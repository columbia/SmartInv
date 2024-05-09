1 pragma solidity ^0.5.0;
2 
3 
4 interface IERC20 {
5 	function totalSupply() external view returns (uint256);
6 	function balanceOf(address account) external view returns (uint256);
7 	function transfer(address recipient, uint256 amount) external returns (bool);
8 	function allowance(address owner, address spender) external view returns (uint256);
9 	function approve(address spender, uint256 amount) external returns (bool);
10 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11 
12 	event Transfer(address indexed from, address indexed to, uint256 value);
13 	event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 library SafeMath {
17 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
18 		uint256 c = a + b;
19 		require(c >= a, "SafeMath: addition overflow");
20 
21 		return c;
22 	}
23 
24 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25 		require(b <= a, "SafeMath: subtraction overflow");
26 		uint256 c = a - b;
27 
28 		return c;
29 	}
30 
31 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32 		if (a == 0) {
33 			return 0;
34 		}
35 
36 		uint256 c = a * b;
37 		require(c / a == b, "SafeMath: multiplication overflow");
38 
39 		return c;
40 	}
41 
42 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
43 		require(b > 0, "SafeMath: division by zero");
44 		uint256 c = a / b;
45 
46 		return c;
47 	}
48 
49 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
50 		require(b != 0, "SafeMath: modulo by zero");
51 		return a % b;
52 	}
53 }
54 
55 contract ERC20 is IERC20 {
56 	using SafeMath for uint256;
57 
58 	mapping (address => uint256) private _balances;
59 	mapping (address => mapping (address => uint256)) private _allowances;
60 	uint256 private _totalSupply;
61 
62 	function totalSupply() public view returns (uint256) {
63 		return _totalSupply;
64 	}
65 
66 	function balanceOf(address account) public view returns (uint256) {
67 		return _balances[account];
68 	}
69 
70 	function transfer(address recipient, uint256 amount) public returns (bool) {
71 		_transfer(msg.sender, recipient, amount);
72 		return true;
73 	}
74 
75 	function allowance(address owner, address spender) public view returns (uint256) {
76 		return _allowances[owner][spender];
77 	}
78 
79 	function approve(address spender, uint256 value) public returns (bool) {
80 		_approve(msg.sender, spender, value);
81 		return true;
82 	}
83 
84 	function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
85 		_transfer(sender, recipient, amount);
86 		_approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
87 		return true;
88 	}
89 
90 	function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
91 		_approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
92 		return true;
93 	}
94 
95 	function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
96 		_approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
97 		return true;
98 	}
99 
100 	function _transfer(address sender, address recipient, uint256 amount) internal {
101 		require(sender != address(0), "ERC20: transfer from the zero address");
102 		require(recipient != address(0), "ERC20: transfer to the zero address");
103 
104 		_balances[sender] = _balances[sender].sub(amount);
105 		_balances[recipient] = _balances[recipient].add(amount);
106 		emit Transfer(sender, recipient, amount);
107 	}
108 
109 	function _mint(address account, uint256 amount) internal {
110 		require(account != address(0), "ERC20: mint to the zero address");
111 
112 		_totalSupply = _totalSupply.add(amount);
113 		_balances[account] = _balances[account].add(amount);
114 		emit Transfer(address(0), account, amount);
115 	}
116 
117 	function _burn(address account, uint256 value) internal {
118 		require(account != address(0), "ERC20: burn from the zero address");
119 
120 		_totalSupply = _totalSupply.sub(value);
121 		_balances[account] = _balances[account].sub(value);
122 		emit Transfer(account, address(0), value);
123 	}
124 
125 	function _approve(address owner, address spender, uint256 value) internal {
126 		require(owner != address(0), "ERC20: approve from the zero address");
127 		require(spender != address(0), "ERC20: approve to the zero address");
128 
129 		_allowances[owner][spender] = value;
130 		emit Approval(owner, spender, value);
131 	}
132 
133 	function _burnFrom(address account, uint256 amount) internal {
134 		_burn(account, amount);
135 		_approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
136 	}
137 }
138 
139 contract ERC20Detailed is IERC20 {
140 	string private _name;
141 	string private _symbol;
142 	uint8 private _decimals;
143 
144 	constructor (string memory name, string memory symbol, uint8 decimals) public {
145 		_name = name;
146 		_symbol = symbol;
147 		_decimals = decimals;
148 	}
149 
150 	function name() public view returns (string memory) {
151 		return _name;
152 	}
153 
154 	function symbol() public view returns (string memory) {
155 		return _symbol;
156 	}
157 
158 	function decimals() public view returns (uint8) {
159 		return _decimals;
160 	}
161 }
162 
163 contract ERC20Burnable is ERC20 {
164 	function burn(uint256 amount) public {
165 		_burn(msg.sender, amount);
166 	}
167 
168 	function burnFrom(address account, uint256 amount) public {
169 		_burnFrom(account, amount);
170 	}
171 }
172 
173 contract Ownable {
174 	address private _owner;
175 
176 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
177 
178 	constructor() internal {
179 		_owner = msg.sender;
180 		emit OwnershipTransferred(address(0), _owner);
181 	}
182 
183 	modifier onlyOwner() {
184 		require(msg.sender == _owner, "Ownable: caller is not the owner");
185 		_;
186 	}
187 
188 	function owner() public view returns (address) {
189 		return _owner;
190 	}
191 
192 	function renounceOwnership() public onlyOwner {
193 		emit OwnershipTransferred(_owner, address(0));
194 		_owner = address(0);
195 	}
196 
197 	function transferOwnership(address newOwner) public onlyOwner {
198 		_transferOwnership(newOwner);
199 	}
200 
201 	function _transferOwnership(address newOwner) internal {
202 		require(newOwner != address(0), "Ownable: new owner is the zero address");
203 		emit OwnershipTransferred(_owner, newOwner);
204 		_owner = newOwner;
205 	}
206 }
207 
208 contract Lockable is Ownable, ERC20 {
209 	using SafeMath for uint256;
210 
211 	uint256 constant INFINITY = 300000000000;
212 
213 	struct UsableLimitInfo{
214 		bool isEnable;
215 		uint256 usableAmount;
216 	}
217 
218 	bool private _tokenLocked;
219 	mapping(address => uint256) private _accountLocked;
220 	mapping(address => UsableLimitInfo) private _amountLocked;
221 
222 	event TokenLocked();
223 	event TokenUnlocked();
224 
225 	event AccountLocked(address account, uint256 time);
226 	event AccountUnlocked(address account, uint256 time);
227 
228 	event EnableAmountLimit(address account, uint256 usableAmount);
229 	event DisableAmountLimit(address account);
230 
231 	constructor() internal {
232 		_tokenLocked = false;
233 	}
234 
235 	modifier whenUnlocked(address originator, address from, address to) {
236 		require(!_tokenLocked, 'Lockable: Token is locked.');
237 		require(!isAccountLocked(originator), 'Lockable: Account is locked.');
238 
239 		if (originator != from) {
240 			require(!isAccountLocked(from), 'Lockable: Account is locked.');
241 		}
242 
243 		require(!isAccountLocked(to), 'Lockable: Account is locked.');
244 		_;
245 	}
246 
247 	modifier checkAmountLimit(address from, uint256 amount) {
248 		if(_amountLocked[from].isEnable == true) {
249 			require(_amountLocked[from].usableAmount >= amount, 'Lockable: check usable amount');
250 		}
251 		_;
252 		if(_amountLocked[from].isEnable == true) {
253 			_decreaseUsableAmount(from, amount);
254 		}
255 	}
256 
257 	function isAccountLocked(address account) internal view returns (bool) {
258 		if (_accountLocked[account] >= block.timestamp) {
259 			return true;
260 		} else {
261 			return false;
262 		}
263 	}
264 
265 	function getTokenLockState() public onlyOwner view returns (bool) {
266 		return _tokenLocked;
267 	}
268 
269 	function getAccountLockState(address account) public onlyOwner view returns (uint256) {
270 		return _accountLocked[account];
271 	}
272 
273 	function getAccountLockState() public view returns (uint256) {
274 		return _accountLocked[msg.sender];
275 	}
276 
277 	function lockToken() public onlyOwner {
278 		_tokenLocked = true;
279 		emit TokenLocked();
280 	}
281 
282 	function unlockToken() public onlyOwner {
283 		_tokenLocked = false; 
284 		emit TokenUnlocked();
285 	}
286 
287 	function lockAccount(address account) public onlyOwner {
288 		_lockAccount(account, INFINITY);
289 	}
290 
291 	function lockAccount(address account, uint256 time) public onlyOwner {
292 		_lockAccount(account, time);
293 	}
294 
295 	function _lockAccount(address account, uint256 time) private onlyOwner {
296 		_accountLocked[account] = time;
297 		emit AccountLocked(account, time);
298 	}
299 
300 	function unlockAccount(address account) public onlyOwner {
301 		if (_accountLocked[account] != 0) {
302 			uint256 lockedTimestamp = _accountLocked[account];
303 			delete _accountLocked[account];
304 			emit AccountUnlocked(account, lockedTimestamp);
305 		}
306 	}
307 
308 	function getUsableLimitInfo(address account) onlyOwner public  view returns (bool, uint256) {
309 		return (_amountLocked[account].isEnable, _amountLocked[account].usableAmount);
310 	}
311 
312 	
313 	
314 	
315 
316 	function setUsableLimitMode(address account, uint256 amount) public onlyOwner {
317 		_setUsableAmount(account, amount);
318 	}
319 
320 	function disableUsableLimitMode(address account) public onlyOwner {
321 		require(_amountLocked[account].isEnable == true, "Lockable: Already disabled.");
322 
323 		_amountLocked[account].isEnable = false;
324 		_amountLocked[account].usableAmount = 0;
325 		emit DisableAmountLimit(account);
326 	}
327 
328 	function increaseUsableAmountLimit(address account, uint256 amount) public onlyOwner {
329 		require(_amountLocked[account].isEnable == true, "Lockable: This account is not set Usable amount limit mode.");
330 		_increaseUsableAmount(account, amount);
331 	}
332 
333 	function decreaseUsableAmountLimit(address account, uint256 amount) public onlyOwner {
334 		require(_amountLocked[account].isEnable == true, "Lockable: This account is not set Usable amount limit mode.");
335 		_decreaseUsableAmount(account, amount);
336 	}
337 
338 	function _increaseUsableAmount(address account, uint256 amount) private {
339 		uint256 val = amount + _amountLocked[account].usableAmount;
340 
341 		_setUsableAmount(account, val);
342 	}
343 
344 	function _decreaseUsableAmount(address account, uint256 amount) private {
345 		uint256 val = _amountLocked[account].usableAmount - amount;
346 
347 		_setUsableAmount(account, val);
348 	}
349 
350 	function _setUsableAmount(address account, uint256 usableAmount) private {
351 		require(balanceOf(account) >= usableAmount, "Lockable: It must not bigger than balance");
352 
353 		if(_amountLocked[account].isEnable == false) {
354 			_amountLocked[account].isEnable = true;
355 		}
356 		_amountLocked[account].usableAmount = usableAmount;
357 		emit EnableAmountLimit(account, usableAmount);
358 	}
359 }
360 
361 contract ERC20Lockable is ERC20, Lockable {
362 	function transfer(address to, uint256 value)
363 	public
364 	whenUnlocked(msg.sender, msg.sender, to)
365 	checkAmountLimit(msg.sender, value)
366 	returns (bool)
367 	{
368 		return super.transfer(to, value);
369 	}
370 
371 	function transferFrom(address from, address to, uint256 value)
372 	public
373 	whenUnlocked(msg.sender, from, to)
374 	checkAmountLimit(from, value)
375 	returns (bool)
376 	{
377 		return super.transferFrom(from, to, value);
378 	}
379 
380 	function approve(address spender, uint256 value) public whenUnlocked(msg.sender, msg.sender, spender) returns (bool) {
381 		return super.approve(spender, value);
382 	}
383 
384 	function increaseAllowance(address spender, uint addedValue) public whenUnlocked(msg.sender, msg.sender, spender) returns (bool) {
385 		return super.increaseAllowance(spender, addedValue);
386 	}
387 
388 	function decreaseAllowance(address spender, uint subtractedValue) public whenUnlocked(msg.sender, msg.sender, spender) returns (bool) {
389 		return super.decreaseAllowance(spender, subtractedValue);
390 	}
391 }
392 
393 contract MediumToken is ERC20, ERC20Detailed, ERC20Burnable, ERC20Lockable {
394 	uint256 private _INITIAL_SUPPLY = 1000000000e18;
395 	string private _TOKEN_NAME = "Medium Token";
396 	string private _TOKEN_SYMBOL = "MDM";
397 	uint8 _DECIMALS = 18;
398 
399 	constructor(address initialWallet) ERC20Detailed(_TOKEN_NAME, _TOKEN_SYMBOL, _DECIMALS) public {
400 		_mint(initialWallet, _INITIAL_SUPPLY);
401 	}
402 }