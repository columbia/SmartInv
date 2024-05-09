1 pragma solidity ^0.4.15;
2 
3 // File: contracts\infrastructure\ITokenRetreiver.sol
4 
5 /**
6  * @title Token retrieve interface
7  *
8  * Allows tokens to be retrieved from a contract
9  *
10  * #created 29/09/2017
11  * #author Frank Bonnet
12  */
13 contract ITokenRetreiver {
14 
15     /**
16      * Extracts tokens from the contract
17      *
18      * @param _tokenContract The address of ERC20 compatible token
19      */
20     function retreiveTokens(address _tokenContract);
21 }
22 
23 // File: contracts\integration\wings\IWingsAdapter.sol
24 
25 /**
26  * @title IWingsAdapter
27  *
28  * WINGS DAO Price Discovery & Promotion Pre-Beta https://www.wings.ai
29  *
30  * #created 04/10/2017
31  * #author Frank Bonnet
32  */
33 contract IWingsAdapter {
34 
35 
36     /**
37      * Get the total raised amount of Ether
38      *
39      * Can only increase, meaning if you withdraw ETH from the wallet, it should be not modified (you can use two fields
40      * to keep one with a total accumulated amount) amount of ETH in contract and totalCollected for total amount of ETH collected
41      *
42      * @return Total raised Ether amount
43      */
44     function totalCollected() constant returns (uint);
45 }
46 
47 // File: contracts\infrastructure\modifier\Owned.sol
48 
49 contract Owned {
50 
51     // The address of the account that is the current owner
52     address internal owner;
53 
54 
55     /**
56      * The publisher is the inital owner
57      */
58     function Owned() {
59         owner = msg.sender;
60     }
61 
62 
63     /**
64      * Access is restricted to the current owner
65      */
66     modifier only_owner() {
67         require(msg.sender == owner);
68 
69         _;
70     }
71 }
72 
73 // File: contracts\source\token\IToken.sol
74 
75 /**
76  * @title ERC20 compatible token interface
77  *
78  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
79  * - Short address attack fix
80  *
81  * #created 29/09/2017
82  * #author Frank Bonnet
83  */
84 contract IToken {
85 
86     /**
87      * Get the total supply of tokens
88      *
89      * @return The total supply
90      */
91     function totalSupply() constant returns (uint);
92 
93 
94     /**
95      * Get balance of `_owner`
96      *
97      * @param _owner The address from which the balance will be retrieved
98      * @return The balance
99      */
100     function balanceOf(address _owner) constant returns (uint);
101 
102 
103     /**
104      * Send `_value` token to `_to` from `msg.sender`
105      *
106      * @param _to The address of the recipient
107      * @param _value The amount of token to be transferred
108      * @return Whether the transfer was successful or not
109      */
110     function transfer(address _to, uint _value) returns (bool);
111 
112 
113     /**
114      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
115      *
116      * @param _from The address of the sender
117      * @param _to The address of the recipient
118      * @param _value The amount of token to be transferred
119      * @return Whether the transfer was successful or not
120      */
121     function transferFrom(address _from, address _to, uint _value) returns (bool);
122 
123 
124     /**
125      * `msg.sender` approves `_spender` to spend `_value` tokens
126      *
127      * @param _spender The address of the account able to transfer the tokens
128      * @param _value The amount of tokens to be approved for transfer
129      * @return Whether the approval was successful or not
130      */
131     function approve(address _spender, uint _value) returns (bool);
132 
133 
134     /**
135      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
136      *
137      * @param _owner The address of the account owning tokens
138      * @param _spender The address of the account able to transfer the tokens
139      * @return Amount of remaining tokens allowed to spent
140      */
141     function allowance(address _owner, address _spender) constant returns (uint);
142 }
143 
144 // File: contracts\source\token\IManagedToken.sol
145 
146 /**
147  * @title ManagedToken interface
148  *
149  * Adds the following functionallity to the basic ERC20 token
150  * - Locking
151  * - Issuing
152  *
153  * #created 29/09/2017
154  * #author Frank Bonnet
155  */
156 contract IManagedToken is IToken {
157 
158     /**
159      * Returns true if the token is locked
160      *
161      * @return Whether the token is locked
162      */
163     function isLocked() constant returns (bool);
164 
165 
166     /**
167      * Unlocks the token so that the transferring of value is enabled
168      *
169      * @return Whether the unlocking was successful or not
170      */
171     function unlock() returns (bool);
172 
173 
174     /**
175      * Issues `_value` new tokens to `_to`
176      *
177      * @param _to The address to which the tokens will be issued
178      * @param _value The amount of new tokens to issue
179      * @return Whether the tokens where sucessfully issued or not
180      */
181     function issue(address _to, uint _value) returns (bool);
182 }
183 
184 // File: contracts\source\crowdsale\ICrowdsale.sol
185 
186 /**
187  * @title ICrowdsale
188  *
189  * Base crowdsale interface to manage the sale of
190  * an ERC20 token
191  *
192  * #created 29/09/2017
193  * #author Frank Bonnet
194  */
195 contract ICrowdsale {
196 
197 
198     /**
199      * Returns true if the contract is currently in the presale phase
200      *
201      * @return True if in presale phase
202      */
203     function isInPresalePhase() constant returns (bool);
204 
205 
206     /**
207      * Returns true if `_beneficiary` has a balance allocated
208      *
209      * @param _beneficiary The account that the balance is allocated for
210      * @param _releaseDate The date after which the balance can be withdrawn
211      * @return True if there is a balance that belongs to `_beneficiary`
212      */
213     function hasBalance(address _beneficiary, uint _releaseDate) constant returns (bool);
214 
215 
216     /**
217      * Get the allocated token balance of `_owner`
218      *
219      * @param _owner The address from which the allocated token balance will be retrieved
220      * @return The allocated token balance
221      */
222     function balanceOf(address _owner) constant returns (uint);
223 
224 
225     /**
226      * Get the allocated eth balance of `_owner`
227      *
228      * @param _owner The address from which the allocated eth balance will be retrieved
229      * @return The allocated eth balance
230      */
231     function ethBalanceOf(address _owner) constant returns (uint);
232 
233 
234     /**
235      * Get invested and refundable balance of `_owner` (only contributions during the ICO phase are registered)
236      *
237      * @param _owner The address from which the refundable balance will be retrieved
238      * @return The invested refundable balance
239      */
240     function refundableEthBalanceOf(address _owner) constant returns (uint);
241 
242 
243     /**
244      * Returns the rate and bonus release date
245      *
246      * @param _phase The phase to use while determining the rate
247      * @param _volume The amount wei used to determine what volume multiplier to use
248      * @return The rate used in `_phase` multiplied by the corresponding volume multiplier
249      */
250     function getRate(uint _phase, uint _volume) constant returns (uint);
251 
252 
253     /**
254      * Convert `_wei` to an amount in tokens using
255      * the `_rate`
256      *
257      * @param _wei amount of wei to convert
258      * @param _rate rate to use for the conversion
259      * @return Amount in tokens
260      */
261     function toTokens(uint _wei, uint _rate) constant returns (uint);
262 
263 
264     /**
265      * Withdraw allocated tokens
266      */
267     function withdrawTokens();
268 
269 
270     /**
271      * Withdraw allocated ether
272      */
273     function withdrawEther();
274 
275 
276     /**
277      * Refund in the case of an unsuccessful crowdsale. The
278      * crowdsale is considered unsuccessful if minAmount was
279      * not raised before end of the crowdsale
280      */
281     function refund();
282 
283 
284     /**
285      * Receive Eth and issue tokens to the sender
286      */
287     function () payable;
288 }
289 
290 // File: contracts\source\crowdsale\Crowdsale.sol
291 
292 /**
293  * @title Crowdsale
294  *
295  * Abstract base crowdsale contract that manages the sale of
296  * an ERC20 token
297  *
298  * #created 29/09/2017
299  * #author Frank Bonnet
300  */
301 contract Crowdsale is ICrowdsale, Owned {
302 
303     enum Stages {
304         Deploying,
305         Deployed,
306         InProgress,
307         Ended
308     }
309 
310     struct Balance {
311         uint eth;
312         uint tokens;
313         uint index;
314     }
315 
316     struct Percentage {
317         uint eth;
318         uint tokens;
319         bool overwriteReleaseDate;
320         uint fixedReleaseDate;
321         uint index;
322     }
323 
324     struct Payout {
325         uint percentage;
326         uint vestingPeriod;
327     }
328 
329     struct Phase {
330         uint rate;
331         uint end;
332         uint bonusReleaseDate;
333         bool useVolumeMultiplier;
334     }
335 
336     struct VolumeMultiplier {
337         uint rateMultiplier;
338         uint bonusReleaseDateMultiplier;
339     }
340 
341     // Crowdsale details
342     uint public baseRate;
343     uint public minAmount;
344     uint public maxAmount;
345     uint public minAcceptedAmount;
346     uint public minAmountPresale;
347     uint public maxAmountPresale;
348     uint public minAcceptedAmountPresale;
349 
350     // Company address
351     address public beneficiary;
352 
353     // Denominators
354     uint internal percentageDenominator;
355     uint internal tokenDenominator;
356 
357     // Crowdsale state
358     uint public start;
359     uint public presaleEnd;
360     uint public crowdsaleEnd;
361     uint public raised;
362     uint public allocatedEth;
363     uint public allocatedTokens;
364     Stages public stage = Stages.Deploying;
365 
366     // Token contract
367     IManagedToken public token;
368 
369     // Invested balances
370     mapping (address => uint) private balances;
371 
372     // Alocated balances
373     mapping (address => mapping(uint => Balance)) private allocated;
374     mapping(address => uint[]) private allocatedIndex;
375 
376     // Stakeholders
377     mapping (address => Percentage) private stakeholderPercentages;
378     address[] private stakeholderPercentagesIndex;
379     Payout[] private stakeholdersPayouts;
380 
381     // Crowdsale phases
382     Phase[] private phases;
383 
384     // Volume multipliers
385     mapping (uint => VolumeMultiplier) private volumeMultipliers;
386     uint[] private volumeMultiplierThresholds;
387 
388 
389     /**
390      * Throw if at stage other than current stage
391      *
392      * @param _stage expected stage to test for
393      */
394     modifier at_stage(Stages _stage) {
395         require(stage == _stage);
396         _;
397     }
398 
399 
400     /**
401      * Only after crowdsaleEnd plus `_time`
402      *
403      * @param _time Time to pass
404      */
405     modifier only_after(uint _time) {
406         require(now > crowdsaleEnd + _time);
407         _;
408     }
409 
410 
411     /**
412      * Only after crowdsale
413      */
414     modifier only_after_crowdsale() {
415         require(now > crowdsaleEnd);
416         _;
417     }
418 
419 
420     /**
421      * Throw if sender is not beneficiary
422      */
423     modifier only_beneficiary() {
424         require(beneficiary == msg.sender);
425         _;
426     }
427 
428 
429     /**
430      * Allows the implementing contract to validate a
431      * contributing account
432      *
433      * @param _contributor Address that is being validated
434      * @return Wheter the contributor is accepted or not
435      */
436     function isAcceptedContributor(address _contributor) internal constant returns (bool);
437 
438 
439     /**
440      * Setup the crowdsale
441      *
442      * @param _start The timestamp of the start date
443      * @param _token The token that is sold
444      * @param _tokenDenominator The token amount of decimals that the token uses
445      * @param _percentageDenominator The percision of percentages
446      * @param _minAmount The min cap for the ICO
447      * @param _maxAmount The max cap for the ICO
448      * @param _minAcceptedAmount The lowest accepted amount during the ICO phase
449      * @param _minAmountPresale The min cap for the presale
450      * @param _maxAmountPresale The max cap for the presale
451      * @param _minAcceptedAmountPresale The lowest accepted amount during the presale phase
452      */
453     function Crowdsale(uint _start, address _token, uint _tokenDenominator, uint _percentageDenominator, uint _minAmount, uint _maxAmount, uint _minAcceptedAmount, uint _minAmountPresale, uint _maxAmountPresale, uint _minAcceptedAmountPresale) {
454         token = IManagedToken(_token);
455         tokenDenominator = _tokenDenominator;
456         percentageDenominator = _percentageDenominator;
457         start = _start;
458         minAmount = _minAmount;
459         maxAmount = _maxAmount;
460         minAcceptedAmount = _minAcceptedAmount;
461         minAmountPresale = _minAmountPresale;
462         maxAmountPresale = _maxAmountPresale;
463         minAcceptedAmountPresale = _minAcceptedAmountPresale;
464     }
465 
466 
467     /**
468      * Setup rates and phases
469      *
470      * @param _baseRate The rate without bonus
471      * @param _phaseRates The rates for each phase
472      * @param _phasePeriods The periods that each phase lasts (first phase is the presale phase)
473      * @param _phaseBonusLockupPeriods The lockup period that each phase lasts
474      * @param _phaseUsesVolumeMultiplier Wheter or not volume bonusses are used in the respective phase
475      */
476     function setupPhases(uint _baseRate, uint[] _phaseRates, uint[] _phasePeriods, uint[] _phaseBonusLockupPeriods, bool[] _phaseUsesVolumeMultiplier) public only_owner at_stage(Stages.Deploying) {
477         baseRate = _baseRate;
478         presaleEnd = start + _phasePeriods[0]; // First phase is expected to be the presale phase
479         crowdsaleEnd = start; // Plus the sum of the rate phases
480 
481         for (uint i = 0; i < _phaseRates.length; i++) {
482             crowdsaleEnd += _phasePeriods[i];
483             phases.push(Phase(_phaseRates[i], crowdsaleEnd, 0, _phaseUsesVolumeMultiplier[i]));
484         }
485 
486         for (uint ii = 0; ii < _phaseRates.length; ii++) {
487             if (_phaseBonusLockupPeriods[ii] > 0) {
488                 phases[ii].bonusReleaseDate = crowdsaleEnd + _phaseBonusLockupPeriods[ii];
489             }
490         }
491     }
492 
493 
494     /**
495      * Setup stakeholders
496      *
497      * @param _stakeholders The addresses of the stakeholders (first stakeholder is the beneficiary)
498      * @param _stakeholderEthPercentages The eth percentages of the stakeholders
499      * @param _stakeholderTokenPercentages The token percentages of the stakeholders
500      * @param _stakeholderTokenPayoutOverwriteReleaseDates Wheter the vesting period is overwritten for the respective stakeholder
501      * @param _stakeholderTokenPayoutFixedReleaseDates The vesting period after which the whole percentage of the tokens is released to the respective stakeholder
502      * @param _stakeholderTokenPayoutPercentages The percentage of the tokens that is released at the respective date
503      * @param _stakeholderTokenPayoutVestingPeriods The vesting period after which the respective percentage of the tokens is released
504      */
505     function setupStakeholders(address[] _stakeholders, uint[] _stakeholderEthPercentages, uint[] _stakeholderTokenPercentages, bool[] _stakeholderTokenPayoutOverwriteReleaseDates, uint[] _stakeholderTokenPayoutFixedReleaseDates, uint[] _stakeholderTokenPayoutPercentages, uint[] _stakeholderTokenPayoutVestingPeriods) public only_owner at_stage(Stages.Deploying) {
506         beneficiary = _stakeholders[0]; // First stakeholder is expected to be the beneficiary
507         for (uint i = 0; i < _stakeholders.length; i++) {
508             stakeholderPercentagesIndex.push(_stakeholders[i]);
509             stakeholderPercentages[_stakeholders[i]] = Percentage(
510                 _stakeholderEthPercentages[i],
511                 _stakeholderTokenPercentages[i],
512                 _stakeholderTokenPayoutOverwriteReleaseDates[i],
513                 _stakeholderTokenPayoutFixedReleaseDates[i], i);
514         }
515 
516         // Percentages add up to 100
517         for (uint ii = 0; ii < _stakeholderTokenPayoutPercentages.length; ii++) {
518             stakeholdersPayouts.push(Payout(_stakeholderTokenPayoutPercentages[ii], _stakeholderTokenPayoutVestingPeriods[ii]));
519         }
520     }
521 
522 
523     /**
524      * Setup volume multipliers
525      *
526      * @param _volumeMultiplierRates The rates will be multiplied by this value (denominated by 4)
527      * @param _volumeMultiplierLockupPeriods The lockup periods will be multiplied by this value (denominated by 4)
528      * @param _volumeMultiplierThresholds The volume thresholds for each respective multiplier
529      */
530     function setupVolumeMultipliers(uint[] _volumeMultiplierRates, uint[] _volumeMultiplierLockupPeriods, uint[] _volumeMultiplierThresholds) public only_owner at_stage(Stages.Deploying) {
531         require(phases.length > 0);
532         volumeMultiplierThresholds = _volumeMultiplierThresholds;
533         for (uint i = 0; i < volumeMultiplierThresholds.length; i++) {
534             volumeMultipliers[volumeMultiplierThresholds[i]] = VolumeMultiplier(_volumeMultiplierRates[i], _volumeMultiplierLockupPeriods[i]);
535         }
536     }
537 
538 
539     /**
540      * After calling the deploy function the crowdsale
541      * rules become immutable
542      */
543     function deploy() public only_owner at_stage(Stages.Deploying) {
544         require(phases.length > 0);
545         require(stakeholderPercentagesIndex.length > 0);
546         stage = Stages.Deployed;
547     }
548 
549 
550     /**
551      * Prove that beneficiary is able to sign transactions
552      * and start the crowdsale
553      */
554     function confirmBeneficiary() public only_beneficiary at_stage(Stages.Deployed) {
555         stage = Stages.InProgress;
556     }
557 
558 
559     /**
560      * Returns true if the contract is currently in the presale phase
561      *
562      * @return True if in presale phase
563      */
564     function isInPresalePhase() public constant returns (bool) {
565         return stage == Stages.InProgress && now >= start && now <= presaleEnd;
566     }
567 
568 
569     /**
570      * Returns true if `_beneficiary` has a balance allocated
571      *
572      * @param _beneficiary The account that the balance is allocated for
573      * @param _releaseDate The date after which the balance can be withdrawn
574      * @return True if there is a balance that belongs to `_beneficiary`
575      */
576     function hasBalance(address _beneficiary, uint _releaseDate) public constant returns (bool) {
577         return allocatedIndex[_beneficiary].length > 0 && _releaseDate == allocatedIndex[_beneficiary][allocated[_beneficiary][_releaseDate].index];
578     }
579 
580 
581     /**
582      * Get the allocated token balance of `_owner`
583      *
584      * @param _owner The address from which the allocated token balance will be retrieved
585      * @return The allocated token balance
586      */
587     function balanceOf(address _owner) public constant returns (uint) {
588         uint sum = 0;
589         for (uint i = 0; i < allocatedIndex[_owner].length; i++) {
590             sum += allocated[_owner][allocatedIndex[_owner][i]].tokens;
591         }
592 
593         return sum;
594     }
595 
596 
597     /**
598      * Get the allocated eth balance of `_owner`
599      *
600      * @param _owner The address from which the allocated eth balance will be retrieved
601      * @return The allocated eth balance
602      */
603     function ethBalanceOf(address _owner) public constant returns (uint) {
604         uint sum = 0;
605         for (uint i = 0; i < allocatedIndex[_owner].length; i++) {
606             sum += allocated[_owner][allocatedIndex[_owner][i]].eth;
607         }
608 
609         return sum;
610     }
611 
612 
613     /**
614      * Get invested and refundable balance of `_owner` (only contributions during the ICO phase are registered)
615      *
616      * @param _owner The address from which the refundable balance will be retrieved
617      * @return The invested refundable balance
618      */
619     function refundableEthBalanceOf(address _owner) public constant returns (uint) {
620         return now > crowdsaleEnd && raised < minAmount ? balances[_owner] : 0;
621     }
622 
623 
624     /**
625      * Returns the current phase based on the current time
626      *
627      * @return The index of the current phase
628      */
629     function getCurrentPhase() public constant returns (uint) {
630         for (uint i = 0; i < phases.length; i++) {
631             if (now <= phases[i].end) {
632                 return i;
633                 break;
634             }
635         }
636 
637         return phases.length; // Does not exist
638     }
639 
640 
641     /**
642      * Returns the rate and bonus release date
643      *
644      * @param _phase The phase to use while determining the rate
645      * @param _volume The amount wei used to determin what volume multiplier to use
646      * @return The rate used in `_phase` multiplied by the corresponding volume multiplier
647      */
648     function getRate(uint _phase, uint _volume) public constant returns (uint) {
649         uint rate = 0;
650         if (stage == Stages.InProgress && now >= start) {
651             Phase storage phase = phases[_phase];
652             rate = phase.rate;
653 
654             // Find volume multiplier
655             if (phase.useVolumeMultiplier && volumeMultiplierThresholds.length > 0 && _volume >= volumeMultiplierThresholds[0]) {
656                 for (uint i = volumeMultiplierThresholds.length; i > 0; i--) {
657                     if (_volume >= volumeMultiplierThresholds[i - 1]) {
658                         VolumeMultiplier storage multiplier = volumeMultipliers[volumeMultiplierThresholds[i - 1]];
659                         rate += phase.rate * multiplier.rateMultiplier / percentageDenominator;
660                         break;
661                     }
662                 }
663             }
664         }
665 
666         return rate;
667     }
668 
669 
670     /**
671      * Get distribution data based on the current phase and
672      * the volume in wei that is being distributed
673      *
674      * @param _phase The current crowdsale phase
675      * @param _volume The amount wei used to determine what volume multiplier to use
676      * @return Volumes and corresponding release dates
677      */
678     function getDistributionData(uint _phase, uint _volume) internal constant returns (uint[], uint[]) {
679         Phase storage phase = phases[_phase];
680         uint remainingVolume = _volume;
681 
682         bool usingMultiplier = false;
683         uint[] memory volumes = new uint[](1);
684         uint[] memory releaseDates = new uint[](1);
685 
686         // Find volume multipliers
687         if (phase.useVolumeMultiplier && volumeMultiplierThresholds.length > 0 && _volume >= volumeMultiplierThresholds[0]) {
688             uint phaseReleasePeriod = phase.bonusReleaseDate - crowdsaleEnd;
689             for (uint i = volumeMultiplierThresholds.length; i > 0; i--) {
690                 if (_volume >= volumeMultiplierThresholds[i - 1]) {
691                     if (!usingMultiplier) {
692                         volumes = new uint[](i + 1);
693                         releaseDates = new uint[](i + 1);
694                         usingMultiplier = true;
695                     }
696 
697                     VolumeMultiplier storage multiplier = volumeMultipliers[volumeMultiplierThresholds[i - 1]];
698                     uint releaseDate = phase.bonusReleaseDate + phaseReleasePeriod * multiplier.bonusReleaseDateMultiplier / percentageDenominator;
699                     uint volume = remainingVolume - volumeMultiplierThresholds[i - 1];
700 
701                     // Store increment
702                     volumes[i] = volume;
703                     releaseDates[i] = releaseDate;
704 
705                     remainingVolume -= volume;
706                 }
707             }
708         }
709 
710         // Store increment
711         volumes[0] = remainingVolume;
712         releaseDates[0] = phase.bonusReleaseDate;
713 
714         return (volumes, releaseDates);
715     }
716 
717 
718     /**
719      * Convert `_wei` to an amount in tokens using
720      * the `_rate`
721      *
722      * @param _wei amount of wei to convert
723      * @param _rate rate to use for the conversion
724      * @return Amount in tokens
725      */
726     function toTokens(uint _wei, uint _rate) public constant returns (uint) {
727         return _wei * _rate * tokenDenominator / 1 ether;
728     }
729 
730 
731     /**
732      * Function to end the crowdsale by setting
733      * the stage to Ended
734      */
735     function endCrowdsale() public at_stage(Stages.InProgress) {
736         require(now > crowdsaleEnd || raised >= maxAmount);
737         require(raised >= minAmount);
738         stage = Stages.Ended;
739 
740         // Unlock token
741         if (!token.unlock()) {
742             revert();
743         }
744 
745         // Allocate tokens (no allocation can be done after this period)
746         uint totalTokenSupply = token.totalSupply() + allocatedTokens;
747         for (uint i = 0; i < stakeholdersPayouts.length; i++) {
748             Payout storage p = stakeholdersPayouts[i];
749             _allocateStakeholdersTokens(totalTokenSupply * p.percentage / percentageDenominator, now + p.vestingPeriod);
750         }
751 
752         // Allocate remaining ETH
753         _allocateStakeholdersEth(this.balance - allocatedEth, 0);
754     }
755 
756 
757     /**
758      * Withdraw allocated tokens
759      */
760     function withdrawTokens() public {
761         uint tokensToSend = 0;
762         for (uint i = 0; i < allocatedIndex[msg.sender].length; i++) {
763             uint releaseDate = allocatedIndex[msg.sender][i];
764             if (releaseDate <= now) {
765                 Balance storage b = allocated[msg.sender][releaseDate];
766                 tokensToSend += b.tokens;
767                 b.tokens = 0;
768             }
769         }
770 
771         if (tokensToSend > 0) {
772             allocatedTokens -= tokensToSend;
773             if (!token.issue(msg.sender, tokensToSend)) {
774                 revert();
775             }
776         }
777     }
778 
779 
780     /**
781      * Withdraw allocated ether
782      */
783     function withdrawEther() public {
784         uint ethToSend = 0;
785         for (uint i = 0; i < allocatedIndex[msg.sender].length; i++) {
786             uint releaseDate = allocatedIndex[msg.sender][i];
787             if (releaseDate <= now) {
788                 Balance storage b = allocated[msg.sender][releaseDate];
789                 ethToSend += b.eth;
790                 b.eth = 0;
791             }
792         }
793 
794         if (ethToSend > 0) {
795             allocatedEth -= ethToSend;
796             if (!msg.sender.send(ethToSend)) {
797                 revert();
798             }
799         }
800     }
801 
802 
803     /**
804      * Refund in the case of an unsuccessful crowdsale. The
805      * crowdsale is considered unsuccessful if minAmount was
806      * not raised before end of the crowdsale
807      */
808     function refund() public only_after_crowdsale at_stage(Stages.InProgress) {
809         require(raised < minAmount);
810 
811         uint receivedAmount = balances[msg.sender];
812         balances[msg.sender] = 0;
813 
814         if (receivedAmount > 0 && !msg.sender.send(receivedAmount)) {
815             balances[msg.sender] = receivedAmount;
816         }
817     }
818 
819 
820     /**
821      * Failsafe and clean-up mechanism
822      */
823     function destroy() public only_beneficiary only_after(2 years) {
824         selfdestruct(beneficiary);
825     }
826 
827 
828     /**
829      * Receive Eth and issue tokens to the sender
830      */
831     function contribute() public payable {
832         _handleTransaction(msg.sender, msg.value);
833     }
834 
835 
836     /**
837      * Receive Eth and issue tokens to the sender
838      *
839      * This function requires that msg.sender is not a contract. This is required because it's
840      * not possible for a contract to specify a gas amount when calling the (internal) send()
841      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
842      *
843      * Contracts can call the contribute() function instead
844      */
845     function () payable {
846         require(msg.sender == tx.origin);
847         _handleTransaction(msg.sender, msg.value);
848     }
849 
850 
851     /**
852      * Handle incoming transactions
853      *
854 
855      */
856     function _handleTransaction(address _sender, uint _received) private at_stage(Stages.InProgress) {
857 
858         // Crowdsale is active
859         require(now >= start && now <= crowdsaleEnd);
860 
861         // Whitelist check
862         require(isAcceptedContributor(_sender));
863 
864         // When in presale phase
865         bool presalePhase = isInPresalePhase();
866         require(!presalePhase || _received >= minAcceptedAmountPresale);
867         require(!presalePhase || raised < maxAmountPresale);
868 
869         // When in ico phase
870         require(presalePhase || _received >= minAcceptedAmount);
871         require(presalePhase || raised >= minAmountPresale);
872         require(presalePhase || raised < maxAmount);
873 
874         uint acceptedAmount;
875         if (presalePhase && raised + _received > maxAmountPresale) {
876             acceptedAmount = maxAmountPresale - raised;
877         } else if (raised + _received > maxAmount) {
878             acceptedAmount = maxAmount - raised;
879         } else {
880             acceptedAmount = _received;
881         }
882 
883         raised += acceptedAmount;
884 
885         if (presalePhase) {
886             // During the presale phase - Non refundable
887             _allocateStakeholdersEth(acceptedAmount, 0);
888         } else {
889             // During the ICO phase - 100% refundable
890             balances[_sender] += acceptedAmount;
891         }
892 
893         // Distribute tokens
894         uint tokensToIssue = 0;
895         uint phase = getCurrentPhase();
896         var rate = getRate(phase, acceptedAmount);
897         var (volumes, releaseDates) = getDistributionData(phase, acceptedAmount);
898 
899         // Allocate tokens
900         for (uint i = 0; i < volumes.length; i++) {
901             var tokensAtCurrentRate = toTokens(volumes[i], rate);
902             if (rate > baseRate && releaseDates[i] > now) {
903                 uint bonusTokens = tokensAtCurrentRate / rate * (rate - baseRate);
904                 _allocateTokens(_sender, bonusTokens, releaseDates[i]);
905 
906                 tokensToIssue += tokensAtCurrentRate - bonusTokens;
907             } else {
908                 tokensToIssue += tokensAtCurrentRate;
909             }
910         }
911 
912         // Issue tokens
913         if (tokensToIssue > 0 && !token.issue(_sender, tokensToIssue)) {
914             revert();
915         }
916 
917         // Refund due to max cap hit
918         if (_received - acceptedAmount > 0 && !_sender.send(_received - acceptedAmount)) {
919             revert();
920         }
921     }
922 
923 
924     /**
925      * Allocate ETH
926      *
927      * @param _beneficiary The account to alocate the eth for
928      * @param _amount The amount of ETH to allocate
929      * @param _releaseDate The date after which the eth can be withdrawn
930      */
931     function _allocateEth(address _beneficiary, uint _amount, uint _releaseDate) private {
932         if (hasBalance(_beneficiary, _releaseDate)) {
933             allocated[_beneficiary][_releaseDate].eth += _amount;
934         } else {
935             allocated[_beneficiary][_releaseDate] = Balance(
936                 _amount, 0, allocatedIndex[_beneficiary].push(_releaseDate) - 1);
937         }
938 
939         allocatedEth += _amount;
940     }
941 
942 
943     /**
944      * Allocate Tokens
945      *
946      * @param _beneficiary The account to allocate the tokens for
947      * @param _amount The amount of tokens to allocate
948      * @param _releaseDate The date after which the tokens can be withdrawn
949      */
950     function _allocateTokens(address _beneficiary, uint _amount, uint _releaseDate) private {
951         if (hasBalance(_beneficiary, _releaseDate)) {
952             allocated[_beneficiary][_releaseDate].tokens += _amount;
953         } else {
954             allocated[_beneficiary][_releaseDate] = Balance(
955                 0, _amount, allocatedIndex[_beneficiary].push(_releaseDate) - 1);
956         }
957 
958         allocatedTokens += _amount;
959     }
960 
961 
962     /**
963      * Allocate ETH for stakeholders
964      *
965      * @param _amount The amount of ETH to allocate
966      * @param _releaseDate The date after which the eth can be withdrawn
967      */
968     function _allocateStakeholdersEth(uint _amount, uint _releaseDate) private {
969         for (uint i = 0; i < stakeholderPercentagesIndex.length; i++) {
970             Percentage storage p = stakeholderPercentages[stakeholderPercentagesIndex[i]];
971             if (p.eth > 0) {
972                 _allocateEth(stakeholderPercentagesIndex[i], _amount * p.eth / percentageDenominator, _releaseDate);
973             }
974         }
975     }
976 
977 
978     /**
979      * Allocate Tokens for stakeholders
980      *
981      * @param _amount The amount of tokens created
982      * @param _releaseDate The date after which the tokens can be withdrawn (unless overwitten)
983      */
984     function _allocateStakeholdersTokens(uint _amount, uint _releaseDate) private {
985         for (uint i = 0; i < stakeholderPercentagesIndex.length; i++) {
986             Percentage storage p = stakeholderPercentages[stakeholderPercentagesIndex[i]];
987             if (p.tokens > 0) {
988                 _allocateTokens(
989                     stakeholderPercentagesIndex[i],
990                     _amount * p.tokens / percentageDenominator,
991                     p.overwriteReleaseDate ? p.fixedReleaseDate : _releaseDate);
992             }
993         }
994     }
995 }
996 
997 // File: contracts\source\NUCrowdsale.sol
998 
999 /**
1000  * @title NUCrowdsale
1001  *
1002  * Network Units (NU) is a decentralised worldwide collaboration of computing power
1003  *
1004  * By allowing gamers and service providers to participate in our unique mining
1005  * process, we will create an ultra-fast, blockchain controlled multiplayer infrastructure
1006  * rentable by developers
1007  *
1008  * Visit https://networkunits.io/
1009  *
1010  * #created 22/10/2017
1011  * #author Frank Bonnet
1012  */
1013 contract NUCrowdsale is Crowdsale, ITokenRetreiver, IWingsAdapter {
1014 
1015 
1016     /**
1017      * Setup the crowdsale
1018      *
1019      * @param _start The timestamp of the start date
1020      * @param _token The token that is sold
1021      * @param _tokenDenominator The token amount of decimals that the token uses
1022      * @param _percentageDenominator The precision of percentages
1023      * @param _minAmount The min cap for the ICO
1024      * @param _maxAmount The max cap for the ICO
1025      * @param _minAcceptedAmount The lowest accepted amount during the ICO phase
1026      * @param _minAmountPresale The min cap for the presale
1027      * @param _maxAmountPresale The max cap for the presale
1028      * @param _minAcceptedAmountPresale The lowest accepted amount during the presale phase
1029      */
1030     function NUCrowdsale(uint _start, address _token, uint _tokenDenominator, uint _percentageDenominator, uint _minAmount, uint _maxAmount, uint _minAcceptedAmount, uint _minAmountPresale, uint _maxAmountPresale, uint _minAcceptedAmountPresale)
1031         Crowdsale(_start, _token, _tokenDenominator, _percentageDenominator, _minAmount, _maxAmount, _minAcceptedAmount, _minAmountPresale, _maxAmountPresale, _minAcceptedAmountPresale)
1032         {
1033     }
1034 
1035 
1036     /**
1037      * Wings integration - Get the total raised amount of Ether
1038      *
1039      * Can only increased, means if you withdraw ETH from the wallet, should be not modified (you can use two fields
1040      * to keep one with a total accumulated amount) amount of ETH in contract and totalCollected for total amount of ETH collected
1041      *
1042      * @return Total raised Ether amount
1043      */
1044     function totalCollected() public constant returns (uint) {
1045         return raised;
1046     }
1047 
1048 
1049     /**
1050      * Allows the implementing contract to validate a
1051      * contributing account
1052      *
1053      * @param _contributor Address that is being validated
1054      * @return Wheter the contributor is accepted or not
1055      */
1056     function isAcceptedContributor(address _contributor) internal constant returns (bool) {
1057         return _contributor != address(0x0);
1058     }
1059 
1060 
1061     /**
1062      * Failsafe mechanism
1063      *
1064      * Allows beneficary to retreive tokens from the contract
1065      *
1066      * @param _tokenContract The address of ERC20 compatible token
1067      */
1068     function retreiveTokens(address _tokenContract) public only_beneficiary {
1069         IToken tokenInstance = IToken(_tokenContract);
1070 
1071         // Retreive tokens from our token contract
1072         ITokenRetreiver(token).retreiveTokens(_tokenContract);
1073 
1074         // Retreive tokens from crowdsale contract
1075         uint tokenBalance = tokenInstance.balanceOf(this);
1076         if (tokenBalance > 0) {
1077             tokenInstance.transfer(beneficiary, tokenBalance);
1078         }
1079     }
1080 }