1 contract ESportsConstants {
2     uint constant TOKEN_DECIMALS = 18;
3     uint8 constant TOKEN_DECIMALS_UINT8 = uint8(TOKEN_DECIMALS);
4     uint constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
5 
6     uint constant RATE = 240; // = 1 ETH
7 }
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
15         uint256 c = a * b;
16         assert(a == 0 || c / a == b);
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal constant returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) internal constant returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 }
38 
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization control
42  * functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45     address public owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51      * account.
52      */
53     function Ownable() {
54         owner = msg.sender;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     /**
66      * @dev Allows the current owner to transfer control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function transferOwnership(address newOwner) onlyOwner {
70         require(newOwner != address(0));
71         OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73     }
74 }
75 
76 contract ESportsFreezingStorage is Ownable {
77     // Timestamp when token release is enabled
78     uint64 public releaseTime;
79 
80     // ERC20 basic token contract being held
81     // ERC20Basic token;
82     ESportsToken token;
83     
84     function ESportsFreezingStorage(ESportsToken _token, uint64 _releaseTime) { //ERC20Basic
85         require(_releaseTime > now);
86         
87         releaseTime = _releaseTime;
88         token = _token;
89     }
90 
91     function release(address _beneficiary) onlyOwner returns(uint) {
92         //require(now >= releaseTime);
93         if (now < releaseTime) return 0;
94 
95         uint amount = token.balanceOf(this);
96         //require(amount > 0);
97         if (amount == 0)  return 0;
98 
99         // token.safeTransfer(beneficiary, amount);
100         //require(token.transfer(_beneficiary, amount));
101         bool result = token.transfer(_beneficiary, amount);
102         if (!result) return 0;
103         
104         return amount;
105     }
106 }
107 
108 /**
109  * @title RefundVault
110  * @dev This contract is used for storing funds while a crowdsale
111  * is in progress. Supports refunding the money if crowdsale fails,
112  * and forwarding it if crowdsale is successful.
113  */
114 contract RefundVault is Ownable {
115     using SafeMath for uint256;
116 
117     enum State {Active, Refunding, Closed}
118 
119     mapping (address => uint256) public deposited;
120 
121     address public wallet;
122 
123     State public state;
124 
125     event Closed();
126 
127     event RefundsEnabled();
128 
129     event Refunded(address indexed beneficiary, uint256 weiAmount);
130 
131     function RefundVault(address _wallet) {
132         require(_wallet != 0x0);
133         wallet = _wallet;
134         state = State.Active;
135     }
136 
137     function deposit(address investor) onlyOwner payable {
138         require(state == State.Active);
139         deposited[investor] = deposited[investor].add(msg.value);
140     }
141 
142     function close() onlyOwner {
143         require(state == State.Active);
144         state = State.Closed;
145         Closed();
146         wallet.transfer(this.balance);
147     }
148 
149     function enableRefunds() onlyOwner {
150         require(state == State.Active);
151         state = State.Refunding;
152         RefundsEnabled();
153     }
154 
155     function refund(address investor, uint weiRaised) onlyOwner {
156         require(state == State.Refunding);
157 
158         uint256 depositedValue = deposited[investor];
159         deposited[investor] = 0;
160         investor.transfer(depositedValue);
161         
162         Refunded(investor, depositedValue);
163     }
164 }
165 
166 /**
167  * @title Crowdsale 
168  * @dev Crowdsale is a base contract for managing a token crowdsale.
169  *
170  * Crowdsales have a start and end timestamps, where investors can make
171  * token purchases and the crowdsale will assign them tokens based
172  * on a token per ETH rate. Funds collected are forwarded to a wallet 
173  * as they arrive.
174  */
175 contract Crowdsale {
176     using SafeMath for uint;
177 
178     // The token being sold
179     MintableToken public token;
180 
181     // start and end timestamps where investments are allowed (both inclusive)
182     uint32 public startTime;
183     uint32 public endTime;
184 
185     // address where funds are collected
186     address public wallet;
187 
188     // how many token units a buyer gets per wei
189     uint public rate;
190 
191     // amount of raised money in wei
192     uint public weiRaised;
193 
194     /**
195      * @dev Amount of already sold tokens.
196      */
197     uint public soldTokens;
198 
199     /**
200      * @dev Maximum amount of tokens to mint.
201      */
202     uint public hardCap;
203 
204     /**
205      * event for token purchase logging
206      * @param purchaser who paid for the tokens
207      * @param beneficiary who got the tokens
208      * @param value weis paid for purchase
209      * @param amount amount of tokens purchased
210      */
211     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint value, uint amount);
212 
213     function Crowdsale(uint32 _startTime, uint32 _endTime, uint _rate, uint _hardCap, address _wallet, address _token) {
214         require(_startTime >= now);
215         require(_endTime >= _startTime);
216         require(_rate > 0);
217         require(_wallet != 0x0);
218         require(_hardCap > _rate);
219 
220         // token = createTokenContract();
221         token = MintableToken(_token);
222 
223         startTime = _startTime;
224         endTime = _endTime;
225         rate = _rate;
226         hardCap = _hardCap;
227         wallet = _wallet;
228     }
229 
230     // creates the token to be sold.
231     // override this method to have crowdsale of a specific mintable token.
232     // function createTokenContract() internal returns (MintableToken) {
233     //     return new MintableToken();
234     // }
235 
236     /**
237      * @dev this method might be overridden for implementing any sale logic.
238      * @return Actual rate.
239      */
240     function getRate() internal constant returns (uint) {
241         return rate;
242     }
243 
244     // Fallback function can be used to buy tokens
245     function() payable {
246         buyTokens(msg.sender, msg.value);
247     }
248 
249     // Low level token purchase function
250     function buyTokens(address beneficiary, uint amountWei) internal {
251         require(beneficiary != 0x0);
252 
253         // Total minted tokens
254         uint totalSupply = token.totalSupply();
255 
256         // Actual token minting rate (with considering bonuses and discounts)
257         uint actualRate = getRate();
258 
259         require(validPurchase(amountWei, actualRate, totalSupply));
260 
261         // Calculate token amount to be created
262         // uint tokens = rate.mul(msg.value).div(1 ether);
263         uint tokens = amountWei.mul(actualRate);
264 
265         if (msg.value == 0) { // if it is a btc purchase then check existence all tokens (no change)
266             require(tokens.add(totalSupply) <= hardCap);
267         }
268 
269         // Change, if minted token would be less
270         uint change = 0;
271 
272         // If hard cap reached
273         if (tokens.add(totalSupply) > hardCap) {
274             // Rest tokens
275             uint maxTokens = hardCap.sub(totalSupply);
276             uint realAmount = maxTokens.div(actualRate);
277 
278             // Rest tokens rounded by actualRate
279             tokens = realAmount.mul(actualRate);
280             change = amountWei.sub(realAmount);
281             amountWei = realAmount;
282         }
283 
284         // Bonuses
285         postBuyTokens(beneficiary, tokens);
286 
287         // Update state
288         weiRaised = weiRaised.add(amountWei);
289         soldTokens = soldTokens.add(tokens);
290 
291         token.mint(beneficiary, tokens);
292         TokenPurchase(msg.sender, beneficiary, amountWei, tokens);
293 
294         if (msg.value != 0) {
295             if (change != 0) {
296                 msg.sender.transfer(change);
297             }
298             forwardFunds(amountWei);
299         }
300     }
301 
302     // Send ether to the fund collection wallet
303     // Override to create custom fund forwarding mechanisms
304     function forwardFunds(uint amountWei) internal {
305         wallet.transfer(amountWei);
306     }
307 
308     // Trasfer bonuses and adding delayed bonuses
309     function postBuyTokens(address _beneficiary, uint _tokens) internal {
310     }
311 
312     /**
313      * @dev Check if the specified purchase is valid.
314      * @return true if the transaction can buy tokens
315      */
316     function validPurchase(uint _amountWei, uint _actualRate, uint _totalSupply) internal constant returns (bool) {
317         bool withinPeriod = now >= startTime && now <= endTime;
318         bool nonZeroPurchase = _amountWei != 0;
319         bool hardCapNotReached = _totalSupply <= hardCap.sub(_actualRate);
320 
321         return withinPeriod && nonZeroPurchase && hardCapNotReached;
322     }
323 
324     /**
325      * @dev Because of discount hasEnded might be true, but validPurchase returns false.
326      * @return true if crowdsale event has ended
327      */
328     function hasEnded() public constant returns (bool) {
329         return now > endTime || token.totalSupply() > hardCap.sub(getRate());
330     }
331 
332     /**
333      * @return true if crowdsale event has started
334      */
335     function hasStarted() public constant returns (bool) {
336         return now >= startTime;
337     }
338 }
339 
340 /**
341  * @title FinalizableCrowdsale
342  * @dev Extension of Crowsdale where an owner can do extra work
343  * after finishing. 
344  */
345 contract FinalizableCrowdsale is Crowdsale, Ownable {
346     using SafeMath for uint256;
347 
348     bool public isFinalized = false;
349 
350     event Finalized();
351 
352     function FinalizableCrowdsale(uint32 _startTime, uint32 _endTime, uint _rate, uint _hardCap, address _wallet, address _token)
353             Crowdsale(_startTime, _endTime, _rate, _hardCap, _wallet, _token) {
354     }
355 
356     /**
357      * @dev Must be called after crowdsale ends, to do some extra finalization
358      * work. Calls the contract's finalization function.
359      */
360     function finalize() onlyOwner {
361         require(!isFinalized);
362         require(hasEnded());
363 
364         isFinalized = true;
365 
366         finalization();
367         Finalized();        
368     }
369 
370     /**
371      * @dev Can be overriden to add finalization logic. The overriding function
372      * should call super.finalization() to ensure the chain of finalization is
373      * executed entirely.
374      */
375     function finalization() internal {
376     }
377 }
378 
379 /**
380  * @title RefundableCrowdsale
381  * @dev Extension of Crowdsale contract that adds a funding goal, and
382  * the possibility of users getting a refund if goal is not met.
383  * Uses a RefundVault as the crowdsale's vault.
384  */
385 contract RefundableCrowdsale is FinalizableCrowdsale {
386     using SafeMath for uint256;
387 
388     // minimum amount of funds to be raised in weis
389     uint public goal;
390 
391     // refund vault used to hold funds while crowdsale is running
392     RefundVault public vault;
393 
394     function RefundableCrowdsale(uint32 _startTime, uint32 _endTime, uint _rate, uint _hardCap, address _wallet, address _token, uint _goal)
395             FinalizableCrowdsale(_startTime, _endTime, _rate, _hardCap, _wallet, _token) {
396         require(_goal > 0);
397         vault = new RefundVault(wallet);
398         goal = _goal;
399     }
400 
401     // We're overriding the fund forwarding from Crowdsale.
402     // In addition to sending the funds, we want to call
403     // the RefundVault deposit function
404     function forwardFunds(uint amountWei) internal {
405         if (goalReached()) {
406             wallet.transfer(amountWei);
407         }
408         else {
409             vault.deposit.value(amountWei)(msg.sender);
410         }
411     }
412 
413     // if crowdsale is unsuccessful, investors can claim refunds here
414     function claimRefund() public {
415         require(isFinalized);
416         require(!goalReached());
417 
418         vault.refund(msg.sender, weiRaised);
419     }
420 
421     // vault finalization task, called when owner calls finalize()
422     function finalization() internal {
423         super.finalization();
424 
425         if (goalReached()) {
426             vault.close();
427         }
428         else {
429             vault.enableRefunds();
430         }
431     }
432 
433     function goalReached() public constant returns (bool) {
434         return weiRaised >= goal;
435     }
436 }
437 
438 contract ESportsMainCrowdsale is ESportsConstants, RefundableCrowdsale {
439     uint constant OVERALL_AMOUNT_TOKENS = 60000000 * TOKEN_DECIMAL_MULTIPLIER; // overall 100.00%
440     uint constant TEAM_BEN_TOKENS = 6000000 * TOKEN_DECIMAL_MULTIPLIER; // 20.00% // Founders
441     uint constant TEAM_PHIL_TOKENS = 6000000 * TOKEN_DECIMAL_MULTIPLIER;
442     uint constant COMPANY_COLD_STORAGE_TOKENS = 12000000 * TOKEN_DECIMAL_MULTIPLIER; // 20.00%
443     uint constant INVESTOR_TOKENS = 3000000 * TOKEN_DECIMAL_MULTIPLIER; // 5.00%
444     uint constant BONUS_TOKENS = 3000000 * TOKEN_DECIMAL_MULTIPLIER; // 5.00% // Pre-sale
445 	uint constant BUFFER_TOKENS = 6000000 * TOKEN_DECIMAL_MULTIPLIER; // 10.00%
446     uint constant PRE_SALE_TOKENS = 12000000 * TOKEN_DECIMAL_MULTIPLIER; // 20.00%
447 
448     // Mainnet addresses
449     address constant TEAM_BEN_ADDRESS = 0x2E352Ed15C4321f4dd7EdFc19402666dE8713cd8;
450     address constant TEAM_PHIL_ADDRESS = 0x4466de3a8f4f0a0f5470b50fdc9f91fa04e00e34;
451     address constant INVESTOR_ADDRESS = 0x14f8d0c41097ca6fddb6aa4fd6a3332af3741847;
452     address constant BONUS_ADDRESS = 0x5baee4a9938d8f59edbe4dc109119983db4b7bd6;
453     address constant COMPANY_COLD_STORAGE_ADDRESS = 0x700d6ae53be946085bb91f96eb1cf9e420236762;
454     address constant PRE_SALE_ADDRESS = 0xcb2809926e615245b3af4ebce5af9fbe1a6a4321;
455     
456     address btcBuyer = 0x1eee4c7d88aadec2ab82dd191491d1a9edf21e9a;
457 
458     ESportsBonusProvider public bonusProvider;
459 
460     bool private isInit = false;
461     
462 	/**
463      * Constructor function
464      */
465     function ESportsMainCrowdsale(
466         uint32 _startTime,
467         uint32 _endTime,
468         uint _softCapWei, // 4000000 EUR
469         address _wallet,
470         address _token
471 	) RefundableCrowdsale(
472         _startTime,
473         _endTime, 
474         RATE,
475         OVERALL_AMOUNT_TOKENS,
476         _wallet,
477         _token,
478         _softCapWei
479 	) {
480 	}
481 
482     /**
483      * @dev Release delayed bonus tokens
484      * @return Amount of got bonus tokens
485      */
486     function releaseBonus() returns(uint) {
487         return bonusProvider.releaseBonus(msg.sender, soldTokens);
488     }
489 
490     /**
491      * @dev Trasfer bonuses and adding delayed bonuses
492      * @param _beneficiary Future bonuses holder
493      * @param _tokens Amount of bonus tokens
494      */
495     function postBuyTokens(address _beneficiary, uint _tokens) internal {
496         uint bonuses = bonusProvider.getBonusAmount(_beneficiary, soldTokens, _tokens, startTime);
497         bonusProvider.addDelayedBonus(_beneficiary, soldTokens, _tokens);
498 
499         if (bonuses > 0) {
500             bonusProvider.sendBonus(_beneficiary, bonuses);
501         }
502     }
503 
504     /**
505      * @dev Initialization of crowdsale. Starts once after deployment token contract
506      * , deployment crowdsale contract and changу token contract's owner 
507      */
508     function init() onlyOwner public returns(bool) {
509         require(!isInit);
510 
511         ESportsToken ertToken = ESportsToken(token);
512         isInit = true;
513 
514         ESportsBonusProvider bProvider = new ESportsBonusProvider(ertToken, COMPANY_COLD_STORAGE_ADDRESS);
515         // bProvider.transferOwnership(owner);
516         bonusProvider = bProvider;
517 
518         mintToFounders(ertToken);
519 
520         require(token.mint(INVESTOR_ADDRESS, INVESTOR_TOKENS));
521         require(token.mint(COMPANY_COLD_STORAGE_ADDRESS, COMPANY_COLD_STORAGE_TOKENS));
522         require(token.mint(PRE_SALE_ADDRESS, PRE_SALE_TOKENS));
523 
524         // bonuses
525         require(token.mint(BONUS_ADDRESS, BONUS_TOKENS));
526         require(token.mint(bonusProvider, BUFFER_TOKENS)); // mint bonus token to bonus provider
527         
528         ertToken.addExcluded(INVESTOR_ADDRESS);
529         ertToken.addExcluded(BONUS_ADDRESS);
530         ertToken.addExcluded(COMPANY_COLD_STORAGE_ADDRESS);
531         ertToken.addExcluded(PRE_SALE_ADDRESS);
532 
533         ertToken.addExcluded(address(bonusProvider));
534 
535         return true;
536     }
537 
538     /**
539      * @dev Mint of tokens in the name of the founders and freeze part of them
540      */
541     function mintToFounders(ESportsToken ertToken) internal {
542         ertToken.mintTimelocked(TEAM_BEN_ADDRESS, TEAM_BEN_TOKENS.mul(20).div(100), startTime + 1 years);
543         ertToken.mintTimelocked(TEAM_BEN_ADDRESS, TEAM_BEN_TOKENS.mul(30).div(100), startTime + 3 years);
544         ertToken.mintTimelocked(TEAM_BEN_ADDRESS, TEAM_BEN_TOKENS.mul(30).div(100), startTime + 5 years);
545         require(token.mint(TEAM_BEN_ADDRESS, TEAM_BEN_TOKENS.mul(20).div(100)));
546 
547         ertToken.mintTimelocked(TEAM_PHIL_ADDRESS, TEAM_PHIL_TOKENS.mul(20).div(100), startTime + 1 years);
548         ertToken.mintTimelocked(TEAM_PHIL_ADDRESS, TEAM_PHIL_TOKENS.mul(30).div(100), startTime + 3 years);
549         ertToken.mintTimelocked(TEAM_PHIL_ADDRESS, TEAM_PHIL_TOKENS.mul(30).div(100), startTime + 5 years);
550         require(token.mint(TEAM_PHIL_ADDRESS, TEAM_PHIL_TOKENS.mul(20).div(100)));
551     }
552 
553     /**
554      * @dev Purchase for bitcoin. Can start only btc buyer
555      */
556     function buyForBitcoin(address _beneficiary, uint _amountWei) public returns(bool) {
557         require(msg.sender == btcBuyer);
558 
559         buyTokens(_beneficiary, _amountWei);
560         
561         return true;
562     }
563 
564     /**
565      * @dev Set new address who can buy tokens for bitcoin
566      */
567     function setBtcBuyer(address _newBtcBuyerAddress) onlyOwner returns(bool) {
568         require(_newBtcBuyerAddress != 0x0);
569 
570         btcBuyer = _newBtcBuyerAddress;
571 
572         return true;
573     }
574 
575     /**
576      * @dev Finish the crowdsale
577      */
578     function finalization() internal {
579         super.finalization();
580         token.finishMinting();
581 
582         bonusProvider.releaseThisBonuses();
583 
584         if (goalReached()) {
585             ESportsToken(token).allowMoveTokens();
586         }
587         token.transferOwnership(owner); // change token owner
588     }
589 }
590 
591 contract ESportsBonusProvider is ESportsConstants, Ownable {
592     // 1) 10% on your investment during first week
593     // 2) 10% to all investors during ICO ( not presale) if we reach 5 000 000 euro investments
594 
595     using SafeMath for uint;
596 
597     ESportsToken public token;
598     address public returnAddressBonuses;
599     mapping (address => uint256) investorBonuses;
600 
601     uint constant FIRST_WEEK = 7 days;
602     uint constant BONUS_THRESHOLD_ETR = 20000 * RATE * TOKEN_DECIMAL_MULTIPLIER; // 5 000 000 EUR -> 20 000 ETH -> ETR
603 
604     function ESportsBonusProvider(ESportsToken _token, address _returnAddressBonuses) {
605         token = _token;
606         returnAddressBonuses = _returnAddressBonuses;
607     }
608 
609     function getBonusAmount(
610         address _buyer,
611         uint _totalSold,
612         uint _amountTokens,
613         uint32 _startTime
614     ) onlyOwner public constant returns (uint) {
615         uint bonus = 0;
616         
617         // Apply bonus for amount
618         if (now < _startTime + FIRST_WEEK && now >= _startTime) {
619             bonus = bonus.add(_amountTokens.div(10)); // 1
620         }
621 
622         return bonus;
623     }
624 
625     function addDelayedBonus(
626         address _buyer,
627         uint _totalSold,
628         uint _amountTokens
629     ) onlyOwner public returns (uint) {
630         uint bonus = 0;
631 
632         if (_totalSold < BONUS_THRESHOLD_ETR) {
633             uint amountThresholdBonus = _amountTokens.div(10); // 2
634             investorBonuses[_buyer] = investorBonuses[_buyer].add(amountThresholdBonus); 
635             bonus = bonus.add(amountThresholdBonus);
636         }
637 
638         return bonus;
639     }
640 
641     function releaseBonus(address _buyer, uint _totalSold) onlyOwner public returns (uint) {
642         require(_totalSold >= BONUS_THRESHOLD_ETR);
643         require(investorBonuses[_buyer] > 0);
644 
645         uint amountBonusTokens = investorBonuses[_buyer];
646         investorBonuses[_buyer] = 0;
647         require(token.transfer(_buyer, amountBonusTokens));
648 
649         return amountBonusTokens;
650     }
651 
652     function getDelayedBonusAmount(address _buyer) public constant returns(uint) {
653         return investorBonuses[_buyer];
654     }
655 
656     function sendBonus(address _buyer, uint _amountBonusTokens) onlyOwner public {
657         require(token.transfer(_buyer, _amountBonusTokens));
658     }
659 
660     function releaseThisBonuses() onlyOwner public {
661         uint remainBonusTokens = token.balanceOf(this); // send all remaining bonuses
662         require(token.transfer(returnAddressBonuses, remainBonusTokens));
663     }
664 }
665 
666 /**
667  * @title ERC20Basic
668  * @dev Simpler version of ERC20 interface
669  * @dev see https://github.com/ethereum/EIPs/issues/179
670  */
671 contract ERC20Basic {
672     uint256 public totalSupply;
673     function balanceOf(address who) constant returns (uint256);
674     function transfer(address to, uint256 value) returns (bool);
675     event Transfer(address indexed from, address indexed to, uint256 value);
676 }
677 
678 /**
679  * @title ERC20 interface
680  * @dev see https://github.com/ethereum/EIPs/issues/20
681  */
682 contract ERC20 is ERC20Basic {
683   	function allowance(address owner, address spender) constant returns (uint256);
684   	function transferFrom(address from, address to, uint256 value) returns (bool);
685   	function approve(address spender, uint256 value) returns (bool);
686   	event Approval(address indexed owner, address indexed spender, uint256 value);
687 }
688 
689 /**
690  * @title Basic token
691  * @dev Basic version of StandardToken, with no allowances. 
692  */
693 contract BasicToken is ERC20Basic {
694     using SafeMath for uint256;
695 
696     mapping (address => uint256) balances;
697 
698     /**
699     * @dev transfer token for a specified address
700     * @param _to The address to transfer to.
701     * @param _value The amount to be transferred.
702     */
703     function transfer(address _to, uint256 _value) returns (bool) {
704         require(_to != address(0));
705 
706         // SafeMath.sub will throw if there is not enough balance.
707         balances[msg.sender] = balances[msg.sender].sub(_value);
708         balances[_to] = balances[_to].add(_value);
709         Transfer(msg.sender, _to, _value);
710         return true;
711     }
712 
713     /**
714     * @dev Gets the balance of the specified address.
715     * @param _owner The address to query the the balance of.
716     * @return An uint256 representing the amount owned by the passed address.
717     */
718     function balanceOf(address _owner) constant returns (uint256 balance) {
719         return balances[_owner];
720     }
721 }
722 
723 /**
724  * @title Standard ERC20 token
725  *
726  * @dev Implementation of the basic standard token.
727  * @dev https://github.com/ethereum/EIPs/issues/20
728  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
729  */
730 contract StandardToken is ERC20, BasicToken {
731 
732     mapping (address => mapping (address => uint256)) allowed;
733 
734     /**
735      * @dev Transfer tokens from one address to another
736      * @param _from address The address which you want to send tokens from
737      * @param _to address The address which you want to transfer to
738      * @param _value uint256 the amount of tokens to be transferred
739      */
740     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
741         require(_to != address(0));
742 
743         var _allowance = allowed[_from][msg.sender];
744 
745         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
746         // require (_value <= _allowance);
747 
748         balances[_from] = balances[_from].sub(_value);
749         balances[_to] = balances[_to].add(_value);
750         allowed[_from][msg.sender] = _allowance.sub(_value);
751         Transfer(_from, _to, _value);
752         return true;
753     }
754 
755     /**
756      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
757      * @param _spender The address which will spend the funds.
758      * @param _value The amount of tokens to be spent.
759      */
760     function approve(address _spender, uint256 _value) returns (bool) {
761 
762         // To change the approve amount you first have to reduce the addresses`
763         //  allowance to zero by calling `approve(_spender, 0)` if it is not
764         //  already 0 to mitigate the race condition described here:
765         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
766         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
767 
768         allowed[msg.sender][_spender] = _value;
769         Approval(msg.sender, _spender, _value);
770         return true;
771     }
772 
773     /**
774      * @dev Function to check the amount of tokens that an owner allowed to a spender.
775      * @param _owner address The address which owns the funds.
776      * @param _spender address The address which will spend the funds.
777      * @return A uint256 specifying the amount of tokens still available for the spender.
778      */
779     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
780         return allowed[_owner][_spender];
781     }
782 
783     /**
784      * approve should be called when allowed[_spender] == 0. To increment
785      * allowed value is better to use this function to avoid 2 calls (and wait until
786      * the first transaction is mined)
787      * From MonolithDAO Token.sol
788      */
789     function increaseApproval(address _spender, uint _addedValue) returns (bool success) {
790         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
791         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
792         return true;
793     }
794 
795     function decreaseApproval(address _spender, uint _subtractedValue) returns (bool success) {
796         uint oldValue = allowed[msg.sender][_spender];
797         if (_subtractedValue > oldValue) {
798             allowed[msg.sender][_spender] = 0;
799         }
800         else {
801             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
802         }
803         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
804         return true;
805     }
806 }
807 
808 /**
809  * @title Mintable token
810  * @dev Simple ERC20 Token example, with mintable token creation
811  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
812  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
813  */
814 contract MintableToken is StandardToken, Ownable {
815     event Mint(address indexed to, uint256 amount);
816 
817     event MintFinished();
818 
819     bool public mintingFinished = false;
820 
821     modifier canMint() {
822         require(!mintingFinished);
823         _;
824     }
825 
826     /**
827      * @dev Function to mint tokens
828      * @param _to The address that will receive the minted tokens.
829      * @param _amount The amount of tokens to mint.
830      * @return A boolean that indicates if the operation was successful.
831      */
832     function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
833         totalSupply = totalSupply.add(_amount);
834         balances[_to] = balances[_to].add(_amount);
835         Mint(_to, _amount);
836         Transfer(0x0, _to, _amount);
837         return true;
838     }
839 
840     /**
841      * @dev Function to stop minting new tokens.
842      * @return True if the operation was successful.
843      */
844     function finishMinting() onlyOwner returns (bool) {
845         mintingFinished = true;
846         MintFinished();
847         return true;
848     }
849 }
850 
851 contract ESportsToken is ESportsConstants, MintableToken {
852     using SafeMath for uint;
853 
854     event Burn(address indexed burner, uint value);
855     event MintTimelocked(address indexed beneficiary, uint amount);
856 
857     /**
858      * @dev Pause token transfer. After successfully finished crowdsale it becomes false
859      */
860     bool public paused = true;
861     /**
862      * @dev Accounts who can transfer token even if paused. Works only during crowdsale
863      */
864     mapping(address => bool) excluded;
865 
866     mapping (address => ESportsFreezingStorage[]) public frozenFunds;
867 
868     function name() constant public returns (string _name) {
869         return "ESports Token";
870     }
871 
872     function symbol() constant public returns (string _symbol) {
873         return "ERT";
874     }
875 
876     function decimals() constant public returns (uint8 _decimals) {
877         return TOKEN_DECIMALS_UINT8;
878     }
879     
880     function allowMoveTokens() onlyOwner {
881         paused = false;
882     }
883 
884     function addExcluded(address _toExclude) onlyOwner {
885         addExcludedInternal(_toExclude);
886     }
887     
888     function addExcludedInternal(address _toExclude) private {
889         excluded[_toExclude] = true;
890     }
891 
892     /**
893      * @dev Wrapper of token.transferFrom
894      */
895     function transferFrom(address _from, address _to, uint _value) returns (bool) {
896         require(!paused || excluded[_from]);
897 
898         return super.transferFrom(_from, _to, _value);
899     }
900 
901     /**
902      * @dev Wrapper of token.transfer 
903      */
904     function transfer(address _to, uint _value) returns (bool) {
905         require(!paused || excluded[msg.sender]);
906 
907         return super.transfer(_to, _value);
908     }
909 
910     /**
911      * @dev Mint timelocked tokens
912      */
913     function mintTimelocked(address _to, uint _amount, uint32 _releaseTime)
914             onlyOwner canMint returns (ESportsFreezingStorage) {
915         ESportsFreezingStorage timelock = new ESportsFreezingStorage(this, _releaseTime);
916         mint(timelock, _amount);
917 
918         frozenFunds[_to].push(timelock);
919         addExcludedInternal(timelock);
920 
921         MintTimelocked(_to, _amount);
922 
923         return timelock;
924     }
925 
926     /**
927      * @dev Release frozen tokens
928      * @return Total amount of released tokens
929      */
930     function returnFrozenFreeFunds() public returns (uint) {
931         uint total = 0;
932         ESportsFreezingStorage[] storage frozenStorages = frozenFunds[msg.sender];
933         // for (uint x = 0; x < frozenStorages.length; x++) {
934         //     uint amount = balanceOf(frozenStorages[x]);
935         //     if (frozenStorages[x].call(bytes4(sha3("release(address)")), msg.sender))
936         //         total = total.add(amount);
937         // }
938         for (uint x = 0; x < frozenStorages.length; x++) {
939             uint amount = frozenStorages[x].release(msg.sender);
940             total = total.add(amount);
941         }
942         
943         return total;
944     }
945 
946     /**
947      * @dev Burns a specific amount of tokens.
948      * @param _value The amount of token to be burned.
949      */
950     function burn(uint _value) public {
951         require(!paused || excluded[msg.sender]);
952         require(_value > 0);
953 
954         balances[msg.sender] = balances[msg.sender].sub(_value);
955         totalSupply = totalSupply.sub(_value);
956         
957         Burn(msg.sender, _value);
958     }
959 }