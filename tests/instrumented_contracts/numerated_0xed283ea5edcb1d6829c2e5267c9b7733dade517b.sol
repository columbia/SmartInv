1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Owned
5  * @dev Contract that sets an owner, who can execute predefined functions, only accessible by him
6  */
7 contract Owned {
8 	address public owner;
9 
10 	constructor() public {
11 		owner = msg.sender;
12 	}
13 
14 	modifier onlyOwner {
15 		require(msg.sender == owner);
16 		_;
17 	}
18 
19 	function transferOwnership(address newOwner) onlyOwner public {
20 		require(newOwner != 0x0);
21 		owner = newOwner;
22 	}
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Mathematical functions to check for overflows
28  */
29 contract SafeMath {
30 	function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
31 		uint256 c = a + b;
32 		assert(c >= a && c >= b);
33 
34 		return c;
35 	}
36 }
37 
38 contract CURESSale is Owned, SafeMath {
39 	uint256 public maxGoal = 175000 * 1 ether;			// Hard Cap in Ethereum
40 	uint256 public minTransfer = 5 * 1 ether;			// Minimum amount in EHT that can be send
41 	uint256 public amountRaised = 0;					// The raised amount in ETH Wei
42 	mapping(address => uint256) public payments;		// How much ETH the user sent
43 	bool public isFinalized = false;					// Indicates if the Private Sale is finalized
44 
45 	// Public event on the blockchain, to notify users when a Payment is made
46 	event PaymentMade(address indexed _from, uint256 _ammount);
47 
48 	/**
49 	 * @dev The default function called when anyone sends funds (ETH) to the contract
50 	 */
51 	function() payable public {
52 		buyTokens();
53 	}
54 
55 	function buyTokens() payable public returns (bool success) {
56 		// Check if finalized
57 		require(!isFinalized);
58 
59 		uint256 amount = msg.value;
60 
61 		// Check if the goal is reached
62 		uint256 collectedEth = safeAdd(amountRaised, amount);
63 		require(collectedEth <= maxGoal);
64 
65 		require(amount >= minTransfer);
66 
67 		payments[msg.sender] = safeAdd(payments[msg.sender], amount);
68 		amountRaised = safeAdd(amountRaised, amount);
69 
70 		owner.transfer(amount);
71 
72 		emit PaymentMade(msg.sender, amount);
73 		return true;
74 	}
75 
76 	// In case of any ETH left at the contract
77 	// Can be used only after the Sale is finalized
78 	function withdraw(uint256 _value) public onlyOwner {
79 		require(isFinalized);
80 		require(_value > 0);
81 
82 		msg.sender.transfer(_value);
83 	}
84 
85 	function changeMinTransfer(uint256 min) external onlyOwner {
86 		require(!isFinalized);
87 
88 		require(min > 0);
89 
90 		minTransfer = min;
91 	}
92 
93 	// CURES finalizes the Sale
94 	function finalize() external onlyOwner {
95 		require(!isFinalized);
96 
97 		// Finalize the Sale
98 		isFinalized = true;
99 	}
100 }