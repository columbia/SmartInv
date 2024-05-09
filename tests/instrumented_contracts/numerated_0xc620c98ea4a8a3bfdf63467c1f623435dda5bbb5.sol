1 pragma solidity 0.4.25;
2 
3 /**
4  *
5  * Contractum.cc
6  *
7  * Get 4% (and more) daily for lifetime!
8  *
9  * You get +0.1% to your profit for each 100 ETH on smartcontract balance (f.e., 5.6% daily while smartcontract balance is among 1600-1700 ETH etc.).
10  *
11  * You get +0.1% to your profit for each full 24 hours when you not withdrawn your income!
12  *
13  * 5% for referral program (use Add Data field and fill it with ETH-address of your upline when you create your deposit).
14  *
15  * Minimum invest amount is 0.01 ETH.
16  * Use 200000 of Gas limit for your transactions.
17  *
18  * Payments: 88%
19  * Advertising: 7%
20  * Admin: 5%
21  *
22  */
23 
24 contract Contractum {
25 	using SafeMath for uint256;
26 
27 	mapping (address => uint256) public userInvested;
28 	mapping (address => uint256) public userWithdrawn;
29 	mapping (address => uint256) public userLastOperationTime;
30 	mapping (address => uint256) public userLastWithdrawTime;
31 
32 	uint256 constant public INVEST_MIN_AMOUNT = 10 finney;      // 0.01 ETH
33 	uint256 constant public BASE_PERCENT = 40;                  // 4%
34 	uint256 constant public REFERRAL_PERCENT = 50;              // 5%
35 	uint256 constant public MARKETING_FEE = 70;                 // 7%
36 	uint256 constant public PROJECT_FEE = 50;                   // 5%
37 	uint256 constant public PERCENTS_DIVIDER = 1000;            // 100%
38 	uint256 constant public CONTRACT_BALANCE_STEP = 100 ether;  // 100 ETH
39 	uint256 constant public TIME_STEP = 1 days;                 // 86400 seconds
40 
41 	uint256 public totalInvested = 0;
42 	uint256 public totalWithdrawn = 0;
43 
44 	address public marketingAddress = 0x9631Be3F285441Eb4d52480AAA227Fa9CdC75153;
45 	address public projectAddress = 0x53b9f206EabC211f1e60b3d98d532b819e182725;
46 
47 	event addedInvest(address indexed user, uint256 amount);
48 	event payedDividends(address indexed user, uint256 dividend);
49 	event payedFees(address indexed user, uint256 amount);
50 	event payedReferrals(address indexed user, address indexed referrer, uint256 amount, uint256 refAmount);
51 
52 	// function to get actual percent rate which depends on contract balance
53 	function getContractBalanceRate() public view returns (uint256) {
54 		uint256 contractBalance = address(this).balance;
55 		uint256 contractBalancePercent = contractBalance.div(CONTRACT_BALANCE_STEP);
56 		return BASE_PERCENT.add(contractBalancePercent);
57 	}
58 
59 	// function to get actual user percent rate which depends on user last dividends payment
60 	function getUserPercentRate(address userAddress) public view returns (uint256) {
61 		uint256 contractBalanceRate = getContractBalanceRate();
62 		if (userInvested[userAddress] != 0) {
63 			uint256 timeMultiplier = now.sub(userLastWithdrawTime[userAddress]).div(TIME_STEP);
64 			return contractBalanceRate.add(timeMultiplier);
65 		} else {
66 			return contractBalanceRate;
67 		}
68 	}
69 
70 	// function to get actual user dividends amount which depends on user percent rate
71 	function getUserDividends(address userAddress) public view returns (uint256) {
72 		uint256 userPercentRate = getUserPercentRate(userAddress);
73 		uint256 userPercents = userInvested[userAddress].mul(userPercentRate).div(PERCENTS_DIVIDER);
74 		uint256 timeDiff = now.sub(userLastOperationTime[userAddress]);
75 		uint256 userDividends = userPercents.mul(timeDiff).div(TIME_STEP);
76 		return userDividends;
77 	}
78 
79 	// function to create new or add to user invest amount
80 	function addInvest() private {
81 		// update user timestamps if it is first user invest
82 		if (userInvested[msg.sender] == 0) {
83 			userLastOperationTime[msg.sender] = now;
84 			userLastWithdrawTime[msg.sender] = now;
85 		// pay dividends if user already made invest
86 		} else {
87 			payDividends();
88 		}
89 
90 		// add to user deposit and total invested
91 		userInvested[msg.sender] += msg.value;
92 		emit addedInvest(msg.sender, msg.value);
93 		totalInvested = totalInvested.add(msg.value);
94 
95 		// pay marketing and project fees
96 		uint256 marketingFee = msg.value.mul(MARKETING_FEE).div(PERCENTS_DIVIDER);
97 		uint256 projectFee = msg.value.mul(PROJECT_FEE).div(PERCENTS_DIVIDER);
98 		uint256 feeAmount = marketingFee.add(projectFee);
99 		marketingAddress.transfer(marketingFee);
100 		projectAddress.transfer(projectFee);
101 		emit payedFees(msg.sender, feeAmount);
102 
103 		// pay ref amount to referrer
104 		address referrer = bytesToAddress(msg.data);
105 		if (referrer > 0x0 && referrer != msg.sender) {
106 			uint256 refAmount = msg.value.mul(REFERRAL_PERCENT).div(PERCENTS_DIVIDER);
107 			referrer.transfer(refAmount);
108 			emit payedReferrals(msg.sender, referrer, msg.value, refAmount);
109 		}
110 	}
111 
112 	// function for pay dividends to user
113 	function payDividends() private {
114 		require(userInvested[msg.sender] != 0);
115 
116 		uint256 contractBalance = address(this).balance;
117 		uint256 percentsAmount = getUserDividends(msg.sender);
118 
119 		// pay percents amount if percents amount less than available contract balance
120 		if (contractBalance >= percentsAmount) {
121 			msg.sender.transfer(percentsAmount);
122 			userWithdrawn[msg.sender] += percentsAmount;
123 			emit payedDividends(msg.sender, percentsAmount);
124 			totalWithdrawn = totalWithdrawn.add(percentsAmount);
125 		// pay all contract balance if percents amount more than available contract balance
126 		} else {
127 			msg.sender.transfer(contractBalance);
128 			userWithdrawn[msg.sender] += contractBalance;
129 			emit payedDividends(msg.sender, contractBalance);
130 			totalWithdrawn = totalWithdrawn.add(contractBalance);
131 		}
132 
133 		userLastOperationTime[msg.sender] = now;
134 	}
135 
136 	function() external payable {
137 		if (msg.value >= INVEST_MIN_AMOUNT) {
138 			addInvest();
139 		} else {
140 			payDividends();
141 
142 			// update last withdraw timestamp for user
143 			userLastWithdrawTime[msg.sender] = now;
144 		}
145 	}
146 
147 	function bytesToAddress(bytes data) private pure returns (address addr) {
148 		assembly {
149 			addr := mload(add(data, 20))
150 		}
151 	}
152 }
153 
154 /**
155  * @title SafeMath
156  * @dev Math operations with safety checks that revert on error
157  */
158 library SafeMath {
159 
160 	/**
161 	* @dev Multiplies two numbers, reverts on overflow.
162 	*/
163 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
164 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
165 		// benefit is lost if 'b' is also tested.
166 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
167 		if (a == 0) {
168 			return 0;
169 		}
170 
171 		uint256 c = a * b;
172 		require(c / a == b);
173 
174 		return c;
175 	}
176 
177 	/**
178 	* @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
179 	*/
180 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
181 		require(b > 0); // Solidity only automatically asserts when dividing by 0
182 		uint256 c = a / b;
183 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
184 
185 		return c;
186 	}
187 
188 	/**
189 	* @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
190 	*/
191 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
192 		require(b <= a);
193 		uint256 c = a - b;
194 
195 		return c;
196 	}
197 
198 	/**
199 	* @dev Adds two numbers, reverts on overflow.
200 	*/
201 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
202 		uint256 c = a + b;
203 		require(c >= a);
204 
205 		return c;
206 	}
207 }