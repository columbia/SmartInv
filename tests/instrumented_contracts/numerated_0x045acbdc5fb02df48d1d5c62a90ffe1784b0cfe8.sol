1 pragma solidity ^0.4.20;
2 contract MessagingContract {
3     struct Message {
4         string data;
5         string senderName;
6     }
7     struct Feed {
8         Message[] messages;
9         string name;
10     }
11     event FeedCreated(uint256 feedId,string feedName);
12     event MessageSent(uint256 feedId, uint256 msgId,string msg,string sender);
13     Feed[] feeds;
14     /// Create a new ballot with $(_numProposals) different proposals.
15     function MessagingContract(string firstFeedName) public {
16         newFeed(firstFeedName);
17     }
18     function newFeed(string name) public returns (uint256){
19         feeds[feeds.length++].name=name;
20         FeedCreated(feeds.length-1,name);
21         return feeds.length-1;
22     }
23     function feedMessage(uint256 feedId,string data,string alias) public{
24         feeds[feedId].messages[feeds[feedId].messages.length++]=Message(data,alias);
25         MessageSent(feedId,feeds[feedId].messages.length-1,data,alias);
26     }
27 }