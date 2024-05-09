1 pragma solidity 0.4.11;
2 
3 contract ERC20Interface {
4 	uint256 public totalSupply;
5 	function balanceOf(address _owner) public constant returns (uint balance); // Get the account balance of another account with address _owner
6 	function transfer(address _to, uint256 _value) public returns (bool success); // Send _value amount of tokens to address _to
7 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success); // Send _value amount of tokens from address _from to address _to
8 	function approve(address _spender, uint256 _value) public returns (bool success);
9 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining); // Returns the amount which _spender is still allowed to withdraw from _owner
10 	event Transfer(address indexed _from, address indexed _to, uint256 _value); // Triggered when tokens are transferred.
11 	event Approval(address indexed _owner, address indexed _spender, uint256 _value); // Triggered whenever approve(address _spender, uint256 _value) is called.
12 }
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
20 		uint256 c = a * b;
21 		assert(a == 0 || c / a == b);
22 		return c;
23 	}
24 
25 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
26 		// assert(b > 0); // Solidity automatically throws when dividing by 0
27 		uint256 c = a / b;
28 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 		return c;
30 	}
31 
32 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
33 		assert(b <= a);
34 		return a - b;
35 	}
36 
37 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
38 		uint256 c = a + b;
39 		assert(c >= a);
40 		return c;
41 	}
42 }
43 contract ERC20Token is ERC20Interface {
44 	using SafeMath for uint256;
45 
46 	mapping (address => uint) balances;
47 	mapping (address => mapping (address => uint256)) allowed;
48 
49 	modifier onlyPayloadSize(uint size) {
50 		require(msg.data.length >= (size + 4));
51 		_;
52 	}
53 
54 	function () public{
55 		revert();
56 	}
57 
58 	function balanceOf(address _owner) public constant returns (uint balance) {
59 		return balances[_owner];
60 	}
61 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
62 		return allowed[_owner][_spender];
63 	}
64 
65 	function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) returns (bool success) {
66 		_transferFrom(msg.sender, _to, _value);
67 		return true;
68 	}
69 	function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool) {
70 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
71 		_transferFrom(_from, _to, _value);
72 		return true;
73 	}
74 	function _transferFrom(address _from, address _to, uint256 _value) internal {
75 		require(_value > 0);
76 		balances[_from] = balances[_from].sub(_value);
77 		balances[_to] = balances[_to].add(_value);
78 		Transfer(_from, _to, _value);
79 	}
80 
81 	function approve(address _spender, uint256 _value) public returns (bool) {
82 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
83 		allowed[msg.sender][_spender] = _value;
84 		Approval(msg.sender, _spender, _value);
85 		return true;
86 	}
87 }
88 
89 contract owned {
90 	address public owner;
91 
92 	function owned() public {
93 		owner = msg.sender;
94 	}
95 
96 	modifier onlyOwner {
97 		if (msg.sender != owner) revert();
98 		_;
99 	}
100 
101 	function transferOwnership(address newOwner) public onlyOwner {
102 		owner = newOwner;
103 	}
104 }
105 
106 
107 contract IQFToken is ERC20Token, owned{
108 	using SafeMath for uint256;
109 
110 	string public name = 'IQF TOKEN';
111 	string public symbol = 'IQF';
112 	uint8 public decimals = 8;
113 	uint256 public totalSupply = 10000000000000000;//100 000 000 * 10^8
114 
115 	function IQFToken() public {
116 		balances[this] = totalSupply;
117 	}
118 
119 	function setTokens(address target, uint256 _value) public onlyOwner {
120 		balances[this] = balances[this].sub(_value);
121 		balances[target] = balances[target].add(_value);
122 		Transfer(this, target, _value);
123 	}
124 
125 	function burnBalance() public onlyOwner {
126 		totalSupply = totalSupply.sub(balances[this]);
127 		Transfer(this, address(0), balances[this]);
128 		balances[this] = 0;
129 	}
130 }