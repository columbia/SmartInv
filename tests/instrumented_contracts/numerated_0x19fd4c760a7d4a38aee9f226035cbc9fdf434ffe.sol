1 // File: ..\openzeppelin-contracts-1.12.0\contracts\token\ERC20\ERC20Basic.sol
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
18 // File: ..\openzeppelin-contracts-1.12.0\contracts\math\SafeMath.sol
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
73 // File: ..\openzeppelin-contracts-1.12.0\contracts\token\ERC20\BasicToken.sol
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
124 // File: ..\openzeppelin-contracts-1.12.0\contracts\token\ERC20\ERC20.sol
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
149 // File: openzeppelin-contracts-1.12.0\contracts\token\ERC20\StandardToken.sol
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
275 // File: openzeppelin-contracts-1.12.0\contracts\ownership\Ownable.sol
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
342 // File: contracts\ERC1132.sol
343 
344 pragma solidity ^0.4.24;
345 
346 /**
347  * @title ERC1132 interface
348  * @dev see https://github.com/ethereum/EIPs/issues/1132
349  */
350 
351 contract ERC1132 {
352     /**
353      * @dev Reasons why a user's tokens have been locked
354      */
355     mapping(address => bytes32[]) public lockReason;
356 
357     /**
358      * @dev locked token structure
359      */
360     struct lockToken {
361         uint256 amount;
362         uint256 validity;
363         bool claimed;
364     }
365 
366     /**
367      * @dev Holds number & validity of tokens locked for a given reason for
368      *      a specified address
369      */
370     mapping(address => mapping(bytes32 => lockToken)) public locked;
371 
372     /**
373      * @dev Records data of all the tokens Locked
374      */
375     event Locked(
376         address indexed _of,
377         bytes32 indexed _reason,
378         uint256 _amount,
379         uint256 _validity
380     );
381 
382     /**
383      * @dev Records data of all the tokens unlocked
384      */
385     event Unlocked(
386         address indexed _of,
387         bytes32 indexed _reason,
388         uint256 _amount
389     );
390     
391 	/**
392 	 * @dev Locks a specified amount of tokens against an address,
393 	 *      for a specified reason and time
394 	 * @param _reason The reason to lock tokens
395 	 * @param _amount Number of tokens to be locked
396 	 * @param _time Lock time in seconds
397 	 * @param _of address to be locked // 추가
398 	 */
399 	function lock(bytes32 _reason, uint256 _amount, uint256 _time, address _of)
400         public returns (bool);
401   
402     /**
403      * @dev Returns tokens locked for a specified address for a
404      *      specified reason
405      *
406      * @param _of The address whose tokens are locked
407      * @param _reason The reason to query the lock tokens for
408      */
409     function tokensLocked(address _of, bytes32 _reason)
410         public view returns (uint256 amount);
411     
412     /**
413      * @dev Returns tokens locked for a specified address for a
414      *      specified reason at a specific time
415      *
416      * @param _of The address whose tokens are locked
417      * @param _reason The reason to query the lock tokens for
418      * @param _time The timestamp to query the lock tokens for
419      */
420     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
421         public view returns (uint256 amount);
422     
423     /**
424      * @dev Returns total tokens held by an address (locked + transferable)
425      * @param _of The address to query the total balance of
426      */
427     function totalBalanceOf(address _of)
428         public view returns (uint256 amount);
429     
430     /**
431      * @dev Extends lock for a specified reason and time
432      * @param _reason The reason to lock tokens
433      * @param _time Lock extension time in seconds
434      */
435     function extendLock(bytes32 _reason, uint256 _time)
436         public returns (bool);
437     
438     /**
439      * @dev Increase number of tokens locked for a specified reason
440      * @param _reason The reason to lock tokens
441      * @param _amount Number of tokens to be increased
442      */
443     function increaseLockAmount(bytes32 _reason, uint256 _amount)
444         public returns (bool);
445 
446     /**
447      * @dev Returns unlockable tokens for a specified address for a specified reason
448      * @param _of The address to query the the unlockable token count of
449      * @param _reason The reason to query the unlockable tokens for
450      */
451     function tokensUnlockable(address _of, bytes32 _reason)
452         public view returns (uint256 amount);
453  
454     /**
455      * @dev Unlocks the unlockable tokens of a specified address
456      * @param _of Address of user, claiming back unlockable tokens
457      */
458     function unlock(address _of)
459         public returns (uint256 unlockableTokens);
460 
461     /**
462      * @dev Gets the unlockable tokens of a specified address
463      * @param _of The address to query the the unlockable token count of
464      */
465     function getUnlockableTokens(address _of)
466         public view returns (uint256 unlockableTokens);
467 
468 }
469 
470 // File: contracts\CVPToken.sol
471 
472 pragma solidity 0.4.24;
473 
474 
475 
476 
477 contract CVPToken is StandardToken, Ownable, ERC1132 {
478 	// Define constants
479 	string public constant name = "CVP Token";
480 	string public constant symbol = "CVP";
481 	uint256 public constant decimals = 18;
482 	uint256 public constant INITIAL_SUPPLY = 20000000000 * (10 ** decimals);
483 
484 	event Mint(address minter, uint256 value);
485 	event Burn(address burner, uint256 value);
486 
487 	/**
488 	 * @dev Error messages for require statements
489 	 */
490 	string internal constant INVALID_TOKEN_VALUES = 'Invalid token values';
491 	string internal constant NOT_ENOUGH_TOKENS = 'Not enough tokens';
492 	string internal constant ALREADY_LOCKED = 'Tokens already locked';
493 	string internal constant NOT_LOCKED = 'No tokens locked';
494 	string internal constant AMOUNT_ZERO = 'Amount can not be 0';
495 
496 	constructor() public {
497         totalSupply_ = INITIAL_SUPPLY;
498 		balances[msg.sender] = INITIAL_SUPPLY;		
499 	}
500 	
501     /**
502 	 * @dev Locks a specified amount of tokens against an address,
503 	 *      for a specified reason and time
504 	 * @param _reason The reason to lock tokens
505 	 * @param _amount Number of tokens to be locked
506 	 * @param _time Lock time in seconds
507 	 * @param _of address to be locked // 추가
508 	 */
509 	function lock(bytes32 _reason, uint256 _amount, uint256 _time, address _of) public onlyOwner returns (bool) {
510 		uint256 validUntil = now.add(_time); //solhint-disable-line
511 
512 		// If tokens are already locked, then functions extendLock or
513 		// increaseLockAmount should be used to make any changes
514 		require(_amount <= balances[_of], NOT_ENOUGH_TOKENS); // 추가
515 		require(tokensLocked(_of, _reason) == 0, ALREADY_LOCKED);
516 		require(_amount != 0, AMOUNT_ZERO);
517 
518 		if (locked[_of][_reason].amount == 0)
519 			lockReason[_of].push(_reason);
520 
521 		// transfer(address(this), _amount); // 수정
522 		balances[address(this)] = balances[address(this)].add(_amount);
523 		balances[_of] = balances[_of].sub(_amount);
524 
525 		locked[_of][_reason] = lockToken(_amount, validUntil, false);
526 
527 		// 수정
528 		emit Transfer(_of, address(this), _amount);
529 		emit Locked(_of, _reason, _amount, validUntil);
530 		return true;
531 	}
532     
533     /**
534      * @dev Transfers and Locks a specified amount of tokens,
535      *      for a specified reason and time
536      * @param _to adress to which tokens are to be transfered
537      * @param _reason The reason to lock tokens
538      * @param _amount Number of tokens to be transfered and locked
539      * @param _time Lock time in seconds
540      */
541     function transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time)
542         public
543         returns (bool)
544     {
545         uint256 validUntil = now.add(_time); //solhint-disable-line
546 
547         require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);
548         require(_amount != 0, AMOUNT_ZERO);
549 
550         if (locked[_to][_reason].amount == 0)
551             lockReason[_to].push(_reason);
552 
553         transfer(address(this), _amount);
554 
555         locked[_to][_reason] = lockToken(_amount, validUntil, false);
556         
557         emit Locked(_to, _reason, _amount, validUntil);
558         return true;
559     }
560 
561     /**
562      * @dev Returns tokens locked for a specified address for a
563      *      specified reason
564      *
565      * @param _of The address whose tokens are locked
566      * @param _reason The reason to query the lock tokens for
567      */
568     function tokensLocked(address _of, bytes32 _reason)
569         public
570         view
571         returns (uint256 amount)
572     {
573         if (!locked[_of][_reason].claimed)
574             amount = locked[_of][_reason].amount;
575     }
576     
577     /**
578      * @dev Returns tokens locked for a specified address for a
579      *      specified reason at a specific time
580      *
581      * @param _of The address whose tokens are locked
582      * @param _reason The reason to query the lock tokens for
583      * @param _time The timestamp to query the lock tokens for
584      */
585     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
586         public
587         view
588         returns (uint256 amount)
589     {
590         if (locked[_of][_reason].validity > _time)
591             amount = locked[_of][_reason].amount;
592     }
593 
594     /**
595      * @dev Returns total tokens held by an address (locked + transferable)
596      * @param _of The address to query the total balance of
597      */
598     function totalBalanceOf(address _of)
599         public
600         view
601         returns (uint256 amount)
602     {
603         amount = balances[_of];
604 
605         for (uint256 i = 0; i < lockReason[_of].length; i++) {
606             amount = amount.add(tokensLocked(_of, lockReason[_of][i]));
607         }   
608     }    
609     
610     /**
611      * @dev Extends lock for a specified reason and time
612      * @param _reason The reason to lock tokens
613      * @param _time Lock extension time in seconds
614      */
615     function extendLock(bytes32 _reason, uint256 _time)
616         public
617         returns (bool)
618     {
619         require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
620 
621         locked[msg.sender][_reason].validity = locked[msg.sender][_reason].validity.add(_time);
622 
623         emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
624         return true;
625     }
626     
627     /**
628      * @dev Increase number of tokens locked for a specified reason
629      * @param _reason The reason to lock tokens
630      * @param _amount Number of tokens to be increased
631      */
632     function increaseLockAmount(bytes32 _reason, uint256 _amount)
633         public
634         returns (bool)
635     {
636         require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
637         transfer(address(this), _amount);
638 
639         locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);
640 
641         emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
642         return true;
643     }
644 
645     /**
646      * @dev Returns unlockable tokens for a specified address for a specified reason
647      * @param _of The address to query the the unlockable token count of
648      * @param _reason The reason to query the unlockable tokens for
649      */
650     function tokensUnlockable(address _of, bytes32 _reason)
651         public
652         view
653         returns (uint256 amount)
654     {
655         if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) //solhint-disable-line
656             amount = locked[_of][_reason].amount;
657     }
658 
659     /**
660      * @dev Unlocks the unlockable tokens of a specified address
661      * @param _of Address of user, claiming back unlockable tokens
662      */
663     function unlock(address _of)
664         public
665         returns (uint256 unlockableTokens)
666     {
667         uint256 lockedTokens;
668 
669         for (uint256 i = 0; i < lockReason[_of].length; i++) {
670             lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);
671             if (lockedTokens > 0) {
672                 unlockableTokens = unlockableTokens.add(lockedTokens);
673                 locked[_of][lockReason[_of][i]].claimed = true;
674                 emit Unlocked(_of, lockReason[_of][i], lockedTokens);
675             }
676         }  
677 
678         if (unlockableTokens > 0)
679             this.transfer(_of, unlockableTokens);
680     }
681 
682     /**
683      * @dev Gets the unlockable tokens of a specified address
684      * @param _of The address to query the the unlockable token count of
685      */
686     function getUnlockableTokens(address _of)
687         public
688         view
689         returns (uint256 unlockableTokens)
690     {
691         for (uint256 i = 0; i < lockReason[_of].length; i++) {
692             unlockableTokens = unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));
693         }  
694     }
695 }