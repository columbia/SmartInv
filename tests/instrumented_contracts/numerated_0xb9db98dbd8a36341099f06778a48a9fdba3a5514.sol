1 //"Token Name","Symbol",Decimal,"WalletAddress","BufferAddress"
2 //1526053412,1526163431,Rate,"WalletAddress",Cap,"TokenAddress",Goal
3 pragma solidity ^0.4.23;
4 
5 //import "../../math/SafeMath.sol";
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16     if (a == 0) {
17       return 0;
18     }
19     c = a * b;
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
45   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 ///////////////////////////////////////////
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   uint256 totalSupply_;
75 
76   /**
77   * @dev total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[msg.sender]);
91 
92     // SafeMath.sub will throw if there is not enough balance.
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of.
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) public view returns (uint256 balance) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115   function allowance(address owner, address spender) public view returns (uint256);
116   function transferFrom(address from, address to, uint256 value) public returns (bool);
117   function approve(address spender, uint256 value) public returns (bool);
118   event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 /**
122  * @title Ownable
123  * @dev The Ownable contract has an owner address, and provides basic authorization control
124  * functions, this simplifies the implementation of "user permissions".
125  */
126 contract OwnableToken {
127   address public owner;
128 
129 
130   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
131 
132 
133   /**
134    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
135    * account.
136    */
137   function OwnableToken() public {
138     owner = msg.sender;
139   }
140 
141   /**
142    * @dev Throws if called by any account other than the owner.
143    */
144   modifier onlyOwner() {
145     require(msg.sender == owner);
146     _;
147   }
148 
149   /**
150    * @dev Allows the current owner to transfer control of the contract to a newOwner.
151    * @param newOwner The address to transfer ownership to.
152    */
153   function transferOwnership(address newOwner) public onlyOwner {
154     require(newOwner != address(0));
155     OwnershipTransferred(owner, newOwner);
156     owner = newOwner;
157   }
158 
159 }
160 
161 /**
162  * @title Burnable Token
163  * @dev Token that can be irreversibly burned (destroyed).
164  */
165 contract BurnableToken is BasicToken, OwnableToken {
166 
167   event Burn(address indexed burner, uint256 value);
168 
169   /**
170    * @dev Burns a specific amount of tokens.
171    * @param _value The amount of token to be burned.
172    */
173   function burn(uint256 _value) public onlyOwner {
174     require(_value <= balances[msg.sender]);
175     // no need to require value <= totalSupply, since that would imply the
176     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
177 
178     address burner = msg.sender;
179     balances[burner] = balances[burner].sub(_value);
180     totalSupply_ = totalSupply_.sub(_value);
181     Burn(burner, _value);
182     Transfer(burner, address(0), _value);
183   }
184 }
185 
186 /**
187  * @title Standard ERC20 token
188  *
189  * @dev Implementation of the basic standard token.
190  * @dev https://github.com/ethereum/EIPs/issues/20
191  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
192  */
193 contract StandardToken is ERC20, BasicToken {
194 
195   mapping (address => mapping (address => uint256)) internal allowed;
196 
197 
198   /**
199    * @dev Transfer tokens from one address to another
200    * @param _from address The address which you want to send tokens from
201    * @param _to address The address which you want to transfer to
202    * @param _value uint256 the amount of tokens to be transferred
203    */
204   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
205     require(_to != address(0));
206     require(_value <= balances[_from]);
207     require(_value <= allowed[_from][msg.sender]);
208 
209     balances[_from] = balances[_from].sub(_value);
210     balances[_to] = balances[_to].add(_value);
211     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212     Transfer(_from, _to, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218    *
219    * Beware that changing an allowance with this method brings the risk that someone may use both the old
220    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223    * @param _spender The address which will spend the funds.
224    * @param _value The amount of tokens to be spent.
225    */
226   function approve(address _spender, uint256 _value) public returns (bool) {
227     allowed[msg.sender][_spender] = _value;
228     Approval(msg.sender, _spender, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Function to check the amount of tokens that an owner allowed to a spender.
234    * @param _owner address The address which owns the funds.
235    * @param _spender address The address which will spend the funds.
236    * @return A uint256 specifying the amount of tokens still available for the spender.
237    */
238   function allowance(address _owner, address _spender) public view returns (uint256) {
239     return allowed[_owner][_spender];
240   }
241 
242   /**
243    * @dev Increase the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To increment
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _addedValue The amount of tokens to increase the allowance by.
251    */
252   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
253     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
254     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258   /**
259    * @dev Decrease the amount of tokens that an owner allowed to a spender.
260    *
261    * approve should be called when allowed[_spender] == 0. To decrement
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _subtractedValue The amount of tokens to decrease the allowance by.
267    */
268   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
269     uint oldValue = allowed[msg.sender][_spender];
270     if (_subtractedValue > oldValue) {
271       allowed[msg.sender][_spender] = 0;
272     } else {
273       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
274     }
275     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276     return true;
277   }
278 
279 }
280 
281 contract esToken is OwnableToken, BurnableToken, StandardToken {
282 	string public name;
283 	string public symbol;
284 	uint8 public decimals;
285 
286 	bool public paused = true;
287 	mapping(address => bool) public whitelist;
288 
289 	modifier whenNotPaused() {
290 		require(!paused || whitelist[msg.sender]);
291 		_;
292 	}
293 
294 	constructor(string _name,string _symbol,uint8 _decimals, address holder, address buffer) public {
295 		name = _name;
296 		symbol = _symbol;
297 		decimals = _decimals;
298 		Transfer(address(0), holder, balances[holder] = totalSupply_ = uint256(10)**(9 + decimals));
299 		addToWhitelist(holder);
300 		addToWhitelist(buffer);
301 	}
302 
303 	function unpause() public onlyOwner {
304 		paused = false;
305 	}
306 
307 	function pause() public onlyOwner {
308 		paused = true;
309 	}
310 
311 	function addToWhitelist(address addr) public onlyOwner {
312 		whitelist[addr] = true;
313 	}
314     
315 	function removeFromWhitelist(address addr) public onlyOwner {
316 		whitelist[addr] = false;
317 	}
318 
319 	function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
320 		return super.transfer(to, value);
321 	}
322 
323 	function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
324 		return super.transferFrom(from, to, value);
325 	}
326 
327 }
328 ///////////////////////////////////////////
329 
330 //import "../Crowdsale.sol";
331 /**
332  * @title Crowdsale
333  * @dev Crowdsale is a base contract for managing a token crowdsale,
334  * allowing investors to purchase tokens with ether. This contract implements
335  * such functionality in its most fundamental form and can be extended to provide additional
336  * functionality and/or custom behavior.
337  * The external interface represents the basic interface for purchasing tokens, and conform
338  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
339  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
340  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
341  * behavior.
342  */
343 contract Crowdsale {
344   using SafeMath for uint256;
345 
346   // The token being sold
347   ERC20 public token;
348 
349   // Address where funds are collected
350   address public wallet;
351 
352   // How many token units a buyer gets per wei
353   uint256 public rate;
354 
355   // Amount of wei raised
356   uint256 public weiRaised;
357 
358   /**
359    * Event for token purchase logging
360    * @param purchaser who paid for the tokens
361    * @param beneficiary who got the tokens
362    * @param value weis paid for purchase
363    * @param amount amount of tokens purchased
364    */
365   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
366 
367   /**
368    * @param _rate Number of token units a buyer gets per wei
369    * @param _wallet Address where collected funds will be forwarded to
370    */
371   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
372     require(_rate > 0);
373     require(_wallet != address(0));
374 
375     rate = _rate;
376     wallet = _wallet;
377     token = _token;
378   }
379 
380   // -----------------------------------------
381   // Crowdsale external interface
382   // -----------------------------------------
383 
384   /**
385    * @dev fallback function ***DO NOT OVERRIDE***
386    */
387   function () external payable {
388     buyTokens(msg.sender);
389   }
390 
391   /**
392    * @dev low level token purchase ***DO NOT OVERRIDE***
393    * @param _beneficiary Address performing the token purchase
394    */
395   function buyTokens(address _beneficiary) public payable {
396 
397     uint256 weiAmount = msg.value;
398     _preValidatePurchase(_beneficiary, weiAmount);
399 
400     // calculate token amount to be created
401     uint256 tokens = _getTokenAmount(weiAmount);
402 
403     // update state
404     weiRaised = weiRaised.add(weiAmount);
405 
406     _processPurchase(_beneficiary, tokens);
407     emit TokenPurchase(
408       msg.sender,
409       _beneficiary,
410       weiAmount,
411       tokens
412     );
413 
414     _updatePurchasingState(_beneficiary, weiAmount);
415 
416     _forwardFunds();
417     _postValidatePurchase(_beneficiary, weiAmount);
418   }
419 
420   // -----------------------------------------
421   // Internal interface (extensible)
422   // -----------------------------------------
423 
424   /**
425    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
426    * @param _beneficiary Address performing the token purchase
427    * @param _weiAmount Value in wei involved in the purchase
428    */
429   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
430     require(_beneficiary != address(0));
431     require(_weiAmount != 0);
432   }
433 
434   /**
435    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
436    * @param _beneficiary Address performing the token purchase
437    * @param _weiAmount Value in wei involved in the purchase
438    */
439   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
440     // optional override
441   }
442 
443   /**
444    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
445    * @param _beneficiary Address performing the token purchase
446    * @param _tokenAmount Number of tokens to be emitted
447    */
448   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
449     token.transfer(_beneficiary, _tokenAmount);
450   }
451 
452   /**
453    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
454    * @param _beneficiary Address receiving the tokens
455    * @param _tokenAmount Number of tokens to be purchased
456    */
457   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
458     _deliverTokens(_beneficiary, _tokenAmount);
459   }
460 
461   /**
462    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
463    * @param _beneficiary Address receiving the tokens
464    * @param _weiAmount Value in wei involved in the purchase
465    */
466   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
467     // optional override
468   }
469 
470   /**
471    * @dev Override to extend the way in which ether is converted to tokens.
472    * @param _weiAmount Value in wei to be converted into tokens
473    * @return Number of tokens that can be purchased with the specified _weiAmount
474    */
475   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
476     return _weiAmount.mul(rate);
477   }
478 
479   /**
480    * @dev Determines how ETH is stored/forwarded on purchases.
481    */
482   function _forwardFunds() internal {
483     wallet.transfer(msg.value);
484   }
485 }
486 
487 //import "/zepp/crowdsale/validation/CappedCrowdsale.sol";
488 /**
489  * @title CappedCrowdsale
490  * @dev Crowdsale with a limit for total contributions.
491  */
492 contract CappedCrowdsale is Crowdsale {
493   using SafeMath for uint256;
494 
495   uint256 public cap;
496 
497   /**
498    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
499    * @param _cap Max amount of wei to be contributed
500    */
501   constructor(uint256 _cap) public {
502     require(_cap > 0);
503     cap = _cap;
504   }
505 
506   /**
507    * @dev Checks whether the cap has been reached.
508    * @return Whether the cap was reached
509    */
510   function capReached() public view returns (bool) {
511     return weiRaised >= cap;
512   }
513 
514   /**
515    * @dev Extend parent behavior requiring purchase to respect the funding cap.
516    * @param _beneficiary Token purchaser
517    * @param _weiAmount Amount of wei contributed
518    */
519   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
520     super._preValidatePurchase(_beneficiary, _weiAmount);
521     require(weiRaised.add(_weiAmount) <= cap);
522   }
523 
524 }
525 
526 //import "../validation/TimedCrowdsale.sol";
527 /**
528  * @title TimedCrowdsale
529  * @dev Crowdsale accepting contributions only within a time frame.
530  */
531 contract TimedCrowdsale is Crowdsale {
532   using SafeMath for uint256;
533 
534   uint256 public openingTime;
535   uint256 public closingTime;
536 
537   /**
538    * @dev Reverts if not in crowdsale time range.
539    */
540   modifier onlyWhileOpen {
541     // solium-disable-next-line security/no-block-members
542     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
543     _;
544   }
545 
546   /**
547    * @dev Constructor, takes crowdsale opening and closing times.
548    * @param _openingTime Crowdsale opening time
549    * @param _closingTime Crowdsale closing time
550    */
551   constructor(uint256 _openingTime, uint256 _closingTime) public {
552     // solium-disable-next-line security/no-block-members
553     //require(_openingTime >= block.timestamp);
554     //require(_closingTime >= _openingTime);
555 
556     openingTime = _openingTime;
557     closingTime = _closingTime;
558   }
559 
560   /**
561    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
562    * @return Whether crowdsale period has elapsed
563    */
564   function hasClosed() public view returns (bool) {
565     // solium-disable-next-line security/no-block-members
566     return block.timestamp > closingTime;
567   }
568 
569   /**
570    * @dev Extend parent behavior requiring to be within contributing period
571    * @param _beneficiary Token purchaser
572    * @param _weiAmount Amount of wei contributed
573    */
574   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
575     super._preValidatePurchase(_beneficiary, _weiAmount);
576   }
577 
578 }
579 
580 //import "../../../ownership/Ownable.sol";
581 /**
582  * @title Ownable
583  * @dev The Ownable contract has an owner address, and provides basic authorization control
584  * functions, this simplifies the implementation of "user permissions".
585  */
586 contract Ownable {
587   address public owner;
588 
589 
590   event OwnershipRenounced(address indexed previousOwner);
591   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
592 
593 
594   /**
595    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
596    * account.
597    */
598   constructor() public {
599     owner = msg.sender;
600   }
601 
602   /**
603    * @dev Throws if called by any account other than the owner.
604    */
605   modifier onlyOwner() {
606     require(msg.sender == owner);
607     _;
608   }
609 
610   /**
611    * @dev Allows the current owner to transfer control of the contract to a newOwner.
612    * @param newOwner The address to transfer ownership to.
613    */
614   function transferOwnership(address newOwner) public onlyOwner {
615     require(newOwner != address(0));
616     emit OwnershipTransferred(owner, newOwner);
617     owner = newOwner;
618   }
619 
620   /**
621    * @dev Allows the current owner to relinquish control of the contract.
622    */
623   function renounceOwnership() public onlyOwner {
624     emit OwnershipRenounced(owner);
625     owner = address(0);
626   }
627 }
628 
629 //import "./FinalizableCrowdsale.sol";
630 /**
631  * @title FinalizableCrowdsale
632  * @dev Extension of Crowdsale where an owner can do extra work
633  * after finishing.
634  */
635 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
636   using SafeMath for uint256;
637 
638   bool public isFinalized = false;
639 
640   event Finalized();
641 
642   /**
643    * @dev Must be called after crowdsale ends, to do some extra finalization
644    * work. Calls the contract's finalization function.
645    */
646   function finalize() onlyOwner public {
647     require(!isFinalized);
648     require(hasClosed());
649 
650     finalization();
651     emit Finalized();
652 
653     isFinalized = true;
654   }
655 
656   /**
657    * @dev Can be overridden to add finalization logic. The overriding function
658    * should call super.finalization() to ensure the chain of finalization is
659    * executed entirely.
660    */
661   function finalization() internal {
662   }
663 
664 }
665 
666 //import "./utils/RefundVault.sol";
667 /**
668  * @title RefundVault
669  * @dev This contract is used for storing funds while a crowdsale
670  * is in progress. Supports refunding the money if crowdsale fails,
671  * and forwarding it if crowdsale is successful.
672  */
673 contract RefundVault is Ownable {
674   using SafeMath for uint256;
675 
676   enum State { Active, Refunding, Closed }
677 
678   mapping (address => uint256) public deposited;
679   address public wallet;
680   State public state;
681 
682   event Closed();
683   event RefundsEnabled();
684   event Refunded(address indexed beneficiary, uint256 weiAmount);
685 
686   /**
687    * @param _wallet Vault address
688    */
689   constructor(address _wallet) public {
690     require(_wallet != address(0));
691     wallet = _wallet;
692     state = State.Active;
693   }
694 
695   /**
696    * @param investor Investor address
697    */
698   function deposit(address investor) onlyOwner public payable {
699     require(state == State.Active);
700     deposited[investor] = deposited[investor].add(msg.value);
701   }
702 
703   function close() onlyOwner public {
704     require(state == State.Active);
705     state = State.Closed;
706     emit Closed();
707     wallet.transfer(address(this).balance);
708   }
709 
710   function enableRefunds() onlyOwner public {
711     require(state == State.Active);
712     state = State.Refunding;
713     emit RefundsEnabled();
714   }
715 
716   /**
717    * @param investor Investor address
718    */
719   function refund(address investor) public {
720     require(state == State.Refunding);
721     uint256 depositedValue = deposited[investor];
722     deposited[investor] = 0;
723     investor.transfer(depositedValue);
724     emit Refunded(investor, depositedValue);
725   }
726 }
727 
728 //import "/zepp/crowdsale/distribution/RefundableCrowdsale.sol";
729 /**
730  * @title RefundableCrowdsale
731  * @dev Extension of Crowdsale contract that adds a funding goal, and
732  * the possibility of users getting a refund if goal is not met.
733  * Uses a RefundVault as the crowdsale's vault.
734  */
735 contract RefundableCrowdsale is FinalizableCrowdsale {
736   using SafeMath for uint256;
737 
738   // minimum amount of funds to be raised in weis
739   uint256 public goal;
740 
741   // refund vault used to hold funds while crowdsale is running
742   RefundVault public vault;
743 
744   /**
745    * @dev Constructor, creates RefundVault.
746    * @param _goal Funding goal
747    */
748   constructor(uint256 _goal) public {
749     require(_goal > 0);
750     vault = new RefundVault(wallet);
751     goal = _goal;
752   }
753 
754   /**
755    * @dev Investors can claim refunds here if crowdsale is unsuccessful
756    */
757   function claimRefund() public {
758     require(isFinalized);
759     require(!goalReached());
760 
761     vault.refund(msg.sender);
762   }
763 
764   /**
765    * @dev Checks whether funding goal was reached.
766    * @return Whether funding goal was reached
767    */
768   function goalReached() public view returns (bool) {
769     return weiRaised >= goal;
770   }
771 
772   /**
773    * @dev vault finalization task, called when owner calls finalize()
774    */
775   function finalization() internal {
776     if (goalReached()) {
777       vault.close();
778     } else {
779       vault.enableRefunds();
780     }
781 
782     super.finalization();
783   }
784 
785   /**
786    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
787    */
788   function _forwardFunds() internal {
789     vault.deposit.value(msg.value)(msg.sender);
790   }
791 
792 }
793 
794 /**
795  * @title esCrowdsale
796  * @dev This is an example of a fully fledged crowdsale.
797  * The way to add new features to a base crowdsale is by multiple inheritance.
798  * In this example we are providing following extensions:
799  * CappedCrowdsale - sets a max boundary for raised funds
800  * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
801  *
802  * After adding multiple features it's good practice to run integration tests
803  * to ensure that subcontracts works together as intended.
804  */
805 contract esCrowdsale is CappedCrowdsale, RefundableCrowdsale {
806 
807   constructor(
808     uint256 _openingTime,
809     uint256 _closingTime,
810     uint256 _rate,
811     address _wallet,
812     uint256 _cap,
813     ERC20 _token,
814     uint256 _goal
815   )
816     public
817     Crowdsale(_rate, _wallet, _token)
818     CappedCrowdsale(_cap)
819     TimedCrowdsale(_openingTime, _closingTime)
820     RefundableCrowdsale(_goal)
821   {
822     //As goal needs to be met for a successful crowdsale
823     //the value needs to less or equal than a cap which is limit for accepted funds
824     require(_goal <= _cap);
825   }
826 }