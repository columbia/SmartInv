1 pragma solidity ^0.4.13;
2 
3 contract Crowdsale {
4   using SafeMath for uint256;
5 
6   // The token being sold
7   ERC20 public token;
8 
9   // Address where funds are collected
10   address public wallet;
11 
12   // How many token units a buyer gets per wei
13   uint256 public rate;
14 
15   // Amount of wei raised
16   uint256 public weiRaised;
17 
18   /**
19    * Event for token purchase logging
20    * @param purchaser who paid for the tokens
21    * @param beneficiary who got the tokens
22    * @param value weis paid for purchase
23    * @param amount amount of tokens purchased
24    */
25   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
26 
27   /**
28    * @param _rate Number of token units a buyer gets per wei
29    * @param _wallet Address where collected funds will be forwarded to
30    * @param _token Address of the token being sold
31    */
32   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
33     require(_rate > 0);
34     require(_wallet != address(0));
35     require(_token != address(0));
36 
37     rate = _rate;
38     wallet = _wallet;
39     token = _token;
40   }
41 
42   // -----------------------------------------
43   // Crowdsale external interface
44   // -----------------------------------------
45 
46   /**
47    * @dev fallback function ***DO NOT OVERRIDE***
48    */
49   function () external payable {
50     buyTokens(msg.sender);
51   }
52 
53   /**
54    * @dev low level token purchase ***DO NOT OVERRIDE***
55    * @param _beneficiary Address performing the token purchase
56    */
57   function buyTokens(address _beneficiary) public payable {
58 
59     uint256 weiAmount = msg.value;
60     _preValidatePurchase(_beneficiary, weiAmount);
61 
62     // calculate token amount to be created
63     uint256 tokens = _getTokenAmount(weiAmount);
64 
65     // update state
66     weiRaised = weiRaised.add(weiAmount);
67 
68     _processPurchase(_beneficiary, tokens);
69     emit TokenPurchase(
70       msg.sender,
71       _beneficiary,
72       weiAmount,
73       tokens
74     );
75 
76     _updatePurchasingState(_beneficiary, weiAmount);
77 
78     _forwardFunds();
79     _postValidatePurchase(_beneficiary, weiAmount);
80   }
81 
82   // -----------------------------------------
83   // Internal interface (extensible)
84   // -----------------------------------------
85 
86   /**
87    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
88    * @param _beneficiary Address performing the token purchase
89    * @param _weiAmount Value in wei involved in the purchase
90    */
91   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
92     require(_beneficiary != address(0));
93     require(_weiAmount != 0);
94   }
95 
96   /**
97    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
98    * @param _beneficiary Address performing the token purchase
99    * @param _weiAmount Value in wei involved in the purchase
100    */
101   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
102     // optional override
103   }
104 
105   /**
106    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
107    * @param _beneficiary Address performing the token purchase
108    * @param _tokenAmount Number of tokens to be emitted
109    */
110   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
111     token.transfer(_beneficiary, _tokenAmount);
112   }
113 
114   /**
115    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
116    * @param _beneficiary Address receiving the tokens
117    * @param _tokenAmount Number of tokens to be purchased
118    */
119   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
120     _deliverTokens(_beneficiary, _tokenAmount);
121   }
122 
123   /**
124    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
125    * @param _beneficiary Address receiving the tokens
126    * @param _weiAmount Value in wei involved in the purchase
127    */
128   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
129     // optional override
130   }
131 
132   /**
133    * @dev Override to extend the way in which ether is converted to tokens.
134    * @param _weiAmount Value in wei to be converted into tokens
135    * @return Number of tokens that can be purchased with the specified _weiAmount
136    */
137   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
138     return _weiAmount.mul(rate);
139   }
140 
141   /**
142    * @dev Determines how ETH is stored/forwarded on purchases.
143    */
144   function _forwardFunds() internal {
145     wallet.transfer(msg.value);
146   }
147 }
148 
149 contract TimedCrowdsale is Crowdsale {
150   using SafeMath for uint256;
151 
152   uint256 public openingTime;
153   uint256 public closingTime;
154 
155   /**
156    * @dev Reverts if not in crowdsale time range.
157    */
158   modifier onlyWhileOpen {
159     // solium-disable-next-line security/no-block-members
160     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
161     _;
162   }
163 
164   /**
165    * @dev Constructor, takes crowdsale opening and closing times.
166    * @param _openingTime Crowdsale opening time
167    * @param _closingTime Crowdsale closing time
168    */
169   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
170     // solium-disable-next-line security/no-block-members
171     require(_openingTime >= block.timestamp);
172     require(_closingTime >= _openingTime);
173 
174     openingTime = _openingTime;
175     closingTime = _closingTime;
176   }
177 
178   /**
179    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
180    * @return Whether crowdsale period has elapsed
181    */
182   function hasClosed() public view returns (bool) {
183     // solium-disable-next-line security/no-block-members
184     return block.timestamp > closingTime;
185   }
186 
187   /**
188    * @dev Extend parent behavior requiring to be within contributing period
189    * @param _beneficiary Token purchaser
190    * @param _weiAmount Amount of wei contributed
191    */
192   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
193     super._preValidatePurchase(_beneficiary, _weiAmount);
194   }
195 
196 }
197 
198 contract Ownable {
199   address public owner;
200 
201 
202   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
203 
204 
205   /**
206    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
207    * account.
208    */
209   function Ownable() public {
210     owner = msg.sender;
211   }
212 
213   /**
214    * @dev Throws if called by any account other than the owner.
215    */
216   modifier onlyOwner() {
217     require(msg.sender == owner);
218     _;
219   }
220 
221   /**
222    * @dev Allows the current owner to transfer control of the contract to a newOwner.
223    * @param newOwner The address to transfer ownership to.
224    */
225   function transferOwnership(address newOwner) public onlyOwner {
226     require(newOwner != address(0));
227     emit OwnershipTransferred(owner, newOwner);
228     owner = newOwner;
229   }
230 
231 }
232 
233 contract RefundVault is Ownable {
234   using SafeMath for uint256;
235 
236   enum State { Active, Refunding, Closed }
237 
238   mapping (address => uint256) public deposited;
239   address public wallet;
240   State public state;
241 
242   event Closed();
243   event RefundsEnabled();
244   event Refunded(address indexed beneficiary, uint256 weiAmount);
245 
246   /**
247    * @param _wallet Vault address
248    */
249   function RefundVault(address _wallet) public {
250     require(_wallet != address(0));
251     wallet = _wallet;
252     state = State.Active;
253   }
254 
255   /**
256    * @param investor Investor address
257    */
258   function deposit(address investor) onlyOwner public payable {
259     require(state == State.Active);
260     deposited[investor] = deposited[investor].add(msg.value);
261   }
262 
263   function close() onlyOwner public {
264     require(state == State.Active);
265     state = State.Closed;
266     emit Closed();
267     wallet.transfer(address(this).balance);
268   }
269 
270   function enableRefunds() onlyOwner public {
271     require(state == State.Active);
272     state = State.Refunding;
273     emit RefundsEnabled();
274   }
275 
276   /**
277    * @param investor Investor address
278    */
279   function refund(address investor) public {
280     require(state == State.Refunding);
281     uint256 depositedValue = deposited[investor];
282     deposited[investor] = 0;
283     investor.transfer(depositedValue);
284     emit Refunded(investor, depositedValue);
285   }
286 }
287 
288 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
289   using SafeMath for uint256;
290 
291   bool public isFinalized = false;
292 
293   event Finalized();
294 
295   /**
296    * @dev Must be called after crowdsale ends, to do some extra finalization
297    * work. Calls the contract's finalization function.
298    */
299   function finalize() onlyOwner public {
300     require(!isFinalized);
301     require(hasClosed());
302 
303     finalization();
304     emit Finalized();
305 
306     isFinalized = true;
307   }
308 
309   /**
310    * @dev Can be overridden to add finalization logic. The overriding function
311    * should call super.finalization() to ensure the chain of finalization is
312    * executed entirely.
313    */
314   function finalization() internal {
315   }
316 
317 }
318 
319 contract RefundableCrowdsale is FinalizableCrowdsale {
320   using SafeMath for uint256;
321 
322   // minimum amount of funds to be raised in weis
323   uint256 public goal;
324 
325   // refund vault used to hold funds while crowdsale is running
326   RefundVault public vault;
327 
328   /**
329    * @dev Constructor, creates RefundVault.
330    * @param _goal Funding goal
331    */
332   function RefundableCrowdsale(uint256 _goal) public {
333     require(_goal > 0);
334     vault = new RefundVault(wallet);
335     goal = _goal;
336   }
337 
338   /**
339    * @dev Investors can claim refunds here if crowdsale is unsuccessful
340    */
341   function claimRefund() public {
342     require(isFinalized);
343     require(!goalReached());
344 
345     vault.refund(msg.sender);
346   }
347 
348   /**
349    * @dev Checks whether funding goal was reached.
350    * @return Whether funding goal was reached
351    */
352   function goalReached() public view returns (bool) {
353     return weiRaised >= goal;
354   }
355 
356   /**
357    * @dev vault finalization task, called when owner calls finalize()
358    */
359   function finalization() internal {
360     if (goalReached()) {
361       vault.close();
362     } else {
363       vault.enableRefunds();
364     }
365 
366     super.finalization();
367   }
368 
369   /**
370    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
371    */
372   function _forwardFunds() internal {
373     vault.deposit.value(msg.value)(msg.sender);
374   }
375 
376 }
377 
378 library SafeMath {
379 
380   /**
381   * @dev Multiplies two numbers, throws on overflow.
382   */
383   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
384     if (a == 0) {
385       return 0;
386     }
387     c = a * b;
388     assert(c / a == b);
389     return c;
390   }
391 
392   /**
393   * @dev Integer division of two numbers, truncating the quotient.
394   */
395   function div(uint256 a, uint256 b) internal pure returns (uint256) {
396     // assert(b > 0); // Solidity automatically throws when dividing by 0
397     // uint256 c = a / b;
398     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
399     return a / b;
400   }
401 
402   /**
403   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
404   */
405   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
406     assert(b <= a);
407     return a - b;
408   }
409 
410   /**
411   * @dev Adds two numbers, throws on overflow.
412   */
413   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
414     c = a + b;
415     assert(c >= a);
416     return c;
417   }
418 }
419 
420 contract MintedCrowdsale is Crowdsale {
421 
422   /**
423    * @dev Overrides delivery by minting tokens upon purchase.
424    * @param _beneficiary Token purchaser
425    * @param _tokenAmount Number of tokens to be minted
426    */
427   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
428     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
429   }
430 }
431 
432 contract ERC20Basic {
433   function totalSupply() public view returns (uint256);
434   function balanceOf(address who) public view returns (uint256);
435   function transfer(address to, uint256 value) public returns (bool);
436   event Transfer(address indexed from, address indexed to, uint256 value);
437 }
438 
439 contract BasicToken is ERC20Basic {
440   using SafeMath for uint256;
441 
442   mapping(address => uint256) balances;
443 
444   uint256 totalSupply_;
445 
446   /**
447   * @dev total number of tokens in existence
448   */
449   function totalSupply() public view returns (uint256) {
450     return totalSupply_;
451   }
452 
453   /**
454   * @dev transfer token for a specified address
455   * @param _to The address to transfer to.
456   * @param _value The amount to be transferred.
457   */
458   function transfer(address _to, uint256 _value) public returns (bool) {
459     require(_to != address(0));
460     require(_value <= balances[msg.sender]);
461 
462     balances[msg.sender] = balances[msg.sender].sub(_value);
463     balances[_to] = balances[_to].add(_value);
464     emit Transfer(msg.sender, _to, _value);
465     return true;
466   }
467 
468   /**
469   * @dev Gets the balance of the specified address.
470   * @param _owner The address to query the the balance of.
471   * @return An uint256 representing the amount owned by the passed address.
472   */
473   function balanceOf(address _owner) public view returns (uint256) {
474     return balances[_owner];
475   }
476 
477 }
478 
479 contract ERC20 is ERC20Basic {
480   function allowance(address owner, address spender) public view returns (uint256);
481   function transferFrom(address from, address to, uint256 value) public returns (bool);
482   function approve(address spender, uint256 value) public returns (bool);
483   event Approval(address indexed owner, address indexed spender, uint256 value);
484 }
485 
486 contract StandardToken is ERC20, BasicToken {
487 
488   mapping (address => mapping (address => uint256)) internal allowed;
489 
490 
491   /**
492    * @dev Transfer tokens from one address to another
493    * @param _from address The address which you want to send tokens from
494    * @param _to address The address which you want to transfer to
495    * @param _value uint256 the amount of tokens to be transferred
496    */
497   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
498     require(_to != address(0));
499     require(_value <= balances[_from]);
500     require(_value <= allowed[_from][msg.sender]);
501 
502     balances[_from] = balances[_from].sub(_value);
503     balances[_to] = balances[_to].add(_value);
504     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
505     emit Transfer(_from, _to, _value);
506     return true;
507   }
508 
509   /**
510    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
511    *
512    * Beware that changing an allowance with this method brings the risk that someone may use both the old
513    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
514    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
515    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
516    * @param _spender The address which will spend the funds.
517    * @param _value The amount of tokens to be spent.
518    */
519   function approve(address _spender, uint256 _value) public returns (bool) {
520     allowed[msg.sender][_spender] = _value;
521     emit Approval(msg.sender, _spender, _value);
522     return true;
523   }
524 
525   /**
526    * @dev Function to check the amount of tokens that an owner allowed to a spender.
527    * @param _owner address The address which owns the funds.
528    * @param _spender address The address which will spend the funds.
529    * @return A uint256 specifying the amount of tokens still available for the spender.
530    */
531   function allowance(address _owner, address _spender) public view returns (uint256) {
532     return allowed[_owner][_spender];
533   }
534 
535   /**
536    * @dev Increase the amount of tokens that an owner allowed to a spender.
537    *
538    * approve should be called when allowed[_spender] == 0. To increment
539    * allowed value is better to use this function to avoid 2 calls (and wait until
540    * the first transaction is mined)
541    * From MonolithDAO Token.sol
542    * @param _spender The address which will spend the funds.
543    * @param _addedValue The amount of tokens to increase the allowance by.
544    */
545   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
546     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
547     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
548     return true;
549   }
550 
551   /**
552    * @dev Decrease the amount of tokens that an owner allowed to a spender.
553    *
554    * approve should be called when allowed[_spender] == 0. To decrement
555    * allowed value is better to use this function to avoid 2 calls (and wait until
556    * the first transaction is mined)
557    * From MonolithDAO Token.sol
558    * @param _spender The address which will spend the funds.
559    * @param _subtractedValue The amount of tokens to decrease the allowance by.
560    */
561   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
562     uint oldValue = allowed[msg.sender][_spender];
563     if (_subtractedValue > oldValue) {
564       allowed[msg.sender][_spender] = 0;
565     } else {
566       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
567     }
568     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
569     return true;
570   }
571 
572 }
573 
574 contract MintableToken is StandardToken, Ownable {
575   event Mint(address indexed to, uint256 amount);
576   event MintFinished();
577 
578   bool public mintingFinished = false;
579 
580 
581   modifier canMint() {
582     require(!mintingFinished);
583     _;
584   }
585 
586   /**
587    * @dev Function to mint tokens
588    * @param _to The address that will receive the minted tokens.
589    * @param _amount The amount of tokens to mint.
590    * @return A boolean that indicates if the operation was successful.
591    */
592   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
593     totalSupply_ = totalSupply_.add(_amount);
594     balances[_to] = balances[_to].add(_amount);
595     emit Mint(_to, _amount);
596     emit Transfer(address(0), _to, _amount);
597     return true;
598   }
599 
600   /**
601    * @dev Function to stop minting new tokens.
602    * @return True if the operation was successful.
603    */
604   function finishMinting() onlyOwner canMint public returns (bool) {
605     mintingFinished = true;
606     emit MintFinished();
607     return true;
608   }
609 }
610 
611 contract CappedToken is MintableToken {
612 
613   uint256 public cap;
614 
615   function CappedToken(uint256 _cap) public {
616     require(_cap > 0);
617     cap = _cap;
618   }
619 
620   /**
621    * @dev Function to mint tokens
622    * @param _to The address that will receive the minted tokens.
623    * @param _amount The amount of tokens to mint.
624    * @return A boolean that indicates if the operation was successful.
625    */
626   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
627     require(totalSupply_.add(_amount) <= cap);
628 
629     return super.mint(_to, _amount);
630   }
631 
632 }
633 
634 contract MonoretoToken is CappedToken {
635     using SafeMath for uint256;
636 
637     string public constant NAME = "Monoreto Token";
638     string public constant SYMBOL = "MNR";
639     uint8 public constant DECIMALS = 18;
640 
641     function MonoretoToken(uint256 _cap) public
642         CappedToken(_cap) {
643 
644     }
645 
646     bool public capAdjusted = false;
647 
648     function adjustCap() public onlyOwner {
649         require(!capAdjusted);
650         capAdjusted = true;
651 
652         uint256 percentToAdjust = 6;
653         uint256 oneHundredPercent = 100;
654         cap = totalSupply().mul(oneHundredPercent).div(percentToAdjust);
655     }
656 }
657 
658 contract CappedCrowdsale is Crowdsale {
659   using SafeMath for uint256;
660 
661   uint256 public cap;
662 
663   /**
664    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
665    * @param _cap Max amount of wei to be contributed
666    */
667   function CappedCrowdsale(uint256 _cap) public {
668     require(_cap > 0);
669     cap = _cap;
670   }
671 
672   /**
673    * @dev Checks whether the cap has been reached. 
674    * @return Whether the cap was reached
675    */
676   function capReached() public view returns (bool) {
677     return weiRaised >= cap;
678   }
679 
680   /**
681    * @dev Extend parent behavior requiring purchase to respect the funding cap.
682    * @param _beneficiary Token purchaser
683    * @param _weiAmount Amount of wei contributed
684    */
685   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
686     super._preValidatePurchase(_beneficiary, _weiAmount);
687     require(weiRaised.add(_weiAmount) <= cap);
688   }
689 
690 }
691 
692 contract BaseMonoretoCrowdsale is CappedCrowdsale, RefundableCrowdsale, MintedCrowdsale {
693 
694     using SafeMath for uint256;
695 
696     uint256 public usdEth;
697     uint256 public usdMnr;
698     uint256 public tokensPurchased;
699     uint256 public tokenTarget;
700 
701     /** 
702      * @dev USDMNR must be set as actual_value * CENT_DECIMALS
703      * @dev example: value 0.2$ per token must be set as 0.2 * CENT_DECIMALS
704      */
705     uint256 public constant CENT_DECIMALS = 1e18;
706 
707     // original contract owner, needed for transfering the ownership of token back after the end of crowdsale
708     address internal deployer;
709 
710     function BaseMonoretoCrowdsale(uint256 _tokenTarget, uint256 _usdEth, uint256 _usdMnr) public
711     {
712         require(_tokenTarget > 0);
713         require(_usdEth > 0);
714         require(_usdMnr > 0);
715 
716         tokenTarget = _tokenTarget;
717         usdEth = _usdEth;
718         usdMnr = _usdMnr;
719 
720         deployer = msg.sender;
721     }
722 
723     function setUsdEth(uint256 _usdEth) external onlyOwner {
724         usdEth = _usdEth;
725         rate = _usdEth.mul(CENT_DECIMALS).div(usdMnr);
726     }
727 
728     function setUsdMnr(uint256 _usdMnr) external onlyOwner {
729         usdMnr = _usdMnr;
730         rate = usdEth.mul(CENT_DECIMALS).div(_usdMnr);
731     }
732 
733     function hasClosed() public view returns (bool) {
734         return super.hasClosed() || capReached();
735     }
736 
737     // If amount of wei sent is less than the threshold, revert.
738     uint256 public constant ETHER_THRESHOLD = 100 finney;
739 
740     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
741         uint256 newTokenAmount = tokensPurchased.add(_getTokenAmount(_weiAmount));
742 
743         require(newTokenAmount <= tokenTarget);
744         require(_weiAmount >= ETHER_THRESHOLD);
745         super._preValidatePurchase(_beneficiary, _weiAmount);
746     }
747 
748     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
749         return _weiAmount.mul(rate); //mul(usdEth).mul(CENT_DECIMALS).div(usdMnr);
750     }
751 
752     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
753         tokensPurchased = tokensPurchased.add(_tokenAmount);
754         super._deliverTokens(_beneficiary, _tokenAmount);
755     }
756 
757     /**
758      * @dev overriden template method from FinalizableCrowdsale.
759      * Returns the ownership of token to the original owner.
760      * The child contract should call super.finalization() 
761      * AFTER executing its own finalizing actions.
762      */
763     function finalization() internal {
764         super.finalization();
765 
766         MonoretoToken castToken = MonoretoToken(token);
767         castToken.transferOwnership(deployer);
768     }
769 
770 }
771 
772 contract MonoretoPreIco is BaseMonoretoCrowdsale {
773 
774     function MonoretoPreIco(uint256 _openTime, uint256 _closeTime, uint256 _goal, uint256 _cap,
775         uint256 _centWeiRate, uint256 _centMnrRate, 
776         uint256 _tokenTarget, uint256 _initialRate, address _ownerWallet, MonoretoToken _token) public
777         BaseMonoretoCrowdsale(_tokenTarget, _centWeiRate, _centMnrRate)
778         CappedCrowdsale(_cap)
779         RefundableCrowdsale(_goal)
780         FinalizableCrowdsale()
781         TimedCrowdsale(_openTime, _closeTime)
782         Crowdsale(_initialRate, _ownerWallet, _token)
783     {
784         require(_goal <= _cap);
785     }
786 
787     /**
788      * @dev Pre-ICO finalization. Cap must be adjusted after pre-ico.
789      */
790     function finalization() internal {
791         MonoretoToken castToken = MonoretoToken(token);
792         castToken.adjustCap();
793 
794         super.finalization();
795     }
796 }