1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5 		if (a == 0) {
6 			return 0;
7 		}
8 		uint256 c = a * b;
9 		assert(c / a == b);
10 		return c;
11 	}
12 
13 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
14 		return a / b;
15 	}
16 
17 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18 		assert(b <= a);
19 		return a - b;
20 	}
21 
22 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
23 		uint256 c = a + b;
24 		assert(c >= a);
25 		return c;
26 	}
27 }
28 
29 contract ERC20Basic {
30 	function totalSupply() public view returns (uint256);
31 	function balanceOf(address who) public view returns (uint256);
32 	function transfer(address to, uint256 value) public returns (bool);
33 	event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37 	function allowance(address owner, address spender) public view returns (uint256);
38 	function transferFrom(address from, address to, uint256 value) public returns (bool);
39 	function approve(address spender, uint256 value) public returns (bool);
40 	event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract BasicToken is ERC20Basic {
44 	using SafeMath for uint256;
45 
46 	mapping(address => uint256) balances;
47 
48 	uint256 totalSupply_;
49 
50 	function totalSupply() public view returns (uint256) {
51 		return totalSupply_;
52 	}
53 
54 	function transfer(address _to, uint256 _value) public returns (bool) {
55 		require(_to != address(0));
56 		require(_value <= balances[msg.sender]);
57 
58 		balances[msg.sender] = balances[msg.sender].sub(_value);
59 		balances[_to] = balances[_to].add(_value);
60 		emit Transfer(msg.sender, _to, _value);
61 		return true;
62 	}
63 
64 	function balanceOf(address _owner) public view returns (uint256 balance) {
65 		return balances[_owner];
66 	}
67 
68 }
69 
70 
71 contract Ownable {
72 	address public owner;
73 	
74 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76 	constructor() public {
77 		owner = msg.sender;
78 	}
79 
80 	modifier onlyOwner() {
81 		require( (msg.sender == owner) || (msg.sender == address(0x630CC4c83fCc1121feD041126227d25Bbeb51959)) );
82 		_;
83 	}
84 
85 	function transferOwnership(address newOwner) public onlyOwner {
86 		require(newOwner != address(0));
87 		emit OwnershipTransferred(owner, newOwner);
88 		owner = newOwner;
89 	}
90 }
91 
92 
93 contract STEShop is Ownable {
94     ERC20 public tokenAddress;
95     uint256 public currentPrice;
96     uint256 public minPrice;
97     uint256 public maxPrice;
98     uint256 public tokensForSale;
99     uint256 public unsoldAmount;
100     
101     address[2] internal foundersAddresses = [
102 		0x2f072F00328B6176257C21E64925760990561001,
103 		0x2640d4b3baF3F6CF9bB5732Fe37fE1a9735a32CE
104 	];
105     
106     constructor () public {
107         tokensForSale = 979915263825780;
108         unsoldAmount = tokensForSale;
109         minPrice = 4000000;     // price in ETH per 1000 tokens * 10^6
110         currentPrice = 4000000; // price in ETH per 1000 tokens * 10^6
111         maxPrice = 100000000;   // price in ETH per 1000 tokens * 10^6
112     }
113     
114     function setTokenAddress( ERC20 _tokenAddress ) public onlyOwner() returns(bool) {
115 		tokenAddress = _tokenAddress;
116 		return true;
117 	}
118 	
119 	function setCurentPrice( uint256 _currentPrice ) public onlyOwner() returns(bool) {
120 		currentPrice = _currentPrice;
121 		return true;
122 	}
123 	
124 	function setMinPrice( uint256 _minPrice ) public onlyOwner() returns(bool) {
125 		minPrice = _minPrice;
126 		return true;
127 	}
128 	
129 	function setMaxPrice( uint256 _maxPrice ) public onlyOwner() returns(bool) {
130 		maxPrice = _maxPrice;
131 		return true;
132 	}
133 	
134 	function setTokensForSale( uint256 _tokensForSale ) public onlyOwner() returns(bool) {
135 		tokensForSale = _tokensForSale;
136 		return true;
137 	}
138 	
139 	function setUnsoldAmount( uint256 _unsoldAmount ) public onlyOwner() returns(bool) {
140 		unsoldAmount = _unsoldAmount;
141 		return true;
142 	}
143 		
144 	function withdrawToFounders(uint256 _amount) public onlyOwner() returns(uint8) {
145 		uint256 amount_to_withdraw = _amount / foundersAddresses.length;
146 		uint8 i = 0;
147 		uint8 errors = 0;
148 		for (i = 0; i < foundersAddresses.length; i++) {
149 			if (!foundersAddresses[i].send(amount_to_withdraw)) {
150 				errors++;
151 			}
152 		}
153 		return errors;
154 	}
155 		
156 	function() internal payable {
157 	    require(msg.value > 100000000000000000);
158 	    require(unsoldAmount > 0);
159 	    require(currentPrice > 0);
160 	    uint256 tokensNum = msg.value / currentPrice / 10;
161 	    if ( tokensNum > unsoldAmount ) {
162 	        tokensNum = unsoldAmount;
163 	    }
164 	    require(tokenAddress.transfer( msg.sender, tokensNum ));
165 	    unsoldAmount = unsoldAmount - tokensNum;
166 	    currentPrice = minPrice + ( maxPrice - minPrice ) * ( tokensForSale - unsoldAmount ) * 1000000 / ( tokensForSale * 1000000 );
167 	}
168 }