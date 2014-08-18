﻿/*
 * Copyright (c) 2013-2015, SteamDB. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
using System;
using System.Collections.Generic;
using System.Linq;
using MySql.Data.MySqlClient;

namespace SteamDatabaseBackend
{
    class AppCommand : Command
    {
        public AppCommand()
        {
            Trigger = "!app";
            IsSteamCommand = true;
        }

        public override void OnCommand(CommandArguments command)
        {
            if (command.Message.Length == 0)
            {
                CommandHandler.ReplyToCommand(command, "Usage:{0} !app <appid or partial game name>", Colors.OLIVE);

                return;
            }

            uint appID;

            if (uint.TryParse(command.Message, out appID))
            {
                var apps = new List<uint>();

                apps.Add(appID);

                JobManager.AddJob(() => Steam.Instance.Apps.PICSGetAccessTokens(apps, Enumerable.Empty<uint>()), new JobManager.IRCRequest
                {
                    Target = appID,
                    Type = JobManager.IRCRequestType.TYPE_APP,
                    Command = command
                });

                return;
            }

            string name = string.Format("%{0}%", command.Message);

            using (MySqlDataReader Reader = DbWorker.ExecuteReader("SELECT `AppID` FROM `Apps` WHERE `Apps`.`StoreName` LIKE @Name OR `Apps`.`Name` LIKE @Name ORDER BY `LastUpdated` DESC LIMIT 1", new MySqlParameter("Name", name)))
            {
                if (Reader.Read())
                {
                    appID = Reader.GetUInt32("AppID");

                    var apps = new List<uint>();

                    apps.Add(appID);

                    JobManager.AddJob(() => Steam.Instance.Apps.PICSGetAccessTokens(apps, Enumerable.Empty<uint>()), new JobManager.IRCRequest
                    {
                        Target = appID,
                        Type = JobManager.IRCRequestType.TYPE_APP,
                        Command = command
                    });

                    return;
                }
            }

            CommandHandler.ReplyToCommand(command, "Nothing was found matching your request.");
        }
    }
}