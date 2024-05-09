1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract ERC20Basic {
46   function totalSupply() public view returns (uint256);
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender)
54     public view returns (uint256);
55 
56   function transferFrom(address from, address to, uint256 value)
57     public returns (bool);
58 
59   function approve(address spender, uint256 value) public returns (bool);
60   event Approval(
61     address indexed owner,
62     address indexed spender,
63     uint256 value
64   );
65 }
66 
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   uint256 totalSupply_;
73 
74   /**
75   * @dev total number of tokens in existence
76   */
77   function totalSupply() public view returns (uint256) {
78     return totalSupply_;
79   }
80 
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[msg.sender]);
89 
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     emit Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 /**
108  * @title Standard ERC20 token
109  *
110  * @dev Implementation of the basic standard token.
111  * @dev https://github.com/ethereum/EIPs/issues/20
112  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
113  */
114 contract StandardToken is ERC20, BasicToken {
115 
116   mapping (address => mapping (address => uint256)) internal allowed;
117 
118 
119   /**
120    * @dev Transfer tokens from one address to another
121    * @param _from address The address which you want to send tokens from
122    * @param _to address The address which you want to transfer to
123    * @param _value uint256 the amount of tokens to be transferred
124    */
125   function transferFrom(
126     address _from,
127     address _to,
128     uint256 _value
129   )
130     public
131     returns (bool)
132   {
133     require(_to != address(0));
134     require(_value <= balances[_from]);
135     require(_value <= allowed[_from][msg.sender]);
136 
137     balances[_from] = balances[_from].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140     emit Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
146    *
147    * Beware that changing an allowance with this method brings the risk that someone may use both the old
148    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint256 _value) public returns (bool) {
155     allowed[msg.sender][_spender] = _value;
156     emit Approval(msg.sender, _spender, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Function to check the amount of tokens that an owner allowed to a spender.
162    * @param _owner address The address which owns the funds.
163    * @param _spender address The address which will spend the funds.
164    * @return A uint256 specifying the amount of tokens still available for the spender.
165    */
166   function allowance(
167     address _owner,
168     address _spender
169    )
170     public
171     view
172     returns (uint256)
173   {
174     return allowed[_owner][_spender];
175   }
176 
177   /**
178    * @dev Increase the amount of tokens that an owner allowed to a spender.
179    *
180    * approve should be called when allowed[_spender] == 0. To increment
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _addedValue The amount of tokens to increase the allowance by.
186    */
187   function increaseApproval(
188     address _spender,
189     uint _addedValue
190   )
191     public
192     returns (bool)
193   {
194     allowed[msg.sender][_spender] = (
195       allowed[msg.sender][_spender].add(_addedValue));
196     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 
200   /**
201    * @dev Decrease the amount of tokens that an owner allowed to a spender.
202    *
203    * approve should be called when allowed[_spender] == 0. To decrement
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _subtractedValue The amount of tokens to decrease the allowance by.
209    */
210   function decreaseApproval(
211     address _spender,
212     uint _subtractedValue
213   )
214     public
215     returns (bool)
216   {
217     uint oldValue = allowed[msg.sender][_spender];
218     if (_subtractedValue > oldValue) {
219       allowed[msg.sender][_spender] = 0;
220     } else {
221       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
222     }
223     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224     return true;
225   }
226 
227 }
228 
229 contract Ownable {
230   address public owner;
231 
232 
233   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
234 
235 
236   /**
237    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
238    * account.
239    */
240   function Ownable() public {
241     //owner = msg.sender;
242   }
243 
244 
245   /**
246    * @dev Throws if called by any account other than the owner.
247    */
248   modifier onlyOwner() {
249     require(msg.sender == owner);
250     _;
251   }
252 
253 
254   /**
255    * @dev Allows the current owner to transfer control of the contract to a newOwner.
256    * @param newOwner The address to transfer ownership to.
257    */
258   function transferOwnership(address newOwner) public onlyOwner {
259     require(newOwner != address(0));
260     OwnershipTransferred(owner, newOwner);
261     owner = newOwner;
262   }
263 
264 }
265 
266 
267 
268 contract BurnableToken is StandardToken, Ownable {
269 
270     event Burn(address indexed burner, uint256 value);
271 
272     /**
273      * @dev Burns a specific amount of tokens.
274      * @param _value The amount of token to be burned.
275      */
276     function burn(uint256 _value) public {
277         require(_value > 0);
278         require(_value <= balances[msg.sender]);
279         // no need to require value <= totalSupply, since that would imply the
280         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
281 
282         address burner = msg.sender;
283         balances[burner] = balances[burner].sub(_value);
284         totalSupply_ = totalSupply_.sub(_value);
285         Burn(burner, _value);
286     }
287 }
288 
289 contract MintableToken is StandardToken, Ownable {
290   event Mint(address indexed to, uint256 amount);
291   event MintFinished();
292 
293   bool public mintingFinished = false;
294 
295 
296   modifier canMint() {
297     require(!mintingFinished);
298     _;
299   }
300 
301   /**
302    * @dev Function to mint tokens
303    * @param _to The address that will receive the minted tokens.
304    * @param _amount The amount of tokens to mint.
305    * @return A boolean that indicates if the operation was successful.
306    */
307   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
308     totalSupply_ = totalSupply_.add(_amount);
309     balances[_to] = balances[_to].add(_amount);
310     Mint(_to, _amount);
311     Transfer(address(0), _to, _amount);
312     return true;
313   }
314 
315   /**
316    * @dev Function to stop minting new tokens.
317    * @return True if the operation was successful.
318    */
319   function finishMinting() onlyOwner canMint public returns (bool) {
320     mintingFinished = true;
321     MintFinished();
322     return true;
323   }
324 }
325 
326 
327 
328 contract ERC1132 {
329     /**
330      * @dev Reasons why a user's tokens have been locked
331      */
332     mapping(address => bytes32[]) public lockReason;
333 
334     /**
335      * @dev locked token structure
336      */
337     struct lockToken {
338         uint256 amount;
339         uint256 validity;
340         bool claimed;
341     }
342 
343     /**
344      * @dev Holds number & validity of tokens locked for a given reason for
345      *      a specified address
346      */
347     mapping(address => mapping(bytes32 => lockToken)) public locked;
348 
349     /**
350      * @dev Records data of all the tokens Locked
351      */
352     event Locked(
353         address indexed _of,
354         bytes32 indexed _reason,
355         uint256 _amount,
356         uint256 _validity
357     );
358 
359     /**
360      * @dev Records data of all the tokens unlocked
361      */
362     event Unlocked(
363         address indexed _of,
364         bytes32 indexed _reason,
365         uint256 _amount
366     );
367     
368     /**
369      * @dev Locks a specified amount of tokens against an address,
370      *      for a specified reason and time
371      * @param _reason The reason to lock tokens
372      * @param _amount Number of tokens to be locked
373      * @param _time Lock time in seconds
374      */
375     function lock(bytes32 _reason, uint256 _amount, uint256 _time)
376         public returns (bool);
377   
378     /**
379      * @dev Returns tokens locked for a specified address for a
380      *      specified reason
381      *
382      * @param _of The address whose tokens are locked
383      * @param _reason The reason to query the lock tokens for
384      */
385     function tokensLocked(address _of, bytes32 _reason)
386         public view returns (uint256 amount);
387     
388     /**
389      * @dev Returns tokens locked for a specified address for a
390      *      specified reason at a specific time
391      *
392      * @param _of The address whose tokens are locked
393      * @param _reason The reason to query the lock tokens for
394      * @param _time The timestamp to query the lock tokens for
395      */
396     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
397         public view returns (uint256 amount);
398     
399     /**
400      * @dev Returns total tokens held by an address (locked + transferable)
401      * @param _of The address to query the total balance of
402      */
403     function totalBalanceOf(address _of)
404         public view returns (uint256 amount);
405     
406     /**
407      * @dev Extends lock for a specified reason and time
408      * @param _reason The reason to lock tokens
409      * @param _time Lock extension time in seconds
410      */
411     function extendLock(bytes32 _reason, uint256 _time)
412         public returns (bool);
413     
414     /**
415      * @dev Increase number of tokens locked for a specified reason
416      * @param _reason The reason to lock tokens
417      * @param _amount Number of tokens to be increased
418      */
419     function increaseLockAmount(bytes32 _reason, uint256 _amount)
420         public returns (bool);
421 
422     /**
423      * @dev Returns unlockable tokens for a specified address for a specified reason
424      * @param _of The address to query the the unlockable token count of
425      * @param _reason The reason to query the unlockable tokens for
426      */
427     function tokensUnlockable(address _of, bytes32 _reason)
428         public view returns (uint256 amount);
429  
430     /**
431      * @dev Unlocks the unlockable tokens of a specified address
432      * @param _of Address of user, claiming back unlockable tokens
433      */
434     function unlock(address _of)
435         public returns (uint256 unlockableTokens);
436 
437     /**
438      * @dev Gets the unlockable tokens of a specified address
439      * @param _of The address to query the the unlockable token count of
440      */
441     function getUnlockableTokens(address _of)
442         public view returns (uint256 unlockableTokens);
443 
444 }
445 
446 contract LockableToken is ERC1132, StandardToken ,BurnableToken ,MintableToken{
447     
448     string public constant name = "BITROZEX";
449     string public constant symbol = "BTZ";
450     uint8 public constant decimals = 8;
451 
452    /**
453     * @dev Error messages for require statements
454     */
455     string internal constant ALREADY_LOCKED = 'Tokens already locked';
456     string internal constant NOT_LOCKED = 'No tokens locked';
457     string internal constant AMOUNT_ZERO = 'Amount can not be 0';
458    
459    /**
460     * @dev constructor to mint initial tokens
461     * Shall update to _mint once openzepplin updates their npm package.
462     */
463     constructor() public {
464         
465         owner=0x788622aE0633DB0fB25701FdDd66EfAE6f7e08af;
466         totalSupply_ =42100000*10**8;
467         balances[owner] = totalSupply_;
468     }
469 
470      function Airdrop(ERC20 token, address[] _addresses, uint256 amount) public {
471         for (uint256 i = 0; i < _addresses.length; i++) {
472             token.transfer(_addresses[i], amount);
473         }
474     }
475 
476 
477     /**
478      * @dev Locks a specified amount of tokens against an address,
479      *      for a specified reason and time
480      * @param _reason The reason to lock tokens
481      * @param _amount Number of tokens to be locked
482      * @param _time Lock time in seconds
483      */
484     function lock(bytes32 _reason, uint256 _amount, uint256 _time)
485         public
486         returns (bool)
487     {
488         uint256 validUntil = now.add(_time); //solhint-disable-line
489 
490         // If tokens are already locked, then functions extendLock or
491         // increaseLockAmount should be used to make any changes
492         require(tokensLocked(msg.sender, _reason) == 0, ALREADY_LOCKED);
493         require(_amount != 0, AMOUNT_ZERO);
494 
495         if (locked[msg.sender][_reason].amount == 0)
496             lockReason[msg.sender].push(_reason);
497 
498         transfer(address(this), _amount);
499 
500         locked[msg.sender][_reason] = lockToken(_amount, validUntil, false);
501 
502         emit Locked(msg.sender, _reason, _amount, validUntil);
503         return true;
504     }
505     
506     /**
507      * @dev Transfers and Locks a specified amount of tokens,
508      *      for a specified reason and time
509      * @param _to adress to which tokens are to be transfered
510      * @param _reason The reason to lock tokens
511      * @param _amount Number of tokens to be transfered and locked
512      * @param _time Lock time in seconds
513      */
514     function transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time)
515         public
516         returns (bool)
517     {
518         uint256 validUntil = now.add(_time); //solhint-disable-line
519 
520         require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);
521         require(_amount != 0, AMOUNT_ZERO);
522 
523         if (locked[_to][_reason].amount == 0)
524             lockReason[_to].push(_reason);
525 
526         transfer(address(this), _amount);
527 
528         locked[_to][_reason] = lockToken(_amount, validUntil, false);
529         
530         emit Locked(_to, _reason, _amount, validUntil);
531         return true;
532     }
533 
534     /**
535      * @dev Returns tokens locked for a specified address for a
536      *      specified reason
537      *
538      * @param _of The address whose tokens are locked
539      * @param _reason The reason to query the lock tokens for
540      */
541     function tokensLocked(address _of, bytes32 _reason)
542         public
543         view
544         returns (uint256 amount)
545     {
546         if (!locked[_of][_reason].claimed)
547             amount = locked[_of][_reason].amount;
548     }
549     
550     /**
551      * @dev Returns tokens locked for a specified address for a
552      *      specified reason at a specific time
553      *
554      * @param _of The address whose tokens are locked
555      * @param _reason The reason to query the lock tokens for
556      * @param _time The timestamp to query the lock tokens for
557      */
558     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
559         public
560         view
561         returns (uint256 amount)
562     {
563         if (locked[_of][_reason].validity > _time)
564             amount = locked[_of][_reason].amount;
565     }
566 
567     /**
568      * @dev Returns total tokens held by an address (locked + transferable)
569      * @param _of The address to query the total balance of
570      */
571     function totalBalanceOf(address _of)
572         public
573         view
574         returns (uint256 amount)
575     {
576         amount = balanceOf(_of);
577 
578         for (uint256 i = 0; i < lockReason[_of].length; i++) {
579             amount = amount.add(tokensLocked(_of, lockReason[_of][i]));
580         }   
581     }    
582     
583     /**
584      * @dev Extends lock for a specified reason and time
585      * @param _reason The reason to lock tokens
586      * @param _time Lock extension time in seconds
587      */
588     function extendLock(bytes32 _reason, uint256 _time)
589         public
590         returns (bool)
591     {
592         require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
593 
594         locked[msg.sender][_reason].validity = locked[msg.sender][_reason].validity.add(_time);
595 
596         emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
597         return true;
598     }
599     
600     /**
601      * @dev Increase number of tokens locked for a specified reason
602      * @param _reason The reason to lock tokens
603      * @param _amount Number of tokens to be increased
604      */
605     function increaseLockAmount(bytes32 _reason, uint256 _amount)
606         public
607         returns (bool)
608     {
609         require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
610         transfer(address(this), _amount);
611 
612         locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);
613 
614         emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
615         return true;
616     }
617 
618     /**
619      * @dev Returns unlockable tokens for a specified address for a specified reason
620      * @param _of The address to query the the unlockable token count of
621      * @param _reason The reason to query the unlockable tokens for
622      */
623     function tokensUnlockable(address _of, bytes32 _reason)
624         public
625         view
626         returns (uint256 amount)
627     {
628         if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) //solhint-disable-line
629             amount = locked[_of][_reason].amount;
630     }
631 
632     /**
633      * @dev Unlocks the unlockable tokens of a specified address
634      * @param _of Address of user, claiming back unlockable tokens
635      */
636     function unlock(address _of)
637         public
638         returns (uint256 unlockableTokens)
639     {
640         uint256 lockedTokens;
641 
642         for (uint256 i = 0; i < lockReason[_of].length; i++) {
643             lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);
644             if (lockedTokens > 0) {
645                 unlockableTokens = unlockableTokens.add(lockedTokens);
646                 locked[_of][lockReason[_of][i]].claimed = true;
647                 emit Unlocked(_of, lockReason[_of][i], lockedTokens);
648             }
649         }  
650 
651         if (unlockableTokens > 0)
652             this.transfer(_of, unlockableTokens);
653     }
654 
655     /**
656      * @dev Gets the unlockable tokens of a specified address
657      * @param _of The address to query the the unlockable token count of
658      */
659     function getUnlockableTokens(address _of)
660         public
661         view
662         returns (uint256 unlockableTokens)
663     {
664         for (uint256 i = 0; i < lockReason[_of].length; i++) {
665             unlockableTokens = unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));
666         }  
667     }
668 }