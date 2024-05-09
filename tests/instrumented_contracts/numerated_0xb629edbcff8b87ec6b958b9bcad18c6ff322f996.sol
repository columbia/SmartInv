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
432 /**
433  * @title Crowdsale
434  * @dev Crowdsale is a base contract for managing a token crowdsale,
435  * allowing investors to purchase tokens with ether. This contract implements
436  * such functionality in its most fundamental form and can be extended to provide additional
437  * functionality and/or custom behavior.
438  * The external interface represents the basic interface for purchasing tokens, and conform
439  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
440  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
441  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
442  * behavior.
443  */
444 
445 contract Crowdsale {
446   using SafeMath for uint256;
447 
448   // The token being sold
449   ERC20 public token;
450 
451   // Address where funds are collected
452   address public wallet;
453 
454   // How many token units a buyer gets per wei
455   uint256 public rate;
456 
457   // Amount of wei raised
458   uint256 public weiRaised;
459 
460   /**
461    * Event for token purchase logging
462    * @param purchaser who paid for the tokens
463    * @param beneficiary who got the tokens
464    * @param value weis paid for purchase
465    * @param amount amount of tokens purchased
466    */
467   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
468 
469   /**
470    * @param _rate Number of token units a buyer gets per wei
471    * @param _wallet Address where collected funds will be forwarded to
472    * @param _token Address of the token being sold
473    */
474   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
475     require(_rate > 0);
476     require(_wallet != address(0));
477     require(_token != address(0));
478 
479     rate = _rate;
480     wallet = _wallet;
481     token = _token;
482   }
483 
484   // -----------------------------------------
485   // Crowdsale external interface
486   // -----------------------------------------
487 
488   /**
489    * @dev fallback function ***DO NOT OVERRIDE***
490    */
491   function () external payable {
492     buyTokens(msg.sender);
493   }
494 
495   /**
496    * @dev low level token purchase ***DO NOT OVERRIDE***
497    * @param _beneficiary Address performing the token purchase
498    */
499   function buyTokens(address _beneficiary) public payable {
500     uint256 weiAmount = msg.value;
501     _preValidatePurchase(_beneficiary, weiAmount);
502 
503     // calculate token amount to be created
504     uint256 tokens = _getTokenAmount(weiAmount);
505 
506     // update state
507     weiRaised = weiRaised.add(weiAmount);
508 
509     _processPurchase(_beneficiary, tokens);
510     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
511 
512     _updatePurchasingState(_beneficiary, weiAmount);
513 
514     _forwardFunds();
515     _postValidatePurchase(_beneficiary, weiAmount);
516   }
517 
518   // -----------------------------------------
519   // Internal interface (extensible)
520   // -----------------------------------------
521 
522   /**
523    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
524    * @param _beneficiary Address performing the token purchase
525    * @param _weiAmount Value in wei involved in the purchase
526    */
527   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
528     require(_beneficiary != address(0));
529     require(_weiAmount != 0);
530   }
531 
532   /**
533    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
534    * @param _beneficiary Address performing the token purchase
535    * @param _weiAmount Value in wei involved in the purchase
536    */
537   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
538     // optional override
539   }
540 
541   /**
542    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
543    * @param _beneficiary Address performing the token purchase
544    * @param _tokenAmount Number of tokens to be emitted
545    */
546   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
547     token.transfer(_beneficiary, _tokenAmount);
548   }
549 
550   /**
551    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
552    * @param _beneficiary Address receiving the tokens
553    * @param _tokenAmount Number of tokens to be purchased
554    */
555   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
556     _deliverTokens(_beneficiary, _tokenAmount);
557   }
558 
559   /**
560    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
561    * @param _beneficiary Address receiving the tokens
562    * @param _weiAmount Value in wei involved in the purchase
563    */
564   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
565     // optional override
566   }
567 
568   /**
569    * @dev Override to extend the way in which ether is converted to tokens.
570    * @param _weiAmount Value in wei to be converted into tokens
571    * @return Number of tokens that can be purchased with the specified _weiAmount
572    */
573   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
574     return _weiAmount.mul(rate);
575   }
576 
577   /**
578    * @dev Determines how ETH is stored/forwarded on purchases.
579    */
580   function _forwardFunds() internal {
581     wallet.transfer(msg.value);
582   }
583 }
584 
585 /**
586  * @title MintedCrowdsale
587  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
588  * Token ownership should be transferred to MintedCrowdsale for minting. 
589  */
590 contract MintedCrowdsale is Crowdsale {
591 
592   /**
593    * @dev Overrides delivery by minting tokens upon purchase.
594    * @param _beneficiary Token purchaser
595    * @param _tokenAmount Number of tokens to be minted
596    */
597   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
598     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
599   }
600 }
601 
602 /**
603  * @title TimedCrowdsale
604  * @dev Crowdsale accepting contributions only within a time frame.
605  */
606 contract TimedCrowdsale is Crowdsale {
607   using SafeMath for uint256;
608 
609   uint256 public openingTime;
610   uint256 public closingTime;
611 
612   /**
613    * @dev Reverts if not in crowdsale time range. 
614    */
615   modifier onlyWhileOpen {
616     require(now >= openingTime && now <= closingTime);
617     _;
618   }
619 
620   /**
621    * @dev Constructor, takes crowdsale opening and closing times.
622    * @param _openingTime Crowdsale opening time
623    * @param _closingTime Crowdsale closing time
624    */
625   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
626     require(_openingTime >= now);
627     require(_closingTime >= _openingTime);
628 
629     openingTime = _openingTime;
630     closingTime = _closingTime;
631   }
632 
633   /**
634    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
635    * @return Whether crowdsale period has elapsed
636    */
637   function hasClosed() public view returns (bool) {
638     return now > closingTime;
639   }
640   
641   /**
642    * @dev Extend parent behavior requiring to be within contributing period
643    * @param _beneficiary Token purchaser
644    * @param _weiAmount Amount of wei contributed
645    */
646   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
647     super._preValidatePurchase(_beneficiary, _weiAmount);
648   }
649 
650 }
651 
652 /**
653  * @title FinalizableCrowdsale
654  * @dev Extension of Crowdsale where an owner can do extra work
655  * after finishing.
656  */
657 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
658   using SafeMath for uint256;
659 
660   bool public isFinalized = false;
661 
662   event Finalized();
663 
664   /**
665    * @dev Must be called after crowdsale ends, to do some extra finalization
666    * work. Calls the contract's finalization function.
667    */
668   function finalize() onlyOwner public {
669     require(!isFinalized);
670     require(hasClosed());
671 
672     finalization();
673     emit Finalized();
674 
675     isFinalized = true;
676   }
677 
678   /**
679    * @dev Can be overridden to add finalization logic. The overriding function
680    * should call super.finalization() to ensure the chain of finalization is
681    * executed entirely.
682    */
683   function finalization() internal {
684   }
685 }
686 
687 /**
688  * @title CappedCrowdsale
689  * @dev Crowdsale with a limit for total contributions.
690  */
691 contract CappedCrowdsale is Crowdsale {
692   using SafeMath for uint256;
693 
694   uint256 public cap;
695 
696   /**
697    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
698    * @param _cap Max amount of wei to be contributed
699    */
700   function CappedCrowdsale(uint256 _cap) public {
701     require(_cap > 0);
702     cap = _cap;
703   }
704 
705   /**
706    * @dev Checks whether the cap has been reached. 
707    * @return Whether the cap was reached
708    */
709   function capReached() public view returns (bool) {
710     return weiRaised >= cap;
711   }
712 
713   /**
714    * @dev Extend parent behavior requiring purchase to respect the funding cap.
715    * @param _beneficiary Token purchaser
716    * @param _weiAmount Amount of wei contributed
717    */
718   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
719     super._preValidatePurchase(_beneficiary, _weiAmount);
720     require(weiRaised.add(_weiAmount) <= cap);
721   }
722 
723 }
724 
725 /**
726  * @title WhitelistedCrowdsale
727  * @dev Crowdsale in which only whitelisted users can contribute.
728  */
729 contract WhitelistedCrowdsale is Crowdsale, Ownable {
730 
731   mapping(address => bool) public whitelist;
732 
733   /**
734    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
735    */
736   modifier isWhitelisted(address _beneficiary) {
737     require(whitelist[_beneficiary]);
738     _;
739   }
740 
741   /**
742    * @dev Adds single address to whitelist.
743    * @param _beneficiary Address to be added to the whitelist
744    */
745   function addToWhitelist(address _beneficiary) external onlyOwner {
746     whitelist[_beneficiary] = true;
747   }
748 
749   /**
750    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
751    * @param _beneficiaries Addresses to be added to the whitelist
752    */
753   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
754     for (uint256 i = 0; i < _beneficiaries.length; i++) {
755       whitelist[_beneficiaries[i]] = true;
756     }
757   }
758 
759   /**
760    * @dev Removes single address from whitelist.
761    * @param _beneficiary Address to be removed to the whitelist
762    */
763   function removeFromWhitelist(address _beneficiary) external onlyOwner {
764     whitelist[_beneficiary] = false;
765   }
766 
767   /**
768    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
769    * @param _beneficiary Token beneficiary
770    * @param _weiAmount Amount of wei contributed
771    */
772   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
773     super._preValidatePurchase(_beneficiary, _weiAmount);
774   }
775 
776 }
777 
778 contract IndividualCapCrowdsale is Crowdsale, Ownable {
779   using SafeMath for uint256;
780 
781   uint256 public minAmount;
782   uint256 public maxAmount;
783 
784   mapping(address => uint256) public contributions;
785 
786   function IndividualCapCrowdsale(uint256 _minAmount, uint256 _maxAmount) public {
787     require(_minAmount > 0);
788     require(_maxAmount > _minAmount);
789 
790     minAmount = _minAmount;
791     maxAmount = _maxAmount;
792   }
793 
794   /**
795    * @dev Set the minimum amount in wei that can be invested per each purchase
796    * @param _minAmount Minimum Amount of wei to be invested per each purchase
797    */
798   function setMinAmount(uint256 _minAmount) public onlyOwner {
799     require(_minAmount > 0);
800     require(_minAmount < maxAmount);
801 
802     minAmount = _minAmount;
803   }
804 
805   /**
806    * @dev Set the overall maximum amount in wei that can be invested by user
807    * @param _maxAmount Maximum Amount of wei allowed to be invested by any user
808    */
809   function setMaxAmount(uint256 _maxAmount) public onlyOwner {
810     require(_maxAmount > 0);
811     require(_maxAmount > minAmount);
812 
813     maxAmount = _maxAmount;
814   }
815 
816   /**
817    * @dev Extend parent behavior requiring purchase to have minimum weiAmount and be within overall maxWeiAmount
818    * @param _beneficiary Token purchaser
819    * @param _weiAmount Amount of wei contributed
820    */
821   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
822     require(_weiAmount >= minAmount);
823     super._preValidatePurchase(_beneficiary, _weiAmount);
824     require(contributions[_beneficiary].add(_weiAmount) <= maxAmount);
825   }
826 
827   /**
828    * @dev Extend parent behavior to update user contributions
829    * @param _beneficiary Token purchaser
830    * @param _weiAmount Amount of wei contributed
831    */
832   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
833     super._updatePurchasingState(_beneficiary, _weiAmount);
834     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
835   }
836 }
837 
838 /**
839  * @title INCXSecondStrategicSale
840  * @dev This smart contract administers strategic sale of incx token. It has following features:
841  * - There is a cap to how much ether can be raised
842  * - There is a time limit in which the tokens can be bought
843  * - Only whitelisted ethereum addresses can contribute (to enforce KYC)
844  * - There is a minimum ether limit on individual contribution per transaction
845  * - There is a maximum ether limit on total individual contribution
846  * - Rate can be changed
847  */
848 contract INCXSecondStrategicSale is CappedCrowdsale, FinalizableCrowdsale, WhitelistedCrowdsale, IndividualCapCrowdsale, MintedCrowdsale {
849   event Refund(address indexed purchaser, uint256 tokens, uint256 weiReturned);
850   event TokensReturned(address indexed owner, uint256 tokens);
851   event EtherDepositedForRefund(address indexed sender,uint256 weiDeposited);
852   event EtherWithdrawn(address indexed wallet,uint256 weiWithdrawn);
853 
854   function INCXSecondStrategicSale(uint256 _openingTime, uint256 _closingTime, uint256 _rate, address _wallet, uint256 _cap, INCXToken _token, uint256 _minAmount, uint256 _maxAmount)
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
891    * @dev Set the new rate
892    * @param _rate New rate amount
893    */
894   function setRate(uint256 _rate) public onlyOwner {
895     require(_rate > 0);
896     rate = _rate;
897   }
898 
899   /**
900    * @dev This method refunds all the contribution that _purchaser has done
901    * @param _purchaser Token purchaser asking for refund
902    */
903   function refund(address _purchaser) public onlyOwner {
904     uint256 amountToRefund = contributions[_purchaser];
905     require(amountToRefund > 0);
906     require(weiRaised >= amountToRefund);
907     require(address(this).balance >= amountToRefund);
908     contributions[_purchaser] = 0;
909     uint256 _tokens = _getTokenAmount(amountToRefund);
910     weiRaised = weiRaised.sub(amountToRefund);
911     _purchaser.transfer(amountToRefund);
912     emit Refund(_purchaser, _tokens, amountToRefund);
913   }
914 }