using Discord;
using Discord.Commands;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace discordBot
{
    class Discord_Bot
    {
        //Constructor.
        DiscordClient discord;
        CommandService command;
    
        public Discord_Bot()
        {
            //Initiates Discord Connection. Checks error
            discord = new DiscordClient(x =>
            {
                x.LogLevel = LogSeverity.Info;
                x.LogHandler = Log;
            });

            //Specifies the prefix for bot commands
            discord.UsingCommands(x =>
            {
                x.PrefixChar = '!';
                x.AllowMentionPrefix = true;
            });

            //Enables commands in the chat
            command = discord.GetService<CommandService>();

            //Initiates commands
            showHelp();
            deleteMsg();
            getRedditPost();
            getYoutubeVideo();

            //Logs the bot into the server.
            discord.ExecuteAndWait(async () =>
            {
                await discord.Connect("< >", TokenType.Bot);
            });
        }

        //Displays all commmands and brief information
        private void showHelp()
        {
            command.CreateCommand("help")
                .Do(async (e) =>
                {
                    await e.Channel.SendMessage("!delete - Deletes 25 previous messages.\n" +
                        "!youtube <search entry> - Gets the link to the youtube URL based on the specified search entry.\n" +
                        "!reddit <subreddit name> - Gets the link to the subreddit given the name.");
                });
        }
        
        //Deletes messages in the chat.
        private void deleteMsg()
        {
            command.CreateCommand("delete")
                .Do(async (e) =>
                {
                    Message[] toBeDeleted;
                    toBeDeleted = await e.Channel.DownloadMessages(25);

                    await e.Channel.DeleteMessages(toBeDeleted);
                });
        }

        
        //Posts a reddit page using a parameter for subreddit
        private void getRedditPost()
        {
            command.CreateCommand("reddit")
                .Parameter("Query")
                .Do(async (e) =>
                {
                    await e.Channel.SendMessage($"{e.User.Mention} <https://www.reddit.com/r/{e.GetArg("Query")}>");
                });
        }

        //Gets youtube URL based on search entry of up to 10 words.
        private void getYoutubeVideo()
        {
            //One word query
            command.CreateCommand("youtube")
                .Parameter("Query")
                .Do(async (e) =>
                {
                    string entry = e.GetArg("Query");
                    await e.Channel.SendMessage($"{e.User.Mention} <https://www.youtube.com/results?search_query={entry}>");
                });
            //Two words
            command.CreateCommand("youtube")
                .Parameter("Query")
                .Parameter("Query2")
                .Do(async (e) =>
                {
                    string entry = e.GetArg("Query") + "+" + e.GetArg("Query2");
                    await e.Channel.SendMessage($"{e.User.Mention} <https://www.youtube.com/results?search_query={entry}>");
                });
            //Three words
            command.CreateCommand("youtube")
                .Parameter("Query")
                .Parameter("Query2")
                .Parameter("Query3")
                .Do(async (e) =>
                {
                    string entry = e.GetArg("Query") + "+" + e.GetArg("Query2") + "+" + e.GetArg("Query3");
                    await e.Channel.SendMessage($"{e.User.Mention} <https://www.youtube.com/results?search_query={entry}>");
                });
            //Four words
            command.CreateCommand("youtube")
                .Parameter("Query")
                .Parameter("Query2")
                .Parameter("Query3")
                .Parameter("Query4")
                .Do(async (e) =>
                {
                    string entry = e.GetArg("Query") + "+" + e.GetArg("Query2") + "+" + e.GetArg("Query3") + "+" + e.GetArg("Query4");
                    await e.Channel.SendMessage($"{e.User.Mention} <https://www.youtube.com/results?search_query={entry}>");
                });
            //Five words
            command.CreateCommand("youtube")
                .Parameter("Query")
                .Parameter("Query2")
                .Parameter("Query3")
                .Parameter("Query4")
                .Parameter("Query5")
                .Do(async (e) =>
                {
                    string entry = e.GetArg("Query") + "+" + e.GetArg("Query2") + "+" + e.GetArg("Query3") + "+" + e.GetArg("Query4") + "+" + e.GetArg("Query5");
                    await e.Channel.SendMessage($"{e.User.Mention} <https://www.youtube.com/results?search_query={entry}>");
                });
            //Six words
            command.CreateCommand("youtube")
                .Parameter("Query")
                .Parameter("Query2")
                .Parameter("Query3")
                .Parameter("Query4")
                .Parameter("Query5")
                .Parameter("Query6")
                .Do(async (e) =>
                {
                    string entry = e.GetArg("Query") + "+" + e.GetArg("Query2") + "+" + e.GetArg("Query3") + "+" + e.GetArg("Query4") + "+" + e.GetArg("Query5") + "+" + e.GetArg("Query6");
                    await e.Channel.SendMessage($"{e.User.Mention} <https://www.youtube.com/results?search_query={entry}>");
                });
            //Seven words
            command.CreateCommand("youtube")
                .Parameter("Query")
                .Parameter("Query2")
                .Parameter("Query3")
                .Parameter("Query4")
                .Parameter("Query5")
                .Parameter("Query6")
                .Parameter("Query7")
                .Do(async (e) =>
                {
                    string entry = e.GetArg("Query") + "+" + e.GetArg("Query2") + "+" + e.GetArg("Query3") + "+" + e.GetArg("Query4") + "+" + e.GetArg("Query5") + "+" + e.GetArg("Query6")
                                 + "+" + e.GetArg("Query7");
                    await e.Channel.SendMessage($"{e.User.Mention} <https://www.youtube.com/results?search_query={entry}>");
                });
            //Eight words
            command.CreateCommand("youtube")
                .Parameter("Query")
                .Parameter("Query2")
                .Parameter("Query3")
                .Parameter("Query4")
                .Parameter("Query5")
                .Parameter("Query6")
                .Parameter("Query7")
                .Parameter("Query8")
                .Do(async (e) =>
                {
                    string entry = e.GetArg("Query") + "+" + e.GetArg("Query2") + "+" + e.GetArg("Query3") + "+" + e.GetArg("Query4") + "+" + e.GetArg("Query5") + "+" + e.GetArg("Query6")
                                 + "+" + e.GetArg("Query7") + "+" + e.GetArg("Query8");
                    await e.Channel.SendMessage($"{e.User.Mention} <https://www.youtube.com/results?search_query={entry}>");
                });
            //Nine words
            command.CreateCommand("youtube")
                .Parameter("Query")
                .Parameter("Query2")
                .Parameter("Query3")
                .Parameter("Query4")
                .Parameter("Query5")
                .Parameter("Query6")
                .Parameter("Query7")
                .Parameter("Query8")
                .Parameter("Query9")
                .Do(async (e) =>
                {
                    string entry = e.GetArg("Query") + "+" + e.GetArg("Query2") + "+" + e.GetArg("Query3") + "+" + e.GetArg("Query4") + "+" + e.GetArg("Query5") + "+" + e.GetArg("Query6")
                                 + "+" + e.GetArg("Query7") + "+" + e.GetArg("Query8") + "+" + e.GetArg("Query9");
                    await e.Channel.SendMessage($"{e.User.Mention} <https://www.youtube.com/results?search_query={entry}>");
                });
            //Ten words
            command.CreateCommand("youtube")
                .Parameter("Query")
                .Parameter("Query2")
                .Parameter("Query3")
                .Parameter("Query4")
                .Parameter("Query5")
                .Parameter("Query6")
                .Parameter("Query7")
                .Parameter("Query8")
                .Parameter("Query9")
                .Parameter("Query10")
                .Do(async (e) =>
                {
                    string entry = e.GetArg("Query") + "+" + e.GetArg("Query2") + "+" + e.GetArg("Query3") + "+" + e.GetArg("Query4") + "+" + e.GetArg("Query5") + "+" + e.GetArg("Query6")
                                 + "+" + e.GetArg("Query7") + "+" + e.GetArg("Query8") + "+" + e.GetArg("Query9") + "+" + e.GetArg("Query10");
                    await e.Channel.SendMessage($"{e.User.Mention} <https://www.youtube.com/results?search_query={entry}>");
                });
        }

        //Error check
        private void Log(object sender, LogMessageEventArgs e)
        {
            Console.WriteLine(e.Message);
        }
    }
}
