1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9 		if (a == 0) {
10 			return 0;
11 		}
12 		uint256 c = a * b;
13 		assert(c / a == b);
14 		return c;
15 	}
16 
17 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
18 		// assert(b > 0); // Solidity automatically throws when dividing by 0
19 		uint256 c = a / b;
20 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
21 		return c;
22 	}
23 
24 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25 		assert(b <= a);
26 		return a - b;
27 	}
28 
29 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
30 		uint256 c = a + b;
31 		assert(c >= a);
32 		return c;
33 	}
34 }
35 
36 contract ERC20 {
37 	function totalSupply() public view returns (uint256 totalSup);
38 	function balanceOf(address _owner) public view returns (uint256 balance);
39 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
40 	function allowance(address _owner, address _spender) public view returns (uint256 remaining);
41 	function approve(address _spender, uint256 _value) public returns (bool success);
42 	function transfer(address _to, uint256 _value) public returns (bool success);
43 	event Transfer(address indexed _from, address indexed _to, uint _value);
44 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47 
48 contract VIX is ERC20 {
49     
50 	using SafeMath for uint256;
51 
52 	uint public constant _totalSupply = 2000000000e18;
53 	//starting supply of Token
54 
55 	string public constant symbol = "VIX";
56 	string public constant name = "VIXCO";
57 	uint8 public constant decimals = 18;
58 
59 	mapping(address => uint256) balances;
60 	mapping(address => mapping(address => uint256)) allowed;
61 
62 	constructor() public{
63 		balances[msg.sender] = _totalSupply;
64 		emit Transfer(0x0, msg.sender, _totalSupply);
65 	}
66 
67 	function totalSupply() public view returns (uint256 totalSup) {
68 		return _totalSupply;
69 	}
70 
71 	function balanceOf(address _owner) public view returns (uint256 balance) {
72 		return balances[_owner];
73 	}
74     
75 	function transfer(address _to, uint256 _value) public returns (bool success) {
76 		balances[msg.sender] = balances[msg.sender].sub(_value);
77 		balances[_to] = balances[_to].add(_value);
78 		emit Transfer(msg.sender, _to, _value);
79 		return true;
80 	}
81     
82 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
83 		require(
84 			balances[_from] >= _value
85 			&& _value > 0
86 		);
87 		balances[_from] = balances[_from].sub(_value);
88 		balances[_to] = balances[_to].add(_value);
89 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
90 		emit Transfer(_from, _to, _value);
91 		return true;
92 	}
93     
94 	function approve(address _spender, uint256 _value) public returns (bool success) {
95 		require(
96 			(_value == 0) || (allowed[msg.sender][_spender] == 0)
97 		);
98 		allowed[msg.sender][_spender] = _value;
99 		emit Approval(msg.sender, _spender, _value);
100 		return true;
101 	}
102     
103 	function allowance(address _owner, address _spender) public view returns (uint256 remain) {
104 		return allowed[_owner][_spender];
105 	}
106 
107 	function () public payable {
108 		revert();
109 	}
110     
111 	event Transfer(address  indexed _from, address indexed _to, uint256 _value);
112 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
113 
114 }