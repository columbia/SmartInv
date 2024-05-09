1 pragma solidity ^0.4.20;
2 
3 
4 library SafeMath {
5 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
6 		uint256 c = a + b;
7 		assert(a <= c);
8 		return c;
9 	}
10 	
11 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12 		uint256 c = a * b;
13 		assert(a == 0 || c / a == b);
14 		return c;
15 	}
16 
17 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
18 		return a / b;
19 	}
20 }
21 
22 
23 contract RailMinegalievPrivateSale {
24 	using SafeMath for uint256;
25 
26 	uint256 public tokenPurchased;
27 	uint256 public amountPurchasedWithDecimals;
28 	uint256 public weiToReceive;
29 	uint256 public pricePerEther;
30 	uint256 public timeLimit; 
31 	address public buyerAddress;
32 	address public owner;
33 	bool public purchaseHalted;
34 	
35 	event Buy(address indexed recipient, uint256 tokenAmountWithDecimals, uint256 price);
36 	
37 	modifier onlyOwner() {
38 		require(msg.sender == owner);
39 		_;
40 	}
41 
42 	function RailMinegalievPrivateSale(
43 	    uint256 amount,
44 		uint256 price,
45 		uint256 limit,
46 		address buyer) 
47 		public
48 	{
49 		owner = msg.sender;
50 		purchaseHalted = false;
51 		weiToReceive = amount * (1 ether);
52 		pricePerEther = price;
53 		timeLimit = limit;
54 		buyerAddress = buyer;
55 	}
56 	
57 	function() 
58 		payable 
59 		public
60 	{
61 		require(!purchaseHalted);
62 		require(weiToReceive == msg.value);
63 		require(buyerAddress == msg.sender);
64 		require(now <= timeLimit);
65 		
66 		uint256 currentPurchase = msg.value.mul(pricePerEther);
67 		amountPurchasedWithDecimals = amountPurchasedWithDecimals.add(currentPurchase);
68 		tokenPurchased = tokenPurchased.add(currentPurchase.div(1 ether));
69 		purchaseHalted = true;
70 		owner.transfer(msg.value);
71 
72 		Buy(msg.sender, currentPurchase, pricePerEther);
73 	}
74 	
75 	function transferOwnership(address newOwner) onlyOwner public {
76         owner = newOwner;
77     }
78 	
79 	function setPrivateSaleHalt(bool halted) onlyOwner public {
80 		purchaseHalted = halted;
81 	}
82 	
83 	function setTimeLimit(uint256 newTimeLimit) onlyOwner public {
84 		timeLimit = newTimeLimit;
85 	}
86 	
87 	function setAmountToReceive(uint256 newAmountToReceive) onlyOwner public {
88 		weiToReceive = newAmountToReceive * (1 ether);
89 	}
90 	
91 	function setPrice(uint256 newPrice) onlyOwner public {
92 		pricePerEther = newPrice;
93 	}
94 	
95 	function setBuyerAddress(address newBuyerAddress) onlyOwner public {
96 		buyerAddress = newBuyerAddress;
97 	}
98 }