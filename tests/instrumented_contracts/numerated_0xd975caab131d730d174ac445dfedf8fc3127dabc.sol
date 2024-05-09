1 // Timelock
2 // lock withdrawal for a set time period
3 // @authors:
4 // Cody Burns <dontpanic@codywburns.com>
5 // license: Apache 2.0
6 // version:
7 
8 pragma solidity ^0.4.19;
9 
10 // Intended use: lock withdrawal for a set time period
11 //
12 // Status: functional
13 // still needs:
14 // submit pr and issues to https://github.com/realcodywburns/
15 //version 0.2.0
16 
17 
18 contract timelock {
19 
20 ////////////////
21 //Global VARS//////////////////////////////////////////////////////////////////////////
22 //////////////
23 
24     uint public freezeBlocks = 5;       //number of blocks to keep a lockers (5)
25 
26 ///////////
27 //MAPPING/////////////////////////////////////////////////////////////////////////////
28 ///////////
29 
30     struct locker{
31       uint freedom;
32       uint bal;
33     }
34     mapping (address => locker) public lockers;
35 
36 ///////////
37 //EVENTS////////////////////////////////////////////////////////////////////////////
38 //////////
39 
40     event Locked(address indexed locker, uint indexed amount);
41     event Released(address indexed locker, uint indexed amount);
42 
43 /////////////
44 //MODIFIERS////////////////////////////////////////////////////////////////////
45 ////////////
46 
47 //////////////
48 //Operations////////////////////////////////////////////////////////////////////////
49 //////////////
50 
51 /* public functions */
52     function() payable public {
53         locker storage l = lockers[msg.sender];
54         l.freedom =  block.number + freezeBlocks; //this will reset the freedom clock
55         l.bal = l.bal + msg.value;
56 
57         Locked(msg.sender, msg.value);
58     }
59 
60     function withdraw() public {
61         locker storage l = lockers[msg.sender];
62         require (block.number > l.freedom && l.bal > 0);
63 
64         // avoid recursive call
65 
66         uint value = l.bal;
67         l.bal = 0;
68         msg.sender.transfer(value);
69         Released(msg.sender, value);
70     }
71 
72 ////////////
73 //OUTPUTS///////////////////////////////////////////////////////////////////////
74 //////////
75 
76 ////////////
77 //SAFETY ////////////////////////////////////////////////////////////////////
78 //////////
79 
80 
81 }