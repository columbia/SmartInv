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
647 contract IsContract {
648 
649     ////////////////////////
650     // Internal functions
651     ////////////////////////
652 
653     function isContract(address addr)
654         internal
655         constant
656         returns (bool)
657     {
658         uint256 size;
659         // takes 700 gas
660         assembly { size := extcodesize(addr) }
661         return size > 0;
662     }
663 }
664 
665 contract NeumarkIssuanceCurve {
666 
667     ////////////////////////
668     // Constants
669     ////////////////////////
670 
671     // maximum number of neumarks that may be created
672     uint256 private constant NEUMARK_CAP = 1500000000000000000000000000;
673 
674     // initial neumark reward fraction (controls curve steepness)
675     uint256 private constant INITIAL_REWARD_FRACTION = 6500000000000000000;
676 
677     // stop issuing new Neumarks above this Euro value (as it goes quickly to zero)
678     uint256 private constant ISSUANCE_LIMIT_EUR_ULPS = 8300000000000000000000000000;
679 
680     // approximate curve linearly above this Euro value
681     uint256 private constant LINEAR_APPROX_LIMIT_EUR_ULPS = 2100000000000000000000000000;
682     uint256 private constant NEUMARKS_AT_LINEAR_LIMIT_ULPS = 1499832501287264827896539871;
683 
684     uint256 private constant TOT_LINEAR_NEUMARKS_ULPS = NEUMARK_CAP - NEUMARKS_AT_LINEAR_LIMIT_ULPS;
685     uint256 private constant TOT_LINEAR_EUR_ULPS = ISSUANCE_LIMIT_EUR_ULPS - LINEAR_APPROX_LIMIT_EUR_ULPS;
686 
687     ////////////////////////
688     // Public functions
689     ////////////////////////
690 
691     /// @notice returns additional amount of neumarks issued for euroUlps at totalEuroUlps
692     /// @param totalEuroUlps actual curve position from which neumarks will be issued
693     /// @param euroUlps amount against which neumarks will be issued
694     function incremental(uint256 totalEuroUlps, uint256 euroUlps)
695         public
696         pure
697         returns (uint256 neumarkUlps)
698     {
699         require(totalEuroUlps + euroUlps >= totalEuroUlps);
700         uint256 from = cumulative(totalEuroUlps);
701         uint256 to = cumulative(totalEuroUlps + euroUlps);
702         // as expansion is not monotonic for large totalEuroUlps, assert below may fail
703         // example: totalEuroUlps=1.999999999999999999999000000e+27 and euroUlps=50
704         assert(to >= from);
705         return to - from;
706     }
707 
708     /// @notice returns amount of euro corresponding to burned neumarks
709     /// @param totalEuroUlps actual curve position from which neumarks will be burned
710     /// @param burnNeumarkUlps amount of neumarks to burn
711     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps)
712         public
713         pure
714         returns (uint256 euroUlps)
715     {
716         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
717         require(totalNeumarkUlps >= burnNeumarkUlps);
718         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
719         uint newTotalEuroUlps = cumulativeInverse(fromNmk, 0, totalEuroUlps);
720         // yes, this may overflow due to non monotonic inverse function
721         assert(totalEuroUlps >= newTotalEuroUlps);
722         return totalEuroUlps - newTotalEuroUlps;
723     }
724 
725     /// @notice returns amount of euro corresponding to burned neumarks
726     /// @param totalEuroUlps actual curve position from which neumarks will be burned
727     /// @param burnNeumarkUlps amount of neumarks to burn
728     /// @param minEurUlps euro amount to start inverse search from, inclusive
729     /// @param maxEurUlps euro amount to end inverse search to, inclusive
730     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
731         public
732         pure
733         returns (uint256 euroUlps)
734     {
735         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
736         require(totalNeumarkUlps >= burnNeumarkUlps);
737         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
738         uint newTotalEuroUlps = cumulativeInverse(fromNmk, minEurUlps, maxEurUlps);
739         // yes, this may overflow due to non monotonic inverse function
740         assert(totalEuroUlps >= newTotalEuroUlps);
741         return totalEuroUlps - newTotalEuroUlps;
742     }
743 
744     /// @notice finds total amount of neumarks issued for given amount of Euro
745     /// @dev binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
746     ///     function below is not monotonic
747     function cumulative(uint256 euroUlps)
748         public
749         pure
750         returns(uint256 neumarkUlps)
751     {
752         // Return the cap if euroUlps is above the limit.
753         if (euroUlps >= ISSUANCE_LIMIT_EUR_ULPS) {
754             return NEUMARK_CAP;
755         }
756         // use linear approximation above limit below
757         // binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
758         if (euroUlps >= LINEAR_APPROX_LIMIT_EUR_ULPS) {
759             // (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS) is small so expression does not overflow
760             return NEUMARKS_AT_LINEAR_LIMIT_ULPS + (TOT_LINEAR_NEUMARKS_ULPS * (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS)) / TOT_LINEAR_EUR_ULPS;
761         }
762 
763         // Approximate cap-cap·(1-1/D)^n using the Binomial expansion
764         // http://galileo.phys.virginia.edu/classes/152.mf1i.spring02/Exponential_Function.htm
765         // Function[imax, -CAP*Sum[(-IR*EUR/CAP)^i/Factorial[i], {i, imax}]]
766         // which may be simplified to
767         // Function[imax, -CAP*Sum[(EUR)^i/(Factorial[i]*(-d)^i), {i, 1, imax}]]
768         // where d = cap/initial_reward
769         uint256 d = 230769230769230769230769231; // NEUMARK_CAP / INITIAL_REWARD_FRACTION
770         uint256 term = NEUMARK_CAP;
771         uint256 sum = 0;
772         uint256 denom = d;
773         do assembly {
774             // We use assembler primarily to avoid the expensive
775             // divide-by-zero check solc inserts for the / operator.
776             term  := div(mul(term, euroUlps), denom)
777             sum   := add(sum, term)
778             denom := add(denom, d)
779             // sub next term as we have power of negative value in the binomial expansion
780             term  := div(mul(term, euroUlps), denom)
781             sum   := sub(sum, term)
782             denom := add(denom, d)
783         } while (term != 0);
784         return sum;
785     }
786 
787     /// @notice find issuance curve inverse by binary search
788     /// @param neumarkUlps neumark amount to compute inverse for
789     /// @param minEurUlps minimum search range for the inverse, inclusive
790     /// @param maxEurUlps maxium search range for the inverse, inclusive
791     /// @dev in case of approximate search (no exact inverse) upper element of minimal search range is returned
792     /// @dev in case of many possible inverses, the lowest one will be used (if range permits)
793     /// @dev corresponds to a linear search that returns first euroUlp value that has cumulative() equal or greater than neumarkUlps
794     function cumulativeInverse(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
795         public
796         pure
797         returns (uint256 euroUlps)
798     {
799         require(maxEurUlps >= minEurUlps);
800         require(cumulative(minEurUlps) <= neumarkUlps);
801         require(cumulative(maxEurUlps) >= neumarkUlps);
802         uint256 min = minEurUlps;
803         uint256 max = maxEurUlps;
804 
805         // Binary search
806         while (max > min) {
807             uint256 mid = (max + min) / 2;
808             uint256 val = cumulative(mid);
809             // exact solution should not be used, a late points of the curve when many euroUlps are needed to
810             // increase by one nmkUlp this will lead to  "indeterministic" inverse values that depend on the initial min and max
811             // and further binary division -> you can land at any of the euro value that is mapped to the same nmk value
812             // with condition below removed, binary search will point to the lowest eur value possible which is good because it cannot be exploited even with 0 gas costs
813             /* if (val == neumarkUlps) {
814                 return mid;
815             }*/
816             // NOTE: approximate search (no inverse) must return upper element of the final range
817             //  last step of approximate search is always (min, min+1) so new mid is (2*min+1)/2 => min
818             //  so new min = mid + 1 = max which was upper range. and that ends the search
819             // NOTE: when there are multiple inverses for the same neumarkUlps, the `max` will be dragged down
820             //  by `max = mid` expression to the lowest eur value of inverse. works only for ranges that cover all points of multiple inverse
821             if (val < neumarkUlps) {
822                 min = mid + 1;
823             } else {
824                 max = mid;
825             }
826         }
827         // NOTE: It is possible that there is no inverse
828         //  for example curve(0) = 0 and curve(1) = 6, so
829         //  there is no value y such that curve(y) = 5.
830         //  When there is no inverse, we must return upper element of last search range.
831         //  This has the effect of reversing the curve less when
832         //  burning Neumarks. This ensures that Neumarks can always
833         //  be burned. It also ensure that the total supply of Neumarks
834         //  remains below the cap.
835         return max;
836     }
837 
838     function neumarkCap()
839         public
840         pure
841         returns (uint256)
842     {
843         return NEUMARK_CAP;
844     }
845 
846     function initialRewardFraction()
847         public
848         pure
849         returns (uint256)
850     {
851         return INITIAL_REWARD_FRACTION;
852     }
853 }
854 
855 contract IBasicToken {
856 
857     ////////////////////////
858     // Events
859     ////////////////////////
860 
861     event Transfer(
862         address indexed from,
863         address indexed to,
864         uint256 amount
865     );
866 
867     ////////////////////////
868     // Public functions
869     ////////////////////////
870 
871     /// @dev This function makes it easy to get the total number of tokens
872     /// @return The total number of tokens
873     function totalSupply()
874         public
875         constant
876         returns (uint256);
877 
878     /// @param owner The address that's balance is being requested
879     /// @return The balance of `owner` at the current block
880     function balanceOf(address owner)
881         public
882         constant
883         returns (uint256 balance);
884 
885     /// @notice Send `amount` tokens to `to` from `msg.sender`
886     /// @param to The address of the recipient
887     /// @param amount The amount of tokens to be transferred
888     /// @return Whether the transfer was successful or not
889     function transfer(address to, uint256 amount)
890         public
891         returns (bool success);
892 
893 }
894 
895 /// @title allows deriving contract to recover any token or ether that it has balance of
896 /// @notice note that this opens your contracts to claims from various people saying they lost tokens and they want them back
897 ///     be ready to handle such claims
898 /// @dev use with care!
899 ///     1. ROLE_RECLAIMER is allowed to claim tokens, it's not returning tokens to original owner
900 ///     2. in derived contract that holds any token by design you must override `reclaim` and block such possibility.
901 ///         see ICBMLockedAccount as an example
902 contract Reclaimable is AccessControlled, AccessRoles {
903 
904     ////////////////////////
905     // Constants
906     ////////////////////////
907 
908     IBasicToken constant internal RECLAIM_ETHER = IBasicToken(0x0);
909 
910     ////////////////////////
911     // Public functions
912     ////////////////////////
913 
914     function reclaim(IBasicToken token)
915         public
916         only(ROLE_RECLAIMER)
917     {
918         address reclaimer = msg.sender;
919         if(token == RECLAIM_ETHER) {
920             reclaimer.transfer(address(this).balance);
921         } else {
922             uint256 balance = token.balanceOf(this);
923             require(token.transfer(reclaimer, balance));
924         }
925     }
926 }
927 
928 /// @title advances snapshot id on demand
929 /// @dev see Snapshot folder for implementation examples ie. DailyAndSnapshotable contract
930 contract ISnapshotable {
931 
932     ////////////////////////
933     // Events
934     ////////////////////////
935 
936     /// @dev should log each new snapshot id created, including snapshots created automatically via MSnapshotPolicy
937     event LogSnapshotCreated(uint256 snapshotId);
938 
939     ////////////////////////
940     // Public functions
941     ////////////////////////
942 
943     /// always creates new snapshot id which gets returned
944     /// however, there is no guarantee that any snapshot will be created with this id, this depends on the implementation of MSnaphotPolicy
945     function createSnapshot()
946         public
947         returns (uint256);
948 
949     /// upper bound of series snapshotIds for which there's a value
950     function currentSnapshotId()
951         public
952         constant
953         returns (uint256);
954 }
955 
956 /// @title Abstracts snapshot id creation logics
957 /// @dev Mixin (internal interface) of the snapshot policy which abstracts snapshot id creation logics from Snapshot contract
958 /// @dev to be implemented and such implementation should be mixed with Snapshot-derived contract, see EveryBlock for simplest example of implementation and StandardSnapshotToken
959 contract MSnapshotPolicy {
960 
961     ////////////////////////
962     // Internal functions
963     ////////////////////////
964 
965     // The snapshot Ids need to be strictly increasing.
966     // Whenever the snaspshot id changes, a new snapshot will be created.
967     // As long as the same snapshot id is being returned, last snapshot will be updated as this indicates that snapshot id didn't change
968     //
969     // Values passed to `hasValueAt` and `valuteAt` are required
970     // to be less or equal to `mCurrentSnapshotId()`.
971     function mAdvanceSnapshotId()
972         internal
973         returns (uint256);
974 
975     // this is a version of mAdvanceSnapshotId that does not modify state but MUST return the same value
976     // it is required to implement ITokenSnapshots interface cleanly
977     function mCurrentSnapshotId()
978         internal
979         constant
980         returns (uint256);
981 
982 }
983 
984 /// @title creates new snapshot id on each day boundary
985 /// @dev snapshot id is unix timestamp of current day boundary
986 contract Daily is MSnapshotPolicy {
987 
988     ////////////////////////
989     // Constants
990     ////////////////////////
991 
992     // Floor[2**128 / 1 days]
993     uint256 private MAX_TIMESTAMP = 3938453320844195178974243141571391;
994 
995     ////////////////////////
996     // Constructor
997     ////////////////////////
998 
999     /// @param start snapshotId from which to start generating values, used to prevent cloning from incompatible schemes
1000     /// @dev start must be for the same day or 0, required for token cloning
1001     constructor(uint256 start) internal {
1002         // 0 is invalid value as we are past unix epoch
1003         if (start > 0) {
1004             uint256 base = dayBase(uint128(block.timestamp));
1005             // must be within current day base
1006             require(start >= base);
1007             // dayBase + 2**128 will not overflow as it is based on block.timestamp
1008             require(start < base + 2**128);
1009         }
1010     }
1011 
1012     ////////////////////////
1013     // Public functions
1014     ////////////////////////
1015 
1016     function snapshotAt(uint256 timestamp)
1017         public
1018         constant
1019         returns (uint256)
1020     {
1021         require(timestamp < MAX_TIMESTAMP);
1022 
1023         return dayBase(uint128(timestamp));
1024     }
1025 
1026     ////////////////////////
1027     // Internal functions
1028     ////////////////////////
1029 
1030     //
1031     // Implements MSnapshotPolicy
1032     //
1033 
1034     function mAdvanceSnapshotId()
1035         internal
1036         returns (uint256)
1037     {
1038         return mCurrentSnapshotId();
1039     }
1040 
1041     function mCurrentSnapshotId()
1042         internal
1043         constant
1044         returns (uint256)
1045     {
1046         // disregard overflows on block.timestamp, see MAX_TIMESTAMP
1047         return dayBase(uint128(block.timestamp));
1048     }
1049 
1050     function dayBase(uint128 timestamp)
1051         internal
1052         pure
1053         returns (uint256)
1054     {
1055         // Round down to the start of the day (00:00 UTC) and place in higher 128bits
1056         return 2**128 * (uint256(timestamp) / 1 days);
1057     }
1058 }
1059 
1060 /// @title creates snapshot id on each day boundary and allows to create additional snapshots within a given day
1061 /// @dev snapshots are encoded in single uint256, where high 128 bits represents a day number (from unix epoch) and low 128 bits represents additional snapshots within given day create via ISnapshotable
1062 contract DailyAndSnapshotable is
1063     Daily,
1064     ISnapshotable
1065 {
1066 
1067     ////////////////////////
1068     // Mutable state
1069     ////////////////////////
1070 
1071     uint256 private _currentSnapshotId;
1072 
1073     ////////////////////////
1074     // Constructor
1075     ////////////////////////
1076 
1077     /// @param start snapshotId from which to start generating values
1078     /// @dev start must be for the same day or 0, required for token cloning
1079     constructor(uint256 start)
1080         internal
1081         Daily(start)
1082     {
1083         if (start > 0) {
1084             _currentSnapshotId = start;
1085         }
1086     }
1087 
1088     ////////////////////////
1089     // Public functions
1090     ////////////////////////
1091 
1092     //
1093     // Implements ISnapshotable
1094     //
1095 
1096     function createSnapshot()
1097         public
1098         returns (uint256)
1099     {
1100         uint256 base = dayBase(uint128(block.timestamp));
1101 
1102         if (base > _currentSnapshotId) {
1103             // New day has started, create snapshot for midnight
1104             _currentSnapshotId = base;
1105         } else {
1106             // within single day, increase counter (assume 2**128 will not be crossed)
1107             _currentSnapshotId += 1;
1108         }
1109 
1110         // Log and return
1111         emit LogSnapshotCreated(_currentSnapshotId);
1112         return _currentSnapshotId;
1113     }
1114 
1115     ////////////////////////
1116     // Internal functions
1117     ////////////////////////
1118 
1119     //
1120     // Implements MSnapshotPolicy
1121     //
1122 
1123     function mAdvanceSnapshotId()
1124         internal
1125         returns (uint256)
1126     {
1127         uint256 base = dayBase(uint128(block.timestamp));
1128 
1129         // New day has started
1130         if (base > _currentSnapshotId) {
1131             _currentSnapshotId = base;
1132             emit LogSnapshotCreated(base);
1133         }
1134 
1135         return _currentSnapshotId;
1136     }
1137 
1138     function mCurrentSnapshotId()
1139         internal
1140         constant
1141         returns (uint256)
1142     {
1143         uint256 base = dayBase(uint128(block.timestamp));
1144 
1145         return base > _currentSnapshotId ? base : _currentSnapshotId;
1146     }
1147 }
1148 
1149 contract ITokenMetadata {
1150 
1151     ////////////////////////
1152     // Public functions
1153     ////////////////////////
1154 
1155     function symbol()
1156         public
1157         constant
1158         returns (string);
1159 
1160     function name()
1161         public
1162         constant
1163         returns (string);
1164 
1165     function decimals()
1166         public
1167         constant
1168         returns (uint8);
1169 }
1170 
1171 /// @title adds token metadata to token contract
1172 /// @dev see Neumark for example implementation
1173 contract TokenMetadata is ITokenMetadata {
1174 
1175     ////////////////////////
1176     // Immutable state
1177     ////////////////////////
1178 
1179     // The Token's name: e.g. DigixDAO Tokens
1180     string private NAME;
1181 
1182     // An identifier: e.g. REP
1183     string private SYMBOL;
1184 
1185     // Number of decimals of the smallest unit
1186     uint8 private DECIMALS;
1187 
1188     // An arbitrary versioning scheme
1189     string private VERSION;
1190 
1191     ////////////////////////
1192     // Constructor
1193     ////////////////////////
1194 
1195     /// @notice Constructor to set metadata
1196     /// @param tokenName Name of the new token
1197     /// @param decimalUnits Number of decimals of the new token
1198     /// @param tokenSymbol Token Symbol for the new token
1199     /// @param version Token version ie. when cloning is used
1200     constructor(
1201         string tokenName,
1202         uint8 decimalUnits,
1203         string tokenSymbol,
1204         string version
1205     )
1206         public
1207     {
1208         NAME = tokenName;                                 // Set the name
1209         SYMBOL = tokenSymbol;                             // Set the symbol
1210         DECIMALS = decimalUnits;                          // Set the decimals
1211         VERSION = version;
1212     }
1213 
1214     ////////////////////////
1215     // Public functions
1216     ////////////////////////
1217 
1218     function name()
1219         public
1220         constant
1221         returns (string)
1222     {
1223         return NAME;
1224     }
1225 
1226     function symbol()
1227         public
1228         constant
1229         returns (string)
1230     {
1231         return SYMBOL;
1232     }
1233 
1234     function decimals()
1235         public
1236         constant
1237         returns (uint8)
1238     {
1239         return DECIMALS;
1240     }
1241 
1242     function version()
1243         public
1244         constant
1245         returns (string)
1246     {
1247         return VERSION;
1248     }
1249 }
1250 
1251 contract IERC20Allowance {
1252 
1253     ////////////////////////
1254     // Events
1255     ////////////////////////
1256 
1257     event Approval(
1258         address indexed owner,
1259         address indexed spender,
1260         uint256 amount
1261     );
1262 
1263     ////////////////////////
1264     // Public functions
1265     ////////////////////////
1266 
1267     /// @dev This function makes it easy to read the `allowed[]` map
1268     /// @param owner The address of the account that owns the token
1269     /// @param spender The address of the account able to transfer the tokens
1270     /// @return Amount of remaining tokens of owner that spender is allowed
1271     ///  to spend
1272     function allowance(address owner, address spender)
1273         public
1274         constant
1275         returns (uint256 remaining);
1276 
1277     /// @notice `msg.sender` approves `spender` to spend `amount` tokens on
1278     ///  its behalf. This is a modified version of the ERC20 approve function
1279     ///  to be a little bit safer
1280     /// @param spender The address of the account able to transfer the tokens
1281     /// @param amount The amount of tokens to be approved for transfer
1282     /// @return True if the approval was successful
1283     function approve(address spender, uint256 amount)
1284         public
1285         returns (bool success);
1286 
1287     /// @notice Send `amount` tokens to `to` from `from` on the condition it
1288     ///  is approved by `from`
1289     /// @param from The address holding the tokens being transferred
1290     /// @param to The address of the recipient
1291     /// @param amount The amount of tokens to be transferred
1292     /// @return True if the transfer was successful
1293     function transferFrom(address from, address to, uint256 amount)
1294         public
1295         returns (bool success);
1296 
1297 }
1298 
1299 contract IERC20Token is IBasicToken, IERC20Allowance {
1300 
1301 }
1302 
1303 /// @title controls spending approvals
1304 /// @dev TokenAllowance observes this interface, Neumark contract implements it
1305 contract MTokenAllowanceController {
1306 
1307     ////////////////////////
1308     // Internal functions
1309     ////////////////////////
1310 
1311     /// @notice Notifies the controller about an approval allowing the
1312     ///  controller to react if desired
1313     /// @param owner The address that calls `approve()`
1314     /// @param spender The spender in the `approve()` call
1315     /// @param amount The amount in the `approve()` call
1316     /// @return False if the controller does not authorize the approval
1317     function mOnApprove(
1318         address owner,
1319         address spender,
1320         uint256 amount
1321     )
1322         internal
1323         returns (bool allow);
1324 
1325     /// @notice Allows to override allowance approved by the owner
1326     ///         Primary role is to enable forced transfers, do not override if you do not like it
1327     ///         Following behavior is expected in the observer
1328     ///         approve() - should revert if mAllowanceOverride() > 0
1329     ///         allowance() - should return mAllowanceOverride() if set
1330     ///         transferFrom() - should override allowance if mAllowanceOverride() > 0
1331     /// @param owner An address giving allowance to spender
1332     /// @param spender An address getting  a right to transfer allowance amount from the owner
1333     /// @return current allowance amount
1334     function mAllowanceOverride(
1335         address owner,
1336         address spender
1337     )
1338         internal
1339         constant
1340         returns (uint256 allowance);
1341 }
1342 
1343 /// @title controls token transfers
1344 /// @dev BasicSnapshotToken observes this interface, Neumark contract implements it
1345 contract MTokenTransferController {
1346 
1347     ////////////////////////
1348     // Internal functions
1349     ////////////////////////
1350 
1351     /// @notice Notifies the controller about a token transfer allowing the
1352     ///  controller to react if desired
1353     /// @param from The origin of the transfer
1354     /// @param to The destination of the transfer
1355     /// @param amount The amount of the transfer
1356     /// @return False if the controller does not authorize the transfer
1357     function mOnTransfer(
1358         address from,
1359         address to,
1360         uint256 amount
1361     )
1362         internal
1363         returns (bool allow);
1364 
1365 }
1366 
1367 /// @title controls approvals and transfers
1368 /// @dev The token controller contract must implement these functions, see Neumark as example
1369 /// @dev please note that controller may be a separate contract that is called from mOnTransfer and mOnApprove functions
1370 contract MTokenController is MTokenTransferController, MTokenAllowanceController {
1371 }
1372 
1373 /// @title internal token transfer function
1374 /// @dev see BasicSnapshotToken for implementation
1375 contract MTokenTransfer {
1376 
1377     ////////////////////////
1378     // Internal functions
1379     ////////////////////////
1380 
1381     /// @dev This is the actual transfer function in the token contract, it can
1382     ///  only be called by other functions in this contract.
1383     /// @param from The address holding the tokens being transferred
1384     /// @param to The address of the recipient
1385     /// @param amount The amount of tokens to be transferred
1386     /// @dev  reverts if transfer was not successful
1387     function mTransfer(
1388         address from,
1389         address to,
1390         uint256 amount
1391     )
1392         internal;
1393 }
1394 
1395 contract IERC677Callback {
1396 
1397     ////////////////////////
1398     // Public functions
1399     ////////////////////////
1400 
1401     // NOTE: This call can be initiated by anyone. You need to make sure that
1402     // it is send by the token (`require(msg.sender == token)`) or make sure
1403     // amount is valid (`require(token.allowance(this) >= amount)`).
1404     function receiveApproval(
1405         address from,
1406         uint256 amount,
1407         address token, // IERC667Token
1408         bytes data
1409     )
1410         public
1411         returns (bool success);
1412 
1413 }
1414 
1415 contract IERC677Allowance is IERC20Allowance {
1416 
1417     ////////////////////////
1418     // Public functions
1419     ////////////////////////
1420 
1421     /// @notice `msg.sender` approves `spender` to send `amount` tokens on
1422     ///  its behalf, and then a function is triggered in the contract that is
1423     ///  being approved, `spender`. This allows users to use their tokens to
1424     ///  interact with contracts in one function call instead of two
1425     /// @param spender The address of the contract able to transfer the tokens
1426     /// @param amount The amount of tokens to be approved for transfer
1427     /// @return True if the function call was successful
1428     function approveAndCall(address spender, uint256 amount, bytes extraData)
1429         public
1430         returns (bool success);
1431 
1432 }
1433 
1434 contract IERC677Token is IERC20Token, IERC677Allowance {
1435 }
1436 
1437 /// @title token spending approval and transfer
1438 /// @dev implements token approval and transfers and exposes relevant part of ERC20 and ERC677 approveAndCall
1439 ///     may be mixed in with any basic token (implementing mTransfer) like BasicSnapshotToken or MintableSnapshotToken to add approval mechanism
1440 ///     observes MTokenAllowanceController interface
1441 ///     observes MTokenTransfer
1442 contract TokenAllowance is
1443     MTokenTransfer,
1444     MTokenAllowanceController,
1445     IERC20Allowance,
1446     IERC677Token
1447 {
1448 
1449     ////////////////////////
1450     // Mutable state
1451     ////////////////////////
1452 
1453     // `allowed` tracks rights to spends others tokens as per ERC20
1454     // owner => spender => amount
1455     mapping (address => mapping (address => uint256)) private _allowed;
1456 
1457     ////////////////////////
1458     // Constructor
1459     ////////////////////////
1460 
1461     constructor()
1462         internal
1463     {
1464     }
1465 
1466     ////////////////////////
1467     // Public functions
1468     ////////////////////////
1469 
1470     //
1471     // Implements IERC20Token
1472     //
1473 
1474     /// @dev This function makes it easy to read the `allowed[]` map
1475     /// @param owner The address of the account that owns the token
1476     /// @param spender The address of the account able to transfer the tokens
1477     /// @return Amount of remaining tokens of _owner that _spender is allowed
1478     ///  to spend
1479     function allowance(address owner, address spender)
1480         public
1481         constant
1482         returns (uint256 remaining)
1483     {
1484         uint256 override = mAllowanceOverride(owner, spender);
1485         if (override > 0) {
1486             return override;
1487         }
1488         return _allowed[owner][spender];
1489     }
1490 
1491     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
1492     ///  its behalf. This is a modified version of the ERC20 approve function
1493     ///  where allowance per spender must be 0 to allow change of such allowance
1494     /// @param spender The address of the account able to transfer the tokens
1495     /// @param amount The amount of tokens to be approved for transfer
1496     /// @return True or reverts, False is never returned
1497     function approve(address spender, uint256 amount)
1498         public
1499         returns (bool success)
1500     {
1501         // Alerts the token controller of the approve function call
1502         require(mOnApprove(msg.sender, spender, amount));
1503 
1504         // To change the approve amount you first have to reduce the addresses`
1505         //  allowance to zero by calling `approve(_spender,0)` if it is not
1506         //  already 0 to mitigate the race condition described here:
1507         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1508         require((amount == 0 || _allowed[msg.sender][spender] == 0) && mAllowanceOverride(msg.sender, spender) == 0);
1509 
1510         _allowed[msg.sender][spender] = amount;
1511         emit Approval(msg.sender, spender, amount);
1512         return true;
1513     }
1514 
1515     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
1516     ///  is approved by `_from`
1517     /// @param from The address holding the tokens being transferred
1518     /// @param to The address of the recipient
1519     /// @param amount The amount of tokens to be transferred
1520     /// @return True if the transfer was successful, reverts in any other case
1521     function transferFrom(address from, address to, uint256 amount)
1522         public
1523         returns (bool success)
1524     {
1525         uint256 allowed = mAllowanceOverride(from, msg.sender);
1526         if (allowed == 0) {
1527             // The standard ERC 20 transferFrom functionality
1528             allowed = _allowed[from][msg.sender];
1529             // yes this will underflow but then we'll revert. will cost gas however so don't underflow
1530             _allowed[from][msg.sender] -= amount;
1531         }
1532         require(allowed >= amount);
1533         mTransfer(from, to, amount);
1534         return true;
1535     }
1536 
1537     //
1538     // Implements IERC677Token
1539     //
1540 
1541     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
1542     ///  its behalf, and then a function is triggered in the contract that is
1543     ///  being approved, `_spender`. This allows users to use their tokens to
1544     ///  interact with contracts in one function call instead of two
1545     /// @param spender The address of the contract able to transfer the tokens
1546     /// @param amount The amount of tokens to be approved for transfer
1547     /// @return True or reverts, False is never returned
1548     function approveAndCall(
1549         address spender,
1550         uint256 amount,
1551         bytes extraData
1552     )
1553         public
1554         returns (bool success)
1555     {
1556         require(approve(spender, amount));
1557 
1558         success = IERC677Callback(spender).receiveApproval(
1559             msg.sender,
1560             amount,
1561             this,
1562             extraData
1563         );
1564         require(success);
1565 
1566         return true;
1567     }
1568 
1569     ////////////////////////
1570     // Internal functions
1571     ////////////////////////
1572 
1573     //
1574     // Implements default MTokenAllowanceController
1575     //
1576 
1577     // no override in default implementation
1578     function mAllowanceOverride(
1579         address /*owner*/,
1580         address /*spender*/
1581     )
1582         internal
1583         constant
1584         returns (uint256)
1585     {
1586         return 0;
1587     }
1588 }
1589 
1590 /// @title Reads and writes snapshots
1591 /// @dev Manages reading and writing a series of values, where each value has assigned a snapshot id for access to historical data
1592 /// @dev may be added to any contract to provide snapshotting mechanism. should be mixed in with any of MSnapshotPolicy implementations to customize snapshot creation mechanics
1593 ///     observes MSnapshotPolicy
1594 /// based on MiniMe token
1595 contract Snapshot is MSnapshotPolicy {
1596 
1597     ////////////////////////
1598     // Types
1599     ////////////////////////
1600 
1601     /// @dev `Values` is the structure that attaches a snapshot id to a
1602     ///  given value, the snapshot id attached is the one that last changed the
1603     ///  value
1604     struct Values {
1605 
1606         // `snapshotId` is the snapshot id that the value was generated at
1607         uint256 snapshotId;
1608 
1609         // `value` at a specific snapshot id
1610         uint256 value;
1611     }
1612 
1613     ////////////////////////
1614     // Internal functions
1615     ////////////////////////
1616 
1617     function hasValue(
1618         Values[] storage values
1619     )
1620         internal
1621         constant
1622         returns (bool)
1623     {
1624         return values.length > 0;
1625     }
1626 
1627     /// @dev makes sure that 'snapshotId' between current snapshot id (mCurrentSnapshotId) and first snapshot id. this guarantees that getValueAt returns value from one of the snapshots.
1628     function hasValueAt(
1629         Values[] storage values,
1630         uint256 snapshotId
1631     )
1632         internal
1633         constant
1634         returns (bool)
1635     {
1636         require(snapshotId <= mCurrentSnapshotId());
1637         return values.length > 0 && values[0].snapshotId <= snapshotId;
1638     }
1639 
1640     /// gets last value in the series
1641     function getValue(
1642         Values[] storage values,
1643         uint256 defaultValue
1644     )
1645         internal
1646         constant
1647         returns (uint256)
1648     {
1649         if (values.length == 0) {
1650             return defaultValue;
1651         } else {
1652             uint256 last = values.length - 1;
1653             return values[last].value;
1654         }
1655     }
1656 
1657     /// @dev `getValueAt` retrieves value at a given snapshot id
1658     /// @param values The series of values being queried
1659     /// @param snapshotId Snapshot id to retrieve the value at
1660     /// @return Value in series being queried
1661     function getValueAt(
1662         Values[] storage values,
1663         uint256 snapshotId,
1664         uint256 defaultValue
1665     )
1666         internal
1667         constant
1668         returns (uint256)
1669     {
1670         require(snapshotId <= mCurrentSnapshotId());
1671 
1672         // Empty value
1673         if (values.length == 0) {
1674             return defaultValue;
1675         }
1676 
1677         // Shortcut for the out of bounds snapshots
1678         uint256 last = values.length - 1;
1679         uint256 lastSnapshot = values[last].snapshotId;
1680         if (snapshotId >= lastSnapshot) {
1681             return values[last].value;
1682         }
1683         uint256 firstSnapshot = values[0].snapshotId;
1684         if (snapshotId < firstSnapshot) {
1685             return defaultValue;
1686         }
1687         // Binary search of the value in the array
1688         uint256 min = 0;
1689         uint256 max = last;
1690         while (max > min) {
1691             uint256 mid = (max + min + 1) / 2;
1692             // must always return lower indice for approximate searches
1693             if (values[mid].snapshotId <= snapshotId) {
1694                 min = mid;
1695             } else {
1696                 max = mid - 1;
1697             }
1698         }
1699         return values[min].value;
1700     }
1701 
1702     /// @dev `setValue` used to update sequence at next snapshot
1703     /// @param values The sequence being updated
1704     /// @param value The new last value of sequence
1705     function setValue(
1706         Values[] storage values,
1707         uint256 value
1708     )
1709         internal
1710     {
1711         // TODO: simplify or break into smaller functions
1712 
1713         uint256 currentSnapshotId = mAdvanceSnapshotId();
1714         // Always create a new entry if there currently is no value
1715         bool empty = values.length == 0;
1716         if (empty) {
1717             // Create a new entry
1718             values.push(
1719                 Values({
1720                     snapshotId: currentSnapshotId,
1721                     value: value
1722                 })
1723             );
1724             return;
1725         }
1726 
1727         uint256 last = values.length - 1;
1728         bool hasNewSnapshot = values[last].snapshotId < currentSnapshotId;
1729         if (hasNewSnapshot) {
1730 
1731             // Do nothing if the value was not modified
1732             bool unmodified = values[last].value == value;
1733             if (unmodified) {
1734                 return;
1735             }
1736 
1737             // Create new entry
1738             values.push(
1739                 Values({
1740                     snapshotId: currentSnapshotId,
1741                     value: value
1742                 })
1743             );
1744         } else {
1745 
1746             // We are updating the currentSnapshotId
1747             bool previousUnmodified = last > 0 && values[last - 1].value == value;
1748             if (previousUnmodified) {
1749                 // Remove current snapshot if current value was set to previous value
1750                 delete values[last];
1751                 values.length--;
1752                 return;
1753             }
1754 
1755             // Overwrite next snapshot entry
1756             values[last].value = value;
1757         }
1758     }
1759 }
1760 
1761 /// @title access to snapshots of a token
1762 /// @notice allows to implement complex token holder rights like revenue disbursal or voting
1763 /// @notice snapshots are series of values with assigned ids. ids increase strictly. particular id mechanism is not assumed
1764 contract ITokenSnapshots {
1765 
1766     ////////////////////////
1767     // Public functions
1768     ////////////////////////
1769 
1770     /// @notice Total amount of tokens at a specific `snapshotId`.
1771     /// @param snapshotId of snapshot at which totalSupply is queried
1772     /// @return The total amount of tokens at `snapshotId`
1773     /// @dev reverts on snapshotIds greater than currentSnapshotId()
1774     /// @dev returns 0 for snapshotIds less than snapshotId of first value
1775     function totalSupplyAt(uint256 snapshotId)
1776         public
1777         constant
1778         returns(uint256);
1779 
1780     /// @dev Queries the balance of `owner` at a specific `snapshotId`
1781     /// @param owner The address from which the balance will be retrieved
1782     /// @param snapshotId of snapshot at which the balance is queried
1783     /// @return The balance at `snapshotId`
1784     function balanceOfAt(address owner, uint256 snapshotId)
1785         public
1786         constant
1787         returns (uint256);
1788 
1789     /// @notice upper bound of series of snapshotIds for which there's a value in series
1790     /// @return snapshotId
1791     function currentSnapshotId()
1792         public
1793         constant
1794         returns (uint256);
1795 }
1796 
1797 /// @title represents link between cloned and parent token
1798 /// @dev when token is clone from other token, initial balances of the cloned token
1799 ///     correspond to balances of parent token at the moment of parent snapshot id specified
1800 /// @notice please note that other tokens beside snapshot token may be cloned
1801 contract IClonedTokenParent is ITokenSnapshots {
1802 
1803     ////////////////////////
1804     // Public functions
1805     ////////////////////////
1806 
1807 
1808     /// @return address of parent token, address(0) if root
1809     /// @dev parent token does not need to clonable, nor snapshottable, just a normal token
1810     function parentToken()
1811         public
1812         constant
1813         returns(IClonedTokenParent parent);
1814 
1815     /// @return snapshot at wchich initial token distribution was taken
1816     function parentSnapshotId()
1817         public
1818         constant
1819         returns(uint256 snapshotId);
1820 }
1821 
1822 /// @title token with snapshots and transfer functionality
1823 /// @dev observes MTokenTransferController interface
1824 ///     observes ISnapshotToken interface
1825 ///     implementes MTokenTransfer interface
1826 contract BasicSnapshotToken is
1827     MTokenTransfer,
1828     MTokenTransferController,
1829     IClonedTokenParent,
1830     IBasicToken,
1831     Snapshot
1832 {
1833     ////////////////////////
1834     // Immutable state
1835     ////////////////////////
1836 
1837     // `PARENT_TOKEN` is the Token address that was cloned to produce this token;
1838     //  it will be 0x0 for a token that was not cloned
1839     IClonedTokenParent private PARENT_TOKEN;
1840 
1841     // `PARENT_SNAPSHOT_ID` is the snapshot id from the Parent Token that was
1842     //  used to determine the initial distribution of the cloned token
1843     uint256 private PARENT_SNAPSHOT_ID;
1844 
1845     ////////////////////////
1846     // Mutable state
1847     ////////////////////////
1848 
1849     // `balances` is the map that tracks the balance of each address, in this
1850     //  contract when the balance changes the snapshot id that the change
1851     //  occurred is also included in the map
1852     mapping (address => Values[]) internal _balances;
1853 
1854     // Tracks the history of the `totalSupply` of the token
1855     Values[] internal _totalSupplyValues;
1856 
1857     ////////////////////////
1858     // Constructor
1859     ////////////////////////
1860 
1861     /// @notice Constructor to create snapshot token
1862     /// @param parentToken Address of the parent token, set to 0x0 if it is a
1863     ///  new token
1864     /// @param parentSnapshotId at which snapshot id clone was created, set to 0 to clone at upper bound
1865     /// @dev please not that as long as cloned token does not overwrite value at current snapshot id, it will refer
1866     ///     to parent token at which this snapshot still may change until snapshot id increases. for that time tokens are coupled
1867     ///     this is prevented by parentSnapshotId value of parentToken.currentSnapshotId() - 1 being the maxiumum
1868     ///     see SnapshotToken.js test to learn consequences coupling has.
1869     constructor(
1870         IClonedTokenParent parentToken,
1871         uint256 parentSnapshotId
1872     )
1873         Snapshot()
1874         internal
1875     {
1876         PARENT_TOKEN = parentToken;
1877         if (parentToken == address(0)) {
1878             require(parentSnapshotId == 0);
1879         } else {
1880             if (parentSnapshotId == 0) {
1881                 require(parentToken.currentSnapshotId() > 0);
1882                 PARENT_SNAPSHOT_ID = parentToken.currentSnapshotId() - 1;
1883             } else {
1884                 PARENT_SNAPSHOT_ID = parentSnapshotId;
1885             }
1886         }
1887     }
1888 
1889     ////////////////////////
1890     // Public functions
1891     ////////////////////////
1892 
1893     //
1894     // Implements IBasicToken
1895     //
1896 
1897     /// @dev This function makes it easy to get the total number of tokens
1898     /// @return The total number of tokens
1899     function totalSupply()
1900         public
1901         constant
1902         returns (uint256)
1903     {
1904         return totalSupplyAtInternal(mCurrentSnapshotId());
1905     }
1906 
1907     /// @param owner The address that's balance is being requested
1908     /// @return The balance of `owner` at the current block
1909     function balanceOf(address owner)
1910         public
1911         constant
1912         returns (uint256 balance)
1913     {
1914         return balanceOfAtInternal(owner, mCurrentSnapshotId());
1915     }
1916 
1917     /// @notice Send `amount` tokens to `to` from `msg.sender`
1918     /// @param to The address of the recipient
1919     /// @param amount The amount of tokens to be transferred
1920     /// @return True if the transfer was successful, reverts in any other case
1921     function transfer(address to, uint256 amount)
1922         public
1923         returns (bool success)
1924     {
1925         mTransfer(msg.sender, to, amount);
1926         return true;
1927     }
1928 
1929     //
1930     // Implements ITokenSnapshots
1931     //
1932 
1933     function totalSupplyAt(uint256 snapshotId)
1934         public
1935         constant
1936         returns(uint256)
1937     {
1938         return totalSupplyAtInternal(snapshotId);
1939     }
1940 
1941     function balanceOfAt(address owner, uint256 snapshotId)
1942         public
1943         constant
1944         returns (uint256)
1945     {
1946         return balanceOfAtInternal(owner, snapshotId);
1947     }
1948 
1949     function currentSnapshotId()
1950         public
1951         constant
1952         returns (uint256)
1953     {
1954         return mCurrentSnapshotId();
1955     }
1956 
1957     //
1958     // Implements IClonedTokenParent
1959     //
1960 
1961     function parentToken()
1962         public
1963         constant
1964         returns(IClonedTokenParent parent)
1965     {
1966         return PARENT_TOKEN;
1967     }
1968 
1969     /// @return snapshot at wchich initial token distribution was taken
1970     function parentSnapshotId()
1971         public
1972         constant
1973         returns(uint256 snapshotId)
1974     {
1975         return PARENT_SNAPSHOT_ID;
1976     }
1977 
1978     //
1979     // Other public functions
1980     //
1981 
1982     /// @notice gets all token balances of 'owner'
1983     /// @dev intended to be called via eth_call where gas limit is not an issue
1984     function allBalancesOf(address owner)
1985         external
1986         constant
1987         returns (uint256[2][])
1988     {
1989         /* very nice and working implementation below,
1990         // copy to memory
1991         Values[] memory values = _balances[owner];
1992         do assembly {
1993             // in memory structs have simple layout where every item occupies uint256
1994             balances := values
1995         } while (false);*/
1996 
1997         Values[] storage values = _balances[owner];
1998         uint256[2][] memory balances = new uint256[2][](values.length);
1999         for(uint256 ii = 0; ii < values.length; ++ii) {
2000             balances[ii] = [values[ii].snapshotId, values[ii].value];
2001         }
2002 
2003         return balances;
2004     }
2005 
2006     ////////////////////////
2007     // Internal functions
2008     ////////////////////////
2009 
2010     function totalSupplyAtInternal(uint256 snapshotId)
2011         internal
2012         constant
2013         returns(uint256)
2014     {
2015         Values[] storage values = _totalSupplyValues;
2016 
2017         // If there is a value, return it, reverts if value is in the future
2018         if (hasValueAt(values, snapshotId)) {
2019             return getValueAt(values, snapshotId, 0);
2020         }
2021 
2022         // Try parent contract at or before the fork
2023         if (address(PARENT_TOKEN) != 0) {
2024             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
2025             return PARENT_TOKEN.totalSupplyAt(earlierSnapshotId);
2026         }
2027 
2028         // Default to an empty balance
2029         return 0;
2030     }
2031 
2032     // get balance at snapshot if with continuation in parent token
2033     function balanceOfAtInternal(address owner, uint256 snapshotId)
2034         internal
2035         constant
2036         returns (uint256)
2037     {
2038         Values[] storage values = _balances[owner];
2039 
2040         // If there is a value, return it, reverts if value is in the future
2041         if (hasValueAt(values, snapshotId)) {
2042             return getValueAt(values, snapshotId, 0);
2043         }
2044 
2045         // Try parent contract at or before the fork
2046         if (PARENT_TOKEN != address(0)) {
2047             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
2048             return PARENT_TOKEN.balanceOfAt(owner, earlierSnapshotId);
2049         }
2050 
2051         // Default to an empty balance
2052         return 0;
2053     }
2054 
2055     //
2056     // Implements MTokenTransfer
2057     //
2058 
2059     /// @dev This is the actual transfer function in the token contract, it can
2060     ///  only be called by other functions in this contract.
2061     /// @param from The address holding the tokens being transferred
2062     /// @param to The address of the recipient
2063     /// @param amount The amount of tokens to be transferred
2064     /// @return True if the transfer was successful, reverts in any other case
2065     function mTransfer(
2066         address from,
2067         address to,
2068         uint256 amount
2069     )
2070         internal
2071     {
2072         // never send to address 0
2073         require(to != address(0));
2074         // block transfers in clone that points to future/current snapshots of parent token
2075         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2076         // Alerts the token controller of the transfer
2077         require(mOnTransfer(from, to, amount));
2078 
2079         // If the amount being transfered is more than the balance of the
2080         //  account the transfer reverts
2081         uint256 previousBalanceFrom = balanceOf(from);
2082         require(previousBalanceFrom >= amount);
2083 
2084         // First update the balance array with the new value for the address
2085         //  sending the tokens
2086         uint256 newBalanceFrom = previousBalanceFrom - amount;
2087         setValue(_balances[from], newBalanceFrom);
2088 
2089         // Then update the balance array with the new value for the address
2090         //  receiving the tokens
2091         uint256 previousBalanceTo = balanceOf(to);
2092         uint256 newBalanceTo = previousBalanceTo + amount;
2093         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
2094         setValue(_balances[to], newBalanceTo);
2095 
2096         // An event to make the transfer easy to find on the blockchain
2097         emit Transfer(from, to, amount);
2098     }
2099 }
2100 
2101 /// @title token generation and destruction
2102 /// @dev internal interface providing token generation and destruction, see MintableSnapshotToken for implementation
2103 contract MTokenMint {
2104 
2105     ////////////////////////
2106     // Internal functions
2107     ////////////////////////
2108 
2109     /// @notice Generates `amount` tokens that are assigned to `owner`
2110     /// @param owner The address that will be assigned the new tokens
2111     /// @param amount The quantity of tokens generated
2112     /// @dev reverts if tokens could not be generated
2113     function mGenerateTokens(address owner, uint256 amount)
2114         internal;
2115 
2116     /// @notice Burns `amount` tokens from `owner`
2117     /// @param owner The address that will lose the tokens
2118     /// @param amount The quantity of tokens to burn
2119     /// @dev reverts if tokens could not be destroyed
2120     function mDestroyTokens(address owner, uint256 amount)
2121         internal;
2122 }
2123 
2124 /// @title basic snapshot token with facitilites to generate and destroy tokens
2125 /// @dev implementes MTokenMint, does not expose any public functions that create/destroy tokens
2126 contract MintableSnapshotToken is
2127     BasicSnapshotToken,
2128     MTokenMint
2129 {
2130 
2131     ////////////////////////
2132     // Constructor
2133     ////////////////////////
2134 
2135     /// @notice Constructor to create a MintableSnapshotToken
2136     /// @param parentToken Address of the parent token, set to 0x0 if it is a
2137     ///  new token
2138     constructor(
2139         IClonedTokenParent parentToken,
2140         uint256 parentSnapshotId
2141     )
2142         BasicSnapshotToken(parentToken, parentSnapshotId)
2143         internal
2144     {}
2145 
2146     /// @notice Generates `amount` tokens that are assigned to `owner`
2147     /// @param owner The address that will be assigned the new tokens
2148     /// @param amount The quantity of tokens generated
2149     function mGenerateTokens(address owner, uint256 amount)
2150         internal
2151     {
2152         // never create for address 0
2153         require(owner != address(0));
2154         // block changes in clone that points to future/current snapshots of patent token
2155         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2156 
2157         uint256 curTotalSupply = totalSupply();
2158         uint256 newTotalSupply = curTotalSupply + amount;
2159         require(newTotalSupply >= curTotalSupply); // Check for overflow
2160 
2161         uint256 previousBalanceTo = balanceOf(owner);
2162         uint256 newBalanceTo = previousBalanceTo + amount;
2163         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
2164 
2165         setValue(_totalSupplyValues, newTotalSupply);
2166         setValue(_balances[owner], newBalanceTo);
2167 
2168         emit Transfer(0, owner, amount);
2169     }
2170 
2171     /// @notice Burns `amount` tokens from `owner`
2172     /// @param owner The address that will lose the tokens
2173     /// @param amount The quantity of tokens to burn
2174     function mDestroyTokens(address owner, uint256 amount)
2175         internal
2176     {
2177         // block changes in clone that points to future/current snapshots of patent token
2178         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2179 
2180         uint256 curTotalSupply = totalSupply();
2181         require(curTotalSupply >= amount);
2182 
2183         uint256 previousBalanceFrom = balanceOf(owner);
2184         require(previousBalanceFrom >= amount);
2185 
2186         uint256 newTotalSupply = curTotalSupply - amount;
2187         uint256 newBalanceFrom = previousBalanceFrom - amount;
2188         setValue(_totalSupplyValues, newTotalSupply);
2189         setValue(_balances[owner], newBalanceFrom);
2190 
2191         emit Transfer(owner, 0, amount);
2192     }
2193 }
2194 
2195 /*
2196     Copyright 2016, Jordi Baylina
2197     Copyright 2017, Remco Bloemen, Marcin Rudolf
2198 
2199     This program is free software: you can redistribute it and/or modify
2200     it under the terms of the GNU General Public License as published by
2201     the Free Software Foundation, either version 3 of the License, or
2202     (at your option) any later version.
2203 
2204     This program is distributed in the hope that it will be useful,
2205     but WITHOUT ANY WARRANTY; without even the implied warranty of
2206     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2207     GNU General Public License for more details.
2208 
2209     You should have received a copy of the GNU General Public License
2210     along with this program.  If not, see <http://www.gnu.org/licenses/>.
2211  */
2212 /// @title StandardSnapshotToken Contract
2213 /// @author Jordi Baylina, Remco Bloemen, Marcin Rudolf
2214 /// @dev This token contract's goal is to make it easy for anyone to clone this
2215 ///  token using the token distribution at a given block, this will allow DAO's
2216 ///  and DApps to upgrade their features in a decentralized manner without
2217 ///  affecting the original token
2218 /// @dev It is ERC20 compliant, but still needs to under go further testing.
2219 /// @dev Various contracts are composed to provide required functionality of this token, different compositions are possible
2220 ///     MintableSnapshotToken provides transfer, miniting and snapshotting functions
2221 ///     TokenAllowance provides approve/transferFrom functions
2222 ///     TokenMetadata adds name, symbol and other token metadata
2223 /// @dev This token is still abstract, Snapshot, BasicSnapshotToken and TokenAllowance observe interfaces that must be implemented
2224 ///     MSnapshotPolicy - particular snapshot id creation mechanism
2225 ///     MTokenController - controlls approvals and transfers
2226 ///     see Neumark as an example
2227 /// @dev implements ERC223 token transfer
2228 contract StandardSnapshotToken is
2229     MintableSnapshotToken,
2230     TokenAllowance
2231 {
2232     ////////////////////////
2233     // Constructor
2234     ////////////////////////
2235 
2236     /// @notice Constructor to create a MiniMeToken
2237     ///  is a new token
2238     /// param tokenName Name of the new token
2239     /// param decimalUnits Number of decimals of the new token
2240     /// param tokenSymbol Token Symbol for the new token
2241     constructor(
2242         IClonedTokenParent parentToken,
2243         uint256 parentSnapshotId
2244     )
2245         MintableSnapshotToken(parentToken, parentSnapshotId)
2246         TokenAllowance()
2247         internal
2248     {}
2249 }
2250 
2251 /// @title old ERC223 callback function
2252 /// @dev as used in Neumark and ICBMEtherToken
2253 contract IERC223LegacyCallback {
2254 
2255     ////////////////////////
2256     // Public functions
2257     ////////////////////////
2258 
2259     function onTokenTransfer(address from, uint256 amount, bytes data)
2260         public;
2261 
2262 }
2263 
2264 contract IERC223Token is IERC20Token, ITokenMetadata {
2265 
2266     /// @dev Departure: We do not log data, it has no advantage over a standard
2267     ///     log event. By sticking to the standard log event we
2268     ///     stay compatible with constracts that expect and ERC20 token.
2269 
2270     // event Transfer(
2271     //    address indexed from,
2272     //    address indexed to,
2273     //    uint256 amount,
2274     //    bytes data);
2275 
2276 
2277     /// @dev Departure: We do not use the callback on regular transfer calls to
2278     ///     stay compatible with constracts that expect and ERC20 token.
2279 
2280     // function transfer(address to, uint256 amount)
2281     //     public
2282     //     returns (bool);
2283 
2284     ////////////////////////
2285     // Public functions
2286     ////////////////////////
2287 
2288     function transfer(address to, uint256 amount, bytes data)
2289         public
2290         returns (bool);
2291 }
2292 
2293 contract Neumark is
2294     AccessControlled,
2295     AccessRoles,
2296     Agreement,
2297     DailyAndSnapshotable,
2298     StandardSnapshotToken,
2299     TokenMetadata,
2300     IERC223Token,
2301     NeumarkIssuanceCurve,
2302     Reclaimable,
2303     IsContract
2304 {
2305 
2306     ////////////////////////
2307     // Constants
2308     ////////////////////////
2309 
2310     string private constant TOKEN_NAME = "Neumark";
2311 
2312     uint8  private constant TOKEN_DECIMALS = 18;
2313 
2314     string private constant TOKEN_SYMBOL = "NEU";
2315 
2316     string private constant VERSION = "NMK_1.0";
2317 
2318     ////////////////////////
2319     // Mutable state
2320     ////////////////////////
2321 
2322     // disable transfers when Neumark is created
2323     bool private _transferEnabled = false;
2324 
2325     // at which point on curve new Neumarks will be created, see NeumarkIssuanceCurve contract
2326     // do not use to get total invested funds. see burn(). this is just a cache for expensive inverse function
2327     uint256 private _totalEurUlps;
2328 
2329     ////////////////////////
2330     // Events
2331     ////////////////////////
2332 
2333     event LogNeumarksIssued(
2334         address indexed owner,
2335         uint256 euroUlps,
2336         uint256 neumarkUlps
2337     );
2338 
2339     event LogNeumarksBurned(
2340         address indexed owner,
2341         uint256 euroUlps,
2342         uint256 neumarkUlps
2343     );
2344 
2345     ////////////////////////
2346     // Constructor
2347     ////////////////////////
2348 
2349     constructor(
2350         IAccessPolicy accessPolicy,
2351         IEthereumForkArbiter forkArbiter
2352     )
2353         AccessRoles()
2354         Agreement(accessPolicy, forkArbiter)
2355         StandardSnapshotToken(
2356             IClonedTokenParent(0x0),
2357             0
2358         )
2359         TokenMetadata(
2360             TOKEN_NAME,
2361             TOKEN_DECIMALS,
2362             TOKEN_SYMBOL,
2363             VERSION
2364         )
2365         DailyAndSnapshotable(0)
2366         NeumarkIssuanceCurve()
2367         Reclaimable()
2368         public
2369     {}
2370 
2371     ////////////////////////
2372     // Public functions
2373     ////////////////////////
2374 
2375     /// @notice issues new Neumarks to msg.sender with reward at current curve position
2376     ///     moves curve position by euroUlps
2377     ///     callable only by ROLE_NEUMARK_ISSUER
2378     function issueForEuro(uint256 euroUlps)
2379         public
2380         only(ROLE_NEUMARK_ISSUER)
2381         acceptAgreement(msg.sender)
2382         returns (uint256)
2383     {
2384         require(_totalEurUlps + euroUlps >= _totalEurUlps);
2385         uint256 neumarkUlps = incremental(_totalEurUlps, euroUlps);
2386         _totalEurUlps += euroUlps;
2387         mGenerateTokens(msg.sender, neumarkUlps);
2388         emit LogNeumarksIssued(msg.sender, euroUlps, neumarkUlps);
2389         return neumarkUlps;
2390     }
2391 
2392     /// @notice used by ROLE_NEUMARK_ISSUER to transer newly issued neumarks
2393     ///     typically to the investor and platform operator
2394     function distribute(address to, uint256 neumarkUlps)
2395         public
2396         only(ROLE_NEUMARK_ISSUER)
2397         acceptAgreement(to)
2398     {
2399         mTransfer(msg.sender, to, neumarkUlps);
2400     }
2401 
2402     /// @notice msg.sender can burn their Neumarks, curve is rolled back using inverse
2403     ///     curve. as a result cost of Neumark gets lower (reward is higher)
2404     function burn(uint256 neumarkUlps)
2405         public
2406         only(ROLE_NEUMARK_BURNER)
2407     {
2408         burnPrivate(neumarkUlps, 0, _totalEurUlps);
2409     }
2410 
2411     /// @notice executes as function above but allows to provide search range for low gas burning
2412     function burn(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2413         public
2414         only(ROLE_NEUMARK_BURNER)
2415     {
2416         burnPrivate(neumarkUlps, minEurUlps, maxEurUlps);
2417     }
2418 
2419     function enableTransfer(bool enabled)
2420         public
2421         only(ROLE_TRANSFER_ADMIN)
2422     {
2423         _transferEnabled = enabled;
2424     }
2425 
2426     function createSnapshot()
2427         public
2428         only(ROLE_SNAPSHOT_CREATOR)
2429         returns (uint256)
2430     {
2431         return DailyAndSnapshotable.createSnapshot();
2432     }
2433 
2434     function transferEnabled()
2435         public
2436         constant
2437         returns (bool)
2438     {
2439         return _transferEnabled;
2440     }
2441 
2442     function totalEuroUlps()
2443         public
2444         constant
2445         returns (uint256)
2446     {
2447         return _totalEurUlps;
2448     }
2449 
2450     function incremental(uint256 euroUlps)
2451         public
2452         constant
2453         returns (uint256 neumarkUlps)
2454     {
2455         return incremental(_totalEurUlps, euroUlps);
2456     }
2457 
2458     //
2459     // Implements IERC223Token with IERC223Callback (onTokenTransfer) callback
2460     //
2461 
2462     // old implementation of ERC223 that was actual when ICBM was deployed
2463     // as Neumark is already deployed this function keeps old behavior for testing
2464     function transfer(address to, uint256 amount, bytes data)
2465         public
2466         returns (bool)
2467     {
2468         // it is necessary to point out implementation to be called
2469         BasicSnapshotToken.mTransfer(msg.sender, to, amount);
2470 
2471         // Notify the receiving contract.
2472         if (isContract(to)) {
2473             IERC223LegacyCallback(to).onTokenTransfer(msg.sender, amount, data);
2474         }
2475         return true;
2476     }
2477 
2478     ////////////////////////
2479     // Internal functions
2480     ////////////////////////
2481 
2482     //
2483     // Implements MTokenController
2484     //
2485 
2486     function mOnTransfer(
2487         address from,
2488         address, // to
2489         uint256 // amount
2490     )
2491         internal
2492         acceptAgreement(from)
2493         returns (bool allow)
2494     {
2495         // must have transfer enabled or msg.sender is Neumark issuer
2496         return _transferEnabled || accessPolicy().allowed(msg.sender, ROLE_NEUMARK_ISSUER, this, msg.sig);
2497     }
2498 
2499     function mOnApprove(
2500         address owner,
2501         address, // spender,
2502         uint256 // amount
2503     )
2504         internal
2505         acceptAgreement(owner)
2506         returns (bool allow)
2507     {
2508         return true;
2509     }
2510 
2511     ////////////////////////
2512     // Private functions
2513     ////////////////////////
2514 
2515     function burnPrivate(uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2516         private
2517     {
2518         uint256 prevEuroUlps = _totalEurUlps;
2519         // burn first in the token to make sure balance/totalSupply is not crossed
2520         mDestroyTokens(msg.sender, burnNeumarkUlps);
2521         _totalEurUlps = cumulativeInverse(totalSupply(), minEurUlps, maxEurUlps);
2522         // actually may overflow on non-monotonic inverse
2523         assert(prevEuroUlps >= _totalEurUlps);
2524         uint256 euroUlps = prevEuroUlps - _totalEurUlps;
2525         emit LogNeumarksBurned(msg.sender, euroUlps, burnNeumarkUlps);
2526     }
2527 }
2528 
2529 /// @title uniquely identifies deployable (non-abstract) platform contract
2530 /// @notice cheap way of assigning implementations to knownInterfaces which represent system services
2531 ///         unfortunatelly ERC165 does not include full public interface (ABI) and does not provide way to list implemented interfaces
2532 ///         EIP820 still in the making
2533 /// @dev ids are generated as follows keccak256("neufund-platform:<contract name>")
2534 ///      ids roughly correspond to ABIs
2535 contract IContractId {
2536     /// @param id defined as above
2537     /// @param version implementation version
2538     function contractId() public pure returns (bytes32 id, uint256 version);
2539 }
2540 
2541 /// @title current ERC223 fallback function
2542 /// @dev to be used in all future token contract
2543 /// @dev NEU and ICBMEtherToken (obsolete) are the only contracts that still uses IERC223LegacyCallback
2544 contract IERC223Callback {
2545 
2546     ////////////////////////
2547     // Public functions
2548     ////////////////////////
2549 
2550     function tokenFallback(address from, uint256 amount, bytes data)
2551         public;
2552 
2553 }
2554 
2555 /// @title disburse payment token amount to snapshot token holders
2556 /// @dev payment token received via ERC223 Transfer
2557 contract IFeeDisbursal is IERC223Callback {
2558     // TODO: declare interface
2559 }
2560 
2561 /// @title disburse payment token amount to snapshot token holders
2562 /// @dev payment token received via ERC223 Transfer
2563 contract IPlatformPortfolio is IERC223Callback {
2564     // TODO: declare interface
2565 }
2566 
2567 contract ITokenExchangeRateOracle {
2568     /// @notice provides actual price of 'numeratorToken' in 'denominatorToken'
2569     ///     returns timestamp at which price was obtained in oracle
2570     function getExchangeRate(address numeratorToken, address denominatorToken)
2571         public
2572         constant
2573         returns (uint256 rateFraction, uint256 timestamp);
2574 
2575     /// @notice allows to retreive multiple exchange rates in once call
2576     function getExchangeRates(address[] numeratorTokens, address[] denominatorTokens)
2577         public
2578         constant
2579         returns (uint256[] rateFractions, uint256[] timestamps);
2580 }
2581 
2582 /// @title root of trust and singletons + known interface registry
2583 /// provides a root which holds all interfaces platform trust, this includes
2584 /// singletons - for which accessors are provided
2585 /// collections of known instances of interfaces
2586 /// @dev interfaces are identified by bytes4, see KnownInterfaces.sol
2587 contract Universe is
2588     Agreement,
2589     IContractId,
2590     KnownInterfaces
2591 {
2592     ////////////////////////
2593     // Events
2594     ////////////////////////
2595 
2596     /// raised on any change of singleton instance
2597     /// @dev for convenience we provide previous instance of singleton in replacedInstance
2598     event LogSetSingleton(
2599         bytes4 interfaceId,
2600         address instance,
2601         address replacedInstance
2602     );
2603 
2604     /// raised on add/remove interface instance in collection
2605     event LogSetCollectionInterface(
2606         bytes4 interfaceId,
2607         address instance,
2608         bool isSet
2609     );
2610 
2611     ////////////////////////
2612     // Mutable state
2613     ////////////////////////
2614 
2615     // mapping of known contracts to addresses of singletons
2616     mapping(bytes4 => address) private _singletons;
2617 
2618     // mapping of known interfaces to collections of contracts
2619     mapping(bytes4 =>
2620         mapping(address => bool)) private _collections; // solium-disable-line indentation
2621 
2622     // known instances
2623     mapping(address => bytes4[]) private _instances;
2624 
2625 
2626     ////////////////////////
2627     // Constructor
2628     ////////////////////////
2629 
2630     constructor(
2631         IAccessPolicy accessPolicy,
2632         IEthereumForkArbiter forkArbiter
2633     )
2634         Agreement(accessPolicy, forkArbiter)
2635         public
2636     {
2637         setSingletonPrivate(KNOWN_INTERFACE_ACCESS_POLICY, accessPolicy);
2638         setSingletonPrivate(KNOWN_INTERFACE_FORK_ARBITER, forkArbiter);
2639     }
2640 
2641     ////////////////////////
2642     // Public methods
2643     ////////////////////////
2644 
2645     /// get singleton instance for 'interfaceId'
2646     function getSingleton(bytes4 interfaceId)
2647         public
2648         constant
2649         returns (address)
2650     {
2651         return _singletons[interfaceId];
2652     }
2653 
2654     function getManySingletons(bytes4[] interfaceIds)
2655         public
2656         constant
2657         returns (address[])
2658     {
2659         address[] memory addresses = new address[](interfaceIds.length);
2660         uint256 idx;
2661         while(idx < interfaceIds.length) {
2662             addresses[idx] = _singletons[interfaceIds[idx]];
2663             idx += 1;
2664         }
2665         return addresses;
2666     }
2667 
2668     /// checks of 'instance' is instance of interface 'interfaceId'
2669     function isSingleton(bytes4 interfaceId, address instance)
2670         public
2671         constant
2672         returns (bool)
2673     {
2674         return _singletons[interfaceId] == instance;
2675     }
2676 
2677     /// checks if 'instance' is one of instances of 'interfaceId'
2678     function isInterfaceCollectionInstance(bytes4 interfaceId, address instance)
2679         public
2680         constant
2681         returns (bool)
2682     {
2683         return _collections[interfaceId][instance];
2684     }
2685 
2686     function isAnyOfInterfaceCollectionInstance(bytes4[] interfaceIds, address instance)
2687         public
2688         constant
2689         returns (bool)
2690     {
2691         uint256 idx;
2692         while(idx < interfaceIds.length) {
2693             if (_collections[interfaceIds[idx]][instance]) {
2694                 return true;
2695             }
2696             idx += 1;
2697         }
2698         return false;
2699     }
2700 
2701     /// gets all interfaces of given instance
2702     function getInterfacesOfInstance(address instance)
2703         public
2704         constant
2705         returns (bytes4[] interfaces)
2706     {
2707         return _instances[instance];
2708     }
2709 
2710     /// sets 'instance' of singleton with interface 'interfaceId'
2711     function setSingleton(bytes4 interfaceId, address instance)
2712         public
2713         only(ROLE_UNIVERSE_MANAGER)
2714     {
2715         setSingletonPrivate(interfaceId, instance);
2716     }
2717 
2718     /// convenience method for setting many singleton instances
2719     function setManySingletons(bytes4[] interfaceIds, address[] instances)
2720         public
2721         only(ROLE_UNIVERSE_MANAGER)
2722     {
2723         require(interfaceIds.length == instances.length);
2724         uint256 idx;
2725         while(idx < interfaceIds.length) {
2726             setSingletonPrivate(interfaceIds[idx], instances[idx]);
2727             idx += 1;
2728         }
2729     }
2730 
2731     /// set or unset 'instance' with 'interfaceId' in collection of instances
2732     function setCollectionInterface(bytes4 interfaceId, address instance, bool set)
2733         public
2734         only(ROLE_UNIVERSE_MANAGER)
2735     {
2736         setCollectionPrivate(interfaceId, instance, set);
2737     }
2738 
2739     /// set or unset 'instance' in many collections of instances
2740     function setInterfaceInManyCollections(bytes4[] interfaceIds, address instance, bool set)
2741         public
2742         only(ROLE_UNIVERSE_MANAGER)
2743     {
2744         uint256 idx;
2745         while(idx < interfaceIds.length) {
2746             setCollectionPrivate(interfaceIds[idx], instance, set);
2747             idx += 1;
2748         }
2749     }
2750 
2751     /// set or unset array of collection
2752     function setCollectionsInterfaces(bytes4[] interfaceIds, address[] instances, bool[] set_flags)
2753         public
2754         only(ROLE_UNIVERSE_MANAGER)
2755     {
2756         require(interfaceIds.length == instances.length);
2757         require(interfaceIds.length == set_flags.length);
2758         uint256 idx;
2759         while(idx < interfaceIds.length) {
2760             setCollectionPrivate(interfaceIds[idx], instances[idx], set_flags[idx]);
2761             idx += 1;
2762         }
2763     }
2764 
2765     //
2766     // Implements IContractId
2767     //
2768 
2769     function contractId() public pure returns (bytes32 id, uint256 version) {
2770         return (0x8b57bfe21a3ef4854e19d702063b6cea03fa514162f8ff43fde551f06372fefd, 0);
2771     }
2772 
2773     ////////////////////////
2774     // Getters
2775     ////////////////////////
2776 
2777     function accessPolicy() public constant returns (IAccessPolicy) {
2778         return IAccessPolicy(_singletons[KNOWN_INTERFACE_ACCESS_POLICY]);
2779     }
2780 
2781     function forkArbiter() public constant returns (IEthereumForkArbiter) {
2782         return IEthereumForkArbiter(_singletons[KNOWN_INTERFACE_FORK_ARBITER]);
2783     }
2784 
2785     function neumark() public constant returns (Neumark) {
2786         return Neumark(_singletons[KNOWN_INTERFACE_NEUMARK]);
2787     }
2788 
2789     function etherToken() public constant returns (IERC223Token) {
2790         return IERC223Token(_singletons[KNOWN_INTERFACE_ETHER_TOKEN]);
2791     }
2792 
2793     function euroToken() public constant returns (IERC223Token) {
2794         return IERC223Token(_singletons[KNOWN_INTERFACE_EURO_TOKEN]);
2795     }
2796 
2797     function etherLock() public constant returns (address) {
2798         return _singletons[KNOWN_INTERFACE_ETHER_LOCK];
2799     }
2800 
2801     function euroLock() public constant returns (address) {
2802         return _singletons[KNOWN_INTERFACE_EURO_LOCK];
2803     }
2804 
2805     function icbmEtherLock() public constant returns (address) {
2806         return _singletons[KNOWN_INTERFACE_ICBM_ETHER_LOCK];
2807     }
2808 
2809     function icbmEuroLock() public constant returns (address) {
2810         return _singletons[KNOWN_INTERFACE_ICBM_EURO_LOCK];
2811     }
2812 
2813     function identityRegistry() public constant returns (address) {
2814         return IIdentityRegistry(_singletons[KNOWN_INTERFACE_IDENTITY_REGISTRY]);
2815     }
2816 
2817     function tokenExchangeRateOracle() public constant returns (address) {
2818         return ITokenExchangeRateOracle(_singletons[KNOWN_INTERFACE_TOKEN_EXCHANGE_RATE_ORACLE]);
2819     }
2820 
2821     function feeDisbursal() public constant returns (address) {
2822         return IFeeDisbursal(_singletons[KNOWN_INTERFACE_FEE_DISBURSAL]);
2823     }
2824 
2825     function platformPortfolio() public constant returns (address) {
2826         return IPlatformPortfolio(_singletons[KNOWN_INTERFACE_PLATFORM_PORTFOLIO]);
2827     }
2828 
2829     function tokenExchange() public constant returns (address) {
2830         return _singletons[KNOWN_INTERFACE_TOKEN_EXCHANGE];
2831     }
2832 
2833     function gasExchange() public constant returns (address) {
2834         return _singletons[KNOWN_INTERFACE_GAS_EXCHANGE];
2835     }
2836 
2837     function platformTerms() public constant returns (address) {
2838         return _singletons[KNOWN_INTERFACE_PLATFORM_TERMS];
2839     }
2840 
2841     ////////////////////////
2842     // Private methods
2843     ////////////////////////
2844 
2845     function setSingletonPrivate(bytes4 interfaceId, address instance)
2846         private
2847     {
2848         require(interfaceId != KNOWN_INTERFACE_UNIVERSE, "NF_UNI_NO_UNIVERSE_SINGLETON");
2849         address replacedInstance = _singletons[interfaceId];
2850         // do nothing if not changing
2851         if (replacedInstance != instance) {
2852             dropInstance(replacedInstance, interfaceId);
2853             addInstance(instance, interfaceId);
2854             _singletons[interfaceId] = instance;
2855         }
2856 
2857         emit LogSetSingleton(interfaceId, instance, replacedInstance);
2858     }
2859 
2860     function setCollectionPrivate(bytes4 interfaceId, address instance, bool set)
2861         private
2862     {
2863         // do nothing if not changing
2864         if (_collections[interfaceId][instance] == set) {
2865             return;
2866         }
2867         _collections[interfaceId][instance] = set;
2868         if (set) {
2869             addInstance(instance, interfaceId);
2870         } else {
2871             dropInstance(instance, interfaceId);
2872         }
2873         emit LogSetCollectionInterface(interfaceId, instance, set);
2874     }
2875 
2876     function addInstance(address instance, bytes4 interfaceId)
2877         private
2878     {
2879         if (instance == address(0)) {
2880             // do not add null instance
2881             return;
2882         }
2883         bytes4[] storage current = _instances[instance];
2884         uint256 idx;
2885         while(idx < current.length) {
2886             // instancy has this interface already, do nothing
2887             if (current[idx] == interfaceId)
2888                 return;
2889             idx += 1;
2890         }
2891         // new interface
2892         current.push(interfaceId);
2893     }
2894 
2895     function dropInstance(address instance, bytes4 interfaceId)
2896         private
2897     {
2898         if (instance == address(0)) {
2899             // do not drop null instance
2900             return;
2901         }
2902         bytes4[] storage current = _instances[instance];
2903         uint256 idx;
2904         uint256 last = current.length - 1;
2905         while(idx <= last) {
2906             if (current[idx] == interfaceId) {
2907                 // delete element
2908                 if (idx < last) {
2909                     // if not last element move last element to idx being deleted
2910                     current[idx] = current[last];
2911                 }
2912                 // delete last element
2913                 current.length -= 1;
2914                 return;
2915             }
2916             idx += 1;
2917         }
2918     }
2919 }