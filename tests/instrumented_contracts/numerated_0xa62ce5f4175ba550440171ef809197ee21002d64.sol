1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 {
70   function totalSupply() public view returns (uint256);
71 
72   function balanceOf(address _who) public view returns (uint256);
73 
74   function allowance(address _owner, address _spender)
75     public view returns (uint256);
76 
77   function transfer(address _to, uint256 _value) public returns (bool);
78 
79   function approve(address _spender, uint256 _value)
80     public returns (bool);
81 
82   function transferFrom(address _from, address _to, uint256 _value)
83     public returns (bool);
84 
85   event Transfer(
86     address indexed from,
87     address indexed to,
88     uint256 value
89   );
90 
91   event Approval(
92     address indexed owner,
93     address indexed spender,
94     uint256 value
95   );
96 }
97 
98 
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * https://github.com/ethereum/EIPs/issues/20
104  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
105  */
106 contract StandardToken is ERC20 {
107   using SafeMath for uint256;
108 
109   mapping(address => uint256) balances;
110 
111   mapping (address => mapping (address => uint256)) internal allowed;
112 
113   uint256 totalSupply_;
114 
115   /**
116   * @dev Total number of tokens in existence
117   */
118   function totalSupply() public view returns (uint256) {
119     return totalSupply_;
120   }
121 
122   /**
123   * @dev Gets the balance of the specified address.
124   * @param _owner The address to query the the balance of.
125   * @return An uint256 representing the amount owned by the passed address.
126   */
127   function balanceOf(address _owner) public view returns (uint256) {
128     return balances[_owner];
129   }
130 
131   /**
132    * @dev Function to check the amount of tokens that an owner allowed to a spender.
133    * @param _owner address The address which owns the funds.
134    * @param _spender address The address which will spend the funds.
135    * @return A uint256 specifying the amount of tokens still available for the spender.
136    */
137   function allowance(
138     address _owner,
139     address _spender
140    )
141     public
142     view
143     returns (uint256)
144   {
145     return allowed[_owner][_spender];
146   }
147 
148   /**
149   * @dev Transfer token for a specified address
150   * @param _to The address to transfer to.
151   * @param _value The amount to be transferred.
152   */
153   function transfer(address _to, uint256 _value) public returns (bool) {
154     require(_value <= balances[msg.sender]);
155     require(_to != address(0));
156 
157     balances[msg.sender] = balances[msg.sender].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     emit Transfer(msg.sender, _to, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165    * Beware that changing an allowance with this method brings the risk that someone may use both the old
166    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    * @param _spender The address which will spend the funds.
170    * @param _value The amount of tokens to be spent.
171    */
172   function approve(address _spender, uint256 _value) public returns (bool) {
173     allowed[msg.sender][_spender] = _value;
174     emit Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param _from address The address which you want to send tokens from
181    * @param _to address The address which you want to transfer to
182    * @param _value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(
185     address _from,
186     address _to,
187     uint256 _value
188   )
189     public
190     returns (bool)
191   {
192     require(_value <= balances[_from]);
193     require(_value <= allowed[_from][msg.sender]);
194     require(_to != address(0));
195 
196     balances[_from] = balances[_from].sub(_value);
197     balances[_to] = balances[_to].add(_value);
198     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
199     emit Transfer(_from, _to, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Increase the amount of tokens that an owner allowed to a spender.
205    * approve should be called when allowed[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param _spender The address which will spend the funds.
210    * @param _addedValue The amount of tokens to increase the allowance by.
211    */
212   function increaseApproval(
213     address _spender,
214     uint256 _addedValue
215   )
216     public
217     returns (bool)
218   {
219     allowed[msg.sender][_spender] = (
220       allowed[msg.sender][_spender].add(_addedValue));
221     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225   /**
226    * @dev Decrease the amount of tokens that an owner allowed to a spender.
227    * approve should be called when allowed[_spender] == 0. To decrement
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _subtractedValue The amount of tokens to decrease the allowance by.
233    */
234   function decreaseApproval(
235     address _spender,
236     uint256 _subtractedValue
237   )
238     public
239     returns (bool)
240   {
241     uint256 oldValue = allowed[msg.sender][_spender];
242     if (_subtractedValue >= oldValue) {
243       allowed[msg.sender][_spender] = 0;
244     } else {
245       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246     }
247     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251 }
252 
253 
254 
255 /**
256  * @title Pausable
257  * @dev Base contract which allows children to implement an emergency stop mechanism.
258  */
259 contract Pausable is Ownable {
260   event Pause();
261   event Unpause();
262 
263   bool public paused = false;
264 
265 
266   /**
267    * @dev Modifier to make a function callable only when the contract is not paused.
268    */
269   modifier whenNotPaused() {
270     require(!paused);
271     _;
272   }
273 
274   /**
275    * @dev Modifier to make a function callable only when the contract is paused.
276    */
277   modifier whenPaused() {
278     require(paused);
279     _;
280   }
281 
282   /**
283    * @dev called by the owner to pause, triggers stopped state
284    */
285   function pause() public onlyOwner whenNotPaused {
286     paused = true;
287     emit Pause();
288   }
289 
290   /**
291    * @dev called by the owner to unpause, returns to normal state
292    */
293   function unpause() public onlyOwner whenPaused {
294     paused = false;
295     emit Unpause();
296   }
297 }
298 
299 
300 
301 /**
302  * @title Burnable Token
303  * @dev Token that can be irreversibly burned (destroyed).
304  */
305 contract BurnableToken is StandardToken {
306 
307   event Burn(address indexed burner, uint256 value);
308 
309   /**
310    * @dev Burns a specific amount of tokens.
311    * @param _value The amount of token to be burned.
312    */
313   function burn(uint256 _value) public {
314     _burn(msg.sender, _value);
315   }
316 
317   /**
318    * @dev Burns a specific amount of tokens from the target address and decrements allowance
319    * @param _from address The address which you want to send tokens from
320    * @param _value uint256 The amount of token to be burned
321    */
322   function burnFrom(address _from, uint256 _value) public {
323     require(_value <= allowed[_from][msg.sender]);
324     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
325     // this function needs to emit an event with the updated approval.
326     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
327     _burn(_from, _value);
328   }
329 
330   function _burn(address _who, uint256 _value) internal {
331     require(_value <= balances[_who]);
332     // no need to require value <= totalSupply, since that would imply the
333     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
334 
335     balances[_who] = balances[_who].sub(_value);
336     totalSupply_ = totalSupply_.sub(_value);
337     emit Burn(_who, _value);
338     emit Transfer(_who, address(0), _value);
339   }
340 }
341 
342 
343 /**
344  * @title Mintable token
345  * @dev Simple ERC20 Token example, with mintable token creation
346  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
347  */
348 contract MintableToken is StandardToken, Ownable {
349   event Mint(address indexed to, uint256 amount);
350   event MintFinished();
351 
352   bool public mintingFinished = false;
353 
354 
355   modifier canMint() {
356     require(!mintingFinished);
357     _;
358   }
359 
360   modifier hasMintPermission() {
361     require(msg.sender == owner);
362     _;
363   }
364 
365   /**
366    * @dev Function to mint tokens
367    * @param _to The address that will receive the minted tokens.
368    * @param _amount The amount of tokens to mint.
369    * @return A boolean that indicates if the operation was successful.
370    */
371   function mint(
372     address _to,
373     uint256 _amount
374   )
375     public
376     hasMintPermission
377     canMint
378     returns (bool)
379   {
380     totalSupply_ = totalSupply_.add(_amount);
381     balances[_to] = balances[_to].add(_amount);
382     emit Mint(_to, _amount);
383     emit Transfer(address(0), _to, _amount);
384     return true;
385   }
386 
387   /**
388    * @dev Function to stop minting new tokens.
389    * @return True if the operation was successful.
390    */
391   function finishMinting() public onlyOwner canMint returns (bool) {
392     mintingFinished = true;
393     emit MintFinished();
394     return true;
395   }
396 }
397 
398 
399 
400 /**
401  * @title SafeMath
402  * @dev Math operations with safety checks that throw on error
403  */
404 library SafeMath {
405 
406   /**
407   * @dev Multiplies two numbers, throws on overflow.
408   */
409   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
410     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
411     // benefit is lost if 'b' is also tested.
412     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
413     if (_a == 0) {
414       return 0;
415     }
416 
417     c = _a * _b;
418     assert(c / _a == _b);
419     return c;
420   }
421 
422   /**
423   * @dev Integer division of two numbers, truncating the quotient.
424   */
425   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
426     // assert(_b > 0); // Solidity automatically throws when dividing by 0
427     // uint256 c = _a / _b;
428     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
429     return _a / _b;
430   }
431 
432   /**
433   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
434   */
435   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
436     assert(_b <= _a);
437     return _a - _b;
438   }
439 
440   /**
441   * @dev Adds two numbers, throws on overflow.
442   */
443   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
444     c = _a + _b;
445     assert(c >= _a);
446     return c;
447   }
448 }
449 
450 /**
451  * @title Pausable token
452  * @dev StandardToken modified with pausable transfers.
453  **/
454 contract PausableToken is StandardToken, Pausable {
455 
456   function transfer(
457     address _to,
458     uint256 _value
459   )
460     public
461     whenNotPaused
462     returns (bool)
463   {
464     return super.transfer(_to, _value);
465   }
466 
467   function transferFrom(
468     address _from,
469     address _to,
470     uint256 _value
471   )
472     public
473     whenNotPaused
474     returns (bool)
475   {
476     return super.transferFrom(_from, _to, _value);
477   }
478 
479   function approve(
480     address _spender,
481     uint256 _value
482   )
483     public
484     whenNotPaused
485     returns (bool)
486   {
487     return super.approve(_spender, _value);
488   }
489 
490   function increaseApproval(
491     address _spender,
492     uint _addedValue
493   )
494     public
495     whenNotPaused
496     returns (bool success)
497   {
498     return super.increaseApproval(_spender, _addedValue);
499   }
500 
501   function decreaseApproval(
502     address _spender,
503     uint _subtractedValue
504   )
505     public
506     whenNotPaused
507     returns (bool success)
508   {
509     return super.decreaseApproval(_spender, _subtractedValue);
510   }
511 }
512 
513 /**
514  * @title ERC1132 interface
515  * @dev see https://github.com/ethereum/EIPs/issues/1132
516  */
517 
518 contract ERC1132 {
519     /**
520      * @dev Reasons why a user's tokens have been locked
521      */
522     mapping(address => bytes32[]) public lockReason;
523 
524     /**
525      * @dev locked token structure
526      */
527     struct lockToken {
528         uint256 amount;
529         uint256 validity;
530         bool claimed;
531     }
532 
533     /**
534      * @dev Holds number & validity of tokens locked for a given reason for
535      *      a specified address
536      */
537     mapping(address => mapping(bytes32 => lockToken)) public locked;
538 
539     /**
540      * @dev Records data of all the tokens Locked
541      */
542     event Lock(
543         address indexed _of,
544         bytes32 indexed _reason,
545         uint256 _amount,
546         uint256 _validity
547     );
548 
549     /**
550      * @dev Records data of all the tokens unlocked
551      */
552     event Unlock(
553         address indexed _of,
554         bytes32 indexed _reason,
555         uint256 _amount
556     );
557     
558     /**
559      * @dev Locks a specified amount of tokens against an address,
560      *      for a specified reason and time
561      * @param _reason The reason to lock tokens
562      * @param _amount Number of tokens to be locked
563      * @param _time Lock time in seconds
564      */
565     function lock(bytes32 _reason, uint256 _amount, uint256 _time)
566         public returns (bool);
567   
568     /**
569      * @dev Returns tokens locked for a specified address for a
570      *      specified reason
571      *
572      * @param _of The address whose tokens are locked
573      * @param _reason The reason to query the lock tokens for
574      */
575     function tokensLocked(address _of, bytes32 _reason)
576         public view returns (uint256 amount);
577     
578     /**
579      * @dev Returns tokens locked for a specified address for a
580      *      specified reason at a specific time
581      *
582      * @param _of The address whose tokens are locked
583      * @param _reason The reason to query the lock tokens for
584      * @param _time The timestamp to query the lock tokens for
585      */
586     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
587         public view returns (uint256 amount);
588     
589     /**
590      * @dev Returns total tokens held by an address (locked + transferable)
591      * @param _of The address to query the total balance of
592      */
593     function totalBalanceOf(address _of)
594         public view returns (uint256 amount);
595     
596     /**
597      * @dev Extends lock for a specified reason and time
598      * @param _reason The reason to lock tokens
599      * @param _time Lock extension time in seconds
600      */
601     function extendLock(bytes32 _reason, uint256 _time)
602         public returns (bool);
603     
604     /**
605      * @dev Increase number of tokens locked for a specified reason
606      * @param _reason The reason to lock tokens
607      * @param _amount Number of tokens to be increased
608      */
609     function increaseLockAmount(bytes32 _reason, uint256 _amount)
610         public returns (bool);
611 
612     /**
613      * @dev Returns unlockable tokens for a specified address for a specified reason
614      * @param _of The address to query the the unlockable token count of
615      * @param _reason The reason to query the unlockable tokens for
616      */
617     function tokensUnlockable(address _of, bytes32 _reason)
618         public view returns (uint256 amount);
619  
620     /**
621      * @dev Unlocks the unlockable tokens of a specified address
622      * @param _of Address of user, claiming back unlockable tokens
623      */
624     function unlock(address _of)
625         public returns (uint256 unlockableTokens);
626 
627     /**
628      * @dev Gets the unlockable tokens of a specified address
629      * @param _of The address to query the the unlockable token count of
630      */
631     function getUnlockableTokens(address _of)
632         public view returns (uint256 unlockableTokens);
633 
634 }
635 
636 
637 /**
638  * @title SCAVOToken
639  * @dev ERC20 Token, where all tokens are pre-assigned to the creator.
640  * Note they can later distribute these tokens as they wish using `transfer` and other
641  * `StandardToken` functions.
642  * Version: 1.3
643  */
644 contract SCAVOToken is ERC1132, StandardToken, MintableToken, PausableToken, BurnableToken {
645 
646 	string public constant name = "SCAVO Token";
647 	string public constant symbol = "SCAVO";
648 	string public constant version = "1.3";
649 	uint8 public constant decimals = 18;
650 
651 	uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
652 
653 	/**
654 	 * @dev Error messages for require statements
655 	 */
656 	string constant alreadyLocked = 'Tokens already locked';
657 	string constant notLocked = 'No tokens locked';
658 	string constant amountZero = 'Amount can not be 0';
659 	string constant transferFailed = 'Transfer Failed';
660   
661 	/**
662 	 * @dev Constructor that gives msg.sender all of existing tokens.
663 	 */
664 	constructor() public {
665 		totalSupply_ = INITIAL_SUPPLY;
666 		balances[msg.sender] = INITIAL_SUPPLY;
667 		emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
668 	}
669   
670     /**
671      * @dev Locks a specified amount of tokens against an address,
672      *      for a specified reason and time
673      * @param _reason The reason to lock tokens
674      * @param _amount Number of tokens to be locked
675      * @param _time Lock time in seconds
676      */
677     function lock(bytes32 _reason, uint256 _amount, uint256 _time)
678         public
679         returns (bool)
680     {
681         uint256 validUntil = block.timestamp.add(_time);
682 
683         // If tokens are already locked, then functions extendLock or
684         // increaseLockAmount should be used to make any changes
685         require(tokensLocked(msg.sender, _reason) == 0, alreadyLocked);
686         require(_amount != 0, amountZero);
687 
688         if (locked[msg.sender][_reason].amount == 0)
689             lockReason[msg.sender].push(_reason);
690 
691         transfer(address(this), _amount);
692 
693         locked[msg.sender][_reason] = lockToken(_amount, validUntil, false);
694 
695         emit Lock(msg.sender, _reason, _amount, validUntil);
696         return true;
697     }
698     
699     /**
700      * @dev Transfers and Locks a specified amount of tokens,
701      *      for a specified reason and time
702      * @param _to adress to which tokens are to be transfered
703      * @param _reason The reason to lock tokens
704      * @param _amount Number of tokens to be transfered and locked
705      * @param _time Lock time in seconds
706      */
707     function transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time)
708         public
709         returns (bool)
710     {
711         uint256 validUntil = block.timestamp.add(_time);
712 
713         require(tokensLocked(_to, _reason) == 0, alreadyLocked);
714         require(_amount != 0, amountZero);
715 
716         if (locked[_to][_reason].amount == 0)
717             lockReason[_to].push(_reason);
718 
719         transfer(address(this), _amount);
720 
721         locked[_to][_reason] = lockToken(_amount, validUntil, false);
722         
723         emit Lock(_to, _reason, _amount, validUntil);
724         return true;
725     }
726 
727     /**
728      * @dev Returns tokens locked for a specified address for a
729      *      specified reason
730      *
731      * @param _of The address whose tokens are locked
732      * @param _reason The reason to query the lock tokens for
733      */
734     function tokensLocked(address _of, bytes32 _reason)
735         public
736         view
737         returns (uint256 amount)
738     {
739         if (!locked[_of][_reason].claimed)
740             amount = locked[_of][_reason].amount;
741     }
742     
743     /**
744      * @dev Returns tokens locked for a specified address for a
745      *      specified reason at a specific time
746      *
747      * @param _of The address whose tokens are locked
748      * @param _reason The reason to query the lock tokens for
749      * @param _time The timestamp to query the lock tokens for
750      */
751     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
752         public
753         view
754         returns (uint256 amount)
755     {
756         if (locked[_of][_reason].validity > _time)
757             amount = locked[_of][_reason].amount;
758     }
759 
760     /**
761      * @dev Returns total tokens held by an address (locked + transferable)
762      * @param _of The address to query the total balance of
763      */
764     function totalBalanceOf(address _of)
765         public
766         view
767         returns (uint256 amount)
768     {
769     	amount = balanceOf(_of);
770 
771         for (uint256 i = 0; i < lockReason[_of].length; i++) {
772             amount = amount.add(tokensLocked(_of, lockReason[_of][i]));
773         }   
774     }    
775     
776     /**
777      * @dev Extends lock for a specified reason and time
778      * @param _reason The reason to lock tokens
779      * @param _time Lock extension time in seconds
780      */
781     function extendLock(bytes32 _reason, uint256 _time)
782         public
783         returns (bool)
784     {
785         require(tokensLocked(msg.sender, _reason) > 0, notLocked);
786 
787         locked[msg.sender][_reason].validity = locked[msg.sender][_reason].validity.add(_time);
788 
789         emit Lock(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
790         return true;
791     }
792     
793     /**
794      * @dev Increase number of tokens locked for a specified reason
795      * @param _reason The reason to lock tokens
796      * @param _amount Number of tokens to be increased
797      */
798     function increaseLockAmount(bytes32 _reason, uint256 _amount)
799         public
800         returns (bool)
801     {
802         require(tokensLocked(msg.sender, _reason) > 0, notLocked);
803         transfer(address(this), _amount);
804 
805         locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);
806 
807         emit Lock(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
808         return true;
809     }
810 
811     /**
812      * @dev Returns unlockable tokens for a specified address for a specified reason
813      * @param _of The address to query the the unlockable token count of
814      * @param _reason The reason to query the unlockable tokens for
815      */
816     function tokensUnlockable(address _of, bytes32 _reason)
817         public
818         view
819         returns (uint256 amount)
820     {
821         if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed)
822             amount = locked[_of][_reason].amount;
823     }
824 
825     /**
826      * @dev Unlocks the unlockable tokens of a specified address
827      * @param _of Address of user, claiming back unlockable tokens
828      */
829     function unlock(address _of)
830         public
831         returns (uint256 unlockableTokens)
832     {
833         uint256 lockedTokens;
834 
835         for (uint256 i = 0; i < lockReason[_of].length; i++) {
836             lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);
837             if (lockedTokens > 0) {
838                 unlockableTokens = unlockableTokens.add(lockedTokens);
839                 locked[_of][lockReason[_of][i]].claimed = true;
840                 emit Unlock(_of, lockReason[_of][i], lockedTokens);
841             }
842         }  
843 
844         if(unlockableTokens > 0)
845         	this.transfer(_of, unlockableTokens);
846     }
847 
848     /**
849      * @dev Gets the unlockable tokens of a specified address
850      * @param _of The address to query the the unlockable token count of
851      */
852     function getUnlockableTokens(address _of)
853         public
854         view
855         returns (uint256 unlockableTokens)
856     {
857         for (uint256 i = 0; i < lockReason[_of].length; i++) {
858             unlockableTokens = unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));
859         }  
860     }  
861 
862 }