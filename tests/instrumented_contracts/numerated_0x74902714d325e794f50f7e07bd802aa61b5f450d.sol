1 pragma solidity ^0.4.24;
2 
3 
4 contract Migrations {
5 	address public owner;
6 	address public newOwner;
7 
8 	address public manager;
9 	address public newManager;
10 
11 	event TransferOwnership(address oldaddr, address newaddr);
12 	event TransferManager(address oldaddr, address newaddr);
13 
14 	modifier onlyOwner() { require(msg.sender == owner); _; }
15 	modifier onlyManager() { require(msg.sender == manager); _; }
16 	modifier onlyAdmin() { require(msg.sender == owner || msg.sender == manager); _; }
17 
18 
19 	constructor() public {
20 		owner = msg.sender;
21 		manager = msg.sender;
22 	}
23 
24 	function transferOwnership(address _newOwner) onlyOwner public {
25 		newOwner = _newOwner;
26 	}
27 
28 	function transferManager(address _newManager) onlyAdmin public {
29 		newManager = _newManager;
30 	}
31 
32 	function acceptOwnership() public {
33 		require(msg.sender == newOwner);
34 		address oldaddr = owner;
35 		owner = newOwner;
36 		newOwner = address(0);
37 		emit TransferOwnership(oldaddr, owner);
38 	}
39 
40 	function acceptManager() public {
41 		require(msg.sender == newManager);
42 		address oldaddr = manager;
43 		manager = newManager;
44 		newManager = address(0);
45 		emit TransferManager(oldaddr, manager);
46 	}
47 }
48 
49 
50 
51 library SafeMath {
52 
53 	function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
54 		if (_a == 0) {
55 			return 0;
56 		}
57 		uint256 c = _a * _b;
58 		require(c / _a == _b);
59 
60 		return c;
61 	}
62 
63 	function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
64 		require(_b > 0);
65 		uint256 c = _a / _b;
66 
67 		return c;
68 	}
69 
70 	function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
71 		require(_b <= _a);
72 		uint256 c =  _a - _b;
73 
74 		return c;
75 	}
76 
77 	function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
78 		uint256 c = _a + _b;
79 		require(c >= _a);
80 
81 		return c;
82 	}
83 
84 	function mod(uint256 _a, uint256 _b) internal pure returns (uint256) {
85 		require(_b != 0);
86 		return _a % _b;
87 	}
88 }
89 
90 
91 // ----------------------------------------------------------------------------
92 // ERC Token Standard #20 Interface
93 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
94 // ----------------------------------------------------------------------------
95 contract ERC20Interface {
96 	function totalSupply() public view returns (uint256);
97 	function balanceOf(address _owner) public view returns (uint256 balance);
98 	function allowance(address _owner, address _spender) public view returns (uint256 remaining);
99 	function transfer(address _to, uint256 _value) public returns (bool success);
100 	function transferFrom(address _from, address _to, uint _value) public returns (bool success);
101 	function approve(address _spender, uint256 _value) public returns (bool success);
102 
103 	event Transfer(address indexed from, address indexed to, uint tokens);
104 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
105 }
106 
107 
108 contract ReentrancyGuard {
109 	uint256 private guardCounter = 1;
110 
111 	modifier noReentrant() {
112 		guardCounter = guardCounter+1;
113 		uint256 localCounter = guardCounter;
114 		_;
115 		require(localCounter == guardCounter);
116 	}
117 }
118 
119 
120 interface tokenRecipient {
121 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
122 }
123 
124 
125 contract ERC20Base is ERC20Interface , ReentrancyGuard{
126 	using SafeMath for uint256;
127 
128 	string public name;
129 	string public symbol;
130 	uint8 public decimals = 18;
131 	uint256 public totalSupply;
132 
133 	mapping(address => uint256) public balanceOf;
134 	mapping(address => mapping (address => uint256)) public allowance;
135 
136 	constructor() public {
137 		//totalSupply = initialSupply * 10 ** uint256(decimals);
138 		uint256 initialSupply = 10000000000;
139 		totalSupply = initialSupply.mul(1 ether);
140 		balanceOf[msg.sender] = totalSupply;
141 		name = "BB Token";
142 		symbol = "BBT";
143 		emit Transfer(address(0), msg.sender, totalSupply);
144 	}
145 
146 	function () payable public {
147 		revert();
148 	}
149 
150 	function totalSupply() public view returns(uint256) {
151 		return totalSupply;
152 	}
153 
154 	function balanceOf(address _owner) public view returns (uint256 balance) {
155 		return balanceOf[_owner];
156 	}
157 
158 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
159 		return allowance[_owner][_spender];
160 	}
161 
162 	function _transfer(address _from, address _to, uint256 _value) internal returns (bool success) {
163 		require(_to != 0x0);
164 		require(balanceOf[_from] >= _value);
165 		if (balanceOf[_to].add(_value) <= balanceOf[_to]) {
166 			revert();
167 		}
168 
169 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
170 		balanceOf[_from] = balanceOf[_from].sub(_value);
171 		balanceOf[_to] = balanceOf[_to].add(_value);
172 		emit Transfer(_from, _to, _value);
173 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
174 
175 		return true;
176 	}
177 
178 	function transfer(address _to, uint256 _value) public returns (bool success) {
179 		return _transfer(msg.sender, _to, _value);
180 	}
181 
182 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
183 		require(_value <= allowance[_from][msg.sender]);
184 		allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
185 		return _transfer(_from, _to, _value);
186 	}
187 
188 	function approve(address _spender, uint256 _value) public returns (bool success) {
189 		allowance[msg.sender][_spender] = _value;
190 		emit Approval(msg.sender, _spender, _value);
191 		return true;
192 	}
193 
194 	function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
195 		allowance[msg.sender][_spender] = (
196 		allowance[msg.sender][_spender].add(_addedValue));
197 		emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
198 		return true;
199 	}
200 
201 	function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
202 		uint256 oldValue = allowance[msg.sender][_spender];
203 		if (_subtractedValue >= oldValue) {
204 			allowance[msg.sender][_spender] = 0;
205 		} else {
206 			allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207 		}
208 		emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
209 		return true;
210 	}
211 
212 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) noReentrant public returns (bool success) {
213 		tokenRecipient spender = tokenRecipient(_spender);
214 		if (approve(_spender, _value)) {
215 			spender.receiveApproval(msg.sender, _value, this, _extraData);
216 			return true;
217 		}
218 	}
219 }
220 
221 
222 contract BBToken is Migrations, ERC20Base {
223 	bool public isTokenLocked;
224 	bool public isUseFreeze;
225 	struct Frozen {
226 		bool from;
227 		uint256 fromUntil;
228 		bool to;
229 		uint256 toUntil;
230 		uint256 amount;
231 		uint256 amountUntil;
232 	}
233 	mapping (address => Frozen) public frozenAccount;
234 
235 	event FrozenFunds(address target, bool freezeFrom, uint256 fromUntil, bool freezeTo, uint256 toUntil, uint256 freezeAmount, uint256 amountUntil);
236 	event Burn(address indexed from, uint256 value);
237 
238 	constructor()
239 		ERC20Base()
240 		onlyOwner()
241 		public
242 	{
243 		uint256 initialSupply = 10000000000;
244 		isUseFreeze = true;
245 		totalSupply = initialSupply.mul(1 ether);
246 		isTokenLocked = false;
247 		symbol = "BBT";
248 		name = "BB Token";
249 		balanceOf[msg.sender] = totalSupply;
250 		emit Transfer(address(0), msg.sender, totalSupply);
251 	}
252 
253 	modifier tokenLock() {
254 		require(isTokenLocked == false);
255 		_;
256 	}
257 
258 	function setLockToken(bool _lock) onlyOwner public {
259 		isTokenLocked = _lock;
260 	}
261 
262 	function setUseFreeze(bool _useOrNot) onlyAdmin public {
263 		isUseFreeze = _useOrNot;
264 	}
265 
266 	function freezeFrom(address target, bool fromFreeze, uint256 fromUntil) onlyAdmin public {
267 		frozenAccount[target].from = fromFreeze;
268 		frozenAccount[target].fromUntil = fromUntil;
269 		emit FrozenFunds(target, fromFreeze, fromUntil, false, 0, 0, 0);
270 	}
271 
272 	function freezeTo(address target, bool toFreeze, uint256 toUntil) onlyAdmin public {
273 		frozenAccount[target].to = toFreeze;
274 		frozenAccount[target].toUntil = toUntil;
275 		emit FrozenFunds(target, false, 0, toFreeze, toUntil, 0, 0);
276 	}
277 
278 	function freezeAmount(address target, uint256 amountFreeze, uint256 amountUntil) onlyAdmin public {
279 		frozenAccount[target].amount = amountFreeze;
280 		frozenAccount[target].amountUntil = amountUntil;
281 		emit FrozenFunds(target, false, 0, false, 0, amountFreeze, amountUntil);
282 	}
283 
284 	function freezeAccount(
285 		address target,
286 		bool fromFreeze,
287 		uint256 fromUntil,
288 		bool toFreeze,
289 		uint256 toUntil,
290 		uint256 amountFreeze,
291 		uint256 amountUntil
292 	) onlyAdmin public {
293 		require(isUseFreeze);
294 		frozenAccount[target].from = fromFreeze;
295 		frozenAccount[target].fromUntil = fromUntil;
296 		frozenAccount[target].to = toFreeze;
297 		frozenAccount[target].toUntil = toUntil;
298 		frozenAccount[target].amount = amountFreeze;
299 		frozenAccount[target].amountUntil = amountUntil;
300 		emit FrozenFunds(target, fromFreeze, fromUntil, toFreeze, toUntil, amountFreeze, amountUntil);
301 	}
302 
303 	function isFrozen(address target) public view returns(bool, uint256, bool, uint256, uint256, uint256) {
304 		return (frozenAccount[target].from, frozenAccount[target].fromUntil, frozenAccount[target].to, frozenAccount[target].toUntil, frozenAccount[target].amount, frozenAccount[target].amountUntil);
305 	}
306 
307 	function _transfer(address _from, address _to, uint256 _value) tokenLock internal returns(bool success) {
308 		require(_to != 0x0);
309 		require(balanceOf[_from] >= _value);
310 
311 		if (balanceOf[_to].add(_value) <= balanceOf[_to]) {
312 			revert();
313 		}
314 
315 		if (isUseFreeze == true) {
316 			if (frozenAccount[_from].from) {
317 				require(!(frozenAccount[_from].fromUntil > now));
318 			}
319 			if (frozenAccount[_to].to) {
320 				require(!(frozenAccount[_to].toUntil > now));
321 			}
322 
323 			if (frozenAccount[_from].amountUntil > now) {
324 				if(balanceOf[_from].sub(_value) < frozenAccount[_from].amount) {
325 					revert();
326 				}
327 			}
328 		}
329 
330 		balanceOf[_from] = balanceOf[_from].sub(_value);
331 		balanceOf[_to] = balanceOf[_to].add(_value);
332 		emit Transfer(_from, _to, _value);
333 
334 		return true;
335 	}
336 }