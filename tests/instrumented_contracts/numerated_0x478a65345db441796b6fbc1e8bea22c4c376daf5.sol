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
18 
19 ///////////// NEW OWNER FUNCTIONALITY
20 
21 	function transferOwnership(address newOwner) public onlyOwner {
22 		require(newOwner != address(0) && newOwner != owner);
23 		emit OwnershipTransferred(owner, newOwner);
24 		owner = newOwner;
25 	}
26 }
27 
28 
29 ///////////// POST ICO DESTROY COMMAND
30 
31 contract Destructible is Ownable {
32 
33 	function Destructible() public payable { }
34 
35 	function destroy() onlyOwner public {
36 		selfdestruct(owner);
37 	}
38 
39 	function destroyAndSend(address _recipient) onlyOwner public {
40 		selfdestruct(_recipient);
41 	}
42 }
43 
44 
45 ///////////// SAFE MATH FUNCTIONS
46 
47 library SafeMath {
48 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49 		uint256 c = a * b;
50 		assert(a == 0 || c / a == b);
51 		return c;
52 	}
53 
54 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
55 		assert(b > 0);
56 		uint256 c = a / b;
57 		return c;
58 	}
59 
60 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61 		assert(b <= a);
62 		return a - b;
63 	}
64 
65 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
66 		uint256 c = a + b;
67 		assert(c >= a);
68 		return c;
69 	}
70 }
71 
72 ///////////// DECLARE ERC223 BASIC INTERFACE
73 
74 contract ERC223ReceivingContract {
75 	function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
76 		_from;
77 		_value;
78 		_data;
79 	}
80 }
81 
82 contract ERC223 {
83 	event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
84 }
85 
86 contract ERC20 {
87 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
88 }
89 
90 
91 contract BasicToken is ERC20, ERC223, Destructible {
92 	uint256 public totalSupply;
93 	using SafeMath for uint256;
94 
95 	mapping(address => uint256) balances;
96 
97 	address[] allParticipants;
98 	mapping(address => bool) isParticipated;
99 
100 
101   ///////////// TRANSFER ////////////////
102 
103 	function transferToAddress(address _to, uint256 _value, bytes _data) internal returns (bool) {
104 		balances[msg.sender] = balances[msg.sender].sub(_value);
105 		balances[_to] = balances[_to].add(_value);
106 		if(!isParticipated[_to]){
107 			allParticipants.push(_to);
108 			isParticipated[_to] = true;
109 		}
110 		emit Transfer(msg.sender, _to, _value);
111 		emit Transfer(msg.sender, _to, _value, _data);
112 		return true;
113 	}
114 
115 	function transferToContract(address _to, uint256 _value, bytes _data) internal returns (bool) {
116 		balances[msg.sender] = balances[msg.sender].sub(_value);
117 		balances[_to] = balances[_to].add(_value);
118 		ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
119 		receiver.tokenFallback(msg.sender, _value, _data);
120 		emit Transfer(msg.sender, _to, _value);
121 		emit Transfer(msg.sender, _to, _value, _data);
122 		return true;
123 	}
124 
125 	function transfer(address _to, uint256 _value, bytes _data) public onlyOwner returns (bool) {
126 		require(_to != address(0));
127 		require(_value <= balances[msg.sender]);
128 		require(_value > 0);
129 
130 		uint256 codeLength;
131 		assembly {
132 			codeLength := extcodesize(_to)
133 		}
134 	
135 		if(codeLength > 0) {
136 			return transferToContract(_to, _value, _data);
137 		} else {
138 			return transferToAddress(_to, _value, _data);
139 		}
140 	}
141 
142 
143 	function transfer(address _to, uint256 _value) public onlyOwner returns (bool) {
144 		require(_to != address(0));
145 		require(_value <= balances[msg.sender]);
146 		require(_value > 0);
147 
148 		uint256 codeLength;
149 		bytes memory empty;
150 		assembly {
151 			codeLength := extcodesize(_to)
152 		}
153 
154 		if(codeLength > 0) {
155 			return transferToContract(_to, _value, empty);
156 		} else {
157 			return transferToAddress(_to, _value, empty);
158 		}
159 	}
160 
161 
162 	function balanceOf(address _address) public constant returns (uint256 balance) {
163 		return balances[_address];
164 	}
165 
166 
167 	function getCountPartipants() public constant returns (uint count){
168 		return allParticipants.length;
169 	}
170 
171 	function getParticipantIndexAddress(uint index)public constant returns (address){
172 		return allParticipants[index];
173 	}
174 }
175 
176 
177 contract StandardToken is BasicToken {
178 
179 	mapping (address => mapping (address => uint256)) internal allowed;
180 }
181 
182 contract Airstayz is StandardToken {
183 	string public constant name = "AIRSTAYZSAFT";
184 	uint public constant decimals = 18;
185 	string public constant symbol = "STAYUS";
186 
187 	function Airstayz() public {
188 		totalSupply = 93000000 *(10**decimals);
189 		owner = msg.sender;
190 		balances[msg.sender] = 93000000 * (10**decimals);
191 	}
192 
193 	function() public {
194 		revert();
195 	}
196 }