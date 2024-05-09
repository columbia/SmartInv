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
15 }
16 
17 
18 contract AuctusToken {
19 	function transfer(address to, uint256 value) public returns (bool);
20 }
21 
22 
23 contract AuctusPreSale {
24 	function getTokenAmount(address who) constant returns (uint256);
25 }
26 
27 
28 contract ContractReceiver {
29 	function tokenFallback(address from, uint256 value, bytes data) public;
30 }
31 
32 
33 contract AuctusPreSaleDistribution is ContractReceiver {
34 	using SafeMath for uint256;
35 
36 	address public auctusTokenAddress = 0xfD89de68b246eB3e21B06e9B65450AC28D222488;
37 	address public auctusPreSaleAddress = 0x84D45E60f7036F0DE7dF8ed68E1Ee50471B963BA;
38 	uint256 public escrowedTokens;
39 	address public owner;
40 	mapping(address => bool) public redeemed;
41 
42 	event Escrow(address indexed from, uint256 value);
43 	event Redeem(address indexed to, uint256 value);
44 
45 	function AuctusPreSaleDistribution() public {
46 		owner = msg.sender;
47 	}
48 
49 	modifier onlyOwner() {
50 		require(owner == msg.sender);
51 		_;
52 	}
53 
54 	function transferOwnership(address newOwner) onlyOwner public {
55 		require(newOwner != address(0));
56 		owner = newOwner;
57 	}
58 
59 	function tokenFallback(address from, uint256 value, bytes) public {
60 		require(msg.sender == auctusTokenAddress);
61 		escrowedTokens = escrowedTokens.add(value);
62 		emit Escrow(from, value);
63 	}
64 
65 	function redeemMany(address[] _addresses) onlyOwner public {
66 		for (uint256 i = 0; i < _addresses.length; i++) {
67 			redeemPreSale(_addresses[i]);
68 		}
69 	}
70 
71 	function redeemPreSale(address _address) public returns (bool) {
72 		if (!redeemed[_address]) {
73 			uint256 value = AuctusPreSale(auctusPreSaleAddress).getTokenAmount(_address);
74 			if (value > 0) {
75 				redeemed[_address] = true;
76 				escrowedTokens = escrowedTokens.sub(value);
77 				assert(AuctusToken(auctusTokenAddress).transfer(_address, value));
78 				emit Redeem(_address, value);
79 				return true;
80 			}
81 		}
82 		return false;
83 	}
84 }