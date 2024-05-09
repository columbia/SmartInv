1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal returns (uint) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 }
44 
45 interface token {
46     function transfer(address receiver, uint amount);
47     function balanceOf(address) returns (uint256);
48 }
49 
50 contract Crowdsale {
51     address public beneficiary;
52     uint public tokenBalance;
53     uint public amountRaised;
54     uint public deadline;
55     uint dollar_exchange;
56     uint test_factor;
57     uint start_time;
58     token public tokenReward;
59     mapping(address => uint256) public balanceOf;
60     event FundTransfer(address backer, uint amount, bool isContribution);
61 
62     /**
63      * Constrctor function
64      *
65      * Setup the owner
66      */
67     function Crowdsale() {
68         tokenBalance = 49893;
69         beneficiary = 0x6519C9A1BF6d69a35C7C87435940B05e9915Ccb3;
70         start_time = now;
71         deadline = start_time + 30 * 1 days;
72         dollar_exchange = 475;
73 
74         tokenReward = token(0xb957B54c347342893b7d79abE2AaF543F7598531);  //vegan coin address
75     }
76 
77     /**
78      * Fallback function
79     **/
80 
81     function () payable beforeDeadline {
82 
83         uint amount = msg.value;
84         uint price;
85         balanceOf[msg.sender] += amount;
86         amountRaised += amount;
87         if (now <= start_time + 7 days) { price = SafeMath.div(2 * 1 ether, dollar_exchange);}
88         else {price = SafeMath.div(3 * 1 ether, dollar_exchange);}
89         tokenBalance = SafeMath.sub(tokenBalance, SafeMath.div(amount, price));
90         if (tokenBalance < 0 ) { revert(); }
91         tokenReward.transfer(msg.sender, SafeMath.div(amount * 1 ether, price));
92         FundTransfer(msg.sender, amount, true);
93         
94     }
95 
96     modifier afterDeadline() { if (now >= deadline) _; }
97     modifier beforeDeadline() { if (now <= deadline) _; }
98 
99     /**
100      * Check if goal was reached
101      *
102      * Checks if the goal or time limit has been reached and ends the campaign
103      */
104 
105     function safeWithdrawal() afterDeadline {
106 
107         if (beneficiary.send(amountRaised)) {
108             FundTransfer(beneficiary, amountRaised, false);
109             tokenReward.transfer(beneficiary, tokenReward.balanceOf(this));
110             tokenBalance = 0;
111         }
112     }
113 }