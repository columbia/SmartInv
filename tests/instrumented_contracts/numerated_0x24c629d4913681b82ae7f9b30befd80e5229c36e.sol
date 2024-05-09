1 pragma solidity ^0.4.18;
2 
3 /**
4  * IOwnership
5  *
6  * Perminent ownership
7  *
8  * #created 01/10/2017
9  * #author Frank Bonnet
10  */
11 interface IOwnership {
12 
13     /**
14      * Returns true if `_account` is the current owner
15      *
16      * @param _account The address to test against
17      */
18     function isOwner(address _account) public view returns (bool);
19 
20 
21     /**
22      * Gets the current owner
23      *
24      * @return address The current owner
25      */
26     function getOwner() public view returns (address);
27 }
28 
29 
30 /**
31  * Ownership
32  *
33  * Perminent ownership
34  *
35  * #created 01/10/2017
36  * #author Frank Bonnet
37  */
38 contract Ownership is IOwnership {
39 
40     // Owner
41     address internal owner;
42 
43 
44     /**
45      * Access is restricted to the current owner
46      */
47     modifier only_owner() {
48         require(msg.sender == owner);
49         _;
50     }
51 
52 
53     /**
54      * The publisher is the inital owner
55      */
56     function Ownership() public {
57         owner = msg.sender;
58     }
59 
60 
61     /**
62      * Returns true if `_account` is the current owner
63      *
64      * @param _account The address to test against
65      */
66     function isOwner(address _account) public view returns (bool) {
67         return _account == owner;
68     }
69 
70 
71     /**
72      * Gets the current owner
73      *
74      * @return address The current owner
75      */
76     function getOwner() public view returns (address) {
77         return owner;
78     }
79 }
80 
81 
82 /**
83  * ERC20 compatible token interface
84  *
85  * - Implements ERC 20 Token standard
86  * - Implements short address attack fix
87  *
88  * #created 29/09/2017
89  * #author Frank Bonnet
90  */
91 interface IToken { 
92 
93     /** 
94      * Get the total supply of tokens
95      * 
96      * @return The total supply
97      */
98     function totalSupply() public view returns (uint);
99 
100 
101     /** 
102      * Get balance of `_owner` 
103      * 
104      * @param _owner The address from which the balance will be retrieved
105      * @return The balance
106      */
107     function balanceOf(address _owner) public view returns (uint);
108 
109 
110     /** 
111      * Send `_value` token to `_to` from `msg.sender`
112      * 
113      * @param _to The address of the recipient
114      * @param _value The amount of token to be transferred
115      * @return Whether the transfer was successful or not
116      */
117     function transfer(address _to, uint _value) public returns (bool);
118 
119 
120     /** 
121      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
122      * 
123      * @param _from The address of the sender
124      * @param _to The address of the recipient
125      * @param _value The amount of token to be transferred
126      * @return Whether the transfer was successful or not
127      */
128     function transferFrom(address _from, address _to, uint _value) public returns (bool);
129 
130 
131     /** 
132      * `msg.sender` approves `_spender` to spend `_value` tokens
133      * 
134      * @param _spender The address of the account able to transfer the tokens
135      * @param _value The amount of tokens to be approved for transfer
136      * @return Whether the approval was successful or not
137      */
138     function approve(address _spender, uint _value) public returns (bool);
139 
140 
141     /** 
142      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
143      * 
144      * @param _owner The address of the account owning tokens
145      * @param _spender The address of the account able to transfer the tokens
146      * @return Amount of remaining tokens allowed to spent
147      */
148     function allowance(address _owner, address _spender) public view returns (uint);
149 }
150 
151 
152 /**
153  * IManagedToken
154  *
155  * Adds the following functionality to the basic ERC20 token
156  * - Locking
157  * - Issuing
158  * - Burning 
159  *
160  * #created 29/09/2017
161  * #author Frank Bonnet
162  */
163 interface IManagedToken { 
164 
165     /** 
166      * Returns true if the token is locked
167      * 
168      * @return Whether the token is locked
169      */
170     function isLocked() public view returns (bool);
171 
172 
173     /**
174      * Locks the token so that the transfering of value is disabled 
175      *
176      * @return Whether the unlocking was successful or not
177      */
178     function lock() public returns (bool);
179 
180 
181     /**
182      * Unlocks the token so that the transfering of value is enabled 
183      *
184      * @return Whether the unlocking was successful or not
185      */
186     function unlock() public returns (bool);
187 
188 
189     /**
190      * Issues `_value` new tokens to `_to`
191      *
192      * @param _to The address to which the tokens will be issued
193      * @param _value The amount of new tokens to issue
194      * @return Whether the tokens where sucessfully issued or not
195      */
196     function issue(address _to, uint _value) public returns (bool);
197 
198 
199     /**
200      * Burns `_value` tokens of `_from`
201      *
202      * @param _from The address that owns the tokens to be burned
203      * @param _value The amount of tokens to be burned
204      * @return Whether the tokens where sucessfully burned or not 
205      */
206     function burn(address _from, uint _value) public returns (bool);
207 }
208 
209 
210 /**
211  * ITokenRetriever
212  *
213  * Allows tokens to be retrieved from a contract
214  *
215  * #created 29/09/2017
216  * #author Frank Bonnet
217  */
218 interface ITokenRetriever {
219 
220     /**
221      * Extracts tokens from the contract
222      *
223      * @param _tokenContract The address of ERC20 compatible token
224      */
225     function retrieveTokens(address _tokenContract) public;
226 }
227 
228 
229 /**
230  * TokenRetriever
231  *
232  * Allows tokens to be retrieved from a contract
233  *
234  * #created 18/10/2017
235  * #author Frank Bonnet
236  */
237 contract TokenRetriever is ITokenRetriever {
238 
239     /**
240      * Extracts tokens from the contract
241      *
242      * @param _tokenContract The address of ERC20 compatible token
243      */
244     function retrieveTokens(address _tokenContract) public {
245         IToken tokenInstance = IToken(_tokenContract);
246         uint tokenBalance = tokenInstance.balanceOf(this);
247         if (tokenBalance > 0) {
248             tokenInstance.transfer(msg.sender, tokenBalance);
249         }
250     }
251 }
252 
253 
254 /**
255  * IAuthenticator 
256  *
257  * Authenticator interface
258  *
259  * #created 15/10/2017
260  * #author Frank Bonnet
261  */
262 interface IAuthenticator {
263     
264 
265     /**
266      * Authenticate 
267      *
268      * Returns whether `_account` is authenticated or not
269      *
270      * @param _account The account to authenticate
271      * @return whether `_account` is successfully authenticated
272      */
273     function authenticate(address _account) public view returns (bool);
274 }
275 
276 
277 /**
278  * IAuthenticationManager 
279  *
280  * Allows the authentication process to be enabled and disabled
281  *
282  * #created 15/10/2017
283  * #author Frank Bonnet
284  */
285 interface IAuthenticationManager {
286     
287 
288     /**
289      * Returns true if authentication is enabled and false 
290      * otherwise
291      *
292      * @return Whether the converter is currently authenticating or not
293      */
294     function isAuthenticating() public view returns (bool);
295 
296 
297     /**
298      * Enable authentication
299      */
300     function enableAuthentication() public;
301 
302 
303     /**
304      * Disable authentication
305      */
306     function disableAuthentication() public;
307 }
308 
309 
310 /**
311  * IWingsAdapter
312  * 
313  * WINGS DAO Price Discovery & Promotion Pre-Beta https://www.wings.ai
314  *
315  * #created 04/10/2017
316  * #author Frank Bonnet
317  */
318 interface IWingsAdapter {
319 
320     /**
321      * Get the total raised amount of Ether
322      *
323      * Can only increase, meaning if you withdraw ETH from the wallet, it should be not modified (you can use two fields 
324      * to keep one with a total accumulated amount) amount of ETH in contract and totalCollected for total amount of ETH collected
325      *
326      * @return Total raised Ether amount
327      */
328     function totalCollected() public view returns (uint);
329 }
330 
331 
332 /**
333  * IPersonalCrowdsaleProxy
334  *
335  * #created 22/11/2017
336  * #author Frank Bonnet
337  */
338 interface IPersonalCrowdsaleProxy {
339 
340     /**
341      * Receive ether and issue tokens
342      * 
343      * This function requires that msg.sender is not a contract. This is required because it's 
344      * not possible for a contract to specify a gas amount when calling the (internal) send() 
345      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
346      * 
347      * Contracts can call the contribute() function instead
348      */
349     function () public payable;
350 }
351 
352 
353 /**
354  * PersonalCrowdsaleProxy
355  *
356  * #created 22/11/2017
357  * #author Frank Bonnet
358  */
359 contract PersonalCrowdsaleProxy is IPersonalCrowdsaleProxy {
360 
361     address public owner;
362     ICrowdsale public target;
363     
364 
365     /**
366      * Deploy proxy
367      *
368      * @param _owner Owner of the proxy
369      * @param _target Target crowdsale
370      */
371     function PersonalCrowdsaleProxy(address _owner, address _target) public {
372         target = ICrowdsale(_target);
373         owner = _owner;
374     }
375 
376 
377     /**
378      * Receive contribution and forward to the target crowdsale
379      * 
380      * This function requires that msg.sender is not a contract. This is required because it's 
381      * not possible for a contract to specify a gas amount when calling the (internal) send() 
382      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
383      */
384     function () public payable {
385         target.contributeFor.value(msg.value)(owner);
386     }
387 }
388 
389 
390 /**
391  * ICrowdsaleProxy
392  *
393  * #created 23/11/2017
394  * #author Frank Bonnet
395  */
396 interface ICrowdsaleProxy {
397 
398     /**
399      * Receive ether and issue tokens to the sender
400      * 
401      * This function requires that msg.sender is not a contract. This is required because it's 
402      * not possible for a contract to specify a gas amount when calling the (internal) send() 
403      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
404      * 
405      * Contracts can call the contribute() function instead
406      */
407     function () public payable;
408 
409 
410     /**
411      * Receive ether and issue tokens to the sender
412      *
413      * @return The accepted ether amount
414      */
415     function contribute() public payable returns (uint);
416 
417 
418     /**
419      * Receive ether and issue tokens to `_beneficiary`
420      *
421      * @param _beneficiary The account that receives the tokens
422      * @return The accepted ether amount
423      */
424     function contributeFor(address _beneficiary) public payable returns (uint);
425 }
426 
427 
428 /**
429  * CrowdsaleProxy
430  *
431  * #created 22/11/2017
432  * #author Frank Bonnet
433  */
434 contract CrowdsaleProxy is ICrowdsaleProxy {
435 
436     address public owner;
437     ICrowdsale public target;
438     
439 
440     /**
441      * Deploy proxy
442      *
443      * @param _owner Owner of the proxy
444      * @param _target Target crowdsale
445      */
446     function CrowdsaleProxy(address _owner, address _target) public {
447         target = ICrowdsale(_target);
448         owner = _owner;
449     }
450 
451 
452     /**
453      * Receive contribution and forward to the crowdsale
454      * 
455      * This function requires that msg.sender is not a contract. This is required because it's 
456      * not possible for a contract to specify a gas amount when calling the (internal) send() 
457      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
458      */
459     function () public payable {
460         target.contributeFor.value(msg.value)(msg.sender);
461     }
462 
463 
464     /**
465      * Receive ether and issue tokens to the sender
466      *
467      * @return The accepted ether amount
468      */
469     function contribute() public payable returns (uint) {
470         target.contributeFor.value(msg.value)(msg.sender);
471     }
472 
473 
474     /**
475      * Receive ether and issue tokens to `_beneficiary`
476      *
477      * @param _beneficiary The account that receives the tokens
478      * @return The accepted ether amount
479      */
480     function contributeFor(address _beneficiary) public payable returns (uint) {
481         target.contributeFor.value(msg.value)(_beneficiary);
482     }
483 }
484 
485 
486 /**
487  * ICrowdsale
488  *
489  * Base crowdsale interface to manage the sale of 
490  * an ERC20 token
491  *
492  * #created 09/09/2017
493  * #author Frank Bonnet
494  */
495 interface ICrowdsale {
496 
497     /**
498      * Returns true if the contract is currently in the presale phase
499      *
500      * @return True if in presale phase
501      */
502     function isInPresalePhase() public view returns (bool);
503 
504 
505     /**
506      * Returns true if the contract is currently in the ended stage
507      *
508      * @return True if ended
509      */
510     function isEnded() public view returns (bool);
511 
512 
513     /**
514      * Returns true if `_beneficiary` has a balance allocated
515      *
516      * @param _beneficiary The account that the balance is allocated for
517      * @param _releaseDate The date after which the balance can be withdrawn
518      * @return True if there is a balance that belongs to `_beneficiary`
519      */
520     function hasBalance(address _beneficiary, uint _releaseDate) public view returns (bool);
521 
522 
523     /** 
524      * Get the allocated token balance of `_owner`
525      * 
526      * @param _owner The address from which the allocated token balance will be retrieved
527      * @return The allocated token balance
528      */
529     function balanceOf(address _owner) public view returns (uint);
530 
531 
532     /** 
533      * Get the allocated eth balance of `_owner`
534      * 
535      * @param _owner The address from which the allocated eth balance will be retrieved
536      * @return The allocated eth balance
537      */
538     function ethBalanceOf(address _owner) public view returns (uint);
539 
540 
541     /** 
542      * Get invested and refundable balance of `_owner` (only contributions during the ICO phase are registered)
543      * 
544      * @param _owner The address from which the refundable balance will be retrieved
545      * @return The invested refundable balance
546      */
547     function refundableEthBalanceOf(address _owner) public view returns (uint);
548 
549 
550     /**
551      * Returns the rate and bonus release date
552      *
553      * @param _phase The phase to use while determining the rate
554      * @param _volume The amount wei used to determine what volume multiplier to use
555      * @return The rate used in `_phase` multiplied by the corresponding volume multiplier
556      */
557     function getRate(uint _phase, uint _volume) public view returns (uint);
558 
559 
560     /**
561      * Convert `_wei` to an amount in tokens using 
562      * the `_rate`
563      *
564      * @param _wei amount of wei to convert
565      * @param _rate rate to use for the conversion
566      * @return Amount in tokens
567      */
568     function toTokens(uint _wei, uint _rate) public view returns (uint);
569 
570 
571     /**
572      * Receive ether and issue tokens to the sender
573      * 
574      * This function requires that msg.sender is not a contract. This is required because it's 
575      * not possible for a contract to specify a gas amount when calling the (internal) send() 
576      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
577      * 
578      * Contracts can call the contribute() function instead
579      */
580     function () public payable;
581 
582 
583     /**
584      * Receive ether and issue tokens to the sender
585      *
586      * @return The accepted ether amount
587      */
588     function contribute() public payable returns (uint);
589 
590 
591     /**
592      * Receive ether and issue tokens to `_beneficiary`
593      *
594      * @param _beneficiary The account that receives the tokens
595      * @return The accepted ether amount
596      */
597     function contributeFor(address _beneficiary) public payable returns (uint);
598 
599 
600     /**
601      * Withdraw allocated tokens
602      */
603     function withdrawTokens() public;
604 
605 
606     /**
607      * Withdraw allocated ether
608      */
609     function withdrawEther() public;
610 
611 
612     /**
613      * Refund in the case of an unsuccessful crowdsale. The 
614      * crowdsale is considered unsuccessful if minAmount was 
615      * not raised before end of the crowdsale
616      */
617     function refund() public;
618 }
619 
620 
621 /**
622  * Crowdsale
623  *
624  * Abstract base crowdsale contract that manages the sale of 
625  * an ERC20 token
626  *
627  * #created 29/09/2017
628  * #author Frank Bonnet
629  */
630 contract Crowdsale is ICrowdsale, Ownership {
631 
632     enum Stages {
633         Deploying,
634         Deployed,
635         InProgress,
636         Ended
637     }
638 
639     struct Balance {
640         uint eth;
641         uint tokens;
642         uint index;
643     }
644 
645     struct Percentage {
646         uint eth;
647         uint tokens;
648         bool overwriteReleaseDate;
649         uint fixedReleaseDate;
650         uint index; 
651     }
652 
653     struct Payout {
654         uint percentage;
655         uint vestingPeriod;
656     }
657 
658     struct Phase {
659         uint rate;
660         uint end;
661         uint bonusReleaseDate;
662         bool useVolumeMultiplier;
663     }
664 
665     struct VolumeMultiplier {
666         uint rateMultiplier;
667         uint bonusReleaseDateMultiplier;
668     }
669 
670     // Crowdsale details
671     uint public baseRate;
672     uint public minAmount; 
673     uint public maxAmount; 
674     uint public minAcceptedAmount;
675     uint public minAmountPresale; 
676     uint public maxAmountPresale;
677     uint public minAcceptedAmountPresale;
678 
679     // Company address
680     address public beneficiary; 
681 
682     // Denominators
683     uint internal percentageDenominator;
684     uint internal tokenDenominator;
685 
686     // Crowdsale state
687     uint public start;
688     uint public presaleEnd;
689     uint public crowdsaleEnd;
690     uint public raised;
691     uint public allocatedEth;
692     uint public allocatedTokens;
693     Stages public stage;
694 
695     // Token contract
696     IManagedToken public token;
697 
698     // Invested balances
699     mapping (address => uint) private balances;
700 
701     // Alocated balances
702     mapping (address => mapping(uint => Balance)) private allocated;
703     mapping(address => uint[]) private allocatedIndex;
704 
705     // Stakeholders
706     mapping (address => Percentage) private stakeholderPercentages;
707     address[] private stakeholderPercentagesIndex;
708     Payout[] private stakeholdersPayouts;
709 
710     // Crowdsale phases
711     Phase[] private phases;
712 
713     // Volume multipliers
714     mapping (uint => VolumeMultiplier) private volumeMultipliers;
715     uint[] private volumeMultiplierThresholds;
716 
717     
718     /**
719      * Throw if at stage other than current stage
720      * 
721      * @param _stage expected stage to test for
722      */
723     modifier at_stage(Stages _stage) {
724         require(stage == _stage);
725         _;
726     }
727 
728 
729     /**
730      * Only after crowdsaleEnd plus `_time`
731      * 
732      * @param _time Time to pass
733      */
734     modifier only_after(uint _time) {
735         require(now > crowdsaleEnd + _time);
736         _;
737     }
738 
739 
740     /**
741      * Only after crowdsale
742      */
743     modifier only_after_crowdsale() {
744         require(now > crowdsaleEnd);
745         _;
746     }
747 
748 
749     /**
750      * Throw if sender is not beneficiary
751      */
752     modifier only_beneficiary() {
753         require(beneficiary == msg.sender);
754         _;
755     }
756 
757 
758     // Events
759     event ProxyCreated(address proxy, address beneficiary);
760 
761 
762     /**
763      * Allows the implementing contract to validate a 
764      * contributing account
765      *
766      * @param _contributor Address that is being validated
767      * @return Wheter the contributor is accepted or not
768      */
769     function isAcceptedContributor(address _contributor) internal view returns (bool);
770 
771 
772     /**
773      * Start in the deployed stage
774      */
775     function Crowdsale() public {
776         stage = Stages.Deploying;
777     }
778 
779 
780     /**
781      * Setup the crowdsale
782      *
783      * @param _start The timestamp of the start date
784      * @param _token The token that is sold
785      * @param _tokenDenominator The token amount of decimals that the token uses
786      * @param _percentageDenominator The percision of percentages
787      * @param _minAmountPresale The min cap for the presale
788      * @param _maxAmountPresale The max cap for the presale
789      * @param _minAcceptedAmountPresale The lowest accepted amount during the presale phase
790      * @param _minAmount The min cap for the ICO
791      * @param _maxAmount The max cap for the ICO
792      * @param _minAcceptedAmount The lowest accepted amount during the ICO phase
793      */
794     function setup(uint _start, address _token, uint _tokenDenominator, uint _percentageDenominator, uint _minAmountPresale, uint _maxAmountPresale, uint _minAcceptedAmountPresale, uint _minAmount, uint _maxAmount, uint _minAcceptedAmount) public only_owner at_stage(Stages.Deploying) {
795         token = IManagedToken(_token);
796         tokenDenominator = _tokenDenominator;
797         percentageDenominator = _percentageDenominator;
798         start = _start;
799         minAmountPresale = _minAmountPresale;
800         maxAmountPresale = _maxAmountPresale;
801         minAcceptedAmountPresale = _minAcceptedAmountPresale;
802         minAmount = _minAmount;
803         maxAmount = _maxAmount;
804         minAcceptedAmount = _minAcceptedAmount;
805     }
806 
807 
808     /**
809      * Setup rates and phases
810      *
811      * @param _baseRate The rate without bonus
812      * @param _phaseRates The rates for each phase
813      * @param _phasePeriods The periods that each phase lasts (first phase is the presale phase)
814      * @param _phaseBonusLockupPeriods The lockup period that each phase lasts
815      * @param _phaseUsesVolumeMultiplier Wheter or not volume bonusses are used in the respective phase
816      */
817     function setupPhases(uint _baseRate, uint[] _phaseRates, uint[] _phasePeriods, uint[] _phaseBonusLockupPeriods, bool[] _phaseUsesVolumeMultiplier) public only_owner at_stage(Stages.Deploying) {
818         baseRate = _baseRate;
819         presaleEnd = start + _phasePeriods[0]; // First phase is expected to be the presale phase
820         crowdsaleEnd = start; // Plus the sum of the rate phases
821 
822         for (uint i = 0; i < _phaseRates.length; i++) {
823             crowdsaleEnd += _phasePeriods[i];
824             phases.push(Phase(_phaseRates[i], crowdsaleEnd, 0, _phaseUsesVolumeMultiplier[i]));
825         }
826 
827         for (uint ii = 0; ii < _phaseRates.length; ii++) {
828             if (_phaseBonusLockupPeriods[ii] > 0) {
829                 phases[ii].bonusReleaseDate = crowdsaleEnd + _phaseBonusLockupPeriods[ii];
830             }
831         }
832     }
833 
834 
835     /**
836      * Setup stakeholders
837      *
838      * @param _stakeholders The addresses of the stakeholders (first stakeholder is the beneficiary)
839      * @param _stakeholderEthPercentages The eth percentages of the stakeholders
840      * @param _stakeholderTokenPercentages The token percentages of the stakeholders
841      * @param _stakeholderTokenPayoutOverwriteReleaseDates Wheter the vesting period is overwritten for the respective stakeholder
842      * @param _stakeholderTokenPayoutFixedReleaseDates The vesting period after which the whole percentage of the tokens is released to the respective stakeholder
843      * @param _stakeholderTokenPayoutPercentages The percentage of the tokens that is released at the respective date
844      * @param _stakeholderTokenPayoutVestingPeriods The vesting period after which the respective percentage of the tokens is released
845      */
846     function setupStakeholders(address[] _stakeholders, uint[] _stakeholderEthPercentages, uint[] _stakeholderTokenPercentages, bool[] _stakeholderTokenPayoutOverwriteReleaseDates, uint[] _stakeholderTokenPayoutFixedReleaseDates, uint[] _stakeholderTokenPayoutPercentages, uint[] _stakeholderTokenPayoutVestingPeriods) public only_owner at_stage(Stages.Deploying) {
847         beneficiary = _stakeholders[0]; // First stakeholder is expected to be the beneficiary
848         for (uint i = 0; i < _stakeholders.length; i++) {
849             stakeholderPercentagesIndex.push(_stakeholders[i]);
850             stakeholderPercentages[_stakeholders[i]] = Percentage(
851                 _stakeholderEthPercentages[i], 
852                 _stakeholderTokenPercentages[i], 
853                 _stakeholderTokenPayoutOverwriteReleaseDates[i],
854                 _stakeholderTokenPayoutFixedReleaseDates[i], i);
855         }
856 
857         // Percentages add up to 100
858         for (uint ii = 0; ii < _stakeholderTokenPayoutPercentages.length; ii++) {
859             stakeholdersPayouts.push(Payout(_stakeholderTokenPayoutPercentages[ii], _stakeholderTokenPayoutVestingPeriods[ii]));
860         }
861     }
862 
863     
864     /**
865      * Setup volume multipliers
866      *
867      * @param _volumeMultiplierRates The rates will be multiplied by this value (denominated by 4)
868      * @param _volumeMultiplierLockupPeriods The lockup periods will be multiplied by this value (denominated by 4)
869      * @param _volumeMultiplierThresholds The volume thresholds for each respective multiplier
870      */
871     function setupVolumeMultipliers(uint[] _volumeMultiplierRates, uint[] _volumeMultiplierLockupPeriods, uint[] _volumeMultiplierThresholds) public only_owner at_stage(Stages.Deploying) {
872         require(phases.length > 0);
873         volumeMultiplierThresholds = _volumeMultiplierThresholds;
874         for (uint i = 0; i < volumeMultiplierThresholds.length; i++) {
875             volumeMultipliers[volumeMultiplierThresholds[i]] = VolumeMultiplier(_volumeMultiplierRates[i], _volumeMultiplierLockupPeriods[i]);
876         }
877     }
878     
879 
880     /**
881      * After calling the deploy function the crowdsale
882      * rules become immutable 
883      */
884     function deploy() public only_owner at_stage(Stages.Deploying) {
885         require(phases.length > 0);
886         require(stakeholderPercentagesIndex.length > 0);
887         stage = Stages.Deployed;
888     }
889 
890 
891     /**
892      * Deploy a contract that serves as a proxy to 
893      * the crowdsale
894      *
895      * @return The address of the deposit address
896      */
897     function createDepositAddress() public returns (address) {
898         address proxy = new CrowdsaleProxy(msg.sender, this);
899         ProxyCreated(proxy, msg.sender);
900         return proxy;
901     }
902 
903 
904     /**
905      * Deploy a contract that serves as a proxy to 
906      * the crowdsale
907      *
908      * @param _beneficiary The owner of the proxy
909      * @return The address of the deposit address
910      */
911     function createDepositAddressFor(address _beneficiary) public returns (address) {
912         address proxy = new CrowdsaleProxy(_beneficiary, this);
913         ProxyCreated(proxy, _beneficiary);
914         return proxy;
915     }
916 
917 
918     /**
919      * Deploy a contract that serves as a proxy to 
920      * the crowdsale
921      *
922      * Contributions through this address will be made 
923      * for msg.sender
924      *
925      * @return The address of the deposit address
926      */
927     function createPersonalDepositAddress() public returns (address) {
928         address proxy = new PersonalCrowdsaleProxy(msg.sender, this);
929         ProxyCreated(proxy, msg.sender);
930         return proxy;
931     }
932 
933 
934     /**
935      * Deploy a contract that serves as a proxy to 
936      * the crowdsale
937      *
938      * Contributions through this address will be made 
939      * for `_beneficiary`
940      *
941      * @param _beneficiary The owner of the proxy
942      * @return The address of the deposit address
943      */
944     function createPersonalDepositAddressFor(address _beneficiary) public returns (address) {
945         address proxy = new PersonalCrowdsaleProxy(_beneficiary, this);
946         ProxyCreated(proxy, _beneficiary);
947         return proxy;
948     }
949 
950 
951     /**
952      * Prove that beneficiary is able to sign transactions 
953      * and start the crowdsale
954      */
955     function confirmBeneficiary() public only_beneficiary at_stage(Stages.Deployed) {
956         stage = Stages.InProgress;
957     }
958 
959 
960     /**
961      * Returns true if the contract is currently in the presale phase
962      *
963      * @return True if in presale phase
964      */
965     function isInPresalePhase() public view returns (bool) {
966         return stage == Stages.InProgress && now >= start && now <= presaleEnd;
967     }
968 
969 
970     /**
971      * Returns true if the contract is currently in the ended stage
972      *
973      * @return True if ended
974      */
975     function isEnded() public view returns (bool) {
976         return stage == Stages.Ended;
977     }
978 
979 
980     /**
981      * Returns true if `_beneficiary` has a balance allocated
982      *
983      * @param _beneficiary The account that the balance is allocated for
984      * @param _releaseDate The date after which the balance can be withdrawn
985      * @return True if there is a balance that belongs to `_beneficiary`
986      */
987     function hasBalance(address _beneficiary, uint _releaseDate) public view returns (bool) {
988         return allocatedIndex[_beneficiary].length > 0 && _releaseDate == allocatedIndex[_beneficiary][allocated[_beneficiary][_releaseDate].index];
989     }
990 
991 
992     /** 
993      * Get the allocated token balance of `_owner`
994      * 
995      * @param _owner The address from which the allocated token balance will be retrieved
996      * @return The allocated token balance
997      */
998     function balanceOf(address _owner) public view returns (uint) {
999         uint sum = 0;
1000         for (uint i = 0; i < allocatedIndex[_owner].length; i++) {
1001             sum += allocated[_owner][allocatedIndex[_owner][i]].tokens;
1002         }
1003 
1004         return sum;
1005     }
1006 
1007 
1008     /** 
1009      * Get the allocated eth balance of `_owner`
1010      * 
1011      * @param _owner The address from which the allocated eth balance will be retrieved
1012      * @return The allocated eth balance
1013      */
1014     function ethBalanceOf(address _owner) public view returns (uint) {
1015         uint sum = 0;
1016         for (uint i = 0; i < allocatedIndex[_owner].length; i++) {
1017             sum += allocated[_owner][allocatedIndex[_owner][i]].eth;
1018         }
1019 
1020         return sum;
1021     }
1022 
1023 
1024     /** 
1025      * Get invested and refundable balance of `_owner` (only contributions during the ICO phase are registered)
1026      * 
1027      * @param _owner The address from which the refundable balance will be retrieved
1028      * @return The invested refundable balance
1029      */
1030     function refundableEthBalanceOf(address _owner) public view returns (uint) {
1031         return now > crowdsaleEnd && raised < minAmount ? balances[_owner] : 0;
1032     }
1033 
1034 
1035     /**
1036      * Returns the current phase based on the current time
1037      *
1038      * @return The index of the current phase
1039      */
1040     function getCurrentPhase() public view returns (uint) {
1041         for (uint i = 0; i < phases.length; i++) {
1042             if (now <= phases[i].end) {
1043                 return i;
1044                 break;
1045             }
1046         }
1047 
1048         return uint(-1); // Does not exist (underflow)
1049     }
1050 
1051 
1052     /**
1053      * Returns the rate and bonus release date
1054      *
1055      * @param _phase The phase to use while determining the rate
1056      * @param _volume The amount wei used to determin what volume multiplier to use
1057      * @return The rate used in `_phase` multiplied by the corresponding volume multiplier
1058      */
1059     function getRate(uint _phase, uint _volume) public view returns (uint) {
1060         uint rate = 0;
1061         if (stage == Stages.InProgress && now >= start) {
1062             Phase storage phase = phases[_phase];
1063             rate = phase.rate;
1064 
1065             // Find volume multiplier
1066             if (phase.useVolumeMultiplier && volumeMultiplierThresholds.length > 0 && _volume >= volumeMultiplierThresholds[0]) {
1067                 for (uint i = volumeMultiplierThresholds.length; i > 0; i--) {
1068                     if (_volume >= volumeMultiplierThresholds[i - 1]) {
1069                         VolumeMultiplier storage multiplier = volumeMultipliers[volumeMultiplierThresholds[i - 1]];
1070                         rate += phase.rate * multiplier.rateMultiplier / percentageDenominator;
1071                         break;
1072                     }
1073                 }
1074             }
1075         }
1076         
1077         return rate;
1078     }
1079 
1080 
1081     /**
1082      * Get distribution data based on the current phase and 
1083      * the volume in wei that is being distributed
1084      * 
1085      * @param _phase The current crowdsale phase
1086      * @param _volume The amount wei used to determine what volume multiplier to use
1087      * @return Volumes and corresponding release dates
1088      */
1089     function getDistributionData(uint _phase, uint _volume) internal view returns (uint[], uint[]) {
1090         Phase storage phase = phases[_phase];
1091         uint remainingVolume = _volume;
1092 
1093         bool usingMultiplier = false;
1094         uint[] memory volumes = new uint[](1);
1095         uint[] memory releaseDates = new uint[](1);
1096 
1097         // Find volume multipliers
1098         if (phase.useVolumeMultiplier && volumeMultiplierThresholds.length > 0 && _volume >= volumeMultiplierThresholds[0]) {
1099             uint phaseReleasePeriod = phase.bonusReleaseDate - crowdsaleEnd;
1100             for (uint i = volumeMultiplierThresholds.length; i > 0; i--) {
1101                 if (_volume >= volumeMultiplierThresholds[i - 1]) {
1102                     if (!usingMultiplier) {
1103                         volumes = new uint[](i + 1);
1104                         releaseDates = new uint[](i + 1);
1105                         usingMultiplier = true;
1106                     }
1107 
1108                     VolumeMultiplier storage multiplier = volumeMultipliers[volumeMultiplierThresholds[i - 1]];
1109                     uint releaseDate = phase.bonusReleaseDate + phaseReleasePeriod * multiplier.bonusReleaseDateMultiplier / percentageDenominator;
1110                     uint volume = remainingVolume - volumeMultiplierThresholds[i - 1];
1111 
1112                     // Store increment
1113                     volumes[i] = volume;
1114                     releaseDates[i] = releaseDate;
1115 
1116                     remainingVolume -= volume;
1117                 }
1118             }
1119         }
1120 
1121         // Store increment
1122         volumes[0] = remainingVolume;
1123         releaseDates[0] = phase.bonusReleaseDate;
1124 
1125         return (volumes, releaseDates);
1126     }
1127 
1128 
1129     /**
1130      * Convert `_wei` to an amount in tokens using 
1131      * the `_rate`
1132      *
1133      * @param _wei amount of wei to convert
1134      * @param _rate rate to use for the conversion
1135      * @return Amount in tokens
1136      */
1137     function toTokens(uint _wei, uint _rate) public view returns (uint) {
1138         return _wei * _rate * tokenDenominator / 1 ether;
1139     }
1140 
1141 
1142     /**
1143      * Receive Eth and issue tokens to the sender
1144      * 
1145      * This function requires that msg.sender is not a contract. This is required because it's 
1146      * not possible for a contract to specify a gas amount when calling the (internal) send() 
1147      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
1148      * 
1149      * Contracts can call the contribute() function instead
1150      */
1151     function () public payable {
1152         require(msg.sender == tx.origin);
1153         _handleTransaction(msg.sender, msg.value);
1154     }
1155 
1156 
1157     /**
1158      * Receive ether and issue tokens to the sender
1159      *
1160      * @return The accepted ether amount
1161      */
1162     function contribute() public payable returns (uint) {
1163         return _handleTransaction(msg.sender, msg.value);
1164     }
1165 
1166 
1167     /**
1168      * Receive ether and issue tokens to `_beneficiary`
1169      *
1170      * @param _beneficiary The account that receives the tokens
1171      * @return The accepted ether amount
1172      */
1173     function contributeFor(address _beneficiary) public payable returns (uint) {
1174         return _handleTransaction(_beneficiary, msg.value);
1175     }
1176 
1177 
1178     /**
1179      * Function to end the crowdsale by setting 
1180      * the stage to Ended
1181      */
1182     function endCrowdsale() public at_stage(Stages.InProgress) {
1183         require(now > crowdsaleEnd || raised >= maxAmount);
1184         require(raised >= minAmount);
1185         stage = Stages.Ended;
1186 
1187         // Unlock token
1188         if (!token.unlock()) {
1189             revert();
1190         }
1191 
1192         // Allocate tokens (no allocation can be done after this period)
1193         uint totalTokenSupply = IToken(token).totalSupply() + allocatedTokens;
1194         for (uint i = 0; i < stakeholdersPayouts.length; i++) {
1195             Payout storage p = stakeholdersPayouts[i];
1196             _allocateStakeholdersTokens(totalTokenSupply * p.percentage / percentageDenominator, now + p.vestingPeriod);
1197         }
1198 
1199         // Allocate remaining ETH
1200         _allocateStakeholdersEth(this.balance - allocatedEth, 0);
1201     }
1202 
1203 
1204     /**
1205      * Withdraw allocated tokens
1206      */
1207     function withdrawTokens() public {
1208         uint tokensToSend = 0;
1209         for (uint i = 0; i < allocatedIndex[msg.sender].length; i++) {
1210             uint releaseDate = allocatedIndex[msg.sender][i];
1211             if (releaseDate <= now) {
1212                 Balance storage b = allocated[msg.sender][releaseDate];
1213                 tokensToSend += b.tokens;
1214                 b.tokens = 0;
1215             }
1216         }
1217 
1218         if (tokensToSend > 0) {
1219             allocatedTokens -= tokensToSend;
1220             if (!token.issue(msg.sender, tokensToSend)) {
1221                 revert();
1222             }
1223         }
1224     }
1225 
1226 
1227     /**
1228      * Withdraw allocated ether
1229      */
1230     function withdrawEther() public {
1231         uint ethToSend = 0;
1232         for (uint i = 0; i < allocatedIndex[msg.sender].length; i++) {
1233             uint releaseDate = allocatedIndex[msg.sender][i];
1234             if (releaseDate <= now) {
1235                 Balance storage b = allocated[msg.sender][releaseDate];
1236                 ethToSend += b.eth;
1237                 b.eth = 0;
1238             }
1239         }
1240 
1241         if (ethToSend > 0) {
1242             allocatedEth -= ethToSend;
1243             if (!msg.sender.send(ethToSend)) {
1244                 revert();
1245             }
1246         }
1247     }
1248 
1249 
1250     /**
1251      * Refund in the case of an unsuccessful crowdsale. The 
1252      * crowdsale is considered unsuccessful if minAmount was 
1253      * not raised before end of the crowdsale
1254      */
1255     function refund() public only_after_crowdsale at_stage(Stages.InProgress) {
1256         require(raised < minAmount);
1257 
1258         uint receivedAmount = balances[msg.sender];
1259         balances[msg.sender] = 0;
1260 
1261         if (receivedAmount > 0 && !msg.sender.send(receivedAmount)) {
1262             balances[msg.sender] = receivedAmount;
1263         }
1264     }
1265 
1266 
1267     /**
1268      * Failsafe and clean-up mechanism
1269      */
1270     function destroy() public only_beneficiary only_after(2 years) {
1271         selfdestruct(beneficiary);
1272     }
1273 
1274 
1275     /**
1276      * Handle incoming transaction
1277      * 
1278      * @param _beneficiary Tokens are issued to this account
1279      * @param _received The amount that was received
1280      * @return The accepted ether amount
1281      */
1282     function _handleTransaction(address _beneficiary, uint _received) internal at_stage(Stages.InProgress) returns (uint) {
1283         require(now >= start && now <= crowdsaleEnd);
1284         require(isAcceptedContributor(_beneficiary));
1285 
1286         if (isInPresalePhase()) {
1287             return _handlePresaleTransaction(
1288                 _beneficiary, _received);
1289         } else {
1290             return _handlePublicsaleTransaction(
1291                 _beneficiary, _received);
1292         }
1293     }
1294 
1295 
1296     /**
1297      * Handle incoming transaction during the presale phase
1298      * 
1299      * @param _beneficiary Tokens are issued to this account
1300      * @param _received The amount that was received
1301      * @return The accepted ether amount
1302      */
1303     function _handlePresaleTransaction(address _beneficiary, uint _received) private returns (uint) {
1304         require(_received >= minAcceptedAmountPresale);
1305         require(raised < maxAmountPresale);
1306 
1307         uint acceptedAmount;
1308         if (raised + _received > maxAmountPresale) {
1309             acceptedAmount = maxAmountPresale - raised;
1310         } else {
1311             acceptedAmount = _received;
1312         }
1313 
1314         raised += acceptedAmount;
1315 
1316         // During the presale phase - Non refundable
1317         _allocateStakeholdersEth(acceptedAmount, 0); 
1318 
1319         // Issue tokens
1320         _distributeTokens(_beneficiary, _received, acceptedAmount);
1321         return acceptedAmount;
1322     }
1323 
1324 
1325     /**
1326      * Handle incoming transaction during the publicsale phase
1327      * 
1328      * @param _beneficiary Tokens are issued to this account
1329      * @param _received The amount that was received
1330      * @return The accepted ether amount
1331      */
1332     function _handlePublicsaleTransaction(address _beneficiary, uint _received) private returns (uint) {
1333         require(_received >= minAcceptedAmount);
1334         require(raised >= minAmountPresale);
1335         require(raised < maxAmount);
1336 
1337         uint acceptedAmount;
1338         if (raised + _received > maxAmount) {
1339             acceptedAmount = maxAmount - raised;
1340         } else {
1341             acceptedAmount = _received;
1342         }
1343 
1344         raised += acceptedAmount;
1345         
1346         // During the ICO phase - 100% refundable
1347         balances[_beneficiary] += acceptedAmount; 
1348 
1349         // Issue tokens
1350         _distributeTokens(_beneficiary, _received, acceptedAmount);
1351         return acceptedAmount;
1352     }
1353 
1354 
1355     /**
1356      * Distribute tokens 
1357      *
1358      * Tokens can be issued by instructing the token contract to create new tokens or by 
1359      * allocating tokens and instructing the token contract to create the tokens later
1360      * 
1361      * @param _beneficiary Tokens are issued to this account
1362      * @param _received The amount that was received
1363      * @param _acceptedAmount The amount that was accepted
1364      */
1365     function _distributeTokens(address _beneficiary, uint _received, uint _acceptedAmount) private {
1366         uint tokensToIssue = 0;
1367         uint phase = getCurrentPhase();
1368         var rate = getRate(phase, _acceptedAmount);
1369         if (rate == 0) {
1370             revert(); // Paused phase
1371         }
1372 
1373         // Volume multipliers
1374         var (volumes, releaseDates) = getDistributionData(
1375             phase, _acceptedAmount);
1376         
1377         // Allocate tokens
1378         for (uint i = 0; i < volumes.length; i++) {
1379             var tokensAtCurrentRate = toTokens(volumes[i], rate);
1380             if (rate > baseRate && releaseDates[i] > now) {
1381                 uint bonusTokens = tokensAtCurrentRate * (rate - baseRate) / rate;
1382                 _allocateTokens(_beneficiary, bonusTokens, releaseDates[i]);
1383 
1384                 tokensToIssue += tokensAtCurrentRate - bonusTokens;
1385             } else {
1386                 tokensToIssue += tokensAtCurrentRate;
1387             }
1388         }
1389 
1390         // Issue tokens
1391         if (tokensToIssue > 0 && !token.issue(_beneficiary, tokensToIssue)) {
1392             revert();
1393         }
1394 
1395         // Refund due to max cap hit
1396         if (_received - _acceptedAmount > 0 && !_beneficiary.send(_received - _acceptedAmount)) {
1397             revert();
1398         }
1399     }
1400 
1401 
1402     /**
1403      * Allocate ETH
1404      *
1405      * @param _beneficiary The account to alocate the eth for
1406      * @param _amount The amount of ETH to allocate
1407      * @param _releaseDate The date after which the eth can be withdrawn
1408      */    
1409     function _allocateEth(address _beneficiary, uint _amount, uint _releaseDate) internal {
1410         if (hasBalance(_beneficiary, _releaseDate)) {
1411             allocated[_beneficiary][_releaseDate].eth += _amount;
1412         } else {
1413             allocated[_beneficiary][_releaseDate] = Balance(
1414                 _amount, 0, allocatedIndex[_beneficiary].push(_releaseDate) - 1);
1415         }
1416 
1417         allocatedEth += _amount;
1418     }
1419 
1420 
1421     /**
1422      * Allocate Tokens
1423      *
1424      * @param _beneficiary The account to allocate the tokens for
1425      * @param _amount The amount of tokens to allocate
1426      * @param _releaseDate The date after which the tokens can be withdrawn
1427      */    
1428     function _allocateTokens(address _beneficiary, uint _amount, uint _releaseDate) internal {
1429         if (hasBalance(_beneficiary, _releaseDate)) {
1430             allocated[_beneficiary][_releaseDate].tokens += _amount;
1431         } else {
1432             allocated[_beneficiary][_releaseDate] = Balance(
1433                 0, _amount, allocatedIndex[_beneficiary].push(_releaseDate) - 1);
1434         }
1435 
1436         allocatedTokens += _amount;
1437     }
1438 
1439 
1440     /**
1441      * Allocate ETH for stakeholders
1442      *
1443      * @param _amount The amount of ETH to allocate
1444      * @param _releaseDate The date after which the eth can be withdrawn
1445      */    
1446     function _allocateStakeholdersEth(uint _amount, uint _releaseDate) internal {
1447         for (uint i = 0; i < stakeholderPercentagesIndex.length; i++) {
1448             Percentage storage p = stakeholderPercentages[stakeholderPercentagesIndex[i]];
1449             if (p.eth > 0) {
1450                 _allocateEth(stakeholderPercentagesIndex[i], _amount * p.eth / percentageDenominator, _releaseDate);
1451             }
1452         }
1453     }
1454 
1455 
1456     /**
1457      * Allocate Tokens for stakeholders
1458      *
1459      * @param _amount The amount of tokens created
1460      * @param _releaseDate The date after which the tokens can be withdrawn (unless overwitten)
1461      */    
1462     function _allocateStakeholdersTokens(uint _amount, uint _releaseDate) internal {
1463         for (uint i = 0; i < stakeholderPercentagesIndex.length; i++) {
1464             Percentage storage p = stakeholderPercentages[stakeholderPercentagesIndex[i]];
1465             if (p.tokens > 0) {
1466                 _allocateTokens(
1467                     stakeholderPercentagesIndex[i], 
1468                     _amount * p.tokens / percentageDenominator, 
1469                     p.overwriteReleaseDate ? p.fixedReleaseDate : _releaseDate);
1470             }
1471         }
1472     }
1473 }
1474 
1475 
1476 /**
1477  * KATXCrowdsale
1478  *
1479  * BitcoinATMs for Everyone
1480  *
1481  * With KriptoATM now everyone has access to Bitcoin, Ethereum, and a wide range of other cryptocurrencies. We let you 
1482  * bring crypto to new places - with our innovative new features, state-of-the-art technology and our simple-to-use approach.
1483  *
1484  * #created 10/11/2017
1485  * #author Frank Bonnet
1486  */
1487 contract KATXCrowdsale is Crowdsale, TokenRetriever, IAuthenticationManager, IWingsAdapter {
1488 
1489     // Authentication
1490     IAuthenticator private authenticator;
1491     bool private requireAuthentication;
1492 
1493 
1494     /**
1495      * Setup authentication
1496      *
1497      * @param _authenticator The address of the authenticator (whitelist)
1498      * @param _requireAuthentication Wether the crowdale requires contributors to be authenticated
1499      */
1500     function setupAuthentication(address _authenticator, bool _requireAuthentication) public only_owner at_stage(Stages.Deploying) {
1501         authenticator = IAuthenticator(_authenticator);
1502         requireAuthentication = _requireAuthentication;
1503     }
1504 
1505 
1506     /**
1507      * Returns true if `_member` is allowed to contribute
1508      *
1509      * @param _member Account that is being validated
1510      * @return Wheter the DCORP is accepted or not
1511      */
1512     function isAcceptedDcorpMember(address _member) public view returns (bool) {
1513         return isAcceptedContributor(_member);
1514     }
1515 
1516 
1517     /**
1518      * Receive a contribution from a DCORP member
1519      *
1520      * @param _member Account that is contributing
1521      */
1522     function contributeForDcorpMember(address _member) public payable {
1523         _handleTransaction(_member, msg.value);
1524     }
1525 
1526 
1527     /**
1528      * Wings integration - Get the total raised amount of Ether
1529      *
1530      * Can only increased, means if you withdraw ETH from the wallet, should be not modified (you can use two fields 
1531      * to keep one with a total accumulated amount) amount of ETH in contract and totalCollected for total amount of ETH collected
1532      *
1533      * @return Total raised Ether amount
1534      */
1535     function totalCollected() public view returns (uint) {
1536         return raised;
1537     }
1538 
1539 
1540     /**
1541      * Returns true if authentication is enabled and false 
1542      * otherwise
1543      *
1544      * @return Whether the converter is currently authenticating or not
1545      */
1546     function isAuthenticating() public view returns (bool) {
1547         return requireAuthentication;
1548     }
1549 
1550 
1551     /**
1552      * Enable authentication
1553      */
1554     function enableAuthentication() public only_owner {
1555         requireAuthentication = true;
1556     }
1557 
1558 
1559     /**
1560      * Disable authentication
1561      */
1562     function disableAuthentication() public only_owner {
1563         requireAuthentication = false;
1564     }
1565 
1566 
1567     /**
1568      * Allows the implementing contract to validate a 
1569      * contributing account
1570      *
1571      * @param _contributor Address that is being validated
1572      * @return Wheter the contributor is accepted or not
1573      */
1574     function isAcceptedContributor(address _contributor) internal view returns (bool) {
1575         return !requireAuthentication || authenticator.authenticate(_contributor);
1576     }
1577 
1578 
1579     /**
1580      * Failsafe mechanism
1581      * 
1582      * Allows the owner to retrieve tokens from the contract that 
1583      * might have been send there by accident
1584      *
1585      * @param _tokenContract The address of ERC20 compatible token
1586      */
1587     function retrieveTokens(address _tokenContract) public only_owner {
1588         super.retrieveTokens(_tokenContract);
1589 
1590         // Retrieve tokens from our token contract
1591         ITokenRetriever(token).retrieveTokens(_tokenContract);
1592     }
1593 }