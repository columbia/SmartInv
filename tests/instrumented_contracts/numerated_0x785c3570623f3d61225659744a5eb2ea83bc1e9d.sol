1 pragma solidity ^0.4.24;
2 
3 // File: contracts/libs/ERC223Receiver_Interface.sol
4 
5 /**
6  * @title ERC223-compliant contract interface.
7  */
8 contract ERC223Receiver {
9     constructor() internal {}
10 
11     /**
12      * @dev Standard ERC223 function that will handle incoming token transfers.
13      *
14      * @param _from Token sender address.
15      * @param _value Amount of tokens.
16      * @param _data Transaction metadata.
17      */
18     function tokenFallback(address _from, uint _value, bytes _data) public;
19 }
20 
21 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
32   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
33     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (a == 0) {
37       return 0;
38     }
39 
40     c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return a / b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
67     c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * See https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   function totalSupply() public view returns (uint256);
82   function balanceOf(address who) public view returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
88 
89 /**
90  * @title Basic token
91  * @dev Basic version of StandardToken, with no allowances.
92  */
93 contract BasicToken is ERC20Basic {
94   using SafeMath for uint256;
95 
96   mapping(address => uint256) balances;
97 
98   uint256 totalSupply_;
99 
100   /**
101   * @dev Total number of tokens in existence
102   */
103   function totalSupply() public view returns (uint256) {
104     return totalSupply_;
105   }
106 
107   /**
108   * @dev Transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     balances[msg.sender] = balances[msg.sender].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     emit Transfer(msg.sender, _to, _value);
119     return true;
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
131 }
132 
133 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 contract ERC20 is ERC20Basic {
140   function allowance(address owner, address spender)
141     public view returns (uint256);
142 
143   function transferFrom(address from, address to, uint256 value)
144     public returns (bool);
145 
146   function approve(address spender, uint256 value) public returns (bool);
147   event Approval(
148     address indexed owner,
149     address indexed spender,
150     uint256 value
151   );
152 }
153 
154 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
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
182     require(_to != address(0));
183     require(_value <= balances[_from]);
184     require(_value <= allowed[_from][msg.sender]);
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
264     if (_subtractedValue > oldValue) {
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
275 // File: contracts/libs/ERC223Token.sol
276 
277 /**
278  * @title Implementation of the ERC223 standard token.
279  * @dev See https://github.com/Dexaran/ERC223-token-standard
280  */
281 contract ERC223Token is StandardToken {
282     using SafeMath for uint;
283 
284     event Transfer(address indexed from, address indexed to, uint value, bytes data);
285 
286     modifier enoughBalance(uint _value) {
287         require (_value <= balanceOf(msg.sender));
288         _;
289     }
290 
291      /**
292      * @dev Transfer the specified amount of tokens to the specified address.
293      *      Invokes the `tokenFallback` function if the recipient is a contract.
294      *      The token transfer fails if the recipient is a contract
295      *      but does not implement the `tokenFallback` function
296      *      or the fallback function to receive funds.
297      *
298      * @param _to Receiver address.
299      * @param _value Amount of tokens that will be transferred.
300      * @param _data Transaction metadata.
301      * @return Success.
302      */
303     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
304         require(_to != address(0));
305 
306         return isContract(_to) ?
307             transferToContract(_to, _value, _data) :
308             transferToAddress(_to, _value, _data)
309         ;
310     }
311 
312     /**
313      * @dev Transfer the specified amount of tokens to the specified address.
314      *      This function works the same with the previous one
315      *      but doesn't contain `_data` param.
316      *      Added due to backwards compatibility reasons.
317      *
318      * @param _to Receiver address.
319      * @param _value Amount of tokens that will be transferred.
320      * @return Success.
321      */
322     function transfer(address _to, uint _value) public returns (bool success) {
323         bytes memory empty;
324 
325         return transfer(_to, _value, empty);
326     }
327 
328     /**
329      * @dev Assemble the given address bytecode. If bytecode exists then the _addr is a contract.
330      * @return If the target is a contract.
331      */
332     function isContract(address _addr) private view returns (bool is_contract) {
333         uint length;
334 
335         assembly {
336             // Retrieve the size of the code on target address; this needs assembly
337             length := extcodesize(_addr)
338         }
339 
340         return (length > 0);
341     }
342     
343     /**
344      * @dev Helper function that transfers to address.
345      * @return Success.
346      */
347     function transferToAddress(address _to, uint _value, bytes _data) private enoughBalance(_value) returns (bool success) {
348         balances[msg.sender] = balances[msg.sender].sub(_value);
349         balances[_to] = balanceOf(_to).add(_value);
350 
351         emit Transfer(msg.sender, _to, _value, _data);
352 
353         return true;
354     }
355 
356     /**
357      * @dev Helper function that transfers to contract.
358      * @return Success.
359      */
360     function transferToContract(address _to, uint _value, bytes _data) private enoughBalance(_value) returns (bool success) {
361         balances[msg.sender] = balances[msg.sender].sub(_value);
362         balances[_to] = balanceOf(_to).add(_value);
363 
364         ERC223Receiver receiver = ERC223Receiver(_to);
365         receiver.tokenFallback(msg.sender, _value, _data);
366 
367         emit Transfer(msg.sender, _to, _value, _data);
368 
369         return true;
370     }
371 }
372 
373 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
374 
375 /**
376  * @title Burnable Token
377  * @dev Token that can be irreversibly burned (destroyed).
378  */
379 contract BurnableToken is BasicToken {
380 
381   event Burn(address indexed burner, uint256 value);
382 
383   /**
384    * @dev Burns a specific amount of tokens.
385    * @param _value The amount of token to be burned.
386    */
387   function burn(uint256 _value) public {
388     _burn(msg.sender, _value);
389   }
390 
391   function _burn(address _who, uint256 _value) internal {
392     require(_value <= balances[_who]);
393     // no need to require value <= totalSupply, since that would imply the
394     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
395 
396     balances[_who] = balances[_who].sub(_value);
397     totalSupply_ = totalSupply_.sub(_value);
398     emit Burn(_who, _value);
399     emit Transfer(_who, address(0), _value);
400   }
401 }
402 
403 // File: openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
404 
405 /**
406  * @title Standard Burnable Token
407  * @dev Adds burnFrom method to ERC20 implementations
408  */
409 contract StandardBurnableToken is BurnableToken, StandardToken {
410 
411   /**
412    * @dev Burns a specific amount of tokens from the target address and decrements allowance
413    * @param _from address The address which you want to send tokens from
414    * @param _value uint256 The amount of token to be burned
415    */
416   function burnFrom(address _from, uint256 _value) public {
417     require(_value <= allowed[_from][msg.sender]);
418     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
419     // this function needs to emit an event with the updated approval.
420     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
421     _burn(_from, _value);
422   }
423 }
424 
425 // File: contracts/libs/BaseToken.sol
426 
427 /**
428  * @title Base token contract for oracle.
429  */
430 contract BaseToken is ERC223Token, StandardBurnableToken {
431 }
432 
433 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
434 
435 /**
436  * @title Ownable
437  * @dev The Ownable contract has an owner address, and provides basic authorization control
438  * functions, this simplifies the implementation of "user permissions".
439  */
440 contract Ownable {
441   address public owner;
442 
443 
444   event OwnershipRenounced(address indexed previousOwner);
445   event OwnershipTransferred(
446     address indexed previousOwner,
447     address indexed newOwner
448   );
449 
450 
451   /**
452    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
453    * account.
454    */
455   constructor() public {
456     owner = msg.sender;
457   }
458 
459   /**
460    * @dev Throws if called by any account other than the owner.
461    */
462   modifier onlyOwner() {
463     require(msg.sender == owner);
464     _;
465   }
466 
467   /**
468    * @dev Allows the current owner to relinquish control of the contract.
469    * @notice Renouncing to ownership will leave the contract without an owner.
470    * It will not be possible to call the functions with the `onlyOwner`
471    * modifier anymore.
472    */
473   function renounceOwnership() public onlyOwner {
474     emit OwnershipRenounced(owner);
475     owner = address(0);
476   }
477 
478   /**
479    * @dev Allows the current owner to transfer control of the contract to a newOwner.
480    * @param _newOwner The address to transfer ownership to.
481    */
482   function transferOwnership(address _newOwner) public onlyOwner {
483     _transferOwnership(_newOwner);
484   }
485 
486   /**
487    * @dev Transfers control of the contract to a newOwner.
488    * @param _newOwner The address to transfer ownership to.
489    */
490   function _transferOwnership(address _newOwner) internal {
491     require(_newOwner != address(0));
492     emit OwnershipTransferred(owner, _newOwner);
493     owner = _newOwner;
494   }
495 }
496 
497 // File: contracts/ShintakuToken.sol
498 
499 /**
500  * @title Shintaku token contract
501  * @dev Burnable ERC223 token with set emission curve.
502  */
503 contract ShintakuToken is BaseToken, Ownable {
504     using SafeMath for uint;
505 
506     string public constant symbol = "SHN";
507     string public constant name = "Shintaku";
508     uint8 public constant demicals = 18;
509 
510     // Unit of tokens
511     uint public constant TOKEN_UNIT = (10 ** uint(demicals));
512 
513     // Parameters
514 
515     // Number of blocks for each period (100000 = ~2-3 weeks)
516     uint public PERIOD_BLOCKS;
517     // Number of blocks to lock owner balance (50x = ~2 years)
518     uint public OWNER_LOCK_BLOCKS;
519     // Number of blocks to lock user remaining balances (25x = ~1 year)
520     uint public USER_LOCK_BLOCKS;
521     // Number of tokens per period during tail emission
522     uint public constant TAIL_EMISSION = 400 * (10 ** 3) * TOKEN_UNIT;
523     // Number of tokens to emit initially: tail emission is 4% of this
524     uint public constant INITIAL_EMISSION_FACTOR = 25;
525     // Absolute cap on funds received per period
526     // Note: this should be obscenely large to prevent larger ether holders
527     //  from monopolizing tokens at low cost. This cap should never be hit in
528     //  practice.
529     uint public constant MAX_RECEIVED_PER_PERIOD = 10000 ether;
530 
531     /**
532      * @dev Store relevant data for a period.
533      */
534     struct Period {
535         // Block this period has started at
536         uint started;
537 
538         // Total funds received this period
539         uint totalReceived;
540         // Locked owner balance, will unlock after a long time
541         uint ownerLockedBalance;
542         // Number of tokens to mint this period
543         uint minting;
544 
545         // Sealed purchases for each account
546         mapping (address => bytes32) sealedPurchaseOrders;
547         // Balance received from each account
548         mapping (address => uint) receivedBalances;
549         // Locked balance for each account
550         mapping (address => uint) lockedBalances;
551 
552         // When withdrawing, withdraw to an alias address (e.g. cold storage)
553         mapping (address => address) aliases;
554     }
555 
556     // Modifiers
557 
558     modifier validPeriod(uint _period) {
559         require(_period <= currentPeriodIndex());
560         _;
561     }
562 
563     // Contract state
564 
565     // List of periods
566     Period[] internal periods;
567 
568     // Address the owner can withdraw funds to (e.g. cold storage)
569     address public ownerAlias;
570 
571     // Events
572 
573     event NextPeriod(uint indexed _period, uint indexed _block);
574     event SealedOrderPlaced(address indexed _from, uint indexed _period, uint _value);
575     event SealedOrderRevealed(address indexed _from, uint indexed _period, address indexed _alias, uint _value);
576     event OpenOrderPlaced(address indexed _from, uint indexed _period, address indexed _alias, uint _value);
577     event Claimed(address indexed _from, uint indexed _period, address indexed _alias, uint _value);
578 
579     // Functions
580 
581     constructor(address _alias, uint _periodBlocks, uint _ownerLockFactor, uint _userLockFactor) public {
582         require(_alias != address(0));
583         require(_periodBlocks >= 2);
584         require(_ownerLockFactor > 0);
585         require(_userLockFactor > 0);
586 
587         periods.push(Period(block.number, 0, 0, calculateMinting(0)));
588         ownerAlias = _alias;
589 
590         PERIOD_BLOCKS = _periodBlocks;
591         OWNER_LOCK_BLOCKS = _periodBlocks.mul(_ownerLockFactor);
592         USER_LOCK_BLOCKS = _periodBlocks.mul(_userLockFactor);
593     }
594 
595     /**
596      * @dev Go to the next period, if sufficient time has passed.
597      */
598     function nextPeriod() public {
599         uint periodIndex = currentPeriodIndex();
600         uint periodIndexNext = periodIndex.add(1);
601         require(block.number.sub(periods[periodIndex].started) > PERIOD_BLOCKS);
602 
603         periods.push(Period(block.number, 0, 0, calculateMinting(periodIndexNext)));
604 
605         emit NextPeriod(periodIndexNext, block.number);
606     }
607 
608     /**
609      * @dev Creates a sealed purchase order.
610      * @param _from Account that will purchase tokens.
611      * @param _period Period of purchase order.
612      * @param _value Purchase funds, in wei.
613      * @param _salt Random value to keep purchase secret.
614      * @return The sealed purchase order.
615      */
616     function createPurchaseOrder(address _from, uint _period, uint _value, bytes32 _salt) public pure returns (bytes32) {
617         return keccak256(abi.encodePacked(_from, _period, _value, _salt));
618     }
619 
620     /**
621      * @dev Submit a sealed purchase order. Wei sent can be different then sealed value.
622      * @param _sealedPurchaseOrder The sealed purchase order.
623      */
624     function placePurchaseOrder(bytes32 _sealedPurchaseOrder) public payable {
625         if (block.number.sub(periods[currentPeriodIndex()].started) > PERIOD_BLOCKS) {
626             nextPeriod();
627         }
628         // Note: current period index may update from above call
629         Period storage period = periods[currentPeriodIndex()];
630         // Each address can only make a single purchase per period
631         require(period.sealedPurchaseOrders[msg.sender] == bytes32(0));
632 
633         period.sealedPurchaseOrders[msg.sender] = _sealedPurchaseOrder;
634         period.receivedBalances[msg.sender] = msg.value;
635 
636         emit SealedOrderPlaced(msg.sender, currentPeriodIndex(), msg.value);
637     }
638 
639     /**
640      * @dev Reveal a sealed purchase order and commit to a purchase.
641      * @param _sealedPurchaseOrder The sealed purchase order.
642      * @param _period Period of purchase order.
643      * @param _value Purchase funds, in wei.
644      * @param _period Period for which to reveal purchase order.
645      * @param _salt Random value to keep purchase secret.
646      * @param _alias Address to withdraw tokens and excess funds to.
647      */
648     function revealPurchaseOrder(bytes32 _sealedPurchaseOrder, uint _period, uint _value, bytes32 _salt, address _alias) public {
649         // Sanity check to make sure user enters an alias
650         require(_alias != address(0));
651         // Can only reveal sealed orders in the next period
652         require(currentPeriodIndex() == _period.add(1));
653         Period storage period = periods[_period];
654         // Each address can only make a single purchase per period
655         require(period.aliases[msg.sender] == address(0));
656 
657         // Note: don't *need* to advance period here
658 
659         bytes32 h = createPurchaseOrder(msg.sender, _period, _value, _salt);
660         require(h == _sealedPurchaseOrder);
661 
662         // The value revealed must not be greater than the value previously sent
663         require(_value <= period.receivedBalances[msg.sender]);
664 
665         period.totalReceived = period.totalReceived.add(_value);
666         uint remainder = period.receivedBalances[msg.sender].sub(_value);
667         period.receivedBalances[msg.sender] = _value;
668         period.aliases[msg.sender] = _alias;
669 
670         emit SealedOrderRevealed(msg.sender, _period, _alias, _value);
671 
672         // Return any extra balance to the alias
673         _alias.transfer(remainder);
674     }
675 
676     /**
677      * @dev Place an unsealed purchase order immediately.
678      * @param _alias Address to withdraw tokens to.
679      */
680     function placeOpenPurchaseOrder(address _alias) public payable {
681         // Sanity check to make sure user enters an alias
682         require(_alias != address(0));
683 
684         if (block.number.sub(periods[currentPeriodIndex()].started) > PERIOD_BLOCKS) {
685             nextPeriod();
686         }
687         // Note: current period index may update from above call
688         Period storage period = periods[currentPeriodIndex()];
689         // Each address can only make a single purchase per period
690         require(period.aliases[msg.sender] == address(0));
691 
692         period.totalReceived = period.totalReceived.add(msg.value);
693         period.receivedBalances[msg.sender] = msg.value;
694         period.aliases[msg.sender] = _alias;
695 
696         emit OpenOrderPlaced(msg.sender, currentPeriodIndex(), _alias, msg.value);
697     }
698 
699     /**
700      * @dev Claim previously purchased tokens for an account.
701      * @param _from Account to claim tokens for.
702      * @param _period Period for which to claim tokens.
703      */
704     function claim(address _from, uint _period) public {
705         // Claiming can only be done at least two periods after submitting sealed purchase order
706         require(currentPeriodIndex() > _period.add(1));
707         Period storage period = periods[_period];
708         require(period.receivedBalances[_from] > 0);
709 
710         uint value = period.receivedBalances[_from];
711         delete period.receivedBalances[_from];
712 
713         (uint emission, uint spent) = calculateEmission(_period, value);
714         uint remainder = value.sub(spent);
715 
716         address alias = period.aliases[_from];
717         // Mint tokens based on spent funds
718         mint(alias, emission);
719 
720         // Lock up remaining funds for account
721         period.lockedBalances[_from] = period.lockedBalances[_from].add(remainder);
722         // Lock up spent funds for owner
723         period.ownerLockedBalance = period.ownerLockedBalance.add(spent);
724 
725         emit Claimed(_from, _period, alias, emission);
726     }
727 
728     /*
729      * @dev Users can withdraw locked balances after the lock time has expired, for an account.
730      * @param _from Account to withdraw balance for.
731      * @param _period Period to withdraw funds for.
732      */
733     function withdraw(address _from, uint _period) public {
734         require(currentPeriodIndex() > _period);
735         Period storage period = periods[_period];
736         require(block.number.sub(period.started) > USER_LOCK_BLOCKS);
737 
738         uint balance = period.lockedBalances[_from];
739         require(balance <= address(this).balance);
740         delete period.lockedBalances[_from];
741 
742         address alias = period.aliases[_from];
743         // Don't delete this, as a user may have unclaimed tokens
744         //delete period.aliases[_from];
745         alias.transfer(balance);
746     }
747 
748     /**
749      * @dev Contract owner can withdraw unlocked owner funds.
750      * @param _period Period to withdraw funds for.
751      */
752     function withdrawOwner(uint _period) public onlyOwner {
753         require(currentPeriodIndex() > _period);
754         Period storage period = periods[_period];
755         require(block.number.sub(period.started) > OWNER_LOCK_BLOCKS);
756 
757         uint balance = period.ownerLockedBalance;
758         require(balance <= address(this).balance);
759         delete period.ownerLockedBalance;
760 
761         ownerAlias.transfer(balance);
762     }
763 
764     /**
765      * @dev The owner can withdraw any unrevealed balances after the deadline.
766      * @param _period Period to withdraw funds for.
767      * @param _from Account to withdraw unrevealed funds against.
768      */
769     function withdrawOwnerUnrevealed(uint _period, address _from) public onlyOwner {
770         // Must be past the reveal deadline of one period
771         require(currentPeriodIndex() > _period.add(1));
772         Period storage period = periods[_period];
773         require(block.number.sub(period.started) > OWNER_LOCK_BLOCKS);
774 
775         uint balance = period.receivedBalances[_from];
776         require(balance <= address(this).balance);
777         delete period.receivedBalances[_from];
778 
779         ownerAlias.transfer(balance);
780     }
781 
782     /**
783      * @dev Calculate the number of tokens to mint during a period.
784      * @param _period The period.
785      * @return Number of tokens to mint.
786      */
787     function calculateMinting(uint _period) internal pure returns (uint) {
788         // Every period, decrease emission by 5% of initial, until tail emission
789         return
790             _period < INITIAL_EMISSION_FACTOR ?
791             TAIL_EMISSION.mul(INITIAL_EMISSION_FACTOR.sub(_period)) :
792             TAIL_EMISSION
793         ;
794     }
795 
796     /**
797      * @dev Helper function to get current period index.
798      * @return The array index of the current period.
799      */
800     function currentPeriodIndex() public view returns (uint) {
801         assert(periods.length > 0);
802 
803         return periods.length.sub(1);
804     }
805 
806     /**
807      * @dev Calculate token emission.
808      * @param _period Period for which to calculate emission.
809      * @param _value Amount paid. Emissions is proportional to this.
810      * @return Number of tokens to emit.
811      * @return The spent balance.
812      */
813     function calculateEmission(uint _period, uint _value) internal view returns (uint, uint) {
814         Period storage currentPeriod = periods[_period];
815         uint minting = currentPeriod.minting;
816         uint totalReceived = currentPeriod.totalReceived;
817 
818         uint scaledValue = _value;
819         if (totalReceived > MAX_RECEIVED_PER_PERIOD) {
820             // If the funds received this period exceed the maximum, scale
821             // emission to refund remaining
822             scaledValue = _value.mul(MAX_RECEIVED_PER_PERIOD).div(totalReceived);
823         }
824 
825         uint emission = scaledValue.mul(minting).div(MAX_RECEIVED_PER_PERIOD);
826         return (emission, scaledValue);
827     }
828 
829     /**
830      * @dev Mints new tokens.
831      * @param _account Account that will receive new tokens.
832      * @param _value Number of tokens to mint.
833      */
834     function mint(address _account, uint _value) internal {
835         balances[_account] = balances[_account].add(_value);
836         totalSupply_ = totalSupply_.add(_value);
837     }
838 
839     // Getters
840 
841     function getPeriodStarted(uint _period) public view validPeriod(_period) returns (uint) {
842         return periods[_period].started;
843     }
844 
845     function getPeriodTotalReceived(uint _period) public view validPeriod(_period) returns (uint) {
846         return periods[_period].totalReceived;
847     }
848 
849     function getPeriodOwnerLockedBalance(uint _period) public view validPeriod(_period) returns (uint) {
850         return periods[_period].ownerLockedBalance;
851     }
852 
853     function getPeriodMinting(uint _period) public view validPeriod(_period) returns (uint) {
854         return periods[_period].minting;
855     }
856 
857     function getPeriodSealedPurchaseOrderFor(uint _period, address _account) public view validPeriod(_period) returns (bytes32) {
858         return periods[_period].sealedPurchaseOrders[_account];
859     }
860 
861     function getPeriodReceivedBalanceFor(uint _period, address _account) public view validPeriod(_period) returns (uint) {
862         return periods[_period].receivedBalances[_account];
863     }
864 
865     function getPeriodLockedBalanceFor(uint _period, address _account) public view validPeriod(_period) returns (uint) {
866         return periods[_period].lockedBalances[_account];
867     }
868 
869     function getPeriodAliasFor(uint _period, address _account) public view validPeriod(_period) returns (address) {
870         return periods[_period].aliases[_account];
871     }
872 }