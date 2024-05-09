1 pragma solidity ^0.4.10;
2 
3 contract EtherGame 
4 {
5     uint[] a;
6     function Test1(uint a) public constant returns(address)
7     {
8         return msg.sender;
9     }
10     function Test2(uint a) constant returns(address)
11     {
12         return msg.sender;
13     }
14     function Test3(uint b) public constant returns(uint)
15     {
16         return a.length;
17     }
18     function Test4(uint b) constant returns(uint)
19     {
20         return a.length;
21     }
22     function Test5(uint b) external constant returns(uint)
23     {
24         return a.length;
25     }
26     function Test6() constant returns(uint)
27     {
28         return a.length;
29     }
30     function Kill(uint a)
31     {
32         selfdestruct(msg.sender);
33     }
34 }