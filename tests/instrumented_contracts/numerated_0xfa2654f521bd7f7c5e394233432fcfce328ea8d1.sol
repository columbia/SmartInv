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
185  */
186 contract StandardToken is ERC20, BasicToken {
187 
188   mapping (address => mapping (address => uint256)) internal allowed;
189 
190 
191   /**
192    * @dev Transfer tokens from one address to another
193    * @param _from address The address which you want to send tokens from
194    * @param _to address The address which you want to transfer to
195    * @param _value uint256 the amount of tokens to be transferred
196    */
197   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
198     require(_to != address(0));
199     require(_value <= balances[_from]);
200     require(_value <= allowed[_from][msg.sender]);
201 
202     balances[_from] = balances[_from].sub(_value);
203     balances[_to] = balances[_to].add(_value);
204     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
205     Transfer(_from, _to, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
211    *
212    * Beware that changing an allowance with this method brings the risk that someone may use both the old
213    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
214    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
215    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
216    * @param _spender The address which will spend the funds.
217    * @param _value The amount of tokens to be spent.
218    */
219   function approve(address _spender, uint256 _value) public returns (bool) {
220     allowed[msg.sender][_spender] = _value;
221     Approval(msg.sender, _spender, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Function to check the amount of tokens that an owner allowed to a spender.
227    * @param _owner address The address which owns the funds.
228    * @param _spender address The address which will spend the funds.
229    * @return A uint256 specifying the amount of tokens still available for the spender.
230    */
231   function allowance(address _owner, address _spender) public view returns (uint256) {
232     return allowed[_owner][_spender];
233   }
234 
235   /**
236    * @dev Increase the amount of tokens that an owner allowed to a spender.
237    *
238    * approve should be called when allowed[_spender] == 0. To increment
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param _spender The address which will spend the funds.
243    * @param _addedValue The amount of tokens to increase the allowance by.
244    */
245   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
246     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
247     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251   /**
252    * @dev Decrease the amount of tokens that an owner allowed to a spender.
253    *
254    * approve should be called when allowed[_spender] == 0. To decrement
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _subtractedValue The amount of tokens to decrease the allowance by.
260    */
261   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
262     uint oldValue = allowed[msg.sender][_spender];
263     if (_subtractedValue > oldValue) {
264       allowed[msg.sender][_spender] = 0;
265     } else {
266       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
267     }
268     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269     return true;
270   }
271 
272 }
273 
274 contract PointToken is OwnableToken, BurnableToken, StandardToken {
275 	string public name;
276 	string public symbol;
277 	uint8 public decimals;
278 
279 	bool public paused = true;
280 	mapping(address => bool) public whitelist;
281 
282 	modifier whenNotPaused() {
283 		require(!paused || whitelist[msg.sender]);
284 		_;
285 	}
286 
287 	constructor(string _name,string _symbol,uint8 _decimals, address holder, address buffer) public {
288 		name = _name;
289 		symbol = _symbol;
290 		decimals = _decimals;
291 		Transfer(address(0), holder, balances[holder] = totalSupply_ = uint256(10)**(9 + decimals));
292 		addToWhitelist(holder);
293 		addToWhitelist(buffer);
294 	}
295 
296 	function unpause() public onlyOwner {
297 		paused = false;
298 	}
299 
300 	function pause() public onlyOwner {
301 		paused = true;
302 	}
303 
304 	function addToWhitelist(address addr) public onlyOwner {
305 		whitelist[addr] = true;
306 	}
307     
308 	function removeFromWhitelist(address addr) public onlyOwner {
309 		whitelist[addr] = false;
310 	}
311 
312 	function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
313 		return super.transfer(to, value);
314 	}
315 
316 	function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
317 		return super.transferFrom(from, to, value);
318 	}
319 
320 }
321 ///////////////////////////////////////////
322 
323 //import "../Crowdsale.sol";
324 /**
325  * @title Crowdsale
326  * @dev Crowdsale is a base contract for managing a token crowdsale,
327  * allowing investors to purchase tokens with ether. This contract implements
328  * such functionality in its most fundamental form and can be extended to provide additional
329  * functionality and/or custom behavior.
330  * The external interface represents the basic interface for purchasing tokens, and conform
331  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
332  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
333  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
334  * behavior.
335  */
336 contract Crowdsale {
337   using SafeMath for uint256;
338 
339   // The token being sold
340   ERC20 public token;
341 
342   // Address where funds are collected
343   address public wallet;
344 
345   // How many token units a buyer gets per wei
346   uint256 public rate;
347 
348   // Amount of wei raised
349   uint256 public weiRaised;
350 
351   /**
352    * Event for token purchase logging
353    * @param purchaser who paid for the tokens
354    * @param beneficiary who got the tokens
355    * @param value weis paid for purchase
356    * @param amount amount of tokens purchased
357    */
358   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
359 
360   /**
361    * @param _rate Number of token units a buyer gets per wei
362    * @param _wallet Address where collected funds will be forwarded to
363    */
364   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
365     require(_rate > 0);
366     require(_wallet != address(0));
367 
368     rate = _rate;
369     wallet = _wallet;
370     token = _token;
371   }
372 
373   // -----------------------------------------
374   // Crowdsale external interface
375   // -----------------------------------------
376 
377   /**
378    * @dev fallback function ***DO NOT OVERRIDE***
379    */
380   function () external payable {
381     buyTokens(msg.sender);
382   }
383 
384   /**
385    * @dev low level token purchase ***DO NOT OVERRIDE***
386    * @param _beneficiary Address performing the token purchase
387    */
388   function buyTokens(address _beneficiary) public payable {
389 
390     uint256 weiAmount = msg.value;
391     _preValidatePurchase(_beneficiary, weiAmount);
392 
393     // calculate token amount to be created
394     uint256 tokens = _getTokenAmount(weiAmount);
395 
396     // update state
397     weiRaised = weiRaised.add(weiAmount);
398 
399     _processPurchase(_beneficiary, tokens);
400     emit TokenPurchase(
401       msg.sender,
402       _beneficiary,
403       weiAmount,
404       tokens
405     );
406 
407     _updatePurchasingState(_beneficiary, weiAmount);
408 
409     _forwardFunds();
410     _postValidatePurchase(_beneficiary, weiAmount);
411   }
412 
413   // -----------------------------------------
414   // Internal interface (extensible)
415   // -----------------------------------------
416 
417   /**
418    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
419    * @param _beneficiary Address performing the token purchase
420    * @param _weiAmount Value in wei involved in the purchase
421    */
422   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
423     require(_beneficiary != address(0));
424     require(_weiAmount != 0);
425   }
426 
427   /**
428    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
429    * @param _beneficiary Address performing the token purchase
430    * @param _weiAmount Value in wei involved in the purchase
431    */
432   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
433     // optional override
434   }
435 
436   /**
437    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
438    * @param _beneficiary Address performing the token purchase
439    * @param _tokenAmount Number of tokens to be emitted
440    */
441   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
442     token.transfer(_beneficiary, _tokenAmount);
443   }
444 
445   /**
446    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
447    * @param _beneficiary Address receiving the tokens
448    * @param _tokenAmount Number of tokens to be purchased
449    */
450   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
451     _deliverTokens(_beneficiary, _tokenAmount);
452   }
453 
454   /**
455    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
456    * @param _beneficiary Address receiving the tokens
457    * @param _weiAmount Value in wei involved in the purchase
458    */
459   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
460     // optional override
461   }
462 
463   /**
464    * @dev Override to extend the way in which ether is converted to tokens.
465    * @param _weiAmount Value in wei to be converted into tokens
466    * @return Number of tokens that can be purchased with the specified _weiAmount
467    */
468   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
469     return _weiAmount.mul(rate);
470   }
471 
472   /**
473    * @dev Determines how ETH is stored/forwarded on purchases.
474    */
475   function _forwardFunds() internal {
476     wallet.transfer(msg.value);
477   }
478 }
479 
480 //import "/zepp/crowdsale/validation/CappedCrowdsale.sol";
481 /**
482  * @title CappedCrowdsale
483  * @dev Crowdsale with a limit for total contributions.
484  */
485 contract CappedCrowdsale is Crowdsale {
486   using SafeMath for uint256;
487 
488   uint256 public cap;
489 
490   /**
491    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
492    * @param _cap Max amount of wei to be contributed
493    */
494   constructor(uint256 _cap) public {
495     require(_cap > 0);
496     cap = _cap;
497   }
498 
499   /**
500    * @dev Checks whether the cap has been reached.
501    * @return Whether the cap was reached
502    */
503   function capReached() public view returns (bool) {
504     return weiRaised >= cap;
505   }
506 
507   /**
508    * @dev Extend parent behavior requiring purchase to respect the funding cap.
509    * @param _beneficiary Token purchaser
510    * @param _weiAmount Amount of wei contributed
511    */
512   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
513     super._preValidatePurchase(_beneficiary, _weiAmount);
514     require(weiRaised.add(_weiAmount) <= cap);
515   }
516 
517 }
518 
519 //import "../validation/TimedCrowdsale.sol";
520 /**
521  * @title TimedCrowdsale
522  * @dev Crowdsale accepting contributions only within a time frame.
523  */
524 contract TimedCrowdsale is Crowdsale {
525   using SafeMath for uint256;
526 
527   uint256 public openingTime;
528   uint256 public closingTime;
529 
530   /**
531    * @dev Reverts if not in crowdsale time range.
532    */
533   modifier onlyWhileOpen {
534     // solium-disable-next-line security/no-block-members
535     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
536     _;
537   }
538 
539   /**
540    * @dev Constructor, takes crowdsale opening and closing times.
541    * @param _openingTime Crowdsale opening time
542    * @param _closingTime Crowdsale closing time
543    */
544   constructor(uint256 _openingTime, uint256 _closingTime) public {
545     // solium-disable-next-line security/no-block-members
546     //require(_openingTime >= block.timestamp);
547     //require(_closingTime >= _openingTime);
548 
549     openingTime = _openingTime;
550     closingTime = _closingTime;
551   }
552 
553   /**
554    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
555    * @return Whether crowdsale period has elapsed
556    */
557   function hasClosed() public view returns (bool) {
558     // solium-disable-next-line security/no-block-members
559     return block.timestamp > closingTime;
560   }
561 
562   /**
563    * @dev Extend parent behavior requiring to be within contributing period
564    * @param _beneficiary Token purchaser
565    * @param _weiAmount Amount of wei contributed
566    */
567   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
568     super._preValidatePurchase(_beneficiary, _weiAmount);
569   }
570 
571 }
572 
573 //import "../../../ownership/Ownable.sol";
574 /**
575  * @title Ownable
576  * @dev The Ownable contract has an owner address, and provides basic authorization control
577  * functions, this simplifies the implementation of "user permissions".
578  */
579 contract Ownable {
580   address public owner;
581 
582 
583   event OwnershipRenounced(address indexed previousOwner);
584   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
585 
586 
587   /**
588    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
589    * account.
590    */
591   constructor() public {
592     owner = msg.sender;
593   }
594 
595   /**
596    * @dev Throws if called by any account other than the owner.
597    */
598   modifier onlyOwner() {
599     require(msg.sender == owner);
600     _;
601   }
602 
603   /**
604    * @dev Allows the current owner to transfer control of the contract to a newOwner.
605    * @param newOwner The address to transfer ownership to.
606    */
607   function transferOwnership(address newOwner) public onlyOwner {
608     require(newOwner != address(0));
609     emit OwnershipTransferred(owner, newOwner);
610     owner = newOwner;
611   }
612 
613   /**
614    * @dev Allows the current owner to relinquish control of the contract.
615    */
616   function renounceOwnership() public onlyOwner {
617     emit OwnershipRenounced(owner);
618     owner = address(0);
619   }
620 }
621 
622 //import "./FinalizableCrowdsale.sol";
623 /**
624  * @title FinalizableCrowdsale
625  * @dev Extension of Crowdsale where an owner can do extra work
626  * after finishing.
627  */
628 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
629   using SafeMath for uint256;
630 
631   bool public isFinalized = false;
632 
633   event Finalized();
634 
635   /**
636    * @dev Must be called after crowdsale ends, to do some extra finalization
637    * work. Calls the contract's finalization function.
638    */
639   function finalize() onlyOwner public {
640     require(!isFinalized);
641     require(hasClosed());
642 
643     finalization();
644     emit Finalized();
645 
646     isFinalized = true;
647   }
648 
649   /**
650    * @dev Can be overridden to add finalization logic. The overriding function
651    * should call super.finalization() to ensure the chain of finalization is
652    * executed entirely.
653    */
654   function finalization() internal {
655   }
656 
657 }
658 
659 //import "./utils/RefundVault.sol";
660 /**
661  * @title RefundVault
662  * @dev This contract is used for storing funds while a crowdsale
663  * is in progress. Supports refunding the money if crowdsale fails,
664  * and forwarding it if crowdsale is successful.
665  */
666 contract RefundVault is Ownable {
667   using SafeMath for uint256;
668 
669   enum State { Active, Refunding, Closed }
670 
671   mapping (address => uint256) public deposited;
672   address public wallet;
673   State public state;
674 
675   event Closed();
676   event RefundsEnabled();
677   event Refunded(address indexed beneficiary, uint256 weiAmount);
678 
679   /**
680    * @param _wallet Vault address
681    */
682   constructor(address _wallet) public {
683     require(_wallet != address(0));
684     wallet = _wallet;
685     state = State.Active;
686   }
687 
688   /**
689    * @param investor Investor address
690    */
691   function deposit(address investor) onlyOwner public payable {
692     require(state == State.Active);
693     deposited[investor] = deposited[investor].add(msg.value);
694   }
695 
696   function close() onlyOwner public {
697     require(state == State.Active);
698     state = State.Closed;
699     emit Closed();
700     wallet.transfer(address(this).balance);
701   }
702 
703   function enableRefunds() onlyOwner public {
704     require(state == State.Active);
705     state = State.Refunding;
706     emit RefundsEnabled();
707   }
708 
709   /**
710    * @param investor Investor address
711    */
712   function refund(address investor) public {
713     require(state == State.Refunding);
714     uint256 depositedValue = deposited[investor];
715     deposited[investor] = 0;
716     investor.transfer(depositedValue);
717     emit Refunded(investor, depositedValue);
718   }
719 }
720 
721 //import "/zepp/crowdsale/distribution/RefundableCrowdsale.sol";
722 /**
723  * @title RefundableCrowdsale
724  * @dev Extension of Crowdsale contract that adds a funding goal, and
725  * the possibility of users getting a refund if goal is not met.
726  * Uses a RefundVault as the crowdsale's vault.
727  */
728 contract RefundableCrowdsale is FinalizableCrowdsale {
729   using SafeMath for uint256;
730 
731   // minimum amount of funds to be raised in weis
732   uint256 public goal;
733 
734   // refund vault used to hold funds while crowdsale is running
735   RefundVault public vault;
736 
737   /**
738    * @dev Constructor, creates RefundVault.
739    * @param _goal Funding goal
740    */
741   constructor(uint256 _goal) public {
742     require(_goal > 0);
743     vault = new RefundVault(wallet);
744     goal = _goal;
745   }
746 
747   /**
748    * @dev Investors can claim refunds here if crowdsale is unsuccessful
749    */
750   function claimRefund() public {
751     require(isFinalized);
752     require(!goalReached());
753 
754     vault.refund(msg.sender);
755   }
756 
757   /**
758    * @dev Checks whether funding goal was reached.
759    * @return Whether funding goal was reached
760    */
761   function goalReached() public view returns (bool) {
762     return weiRaised >= goal;
763   }
764 
765   /**
766    * @dev vault finalization task, called when owner calls finalize()
767    */
768   function finalization() internal {
769     if (goalReached()) {
770       vault.close();
771     } else {
772       vault.enableRefunds();
773     }
774 
775     super.finalization();
776   }
777 
778   /**
779    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
780    */
781   function _forwardFunds() internal {
782     vault.deposit.value(msg.value)(msg.sender);
783   }
784 
785 }
786 
787 /**
788  * @title esCrowdsale
789  * @dev This is an example of a fully fledged crowdsale.
790  * The way to add new features to a base crowdsale is by multiple inheritance.
791  * In this example we are providing following extensions:
792  * CappedCrowdsale - sets a max boundary for raised funds
793  * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
794  *
795  * After adding multiple features it's good practice to run integration tests
796  * to ensure that subcontracts works together as intended.
797  */
798 contract PointCrowdsale is CappedCrowdsale, RefundableCrowdsale {
799 
800   constructor(
801     uint256 _openingTime,
802     uint256 _closingTime,
803     uint256 _rate,
804     address _wallet,
805     uint256 _cap,
806     ERC20 _token,
807     uint256 _goal
808   )
809     public
810     Crowdsale(_rate, _wallet, _token)
811     CappedCrowdsale(_cap)
812     TimedCrowdsale(_openingTime, _closingTime)
813     RefundableCrowdsale(_goal)
814   {
815     //As goal needs to be met for a successful crowdsale
816     //the value needs to less or equal than a cap which is limit for accepted funds
817     require(_goal <= _cap);
818   }
819 }