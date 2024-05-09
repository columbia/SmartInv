1 pragma solidity ^0.4.9;
2 
3 contract ERC20 {
4 	string public name;
5 	string public symbol;
6 	uint8 public decimals = 8;
7 
8 	uint public totalSupply;
9 	function balanceOf(address _owner) public constant returns (uint balance);
10 	function transfer(address _to, uint256 _value) public returns (bool success);
11 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12 	function approve(address _spender, uint256 _value) public returns (bool success);
13 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
14 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
15 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 }
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
24 		uint256 c = a * b;
25 		assert(a == 0 || c / a == b);
26 		return c;
27 	}
28 
29 	/* function div(uint256 a, uint256 b) internal constant returns (uint256) {
30 		// assert(b > 0); // Solidity automatically throws when dividing by 0
31 		uint256 c = a / b;
32 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 		return c;
34 	} */
35 
36 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
37 		assert(b <= a);
38 		return a - b;
39 	}
40 
41 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
42 		uint256 c = a + b;
43 		assert(c >= a);
44 		return c;
45 	}
46 }
47 
48 contract owned {
49 	address public owner;
50 
51 	function owned() public {
52 		owner = msg.sender;
53 	}
54 
55 	modifier onlyOwner {
56 		require(msg.sender == owner);
57 		_;
58 	}
59 
60 	function transferOwnership(address newOwner) public onlyOwner {
61 		owner = newOwner;
62 	}
63 }
64 
65 contract BazistaToken is ERC20, owned {
66 	using SafeMath for uint256;
67 
68 	string public name = 'Bazista Token';
69 	string public symbol = 'BZS';
70 
71 	uint256 public totalSupply = 44000000000000000;
72 
73 	address public icoWallet;
74 	uint256 public icoSupply = 33440000000000000;
75 
76 	address public advisorsWallet;
77 	uint256 public advisorsSupply = 1320000000000000;
78 
79 	address public teamWallet;
80 	uint256 public teamSupply = 6600000000000000;
81 
82 	address public marketingWallet;
83 	uint256 public marketingSupply = 1760000000000000;
84 
85 	address public bountyWallet;
86 	uint256 public bountySupply = 880000000000000;
87 
88 	mapping(address => uint) balances;
89 	mapping (address => mapping (address => uint256)) allowed;
90 
91 	modifier onlyPayloadSize(uint size) {
92 		require(msg.data.length >= (size + 4));
93 		_;
94 	}
95 
96 	function BazistaToken () public {
97 		balances[this] = totalSupply;
98 	}
99 
100 
101 	function setWallets(address _advisorsWallet, address _teamWallet, address _marketingWallet, address _bountyWallet) public onlyOwner {
102 		advisorsWallet = _advisorsWallet;
103 		_transferFrom(this, advisorsWallet, advisorsSupply);
104 
105 		teamWallet = _teamWallet;
106 		_transferFrom(this, teamWallet, teamSupply);
107 
108 		marketingWallet = _marketingWallet;
109 		_transferFrom(this, marketingWallet, marketingSupply);
110 
111 		bountyWallet = _bountyWallet;
112 		_transferFrom(this, bountyWallet, bountySupply);
113 	}
114 
115 
116 	function setICO(address _icoWallet) public onlyOwner {
117 		icoWallet = _icoWallet;
118 		_transferFrom(this, icoWallet, icoSupply);
119 	}
120 
121 	function () public{
122 		revert();
123 	}
124 
125 	function balanceOf(address _owner) public constant returns (uint balance) {
126 		return balances[_owner];
127 	}
128 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
129 		return allowed[_owner][_spender];
130 	}
131 
132 	function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) returns (bool success) {
133 		_transferFrom(msg.sender, _to, _value);
134 		return true;
135 	}
136 	function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool) {
137 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
138 		_transferFrom(_from, _to, _value);
139 		return true;
140 	}
141 	function _transferFrom(address _from, address _to, uint256 _value) internal {
142 		require(_value > 0);
143 		balances[_from] = balances[_from].sub(_value);
144 		balances[_to] = balances[_to].add(_value);
145 		Transfer(_from, _to, _value);
146 	}
147 
148 	function approve(address _spender, uint256 _value) public returns (bool) {
149 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
150 		allowed[msg.sender][_spender] = _value;
151 		Approval(msg.sender, _spender, _value);
152 		return true;
153 	}
154 }