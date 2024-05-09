1 pragma solidity ^0.4.23;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
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
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     emit OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract ERC20 is ERC20Basic {
106   function allowance(address owner, address spender) public view returns (uint256);
107   function transferFrom(address from, address to, uint256 value) public returns (bool);
108   function approve(address spender, uint256 value) public returns (bool);
109   event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 /**
113  * @title Crowdsale
114  * @dev Crowdsale is a base contract for managing a token crowdsale,
115  * allowing investors to purchase tokens with ether. This contract implements
116  * such functionality in its most fundamental form and can be extended to provide additional
117  * functionality and/or custom behavior.
118  * The external interface represents the basic interface for purchasing tokens, and conform
119  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
120  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
121  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
122  * behavior.
123  */
124 contract Crowdsale {
125   using SafeMath for uint256;
126 
127   // The token being sold
128   ERC20 public token;
129 
130   // Address where funds are collected
131   address public wallet;
132 
133   // How many token units a buyer gets per wei
134   uint256 public rate;
135 
136   // Amount of wei raised
137   uint256 public weiRaised;
138 
139   /**
140    * Event for token purchase logging
141    * @param purchaser who paid for the tokens
142    * @param beneficiary who got the tokens
143    * @param value weis paid for purchase
144    * @param amount amount of tokens purchased
145    */
146   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
147 
148   /**
149    * @param _rate Number of token units a buyer gets per wei
150    * @param _wallet Address where collected funds will be forwarded to
151    * @param _token Address of the token being sold
152    */
153   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
154     require(_rate > 0);
155     require(_wallet != address(0));
156     require(_token != address(0));
157 
158     rate = _rate;
159     wallet = _wallet;
160     token = _token;
161   }
162 
163   // -----------------------------------------
164   // Crowdsale external interface
165   // -----------------------------------------
166 
167   /**
168    * @dev fallback function ***DO NOT OVERRIDE***
169    */
170   function () external payable {
171     buyTokens(msg.sender);
172   }
173 
174   /**
175    * @dev low level token purchase ***DO NOT OVERRIDE***
176    * @param _beneficiary Address performing the token purchase
177    */
178   function buyTokens(address _beneficiary) public payable {
179 
180     uint256 weiAmount = msg.value;
181     _preValidatePurchase(_beneficiary, weiAmount);
182 
183     // calculate token amount to be created
184     uint256 tokens = _getTokenAmount(weiAmount);
185 
186     // update state
187     weiRaised = weiRaised.add(weiAmount);
188 
189     _processPurchase(_beneficiary, tokens);
190     emit TokenPurchase(
191       msg.sender,
192       _beneficiary,
193       weiAmount,
194       tokens
195     );
196 
197     _updatePurchasingState(_beneficiary, weiAmount);
198 
199     _forwardFunds();
200     _postValidatePurchase(_beneficiary, weiAmount);
201   }
202 
203   // -----------------------------------------
204   // Internal interface (extensible)
205   // -----------------------------------------
206 
207   /**
208    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
209    * @param _beneficiary Address performing the token purchase
210    * @param _weiAmount Value in wei involved in the purchase
211    */
212   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
213     require(_beneficiary != address(0));
214     require(_weiAmount != 0);
215   }
216 
217   /**
218    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
219    * @param _beneficiary Address performing the token purchase
220    * @param _weiAmount Value in wei involved in the purchase
221    */
222   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
223     // optional override
224   }
225 
226   /**
227    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
228    * @param _beneficiary Address performing the token purchase
229    * @param _tokenAmount Number of tokens to be emitted
230    */
231   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
232     token.transfer(_beneficiary, _tokenAmount);
233   }
234 
235   /**
236    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
237    * @param _beneficiary Address receiving the tokens
238    * @param _tokenAmount Number of tokens to be purchased
239    */
240   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
241     _deliverTokens(_beneficiary, _tokenAmount);
242   }
243 
244   /**
245    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
246    * @param _beneficiary Address receiving the tokens
247    * @param _weiAmount Value in wei involved in the purchase
248    */
249   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
250     // optional override
251   }
252 
253   /**
254    * @dev Override to extend the way in which ether is converted to tokens.
255    * @param _weiAmount Value in wei to be converted into tokens
256    * @return Number of tokens that can be purchased with the specified _weiAmount
257    */
258   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
259     return _weiAmount.mul(rate);
260   }
261 
262   /**
263    * @dev Determines how ETH is stored/forwarded on purchases.
264    */
265   function _forwardFunds() internal {
266     wallet.transfer(msg.value);
267   }
268 }
269 
270 /**
271  * @title CappedCrowdsale
272  * @dev Crowdsale with a limit for total contributions.
273  */
274 contract CappedCrowdsale is Crowdsale {
275   using SafeMath for uint256;
276 
277   uint256 public cap;
278 
279   /**
280    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
281    * @param _cap Max amount of wei to be contributed
282    */
283   function CappedCrowdsale(uint256 _cap) public {
284     require(_cap > 0);
285     cap = _cap;
286   }
287 
288   /**
289    * @dev Checks whether the cap has been reached. 
290    * @return Whether the cap was reached
291    */
292   function capReached() public view returns (bool) {
293     return weiRaised >= cap;
294   }
295 
296   /**
297    * @dev Extend parent behavior requiring purchase to respect the funding cap.
298    * @param _beneficiary Token purchaser
299    * @param _weiAmount Amount of wei contributed
300    */
301   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
302     super._preValidatePurchase(_beneficiary, _weiAmount);
303     require(weiRaised.add(_weiAmount) <= cap);
304   }
305 
306 }
307 
308 /**
309  * @title Basic token
310  * @dev Basic version of StandardToken, with no allowances.
311  */
312 contract BasicToken is ERC20Basic {
313   using SafeMath for uint256;
314 
315   mapping(address => uint256) balances;
316 
317   uint256 totalSupply_;
318 
319   /**
320   * @dev total number of tokens in existence
321   */
322   function totalSupply() public view returns (uint256) {
323     return totalSupply_;
324   }
325 
326   /**
327   * @dev transfer token for a specified address
328   * @param _to The address to transfer to.
329   * @param _value The amount to be transferred.
330   */
331   function transfer(address _to, uint256 _value) public returns (bool) {
332     require(_to != address(0));
333     require(_value <= balances[msg.sender]);
334 
335     balances[msg.sender] = balances[msg.sender].sub(_value);
336     balances[_to] = balances[_to].add(_value);
337     emit Transfer(msg.sender, _to, _value);
338     return true;
339   }
340 
341   /**
342   * @dev Gets the balance of the specified address.
343   * @param _owner The address to query the the balance of.
344   * @return An uint256 representing the amount owned by the passed address.
345   */
346   function balanceOf(address _owner) public view returns (uint256) {
347     return balances[_owner];
348   }
349 
350 }
351 
352 /**
353  * @title Standard ERC20 token
354  *
355  * @dev Implementation of the basic standard token.
356  * @dev https://github.com/ethereum/EIPs/issues/20
357  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
358  */
359 contract StandardToken is ERC20, BasicToken {
360 
361   mapping (address => mapping (address => uint256)) internal allowed;
362 
363 
364   /**
365    * @dev Transfer tokens from one address to another
366    * @param _from address The address which you want to send tokens from
367    * @param _to address The address which you want to transfer to
368    * @param _value uint256 the amount of tokens to be transferred
369    */
370   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
371     require(_to != address(0));
372     require(_value <= balances[_from]);
373     require(_value <= allowed[_from][msg.sender]);
374 
375     balances[_from] = balances[_from].sub(_value);
376     balances[_to] = balances[_to].add(_value);
377     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
378     emit Transfer(_from, _to, _value);
379     return true;
380   }
381 
382   /**
383    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
384    *
385    * Beware that changing an allowance with this method brings the risk that someone may use both the old
386    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
387    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
388    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
389    * @param _spender The address which will spend the funds.
390    * @param _value The amount of tokens to be spent.
391    */
392   function approve(address _spender, uint256 _value) public returns (bool) {
393     allowed[msg.sender][_spender] = _value;
394     emit Approval(msg.sender, _spender, _value);
395     return true;
396   }
397 
398   /**
399    * @dev Function to check the amount of tokens that an owner allowed to a spender.
400    * @param _owner address The address which owns the funds.
401    * @param _spender address The address which will spend the funds.
402    * @return A uint256 specifying the amount of tokens still available for the spender.
403    */
404   function allowance(address _owner, address _spender) public view returns (uint256) {
405     return allowed[_owner][_spender];
406   }
407 
408   /**
409    * @dev Increase the amount of tokens that an owner allowed to a spender.
410    *
411    * approve should be called when allowed[_spender] == 0. To increment
412    * allowed value is better to use this function to avoid 2 calls (and wait until
413    * the first transaction is mined)
414    * From MonolithDAO Token.sol
415    * @param _spender The address which will spend the funds.
416    * @param _addedValue The amount of tokens to increase the allowance by.
417    */
418   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
419     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
420     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
421     return true;
422   }
423 
424   /**
425    * @dev Decrease the amount of tokens that an owner allowed to a spender.
426    *
427    * approve should be called when allowed[_spender] == 0. To decrement
428    * allowed value is better to use this function to avoid 2 calls (and wait until
429    * the first transaction is mined)
430    * From MonolithDAO Token.sol
431    * @param _spender The address which will spend the funds.
432    * @param _subtractedValue The amount of tokens to decrease the allowance by.
433    */
434   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
435     uint oldValue = allowed[msg.sender][_spender];
436     if (_subtractedValue > oldValue) {
437       allowed[msg.sender][_spender] = 0;
438     } else {
439       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
440     }
441     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
442     return true;
443   }
444 
445 }
446 
447 /**
448  * @title Mintable token
449  * @dev Simple ERC20 Token example, with mintable token creation
450  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
451  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
452  */
453 contract MintableToken is StandardToken, Ownable {
454   event Mint(address indexed to, uint256 amount);
455   event MintFinished();
456 
457   bool public mintingFinished = false;
458 
459 
460   modifier canMint() {
461     require(!mintingFinished);
462     _;
463   }
464 
465   /**
466    * @dev Function to mint tokens
467    * @param _to The address that will receive the minted tokens.
468    * @param _amount The amount of tokens to mint.
469    * @return A boolean that indicates if the operation was successful.
470    */
471   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
472     totalSupply_ = totalSupply_.add(_amount);
473     balances[_to] = balances[_to].add(_amount);
474     emit Mint(_to, _amount);
475     emit Transfer(address(0), _to, _amount);
476     return true;
477   }
478 
479   /**
480    * @dev Function to stop minting new tokens.
481    * @return True if the operation was successful.
482    */
483   function finishMinting() onlyOwner canMint public returns (bool) {
484     mintingFinished = true;
485     emit MintFinished();
486     return true;
487   }
488 }
489 
490 /**
491  * @title MintedCrowdsale
492  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
493  * Token ownership should be transferred to MintedCrowdsale for minting. 
494  */
495 contract MintedCrowdsale is Crowdsale {
496 
497   /**
498    * @dev Overrides delivery by minting tokens upon purchase.
499    * @param _beneficiary Token purchaser
500    * @param _tokenAmount Number of tokens to be minted
501    */
502   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
503     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
504   }
505 }
506 
507 /**
508  * @title WhitelistedCrowdsale
509  * @dev Crowdsale in which only whitelisted users can contribute.
510  */
511 contract WhitelistedCrowdsale is Crowdsale, Ownable {
512 
513   mapping(address => bool) public whitelist;
514 
515   /**
516    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
517    */
518   modifier isWhitelisted(address _beneficiary) {
519     require(whitelist[_beneficiary]);
520     _;
521   }
522 
523   /**
524    * @dev Adds single address to whitelist.
525    * @param _beneficiary Address to be added to the whitelist
526    */
527   function addToWhitelist(address _beneficiary) external onlyOwner {
528     whitelist[_beneficiary] = true;
529   }
530 
531   /**
532    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
533    * @param _beneficiaries Addresses to be added to the whitelist
534    */
535   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
536     for (uint256 i = 0; i < _beneficiaries.length; i++) {
537       whitelist[_beneficiaries[i]] = true;
538     }
539   }
540 
541   /**
542    * @dev Removes single address from whitelist.
543    * @param _beneficiary Address to be removed to the whitelist
544    */
545   function removeFromWhitelist(address _beneficiary) external onlyOwner {
546     whitelist[_beneficiary] = false;
547   }
548 
549   /**
550    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
551    * @param _beneficiary Token beneficiary
552    * @param _weiAmount Amount of wei contributed
553    */
554   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
555     super._preValidatePurchase(_beneficiary, _weiAmount);
556   }
557 
558 }
559 
560 contract ClosableCrowdsale is Ownable {
561 
562     bool public isClosed = false;
563 
564     event Closed();
565 
566     modifier onlyOpenCrowdsale() {
567         require(!isClosed);
568         _;
569     }
570 
571     /**
572      * @dev Must be called after crowdsale ends, to do some extra finalization
573      * work. Calls the contract's close function.
574      */
575     function closeCrowdsale() onlyOwner onlyOpenCrowdsale public {
576         close();
577         emit Closed();
578 
579         isClosed = true;
580     }
581 
582     /**
583      * @dev Can be overridden to add finalization logic. The overriding function
584      * should call super.close() to ensure the chain of finalization is
585      * executed entirely.
586      */
587     function close() internal {
588     }
589 
590 }
591 
592 contract MaxContributionCrowdsale {
593 
594     function getMaxContributionAmount() public view returns (uint256) {
595         // ToDo: Change value to real before deploy
596         return 15 ether;
597     }
598 
599 }
600 
601 contract BasicCrowdsale is MintedCrowdsale, CappedCrowdsale, ClosableCrowdsale {
602     uint256 public startingTime;
603 
604     address public maxContributionAmountContract;
605 
606     uint256 constant MIN_CONTRIBUTION_AMOUNT = 1 finney;
607 
608     uint256 constant PRE_SALE_CAP = 19747 ether;
609     uint256 constant PRE_SALE_RATE = 304;
610 
611     uint256 constant BONUS_1_AMOUNT = 39889 ether;
612     uint256 constant BONUS_2_AMOUNT = 60031 ether;
613     uint256 constant BONUS_3_AMOUNT = 80173 ether;
614     uint256 constant BONUS_4_AMOUNT = 92021 ether;
615     uint256 constant BONUS_5_AMOUNT = 103079 ether;
616 
617     uint256 constant BONUS_1_CAP = PRE_SALE_CAP + BONUS_1_AMOUNT;
618     uint256 constant BONUS_1_RATE = 276;
619 
620     uint256 constant BONUS_2_CAP = BONUS_1_CAP + BONUS_2_AMOUNT;
621     uint256 constant BONUS_2_RATE = 266;
622 
623     uint256 constant BONUS_3_CAP = BONUS_2_CAP + BONUS_3_AMOUNT;
624     uint256 constant BONUS_3_RATE = 261;
625 
626     uint256 constant BONUS_4_CAP = BONUS_3_CAP + BONUS_4_AMOUNT;
627     uint256 constant BONUS_4_RATE = 258;
628 
629     uint256 constant BONUS_5_CAP = BONUS_4_CAP + BONUS_5_AMOUNT;
630     uint256 constant REGULAR_RATE = 253;
631 
632     event LogBountyTokenMinted(address minter, address beneficiary, uint256 amount);
633 
634     constructor(uint256 _rate, address _wallet, address _token, uint256 _cap, address _maxContributionAmountContract)
635     Crowdsale(_rate, _wallet, ERC20(_token))
636     CappedCrowdsale(_cap) public {
637         startingTime = now;
638         maxContributionAmountContract = _maxContributionAmountContract;
639     }
640 
641     function setMaxContributionCrowdsaleAddress(address _maxContributionAmountContractAddress) public onlyOwner {
642         maxContributionAmountContract = _maxContributionAmountContractAddress;
643     }
644 
645     function getMaxContributionAmount() public view returns(uint256) {
646         return MaxContributionCrowdsale(maxContributionAmountContract).getMaxContributionAmount();
647     }
648 
649     function _preValidatePurchase(address beneficiary, uint256 weiAmount) onlyOpenCrowdsale internal {
650         require(msg.value >= MIN_CONTRIBUTION_AMOUNT);
651         require(msg.value <= getMaxContributionAmount());
652         super._preValidatePurchase(beneficiary, weiAmount);
653     }
654 
655     function getRate() public constant returns (uint256) {
656         require(now >= startingTime);
657 
658         // Pre Sale Period
659         if (weiRaised < PRE_SALE_CAP) {
660             return PRE_SALE_RATE;
661         }
662 
663         //First Bonus Period
664         if (weiRaised < BONUS_1_CAP) {
665             return BONUS_1_RATE;
666         }
667 
668         //Second Bonus Period
669         if (weiRaised < BONUS_2_CAP) {
670             return BONUS_2_RATE;
671         }
672 
673         //Third Bonus Period
674         if (weiRaised < BONUS_3_CAP) {
675             return BONUS_3_RATE;
676         }
677 
678         //Fourth Bonus Period
679         if (weiRaised < BONUS_4_CAP) {
680             return BONUS_4_RATE;
681         }
682 
683         // Default Period
684         return rate;
685     }
686 
687     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
688         uint256 _rate = getRate();
689         return _weiAmount.mul(_rate);
690     }
691 
692     function createBountyToken(address beneficiary, uint256 amount) public onlyOwner onlyOpenCrowdsale returns (bool) {
693         MintableToken(token).mint(beneficiary, amount);
694         LogBountyTokenMinted(msg.sender, beneficiary, amount);
695         return true;
696     }
697 
698     function close() internal {
699         MintableToken(token).transferOwnership(owner);
700         super.close();
701     }
702 
703 }
704 
705 contract WhitelistedBasicCrowdsale is BasicCrowdsale, WhitelistedCrowdsale {
706 
707 
708     constructor(uint256 _rate, address _wallet, address _token, uint256 _cap, address _maxContributionAmountContract)
709     BasicCrowdsale(_rate, _wallet, ERC20(_token), _cap, _maxContributionAmountContract)
710     WhitelistedCrowdsale()
711     public {
712     }
713 }