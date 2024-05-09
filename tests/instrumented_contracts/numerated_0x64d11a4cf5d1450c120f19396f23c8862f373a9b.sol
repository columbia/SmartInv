1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10     /**
11      * @dev Multiplies two numbers, reverts on overflow.
12      */
13     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (_a == 0) {
18         return 0;
19         }
20 
21         uint256 c = _a * _b;
22         require(c / _a == _b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31         require(_b > 0); // Solidity only automatically asserts when dividing by 0
32         uint256 c = _a / _b;
33         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40      */
41     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42         require(_b <= _a);
43         uint256 c = _a - _b;
44 
45         return c;
46     }
47 
48     /**
49      * @dev Adds two numbers, reverts on overflow.
50      */
51     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
52         uint256 c = _a + _b;
53         require(c >= _a);
54 
55         return c;
56     }
57 
58     /**
59      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60      * reverts when dividing by zero.
61      */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75     address public owner;
76 
77 
78     event OwnershipRenounced(address indexed previousOwner);
79     event OwnershipTransferred(
80         address indexed previousOwner,
81         address indexed newOwner
82     );
83 
84 
85     /**
86      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
87      * account.
88      */
89     constructor() public {
90         owner = msg.sender;
91     }
92 
93     /**
94      * @dev Throws if called by any account other than the owner.
95      */
96     modifier onlyOwner() {
97         require(msg.sender == owner);
98         _;
99     }
100 
101     /**
102      * @dev Allows the current owner to relinquish control of the contract.
103      * @notice Renouncing to ownership will leave the contract without an owner.
104      * It will not be possible to call the functions with the `onlyOwner`
105      * modifier anymore.
106      */
107     function renounceOwnership() public onlyOwner {
108         emit OwnershipRenounced(owner);
109         owner = address(0);
110     }
111 
112     /**
113      * @dev Allows the current owner to transfer control of the contract to a newOwner.
114      * @param _newOwner The address to transfer ownership to.
115      */
116     function transferOwnership(address _newOwner) public onlyOwner {
117         _transferOwnership(_newOwner);
118     }
119 
120     /**
121      * @dev Transfers control of the contract to a newOwner.
122      * @param _newOwner The address to transfer ownership to.
123      */
124     function _transferOwnership(address _newOwner) internal {
125         require(_newOwner != address(0));
126         emit OwnershipTransferred(owner, _newOwner);
127         owner = _newOwner;
128     }
129 }
130 
131 
132 /**
133  * @title Currency exchange rate contract
134  */
135 contract CurrencyExchangeRate is Ownable {
136 
137     struct Currency {
138         uint256 exRateToEther; // Exchange rate: currency to Ether
139         uint8 exRateDecimals;  // Exchange rate decimals
140     }
141 
142     Currency[] public currencies;
143 
144     event CurrencyExchangeRateAdded(
145         address indexed setter, uint256 index, uint256 rate, uint256 decimals
146     );
147 
148     event CurrencyExchangeRateSet(
149         address indexed setter, uint256 index, uint256 rate, uint256 decimals
150     );
151 
152     constructor() public {
153         // Add Ether to index 0
154         currencies.push(
155             Currency ({
156                 exRateToEther: 1,
157                 exRateDecimals: 0
158             })
159         );
160         // Add USD to index 1
161         currencies.push(
162             Currency ({
163                 exRateToEther: 30000,
164                 exRateDecimals: 2
165             })
166         );
167     }
168 
169     function addCurrencyExchangeRate(
170         uint256 _exRateToEther, 
171         uint8 _exRateDecimals
172     ) external onlyOwner {
173         emit CurrencyExchangeRateAdded(
174             msg.sender, currencies.length, _exRateToEther, _exRateDecimals);
175         currencies.push(
176             Currency ({
177                 exRateToEther: _exRateToEther,
178                 exRateDecimals: _exRateDecimals
179             })
180         );
181     }
182 
183     function setCurrencyExchangeRate(
184         uint256 _currencyIndex,
185         uint256 _exRateToEther, 
186         uint8 _exRateDecimals
187     ) external onlyOwner {
188         emit CurrencyExchangeRateSet(
189             msg.sender, _currencyIndex, _exRateToEther, _exRateDecimals);
190         currencies[_currencyIndex].exRateToEther = _exRateToEther;
191         currencies[_currencyIndex].exRateDecimals = _exRateDecimals;
192     }
193 }
194 
195 
196 /**
197  * @title KYC contract interface
198  */
199 contract KYC {
200     
201     /**
202      * Get KYC expiration timestamp in second.
203      *
204      * @param _who Account address
205      * @return KYC expiration timestamp in second
206      */
207     function expireOf(address _who) external view returns (uint256);
208 
209     /**
210      * Get KYC level.
211      * Level is ranging from 0 (lowest, no KYC) to 255 (highest, toughest).
212      *
213      * @param _who Account address
214      * @return KYC level
215      */
216     function kycLevelOf(address _who) external view returns (uint8);
217 
218     /**
219      * Get encoded nationalities (country list).
220      * The uint256 is represented by 256 bits (0 or 1).
221      * Every bit can represent a country.
222      * For each listed country, set the corresponding bit to 1.
223      * To do so, up to 256 countries can be encoded in an uint256 variable.
224      * Further, if country blacklist of an ICO was encoded by the same way,
225      * it is able to use bitwise AND to check whether the investor can invest
226      * the ICO by the crowdsale.
227      *
228      * @param _who Account address
229      * @return Encoded nationalities
230      */
231     function nationalitiesOf(address _who) external view returns (uint256);
232 
233     /**
234      * Set KYC status to specific account address.
235      *
236      * @param _who Account address
237      * @param _expiresAt Expire timestamp in seconds
238      * @param _level KYC level
239      * @param _nationalities Encoded nationalities
240      */
241     function setKYC(
242         address _who, uint256 _expiresAt, uint8 _level, uint256 _nationalities) 
243         external;
244 
245     event KYCSet (
246         address indexed _setter,
247         address indexed _who,
248         uint256 _expiresAt,
249         uint8 _level,
250         uint256 _nationalities
251     );
252 }
253 
254 
255 /**
256  * @title ERC20 interface
257  * @dev see https://github.com/ethereum/EIPs/issues/20
258  */
259 contract ERC20 {
260     function totalSupply() public view returns (uint256);
261 
262     function balanceOf(address _who) public view returns (uint256);
263 
264     function allowance(address _owner, address _spender)
265         public view returns (uint256);
266 
267     function transfer(address _to, uint256 _value) public returns (bool);
268 
269     function approve(address _spender, uint256 _value)
270         public returns (bool);
271 
272     function transferFrom(address _from, address _to, uint256 _value)
273         public returns (bool);
274 
275     event Transfer(
276         address indexed from,
277         address indexed to,
278         uint256 value
279     );
280 
281     event Approval(
282         address indexed owner,
283         address indexed spender,
284         uint256 value
285     );
286 }
287 
288 
289 contract EtherVault is Ownable {
290     using SafeMath for uint256;
291 
292     enum State { Active, Refunding, Closed }
293 
294     address public wallet;
295     State public state;
296 
297     event Closed(address indexed commissionWallet, uint256 commission);
298     event RefundsEnabled();
299     event Refunded(address indexed beneficiary, uint256 weiAmount);
300 
301     constructor(address _wallet) public {
302         require(
303             _wallet != address(0),
304             "Failed to create Ether vault due to wallet address is 0x0."
305         );
306         wallet = _wallet;
307         state = State.Active;
308     }
309 
310     function deposit() public onlyOwner payable {
311         require(
312             state == State.Active,
313             "Failed to deposit Ether due to state is not Active."
314         );
315     }
316 
317     function close(address _commissionWallet, uint256 _commission) public onlyOwner {
318         require(
319             state == State.Active,
320             "Failed to close due to state is not Active."
321         );
322         state = State.Closed;
323         emit Closed(_commissionWallet, _commission);
324         _commissionWallet.transfer(address(this).balance.mul(_commission).div(100));
325         wallet.transfer(address(this).balance);
326     }
327 
328     function enableRefunds() public onlyOwner {
329         require(
330             state == State.Active,
331             "Failed to enable refunds due to state is not Active."
332         );
333         emit RefundsEnabled();
334         state = State.Refunding;        
335     }
336 
337     function refund(address investor, uint256 depositedValue) public onlyOwner {
338         require(
339             state == State.Refunding,
340             "Failed to refund due to state is not Refunding."
341         );
342         emit Refunded(investor, depositedValue);
343         investor.transfer(depositedValue);        
344     }
345 }
346 
347 
348 
349 /**
350  * @title ICO Rocket Fuel contract for FirstMile/LastMile service.
351  */
352 contract IcoRocketFuel is Ownable {
353     using SafeMath for uint256;
354 
355     // Crowdsale current state
356     enum States {Ready, Active, Paused, Refunding, Closed}
357     States public state = States.Ready;
358 
359     // Token for crowdsale (Token contract).
360     // Replace 0x0 by deployed ERC20 token address.
361     ERC20 public token = ERC20(0x0e27b0ca1f890d37737dd5cde9de22431255f524);
362 
363     // Crowdsale owner (ICO team).
364     // Replace 0x0 by wallet address of ICO team.
365     address public crowdsaleOwner = 0xf75589cac3b23f24de65fe5a3cd07966728071a3;
366 
367     // When crowdsale is closed, commissions will transfer to this wallet.
368     // Replace 0x0 by commission wallet address of platform.
369     address public commissionWallet = 0xf75589cac3b23f24de65fe5a3cd07966728071a3;
370 
371     // Base exchange rate (1 invested currency = N tokens) and its decimals.
372     // Ex. to present base exchange rate = 0.01 (= 1 / (10^2))
373     //     baseExRate = 1; baseExRateDecimals = 2 
374     //     (1 / (10^2)) equal to (baseExRate / (10^baseExRateDecimals))
375     uint256 public baseExRate = 20;    
376     uint8 public baseExRateDecimals = 0;
377 
378     // External exchange rate contract and currency index.
379     // Use exRate.currencies(currency) to get tuple.
380     // tuple = (Exchange rate to Ether, Exchange rate decimal)
381     // Replace 0x0 by address of deployed CurrencyExchangeRate contract.
382     CurrencyExchangeRate public exRate = CurrencyExchangeRate(0x44802e3d6fb67bd8ee7b24033ee04b1290692fd9);
383     // Supported currency
384     // 0: Ether
385     // 1: USD
386     uint256 public currency = 1;
387 
388     // Total raised in specified currency.
389     uint256 public raised = 0;
390     // Hard cap in specified currency.
391     uint256 public cap = 25000000 * (10**18);
392     // Soft cap in specified currency.
393     uint256 public goal = 0;
394     // Minimum investment in specified currency.
395     uint256 public minInvest = 50000 * (10**18);
396     
397     // Crowdsale closing time in second.
398     uint256 public closingTime = 1548979200;
399     // Whether allow early closure
400     bool public earlyClosure = true;
401 
402     // Commission percentage. Set to 10 means 10% 
403     uint8 public commission = 10;
404 
405     // When KYC is required, check KYC result with this contract.
406     // The value is initiated by constructor.
407     // The value is not allowed to change after contract deployment.
408     // Replace 0x0 by address of deployed KYC contract.
409     KYC public kyc = KYC(0x8df3064451f840285993e2a4cfc0ec56b267d288);
410 
411     // Get encoded country blacklist.
412     // The uint256 is represented by 256 bits (0 or 1).
413     // Every bit can represent a country.
414     // For the country listed in the blacklist, set the corresponding bit to 1.
415     // To do so, up to 256 countries can be encoded in an uint256 variable.
416     // Further, if nationalities of an investor were encoded by the same way,
417     // it is able to use bitwise AND to check whether the investor can invest
418     // the ICO by the crowdsale.
419     // Keypasco: Natural persons from Singapore and United States cannot invest.
420     uint256 public countryBlacklist = 27606985387965724171868518586879082855975017189942647717541493312847872;
421 
422     // Get required KYC level of the crowdsale.
423     // KYC level = 0 (default): Crowdsale does not require KYC.
424     // KYC level > 0: Crowdsale requires centain level of KYC.
425     // KYC level ranges from 0 (no KYC) to 255 (toughest).
426     uint8 public kycLevel = 100;
427 
428     // Whether legal person can skip country check.
429     // True: can skip; False: cannot skip.  
430     bool public legalPersonSkipsCountryCheck = true;
431 
432     // Use deposits[buyer] to get deposited Wei for buying the token.
433     // The buyer is the buyer address.
434     mapping(address => uint256) public deposits;
435     // Ether vault entrusts invested Wei.
436     EtherVault public vault;
437     
438     // Investment in specified currency.
439     // Use invests[buyer] to get current investments.
440     mapping(address => uint256) public invests;
441     // Token units can be claimed by buyer.
442     // Use tokenUnits[buyer] to get current bought token units.
443     mapping(address => uint256) public tokenUnits;
444     // Total token units for performing the deal.
445     // Sum of all buyers' bought token units will equal to this value.
446     uint256 public totalTokenUnits = 0;
447 
448     // Bonus tiers which will be initiated in constructor.
449     struct BonusTier {
450         uint256 investSize; // Invest in specified currency
451         uint256 bonus;      // Bonus in percentage
452     }
453     // Bonus levels initiated by constructor.
454     BonusTier[] public bonusTiers;
455 
456     event StateSet(
457         address indexed setter, 
458         States oldState, 
459         States newState
460     );
461 
462     event CrowdsaleStarted(
463         address indexed icoTeam
464     );
465 
466     event TokenBought(
467         address indexed buyer, 
468         uint256 valueWei, 
469         uint256 valueCurrency
470     );
471 
472     event TokensRefunded(
473         address indexed beneficiary,
474         uint256 valueTokenUnit
475     );
476 
477     event Finalized(
478         address indexed icoTeam
479     );
480 
481     event SurplusTokensRefunded(
482         address indexed beneficiary,
483         uint256 valueTokenUnit
484     );
485 
486     event CrowdsaleStopped(
487         address indexed owner
488     );
489 
490     event TokenClaimed(
491         address indexed beneficiary,
492         uint256 valueTokenUnit
493     );
494 
495     event RefundClaimed(
496         address indexed beneficiary,
497         uint256 valueWei
498     );
499 
500     modifier onlyCrowdsaleOwner() {
501         require(
502             msg.sender == crowdsaleOwner,
503             "Failed to call function due to permission denied."
504         );
505         _;
506     }
507 
508     modifier inState(States _state) {
509         require(
510             state == _state,
511             "Failed to call function due to crowdsale is not in right state."
512         );
513         _;
514     }
515 
516     constructor() public {
517         // Must push higher bonus first.
518         bonusTiers.push(
519             BonusTier({
520                 investSize: 400000 * (10**18),
521                 bonus: 50
522             })
523         );
524         bonusTiers.push(
525             BonusTier({
526                 investSize: 200000 * (10**18),
527                 bonus: 40
528             })
529         );
530         bonusTiers.push(
531             BonusTier({
532                 investSize: 100000 * (10**18),
533                 bonus: 30
534             })
535         );
536         bonusTiers.push(
537             BonusTier({
538                 investSize: 50000 * (10**18),
539                 bonus: 20
540             })
541         );
542     }
543 
544     function setAddress(
545         address _token,
546         address _crowdsaleOwner,
547         address _commissionWallet,
548         address _exRate,
549         address _kyc
550     ) external onlyOwner inState(States.Ready){
551         token = ERC20(_token);
552         crowdsaleOwner = _crowdsaleOwner;
553         commissionWallet = _commissionWallet;
554         exRate = CurrencyExchangeRate(_exRate);
555         kyc = KYC(_kyc);
556     }
557 
558     function setSpecialOffer(
559         uint256 _currency,
560         uint256 _cap,
561         uint256 _goal,
562         uint256 _minInvest,
563         uint256 _closingTime
564     ) external onlyOwner inState(States.Ready) {
565         currency = _currency;
566         cap = _cap;
567         goal = _goal;
568         minInvest = _minInvest;
569         closingTime = _closingTime;
570     }
571 
572     function setInvestRestriction(
573         uint256 _countryBlacklist,
574         uint8 _kycLevel,
575         bool _legalPersonSkipsCountryCheck
576     ) external onlyOwner inState(States.Ready) {
577         countryBlacklist = _countryBlacklist;
578         kycLevel = _kycLevel;
579         legalPersonSkipsCountryCheck = _legalPersonSkipsCountryCheck;
580     }
581 
582     function setState(uint256 _state) external onlyOwner {
583         require(
584             uint256(state) < uint256(States.Refunding),
585             "Failed to set state due to crowdsale was finalized."
586         );
587         require(
588             // Only allow switch state between Active and Paused.
589             uint256(States.Active) == _state || uint256(States.Paused) == _state,
590             "Failed to set state due to invalid index."
591         );
592         emit StateSet(msg.sender, state, States(_state));
593         state = States(_state);
594     }
595 
596     /**
597      * Get bonus in token units.
598      * @param _investSize Total investment size in specified currency
599      * @param _tokenUnits Token units for the investment (without bonus)
600      * @return Bonus in token units
601      */
602     function _getBonus(uint256 _investSize, uint256 _tokenUnits) 
603         private view returns (uint256) 
604     {
605         for (uint256 _i = 0; _i < bonusTiers.length; _i++) {
606             if (_investSize >= bonusTiers[_i].investSize) {
607                 return _tokenUnits.mul(bonusTiers[_i].bonus).div(100);
608             }
609         }
610         return 0;
611     }
612 
613     /**
614      * Start crowdsale.
615      */
616     function startCrowdsale()
617         external
618         onlyCrowdsaleOwner
619         inState(States.Ready)
620     {
621         emit CrowdsaleStarted(msg.sender);
622         vault = new EtherVault(msg.sender);
623         state = States.Active;
624     }
625 
626     /**
627      * Buy token.
628      */
629     function buyToken()
630         external
631         inState(States.Active)
632         payable
633     {
634         // KYC level = 0 means no KYC can invest.
635         // KYC level > 0 means certain level of KYC is required.
636         if (kycLevel > 0) {
637             require(
638                 // solium-disable-next-line security/no-block-members
639                 block.timestamp < kyc.expireOf(msg.sender),
640                 "Failed to buy token due to KYC was expired."
641             );
642         }
643 
644         require(
645             kycLevel <= kyc.kycLevelOf(msg.sender),
646             "Failed to buy token due to require higher KYC level."
647         );
648 
649         require(
650             countryBlacklist & kyc.nationalitiesOf(msg.sender) == 0 || (
651                 kyc.kycLevelOf(msg.sender) >= 200 && legalPersonSkipsCountryCheck
652             ),
653             "Failed to buy token due to country investment restriction."
654         );
655 
656         // Get exchange rate of specified currency.
657         (uint256 _exRate, uint8 _exRateDecimals) = exRate.currencies(currency);
658 
659         // Convert from Ether to base currency.
660         uint256 _investSize = (msg.value)
661             .mul(_exRate).div(10**uint256(_exRateDecimals));
662 
663         require(
664             _investSize >= minInvest,
665             "Failed to buy token due to less than minimum investment."
666         );
667 
668         require(
669             raised.add(_investSize) <= cap,
670             "Failed to buy token due to exceed cap."
671         );
672 
673         require(
674             // solium-disable-next-line security/no-block-members
675             block.timestamp < closingTime,
676             "Failed to buy token due to crowdsale is closed."
677         );
678 
679         // Update total invested in specified currency.
680         invests[msg.sender] = invests[msg.sender].add(_investSize);
681         // Update total invested wei.
682         deposits[msg.sender] = deposits[msg.sender].add(msg.value);
683         // Update total raised in specified currency.    
684         raised = raised.add(_investSize);
685 
686         // Log previous token units.
687         uint256 _previousTokenUnits = tokenUnits[msg.sender];
688 
689         // Calculate token units by base exchange rate.
690         uint256 _tokenUnits = invests[msg.sender]
691             .mul(baseExRate)
692             .div(10**uint256(baseExRateDecimals));
693 
694         // Calculate bought token units (take bonus into account).
695         uint256 _tokenUnitsWithBonus = _tokenUnits.add(
696             _getBonus(invests[msg.sender], _tokenUnits));
697 
698         // Update total bought token units.
699         tokenUnits[msg.sender] = _tokenUnitsWithBonus;
700 
701         // Update total token units to be issued.
702         totalTokenUnits = totalTokenUnits
703             .sub(_previousTokenUnits)
704             .add(_tokenUnitsWithBonus);
705 
706         emit TokenBought(msg.sender, msg.value, _investSize);
707 
708         // Entrust wei to vault.
709         vault.deposit.value(msg.value)();
710     }
711 
712     /**
713      * Refund token units to wallet address of crowdsale owner.
714      */
715     function _refundTokens()
716         private
717         inState(States.Refunding)
718     {
719         uint256 _value = token.balanceOf(address(this));
720         emit TokensRefunded(crowdsaleOwner, _value);
721         if (_value > 0) {         
722             // Refund all tokens for crowdsale to refund wallet.
723             token.transfer(crowdsaleOwner, _value);
724         }
725     }
726 
727     /**
728      * Finalize this crowdsale.
729      */
730     function finalize()
731         external
732         inState(States.Active)        
733         onlyCrowdsaleOwner
734     {
735         require(
736             // solium-disable-next-line security/no-block-members                
737             earlyClosure || block.timestamp >= closingTime,                   
738             "Failed to finalize due to crowdsale is opening."
739         );
740 
741         emit Finalized(msg.sender);
742 
743         if (raised >= goal && token.balanceOf(address(this)) >= totalTokenUnits) {
744             // Set state to Closed whiling preventing reentry.
745             state = States.Closed;
746 
747             // Refund surplus tokens.
748             uint256 _balance = token.balanceOf(address(this));
749             uint256 _surplus = _balance.sub(totalTokenUnits);
750             emit SurplusTokensRefunded(crowdsaleOwner, _surplus);
751             if (_surplus > 0) {
752                 // Refund surplus tokens to refund wallet.
753                 token.transfer(crowdsaleOwner, _surplus);
754             }
755             // Close vault, and transfer commission and raised ether.
756             vault.close(commissionWallet, commission);
757         } else {
758             state = States.Refunding;
759             _refundTokens();
760             vault.enableRefunds();
761         }
762     }
763 
764     /**
765      * Stop this crowdsale.
766      * Only stop suspecious projects.
767      */
768     function stopCrowdsale()  
769         external
770         onlyOwner
771         inState(States.Paused)
772     {
773         emit CrowdsaleStopped(msg.sender);
774         state = States.Refunding;
775         _refundTokens();
776         vault.enableRefunds();
777     }
778 
779     /**
780      * Investors claim bought token units.
781      */
782     function claimToken()
783         external 
784         inState(States.Closed)
785     {
786         require(
787             tokenUnits[msg.sender] > 0,
788             "Failed to claim token due to token unit is 0."
789         );
790         uint256 _value = tokenUnits[msg.sender];
791         tokenUnits[msg.sender] = 0;
792         emit TokenClaimed(msg.sender, _value);
793         token.transfer(msg.sender, _value);
794     }
795 
796     /**
797      * Investors claim invested Ether refunds.
798      */
799     function claimRefund()
800         external
801         inState(States.Refunding)
802     {
803         require(
804             deposits[msg.sender] > 0,
805             "Failed to claim refund due to deposit is 0."
806         );
807 
808         uint256 _value = deposits[msg.sender];
809         deposits[msg.sender] = 0;
810         emit RefundClaimed(msg.sender, _value);
811         vault.refund(msg.sender, _value);
812     }
813 }