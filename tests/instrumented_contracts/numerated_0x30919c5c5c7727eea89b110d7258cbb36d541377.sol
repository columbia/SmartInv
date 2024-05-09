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
58     uint price;
59     token public tokenReward;
60     mapping(address => uint256) public balanceOf;
61     event FundTransfer(address backer, uint amount, bool isContribution);
62 
63     /**
64      * Constrctor function
65      *
66      * Setup the owner
67      */
68     function Crowdsale() {
69         beneficiary = 0xD83A4537f917feFf68088eAB619dC6C529A55ad4;
70         start_time = now;
71         deadline = start_time + 2 * 1 days;    
72         dollar_exchange = 280;
73         tokenReward = token(0x2ca8e1fbcde534c8c71d8f39864395c2ed76fb0e);  //chozun coin address
74     }
75 
76     /**
77      * Fallback function
78     **/
79 
80     function () payable beforeDeadline {
81 
82         tokenBalance = 4930089;
83         uint amount = msg.value;
84         balanceOf[msg.sender] += amount;
85         amountRaised += amount;
86         price = SafeMath.div(0.35 * 1 ether, dollar_exchange);
87         if (amount >= 37.5 ether && amount < 83 ether) {price = SafeMath.div(SafeMath.mul(100, price), 110);} 
88         if (amount >= 87.5 ether && amount < 166 ether) {price = SafeMath.div(SafeMath.mul(100, price), 115);} 
89         if (amount >= 175 ether) {price = SafeMath.div(SafeMath.mul(100, price), 120);}
90         tokenBalance = SafeMath.sub(tokenBalance, SafeMath.div(amount, price));
91         if (tokenBalance < 0 ) { revert(); }
92         tokenReward.transfer(msg.sender, SafeMath.div(amount * 1 ether, price));
93         FundTransfer(msg.sender, amount, true);
94         
95     }
96 
97     modifier afterDeadline() { if (now >= deadline) _; }
98     modifier beforeDeadline() { if (now <= deadline) _; }
99 
100     function safeWithdrawal() afterDeadline {
101 
102         if (beneficiary.send(amountRaised)) {
103             FundTransfer(beneficiary, amountRaised, false);
104             tokenReward.transfer(beneficiary, tokenReward.balanceOf(this));
105             tokenBalance = 0;
106         }
107     }
108 }