1 /**
2 *	Crowdsale for Edgeless Tokens.
3 *	Raised Ether will be stored safely at a multisignature wallet and returned to the ICO in case the funding goal is not reached,
4 *   allowing the investors to withdraw their funds.
5 *	Author: Julia Altenried
6 **/
7 
8 pragma solidity ^0.4.6;
9 
10 contract token {
11 	function transferFrom(address sender, address receiver, uint amount) returns(bool success){}
12 	function burn() {}
13 }
14 
15 contract SafeMath {
16   //internals
17 
18   function safeMul(uint a, uint b) internal returns (uint) {
19     uint c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function safeSub(uint a, uint b) internal returns (uint) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function safeAdd(uint a, uint b) internal returns (uint) {
30     uint c = a + b;
31     assert(c>=a && c>=b);
32     return c;
33   }
34 
35   function assert(bool assertion) internal {
36     if (!assertion) throw;
37   }
38 }
39 
40 
41 contract Crowdsale is SafeMath {
42     /* tokens will be transfered from this address */
43 	address public beneficiary = 0x003230bbe64eccd66f62913679c8966cf9f41166;
44 	/* if the funding goal is not reached, investors may withdraw their funds */
45 	uint public fundingGoal = 50000000;
46 	/* the maximum amount of tokens to be sold */
47 	uint public maxGoal = 440000000;
48 	/* how much has been raised by crowdale (in ETH) */
49 	uint public amountRaised;
50 	/* the start date of the crowdsale */
51 	uint public start = 1488294000;
52 	/* the number of tokens already sold */
53 	uint public tokensSold;
54 	/* there are different prices in different time intervals */
55 	uint[4] public deadlines = [1488297600, 1488902400, 1489507200,1490112000];
56 	uint[4] public prices = [833333333333333, 909090909090909,952380952380952, 1000000000000000];
57 	/* the address of the token contract */
58 	token public tokenReward;
59 	/* the balances (in ETH) of all investors */
60 	mapping(address => uint256) public balanceOf;
61 	/* indicated if the funding goal has been reached. */
62 	bool fundingGoalReached = false;
63 	/* indicates if the crowdsale has been closed already */
64 	bool crowdsaleClosed = false;
65 	/* the multisignature wallet on which the funds will be stored */
66 	address msWallet = 0x91efffb9c6cd3a66474688d0a48aa6ecfe515aa5;
67 	/* notifying transfers and the success of the crowdsale*/
68 	event GoalReached(address beneficiary, uint amountRaised);
69 	event FundTransfer(address backer, uint amount, bool isContribution, uint amountRaised);
70 
71 
72 
73     /*  initialization, set the token address */
74     function Crowdsale( ) {
75         tokenReward = token(0x08711d3b02c8758f2fb3ab4e80228418a7f8e39c);
76     }
77 
78     /* invest by sending ether to the contract. */
79     function () payable{
80 		if(msg.sender != msWallet) //do not trigger investment if the multisig wallet is returning the funds
81         	invest(msg.sender);
82     }
83 
84     /* make an investment
85     *  only callable if the crowdsale started and hasn't been closed already and the maxGoal wasn't reached yet.
86     *  the current token price is looked up and the corresponding number of tokens is transfered to the receiver.
87     *  the sent value is directly forwarded to a safe multisig wallet.
88     *  this method allows to purchase tokens in behalf of another address.*/
89     function invest(address receiver) payable{
90     	uint amount = msg.value;
91     	uint price = getPrice();
92     	if(price > amount) throw;
93 		uint numTokens = amount / price;
94 		if (crowdsaleClosed||now<start||safeAdd(tokensSold,numTokens)>maxGoal) throw;
95 		if(!msWallet.send(amount)) throw;
96 		balanceOf[receiver] = safeAdd(balanceOf[receiver],amount);
97 		amountRaised = safeAdd(amountRaised, amount);
98 		tokensSold+=numTokens;
99 		if(!tokenReward.transferFrom(beneficiary, receiver, numTokens)) throw;
100         FundTransfer(receiver, amount, true, amountRaised);
101     }
102 
103     /* looks up the current token price */
104     function getPrice() constant returns (uint256 price){
105         for(var i = 0; i < deadlines.length; i++)
106             if(now<deadlines[i])
107                 return prices[i];
108         return prices[prices.length-1];//should never be returned, but to be sure to not divide by 0
109     }
110 
111     modifier afterDeadline() { if (now >= deadlines[deadlines.length-1]) _; }
112 
113     /* checks if the goal or time limit has been reached and ends the campaign */
114     function checkGoalReached() afterDeadline {
115         if (tokensSold >= fundingGoal){
116             fundingGoalReached = true;
117             tokenReward.burn(); //burn remaining tokens but 60 000 000
118             GoalReached(beneficiary, amountRaised);
119         }
120         crowdsaleClosed = true;
121     }
122 
123     /* allows the funders to withdraw their funds if the goal has not been reached.
124 	*  only works after funds have been returned from the multisig wallet. */
125 	function safeWithdrawal() afterDeadline {
126 		uint amount = balanceOf[msg.sender];
127 		if(address(this).balance >= amount){
128 			balanceOf[msg.sender] = 0;
129 			if (amount > 0) {
130 				if (msg.sender.send(amount)) {
131 					FundTransfer(msg.sender, amount, false, amountRaised);
132 				} else {
133 					balanceOf[msg.sender] = amount;
134 				}
135 			}
136 		}
137     }
138 
139 }