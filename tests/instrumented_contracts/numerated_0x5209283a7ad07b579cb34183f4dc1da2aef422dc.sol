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
47 }
48 
49 contract Crowdsale {
50     address public beneficiary;
51     uint public tokenBalance;
52     uint public amountRaised;
53     uint public deadline;
54     uint dollar_exchange;
55     uint test_factor;
56     uint start_time;
57     token public tokenReward;
58     mapping(address => uint256) public balanceOf;
59     event FundTransfer(address backer, uint amount, bool isContribution);
60 
61     /**
62      * Constrctor function
63      *
64      * Setup the owner
65      */
66     function Crowdsale() {
67         tokenBalance = 50000;
68         beneficiary = 0x6519C9A1BF6d69a35C7C87435940B05e9915Ccb3;
69         start_time = now;
70         deadline = start_time + 30 * 1 days;
71         dollar_exchange = 295;
72 
73         tokenReward = token(0x67682915bdfe37a04edcb8888c0f162181e9f400);  //vegan coin address
74     }
75 
76     /**
77      * Fallback function
78     **/
79 
80     function () payable beforeDeadline {
81 
82         uint amount = msg.value;
83         uint price;
84         balanceOf[msg.sender] += amount;
85         amountRaised += amount;
86         if (now <= start_time + 7 days) { price = SafeMath.div(2 * 1 ether, dollar_exchange);}
87         else {price = SafeMath.div(3 * 1 ether, dollar_exchange);}
88         // price = SafeMath.div(price, test_factor); for testing
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
109         }
110     }
111 }