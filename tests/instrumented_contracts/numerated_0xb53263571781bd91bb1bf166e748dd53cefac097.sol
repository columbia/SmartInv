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
28 contract AuctusToken {
29 	function transfer(address to, uint256 value) public returns (bool);
30 }
31 
32 
33 contract AuctusPreSale {
34 	function getTokenAmount(address who) constant returns (uint256);
35 }
36 
37 
38 contract ContractReceiver {
39 	function tokenFallback(address from, uint256 value, bytes data) public;
40 }
41 
42 
43 contract AuctusBonusDistribution is ContractReceiver {
44 	using SafeMath for uint256;
45 
46 	address public auctusTokenAddress = 0xc12d099be31567add4e4e4d0D45691C3F58f5663;
47 	address public auctusPreSaleAddress = 0x84D45E60f7036F0DE7dF8ed68E1Ee50471B963BA;
48 	uint256 public escrowedTokens;
49 	mapping(address => bool) public authorized;
50 	mapping(address => bool) public redeemed;
51 
52 	event Escrow(address indexed from, uint256 value);
53 	event Redeem(address indexed to, uint256 value);
54 
55 	modifier isAuthorized() {
56 		require(authorized[msg.sender]);
57 		_;
58 	}
59 
60 	function AuctusBonusDistribution() public {
61 		authorized[msg.sender] = true;
62 	}
63 
64 	function setAuthorization(address _address, bool _authorized) isAuthorized public {
65 		require(_address != address(0) && _address != msg.sender);
66 		authorized[_address] = _authorized;
67 	}
68 
69 	function drainAUC(uint256 value) isAuthorized public {
70 		assert(AuctusToken(auctusTokenAddress).transfer(msg.sender, value));
71 	}
72 
73 	function tokenFallback(address from, uint256 value, bytes) public {
74 		require(msg.sender == auctusTokenAddress);
75 		escrowedTokens = escrowedTokens.add(value);
76 		emit Escrow(from, value);
77 	}
78 
79 	function sendPreSaleBonusMany(address[] _addresses) isAuthorized public {
80 		for (uint256 i = 0; i < _addresses.length; i++) {
81 			sendPreSaleBonus(_addresses[i]);
82 		}
83 	}
84 
85 	function sendPreSaleBonus(address _address) public returns (bool) {
86 		if (!redeemed[_address]) {
87 			uint256 value = AuctusPreSale(auctusPreSaleAddress).getTokenAmount(_address).mul(12).div(100);
88 			if (value > 0) {
89 				redeemed[_address] = true;
90 				sendBonus(_address, value);
91 				return true;
92 			}
93 		}
94 		return false;
95 	}
96 
97 	function sendBonusMany(address[] _addresses, uint256[] _values) isAuthorized public {
98 		for (uint256 i = 0; i < _addresses.length; i++) {
99 			sendBonus(_addresses[i], _values[i]);
100 		}
101 	}
102 
103 	function sendBonus(address _address, uint256 value) internal {
104 		escrowedTokens = escrowedTokens.sub(value);
105 		assert(AuctusToken(auctusTokenAddress).transfer(_address, value));
106 		emit Redeem(_address, value);
107 	}
108 }