1 pragma solidity ^0.4.23;
2 
3 
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
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
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 
54 
55 /**
56  * @title MultiOwnable
57  */
58 contract MultiOwnable {
59   address public root;
60   mapping (address => address) public owners; // owner => parent of owner
61   
62   /**
63   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64   * account.
65   */
66   constructor() public {
67     root = msg.sender;
68     owners[root] = root;
69   }
70   
71   /**
72   * @dev Throws if called by any account other than the owner.
73   */
74   modifier onlyOwner() {
75     require(owners[msg.sender] != 0);
76     _;
77   }
78   
79   /**
80   * @dev Adding new owners
81   */
82   function newOwner(address _owner) onlyOwner external returns (bool) {
83     require(_owner != 0);
84     owners[_owner] = msg.sender;
85     return true;
86   }
87   
88   /**
89     * @dev Deleting owners
90     */
91   function deleteOwner(address _owner) onlyOwner external returns (bool) {
92     require(owners[_owner] == msg.sender || (owners[_owner] != 0 && msg.sender == root));
93     owners[_owner] = 0;
94     return true;
95   }
96 }
97 
98 
99 
100 /**
101  * @title ERC20Basic
102  * @dev Simpler version of ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/179
104  */
105 contract ERC20Basic {
106   function totalSupply() public view returns (uint256);
107   function balanceOf(address who) public view returns (uint256);
108   function transfer(address to, uint256 value) public returns (bool);
109   event Transfer(address indexed from, address indexed to, uint256 value);
110 }
111 
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender) public view returns (uint256);
119   function transferFrom(address from, address to, uint256 value) public returns (bool);
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 
125 /**
126  * @title Basic token
127  * @dev Basic version of StandardToken, with no allowances.
128  */
129 contract BasicToken is ERC20Basic {
130   using SafeMath for uint256;
131 
132   mapping(address => uint256) balances;
133 
134   uint256 totalSupply_;
135 
136   /**
137   * @dev total number of tokens in existence
138   */
139   function totalSupply() public view returns (uint256) {
140     return totalSupply_;
141   }
142 
143   /**
144   * @dev transfer token for a specified address
145   * @param _to The address to transfer to.
146   * @param _value The amount to be transferred.
147   */
148   function transfer(address _to, uint256 _value) public returns (bool) {
149     require(_to != address(0));
150     require(_value <= balances[msg.sender]);
151 
152     balances[msg.sender] = balances[msg.sender].sub(_value);
153     balances[_to] = balances[_to].add(_value);
154     emit Transfer(msg.sender, _to, _value);
155     return true;
156   }
157 
158   /**
159   * @dev Gets the balance of the specified address.
160   * @param _owner The address to query the the balance of.
161   * @return An uint256 representing the amount owned by the passed address.
162   */
163   function balanceOf(address _owner) public view returns (uint256 balance) {
164     return balances[_owner];
165   }
166 
167 }
168 
169 
170 
171 
172 /**
173  * @title Burnable Token
174  * @dev Token that can be irreversibly burned (destroyed).
175  */
176 contract BurnableToken is BasicToken {
177 
178   event Burn(address indexed burner, uint256 value);
179 
180   /**
181    * @dev Burns a specific amount of tokens.
182    * @param _value The amount of token to be burned.
183    */
184   function burn(uint256 _value) public {
185     _burn(msg.sender, _value);
186   }
187 
188   function _burn(address _who, uint256 _value) internal {
189     require(_value <= balances[_who]);
190     // no need to require value <= totalSupply, since that would imply the
191     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
192 
193     balances[_who] = balances[_who].sub(_value);
194     totalSupply_ = totalSupply_.sub(_value);
195     emit Burn(_who, _value);
196     emit Transfer(_who, address(0), _value);
197   }
198 }
199 
200 
201 
202 
203 /**
204  * @title Standard ERC20 token
205  *
206  * @dev Implementation of the basic standard token.
207  * @dev https://github.com/ethereum/EIPs/issues/20
208  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
209  */
210 contract StandardToken is ERC20, BasicToken {
211 
212   mapping (address => mapping (address => uint256)) internal allowed;
213 
214 
215   /**
216    * @dev Transfer tokens from one address to another
217    * @param _from address The address which you want to send tokens from
218    * @param _to address The address which you want to transfer to
219    * @param _value uint256 the amount of tokens to be transferred
220    */
221   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
222     require(_to != address(0));
223     require(_value <= balances[_from]);
224     require(_value <= allowed[_from][msg.sender]);
225 
226     balances[_from] = balances[_from].sub(_value);
227     balances[_to] = balances[_to].add(_value);
228     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
229     emit Transfer(_from, _to, _value);
230     return true;
231   }
232 
233   /**
234    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
235    *
236    * Beware that changing an allowance with this method brings the risk that someone may use both the old
237    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
238    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
239    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240    * @param _spender The address which will spend the funds.
241    * @param _value The amount of tokens to be spent.
242    */
243   function approve(address _spender, uint256 _value) public returns (bool) {
244     allowed[msg.sender][_spender] = _value;
245     emit Approval(msg.sender, _spender, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Function to check the amount of tokens that an owner allowed to a spender.
251    * @param _owner address The address which owns the funds.
252    * @param _spender address The address which will spend the funds.
253    * @return A uint256 specifying the amount of tokens still available for the spender.
254    */
255   function allowance(address _owner, address _spender) public view returns (uint256) {
256     return allowed[_owner][_spender];
257   }
258 
259   /**
260    * @dev Increase the amount of tokens that an owner allowed to a spender.
261    *
262    * approve should be called when allowed[_spender] == 0. To increment
263    * allowed value is better to use this function to avoid 2 calls (and wait until
264    * the first transaction is mined)
265    * From MonolithDAO Token.sol
266    * @param _spender The address which will spend the funds.
267    * @param _addedValue The amount of tokens to increase the allowance by.
268    */
269   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
270     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
271     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275   /**
276    * @dev Decrease the amount of tokens that an owner allowed to a spender.
277    *
278    * approve should be called when allowed[_spender] == 0. To decrement
279    * allowed value is better to use this function to avoid 2 calls (and wait until
280    * the first transaction is mined)
281    * From MonolithDAO Token.sol
282    * @param _spender The address which will spend the funds.
283    * @param _subtractedValue The amount of tokens to decrease the allowance by.
284    */
285   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
286     uint oldValue = allowed[msg.sender][_spender];
287     if (_subtractedValue > oldValue) {
288       allowed[msg.sender][_spender] = 0;
289     } else {
290       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
291     }
292     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
293     return true;
294   }
295 
296 }
297 
298 
299 
300 
301 
302 /**
303  * @title Mintable token
304  * @dev Simple ERC20 Token example, with mintable token creation
305  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
306  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
307  */
308 contract MintableToken is StandardToken, MultiOwnable {
309   event Mint(address indexed to, uint256 amount);
310   event MintFinished();
311 
312   bool public mintingFinished = false;
313 
314 
315   modifier canMint() {
316     require(!mintingFinished);
317     _;
318   }
319 
320   /**
321    * @dev Function to mint tokens
322    * @param _to The address that will receive the minted tokens.
323    * @param _amount The amount of tokens to mint.
324    * @return A boolean that indicates if the operation was successful.
325    */
326   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
327     totalSupply_ = totalSupply_.add(_amount);
328     balances[_to] = balances[_to].add(_amount);
329     emit Mint(_to, _amount);
330     emit Transfer(address(0), _to, _amount);
331     return true;
332   }
333 
334   /**
335    * @dev Function to stop minting new tokens.
336    * @return True if the operation was successful.
337    */
338   function finishMinting() onlyOwner canMint public returns (bool) {
339     mintingFinished = true;
340     emit MintFinished();
341     return true;
342   }
343 }
344 
345 
346 
347 
348 /**
349  * @title HUMToken
350  * @dev ERC20 HUMToken.
351  * Note they can later distribute these tokens as they wish using `transfer` and other
352  * `StandardToken` functions.
353  */
354 contract HUMToken is MintableToken, BurnableToken {
355 
356   string public constant name = "HUMToken"; // solium-disable-line uppercase
357   string public constant symbol = "HUM"; // solium-disable-line uppercase
358   uint8 public constant decimals = 18; // solium-disable-line uppercase, // 18 decimals is the strongly suggested default, avoid changing it
359 
360   uint256 public constant INITIAL_SUPPLY = 2500 * 1000 * 1000 * (10 ** uint256(decimals)); // 2,500,000,000 HUM
361 
362   bool public isUnlocked = false;
363   
364   /**
365    * @dev Constructor that gives msg.sender all of existing tokens.
366    */
367   constructor(address _wallet) public {
368     totalSupply_ = INITIAL_SUPPLY;
369     balances[_wallet] = INITIAL_SUPPLY;
370     emit Transfer(address(0), _wallet, INITIAL_SUPPLY);
371   }
372 
373   modifier onlyTransferable() {
374     require(isUnlocked || owners[msg.sender] != 0);
375     _;
376   }
377 
378   function transferFrom(address _from, address _to, uint256 _value) public onlyTransferable returns (bool) {
379       return super.transferFrom(_from, _to, _value);
380   }
381 
382   function transfer(address _to, uint256 _value) public onlyTransferable returns (bool) {
383       return super.transfer(_to, _value);
384   }
385   
386   function unlockTransfer() public onlyOwner {
387       isUnlocked = true;
388   }
389 
390 }
391 
392 
393 
394 /**
395  * @title Crowdsale
396  * @dev Crowdsale is a base contract for managing a token crowdsale,
397  * allowing investors to purchase tokens with ether. This contract implements
398  * such functionality in its most fundamental form and can be extended to provide additional
399  * functionality and/or custom behavior.
400  * The external interface represents the basic interface for purchasing tokens, and conform
401  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
402  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
403  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
404  * behavior.
405  */
406 contract Crowdsale {
407   using SafeMath for uint256;
408 
409   // The token being sold
410   ERC20 public token;
411 
412   // Address where funds are collected
413   address public wallet;
414 
415   // How many token units a buyer gets per wei
416   uint256 public rate;
417 
418   // Amount of wei raised
419   uint256 public weiRaised;
420 
421   /**
422    * Event for token purchase logging
423    * @param purchaser who paid for the tokens
424    * @param beneficiary who got the tokens
425    * @param value weis paid for purchase
426    * @param amount amount of tokens purchased
427    */
428   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
429 
430   /**
431    * @param _rate Number of token units a buyer gets per wei
432    * @param _wallet Address where collected funds will be forwarded to
433    * @param _token Address of the token being sold
434    */
435   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
436     require(_rate > 0);
437     require(_wallet != address(0));
438     require(_token != address(0));
439 
440     rate = _rate;
441     wallet = _wallet;
442     token = _token;
443   }
444 
445   // -----------------------------------------
446   // Crowdsale external interface
447   // -----------------------------------------
448 
449   /**
450    * @dev fallback function ***DO NOT OVERRIDE***
451    */
452   function () external payable {
453     buyTokens(msg.sender);
454   }
455 
456   /**
457    * @dev low level token purchase ***DO NOT OVERRIDE***
458    * @param _beneficiary Address performing the token purchase
459    */
460   function buyTokens(address _beneficiary) public payable {
461 
462     uint256 weiAmount = msg.value;
463     _preValidatePurchase(_beneficiary, weiAmount);
464 
465     // calculate token amount to be created
466     uint256 tokens = _getTokenAmount(weiAmount);
467 
468     // update state
469     weiRaised = weiRaised.add(weiAmount);
470 
471     _processPurchase(_beneficiary, tokens);
472     emit TokenPurchase(
473       msg.sender,
474       _beneficiary,
475       weiAmount,
476       tokens
477     );
478 
479     _updatePurchasingState(_beneficiary, weiAmount);
480 
481     _forwardFunds();
482     _postValidatePurchase(_beneficiary, weiAmount);
483   }
484 
485   // -----------------------------------------
486   // Internal interface (extensible)
487   // -----------------------------------------
488 
489   /**
490    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
491    * @param _beneficiary Address performing the token purchase
492    * @param _weiAmount Value in wei involved in the purchase
493    */
494   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
495     require(_beneficiary != address(0));
496     require(_weiAmount != 0);
497   }
498 
499   /**
500    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
501    * @param _beneficiary Address performing the token purchase
502    * @param _weiAmount Value in wei involved in the purchase
503    */
504   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
505     // optional override
506   }
507 
508   /**
509    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
510    * @param _beneficiary Address performing the token purchase
511    * @param _tokenAmount Number of tokens to be emitted
512    */
513   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
514     token.transfer(_beneficiary, _tokenAmount);
515   }
516 
517   /**
518    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
519    * @param _beneficiary Address receiving the tokens
520    * @param _tokenAmount Number of tokens to be purchased
521    */
522   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
523     _deliverTokens(_beneficiary, _tokenAmount);
524   }
525 
526   /**
527    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
528    * @param _beneficiary Address receiving the tokens
529    * @param _weiAmount Value in wei involved in the purchase
530    */
531   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
532     // optional override
533   }
534 
535   /**
536    * @dev Override to extend the way in which ether is converted to tokens.
537    * @param _weiAmount Value in wei to be converted into tokens
538    * @return Number of tokens that can be purchased with the specified _weiAmount
539    */
540   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
541     return _weiAmount.mul(rate);
542   }
543 
544   /**
545    * @dev Determines how ETH is stored/forwarded on purchases.
546    */
547   function _forwardFunds() internal {
548     wallet.transfer(msg.value);
549   }
550 }
551 
552 
553 
554 /**
555  * @title CappedCrowdsale
556  * @dev Crowdsale with a limit for total contributions.
557  */
558 contract CappedCrowdsale is Crowdsale {
559   using SafeMath for uint256;
560 
561   uint256 public cap;
562 
563   /**
564    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
565    * @param _cap Max amount of wei to be contributed
566    */
567   constructor(uint256 _cap) public {
568     require(_cap > 0);
569     cap = _cap;
570   }
571 
572   /**
573    * @dev Checks whether the cap has been reached. 
574    * @return Whether the cap was reached
575    */
576   function capReached() public view returns (bool) {
577     return weiRaised >= cap;
578   }
579 
580   /**
581    * @dev Extend parent behavior requiring purchase to respect the funding cap.
582    * @param _beneficiary Token purchaser
583    * @param _weiAmount Amount of wei contributed
584    */
585   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
586     super._preValidatePurchase(_beneficiary, _weiAmount);
587     require(weiRaised.add(_weiAmount) <= cap);
588   }
589 
590 }
591 
592 
593 
594 
595 
596 /**
597  * @title IndividuallyCappedCrowdsale
598  * @dev Crowdsale with per-user caps.
599  */
600 contract IndividuallyCappedCrowdsale is Crowdsale {
601   using SafeMath for uint256;
602 
603   mapping(address => uint256) public contributions;
604   uint256 public individualCap;
605 
606   constructor(uint256 _individualCap) public {
607     individualCap = _individualCap;
608   }
609 
610   /**
611    * @dev Returns the cap per a user.
612    * @return Current cap for individual user
613    */
614   function getUserCap() public view returns (uint256) {
615     return individualCap;
616   }
617 
618   /**
619    * @dev Returns the amount contributed so far by a sepecific user.
620    * @param _beneficiary Address of contributor
621    * @return User contribution so far
622    */
623   function getUserContribution(address _beneficiary) public view returns (uint256) {
624     return contributions[_beneficiary];
625   }
626 
627   /**
628    * @dev Extend parent behavior requiring purchase to respect the user's funding cap.
629    * @param _beneficiary Token purchaser
630    * @param _weiAmount Amount of wei contributed
631    */
632   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
633     super._preValidatePurchase(_beneficiary, _weiAmount);
634     require(contributions[_beneficiary].add(_weiAmount) <= individualCap);
635   }
636 
637   /**
638    * @dev Extend parent behavior to update user contributions
639    * @param _beneficiary Token purchaser
640    * @param _weiAmount Amount of wei contributed
641    */
642   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
643     super._updatePurchasingState(_beneficiary, _weiAmount);
644     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
645   }
646 
647 }
648 
649 
650 
651 /**
652  * @title WhitelistedCrowdsale
653  * @dev Crowdsale in which only whitelisted users can contribute.
654  */
655 contract WhitelistedCrowdsale is Crowdsale, MultiOwnable {
656 
657   mapping(address => bool) public whitelist;
658 
659   /**
660    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
661    */
662   modifier isWhitelisted(address _beneficiary) {
663     require(whitelist[_beneficiary]);
664     _;
665   }
666 
667   /**
668    * @dev Adds single address to whitelist.
669    * @param _beneficiary Address to be added to the whitelist
670    */
671   function addToWhitelist(address _beneficiary) external onlyOwner {
672     whitelist[_beneficiary] = true;
673   }
674 
675   /**
676    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
677    * @param _beneficiaries Addresses to be added to the whitelist
678    */
679   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
680     for (uint256 i = 0; i < _beneficiaries.length; i++) {
681       whitelist[_beneficiaries[i]] = true;
682     }
683   }
684 
685   /**
686    * @dev Removes single address from whitelist.
687    * @param _beneficiary Address to be removed to the whitelist
688    */
689   function removeFromWhitelist(address _beneficiary) external onlyOwner {
690     whitelist[_beneficiary] = false;
691   }
692 
693   /**
694    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
695    * @param _beneficiary Token beneficiary
696    * @param _weiAmount Amount of wei contributed
697    */
698   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
699     super._preValidatePurchase(_beneficiary, _weiAmount);
700   }
701 
702 }
703 
704 
705 
706 
707 contract HUMPresale is WhitelistedCrowdsale, IndividuallyCappedCrowdsale {
708   
709   uint256 public constant minimum = 100000000000000000; // 0.1 ether
710   bool public isOnSale = false;
711 
712   mapping(address => uint256) public bonusTokens;
713   uint256 public bonusPercent;
714   address[] public contributors;
715 
716   event DistrubuteBonusTokens(address indexed sender);
717   event Withdraw(address indexed _from, uint256 _amount);
718 
719   constructor (
720     uint256 _rate,
721     uint256 _bonusPercent,
722     address _wallet,
723     HUMToken _token,
724     uint256 _individualCapEther
725   ) 
726     public
727     Crowdsale(_rate, _wallet, _token)
728     IndividuallyCappedCrowdsale(_individualCapEther.mul(10 ** 18))
729   { 
730     bonusPercent = _bonusPercent;
731   }
732 
733   function modifyTokenPrice(uint256 _rate) public onlyOwner {
734     rate = _rate;
735   }
736 
737   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
738     super._processPurchase(_beneficiary, _tokenAmount);
739 
740     if (bonusPercent > 0) {
741       if (contributions[_beneficiary] == 0) {
742         contributors.push(_beneficiary);
743       }
744       bonusTokens[_beneficiary] = bonusTokens[_beneficiary].add(_tokenAmount.mul(bonusPercent).div(100));
745     }
746   }
747 
748   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
749     super._preValidatePurchase(_beneficiary, _weiAmount);
750 
751     bool isOverMinimum = _weiAmount >= minimum;
752   
753     require(isOverMinimum && isOnSale);
754   }
755 
756   function openSale() public onlyOwner {
757     require(!isOnSale);
758 
759     isOnSale = true;
760   }
761 
762   function closeSale() public onlyOwner {
763     require(isOnSale);
764 
765     if (token.balanceOf(this) > 0) {
766       withdrawToken();
767     }
768 
769     isOnSale = false;
770   }
771 
772   function withdrawToken() public onlyOwner {
773     uint256 balanceOfThis = token.balanceOf(this);
774     token.transfer(wallet, balanceOfThis);
775     emit Withdraw(wallet, balanceOfThis);
776   }
777 
778   function distributeBonusTokens() public onlyOwner {
779     require(!isOnSale);
780 
781     for (uint i = 0; i < contributors.length; i++) {
782       if (bonusTokens[contributors[i]] > 0) {
783         token.transferFrom(wallet, contributors[i], bonusTokens[contributors[i]]);
784         bonusTokens[contributors[i]] = 0;
785       }
786     }
787 
788     emit DistrubuteBonusTokens(msg.sender);
789   }
790 
791   function getContributors() public view onlyOwner returns(address[]) {
792     return contributors;
793   }
794 
795   /// @dev get addresses who has bonus tokens
796   /// @return Returns array of addresses.
797   function getBonusList() public view onlyOwner returns(address[]) {
798     address[] memory contributorsTmp = new address[](contributors.length);
799     uint count = 0;
800     uint i;
801 
802     for (i = 0; i < contributors.length; i++) {
803       if (bonusTokens[contributors[i]] > 0) {
804         contributorsTmp[count] = contributors[i];
805         count += 1;
806       }
807     }
808     
809     address[] memory _bonusList = new address[](count);
810     for (i = 0; i < count; i++) {
811       _bonusList[i] = contributorsTmp[i];
812     }
813 
814     return _bonusList;
815   }
816 
817   /// @dev distribute bonus tokens to addresses who has bonus tokens
818   /// @param _bonusList array of addresses who has bonus tokens.
819   function distributeBonusTokensByList(address[] _bonusList) public onlyOwner {
820     require(!isOnSale);
821 
822     for (uint i = 0; i < _bonusList.length; i++) {
823       if (bonusTokens[_bonusList[i]] > 0) {
824         token.transferFrom(wallet, _bonusList[i], bonusTokens[_bonusList[i]]);
825         bonusTokens[_bonusList[i]] = 0;
826       }
827     }
828 
829     emit DistrubuteBonusTokens(msg.sender);
830   }
831 
832 }