1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
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
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract Crowdsale {
60   using SafeMath for uint256;
61 
62   // The token being sold
63   ERC20 public token;
64 
65   // Address where funds are collected
66   address public wallet;
67 
68   // How many token units a buyer gets per wei
69   uint256 public rate;
70 
71   // Amount of wei raised
72   uint256 public weiRaised;
73 
74   /**
75    * Event for token purchase logging
76    * @param purchaser who paid for the tokens
77    * @param beneficiary who got the tokens
78    * @param value weis paid for purchase
79    * @param amount amount of tokens purchased
80    */
81   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
82 
83   /**
84    * @param _rate Number of token units a buyer gets per wei
85    * @param _wallet Address where collected funds will be forwarded to
86    * @param _token Address of the token being sold
87    */
88   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
89     require(_rate > 0);
90     require(_wallet != address(0));
91     require(_token != address(0));
92 
93     rate = _rate;
94     wallet = _wallet;
95     token = _token;
96   }
97 
98   // -----------------------------------------
99   // Crowdsale external interface
100   // -----------------------------------------
101 
102   /**
103    * @dev fallback function ***DO NOT OVERRIDE***
104    */
105   function () external payable {
106     buyTokens(msg.sender);
107   }
108 
109   /**
110    * @dev low level token purchase ***DO NOT OVERRIDE***
111    * @param _beneficiary Address performing the token purchase
112    */
113   function buyTokens(address _beneficiary) public payable {
114 
115     uint256 weiAmount = msg.value;
116     _preValidatePurchase(_beneficiary, weiAmount);
117 
118     // calculate token amount to be created
119     uint256 tokens = _getTokenAmount(weiAmount);
120 
121     // update state
122     weiRaised = weiRaised.add(weiAmount);
123 
124     _processPurchase(_beneficiary, tokens);
125     emit TokenPurchase(
126       msg.sender,
127       _beneficiary,
128       weiAmount,
129       tokens
130     );
131 
132     _updatePurchasingState(_beneficiary, weiAmount);
133 
134     _forwardFunds();
135     _postValidatePurchase(_beneficiary, weiAmount);
136   }
137 
138   // -----------------------------------------
139   // Internal interface (extensible)
140   // -----------------------------------------
141 
142   /**
143    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
144    * @param _beneficiary Address performing the token purchase
145    * @param _weiAmount Value in wei involved in the purchase
146    */
147   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
148     require(_beneficiary != address(0));
149     require(_weiAmount != 0);
150   }
151 
152   /**
153    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
154    * @param _beneficiary Address performing the token purchase
155    * @param _weiAmount Value in wei involved in the purchase
156    */
157   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
158     // optional override
159   }
160 
161   /**
162    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
163    * @param _beneficiary Address performing the token purchase
164    * @param _tokenAmount Number of tokens to be emitted
165    */
166   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
167     token.transfer(_beneficiary, _tokenAmount);
168   }
169 
170   /**
171    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
172    * @param _beneficiary Address receiving the tokens
173    * @param _tokenAmount Number of tokens to be purchased
174    */
175   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
176     _deliverTokens(_beneficiary, _tokenAmount);
177   }
178 
179   /**
180    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
181    * @param _beneficiary Address receiving the tokens
182    * @param _weiAmount Value in wei involved in the purchase
183    */
184   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
185     // optional override
186   }
187 
188   /**
189    * @dev Override to extend the way in which ether is converted to tokens.
190    * @param _weiAmount Value in wei to be converted into tokens
191    * @return Number of tokens that can be purchased with the specified _weiAmount
192    */
193   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
194     return _weiAmount.mul(rate);
195   }
196 
197   /**
198    * @dev Determines how ETH is stored/forwarded on purchases.
199    */
200   function _forwardFunds() internal {
201     wallet.transfer(msg.value);
202   }
203 }
204 
205 contract CappedCrowdsale is Crowdsale {
206   using SafeMath for uint256;
207 
208   uint256 public cap;
209 
210   /**
211    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
212    * @param _cap Max amount of wei to be contributed
213    */
214   function CappedCrowdsale(uint256 _cap) public {
215     require(_cap > 0);
216     cap = _cap;
217   }
218 
219   /**
220    * @dev Checks whether the cap has been reached. 
221    * @return Whether the cap was reached
222    */
223   function capReached() public view returns (bool) {
224     return weiRaised >= cap;
225   }
226 
227   /**
228    * @dev Extend parent behavior requiring purchase to respect the funding cap.
229    * @param _beneficiary Token purchaser
230    * @param _weiAmount Amount of wei contributed
231    */
232   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
233     super._preValidatePurchase(_beneficiary, _weiAmount);
234     require(weiRaised.add(_weiAmount) <= cap);
235   }
236 
237 }
238 
239 contract MintedCrowdsale is Crowdsale {
240 
241   /**
242    * @dev Overrides delivery by minting tokens upon purchase.
243    * @param _beneficiary Token purchaser
244    * @param _tokenAmount Number of tokens to be minted
245    */
246   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
247     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
248   }
249 }
250 
251 contract TimedCrowdsale is Crowdsale {
252   using SafeMath for uint256;
253 
254   uint256 public openingTime;
255   uint256 public closingTime;
256 
257   /**
258    * @dev Reverts if not in crowdsale time range.
259    */
260   modifier onlyWhileOpen {
261     // solium-disable-next-line security/no-block-members
262     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
263     _;
264   }
265 
266   /**
267    * @dev Constructor, takes crowdsale opening and closing times.
268    * @param _openingTime Crowdsale opening time
269    * @param _closingTime Crowdsale closing time
270    */
271   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
272     // solium-disable-next-line security/no-block-members
273     require(_openingTime >= block.timestamp);
274     require(_closingTime >= _openingTime);
275 
276     openingTime = _openingTime;
277     closingTime = _closingTime;
278   }
279 
280   /**
281    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
282    * @return Whether crowdsale period has elapsed
283    */
284   function hasClosed() public view returns (bool) {
285     // solium-disable-next-line security/no-block-members
286     return block.timestamp > closingTime;
287   }
288 
289   /**
290    * @dev Extend parent behavior requiring to be within contributing period
291    * @param _beneficiary Token purchaser
292    * @param _weiAmount Amount of wei contributed
293    */
294   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
295     super._preValidatePurchase(_beneficiary, _weiAmount);
296   }
297 
298 }
299 
300 contract BasicToken is ERC20Basic {
301   using SafeMath for uint256;
302 
303   mapping(address => uint256) balances;
304 
305   uint256 totalSupply_;
306 
307   /**
308   * @dev total number of tokens in existence
309   */
310   function totalSupply() public view returns (uint256) {
311     return totalSupply_;
312   }
313 
314   /**
315   * @dev transfer token for a specified address
316   * @param _to The address to transfer to.
317   * @param _value The amount to be transferred.
318   */
319   function transfer(address _to, uint256 _value) public returns (bool) {
320     require(_to != address(0));
321     require(_value <= balances[msg.sender]);
322 
323     balances[msg.sender] = balances[msg.sender].sub(_value);
324     balances[_to] = balances[_to].add(_value);
325     emit Transfer(msg.sender, _to, _value);
326     return true;
327   }
328 
329   /**
330   * @dev Gets the balance of the specified address.
331   * @param _owner The address to query the the balance of.
332   * @return An uint256 representing the amount owned by the passed address.
333   */
334   function balanceOf(address _owner) public view returns (uint256) {
335     return balances[_owner];
336   }
337 
338 }
339 
340 contract StandardToken is ERC20, BasicToken {
341 
342   mapping (address => mapping (address => uint256)) internal allowed;
343 
344 
345   /**
346    * @dev Transfer tokens from one address to another
347    * @param _from address The address which you want to send tokens from
348    * @param _to address The address which you want to transfer to
349    * @param _value uint256 the amount of tokens to be transferred
350    */
351   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
352     require(_to != address(0));
353     require(_value <= balances[_from]);
354     require(_value <= allowed[_from][msg.sender]);
355 
356     balances[_from] = balances[_from].sub(_value);
357     balances[_to] = balances[_to].add(_value);
358     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
359     emit Transfer(_from, _to, _value);
360     return true;
361   }
362 
363   /**
364    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
365    *
366    * Beware that changing an allowance with this method brings the risk that someone may use both the old
367    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
368    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
369    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
370    * @param _spender The address which will spend the funds.
371    * @param _value The amount of tokens to be spent.
372    */
373   function approve(address _spender, uint256 _value) public returns (bool) {
374     allowed[msg.sender][_spender] = _value;
375     emit Approval(msg.sender, _spender, _value);
376     return true;
377   }
378 
379   /**
380    * @dev Function to check the amount of tokens that an owner allowed to a spender.
381    * @param _owner address The address which owns the funds.
382    * @param _spender address The address which will spend the funds.
383    * @return A uint256 specifying the amount of tokens still available for the spender.
384    */
385   function allowance(address _owner, address _spender) public view returns (uint256) {
386     return allowed[_owner][_spender];
387   }
388 
389   /**
390    * @dev Increase the amount of tokens that an owner allowed to a spender.
391    *
392    * approve should be called when allowed[_spender] == 0. To increment
393    * allowed value is better to use this function to avoid 2 calls (and wait until
394    * the first transaction is mined)
395    * From MonolithDAO Token.sol
396    * @param _spender The address which will spend the funds.
397    * @param _addedValue The amount of tokens to increase the allowance by.
398    */
399   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
400     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
401     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
402     return true;
403   }
404 
405   /**
406    * @dev Decrease the amount of tokens that an owner allowed to a spender.
407    *
408    * approve should be called when allowed[_spender] == 0. To decrement
409    * allowed value is better to use this function to avoid 2 calls (and wait until
410    * the first transaction is mined)
411    * From MonolithDAO Token.sol
412    * @param _spender The address which will spend the funds.
413    * @param _subtractedValue The amount of tokens to decrease the allowance by.
414    */
415   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
416     uint oldValue = allowed[msg.sender][_spender];
417     if (_subtractedValue > oldValue) {
418       allowed[msg.sender][_spender] = 0;
419     } else {
420       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
421     }
422     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
423     return true;
424   }
425 
426 }
427 
428 contract Ownable {
429   address public owner;
430 
431 
432   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
433 
434 
435   /**
436    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
437    * account.
438    */
439   function Ownable() public {
440     owner = msg.sender;
441   }
442 
443   /**
444    * @dev Throws if called by any account other than the owner.
445    */
446   modifier onlyOwner() {
447     require(msg.sender == owner);
448     _;
449   }
450 
451   /**
452    * @dev Allows the current owner to transfer control of the contract to a newOwner.
453    * @param newOwner The address to transfer ownership to.
454    */
455   function transferOwnership(address newOwner) public onlyOwner {
456     require(newOwner != address(0));
457     emit OwnershipTransferred(owner, newOwner);
458     owner = newOwner;
459   }
460 
461 }
462 
463 contract RefundVault is Ownable {
464   using SafeMath for uint256;
465 
466   enum State { Active, Refunding, Closed }
467 
468   mapping (address => uint256) public deposited;
469   address public wallet;
470   State public state;
471 
472   event Closed();
473   event RefundsEnabled();
474   event Refunded(address indexed beneficiary, uint256 weiAmount);
475 
476   /**
477    * @param _wallet Vault address
478    */
479   function RefundVault(address _wallet) public {
480     require(_wallet != address(0));
481     wallet = _wallet;
482     state = State.Active;
483   }
484 
485   /**
486    * @param investor Investor address
487    */
488   function deposit(address investor) onlyOwner public payable {
489     require(state == State.Active);
490     deposited[investor] = deposited[investor].add(msg.value);
491   }
492 
493   function close() onlyOwner public {
494     require(state == State.Active);
495     state = State.Closed;
496     emit Closed();
497     wallet.transfer(address(this).balance);
498   }
499 
500   function enableRefunds() onlyOwner public {
501     require(state == State.Active);
502     state = State.Refunding;
503     emit RefundsEnabled();
504   }
505 
506   /**
507    * @param investor Investor address
508    */
509   function refund(address investor) public {
510     require(state == State.Refunding);
511     uint256 depositedValue = deposited[investor];
512     deposited[investor] = 0;
513     investor.transfer(depositedValue);
514     emit Refunded(investor, depositedValue);
515   }
516 }
517 
518 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
519   using SafeMath for uint256;
520 
521   bool public isFinalized = false;
522 
523   event Finalized();
524 
525   /**
526    * @dev Must be called after crowdsale ends, to do some extra finalization
527    * work. Calls the contract's finalization function.
528    */
529   function finalize() onlyOwner public {
530     require(!isFinalized);
531     require(hasClosed());
532 
533     finalization();
534     emit Finalized();
535 
536     isFinalized = true;
537   }
538 
539   /**
540    * @dev Can be overridden to add finalization logic. The overriding function
541    * should call super.finalization() to ensure the chain of finalization is
542    * executed entirely.
543    */
544   function finalization() internal {
545   }
546 
547 }
548 
549 contract RefundableCrowdsale is FinalizableCrowdsale {
550   using SafeMath for uint256;
551 
552   // minimum amount of funds to be raised in weis
553   uint256 public goal;
554 
555   // refund vault used to hold funds while crowdsale is running
556   RefundVault public vault;
557 
558   /**
559    * @dev Constructor, creates RefundVault.
560    * @param _goal Funding goal
561    */
562   function RefundableCrowdsale(uint256 _goal) public {
563     require(_goal > 0);
564     vault = new RefundVault(wallet);
565     goal = _goal;
566   }
567 
568   /**
569    * @dev Investors can claim refunds here if crowdsale is unsuccessful
570    */
571   function claimRefund() public {
572     require(isFinalized);
573     require(!goalReached());
574 
575     vault.refund(msg.sender);
576   }
577 
578   /**
579    * @dev Checks whether funding goal was reached.
580    * @return Whether funding goal was reached
581    */
582   function goalReached() public view returns (bool) {
583     return weiRaised >= goal;
584   }
585 
586   /**
587    * @dev vault finalization task, called when owner calls finalize()
588    */
589   function finalization() internal {
590     if (goalReached()) {
591       vault.close();
592     } else {
593       vault.enableRefunds();
594     }
595 
596     super.finalization();
597   }
598 
599   /**
600    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
601    */
602   function _forwardFunds() internal {
603     vault.deposit.value(msg.value)(msg.sender);
604   }
605 
606 }
607 
608 contract BaseMonoretoCrowdsale is CappedCrowdsale, RefundableCrowdsale, MintedCrowdsale {
609 
610     using SafeMath for uint256;
611 
612     uint256 public usdEth;
613     uint256 public usdMnr;
614     uint256 public tokensPurchased;
615     uint256 public tokenTarget;
616 
617     /** 
618      * @dev USDMNR must be set as actual_value * CENT_DECIMALS
619      * @dev example: value 0.2$ per token must be set as 0.2 * CENT_DECIMALS
620      */
621     uint256 public constant CENT_DECIMALS = 100000;
622 
623     // original contract owner, needed for transfering the ownership of token back after the end of crowdsale
624     address internal deployer;
625 
626     function BaseMonoretoCrowdsale(uint256 _tokenTarget, uint256 _usdEth, uint256 _usdMnr) public
627     {
628         require(_tokenTarget > 0);
629         require(_usdEth > 0);
630         require(_usdMnr > 0);
631 
632         tokenTarget = _tokenTarget;
633         usdEth = _usdEth;
634         usdMnr = _usdMnr;
635 
636         deployer = msg.sender;
637     }
638 
639     function setUsdEth(uint256 _usdEth) external onlyOwner {
640         usdEth = _usdEth;
641         rate = _usdEth.mul(CENT_DECIMALS).div(usdMnr);
642     }
643 
644     function setUsdMnr(uint256 _usdMnr) external onlyOwner {
645         usdMnr = _usdMnr;
646         rate = usdEth.mul(CENT_DECIMALS).div(_usdMnr);
647     }
648 
649     function hasClosed() public view returns (bool) {
650         return super.hasClosed() || capReached();
651     }
652 
653     // If amount of wei sent is less than the threshold, revert.
654     uint256 public constant ETHER_THRESHOLD = 100 finney;
655 
656     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
657         uint256 newTokenAmount = tokensPurchased.add(_getTokenAmount(_weiAmount));
658 
659         require(newTokenAmount <= tokenTarget);
660         require(_weiAmount >= ETHER_THRESHOLD);
661         super._preValidatePurchase(_beneficiary, _weiAmount);
662     }
663 
664     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
665         return _weiAmount.mul(usdEth).mul(CENT_DECIMALS).div(usdMnr);
666     }
667 
668     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
669         tokensPurchased = tokensPurchased.add(_tokenAmount);
670         super._deliverTokens(_beneficiary, _tokenAmount);
671     }
672 
673     /**
674      * @dev overriden template method from FinalizableCrowdsale.
675      * Returns the ownership of token to the original owner.
676      * The child contract should call super.finalization() 
677      * AFTER executing its own finalizing actions.
678      */
679     function finalization() internal {
680         super.finalization();
681 
682         MonoretoToken castToken = MonoretoToken(token);
683         castToken.transferOwnership(deployer);
684     }
685 
686 }
687 
688 contract MonoretoPreIco is BaseMonoretoCrowdsale {
689 
690     function MonoretoPreIco(uint256 _openTime, uint256 _closeTime, uint256 _goal, uint256 _cap,
691         uint256 _centWeiRate, uint256 _centMnrRate, 
692         uint256 _tokenTarget, address _ownerWallet, MonoretoToken _token) public
693         BaseMonoretoCrowdsale(_tokenTarget, _centWeiRate, _centMnrRate)
694         CappedCrowdsale(_cap)
695         RefundableCrowdsale(_goal)
696         FinalizableCrowdsale()
697         TimedCrowdsale(_openTime, _closeTime)
698         Crowdsale(_centWeiRate.mul(CENT_DECIMALS).div(_centMnrRate), _ownerWallet, _token)
699     {
700         require(_goal <= _cap);
701     }
702 
703     /**
704      * @dev Pre-ICO finalization. Cap must be adjusted after pre-ico.
705      */
706     function finalization() internal {
707         MonoretoToken castToken = MonoretoToken(token);
708         castToken.adjustCap();
709 
710         super.finalization();
711     }
712 }
713 
714 contract MintableToken is StandardToken, Ownable {
715   event Mint(address indexed to, uint256 amount);
716   event MintFinished();
717 
718   bool public mintingFinished = false;
719 
720 
721   modifier canMint() {
722     require(!mintingFinished);
723     _;
724   }
725 
726   /**
727    * @dev Function to mint tokens
728    * @param _to The address that will receive the minted tokens.
729    * @param _amount The amount of tokens to mint.
730    * @return A boolean that indicates if the operation was successful.
731    */
732   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
733     totalSupply_ = totalSupply_.add(_amount);
734     balances[_to] = balances[_to].add(_amount);
735     emit Mint(_to, _amount);
736     emit Transfer(address(0), _to, _amount);
737     return true;
738   }
739 
740   /**
741    * @dev Function to stop minting new tokens.
742    * @return True if the operation was successful.
743    */
744   function finishMinting() onlyOwner canMint public returns (bool) {
745     mintingFinished = true;
746     emit MintFinished();
747     return true;
748   }
749 }
750 
751 contract CappedToken is MintableToken {
752 
753   uint256 public cap;
754 
755   function CappedToken(uint256 _cap) public {
756     require(_cap > 0);
757     cap = _cap;
758   }
759 
760   /**
761    * @dev Function to mint tokens
762    * @param _to The address that will receive the minted tokens.
763    * @param _amount The amount of tokens to mint.
764    * @return A boolean that indicates if the operation was successful.
765    */
766   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
767     require(totalSupply_.add(_amount) <= cap);
768 
769     return super.mint(_to, _amount);
770   }
771 
772 }
773 
774 contract MonoretoToken is CappedToken {
775     using SafeMath for uint256;
776 
777     string public constant NAME = "Monoreto Token";
778     string public constant SYMBOL = "MNR";
779     uint8 public constant DECIMALS = 18;
780 
781     function MonoretoToken(uint256 _cap) public
782         CappedToken(_cap) {
783 
784     }
785 
786     bool public capAdjusted = false;
787 
788     function adjustCap() public onlyOwner {
789         require(!capAdjusted);
790         capAdjusted = true;
791 
792         uint256 percentToAdjust = 6;
793         uint256 oneHundredPercent = 100;
794         cap = totalSupply().mul(oneHundredPercent).div(percentToAdjust);
795     }
796 }