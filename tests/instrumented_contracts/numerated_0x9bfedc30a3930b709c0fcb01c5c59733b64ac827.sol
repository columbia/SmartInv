1 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 // pragma solidity ^0.4.24;
4 pragma solidity ^0.5.0;
5 
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * See https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   function totalSupply() public view returns (uint256);
14   function balanceOf(address _who) public view returns (uint256);
15   function transfer(address _to, uint256 _value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 // File: zeppelin-solidity/contracts/math/SafeMath.sol
20 
21 // pragma solidity ^0.4.24;
22 pragma solidity ^0.5.0;
23 
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30 
31   /**
32   * @dev Multiplies two numbers, throws on overflow.
33   */
34   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
35     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
36     // benefit is lost if 'b' is also tested.
37     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38     if (_a == 0) {
39       return 0;
40     }
41 
42     c = _a * _b;
43     assert(c / _a == _b);
44     return c;
45   }
46 
47   /**
48   * @dev Integer division of two numbers, truncating the quotient.
49   */
50   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     // assert(_b > 0); // Solidity automatically throws when dividing by 0
52     // uint256 c = _a / _b;
53     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
54     return _a / _b;
55   }
56 
57   /**
58   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59   */
60   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
61     assert(_b <= _a);
62     return _a - _b;
63   }
64 
65   /**
66   * @dev Adds two numbers, throws on overflow.
67   */
68   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
69     c = _a + _b;
70     assert(c >= _a);
71     return c;
72   }
73 }
74 
75 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
76 
77 // pragma solidity >=0.4.24;
78 pragma solidity ^0.5.0;
79 
80 
81 
82 
83 /**
84  * @title Basic token
85  * @dev Basic version of StandardToken, with no allowances.
86  */
87 contract BasicToken is ERC20Basic {
88   using SafeMath for uint256;
89 
90   mapping(address => uint256) internal balances;
91 
92   uint256 internal totalSupply_;
93 
94   /**
95   * @dev Total number of tokens in existence
96   */
97   function totalSupply() public view returns (uint256) {
98     return totalSupply_;
99   }
100 
101   /**
102   * @dev Transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106   function transfer(address _to, uint256 _value) public returns (bool) {
107     require(_value <= balances[msg.sender]);
108     require(_to != address(0));
109 
110     balances[msg.sender] = balances[msg.sender].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     emit Transfer(msg.sender, _to, _value);
113     return true;
114   }
115 
116   /**
117   * @dev Gets the balance of the specified address.
118   * @param _owner The address to query the the balance of.
119   * @return An uint256 representing the amount owned by the passed address.
120   */
121   function balanceOf(address _owner) public view returns (uint256) {
122     return balances[_owner];
123   }
124 
125 }
126 
127 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
128 
129 // pragma solidity ^0.4.24;
130 pragma solidity ^0.5.0;
131 
132 
133 
134 /**
135  * @title ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/20
137  */
138 contract ERC20 is ERC20Basic {
139   function allowance(address _owner, address _spender)
140     public view returns (uint256);
141 
142   function transferFrom(address _from, address _to, uint256 _value)
143     public returns (bool);
144 
145   function approve(address _spender, uint256 _value) public returns (bool);
146   event Approval(
147     address indexed owner,
148     address indexed spender,
149     uint256 value
150   );
151 }
152 
153 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
154 
155 // pragma solidity >=0.4.24;
156 
157 pragma solidity ^0.5.0;
158 
159 
160 
161 
162 /**
163  * @title Standard ERC20 token
164  *
165  * @dev Implementation of the basic standard token.
166  * https://github.com/ethereum/EIPs/issues/20
167  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
168  */
169 contract StandardToken is ERC20, BasicToken {
170 
171   mapping (address => mapping (address => uint256)) internal allowed;
172 
173 
174   /**
175    * @dev Transfer tokens from one address to another
176    * @param _from address The address which you want to send tokens from
177    * @param _to address The address which you want to transfer to
178    * @param _value uint256 the amount of tokens to be transferred
179    */
180   function transferFrom(
181     address _from,
182     address _to,
183     uint256 _value
184   )
185     public
186     returns (bool)
187   {
188     require(_value <= balances[_from]);
189     require(_value <= allowed[_from][msg.sender]);
190     require(_to != address(0));
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     emit Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param _spender The address which will spend the funds.
206    * @param _value The amount of tokens to be spent.
207    */
208   function approve(address _spender, uint256 _value) public returns (bool) {
209     allowed[msg.sender][_spender] = _value;
210     emit Approval(msg.sender, _spender, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param _owner address The address which owns the funds.
217    * @param _spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(
221     address _owner,
222     address _spender
223    )
224     public
225     view
226     returns (uint256)
227   {
228     return allowed[_owner][_spender];
229   }
230 
231   /**
232    * @dev Increase the amount of tokens that an owner allowed to a spender.
233    * approve should be called when allowed[_spender] == 0. To increment
234    * allowed value is better to use this function to avoid 2 calls (and wait until
235    * the first transaction is mined)
236    * From MonolithDAO Token.sol
237    * @param _spender The address which will spend the funds.
238    * @param _addedValue The amount of tokens to increase the allowance by.
239    */
240   function increaseApproval(
241     address _spender,
242     uint256 _addedValue
243   )
244     public
245     returns (bool)
246   {
247     allowed[msg.sender][_spender] = (
248       allowed[msg.sender][_spender].add(_addedValue));
249     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253   /**
254    * @dev Decrease the amount of tokens that an owner allowed to a spender.
255    * approve should be called when allowed[_spender] == 0. To decrement
256    * allowed value is better to use this function to avoid 2 calls (and wait until
257    * the first transaction is mined)
258    * From MonolithDAO Token.sol
259    * @param _spender The address which will spend the funds.
260    * @param _subtractedValue The amount of tokens to decrease the allowance by.
261    */
262   function decreaseApproval(
263     address _spender,
264     uint256 _subtractedValue
265   )
266     public
267     returns (bool)
268   {
269     uint256 oldValue = allowed[msg.sender][_spender];
270     if (_subtractedValue >= oldValue) {
271       allowed[msg.sender][_spender] = 0;
272     } else {
273       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
274     }
275     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276     return true;
277   }
278 
279 }
280 
281 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
282 
283 // pragma solidity >=0.4.24;
284 pragma solidity ^0.5.0;
285 
286 /**
287  * @title Ownable
288  * @dev The Ownable contract has an owner address, and provides basic authorization control
289  * functions, this simplifies the implementation of "user permissions".
290  */
291 contract Ownable {
292   address public owner;
293 
294 
295   event OwnershipRenounced(address indexed previousOwner);
296   event OwnershipTransferred(
297     address indexed previousOwner,
298     address indexed newOwner
299   );
300 
301 
302   /**
303    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
304    * account.
305    */
306   constructor() public {
307     owner = msg.sender;
308   }
309 
310   /**
311    * @dev Throws if called by any account other than the owner.
312    */
313   modifier onlyOwner() {
314     require(msg.sender == owner);
315     _;
316   }
317 
318   /**
319    * @dev Allows the current owner to relinquish control of the contract.
320    * @notice Renouncing to ownership will leave the contract without an owner.
321    * It will not be possible to call the functions with the `onlyOwner`
322    * modifier anymore.
323    */
324   function renounceOwnership() public onlyOwner {
325     emit OwnershipRenounced(owner);
326     owner = address(0);
327   }
328 
329   /**
330    * @dev Allows the current owner to transfer control of the contract to a newOwner.
331    * @param _newOwner The address to transfer ownership to.
332    */
333   function transferOwnership(address _newOwner) public onlyOwner {
334     _transferOwnership(_newOwner);
335   }
336 
337   /**
338    * @dev Transfers control of the contract to a newOwner.
339    * @param _newOwner The address to transfer ownership to.
340    */
341   function _transferOwnership(address _newOwner) internal {
342     require(_newOwner != address(0));
343     emit OwnershipTransferred(owner, _newOwner);
344     owner = _newOwner;
345   }
346 }
347 
348 // File: contracts/ERC1132.sol
349 
350 pragma solidity ^0.5.0;
351 // pragma solidity >=0.4.24;
352 /**
353  * @title ERC1132 interface
354  * @dev see https://github.com/ethereum/EIPs/issues/1132
355  */
356 
357 contract ERC1132 {
358     /**
359      * @dev Reasons why a user's tokens have been locked
360      */
361     mapping(address => bytes32[]) public lockReason;
362 
363     /**
364      * @dev locked token structure
365      */
366     struct lockToken {
367         uint256 amount;
368         uint256 validity;
369         bool claimed;
370     }
371 
372     /**
373      * @dev Holds number & validity of tokens locked for a given reason for
374      *      a specified address
375      */
376     mapping(address => mapping(bytes32 => lockToken)) public locked;
377 
378     /**
379      * @dev Records data of all the tokens Locked
380      */
381     event Locked(
382         address indexed _of,
383         bytes32 indexed _reason,
384         uint256 _amount,
385         uint256 _validity
386     );
387 
388     /**
389      * @dev Records data of all the tokens unlocked
390      */
391     event Unlocked(
392         address indexed _of,
393         bytes32 indexed _reason,
394         uint256 _amount
395     );
396     
397     /**
398      * @dev Locks a specified amount of tokens against an address,
399      *      for a specified reason and time
400      * @param _reason The reason to lock tokens
401      * @param _amount Number of tokens to be locked
402      * @param _time Lock time in seconds
403      */
404     function lock(bytes32 _reason, uint256 _amount, uint256 _time, address _of)
405         public returns (bool);
406   
407     /**
408      * @dev Returns tokens locked for a specified address for a
409      *      specified reason
410      *
411      * @param _of The address whose tokens are locked
412      * @param _reason The reason to query the lock tokens for
413      */
414     function tokensLocked(address _of, bytes32 _reason)
415         public view returns (uint256 amount);
416     
417     /**
418      * @dev Returns tokens locked for a specified address for a
419      *      specified reason at a specific time
420      *
421      * @param _of The address whose tokens are locked
422      * @param _reason The reason to query the lock tokens for
423      * @param _time The timestamp to query the lock tokens for
424      */
425     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
426         public view returns (uint256 amount);
427     
428     /**
429      * @dev Returns total tokens held by an address (locked + transferable)
430      * @param _of The address to query the total balance of
431      */
432     function totalBalanceOf(address _of)
433         public view returns (uint256 amount);
434     
435     /**
436      * @dev Extends lock for a specified reason and time
437      * @param _reason The reason to lock tokens
438      * @param _time Lock extension time in seconds
439      */
440     function extendLock(bytes32 _reason, uint256 _time)
441         public returns (bool);
442     
443     /**
444      * @dev Increase number of tokens locked for a specified reason
445      * @param _reason The reason to lock tokens
446      * @param _amount Number of tokens to be increased
447      */
448     function increaseLockAmount(bytes32 _reason, uint256 _amount)
449         public returns (bool);
450 
451     /**
452      * @dev Returns unlockable tokens for a specified address for a specified reason
453      * @param _of The address to query the the unlockable token count of
454      * @param _reason The reason to query the unlockable tokens for
455      */
456     function tokensUnlockable(address _of, bytes32 _reason)
457         public view returns (uint256 amount);
458  
459     /**
460      * @dev Unlocks the unlockable tokens of a specified address
461      * @param _of Address of user, claiming back unlockable tokens
462      */
463     function unlock(address _of)
464         public returns (uint256 unlockableTokens);
465 
466     /**
467      * @dev Gets the unlockable tokens of a specified address
468      * @param _of The address to query the the unlockable token count of
469      */
470     function getUnlockableTokens(address _of)
471         public view returns (uint256 unlockableTokens);
472 
473 }
474 
475 // File: contracts/FACITE.sol
476 
477 pragma solidity ^0.5.0;
478 // pragma solidity >= 0.4.24;
479 
480 
481 
482 
483 contract FACITE is StandardToken, Ownable, ERC1132 {
484     string public constant name = "FACITE";
485     string public constant symbol = "FIT";
486     uint256 public constant decimals = 18;
487     uint256 public constant INITIAL_SUPPLY = 5000000000 * (10 ** decimals);
488     
489 	constructor() public {
490         totalSupply_ = INITIAL_SUPPLY;
491 		balances[msg.sender] = INITIAL_SUPPLY;
492 	}
493 
494     event Mint(address minter, uint256 value);
495 	event Burn(address burner, uint256 value);
496 
497     string internal constant INVALID_TOKEN_VALUES = 'Invalid token values';
498 	string internal constant NOT_ENOUGH_TOKENS = 'Not enough tokens';
499     string internal constant ALREADY_LOCKED = 'Tokens already locked';
500 	string internal constant NOT_LOCKED = 'No tokens locked';
501 	string internal constant AMOUNT_ZERO = 'Amount can not be 0';
502 
503     // locks
504     function lock(bytes32 _reason, uint256 _amount, uint256 _time, address _of) public onlyOwner returns (bool) {
505         uint256 validUntil = now.add(_time); //solhint-disable-line
506 
507         // If tokens are already locked, then functions extendLock or
508         // increaseLockAmount should be used to make any changes
509         require(_amount <= balances[_of], NOT_ENOUGH_TOKENS); // 추가
510         require(tokensLocked(_of, _reason) == 0, ALREADY_LOCKED);
511         require(_amount != 0, AMOUNT_ZERO);
512 
513         if (locked[_of][_reason].amount == 0)
514             lockReason[_of].push(_reason);
515 
516         // transfer(address(this), _amount); // 수정
517         balances[address(this)] = balances[address(this)].add(_amount);
518         balances[_of] = balances[_of].sub(_amount);
519 
520         locked[_of][_reason] = lockToken(_amount, validUntil, false);
521 
522         // 수정
523         emit Transfer(_of, address(this), _amount);
524         emit Locked(_of, _reason, _amount, validUntil);
525         return true;
526     }
527 
528     function transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time)
529         public onlyOwner
530         returns (bool)
531     {
532         uint256 validUntil = now.add(_time); //solhint-disable-line
533 
534         require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);
535         require(_amount != 0, AMOUNT_ZERO);
536 
537         if (locked[_to][_reason].amount == 0)
538             lockReason[_to].push(_reason);
539 
540         transfer(address(this), _amount);
541 
542         locked[_to][_reason] = lockToken(_amount, validUntil, false);
543         
544         emit Locked(_to, _reason, _amount, validUntil);
545         return true;
546     }
547 
548     function tokensLocked(address _of, bytes32 _reason)
549         public
550         view
551         returns (uint256 amount)
552     {
553         if (!locked[_of][_reason].claimed)
554             amount = locked[_of][_reason].amount;
555     }
556     
557     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
558         public
559         view
560         returns (uint256 amount)
561     {
562         if (locked[_of][_reason].validity > _time)
563             amount = locked[_of][_reason].amount;
564     }
565 
566     function totalBalanceOf(address _of)
567         public
568         view
569         returns (uint256 amount)
570     {
571         amount = balanceOf(_of);
572 
573         for (uint256 i = 0; i < lockReason[_of].length; i++) {
574             amount = amount.add(tokensLocked(_of, lockReason[_of][i]));
575         }   
576     }    
577 
578     function extendLock(bytes32 _reason, uint256 _time)
579         public onlyOwner
580         returns (bool)
581     {
582         require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
583 
584         locked[msg.sender][_reason].validity = locked[msg.sender][_reason].validity.add(_time);
585 
586         emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
587         return true;
588     }
589 
590     function increaseLockAmount(bytes32 _reason, uint256 _amount)
591         public onlyOwner
592         returns (bool)
593     {
594         require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
595         transfer(address(this), _amount);
596 
597         locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);
598 
599         emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
600         return true;
601     }
602 
603 
604     function tokensUnlockable(address _of, bytes32 _reason)
605         public
606         view
607         returns (uint256 amount)
608     {
609         if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) //solhint-disable-line
610             amount = locked[_of][_reason].amount;
611     }
612 
613      function unlock(address _of)
614         public onlyOwner
615         returns (uint256 unlockableTokens)
616     {
617         uint256 lockedTokens;
618 
619         for (uint256 i = 0; i < lockReason[_of].length; i++) {
620             lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);
621             if (lockedTokens > 0) {
622                 unlockableTokens = unlockableTokens.add(lockedTokens);
623                 locked[_of][lockReason[_of][i]].claimed = true;
624                 emit Unlocked(_of, lockReason[_of][i], lockedTokens);
625             }
626         }  
627 
628         if (unlockableTokens > 0)
629             this.transfer(_of, unlockableTokens);
630     }
631 
632     function getUnlockableTokens(address _of)
633         public
634         view
635         returns (uint256 unlockableTokens)
636     {
637         for (uint256 i = 0; i < lockReason[_of].length; i++) {
638             unlockableTokens = unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));
639         }  
640     }
641 }