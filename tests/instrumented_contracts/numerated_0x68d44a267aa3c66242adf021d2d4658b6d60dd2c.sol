1 pragma solidity ^0.4.6;
2 
3 contract token {
4 	function transferFrom(address sender, address receiver, uint amount) returns(bool success){}
5 	function burn() {}
6 }
7 
8 contract SafeMath {
9   
10 
11   function safeMul(uint a, uint b) internal returns (uint) {
12     uint c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function safeSub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27 
28   function assert(bool assertion) internal {
29     if (!assertion) throw;
30   }
31 }
32 
33 
34 contract Crowdsale is SafeMath {
35     /* tokens will be transfered from this address (92M) */
36 	address public beneficiary = 0xbB93222C54f72ae99b2539a44093f2ED62533EBE;
37 	/* if the funding goal is not reached, investors may withdraw their funds,this is the minimum target */
38 	uint public fundingGoal = 1200000;
39 	/*  maximum amount of tokens to be sold */
40 	uint public maxGoal = 92000000;
41 	/* how much has been raised by crowdale ( ETH) */
42 	uint public amountRaised;
43 	/* the start date of the crowdsale */
44 	uint public start = 1493727424;
45 	/* the number of tokens already sold */
46 	uint public tokensSold;
47 	/* there are different prices in different time intervals */
48 	uint[2] public deadlines = [1494086400,1496757600];
49 	uint[2] public prices = [5000000000000000 ,6250000000000000 ];
50 	/* the address of the token contract */
51 	token public tokenReward;
52 	/* the balances (in ETH) of all investors */
53 	mapping(address => uint256) public balanceOf;
54 	/* indicated if the funding goal has been reached. */
55 	bool fundingGoalReached = false;
56 	/* indicates if the crowdsale has been closed already */
57 	bool crowdsaleClosed = false;
58 	/* the multisignature wallet on which the funds will be stored */
59 	address msWallet = 0x82612343BD6856E2A90378fAdeB5FFd950C348C9;
60 	/* notifying transfers and the success of the crowdsale*/
61 	event GoalReached(address beneficiary, uint amountRaised);
62 	event FundTransfer(address backer, uint amount, bool isContribution, uint amountRaised);
63 
64 
65 
66     /*  initialization, set the voise token address */
67     function Crowdsale( ) {
68         tokenReward = token(0x82665764ea0b58157E1e5E9bab32F68c76Ec0CdF);
69     }
70 
71     /* invest by sending ether to the contract. */
72     function () payable{
73 		if(msg.sender != msWallet) //do not trigger investment if the multisig wallet is returning the funds
74         	invest(msg.sender);
75     }
76 
77     /* function to invest in the crowdsale
78     *  only callable if the crowdsale started and hasn't been closed already and the maxGoal wasn't reached yet.
79     *  the current token price is looked up and the corresponding number of tokens is transfered to the receiver.
80     *  the sent value is directly forwarded to a safe multisig wallet.
81     *  this method allows to purchase tokens in behalf of another address.*/
82     function invest(address receiver) payable{
83     	uint amount = msg.value;
84     	uint price = getPrice();
85     	if(price > amount) throw;
86 		uint numTokens = amount / price;
87 		if (crowdsaleClosed||now<start||safeAdd(tokensSold,numTokens)>maxGoal) throw;
88 		if(!msWallet.send(amount)) throw;
89 		balanceOf[receiver] = safeAdd(balanceOf[receiver],amount);
90 		amountRaised = safeAdd(amountRaised, amount);
91 		tokensSold+=numTokens;
92 		if(!tokenReward.transferFrom(beneficiary, receiver, numTokens)) throw;
93         FundTransfer(receiver, amount, true, amountRaised);
94     }
95 
96     /* looks up the current token price */
97     function getPrice() constant returns (uint256 price){
98         for(var i = 0; i < deadlines.length; i++)
99             if(now<deadlines[i])
100                 return prices[i];
101         return prices[prices.length-1];//should never be returned, but to be sure to not divide by 0
102     }
103 
104     modifier afterDeadline() { if (now >= deadlines[deadlines.length-1]) _; }
105 
106     /* checks if the goal or time limit has been reached and ends the campaign */
107     function checkGoalReached() afterDeadline {
108         if (tokensSold >= fundingGoal){
109             fundingGoalReached = true;
110             tokenReward.burn(); //burn remaining tokens 
111             GoalReached(beneficiary, amountRaised);
112         }
113         crowdsaleClosed = true;
114     }
115 
116     /* allows the funders to withdraw their funds if the goal has not been reached.
117 	*  only works after funds have been returned from the multisig wallet. */
118 	function safeWithdrawal() afterDeadline {
119 		uint amount = balanceOf[msg.sender];
120 		if(address(this).balance >= amount){
121 			balanceOf[msg.sender] = 0;
122 			if (amount > 0) {
123 				if (msg.sender.send(amount)) {
124 					FundTransfer(msg.sender, amount, false, amountRaised);
125 				} else {
126 					balanceOf[msg.sender] = amount;
127 				}
128 			}
129 		}
130     }
131 
132 }