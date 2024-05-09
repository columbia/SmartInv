1 pragma solidity 0.4.25;
2 
3 /// @title provides subject to role checking logic
4 contract IAccessPolicy {
5 
6     ////////////////////////
7     // Public functions
8     ////////////////////////
9 
10     /// @notice We don't make this function constant to allow for state-updating access controls such as rate limiting.
11     /// @dev checks if subject belongs to requested role for particular object
12     /// @param subject address to be checked against role, typically msg.sender
13     /// @param role identifier of required role
14     /// @param object contract instance context for role checking, typically contract requesting the check
15     /// @param verb additional data, in current AccessControll implementation msg.sig
16     /// @return if subject belongs to a role
17     function allowed(
18         address subject,
19         bytes32 role,
20         address object,
21         bytes4 verb
22     )
23         public
24         returns (bool);
25 }
26 
27 /// @title enables access control in implementing contract
28 /// @dev see AccessControlled for implementation
29 contract IAccessControlled {
30 
31     ////////////////////////
32     // Events
33     ////////////////////////
34 
35     /// @dev must log on access policy change
36     event LogAccessPolicyChanged(
37         address controller,
38         IAccessPolicy oldPolicy,
39         IAccessPolicy newPolicy
40     );
41 
42     ////////////////////////
43     // Public functions
44     ////////////////////////
45 
46     /// @dev allows to change access control mechanism for this contract
47     ///     this method must be itself access controlled, see AccessControlled implementation and notice below
48     /// @notice it is a huge issue for Solidity that modifiers are not part of function signature
49     ///     then interfaces could be used for example to control access semantics
50     /// @param newPolicy new access policy to controll this contract
51     /// @param newAccessController address of ROLE_ACCESS_CONTROLLER of new policy that can set access to this contract
52     function setAccessPolicy(IAccessPolicy newPolicy, address newAccessController)
53         public;
54 
55     function accessPolicy()
56         public
57         constant
58         returns (IAccessPolicy);
59 
60 }
61 
62 contract StandardRoles {
63 
64     ////////////////////////
65     // Constants
66     ////////////////////////
67 
68     // @notice Soldity somehow doesn't evaluate this compile time
69     // @dev role which has rights to change permissions and set new policy in contract, keccak256("AccessController")
70     bytes32 internal constant ROLE_ACCESS_CONTROLLER = 0xac42f8beb17975ed062dcb80c63e6d203ef1c2c335ced149dc5664cc671cb7da;
71 }
72 
73 /// @title Granular code execution permissions
74 /// @notice Intended to replace existing Ownable pattern with more granular permissions set to execute smart contract functions
75 ///     for each function where 'only' modifier is applied, IAccessPolicy implementation is called to evaluate if msg.sender belongs to required role for contract being called.
76 ///     Access evaluation specific belong to IAccessPolicy implementation, see RoleBasedAccessPolicy for details.
77 /// @dev Should be inherited by a contract requiring such permissions controll. IAccessPolicy must be provided in constructor. Access policy may be replaced to a different one
78 ///     by msg.sender with ROLE_ACCESS_CONTROLLER role
79 contract AccessControlled is IAccessControlled, StandardRoles {
80 
81     ////////////////////////
82     // Mutable state
83     ////////////////////////
84 
85     IAccessPolicy private _accessPolicy;
86 
87     ////////////////////////
88     // Modifiers
89     ////////////////////////
90 
91     /// @dev limits function execution only to senders assigned to required 'role'
92     modifier only(bytes32 role) {
93         require(_accessPolicy.allowed(msg.sender, role, this, msg.sig));
94         _;
95     }
96 
97     ////////////////////////
98     // Constructor
99     ////////////////////////
100 
101     constructor(IAccessPolicy policy) internal {
102         require(address(policy) != 0x0);
103         _accessPolicy = policy;
104     }
105 
106     ////////////////////////
107     // Public functions
108     ////////////////////////
109 
110     //
111     // Implements IAccessControlled
112     //
113 
114     function setAccessPolicy(IAccessPolicy newPolicy, address newAccessController)
115         public
116         only(ROLE_ACCESS_CONTROLLER)
117     {
118         // ROLE_ACCESS_CONTROLLER must be present
119         // under the new policy. This provides some
120         // protection against locking yourself out.
121         require(newPolicy.allowed(newAccessController, ROLE_ACCESS_CONTROLLER, this, msg.sig));
122 
123         // We can now safely set the new policy without foot shooting.
124         IAccessPolicy oldPolicy = _accessPolicy;
125         _accessPolicy = newPolicy;
126 
127         // Log event
128         emit LogAccessPolicyChanged(msg.sender, oldPolicy, newPolicy);
129     }
130 
131     function accessPolicy()
132         public
133         constant
134         returns (IAccessPolicy)
135     {
136         return _accessPolicy;
137     }
138 }
139 
140 /// @title standard access roles of the Platform
141 /// @dev constants are kept in CODE not in STORAGE so they are comparatively cheap
142 contract AccessRoles {
143 
144     ////////////////////////
145     // Constants
146     ////////////////////////
147 
148     // NOTE: All roles are set to the keccak256 hash of the
149     // CamelCased role name, i.e.
150     // ROLE_LOCKED_ACCOUNT_ADMIN = keccak256("LockedAccountAdmin")
151 
152     // May issue (generate) Neumarks
153     bytes32 internal constant ROLE_NEUMARK_ISSUER = 0x921c3afa1f1fff707a785f953a1e197bd28c9c50e300424e015953cbf120c06c;
154 
155     // May burn Neumarks it owns
156     bytes32 internal constant ROLE_NEUMARK_BURNER = 0x19ce331285f41739cd3362a3ec176edffe014311c0f8075834fdd19d6718e69f;
157 
158     // May create new snapshots on Neumark
159     bytes32 internal constant ROLE_SNAPSHOT_CREATOR = 0x08c1785afc57f933523bc52583a72ce9e19b2241354e04dd86f41f887e3d8174;
160 
161     // May enable/disable transfers on Neumark
162     bytes32 internal constant ROLE_TRANSFER_ADMIN = 0xb6527e944caca3d151b1f94e49ac5e223142694860743e66164720e034ec9b19;
163 
164     // may reclaim tokens/ether from contracts supporting IReclaimable interface
165     bytes32 internal constant ROLE_RECLAIMER = 0x0542bbd0c672578966dcc525b30aa16723bb042675554ac5b0362f86b6e97dc5;
166 
167     // represents legally platform operator in case of forks and contracts with legal agreement attached. keccak256("PlatformOperatorRepresentative")
168     bytes32 internal constant ROLE_PLATFORM_OPERATOR_REPRESENTATIVE = 0xb2b321377653f655206f71514ff9f150d0822d062a5abcf220d549e1da7999f0;
169 
170     // allows to deposit EUR-T and allow addresses to send and receive EUR-T. keccak256("EurtDepositManager")
171     bytes32 internal constant ROLE_EURT_DEPOSIT_MANAGER = 0x7c8ecdcba80ce87848d16ad77ef57cc196c208fc95c5638e4a48c681a34d4fe7;
172 
173     // allows to register identities and change associated claims keccak256("IdentityManager")
174     bytes32 internal constant ROLE_IDENTITY_MANAGER = 0x32964e6bc50f2aaab2094a1d311be8bda920fc4fb32b2fb054917bdb153a9e9e;
175 
176     // allows to replace controller on euro token and to destroy tokens without withdraw kecckak256("EurtLegalManager")
177     bytes32 internal constant ROLE_EURT_LEGAL_MANAGER = 0x4eb6b5806954a48eb5659c9e3982d5e75bfb2913f55199877d877f157bcc5a9b;
178 
179     // allows to change known interfaces in universe kecckak256("UniverseManager")
180     bytes32 internal constant ROLE_UNIVERSE_MANAGER = 0xe8d8f8f9ea4b19a5a4368dbdace17ad71a69aadeb6250e54c7b4c7b446301738;
181 
182     // allows to exchange gas for EUR-T keccak("GasExchange")
183     bytes32 internal constant ROLE_GAS_EXCHANGE = 0x9fe43636e0675246c99e96d7abf9f858f518b9442c35166d87f0934abef8a969;
184 
185     // allows to set token exchange rates keccak("TokenRateOracle")
186     bytes32 internal constant ROLE_TOKEN_RATE_ORACLE = 0xa80c3a0c8a5324136e4c806a778583a2a980f378bdd382921b8d28dcfe965585;
187 }
188 
189 contract IEthereumForkArbiter {
190 
191     ////////////////////////
192     // Events
193     ////////////////////////
194 
195     event LogForkAnnounced(
196         string name,
197         string url,
198         uint256 blockNumber
199     );
200 
201     event LogForkSigned(
202         uint256 blockNumber,
203         bytes32 blockHash
204     );
205 
206     ////////////////////////
207     // Public functions
208     ////////////////////////
209 
210     function nextForkName()
211         public
212         constant
213         returns (string);
214 
215     function nextForkUrl()
216         public
217         constant
218         returns (string);
219 
220     function nextForkBlockNumber()
221         public
222         constant
223         returns (uint256);
224 
225     function lastSignedBlockNumber()
226         public
227         constant
228         returns (uint256);
229 
230     function lastSignedBlockHash()
231         public
232         constant
233         returns (bytes32);
234 
235     function lastSignedTimestamp()
236         public
237         constant
238         returns (uint256);
239 
240 }
241 
242 /**
243  * @title legally binding smart contract
244  * @dev General approach to paring legal and smart contracts:
245  * 1. All terms and agreement are between two parties: here between smart conctract legal representation and platform investor.
246  * 2. Parties are represented by public Ethereum addresses. Platform investor is and address that holds and controls funds and receives and controls Neumark token
247  * 3. Legal agreement has immutable part that corresponds to smart contract code and mutable part that may change for example due to changing regulations or other externalities that smart contract does not control.
248  * 4. There should be a provision in legal document that future changes in mutable part cannot change terms of immutable part.
249  * 5. Immutable part links to corresponding smart contract via its address.
250  * 6. Additional provision should be added if smart contract supports it
251  *  a. Fork provision
252  *  b. Bugfixing provision (unilateral code update mechanism)
253  *  c. Migration provision (bilateral code update mechanism)
254  *
255  * Details on Agreement base class:
256  * 1. We bind smart contract to legal contract by storing uri (preferably ipfs or hash) of the legal contract in the smart contract. It is however crucial that such binding is done by smart contract legal representation so transaction establishing the link must be signed by respective wallet ('amendAgreement')
257  * 2. Mutable part of agreement may change. We should be able to amend the uri later. Previous amendments should not be lost and should be retrievable (`amendAgreement` and 'pastAgreement' functions).
258  * 3. It is up to deriving contract to decide where to put 'acceptAgreement' modifier. However situation where there is no cryptographic proof that given address was really acting in the transaction should be avoided, simplest example being 'to' address in `transfer` function of ERC20.
259  *
260 **/
261 contract IAgreement {
262 
263     ////////////////////////
264     // Events
265     ////////////////////////
266 
267     event LogAgreementAccepted(
268         address indexed accepter
269     );
270 
271     event LogAgreementAmended(
272         address contractLegalRepresentative,
273         string agreementUri
274     );
275 
276     /// @dev should have access restrictions so only contractLegalRepresentative may call
277     function amendAgreement(string agreementUri) public;
278 
279     /// returns information on last amendment of the agreement
280     /// @dev MUST revert if no agreements were set
281     function currentAgreement()
282         public
283         constant
284         returns
285         (
286             address contractLegalRepresentative,
287             uint256 signedBlockTimestamp,
288             string agreementUri,
289             uint256 index
290         );
291 
292     /// returns information on amendment with index
293     /// @dev MAY revert on non existing amendment, indexing starts from 0
294     function pastAgreement(uint256 amendmentIndex)
295         public
296         constant
297         returns
298         (
299             address contractLegalRepresentative,
300             uint256 signedBlockTimestamp,
301             string agreementUri,
302             uint256 index
303         );
304 
305     /// returns the number of block at wchich `signatory` signed agreement
306     /// @dev MUST return 0 if not signed
307     function agreementSignedAtBlock(address signatory)
308         public
309         constant
310         returns (uint256 blockNo);
311 
312     /// returns number of amendments made by contractLegalRepresentative
313     function amendmentsCount()
314         public
315         constant
316         returns (uint256);
317 }
318 
319 /**
320  * @title legally binding smart contract
321  * @dev read IAgreement for details
322 **/
323 contract Agreement is
324     IAgreement,
325     AccessControlled,
326     AccessRoles
327 {
328 
329     ////////////////////////
330     // Type declarations
331     ////////////////////////
332 
333     /// @notice agreement with signature of the platform operator representative
334     struct SignedAgreement {
335         address contractLegalRepresentative;
336         uint256 signedBlockTimestamp;
337         string agreementUri;
338     }
339 
340     ////////////////////////
341     // Immutable state
342     ////////////////////////
343 
344     IEthereumForkArbiter private ETHEREUM_FORK_ARBITER;
345 
346     ////////////////////////
347     // Mutable state
348     ////////////////////////
349 
350     // stores all amendments to the agreement, first amendment is the original
351     SignedAgreement[] private _amendments;
352 
353     // stores block numbers of all addresses that signed the agreement (signatory => block number)
354     mapping(address => uint256) private _signatories;
355 
356     ////////////////////////
357     // Modifiers
358     ////////////////////////
359 
360     /// @notice logs that agreement was accepted by platform user
361     /// @dev intended to be added to functions that if used make 'accepter' origin to enter legally binding agreement
362     modifier acceptAgreement(address accepter) {
363         acceptAgreementInternal(accepter);
364         _;
365     }
366 
367     modifier onlyLegalRepresentative(address legalRepresentative) {
368         require(mCanAmend(legalRepresentative));
369         _;
370     }
371 
372     ////////////////////////
373     // Constructor
374     ////////////////////////
375 
376     constructor(IAccessPolicy accessPolicy, IEthereumForkArbiter forkArbiter)
377         AccessControlled(accessPolicy)
378         internal
379     {
380         require(forkArbiter != IEthereumForkArbiter(0x0));
381         ETHEREUM_FORK_ARBITER = forkArbiter;
382     }
383 
384     ////////////////////////
385     // Public functions
386     ////////////////////////
387 
388     function amendAgreement(string agreementUri)
389         public
390         onlyLegalRepresentative(msg.sender)
391     {
392         SignedAgreement memory amendment = SignedAgreement({
393             contractLegalRepresentative: msg.sender,
394             signedBlockTimestamp: block.timestamp,
395             agreementUri: agreementUri
396         });
397         _amendments.push(amendment);
398         emit LogAgreementAmended(msg.sender, agreementUri);
399     }
400 
401     function ethereumForkArbiter()
402         public
403         constant
404         returns (IEthereumForkArbiter)
405     {
406         return ETHEREUM_FORK_ARBITER;
407     }
408 
409     function currentAgreement()
410         public
411         constant
412         returns
413         (
414             address contractLegalRepresentative,
415             uint256 signedBlockTimestamp,
416             string agreementUri,
417             uint256 index
418         )
419     {
420         require(_amendments.length > 0);
421         uint256 last = _amendments.length - 1;
422         SignedAgreement storage amendment = _amendments[last];
423         return (
424             amendment.contractLegalRepresentative,
425             amendment.signedBlockTimestamp,
426             amendment.agreementUri,
427             last
428         );
429     }
430 
431     function pastAgreement(uint256 amendmentIndex)
432         public
433         constant
434         returns
435         (
436             address contractLegalRepresentative,
437             uint256 signedBlockTimestamp,
438             string agreementUri,
439             uint256 index
440         )
441     {
442         SignedAgreement storage amendment = _amendments[amendmentIndex];
443         return (
444             amendment.contractLegalRepresentative,
445             amendment.signedBlockTimestamp,
446             amendment.agreementUri,
447             amendmentIndex
448         );
449     }
450 
451     function agreementSignedAtBlock(address signatory)
452         public
453         constant
454         returns (uint256 blockNo)
455     {
456         return _signatories[signatory];
457     }
458 
459     function amendmentsCount()
460         public
461         constant
462         returns (uint256)
463     {
464         return _amendments.length;
465     }
466 
467     ////////////////////////
468     // Internal functions
469     ////////////////////////
470 
471     /// provides direct access to derived contract
472     function acceptAgreementInternal(address accepter)
473         internal
474     {
475         if(_signatories[accepter] == 0) {
476             require(_amendments.length > 0);
477             _signatories[accepter] = block.number;
478             emit LogAgreementAccepted(accepter);
479         }
480     }
481 
482     //
483     // MAgreement Internal interface (todo: extract)
484     //
485 
486     /// default amend permission goes to ROLE_PLATFORM_OPERATOR_REPRESENTATIVE
487     function mCanAmend(address legalRepresentative)
488         internal
489         returns (bool)
490     {
491         return accessPolicy().allowed(legalRepresentative, ROLE_PLATFORM_OPERATOR_REPRESENTATIVE, this, msg.sig);
492     }
493 }
494 
495 /// @title uniquely identifies deployable (non-abstract) platform contract
496 /// @notice cheap way of assigning implementations to knownInterfaces which represent system services
497 ///         unfortunatelly ERC165 does not include full public interface (ABI) and does not provide way to list implemented interfaces
498 ///         EIP820 still in the making
499 /// @dev ids are generated as follows keccak256("neufund-platform:<contract name>")
500 ///      ids roughly correspond to ABIs
501 contract IContractId {
502     /// @param id defined as above
503     /// @param version implementation version
504     function contractId() public pure returns (bytes32 id, uint256 version);
505 }
506 
507 contract ShareholderRights is IContractId {
508 
509     ////////////////////////
510     // Types
511     ////////////////////////
512 
513     enum VotingRule {
514         // nominee has no voting rights
515         NoVotingRights,
516         // nominee votes yes if token holders do not say otherwise
517         Positive,
518         // nominee votes against if token holders do not say otherwise
519         Negative,
520         // nominee passes the vote as is giving yes/no split
521         Proportional
522     }
523 
524     ////////////////////////
525     // Constants state
526     ////////////////////////
527 
528     bytes32 private constant EMPTY_STRING_HASH = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
529 
530     ////////////////////////
531     // Immutable state
532     ////////////////////////
533 
534     // a right to drag along (or be dragged) on exit
535     bool public constant HAS_DRAG_ALONG_RIGHTS = true;
536     // a right to tag along
537     bool public constant HAS_TAG_ALONG_RIGHTS = true;
538     // information is fundamental right that cannot be removed
539     bool public constant HAS_GENERAL_INFORMATION_RIGHTS = true;
540     // voting Right
541     VotingRule public GENERAL_VOTING_RULE;
542     // voting rights in tag along
543     VotingRule public TAG_ALONG_VOTING_RULE;
544     // liquidation preference multiplicator as decimal fraction
545     uint256 public LIQUIDATION_PREFERENCE_MULTIPLIER_FRAC;
546     // founder's vesting
547     bool public HAS_FOUNDERS_VESTING;
548     // duration of general voting
549     uint256 public GENERAL_VOTING_DURATION;
550     // duration of restricted act votings (like exit etc.)
551     uint256 public RESTRICTED_ACT_VOTING_DURATION;
552     // offchain time to finalize and execute voting;
553     uint256 public VOTING_FINALIZATION_DURATION;
554     // quorum of tokenholders for the vote to count as decimal fraction
555     uint256 public TOKENHOLDERS_QUORUM_FRAC = 10**17; // 10%
556     // number of tokens voting / total supply must be more than this to count the vote
557     uint256 public VOTING_MAJORITY_FRAC = 10**17; // 10%
558     // url (typically IPFS hash) to investment agreement between nominee and company
559     string public INVESTMENT_AGREEMENT_TEMPLATE_URL;
560 
561     ////////////////////////
562     // Constructor
563     ////////////////////////
564 
565     constructor(
566         VotingRule generalVotingRule,
567         VotingRule tagAlongVotingRule,
568         uint256 liquidationPreferenceMultiplierFrac,
569         bool hasFoundersVesting,
570         uint256 generalVotingDuration,
571         uint256 restrictedActVotingDuration,
572         uint256 votingFinalizationDuration,
573         uint256 tokenholdersQuorumFrac,
574         uint256 votingMajorityFrac,
575         string investmentAgreementTemplateUrl
576     )
577         public
578     {
579         // todo: revise requires
580         require(uint(generalVotingRule) < 4);
581         require(uint(tagAlongVotingRule) < 4);
582         // quorum < 100%
583         require(tokenholdersQuorumFrac < 10**18);
584         require(keccak256(abi.encodePacked(investmentAgreementTemplateUrl)) != EMPTY_STRING_HASH);
585 
586         GENERAL_VOTING_RULE = generalVotingRule;
587         TAG_ALONG_VOTING_RULE = tagAlongVotingRule;
588         LIQUIDATION_PREFERENCE_MULTIPLIER_FRAC = liquidationPreferenceMultiplierFrac;
589         HAS_FOUNDERS_VESTING = hasFoundersVesting;
590         GENERAL_VOTING_DURATION = generalVotingDuration;
591         RESTRICTED_ACT_VOTING_DURATION = restrictedActVotingDuration;
592         VOTING_FINALIZATION_DURATION = votingFinalizationDuration;
593         TOKENHOLDERS_QUORUM_FRAC = tokenholdersQuorumFrac;
594         VOTING_MAJORITY_FRAC = votingMajorityFrac;
595         INVESTMENT_AGREEMENT_TEMPLATE_URL = investmentAgreementTemplateUrl;
596     }
597 
598     //
599     // Implements IContractId
600     //
601 
602     function contractId() public pure returns (bytes32 id, uint256 version) {
603         return (0x7f46caed28b4e7a90dc4db9bba18d1565e6c4824f0dc1b96b3b88d730da56e57, 0);
604     }
605 }
606 
607 contract Math {
608 
609     ////////////////////////
610     // Internal functions
611     ////////////////////////
612 
613     // absolute difference: |v1 - v2|
614     function absDiff(uint256 v1, uint256 v2)
615         internal
616         pure
617         returns(uint256)
618     {
619         return v1 > v2 ? v1 - v2 : v2 - v1;
620     }
621 
622     // divide v by d, round up if remainder is 0.5 or more
623     function divRound(uint256 v, uint256 d)
624         internal
625         pure
626         returns(uint256)
627     {
628         return add(v, d/2) / d;
629     }
630 
631     // computes decimal decimalFraction 'frac' of 'amount' with maximum precision (multiplication first)
632     // both amount and decimalFraction must have 18 decimals precision, frac 10**18 represents a whole (100% of) amount
633     // mind loss of precision as decimal fractions do not have finite binary expansion
634     // do not use instead of division
635     function decimalFraction(uint256 amount, uint256 frac)
636         internal
637         pure
638         returns(uint256)
639     {
640         // it's like 1 ether is 100% proportion
641         return proportion(amount, frac, 10**18);
642     }
643 
644     // computes part/total of amount with maximum precision (multiplication first)
645     // part and total must have the same units
646     function proportion(uint256 amount, uint256 part, uint256 total)
647         internal
648         pure
649         returns(uint256)
650     {
651         return divRound(mul(amount, part), total);
652     }
653 
654     //
655     // Open Zeppelin Math library below
656     //
657 
658     function mul(uint256 a, uint256 b)
659         internal
660         pure
661         returns (uint256)
662     {
663         uint256 c = a * b;
664         assert(a == 0 || c / a == b);
665         return c;
666     }
667 
668     function sub(uint256 a, uint256 b)
669         internal
670         pure
671         returns (uint256)
672     {
673         assert(b <= a);
674         return a - b;
675     }
676 
677     function add(uint256 a, uint256 b)
678         internal
679         pure
680         returns (uint256)
681     {
682         uint256 c = a + b;
683         assert(c >= a);
684         return c;
685     }
686 
687     function min(uint256 a, uint256 b)
688         internal
689         pure
690         returns (uint256)
691     {
692         return a < b ? a : b;
693     }
694 
695     function max(uint256 a, uint256 b)
696         internal
697         pure
698         returns (uint256)
699     {
700         return a > b ? a : b;
701     }
702 }
703 
704 /// @title set terms of Platform (investor's network) of the ETO
705 contract PlatformTerms is Math, IContractId {
706 
707     ////////////////////////
708     // Constants
709     ////////////////////////
710 
711     // fraction of fee deduced on successful ETO (see Math.sol for fraction definition)
712     uint256 public constant PLATFORM_FEE_FRACTION = 3 * 10**16;
713     // fraction of tokens deduced on succesful ETO
714     uint256 public constant TOKEN_PARTICIPATION_FEE_FRACTION = 2 * 10**16;
715     // share of Neumark reward platform operator gets
716     // actually this is a divisor that splits Neumark reward in two parts
717     // the results of division belongs to platform operator, the remaining reward part belongs to investor
718     uint256 public constant PLATFORM_NEUMARK_SHARE = 2; // 50:50 division
719     // ICBM investors whitelisted by default
720     bool public constant IS_ICBM_INVESTOR_WHITELISTED = true;
721 
722     // minimum ticket size Platform accepts in EUR ULPS
723     uint256 public constant MIN_TICKET_EUR_ULPS = 100 * 10**18;
724     // maximum ticket size Platform accepts in EUR ULPS
725     // no max ticket in general prospectus regulation
726     // uint256 public constant MAX_TICKET_EUR_ULPS = 10000000 * 10**18;
727 
728     // min duration from setting the date to ETO start
729     uint256 public constant DATE_TO_WHITELIST_MIN_DURATION = 5 days;
730     // token rate expires after
731     uint256 public constant TOKEN_RATE_EXPIRES_AFTER = 4 hours;
732 
733     // duration constraints
734     uint256 public constant MIN_WHITELIST_DURATION = 0 days;
735     uint256 public constant MAX_WHITELIST_DURATION = 30 days;
736     uint256 public constant MIN_PUBLIC_DURATION = 0 days;
737     uint256 public constant MAX_PUBLIC_DURATION = 60 days;
738 
739     // minimum length of whole offer
740     uint256 public constant MIN_OFFER_DURATION = 1 days;
741     // quarter should be enough for everyone
742     uint256 public constant MAX_OFFER_DURATION = 90 days;
743 
744     uint256 public constant MIN_SIGNING_DURATION = 14 days;
745     uint256 public constant MAX_SIGNING_DURATION = 60 days;
746 
747     uint256 public constant MIN_CLAIM_DURATION = 7 days;
748     uint256 public constant MAX_CLAIM_DURATION = 30 days;
749 
750     ////////////////////////
751     // Public Function
752     ////////////////////////
753 
754     // calculates investor's and platform operator's neumarks from total reward
755     function calculateNeumarkDistribution(uint256 rewardNmk)
756         public
757         pure
758         returns (uint256 platformNmk, uint256 investorNmk)
759     {
760         // round down - platform may get 1 wei less than investor
761         platformNmk = rewardNmk / PLATFORM_NEUMARK_SHARE;
762         // rewardNmk > platformNmk always
763         return (platformNmk, rewardNmk - platformNmk);
764     }
765 
766     function calculatePlatformTokenFee(uint256 tokenAmount)
767         public
768         pure
769         returns (uint256)
770     {
771         // mind tokens having 0 precision
772         return proportion(tokenAmount, TOKEN_PARTICIPATION_FEE_FRACTION, 10**18);
773     }
774 
775     function calculatePlatformFee(uint256 amount)
776         public
777         pure
778         returns (uint256)
779     {
780         return decimalFraction(amount, PLATFORM_FEE_FRACTION);
781     }
782 
783     //
784     // Implements IContractId
785     //
786 
787     function contractId() public pure returns (bytes32 id, uint256 version) {
788         return (0x95482babc4e32de6c4dc3910ee7ae62c8e427efde6bc4e9ce0d6d93e24c39323, 0);
789     }
790 }
791 
792 /// @title describes layout of claims in 256bit records stored for identities
793 /// @dev intended to be derived by contracts requiring access to particular claims
794 contract IdentityRecord {
795 
796     ////////////////////////
797     // Types
798     ////////////////////////
799 
800     /// @dev here the idea is to have claims of size of uint256 and use this struct
801     ///     to translate in and out of this struct. until we do not cross uint256 we
802     ///     have binary compatibility
803     struct IdentityClaims {
804         bool isVerified; // 1 bit
805         bool isSophisticatedInvestor; // 1 bit
806         bool hasBankAccount; // 1 bit
807         bool accountFrozen; // 1 bit
808         // uint252 reserved
809     }
810 
811     ////////////////////////
812     // Internal functions
813     ////////////////////////
814 
815     /// translates uint256 to struct
816     function deserializeClaims(bytes32 data) internal pure returns (IdentityClaims memory claims) {
817         // for memory layout of struct, each field below word length occupies whole word
818         assembly {
819             mstore(claims, and(data, 0x1))
820             mstore(add(claims, 0x20), div(and(data, 0x2), 0x2))
821             mstore(add(claims, 0x40), div(and(data, 0x4), 0x4))
822             mstore(add(claims, 0x60), div(and(data, 0x8), 0x8))
823         }
824     }
825 }
826 
827 
828 /// @title interface storing and retrieve 256bit claims records for identity
829 /// actual format of record is decoupled from storage (except maximum size)
830 contract IIdentityRegistry {
831 
832     ////////////////////////
833     // Events
834     ////////////////////////
835 
836     /// provides information on setting claims
837     event LogSetClaims(
838         address indexed identity,
839         bytes32 oldClaims,
840         bytes32 newClaims
841     );
842 
843     ////////////////////////
844     // Public functions
845     ////////////////////////
846 
847     /// get claims for identity
848     function getClaims(address identity) public constant returns (bytes32);
849 
850     /// set claims for identity
851     /// @dev odlClaims and newClaims used for optimistic locking. to override with newClaims
852     ///     current claims must be oldClaims
853     function setClaims(address identity, bytes32 oldClaims, bytes32 newClaims) public;
854 }
855 
856 /// @title known interfaces (services) of the platform
857 /// "known interface" is a unique id of service provided by the platform and discovered via Universe contract
858 ///  it does not refer to particular contract/interface ABI, particular service may be delivered via different implementations
859 ///  however for a few contracts we commit platform to particular implementation (all ICBM Contracts, Universe itself etc.)
860 /// @dev constants are kept in CODE not in STORAGE so they are comparatively cheap
861 contract KnownInterfaces {
862 
863     ////////////////////////
864     // Constants
865     ////////////////////////
866 
867     // NOTE: All interface are set to the keccak256 hash of the
868     // CamelCased interface or singleton name, i.e.
869     // KNOWN_INTERFACE_NEUMARK = keccak256("Neumark")
870 
871     // EIP 165 + EIP 820 should be use instead but it seems they are far from finished
872     // also interface signature should be build automatically by solidity. otherwise it is a pure hassle
873 
874     // neumark token interface and sigleton keccak256("Neumark")
875     bytes4 internal constant KNOWN_INTERFACE_NEUMARK = 0xeb41a1bd;
876 
877     // ether token interface and singleton keccak256("EtherToken")
878     bytes4 internal constant KNOWN_INTERFACE_ETHER_TOKEN = 0x8cf73cf1;
879 
880     // euro token interface and singleton keccak256("EuroToken")
881     bytes4 internal constant KNOWN_INTERFACE_EURO_TOKEN = 0x83c3790b;
882 
883     // identity registry interface and singleton keccak256("IIdentityRegistry")
884     bytes4 internal constant KNOWN_INTERFACE_IDENTITY_REGISTRY = 0x0a72e073;
885 
886     // currency rates oracle interface and singleton keccak256("ITokenExchangeRateOracle")
887     bytes4 internal constant KNOWN_INTERFACE_TOKEN_EXCHANGE_RATE_ORACLE = 0xc6e5349e;
888 
889     // fee disbursal interface and singleton keccak256("IFeeDisbursal")
890     bytes4 internal constant KNOWN_INTERFACE_FEE_DISBURSAL = 0xf4c848e8;
891 
892     // platform portfolio holding equity tokens belonging to NEU holders keccak256("IPlatformPortfolio");
893     bytes4 internal constant KNOWN_INTERFACE_PLATFORM_PORTFOLIO = 0xaa1590d0;
894 
895     // token exchange interface and singleton keccak256("ITokenExchange")
896     bytes4 internal constant KNOWN_INTERFACE_TOKEN_EXCHANGE = 0xddd7a521;
897 
898     // service exchanging euro token for gas ("IGasTokenExchange")
899     bytes4 internal constant KNOWN_INTERFACE_GAS_EXCHANGE = 0x89dbc6de;
900 
901     // access policy interface and singleton keccak256("IAccessPolicy")
902     bytes4 internal constant KNOWN_INTERFACE_ACCESS_POLICY = 0xb05049d9;
903 
904     // euro lock account (upgraded) keccak256("LockedAccount:Euro")
905     bytes4 internal constant KNOWN_INTERFACE_EURO_LOCK = 0x2347a19e;
906 
907     // ether lock account (upgraded) keccak256("LockedAccount:Ether")
908     bytes4 internal constant KNOWN_INTERFACE_ETHER_LOCK = 0x978a6823;
909 
910     // icbm euro lock account keccak256("ICBMLockedAccount:Euro")
911     bytes4 internal constant KNOWN_INTERFACE_ICBM_EURO_LOCK = 0x36021e14;
912 
913     // ether lock account (upgraded) keccak256("ICBMLockedAccount:Ether")
914     bytes4 internal constant KNOWN_INTERFACE_ICBM_ETHER_LOCK = 0x0b58f006;
915 
916     // ether token interface and singleton keccak256("ICBMEtherToken")
917     bytes4 internal constant KNOWN_INTERFACE_ICBM_ETHER_TOKEN = 0xae8b50b9;
918 
919     // euro token interface and singleton keccak256("ICBMEuroToken")
920     bytes4 internal constant KNOWN_INTERFACE_ICBM_EURO_TOKEN = 0xc2c6cd72;
921 
922     // ICBM commitment interface interface and singleton keccak256("ICBMCommitment")
923     bytes4 internal constant KNOWN_INTERFACE_ICBM_COMMITMENT = 0x7f2795ef;
924 
925     // ethereum fork arbiter interface and singleton keccak256("IEthereumForkArbiter")
926     bytes4 internal constant KNOWN_INTERFACE_FORK_ARBITER = 0x2fe7778c;
927 
928     // Platform terms interface and singletong keccak256("PlatformTerms")
929     bytes4 internal constant KNOWN_INTERFACE_PLATFORM_TERMS = 0x75ecd7f8;
930 
931     // for completness we define Universe service keccak256("Universe");
932     bytes4 internal constant KNOWN_INTERFACE_UNIVERSE = 0xbf202454;
933 
934     // ETO commitment interface (collection) keccak256("ICommitment")
935     bytes4 internal constant KNOWN_INTERFACE_COMMITMENT = 0xfa0e0c60;
936 
937     // Equity Token Controller interface (collection) keccak256("IEquityTokenController")
938     bytes4 internal constant KNOWN_INTERFACE_EQUITY_TOKEN_CONTROLLER = 0xfa30b2f1;
939 
940     // Equity Token interface (collection) keccak256("IEquityToken")
941     bytes4 internal constant KNOWN_INTERFACE_EQUITY_TOKEN = 0xab9885bb;
942 }
943 
944 contract IsContract {
945 
946     ////////////////////////
947     // Internal functions
948     ////////////////////////
949 
950     function isContract(address addr)
951         internal
952         constant
953         returns (bool)
954     {
955         uint256 size;
956         // takes 700 gas
957         assembly { size := extcodesize(addr) }
958         return size > 0;
959     }
960 }
961 
962 contract NeumarkIssuanceCurve {
963 
964     ////////////////////////
965     // Constants
966     ////////////////////////
967 
968     // maximum number of neumarks that may be created
969     uint256 private constant NEUMARK_CAP = 1500000000000000000000000000;
970 
971     // initial neumark reward fraction (controls curve steepness)
972     uint256 private constant INITIAL_REWARD_FRACTION = 6500000000000000000;
973 
974     // stop issuing new Neumarks above this Euro value (as it goes quickly to zero)
975     uint256 private constant ISSUANCE_LIMIT_EUR_ULPS = 8300000000000000000000000000;
976 
977     // approximate curve linearly above this Euro value
978     uint256 private constant LINEAR_APPROX_LIMIT_EUR_ULPS = 2100000000000000000000000000;
979     uint256 private constant NEUMARKS_AT_LINEAR_LIMIT_ULPS = 1499832501287264827896539871;
980 
981     uint256 private constant TOT_LINEAR_NEUMARKS_ULPS = NEUMARK_CAP - NEUMARKS_AT_LINEAR_LIMIT_ULPS;
982     uint256 private constant TOT_LINEAR_EUR_ULPS = ISSUANCE_LIMIT_EUR_ULPS - LINEAR_APPROX_LIMIT_EUR_ULPS;
983 
984     ////////////////////////
985     // Public functions
986     ////////////////////////
987 
988     /// @notice returns additional amount of neumarks issued for euroUlps at totalEuroUlps
989     /// @param totalEuroUlps actual curve position from which neumarks will be issued
990     /// @param euroUlps amount against which neumarks will be issued
991     function incremental(uint256 totalEuroUlps, uint256 euroUlps)
992         public
993         pure
994         returns (uint256 neumarkUlps)
995     {
996         require(totalEuroUlps + euroUlps >= totalEuroUlps);
997         uint256 from = cumulative(totalEuroUlps);
998         uint256 to = cumulative(totalEuroUlps + euroUlps);
999         // as expansion is not monotonic for large totalEuroUlps, assert below may fail
1000         // example: totalEuroUlps=1.999999999999999999999000000e+27 and euroUlps=50
1001         assert(to >= from);
1002         return to - from;
1003     }
1004 
1005     /// @notice returns amount of euro corresponding to burned neumarks
1006     /// @param totalEuroUlps actual curve position from which neumarks will be burned
1007     /// @param burnNeumarkUlps amount of neumarks to burn
1008     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps)
1009         public
1010         pure
1011         returns (uint256 euroUlps)
1012     {
1013         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
1014         require(totalNeumarkUlps >= burnNeumarkUlps);
1015         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
1016         uint newTotalEuroUlps = cumulativeInverse(fromNmk, 0, totalEuroUlps);
1017         // yes, this may overflow due to non monotonic inverse function
1018         assert(totalEuroUlps >= newTotalEuroUlps);
1019         return totalEuroUlps - newTotalEuroUlps;
1020     }
1021 
1022     /// @notice returns amount of euro corresponding to burned neumarks
1023     /// @param totalEuroUlps actual curve position from which neumarks will be burned
1024     /// @param burnNeumarkUlps amount of neumarks to burn
1025     /// @param minEurUlps euro amount to start inverse search from, inclusive
1026     /// @param maxEurUlps euro amount to end inverse search to, inclusive
1027     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
1028         public
1029         pure
1030         returns (uint256 euroUlps)
1031     {
1032         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
1033         require(totalNeumarkUlps >= burnNeumarkUlps);
1034         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
1035         uint newTotalEuroUlps = cumulativeInverse(fromNmk, minEurUlps, maxEurUlps);
1036         // yes, this may overflow due to non monotonic inverse function
1037         assert(totalEuroUlps >= newTotalEuroUlps);
1038         return totalEuroUlps - newTotalEuroUlps;
1039     }
1040 
1041     /// @notice finds total amount of neumarks issued for given amount of Euro
1042     /// @dev binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
1043     ///     function below is not monotonic
1044     function cumulative(uint256 euroUlps)
1045         public
1046         pure
1047         returns(uint256 neumarkUlps)
1048     {
1049         // Return the cap if euroUlps is above the limit.
1050         if (euroUlps >= ISSUANCE_LIMIT_EUR_ULPS) {
1051             return NEUMARK_CAP;
1052         }
1053         // use linear approximation above limit below
1054         // binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
1055         if (euroUlps >= LINEAR_APPROX_LIMIT_EUR_ULPS) {
1056             // (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS) is small so expression does not overflow
1057             return NEUMARKS_AT_LINEAR_LIMIT_ULPS + (TOT_LINEAR_NEUMARKS_ULPS * (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS)) / TOT_LINEAR_EUR_ULPS;
1058         }
1059 
1060         // Approximate cap-cap·(1-1/D)^n using the Binomial expansion
1061         // http://galileo.phys.virginia.edu/classes/152.mf1i.spring02/Exponential_Function.htm
1062         // Function[imax, -CAP*Sum[(-IR*EUR/CAP)^i/Factorial[i], {i, imax}]]
1063         // which may be simplified to
1064         // Function[imax, -CAP*Sum[(EUR)^i/(Factorial[i]*(-d)^i), {i, 1, imax}]]
1065         // where d = cap/initial_reward
1066         uint256 d = 230769230769230769230769231; // NEUMARK_CAP / INITIAL_REWARD_FRACTION
1067         uint256 term = NEUMARK_CAP;
1068         uint256 sum = 0;
1069         uint256 denom = d;
1070         do assembly {
1071             // We use assembler primarily to avoid the expensive
1072             // divide-by-zero check solc inserts for the / operator.
1073             term  := div(mul(term, euroUlps), denom)
1074             sum   := add(sum, term)
1075             denom := add(denom, d)
1076             // sub next term as we have power of negative value in the binomial expansion
1077             term  := div(mul(term, euroUlps), denom)
1078             sum   := sub(sum, term)
1079             denom := add(denom, d)
1080         } while (term != 0);
1081         return sum;
1082     }
1083 
1084     /// @notice find issuance curve inverse by binary search
1085     /// @param neumarkUlps neumark amount to compute inverse for
1086     /// @param minEurUlps minimum search range for the inverse, inclusive
1087     /// @param maxEurUlps maxium search range for the inverse, inclusive
1088     /// @dev in case of approximate search (no exact inverse) upper element of minimal search range is returned
1089     /// @dev in case of many possible inverses, the lowest one will be used (if range permits)
1090     /// @dev corresponds to a linear search that returns first euroUlp value that has cumulative() equal or greater than neumarkUlps
1091     function cumulativeInverse(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
1092         public
1093         pure
1094         returns (uint256 euroUlps)
1095     {
1096         require(maxEurUlps >= minEurUlps);
1097         require(cumulative(minEurUlps) <= neumarkUlps);
1098         require(cumulative(maxEurUlps) >= neumarkUlps);
1099         uint256 min = minEurUlps;
1100         uint256 max = maxEurUlps;
1101 
1102         // Binary search
1103         while (max > min) {
1104             uint256 mid = (max + min) / 2;
1105             uint256 val = cumulative(mid);
1106             // exact solution should not be used, a late points of the curve when many euroUlps are needed to
1107             // increase by one nmkUlp this will lead to  "indeterministic" inverse values that depend on the initial min and max
1108             // and further binary division -> you can land at any of the euro value that is mapped to the same nmk value
1109             // with condition below removed, binary search will point to the lowest eur value possible which is good because it cannot be exploited even with 0 gas costs
1110             /* if (val == neumarkUlps) {
1111                 return mid;
1112             }*/
1113             // NOTE: approximate search (no inverse) must return upper element of the final range
1114             //  last step of approximate search is always (min, min+1) so new mid is (2*min+1)/2 => min
1115             //  so new min = mid + 1 = max which was upper range. and that ends the search
1116             // NOTE: when there are multiple inverses for the same neumarkUlps, the `max` will be dragged down
1117             //  by `max = mid` expression to the lowest eur value of inverse. works only for ranges that cover all points of multiple inverse
1118             if (val < neumarkUlps) {
1119                 min = mid + 1;
1120             } else {
1121                 max = mid;
1122             }
1123         }
1124         // NOTE: It is possible that there is no inverse
1125         //  for example curve(0) = 0 and curve(1) = 6, so
1126         //  there is no value y such that curve(y) = 5.
1127         //  When there is no inverse, we must return upper element of last search range.
1128         //  This has the effect of reversing the curve less when
1129         //  burning Neumarks. This ensures that Neumarks can always
1130         //  be burned. It also ensure that the total supply of Neumarks
1131         //  remains below the cap.
1132         return max;
1133     }
1134 
1135     function neumarkCap()
1136         public
1137         pure
1138         returns (uint256)
1139     {
1140         return NEUMARK_CAP;
1141     }
1142 
1143     function initialRewardFraction()
1144         public
1145         pure
1146         returns (uint256)
1147     {
1148         return INITIAL_REWARD_FRACTION;
1149     }
1150 }
1151 
1152 contract IBasicToken {
1153 
1154     ////////////////////////
1155     // Events
1156     ////////////////////////
1157 
1158     event Transfer(
1159         address indexed from,
1160         address indexed to,
1161         uint256 amount
1162     );
1163 
1164     ////////////////////////
1165     // Public functions
1166     ////////////////////////
1167 
1168     /// @dev This function makes it easy to get the total number of tokens
1169     /// @return The total number of tokens
1170     function totalSupply()
1171         public
1172         constant
1173         returns (uint256);
1174 
1175     /// @param owner The address that's balance is being requested
1176     /// @return The balance of `owner` at the current block
1177     function balanceOf(address owner)
1178         public
1179         constant
1180         returns (uint256 balance);
1181 
1182     /// @notice Send `amount` tokens to `to` from `msg.sender`
1183     /// @param to The address of the recipient
1184     /// @param amount The amount of tokens to be transferred
1185     /// @return Whether the transfer was successful or not
1186     function transfer(address to, uint256 amount)
1187         public
1188         returns (bool success);
1189 
1190 }
1191 
1192 /// @title allows deriving contract to recover any token or ether that it has balance of
1193 /// @notice note that this opens your contracts to claims from various people saying they lost tokens and they want them back
1194 ///     be ready to handle such claims
1195 /// @dev use with care!
1196 ///     1. ROLE_RECLAIMER is allowed to claim tokens, it's not returning tokens to original owner
1197 ///     2. in derived contract that holds any token by design you must override `reclaim` and block such possibility.
1198 ///         see ICBMLockedAccount as an example
1199 contract Reclaimable is AccessControlled, AccessRoles {
1200 
1201     ////////////////////////
1202     // Constants
1203     ////////////////////////
1204 
1205     IBasicToken constant internal RECLAIM_ETHER = IBasicToken(0x0);
1206 
1207     ////////////////////////
1208     // Public functions
1209     ////////////////////////
1210 
1211     function reclaim(IBasicToken token)
1212         public
1213         only(ROLE_RECLAIMER)
1214     {
1215         address reclaimer = msg.sender;
1216         if(token == RECLAIM_ETHER) {
1217             reclaimer.transfer(address(this).balance);
1218         } else {
1219             uint256 balance = token.balanceOf(this);
1220             require(token.transfer(reclaimer, balance));
1221         }
1222     }
1223 }
1224 
1225 /// @title advances snapshot id on demand
1226 /// @dev see Snapshot folder for implementation examples ie. DailyAndSnapshotable contract
1227 contract ISnapshotable {
1228 
1229     ////////////////////////
1230     // Events
1231     ////////////////////////
1232 
1233     /// @dev should log each new snapshot id created, including snapshots created automatically via MSnapshotPolicy
1234     event LogSnapshotCreated(uint256 snapshotId);
1235 
1236     ////////////////////////
1237     // Public functions
1238     ////////////////////////
1239 
1240     /// always creates new snapshot id which gets returned
1241     /// however, there is no guarantee that any snapshot will be created with this id, this depends on the implementation of MSnaphotPolicy
1242     function createSnapshot()
1243         public
1244         returns (uint256);
1245 
1246     /// upper bound of series snapshotIds for which there's a value
1247     function currentSnapshotId()
1248         public
1249         constant
1250         returns (uint256);
1251 }
1252 
1253 /// @title Abstracts snapshot id creation logics
1254 /// @dev Mixin (internal interface) of the snapshot policy which abstracts snapshot id creation logics from Snapshot contract
1255 /// @dev to be implemented and such implementation should be mixed with Snapshot-derived contract, see EveryBlock for simplest example of implementation and StandardSnapshotToken
1256 contract MSnapshotPolicy {
1257 
1258     ////////////////////////
1259     // Internal functions
1260     ////////////////////////
1261 
1262     // The snapshot Ids need to be strictly increasing.
1263     // Whenever the snaspshot id changes, a new snapshot will be created.
1264     // As long as the same snapshot id is being returned, last snapshot will be updated as this indicates that snapshot id didn't change
1265     //
1266     // Values passed to `hasValueAt` and `valuteAt` are required
1267     // to be less or equal to `mCurrentSnapshotId()`.
1268     function mAdvanceSnapshotId()
1269         internal
1270         returns (uint256);
1271 
1272     // this is a version of mAdvanceSnapshotId that does not modify state but MUST return the same value
1273     // it is required to implement ITokenSnapshots interface cleanly
1274     function mCurrentSnapshotId()
1275         internal
1276         constant
1277         returns (uint256);
1278 
1279 }
1280 
1281 /// @title creates new snapshot id on each day boundary
1282 /// @dev snapshot id is unix timestamp of current day boundary
1283 contract Daily is MSnapshotPolicy {
1284 
1285     ////////////////////////
1286     // Constants
1287     ////////////////////////
1288 
1289     // Floor[2**128 / 1 days]
1290     uint256 private MAX_TIMESTAMP = 3938453320844195178974243141571391;
1291 
1292     ////////////////////////
1293     // Constructor
1294     ////////////////////////
1295 
1296     /// @param start snapshotId from which to start generating values, used to prevent cloning from incompatible schemes
1297     /// @dev start must be for the same day or 0, required for token cloning
1298     constructor(uint256 start) internal {
1299         // 0 is invalid value as we are past unix epoch
1300         if (start > 0) {
1301             uint256 base = dayBase(uint128(block.timestamp));
1302             // must be within current day base
1303             require(start >= base);
1304             // dayBase + 2**128 will not overflow as it is based on block.timestamp
1305             require(start < base + 2**128);
1306         }
1307     }
1308 
1309     ////////////////////////
1310     // Public functions
1311     ////////////////////////
1312 
1313     function snapshotAt(uint256 timestamp)
1314         public
1315         constant
1316         returns (uint256)
1317     {
1318         require(timestamp < MAX_TIMESTAMP);
1319 
1320         return dayBase(uint128(timestamp));
1321     }
1322 
1323     ////////////////////////
1324     // Internal functions
1325     ////////////////////////
1326 
1327     //
1328     // Implements MSnapshotPolicy
1329     //
1330 
1331     function mAdvanceSnapshotId()
1332         internal
1333         returns (uint256)
1334     {
1335         return mCurrentSnapshotId();
1336     }
1337 
1338     function mCurrentSnapshotId()
1339         internal
1340         constant
1341         returns (uint256)
1342     {
1343         // disregard overflows on block.timestamp, see MAX_TIMESTAMP
1344         return dayBase(uint128(block.timestamp));
1345     }
1346 
1347     function dayBase(uint128 timestamp)
1348         internal
1349         pure
1350         returns (uint256)
1351     {
1352         // Round down to the start of the day (00:00 UTC) and place in higher 128bits
1353         return 2**128 * (uint256(timestamp) / 1 days);
1354     }
1355 }
1356 
1357 /// @title creates snapshot id on each day boundary and allows to create additional snapshots within a given day
1358 /// @dev snapshots are encoded in single uint256, where high 128 bits represents a day number (from unix epoch) and low 128 bits represents additional snapshots within given day create via ISnapshotable
1359 contract DailyAndSnapshotable is
1360     Daily,
1361     ISnapshotable
1362 {
1363 
1364     ////////////////////////
1365     // Mutable state
1366     ////////////////////////
1367 
1368     uint256 private _currentSnapshotId;
1369 
1370     ////////////////////////
1371     // Constructor
1372     ////////////////////////
1373 
1374     /// @param start snapshotId from which to start generating values
1375     /// @dev start must be for the same day or 0, required for token cloning
1376     constructor(uint256 start)
1377         internal
1378         Daily(start)
1379     {
1380         if (start > 0) {
1381             _currentSnapshotId = start;
1382         }
1383     }
1384 
1385     ////////////////////////
1386     // Public functions
1387     ////////////////////////
1388 
1389     //
1390     // Implements ISnapshotable
1391     //
1392 
1393     function createSnapshot()
1394         public
1395         returns (uint256)
1396     {
1397         uint256 base = dayBase(uint128(block.timestamp));
1398 
1399         if (base > _currentSnapshotId) {
1400             // New day has started, create snapshot for midnight
1401             _currentSnapshotId = base;
1402         } else {
1403             // within single day, increase counter (assume 2**128 will not be crossed)
1404             _currentSnapshotId += 1;
1405         }
1406 
1407         // Log and return
1408         emit LogSnapshotCreated(_currentSnapshotId);
1409         return _currentSnapshotId;
1410     }
1411 
1412     ////////////////////////
1413     // Internal functions
1414     ////////////////////////
1415 
1416     //
1417     // Implements MSnapshotPolicy
1418     //
1419 
1420     function mAdvanceSnapshotId()
1421         internal
1422         returns (uint256)
1423     {
1424         uint256 base = dayBase(uint128(block.timestamp));
1425 
1426         // New day has started
1427         if (base > _currentSnapshotId) {
1428             _currentSnapshotId = base;
1429             emit LogSnapshotCreated(base);
1430         }
1431 
1432         return _currentSnapshotId;
1433     }
1434 
1435     function mCurrentSnapshotId()
1436         internal
1437         constant
1438         returns (uint256)
1439     {
1440         uint256 base = dayBase(uint128(block.timestamp));
1441 
1442         return base > _currentSnapshotId ? base : _currentSnapshotId;
1443     }
1444 }
1445 
1446 contract ITokenMetadata {
1447 
1448     ////////////////////////
1449     // Public functions
1450     ////////////////////////
1451 
1452     function symbol()
1453         public
1454         constant
1455         returns (string);
1456 
1457     function name()
1458         public
1459         constant
1460         returns (string);
1461 
1462     function decimals()
1463         public
1464         constant
1465         returns (uint8);
1466 }
1467 
1468 /// @title adds token metadata to token contract
1469 /// @dev see Neumark for example implementation
1470 contract TokenMetadata is ITokenMetadata {
1471 
1472     ////////////////////////
1473     // Immutable state
1474     ////////////////////////
1475 
1476     // The Token's name: e.g. DigixDAO Tokens
1477     string private NAME;
1478 
1479     // An identifier: e.g. REP
1480     string private SYMBOL;
1481 
1482     // Number of decimals of the smallest unit
1483     uint8 private DECIMALS;
1484 
1485     // An arbitrary versioning scheme
1486     string private VERSION;
1487 
1488     ////////////////////////
1489     // Constructor
1490     ////////////////////////
1491 
1492     /// @notice Constructor to set metadata
1493     /// @param tokenName Name of the new token
1494     /// @param decimalUnits Number of decimals of the new token
1495     /// @param tokenSymbol Token Symbol for the new token
1496     /// @param version Token version ie. when cloning is used
1497     constructor(
1498         string tokenName,
1499         uint8 decimalUnits,
1500         string tokenSymbol,
1501         string version
1502     )
1503         public
1504     {
1505         NAME = tokenName;                                 // Set the name
1506         SYMBOL = tokenSymbol;                             // Set the symbol
1507         DECIMALS = decimalUnits;                          // Set the decimals
1508         VERSION = version;
1509     }
1510 
1511     ////////////////////////
1512     // Public functions
1513     ////////////////////////
1514 
1515     function name()
1516         public
1517         constant
1518         returns (string)
1519     {
1520         return NAME;
1521     }
1522 
1523     function symbol()
1524         public
1525         constant
1526         returns (string)
1527     {
1528         return SYMBOL;
1529     }
1530 
1531     function decimals()
1532         public
1533         constant
1534         returns (uint8)
1535     {
1536         return DECIMALS;
1537     }
1538 
1539     function version()
1540         public
1541         constant
1542         returns (string)
1543     {
1544         return VERSION;
1545     }
1546 }
1547 
1548 contract IERC20Allowance {
1549 
1550     ////////////////////////
1551     // Events
1552     ////////////////////////
1553 
1554     event Approval(
1555         address indexed owner,
1556         address indexed spender,
1557         uint256 amount
1558     );
1559 
1560     ////////////////////////
1561     // Public functions
1562     ////////////////////////
1563 
1564     /// @dev This function makes it easy to read the `allowed[]` map
1565     /// @param owner The address of the account that owns the token
1566     /// @param spender The address of the account able to transfer the tokens
1567     /// @return Amount of remaining tokens of owner that spender is allowed
1568     ///  to spend
1569     function allowance(address owner, address spender)
1570         public
1571         constant
1572         returns (uint256 remaining);
1573 
1574     /// @notice `msg.sender` approves `spender` to spend `amount` tokens on
1575     ///  its behalf. This is a modified version of the ERC20 approve function
1576     ///  to be a little bit safer
1577     /// @param spender The address of the account able to transfer the tokens
1578     /// @param amount The amount of tokens to be approved for transfer
1579     /// @return True if the approval was successful
1580     function approve(address spender, uint256 amount)
1581         public
1582         returns (bool success);
1583 
1584     /// @notice Send `amount` tokens to `to` from `from` on the condition it
1585     ///  is approved by `from`
1586     /// @param from The address holding the tokens being transferred
1587     /// @param to The address of the recipient
1588     /// @param amount The amount of tokens to be transferred
1589     /// @return True if the transfer was successful
1590     function transferFrom(address from, address to, uint256 amount)
1591         public
1592         returns (bool success);
1593 
1594 }
1595 
1596 contract IERC20Token is IBasicToken, IERC20Allowance {
1597 
1598 }
1599 
1600 /// @title controls spending approvals
1601 /// @dev TokenAllowance observes this interface, Neumark contract implements it
1602 contract MTokenAllowanceController {
1603 
1604     ////////////////////////
1605     // Internal functions
1606     ////////////////////////
1607 
1608     /// @notice Notifies the controller about an approval allowing the
1609     ///  controller to react if desired
1610     /// @param owner The address that calls `approve()`
1611     /// @param spender The spender in the `approve()` call
1612     /// @param amount The amount in the `approve()` call
1613     /// @return False if the controller does not authorize the approval
1614     function mOnApprove(
1615         address owner,
1616         address spender,
1617         uint256 amount
1618     )
1619         internal
1620         returns (bool allow);
1621 
1622     /// @notice Allows to override allowance approved by the owner
1623     ///         Primary role is to enable forced transfers, do not override if you do not like it
1624     ///         Following behavior is expected in the observer
1625     ///         approve() - should revert if mAllowanceOverride() > 0
1626     ///         allowance() - should return mAllowanceOverride() if set
1627     ///         transferFrom() - should override allowance if mAllowanceOverride() > 0
1628     /// @param owner An address giving allowance to spender
1629     /// @param spender An address getting  a right to transfer allowance amount from the owner
1630     /// @return current allowance amount
1631     function mAllowanceOverride(
1632         address owner,
1633         address spender
1634     )
1635         internal
1636         constant
1637         returns (uint256 allowance);
1638 }
1639 
1640 /// @title controls token transfers
1641 /// @dev BasicSnapshotToken observes this interface, Neumark contract implements it
1642 contract MTokenTransferController {
1643 
1644     ////////////////////////
1645     // Internal functions
1646     ////////////////////////
1647 
1648     /// @notice Notifies the controller about a token transfer allowing the
1649     ///  controller to react if desired
1650     /// @param from The origin of the transfer
1651     /// @param to The destination of the transfer
1652     /// @param amount The amount of the transfer
1653     /// @return False if the controller does not authorize the transfer
1654     function mOnTransfer(
1655         address from,
1656         address to,
1657         uint256 amount
1658     )
1659         internal
1660         returns (bool allow);
1661 
1662 }
1663 
1664 /// @title controls approvals and transfers
1665 /// @dev The token controller contract must implement these functions, see Neumark as example
1666 /// @dev please note that controller may be a separate contract that is called from mOnTransfer and mOnApprove functions
1667 contract MTokenController is MTokenTransferController, MTokenAllowanceController {
1668 }
1669 
1670 /// @title internal token transfer function
1671 /// @dev see BasicSnapshotToken for implementation
1672 contract MTokenTransfer {
1673 
1674     ////////////////////////
1675     // Internal functions
1676     ////////////////////////
1677 
1678     /// @dev This is the actual transfer function in the token contract, it can
1679     ///  only be called by other functions in this contract.
1680     /// @param from The address holding the tokens being transferred
1681     /// @param to The address of the recipient
1682     /// @param amount The amount of tokens to be transferred
1683     /// @dev  reverts if transfer was not successful
1684     function mTransfer(
1685         address from,
1686         address to,
1687         uint256 amount
1688     )
1689         internal;
1690 }
1691 
1692 contract IERC677Callback {
1693 
1694     ////////////////////////
1695     // Public functions
1696     ////////////////////////
1697 
1698     // NOTE: This call can be initiated by anyone. You need to make sure that
1699     // it is send by the token (`require(msg.sender == token)`) or make sure
1700     // amount is valid (`require(token.allowance(this) >= amount)`).
1701     function receiveApproval(
1702         address from,
1703         uint256 amount,
1704         address token, // IERC667Token
1705         bytes data
1706     )
1707         public
1708         returns (bool success);
1709 
1710 }
1711 
1712 contract IERC677Allowance is IERC20Allowance {
1713 
1714     ////////////////////////
1715     // Public functions
1716     ////////////////////////
1717 
1718     /// @notice `msg.sender` approves `spender` to send `amount` tokens on
1719     ///  its behalf, and then a function is triggered in the contract that is
1720     ///  being approved, `spender`. This allows users to use their tokens to
1721     ///  interact with contracts in one function call instead of two
1722     /// @param spender The address of the contract able to transfer the tokens
1723     /// @param amount The amount of tokens to be approved for transfer
1724     /// @return True if the function call was successful
1725     function approveAndCall(address spender, uint256 amount, bytes extraData)
1726         public
1727         returns (bool success);
1728 
1729 }
1730 
1731 contract IERC677Token is IERC20Token, IERC677Allowance {
1732 }
1733 
1734 /// @title token spending approval and transfer
1735 /// @dev implements token approval and transfers and exposes relevant part of ERC20 and ERC677 approveAndCall
1736 ///     may be mixed in with any basic token (implementing mTransfer) like BasicSnapshotToken or MintableSnapshotToken to add approval mechanism
1737 ///     observes MTokenAllowanceController interface
1738 ///     observes MTokenTransfer
1739 contract TokenAllowance is
1740     MTokenTransfer,
1741     MTokenAllowanceController,
1742     IERC20Allowance,
1743     IERC677Token
1744 {
1745 
1746     ////////////////////////
1747     // Mutable state
1748     ////////////////////////
1749 
1750     // `allowed` tracks rights to spends others tokens as per ERC20
1751     // owner => spender => amount
1752     mapping (address => mapping (address => uint256)) private _allowed;
1753 
1754     ////////////////////////
1755     // Constructor
1756     ////////////////////////
1757 
1758     constructor()
1759         internal
1760     {
1761     }
1762 
1763     ////////////////////////
1764     // Public functions
1765     ////////////////////////
1766 
1767     //
1768     // Implements IERC20Token
1769     //
1770 
1771     /// @dev This function makes it easy to read the `allowed[]` map
1772     /// @param owner The address of the account that owns the token
1773     /// @param spender The address of the account able to transfer the tokens
1774     /// @return Amount of remaining tokens of _owner that _spender is allowed
1775     ///  to spend
1776     function allowance(address owner, address spender)
1777         public
1778         constant
1779         returns (uint256 remaining)
1780     {
1781         uint256 override = mAllowanceOverride(owner, spender);
1782         if (override > 0) {
1783             return override;
1784         }
1785         return _allowed[owner][spender];
1786     }
1787 
1788     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
1789     ///  its behalf. This is a modified version of the ERC20 approve function
1790     ///  where allowance per spender must be 0 to allow change of such allowance
1791     /// @param spender The address of the account able to transfer the tokens
1792     /// @param amount The amount of tokens to be approved for transfer
1793     /// @return True or reverts, False is never returned
1794     function approve(address spender, uint256 amount)
1795         public
1796         returns (bool success)
1797     {
1798         // Alerts the token controller of the approve function call
1799         require(mOnApprove(msg.sender, spender, amount));
1800 
1801         // To change the approve amount you first have to reduce the addresses`
1802         //  allowance to zero by calling `approve(_spender,0)` if it is not
1803         //  already 0 to mitigate the race condition described here:
1804         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1805         require((amount == 0 || _allowed[msg.sender][spender] == 0) && mAllowanceOverride(msg.sender, spender) == 0);
1806 
1807         _allowed[msg.sender][spender] = amount;
1808         emit Approval(msg.sender, spender, amount);
1809         return true;
1810     }
1811 
1812     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
1813     ///  is approved by `_from`
1814     /// @param from The address holding the tokens being transferred
1815     /// @param to The address of the recipient
1816     /// @param amount The amount of tokens to be transferred
1817     /// @return True if the transfer was successful, reverts in any other case
1818     function transferFrom(address from, address to, uint256 amount)
1819         public
1820         returns (bool success)
1821     {
1822         uint256 allowed = mAllowanceOverride(from, msg.sender);
1823         if (allowed == 0) {
1824             // The standard ERC 20 transferFrom functionality
1825             allowed = _allowed[from][msg.sender];
1826             // yes this will underflow but then we'll revert. will cost gas however so don't underflow
1827             _allowed[from][msg.sender] -= amount;
1828         }
1829         require(allowed >= amount);
1830         mTransfer(from, to, amount);
1831         return true;
1832     }
1833 
1834     //
1835     // Implements IERC677Token
1836     //
1837 
1838     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
1839     ///  its behalf, and then a function is triggered in the contract that is
1840     ///  being approved, `_spender`. This allows users to use their tokens to
1841     ///  interact with contracts in one function call instead of two
1842     /// @param spender The address of the contract able to transfer the tokens
1843     /// @param amount The amount of tokens to be approved for transfer
1844     /// @return True or reverts, False is never returned
1845     function approveAndCall(
1846         address spender,
1847         uint256 amount,
1848         bytes extraData
1849     )
1850         public
1851         returns (bool success)
1852     {
1853         require(approve(spender, amount));
1854 
1855         success = IERC677Callback(spender).receiveApproval(
1856             msg.sender,
1857             amount,
1858             this,
1859             extraData
1860         );
1861         require(success);
1862 
1863         return true;
1864     }
1865 
1866     ////////////////////////
1867     // Internal functions
1868     ////////////////////////
1869 
1870     //
1871     // Implements default MTokenAllowanceController
1872     //
1873 
1874     // no override in default implementation
1875     function mAllowanceOverride(
1876         address /*owner*/,
1877         address /*spender*/
1878     )
1879         internal
1880         constant
1881         returns (uint256)
1882     {
1883         return 0;
1884     }
1885 }
1886 
1887 /// @title Reads and writes snapshots
1888 /// @dev Manages reading and writing a series of values, where each value has assigned a snapshot id for access to historical data
1889 /// @dev may be added to any contract to provide snapshotting mechanism. should be mixed in with any of MSnapshotPolicy implementations to customize snapshot creation mechanics
1890 ///     observes MSnapshotPolicy
1891 /// based on MiniMe token
1892 contract Snapshot is MSnapshotPolicy {
1893 
1894     ////////////////////////
1895     // Types
1896     ////////////////////////
1897 
1898     /// @dev `Values` is the structure that attaches a snapshot id to a
1899     ///  given value, the snapshot id attached is the one that last changed the
1900     ///  value
1901     struct Values {
1902 
1903         // `snapshotId` is the snapshot id that the value was generated at
1904         uint256 snapshotId;
1905 
1906         // `value` at a specific snapshot id
1907         uint256 value;
1908     }
1909 
1910     ////////////////////////
1911     // Internal functions
1912     ////////////////////////
1913 
1914     function hasValue(
1915         Values[] storage values
1916     )
1917         internal
1918         constant
1919         returns (bool)
1920     {
1921         return values.length > 0;
1922     }
1923 
1924     /// @dev makes sure that 'snapshotId' between current snapshot id (mCurrentSnapshotId) and first snapshot id. this guarantees that getValueAt returns value from one of the snapshots.
1925     function hasValueAt(
1926         Values[] storage values,
1927         uint256 snapshotId
1928     )
1929         internal
1930         constant
1931         returns (bool)
1932     {
1933         require(snapshotId <= mCurrentSnapshotId());
1934         return values.length > 0 && values[0].snapshotId <= snapshotId;
1935     }
1936 
1937     /// gets last value in the series
1938     function getValue(
1939         Values[] storage values,
1940         uint256 defaultValue
1941     )
1942         internal
1943         constant
1944         returns (uint256)
1945     {
1946         if (values.length == 0) {
1947             return defaultValue;
1948         } else {
1949             uint256 last = values.length - 1;
1950             return values[last].value;
1951         }
1952     }
1953 
1954     /// @dev `getValueAt` retrieves value at a given snapshot id
1955     /// @param values The series of values being queried
1956     /// @param snapshotId Snapshot id to retrieve the value at
1957     /// @return Value in series being queried
1958     function getValueAt(
1959         Values[] storage values,
1960         uint256 snapshotId,
1961         uint256 defaultValue
1962     )
1963         internal
1964         constant
1965         returns (uint256)
1966     {
1967         require(snapshotId <= mCurrentSnapshotId());
1968 
1969         // Empty value
1970         if (values.length == 0) {
1971             return defaultValue;
1972         }
1973 
1974         // Shortcut for the out of bounds snapshots
1975         uint256 last = values.length - 1;
1976         uint256 lastSnapshot = values[last].snapshotId;
1977         if (snapshotId >= lastSnapshot) {
1978             return values[last].value;
1979         }
1980         uint256 firstSnapshot = values[0].snapshotId;
1981         if (snapshotId < firstSnapshot) {
1982             return defaultValue;
1983         }
1984         // Binary search of the value in the array
1985         uint256 min = 0;
1986         uint256 max = last;
1987         while (max > min) {
1988             uint256 mid = (max + min + 1) / 2;
1989             // must always return lower indice for approximate searches
1990             if (values[mid].snapshotId <= snapshotId) {
1991                 min = mid;
1992             } else {
1993                 max = mid - 1;
1994             }
1995         }
1996         return values[min].value;
1997     }
1998 
1999     /// @dev `setValue` used to update sequence at next snapshot
2000     /// @param values The sequence being updated
2001     /// @param value The new last value of sequence
2002     function setValue(
2003         Values[] storage values,
2004         uint256 value
2005     )
2006         internal
2007     {
2008         // TODO: simplify or break into smaller functions
2009 
2010         uint256 currentSnapshotId = mAdvanceSnapshotId();
2011         // Always create a new entry if there currently is no value
2012         bool empty = values.length == 0;
2013         if (empty) {
2014             // Create a new entry
2015             values.push(
2016                 Values({
2017                     snapshotId: currentSnapshotId,
2018                     value: value
2019                 })
2020             );
2021             return;
2022         }
2023 
2024         uint256 last = values.length - 1;
2025         bool hasNewSnapshot = values[last].snapshotId < currentSnapshotId;
2026         if (hasNewSnapshot) {
2027 
2028             // Do nothing if the value was not modified
2029             bool unmodified = values[last].value == value;
2030             if (unmodified) {
2031                 return;
2032             }
2033 
2034             // Create new entry
2035             values.push(
2036                 Values({
2037                     snapshotId: currentSnapshotId,
2038                     value: value
2039                 })
2040             );
2041         } else {
2042 
2043             // We are updating the currentSnapshotId
2044             bool previousUnmodified = last > 0 && values[last - 1].value == value;
2045             if (previousUnmodified) {
2046                 // Remove current snapshot if current value was set to previous value
2047                 delete values[last];
2048                 values.length--;
2049                 return;
2050             }
2051 
2052             // Overwrite next snapshot entry
2053             values[last].value = value;
2054         }
2055     }
2056 }
2057 
2058 /// @title access to snapshots of a token
2059 /// @notice allows to implement complex token holder rights like revenue disbursal or voting
2060 /// @notice snapshots are series of values with assigned ids. ids increase strictly. particular id mechanism is not assumed
2061 contract ITokenSnapshots {
2062 
2063     ////////////////////////
2064     // Public functions
2065     ////////////////////////
2066 
2067     /// @notice Total amount of tokens at a specific `snapshotId`.
2068     /// @param snapshotId of snapshot at which totalSupply is queried
2069     /// @return The total amount of tokens at `snapshotId`
2070     /// @dev reverts on snapshotIds greater than currentSnapshotId()
2071     /// @dev returns 0 for snapshotIds less than snapshotId of first value
2072     function totalSupplyAt(uint256 snapshotId)
2073         public
2074         constant
2075         returns(uint256);
2076 
2077     /// @dev Queries the balance of `owner` at a specific `snapshotId`
2078     /// @param owner The address from which the balance will be retrieved
2079     /// @param snapshotId of snapshot at which the balance is queried
2080     /// @return The balance at `snapshotId`
2081     function balanceOfAt(address owner, uint256 snapshotId)
2082         public
2083         constant
2084         returns (uint256);
2085 
2086     /// @notice upper bound of series of snapshotIds for which there's a value in series
2087     /// @return snapshotId
2088     function currentSnapshotId()
2089         public
2090         constant
2091         returns (uint256);
2092 }
2093 
2094 /// @title represents link between cloned and parent token
2095 /// @dev when token is clone from other token, initial balances of the cloned token
2096 ///     correspond to balances of parent token at the moment of parent snapshot id specified
2097 /// @notice please note that other tokens beside snapshot token may be cloned
2098 contract IClonedTokenParent is ITokenSnapshots {
2099 
2100     ////////////////////////
2101     // Public functions
2102     ////////////////////////
2103 
2104 
2105     /// @return address of parent token, address(0) if root
2106     /// @dev parent token does not need to clonable, nor snapshottable, just a normal token
2107     function parentToken()
2108         public
2109         constant
2110         returns(IClonedTokenParent parent);
2111 
2112     /// @return snapshot at wchich initial token distribution was taken
2113     function parentSnapshotId()
2114         public
2115         constant
2116         returns(uint256 snapshotId);
2117 }
2118 
2119 /// @title token with snapshots and transfer functionality
2120 /// @dev observes MTokenTransferController interface
2121 ///     observes ISnapshotToken interface
2122 ///     implementes MTokenTransfer interface
2123 contract BasicSnapshotToken is
2124     MTokenTransfer,
2125     MTokenTransferController,
2126     IClonedTokenParent,
2127     IBasicToken,
2128     Snapshot
2129 {
2130     ////////////////////////
2131     // Immutable state
2132     ////////////////////////
2133 
2134     // `PARENT_TOKEN` is the Token address that was cloned to produce this token;
2135     //  it will be 0x0 for a token that was not cloned
2136     IClonedTokenParent private PARENT_TOKEN;
2137 
2138     // `PARENT_SNAPSHOT_ID` is the snapshot id from the Parent Token that was
2139     //  used to determine the initial distribution of the cloned token
2140     uint256 private PARENT_SNAPSHOT_ID;
2141 
2142     ////////////////////////
2143     // Mutable state
2144     ////////////////////////
2145 
2146     // `balances` is the map that tracks the balance of each address, in this
2147     //  contract when the balance changes the snapshot id that the change
2148     //  occurred is also included in the map
2149     mapping (address => Values[]) internal _balances;
2150 
2151     // Tracks the history of the `totalSupply` of the token
2152     Values[] internal _totalSupplyValues;
2153 
2154     ////////////////////////
2155     // Constructor
2156     ////////////////////////
2157 
2158     /// @notice Constructor to create snapshot token
2159     /// @param parentToken Address of the parent token, set to 0x0 if it is a
2160     ///  new token
2161     /// @param parentSnapshotId at which snapshot id clone was created, set to 0 to clone at upper bound
2162     /// @dev please not that as long as cloned token does not overwrite value at current snapshot id, it will refer
2163     ///     to parent token at which this snapshot still may change until snapshot id increases. for that time tokens are coupled
2164     ///     this is prevented by parentSnapshotId value of parentToken.currentSnapshotId() - 1 being the maxiumum
2165     ///     see SnapshotToken.js test to learn consequences coupling has.
2166     constructor(
2167         IClonedTokenParent parentToken,
2168         uint256 parentSnapshotId
2169     )
2170         Snapshot()
2171         internal
2172     {
2173         PARENT_TOKEN = parentToken;
2174         if (parentToken == address(0)) {
2175             require(parentSnapshotId == 0);
2176         } else {
2177             if (parentSnapshotId == 0) {
2178                 require(parentToken.currentSnapshotId() > 0);
2179                 PARENT_SNAPSHOT_ID = parentToken.currentSnapshotId() - 1;
2180             } else {
2181                 PARENT_SNAPSHOT_ID = parentSnapshotId;
2182             }
2183         }
2184     }
2185 
2186     ////////////////////////
2187     // Public functions
2188     ////////////////////////
2189 
2190     //
2191     // Implements IBasicToken
2192     //
2193 
2194     /// @dev This function makes it easy to get the total number of tokens
2195     /// @return The total number of tokens
2196     function totalSupply()
2197         public
2198         constant
2199         returns (uint256)
2200     {
2201         return totalSupplyAtInternal(mCurrentSnapshotId());
2202     }
2203 
2204     /// @param owner The address that's balance is being requested
2205     /// @return The balance of `owner` at the current block
2206     function balanceOf(address owner)
2207         public
2208         constant
2209         returns (uint256 balance)
2210     {
2211         return balanceOfAtInternal(owner, mCurrentSnapshotId());
2212     }
2213 
2214     /// @notice Send `amount` tokens to `to` from `msg.sender`
2215     /// @param to The address of the recipient
2216     /// @param amount The amount of tokens to be transferred
2217     /// @return True if the transfer was successful, reverts in any other case
2218     function transfer(address to, uint256 amount)
2219         public
2220         returns (bool success)
2221     {
2222         mTransfer(msg.sender, to, amount);
2223         return true;
2224     }
2225 
2226     //
2227     // Implements ITokenSnapshots
2228     //
2229 
2230     function totalSupplyAt(uint256 snapshotId)
2231         public
2232         constant
2233         returns(uint256)
2234     {
2235         return totalSupplyAtInternal(snapshotId);
2236     }
2237 
2238     function balanceOfAt(address owner, uint256 snapshotId)
2239         public
2240         constant
2241         returns (uint256)
2242     {
2243         return balanceOfAtInternal(owner, snapshotId);
2244     }
2245 
2246     function currentSnapshotId()
2247         public
2248         constant
2249         returns (uint256)
2250     {
2251         return mCurrentSnapshotId();
2252     }
2253 
2254     //
2255     // Implements IClonedTokenParent
2256     //
2257 
2258     function parentToken()
2259         public
2260         constant
2261         returns(IClonedTokenParent parent)
2262     {
2263         return PARENT_TOKEN;
2264     }
2265 
2266     /// @return snapshot at wchich initial token distribution was taken
2267     function parentSnapshotId()
2268         public
2269         constant
2270         returns(uint256 snapshotId)
2271     {
2272         return PARENT_SNAPSHOT_ID;
2273     }
2274 
2275     //
2276     // Other public functions
2277     //
2278 
2279     /// @notice gets all token balances of 'owner'
2280     /// @dev intended to be called via eth_call where gas limit is not an issue
2281     function allBalancesOf(address owner)
2282         external
2283         constant
2284         returns (uint256[2][])
2285     {
2286         /* very nice and working implementation below,
2287         // copy to memory
2288         Values[] memory values = _balances[owner];
2289         do assembly {
2290             // in memory structs have simple layout where every item occupies uint256
2291             balances := values
2292         } while (false);*/
2293 
2294         Values[] storage values = _balances[owner];
2295         uint256[2][] memory balances = new uint256[2][](values.length);
2296         for(uint256 ii = 0; ii < values.length; ++ii) {
2297             balances[ii] = [values[ii].snapshotId, values[ii].value];
2298         }
2299 
2300         return balances;
2301     }
2302 
2303     ////////////////////////
2304     // Internal functions
2305     ////////////////////////
2306 
2307     function totalSupplyAtInternal(uint256 snapshotId)
2308         internal
2309         constant
2310         returns(uint256)
2311     {
2312         Values[] storage values = _totalSupplyValues;
2313 
2314         // If there is a value, return it, reverts if value is in the future
2315         if (hasValueAt(values, snapshotId)) {
2316             return getValueAt(values, snapshotId, 0);
2317         }
2318 
2319         // Try parent contract at or before the fork
2320         if (address(PARENT_TOKEN) != 0) {
2321             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
2322             return PARENT_TOKEN.totalSupplyAt(earlierSnapshotId);
2323         }
2324 
2325         // Default to an empty balance
2326         return 0;
2327     }
2328 
2329     // get balance at snapshot if with continuation in parent token
2330     function balanceOfAtInternal(address owner, uint256 snapshotId)
2331         internal
2332         constant
2333         returns (uint256)
2334     {
2335         Values[] storage values = _balances[owner];
2336 
2337         // If there is a value, return it, reverts if value is in the future
2338         if (hasValueAt(values, snapshotId)) {
2339             return getValueAt(values, snapshotId, 0);
2340         }
2341 
2342         // Try parent contract at or before the fork
2343         if (PARENT_TOKEN != address(0)) {
2344             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
2345             return PARENT_TOKEN.balanceOfAt(owner, earlierSnapshotId);
2346         }
2347 
2348         // Default to an empty balance
2349         return 0;
2350     }
2351 
2352     //
2353     // Implements MTokenTransfer
2354     //
2355 
2356     /// @dev This is the actual transfer function in the token contract, it can
2357     ///  only be called by other functions in this contract.
2358     /// @param from The address holding the tokens being transferred
2359     /// @param to The address of the recipient
2360     /// @param amount The amount of tokens to be transferred
2361     /// @return True if the transfer was successful, reverts in any other case
2362     function mTransfer(
2363         address from,
2364         address to,
2365         uint256 amount
2366     )
2367         internal
2368     {
2369         // never send to address 0
2370         require(to != address(0));
2371         // block transfers in clone that points to future/current snapshots of parent token
2372         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2373         // Alerts the token controller of the transfer
2374         require(mOnTransfer(from, to, amount));
2375 
2376         // If the amount being transfered is more than the balance of the
2377         //  account the transfer reverts
2378         uint256 previousBalanceFrom = balanceOf(from);
2379         require(previousBalanceFrom >= amount);
2380 
2381         // First update the balance array with the new value for the address
2382         //  sending the tokens
2383         uint256 newBalanceFrom = previousBalanceFrom - amount;
2384         setValue(_balances[from], newBalanceFrom);
2385 
2386         // Then update the balance array with the new value for the address
2387         //  receiving the tokens
2388         uint256 previousBalanceTo = balanceOf(to);
2389         uint256 newBalanceTo = previousBalanceTo + amount;
2390         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
2391         setValue(_balances[to], newBalanceTo);
2392 
2393         // An event to make the transfer easy to find on the blockchain
2394         emit Transfer(from, to, amount);
2395     }
2396 }
2397 
2398 /// @title token generation and destruction
2399 /// @dev internal interface providing token generation and destruction, see MintableSnapshotToken for implementation
2400 contract MTokenMint {
2401 
2402     ////////////////////////
2403     // Internal functions
2404     ////////////////////////
2405 
2406     /// @notice Generates `amount` tokens that are assigned to `owner`
2407     /// @param owner The address that will be assigned the new tokens
2408     /// @param amount The quantity of tokens generated
2409     /// @dev reverts if tokens could not be generated
2410     function mGenerateTokens(address owner, uint256 amount)
2411         internal;
2412 
2413     /// @notice Burns `amount` tokens from `owner`
2414     /// @param owner The address that will lose the tokens
2415     /// @param amount The quantity of tokens to burn
2416     /// @dev reverts if tokens could not be destroyed
2417     function mDestroyTokens(address owner, uint256 amount)
2418         internal;
2419 }
2420 
2421 /// @title basic snapshot token with facitilites to generate and destroy tokens
2422 /// @dev implementes MTokenMint, does not expose any public functions that create/destroy tokens
2423 contract MintableSnapshotToken is
2424     BasicSnapshotToken,
2425     MTokenMint
2426 {
2427 
2428     ////////////////////////
2429     // Constructor
2430     ////////////////////////
2431 
2432     /// @notice Constructor to create a MintableSnapshotToken
2433     /// @param parentToken Address of the parent token, set to 0x0 if it is a
2434     ///  new token
2435     constructor(
2436         IClonedTokenParent parentToken,
2437         uint256 parentSnapshotId
2438     )
2439         BasicSnapshotToken(parentToken, parentSnapshotId)
2440         internal
2441     {}
2442 
2443     /// @notice Generates `amount` tokens that are assigned to `owner`
2444     /// @param owner The address that will be assigned the new tokens
2445     /// @param amount The quantity of tokens generated
2446     function mGenerateTokens(address owner, uint256 amount)
2447         internal
2448     {
2449         // never create for address 0
2450         require(owner != address(0));
2451         // block changes in clone that points to future/current snapshots of patent token
2452         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2453 
2454         uint256 curTotalSupply = totalSupply();
2455         uint256 newTotalSupply = curTotalSupply + amount;
2456         require(newTotalSupply >= curTotalSupply); // Check for overflow
2457 
2458         uint256 previousBalanceTo = balanceOf(owner);
2459         uint256 newBalanceTo = previousBalanceTo + amount;
2460         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
2461 
2462         setValue(_totalSupplyValues, newTotalSupply);
2463         setValue(_balances[owner], newBalanceTo);
2464 
2465         emit Transfer(0, owner, amount);
2466     }
2467 
2468     /// @notice Burns `amount` tokens from `owner`
2469     /// @param owner The address that will lose the tokens
2470     /// @param amount The quantity of tokens to burn
2471     function mDestroyTokens(address owner, uint256 amount)
2472         internal
2473     {
2474         // block changes in clone that points to future/current snapshots of patent token
2475         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2476 
2477         uint256 curTotalSupply = totalSupply();
2478         require(curTotalSupply >= amount);
2479 
2480         uint256 previousBalanceFrom = balanceOf(owner);
2481         require(previousBalanceFrom >= amount);
2482 
2483         uint256 newTotalSupply = curTotalSupply - amount;
2484         uint256 newBalanceFrom = previousBalanceFrom - amount;
2485         setValue(_totalSupplyValues, newTotalSupply);
2486         setValue(_balances[owner], newBalanceFrom);
2487 
2488         emit Transfer(owner, 0, amount);
2489     }
2490 }
2491 
2492 /*
2493     Copyright 2016, Jordi Baylina
2494     Copyright 2017, Remco Bloemen, Marcin Rudolf
2495 
2496     This program is free software: you can redistribute it and/or modify
2497     it under the terms of the GNU General Public License as published by
2498     the Free Software Foundation, either version 3 of the License, or
2499     (at your option) any later version.
2500 
2501     This program is distributed in the hope that it will be useful,
2502     but WITHOUT ANY WARRANTY; without even the implied warranty of
2503     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2504     GNU General Public License for more details.
2505 
2506     You should have received a copy of the GNU General Public License
2507     along with this program.  If not, see <http://www.gnu.org/licenses/>.
2508  */
2509 /// @title StandardSnapshotToken Contract
2510 /// @author Jordi Baylina, Remco Bloemen, Marcin Rudolf
2511 /// @dev This token contract's goal is to make it easy for anyone to clone this
2512 ///  token using the token distribution at a given block, this will allow DAO's
2513 ///  and DApps to upgrade their features in a decentralized manner without
2514 ///  affecting the original token
2515 /// @dev It is ERC20 compliant, but still needs to under go further testing.
2516 /// @dev Various contracts are composed to provide required functionality of this token, different compositions are possible
2517 ///     MintableSnapshotToken provides transfer, miniting and snapshotting functions
2518 ///     TokenAllowance provides approve/transferFrom functions
2519 ///     TokenMetadata adds name, symbol and other token metadata
2520 /// @dev This token is still abstract, Snapshot, BasicSnapshotToken and TokenAllowance observe interfaces that must be implemented
2521 ///     MSnapshotPolicy - particular snapshot id creation mechanism
2522 ///     MTokenController - controlls approvals and transfers
2523 ///     see Neumark as an example
2524 /// @dev implements ERC223 token transfer
2525 contract StandardSnapshotToken is
2526     MintableSnapshotToken,
2527     TokenAllowance
2528 {
2529     ////////////////////////
2530     // Constructor
2531     ////////////////////////
2532 
2533     /// @notice Constructor to create a MiniMeToken
2534     ///  is a new token
2535     /// param tokenName Name of the new token
2536     /// param decimalUnits Number of decimals of the new token
2537     /// param tokenSymbol Token Symbol for the new token
2538     constructor(
2539         IClonedTokenParent parentToken,
2540         uint256 parentSnapshotId
2541     )
2542         MintableSnapshotToken(parentToken, parentSnapshotId)
2543         TokenAllowance()
2544         internal
2545     {}
2546 }
2547 
2548 /// @title old ERC223 callback function
2549 /// @dev as used in Neumark and ICBMEtherToken
2550 contract IERC223LegacyCallback {
2551 
2552     ////////////////////////
2553     // Public functions
2554     ////////////////////////
2555 
2556     function onTokenTransfer(address from, uint256 amount, bytes data)
2557         public;
2558 
2559 }
2560 
2561 contract IERC223Token is IERC20Token, ITokenMetadata {
2562 
2563     /// @dev Departure: We do not log data, it has no advantage over a standard
2564     ///     log event. By sticking to the standard log event we
2565     ///     stay compatible with constracts that expect and ERC20 token.
2566 
2567     // event Transfer(
2568     //    address indexed from,
2569     //    address indexed to,
2570     //    uint256 amount,
2571     //    bytes data);
2572 
2573 
2574     /// @dev Departure: We do not use the callback on regular transfer calls to
2575     ///     stay compatible with constracts that expect and ERC20 token.
2576 
2577     // function transfer(address to, uint256 amount)
2578     //     public
2579     //     returns (bool);
2580 
2581     ////////////////////////
2582     // Public functions
2583     ////////////////////////
2584 
2585     function transfer(address to, uint256 amount, bytes data)
2586         public
2587         returns (bool);
2588 }
2589 
2590 contract Neumark is
2591     AccessControlled,
2592     AccessRoles,
2593     Agreement,
2594     DailyAndSnapshotable,
2595     StandardSnapshotToken,
2596     TokenMetadata,
2597     IERC223Token,
2598     NeumarkIssuanceCurve,
2599     Reclaimable,
2600     IsContract
2601 {
2602 
2603     ////////////////////////
2604     // Constants
2605     ////////////////////////
2606 
2607     string private constant TOKEN_NAME = "Neumark";
2608 
2609     uint8  private constant TOKEN_DECIMALS = 18;
2610 
2611     string private constant TOKEN_SYMBOL = "NEU";
2612 
2613     string private constant VERSION = "NMK_1.0";
2614 
2615     ////////////////////////
2616     // Mutable state
2617     ////////////////////////
2618 
2619     // disable transfers when Neumark is created
2620     bool private _transferEnabled = false;
2621 
2622     // at which point on curve new Neumarks will be created, see NeumarkIssuanceCurve contract
2623     // do not use to get total invested funds. see burn(). this is just a cache for expensive inverse function
2624     uint256 private _totalEurUlps;
2625 
2626     ////////////////////////
2627     // Events
2628     ////////////////////////
2629 
2630     event LogNeumarksIssued(
2631         address indexed owner,
2632         uint256 euroUlps,
2633         uint256 neumarkUlps
2634     );
2635 
2636     event LogNeumarksBurned(
2637         address indexed owner,
2638         uint256 euroUlps,
2639         uint256 neumarkUlps
2640     );
2641 
2642     ////////////////////////
2643     // Constructor
2644     ////////////////////////
2645 
2646     constructor(
2647         IAccessPolicy accessPolicy,
2648         IEthereumForkArbiter forkArbiter
2649     )
2650         AccessRoles()
2651         Agreement(accessPolicy, forkArbiter)
2652         StandardSnapshotToken(
2653             IClonedTokenParent(0x0),
2654             0
2655         )
2656         TokenMetadata(
2657             TOKEN_NAME,
2658             TOKEN_DECIMALS,
2659             TOKEN_SYMBOL,
2660             VERSION
2661         )
2662         DailyAndSnapshotable(0)
2663         NeumarkIssuanceCurve()
2664         Reclaimable()
2665         public
2666     {}
2667 
2668     ////////////////////////
2669     // Public functions
2670     ////////////////////////
2671 
2672     /// @notice issues new Neumarks to msg.sender with reward at current curve position
2673     ///     moves curve position by euroUlps
2674     ///     callable only by ROLE_NEUMARK_ISSUER
2675     function issueForEuro(uint256 euroUlps)
2676         public
2677         only(ROLE_NEUMARK_ISSUER)
2678         acceptAgreement(msg.sender)
2679         returns (uint256)
2680     {
2681         require(_totalEurUlps + euroUlps >= _totalEurUlps);
2682         uint256 neumarkUlps = incremental(_totalEurUlps, euroUlps);
2683         _totalEurUlps += euroUlps;
2684         mGenerateTokens(msg.sender, neumarkUlps);
2685         emit LogNeumarksIssued(msg.sender, euroUlps, neumarkUlps);
2686         return neumarkUlps;
2687     }
2688 
2689     /// @notice used by ROLE_NEUMARK_ISSUER to transer newly issued neumarks
2690     ///     typically to the investor and platform operator
2691     function distribute(address to, uint256 neumarkUlps)
2692         public
2693         only(ROLE_NEUMARK_ISSUER)
2694         acceptAgreement(to)
2695     {
2696         mTransfer(msg.sender, to, neumarkUlps);
2697     }
2698 
2699     /// @notice msg.sender can burn their Neumarks, curve is rolled back using inverse
2700     ///     curve. as a result cost of Neumark gets lower (reward is higher)
2701     function burn(uint256 neumarkUlps)
2702         public
2703         only(ROLE_NEUMARK_BURNER)
2704     {
2705         burnPrivate(neumarkUlps, 0, _totalEurUlps);
2706     }
2707 
2708     /// @notice executes as function above but allows to provide search range for low gas burning
2709     function burn(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2710         public
2711         only(ROLE_NEUMARK_BURNER)
2712     {
2713         burnPrivate(neumarkUlps, minEurUlps, maxEurUlps);
2714     }
2715 
2716     function enableTransfer(bool enabled)
2717         public
2718         only(ROLE_TRANSFER_ADMIN)
2719     {
2720         _transferEnabled = enabled;
2721     }
2722 
2723     function createSnapshot()
2724         public
2725         only(ROLE_SNAPSHOT_CREATOR)
2726         returns (uint256)
2727     {
2728         return DailyAndSnapshotable.createSnapshot();
2729     }
2730 
2731     function transferEnabled()
2732         public
2733         constant
2734         returns (bool)
2735     {
2736         return _transferEnabled;
2737     }
2738 
2739     function totalEuroUlps()
2740         public
2741         constant
2742         returns (uint256)
2743     {
2744         return _totalEurUlps;
2745     }
2746 
2747     function incremental(uint256 euroUlps)
2748         public
2749         constant
2750         returns (uint256 neumarkUlps)
2751     {
2752         return incremental(_totalEurUlps, euroUlps);
2753     }
2754 
2755     //
2756     // Implements IERC223Token with IERC223Callback (onTokenTransfer) callback
2757     //
2758 
2759     // old implementation of ERC223 that was actual when ICBM was deployed
2760     // as Neumark is already deployed this function keeps old behavior for testing
2761     function transfer(address to, uint256 amount, bytes data)
2762         public
2763         returns (bool)
2764     {
2765         // it is necessary to point out implementation to be called
2766         BasicSnapshotToken.mTransfer(msg.sender, to, amount);
2767 
2768         // Notify the receiving contract.
2769         if (isContract(to)) {
2770             IERC223LegacyCallback(to).onTokenTransfer(msg.sender, amount, data);
2771         }
2772         return true;
2773     }
2774 
2775     ////////////////////////
2776     // Internal functions
2777     ////////////////////////
2778 
2779     //
2780     // Implements MTokenController
2781     //
2782 
2783     function mOnTransfer(
2784         address from,
2785         address, // to
2786         uint256 // amount
2787     )
2788         internal
2789         acceptAgreement(from)
2790         returns (bool allow)
2791     {
2792         // must have transfer enabled or msg.sender is Neumark issuer
2793         return _transferEnabled || accessPolicy().allowed(msg.sender, ROLE_NEUMARK_ISSUER, this, msg.sig);
2794     }
2795 
2796     function mOnApprove(
2797         address owner,
2798         address, // spender,
2799         uint256 // amount
2800     )
2801         internal
2802         acceptAgreement(owner)
2803         returns (bool allow)
2804     {
2805         return true;
2806     }
2807 
2808     ////////////////////////
2809     // Private functions
2810     ////////////////////////
2811 
2812     function burnPrivate(uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2813         private
2814     {
2815         uint256 prevEuroUlps = _totalEurUlps;
2816         // burn first in the token to make sure balance/totalSupply is not crossed
2817         mDestroyTokens(msg.sender, burnNeumarkUlps);
2818         _totalEurUlps = cumulativeInverse(totalSupply(), minEurUlps, maxEurUlps);
2819         // actually may overflow on non-monotonic inverse
2820         assert(prevEuroUlps >= _totalEurUlps);
2821         uint256 euroUlps = prevEuroUlps - _totalEurUlps;
2822         emit LogNeumarksBurned(msg.sender, euroUlps, burnNeumarkUlps);
2823     }
2824 }
2825 
2826 /// @title current ERC223 fallback function
2827 /// @dev to be used in all future token contract
2828 /// @dev NEU and ICBMEtherToken (obsolete) are the only contracts that still uses IERC223LegacyCallback
2829 contract IERC223Callback {
2830 
2831     ////////////////////////
2832     // Public functions
2833     ////////////////////////
2834 
2835     function tokenFallback(address from, uint256 amount, bytes data)
2836         public;
2837 
2838 }
2839 
2840 /// @title disburse payment token amount to snapshot token holders
2841 /// @dev payment token received via ERC223 Transfer
2842 contract IFeeDisbursal is IERC223Callback {
2843     // TODO: declare interface
2844 }
2845 
2846 /// @title disburse payment token amount to snapshot token holders
2847 /// @dev payment token received via ERC223 Transfer
2848 contract IPlatformPortfolio is IERC223Callback {
2849     // TODO: declare interface
2850 }
2851 
2852 contract ITokenExchangeRateOracle {
2853     /// @notice provides actual price of 'numeratorToken' in 'denominatorToken'
2854     ///     returns timestamp at which price was obtained in oracle
2855     function getExchangeRate(address numeratorToken, address denominatorToken)
2856         public
2857         constant
2858         returns (uint256 rateFraction, uint256 timestamp);
2859 
2860     /// @notice allows to retreive multiple exchange rates in once call
2861     function getExchangeRates(address[] numeratorTokens, address[] denominatorTokens)
2862         public
2863         constant
2864         returns (uint256[] rateFractions, uint256[] timestamps);
2865 }
2866 
2867 /// @title root of trust and singletons + known interface registry
2868 /// provides a root which holds all interfaces platform trust, this includes
2869 /// singletons - for which accessors are provided
2870 /// collections of known instances of interfaces
2871 /// @dev interfaces are identified by bytes4, see KnownInterfaces.sol
2872 contract Universe is
2873     Agreement,
2874     IContractId,
2875     KnownInterfaces
2876 {
2877     ////////////////////////
2878     // Events
2879     ////////////////////////
2880 
2881     /// raised on any change of singleton instance
2882     /// @dev for convenience we provide previous instance of singleton in replacedInstance
2883     event LogSetSingleton(
2884         bytes4 interfaceId,
2885         address instance,
2886         address replacedInstance
2887     );
2888 
2889     /// raised on add/remove interface instance in collection
2890     event LogSetCollectionInterface(
2891         bytes4 interfaceId,
2892         address instance,
2893         bool isSet
2894     );
2895 
2896     ////////////////////////
2897     // Mutable state
2898     ////////////////////////
2899 
2900     // mapping of known contracts to addresses of singletons
2901     mapping(bytes4 => address) private _singletons;
2902 
2903     // mapping of known interfaces to collections of contracts
2904     mapping(bytes4 =>
2905         mapping(address => bool)) private _collections; // solium-disable-line indentation
2906 
2907     // known instances
2908     mapping(address => bytes4[]) private _instances;
2909 
2910 
2911     ////////////////////////
2912     // Constructor
2913     ////////////////////////
2914 
2915     constructor(
2916         IAccessPolicy accessPolicy,
2917         IEthereumForkArbiter forkArbiter
2918     )
2919         Agreement(accessPolicy, forkArbiter)
2920         public
2921     {
2922         setSingletonPrivate(KNOWN_INTERFACE_ACCESS_POLICY, accessPolicy);
2923         setSingletonPrivate(KNOWN_INTERFACE_FORK_ARBITER, forkArbiter);
2924     }
2925 
2926     ////////////////////////
2927     // Public methods
2928     ////////////////////////
2929 
2930     /// get singleton instance for 'interfaceId'
2931     function getSingleton(bytes4 interfaceId)
2932         public
2933         constant
2934         returns (address)
2935     {
2936         return _singletons[interfaceId];
2937     }
2938 
2939     function getManySingletons(bytes4[] interfaceIds)
2940         public
2941         constant
2942         returns (address[])
2943     {
2944         address[] memory addresses = new address[](interfaceIds.length);
2945         uint256 idx;
2946         while(idx < interfaceIds.length) {
2947             addresses[idx] = _singletons[interfaceIds[idx]];
2948             idx += 1;
2949         }
2950         return addresses;
2951     }
2952 
2953     /// checks of 'instance' is instance of interface 'interfaceId'
2954     function isSingleton(bytes4 interfaceId, address instance)
2955         public
2956         constant
2957         returns (bool)
2958     {
2959         return _singletons[interfaceId] == instance;
2960     }
2961 
2962     /// checks if 'instance' is one of instances of 'interfaceId'
2963     function isInterfaceCollectionInstance(bytes4 interfaceId, address instance)
2964         public
2965         constant
2966         returns (bool)
2967     {
2968         return _collections[interfaceId][instance];
2969     }
2970 
2971     function isAnyOfInterfaceCollectionInstance(bytes4[] interfaceIds, address instance)
2972         public
2973         constant
2974         returns (bool)
2975     {
2976         uint256 idx;
2977         while(idx < interfaceIds.length) {
2978             if (_collections[interfaceIds[idx]][instance]) {
2979                 return true;
2980             }
2981             idx += 1;
2982         }
2983         return false;
2984     }
2985 
2986     /// gets all interfaces of given instance
2987     function getInterfacesOfInstance(address instance)
2988         public
2989         constant
2990         returns (bytes4[] interfaces)
2991     {
2992         return _instances[instance];
2993     }
2994 
2995     /// sets 'instance' of singleton with interface 'interfaceId'
2996     function setSingleton(bytes4 interfaceId, address instance)
2997         public
2998         only(ROLE_UNIVERSE_MANAGER)
2999     {
3000         setSingletonPrivate(interfaceId, instance);
3001     }
3002 
3003     /// convenience method for setting many singleton instances
3004     function setManySingletons(bytes4[] interfaceIds, address[] instances)
3005         public
3006         only(ROLE_UNIVERSE_MANAGER)
3007     {
3008         require(interfaceIds.length == instances.length);
3009         uint256 idx;
3010         while(idx < interfaceIds.length) {
3011             setSingletonPrivate(interfaceIds[idx], instances[idx]);
3012             idx += 1;
3013         }
3014     }
3015 
3016     /// set or unset 'instance' with 'interfaceId' in collection of instances
3017     function setCollectionInterface(bytes4 interfaceId, address instance, bool set)
3018         public
3019         only(ROLE_UNIVERSE_MANAGER)
3020     {
3021         setCollectionPrivate(interfaceId, instance, set);
3022     }
3023 
3024     /// set or unset 'instance' in many collections of instances
3025     function setInterfaceInManyCollections(bytes4[] interfaceIds, address instance, bool set)
3026         public
3027         only(ROLE_UNIVERSE_MANAGER)
3028     {
3029         uint256 idx;
3030         while(idx < interfaceIds.length) {
3031             setCollectionPrivate(interfaceIds[idx], instance, set);
3032             idx += 1;
3033         }
3034     }
3035 
3036     /// set or unset array of collection
3037     function setCollectionsInterfaces(bytes4[] interfaceIds, address[] instances, bool[] set_flags)
3038         public
3039         only(ROLE_UNIVERSE_MANAGER)
3040     {
3041         require(interfaceIds.length == instances.length);
3042         require(interfaceIds.length == set_flags.length);
3043         uint256 idx;
3044         while(idx < interfaceIds.length) {
3045             setCollectionPrivate(interfaceIds[idx], instances[idx], set_flags[idx]);
3046             idx += 1;
3047         }
3048     }
3049 
3050     //
3051     // Implements IContractId
3052     //
3053 
3054     function contractId() public pure returns (bytes32 id, uint256 version) {
3055         return (0x8b57bfe21a3ef4854e19d702063b6cea03fa514162f8ff43fde551f06372fefd, 0);
3056     }
3057 
3058     ////////////////////////
3059     // Getters
3060     ////////////////////////
3061 
3062     function accessPolicy() public constant returns (IAccessPolicy) {
3063         return IAccessPolicy(_singletons[KNOWN_INTERFACE_ACCESS_POLICY]);
3064     }
3065 
3066     function forkArbiter() public constant returns (IEthereumForkArbiter) {
3067         return IEthereumForkArbiter(_singletons[KNOWN_INTERFACE_FORK_ARBITER]);
3068     }
3069 
3070     function neumark() public constant returns (Neumark) {
3071         return Neumark(_singletons[KNOWN_INTERFACE_NEUMARK]);
3072     }
3073 
3074     function etherToken() public constant returns (IERC223Token) {
3075         return IERC223Token(_singletons[KNOWN_INTERFACE_ETHER_TOKEN]);
3076     }
3077 
3078     function euroToken() public constant returns (IERC223Token) {
3079         return IERC223Token(_singletons[KNOWN_INTERFACE_EURO_TOKEN]);
3080     }
3081 
3082     function etherLock() public constant returns (address) {
3083         return _singletons[KNOWN_INTERFACE_ETHER_LOCK];
3084     }
3085 
3086     function euroLock() public constant returns (address) {
3087         return _singletons[KNOWN_INTERFACE_EURO_LOCK];
3088     }
3089 
3090     function icbmEtherLock() public constant returns (address) {
3091         return _singletons[KNOWN_INTERFACE_ICBM_ETHER_LOCK];
3092     }
3093 
3094     function icbmEuroLock() public constant returns (address) {
3095         return _singletons[KNOWN_INTERFACE_ICBM_EURO_LOCK];
3096     }
3097 
3098     function identityRegistry() public constant returns (address) {
3099         return IIdentityRegistry(_singletons[KNOWN_INTERFACE_IDENTITY_REGISTRY]);
3100     }
3101 
3102     function tokenExchangeRateOracle() public constant returns (address) {
3103         return ITokenExchangeRateOracle(_singletons[KNOWN_INTERFACE_TOKEN_EXCHANGE_RATE_ORACLE]);
3104     }
3105 
3106     function feeDisbursal() public constant returns (address) {
3107         return IFeeDisbursal(_singletons[KNOWN_INTERFACE_FEE_DISBURSAL]);
3108     }
3109 
3110     function platformPortfolio() public constant returns (address) {
3111         return IPlatformPortfolio(_singletons[KNOWN_INTERFACE_PLATFORM_PORTFOLIO]);
3112     }
3113 
3114     function tokenExchange() public constant returns (address) {
3115         return _singletons[KNOWN_INTERFACE_TOKEN_EXCHANGE];
3116     }
3117 
3118     function gasExchange() public constant returns (address) {
3119         return _singletons[KNOWN_INTERFACE_GAS_EXCHANGE];
3120     }
3121 
3122     function platformTerms() public constant returns (address) {
3123         return _singletons[KNOWN_INTERFACE_PLATFORM_TERMS];
3124     }
3125 
3126     ////////////////////////
3127     // Private methods
3128     ////////////////////////
3129 
3130     function setSingletonPrivate(bytes4 interfaceId, address instance)
3131         private
3132     {
3133         require(interfaceId != KNOWN_INTERFACE_UNIVERSE, "NF_UNI_NO_UNIVERSE_SINGLETON");
3134         address replacedInstance = _singletons[interfaceId];
3135         // do nothing if not changing
3136         if (replacedInstance != instance) {
3137             dropInstance(replacedInstance, interfaceId);
3138             addInstance(instance, interfaceId);
3139             _singletons[interfaceId] = instance;
3140         }
3141 
3142         emit LogSetSingleton(interfaceId, instance, replacedInstance);
3143     }
3144 
3145     function setCollectionPrivate(bytes4 interfaceId, address instance, bool set)
3146         private
3147     {
3148         // do nothing if not changing
3149         if (_collections[interfaceId][instance] == set) {
3150             return;
3151         }
3152         _collections[interfaceId][instance] = set;
3153         if (set) {
3154             addInstance(instance, interfaceId);
3155         } else {
3156             dropInstance(instance, interfaceId);
3157         }
3158         emit LogSetCollectionInterface(interfaceId, instance, set);
3159     }
3160 
3161     function addInstance(address instance, bytes4 interfaceId)
3162         private
3163     {
3164         if (instance == address(0)) {
3165             // do not add null instance
3166             return;
3167         }
3168         bytes4[] storage current = _instances[instance];
3169         uint256 idx;
3170         while(idx < current.length) {
3171             // instancy has this interface already, do nothing
3172             if (current[idx] == interfaceId)
3173                 return;
3174             idx += 1;
3175         }
3176         // new interface
3177         current.push(interfaceId);
3178     }
3179 
3180     function dropInstance(address instance, bytes4 interfaceId)
3181         private
3182     {
3183         if (instance == address(0)) {
3184             // do not drop null instance
3185             return;
3186         }
3187         bytes4[] storage current = _instances[instance];
3188         uint256 idx;
3189         uint256 last = current.length - 1;
3190         while(idx <= last) {
3191             if (current[idx] == interfaceId) {
3192                 // delete element
3193                 if (idx < last) {
3194                     // if not last element move last element to idx being deleted
3195                     current[idx] = current[last];
3196                 }
3197                 // delete last element
3198                 current.length -= 1;
3199                 return;
3200             }
3201             idx += 1;
3202         }
3203     }
3204 }
3205 
3206 /// @title sets duration of states in ETO
3207 contract ETODurationTerms is IContractId {
3208 
3209     ////////////////////////
3210     // Immutable state
3211     ////////////////////////
3212 
3213     // duration of Whitelist state
3214     uint32 public WHITELIST_DURATION;
3215 
3216     // duration of Public state
3217     uint32 public PUBLIC_DURATION;
3218 
3219     // time for Nominee and Company to sign Investment Agreement offchain and present proof on-chain
3220     uint32 public SIGNING_DURATION;
3221 
3222     // time for Claim before fee payout from ETO to NEU holders
3223     uint32 public CLAIM_DURATION;
3224 
3225     ////////////////////////
3226     // Constructor
3227     ////////////////////////
3228 
3229     constructor(
3230         uint32 whitelistDuration,
3231         uint32 publicDuration,
3232         uint32 signingDuration,
3233         uint32 claimDuration
3234     )
3235         public
3236     {
3237         WHITELIST_DURATION = whitelistDuration;
3238         PUBLIC_DURATION = publicDuration;
3239         SIGNING_DURATION = signingDuration;
3240         CLAIM_DURATION = claimDuration;
3241     }
3242 
3243     //
3244     // Implements IContractId
3245     //
3246 
3247     function contractId() public pure returns (bytes32 id, uint256 version) {
3248         return (0x5fb50201b453799d95f8a80291b940f1c543537b95bff2e3c78c2e36070494c0, 0);
3249     }
3250 }
3251 
3252 /// @title sets terms for tokens in ETO
3253 contract ETOTokenTerms is IContractId {
3254 
3255     ////////////////////////
3256     // Immutable state
3257     ////////////////////////
3258 
3259     // minimum number of tokens being offered. will set min cap
3260     uint256 public MIN_NUMBER_OF_TOKENS;
3261     // maximum number of tokens being offered. will set max cap
3262     uint256 public MAX_NUMBER_OF_TOKENS;
3263     // base token price in EUR-T, without any discount scheme
3264     uint256 public TOKEN_PRICE_EUR_ULPS;
3265     // maximum number of tokens in whitelist phase
3266     uint256 public MAX_NUMBER_OF_TOKENS_IN_WHITELIST;
3267     // equity tokens per share
3268     uint256 public constant EQUITY_TOKENS_PER_SHARE = 10000;
3269     // equity tokens decimals (precision)
3270     uint8 public constant EQUITY_TOKENS_PRECISION = 0; // indivisible
3271 
3272 
3273     ////////////////////////
3274     // Constructor
3275     ////////////////////////
3276 
3277     constructor(
3278         uint256 minNumberOfTokens,
3279         uint256 maxNumberOfTokens,
3280         uint256 tokenPriceEurUlps,
3281         uint256 maxNumberOfTokensInWhitelist
3282     )
3283         public
3284     {
3285         require(maxNumberOfTokensInWhitelist <= maxNumberOfTokens);
3286         require(maxNumberOfTokens >= minNumberOfTokens);
3287         // min cap must be > single share
3288         require(minNumberOfTokens >= EQUITY_TOKENS_PER_SHARE, "NF_ETO_TERMS_ONE_SHARE");
3289 
3290         MIN_NUMBER_OF_TOKENS = minNumberOfTokens;
3291         MAX_NUMBER_OF_TOKENS = maxNumberOfTokens;
3292         TOKEN_PRICE_EUR_ULPS = tokenPriceEurUlps;
3293         MAX_NUMBER_OF_TOKENS_IN_WHITELIST = maxNumberOfTokensInWhitelist;
3294     }
3295 
3296     //
3297     // Implements IContractId
3298     //
3299 
3300     function contractId() public pure returns (bytes32 id, uint256 version) {
3301         return (0x591e791aab2b14c80194b729a2abcba3e8cce1918be4061be170e7223357ae5c, 0);
3302     }
3303 }
3304 
3305 /// @title base terms of Equity Token Offering
3306 /// encapsulates pricing, discounts and whitelisting mechanism
3307 /// @dev to be split is mixins
3308 contract ETOTerms is
3309     IdentityRecord,
3310     Math,
3311     IContractId
3312 {
3313 
3314     ////////////////////////
3315     // Types
3316     ////////////////////////
3317 
3318     // @notice whitelist entry with a discount
3319     struct WhitelistTicket {
3320         // this also overrides maximum ticket
3321         uint128 discountAmountEurUlps;
3322         // a percentage of full price to be paid (1 - discount)
3323         uint128 fullTokenPriceFrac;
3324     }
3325 
3326     ////////////////////////
3327     // Constants state
3328     ////////////////////////
3329 
3330     bytes32 private constant EMPTY_STRING_HASH = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
3331     uint256 public constant MIN_QUALIFIED_INVESTOR_TICKET_EUR_ULPS = 100000 * 10**18;
3332 
3333     ////////////////////////
3334     // Immutable state
3335     ////////////////////////
3336 
3337     // reference to duration terms
3338     ETODurationTerms public DURATION_TERMS;
3339     // reference to token terms
3340     ETOTokenTerms public TOKEN_TERMS;
3341     // total number of shares in the company (incl. Authorized Shares) at moment of sale
3342     uint256 public EXISTING_COMPANY_SHARES;
3343     // sets nominal value of a share
3344     uint256 public SHARE_NOMINAL_VALUE_EUR_ULPS;
3345     // maximum discount on token price that may be given to investor (as decimal fraction)
3346     // uint256 public MAXIMUM_TOKEN_PRICE_DISCOUNT_FRAC;
3347     // minimum ticket
3348     uint256 public MIN_TICKET_EUR_ULPS;
3349     // maximum ticket for sophisiticated investors
3350     uint256 public MAX_TICKET_EUR_ULPS;
3351     // maximum ticket for simple investors
3352     uint256 public MAX_TICKET_SIMPLE_EUR_ULPS;
3353     // should enable transfers on ETO success
3354     // transfers are always disabled during token offering
3355     // if set to False transfers on Equity Token will remain disabled after offering
3356     // once those terms are on-chain this flags fully controls token transferability
3357     bool public ENABLE_TRANSFERS_ON_SUCCESS;
3358     // tells if offering accepts retail investors. if so, registered prospectus is required
3359     // and ENABLE_TRANSFERS_ON_SUCCESS is forced to be false as per current platform policy
3360     bool public ALLOW_RETAIL_INVESTORS;
3361     // represents the discount % for whitelist participants
3362     uint256 public WHITELIST_DISCOUNT_FRAC;
3363     // represents the discount % for public participants, using values > 0 will result
3364     // in automatic downround shareholder resolution
3365     uint256 public PUBLIC_DISCOUNT_FRAC;
3366 
3367     // paperwork
3368     // prospectus / investment memorandum / crowdfunding pamphlet etc.
3369     string public INVESTOR_OFFERING_DOCUMENT_URL;
3370     // settings for shareholder rights
3371     ShareholderRights public SHAREHOLDER_RIGHTS;
3372 
3373     // equity token setup
3374     string public EQUITY_TOKEN_NAME;
3375     string public EQUITY_TOKEN_SYMBOL;
3376 
3377     // manages whitelist
3378     address public WHITELIST_MANAGER;
3379     // wallet registry of KYC procedure
3380     IIdentityRegistry public IDENTITY_REGISTRY;
3381     Universe public UNIVERSE;
3382 
3383     // variables from token terms for local use
3384     // minimum number of tokens being offered. will set min cap
3385     uint256 private MIN_NUMBER_OF_TOKENS;
3386     // maximum number of tokens being offered. will set max cap
3387     uint256 private MAX_NUMBER_OF_TOKENS;
3388     // base token price in EUR-T, without any discount scheme
3389     uint256 private TOKEN_PRICE_EUR_ULPS;
3390 
3391 
3392     ////////////////////////
3393     // Mutable state
3394     ////////////////////////
3395 
3396     // mapping of investors allowed in whitelist
3397     mapping (address => WhitelistTicket) private _whitelist;
3398 
3399     ////////////////////////
3400     // Modifiers
3401     ////////////////////////
3402 
3403     modifier onlyWhitelistManager() {
3404         require(msg.sender == WHITELIST_MANAGER);
3405         _;
3406     }
3407 
3408     ////////////////////////
3409     // Events
3410     ////////////////////////
3411 
3412     // raised on invesor added to whitelist
3413     event LogInvestorWhitelisted(
3414         address indexed investor,
3415         uint256 discountAmountEurUlps,
3416         uint256 fullTokenPriceFrac
3417     );
3418 
3419     ////////////////////////
3420     // Constructor
3421     ////////////////////////
3422 
3423     constructor(
3424         Universe universe,
3425         ETODurationTerms durationTerms,
3426         ETOTokenTerms tokenTerms,
3427         uint256 existingCompanyShares,
3428         uint256 minTicketEurUlps,
3429         uint256 maxTicketEurUlps,
3430         bool allowRetailInvestors,
3431         bool enableTransfersOnSuccess,
3432         string investorOfferingDocumentUrl,
3433         ShareholderRights shareholderRights,
3434         string equityTokenName,
3435         string equityTokenSymbol,
3436         uint256 shareNominalValueEurUlps,
3437         uint256 whitelistDiscountFrac,
3438         uint256 publicDiscountFrac
3439     )
3440         public
3441     {
3442         require(durationTerms != address(0));
3443         require(tokenTerms != address(0));
3444         require(existingCompanyShares > 0);
3445         require(keccak256(abi.encodePacked(investorOfferingDocumentUrl)) != EMPTY_STRING_HASH);
3446         require(keccak256(abi.encodePacked(equityTokenName)) != EMPTY_STRING_HASH);
3447         require(keccak256(abi.encodePacked(equityTokenSymbol)) != EMPTY_STRING_HASH);
3448         require(shareholderRights != address(0));
3449         // test interface
3450         // require(shareholderRights.HAS_GENERAL_INFORMATION_RIGHTS());
3451         require(shareNominalValueEurUlps > 0);
3452         require(whitelistDiscountFrac >= 0 && whitelistDiscountFrac <= 99*10**16);
3453         require(publicDiscountFrac >= 0 && publicDiscountFrac <= 99*10**16);
3454         require(minTicketEurUlps<=maxTicketEurUlps);
3455 
3456         // copy token terms variables
3457         MIN_NUMBER_OF_TOKENS = tokenTerms.MIN_NUMBER_OF_TOKENS();
3458         MAX_NUMBER_OF_TOKENS = tokenTerms.MAX_NUMBER_OF_TOKENS();
3459         TOKEN_PRICE_EUR_ULPS = tokenTerms.TOKEN_PRICE_EUR_ULPS();
3460 
3461         DURATION_TERMS = durationTerms;
3462         TOKEN_TERMS = tokenTerms;
3463         EXISTING_COMPANY_SHARES = existingCompanyShares;
3464         MIN_TICKET_EUR_ULPS = minTicketEurUlps;
3465         MAX_TICKET_EUR_ULPS = maxTicketEurUlps;
3466         ALLOW_RETAIL_INVESTORS = allowRetailInvestors;
3467         ENABLE_TRANSFERS_ON_SUCCESS = enableTransfersOnSuccess;
3468         INVESTOR_OFFERING_DOCUMENT_URL = investorOfferingDocumentUrl;
3469         SHAREHOLDER_RIGHTS = shareholderRights;
3470         EQUITY_TOKEN_NAME = equityTokenName;
3471         EQUITY_TOKEN_SYMBOL = equityTokenSymbol;
3472         SHARE_NOMINAL_VALUE_EUR_ULPS = shareNominalValueEurUlps;
3473         WHITELIST_DISCOUNT_FRAC = whitelistDiscountFrac;
3474         PUBLIC_DISCOUNT_FRAC = publicDiscountFrac;
3475         WHITELIST_MANAGER = msg.sender;
3476         IDENTITY_REGISTRY = IIdentityRegistry(universe.identityRegistry());
3477         UNIVERSE = universe;
3478     }
3479 
3480     ////////////////////////
3481     // Public methods
3482     ////////////////////////
3483 
3484     // calculates token amount for a given commitment at a position of the curve
3485     // we require that equity token precision is 0
3486     function calculateTokenAmount(uint256 /*totalEurUlps*/, uint256 committedEurUlps)
3487         public
3488         constant
3489         returns (uint256 tokenAmountInt)
3490     {
3491         // we may disregard totalEurUlps as curve is flat, round down when calculating tokens
3492         return committedEurUlps / calculatePriceFraction(10**18 - PUBLIC_DISCOUNT_FRAC);
3493     }
3494 
3495     // calculates amount of euro required to acquire amount of tokens at a position of the (inverse) curve
3496     // we require that equity token precision is 0
3497     function calculateEurUlpsAmount(uint256 /*totalTokensInt*/, uint256 tokenAmountInt)
3498         public
3499         constant
3500         returns (uint256 committedEurUlps)
3501     {
3502         // we may disregard totalTokensInt as curve is flat
3503         return mul(tokenAmountInt, calculatePriceFraction(10**18 - PUBLIC_DISCOUNT_FRAC));
3504     }
3505 
3506     // get mincap in EUR
3507     function ESTIMATED_MIN_CAP_EUR_ULPS() public constant returns(uint256) {
3508         return calculateEurUlpsAmount(0, MIN_NUMBER_OF_TOKENS);
3509     }
3510 
3511     // get max cap in EUR
3512     function ESTIMATED_MAX_CAP_EUR_ULPS() public constant returns(uint256) {
3513         return calculateEurUlpsAmount(0, MAX_NUMBER_OF_TOKENS);
3514     }
3515 
3516     function calculatePriceFraction(uint256 priceFrac) public constant returns(uint256) {
3517         if (priceFrac == 1) {
3518             return TOKEN_PRICE_EUR_ULPS;
3519         } else {
3520             return decimalFraction(priceFrac, TOKEN_PRICE_EUR_ULPS);
3521         }
3522     }
3523 
3524     function addWhitelisted(
3525         address[] investors,
3526         uint256[] discountAmountsEurUlps,
3527         uint256[] discountsFrac
3528     )
3529         external
3530         onlyWhitelistManager
3531     {
3532         require(investors.length == discountAmountsEurUlps.length);
3533         require(investors.length == discountsFrac.length);
3534 
3535         for (uint256 i = 0; i < investors.length; i += 1) {
3536             addWhitelistInvestorPrivate(investors[i], discountAmountsEurUlps[i], discountsFrac[i]);
3537         }
3538     }
3539 
3540     function whitelistTicket(address investor)
3541         public
3542         constant
3543         returns (bool isWhitelisted, uint256 discountAmountEurUlps, uint256 fullTokenPriceFrac)
3544     {
3545         WhitelistTicket storage wlTicket = _whitelist[investor];
3546         isWhitelisted = wlTicket.fullTokenPriceFrac > 0;
3547         discountAmountEurUlps = wlTicket.discountAmountEurUlps;
3548         fullTokenPriceFrac = wlTicket.fullTokenPriceFrac;
3549     }
3550 
3551     // calculate contribution of investor
3552     function calculateContribution(
3553         address investor,
3554         uint256 totalContributedEurUlps,
3555         uint256 existingInvestorContributionEurUlps,
3556         uint256 newInvestorContributionEurUlps,
3557         bool applyWhitelistDiscounts
3558     )
3559         public
3560         constant
3561         returns (
3562             bool isWhitelisted,
3563             bool isEligible,
3564             uint256 minTicketEurUlps,
3565             uint256 maxTicketEurUlps,
3566             uint256 equityTokenInt,
3567             uint256 fixedSlotEquityTokenInt
3568             )
3569     {
3570         (
3571             isWhitelisted,
3572             minTicketEurUlps,
3573             maxTicketEurUlps,
3574             equityTokenInt,
3575             fixedSlotEquityTokenInt
3576         ) = calculateContributionPrivate(
3577             investor,
3578             totalContributedEurUlps,
3579             existingInvestorContributionEurUlps,
3580             newInvestorContributionEurUlps,
3581             applyWhitelistDiscounts);
3582         // check if is eligible for investment
3583         IdentityClaims memory claims = deserializeClaims(IDENTITY_REGISTRY.getClaims(investor));
3584         isEligible = claims.isVerified && !claims.accountFrozen;
3585     }
3586 
3587     function equityTokensToShares(uint256 amount)
3588         public
3589         constant
3590         returns (uint256)
3591     {
3592         return divRound(amount, TOKEN_TERMS.EQUITY_TOKENS_PER_SHARE());
3593     }
3594 
3595     /// @notice checks terms against platform terms, reverts on invalid
3596     function requireValidTerms(PlatformTerms platformTerms)
3597         public
3598         constant
3599         returns (bool)
3600     {
3601         // apply constraints on retail fundraising
3602         if (ALLOW_RETAIL_INVESTORS) {
3603             // make sure transfers are disabled after offering for retail investors
3604             require(!ENABLE_TRANSFERS_ON_SUCCESS, "NF_MUST_DISABLE_TRANSFERS");
3605         } else {
3606             // only qualified investors allowed defined as tickets > 100000 EUR
3607             require(MIN_TICKET_EUR_ULPS >= MIN_QUALIFIED_INVESTOR_TICKET_EUR_ULPS, "NF_MIN_QUALIFIED_INVESTOR_TICKET");
3608         }
3609         // min ticket must be > token price
3610         require(MIN_TICKET_EUR_ULPS >= TOKEN_TERMS.TOKEN_PRICE_EUR_ULPS(), "NF_MIN_TICKET_LT_TOKEN_PRICE");
3611         // it must be possible to collect more funds than max number of tokens
3612         require(ESTIMATED_MAX_CAP_EUR_ULPS() >= MIN_TICKET_EUR_ULPS, "NF_MAX_FUNDS_LT_MIN_TICKET");
3613 
3614         require(MIN_TICKET_EUR_ULPS >= platformTerms.MIN_TICKET_EUR_ULPS(), "NF_ETO_TERMS_MIN_TICKET_EUR_ULPS");
3615         // duration checks
3616         require(DURATION_TERMS.WHITELIST_DURATION() >= platformTerms.MIN_WHITELIST_DURATION(), "NF_ETO_TERMS_WL_D_MIN");
3617         require(DURATION_TERMS.WHITELIST_DURATION() <= platformTerms.MAX_WHITELIST_DURATION(), "NF_ETO_TERMS_WL_D_MAX");
3618 
3619         require(DURATION_TERMS.PUBLIC_DURATION() >= platformTerms.MIN_PUBLIC_DURATION(), "NF_ETO_TERMS_PUB_D_MIN");
3620         require(DURATION_TERMS.PUBLIC_DURATION() <= platformTerms.MAX_PUBLIC_DURATION(), "NF_ETO_TERMS_PUB_D_MAX");
3621 
3622         uint256 totalDuration = DURATION_TERMS.WHITELIST_DURATION() + DURATION_TERMS.PUBLIC_DURATION();
3623         require(totalDuration >= platformTerms.MIN_OFFER_DURATION(), "NF_ETO_TERMS_TOT_O_MIN");
3624         require(totalDuration <= platformTerms.MAX_OFFER_DURATION(), "NF_ETO_TERMS_TOT_O_MAX");
3625 
3626         require(DURATION_TERMS.SIGNING_DURATION() >= platformTerms.MIN_SIGNING_DURATION(), "NF_ETO_TERMS_SIG_MIN");
3627         require(DURATION_TERMS.SIGNING_DURATION() <= platformTerms.MAX_SIGNING_DURATION(), "NF_ETO_TERMS_SIG_MAX");
3628 
3629         require(DURATION_TERMS.CLAIM_DURATION() >= platformTerms.MIN_CLAIM_DURATION(), "NF_ETO_TERMS_CLAIM_MIN");
3630         require(DURATION_TERMS.CLAIM_DURATION() <= platformTerms.MAX_CLAIM_DURATION(), "NF_ETO_TERMS_CLAIM_MAX");
3631 
3632         return true;
3633     }
3634 
3635     //
3636     // Implements IContractId
3637     //
3638 
3639     function contractId() public pure returns (bytes32 id, uint256 version) {
3640         return (0x3468b14073c33fa00ee7f8a289b14f4a10c78ab72726033b27003c31c47b3f6a, 0);
3641     }
3642 
3643     ////////////////////////
3644     // Private methods
3645     ////////////////////////
3646 
3647     function calculateContributionPrivate(
3648         address investor,
3649         uint256 totalContributedEurUlps,
3650         uint256 existingInvestorContributionEurUlps,
3651         uint256 newInvestorContributionEurUlps,
3652         bool applyWhitelistDiscounts
3653     )
3654         private
3655         constant
3656         returns (
3657             bool isWhitelisted,
3658             uint256 minTicketEurUlps,
3659             uint256 maxTicketEurUlps,
3660             uint256 equityTokenInt,
3661             uint256 fixedSlotEquityTokenInt
3662         )
3663     {
3664         uint256 discountedAmount;
3665         minTicketEurUlps = MIN_TICKET_EUR_ULPS;
3666         maxTicketEurUlps = MAX_TICKET_EUR_ULPS;
3667         WhitelistTicket storage wlTicket = _whitelist[investor];
3668         // check if has access to discount
3669         isWhitelisted = wlTicket.fullTokenPriceFrac > 0;
3670         // whitelist use discount is possible
3671         if (applyWhitelistDiscounts) {
3672             // can invest more than general max ticket
3673             maxTicketEurUlps = max(wlTicket.discountAmountEurUlps, maxTicketEurUlps);
3674             // can invest less than general min ticket
3675             if (wlTicket.discountAmountEurUlps > 0) {
3676                 minTicketEurUlps = min(wlTicket.discountAmountEurUlps, minTicketEurUlps);
3677             }
3678             if (existingInvestorContributionEurUlps < wlTicket.discountAmountEurUlps) {
3679                 discountedAmount = min(newInvestorContributionEurUlps, wlTicket.discountAmountEurUlps - existingInvestorContributionEurUlps);
3680                 // discount is fixed so use base token price
3681                 if (discountedAmount > 0) {
3682                     // always round down when calculating tokens
3683                     fixedSlotEquityTokenInt = discountedAmount / calculatePriceFraction(wlTicket.fullTokenPriceFrac);
3684                 }
3685             }
3686         }
3687         // if any amount above discount
3688         uint256 remainingAmount = newInvestorContributionEurUlps - discountedAmount;
3689         if (remainingAmount > 0) {
3690             if (applyWhitelistDiscounts && WHITELIST_DISCOUNT_FRAC > 0) {
3691                 // will not overflow, WHITELIST_DISCOUNT_FRAC < Q18 from constructor, also round down
3692                 equityTokenInt = remainingAmount / calculatePriceFraction(10**18 - WHITELIST_DISCOUNT_FRAC);
3693             } else {
3694                 // use pricing along the curve
3695                 equityTokenInt = calculateTokenAmount(totalContributedEurUlps + discountedAmount, remainingAmount);
3696             }
3697         }
3698         // should have all issued tokens
3699         equityTokenInt += fixedSlotEquityTokenInt;
3700 
3701     }
3702 
3703     function addWhitelistInvestorPrivate(
3704         address investor,
3705         uint256 discountAmountEurUlps,
3706         uint256 fullTokenPriceFrac
3707     )
3708         private
3709     {
3710         // Validate
3711         require(investor != address(0));
3712         require(fullTokenPriceFrac > 0 && fullTokenPriceFrac <= 10**18, "NF_DISCOUNT_RANGE");
3713         require(discountAmountEurUlps < 2**128);
3714 
3715 
3716         _whitelist[investor] = WhitelistTicket({
3717             discountAmountEurUlps: uint128(discountAmountEurUlps),
3718             fullTokenPriceFrac: uint128(fullTokenPriceFrac)
3719         });
3720 
3721         emit LogInvestorWhitelisted(investor, discountAmountEurUlps, fullTokenPriceFrac);
3722     }
3723 
3724 }
3725 
3726 /// @title hooks token controller to token contract and allows to replace it
3727 contract ITokenControllerHook {
3728 
3729     ////////////////////////
3730     // Events
3731     ////////////////////////
3732 
3733     event LogChangeTokenController(
3734         address oldController,
3735         address newController,
3736         address by
3737     );
3738 
3739     ////////////////////////
3740     // Public functions
3741     ////////////////////////
3742 
3743     /// @notice replace current token controller
3744     /// @dev please note that this process is also controlled by existing controller
3745     function changeTokenController(address newController)
3746         public;
3747 
3748     /// @notice returns current controller
3749     function tokenController()
3750         public
3751         constant
3752         returns (address currentController);
3753 
3754 }
3755 
3756 /// @title state space of ETOCommitment
3757 contract IETOCommitmentStates {
3758     ////////////////////////
3759     // Types
3760     ////////////////////////
3761 
3762     // order must reflect time precedence, do not change order below
3763     enum ETOState {
3764         Setup, // Initial state
3765         Whitelist,
3766         Public,
3767         Signing,
3768         Claim,
3769         Payout, // Terminal state
3770         Refund // Terminal state
3771     }
3772 
3773     // number of states in enum
3774     uint256 constant internal ETO_STATES_COUNT = 7;
3775 }
3776 
3777 /// @title provides callback on state transitions
3778 /// @dev observer called after the state() of commitment contract was set
3779 contract IETOCommitmentObserver is IETOCommitmentStates {
3780     function commitmentObserver() public constant returns (address);
3781     function onStateTransition(ETOState oldState, ETOState newState) public;
3782 }
3783 
3784 /// @title granular token controller based on MSnapshotToken observer pattern
3785 contract ITokenController {
3786 
3787     ////////////////////////
3788     // Public functions
3789     ////////////////////////
3790 
3791     /// @notice see MTokenTransferController
3792     /// @dev additionally passes broker that is executing transaction between from and to
3793     ///      for unbrokered transfer, broker == from
3794     function onTransfer(address broker, address from, address to, uint256 amount)
3795         public
3796         constant
3797         returns (bool allow);
3798 
3799     /// @notice see MTokenAllowanceController
3800     function onApprove(address owner, address spender, uint256 amount)
3801         public
3802         constant
3803         returns (bool allow);
3804 
3805     /// @notice see MTokenMint
3806     function onGenerateTokens(address sender, address owner, uint256 amount)
3807         public
3808         constant
3809         returns (bool allow);
3810 
3811     /// @notice see MTokenMint
3812     function onDestroyTokens(address sender, address owner, uint256 amount)
3813         public
3814         constant
3815         returns (bool allow);
3816 
3817     /// @notice controls if sender can change controller to newController
3818     /// @dev for this to succeed TYPICALLY current controller must be already migrated to a new one
3819     function onChangeTokenController(address sender, address newController)
3820         public
3821         constant
3822         returns (bool);
3823 
3824     /// @notice overrides spender allowance
3825     /// @dev may be used to implemented forced transfers in which token controller may override approved allowance
3826     ///      with any > 0 value and then use transferFrom to execute such transfer
3827     ///      This by definition creates non-trustless token so do not implement this call if you do not need trustless transfers!
3828     ///      Implementer should not allow approve() to be executed if there is an overrride
3829     //       Implemented should return allowance() taking into account override
3830     function onAllowance(address owner, address spender)
3831         public
3832         constant
3833         returns (uint256 allowanceOverride);
3834 }
3835 
3836 contract IEquityTokenController is
3837     IAgreement,
3838     ITokenController,
3839     IETOCommitmentObserver,
3840     IERC223Callback
3841 {
3842     /// controls if sender can change old nominee to new nominee
3843     /// @dev for this to succeed typically a voting of the token holders should happen and new nominee should be set
3844     function onChangeNominee(address sender, address oldNominee, address newNominee)
3845         public
3846         constant
3847         returns (bool);
3848 }
3849 
3850 contract IEquityToken is
3851     IAgreement,
3852     IClonedTokenParent,
3853     IERC223Token,
3854     ITokenControllerHook
3855 {
3856     /// @dev equity token is not divisible (Decimals == 0) but single share is represented by
3857     ///  tokensPerShare tokens
3858     function tokensPerShare() public constant returns (uint256);
3859 
3860     // number of shares represented by tokens. we round to the closest value.
3861     function sharesTotalSupply() public constant returns (uint256);
3862 
3863     /// nominal value of a share in EUR decimal(18) precision
3864     function shareNominalValueEurUlps() public constant returns (uint256);
3865 
3866     // returns company legal representative account that never changes
3867     function companyLegalRepresentative() public constant returns (address);
3868 
3869     /// returns current nominee which is contract legal rep
3870     function nominee() public constant returns (address);
3871 
3872     /// only by previous nominee
3873     function changeNominee(address newNominee) public;
3874 
3875     /// controlled, always issues to msg.sender
3876     function issueTokens(uint256 amount) public;
3877 
3878     /// controlled, may send tokens even when transfer are disabled: to active ETO only
3879     function distributeTokens(address to, uint256 amount) public;
3880 
3881     // controlled, msg.sender is typically failed ETO
3882     function destroyTokens(uint256 amount) public;
3883 }
3884 
3885 contract EquityToken is
3886     IEquityToken,
3887     IContractId,
3888     StandardSnapshotToken,
3889     Daily,
3890     TokenMetadata,
3891     Agreement,
3892     IsContract,
3893     Math
3894 {
3895     ////////////////////////
3896     // Immutable state
3897     ////////////////////////
3898 
3899     // reference to platform terms
3900     uint256 private TOKENS_PER_SHARE;
3901     // company representative address
3902     address private COMPANY_LEGAL_REPRESENTATIVE;
3903     // sets nominal value of a share
3904     uint256 public SHARE_NOMINAL_VALUE_EUR_ULPS;
3905 
3906     ////////////////////////
3907     // Mutable state
3908     ////////////////////////
3909 
3910     // nominee address
3911     address private _nominee;
3912     // company management contract
3913     IEquityTokenController private _tokenController;
3914 
3915     ////////////////////////
3916     // Events
3917     ////////////////////////
3918 
3919     event LogTokensIssued(
3920         address indexed holder,
3921         address controller,
3922         uint256 amount
3923     );
3924 
3925     event LogTokensDestroyed(
3926         address indexed holder,
3927         address controller,
3928         uint256 amount
3929     );
3930 
3931     event LogChangeTokenController(
3932         address oldController,
3933         address newController,
3934         address by
3935     );
3936 
3937     event LogChangeNominee(
3938         address oldNominee,
3939         address newNominee,
3940         address controller,
3941         address by
3942     );
3943 
3944     ////////////////////////
3945     // Modifiers
3946     ////////////////////////
3947 
3948     modifier onlyIfIssueAllowed(address to, uint256 amount) {
3949         require(_tokenController.onGenerateTokens(msg.sender, to, amount), "NF_EQTOKEN_NO_GENERATE");
3950         _;
3951     }
3952 
3953     modifier onlyIfDestroyAllowed(address owner, uint256 amount) {
3954         require(_tokenController.onDestroyTokens(msg.sender, owner, amount), "NF_EQTOKEN_NO_DESTROY");
3955         _;
3956     }
3957 
3958     ////////////////////////
3959     // Constructor
3960     ////////////////////////
3961 
3962     constructor(
3963         Universe universe,
3964         IEquityTokenController controller,
3965         ETOTerms etoTerms,
3966         address nominee,
3967         address companyLegalRep
3968     )
3969         Agreement(universe.accessPolicy(), universe.forkArbiter())
3970         StandardSnapshotToken(
3971             IClonedTokenParent(0x0),
3972             0
3973         )
3974         TokenMetadata(
3975             etoTerms.EQUITY_TOKEN_NAME(),
3976             etoTerms.TOKEN_TERMS().EQUITY_TOKENS_PRECISION(),
3977             etoTerms.EQUITY_TOKEN_SYMBOL(),
3978             "1.0"
3979         )
3980         Daily(0)
3981         public
3982     {
3983         TOKENS_PER_SHARE = etoTerms.TOKEN_TERMS().EQUITY_TOKENS_PER_SHARE();
3984         COMPANY_LEGAL_REPRESENTATIVE = companyLegalRep;
3985         SHARE_NOMINAL_VALUE_EUR_ULPS = etoTerms.SHARE_NOMINAL_VALUE_EUR_ULPS();
3986 
3987         _nominee = nominee;
3988         _tokenController = controller;
3989     }
3990 
3991     ////////////////////////
3992     // Public functions
3993     ////////////////////////
3994 
3995     //
3996     // Implements IEquityToken
3997     //
3998 
3999     /// @dev token controller performs access control
4000     function issueTokens(uint256 amount)
4001         public
4002         onlyIfIssueAllowed(address(this), amount)
4003         acceptAgreement(msg.sender)
4004     {
4005         mGenerateTokens(msg.sender, amount);
4006         emit LogTokensIssued(msg.sender, _tokenController, amount);
4007     }
4008 
4009     /// differs from transfer only by 'to' accepting agreement
4010     function distributeTokens(address to, uint256 amount)
4011         public
4012         acceptAgreement(to)
4013     {
4014         mTransfer(msg.sender, to, amount);
4015     }
4016 
4017     /// @dev token controller will allow if ETO in refund state
4018     function destroyTokens(uint256 amount)
4019         public
4020         onlyIfDestroyAllowed(msg.sender, amount)
4021         acceptAgreement(msg.sender)
4022     {
4023         mDestroyTokens(msg.sender, amount);
4024         emit LogTokensDestroyed(msg.sender, _tokenController, amount);
4025     }
4026 
4027     function changeNominee(address newNominee)
4028         public
4029     {
4030         // typically requires a valid migration in the old controller
4031         require(_tokenController.onChangeNominee(msg.sender, _nominee, newNominee));
4032         _nominee = newNominee;
4033         emit LogChangeNominee(_nominee, newNominee, _tokenController, msg.sender);
4034     }
4035 
4036     function tokensPerShare() public constant returns (uint256) {
4037         return TOKENS_PER_SHARE;
4038     }
4039 
4040     function sharesTotalSupply() public constant returns (uint256) {
4041         return tokensToShares(totalSupply());
4042     }
4043 
4044     function shareNominalValueEurUlps() public constant returns (uint256) {
4045         return SHARE_NOMINAL_VALUE_EUR_ULPS;
4046     }
4047 
4048     function nominee() public constant returns (address) {
4049         return _nominee;
4050     }
4051 
4052     function companyLegalRepresentative() public constant returns (address) {
4053         return COMPANY_LEGAL_REPRESENTATIVE;
4054     }
4055 
4056     //
4057     // Implements ITokenControllerHook
4058     //
4059 
4060     function changeTokenController(address newController)
4061         public
4062     {
4063         // typically requires a valid migration in the old controller
4064         require(_tokenController.onChangeTokenController(msg.sender, newController), "NF_ET_NO_PERM_NEW_CONTROLLER");
4065         _tokenController = IEquityTokenController(newController);
4066         emit LogChangeTokenController(_tokenController, newController, msg.sender);
4067     }
4068 
4069     function tokenController() public constant returns (address) {
4070         return _tokenController;
4071     }
4072 
4073     //
4074     // Implements IERC223Token with IERC223Callback (tokenFallback) callback
4075     //
4076 
4077     function transfer(address to, uint256 amount, bytes data)
4078         public
4079         returns (bool)
4080     {
4081         // it is necessary to point out implementation to be called
4082         BasicSnapshotToken.mTransfer(msg.sender, to, amount);
4083 
4084         // Notify the receiving contract.
4085         if (isContract(to)) {
4086             IERC223Callback(to).tokenFallback(msg.sender, amount, data);
4087         }
4088         return true;
4089     }
4090 
4091     //
4092     // Implements IContractId
4093     //
4094 
4095     function contractId() public pure returns (bytes32 id, uint256 version) {
4096         return (0x45a709aff6d5ae42cb70f87551d8d7dbec5235cf2baa71a009ed0a9795258d8f, 0);
4097     }
4098 
4099     ////////////////////////
4100     // Internal functions
4101     ////////////////////////
4102 
4103     //
4104     // Implements MTokenController
4105     //
4106 
4107     function mOnTransfer(
4108         address from,
4109         address to,
4110         uint256 amount
4111     )
4112         internal
4113         acceptAgreement(from)
4114         returns (bool allow)
4115     {
4116         // if token controller allows transfer
4117         return _tokenController.onTransfer(msg.sender, from, to, amount);
4118     }
4119 
4120     function mOnApprove(
4121         address owner,
4122         address spender,
4123         uint256 amount
4124     )
4125         internal
4126         acceptAgreement(owner)
4127         returns (bool allow)
4128     {
4129         return _tokenController.onApprove(owner, spender, amount);
4130     }
4131 
4132     function mAllowanceOverride(
4133         address owner,
4134         address spender
4135     )
4136         internal
4137         constant
4138         returns (uint256)
4139     {
4140         return _tokenController.onAllowance(owner, spender);
4141     }
4142 
4143     //
4144     // Overrides Agreement
4145     //
4146 
4147     function mCanAmend(address legalRepresentative)
4148         internal
4149         returns (bool)
4150     {
4151         return legalRepresentative == _nominee;
4152     }
4153 
4154     function tokensToShares(uint256 amount)
4155         internal
4156         constant
4157         returns (uint256)
4158     {
4159         return divRound(amount, TOKENS_PER_SHARE);
4160     }
4161 }