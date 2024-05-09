1 pragma solidity 0.4.21;
2 
3 contract Ownable {
4 	address public owner;
5 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7 
8 	function Ownable() public {
9 		owner = msg.sender;
10 	}
11 
12 
13 	modifier onlyOwner() {
14 		require(msg.sender == owner);
15 		_;
16 	}
17 
18 ///////////// NEW OWNER FUNCTIONALITY
19 
20 	function transferOwnership(address newOwner) public onlyOwner {
21 		require(newOwner != address(0) && newOwner != owner);
22 		emit OwnershipTransferred(owner, newOwner);
23 		owner = newOwner;
24 	}
25 }
26 
27 ///////////// SAFE MATH FUNCTIONS
28 
29 library SafeMath {
30 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31 		uint256 c = a * b;
32 		assert(a == 0 || c / a == b);
33 		return c;
34 	}
35 
36 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
37 		assert(b > 0); // Solidity automatically throws when dividing by 0
38 		uint256 c = a / b;
39 		return c;
40 	}
41 
42 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43 		assert(b <= a);
44 		return a - b;
45 	}
46 
47 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
48 		uint256 c = a + b;
49 		assert(c >= a);
50 		return c;
51 	}
52 }
53 
54 
55 ///////////// DECLARE ERC223 BASIC INTERFACE
56 
57 contract ERC223ReceivingContract {
58 	function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
59 		_from;
60 		_value;
61 		_data;
62 	}
63 }
64 
65 contract ERC223 {
66 	event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
67 }
68 
69 contract ERC20 {
70 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
71 }
72 
73 
74 contract BasicToken is ERC20, ERC223, Ownable {
75 	uint256 public totalSupply;
76 	using SafeMath for uint256;
77 
78 	mapping(address => uint256) balances;
79 
80 
81   ///////////// TRANSFER ////////////////
82 
83 	function transferToAddress(address _to, uint256 _value, bytes _data) internal returns (bool) {
84 		balances[msg.sender] = balances[msg.sender].sub(_value);
85 		balances[_to] = balances[_to].add(_value);
86 		emit Transfer(msg.sender, _to, _value);
87 		emit Transfer(msg.sender, _to, _value, _data);
88 		return true;
89 	}
90 
91 	function transferToContract(address _to, uint256 _value, bytes _data) internal returns (bool) {
92 		balances[msg.sender] = balances[msg.sender].sub(_value);
93 		balances[_to] = balances[_to].add(_value);
94 		ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
95 		receiver.tokenFallback(msg.sender, _value, _data);
96 		emit Transfer(msg.sender, _to, _value);
97 		emit Transfer(msg.sender, _to, _value, _data);
98 		return true;
99 	}
100 
101 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
102 		require(_to != address(0));
103 		require(_value <= balances[msg.sender]);
104 		require(_value > 0);
105 
106 		uint256 codeLength;
107 		assembly {
108 			codeLength := extcodesize(_to)
109 		}
110 	
111 		if(codeLength > 0) {
112 			return transferToContract(_to, _value, _data);
113 		} else {
114 			return transferToAddress(_to, _value, _data);
115 		}
116 	}
117 
118 
119 	function transfer(address _to, uint256 _value) public returns (bool) {
120 		require(_to != address(0));
121 		require(_value <= balances[msg.sender]);
122 		require(_value > 0);
123 
124 		uint256 codeLength;
125 		bytes memory empty;
126 		assembly {
127 			codeLength := extcodesize(_to)
128 		}
129 
130 		if(codeLength > 0) {
131 			return transferToContract(_to, _value, empty);
132 		} else {
133 			return transferToAddress(_to, _value, empty);
134 		}
135 	}
136 
137 
138 	function balanceOf(address _address) public constant returns (uint256 balance) {
139 		return balances[_address];
140 	}
141 }
142 
143 
144 contract StandardToken is BasicToken {
145 
146 	mapping (address => mapping (address => uint256)) internal allowed;
147 }
148 
149 contract Nomid is StandardToken {
150 	string public constant name = "NOMIDMAN";
151 	uint public constant decimals = 18;
152 	string public constant symbol = "MANO";
153 
154 	function Nomid() public {
155 		totalSupply=901000000 *(10**decimals);
156 		owner = msg.sender;
157 		balances[msg.sender] = 901000000 * (10**decimals);
158 	}
159 
160 	function() public {
161 		revert();
162 	}
163 }