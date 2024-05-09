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
189 /// @title describes layout of claims in 256bit records stored for identities
190 /// @dev intended to be derived by contracts requiring access to particular claims
191 contract IdentityRecord {
192 
193     ////////////////////////
194     // Types
195     ////////////////////////
196 
197     /// @dev here the idea is to have claims of size of uint256 and use this struct
198     ///     to translate in and out of this struct. until we do not cross uint256 we
199     ///     have binary compatibility
200     struct IdentityClaims {
201         bool isVerified; // 1 bit
202         bool isSophisticatedInvestor; // 1 bit
203         bool hasBankAccount; // 1 bit
204         bool accountFrozen; // 1 bit
205         // uint252 reserved
206     }
207 
208     ////////////////////////
209     // Internal functions
210     ////////////////////////
211 
212     /// translates uint256 to struct
213     function deserializeClaims(bytes32 data) internal pure returns (IdentityClaims memory claims) {
214         // for memory layout of struct, each field below word length occupies whole word
215         assembly {
216             mstore(claims, and(data, 0x1))
217             mstore(add(claims, 0x20), div(and(data, 0x2), 0x2))
218             mstore(add(claims, 0x40), div(and(data, 0x4), 0x4))
219             mstore(add(claims, 0x60), div(and(data, 0x8), 0x8))
220         }
221     }
222 }
223 
224 
225 /// @title interface storing and retrieve 256bit claims records for identity
226 /// actual format of record is decoupled from storage (except maximum size)
227 contract IIdentityRegistry {
228 
229     ////////////////////////
230     // Events
231     ////////////////////////
232 
233     /// provides information on setting claims
234     event LogSetClaims(
235         address indexed identity,
236         bytes32 oldClaims,
237         bytes32 newClaims
238     );
239 
240     ////////////////////////
241     // Public functions
242     ////////////////////////
243 
244     /// get claims for identity
245     function getClaims(address identity) public constant returns (bytes32);
246 
247     /// set claims for identity
248     /// @dev odlClaims and newClaims used for optimistic locking. to override with newClaims
249     ///     current claims must be oldClaims
250     function setClaims(address identity, bytes32 oldClaims, bytes32 newClaims) public;
251 }
252 
253 /// @title known interfaces (services) of the platform
254 /// "known interface" is a unique id of service provided by the platform and discovered via Universe contract
255 ///  it does not refer to particular contract/interface ABI, particular service may be delivered via different implementations
256 ///  however for a few contracts we commit platform to particular implementation (all ICBM Contracts, Universe itself etc.)
257 /// @dev constants are kept in CODE not in STORAGE so they are comparatively cheap
258 contract KnownInterfaces {
259 
260     ////////////////////////
261     // Constants
262     ////////////////////////
263 
264     // NOTE: All interface are set to the keccak256 hash of the
265     // CamelCased interface or singleton name, i.e.
266     // KNOWN_INTERFACE_NEUMARK = keccak256("Neumark")
267 
268     // EIP 165 + EIP 820 should be use instead but it seems they are far from finished
269     // also interface signature should be build automatically by solidity. otherwise it is a pure hassle
270 
271     // neumark token interface and sigleton keccak256("Neumark")
272     bytes4 internal constant KNOWN_INTERFACE_NEUMARK = 0xeb41a1bd;
273 
274     // ether token interface and singleton keccak256("EtherToken")
275     bytes4 internal constant KNOWN_INTERFACE_ETHER_TOKEN = 0x8cf73cf1;
276 
277     // euro token interface and singleton keccak256("EuroToken")
278     bytes4 internal constant KNOWN_INTERFACE_EURO_TOKEN = 0x83c3790b;
279 
280     // identity registry interface and singleton keccak256("IIdentityRegistry")
281     bytes4 internal constant KNOWN_INTERFACE_IDENTITY_REGISTRY = 0x0a72e073;
282 
283     // currency rates oracle interface and singleton keccak256("ITokenExchangeRateOracle")
284     bytes4 internal constant KNOWN_INTERFACE_TOKEN_EXCHANGE_RATE_ORACLE = 0xc6e5349e;
285 
286     // fee disbursal interface and singleton keccak256("IFeeDisbursal")
287     bytes4 internal constant KNOWN_INTERFACE_FEE_DISBURSAL = 0xf4c848e8;
288 
289     // platform portfolio holding equity tokens belonging to NEU holders keccak256("IPlatformPortfolio");
290     bytes4 internal constant KNOWN_INTERFACE_PLATFORM_PORTFOLIO = 0xaa1590d0;
291 
292     // token exchange interface and singleton keccak256("ITokenExchange")
293     bytes4 internal constant KNOWN_INTERFACE_TOKEN_EXCHANGE = 0xddd7a521;
294 
295     // service exchanging euro token for gas ("IGasTokenExchange")
296     bytes4 internal constant KNOWN_INTERFACE_GAS_EXCHANGE = 0x89dbc6de;
297 
298     // access policy interface and singleton keccak256("IAccessPolicy")
299     bytes4 internal constant KNOWN_INTERFACE_ACCESS_POLICY = 0xb05049d9;
300 
301     // euro lock account (upgraded) keccak256("LockedAccount:Euro")
302     bytes4 internal constant KNOWN_INTERFACE_EURO_LOCK = 0x2347a19e;
303 
304     // ether lock account (upgraded) keccak256("LockedAccount:Ether")
305     bytes4 internal constant KNOWN_INTERFACE_ETHER_LOCK = 0x978a6823;
306 
307     // icbm euro lock account keccak256("ICBMLockedAccount:Euro")
308     bytes4 internal constant KNOWN_INTERFACE_ICBM_EURO_LOCK = 0x36021e14;
309 
310     // ether lock account (upgraded) keccak256("ICBMLockedAccount:Ether")
311     bytes4 internal constant KNOWN_INTERFACE_ICBM_ETHER_LOCK = 0x0b58f006;
312 
313     // ether token interface and singleton keccak256("ICBMEtherToken")
314     bytes4 internal constant KNOWN_INTERFACE_ICBM_ETHER_TOKEN = 0xae8b50b9;
315 
316     // euro token interface and singleton keccak256("ICBMEuroToken")
317     bytes4 internal constant KNOWN_INTERFACE_ICBM_EURO_TOKEN = 0xc2c6cd72;
318 
319     // ICBM commitment interface interface and singleton keccak256("ICBMCommitment")
320     bytes4 internal constant KNOWN_INTERFACE_ICBM_COMMITMENT = 0x7f2795ef;
321 
322     // ethereum fork arbiter interface and singleton keccak256("IEthereumForkArbiter")
323     bytes4 internal constant KNOWN_INTERFACE_FORK_ARBITER = 0x2fe7778c;
324 
325     // Platform terms interface and singletong keccak256("PlatformTerms")
326     bytes4 internal constant KNOWN_INTERFACE_PLATFORM_TERMS = 0x75ecd7f8;
327 
328     // for completness we define Universe service keccak256("Universe");
329     bytes4 internal constant KNOWN_INTERFACE_UNIVERSE = 0xbf202454;
330 
331     // ETO commitment interface (collection) keccak256("ICommitment")
332     bytes4 internal constant KNOWN_INTERFACE_COMMITMENT = 0xfa0e0c60;
333 
334     // Equity Token Controller interface (collection) keccak256("IEquityTokenController")
335     bytes4 internal constant KNOWN_INTERFACE_EQUITY_TOKEN_CONTROLLER = 0xfa30b2f1;
336 
337     // Equity Token interface (collection) keccak256("IEquityToken")
338     bytes4 internal constant KNOWN_INTERFACE_EQUITY_TOKEN = 0xab9885bb;
339 }
340 
341 /// @title uniquely identifies deployable (non-abstract) platform contract
342 /// @notice cheap way of assigning implementations to knownInterfaces which represent system services
343 ///         unfortunatelly ERC165 does not include full public interface (ABI) and does not provide way to list implemented interfaces
344 ///         EIP820 still in the making
345 /// @dev ids are generated as follows keccak256("neufund-platform:<contract name>")
346 ///      ids roughly correspond to ABIs
347 contract IContractId {
348     /// @param id defined as above
349     /// @param version implementation version
350     function contractId() public pure returns (bytes32 id, uint256 version);
351 }
352 
353 /// @title granular token controller based on MSnapshotToken observer pattern
354 contract ITokenController {
355 
356     ////////////////////////
357     // Public functions
358     ////////////////////////
359 
360     /// @notice see MTokenTransferController
361     /// @dev additionally passes broker that is executing transaction between from and to
362     ///      for unbrokered transfer, broker == from
363     function onTransfer(address broker, address from, address to, uint256 amount)
364         public
365         constant
366         returns (bool allow);
367 
368     /// @notice see MTokenAllowanceController
369     function onApprove(address owner, address spender, uint256 amount)
370         public
371         constant
372         returns (bool allow);
373 
374     /// @notice see MTokenMint
375     function onGenerateTokens(address sender, address owner, uint256 amount)
376         public
377         constant
378         returns (bool allow);
379 
380     /// @notice see MTokenMint
381     function onDestroyTokens(address sender, address owner, uint256 amount)
382         public
383         constant
384         returns (bool allow);
385 
386     /// @notice controls if sender can change controller to newController
387     /// @dev for this to succeed TYPICALLY current controller must be already migrated to a new one
388     function onChangeTokenController(address sender, address newController)
389         public
390         constant
391         returns (bool);
392 
393     /// @notice overrides spender allowance
394     /// @dev may be used to implemented forced transfers in which token controller may override approved allowance
395     ///      with any > 0 value and then use transferFrom to execute such transfer
396     ///      This by definition creates non-trustless token so do not implement this call if you do not need trustless transfers!
397     ///      Implementer should not allow approve() to be executed if there is an overrride
398     //       Implemented should return allowance() taking into account override
399     function onAllowance(address owner, address spender)
400         public
401         constant
402         returns (uint256 allowanceOverride);
403 }
404 
405 contract IEthereumForkArbiter {
406 
407     ////////////////////////
408     // Events
409     ////////////////////////
410 
411     event LogForkAnnounced(
412         string name,
413         string url,
414         uint256 blockNumber
415     );
416 
417     event LogForkSigned(
418         uint256 blockNumber,
419         bytes32 blockHash
420     );
421 
422     ////////////////////////
423     // Public functions
424     ////////////////////////
425 
426     function nextForkName()
427         public
428         constant
429         returns (string);
430 
431     function nextForkUrl()
432         public
433         constant
434         returns (string);
435 
436     function nextForkBlockNumber()
437         public
438         constant
439         returns (uint256);
440 
441     function lastSignedBlockNumber()
442         public
443         constant
444         returns (uint256);
445 
446     function lastSignedBlockHash()
447         public
448         constant
449         returns (bytes32);
450 
451     function lastSignedTimestamp()
452         public
453         constant
454         returns (uint256);
455 
456 }
457 
458 /**
459  * @title legally binding smart contract
460  * @dev General approach to paring legal and smart contracts:
461  * 1. All terms and agreement are between two parties: here between smart conctract legal representation and platform investor.
462  * 2. Parties are represented by public Ethereum addresses. Platform investor is and address that holds and controls funds and receives and controls Neumark token
463  * 3. Legal agreement has immutable part that corresponds to smart contract code and mutable part that may change for example due to changing regulations or other externalities that smart contract does not control.
464  * 4. There should be a provision in legal document that future changes in mutable part cannot change terms of immutable part.
465  * 5. Immutable part links to corresponding smart contract via its address.
466  * 6. Additional provision should be added if smart contract supports it
467  *  a. Fork provision
468  *  b. Bugfixing provision (unilateral code update mechanism)
469  *  c. Migration provision (bilateral code update mechanism)
470  *
471  * Details on Agreement base class:
472  * 1. We bind smart contract to legal contract by storing uri (preferably ipfs or hash) of the legal contract in the smart contract. It is however crucial that such binding is done by smart contract legal representation so transaction establishing the link must be signed by respective wallet ('amendAgreement')
473  * 2. Mutable part of agreement may change. We should be able to amend the uri later. Previous amendments should not be lost and should be retrievable (`amendAgreement` and 'pastAgreement' functions).
474  * 3. It is up to deriving contract to decide where to put 'acceptAgreement' modifier. However situation where there is no cryptographic proof that given address was really acting in the transaction should be avoided, simplest example being 'to' address in `transfer` function of ERC20.
475  *
476 **/
477 contract IAgreement {
478 
479     ////////////////////////
480     // Events
481     ////////////////////////
482 
483     event LogAgreementAccepted(
484         address indexed accepter
485     );
486 
487     event LogAgreementAmended(
488         address contractLegalRepresentative,
489         string agreementUri
490     );
491 
492     /// @dev should have access restrictions so only contractLegalRepresentative may call
493     function amendAgreement(string agreementUri) public;
494 
495     /// returns information on last amendment of the agreement
496     /// @dev MUST revert if no agreements were set
497     function currentAgreement()
498         public
499         constant
500         returns
501         (
502             address contractLegalRepresentative,
503             uint256 signedBlockTimestamp,
504             string agreementUri,
505             uint256 index
506         );
507 
508     /// returns information on amendment with index
509     /// @dev MAY revert on non existing amendment, indexing starts from 0
510     function pastAgreement(uint256 amendmentIndex)
511         public
512         constant
513         returns
514         (
515             address contractLegalRepresentative,
516             uint256 signedBlockTimestamp,
517             string agreementUri,
518             uint256 index
519         );
520 
521     /// returns the number of block at wchich `signatory` signed agreement
522     /// @dev MUST return 0 if not signed
523     function agreementSignedAtBlock(address signatory)
524         public
525         constant
526         returns (uint256 blockNo);
527 
528     /// returns number of amendments made by contractLegalRepresentative
529     function amendmentsCount()
530         public
531         constant
532         returns (uint256);
533 }
534 
535 /**
536  * @title legally binding smart contract
537  * @dev read IAgreement for details
538 **/
539 contract Agreement is
540     IAgreement,
541     AccessControlled,
542     AccessRoles
543 {
544 
545     ////////////////////////
546     // Type declarations
547     ////////////////////////
548 
549     /// @notice agreement with signature of the platform operator representative
550     struct SignedAgreement {
551         address contractLegalRepresentative;
552         uint256 signedBlockTimestamp;
553         string agreementUri;
554     }
555 
556     ////////////////////////
557     // Immutable state
558     ////////////////////////
559 
560     IEthereumForkArbiter private ETHEREUM_FORK_ARBITER;
561 
562     ////////////////////////
563     // Mutable state
564     ////////////////////////
565 
566     // stores all amendments to the agreement, first amendment is the original
567     SignedAgreement[] private _amendments;
568 
569     // stores block numbers of all addresses that signed the agreement (signatory => block number)
570     mapping(address => uint256) private _signatories;
571 
572     ////////////////////////
573     // Modifiers
574     ////////////////////////
575 
576     /// @notice logs that agreement was accepted by platform user
577     /// @dev intended to be added to functions that if used make 'accepter' origin to enter legally binding agreement
578     modifier acceptAgreement(address accepter) {
579         acceptAgreementInternal(accepter);
580         _;
581     }
582 
583     modifier onlyLegalRepresentative(address legalRepresentative) {
584         require(mCanAmend(legalRepresentative));
585         _;
586     }
587 
588     ////////////////////////
589     // Constructor
590     ////////////////////////
591 
592     constructor(IAccessPolicy accessPolicy, IEthereumForkArbiter forkArbiter)
593         AccessControlled(accessPolicy)
594         internal
595     {
596         require(forkArbiter != IEthereumForkArbiter(0x0));
597         ETHEREUM_FORK_ARBITER = forkArbiter;
598     }
599 
600     ////////////////////////
601     // Public functions
602     ////////////////////////
603 
604     function amendAgreement(string agreementUri)
605         public
606         onlyLegalRepresentative(msg.sender)
607     {
608         SignedAgreement memory amendment = SignedAgreement({
609             contractLegalRepresentative: msg.sender,
610             signedBlockTimestamp: block.timestamp,
611             agreementUri: agreementUri
612         });
613         _amendments.push(amendment);
614         emit LogAgreementAmended(msg.sender, agreementUri);
615     }
616 
617     function ethereumForkArbiter()
618         public
619         constant
620         returns (IEthereumForkArbiter)
621     {
622         return ETHEREUM_FORK_ARBITER;
623     }
624 
625     function currentAgreement()
626         public
627         constant
628         returns
629         (
630             address contractLegalRepresentative,
631             uint256 signedBlockTimestamp,
632             string agreementUri,
633             uint256 index
634         )
635     {
636         require(_amendments.length > 0);
637         uint256 last = _amendments.length - 1;
638         SignedAgreement storage amendment = _amendments[last];
639         return (
640             amendment.contractLegalRepresentative,
641             amendment.signedBlockTimestamp,
642             amendment.agreementUri,
643             last
644         );
645     }
646 
647     function pastAgreement(uint256 amendmentIndex)
648         public
649         constant
650         returns
651         (
652             address contractLegalRepresentative,
653             uint256 signedBlockTimestamp,
654             string agreementUri,
655             uint256 index
656         )
657     {
658         SignedAgreement storage amendment = _amendments[amendmentIndex];
659         return (
660             amendment.contractLegalRepresentative,
661             amendment.signedBlockTimestamp,
662             amendment.agreementUri,
663             amendmentIndex
664         );
665     }
666 
667     function agreementSignedAtBlock(address signatory)
668         public
669         constant
670         returns (uint256 blockNo)
671     {
672         return _signatories[signatory];
673     }
674 
675     function amendmentsCount()
676         public
677         constant
678         returns (uint256)
679     {
680         return _amendments.length;
681     }
682 
683     ////////////////////////
684     // Internal functions
685     ////////////////////////
686 
687     /// provides direct access to derived contract
688     function acceptAgreementInternal(address accepter)
689         internal
690     {
691         if(_signatories[accepter] == 0) {
692             require(_amendments.length > 0);
693             _signatories[accepter] = block.number;
694             emit LogAgreementAccepted(accepter);
695         }
696     }
697 
698     //
699     // MAgreement Internal interface (todo: extract)
700     //
701 
702     /// default amend permission goes to ROLE_PLATFORM_OPERATOR_REPRESENTATIVE
703     function mCanAmend(address legalRepresentative)
704         internal
705         returns (bool)
706     {
707         return accessPolicy().allowed(legalRepresentative, ROLE_PLATFORM_OPERATOR_REPRESENTATIVE, this, msg.sig);
708     }
709 }
710 
711 contract IsContract {
712 
713     ////////////////////////
714     // Internal functions
715     ////////////////////////
716 
717     function isContract(address addr)
718         internal
719         constant
720         returns (bool)
721     {
722         uint256 size;
723         // takes 700 gas
724         assembly { size := extcodesize(addr) }
725         return size > 0;
726     }
727 }
728 
729 contract NeumarkIssuanceCurve {
730 
731     ////////////////////////
732     // Constants
733     ////////////////////////
734 
735     // maximum number of neumarks that may be created
736     uint256 private constant NEUMARK_CAP = 1500000000000000000000000000;
737 
738     // initial neumark reward fraction (controls curve steepness)
739     uint256 private constant INITIAL_REWARD_FRACTION = 6500000000000000000;
740 
741     // stop issuing new Neumarks above this Euro value (as it goes quickly to zero)
742     uint256 private constant ISSUANCE_LIMIT_EUR_ULPS = 8300000000000000000000000000;
743 
744     // approximate curve linearly above this Euro value
745     uint256 private constant LINEAR_APPROX_LIMIT_EUR_ULPS = 2100000000000000000000000000;
746     uint256 private constant NEUMARKS_AT_LINEAR_LIMIT_ULPS = 1499832501287264827896539871;
747 
748     uint256 private constant TOT_LINEAR_NEUMARKS_ULPS = NEUMARK_CAP - NEUMARKS_AT_LINEAR_LIMIT_ULPS;
749     uint256 private constant TOT_LINEAR_EUR_ULPS = ISSUANCE_LIMIT_EUR_ULPS - LINEAR_APPROX_LIMIT_EUR_ULPS;
750 
751     ////////////////////////
752     // Public functions
753     ////////////////////////
754 
755     /// @notice returns additional amount of neumarks issued for euroUlps at totalEuroUlps
756     /// @param totalEuroUlps actual curve position from which neumarks will be issued
757     /// @param euroUlps amount against which neumarks will be issued
758     function incremental(uint256 totalEuroUlps, uint256 euroUlps)
759         public
760         pure
761         returns (uint256 neumarkUlps)
762     {
763         require(totalEuroUlps + euroUlps >= totalEuroUlps);
764         uint256 from = cumulative(totalEuroUlps);
765         uint256 to = cumulative(totalEuroUlps + euroUlps);
766         // as expansion is not monotonic for large totalEuroUlps, assert below may fail
767         // example: totalEuroUlps=1.999999999999999999999000000e+27 and euroUlps=50
768         assert(to >= from);
769         return to - from;
770     }
771 
772     /// @notice returns amount of euro corresponding to burned neumarks
773     /// @param totalEuroUlps actual curve position from which neumarks will be burned
774     /// @param burnNeumarkUlps amount of neumarks to burn
775     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps)
776         public
777         pure
778         returns (uint256 euroUlps)
779     {
780         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
781         require(totalNeumarkUlps >= burnNeumarkUlps);
782         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
783         uint newTotalEuroUlps = cumulativeInverse(fromNmk, 0, totalEuroUlps);
784         // yes, this may overflow due to non monotonic inverse function
785         assert(totalEuroUlps >= newTotalEuroUlps);
786         return totalEuroUlps - newTotalEuroUlps;
787     }
788 
789     /// @notice returns amount of euro corresponding to burned neumarks
790     /// @param totalEuroUlps actual curve position from which neumarks will be burned
791     /// @param burnNeumarkUlps amount of neumarks to burn
792     /// @param minEurUlps euro amount to start inverse search from, inclusive
793     /// @param maxEurUlps euro amount to end inverse search to, inclusive
794     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
795         public
796         pure
797         returns (uint256 euroUlps)
798     {
799         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
800         require(totalNeumarkUlps >= burnNeumarkUlps);
801         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
802         uint newTotalEuroUlps = cumulativeInverse(fromNmk, minEurUlps, maxEurUlps);
803         // yes, this may overflow due to non monotonic inverse function
804         assert(totalEuroUlps >= newTotalEuroUlps);
805         return totalEuroUlps - newTotalEuroUlps;
806     }
807 
808     /// @notice finds total amount of neumarks issued for given amount of Euro
809     /// @dev binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
810     ///     function below is not monotonic
811     function cumulative(uint256 euroUlps)
812         public
813         pure
814         returns(uint256 neumarkUlps)
815     {
816         // Return the cap if euroUlps is above the limit.
817         if (euroUlps >= ISSUANCE_LIMIT_EUR_ULPS) {
818             return NEUMARK_CAP;
819         }
820         // use linear approximation above limit below
821         // binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
822         if (euroUlps >= LINEAR_APPROX_LIMIT_EUR_ULPS) {
823             // (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS) is small so expression does not overflow
824             return NEUMARKS_AT_LINEAR_LIMIT_ULPS + (TOT_LINEAR_NEUMARKS_ULPS * (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS)) / TOT_LINEAR_EUR_ULPS;
825         }
826 
827         // Approximate cap-cap·(1-1/D)^n using the Binomial expansion
828         // http://galileo.phys.virginia.edu/classes/152.mf1i.spring02/Exponential_Function.htm
829         // Function[imax, -CAP*Sum[(-IR*EUR/CAP)^i/Factorial[i], {i, imax}]]
830         // which may be simplified to
831         // Function[imax, -CAP*Sum[(EUR)^i/(Factorial[i]*(-d)^i), {i, 1, imax}]]
832         // where d = cap/initial_reward
833         uint256 d = 230769230769230769230769231; // NEUMARK_CAP / INITIAL_REWARD_FRACTION
834         uint256 term = NEUMARK_CAP;
835         uint256 sum = 0;
836         uint256 denom = d;
837         do assembly {
838             // We use assembler primarily to avoid the expensive
839             // divide-by-zero check solc inserts for the / operator.
840             term  := div(mul(term, euroUlps), denom)
841             sum   := add(sum, term)
842             denom := add(denom, d)
843             // sub next term as we have power of negative value in the binomial expansion
844             term  := div(mul(term, euroUlps), denom)
845             sum   := sub(sum, term)
846             denom := add(denom, d)
847         } while (term != 0);
848         return sum;
849     }
850 
851     /// @notice find issuance curve inverse by binary search
852     /// @param neumarkUlps neumark amount to compute inverse for
853     /// @param minEurUlps minimum search range for the inverse, inclusive
854     /// @param maxEurUlps maxium search range for the inverse, inclusive
855     /// @dev in case of approximate search (no exact inverse) upper element of minimal search range is returned
856     /// @dev in case of many possible inverses, the lowest one will be used (if range permits)
857     /// @dev corresponds to a linear search that returns first euroUlp value that has cumulative() equal or greater than neumarkUlps
858     function cumulativeInverse(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
859         public
860         pure
861         returns (uint256 euroUlps)
862     {
863         require(maxEurUlps >= minEurUlps);
864         require(cumulative(minEurUlps) <= neumarkUlps);
865         require(cumulative(maxEurUlps) >= neumarkUlps);
866         uint256 min = minEurUlps;
867         uint256 max = maxEurUlps;
868 
869         // Binary search
870         while (max > min) {
871             uint256 mid = (max + min) / 2;
872             uint256 val = cumulative(mid);
873             // exact solution should not be used, a late points of the curve when many euroUlps are needed to
874             // increase by one nmkUlp this will lead to  "indeterministic" inverse values that depend on the initial min and max
875             // and further binary division -> you can land at any of the euro value that is mapped to the same nmk value
876             // with condition below removed, binary search will point to the lowest eur value possible which is good because it cannot be exploited even with 0 gas costs
877             /* if (val == neumarkUlps) {
878                 return mid;
879             }*/
880             // NOTE: approximate search (no inverse) must return upper element of the final range
881             //  last step of approximate search is always (min, min+1) so new mid is (2*min+1)/2 => min
882             //  so new min = mid + 1 = max which was upper range. and that ends the search
883             // NOTE: when there are multiple inverses for the same neumarkUlps, the `max` will be dragged down
884             //  by `max = mid` expression to the lowest eur value of inverse. works only for ranges that cover all points of multiple inverse
885             if (val < neumarkUlps) {
886                 min = mid + 1;
887             } else {
888                 max = mid;
889             }
890         }
891         // NOTE: It is possible that there is no inverse
892         //  for example curve(0) = 0 and curve(1) = 6, so
893         //  there is no value y such that curve(y) = 5.
894         //  When there is no inverse, we must return upper element of last search range.
895         //  This has the effect of reversing the curve less when
896         //  burning Neumarks. This ensures that Neumarks can always
897         //  be burned. It also ensure that the total supply of Neumarks
898         //  remains below the cap.
899         return max;
900     }
901 
902     function neumarkCap()
903         public
904         pure
905         returns (uint256)
906     {
907         return NEUMARK_CAP;
908     }
909 
910     function initialRewardFraction()
911         public
912         pure
913         returns (uint256)
914     {
915         return INITIAL_REWARD_FRACTION;
916     }
917 }
918 
919 contract IBasicToken {
920 
921     ////////////////////////
922     // Events
923     ////////////////////////
924 
925     event Transfer(
926         address indexed from,
927         address indexed to,
928         uint256 amount
929     );
930 
931     ////////////////////////
932     // Public functions
933     ////////////////////////
934 
935     /// @dev This function makes it easy to get the total number of tokens
936     /// @return The total number of tokens
937     function totalSupply()
938         public
939         constant
940         returns (uint256);
941 
942     /// @param owner The address that's balance is being requested
943     /// @return The balance of `owner` at the current block
944     function balanceOf(address owner)
945         public
946         constant
947         returns (uint256 balance);
948 
949     /// @notice Send `amount` tokens to `to` from `msg.sender`
950     /// @param to The address of the recipient
951     /// @param amount The amount of tokens to be transferred
952     /// @return Whether the transfer was successful or not
953     function transfer(address to, uint256 amount)
954         public
955         returns (bool success);
956 
957 }
958 
959 /// @title allows deriving contract to recover any token or ether that it has balance of
960 /// @notice note that this opens your contracts to claims from various people saying they lost tokens and they want them back
961 ///     be ready to handle such claims
962 /// @dev use with care!
963 ///     1. ROLE_RECLAIMER is allowed to claim tokens, it's not returning tokens to original owner
964 ///     2. in derived contract that holds any token by design you must override `reclaim` and block such possibility.
965 ///         see ICBMLockedAccount as an example
966 contract Reclaimable is AccessControlled, AccessRoles {
967 
968     ////////////////////////
969     // Constants
970     ////////////////////////
971 
972     IBasicToken constant internal RECLAIM_ETHER = IBasicToken(0x0);
973 
974     ////////////////////////
975     // Public functions
976     ////////////////////////
977 
978     function reclaim(IBasicToken token)
979         public
980         only(ROLE_RECLAIMER)
981     {
982         address reclaimer = msg.sender;
983         if(token == RECLAIM_ETHER) {
984             reclaimer.transfer(address(this).balance);
985         } else {
986             uint256 balance = token.balanceOf(this);
987             require(token.transfer(reclaimer, balance));
988         }
989     }
990 }
991 
992 /// @title advances snapshot id on demand
993 /// @dev see Snapshot folder for implementation examples ie. DailyAndSnapshotable contract
994 contract ISnapshotable {
995 
996     ////////////////////////
997     // Events
998     ////////////////////////
999 
1000     /// @dev should log each new snapshot id created, including snapshots created automatically via MSnapshotPolicy
1001     event LogSnapshotCreated(uint256 snapshotId);
1002 
1003     ////////////////////////
1004     // Public functions
1005     ////////////////////////
1006 
1007     /// always creates new snapshot id which gets returned
1008     /// however, there is no guarantee that any snapshot will be created with this id, this depends on the implementation of MSnaphotPolicy
1009     function createSnapshot()
1010         public
1011         returns (uint256);
1012 
1013     /// upper bound of series snapshotIds for which there's a value
1014     function currentSnapshotId()
1015         public
1016         constant
1017         returns (uint256);
1018 }
1019 
1020 /// @title Abstracts snapshot id creation logics
1021 /// @dev Mixin (internal interface) of the snapshot policy which abstracts snapshot id creation logics from Snapshot contract
1022 /// @dev to be implemented and such implementation should be mixed with Snapshot-derived contract, see EveryBlock for simplest example of implementation and StandardSnapshotToken
1023 contract MSnapshotPolicy {
1024 
1025     ////////////////////////
1026     // Internal functions
1027     ////////////////////////
1028 
1029     // The snapshot Ids need to be strictly increasing.
1030     // Whenever the snaspshot id changes, a new snapshot will be created.
1031     // As long as the same snapshot id is being returned, last snapshot will be updated as this indicates that snapshot id didn't change
1032     //
1033     // Values passed to `hasValueAt` and `valuteAt` are required
1034     // to be less or equal to `mCurrentSnapshotId()`.
1035     function mAdvanceSnapshotId()
1036         internal
1037         returns (uint256);
1038 
1039     // this is a version of mAdvanceSnapshotId that does not modify state but MUST return the same value
1040     // it is required to implement ITokenSnapshots interface cleanly
1041     function mCurrentSnapshotId()
1042         internal
1043         constant
1044         returns (uint256);
1045 
1046 }
1047 
1048 /// @title creates new snapshot id on each day boundary
1049 /// @dev snapshot id is unix timestamp of current day boundary
1050 contract Daily is MSnapshotPolicy {
1051 
1052     ////////////////////////
1053     // Constants
1054     ////////////////////////
1055 
1056     // Floor[2**128 / 1 days]
1057     uint256 private MAX_TIMESTAMP = 3938453320844195178974243141571391;
1058 
1059     ////////////////////////
1060     // Constructor
1061     ////////////////////////
1062 
1063     /// @param start snapshotId from which to start generating values, used to prevent cloning from incompatible schemes
1064     /// @dev start must be for the same day or 0, required for token cloning
1065     constructor(uint256 start) internal {
1066         // 0 is invalid value as we are past unix epoch
1067         if (start > 0) {
1068             uint256 base = dayBase(uint128(block.timestamp));
1069             // must be within current day base
1070             require(start >= base);
1071             // dayBase + 2**128 will not overflow as it is based on block.timestamp
1072             require(start < base + 2**128);
1073         }
1074     }
1075 
1076     ////////////////////////
1077     // Public functions
1078     ////////////////////////
1079 
1080     function snapshotAt(uint256 timestamp)
1081         public
1082         constant
1083         returns (uint256)
1084     {
1085         require(timestamp < MAX_TIMESTAMP);
1086 
1087         return dayBase(uint128(timestamp));
1088     }
1089 
1090     ////////////////////////
1091     // Internal functions
1092     ////////////////////////
1093 
1094     //
1095     // Implements MSnapshotPolicy
1096     //
1097 
1098     function mAdvanceSnapshotId()
1099         internal
1100         returns (uint256)
1101     {
1102         return mCurrentSnapshotId();
1103     }
1104 
1105     function mCurrentSnapshotId()
1106         internal
1107         constant
1108         returns (uint256)
1109     {
1110         // disregard overflows on block.timestamp, see MAX_TIMESTAMP
1111         return dayBase(uint128(block.timestamp));
1112     }
1113 
1114     function dayBase(uint128 timestamp)
1115         internal
1116         pure
1117         returns (uint256)
1118     {
1119         // Round down to the start of the day (00:00 UTC) and place in higher 128bits
1120         return 2**128 * (uint256(timestamp) / 1 days);
1121     }
1122 }
1123 
1124 /// @title creates snapshot id on each day boundary and allows to create additional snapshots within a given day
1125 /// @dev snapshots are encoded in single uint256, where high 128 bits represents a day number (from unix epoch) and low 128 bits represents additional snapshots within given day create via ISnapshotable
1126 contract DailyAndSnapshotable is
1127     Daily,
1128     ISnapshotable
1129 {
1130 
1131     ////////////////////////
1132     // Mutable state
1133     ////////////////////////
1134 
1135     uint256 private _currentSnapshotId;
1136 
1137     ////////////////////////
1138     // Constructor
1139     ////////////////////////
1140 
1141     /// @param start snapshotId from which to start generating values
1142     /// @dev start must be for the same day or 0, required for token cloning
1143     constructor(uint256 start)
1144         internal
1145         Daily(start)
1146     {
1147         if (start > 0) {
1148             _currentSnapshotId = start;
1149         }
1150     }
1151 
1152     ////////////////////////
1153     // Public functions
1154     ////////////////////////
1155 
1156     //
1157     // Implements ISnapshotable
1158     //
1159 
1160     function createSnapshot()
1161         public
1162         returns (uint256)
1163     {
1164         uint256 base = dayBase(uint128(block.timestamp));
1165 
1166         if (base > _currentSnapshotId) {
1167             // New day has started, create snapshot for midnight
1168             _currentSnapshotId = base;
1169         } else {
1170             // within single day, increase counter (assume 2**128 will not be crossed)
1171             _currentSnapshotId += 1;
1172         }
1173 
1174         // Log and return
1175         emit LogSnapshotCreated(_currentSnapshotId);
1176         return _currentSnapshotId;
1177     }
1178 
1179     ////////////////////////
1180     // Internal functions
1181     ////////////////////////
1182 
1183     //
1184     // Implements MSnapshotPolicy
1185     //
1186 
1187     function mAdvanceSnapshotId()
1188         internal
1189         returns (uint256)
1190     {
1191         uint256 base = dayBase(uint128(block.timestamp));
1192 
1193         // New day has started
1194         if (base > _currentSnapshotId) {
1195             _currentSnapshotId = base;
1196             emit LogSnapshotCreated(base);
1197         }
1198 
1199         return _currentSnapshotId;
1200     }
1201 
1202     function mCurrentSnapshotId()
1203         internal
1204         constant
1205         returns (uint256)
1206     {
1207         uint256 base = dayBase(uint128(block.timestamp));
1208 
1209         return base > _currentSnapshotId ? base : _currentSnapshotId;
1210     }
1211 }
1212 
1213 contract ITokenMetadata {
1214 
1215     ////////////////////////
1216     // Public functions
1217     ////////////////////////
1218 
1219     function symbol()
1220         public
1221         constant
1222         returns (string);
1223 
1224     function name()
1225         public
1226         constant
1227         returns (string);
1228 
1229     function decimals()
1230         public
1231         constant
1232         returns (uint8);
1233 }
1234 
1235 /// @title adds token metadata to token contract
1236 /// @dev see Neumark for example implementation
1237 contract TokenMetadata is ITokenMetadata {
1238 
1239     ////////////////////////
1240     // Immutable state
1241     ////////////////////////
1242 
1243     // The Token's name: e.g. DigixDAO Tokens
1244     string private NAME;
1245 
1246     // An identifier: e.g. REP
1247     string private SYMBOL;
1248 
1249     // Number of decimals of the smallest unit
1250     uint8 private DECIMALS;
1251 
1252     // An arbitrary versioning scheme
1253     string private VERSION;
1254 
1255     ////////////////////////
1256     // Constructor
1257     ////////////////////////
1258 
1259     /// @notice Constructor to set metadata
1260     /// @param tokenName Name of the new token
1261     /// @param decimalUnits Number of decimals of the new token
1262     /// @param tokenSymbol Token Symbol for the new token
1263     /// @param version Token version ie. when cloning is used
1264     constructor(
1265         string tokenName,
1266         uint8 decimalUnits,
1267         string tokenSymbol,
1268         string version
1269     )
1270         public
1271     {
1272         NAME = tokenName;                                 // Set the name
1273         SYMBOL = tokenSymbol;                             // Set the symbol
1274         DECIMALS = decimalUnits;                          // Set the decimals
1275         VERSION = version;
1276     }
1277 
1278     ////////////////////////
1279     // Public functions
1280     ////////////////////////
1281 
1282     function name()
1283         public
1284         constant
1285         returns (string)
1286     {
1287         return NAME;
1288     }
1289 
1290     function symbol()
1291         public
1292         constant
1293         returns (string)
1294     {
1295         return SYMBOL;
1296     }
1297 
1298     function decimals()
1299         public
1300         constant
1301         returns (uint8)
1302     {
1303         return DECIMALS;
1304     }
1305 
1306     function version()
1307         public
1308         constant
1309         returns (string)
1310     {
1311         return VERSION;
1312     }
1313 }
1314 
1315 contract IERC20Allowance {
1316 
1317     ////////////////////////
1318     // Events
1319     ////////////////////////
1320 
1321     event Approval(
1322         address indexed owner,
1323         address indexed spender,
1324         uint256 amount
1325     );
1326 
1327     ////////////////////////
1328     // Public functions
1329     ////////////////////////
1330 
1331     /// @dev This function makes it easy to read the `allowed[]` map
1332     /// @param owner The address of the account that owns the token
1333     /// @param spender The address of the account able to transfer the tokens
1334     /// @return Amount of remaining tokens of owner that spender is allowed
1335     ///  to spend
1336     function allowance(address owner, address spender)
1337         public
1338         constant
1339         returns (uint256 remaining);
1340 
1341     /// @notice `msg.sender` approves `spender` to spend `amount` tokens on
1342     ///  its behalf. This is a modified version of the ERC20 approve function
1343     ///  to be a little bit safer
1344     /// @param spender The address of the account able to transfer the tokens
1345     /// @param amount The amount of tokens to be approved for transfer
1346     /// @return True if the approval was successful
1347     function approve(address spender, uint256 amount)
1348         public
1349         returns (bool success);
1350 
1351     /// @notice Send `amount` tokens to `to` from `from` on the condition it
1352     ///  is approved by `from`
1353     /// @param from The address holding the tokens being transferred
1354     /// @param to The address of the recipient
1355     /// @param amount The amount of tokens to be transferred
1356     /// @return True if the transfer was successful
1357     function transferFrom(address from, address to, uint256 amount)
1358         public
1359         returns (bool success);
1360 
1361 }
1362 
1363 contract IERC20Token is IBasicToken, IERC20Allowance {
1364 
1365 }
1366 
1367 /// @title controls spending approvals
1368 /// @dev TokenAllowance observes this interface, Neumark contract implements it
1369 contract MTokenAllowanceController {
1370 
1371     ////////////////////////
1372     // Internal functions
1373     ////////////////////////
1374 
1375     /// @notice Notifies the controller about an approval allowing the
1376     ///  controller to react if desired
1377     /// @param owner The address that calls `approve()`
1378     /// @param spender The spender in the `approve()` call
1379     /// @param amount The amount in the `approve()` call
1380     /// @return False if the controller does not authorize the approval
1381     function mOnApprove(
1382         address owner,
1383         address spender,
1384         uint256 amount
1385     )
1386         internal
1387         returns (bool allow);
1388 
1389     /// @notice Allows to override allowance approved by the owner
1390     ///         Primary role is to enable forced transfers, do not override if you do not like it
1391     ///         Following behavior is expected in the observer
1392     ///         approve() - should revert if mAllowanceOverride() > 0
1393     ///         allowance() - should return mAllowanceOverride() if set
1394     ///         transferFrom() - should override allowance if mAllowanceOverride() > 0
1395     /// @param owner An address giving allowance to spender
1396     /// @param spender An address getting  a right to transfer allowance amount from the owner
1397     /// @return current allowance amount
1398     function mAllowanceOverride(
1399         address owner,
1400         address spender
1401     )
1402         internal
1403         constant
1404         returns (uint256 allowance);
1405 }
1406 
1407 /// @title controls token transfers
1408 /// @dev BasicSnapshotToken observes this interface, Neumark contract implements it
1409 contract MTokenTransferController {
1410 
1411     ////////////////////////
1412     // Internal functions
1413     ////////////////////////
1414 
1415     /// @notice Notifies the controller about a token transfer allowing the
1416     ///  controller to react if desired
1417     /// @param from The origin of the transfer
1418     /// @param to The destination of the transfer
1419     /// @param amount The amount of the transfer
1420     /// @return False if the controller does not authorize the transfer
1421     function mOnTransfer(
1422         address from,
1423         address to,
1424         uint256 amount
1425     )
1426         internal
1427         returns (bool allow);
1428 
1429 }
1430 
1431 /// @title controls approvals and transfers
1432 /// @dev The token controller contract must implement these functions, see Neumark as example
1433 /// @dev please note that controller may be a separate contract that is called from mOnTransfer and mOnApprove functions
1434 contract MTokenController is MTokenTransferController, MTokenAllowanceController {
1435 }
1436 
1437 /// @title internal token transfer function
1438 /// @dev see BasicSnapshotToken for implementation
1439 contract MTokenTransfer {
1440 
1441     ////////////////////////
1442     // Internal functions
1443     ////////////////////////
1444 
1445     /// @dev This is the actual transfer function in the token contract, it can
1446     ///  only be called by other functions in this contract.
1447     /// @param from The address holding the tokens being transferred
1448     /// @param to The address of the recipient
1449     /// @param amount The amount of tokens to be transferred
1450     /// @dev  reverts if transfer was not successful
1451     function mTransfer(
1452         address from,
1453         address to,
1454         uint256 amount
1455     )
1456         internal;
1457 }
1458 
1459 contract IERC677Callback {
1460 
1461     ////////////////////////
1462     // Public functions
1463     ////////////////////////
1464 
1465     // NOTE: This call can be initiated by anyone. You need to make sure that
1466     // it is send by the token (`require(msg.sender == token)`) or make sure
1467     // amount is valid (`require(token.allowance(this) >= amount)`).
1468     function receiveApproval(
1469         address from,
1470         uint256 amount,
1471         address token, // IERC667Token
1472         bytes data
1473     )
1474         public
1475         returns (bool success);
1476 
1477 }
1478 
1479 contract IERC677Allowance is IERC20Allowance {
1480 
1481     ////////////////////////
1482     // Public functions
1483     ////////////////////////
1484 
1485     /// @notice `msg.sender` approves `spender` to send `amount` tokens on
1486     ///  its behalf, and then a function is triggered in the contract that is
1487     ///  being approved, `spender`. This allows users to use their tokens to
1488     ///  interact with contracts in one function call instead of two
1489     /// @param spender The address of the contract able to transfer the tokens
1490     /// @param amount The amount of tokens to be approved for transfer
1491     /// @return True if the function call was successful
1492     function approveAndCall(address spender, uint256 amount, bytes extraData)
1493         public
1494         returns (bool success);
1495 
1496 }
1497 
1498 contract IERC677Token is IERC20Token, IERC677Allowance {
1499 }
1500 
1501 /// @title token spending approval and transfer
1502 /// @dev implements token approval and transfers and exposes relevant part of ERC20 and ERC677 approveAndCall
1503 ///     may be mixed in with any basic token (implementing mTransfer) like BasicSnapshotToken or MintableSnapshotToken to add approval mechanism
1504 ///     observes MTokenAllowanceController interface
1505 ///     observes MTokenTransfer
1506 contract TokenAllowance is
1507     MTokenTransfer,
1508     MTokenAllowanceController,
1509     IERC20Allowance,
1510     IERC677Token
1511 {
1512 
1513     ////////////////////////
1514     // Mutable state
1515     ////////////////////////
1516 
1517     // `allowed` tracks rights to spends others tokens as per ERC20
1518     // owner => spender => amount
1519     mapping (address => mapping (address => uint256)) private _allowed;
1520 
1521     ////////////////////////
1522     // Constructor
1523     ////////////////////////
1524 
1525     constructor()
1526         internal
1527     {
1528     }
1529 
1530     ////////////////////////
1531     // Public functions
1532     ////////////////////////
1533 
1534     //
1535     // Implements IERC20Token
1536     //
1537 
1538     /// @dev This function makes it easy to read the `allowed[]` map
1539     /// @param owner The address of the account that owns the token
1540     /// @param spender The address of the account able to transfer the tokens
1541     /// @return Amount of remaining tokens of _owner that _spender is allowed
1542     ///  to spend
1543     function allowance(address owner, address spender)
1544         public
1545         constant
1546         returns (uint256 remaining)
1547     {
1548         uint256 override = mAllowanceOverride(owner, spender);
1549         if (override > 0) {
1550             return override;
1551         }
1552         return _allowed[owner][spender];
1553     }
1554 
1555     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
1556     ///  its behalf. This is a modified version of the ERC20 approve function
1557     ///  where allowance per spender must be 0 to allow change of such allowance
1558     /// @param spender The address of the account able to transfer the tokens
1559     /// @param amount The amount of tokens to be approved for transfer
1560     /// @return True or reverts, False is never returned
1561     function approve(address spender, uint256 amount)
1562         public
1563         returns (bool success)
1564     {
1565         // Alerts the token controller of the approve function call
1566         require(mOnApprove(msg.sender, spender, amount));
1567 
1568         // To change the approve amount you first have to reduce the addresses`
1569         //  allowance to zero by calling `approve(_spender,0)` if it is not
1570         //  already 0 to mitigate the race condition described here:
1571         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1572         require((amount == 0 || _allowed[msg.sender][spender] == 0) && mAllowanceOverride(msg.sender, spender) == 0);
1573 
1574         _allowed[msg.sender][spender] = amount;
1575         emit Approval(msg.sender, spender, amount);
1576         return true;
1577     }
1578 
1579     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
1580     ///  is approved by `_from`
1581     /// @param from The address holding the tokens being transferred
1582     /// @param to The address of the recipient
1583     /// @param amount The amount of tokens to be transferred
1584     /// @return True if the transfer was successful, reverts in any other case
1585     function transferFrom(address from, address to, uint256 amount)
1586         public
1587         returns (bool success)
1588     {
1589         uint256 allowed = mAllowanceOverride(from, msg.sender);
1590         if (allowed == 0) {
1591             // The standard ERC 20 transferFrom functionality
1592             allowed = _allowed[from][msg.sender];
1593             // yes this will underflow but then we'll revert. will cost gas however so don't underflow
1594             _allowed[from][msg.sender] -= amount;
1595         }
1596         require(allowed >= amount);
1597         mTransfer(from, to, amount);
1598         return true;
1599     }
1600 
1601     //
1602     // Implements IERC677Token
1603     //
1604 
1605     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
1606     ///  its behalf, and then a function is triggered in the contract that is
1607     ///  being approved, `_spender`. This allows users to use their tokens to
1608     ///  interact with contracts in one function call instead of two
1609     /// @param spender The address of the contract able to transfer the tokens
1610     /// @param amount The amount of tokens to be approved for transfer
1611     /// @return True or reverts, False is never returned
1612     function approveAndCall(
1613         address spender,
1614         uint256 amount,
1615         bytes extraData
1616     )
1617         public
1618         returns (bool success)
1619     {
1620         require(approve(spender, amount));
1621 
1622         success = IERC677Callback(spender).receiveApproval(
1623             msg.sender,
1624             amount,
1625             this,
1626             extraData
1627         );
1628         require(success);
1629 
1630         return true;
1631     }
1632 
1633     ////////////////////////
1634     // Internal functions
1635     ////////////////////////
1636 
1637     //
1638     // Implements default MTokenAllowanceController
1639     //
1640 
1641     // no override in default implementation
1642     function mAllowanceOverride(
1643         address /*owner*/,
1644         address /*spender*/
1645     )
1646         internal
1647         constant
1648         returns (uint256)
1649     {
1650         return 0;
1651     }
1652 }
1653 
1654 /// @title Reads and writes snapshots
1655 /// @dev Manages reading and writing a series of values, where each value has assigned a snapshot id for access to historical data
1656 /// @dev may be added to any contract to provide snapshotting mechanism. should be mixed in with any of MSnapshotPolicy implementations to customize snapshot creation mechanics
1657 ///     observes MSnapshotPolicy
1658 /// based on MiniMe token
1659 contract Snapshot is MSnapshotPolicy {
1660 
1661     ////////////////////////
1662     // Types
1663     ////////////////////////
1664 
1665     /// @dev `Values` is the structure that attaches a snapshot id to a
1666     ///  given value, the snapshot id attached is the one that last changed the
1667     ///  value
1668     struct Values {
1669 
1670         // `snapshotId` is the snapshot id that the value was generated at
1671         uint256 snapshotId;
1672 
1673         // `value` at a specific snapshot id
1674         uint256 value;
1675     }
1676 
1677     ////////////////////////
1678     // Internal functions
1679     ////////////////////////
1680 
1681     function hasValue(
1682         Values[] storage values
1683     )
1684         internal
1685         constant
1686         returns (bool)
1687     {
1688         return values.length > 0;
1689     }
1690 
1691     /// @dev makes sure that 'snapshotId' between current snapshot id (mCurrentSnapshotId) and first snapshot id. this guarantees that getValueAt returns value from one of the snapshots.
1692     function hasValueAt(
1693         Values[] storage values,
1694         uint256 snapshotId
1695     )
1696         internal
1697         constant
1698         returns (bool)
1699     {
1700         require(snapshotId <= mCurrentSnapshotId());
1701         return values.length > 0 && values[0].snapshotId <= snapshotId;
1702     }
1703 
1704     /// gets last value in the series
1705     function getValue(
1706         Values[] storage values,
1707         uint256 defaultValue
1708     )
1709         internal
1710         constant
1711         returns (uint256)
1712     {
1713         if (values.length == 0) {
1714             return defaultValue;
1715         } else {
1716             uint256 last = values.length - 1;
1717             return values[last].value;
1718         }
1719     }
1720 
1721     /// @dev `getValueAt` retrieves value at a given snapshot id
1722     /// @param values The series of values being queried
1723     /// @param snapshotId Snapshot id to retrieve the value at
1724     /// @return Value in series being queried
1725     function getValueAt(
1726         Values[] storage values,
1727         uint256 snapshotId,
1728         uint256 defaultValue
1729     )
1730         internal
1731         constant
1732         returns (uint256)
1733     {
1734         require(snapshotId <= mCurrentSnapshotId());
1735 
1736         // Empty value
1737         if (values.length == 0) {
1738             return defaultValue;
1739         }
1740 
1741         // Shortcut for the out of bounds snapshots
1742         uint256 last = values.length - 1;
1743         uint256 lastSnapshot = values[last].snapshotId;
1744         if (snapshotId >= lastSnapshot) {
1745             return values[last].value;
1746         }
1747         uint256 firstSnapshot = values[0].snapshotId;
1748         if (snapshotId < firstSnapshot) {
1749             return defaultValue;
1750         }
1751         // Binary search of the value in the array
1752         uint256 min = 0;
1753         uint256 max = last;
1754         while (max > min) {
1755             uint256 mid = (max + min + 1) / 2;
1756             // must always return lower indice for approximate searches
1757             if (values[mid].snapshotId <= snapshotId) {
1758                 min = mid;
1759             } else {
1760                 max = mid - 1;
1761             }
1762         }
1763         return values[min].value;
1764     }
1765 
1766     /// @dev `setValue` used to update sequence at next snapshot
1767     /// @param values The sequence being updated
1768     /// @param value The new last value of sequence
1769     function setValue(
1770         Values[] storage values,
1771         uint256 value
1772     )
1773         internal
1774     {
1775         // TODO: simplify or break into smaller functions
1776 
1777         uint256 currentSnapshotId = mAdvanceSnapshotId();
1778         // Always create a new entry if there currently is no value
1779         bool empty = values.length == 0;
1780         if (empty) {
1781             // Create a new entry
1782             values.push(
1783                 Values({
1784                     snapshotId: currentSnapshotId,
1785                     value: value
1786                 })
1787             );
1788             return;
1789         }
1790 
1791         uint256 last = values.length - 1;
1792         bool hasNewSnapshot = values[last].snapshotId < currentSnapshotId;
1793         if (hasNewSnapshot) {
1794 
1795             // Do nothing if the value was not modified
1796             bool unmodified = values[last].value == value;
1797             if (unmodified) {
1798                 return;
1799             }
1800 
1801             // Create new entry
1802             values.push(
1803                 Values({
1804                     snapshotId: currentSnapshotId,
1805                     value: value
1806                 })
1807             );
1808         } else {
1809 
1810             // We are updating the currentSnapshotId
1811             bool previousUnmodified = last > 0 && values[last - 1].value == value;
1812             if (previousUnmodified) {
1813                 // Remove current snapshot if current value was set to previous value
1814                 delete values[last];
1815                 values.length--;
1816                 return;
1817             }
1818 
1819             // Overwrite next snapshot entry
1820             values[last].value = value;
1821         }
1822     }
1823 }
1824 
1825 /// @title access to snapshots of a token
1826 /// @notice allows to implement complex token holder rights like revenue disbursal or voting
1827 /// @notice snapshots are series of values with assigned ids. ids increase strictly. particular id mechanism is not assumed
1828 contract ITokenSnapshots {
1829 
1830     ////////////////////////
1831     // Public functions
1832     ////////////////////////
1833 
1834     /// @notice Total amount of tokens at a specific `snapshotId`.
1835     /// @param snapshotId of snapshot at which totalSupply is queried
1836     /// @return The total amount of tokens at `snapshotId`
1837     /// @dev reverts on snapshotIds greater than currentSnapshotId()
1838     /// @dev returns 0 for snapshotIds less than snapshotId of first value
1839     function totalSupplyAt(uint256 snapshotId)
1840         public
1841         constant
1842         returns(uint256);
1843 
1844     /// @dev Queries the balance of `owner` at a specific `snapshotId`
1845     /// @param owner The address from which the balance will be retrieved
1846     /// @param snapshotId of snapshot at which the balance is queried
1847     /// @return The balance at `snapshotId`
1848     function balanceOfAt(address owner, uint256 snapshotId)
1849         public
1850         constant
1851         returns (uint256);
1852 
1853     /// @notice upper bound of series of snapshotIds for which there's a value in series
1854     /// @return snapshotId
1855     function currentSnapshotId()
1856         public
1857         constant
1858         returns (uint256);
1859 }
1860 
1861 /// @title represents link between cloned and parent token
1862 /// @dev when token is clone from other token, initial balances of the cloned token
1863 ///     correspond to balances of parent token at the moment of parent snapshot id specified
1864 /// @notice please note that other tokens beside snapshot token may be cloned
1865 contract IClonedTokenParent is ITokenSnapshots {
1866 
1867     ////////////////////////
1868     // Public functions
1869     ////////////////////////
1870 
1871 
1872     /// @return address of parent token, address(0) if root
1873     /// @dev parent token does not need to clonable, nor snapshottable, just a normal token
1874     function parentToken()
1875         public
1876         constant
1877         returns(IClonedTokenParent parent);
1878 
1879     /// @return snapshot at wchich initial token distribution was taken
1880     function parentSnapshotId()
1881         public
1882         constant
1883         returns(uint256 snapshotId);
1884 }
1885 
1886 /// @title token with snapshots and transfer functionality
1887 /// @dev observes MTokenTransferController interface
1888 ///     observes ISnapshotToken interface
1889 ///     implementes MTokenTransfer interface
1890 contract BasicSnapshotToken is
1891     MTokenTransfer,
1892     MTokenTransferController,
1893     IClonedTokenParent,
1894     IBasicToken,
1895     Snapshot
1896 {
1897     ////////////////////////
1898     // Immutable state
1899     ////////////////////////
1900 
1901     // `PARENT_TOKEN` is the Token address that was cloned to produce this token;
1902     //  it will be 0x0 for a token that was not cloned
1903     IClonedTokenParent private PARENT_TOKEN;
1904 
1905     // `PARENT_SNAPSHOT_ID` is the snapshot id from the Parent Token that was
1906     //  used to determine the initial distribution of the cloned token
1907     uint256 private PARENT_SNAPSHOT_ID;
1908 
1909     ////////////////////////
1910     // Mutable state
1911     ////////////////////////
1912 
1913     // `balances` is the map that tracks the balance of each address, in this
1914     //  contract when the balance changes the snapshot id that the change
1915     //  occurred is also included in the map
1916     mapping (address => Values[]) internal _balances;
1917 
1918     // Tracks the history of the `totalSupply` of the token
1919     Values[] internal _totalSupplyValues;
1920 
1921     ////////////////////////
1922     // Constructor
1923     ////////////////////////
1924 
1925     /// @notice Constructor to create snapshot token
1926     /// @param parentToken Address of the parent token, set to 0x0 if it is a
1927     ///  new token
1928     /// @param parentSnapshotId at which snapshot id clone was created, set to 0 to clone at upper bound
1929     /// @dev please not that as long as cloned token does not overwrite value at current snapshot id, it will refer
1930     ///     to parent token at which this snapshot still may change until snapshot id increases. for that time tokens are coupled
1931     ///     this is prevented by parentSnapshotId value of parentToken.currentSnapshotId() - 1 being the maxiumum
1932     ///     see SnapshotToken.js test to learn consequences coupling has.
1933     constructor(
1934         IClonedTokenParent parentToken,
1935         uint256 parentSnapshotId
1936     )
1937         Snapshot()
1938         internal
1939     {
1940         PARENT_TOKEN = parentToken;
1941         if (parentToken == address(0)) {
1942             require(parentSnapshotId == 0);
1943         } else {
1944             if (parentSnapshotId == 0) {
1945                 require(parentToken.currentSnapshotId() > 0);
1946                 PARENT_SNAPSHOT_ID = parentToken.currentSnapshotId() - 1;
1947             } else {
1948                 PARENT_SNAPSHOT_ID = parentSnapshotId;
1949             }
1950         }
1951     }
1952 
1953     ////////////////////////
1954     // Public functions
1955     ////////////////////////
1956 
1957     //
1958     // Implements IBasicToken
1959     //
1960 
1961     /// @dev This function makes it easy to get the total number of tokens
1962     /// @return The total number of tokens
1963     function totalSupply()
1964         public
1965         constant
1966         returns (uint256)
1967     {
1968         return totalSupplyAtInternal(mCurrentSnapshotId());
1969     }
1970 
1971     /// @param owner The address that's balance is being requested
1972     /// @return The balance of `owner` at the current block
1973     function balanceOf(address owner)
1974         public
1975         constant
1976         returns (uint256 balance)
1977     {
1978         return balanceOfAtInternal(owner, mCurrentSnapshotId());
1979     }
1980 
1981     /// @notice Send `amount` tokens to `to` from `msg.sender`
1982     /// @param to The address of the recipient
1983     /// @param amount The amount of tokens to be transferred
1984     /// @return True if the transfer was successful, reverts in any other case
1985     function transfer(address to, uint256 amount)
1986         public
1987         returns (bool success)
1988     {
1989         mTransfer(msg.sender, to, amount);
1990         return true;
1991     }
1992 
1993     //
1994     // Implements ITokenSnapshots
1995     //
1996 
1997     function totalSupplyAt(uint256 snapshotId)
1998         public
1999         constant
2000         returns(uint256)
2001     {
2002         return totalSupplyAtInternal(snapshotId);
2003     }
2004 
2005     function balanceOfAt(address owner, uint256 snapshotId)
2006         public
2007         constant
2008         returns (uint256)
2009     {
2010         return balanceOfAtInternal(owner, snapshotId);
2011     }
2012 
2013     function currentSnapshotId()
2014         public
2015         constant
2016         returns (uint256)
2017     {
2018         return mCurrentSnapshotId();
2019     }
2020 
2021     //
2022     // Implements IClonedTokenParent
2023     //
2024 
2025     function parentToken()
2026         public
2027         constant
2028         returns(IClonedTokenParent parent)
2029     {
2030         return PARENT_TOKEN;
2031     }
2032 
2033     /// @return snapshot at wchich initial token distribution was taken
2034     function parentSnapshotId()
2035         public
2036         constant
2037         returns(uint256 snapshotId)
2038     {
2039         return PARENT_SNAPSHOT_ID;
2040     }
2041 
2042     //
2043     // Other public functions
2044     //
2045 
2046     /// @notice gets all token balances of 'owner'
2047     /// @dev intended to be called via eth_call where gas limit is not an issue
2048     function allBalancesOf(address owner)
2049         external
2050         constant
2051         returns (uint256[2][])
2052     {
2053         /* very nice and working implementation below,
2054         // copy to memory
2055         Values[] memory values = _balances[owner];
2056         do assembly {
2057             // in memory structs have simple layout where every item occupies uint256
2058             balances := values
2059         } while (false);*/
2060 
2061         Values[] storage values = _balances[owner];
2062         uint256[2][] memory balances = new uint256[2][](values.length);
2063         for(uint256 ii = 0; ii < values.length; ++ii) {
2064             balances[ii] = [values[ii].snapshotId, values[ii].value];
2065         }
2066 
2067         return balances;
2068     }
2069 
2070     ////////////////////////
2071     // Internal functions
2072     ////////////////////////
2073 
2074     function totalSupplyAtInternal(uint256 snapshotId)
2075         internal
2076         constant
2077         returns(uint256)
2078     {
2079         Values[] storage values = _totalSupplyValues;
2080 
2081         // If there is a value, return it, reverts if value is in the future
2082         if (hasValueAt(values, snapshotId)) {
2083             return getValueAt(values, snapshotId, 0);
2084         }
2085 
2086         // Try parent contract at or before the fork
2087         if (address(PARENT_TOKEN) != 0) {
2088             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
2089             return PARENT_TOKEN.totalSupplyAt(earlierSnapshotId);
2090         }
2091 
2092         // Default to an empty balance
2093         return 0;
2094     }
2095 
2096     // get balance at snapshot if with continuation in parent token
2097     function balanceOfAtInternal(address owner, uint256 snapshotId)
2098         internal
2099         constant
2100         returns (uint256)
2101     {
2102         Values[] storage values = _balances[owner];
2103 
2104         // If there is a value, return it, reverts if value is in the future
2105         if (hasValueAt(values, snapshotId)) {
2106             return getValueAt(values, snapshotId, 0);
2107         }
2108 
2109         // Try parent contract at or before the fork
2110         if (PARENT_TOKEN != address(0)) {
2111             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
2112             return PARENT_TOKEN.balanceOfAt(owner, earlierSnapshotId);
2113         }
2114 
2115         // Default to an empty balance
2116         return 0;
2117     }
2118 
2119     //
2120     // Implements MTokenTransfer
2121     //
2122 
2123     /// @dev This is the actual transfer function in the token contract, it can
2124     ///  only be called by other functions in this contract.
2125     /// @param from The address holding the tokens being transferred
2126     /// @param to The address of the recipient
2127     /// @param amount The amount of tokens to be transferred
2128     /// @return True if the transfer was successful, reverts in any other case
2129     function mTransfer(
2130         address from,
2131         address to,
2132         uint256 amount
2133     )
2134         internal
2135     {
2136         // never send to address 0
2137         require(to != address(0));
2138         // block transfers in clone that points to future/current snapshots of parent token
2139         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2140         // Alerts the token controller of the transfer
2141         require(mOnTransfer(from, to, amount));
2142 
2143         // If the amount being transfered is more than the balance of the
2144         //  account the transfer reverts
2145         uint256 previousBalanceFrom = balanceOf(from);
2146         require(previousBalanceFrom >= amount);
2147 
2148         // First update the balance array with the new value for the address
2149         //  sending the tokens
2150         uint256 newBalanceFrom = previousBalanceFrom - amount;
2151         setValue(_balances[from], newBalanceFrom);
2152 
2153         // Then update the balance array with the new value for the address
2154         //  receiving the tokens
2155         uint256 previousBalanceTo = balanceOf(to);
2156         uint256 newBalanceTo = previousBalanceTo + amount;
2157         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
2158         setValue(_balances[to], newBalanceTo);
2159 
2160         // An event to make the transfer easy to find on the blockchain
2161         emit Transfer(from, to, amount);
2162     }
2163 }
2164 
2165 /// @title token generation and destruction
2166 /// @dev internal interface providing token generation and destruction, see MintableSnapshotToken for implementation
2167 contract MTokenMint {
2168 
2169     ////////////////////////
2170     // Internal functions
2171     ////////////////////////
2172 
2173     /// @notice Generates `amount` tokens that are assigned to `owner`
2174     /// @param owner The address that will be assigned the new tokens
2175     /// @param amount The quantity of tokens generated
2176     /// @dev reverts if tokens could not be generated
2177     function mGenerateTokens(address owner, uint256 amount)
2178         internal;
2179 
2180     /// @notice Burns `amount` tokens from `owner`
2181     /// @param owner The address that will lose the tokens
2182     /// @param amount The quantity of tokens to burn
2183     /// @dev reverts if tokens could not be destroyed
2184     function mDestroyTokens(address owner, uint256 amount)
2185         internal;
2186 }
2187 
2188 /// @title basic snapshot token with facitilites to generate and destroy tokens
2189 /// @dev implementes MTokenMint, does not expose any public functions that create/destroy tokens
2190 contract MintableSnapshotToken is
2191     BasicSnapshotToken,
2192     MTokenMint
2193 {
2194 
2195     ////////////////////////
2196     // Constructor
2197     ////////////////////////
2198 
2199     /// @notice Constructor to create a MintableSnapshotToken
2200     /// @param parentToken Address of the parent token, set to 0x0 if it is a
2201     ///  new token
2202     constructor(
2203         IClonedTokenParent parentToken,
2204         uint256 parentSnapshotId
2205     )
2206         BasicSnapshotToken(parentToken, parentSnapshotId)
2207         internal
2208     {}
2209 
2210     /// @notice Generates `amount` tokens that are assigned to `owner`
2211     /// @param owner The address that will be assigned the new tokens
2212     /// @param amount The quantity of tokens generated
2213     function mGenerateTokens(address owner, uint256 amount)
2214         internal
2215     {
2216         // never create for address 0
2217         require(owner != address(0));
2218         // block changes in clone that points to future/current snapshots of patent token
2219         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2220 
2221         uint256 curTotalSupply = totalSupply();
2222         uint256 newTotalSupply = curTotalSupply + amount;
2223         require(newTotalSupply >= curTotalSupply); // Check for overflow
2224 
2225         uint256 previousBalanceTo = balanceOf(owner);
2226         uint256 newBalanceTo = previousBalanceTo + amount;
2227         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
2228 
2229         setValue(_totalSupplyValues, newTotalSupply);
2230         setValue(_balances[owner], newBalanceTo);
2231 
2232         emit Transfer(0, owner, amount);
2233     }
2234 
2235     /// @notice Burns `amount` tokens from `owner`
2236     /// @param owner The address that will lose the tokens
2237     /// @param amount The quantity of tokens to burn
2238     function mDestroyTokens(address owner, uint256 amount)
2239         internal
2240     {
2241         // block changes in clone that points to future/current snapshots of patent token
2242         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2243 
2244         uint256 curTotalSupply = totalSupply();
2245         require(curTotalSupply >= amount);
2246 
2247         uint256 previousBalanceFrom = balanceOf(owner);
2248         require(previousBalanceFrom >= amount);
2249 
2250         uint256 newTotalSupply = curTotalSupply - amount;
2251         uint256 newBalanceFrom = previousBalanceFrom - amount;
2252         setValue(_totalSupplyValues, newTotalSupply);
2253         setValue(_balances[owner], newBalanceFrom);
2254 
2255         emit Transfer(owner, 0, amount);
2256     }
2257 }
2258 
2259 /*
2260     Copyright 2016, Jordi Baylina
2261     Copyright 2017, Remco Bloemen, Marcin Rudolf
2262 
2263     This program is free software: you can redistribute it and/or modify
2264     it under the terms of the GNU General Public License as published by
2265     the Free Software Foundation, either version 3 of the License, or
2266     (at your option) any later version.
2267 
2268     This program is distributed in the hope that it will be useful,
2269     but WITHOUT ANY WARRANTY; without even the implied warranty of
2270     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2271     GNU General Public License for more details.
2272 
2273     You should have received a copy of the GNU General Public License
2274     along with this program.  If not, see <http://www.gnu.org/licenses/>.
2275  */
2276 /// @title StandardSnapshotToken Contract
2277 /// @author Jordi Baylina, Remco Bloemen, Marcin Rudolf
2278 /// @dev This token contract's goal is to make it easy for anyone to clone this
2279 ///  token using the token distribution at a given block, this will allow DAO's
2280 ///  and DApps to upgrade their features in a decentralized manner without
2281 ///  affecting the original token
2282 /// @dev It is ERC20 compliant, but still needs to under go further testing.
2283 /// @dev Various contracts are composed to provide required functionality of this token, different compositions are possible
2284 ///     MintableSnapshotToken provides transfer, miniting and snapshotting functions
2285 ///     TokenAllowance provides approve/transferFrom functions
2286 ///     TokenMetadata adds name, symbol and other token metadata
2287 /// @dev This token is still abstract, Snapshot, BasicSnapshotToken and TokenAllowance observe interfaces that must be implemented
2288 ///     MSnapshotPolicy - particular snapshot id creation mechanism
2289 ///     MTokenController - controlls approvals and transfers
2290 ///     see Neumark as an example
2291 /// @dev implements ERC223 token transfer
2292 contract StandardSnapshotToken is
2293     MintableSnapshotToken,
2294     TokenAllowance
2295 {
2296     ////////////////////////
2297     // Constructor
2298     ////////////////////////
2299 
2300     /// @notice Constructor to create a MiniMeToken
2301     ///  is a new token
2302     /// param tokenName Name of the new token
2303     /// param decimalUnits Number of decimals of the new token
2304     /// param tokenSymbol Token Symbol for the new token
2305     constructor(
2306         IClonedTokenParent parentToken,
2307         uint256 parentSnapshotId
2308     )
2309         MintableSnapshotToken(parentToken, parentSnapshotId)
2310         TokenAllowance()
2311         internal
2312     {}
2313 }
2314 
2315 /// @title old ERC223 callback function
2316 /// @dev as used in Neumark and ICBMEtherToken
2317 contract IERC223LegacyCallback {
2318 
2319     ////////////////////////
2320     // Public functions
2321     ////////////////////////
2322 
2323     function onTokenTransfer(address from, uint256 amount, bytes data)
2324         public;
2325 
2326 }
2327 
2328 contract IERC223Token is IERC20Token, ITokenMetadata {
2329 
2330     /// @dev Departure: We do not log data, it has no advantage over a standard
2331     ///     log event. By sticking to the standard log event we
2332     ///     stay compatible with constracts that expect and ERC20 token.
2333 
2334     // event Transfer(
2335     //    address indexed from,
2336     //    address indexed to,
2337     //    uint256 amount,
2338     //    bytes data);
2339 
2340 
2341     /// @dev Departure: We do not use the callback on regular transfer calls to
2342     ///     stay compatible with constracts that expect and ERC20 token.
2343 
2344     // function transfer(address to, uint256 amount)
2345     //     public
2346     //     returns (bool);
2347 
2348     ////////////////////////
2349     // Public functions
2350     ////////////////////////
2351 
2352     function transfer(address to, uint256 amount, bytes data)
2353         public
2354         returns (bool);
2355 }
2356 
2357 contract Neumark is
2358     AccessControlled,
2359     AccessRoles,
2360     Agreement,
2361     DailyAndSnapshotable,
2362     StandardSnapshotToken,
2363     TokenMetadata,
2364     IERC223Token,
2365     NeumarkIssuanceCurve,
2366     Reclaimable,
2367     IsContract
2368 {
2369 
2370     ////////////////////////
2371     // Constants
2372     ////////////////////////
2373 
2374     string private constant TOKEN_NAME = "Neumark";
2375 
2376     uint8  private constant TOKEN_DECIMALS = 18;
2377 
2378     string private constant TOKEN_SYMBOL = "NEU";
2379 
2380     string private constant VERSION = "NMK_1.0";
2381 
2382     ////////////////////////
2383     // Mutable state
2384     ////////////////////////
2385 
2386     // disable transfers when Neumark is created
2387     bool private _transferEnabled = false;
2388 
2389     // at which point on curve new Neumarks will be created, see NeumarkIssuanceCurve contract
2390     // do not use to get total invested funds. see burn(). this is just a cache for expensive inverse function
2391     uint256 private _totalEurUlps;
2392 
2393     ////////////////////////
2394     // Events
2395     ////////////////////////
2396 
2397     event LogNeumarksIssued(
2398         address indexed owner,
2399         uint256 euroUlps,
2400         uint256 neumarkUlps
2401     );
2402 
2403     event LogNeumarksBurned(
2404         address indexed owner,
2405         uint256 euroUlps,
2406         uint256 neumarkUlps
2407     );
2408 
2409     ////////////////////////
2410     // Constructor
2411     ////////////////////////
2412 
2413     constructor(
2414         IAccessPolicy accessPolicy,
2415         IEthereumForkArbiter forkArbiter
2416     )
2417         AccessRoles()
2418         Agreement(accessPolicy, forkArbiter)
2419         StandardSnapshotToken(
2420             IClonedTokenParent(0x0),
2421             0
2422         )
2423         TokenMetadata(
2424             TOKEN_NAME,
2425             TOKEN_DECIMALS,
2426             TOKEN_SYMBOL,
2427             VERSION
2428         )
2429         DailyAndSnapshotable(0)
2430         NeumarkIssuanceCurve()
2431         Reclaimable()
2432         public
2433     {}
2434 
2435     ////////////////////////
2436     // Public functions
2437     ////////////////////////
2438 
2439     /// @notice issues new Neumarks to msg.sender with reward at current curve position
2440     ///     moves curve position by euroUlps
2441     ///     callable only by ROLE_NEUMARK_ISSUER
2442     function issueForEuro(uint256 euroUlps)
2443         public
2444         only(ROLE_NEUMARK_ISSUER)
2445         acceptAgreement(msg.sender)
2446         returns (uint256)
2447     {
2448         require(_totalEurUlps + euroUlps >= _totalEurUlps);
2449         uint256 neumarkUlps = incremental(_totalEurUlps, euroUlps);
2450         _totalEurUlps += euroUlps;
2451         mGenerateTokens(msg.sender, neumarkUlps);
2452         emit LogNeumarksIssued(msg.sender, euroUlps, neumarkUlps);
2453         return neumarkUlps;
2454     }
2455 
2456     /// @notice used by ROLE_NEUMARK_ISSUER to transer newly issued neumarks
2457     ///     typically to the investor and platform operator
2458     function distribute(address to, uint256 neumarkUlps)
2459         public
2460         only(ROLE_NEUMARK_ISSUER)
2461         acceptAgreement(to)
2462     {
2463         mTransfer(msg.sender, to, neumarkUlps);
2464     }
2465 
2466     /// @notice msg.sender can burn their Neumarks, curve is rolled back using inverse
2467     ///     curve. as a result cost of Neumark gets lower (reward is higher)
2468     function burn(uint256 neumarkUlps)
2469         public
2470         only(ROLE_NEUMARK_BURNER)
2471     {
2472         burnPrivate(neumarkUlps, 0, _totalEurUlps);
2473     }
2474 
2475     /// @notice executes as function above but allows to provide search range for low gas burning
2476     function burn(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2477         public
2478         only(ROLE_NEUMARK_BURNER)
2479     {
2480         burnPrivate(neumarkUlps, minEurUlps, maxEurUlps);
2481     }
2482 
2483     function enableTransfer(bool enabled)
2484         public
2485         only(ROLE_TRANSFER_ADMIN)
2486     {
2487         _transferEnabled = enabled;
2488     }
2489 
2490     function createSnapshot()
2491         public
2492         only(ROLE_SNAPSHOT_CREATOR)
2493         returns (uint256)
2494     {
2495         return DailyAndSnapshotable.createSnapshot();
2496     }
2497 
2498     function transferEnabled()
2499         public
2500         constant
2501         returns (bool)
2502     {
2503         return _transferEnabled;
2504     }
2505 
2506     function totalEuroUlps()
2507         public
2508         constant
2509         returns (uint256)
2510     {
2511         return _totalEurUlps;
2512     }
2513 
2514     function incremental(uint256 euroUlps)
2515         public
2516         constant
2517         returns (uint256 neumarkUlps)
2518     {
2519         return incremental(_totalEurUlps, euroUlps);
2520     }
2521 
2522     //
2523     // Implements IERC223Token with IERC223Callback (onTokenTransfer) callback
2524     //
2525 
2526     // old implementation of ERC223 that was actual when ICBM was deployed
2527     // as Neumark is already deployed this function keeps old behavior for testing
2528     function transfer(address to, uint256 amount, bytes data)
2529         public
2530         returns (bool)
2531     {
2532         // it is necessary to point out implementation to be called
2533         BasicSnapshotToken.mTransfer(msg.sender, to, amount);
2534 
2535         // Notify the receiving contract.
2536         if (isContract(to)) {
2537             IERC223LegacyCallback(to).onTokenTransfer(msg.sender, amount, data);
2538         }
2539         return true;
2540     }
2541 
2542     ////////////////////////
2543     // Internal functions
2544     ////////////////////////
2545 
2546     //
2547     // Implements MTokenController
2548     //
2549 
2550     function mOnTransfer(
2551         address from,
2552         address, // to
2553         uint256 // amount
2554     )
2555         internal
2556         acceptAgreement(from)
2557         returns (bool allow)
2558     {
2559         // must have transfer enabled or msg.sender is Neumark issuer
2560         return _transferEnabled || accessPolicy().allowed(msg.sender, ROLE_NEUMARK_ISSUER, this, msg.sig);
2561     }
2562 
2563     function mOnApprove(
2564         address owner,
2565         address, // spender,
2566         uint256 // amount
2567     )
2568         internal
2569         acceptAgreement(owner)
2570         returns (bool allow)
2571     {
2572         return true;
2573     }
2574 
2575     ////////////////////////
2576     // Private functions
2577     ////////////////////////
2578 
2579     function burnPrivate(uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2580         private
2581     {
2582         uint256 prevEuroUlps = _totalEurUlps;
2583         // burn first in the token to make sure balance/totalSupply is not crossed
2584         mDestroyTokens(msg.sender, burnNeumarkUlps);
2585         _totalEurUlps = cumulativeInverse(totalSupply(), minEurUlps, maxEurUlps);
2586         // actually may overflow on non-monotonic inverse
2587         assert(prevEuroUlps >= _totalEurUlps);
2588         uint256 euroUlps = prevEuroUlps - _totalEurUlps;
2589         emit LogNeumarksBurned(msg.sender, euroUlps, burnNeumarkUlps);
2590     }
2591 }
2592 
2593 /// @title current ERC223 fallback function
2594 /// @dev to be used in all future token contract
2595 /// @dev NEU and ICBMEtherToken (obsolete) are the only contracts that still uses IERC223LegacyCallback
2596 contract IERC223Callback {
2597 
2598     ////////////////////////
2599     // Public functions
2600     ////////////////////////
2601 
2602     function tokenFallback(address from, uint256 amount, bytes data)
2603         public;
2604 
2605 }
2606 
2607 /// @title disburse payment token amount to snapshot token holders
2608 /// @dev payment token received via ERC223 Transfer
2609 contract IFeeDisbursal is IERC223Callback {
2610     // TODO: declare interface
2611 }
2612 
2613 /// @title disburse payment token amount to snapshot token holders
2614 /// @dev payment token received via ERC223 Transfer
2615 contract IPlatformPortfolio is IERC223Callback {
2616     // TODO: declare interface
2617 }
2618 
2619 contract ITokenExchangeRateOracle {
2620     /// @notice provides actual price of 'numeratorToken' in 'denominatorToken'
2621     ///     returns timestamp at which price was obtained in oracle
2622     function getExchangeRate(address numeratorToken, address denominatorToken)
2623         public
2624         constant
2625         returns (uint256 rateFraction, uint256 timestamp);
2626 
2627     /// @notice allows to retreive multiple exchange rates in once call
2628     function getExchangeRates(address[] numeratorTokens, address[] denominatorTokens)
2629         public
2630         constant
2631         returns (uint256[] rateFractions, uint256[] timestamps);
2632 }
2633 
2634 /// @title root of trust and singletons + known interface registry
2635 /// provides a root which holds all interfaces platform trust, this includes
2636 /// singletons - for which accessors are provided
2637 /// collections of known instances of interfaces
2638 /// @dev interfaces are identified by bytes4, see KnownInterfaces.sol
2639 contract Universe is
2640     Agreement,
2641     IContractId,
2642     KnownInterfaces
2643 {
2644     ////////////////////////
2645     // Events
2646     ////////////////////////
2647 
2648     /// raised on any change of singleton instance
2649     /// @dev for convenience we provide previous instance of singleton in replacedInstance
2650     event LogSetSingleton(
2651         bytes4 interfaceId,
2652         address instance,
2653         address replacedInstance
2654     );
2655 
2656     /// raised on add/remove interface instance in collection
2657     event LogSetCollectionInterface(
2658         bytes4 interfaceId,
2659         address instance,
2660         bool isSet
2661     );
2662 
2663     ////////////////////////
2664     // Mutable state
2665     ////////////////////////
2666 
2667     // mapping of known contracts to addresses of singletons
2668     mapping(bytes4 => address) private _singletons;
2669 
2670     // mapping of known interfaces to collections of contracts
2671     mapping(bytes4 =>
2672         mapping(address => bool)) private _collections; // solium-disable-line indentation
2673 
2674     // known instances
2675     mapping(address => bytes4[]) private _instances;
2676 
2677 
2678     ////////////////////////
2679     // Constructor
2680     ////////////////////////
2681 
2682     constructor(
2683         IAccessPolicy accessPolicy,
2684         IEthereumForkArbiter forkArbiter
2685     )
2686         Agreement(accessPolicy, forkArbiter)
2687         public
2688     {
2689         setSingletonPrivate(KNOWN_INTERFACE_ACCESS_POLICY, accessPolicy);
2690         setSingletonPrivate(KNOWN_INTERFACE_FORK_ARBITER, forkArbiter);
2691     }
2692 
2693     ////////////////////////
2694     // Public methods
2695     ////////////////////////
2696 
2697     /// get singleton instance for 'interfaceId'
2698     function getSingleton(bytes4 interfaceId)
2699         public
2700         constant
2701         returns (address)
2702     {
2703         return _singletons[interfaceId];
2704     }
2705 
2706     function getManySingletons(bytes4[] interfaceIds)
2707         public
2708         constant
2709         returns (address[])
2710     {
2711         address[] memory addresses = new address[](interfaceIds.length);
2712         uint256 idx;
2713         while(idx < interfaceIds.length) {
2714             addresses[idx] = _singletons[interfaceIds[idx]];
2715             idx += 1;
2716         }
2717         return addresses;
2718     }
2719 
2720     /// checks of 'instance' is instance of interface 'interfaceId'
2721     function isSingleton(bytes4 interfaceId, address instance)
2722         public
2723         constant
2724         returns (bool)
2725     {
2726         return _singletons[interfaceId] == instance;
2727     }
2728 
2729     /// checks if 'instance' is one of instances of 'interfaceId'
2730     function isInterfaceCollectionInstance(bytes4 interfaceId, address instance)
2731         public
2732         constant
2733         returns (bool)
2734     {
2735         return _collections[interfaceId][instance];
2736     }
2737 
2738     function isAnyOfInterfaceCollectionInstance(bytes4[] interfaceIds, address instance)
2739         public
2740         constant
2741         returns (bool)
2742     {
2743         uint256 idx;
2744         while(idx < interfaceIds.length) {
2745             if (_collections[interfaceIds[idx]][instance]) {
2746                 return true;
2747             }
2748             idx += 1;
2749         }
2750         return false;
2751     }
2752 
2753     /// gets all interfaces of given instance
2754     function getInterfacesOfInstance(address instance)
2755         public
2756         constant
2757         returns (bytes4[] interfaces)
2758     {
2759         return _instances[instance];
2760     }
2761 
2762     /// sets 'instance' of singleton with interface 'interfaceId'
2763     function setSingleton(bytes4 interfaceId, address instance)
2764         public
2765         only(ROLE_UNIVERSE_MANAGER)
2766     {
2767         setSingletonPrivate(interfaceId, instance);
2768     }
2769 
2770     /// convenience method for setting many singleton instances
2771     function setManySingletons(bytes4[] interfaceIds, address[] instances)
2772         public
2773         only(ROLE_UNIVERSE_MANAGER)
2774     {
2775         require(interfaceIds.length == instances.length);
2776         uint256 idx;
2777         while(idx < interfaceIds.length) {
2778             setSingletonPrivate(interfaceIds[idx], instances[idx]);
2779             idx += 1;
2780         }
2781     }
2782 
2783     /// set or unset 'instance' with 'interfaceId' in collection of instances
2784     function setCollectionInterface(bytes4 interfaceId, address instance, bool set)
2785         public
2786         only(ROLE_UNIVERSE_MANAGER)
2787     {
2788         setCollectionPrivate(interfaceId, instance, set);
2789     }
2790 
2791     /// set or unset 'instance' in many collections of instances
2792     function setInterfaceInManyCollections(bytes4[] interfaceIds, address instance, bool set)
2793         public
2794         only(ROLE_UNIVERSE_MANAGER)
2795     {
2796         uint256 idx;
2797         while(idx < interfaceIds.length) {
2798             setCollectionPrivate(interfaceIds[idx], instance, set);
2799             idx += 1;
2800         }
2801     }
2802 
2803     /// set or unset array of collection
2804     function setCollectionsInterfaces(bytes4[] interfaceIds, address[] instances, bool[] set_flags)
2805         public
2806         only(ROLE_UNIVERSE_MANAGER)
2807     {
2808         require(interfaceIds.length == instances.length);
2809         require(interfaceIds.length == set_flags.length);
2810         uint256 idx;
2811         while(idx < interfaceIds.length) {
2812             setCollectionPrivate(interfaceIds[idx], instances[idx], set_flags[idx]);
2813             idx += 1;
2814         }
2815     }
2816 
2817     //
2818     // Implements IContractId
2819     //
2820 
2821     function contractId() public pure returns (bytes32 id, uint256 version) {
2822         return (0x8b57bfe21a3ef4854e19d702063b6cea03fa514162f8ff43fde551f06372fefd, 0);
2823     }
2824 
2825     ////////////////////////
2826     // Getters
2827     ////////////////////////
2828 
2829     function accessPolicy() public constant returns (IAccessPolicy) {
2830         return IAccessPolicy(_singletons[KNOWN_INTERFACE_ACCESS_POLICY]);
2831     }
2832 
2833     function forkArbiter() public constant returns (IEthereumForkArbiter) {
2834         return IEthereumForkArbiter(_singletons[KNOWN_INTERFACE_FORK_ARBITER]);
2835     }
2836 
2837     function neumark() public constant returns (Neumark) {
2838         return Neumark(_singletons[KNOWN_INTERFACE_NEUMARK]);
2839     }
2840 
2841     function etherToken() public constant returns (IERC223Token) {
2842         return IERC223Token(_singletons[KNOWN_INTERFACE_ETHER_TOKEN]);
2843     }
2844 
2845     function euroToken() public constant returns (IERC223Token) {
2846         return IERC223Token(_singletons[KNOWN_INTERFACE_EURO_TOKEN]);
2847     }
2848 
2849     function etherLock() public constant returns (address) {
2850         return _singletons[KNOWN_INTERFACE_ETHER_LOCK];
2851     }
2852 
2853     function euroLock() public constant returns (address) {
2854         return _singletons[KNOWN_INTERFACE_EURO_LOCK];
2855     }
2856 
2857     function icbmEtherLock() public constant returns (address) {
2858         return _singletons[KNOWN_INTERFACE_ICBM_ETHER_LOCK];
2859     }
2860 
2861     function icbmEuroLock() public constant returns (address) {
2862         return _singletons[KNOWN_INTERFACE_ICBM_EURO_LOCK];
2863     }
2864 
2865     function identityRegistry() public constant returns (address) {
2866         return IIdentityRegistry(_singletons[KNOWN_INTERFACE_IDENTITY_REGISTRY]);
2867     }
2868 
2869     function tokenExchangeRateOracle() public constant returns (address) {
2870         return ITokenExchangeRateOracle(_singletons[KNOWN_INTERFACE_TOKEN_EXCHANGE_RATE_ORACLE]);
2871     }
2872 
2873     function feeDisbursal() public constant returns (address) {
2874         return IFeeDisbursal(_singletons[KNOWN_INTERFACE_FEE_DISBURSAL]);
2875     }
2876 
2877     function platformPortfolio() public constant returns (address) {
2878         return IPlatformPortfolio(_singletons[KNOWN_INTERFACE_PLATFORM_PORTFOLIO]);
2879     }
2880 
2881     function tokenExchange() public constant returns (address) {
2882         return _singletons[KNOWN_INTERFACE_TOKEN_EXCHANGE];
2883     }
2884 
2885     function gasExchange() public constant returns (address) {
2886         return _singletons[KNOWN_INTERFACE_GAS_EXCHANGE];
2887     }
2888 
2889     function platformTerms() public constant returns (address) {
2890         return _singletons[KNOWN_INTERFACE_PLATFORM_TERMS];
2891     }
2892 
2893     ////////////////////////
2894     // Private methods
2895     ////////////////////////
2896 
2897     function setSingletonPrivate(bytes4 interfaceId, address instance)
2898         private
2899     {
2900         require(interfaceId != KNOWN_INTERFACE_UNIVERSE, "NF_UNI_NO_UNIVERSE_SINGLETON");
2901         address replacedInstance = _singletons[interfaceId];
2902         // do nothing if not changing
2903         if (replacedInstance != instance) {
2904             dropInstance(replacedInstance, interfaceId);
2905             addInstance(instance, interfaceId);
2906             _singletons[interfaceId] = instance;
2907         }
2908 
2909         emit LogSetSingleton(interfaceId, instance, replacedInstance);
2910     }
2911 
2912     function setCollectionPrivate(bytes4 interfaceId, address instance, bool set)
2913         private
2914     {
2915         // do nothing if not changing
2916         if (_collections[interfaceId][instance] == set) {
2917             return;
2918         }
2919         _collections[interfaceId][instance] = set;
2920         if (set) {
2921             addInstance(instance, interfaceId);
2922         } else {
2923             dropInstance(instance, interfaceId);
2924         }
2925         emit LogSetCollectionInterface(interfaceId, instance, set);
2926     }
2927 
2928     function addInstance(address instance, bytes4 interfaceId)
2929         private
2930     {
2931         if (instance == address(0)) {
2932             // do not add null instance
2933             return;
2934         }
2935         bytes4[] storage current = _instances[instance];
2936         uint256 idx;
2937         while(idx < current.length) {
2938             // instancy has this interface already, do nothing
2939             if (current[idx] == interfaceId)
2940                 return;
2941             idx += 1;
2942         }
2943         // new interface
2944         current.push(interfaceId);
2945     }
2946 
2947     function dropInstance(address instance, bytes4 interfaceId)
2948         private
2949     {
2950         if (instance == address(0)) {
2951             // do not drop null instance
2952             return;
2953         }
2954         bytes4[] storage current = _instances[instance];
2955         uint256 idx;
2956         uint256 last = current.length - 1;
2957         while(idx <= last) {
2958             if (current[idx] == interfaceId) {
2959                 // delete element
2960                 if (idx < last) {
2961                     // if not last element move last element to idx being deleted
2962                     current[idx] = current[last];
2963                 }
2964                 // delete last element
2965                 current.length -= 1;
2966                 return;
2967             }
2968             idx += 1;
2969         }
2970     }
2971 }
2972 
2973 /// @title token controller for EuroToken
2974 /// @notice permissions for transfer are divided in 'from' permission (address sends funds)
2975 ///  and 'to' permission (address receives funds). both transfer sides must have appropriate permission for transfer to happen
2976 ///  also controls for minimum amounts in deposit and withdraw permissions
2977 ///  whitelist several known singleton contracts from Universe to be able to receive and send EUR-T
2978 /// @dev if contracts are replaced in universe, `applySettings` function must be called
2979 contract EuroTokenController is
2980     ITokenController,
2981     IContractId,
2982     AccessControlled,
2983     AccessRoles,
2984     IdentityRecord,
2985     KnownInterfaces
2986 {
2987 
2988     ////////////////////////
2989     // Events
2990     ////////////////////////
2991 
2992     event LogAllowedFromAddress(
2993         address indexed from,
2994         bool allowed
2995     );
2996 
2997     event LogAllowedToAddress(
2998         address indexed to,
2999         bool allowed
3000     );
3001 
3002     event LogUniverseReloaded();
3003 
3004     ////////////////////////
3005     // Constants
3006     ////////////////////////
3007 
3008     bytes4[] private TRANSFER_ALLOWED_INTERFACES = [KNOWN_INTERFACE_COMMITMENT, KNOWN_INTERFACE_EQUITY_TOKEN_CONTROLLER];
3009 
3010     ////////////////////////
3011     // Immutable state
3012     ////////////////////////
3013 
3014     Universe private UNIVERSE;
3015 
3016     ////////////////////////
3017     // Mutable state
3018     ////////////////////////
3019 
3020     // a list of addresses that are allowed to receive EUR-T
3021     mapping(address => bool) private _allowedTransferTo;
3022 
3023     // a list of of addresses that are allowed to send EUR-T
3024     mapping(address => bool) private _allowedTransferFrom;
3025 
3026     // min deposit amount
3027     uint256 private _minDepositAmountEurUlps;
3028 
3029     // min withdraw amount
3030     uint256 private _minWithdrawAmountEurUlps;
3031 
3032     // max token exchange can make for gas purchase
3033     uint256 private _maxSimpleExchangeAllowanceEurUlps;
3034 
3035     // identity registry
3036     IIdentityRegistry private _identityRegistry;
3037 
3038     ////////////////////////
3039     // Constructor
3040     ////////////////////////
3041 
3042     constructor(
3043         Universe universe
3044     )
3045         AccessControlled(universe.accessPolicy())
3046         public
3047     {
3048         UNIVERSE = universe;
3049     }
3050 
3051     ////////////////////////
3052     // Public Functions
3053     ////////////////////////
3054 
3055     /// @notice enables or disables address to be receipient of EUR-T
3056     function setAllowedTransferTo(address to, bool allowed)
3057         public
3058         only(ROLE_EURT_LEGAL_MANAGER)
3059     {
3060         setAllowedTransferToPrivate(to, allowed);
3061     }
3062 
3063     /// @notice enables or disables address to be sender of EUR-T
3064     function setAllowedTransferFrom(address from, bool allowed)
3065         public
3066         only(ROLE_EURT_LEGAL_MANAGER)
3067     {
3068         setAllowedTransferFromPrivate(from, allowed);
3069     }
3070 
3071     /// @notice sets limits and whitelists contracts from universe
3072     function applySettings(
3073         uint256 minDepositAmountEurUlps,
3074         uint256 minWithdrawAmountEurUlps,
3075         uint256 maxSimpleExchangeAllowanceEurUlps
3076     )
3077         public
3078         only(ROLE_EURT_LEGAL_MANAGER)
3079     {
3080         applySettingsPrivate(
3081             minDepositAmountEurUlps,
3082             minWithdrawAmountEurUlps,
3083             maxSimpleExchangeAllowanceEurUlps
3084         );
3085     }
3086 
3087     //
3088     // Public Getters
3089     //
3090 
3091     function allowedTransferTo(address to)
3092         public
3093         constant
3094         returns (bool)
3095     {
3096         return _allowedTransferTo[to];
3097     }
3098 
3099     function allowedTransferFrom(address from)
3100         public
3101         constant
3102         returns (bool)
3103     {
3104         return _allowedTransferFrom[from];
3105     }
3106 
3107     function minDepositAmountEurUlps()
3108         public
3109         constant
3110         returns (uint256)
3111     {
3112         return _minDepositAmountEurUlps;
3113     }
3114 
3115     function minWithdrawAmountEurUlps()
3116         public
3117         constant
3118         returns (uint256)
3119     {
3120         return _minWithdrawAmountEurUlps;
3121     }
3122 
3123     function maxSimpleExchangeAllowanceEurUlps()
3124         public
3125         constant
3126         returns (uint256)
3127     {
3128         return _maxSimpleExchangeAllowanceEurUlps;
3129     }
3130 
3131     //
3132     // Implements ITokenController
3133     //
3134 
3135     function onTransfer(address broker, address from, address to, uint256 /*amount*/)
3136         public
3137         constant
3138         returns (bool allow)
3139     {
3140         // detect brokered (transferFrom) transfer when from is different address executing transfer
3141         bool isBrokeredTransfer = broker != from;
3142         // "from" must be allowed to transfer from to "to"
3143         bool isTransferAllowed = isTransferAllowedPrivate(from, to, isBrokeredTransfer);
3144         // broker must have direct permission to transfer from
3145         bool isBrokerAllowed = !isBrokeredTransfer || _allowedTransferFrom[broker];
3146         return isTransferAllowed && isBrokerAllowed;
3147     }
3148 
3149     /// always approve
3150     function onApprove(address, address, uint256)
3151         public
3152         constant
3153         returns (bool allow)
3154     {
3155         return true;
3156     }
3157 
3158     /// allows to deposit if user has kyc and deposit is >= minimum
3159     function onGenerateTokens(address /*sender*/, address owner, uint256 amount)
3160         public
3161         constant
3162         returns (bool allow)
3163     {
3164         if (amount < _minDepositAmountEurUlps) {
3165             return false;
3166         }
3167         if(_allowedTransferTo[owner]) {
3168             return true;
3169         }
3170         IdentityClaims memory claims = deserializeClaims(_identityRegistry.getClaims(owner));
3171         return claims.isVerified && !claims.accountFrozen;
3172     }
3173 
3174     /// allow to withdraw if user has a valid bank account, kyc and amount >= minium
3175     function onDestroyTokens(address /*sender*/, address owner, uint256 amount)
3176         public
3177         constant
3178         returns (bool allow)
3179     {
3180         if (amount < _minWithdrawAmountEurUlps) {
3181             return false;
3182         }
3183         if(_allowedTransferFrom[owner]) {
3184             return true;
3185         }
3186         IdentityClaims memory claims = deserializeClaims(_identityRegistry.getClaims(owner));
3187         return claims.isVerified && !claims.accountFrozen && claims.hasBankAccount;
3188     }
3189 
3190     function onChangeTokenController(address sender, address newController)
3191         public
3192         constant
3193         returns (bool)
3194     {
3195         // can change if original sender (sender) has role on ROLE_EURT_LEGAL_MANAGER on msg.sender (which is euro token)
3196         // this replaces only() modifier on euro token method
3197         return accessPolicy().allowed(sender, ROLE_EURT_LEGAL_MANAGER, msg.sender, msg.sig) && newController != address(0x0);
3198     }
3199 
3200     /// always allow to transfer from owner to simple exchange lte _maxSimpleExchangeAllowanceEurUlps
3201     function onAllowance(address /*owner*/, address spender)
3202         public
3203         constant
3204         returns (uint256)
3205     {
3206         address exchange = UNIVERSE.gasExchange();
3207         if (spender == address(exchange)) {
3208             // override on allowance to simple exchange
3209             return _maxSimpleExchangeAllowanceEurUlps;
3210         } else {
3211             return 0; // no override
3212         }
3213     }
3214 
3215     //
3216     // Implements IContractId
3217     //
3218 
3219     function contractId() public pure returns (bytes32 id, uint256 version) {
3220         return (0xddc22bc86ca8ebf8229756d3fd83791c143630f28e301fef65bbe3070a377f2a, 0);
3221     }
3222 
3223     ////////////////////////
3224     // Private Functions
3225     ////////////////////////
3226 
3227     function applySettingsPrivate(
3228         uint256 pMinDepositAmountEurUlps,
3229         uint256 pMinWithdrawAmountEurUlps,
3230         uint256 pMaxSimpleExchangeAllowanceEurUlps
3231     )
3232         private
3233     {
3234         _identityRegistry = IIdentityRegistry(UNIVERSE.identityRegistry());
3235         allowFromUniverse();
3236         _minDepositAmountEurUlps = pMinDepositAmountEurUlps;
3237         _minWithdrawAmountEurUlps = pMinWithdrawAmountEurUlps;
3238         _maxSimpleExchangeAllowanceEurUlps = pMaxSimpleExchangeAllowanceEurUlps;
3239     }
3240 
3241     /// enables to and from transfers for several Universe singletons
3242     function allowFromUniverse()
3243         private
3244     {
3245         // contracts below may send funds
3246         // euro lock must be able to send (invest)
3247         setAllowedTransferFromPrivate(UNIVERSE.euroLock(), true);
3248         // fee disbursal must be able to pay out
3249         setAllowedTransferFromPrivate(UNIVERSE.feeDisbursal(), true);
3250         // gas exchange must be able to act as a broker (from)
3251         setAllowedTransferFromPrivate(UNIVERSE.gasExchange(), true);
3252 
3253         // contracts below may receive funds
3254         // fee disbursal may receive funds to disburse
3255         setAllowedTransferToPrivate(UNIVERSE.feeDisbursal(), true);
3256         // euro lock may receive refunds
3257         setAllowedTransferToPrivate(UNIVERSE.euroLock(), true);
3258         // gas exchange must be able to receive euro token (as payment)
3259         setAllowedTransferToPrivate(UNIVERSE.gasExchange(), true);
3260 
3261         emit LogUniverseReloaded();
3262     }
3263 
3264     function setAllowedTransferToPrivate(address to, bool allowed)
3265         private
3266     {
3267         _allowedTransferTo[to] = allowed;
3268         emit LogAllowedToAddress(to, allowed);
3269     }
3270 
3271     function setAllowedTransferFromPrivate(address from, bool allowed)
3272         private
3273     {
3274         _allowedTransferFrom[from] = allowed;
3275         emit LogAllowedFromAddress(from, allowed);
3276     }
3277 
3278     // optionally allows peer to peer transfers of Verified users: for the transferFrom check
3279     function isTransferAllowedPrivate(address from, address to, bool allowPeerTransfers)
3280         private
3281         constant
3282         returns (bool)
3283     {
3284         // check if both parties are explicitely allowed for transfers
3285         bool explicitFrom = _allowedTransferFrom[from];
3286         bool explicitTo = _allowedTransferTo[to];
3287         if (explicitFrom && explicitTo) {
3288             return true;
3289         }
3290         // try to resolve 'from'
3291         if (!explicitFrom) {
3292             IdentityClaims memory claimsFrom = deserializeClaims(_identityRegistry.getClaims(from));
3293             explicitFrom = claimsFrom.isVerified && !claimsFrom.accountFrozen;
3294         }
3295         if (!explicitFrom) {
3296             // all ETO and ETC contracts may send funds (for example: refund)
3297             explicitFrom = UNIVERSE.isAnyOfInterfaceCollectionInstance(TRANSFER_ALLOWED_INTERFACES, from);
3298         }
3299         if (!explicitFrom) {
3300             // from will not be resolved, return immediately
3301             return false;
3302         }
3303         if (!explicitTo) {
3304             // all ETO and ETC contracts may receive funds
3305             explicitTo = UNIVERSE.isAnyOfInterfaceCollectionInstance(TRANSFER_ALLOWED_INTERFACES, to);
3306         }
3307         if (!explicitTo) {
3308             // if not, `to` address must have kyc (all addresses with KYC may receive transfers)
3309             IdentityClaims memory claims = deserializeClaims(_identityRegistry.getClaims(to));
3310             explicitTo = claims.isVerified && !claims.accountFrozen;
3311         }
3312         if (allowPeerTransfers) {
3313             return explicitTo;
3314         }
3315         if(claims.isVerified && !claims.accountFrozen && claimsFrom.isVerified && !claimsFrom.accountFrozen) {
3316             // user to user transfer not allowed
3317             return false;
3318         }
3319         // we only get here if explicitFrom was true
3320         return explicitTo;
3321     }
3322 }