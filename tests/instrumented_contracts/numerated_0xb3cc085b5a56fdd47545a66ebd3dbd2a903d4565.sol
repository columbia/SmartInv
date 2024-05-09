1 pragma solidity ^0.4.21;
2 
3 
4 library SafeMath {
5 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
6 		uint256 c = a + b;
7 		assert(a <= c);
8 		return c;
9 	}
10 
11 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12 		assert(a >= b);
13 		return a - b;
14 	}
15 
16 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17 		uint256 c = a * b;
18 		assert(a == 0 || c / a == b);
19 		return c;
20 	}
21 
22 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
23 		return a / b;
24 	}
25 }
26 
27 
28 contract AuctusStepVesting {
29 	using SafeMath for uint256;
30 
31 	address public beneficiary;
32 	uint256 public start;
33 	uint256 public cliff;
34 	uint256 public steps;
35 
36 	uint256 public releasedSteps;
37 	uint256 public releasedAmount;
38 	uint256 public remainingAmount;
39 
40 	event Released(uint256 step, uint256 amount);
41 
42 	/**
43 	* @dev Creates a vesting contract that vests its balance to the _beneficiary
44 	* The amount is released gradually in steps
45 	* @param _beneficiary address of the beneficiary to whom vested are transferred
46 	* @param _start unix time that starts to apply the vesting rules
47 	* @param _cliff duration in seconds of the cliff in which will begin to vest and between the steps
48 	* @param _steps total number of steps to release all the balance
49 	*/
50 	function AuctusStepVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _steps) public {
51 		require(_beneficiary != address(0));
52 		require(_steps > 0);
53 		require(_cliff > 0);
54 
55 		beneficiary = _beneficiary;
56 		cliff = _cliff;
57 		start = _start;
58 		steps = _steps;
59 	}
60 
61 	function transfer(uint256 amount) internal;
62 
63 	/**
64 	* @notice Transfers vested tokens to beneficiary.
65 	*/
66 	function release() public {
67 		uint256 unreleased = getAllowedStepAmount();
68 
69 		require(unreleased > 0);
70 
71 		releasedAmount = releasedAmount.add(unreleased);
72 		remainingAmount = remainingAmount.sub(unreleased);
73 		if (remainingAmount == 0) {
74 			releasedSteps = steps;
75 		} else {
76 			releasedSteps = releasedSteps + 1;
77 		}
78 
79 		transfer(unreleased);
80 
81 		emit Released(releasedSteps, unreleased);
82 	}
83 
84 	function getAllowedStepAmount() public view returns (uint256) {
85 		if (remainingAmount == 0) {
86 			return 0;
87 		} else if (now < start) {
88 			return 0;
89 		} else {
90 			uint256 secondsFromTheBeginning = now.sub(start);
91 			if (secondsFromTheBeginning < cliff) {
92 				return 0;
93 			} else {
94 				uint256 stepsAllowed = secondsFromTheBeginning.div(cliff);
95 				if (stepsAllowed >= steps) {
96 					return remainingAmount;
97 				} else if (releasedSteps == stepsAllowed) {
98 					return 0;
99 				} else {
100 					return totalControlledBalance().div(steps);
101 				}
102 			}
103 		}
104 	}
105 
106 	function totalControlledBalance() public view returns (uint256) {
107 		return remainingAmount.add(releasedAmount);
108 	}
109 }
110 
111 
112 contract AuctusEtherVesting is AuctusStepVesting {
113 	function AuctusEtherVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _steps) 
114 		public 
115 		AuctusStepVesting(_beneficiary, _start, _cliff, _steps) 
116 	{
117 	}
118 
119 	function transfer(uint256 amount) internal {
120 		beneficiary.transfer(amount);
121 	}
122 
123 	function () payable public {
124 		remainingAmount = remainingAmount.add(msg.value);
125 	}
126 }
127 
128 
129 contract AuctusToken {
130 	function transfer(address to, uint256 value) public returns (bool);
131 }
132 
133 
134 contract ContractReceiver {
135 	function tokenFallback(address from, uint256 value, bytes data) public;
136 }
137 
138 
139 contract AuctusTokenVesting is AuctusStepVesting, ContractReceiver {
140 	address public auctusTokenAddress = 0xc12d099be31567add4e4e4d0D45691C3F58f5663;
141 
142 	function AuctusTokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _steps) 
143 		public 
144 		AuctusStepVesting(_beneficiary, _start, _cliff, _steps) 
145 	{
146 	}
147 
148 	function transfer(uint256 amount) internal {
149 		assert(AuctusToken(auctusTokenAddress).transfer(beneficiary, amount));
150 	}
151 
152 	function tokenFallback(address from, uint256 value, bytes) public {
153 		require(msg.sender == auctusTokenAddress);
154 		remainingAmount = remainingAmount.add(value);
155 	}
156 }