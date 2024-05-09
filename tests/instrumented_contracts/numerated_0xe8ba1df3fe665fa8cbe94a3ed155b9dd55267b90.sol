1 pragma solidity ^0.4.18;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
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
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
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
91     emit Transfer(msg.sender, _to, _value);
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
106 contract BurnableToken is BasicToken {
107 
108   event Burn(address indexed burner, uint256 value);
109 
110   /**
111    * @dev Burns a specific amount of tokens.
112    * @param _value The amount of token to be burned.
113    */
114   function burn(uint256 _value) public {
115     require(_value <= balances[msg.sender]);
116     // no need to require value <= totalSupply, since that would imply the
117     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
118 
119     address burner = msg.sender;
120     balances[burner] = balances[burner].sub(_value);
121     totalSupply_ = totalSupply_.sub(_value);
122     emit Burn(burner, _value);
123     emit Transfer(burner, address(0), _value);
124   }
125 }
126 
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 is ERC20Basic {
132   function allowance(address owner, address spender) public view returns (uint256);
133   function transferFrom(address from, address to, uint256 value) public returns (bool);
134   function approve(address spender, uint256 value) public returns (bool);
135   event Approval(address indexed owner, address indexed spender, uint256 value);
136 }
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * @dev https://github.com/ethereum/EIPs/issues/20
143  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157     require(_to != address(0));
158     require(_value <= balances[_from]);
159     require(_value <= allowed[_from][msg.sender]);
160 
161     balances[_from] = balances[_from].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164     emit Transfer(_from, _to, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170    *
171    * Beware that changing an allowance with this method brings the risk that someone may use both the old
172    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    * @param _spender The address which will spend the funds.
176    * @param _value The amount of tokens to be spent.
177    */
178   function approve(address _spender, uint256 _value) public returns (bool) {
179     allowed[msg.sender][_spender] = _value;
180     emit Approval(msg.sender, _spender, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Function to check the amount of tokens that an owner allowed to a spender.
186    * @param _owner address The address which owns the funds.
187    * @param _spender address The address which will spend the funds.
188    * @return A uint256 specifying the amount of tokens still available for the spender.
189    */
190   function allowance(address _owner, address _spender) public view returns (uint256) {
191     return allowed[_owner][_spender];
192   }
193 
194   /**
195    * @dev Increase the amount of tokens that an owner allowed to a spender.
196    *
197    * approve should be called when allowed[_spender] == 0. To increment
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _addedValue The amount of tokens to increase the allowance by.
203    */
204   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
205     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
206     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210   /**
211    * @dev Decrease the amount of tokens that an owner allowed to a spender.
212    *
213    * approve should be called when allowed[_spender] == 0. To decrement
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param _spender The address which will spend the funds.
218    * @param _subtractedValue The amount of tokens to decrease the allowance by.
219    */
220   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
221     uint oldValue = allowed[msg.sender][_spender];
222     if (_subtractedValue > oldValue) {
223       allowed[msg.sender][_spender] = 0;
224     } else {
225       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
226     }
227     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231 }
232 
233 /**
234  * @title Ownable
235  * @dev The Ownable contract has an owner address, and provides basic authorization control
236  * functions, this simplifies the implementation of "user permissions".
237  */
238 contract Ownable {
239   address public owner;
240 
241 
242   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
243 
244 
245   /**
246    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
247    * account.
248    */
249   function Ownable() public {
250     owner = msg.sender;
251   }
252 
253   /**
254    * @dev Throws if called by any account other than the owner.
255    */
256   modifier onlyOwner() {
257     require(msg.sender == owner);
258     _;
259   }
260 
261   /**
262    * @dev Allows the current owner to transfer control of the contract to a newOwner.
263    * @param newOwner The address to transfer ownership to.
264    */
265   function transferOwnership(address newOwner) public onlyOwner {
266     require(newOwner != address(0));
267     emit OwnershipTransferred(owner, newOwner);
268     owner = newOwner;
269   }
270 
271 }
272 
273 /**
274  * @title Mintable token
275  * @dev Simple ERC20 Token example, with mintable token creation
276  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
277  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
278  */
279 contract MintableToken is StandardToken, Ownable {
280   event Mint(address indexed to, uint256 amount);
281   event MintFinished();
282   event MintResumed();
283 
284   bool public mintingFinished = false;
285 
286   uint256 public maxSupply;
287 
288   function MintableToken(uint256 _maxSupply) public {
289     require(_maxSupply > 0);
290 
291     maxSupply = _maxSupply;
292   }
293 
294 
295   modifier canMint() {
296     require(!mintingFinished);
297     _;
298   }
299 
300   modifier isWithinLimit(uint256 amount) {
301     require((totalSupply_.add(amount)) <= maxSupply);
302     _;
303   }
304 
305   modifier canNotMint() {
306     require(mintingFinished);
307     _;
308   }
309 
310   /**
311    * @dev Function to mint tokens
312    * @param _to The address that will receive the minted tokens.
313    * @param _amount The amount of tokens to mint.
314    * @return A boolean that indicates if the operation was successful.
315    */
316   function mint(address _to, uint256 _amount) onlyOwner canMint isWithinLimit(_amount) public returns (bool) {
317     totalSupply_ = totalSupply_.add(_amount);
318     balances[_to] = balances[_to].add(_amount);
319     emit Mint(_to, _amount);
320     emit Transfer(address(0), _to, _amount);
321     return true;
322   }
323 
324   /**
325    * @dev Function to stop minting new tokens.
326    * @return True if the operation was successful.
327    */
328   function finishMinting() onlyOwner canMint public returns (bool) {
329     mintingFinished = true;
330     emit MintFinished();
331     return true;
332   }
333 
334   /**
335    * @dev Function to resume minting new tokens.
336    * @return True if the operation was successful.
337    */
338   function resumeMinting() onlyOwner canNotMint public returns (bool) {
339     mintingFinished = false;
340     emit MintResumed();
341     return true;
342   }
343 }
344 
345 /**
346  * @title Pausable
347  * @dev Base contract which allows children to implement an emergency stop mechanism.
348  */
349 contract Pausable is Ownable {
350   event Pause();
351   event Unpause();
352 
353   bool public paused = true;
354 
355 
356   /**
357    * @dev Modifier to make a function callable only when the contract is not paused.
358    */
359   modifier whenNotPaused() {
360     require(!paused);
361     _;
362   }
363 
364   /**
365    * @dev Modifier to make a function callable only when the contract is paused.
366    */
367   modifier whenPaused() {
368     require(paused);
369     _;
370   }
371 
372   /**
373    * @dev called by the owner to pause, triggers stopped state
374    */
375   function pause() onlyOwner whenNotPaused public {
376     paused = true;
377     emit Pause();
378   }
379 
380   /**
381    * @dev called by the owner to unpause, returns to normal state
382    */
383   function unpause() onlyOwner whenPaused public {
384     paused = false;
385     emit Unpause();
386   }
387 }
388 
389 /**
390  * @title Pausable token
391  * @dev StandardToken modified with pausable transfers.
392  **/
393 contract PausableToken is StandardToken, Pausable {
394 
395   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
396     return super.transfer(_to, _value);
397   }
398 
399   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
400     return super.transferFrom(_from, _to, _value);
401   }
402 
403   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
404     return super.approve(_spender, _value);
405   }
406 
407   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
408     return super.increaseApproval(_spender, _addedValue);
409   }
410 
411   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
412     return super.decreaseApproval(_spender, _subtractedValue);
413   }
414 }
415 
416 /**
417  * @title INCXToken
418  * @dev This is a standard ERC20 token
419  */
420 contract INCXToken is BurnableToken, PausableToken, MintableToken {
421   string public constant name = "INCX Coin";
422   string public constant symbol = "INCX";
423   uint64 public constant decimals = 18;
424   uint256 public constant maxLimit = 1000000000 * 10**uint(decimals);
425 
426   function INCXToken()
427     public
428     MintableToken(maxLimit)
429   {
430   }
431 }
432 
433 /**
434  * @title Crowdsale
435  * @dev Crowdsale is a base contract for managing a token crowdsale,
436  * allowing investors to purchase tokens with ether. This contract implements
437  * such functionality in its most fundamental form and can be extended to provide additional
438  * functionality and/or custom behavior.
439  * The external interface represents the basic interface for purchasing tokens, and conform
440  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
441  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
442  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
443  * behavior.
444  */
445 
446 contract Crowdsale {
447   using SafeMath for uint256;
448 
449   // The token being sold
450   ERC20 public token;
451 
452   // Address where funds are collected
453   address public wallet;
454 
455   // How many token units a buyer gets per wei
456   uint256 public rate;
457 
458   // Amount of wei raised
459   uint256 public weiRaised;
460 
461   /**
462    * Event for token purchase logging
463    * @param purchaser who paid for the tokens
464    * @param beneficiary who got the tokens
465    * @param value weis paid for purchase
466    * @param amount amount of tokens purchased
467    */
468   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
469 
470   /**
471    * @param _rate Number of token units a buyer gets per wei
472    * @param _wallet Address where collected funds will be forwarded to
473    * @param _token Address of the token being sold
474    */
475   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
476     require(_rate > 0);
477     require(_wallet != address(0));
478     require(_token != address(0));
479 
480     rate = _rate;
481     wallet = _wallet;
482     token = _token;
483   }
484 
485   // -----------------------------------------
486   // Crowdsale external interface
487   // -----------------------------------------
488 
489   /**
490    * @dev fallback function ***DO NOT OVERRIDE***
491    */
492   function () external payable {
493     buyTokens(msg.sender);
494   }
495 
496   /**
497    * @dev low level token purchase ***DO NOT OVERRIDE***
498    * @param _beneficiary Address performing the token purchase
499    */
500   function buyTokens(address _beneficiary) public payable {
501     uint256 weiAmount = msg.value;
502     _preValidatePurchase(_beneficiary, weiAmount);
503 
504     // calculate token amount to be created
505     uint256 tokens = _getTokenAmount(weiAmount);
506 
507     // update state
508     weiRaised = weiRaised.add(weiAmount);
509 
510     _processPurchase(_beneficiary, tokens);
511     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
512 
513     _updatePurchasingState(_beneficiary, weiAmount);
514 
515     _forwardFunds();
516     _postValidatePurchase(_beneficiary, weiAmount);
517   }
518 
519   // -----------------------------------------
520   // Internal interface (extensible)
521   // -----------------------------------------
522 
523   /**
524    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
525    * @param _beneficiary Address performing the token purchase
526    * @param _weiAmount Value in wei involved in the purchase
527    */
528   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
529     require(_beneficiary != address(0));
530     require(_weiAmount != 0);
531   }
532 
533   /**
534    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
535    * @param _beneficiary Address performing the token purchase
536    * @param _weiAmount Value in wei involved in the purchase
537    */
538   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
539     // optional override
540   }
541 
542   /**
543    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
544    * @param _beneficiary Address performing the token purchase
545    * @param _tokenAmount Number of tokens to be emitted
546    */
547   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
548     token.transfer(_beneficiary, _tokenAmount);
549   }
550 
551   /**
552    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
553    * @param _beneficiary Address receiving the tokens
554    * @param _tokenAmount Number of tokens to be purchased
555    */
556   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
557     _deliverTokens(_beneficiary, _tokenAmount);
558   }
559 
560   /**
561    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
562    * @param _beneficiary Address receiving the tokens
563    * @param _weiAmount Value in wei involved in the purchase
564    */
565   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
566     // optional override
567   }
568 
569   /**
570    * @dev Override to extend the way in which ether is converted to tokens.
571    * @param _weiAmount Value in wei to be converted into tokens
572    * @return Number of tokens that can be purchased with the specified _weiAmount
573    */
574   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
575     return _weiAmount.mul(rate);
576   }
577 
578   /**
579    * @dev Determines how ETH is stored/forwarded on purchases.
580    */
581   function _forwardFunds() internal {
582     wallet.transfer(msg.value);
583   }
584 }
585 
586 /**
587  * @title MintedCrowdsale
588  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
589  * Token ownership should be transferred to MintedCrowdsale for minting. 
590  */
591 contract MintedCrowdsale is Crowdsale {
592 
593   /**
594    * @dev Overrides delivery by minting tokens upon purchase.
595    * @param _beneficiary Token purchaser
596    * @param _tokenAmount Number of tokens to be minted
597    */
598   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
599     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
600   }
601 }
602 
603 /**
604  * @title TimedCrowdsale
605  * @dev Crowdsale accepting contributions only within a time frame.
606  */
607 contract TimedCrowdsale is Crowdsale {
608   using SafeMath for uint256;
609 
610   uint256 public openingTime;
611   uint256 public closingTime;
612 
613   /**
614    * @dev Reverts if not in crowdsale time range. 
615    */
616   modifier onlyWhileOpen {
617     require(now >= openingTime && now <= closingTime);
618     _;
619   }
620 
621   /**
622    * @dev Constructor, takes crowdsale opening and closing times.
623    * @param _openingTime Crowdsale opening time
624    * @param _closingTime Crowdsale closing time
625    */
626   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
627     require(_openingTime >= now);
628     require(_closingTime >= _openingTime);
629 
630     openingTime = _openingTime;
631     closingTime = _closingTime;
632   }
633 
634   /**
635    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
636    * @return Whether crowdsale period has elapsed
637    */
638   function hasClosed() public view returns (bool) {
639     return now > closingTime;
640   }
641   
642   /**
643    * @dev Extend parent behavior requiring to be within contributing period
644    * @param _beneficiary Token purchaser
645    * @param _weiAmount Amount of wei contributed
646    */
647   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
648     super._preValidatePurchase(_beneficiary, _weiAmount);
649   }
650 
651 }
652 
653 /**
654  * @title FinalizableCrowdsale
655  * @dev Extension of Crowdsale where an owner can do extra work
656  * after finishing.
657  */
658 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
659   using SafeMath for uint256;
660 
661   bool public isFinalized = false;
662 
663   event Finalized();
664 
665   /**
666    * @dev Must be called after crowdsale ends, to do some extra finalization
667    * work. Calls the contract's finalization function.
668    */
669   function finalize() onlyOwner public {
670     require(!isFinalized);
671     require(hasClosed());
672 
673     finalization();
674     emit Finalized();
675 
676     isFinalized = true;
677   }
678 
679   /**
680    * @dev Can be overridden to add finalization logic. The overriding function
681    * should call super.finalization() to ensure the chain of finalization is
682    * executed entirely.
683    */
684   function finalization() internal {
685   }
686 }
687 
688 /**
689  * @title CappedCrowdsale
690  * @dev Crowdsale with a limit for total contributions.
691  */
692 contract CappedCrowdsale is Crowdsale {
693   using SafeMath for uint256;
694 
695   uint256 public cap;
696 
697   /**
698    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
699    * @param _cap Max amount of wei to be contributed
700    */
701   function CappedCrowdsale(uint256 _cap) public {
702     require(_cap > 0);
703     cap = _cap;
704   }
705 
706   /**
707    * @dev Checks whether the cap has been reached. 
708    * @return Whether the cap was reached
709    */
710   function capReached() public view returns (bool) {
711     return weiRaised >= cap;
712   }
713 
714   /**
715    * @dev Extend parent behavior requiring purchase to respect the funding cap.
716    * @param _beneficiary Token purchaser
717    * @param _weiAmount Amount of wei contributed
718    */
719   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
720     super._preValidatePurchase(_beneficiary, _weiAmount);
721     require(weiRaised.add(_weiAmount) <= cap);
722   }
723 
724 }
725 
726 /**
727  * @title WhitelistedCrowdsale
728  * @dev Crowdsale in which only whitelisted users can contribute.
729  */
730 contract WhitelistedCrowdsale is Crowdsale, Ownable {
731 
732   mapping(address => bool) public whitelist;
733 
734   /**
735    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
736    */
737   modifier isWhitelisted(address _beneficiary) {
738     require(whitelist[_beneficiary]);
739     _;
740   }
741 
742   /**
743    * @dev Adds single address to whitelist.
744    * @param _beneficiary Address to be added to the whitelist
745    */
746   function addToWhitelist(address _beneficiary) external onlyOwner {
747     whitelist[_beneficiary] = true;
748   }
749 
750   /**
751    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
752    * @param _beneficiaries Addresses to be added to the whitelist
753    */
754   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
755     for (uint256 i = 0; i < _beneficiaries.length; i++) {
756       whitelist[_beneficiaries[i]] = true;
757     }
758   }
759 
760   /**
761    * @dev Removes single address from whitelist.
762    * @param _beneficiary Address to be removed to the whitelist
763    */
764   function removeFromWhitelist(address _beneficiary) external onlyOwner {
765     whitelist[_beneficiary] = false;
766   }
767 
768   /**
769    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
770    * @param _beneficiary Token beneficiary
771    * @param _weiAmount Amount of wei contributed
772    */
773   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
774     super._preValidatePurchase(_beneficiary, _weiAmount);
775   }
776 
777 }
778 
779 contract IndividualCapCrowdsale is Crowdsale, Ownable {
780   using SafeMath for uint256;
781 
782   uint256 public minAmount;
783   uint256 public maxAmount;
784 
785   mapping(address => uint256) public contributions;
786 
787   function IndividualCapCrowdsale(uint256 _minAmount, uint256 _maxAmount) public {
788     require(_minAmount > 0);
789     require(_maxAmount > _minAmount);
790 
791     minAmount = _minAmount;
792     maxAmount = _maxAmount;
793   }
794 
795   /**
796    * @dev Set the minimum amount in wei that can be invested per each purchase
797    * @param _minAmount Minimum Amount of wei to be invested per each purchase
798    */
799   function setMinAmount(uint256 _minAmount) public onlyOwner {
800     require(_minAmount > 0);
801     require(_minAmount < maxAmount);
802 
803     minAmount = _minAmount;
804   }
805 
806   /**
807    * @dev Set the overall maximum amount in wei that can be invested by user
808    * @param _maxAmount Maximum Amount of wei allowed to be invested by any user
809    */
810   function setMaxAmount(uint256 _maxAmount) public onlyOwner {
811     require(_maxAmount > 0);
812     require(_maxAmount > minAmount);
813 
814     maxAmount = _maxAmount;
815   }
816 
817   /**
818    * @dev Extend parent behavior requiring purchase to have minimum weiAmount and be within overall maxWeiAmount
819    * @param _beneficiary Token purchaser
820    * @param _weiAmount Amount of wei contributed
821    */
822   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
823     require(_weiAmount >= minAmount);
824     super._preValidatePurchase(_beneficiary, _weiAmount);
825     require(contributions[_beneficiary].add(_weiAmount) <= maxAmount);
826   }
827 
828   /**
829    * @dev Extend parent behavior to update user contributions
830    * @param _beneficiary Token purchaser
831    * @param _weiAmount Amount of wei contributed
832    */
833   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
834     super._updatePurchasingState(_beneficiary, _weiAmount);
835     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
836   }
837 }
838 
839 /**
840  * @title INCXPrivateSale
841  * @dev This smart contract administers private sale of incx token. It has following features:
842  * - There is a cap to how much ether can be raised
843  * - There is a time limit in which the tokens can be bought
844  * - Only whitelisted ethereum addresses can contribute (to enforce KYC)
845  * - There is a minimum ether limit on individual contribution per transaction
846  * - There is a maximum ether limit on total individual contribution
847  */
848 contract INCXPrivateSale is CappedCrowdsale, FinalizableCrowdsale, WhitelistedCrowdsale, IndividualCapCrowdsale, MintedCrowdsale {
849   event Refund(address indexed purchaser, uint256 tokens, uint256 weiReturned);
850   event TokensReturned(address indexed owner, uint256 tokens);
851   event EtherDepositedForRefund(address indexed sender,uint256 weiDeposited);
852   event EtherWithdrawn(address indexed wallet,uint256 weiWithdrawn);
853 
854   function INCXPrivateSale(uint256 _openingTime, uint256 _closingTime, uint256 _rate, address _wallet, uint256 _cap, INCXToken _token, uint256 _minAmount, uint256 _maxAmount)
855     public
856     Crowdsale(_rate, _wallet, _token)
857     CappedCrowdsale(_cap)
858     TimedCrowdsale(_openingTime, _closingTime)
859     IndividualCapCrowdsale(_minAmount, _maxAmount)
860   {
861   }
862 
863   /**
864    * @dev Transfer ownership of token back to wallet
865    */
866   function finalization() internal {
867     Ownable(token).transferOwnership(wallet);    
868   }
869 
870   function isOpen() public view returns (bool) {
871     return now >= openingTime;
872   }
873 
874   /**
875    * @dev Deposit ether with smart contract to allow refunds
876    */
877   function depositEtherForRefund() external payable {
878     emit EtherDepositedForRefund(msg.sender, msg.value);
879   }
880 
881   /**
882    * @dev Allow withdraw funds from smart contract
883    */
884   function withdraw() public onlyOwner {
885     uint256 returnAmount = this.balance;
886     wallet.transfer(returnAmount);
887     emit EtherWithdrawn(wallet, returnAmount);
888   }
889 
890   /**
891    * @dev This method refunds all the contribution that _purchaser has done
892    * @param _purchaser Token purchaser asking for refund
893    */
894   function refund(address _purchaser) public onlyOwner {
895     uint256 amountToRefund = contributions[_purchaser];
896     require(amountToRefund > 0);
897     require(weiRaised >= amountToRefund);
898     require(address(this).balance >= amountToRefund);
899     contributions[_purchaser] = 0;
900     uint256 _tokens = _getTokenAmount(amountToRefund);
901     weiRaised = weiRaised.sub(amountToRefund);
902     _purchaser.transfer(amountToRefund);
903     emit Refund(_purchaser, _tokens, amountToRefund);
904   }
905 }