1 pragma solidity ^0.4.24;
2 
3 // THE LAST SMART CONTRACT HAD SOME SECURITY HOLES
4 // THIS IS THE SECOND SMART CONTRACT
5 // OLD CONTRACT CAN BE SEEN AT https://etherscan.io/address/0xdd8f1fc3f9eb03e151abb5afcc42644e28a1e797
6 // DATA IS IMPORTED FROM THE LAST CONTRACT
7 // BIG SHOUTOUT TO CASTILLO NETWORK FOR FINDING THE SECURITY HOLE AND PERFORMING AN AUDIT ON THE LAST CONTRACT
8 // https://github.com/EthereumCommonwealth/Auditing
9 
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error
13  */
14 library SafeMath {
15 
16 	/**
17 	* @dev Multiplies two numbers, throws on overflow.
18 	*/
19 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20 		if (a == 0) {
21 			return 0;
22 		}
23 		c = a * b;
24 		assert(c / a == b);
25 		return c;
26 	}
27 
28 	/**
29 	* @dev Integer division of two numbers, truncating the quotient.
30 	*/
31 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
32 		// assert(b > 0); // Solidity automatically throws when dividing by 0
33 		// uint256 c = a / b;
34 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 		return a / b;
36 	}
37 
38 	/**
39 	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40 	*/
41 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42 		assert(b <= a);
43 		return a - b;
44 	}
45 
46 	/**
47 	* @dev Adds two numbers, throws on overflow.
48 	*/
49 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50 		c = a + b;
51 		assert(c >= a);
52 		return c;
53 	}
54 }
55 
56 // Create Ad on DappVolume
57 // Advertiser can choose 1 hour, 12 hours, 24 hours, or 1 week
58 // half of the money gets sent back to last advertiser
59 //
60 // An investor can earn 10% of the ad revenue
61 // Investors can get bought out by new investors
62 // when an invester is bought out, they get 120% of their investment back
63 
64 contract DappVolumeAd {
65 
66 	// import safemath
67 	using SafeMath for uint256;
68 
69 	// set variables
70 	uint256 public dappId;
71 	uint256 public purchaseTimestamp;
72 	uint256 public purchaseSeconds;
73 	uint256 public investmentMin;
74 	uint256 public adPriceHour;
75 	uint256 public adPriceHalfDay;
76 	uint256 public adPriceDay;
77 	uint256 public adPriceWeek;
78 	uint256 public adPriceMultiple;
79 	address public contractOwner;
80 	address public lastOwner;
81 	address public theInvestor;
82 
83 	// only contract owner
84 	modifier onlyContractOwner {
85 		require(msg.sender == contractOwner);
86 		_;
87 	}
88 
89 	// set constructor
90 	constructor() public {
91 		investmentMin = 4096000000000000000;
92 		adPriceHour = 5000000000000000;
93 		adPriceHalfDay = 50000000000000000;
94 		adPriceDay = 100000000000000000;
95 		adPriceWeek = 500000000000000000;
96 		adPriceMultiple = 2;
97 		contractOwner = msg.sender;
98 		theInvestor = 0x1C26d2dFDACe03F0F6D0AaCa233D00728b9e58da;
99 		lastOwner = contractOwner;
100 	}
101 
102 	// withdraw funds to contract creator
103 	function withdraw() public onlyContractOwner {
104 		contractOwner.transfer(address(this).balance);
105 	}
106 
107 	// set ad price multiple incase we want to up the price in the future
108 	function setAdPriceMultiple(uint256 amount) public onlyContractOwner {
109 		adPriceMultiple = amount;
110 	}
111 
112 	// update and set ad
113 	function updateAd(uint256 id) public payable {
114 		// set minimum amount and make sure ad hasnt expired
115 		require(msg.value >= adPriceMultiple.mul(adPriceHour));
116 		require(block.timestamp > purchaseTimestamp.add(purchaseSeconds));
117 		require(id > 0);
118 
119 		// send 10% to the investor
120 		theInvestor.send(msg.value.div(10));
121 		// send 50% of the money to the last person
122 		lastOwner.send(msg.value.div(2));
123 
124 		// set ad time limit in seconds
125 		if (msg.value >= adPriceMultiple.mul(adPriceWeek)) {
126 			purchaseSeconds = 604800; // 1 week
127 		} else if (msg.value >= adPriceMultiple.mul(adPriceDay)) {
128 			purchaseSeconds = 86400; // 1 day
129 		} else if (msg.value >= adPriceMultiple.mul(adPriceHalfDay)) {
130 			purchaseSeconds = 43200; // 12 hours
131 		} else {
132 			purchaseSeconds = 3600; // 1 hour
133 		}
134 
135 		// set dapp id
136 		dappId = id;
137 		// set new timestamp
138 		purchaseTimestamp = block.timestamp;
139 		// set last owner
140 		lastOwner = msg.sender;
141 	}
142 
143 	// update the investor
144 	function updateInvestor() public payable {
145 		require(msg.value >= investmentMin);
146 		// send 60% to last investor (120% of original purchase)
147 		theInvestor.send(msg.value.div(100).mul(60));
148 		// double the price to become the investor
149 		investmentMin = investmentMin.mul(2);
150 		// set new investor
151 		theInvestor = msg.sender;
152 	}
153 
154 	// get timestamp when ad ends
155 	function getPurchaseTimestampEnds() public view returns (uint _getPurchaseTimestampAdEnds) {
156 		return purchaseTimestamp.add(purchaseSeconds);
157 	}
158 
159 	// get contract balance
160 	function getBalance() public view returns(uint256){
161 		return address(this).balance;
162 	}
163 
164 }