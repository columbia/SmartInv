1 pragma solidity 0.4.21;
2 
3 contract Ownable {
4 	address public owner;
5 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7 	function Ownable() public {
8 		owner = msg.sender;
9 	}
10 
11 	modifier onlyOwner() {
12 		require(msg.sender == owner);
13 		_;
14 	}
15 
16 	///////////// NEW OWNER FUNCTIONALITY
17 
18 	function transferOwnership(address newOwner) public onlyOwner {
19 		require(newOwner != address(0) && newOwner != owner);
20 		emit OwnershipTransferred(owner, newOwner);
21 		owner = newOwner;
22 	}
23 }
24 
25 ///////////// DESTROY FUNCTION
26 
27 contract Destructible is Ownable {
28 
29 	function Destructible() public payable { }
30 
31 	function destroy() onlyOwner public {
32 		selfdestruct(owner);
33 	}
34 
35 	function destroyAndSend(address _recipient) onlyOwner public {
36 		selfdestruct(_recipient);
37 	}
38 }
39 
40 ///////////// SAFE MATH FUNCTIONS
41 
42 library SafeMath {
43 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44 		uint256 c = a * b;
45 		assert(a == 0 || c / a == b);
46 		return c;
47 	}
48 
49 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
50 		assert(b > 0); // Solidity automatically throws when dividing by 0
51 		uint256 c = a / b;
52 		return c;
53 	}
54 
55 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56 		assert(b <= a);
57 		return a - b;
58 	}
59 
60 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
61 		uint256 c = a + b;
62 		assert(c >= a);
63 		return c;
64 	}
65 }
66 
67 contract Lockable is Destructible {
68 	mapping(address => bool) lockedAddress;
69 
70 	function lock(address _address) public onlyOwner {
71 		lockedAddress[_address] = true;
72 	}
73 
74 	function unlock(address _address) public onlyOwner {
75 		lockedAddress[_address] = false;
76 	}
77 
78 	modifier onlyUnlocked() {
79 		uint nowtime = block.timestamp;
80 		uint futuretime = 1550537591; // EPOCH TIMESTAMP OF Feb 2, 2019 GMT
81 		if(nowtime > futuretime) {
82 			_;
83 		} else {
84 			require(!lockedAddress[msg.sender]);
85 			_;
86 		}
87 	}
88 
89 	function isLocked(address _address) public constant returns (bool) {
90 		return lockedAddress[_address];
91 	}
92 }
93 
94 contract UserTokensControl is Lockable {
95 	address contractReserve;
96 }
97 
98 ///////////// DECLARE ERC223 BASIC INTERFACE
99 
100 contract ERC223ReceivingContract {
101 	function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
102 		_from;
103 		_value;
104 		_data;
105 	}
106 }
107 
108 contract ERC223 {
109 	event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
110 }
111 
112 contract ERC20 {
113 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
114 }
115 
116 contract BasicToken is ERC20, ERC223, UserTokensControl {
117 	uint256 public totalSupply;
118 	using SafeMath for uint256;
119 
120 	mapping(address => uint256) balances;
121 
122 	///////////// TRANSFER ////////////////
123 
124 	function transferToAddress(address _to, uint256 _value, bytes _data) internal returns (bool) {
125 		balances[msg.sender] = balances[msg.sender].sub(_value);
126 		balances[_to] = balances[_to].add(_value);
127 		emit Transfer(msg.sender, _to, _value);
128 		emit Transfer(msg.sender, _to, _value, _data);
129 		return true;
130 	}
131 
132 	function transferToContract(address _to, uint256 _value, bytes _data) internal returns (bool) {
133 		balances[msg.sender] = balances[msg.sender].sub(_value);
134 		balances[_to] = balances[_to].add(_value);
135 		ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
136 		receiver.tokenFallback(msg.sender, _value, _data);
137 		emit Transfer(msg.sender, _to, _value);
138 		emit Transfer(msg.sender, _to, _value, _data);
139 		return true;
140 	}
141 
142 	function transfer(address _to, uint256 _value, bytes _data) onlyUnlocked public returns (bool) {
143 		require(_to != address(0));
144 		require(_value <= balances[msg.sender]);
145 		require(_value > 0);
146 
147 		uint256 codeLength;
148 		assembly {
149 			codeLength := extcodesize(_to)
150 		}
151 	
152 		if(codeLength > 0) {
153 			return transferToContract(_to, _value, _data);
154 		} else {
155 			return transferToAddress(_to, _value, _data);
156 		}
157 	}
158 
159 
160 	function transfer(address _to, uint256 _value) onlyUnlocked public returns (bool) {
161 		require(_to != address(0));
162 		require(_value <= balances[msg.sender]);
163 		require(_value > 0);
164 
165 		uint256 codeLength;
166 		bytes memory empty;
167 		assembly {
168 			codeLength := extcodesize(_to)
169 		}
170 
171 		if(codeLength > 0) {
172 			return transferToContract(_to, _value, empty);
173 		} else {
174 			return transferToAddress(_to, _value, empty);
175 		}
176 	}
177 
178 
179 	function balanceOf(address _address) public constant returns (uint256 balance) {
180 		return balances[_address];
181 	}
182 }
183 
184 contract StandardToken is BasicToken {
185 
186 	mapping (address => mapping (address => uint256)) internal allowed;
187 }
188 
189 contract Superpack is StandardToken {
190 	string public constant name = "Superpack";
191 	uint public constant decimals = 18;
192 	string public constant symbol = "SPAC";
193 
194 	function Superpack() public {
195 		totalSupply = 1000000000 *(10**decimals);
196 		owner = msg.sender;
197 		balances[msg.sender] = 1000000000 * (10**decimals);
198 	}
199 
200 	function() public {
201 		revert();
202 	}
203 }