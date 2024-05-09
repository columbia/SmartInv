1 pragma solidity ^0.4.24;
2 
3 // THE LAST SMART CONTRACT HAD SOME SECURITY HOLES
4 // THIS IS THE SECOND SMART CONTRACT FOR THE LIKE FEATURE
5 // OLD CONTRACT CAN BE SEEN AT https://etherscan.io/address/0x6acd16200a2a046bf207d1b263202ec1a75a7d51
6 // DATA IS IMPORTED FROM THE LAST CONTRACT
7 // BIG SHOUTOUT TO CASTILLO NETWORK FOR FINDING THE SECURITY HOLE AND PERFORMING AN AUDIT ON THE LAST CONTRACT
8 // https://github.com/EthereumCommonwealth/Auditing
9 
10 // Old contract data
11 contract dappVolumeHearts {
12 	// map dapp ids with heart totals
13 	mapping(uint256 => uint256) public totals;
14 	// get total hearts by id
15 	function getTotalHeartsByDappId(uint256 dapp_id) public view returns(uint256) {
16 		return totals[dapp_id];
17 	}
18 }
19 
20 // Allows users to "heart" (like) a DAPP by dapp id
21 // 1 Like = XXXXX eth will be set on front end of site
22 // 50% of each transaction gets sent to the last liker
23 
24 contract DappVolumeHearts {
25 
26 	dappVolumeHearts firstContract;
27 
28 	using SafeMath for uint256;
29 
30 	// set contract owner
31 	address public contractOwner;
32 	// set last address transacted
33 	address public lastAddress;
34 	// set first contracts address
35 	address constant public firstContractAddress = 0x6ACD16200a2a046bf207D1B263202ec1A75a7D51;
36 	// map dapp ids with heart totals ( does not count first contract )
37 	mapping(uint256 => uint256) public totals;
38 
39 	// only contract owner
40 	modifier onlyContractOwner {
41 		require(msg.sender == contractOwner);
42 		_;
43 	}
44 
45 	// set constructor
46 	constructor() public {
47 		contractOwner = msg.sender;
48 		lastAddress = msg.sender;
49 		firstContract = dappVolumeHearts(firstContractAddress);
50 	}
51 
52 
53 	// withdraw funds to contract creator
54 	function withdraw() public onlyContractOwner {
55 		contractOwner.transfer(address(this).balance);
56 	}
57 
58 	// update heart count
59 	function update(uint256 dapp_id) public payable {
60 		require(msg.value >= 2000000000000000);
61 		require(dapp_id > 0);
62 		totals[dapp_id] = totals[dapp_id].add(msg.value);
63 		// send 50% of the money to the last person
64 		lastAddress.send(msg.value.div(2));
65 		lastAddress = msg.sender;
66 	}
67 
68 	// get total hearts by id with legacy contract totaled in
69 	function getTotalHeartsByDappId(uint256 dapp_id) public view returns(uint256) {
70 		return totals[dapp_id].add(firstContract.getTotalHeartsByDappId(dapp_id));
71 	}
72 
73 	// get contract balance
74 	function getBalance() public view returns(uint256){
75 		return address(this).balance;
76 	}
77 
78 }
79 
80 /**
81  * @title SafeMath
82  * @dev Math operations with safety checks that throw on error
83  */
84 library SafeMath {
85 
86 	/**
87 	* @dev Multiplies two numbers, throws on overflow.
88 	*/
89 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
90 		if (a == 0) {
91 			return 0;
92 		}
93 		c = a * b;
94 		assert(c / a == b);
95 		return c;
96 	}
97 
98 	/**
99 	* @dev Integer division of two numbers, truncating the quotient.
100 	*/
101 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
102 		// assert(b > 0); // Solidity automatically throws when dividing by 0
103 		// uint256 c = a / b;
104 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
105 		return a / b;
106 	}
107 
108 	/**
109 	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
110 	*/
111 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112 		assert(b <= a);
113 		return a - b;
114 	}
115 
116 	/**
117 	* @dev Adds two numbers, throws on overflow.
118 	*/
119 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
120 		c = a + b;
121 		assert(c >= a);
122 		return c;
123 	}
124 }