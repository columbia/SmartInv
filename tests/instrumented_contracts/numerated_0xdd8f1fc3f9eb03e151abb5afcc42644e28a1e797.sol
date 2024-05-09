1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9 	/**
10 	* @dev Multiplies two numbers, throws on overflow.
11 	*/
12 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13 		if (a == 0) {
14 			return 0;
15 		}
16 		c = a * b;
17 		assert(c / a == b);
18 		return c;
19 	}
20 
21 	/**
22 	* @dev Integer division of two numbers, truncating the quotient.
23 	*/
24 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
25 		// assert(b > 0); // Solidity automatically throws when dividing by 0
26 		// uint256 c = a / b;
27 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
28 		return a / b;
29 	}
30 
31 	/**
32 	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33 	*/
34 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35 		assert(b <= a);
36 		return a - b;
37 	}
38 
39 	/**
40 	* @dev Adds two numbers, throws on overflow.
41 	*/
42 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43 		c = a + b;
44 		assert(c >= a);
45 		return c;
46 	}
47 }
48 
49 // Create Ad on DappVolume
50 // Advertiser can choose 1 hour, 12 hours, 24 hours, or 1 week
51 // half of the money gets sent back to last advertiser
52 //
53 // An investor can earn 10% of the ad revenue
54 // Investors can get bought out by new investors
55 // when an invester is bought out, they get 120% of their investment back
56 
57 contract dappVolumeAd {
58 
59 // import safemath
60 using SafeMath for uint256;
61 
62 	// set variables
63 	uint256 public dappId;
64 	uint256 public purchaseTimestamp;
65 	uint256 public purchaseSeconds;
66 	uint256 public investmentMin;
67 	uint256 public adPriceHour;
68 	uint256 public adPriceHalfDay;
69 	uint256 public adPriceDay;
70 	uint256 public adPriceWeek;
71 	uint256 public adPriceMultiple;
72 	address public contractOwner;
73 	address public lastOwner;
74 	address public theInvestor;
75 
76 	// only contract owner
77 	modifier onlyContractOwner {
78 		require(msg.sender == contractOwner);
79 		_;
80 	}
81 
82 	// set constructor
83 	constructor() public {
84 		investmentMin = 1000000000000000;
85 		adPriceHour = 5000000000000000;
86 		adPriceHalfDay = 50000000000000000;
87 		adPriceDay = 100000000000000000;
88 		adPriceWeek = 500000000000000000;
89 		adPriceMultiple = 1;
90 		contractOwner = msg.sender;
91 		theInvestor = contractOwner;
92 		lastOwner = contractOwner;
93 	}
94 
95 	// withdraw funds to contract creator
96 	function withdraw() public onlyContractOwner {
97 		contractOwner.transfer(address(this).balance);
98 	}
99 
100 	// set ad price multiple incase we want to up the price in the future
101 	function setAdPriceMultiple(uint256 amount) public onlyContractOwner {
102 		adPriceMultiple = amount;
103 	}
104 
105 	// update and set ad
106 	function updateAd(uint256 id) public payable {
107 		// set minimum amount and make sure ad hasnt expired
108 		require(msg.value >= adPriceMultiple.mul(adPriceHour));
109 		require(block.timestamp > purchaseTimestamp + purchaseSeconds);
110 		require(id > 0);
111 
112 		// set ad time limit in seconds
113 		if (msg.value >= adPriceMultiple.mul(adPriceWeek)) {
114 			purchaseSeconds = 604800; // 1 week
115 		} else if (msg.value >= adPriceMultiple.mul(adPriceDay)) {
116 			purchaseSeconds = 86400; // 1 day
117 		} else if (msg.value >= adPriceMultiple.mul(adPriceHalfDay)) {
118 			purchaseSeconds = 43200; // 12 hours
119 		} else {
120 			purchaseSeconds = 3600; // 1 hour
121 		}
122 
123 		// set new timestamp
124 		purchaseTimestamp = block.timestamp;
125 		// send 50% of the money to the last person
126 		lastOwner.transfer(msg.value.div(2));
127 		// send 10% to the investor
128 		theInvestor.transfer(msg.value.div(10));
129 		// set last owner
130 		lastOwner = msg.sender;
131 		// set dapp id
132 		dappId = id;
133 	}
134 
135 	// update the investor
136 	function updateInvestor() public payable {
137 		require(msg.value >= investmentMin);
138 		theInvestor.transfer(msg.value.div(100).mul(60)); // send 60% to last investor (120% of original purchase)
139 		theInvestor = msg.sender; // set new investor
140 		investmentMin = investmentMin.mul(2); // double the price to become the investor
141 	}
142 
143 	// get timestamp when ad ends
144 	function getPurchaseTimestampEnds() public view returns (uint _getPurchaseTimestampAdEnds) {
145 		return purchaseTimestamp.add(purchaseSeconds);
146 	}
147 
148 	// get contract balance
149 	function getBalance() public view returns(uint256){
150 		return address(this).balance;
151 	}
152 
153 }