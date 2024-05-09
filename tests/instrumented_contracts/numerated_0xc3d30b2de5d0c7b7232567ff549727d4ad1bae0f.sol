1 pragma solidity ^0.4.18;
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
14 		// assert(b > 0); // Solidity automatically throws when dividing by 0
15 		uint256 c = a / b;
16 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
17 		return c;
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
32 contract Ownable {
33 	address public owner;
34 
35 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37 	function Ownable() public {
38 		owner = msg.sender;
39 	}
40 
41 	modifier onlyOwner() {
42 		require(msg.sender == owner);
43 		_;
44 	}
45 
46 	function transferOwnership(address newOwner) public onlyOwner {
47 		require(newOwner != address(0));
48 		OwnershipTransferred(owner, newOwner);
49 		owner = newOwner;
50 	}
51 }
52 
53 contract ERC20Basic {
54 	uint256 public totalSupply;
55 	uint256 freezeTransferTime;
56 	function balanceOf(address who) public constant returns (uint256);
57 	function transfer(address to, uint256 value) public returns (bool);
58 	event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 contract ERC20 is ERC20Basic {
62 	function allowance(address owner, address spender) public constant returns (uint256);
63 	function transferFrom(address from, address to, uint256 value) public returns (bool);
64 	function approve(address spender, uint256 value) public returns (bool);
65 	event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 contract BasicToken is ERC20Basic {
69 
70 	using SafeMath for uint256;
71 	mapping(address => uint256) balances;
72 
73 	function transfer(address _to, uint256 _value) public returns (bool) {
74 		require(_to != address(0));
75         require(now >= freezeTransferTime);
76 		balances[msg.sender] = balances[msg.sender].sub(_value);
77 		balances[_to] = balances[_to].add(_value);
78 		Transfer(msg.sender, _to, _value);
79 		return true;
80 	}
81 
82 	function balanceOf(address _owner) public constant returns (uint256 balance) {
83 		return balances[_owner];
84 	}
85 }
86 
87 contract StandardToken is ERC20, BasicToken {
88 
89 	mapping (address => mapping (address => uint256)) allowed;
90 
91 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
92 		require(_to != address(0));
93 		require(now >= freezeTransferTime);
94 
95 		var _allowance = allowed[_from][msg.sender];
96 		balances[_to] = balances[_to].add(_value);
97 		balances[_from] = balances[_from].sub(_value);
98 		allowed[_from][msg.sender] = _allowance.sub(_value);
99 		Transfer(_from, _to, _value);
100 		return true;
101 	}
102 
103 	function approve(address _spender, uint256 _value) public returns (bool) {
104 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
105 		allowed[msg.sender][_spender] = _value;
106 		Approval(msg.sender, _spender, _value);
107 		return true;
108 	}
109 
110 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
111 		return allowed[_owner][_spender];
112 	}
113 }
114 
115 contract MintableToken is StandardToken, Ownable {
116 
117 	event Mint(address indexed to, uint256 amount);
118 	event MintFinished();
119 
120 	bool public mintingFinished = false;
121 
122 	modifier canMint() {
123 		require(!mintingFinished);
124 		_;
125 	}
126 
127 	function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
128 		totalSupply = totalSupply.add(_amount);
129 		balances[_to] = balances[_to].add(_amount);
130 		Mint(_to, _amount);
131 		return true;
132 	}
133 
134 	function finishMinting() public onlyOwner returns (bool) {
135 		mintingFinished = true;
136 		MintFinished();
137 		return true;
138 	}
139 }
140 
141 contract SIGToken is MintableToken {
142 
143 	string public constant name = "Saxinvest Group Coin";
144 	string public constant symbol = "SIG";
145 	uint32 public constant decimals = 18;
146 
147 	function SIGToken(uint256 _freezeTransferTime) public {
148 		freezeTransferTime = _freezeTransferTime;
149 	}
150 }