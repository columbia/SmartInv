1 pragma solidity ^0.4.21;
2 
3 // ----------------- 
4 //begin SafeMath.sol
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 //end SafeMath.sol
53 // ----------------- 
54 //begin Ownable.sol
55 
56 /**
57  * @title Ownable
58  * @dev The Ownable contract has an owner address, and provides basic authorization control
59  * functions, this simplifies the implementation of "user permissions".
60  */
61 contract Ownable {
62   address public owner;
63 
64 
65   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67 
68   /**
69    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70    * account.
71    */
72   function Ownable() public {
73     owner = msg.sender;
74   }
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address newOwner) public onlyOwner {
89     require(newOwner != address(0));
90     emit OwnershipTransferred(owner, newOwner);
91     owner = newOwner;
92   }
93 
94 }
95 
96 //end Ownable.sol
97 // ----------------- 
98 //begin ERC20Basic.sol
99 
100 /**
101  * @title ERC20Basic
102  * @dev Simpler version of ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/179
104  */
105 contract ERC20Basic {
106   function totalSupply() public view returns (uint256);
107   function balanceOf(address who) public view returns (uint256);
108   function transfer(address to, uint256 value) public returns (bool);
109   event Transfer(address indexed from, address indexed to, uint256 value);
110 }
111 
112 //end ERC20Basic.sol
113 // ----------------- 
114 //begin Pausable.sol
115 
116 
117 
118 /**
119  * @title Pausable
120  * @dev Base contract which allows children to implement an emergency stop mechanism.
121  */
122 contract Pausable is Ownable {
123   event Pause();
124   event Unpause();
125 
126   bool public paused = false;
127 
128 
129   /**
130    * @dev Modifier to make a function callable only when the contract is not paused.
131    */
132   modifier whenNotPaused() {
133     require(!paused);
134     _;
135   }
136 
137   /**
138    * @dev Modifier to make a function callable only when the contract is paused.
139    */
140   modifier whenPaused() {
141     require(paused);
142     _;
143   }
144 
145   /**
146    * @dev called by the owner to pause, triggers stopped state
147    */
148   function pause() onlyOwner whenNotPaused public {
149     paused = true;
150     emit Pause();
151   }
152 
153   /**
154    * @dev called by the owner to unpause, returns to normal state
155    */
156   function unpause() onlyOwner whenPaused public {
157     paused = false;
158     emit Unpause();
159   }
160 }
161 
162 //end Pausable.sol
163 // ----------------- 
164 //begin ERC20.sol
165 
166 
167 /**
168  * @title ERC20 interface
169  * @dev see https://github.com/ethereum/EIPs/issues/20
170  */
171 contract ERC20 is ERC20Basic {
172   function allowance(address owner, address spender) public view returns (uint256);
173   function transferFrom(address from, address to, uint256 value) public returns (bool);
174   function approve(address spender, uint256 value) public returns (bool);
175   event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
177 
178 //end ERC20.sol
179 // ----------------- 
180 //begin BasicToken.sol
181 
182 
183 
184 /**
185  * @title Basic token
186  * @dev Basic version of StandardToken, with no allowances.
187  */
188 contract BasicToken is ERC20Basic {
189   using SafeMath for uint256;
190 
191   mapping(address => uint256) balances;
192 
193   uint256 totalSupply_;
194 
195   /**
196   * @dev total number of tokens in existence
197   */
198   function totalSupply() public view returns (uint256) {
199     return totalSupply_;
200   }
201 
202   /**
203   * @dev transfer token for a specified address
204   * @param _to The address to transfer to.
205   * @param _value The amount to be transferred.
206   */
207   function transfer(address _to, uint256 _value) public returns (bool) {
208     require(_to != address(0));
209     require(_value <= balances[msg.sender]);
210 
211     balances[msg.sender] = balances[msg.sender].sub(_value);
212     balances[_to] = balances[_to].add(_value);
213     emit Transfer(msg.sender, _to, _value);
214     return true;
215   }
216 
217   /**
218   * @dev Gets the balance of the specified address.
219   * @param _owner The address to query the the balance of.
220   * @return An uint256 representing the amount owned by the passed address.
221   */
222   function balanceOf(address _owner) public view returns (uint256 balance) {
223     return balances[_owner];
224   }
225 
226 }
227 
228 //end BasicToken.sol
229 // ----------------- 
230 //begin Crowdsale.sol
231 
232 
233 /**
234  * @title Crowdsale
235  * @dev Crowdsale is a base contract for managing a token crowdsale,
236  * allowing investors to purchase tokens with ether. This contract implements
237  * such functionality in its most fundamental form and can be extended to provide additional
238  * functionality and/or custom behavior.
239  * The external interface represents the basic interface for purchasing tokens, and conform
240  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
241  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
242  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
243  * behavior.
244  */
245 contract Crowdsale {
246   using SafeMath for uint256;
247 
248   // The token being sold
249   ERC20 public token;
250 
251   // Address where funds are collected
252   address public wallet;
253 
254   // How many token units a buyer gets per wei
255   uint256 public rate;
256 
257   // Amount of wei raised
258   uint256 public weiRaised;
259 
260   /**
261    * Event for token purchase logging
262    * @param purchaser who paid for the tokens
263    * @param beneficiary who got the tokens
264    * @param value weis paid for purchase
265    * @param amount amount of tokens purchased
266    */
267   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
268 
269   /**
270    * @param _rate Number of token units a buyer gets per wei
271    * @param _wallet Address where collected funds will be forwarded to
272    * @param _token Address of the token being sold
273    */
274   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
275     require(_rate > 0);
276     require(_wallet != address(0));
277     require(_token != address(0));
278 
279     rate = _rate;
280     wallet = _wallet;
281     token = _token;
282   }
283 
284   // -----------------------------------------
285   // Crowdsale external interface
286   // -----------------------------------------
287 
288   /**
289    * @dev fallback function ***DO NOT OVERRIDE***
290    */
291   function () external payable {
292     buyTokens(msg.sender);
293   }
294 
295   /**
296    * @dev low level token purchase ***DO NOT OVERRIDE***
297    * @param _beneficiary Address performing the token purchase
298    */
299   function buyTokens(address _beneficiary) public payable {
300 
301     uint256 weiAmount = msg.value;
302     _preValidatePurchase(_beneficiary, weiAmount);
303 
304     // calculate token amount to be created
305     uint256 tokens = _getTokenAmount(weiAmount);
306 
307     // update state
308     weiRaised = weiRaised.add(weiAmount);
309 
310     _processPurchase(_beneficiary, tokens);
311     emit TokenPurchase(
312       msg.sender,
313       _beneficiary,
314       weiAmount,
315       tokens
316     );
317 
318     _updatePurchasingState(_beneficiary, weiAmount);
319 
320     _forwardFunds();
321     _postValidatePurchase(_beneficiary, weiAmount);
322   }
323 
324   // -----------------------------------------
325   // Internal interface (extensible)
326   // -----------------------------------------
327 
328   /**
329    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
330    * @param _beneficiary Address performing the token purchase
331    * @param _weiAmount Value in wei involved in the purchase
332    */
333   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
334     require(_beneficiary != address(0));
335     require(_weiAmount != 0);
336   }
337 
338   /**
339    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
340    * @param _beneficiary Address performing the token purchase
341    * @param _weiAmount Value in wei involved in the purchase
342    */
343   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
344     // optional override
345   }
346 
347   /**
348    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
349    * @param _beneficiary Address performing the token purchase
350    * @param _tokenAmount Number of tokens to be emitted
351    */
352   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
353     token.transfer(_beneficiary, _tokenAmount);
354   }
355 
356   /**
357    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
358    * @param _beneficiary Address receiving the tokens
359    * @param _tokenAmount Number of tokens to be purchased
360    */
361   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
362     _deliverTokens(_beneficiary, _tokenAmount);
363   }
364 
365   /**
366    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
367    * @param _beneficiary Address receiving the tokens
368    * @param _weiAmount Value in wei involved in the purchase
369    */
370   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
371     // optional override
372   }
373 
374   /**
375    * @dev Override to extend the way in which ether is converted to tokens.
376    * @param _weiAmount Value in wei to be converted into tokens
377    * @return Number of tokens that can be purchased with the specified _weiAmount
378    */
379   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
380     return _weiAmount.mul(rate);
381   }
382 
383   /**
384    * @dev Determines how ETH is stored/forwarded on purchases.
385    */
386   function _forwardFunds() internal {
387     wallet.transfer(msg.value);
388   }
389 }
390 
391 //end Crowdsale.sol
392 // ----------------- 
393 //begin StandardToken.sol
394 
395 
396 /**
397  * @title Standard ERC20 token
398  *
399  * @dev Implementation of the basic standard token.
400  * @dev https://github.com/ethereum/EIPs/issues/20
401  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
402  */
403 contract StandardToken is ERC20, BasicToken {
404 
405   mapping (address => mapping (address => uint256)) internal allowed;
406 
407 
408   /**
409    * @dev Transfer tokens from one address to another
410    * @param _from address The address which you want to send tokens from
411    * @param _to address The address which you want to transfer to
412    * @param _value uint256 the amount of tokens to be transferred
413    */
414   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
415     require(_to != address(0));
416     require(_value <= balances[_from]);
417     require(_value <= allowed[_from][msg.sender]);
418 
419     balances[_from] = balances[_from].sub(_value);
420     balances[_to] = balances[_to].add(_value);
421     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
422     emit Transfer(_from, _to, _value);
423     return true;
424   }
425 
426   /**
427    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
428    *
429    * Beware that changing an allowance with this method brings the risk that someone may use both the old
430    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
431    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
432    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
433    * @param _spender The address which will spend the funds.
434    * @param _value The amount of tokens to be spent.
435    */
436   function approve(address _spender, uint256 _value) public returns (bool) {
437     allowed[msg.sender][_spender] = _value;
438     emit Approval(msg.sender, _spender, _value);
439     return true;
440   }
441 
442   /**
443    * @dev Function to check the amount of tokens that an owner allowed to a spender.
444    * @param _owner address The address which owns the funds.
445    * @param _spender address The address which will spend the funds.
446    * @return A uint256 specifying the amount of tokens still available for the spender.
447    */
448   function allowance(address _owner, address _spender) public view returns (uint256) {
449     return allowed[_owner][_spender];
450   }
451 
452   /**
453    * @dev Increase the amount of tokens that an owner allowed to a spender.
454    *
455    * approve should be called when allowed[_spender] == 0. To increment
456    * allowed value is better to use this function to avoid 2 calls (and wait until
457    * the first transaction is mined)
458    * From MonolithDAO Token.sol
459    * @param _spender The address which will spend the funds.
460    * @param _addedValue The amount of tokens to increase the allowance by.
461    */
462   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
463     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
464     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
465     return true;
466   }
467 
468   /**
469    * @dev Decrease the amount of tokens that an owner allowed to a spender.
470    *
471    * approve should be called when allowed[_spender] == 0. To decrement
472    * allowed value is better to use this function to avoid 2 calls (and wait until
473    * the first transaction is mined)
474    * From MonolithDAO Token.sol
475    * @param _spender The address which will spend the funds.
476    * @param _subtractedValue The amount of tokens to decrease the allowance by.
477    */
478   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
479     uint oldValue = allowed[msg.sender][_spender];
480     if (_subtractedValue > oldValue) {
481       allowed[msg.sender][_spender] = 0;
482     } else {
483       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
484     }
485     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
486     return true;
487   }
488 
489 }
490 
491 //end StandardToken.sol
492 // ----------------- 
493 //begin PausableToken.sol
494 
495 
496 /**
497  * @title Pausable token
498  * @dev StandardToken modified with pausable transfers.
499  **/
500 contract PausableToken is StandardToken, Pausable {
501 
502   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
503     return super.transfer(_to, _value);
504   }
505 
506   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
507     return super.transferFrom(_from, _to, _value);
508   }
509 
510   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
511     return super.approve(_spender, _value);
512   }
513 
514   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
515     return super.increaseApproval(_spender, _addedValue);
516   }
517 
518   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
519     return super.decreaseApproval(_spender, _subtractedValue);
520   }
521 }
522 
523 //end PausableToken.sol
524 // ----------------- 
525 //begin TimedCrowdsale.sol
526 
527 
528 /**
529  * @title TimedCrowdsale
530  * @dev Crowdsale accepting contributions only within a time frame.
531  */
532 contract TimedCrowdsale is Crowdsale {
533   using SafeMath for uint256;
534 
535   uint256 public openingTime;
536   uint256 public closingTime;
537 
538   /**
539    * @dev Reverts if not in crowdsale time range.
540    */
541   modifier onlyWhileOpen {
542     // solium-disable-next-line security/no-block-members
543     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
544     _;
545   }
546 
547   /**
548    * @dev Constructor, takes crowdsale opening and closing times.
549    * @param _openingTime Crowdsale opening time
550    * @param _closingTime Crowdsale closing time
551    */
552   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
553     // solium-disable-next-line security/no-block-members
554     require(_openingTime >= block.timestamp);
555     require(_closingTime >= _openingTime);
556 
557     openingTime = _openingTime;
558     closingTime = _closingTime;
559   }
560 
561   /**
562    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
563    * @return Whether crowdsale period has elapsed
564    */
565   function hasClosed() public view returns (bool) {
566     // solium-disable-next-line security/no-block-members
567     return block.timestamp > closingTime;
568   }
569 
570   /**
571    * @dev Extend parent behavior requiring to be within contributing period
572    * @param _beneficiary Token purchaser
573    * @param _weiAmount Amount of wei contributed
574    */
575   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
576     super._preValidatePurchase(_beneficiary, _weiAmount);
577   }
578 
579 }
580 
581 //end TimedCrowdsale.sol
582 // ----------------- 
583 //begin MintableToken.sol
584 
585 
586 /**
587  * @title Mintable token
588  * @dev Simple ERC20 Token example, with mintable token creation
589  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
590  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
591  */
592 contract MintableToken is StandardToken, Ownable {
593   event Mint(address indexed to, uint256 amount);
594   event MintFinished();
595 
596   bool public mintingFinished = false;
597 
598 
599   modifier canMint() {
600     require(!mintingFinished);
601     _;
602   }
603 
604   /**
605    * @dev Function to mint tokens
606    * @param _to The address that will receive the minted tokens.
607    * @param _amount The amount of tokens to mint.
608    * @return A boolean that indicates if the operation was successful.
609    */
610   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
611     totalSupply_ = totalSupply_.add(_amount);
612     balances[_to] = balances[_to].add(_amount);
613     emit Mint(_to, _amount);
614     emit Transfer(address(0), _to, _amount);
615     return true;
616   }
617 
618   /**
619    * @dev Function to stop minting new tokens.
620    * @return True if the operation was successful.
621    */
622   function finishMinting() onlyOwner canMint public returns (bool) {
623     mintingFinished = true;
624     emit MintFinished();
625     return true;
626   }
627 }
628 
629 //end MintableToken.sol
630 // ----------------- 
631 //begin MintedCrowdsale.sol
632 
633 
634 /**
635  * @title MintedCrowdsale
636  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
637  * Token ownership should be transferred to MintedCrowdsale for minting. 
638  */
639 contract MintedCrowdsale is Crowdsale {
640 
641   /**
642    * @dev Overrides delivery by minting tokens upon purchase.
643    * @param _beneficiary Token purchaser
644    * @param _tokenAmount Number of tokens to be minted
645    */
646   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
647     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
648   }
649 }
650 
651 //end MintedCrowdsale.sol
652 // ----------------- 
653 //begin FinalizableCrowdsale.sol
654 
655 
656 /**
657  * @title FinalizableCrowdsale
658  * @dev Extension of Crowdsale where an owner can do extra work
659  * after finishing.
660  */
661 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
662   using SafeMath for uint256;
663 
664   bool public isFinalized = false;
665 
666   event Finalized();
667 
668   /**
669    * @dev Must be called after crowdsale ends, to do some extra finalization
670    * work. Calls the contract's finalization function.
671    */
672   function finalize() onlyOwner public {
673     require(!isFinalized);
674     require(hasClosed());
675 
676     finalization();
677     emit Finalized();
678 
679     isFinalized = true;
680   }
681 
682   /**
683    * @dev Can be overridden to add finalization logic. The overriding function
684    * should call super.finalization() to ensure the chain of finalization is
685    * executed entirely.
686    */
687   function finalization() internal {
688   }
689 
690 }
691 
692 //end FinalizableCrowdsale.sol
693 // ----------------- 
694 //begin TimedPresaleCrowdsale.sol
695 
696 contract TimedPresaleCrowdsale is FinalizableCrowdsale {
697     using SafeMath for uint256;
698 
699     uint256 public presaleOpeningTime;
700     uint256 public presaleClosingTime;
701 
702     uint256 public bonusUnlockTime;
703 
704     event CrowdsaleTimesChanged(uint256 presaleOpeningTime, uint256 presaleClosingTime, uint256 openingTime, uint256 closingTime);
705 
706     /**
707      * @dev Reverts if not in crowdsale time range.
708      */
709     modifier onlyWhileOpen {
710         require(isPresale() || isSale());
711         _;
712     }
713 
714 
715     function TimedPresaleCrowdsale(uint256 _presaleOpeningTime, uint256 _presaleClosingTime, uint256 _openingTime, uint256 _closingTime) public
716     TimedCrowdsale(_openingTime, _closingTime) {
717 
718         changeTimes(_presaleOpeningTime, _presaleClosingTime, _openingTime, _closingTime);
719     }
720 
721     function changeTimes(uint256 _presaleOpeningTime, uint256 _presaleClosingTime, uint256 _openingTime, uint256 _closingTime) public onlyOwner {
722         require(!isFinalized);
723         require(_presaleOpeningTime >= now);
724         require(_presaleClosingTime >= _presaleOpeningTime);
725         require(_openingTime >= _presaleClosingTime);
726         require(_closingTime >= _openingTime);
727 
728         presaleOpeningTime = _presaleOpeningTime;
729         presaleClosingTime = _presaleClosingTime;
730         openingTime = _openingTime;
731         closingTime = _closingTime;
732 
733         emit CrowdsaleTimesChanged(_presaleOpeningTime, _presaleClosingTime, _openingTime, _closingTime);
734     }
735 
736     function isPresale() public view returns (bool) {
737         return now >= presaleOpeningTime && now <= presaleClosingTime;
738     }
739 
740     function isSale() public view returns (bool) {
741         return now >= openingTime && now <= closingTime;
742     }
743 }
744 
745 //end TimedPresaleCrowdsale.sol
746 // ----------------- 
747 //begin TokenCappedCrowdsale.sol
748 
749 
750 
751 contract TokenCappedCrowdsale is FinalizableCrowdsale {
752     using SafeMath for uint256;
753 
754     uint256 public cap;
755     uint256 public totalTokens;
756     uint256 public soldTokens = 0;
757     bool public capIncreased = false;
758 
759     event CapIncreased();
760 
761     function TokenCappedCrowdsale() public {
762 
763         cap = 400 * 1000 * 1000 * 1 ether;
764         totalTokens = 750 * 1000 * 1000 * 1 ether;
765     }
766 
767     function notExceedingSaleCap(uint256 amount) internal view returns (bool) {
768         return cap >= amount.add(soldTokens);
769     }
770 
771     /**
772     * Finalization logic. We take the expected sale cap
773     * ether and find the difference from the actual minted tokens.
774     * The remaining balance and the reserved amount for the team are minted
775     * to the team wallet.
776     */
777     function finalization() internal {
778         super.finalization();
779     }
780 }
781 
782 //end TokenCappedCrowdsale.sol
783 // ----------------- 
784 //begin OpiriaCrowdsale.sol
785 
786 contract OpiriaCrowdsale is TimedPresaleCrowdsale, MintedCrowdsale, TokenCappedCrowdsale {
787     using SafeMath for uint256;
788 
789     uint256 public presaleWeiLimit;
790 
791     address public tokensWallet;
792 
793     uint256 public totalBonus = 0;
794 
795     bool public hiddenCapTriggered;
796 
797     mapping(address => uint256) public bonusOf;
798 
799     // Crowdsale(uint256 _rate, address _wallet, ERC20 _token)
800     function OpiriaCrowdsale(ERC20 _token, uint16 _initialEtherUsdRate, address _wallet, address _tokensWallet,
801         uint256 _presaleOpeningTime, uint256 _presaleClosingTime, uint256 _openingTime, uint256 _closingTime
802     ) public
803     TimedPresaleCrowdsale(_presaleOpeningTime, _presaleClosingTime, _openingTime, _closingTime)
804     Crowdsale(_initialEtherUsdRate, _wallet, _token) {
805         setEtherUsdRate(_initialEtherUsdRate);
806         tokensWallet = _tokensWallet;
807     }
808 
809     //overridden
810     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
811         // 1 ether * etherUsdRate * 10
812 
813         return _weiAmount.mul(rate).mul(10);
814     }
815 
816     function _getBonusAmount(uint256 tokens) internal view returns (uint256) {
817         uint8 bonusPercent = _getBonusPercent();
818         uint256 bonusAmount = tokens.mul(bonusPercent).div(100);
819         return bonusAmount;
820     }
821 
822     function _getBonusPercent() internal view returns (uint8) {
823         if (isPresale()) {
824             return 20;
825         }
826         uint256 daysPassed = (now - openingTime) / 1 days;
827         uint8 calcPercent = 0;
828         if (daysPassed < 15) {
829             // daysPassed will be less than 15 so no worries about overflow here
830             calcPercent = (15 - uint8(daysPassed));
831         }
832         return calcPercent;
833     }
834 
835     //overridden
836     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
837         _saveBonus(_beneficiary, _tokenAmount);
838         _deliverTokens(_beneficiary, _tokenAmount);
839 
840         soldTokens = soldTokens.add(_tokenAmount);
841     }
842 
843     function _saveBonus(address _beneficiary, uint256 tokens) internal {
844         uint256 bonusAmount = _getBonusAmount(tokens);
845         if (bonusAmount > 0) {
846             totalBonus = totalBonus.add(bonusAmount);
847             soldTokens = soldTokens.add(bonusAmount);
848             bonusOf[_beneficiary] = bonusOf[_beneficiary].add(bonusAmount);
849         }
850     }
851 
852     //overridden
853     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
854         super._preValidatePurchase(_beneficiary, _weiAmount);
855         if (isPresale()) {
856             require(_weiAmount >= presaleWeiLimit);
857         }
858         else {
859             uint256 hoursFromOpening = (now - openingTime) / 1 hours;
860             if (hoursFromOpening < 4) {
861                 require(_weiAmount <= 1 ether);
862             }
863         }
864 
865         uint256 tokens = _getTokenAmount(_weiAmount);
866         uint256 bonusTokens = _getBonusAmount(tokens);
867         require(notExceedingSaleCap(tokens.add(bonusTokens)));
868     }
869 
870     function setEtherUsdRate(uint16 _etherUsdRate) public onlyOwner {
871         rate = _etherUsdRate;
872 
873         // the presaleWeiLimit must be $5000 in eth at the defined 'etherUsdRate'
874         // presaleWeiLimit = 1 ether / etherUsdRate * 5000
875         presaleWeiLimit = uint256(1 ether).mul(2500).div(rate);
876     }
877 
878     /**
879     * Send tokens by the owner directly to an address.
880     */
881     function sendTokensTo(uint256 amount, address to) public onlyOwner {
882         require(!isFinalized);
883         require(notExceedingSaleCap(amount));
884 
885         require(MintableToken(token).mint(to, amount));
886         soldTokens = soldTokens.add(amount);
887 
888         emit TokenPurchase(msg.sender, to, 0, amount);
889     }
890 
891     function unlockTokenTransfers() public onlyOwner {
892         require(isFinalized);
893         require(now > closingTime + 30 days);
894         require(PausableToken(token).paused());
895         bonusUnlockTime = now + 30 days;
896         PausableToken(token).unpause();
897     }
898 
899 
900     function distributeBonus(address[] addresses) public onlyOwner {
901         require(now > bonusUnlockTime);
902         for (uint i = 0; i < addresses.length; i++) {
903             if (bonusOf[addresses[i]] > 0) {
904                 uint256 bonusAmount = bonusOf[addresses[i]];
905                 _deliverTokens(addresses[i], bonusAmount);
906                 totalBonus = totalBonus.sub(bonusAmount);
907                 bonusOf[addresses[i]] = 0;
908             }
909         }
910         if(totalBonus == 0 && reservedTokensClaimStage == 3) {
911             MintableToken(token).finishMinting();
912         }
913     }
914 
915     function withdrawBonus() public {
916         require(now > bonusUnlockTime);
917         require(bonusOf[msg.sender] > 0);
918 
919         _deliverTokens(msg.sender, bonusOf[msg.sender]);
920         totalBonus = totalBonus.sub(bonusOf[msg.sender]);
921         bonusOf[msg.sender] = 0;
922 
923         if(totalBonus == 0 && reservedTokensClaimStage == 3) {
924             MintableToken(token).finishMinting();
925         }
926     }
927 
928 
929     function finalization() internal {
930         super.finalization();
931 
932         // mint 25% of total Tokens (13% for development, 5% for company/team, 6% for advisors, 2% bounty) into team wallet
933         uint256 toMintNow = totalTokens.mul(25).div(100);
934 
935         if (!capIncreased) {
936             // if the cap didn't increase (according to whitepaper) mint the 50MM tokens to the team wallet too
937             toMintNow = toMintNow.add(50 * 1000 * 1000);
938         }
939         _deliverTokens(tokensWallet, toMintNow);
940     }
941 
942     uint8 public reservedTokensClaimStage = 0;
943 
944     function claimReservedTokens() public onlyOwner {
945 
946         uint256 toMintNow = totalTokens.mul(5).div(100);
947         if (reservedTokensClaimStage == 0) {
948             require(now > closingTime + 6 * 30 days);
949             reservedTokensClaimStage = 1;
950             _deliverTokens(tokensWallet, toMintNow);
951         }
952         else if (reservedTokensClaimStage == 1) {
953             require(now > closingTime + 12 * 30 days);
954             reservedTokensClaimStage = 2;
955             _deliverTokens(tokensWallet, toMintNow);
956         }
957         else if (reservedTokensClaimStage == 2) {
958             require(now > closingTime + 24 * 30 days);
959             reservedTokensClaimStage = 3;
960             _deliverTokens(tokensWallet, toMintNow);
961             if (totalBonus == 0) {
962                 MintableToken(token).finishMinting();
963             }
964         }
965         else {
966             revert();
967         }
968     }
969 
970     function increaseCap() public onlyOwner {
971         require(!capIncreased);
972         require(!isFinalized);
973         require(now < openingTime + 5 days);
974 
975         capIncreased = true;
976         cap = cap.add(50 * 1000 * 1000);
977         emit CapIncreased();
978     }
979 
980     function triggerHiddenCap() public onlyOwner {
981         require(!hiddenCapTriggered);
982         require(now > presaleOpeningTime);
983         require(now < presaleClosingTime);
984 
985         presaleClosingTime = now;
986         openingTime = now + 24 hours;
987 
988         hiddenCapTriggered = true;
989     }
990 }
991 
992 //end OpiriaCrowdsale.sol