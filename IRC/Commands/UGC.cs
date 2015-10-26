﻿/*
 * Copyright (c) 2013-2015, SteamDB. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

using System;
using SteamKit2;

namespace SteamDatabaseBackend
{
    class UGCCommand : Command
    {
        private readonly SteamCloud Cloud;

        public UGCCommand()
        {
            Trigger = "ugc";
            IsSteamCommand = true;

            Cloud = Steam.Instance.Client.GetHandler<SteamCloud>();
        }

        public override async void OnCommand(CommandArguments command)
        {
            if (command.Message.Length == 0)
            {
                CommandHandler.ReplyToCommand(command, "Usage:{0} ugc <ugcid>", Colors.OLIVE);

                return;
            }

            ulong ugcId;

            if (!ulong.TryParse(command.Message, out ugcId))
            {
                CommandHandler.ReplyToCommand(command, "Invalid UGC ID");

                return;
            }

            var callback = await Cloud.RequestUGCDetails(ugcId);

            if (callback.Result != EResult.OK)
            {
                CommandHandler.ReplyToCommand(command, "Unable to request UGC info: {0}{1}", Colors.RED, callback.Result);

                return;
            }

            CommandHandler.ReplyToCommand(command, "Creator: {0}{1}{2}, App: {3}{4}{5}, File: {6}{7}{8}, Size: {9}{10}{11} -{12} {13}",
                Colors.BLUE, callback.Creator.Render(true), Colors.NORMAL,
                Colors.BLUE, callback.AppID, Colors.NORMAL,
                Colors.BLUE, callback.FileName, Colors.NORMAL,
                Colors.BLUE, GetByteSizeString(callback.FileSize), Colors.NORMAL,
                Colors.DARKBLUE, callback.URL
            );
        }

        private static string GetByteSizeString(uint size)
        {
            string[] suf = { "B", "KB", "MB", "GB" };

            if (size == 0)
            {
                return "0B";
            }

            int place = Convert.ToInt32(Math.Floor(Math.Log(size, 1024)));
            double num = Math.Round(size / Math.Pow(1024, place), 1);
            return (Math.Sign(size) * num) + suf[place];
        }
    }
}
