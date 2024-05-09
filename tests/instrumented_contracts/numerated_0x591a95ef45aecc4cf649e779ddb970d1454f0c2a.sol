1 pragma solidity ^0.4.11;
2 
3 
4 
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   /**
30   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 /**
48  * @title Ownable
49  * @dev The Ownable contract has an owner address, and provides basic authorization control
50  * functions, this simplifies the implementation of "user permissions".
51  */
52 contract Ownable {
53   address public owner;
54 
55 
56   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58 
59   /**
60    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61    * account.
62    */
63   function Ownable() public {
64     owner = msg.sender;
65   }
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address newOwner) public onlyOwner {
80     require(newOwner != address(0));
81     OwnershipTransferred(owner, newOwner);
82     owner = newOwner;
83   }
84 
85 }
86 
87 
88 /**
89  * @title ERC20Basic
90  * @dev Simpler version of ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/179
92  */
93 contract ERC20Basic {
94   function totalSupply() public view returns (uint256);
95   function balanceOf(address who) public view returns (uint256);
96   function transfer(address to, uint256 value) public returns (bool);
97   event Transfer(address indexed from, address indexed to, uint256 value);
98 }
99 
100 /**
101  * @title ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public view returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 
112 contract Crowdsale {
113   using SafeMath for uint256;
114 
115   // The token being sold
116   ERC20 public token;
117 
118   // Address where funds are collected
119   address public wallet;
120 
121   // How many token units a buyer gets per wei
122   uint256 public rate;
123 
124   // Amount of wei raised
125   uint256 public weiRaised;
126 
127   /**
128    * Event for token purchase logging
129    * @param purchaser who paid for the tokens
130    * @param beneficiary who got the tokens
131    * @param value weis paid for purchase
132    * @param amount amount of tokens purchased
133    */
134   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
135 
136   /**
137    * @param _rate Number of token units a buyer gets per wei
138    * @param _wallet Address where collected funds will be forwarded to
139    * @param _token Address of the token being sold
140    */
141   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
142     require(_rate > 0);
143     require(_wallet != address(0));
144     require(_token != address(0));
145 
146     rate = _rate;
147     wallet = _wallet;
148     token = _token;
149   }
150 
151   // -----------------------------------------
152   // Crowdsale external interface
153   // -----------------------------------------
154 
155   /**
156    * @dev fallback function ***DO NOT OVERRIDE***
157    */
158   function () external payable {
159     buyTokens(msg.sender);
160   }
161 
162   /**
163    * @dev low level token purchase ***DO NOT OVERRIDE***
164    * @param _beneficiary Address performing the token purchase
165    */
166   function buyTokens(address _beneficiary) public payable {
167 
168     uint256 weiAmount = msg.value;
169     _preValidatePurchase(_beneficiary, weiAmount);
170 
171     // calculate token amount to be created
172     uint256 tokens = _getTokenAmount(weiAmount);
173 
174     // update state
175     weiRaised = weiRaised.add(weiAmount);
176 
177    TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
178     _processPurchase(_beneficiary, tokens);
179     
180   
181     _updatePurchasingState(_beneficiary, weiAmount);
182 
183     _forwardFunds();
184     _postValidatePurchase(_beneficiary, weiAmount);
185   }
186 
187   // -----------------------------------------
188   // Internal interface (extensible)
189   // -----------------------------------------
190 
191   /**
192    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
193    * @param _beneficiary Address performing the token purchase
194    * @param _weiAmount Value in wei involved in the purchase
195    */
196   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
197     require(_beneficiary != address(0));
198     require(_weiAmount != 0);
199   }
200 
201   /**
202    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
203    * @param _beneficiary Address performing the token purchase
204    * @param _weiAmount Value in wei involved in the purchase
205    */
206   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
207     // optional override
208   }
209 
210   /**
211    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
212    * @param _beneficiary Address performing the token purchase
213    * @param _tokenAmount Number of tokens to be emitted
214    */
215   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
216     token.transfer(_beneficiary, _tokenAmount);
217   }
218 
219   /**
220    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
221    * @param _beneficiary Address receiving the tokens
222    * @param _tokenAmount Number of tokens to be purchased
223    */
224   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
225     _deliverTokens(_beneficiary, _tokenAmount);
226   }
227 
228   /**
229    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
230    * @param _beneficiary Address receiving the tokens
231    * @param _weiAmount Value in wei involved in the purchase
232    */
233   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
234     // optional override
235   }
236 
237   /**
238    * @dev Override to extend the way in which ether is converted to tokens.
239    * @param _weiAmount Value in wei to be converted into tokens
240    * @return Number of tokens that can be purchased with the specified _weiAmount
241    */
242   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
243     return _weiAmount.mul(rate);
244   }
245 
246   /**
247    * @dev Determines how ETH is stored/forwarded on purchases.
248    */
249   function _forwardFunds() internal {
250     wallet.transfer(msg.value);
251   }
252 }
253 
254 
255 
256 /**
257  * @title TimedCrowdsale
258  * @dev Crowdsale accepting contributions only within a time frame.
259  */
260 contract TimedCrowdsale is Crowdsale {
261   using SafeMath for uint256;
262 
263   uint256 public openingTime;
264   uint256 public closingTime;
265 
266   /**
267    * @dev Reverts if not in crowdsale time range.
268    */
269   modifier onlyWhileOpen {
270     require(now >= openingTime && now <= closingTime);
271     _;
272   }
273 
274   /**
275    * @dev Constructor, takes crowdsale opening and closing times.
276    * @param _openingTime Crowdsale opening time
277    * @param _closingTime Crowdsale closing time
278    */
279   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
280     require(_openingTime >= now);
281     require(_closingTime >= _openingTime);
282 
283     openingTime = _openingTime;
284     closingTime = _closingTime;
285   }
286 
287   /**
288    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
289    * @return Whether crowdsale period has elapsed
290    */
291   function hasClosed() public view returns (bool) {
292     return now > closingTime;
293   }
294 
295   /**
296    * @dev Extend parent behavior requiring to be within contributing period
297    * @param _beneficiary Token purchaser
298    * @param _weiAmount Amount of wei contributed
299    */
300   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
301     super._preValidatePurchase(_beneficiary, _weiAmount);
302   }
303 
304 }
305 
306 
307 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
308   using SafeMath for uint256;
309 
310   bool public isFinalized = false;
311 
312   event Finalized();
313 
314   /**
315    * @dev Must be called after crowdsale ends, to do some extra finalization
316    * work. Calls the contract's finalization function.
317    */
318   function finalize() onlyOwner public {
319    
320     require(!isFinalized);
321     require(hasClosed());
322 
323     finalization();
324     Finalized();
325 
326     isFinalized = true;
327   }
328 
329   /**
330    * @dev Can be overridden to add finalization logic. The overriding function
331    * should call super.finalization() to ensure the chain of finalization is
332    * executed entirely.
333    */
334   function finalization() internal {
335   }
336 }
337 
338 
339 /**
340  * @title Basic token
341  * @dev Basic version of StandardToken, with no allowances.
342  */
343 contract BasicToken is ERC20Basic {
344   using SafeMath for uint256;
345 
346   mapping(address => uint256) balances;
347 
348   uint256 totalSupply_;
349   
350   /**
351   * @dev total number of tokens in existence
352   */
353   function totalSupply() public view returns (uint256) {
354     return totalSupply_;
355   }
356 
357   /**
358   * @dev transfer token for a specified address
359   * @param _to The address to transfer to.
360   * @param _value The amount to be transferred.
361   */
362  
363   function transfer(address _to, uint256 _value) public  returns (bool) {
364       
365   
366     require(_to != address(0));
367     require(_value <= balances[msg.sender]);
368     // SafeMath.sub will throw if there is not enough balance.
369     balances[msg.sender] = balances[msg.sender].sub(_value);
370     balances[_to] = balances[_to].add(_value);
371     Transfer(msg.sender, _to, _value);
372     return true;
373   }
374 
375   /**
376   * @dev Gets the balance of the specified address.
377   * @param _owner The address to query the the balance of.
378   * @return An uint256 representing the amount owned by the passed address.
379   */
380   function balanceOf(address _owner) public view returns (uint256 balance) {
381     return balances[_owner];
382   }
383 
384 }
385 
386 
387 /**
388  * @title Standard ERC20 token
389  *
390  * @dev Implementation of the basic standard token.
391  * @dev https://github.com/ethereum/EIPs/issues/20
392  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
393  */
394 contract StandardToken is ERC20, BasicToken {
395 
396   mapping (address => mapping (address => uint256)) internal allowed;
397 
398 
399   /**
400    * @dev Transfer tokens from one address to another
401    * @param _from address The address which you want to send tokens from
402    * @param _to address The address which you want to transfer to
403    * @param _value uint256 the amount of tokens to be transferred
404    */
405   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
406     require(_to != address(0));
407     require(_value <= balances[_from]);
408     require(_value <= allowed[_from][msg.sender]);
409 
410     balances[_from] = balances[_from].sub(_value);
411     balances[_to] = balances[_to].add(_value);
412     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
413     Transfer(_from, _to, _value);
414     return true;
415   }
416 
417   /**
418    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
419    *
420    * Beware that changing an allowance with this method brings the risk that someone may use both the old
421    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
422    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
423    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
424    * @param _spender The address which will spend the funds.
425    * @param _value The amount of tokens to be spent.
426    */
427   function approve(address _spender, uint256 _value) public returns (bool) {
428     allowed[msg.sender][_spender] = _value;
429     Approval(msg.sender, _spender, _value);
430     return true;
431   }
432 
433   /**
434    * @dev Function to check the amount of tokens that an owner allowed to a spender.
435    * @param _owner address The address which owns the funds.
436    * @param _spender address The address which will spend the funds.
437    * @return A uint256 specifying the amount of tokens still available for the spender.
438    */
439   function allowance(address _owner, address _spender) public view returns (uint256) {
440     return allowed[_owner][_spender];
441   }
442 
443   /**
444    * @dev Increase the amount of tokens that an owner allowed to a spender.
445    *
446    * approve should be called when allowed[_spender] == 0. To increment
447    * allowed value is better to use this function to avoid 2 calls (and wait until
448    * the first transaction is mined)
449    * From MonolithDAO Token.sol
450    * @param _spender The address which will spend the funds.
451    * @param _addedValue The amount of tokens to increase the allowance by.
452    */
453   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
454     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
455     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
456     return true;
457   }
458 
459   /**
460    * @dev Decrease the amount of tokens that an owner allowed to a spender.
461    *
462    * approve should be called when allowed[_spender] == 0. To decrement
463    * allowed value is better to use this function to avoid 2 calls (and wait until
464    * the first transaction is mined)
465    * From MonolithDAO Token.sol
466    * @param _spender The address which will spend the funds.
467    * @param _subtractedValue The amount of tokens to decrease the allowance by.
468    */
469   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
470     uint oldValue = allowed[msg.sender][_spender];
471     if (_subtractedValue > oldValue) {
472       allowed[msg.sender][_spender] = 0;
473     } else {
474       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
475     }
476     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
477     return true;
478   }
479 
480 }
481 
482 
483 contract MintableToken is StandardToken, Ownable {
484   event Mint(address indexed to, uint256 amount);
485   event MintFinished();
486 
487   bool public mintingFinished = false;
488 
489 
490   modifier canMint() {
491     require(!mintingFinished);
492     _;
493   }
494 
495   /**
496    * @dev Function to mint tokens
497    * @param _to The address that will receive the minted tokens.
498    * @param _amount The amount of tokens to mint.
499    * @return A boolean that indicates if the operation was successful.
500    */
501   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
502     totalSupply_ = totalSupply_.add(_amount);
503     balances[_to] = balances[_to].add(_amount);
504     Mint(_to, _amount);
505     Transfer(address(0), _to, _amount);
506     return true;
507   }
508 
509   /**
510    * @dev Function to stop minting new tokens.
511    * @return True if the operation was successful.
512    */
513   function finishMinting() onlyOwner canMint public returns (bool) {
514     mintingFinished = true;
515     MintFinished();
516     return true;
517   }
518 }
519 
520 /**
521  * @title CappedCrowdsale
522  * @dev Crowdsale with a limit for total contributions.
523  */
524 contract CappedCrowdsale is Crowdsale {
525   using SafeMath for uint256;
526 
527   uint256 public cap;
528 
529   /**
530    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
531    * @param _cap Max amount of wei to be contributed
532    */
533   function CappedCrowdsale(uint256 _cap) public {
534     require(_cap > 0);
535     cap = _cap;
536   }
537 
538   /**
539    * @dev Checks whether the cap has been reached.
540    * @return Whether the cap was reached
541    */
542   function capReached() public view returns (bool) {
543     return weiRaised >= cap;
544   }
545 
546   /**
547    * @dev Extend parent behavior requiring purchase to respect the funding cap.
548    * @param _beneficiary Token purchaser
549    * @param _weiAmount Amount of wei contributed
550    */
551   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
552     super._preValidatePurchase(_beneficiary, _weiAmount);
553     require(weiRaised.add(_weiAmount) <= cap);
554   }
555 
556 }
557 
558 contract WhitelistedCrowdsale is Crowdsale, Ownable {
559 
560   mapping(address => bool) public whitelist;
561 
562   /**
563    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
564    */
565   modifier isWhitelisted(address _beneficiary) {
566     require(whitelist[_beneficiary]);
567     _;
568   }
569 
570   /**
571    * @dev Adds single address to whitelist.
572    * @param _beneficiary Address to be added to the whitelist
573    */
574   function addToWhitelist(address _beneficiary) external onlyOwner {
575     whitelist[_beneficiary] = true;
576   }
577 
578   /**
579    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
580    * @param _beneficiaries Addresses to be added to the whitelist
581    */
582   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
583     for (uint256 i = 0; i < _beneficiaries.length; i++) {
584       whitelist[_beneficiaries[i]] = true;
585     }
586   }
587 
588   /**
589    * @dev Removes single address from whitelist.
590    * @param _beneficiary Address to be removed to the whitelist
591    */
592   function removeFromWhitelist(address _beneficiary) external onlyOwner {
593     whitelist[_beneficiary] = false;
594   }
595 
596   /**
597    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
598    * @param _beneficiary Token beneficiary
599    * @param _weiAmount Amount of wei contributed
600    */
601   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
602     super._preValidatePurchase(_beneficiary, _weiAmount);
603   }
604 
605 }
606 
607 
608 
609 
610 /**
611  * @title MintedCrowdsale
612  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
613  * Token ownership should be transferred to MintedCrowdsale for minting.
614  */
615 contract MintedCrowdsale is Crowdsale {
616 
617   /**
618   * @dev Overrides delivery by minting tokens upon purchase.
619   * @param _beneficiary Token purchaser
620   * @param _tokenAmount Number of tokens to be minted
621   */
622   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
623     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
624   }
625 }
626 
627 
628 
629 /**
630  * @title DagtCrowdsale
631  * @dev DAGT Token that can be minted.
632  * It is meant to be used in a crowdsale contract.
633  */
634 contract DagtCrowdsale is CappedCrowdsale, MintedCrowdsale, FinalizableCrowdsale, WhitelistedCrowdsale {
635     using SafeMath for uint256;
636     // Constants
637     string public constant version = "1.1";
638     // DAGT token unit.1000000000000000000
639     // Using same decimal value as ETH (makes ETH-DAGT conversion much easier).
640     // This is the same as in DAGT token contract.
641     uint256 public constant TOKEN_UNIT = 10 ** 18;
642     // Maximum number of tokens in circulation
643     uint256 public constant MAX_TOKENS = 100000000 * TOKEN_UNIT;
644     // Values should be 10x percents, value 1000 = 100%
645     uint public constant BONUS_COEFF = 1000; 
646     // Variables
647     address public remainingTokensWallet;
648     uint public lockingRatio;
649     uint256 public minWeiAmount;
650 
651      // The following will be populated by main crowdsale contract
652     uint32[] public BONUS_TIMES;
653     uint32[] public BONUS_TIMES_VALUES;
654     uint256[] public BONUS_AMOUNTS;
655     uint32[] public BONUS_AMOUNTS_VALUES;
656     /**
657     * @dev Constructor, takes crowdsale opening and closing times.
658     * @param _openingTime crowdsale opening time
659     * @param _closingTime crowdsale closing time
660     * @param _rate Number of token units a buyer gets per wei
661     * @param _wallet Address where collected funds will be forwarded to
662     * @param _remainingTokensWallet remaining tokens wallet
663     * @param _cap Max amount of wei to be contributed
664     * @param _lockingRatio locking ratio except bunus
665     * @param _token Address of the token being sold
666     */
667     function DagtCrowdsale(uint256 _openingTime, uint256 _closingTime, uint256 _rate, address _wallet, address _remainingTokensWallet, uint256 _cap, uint _lockingRatio, MintableToken _token) public
668         Crowdsale(_rate, _wallet, _token)
669         CappedCrowdsale(_cap)
670         TimedCrowdsale(_openingTime, _closingTime) {
671             
672         require(_remainingTokensWallet != address(0));
673         remainingTokensWallet = _remainingTokensWallet;
674         setLockedRatio(_lockingRatio);
675     }
676     /**
677     * @dev Checks whether _beneficiary in whitelisted for the Presale And sale.
678     * @param _beneficiary , User's Address. 
679     * @return Whether _beneficiary in whitelisted.
680     */
681     function isWhitelistedAddress(address _beneficiary) public constant returns (bool) {
682         return whitelist[_beneficiary];
683     }
684     /**
685     * @dev Override to extend the way in which ether is converted to tokens.
686     * @param _weiAmount Value in wei to be converted into tokens
687     * @return Number of tokens that can be purchased with the specified _weiAmount
688     */
689     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
690         return computeTokens(_weiAmount);
691     }
692     /**
693     * @dev Can be overridden to add finalization logic. The overriding function
694     * should call super.finalization() to ensure the chain of finalization is
695     * executed entirely.
696     */
697     function finalization() internal {
698         //DAGT gets 20% of the amount of the total token supply
699         uint256 totalSupply = token.totalSupply();
700         // // total remaining Tokens
701         //MintableToken token = MintableToken(token);
702         MintableToken(token).mint(remainingTokensWallet,MAX_TOKENS.sub(totalSupply));
703         MintableToken(token).finishMinting();
704         //===================================================================
705         super.finalization();
706     }
707     /**
708     * @dev Overridden TimedCrowdsale, takes crowdsale opening and closing times.
709     * @param _openingTime Crowdsale opening time
710     * @param _closingTime Crowdsale closing time
711     */
712     function setTimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public onlyOwner {
713         // require(_openingTime >= now);
714         require(_closingTime >= _openingTime);
715 
716         openingTime = _openingTime;
717         closingTime = _closingTime;
718     }
719     /**
720     * @dev Computes overall bonus based on time of contribution and amount of contribution. 
721     * The total bonus is the sum of bonus by time and bonus by amount
722     * @return tokens 
723     */
724     function computeTokens(uint256 _weiAmount) public constant returns(uint256) {
725         if(_weiAmount < minWeiAmount){ 
726             return 0;
727         }
728         
729         uint256 tokens = _weiAmount.mul(rate.mul(computeTimeBonus(now))).div(BONUS_COEFF);
730         uint256 bonus = tokens.mul(computeAmountBonus(_weiAmount)).div(BONUS_COEFF);
731         return tokens.div(lockingRatio).add(bonus);
732     }
733     /**
734     * @dev Set the Minimum of investment. 
735     * @param _minWeiAmount Value in wei
736     */
737     function setMinAmount(uint256 _minWeiAmount)  public onlyOwner{
738         require(_minWeiAmount > uint256(0));
739         minWeiAmount = _minWeiAmount;
740     }
741     
742    /**
743     * @dev Set the lockingRatio  of  total bonus that is the sum of bonus by time. 
744     * @param _lockingRatio locking ratio except bunus
745     */
746     function setLockedRatio(uint _lockingRatio)  public onlyOwner{
747         require(_lockingRatio > uint(0));
748         lockingRatio = _lockingRatio;
749     }
750     /**
751      * * @dev Computes bonus based on time of contribution relative to the beginning of crowdsale
752     * @return bonus 
753     */
754     function computeTimeBonus(uint256 _time) public constant returns(uint256) {
755         require(_time >= openingTime);
756 
757         for (uint i = 0; i < BONUS_TIMES.length; i++) {
758             if (_time.sub(openingTime) <= BONUS_TIMES[i]) {
759                 return BONUS_TIMES_VALUES[i];
760             }
761         }
762         return 0;
763     }
764 
765     /**
766     * @dev Computes bonus based on amount of contribution
767     * @return bonus 
768     */
769     function computeAmountBonus(uint256 _weiAmount) public constant returns(uint256) {
770         for (uint i = 0; i < BONUS_AMOUNTS.length; i++) {
771             if (_weiAmount >= BONUS_AMOUNTS[i]) {
772                 return BONUS_AMOUNTS_VALUES[i];
773             }
774         }
775         return 0;
776     }
777       /**
778     * @dev Retrieve length of bonuses by time array
779     * @return Bonuses by time array length
780     */
781     function bonusesForTimesCount() public constant returns(uint) {
782         return BONUS_TIMES.length;
783     }
784 
785     /**
786     * @dev Sets bonuses for time
787     */
788     function setBonusesForTimes(uint32[] times, uint32[] values) public onlyOwner {
789         require(times.length == values.length);
790         for (uint i = 0; i + 1 < times.length; i++) {
791             require(times[i] < times[i+1]);
792         }
793 
794         BONUS_TIMES = times;
795         BONUS_TIMES_VALUES = values;
796     }
797 
798     /**
799     * @dev Retrieve length of bonuses by amounts array
800     * @return Bonuses by amounts array length
801     */
802     function bonusesForAmountsCount() public constant returns(uint) {
803         return BONUS_AMOUNTS.length;
804     }
805 
806     /**
807     * @dev Sets bonuses for USD amounts
808     */
809     function setBonusesForAmounts(uint256[] amounts, uint32[] values) public onlyOwner {
810         require(amounts.length == values.length);
811         for (uint i = 0; i + 1 < amounts.length; i++) {
812             require(amounts[i] > amounts[i+1]);
813         }
814 
815         BONUS_AMOUNTS = amounts;
816         BONUS_AMOUNTS_VALUES = values;
817     }
818 
819 }