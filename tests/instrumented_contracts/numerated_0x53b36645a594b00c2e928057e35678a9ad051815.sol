1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5 		if (a == 0) return 0;
6 		uint256 c = a * b;
7 		assert(c / a == b);
8 		return c;
9 	}
10 
11 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
12 		uint256 c = a / b;
13 		return c;
14 	}
15 
16 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17 		assert(b <= a);
18 		return a - b;
19 	}
20 
21 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
22 		uint256 c = a + b;
23 		assert(c >= a);
24 		return c;
25 	}
26 }
27 
28 contract Ownable {
29 	address public owner;
30 
31 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33 	function Ownable() public {
34 		owner = msg.sender;
35 	}
36 
37 	modifier onlyOwner() {
38 		require(msg.sender == owner);
39 		_;
40 	}
41 
42 	function transferOwnership(address newOwner) public onlyOwner {
43 		require(newOwner != address(0));
44 		OwnershipTransferred(owner, newOwner);
45 		owner = newOwner;
46 	}
47 }
48 
49 contract Token {
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
51         (_from);
52         (_to);
53         (_value);
54 		return true;
55 	}
56 }
57 
58 contract Crowdsale2 is Ownable {
59 	
60 	using SafeMath for uint256;
61 
62 	Token public token;
63 	
64 	address public wallet;
65 	
66 	address public destination;
67 
68 	uint256 public startTime;
69 	
70 	uint256 public endTime;
71 
72 	uint256 public rate;
73 
74 	uint256 public tokensSold;
75 	
76 	uint256 public weiRaised;
77 
78 	event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
79 
80 	function Crowdsale2(address _token, address _wallet, address _destination, uint256 _startTime, uint256 _endTime, uint256 _rate) public {
81 		startTime = _startTime;
82 		endTime = _endTime;
83 		rate = _rate;
84 		token = Token(_token);
85 		wallet = _wallet;
86 		destination = _destination;
87 	}
88 
89 	function () external payable {
90 		require(validPurchase());
91 
92 		uint256 amount = msg.value;
93 		uint256 tokens = amount.mul(rate) / (1 ether);
94 
95 		weiRaised = weiRaised.add(amount);
96 		tokensSold = tokensSold.add(tokens);
97 
98 		token.transferFrom(wallet, msg.sender, tokens);
99 		TokenPurchase(msg.sender, amount, tokens);
100 
101 		destination.transfer(amount);
102 	}
103 
104 	function validPurchase() internal view returns (bool) {
105 		bool withinPeriod = now >= startTime && now <= endTime;
106 		bool nonZeroPurchase = msg.value != 0;
107 		return withinPeriod && nonZeroPurchase;
108 	}
109 
110 	function setEndTime(uint256 _endTime) public onlyOwner returns (bool) {
111 		endTime = _endTime;
112 		return true;
113 	}
114 
115 	function hasEnded() public view returns (bool) {
116 		return now > endTime;
117 	}
118 }