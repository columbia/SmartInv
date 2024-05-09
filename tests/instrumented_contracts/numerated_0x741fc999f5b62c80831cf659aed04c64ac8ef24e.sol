1 /**
2  *  Crowdsale for Monetha Tokens.
3  *  Raised Ether will be stored safely at the wallet and returned to the ICO in case the funding goal is not reached,
4  *  allowing the investors to withdraw their funds.
5  *  Author: Julia Altenried
6  *  Internal audit: Alex Bazhanau, Andrej Ruckij
7  *  Audit: Blockchain & Smart Contract Security Group
8  **/
9 
10 pragma solidity ^0.4.15;
11 
12 contract token {
13 	function transferFrom(address sender, address receiver, uint amount) returns(bool success) {}
14 
15 	function burn() {}
16 	
17 	function setStart(uint newStart) {}
18 }
19 
20 contract SafeMath {
21 	//internals
22 
23 	function safeMul(uint a, uint b) internal returns(uint) {
24 		uint c = a * b;
25 		assert(a == 0 || c / a == b);
26 		return c;
27 	}
28 
29 	function safeSub(uint a, uint b) internal returns(uint) {
30 		assert(b <= a);
31 		return a - b;
32 	}
33 
34 	function safeAdd(uint a, uint b) internal returns(uint) {
35 		uint c = a + b;
36 		assert(c >= a && c >= b);
37 		return c;
38 	}
39 
40 }
41 
42 
43 contract Crowdsale is SafeMath {
44 	/* tokens will be transfered from this address */
45 	address public tokenOwner;
46 	/* if the funding goal is not reached, investors may withdraw their funds */
47 	uint constant public fundingGoal = 672000000000;
48 	/* when the soft cap is reached, the price for monetha tokens will rise */
49 	uint constant public softCap = 6720000000000;
50 	/* the maximum amount of tokens to be sold */
51 	uint constant public maxGoal = 20120000000000;
52 	/* how much has been raised by crowdale (in ETH) */
53 	uint public amountRaised;
54 	/* the start date of the crowdsale */
55 	uint public start;
56 	/* the end date of the crowdsale*/
57 	uint public end;
58 	/* time after reaching the soft cap, while the crowdsale will be still available*/
59 	uint public timeAfterSoftCap;
60 	/* the number of tokens already sold */
61 	uint public tokensSold = 0;
62 	/* the rates before and after the soft cap is reached */
63 	uint constant public rateSoft = 24;
64 	uint constant public rateHard = 20;
65 
66 	uint constant public rateCoefficient = 100000000000;
67 	/* the address of the token contract */
68 	token public tokenReward;
69 	/* the balances (in ETH) of all investors */
70 	mapping(address => uint) public balanceOf;
71 	/* indicates if the crowdsale has been closed already */
72 	bool public crowdsaleClosed = false;
73 	/* the wallet on which the funds will be stored */
74 	address msWallet;
75 	/* notifying transfers and the success of the crowdsale*/
76 	event GoalReached(address _tokenOwner, uint _amountRaised);
77 	event FundTransfer(address backer, uint amount, bool isContribution, uint _amountRaised);
78 
79 
80 
81 	/*  initialization, set the token address */
82 	function Crowdsale(
83 		address _tokenAddr, 
84 		address _walletAddr, 
85 		address _tokenOwner, 
86 		uint _start, 
87 		uint _end,
88 		uint _timeAfterSoftCap) {
89 		tokenReward = token(_tokenAddr);
90 		msWallet = _walletAddr;
91 		tokenOwner = _tokenOwner;
92 
93 		require(_start < _end);
94 		start = _start;
95 		end = _end;
96 		timeAfterSoftCap = _timeAfterSoftCap;
97 	}
98 
99 	/* invest by sending ether to the contract. */
100 	function() payable {
101 		if (msg.sender != msWallet) //do not trigger investment if the wallet is returning the funds
102 			invest(msg.sender);
103 	}
104 
105 	/* make an investment
106 	 *  only callable if the crowdsale started and hasn't been closed already and the maxGoal wasn't reached yet.
107 	 *  the current token price is looked up and the corresponding number of tokens is transfered to the receiver.
108 	 *  the sent value is directly forwarded to a safe wallet.
109 	 *  this method allows to purchase tokens in behalf of another address.*/
110 	function invest(address _receiver) payable {
111 		uint amount = msg.value;
112 		var (numTokens, reachedSoftCap) = getNumTokens(amount);
113 		require(numTokens>0);
114 		require(!crowdsaleClosed && now >= start && now <= end && safeAdd(tokensSold, numTokens) <= maxGoal);
115 		msWallet.transfer(amount);
116 		balanceOf[_receiver] = safeAdd(balanceOf[_receiver], amount);
117 		amountRaised = safeAdd(amountRaised, amount);
118 		tokensSold += numTokens;
119 		assert(tokenReward.transferFrom(tokenOwner, _receiver, numTokens));
120 		FundTransfer(_receiver, amount, true, amountRaised);
121 		if (reachedSoftCap) {
122 			uint newEnd = now + timeAfterSoftCap;
123 			if (newEnd < end) {
124 				end = newEnd;
125 				tokenReward.setStart(newEnd);
126 			} 
127 		}
128 	}
129 	
130 	function getNumTokens(uint _value) constant returns(uint numTokens, bool reachedSoftCap) {
131 		if (tokensSold < softCap) {
132 			numTokens = safeMul(_value,rateSoft)/rateCoefficient;
133 			if (safeAdd(tokensSold,numTokens) < softCap) 
134 				return (numTokens, false);
135 			else if (safeAdd(tokensSold,numTokens) == softCap) 
136 				return (numTokens, true);
137 			else {
138 				numTokens = safeSub(softCap, tokensSold);
139 				uint missing = safeSub(_value, safeMul(numTokens,rateCoefficient)/rateSoft);
140 				return (safeAdd(numTokens, safeMul(missing,rateHard)/rateCoefficient), true);
141 			}
142 		} 
143 		else 
144 			return (safeMul(_value,rateHard)/rateCoefficient, false);
145 	}
146 
147 	modifier afterDeadline() {
148 		if (now > end) 
149 			_;
150 	}
151 
152 	/* checks if the goal or time limit has been reached and ends the campaign */
153 	function checkGoalReached() afterDeadline {
154 		require(msg.sender == tokenOwner);
155 
156 		if (tokensSold >= fundingGoal) {
157 			tokenReward.burn(); //burn remaining tokens but the reserved ones
158 			GoalReached(tokenOwner, amountRaised);
159 		}
160 		crowdsaleClosed = true;
161 	}
162 
163 	/* allows the funders to withdraw their funds if the goal has not been reached.
164 	 *  only works after funds have been returned from the wallet. */
165 	function safeWithdrawal() afterDeadline {
166 		uint amount = balanceOf[msg.sender];
167 		if (address(this).balance >= amount) {
168 			balanceOf[msg.sender] = 0;
169 			if (amount > 0) {
170 				msg.sender.transfer(amount);
171 				FundTransfer(msg.sender, amount, false, amountRaised);
172 			}
173 		}
174 	}
175 
176 }