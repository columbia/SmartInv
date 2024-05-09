1 pragma solidity ^0.4.8;
2 contract Switch 
3 {
4     uint256 public blink_block;
5     uint256 public on_block;
6     address public owner;
7 
8     function Switch(){
9         owner=msg.sender;
10         on_block=block.number;
11         blink_block=block.number;
12     }
13     function blink() payable {
14         if(msg.value>0)blink_block=block.number;
15     }
16     function () payable {
17         if(msg.value>0)on_block=block.number;
18     }
19     function kill() {
20     if (msg.sender==owner) selfdestruct(owner);
21     }
22 }