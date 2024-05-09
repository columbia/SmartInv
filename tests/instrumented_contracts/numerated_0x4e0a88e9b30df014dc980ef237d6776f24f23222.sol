1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * See https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address _who) public view returns (uint256);
61   function transfer(address _to, uint256 _value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70   function allowance(address _owner, address _spender)
71     public view returns (uint256);
72 
73   function transferFrom(address _from, address _to, uint256 _value)
74     public returns (bool);
75 
76   function approve(address _spender, uint256 _value) public returns (bool);
77   event Approval(
78     address indexed owner,
79     address indexed spender,
80     uint256 value
81   );
82 }
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89   using SafeMath for uint256;
90 
91   mapping(address => uint256) internal balances;
92 
93   uint256 internal totalSupply_;
94 
95   /**
96   * @dev Total number of tokens in existence
97   */
98   function totalSupply() public view returns (uint256) {
99     return totalSupply_;
100   }
101 
102   /**
103   * @dev Transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint256 _value) public returns (bool) {
108     require(_value <= balances[msg.sender]);
109     require(_to != address(0));
110 
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     emit Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) public view returns (uint256) {
123     return balances[_owner];
124   }
125 
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * https://github.com/ethereum/EIPs/issues/20
133  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(
147     address _from,
148     address _to,
149     uint256 _value
150   )
151     public
152     returns (bool)
153   {
154     require(_value <= balances[_from]);
155     require(_value <= allowed[_from][msg.sender]);
156     require(_to != address(0));
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     emit Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(
187     address _owner,
188     address _spender
189    )
190     public
191     view
192     returns (uint256)
193   {
194     return allowed[_owner][_spender];
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseApproval(
207     address _spender,
208     uint256 _addedValue
209   )
210     public
211     returns (bool)
212   {
213     allowed[msg.sender][_spender] = (
214       allowed[msg.sender][_spender].add(_addedValue));
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(
229     address _spender,
230     uint256 _subtractedValue
231   )
232     public
233     returns (bool)
234   {
235     uint256 oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue >= oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 contract CoblicAccessControl {
248 	/**
249 	 *		- The Admin: The admin can reassign other roles and change the addresses of Coblic's smart contracts.
250 	 *			It is also the only role that can unpause the smart contract, and is initially set to the address
251 	 *			that created the smart contract in the CoblicToken constructor.
252 	 *
253 	 *		- The System: The System can call burn function
254 	 *
255 	 */
256 
257 	// The addresses of the accounts (or contracts) that can execute actions within each roles.
258 	address public adminAddress;
259 	address public systemAddress;
260 	address public ceoAddress;
261 
262 	/// @dev Access modifier for Admin-only functionality
263 	modifier onlyAdmin() {
264 		require(msg.sender == adminAddress);
265 		_;
266 	}
267 
268 	// @dev Access modifier for CEO-only functionality
269 	modifier onlyCEO() {
270 		require(msg.sender == ceoAddress || msg.sender == adminAddress);
271 		_;
272 	}
273 
274 	/// @dev Access modifier for System-only functionality
275 	modifier onlySystem() {
276 		require(msg.sender == systemAddress || msg.sender == adminAddress);
277 		_;
278 	}
279 
280 	/// @dev Assigns a new address to act as the Admin. Only available to the current Admin.
281 	/// @param _newAdminAddress The address of the new Admin
282 	function setAdmin(address _newAdminAddress) public onlyAdmin {
283 		require(_newAdminAddress != address(0));
284 
285 		adminAddress = _newAdminAddress;
286 	}
287 
288 	/// @dev Assigns a new address to act as the System. Only available to the current Admin.
289 	/// @param _newSystemAddress The address of the new System
290 	function setSystem(address _newSystemAddress) public onlySystem {
291 		require(_newSystemAddress != address(0));
292 
293 		systemAddress = _newSystemAddress;
294 	}
295 
296 	/// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
297 	/// @param _newCEOAddress The address of the new CEO
298 	function setCEO(address _newCEOAddress) public onlyCEO {
299 		require(_newCEOAddress != address(0));
300 
301 		ceoAddress = _newCEOAddress;
302 	}
303 }
304 
305 /**
306  * @title ERC1132 interface
307  * @dev see https://github.com/ethereum/EIPs/issues/1132
308  */
309 
310 contract ERC1132 {
311 	/**
312 	 * @dev Reasons why a user's tokens have been locked
313 	 */
314 	mapping(address => bytes32[]) public lockReason;
315 
316 	/**
317 	 * @dev locked token structure
318 	 */
319 	struct lockToken {
320 		uint256 amount;
321 		uint256 validity;
322 		bool claimed;
323 	}
324 
325 	/**
326 	 * @dev Holds number & validity of tokens locked for a given reason for
327 	 *      a specified address
328 	 */
329 	mapping(address => mapping(bytes32 => lockToken)) public locked;
330 
331 	/**
332 	 * @dev Records data of all the tokens Locked
333 	 */
334 	event Locked(
335 			address indexed _of,
336 			bytes32 indexed _reason,
337 			uint256 _amount,
338 			uint256 _validity
339 			);
340 
341 	/**
342 	 * @dev Records data of all the tokens unlocked
343 	 */
344 	event Unlocked(
345 			address indexed _of,
346 			bytes32 indexed _reason,
347 			uint256 _amount
348 			);
349 
350 	/**
351 	 * @dev Locks a specified amount of tokens against an address,
352 	 *      for a specified reason and time
353 	 * @param _reason The reason to lock tokens
354 	 * @param _amount Number of tokens to be locked
355 	 * @param _time Lock time in seconds
356 	 * @param _of address to be locked
357 	 */
358 	function lock(bytes32 _reason, uint256 _amount, uint256 _time, address _of)
359 		public returns (bool);
360 
361 	/**
362 	 * @dev Returns tokens locked for a specified address for a
363 	 *      specified reason
364 	 *
365 	 * @param _of The address whose tokens are locked
366 	 * @param _reason The reason to query the lock tokens for
367 	 */
368 	function tokensLocked(address _of, bytes32 _reason)
369 		public view returns (uint256 amount);
370 
371 	/**
372 	 * @dev Returns tokens locked for a specified address for a
373 	 *      specified reason at a specific time
374 	 *
375 	 * @param _of The address whose tokens are locked
376 	 * @param _reason The reason to query the lock tokens for
377 	 * @param _time The timestamp to query the lock tokens for
378 	 */
379 	function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
380 		public view returns (uint256 amount);
381 
382 	/**
383 	 * @dev Returns total tokens held by an address (locked + transferable)
384 	 * @param _of The address to query the total balance of
385 	 */
386 	function totalBalanceOf(address _of)
387 		public view returns (uint256 amount);
388 
389 	/**
390 	 * @dev Extends lock for a specified reason and time
391 	 * @param _reason The reason to lock tokens
392 	 * @param _time Lock extension time in seconds
393 	 */
394 	function extendLock(bytes32 _reason, uint256 _time)
395 		public returns (bool);
396 
397 	/**
398 	 * @dev Increase number of tokens locked for a specified reason
399 	 * @param _reason The reason to lock tokens
400 	 * @param _amount Number of tokens to be increased
401 	 */
402 	function increaseLockAmount(bytes32 _reason, uint256 _amount)
403 		public returns (bool);
404 
405 	/**
406 	 * @dev Returns unlockable tokens for a specified address for a specified reason
407 	 * @param _of The address to query the the unlockable token count of
408 	 * @param _reason The reason to query the unlockable tokens for
409 	 */
410 	function tokensUnlockable(address _of, bytes32 _reason)
411 		public view returns (uint256 amount);
412 
413 	/**
414 	 * @dev Unlocks the unlockable tokens of a specified address
415 	 * @param _of Address of user, claiming back unlockable tokens
416 	 */
417 	function unlock(address _of)
418 		public returns (uint256 unlockableTokens);
419 
420 	/**
421 	 * @dev Gets the unlockable tokens of a specified address
422 	 * @param _of The address to query the the unlockable token count of
423 	 */
424 	function getUnlockableTokens(address _of)
425 		public view returns (uint256 unlockableTokens);
426 
427 }
428 
429 contract CoblicToken is StandardToken, CoblicAccessControl, ERC1132 {
430 	// Define constants
431 	string public constant name = "Coblic Token";
432 	string public constant symbol = "CT";
433 	uint256 public constant decimals = 18;
434 	uint256 public constant INITIAL_SUPPLY = 20000000000 * (10 ** decimals);
435 
436 	event Mint(address minter, uint256 value);
437 	event Burn(address burner, uint256 value);
438 
439 	/**
440 	 * @dev Error messages for require statements
441 	 */
442 	string internal constant INVALID_TOKEN_VALUES = 'Invalid token values';
443 	string internal constant NOT_ENOUGH_TOKENS = 'Not enough tokens';
444 	string internal constant ALREADY_LOCKED = 'Tokens already locked';
445 	string internal constant NOT_LOCKED = 'No tokens locked';
446 	string internal constant AMOUNT_ZERO = 'Amount can not be 0';
447 
448 	constructor(address _adminAddress, address _systemAddress, address _ceoAddress) public {
449 		adminAddress = _adminAddress;
450 		systemAddress = _systemAddress;
451 		ceoAddress = _ceoAddress;
452 		totalSupply_ = INITIAL_SUPPLY;
453 		balances[adminAddress] = INITIAL_SUPPLY;
454 	}
455 
456 	/**
457 	 * admin or system can call burn function to burn tokens in 0x0 address
458 	 */
459 
460 	/**
461 	 * @dev Mint a specified amount of tokens to the Admin address. Only available to the Admin.
462 	 * @param _to address to mint
463 	 * @param _amount an amount value to be minted
464 	 */
465 	function mint(address _to, uint256 _amount) public onlyAdmin {
466 		require(_amount > 0, INVALID_TOKEN_VALUES);
467 		balances[_to] = balances[_to].add(_amount);
468 		totalSupply_ = totalSupply_.add(_amount);
469 		emit Mint(_to, _amount);
470 	}
471 
472 	/**
473 	 * @dev Burn a specified amount of tokens in msg.sender. Only available to the Admin and System.
474 	 * @param _of address to burn
475 	 * @param _amount an amount value to be burned
476 	 */
477 	function burn(address _of, uint256 _amount) public onlySystem {
478 		require(_amount > 0, INVALID_TOKEN_VALUES);
479 		require(_amount <= balances[_of], NOT_ENOUGH_TOKENS);
480 		balances[_of] = balances[_of].sub(_amount);
481 		totalSupply_ = totalSupply_.sub(_amount);
482 		emit Burn(_of, _amount);
483 	}
484 
485 	/**
486 	 * @dev Locks a specified amount of tokens against an address,
487 	 *      for a specified reason and time
488 	 * @param _reason The reason to lock tokens
489 	 * @param _amount Number of tokens to be locked
490 	 * @param _time Lock time in seconds
491 	 * @param _of address to be locked
492 	 */
493 	function lock(bytes32 _reason, uint256 _amount, uint256 _time, address _of) public onlyAdmin returns (bool) {
494 		uint256 validUntil = now.add(_time); //solhint-disable-line
495 
496 		// If tokens are already locked, then functions extendLock or
497 		// increaseLockAmount should be used to make any changes
498 		require(_amount <= balances[_of], NOT_ENOUGH_TOKENS);
499 		require(tokensLocked(_of, _reason) == 0, ALREADY_LOCKED);
500 		require(_amount != 0, AMOUNT_ZERO);
501 
502 		if (locked[_of][_reason].amount == 0)
503 			lockReason[_of].push(_reason);
504 
505 		balances[address(this)] = balances[address(this)].add(_amount);
506 		balances[_of] = balances[_of].sub(_amount);
507 
508 		locked[_of][_reason] = lockToken(_amount, validUntil, false);
509 
510 		emit Transfer(_of, address(this), _amount);
511 		emit Locked(_of, _reason, _amount, validUntil);
512 		return true;
513 	}
514 
515 	/**
516 	 * @dev Transfers and Locks a specified amount of tokens,
517 	 *      for a specified reason and time
518 	 * @param _to adress to which tokens are to be transfered
519 	 * @param _reason The reason to lock tokens
520 	 * @param _amount Number of tokens to be transfered and locked
521 	 * @param _time Lock time in seconds
522 	 */
523 	function transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time) public returns (bool) {
524 		uint256 validUntil = now.add(_time); //solhint-disable-line
525 
526 		require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);
527 		require(_amount != 0, AMOUNT_ZERO);
528 
529 		if (locked[_to][_reason].amount == 0)
530 			lockReason[_to].push(_reason);
531 
532 		transfer(address(this), _amount);
533 
534 		locked[_to][_reason] = lockToken(_amount, validUntil, false);
535 
536 		emit Locked(_to, _reason, _amount, validUntil);
537 		return true;
538 	}
539 
540 	/**
541 	 * @dev Returns tokens locked for a specified address for a
542 	 *      specified reason
543 	 *
544 	 * @param _of The address whose tokens are locked
545 	 * @param _reason The reason to query the lock tokens for
546 	 */
547 	function tokensLocked(address _of, bytes32 _reason) public view returns (uint256 amount) {
548 		if (!locked[_of][_reason].claimed)
549 			amount = locked[_of][_reason].amount;
550 	}
551 
552 	/**
553 	 * @dev Returns tokens locked for a specified address for a
554 	 *      specified reason at a specific time
555 	 *
556 	 * @param _of The address whose tokens are locked
557 	 * @param _reason The reason to query the lock tokens for
558 	 * @param _time The timestamp to query the lock tokens for
559 	 */
560 	function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time) public view returns (uint256 amount) {
561 		if (locked[_of][_reason].validity > _time)
562 			amount = locked[_of][_reason].amount;
563 	}
564 
565 	/**
566 	 * @dev Returns total tokens held by an address (locked + transferable)
567 	 * @param _of The address to query the total balance of
568 	 */
569 	function totalBalanceOf(address _of) public view returns (uint256 amount) {
570 		amount = balanceOf(_of);
571 
572 		for (uint256 i = 0; i < lockReason[_of].length; i++) {
573 			amount = amount.add(tokensLocked(_of, lockReason[_of][i]));
574 		}
575 	}
576 
577 	/**
578 	 * @dev Extends lock for a specified reason and time
579 	 * @param _reason The reason to lock tokens
580 	 * @param _time Lock extension time in seconds
581 	 */
582 	function extendLock(bytes32 _reason, uint256 _time) public returns (bool) {
583 		require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
584 
585 		locked[msg.sender][_reason].validity = locked[msg.sender][_reason].validity.add(_time);
586 
587 		emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
588 		return true;
589 	}
590 
591 	/**
592 	 * @dev Increase number of tokens locked for a specified reason
593 	 * @param _reason The reason to lock tokens
594 	 * @param _amount Number of tokens to be increased
595 	 */
596 	function increaseLockAmount(bytes32 _reason, uint256 _amount) public returns (bool) {
597 		require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
598 		transfer(address(this), _amount);
599 
600 		locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);
601 
602 		emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
603 		return true;
604 	}
605 
606 	/**
607 	 * @dev Returns unlockable tokens for a specified address for a specified reason
608 	 * @param _of The address to query the the unlockable token count of
609 	 * @param _reason The reason to query the unlockable tokens for
610 	 */
611 	function tokensUnlockable(address _of, bytes32 _reason) public view returns (uint256 amount) {
612 		if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) //solhint-disable-line
613 			amount = locked[_of][_reason].amount;
614 	}
615 
616 	/**
617 	 * @dev Unlocks the unlockable tokens of a specified address
618 	 * @param _of Address of user, claiming back unlockable tokens
619 	 */
620 	function unlock(address _of) public returns (uint256 unlockableTokens) {
621 		uint256 lockedTokens;
622 
623 		for (uint256 i = 0; i < lockReason[_of].length; i++) {
624 			lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);
625 			if (lockedTokens > 0) {
626 				unlockableTokens = unlockableTokens.add(lockedTokens);
627 				locked[_of][lockReason[_of][i]].claimed = true;
628 				emit Unlocked(_of, lockReason[_of][i], lockedTokens);
629 			}
630 		}  
631 
632 		if (unlockableTokens > 0)
633 			this.transfer(_of, unlockableTokens);
634 	}
635 
636 	/**
637 	 * @dev Gets the unlockable tokens of a specified address
638 	 * @param _of The address to query the the unlockable token count of
639 	 */
640 	function getUnlockableTokens(address _of) public view returns (uint256 unlockableTokens) {
641 		for (uint256 i = 0; i < lockReason[_of].length; i++) {
642 			unlockableTokens = unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));
643 		}  
644 	}
645 }