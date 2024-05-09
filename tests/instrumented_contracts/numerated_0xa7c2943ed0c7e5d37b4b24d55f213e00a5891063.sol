1 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * See https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address _who) public view returns (uint256);
14   function transfer(address _to, uint256 _value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
19 
20 pragma solidity ^0.4.24;
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
33     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (_a == 0) {
37       return 0;
38     }
39 
40     c = _a * _b;
41     assert(c / _a == _b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
49     // assert(_b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = _a / _b;
51     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
52     return _a / _b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
59     assert(_b <= _a);
60     return _a - _b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
67     c = _a + _b;
68     assert(c >= _a);
69     return c;
70   }
71 }
72 
73 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
74 
75 pragma solidity ^0.4.24;
76 
77 
78 
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) internal balances;
88 
89   uint256 internal totalSupply_;
90 
91   /**
92   * @dev Total number of tokens in existence
93   */
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97 
98   /**
99   * @dev Transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_value <= balances[msg.sender]);
105     require(_to != address(0));
106 
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     emit Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
125 
126 pragma solidity ^0.4.24;
127 
128 
129 
130 /**
131  * @title ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/20
133  */
134 contract ERC20 is ERC20Basic {
135   function allowance(address _owner, address _spender)
136     public view returns (uint256);
137 
138   function transferFrom(address _from, address _to, uint256 _value)
139     public returns (bool);
140 
141   function approve(address _spender, uint256 _value) public returns (bool);
142   event Approval(
143     address indexed owner,
144     address indexed spender,
145     uint256 value
146   );
147 }
148 
149 // File: openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
150 
151 pragma solidity ^0.4.24;
152 
153 
154 
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * https://github.com/ethereum/EIPs/issues/20
161  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165   mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     public
180     returns (bool)
181   {
182     require(_value <= balances[_from]);
183     require(_value <= allowed[_from][msg.sender]);
184     require(_to != address(0));
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     emit Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     emit Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(
215     address _owner,
216     address _spender
217    )
218     public
219     view
220     returns (uint256)
221   {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(
235     address _spender,
236     uint256 _addedValue
237   )
238     public
239     returns (bool)
240   {
241     allowed[msg.sender][_spender] = (
242       allowed[msg.sender][_spender].add(_addedValue));
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247   /**
248    * @dev Decrease the amount of tokens that an owner allowed to a spender.
249    * approve should be called when allowed[_spender] == 0. To decrement
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _subtractedValue The amount of tokens to decrease the allowance by.
255    */
256   function decreaseApproval(
257     address _spender,
258     uint256 _subtractedValue
259   )
260     public
261     returns (bool)
262   {
263     uint256 oldValue = allowed[msg.sender][_spender];
264     if (_subtractedValue >= oldValue) {
265       allowed[msg.sender][_spender] = 0;
266     } else {
267       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
268     }
269     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273 }
274 
275 // File: openzeppelin-solidity\contracts\ownership\Ownable.sol
276 
277 pragma solidity ^0.4.24;
278 
279 
280 /**
281  * @title Ownable
282  * @dev The Ownable contract has an owner address, and provides basic authorization control
283  * functions, this simplifies the implementation of "user permissions".
284  */
285 contract Ownable {
286   address public owner;
287 
288 
289   event OwnershipRenounced(address indexed previousOwner);
290   event OwnershipTransferred(
291     address indexed previousOwner,
292     address indexed newOwner
293   );
294 
295 
296   /**
297    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
298    * account.
299    */
300   constructor() public {
301     owner = msg.sender;
302   }
303 
304   /**
305    * @dev Throws if called by any account other than the owner.
306    */
307   modifier onlyOwner() {
308     require(msg.sender == owner);
309     _;
310   }
311 
312   /**
313    * @dev Allows the current owner to relinquish control of the contract.
314    * @notice Renouncing to ownership will leave the contract without an owner.
315    * It will not be possible to call the functions with the `onlyOwner`
316    * modifier anymore.
317    */
318   function renounceOwnership() public onlyOwner {
319     emit OwnershipRenounced(owner);
320     owner = address(0);
321   }
322 
323   /**
324    * @dev Allows the current owner to transfer control of the contract to a newOwner.
325    * @param _newOwner The address to transfer ownership to.
326    */
327   function transferOwnership(address _newOwner) public onlyOwner {
328     _transferOwnership(_newOwner);
329   }
330 
331   /**
332    * @dev Transfers control of the contract to a newOwner.
333    * @param _newOwner The address to transfer ownership to.
334    */
335   function _transferOwnership(address _newOwner) internal {
336     require(_newOwner != address(0));
337     emit OwnershipTransferred(owner, _newOwner);
338     owner = _newOwner;
339   }
340 }
341 
342 // File: openzeppelin-solidity\contracts\token\ERC1132\ERC1132.sol
343 
344 pragma solidity ^0.4.24;
345 
346 contract ERC1132 {
347     /**
348      * @dev Reasons why a user's tokens have been locked
349      */
350     mapping(address => bytes32[]) public lockReason;
351 
352     /**
353      * @dev locked token structure
354      */
355     struct lockToken {
356         uint256 amount;
357         uint256 validity;
358         bool claimed;
359     }
360 
361     /**
362      * @dev Holds number & validity of tokens locked for a given reason for
363      *      a specified address
364      */
365     mapping(address => mapping(bytes32 => lockToken)) public locked;
366 
367     /**
368      * @dev Records data of all the tokens Locked
369      */
370     event Locked(
371         address indexed _of,
372         bytes32 indexed _reason,
373         uint256 _amount,
374         uint256 _validity
375     );
376 
377     /**
378      * @dev Records data of all the tokens unlocked
379      */
380     event Unlocked(
381         address indexed _of,
382         bytes32 indexed _reason,
383         uint256 _amount
384     );
385     
386     /**
387      * @dev Locks a specified amount of tokens against an address,
388      *      for a specified reason and time
389      * @param _reason The reason to lock tokens
390      * @param _amount Number of tokens to be locked
391      * @param _time Lock time in seconds
392      */
393     function lock(bytes32 _reason, uint256 _amount, uint256 _time, address _of)
394         public returns (bool);
395   
396     /**
397      * @dev Returns tokens locked for a specified address for a
398      *      specified reason
399      *
400      * @param _of The address whose tokens are locked
401      * @param _reason The reason to query the lock tokens for
402      */
403     function tokensLocked(address _of, bytes32 _reason)
404         public view returns (uint256 amount);
405     
406     /**
407      * @dev Returns tokens locked for a specified address for a
408      *      specified reason at a specific time
409      *
410      * @param _of The address whose tokens are locked
411      * @param _reason The reason to query the lock tokens for
412      * @param _time The timestamp to query the lock tokens for
413      */
414     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
415         public view returns (uint256 amount);
416     
417     /**
418      * @dev Returns total tokens held by an address (locked + transferable)
419      * @param _of The address to query the total balance of
420      */
421     function totalBalanceOf(address _of)
422         public view returns (uint256 amount);
423     
424     /**
425      * @dev Extends lock for a specified reason and time
426      * @param _reason The reason to lock tokens
427      * @param _time Lock extension time in seconds
428      */
429     function extendLock(bytes32 _reason, uint256 _time)
430         public returns (bool);
431     
432     /**
433      * @dev Increase number of tokens locked for a specified reason
434      * @param _reason The reason to lock tokens
435      * @param _amount Number of tokens to be increased
436      */
437     function increaseLockAmount(bytes32 _reason, uint256 _amount)
438         public returns (bool);
439 
440     /**
441      * @dev Returns unlockable tokens for a specified address for a specified reason
442      * @param _of The address to query the the unlockable token count of
443      * @param _reason The reason to query the unlockable tokens for
444      */
445     function tokensUnlockable(address _of, bytes32 _reason)
446         public view returns (uint256 amount);
447  
448     /**
449      * @dev Unlocks the unlockable tokens of a specified address
450      * @param _of Address of user, claiming back unlockable tokens
451      */
452     function unlock(address _of)
453         public returns (uint256 unlockableTokens);
454 
455     /**
456      * @dev Gets the unlockable tokens of a specified address
457      * @param _of The address to query the the unlockable token count of
458      */
459     function getUnlockableTokens(address _of)
460         public view returns (uint256 unlockableTokens);
461 
462 }
463 
464 // File: contracts\BiibroSToken.sol
465 
466 pragma solidity ^0.4.24;
467 
468 // Import
469 
470 
471 
472 
473 
474 // Contract
475 contract BiibroSToken is StandardToken, Ownable, ERC1132 {
476 	// Define constants
477 	string public constant name 					= "S-Token";
478 	string public constant symbol 					= "STO";
479 	uint256 public constant decimals 				= 18;
480 	uint256 public constant INITIAL_SUPPLY 				= 500000000000 * (10 ** decimals);
481     
482 	constructor() public {
483         	totalSupply_ 						= INITIAL_SUPPLY;
484 		balances[msg.sender] 					= INITIAL_SUPPLY;
485 	}
486 
487 	// Define events
488     	event Mint(address minter, uint256 value);
489 	event Burn(address burner, uint256 value);
490 
491 	// Dev Error messages for require statements
492 	string internal constant INVALID_TOKEN_VALUES 			= 'Invalid token values';
493 	string internal constant NOT_ENOUGH_TOKENS 			= 'Not enough tokens';
494 	string internal constant ALREADY_LOCKED 			= 'Tokens already locked';
495 	string internal constant NOT_LOCKED 				= 'No tokens locked';
496 	string internal constant AMOUNT_ZERO 				= 'Amount can not be 0';
497 
498 	// Mint
499 	function mint(address _to, uint256 _amount) public onlyOwner {
500         	require(_amount > 0, INVALID_TOKEN_VALUES);
501         	
502 		balances[_to] 						= balances[_to].add(_amount);
503         	totalSupply_ 						= totalSupply_.add(_amount);
504         	
505 		emit Mint(_to, _amount);
506 	}	
507 
508 	// Burn
509 	function burn(address _of, uint256 _amount) public onlyOwner {
510         	require(_amount > 0, INVALID_TOKEN_VALUES);
511         	require(_amount <= balances[_of], NOT_ENOUGH_TOKENS);
512         	
513 		balances[_of] 						= balances[_of].sub(_amount);
514         	totalSupply_ 						= totalSupply_.sub(_amount);
515         	
516 		emit Burn(_of, _amount);
517 	}
518 
519 	// Lock - Important
520     	function lock(bytes32 _reason, uint256 _amount, uint256 _time, address _of) public onlyOwner returns (bool) {
521         	uint256 validUntil 					= now.add(_time);
522 
523 		require(_amount <= balances[_of], NOT_ENOUGH_TOKENS);
524 		require(tokensLocked(_of, _reason) == 0, ALREADY_LOCKED);
525 		require(_amount != 0, AMOUNT_ZERO);
526 
527 		if (locked[_of][_reason].amount == 0)
528 			lockReason[_of].push(_reason);
529 
530 		balances[address(this)] = balances[address(this)].add(_amount);
531 		balances[_of] = balances[_of].sub(_amount);
532 
533 		locked[_of][_reason] = lockToken(_amount, validUntil, false);
534 
535 		emit Transfer(_of, address(this), _amount);
536 		emit Locked(_of, _reason, _amount, validUntil);
537 		
538 		return true;
539     	}
540 
541     	function transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time) public returns (bool) {
542         	uint256 validUntil 					= now.add(_time); 
543 
544         	require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);
545         	require(_amount != 0, AMOUNT_ZERO);
546 
547         	if (locked[_to][_reason].amount == 0)
548             		lockReason[_to].push(_reason);
549 
550         	transfer(address(this), _amount);
551 
552         	locked[_to][_reason] 					= lockToken(_amount, validUntil, false);
553 
554         	emit Locked(_to, _reason, _amount, validUntil);
555         
556 		return true;
557     	}
558 
559     	function tokensLocked(address _of, bytes32 _reason) public view returns (uint256 amount) {	
560         	if (!locked[_of][_reason].claimed)
561             		amount 						= locked[_of][_reason].amount;
562     	}
563 
564     	function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time) public view returns (uint256 amount) {
565         	if (locked[_of][_reason].validity > _time)
566             		amount 						= locked[_of][_reason].amount;
567     	}
568 
569     	function totalBalanceOf(address _of) public view returns (uint256 amount) {
570         	amount 							= balanceOf(_of);
571 
572         	for (uint256 i = 0; i < lockReason[_of].length; i++) {
573             		amount 						= amount.add(tokensLocked(_of, lockReason[_of][i]));
574         	}
575     	}
576 
577     	function extendLock(bytes32 _reason, uint256 _time) public returns (bool) {
578         	require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
579 
580         	locked[msg.sender][_reason].validity 			= locked[msg.sender][_reason].validity.add(_time);
581 
582         	emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
583         
584 		return true;
585     	}	
586 
587     	function increaseLockAmount(bytes32 _reason, uint256 _amount) public returns (bool) {
588         	require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
589         	
590 		transfer(address(this), _amount);
591 
592         	locked[msg.sender][_reason].amount 			= locked[msg.sender][_reason].amount.add(_amount);
593 
594         	emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
595         
596 		return true;
597    	}
598 
599     	function tokensUnlockable(address _of, bytes32 _reason) public view returns (uint256 amount) {
600         	if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) 
601             		amount 						= locked[_of][_reason].amount;
602     	}
603 
604     	function unlock(address _of) public returns (uint256 unlockableTokens) {
605         	uint256 lockedTokens;
606 
607         	for (uint256 i = 0; i < lockReason[_of].length; i++) {
608             		lockedTokens 					= tokensUnlockable(_of, lockReason[_of][i]);
609             
610 	    		if (lockedTokens > 0) {
611                 		unlockableTokens 			= unlockableTokens.add(lockedTokens);
612                 		locked[_of][lockReason[_of][i]].claimed = true;
613 
614                 		emit Unlocked(_of, lockReason[_of][i], lockedTokens);
615             		}
616         	}
617 
618         	if (unlockableTokens > 0)
619             		this.transfer(_of, unlockableTokens);
620     	}
621 
622     	function getUnlockableTokens(address _of) public view returns (uint256 unlockableTokens) {
623         	for (uint256 i = 0; i < lockReason[_of].length; i++) {
624             		unlockableTokens 				= unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));
625         	}
626     	}
627 }