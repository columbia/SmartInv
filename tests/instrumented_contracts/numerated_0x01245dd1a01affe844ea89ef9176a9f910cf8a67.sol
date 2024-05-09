1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 ///////////////////////////////////////////
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   uint256 totalSupply_;
72 
73   /**
74   * @dev total number of tokens in existence
75   */
76   function totalSupply() public view returns (uint256) {
77     return totalSupply_;
78   }
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88 
89     // SafeMath.sub will throw if there is not enough balance.
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256 balance) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) public view returns (uint256);
113   function transferFrom(address from, address to, uint256 value) public returns (bool);
114   function approve(address spender, uint256 value) public returns (bool);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 /**
119  * @title Ownable
120  * @dev The Ownable contract has an owner address, and provides basic authorization control
121  * functions, this simplifies the implementation of "user permissions".
122  */
123 contract OwnableToken {
124   address public owner;
125 
126 
127   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129 
130   /**
131    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
132    * account.
133    */
134   function OwnableToken() public {
135     owner = msg.sender;
136   }
137 
138   /**
139    * @dev Throws if called by any account other than the owner.
140    */
141   modifier onlyOwner() {
142     require(msg.sender == owner);
143     _;
144   }
145 
146   /**
147    * @dev Allows the current owner to transfer control of the contract to a newOwner.
148    * @param newOwner The address to transfer ownership to.
149    */
150   function transferOwnership(address newOwner) public onlyOwner {
151     require(newOwner != address(0));
152     OwnershipTransferred(owner, newOwner);
153     owner = newOwner;
154   }
155 
156 }
157 
158 /**
159  * @title Burnable Token
160  * @dev Token that can be irreversibly burned (destroyed).
161  */
162 contract BurnableToken is BasicToken, OwnableToken {
163 
164   event Burn(address indexed burner, uint256 value);
165 
166   /**
167    * @dev Burns a specific amount of tokens.
168    * @param _value The amount of token to be burned.
169    */
170   function burn(uint256 _value) public onlyOwner {
171     require(_value <= balances[msg.sender]);
172     // no need to require value <= totalSupply, since that would imply the
173     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
174 
175     address burner = msg.sender;
176     balances[burner] = balances[burner].sub(_value);
177     totalSupply_ = totalSupply_.sub(_value);
178     Burn(burner, _value);
179     Transfer(burner, address(0), _value);
180   }
181 }
182 
183 /**
184  * @title Standard ERC20 token
185  *
186  * @dev Implementation of the basic standard token.
187  * @dev https://github.com/ethereum/EIPs/issues/20
188  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
189  */
190 contract StandardToken is ERC20, BasicToken {
191 
192   mapping (address => mapping (address => uint256)) internal allowed;
193 
194 
195   /**
196    * @dev Transfer tokens from one address to another
197    * @param _from address The address which you want to send tokens from
198    * @param _to address The address which you want to transfer to
199    * @param _value uint256 the amount of tokens to be transferred
200    */
201   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
202     require(_to != address(0));
203     require(_value <= balances[_from]);
204     require(_value <= allowed[_from][msg.sender]);
205 
206     balances[_from] = balances[_from].sub(_value);
207     balances[_to] = balances[_to].add(_value);
208     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
209     Transfer(_from, _to, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
215    *
216    * Beware that changing an allowance with this method brings the risk that someone may use both the old
217    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
218    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
219    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220    * @param _spender The address which will spend the funds.
221    * @param _value The amount of tokens to be spent.
222    */
223   function approve(address _spender, uint256 _value) public returns (bool) {
224     allowed[msg.sender][_spender] = _value;
225     Approval(msg.sender, _spender, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Function to check the amount of tokens that an owner allowed to a spender.
231    * @param _owner address The address which owns the funds.
232    * @param _spender address The address which will spend the funds.
233    * @return A uint256 specifying the amount of tokens still available for the spender.
234    */
235   function allowance(address _owner, address _spender) public view returns (uint256) {
236     return allowed[_owner][_spender];
237   }
238 
239   /**
240    * @dev Increase the amount of tokens that an owner allowed to a spender.
241    *
242    * approve should be called when allowed[_spender] == 0. To increment
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param _spender The address which will spend the funds.
247    * @param _addedValue The amount of tokens to increase the allowance by.
248    */
249   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
250     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
251     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255   /**
256    * @dev Decrease the amount of tokens that an owner allowed to a spender.
257    *
258    * approve should be called when allowed[_spender] == 0. To decrement
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param _spender The address which will spend the funds.
263    * @param _subtractedValue The amount of tokens to decrease the allowance by.
264    */
265   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
266     uint oldValue = allowed[msg.sender][_spender];
267     if (_subtractedValue > oldValue) {
268       allowed[msg.sender][_spender] = 0;
269     } else {
270       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
271     }
272     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273     return true;
274   }
275 
276 }
277 
278 contract esToken is OwnableToken, BurnableToken, StandardToken {
279 	string public name;
280 	string public symbol;
281 	uint8 public decimals;
282 
283 	bool public paused = true;
284 	mapping(address => bool) public whitelist;
285 
286 	modifier whenNotPaused() {
287 		require(!paused || whitelist[msg.sender]);
288 		_;
289 	}
290 
291 	constructor(string _name,string _symbol,uint8 _decimals, address holder, address buffer) public {
292 		name = _name;
293 		symbol = _symbol;
294 		decimals = _decimals;
295 		Transfer(address(0), holder, balances[holder] = totalSupply_ = uint256(10)**(9 + decimals));
296 		addToWhitelist(holder);
297 		addToWhitelist(buffer);
298 	}
299 
300 	function unpause() public onlyOwner {
301 		paused = false;
302 	}
303 
304 	function pause() public onlyOwner {
305 		paused = true;
306 	}
307 
308 	function addToWhitelist(address addr) public onlyOwner {
309 		whitelist[addr] = true;
310 	}
311     
312 	function removeFromWhitelist(address addr) public onlyOwner {
313 		whitelist[addr] = false;
314 	}
315 
316 	function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
317 		return super.transfer(to, value);
318 	}
319 
320 	function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
321 		return super.transferFrom(from, to, value);
322 	}
323 
324 }
325 ///////////////////////////////////////////
326 
327 //import "../Crowdsale.sol";
328 /**
329  * @title Crowdsale
330  * @dev Crowdsale is a base contract for managing a token crowdsale,
331  * allowing investors to purchase tokens with ether. This contract implements
332  * such functionality in its most fundamental form and can be extended to provide additional
333  * functionality and/or custom behavior.
334  * The external interface represents the basic interface for purchasing tokens, and conform
335  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
336  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
337  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
338  * behavior.
339  */
340 contract Crowdsale {
341   using SafeMath for uint256;
342 
343   // The token being sold
344   ERC20 public token;
345 
346   // Address where funds are collected
347   address public wallet;
348 
349   // How many token units a buyer gets per wei
350   uint256 public rate;
351 
352   // Amount of wei raised
353   uint256 public weiRaised;
354 
355   /**
356    * Event for token purchase logging
357    * @param purchaser who paid for the tokens
358    * @param beneficiary who got the tokens
359    * @param value weis paid for purchase
360    * @param amount amount of tokens purchased
361    */
362   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
363 
364   /**
365    * @param _rate Number of token units a buyer gets per wei
366    * @param _wallet Address where collected funds will be forwarded to
367    */
368   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
369     require(_rate > 0);
370     require(_wallet != address(0));
371 
372     rate = _rate;
373     wallet = _wallet;
374     token = _token;
375   }
376 
377   // -----------------------------------------
378   // Crowdsale external interface
379   // -----------------------------------------
380 
381   /**
382    * @dev fallback function ***DO NOT OVERRIDE***
383    */
384   function () external payable {
385     buyTokens(msg.sender);
386   }
387 
388   /**
389    * @dev low level token purchase ***DO NOT OVERRIDE***
390    * @param _beneficiary Address performing the token purchase
391    */
392   function buyTokens(address _beneficiary) public payable {
393 
394     uint256 weiAmount = msg.value;
395     _preValidatePurchase(_beneficiary, weiAmount);
396 
397     // calculate token amount to be created
398     uint256 tokens = _getTokenAmount(weiAmount);
399 
400     // update state
401     weiRaised = weiRaised.add(weiAmount);
402 
403     _processPurchase(_beneficiary, tokens);
404     emit TokenPurchase(
405       msg.sender,
406       _beneficiary,
407       weiAmount,
408       tokens
409     );
410 
411     _updatePurchasingState(_beneficiary, weiAmount);
412 
413     _forwardFunds();
414     _postValidatePurchase(_beneficiary, weiAmount);
415   }
416 
417   // -----------------------------------------
418   // Internal interface (extensible)
419   // -----------------------------------------
420 
421   /**
422    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
423    * @param _beneficiary Address performing the token purchase
424    * @param _weiAmount Value in wei involved in the purchase
425    */
426   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
427     require(_beneficiary != address(0));
428     require(_weiAmount != 0);
429   }
430 
431   /**
432    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
433    * @param _beneficiary Address performing the token purchase
434    * @param _weiAmount Value in wei involved in the purchase
435    */
436   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
437     // optional override
438   }
439 
440   /**
441    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
442    * @param _beneficiary Address performing the token purchase
443    * @param _tokenAmount Number of tokens to be emitted
444    */
445   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
446     token.transfer(_beneficiary, _tokenAmount);
447   }
448 
449   /**
450    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
451    * @param _beneficiary Address receiving the tokens
452    * @param _tokenAmount Number of tokens to be purchased
453    */
454   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
455     _deliverTokens(_beneficiary, _tokenAmount);
456   }
457 
458   /**
459    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
460    * @param _beneficiary Address receiving the tokens
461    * @param _weiAmount Value in wei involved in the purchase
462    */
463   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
464     // optional override
465   }
466 
467   /**
468    * @dev Override to extend the way in which ether is converted to tokens.
469    * @param _weiAmount Value in wei to be converted into tokens
470    * @return Number of tokens that can be purchased with the specified _weiAmount
471    */
472   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
473     return _weiAmount.mul(rate);
474   }
475 
476   /**
477    * @dev Determines how ETH is stored/forwarded on purchases.
478    */
479   function _forwardFunds() internal {
480     wallet.transfer(msg.value);
481   }
482 }
483 
484 //import "/zepp/crowdsale/validation/CappedCrowdsale.sol";
485 /**
486  * @title CappedCrowdsale
487  * @dev Crowdsale with a limit for total contributions.
488  */
489 contract CappedCrowdsale is Crowdsale {
490   using SafeMath for uint256;
491 
492   uint256 public cap;
493 
494   /**
495    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
496    * @param _cap Max amount of wei to be contributed
497    */
498   constructor(uint256 _cap) public {
499     require(_cap > 0);
500     cap = _cap;
501   }
502 
503   /**
504    * @dev Checks whether the cap has been reached.
505    * @return Whether the cap was reached
506    */
507   function capReached() public view returns (bool) {
508     return weiRaised >= cap;
509   }
510 
511   /**
512    * @dev Extend parent behavior requiring purchase to respect the funding cap.
513    * @param _beneficiary Token purchaser
514    * @param _weiAmount Amount of wei contributed
515    */
516   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
517     super._preValidatePurchase(_beneficiary, _weiAmount);
518     require(weiRaised.add(_weiAmount) <= cap);
519   }
520 
521 }
522 
523 //import "../validation/TimedCrowdsale.sol";
524 /**
525  * @title TimedCrowdsale
526  * @dev Crowdsale accepting contributions only within a time frame.
527  */
528 contract TimedCrowdsale is Crowdsale {
529   using SafeMath for uint256;
530 
531   uint256 public openingTime;
532   uint256 public closingTime;
533 
534   /**
535    * @dev Reverts if not in crowdsale time range.
536    */
537   modifier onlyWhileOpen {
538     // solium-disable-next-line security/no-block-members
539     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
540     _;
541   }
542 
543   /**
544    * @dev Constructor, takes crowdsale opening and closing times.
545    * @param _openingTime Crowdsale opening time
546    * @param _closingTime Crowdsale closing time
547    */
548   constructor(uint256 _openingTime, uint256 _closingTime) public {
549     // solium-disable-next-line security/no-block-members
550     //require(_openingTime >= block.timestamp);
551     //require(_closingTime >= _openingTime);
552 
553     openingTime = _openingTime;
554     closingTime = _closingTime;
555   }
556 
557   /**
558    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
559    * @return Whether crowdsale period has elapsed
560    */
561   function hasClosed() public view returns (bool) {
562     // solium-disable-next-line security/no-block-members
563     return block.timestamp > closingTime;
564   }
565 
566   /**
567    * @dev Extend parent behavior requiring to be within contributing period
568    * @param _beneficiary Token purchaser
569    * @param _weiAmount Amount of wei contributed
570    */
571   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
572     super._preValidatePurchase(_beneficiary, _weiAmount);
573   }
574 
575 }
576 
577 //import "../../../ownership/Ownable.sol";
578 /**
579  * @title Ownable
580  * @dev The Ownable contract has an owner address, and provides basic authorization control
581  * functions, this simplifies the implementation of "user permissions".
582  */
583 contract Ownable {
584   address public owner;
585 
586 
587   event OwnershipRenounced(address indexed previousOwner);
588   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
589 
590 
591   /**
592    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
593    * account.
594    */
595   constructor() public {
596     owner = msg.sender;
597   }
598 
599   /**
600    * @dev Throws if called by any account other than the owner.
601    */
602   modifier onlyOwner() {
603     require(msg.sender == owner);
604     _;
605   }
606 
607   /**
608    * @dev Allows the current owner to transfer control of the contract to a newOwner.
609    * @param newOwner The address to transfer ownership to.
610    */
611   function transferOwnership(address newOwner) public onlyOwner {
612     require(newOwner != address(0));
613     emit OwnershipTransferred(owner, newOwner);
614     owner = newOwner;
615   }
616 
617   /**
618    * @dev Allows the current owner to relinquish control of the contract.
619    */
620   function renounceOwnership() public onlyOwner {
621     emit OwnershipRenounced(owner);
622     owner = address(0);
623   }
624 }
625 
626 //import "./FinalizableCrowdsale.sol";
627 /**
628  * @title FinalizableCrowdsale
629  * @dev Extension of Crowdsale where an owner can do extra work
630  * after finishing.
631  */
632 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
633   using SafeMath for uint256;
634 
635   bool public isFinalized = false;
636 
637   event Finalized();
638 
639   /**
640    * @dev Must be called after crowdsale ends, to do some extra finalization
641    * work. Calls the contract's finalization function.
642    */
643   function finalize() onlyOwner public {
644     require(!isFinalized);
645     require(hasClosed());
646 
647     finalization();
648     emit Finalized();
649 
650     isFinalized = true;
651   }
652 
653   /**
654    * @dev Can be overridden to add finalization logic. The overriding function
655    * should call super.finalization() to ensure the chain of finalization is
656    * executed entirely.
657    */
658   function finalization() internal {
659   }
660 
661 }
662 
663 //import "./utils/RefundVault.sol";
664 /**
665  * @title RefundVault
666  * @dev This contract is used for storing funds while a crowdsale
667  * is in progress. Supports refunding the money if crowdsale fails,
668  * and forwarding it if crowdsale is successful.
669  */
670 contract RefundVault is Ownable {
671   using SafeMath for uint256;
672 
673   enum State { Active, Refunding, Closed }
674 
675   mapping (address => uint256) public deposited;
676   address public wallet;
677   State public state;
678 
679   event Closed();
680   event RefundsEnabled();
681   event Refunded(address indexed beneficiary, uint256 weiAmount);
682 
683   /**
684    * @param _wallet Vault address
685    */
686   constructor(address _wallet) public {
687     require(_wallet != address(0));
688     wallet = _wallet;
689     state = State.Active;
690   }
691 
692   /**
693    * @param investor Investor address
694    */
695   function deposit(address investor) onlyOwner public payable {
696     require(state == State.Active);
697     deposited[investor] = deposited[investor].add(msg.value);
698   }
699 
700   function close() onlyOwner public {
701     require(state == State.Active);
702     state = State.Closed;
703     emit Closed();
704     wallet.transfer(address(this).balance);
705   }
706 
707   function enableRefunds() onlyOwner public {
708     require(state == State.Active);
709     state = State.Refunding;
710     emit RefundsEnabled();
711   }
712 
713   /**
714    * @param investor Investor address
715    */
716   function refund(address investor) public {
717     require(state == State.Refunding);
718     uint256 depositedValue = deposited[investor];
719     deposited[investor] = 0;
720     investor.transfer(depositedValue);
721     emit Refunded(investor, depositedValue);
722   }
723 }
724 
725 //import "/zepp/crowdsale/distribution/RefundableCrowdsale.sol";
726 /**
727  * @title RefundableCrowdsale
728  * @dev Extension of Crowdsale contract that adds a funding goal, and
729  * the possibility of users getting a refund if goal is not met.
730  * Uses a RefundVault as the crowdsale's vault.
731  */
732 contract RefundableCrowdsale is FinalizableCrowdsale {
733   using SafeMath for uint256;
734 
735   // minimum amount of funds to be raised in weis
736   uint256 public goal;
737 
738   // refund vault used to hold funds while crowdsale is running
739   RefundVault public vault;
740 
741   /**
742    * @dev Constructor, creates RefundVault.
743    * @param _goal Funding goal
744    */
745   constructor(uint256 _goal) public {
746     require(_goal > 0);
747     vault = new RefundVault(wallet);
748     goal = _goal;
749   }
750 
751   /**
752    * @dev Investors can claim refunds here if crowdsale is unsuccessful
753    */
754   function claimRefund() public {
755     require(isFinalized);
756     require(!goalReached());
757 
758     vault.refund(msg.sender);
759   }
760 
761   /**
762    * @dev Checks whether funding goal was reached.
763    * @return Whether funding goal was reached
764    */
765   function goalReached() public view returns (bool) {
766     return weiRaised >= goal;
767   }
768 
769   /**
770    * @dev vault finalization task, called when owner calls finalize()
771    */
772   function finalization() internal {
773     if (goalReached()) {
774       vault.close();
775     } else {
776       vault.enableRefunds();
777     }
778 
779     super.finalization();
780   }
781 
782   /**
783    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
784    */
785   function _forwardFunds() internal {
786     vault.deposit.value(msg.value)(msg.sender);
787   }
788 
789 }
790 
791 /**
792  * @title esCrowdsale
793  * @dev This is an example of a fully fledged crowdsale.
794  * The way to add new features to a base crowdsale is by multiple inheritance.
795  * In this example we are providing following extensions:
796  * CappedCrowdsale - sets a max boundary for raised funds
797  * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
798  *
799  * After adding multiple features it's good practice to run integration tests
800  * to ensure that subcontracts works together as intended.
801  */
802 contract esCrowdsale is CappedCrowdsale, RefundableCrowdsale {
803 
804   constructor(
805     uint256 _openingTime,
806     uint256 _closingTime,
807     uint256 _rate,
808     address _wallet,
809     uint256 _cap,
810     ERC20 _token,
811     uint256 _goal
812   )
813     public
814     Crowdsale(_rate, _wallet, _token)
815     CappedCrowdsale(_cap)
816     TimedCrowdsale(_openingTime, _closingTime)
817     RefundableCrowdsale(_goal)
818   {
819     //As goal needs to be met for a successful crowdsale
820     //the value needs to less or equal than a cap which is limit for accepted funds
821     require(_goal <= _cap);
822   }
823 }