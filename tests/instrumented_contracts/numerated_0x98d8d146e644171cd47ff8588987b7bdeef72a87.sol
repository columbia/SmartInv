1 pragma solidity ^0.4.24;
2 
3 contract Migrations {
4 	address public owner;
5 	address public newOwner;
6 
7 	address public manager;
8 	address public newManager;
9 
10 	event TransferOwnership(address oldaddr, address newaddr);
11 	event TransferManager(address oldaddr, address newaddr);
12 
13 	modifier onlyOwner() { require(msg.sender == owner); _; }
14 	modifier onlyManager() { require(msg.sender == manager); _; }
15 	modifier onlyAdmin() { require(msg.sender == owner || msg.sender == manager); _; }
16 
17 
18 	constructor() public {
19 		owner = msg.sender;
20 		manager = msg.sender;
21 	}
22 
23 	function transferOwnership(address _newOwner) onlyOwner public {
24 		newOwner = _newOwner;
25 	}
26 
27 	function transferManager(address _newManager) onlyAdmin public {
28 		newManager = _newManager;
29 	}
30 
31 	function acceptOwnership() public {
32 		require(msg.sender == newOwner);
33 		address oldaddr = owner;
34 		owner = newOwner;
35 		newOwner = address(0);
36 		emit TransferOwnership(oldaddr, owner);
37 	}
38 
39 	function acceptManager() public {
40 		require(msg.sender == newManager);
41 		address oldaddr = manager;
42 		manager = newManager;
43 		newManager = address(0);
44 		emit TransferManager(oldaddr, manager);
45 	}
46 }
47 
48 
49 library SafeMath {
50 
51 	function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
52 		if (_a == 0) {
53 			return 0;
54 		}
55 		uint256 c = _a * _b;
56 		require(c / _a == _b);
57 
58 		return c;
59 	}
60 
61 	function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
62 		require(_b > 0);
63 		uint256 c = _a / _b;
64 
65 		return c;
66 	}
67 
68 	function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
69 		require(_b <= _a);
70 		uint256 c =  _a - _b;
71 
72 		return c;
73 	}
74 
75 	function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
76 		uint256 c = _a + _b;
77 		require(c >= _a);
78 
79 		return c;
80 	}
81 
82 	function mod(uint256 _a, uint256 _b) internal pure returns (uint256) {
83 		require(_b != 0);
84 		return _a % _b;
85 	}
86 }
87 
88 // ----------------------------------------------------------------------------
89 // ERC Token Standard #20 Interface
90 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
91 // ----------------------------------------------------------------------------
92 contract ERC20Interface {
93 	function totalSupply() public view returns (uint256);
94 	function balanceOf(address _owner) public view returns (uint256 balance);
95 	function allowance(address _owner, address _spender) public view returns (uint256 remaining);
96 	function transfer(address _to, uint256 _value) public returns (bool success);
97 	function transferFrom(address _from, address _to, uint _value) public returns (bool success);
98 	function approve(address _spender, uint256 _value) public returns (bool success);
99 
100 	event Transfer(address indexed from, address indexed to, uint tokens);
101 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
102 }
103 
104 
105 contract ReentrancyGuard {
106 	uint256 private guardCounter = 1;
107 
108 	modifier noReentrant() {
109 		guardCounter += 1;
110 		uint256 localCounter = guardCounter;
111 		_;
112 		require(localCounter == guardCounter);
113 	}
114 }
115 
116 
117 interface tokenRecipient {
118 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
119 }
120 
121 
122 contract ERC20Base is ERC20Interface , ReentrancyGuard{
123 	using SafeMath for uint256;
124 
125 	string public name;
126 	string public symbol;
127 	uint8 public decimals = 18;
128 	uint256 public totalSupply;
129 
130 	mapping(address => uint256) public balanceOf;
131 	mapping(address => mapping (address => uint256)) public allowance;
132 
133 	constructor() public {
134 		//totalSupply = initialSupply * 10 ** uint256(decimals);
135 		uint256 initialSupply = 20000000000;
136 		totalSupply = initialSupply.mul(1 ether);
137 		balanceOf[msg.sender] = totalSupply;
138 		name = "ABCToken";
139 		symbol = "ABC";
140 	}
141 
142 	function () payable public {
143 		revert();
144 	}
145 
146 	function totalSupply() public view returns(uint256) {
147 		return totalSupply;
148 	}
149 
150 	function balanceOf(address _owner) public view returns (uint256 balance) {
151 		return balanceOf[_owner];
152 	}
153 
154 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
155 		return allowance[_owner][_spender];
156 	}
157 
158 	function _transfer(address _from, address _to, uint256 _value) internal returns (bool success) {
159 		require(_to != 0x0);
160 		require(balanceOf[_from] >= _value);
161 		if (balanceOf[_to].add(_value) <= balanceOf[_to]) {
162 			revert();
163 		}
164 
165 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
166 		balanceOf[_from] = balanceOf[_from].sub(_value);
167 		balanceOf[_to] = balanceOf[_to].add(_value);
168 		emit Transfer(_from, _to, _value);
169 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
170 
171 		return true;
172 	}
173 
174 	function transfer(address _to, uint256 _value) public returns (bool success) {
175 		return _transfer(msg.sender, _to, _value);
176 	}
177 
178 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
179 		require(_value <= allowance[_from][msg.sender]);
180 		allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
181 		return _transfer(_from, _to, _value);
182 	}
183 
184 	function approve(address _spender, uint256 _value) public returns (bool success) {
185 		allowance[msg.sender][_spender] = _value;
186 		emit Approval(msg.sender, _spender, _value);
187 		return true;
188 	}
189 
190 	function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
191 		allowance[msg.sender][_spender] = (
192 		allowance[msg.sender][_spender].add(_addedValue));
193 		emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
194 		return true;
195 	}
196 
197 	function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
198 		uint256 oldValue = allowance[msg.sender][_spender];
199 		if (_subtractedValue >= oldValue) {
200 			allowance[msg.sender][_spender] = 0;
201 		} else {
202 			allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
203 		}
204 		emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
205 		return true;
206 	}
207 
208 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) noReentrant public returns (bool success) {
209 		tokenRecipient spender = tokenRecipient(_spender);
210 		if (approve(_spender, _value)) {
211 			spender.receiveApproval(msg.sender, _value, this, _extraData);
212 			return true;
213 		}
214 	}
215 }
216 
217 contract BXAToken is Migrations, ERC20Base {
218 	bool public isTokenLocked;
219 	bool public isUseFreeze;
220 	struct Frozen {
221 		bool from;
222 		uint256 amount;
223 	}
224 	mapping (address => Frozen) public frozenAccount;
225 
226 	event FrozenFunds(address target, bool freezeFrom, uint256 freezeAmount);
227 
228 	constructor()
229 		ERC20Base()
230 		onlyOwner()
231 		public
232 	{
233 		uint256 initialSupply = 20000000000;
234 		isUseFreeze = true;
235 		totalSupply = initialSupply.mul(1 ether);
236 		isTokenLocked = false;
237 		symbol = "BXA";
238 		name = "BXA";
239 		balanceOf[msg.sender] = totalSupply;
240 		emit Transfer(address(0), msg.sender, totalSupply);
241 	}
242 
243 	modifier tokenLock() {
244 		require(isTokenLocked == false);
245 		_;
246 	}
247 
248 	function setLockToken(bool _lock) onlyOwner public {
249 		isTokenLocked = _lock;
250 	}
251 
252 	function setUseFreeze(bool _useOrNot) onlyAdmin public {
253 		isUseFreeze = _useOrNot;
254 	}
255 
256 	function freezeFrom(address target, bool fromFreeze) onlyAdmin public {
257 		frozenAccount[target].from = fromFreeze;
258 		emit FrozenFunds(target, fromFreeze, 0);
259 	}
260 
261 	function freezeAmount(address target, uint256 amountFreeze) onlyAdmin public {
262 		frozenAccount[target].amount = amountFreeze;
263 		emit FrozenFunds(target, false, amountFreeze);
264 	}
265 
266 	function freezeAccount(
267 		address target,
268 		bool fromFreeze,
269 		uint256 amountFreeze
270 	) onlyAdmin public {
271 		require(isUseFreeze);
272 		frozenAccount[target].from = fromFreeze;
273 		frozenAccount[target].amount = amountFreeze;
274 		emit FrozenFunds(target, fromFreeze, amountFreeze);
275 	}
276 
277 	function isFrozen(address target) public view returns(bool, uint256) {
278 		return (frozenAccount[target].from, frozenAccount[target].amount);
279 	}
280 
281 	function _transfer(address _from, address _to, uint256 _value) tokenLock internal returns(bool success) {
282 		require(balanceOf[_from] >= _value);
283 
284 		if (balanceOf[_to].add(_value) <= balanceOf[_to]) {
285 			revert();
286 		}
287 
288 		if (isUseFreeze == true) {
289 			require(frozenAccount[_from].from == false);
290 
291 			if(balanceOf[_from].sub(_value) < frozenAccount[_from].amount) {
292 				revert();
293 			}
294 		}
295 
296 		if (_to == address(0)) {
297 			require(msg.sender == owner);
298 			totalSupply = totalSupply.sub(_value);
299 		}
300 		balanceOf[_from] = balanceOf[_from].sub(_value);
301 		balanceOf[_to] = balanceOf[_to].add(_value);
302 		emit Transfer(_from, _to, _value);
303 
304 		return true;
305 	}
306 
307 	function totalBurn() public view returns(uint256) {
308 		return balanceOf[address(0)];
309 	}
310 }