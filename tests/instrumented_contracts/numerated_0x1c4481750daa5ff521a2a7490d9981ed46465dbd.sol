1 pragma solidity 0.4.15;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 /**
77  * @title Pausable
78  * @dev Base contract which allows children to implement an emergency stop mechanism.
79  */
80 contract Pausable is Ownable {
81   event Pause();
82   event Unpause();
83 
84   bool public paused = false;
85 
86 
87   /**
88    * @dev Modifier to make a function callable only when the contract is not paused.
89    */
90   modifier whenNotPaused() {
91     require(!paused);
92     _;
93   }
94 
95   /**
96    * @dev Modifier to make a function callable only when the contract is paused.
97    */
98   modifier whenPaused() {
99     require(paused);
100     _;
101   }
102 
103   /**
104    * @dev called by the owner to pause, triggers stopped state
105    */
106   function pause() onlyOwner whenNotPaused public {
107     paused = true;
108     Pause();
109   }
110 
111   /**
112    * @dev called by the owner to unpause, returns to normal state
113    */
114   function unpause() onlyOwner whenPaused public {
115     paused = false;
116     Unpause();
117   }
118 }
119 
120 /**
121  * @title ERC20Basic
122  * @dev Simpler version of ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/179
124  */
125 contract ERC20Basic {
126   uint256 public totalSupply;
127   function balanceOf(address who) public constant returns (uint256);
128   function transfer(address to, uint256 value) public returns (bool);
129   event Transfer(address indexed from, address indexed to, uint256 value);
130 }
131 
132 /**
133  * @title ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20 is ERC20Basic {
137   function allowance(address owner, address spender) public constant returns (uint256);
138   function transferFrom(address from, address to, uint256 value) public returns (bool);
139   function approve(address spender, uint256 value) public returns (bool);
140   event Approval(address indexed owner, address indexed spender, uint256 value);
141 }
142 
143 /**
144  * @title Basic token
145  * @dev Basic version of StandardToken, with no allowances.
146  */
147 contract BasicToken is ERC20Basic {
148   using SafeMath for uint256;
149 
150   mapping(address => uint256) balances;
151 
152   /**
153   * @dev transfer token for a specified address
154   * @param _to The address to transfer to.
155   * @param _value The amount to be transferred.
156   */
157   function transfer(address _to, uint256 _value) public returns (bool) {
158     require(_to != address(0));
159 
160     // SafeMath.sub will throw if there is not enough balance.
161     balances[msg.sender] = balances[msg.sender].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     Transfer(msg.sender, _to, _value);
164     return true;
165   }
166 
167   /**
168   * @dev Gets the balance of the specified address.
169   * @param _owner The address to query the the balance of.
170   * @return An uint256 representing the amount owned by the passed address.
171   */
172   function balanceOf(address _owner) public constant returns (uint256 balance) {
173     return balances[_owner];
174   }
175 
176 }
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * @dev https://github.com/ethereum/EIPs/issues/20
183  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  */
185 contract StandardToken is ERC20, BasicToken {
186 
187   mapping (address => mapping (address => uint256)) allowed;
188 
189 
190   /**
191    * @dev Transfer tokens from one address to another
192    * @param _from address The address which you want to send tokens from
193    * @param _to address The address which you want to transfer to
194    * @param _value uint256 the amount of tokens to be transferred
195    */
196   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
197     require(_to != address(0));
198 
199     uint256 _allowance = allowed[_from][msg.sender];
200 
201     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
202     // require (_value <= _allowance);
203 
204     balances[_from] = balances[_from].sub(_value);
205     balances[_to] = balances[_to].add(_value);
206     allowed[_from][msg.sender] = _allowance.sub(_value);
207     Transfer(_from, _to, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
213    *
214    * Beware that changing an allowance with this method brings the risk that someone may use both the old
215    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218    * @param _spender The address which will spend the funds.
219    * @param _value The amount of tokens to be spent.
220    */
221   function approve(address _spender, uint256 _value) public returns (bool) {
222     allowed[msg.sender][_spender] = _value;
223     Approval(msg.sender, _spender, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Function to check the amount of tokens that an owner allowed to a spender.
229    * @param _owner address The address which owns the funds.
230    * @param _spender address The address which will spend the funds.
231    * @return A uint256 specifying the amount of tokens still available for the spender.
232    */
233   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
234     return allowed[_owner][_spender];
235   }
236 
237   /**
238    * approve should be called when allowed[_spender] == 0. To increment
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    */
243   function increaseApproval (address _spender, uint _addedValue)
244     returns (bool success) {
245     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
246     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250   function decreaseApproval (address _spender, uint _subtractedValue)
251     returns (bool success) {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 /**
265  * @title Mintable token
266  * @dev Simple ERC20 Token example, with mintable token creation
267  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
268  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
269  */
270 
271 contract MintableToken is StandardToken, Ownable {
272   event Mint(address indexed to, uint256 amount);
273   event MintFinished();
274 
275   bool public mintingFinished = false;
276 
277 
278   modifier canMint() {
279     require(!mintingFinished);
280     _;
281   }
282 
283   /**
284    * @dev Function to mint tokens
285    * @param _to The address that will receive the minted tokens.
286    * @param _amount The amount of tokens to mint.
287    * @return A boolean that indicates if the operation was successful.
288    */
289   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
290     totalSupply = totalSupply.add(_amount);
291     balances[_to] = balances[_to].add(_amount);
292     Mint(_to, _amount);
293     Transfer(0x0, _to, _amount);
294     return true;
295   }
296 
297   /**
298    * @dev Function to stop minting new tokens.
299    * @return True if the operation was successful.
300    */
301   function finishMinting() onlyOwner public returns (bool) {
302     mintingFinished = true;
303     MintFinished();
304     return true;
305   }
306 }
307 
308 /**
309  * @title LimitedTransferToken
310  * @dev LimitedTransferToken defines the generic interface and the implementation to limit token
311  * transferability for different events. It is intended to be used as a base class for other token
312  * contracts.
313  * LimitedTransferToken has been designed to allow for different limiting factors,
314  * this can be achieved by recursively calling super.transferableTokens() until the base class is
315  * hit. For example:
316  *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
317  *       return min256(unlockedTokens, super.transferableTokens(holder, time));
318  *     }
319  * A working example is VestedToken.sol:
320  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
321  */
322 
323 contract LimitedTransferToken is ERC20 {
324 
325   /**
326    * @dev Checks whether it can transfer or otherwise throws.
327    */
328   modifier canTransfer(address _sender, uint256 _value) {
329    require(_value <= transferableTokens(_sender, uint64(now)));
330    _;
331   }
332 
333   /**
334    * @dev Checks modifier and allows transfer if tokens are not locked.
335    * @param _to The address that will receive the tokens.
336    * @param _value The amount of tokens to be transferred.
337    */
338   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns (bool) {
339     return super.transfer(_to, _value);
340   }
341 
342   /**
343   * @dev Checks modifier and allows transfer if tokens are not locked.
344   * @param _from The address that will send the tokens.
345   * @param _to The address that will receive the tokens.
346   * @param _value The amount of tokens to be transferred.
347   */
348   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns (bool) {
349     return super.transferFrom(_from, _to, _value);
350   }
351 
352   /**
353    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
354    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
355    * specific logic for limiting token transferability for a holder over time.
356    */
357   function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
358     return balanceOf(holder);
359   }
360 }
361 
362 
363 /**
364  * @title Crowdsale
365  * @dev Crowdsale is a base contract for managing a token crowdsale.
366  * Crowdsales have a start and end timestamps, where investors can make
367  * token purchases and the crowdsale will assign them tokens based
368  * on a token per ETH rate. Funds collected are forwarded to a wallet
369  * as they arrive.
370  */
371 contract Crowdsale {
372   using SafeMath for uint256;
373 
374   // The token being sold
375   MintableToken public token;
376 
377   // start and end timestamps where investments are allowed (both inclusive)
378   uint256 public startTime;
379   uint256 public endTime;
380 
381   // address where funds are collected
382   address public wallet;
383 
384   // how many token units a buyer gets per wei
385   uint256 public rate;
386 
387   // amount of raised money in wei
388   uint256 public weiRaised;
389 
390   /**
391    * event for token purchase logging
392    * @param purchaser who paid for the tokens
393    * @param beneficiary who got the tokens
394    * @param value weis paid for purchase
395    * @param amount amount of tokens purchased
396    */
397   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
398 
399 
400   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
401     require(_startTime >= now);
402     require(_endTime >= _startTime);
403     require(_rate > 0);
404     require(_wallet != 0x0);
405 
406     token = createTokenContract();
407     startTime = _startTime;
408     endTime = _endTime;
409     rate = _rate;
410     wallet = _wallet;
411   }
412 
413   // creates the token to be sold.
414   // override this method to have crowdsale of a specific mintable token.
415   function createTokenContract() internal returns (MintableToken) {
416     return new MintableToken();
417   }
418 
419 
420   // fallback function can be used to buy tokens
421   function () payable {
422     buyTokens(msg.sender);
423   }
424 
425   // low level token purchase function
426   function buyTokens(address beneficiary) public payable {
427     require(beneficiary != 0x0);
428     require(validPurchase());
429 
430     uint256 weiAmount = msg.value;
431 
432     // calculate token amount to be created
433     uint256 tokens = weiAmount.mul(rate);
434 
435     // update state
436     weiRaised = weiRaised.add(weiAmount);
437 
438     token.mint(beneficiary, tokens);
439     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
440 
441     forwardFunds();
442   }
443 
444   // send ether to the fund collection wallet
445   // override to create custom fund forwarding mechanisms
446   function forwardFunds() internal {
447     wallet.transfer(msg.value);
448   }
449 
450   // @return true if the transaction can buy tokens
451   function validPurchase() internal constant returns (bool) {
452     bool withinPeriod = now >= startTime && now <= endTime;
453     bool nonZeroPurchase = msg.value != 0;
454     return withinPeriod && nonZeroPurchase;
455   }
456 
457   // @return true if crowdsale event has ended
458   function hasEnded() public constant returns (bool) {
459     return now > endTime;
460   }
461 
462 
463 }
464 
465 /**
466  * @title CappedCrowdsale
467  * @dev Extension of Crowdsale with a max amount of funds raised
468  */
469 contract CappedCrowdsale is Crowdsale {
470   using SafeMath for uint256;
471 
472   uint256 public cap;
473 
474   function CappedCrowdsale(uint256 _cap) {
475     require(_cap > 0);
476     cap = _cap;
477   }
478 
479   // overriding Crowdsale#validPurchase to add extra cap logic
480   // @return true if investors can buy at the moment
481   function validPurchase() internal constant returns (bool) {
482     bool withinCap = weiRaised.add(msg.value) <= cap;
483     return super.validPurchase() && withinCap;
484   }
485 
486   // overriding Crowdsale#hasEnded to add cap logic
487   // @return true if crowdsale event has ended
488   function hasEnded() public constant returns (bool) {
489     bool capReached = weiRaised >= cap;
490     return super.hasEnded() || capReached;
491   }
492 
493 }
494 
495 /**
496  * @title FinalizableCrowdsale
497  * @dev Extension of Crowdsale where an owner can do extra work
498  * after finishing.
499  */
500 contract FinalizableCrowdsale is Crowdsale, Ownable {
501   using SafeMath for uint256;
502 
503   bool public isFinalized = false;
504 
505   event Finalized();
506 
507   /**
508    * @dev Must be called after crowdsale ends, to do some extra finalization
509    * work. Calls the contract's finalization function.
510    */
511   function finalize() onlyOwner public {
512     require(!isFinalized);
513     require(hasEnded());
514 
515     finalization();
516     Finalized();
517 
518     isFinalized = true;
519   }
520 
521   /**
522    * @dev Can be overridden to add finalization logic. The overriding function
523    * should call super.finalization() to ensure the chain of finalization is
524    * executed entirely.
525    */
526   function finalization() internal {
527   }
528 }
529 
530 
531 
532 contract Tiers {
533   using SafeMath for uint256;
534 
535   uint256 public cpCap = 45000 ether;
536   uint256 public presaleWeiSold = 18000 ether;
537 
538   uint256[6] public tierAmountCaps =  [ presaleWeiSold
539                                       , presaleWeiSold + 5000 ether
540                                       , presaleWeiSold + 10000 ether
541                                       , presaleWeiSold + 15000 ether
542                                       , presaleWeiSold + 21000 ether
543                                       , cpCap
544                                       ];
545   uint256[6] public tierRates = [ 2000 // tierRates[0] should never be used, but it is accurate
546                                 , 1500 // Tokens are purchased at a rate of 105-150
547                                 , 1350 // per deciEth, depending on purchase tier.
548                                 , 1250 // tierRates[i] is the purchase rate of tier_i
549                                 , 1150
550                                 , 1050
551                                 ];
552 
553     function tierIndexByWeiAmount(uint256 weiLevel) public constant returns (uint256) {
554         require(weiLevel <= cpCap);
555         for (uint256 i = 0; i < tierAmountCaps.length; i++) {
556             if (weiLevel <= tierAmountCaps[i]) {
557                 return i;
558             }
559         }
560     }
561 
562     /**
563      * @dev Calculates how many tokens a given amount of wei can buy at
564      * a particular level of weiRaised. Takes into account tiers of purchase
565      * bonus
566      */
567     function calculateTokens(uint256 _amountWei, uint256 _weiRaised) public constant returns (uint256) {
568         uint256 currentTier = tierIndexByWeiAmount(_weiRaised);
569         uint256 startWeiLevel = _weiRaised;
570         uint256 endWeiLevel = _amountWei.add(_weiRaised);
571         uint256 tokens = 0;
572         for (uint256 i = currentTier; i < tierAmountCaps.length; i++) {
573             if (endWeiLevel <= tierAmountCaps[i]) {
574                 tokens = tokens.add((endWeiLevel.sub(startWeiLevel)).mul(tierRates[i]));
575                 break;
576             } else {
577                 tokens = tokens.add((tierAmountCaps[i].sub(startWeiLevel)).mul(tierRates[i]));
578                 startWeiLevel = tierAmountCaps[i];
579             }
580         }
581         return tokens;
582     }
583 
584 }
585 
586 contract CPToken is MintableToken, LimitedTransferToken {
587     string public name = "BLOCKMASON CREDIT PROTOCOL TOKEN";
588     string public symbol = "BCPT";
589     uint256 public decimals = 18;
590 
591     bool public saleOver = false;
592 
593     function CPToken() {
594     }
595 
596     function endSale() public onlyOwner {
597         require (!saleOver);
598         saleOver = true;
599     }
600 
601     /**
602      * @dev returns all user's tokens if time >= releaseTime
603      */
604     function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
605         if (saleOver)
606             return balanceOf(holder);
607         else
608             return 0;
609     }
610 
611 }
612 
613 
614 
615 contract DPIcoWhitelist {
616     address public admin;
617     bool public isOn;
618     mapping (address => bool) public whitelist;
619     address[] public users;
620 
621     modifier signUpOpen() {
622         if (!isOn) revert();
623         _;
624     }
625 
626     modifier isAdmin() {
627         if (msg.sender != admin) revert();
628         _;
629     }
630 
631     modifier newAddr() {
632         if (whitelist[msg.sender]) revert();
633         _;
634     }
635 
636     function DPIcoWhitelist() {
637         admin = msg.sender;
638         isOn = false;
639     }
640 
641     function () {
642         signUp();
643     }
644 
645     // Public functions
646 
647     function setSignUpOnOff(bool state) public isAdmin {
648         isOn = state;
649     }
650 
651     function signUp() public signUpOpen newAddr {
652         whitelist[msg.sender] = true;
653         users.push(msg.sender);
654     }
655 
656     function getAdmin() public constant returns (address) {
657         return admin;
658     }
659 
660     function signUpOn() public constant returns (bool) {
661         return isOn;
662     }
663 
664     function isSignedUp(address addr) public constant returns (bool) {
665         return whitelist[addr];
666     }
667 
668     function getUsers() public constant returns (address[]) {
669         return users;
670     }
671 
672     function numUsers() public constant returns (uint) {
673         return users.length;
674     }
675 
676     function userAtIndex(uint idx) public constant returns (address) {
677         return users[idx];
678     }
679 }
680 
681 contract CPCrowdsale is CappedCrowdsale, FinalizableCrowdsale, Pausable {
682     using SafeMath for uint256;
683 
684     DPIcoWhitelist private aw;
685     Tiers private at;
686     mapping (address => bool) private hasPurchased; // has whitelist address purchased already
687     uint256 public whitelistEndTime;
688     uint256 public maxWhitelistPurchaseWei;
689     uint256 public openWhitelistEndTime;
690 
691     function CPCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _whitelistEndTime, uint256 _openWhitelistEndTime, address _wallet, address _tiersContract, address _whitelistContract, address _airdropWallet, address _advisorWallet, address _stakingWallet, address _privateSaleWallet)
692         CappedCrowdsale(45000 ether) // crowdsale capped at 45000 ether
693         FinalizableCrowdsale()
694         Crowdsale(_startTime, _endTime, 1, _wallet)  // rate = 1 is a dummy value; we use tiers instead
695     {
696         token.mint(_wallet, 23226934 * (10 ** 18));
697         token.mint(_airdropWallet, 5807933 * (10 ** 18));
698         token.mint(_advisorWallet, 5807933 * (10 ** 18));
699         token.mint(_stakingWallet, 11615867 * (10 ** 18));
700         token.mint(_privateSaleWallet, 36000000 * (10 ** 18));
701 
702         aw = DPIcoWhitelist(_whitelistContract);
703         require (aw.numUsers() > 0);
704         at = Tiers(_tiersContract);
705         whitelistEndTime = _whitelistEndTime;
706         openWhitelistEndTime = _openWhitelistEndTime;
707         weiRaised = 18000 ether; // 18K ether was sold during presale
708         maxWhitelistPurchaseWei = (cap.sub(weiRaised)).div(aw.numUsers());
709     }
710 
711     // Public functions
712     function buyTokens(address beneficiary) public payable whenNotPaused {
713         uint256 weiAmount = msg.value;
714 
715         require(beneficiary != 0x0);
716         require(validPurchase());
717         require(!isWhitelistPeriod()
718              || whitelistValidPurchase(msg.sender, beneficiary, weiAmount));
719         require(!isOpenWhitelistPeriod()
720              || openWhitelistValidPurchase(msg.sender, beneficiary));
721 
722         hasPurchased[beneficiary] = true;
723 
724         uint256 tokens = at.calculateTokens(weiAmount, weiRaised);
725         weiRaised = weiRaised.add(weiAmount);
726         token.mint(beneficiary, tokens);
727         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
728         forwardFunds();
729     }
730 
731     // Internal functions
732 
733     function createTokenContract() internal returns (MintableToken) {
734         return new CPToken();
735     }
736 
737     /**
738      * @dev Overriden to add finalization logic.
739      * Mints remaining tokens to dev wallet
740      */
741     function finalization() internal {
742         uint256 remainingWei = cap.sub(weiRaised);
743         if (remainingWei > 0) {
744             uint256 remainingDevTokens = at.calculateTokens(remainingWei, weiRaised);
745             token.mint(wallet, remainingDevTokens);
746         }
747         CPToken(token).endSale();
748         token.finishMinting();
749         super.finalization();
750     }
751 
752     // Private functions
753 
754     // can't override `validPurchase` because need to pass additional values
755     function whitelistValidPurchase(address buyer, address beneficiary, uint256 amountWei) private constant returns (bool) {
756         bool beneficiaryPurchasedPreviously = hasPurchased[beneficiary];
757         bool belowMaxWhitelistPurchase = amountWei <= maxWhitelistPurchaseWei;
758         return (openWhitelistValidPurchase(buyer, beneficiary)
759                 && !beneficiaryPurchasedPreviously
760                 && belowMaxWhitelistPurchase);
761     }
762 
763     // @return true if `now` is within the bounds of the whitelist period
764     function isWhitelistPeriod() private constant returns (bool) {
765         return (now <= whitelistEndTime && now >= startTime);
766     }
767 
768     // can't override `validPurchase` because need to pass additional values
769     function openWhitelistValidPurchase(address buyer, address beneficiary) private constant returns (bool) {
770         bool buyerIsBeneficiary = buyer == beneficiary;
771         bool signedup = aw.isSignedUp(beneficiary);
772         return (buyerIsBeneficiary && signedup);
773     }
774 
775     // @return true if `now` is within the bounds of the open whitelist period
776     function isOpenWhitelistPeriod() private constant returns (bool) {
777         bool cappedWhitelistOver = now > whitelistEndTime;
778         bool openWhitelistPeriod = now <= openWhitelistEndTime;
779         return cappedWhitelistOver && openWhitelistPeriod;
780     }
781 
782 }