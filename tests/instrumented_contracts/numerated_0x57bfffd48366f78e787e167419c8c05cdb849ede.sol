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
379     Stages public stage = Stages.Deploying;
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
445      * Allows the implementing contract to validate a 
446      * contributing account
447      *
448      * @param _contributor Address that is being validated
449      * @return Wheter the contributor is accepted or not
450      */
451     function isAcceptedContributor(address _contributor) internal constant returns (bool);
452 
453 
454     /**
455      * Setup the crowdsale
456      *
457      * @param _start The timestamp of the start date
458      * @param _token The token that is sold
459      * @param _tokenDenominator The token amount of decimals that the token uses
460      * @param _percentageDenominator The percision of percentages
461      * @param _minAmount The min cap for the ICO
462      * @param _maxAmount The max cap for the ICO
463      * @param _minAcceptedAmount The lowest accepted amount during the ICO phase
464      * @param _minAmountPresale The min cap for the presale
465      * @param _maxAmountPresale The max cap for the presale
466      * @param _minAcceptedAmountPresale The lowest accepted amount during the presale phase
467      */
468     function Crowdsale(uint _start, address _token, uint _tokenDenominator, uint _percentageDenominator, uint _minAmount, uint _maxAmount, uint _minAcceptedAmount, uint _minAmountPresale, uint _maxAmountPresale, uint _minAcceptedAmountPresale) {
469         token = IManagedToken(_token);
470         tokenDenominator = _tokenDenominator;
471         percentageDenominator = _percentageDenominator;
472         start = _start;
473         minAmount = _minAmount;
474         maxAmount = _maxAmount;
475         minAcceptedAmount = _minAcceptedAmount;
476         minAmountPresale = _minAmountPresale;
477         maxAmountPresale = _maxAmountPresale;
478         minAcceptedAmountPresale = _minAcceptedAmountPresale;
479     }
480 
481 
482     /**
483      * Setup rates and phases
484      *
485      * @param _baseRate The rate without bonus
486      * @param _phaseRates The rates for each phase
487      * @param _phasePeriods The periods that each phase lasts (first phase is the presale phase)
488      * @param _phaseBonusLockupPeriods The lockup period that each phase lasts
489      * @param _phaseUsesVolumeMultiplier Wheter or not volume bonusses are used in the respective phase
490      */
491     function setupPhases(uint _baseRate, uint[] _phaseRates, uint[] _phasePeriods, uint[] _phaseBonusLockupPeriods, bool[] _phaseUsesVolumeMultiplier) public only_owner at_stage(Stages.Deploying) {
492         baseRate = _baseRate;
493         presaleEnd = start + _phasePeriods[0]; // First phase is expected to be the presale phase
494         crowdsaleEnd = start; // Plus the sum of the rate phases
495 
496         for (uint i = 0; i < _phaseRates.length; i++) {
497             crowdsaleEnd += _phasePeriods[i];
498             phases.push(Phase(_phaseRates[i], crowdsaleEnd, 0, _phaseUsesVolumeMultiplier[i]));
499         }
500 
501         for (uint ii = 0; ii < _phaseRates.length; ii++) {
502             if (_phaseBonusLockupPeriods[ii] > 0) {
503                 phases[ii].bonusReleaseDate = crowdsaleEnd + _phaseBonusLockupPeriods[ii];
504             }
505         }
506     }
507 
508 
509     /**
510      * Setup stakeholders
511      *
512      * @param _stakeholders The addresses of the stakeholders (first stakeholder is the beneficiary)
513      * @param _stakeholderEthPercentages The eth percentages of the stakeholders
514      * @param _stakeholderTokenPercentages The token percentages of the stakeholders
515      * @param _stakeholderTokenPayoutOverwriteReleaseDates Wheter the vesting period is overwritten for the respective stakeholder
516      * @param _stakeholderTokenPayoutFixedReleaseDates The vesting period after which the whole percentage of the tokens is released to the respective stakeholder
517      * @param _stakeholderTokenPayoutPercentages The percentage of the tokens that is released at the respective date
518      * @param _stakeholderTokenPayoutVestingPeriods The vesting period after which the respective percentage of the tokens is released
519      */
520     function setupStakeholders(address[] _stakeholders, uint[] _stakeholderEthPercentages, uint[] _stakeholderTokenPercentages, bool[] _stakeholderTokenPayoutOverwriteReleaseDates, uint[] _stakeholderTokenPayoutFixedReleaseDates, uint[] _stakeholderTokenPayoutPercentages, uint[] _stakeholderTokenPayoutVestingPeriods) public only_owner at_stage(Stages.Deploying) {
521         beneficiary = _stakeholders[0]; // First stakeholder is expected to be the beneficiary
522         for (uint i = 0; i < _stakeholders.length; i++) {
523             stakeholderPercentagesIndex.push(_stakeholders[i]);
524             stakeholderPercentages[_stakeholders[i]] = Percentage(
525                 _stakeholderEthPercentages[i], 
526                 _stakeholderTokenPercentages[i], 
527                 _stakeholderTokenPayoutOverwriteReleaseDates[i],
528                 _stakeholderTokenPayoutFixedReleaseDates[i], i);
529         }
530 
531         // Percentages add up to 100
532         for (uint ii = 0; ii < _stakeholderTokenPayoutPercentages.length; ii++) {
533             stakeholdersPayouts.push(Payout(_stakeholderTokenPayoutPercentages[ii], _stakeholderTokenPayoutVestingPeriods[ii]));
534         }
535     }
536 
537     
538     /**
539      * Setup volume multipliers
540      *
541      * @param _volumeMultiplierRates The rates will be multiplied by this value (denominated by 4)
542      * @param _volumeMultiplierLockupPeriods The lockup periods will be multiplied by this value (denominated by 4)
543      * @param _volumeMultiplierThresholds The volume thresholds for each respective multiplier
544      */
545     function setupVolumeMultipliers(uint[] _volumeMultiplierRates, uint[] _volumeMultiplierLockupPeriods, uint[] _volumeMultiplierThresholds) public only_owner at_stage(Stages.Deploying) {
546         require(phases.length > 0);
547         volumeMultiplierThresholds = _volumeMultiplierThresholds;
548         for (uint i = 0; i < volumeMultiplierThresholds.length; i++) {
549             volumeMultipliers[volumeMultiplierThresholds[i]] = VolumeMultiplier(_volumeMultiplierRates[i], _volumeMultiplierLockupPeriods[i]);
550         }
551     }
552     
553 
554     /**
555      * After calling the deploy function the crowdsale
556      * rules become immutable 
557      */
558     function deploy() public only_owner at_stage(Stages.Deploying) {
559         require(phases.length > 0);
560         require(stakeholderPercentagesIndex.length > 0);
561         stage = Stages.Deployed;
562     }
563 
564 
565     /**
566      * Prove that beneficiary is able to sign transactions 
567      * and start the crowdsale
568      */
569     function confirmBeneficiary() public only_beneficiary at_stage(Stages.Deployed) {
570         stage = Stages.InProgress;
571     }
572 
573 
574     /**
575      * Returns true if the contract is currently in the presale phase
576      *
577      * @return True if in presale phase
578      */
579     function isInPresalePhase() public constant returns (bool) {
580         return stage == Stages.InProgress && now >= start && now <= presaleEnd;
581     }
582 
583 
584     /**
585      * Returns true if `_beneficiary` has a balance allocated
586      *
587      * @param _beneficiary The account that the balance is allocated for
588      * @param _releaseDate The date after which the balance can be withdrawn
589      * @return True if there is a balance that belongs to `_beneficiary`
590      */
591     function hasBalance(address _beneficiary, uint _releaseDate) public constant returns (bool) {
592         return allocatedIndex[_beneficiary].length > 0 && _releaseDate == allocatedIndex[_beneficiary][allocated[_beneficiary][_releaseDate].index];
593     }
594 
595 
596     /** 
597      * Get the allocated token balance of `_owner`
598      * 
599      * @param _owner The address from which the allocated token balance will be retrieved
600      * @return The allocated token balance
601      */
602     function balanceOf(address _owner) public constant returns (uint) {
603         uint sum = 0;
604         for (uint i = 0; i < allocatedIndex[_owner].length; i++) {
605             sum += allocated[_owner][allocatedIndex[_owner][i]].tokens;
606         }
607 
608         return sum;
609     }
610 
611 
612     /** 
613      * Get the allocated eth balance of `_owner`
614      * 
615      * @param _owner The address from which the allocated eth balance will be retrieved
616      * @return The allocated eth balance
617      */
618     function ethBalanceOf(address _owner) public constant returns (uint) {
619         uint sum = 0;
620         for (uint i = 0; i < allocatedIndex[_owner].length; i++) {
621             sum += allocated[_owner][allocatedIndex[_owner][i]].eth;
622         }
623 
624         return sum;
625     }
626 
627 
628     /** 
629      * Get invested and refundable balance of `_owner` (only contributions during the ICO phase are registered)
630      * 
631      * @param _owner The address from which the refundable balance will be retrieved
632      * @return The invested refundable balance
633      */
634     function refundableEthBalanceOf(address _owner) public constant returns (uint) {
635         return now > crowdsaleEnd && raised < minAmount ? balances[_owner] : 0;
636     }
637 
638 
639     /**
640      * Returns the current phase based on the current time
641      *
642      * @return The index of the current phase
643      */
644     function getCurrentPhase() public constant returns (uint found) {
645         for (uint i = 0; i < phases.length; i++) {
646             if (now <= phases[i].end) {
647                 return i;
648                 break;
649             }
650         }
651 
652         return phases.length; // Does not exist
653     }
654 
655 
656     /**
657      * Returns the rate and bonus release date
658      *
659      * @param _phase The phase to use while determining the rate
660      * @param _volume The amount wei used to determin what volume multiplier to use
661      * @return The rate used in `_phase` multiplied by the corresponding volume multiplier
662      */
663     function getRate(uint _phase, uint _volume) public constant returns (uint) {
664         uint rate = 0;
665         if (stage == Stages.InProgress && now >= start) {
666             Phase storage phase = phases[_phase];
667             rate = phase.rate;
668 
669             // Find volume multiplier
670             if (phase.useVolumeMultiplier && volumeMultiplierThresholds.length > 0 && _volume >= volumeMultiplierThresholds[0]) {
671                 for (uint i = volumeMultiplierThresholds.length; i > 0; i--) {
672                     if (_volume >= volumeMultiplierThresholds[i - 1]) {
673                         VolumeMultiplier storage multiplier = volumeMultipliers[volumeMultiplierThresholds[i - 1]];
674                         rate += phase.rate * multiplier.rateMultiplier / percentageDenominator;
675                         break;
676                     }
677                 }
678             }
679         }
680         
681         return rate;
682     }
683 
684 
685     /**
686      * Get distribution data based on the current phase and 
687      * the volume in wei that is being distributed
688      * 
689      * @param _phase The current crowdsale phase
690      * @param _volume The amount wei used to determine what volume multiplier to use
691      * @return Volumes and corresponding release dates
692      */
693     function getDistributionData(uint _phase, uint _volume) internal constant returns (uint[], uint[]) {
694         Phase storage phase = phases[_phase];
695         uint remainingVolume = _volume;
696 
697         bool usingMultiplier = false;
698         uint[] memory volumes = new uint[](1);
699         uint[] memory releaseDates = new uint[](1);
700 
701         // Find volume multipliers
702         if (phase.useVolumeMultiplier && volumeMultiplierThresholds.length > 0 && _volume >= volumeMultiplierThresholds[0]) {
703             uint phaseReleasePeriod = phase.bonusReleaseDate - crowdsaleEnd;
704             for (uint i = volumeMultiplierThresholds.length; i > 0; i--) {
705                 if (_volume >= volumeMultiplierThresholds[i - 1]) {
706                     if (!usingMultiplier) {
707                         volumes = new uint[](i + 1);
708                         releaseDates = new uint[](i + 1);
709                         usingMultiplier = true;
710                     }
711 
712                     VolumeMultiplier storage multiplier = volumeMultipliers[volumeMultiplierThresholds[i - 1]];
713                     uint releaseDate = phase.bonusReleaseDate + phaseReleasePeriod * multiplier.bonusReleaseDateMultiplier / percentageDenominator;
714                     uint volume = remainingVolume - volumeMultiplierThresholds[i - 1];
715 
716                     // Store increment
717                     volumes[i] = volume;
718                     releaseDates[i] = releaseDate;
719 
720                     remainingVolume -= volume;
721                 }
722             }
723         }
724 
725         // Store increment
726         volumes[0] = remainingVolume;
727         releaseDates[0] = phase.bonusReleaseDate;
728 
729         return (volumes, releaseDates);
730     }
731 
732 
733     /**
734      * Convert `_wei` to an amount in tokens using 
735      * the `_rate`
736      *
737      * @param _wei amount of wei to convert
738      * @param _rate rate to use for the conversion
739      * @return Amount in tokens
740      */
741     function toTokens(uint _wei, uint _rate) public constant returns (uint) {
742         return _wei * _rate * tokenDenominator / 1 ether;
743     }
744 
745 
746     /**
747      * Function to end the crowdsale by setting 
748      * the stage to Ended
749      */
750     function endCrowdsale() public at_stage(Stages.InProgress) {
751         require(now > crowdsaleEnd || raised >= maxAmount);
752         require(raised >= minAmount);
753         stage = Stages.Ended;
754 
755         // Unlock token
756         if (!token.unlock()) {
757             revert();
758         }
759 
760         // Allocate tokens (no allocation can be done after this period)
761         uint totalTokenSupply = token.totalSupply() + allocatedTokens;
762         for (uint i = 0; i < stakeholdersPayouts.length; i++) {
763             Payout storage p = stakeholdersPayouts[i];
764             _allocateStakeholdersTokens(totalTokenSupply * p.percentage / percentageDenominator, now + p.vestingPeriod);
765         }
766 
767         // Allocate remaining ETH
768         _allocateStakeholdersEth(this.balance - allocatedEth, 0);
769     }
770 
771 
772     /**
773      * Withdraw allocated tokens
774      */
775     function withdrawTokens() public {
776         uint tokensToSend = 0;
777         for (uint i = 0; i < allocatedIndex[msg.sender].length; i++) {
778             uint releaseDate = allocatedIndex[msg.sender][i];
779             if (releaseDate <= now) {
780                 Balance storage b = allocated[msg.sender][releaseDate];
781                 tokensToSend += b.tokens;
782                 b.tokens = 0;
783             }
784         }
785 
786         if (tokensToSend > 0) {
787             allocatedTokens -= tokensToSend;
788             if (!token.issue(msg.sender, tokensToSend)) {
789                 revert();
790             }
791         }
792     }
793 
794 
795     /**
796      * Withdraw allocated ether
797      */
798     function withdrawEther() public {
799         uint ethToSend = 0;
800         for (uint i = 0; i < allocatedIndex[msg.sender].length; i++) {
801             uint releaseDate = allocatedIndex[msg.sender][i];
802             if (releaseDate <= now) {
803                 Balance storage b = allocated[msg.sender][releaseDate];
804                 ethToSend += b.eth;
805                 b.eth = 0;
806             }
807         }
808 
809         if (ethToSend > 0) {
810             allocatedEth -= ethToSend;
811             if (!msg.sender.send(ethToSend)) {
812                 revert();
813             }
814         }
815     }
816 
817 
818     /**
819      * Refund in the case of an unsuccessful crowdsale. The 
820      * crowdsale is considered unsuccessful if minAmount was 
821      * not raised before end of the crowdsale
822      */
823     function refund() public only_after_crowdsale at_stage(Stages.InProgress) {
824         require(raised < minAmount);
825 
826         uint receivedAmount = balances[msg.sender];
827         balances[msg.sender] = 0;
828 
829         if (receivedAmount > 0 && !msg.sender.send(receivedAmount)) {
830             balances[msg.sender] = receivedAmount;
831         }
832     }
833 
834 
835     /**
836      * Failsafe and clean-up mechanism
837      */
838     function destroy() public only_beneficiary only_after(2 years) {
839         selfdestruct(beneficiary);
840     }
841 
842 
843     /**
844      * Receive Eth and issue tokens to the sender
845      */
846     function contribute() public payable {
847         _handleTransaction(msg.sender, msg.value);
848     }
849 
850 
851     /**
852      * Receive Eth and issue tokens to the sender
853      * 
854      * This function requires that msg.sender is not a contract. This is required because it's 
855      * not possible for a contract to specify a gas amount when calling the (internal) send() 
856      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
857      * 
858      * Contracts can call the contribute() function instead
859      */
860     function () payable {
861         require(msg.sender == tx.origin);
862         _handleTransaction(msg.sender, msg.value);
863     }
864 
865 
866     /**
867      * Handle incoming transactions
868      * 
869      * @param _sender Transaction sender
870      * @param _received 
871      */
872     function _handleTransaction(address _sender, uint _received) private at_stage(Stages.InProgress) {
873 
874         // Crowdsale is active
875         require(now >= start && now <= crowdsaleEnd);
876 
877         // Whitelist check
878         require(isAcceptedContributor(_sender));
879 
880         // When in presale phase
881         bool presalePhase = isInPresalePhase();
882         require(!presalePhase || _received >= minAcceptedAmountPresale);
883         require(!presalePhase || raised < maxAmountPresale);
884 
885         // When in ico phase
886         require(presalePhase || _received >= minAcceptedAmount);
887         require(presalePhase || raised >= minAmountPresale);
888         require(presalePhase || raised < maxAmount);
889 
890         uint acceptedAmount;
891         if (presalePhase && raised + _received > maxAmountPresale) {
892             acceptedAmount = maxAmountPresale - raised;
893         } else if (raised + _received > maxAmount) {
894             acceptedAmount = maxAmount - raised;
895         } else {
896             acceptedAmount = _received;
897         }
898 
899         raised += acceptedAmount;
900         
901         if (presalePhase) {
902             // During the presale phase - Non refundable
903             _allocateStakeholdersEth(acceptedAmount, 0); 
904         } else {
905             // During the ICO phase - 100% refundable
906             balances[_sender] += acceptedAmount; 
907         }
908 
909         // Distribute tokens
910         uint tokensToIssue = 0;
911         uint phase = getCurrentPhase();
912         var rate = getRate(phase, acceptedAmount);
913         var (volumes, releaseDates) = getDistributionData(phase, acceptedAmount);
914         
915         // Allocate tokens
916         for (uint i = 0; i < volumes.length; i++) {
917             var tokensAtCurrentRate = toTokens(volumes[i], rate);
918             if (rate > baseRate && releaseDates[i] > now) {
919                 uint bonusTokens = tokensAtCurrentRate / rate * (rate - baseRate);
920                 _allocateTokens(_sender, bonusTokens, releaseDates[i]);
921 
922                 tokensToIssue += tokensAtCurrentRate - bonusTokens;
923             } else {
924                 tokensToIssue += tokensAtCurrentRate;
925             }
926         }
927 
928         // Issue tokens
929         if (tokensToIssue > 0 && !token.issue(_sender, tokensToIssue)) {
930             revert();
931         }
932 
933         // Refund due to max cap hit
934         if (_received - acceptedAmount > 0 && !_sender.send(_received - acceptedAmount)) {
935             revert();
936         }
937     }
938 
939 
940     /**
941      * Allocate ETH
942      *
943      * @param _beneficiary The account to alocate the eth for
944      * @param _amount The amount of ETH to allocate
945      * @param _releaseDate The date after which the eth can be withdrawn
946      */    
947     function _allocateEth(address _beneficiary, uint _amount, uint _releaseDate) private {
948         if (hasBalance(_beneficiary, _releaseDate)) {
949             allocated[_beneficiary][_releaseDate].eth += _amount;
950         } else {
951             allocated[_beneficiary][_releaseDate] = Balance(
952                 _amount, 0, allocatedIndex[_beneficiary].push(_releaseDate) - 1);
953         }
954 
955         allocatedEth += _amount;
956     }
957 
958 
959     /**
960      * Allocate Tokens
961      *
962      * @param _beneficiary The account to allocate the tokens for
963      * @param _amount The amount of tokens to allocate
964      * @param _releaseDate The date after which the tokens can be withdrawn
965      */    
966     function _allocateTokens(address _beneficiary, uint _amount, uint _releaseDate) private {
967         if (hasBalance(_beneficiary, _releaseDate)) {
968             allocated[_beneficiary][_releaseDate].tokens += _amount;
969         } else {
970             allocated[_beneficiary][_releaseDate] = Balance(
971                 0, _amount, allocatedIndex[_beneficiary].push(_releaseDate) - 1);
972         }
973 
974         allocatedTokens += _amount;
975     }
976 
977 
978     /**
979      * Allocate ETH for stakeholders
980      *
981      * @param _amount The amount of ETH to allocate
982      * @param _releaseDate The date after which the eth can be withdrawn
983      */    
984     function _allocateStakeholdersEth(uint _amount, uint _releaseDate) private {
985         for (uint i = 0; i < stakeholderPercentagesIndex.length; i++) {
986             Percentage storage p = stakeholderPercentages[stakeholderPercentagesIndex[i]];
987             if (p.eth > 0) {
988                 _allocateEth(stakeholderPercentagesIndex[i], _amount * p.eth / percentageDenominator, _releaseDate);
989             }
990         }
991     }
992 
993 
994     /**
995      * Allocate Tokens for stakeholders
996      *
997      * @param _amount The amount of tokens created
998      * @param _releaseDate The date after which the tokens can be withdrawn (unless overwitten)
999      */    
1000     function _allocateStakeholdersTokens(uint _amount, uint _releaseDate) private {
1001         for (uint i = 0; i < stakeholderPercentagesIndex.length; i++) {
1002             Percentage storage p = stakeholderPercentages[stakeholderPercentagesIndex[i]];
1003             if (p.tokens > 0) {
1004                 _allocateTokens(
1005                     stakeholderPercentagesIndex[i], 
1006                     _amount * p.tokens / percentageDenominator, 
1007                     p.overwriteReleaseDate ? p.fixedReleaseDate : _releaseDate);
1008             }
1009         }
1010     }
1011 }
1012 
1013 
1014 /**
1015  * @title GLACrowdsale
1016  *
1017  * Gladius is the decentralized solution to protect against DDoS attacks by allowing you to connect 
1018  * with protection pools near you to provide better protection and accelerate your content. With an easy 
1019  * to use interface as well as powerful insight tools, Gladius enables anyone to protect and accelerate 
1020  * their website. Visit https://gladius.io/ 
1021  *
1022  * #created 29/09/2017
1023  * #author Frank Bonnet
1024  */
1025 contract GLACrowdsale is Crowdsale, ITokenRetreiver, IWingsAdapter {
1026 
1027     /**
1028      * Whitelist used for authentication
1029      */
1030     IWhitelist private whitelist;
1031 
1032 
1033     /**
1034      * Setup the crowdsale
1035      *
1036      * @param _whitelist The address of the whitelist authenticator
1037      * @param _start The timestamp of the start date
1038      * @param _token The token that is sold
1039      * @param _tokenDenominator The token amount of decimals that the token uses
1040      * @param _percentageDenominator The precision of percentages
1041      * @param _minAmount The min cap for the ICO
1042      * @param _maxAmount The max cap for the ICO
1043      * @param _minAcceptedAmount The lowest accepted amount during the ICO phase
1044      * @param _minAmountPresale The min cap for the presale
1045      * @param _maxAmountPresale The max cap for the presale
1046      * @param _minAcceptedAmountPresale The lowest accepted amount during the presale phase
1047      */
1048     function GLACrowdsale(address _whitelist, uint _start, address _token, uint _tokenDenominator, uint _percentageDenominator, uint _minAmount, uint _maxAmount, uint _minAcceptedAmount, uint _minAmountPresale, uint _maxAmountPresale, uint _minAcceptedAmountPresale) 
1049         Crowdsale(_start, _token, _tokenDenominator, _percentageDenominator, _minAmount, _maxAmount, _minAcceptedAmount, _minAmountPresale, _maxAmountPresale, _minAcceptedAmountPresale) {
1050         whitelist = IWhitelist(_whitelist);
1051     }
1052 
1053 
1054     /**
1055      * Wings integration - Get the total raised amount of Ether
1056      *
1057      * Can only increased, means if you withdraw ETH from the wallet, should be not modified (you can use two fields 
1058      * to keep one with a total accumulated amount) amount of ETH in contract and totalCollected for total amount of ETH collected
1059      *
1060      * @return Total raised Ether amount
1061      */
1062     function totalCollected() public constant returns (uint) {
1063         return raised;
1064     }
1065 
1066 
1067     /**
1068      * Allows the implementing contract to validate a 
1069      * contributing account
1070      *
1071      * @param _contributor Address that is being validated
1072      * @return Wheter the contributor is accepted or not
1073      */
1074     function isAcceptedContributor(address _contributor) internal constant returns (bool) {
1075         return whitelist.authenticate(_contributor);
1076     }
1077 
1078 
1079     /**
1080      * Failsafe mechanism
1081      * 
1082      * Allows beneficary to retreive tokens from the contract
1083      *
1084      * @param _tokenContract The address of ERC20 compatible token
1085      */
1086     function retreiveTokens(address _tokenContract) public only_beneficiary {
1087         IToken tokenInstance = IToken(_tokenContract);
1088 
1089         // Retreive tokens from our token contract
1090         ITokenRetreiver(token).retreiveTokens(_tokenContract);
1091 
1092         // Retreive tokens from crowdsale contract
1093         uint tokenBalance = tokenInstance.balanceOf(this);
1094         if (tokenBalance > 0) {
1095             tokenInstance.transfer(beneficiary, tokenBalance);
1096         }
1097     }
1098 }