1 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.23;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
19 
20 pragma solidity ^0.4.23;
21 
22 
23 
24 /**
25  * @title ERC20 interface
26  * @dev see https://github.com/ethereum/EIPs/issues/20
27  */
28 contract ERC20 is ERC20Basic {
29   function allowance(address owner, address spender)
30     public view returns (uint256);
31 
32   function transferFrom(address from, address to, uint256 value)
33     public returns (bool);
34 
35   function approve(address spender, uint256 value) public returns (bool);
36   event Approval(
37     address indexed owner,
38     address indexed spender,
39     uint256 value
40   );
41 }
42 
43 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
44 
45 pragma solidity ^0.4.23;
46 
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that throw on error
51  */
52 library SafeMath {
53 
54   /**
55   * @dev Multiplies two numbers, throws on overflow.
56   */
57   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
58     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
59     // benefit is lost if 'b' is also tested.
60     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
61     if (a == 0) {
62       return 0;
63     }
64 
65     c = a * b;
66     assert(c / a == b);
67     return c;
68   }
69 
70   /**
71   * @dev Integer division of two numbers, truncating the quotient.
72   */
73   function div(uint256 a, uint256 b) internal pure returns (uint256) {
74     // assert(b > 0); // Solidity automatically throws when dividing by 0
75     // uint256 c = a / b;
76     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77     return a / b;
78   }
79 
80   /**
81   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
82   */
83   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84     assert(b <= a);
85     return a - b;
86   }
87 
88   /**
89   * @dev Adds two numbers, throws on overflow.
90   */
91   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
92     c = a + b;
93     assert(c >= a);
94     return c;
95   }
96 }
97 
98 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
99 
100 pragma solidity ^0.4.24;
101 
102 
103 
104 
105 /**
106  * @title Crowdsale
107  * @dev Crowdsale is a base contract for managing a token crowdsale,
108  * allowing investors to purchase tokens with ether. This contract implements
109  * such functionality in its most fundamental form and can be extended to provide additional
110  * functionality and/or custom behavior.
111  * The external interface represents the basic interface for purchasing tokens, and conform
112  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
113  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
114  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
115  * behavior.
116  */
117 contract Crowdsale {
118   using SafeMath for uint256;
119 
120   // The token being sold
121   ERC20 public token;
122 
123   // Address where funds are collected
124   address public wallet;
125 
126   // How many token units a buyer gets per wei.
127   // The rate is the conversion between wei and the smallest and indivisible token unit.
128   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
129   // 1 wei will give you 1 unit, or 0.001 TOK.
130   uint256 public rate;
131 
132   // Amount of wei raised
133   uint256 public weiRaised;
134 
135   /**
136    * Event for token purchase logging
137    * @param purchaser who paid for the tokens
138    * @param beneficiary who got the tokens
139    * @param value weis paid for purchase
140    * @param amount amount of tokens purchased
141    */
142   event TokenPurchase(
143     address indexed purchaser,
144     address indexed beneficiary,
145     uint256 value,
146     uint256 amount
147   );
148 
149   /**
150    * @param _rate Number of token units a buyer gets per wei
151    * @param _wallet Address where collected funds will be forwarded to
152    * @param _token Address of the token being sold
153    */
154   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
155     require(_rate > 0);
156     require(_wallet != address(0));
157     require(_token != address(0));
158 
159     rate = _rate;
160     wallet = _wallet;
161     token = _token;
162   }
163 
164   // -----------------------------------------
165   // Crowdsale external interface
166   // -----------------------------------------
167 
168   /**
169    * @dev fallback function ***DO NOT OVERRIDE***
170    */
171   function () external payable {
172     buyTokens(msg.sender);
173   }
174 
175   /**
176    * @dev low level token purchase ***DO NOT OVERRIDE***
177    * @param _beneficiary Address performing the token purchase
178    */
179   function buyTokens(address _beneficiary) public payable {
180 
181     uint256 weiAmount = msg.value;
182     _preValidatePurchase(_beneficiary, weiAmount);
183 
184     // calculate token amount to be created
185     uint256 tokens = _getTokenAmount(weiAmount);
186 
187     // update state
188     weiRaised = weiRaised.add(weiAmount);
189 
190     _processPurchase(_beneficiary, tokens);
191     emit TokenPurchase(
192       msg.sender,
193       _beneficiary,
194       weiAmount,
195       tokens
196     );
197 
198     _updatePurchasingState(_beneficiary, weiAmount);
199 
200     _forwardFunds();
201     _postValidatePurchase(_beneficiary, weiAmount);
202   }
203 
204   // -----------------------------------------
205   // Internal interface (extensible)
206   // -----------------------------------------
207 
208   /**
209    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
210    * @param _beneficiary Address performing the token purchase
211    * @param _weiAmount Value in wei involved in the purchase
212    */
213   function _preValidatePurchase(
214     address _beneficiary,
215     uint256 _weiAmount
216   )
217     internal
218   {
219     require(_beneficiary != address(0));
220     require(_weiAmount != 0);
221   }
222 
223   /**
224    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
225    * @param _beneficiary Address performing the token purchase
226    * @param _weiAmount Value in wei involved in the purchase
227    */
228   function _postValidatePurchase(
229     address _beneficiary,
230     uint256 _weiAmount
231   )
232     internal
233   {
234     // optional override
235   }
236 
237   /**
238    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
239    * @param _beneficiary Address performing the token purchase
240    * @param _tokenAmount Number of tokens to be emitted
241    */
242   function _deliverTokens(
243     address _beneficiary,
244     uint256 _tokenAmount
245   )
246     internal
247   {
248     token.transfer(_beneficiary, _tokenAmount);
249   }
250 
251   /**
252    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
253    * @param _beneficiary Address receiving the tokens
254    * @param _tokenAmount Number of tokens to be purchased
255    */
256   function _processPurchase(
257     address _beneficiary,
258     uint256 _tokenAmount
259   )
260     internal
261   {
262     _deliverTokens(_beneficiary, _tokenAmount);
263   }
264 
265   /**
266    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
267    * @param _beneficiary Address receiving the tokens
268    * @param _weiAmount Value in wei involved in the purchase
269    */
270   function _updatePurchasingState(
271     address _beneficiary,
272     uint256 _weiAmount
273   )
274     internal
275   {
276     // optional override
277   }
278 
279   /**
280    * @dev Override to extend the way in which ether is converted to tokens.
281    * @param _weiAmount Value in wei to be converted into tokens
282    * @return Number of tokens that can be purchased with the specified _weiAmount
283    */
284   function _getTokenAmount(uint256 _weiAmount)
285     internal view returns (uint256)
286   {
287     return _weiAmount.mul(rate);
288   }
289 
290   /**
291    * @dev Determines how ETH is stored/forwarded on purchases.
292    */
293   function _forwardFunds() internal {
294     wallet.transfer(msg.value);
295   }
296 }
297 
298 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
299 
300 pragma solidity ^0.4.24;
301 
302 
303 
304 
305 
306 
307 /**
308  * @title TimedCrowdsale
309  * @dev Crowdsale accepting contributions only within a time frame.
310  */
311 contract TimedCrowdsale is Crowdsale {
312   using SafeMath for uint256;
313 
314   uint256 public openingTime;
315   uint256 public closingTime;
316 
317   /**
318    * @dev Reverts if not in crowdsale time range.
319    */
320   modifier onlyWhileOpen {
321     // solium-disable-next-line security/no-block-members
322     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
323     _;
324   }
325 
326   /**
327    * @dev Constructor, takes crowdsale opening and closing times.
328    * @param _openingTime Crowdsale opening time
329    * @param _closingTime Crowdsale closing time
330    */
331   constructor(uint256 _openingTime, uint256 _closingTime) public {
332     // solium-disable-next-line security/no-block-members
333     require(_openingTime >= block.timestamp);
334     require(_closingTime >= _openingTime);
335 
336     openingTime = _openingTime;
337     closingTime = _closingTime;
338   }
339 
340   /**
341    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
342    * @return Whether crowdsale period has elapsed
343    */
344   function hasClosed() public view returns (bool) {
345     // solium-disable-next-line security/no-block-members
346     return block.timestamp > closingTime;
347   }
348 
349   /**
350    * @dev Extend parent behavior requiring to be within contributing period
351    * @param _beneficiary Token purchaser
352    * @param _weiAmount Amount of wei contributed
353    */
354   function _preValidatePurchase(
355     address _beneficiary,
356     uint256 _weiAmount
357   )
358     internal
359     onlyWhileOpen
360   {
361     super._preValidatePurchase(_beneficiary, _weiAmount);
362   }
363 
364 }
365 
366 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
367 
368 pragma solidity ^0.4.23;
369 
370 
371 
372 
373 /**
374  * @title CappedCrowdsale
375  * @dev Crowdsale with a limit for total contributions.
376  */
377 contract CappedCrowdsale is Crowdsale {
378   using SafeMath for uint256;
379 
380   uint256 public cap;
381 
382   /**
383    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
384    * @param _cap Max amount of wei to be contributed
385    */
386   constructor(uint256 _cap) public {
387     require(_cap > 0);
388     cap = _cap;
389   }
390 
391   /**
392    * @dev Checks whether the cap has been reached.
393    * @return Whether the cap was reached
394    */
395   function capReached() public view returns (bool) {
396     return weiRaised >= cap;
397   }
398 
399   /**
400    * @dev Extend parent behavior requiring purchase to respect the funding cap.
401    * @param _beneficiary Token purchaser
402    * @param _weiAmount Amount of wei contributed
403    */
404   function _preValidatePurchase(
405     address _beneficiary,
406     uint256 _weiAmount
407   )
408     internal
409   {
410     super._preValidatePurchase(_beneficiary, _weiAmount);
411     require(weiRaised.add(_weiAmount) <= cap);
412   }
413 
414 }
415 
416 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
417 
418 pragma solidity ^0.4.24;
419 
420 
421 
422 
423 
424 /**
425  * @title Basic token
426  * @dev Basic version of StandardToken, with no allowances.
427  */
428 contract BasicToken is ERC20Basic {
429   using SafeMath for uint256;
430 
431   mapping(address => uint256) balances;
432 
433   uint256 totalSupply_;
434 
435   /**
436   * @dev total number of tokens in existence
437   */
438   function totalSupply() public view returns (uint256) {
439     return totalSupply_;
440   }
441 
442   /**
443   * @dev transfer token for a specified address
444   * @param _to The address to transfer to.
445   * @param _value The amount to be transferred.
446   */
447   function transfer(address _to, uint256 _value) public returns (bool) {
448     require(_to != address(0));
449     require(_value <= balances[msg.sender]);
450 
451     balances[msg.sender] = balances[msg.sender].sub(_value);
452     balances[_to] = balances[_to].add(_value);
453     emit Transfer(msg.sender, _to, _value);
454     return true;
455   }
456 
457   /**
458   * @dev Gets the balance of the specified address.
459   * @param _owner The address to query the the balance of.
460   * @return An uint256 representing the amount owned by the passed address.
461   */
462   function balanceOf(address _owner) public view returns (uint256) {
463     return balances[_owner];
464   }
465 
466 }
467 
468 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
469 
470 pragma solidity ^0.4.24;
471 
472 
473 
474 
475 
476 /**
477  * @title Standard ERC20 token
478  *
479  * @dev Implementation of the basic standard token.
480  * @dev https://github.com/ethereum/EIPs/issues/20
481  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
482  */
483 contract StandardToken is ERC20, BasicToken {
484 
485   mapping (address => mapping (address => uint256)) internal allowed;
486 
487 
488   /**
489    * @dev Transfer tokens from one address to another
490    * @param _from address The address which you want to send tokens from
491    * @param _to address The address which you want to transfer to
492    * @param _value uint256 the amount of tokens to be transferred
493    */
494   function transferFrom(
495     address _from,
496     address _to,
497     uint256 _value
498   )
499     public
500     returns (bool)
501   {
502     require(_to != address(0));
503     require(_value <= balances[_from]);
504     require(_value <= allowed[_from][msg.sender]);
505 
506     balances[_from] = balances[_from].sub(_value);
507     balances[_to] = balances[_to].add(_value);
508     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
509     emit Transfer(_from, _to, _value);
510     return true;
511   }
512 
513   /**
514    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
515    *
516    * Beware that changing an allowance with this method brings the risk that someone may use both the old
517    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
518    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
519    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
520    * @param _spender The address which will spend the funds.
521    * @param _value The amount of tokens to be spent.
522    */
523   function approve(address _spender, uint256 _value) public returns (bool) {
524     allowed[msg.sender][_spender] = _value;
525     emit Approval(msg.sender, _spender, _value);
526     return true;
527   }
528 
529   /**
530    * @dev Function to check the amount of tokens that an owner allowed to a spender.
531    * @param _owner address The address which owns the funds.
532    * @param _spender address The address which will spend the funds.
533    * @return A uint256 specifying the amount of tokens still available for the spender.
534    */
535   function allowance(
536     address _owner,
537     address _spender
538    )
539     public
540     view
541     returns (uint256)
542   {
543     return allowed[_owner][_spender];
544   }
545 
546   /**
547    * @dev Increase the amount of tokens that an owner allowed to a spender.
548    *
549    * approve should be called when allowed[_spender] == 0. To increment
550    * allowed value is better to use this function to avoid 2 calls (and wait until
551    * the first transaction is mined)
552    * From MonolithDAO Token.sol
553    * @param _spender The address which will spend the funds.
554    * @param _addedValue The amount of tokens to increase the allowance by.
555    */
556   function increaseApproval(
557     address _spender,
558     uint _addedValue
559   )
560     public
561     returns (bool)
562   {
563     allowed[msg.sender][_spender] = (
564       allowed[msg.sender][_spender].add(_addedValue));
565     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
566     return true;
567   }
568 
569   /**
570    * @dev Decrease the amount of tokens that an owner allowed to a spender.
571    *
572    * approve should be called when allowed[_spender] == 0. To decrement
573    * allowed value is better to use this function to avoid 2 calls (and wait until
574    * the first transaction is mined)
575    * From MonolithDAO Token.sol
576    * @param _spender The address which will spend the funds.
577    * @param _subtractedValue The amount of tokens to decrease the allowance by.
578    */
579   function decreaseApproval(
580     address _spender,
581     uint _subtractedValue
582   )
583     public
584     returns (bool)
585   {
586     uint oldValue = allowed[msg.sender][_spender];
587     if (_subtractedValue > oldValue) {
588       allowed[msg.sender][_spender] = 0;
589     } else {
590       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
591     }
592     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
593     return true;
594   }
595 
596 }
597 
598 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
599 
600 pragma solidity ^0.4.24;
601 
602 
603 /**
604  * @title Ownable
605  * @dev The Ownable contract has an owner address, and provides basic authorization control
606  * functions, this simplifies the implementation of "user permissions".
607  */
608 contract Ownable {
609   address public owner;
610 
611 
612   event OwnershipRenounced(address indexed previousOwner);
613   event OwnershipTransferred(
614     address indexed previousOwner,
615     address indexed newOwner
616   );
617 
618 
619   /**
620    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
621    * account.
622    */
623   constructor() public {
624     owner = msg.sender;
625   }
626 
627   /**
628    * @dev Throws if called by any account other than the owner.
629    */
630   modifier onlyOwner() {
631     require(msg.sender == owner);
632     _;
633   }
634 
635   /**
636    * @dev Allows the current owner to relinquish control of the contract.
637    */
638   function renounceOwnership() public onlyOwner {
639     emit OwnershipRenounced(owner);
640     owner = address(0);
641   }
642 
643   /**
644    * @dev Allows the current owner to transfer control of the contract to a newOwner.
645    * @param _newOwner The address to transfer ownership to.
646    */
647   function transferOwnership(address _newOwner) public onlyOwner {
648     _transferOwnership(_newOwner);
649   }
650 
651   /**
652    * @dev Transfers control of the contract to a newOwner.
653    * @param _newOwner The address to transfer ownership to.
654    */
655   function _transferOwnership(address _newOwner) internal {
656     require(_newOwner != address(0));
657     emit OwnershipTransferred(owner, _newOwner);
658     owner = _newOwner;
659   }
660 }
661 
662 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
663 
664 pragma solidity ^0.4.24;
665 
666 
667 
668 
669 
670 /**
671  * @title Mintable token
672  * @dev Simple ERC20 Token example, with mintable token creation
673  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
674  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
675  */
676 contract MintableToken is StandardToken, Ownable {
677   event Mint(address indexed to, uint256 amount);
678   event MintFinished();
679 
680   bool public mintingFinished = false;
681 
682 
683   modifier canMint() {
684     require(!mintingFinished);
685     _;
686   }
687 
688   modifier hasMintPermission() {
689     require(msg.sender == owner);
690     _;
691   }
692 
693   /**
694    * @dev Function to mint tokens
695    * @param _to The address that will receive the minted tokens.
696    * @param _amount The amount of tokens to mint.
697    * @return A boolean that indicates if the operation was successful.
698    */
699   function mint(
700     address _to,
701     uint256 _amount
702   )
703     hasMintPermission
704     canMint
705     public
706     returns (bool)
707   {
708     totalSupply_ = totalSupply_.add(_amount);
709     balances[_to] = balances[_to].add(_amount);
710     emit Mint(_to, _amount);
711     emit Transfer(address(0), _to, _amount);
712     return true;
713   }
714 
715   /**
716    * @dev Function to stop minting new tokens.
717    * @return True if the operation was successful.
718    */
719   function finishMinting() onlyOwner canMint public returns (bool) {
720     mintingFinished = true;
721     emit MintFinished();
722     return true;
723   }
724 }
725 
726 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
727 
728 pragma solidity ^0.4.24;
729 
730 
731 
732 
733 /**
734  * @title MintedCrowdsale
735  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
736  * Token ownership should be transferred to MintedCrowdsale for minting.
737  */
738 contract MintedCrowdsale is Crowdsale {
739 
740   /**
741    * @dev Overrides delivery by minting tokens upon purchase.
742    * @param _beneficiary Token purchaser
743    * @param _tokenAmount Number of tokens to be minted
744    */
745   function _deliverTokens(
746     address _beneficiary,
747     uint256 _tokenAmount
748   )
749     internal
750   {
751     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
752   }
753 }
754 
755 // File: contracts/FairInitialTokenOffering.sol
756 
757 pragma solidity 0.4.24;
758 
759 
760 
761 
762 
763 //import "node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
764 
765 
766 interface MintableERC20 {
767     function finishMinting() public returns (bool);
768 }
769 
770 
771 contract FairInitialTokenOffering is Crowdsale, TimedCrowdsale, CappedCrowdsale, MintedCrowdsale {
772     bool public isFinalized = false;
773 
774     event Finalized();
775     constructor
776     (
777         uint256 _rate,
778         address _wallet,
779         ERC20 _token,
780         uint256 _openingTime,
781         uint256 _closingTime,
782         uint256 _cap
783     )
784         Crowdsale(_rate, _wallet, _token)
785         TimedCrowdsale(_openingTime, _closingTime)
786         CappedCrowdsale(_cap)
787         public
788     {
789 
790     }
791     function finalize() public {
792       require(!isFinalized);
793       require(hasClosed() || capReached());
794 
795       finalization();
796       emit Finalized();
797 
798       isFinalized = true;
799     }
800 
801 
802     function finalization() internal {
803         MintableERC20 mintableToken = MintableERC20(token);
804         mintableToken.finishMinting();
805     }
806 }