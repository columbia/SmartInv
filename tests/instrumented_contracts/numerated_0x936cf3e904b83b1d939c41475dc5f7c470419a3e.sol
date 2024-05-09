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
18 contract ContractReceiver {
19 	function tokenFallback(address from, uint256 value, bytes data) public;
20 }
21 
22 
23 contract AuctusToken {
24 	function transfer(address to, uint256 value) public returns (bool);
25 }
26 
27 
28 contract AuctusBountyDistribution is ContractReceiver {
29 	using SafeMath for uint256;
30 
31 	address public auctusTokenAddress = 0xfD89de68b246eB3e21B06e9B65450AC28D222488;
32 	address public owner;
33 	uint256 public escrowedTokens;
34 	mapping(address => bool) public redeemed;
35 
36 	event Escrow(address indexed from, uint256 value);
37 	event Redeem(address indexed to, uint256 value);
38 
39 	function AuctusBountyDistribution() public {
40 		owner = msg.sender;
41 	}
42 
43 	modifier onlyOwner() {
44 		require(owner == msg.sender);
45 		_;
46 	}
47 
48 	modifier isValidMessage(uint256 value, uint256 timelimit, uint8 v, bytes32 r, bytes32 s) {
49 		require(owner == ecrecover(keccak256("\x19Ethereum Signed Message:\n32", keccak256(this, msg.sender, value, timelimit)), v, r, s));
50 		_;
51 	}
52 
53 	function transferOwnership(address newOwner) onlyOwner public {
54 		require(newOwner != address(0));
55 		owner = newOwner;
56 	}
57 
58 	function tokenFallback(address from, uint256 value, bytes) public {
59 		require(msg.sender == auctusTokenAddress);
60 		escrowedTokens = escrowedTokens.add(value);
61 		emit Escrow(from, value);
62 	}
63 
64 	function redeemBounty(
65 		uint256 value,
66 		uint256 timelimit,
67 		uint8 v,
68 		bytes32 r,
69 		bytes32 s
70 	)
71 		isValidMessage(value, timelimit, v, r, s)
72 		public 
73 	{
74 		require(timelimit >= now);
75 		require(!redeemed[msg.sender]);
76 		redeemed[msg.sender] = true;
77 		internalRedeem(msg.sender, value);
78 	}
79 
80 	function forcedRedeem(address to, uint256 value) onlyOwner public {
81 		internalRedeem(to, value);
82 	}
83 
84 	function internalRedeem(address to, uint256 value) private {
85 		escrowedTokens = escrowedTokens.sub(value);
86 		assert(AuctusToken(auctusTokenAddress).transfer(to, value));
87 		emit Redeem(to, value);
88 	}
89 }