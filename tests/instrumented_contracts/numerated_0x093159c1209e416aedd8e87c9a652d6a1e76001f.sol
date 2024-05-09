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
29 	mapping (address => uint256) public userTimestamp;
30 
31 	uint256 constant public INVEST_MIN_AMOUNT = 10 finney;      // 0.01 ETH
32 	uint256 constant public BASE_PERCENT = 40;                  // 4%
33 	uint256 constant public REFERRAL_PERCENT = 50;              // 5%
34 	uint256 constant public MARKETING_FEE = 70;                 // 7%
35 	uint256 constant public PROJECT_FEE = 50;                   // 5%
36 	uint256 constant public PERCENTS_DIVIDER = 1000;            // 100%
37 	uint256 constant public CONTRACT_BALANCE_STEP = 100 ether;  // 100 ETH
38 	uint256 constant public TIME_STEP = 1 days;                 // 86400 seconds
39 
40 	uint256 public totalInvested = 0;
41 	uint256 public totalWithdrawn = 0;
42 
43 	address public marketingAddress = 0x9631Be3F285441Eb4d52480AAA227Fa9CdC75153;
44 	address public projectAddress = 0x53b9f206EabC211f1e60b3d98d532b819e182725;
45 
46 	event addedInvest(address indexed user, uint256 amount);
47 	event payedDividends(address indexed user, uint256 dividend);
48 	event payedFees(address indexed user, uint256 amount);
49 	event payedReferrals(address indexed user, address indexed referrer, uint256 amount, uint256 refAmount);
50 
51 	// function to get actual percent rate which depends on contract balance
52 	function getContractBalanceRate() public view returns (uint256) {
53 		uint256 contractBalance = address(this).balance;
54 		uint256 contractBalancePercent = contractBalance.div(CONTRACT_BALANCE_STEP);
55 		return BASE_PERCENT.add(contractBalancePercent);
56 	}
57 
58 	// function to get actual user percent rate which depends on user last dividends payment
59 	function getUserPercentRate(address userAddress) public view returns (uint256) {
60 		uint256 contractBalanceRate = getContractBalanceRate();
61 		if (userInvested[userAddress] != 0) {
62 			uint256 timeMultiplier = now.sub(userTimestamp[userAddress]).div(TIME_STEP);
63 			return contractBalanceRate.add(timeMultiplier);
64 		} else {
65 			return contractBalanceRate;
66 		}
67 	}
68 
69 	// function to get actual user dividends amount which depends on user percent rate
70 	function getUserDividends(address userAddress) public view returns (uint256) {
71 		uint256 userPercentRate = getUserPercentRate(userAddress);
72 		uint256 userPercents = userInvested[userAddress].mul(userPercentRate).div(PERCENTS_DIVIDER);
73 		uint256 timeDiff = now.sub(userTimestamp[userAddress]);
74 		uint256 userDividends = userPercents.mul(timeDiff).div(TIME_STEP);
75 		return userDividends;
76 	}
77 
78 	// function to create new or add to user invest amount
79 	function addInvest() private {
80 		// update user timestamp if it is first user invest
81 		if (userInvested[msg.sender] == 0) {
82 			userTimestamp[msg.sender] = now;
83 		}
84 
85 		// add to user deposit and total invested
86 		userInvested[msg.sender] += msg.value;
87 		emit addedInvest(msg.sender, msg.value);
88 		totalInvested = totalInvested.add(msg.value);
89 
90 		// pay marketing and project fees
91 		uint256 marketingFee = msg.value.mul(MARKETING_FEE).div(PERCENTS_DIVIDER);
92 		uint256 projectFee = msg.value.mul(PROJECT_FEE).div(PERCENTS_DIVIDER);
93 		uint256 feeAmount = marketingFee.add(projectFee);
94 		marketingAddress.transfer(marketingFee);
95 		projectAddress.transfer(projectFee);
96 		emit payedFees(msg.sender, feeAmount);
97 
98 		// pay ref amount to referrer
99 		address referrer = bytesToAddress(msg.data);
100 		if (referrer > 0x0 && referrer != msg.sender) {
101 			uint256 refAmount = msg.value.mul(REFERRAL_PERCENT).div(PERCENTS_DIVIDER);
102 			referrer.transfer(refAmount);
103 			emit payedReferrals(msg.sender, referrer, msg.value, refAmount);
104 		}
105 	}
106 
107 	// function for pay dividends to user
108 	function payDividends() private {
109 		require(userInvested[msg.sender] != 0);
110 
111 		uint256 contractBalance = address(this).balance;
112 		uint256 percentsAmount = getUserDividends(msg.sender);
113 
114 		// pay percents amount if percents amount less than available contract balance
115 		if (contractBalance >= percentsAmount) {
116 			msg.sender.transfer(percentsAmount);
117 			userWithdrawn[msg.sender] += percentsAmount;
118 			emit payedDividends(msg.sender, percentsAmount);
119 			totalWithdrawn = totalWithdrawn.add(percentsAmount);
120 		// pay all contract balance if percents amount more than available contract balance
121 		} else {
122 			msg.sender.transfer(contractBalance);
123 			userWithdrawn[msg.sender] += contractBalance;
124 			emit payedDividends(msg.sender, contractBalance);
125 			totalWithdrawn = totalWithdrawn.add(contractBalance);
126 		}
127 
128 		// update last timestamp for user
129 		userTimestamp[msg.sender] = now;
130 	}
131 
132 	function() external payable {
133 		if (msg.value >= INVEST_MIN_AMOUNT) {
134 			addInvest();
135 		} else {
136 			payDividends();
137 		}
138 	}
139 
140 	function bytesToAddress(bytes data) private pure returns (address addr) {
141 		assembly {
142 			addr := mload(add(data, 20))
143 		}
144 	}
145 }
146 
147 /**
148  * @title SafeMath
149  * @dev Math operations with safety checks that revert on error
150  */
151 library SafeMath {
152 
153 	/**
154 	* @dev Multiplies two numbers, reverts on overflow.
155 	*/
156 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
158 		// benefit is lost if 'b' is also tested.
159 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
160 		if (a == 0) {
161 			return 0;
162 		}
163 
164 		uint256 c = a * b;
165 		require(c / a == b);
166 
167 		return c;
168 	}
169 
170 	/**
171 	* @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
172 	*/
173 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
174 		require(b > 0); // Solidity only automatically asserts when dividing by 0
175 		uint256 c = a / b;
176 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
177 
178 		return c;
179 	}
180 
181 	/**
182 	* @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
183 	*/
184 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
185 		require(b <= a);
186 		uint256 c = a - b;
187 
188 		return c;
189 	}
190 
191 	/**
192 	* @dev Adds two numbers, reverts on overflow.
193 	*/
194 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
195 		uint256 c = a + b;
196 		require(c >= a);
197 
198 		return c;
199 	}
200 }