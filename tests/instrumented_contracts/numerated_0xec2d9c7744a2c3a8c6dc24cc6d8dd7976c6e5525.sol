1 /**
2  * Copyright 2017 Icofunding S.L. (https://icofunding.com)
3  * 
4  */
5 
6 /**
7  * Math operations with safety checks
8  * Reference: https://github.com/OpenZeppelin/zeppelin-solidity/commit/353285e5d96477b4abb86f7cde9187e84ed251ac
9  */
10 contract SafeMath {
11   function safeMul(uint a, uint b) internal constant returns (uint) {
12     uint c = a * b;
13 
14     assert(a == 0 || c / a == b);
15 
16     return c;
17   }
18 
19   function safeDiv(uint a, uint b) internal constant returns (uint) {    
20     uint c = a / b;
21 
22     return c;
23   }
24 
25   function safeSub(uint a, uint b) internal constant returns (uint) {
26     require(b <= a);
27 
28     return a - b;
29   }
30 
31   function safeAdd(uint a, uint b) internal constant returns (uint) {
32     uint c = a + b;
33 
34     assert(c>=a && c>=b);
35 
36     return c;
37   }
38 }
39 
40 contract EtherReceiverInterface {
41   function receiveEther() public payable;
42 }
43 
44 /**
45  * Escrow contract to manage the funds collected
46  */
47 contract Escrow is SafeMath, EtherReceiverInterface {
48   // Sample thresholds.
49   uint[3] threshold = [0 ether, 21008 ether, 1000000 ether];
50   // Different rates for each phase.
51   uint[2] rate = [4, 1];
52 
53   // Adresses that will receive funds
54   address public project;
55   address public icofunding;
56 
57   // Block from when the funds will be released
58   uint public lockUntil;
59 
60   // Wei
61   uint public totalCollected; // total amount of wei collected
62 
63   modifier locked() {
64     require(block.number >= lockUntil);
65 
66     _;
67   }
68 
69   event e_Withdraw(uint block, uint fee, uint amount);
70 
71   function Escrow(uint _lockUntil, address _icofunding, address _project) {
72     lockUntil = _lockUntil;
73     icofunding = _icofunding;
74     project = _project;
75   }
76 
77   // Sends the funds collected to the addresses "icofunding" and "project"
78   // The ether is distributed following the formula below
79   // Only exeuted after "lockUntil"
80   function withdraw() public locked {
81     // Calculates the amount to send to each address
82     uint fee = getFee(this.balance);
83     uint amount = safeSub(this.balance, fee);
84 
85     // Sends the ether
86     icofunding.transfer(fee);
87     project.transfer(amount);
88 
89     e_Withdraw(block.number, fee, amount);
90   }
91 
92   // Calculates the variable fees depending on the amount, thresholds and rates set.
93   function getFee(uint value) public constant returns (uint) {
94     uint fee;
95     uint slice;
96     uint aux;
97 
98     for(uint i = 0; i < 2; i++) {
99       aux = value;
100       if(value > threshold[i+1])
101         aux = threshold[i+1];
102 
103       if(threshold[i] < aux) {
104         slice = safeSub(aux, threshold[i]);
105 
106         fee = safeAdd(fee, safeDiv(safeMul(slice, rate[i]), 100));
107       }
108     }
109 
110     return fee;
111   }
112 
113   function receiveEther() public payable {
114     totalCollected += msg.value;
115   }
116 
117   function() payable {
118     totalCollected += msg.value;
119   }
120 }