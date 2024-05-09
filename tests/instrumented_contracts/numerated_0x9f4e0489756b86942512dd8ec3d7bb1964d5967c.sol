1 pragma solidity ^0.4.20;
2 
3 contract olty_6 {
4 
5 event test_value(uint256 indexed value1);
6 
7 address public owner;
8 
9 // variables to store who needs to get what %
10 address public charity;
11 address public dividend;
12 address public maintain;
13 address public fuel;
14 address public winner;
15 
16 // each ticket is 0.002 ether
17 uint constant uprice = 0.002 ether;
18 
19 mapping (address => uint) public ownershipDistribute;
20 mapping (address => uint) public tickets;
21 
22 
23 // constructor function
24 function olty_6() {
25     owner = msg.sender;
26     
27     charity = 0x889cbf08666fa94B2E74Dc6645059A60E25f9079;
28     dividend = 0xD942E1F5f0fACD4540896843087E1e937A399828;
29     maintain = 0x0e0146235236FC9E3f700991193E189f63eC4c32;
30     fuel = 0x7aC1BC1E05Fc374e287Df5537fd03e5ef40b7333;
31     winner = 0x6b730f4D92e236D0eC22b2baFf26873F297d7e67;
32     
33     ownershipDistribute[charity] = 5;
34     ownershipDistribute[dividend] =10;
35     ownershipDistribute[maintain] = 15;
36     ownershipDistribute[fuel] = 5;
37     ownershipDistribute[winner] = 65;    
38 }
39 
40 
41 function() payable {
42     buyTickets(1);
43 }
44 
45 function buyTickets(uint no_tickets) payable {
46     tickets[msg.sender] += no_tickets;
47 }
48 
49 function distribute(uint winner_select, uint winning_no, address win, uint promo)
50      returns(bool success) {
51          
52     uint bal = this.balance;
53     
54     if (promo != 1) {
55     if (msg.sender == owner) {
56     charity.transfer(bal * ownershipDistribute[charity] / 100);
57     fuel.transfer(bal * ownershipDistribute[fuel] / 100);    
58     dividend.transfer(bal * ownershipDistribute[dividend] / 100);
59     maintain.transfer(bal * ownershipDistribute[maintain] / 100);
60     if (winner_select == 1) {
61         winner.transfer(bal * ownershipDistribute[winner] / 100);
62     } else if (winner_select == 2) {
63         winner.transfer(bal * ownershipDistribute[winner] / 100);
64     } else {
65         // do nothing
66         test_value(999);
67     }
68         } else {
69     throw;
70     } // else statement
71     return true;
72     }   
73     
74     if (promo == 1) {
75     if (msg.sender == owner) {
76     charity.transfer(bal * ownershipDistribute[charity] / 100);
77     fuel.transfer(bal * ownershipDistribute[fuel] / 100);    
78     dividend.transfer(bal * ownershipDistribute[dividend] / 100);
79 
80     if (winner_select == 1) {
81         winner.transfer(bal * 80 / 100);
82     } else if (winner_select == 2) {
83         winner.transfer(bal * 80 / 100);
84     } else {
85         // do nothing
86         test_value(999);
87     }
88         } else {
89     throw;
90     } // else statement
91     return true;
92     }       
93     
94 }  // function distribute
95 
96 }  // contract olty_6