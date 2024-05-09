1 pragma solidity ^0.4.8;
2 contract Switch 
3 {
4     bool public state=false;
5     uint256 public blinc_block;
6     uint256 public on_block;
7     address public owner;
8 
9     function Switch(){
10         owner=msg.sender;
11         on_block==block.number;
12         blinc_block=block.number;
13     }
14     function blinc() payable {
15         if(msg.value>0)blinc_block=block.number;
16     }
17     function () payable {
18         if(msg.value>0)on_block=block.number;
19     }
20     function kill() {
21     if (msg.sender==owner) selfdestruct(owner);
22     }
23 }