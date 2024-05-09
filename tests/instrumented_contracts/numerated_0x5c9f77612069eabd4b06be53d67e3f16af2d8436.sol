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
27  * @title Token retrieve interface
28  *
29  * Allows tokens to be retrieved from a contract
30  *
31  * #created 29/09/2017
32  * #author Frank Bonnet
33  */
34 contract ITokenRetreiver {
35 
36     /**
37      * Extracts tokens from the contract
38      *
39      * @param _tokenContract The address of ERC20 compatible token
40      */
41     function retreiveTokens(address _tokenContract);
42 }
43 
44 
45 contract Owned {
46 
47     // The address of the account that is the current owner 
48     address internal owner;
49 
50 
51     /**
52      * The publisher is the inital owner
53      */
54     function Owned() {
55         owner = msg.sender;
56     }
57 
58 
59     /**
60      * Access is restricted to the current owner
61      */
62     modifier only_owner() {
63         require(msg.sender == owner);
64 
65         _;
66     }
67 }
68 
69 
70 /**
71  * @title ERC20 compatible token interface
72  *
73  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
74  * - Short address attack fix
75  *
76  * #created 29/09/2017
77  * #author Frank Bonnet
78  */
79 contract IToken { 
80 
81     /** 
82      * Get the total supply of tokens
83      * 
84      * @return The total supply
85      */
86     function totalSupply() constant returns (uint);
87 
88 
89     /** 
90      * Get balance of `_owner` 
91      * 
92      * @param _owner The address from which the balance will be retrieved
93      * @return The balance
94      */
95     function balanceOf(address _owner) constant returns (uint);
96 
97 
98     /** 
99      * Send `_value` token to `_to` from `msg.sender`
100      * 
101      * @param _to The address of the recipient
102      * @param _value The amount of token to be transferred
103      * @return Whether the transfer was successful or not
104      */
105     function transfer(address _to, uint _value) returns (bool);
106 
107 
108     /** 
109      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
110      * 
111      * @param _from The address of the sender
112      * @param _to The address of the recipient
113      * @param _value The amount of token to be transferred
114      * @return Whether the transfer was successful or not
115      */
116     function transferFrom(address _from, address _to, uint _value) returns (bool);
117 
118 
119     /** 
120      * `msg.sender` approves `_spender` to spend `_value` tokens
121      * 
122      * @param _spender The address of the account able to transfer the tokens
123      * @param _value The amount of tokens to be approved for transfer
124      * @return Whether the approval was successful or not
125      */
126     function approve(address _spender, uint _value) returns (bool);
127 
128 
129     /** 
130      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
131      * 
132      * @param _owner The address of the account owning tokens
133      * @param _spender The address of the account able to transfer the tokens
134      * @return Amount of remaining tokens allowed to spent
135      */
136     function allowance(address _owner, address _spender) constant returns (uint);
137 }
138 
139 
140 /**
141  * @title ManagedToken interface
142  *
143  * Adds the following functionallity to the basic ERC20 token
144  * - Locking
145  * - Issuing
146  *
147  * #created 29/09/2017
148  * #author Frank Bonnet
149  */
150 contract IManagedToken is IToken { 
151 
152     /** 
153      * Returns true if the token is locked
154      * 
155      * @return Whether the token is locked
156      */
157     function isLocked() constant returns (bool);
158 
159 
160     /**
161      * Unlocks the token so that the transferring of value is enabled 
162      *
163      * @return Whether the unlocking was successful or not
164      */
165     function unlock() returns (bool);
166 
167 
168     /**
169      * Issues `_value` new tokens to `_to`
170      *
171      * @param _to The address to which the tokens will be issued
172      * @param _value The amount of new tokens to issue
173      * @return Whether the tokens where sucessfully issued or not
174      */
175     function issue(address _to, uint _value) returns (bool);
176 }
177 
178 
179 /**
180  * @title ICrowdsale
181  *
182  * Base crowdsale interface to manage the sale of 
183  * an ERC20 token
184  *
185  * #created 29/09/2017
186  * #author Frank Bonnet
187  */
188 contract ICrowdsale {
189 
190 
191     /**
192      * Returns true if the contract is currently in the presale phase
193      *
194      * @return True if in presale phase
195      */
196     function isInPresalePhase() constant returns (bool);
197 
198 
199     /**
200      * Returns true if `_beneficiary` has a balance allocated
201      *
202      * @param _beneficiary The account that the balance is allocated for
203      * @param _releaseDate The date after which the balance can be withdrawn
204      * @return True if there is a balance that belongs to `_beneficiary`
205      */
206     function hasBalance(address _beneficiary, uint _releaseDate) constant returns (bool);
207 
208 
209     /** 
210      * Get the allocated token balance of `_owner`
211      * 
212      * @param _owner The address from which the allocated token balance will be retrieved
213      * @return The allocated token balance
214      */
215     function balanceOf(address _owner) constant returns (uint);
216 
217 
218     /** 
219      * Get the allocated eth balance of `_owner`
220      * 
221      * @param _owner The address from which the allocated eth balance will be retrieved
222      * @return The allocated eth balance
223      */
224     function ethBalanceOf(address _owner) constant returns (uint);
225 
226 
227     /** 
228      * Get invested and refundable balance of `_owner` (only contributions during the ICO phase are registered)
229      * 
230      * @param _owner The address from which the refundable balance will be retrieved
231      * @return The invested refundable balance
232      */
233     function refundableEthBalanceOf(address _owner) constant returns (uint);
234 
235 
236     /**
237      * Returns the rate and bonus release date
238      *
239      * @param _phase The phase to use while determining the rate
240      * @param _volume The amount wei used to determine what volume multiplier to use
241      * @return The rate used in `_phase` multiplied by the corresponding volume multiplier
242      */
243     function getRate(uint _phase, uint _volume) constant returns (uint);
244 
245 
246     /**
247      * Convert `_wei` to an amount in tokens using 
248      * the `_rate`
249      *
250      * @param _wei amount of wei to convert
251      * @param _rate rate to use for the conversion
252      * @return Amount in tokens
253      */
254     function toTokens(uint _wei, uint _rate) constant returns (uint);
255 
256 
257     /**
258      * Withdraw allocated tokens
259      */
260     function withdrawTokens();
261 
262 
263     /**
264      * Withdraw allocated ether
265      */
266     function withdrawEther();
267 
268 
269     /**
270      * Refund in the case of an unsuccessful crowdsale. The 
271      * crowdsale is considered unsuccessful if minAmount was 
272      * not raised before end of the crowdsale
273      */
274     function refund();
275 
276 
277     /**
278      * Receive Eth and issue tokens to the sender
279      */
280     function () payable;
281 }
282 
283 
284 /**
285  * @title Crowdsale
286  *
287  * Abstract base crowdsale contract that manages the sale of 
288  * an ERC20 token
289  *
290  * #created 29/09/2017
291  * #author Frank Bonnet
292  */
293 contract Crowdsale is ICrowdsale, Owned {
294 
295     enum Stages {
296         Deploying,
297         Deployed,
298         InProgress,
299         Ended
300     }
301 
302     struct Balance {
303         uint eth;
304         uint tokens;
305         uint index;
306     }
307 
308     struct Percentage {
309         uint eth;
310         uint tokens;
311         bool overwriteReleaseDate;
312         uint fixedReleaseDate;
313         uint index; 
314     }
315 
316     struct Payout {
317         uint percentage;
318         uint vestingPeriod;
319     }
320 
321     struct Phase {
322         uint rate;
323         uint end;
324         uint bonusReleaseDate;
325         bool useVolumeMultiplier;
326     }
327 
328     struct VolumeMultiplier {
329         uint rateMultiplier;
330         uint bonusReleaseDateMultiplier;
331     }
332 
333     // Crowdsale details
334     uint public baseRate;
335     uint public minAmount; 
336     uint public maxAmount; 
337     uint public minAcceptedAmount;
338     uint public minAmountPresale; 
339     uint public maxAmountPresale;
340     uint public minAcceptedAmountPresale;
341 
342     // Company address
343     address public beneficiary; 
344 
345     // Denominators
346     uint internal percentageDenominator;
347     uint internal tokenDenominator;
348 
349     // Crowdsale state
350     uint public start;
351     uint public presaleEnd;
352     uint public crowdsaleEnd;
353     uint public raised;
354     uint public allocatedEth;
355     uint public allocatedTokens;
356     Stages public stage = Stages.Deploying;
357 
358     // Token contract
359     IManagedToken public token;
360 
361     // Invested balances
362     mapping (address => uint) private balances;
363 
364     // Alocated balances
365     mapping (address => mapping(uint => Balance)) private allocated;
366     mapping(address => uint[]) private allocatedIndex;
367 
368     // Stakeholders
369     mapping (address => Percentage) private stakeholderPercentages;
370     address[] private stakeholderPercentagesIndex;
371     Payout[] private stakeholdersPayouts;
372 
373     // Crowdsale phases
374     Phase[] private phases;
375 
376     // Volume multipliers
377     mapping (uint => VolumeMultiplier) private volumeMultipliers;
378     uint[] private volumeMultiplierThresholds;
379 
380 
381     /**
382      * Throw if at stage other than current stage
383      * 
384      * @param _stage expected stage to test for
385      */
386     modifier at_stage(Stages _stage) {
387         require(stage == _stage);
388         _;
389     }
390 
391 
392     /**
393      * Only after crowdsaleEnd plus `_time`
394      * 
395      * @param _time Time to pass
396      */
397     modifier only_after(uint _time) {
398         require(now > crowdsaleEnd + _time);
399         _;
400     }
401 
402 
403     /**
404      * Only after crowdsale
405      */
406     modifier only_after_crowdsale() {
407         require(now > crowdsaleEnd);
408         _;
409     }
410 
411 
412     /**
413      * Throw if sender is not beneficiary
414      */
415     modifier only_beneficiary() {
416         require(beneficiary == msg.sender);
417         _;
418     }
419 
420 
421     /**
422      * Allows the implementing contract to validate a 
423      * contributing account
424      *
425      * @param _contributor Address that is being validated
426      * @return Wheter the contributor is accepted or not
427      */
428     function isAcceptedContributor(address _contributor) internal constant returns (bool);
429 
430 
431     /**
432      * Setup the crowdsale
433      *
434      * @param _start The timestamp of the start date
435      * @param _token The token that is sold
436      * @param _tokenDenominator The token amount of decimals that the token uses
437      * @param _percentageDenominator The percision of percentages
438      * @param _minAmount The min cap for the ICO
439      * @param _maxAmount The max cap for the ICO
440      * @param _minAcceptedAmount The lowest accepted amount during the ICO phase
441      * @param _minAmountPresale The min cap for the presale
442      * @param _maxAmountPresale The max cap for the presale
443      * @param _minAcceptedAmountPresale The lowest accepted amount during the presale phase
444      */
445     function Crowdsale(uint _start, address _token, uint _tokenDenominator, uint _percentageDenominator, uint _minAmount, uint _maxAmount, uint _minAcceptedAmount, uint _minAmountPresale, uint _maxAmountPresale, uint _minAcceptedAmountPresale) {
446         token = IManagedToken(_token);
447         tokenDenominator = _tokenDenominator;
448         percentageDenominator = _percentageDenominator;
449         start = _start;
450         minAmount = _minAmount;
451         maxAmount = _maxAmount;
452         minAcceptedAmount = _minAcceptedAmount;
453         minAmountPresale = _minAmountPresale;
454         maxAmountPresale = _maxAmountPresale;
455         minAcceptedAmountPresale = _minAcceptedAmountPresale;
456     }
457 
458 
459     /**
460      * Setup rates and phases
461      *
462      * @param _baseRate The rate without bonus
463      * @param _phaseRates The rates for each phase
464      * @param _phasePeriods The periods that each phase lasts (first phase is the presale phase)
465      * @param _phaseBonusLockupPeriods The lockup period that each phase lasts
466      * @param _phaseUsesVolumeMultiplier Wheter or not volume bonusses are used in the respective phase
467      */
468     function setupPhases(uint _baseRate, uint[] _phaseRates, uint[] _phasePeriods, uint[] _phaseBonusLockupPeriods, bool[] _phaseUsesVolumeMultiplier) public only_owner at_stage(Stages.Deploying) {
469         baseRate = _baseRate;
470         presaleEnd = start + _phasePeriods[0]; // First phase is expected to be the presale phase
471         crowdsaleEnd = start; // Plus the sum of the rate phases
472 
473         for (uint i = 0; i < _phaseRates.length; i++) {
474             crowdsaleEnd += _phasePeriods[i];
475             phases.push(Phase(_phaseRates[i], crowdsaleEnd, 0, _phaseUsesVolumeMultiplier[i]));
476         }
477 
478         for (uint ii = 0; ii < _phaseRates.length; ii++) {
479             if (_phaseBonusLockupPeriods[ii] > 0) {
480                 phases[ii].bonusReleaseDate = crowdsaleEnd + _phaseBonusLockupPeriods[ii];
481             }
482         }
483     }
484 
485 
486     /**
487      * Setup stakeholders
488      *
489      * @param _stakeholders The addresses of the stakeholders (first stakeholder is the beneficiary)
490      * @param _stakeholderEthPercentages The eth percentages of the stakeholders
491      * @param _stakeholderTokenPercentages The token percentages of the stakeholders
492      * @param _stakeholderTokenPayoutOverwriteReleaseDates Wheter the vesting period is overwritten for the respective stakeholder
493      * @param _stakeholderTokenPayoutFixedReleaseDates The vesting period after which the whole percentage of the tokens is released to the respective stakeholder
494      * @param _stakeholderTokenPayoutPercentages The percentage of the tokens that is released at the respective date
495      * @param _stakeholderTokenPayoutVestingPeriods The vesting period after which the respective percentage of the tokens is released
496      */
497     function setupStakeholders(address[] _stakeholders, uint[] _stakeholderEthPercentages, uint[] _stakeholderTokenPercentages, bool[] _stakeholderTokenPayoutOverwriteReleaseDates, uint[] _stakeholderTokenPayoutFixedReleaseDates, uint[] _stakeholderTokenPayoutPercentages, uint[] _stakeholderTokenPayoutVestingPeriods) public only_owner at_stage(Stages.Deploying) {
498         beneficiary = _stakeholders[0]; // First stakeholder is expected to be the beneficiary
499         for (uint i = 0; i < _stakeholders.length; i++) {
500             stakeholderPercentagesIndex.push(_stakeholders[i]);
501             stakeholderPercentages[_stakeholders[i]] = Percentage(
502                 _stakeholderEthPercentages[i], 
503                 _stakeholderTokenPercentages[i], 
504                 _stakeholderTokenPayoutOverwriteReleaseDates[i],
505                 _stakeholderTokenPayoutFixedReleaseDates[i], i);
506         }
507 
508         // Percentages add up to 100
509         for (uint ii = 0; ii < _stakeholderTokenPayoutPercentages.length; ii++) {
510             stakeholdersPayouts.push(Payout(_stakeholderTokenPayoutPercentages[ii], _stakeholderTokenPayoutVestingPeriods[ii]));
511         }
512     }
513 
514     
515     /**
516      * Setup volume multipliers
517      *
518      * @param _volumeMultiplierRates The rates will be multiplied by this value (denominated by 4)
519      * @param _volumeMultiplierLockupPeriods The lockup periods will be multiplied by this value (denominated by 4)
520      * @param _volumeMultiplierThresholds The volume thresholds for each respective multiplier
521      */
522     function setupVolumeMultipliers(uint[] _volumeMultiplierRates, uint[] _volumeMultiplierLockupPeriods, uint[] _volumeMultiplierThresholds) public only_owner at_stage(Stages.Deploying) {
523         require(phases.length > 0);
524         volumeMultiplierThresholds = _volumeMultiplierThresholds;
525         for (uint i = 0; i < volumeMultiplierThresholds.length; i++) {
526             volumeMultipliers[volumeMultiplierThresholds[i]] = VolumeMultiplier(_volumeMultiplierRates[i], _volumeMultiplierLockupPeriods[i]);
527         }
528     }
529     
530 
531     /**
532      * After calling the deploy function the crowdsale
533      * rules become immutable 
534      */
535     function deploy() public only_owner at_stage(Stages.Deploying) {
536         require(phases.length > 0);
537         require(stakeholderPercentagesIndex.length > 0);
538         stage = Stages.Deployed;
539     }
540 
541 
542     /**
543      * Prove that beneficiary is able to sign transactions 
544      * and start the crowdsale
545      */
546     function confirmBeneficiary() public only_beneficiary at_stage(Stages.Deployed) {
547         stage = Stages.InProgress;
548     }
549 
550 
551     /**
552      * Returns true if the contract is currently in the presale phase
553      *
554      * @return True if in presale phase
555      */
556     function isInPresalePhase() public constant returns (bool) {
557         return stage == Stages.InProgress && now >= start && now <= presaleEnd;
558     }
559 
560 
561     /**
562      * Returns true if `_beneficiary` has a balance allocated
563      *
564      * @param _beneficiary The account that the balance is allocated for
565      * @param _releaseDate The date after which the balance can be withdrawn
566      * @return True if there is a balance that belongs to `_beneficiary`
567      */
568     function hasBalance(address _beneficiary, uint _releaseDate) public constant returns (bool) {
569         return allocatedIndex[_beneficiary].length > 0 && _releaseDate == allocatedIndex[_beneficiary][allocated[_beneficiary][_releaseDate].index];
570     }
571 
572 
573     /** 
574      * Get the allocated token balance of `_owner`
575      * 
576      * @param _owner The address from which the allocated token balance will be retrieved
577      * @return The allocated token balance
578      */
579     function balanceOf(address _owner) public constant returns (uint) {
580         uint sum = 0;
581         for (uint i = 0; i < allocatedIndex[_owner].length; i++) {
582             sum += allocated[_owner][allocatedIndex[_owner][i]].tokens;
583         }
584 
585         return sum;
586     }
587 
588 
589     /** 
590      * Get the allocated eth balance of `_owner`
591      * 
592      * @param _owner The address from which the allocated eth balance will be retrieved
593      * @return The allocated eth balance
594      */
595     function ethBalanceOf(address _owner) public constant returns (uint) {
596         uint sum = 0;
597         for (uint i = 0; i < allocatedIndex[_owner].length; i++) {
598             sum += allocated[_owner][allocatedIndex[_owner][i]].eth;
599         }
600 
601         return sum;
602     }
603 
604 
605     /** 
606      * Get invested and refundable balance of `_owner` (only contributions during the ICO phase are registered)
607      * 
608      * @param _owner The address from which the refundable balance will be retrieved
609      * @return The invested refundable balance
610      */
611     function refundableEthBalanceOf(address _owner) public constant returns (uint) {
612         return now > crowdsaleEnd && raised < minAmount ? balances[_owner] : 0;
613     }
614 
615 
616     /**
617      * Returns the current phase based on the current time
618      *
619      * @return The index of the current phase
620      */
621     function getCurrentPhase() public constant returns (uint found) {
622         for (uint i = 0; i < phases.length; i++) {
623             if (now <= phases[i].end) {
624                 return i;
625                 break;
626             }
627         }
628 
629         return phases.length; // Does not exist
630     }
631 
632 
633     /**
634      * Returns the rate and bonus release date
635      *
636      * @param _phase The phase to use while determining the rate
637      * @param _volume The amount wei used to determin what volume multiplier to use
638      * @return The rate used in `_phase` multiplied by the corresponding volume multiplier
639      */
640     function getRate(uint _phase, uint _volume) public constant returns (uint) {
641         uint rate = 0;
642         if (stage == Stages.InProgress && now >= start) {
643             Phase storage phase = phases[_phase];
644             rate = phase.rate;
645 
646             // Find volume multiplier
647             if (phase.useVolumeMultiplier && volumeMultiplierThresholds.length > 0 && _volume >= volumeMultiplierThresholds[0]) {
648                 for (uint i = volumeMultiplierThresholds.length; i > 0; i--) {
649                     if (_volume >= volumeMultiplierThresholds[i - 1]) {
650                         VolumeMultiplier storage multiplier = volumeMultipliers[volumeMultiplierThresholds[i - 1]];
651                         rate += phase.rate * multiplier.rateMultiplier / percentageDenominator;
652                         break;
653                     }
654                 }
655             }
656         }
657         
658         return rate;
659     }
660 
661 
662     /**
663      * Get distribution data based on the current phase and 
664      * the volume in wei that is being distributed
665      * 
666      * @param _phase The current crowdsale phase
667      * @param _volume The amount wei used to determine what volume multiplier to use
668      * @return Volumes and corresponding release dates
669      */
670     function getDistributionData(uint _phase, uint _volume) internal constant returns (uint[], uint[]) {
671         Phase storage phase = phases[_phase];
672         uint remainingVolume = _volume;
673 
674         bool usingMultiplier = false;
675         uint[] memory volumes = new uint[](1);
676         uint[] memory releaseDates = new uint[](1);
677 
678         // Find volume multipliers
679         if (phase.useVolumeMultiplier && volumeMultiplierThresholds.length > 0 && _volume >= volumeMultiplierThresholds[0]) {
680             uint phaseReleasePeriod = phase.bonusReleaseDate - crowdsaleEnd;
681             for (uint i = volumeMultiplierThresholds.length; i > 0; i--) {
682                 if (_volume >= volumeMultiplierThresholds[i - 1]) {
683                     if (!usingMultiplier) {
684                         volumes = new uint[](i + 1);
685                         releaseDates = new uint[](i + 1);
686                         usingMultiplier = true;
687                     }
688 
689                     VolumeMultiplier storage multiplier = volumeMultipliers[volumeMultiplierThresholds[i - 1]];
690                     uint releaseDate = phase.bonusReleaseDate + phaseReleasePeriod * multiplier.bonusReleaseDateMultiplier / percentageDenominator;
691                     uint volume = remainingVolume - volumeMultiplierThresholds[i - 1];
692 
693                     // Store increment
694                     volumes[i] = volume;
695                     releaseDates[i] = releaseDate;
696 
697                     remainingVolume -= volume;
698                 }
699             }
700         }
701 
702         // Store increment
703         volumes[0] = remainingVolume;
704         releaseDates[0] = phase.bonusReleaseDate;
705 
706         return (volumes, releaseDates);
707     }
708 
709 
710     /**
711      * Convert `_wei` to an amount in tokens using 
712      * the `_rate`
713      *
714      * @param _wei amount of wei to convert
715      * @param _rate rate to use for the conversion
716      * @return Amount in tokens
717      */
718     function toTokens(uint _wei, uint _rate) public constant returns (uint) {
719         return _wei * _rate * tokenDenominator / 1 ether;
720     }
721 
722 
723     /**
724      * Function to end the crowdsale by setting 
725      * the stage to Ended
726      */
727     function endCrowdsale() public at_stage(Stages.InProgress) {
728         require(now > crowdsaleEnd || raised >= maxAmount);
729         require(raised >= minAmount);
730         stage = Stages.Ended;
731 
732         // Unlock token
733         if (!token.unlock()) {
734             revert();
735         }
736 
737         // Allocate tokens (no allocation can be done after this period)
738         uint totalTokenSupply = token.totalSupply() + allocatedTokens;
739         for (uint i = 0; i < stakeholdersPayouts.length; i++) {
740             Payout storage p = stakeholdersPayouts[i];
741             _allocateStakeholdersTokens(totalTokenSupply * p.percentage / percentageDenominator, now + p.vestingPeriod);
742         }
743 
744         // Allocate remaining ETH
745         _allocateStakeholdersEth(this.balance - allocatedEth, 0);
746     }
747 
748 
749     /**
750      * Withdraw allocated tokens
751      */
752     function withdrawTokens() public {
753         uint tokensToSend = 0;
754         for (uint i = 0; i < allocatedIndex[msg.sender].length; i++) {
755             uint releaseDate = allocatedIndex[msg.sender][i];
756             if (releaseDate <= now) {
757                 Balance storage b = allocated[msg.sender][releaseDate];
758                 tokensToSend += b.tokens;
759                 b.tokens = 0;
760             }
761         }
762 
763         if (tokensToSend > 0) {
764             allocatedTokens -= tokensToSend;
765             if (!token.issue(msg.sender, tokensToSend)) {
766                 revert();
767             }
768         }
769     }
770 
771 
772     /**
773      * Withdraw allocated ether
774      */
775     function withdrawEther() public {
776         uint ethToSend = 0;
777         for (uint i = 0; i < allocatedIndex[msg.sender].length; i++) {
778             uint releaseDate = allocatedIndex[msg.sender][i];
779             if (releaseDate <= now) {
780                 Balance storage b = allocated[msg.sender][releaseDate];
781                 ethToSend += b.eth;
782                 b.eth = 0;
783             }
784         }
785 
786         if (ethToSend > 0) {
787             allocatedEth -= ethToSend;
788             if (!msg.sender.send(ethToSend)) {
789                 revert();
790             }
791         }
792     }
793 
794 
795     /**
796      * Refund in the case of an unsuccessful crowdsale. The 
797      * crowdsale is considered unsuccessful if minAmount was 
798      * not raised before end of the crowdsale
799      */
800     function refund() public only_after_crowdsale at_stage(Stages.InProgress) {
801         require(raised < minAmount);
802 
803         uint receivedAmount = balances[msg.sender];
804         balances[msg.sender] = 0;
805 
806         if (receivedAmount > 0 && !msg.sender.send(receivedAmount)) {
807             balances[msg.sender] = receivedAmount;
808         }
809     }
810 
811 
812     /**
813      * Failsafe and clean-up mechanism
814      */
815     function destroy() public only_beneficiary only_after(2 years) {
816         selfdestruct(beneficiary);
817     }
818 
819 
820     /**
821      * Receive Eth and issue tokens to the sender
822      */
823     function contribute() public payable {
824         _handleTransaction(msg.sender, msg.value);
825     }
826 
827 
828     /**
829      * Receive Eth and issue tokens to the sender
830      * 
831      * This function requires that msg.sender is not a contract. This is required because it's 
832      * not possible for a contract to specify a gas amount when calling the (internal) send() 
833      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
834      * 
835      * Contracts can call the contribute() function instead
836      */
837     function () payable {
838         require(msg.sender == tx.origin);
839         _handleTransaction(msg.sender, msg.value);
840     }
841 
842 
843     /**
844      * Handle incoming transactions
845      * 
846      * @param _sender Transaction sender
847      * @param _received 
848      */
849     function _handleTransaction(address _sender, uint _received) private at_stage(Stages.InProgress) {
850 
851         // Crowdsale is active
852         require(now >= start && now <= crowdsaleEnd);
853 
854         // Whitelist check
855         require(isAcceptedContributor(_sender));
856 
857         // When in presale phase
858         bool presalePhase = isInPresalePhase();
859         require(!presalePhase || _received >= minAcceptedAmountPresale);
860         require(!presalePhase || raised < maxAmountPresale);
861 
862         // When in ico phase
863         require(presalePhase || _received >= minAcceptedAmount);
864         require(presalePhase || raised >= minAmountPresale);
865         require(presalePhase || raised < maxAmount);
866 
867         uint acceptedAmount;
868         if (presalePhase && raised + _received > maxAmountPresale) {
869             acceptedAmount = maxAmountPresale - raised;
870         } else if (raised + _received > maxAmount) {
871             acceptedAmount = maxAmount - raised;
872         } else {
873             acceptedAmount = _received;
874         }
875 
876         raised += acceptedAmount;
877         
878         if (presalePhase) {
879             // During the presale phase - Non refundable
880             _allocateStakeholdersEth(acceptedAmount, 0); 
881         } else {
882             // During the ICO phase - 100% refundable
883             balances[_sender] += acceptedAmount; 
884         }
885 
886         // Distribute tokens
887         uint tokensToIssue = 0;
888         uint phase = getCurrentPhase();
889         var rate = getRate(phase, acceptedAmount);
890         var (volumes, releaseDates) = getDistributionData(phase, acceptedAmount);
891         
892         // Allocate tokens
893         for (uint i = 0; i < volumes.length; i++) {
894             var tokensAtCurrentRate = toTokens(volumes[i], rate);
895             if (rate > baseRate && releaseDates[i] > now) {
896                 uint bonusTokens = tokensAtCurrentRate / rate * (rate - baseRate);
897                 _allocateTokens(_sender, bonusTokens, releaseDates[i]);
898 
899                 tokensToIssue += tokensAtCurrentRate - bonusTokens;
900             } else {
901                 tokensToIssue += tokensAtCurrentRate;
902             }
903         }
904 
905         // Issue tokens
906         if (tokensToIssue > 0 && !token.issue(_sender, tokensToIssue)) {
907             revert();
908         }
909 
910         // Refund due to max cap hit
911         if (_received - acceptedAmount > 0 && !_sender.send(_received - acceptedAmount)) {
912             revert();
913         }
914     }
915 
916 
917     /**
918      * Allocate ETH
919      *
920      * @param _beneficiary The account to alocate the eth for
921      * @param _amount The amount of ETH to allocate
922      * @param _releaseDate The date after which the eth can be withdrawn
923      */    
924     function _allocateEth(address _beneficiary, uint _amount, uint _releaseDate) private {
925         if (hasBalance(_beneficiary, _releaseDate)) {
926             allocated[_beneficiary][_releaseDate].eth += _amount;
927         } else {
928             allocated[_beneficiary][_releaseDate] = Balance(
929                 _amount, 0, allocatedIndex[_beneficiary].push(_releaseDate) - 1);
930         }
931 
932         allocatedEth += _amount;
933     }
934 
935 
936     /**
937      * Allocate Tokens
938      *
939      * @param _beneficiary The account to allocate the tokens for
940      * @param _amount The amount of tokens to allocate
941      * @param _releaseDate The date after which the tokens can be withdrawn
942      */    
943     function _allocateTokens(address _beneficiary, uint _amount, uint _releaseDate) private {
944         if (hasBalance(_beneficiary, _releaseDate)) {
945             allocated[_beneficiary][_releaseDate].tokens += _amount;
946         } else {
947             allocated[_beneficiary][_releaseDate] = Balance(
948                 0, _amount, allocatedIndex[_beneficiary].push(_releaseDate) - 1);
949         }
950 
951         allocatedTokens += _amount;
952     }
953 
954 
955     /**
956      * Allocate ETH for stakeholders
957      *
958      * @param _amount The amount of ETH to allocate
959      * @param _releaseDate The date after which the eth can be withdrawn
960      */    
961     function _allocateStakeholdersEth(uint _amount, uint _releaseDate) private {
962         for (uint i = 0; i < stakeholderPercentagesIndex.length; i++) {
963             Percentage storage p = stakeholderPercentages[stakeholderPercentagesIndex[i]];
964             if (p.eth > 0) {
965                 _allocateEth(stakeholderPercentagesIndex[i], _amount * p.eth / percentageDenominator, _releaseDate);
966             }
967         }
968     }
969 
970 
971     /**
972      * Allocate Tokens for stakeholders
973      *
974      * @param _amount The amount of tokens created
975      * @param _releaseDate The date after which the tokens can be withdrawn (unless overwitten)
976      */    
977     function _allocateStakeholdersTokens(uint _amount, uint _releaseDate) private {
978         for (uint i = 0; i < stakeholderPercentagesIndex.length; i++) {
979             Percentage storage p = stakeholderPercentages[stakeholderPercentagesIndex[i]];
980             if (p.tokens > 0) {
981                 _allocateTokens(
982                     stakeholderPercentagesIndex[i], 
983                     _amount * p.tokens / percentageDenominator, 
984                     p.overwriteReleaseDate ? p.fixedReleaseDate : _releaseDate);
985             }
986         }
987     }
988 }
989 
990 
991 /**
992  * @title NUCrowdsale
993  *
994  * Network Units (NU) is a decentralised worldwide collaboration of computing power
995  *
996  * By allowing gamers and service providers to participate in our unique mining 
997  * process, we will create an ultra-fast, blockchain controlled multiplayer infrastructure 
998  * rentable by developers
999  *
1000  * Visit https://networkunits.io/
1001  *
1002  * #created 22/10/2017
1003  * #author Frank Bonnet
1004  */
1005 contract NUCrowdsale is Crowdsale, ITokenRetreiver, IWingsAdapter {
1006 
1007 
1008     /**
1009      * Setup the crowdsale
1010      *
1011      * @param _start The timestamp of the start date
1012      * @param _token The token that is sold
1013      * @param _tokenDenominator The token amount of decimals that the token uses
1014      * @param _percentageDenominator The precision of percentages
1015      * @param _minAmount The min cap for the ICO
1016      * @param _maxAmount The max cap for the ICO
1017      * @param _minAcceptedAmount The lowest accepted amount during the ICO phase
1018      * @param _minAmountPresale The min cap for the presale
1019      * @param _maxAmountPresale The max cap for the presale
1020      * @param _minAcceptedAmountPresale The lowest accepted amount during the presale phase
1021      */
1022     function NUCrowdsale(uint _start, address _token, uint _tokenDenominator, uint _percentageDenominator, uint _minAmount, uint _maxAmount, uint _minAcceptedAmount, uint _minAmountPresale, uint _maxAmountPresale, uint _minAcceptedAmountPresale) 
1023         Crowdsale(_start, _token, _tokenDenominator, _percentageDenominator, _minAmount, _maxAmount, _minAcceptedAmount, _minAmountPresale, _maxAmountPresale, _minAcceptedAmountPresale) {
1024     }
1025 
1026 
1027     /**
1028      * Wings integration - Get the total raised amount of Ether
1029      *
1030      * Can only increased, means if you withdraw ETH from the wallet, should be not modified (you can use two fields 
1031      * to keep one with a total accumulated amount) amount of ETH in contract and totalCollected for total amount of ETH collected
1032      *
1033      * @return Total raised Ether amount
1034      */
1035     function totalCollected() public constant returns (uint) {
1036         return raised;
1037     }
1038 
1039 
1040     /**
1041      * Allows the implementing contract to validate a 
1042      * contributing account
1043      *
1044      * @param _contributor Address that is being validated
1045      * @return Wheter the contributor is accepted or not
1046      */
1047     function isAcceptedContributor(address _contributor) internal constant returns (bool) {
1048         return _contributor != address(0x0);
1049     }
1050 
1051 
1052     /**
1053      * Failsafe mechanism
1054      * 
1055      * Allows beneficary to retreive tokens from the contract
1056      *
1057      * @param _tokenContract The address of ERC20 compatible token
1058      */
1059     function retreiveTokens(address _tokenContract) public only_beneficiary {
1060         IToken tokenInstance = IToken(_tokenContract);
1061 
1062         // Retreive tokens from our token contract
1063         ITokenRetreiver(token).retreiveTokens(_tokenContract);
1064 
1065         // Retreive tokens from crowdsale contract
1066         uint tokenBalance = tokenInstance.balanceOf(this);
1067         if (tokenBalance > 0) {
1068             tokenInstance.transfer(beneficiary, tokenBalance);
1069         }
1070     }
1071 }