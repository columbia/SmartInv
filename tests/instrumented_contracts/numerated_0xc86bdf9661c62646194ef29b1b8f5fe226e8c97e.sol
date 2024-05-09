1 pragma solidity ^0.4.13;
2 
3 contract EtherShare {
4     
5     uint public count;
6     address[] public link; // if there are other EtherShare contracts
7 
8     struct oneShare {
9         address sender;
10         string nickname;
11         uint timestamp;
12         bool AllowUpdated;
13         string content;
14     }
15     mapping(uint => oneShare[]) public allShare;
16 
17     event EVENT(uint ShareID, uint ReplyID);
18 
19     function EtherShare() public {
20         NewShare("Peilin Zheng", false, "Hello, EtherShare!");  // zhengpeilin.com
21     }
22 
23     function NewShare(string nickname, bool AllowUpdated, string content) public {
24         allShare[count].push(oneShare(msg.sender, nickname, now, AllowUpdated, content)); // add a new share
25         EVENT(count,0);
26         count++;
27     }
28 
29     function ReplyShare(uint ShareID, string nickname, bool AllowUpdated, string content) public {
30         require(ShareID<count); // reply to a existed share
31         allShare[ShareID].push(oneShare(msg.sender, nickname, now, AllowUpdated, content));
32         EVENT(ShareID,allShare[ShareID].length-1);
33     }
34 
35     function Update(uint ShareID, uint ReplyID, string content) public {
36         require(msg.sender==allShare[ShareID][ReplyID].sender && allShare[ShareID][ReplyID].AllowUpdated);  // only sender can update the share or reply which is AllowUpdated
37         allShare[ShareID][ReplyID].content = content;
38         allShare[ShareID][ReplyID].timestamp = now;
39         EVENT(ShareID,ReplyID);
40     }
41 }