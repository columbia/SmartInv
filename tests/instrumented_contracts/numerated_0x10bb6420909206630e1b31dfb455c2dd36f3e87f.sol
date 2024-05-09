1 pragma solidity 0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) public view returns (uint256);
73   function transferFrom(address from, address to, uint256 value) public returns (bool);
74   function approve(address spender, uint256 value) public returns (bool);
75   event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
79 
80 /**
81  * @title Crowdsale
82  * @dev Crowdsale is a base contract for managing a token crowdsale,
83  * allowing investors to purchase tokens with ether. This contract implements
84  * such functionality in its most fundamental form and can be extended to provide additional
85  * functionality and/or custom behavior.
86  * The external interface represents the basic interface for purchasing tokens, and conform
87  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
88  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
89  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
90  * behavior.
91  */
92 contract Crowdsale {
93   using SafeMath for uint256;
94 
95   // The token being sold
96   ERC20 public token;
97 
98   // Address where funds are collected
99   address public wallet;
100 
101   // How many token units a buyer gets per wei
102   uint256 public rate;
103 
104   // Amount of wei raised
105   uint256 public weiRaised;
106 
107   /**
108    * Event for token purchase logging
109    * @param purchaser who paid for the tokens
110    * @param beneficiary who got the tokens
111    * @param value weis paid for purchase
112    * @param amount amount of tokens purchased
113    */
114   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
115 
116   /**
117    * @param _rate Number of token units a buyer gets per wei
118    * @param _wallet Address where collected funds will be forwarded to
119    * @param _token Address of the token being sold
120    */
121   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
122     require(_rate > 0);
123     require(_wallet != address(0));
124     require(_token != address(0));
125 
126     rate = _rate;
127     wallet = _wallet;
128     token = _token;
129   }
130 
131   // -----------------------------------------
132   // Crowdsale external interface
133   // -----------------------------------------
134 
135   /**
136    * @dev fallback function ***DO NOT OVERRIDE***
137    */
138   function () external payable {
139     buyTokens(msg.sender);
140   }
141 
142   /**
143    * @dev low level token purchase ***DO NOT OVERRIDE***
144    * @param _beneficiary Address performing the token purchase
145    */
146   function buyTokens(address _beneficiary) public payable {
147 
148     uint256 weiAmount = msg.value;
149     _preValidatePurchase(_beneficiary, weiAmount);
150 
151     // calculate token amount to be created
152     uint256 tokens = _getTokenAmount(weiAmount);
153 
154     // update state
155     weiRaised = weiRaised.add(weiAmount);
156 
157     _processPurchase(_beneficiary, tokens);
158     emit TokenPurchase(
159       msg.sender,
160       _beneficiary,
161       weiAmount,
162       tokens
163     );
164 
165     _updatePurchasingState(_beneficiary, weiAmount);
166 
167     _forwardFunds();
168     _postValidatePurchase(_beneficiary, weiAmount);
169   }
170 
171   // -----------------------------------------
172   // Internal interface (extensible)
173   // -----------------------------------------
174 
175   /**
176    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
177    * @param _beneficiary Address performing the token purchase
178    * @param _weiAmount Value in wei involved in the purchase
179    */
180   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
181     require(_beneficiary != address(0));
182     require(_weiAmount != 0);
183   }
184 
185   /**
186    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
187    * @param _beneficiary Address performing the token purchase
188    * @param _weiAmount Value in wei involved in the purchase
189    */
190   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
191     // optional override
192   }
193 
194   /**
195    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
196    * @param _beneficiary Address performing the token purchase
197    * @param _tokenAmount Number of tokens to be emitted
198    */
199   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
200     token.transfer(_beneficiary, _tokenAmount);
201   }
202 
203   /**
204    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
205    * @param _beneficiary Address receiving the tokens
206    * @param _tokenAmount Number of tokens to be purchased
207    */
208   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
209     _deliverTokens(_beneficiary, _tokenAmount);
210   }
211 
212   /**
213    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
214    * @param _beneficiary Address receiving the tokens
215    * @param _weiAmount Value in wei involved in the purchase
216    */
217   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
218     // optional override
219   }
220 
221   /**
222    * @dev Override to extend the way in which ether is converted to tokens.
223    * @param _weiAmount Value in wei to be converted into tokens
224    * @return Number of tokens that can be purchased with the specified _weiAmount
225    */
226   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
227     return _weiAmount.mul(rate);
228   }
229 
230   /**
231    * @dev Determines how ETH is stored/forwarded on purchases.
232    */
233   function _forwardFunds() internal {
234     wallet.transfer(msg.value);
235   }
236 }
237 
238 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
239 
240 /**
241  * @title TimedCrowdsale
242  * @dev Crowdsale accepting contributions only within a time frame.
243  */
244 contract TimedCrowdsale is Crowdsale {
245   using SafeMath for uint256;
246 
247   uint256 public openingTime;
248   uint256 public closingTime;
249 
250   /**
251    * @dev Reverts if not in crowdsale time range.
252    */
253   modifier onlyWhileOpen {
254     // solium-disable-next-line security/no-block-members
255     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
256     _;
257   }
258 
259   /**
260    * @dev Constructor, takes crowdsale opening and closing times.
261    * @param _openingTime Crowdsale opening time
262    * @param _closingTime Crowdsale closing time
263    */
264   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
265     // solium-disable-next-line security/no-block-members
266     require(_openingTime >= block.timestamp);
267     require(_closingTime >= _openingTime);
268 
269     openingTime = _openingTime;
270     closingTime = _closingTime;
271   }
272 
273   /**
274    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
275    * @return Whether crowdsale period has elapsed
276    */
277   function hasClosed() public view returns (bool) {
278     // solium-disable-next-line security/no-block-members
279     return block.timestamp > closingTime;
280   }
281 
282   /**
283    * @dev Extend parent behavior requiring to be within contributing period
284    * @param _beneficiary Token purchaser
285    * @param _weiAmount Amount of wei contributed
286    */
287   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
288     super._preValidatePurchase(_beneficiary, _weiAmount);
289   }
290 
291 }
292 
293 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
294 
295 /**
296  * @title Ownable
297  * @dev The Ownable contract has an owner address, and provides basic authorization control
298  * functions, this simplifies the implementation of "user permissions".
299  */
300 contract Ownable {
301   address public owner;
302 
303 
304   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
305 
306 
307   /**
308    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
309    * account.
310    */
311   function Ownable() public {
312     owner = msg.sender;
313   }
314 
315   /**
316    * @dev Throws if called by any account other than the owner.
317    */
318   modifier onlyOwner() {
319     require(msg.sender == owner);
320     _;
321   }
322 
323   /**
324    * @dev Allows the current owner to transfer control of the contract to a newOwner.
325    * @param newOwner The address to transfer ownership to.
326    */
327   function transferOwnership(address newOwner) public onlyOwner {
328     require(newOwner != address(0));
329     emit OwnershipTransferred(owner, newOwner);
330     owner = newOwner;
331   }
332 
333 }
334 
335 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/validation/WhitelistedCrowdsale.sol
336 
337 /**
338  * @title WhitelistedCrowdsale
339  * @dev Crowdsale in which only whitelisted users can contribute.
340  */
341 contract WhitelistedCrowdsale is Crowdsale, Ownable {
342 
343   mapping(address => bool) public whitelist;
344 
345   /**
346    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
347    */
348   modifier isWhitelisted(address _beneficiary) {
349     require(whitelist[_beneficiary]);
350     _;
351   }
352 
353   /**
354    * @dev Adds single address to whitelist.
355    * @param _beneficiary Address to be added to the whitelist
356    */
357   function addToWhitelist(address _beneficiary) external onlyOwner {
358     whitelist[_beneficiary] = true;
359   }
360 
361   /**
362    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
363    * @param _beneficiaries Addresses to be added to the whitelist
364    */
365   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
366     for (uint256 i = 0; i < _beneficiaries.length; i++) {
367       whitelist[_beneficiaries[i]] = true;
368     }
369   }
370 
371   /**
372    * @dev Removes single address from whitelist.
373    * @param _beneficiary Address to be removed to the whitelist
374    */
375   function removeFromWhitelist(address _beneficiary) external onlyOwner {
376     whitelist[_beneficiary] = false;
377   }
378 
379   /**
380    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
381    * @param _beneficiary Token beneficiary
382    * @param _weiAmount Amount of wei contributed
383    */
384   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
385     super._preValidatePurchase(_beneficiary, _weiAmount);
386   }
387 
388 }
389 
390 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
391 
392 /**
393  * @title Basic token
394  * @dev Basic version of StandardToken, with no allowances.
395  */
396 contract BasicToken is ERC20Basic {
397   using SafeMath for uint256;
398 
399   mapping(address => uint256) balances;
400 
401   uint256 totalSupply_;
402 
403   /**
404   * @dev total number of tokens in existence
405   */
406   function totalSupply() public view returns (uint256) {
407     return totalSupply_;
408   }
409 
410   /**
411   * @dev transfer token for a specified address
412   * @param _to The address to transfer to.
413   * @param _value The amount to be transferred.
414   */
415   function transfer(address _to, uint256 _value) public returns (bool) {
416     require(_to != address(0));
417     require(_value <= balances[msg.sender]);
418 
419     balances[msg.sender] = balances[msg.sender].sub(_value);
420     balances[_to] = balances[_to].add(_value);
421     emit Transfer(msg.sender, _to, _value);
422     return true;
423   }
424 
425   /**
426   * @dev Gets the balance of the specified address.
427   * @param _owner The address to query the the balance of.
428   * @return An uint256 representing the amount owned by the passed address.
429   */
430   function balanceOf(address _owner) public view returns (uint256) {
431     return balances[_owner];
432   }
433 
434 }
435 
436 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
437 
438 /**
439  * @title Burnable Token
440  * @dev Token that can be irreversibly burned (destroyed).
441  */
442 contract BurnableToken is BasicToken {
443 
444   event Burn(address indexed burner, uint256 value);
445 
446   /**
447    * @dev Burns a specific amount of tokens.
448    * @param _value The amount of token to be burned.
449    */
450   function burn(uint256 _value) public {
451     _burn(msg.sender, _value);
452   }
453 
454   function _burn(address _who, uint256 _value) internal {
455     require(_value <= balances[_who]);
456     // no need to require value <= totalSupply, since that would imply the
457     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
458 
459     balances[_who] = balances[_who].sub(_value);
460     totalSupply_ = totalSupply_.sub(_value);
461     emit Burn(_who, _value);
462     emit Transfer(_who, address(0), _value);
463   }
464 }
465 
466 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
467 
468 /**
469  * @title Standard ERC20 token
470  *
471  * @dev Implementation of the basic standard token.
472  * @dev https://github.com/ethereum/EIPs/issues/20
473  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
474  */
475 contract StandardToken is ERC20, BasicToken {
476 
477   mapping (address => mapping (address => uint256)) internal allowed;
478 
479 
480   /**
481    * @dev Transfer tokens from one address to another
482    * @param _from address The address which you want to send tokens from
483    * @param _to address The address which you want to transfer to
484    * @param _value uint256 the amount of tokens to be transferred
485    */
486   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
487     require(_to != address(0));
488     require(_value <= balances[_from]);
489     require(_value <= allowed[_from][msg.sender]);
490 
491     balances[_from] = balances[_from].sub(_value);
492     balances[_to] = balances[_to].add(_value);
493     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
494     emit Transfer(_from, _to, _value);
495     return true;
496   }
497 
498   /**
499    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
500    *
501    * Beware that changing an allowance with this method brings the risk that someone may use both the old
502    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
503    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
504    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
505    * @param _spender The address which will spend the funds.
506    * @param _value The amount of tokens to be spent.
507    */
508   function approve(address _spender, uint256 _value) public returns (bool) {
509     allowed[msg.sender][_spender] = _value;
510     emit Approval(msg.sender, _spender, _value);
511     return true;
512   }
513 
514   /**
515    * @dev Function to check the amount of tokens that an owner allowed to a spender.
516    * @param _owner address The address which owns the funds.
517    * @param _spender address The address which will spend the funds.
518    * @return A uint256 specifying the amount of tokens still available for the spender.
519    */
520   function allowance(address _owner, address _spender) public view returns (uint256) {
521     return allowed[_owner][_spender];
522   }
523 
524   /**
525    * @dev Increase the amount of tokens that an owner allowed to a spender.
526    *
527    * approve should be called when allowed[_spender] == 0. To increment
528    * allowed value is better to use this function to avoid 2 calls (and wait until
529    * the first transaction is mined)
530    * From MonolithDAO Token.sol
531    * @param _spender The address which will spend the funds.
532    * @param _addedValue The amount of tokens to increase the allowance by.
533    */
534   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
535     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
536     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
537     return true;
538   }
539 
540   /**
541    * @dev Decrease the amount of tokens that an owner allowed to a spender.
542    *
543    * approve should be called when allowed[_spender] == 0. To decrement
544    * allowed value is better to use this function to avoid 2 calls (and wait until
545    * the first transaction is mined)
546    * From MonolithDAO Token.sol
547    * @param _spender The address which will spend the funds.
548    * @param _subtractedValue The amount of tokens to decrease the allowance by.
549    */
550   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
551     uint oldValue = allowed[msg.sender][_spender];
552     if (_subtractedValue > oldValue) {
553       allowed[msg.sender][_spender] = 0;
554     } else {
555       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
556     }
557     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
558     return true;
559   }
560 
561 }
562 
563 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
564 
565 /**
566  * @title Mintable token
567  * @dev Simple ERC20 Token example, with mintable token creation
568  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
569  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
570  */
571 contract MintableToken is StandardToken, Ownable {
572   event Mint(address indexed to, uint256 amount);
573   event MintFinished();
574 
575   bool public mintingFinished = false;
576 
577 
578   modifier canMint() {
579     require(!mintingFinished);
580     _;
581   }
582 
583   /**
584    * @dev Function to mint tokens
585    * @param _to The address that will receive the minted tokens.
586    * @param _amount The amount of tokens to mint.
587    * @return A boolean that indicates if the operation was successful.
588    */
589   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
590     totalSupply_ = totalSupply_.add(_amount);
591     balances[_to] = balances[_to].add(_amount);
592     emit Mint(_to, _amount);
593     emit Transfer(address(0), _to, _amount);
594     return true;
595   }
596 
597   /**
598    * @dev Function to stop minting new tokens.
599    * @return True if the operation was successful.
600    */
601   function finishMinting() onlyOwner canMint public returns (bool) {
602     mintingFinished = true;
603     emit MintFinished();
604     return true;
605   }
606 }
607 
608 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
609 
610 /**
611  * @title Capped token
612  * @dev Mintable token with a token cap.
613  */
614 contract CappedToken is MintableToken {
615 
616   uint256 public cap;
617 
618   function CappedToken(uint256 _cap) public {
619     require(_cap > 0);
620     cap = _cap;
621   }
622 
623   /**
624    * @dev Function to mint tokens
625    * @param _to The address that will receive the minted tokens.
626    * @param _amount The amount of tokens to mint.
627    * @return A boolean that indicates if the operation was successful.
628    */
629   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
630     require(totalSupply_.add(_amount) <= cap);
631 
632     return super.mint(_to, _amount);
633   }
634 
635 }
636 
637 // File: contracts/CareerChainToken.sol
638 
639 //CCH is a capped token with a max supply of 93000000 tokenSupply
640 //It is a burnable token as well
641 contract CareerChainToken is CappedToken(93000000000000000000000000), BurnableToken  {
642     string public name = "CareerChain Token";
643     string public symbol = "CCH";
644     uint8 public decimals = 18;
645 
646     //only the owner is allowed to burn tokens
647     function burn(uint256 _value) public onlyOwner {
648         _burn(msg.sender, _value);
649 
650     }
651 
652 }
653 
654 // File: contracts/CareerChainPrivateSale.sol
655 
656 /*
657   Token sale contract for the private sale
658   This contract has time constraints and only whitelisted accounts can invest
659   Tokens will not be issued to the investor immediately, but stored in this contract until the lock-up ends.
660   When the lock-up has ended, investors can withdraw their tokens to their own account
661 
662   A staged lock-up is used with 6 grades:
663     firstVestedLockUpAmount sit in lock-up until lockupEndTime[0]
664     stagedVestedLockUpAmounts sit in lock-up until lockupEndTime[1]
665     ...
666     stagedVestedLockUpAmounts sit in lock-up until lockupEndTime[6]
667 
668   For example:
669   When an investor buys 3,000,000 tokens:
670       875,000 tokens in lock-up till Dec 31 2018
671     1,000,000 tokens in lock-up till Jun 30 2018
672     1,000,000 tokens in lock-up till Dec 31 2019
673       125,000 tokens in lock-up till Jun 30 2019
674 */
675 contract CareerChainPrivateSale is TimedCrowdsale, WhitelistedCrowdsale  {
676     using SafeMath for uint256;
677 
678     //Tokens sold (but locked in the contract)
679     uint256 public tokensStillInLockup;
680 
681     //lock-up end time, 6 stages
682     uint256[6] public lockupEndTime;
683 
684     //balances in the lock-ups
685     mapping(address => uint256) public balances;
686 
687     //released from lock-ups
688     mapping(address => uint256) public released;
689 
690     //vesting levels
691     uint256 public firstVestedLockUpAmount;
692     uint256 public stagedVestedLockUpAmounts;
693 
694     //constructor function
695     //initializing lock-up periods and corresponding amounts of tokens
696     function CareerChainPrivateSale
697     (
698         uint256 _openingTime,
699         uint256 _closingTime,
700         uint256 _rate,
701         address _wallet,
702         uint256[6] _lockupEndTime,
703         uint256 _firstVestedLockUpAmount,
704         uint256 _stagedVestedLockUpAmounts,
705         CareerChainToken _token
706     )
707         public
708         Crowdsale(_rate, _wallet, _token)
709         TimedCrowdsale(_openingTime, _closingTime)
710     {
711         // solium-disable-next-line security/no-block-members
712         require(_lockupEndTime[0] >= block.timestamp);
713         require(_lockupEndTime[1] >= _lockupEndTime[0]);
714         require(_lockupEndTime[2] >= _lockupEndTime[1]);
715         require(_lockupEndTime[3] >= _lockupEndTime[2]);
716         require(_lockupEndTime[4] >= _lockupEndTime[3]);
717         require(_lockupEndTime[5] >= _lockupEndTime[4]);
718 
719         lockupEndTime = _lockupEndTime;
720 
721         firstVestedLockUpAmount = _firstVestedLockUpAmount;
722         stagedVestedLockUpAmounts = _stagedVestedLockUpAmounts;
723     }
724 
725 
726     //Overrides parent by storing balances instead of issuing tokens right away.
727     // @param _beneficiary Token purchaser
728     // @param _tokenAmount Amount of tokens purchased
729     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
730 
731         uint256 newTokensSold = tokensStillInLockup.add(_tokenAmount);
732         require(newTokensSold <= token.balanceOf(address(this)));
733         tokensStillInLockup = newTokensSold;
734 
735         //add tokens to contract token balance (due to lock-up)
736         balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
737 
738     }
739 
740     //when sale has ended, send unsold tokens back to token contract
741     // @param _beneficiary Token contract
742     function TransferUnsoldTokensBackToTokenContract(address _beneficiary) public onlyOwner {
743 
744         require(hasClosed());
745         uint256 unSoldTokens = token.balanceOf(address(this)).sub(tokensStillInLockup);
746 
747         token.transfer(_beneficiary, unSoldTokens);
748     }
749 
750     //when sale isn't ended, issue tokens to investors paid with fiat currency
751     // @param _beneficiary Token purchaser (with fiat)
752     // @param _tokenAmount Amount of tokens purchased
753     function IssueTokensToInvestors(address _beneficiary, uint256 _amount) public onlyOwner onlyWhileOpen {
754         require(_beneficiary != address(0));
755         _processPurchase(_beneficiary, _amount);
756     }
757 
758     //owner is able to change rate in case of big price fluctuations of ether (on the market)
759     function _changeRate(uint256 _rate) public onlyOwner {
760         require(_rate > 0);
761         rate = _rate;
762     }
763 
764     //Calculates the amount that has already vested but hasn't been released yet.
765     function releasableAmount() private view returns (uint256) {
766         return vestedAmount().sub(released[msg.sender]);
767     }
768 
769     // Calculates the amount that has already vested.
770     function vestedAmount() private view returns (uint256) {
771         uint256 lockupStage = 0;
772         uint256 releasable = 0;
773 
774         //determine current lock-up phase
775         uint256 i = 0;
776         // solium-disable-next-line security/no-block-members
777         while (i < lockupEndTime.length && lockupEndTime[i] <= now) {
778             lockupStage = lockupStage.add(1);
779             i = i.add(1);
780         }
781 
782         //if lockupStage == 0 then all tokens are still in lock-up (first lock-up period not ended yet)
783         if(lockupStage>0) {
784             //calculate the releasable amount depending on the current lock-up stage
785             releasable = (lockupStage.sub(1).mul(stagedVestedLockUpAmounts)).add(firstVestedLockUpAmount);
786         }
787 
788         return releasable;
789     }
790 
791     //Withdraw tokens only after lock-up ends, applying the staged lock-up scheme.
792     function withdrawTokens() public {
793         uint256 tobeReleased = 0;
794         uint256 unreleased = releasableAmount();
795 
796         //max amount to be withdrawn is the releasable amount, excess stays in lock-up, unless all lock-ups have ended
797         // solium-disable-next-line security/no-block-members
798         if(balances[msg.sender] >= unreleased && lockupEndTime[lockupEndTime.length-1] > now)
799         {
800             tobeReleased = unreleased;
801         }
802         else
803         {
804             tobeReleased = balances[msg.sender];
805         }
806 
807         //revert transaction when nothing to be withdrawn
808         require(tobeReleased > 0);
809 
810         balances[msg.sender] = balances[msg.sender].sub(tobeReleased);
811         tokensStillInLockup = tokensStillInLockup.sub(tobeReleased);
812         released[msg.sender] = released[msg.sender].add(tobeReleased);
813 
814         _deliverTokens(msg.sender, tobeReleased);
815 
816     }
817 
818 }