1 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.21;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
19 
20 pragma solidity ^0.4.21;
21 
22 
23 
24 /**
25  * @title ERC20 interface
26  * @dev see https://github.com/ethereum/EIPs/issues/20
27  */
28 contract ERC20 is ERC20Basic {
29   function allowance(address owner, address spender) public view returns (uint256);
30   function transferFrom(address from, address to, uint256 value) public returns (bool);
31   function approve(address spender, uint256 value) public returns (bool);
32   event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 // File: zeppelin-solidity/contracts/math/SafeMath.sol
36 
37 pragma solidity ^0.4.21;
38 
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
50     if (a == 0) {
51       return 0;
52     }
53     c = a * b;
54     assert(c / a == b);
55     return c;
56   }
57 
58   /**
59   * @dev Integer division of two numbers, truncating the quotient.
60   */
61   function div(uint256 a, uint256 b) internal pure returns (uint256) {
62     // assert(b > 0); // Solidity automatically throws when dividing by 0
63     // uint256 c = a / b;
64     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65     return a / b;
66   }
67 
68   /**
69   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
70   */
71   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   /**
77   * @dev Adds two numbers, throws on overflow.
78   */
79   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
80     c = a + b;
81     assert(c >= a);
82     return c;
83   }
84 }
85 
86 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
87 
88 pragma solidity ^0.4.21;
89 
90 
91 
92 
93 /**
94  * @title Crowdsale
95  * @dev Crowdsale is a base contract for managing a token crowdsale,
96  * allowing investors to purchase tokens with ether. This contract implements
97  * such functionality in its most fundamental form and can be extended to provide additional
98  * functionality and/or custom behavior.
99  * The external interface represents the basic interface for purchasing tokens, and conform
100  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
101  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
102  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
103  * behavior.
104  */
105 contract Crowdsale {
106   using SafeMath for uint256;
107 
108   // The token being sold
109   ERC20 public token;
110 
111   // Address where funds are collected
112   address public wallet;
113 
114   // How many token units a buyer gets per wei
115   uint256 public rate;
116 
117   // Amount of wei raised
118   uint256 public weiRaised;
119 
120   /**
121    * Event for token purchase logging
122    * @param purchaser who paid for the tokens
123    * @param beneficiary who got the tokens
124    * @param value weis paid for purchase
125    * @param amount amount of tokens purchased
126    */
127   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
128 
129   /**
130    * @param _rate Number of token units a buyer gets per wei
131    * @param _wallet Address where collected funds will be forwarded to
132    * @param _token Address of the token being sold
133    */
134   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
135     require(_rate > 0);
136     require(_wallet != address(0));
137     require(_token != address(0));
138 
139     rate = _rate;
140     wallet = _wallet;
141     token = _token;
142   }
143 
144   // -----------------------------------------
145   // Crowdsale external interface
146   // -----------------------------------------
147 
148   /**
149    * @dev fallback function ***DO NOT OVERRIDE***
150    */
151   function () external payable {
152     buyTokens(msg.sender);
153   }
154 
155   /**
156    * @dev low level token purchase ***DO NOT OVERRIDE***
157    * @param _beneficiary Address performing the token purchase
158    */
159   function buyTokens(address _beneficiary) public payable {
160 
161     uint256 weiAmount = msg.value;
162     _preValidatePurchase(_beneficiary, weiAmount);
163 
164     // calculate token amount to be created
165     uint256 tokens = _getTokenAmount(weiAmount);
166 
167     // update state
168     weiRaised = weiRaised.add(weiAmount);
169 
170     _processPurchase(_beneficiary, tokens);
171     emit TokenPurchase(
172       msg.sender,
173       _beneficiary,
174       weiAmount,
175       tokens
176     );
177 
178     _updatePurchasingState(_beneficiary, weiAmount);
179 
180     _forwardFunds();
181     _postValidatePurchase(_beneficiary, weiAmount);
182   }
183 
184   // -----------------------------------------
185   // Internal interface (extensible)
186   // -----------------------------------------
187 
188   /**
189    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
190    * @param _beneficiary Address performing the token purchase
191    * @param _weiAmount Value in wei involved in the purchase
192    */
193   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
194     require(_beneficiary != address(0));
195     require(_weiAmount != 0);
196   }
197 
198   /**
199    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
200    * @param _beneficiary Address performing the token purchase
201    * @param _weiAmount Value in wei involved in the purchase
202    */
203   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
204     // optional override
205   }
206 
207   /**
208    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
209    * @param _beneficiary Address performing the token purchase
210    * @param _tokenAmount Number of tokens to be emitted
211    */
212   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
213     token.transfer(_beneficiary, _tokenAmount);
214   }
215 
216   /**
217    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
218    * @param _beneficiary Address receiving the tokens
219    * @param _tokenAmount Number of tokens to be purchased
220    */
221   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
222     _deliverTokens(_beneficiary, _tokenAmount);
223   }
224 
225   /**
226    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
227    * @param _beneficiary Address receiving the tokens
228    * @param _weiAmount Value in wei involved in the purchase
229    */
230   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
231     // optional override
232   }
233 
234   /**
235    * @dev Override to extend the way in which ether is converted to tokens.
236    * @param _weiAmount Value in wei to be converted into tokens
237    * @return Number of tokens that can be purchased with the specified _weiAmount
238    */
239   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
240     return _weiAmount.mul(rate);
241   }
242 
243   /**
244    * @dev Determines how ETH is stored/forwarded on purchases.
245    */
246   function _forwardFunds() internal {
247     wallet.transfer(msg.value);
248   }
249 }
250 
251 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
252 
253 pragma solidity ^0.4.21;
254 
255 
256 
257 
258 /**
259  * @title Basic token
260  * @dev Basic version of StandardToken, with no allowances.
261  */
262 contract BasicToken is ERC20Basic {
263   using SafeMath for uint256;
264 
265   mapping(address => uint256) balances;
266 
267   uint256 totalSupply_;
268 
269   /**
270   * @dev total number of tokens in existence
271   */
272   function totalSupply() public view returns (uint256) {
273     return totalSupply_;
274   }
275 
276   /**
277   * @dev transfer token for a specified address
278   * @param _to The address to transfer to.
279   * @param _value The amount to be transferred.
280   */
281   function transfer(address _to, uint256 _value) public returns (bool) {
282     require(_to != address(0));
283     require(_value <= balances[msg.sender]);
284 
285     balances[msg.sender] = balances[msg.sender].sub(_value);
286     balances[_to] = balances[_to].add(_value);
287     emit Transfer(msg.sender, _to, _value);
288     return true;
289   }
290 
291   /**
292   * @dev Gets the balance of the specified address.
293   * @param _owner The address to query the the balance of.
294   * @return An uint256 representing the amount owned by the passed address.
295   */
296   function balanceOf(address _owner) public view returns (uint256) {
297     return balances[_owner];
298   }
299 
300 }
301 
302 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
303 
304 pragma solidity ^0.4.21;
305 
306 
307 
308 
309 /**
310  * @title Standard ERC20 token
311  *
312  * @dev Implementation of the basic standard token.
313  * @dev https://github.com/ethereum/EIPs/issues/20
314  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
315  */
316 contract StandardToken is ERC20, BasicToken {
317 
318   mapping (address => mapping (address => uint256)) internal allowed;
319 
320 
321   /**
322    * @dev Transfer tokens from one address to another
323    * @param _from address The address which you want to send tokens from
324    * @param _to address The address which you want to transfer to
325    * @param _value uint256 the amount of tokens to be transferred
326    */
327   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
328     require(_to != address(0));
329     require(_value <= balances[_from]);
330     require(_value <= allowed[_from][msg.sender]);
331 
332     balances[_from] = balances[_from].sub(_value);
333     balances[_to] = balances[_to].add(_value);
334     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
335     emit Transfer(_from, _to, _value);
336     return true;
337   }
338 
339   /**
340    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
341    *
342    * Beware that changing an allowance with this method brings the risk that someone may use both the old
343    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
344    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
345    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
346    * @param _spender The address which will spend the funds.
347    * @param _value The amount of tokens to be spent.
348    */
349   function approve(address _spender, uint256 _value) public returns (bool) {
350     allowed[msg.sender][_spender] = _value;
351     emit Approval(msg.sender, _spender, _value);
352     return true;
353   }
354 
355   /**
356    * @dev Function to check the amount of tokens that an owner allowed to a spender.
357    * @param _owner address The address which owns the funds.
358    * @param _spender address The address which will spend the funds.
359    * @return A uint256 specifying the amount of tokens still available for the spender.
360    */
361   function allowance(address _owner, address _spender) public view returns (uint256) {
362     return allowed[_owner][_spender];
363   }
364 
365   /**
366    * @dev Increase the amount of tokens that an owner allowed to a spender.
367    *
368    * approve should be called when allowed[_spender] == 0. To increment
369    * allowed value is better to use this function to avoid 2 calls (and wait until
370    * the first transaction is mined)
371    * From MonolithDAO Token.sol
372    * @param _spender The address which will spend the funds.
373    * @param _addedValue The amount of tokens to increase the allowance by.
374    */
375   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
376     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
377     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
378     return true;
379   }
380 
381   /**
382    * @dev Decrease the amount of tokens that an owner allowed to a spender.
383    *
384    * approve should be called when allowed[_spender] == 0. To decrement
385    * allowed value is better to use this function to avoid 2 calls (and wait until
386    * the first transaction is mined)
387    * From MonolithDAO Token.sol
388    * @param _spender The address which will spend the funds.
389    * @param _subtractedValue The amount of tokens to decrease the allowance by.
390    */
391   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
392     uint oldValue = allowed[msg.sender][_spender];
393     if (_subtractedValue > oldValue) {
394       allowed[msg.sender][_spender] = 0;
395     } else {
396       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
397     }
398     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
399     return true;
400   }
401 
402 }
403 
404 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
405 
406 pragma solidity ^0.4.21;
407 
408 
409 /**
410  * @title Ownable
411  * @dev The Ownable contract has an owner address, and provides basic authorization control
412  * functions, this simplifies the implementation of "user permissions".
413  */
414 contract Ownable {
415   address public owner;
416 
417 
418   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
419 
420 
421   /**
422    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
423    * account.
424    */
425   function Ownable() public {
426     owner = msg.sender;
427   }
428 
429   /**
430    * @dev Throws if called by any account other than the owner.
431    */
432   modifier onlyOwner() {
433     require(msg.sender == owner);
434     _;
435   }
436 
437   /**
438    * @dev Allows the current owner to transfer control of the contract to a newOwner.
439    * @param newOwner The address to transfer ownership to.
440    */
441   function transferOwnership(address newOwner) public onlyOwner {
442     require(newOwner != address(0));
443     emit OwnershipTransferred(owner, newOwner);
444     owner = newOwner;
445   }
446 
447 }
448 
449 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
450 
451 pragma solidity ^0.4.21;
452 
453 
454 
455 
456 /**
457  * @title Mintable token
458  * @dev Simple ERC20 Token example, with mintable token creation
459  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
460  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
461  */
462 contract MintableToken is StandardToken, Ownable {
463   event Mint(address indexed to, uint256 amount);
464   event MintFinished();
465 
466   bool public mintingFinished = false;
467 
468 
469   modifier canMint() {
470     require(!mintingFinished);
471     _;
472   }
473 
474   /**
475    * @dev Function to mint tokens
476    * @param _to The address that will receive the minted tokens.
477    * @param _amount The amount of tokens to mint.
478    * @return A boolean that indicates if the operation was successful.
479    */
480   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
481     totalSupply_ = totalSupply_.add(_amount);
482     balances[_to] = balances[_to].add(_amount);
483     emit Mint(_to, _amount);
484     emit Transfer(address(0), _to, _amount);
485     return true;
486   }
487 
488   /**
489    * @dev Function to stop minting new tokens.
490    * @return True if the operation was successful.
491    */
492   function finishMinting() onlyOwner canMint public returns (bool) {
493     mintingFinished = true;
494     emit MintFinished();
495     return true;
496   }
497 }
498 
499 // File: zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
500 
501 pragma solidity ^0.4.21;
502 
503 
504 
505 
506 /**
507  * @title MintedCrowdsale
508  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
509  * Token ownership should be transferred to MintedCrowdsale for minting. 
510  */
511 contract MintedCrowdsale is Crowdsale {
512 
513   /**
514    * @dev Overrides delivery by minting tokens upon purchase.
515    * @param _beneficiary Token purchaser
516    * @param _tokenAmount Number of tokens to be minted
517    */
518   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
519     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
520   }
521 }
522 
523 // File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
524 
525 pragma solidity ^0.4.21;
526 
527 
528 
529 
530 /**
531  * @title TimedCrowdsale
532  * @dev Crowdsale accepting contributions only within a time frame.
533  */
534 contract TimedCrowdsale is Crowdsale {
535   using SafeMath for uint256;
536 
537   uint256 public openingTime;
538   uint256 public closingTime;
539 
540   /**
541    * @dev Reverts if not in crowdsale time range.
542    */
543   modifier onlyWhileOpen {
544     // solium-disable-next-line security/no-block-members
545     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
546     _;
547   }
548 
549   /**
550    * @dev Constructor, takes crowdsale opening and closing times.
551    * @param _openingTime Crowdsale opening time
552    * @param _closingTime Crowdsale closing time
553    */
554   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
555     // solium-disable-next-line security/no-block-members
556     require(_openingTime >= block.timestamp);
557     require(_closingTime >= _openingTime);
558 
559     openingTime = _openingTime;
560     closingTime = _closingTime;
561   }
562 
563   /**
564    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
565    * @return Whether crowdsale period has elapsed
566    */
567   function hasClosed() public view returns (bool) {
568     // solium-disable-next-line security/no-block-members
569     return block.timestamp > closingTime;
570   }
571 
572   /**
573    * @dev Extend parent behavior requiring to be within contributing period
574    * @param _beneficiary Token purchaser
575    * @param _weiAmount Amount of wei contributed
576    */
577   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
578     super._preValidatePurchase(_beneficiary, _weiAmount);
579   }
580 
581 }
582 
583 // File: zeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
584 
585 pragma solidity ^0.4.21;
586 
587 
588 
589 
590 
591 /**
592  * @title FinalizableCrowdsale
593  * @dev Extension of Crowdsale where an owner can do extra work
594  * after finishing.
595  */
596 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
597   using SafeMath for uint256;
598 
599   bool public isFinalized = false;
600 
601   event Finalized();
602 
603   /**
604    * @dev Must be called after crowdsale ends, to do some extra finalization
605    * work. Calls the contract's finalization function.
606    */
607   function finalize() onlyOwner public {
608     require(!isFinalized);
609     require(hasClosed());
610 
611     finalization();
612     emit Finalized();
613 
614     isFinalized = true;
615   }
616 
617   /**
618    * @dev Can be overridden to add finalization logic. The overriding function
619    * should call super.finalization() to ensure the chain of finalization is
620    * executed entirely.
621    */
622   function finalization() internal {
623   }
624 
625 }
626 
627 // File: contracts/Crowdsale/BasicCrowdsale.sol
628 
629 pragma solidity ^0.4.24;
630 
631 
632 
633 
634 contract BasicCrowdsale is MintedCrowdsale, FinalizableCrowdsale {
635     
636     uint256 public cap = 100000000 * (10 ** 18); // Total number of MYO tokens that would be created
637     uint256 public capForSale = 71000000 * (10 ** 18); // Total MYO tokens that could be sold during the ICO
638     uint256 public bountyTokensCap = 5000000 * (10 ** 18); // Total number of MYO tokens that would be given as a reward
639     uint256 public reservedForTeamTokens = 29000000 * (10 ** 18); // Tokens reserved for rewardpool, advisors and team that will be minted after Crowdsale
640     uint256 public totalMintedBountyTokens; // Total number of MYO tokens given as a reward
641 
642     uint256 public privateSaleEndDate;
643     mapping (address => bool) public minters;
644 
645     uint256 constant MIN_CONTRIBUTION_AMOUNT = 10 finney;
646     uint256 constant MAX_CONTRIBUTION_AMOUNT = 250 ether;
647 
648     uint256 public constant PRIVATE_SALE_CAP = 26000000 * (10 ** 18);
649     uint256 public constant PRIVATE_SALE_DURATION = 24 days; // to be calculated according to deployment day; the end date should be 15 May
650 
651     uint256 public constant MAIN_SALE_DURATION = 60 days;
652     uint256 public mainSaleDurationExtentionLimitInDays = 120; //max days the duration of the ICO can be extended
653 
654     event LogFiatTokenMinted(address sender, address beficiary, uint256 amount);
655     event LogFiatTokenMintedToMany(address sender, address[] beneficiaries, uint256[] amount);
656     event LogBountyTokenMinted(address minter, address beneficiary, uint256 amount);
657     event LogBountyTokenMintedToMany(address sender, address[] beneficiaries, uint256[] amount);
658     event LogPrivateSaleExtended(uint256 extentionInDays);
659     event LogMainSaleExtended(uint256 extentionInDays);
660     event LogRateChanged(uint256 rate);
661     event LogMinterAdded(address minterAdded);
662     event LogMinterRemoved(address minterRemoved);
663 
664     constructor(uint256 _rate, address _wallet, address _token, uint256 _openingTime, uint256 _closingTime)
665     Crowdsale(_rate, _wallet, ERC20(_token))
666     TimedCrowdsale(_openingTime, _closingTime) public {
667         privateSaleEndDate = _openingTime.add(PRIVATE_SALE_DURATION);
668     }
669 
670     // only addresses who are allowed to mint
671     modifier onlyMinter (){
672         require(minters[msg.sender]);
673         _;
674     }
675 
676     function buyTokens(address beneficiary) public payable {
677         require(msg.value >= MIN_CONTRIBUTION_AMOUNT);
678         require(msg.value <= MAX_CONTRIBUTION_AMOUNT);
679         uint amount = _getTokenAmount(msg.value);
680         if(now <= privateSaleEndDate) {
681             require(MintableToken(token).totalSupply().add(amount) < PRIVATE_SALE_CAP);
682         }
683         
684         require(MintableToken(token).totalSupply().add(amount) <= capForSale);
685         super.buyTokens(beneficiary);
686     }
687 
688     function addMinter(address _minter) public onlyOwner {
689         require(_minter != address(0));
690         minters[_minter] = true;
691         emit LogMinterAdded(_minter);
692     }
693 
694     function removeMinter(address _minter) public onlyOwner {
695         minters[_minter] = false;
696         emit LogMinterRemoved(_minter);
697     }
698 
699     function createFiatToken(address beneficiary, uint256 amount) public onlyMinter() returns(bool){
700         require(!hasClosed());
701         mintFiatToken(beneficiary, amount);
702         emit LogFiatTokenMinted(msg.sender, beneficiary, amount);
703         return true;
704     }
705 
706     function createFiatTokenToMany(address[] beneficiaries, uint256[] amount) public onlyMinter() returns(bool){
707         multiBeneficiariesValidation(beneficiaries, amount);
708         for(uint i = 0; i < beneficiaries.length; i++){
709             mintFiatToken(beneficiaries[i], amount[i]);
710         } 
711         emit LogFiatTokenMintedToMany(msg.sender, beneficiaries, amount);
712         return true;
713     }
714 
715     function mintFiatToken(address beneficiary, uint256 amount) internal {
716         require(MintableToken(token).totalSupply().add(amount) <= capForSale);
717         MintableToken(token).mint(beneficiary, amount);
718     }
719 
720     function createBountyToken(address beneficiary, uint256 amount) public onlyMinter() returns (bool) {
721         require(!hasClosed());
722         mintBountyToken(beneficiary, amount);
723         emit LogBountyTokenMinted(msg.sender, beneficiary, amount);
724         return true;
725     }
726 
727     function createBountyTokenToMany(address[] beneficiaries, uint256[] amount) public onlyMinter() returns (bool) {
728         multiBeneficiariesValidation(beneficiaries, amount);
729         for(uint i = 0; i < beneficiaries.length; i++){
730             mintBountyToken(beneficiaries[i], amount[i]);
731         }
732         
733         emit LogBountyTokenMintedToMany(msg.sender, beneficiaries, amount);
734         return true;
735     }
736 
737     function mintBountyToken(address beneficiary, uint256 amount) internal {
738         require(MintableToken(token).totalSupply().add(amount) <= capForSale);
739         require(totalMintedBountyTokens.add(amount) <= bountyTokensCap);
740         MintableToken(token).mint(beneficiary, amount);
741         totalMintedBountyTokens = totalMintedBountyTokens.add(amount);
742     }
743 
744     function multiBeneficiariesValidation(address[] beneficiaries, uint256[] amount) internal view {
745         require(!hasClosed());
746         require(beneficiaries.length > 0);
747         require(beneficiaries.length == amount.length);
748     }
749 
750     /**
751         @param extentionInDays is a simple number of the days, e.c. 3 => 3 days
752      */
753     function extendPrivateSaleDuration(uint256 extentionInDays) public onlyOwner returns (bool) {
754         require(now <= privateSaleEndDate);
755         extentionInDays = extentionInDays.mul(1 days); // convert the days in seconds
756         privateSaleEndDate = privateSaleEndDate.add(extentionInDays);
757         closingTime = closingTime.add(extentionInDays);
758         emit LogPrivateSaleExtended(extentionInDays);
759         return true;
760     }
761 
762     /**
763         @param extentionInDays is a simple number of the days, e.c. 3 => 3 days
764      */
765     function extendMainSaleDuration(uint256 extentionInDays) public onlyOwner returns (bool) {
766         require(now > privateSaleEndDate);
767         require(!hasClosed());
768         require(mainSaleDurationExtentionLimitInDays.sub(extentionInDays) >= 0);
769 
770         uint256 extention = extentionInDays.mul(1 days); // convert the days in seconds
771         mainSaleDurationExtentionLimitInDays = mainSaleDurationExtentionLimitInDays.sub(extentionInDays); // substract days from the limit
772         closingTime = closingTime.add(extention);
773 
774         emit LogMainSaleExtended(extentionInDays);
775         return true;
776     }
777 
778     function changeRate(uint _newRate) public onlyOwner returns (bool) {
779         require(!hasClosed());
780         require(_newRate != 0);
781         rate = _newRate;
782         emit LogRateChanged(_newRate);
783         return true;
784     }
785 
786     // after finalization will be minted manually reservedForTeamTokens amount
787     function finalization() internal {
788         MintableToken(token).transferOwnership(owner);
789         super.finalization();
790     }
791 }
792 
793 // File: contracts/Crowdsale/MultipleWhitelistedCrowdsale.sol
794 
795 pragma solidity ^0.4.24;
796 
797 
798 
799 /**
800  * @title MultipleWhitelistedCrowdsale
801  * @dev Crowdsale in which only whitelisted users can contribute.
802  */
803 contract MultipleWhitelistedCrowdsale is Crowdsale, Ownable {
804 
805   mapping(address => bool) public whitelist;
806   // keeps all addresses who can manage the whitelist
807   mapping(address => bool) public whitelistManagers;
808 
809   constructor() public {
810       whitelistManagers[owner] = true;
811   }
812 
813   /**
814    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
815    */
816   modifier isWhitelisted(address _beneficiary) {
817     require(whitelist[_beneficiary]);
818     _;
819   }
820 
821   /**
822    * @dev Reverts if msg.sender is not whitelist manager
823    */
824   modifier onlyWhitelistManager(){
825       require(whitelistManagers[msg.sender]);
826       _;
827   }
828 
829   /**
830    * @dev Adds single address who can manage the whitelist.
831    * @param _manager Address to be added to the whitelistManagers
832    */
833   function addWhitelistManager(address _manager) public onlyOwner {
834       require(_manager != address(0));
835       whitelistManagers[_manager] = true;
836   }
837 
838   /**
839   * @param _manager Address to remove from whitelistManagers
840    */
841 
842   function removeWhitelistManager(address _manager) public onlyOwner {
843       whitelistManagers[_manager] = false;
844   }
845 
846   /**
847    * @dev Adds single address to whitelist.
848    * @param _beneficiary Address to be added to the whitelist
849    */
850   function addToWhitelist(address _beneficiary) external onlyWhitelistManager() {
851     whitelist[_beneficiary] = true;
852   }
853 
854   /**
855    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
856    * @param _beneficiaries Addresses to be added to the whitelist
857    */
858   function addManyToWhitelist(address[] _beneficiaries) external onlyWhitelistManager() {
859     for (uint256 i = 0; i < _beneficiaries.length; i++) {
860       whitelist[_beneficiaries[i]] = true;
861     }
862   }
863 
864   /**
865    * @dev Removes single address from whitelist.
866    * @param _beneficiary Address to be removed to the whitelist
867    */
868   function removeFromWhitelist(address _beneficiary) external onlyWhitelistManager() {
869     whitelist[_beneficiary] = false;
870   }
871 
872   /**
873    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
874    * @param _beneficiary Token beneficiary
875    * @param _weiAmount Amount of wei contributed
876    */
877   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
878     super._preValidatePurchase(_beneficiary, _weiAmount);
879   }
880 
881 }
882 
883 // File: contracts/Crowdsale/WhitelistedBasicCrowdsale.sol
884 
885 pragma solidity ^0.4.24;
886 
887 
888 
889 
890 contract WhitelistedBasicCrowdsale is BasicCrowdsale, MultipleWhitelistedCrowdsale {
891 
892 
893     constructor(uint256 _rate, address _wallet, address _token, uint256 _openingTime, uint256 _closingTime)
894     BasicCrowdsale(_rate, _wallet, ERC20(_token), _openingTime, _closingTime)
895     MultipleWhitelistedCrowdsale()
896     public {
897     }
898 }