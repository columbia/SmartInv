1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.2;
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function totalMinted() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 contract FROGE is IERC20 {
11 
12     bytes32 public constant name = "FROGE";
13     bytes32 public constant symbol = "FROGE";
14     uint8 public constant decimals = 18;
15 
16     event Mint(address indexed to, uint256 amount);	
17     mapping(address => uint256) balances;
18 	
19 	address public owner;
20     uint256 totalSupply_;
21     uint256 minted_;
22     using SafeMath for uint256;
23 	
24 	constructor() {
25 		totalSupply_ = 1000000000000000000000000000;
26 		owner = msg.sender;
27     }
28 
29     modifier onlyOwner() {
30         require(msg.sender == owner);
31         _;
32     }
33 	
34     function totalSupply() public override view returns (uint256) {
35 		return totalSupply_;
36     }
37     
38     function totalMinted() public override view returns (uint256) {
39 		return minted_;
40     }
41 	
42     function balanceOf(address tokenOwner) public override view returns (uint256) {
43         return balances[tokenOwner];
44     }
45 	
46     function transfer(address receiver, uint256 numTokens) public override returns (bool) {
47         require(numTokens <= balances[msg.sender]);
48         balances[msg.sender] = balances[msg.sender].sub(numTokens);
49         balances[receiver] = balances[receiver].add(numTokens);
50         emit Transfer(msg.sender, receiver, numTokens);
51         return true;
52     }
53     
54     function mint(address receiver, uint256 numTokens) public onlyOwner returns (bool) {
55         minted_ = minted_.add(numTokens);
56         require(minted_ <= totalSupply_);
57         
58         balances[receiver] = balances[receiver].add(numTokens);
59         emit Mint(receiver, numTokens);
60         return true;
61     }
62 	
63 	function transferOwner(address newOwnerAddress) public onlyOwner returns (bool) {
64 		if (newOwnerAddress != address(0)) {
65 			owner = newOwnerAddress;
66 			return true;
67 		}else{
68 		    return false;
69 		}
70 	}
71 	
72 }
73 
74 library SafeMath {
75 	
76 	function fxpMul(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
77 		return div(mul(a, b), base);
78 	}
79 		
80 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
81 		uint256 c = a + b;
82 		require(c >= a, "SafeMath: addition overflow");
83 		return c;
84 	}
85 
86 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87 		require(b <= a, "SafeMath: subtraction overflow");
88 		uint256 c = a - b;
89 		return c;
90 	}
91 
92 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93 		if (a == 0) {
94 			return 0;
95 		}
96 		uint256 c = a * b;
97 		require(c / a == b, "SafeMath: multiplication overflow");
98 		return c;
99 	}
100 
101 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
102 		require(b > 0, "SafeMath: division by zero");
103 		uint256 c = a / b;
104 		return c;
105 	}
106 }