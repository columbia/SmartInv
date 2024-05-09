1 pragma solidity ^0.6.0;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43   /**
44    * @dev Allows the current owner to relinquish control of the contract.
45    */
46   function renounceOwnership() public onlyOwner {
47     emit OwnershipRenounced(owner);
48     owner = address(0);
49   }
50 }
51 
52 interface ICallable {
53 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
54 }
55 
56 // 
57 /**
58  * @dev Wrappers over Solidity's arithmetic operations with added overflow
59  * checks.
60  *
61  * Arithmetic operations in Solidity wrap on overflow. This can easily result
62  * in bugs, because programmers usually assume that an overflow raises an
63  * error, which is the standard behavior in high level programming languages.
64  * `SafeMath` restores this intuition by reverting the transaction when an
65  * operation overflows.
66  *
67  * Using this library instead of the unchecked operations eliminates an entire
68  * class of bugs, so it's recommended to use it always.
69  */
70 library SafeMath {
71     /**
72      * @dev Returns the addition of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `+` operator.
76      *
77      * Requirements:
78      *
79      * - Addition cannot overflow.
80      */
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         require(c >= a, "SafeMath: addition overflow");
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the subtraction of two unsigned integers, reverting on
90      * overflow (when the result is negative).
91      *
92      * Counterpart to Solidity's `-` operator.
93      *
94      * Requirements:
95      *
96      * - Subtraction cannot overflow.
97      */
98     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99         return sub(a, b, "SafeMath: subtraction overflow");
100     }
101 
102     /**
103      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
104      * overflow (when the result is negative).
105      *
106      * Counterpart to Solidity's `-` operator.
107      *
108      * Requirements:
109      *
110      * - Subtraction cannot overflow.
111      */
112     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
113         require(b <= a, errorMessage);
114         uint256 c = a - b;
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the multiplication of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `*` operator.
124      *
125      * Requirements:
126      *
127      * - Multiplication cannot overflow.
128      */
129     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
131         // benefit is lost if 'b' is also tested.
132         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
133         if (a == 0) {
134             return 0;
135         }
136 
137         uint256 c = a * b;
138         require(c / a == b, "SafeMath: multiplication overflow");
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the integer division of two unsigned integers. Reverts on
145      * division by zero. The result is rounded towards zero.
146      *
147      * Counterpart to Solidity's `/` operator. Note: this function uses a
148      * `revert` opcode (which leaves remaining gas untouched) while Solidity
149      * uses an invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function div(uint256 a, uint256 b) internal pure returns (uint256) {
156         return div(a, b, "SafeMath: division by zero");
157     }
158 
159     /**
160      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
161      * division by zero. The result is rounded towards zero.
162      *
163      * Counterpart to Solidity's `/` operator. Note: this function uses a
164      * `revert` opcode (which leaves remaining gas untouched) while Solidity
165      * uses an invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      *
169      * - The divisor cannot be zero.
170      */
171     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b > 0, errorMessage);
173         uint256 c = a / b;
174         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * Reverts when dividing by zero.
182      *
183      * Counterpart to Solidity's `%` operator. This function uses a `revert`
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
192         return mod(a, b, "SafeMath: modulo by zero");
193     }
194 
195     /**
196      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
197      * Reverts with custom message when dividing by zero.
198      *
199      * Counterpart to Solidity's `%` operator. This function uses a `revert`
200      * opcode (which leaves remaining gas untouched) while Solidity uses an
201      * invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
208         require(b != 0, errorMessage);
209         return a % b;
210     }
211 }
212 
213 contract Defiance is Ownable {
214 
215 	using SafeMath for uint;
216 
217 	uint256 constant private FLOAT_SCALAR = 2**64;
218 	uint256 constant private INITIAL_SUPPLY = 36e23; // 3.6m
219 	uint256 constant private BURN_RATE = 2; // 2% per tx
220 	uint256 constant private SUPPLY_FLOOR = 10; // 1% of 3.6m = 360k
221 	uint256 constant private MIN_STAKE_AMOUNT = 1e21; // 1,000
222 
223 	string constant public name = "Defiance Phoenix";
224 	string constant public symbol = "DEPH";
225 	uint8 constant public decimals = 18;
226 
227 	struct User {
228 		bool whitelisted;
229 		bool pauseWhitelisted;
230 		uint256 balance;
231 		uint256 staked;
232 		mapping(address => uint256) allowance;
233 		int256 scaledPayout;
234 	}
235 
236 	struct Info {
237 		uint256 totalSupply;
238 		uint256 totalStaked;
239 		mapping(address => User) users;
240 		uint256 scaledPayoutPerToken;
241 		address admin;
242 	}
243 	Info private info;
244 
245 
246 	event Transfer(address indexed from, address indexed to, uint256 tokens);
247 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
248 	event Whitelist(address indexed user, bool status);
249 	event PauseWhitelist(address indexed user, bool status);
250 	event Stake(address indexed owner, uint256 tokens);
251 	event Unstake(address indexed owner, uint256 tokens);
252 	event Collect(address indexed owner, uint256 tokens);
253 	event Burn(uint256 tokens);
254 	event Pause();
255 	event Unpause();
256 	event NotPausable();
257 
258 	bool public paused = false;
259 	bool public canPause = true;
260 
261   /**
262    * @dev Modifier to make a function callable only when the contract is not paused.
263    */
264   modifier whenNotPaused() {
265     require(!paused || msg.sender == owner || info.users[msg.sender].pauseWhitelisted, "paused.!");
266     _;
267   }
268    /**
269    * @dev Modifier to make a function callable only when the contract is paused.
270    */
271   modifier whenPaused() {
272     require(paused, "not paused.!");
273     _;
274   }
275   modifier onlyAdmin() {
276     require(msg.sender == info.admin,"only admin.!");
277     _;
278   }
279   /**
280      * @dev called by the owner to pause, triggers stopped state
281      **/
282     function pause() onlyOwner whenNotPaused public {
283         require(canPause == true);
284         paused = true;
285         emit Pause();
286     }
287 
288   /**
289    * @dev called by the owner to unpause, returns to normal state
290    */
291   function unpause() onlyOwner whenPaused public {
292     require(paused == true);
293     paused = false;
294     emit Unpause();
295   }
296 
297   /**
298      * @dev Prevent the token from ever being paused again
299      **/
300     function notPausable() onlyOwner public{
301         paused = false;
302         canPause = false;
303         emit NotPausable();
304     }
305 
306 	constructor() public {
307 		info.admin = msg.sender;
308 		info.totalSupply = INITIAL_SUPPLY;
309 		info.users[msg.sender].balance = INITIAL_SUPPLY;
310 		emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
311 		whitelist(msg.sender, true);
312 		paused = true;
313 	}
314 
315 	function stake(uint256 _tokens)  external whenNotPaused {
316 		_stake(_tokens);
317 	}
318 
319 	function unstake(uint256 _tokens) external whenNotPaused {
320 		_unstake(_tokens);
321 	}
322 
323 	function collect() external whenNotPaused returns (uint256) {
324 		uint256 _dividends = dividendsOf(msg.sender);
325 		require(_dividends >= 0);
326 		info.users[msg.sender].scaledPayout += int256(_dividends.mul(FLOAT_SCALAR));
327 		uint _balance = info.users[msg.sender].balance;
328 		info.users[msg.sender].balance = _balance.add(_dividends);
329 		emit Transfer(address(this), msg.sender, _dividends);
330 		emit Collect(msg.sender, _dividends);
331 		return _dividends;
332 	}
333 
334 	function burn(uint256 _tokens) external {
335 		require(msg.sender != info.admin);
336 		require(balanceOf(msg.sender) >= _tokens);
337 
338 		uint _balance = info.users[msg.sender].balance;
339 		info.users[msg.sender].balance = _balance.sub(_tokens);
340 		uint256 _burnedAmount = _tokens;
341 		if (info.totalStaked > 0) {
342 			_burnedAmount = _burnedAmount.div(2);
343 			uint _scaledPayout = _burnedAmount.mul(FLOAT_SCALAR).div(info.totalStaked);
344 			info.scaledPayoutPerToken = info.scaledPayoutPerToken.add(_scaledPayout);
345 			emit Transfer(msg.sender, address(this), _burnedAmount);
346 		}
347 		info.totalSupply = info.totalSupply.sub(_burnedAmount);
348 		emit Transfer(msg.sender, address(0x0), _burnedAmount);
349 		emit Burn(_burnedAmount);
350 	}
351 
352 	function distribute(uint256 _tokens) external {
353 		require(info.totalStaked > 0);
354 		require(balanceOf(msg.sender) >= _tokens);
355 		uint _balance = info.users[msg.sender].balance;
356 		info.users[msg.sender].balance = _balance.sub(_tokens);
357 		
358 		uint _scaledPayout = _tokens.mul(FLOAT_SCALAR).div(info.totalStaked);
359 		info.scaledPayoutPerToken = info.scaledPayoutPerToken.add(_scaledPayout);
360 		emit Transfer(msg.sender, address(this), _tokens);
361 	}
362 
363 	function transfer(address _to, uint256 _tokens) external whenNotPaused returns (bool) {
364 		_transfer(msg.sender, _to, _tokens);
365 		return true;
366 	}
367 
368 	function approve(address _spender, uint256 _tokens) external whenNotPaused returns (bool) {
369 		info.users[msg.sender].allowance[_spender] = _tokens;
370 		emit Approval(msg.sender, _spender, _tokens);
371 		return true;
372 	}
373 
374 	function transferFrom(address _from, address _to, uint256 _tokens) external whenNotPaused returns (bool) {
375 		require(info.users[_from].allowance[msg.sender] >= _tokens);
376 
377 		uint _balance = info.users[_from].allowance[msg.sender];
378 		info.users[_from].allowance[msg.sender] = _balance.sub(_tokens);
379 		_transfer(_from, _to, _tokens);
380 		return true;
381 	}
382 
383 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external whenNotPaused returns (bool) {
384 		uint256 _transferred = _transfer(msg.sender, _to, _tokens);
385 		uint32 _size;
386 		assembly {
387 			_size := extcodesize(_to)
388 		}
389 		if (_size > 0) {
390 			require(ICallable(_to).tokenCallback(msg.sender, _transferred, _data));
391 		}
392 		return true;
393 	}
394 
395 	function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external whenNotPaused {
396 		require(_receivers.length == _amounts.length);
397 		for (uint256 i = 0; i < _receivers.length; i++) {
398 			_transfer(msg.sender, _receivers[i], _amounts[i]);
399 		}
400 	}
401 
402 	function whitelist(address _user, bool _status) public onlyAdmin {
403 		//require(msg.sender == info.admin);
404 		info.users[_user].whitelisted = _status;
405 		emit Whitelist(_user, _status);
406 	}
407 	function pauseWhitelist(address _user, bool _status) public onlyAdmin {
408 		//require(msg.sender == info.admin);
409 		info.users[_user].pauseWhitelisted = _status;
410 		emit PauseWhitelist(_user, _status);
411 	}
412 
413 	function totalSupply() public view returns (uint256) {
414 		return info.totalSupply;
415 	}
416 
417 	function totalStaked() public view returns (uint256) {
418 		return info.totalStaked;
419 	}
420 
421 	function balanceOf(address _user) public view returns (uint256) {
422 		return info.users[_user].balance.sub(stakedOf(_user));
423 	}
424 
425 	function stakedOf(address _user) public view returns (uint256) {
426 		return info.users[_user].staked;
427 	}
428 
429 	function dividendsOf(address _user) public view returns (uint256) {
430 		return uint256(int256(info.scaledPayoutPerToken.mul(info.users[_user].staked)) - info.users[_user].scaledPayout).div(FLOAT_SCALAR);
431 	}
432 
433 	function allowance(address _user, address _spender) public view returns (uint256) {
434 		return info.users[_user].allowance[_spender];
435 	}
436 
437 	function isWhitelisted(address _user) public view returns (bool) {
438 		return info.users[_user].whitelisted;
439 	}
440 
441 	function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 totalTokensStaked, uint256 userBalance, uint256 userStaked, uint256 userDividends) {
442 		return (totalSupply(), totalStaked(), balanceOf(_user), stakedOf(_user), dividendsOf(_user));
443 	}
444 
445 
446 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
447 		require(balanceOf(_from) >= _tokens);
448 		uint _fromBalance = info.users[_from].balance;
449 		info.users[_from].balance = _fromBalance.sub(_tokens);
450 		
451 		uint256 _burnedAmount = _tokens.mul(BURN_RATE).div(100);
452 		if (totalSupply().sub(_burnedAmount) < INITIAL_SUPPLY.mul(SUPPLY_FLOOR).div(100) || isWhitelisted(_from)) {
453 			_burnedAmount = 0;
454 		}
455 		uint256 _transferred = _tokens.sub(_burnedAmount);
456 		
457 		uint _toBalance = info.users[_to].balance;
458 
459 		info.users[_to].balance = _toBalance.add(_transferred);
460 		emit Transfer(_from, _to, _transferred);
461 		if (_burnedAmount > 0) {
462 			if (info.totalStaked > 0) {
463 				_burnedAmount = _burnedAmount.div(2);
464 				
465 				uint _scaledPayout = _burnedAmount.mul(FLOAT_SCALAR).div(info.totalStaked);
466 
467 				info.scaledPayoutPerToken = info.scaledPayoutPerToken.add(_scaledPayout);
468 				emit Transfer(_from, address(this), _burnedAmount);
469 			}
470 			info.totalSupply = info.totalSupply.sub(_burnedAmount);
471 			emit Transfer(_from, address(0x0), _burnedAmount);
472 			emit Burn(_burnedAmount);
473 		}
474 		return _transferred;
475 	}
476 
477 	function _stake(uint256 _amount) internal {
478 		require(balanceOf(msg.sender) >= _amount);
479 		require(stakedOf(msg.sender).add(_amount) >= MIN_STAKE_AMOUNT);
480 		info.totalStaked = info.totalStaked.add(_amount);
481 
482 		uint _userStaked = info.users[msg.sender].staked;
483 		info.users[msg.sender].staked = _userStaked.add(_amount);
484 		info.users[msg.sender].scaledPayout += int256(_amount.mul(info.scaledPayoutPerToken));
485 		emit Transfer(msg.sender, address(this), _amount);
486 		emit Stake(msg.sender, _amount);
487 	}
488 	function _unstake(uint256 _amount) internal {
489 		require(stakedOf(msg.sender) >= _amount);
490 		uint256 _burnedAmount = _amount.mul(BURN_RATE).div(100);
491 		info.scaledPayoutPerToken = info.scaledPayoutPerToken.add(_burnedAmount.mul(FLOAT_SCALAR).div(info.totalStaked));
492 		info.totalStaked = info.totalStaked.sub(_amount);
493 
494 		uint _userBalance = info.users[msg.sender].balance;
495 		info.users[msg.sender].balance = _userBalance.sub(_burnedAmount);
496 
497 		uint _userStaked = info.users[msg.sender].staked;
498 		info.users[msg.sender].staked = _userStaked.sub(_amount);
499 
500 		info.users[msg.sender].scaledPayout -= int256(_amount.mul(info.scaledPayoutPerToken));
501 		emit Transfer(address(this), msg.sender, _amount.sub(_burnedAmount));
502 		emit Unstake(msg.sender, _amount);
503 	}
504 }