1 pragma solidity ^0.5.11;
2 
3 contract AlephSync{
4 
5     event SyncEvent(uint256 timestamp, address addr, string message); 
6     event MessageEvent(uint256 timestamp, address addr, string msgtype, string msgcontent); 
7     
8     function doEmit(string memory message) public {
9         emit SyncEvent(block.timestamp, msg.sender, message);
10     }
11     
12     function doMessage(string memory msgtype, string memory msgcontent) public {
13         emit MessageEvent(block.timestamp, msg.sender, msgtype, msgcontent);
14     }
15 
16 }