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
495 /// @title describes layout of claims in 256bit records stored for identities
496 /// @dev intended to be derived by contracts requiring access to particular claims
497 contract IdentityRecord {
498 
499     ////////////////////////
500     // Types
501     ////////////////////////
502 
503     /// @dev here the idea is to have claims of size of uint256 and use this struct
504     ///     to translate in and out of this struct. until we do not cross uint256 we
505     ///     have binary compatibility
506     struct IdentityClaims {
507         bool isVerified; // 1 bit
508         bool isSophisticatedInvestor; // 1 bit
509         bool hasBankAccount; // 1 bit
510         bool accountFrozen; // 1 bit
511         // uint252 reserved
512     }
513 
514     ////////////////////////
515     // Internal functions
516     ////////////////////////
517 
518     /// translates uint256 to struct
519     function deserializeClaims(bytes32 data) internal pure returns (IdentityClaims memory claims) {
520         // for memory layout of struct, each field below word length occupies whole word
521         assembly {
522             mstore(claims, and(data, 0x1))
523             mstore(add(claims, 0x20), div(and(data, 0x2), 0x2))
524             mstore(add(claims, 0x40), div(and(data, 0x4), 0x4))
525             mstore(add(claims, 0x60), div(and(data, 0x8), 0x8))
526         }
527     }
528 }
529 
530 
531 /// @title interface storing and retrieve 256bit claims records for identity
532 /// actual format of record is decoupled from storage (except maximum size)
533 contract IIdentityRegistry {
534 
535     ////////////////////////
536     // Events
537     ////////////////////////
538 
539     /// provides information on setting claims
540     event LogSetClaims(
541         address indexed identity,
542         bytes32 oldClaims,
543         bytes32 newClaims
544     );
545 
546     ////////////////////////
547     // Public functions
548     ////////////////////////
549 
550     /// get claims for identity
551     function getClaims(address identity) public constant returns (bytes32);
552 
553     /// set claims for identity
554     /// @dev odlClaims and newClaims used for optimistic locking. to override with newClaims
555     ///     current claims must be oldClaims
556     function setClaims(address identity, bytes32 oldClaims, bytes32 newClaims) public;
557 }
558 
559 /// @title known interfaces (services) of the platform
560 /// "known interface" is a unique id of service provided by the platform and discovered via Universe contract
561 ///  it does not refer to particular contract/interface ABI, particular service may be delivered via different implementations
562 ///  however for a few contracts we commit platform to particular implementation (all ICBM Contracts, Universe itself etc.)
563 /// @dev constants are kept in CODE not in STORAGE so they are comparatively cheap
564 contract KnownInterfaces {
565 
566     ////////////////////////
567     // Constants
568     ////////////////////////
569 
570     // NOTE: All interface are set to the keccak256 hash of the
571     // CamelCased interface or singleton name, i.e.
572     // KNOWN_INTERFACE_NEUMARK = keccak256("Neumark")
573 
574     // EIP 165 + EIP 820 should be use instead but it seems they are far from finished
575     // also interface signature should be build automatically by solidity. otherwise it is a pure hassle
576 
577     // neumark token interface and sigleton keccak256("Neumark")
578     bytes4 internal constant KNOWN_INTERFACE_NEUMARK = 0xeb41a1bd;
579 
580     // ether token interface and singleton keccak256("EtherToken")
581     bytes4 internal constant KNOWN_INTERFACE_ETHER_TOKEN = 0x8cf73cf1;
582 
583     // euro token interface and singleton keccak256("EuroToken")
584     bytes4 internal constant KNOWN_INTERFACE_EURO_TOKEN = 0x83c3790b;
585 
586     // identity registry interface and singleton keccak256("IIdentityRegistry")
587     bytes4 internal constant KNOWN_INTERFACE_IDENTITY_REGISTRY = 0x0a72e073;
588 
589     // currency rates oracle interface and singleton keccak256("ITokenExchangeRateOracle")
590     bytes4 internal constant KNOWN_INTERFACE_TOKEN_EXCHANGE_RATE_ORACLE = 0xc6e5349e;
591 
592     // fee disbursal interface and singleton keccak256("IFeeDisbursal")
593     bytes4 internal constant KNOWN_INTERFACE_FEE_DISBURSAL = 0xf4c848e8;
594 
595     // platform portfolio holding equity tokens belonging to NEU holders keccak256("IPlatformPortfolio");
596     bytes4 internal constant KNOWN_INTERFACE_PLATFORM_PORTFOLIO = 0xaa1590d0;
597 
598     // token exchange interface and singleton keccak256("ITokenExchange")
599     bytes4 internal constant KNOWN_INTERFACE_TOKEN_EXCHANGE = 0xddd7a521;
600 
601     // service exchanging euro token for gas ("IGasTokenExchange")
602     bytes4 internal constant KNOWN_INTERFACE_GAS_EXCHANGE = 0x89dbc6de;
603 
604     // access policy interface and singleton keccak256("IAccessPolicy")
605     bytes4 internal constant KNOWN_INTERFACE_ACCESS_POLICY = 0xb05049d9;
606 
607     // euro lock account (upgraded) keccak256("LockedAccount:Euro")
608     bytes4 internal constant KNOWN_INTERFACE_EURO_LOCK = 0x2347a19e;
609 
610     // ether lock account (upgraded) keccak256("LockedAccount:Ether")
611     bytes4 internal constant KNOWN_INTERFACE_ETHER_LOCK = 0x978a6823;
612 
613     // icbm euro lock account keccak256("ICBMLockedAccount:Euro")
614     bytes4 internal constant KNOWN_INTERFACE_ICBM_EURO_LOCK = 0x36021e14;
615 
616     // ether lock account (upgraded) keccak256("ICBMLockedAccount:Ether")
617     bytes4 internal constant KNOWN_INTERFACE_ICBM_ETHER_LOCK = 0x0b58f006;
618 
619     // ether token interface and singleton keccak256("ICBMEtherToken")
620     bytes4 internal constant KNOWN_INTERFACE_ICBM_ETHER_TOKEN = 0xae8b50b9;
621 
622     // euro token interface and singleton keccak256("ICBMEuroToken")
623     bytes4 internal constant KNOWN_INTERFACE_ICBM_EURO_TOKEN = 0xc2c6cd72;
624 
625     // ICBM commitment interface interface and singleton keccak256("ICBMCommitment")
626     bytes4 internal constant KNOWN_INTERFACE_ICBM_COMMITMENT = 0x7f2795ef;
627 
628     // ethereum fork arbiter interface and singleton keccak256("IEthereumForkArbiter")
629     bytes4 internal constant KNOWN_INTERFACE_FORK_ARBITER = 0x2fe7778c;
630 
631     // Platform terms interface and singletong keccak256("PlatformTerms")
632     bytes4 internal constant KNOWN_INTERFACE_PLATFORM_TERMS = 0x75ecd7f8;
633 
634     // for completness we define Universe service keccak256("Universe");
635     bytes4 internal constant KNOWN_INTERFACE_UNIVERSE = 0xbf202454;
636 
637     // ETO commitment interface (collection) keccak256("ICommitment")
638     bytes4 internal constant KNOWN_INTERFACE_COMMITMENT = 0xfa0e0c60;
639 
640     // Equity Token Controller interface (collection) keccak256("IEquityTokenController")
641     bytes4 internal constant KNOWN_INTERFACE_EQUITY_TOKEN_CONTROLLER = 0xfa30b2f1;
642 
643     // Equity Token interface (collection) keccak256("IEquityToken")
644     bytes4 internal constant KNOWN_INTERFACE_EQUITY_TOKEN = 0xab9885bb;
645 }
646 
647 /// @notice implemented in the contract that is the target of state migration
648 /// @dev implementation must provide actual function that will be called by source to migrate state
649 contract IMigrationTarget {
650 
651     ////////////////////////
652     // Public functions
653     ////////////////////////
654 
655     // should return migration source address
656     function currentMigrationSource()
657         public
658         constant
659         returns (address);
660 }
661 
662 /// @notice implemented in the contract that stores state to be migrated
663 /// @notice contract is called migration source
664 /// @dev migration target implements IMigrationTarget interface, when it is passed in 'enableMigration' function
665 /// @dev 'migrate' function may be called to migrate part of state owned by msg.sender
666 /// @dev in legal terms this corresponds to amending/changing agreement terms by co-signature of parties
667 contract IMigrationSource {
668 
669     ////////////////////////
670     // Events
671     ////////////////////////
672 
673     event LogMigrationEnabled(
674         address target
675     );
676 
677     ////////////////////////
678     // Public functions
679     ////////////////////////
680 
681     /// @notice should migrate state owned by msg.sender
682     /// @dev intended flow is to: read source state, clear source state, call migrate function on target, log success event
683     function migrate()
684         public;
685 
686     /// @notice should enable migration to migration target
687     /// @dev should limit access to specific role in implementation
688     function enableMigration(IMigrationTarget migration)
689         public;
690 
691     /// @notice returns current migration target
692     function currentMigrationTarget()
693         public
694         constant
695         returns (IMigrationTarget);
696 }
697 
698 /// @notice mixin that enables migration pattern for a contract
699 /// @dev when derived from
700 contract MigrationSource is
701     IMigrationSource,
702     AccessControlled
703 {
704     ////////////////////////
705     // Immutable state
706     ////////////////////////
707 
708     /// stores role hash that can enable migration
709     bytes32 private MIGRATION_ADMIN;
710 
711     ////////////////////////
712     // Mutable state
713     ////////////////////////
714 
715     // migration target contract
716     IMigrationTarget internal _migration;
717 
718     ////////////////////////
719     // Modifiers
720     ////////////////////////
721 
722     /// @notice add to enableMigration function to prevent changing of migration
723     ///     target once set
724     modifier onlyMigrationEnabledOnce() {
725         require(address(_migration) == 0);
726         _;
727     }
728 
729     modifier onlyMigrationEnabled() {
730         require(address(_migration) != 0);
731         _;
732     }
733 
734     ////////////////////////
735     // Constructor
736     ////////////////////////
737 
738     constructor(
739         IAccessPolicy policy,
740         bytes32 migrationAdminRole
741     )
742         AccessControlled(policy)
743         internal
744     {
745         MIGRATION_ADMIN = migrationAdminRole;
746     }
747 
748     ////////////////////////
749     // Public functions
750     ////////////////////////
751 
752     /// @notice should migrate state that belongs to msg.sender
753     /// @dev do not forget to add accessor `onlyMigrationEnabled` modifier in implementation
754     function migrate()
755         public;
756 
757     /// @notice should enable migration to migration target
758     /// @dev do not forget to add accessor modifier in override
759     function enableMigration(IMigrationTarget migration)
760         public
761         onlyMigrationEnabledOnce()
762         only(MIGRATION_ADMIN)
763     {
764         // this must be the source
765         require(migration.currentMigrationSource() == address(this));
766         _migration = migration;
767         emit LogMigrationEnabled(_migration);
768     }
769 
770     /// @notice returns current migration target
771     function currentMigrationTarget()
772         public
773         constant
774         returns (IMigrationTarget)
775     {
776         return _migration;
777     }
778 }
779 
780 contract IsContract {
781 
782     ////////////////////////
783     // Internal functions
784     ////////////////////////
785 
786     function isContract(address addr)
787         internal
788         constant
789         returns (bool)
790     {
791         uint256 size;
792         // takes 700 gas
793         assembly { size := extcodesize(addr) }
794         return size > 0;
795     }
796 }
797 
798 contract IBasicToken {
799 
800     ////////////////////////
801     // Events
802     ////////////////////////
803 
804     event Transfer(
805         address indexed from,
806         address indexed to,
807         uint256 amount
808     );
809 
810     ////////////////////////
811     // Public functions
812     ////////////////////////
813 
814     /// @dev This function makes it easy to get the total number of tokens
815     /// @return The total number of tokens
816     function totalSupply()
817         public
818         constant
819         returns (uint256);
820 
821     /// @param owner The address that's balance is being requested
822     /// @return The balance of `owner` at the current block
823     function balanceOf(address owner)
824         public
825         constant
826         returns (uint256 balance);
827 
828     /// @notice Send `amount` tokens to `to` from `msg.sender`
829     /// @param to The address of the recipient
830     /// @param amount The amount of tokens to be transferred
831     /// @return Whether the transfer was successful or not
832     function transfer(address to, uint256 amount)
833         public
834         returns (bool success);
835 
836 }
837 
838 /// @title allows deriving contract to recover any token or ether that it has balance of
839 /// @notice note that this opens your contracts to claims from various people saying they lost tokens and they want them back
840 ///     be ready to handle such claims
841 /// @dev use with care!
842 ///     1. ROLE_RECLAIMER is allowed to claim tokens, it's not returning tokens to original owner
843 ///     2. in derived contract that holds any token by design you must override `reclaim` and block such possibility.
844 ///         see ICBMLockedAccount as an example
845 contract Reclaimable is AccessControlled, AccessRoles {
846 
847     ////////////////////////
848     // Constants
849     ////////////////////////
850 
851     IBasicToken constant internal RECLAIM_ETHER = IBasicToken(0x0);
852 
853     ////////////////////////
854     // Public functions
855     ////////////////////////
856 
857     function reclaim(IBasicToken token)
858         public
859         only(ROLE_RECLAIMER)
860     {
861         address reclaimer = msg.sender;
862         if(token == RECLAIM_ETHER) {
863             reclaimer.transfer(address(this).balance);
864         } else {
865             uint256 balance = token.balanceOf(this);
866             require(token.transfer(reclaimer, balance));
867         }
868     }
869 }
870 
871 contract ITokenMetadata {
872 
873     ////////////////////////
874     // Public functions
875     ////////////////////////
876 
877     function symbol()
878         public
879         constant
880         returns (string);
881 
882     function name()
883         public
884         constant
885         returns (string);
886 
887     function decimals()
888         public
889         constant
890         returns (uint8);
891 }
892 
893 /// @title adds token metadata to token contract
894 /// @dev see Neumark for example implementation
895 contract TokenMetadata is ITokenMetadata {
896 
897     ////////////////////////
898     // Immutable state
899     ////////////////////////
900 
901     // The Token's name: e.g. DigixDAO Tokens
902     string private NAME;
903 
904     // An identifier: e.g. REP
905     string private SYMBOL;
906 
907     // Number of decimals of the smallest unit
908     uint8 private DECIMALS;
909 
910     // An arbitrary versioning scheme
911     string private VERSION;
912 
913     ////////////////////////
914     // Constructor
915     ////////////////////////
916 
917     /// @notice Constructor to set metadata
918     /// @param tokenName Name of the new token
919     /// @param decimalUnits Number of decimals of the new token
920     /// @param tokenSymbol Token Symbol for the new token
921     /// @param version Token version ie. when cloning is used
922     constructor(
923         string tokenName,
924         uint8 decimalUnits,
925         string tokenSymbol,
926         string version
927     )
928         public
929     {
930         NAME = tokenName;                                 // Set the name
931         SYMBOL = tokenSymbol;                             // Set the symbol
932         DECIMALS = decimalUnits;                          // Set the decimals
933         VERSION = version;
934     }
935 
936     ////////////////////////
937     // Public functions
938     ////////////////////////
939 
940     function name()
941         public
942         constant
943         returns (string)
944     {
945         return NAME;
946     }
947 
948     function symbol()
949         public
950         constant
951         returns (string)
952     {
953         return SYMBOL;
954     }
955 
956     function decimals()
957         public
958         constant
959         returns (uint8)
960     {
961         return DECIMALS;
962     }
963 
964     function version()
965         public
966         constant
967         returns (string)
968     {
969         return VERSION;
970     }
971 }
972 
973 /// @title controls spending approvals
974 /// @dev TokenAllowance observes this interface, Neumark contract implements it
975 contract MTokenAllowanceController {
976 
977     ////////////////////////
978     // Internal functions
979     ////////////////////////
980 
981     /// @notice Notifies the controller about an approval allowing the
982     ///  controller to react if desired
983     /// @param owner The address that calls `approve()`
984     /// @param spender The spender in the `approve()` call
985     /// @param amount The amount in the `approve()` call
986     /// @return False if the controller does not authorize the approval
987     function mOnApprove(
988         address owner,
989         address spender,
990         uint256 amount
991     )
992         internal
993         returns (bool allow);
994 
995     /// @notice Allows to override allowance approved by the owner
996     ///         Primary role is to enable forced transfers, do not override if you do not like it
997     ///         Following behavior is expected in the observer
998     ///         approve() - should revert if mAllowanceOverride() > 0
999     ///         allowance() - should return mAllowanceOverride() if set
1000     ///         transferFrom() - should override allowance if mAllowanceOverride() > 0
1001     /// @param owner An address giving allowance to spender
1002     /// @param spender An address getting  a right to transfer allowance amount from the owner
1003     /// @return current allowance amount
1004     function mAllowanceOverride(
1005         address owner,
1006         address spender
1007     )
1008         internal
1009         constant
1010         returns (uint256 allowance);
1011 }
1012 
1013 /// @title controls token transfers
1014 /// @dev BasicSnapshotToken observes this interface, Neumark contract implements it
1015 contract MTokenTransferController {
1016 
1017     ////////////////////////
1018     // Internal functions
1019     ////////////////////////
1020 
1021     /// @notice Notifies the controller about a token transfer allowing the
1022     ///  controller to react if desired
1023     /// @param from The origin of the transfer
1024     /// @param to The destination of the transfer
1025     /// @param amount The amount of the transfer
1026     /// @return False if the controller does not authorize the transfer
1027     function mOnTransfer(
1028         address from,
1029         address to,
1030         uint256 amount
1031     )
1032         internal
1033         returns (bool allow);
1034 
1035 }
1036 
1037 /// @title controls approvals and transfers
1038 /// @dev The token controller contract must implement these functions, see Neumark as example
1039 /// @dev please note that controller may be a separate contract that is called from mOnTransfer and mOnApprove functions
1040 contract MTokenController is MTokenTransferController, MTokenAllowanceController {
1041 }
1042 
1043 contract TrustlessTokenController is
1044     MTokenController
1045 {
1046     ////////////////////////
1047     // Internal functions
1048     ////////////////////////
1049 
1050     //
1051     // Implements MTokenController
1052     //
1053 
1054     function mOnTransfer(
1055         address /*from*/,
1056         address /*to*/,
1057         uint256 /*amount*/
1058     )
1059         internal
1060         returns (bool allow)
1061     {
1062         return true;
1063     }
1064 
1065     function mOnApprove(
1066         address /*owner*/,
1067         address /*spender*/,
1068         uint256 /*amount*/
1069     )
1070         internal
1071         returns (bool allow)
1072     {
1073         return true;
1074     }
1075 }
1076 
1077 contract IERC20Allowance {
1078 
1079     ////////////////////////
1080     // Events
1081     ////////////////////////
1082 
1083     event Approval(
1084         address indexed owner,
1085         address indexed spender,
1086         uint256 amount
1087     );
1088 
1089     ////////////////////////
1090     // Public functions
1091     ////////////////////////
1092 
1093     /// @dev This function makes it easy to read the `allowed[]` map
1094     /// @param owner The address of the account that owns the token
1095     /// @param spender The address of the account able to transfer the tokens
1096     /// @return Amount of remaining tokens of owner that spender is allowed
1097     ///  to spend
1098     function allowance(address owner, address spender)
1099         public
1100         constant
1101         returns (uint256 remaining);
1102 
1103     /// @notice `msg.sender` approves `spender` to spend `amount` tokens on
1104     ///  its behalf. This is a modified version of the ERC20 approve function
1105     ///  to be a little bit safer
1106     /// @param spender The address of the account able to transfer the tokens
1107     /// @param amount The amount of tokens to be approved for transfer
1108     /// @return True if the approval was successful
1109     function approve(address spender, uint256 amount)
1110         public
1111         returns (bool success);
1112 
1113     /// @notice Send `amount` tokens to `to` from `from` on the condition it
1114     ///  is approved by `from`
1115     /// @param from The address holding the tokens being transferred
1116     /// @param to The address of the recipient
1117     /// @param amount The amount of tokens to be transferred
1118     /// @return True if the transfer was successful
1119     function transferFrom(address from, address to, uint256 amount)
1120         public
1121         returns (bool success);
1122 
1123 }
1124 
1125 contract IERC20Token is IBasicToken, IERC20Allowance {
1126 
1127 }
1128 
1129 contract IERC677Callback {
1130 
1131     ////////////////////////
1132     // Public functions
1133     ////////////////////////
1134 
1135     // NOTE: This call can be initiated by anyone. You need to make sure that
1136     // it is send by the token (`require(msg.sender == token)`) or make sure
1137     // amount is valid (`require(token.allowance(this) >= amount)`).
1138     function receiveApproval(
1139         address from,
1140         uint256 amount,
1141         address token, // IERC667Token
1142         bytes data
1143     )
1144         public
1145         returns (bool success);
1146 
1147 }
1148 
1149 contract IERC677Allowance is IERC20Allowance {
1150 
1151     ////////////////////////
1152     // Public functions
1153     ////////////////////////
1154 
1155     /// @notice `msg.sender` approves `spender` to send `amount` tokens on
1156     ///  its behalf, and then a function is triggered in the contract that is
1157     ///  being approved, `spender`. This allows users to use their tokens to
1158     ///  interact with contracts in one function call instead of two
1159     /// @param spender The address of the contract able to transfer the tokens
1160     /// @param amount The amount of tokens to be approved for transfer
1161     /// @return True if the function call was successful
1162     function approveAndCall(address spender, uint256 amount, bytes extraData)
1163         public
1164         returns (bool success);
1165 
1166 }
1167 
1168 contract IERC677Token is IERC20Token, IERC677Allowance {
1169 }
1170 
1171 contract Math {
1172 
1173     ////////////////////////
1174     // Internal functions
1175     ////////////////////////
1176 
1177     // absolute difference: |v1 - v2|
1178     function absDiff(uint256 v1, uint256 v2)
1179         internal
1180         pure
1181         returns(uint256)
1182     {
1183         return v1 > v2 ? v1 - v2 : v2 - v1;
1184     }
1185 
1186     // divide v by d, round up if remainder is 0.5 or more
1187     function divRound(uint256 v, uint256 d)
1188         internal
1189         pure
1190         returns(uint256)
1191     {
1192         return add(v, d/2) / d;
1193     }
1194 
1195     // computes decimal decimalFraction 'frac' of 'amount' with maximum precision (multiplication first)
1196     // both amount and decimalFraction must have 18 decimals precision, frac 10**18 represents a whole (100% of) amount
1197     // mind loss of precision as decimal fractions do not have finite binary expansion
1198     // do not use instead of division
1199     function decimalFraction(uint256 amount, uint256 frac)
1200         internal
1201         pure
1202         returns(uint256)
1203     {
1204         // it's like 1 ether is 100% proportion
1205         return proportion(amount, frac, 10**18);
1206     }
1207 
1208     // computes part/total of amount with maximum precision (multiplication first)
1209     // part and total must have the same units
1210     function proportion(uint256 amount, uint256 part, uint256 total)
1211         internal
1212         pure
1213         returns(uint256)
1214     {
1215         return divRound(mul(amount, part), total);
1216     }
1217 
1218     //
1219     // Open Zeppelin Math library below
1220     //
1221 
1222     function mul(uint256 a, uint256 b)
1223         internal
1224         pure
1225         returns (uint256)
1226     {
1227         uint256 c = a * b;
1228         assert(a == 0 || c / a == b);
1229         return c;
1230     }
1231 
1232     function sub(uint256 a, uint256 b)
1233         internal
1234         pure
1235         returns (uint256)
1236     {
1237         assert(b <= a);
1238         return a - b;
1239     }
1240 
1241     function add(uint256 a, uint256 b)
1242         internal
1243         pure
1244         returns (uint256)
1245     {
1246         uint256 c = a + b;
1247         assert(c >= a);
1248         return c;
1249     }
1250 
1251     function min(uint256 a, uint256 b)
1252         internal
1253         pure
1254         returns (uint256)
1255     {
1256         return a < b ? a : b;
1257     }
1258 
1259     function max(uint256 a, uint256 b)
1260         internal
1261         pure
1262         returns (uint256)
1263     {
1264         return a > b ? a : b;
1265     }
1266 }
1267 
1268 /// @title internal token transfer function
1269 /// @dev see BasicSnapshotToken for implementation
1270 contract MTokenTransfer {
1271 
1272     ////////////////////////
1273     // Internal functions
1274     ////////////////////////
1275 
1276     /// @dev This is the actual transfer function in the token contract, it can
1277     ///  only be called by other functions in this contract.
1278     /// @param from The address holding the tokens being transferred
1279     /// @param to The address of the recipient
1280     /// @param amount The amount of tokens to be transferred
1281     /// @dev  reverts if transfer was not successful
1282     function mTransfer(
1283         address from,
1284         address to,
1285         uint256 amount
1286     )
1287         internal;
1288 }
1289 
1290 /**
1291  * @title Basic token
1292  * @dev Basic version of StandardToken, with no allowances.
1293  */
1294 contract BasicToken is
1295     MTokenTransfer,
1296     MTokenTransferController,
1297     IBasicToken,
1298     Math
1299 {
1300 
1301     ////////////////////////
1302     // Mutable state
1303     ////////////////////////
1304 
1305     mapping(address => uint256) internal _balances;
1306 
1307     uint256 internal _totalSupply;
1308 
1309     ////////////////////////
1310     // Public functions
1311     ////////////////////////
1312 
1313     /**
1314     * @dev transfer token for a specified address
1315     * @param to The address to transfer to.
1316     * @param amount The amount to be transferred.
1317     */
1318     function transfer(address to, uint256 amount)
1319         public
1320         returns (bool)
1321     {
1322         mTransfer(msg.sender, to, amount);
1323         return true;
1324     }
1325 
1326     /// @dev This function makes it easy to get the total number of tokens
1327     /// @return The total number of tokens
1328     function totalSupply()
1329         public
1330         constant
1331         returns (uint256)
1332     {
1333         return _totalSupply;
1334     }
1335 
1336     /**
1337     * @dev Gets the balance of the specified address.
1338     * @param owner The address to query the the balance of.
1339     * @return An uint256 representing the amount owned by the passed address.
1340     */
1341     function balanceOf(address owner)
1342         public
1343         constant
1344         returns (uint256 balance)
1345     {
1346         return _balances[owner];
1347     }
1348 
1349     ////////////////////////
1350     // Internal functions
1351     ////////////////////////
1352 
1353     //
1354     // Implements MTokenTransfer
1355     //
1356 
1357     function mTransfer(address from, address to, uint256 amount)
1358         internal
1359     {
1360         require(to != address(0));
1361         require(mOnTransfer(from, to, amount));
1362 
1363         _balances[from] = sub(_balances[from], amount);
1364         _balances[to] = add(_balances[to], amount);
1365         emit Transfer(from, to, amount);
1366     }
1367 }
1368 
1369 /// @title token spending approval and transfer
1370 /// @dev implements token approval and transfers and exposes relevant part of ERC20 and ERC677 approveAndCall
1371 ///     may be mixed in with any basic token (implementing mTransfer) like BasicSnapshotToken or MintableSnapshotToken to add approval mechanism
1372 ///     observes MTokenAllowanceController interface
1373 ///     observes MTokenTransfer
1374 contract TokenAllowance is
1375     MTokenTransfer,
1376     MTokenAllowanceController,
1377     IERC20Allowance,
1378     IERC677Token
1379 {
1380 
1381     ////////////////////////
1382     // Mutable state
1383     ////////////////////////
1384 
1385     // `allowed` tracks rights to spends others tokens as per ERC20
1386     // owner => spender => amount
1387     mapping (address => mapping (address => uint256)) private _allowed;
1388 
1389     ////////////////////////
1390     // Constructor
1391     ////////////////////////
1392 
1393     constructor()
1394         internal
1395     {
1396     }
1397 
1398     ////////////////////////
1399     // Public functions
1400     ////////////////////////
1401 
1402     //
1403     // Implements IERC20Token
1404     //
1405 
1406     /// @dev This function makes it easy to read the `allowed[]` map
1407     /// @param owner The address of the account that owns the token
1408     /// @param spender The address of the account able to transfer the tokens
1409     /// @return Amount of remaining tokens of _owner that _spender is allowed
1410     ///  to spend
1411     function allowance(address owner, address spender)
1412         public
1413         constant
1414         returns (uint256 remaining)
1415     {
1416         uint256 override = mAllowanceOverride(owner, spender);
1417         if (override > 0) {
1418             return override;
1419         }
1420         return _allowed[owner][spender];
1421     }
1422 
1423     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
1424     ///  its behalf. This is a modified version of the ERC20 approve function
1425     ///  where allowance per spender must be 0 to allow change of such allowance
1426     /// @param spender The address of the account able to transfer the tokens
1427     /// @param amount The amount of tokens to be approved for transfer
1428     /// @return True or reverts, False is never returned
1429     function approve(address spender, uint256 amount)
1430         public
1431         returns (bool success)
1432     {
1433         // Alerts the token controller of the approve function call
1434         require(mOnApprove(msg.sender, spender, amount));
1435 
1436         // To change the approve amount you first have to reduce the addresses`
1437         //  allowance to zero by calling `approve(_spender,0)` if it is not
1438         //  already 0 to mitigate the race condition described here:
1439         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1440         require((amount == 0 || _allowed[msg.sender][spender] == 0) && mAllowanceOverride(msg.sender, spender) == 0);
1441 
1442         _allowed[msg.sender][spender] = amount;
1443         emit Approval(msg.sender, spender, amount);
1444         return true;
1445     }
1446 
1447     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
1448     ///  is approved by `_from`
1449     /// @param from The address holding the tokens being transferred
1450     /// @param to The address of the recipient
1451     /// @param amount The amount of tokens to be transferred
1452     /// @return True if the transfer was successful, reverts in any other case
1453     function transferFrom(address from, address to, uint256 amount)
1454         public
1455         returns (bool success)
1456     {
1457         uint256 allowed = mAllowanceOverride(from, msg.sender);
1458         if (allowed == 0) {
1459             // The standard ERC 20 transferFrom functionality
1460             allowed = _allowed[from][msg.sender];
1461             // yes this will underflow but then we'll revert. will cost gas however so don't underflow
1462             _allowed[from][msg.sender] -= amount;
1463         }
1464         require(allowed >= amount);
1465         mTransfer(from, to, amount);
1466         return true;
1467     }
1468 
1469     //
1470     // Implements IERC677Token
1471     //
1472 
1473     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
1474     ///  its behalf, and then a function is triggered in the contract that is
1475     ///  being approved, `_spender`. This allows users to use their tokens to
1476     ///  interact with contracts in one function call instead of two
1477     /// @param spender The address of the contract able to transfer the tokens
1478     /// @param amount The amount of tokens to be approved for transfer
1479     /// @return True or reverts, False is never returned
1480     function approveAndCall(
1481         address spender,
1482         uint256 amount,
1483         bytes extraData
1484     )
1485         public
1486         returns (bool success)
1487     {
1488         require(approve(spender, amount));
1489 
1490         success = IERC677Callback(spender).receiveApproval(
1491             msg.sender,
1492             amount,
1493             this,
1494             extraData
1495         );
1496         require(success);
1497 
1498         return true;
1499     }
1500 
1501     ////////////////////////
1502     // Internal functions
1503     ////////////////////////
1504 
1505     //
1506     // Implements default MTokenAllowanceController
1507     //
1508 
1509     // no override in default implementation
1510     function mAllowanceOverride(
1511         address /*owner*/,
1512         address /*spender*/
1513     )
1514         internal
1515         constant
1516         returns (uint256)
1517     {
1518         return 0;
1519     }
1520 }
1521 
1522 /**
1523  * @title Standard ERC20 token
1524  *
1525  * @dev Implementation of the standard token.
1526  * @dev https://github.com/ethereum/EIPs/issues/20
1527  */
1528 contract StandardToken is
1529     IERC20Token,
1530     BasicToken,
1531     TokenAllowance
1532 {
1533 
1534 }
1535 
1536 /// @title uniquely identifies deployable (non-abstract) platform contract
1537 /// @notice cheap way of assigning implementations to knownInterfaces which represent system services
1538 ///         unfortunatelly ERC165 does not include full public interface (ABI) and does not provide way to list implemented interfaces
1539 ///         EIP820 still in the making
1540 /// @dev ids are generated as follows keccak256("neufund-platform:<contract name>")
1541 ///      ids roughly correspond to ABIs
1542 contract IContractId {
1543     /// @param id defined as above
1544     /// @param version implementation version
1545     function contractId() public pure returns (bytes32 id, uint256 version);
1546 }
1547 
1548 /// @title current ERC223 fallback function
1549 /// @dev to be used in all future token contract
1550 /// @dev NEU and ICBMEtherToken (obsolete) are the only contracts that still uses IERC223LegacyCallback
1551 contract IERC223Callback {
1552 
1553     ////////////////////////
1554     // Public functions
1555     ////////////////////////
1556 
1557     function tokenFallback(address from, uint256 amount, bytes data)
1558         public;
1559 
1560 }
1561 
1562 contract IERC223Token is IERC20Token, ITokenMetadata {
1563 
1564     /// @dev Departure: We do not log data, it has no advantage over a standard
1565     ///     log event. By sticking to the standard log event we
1566     ///     stay compatible with constracts that expect and ERC20 token.
1567 
1568     // event Transfer(
1569     //    address indexed from,
1570     //    address indexed to,
1571     //    uint256 amount,
1572     //    bytes data);
1573 
1574 
1575     /// @dev Departure: We do not use the callback on regular transfer calls to
1576     ///     stay compatible with constracts that expect and ERC20 token.
1577 
1578     // function transfer(address to, uint256 amount)
1579     //     public
1580     //     returns (bool);
1581 
1582     ////////////////////////
1583     // Public functions
1584     ////////////////////////
1585 
1586     function transfer(address to, uint256 amount, bytes data)
1587         public
1588         returns (bool);
1589 }
1590 
1591 contract IWithdrawableToken {
1592 
1593     ////////////////////////
1594     // Public functions
1595     ////////////////////////
1596 
1597     /// @notice withdraws from a token holding assets
1598     /// @dev amount of asset should be returned to msg.sender and corresponding balance burned
1599     function withdraw(uint256 amount)
1600         public;
1601 }
1602 
1603 contract EtherToken is
1604     IsContract,
1605     IContractId,
1606     AccessControlled,
1607     StandardToken,
1608     TrustlessTokenController,
1609     IWithdrawableToken,
1610     TokenMetadata,
1611     IERC223Token,
1612     Reclaimable
1613 {
1614     ////////////////////////
1615     // Constants
1616     ////////////////////////
1617 
1618     string private constant NAME = "Ether Token";
1619 
1620     string private constant SYMBOL = "ETH-T";
1621 
1622     uint8 private constant DECIMALS = 18;
1623 
1624     ////////////////////////
1625     // Events
1626     ////////////////////////
1627 
1628     event LogDeposit(
1629         address indexed to,
1630         uint256 amount
1631     );
1632 
1633     event LogWithdrawal(
1634         address indexed from,
1635         uint256 amount
1636     );
1637 
1638     event LogWithdrawAndSend(
1639         address indexed from,
1640         address indexed to,
1641         uint256 amount
1642     );
1643 
1644     ////////////////////////
1645     // Constructor
1646     ////////////////////////
1647 
1648     constructor(IAccessPolicy accessPolicy)
1649         AccessControlled(accessPolicy)
1650         StandardToken()
1651         TokenMetadata(NAME, DECIMALS, SYMBOL, "")
1652         Reclaimable()
1653         public
1654     {
1655     }
1656 
1657     ////////////////////////
1658     // Public functions
1659     ////////////////////////
1660 
1661     /// deposit msg.value of Ether to msg.sender balance
1662     function deposit()
1663         public
1664         payable
1665     {
1666         depositPrivate();
1667         emit Transfer(address(0), msg.sender, msg.value);
1668     }
1669 
1670     /// @notice convenience function to deposit and immediately transfer amount
1671     /// @param transferTo where to transfer after deposit
1672     /// @param amount total amount to transfer, must be <= balance after deposit
1673     /// @param data erc223 data
1674     /// @dev intended to deposit from simple account and invest in ETO
1675     function depositAndTransfer(address transferTo, uint256 amount, bytes data)
1676         public
1677         payable
1678     {
1679         depositPrivate();
1680         transfer(transferTo, amount, data);
1681     }
1682 
1683     /// withdraws and sends 'amount' of ether to msg.sender
1684     function withdraw(uint256 amount)
1685         public
1686     {
1687         withdrawPrivate(amount);
1688         msg.sender.transfer(amount);
1689     }
1690 
1691     /// @notice convenience function to withdraw and transfer to external account
1692     /// @param sendTo address to which send total amount
1693     /// @param amount total amount to withdraw and send
1694     /// @dev function is payable and is meant to withdraw funds on accounts balance and token in single transaction
1695     /// @dev BEWARE that msg.sender of the funds is Ether Token contract and not simple account calling it.
1696     /// @dev  when sent to smart conctract funds may be lost, so this is prevented below
1697     function withdrawAndSend(address sendTo, uint256 amount)
1698         public
1699         payable
1700     {
1701         // must send at least what is in msg.value to being another deposit function
1702         require(amount >= msg.value, "NF_ET_NO_DEPOSIT");
1703         if (amount > msg.value) {
1704             uint256 withdrawRemainder = amount - msg.value;
1705             withdrawPrivate(withdrawRemainder);
1706         }
1707         emit LogWithdrawAndSend(msg.sender, sendTo, amount);
1708         sendTo.transfer(amount);
1709     }
1710 
1711     //
1712     // Implements IERC223Token
1713     //
1714 
1715     function transfer(address to, uint256 amount, bytes data)
1716         public
1717         returns (bool)
1718     {
1719         BasicToken.mTransfer(msg.sender, to, amount);
1720 
1721         // Notify the receiving contract.
1722         if (isContract(to)) {
1723             // in case of re-entry (1) transfer is done (2) msg.sender is different
1724             IERC223Callback(to).tokenFallback(msg.sender, amount, data);
1725         }
1726         return true;
1727     }
1728 
1729     //
1730     // Overrides Reclaimable
1731     //
1732 
1733     /// @notice allows EtherToken to reclaim tokens wrongly sent to its address
1734     /// @dev as EtherToken by design has balance of Ether (native Ethereum token)
1735     ///     such reclamation is not allowed
1736     function reclaim(IBasicToken token)
1737         public
1738     {
1739         // forbid reclaiming ETH hold in this contract.
1740         require(token != RECLAIM_ETHER);
1741         Reclaimable.reclaim(token);
1742     }
1743 
1744     //
1745     // Implements IContractId
1746     //
1747 
1748     function contractId() public pure returns (bytes32 id, uint256 version) {
1749         return (0x75b86bc24f77738576716a36431588ae768d80d077231d1661c2bea674c6373a, 0);
1750     }
1751 
1752 
1753     ////////////////////////
1754     // Private functions
1755     ////////////////////////
1756 
1757     function depositPrivate()
1758         private
1759     {
1760         _balances[msg.sender] = add(_balances[msg.sender], msg.value);
1761         _totalSupply = add(_totalSupply, msg.value);
1762         emit LogDeposit(msg.sender, msg.value);
1763     }
1764 
1765     function withdrawPrivate(uint256 amount)
1766         private
1767     {
1768         require(_balances[msg.sender] >= amount);
1769         _balances[msg.sender] = sub(_balances[msg.sender], amount);
1770         _totalSupply = sub(_totalSupply, amount);
1771         emit LogWithdrawal(msg.sender, amount);
1772         emit Transfer(msg.sender, address(0), amount);
1773     }
1774 }
1775 
1776 /// @title granular token controller based on MSnapshotToken observer pattern
1777 contract ITokenController {
1778 
1779     ////////////////////////
1780     // Public functions
1781     ////////////////////////
1782 
1783     /// @notice see MTokenTransferController
1784     /// @dev additionally passes broker that is executing transaction between from and to
1785     ///      for unbrokered transfer, broker == from
1786     function onTransfer(address broker, address from, address to, uint256 amount)
1787         public
1788         constant
1789         returns (bool allow);
1790 
1791     /// @notice see MTokenAllowanceController
1792     function onApprove(address owner, address spender, uint256 amount)
1793         public
1794         constant
1795         returns (bool allow);
1796 
1797     /// @notice see MTokenMint
1798     function onGenerateTokens(address sender, address owner, uint256 amount)
1799         public
1800         constant
1801         returns (bool allow);
1802 
1803     /// @notice see MTokenMint
1804     function onDestroyTokens(address sender, address owner, uint256 amount)
1805         public
1806         constant
1807         returns (bool allow);
1808 
1809     /// @notice controls if sender can change controller to newController
1810     /// @dev for this to succeed TYPICALLY current controller must be already migrated to a new one
1811     function onChangeTokenController(address sender, address newController)
1812         public
1813         constant
1814         returns (bool);
1815 
1816     /// @notice overrides spender allowance
1817     /// @dev may be used to implemented forced transfers in which token controller may override approved allowance
1818     ///      with any > 0 value and then use transferFrom to execute such transfer
1819     ///      This by definition creates non-trustless token so do not implement this call if you do not need trustless transfers!
1820     ///      Implementer should not allow approve() to be executed if there is an overrride
1821     //       Implemented should return allowance() taking into account override
1822     function onAllowance(address owner, address spender)
1823         public
1824         constant
1825         returns (uint256 allowanceOverride);
1826 }
1827 
1828 /// @title hooks token controller to token contract and allows to replace it
1829 contract ITokenControllerHook {
1830 
1831     ////////////////////////
1832     // Events
1833     ////////////////////////
1834 
1835     event LogChangeTokenController(
1836         address oldController,
1837         address newController,
1838         address by
1839     );
1840 
1841     ////////////////////////
1842     // Public functions
1843     ////////////////////////
1844 
1845     /// @notice replace current token controller
1846     /// @dev please note that this process is also controlled by existing controller
1847     function changeTokenController(address newController)
1848         public;
1849 
1850     /// @notice returns current controller
1851     function tokenController()
1852         public
1853         constant
1854         returns (address currentController);
1855 
1856 }
1857 
1858 contract EuroToken is
1859     Agreement,
1860     IERC677Token,
1861     StandardToken,
1862     IWithdrawableToken,
1863     ITokenControllerHook,
1864     TokenMetadata,
1865     IERC223Token,
1866     IsContract,
1867     IContractId
1868 {
1869     ////////////////////////
1870     // Constants
1871     ////////////////////////
1872 
1873     string private constant NAME = "Euro Token";
1874 
1875     string private constant SYMBOL = "EUR-T";
1876 
1877     uint8 private constant DECIMALS = 18;
1878 
1879     ////////////////////////
1880     // Mutable state
1881     ////////////////////////
1882 
1883     ITokenController private _tokenController;
1884 
1885     ////////////////////////
1886     // Events
1887     ////////////////////////
1888 
1889     /// on each deposit (increase of supply) of EUR-T
1890     /// 'by' indicates account that executed the deposit function for 'to' (typically bank connector)
1891     event LogDeposit(
1892         address indexed to,
1893         address by,
1894         uint256 amount,
1895         bytes32 reference
1896     );
1897 
1898     // proof of requested deposit initiated by token holder
1899     event LogWithdrawal(
1900         address indexed from,
1901         uint256 amount
1902     );
1903 
1904     // proof of settled deposit
1905     event LogWithdrawSettled(
1906         address from,
1907         address by, // who settled
1908         uint256 amount, // settled amount, after fees, negative interest rates etc.
1909         uint256 originalAmount, // original amount withdrawn
1910         bytes32 withdrawTxHash, // hash of withdraw transaction
1911         bytes32 reference // reference number of withdraw operation at deposit manager
1912     );
1913 
1914     /// on destroying the tokens without withdraw (see `destroyTokens` function below)
1915     event LogDestroy(
1916         address indexed from,
1917         address by,
1918         uint256 amount
1919     );
1920 
1921     ////////////////////////
1922     // Modifiers
1923     ////////////////////////
1924 
1925     modifier onlyIfDepositAllowed(address to, uint256 amount) {
1926         require(_tokenController.onGenerateTokens(msg.sender, to, amount));
1927         _;
1928     }
1929 
1930     modifier onlyIfWithdrawAllowed(address from, uint256 amount) {
1931         require(_tokenController.onDestroyTokens(msg.sender, from, amount));
1932         _;
1933     }
1934 
1935     ////////////////////////
1936     // Constructor
1937     ////////////////////////
1938 
1939     constructor(
1940         IAccessPolicy accessPolicy,
1941         IEthereumForkArbiter forkArbiter,
1942         ITokenController tokenController
1943     )
1944         Agreement(accessPolicy, forkArbiter)
1945         StandardToken()
1946         TokenMetadata(NAME, DECIMALS, SYMBOL, "")
1947         public
1948     {
1949         require(tokenController != ITokenController(0x0));
1950         _tokenController = tokenController;
1951     }
1952 
1953     ////////////////////////
1954     // Public functions
1955     ////////////////////////
1956 
1957     /// @notice deposit 'amount' of EUR-T to address 'to', attaching correlating `reference` to LogDeposit event
1958     /// @dev deposit may happen only in case 'to' can receive transfer in token controller
1959     ///     by default KYC is required to receive deposits
1960     function deposit(address to, uint256 amount, bytes32 reference)
1961         public
1962         only(ROLE_EURT_DEPOSIT_MANAGER)
1963         onlyIfDepositAllowed(to, amount)
1964         acceptAgreement(to)
1965     {
1966         require(to != address(0));
1967         _balances[to] = add(_balances[to], amount);
1968         _totalSupply = add(_totalSupply, amount);
1969         emit LogDeposit(to, msg.sender, amount, reference);
1970         emit Transfer(address(0), to, amount);
1971     }
1972 
1973     /// @notice runs many deposits within one transaction
1974     /// @dev deposit may happen only in case 'to' can receive transfer in token controller
1975     ///     by default KYC is required to receive deposits
1976     function depositMany(address[] to, uint256[] amount, bytes32[] reference)
1977         public
1978     {
1979         require(to.length == amount.length);
1980         require(to.length == reference.length);
1981         for (uint256 i = 0; i < to.length; i++) {
1982             deposit(to[i], amount[i], reference[i]);
1983         }
1984     }
1985 
1986     /// @notice withdraws 'amount' of EUR-T by burning required amount and providing a proof of whithdrawal
1987     /// @dev proof is provided in form of log entry. based on that proof deposit manager will make a bank transfer
1988     ///     by default controller will check the following: KYC and existence of working bank account
1989     function withdraw(uint256 amount)
1990         public
1991         onlyIfWithdrawAllowed(msg.sender, amount)
1992         acceptAgreement(msg.sender)
1993     {
1994         destroyTokensPrivate(msg.sender, amount);
1995         emit LogWithdrawal(msg.sender, amount);
1996     }
1997 
1998     /// @notice issued by deposit manager when withdraw request was settled. typicaly amount that could be settled will be lower
1999     ///         than amount withdrawn: banks charge negative interest rates and various fees that must be deduced
2000     ///         reference number is attached that may be used to identify withdraw operation at deposit manager
2001     function settleWithdraw(address from, uint256 amount, uint256 originalAmount, bytes32 withdrawTxHash, bytes32 reference)
2002         public
2003         only(ROLE_EURT_DEPOSIT_MANAGER)
2004     {
2005         emit LogWithdrawSettled(from, msg.sender, amount, originalAmount, withdrawTxHash, reference);
2006     }
2007 
2008     /// @notice this method allows to destroy EUR-T belonging to any account
2009     ///     note that EURO is fiat currency and is not trustless, EUR-T is also
2010     ///     just internal currency of Neufund platform, not general purpose stable coin
2011     ///     we need to be able to destroy EUR-T if ordered by authorities
2012     function destroy(address owner, uint256 amount)
2013         public
2014         only(ROLE_EURT_LEGAL_MANAGER)
2015     {
2016         destroyTokensPrivate(owner, amount);
2017         emit LogDestroy(owner, msg.sender, amount);
2018     }
2019 
2020     //
2021     // Implements ITokenControllerHook
2022     //
2023 
2024     function changeTokenController(address newController)
2025         public
2026     {
2027         require(_tokenController.onChangeTokenController(msg.sender, newController));
2028         _tokenController = ITokenController(newController);
2029         emit LogChangeTokenController(_tokenController, newController, msg.sender);
2030     }
2031 
2032     function tokenController()
2033         public
2034         constant
2035         returns (address)
2036     {
2037         return _tokenController;
2038     }
2039 
2040     //
2041     // Implements IERC223Token
2042     //
2043     function transfer(address to, uint256 amount, bytes data)
2044         public
2045         returns (bool success)
2046     {
2047         return ierc223TransferInternal(msg.sender, to, amount, data);
2048     }
2049 
2050     /// @notice convenience function to deposit and immediately transfer amount
2051     /// @param depositTo which account to deposit to and then transfer from
2052     /// @param transferTo where to transfer after deposit
2053     /// @param depositAmount amount to deposit
2054     /// @param transferAmount total amount to transfer, must be <= balance after deposit
2055     /// @dev intended to deposit from bank account and invest in ETO
2056     function depositAndTransfer(
2057         address depositTo,
2058         address transferTo,
2059         uint256 depositAmount,
2060         uint256 transferAmount,
2061         bytes data,
2062         bytes32 reference
2063     )
2064         public
2065         returns (bool success)
2066     {
2067         deposit(depositTo, depositAmount, reference);
2068         return ierc223TransferInternal(depositTo, transferTo, transferAmount, data);
2069     }
2070 
2071     //
2072     // Implements IContractId
2073     //
2074 
2075     function contractId() public pure returns (bytes32 id, uint256 version) {
2076         return (0xfb5c7e43558c4f3f5a2d87885881c9b10ff4be37e3308579c178bf4eaa2c29cd, 0);
2077     }
2078 
2079     ////////////////////////
2080     // Internal functions
2081     ////////////////////////
2082 
2083     //
2084     // Implements MTokenController
2085     //
2086 
2087     function mOnTransfer(
2088         address from,
2089         address to,
2090         uint256 amount
2091     )
2092         internal
2093         acceptAgreement(from)
2094         returns (bool allow)
2095     {
2096         address broker = msg.sender;
2097         if (broker != from) {
2098             // if called by the depositor (deposit and send), ignore the broker flag
2099             bool isDepositor = accessPolicy().allowed(msg.sender, ROLE_EURT_DEPOSIT_MANAGER, this, msg.sig);
2100             // this is not very clean but alternative (give brokerage rights to all depositors) is maintenance hell
2101             if (isDepositor) {
2102                 broker = from;
2103             }
2104         }
2105         return _tokenController.onTransfer(broker, from, to, amount);
2106     }
2107 
2108     function mOnApprove(
2109         address owner,
2110         address spender,
2111         uint256 amount
2112     )
2113         internal
2114         acceptAgreement(owner)
2115         returns (bool allow)
2116     {
2117         return _tokenController.onApprove(owner, spender, amount);
2118     }
2119 
2120     function mAllowanceOverride(
2121         address owner,
2122         address spender
2123     )
2124         internal
2125         constant
2126         returns (uint256)
2127     {
2128         return _tokenController.onAllowance(owner, spender);
2129     }
2130 
2131     //
2132     // Observes MAgreement internal interface
2133     //
2134 
2135     /// @notice euro token is legally represented by separate entity ROLE_EURT_LEGAL_MANAGER
2136     function mCanAmend(address legalRepresentative)
2137         internal
2138         returns (bool)
2139     {
2140         return accessPolicy().allowed(legalRepresentative, ROLE_EURT_LEGAL_MANAGER, this, msg.sig);
2141     }
2142 
2143     ////////////////////////
2144     // Private functions
2145     ////////////////////////
2146 
2147     function destroyTokensPrivate(address owner, uint256 amount)
2148         private
2149     {
2150         require(_balances[owner] >= amount);
2151         _balances[owner] = sub(_balances[owner], amount);
2152         _totalSupply = sub(_totalSupply, amount);
2153         emit Transfer(owner, address(0), amount);
2154     }
2155 
2156     /// @notice internal transfer function that checks permissions and calls the tokenFallback
2157     function ierc223TransferInternal(address from, address to, uint256 amount, bytes data)
2158         private
2159         returns (bool success)
2160     {
2161         BasicToken.mTransfer(from, to, amount);
2162 
2163         // Notify the receiving contract.
2164         if (isContract(to)) {
2165             // in case of re-entry (1) transfer is done (2) msg.sender is different
2166             IERC223Callback(to).tokenFallback(from, amount, data);
2167         }
2168         return true;
2169     }
2170 }
2171 
2172 /// @title serialization of basic types from/to bytes
2173 contract Serialization {
2174     ////////////////////////
2175     // Internal functions
2176     ////////////////////////
2177     function decodeAddress(bytes b)
2178         internal
2179         pure
2180         returns (address a)
2181     {
2182         require(b.length == 20);
2183         assembly {
2184             // load memory area that is address "carved out" of 64 byte bytes. prefix is zeroed
2185             a := and(mload(add(b, 20)), 0x00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
2186         }
2187     }
2188 }
2189 
2190 contract NeumarkIssuanceCurve {
2191 
2192     ////////////////////////
2193     // Constants
2194     ////////////////////////
2195 
2196     // maximum number of neumarks that may be created
2197     uint256 private constant NEUMARK_CAP = 1500000000000000000000000000;
2198 
2199     // initial neumark reward fraction (controls curve steepness)
2200     uint256 private constant INITIAL_REWARD_FRACTION = 6500000000000000000;
2201 
2202     // stop issuing new Neumarks above this Euro value (as it goes quickly to zero)
2203     uint256 private constant ISSUANCE_LIMIT_EUR_ULPS = 8300000000000000000000000000;
2204 
2205     // approximate curve linearly above this Euro value
2206     uint256 private constant LINEAR_APPROX_LIMIT_EUR_ULPS = 2100000000000000000000000000;
2207     uint256 private constant NEUMARKS_AT_LINEAR_LIMIT_ULPS = 1499832501287264827896539871;
2208 
2209     uint256 private constant TOT_LINEAR_NEUMARKS_ULPS = NEUMARK_CAP - NEUMARKS_AT_LINEAR_LIMIT_ULPS;
2210     uint256 private constant TOT_LINEAR_EUR_ULPS = ISSUANCE_LIMIT_EUR_ULPS - LINEAR_APPROX_LIMIT_EUR_ULPS;
2211 
2212     ////////////////////////
2213     // Public functions
2214     ////////////////////////
2215 
2216     /// @notice returns additional amount of neumarks issued for euroUlps at totalEuroUlps
2217     /// @param totalEuroUlps actual curve position from which neumarks will be issued
2218     /// @param euroUlps amount against which neumarks will be issued
2219     function incremental(uint256 totalEuroUlps, uint256 euroUlps)
2220         public
2221         pure
2222         returns (uint256 neumarkUlps)
2223     {
2224         require(totalEuroUlps + euroUlps >= totalEuroUlps);
2225         uint256 from = cumulative(totalEuroUlps);
2226         uint256 to = cumulative(totalEuroUlps + euroUlps);
2227         // as expansion is not monotonic for large totalEuroUlps, assert below may fail
2228         // example: totalEuroUlps=1.999999999999999999999000000e+27 and euroUlps=50
2229         assert(to >= from);
2230         return to - from;
2231     }
2232 
2233     /// @notice returns amount of euro corresponding to burned neumarks
2234     /// @param totalEuroUlps actual curve position from which neumarks will be burned
2235     /// @param burnNeumarkUlps amount of neumarks to burn
2236     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps)
2237         public
2238         pure
2239         returns (uint256 euroUlps)
2240     {
2241         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
2242         require(totalNeumarkUlps >= burnNeumarkUlps);
2243         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
2244         uint newTotalEuroUlps = cumulativeInverse(fromNmk, 0, totalEuroUlps);
2245         // yes, this may overflow due to non monotonic inverse function
2246         assert(totalEuroUlps >= newTotalEuroUlps);
2247         return totalEuroUlps - newTotalEuroUlps;
2248     }
2249 
2250     /// @notice returns amount of euro corresponding to burned neumarks
2251     /// @param totalEuroUlps actual curve position from which neumarks will be burned
2252     /// @param burnNeumarkUlps amount of neumarks to burn
2253     /// @param minEurUlps euro amount to start inverse search from, inclusive
2254     /// @param maxEurUlps euro amount to end inverse search to, inclusive
2255     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2256         public
2257         pure
2258         returns (uint256 euroUlps)
2259     {
2260         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
2261         require(totalNeumarkUlps >= burnNeumarkUlps);
2262         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
2263         uint newTotalEuroUlps = cumulativeInverse(fromNmk, minEurUlps, maxEurUlps);
2264         // yes, this may overflow due to non monotonic inverse function
2265         assert(totalEuroUlps >= newTotalEuroUlps);
2266         return totalEuroUlps - newTotalEuroUlps;
2267     }
2268 
2269     /// @notice finds total amount of neumarks issued for given amount of Euro
2270     /// @dev binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
2271     ///     function below is not monotonic
2272     function cumulative(uint256 euroUlps)
2273         public
2274         pure
2275         returns(uint256 neumarkUlps)
2276     {
2277         // Return the cap if euroUlps is above the limit.
2278         if (euroUlps >= ISSUANCE_LIMIT_EUR_ULPS) {
2279             return NEUMARK_CAP;
2280         }
2281         // use linear approximation above limit below
2282         // binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
2283         if (euroUlps >= LINEAR_APPROX_LIMIT_EUR_ULPS) {
2284             // (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS) is small so expression does not overflow
2285             return NEUMARKS_AT_LINEAR_LIMIT_ULPS + (TOT_LINEAR_NEUMARKS_ULPS * (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS)) / TOT_LINEAR_EUR_ULPS;
2286         }
2287 
2288         // Approximate cap-cap·(1-1/D)^n using the Binomial expansion
2289         // http://galileo.phys.virginia.edu/classes/152.mf1i.spring02/Exponential_Function.htm
2290         // Function[imax, -CAP*Sum[(-IR*EUR/CAP)^i/Factorial[i], {i, imax}]]
2291         // which may be simplified to
2292         // Function[imax, -CAP*Sum[(EUR)^i/(Factorial[i]*(-d)^i), {i, 1, imax}]]
2293         // where d = cap/initial_reward
2294         uint256 d = 230769230769230769230769231; // NEUMARK_CAP / INITIAL_REWARD_FRACTION
2295         uint256 term = NEUMARK_CAP;
2296         uint256 sum = 0;
2297         uint256 denom = d;
2298         do assembly {
2299             // We use assembler primarily to avoid the expensive
2300             // divide-by-zero check solc inserts for the / operator.
2301             term  := div(mul(term, euroUlps), denom)
2302             sum   := add(sum, term)
2303             denom := add(denom, d)
2304             // sub next term as we have power of negative value in the binomial expansion
2305             term  := div(mul(term, euroUlps), denom)
2306             sum   := sub(sum, term)
2307             denom := add(denom, d)
2308         } while (term != 0);
2309         return sum;
2310     }
2311 
2312     /// @notice find issuance curve inverse by binary search
2313     /// @param neumarkUlps neumark amount to compute inverse for
2314     /// @param minEurUlps minimum search range for the inverse, inclusive
2315     /// @param maxEurUlps maxium search range for the inverse, inclusive
2316     /// @dev in case of approximate search (no exact inverse) upper element of minimal search range is returned
2317     /// @dev in case of many possible inverses, the lowest one will be used (if range permits)
2318     /// @dev corresponds to a linear search that returns first euroUlp value that has cumulative() equal or greater than neumarkUlps
2319     function cumulativeInverse(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2320         public
2321         pure
2322         returns (uint256 euroUlps)
2323     {
2324         require(maxEurUlps >= minEurUlps);
2325         require(cumulative(minEurUlps) <= neumarkUlps);
2326         require(cumulative(maxEurUlps) >= neumarkUlps);
2327         uint256 min = minEurUlps;
2328         uint256 max = maxEurUlps;
2329 
2330         // Binary search
2331         while (max > min) {
2332             uint256 mid = (max + min) / 2;
2333             uint256 val = cumulative(mid);
2334             // exact solution should not be used, a late points of the curve when many euroUlps are needed to
2335             // increase by one nmkUlp this will lead to  "indeterministic" inverse values that depend on the initial min and max
2336             // and further binary division -> you can land at any of the euro value that is mapped to the same nmk value
2337             // with condition below removed, binary search will point to the lowest eur value possible which is good because it cannot be exploited even with 0 gas costs
2338             /* if (val == neumarkUlps) {
2339                 return mid;
2340             }*/
2341             // NOTE: approximate search (no inverse) must return upper element of the final range
2342             //  last step of approximate search is always (min, min+1) so new mid is (2*min+1)/2 => min
2343             //  so new min = mid + 1 = max which was upper range. and that ends the search
2344             // NOTE: when there are multiple inverses for the same neumarkUlps, the `max` will be dragged down
2345             //  by `max = mid` expression to the lowest eur value of inverse. works only for ranges that cover all points of multiple inverse
2346             if (val < neumarkUlps) {
2347                 min = mid + 1;
2348             } else {
2349                 max = mid;
2350             }
2351         }
2352         // NOTE: It is possible that there is no inverse
2353         //  for example curve(0) = 0 and curve(1) = 6, so
2354         //  there is no value y such that curve(y) = 5.
2355         //  When there is no inverse, we must return upper element of last search range.
2356         //  This has the effect of reversing the curve less when
2357         //  burning Neumarks. This ensures that Neumarks can always
2358         //  be burned. It also ensure that the total supply of Neumarks
2359         //  remains below the cap.
2360         return max;
2361     }
2362 
2363     function neumarkCap()
2364         public
2365         pure
2366         returns (uint256)
2367     {
2368         return NEUMARK_CAP;
2369     }
2370 
2371     function initialRewardFraction()
2372         public
2373         pure
2374         returns (uint256)
2375     {
2376         return INITIAL_REWARD_FRACTION;
2377     }
2378 }
2379 
2380 /// @title advances snapshot id on demand
2381 /// @dev see Snapshot folder for implementation examples ie. DailyAndSnapshotable contract
2382 contract ISnapshotable {
2383 
2384     ////////////////////////
2385     // Events
2386     ////////////////////////
2387 
2388     /// @dev should log each new snapshot id created, including snapshots created automatically via MSnapshotPolicy
2389     event LogSnapshotCreated(uint256 snapshotId);
2390 
2391     ////////////////////////
2392     // Public functions
2393     ////////////////////////
2394 
2395     /// always creates new snapshot id which gets returned
2396     /// however, there is no guarantee that any snapshot will be created with this id, this depends on the implementation of MSnaphotPolicy
2397     function createSnapshot()
2398         public
2399         returns (uint256);
2400 
2401     /// upper bound of series snapshotIds for which there's a value
2402     function currentSnapshotId()
2403         public
2404         constant
2405         returns (uint256);
2406 }
2407 
2408 /// @title Abstracts snapshot id creation logics
2409 /// @dev Mixin (internal interface) of the snapshot policy which abstracts snapshot id creation logics from Snapshot contract
2410 /// @dev to be implemented and such implementation should be mixed with Snapshot-derived contract, see EveryBlock for simplest example of implementation and StandardSnapshotToken
2411 contract MSnapshotPolicy {
2412 
2413     ////////////////////////
2414     // Internal functions
2415     ////////////////////////
2416 
2417     // The snapshot Ids need to be strictly increasing.
2418     // Whenever the snaspshot id changes, a new snapshot will be created.
2419     // As long as the same snapshot id is being returned, last snapshot will be updated as this indicates that snapshot id didn't change
2420     //
2421     // Values passed to `hasValueAt` and `valuteAt` are required
2422     // to be less or equal to `mCurrentSnapshotId()`.
2423     function mAdvanceSnapshotId()
2424         internal
2425         returns (uint256);
2426 
2427     // this is a version of mAdvanceSnapshotId that does not modify state but MUST return the same value
2428     // it is required to implement ITokenSnapshots interface cleanly
2429     function mCurrentSnapshotId()
2430         internal
2431         constant
2432         returns (uint256);
2433 
2434 }
2435 
2436 /// @title creates new snapshot id on each day boundary
2437 /// @dev snapshot id is unix timestamp of current day boundary
2438 contract Daily is MSnapshotPolicy {
2439 
2440     ////////////////////////
2441     // Constants
2442     ////////////////////////
2443 
2444     // Floor[2**128 / 1 days]
2445     uint256 private MAX_TIMESTAMP = 3938453320844195178974243141571391;
2446 
2447     ////////////////////////
2448     // Constructor
2449     ////////////////////////
2450 
2451     /// @param start snapshotId from which to start generating values, used to prevent cloning from incompatible schemes
2452     /// @dev start must be for the same day or 0, required for token cloning
2453     constructor(uint256 start) internal {
2454         // 0 is invalid value as we are past unix epoch
2455         if (start > 0) {
2456             uint256 base = dayBase(uint128(block.timestamp));
2457             // must be within current day base
2458             require(start >= base);
2459             // dayBase + 2**128 will not overflow as it is based on block.timestamp
2460             require(start < base + 2**128);
2461         }
2462     }
2463 
2464     ////////////////////////
2465     // Public functions
2466     ////////////////////////
2467 
2468     function snapshotAt(uint256 timestamp)
2469         public
2470         constant
2471         returns (uint256)
2472     {
2473         require(timestamp < MAX_TIMESTAMP);
2474 
2475         return dayBase(uint128(timestamp));
2476     }
2477 
2478     ////////////////////////
2479     // Internal functions
2480     ////////////////////////
2481 
2482     //
2483     // Implements MSnapshotPolicy
2484     //
2485 
2486     function mAdvanceSnapshotId()
2487         internal
2488         returns (uint256)
2489     {
2490         return mCurrentSnapshotId();
2491     }
2492 
2493     function mCurrentSnapshotId()
2494         internal
2495         constant
2496         returns (uint256)
2497     {
2498         // disregard overflows on block.timestamp, see MAX_TIMESTAMP
2499         return dayBase(uint128(block.timestamp));
2500     }
2501 
2502     function dayBase(uint128 timestamp)
2503         internal
2504         pure
2505         returns (uint256)
2506     {
2507         // Round down to the start of the day (00:00 UTC) and place in higher 128bits
2508         return 2**128 * (uint256(timestamp) / 1 days);
2509     }
2510 }
2511 
2512 /// @title creates snapshot id on each day boundary and allows to create additional snapshots within a given day
2513 /// @dev snapshots are encoded in single uint256, where high 128 bits represents a day number (from unix epoch) and low 128 bits represents additional snapshots within given day create via ISnapshotable
2514 contract DailyAndSnapshotable is
2515     Daily,
2516     ISnapshotable
2517 {
2518 
2519     ////////////////////////
2520     // Mutable state
2521     ////////////////////////
2522 
2523     uint256 private _currentSnapshotId;
2524 
2525     ////////////////////////
2526     // Constructor
2527     ////////////////////////
2528 
2529     /// @param start snapshotId from which to start generating values
2530     /// @dev start must be for the same day or 0, required for token cloning
2531     constructor(uint256 start)
2532         internal
2533         Daily(start)
2534     {
2535         if (start > 0) {
2536             _currentSnapshotId = start;
2537         }
2538     }
2539 
2540     ////////////////////////
2541     // Public functions
2542     ////////////////////////
2543 
2544     //
2545     // Implements ISnapshotable
2546     //
2547 
2548     function createSnapshot()
2549         public
2550         returns (uint256)
2551     {
2552         uint256 base = dayBase(uint128(block.timestamp));
2553 
2554         if (base > _currentSnapshotId) {
2555             // New day has started, create snapshot for midnight
2556             _currentSnapshotId = base;
2557         } else {
2558             // within single day, increase counter (assume 2**128 will not be crossed)
2559             _currentSnapshotId += 1;
2560         }
2561 
2562         // Log and return
2563         emit LogSnapshotCreated(_currentSnapshotId);
2564         return _currentSnapshotId;
2565     }
2566 
2567     ////////////////////////
2568     // Internal functions
2569     ////////////////////////
2570 
2571     //
2572     // Implements MSnapshotPolicy
2573     //
2574 
2575     function mAdvanceSnapshotId()
2576         internal
2577         returns (uint256)
2578     {
2579         uint256 base = dayBase(uint128(block.timestamp));
2580 
2581         // New day has started
2582         if (base > _currentSnapshotId) {
2583             _currentSnapshotId = base;
2584             emit LogSnapshotCreated(base);
2585         }
2586 
2587         return _currentSnapshotId;
2588     }
2589 
2590     function mCurrentSnapshotId()
2591         internal
2592         constant
2593         returns (uint256)
2594     {
2595         uint256 base = dayBase(uint128(block.timestamp));
2596 
2597         return base > _currentSnapshotId ? base : _currentSnapshotId;
2598     }
2599 }
2600 
2601 /// @title Reads and writes snapshots
2602 /// @dev Manages reading and writing a series of values, where each value has assigned a snapshot id for access to historical data
2603 /// @dev may be added to any contract to provide snapshotting mechanism. should be mixed in with any of MSnapshotPolicy implementations to customize snapshot creation mechanics
2604 ///     observes MSnapshotPolicy
2605 /// based on MiniMe token
2606 contract Snapshot is MSnapshotPolicy {
2607 
2608     ////////////////////////
2609     // Types
2610     ////////////////////////
2611 
2612     /// @dev `Values` is the structure that attaches a snapshot id to a
2613     ///  given value, the snapshot id attached is the one that last changed the
2614     ///  value
2615     struct Values {
2616 
2617         // `snapshotId` is the snapshot id that the value was generated at
2618         uint256 snapshotId;
2619 
2620         // `value` at a specific snapshot id
2621         uint256 value;
2622     }
2623 
2624     ////////////////////////
2625     // Internal functions
2626     ////////////////////////
2627 
2628     function hasValue(
2629         Values[] storage values
2630     )
2631         internal
2632         constant
2633         returns (bool)
2634     {
2635         return values.length > 0;
2636     }
2637 
2638     /// @dev makes sure that 'snapshotId' between current snapshot id (mCurrentSnapshotId) and first snapshot id. this guarantees that getValueAt returns value from one of the snapshots.
2639     function hasValueAt(
2640         Values[] storage values,
2641         uint256 snapshotId
2642     )
2643         internal
2644         constant
2645         returns (bool)
2646     {
2647         require(snapshotId <= mCurrentSnapshotId());
2648         return values.length > 0 && values[0].snapshotId <= snapshotId;
2649     }
2650 
2651     /// gets last value in the series
2652     function getValue(
2653         Values[] storage values,
2654         uint256 defaultValue
2655     )
2656         internal
2657         constant
2658         returns (uint256)
2659     {
2660         if (values.length == 0) {
2661             return defaultValue;
2662         } else {
2663             uint256 last = values.length - 1;
2664             return values[last].value;
2665         }
2666     }
2667 
2668     /// @dev `getValueAt` retrieves value at a given snapshot id
2669     /// @param values The series of values being queried
2670     /// @param snapshotId Snapshot id to retrieve the value at
2671     /// @return Value in series being queried
2672     function getValueAt(
2673         Values[] storage values,
2674         uint256 snapshotId,
2675         uint256 defaultValue
2676     )
2677         internal
2678         constant
2679         returns (uint256)
2680     {
2681         require(snapshotId <= mCurrentSnapshotId());
2682 
2683         // Empty value
2684         if (values.length == 0) {
2685             return defaultValue;
2686         }
2687 
2688         // Shortcut for the out of bounds snapshots
2689         uint256 last = values.length - 1;
2690         uint256 lastSnapshot = values[last].snapshotId;
2691         if (snapshotId >= lastSnapshot) {
2692             return values[last].value;
2693         }
2694         uint256 firstSnapshot = values[0].snapshotId;
2695         if (snapshotId < firstSnapshot) {
2696             return defaultValue;
2697         }
2698         // Binary search of the value in the array
2699         uint256 min = 0;
2700         uint256 max = last;
2701         while (max > min) {
2702             uint256 mid = (max + min + 1) / 2;
2703             // must always return lower indice for approximate searches
2704             if (values[mid].snapshotId <= snapshotId) {
2705                 min = mid;
2706             } else {
2707                 max = mid - 1;
2708             }
2709         }
2710         return values[min].value;
2711     }
2712 
2713     /// @dev `setValue` used to update sequence at next snapshot
2714     /// @param values The sequence being updated
2715     /// @param value The new last value of sequence
2716     function setValue(
2717         Values[] storage values,
2718         uint256 value
2719     )
2720         internal
2721     {
2722         // TODO: simplify or break into smaller functions
2723 
2724         uint256 currentSnapshotId = mAdvanceSnapshotId();
2725         // Always create a new entry if there currently is no value
2726         bool empty = values.length == 0;
2727         if (empty) {
2728             // Create a new entry
2729             values.push(
2730                 Values({
2731                     snapshotId: currentSnapshotId,
2732                     value: value
2733                 })
2734             );
2735             return;
2736         }
2737 
2738         uint256 last = values.length - 1;
2739         bool hasNewSnapshot = values[last].snapshotId < currentSnapshotId;
2740         if (hasNewSnapshot) {
2741 
2742             // Do nothing if the value was not modified
2743             bool unmodified = values[last].value == value;
2744             if (unmodified) {
2745                 return;
2746             }
2747 
2748             // Create new entry
2749             values.push(
2750                 Values({
2751                     snapshotId: currentSnapshotId,
2752                     value: value
2753                 })
2754             );
2755         } else {
2756 
2757             // We are updating the currentSnapshotId
2758             bool previousUnmodified = last > 0 && values[last - 1].value == value;
2759             if (previousUnmodified) {
2760                 // Remove current snapshot if current value was set to previous value
2761                 delete values[last];
2762                 values.length--;
2763                 return;
2764             }
2765 
2766             // Overwrite next snapshot entry
2767             values[last].value = value;
2768         }
2769     }
2770 }
2771 
2772 /// @title access to snapshots of a token
2773 /// @notice allows to implement complex token holder rights like revenue disbursal or voting
2774 /// @notice snapshots are series of values with assigned ids. ids increase strictly. particular id mechanism is not assumed
2775 contract ITokenSnapshots {
2776 
2777     ////////////////////////
2778     // Public functions
2779     ////////////////////////
2780 
2781     /// @notice Total amount of tokens at a specific `snapshotId`.
2782     /// @param snapshotId of snapshot at which totalSupply is queried
2783     /// @return The total amount of tokens at `snapshotId`
2784     /// @dev reverts on snapshotIds greater than currentSnapshotId()
2785     /// @dev returns 0 for snapshotIds less than snapshotId of first value
2786     function totalSupplyAt(uint256 snapshotId)
2787         public
2788         constant
2789         returns(uint256);
2790 
2791     /// @dev Queries the balance of `owner` at a specific `snapshotId`
2792     /// @param owner The address from which the balance will be retrieved
2793     /// @param snapshotId of snapshot at which the balance is queried
2794     /// @return The balance at `snapshotId`
2795     function balanceOfAt(address owner, uint256 snapshotId)
2796         public
2797         constant
2798         returns (uint256);
2799 
2800     /// @notice upper bound of series of snapshotIds for which there's a value in series
2801     /// @return snapshotId
2802     function currentSnapshotId()
2803         public
2804         constant
2805         returns (uint256);
2806 }
2807 
2808 /// @title represents link between cloned and parent token
2809 /// @dev when token is clone from other token, initial balances of the cloned token
2810 ///     correspond to balances of parent token at the moment of parent snapshot id specified
2811 /// @notice please note that other tokens beside snapshot token may be cloned
2812 contract IClonedTokenParent is ITokenSnapshots {
2813 
2814     ////////////////////////
2815     // Public functions
2816     ////////////////////////
2817 
2818 
2819     /// @return address of parent token, address(0) if root
2820     /// @dev parent token does not need to clonable, nor snapshottable, just a normal token
2821     function parentToken()
2822         public
2823         constant
2824         returns(IClonedTokenParent parent);
2825 
2826     /// @return snapshot at wchich initial token distribution was taken
2827     function parentSnapshotId()
2828         public
2829         constant
2830         returns(uint256 snapshotId);
2831 }
2832 
2833 /// @title token with snapshots and transfer functionality
2834 /// @dev observes MTokenTransferController interface
2835 ///     observes ISnapshotToken interface
2836 ///     implementes MTokenTransfer interface
2837 contract BasicSnapshotToken is
2838     MTokenTransfer,
2839     MTokenTransferController,
2840     IClonedTokenParent,
2841     IBasicToken,
2842     Snapshot
2843 {
2844     ////////////////////////
2845     // Immutable state
2846     ////////////////////////
2847 
2848     // `PARENT_TOKEN` is the Token address that was cloned to produce this token;
2849     //  it will be 0x0 for a token that was not cloned
2850     IClonedTokenParent private PARENT_TOKEN;
2851 
2852     // `PARENT_SNAPSHOT_ID` is the snapshot id from the Parent Token that was
2853     //  used to determine the initial distribution of the cloned token
2854     uint256 private PARENT_SNAPSHOT_ID;
2855 
2856     ////////////////////////
2857     // Mutable state
2858     ////////////////////////
2859 
2860     // `balances` is the map that tracks the balance of each address, in this
2861     //  contract when the balance changes the snapshot id that the change
2862     //  occurred is also included in the map
2863     mapping (address => Values[]) internal _balances;
2864 
2865     // Tracks the history of the `totalSupply` of the token
2866     Values[] internal _totalSupplyValues;
2867 
2868     ////////////////////////
2869     // Constructor
2870     ////////////////////////
2871 
2872     /// @notice Constructor to create snapshot token
2873     /// @param parentToken Address of the parent token, set to 0x0 if it is a
2874     ///  new token
2875     /// @param parentSnapshotId at which snapshot id clone was created, set to 0 to clone at upper bound
2876     /// @dev please not that as long as cloned token does not overwrite value at current snapshot id, it will refer
2877     ///     to parent token at which this snapshot still may change until snapshot id increases. for that time tokens are coupled
2878     ///     this is prevented by parentSnapshotId value of parentToken.currentSnapshotId() - 1 being the maxiumum
2879     ///     see SnapshotToken.js test to learn consequences coupling has.
2880     constructor(
2881         IClonedTokenParent parentToken,
2882         uint256 parentSnapshotId
2883     )
2884         Snapshot()
2885         internal
2886     {
2887         PARENT_TOKEN = parentToken;
2888         if (parentToken == address(0)) {
2889             require(parentSnapshotId == 0);
2890         } else {
2891             if (parentSnapshotId == 0) {
2892                 require(parentToken.currentSnapshotId() > 0);
2893                 PARENT_SNAPSHOT_ID = parentToken.currentSnapshotId() - 1;
2894             } else {
2895                 PARENT_SNAPSHOT_ID = parentSnapshotId;
2896             }
2897         }
2898     }
2899 
2900     ////////////////////////
2901     // Public functions
2902     ////////////////////////
2903 
2904     //
2905     // Implements IBasicToken
2906     //
2907 
2908     /// @dev This function makes it easy to get the total number of tokens
2909     /// @return The total number of tokens
2910     function totalSupply()
2911         public
2912         constant
2913         returns (uint256)
2914     {
2915         return totalSupplyAtInternal(mCurrentSnapshotId());
2916     }
2917 
2918     /// @param owner The address that's balance is being requested
2919     /// @return The balance of `owner` at the current block
2920     function balanceOf(address owner)
2921         public
2922         constant
2923         returns (uint256 balance)
2924     {
2925         return balanceOfAtInternal(owner, mCurrentSnapshotId());
2926     }
2927 
2928     /// @notice Send `amount` tokens to `to` from `msg.sender`
2929     /// @param to The address of the recipient
2930     /// @param amount The amount of tokens to be transferred
2931     /// @return True if the transfer was successful, reverts in any other case
2932     function transfer(address to, uint256 amount)
2933         public
2934         returns (bool success)
2935     {
2936         mTransfer(msg.sender, to, amount);
2937         return true;
2938     }
2939 
2940     //
2941     // Implements ITokenSnapshots
2942     //
2943 
2944     function totalSupplyAt(uint256 snapshotId)
2945         public
2946         constant
2947         returns(uint256)
2948     {
2949         return totalSupplyAtInternal(snapshotId);
2950     }
2951 
2952     function balanceOfAt(address owner, uint256 snapshotId)
2953         public
2954         constant
2955         returns (uint256)
2956     {
2957         return balanceOfAtInternal(owner, snapshotId);
2958     }
2959 
2960     function currentSnapshotId()
2961         public
2962         constant
2963         returns (uint256)
2964     {
2965         return mCurrentSnapshotId();
2966     }
2967 
2968     //
2969     // Implements IClonedTokenParent
2970     //
2971 
2972     function parentToken()
2973         public
2974         constant
2975         returns(IClonedTokenParent parent)
2976     {
2977         return PARENT_TOKEN;
2978     }
2979 
2980     /// @return snapshot at wchich initial token distribution was taken
2981     function parentSnapshotId()
2982         public
2983         constant
2984         returns(uint256 snapshotId)
2985     {
2986         return PARENT_SNAPSHOT_ID;
2987     }
2988 
2989     //
2990     // Other public functions
2991     //
2992 
2993     /// @notice gets all token balances of 'owner'
2994     /// @dev intended to be called via eth_call where gas limit is not an issue
2995     function allBalancesOf(address owner)
2996         external
2997         constant
2998         returns (uint256[2][])
2999     {
3000         /* very nice and working implementation below,
3001         // copy to memory
3002         Values[] memory values = _balances[owner];
3003         do assembly {
3004             // in memory structs have simple layout where every item occupies uint256
3005             balances := values
3006         } while (false);*/
3007 
3008         Values[] storage values = _balances[owner];
3009         uint256[2][] memory balances = new uint256[2][](values.length);
3010         for(uint256 ii = 0; ii < values.length; ++ii) {
3011             balances[ii] = [values[ii].snapshotId, values[ii].value];
3012         }
3013 
3014         return balances;
3015     }
3016 
3017     ////////////////////////
3018     // Internal functions
3019     ////////////////////////
3020 
3021     function totalSupplyAtInternal(uint256 snapshotId)
3022         internal
3023         constant
3024         returns(uint256)
3025     {
3026         Values[] storage values = _totalSupplyValues;
3027 
3028         // If there is a value, return it, reverts if value is in the future
3029         if (hasValueAt(values, snapshotId)) {
3030             return getValueAt(values, snapshotId, 0);
3031         }
3032 
3033         // Try parent contract at or before the fork
3034         if (address(PARENT_TOKEN) != 0) {
3035             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
3036             return PARENT_TOKEN.totalSupplyAt(earlierSnapshotId);
3037         }
3038 
3039         // Default to an empty balance
3040         return 0;
3041     }
3042 
3043     // get balance at snapshot if with continuation in parent token
3044     function balanceOfAtInternal(address owner, uint256 snapshotId)
3045         internal
3046         constant
3047         returns (uint256)
3048     {
3049         Values[] storage values = _balances[owner];
3050 
3051         // If there is a value, return it, reverts if value is in the future
3052         if (hasValueAt(values, snapshotId)) {
3053             return getValueAt(values, snapshotId, 0);
3054         }
3055 
3056         // Try parent contract at or before the fork
3057         if (PARENT_TOKEN != address(0)) {
3058             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
3059             return PARENT_TOKEN.balanceOfAt(owner, earlierSnapshotId);
3060         }
3061 
3062         // Default to an empty balance
3063         return 0;
3064     }
3065 
3066     //
3067     // Implements MTokenTransfer
3068     //
3069 
3070     /// @dev This is the actual transfer function in the token contract, it can
3071     ///  only be called by other functions in this contract.
3072     /// @param from The address holding the tokens being transferred
3073     /// @param to The address of the recipient
3074     /// @param amount The amount of tokens to be transferred
3075     /// @return True if the transfer was successful, reverts in any other case
3076     function mTransfer(
3077         address from,
3078         address to,
3079         uint256 amount
3080     )
3081         internal
3082     {
3083         // never send to address 0
3084         require(to != address(0));
3085         // block transfers in clone that points to future/current snapshots of parent token
3086         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
3087         // Alerts the token controller of the transfer
3088         require(mOnTransfer(from, to, amount));
3089 
3090         // If the amount being transfered is more than the balance of the
3091         //  account the transfer reverts
3092         uint256 previousBalanceFrom = balanceOf(from);
3093         require(previousBalanceFrom >= amount);
3094 
3095         // First update the balance array with the new value for the address
3096         //  sending the tokens
3097         uint256 newBalanceFrom = previousBalanceFrom - amount;
3098         setValue(_balances[from], newBalanceFrom);
3099 
3100         // Then update the balance array with the new value for the address
3101         //  receiving the tokens
3102         uint256 previousBalanceTo = balanceOf(to);
3103         uint256 newBalanceTo = previousBalanceTo + amount;
3104         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
3105         setValue(_balances[to], newBalanceTo);
3106 
3107         // An event to make the transfer easy to find on the blockchain
3108         emit Transfer(from, to, amount);
3109     }
3110 }
3111 
3112 /// @title token generation and destruction
3113 /// @dev internal interface providing token generation and destruction, see MintableSnapshotToken for implementation
3114 contract MTokenMint {
3115 
3116     ////////////////////////
3117     // Internal functions
3118     ////////////////////////
3119 
3120     /// @notice Generates `amount` tokens that are assigned to `owner`
3121     /// @param owner The address that will be assigned the new tokens
3122     /// @param amount The quantity of tokens generated
3123     /// @dev reverts if tokens could not be generated
3124     function mGenerateTokens(address owner, uint256 amount)
3125         internal;
3126 
3127     /// @notice Burns `amount` tokens from `owner`
3128     /// @param owner The address that will lose the tokens
3129     /// @param amount The quantity of tokens to burn
3130     /// @dev reverts if tokens could not be destroyed
3131     function mDestroyTokens(address owner, uint256 amount)
3132         internal;
3133 }
3134 
3135 /// @title basic snapshot token with facitilites to generate and destroy tokens
3136 /// @dev implementes MTokenMint, does not expose any public functions that create/destroy tokens
3137 contract MintableSnapshotToken is
3138     BasicSnapshotToken,
3139     MTokenMint
3140 {
3141 
3142     ////////////////////////
3143     // Constructor
3144     ////////////////////////
3145 
3146     /// @notice Constructor to create a MintableSnapshotToken
3147     /// @param parentToken Address of the parent token, set to 0x0 if it is a
3148     ///  new token
3149     constructor(
3150         IClonedTokenParent parentToken,
3151         uint256 parentSnapshotId
3152     )
3153         BasicSnapshotToken(parentToken, parentSnapshotId)
3154         internal
3155     {}
3156 
3157     /// @notice Generates `amount` tokens that are assigned to `owner`
3158     /// @param owner The address that will be assigned the new tokens
3159     /// @param amount The quantity of tokens generated
3160     function mGenerateTokens(address owner, uint256 amount)
3161         internal
3162     {
3163         // never create for address 0
3164         require(owner != address(0));
3165         // block changes in clone that points to future/current snapshots of patent token
3166         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
3167 
3168         uint256 curTotalSupply = totalSupply();
3169         uint256 newTotalSupply = curTotalSupply + amount;
3170         require(newTotalSupply >= curTotalSupply); // Check for overflow
3171 
3172         uint256 previousBalanceTo = balanceOf(owner);
3173         uint256 newBalanceTo = previousBalanceTo + amount;
3174         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
3175 
3176         setValue(_totalSupplyValues, newTotalSupply);
3177         setValue(_balances[owner], newBalanceTo);
3178 
3179         emit Transfer(0, owner, amount);
3180     }
3181 
3182     /// @notice Burns `amount` tokens from `owner`
3183     /// @param owner The address that will lose the tokens
3184     /// @param amount The quantity of tokens to burn
3185     function mDestroyTokens(address owner, uint256 amount)
3186         internal
3187     {
3188         // block changes in clone that points to future/current snapshots of patent token
3189         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
3190 
3191         uint256 curTotalSupply = totalSupply();
3192         require(curTotalSupply >= amount);
3193 
3194         uint256 previousBalanceFrom = balanceOf(owner);
3195         require(previousBalanceFrom >= amount);
3196 
3197         uint256 newTotalSupply = curTotalSupply - amount;
3198         uint256 newBalanceFrom = previousBalanceFrom - amount;
3199         setValue(_totalSupplyValues, newTotalSupply);
3200         setValue(_balances[owner], newBalanceFrom);
3201 
3202         emit Transfer(owner, 0, amount);
3203     }
3204 }
3205 
3206 /*
3207     Copyright 2016, Jordi Baylina
3208     Copyright 2017, Remco Bloemen, Marcin Rudolf
3209 
3210     This program is free software: you can redistribute it and/or modify
3211     it under the terms of the GNU General Public License as published by
3212     the Free Software Foundation, either version 3 of the License, or
3213     (at your option) any later version.
3214 
3215     This program is distributed in the hope that it will be useful,
3216     but WITHOUT ANY WARRANTY; without even the implied warranty of
3217     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
3218     GNU General Public License for more details.
3219 
3220     You should have received a copy of the GNU General Public License
3221     along with this program.  If not, see <http://www.gnu.org/licenses/>.
3222  */
3223 /// @title StandardSnapshotToken Contract
3224 /// @author Jordi Baylina, Remco Bloemen, Marcin Rudolf
3225 /// @dev This token contract's goal is to make it easy for anyone to clone this
3226 ///  token using the token distribution at a given block, this will allow DAO's
3227 ///  and DApps to upgrade their features in a decentralized manner without
3228 ///  affecting the original token
3229 /// @dev It is ERC20 compliant, but still needs to under go further testing.
3230 /// @dev Various contracts are composed to provide required functionality of this token, different compositions are possible
3231 ///     MintableSnapshotToken provides transfer, miniting and snapshotting functions
3232 ///     TokenAllowance provides approve/transferFrom functions
3233 ///     TokenMetadata adds name, symbol and other token metadata
3234 /// @dev This token is still abstract, Snapshot, BasicSnapshotToken and TokenAllowance observe interfaces that must be implemented
3235 ///     MSnapshotPolicy - particular snapshot id creation mechanism
3236 ///     MTokenController - controlls approvals and transfers
3237 ///     see Neumark as an example
3238 /// @dev implements ERC223 token transfer
3239 contract StandardSnapshotToken is
3240     MintableSnapshotToken,
3241     TokenAllowance
3242 {
3243     ////////////////////////
3244     // Constructor
3245     ////////////////////////
3246 
3247     /// @notice Constructor to create a MiniMeToken
3248     ///  is a new token
3249     /// param tokenName Name of the new token
3250     /// param decimalUnits Number of decimals of the new token
3251     /// param tokenSymbol Token Symbol for the new token
3252     constructor(
3253         IClonedTokenParent parentToken,
3254         uint256 parentSnapshotId
3255     )
3256         MintableSnapshotToken(parentToken, parentSnapshotId)
3257         TokenAllowance()
3258         internal
3259     {}
3260 }
3261 
3262 /// @title old ERC223 callback function
3263 /// @dev as used in Neumark and ICBMEtherToken
3264 contract IERC223LegacyCallback {
3265 
3266     ////////////////////////
3267     // Public functions
3268     ////////////////////////
3269 
3270     function onTokenTransfer(address from, uint256 amount, bytes data)
3271         public;
3272 
3273 }
3274 
3275 contract Neumark is
3276     AccessControlled,
3277     AccessRoles,
3278     Agreement,
3279     DailyAndSnapshotable,
3280     StandardSnapshotToken,
3281     TokenMetadata,
3282     IERC223Token,
3283     NeumarkIssuanceCurve,
3284     Reclaimable,
3285     IsContract
3286 {
3287 
3288     ////////////////////////
3289     // Constants
3290     ////////////////////////
3291 
3292     string private constant TOKEN_NAME = "Neumark";
3293 
3294     uint8  private constant TOKEN_DECIMALS = 18;
3295 
3296     string private constant TOKEN_SYMBOL = "NEU";
3297 
3298     string private constant VERSION = "NMK_1.0";
3299 
3300     ////////////////////////
3301     // Mutable state
3302     ////////////////////////
3303 
3304     // disable transfers when Neumark is created
3305     bool private _transferEnabled = false;
3306 
3307     // at which point on curve new Neumarks will be created, see NeumarkIssuanceCurve contract
3308     // do not use to get total invested funds. see burn(). this is just a cache for expensive inverse function
3309     uint256 private _totalEurUlps;
3310 
3311     ////////////////////////
3312     // Events
3313     ////////////////////////
3314 
3315     event LogNeumarksIssued(
3316         address indexed owner,
3317         uint256 euroUlps,
3318         uint256 neumarkUlps
3319     );
3320 
3321     event LogNeumarksBurned(
3322         address indexed owner,
3323         uint256 euroUlps,
3324         uint256 neumarkUlps
3325     );
3326 
3327     ////////////////////////
3328     // Constructor
3329     ////////////////////////
3330 
3331     constructor(
3332         IAccessPolicy accessPolicy,
3333         IEthereumForkArbiter forkArbiter
3334     )
3335         AccessRoles()
3336         Agreement(accessPolicy, forkArbiter)
3337         StandardSnapshotToken(
3338             IClonedTokenParent(0x0),
3339             0
3340         )
3341         TokenMetadata(
3342             TOKEN_NAME,
3343             TOKEN_DECIMALS,
3344             TOKEN_SYMBOL,
3345             VERSION
3346         )
3347         DailyAndSnapshotable(0)
3348         NeumarkIssuanceCurve()
3349         Reclaimable()
3350         public
3351     {}
3352 
3353     ////////////////////////
3354     // Public functions
3355     ////////////////////////
3356 
3357     /// @notice issues new Neumarks to msg.sender with reward at current curve position
3358     ///     moves curve position by euroUlps
3359     ///     callable only by ROLE_NEUMARK_ISSUER
3360     function issueForEuro(uint256 euroUlps)
3361         public
3362         only(ROLE_NEUMARK_ISSUER)
3363         acceptAgreement(msg.sender)
3364         returns (uint256)
3365     {
3366         require(_totalEurUlps + euroUlps >= _totalEurUlps);
3367         uint256 neumarkUlps = incremental(_totalEurUlps, euroUlps);
3368         _totalEurUlps += euroUlps;
3369         mGenerateTokens(msg.sender, neumarkUlps);
3370         emit LogNeumarksIssued(msg.sender, euroUlps, neumarkUlps);
3371         return neumarkUlps;
3372     }
3373 
3374     /// @notice used by ROLE_NEUMARK_ISSUER to transer newly issued neumarks
3375     ///     typically to the investor and platform operator
3376     function distribute(address to, uint256 neumarkUlps)
3377         public
3378         only(ROLE_NEUMARK_ISSUER)
3379         acceptAgreement(to)
3380     {
3381         mTransfer(msg.sender, to, neumarkUlps);
3382     }
3383 
3384     /// @notice msg.sender can burn their Neumarks, curve is rolled back using inverse
3385     ///     curve. as a result cost of Neumark gets lower (reward is higher)
3386     function burn(uint256 neumarkUlps)
3387         public
3388         only(ROLE_NEUMARK_BURNER)
3389     {
3390         burnPrivate(neumarkUlps, 0, _totalEurUlps);
3391     }
3392 
3393     /// @notice executes as function above but allows to provide search range for low gas burning
3394     function burn(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
3395         public
3396         only(ROLE_NEUMARK_BURNER)
3397     {
3398         burnPrivate(neumarkUlps, minEurUlps, maxEurUlps);
3399     }
3400 
3401     function enableTransfer(bool enabled)
3402         public
3403         only(ROLE_TRANSFER_ADMIN)
3404     {
3405         _transferEnabled = enabled;
3406     }
3407 
3408     function createSnapshot()
3409         public
3410         only(ROLE_SNAPSHOT_CREATOR)
3411         returns (uint256)
3412     {
3413         return DailyAndSnapshotable.createSnapshot();
3414     }
3415 
3416     function transferEnabled()
3417         public
3418         constant
3419         returns (bool)
3420     {
3421         return _transferEnabled;
3422     }
3423 
3424     function totalEuroUlps()
3425         public
3426         constant
3427         returns (uint256)
3428     {
3429         return _totalEurUlps;
3430     }
3431 
3432     function incremental(uint256 euroUlps)
3433         public
3434         constant
3435         returns (uint256 neumarkUlps)
3436     {
3437         return incremental(_totalEurUlps, euroUlps);
3438     }
3439 
3440     //
3441     // Implements IERC223Token with IERC223Callback (onTokenTransfer) callback
3442     //
3443 
3444     // old implementation of ERC223 that was actual when ICBM was deployed
3445     // as Neumark is already deployed this function keeps old behavior for testing
3446     function transfer(address to, uint256 amount, bytes data)
3447         public
3448         returns (bool)
3449     {
3450         // it is necessary to point out implementation to be called
3451         BasicSnapshotToken.mTransfer(msg.sender, to, amount);
3452 
3453         // Notify the receiving contract.
3454         if (isContract(to)) {
3455             IERC223LegacyCallback(to).onTokenTransfer(msg.sender, amount, data);
3456         }
3457         return true;
3458     }
3459 
3460     ////////////////////////
3461     // Internal functions
3462     ////////////////////////
3463 
3464     //
3465     // Implements MTokenController
3466     //
3467 
3468     function mOnTransfer(
3469         address from,
3470         address, // to
3471         uint256 // amount
3472     )
3473         internal
3474         acceptAgreement(from)
3475         returns (bool allow)
3476     {
3477         // must have transfer enabled or msg.sender is Neumark issuer
3478         return _transferEnabled || accessPolicy().allowed(msg.sender, ROLE_NEUMARK_ISSUER, this, msg.sig);
3479     }
3480 
3481     function mOnApprove(
3482         address owner,
3483         address, // spender,
3484         uint256 // amount
3485     )
3486         internal
3487         acceptAgreement(owner)
3488         returns (bool allow)
3489     {
3490         return true;
3491     }
3492 
3493     ////////////////////////
3494     // Private functions
3495     ////////////////////////
3496 
3497     function burnPrivate(uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
3498         private
3499     {
3500         uint256 prevEuroUlps = _totalEurUlps;
3501         // burn first in the token to make sure balance/totalSupply is not crossed
3502         mDestroyTokens(msg.sender, burnNeumarkUlps);
3503         _totalEurUlps = cumulativeInverse(totalSupply(), minEurUlps, maxEurUlps);
3504         // actually may overflow on non-monotonic inverse
3505         assert(prevEuroUlps >= _totalEurUlps);
3506         uint256 euroUlps = prevEuroUlps - _totalEurUlps;
3507         emit LogNeumarksBurned(msg.sender, euroUlps, burnNeumarkUlps);
3508     }
3509 }
3510 
3511 /// @title disburse payment token amount to snapshot token holders
3512 /// @dev payment token received via ERC223 Transfer
3513 contract IFeeDisbursal is IERC223Callback {
3514     // TODO: declare interface
3515 }
3516 
3517 /// @title disburse payment token amount to snapshot token holders
3518 /// @dev payment token received via ERC223 Transfer
3519 contract IPlatformPortfolio is IERC223Callback {
3520     // TODO: declare interface
3521 }
3522 
3523 contract ITokenExchangeRateOracle {
3524     /// @notice provides actual price of 'numeratorToken' in 'denominatorToken'
3525     ///     returns timestamp at which price was obtained in oracle
3526     function getExchangeRate(address numeratorToken, address denominatorToken)
3527         public
3528         constant
3529         returns (uint256 rateFraction, uint256 timestamp);
3530 
3531     /// @notice allows to retreive multiple exchange rates in once call
3532     function getExchangeRates(address[] numeratorTokens, address[] denominatorTokens)
3533         public
3534         constant
3535         returns (uint256[] rateFractions, uint256[] timestamps);
3536 }
3537 
3538 /// @title root of trust and singletons + known interface registry
3539 /// provides a root which holds all interfaces platform trust, this includes
3540 /// singletons - for which accessors are provided
3541 /// collections of known instances of interfaces
3542 /// @dev interfaces are identified by bytes4, see KnownInterfaces.sol
3543 contract Universe is
3544     Agreement,
3545     IContractId,
3546     KnownInterfaces
3547 {
3548     ////////////////////////
3549     // Events
3550     ////////////////////////
3551 
3552     /// raised on any change of singleton instance
3553     /// @dev for convenience we provide previous instance of singleton in replacedInstance
3554     event LogSetSingleton(
3555         bytes4 interfaceId,
3556         address instance,
3557         address replacedInstance
3558     );
3559 
3560     /// raised on add/remove interface instance in collection
3561     event LogSetCollectionInterface(
3562         bytes4 interfaceId,
3563         address instance,
3564         bool isSet
3565     );
3566 
3567     ////////////////////////
3568     // Mutable state
3569     ////////////////////////
3570 
3571     // mapping of known contracts to addresses of singletons
3572     mapping(bytes4 => address) private _singletons;
3573 
3574     // mapping of known interfaces to collections of contracts
3575     mapping(bytes4 =>
3576         mapping(address => bool)) private _collections; // solium-disable-line indentation
3577 
3578     // known instances
3579     mapping(address => bytes4[]) private _instances;
3580 
3581 
3582     ////////////////////////
3583     // Constructor
3584     ////////////////////////
3585 
3586     constructor(
3587         IAccessPolicy accessPolicy,
3588         IEthereumForkArbiter forkArbiter
3589     )
3590         Agreement(accessPolicy, forkArbiter)
3591         public
3592     {
3593         setSingletonPrivate(KNOWN_INTERFACE_ACCESS_POLICY, accessPolicy);
3594         setSingletonPrivate(KNOWN_INTERFACE_FORK_ARBITER, forkArbiter);
3595     }
3596 
3597     ////////////////////////
3598     // Public methods
3599     ////////////////////////
3600 
3601     /// get singleton instance for 'interfaceId'
3602     function getSingleton(bytes4 interfaceId)
3603         public
3604         constant
3605         returns (address)
3606     {
3607         return _singletons[interfaceId];
3608     }
3609 
3610     function getManySingletons(bytes4[] interfaceIds)
3611         public
3612         constant
3613         returns (address[])
3614     {
3615         address[] memory addresses = new address[](interfaceIds.length);
3616         uint256 idx;
3617         while(idx < interfaceIds.length) {
3618             addresses[idx] = _singletons[interfaceIds[idx]];
3619             idx += 1;
3620         }
3621         return addresses;
3622     }
3623 
3624     /// checks of 'instance' is instance of interface 'interfaceId'
3625     function isSingleton(bytes4 interfaceId, address instance)
3626         public
3627         constant
3628         returns (bool)
3629     {
3630         return _singletons[interfaceId] == instance;
3631     }
3632 
3633     /// checks if 'instance' is one of instances of 'interfaceId'
3634     function isInterfaceCollectionInstance(bytes4 interfaceId, address instance)
3635         public
3636         constant
3637         returns (bool)
3638     {
3639         return _collections[interfaceId][instance];
3640     }
3641 
3642     function isAnyOfInterfaceCollectionInstance(bytes4[] interfaceIds, address instance)
3643         public
3644         constant
3645         returns (bool)
3646     {
3647         uint256 idx;
3648         while(idx < interfaceIds.length) {
3649             if (_collections[interfaceIds[idx]][instance]) {
3650                 return true;
3651             }
3652             idx += 1;
3653         }
3654         return false;
3655     }
3656 
3657     /// gets all interfaces of given instance
3658     function getInterfacesOfInstance(address instance)
3659         public
3660         constant
3661         returns (bytes4[] interfaces)
3662     {
3663         return _instances[instance];
3664     }
3665 
3666     /// sets 'instance' of singleton with interface 'interfaceId'
3667     function setSingleton(bytes4 interfaceId, address instance)
3668         public
3669         only(ROLE_UNIVERSE_MANAGER)
3670     {
3671         setSingletonPrivate(interfaceId, instance);
3672     }
3673 
3674     /// convenience method for setting many singleton instances
3675     function setManySingletons(bytes4[] interfaceIds, address[] instances)
3676         public
3677         only(ROLE_UNIVERSE_MANAGER)
3678     {
3679         require(interfaceIds.length == instances.length);
3680         uint256 idx;
3681         while(idx < interfaceIds.length) {
3682             setSingletonPrivate(interfaceIds[idx], instances[idx]);
3683             idx += 1;
3684         }
3685     }
3686 
3687     /// set or unset 'instance' with 'interfaceId' in collection of instances
3688     function setCollectionInterface(bytes4 interfaceId, address instance, bool set)
3689         public
3690         only(ROLE_UNIVERSE_MANAGER)
3691     {
3692         setCollectionPrivate(interfaceId, instance, set);
3693     }
3694 
3695     /// set or unset 'instance' in many collections of instances
3696     function setInterfaceInManyCollections(bytes4[] interfaceIds, address instance, bool set)
3697         public
3698         only(ROLE_UNIVERSE_MANAGER)
3699     {
3700         uint256 idx;
3701         while(idx < interfaceIds.length) {
3702             setCollectionPrivate(interfaceIds[idx], instance, set);
3703             idx += 1;
3704         }
3705     }
3706 
3707     /// set or unset array of collection
3708     function setCollectionsInterfaces(bytes4[] interfaceIds, address[] instances, bool[] set_flags)
3709         public
3710         only(ROLE_UNIVERSE_MANAGER)
3711     {
3712         require(interfaceIds.length == instances.length);
3713         require(interfaceIds.length == set_flags.length);
3714         uint256 idx;
3715         while(idx < interfaceIds.length) {
3716             setCollectionPrivate(interfaceIds[idx], instances[idx], set_flags[idx]);
3717             idx += 1;
3718         }
3719     }
3720 
3721     //
3722     // Implements IContractId
3723     //
3724 
3725     function contractId() public pure returns (bytes32 id, uint256 version) {
3726         return (0x8b57bfe21a3ef4854e19d702063b6cea03fa514162f8ff43fde551f06372fefd, 0);
3727     }
3728 
3729     ////////////////////////
3730     // Getters
3731     ////////////////////////
3732 
3733     function accessPolicy() public constant returns (IAccessPolicy) {
3734         return IAccessPolicy(_singletons[KNOWN_INTERFACE_ACCESS_POLICY]);
3735     }
3736 
3737     function forkArbiter() public constant returns (IEthereumForkArbiter) {
3738         return IEthereumForkArbiter(_singletons[KNOWN_INTERFACE_FORK_ARBITER]);
3739     }
3740 
3741     function neumark() public constant returns (Neumark) {
3742         return Neumark(_singletons[KNOWN_INTERFACE_NEUMARK]);
3743     }
3744 
3745     function etherToken() public constant returns (IERC223Token) {
3746         return IERC223Token(_singletons[KNOWN_INTERFACE_ETHER_TOKEN]);
3747     }
3748 
3749     function euroToken() public constant returns (IERC223Token) {
3750         return IERC223Token(_singletons[KNOWN_INTERFACE_EURO_TOKEN]);
3751     }
3752 
3753     function etherLock() public constant returns (address) {
3754         return _singletons[KNOWN_INTERFACE_ETHER_LOCK];
3755     }
3756 
3757     function euroLock() public constant returns (address) {
3758         return _singletons[KNOWN_INTERFACE_EURO_LOCK];
3759     }
3760 
3761     function icbmEtherLock() public constant returns (address) {
3762         return _singletons[KNOWN_INTERFACE_ICBM_ETHER_LOCK];
3763     }
3764 
3765     function icbmEuroLock() public constant returns (address) {
3766         return _singletons[KNOWN_INTERFACE_ICBM_EURO_LOCK];
3767     }
3768 
3769     function identityRegistry() public constant returns (address) {
3770         return IIdentityRegistry(_singletons[KNOWN_INTERFACE_IDENTITY_REGISTRY]);
3771     }
3772 
3773     function tokenExchangeRateOracle() public constant returns (address) {
3774         return ITokenExchangeRateOracle(_singletons[KNOWN_INTERFACE_TOKEN_EXCHANGE_RATE_ORACLE]);
3775     }
3776 
3777     function feeDisbursal() public constant returns (address) {
3778         return IFeeDisbursal(_singletons[KNOWN_INTERFACE_FEE_DISBURSAL]);
3779     }
3780 
3781     function platformPortfolio() public constant returns (address) {
3782         return IPlatformPortfolio(_singletons[KNOWN_INTERFACE_PLATFORM_PORTFOLIO]);
3783     }
3784 
3785     function tokenExchange() public constant returns (address) {
3786         return _singletons[KNOWN_INTERFACE_TOKEN_EXCHANGE];
3787     }
3788 
3789     function gasExchange() public constant returns (address) {
3790         return _singletons[KNOWN_INTERFACE_GAS_EXCHANGE];
3791     }
3792 
3793     function platformTerms() public constant returns (address) {
3794         return _singletons[KNOWN_INTERFACE_PLATFORM_TERMS];
3795     }
3796 
3797     ////////////////////////
3798     // Private methods
3799     ////////////////////////
3800 
3801     function setSingletonPrivate(bytes4 interfaceId, address instance)
3802         private
3803     {
3804         require(interfaceId != KNOWN_INTERFACE_UNIVERSE, "NF_UNI_NO_UNIVERSE_SINGLETON");
3805         address replacedInstance = _singletons[interfaceId];
3806         // do nothing if not changing
3807         if (replacedInstance != instance) {
3808             dropInstance(replacedInstance, interfaceId);
3809             addInstance(instance, interfaceId);
3810             _singletons[interfaceId] = instance;
3811         }
3812 
3813         emit LogSetSingleton(interfaceId, instance, replacedInstance);
3814     }
3815 
3816     function setCollectionPrivate(bytes4 interfaceId, address instance, bool set)
3817         private
3818     {
3819         // do nothing if not changing
3820         if (_collections[interfaceId][instance] == set) {
3821             return;
3822         }
3823         _collections[interfaceId][instance] = set;
3824         if (set) {
3825             addInstance(instance, interfaceId);
3826         } else {
3827             dropInstance(instance, interfaceId);
3828         }
3829         emit LogSetCollectionInterface(interfaceId, instance, set);
3830     }
3831 
3832     function addInstance(address instance, bytes4 interfaceId)
3833         private
3834     {
3835         if (instance == address(0)) {
3836             // do not add null instance
3837             return;
3838         }
3839         bytes4[] storage current = _instances[instance];
3840         uint256 idx;
3841         while(idx < current.length) {
3842             // instancy has this interface already, do nothing
3843             if (current[idx] == interfaceId)
3844                 return;
3845             idx += 1;
3846         }
3847         // new interface
3848         current.push(interfaceId);
3849     }
3850 
3851     function dropInstance(address instance, bytes4 interfaceId)
3852         private
3853     {
3854         if (instance == address(0)) {
3855             // do not drop null instance
3856             return;
3857         }
3858         bytes4[] storage current = _instances[instance];
3859         uint256 idx;
3860         uint256 last = current.length - 1;
3861         while(idx <= last) {
3862             if (current[idx] == interfaceId) {
3863                 // delete element
3864                 if (idx < last) {
3865                     // if not last element move last element to idx being deleted
3866                     current[idx] = current[last];
3867                 }
3868                 // delete last element
3869                 current.length -= 1;
3870                 return;
3871             }
3872             idx += 1;
3873         }
3874     }
3875 }
3876 
3877 /// @notice mixin that enables contract to receive migration
3878 /// @dev when derived from
3879 contract MigrationTarget is
3880     IMigrationTarget
3881 {
3882     ////////////////////////
3883     // Modifiers
3884     ////////////////////////
3885 
3886     // intended to be applied on migration receiving function
3887     modifier onlyMigrationSource() {
3888         require(msg.sender == currentMigrationSource(), "NF_INV_SOURCE");
3889         _;
3890     }
3891 }
3892 
3893 /// @notice implemented in the contract that is the target of LockedAccount migration
3894 ///  migration process is removing investors balance from source LockedAccount fully
3895 ///  target should re-create investor with the same balance, totalLockedAmount and totalInvestors are invariant during migration
3896 contract ICBMLockedAccountMigration is
3897     MigrationTarget
3898 {
3899     ////////////////////////
3900     // Public functions
3901     ////////////////////////
3902 
3903     // implemented in migration target, apply `onlyMigrationSource()` modifier, modifiers are not inherited
3904     function migrateInvestor(
3905         address investor,
3906         uint256 balance,
3907         uint256 neumarksDue,
3908         uint256 unlockDate
3909     )
3910         public;
3911 
3912 }
3913 
3914 /// @title standard access roles of the Platform
3915 /// @dev constants are kept in CODE not in STORAGE so they are comparatively cheap
3916 contract ICBMRoles {
3917 
3918     ////////////////////////
3919     // Constants
3920     ////////////////////////
3921 
3922     // NOTE: All roles are set to the keccak256 hash of the
3923     // CamelCased role name, i.e.
3924     // ROLE_LOCKED_ACCOUNT_ADMIN = keccak256("LockedAccountAdmin")
3925 
3926     // may setup LockedAccount, change disbursal mechanism and set migration
3927     bytes32 internal constant ROLE_LOCKED_ACCOUNT_ADMIN = 0x4675da546d2d92c5b86c4f726a9e61010dce91cccc2491ce6019e78b09d2572e;
3928 
3929     // may setup whitelists and abort whitelisting contract with curve rollback
3930     bytes32 internal constant ROLE_WHITELIST_ADMIN = 0xaef456e7c864418e1d2a40d996ca4febf3a7e317fe3af5a7ea4dda59033bbe5c;
3931 }
3932 
3933 contract TimeSource {
3934 
3935     ////////////////////////
3936     // Internal functions
3937     ////////////////////////
3938 
3939     function currentTime() internal constant returns (uint256) {
3940         return block.timestamp;
3941     }
3942 }
3943 
3944 contract ICBMLockedAccount is
3945     AccessControlled,
3946     ICBMRoles,
3947     TimeSource,
3948     Math,
3949     IsContract,
3950     MigrationSource,
3951     IERC677Callback,
3952     Reclaimable
3953 {
3954 
3955     ////////////////////////
3956     // Type declarations
3957     ////////////////////////
3958 
3959     // state space of LockedAccount
3960     enum LockState {
3961         // controller is not yet set
3962         Uncontrolled,
3963         // new funds lockd are accepted from investors
3964         AcceptingLocks,
3965         // funds may be unlocked by investors, final state
3966         AcceptingUnlocks,
3967         // funds may be unlocked by investors, without any constraints, final state
3968         ReleaseAll
3969     }
3970 
3971     // represents locked account of the investor
3972     struct Account {
3973         // funds locked in the account
3974         uint256 balance;
3975         // neumark amount that must be returned to unlock
3976         uint256 neumarksDue;
3977         // date with which unlock may happen without penalty
3978         uint256 unlockDate;
3979     }
3980 
3981     ////////////////////////
3982     // Immutable state
3983     ////////////////////////
3984 
3985     // a token controlled by LockedAccount, read ERC20 + extensions to read what
3986     // token is it (ETH/EUR etc.)
3987     IERC677Token private ASSET_TOKEN;
3988 
3989     Neumark private NEUMARK;
3990 
3991     // longstop period in seconds
3992     uint256 private LOCK_PERIOD;
3993 
3994     // penalty: decimalFraction of stored amount on escape hatch
3995     uint256 private PENALTY_FRACTION;
3996 
3997     ////////////////////////
3998     // Mutable state
3999     ////////////////////////
4000 
4001     // total amount of tokens locked
4002     uint256 private _totalLockedAmount;
4003 
4004     // total number of locked investors
4005     uint256 internal _totalInvestors;
4006 
4007     // current state of the locking contract
4008     LockState private _lockState;
4009 
4010     // controlling contract that may lock money or unlock all account if fails
4011     address private _controller;
4012 
4013     // fee distribution pool
4014     address private _penaltyDisbursalAddress;
4015 
4016     // LockedAccountMigration private migration;
4017     mapping(address => Account) internal _accounts;
4018 
4019     ////////////////////////
4020     // Events
4021     ////////////////////////
4022 
4023     /// @notice logged when funds are locked by investor
4024     /// @param investor address of investor locking funds
4025     /// @param amount amount of newly locked funds
4026     /// @param amount of neumarks that must be returned to unlock funds
4027     event LogFundsLocked(
4028         address indexed investor,
4029         uint256 amount,
4030         uint256 neumarks
4031     );
4032 
4033     /// @notice logged when investor unlocks funds
4034     /// @param investor address of investor unlocking funds
4035     /// @param amount amount of unlocked funds
4036     /// @param neumarks amount of Neumarks that was burned
4037     event LogFundsUnlocked(
4038         address indexed investor,
4039         uint256 amount,
4040         uint256 neumarks
4041     );
4042 
4043     /// @notice logged when unlock penalty is disbursed to Neumark holders
4044     /// @param disbursalPoolAddress address of disbursal pool receiving penalty
4045     /// @param amount penalty amount
4046     /// @param assetToken address of token contract penalty was paid with
4047     /// @param investor addres of investor paying penalty
4048     /// @dev assetToken and investor parameters are added for quick tallying penalty payouts
4049     event LogPenaltyDisbursed(
4050         address indexed disbursalPoolAddress,
4051         uint256 amount,
4052         address assetToken,
4053         address investor
4054     );
4055 
4056     /// @notice logs Locked Account state transitions
4057     event LogLockStateTransition(
4058         LockState oldState,
4059         LockState newState
4060     );
4061 
4062     event LogInvestorMigrated(
4063         address indexed investor,
4064         uint256 amount,
4065         uint256 neumarks,
4066         uint256 unlockDate
4067     );
4068 
4069     ////////////////////////
4070     // Modifiers
4071     ////////////////////////
4072 
4073     modifier onlyController() {
4074         require(msg.sender == address(_controller));
4075         _;
4076     }
4077 
4078     modifier onlyState(LockState state) {
4079         require(_lockState == state);
4080         _;
4081     }
4082 
4083     modifier onlyStates(LockState state1, LockState state2) {
4084         require(_lockState == state1 || _lockState == state2);
4085         _;
4086     }
4087 
4088     ////////////////////////
4089     // Constructor
4090     ////////////////////////
4091 
4092     /// @notice creates new LockedAccount instance
4093     /// @param policy governs execution permissions to admin functions
4094     /// @param assetToken token contract representing funds locked
4095     /// @param neumark Neumark token contract
4096     /// @param penaltyDisbursalAddress address of disbursal contract for penalty fees
4097     /// @param lockPeriod period for which funds are locked, in seconds
4098     /// @param penaltyFraction decimal fraction of unlocked amount paid as penalty,
4099     ///     if unlocked before lockPeriod is over
4100     /// @dev this implementation does not allow spending funds on ICOs but provides
4101     ///     a migration mechanism to final LockedAccount with such functionality
4102     constructor(
4103         IAccessPolicy policy,
4104         IERC677Token assetToken,
4105         Neumark neumark,
4106         address penaltyDisbursalAddress,
4107         uint256 lockPeriod,
4108         uint256 penaltyFraction
4109     )
4110         MigrationSource(policy, ROLE_LOCKED_ACCOUNT_ADMIN)
4111         Reclaimable()
4112         public
4113     {
4114         ASSET_TOKEN = assetToken;
4115         NEUMARK = neumark;
4116         LOCK_PERIOD = lockPeriod;
4117         PENALTY_FRACTION = penaltyFraction;
4118         _penaltyDisbursalAddress = penaltyDisbursalAddress;
4119     }
4120 
4121     ////////////////////////
4122     // Public functions
4123     ////////////////////////
4124 
4125     /// @notice locks funds of investors for a period of time
4126     /// @param investor funds owner
4127     /// @param amount amount of funds locked
4128     /// @param neumarks amount of neumarks that needs to be returned by investor to unlock funds
4129     /// @dev callable only from controller (Commitment) contract
4130     function lock(address investor, uint256 amount, uint256 neumarks)
4131         public
4132         onlyState(LockState.AcceptingLocks)
4133         onlyController()
4134     {
4135         require(amount > 0);
4136         // transfer to itself from Commitment contract allowance
4137         assert(ASSET_TOKEN.transferFrom(msg.sender, address(this), amount));
4138 
4139         Account storage account = _accounts[investor];
4140         account.balance = addBalance(account.balance, amount);
4141         account.neumarksDue = add(account.neumarksDue, neumarks);
4142 
4143         if (account.unlockDate == 0) {
4144             // this is new account - unlockDate always > 0
4145             _totalInvestors += 1;
4146             account.unlockDate = currentTime() + LOCK_PERIOD;
4147         }
4148         emit LogFundsLocked(investor, amount, neumarks);
4149     }
4150 
4151     /// @notice unlocks investors funds, see unlockInvestor for details
4152     /// @dev function requires that proper allowance on Neumark is made to LockedAccount by msg.sender
4153     ///     except in ReleaseAll state which does not burn Neumark
4154     function unlock()
4155         public
4156         onlyStates(LockState.AcceptingUnlocks, LockState.ReleaseAll)
4157     {
4158         unlockInvestor(msg.sender);
4159     }
4160 
4161     /// @notice unlocks investors funds, see unlockInvestor for details
4162     /// @dev this ERC667 callback by Neumark contract after successful approve
4163     ///     allows to unlock and allow neumarks to be burned in one transaction
4164     function receiveApproval(
4165         address from,
4166         uint256, // _amount,
4167         address _token,
4168         bytes _data
4169     )
4170         public
4171         onlyState(LockState.AcceptingUnlocks)
4172         returns (bool)
4173     {
4174         require(msg.sender == _token);
4175         require(_data.length == 0);
4176 
4177         // only from neumarks
4178         require(_token == address(NEUMARK));
4179 
4180         // this will check if allowance was made and if _amount is enough to
4181         //  unlock, reverts on any error condition
4182         unlockInvestor(from);
4183 
4184         // we assume external call so return value will be lost to clients
4185         // that's why we throw above
4186         return true;
4187     }
4188 
4189     /// allows to anyone to release all funds without burning Neumarks and any
4190     /// other penalties
4191     function controllerFailed()
4192         public
4193         onlyState(LockState.AcceptingLocks)
4194         onlyController()
4195     {
4196         changeState(LockState.ReleaseAll);
4197     }
4198 
4199     /// allows anyone to use escape hatch
4200     function controllerSucceeded()
4201         public
4202         onlyState(LockState.AcceptingLocks)
4203         onlyController()
4204     {
4205         changeState(LockState.AcceptingUnlocks);
4206     }
4207 
4208     function setController(address controller)
4209         public
4210         only(ROLE_LOCKED_ACCOUNT_ADMIN)
4211         onlyState(LockState.Uncontrolled)
4212     {
4213         _controller = controller;
4214         changeState(LockState.AcceptingLocks);
4215     }
4216 
4217     /// sets address to which tokens from unlock penalty are sent
4218     /// both simple addresses and contracts are allowed
4219     /// contract needs to implement ApproveAndCallCallback interface
4220     function setPenaltyDisbursal(address penaltyDisbursalAddress)
4221         public
4222         only(ROLE_LOCKED_ACCOUNT_ADMIN)
4223     {
4224         require(penaltyDisbursalAddress != address(0));
4225 
4226         // can be changed at any moment by admin
4227         _penaltyDisbursalAddress = penaltyDisbursalAddress;
4228     }
4229 
4230     function assetToken()
4231         public
4232         constant
4233         returns (IERC677Token)
4234     {
4235         return ASSET_TOKEN;
4236     }
4237 
4238     function neumark()
4239         public
4240         constant
4241         returns (Neumark)
4242     {
4243         return NEUMARK;
4244     }
4245 
4246     function lockPeriod()
4247         public
4248         constant
4249         returns (uint256)
4250     {
4251         return LOCK_PERIOD;
4252     }
4253 
4254     function penaltyFraction()
4255         public
4256         constant
4257         returns (uint256)
4258     {
4259         return PENALTY_FRACTION;
4260     }
4261 
4262     function balanceOf(address investor)
4263         public
4264         constant
4265         returns (uint256, uint256, uint256)
4266     {
4267         Account storage account = _accounts[investor];
4268         return (account.balance, account.neumarksDue, account.unlockDate);
4269     }
4270 
4271     function controller()
4272         public
4273         constant
4274         returns (address)
4275     {
4276         return _controller;
4277     }
4278 
4279     function lockState()
4280         public
4281         constant
4282         returns (LockState)
4283     {
4284         return _lockState;
4285     }
4286 
4287     function totalLockedAmount()
4288         public
4289         constant
4290         returns (uint256)
4291     {
4292         return _totalLockedAmount;
4293     }
4294 
4295     function totalInvestors()
4296         public
4297         constant
4298         returns (uint256)
4299     {
4300         return _totalInvestors;
4301     }
4302 
4303     function penaltyDisbursalAddress()
4304         public
4305         constant
4306         returns (address)
4307     {
4308         return _penaltyDisbursalAddress;
4309     }
4310 
4311     //
4312     // Overrides migration source
4313     //
4314 
4315     /// enables migration to new LockedAccount instance
4316     /// it can be set only once to prevent setting temporary migrations that let
4317     /// just one investor out
4318     /// may be set in AcceptingLocks state (in unlikely event that controller
4319     /// fails we let investors out)
4320     /// and AcceptingUnlocks - which is normal operational mode
4321     function enableMigration(IMigrationTarget migration)
4322         public
4323         onlyStates(LockState.AcceptingLocks, LockState.AcceptingUnlocks)
4324     {
4325         // will enforce other access controls
4326         MigrationSource.enableMigration(migration);
4327     }
4328 
4329     /// migrates single investor
4330     function migrate()
4331         public
4332         onlyMigrationEnabled()
4333     {
4334         // migrates
4335         Account memory account = _accounts[msg.sender];
4336 
4337         // return on non existing accounts silently
4338         if (account.balance == 0) {
4339             return;
4340         }
4341 
4342         // this will clear investor storage
4343         removeInvestor(msg.sender, account.balance);
4344 
4345         // let migration target to own asset balance that belongs to investor
4346         assert(ASSET_TOKEN.approve(address(_migration), account.balance));
4347         ICBMLockedAccountMigration(_migration).migrateInvestor(
4348             msg.sender,
4349             account.balance,
4350             account.neumarksDue,
4351             account.unlockDate
4352         );
4353         emit LogInvestorMigrated(msg.sender, account.balance, account.neumarksDue, account.unlockDate);
4354     }
4355 
4356     //
4357     // Overrides Reclaimable
4358     //
4359 
4360     /// @notice allows LockedAccount to reclaim tokens wrongly sent to its address
4361     /// @dev as LockedAccount by design has balance of assetToken (in the name of investors)
4362     ///     such reclamation is not allowed
4363     function reclaim(IBasicToken token)
4364         public
4365     {
4366         // forbid reclaiming locked tokens
4367         require(token != ASSET_TOKEN);
4368         Reclaimable.reclaim(token);
4369     }
4370 
4371     ////////////////////////
4372     // Internal functions
4373     ////////////////////////
4374 
4375     function addBalance(uint256 balance, uint256 amount)
4376         internal
4377         returns (uint256)
4378     {
4379         _totalLockedAmount = add(_totalLockedAmount, amount);
4380         uint256 newBalance = balance + amount;
4381         return newBalance;
4382     }
4383 
4384     ////////////////////////
4385     // Private functions
4386     ////////////////////////
4387 
4388     function subBalance(uint256 balance, uint256 amount)
4389         private
4390         returns (uint256)
4391     {
4392         _totalLockedAmount -= amount;
4393         return balance - amount;
4394     }
4395 
4396     function removeInvestor(address investor, uint256 balance)
4397         private
4398     {
4399         subBalance(balance, balance);
4400         _totalInvestors -= 1;
4401         delete _accounts[investor];
4402     }
4403 
4404     function changeState(LockState newState)
4405         private
4406     {
4407         assert(newState != _lockState);
4408         emit LogLockStateTransition(_lockState, newState);
4409         _lockState = newState;
4410     }
4411 
4412     /// @notice unlocks 'investor' tokens by making them withdrawable from assetToken
4413     /// @dev expects number of neumarks that is due on investor's account to be approved for LockedAccount for transfer
4414     /// @dev there are 3 unlock modes depending on contract and investor state
4415     ///     in 'AcceptingUnlocks' state Neumarks due will be burned and funds transferred to investors address in assetToken,
4416     ///         before unlockDate, penalty is deduced and distributed
4417     ///     in 'ReleaseAll' neumarks are not burned and unlockDate is not observed, funds are unlocked unconditionally
4418     function unlockInvestor(address investor)
4419         private
4420     {
4421         // use memory storage to obtain copy and be able to erase storage
4422         Account memory accountInMem = _accounts[investor];
4423 
4424         // silently return on non-existing accounts
4425         if (accountInMem.balance == 0) {
4426             return;
4427         }
4428         // remove investor account before external calls
4429         removeInvestor(investor, accountInMem.balance);
4430 
4431         // Neumark burning and penalty processing only in AcceptingUnlocks state
4432         if (_lockState == LockState.AcceptingUnlocks) {
4433             // transfer Neumarks to be burned to itself via allowance mechanism
4434             //  not enough allowance results in revert which is acceptable state so 'require' is used
4435             require(NEUMARK.transferFrom(investor, address(this), accountInMem.neumarksDue));
4436 
4437             // burn neumarks corresponding to unspent funds
4438             NEUMARK.burn(accountInMem.neumarksDue);
4439 
4440             // take the penalty if before unlockDate
4441             if (currentTime() < accountInMem.unlockDate) {
4442                 require(_penaltyDisbursalAddress != address(0));
4443                 uint256 penalty = decimalFraction(accountInMem.balance, PENALTY_FRACTION);
4444 
4445                 // distribute penalty
4446                 if (isContract(_penaltyDisbursalAddress)) {
4447                     require(
4448                         ASSET_TOKEN.approveAndCall(_penaltyDisbursalAddress, penalty, "")
4449                     );
4450                 } else {
4451                     // transfer to simple address
4452                     assert(ASSET_TOKEN.transfer(_penaltyDisbursalAddress, penalty));
4453                 }
4454                 emit LogPenaltyDisbursed(_penaltyDisbursalAddress, penalty, ASSET_TOKEN, investor);
4455                 accountInMem.balance -= penalty;
4456             }
4457         }
4458         if (_lockState == LockState.ReleaseAll) {
4459             accountInMem.neumarksDue = 0;
4460         }
4461         // transfer amount back to investor - now it can withdraw
4462         assert(ASSET_TOKEN.transfer(investor, accountInMem.balance));
4463         emit LogFundsUnlocked(investor, accountInMem.balance, accountInMem.neumarksDue);
4464     }
4465 }
4466 
4467 contract LockedAccount is
4468     Agreement,
4469     Math,
4470     Serialization,
4471     ICBMLockedAccountMigration,
4472     IdentityRecord,
4473     KnownInterfaces,
4474     Reclaimable,
4475     IContractId
4476 {
4477     ////////////////////////
4478     // Type declarations
4479     ////////////////////////
4480 
4481     /// represents locked account of the investor
4482     struct Account {
4483         // funds locked in the account
4484         uint112 balance;
4485         // neumark amount that must be returned to unlock
4486         uint112 neumarksDue;
4487         // date with which unlock may happen without penalty
4488         uint32 unlockDate;
4489     }
4490 
4491     /// represents account migration destination
4492     /// @notice migration destinations require KYC when being set
4493     /// @dev used to setup migration to different wallet if for some reason investors
4494     ///   wants to use different wallet in the Platform than ICBM.
4495     /// @dev it also allows to split the tickets, neumarks due will be split proportionally
4496     struct Destination {
4497         // destination wallet
4498         address investor;
4499         // amount to be migrated to wallet above. 0 means all funds
4500         uint112 amount;
4501     }
4502 
4503     ////////////////////////
4504     // Immutable state
4505     ////////////////////////
4506 
4507     // token that stores investors' funds
4508     IERC223Token private PAYMENT_TOKEN;
4509 
4510     Neumark private NEUMARK;
4511 
4512     // longstop period in seconds
4513     uint256 private LOCK_PERIOD;
4514 
4515     // penalty: decimalFraction of stored amount on escape hatch
4516     uint256 private PENALTY_FRACTION;
4517 
4518     // interface registry
4519     Universe private UNIVERSE;
4520 
4521     // icbm locked account which is migration source
4522     ICBMLockedAccount private MIGRATION_SOURCE;
4523 
4524     // old payment token
4525     IERC677Token private OLD_PAYMENT_TOKEN;
4526 
4527     ////////////////////////
4528     // Mutable state
4529     ////////////////////////
4530 
4531     // total amount of tokens locked
4532     uint112 private _totalLockedAmount;
4533 
4534     // total number of locked investors
4535     uint256 internal _totalInvestors;
4536 
4537     // all accounts
4538     mapping(address => Account) internal _accounts;
4539 
4540     // tracks investment to be able to control refunds (commitment => investor => account)
4541     mapping(address => mapping(address => Account)) internal _commitments;
4542 
4543     // account migration destinations
4544     mapping(address => Destination[]) private _destinations;
4545 
4546     ////////////////////////
4547     // Events
4548     ////////////////////////
4549 
4550     /// @notice logged when funds are committed to token offering
4551     /// @param investor address
4552     /// @param commitment commitment contract where funds were sent
4553     /// @param amount amount of invested funds
4554     /// @param amount of corresponging Neumarks that successful offering will "unlock"
4555     event LogFundsCommitted(
4556         address indexed investor,
4557         address indexed commitment,
4558         uint256 amount,
4559         uint256 neumarks
4560     );
4561 
4562     /// @notice logged when investor unlocks funds
4563     /// @param investor address of investor unlocking funds
4564     /// @param amount amount of unlocked funds
4565     /// @param neumarks amount of Neumarks that was burned
4566     event LogFundsUnlocked(
4567         address indexed investor,
4568         uint256 amount,
4569         uint256 neumarks
4570     );
4571 
4572     /// @notice logged when investor account is migrated
4573     /// @param investor address receiving the migration
4574     /// @param amount amount of newly migrated funds
4575     /// @param amount of neumarks that must be returned to unlock funds
4576     event LogFundsLocked(
4577         address indexed investor,
4578         uint256 amount,
4579         uint256 neumarks
4580     );
4581 
4582     /// @notice logged when investor funds/obligations moved to different address
4583     /// @param oldInvestor current address
4584     /// @param newInvestor destination address
4585     /// @dev see move function for comments
4586     /*event LogInvestorMoved(
4587         address indexed oldInvestor,
4588         address indexed newInvestor
4589     );*/
4590 
4591     /// @notice logged when funds are locked as a refund by commitment contract
4592     /// @param investor address of refunded investor
4593     /// @param commitment commitment contract sending the refund
4594     /// @param amount refund amount
4595     /// @param amount of neumarks corresponding to the refund
4596     event LogFundsRefunded(
4597         address indexed investor,
4598         address indexed commitment,
4599         uint256 amount,
4600         uint256 neumarks
4601     );
4602 
4603     /// @notice logged when unlock penalty is disbursed to Neumark holders
4604     /// @param disbursalPoolAddress address of disbursal pool receiving penalty
4605     /// @param amount penalty amount
4606     /// @param paymentToken address of token contract penalty was paid with
4607     /// @param investor addres of investor paying penalty
4608     /// @dev paymentToken and investor parameters are added for quick tallying penalty payouts
4609     event LogPenaltyDisbursed(
4610         address indexed disbursalPoolAddress,
4611         address indexed investor,
4612         uint256 amount,
4613         address paymentToken
4614     );
4615 
4616     /// @notice logged when migration destination is set for an investor
4617     event LogMigrationDestination(
4618         address indexed investor,
4619         address indexed destination,
4620         uint256 amount
4621     );
4622 
4623     ////////////////////////
4624     // Modifiers
4625     ////////////////////////
4626 
4627     modifier onlyIfCommitment(address commitment) {
4628         // is allowed token offering
4629         require(UNIVERSE.isInterfaceCollectionInstance(KNOWN_INTERFACE_COMMITMENT, commitment), "NF_LOCKED_ONLY_COMMITMENT");
4630         _;
4631     }
4632 
4633     ////////////////////////
4634     // Constructor
4635     ////////////////////////
4636 
4637     /// @notice creates new LockedAccount instance
4638     /// @param universe provides interface and identity registries
4639     /// @param paymentToken token contract representing funds locked
4640     /// @param migrationSource old locked account
4641     constructor(
4642         Universe universe,
4643         Neumark neumark,
4644         IERC223Token paymentToken,
4645         ICBMLockedAccount migrationSource
4646     )
4647         Agreement(universe.accessPolicy(), universe.forkArbiter())
4648         Reclaimable()
4649         public
4650     {
4651         PAYMENT_TOKEN = paymentToken;
4652         MIGRATION_SOURCE = migrationSource;
4653         OLD_PAYMENT_TOKEN = MIGRATION_SOURCE.assetToken();
4654         UNIVERSE = universe;
4655         NEUMARK = neumark;
4656         LOCK_PERIOD = migrationSource.lockPeriod();
4657         PENALTY_FRACTION = migrationSource.penaltyFraction();
4658         // this is not super sexy but it's very practical against attaching ETH wallet to EUR wallet
4659         // we decrease chances of migration lethal setup errors in non migrated wallets
4660         require(keccak256(abi.encodePacked(ITokenMetadata(OLD_PAYMENT_TOKEN).symbol())) == keccak256(abi.encodePacked(PAYMENT_TOKEN.symbol())));
4661     }
4662 
4663     ////////////////////////
4664     // Public functions
4665     ////////////////////////
4666 
4667     /// @notice commits funds in one of offerings on the platform
4668     /// @param commitment commitment contract with token offering
4669     /// @param amount amount of funds to invest
4670     /// @dev data ignored, to keep compatibility with ERC223
4671     /// @dev happens via ERC223 transfer and callback
4672     function transfer(address commitment, uint256 amount, bytes /*data*/)
4673         public
4674         onlyIfCommitment(commitment)
4675     {
4676         require(amount > 0, "NF_LOCKED_NO_ZERO");
4677         Account storage account = _accounts[msg.sender];
4678         // no overflow with account.balance which is uint112
4679         require(account.balance >= amount, "NF_LOCKED_NO_FUNDS");
4680         // calculate unlocked NEU as proportion of invested amount to account balance
4681         uint112 unlockedNmkUlps = uint112(
4682             proportion(
4683                 account.neumarksDue,
4684                 amount,
4685                 account.balance
4686             )
4687         );
4688         account.balance = subBalance(account.balance, uint112(amount));
4689         // will not overflow as amount < account.balance so unlockedNmkUlps must be >= account.neumarksDue
4690         account.neumarksDue -= unlockedNmkUlps;
4691         // track investment
4692         Account storage investment = _commitments[address(commitment)][msg.sender];
4693         investment.balance += uint112(amount);
4694         investment.neumarksDue += unlockedNmkUlps;
4695         // invest via ERC223 interface
4696         assert(PAYMENT_TOKEN.transfer(commitment, amount, abi.encodePacked(msg.sender)));
4697         emit LogFundsCommitted(msg.sender, commitment, amount, unlockedNmkUlps);
4698     }
4699 
4700     /// @notice unlocks investors funds, see unlockInvestor for details
4701     /// @dev function requires that proper allowance on Neumark is made to LockedAccount by msg.sender
4702     ///     except in ReleaseAll state which does not burn Neumark
4703     function unlock()
4704         public
4705     {
4706         unlockInvestor(msg.sender);
4707     }
4708 
4709     /// @notice unlocks investors funds, see unlockInvestor for details
4710     /// @dev this ERC667 callback by Neumark contract after successful approve
4711     ///     allows to unlock and allow neumarks to be burned in one transaction
4712     function receiveApproval(address from, uint256, address _token, bytes _data)
4713         public
4714         returns (bool)
4715     {
4716         require(msg.sender == _token);
4717         require(_data.length == 0);
4718         // only from neumarks
4719         require(_token == address(NEUMARK), "NF_ONLY_NEU");
4720         // this will check if allowance was made and if _amount is enough to
4721         //  unlock, reverts on any error condition
4722         unlockInvestor(from);
4723         return true;
4724     }
4725 
4726     /// @notice refunds investor in case of failed offering
4727     /// @param investor funds owner
4728     /// @dev callable only by ETO contract, bookkeeping in LockedAccount::_commitments
4729     /// @dev expected that ETO makes allowance for transferFrom
4730     function refunded(address investor)
4731         public
4732     {
4733         Account memory investment = _commitments[msg.sender][investor];
4734         // return silently when there is no refund (so commitment contracts can blank-call, less gas used)
4735         if (investment.balance == 0)
4736             return;
4737         // free gas here
4738         delete _commitments[msg.sender][investor];
4739         Account storage account = _accounts[investor];
4740         // account must exist
4741         require(account.unlockDate > 0, "NF_LOCKED_ACCOUNT_LIQUIDATED");
4742         // add refunded amount
4743         account.balance = addBalance(account.balance, investment.balance);
4744         account.neumarksDue = add112(account.neumarksDue, investment.neumarksDue);
4745         // transfer to itself from Commitment contract allowance
4746         assert(PAYMENT_TOKEN.transferFrom(msg.sender, address(this), investment.balance));
4747         emit LogFundsRefunded(investor, msg.sender, investment.balance, investment.neumarksDue);
4748     }
4749 
4750     /// @notice may be used by commitment contract to refund gas for commitment bookkeeping
4751     /// @dev https://gastoken.io/ (15000 - 900 for a call)
4752     function claimed(address investor) public {
4753         delete _commitments[msg.sender][investor];
4754     }
4755 
4756     /// checks commitments made from locked account that were not settled by ETO via refunded or claimed functions
4757     function pendingCommitments(address commitment, address investor)
4758         public
4759         constant
4760         returns (uint256 balance, uint256 neumarkDue)
4761     {
4762         Account storage i = _commitments[commitment][investor];
4763         return (i.balance, i.neumarksDue);
4764     }
4765 
4766     //
4767     // Implements LockedAccountMigrationTarget
4768     //
4769 
4770     function migrateInvestor(
4771         address investor,
4772         uint256 balance256,
4773         uint256 neumarksDue256,
4774         uint256 unlockDate256
4775     )
4776         public
4777         onlyMigrationSource()
4778     {
4779         // internally we use 112 bits to store amounts
4780         require(balance256 < 2**112, "NF_OVR");
4781         uint112 balance = uint112(balance256);
4782         assert(neumarksDue256 < 2**112);
4783         uint112 neumarksDue = uint112(neumarksDue256);
4784         assert(unlockDate256 < 2**32);
4785         uint32 unlockDate = uint32(unlockDate256);
4786 
4787         // transfer assets
4788         require(OLD_PAYMENT_TOKEN.transferFrom(msg.sender, address(this), balance));
4789         IWithdrawableToken(OLD_PAYMENT_TOKEN).withdraw(balance);
4790         // migrate previous asset token depends on token type, unfortunatelly deposit function differs so we have to cast. this is weak...
4791         if (PAYMENT_TOKEN == UNIVERSE.etherToken()) {
4792             // after EtherToken withdraw, deposit ether into new token
4793             EtherToken(PAYMENT_TOKEN).deposit.value(balance)();
4794         } else {
4795             EuroToken(PAYMENT_TOKEN).deposit(this, balance, 0x0);
4796         }
4797         Destination[] storage destinations = _destinations[investor];
4798         if (destinations.length == 0) {
4799             // if no destinations defined then migrate to original investor wallet
4800             lock(investor, balance, neumarksDue, unlockDate);
4801         } else {
4802             // enumerate all destinations and migrate balance piece by piece
4803             uint256 idx;
4804             while(idx < destinations.length) {
4805                 Destination storage destination = destinations[idx];
4806                 // get partial amount to migrate, if 0 specified then take all, as a result 0 must be the last destination
4807                 uint112 partialAmount = destination.amount == 0 ? balance : destination.amount;
4808                 require(partialAmount <= balance, "NF_LOCKED_ACCOUNT_SPLIT_OVERSPENT");
4809                 // compute corresponding NEU proportionally, result < 10**18 as partialAmount <= balance
4810                 uint112 partialNmkUlps = uint112(
4811                     proportion(
4812                         neumarksDue,
4813                         partialAmount,
4814                         balance
4815                     )
4816                 );
4817                 // no overflow see above
4818                 balance -= partialAmount;
4819                 // no overflow partialNmkUlps <= neumarksDue as as partialAmount <= balance, see proportion
4820                 neumarksDue -= partialNmkUlps;
4821                 // lock partial to destination investor
4822                 lock(destination.investor, partialAmount, partialNmkUlps, unlockDate);
4823                 idx += 1;
4824             }
4825             // all funds and NEU must be migrated
4826             require(balance == 0, "NF_LOCKED_ACCOUNT_SPLIT_UNDERSPENT");
4827             assert(neumarksDue == 0);
4828             // free up gas
4829             delete _destinations[investor];
4830         }
4831     }
4832 
4833     /// @notice changes migration destination for msg.sender
4834     /// @param destinationWallet where migrate funds to, must have valid verification claims
4835     /// @dev msg.sender has funds in old icbm wallet and calls this function on new icbm wallet before s/he migrates
4836     function setInvestorMigrationWallet(address destinationWallet)
4837         public
4838     {
4839         Destination[] storage destinations = _destinations[msg.sender];
4840         // delete old destinations
4841         if(destinations.length > 0) {
4842             delete _destinations[msg.sender];
4843         }
4844         // new destination for the whole amount
4845         addDestination(destinations, destinationWallet, 0);
4846     }
4847 
4848     /// @dev if one of amounts is > 2**112, solidity will pass modulo value, so for 2**112 + 1, we'll get 1
4849     ///      and that's fine
4850     function setInvestorMigrationWallets(address[] wallets, uint112[] amounts)
4851         public
4852     {
4853         require(wallets.length == amounts.length);
4854         Destination[] storage destinations = _destinations[msg.sender];
4855         // delete old destinations
4856         if(destinations.length > 0) {
4857             delete _destinations[msg.sender];
4858         }
4859         uint256 idx;
4860         while(idx < wallets.length) {
4861             addDestination(destinations, wallets[idx], amounts[idx]);
4862             idx += 1;
4863         }
4864     }
4865 
4866     /// @notice returns current set of destination wallets for investor migration
4867     function getInvestorMigrationWallets(address investor)
4868         public
4869         constant
4870         returns (address[] wallets, uint112[] amounts)
4871     {
4872         Destination[] storage destinations = _destinations[investor];
4873         wallets = new address[](destinations.length);
4874         amounts = new uint112[](destinations.length);
4875         uint256 idx;
4876         while(idx < destinations.length) {
4877             wallets[idx] = destinations[idx].investor;
4878             amounts[idx] = destinations[idx].amount;
4879             idx += 1;
4880         }
4881     }
4882 
4883     //
4884     // Implements IMigrationTarget
4885     //
4886 
4887     function currentMigrationSource()
4888         public
4889         constant
4890         returns (address)
4891     {
4892         return address(MIGRATION_SOURCE);
4893     }
4894 
4895     //
4896     // Implements IContractId
4897     //
4898 
4899     function contractId() public pure returns (bytes32 id, uint256 version) {
4900         return (0x15fbe12e85e3698f22c35480f7c66bc38590bb8cfe18cbd6dc3d49355670e561, 0);
4901     }
4902 
4903     //
4904     // Payable default function to receive ether during migration
4905     //
4906     function ()
4907         public
4908         payable
4909     {
4910         require(msg.sender == address(OLD_PAYMENT_TOKEN));
4911     }
4912 
4913     //
4914     // Overrides Reclaimable
4915     //
4916 
4917     /// @notice allows LockedAccount to reclaim tokens wrongly sent to its address
4918     /// @dev as LockedAccount by design has balance of paymentToken (in the name of investors)
4919     ///     such reclamation is not allowed
4920     function reclaim(IBasicToken token)
4921         public
4922     {
4923         // forbid reclaiming locked tokens
4924         require(token != PAYMENT_TOKEN, "NO_PAYMENT_TOKEN_RECLAIM");
4925         Reclaimable.reclaim(token);
4926     }
4927 
4928     //
4929     // Public accessors
4930     //
4931 
4932     function paymentToken()
4933         public
4934         constant
4935         returns (IERC223Token)
4936     {
4937         return PAYMENT_TOKEN;
4938     }
4939 
4940     function neumark()
4941         public
4942         constant
4943         returns (Neumark)
4944     {
4945         return NEUMARK;
4946     }
4947 
4948     function lockPeriod()
4949         public
4950         constant
4951         returns (uint256)
4952     {
4953         return LOCK_PERIOD;
4954     }
4955 
4956     function penaltyFraction()
4957         public
4958         constant
4959         returns (uint256)
4960     {
4961         return PENALTY_FRACTION;
4962     }
4963 
4964     function balanceOf(address investor)
4965         public
4966         constant
4967         returns (uint256 balance, uint256 neumarksDue, uint32 unlockDate)
4968     {
4969         Account storage account = _accounts[investor];
4970         return (account.balance, account.neumarksDue, account.unlockDate);
4971     }
4972 
4973     function totalLockedAmount()
4974         public
4975         constant
4976         returns (uint256)
4977     {
4978         return _totalLockedAmount;
4979     }
4980 
4981     function totalInvestors()
4982         public
4983         constant
4984         returns (uint256)
4985     {
4986         return _totalInvestors;
4987     }
4988 
4989     ////////////////////////
4990     // Internal functions
4991     ////////////////////////
4992 
4993     function addBalance(uint112 balance, uint112 amount)
4994         internal
4995         returns (uint112)
4996     {
4997         _totalLockedAmount = add112(_totalLockedAmount, amount);
4998         // will not overflow as _totalLockedAmount >= balance
4999         return balance + amount;
5000     }
5001 
5002     ////////////////////////
5003     // Private functions
5004     ////////////////////////
5005 
5006     function subBalance(uint112 balance, uint112 amount)
5007         private
5008         returns (uint112)
5009     {
5010         _totalLockedAmount = sub112(_totalLockedAmount, amount);
5011         return sub112(balance, amount);
5012     }
5013 
5014     function removeInvestor(address investor, uint112 balance)
5015         private
5016     {
5017         subBalance(balance, balance);
5018         _totalInvestors -= 1;
5019         delete _accounts[investor];
5020     }
5021 
5022     /// @notice unlocks 'investor' tokens by making them withdrawable from paymentToken
5023     /// @dev expects number of neumarks that is due on investor's account to be approved for LockedAccount for transfer
5024     /// @dev there are 3 unlock modes depending on contract and investor state
5025     ///     in 'AcceptingUnlocks' state Neumarks due will be burned and funds transferred to investors address in paymentToken,
5026     ///         before unlockDate, penalty is deduced and distributed
5027     function unlockInvestor(address investor)
5028         private
5029     {
5030         // use memory storage to obtain copy and be able to erase storage
5031         Account memory accountInMem = _accounts[investor];
5032 
5033         // silently return on non-existing accounts
5034         if (accountInMem.balance == 0) {
5035             return;
5036         }
5037         // remove investor account before external calls
5038         removeInvestor(investor, accountInMem.balance);
5039 
5040         // transfer Neumarks to be burned to itself via allowance mechanism
5041         //  not enough allowance results in revert which is acceptable state so 'require' is used
5042         require(NEUMARK.transferFrom(investor, address(this), accountInMem.neumarksDue));
5043 
5044         // burn neumarks corresponding to unspent funds
5045         NEUMARK.burn(accountInMem.neumarksDue);
5046 
5047         // take the penalty if before unlockDate
5048         if (block.timestamp < accountInMem.unlockDate) {
5049             address penaltyDisbursalAddress = UNIVERSE.feeDisbursal();
5050             require(penaltyDisbursalAddress != address(0));
5051             uint112 penalty = uint112(decimalFraction(accountInMem.balance, PENALTY_FRACTION));
5052             // distribution via ERC223 to contract or simple address
5053             assert(PAYMENT_TOKEN.transfer(penaltyDisbursalAddress, penalty, abi.encodePacked(NEUMARK)));
5054             emit LogPenaltyDisbursed(penaltyDisbursalAddress, investor, penalty, PAYMENT_TOKEN);
5055             accountInMem.balance -= penalty;
5056         }
5057         // transfer amount back to investor - now it can withdraw
5058         assert(PAYMENT_TOKEN.transfer(investor, accountInMem.balance, ""));
5059         emit LogFundsUnlocked(investor, accountInMem.balance, accountInMem.neumarksDue);
5060     }
5061 
5062     /// @notice locks funds of investors for a period of time, called by migration
5063     /// @param investor funds owner
5064     /// @param amount amount of funds locked
5065     /// @param neumarks amount of neumarks that needs to be returned by investor to unlock funds
5066     /// @param unlockDate unlockDate of migrating account
5067     /// @dev used only by migration
5068     function lock(address investor, uint112 amount, uint112 neumarks, uint32 unlockDate)
5069         private
5070         acceptAgreement(investor)
5071     {
5072         require(amount > 0);
5073         Account storage account = _accounts[investor];
5074         if (account.unlockDate == 0) {
5075             // this is new account - unlockDate always > 0
5076             _totalInvestors += 1;
5077         }
5078 
5079         // update holdings
5080         account.balance = addBalance(account.balance, amount);
5081         account.neumarksDue = add112(account.neumarksDue, neumarks);
5082         // overwrite unlockDate if it is earler. we do not supporting joining tickets from different investors
5083         // this will discourage sending 1 wei to move unlock date
5084         if (unlockDate > account.unlockDate) {
5085             account.unlockDate = unlockDate;
5086         }
5087 
5088         emit LogFundsLocked(investor, amount, neumarks);
5089     }
5090 
5091     function addDestination(Destination[] storage destinations, address wallet, uint112 amount)
5092         private
5093     {
5094         // only verified destinations
5095         IIdentityRegistry identityRegistry = IIdentityRegistry(UNIVERSE.identityRegistry());
5096         IdentityClaims memory claims = deserializeClaims(identityRegistry.getClaims(wallet));
5097         require(claims.isVerified && !claims.accountFrozen, "NF_DEST_NO_VERIFICATION");
5098         if (wallet != msg.sender) {
5099             // prevent squatting - cannot set destination for not yet migrated investor
5100             (,,uint256 unlockDate) = MIGRATION_SOURCE.balanceOf(wallet);
5101             require(unlockDate == 0, "NF_DEST_NO_SQUATTING");
5102         }
5103 
5104         destinations.push(
5105             Destination({investor: wallet, amount: amount})
5106         );
5107         emit LogMigrationDestination(msg.sender, wallet, amount);
5108     }
5109 
5110     function sub112(uint112 a, uint112 b) internal pure returns (uint112)
5111     {
5112         assert(b <= a);
5113         return a - b;
5114     }
5115 
5116     function add112(uint112 a, uint112 b) internal pure returns (uint112)
5117     {
5118         uint112 c = a + b;
5119         assert(c >= a);
5120         return c;
5121     }
5122 }