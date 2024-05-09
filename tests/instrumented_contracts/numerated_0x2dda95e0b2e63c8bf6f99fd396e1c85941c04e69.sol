1 pragma solidity ^0.4.18;
2 
3 	library SafeMath {
4 
5 		function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6 			if (a == 0) {
7 				return 0;
8 			}
9 
10 			uint256 c = a * b;
11 			assert(c / a == b);
12 			return c;
13 		}
14 
15 		function div(uint256 a, uint256 b) internal pure returns (uint256) {
16 			// assert(b > 0); // Solidity automatically throws when dividing by 0
17 			uint256 c = a / b;
18 			// assert(a == b * c + a % b); // There is no case in which this doesn't hold
19 			return c;
20 		}
21 
22 		function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23 			assert(b <= a);
24 			return a - b;
25 		}
26 
27 		function add(uint256 a, uint256 b) internal pure returns (uint256) {
28 			uint256 c = a + b;
29 			assert(c >= a);
30 			return c;
31 		}
32 	}
33 
34 
35 	contract Ownable {
36 
37 		address public owner;
38 		event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40 		function Ownable() public {
41 			owner = msg.sender;
42 		}
43 
44 		modifier onlyOwner() {
45 			require(msg.sender == owner);
46 			_;
47 		}
48 
49 		function transferOwnership(address newOwner) public onlyOwner {
50 			require(newOwner != address(0));
51 			emit OwnershipTransferred(owner, newOwner);
52 			owner = newOwner;
53 		}
54 	}
55 
56 	contract ERC20Basic {
57 		function totalSupply() public view returns (uint256);
58 		function balanceOf(address who) public view returns (uint256);
59 		function transfer(address to, uint256 value) public returns (bool);
60 		event Transfer(address indexed from, address indexed to, uint256 value);
61 	}
62 
63 	contract ERC20 is ERC20Basic {
64 		function allowance(address owner, address spender) public view returns (uint256);
65 		function transferFrom(address from, address to, uint256 value) public returns (bool);
66 		function approve(address spender, uint256 value) public returns (bool);
67 		event Approval(address indexed owner, address indexed spender, uint256 value);
68 	}
69 
70 	contract Rhodium is ERC20, Ownable{
71 
72 	using SafeMath for uint256;
73 
74 	string public constant name = "Rhodium"; // solium-disable-line uppercase
75 	string public constant symbol = "RH45"; // solium-disable-line uppercase
76 	uint8 public constant decimals = 8; // solium-disable-line uppercase
77 
78 	uint256 public constant INITIAL_SUPPLY = 45000000e8;
79 	uint256 totalSupply_;
80 
81 
82 	uint256 public minAmount = 0.04 ether;
83 
84 	uint256 public rate =  100000000;
85 	bool public allowSelling = false; 
86 
87 	mapping(address => uint256) balances;
88 	mapping (address => mapping (address => uint256)) internal allowed;
89 
90 	function Rhodium() public {
91 		totalSupply_ = INITIAL_SUPPLY;
92 		balances[msg.sender] = INITIAL_SUPPLY;
93 		emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
94 	}
95 
96 	function totalSupply() public view returns (uint256) {
97 		return totalSupply_;
98 	}
99 
100 	function () public payable {
101 
102 		require(allowSelling);
103 		require(msg.sender != address(0));
104 		require(tx.origin == msg.sender); 
105 		require(msg.value >= minAmount);
106 
107 		uint256 ethAmount = msg.value; 
108 		uint256 numTokensSend = 0;
109 
110 		numTokensSend = ethAmount.div(rate);
111 
112 		if (balances[owner] >= numTokensSend) {
113 
114 			balances[owner] = balances[owner].sub(numTokensSend);
115 			balances[msg.sender] = balances[msg.sender].add(numTokensSend);
116 
117 			owner.transfer(ethAmount);
118 			emit Transfer(owner, msg.sender, numTokensSend);
119 
120 		}else{
121 			revert();
122 		}
123 
124 			
125 	}
126 
127 	modifier onlyPayloadSize(uint size) {
128 		assert(msg.data.length >= size * 32 + 4);
129 		_;
130 	}
131 
132 	
133 	function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool) {
134 		require(_to != address(0));
135 		require(_value <= balances[msg.sender]);
136 
137 		// SafeMath.sub will throw if there is not enough balance.
138 		balances[msg.sender] = balances[msg.sender].sub(_value);
139 		balances[_to] = balances[_to].add(_value);
140 		emit Transfer(msg.sender, _to, _value);
141 		return true;
142 	}
143 
144 
145 	function balanceOf(address _owner) public view returns (uint256 balance) {
146 		return balances[_owner];
147 	}
148 
149 
150 	function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) public returns (bool) {
151 		require(_to != address(0));
152 		require(_value <= balances[_from]);
153 		require(_value <= allowed[_from][msg.sender]);
154 
155 		balances[_from] = balances[_from].sub(_value);
156 		balances[_to] = balances[_to].add(_value);
157 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158 		emit Transfer(_from, _to, _value);
159 		return true;
160 	}
161 
162 	function multiTransfer(address[] _toAddresses, uint256[] _amounts) public returns (bool) {
163 
164 		require(_toAddresses.length <= 255);
165 		require(_toAddresses.length == _amounts.length);
166 
167 		for (uint8 i = 0; i < _toAddresses.length; i++) {
168 			transfer(_toAddresses[i], _amounts[i]);
169 		}
170 
171 		return true;
172 	}
173 
174 	function approve(address _spender, uint256 _value) onlyPayloadSize(2) public returns (bool) {
175 		allowed[msg.sender][_spender] = _value;
176 		emit Approval(msg.sender, _spender, _value);
177 		return true;
178 	}
179 
180 	function allowance(address _owner, address _spender) public view returns (uint256) {
181 		return allowed[_owner][_spender];
182 	}
183 
184 	function increaseApproval(address _spender, uint _addedValue) onlyPayloadSize(2) public returns (bool) {
185 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
186 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187 		return true;
188 	}
189 
190 	function decreaseApproval(address _spender, uint _subtractedValue) onlyPayloadSize(2) public returns (bool) {
191 
192 		uint oldValue = allowed[msg.sender][_spender];
193 
194 		if (_subtractedValue > oldValue) {
195 			allowed[msg.sender][_spender] = 0;
196 		} else {
197 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
198 		}
199 	
200 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201 		return true;
202 	}
203 
204 	function sellingEnable(uint256 _rate) onlyOwner public {
205 		require(_rate > 0);
206 		allowSelling = true;
207 		rate = _rate; 
208 	}
209 
210 	function sellingDisable() onlyOwner public {
211 		allowSelling = false;
212 	}
213 }