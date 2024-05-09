1 pragma solidity ^0.4.24;
2 
3 
4 
5 
6 /**
7 * @title SafeMath
8 * @dev Math operations with safety checks that revert on error
9 */
10 library SafeMath {
11 
12 
13 
14 
15 	/**
16 	* @dev Multiplies two numbers, reverts on overflow.
17 	*/
18 	function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
19 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
20 		// benefit is lost if 'b' is also tested.
21 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
22 		if (_a == 0) {
23 			return 0;
24 		}
25 
26 
27 
28 
29 		uint256 c = _a * _b;
30 		require(c / _a == _b);
31 
32 
33 
34 
35 		return c;
36 	}
37 
38 
39 
40 
41 	/**
42 	* @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
43 	*/
44 	function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45 		require(_b > 0); // Solidity only automatically asserts when dividing by 0
46 		uint256 c = _a / _b;
47 		// assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48 
49 
50 
51 
52 		return c;
53 	}
54 
55 
56 
57 
58 	/**
59 	* @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
60 	*/
61 	function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
62 		require(_b <= _a);
63 		uint256 c = _a - _b;
64 
65 
66 
67 
68 		return c;
69 	}
70 
71 
72 
73 
74 	/**
75 	* @dev Adds two numbers, reverts on overflow.
76 	*/
77 	function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
78 		uint256 c = _a + _b;
79 		require(c >= _a);
80 
81 
82 
83 
84 		return c;
85 	}
86 }
87 
88 
89 
90 
91 /**
92 * @title Ownable
93 * @dev The Ownable contract has an owner address, and provides basic authorization control
94 * functions, this simplifies the implementation of "user permissions".
95 */
96 
97 
98 
99 
100 contract Ownable {
101 	address internal _owner;
102 
103 
104 
105 
106 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
107 
108 
109 
110 
111 	/*
112 	* @dev The Ownable constructor sets the original `owner` o the contract to the sender account
113 	*/
114 	constructor() public {
115 		_owner = msg.sender;
116 	}
117 
118 
119 
120 
121 	/**
122 	* @dev Throws if called by any account other than the owner.
123 	*/
124 	modifier onlyOwner() {
125 		require(msg.sender == _owner);
126 		_;
127 	}
128 
129 
130 
131 
132 	/**
133 	* @dev Allows the current owner to transfer control of the contract to a newOwner.
134 	* @param newOwner The address to transfer ownership to.
135 	*/
136 	function transferOwnership(address newOwner) onlyOwner() public {
137 		require(newOwner != _owner);
138 		_transferOwnership(newOwner);
139 	}
140 
141 
142 
143 
144 	/**
145 	* @dev Transfers control of the contract to a newOwner.
146 	* @param newOwner The address to transfer ownership to.
147 	*/
148 	function _transferOwnership(address newOwner) internal {
149 		require(newOwner != address(0));
150 		emit OwnershipTransferred(_owner, newOwner);
151 		_owner = newOwner;
152 	}
153 
154 
155 
156 
157 	function getOwner() public constant returns(address) {
158 		return (_owner);
159 	}
160 }
161 
162 
163 
164 
165 /**
166 * @title Pausable
167 * @dev Base contract which allows children to implement an emergency stop mechanism.
168 */
169 contract Pausable is Ownable {
170 	event Paused();
171 	event Unpaused();
172 
173 
174 
175 
176 	bool public paused = false;
177 
178 
179 
180 
181 
182 
183 
184 
185 	/**
186 	* @dev Modifier to make a function callable only when the contract is not paused.
187 	*/
188 	modifier whenNotPaused() {
189 			require(!paused);
190 		_;
191 	}
192 
193 
194 
195 
196 	/**
197 	* @dev Modifier to make a function callable only when the contract is paused.
198 	*/
199 	modifier whenPaused() {
200 		require(paused);
201 		_;
202 	}
203 
204 
205 
206 
207 	/**
208 	* @dev called by the owner to pause, triggers stopped state
209 	*/
210 	function pause() public onlyOwner whenNotPaused {
211 		paused = true;
212 		emit Paused();
213 	}
214 
215 
216 
217 
218 	/**
219 	* @dev called by the owner to unpause, returns to normal state
220 	*/
221 	function unpause() public onlyOwner whenPaused {
222 		paused = false;
223 		emit Unpaused();
224 	}
225 }
226 
227 
228 
229 
230 /**
231 * @title ERC20 interface
232 * @dev see https://github.com/ethereum/EIPs/issues/20
233 */
234 interface IERC20 {
235 	function totalSupply()
236 		external view returns (uint256);
237 
238 
239 
240 
241 	function balanceOf(address _who)
242 		external view returns (uint256);
243 
244 
245 
246 
247 	function allowance(address _owner, address _spender)
248 		external view returns (uint256);
249 
250 
251 
252 
253 	function transfer(address _to, uint256 _value)
254 		external returns (bool);
255 
256 
257 
258 
259 	function approve(address _spender, uint256 _value)
260 		external returns (bool);
261 
262 
263 
264 
265 	function transferFrom(address _from, address _to, uint256 _value)
266 		external returns (bool);
267 
268 
269 
270 
271 	event Transfer(
272 		address indexed from,
273 		address indexed to,
274 		uint256 value
275 	);
276 
277 
278 
279 
280 	event Approval(
281 		address indexed owner,
282 		address indexed spender,
283 		uint256 value
284 	);
285 }
286 
287 
288 
289 
290 
291 
292 
293 
294 /**
295 * @title Standard ERC20 token
296 *
297 * @dev Implementation of the basic standard token.
298 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
299 * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
300 */
301 contract ERC20 is IERC20 {
302 	using SafeMath for uint256;
303 
304 
305 
306 
307 	mapping (address => uint256) internal balances_;
308 
309 
310 
311 
312 	mapping (address => mapping (address => uint256)) internal allowed_;
313 
314 
315 
316 
317 	uint256 internal totalSupply_;
318 
319 
320 
321 
322 	/**
323 	* @dev Total number of tokens in existence
324 	*/
325 	function totalSupply() public view returns (uint256) {
326 		return totalSupply_;
327 	}
328 
329 
330 
331 
332 	/**
333 	* @dev Gets the balance of the specified address.
334 	* @param _owner The address to query the the balance of.
335 	* @return An uint256 representing the amount owned by the passed address.
336 	*/
337 	function balanceOf(address _owner) public view returns (uint256) {
338 		return balances_[_owner];
339 	}
340 
341 
342 
343 
344 	/**
345 	* @dev Function to check the amount of tokens that an owner allowed to a spender.
346 	* @param _owner address The address which owns the funds.
347 	* @param _spender address The address which will spend the funds.
348 	* @return A uint256 specifying the amount of tokens still available for the spender.
349 	*/
350 	function allowance(
351 		address _owner,
352 		address _spender
353 	 )
354 		public
355 		view
356 		returns (uint256)
357 	{
358 		return allowed_[_owner][_spender];
359 	}
360 
361 
362 
363 
364 	/**
365 	* @dev Transfer token for a specified address
366 	* @param _to The address to transfer to.
367 	* @param _value The amount to be transferred.
368 	*/
369 	function transfer(address _to, uint256 _value) public returns (bool) {
370 		require(_value <= balances_[msg.sender]);
371 		require(_to != address(0));
372 
373 
374 
375 
376 		balances_[msg.sender] = balances_[msg.sender].sub(_value);
377 		balances_[_to] = balances_[_to].add(_value);
378 		emit Transfer(msg.sender, _to, _value);
379 		return true;
380 	}
381 
382 
383 
384 
385 	/**
386 	* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
387 	* Beware that changing an allowance with this method brings the risk that someone may use both the old
388 	* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
389 	* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
390 	* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
391 	* @param _spender The address which will spend the funds.
392 	* @param _value The amount of tokens to be spent.
393 	*/
394 	function approve(address _spender, uint256 _value) public returns (bool) {
395 		allowed_[msg.sender][_spender] = _value;
396 		emit Approval(msg.sender, _spender, _value);
397 		return true;
398 	}
399 
400 
401 
402 
403 	/**
404 	* @dev Transfer tokens from one address to another
405 	* @param _from address The address which you want to send tokens from
406 	* @param _to address The address which you want to transfer to
407 	* @param _value uint256 the amount of tokens to be transferred
408 	*/
409 	function transferFrom(
410 		address _from,
411 		address _to,
412 		uint256 _value
413 	)
414 		public
415 		returns (bool)
416 	{
417 		require(_value <= balances_[_from]);
418 		require(_value <= allowed_[_from][msg.sender]);
419 		require(_to != address(0));
420 
421 
422 
423 
424 		balances_[_from] = balances_[_from].sub(_value);
425 		balances_[_to] = balances_[_to].add(_value);
426 		allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
427 		emit Transfer(_from, _to, _value);
428 		return true;
429 	}
430 
431 
432 
433 
434 	/**
435 	* @dev Internal function that mints an amount of the token and assigns it to
436 	* an account. This encapsulates the modification of balances such that the
437 	* proper events are emitted.
438 	* @param _account The account that will receive the created tokens.
439 	* @param _amount The amount that will be created.
440 	*/
441 	function _mint(address _account, uint256 _amount) internal {
442 		require(_account != 0);
443 		totalSupply_ = totalSupply_.add(_amount);
444 		balances_[_account] = balances_[_account].add(_amount);
445 		emit Transfer(address(0), _account, _amount);
446 	}
447 }
448 
449 
450 
451 
452 
453 
454 
455 
456 /**
457 * @title Pausable token
458 * @dev ERC20 modified with pausable transfers.
459 **/
460 contract ERC20Pausable is ERC20, Pausable {
461 
462 
463 
464 
465 	function transfer(
466 		address _to,
467 		uint256 _value
468 	)
469 		public
470 		whenNotPaused
471 		returns (bool)
472 	{
473 		return super.transfer(_to, _value);
474 	}
475 
476 
477 
478 
479 	function transferFrom(
480 		address _from,
481 		address _to,
482 		uint256 _value
483 	)
484 		public
485 		whenNotPaused
486 		returns (bool)
487 	{
488 		return super.transferFrom(_from, _to, _value);
489 	}
490 
491 
492 
493 
494 	function approve(
495 		address _spender,
496 		uint256 _value
497 	)
498 		public
499 		whenNotPaused
500 		returns (bool)
501 	{
502 		return super.approve(_spender, _value);
503 	}
504 }
505 
506 
507 
508 
509 
510 
511 
512 
513 
514 
515 
516 
517 contract BetMatchToken is ERC20Pausable {
518 	string public constant name = "XBM";
519 	string public constant symbol = "XBM";
520 	uint8 public constant decimals = 18;
521 
522 
523 
524 
525 	uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
526 
527 
528 
529 
530 	constructor () public {
531 		totalSupply_ = INITIAL_SUPPLY;
532 		balances_[msg.sender] = INITIAL_SUPPLY;
533 		emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
534 	}
535 }