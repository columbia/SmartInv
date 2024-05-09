1 pragma solidity ^0.4.15;
2 
3 	contract SafeMath {
4 
5 	  function safeMul(uint a, uint b) returns (uint) {
6 		if (a == 0) {
7 		  return 0;
8 		} else {
9 		  uint c = a * b;
10 		  require(c / a == b);
11 		  return c;
12 		}
13 	  }
14 
15 	  function safeDiv(uint a, uint b) returns (uint) {
16 		require(b > 0);
17 		uint c = a / b;
18 		require(a == b * c + a % b);
19 		return c;
20 	  }
21 
22 	}
23 
24 	contract token {
25 		function transferFrom(address _from, address _receiver, uint _amount);
26 	}
27 
28 	contract CrowdSale is SafeMath {
29 		address public beneficiary;
30 		uint public fundingMinimumTargetInUsd;
31 		uint public fundingMaximumTargetInUsd;
32 		uint public amountRaised;
33 		uint public priceInUsd;
34 		token public tokenReward;
35 		mapping(address => uint256) public balanceOf;
36 		bool public fundingGoalReached = false;
37 		address tokenHolder;
38 		address public creator;
39 		uint public tokenAllocation;
40 		uint public tokenRaised;
41 		uint public etherPriceInUsd;
42 		uint public totalUsdRaised;
43 		bool public icoState = false;
44 		bool public userRefund = false;
45 		mapping(address => bool) public syncList;
46 
47 		event GoalMinimumReached(address _beneficiary, uint _amountRaised, uint _totalUsdRaised);
48 		event GoalMaximumReached(address _beneficiary, uint _amountRaised, uint _totalUsdRaised);
49 		event FundTransfer(address _backer, uint _amount, bool _isContribution);
50 
51 		/**
52 		 * Constrctor function
53 		 *
54 		 * Setup the owner
55 		 */
56 		function CrowdSale(
57 			address ifSuccessfulSendTo,
58 			uint _fundingMinimumTargetInUsd,
59 			uint _fundingMaximumTargetInUsd,
60 			uint tokenPriceInUSD,
61 			address addressOfTokenUsedAsReward,
62 			address _tokenHolder,
63 			uint _tokenAllocation,
64 			uint _etherPriceInUsd
65 		) {
66 			creator = msg.sender;
67 			syncList[creator] = true;
68 			beneficiary = ifSuccessfulSendTo;
69 			fundingMinimumTargetInUsd = _fundingMinimumTargetInUsd;
70 			fundingMaximumTargetInUsd = _fundingMaximumTargetInUsd;
71 			priceInUsd = tokenPriceInUSD;
72 			tokenReward = token(addressOfTokenUsedAsReward);
73 			tokenHolder = _tokenHolder;
74 			tokenAllocation = _tokenAllocation;
75 			etherPriceInUsd = _etherPriceInUsd;
76 		}
77 
78 		modifier isMaximum() {
79 		  require(safeMul(msg.value, etherPriceInUsd) <= 100000000000000000000000000);
80 		   _;
81 		}
82 
83 		modifier isCreator() {
84 			require(msg.sender == creator);
85 			_;
86 		}
87 
88 		modifier isSyncList(address _source){
89 		  require(syncList[_source]);
90 		  _;
91 		}
92 
93 		function addToSyncList(address _source) isCreator() returns (bool) {
94 		  syncList[_source] = true;
95 		}
96 
97 		function setEtherPrice(uint _price) isSyncList(msg.sender) returns (bool result){
98 		  etherPriceInUsd = _price;
99 		  return true;
100 		}
101 
102 		function stopIco() isCreator() returns (bool result){
103 		  icoState = false;
104 		  return true;
105 		}
106 
107 		function startIco() isCreator() returns (bool result){
108 		  icoState = true;
109 		  return true;
110 		}
111 
112 		function settingsIco(uint _priceInUsd, address _tokenHolder, uint _tokenAllocation, uint _fundingMinimumTargetInUsd, uint _fundingMaximumTargetInUsd) isCreator() returns (bool result){
113 		  require(!icoState);
114 		  priceInUsd = _priceInUsd;
115 		  tokenHolder = _tokenHolder;
116 		  tokenAllocation = _tokenAllocation;
117 		  fundingMinimumTargetInUsd = _fundingMinimumTargetInUsd;
118 		  fundingMaximumTargetInUsd = _fundingMaximumTargetInUsd;
119 		  return true;
120 		}
121 
122 		/**
123 		 * Fallback function
124 		 *
125 		 * The function without name is the default function that is called whenever anyone sends funds to a contract
126 		 */
127 		function () isMaximum() payable {
128 			require(icoState);
129 
130 			uint etherAmountInWei = msg.value;
131 			uint amount = safeMul(msg.value, etherPriceInUsd);
132 			uint256 tokenAmount = safeDiv(safeDiv(amount, priceInUsd), 10000000000);
133 			require(tokenRaised + tokenAmount <= tokenAllocation);
134 			tokenRaised += tokenAmount;
135 
136 
137 			uint amountInUsd = safeDiv(amount, 1000000000000000000);
138 			require(totalUsdRaised + amountInUsd <= fundingMaximumTargetInUsd);
139 			totalUsdRaised += amountInUsd;
140 
141 			balanceOf[msg.sender] += etherAmountInWei;
142 			amountRaised += etherAmountInWei;
143 			tokenReward.transferFrom(tokenHolder, msg.sender, tokenAmount);
144 			FundTransfer(msg.sender, etherAmountInWei, true);
145 		}
146 
147 		/**
148 		 * Check if goal was reached
149 		 *
150 		 * Checks if the goal or time limit has been reached and ends the campaign
151 		 */
152 		function checkGoalReached() isCreator() {
153 			if (totalUsdRaised >= fundingMaximumTargetInUsd){
154 				fundingGoalReached = true;
155 				GoalMaximumReached(beneficiary, amountRaised, totalUsdRaised);
156 			} else if (totalUsdRaised >= fundingMinimumTargetInUsd) {
157 				fundingGoalReached = true;
158 				GoalMinimumReached(beneficiary, amountRaised, totalUsdRaised);
159 			}
160 		}
161 
162 
163 		/**
164 		 * Withdraw the funds
165 		 *
166 		 */
167 		function safeWithdrawal() {
168 			if (userRefund) {
169 				uint amount = balanceOf[msg.sender];
170 				balanceOf[msg.sender] = 0;
171 				if (amount > 0) {
172 					if (msg.sender.send(amount)) {
173 						FundTransfer(msg.sender, amount, false);
174 					} else {
175 						balanceOf[msg.sender] = amount;
176 					}
177 				}
178 			}
179 		}
180 
181 		//Transfer Funds
182 		function drain() {
183 			require(beneficiary == msg.sender);
184 			if (beneficiary.send(amountRaised)) {
185 				FundTransfer(beneficiary, amountRaised, false);
186 			}
187 		}
188 
189 		//Autorize users refunds
190 		function AutorizeRefund() isCreator() returns (bool success){
191 			require(!icoState);
192 			userRefund = true;
193 			return true;
194 		}
195 
196 		// Remove contract
197 		function removeContract() public isCreator() {
198 			require(!icoState);
199 			selfdestruct(msg.sender);
200 		}
201 
202 	}