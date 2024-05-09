1 pragma solidity ^0.4.18;
2 
3 /**
4  * IPausable
5  *
6  * Simple interface to pause and resume 
7  *
8  * #created 11/10/2017
9  * #author Frank Bonnet
10  */
11 interface IPausable {
12 
13 
14     /**
15      * Returns whether the implementing contract is 
16      * currently paused or not
17      *
18      * @return Whether the paused state is active
19      */
20     function isPaused() public view returns (bool);
21 
22 
23     /**
24      * Change the state to paused
25      */
26     function pause() public;
27 
28 
29     /**
30      * Change the state to resume, undo the effects 
31      * of calling pause
32      */
33     function resume() public;
34 }
35 
36 
37 /**
38  * IOwnership
39  *
40  * Perminent ownership
41  *
42  * #created 01/10/2017
43  * #author Frank Bonnet
44  */
45 interface IOwnership {
46 
47     /**
48      * Returns true if `_account` is the current owner
49      *
50      * @param _account The address to test against
51      */
52     function isOwner(address _account) public view returns (bool);
53 
54 
55     /**
56      * Gets the current owner
57      *
58      * @return address The current owner
59      */
60     function getOwner() public view returns (address);
61 }
62 
63 
64 /**
65  * Ownership
66  *
67  * Perminent ownership
68  *
69  * #created 01/10/2017
70  * #author Frank Bonnet
71  */
72 contract Ownership is IOwnership {
73 
74     // Owner
75     address internal owner;
76 
77 
78     /**
79      * Access is restricted to the current owner
80      */
81     modifier only_owner() {
82         require(msg.sender == owner);
83         _;
84     }
85 
86 
87     /**
88      * The publisher is the inital owner
89      */
90     function Ownership() public {
91         owner = msg.sender;
92     }
93 
94 
95     /**
96      * Returns true if `_account` is the current owner
97      *
98      * @param _account The address to test against
99      */
100     function isOwner(address _account) public view returns (bool) {
101         return _account == owner;
102     }
103 
104 
105     /**
106      * Gets the current owner
107      *
108      * @return address The current owner
109      */
110     function getOwner() public view returns (address) {
111         return owner;
112     }
113 }
114 
115 
116 /**
117  * ERC20 compatible token interface
118  *
119  * - Implements ERC 20 Token standard
120  * - Implements short address attack fix
121  *
122  * #created 29/09/2017
123  * #author Frank Bonnet
124  */
125 interface IToken { 
126 
127     /** 
128      * Get the total supply of tokens
129      * 
130      * @return The total supply
131      */
132     function totalSupply() public view returns (uint);
133 
134 
135     /** 
136      * Get balance of `_owner` 
137      * 
138      * @param _owner The address from which the balance will be retrieved
139      * @return The balance
140      */
141     function balanceOf(address _owner) public view returns (uint);
142 
143 
144     /** 
145      * Send `_value` token to `_to` from `msg.sender`
146      * 
147      * @param _to The address of the recipient
148      * @param _value The amount of token to be transferred
149      * @return Whether the transfer was successful or not
150      */
151     function transfer(address _to, uint _value) public returns (bool);
152 
153 
154     /** 
155      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
156      * 
157      * @param _from The address of the sender
158      * @param _to The address of the recipient
159      * @param _value The amount of token to be transferred
160      * @return Whether the transfer was successful or not
161      */
162     function transferFrom(address _from, address _to, uint _value) public returns (bool);
163 
164 
165     /** 
166      * `msg.sender` approves `_spender` to spend `_value` tokens
167      * 
168      * @param _spender The address of the account able to transfer the tokens
169      * @param _value The amount of tokens to be approved for transfer
170      * @return Whether the approval was successful or not
171      */
172     function approve(address _spender, uint _value) public returns (bool);
173 
174 
175     /** 
176      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
177      * 
178      * @param _owner The address of the account owning tokens
179      * @param _spender The address of the account able to transfer the tokens
180      * @return Amount of remaining tokens allowed to spent
181      */
182     function allowance(address _owner, address _spender) public view returns (uint);
183 }
184 
185 
186 /**
187  * IManagedToken
188  *
189  * Adds the following functionality to the basic ERC20 token
190  * - Locking
191  * - Issuing
192  * - Burning 
193  *
194  * #created 29/09/2017
195  * #author Frank Bonnet
196  */
197 interface IManagedToken { 
198 
199     /** 
200      * Returns true if the token is locked
201      * 
202      * @return Whether the token is locked
203      */
204     function isLocked() public view returns (bool);
205 
206 
207     /**
208      * Locks the token so that the transfering of value is disabled 
209      *
210      * @return Whether the unlocking was successful or not
211      */
212     function lock() public returns (bool);
213 
214 
215     /**
216      * Unlocks the token so that the transfering of value is enabled 
217      *
218      * @return Whether the unlocking was successful or not
219      */
220     function unlock() public returns (bool);
221 
222 
223     /**
224      * Issues `_value` new tokens to `_to`
225      *
226      * @param _to The address to which the tokens will be issued
227      * @param _value The amount of new tokens to issue
228      * @return Whether the tokens where sucessfully issued or not
229      */
230     function issue(address _to, uint _value) public returns (bool);
231 
232 
233     /**
234      * Burns `_value` tokens of `_from`
235      *
236      * @param _from The address that owns the tokens to be burned
237      * @param _value The amount of tokens to be burned
238      * @return Whether the tokens where sucessfully burned or not 
239      */
240     function burn(address _from, uint _value) public returns (bool);
241 }
242 
243 
244 /**
245  * ITokenRetriever
246  *
247  * Allows tokens to be retrieved from a contract
248  *
249  * #created 29/09/2017
250  * #author Frank Bonnet
251  */
252 interface ITokenRetriever {
253 
254     /**
255      * Extracts tokens from the contract
256      *
257      * @param _tokenContract The address of ERC20 compatible token
258      */
259     function retrieveTokens(address _tokenContract) public;
260 }
261 
262 
263 /**
264  * TokenRetriever
265  *
266  * Allows tokens to be retrieved from a contract
267  *
268  * #created 18/10/2017
269  * #author Frank Bonnet
270  */
271 contract TokenRetriever is ITokenRetriever {
272 
273     /**
274      * Extracts tokens from the contract
275      *
276      * @param _tokenContract The address of ERC20 compatible token
277      */
278     function retrieveTokens(address _tokenContract) public {
279         IToken tokenInstance = IToken(_tokenContract);
280         uint tokenBalance = tokenInstance.balanceOf(this);
281         if (tokenBalance > 0) {
282             tokenInstance.transfer(msg.sender, tokenBalance);
283         }
284     }
285 }
286 
287 
288 /**
289  * IAuthenticator 
290  *
291  * Authenticator interface
292  *
293  * #created 15/10/2017
294  * #author Frank Bonnet
295  */
296 interface IAuthenticator {
297     
298 
299     /**
300      * Authenticate 
301      *
302      * Returns whether `_account` is authenticated or not
303      *
304      * @param _account The account to authenticate
305      * @return whether `_account` is successfully authenticated
306      */
307     function authenticate(address _account) public view returns (bool);
308 }
309 
310 
311 /**
312  * IAuthenticationManager 
313  *
314  * Allows the authentication process to be enabled and disabled
315  *
316  * #created 15/10/2017
317  * #author Frank Bonnet
318  */
319 interface IAuthenticationManager {
320     
321 
322     /**
323      * Returns true if authentication is enabled and false 
324      * otherwise
325      *
326      * @return Whether the converter is currently authenticating or not
327      */
328     function isAuthenticating() public view returns (bool);
329 
330 
331     /**
332      * Enable authentication
333      */
334     function enableAuthentication() public;
335 
336 
337     /**
338      * Disable authentication
339      */
340     function disableAuthentication() public;
341 }
342 
343 
344 /**
345  * IWingsAdapter
346  * 
347  * WINGS DAO Price Discovery & Promotion Pre-Beta https://www.wings.ai
348  *
349  * #created 04/10/2017
350  * #author Frank Bonnet
351  */
352 interface IWingsAdapter {
353 
354     /**
355      * Get the total raised amount of Ether
356      *
357      * Can only increase, meaning if you withdraw ETH from the wallet, it should be not modified (you can use two fields 
358      * to keep one with a total accumulated amount) amount of ETH in contract and totalCollected for total amount of ETH collected
359      *
360      * @return Total raised Ether amount
361      */
362     function totalCollected() public view returns (uint);
363 }
364 
365 
366 /**
367  * IPersonalCrowdsaleProxy
368  *
369  * #created 22/11/2017
370  * #author Frank Bonnet
371  */
372 interface IPersonalCrowdsaleProxy {
373 
374     /**
375      * Receive ether and issue tokens
376      * 
377      * This function requires that msg.sender is not a contract. This is required because it's 
378      * not possible for a contract to specify a gas amount when calling the (internal) send() 
379      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
380      * 
381      * Contracts can call the contribute() function instead
382      */
383     function () public payable;
384 }
385 
386 
387 /**
388  * PersonalCrowdsaleProxy
389  *
390  * #created 22/11/2017
391  * #author Frank Bonnet
392  */
393 contract PersonalCrowdsaleProxy is IPersonalCrowdsaleProxy {
394 
395     address public owner;
396     ICrowdsale public target;
397     
398 
399     /**
400      * Deploy proxy
401      *
402      * @param _owner Owner of the proxy
403      * @param _target Target crowdsale
404      */
405     function PersonalCrowdsaleProxy(address _owner, address _target) public {
406         target = ICrowdsale(_target);
407         owner = _owner;
408     }
409 
410 
411     /**
412      * Receive contribution and forward to the target crowdsale
413      * 
414      * This function requires that msg.sender is not a contract. This is required because it's 
415      * not possible for a contract to specify a gas amount when calling the (internal) send() 
416      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
417      */
418     function () public payable {
419         target.contributeFor.value(msg.value)(owner);
420     }
421 }
422 
423 
424 /**
425  * ICrowdsaleProxy
426  *
427  * #created 23/11/2017
428  * #author Frank Bonnet
429  */
430 interface ICrowdsaleProxy {
431 
432     /**
433      * Receive ether and issue tokens to the sender
434      * 
435      * This function requires that msg.sender is not a contract. This is required because it's 
436      * not possible for a contract to specify a gas amount when calling the (internal) send() 
437      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
438      * 
439      * Contracts can call the contribute() function instead
440      */
441     function () public payable;
442 
443 
444     /**
445      * Receive ether and issue tokens to the sender
446      *
447      * @return The accepted ether amount
448      */
449     function contribute() public payable returns (uint);
450 
451 
452     /**
453      * Receive ether and issue tokens to `_beneficiary`
454      *
455      * @param _beneficiary The account that receives the tokens
456      * @return The accepted ether amount
457      */
458     function contributeFor(address _beneficiary) public payable returns (uint);
459 }
460 
461 
462 /**
463  * CrowdsaleProxy
464  *
465  * #created 22/11/2017
466  * #author Frank Bonnet
467  */
468 contract CrowdsaleProxy is ICrowdsaleProxy {
469 
470     address public owner;
471     ICrowdsale public target;
472     
473 
474     /**
475      * Deploy proxy
476      *
477      * @param _owner Owner of the proxy
478      * @param _target Target crowdsale
479      */
480     function CrowdsaleProxy(address _owner, address _target) public {
481         target = ICrowdsale(_target);
482         owner = _owner;
483     }
484 
485 
486     /**
487      * Receive contribution and forward to the crowdsale
488      * 
489      * This function requires that msg.sender is not a contract. This is required because it's 
490      * not possible for a contract to specify a gas amount when calling the (internal) send() 
491      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
492      */
493     function () public payable {
494         target.contributeFor.value(msg.value)(msg.sender);
495     }
496 
497 
498     /**
499      * Receive ether and issue tokens to the sender
500      *
501      * @return The accepted ether amount
502      */
503     function contribute() public payable returns (uint) {
504         target.contributeFor.value(msg.value)(msg.sender);
505     }
506 
507 
508     /**
509      * Receive ether and issue tokens to `_beneficiary`
510      *
511      * @param _beneficiary The account that receives the tokens
512      * @return The accepted ether amount
513      */
514     function contributeFor(address _beneficiary) public payable returns (uint) {
515         target.contributeFor.value(msg.value)(_beneficiary);
516     }
517 }
518 
519 
520 /**
521  * ICrowdsale
522  *
523  * Base crowdsale interface to manage the sale of 
524  * an ERC20 token
525  *
526  * #created 09/09/2017
527  * #author Frank Bonnet
528  */
529 interface ICrowdsale {
530 
531     /**
532      * Returns true if the contract is currently in the presale phase
533      *
534      * @return True if in presale phase
535      */
536     function isInPresalePhase() public view returns (bool);
537 
538 
539     /**
540      * Returns true if the contract is currently in the ended stage
541      *
542      * @return True if ended
543      */
544     function isEnded() public view returns (bool);
545 
546 
547     /**
548      * Returns true if `_beneficiary` has a balance allocated
549      *
550      * @param _beneficiary The account that the balance is allocated for
551      * @param _releaseDate The date after which the balance can be withdrawn
552      * @return True if there is a balance that belongs to `_beneficiary`
553      */
554     function hasBalance(address _beneficiary, uint _releaseDate) public view returns (bool);
555 
556 
557     /** 
558      * Get the allocated token balance of `_owner`
559      * 
560      * @param _owner The address from which the allocated token balance will be retrieved
561      * @return The allocated token balance
562      */
563     function balanceOf(address _owner) public view returns (uint);
564 
565 
566     /** 
567      * Get the allocated eth balance of `_owner`
568      * 
569      * @param _owner The address from which the allocated eth balance will be retrieved
570      * @return The allocated eth balance
571      */
572     function ethBalanceOf(address _owner) public view returns (uint);
573 
574 
575     /** 
576      * Get invested and refundable balance of `_owner` (only contributions during the ICO phase are registered)
577      * 
578      * @param _owner The address from which the refundable balance will be retrieved
579      * @return The invested refundable balance
580      */
581     function refundableEthBalanceOf(address _owner) public view returns (uint);
582 
583 
584     /**
585      * Returns the rate and bonus release date
586      *
587      * @param _phase The phase to use while determining the rate
588      * @param _volume The amount wei used to determine what volume multiplier to use
589      * @return The rate used in `_phase` multiplied by the corresponding volume multiplier
590      */
591     function getRate(uint _phase, uint _volume) public view returns (uint);
592 
593 
594     /**
595      * Convert `_wei` to an amount in tokens using 
596      * the `_rate`
597      *
598      * @param _wei amount of wei to convert
599      * @param _rate rate to use for the conversion
600      * @return Amount in tokens
601      */
602     function toTokens(uint _wei, uint _rate) public view returns (uint);
603 
604 
605     /**
606      * Receive ether and issue tokens to the sender
607      * 
608      * This function requires that msg.sender is not a contract. This is required because it's 
609      * not possible for a contract to specify a gas amount when calling the (internal) send() 
610      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
611      * 
612      * Contracts can call the contribute() function instead
613      */
614     function () public payable;
615 
616 
617     /**
618      * Receive ether and issue tokens to the sender
619      *
620      * @return The accepted ether amount
621      */
622     function contribute() public payable returns (uint);
623 
624 
625     /**
626      * Receive ether and issue tokens to `_beneficiary`
627      *
628      * @param _beneficiary The account that receives the tokens
629      * @return The accepted ether amount
630      */
631     function contributeFor(address _beneficiary) public payable returns (uint);
632 
633 
634     /**
635      * Withdraw allocated tokens
636      */
637     function withdrawTokens() public;
638 
639 
640     /**
641      * Withdraw allocated ether
642      */
643     function withdrawEther() public;
644 
645 
646     /**
647      * Refund in the case of an unsuccessful crowdsale. The 
648      * crowdsale is considered unsuccessful if minAmount was 
649      * not raised before end of the crowdsale
650      */
651     function refund() public;
652 }
653 
654 
655 /**
656  * Crowdsale
657  *
658  * Abstract base crowdsale contract that manages the sale of 
659  * an ERC20 token
660  *
661  * #created 29/09/2017
662  * #author Frank Bonnet
663  */
664 contract Crowdsale is ICrowdsale, Ownership {
665 
666     enum Stages {
667         Deploying,
668         Deployed,
669         InProgress,
670         Ended
671     }
672 
673     struct Balance {
674         uint eth;
675         uint tokens;
676         uint index;
677     }
678 
679     struct Percentage {
680         uint eth;
681         uint tokens;
682         bool overwriteReleaseDate;
683         uint fixedReleaseDate;
684         uint index; 
685     }
686 
687     struct Payout {
688         uint percentage;
689         uint vestingPeriod;
690     }
691 
692     struct Phase {
693         uint rate;
694         uint end;
695         uint bonusReleaseDate;
696         bool useVolumeMultiplier;
697     }
698 
699     struct VolumeMultiplier {
700         uint rateMultiplier;
701         uint bonusReleaseDateMultiplier;
702     }
703 
704     // Crowdsale details
705     uint public baseRate;
706     uint public minAmount; 
707     uint public maxAmount; 
708     uint public minAcceptedAmount;
709     uint public minAmountPresale; 
710     uint public maxAmountPresale;
711     uint public minAcceptedAmountPresale;
712 
713     // Company address
714     address public beneficiary; 
715 
716     // Denominators
717     uint internal percentageDenominator;
718     uint internal tokenDenominator;
719 
720     // Crowdsale state
721     uint public start;
722     uint public presaleEnd;
723     uint public crowdsaleEnd;
724     uint public raised;
725     uint public allocatedEth;
726     uint public allocatedTokens;
727     Stages public stage;
728 
729     // Token contract
730     IManagedToken public token;
731 
732     // Invested balances
733     mapping (address => uint) private balances;
734 
735     // Alocated balances
736     mapping (address => mapping(uint => Balance)) private allocated;
737     mapping(address => uint[]) private allocatedIndex;
738 
739     // Stakeholders
740     mapping (address => Percentage) private stakeholderPercentages;
741     address[] private stakeholderPercentagesIndex;
742     Payout[] private stakeholdersPayouts;
743 
744     // Crowdsale phases
745     Phase[] private phases;
746 
747     // Volume multipliers
748     mapping (uint => VolumeMultiplier) private volumeMultipliers;
749     uint[] private volumeMultiplierThresholds;
750 
751     
752     /**
753      * Throw if at stage other than current stage
754      * 
755      * @param _stage expected stage to test for
756      */
757     modifier at_stage(Stages _stage) {
758         require(stage == _stage);
759         _;
760     }
761 
762 
763     /**
764      * Only after crowdsaleEnd plus `_time`
765      * 
766      * @param _time Time to pass
767      */
768     modifier only_after(uint _time) {
769         require(now > crowdsaleEnd + _time);
770         _;
771     }
772 
773 
774     /**
775      * Only after crowdsale
776      */
777     modifier only_after_crowdsale() {
778         require(now > crowdsaleEnd);
779         _;
780     }
781 
782 
783     /**
784      * Throw if sender is not beneficiary
785      */
786     modifier only_beneficiary() {
787         require(beneficiary == msg.sender);
788         _;
789     }
790 
791 
792     /**
793      * Start in the deploying stage
794      */
795     function Crowdsale() public {
796         stage = Stages.Deploying;
797     }
798 
799 
800     /**
801      * Setup the crowdsale
802      *
803      * @param _start The timestamp of the start date
804      * @param _token The token that is sold
805      * @param _tokenDenominator The token amount of decimals that the token uses
806      * @param _percentageDenominator The percision of percentages
807      * @param _minAmountPresale The min cap for the presale
808      * @param _maxAmountPresale The max cap for the presale
809      * @param _minAcceptedAmountPresale The lowest accepted amount during the presale phase
810      * @param _minAmount The min cap for the ICO
811      * @param _maxAmount The max cap for the ICO
812      * @param _minAcceptedAmount The lowest accepted amount during the ICO phase
813      */
814     function setup(uint _start, address _token, uint _tokenDenominator, uint _percentageDenominator, uint _minAmountPresale, uint _maxAmountPresale, uint _minAcceptedAmountPresale, uint _minAmount, uint _maxAmount, uint _minAcceptedAmount) public only_owner at_stage(Stages.Deploying) {
815         token = IManagedToken(_token);
816         tokenDenominator = _tokenDenominator;
817         percentageDenominator = _percentageDenominator;
818         start = _start;
819         minAmountPresale = _minAmountPresale;
820         maxAmountPresale = _maxAmountPresale;
821         minAcceptedAmountPresale = _minAcceptedAmountPresale;
822         minAmount = _minAmount;
823         maxAmount = _maxAmount;
824         minAcceptedAmount = _minAcceptedAmount;
825     }
826 
827 
828     /**
829      * Setup rates and phases
830      *
831      * @param _baseRate The rate without bonus
832      * @param _phaseRates The rates for each phase
833      * @param _phasePeriods The periods that each phase lasts (first phase is the presale phase)
834      * @param _phaseBonusLockupPeriods The lockup period that each phase lasts
835      * @param _phaseUsesVolumeMultiplier Wheter or not volume bonusses are used in the respective phase
836      */
837     function setupPhases(uint _baseRate, uint[] _phaseRates, uint[] _phasePeriods, uint[] _phaseBonusLockupPeriods, bool[] _phaseUsesVolumeMultiplier) public only_owner at_stage(Stages.Deploying) {
838         baseRate = _baseRate;
839         presaleEnd = start + _phasePeriods[0]; // First phase is expected to be the presale phase
840         crowdsaleEnd = start; // Plus the sum of the rate phases
841 
842         for (uint i = 0; i < _phaseRates.length; i++) {
843             crowdsaleEnd += _phasePeriods[i];
844             phases.push(Phase(_phaseRates[i], crowdsaleEnd, 0, _phaseUsesVolumeMultiplier[i]));
845         }
846 
847         for (uint ii = 0; ii < _phaseRates.length; ii++) {
848             if (_phaseBonusLockupPeriods[ii] > 0) {
849                 phases[ii].bonusReleaseDate = crowdsaleEnd + _phaseBonusLockupPeriods[ii];
850             }
851         }
852     }
853 
854 
855     /**
856      * Setup stakeholders
857      *
858      * @param _stakeholders The addresses of the stakeholders (first stakeholder is the beneficiary)
859      * @param _stakeholderEthPercentages The eth percentages of the stakeholders
860      * @param _stakeholderTokenPercentages The token percentages of the stakeholders
861      * @param _stakeholderTokenPayoutOverwriteReleaseDates Wheter the vesting period is overwritten for the respective stakeholder
862      * @param _stakeholderTokenPayoutFixedReleaseDates The vesting period after which the whole percentage of the tokens is released to the respective stakeholder
863      * @param _stakeholderTokenPayoutPercentages The percentage of the tokens that is released at the respective date
864      * @param _stakeholderTokenPayoutVestingPeriods The vesting period after which the respective percentage of the tokens is released
865      */
866     function setupStakeholders(address[] _stakeholders, uint[] _stakeholderEthPercentages, uint[] _stakeholderTokenPercentages, bool[] _stakeholderTokenPayoutOverwriteReleaseDates, uint[] _stakeholderTokenPayoutFixedReleaseDates, uint[] _stakeholderTokenPayoutPercentages, uint[] _stakeholderTokenPayoutVestingPeriods) public only_owner at_stage(Stages.Deploying) {
867         beneficiary = _stakeholders[0]; // First stakeholder is expected to be the beneficiary
868         for (uint i = 0; i < _stakeholders.length; i++) {
869             stakeholderPercentagesIndex.push(_stakeholders[i]);
870             stakeholderPercentages[_stakeholders[i]] = Percentage(
871                 _stakeholderEthPercentages[i], 
872                 _stakeholderTokenPercentages[i], 
873                 _stakeholderTokenPayoutOverwriteReleaseDates[i],
874                 _stakeholderTokenPayoutFixedReleaseDates[i], i);
875         }
876 
877         // Percentages add up to 100
878         for (uint ii = 0; ii < _stakeholderTokenPayoutPercentages.length; ii++) {
879             stakeholdersPayouts.push(Payout(_stakeholderTokenPayoutPercentages[ii], _stakeholderTokenPayoutVestingPeriods[ii]));
880         }
881     }
882 
883     
884     /**
885      * Setup volume multipliers
886      *
887      * @param _volumeMultiplierRates The rates will be multiplied by this value (denominated by 4)
888      * @param _volumeMultiplierLockupPeriods The lockup periods will be multiplied by this value (denominated by 4)
889      * @param _volumeMultiplierThresholds The volume thresholds for each respective multiplier
890      */
891     function setupVolumeMultipliers(uint[] _volumeMultiplierRates, uint[] _volumeMultiplierLockupPeriods, uint[] _volumeMultiplierThresholds) public only_owner at_stage(Stages.Deploying) {
892         require(phases.length > 0);
893         volumeMultiplierThresholds = _volumeMultiplierThresholds;
894         for (uint i = 0; i < volumeMultiplierThresholds.length; i++) {
895             volumeMultipliers[volumeMultiplierThresholds[i]] = VolumeMultiplier(_volumeMultiplierRates[i], _volumeMultiplierLockupPeriods[i]);
896         }
897     }
898     
899 
900     /**
901      * After calling the deploy function the crowdsale
902      * rules become immutable 
903      */
904     function deploy() public only_owner at_stage(Stages.Deploying) {
905         require(phases.length > 0);
906         require(stakeholderPercentagesIndex.length > 0);
907         stage = Stages.Deployed;
908     }
909 
910 
911     /**
912      * Prove that beneficiary is able to sign transactions 
913      * and start the crowdsale
914      */
915     function confirmBeneficiary() public only_beneficiary at_stage(Stages.Deployed) {
916         stage = Stages.InProgress;
917     }
918 
919 
920     /**
921      * Returns true if the contract is currently in the presale phase
922      *
923      * @return True if in presale phase
924      */
925     function isInPresalePhase() public view returns (bool) {
926         return stage == Stages.InProgress && now >= start && now <= presaleEnd;
927     }
928 
929 
930     /**
931      * Returns true if the contract is currently in the ended stage
932      *
933      * @return True if ended
934      */
935     function isEnded() public view returns (bool) {
936         return stage == Stages.Ended;
937     }
938 
939 
940     /**
941      * Returns true if `_beneficiary` has a balance allocated
942      *
943      * @param _beneficiary The account that the balance is allocated for
944      * @param _releaseDate The date after which the balance can be withdrawn
945      * @return True if there is a balance that belongs to `_beneficiary`
946      */
947     function hasBalance(address _beneficiary, uint _releaseDate) public view returns (bool) {
948         return allocatedIndex[_beneficiary].length > 0 && _releaseDate == allocatedIndex[_beneficiary][allocated[_beneficiary][_releaseDate].index];
949     }
950 
951 
952     /** 
953      * Get the allocated token balance of `_owner`
954      * 
955      * @param _owner The address from which the allocated token balance will be retrieved
956      * @return The allocated token balance
957      */
958     function balanceOf(address _owner) public view returns (uint) {
959         uint sum = 0;
960         for (uint i = 0; i < allocatedIndex[_owner].length; i++) {
961             sum += allocated[_owner][allocatedIndex[_owner][i]].tokens;
962         }
963 
964         return sum;
965     }
966 
967 
968     /** 
969      * Get the allocated eth balance of `_owner`
970      * 
971      * @param _owner The address from which the allocated eth balance will be retrieved
972      * @return The allocated eth balance
973      */
974     function ethBalanceOf(address _owner) public view returns (uint) {
975         uint sum = 0;
976         for (uint i = 0; i < allocatedIndex[_owner].length; i++) {
977             sum += allocated[_owner][allocatedIndex[_owner][i]].eth;
978         }
979 
980         return sum;
981     }
982 
983 
984     /** 
985      * Get invested and refundable balance of `_owner` (only contributions during the ICO phase are registered)
986      * 
987      * @param _owner The address from which the refundable balance will be retrieved
988      * @return The invested refundable balance
989      */
990     function refundableEthBalanceOf(address _owner) public view returns (uint) {
991         return now > crowdsaleEnd && raised < minAmount ? balances[_owner] : 0;
992     }
993 
994 
995     /**
996      * Returns the current phase based on the current time
997      *
998      * @return The index of the current phase
999      */
1000     function getCurrentPhase() public view returns (uint) {
1001         for (uint i = 0; i < phases.length; i++) {
1002             if (now <= phases[i].end) {
1003                 return i;
1004                 break;
1005             }
1006         }
1007 
1008         return uint(-1); // Does not exist (underflow)
1009     }
1010 
1011 
1012     /**
1013      * Returns the rate and bonus release date
1014      *
1015      * @param _phase The phase to use while determining the rate
1016      * @param _volume The amount wei used to determin what volume multiplier to use
1017      * @return The rate used in `_phase` multiplied by the corresponding volume multiplier
1018      */
1019     function getRate(uint _phase, uint _volume) public view returns (uint) {
1020         uint rate = 0;
1021         if (stage == Stages.InProgress && now >= start) {
1022             Phase storage phase = phases[_phase];
1023             rate = phase.rate;
1024 
1025             // Find volume multiplier
1026             if (phase.useVolumeMultiplier && volumeMultiplierThresholds.length > 0 && _volume >= volumeMultiplierThresholds[0]) {
1027                 for (uint i = volumeMultiplierThresholds.length; i > 0; i--) {
1028                     if (_volume >= volumeMultiplierThresholds[i - 1]) {
1029                         VolumeMultiplier storage multiplier = volumeMultipliers[volumeMultiplierThresholds[i - 1]];
1030                         rate += phase.rate * multiplier.rateMultiplier / percentageDenominator;
1031                         break;
1032                     }
1033                 }
1034             }
1035         }
1036         
1037         return rate;
1038     }
1039 
1040 
1041     /**
1042      * Get distribution data based on the current phase and 
1043      * the volume in wei that is being distributed
1044      * 
1045      * @param _phase The current crowdsale phase
1046      * @param _volume The amount wei used to determine what volume multiplier to use
1047      * @return Volumes and corresponding release dates
1048      */
1049     function getDistributionData(uint _phase, uint _volume) internal view returns (uint[], uint[]) {
1050         Phase storage phase = phases[_phase];
1051         uint remainingVolume = _volume;
1052 
1053         bool usingMultiplier = false;
1054         uint[] memory volumes = new uint[](1);
1055         uint[] memory releaseDates = new uint[](1);
1056 
1057         // Find volume multipliers
1058         if (phase.useVolumeMultiplier && volumeMultiplierThresholds.length > 0 && _volume >= volumeMultiplierThresholds[0]) {
1059             uint phaseReleasePeriod = phase.bonusReleaseDate - crowdsaleEnd;
1060             for (uint i = volumeMultiplierThresholds.length; i > 0; i--) {
1061                 if (_volume >= volumeMultiplierThresholds[i - 1]) {
1062                     if (!usingMultiplier) {
1063                         volumes = new uint[](i + 1);
1064                         releaseDates = new uint[](i + 1);
1065                         usingMultiplier = true;
1066                     }
1067 
1068                     VolumeMultiplier storage multiplier = volumeMultipliers[volumeMultiplierThresholds[i - 1]];
1069                     uint releaseDate = phase.bonusReleaseDate + phaseReleasePeriod * multiplier.bonusReleaseDateMultiplier / percentageDenominator;
1070                     uint volume = remainingVolume - volumeMultiplierThresholds[i - 1];
1071 
1072                     // Store increment
1073                     volumes[i] = volume;
1074                     releaseDates[i] = releaseDate;
1075 
1076                     remainingVolume -= volume;
1077                 }
1078             }
1079         }
1080 
1081         // Store increment
1082         volumes[0] = remainingVolume;
1083         releaseDates[0] = phase.bonusReleaseDate;
1084 
1085         return (volumes, releaseDates);
1086     }
1087 
1088 
1089     /**
1090      * Convert `_wei` to an amount in tokens using 
1091      * the `_rate`
1092      *
1093      * @param _wei amount of wei to convert
1094      * @param _rate rate to use for the conversion
1095      * @return Amount in tokens
1096      */
1097     function toTokens(uint _wei, uint _rate) public view returns (uint) {
1098         return _wei * _rate * tokenDenominator / 1 ether;
1099     }
1100 
1101 
1102     /**
1103      * Receive Eth and issue tokens to the sender
1104      * 
1105      * This function requires that msg.sender is not a contract. This is required because it's 
1106      * not possible for a contract to specify a gas amount when calling the (internal) send() 
1107      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
1108      * 
1109      * Contracts can call the contribute() function instead
1110      */
1111     function () public payable {
1112         require(msg.sender == tx.origin);
1113         _handleTransaction(msg.sender, msg.value);
1114     }
1115 
1116 
1117     /**
1118      * Receive ether and issue tokens to the sender
1119      *
1120      * @return The accepted ether amount
1121      */
1122     function contribute() public payable returns (uint) {
1123         return _handleTransaction(msg.sender, msg.value);
1124     }
1125 
1126 
1127     /**
1128      * Receive ether and issue tokens to `_beneficiary`
1129      *
1130      * @param _beneficiary The account that receives the tokens
1131      * @return The accepted ether amount
1132      */
1133     function contributeFor(address _beneficiary) public payable returns (uint) {
1134         return _handleTransaction(_beneficiary, msg.value);
1135     }
1136 
1137 
1138     /**
1139      * Function to end the crowdsale by setting 
1140      * the stage to Ended
1141      */
1142     function endCrowdsale() public at_stage(Stages.InProgress) {
1143         require(now > crowdsaleEnd || raised >= maxAmount);
1144         require(raised >= minAmount);
1145         stage = Stages.Ended;
1146 
1147         // Unlock token
1148         if (!token.unlock()) {
1149             revert();
1150         }
1151 
1152         // Allocate tokens (no allocation can be done after this period)
1153         uint totalTokenSupply = IToken(token).totalSupply() + allocatedTokens;
1154         for (uint i = 0; i < stakeholdersPayouts.length; i++) {
1155             Payout storage p = stakeholdersPayouts[i];
1156             _allocateStakeholdersTokens(totalTokenSupply * p.percentage / percentageDenominator, now + p.vestingPeriod);
1157         }
1158 
1159         // Allocate remaining ETH
1160         _allocateStakeholdersEth(this.balance - allocatedEth, 0);
1161     }
1162 
1163 
1164     /**
1165      * Withdraw allocated tokens
1166      */
1167     function withdrawTokens() public {
1168         withdrawTokensTo(msg.sender);
1169     }
1170 
1171 
1172     /**
1173      * Withdraw allocated tokens
1174      *
1175      * @param _beneficiary Address to send to
1176      */
1177     function withdrawTokensTo(address _beneficiary) public {
1178         uint tokensToSend = 0;
1179         for (uint i = 0; i < allocatedIndex[msg.sender].length; i++) {
1180             uint releaseDate = allocatedIndex[msg.sender][i];
1181             if (releaseDate <= now) {
1182                 Balance storage b = allocated[msg.sender][releaseDate];
1183                 tokensToSend += b.tokens;
1184                 b.tokens = 0;
1185             }
1186         }
1187 
1188         if (tokensToSend > 0) {
1189             allocatedTokens -= tokensToSend;
1190             if (!token.issue(_beneficiary, tokensToSend)) {
1191                 revert();
1192             }
1193         }
1194     }
1195 
1196 
1197     /**
1198      * Withdraw allocated ether
1199      */
1200     function withdrawEther() public {
1201         withdrawEtherTo(msg.sender);
1202     }
1203 
1204 
1205     /**
1206      * Withdraw allocated ether
1207      *
1208      * @param _beneficiary Address to send to
1209      */
1210     function withdrawEtherTo(address _beneficiary) public {
1211         uint ethToSend = 0;
1212         for (uint i = 0; i < allocatedIndex[msg.sender].length; i++) {
1213             uint releaseDate = allocatedIndex[msg.sender][i];
1214             if (releaseDate <= now) {
1215                 Balance storage b = allocated[msg.sender][releaseDate];
1216                 ethToSend += b.eth;
1217                 b.eth = 0;
1218             }
1219         }
1220 
1221         if (ethToSend > 0) {
1222             allocatedEth -= ethToSend;
1223             if (!_beneficiary.send(ethToSend)) {
1224                 revert();
1225             }
1226         }
1227     }
1228 
1229 
1230     /**
1231      * Refund in the case of an unsuccessful crowdsale. The 
1232      * crowdsale is considered unsuccessful if minAmount was 
1233      * not raised before end of the crowdsale
1234      */
1235     function refund() public only_after_crowdsale at_stage(Stages.InProgress) {
1236         refundTo(msg.sender);
1237     }
1238 
1239 
1240     /**
1241      * Refund in the case of an unsuccessful crowdsale. The 
1242      * crowdsale is considered unsuccessful if minAmount was 
1243      * not raised before end of the crowdsale
1244      *
1245      * @param _beneficiary Address to send to
1246      */
1247     function refundTo(address _beneficiary) public only_after_crowdsale at_stage(Stages.InProgress) {
1248         require(raised < minAmount);
1249 
1250         uint receivedAmount = balances[msg.sender];
1251         balances[msg.sender] = 0;
1252 
1253         if (receivedAmount > 0 && !_beneficiary.send(receivedAmount)) {
1254             balances[msg.sender] = receivedAmount;
1255         }
1256     }
1257 
1258 
1259     /**
1260      * Failsafe and clean-up mechanism
1261      */
1262     function destroy() public only_beneficiary only_after(2 years) {
1263         selfdestruct(beneficiary);
1264     }
1265 
1266 
1267     /**
1268      * Handle incoming transaction
1269      * 
1270      * @param _beneficiary Tokens are issued to this account
1271      * @param _received The amount that was received
1272      * @return The accepted ether amount
1273      */
1274     function _handleTransaction(address _beneficiary, uint _received) internal at_stage(Stages.InProgress) returns (uint) {
1275         require(now >= start && now <= crowdsaleEnd);
1276         require(isAcceptingContributions());
1277         require(isAcceptedContributor(_beneficiary));
1278 
1279         if (isInPresalePhase()) {
1280             return _handlePresaleTransaction(
1281                 _beneficiary, _received);
1282         } else {
1283             return _handlePublicsaleTransaction(
1284                 _beneficiary, _received);
1285         }
1286     }
1287 
1288 
1289     /**
1290      * Handle incoming transaction during the presale phase
1291      * 
1292      * @param _beneficiary Tokens are issued to this account
1293      * @param _received The amount that was received
1294      * @return The accepted ether amount
1295      */
1296     function _handlePresaleTransaction(address _beneficiary, uint _received) private returns (uint) {
1297         require(_received >= minAcceptedAmountPresale);
1298         require(raised < maxAmountPresale);
1299 
1300         uint acceptedAmount;
1301         if (raised + _received > maxAmountPresale) {
1302             acceptedAmount = maxAmountPresale - raised;
1303         } else {
1304             acceptedAmount = _received;
1305         }
1306 
1307         raised += acceptedAmount;
1308 
1309         // During the presale phase - Non refundable
1310         _allocateStakeholdersEth(acceptedAmount, 0); 
1311 
1312         // Issue tokens
1313         _distributeTokens(_beneficiary, _received, acceptedAmount);
1314         return acceptedAmount;
1315     }
1316 
1317 
1318     /**
1319      * Handle incoming transaction during the publicsale phase
1320      * 
1321      * @param _beneficiary Tokens are issued to this account
1322      * @param _received The amount that was received
1323      * @return The accepted ether amount
1324      */
1325     function _handlePublicsaleTransaction(address _beneficiary, uint _received) private returns (uint) {
1326         require(_received >= minAcceptedAmount);
1327         require(raised >= minAmountPresale);
1328         require(raised < maxAmount);
1329 
1330         uint acceptedAmount;
1331         if (raised + _received > maxAmount) {
1332             acceptedAmount = maxAmount - raised;
1333         } else {
1334             acceptedAmount = _received;
1335         }
1336 
1337         raised += acceptedAmount;
1338         
1339         // During the ICO phase - 100% refundable
1340         balances[_beneficiary] += acceptedAmount; 
1341 
1342         // Issue tokens
1343         _distributeTokens(_beneficiary, _received, acceptedAmount);
1344         return acceptedAmount;
1345     }
1346 
1347 
1348     /**
1349      * Distribute tokens 
1350      *
1351      * Tokens can be issued by instructing the token contract to create new tokens or by 
1352      * allocating tokens and instructing the token contract to create the tokens later
1353      * 
1354      * @param _beneficiary Tokens are issued to this account
1355      * @param _received The amount that was received
1356      * @param _acceptedAmount The amount that was accepted
1357      */
1358     function _distributeTokens(address _beneficiary, uint _received, uint _acceptedAmount) private {
1359         uint tokensToIssue = 0;
1360         uint phase = getCurrentPhase();
1361         var rate = getRate(phase, _acceptedAmount);
1362         if (rate == 0) {
1363             revert(); // Paused phase
1364         }
1365 
1366         // Volume multipliers
1367         var (volumes, releaseDates) = getDistributionData(
1368             phase, _acceptedAmount);
1369         
1370         // Allocate tokens
1371         for (uint i = 0; i < volumes.length; i++) {
1372             var tokensAtCurrentRate = toTokens(volumes[i], rate);
1373             if (rate > baseRate && releaseDates[i] > now) {
1374                 uint bonusTokens = tokensAtCurrentRate * (rate - baseRate) / rate;
1375                 _allocateTokens(_beneficiary, bonusTokens, releaseDates[i]);
1376 
1377                 tokensToIssue += tokensAtCurrentRate - bonusTokens;
1378             } else {
1379                 tokensToIssue += tokensAtCurrentRate;
1380             }
1381         }
1382 
1383         // Issue tokens
1384         if (tokensToIssue > 0 && !token.issue(_beneficiary, tokensToIssue)) {
1385             revert();
1386         }
1387 
1388         // Refund due to max cap hit
1389         if (_received - _acceptedAmount > 0 && !_beneficiary.send(_received - _acceptedAmount)) {
1390             revert();
1391         }
1392     }
1393 
1394 
1395     /**
1396      * Allocate ETH
1397      *
1398      * @param _beneficiary The account to alocate the eth for
1399      * @param _amount The amount of ETH to allocate
1400      * @param _releaseDate The date after which the eth can be withdrawn
1401      */    
1402     function _allocateEth(address _beneficiary, uint _amount, uint _releaseDate) internal {
1403         if (hasBalance(_beneficiary, _releaseDate)) {
1404             allocated[_beneficiary][_releaseDate].eth += _amount;
1405         } else {
1406             allocated[_beneficiary][_releaseDate] = Balance(
1407                 _amount, 0, allocatedIndex[_beneficiary].push(_releaseDate) - 1);
1408         }
1409 
1410         allocatedEth += _amount;
1411     }
1412 
1413 
1414     /**
1415      * Allocate Tokens
1416      *
1417      * @param _beneficiary The account to allocate the tokens for
1418      * @param _amount The amount of tokens to allocate
1419      * @param _releaseDate The date after which the tokens can be withdrawn
1420      */    
1421     function _allocateTokens(address _beneficiary, uint _amount, uint _releaseDate) internal {
1422         if (hasBalance(_beneficiary, _releaseDate)) {
1423             allocated[_beneficiary][_releaseDate].tokens += _amount;
1424         } else {
1425             allocated[_beneficiary][_releaseDate] = Balance(
1426                 0, _amount, allocatedIndex[_beneficiary].push(_releaseDate) - 1);
1427         }
1428 
1429         allocatedTokens += _amount;
1430     }
1431 
1432 
1433     /**
1434      * Allocate ETH for stakeholders
1435      *
1436      * @param _amount The amount of ETH to allocate
1437      * @param _releaseDate The date after which the eth can be withdrawn
1438      */    
1439     function _allocateStakeholdersEth(uint _amount, uint _releaseDate) internal {
1440         for (uint i = 0; i < stakeholderPercentagesIndex.length; i++) {
1441             Percentage storage p = stakeholderPercentages[stakeholderPercentagesIndex[i]];
1442             if (p.eth > 0) {
1443                 _allocateEth(stakeholderPercentagesIndex[i], _amount * p.eth / percentageDenominator, _releaseDate);
1444             }
1445         }
1446     }
1447 
1448 
1449     /**
1450      * Allocate Tokens for stakeholders
1451      *
1452      * @param _amount The amount of tokens created
1453      * @param _releaseDate The date after which the tokens can be withdrawn (unless overwitten)
1454      */    
1455     function _allocateStakeholdersTokens(uint _amount, uint _releaseDate) internal {
1456         for (uint i = 0; i < stakeholderPercentagesIndex.length; i++) {
1457             Percentage storage p = stakeholderPercentages[stakeholderPercentagesIndex[i]];
1458             if (p.tokens > 0) {
1459                 _allocateTokens(
1460                     stakeholderPercentagesIndex[i], 
1461                     _amount * p.tokens / percentageDenominator, 
1462                     p.overwriteReleaseDate ? p.fixedReleaseDate : _releaseDate);
1463             }
1464         }
1465     }
1466 
1467 
1468     /**
1469      * Allows the implementing contract to validate a 
1470      * contributing account
1471      *
1472      * @param _contributor Address that is being validated
1473      * @return Wheter the contributor is accepted or not
1474      */
1475     function isAcceptedContributor(address _contributor) internal view returns (bool);
1476 
1477 
1478     /**
1479      * Allows the implementing contract to prevent the accepting 
1480      * of contributions
1481      *
1482      * @return Wheter contributions are accepted or not
1483      */
1484     function isAcceptingContributions() internal view returns (bool);
1485 }
1486 
1487 
1488 /**
1489  * MoxyOne Crowdsale
1490  *
1491  * Advancing the blockchain industry by creating seamless and secure debit card 
1492  * and payment infrastructure for every company, project and ICO that issues cryptocurrency tokens. 
1493  *
1494  * #created 06/01/2018
1495  * #author Frank Bonnet
1496  */
1497 contract MoxyOneCrowdsale is Crowdsale, TokenRetriever, IPausable, IAuthenticationManager, IWingsAdapter {
1498 
1499     // State
1500     bool private paused;
1501 
1502     // Authentication
1503     IAuthenticator private authenticator;
1504     bool private requireAuthentication;
1505 
1506 
1507     /**
1508      * Returns whether the implementing contract is 
1509      * currently paused or not
1510      *
1511      * @return Whether the paused state is active
1512      */
1513     function isPaused() public view returns (bool) {
1514         return paused;
1515     }
1516 
1517 
1518     /**
1519      * Change the state to paused
1520      */
1521     function pause() public only_owner {
1522         paused = true;
1523     }
1524 
1525 
1526     /**
1527      * Change the state to resume, undo the effects 
1528      * of calling pause
1529      */
1530     function resume() public only_owner {
1531         paused = false;
1532     }
1533 
1534 
1535     /**
1536      * Setup authentication
1537      *
1538      * @param _authenticator The address of the authenticator (whitelist)
1539      * @param _requireAuthentication Wether the crowdale requires contributors to be authenticated
1540      */
1541     function setupAuthentication(address _authenticator, bool _requireAuthentication) public only_owner at_stage(Stages.Deploying) {
1542         authenticator = IAuthenticator(_authenticator);
1543         requireAuthentication = _requireAuthentication;
1544     }
1545 
1546 
1547     /**
1548      * Returns true if authentication is enabled and false 
1549      * otherwise
1550      *
1551      * @return Whether the converter is currently authenticating or not
1552      */
1553     function isAuthenticating() public view returns (bool) {
1554         return requireAuthentication;
1555     }
1556 
1557 
1558     /**
1559      * Enable authentication
1560      */
1561     function enableAuthentication() public only_owner {
1562         requireAuthentication = true;
1563     }
1564 
1565 
1566     /**
1567      * Disable authentication
1568      */
1569     function disableAuthentication() public only_owner {
1570         requireAuthentication = false;
1571     }
1572 
1573 
1574     /**
1575      * Validate a contributing account
1576      *
1577      * @param _contributor Address that is being validated
1578      * @return Wheter the contributor is accepted or not
1579      */
1580     function isAcceptedContributor(address _contributor) internal view returns (bool) {
1581         return !requireAuthentication || authenticator.authenticate(_contributor);
1582     }
1583 
1584 
1585     /**
1586      * Indicate if contributions are currently accepted
1587      *
1588      * @return Wheter contributions are accepted or not
1589      */
1590     function isAcceptingContributions() internal view returns (bool) {
1591         return !paused;
1592     }
1593 
1594 
1595     /**
1596      * Wings integration - Get the total raised amount of Ether
1597      *
1598      * Can only increased, means if you withdraw ETH from the wallet, should be not modified (you can use two fields 
1599      * to keep one with a total accumulated amount) amount of ETH in contract and totalCollected for total amount of ETH collected
1600      *
1601      * @return Total raised Ether amount
1602      */
1603     function totalCollected() public view returns (uint) {
1604         return raised;
1605     }
1606 
1607 
1608     /**
1609      * Failsafe mechanism
1610      * 
1611      * Allows the owner to retrieve tokens from the contract that 
1612      * might have been send there by accident
1613      *
1614      * @param _tokenContract The address of ERC20 compatible token
1615      */
1616     function retrieveTokens(address _tokenContract) public only_owner {
1617         super.retrieveTokens(_tokenContract);
1618 
1619         // Retrieve tokens from our token contract
1620         ITokenRetriever(token).retrieveTokens(_tokenContract);
1621     }
1622 }