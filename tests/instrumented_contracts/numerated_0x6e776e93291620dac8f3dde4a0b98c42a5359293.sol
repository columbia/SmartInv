1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   /**
44   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   uint256 totalSupply_;
71 
72   /**
73   * @dev total number of tokens in existence
74   */
75   function totalSupply() public view returns (uint256) {
76     return totalSupply_;
77   }
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[msg.sender]);
87 
88     // SafeMath.sub will throw if there is not enough balance.
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of.
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) public view returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public view returns (uint256);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amount of tokens to be transferred
134    */
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[_from]);
138     require(_value <= allowed[_from][msg.sender]);
139 
140     balances[_from] = balances[_from].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143     Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    *
150    * Beware that changing an allowance with this method brings the risk that someone may use both the old
151    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint256 specifying the amount of tokens still available for the spender.
168    */
169   function allowance(address _owner, address _spender) public view returns (uint256) {
170     return allowed[_owner][_spender];
171   }
172 
173   /**
174    * @dev Increase the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To increment
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _addedValue The amount of tokens to increase the allowance by.
182    */
183   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
184     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189   /**
190    * @dev Decrease the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To decrement
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _subtractedValue The amount of tokens to decrease the allowance by.
198    */
199   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200     uint oldValue = allowed[msg.sender][_spender];
201     if (_subtractedValue > oldValue) {
202       allowed[msg.sender][_spender] = 0;
203     } else {
204       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205     }
206     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210 }
211 
212 /**
213  * @title Ownable
214  * @dev The Ownable contract has an owner address, and provides basic authorization control
215  * functions, this simplifies the implementation of "user permissions".
216  */
217 contract Ownable {
218   address public owner;
219 
220 
221   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223 
224   /**
225    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
226    * account.
227    */
228   function Ownable() public {
229     owner = msg.sender;
230   }
231 
232   /**
233    * @dev Throws if called by any account other than the owner.
234    */
235   modifier onlyOwner() {
236     require(msg.sender == owner);
237     _;
238   }
239 
240   /**
241    * @dev Allows the current owner to transfer control of the contract to a newOwner.
242    * @param newOwner The address to transfer ownership to.
243    */
244   function transferOwnership(address newOwner) public onlyOwner {
245     require(newOwner != address(0));
246     OwnershipTransferred(owner, newOwner);
247     owner = newOwner;
248   }
249 
250 }
251 
252 /**
253  * @title Mintable token
254  * @dev Simple ERC20 Token example, with mintable token creation
255  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
256  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
257  */
258 contract MintableToken is StandardToken, Ownable {
259   event Mint(address indexed to, uint256 amount);
260   event MintFinished();
261 
262   bool public mintingFinished = false;
263 
264 
265   modifier canMint() {
266     require(!mintingFinished);
267     _;
268   }
269 
270   /**
271    * @dev Function to mint tokens
272    * @param _to The address that will receive the minted tokens.
273    * @param _amount The amount of tokens to mint.
274    * @return A boolean that indicates if the operation was successful.
275    */
276   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
277     totalSupply_ = totalSupply_.add(_amount);
278     balances[_to] = balances[_to].add(_amount);
279     Mint(_to, _amount);
280     Transfer(address(0), _to, _amount);
281     return true;
282   }
283 
284   /**
285    * @dev Function to stop minting new tokens.
286    * @return True if the operation was successful.
287    */
288   function finishMinting() onlyOwner canMint public returns (bool) {
289     mintingFinished = true;
290     MintFinished();
291     return true;
292   }
293 }
294 
295 /**
296  * @title Crowdsale
297  * @dev Crowdsale is a base contract for managing a token crowdsale,
298  * allowing investors to purchase tokens with ether. This contract implements
299  * such functionality in its most fundamental form and can be extended to provide additional
300  * functionality and/or custom behavior.
301  * The external interface represents the basic interface for purchasing tokens, and conform
302  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
303  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
304  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
305  * behavior.
306  */
307 
308 contract Crowdsale {
309   using SafeMath for uint256;
310 
311   // The token being sold
312   ERC20 public token;
313 
314   // Address where funds are collected
315   address public wallet;
316 
317   // How many token units a buyer gets per wei
318   uint256 public rate;
319 
320   // Amount of wei raised
321   uint256 public weiRaised;
322 
323   /**
324    * Event for token purchase logging
325    * @param purchaser who paid for the tokens
326    * @param beneficiary who got the tokens
327    * @param value weis paid for purchase
328    * @param amount amount of tokens purchased
329    */
330   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
331 
332   /**
333    * @param _rate Number of token units a buyer gets per wei
334    * @param _wallet Address where collected funds will be forwarded to
335    * @param _token Address of the token being sold
336    */
337   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
338     require(_rate > 0);
339     require(_wallet != address(0));
340     require(_token != address(0));
341 
342     rate = _rate;
343     wallet = _wallet;
344     token = _token;
345   }
346 
347   // -----------------------------------------
348   // Crowdsale external interface
349   // -----------------------------------------
350 
351   /**
352    * @dev fallback function ***DO NOT OVERRIDE***
353    */
354   function () external payable {
355     buyTokens(msg.sender);
356   }
357 
358   /**
359    * @dev low level token purchase ***DO NOT OVERRIDE***
360    * @param _beneficiary Address performing the token purchase
361    */
362   function buyTokens(address _beneficiary) public payable {
363 
364     uint256 weiAmount = msg.value;
365     _preValidatePurchase(_beneficiary, weiAmount);
366 
367     // calculate token amount to be created
368     uint256 tokens = _getTokenAmount(weiAmount);
369 
370     // update state
371     weiRaised = weiRaised.add(weiAmount);
372 
373     _processPurchase(_beneficiary, tokens);
374     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
375 
376     _updatePurchasingState(_beneficiary, weiAmount);
377 
378     _forwardFunds();
379     _postValidatePurchase(_beneficiary, weiAmount);
380   }
381 
382   // -----------------------------------------
383   // Internal interface (extensible)
384   // -----------------------------------------
385 
386   /**
387    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
388    * @param _beneficiary Address performing the token purchase
389    * @param _weiAmount Value in wei involved in the purchase
390    */
391   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
392     require(_beneficiary != address(0));
393     require(_weiAmount != 0);
394   }
395 
396   /**
397    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
398    * @param _beneficiary Address performing the token purchase
399    * @param _weiAmount Value in wei involved in the purchase
400    */
401   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
402     // optional override
403   }
404 
405   /**
406    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
407    * @param _beneficiary Address performing the token purchase
408    * @param _tokenAmount Number of tokens to be emitted
409    */
410   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
411     token.transfer(_beneficiary, _tokenAmount);
412   }
413 
414   /**
415    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
416    * @param _beneficiary Address receiving the tokens
417    * @param _tokenAmount Number of tokens to be purchased
418    */
419   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
420     _deliverTokens(_beneficiary, _tokenAmount);
421   }
422 
423   /**
424    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
425    * @param _beneficiary Address receiving the tokens
426    * @param _weiAmount Value in wei involved in the purchase
427    */
428   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
429     // optional override
430   }
431 
432   /**
433    * @dev Override to extend the way in which ether is converted to tokens.
434    * @param _weiAmount Value in wei to be converted into tokens
435    * @return Number of tokens that can be purchased with the specified _weiAmount
436    */
437   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
438     return _weiAmount.mul(rate);
439   }
440 
441   /**
442    * @dev Determines how ETH is stored/forwarded on purchases.
443    */
444   function _forwardFunds() internal {
445     wallet.transfer(msg.value);
446   }
447 }
448 
449 /**
450  * @title CappedCrowdsale
451  * @dev Crowdsale with a limit for total contributions.
452  */
453 contract CappedCrowdsale is Crowdsale {
454   using SafeMath for uint256;
455 
456   uint256 public cap;
457 
458   /**
459    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
460    * @param _cap Max amount of wei to be contributed
461    */
462   function CappedCrowdsale(uint256 _cap) public {
463     require(_cap > 0);
464     cap = _cap;
465   }
466 
467   /**
468    * @dev Checks whether the cap has been reached. 
469    * @return Whether the cap was reached
470    */
471   function capReached() public view returns (bool) {
472     return weiRaised >= cap;
473   }
474 
475   /**
476    * @dev Extend parent behavior requiring purchase to respect the funding cap.
477    * @param _beneficiary Token purchaser
478    * @param _weiAmount Amount of wei contributed
479    */
480   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
481     super._preValidatePurchase(_beneficiary, _weiAmount);
482     require(weiRaised.add(_weiAmount) <= cap);
483   }
484 
485 }
486 
487 /**
488  * @title TimedCrowdsale
489  * @dev Crowdsale accepting contributions only within a time frame.
490  */
491 contract TimedCrowdsale is Crowdsale {
492   using SafeMath for uint256;
493 
494   uint256 public openingTime;
495   uint256 public closingTime;
496 
497   /**
498    * @dev Reverts if not in crowdsale time range. 
499    */
500   modifier onlyWhileOpen {
501     require(now >= openingTime && now <= closingTime);
502     _;
503   }
504 
505   /**
506    * @dev Constructor, takes crowdsale opening and closing times.
507    * @param _openingTime Crowdsale opening time
508    * @param _closingTime Crowdsale closing time
509    */
510   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
511     require(_openingTime >= now);
512     require(_closingTime >= _openingTime);
513 
514     openingTime = _openingTime;
515     closingTime = _closingTime;
516   }
517 
518   /**
519    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
520    * @return Whether crowdsale period has elapsed
521    */
522   function hasClosed() public view returns (bool) {
523     return now > closingTime;
524   }
525   
526   /**
527    * @dev Extend parent behavior requiring to be within contributing period
528    * @param _beneficiary Token purchaser
529    * @param _weiAmount Amount of wei contributed
530    */
531   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
532     super._preValidatePurchase(_beneficiary, _weiAmount);
533   }
534 
535 }
536 
537 /**
538  * @title FinalizableCrowdsale
539  * @dev Extension of Crowdsale where an owner can do extra work
540  * after finishing.
541  */
542 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
543   using SafeMath for uint256;
544 
545   bool public isFinalized = false;
546 
547   event Finalized();
548 
549   /**
550    * @dev Must be called after crowdsale ends, to do some extra finalization
551    * work. Calls the contract's finalization function.
552    */
553   function finalize() onlyOwner public {
554     require(!isFinalized);
555     require(hasClosed());
556 
557     finalization();
558     Finalized();
559 
560     isFinalized = true;
561   }
562 
563   /**
564    * @dev Can be overridden to add finalization logic. The overriding function
565    * should call super.finalization() to ensure the chain of finalization is
566    * executed entirely.
567    */
568   function finalization() internal {
569   }
570 }
571 
572 /**
573  * @title RefundVault
574  * @dev This contract is used for storing funds while a crowdsale
575  * is in progress. Supports refunding the money if crowdsale fails,
576  * and forwarding it if crowdsale is successful.
577  */
578 contract RefundVault is Ownable {
579   using SafeMath for uint256;
580 
581   enum State { Active, Refunding, Closed }
582 
583   mapping (address => uint256) public deposited;
584   address public wallet;
585   State public state;
586 
587   event Closed();
588   event RefundsEnabled();
589   event Refunded(address indexed beneficiary, uint256 weiAmount);
590 
591   /**
592    * @param _wallet Vault address
593    */
594   function RefundVault(address _wallet) public {
595     require(_wallet != address(0));
596     wallet = _wallet;
597     state = State.Active;
598   }
599 
600   /**
601    * @param investor Investor address
602    */
603   function deposit(address investor) onlyOwner public payable {
604     require(state == State.Active);
605     deposited[investor] = deposited[investor].add(msg.value);
606   }
607 
608   function close() onlyOwner public {
609     require(state == State.Active);
610     state = State.Closed;
611     Closed();
612     wallet.transfer(this.balance);
613   }
614 
615   function enableRefunds() onlyOwner public {
616     require(state == State.Active);
617     state = State.Refunding;
618     RefundsEnabled();
619   }
620 
621   /**
622    * @param investor Investor address
623    */
624   function refund(address investor) public {
625     require(state == State.Refunding);
626     uint256 depositedValue = deposited[investor];
627     deposited[investor] = 0;
628     investor.transfer(depositedValue);
629     Refunded(investor, depositedValue);
630   }
631 }
632 
633 /**
634  * @title RefundableCrowdsale
635  * @dev Extension of Crowdsale contract that adds a funding goal, and
636  * the possibility of users getting a refund if goal is not met.
637  * Uses a RefundVault as the crowdsale's vault.
638  */
639 contract RefundableCrowdsale is FinalizableCrowdsale {
640   using SafeMath for uint256;
641 
642   // minimum amount of funds to be raised in weis
643   uint256 public goal;
644 
645   // refund vault used to hold funds while crowdsale is running
646   RefundVault public vault;
647 
648   /**
649    * @dev Constructor, creates RefundVault. 
650    * @param _goal Funding goal
651    */
652   function RefundableCrowdsale(uint256 _goal) public {
653     require(_goal > 0);
654     vault = new RefundVault(wallet);
655     goal = _goal;
656   }
657 
658   /**
659    * @dev Investors can claim refunds here if crowdsale is unsuccessful
660    */
661   function claimRefund() public {
662     require(isFinalized);
663     require(!goalReached());
664 
665     vault.refund(msg.sender);
666   }
667 
668   /**
669    * @dev Checks whether funding goal was reached. 
670    * @return Whether funding goal was reached
671    */
672   function goalReached() public view returns (bool) {
673     return weiRaised >= goal;
674   }
675 
676   /**
677    * @dev vault finalization task, called when owner calls finalize()
678    */
679   function finalization() internal {
680     if (goalReached()) {
681       vault.close();
682     } else {
683       vault.enableRefunds();
684     }
685 
686     super.finalization();
687   }
688 
689   /**
690    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
691    */
692   function _forwardFunds() internal {
693     vault.deposit.value(msg.value)(msg.sender);
694   }
695 
696 }
697 
698 /**
699  * @title MintedCrowdsale
700  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
701  * Token ownership should be transferred to MintedCrowdsale for minting. 
702  */
703 contract MintedCrowdsale is Crowdsale {
704 
705   /**
706   * @dev Overrides delivery by minting tokens upon purchase.
707   * @param _beneficiary Token purchaser
708   * @param _tokenAmount Number of tokens to be minted
709   */
710   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
711     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
712   }
713 }
714 
715 /**
716  * @title DeskBellPresale
717  * @dev Pre-sale contract, with emission limits, with time of sale limits, bonus periods and finalisation
718  */
719 contract DeskBellPresale is CappedCrowdsale, RefundableCrowdsale, MintedCrowdsale {
720 
721     function DeskBellPresale() public
722         Crowdsale(1000, 0xC4F9617107a38fb5a0674De68E428484F70f4CaC, MintableToken(0xDE9AB41040A1FE5Ea59e89d8f02e49F514532538))
723         CappedCrowdsale(7000 ether)
724         TimedCrowdsale(1522065600, 1523275200)
725         RefundableCrowdsale(600 ether)
726     {
727         require(goal <= cap);
728     }
729 
730     /**
731      * @dev minimum limit of purchase
732      */
733     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
734         super._preValidatePurchase(_beneficiary, _weiAmount);
735         require(_weiAmount >= (1 ether / rate).mul(10));
736     }
737 
738     /**
739      * @dev calculation of the bonuses in two periods
740      */
741     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
742         uint256 tokens = _weiAmount.mul(rate);
743         uint256 bonusTokens = 0;
744         if (now < openingTime.add(7 days)) {
745             bonusTokens = tokens.mul(15).div(100);
746         } else {
747             bonusTokens = tokens.mul(75).div(1000);
748         }
749         return tokens.add(bonusTokens);
750     }
751 
752     /**
753      * @dev overload finalize with condition on goal over hasClosed
754      */
755     function finalize() onlyOwner public {
756         require(!isFinalized);
757         require(hasClosed() || goalReached());
758 
759         finalization();
760         Finalized();
761 
762         isFinalized = true;
763     }
764 
765     /**
766      * @dev finalizing contract with returning of ownership to developers address
767      */
768     function finalization() internal {
769         super.finalization();
770         MintableToken(token).transferOwnership(0x57F8FFD76e9F90Ed945E3dB07F8f43b8e4B8E45d);
771     }
772 }