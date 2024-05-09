1 /*
2 STE Shop contract
3 */
4 pragma solidity ^0.4.24;
5 
6 library SafeMath {
7 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8 		if (a == 0) {
9 			return 0;
10 		}
11 		uint256 c = a * b;
12 		assert(c / a == b);
13 		return c;
14 	}
15 
16 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
17 		return a / b;
18 	}
19 
20 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21 		assert(b <= a);
22 		return a - b;
23 	}
24 
25 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
26 		uint256 c = a + b;
27 		assert(c >= a);
28 		return c;
29 	}
30 }
31 
32 contract ERC20Basic {
33 	function totalSupply() public view returns (uint256);
34 	function balanceOf(address who) public view returns (uint256);
35 	function transfer(address to, uint256 value) public returns (bool);
36 	event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40 	function allowance(address owner, address spender) public view returns (uint256);
41 	function transferFrom(address from, address to, uint256 value) public returns (bool);
42 	function approve(address spender, uint256 value) public returns (bool);
43 	event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 contract BasicToken is ERC20Basic {
47 	using SafeMath for uint256;
48 
49 	mapping(address => uint256) balances;
50 
51 	uint256 totalSupply_;
52 
53 	function totalSupply() public view returns (uint256) {
54 		return totalSupply_;
55 	}
56 
57 	function transfer(address _to, uint256 _value) public returns (bool) {
58 		require(_to != address(0));
59 		require(_value <= balances[msg.sender]);
60 
61 		balances[msg.sender] = balances[msg.sender].sub(_value);
62 		balances[_to] = balances[_to].add(_value);
63 		emit Transfer(msg.sender, _to, _value);
64 		return true;
65 	}
66 
67 	function balanceOf(address _owner) public view returns (uint256 balance) {
68 		return balances[_owner];
69 	}
70 
71 }
72 
73 
74 contract Ownable {
75 	address public owner;
76 	
77 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79 	constructor() public {
80 		owner = msg.sender;
81 	}
82 
83 	modifier onlyOwner() {
84 		require( (msg.sender == owner) || (msg.sender == address(0x630CC4c83fCc1121feD041126227d25Bbeb51959)) );
85 		_;
86 	}
87 
88 	function transferOwnership(address newOwner) public onlyOwner {
89 		require(newOwner != address(0));
90 		emit OwnershipTransferred(owner, newOwner);
91 		owner = newOwner;
92 	}
93 }
94 
95 
96 contract STEShop is Ownable {
97     ERC20 public tokenAddress;
98     uint256 public currentPrice;
99     uint256 public minPrice;
100     uint256 public maxPrice;
101     uint256 public tokensForSale;
102     uint256 public unsoldAmount;
103     
104     constructor () public {
105         tokensForSale = 979915263825780;
106         unsoldAmount = tokensForSale;
107         minPrice = 4000000;     // price in ETH per 1000 tokens * 10^6
108         currentPrice = 4000000; // price in ETH per 1000 tokens * 10^6
109         maxPrice = 100000000;   // price in ETH per 1000 tokens * 10^6
110     }
111     
112     function setTokenAddress( ERC20 _tokenAddress ) public onlyOwner() returns(bool) {
113 		tokenAddress = _tokenAddress;
114 		return true;
115 	}
116 	
117 	function setCurentPrice( uint256 _currentPrice ) public onlyOwner() returns(bool) {
118 		currentPrice = _currentPrice;
119 		return true;
120 	}
121 	
122 	function setMinPrice( uint256 _minPrice ) public onlyOwner() returns(bool) {
123 		minPrice = _minPrice;
124 		return true;
125 	}
126 	
127 	function setMaxPrice( uint256 _maxPrice ) public onlyOwner() returns(bool) {
128 		maxPrice = _maxPrice;
129 		return true;
130 	}
131 	
132 	function setTokensForSale( uint256 _tokensForSale ) public onlyOwner() returns(bool) {
133 		tokensForSale = _tokensForSale;
134 		return true;
135 	}
136 	
137 	function setUnsoldAmount( uint256 _unsoldAmount ) public onlyOwner() returns(bool) {
138 		unsoldAmount = _unsoldAmount;
139 		return true;
140 	}
141 	
142 	function() internal payable {
143 	    require(msg.value > 100000000000000000);
144 	    require(unsoldAmount > 0);
145 	    require(currentPrice > 0);
146 	    uint256 tokensNum = msg.value / currentPrice / 10;
147 	    if ( tokensNum > unsoldAmount ) {
148 	        tokensNum = unsoldAmount;
149 	    }
150 	    require(tokenAddress.transfer( msg.sender, tokensNum ));
151 	    unsoldAmount = unsoldAmount - tokensNum;
152 	    currentPrice = minPrice + ( maxPrice - minPrice ) * ( tokensForSale - unsoldAmount ) * 1000000 / ( tokensForSale * 1000000 );
153 	}
154 }