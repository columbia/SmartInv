1 pragma solidity 0.4.18;
2 
3 contract Ownable {
4 	address public owner;
5 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7 	function Ownable() {
8 		owner = msg.sender;
9 	}
10 
11 	modifier onlyOwner() {
12 		require(msg.sender == owner);
13 		_;
14 	}
15 
16 	function transferOwnership(address newOwner) onlyOwner public {
17 		require(newOwner != address(0));
18 		OwnershipTransferred(owner, newOwner);
19 		owner = newOwner;
20 	}
21 }
22 
23 library SafeMath {
24 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
25 		uint256 c = a * b;
26 		assert(a == 0 || c / a == b);
27 		return c;
28 	}
29 
30 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
31 		uint256 c = a / b;
32 		return c;
33 	}
34 
35 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36 		assert(b <= a);
37 		return a - b;
38 	}
39 
40 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
41 		uint256 c = a + b;
42 		assert(c >= a);
43 		return c;
44 	}
45 }
46 
47 contract ERC20 {
48 	uint256 public totalSupply;
49 	function balanceOf(address who) public constant returns (uint256);
50 	function transfer(address to, uint256 value) public returns (bool);
51 	event Transfer(address indexed from, address indexed to, uint256 value);
52 
53 	function allowance(address owner, address spender) public constant returns (uint256);
54 	function transferFrom(address from, address to, uint256 value) public returns (bool);
55 	function approve(address spender, uint256 value) public returns (bool);
56 	event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract StandardToken is ERC20 {
60 	using SafeMath for uint256;
61 
62 	mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64 
65 	function transfer(address _to, uint256 _value) public returns (bool) {
66 		require(_to != address(0));
67 
68 		balances[msg.sender] = balances[msg.sender].sub(_value);
69 		balances[_to] = balances[_to].add(_value);
70 		Transfer(msg.sender, _to, _value);
71 		return true;
72 	}
73 
74 	function balanceOf(address _owner) public constant returns (uint256 balance) {
75 		return balances[_owner];
76 	}
77 
78 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79 		require(_to != address(0));
80 
81 		uint256 _allowance = allowed[_from][msg.sender];
82 
83 		balances[_from] = balances[_from].sub(_value);
84 		balances[_to] = balances[_to].add(_value);
85 		allowed[_from][msg.sender] = _allowance.sub(_value);
86 		Transfer(_from, _to, _value);
87 		return true;
88 	}
89 
90 	function approve(address _spender, uint256 _value) public returns (bool) {
91 		allowed[msg.sender][_spender] = _value;
92 		Approval(msg.sender, _spender, _value);
93 		return true;
94 	}
95 
96 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
97 		return allowed[_owner][_spender];
98 	}
99 }
100 
101 contract LBToken is StandardToken {
102 	string public constant name = "LB Token";
103     string public constant symbol = "LB";
104     uint8  public constant decimals = 18;
105 
106 	address public minter; 
107 	uint    public tokenSaleEndTime; 
108 
109 	modifier onlyMinter {
110 		require (msg.sender == minter);
111 		_;
112 	}
113 
114 	modifier whenMintable {
115 		require (now <= tokenSaleEndTime);
116 		_;
117 	}
118 
119     modifier validDestination(address to) {
120         require(to != address(this));
121         _;
122     }
123 
124 	function LBToken(address _minter, uint _tokenSaleEndTime) public {
125 		minter = _minter;
126 		tokenSaleEndTime = _tokenSaleEndTime;
127     }
128 
129 	function transfer(address _to, uint _value)
130         public
131         validDestination(_to)
132         returns (bool) 
133     {
134         return super.transfer(_to, _value);
135     }
136 
137 	function transferFrom(address _from, address _to, uint _value)
138         public
139         validDestination(_to)
140         returns (bool) 
141     {
142         return super.transferFrom(_from, _to, _value);
143     }
144 
145 	function createToken(address _recipient, uint _value)
146 		whenMintable
147 		onlyMinter
148 		returns (bool)
149 	{
150 		balances[_recipient] += _value;
151 		totalSupply += _value;
152 		return true;
153 	}
154 }