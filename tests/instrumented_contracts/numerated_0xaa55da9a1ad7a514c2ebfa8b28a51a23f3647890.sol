1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 
19 
20 /**
21  * @title ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/20
23  */
24 contract ERC20 is ERC20Basic {
25   function allowance(address owner, address spender) public view returns (uint256);
26   function transferFrom(address from, address to, uint256 value) public returns (bool);
27   function approve(address spender, uint256 value) public returns (bool);
28   event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 
32 
33 /**
34  * @title Basic token
35  * @dev Basic version of StandardToken, with no allowances.
36  */
37 contract BasicToken is ERC20Basic {
38   using SafeMath for uint256;
39 
40   mapping(address => uint256) balances;
41 
42   uint256 totalSupply_;
43 
44   /**
45   * @dev total number of tokens in existence
46   */
47   function totalSupply() public view returns (uint256) {
48     return totalSupply_;
49   }
50 
51   /**
52   * @dev transfer token for a specified address
53   * @param _to The address to transfer to.
54   * @param _value The amount to be transferred.
55   */
56   function transfer(address _to, uint256 _value) public returns (bool) {
57     require(_to != address(0));
58     require(_value <= balances[msg.sender]);
59 
60     balances[msg.sender] = balances[msg.sender].sub(_value);
61     balances[_to] = balances[_to].add(_value);
62     emit Transfer(msg.sender, _to, _value);
63     return true;
64   }
65 
66   /**
67   * @dev Gets the balance of the specified address.
68   * @param _owner The address to query the the balance of.
69   * @return An uint256 representing the amount owned by the passed address.
70   */
71   function balanceOf(address _owner) public view returns (uint256) {
72     return balances[_owner];
73   }
74 
75 }
76 
77 
78 
79 
80 /**
81  * @title Ownable
82  * @dev The Ownable contract has an owner address, and provides basic authorization control
83  * functions, this simplifies the implementation of "user permissions".
84  */
85 contract Ownable {
86   address public owner;
87 
88 
89   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
90 
91 
92   /**
93    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
94    * account.
95    */
96   function Ownable() public {
97     owner = msg.sender;
98   }
99 
100   /**
101    * @dev Throws if called by any account other than the owner.
102    */
103   modifier onlyOwner() {
104     require(msg.sender == owner);
105     _;
106   }
107 
108   /**
109    * @dev Allows the current owner to transfer control of the contract to a newOwner.
110    * @param newOwner The address to transfer ownership to.
111    */
112   function transferOwnership(address newOwner) public onlyOwner {
113     require(newOwner != address(0));
114     emit OwnershipTransferred(owner, newOwner);
115     owner = newOwner;
116   }
117 
118 }
119 
120 
121 
122 
123 
124 
125 
126 
127 
128 
129 
130 
131 
132 
133 /**
134  * @title Standard ERC20 token
135  *
136  * @dev Implementation of the basic standard token.
137  * @dev https://github.com/ethereum/EIPs/issues/20
138  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  */
140 contract StandardToken is ERC20, BasicToken {
141 
142   mapping (address => mapping (address => uint256)) internal allowed;
143 
144 
145   /**
146    * @dev Transfer tokens from one address to another
147    * @param _from address The address which you want to send tokens from
148    * @param _to address The address which you want to transfer to
149    * @param _value uint256 the amount of tokens to be transferred
150    */
151   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
152     require(_to != address(0));
153     require(_value <= balances[_from]);
154     require(_value <= allowed[_from][msg.sender]);
155 
156     balances[_from] = balances[_from].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159     emit Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165    *
166    * Beware that changing an allowance with this method brings the risk that someone may use both the old
167    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170    * @param _spender The address which will spend the funds.
171    * @param _value The amount of tokens to be spent.
172    */
173   function approve(address _spender, uint256 _value) public returns (bool) {
174     allowed[msg.sender][_spender] = _value;
175     emit Approval(msg.sender, _spender, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Function to check the amount of tokens that an owner allowed to a spender.
181    * @param _owner address The address which owns the funds.
182    * @param _spender address The address which will spend the funds.
183    * @return A uint256 specifying the amount of tokens still available for the spender.
184    */
185   function allowance(address _owner, address _spender) public view returns (uint256) {
186     return allowed[_owner][_spender];
187   }
188 
189   /**
190    * @dev Increase the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To increment
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _addedValue The amount of tokens to increase the allowance by.
198    */
199   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
200     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205   /**
206    * @dev Decrease the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To decrement
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _subtractedValue The amount of tokens to decrease the allowance by.
214    */
215   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
216     uint oldValue = allowed[msg.sender][_spender];
217     if (_subtractedValue > oldValue) {
218       allowed[msg.sender][_spender] = 0;
219     } else {
220       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
221     }
222     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226 }
227 
228 
229 
230 
231 /**
232  * @title Mintable token
233  * @dev Simple ERC20 Token example, with mintable token creation
234  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
235  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
236  */
237 contract MintableToken is StandardToken, Ownable {
238   event Mint(address indexed to, uint256 amount);
239   event MintFinished();
240 
241   bool public mintingFinished = false;
242 
243 
244   modifier canMint() {
245     require(!mintingFinished);
246     _;
247   }
248 
249   /**
250    * @dev Function to mint tokens
251    * @param _to The address that will receive the minted tokens.
252    * @param _amount The amount of tokens to mint.
253    * @return A boolean that indicates if the operation was successful.
254    */
255   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
256     totalSupply_ = totalSupply_.add(_amount);
257     balances[_to] = balances[_to].add(_amount);
258     emit Mint(_to, _amount);
259     emit Transfer(address(0), _to, _amount);
260     return true;
261   }
262 
263   /**
264    * @dev Function to stop minting new tokens.
265    * @return True if the operation was successful.
266    */
267   function finishMinting() onlyOwner canMint public returns (bool) {
268     mintingFinished = true;
269     emit MintFinished();
270     return true;
271   }
272 }
273 
274 
275 
276 /**
277  * @title Capped token
278  * @dev Mintable token with a token cap.
279  */
280 contract CappedToken is MintableToken {
281 
282   uint256 public cap;
283 
284   function CappedToken(uint256 _cap) public {
285     require(_cap > 0);
286     cap = _cap;
287   }
288 
289   /**
290    * @dev Function to mint tokens
291    * @param _to The address that will receive the minted tokens.
292    * @param _amount The amount of tokens to mint.
293    * @return A boolean that indicates if the operation was successful.
294    */
295   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
296     require(totalSupply_.add(_amount) <= cap);
297 
298     return super.mint(_to, _amount);
299   }
300 
301 }
302 
303 
304 /**
305  * @title Burnable Token
306  * @dev Token that can be irreversibly burned (destroyed).
307  */
308 contract BurnableToken is BasicToken {
309 
310   event Burn(address indexed burner, uint256 value);
311 
312   /**
313    * @dev Burns a specific amount of tokens.
314    * @param _value The amount of token to be burned.
315    */
316   function burn(uint256 _value) public {
317     _burn(msg.sender, _value);
318   }
319 
320   function _burn(address _who, uint256 _value) internal {
321     require(_value <= balances[_who]);
322     // no need to require value <= totalSupply, since that would imply the
323     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
324 
325     balances[_who] = balances[_who].sub(_value);
326     totalSupply_ = totalSupply_.sub(_value);
327     emit Burn(_who, _value);
328     emit Transfer(_who, address(0), _value);
329   }
330 }
331 
332 
333 //CCH is a capped token with a max supply of 145249999 tokenSupply
334 //It is a burnable token as well
335 contract CareerChainToken is CappedToken(145249999000000000000000000), BurnableToken  {
336     string public name = "CareerChain Token";
337     string public symbol = "CCH";
338     uint8 public decimals = 18;
339 
340     //only the owner is allowed to burn tokens
341     function burn(uint256 _value) public onlyOwner {
342       _burn(msg.sender, _value);
343 
344     }
345 
346 }
347 
348 
349 
350 
351 /**
352  * @title SafeMath
353  * @dev Math operations with safety checks that throw on error
354  */
355 library SafeMath {
356 
357   /**
358   * @dev Multiplies two numbers, throws on overflow.
359   */
360   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
361     if (a == 0) {
362       return 0;
363     }
364     c = a * b;
365     assert(c / a == b);
366     return c;
367   }
368 
369   /**
370   * @dev Integer division of two numbers, truncating the quotient.
371   */
372   function div(uint256 a, uint256 b) internal pure returns (uint256) {
373     // assert(b > 0); // Solidity automatically throws when dividing by 0
374     // uint256 c = a / b;
375     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
376     return a / b;
377   }
378 
379   /**
380   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
381   */
382   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
383     assert(b <= a);
384     return a - b;
385   }
386 
387   /**
388   * @dev Adds two numbers, throws on overflow.
389   */
390   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
391     c = a + b;
392     assert(c >= a);
393     return c;
394   }
395 }
396 
397 
398 
399 /**
400  * @title Crowdsale
401  * @dev Crowdsale is a base contract for managing a token crowdsale,
402  * allowing investors to purchase tokens with ether. This contract implements
403  * such functionality in its most fundamental form and can be extended to provide additional
404  * functionality and/or custom behavior.
405  * The external interface represents the basic interface for purchasing tokens, and conform
406  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
407  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
408  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
409  * behavior.
410  */
411 contract Crowdsale {
412   using SafeMath for uint256;
413 
414   // The token being sold
415   ERC20 public token;
416 
417   // Address where funds are collected
418   address public wallet;
419 
420   // How many token units a buyer gets per wei
421   uint256 public rate;
422 
423   // Amount of wei raised
424   uint256 public weiRaised;
425 
426   /**
427    * Event for token purchase logging
428    * @param purchaser who paid for the tokens
429    * @param beneficiary who got the tokens
430    * @param value weis paid for purchase
431    * @param amount amount of tokens purchased
432    */
433   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
434 
435   /**
436    * @param _rate Number of token units a buyer gets per wei
437    * @param _wallet Address where collected funds will be forwarded to
438    * @param _token Address of the token being sold
439    */
440   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
441     require(_rate > 0);
442     require(_wallet != address(0));
443     require(_token != address(0));
444 
445     rate = _rate;
446     wallet = _wallet;
447     token = _token;
448   }
449 
450   // -----------------------------------------
451   // Crowdsale external interface
452   // -----------------------------------------
453 
454   /**
455    * @dev fallback function ***DO NOT OVERRIDE***
456    */
457   function () external payable {
458     buyTokens(msg.sender);
459   }
460 
461   /**
462    * @dev low level token purchase ***DO NOT OVERRIDE***
463    * @param _beneficiary Address performing the token purchase
464    */
465   function buyTokens(address _beneficiary) public payable {
466 
467     uint256 weiAmount = msg.value;
468     _preValidatePurchase(_beneficiary, weiAmount);
469 
470     // calculate token amount to be created
471     uint256 tokens = _getTokenAmount(weiAmount);
472 
473     // update state
474     weiRaised = weiRaised.add(weiAmount);
475 
476     _processPurchase(_beneficiary, tokens);
477     emit TokenPurchase(
478       msg.sender,
479       _beneficiary,
480       weiAmount,
481       tokens
482     );
483 
484     _updatePurchasingState(_beneficiary, weiAmount);
485 
486     _forwardFunds();
487     _postValidatePurchase(_beneficiary, weiAmount);
488   }
489 
490   // -----------------------------------------
491   // Internal interface (extensible)
492   // -----------------------------------------
493 
494   /**
495    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
496    * @param _beneficiary Address performing the token purchase
497    * @param _weiAmount Value in wei involved in the purchase
498    */
499   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
500     require(_beneficiary != address(0));
501     require(_weiAmount != 0);
502   }
503 
504   /**
505    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
506    * @param _beneficiary Address performing the token purchase
507    * @param _weiAmount Value in wei involved in the purchase
508    */
509   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
510     // optional override
511   }
512 
513   /**
514    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
515    * @param _beneficiary Address performing the token purchase
516    * @param _tokenAmount Number of tokens to be emitted
517    */
518   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
519     token.transfer(_beneficiary, _tokenAmount);
520   }
521 
522   /**
523    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
524    * @param _beneficiary Address receiving the tokens
525    * @param _tokenAmount Number of tokens to be purchased
526    */
527   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
528     _deliverTokens(_beneficiary, _tokenAmount);
529   }
530 
531   /**
532    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
533    * @param _beneficiary Address receiving the tokens
534    * @param _weiAmount Value in wei involved in the purchase
535    */
536   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
537     // optional override
538   }
539 
540   /**
541    * @dev Override to extend the way in which ether is converted to tokens.
542    * @param _weiAmount Value in wei to be converted into tokens
543    * @return Number of tokens that can be purchased with the specified _weiAmount
544    */
545   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
546     return _weiAmount.mul(rate);
547   }
548 
549   /**
550    * @dev Determines how ETH is stored/forwarded on purchases.
551    */
552   function _forwardFunds() internal {
553     wallet.transfer(msg.value);
554   }
555 }
556 
557 
558 
559 
560 /**
561  * @title WhitelistedCrowdsale
562  * @dev Crowdsale in which only whitelisted users can contribute.
563  */
564 contract WhitelistedCrowdsale is Crowdsale, Ownable {
565 
566   mapping(address => bool) public whitelist;
567 
568   /**
569    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
570    */
571   modifier isWhitelisted(address _beneficiary) {
572     require(whitelist[_beneficiary]);
573     _;
574   }
575 
576   /**
577    * @dev Adds single address to whitelist.
578    * @param _beneficiary Address to be added to the whitelist
579    */
580   function addToWhitelist(address _beneficiary) external onlyOwner {
581     whitelist[_beneficiary] = true;
582   }
583 
584   /**
585    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
586    * @param _beneficiaries Addresses to be added to the whitelist
587    */
588   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
589     for (uint256 i = 0; i < _beneficiaries.length; i++) {
590       whitelist[_beneficiaries[i]] = true;
591     }
592   }
593 
594   /**
595    * @dev Removes single address from whitelist.
596    * @param _beneficiary Address to be removed to the whitelist
597    */
598   function removeFromWhitelist(address _beneficiary) external onlyOwner {
599     whitelist[_beneficiary] = false;
600   }
601 
602   /**
603    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
604    * @param _beneficiary Token beneficiary
605    * @param _weiAmount Amount of wei contributed
606    */
607   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
608     super._preValidatePurchase(_beneficiary, _weiAmount);
609   }
610 
611 }
612 
613 
614 
615 
616 
617 
618 
619 /**
620  * @title TimedCrowdsale
621  * @dev Crowdsale accepting contributions only within a time frame.
622  */
623 contract TimedCrowdsale is Crowdsale {
624   using SafeMath for uint256;
625 
626   uint256 public openingTime;
627   uint256 public closingTime;
628 
629   /**
630    * @dev Reverts if not in crowdsale time range.
631    */
632   modifier onlyWhileOpen {
633     // solium-disable-next-line security/no-block-members
634     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
635     _;
636   }
637 
638   /**
639    * @dev Constructor, takes crowdsale opening and closing times.
640    * @param _openingTime Crowdsale opening time
641    * @param _closingTime Crowdsale closing time
642    */
643   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
644     // solium-disable-next-line security/no-block-members
645     require(_openingTime >= block.timestamp);
646     require(_closingTime >= _openingTime);
647 
648     openingTime = _openingTime;
649     closingTime = _closingTime;
650   }
651 
652   /**
653    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
654    * @return Whether crowdsale period has elapsed
655    */
656   function hasClosed() public view returns (bool) {
657     // solium-disable-next-line security/no-block-members
658     return block.timestamp > closingTime;
659   }
660 
661   /**
662    * @dev Extend parent behavior requiring to be within contributing period
663    * @param _beneficiary Token purchaser
664    * @param _weiAmount Amount of wei contributed
665    */
666   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
667     super._preValidatePurchase(_beneficiary, _weiAmount);
668   }
669 
670 }
671 
672 
673 /*
674   Token sale contract for the private sale
675   This contract has time constraints and only whitelisted accounts can invest
676   Tokens will not be issued to the investor immediately, but stored in this contract until the lock-up ends.
677   When the lock-up has ended, investors can withdraw their tokens to their own account
678 
679   A staged lock-up is used with 6 grades:
680     firstVestedLockUpAmount sit in lock-up until lockupEndTime[0]
681     stagedVestedLockUpAmounts sit in lock-up until lockupEndTime[1]
682     ...
683     stagedVestedLockUpAmounts sit in lock-up until lockupEndTime[6]
684 
685   For example:
686   When an investor buys 3,000,000 tokens:
687       875,000 tokens in lock-up till Dec 31 2018
688     1,000,000 tokens in lock-up till Jun 30 2018
689     1,000,000 tokens in lock-up till Dec 31 2019
690       125,000 tokens in lock-up till Jun 30 2019
691 */
692 contract CareerChainPrivateSale is TimedCrowdsale, WhitelistedCrowdsale  {
693     using SafeMath for uint256;
694 
695     //Tokens sold (but locked in the contract)
696     uint256 public tokensStillInLockup;
697 
698     //lock-up end time, 6 stages
699     uint256[6] public lockupEndTime;
700 
701     //balances in the lock-ups
702     mapping(address => uint256) public balances;
703 
704     //released from lock-ups
705     mapping(address => uint256) public released;
706 
707     //vesting levels
708     uint256 public firstVestedLockUpAmount;
709     uint256 public stagedVestedLockUpAmounts;
710 
711     //constructor function
712     //initializing lock-up periods and corresponding amounts of tokens
713     function CareerChainPrivateSale
714         (
715             uint256 _openingTime,
716             uint256 _closingTime,
717             uint256 _rate,
718             address _wallet,
719             uint256[6] _lockupEndTime,
720             uint256 _firstVestedLockUpAmount,
721             uint256 _stagedVestedLockUpAmounts,
722             CareerChainToken _token
723         )
724         public
725         Crowdsale(_rate, _wallet, _token)
726         TimedCrowdsale(_openingTime, _closingTime)
727         {
728             // solium-disable-next-line security/no-block-members
729             require(_lockupEndTime[0] >= block.timestamp);
730             require(_lockupEndTime[1] >= _lockupEndTime[0]);
731             require(_lockupEndTime[2] >= _lockupEndTime[1]);
732             require(_lockupEndTime[3] >= _lockupEndTime[2]);
733             require(_lockupEndTime[4] >= _lockupEndTime[3]);
734             require(_lockupEndTime[5] >= _lockupEndTime[4]);
735 
736             lockupEndTime = _lockupEndTime;
737 
738             firstVestedLockUpAmount = _firstVestedLockUpAmount;
739             stagedVestedLockUpAmounts = _stagedVestedLockUpAmounts;
740         }
741 
742 
743     //Overrides parent by storing balances instead of issuing tokens right away.
744     // @param _beneficiary Token purchaser
745     // @param _tokenAmount Amount of tokens purchased
746     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
747 
748         uint256 newTokensSold = tokensStillInLockup.add(_tokenAmount);
749         require(newTokensSold <= token.balanceOf(address(this)));
750         tokensStillInLockup = newTokensSold;
751 
752         //add tokens to contract token balance (due to lock-up)
753         balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
754 
755     }
756 
757     //when sale has ended, send unsold tokens back to token contract
758     // @param _beneficiary Token contract
759     function TransferUnsoldTokensBackToTokenContract(address _beneficiary) public onlyOwner {
760 
761         require(hasClosed());
762         uint256 unSoldTokens = token.balanceOf(address(this)).sub(tokensStillInLockup);
763 
764         token.transfer(_beneficiary, unSoldTokens);
765     }
766 
767     //when sale isn't ended, issue tokens to investors paid with fiat currency
768     // @param _beneficiary Token purchaser (with fiat)
769     // @param _tokenAmount Amount of tokens purchased
770     function IssueTokensToInvestors(address _beneficiary, uint256 _amount) public onlyOwner onlyWhileOpen{
771 
772         require(_beneficiary != address(0));
773         _processPurchase(_beneficiary, _amount);
774     }
775 
776     //owner is able to change rate in case of big price fluctuations of ether (on the market)
777     function _changeRate(uint256 _rate) public onlyOwner {
778         require(_rate > 0);
779         rate = _rate;
780     }
781 
782     //Calculates the amount that has already vested but hasn't been released yet.
783     function releasableAmount() private view returns (uint256) {
784       return vestedAmount().sub(released[msg.sender]);
785     }
786 
787     // Calculates the amount that has already vested.
788     function vestedAmount() private view returns (uint256) {
789       uint256 lockupStage = 0;
790       uint256 releasable = 0;
791 
792       //determine current lock-up phase
793       uint256 i=0;
794       while (i < lockupEndTime.length && lockupEndTime[i]<=now)
795       {
796         lockupStage = lockupStage.add(1);
797         i = i.add(1);
798       }
799 
800       //if lockupStage == 0 then all tokens are still in lock-up (first lock-up period not ended yet)
801       if(lockupStage>0)
802       {
803         //calculate the releasable amount depending on the current lock-up stage
804         releasable = (lockupStage.sub(1).mul(stagedVestedLockUpAmounts)).add(firstVestedLockUpAmount);
805       }
806       return releasable;
807     }
808 
809     //Withdraw tokens only after lock-up ends, applying the staged lock-up scheme.
810     function withdrawTokens() public {
811       uint256 tobeReleased = 0;
812       uint256 unreleased = releasableAmount();
813 
814       //max amount to be withdrawn is the releasable amount, excess stays in lock-up, unless all lock-ups have ended
815       if(balances[msg.sender] >= unreleased && lockupEndTime[lockupEndTime.length-1] > now)
816       {
817         tobeReleased = unreleased;
818       }
819       else
820       {
821         tobeReleased = balances[msg.sender];
822       }
823 
824       //revert transaction when nothing to be withdrawn
825       require(tobeReleased > 0);
826 
827       balances[msg.sender] = balances[msg.sender].sub(tobeReleased);
828       tokensStillInLockup = tokensStillInLockup.sub(tobeReleased);
829       released[msg.sender] = released[msg.sender].add(tobeReleased);
830 
831       _deliverTokens(msg.sender, tobeReleased);
832 
833     }
834 
835 }