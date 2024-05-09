1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4 	function mul(uint a, uint b) internal returns(uint) {
5 		uint c = a * b;
6 		assert(a == 0 || c / a == b);
7 		return c;
8 	}
9 
10 	function div(uint a, uint b) internal returns(uint) {
11 		uint c = a / b;
12 		return c; 
13 	}
14 
15 	function sub(uint a, uint b) internal returns(uint) {
16 		assert(b <= a);
17 		return a - b;
18 	}
19 
20 	function add(uint a, uint b) internal returns(uint) {
21 		uint c = a + b;
22 		assert(c >= a);
23 		return c;
24 	}
25 	function max64(uint64 a, uint64 b) internal constant returns(uint64) {
26 		return a >= b ? a : b;
27 	}
28 
29 	function min64(uint64 a, uint64 b) internal constant returns(uint64) {
30 		return a < b ? a : b;
31 	}
32 
33 	function max256(uint256 a, uint256 b) internal constant returns(uint256) {
34 		return a >= b ? a : b;
35 	}
36 
37 	function min256(uint256 a, uint256 b) internal constant returns(uint256) {
38 		return a < b ? a : b;
39 	}
40 
41 	function assert(bool assertion) internal {
42 		if(!assertion) {
43 			throw;
44 		}
45 	}
46 }
47 
48 contract ERC20Basic {
49 	uint public totalSupply;
50 	function balanceOf(address who) constant returns(uint);
51 	function transfer(address to, uint value);
52 	event Transfer(address indexed from, address indexed to, uint value);
53 }
54 
55 contract BasicToken is ERC20Basic {
56 	using SafeMath 	for uint;
57 	mapping(address => uint) balances;
58 
59 	modifier onlyPayloadSize(uint size) {
60 		if(msg.data.length < size + 4) {
61 			throw;
62 		}
63 		_;
64 	}
65 
66 	function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
67 		balances[msg.sender] = balances[msg.sender].sub(_value);
68 		balances[_to] = balances[_to].add(_value);
69 		Transfer(msg.sender, _to, _value);
70 	}
71 
72 	function balanceOf(address _owner) constant returns(uint balance) {
73 		return balances[_owner];
74 	}
75 
76 }
77 
78 contract ERC20 is ERC20Basic {
79 	function allowance(address owner, address spender) constant returns(uint);
80 	function transferFrom(address from, address to, uint value);
81 	function approve(address spender, uint value);
82 	event Approval(address indexed owner, address indexed spender, uint value);
83 }
84 
85 contract StandardToken is BasicToken, ERC20 {
86 	mapping(address => mapping(address => uint)) allowed;
87 	function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
88 		var _allowance = allowed[_from][msg.sender];
89 		balances[_to] = balances[_to].add(_value);
90 		balances[_from] = balances[_from].sub(_value);
91 		allowed[_from][msg.sender] = _allowance.sub(_value);
92 		Transfer(_from, _to, _value);
93 	}
94 
95 	function approve(address _spender, uint _value) {
96 		if((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
97 		allowed[msg.sender][_spender] = _value;
98 		Approval(msg.sender, _spender, _value);
99 	}
100 
101 	function allowance(address _owner, address _spender) constant returns(uint remaining) {
102 		return allowed[_owner][_spender];
103 	}
104 
105 }
106 
107 contract CCtestToken is StandardToken {
108 	string public constant symbol = "CCtest";
109 	string public constant name = "Coffee College";
110 	uint8 public constant decimals = 18;
111 	address public target;
112 	
113 	event InvalidCaller(address caller);
114 
115 	modifier onlyOwner {
116 		if(target == msg.sender) {
117 			_;
118 		} else {
119 			InvalidCaller(msg.sender);
120 			throw;
121 		}
122 	}
123 	function CCtestToken(address _target) {
124 		target = _target;
125 		totalSupply = 10000 * 10 ** 18;
126 		balances[target] = totalSupply;
127 	}
128 
129 }