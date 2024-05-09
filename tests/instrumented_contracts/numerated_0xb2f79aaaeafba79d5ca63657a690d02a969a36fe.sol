1 pragma solidity ^0.4.16;
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
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 /**
45  * @title ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/20
47  */
48 contract ERC20 is ERC20Basic {
49   function allowance(address owner, address spender) constant returns (uint256);
50   function transferFrom(address from, address to, uint256 value) returns (bool);
51   function approve(address spender, uint256 value) returns (bool);
52   event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances. 
57  */
58 contract BasicToken is ERC20Basic {
59     using SafeMath for uint256;
60 
61     mapping (address => uint256) balances;
62 
63     /**
64     * @dev transfer token for a specified address
65     * @param _to The address to transfer to.
66     * @param _value The amount to be transferred.
67     */
68     function transfer(address _to, uint256 _value) returns (bool) {
69         require(_to != address(0));
70 
71         // SafeMath.sub will throw if there is not enough balance.
72         balances[msg.sender] = balances[msg.sender].sub(_value);
73         balances[_to] = balances[_to].add(_value);
74         Transfer(msg.sender, _to, _value);
75         return true;
76     }
77 
78     /**
79     * @dev Gets the balance of the specified address.
80     * @param _owner The address to query the the balance of.
81     * @return An uint256 representing the amount owned by the passed address.
82     */
83     function balanceOf(address _owner) constant returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * @dev https://github.com/ethereum/EIPs/issues/20
94  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 contract StandardToken is ERC20, BasicToken {
97 
98     mapping (address => mapping (address => uint256)) allowed;
99 
100 
101     /**
102      * @dev Transfer tokens from one address to another
103      * @param _from address The address which you want to send tokens from
104      * @param _to address The address which you want to transfer to
105      * @param _value uint256 the amount of tokens to be transferred
106      */
107     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
108         require(_to != address(0));
109 
110         var _allowance = allowed[_from][msg.sender];
111 
112         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
113         // require (_value <= _allowance);
114 
115         balances[_from] = balances[_from].sub(_value);
116         balances[_to] = balances[_to].add(_value);
117         allowed[_from][msg.sender] = _allowance.sub(_value);
118         Transfer(_from, _to, _value);
119         return true;
120     }
121 
122     /**
123      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
124      * @param _spender The address which will spend the funds.
125      * @param _value The amount of tokens to be spent.
126      */
127     function approve(address _spender, uint256 _value) returns (bool) {
128 
129         // To change the approve amount you first have to reduce the addresses`
130         //  allowance to zero by calling `approve(_spender, 0)` if it is not
131         //  already 0 to mitigate the race condition described here:
132         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
134 
135         allowed[msg.sender][_spender] = _value;
136         Approval(msg.sender, _spender, _value);
137         return true;
138     }
139 
140     /**
141      * @dev Function to check the amount of tokens that an owner allowed to a spender.
142      * @param _owner address The address which owns the funds.
143      * @param _spender address The address which will spend the funds.
144      * @return A uint256 specifying the amount of tokens still available for the spender.
145      */
146     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
147         return allowed[_owner][_spender];
148     }
149 
150     /**
151      * approve should be called when allowed[_spender] == 0. To increment
152      * allowed value is better to use this function to avoid 2 calls (and wait until
153      * the first transaction is mined)
154      * From MonolithDAO Token.sol
155      */
156     function increaseApproval(address _spender, uint _addedValue) returns (bool success) {
157         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
158         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159         return true;
160     }
161 
162     function decreaseApproval(address _spender, uint _subtractedValue) returns (bool success) {
163         uint oldValue = allowed[msg.sender][_spender];
164         if (_subtractedValue > oldValue) {
165             allowed[msg.sender][_spender] = 0;
166         }
167         else {
168             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
169         }
170         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171         return true;
172     }
173 
174 }
175 
176 /**
177  * @title Ownable
178  * @dev The Ownable contract has an owner address, and provides basic authorization control
179  * functions, this simplifies the implementation of "user permissions".
180  */
181 contract Ownable {
182     address public owner;
183 
184 
185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
186 
187 
188     /**
189      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
190      * account.
191      */
192     function Ownable() {
193         owner = msg.sender;
194     }
195 
196 
197     /**
198      * @dev Throws if called by any account other than the owner.
199      */
200     modifier onlyOwner() {
201         require(msg.sender == owner);
202         _;
203     }
204 
205 
206     /**
207      * @dev Allows the current owner to transfer control of the contract to a newOwner.
208      * @param newOwner The address to transfer ownership to.
209      */
210     function transferOwnership(address newOwner) onlyOwner {
211         require(newOwner != address(0));
212         OwnershipTransferred(owner, newOwner);
213         owner = newOwner;
214     }
215 
216 }
217 
218 /**
219  * @title Mintable token
220  * @dev Simple ERC20 Token example, with mintable token creation
221  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
222  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
223  */
224 
225 contract MintableToken is StandardToken, Ownable {
226     event Mint(address indexed to, uint256 amount);
227 
228     event MintFinished();
229 
230     bool public mintingFinished = false;
231 
232 
233     modifier canMint() {
234         require(!mintingFinished);
235         _;
236     }
237 
238     /**
239      * @dev Function to mint tokens
240      * @param _to The address that will receive the minted tokens.
241      * @param _amount The amount of tokens to mint.
242      * @return A boolean that indicates if the operation was successful.
243      */
244     function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
245         totalSupply = totalSupply.add(_amount);
246         balances[_to] = balances[_to].add(_amount);
247         Mint(_to, _amount);
248         Transfer(0x0, _to, _amount);
249         return true;
250     }
251 
252     /**
253      * @dev Function to stop minting new tokens.
254      * @return True if the operation was successful.
255      */
256     function finishMinting() onlyOwner returns (bool) {
257         mintingFinished = true;
258         MintFinished();
259         return true;
260     }
261 }
262 
263 contract usingMyWillConsts {
264     uint constant TOKEN_DECIMALS = 18;
265     uint8 constant TOKEN_DECIMALS_UINT8 = 18;
266     uint constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
267 }
268 contract MyWillToken is usingMyWillConsts, MintableToken {
269     /**
270      * @dev Pause token transfer. After successfully finished crowdsale it becomes true.
271      */
272     bool public paused = true;
273     /**
274      * @dev Accounts who can transfer token even if paused. Works only during crowdsale.
275      */
276     mapping(address => bool) excluded;
277 
278     function name() constant public returns (string _name) {
279         return "MyWill Coin";
280     }
281 
282     function symbol() constant public returns (bytes32 _symbol) {
283         return "WIL";
284     }
285 
286     function decimals() constant public returns (uint8 _decimals) {
287         return TOKEN_DECIMALS_UINT8;
288     }
289 
290     function crowdsaleFinished() onlyOwner {
291         paused = false;
292     }
293 
294     function addExcluded(address _toExclude) onlyOwner {
295         excluded[_toExclude] = true;
296     }
297 
298     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
299         require(!paused || excluded[_from]);
300         return super.transferFrom(_from, _to, _value);
301     }
302 
303     function transfer(address _to, uint256 _value) returns (bool) {
304         require(!paused || excluded[msg.sender]);
305         return super.transfer(_to, _value);
306     }
307 }
308 /**
309  * @title Crowdsale 
310  * @dev Crowdsale is a base contract for managing a token crowdsale.
311  *
312  * Crowdsales have a start and end timestamps, where investors can make
313  * token purchases and the crowdsale will assign them tokens based
314  * on a token per ETH rate. Funds collected are forwarded to a wallet 
315  * as they arrive.
316  */
317 contract Crowdsale {
318     using SafeMath for uint;
319 
320     // The token being sold
321     MintableToken public token;
322 
323     // start and end timestamps where investments are allowed (both inclusive)
324     uint32 public startTime;
325     uint32 public endTime;
326 
327     // address where funds are collected
328     address public wallet;
329 
330     // amount of raised money in wei
331     uint public weiRaised;
332 
333     /**
334      * @dev Amount of already sold tokens.
335      */
336     uint public soldTokens;
337 
338     /**
339      * @dev Maximum amount of tokens to mint.
340      */
341     uint public hardCap;
342 
343     /**
344      * event for token purchase logging
345      * @param purchaser who paid for the tokens
346      * @param beneficiary who got the tokens
347      * @param value weis paid for purchase
348      * @param amount amount of tokens purchased
349      */
350     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint value, uint amount);
351 
352 
353     function Crowdsale(uint32 _startTime, uint32 _endTime, uint _hardCap, address _wallet) {
354         require(_startTime >= now);
355         require(_endTime >= _startTime);
356         require(_wallet != 0x0);
357         require(_hardCap > 0);
358 
359         token = createTokenContract();
360         startTime = _startTime;
361         endTime = _endTime;
362         hardCap = _hardCap;
363         wallet = _wallet;
364     }
365 
366     // creates the token to be sold.
367     // override this method to have crowdsale of a specific mintable token.
368     function createTokenContract() internal returns (MintableToken) {
369         return new MintableToken();
370     }
371 
372     /**
373      * @dev this method might be overridden for implementing any sale logic.
374      * @return Actual rate.
375      */
376     function getRate(uint amount) internal constant returns (uint);
377 
378     function getBaseRate() internal constant returns (uint);
379 
380     /**
381      * @dev rate scale (or divider), to support not integer rates.
382      * @return Rate divider.
383      */
384     function getRateScale() internal constant returns (uint) {
385         return 1;
386     }
387 
388     // fallback function can be used to buy tokens
389     function() payable {
390         buyTokens(msg.sender, msg.value);
391     }
392 
393     // low level token purchase function
394     function buyTokens(address beneficiary, uint amountWei) internal {
395         require(beneficiary != 0x0);
396 
397         // total minted tokens
398         uint totalSupply = token.totalSupply();
399 
400         // actual token minting rate (with considering bonuses and discounts)
401         uint actualRate = getRate(amountWei);
402         uint rateScale = getRateScale();
403 
404         require(validPurchase(amountWei, actualRate, totalSupply));
405 
406         // calculate token amount to be created
407         uint tokens = amountWei.mul(actualRate).div(rateScale);
408 
409         // change, if minted token would be less
410         uint change = 0;
411 
412         // if hard cap reached
413         if (tokens.add(totalSupply) > hardCap) {
414             // rest tokens
415             uint maxTokens = hardCap.sub(totalSupply);
416             uint realAmount = maxTokens.mul(rateScale).div(actualRate);
417 
418             // rest tokens rounded by actualRate
419             tokens = realAmount.mul(actualRate).div(rateScale);
420             change = amountWei - realAmount;
421             amountWei = realAmount;
422         }
423 
424         // update state
425         weiRaised = weiRaised.add(amountWei);
426         soldTokens = soldTokens.add(tokens);
427 
428         token.mint(beneficiary, tokens);
429         TokenPurchase(msg.sender, beneficiary, amountWei, tokens);
430 
431         if (change != 0) {
432             msg.sender.transfer(change);
433         }
434         forwardFunds(amountWei);
435     }
436 
437     // send ether to the fund collection wallet
438     // override to create custom fund forwarding mechanisms
439     function forwardFunds(uint amountWei) internal {
440         wallet.transfer(amountWei);
441     }
442 
443     /**
444      * @dev Check if the specified purchase is valid.
445      * @return true if the transaction can buy tokens
446      */
447     function validPurchase(uint _amountWei, uint _actualRate, uint _totalSupply) internal constant returns (bool) {
448         bool withinPeriod = now >= startTime && now <= endTime;
449         bool nonZeroPurchase = _amountWei != 0;
450         bool hardCapNotReached = _totalSupply <= hardCap.sub(_actualRate);
451 
452         return withinPeriod && nonZeroPurchase && hardCapNotReached;
453     }
454 
455     /**
456      * @dev Because of discount hasEnded might be true, but validPurchase returns false.
457      * @return true if crowdsale event has ended
458      */
459     function hasEnded() public constant returns (bool) {
460         return now > endTime || token.totalSupply() > hardCap.sub(getBaseRate());
461     }
462 
463     /**
464      * @return true if crowdsale event has started
465      */
466     function hasStarted() public constant returns (bool) {
467         return now >= startTime;
468     }
469 
470     /**
471      * @dev Check this crowdsale event has ended considering with amount to buy.
472      * @param _value Amount to spend.
473      * @return true if crowdsale event has ended
474      */
475     function hasEnded(uint _value) public constant returns (bool) {
476         uint actualRate = getRate(_value);
477         return now > endTime || token.totalSupply() > hardCap.sub(actualRate);
478     }
479 }
480 
481 /**
482  * @title FinalizableCrowdsale
483  * @dev Extension of Crowsdale where an owner can do extra work
484  * after finishing. 
485  */
486 contract FinalizableCrowdsale is Crowdsale, Ownable {
487     using SafeMath for uint256;
488 
489     bool public isFinalized = false;
490 
491     event Finalized();
492 
493     function FinalizableCrowdsale(uint32 _startTime, uint32 _endTime, uint _hardCap, address _wallet)
494             Crowdsale(_startTime, _endTime, _hardCap, _wallet) {
495     }
496 
497     /**
498      * @dev Must be called after crowdsale ends, to do some extra finalization
499      * work. Calls the contract's finalization function.
500      */
501     function finalize() onlyOwner notFinalized {
502         require(hasEnded());
503 
504         finalization();
505         Finalized();
506 
507         isFinalized = true;
508     }
509 
510     /**
511      * @dev Can be overriden to add finalization logic. The overriding function
512      * should call super.finalization() to ensure the chain of finalization is
513      * executed entirely.
514      */
515     function finalization() internal {
516     }
517 
518     modifier notFinalized() {
519         require(!isFinalized);
520         _;
521     }
522 }
523 
524 /**
525  * @title RefundVault
526  * @dev This contract is used for storing funds while a crowdsale
527  * is in progress. Supports refunding the money if crowdsale fails,
528  * and forwarding it if crowdsale is successful.
529  */
530 contract RefundVault is Ownable {
531     using SafeMath for uint256;
532 
533     enum State {Active, Refunding, Closed}
534 
535     mapping (address => uint256) public deposited;
536 
537     address public wallet;
538 
539     State public state;
540 
541     event Closed();
542 
543     event RefundsEnabled();
544 
545     event Refunded(address indexed beneficiary, uint256 weiAmount);
546 
547     function RefundVault(address _wallet) {
548         require(_wallet != 0x0);
549         wallet = _wallet;
550         state = State.Active;
551     }
552 
553     function deposit(address investor) onlyOwner payable {
554         require(state == State.Active);
555         deposited[investor] = deposited[investor].add(msg.value);
556     }
557 
558     function close() onlyOwner {
559         require(state == State.Active);
560         state = State.Closed;
561         Closed();
562         wallet.transfer(this.balance);
563     }
564 
565     function enableRefunds() onlyOwner {
566         require(state == State.Active);
567         state = State.Refunding;
568         RefundsEnabled();
569     }
570 
571     function refund(address investor) onlyOwner {
572         require(state == State.Refunding);
573         uint256 depositedValue = deposited[investor];
574         deposited[investor] = 0;
575         investor.transfer(depositedValue);
576         Refunded(investor, depositedValue);
577     }
578 }
579 
580 /**
581  * @title RefundableCrowdsale
582  * @dev Extension of Crowdsale contract that adds a funding goal, and
583  * the possibility of users getting a refund if goal is not met.
584  * Uses a RefundVault as the crowdsale's vault.
585  */
586 contract RefundableCrowdsale is FinalizableCrowdsale {
587     using SafeMath for uint256;
588 
589     // minimum amount of funds to be raised in weis
590     uint public goal;
591 
592     // refund vault used to hold funds while crowdsale is running
593     RefundVault public vault;
594 
595     function RefundableCrowdsale(uint32 _startTime, uint32 _endTime, uint _hardCap, address _wallet, uint _goal)
596             FinalizableCrowdsale(_startTime, _endTime, _hardCap, _wallet) {
597         require(_goal > 0);
598         vault = new RefundVault(wallet);
599         goal = _goal;
600     }
601 
602     // We're overriding the fund forwarding from Crowdsale.
603     // In addition to sending the funds, we want to call
604     // the RefundVault deposit function
605     function forwardFunds(uint amountWei) internal {
606         if (goalReached()) {
607             wallet.transfer(amountWei);
608         }
609         else {
610             vault.deposit.value(amountWei)(msg.sender);
611         }
612     }
613 
614     // if crowdsale is unsuccessful, investors can claim refunds here
615     function claimRefund() public {
616         require(isFinalized);
617         require(!goalReached());
618 
619         vault.refund(msg.sender);
620     }
621 
622     /**
623      * @dev Close vault only if goal was reached.
624      */
625     function closeVault() public onlyOwner {
626         require(goalReached());
627         vault.close();
628     }
629 
630     // vault finalization task, called when owner calls finalize()
631     function finalization() internal {
632         super.finalization();
633 
634         if (goalReached()) {
635             vault.close();
636         }
637         else {
638             vault.enableRefunds();
639         }
640     }
641 
642     function goalReached() public constant returns (bool) {
643         return weiRaised >= goal;
644     }
645 
646 }
647 contract MyWillRateProviderI {
648     /**
649      * @dev Calculate actual rate using the specified parameters.
650      * @param buyer     Investor (buyer) address.
651      * @param totalSold Amount of sold tokens.
652      * @param amountWei Amount of wei to purchase.
653      * @return ETH to Token rate.
654      */
655     function getRate(address buyer, uint totalSold, uint amountWei) public constant returns (uint);
656 
657     /**
658      * @dev rate scale (or divider), to support not integer rates.
659      * @return Rate divider.
660      */
661     function getRateScale() public constant returns (uint);
662 
663     /**
664      * @return Absolute base rate.
665      */
666     function getBaseRate() public constant returns (uint);
667 }
668 
669 contract MyWillRateProvider is usingMyWillConsts, MyWillRateProviderI, Ownable {
670     // rate calculate accuracy
671     uint constant RATE_SCALE = 10000;
672     uint constant STEP_30 = 20000000 * TOKEN_DECIMAL_MULTIPLIER;
673     uint constant STEP_20 = 40000000 * TOKEN_DECIMAL_MULTIPLIER;
674     uint constant STEP_10 = 60000000 * TOKEN_DECIMAL_MULTIPLIER;
675     uint constant RATE_30 = 1950 * RATE_SCALE;
676     uint constant RATE_20 = 1800 * RATE_SCALE;
677     uint constant RATE_10 = 1650 * RATE_SCALE;
678     uint constant BASE_RATE = 1500 * RATE_SCALE;
679 
680     struct ExclusiveRate {
681         // be careful, accuracies this about 15 minutes
682         uint32 workUntil;
683         // exclusive rate or 0
684         uint rate;
685         // rate bonus percent, which will be divided by 1000 or 0
686         uint16 bonusPercent1000;
687         // flag to check, that record exists
688         bool exists;
689     }
690 
691     mapping(address => ExclusiveRate) exclusiveRate;
692 
693     function getRateScale() public constant returns (uint) {
694         return RATE_SCALE;
695     }
696 
697     function getBaseRate() public constant returns (uint) {
698         return BASE_RATE;
699     }
700 
701     function getRate(address buyer, uint totalSold, uint amountWei) public constant returns (uint) {
702         uint rate;
703         // apply sale
704         if (totalSold < STEP_30) {
705             rate = RATE_30;
706         }
707         else if (totalSold < STEP_20) {
708             rate = RATE_20;
709         }
710         else if (totalSold < STEP_10) {
711             rate = RATE_10;
712         }
713         else {
714             rate = BASE_RATE;
715         }
716 
717         // apply bonus for amount
718         if (amountWei >= 1000 ether) {
719             rate += rate * 13 / 100;
720         }
721         else if (amountWei >= 500 ether) {
722             rate += rate * 10 / 100;
723         }
724         else if (amountWei >= 100 ether) {
725             rate += rate * 7 / 100;
726         }
727         else if (amountWei >= 50 ether) {
728             rate += rate * 5 / 100;
729         }
730         else if (amountWei >= 30 ether) {
731             rate += rate * 4 / 100;
732         }
733         else if (amountWei >= 10 ether) {
734             rate += rate * 25 / 1000;
735         }
736 
737         ExclusiveRate memory eRate = exclusiveRate[buyer];
738         if (eRate.exists && eRate.workUntil >= now) {
739             if (eRate.rate != 0) {
740                 rate = eRate.rate;
741             }
742             rate += rate * eRate.bonusPercent1000 / 1000;
743         }
744         return rate;
745     }
746 
747     function setExclusiveRate(address _investor, uint _rate, uint16 _bonusPercent1000, uint32 _workUntil) onlyOwner {
748         exclusiveRate[_investor] = ExclusiveRate(_workUntil, _rate, _bonusPercent1000, true);
749     }
750 
751     function removeExclusiveRate(address _investor) onlyOwner {
752         delete exclusiveRate[_investor];
753     }
754 }
755 contract MyWillCrowdsale is usingMyWillConsts, RefundableCrowdsale {
756     uint constant teamTokens = 11000000 * TOKEN_DECIMAL_MULTIPLIER;
757     uint constant bountyTokens = 2000000 * TOKEN_DECIMAL_MULTIPLIER;
758     uint constant icoTokens = 3038800 * TOKEN_DECIMAL_MULTIPLIER;
759     uint constant minimalPurchase = 0.05 ether;
760     address constant teamAddress = 0xE4F0Ff4641f3c99de342b06c06414d94A585eFfb;
761     address constant bountyAddress = 0x76d4136d6EE53DB4cc087F2E2990283d5317A5e9;
762     address constant icoAccountAddress = 0x195610851A43E9685643A8F3b49F0F8a019204f1;
763 
764     MyWillRateProviderI public rateProvider;
765 
766     function MyWillCrowdsale(
767             uint32 _startTime,
768             uint32 _endTime,
769             uint _softCapWei,
770             uint _hardCapTokens
771     )
772         RefundableCrowdsale(_startTime, _endTime, _hardCapTokens * TOKEN_DECIMAL_MULTIPLIER, 0x80826b5b717aDd3E840343364EC9d971FBa3955C, _softCapWei) {
773 
774         token.mint(teamAddress,  teamTokens);
775         token.mint(bountyAddress, bountyTokens);
776         token.mint(icoAccountAddress, icoTokens);
777 
778         MyWillToken(token).addExcluded(teamAddress);
779         MyWillToken(token).addExcluded(bountyAddress);
780         MyWillToken(token).addExcluded(icoAccountAddress);
781 
782         MyWillRateProvider provider = new MyWillRateProvider();
783         provider.transferOwnership(owner);
784         rateProvider = provider;
785 
786         // pre ICO
787     }
788 
789     /**
790      * @dev override token creation to integrate with MyWill token.
791      */
792     function createTokenContract() internal returns (MintableToken) {
793         return new MyWillToken();
794     }
795 
796     /**
797      * @dev override getRate to integrate with rate provider.
798      */
799     function getRate(uint _value) internal constant returns (uint) {
800         return rateProvider.getRate(msg.sender, soldTokens, _value);
801     }
802 
803     function getBaseRate() internal constant returns (uint) {
804         return rateProvider.getRate(msg.sender, soldTokens, minimalPurchase);
805     }
806 
807     /**
808      * @dev override getRateScale to integrate with rate provider.
809      */
810     function getRateScale() internal constant returns (uint) {
811         return rateProvider.getRateScale();
812     }
813 
814     /**
815      * @dev Admin can set new rate provider.
816      * @param _rateProviderAddress New rate provider.
817      */
818     function setRateProvider(address _rateProviderAddress) onlyOwner {
819         require(_rateProviderAddress != 0);
820         rateProvider = MyWillRateProviderI(_rateProviderAddress);
821     }
822 
823     /**
824      * @dev Admin can move end time.
825      * @param _endTime New end time.
826      */
827     function setEndTime(uint32 _endTime) onlyOwner notFinalized {
828         require(_endTime > startTime);
829         endTime = _endTime;
830     }
831 
832     function validPurchase(uint _amountWei, uint _actualRate, uint _totalSupply) internal constant returns (bool) {
833         if (_amountWei < minimalPurchase) {
834             return false;
835         }
836         return super.validPurchase(_amountWei, _actualRate, _totalSupply);
837     }
838 
839     function finalization() internal {
840         super.finalization();
841         token.finishMinting();
842         if (!goalReached()) {
843             return;
844         }
845         MyWillToken(token).crowdsaleFinished();
846         token.transferOwnership(owner);
847     }
848 }