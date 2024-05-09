1 pragma solidity ^0.4.10;
2 
3 contract EtherGame 
4 {
5     uint[] a;
6     function Test1(uint a) public returns(address)
7     {
8         return msg.sender;
9     }
10     function Test2(uint a) returns(address)
11     {
12         return msg.sender;
13     }
14     function Test3(uint b) public returns(uint)
15     {
16         return a.length;
17     }
18     function Test4(uint b) returns(uint)
19     {
20         return a.length;
21     }
22     function Kill(uint a)
23     {
24         selfdestruct(msg.sender);
25     }
26 }