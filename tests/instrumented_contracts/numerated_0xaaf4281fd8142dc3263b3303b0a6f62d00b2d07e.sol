1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title IWingsAdapter
5  * 
6  * WINGS DAO Price Discovery & Promotion Pre-Beta https://www.wings.ai
7  *
8  * #created 04/10/2017
9  * #author Frank Bonnet
10  */
11 contract IWingsAdapter {
12 
13 
14     /**
15      * Get the total raised amount of Ether
16      *
17      * Can only increase, meaning if you withdraw ETH from the wallet, it should be not modified (you can use two fields 
18      * to keep one with a total accumulated amount) amount of ETH in contract and totalCollected for total amount of ETH collected
19      *
20      * @return Total raised Ether amount
21      */
22     function totalCollected() constant returns (uint);
23 }
24 
25 
26 /**
27  * @title IWhitelist 
28  *
29  * Whitelist authentication interface
30  *
31  * #created 04/10/2017
32  * #author Frank Bonnet
33  */
34 contract IWhitelist {
35     
36 
37     /**
38      * Authenticate 
39      *
40      * Returns whether `_account` is on the whitelist
41      *
42      * @param _account The account to authenticate
43      * @return whether `_account` is successfully authenticated
44      */
45     function authenticate(address _account) constant returns (bool);
46 }
47 
48 
49 /**
50  * @title Token retrieve interface
51  *
52  * Allows tokens to be retrieved from a contract
53  *
54  * #created 29/09/2017
55  * #author Frank Bonnet
56  */
57 contract ITokenRetreiver {
58 
59     /**
60      * Extracts tokens from the contract
61      *
62      * @param _tokenContract The address of ERC20 compatible token
63      */
64     function retreiveTokens(address _tokenContract);
65 }
66 
67 
68 contract Owned {
69 
70     // The address of the account that is the current owner 
71     address internal owner;
72 
73 
74     /**
75      * The publisher is the inital owner
76      */
77     function Owned() {
78         owner = msg.sender;
79     }
80 
81 
82     /**
83      * Access is restricted to the current owner
84      */
85     modifier only_owner() {
86         require(msg.sender == owner);
87 
88         _;
89     }
90 }
91 
92 
93 /**
94  * @title ERC20 compatible token interface
95  *
96  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
97  * - Short address attack fix
98  *
99  * #created 29/09/2017
100  * #author Frank Bonnet
101  */
102 contract IToken { 
103 
104     /** 
105      * Get the total supply of tokens
106      * 
107      * @return The total supply
108      */
109     function totalSupply() constant returns (uint);
110 
111 
112     /** 
113      * Get balance of `_owner` 
114      * 
115      * @param _owner The address from which the balance will be retrieved
116      * @return The balance
117      */
118     function balanceOf(address _owner) constant returns (uint);
119 
120 
121     /** 
122      * Send `_value` token to `_to` from `msg.sender`
123      * 
124      * @param _to The address of the recipient
125      * @param _value The amount of token to be transferred
126      * @return Whether the transfer was successful or not
127      */
128     function transfer(address _to, uint _value) returns (bool);
129 
130 
131     /** 
132      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
133      * 
134      * @param _from The address of the sender
135      * @param _to The address of the recipient
136      * @param _value The amount of token to be transferred
137      * @return Whether the transfer was successful or not
138      */
139     function transferFrom(address _from, address _to, uint _value) returns (bool);
140 
141 
142     /** 
143      * `msg.sender` approves `_spender` to spend `_value` tokens
144      * 
145      * @param _spender The address of the account able to transfer the tokens
146      * @param _value The amount of tokens to be approved for transfer
147      * @return Whether the approval was successful or not
148      */
149     function approve(address _spender, uint _value) returns (bool);
150 
151 
152     /** 
153      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
154      * 
155      * @param _owner The address of the account owning tokens
156      * @param _spender The address of the account able to transfer the tokens
157      * @return Amount of remaining tokens allowed to spent
158      */
159     function allowance(address _owner, address _spender) constant returns (uint);
160 }
161 
162 
163 /**
164  * @title ManagedToken interface
165  *
166  * Adds the following functionallity to the basic ERC20 token
167  * - Locking
168  * - Issuing
169  *
170  * #created 29/09/2017
171  * #author Frank Bonnet
172  */
173 contract IManagedToken is IToken { 
174 
175     /** 
176      * Returns true if the token is locked
177      * 
178      * @return Whether the token is locked
179      */
180     function isLocked() constant returns (bool);
181 
182 
183     /**
184      * Unlocks the token so that the transferring of value is enabled 
185      *
186      * @return Whether the unlocking was successful or not
187      */
188     function unlock() returns (bool);
189 
190 
191     /**
192      * Issues `_value` new tokens to `_to`
193      *
194      * @param _to The address to which the tokens will be issued
195      * @param _value The amount of new tokens to issue
196      * @return Whether the tokens where sucessfully issued or not
197      */
198     function issue(address _to, uint _value) returns (bool);
199 }
200 
201 
202 /**
203  * @title ICrowdsale
204  *
205  * Base crowdsale interface to manage the sale of 
206  * an ERC20 token
207  *
208  * #created 29/09/2017
209  * #author Frank Bonnet
210  */
211 contract ICrowdsale {
212 
213 
214     /**
215      * Returns true if the contract is currently in the presale phase
216      *
217      * @return True if in presale phase
218      */
219     function isInPresalePhase() constant returns (bool);
220 
221 
222     /**
223      * Returns true if `_beneficiary` has a balance allocated
224      *
225      * @param _beneficiary The account that the balance is allocated for
226      * @param _releaseDate The date after which the balance can be withdrawn
227      * @return True if there is a balance that belongs to `_beneficiary`
228      */
229     function hasBalance(address _beneficiary, uint _releaseDate) constant returns (bool);
230 
231 
232     /** 
233      * Get the allocated token balance of `_owner`
234      * 
235      * @param _owner The address from which the allocated token balance will be retrieved
236      * @return The allocated token balance
237      */
238     function balanceOf(address _owner) constant returns (uint);
239 
240 
241     /** 
242      * Get the allocated eth balance of `_owner`
243      * 
244      * @param _owner The address from which the allocated eth balance will be retrieved
245      * @return The allocated eth balance
246      */
247     function ethBalanceOf(address _owner) constant returns (uint);
248 
249 
250     /** 
251      * Get invested and refundable balance of `_owner` (only contributions during the ICO phase are registered)
252      * 
253      * @param _owner The address from which the refundable balance will be retrieved
254      * @return The invested refundable balance
255      */
256     function refundableEthBalanceOf(address _owner) constant returns (uint);
257 
258 
259     /**
260      * Returns the rate and bonus release date
261      *
262      * @param _phase The phase to use while determining the rate
263      * @param _volume The amount wei used to determine what volume multiplier to use
264      * @return The rate used in `_phase` multiplied by the corresponding volume multiplier
265      */
266     function getRate(uint _phase, uint _volume) constant returns (uint);
267 
268 
269     /**
270      * Convert `_wei` to an amount in tokens using 
271      * the `_rate`
272      *
273      * @param _wei amount of wei to convert
274      * @param _rate rate to use for the conversion
275      * @return Amount in tokens
276      */
277     function toTokens(uint _wei, uint _rate) constant returns (uint);
278 
279 
280     /**
281      * Withdraw allocated tokens
282      */
283     function withdrawTokens();
284 
285 
286     /**
287      * Withdraw allocated ether
288      */
289     function withdrawEther();
290 
291 
292     /**
293      * Refund in the case of an unsuccessful crowdsale. The 
294      * crowdsale is considered unsuccessful if minAmount was 
295      * not raised before end of the crowdsale
296      */
297     function refund();
298 
299 
300     /**
301      * Receive Eth and issue tokens to the sender
302      */
303     function () payable;
304 }
305 
306 
307 /**
308  * @title Crowdsale
309  *
310  * Abstract base crowdsale contract that manages the sale of 
311  * an ERC20 token
312  *
313  * #created 29/09/2017
314  * #author Frank Bonnet
315  */
316 contract Crowdsale is ICrowdsale, Owned {
317 
318     enum Stages {
319         Deploying,
320         Deployed,
321         InProgress,
322         Ended
323     }
324 
325     struct Balance {
326         uint eth;
327         uint tokens;
328         uint index;
329     }
330 
331     struct Percentage {
332         uint eth;
333         uint tokens;
334         bool overwriteReleaseDate;
335         uint fixedReleaseDate;
336         uint index; 
337     }
338 
339     struct Payout {
340         uint percentage;
341         uint vestingPeriod;
342     }
343 
344     struct Phase {
345         uint rate;
346         uint end;
347         uint bonusReleaseDate;
348         bool useVolumeMultiplier;
349     }
350 
351     struct VolumeMultiplier {
352         uint rateMultiplier;
353         uint bonusReleaseDateMultiplier;
354     }
355 
356     // Crowdsale details
357     uint public baseRate;
358     uint public minAmount; 
359     uint public maxAmount; 
360     uint public minAcceptedAmount;
361     uint public minAmountPresale; 
362     uint public maxAmountPresale;
363     uint public minAcceptedAmountPresale;
364 
365     // Company address
366     address public beneficiary; 
367 
368     // Denominators
369     uint internal percentageDenominator;
370     uint internal tokenDenominator;
371 
372     // Crowdsale state
373     uint public start;
374     uint public presaleEnd;
375     uint public crowdsaleEnd;
376     uint public raised;
377     uint public allocatedEth;
378     uint public allocatedTokens;
379     Stages public stage;
380 
381     // Token contract
382     IManagedToken public token;
383 
384     // Invested balances
385     mapping (address => uint) private balances;
386 
387     // Alocated balances
388     mapping (address => mapping(uint => Balance)) private allocated;
389     mapping(address => uint[]) private allocatedIndex;
390 
391     // Stakeholders
392     mapping (address => Percentage) private stakeholderPercentages;
393     address[] private stakeholderPercentagesIndex;
394     Payout[] private stakeholdersPayouts;
395 
396     // Crowdsale phases
397     Phase[] private phases;
398 
399     // Volume multipliers
400     mapping (uint => VolumeMultiplier) private volumeMultipliers;
401     uint[] private volumeMultiplierThresholds;
402 
403     
404     /**
405      * Throw if at stage other than current stage
406      * 
407      * @param _stage expected stage to test for
408      */
409     modifier at_stage(Stages _stage) {
410         require(stage == _stage);
411         _;
412     }
413 
414 
415     /**
416      * Only after crowdsaleEnd plus `_time`
417      * 
418      * @param _time Time to pass
419      */
420     modifier only_after(uint _time) {
421         require(now > crowdsaleEnd + _time);
422         _;
423     }
424 
425 
426     /**
427      * Only after crowdsale
428      */
429     modifier only_after_crowdsale() {
430         require(now > crowdsaleEnd);
431         _;
432     }
433 
434 
435     /**
436      * Throw if sender is not beneficiary
437      */
438     modifier only_beneficiary() {
439         require(beneficiary == msg.sender);
440         _;
441     }
442 
443 
444     /**
445      * Start in the deployed stage
446      */
447     function Crowdsale() {
448         stage = Stages.Deploying;
449     }
450 
451 
452     /**
453      * Setup the crowdsale
454      *
455      * @param _start The timestamp of the start date
456      * @param _token The token that is sold
457      * @param _tokenDenominator The token amount of decimals that the token uses
458      * @param _percentageDenominator The percision of percentages
459      * @param _minAmount The min cap for the ICO
460      * @param _maxAmount The max cap for the ICO
461      * @param _minAcceptedAmount The lowest accepted amount during the ICO phase
462      * @param _minAmountPresale The min cap for the presale
463      * @param _maxAmountPresale The max cap for the presale
464      * @param _minAcceptedAmountPresale The lowest accepted amount during the presale phase
465      */
466     function setup(uint _start, address _token, uint _tokenDenominator, uint _percentageDenominator, uint _minAmount, uint _maxAmount, uint _minAcceptedAmount, uint _minAmountPresale, uint _maxAmountPresale, uint _minAcceptedAmountPresale) public only_owner at_stage(Stages.Deploying) {
467         token = IManagedToken(_token);
468         tokenDenominator = _tokenDenominator;
469         percentageDenominator = _percentageDenominator;
470         start = _start;
471         minAmount = _minAmount;
472         maxAmount = _maxAmount;
473         minAcceptedAmount = _minAcceptedAmount;
474         minAmountPresale = _minAmountPresale;
475         maxAmountPresale = _maxAmountPresale;
476         minAcceptedAmountPresale = _minAcceptedAmountPresale;
477     }
478 
479 
480     /**
481      * Setup rates and phases
482      *
483      * @param _baseRate The rate without bonus
484      * @param _phaseRates The rates for each phase
485      * @param _phasePeriods The periods that each phase lasts (first phase is the presale phase)
486      * @param _phaseBonusLockupPeriods The lockup period that each phase lasts
487      * @param _phaseUsesVolumeMultiplier Wheter or not volume bonusses are used in the respective phase
488      */
489     function setupPhases(uint _baseRate, uint[] _phaseRates, uint[] _phasePeriods, uint[] _phaseBonusLockupPeriods, bool[] _phaseUsesVolumeMultiplier) public only_owner at_stage(Stages.Deploying) {
490         baseRate = _baseRate;
491         presaleEnd = start + _phasePeriods[0]; // First phase is expected to be the presale phase
492         crowdsaleEnd = start; // Plus the sum of the rate phases
493 
494         for (uint i = 0; i < _phaseRates.length; i++) {
495             crowdsaleEnd += _phasePeriods[i];
496             phases.push(Phase(_phaseRates[i], crowdsaleEnd, 0, _phaseUsesVolumeMultiplier[i]));
497         }
498 
499         for (uint ii = 0; ii < _phaseRates.length; ii++) {
500             if (_phaseBonusLockupPeriods[ii] > 0) {
501                 phases[ii].bonusReleaseDate = crowdsaleEnd + _phaseBonusLockupPeriods[ii];
502             }
503         }
504     }
505 
506 
507     /**
508      * Setup stakeholders
509      *
510      * @param _stakeholders The addresses of the stakeholders (first stakeholder is the beneficiary)
511      * @param _stakeholderEthPercentages The eth percentages of the stakeholders
512      * @param _stakeholderTokenPercentages The token percentages of the stakeholders
513      * @param _stakeholderTokenPayoutOverwriteReleaseDates Wheter the vesting period is overwritten for the respective stakeholder
514      * @param _stakeholderTokenPayoutFixedReleaseDates The vesting period after which the whole percentage of the tokens is released to the respective stakeholder
515      * @param _stakeholderTokenPayoutPercentages The percentage of the tokens that is released at the respective date
516      * @param _stakeholderTokenPayoutVestingPeriods The vesting period after which the respective percentage of the tokens is released
517      */
518     function setupStakeholders(address[] _stakeholders, uint[] _stakeholderEthPercentages, uint[] _stakeholderTokenPercentages, bool[] _stakeholderTokenPayoutOverwriteReleaseDates, uint[] _stakeholderTokenPayoutFixedReleaseDates, uint[] _stakeholderTokenPayoutPercentages, uint[] _stakeholderTokenPayoutVestingPeriods) public only_owner at_stage(Stages.Deploying) {
519         beneficiary = _stakeholders[0]; // First stakeholder is expected to be the beneficiary
520         for (uint i = 0; i < _stakeholders.length; i++) {
521             stakeholderPercentagesIndex.push(_stakeholders[i]);
522             stakeholderPercentages[_stakeholders[i]] = Percentage(
523                 _stakeholderEthPercentages[i], 
524                 _stakeholderTokenPercentages[i], 
525                 _stakeholderTokenPayoutOverwriteReleaseDates[i],
526                 _stakeholderTokenPayoutFixedReleaseDates[i], i);
527         }
528 
529         // Percentages add up to 100
530         for (uint ii = 0; ii < _stakeholderTokenPayoutPercentages.length; ii++) {
531             stakeholdersPayouts.push(Payout(_stakeholderTokenPayoutPercentages[ii], _stakeholderTokenPayoutVestingPeriods[ii]));
532         }
533     }
534 
535     
536     /**
537      * Setup volume multipliers
538      *
539      * @param _volumeMultiplierRates The rates will be multiplied by this value (denominated by 4)
540      * @param _volumeMultiplierLockupPeriods The lockup periods will be multiplied by this value (denominated by 4)
541      * @param _volumeMultiplierThresholds The volume thresholds for each respective multiplier
542      */
543     function setupVolumeMultipliers(uint[] _volumeMultiplierRates, uint[] _volumeMultiplierLockupPeriods, uint[] _volumeMultiplierThresholds) public only_owner at_stage(Stages.Deploying) {
544         require(phases.length > 0);
545         volumeMultiplierThresholds = _volumeMultiplierThresholds;
546         for (uint i = 0; i < volumeMultiplierThresholds.length; i++) {
547             volumeMultipliers[volumeMultiplierThresholds[i]] = VolumeMultiplier(_volumeMultiplierRates[i], _volumeMultiplierLockupPeriods[i]);
548         }
549     }
550     
551 
552     /**
553      * After calling the deploy function the crowdsale
554      * rules become immutable 
555      */
556     function deploy() public only_owner at_stage(Stages.Deploying) {
557         require(phases.length > 0);
558         require(stakeholderPercentagesIndex.length > 0);
559         stage = Stages.Deployed;
560     }
561 
562 
563     /**
564      * Prove that beneficiary is able to sign transactions 
565      * and start the crowdsale
566      */
567     function confirmBeneficiary() public only_beneficiary at_stage(Stages.Deployed) {
568         stage = Stages.InProgress;
569     }
570 
571 
572     /**
573      * Returns true if the contract is currently in the presale phase
574      *
575      * @return True if in presale phase
576      */
577     function isInPresalePhase() public constant returns (bool) {
578         return stage == Stages.InProgress && now >= start && now <= presaleEnd;
579     }
580 
581 
582     /**
583      * Returns true if `_beneficiary` has a balance allocated
584      *
585      * @param _beneficiary The account that the balance is allocated for
586      * @param _releaseDate The date after which the balance can be withdrawn
587      * @return True if there is a balance that belongs to `_beneficiary`
588      */
589     function hasBalance(address _beneficiary, uint _releaseDate) public constant returns (bool) {
590         return allocatedIndex[_beneficiary].length > 0 && _releaseDate == allocatedIndex[_beneficiary][allocated[_beneficiary][_releaseDate].index];
591     }
592 
593 
594     /** 
595      * Get the allocated token balance of `_owner`
596      * 
597      * @param _owner The address from which the allocated token balance will be retrieved
598      * @return The allocated token balance
599      */
600     function balanceOf(address _owner) public constant returns (uint) {
601         uint sum = 0;
602         for (uint i = 0; i < allocatedIndex[_owner].length; i++) {
603             sum += allocated[_owner][allocatedIndex[_owner][i]].tokens;
604         }
605 
606         return sum;
607     }
608 
609 
610     /** 
611      * Get the allocated eth balance of `_owner`
612      * 
613      * @param _owner The address from which the allocated eth balance will be retrieved
614      * @return The allocated eth balance
615      */
616     function ethBalanceOf(address _owner) public constant returns (uint) {
617         uint sum = 0;
618         for (uint i = 0; i < allocatedIndex[_owner].length; i++) {
619             sum += allocated[_owner][allocatedIndex[_owner][i]].eth;
620         }
621 
622         return sum;
623     }
624 
625 
626     /** 
627      * Get invested and refundable balance of `_owner` (only contributions during the ICO phase are registered)
628      * 
629      * @param _owner The address from which the refundable balance will be retrieved
630      * @return The invested refundable balance
631      */
632     function refundableEthBalanceOf(address _owner) public constant returns (uint) {
633         return now > crowdsaleEnd && raised < minAmount ? balances[_owner] : 0;
634     }
635 
636 
637     /**
638      * Returns the current phase based on the current time
639      *
640      * @return The index of the current phase
641      */
642     function getCurrentPhase() public constant returns (uint) {
643         for (uint i = 0; i < phases.length; i++) {
644             if (now <= phases[i].end) {
645                 return i;
646                 break;
647             }
648         }
649 
650         return phases.length; // Does not exist
651     }
652 
653 
654     /**
655      * Returns the rate and bonus release date
656      *
657      * @param _phase The phase to use while determining the rate
658      * @param _volume The amount wei used to determin what volume multiplier to use
659      * @return The rate used in `_phase` multiplied by the corresponding volume multiplier
660      */
661     function getRate(uint _phase, uint _volume) public constant returns (uint) {
662         uint rate = 0;
663         if (stage == Stages.InProgress && now >= start) {
664             Phase storage phase = phases[_phase];
665             rate = phase.rate;
666 
667             // Find volume multiplier
668             if (phase.useVolumeMultiplier && volumeMultiplierThresholds.length > 0 && _volume >= volumeMultiplierThresholds[0]) {
669                 for (uint i = volumeMultiplierThresholds.length; i > 0; i--) {
670                     if (_volume >= volumeMultiplierThresholds[i - 1]) {
671                         VolumeMultiplier storage multiplier = volumeMultipliers[volumeMultiplierThresholds[i - 1]];
672                         rate += phase.rate * multiplier.rateMultiplier / percentageDenominator;
673                         break;
674                     }
675                 }
676             }
677         }
678         
679         return rate;
680     }
681 
682 
683     /**
684      * Get distribution data based on the current phase and 
685      * the volume in wei that is being distributed
686      * 
687      * @param _phase The current crowdsale phase
688      * @param _volume The amount wei used to determine what volume multiplier to use
689      * @return Volumes and corresponding release dates
690      */
691     function getDistributionData(uint _phase, uint _volume) internal constant returns (uint[], uint[]) {
692         Phase storage phase = phases[_phase];
693         uint remainingVolume = _volume;
694 
695         bool usingMultiplier = false;
696         uint[] memory volumes = new uint[](1);
697         uint[] memory releaseDates = new uint[](1);
698 
699         // Find volume multipliers
700         if (phase.useVolumeMultiplier && volumeMultiplierThresholds.length > 0 && _volume >= volumeMultiplierThresholds[0]) {
701             uint phaseReleasePeriod = phase.bonusReleaseDate - crowdsaleEnd;
702             for (uint i = volumeMultiplierThresholds.length; i > 0; i--) {
703                 if (_volume >= volumeMultiplierThresholds[i - 1]) {
704                     if (!usingMultiplier) {
705                         volumes = new uint[](i + 1);
706                         releaseDates = new uint[](i + 1);
707                         usingMultiplier = true;
708                     }
709 
710                     VolumeMultiplier storage multiplier = volumeMultipliers[volumeMultiplierThresholds[i - 1]];
711                     uint releaseDate = phase.bonusReleaseDate + phaseReleasePeriod * multiplier.bonusReleaseDateMultiplier / percentageDenominator;
712                     uint volume = remainingVolume - volumeMultiplierThresholds[i - 1];
713 
714                     // Store increment
715                     volumes[i] = volume;
716                     releaseDates[i] = releaseDate;
717 
718                     remainingVolume -= volume;
719                 }
720             }
721         }
722 
723         // Store increment
724         volumes[0] = remainingVolume;
725         releaseDates[0] = phase.bonusReleaseDate;
726 
727         return (volumes, releaseDates);
728     }
729 
730 
731     /**
732      * Convert `_wei` to an amount in tokens using 
733      * the `_rate`
734      *
735      * @param _wei amount of wei to convert
736      * @param _rate rate to use for the conversion
737      * @return Amount in tokens
738      */
739     function toTokens(uint _wei, uint _rate) public constant returns (uint) {
740         return _wei * _rate * tokenDenominator / 1 ether;
741     }
742 
743 
744     /**
745      * Function to end the crowdsale by setting 
746      * the stage to Ended
747      */
748     function endCrowdsale() public at_stage(Stages.InProgress) {
749         require(now > crowdsaleEnd || raised >= maxAmount);
750         require(raised >= minAmount);
751         stage = Stages.Ended;
752 
753         // Unlock token
754         if (!token.unlock()) {
755             revert();
756         }
757 
758         // Allocate tokens (no allocation can be done after this period)
759         uint totalTokenSupply = token.totalSupply() + allocatedTokens;
760         for (uint i = 0; i < stakeholdersPayouts.length; i++) {
761             Payout storage p = stakeholdersPayouts[i];
762             _allocateStakeholdersTokens(totalTokenSupply * p.percentage / percentageDenominator, now + p.vestingPeriod);
763         }
764 
765         // Allocate remaining ETH
766         _allocateStakeholdersEth(this.balance - allocatedEth, 0);
767     }
768 
769 
770     /**
771      * Withdraw allocated tokens
772      */
773     function withdrawTokens() public {
774         uint tokensToSend = 0;
775         for (uint i = 0; i < allocatedIndex[msg.sender].length; i++) {
776             uint releaseDate = allocatedIndex[msg.sender][i];
777             if (releaseDate <= now) {
778                 Balance storage b = allocated[msg.sender][releaseDate];
779                 tokensToSend += b.tokens;
780                 b.tokens = 0;
781             }
782         }
783 
784         if (tokensToSend > 0) {
785             allocatedTokens -= tokensToSend;
786             if (!token.issue(msg.sender, tokensToSend)) {
787                 revert();
788             }
789         }
790     }
791 
792 
793     /**
794      * Withdraw allocated ether
795      */
796     function withdrawEther() public {
797         uint ethToSend = 0;
798         for (uint i = 0; i < allocatedIndex[msg.sender].length; i++) {
799             uint releaseDate = allocatedIndex[msg.sender][i];
800             if (releaseDate <= now) {
801                 Balance storage b = allocated[msg.sender][releaseDate];
802                 ethToSend += b.eth;
803                 b.eth = 0;
804             }
805         }
806 
807         if (ethToSend > 0) {
808             allocatedEth -= ethToSend;
809             if (!msg.sender.send(ethToSend)) {
810                 revert();
811             }
812         }
813     }
814 
815 
816     /**
817      * Refund in the case of an unsuccessful crowdsale. The 
818      * crowdsale is considered unsuccessful if minAmount was 
819      * not raised before end of the crowdsale
820      */
821     function refund() public only_after_crowdsale at_stage(Stages.InProgress) {
822         require(raised < minAmount);
823 
824         uint receivedAmount = balances[msg.sender];
825         balances[msg.sender] = 0;
826 
827         if (receivedAmount > 0 && !msg.sender.send(receivedAmount)) {
828             balances[msg.sender] = receivedAmount;
829         }
830     }
831 
832 
833     /**
834      * Failsafe and clean-up mechanism
835      */
836     function destroy() public only_beneficiary only_after(2 years) {
837         selfdestruct(beneficiary);
838     }
839 
840 
841     /**
842      * Receive Eth and issue tokens to the sender
843      */
844     function contribute() public payable {
845         _handleTransaction(msg.sender, msg.value);
846     }
847 
848 
849     /**
850      * Receive Eth and issue tokens to the sender
851      * 
852      * This function requires that msg.sender is not a contract. This is required because it's 
853      * not possible for a contract to specify a gas amount when calling the (internal) send() 
854      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
855      * 
856      * Contracts can call the contribute() function instead
857      */
858     function () payable {
859         require(msg.sender == tx.origin);
860         _handleTransaction(msg.sender, msg.value);
861     }
862 
863 
864     /**
865      * Handle incoming transactions
866      * 
867      * @param _sender Transaction sender
868      * @param _received 
869      */
870     function _handleTransaction(address _sender, uint _received) internal at_stage(Stages.InProgress) {
871 
872         // Crowdsale is active
873         require(now >= start && now <= crowdsaleEnd);
874 
875         // Whitelist check
876         require(isAcceptedContributor(_sender));
877 
878         // When in presale phase
879         bool presalePhase = isInPresalePhase();
880         require(!presalePhase || _received >= minAcceptedAmountPresale);
881         require(!presalePhase || raised < maxAmountPresale);
882 
883         // When in ico phase
884         require(presalePhase || _received >= minAcceptedAmount);
885         require(presalePhase || raised >= minAmountPresale);
886         require(presalePhase || raised < maxAmount);
887 
888         uint acceptedAmount;
889         if (presalePhase && raised + _received > maxAmountPresale) {
890             acceptedAmount = maxAmountPresale - raised;
891         } else if (raised + _received > maxAmount) {
892             acceptedAmount = maxAmount - raised;
893         } else {
894             acceptedAmount = _received;
895         }
896 
897         raised += acceptedAmount;
898         
899         if (presalePhase) {
900             // During the presale phase - Non refundable
901             _allocateStakeholdersEth(acceptedAmount, 0); 
902         } else {
903             // During the ICO phase - 100% refundable
904             balances[_sender] += acceptedAmount; 
905         }
906 
907         // Distribute tokens
908         uint tokensToIssue = 0;
909         uint phase = getCurrentPhase();
910         var rate = getRate(phase, acceptedAmount);
911         if (rate == 0) {
912             revert(); // Paused phase
913         }
914 
915         var (volumes, releaseDates) = getDistributionData(
916             phase, acceptedAmount);
917         
918         // Allocate tokens
919         for (uint i = 0; i < volumes.length; i++) {
920             var tokensAtCurrentRate = toTokens(volumes[i], rate);
921             if (rate > baseRate && releaseDates[i] > now) {
922                 uint bonusTokens = tokensAtCurrentRate * (rate - baseRate) / rate;
923                 _allocateTokens(_sender, bonusTokens, releaseDates[i]);
924 
925                 tokensToIssue += tokensAtCurrentRate - bonusTokens;
926             } else {
927                 tokensToIssue += tokensAtCurrentRate;
928             }
929         }
930 
931         // Issue tokens
932         if (tokensToIssue > 0 && !token.issue(_sender, tokensToIssue)) {
933             revert();
934         }
935 
936         // Refund due to max cap hit
937         if (_received - acceptedAmount > 0 && !_sender.send(_received - acceptedAmount)) {
938             revert();
939         }
940     }
941 
942 
943     /**
944      * Allocate ETH
945      *
946      * @param _beneficiary The account to alocate the eth for
947      * @param _amount The amount of ETH to allocate
948      * @param _releaseDate The date after which the eth can be withdrawn
949      */    
950     function _allocateEth(address _beneficiary, uint _amount, uint _releaseDate) internal {
951         if (hasBalance(_beneficiary, _releaseDate)) {
952             allocated[_beneficiary][_releaseDate].eth += _amount;
953         } else {
954             allocated[_beneficiary][_releaseDate] = Balance(
955                 _amount, 0, allocatedIndex[_beneficiary].push(_releaseDate) - 1);
956         }
957 
958         allocatedEth += _amount;
959     }
960 
961 
962     /**
963      * Allocate Tokens
964      *
965      * @param _beneficiary The account to allocate the tokens for
966      * @param _amount The amount of tokens to allocate
967      * @param _releaseDate The date after which the tokens can be withdrawn
968      */    
969     function _allocateTokens(address _beneficiary, uint _amount, uint _releaseDate) internal {
970         if (hasBalance(_beneficiary, _releaseDate)) {
971             allocated[_beneficiary][_releaseDate].tokens += _amount;
972         } else {
973             allocated[_beneficiary][_releaseDate] = Balance(
974                 0, _amount, allocatedIndex[_beneficiary].push(_releaseDate) - 1);
975         }
976 
977         allocatedTokens += _amount;
978     }
979 
980 
981     /**
982      * Allocate ETH for stakeholders
983      *
984      * @param _amount The amount of ETH to allocate
985      * @param _releaseDate The date after which the eth can be withdrawn
986      */    
987     function _allocateStakeholdersEth(uint _amount, uint _releaseDate) internal {
988         for (uint i = 0; i < stakeholderPercentagesIndex.length; i++) {
989             Percentage storage p = stakeholderPercentages[stakeholderPercentagesIndex[i]];
990             if (p.eth > 0) {
991                 _allocateEth(stakeholderPercentagesIndex[i], _amount * p.eth / percentageDenominator, _releaseDate);
992             }
993         }
994     }
995 
996 
997     /**
998      * Allocate Tokens for stakeholders
999      *
1000      * @param _amount The amount of tokens created
1001      * @param _releaseDate The date after which the tokens can be withdrawn (unless overwitten)
1002      */    
1003     function _allocateStakeholdersTokens(uint _amount, uint _releaseDate) internal {
1004         for (uint i = 0; i < stakeholderPercentagesIndex.length; i++) {
1005             Percentage storage p = stakeholderPercentages[stakeholderPercentagesIndex[i]];
1006             if (p.tokens > 0) {
1007                 _allocateTokens(
1008                     stakeholderPercentagesIndex[i], 
1009                     _amount * p.tokens / percentageDenominator, 
1010                     p.overwriteReleaseDate ? p.fixedReleaseDate : _releaseDate);
1011             }
1012         }
1013     }
1014 
1015 
1016     /**
1017      * Allows the implementing contract to validate a 
1018      * contributing account
1019      *
1020      * @param _contributor Address that is being validated
1021      * @return Wheter the contributor is accepted or not
1022      */
1023     function isAcceptedContributor(address _contributor) internal constant returns (bool);
1024 }
1025 
1026 
1027 /**
1028  * @title GLACrowdsale
1029  *
1030  * Gladius is the decentralized solution to protect against DDoS attacks by allowing you to connect 
1031  * with protection pools near you to provide better protection and accelerate your content. With an easy 
1032  * to use interface as well as powerful insight tools, Gladius enables anyone to protect and accelerate 
1033  * their website. Visit https://gladius.io/ 
1034  *
1035  * #created 29/09/2017
1036  * #author Frank Bonnet
1037  */
1038 contract GLACrowdsale is Crowdsale, ITokenRetreiver, IWingsAdapter {
1039 
1040     // Whitelist used for authentication
1041     IWhitelist private whitelist;
1042 
1043     // Presale
1044     bool private presaleAttached;
1045     IToken private presaleToken;
1046     ICrowdsale private presale;
1047     mapping(address => bool) private presaleConversions;
1048 
1049 
1050     /**
1051      * Setup the whitelist
1052      *
1053      * @param _whitelist The address of the whitelist authenticator
1054      */
1055     function setupWhitelist(address _whitelist) public only_owner at_stage(Stages.Deploying) {
1056         whitelist = IWhitelist(_whitelist);
1057     }
1058 
1059 
1060     /**
1061      * Wings integration - Get the total raised amount of Ether
1062      *
1063      * Can only increased, means if you withdraw ETH from the wallet, should be not modified (you can use two fields 
1064      * to keep one with a total accumulated amount) amount of ETH in contract and totalCollected for total amount of ETH collected
1065      *
1066      * @return Total raised Ether amount
1067      */
1068     function totalCollected() public constant returns (uint) {
1069         return raised;
1070     }
1071 
1072 
1073     /**
1074      * Allows the implementing contract to validate a 
1075      * contributing account
1076      *
1077      * @param _contributor Address that is being validated
1078      * @return Wheter the contributor is accepted or not
1079      */
1080     function isAcceptedContributor(address _contributor) internal constant returns (bool) {
1081         return whitelist.authenticate(_contributor);
1082     }
1083 
1084 
1085     /**
1086      * Attach the presale contracts
1087      *
1088      * @param _presale The address of the private presale contract
1089      * @param _presaleToken The token used in the private presale 
1090      */
1091     function attachPresale(address _presale, address _presaleToken) public only_owner at_stage(Stages.Deploying) {
1092         presaleToken = IToken(_presaleToken);
1093         presale = ICrowdsale(_presale);
1094         presaleAttached = true;
1095     }
1096 
1097 
1098     /**
1099      * Allow investors that contributed in the private presale 
1100      * to generate the same amount of tokens in the actual crowdsale
1101      *
1102      * @param _contributor Account that contributed in the presale
1103      */
1104     function importPresaleContribution(address _contributor) public {
1105         require(presaleAttached);
1106         require(!presaleConversions[_contributor]);
1107         presaleConversions[_contributor] = true;
1108 
1109         // Read amounts from private presale
1110         uint distributedPresaleTokens = presaleToken.balanceOf(_contributor);
1111 
1112         // If this is zero _contributor did not contribute anything
1113         require(distributedPresaleTokens > 0);
1114         
1115         // Allocate tokens
1116         uint allocatedPresaleTokens = presale.balanceOf(_contributor);
1117         _allocateTokens(_contributor, allocatedPresaleTokens, crowdsaleEnd + 30 days);
1118 
1119         // Issue tokens
1120         if (!token.issue(_contributor, distributedPresaleTokens)) {
1121             revert();
1122         }
1123     }
1124 
1125 
1126     /**
1127      * Failsafe mechanism
1128      * 
1129      * Allows beneficary to retreive tokens from the contract
1130      *
1131      * @param _tokenContract The address of ERC20 compatible token
1132      */
1133     function retreiveTokens(address _tokenContract) public only_beneficiary {
1134         IToken tokenInstance = IToken(_tokenContract);
1135 
1136         // Retreive tokens from our token contract
1137         ITokenRetreiver(token).retreiveTokens(_tokenContract);
1138 
1139         // Retreive tokens from crowdsale contract
1140         uint tokenBalance = tokenInstance.balanceOf(this);
1141         if (tokenBalance > 0) {
1142             tokenInstance.transfer(beneficiary, tokenBalance);
1143         }
1144     }
1145 }