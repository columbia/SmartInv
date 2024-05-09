1 pragma solidity 0.4.23;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
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
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/math/SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     if (a == 0) {
58       return 0;
59     }
60     uint256 c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   /**
76   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     // SafeMath.sub will throw if there is not enough balance.
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256 balance) {
149     return balances[_owner];
150   }
151 
152 }
153 
154 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender) public view returns (uint256);
162   function transferFrom(address from, address to, uint256 value) public returns (bool);
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
168 
169 /**
170  * @title Standard ERC20 token
171  *
172  * @dev Implementation of the basic standard token.
173  * @dev https://github.com/ethereum/EIPs/issues/20
174  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  */
176 contract StandardToken is ERC20, BasicToken {
177 
178   mapping (address => mapping (address => uint256)) internal allowed;
179 
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
188     require(_to != address(0));
189     require(_value <= balances[_from]);
190     require(_value <= allowed[_from][msg.sender]);
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    *
202    * Beware that changing an allowance with this method brings the risk that someone may use both the old
203    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed[msg.sender][_spender] = _value;
211     Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(address _owner, address _spender) public view returns (uint256) {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To increment
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _addedValue The amount of tokens to increase the allowance by.
234    */
235   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
236     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241   /**
242    * @dev Decrease the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To decrement
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _subtractedValue The amount of tokens to decrease the allowance by.
250    */
251   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
265 
266 /**
267  * @title Mintable token
268  * @dev Simple ERC20 Token example, with mintable token creation
269  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
270  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
271  */
272 contract MintableToken is StandardToken, Ownable {
273   event Mint(address indexed to, uint256 amount);
274   event MintFinished();
275 
276   bool public mintingFinished = false;
277 
278 
279   modifier canMint() {
280     require(!mintingFinished);
281     _;
282   }
283 
284   /**
285    * @dev Function to mint tokens
286    * @param _to The address that will receive the minted tokens.
287    * @param _amount The amount of tokens to mint.
288    * @return A boolean that indicates if the operation was successful.
289    */
290   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
291     totalSupply_ = totalSupply_.add(_amount);
292     balances[_to] = balances[_to].add(_amount);
293     Mint(_to, _amount);
294     Transfer(address(0), _to, _amount);
295     return true;
296   }
297 
298   /**
299    * @dev Function to stop minting new tokens.
300    * @return True if the operation was successful.
301    */
302   function finishMinting() onlyOwner canMint public returns (bool) {
303     mintingFinished = true;
304     MintFinished();
305     return true;
306   }
307 }
308 
309 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
310 
311 /**
312  * @title Pausable
313  * @dev Base contract which allows children to implement an emergency stop mechanism.
314  */
315 contract Pausable is Ownable {
316   event Pause();
317   event Unpause();
318 
319   bool public paused = false;
320 
321 
322   /**
323    * @dev Modifier to make a function callable only when the contract is not paused.
324    */
325   modifier whenNotPaused() {
326     require(!paused);
327     _;
328   }
329 
330   /**
331    * @dev Modifier to make a function callable only when the contract is paused.
332    */
333   modifier whenPaused() {
334     require(paused);
335     _;
336   }
337 
338   /**
339    * @dev called by the owner to pause, triggers stopped state
340    */
341   function pause() onlyOwner whenNotPaused public {
342     paused = true;
343     Pause();
344   }
345 
346   /**
347    * @dev called by the owner to unpause, returns to normal state
348    */
349   function unpause() onlyOwner whenPaused public {
350     paused = false;
351     Unpause();
352   }
353 }
354 
355 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
356 
357 /**
358  * @title Pausable token
359  * @dev StandardToken modified with pausable transfers.
360  **/
361 contract PausableToken is StandardToken, Pausable {
362 
363   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
364     return super.transfer(_to, _value);
365   }
366 
367   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
368     return super.transferFrom(_from, _to, _value);
369   }
370 
371   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
372     return super.approve(_spender, _value);
373   }
374 
375   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
376     return super.increaseApproval(_spender, _addedValue);
377   }
378 
379   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
380     return super.decreaseApproval(_spender, _subtractedValue);
381   }
382 }
383 
384 // File: contracts/REBToken.sol
385 
386 /**
387  * @title REB Token contract - ERC20 compatible token contract.
388  */
389 contract REBToken is PausableToken, MintableToken {
390     string public name = "REBGLO Token";
391     string public symbol = "REB";
392     uint8 public decimals = 18;
393 
394     /**
395      * @dev Contract constructor function to start token paused for transfer
396      */
397     function REBToken() public {
398         pause();
399     }
400 
401     /**
402      * @dev check user's REB balance tier
403      * @param holderAddress Token holder address
404      * @return string representing the milestone tier
405      */
406     function checkBalanceTier(address holderAddress) public view returns(string) {
407         uint256 holderBalance = balanceOf(holderAddress);
408 
409         if (holderBalance >= 1000000e18) {
410             return "Platinum tier";
411         } else if (holderBalance >= 700000e18) {
412             return "Gold tier";
413         } else if (holderBalance >= 300000e18) {
414             return "Titanium tier";
415         } else if (holderBalance == 0) {
416             return "Possess no REB";
417         }
418 
419         return "Free tier";
420     }
421 }
422 
423 // File: contracts/LockTokenAllocation.sol
424 
425 /**
426  * @title LockTokenAllocation contract
427  */
428 contract LockTokenAllocation is Ownable {
429     using SafeMath for uint;
430     uint256 public unlockedAt;
431     uint256 public canSelfDestruct;
432     uint256 public tokensCreated;
433     uint256 public allocatedTokens;
434     uint256 public totalLockTokenAllocation;
435 
436     mapping (address => uint256) public lockedAllocations;
437 
438     REBToken public REB;
439 
440     /**
441      * @dev constructor function that sets token, totalTokenSupply, unlock time, and selfdestruct timestamp
442      * for the LockTokenAllocation contract
443      */
444     function LockTokenAllocation
445         (
446             REBToken _token,
447             uint256 _unlockedAt,
448             uint256 _canSelfDestruct,
449             uint256 _totalLockTokenAllocation
450         )
451         public
452     {
453         require(_token != address(0));
454 
455         REB = REBToken(_token);
456         unlockedAt = _unlockedAt;
457         canSelfDestruct = _canSelfDestruct;
458         totalLockTokenAllocation = _totalLockTokenAllocation;
459     }
460 
461     /**
462      * @dev Adds founders' token allocation
463      * @param beneficiary Ethereum address of a person
464      * @param allocationValue Number of tokens allocated to person
465      * @return true if address is correctly added
466      */
467     function addLockTokenAllocation(address beneficiary, uint256 allocationValue)
468         external
469         onlyOwner
470         returns(bool)
471     {
472         require(lockedAllocations[beneficiary] == 0 && beneficiary != address(0)); // can only add once.
473 
474         allocatedTokens = allocatedTokens.add(allocationValue);
475         require(allocatedTokens <= totalLockTokenAllocation);
476 
477         lockedAllocations[beneficiary] = allocationValue;
478         return true;
479     }
480 
481 
482     /**
483      * @dev Allow unlocking of allocated tokens by transferring them to whitelisted addresses.
484      * Need to be called by each address
485      */
486     function unlock() external {
487         require(REB != address(0));
488         assert(now >= unlockedAt);
489 
490         // During first unlock attempt fetch total number of locked tokens.
491         if (tokensCreated == 0) {
492             tokensCreated = REB.balanceOf(this);
493         }
494 
495         uint256 transferAllocation = lockedAllocations[msg.sender];
496         lockedAllocations[msg.sender] = 0;
497 
498         // Will fail if allocation (and therefore toTransfer) is 0.
499         require(REB.transfer(msg.sender, transferAllocation));
500     }
501 
502     /**
503      * @dev allow for selfdestruct possibility and sending funds to owner
504      */
505     function kill() public onlyOwner {
506         require(now >= canSelfDestruct);
507         uint256 balance = REB.balanceOf(this);
508 
509         if (balance > 0) {
510             REB.transfer(msg.sender, balance);
511         }
512 
513         selfdestruct(owner);
514     }
515 }
516 
517 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
518 
519 /**
520  * @title Crowdsale
521  * @dev Crowdsale is a base contract for managing a token crowdsale,
522  * allowing investors to purchase tokens with ether. This contract implements
523  * such functionality in its most fundamental form and can be extended to provide additional
524  * functionality and/or custom behavior.
525  * The external interface represents the basic interface for purchasing tokens, and conform
526  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
527  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
528  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
529  * behavior.
530  */
531 
532 contract Crowdsale {
533   using SafeMath for uint256;
534 
535   // The token being sold
536   ERC20 public token;
537 
538   // Address where funds are collected
539   address public wallet;
540 
541   // How many token units a buyer gets per wei
542   uint256 public rate;
543 
544   // Amount of wei raised
545   uint256 public weiRaised;
546 
547   /**
548    * Event for token purchase logging
549    * @param purchaser who paid for the tokens
550    * @param beneficiary who got the tokens
551    * @param value weis paid for purchase
552    * @param amount amount of tokens purchased
553    */
554   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
555 
556   /**
557    * @param _rate Number of token units a buyer gets per wei
558    * @param _wallet Address where collected funds will be forwarded to
559    * @param _token Address of the token being sold
560    */
561   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
562     require(_rate > 0);
563     require(_wallet != address(0));
564     require(_token != address(0));
565 
566     rate = _rate;
567     wallet = _wallet;
568     token = _token;
569   }
570 
571   // -----------------------------------------
572   // Crowdsale external interface
573   // -----------------------------------------
574 
575   /**
576    * @dev fallback function ***DO NOT OVERRIDE***
577    */
578   function () external payable {
579     buyTokens(msg.sender);
580   }
581 
582   /**
583    * @dev low level token purchase ***DO NOT OVERRIDE***
584    * @param _beneficiary Address performing the token purchase
585    */
586   function buyTokens(address _beneficiary) public payable {
587 
588     uint256 weiAmount = msg.value;
589     _preValidatePurchase(_beneficiary, weiAmount);
590 
591     // calculate token amount to be created
592     uint256 tokens = _getTokenAmount(weiAmount);
593 
594     // update state
595     weiRaised = weiRaised.add(weiAmount);
596 
597     _processPurchase(_beneficiary, tokens);
598     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
599 
600     _updatePurchasingState(_beneficiary, weiAmount);
601 
602     _forwardFunds();
603     _postValidatePurchase(_beneficiary, weiAmount);
604   }
605 
606   // -----------------------------------------
607   // Internal interface (extensible)
608   // -----------------------------------------
609 
610   /**
611    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
612    * @param _beneficiary Address performing the token purchase
613    * @param _weiAmount Value in wei involved in the purchase
614    */
615   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
616     require(_beneficiary != address(0));
617     require(_weiAmount != 0);
618   }
619 
620   /**
621    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
622    * @param _beneficiary Address performing the token purchase
623    * @param _weiAmount Value in wei involved in the purchase
624    */
625   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
626     // optional override
627   }
628 
629   /**
630    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
631    * @param _beneficiary Address performing the token purchase
632    * @param _tokenAmount Number of tokens to be emitted
633    */
634   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
635     token.transfer(_beneficiary, _tokenAmount);
636   }
637 
638   /**
639    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
640    * @param _beneficiary Address receiving the tokens
641    * @param _tokenAmount Number of tokens to be purchased
642    */
643   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
644     _deliverTokens(_beneficiary, _tokenAmount);
645   }
646 
647   /**
648    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
649    * @param _beneficiary Address receiving the tokens
650    * @param _weiAmount Value in wei involved in the purchase
651    */
652   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
653     // optional override
654   }
655 
656   /**
657    * @dev Override to extend the way in which ether is converted to tokens.
658    * @param _weiAmount Value in wei to be converted into tokens
659    * @return Number of tokens that can be purchased with the specified _weiAmount
660    */
661   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
662     return _weiAmount.mul(rate);
663   }
664 
665   /**
666    * @dev Determines how ETH is stored/forwarded on purchases.
667    */
668   function _forwardFunds() internal {
669     wallet.transfer(msg.value);
670   }
671 }
672 
673 // File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
674 
675 /**
676  * @title TimedCrowdsale
677  * @dev Crowdsale accepting contributions only within a time frame.
678  */
679 contract TimedCrowdsale is Crowdsale {
680   using SafeMath for uint256;
681 
682   uint256 public openingTime;
683   uint256 public closingTime;
684 
685   /**
686    * @dev Reverts if not in crowdsale time range.
687    */
688   modifier onlyWhileOpen {
689     require(now >= openingTime && now <= closingTime);
690     _;
691   }
692 
693   /**
694    * @dev Constructor, takes crowdsale opening and closing times.
695    * @param _openingTime Crowdsale opening time
696    * @param _closingTime Crowdsale closing time
697    */
698   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
699     require(_openingTime >= now);
700     require(_closingTime >= _openingTime);
701 
702     openingTime = _openingTime;
703     closingTime = _closingTime;
704   }
705 
706   /**
707    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
708    * @return Whether crowdsale period has elapsed
709    */
710   function hasClosed() public view returns (bool) {
711     return now > closingTime;
712   }
713 
714   /**
715    * @dev Extend parent behavior requiring to be within contributing period
716    * @param _beneficiary Token purchaser
717    * @param _weiAmount Amount of wei contributed
718    */
719   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
720     super._preValidatePurchase(_beneficiary, _weiAmount);
721   }
722 
723 }
724 
725 // File: zeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
726 
727 /**
728  * @title FinalizableCrowdsale
729  * @dev Extension of Crowdsale where an owner can do extra work
730  * after finishing.
731  */
732 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
733   using SafeMath for uint256;
734 
735   bool public isFinalized = false;
736 
737   event Finalized();
738 
739   /**
740    * @dev Must be called after crowdsale ends, to do some extra finalization
741    * work. Calls the contract's finalization function.
742    */
743   function finalize() onlyOwner public {
744     require(!isFinalized);
745     require(hasClosed());
746 
747     finalization();
748     Finalized();
749 
750     isFinalized = true;
751   }
752 
753   /**
754    * @dev Can be overridden to add finalization logic. The overriding function
755    * should call super.finalization() to ensure the chain of finalization is
756    * executed entirely.
757    */
758   function finalization() internal {
759   }
760 }
761 
762 // File: zeppelin-solidity/contracts/crowdsale/validation/WhitelistedCrowdsale.sol
763 
764 /**
765  * @title WhitelistedCrowdsale
766  * @dev Crowdsale in which only whitelisted users can contribute.
767  */
768 contract WhitelistedCrowdsale is Crowdsale, Ownable {
769 
770   mapping(address => bool) public whitelist;
771 
772   /**
773    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
774    */
775   modifier isWhitelisted(address _beneficiary) {
776     require(whitelist[_beneficiary]);
777     _;
778   }
779 
780   /**
781    * @dev Adds single address to whitelist.
782    * @param _beneficiary Address to be added to the whitelist
783    */
784   function addToWhitelist(address _beneficiary) external onlyOwner {
785     whitelist[_beneficiary] = true;
786   }
787 
788   /**
789    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
790    * @param _beneficiaries Addresses to be added to the whitelist
791    */
792   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
793     for (uint256 i = 0; i < _beneficiaries.length; i++) {
794       whitelist[_beneficiaries[i]] = true;
795     }
796   }
797 
798   /**
799    * @dev Removes single address from whitelist.
800    * @param _beneficiary Address to be removed to the whitelist
801    */
802   function removeFromWhitelist(address _beneficiary) external onlyOwner {
803     whitelist[_beneficiary] = false;
804   }
805 
806   /**
807    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
808    * @param _beneficiary Token beneficiary
809    * @param _weiAmount Amount of wei contributed
810    */
811   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
812     super._preValidatePurchase(_beneficiary, _weiAmount);
813   }
814 
815 }
816 
817 // File: contracts/REBCrowdsale.sol
818 
819 /**
820  * @title REB Crowdsale contract - crowdsale contract for the REB tokens.
821  */
822 contract REBCrowdsale is FinalizableCrowdsale, WhitelistedCrowdsale, Pausable {
823     uint256 constant public BOUNTY_SHARE =               125000000e18;   // 125 M
824     uint256 constant public TEAM_SHARE =                 2800000000e18;  // 2.8 B
825     uint256 constant public ADVISOR_SHARE =              1750000000e18;  // 1.75 B
826 
827     uint256 constant public AIRDROP_SHARE =              200000000e18;   // 200 M
828     uint256 constant public TOTAL_TOKENS_FOR_CROWDSALE = 5125000000e18;  // 5.125 B
829 
830     uint256 constant public PUBLIC_CROWDSALE_SOFT_CAP =  800000000e18;  // 800 M
831 
832     address public bountyWallet;
833     address public teamReserve;
834     address public advisorReserve;
835     address public airdrop;
836 
837     // remainderPurchaser and remainderTokens info saved in the contract
838     // used for reference for contract owner to send refund if any to last purchaser after end of crowdsale
839     address public remainderPurchaser;
840     uint256 public remainderAmount;
841 
842     // external contracts
843 
844     event MintedTokensFor(address indexed investor, uint256 tokensPurchased);
845     event TokenRateChanged(uint256 previousRate, uint256 newRate);
846 
847     /**
848      * @dev Contract constructor function
849      * @param _openingTime The timestamp of the beginning of the crowdsale
850      * @param _closingTime Timestamp when the crowdsale will finish
851      * @param _token REB token address
852      * @param _rate The token rate per ETH
853      * @param _wallet Multisig wallet that will hold the crowdsale funds.
854      * @param _bountyWallet Ethereum address where bounty tokens will be minted to
855      */
856     function REBCrowdsale
857         (
858             uint256 _openingTime,
859             uint256 _closingTime,
860             REBToken _token,
861             uint256 _rate,
862             address _wallet,
863             address _bountyWallet
864         )
865         public
866         FinalizableCrowdsale()
867         Crowdsale(_rate, _wallet, _token)
868         TimedCrowdsale(_openingTime, _closingTime)
869     {
870         require(_bountyWallet != address(0));
871         bountyWallet = _bountyWallet;
872 
873         require(REBToken(token).paused());
874         // NOTE: Ensure token ownership is transferred to crowdsale so it able to mint tokens
875     }
876 
877     /**
878      * @dev change crowdsale rate
879      * @param newRate Figure that corresponds to the new rate per token
880      */
881     function setRate(uint256 newRate) external onlyOwner {
882         require(newRate != 0);
883 
884         TokenRateChanged(rate, newRate);
885         rate = newRate;
886     }
887 
888     /**
889      * @dev Mint tokens investors that send fiat for token purchases.
890      * The send of fiat will be off chain and custom minting happens in this function and it performed by the owner
891      * @param beneficiaryAddress Address of beneficiary
892      * @param amountOfTokens Number of tokens to be created
893      */
894     function mintTokensFor(address beneficiaryAddress, uint256 amountOfTokens)
895         public
896         onlyOwner
897     {
898         require(beneficiaryAddress != address(0));
899         require(token.totalSupply().add(amountOfTokens) <= TOTAL_TOKENS_FOR_CROWDSALE);
900 
901         _deliverTokens(beneficiaryAddress, amountOfTokens);
902         MintedTokensFor(beneficiaryAddress, amountOfTokens);
903     }
904 
905     /**
906      * @dev Set the address which should receive the vested team and advisors tokens plus airdrop shares on finalization
907      * @param _teamReserve address of team and advisor allocation contract
908      * @param _advisorReserve address of team and advisor allocation contract
909      * @param _airdrop address of airdrop contract
910      */
911     function setTeamAndAdvisorAndAirdropAddresses
912         (
913             address _teamReserve,
914             address _advisorReserve,
915             address _airdrop
916         )
917         public
918         onlyOwner
919     {
920         // only able to be set once
921         require(teamReserve == address(0x0) && advisorReserve == address(0x0) && airdrop == address(0x0));
922         // ensure that the addresses as params to the func are not empty
923         require(_teamReserve != address(0x0) && _advisorReserve != address(0x0) && _airdrop != address(0x0));
924 
925         teamReserve = _teamReserve;
926         advisorReserve = _advisorReserve;
927         airdrop = _airdrop;
928     }
929 
930     // overriding TimeCrowdsale#hasClosed to add cap logic
931     // @return true if crowdsale event has ended
932     function hasClosed() public view returns (bool) {
933         if (token.totalSupply() > PUBLIC_CROWDSALE_SOFT_CAP) {
934             return true;
935         }
936 
937         return super.hasClosed();
938     }
939 
940     /**
941      * @dev Overrides delivery by minting tokens upon purchase.
942      * @param _beneficiary Token purchaser
943      * @param _tokenAmount Number of tokens to be minted
944      */
945     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
946         require(MintableToken(token).mint(_beneficiary, _tokenAmount));
947     }
948 
949     /**
950      * @dev Override validation of an incoming purchase.
951      * Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
952      * @param _beneficiary Address performing the token purchase
953      * @param _weiAmount Value in wei involved in the purchase
954      */
955     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount)
956         internal
957         isWhitelisted(_beneficiary)
958         whenNotPaused
959     {
960         require(_beneficiary != address(0));
961         require(_weiAmount != 0);
962         require(token.totalSupply() < TOTAL_TOKENS_FOR_CROWDSALE);
963     }
964 
965     /**
966      * @dev Override to extend the way in which ether is converted to tokens.
967      * @param _weiAmount Value in wei to be converted into tokens
968      * @return Number of tokens that can be purchased with the specified _weiAmount
969      */
970     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
971         uint256 tokensAmount = _weiAmount.mul(rate);
972 
973         // remainder logic
974         if (token.totalSupply().add(tokensAmount) > TOTAL_TOKENS_FOR_CROWDSALE) {
975             tokensAmount = TOTAL_TOKENS_FOR_CROWDSALE.sub(token.totalSupply());
976             uint256 _weiAmountLocalScope = tokensAmount.div(rate);
977 
978             // save info so as to refund purchaser after crowdsale's end
979             remainderPurchaser = msg.sender;
980             remainderAmount = _weiAmount.sub(_weiAmountLocalScope);
981 
982             // update state here so when it is updated again in buyTokens the weiAmount reflects the remainder logic
983             if (weiRaised > _weiAmount.add(_weiAmountLocalScope))
984                 weiRaised = weiRaised.sub(_weiAmount.add(_weiAmountLocalScope));
985         }
986 
987         return tokensAmount;
988     }
989 
990     /**
991      * @dev finalizes crowdsale
992      */
993     function finalization() internal {
994         // This must have been set manually prior to finalize().
995         require(teamReserve != address(0x0) && advisorReserve != address(0x0) && airdrop != address(0x0));
996 
997         if (TOTAL_TOKENS_FOR_CROWDSALE > token.totalSupply()) {
998             uint256 remainingTokens = TOTAL_TOKENS_FOR_CROWDSALE.sub(token.totalSupply());
999             _deliverTokens(wallet, remainingTokens);
1000         }
1001 
1002         // final minting
1003         _deliverTokens(bountyWallet, BOUNTY_SHARE);
1004         _deliverTokens(teamReserve, TEAM_SHARE);
1005         _deliverTokens(advisorReserve, ADVISOR_SHARE);
1006         _deliverTokens(airdrop, AIRDROP_SHARE);
1007 
1008         REBToken(token).finishMinting();
1009         REBToken(token).unpause();
1010         super.finalization();
1011     }
1012 }