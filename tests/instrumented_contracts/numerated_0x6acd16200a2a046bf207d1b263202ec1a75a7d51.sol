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
49 // Allows users to "heart" (like) a DAPP by dapp id
50 // 1 Like = XXXXX eth will be set on front end of site
51 // 50% of each transaction gets sent to the last liker
52 
53 contract dappVolumeHearts {
54 
55 	using SafeMath for uint256;
56 
57 	// set contract owner
58 	address public contractOwner;
59 	// set last address transacted
60 	address public lastAddress;
61 
62 	// only contract owner
63 	modifier onlyContractOwner {
64 		require(msg.sender == contractOwner);
65 		_;
66 	}
67 
68 	// set constructor
69 	constructor() public {
70 		contractOwner = msg.sender;
71 	}
72 
73 	// withdraw funds to contract creator
74 	function withdraw() public onlyContractOwner {
75 		contractOwner.transfer(address(this).balance);
76 	}
77 
78 	// map dapp ids with heart totals
79 	mapping(uint256 => uint256) public totals;
80 
81 	// update heart count
82 	function update(uint256 dapp_id) public payable {
83 		require(msg.value > 1900000000000000);
84 		totals[dapp_id] = totals[dapp_id] + msg.value;
85 		// send 50% of the money to the last person
86 		lastAddress.transfer(msg.value.div(2));
87 		lastAddress = msg.sender;
88 	}
89 
90 	// get total hearts by id
91 	function getTotalHeartsByDappId(uint256 dapp_id) public view returns(uint256) {
92 		return totals[dapp_id];
93 	}
94 
95 	// get contract balance
96 	function getBalance() public view returns(uint256){
97 		return address(this).balance;
98 	}
99 
100 }