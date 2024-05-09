1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract ERC20Basic {
81   function totalSupply() public view returns (uint256);
82   function balanceOf(address who) public view returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) public view returns (uint256);
89   function transferFrom(address from, address to, uint256 value) public returns (bool);
90   function approve(address spender, uint256 value) public returns (bool);
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 contract BasicToken is ERC20Basic {
95   using SafeMath for uint256;
96 
97   mapping(address => uint256) balances;
98 
99   uint256 totalSupply_;
100 
101   /**
102   * @dev total number of tokens in existence
103   */
104   function totalSupply() public view returns (uint256) {
105     return totalSupply_;
106   }
107 
108   /**
109   * @dev transfer token for a specified address
110   * @param _to The address to transfer to.
111   * @param _value The amount to be transferred.
112   */
113   function transfer(address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[msg.sender]);
116 
117     // SafeMath.sub will throw if there is not enough balance.
118     balances[msg.sender] = balances[msg.sender].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     Transfer(msg.sender, _to, _value);
121     return true;
122   }
123 
124   /**
125   * @dev Gets the balance of the specified address.
126   * @param _owner The address to query the the balance of.
127   * @return An uint256 representing the amount owned by the passed address.
128   */
129   function balanceOf(address _owner) public view returns (uint256 balance) {
130     return balances[_owner];
131   }
132 }
133 
134 contract StandardToken is ERC20, BasicToken {
135 
136   mapping (address => mapping (address => uint256)) internal allowed;
137 
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    *
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Function to check the amount of tokens that an owner allowed to a spender.
175    * @param _owner address The address which owns the funds.
176    * @param _spender address The address which will spend the funds.
177    * @return A uint256 specifying the amount of tokens still available for the spender.
178    */
179   function allowance(address _owner, address _spender) public view returns (uint256) {
180     return allowed[_owner][_spender];
181   }
182 
183   /**
184    * @dev Increase the amount of tokens that an owner allowed to a spender.
185    *
186    * approve should be called when allowed[_spender] == 0. To increment
187    * allowed value is better to use this function to avoid 2 calls (and wait until
188    * the first transaction is mined)
189    * From MonolithDAO Token.sol
190    * @param _spender The address which will spend the funds.
191    * @param _addedValue The amount of tokens to increase the allowance by.
192    */
193   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   /**
200    * @dev Decrease the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To decrement
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _subtractedValue The amount of tokens to decrease the allowance by.
208    */
209   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 }
220 
221 contract MintableToken is StandardToken, Ownable {
222   event Mint(address indexed to, uint256 amount);
223   event MintFinished();
224 
225   bool public mintingFinished = false;
226 
227 
228   modifier canMint() {
229     require(!mintingFinished);
230     _;
231   }
232 
233   /**
234    * @dev Function to mint tokens
235    * @param _to The address that will receive the minted tokens.
236    * @param _amount The amount of tokens to mint.
237    * @return A boolean that indicates if the operation was successful.
238    */
239   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
240     totalSupply_ = totalSupply_.add(_amount);
241     balances[_to] = balances[_to].add(_amount);
242     Mint(_to, _amount);
243     Transfer(address(0), _to, _amount);
244     return true;
245   }
246 
247   /**
248    * @dev Function to stop minting new tokens.
249    * @return True if the operation was successful.
250    */
251   function finishMinting() onlyOwner canMint public returns (bool) {
252     mintingFinished = true;
253     MintFinished();
254     return true;
255   }
256 }
257 
258 contract Crowdsale {
259   using SafeMath for uint256;
260 
261   // The token being sold
262   ERC20 public token;
263 
264   // Address where funds are collected
265   address public wallet;
266 
267   // How many token units a buyer gets per wei
268   uint256 public rate;
269 
270   // Amount of wei raised
271   uint256 public weiRaised;
272 
273   /**
274    * Event for token purchase logging
275    * @param purchaser who paid for the tokens
276    * @param beneficiary who got the tokens
277    * @param value weis paid for purchase
278    * @param amount amount of tokens purchased
279    */
280   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
281 
282   /**
283    * @param _rate Number of token units a buyer gets per wei
284    * @param _wallet Address where collected funds will be forwarded to
285    * @param _token Address of the token being sold
286    */
287   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
288     require(_rate > 0);
289     require(_wallet != address(0));
290     require(_token != address(0));
291 
292     rate = _rate;
293     wallet = _wallet;
294     token = _token;
295   }
296 
297   // -----------------------------------------
298   // Crowdsale external interface
299   // -----------------------------------------
300 
301   function () external payable {
302       buyTokens(msg.sender);
303   }
304   /**
305    * @dev low level token purchase ***DO NOT OVERRIDE***
306    * @param _beneficiary Address performing the token purchase
307    */
308   function buyTokens(address _beneficiary) payable public  {
309     uint weiAmount;
310     uint changeEthBack;
311 
312     (weiAmount,changeEthBack) = _prePurchaseAmount(msg.value);
313     _preValidatePurchase(_beneficiary, weiAmount);
314 
315     // calculate token amount to be created
316     uint256 tokens = _getTokenAmount(weiAmount);
317 
318     // update state
319     weiRaised = weiRaised.add(weiAmount);
320 
321     _processPurchase(_beneficiary, tokens);
322     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
323 
324     _updatePurchasingState(_beneficiary, weiAmount);
325 
326     _forwardFunds(weiAmount);
327     _postValidatePurchase(_beneficiary, weiAmount);
328     if (changeEthBack > 0) {
329         msg.sender.transfer(changeEthBack);
330     }
331   }
332 
333   // -----------------------------------------
334   // Internal interface (extensible)
335   // -----------------------------------------
336 
337   /*
338   ** @dev _prePurchaseAmount. Calculate the acceptable wei amount according to the sale cap.
339   ** @param _weiAmount the amount which is sent to the contract.
340   ** @return weiAmount the acceptable amount
341   **         changeEthBack ether amount to send back to the purchaser.
342   **
343   */
344   function _prePurchaseAmount(uint _weiAmount) internal returns(uint , uint) {
345        return (_weiAmount,0);
346   }
347   /**
348    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
349    * @param _beneficiary Address performing the token purchase
350    * @param _weiAmount Value in wei involved in the purchase
351    */
352   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
353     require(_beneficiary != address(0));
354     require(_weiAmount != 0);
355   }
356 
357   /**
358    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
359    * @param _beneficiary Address performing the token purchase
360    * @param _weiAmount Value in wei involved in the purchase
361    */
362   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
363     // optional override
364   }
365 
366   /**
367    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
368    * @param _beneficiary Address performing the token purchase
369    * @param _tokenAmount Number of tokens to be emitted
370    */
371   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
372     token.transfer(_beneficiary, _tokenAmount);
373   }
374 
375   /**
376    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
377    * @param _beneficiary Address receiving the tokens
378    * @param _tokenAmount Number of tokens to be purchased
379    */
380   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
381     _deliverTokens(_beneficiary, _tokenAmount);
382   }
383 
384   /**
385    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
386    * @param _beneficiary Address receiving the tokens
387    * @param _weiAmount Value in wei involved in the purchase
388    */
389   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
390     // optional override
391   }
392 
393   /**
394    * @dev Override to extend the way in which ether is converted to tokens.
395    * @param _weiAmount Value in wei to be converted into tokens
396    * @return Number of tokens that can be purchased with the specified _weiAmount
397    */
398   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
399     return _weiAmount.mul(rate);
400   }
401 
402   /**
403    * @dev Determines how ETH is stored/forwarded on purchases.
404    */
405   function _forwardFunds(uint _value) internal {
406     wallet.transfer(_value);
407   }
408 }
409 
410 contract CappedCrowdsale is Crowdsale {
411   using SafeMath for uint256;
412 
413   uint256 public cap;
414 
415   /**
416    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
417    * @param _cap Max amount of wei to be contributed
418    */
419   function CappedCrowdsale(uint256 _cap) public {
420     require(_cap > 0);
421     cap = _cap;
422   }
423 
424   /**
425    * @dev Checks whether the cap has been reached.
426    * @return Whether the cap was reached
427    */
428   function capReached() public view returns (bool) {
429     return weiRaised >= cap;
430   }
431 
432   /**
433    * @dev Extend parent behavior requiring purchase to respect the funding cap.
434    * @param _beneficiary Token purchaser
435    * @param _weiAmount Amount of wei contributed
436    */
437   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
438     super._preValidatePurchase(_beneficiary, _weiAmount);
439     require(weiRaised.add(_weiAmount) <= cap);
440   }
441 }
442 
443 contract WhitelistedCrowdsale is Crowdsale, Ownable {
444   event LogAddedToWhiteList(address indexed _address);
445   event LogRemovedFromWhiteList(address indexed _address);
446 
447   mapping(address => bool) public whitelist;
448 
449   /**
450    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
451    */
452   modifier isWhitelisted(address _beneficiary) {
453     require(whitelist[_beneficiary]);
454     _;
455   }
456 
457   /**
458    * @dev Adds single address to whitelist.
459    * @param _beneficiary Address to be added to the whitelist
460    */
461   function addToWhitelist(address _beneficiary) external onlyOwner {
462     whitelist[_beneficiary] = true;
463     emit LogAddedToWhiteList(_beneficiary);
464   }
465 
466   /**
467    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
468    * @param _beneficiaries Addresses to be added to the whitelist
469    */
470   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
471     for (uint256 i = 0; i < _beneficiaries.length; i++) {
472       whitelist[_beneficiaries[i]] = true;
473       emit LogAddedToWhiteList(_beneficiaries[i]);
474     }
475   }
476 
477   /**
478    * @dev Removes single address from whitelist.
479    * @param _beneficiary Address to be removed to the whitelist
480    */
481   function removeFromWhitelist(address _beneficiary) external onlyOwner {
482     whitelist[_beneficiary] = false;
483     emit LogRemovedFromWhiteList(_beneficiary);
484   }
485 
486   /**
487    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
488    * @param _beneficiary Token beneficiary
489    * @param _weiAmount Amount of wei contributed
490    */
491   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
492     super._preValidatePurchase(_beneficiary, _weiAmount);
493   }
494 }
495 
496 contract TimedCrowdsale is Crowdsale {
497   using SafeMath for uint256;
498 
499   uint256 public openingTime;
500   uint256 public closingTime;
501 
502   /**
503    * @dev Reverts if not in crowdsale time range.
504    */
505   modifier onlyWhileOpen {
506     require(now >= openingTime && now <= closingTime);
507     _;
508   }
509 
510   /**
511    * @dev Constructor, takes crowdsale opening and closing times.
512    * @param _openingTime Crowdsale opening time
513    * @param _closingTime Crowdsale closing time
514    */
515   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
516     require(_openingTime >= now);
517     require(_closingTime >= _openingTime);
518 
519     openingTime = _openingTime;
520     closingTime = _closingTime;
521   }
522 
523   /**
524    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
525    * @return Whether crowdsale period has elapsed
526    */
527   function hasClosed() public view returns (bool) {
528     return now > closingTime;
529   }
530 
531   /**
532    * @dev Extend parent behavior requiring to be within contributing period
533    * @param _beneficiary Token purchaser
534    * @param _weiAmount Amount of wei contributed
535    */
536   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
537     super._preValidatePurchase(_beneficiary, _weiAmount);
538   }
539 }
540 
541 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
542   using SafeMath for uint256;
543 
544   bool public isFinalized = false;
545 
546   event Finalized();
547 
548   /**
549    * @dev Must be called after crowdsale ends, to do some extra finalization
550    * work. Calls the contract's finalization function.
551    */
552   function finalize() onlyOwner public {
553     require(!isFinalized);
554     require(hasClosed());
555 
556     finalization();
557     emit Finalized();
558 
559     isFinalized = true;
560   }
561 
562   /**
563    * @dev Can be overridden to add finalization logic. The overriding function
564    * should call super.finalization() to ensure the chain of finalization is
565    * executed entirely.
566    */
567   function finalization() internal {
568   }
569 }
570 
571 contract MintedCrowdsale is Crowdsale {
572 
573   /**
574   * @dev Overrides delivery by minting tokens upon purchase.
575   * @param _beneficiary Token purchaser
576   * @param _tokenAmount Number of tokens to be minted
577   */
578   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
579     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
580   }
581 }
582 
583 contract BuyLimits {
584     event LogLimitsChanged(uint _minBuy, uint _maxBuy);
585 
586     // Variables holding the min and max payment in wei
587     uint public minBuy; // min buy in wei
588     uint public maxBuy; // max buy in wei, 0 means no maximum
589 
590     /*
591     ** Modifier, reverting if not within limits.
592     */
593     modifier isWithinLimits(uint _amount) {
594         require(withinLimits(_amount));
595         _;
596     }
597 
598     /*
599     ** @dev Constructor, define variable:
600     */
601     function BuyLimits(uint _min, uint  _max) public {
602         _setLimits(_min, _max);
603     }
604 
605     /*
606     ** @dev Check TXs value is within limits:
607     */
608     function withinLimits(uint _value) public view returns(bool) {
609         if (maxBuy != 0) {
610             return (_value >= minBuy && _value <= maxBuy);
611         }
612         return (_value >= minBuy);
613     }
614 
615     /*
616     ** @dev set limits logic:
617     ** @param _min set the minimum buy in wei
618     ** @param _max set the maximum buy in wei, 0 indeicates no maximum
619     */
620     function _setLimits(uint _min, uint _max) internal {
621         if (_max != 0) {
622             require (_min <= _max); // Sanity Check
623         }
624         minBuy = _min;
625         maxBuy = _max;
626         emit LogLimitsChanged(_min, _max);
627     }
628 }
629 
630 contract BuyLimitsCrowdsale is BuyLimits,Crowdsale {
631 
632     /**
633      ** @dev Constructor, define variable:
634     */
635     function BuyLimitsCrowdsale(uint _min, uint  _max)
636     public
637     BuyLimits(_min,_max)
638     {
639     }
640 
641     /**
642      * @dev Extend parent behavior requiring to be within contributing period
643      * @param _beneficiary Token purchaser
644      * @param _weiAmount Amount of wei contributed
645      */
646     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWithinLimits(_weiAmount) {
647         super._preValidatePurchase(_beneficiary, _weiAmount);
648     }
649 }
650 
651 contract DAOstackSale is MintedCrowdsale, CappedCrowdsale, FinalizableCrowdsale, BuyLimitsCrowdsale, WhitelistedCrowdsale {
652     using SafeMath for uint256;
653 
654     uint public maxGasPrice;
655 
656     /*
657     ** @dev constructor.
658     ** @param _openingTime the time sale start.
659     ** @param _closingTime the time sale ends.
660     ** @param _rate the sale rate, buyer gets tokens = _rates * msg.value.
661     ** @param _wallet the DAOstack multi-sig address.
662     ** @param _cap the sale cap.
663     ** @param _minBuy the min amount (in Wei) one can buy with.
664     ** @param _maxBuy the max amount (in Wei) one can buy with.
665     ** @param _token the mintable token contract.
666     */
667     function DAOstackSale(
668         uint _openingTime,
669         uint _closingTime,
670         uint _rate,
671         address _wallet,
672         uint _cap,
673         uint _minBuy,
674         uint _maxBuy,
675         uint _maxGasPrice,
676         MintableToken _token
677     ) public
678         Crowdsale(_rate, _wallet, _token)
679         CappedCrowdsale(_cap)
680         BuyLimitsCrowdsale(_minBuy, _maxBuy)
681         TimedCrowdsale(_openingTime,_closingTime)
682     {
683         maxGasPrice = _maxGasPrice;
684     }
685 
686     /*
687     ** @dev Drain function, in case of failure. Contract should not hold eth anyhow.
688     */
689     function drain() onlyOwner public {
690         wallet.transfer((address(this)).balance);
691     }
692 
693     /*
694     ** @dev Drain tokens to wallet.
695     *  For the case someone accidentally send ERC20 tokens to the contract.
696     *  @param _token the token to drain.
697     */
698     function drainTokens(StandardToken _token) onlyOwner public {
699         _token.transfer(wallet, _token.balanceOf(address(this)));
700     }
701 
702     function hasClosed() public view returns (bool) {
703         return (capReached() || super.hasClosed());
704     }
705 
706     /*
707     ** @dev Finalizing. Transfer token ownership to wallet for safe-keeping until it will be transferred to the DAO.
708     **      Called from the finalize function in FinalizableCrowdsale.
709     */
710     function finalization() internal {
711         MintableToken(token).transferOwnership(wallet);
712         super.finalization();
713     }
714 
715     /*
716     ** @dev _prePurchaseAmount. Calculate the acceptable wei amount according to the sale cap.
717     **      override  crowdsale _prePurchaseAmount .
718     ** @param _weiAmount the amount which is sent to the contract.
719     ** @return weiAmount the acceptable amount
720     **         changeEthBack ether amount to send back to the purchaser.
721     **
722     */
723     function _prePurchaseAmount(uint _weiAmount) internal returns(uint weiAmount, uint changeEthBack) {
724         if (weiRaised.add(_weiAmount) > cap) {
725             changeEthBack = weiRaised.add(_weiAmount) - cap;
726             weiAmount = _weiAmount.sub(changeEthBack);
727             if (weiAmount < minBuy) {
728                 _setLimits(weiAmount,maxBuy);
729             }
730         } else {
731             weiAmount = _weiAmount;
732         }
733     }
734 
735 
736     /**
737      * @dev checking gas price.
738      * @param _beneficiary Address performing the token purchase
739      * @param _weiAmount Value in wei involved in the purchase
740      */
741     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
742       require(tx.gasprice <= maxGasPrice);
743       super._preValidatePurchase(_beneficiary, _weiAmount);
744     }
745 }