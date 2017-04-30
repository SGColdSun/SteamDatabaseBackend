﻿/*
 * Copyright (c) 2013-2015, SteamDB. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Dapper;
using SteamKit2;

namespace SteamDatabaseBackend
{
    class AppProcessor : IDisposable
    {
        private static readonly string[] Triggers =
        {
            "Valve",
            "Steam",
            "Half-Life",
            "Left 4 Dead",
            "Counter-Strike",
            "Dota",
            "Day of Defeat",
            "Team Fortress"
        };

        private IDbConnection DbConnection;

        private readonly Dictionary<string, PICSInfo> CurrentData;
        private uint ChangeNumber;
        private readonly uint AppID;

        public AppProcessor(uint appID)
        {
            AppID = appID;

            DbConnection = Database.GetConnection();

            CurrentData = DbConnection.Query<PICSInfo>("SELECT `Name` as `KeyName`, `Value`, `KeyID` FROM `AppsInfo` INNER JOIN `KeyNames` ON `AppsInfo`.`KeyID` = `KeyNames`.`ID` WHERE `AppID` = @AppID", new { AppID }).ToDictionary(x => x.KeyName, x => x);
        }

        public void Dispose()
        {
            if (DbConnection != null)
            {
                DbConnection.Dispose();
                DbConnection = null;
            }
        }

        public void Process(SteamApps.PICSProductInfoCallback.PICSProductInfo productInfo)
        {
            ChangeNumber = productInfo.ChangeNumber;

            if (Settings.IsFullRun)
            {
                Log.WriteDebug("App Processor", "AppID: {0}", AppID);

                DbConnection.Execute("INSERT INTO `Changelists` (`ChangeID`) VALUES (@ChangeNumber) ON DUPLICATE KEY UPDATE `Date` = `Date`", new { productInfo.ChangeNumber });
                DbConnection.Execute("INSERT INTO `ChangelistsApps` (`ChangeID`, `AppID`) VALUES (@ChangeNumber, @AppID) ON DUPLICATE KEY UPDATE `AppID` = `AppID`", new { AppID, productInfo.ChangeNumber });
            }

            ProcessKey("root_changenumber", "changenumber", ChangeNumber.ToString());

            var app = DbConnection.Query<App>("SELECT `Name`, `AppType` FROM `Apps` WHERE `AppID` = @AppID LIMIT 1", new { AppID }).SingleOrDefault();

            var newAppName = productInfo.KeyValues["common"]["name"].AsString();

            if (newAppName != null)
            {
                int newAppType = -1;
                string currentType = productInfo.KeyValues["common"]["type"].AsString().ToLower();

                using (var reader = DbConnection.ExecuteReader("SELECT `AppType` FROM `AppsTypes` WHERE `Name` = @Type LIMIT 1", new { Type = currentType }))
                {
                    if (reader.Read())
                    {
                        newAppType = reader.GetInt32(reader.GetOrdinal("AppType"));
                    }
                }

                if (newAppType == -1)
                {
                    DbConnection.Execute("INSERT INTO `AppsTypes` (`Name`, `DisplayName`) VALUES(@Name, @DisplayName)",
                        new { Name = currentType, DisplayName = productInfo.KeyValues["common"]["type"].AsString() }); // We don't need to lower display name

                    Log.WriteInfo("App Processor", "Creating new apptype \"{0}\" (AppID {1})", currentType, AppID);

                    IRC.Instance.SendOps("New app type: {0}{1}{2} - {3}", Colors.BLUE, currentType, Colors.NORMAL, SteamDB.GetAppURL(AppID, "history"));

                    newAppType = DbConnection.ExecuteScalar<int>("SELECT `AppType` FROM `AppsTypes` WHERE `Name` = @Type LIMIT 1", new { Type = currentType });
                }

                if (string.IsNullOrEmpty(app.Name) || app.Name.StartsWith(SteamDB.UNKNOWN_APP, StringComparison.Ordinal))
                {
                    DbConnection.Execute("INSERT INTO `Apps` (`AppID`, `AppType`, `Name`, `LastKnownName`) VALUES (@AppID, @Type, @AppName, @AppName) ON DUPLICATE KEY UPDATE `Name` = VALUES(`Name`), `LastKnownName` = VALUES(`LastKnownName`), `AppType` = VALUES(`AppType`)",
                        new { AppID, Type = newAppType, AppName = newAppName }
                    );

                    MakeHistory("created_app");
                    MakeHistory("created_info", SteamDB.DATABASE_NAME_TYPE, string.Empty, newAppName);

                    // TODO: Testy testy
                    if (!Settings.IsFullRun && Settings.Current.ChatRooms.Count > 0)
                    {
                        Steam.Instance.Friends.SendChatRoomMessage(Settings.Current.ChatRooms[0], EChatEntryType.ChatMsg,
                            string.Format(
                                "New {0} was published: {1}\nSteamDB: {2}\nSteam: https://store.steampowered.com/app/{3}/",
                                currentType,
                                newAppName,
                                SteamDB.GetAppURL(AppID),
                                AppID
                            )
                        );
                    }

                    if ((newAppType > 9 && newAppType != 13 && newAppType != 17) || Triggers.Any(newAppName.Contains))
                    {
                        IRC.Instance.SendOps("New {0}: {1}{2}{3} -{4} {5}",
                            currentType,
                            Colors.BLUE, newAppName, Colors.NORMAL,
                            Colors.DARKBLUE, SteamDB.GetAppURL(AppID, "history"));
                    }
                }
                else if (!app.Name.Equals(newAppName))
                {
                    DbConnection.Execute("UPDATE `Apps` SET `Name` = @AppName, `LastKnownName` = @AppName WHERE `AppID` = @AppID", new { AppID, AppName = newAppName });

                    MakeHistory("modified_info", SteamDB.DATABASE_NAME_TYPE, app.Name, newAppName);
                }

                if (app.AppType == 0 || app.AppType != newAppType)
                {
                    DbConnection.Execute("UPDATE `Apps` SET `AppType` = @Type WHERE `AppID` = @AppID", new { AppID, Type = newAppType });

                    if (app.AppType == 0)
                    {
                        MakeHistory("created_info", SteamDB.DATABASE_APPTYPE, string.Empty, newAppType.ToString());
                    }
                    else
                    {
                        MakeHistory("modified_info", SteamDB.DATABASE_APPTYPE, app.AppType.ToString(), newAppType.ToString());
                    }
                }
            }

            foreach (var section in productInfo.KeyValues.Children)
            {
                string sectionName = section.Name.ToLower();

                if (sectionName == "appid" || sectionName == "public_only" || sectionName == "change_number")
                {
                    continue;
                }

                if (sectionName == "common" || sectionName == "extended")
                {
                    foreach (var keyvalue in section.Children)
                    {
                        var keyName = string.Format("{0}_{1}", sectionName, keyvalue.Name);

                        if (keyName.Equals("common_type") || keyName.Equals("common_gameid") || keyName.Equals("common_name") || keyName.Equals("extended_order"))
                        {
                            // Ignore common keys that are either duplicated or serve no real purpose
                            continue;
                        }

                        if (keyvalue.Children.Count > 0)
                        {
                            ProcessKey(keyName, keyvalue.Name, Utils.JsonifyKeyValue(keyvalue), true);
                        }
                        else if (!string.IsNullOrEmpty(keyvalue.Value))
                        {
                            ProcessKey(keyName, keyvalue.Name, keyvalue.Value);
                        }
                    }
                }
                else
                {
                    sectionName = string.Format("root_{0}", sectionName);

                    if (ProcessKey(sectionName, sectionName, Utils.JsonifyKeyValue(section), true) && sectionName.Equals("root_depots"))
                    {
                        DbConnection.Execute("UPDATE `Apps` SET `LastDepotUpdate` = unix_timestamp() WHERE `AppID` = @AppID", new { AppID });
                    }
                }
            }

            foreach (var data in CurrentData.Values.Where(data => !data.Processed && !data.KeyName.StartsWith("website", StringComparison.Ordinal)))
            {
                DbConnection.Execute("DELETE FROM `AppsInfo` WHERE `AppID` = @AppID AND `KeyID` = @Key", new { AppID, data.Key });

                MakeHistory("removed_key", data.Key, data.Value);

                if (newAppName != null && data.KeyName.Equals("common_section_type") && data.Value.Equals("ownersonly"))
                {
                    IRC.Instance.SendMain("Removed ownersonly from: {0}{1}{2} -{3} {4}", Colors.BLUE, app.Name, Colors.NORMAL, Colors.DARKBLUE, SteamDB.GetAppURL(AppID, "history"));
                }
            }

            if (newAppName == null)
            {
                if (string.IsNullOrEmpty(app.Name)) // We don't have the app in our database yet
                {
                    DbConnection.Execute("INSERT INTO `Apps` (`AppID`, `Name`) VALUES (@AppID, @AppName) ON DUPLICATE KEY UPDATE `AppType` = `AppType`", new { AppID, AppName = string.Format("{0} {1}", SteamDB.UNKNOWN_APP, AppID) });
                }
                else if (!app.Name.StartsWith(SteamDB.UNKNOWN_APP, StringComparison.Ordinal)) // We do have the app, replace it with default name
                {
                    IRC.Instance.SendMain("App deleted: {0}{1}{2} -{3} {4}", Colors.BLUE, app.Name, Colors.NORMAL, Colors.DARKBLUE, SteamDB.GetAppURL(AppID, "history"));

                    DbConnection.Execute("UPDATE `Apps` SET `Name` = @AppName, `AppType` = 0 WHERE `AppID` = @AppID", new { AppID, AppName = string.Format("{0} {1}", SteamDB.UNKNOWN_APP, AppID) });

                    MakeHistory("deleted_app", 0, app.Name);
                }
            }

            if (productInfo.KeyValues["depots"] != null)
            {
                Steam.Instance.DepotProcessor.Process(AppID, ChangeNumber, productInfo.KeyValues["depots"]);
            }
        }

        public void ProcessUnknown()
        {
            Log.WriteInfo("App Processor", "Unknown AppID: {0}", AppID);

            var name = DbConnection.ExecuteScalar<string>("SELECT `Name` FROM `Apps` WHERE `AppID` = @AppID LIMIT 1", new { AppID });

            var data = CurrentData.Values.Where(x => !x.KeyName.StartsWith("website", StringComparison.Ordinal)).ToList();

            if (data.Any())
            {
                DbConnection.Execute(GetHistoryQuery(), data.Select(x => new PICSHistory
                {
                    ID       = AppID,
                    ChangeID = ChangeNumber,
                    Key      = x.Key,
                    OldValue = x.Value,
                    Action   = "removed_key"
                }));
            }

            if (!string.IsNullOrEmpty(name) && !name.StartsWith(SteamDB.UNKNOWN_APP, StringComparison.Ordinal))
            {
                DbConnection.Execute(GetHistoryQuery(), new PICSHistory
                {
                    ID       = AppID,
                    ChangeID = ChangeNumber,
                    OldValue = name,
                    Action   = "deleted_app"
                });
            }

            DbConnection.Execute("DELETE FROM `Apps` WHERE `AppID` = @AppID", new { AppID });
            DbConnection.Execute("DELETE FROM `AppsInfo` WHERE `AppID` = @AppID", new { AppID });
            DbConnection.Execute("DELETE FROM `Store` WHERE `AppID` = @AppID", new { AppID });
        }

        private bool ProcessKey(string keyName, string displayName, string value, bool isJSON = false)
        {
            if (keyName.Length > 90)
            {
                Log.WriteError("App Processor", "Key {0} for AppID {1} is too long, not inserting info.", keyName, AppID);

                return false;
            }

            // All keys in PICS are supposed to be lower case
            keyName = keyName.ToLower().Trim();

            if (!CurrentData.ContainsKey(keyName))
            {
                uint key = GetKeyNameID(keyName);

                if (key == 0)
                {
                    var type = isJSON ? 86 : 0; // 86 is a hardcoded const for the website

                    DbConnection.Execute("INSERT INTO `KeyNames` (`Name`, `Type`, `DisplayName`) VALUES(@Name, @Type, @DisplayName)", new { Name = keyName, DisplayName = displayName, Type = type });

                    key = GetKeyNameID(keyName);

                    if (key == 0)
                    {
                        // We can't insert anything because key wasn't created
                        Log.WriteError("App Processor", "Failed to create key {0} for AppID {1}, not inserting info.", keyName, AppID);

                        return false;
                    }

                    IRC.Instance.SendOps("New app keyname: {0}{1} {2}(ID: {3}) ({4}) - {5}", Colors.BLUE, keyName, Colors.LIGHTGRAY, key, displayName, SteamDB.GetAppURL(AppID, "history"));
                }

                DbConnection.Execute("INSERT INTO `AppsInfo` (`AppID`, `KeyID`, `Value`) VALUES (@AppID, @Key, @Value)", new { AppID, Key = key, Value = value });
                MakeHistory("created_key", key, string.Empty, value);

                if ((keyName == "extended_developer" || keyName == "extended_publisher") && value == "Valve")
                {
                    IRC.Instance.SendOps("New {0}=Valve app: {1}{2}{3} -{4} {5}",
                        displayName,
                        Colors.BLUE, Steam.GetAppName(AppID), Colors.NORMAL,
                        Colors.DARKBLUE, SteamDB.GetAppURL(AppID, "history"));
                }

                if (keyName == "common_oslist" && value.Contains("linux"))
                {
                    PrintLinux();
                }

                return true;
            }

            var data = CurrentData[keyName];

            if (data.Processed)
            {
                Log.WriteWarn("App Processor", "Duplicate key {0} in AppID {1}", keyName, AppID);

                return false;
            }

            data.Processed = true;

            CurrentData[keyName] = data;

            if (!data.Value.Equals(value))
            {
                DbConnection.Execute("UPDATE `AppsInfo` SET `Value` = @Value WHERE `AppID` = @AppID AND `KeyID` = @Key", new { AppID, Key = data.Key, Value = value });
                MakeHistory("modified_key", data.Key, data.Value, value);

                if (keyName == "common_oslist" && value.Contains("linux") && !data.Value.Contains("linux"))
                {
                    PrintLinux();
                }

                return true;
            }

            return false;
        }

        public static string GetHistoryQuery()
        {
            return "INSERT INTO `AppsHistory` (`ChangeID`, `AppID`, `Action`, `Key`, `OldValue`, `NewValue`) VALUES (@ChangeID, @ID, @Action, @Key, @OldValue, @NewValue)";
        }

        private void MakeHistory(string action, uint keyNameID = 0, string oldValue = "", string newValue = "")
        {
            DbConnection.Execute(GetHistoryQuery(),
                new PICSHistory
                {
                    ID       = AppID,
                    ChangeID = ChangeNumber,
                    Key      = keyNameID,
                    OldValue = oldValue,
                    NewValue = newValue,
                    Action   = action
                }
            );
        }

        private uint GetKeyNameID(string keyName)
        {
            return DbConnection.ExecuteScalar<uint>("SELECT `ID` FROM `KeyNames` WHERE `Name` = @keyName", new { keyName });
        }

        private void PrintLinux()
        {
            string appType;
            var name = Steam.GetAppName(AppID, out appType);

            if (appType != "Game" && appType != "Application")
            {
                return;
            }

            IRC.Instance.SendSteamLUG(string.Format(
                "[oslist][{0}] {1} now lists Linux{2} - {3} - https://store.steampowered.com/app/{4}/",
                appType, name, LinkExpander.GetFormattedPrices(AppID), SteamDB.GetAppURL(AppID, "history"), AppID
            ));
        }
    }
}
