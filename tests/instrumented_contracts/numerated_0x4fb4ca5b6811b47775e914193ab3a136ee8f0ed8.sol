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
187 
188     // allows to disburse to the fee disbursal contract keccak("Disburser")
189     bytes32 internal constant ROLE_DISBURSER = 0xd7ea6093d11d866c9e8449f8bffd9da1387c530ee40ad54f0641425bb0ca33b7;
190 
191     // allows to manage feedisbursal controller keccak("DisbursalManager")
192     bytes32 internal constant ROLE_DISBURSAL_MANAGER = 0x677f87f7b7ef7c97e42a7e6c85c295cf020c9f11eea1e49f6bf847d7aeae1475;
193 
194 }
195 
196 /// @title describes layout of claims in 256bit records stored for identities
197 /// @dev intended to be derived by contracts requiring access to particular claims
198 contract IdentityRecord {
199 
200     ////////////////////////
201     // Types
202     ////////////////////////
203 
204     /// @dev here the idea is to have claims of size of uint256 and use this struct
205     ///     to translate in and out of this struct. until we do not cross uint256 we
206     ///     have binary compatibility
207     struct IdentityClaims {
208         bool isVerified; // 1 bit
209         bool isSophisticatedInvestor; // 1 bit
210         bool hasBankAccount; // 1 bit
211         bool accountFrozen; // 1 bit
212         // uint252 reserved
213     }
214 
215     ////////////////////////
216     // Internal functions
217     ////////////////////////
218 
219     /// translates uint256 to struct
220     function deserializeClaims(bytes32 data) internal pure returns (IdentityClaims memory claims) {
221         // for memory layout of struct, each field below word length occupies whole word
222         assembly {
223             mstore(claims, and(data, 0x1))
224             mstore(add(claims, 0x20), div(and(data, 0x2), 0x2))
225             mstore(add(claims, 0x40), div(and(data, 0x4), 0x4))
226             mstore(add(claims, 0x60), div(and(data, 0x8), 0x8))
227         }
228     }
229 }
230 
231 
232 /// @title interface storing and retrieve 256bit claims records for identity
233 /// actual format of record is decoupled from storage (except maximum size)
234 contract IIdentityRegistry {
235 
236     ////////////////////////
237     // Events
238     ////////////////////////
239 
240     /// provides information on setting claims
241     event LogSetClaims(
242         address indexed identity,
243         bytes32 oldClaims,
244         bytes32 newClaims
245     );
246 
247     ////////////////////////
248     // Public functions
249     ////////////////////////
250 
251     /// get claims for identity
252     function getClaims(address identity) public constant returns (bytes32);
253 
254     /// set claims for identity
255     /// @dev odlClaims and newClaims used for optimistic locking. to override with newClaims
256     ///     current claims must be oldClaims
257     function setClaims(address identity, bytes32 oldClaims, bytes32 newClaims) public;
258 }
259 
260 /// @title known interfaces (services) of the platform
261 /// "known interface" is a unique id of service provided by the platform and discovered via Universe contract
262 ///  it does not refer to particular contract/interface ABI, particular service may be delivered via different implementations
263 ///  however for a few contracts we commit platform to particular implementation (all ICBM Contracts, Universe itself etc.)
264 /// @dev constants are kept in CODE not in STORAGE so they are comparatively cheap
265 contract KnownInterfaces {
266 
267     ////////////////////////
268     // Constants
269     ////////////////////////
270 
271     // NOTE: All interface are set to the keccak256 hash of the
272     // CamelCased interface or singleton name, i.e.
273     // KNOWN_INTERFACE_NEUMARK = keccak256("Neumark")
274 
275     // EIP 165 + EIP 820 should be use instead but it seems they are far from finished
276     // also interface signature should be build automatically by solidity. otherwise it is a pure hassle
277 
278     // neumark token interface and sigleton keccak256("Neumark")
279     bytes4 internal constant KNOWN_INTERFACE_NEUMARK = 0xeb41a1bd;
280 
281     // ether token interface and singleton keccak256("EtherToken")
282     bytes4 internal constant KNOWN_INTERFACE_ETHER_TOKEN = 0x8cf73cf1;
283 
284     // euro token interface and singleton keccak256("EuroToken")
285     bytes4 internal constant KNOWN_INTERFACE_EURO_TOKEN = 0x83c3790b;
286 
287     // euro token interface and singleton keccak256("EuroTokenController")
288     bytes4 internal constant KNOWN_INTERFACE_EURO_TOKEN_CONTROLLER = 0x33ac4661;
289 
290     // identity registry interface and singleton keccak256("IIdentityRegistry")
291     bytes4 internal constant KNOWN_INTERFACE_IDENTITY_REGISTRY = 0x0a72e073;
292 
293     // currency rates oracle interface and singleton keccak256("ITokenExchangeRateOracle")
294     bytes4 internal constant KNOWN_INTERFACE_TOKEN_EXCHANGE_RATE_ORACLE = 0xc6e5349e;
295 
296     // fee disbursal interface and singleton keccak256("IFeeDisbursal")
297     bytes4 internal constant KNOWN_INTERFACE_FEE_DISBURSAL = 0xf4c848e8;
298 
299     // platform portfolio holding equity tokens belonging to NEU holders keccak256("IPlatformPortfolio");
300     bytes4 internal constant KNOWN_INTERFACE_PLATFORM_PORTFOLIO = 0xaa1590d0;
301 
302     // token exchange interface and singleton keccak256("ITokenExchange")
303     bytes4 internal constant KNOWN_INTERFACE_TOKEN_EXCHANGE = 0xddd7a521;
304 
305     // service exchanging euro token for gas ("IGasTokenExchange")
306     bytes4 internal constant KNOWN_INTERFACE_GAS_EXCHANGE = 0x89dbc6de;
307 
308     // access policy interface and singleton keccak256("IAccessPolicy")
309     bytes4 internal constant KNOWN_INTERFACE_ACCESS_POLICY = 0xb05049d9;
310 
311     // euro lock account (upgraded) keccak256("LockedAccount:Euro")
312     bytes4 internal constant KNOWN_INTERFACE_EURO_LOCK = 0x2347a19e;
313 
314     // ether lock account (upgraded) keccak256("LockedAccount:Ether")
315     bytes4 internal constant KNOWN_INTERFACE_ETHER_LOCK = 0x978a6823;
316 
317     // icbm euro lock account keccak256("ICBMLockedAccount:Euro")
318     bytes4 internal constant KNOWN_INTERFACE_ICBM_EURO_LOCK = 0x36021e14;
319 
320     // ether lock account (upgraded) keccak256("ICBMLockedAccount:Ether")
321     bytes4 internal constant KNOWN_INTERFACE_ICBM_ETHER_LOCK = 0x0b58f006;
322 
323     // ether token interface and singleton keccak256("ICBMEtherToken")
324     bytes4 internal constant KNOWN_INTERFACE_ICBM_ETHER_TOKEN = 0xae8b50b9;
325 
326     // euro token interface and singleton keccak256("ICBMEuroToken")
327     bytes4 internal constant KNOWN_INTERFACE_ICBM_EURO_TOKEN = 0xc2c6cd72;
328 
329     // ICBM commitment interface interface and singleton keccak256("ICBMCommitment")
330     bytes4 internal constant KNOWN_INTERFACE_ICBM_COMMITMENT = 0x7f2795ef;
331 
332     // ethereum fork arbiter interface and singleton keccak256("IEthereumForkArbiter")
333     bytes4 internal constant KNOWN_INTERFACE_FORK_ARBITER = 0x2fe7778c;
334 
335     // Platform terms interface and singletong keccak256("PlatformTerms")
336     bytes4 internal constant KNOWN_INTERFACE_PLATFORM_TERMS = 0x75ecd7f8;
337 
338     // for completness we define Universe service keccak256("Universe");
339     bytes4 internal constant KNOWN_INTERFACE_UNIVERSE = 0xbf202454;
340 
341     // ETO commitment interface (collection) keccak256("ICommitment")
342     bytes4 internal constant KNOWN_INTERFACE_COMMITMENT = 0xfa0e0c60;
343 
344     // Equity Token Controller interface (collection) keccak256("IEquityTokenController")
345     bytes4 internal constant KNOWN_INTERFACE_EQUITY_TOKEN_CONTROLLER = 0xfa30b2f1;
346 
347     // Equity Token interface (collection) keccak256("IEquityToken")
348     bytes4 internal constant KNOWN_INTERFACE_EQUITY_TOKEN = 0xab9885bb;
349 
350     // Payment tokens (collection) keccak256("PaymentToken")
351     bytes4 internal constant KNOWN_INTERFACE_PAYMENT_TOKEN = 0xb2a0042a;
352 }
353 
354 /// @title uniquely identifies deployable (non-abstract) platform contract
355 /// @notice cheap way of assigning implementations to knownInterfaces which represent system services
356 ///         unfortunatelly ERC165 does not include full public interface (ABI) and does not provide way to list implemented interfaces
357 ///         EIP820 still in the making
358 /// @dev ids are generated as follows keccak256("neufund-platform:<contract name>")
359 ///      ids roughly correspond to ABIs
360 contract IContractId {
361     /// @param id defined as above
362     /// @param version implementation version
363     function contractId() public pure returns (bytes32 id, uint256 version);
364 }
365 
366 /// @title granular token controller based on MSnapshotToken observer pattern
367 contract ITokenController {
368 
369     ////////////////////////
370     // Public functions
371     ////////////////////////
372 
373     /// @notice see MTokenTransferController
374     /// @dev additionally passes broker that is executing transaction between from and to
375     ///      for unbrokered transfer, broker == from
376     function onTransfer(address broker, address from, address to, uint256 amount)
377         public
378         constant
379         returns (bool allow);
380 
381     /// @notice see MTokenAllowanceController
382     function onApprove(address owner, address spender, uint256 amount)
383         public
384         constant
385         returns (bool allow);
386 
387     /// @notice see MTokenMint
388     function onGenerateTokens(address sender, address owner, uint256 amount)
389         public
390         constant
391         returns (bool allow);
392 
393     /// @notice see MTokenMint
394     function onDestroyTokens(address sender, address owner, uint256 amount)
395         public
396         constant
397         returns (bool allow);
398 
399     /// @notice controls if sender can change controller to newController
400     /// @dev for this to succeed TYPICALLY current controller must be already migrated to a new one
401     function onChangeTokenController(address sender, address newController)
402         public
403         constant
404         returns (bool);
405 
406     /// @notice overrides spender allowance
407     /// @dev may be used to implemented forced transfers in which token controller may override approved allowance
408     ///      with any > 0 value and then use transferFrom to execute such transfer
409     ///      This by definition creates non-trustless token so do not implement this call if you do not need trustless transfers!
410     ///      Implementer should not allow approve() to be executed if there is an overrride
411     //       Implemented should return allowance() taking into account override
412     function onAllowance(address owner, address spender)
413         public
414         constant
415         returns (uint256 allowanceOverride);
416 }
417 
418 contract IEthereumForkArbiter {
419 
420     ////////////////////////
421     // Events
422     ////////////////////////
423 
424     event LogForkAnnounced(
425         string name,
426         string url,
427         uint256 blockNumber
428     );
429 
430     event LogForkSigned(
431         uint256 blockNumber,
432         bytes32 blockHash
433     );
434 
435     ////////////////////////
436     // Public functions
437     ////////////////////////
438 
439     function nextForkName()
440         public
441         constant
442         returns (string);
443 
444     function nextForkUrl()
445         public
446         constant
447         returns (string);
448 
449     function nextForkBlockNumber()
450         public
451         constant
452         returns (uint256);
453 
454     function lastSignedBlockNumber()
455         public
456         constant
457         returns (uint256);
458 
459     function lastSignedBlockHash()
460         public
461         constant
462         returns (bytes32);
463 
464     function lastSignedTimestamp()
465         public
466         constant
467         returns (uint256);
468 
469 }
470 
471 /**
472  * @title legally binding smart contract
473  * @dev General approach to paring legal and smart contracts:
474  * 1. All terms and agreement are between two parties: here between smart conctract legal representation and platform investor.
475  * 2. Parties are represented by public Ethereum addresses. Platform investor is and address that holds and controls funds and receives and controls Neumark token
476  * 3. Legal agreement has immutable part that corresponds to smart contract code and mutable part that may change for example due to changing regulations or other externalities that smart contract does not control.
477  * 4. There should be a provision in legal document that future changes in mutable part cannot change terms of immutable part.
478  * 5. Immutable part links to corresponding smart contract via its address.
479  * 6. Additional provision should be added if smart contract supports it
480  *  a. Fork provision
481  *  b. Bugfixing provision (unilateral code update mechanism)
482  *  c. Migration provision (bilateral code update mechanism)
483  *
484  * Details on Agreement base class:
485  * 1. We bind smart contract to legal contract by storing uri (preferably ipfs or hash) of the legal contract in the smart contract. It is however crucial that such binding is done by smart contract legal representation so transaction establishing the link must be signed by respective wallet ('amendAgreement')
486  * 2. Mutable part of agreement may change. We should be able to amend the uri later. Previous amendments should not be lost and should be retrievable (`amendAgreement` and 'pastAgreement' functions).
487  * 3. It is up to deriving contract to decide where to put 'acceptAgreement' modifier. However situation where there is no cryptographic proof that given address was really acting in the transaction should be avoided, simplest example being 'to' address in `transfer` function of ERC20.
488  *
489 **/
490 contract IAgreement {
491 
492     ////////////////////////
493     // Events
494     ////////////////////////
495 
496     event LogAgreementAccepted(
497         address indexed accepter
498     );
499 
500     event LogAgreementAmended(
501         address contractLegalRepresentative,
502         string agreementUri
503     );
504 
505     /// @dev should have access restrictions so only contractLegalRepresentative may call
506     function amendAgreement(string agreementUri) public;
507 
508     /// returns information on last amendment of the agreement
509     /// @dev MUST revert if no agreements were set
510     function currentAgreement()
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
521     /// returns information on amendment with index
522     /// @dev MAY revert on non existing amendment, indexing starts from 0
523     function pastAgreement(uint256 amendmentIndex)
524         public
525         constant
526         returns
527         (
528             address contractLegalRepresentative,
529             uint256 signedBlockTimestamp,
530             string agreementUri,
531             uint256 index
532         );
533 
534     /// returns the number of block at wchich `signatory` signed agreement
535     /// @dev MUST return 0 if not signed
536     function agreementSignedAtBlock(address signatory)
537         public
538         constant
539         returns (uint256 blockNo);
540 
541     /// returns number of amendments made by contractLegalRepresentative
542     function amendmentsCount()
543         public
544         constant
545         returns (uint256);
546 }
547 
548 /**
549  * @title legally binding smart contract
550  * @dev read IAgreement for details
551 **/
552 contract Agreement is
553     IAgreement,
554     AccessControlled,
555     AccessRoles
556 {
557 
558     ////////////////////////
559     // Type declarations
560     ////////////////////////
561 
562     /// @notice agreement with signature of the platform operator representative
563     struct SignedAgreement {
564         address contractLegalRepresentative;
565         uint256 signedBlockTimestamp;
566         string agreementUri;
567     }
568 
569     ////////////////////////
570     // Immutable state
571     ////////////////////////
572 
573     IEthereumForkArbiter private ETHEREUM_FORK_ARBITER;
574 
575     ////////////////////////
576     // Mutable state
577     ////////////////////////
578 
579     // stores all amendments to the agreement, first amendment is the original
580     SignedAgreement[] private _amendments;
581 
582     // stores block numbers of all addresses that signed the agreement (signatory => block number)
583     mapping(address => uint256) private _signatories;
584 
585     ////////////////////////
586     // Modifiers
587     ////////////////////////
588 
589     /// @notice logs that agreement was accepted by platform user
590     /// @dev intended to be added to functions that if used make 'accepter' origin to enter legally binding agreement
591     modifier acceptAgreement(address accepter) {
592         acceptAgreementInternal(accepter);
593         _;
594     }
595 
596     modifier onlyLegalRepresentative(address legalRepresentative) {
597         require(mCanAmend(legalRepresentative));
598         _;
599     }
600 
601     ////////////////////////
602     // Constructor
603     ////////////////////////
604 
605     constructor(IAccessPolicy accessPolicy, IEthereumForkArbiter forkArbiter)
606         AccessControlled(accessPolicy)
607         internal
608     {
609         require(forkArbiter != IEthereumForkArbiter(0x0));
610         ETHEREUM_FORK_ARBITER = forkArbiter;
611     }
612 
613     ////////////////////////
614     // Public functions
615     ////////////////////////
616 
617     function amendAgreement(string agreementUri)
618         public
619         onlyLegalRepresentative(msg.sender)
620     {
621         SignedAgreement memory amendment = SignedAgreement({
622             contractLegalRepresentative: msg.sender,
623             signedBlockTimestamp: block.timestamp,
624             agreementUri: agreementUri
625         });
626         _amendments.push(amendment);
627         emit LogAgreementAmended(msg.sender, agreementUri);
628     }
629 
630     function ethereumForkArbiter()
631         public
632         constant
633         returns (IEthereumForkArbiter)
634     {
635         return ETHEREUM_FORK_ARBITER;
636     }
637 
638     function currentAgreement()
639         public
640         constant
641         returns
642         (
643             address contractLegalRepresentative,
644             uint256 signedBlockTimestamp,
645             string agreementUri,
646             uint256 index
647         )
648     {
649         require(_amendments.length > 0);
650         uint256 last = _amendments.length - 1;
651         SignedAgreement storage amendment = _amendments[last];
652         return (
653             amendment.contractLegalRepresentative,
654             amendment.signedBlockTimestamp,
655             amendment.agreementUri,
656             last
657         );
658     }
659 
660     function pastAgreement(uint256 amendmentIndex)
661         public
662         constant
663         returns
664         (
665             address contractLegalRepresentative,
666             uint256 signedBlockTimestamp,
667             string agreementUri,
668             uint256 index
669         )
670     {
671         SignedAgreement storage amendment = _amendments[amendmentIndex];
672         return (
673             amendment.contractLegalRepresentative,
674             amendment.signedBlockTimestamp,
675             amendment.agreementUri,
676             amendmentIndex
677         );
678     }
679 
680     function agreementSignedAtBlock(address signatory)
681         public
682         constant
683         returns (uint256 blockNo)
684     {
685         return _signatories[signatory];
686     }
687 
688     function amendmentsCount()
689         public
690         constant
691         returns (uint256)
692     {
693         return _amendments.length;
694     }
695 
696     ////////////////////////
697     // Internal functions
698     ////////////////////////
699 
700     /// provides direct access to derived contract
701     function acceptAgreementInternal(address accepter)
702         internal
703     {
704         if(_signatories[accepter] == 0) {
705             require(_amendments.length > 0);
706             _signatories[accepter] = block.number;
707             emit LogAgreementAccepted(accepter);
708         }
709     }
710 
711     //
712     // MAgreement Internal interface (todo: extract)
713     //
714 
715     /// default amend permission goes to ROLE_PLATFORM_OPERATOR_REPRESENTATIVE
716     function mCanAmend(address legalRepresentative)
717         internal
718         returns (bool)
719     {
720         return accessPolicy().allowed(legalRepresentative, ROLE_PLATFORM_OPERATOR_REPRESENTATIVE, this, msg.sig);
721     }
722 }
723 
724 contract IsContract {
725 
726     ////////////////////////
727     // Internal functions
728     ////////////////////////
729 
730     function isContract(address addr)
731         internal
732         constant
733         returns (bool)
734     {
735         uint256 size;
736         // takes 700 gas
737         assembly { size := extcodesize(addr) }
738         return size > 0;
739     }
740 }
741 
742 contract NeumarkIssuanceCurve {
743 
744     ////////////////////////
745     // Constants
746     ////////////////////////
747 
748     // maximum number of neumarks that may be created
749     uint256 private constant NEUMARK_CAP = 1500000000000000000000000000;
750 
751     // initial neumark reward fraction (controls curve steepness)
752     uint256 private constant INITIAL_REWARD_FRACTION = 6500000000000000000;
753 
754     // stop issuing new Neumarks above this Euro value (as it goes quickly to zero)
755     uint256 private constant ISSUANCE_LIMIT_EUR_ULPS = 8300000000000000000000000000;
756 
757     // approximate curve linearly above this Euro value
758     uint256 private constant LINEAR_APPROX_LIMIT_EUR_ULPS = 2100000000000000000000000000;
759     uint256 private constant NEUMARKS_AT_LINEAR_LIMIT_ULPS = 1499832501287264827896539871;
760 
761     uint256 private constant TOT_LINEAR_NEUMARKS_ULPS = NEUMARK_CAP - NEUMARKS_AT_LINEAR_LIMIT_ULPS;
762     uint256 private constant TOT_LINEAR_EUR_ULPS = ISSUANCE_LIMIT_EUR_ULPS - LINEAR_APPROX_LIMIT_EUR_ULPS;
763 
764     ////////////////////////
765     // Public functions
766     ////////////////////////
767 
768     /// @notice returns additional amount of neumarks issued for euroUlps at totalEuroUlps
769     /// @param totalEuroUlps actual curve position from which neumarks will be issued
770     /// @param euroUlps amount against which neumarks will be issued
771     function incremental(uint256 totalEuroUlps, uint256 euroUlps)
772         public
773         pure
774         returns (uint256 neumarkUlps)
775     {
776         require(totalEuroUlps + euroUlps >= totalEuroUlps);
777         uint256 from = cumulative(totalEuroUlps);
778         uint256 to = cumulative(totalEuroUlps + euroUlps);
779         // as expansion is not monotonic for large totalEuroUlps, assert below may fail
780         // example: totalEuroUlps=1.999999999999999999999000000e+27 and euroUlps=50
781         assert(to >= from);
782         return to - from;
783     }
784 
785     /// @notice returns amount of euro corresponding to burned neumarks
786     /// @param totalEuroUlps actual curve position from which neumarks will be burned
787     /// @param burnNeumarkUlps amount of neumarks to burn
788     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps)
789         public
790         pure
791         returns (uint256 euroUlps)
792     {
793         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
794         require(totalNeumarkUlps >= burnNeumarkUlps);
795         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
796         uint newTotalEuroUlps = cumulativeInverse(fromNmk, 0, totalEuroUlps);
797         // yes, this may overflow due to non monotonic inverse function
798         assert(totalEuroUlps >= newTotalEuroUlps);
799         return totalEuroUlps - newTotalEuroUlps;
800     }
801 
802     /// @notice returns amount of euro corresponding to burned neumarks
803     /// @param totalEuroUlps actual curve position from which neumarks will be burned
804     /// @param burnNeumarkUlps amount of neumarks to burn
805     /// @param minEurUlps euro amount to start inverse search from, inclusive
806     /// @param maxEurUlps euro amount to end inverse search to, inclusive
807     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
808         public
809         pure
810         returns (uint256 euroUlps)
811     {
812         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
813         require(totalNeumarkUlps >= burnNeumarkUlps);
814         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
815         uint newTotalEuroUlps = cumulativeInverse(fromNmk, minEurUlps, maxEurUlps);
816         // yes, this may overflow due to non monotonic inverse function
817         assert(totalEuroUlps >= newTotalEuroUlps);
818         return totalEuroUlps - newTotalEuroUlps;
819     }
820 
821     /// @notice finds total amount of neumarks issued for given amount of Euro
822     /// @dev binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
823     ///     function below is not monotonic
824     function cumulative(uint256 euroUlps)
825         public
826         pure
827         returns(uint256 neumarkUlps)
828     {
829         // Return the cap if euroUlps is above the limit.
830         if (euroUlps >= ISSUANCE_LIMIT_EUR_ULPS) {
831             return NEUMARK_CAP;
832         }
833         // use linear approximation above limit below
834         // binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
835         if (euroUlps >= LINEAR_APPROX_LIMIT_EUR_ULPS) {
836             // (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS) is small so expression does not overflow
837             return NEUMARKS_AT_LINEAR_LIMIT_ULPS + (TOT_LINEAR_NEUMARKS_ULPS * (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS)) / TOT_LINEAR_EUR_ULPS;
838         }
839 
840         // Approximate cap-cap·(1-1/D)^n using the Binomial expansion
841         // http://galileo.phys.virginia.edu/classes/152.mf1i.spring02/Exponential_Function.htm
842         // Function[imax, -CAP*Sum[(-IR*EUR/CAP)^i/Factorial[i], {i, imax}]]
843         // which may be simplified to
844         // Function[imax, -CAP*Sum[(EUR)^i/(Factorial[i]*(-d)^i), {i, 1, imax}]]
845         // where d = cap/initial_reward
846         uint256 d = 230769230769230769230769231; // NEUMARK_CAP / INITIAL_REWARD_FRACTION
847         uint256 term = NEUMARK_CAP;
848         uint256 sum = 0;
849         uint256 denom = d;
850         do assembly {
851             // We use assembler primarily to avoid the expensive
852             // divide-by-zero check solc inserts for the / operator.
853             term  := div(mul(term, euroUlps), denom)
854             sum   := add(sum, term)
855             denom := add(denom, d)
856             // sub next term as we have power of negative value in the binomial expansion
857             term  := div(mul(term, euroUlps), denom)
858             sum   := sub(sum, term)
859             denom := add(denom, d)
860         } while (term != 0);
861         return sum;
862     }
863 
864     /// @notice find issuance curve inverse by binary search
865     /// @param neumarkUlps neumark amount to compute inverse for
866     /// @param minEurUlps minimum search range for the inverse, inclusive
867     /// @param maxEurUlps maxium search range for the inverse, inclusive
868     /// @dev in case of approximate search (no exact inverse) upper element of minimal search range is returned
869     /// @dev in case of many possible inverses, the lowest one will be used (if range permits)
870     /// @dev corresponds to a linear search that returns first euroUlp value that has cumulative() equal or greater than neumarkUlps
871     function cumulativeInverse(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
872         public
873         pure
874         returns (uint256 euroUlps)
875     {
876         require(maxEurUlps >= minEurUlps);
877         require(cumulative(minEurUlps) <= neumarkUlps);
878         require(cumulative(maxEurUlps) >= neumarkUlps);
879         uint256 min = minEurUlps;
880         uint256 max = maxEurUlps;
881 
882         // Binary search
883         while (max > min) {
884             uint256 mid = (max + min) / 2;
885             uint256 val = cumulative(mid);
886             // exact solution should not be used, a late points of the curve when many euroUlps are needed to
887             // increase by one nmkUlp this will lead to  "indeterministic" inverse values that depend on the initial min and max
888             // and further binary division -> you can land at any of the euro value that is mapped to the same nmk value
889             // with condition below removed, binary search will point to the lowest eur value possible which is good because it cannot be exploited even with 0 gas costs
890             /* if (val == neumarkUlps) {
891                 return mid;
892             }*/
893             // NOTE: approximate search (no inverse) must return upper element of the final range
894             //  last step of approximate search is always (min, min+1) so new mid is (2*min+1)/2 => min
895             //  so new min = mid + 1 = max which was upper range. and that ends the search
896             // NOTE: when there are multiple inverses for the same neumarkUlps, the `max` will be dragged down
897             //  by `max = mid` expression to the lowest eur value of inverse. works only for ranges that cover all points of multiple inverse
898             if (val < neumarkUlps) {
899                 min = mid + 1;
900             } else {
901                 max = mid;
902             }
903         }
904         // NOTE: It is possible that there is no inverse
905         //  for example curve(0) = 0 and curve(1) = 6, so
906         //  there is no value y such that curve(y) = 5.
907         //  When there is no inverse, we must return upper element of last search range.
908         //  This has the effect of reversing the curve less when
909         //  burning Neumarks. This ensures that Neumarks can always
910         //  be burned. It also ensure that the total supply of Neumarks
911         //  remains below the cap.
912         return max;
913     }
914 
915     function neumarkCap()
916         public
917         pure
918         returns (uint256)
919     {
920         return NEUMARK_CAP;
921     }
922 
923     function initialRewardFraction()
924         public
925         pure
926         returns (uint256)
927     {
928         return INITIAL_REWARD_FRACTION;
929     }
930 }
931 
932 contract IBasicToken {
933 
934     ////////////////////////
935     // Events
936     ////////////////////////
937 
938     event Transfer(
939         address indexed from,
940         address indexed to,
941         uint256 amount
942     );
943 
944     ////////////////////////
945     // Public functions
946     ////////////////////////
947 
948     /// @dev This function makes it easy to get the total number of tokens
949     /// @return The total number of tokens
950     function totalSupply()
951         public
952         constant
953         returns (uint256);
954 
955     /// @param owner The address that's balance is being requested
956     /// @return The balance of `owner` at the current block
957     function balanceOf(address owner)
958         public
959         constant
960         returns (uint256 balance);
961 
962     /// @notice Send `amount` tokens to `to` from `msg.sender`
963     /// @param to The address of the recipient
964     /// @param amount The amount of tokens to be transferred
965     /// @return Whether the transfer was successful or not
966     function transfer(address to, uint256 amount)
967         public
968         returns (bool success);
969 
970 }
971 
972 /// @title allows deriving contract to recover any token or ether that it has balance of
973 /// @notice note that this opens your contracts to claims from various people saying they lost tokens and they want them back
974 ///     be ready to handle such claims
975 /// @dev use with care!
976 ///     1. ROLE_RECLAIMER is allowed to claim tokens, it's not returning tokens to original owner
977 ///     2. in derived contract that holds any token by design you must override `reclaim` and block such possibility.
978 ///         see ICBMLockedAccount as an example
979 contract Reclaimable is AccessControlled, AccessRoles {
980 
981     ////////////////////////
982     // Constants
983     ////////////////////////
984 
985     IBasicToken constant internal RECLAIM_ETHER = IBasicToken(0x0);
986 
987     ////////////////////////
988     // Public functions
989     ////////////////////////
990 
991     function reclaim(IBasicToken token)
992         public
993         only(ROLE_RECLAIMER)
994     {
995         address reclaimer = msg.sender;
996         if(token == RECLAIM_ETHER) {
997             reclaimer.transfer(address(this).balance);
998         } else {
999             uint256 balance = token.balanceOf(this);
1000             require(token.transfer(reclaimer, balance));
1001         }
1002     }
1003 }
1004 
1005 /// @title advances snapshot id on demand
1006 /// @dev see Snapshot folder for implementation examples ie. DailyAndSnapshotable contract
1007 contract ISnapshotable {
1008 
1009     ////////////////////////
1010     // Events
1011     ////////////////////////
1012 
1013     /// @dev should log each new snapshot id created, including snapshots created automatically via MSnapshotPolicy
1014     event LogSnapshotCreated(uint256 snapshotId);
1015 
1016     ////////////////////////
1017     // Public functions
1018     ////////////////////////
1019 
1020     /// always creates new snapshot id which gets returned
1021     /// however, there is no guarantee that any snapshot will be created with this id, this depends on the implementation of MSnaphotPolicy
1022     function createSnapshot()
1023         public
1024         returns (uint256);
1025 
1026     /// upper bound of series snapshotIds for which there's a value
1027     function currentSnapshotId()
1028         public
1029         constant
1030         returns (uint256);
1031 }
1032 
1033 /// @title Abstracts snapshot id creation logics
1034 /// @dev Mixin (internal interface) of the snapshot policy which abstracts snapshot id creation logics from Snapshot contract
1035 /// @dev to be implemented and such implementation should be mixed with Snapshot-derived contract, see EveryBlock for simplest example of implementation and StandardSnapshotToken
1036 contract MSnapshotPolicy {
1037 
1038     ////////////////////////
1039     // Internal functions
1040     ////////////////////////
1041 
1042     // The snapshot Ids need to be strictly increasing.
1043     // Whenever the snaspshot id changes, a new snapshot will be created.
1044     // As long as the same snapshot id is being returned, last snapshot will be updated as this indicates that snapshot id didn't change
1045     //
1046     // Values passed to `hasValueAt` and `valuteAt` are required
1047     // to be less or equal to `mCurrentSnapshotId()`.
1048     function mAdvanceSnapshotId()
1049         internal
1050         returns (uint256);
1051 
1052     // this is a version of mAdvanceSnapshotId that does not modify state but MUST return the same value
1053     // it is required to implement ITokenSnapshots interface cleanly
1054     function mCurrentSnapshotId()
1055         internal
1056         constant
1057         returns (uint256);
1058 
1059 }
1060 
1061 /// @title creates new snapshot id on each day boundary
1062 /// @dev snapshot id is unix timestamp of current day boundary
1063 contract Daily is MSnapshotPolicy {
1064 
1065     ////////////////////////
1066     // Constants
1067     ////////////////////////
1068 
1069     // Floor[2**128 / 1 days]
1070     uint256 private MAX_TIMESTAMP = 3938453320844195178974243141571391;
1071 
1072     ////////////////////////
1073     // Constructor
1074     ////////////////////////
1075 
1076     /// @param start snapshotId from which to start generating values, used to prevent cloning from incompatible schemes
1077     /// @dev start must be for the same day or 0, required for token cloning
1078     constructor(uint256 start) internal {
1079         // 0 is invalid value as we are past unix epoch
1080         if (start > 0) {
1081             uint256 base = dayBase(uint128(block.timestamp));
1082             // must be within current day base
1083             require(start >= base);
1084             // dayBase + 2**128 will not overflow as it is based on block.timestamp
1085             require(start < base + 2**128);
1086         }
1087     }
1088 
1089     ////////////////////////
1090     // Public functions
1091     ////////////////////////
1092 
1093     function snapshotAt(uint256 timestamp)
1094         public
1095         constant
1096         returns (uint256)
1097     {
1098         require(timestamp < MAX_TIMESTAMP);
1099 
1100         return dayBase(uint128(timestamp));
1101     }
1102 
1103     ////////////////////////
1104     // Internal functions
1105     ////////////////////////
1106 
1107     //
1108     // Implements MSnapshotPolicy
1109     //
1110 
1111     function mAdvanceSnapshotId()
1112         internal
1113         returns (uint256)
1114     {
1115         return mCurrentSnapshotId();
1116     }
1117 
1118     function mCurrentSnapshotId()
1119         internal
1120         constant
1121         returns (uint256)
1122     {
1123         // disregard overflows on block.timestamp, see MAX_TIMESTAMP
1124         return dayBase(uint128(block.timestamp));
1125     }
1126 
1127     function dayBase(uint128 timestamp)
1128         internal
1129         pure
1130         returns (uint256)
1131     {
1132         // Round down to the start of the day (00:00 UTC) and place in higher 128bits
1133         return 2**128 * (uint256(timestamp) / 1 days);
1134     }
1135 }
1136 
1137 /// @title creates snapshot id on each day boundary and allows to create additional snapshots within a given day
1138 /// @dev snapshots are encoded in single uint256, where high 128 bits represents a day number (from unix epoch) and low 128 bits represents additional snapshots within given day create via ISnapshotable
1139 contract DailyAndSnapshotable is
1140     Daily,
1141     ISnapshotable
1142 {
1143 
1144     ////////////////////////
1145     // Mutable state
1146     ////////////////////////
1147 
1148     uint256 private _currentSnapshotId;
1149 
1150     ////////////////////////
1151     // Constructor
1152     ////////////////////////
1153 
1154     /// @param start snapshotId from which to start generating values
1155     /// @dev start must be for the same day or 0, required for token cloning
1156     constructor(uint256 start)
1157         internal
1158         Daily(start)
1159     {
1160         if (start > 0) {
1161             _currentSnapshotId = start;
1162         }
1163     }
1164 
1165     ////////////////////////
1166     // Public functions
1167     ////////////////////////
1168 
1169     //
1170     // Implements ISnapshotable
1171     //
1172 
1173     function createSnapshot()
1174         public
1175         returns (uint256)
1176     {
1177         uint256 base = dayBase(uint128(block.timestamp));
1178 
1179         if (base > _currentSnapshotId) {
1180             // New day has started, create snapshot for midnight
1181             _currentSnapshotId = base;
1182         } else {
1183             // within single day, increase counter (assume 2**128 will not be crossed)
1184             _currentSnapshotId += 1;
1185         }
1186 
1187         // Log and return
1188         emit LogSnapshotCreated(_currentSnapshotId);
1189         return _currentSnapshotId;
1190     }
1191 
1192     ////////////////////////
1193     // Internal functions
1194     ////////////////////////
1195 
1196     //
1197     // Implements MSnapshotPolicy
1198     //
1199 
1200     function mAdvanceSnapshotId()
1201         internal
1202         returns (uint256)
1203     {
1204         uint256 base = dayBase(uint128(block.timestamp));
1205 
1206         // New day has started
1207         if (base > _currentSnapshotId) {
1208             _currentSnapshotId = base;
1209             emit LogSnapshotCreated(base);
1210         }
1211 
1212         return _currentSnapshotId;
1213     }
1214 
1215     function mCurrentSnapshotId()
1216         internal
1217         constant
1218         returns (uint256)
1219     {
1220         uint256 base = dayBase(uint128(block.timestamp));
1221 
1222         return base > _currentSnapshotId ? base : _currentSnapshotId;
1223     }
1224 }
1225 
1226 contract ITokenMetadata {
1227 
1228     ////////////////////////
1229     // Public functions
1230     ////////////////////////
1231 
1232     function symbol()
1233         public
1234         constant
1235         returns (string);
1236 
1237     function name()
1238         public
1239         constant
1240         returns (string);
1241 
1242     function decimals()
1243         public
1244         constant
1245         returns (uint8);
1246 }
1247 
1248 /// @title adds token metadata to token contract
1249 /// @dev see Neumark for example implementation
1250 contract TokenMetadata is ITokenMetadata {
1251 
1252     ////////////////////////
1253     // Immutable state
1254     ////////////////////////
1255 
1256     // The Token's name: e.g. DigixDAO Tokens
1257     string private NAME;
1258 
1259     // An identifier: e.g. REP
1260     string private SYMBOL;
1261 
1262     // Number of decimals of the smallest unit
1263     uint8 private DECIMALS;
1264 
1265     // An arbitrary versioning scheme
1266     string private VERSION;
1267 
1268     ////////////////////////
1269     // Constructor
1270     ////////////////////////
1271 
1272     /// @notice Constructor to set metadata
1273     /// @param tokenName Name of the new token
1274     /// @param decimalUnits Number of decimals of the new token
1275     /// @param tokenSymbol Token Symbol for the new token
1276     /// @param version Token version ie. when cloning is used
1277     constructor(
1278         string tokenName,
1279         uint8 decimalUnits,
1280         string tokenSymbol,
1281         string version
1282     )
1283         public
1284     {
1285         NAME = tokenName;                                 // Set the name
1286         SYMBOL = tokenSymbol;                             // Set the symbol
1287         DECIMALS = decimalUnits;                          // Set the decimals
1288         VERSION = version;
1289     }
1290 
1291     ////////////////////////
1292     // Public functions
1293     ////////////////////////
1294 
1295     function name()
1296         public
1297         constant
1298         returns (string)
1299     {
1300         return NAME;
1301     }
1302 
1303     function symbol()
1304         public
1305         constant
1306         returns (string)
1307     {
1308         return SYMBOL;
1309     }
1310 
1311     function decimals()
1312         public
1313         constant
1314         returns (uint8)
1315     {
1316         return DECIMALS;
1317     }
1318 
1319     function version()
1320         public
1321         constant
1322         returns (string)
1323     {
1324         return VERSION;
1325     }
1326 }
1327 
1328 contract IERC20Allowance {
1329 
1330     ////////////////////////
1331     // Events
1332     ////////////////////////
1333 
1334     event Approval(
1335         address indexed owner,
1336         address indexed spender,
1337         uint256 amount
1338     );
1339 
1340     ////////////////////////
1341     // Public functions
1342     ////////////////////////
1343 
1344     /// @dev This function makes it easy to read the `allowed[]` map
1345     /// @param owner The address of the account that owns the token
1346     /// @param spender The address of the account able to transfer the tokens
1347     /// @return Amount of remaining tokens of owner that spender is allowed
1348     ///  to spend
1349     function allowance(address owner, address spender)
1350         public
1351         constant
1352         returns (uint256 remaining);
1353 
1354     /// @notice `msg.sender` approves `spender` to spend `amount` tokens on
1355     ///  its behalf. This is a modified version of the ERC20 approve function
1356     ///  to be a little bit safer
1357     /// @param spender The address of the account able to transfer the tokens
1358     /// @param amount The amount of tokens to be approved for transfer
1359     /// @return True if the approval was successful
1360     function approve(address spender, uint256 amount)
1361         public
1362         returns (bool success);
1363 
1364     /// @notice Send `amount` tokens to `to` from `from` on the condition it
1365     ///  is approved by `from`
1366     /// @param from The address holding the tokens being transferred
1367     /// @param to The address of the recipient
1368     /// @param amount The amount of tokens to be transferred
1369     /// @return True if the transfer was successful
1370     function transferFrom(address from, address to, uint256 amount)
1371         public
1372         returns (bool success);
1373 
1374 }
1375 
1376 contract IERC20Token is IBasicToken, IERC20Allowance {
1377 
1378 }
1379 
1380 /// @title controls spending approvals
1381 /// @dev TokenAllowance observes this interface, Neumark contract implements it
1382 contract MTokenAllowanceController {
1383 
1384     ////////////////////////
1385     // Internal functions
1386     ////////////////////////
1387 
1388     /// @notice Notifies the controller about an approval allowing the
1389     ///  controller to react if desired
1390     /// @param owner The address that calls `approve()`
1391     /// @param spender The spender in the `approve()` call
1392     /// @param amount The amount in the `approve()` call
1393     /// @return False if the controller does not authorize the approval
1394     function mOnApprove(
1395         address owner,
1396         address spender,
1397         uint256 amount
1398     )
1399         internal
1400         returns (bool allow);
1401 
1402     /// @notice Allows to override allowance approved by the owner
1403     ///         Primary role is to enable forced transfers, do not override if you do not like it
1404     ///         Following behavior is expected in the observer
1405     ///         approve() - should revert if mAllowanceOverride() > 0
1406     ///         allowance() - should return mAllowanceOverride() if set
1407     ///         transferFrom() - should override allowance if mAllowanceOverride() > 0
1408     /// @param owner An address giving allowance to spender
1409     /// @param spender An address getting  a right to transfer allowance amount from the owner
1410     /// @return current allowance amount
1411     function mAllowanceOverride(
1412         address owner,
1413         address spender
1414     )
1415         internal
1416         constant
1417         returns (uint256 allowance);
1418 }
1419 
1420 /// @title controls token transfers
1421 /// @dev BasicSnapshotToken observes this interface, Neumark contract implements it
1422 contract MTokenTransferController {
1423 
1424     ////////////////////////
1425     // Internal functions
1426     ////////////////////////
1427 
1428     /// @notice Notifies the controller about a token transfer allowing the
1429     ///  controller to react if desired
1430     /// @param from The origin of the transfer
1431     /// @param to The destination of the transfer
1432     /// @param amount The amount of the transfer
1433     /// @return False if the controller does not authorize the transfer
1434     function mOnTransfer(
1435         address from,
1436         address to,
1437         uint256 amount
1438     )
1439         internal
1440         returns (bool allow);
1441 
1442 }
1443 
1444 /// @title controls approvals and transfers
1445 /// @dev The token controller contract must implement these functions, see Neumark as example
1446 /// @dev please note that controller may be a separate contract that is called from mOnTransfer and mOnApprove functions
1447 contract MTokenController is MTokenTransferController, MTokenAllowanceController {
1448 }
1449 
1450 /// @title internal token transfer function
1451 /// @dev see BasicSnapshotToken for implementation
1452 contract MTokenTransfer {
1453 
1454     ////////////////////////
1455     // Internal functions
1456     ////////////////////////
1457 
1458     /// @dev This is the actual transfer function in the token contract, it can
1459     ///  only be called by other functions in this contract.
1460     /// @param from The address holding the tokens being transferred
1461     /// @param to The address of the recipient
1462     /// @param amount The amount of tokens to be transferred
1463     /// @dev  reverts if transfer was not successful
1464     function mTransfer(
1465         address from,
1466         address to,
1467         uint256 amount
1468     )
1469         internal;
1470 }
1471 
1472 contract IERC677Callback {
1473 
1474     ////////////////////////
1475     // Public functions
1476     ////////////////////////
1477 
1478     // NOTE: This call can be initiated by anyone. You need to make sure that
1479     // it is send by the token (`require(msg.sender == token)`) or make sure
1480     // amount is valid (`require(token.allowance(this) >= amount)`).
1481     function receiveApproval(
1482         address from,
1483         uint256 amount,
1484         address token, // IERC667Token
1485         bytes data
1486     )
1487         public
1488         returns (bool success);
1489 
1490 }
1491 
1492 contract IERC677Allowance is IERC20Allowance {
1493 
1494     ////////////////////////
1495     // Public functions
1496     ////////////////////////
1497 
1498     /// @notice `msg.sender` approves `spender` to send `amount` tokens on
1499     ///  its behalf, and then a function is triggered in the contract that is
1500     ///  being approved, `spender`. This allows users to use their tokens to
1501     ///  interact with contracts in one function call instead of two
1502     /// @param spender The address of the contract able to transfer the tokens
1503     /// @param amount The amount of tokens to be approved for transfer
1504     /// @return True if the function call was successful
1505     function approveAndCall(address spender, uint256 amount, bytes extraData)
1506         public
1507         returns (bool success);
1508 
1509 }
1510 
1511 contract IERC677Token is IERC20Token, IERC677Allowance {
1512 }
1513 
1514 /// @title token spending approval and transfer
1515 /// @dev implements token approval and transfers and exposes relevant part of ERC20 and ERC677 approveAndCall
1516 ///     may be mixed in with any basic token (implementing mTransfer) like BasicSnapshotToken or MintableSnapshotToken to add approval mechanism
1517 ///     observes MTokenAllowanceController interface
1518 ///     observes MTokenTransfer
1519 contract TokenAllowance is
1520     MTokenTransfer,
1521     MTokenAllowanceController,
1522     IERC20Allowance,
1523     IERC677Token
1524 {
1525 
1526     ////////////////////////
1527     // Mutable state
1528     ////////////////////////
1529 
1530     // `allowed` tracks rights to spends others tokens as per ERC20
1531     // owner => spender => amount
1532     mapping (address => mapping (address => uint256)) private _allowed;
1533 
1534     ////////////////////////
1535     // Constructor
1536     ////////////////////////
1537 
1538     constructor()
1539         internal
1540     {
1541     }
1542 
1543     ////////////////////////
1544     // Public functions
1545     ////////////////////////
1546 
1547     //
1548     // Implements IERC20Token
1549     //
1550 
1551     /// @dev This function makes it easy to read the `allowed[]` map
1552     /// @param owner The address of the account that owns the token
1553     /// @param spender The address of the account able to transfer the tokens
1554     /// @return Amount of remaining tokens of _owner that _spender is allowed
1555     ///  to spend
1556     function allowance(address owner, address spender)
1557         public
1558         constant
1559         returns (uint256 remaining)
1560     {
1561         uint256 override = mAllowanceOverride(owner, spender);
1562         if (override > 0) {
1563             return override;
1564         }
1565         return _allowed[owner][spender];
1566     }
1567 
1568     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
1569     ///  its behalf. This is a modified version of the ERC20 approve function
1570     ///  where allowance per spender must be 0 to allow change of such allowance
1571     /// @param spender The address of the account able to transfer the tokens
1572     /// @param amount The amount of tokens to be approved for transfer
1573     /// @return True or reverts, False is never returned
1574     function approve(address spender, uint256 amount)
1575         public
1576         returns (bool success)
1577     {
1578         // Alerts the token controller of the approve function call
1579         require(mOnApprove(msg.sender, spender, amount));
1580 
1581         // To change the approve amount you first have to reduce the addresses`
1582         //  allowance to zero by calling `approve(_spender,0)` if it is not
1583         //  already 0 to mitigate the race condition described here:
1584         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1585         require((amount == 0 || _allowed[msg.sender][spender] == 0) && mAllowanceOverride(msg.sender, spender) == 0);
1586 
1587         _allowed[msg.sender][spender] = amount;
1588         emit Approval(msg.sender, spender, amount);
1589         return true;
1590     }
1591 
1592     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
1593     ///  is approved by `_from`
1594     /// @param from The address holding the tokens being transferred
1595     /// @param to The address of the recipient
1596     /// @param amount The amount of tokens to be transferred
1597     /// @return True if the transfer was successful, reverts in any other case
1598     function transferFrom(address from, address to, uint256 amount)
1599         public
1600         returns (bool success)
1601     {
1602         uint256 allowed = mAllowanceOverride(from, msg.sender);
1603         if (allowed == 0) {
1604             // The standard ERC 20 transferFrom functionality
1605             allowed = _allowed[from][msg.sender];
1606             // yes this will underflow but then we'll revert. will cost gas however so don't underflow
1607             _allowed[from][msg.sender] -= amount;
1608         }
1609         require(allowed >= amount);
1610         mTransfer(from, to, amount);
1611         return true;
1612     }
1613 
1614     //
1615     // Implements IERC677Token
1616     //
1617 
1618     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
1619     ///  its behalf, and then a function is triggered in the contract that is
1620     ///  being approved, `_spender`. This allows users to use their tokens to
1621     ///  interact with contracts in one function call instead of two
1622     /// @param spender The address of the contract able to transfer the tokens
1623     /// @param amount The amount of tokens to be approved for transfer
1624     /// @return True or reverts, False is never returned
1625     function approveAndCall(
1626         address spender,
1627         uint256 amount,
1628         bytes extraData
1629     )
1630         public
1631         returns (bool success)
1632     {
1633         require(approve(spender, amount));
1634 
1635         success = IERC677Callback(spender).receiveApproval(
1636             msg.sender,
1637             amount,
1638             this,
1639             extraData
1640         );
1641         require(success);
1642 
1643         return true;
1644     }
1645 
1646     ////////////////////////
1647     // Internal functions
1648     ////////////////////////
1649 
1650     //
1651     // Implements default MTokenAllowanceController
1652     //
1653 
1654     // no override in default implementation
1655     function mAllowanceOverride(
1656         address /*owner*/,
1657         address /*spender*/
1658     )
1659         internal
1660         constant
1661         returns (uint256)
1662     {
1663         return 0;
1664     }
1665 }
1666 
1667 /// @title Reads and writes snapshots
1668 /// @dev Manages reading and writing a series of values, where each value has assigned a snapshot id for access to historical data
1669 /// @dev may be added to any contract to provide snapshotting mechanism. should be mixed in with any of MSnapshotPolicy implementations to customize snapshot creation mechanics
1670 ///     observes MSnapshotPolicy
1671 /// based on MiniMe token
1672 contract Snapshot is MSnapshotPolicy {
1673 
1674     ////////////////////////
1675     // Types
1676     ////////////////////////
1677 
1678     /// @dev `Values` is the structure that attaches a snapshot id to a
1679     ///  given value, the snapshot id attached is the one that last changed the
1680     ///  value
1681     struct Values {
1682 
1683         // `snapshotId` is the snapshot id that the value was generated at
1684         uint256 snapshotId;
1685 
1686         // `value` at a specific snapshot id
1687         uint256 value;
1688     }
1689 
1690     ////////////////////////
1691     // Internal functions
1692     ////////////////////////
1693 
1694     function hasValue(
1695         Values[] storage values
1696     )
1697         internal
1698         constant
1699         returns (bool)
1700     {
1701         return values.length > 0;
1702     }
1703 
1704     /// @dev makes sure that 'snapshotId' between current snapshot id (mCurrentSnapshotId) and first snapshot id. this guarantees that getValueAt returns value from one of the snapshots.
1705     function hasValueAt(
1706         Values[] storage values,
1707         uint256 snapshotId
1708     )
1709         internal
1710         constant
1711         returns (bool)
1712     {
1713         require(snapshotId <= mCurrentSnapshotId());
1714         return values.length > 0 && values[0].snapshotId <= snapshotId;
1715     }
1716 
1717     /// gets last value in the series
1718     function getValue(
1719         Values[] storage values,
1720         uint256 defaultValue
1721     )
1722         internal
1723         constant
1724         returns (uint256)
1725     {
1726         if (values.length == 0) {
1727             return defaultValue;
1728         } else {
1729             uint256 last = values.length - 1;
1730             return values[last].value;
1731         }
1732     }
1733 
1734     /// @dev `getValueAt` retrieves value at a given snapshot id
1735     /// @param values The series of values being queried
1736     /// @param snapshotId Snapshot id to retrieve the value at
1737     /// @return Value in series being queried
1738     function getValueAt(
1739         Values[] storage values,
1740         uint256 snapshotId,
1741         uint256 defaultValue
1742     )
1743         internal
1744         constant
1745         returns (uint256)
1746     {
1747         require(snapshotId <= mCurrentSnapshotId());
1748 
1749         // Empty value
1750         if (values.length == 0) {
1751             return defaultValue;
1752         }
1753 
1754         // Shortcut for the out of bounds snapshots
1755         uint256 last = values.length - 1;
1756         uint256 lastSnapshot = values[last].snapshotId;
1757         if (snapshotId >= lastSnapshot) {
1758             return values[last].value;
1759         }
1760         uint256 firstSnapshot = values[0].snapshotId;
1761         if (snapshotId < firstSnapshot) {
1762             return defaultValue;
1763         }
1764         // Binary search of the value in the array
1765         uint256 min = 0;
1766         uint256 max = last;
1767         while (max > min) {
1768             uint256 mid = (max + min + 1) / 2;
1769             // must always return lower indice for approximate searches
1770             if (values[mid].snapshotId <= snapshotId) {
1771                 min = mid;
1772             } else {
1773                 max = mid - 1;
1774             }
1775         }
1776         return values[min].value;
1777     }
1778 
1779     /// @dev `setValue` used to update sequence at next snapshot
1780     /// @param values The sequence being updated
1781     /// @param value The new last value of sequence
1782     function setValue(
1783         Values[] storage values,
1784         uint256 value
1785     )
1786         internal
1787     {
1788         // TODO: simplify or break into smaller functions
1789 
1790         uint256 currentSnapshotId = mAdvanceSnapshotId();
1791         // Always create a new entry if there currently is no value
1792         bool empty = values.length == 0;
1793         if (empty) {
1794             // Create a new entry
1795             values.push(
1796                 Values({
1797                     snapshotId: currentSnapshotId,
1798                     value: value
1799                 })
1800             );
1801             return;
1802         }
1803 
1804         uint256 last = values.length - 1;
1805         bool hasNewSnapshot = values[last].snapshotId < currentSnapshotId;
1806         if (hasNewSnapshot) {
1807 
1808             // Do nothing if the value was not modified
1809             bool unmodified = values[last].value == value;
1810             if (unmodified) {
1811                 return;
1812             }
1813 
1814             // Create new entry
1815             values.push(
1816                 Values({
1817                     snapshotId: currentSnapshotId,
1818                     value: value
1819                 })
1820             );
1821         } else {
1822 
1823             // We are updating the currentSnapshotId
1824             bool previousUnmodified = last > 0 && values[last - 1].value == value;
1825             if (previousUnmodified) {
1826                 // Remove current snapshot if current value was set to previous value
1827                 delete values[last];
1828                 values.length--;
1829                 return;
1830             }
1831 
1832             // Overwrite next snapshot entry
1833             values[last].value = value;
1834         }
1835     }
1836 }
1837 
1838 /// @title access to snapshots of a token
1839 /// @notice allows to implement complex token holder rights like revenue disbursal or voting
1840 /// @notice snapshots are series of values with assigned ids. ids increase strictly. particular id mechanism is not assumed
1841 contract ITokenSnapshots {
1842 
1843     ////////////////////////
1844     // Public functions
1845     ////////////////////////
1846 
1847     /// @notice Total amount of tokens at a specific `snapshotId`.
1848     /// @param snapshotId of snapshot at which totalSupply is queried
1849     /// @return The total amount of tokens at `snapshotId`
1850     /// @dev reverts on snapshotIds greater than currentSnapshotId()
1851     /// @dev returns 0 for snapshotIds less than snapshotId of first value
1852     function totalSupplyAt(uint256 snapshotId)
1853         public
1854         constant
1855         returns(uint256);
1856 
1857     /// @dev Queries the balance of `owner` at a specific `snapshotId`
1858     /// @param owner The address from which the balance will be retrieved
1859     /// @param snapshotId of snapshot at which the balance is queried
1860     /// @return The balance at `snapshotId`
1861     function balanceOfAt(address owner, uint256 snapshotId)
1862         public
1863         constant
1864         returns (uint256);
1865 
1866     /// @notice upper bound of series of snapshotIds for which there's a value in series
1867     /// @return snapshotId
1868     function currentSnapshotId()
1869         public
1870         constant
1871         returns (uint256);
1872 }
1873 
1874 /// @title represents link between cloned and parent token
1875 /// @dev when token is clone from other token, initial balances of the cloned token
1876 ///     correspond to balances of parent token at the moment of parent snapshot id specified
1877 /// @notice please note that other tokens beside snapshot token may be cloned
1878 contract IClonedTokenParent is ITokenSnapshots {
1879 
1880     ////////////////////////
1881     // Public functions
1882     ////////////////////////
1883 
1884 
1885     /// @return address of parent token, address(0) if root
1886     /// @dev parent token does not need to clonable, nor snapshottable, just a normal token
1887     function parentToken()
1888         public
1889         constant
1890         returns(IClonedTokenParent parent);
1891 
1892     /// @return snapshot at wchich initial token distribution was taken
1893     function parentSnapshotId()
1894         public
1895         constant
1896         returns(uint256 snapshotId);
1897 }
1898 
1899 /// @title token with snapshots and transfer functionality
1900 /// @dev observes MTokenTransferController interface
1901 ///     observes ISnapshotToken interface
1902 ///     implementes MTokenTransfer interface
1903 contract BasicSnapshotToken is
1904     MTokenTransfer,
1905     MTokenTransferController,
1906     IClonedTokenParent,
1907     IBasicToken,
1908     Snapshot
1909 {
1910     ////////////////////////
1911     // Immutable state
1912     ////////////////////////
1913 
1914     // `PARENT_TOKEN` is the Token address that was cloned to produce this token;
1915     //  it will be 0x0 for a token that was not cloned
1916     IClonedTokenParent private PARENT_TOKEN;
1917 
1918     // `PARENT_SNAPSHOT_ID` is the snapshot id from the Parent Token that was
1919     //  used to determine the initial distribution of the cloned token
1920     uint256 private PARENT_SNAPSHOT_ID;
1921 
1922     ////////////////////////
1923     // Mutable state
1924     ////////////////////////
1925 
1926     // `balances` is the map that tracks the balance of each address, in this
1927     //  contract when the balance changes the snapshot id that the change
1928     //  occurred is also included in the map
1929     mapping (address => Values[]) internal _balances;
1930 
1931     // Tracks the history of the `totalSupply` of the token
1932     Values[] internal _totalSupplyValues;
1933 
1934     ////////////////////////
1935     // Constructor
1936     ////////////////////////
1937 
1938     /// @notice Constructor to create snapshot token
1939     /// @param parentToken Address of the parent token, set to 0x0 if it is a
1940     ///  new token
1941     /// @param parentSnapshotId at which snapshot id clone was created, set to 0 to clone at upper bound
1942     /// @dev please not that as long as cloned token does not overwrite value at current snapshot id, it will refer
1943     ///     to parent token at which this snapshot still may change until snapshot id increases. for that time tokens are coupled
1944     ///     this is prevented by parentSnapshotId value of parentToken.currentSnapshotId() - 1 being the maxiumum
1945     ///     see SnapshotToken.js test to learn consequences coupling has.
1946     constructor(
1947         IClonedTokenParent parentToken,
1948         uint256 parentSnapshotId
1949     )
1950         Snapshot()
1951         internal
1952     {
1953         PARENT_TOKEN = parentToken;
1954         if (parentToken == address(0)) {
1955             require(parentSnapshotId == 0);
1956         } else {
1957             if (parentSnapshotId == 0) {
1958                 require(parentToken.currentSnapshotId() > 0);
1959                 PARENT_SNAPSHOT_ID = parentToken.currentSnapshotId() - 1;
1960             } else {
1961                 PARENT_SNAPSHOT_ID = parentSnapshotId;
1962             }
1963         }
1964     }
1965 
1966     ////////////////////////
1967     // Public functions
1968     ////////////////////////
1969 
1970     //
1971     // Implements IBasicToken
1972     //
1973 
1974     /// @dev This function makes it easy to get the total number of tokens
1975     /// @return The total number of tokens
1976     function totalSupply()
1977         public
1978         constant
1979         returns (uint256)
1980     {
1981         return totalSupplyAtInternal(mCurrentSnapshotId());
1982     }
1983 
1984     /// @param owner The address that's balance is being requested
1985     /// @return The balance of `owner` at the current block
1986     function balanceOf(address owner)
1987         public
1988         constant
1989         returns (uint256 balance)
1990     {
1991         return balanceOfAtInternal(owner, mCurrentSnapshotId());
1992     }
1993 
1994     /// @notice Send `amount` tokens to `to` from `msg.sender`
1995     /// @param to The address of the recipient
1996     /// @param amount The amount of tokens to be transferred
1997     /// @return True if the transfer was successful, reverts in any other case
1998     function transfer(address to, uint256 amount)
1999         public
2000         returns (bool success)
2001     {
2002         mTransfer(msg.sender, to, amount);
2003         return true;
2004     }
2005 
2006     //
2007     // Implements ITokenSnapshots
2008     //
2009 
2010     function totalSupplyAt(uint256 snapshotId)
2011         public
2012         constant
2013         returns(uint256)
2014     {
2015         return totalSupplyAtInternal(snapshotId);
2016     }
2017 
2018     function balanceOfAt(address owner, uint256 snapshotId)
2019         public
2020         constant
2021         returns (uint256)
2022     {
2023         return balanceOfAtInternal(owner, snapshotId);
2024     }
2025 
2026     function currentSnapshotId()
2027         public
2028         constant
2029         returns (uint256)
2030     {
2031         return mCurrentSnapshotId();
2032     }
2033 
2034     //
2035     // Implements IClonedTokenParent
2036     //
2037 
2038     function parentToken()
2039         public
2040         constant
2041         returns(IClonedTokenParent parent)
2042     {
2043         return PARENT_TOKEN;
2044     }
2045 
2046     /// @return snapshot at wchich initial token distribution was taken
2047     function parentSnapshotId()
2048         public
2049         constant
2050         returns(uint256 snapshotId)
2051     {
2052         return PARENT_SNAPSHOT_ID;
2053     }
2054 
2055     //
2056     // Other public functions
2057     //
2058 
2059     /// @notice gets all token balances of 'owner'
2060     /// @dev intended to be called via eth_call where gas limit is not an issue
2061     function allBalancesOf(address owner)
2062         external
2063         constant
2064         returns (uint256[2][])
2065     {
2066         /* very nice and working implementation below,
2067         // copy to memory
2068         Values[] memory values = _balances[owner];
2069         do assembly {
2070             // in memory structs have simple layout where every item occupies uint256
2071             balances := values
2072         } while (false);*/
2073 
2074         Values[] storage values = _balances[owner];
2075         uint256[2][] memory balances = new uint256[2][](values.length);
2076         for(uint256 ii = 0; ii < values.length; ++ii) {
2077             balances[ii] = [values[ii].snapshotId, values[ii].value];
2078         }
2079 
2080         return balances;
2081     }
2082 
2083     ////////////////////////
2084     // Internal functions
2085     ////////////////////////
2086 
2087     function totalSupplyAtInternal(uint256 snapshotId)
2088         internal
2089         constant
2090         returns(uint256)
2091     {
2092         Values[] storage values = _totalSupplyValues;
2093 
2094         // If there is a value, return it, reverts if value is in the future
2095         if (hasValueAt(values, snapshotId)) {
2096             return getValueAt(values, snapshotId, 0);
2097         }
2098 
2099         // Try parent contract at or before the fork
2100         if (address(PARENT_TOKEN) != 0) {
2101             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
2102             return PARENT_TOKEN.totalSupplyAt(earlierSnapshotId);
2103         }
2104 
2105         // Default to an empty balance
2106         return 0;
2107     }
2108 
2109     // get balance at snapshot if with continuation in parent token
2110     function balanceOfAtInternal(address owner, uint256 snapshotId)
2111         internal
2112         constant
2113         returns (uint256)
2114     {
2115         Values[] storage values = _balances[owner];
2116 
2117         // If there is a value, return it, reverts if value is in the future
2118         if (hasValueAt(values, snapshotId)) {
2119             return getValueAt(values, snapshotId, 0);
2120         }
2121 
2122         // Try parent contract at or before the fork
2123         if (PARENT_TOKEN != address(0)) {
2124             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
2125             return PARENT_TOKEN.balanceOfAt(owner, earlierSnapshotId);
2126         }
2127 
2128         // Default to an empty balance
2129         return 0;
2130     }
2131 
2132     //
2133     // Implements MTokenTransfer
2134     //
2135 
2136     /// @dev This is the actual transfer function in the token contract, it can
2137     ///  only be called by other functions in this contract.
2138     /// @param from The address holding the tokens being transferred
2139     /// @param to The address of the recipient
2140     /// @param amount The amount of tokens to be transferred
2141     /// @return True if the transfer was successful, reverts in any other case
2142     function mTransfer(
2143         address from,
2144         address to,
2145         uint256 amount
2146     )
2147         internal
2148     {
2149         // never send to address 0
2150         require(to != address(0));
2151         // block transfers in clone that points to future/current snapshots of parent token
2152         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2153         // Alerts the token controller of the transfer
2154         require(mOnTransfer(from, to, amount));
2155 
2156         // If the amount being transfered is more than the balance of the
2157         //  account the transfer reverts
2158         uint256 previousBalanceFrom = balanceOf(from);
2159         require(previousBalanceFrom >= amount);
2160 
2161         // First update the balance array with the new value for the address
2162         //  sending the tokens
2163         uint256 newBalanceFrom = previousBalanceFrom - amount;
2164         setValue(_balances[from], newBalanceFrom);
2165 
2166         // Then update the balance array with the new value for the address
2167         //  receiving the tokens
2168         uint256 previousBalanceTo = balanceOf(to);
2169         uint256 newBalanceTo = previousBalanceTo + amount;
2170         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
2171         setValue(_balances[to], newBalanceTo);
2172 
2173         // An event to make the transfer easy to find on the blockchain
2174         emit Transfer(from, to, amount);
2175     }
2176 }
2177 
2178 /// @title token generation and destruction
2179 /// @dev internal interface providing token generation and destruction, see MintableSnapshotToken for implementation
2180 contract MTokenMint {
2181 
2182     ////////////////////////
2183     // Internal functions
2184     ////////////////////////
2185 
2186     /// @notice Generates `amount` tokens that are assigned to `owner`
2187     /// @param owner The address that will be assigned the new tokens
2188     /// @param amount The quantity of tokens generated
2189     /// @dev reverts if tokens could not be generated
2190     function mGenerateTokens(address owner, uint256 amount)
2191         internal;
2192 
2193     /// @notice Burns `amount` tokens from `owner`
2194     /// @param owner The address that will lose the tokens
2195     /// @param amount The quantity of tokens to burn
2196     /// @dev reverts if tokens could not be destroyed
2197     function mDestroyTokens(address owner, uint256 amount)
2198         internal;
2199 }
2200 
2201 /// @title basic snapshot token with facitilites to generate and destroy tokens
2202 /// @dev implementes MTokenMint, does not expose any public functions that create/destroy tokens
2203 contract MintableSnapshotToken is
2204     BasicSnapshotToken,
2205     MTokenMint
2206 {
2207 
2208     ////////////////////////
2209     // Constructor
2210     ////////////////////////
2211 
2212     /// @notice Constructor to create a MintableSnapshotToken
2213     /// @param parentToken Address of the parent token, set to 0x0 if it is a
2214     ///  new token
2215     constructor(
2216         IClonedTokenParent parentToken,
2217         uint256 parentSnapshotId
2218     )
2219         BasicSnapshotToken(parentToken, parentSnapshotId)
2220         internal
2221     {}
2222 
2223     /// @notice Generates `amount` tokens that are assigned to `owner`
2224     /// @param owner The address that will be assigned the new tokens
2225     /// @param amount The quantity of tokens generated
2226     function mGenerateTokens(address owner, uint256 amount)
2227         internal
2228     {
2229         // never create for address 0
2230         require(owner != address(0));
2231         // block changes in clone that points to future/current snapshots of patent token
2232         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2233 
2234         uint256 curTotalSupply = totalSupply();
2235         uint256 newTotalSupply = curTotalSupply + amount;
2236         require(newTotalSupply >= curTotalSupply); // Check for overflow
2237 
2238         uint256 previousBalanceTo = balanceOf(owner);
2239         uint256 newBalanceTo = previousBalanceTo + amount;
2240         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
2241 
2242         setValue(_totalSupplyValues, newTotalSupply);
2243         setValue(_balances[owner], newBalanceTo);
2244 
2245         emit Transfer(0, owner, amount);
2246     }
2247 
2248     /// @notice Burns `amount` tokens from `owner`
2249     /// @param owner The address that will lose the tokens
2250     /// @param amount The quantity of tokens to burn
2251     function mDestroyTokens(address owner, uint256 amount)
2252         internal
2253     {
2254         // block changes in clone that points to future/current snapshots of patent token
2255         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2256 
2257         uint256 curTotalSupply = totalSupply();
2258         require(curTotalSupply >= amount);
2259 
2260         uint256 previousBalanceFrom = balanceOf(owner);
2261         require(previousBalanceFrom >= amount);
2262 
2263         uint256 newTotalSupply = curTotalSupply - amount;
2264         uint256 newBalanceFrom = previousBalanceFrom - amount;
2265         setValue(_totalSupplyValues, newTotalSupply);
2266         setValue(_balances[owner], newBalanceFrom);
2267 
2268         emit Transfer(owner, 0, amount);
2269     }
2270 }
2271 
2272 /*
2273     Copyright 2016, Jordi Baylina
2274     Copyright 2017, Remco Bloemen, Marcin Rudolf
2275 
2276     This program is free software: you can redistribute it and/or modify
2277     it under the terms of the GNU General Public License as published by
2278     the Free Software Foundation, either version 3 of the License, or
2279     (at your option) any later version.
2280 
2281     This program is distributed in the hope that it will be useful,
2282     but WITHOUT ANY WARRANTY; without even the implied warranty of
2283     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2284     GNU General Public License for more details.
2285 
2286     You should have received a copy of the GNU General Public License
2287     along with this program.  If not, see <http://www.gnu.org/licenses/>.
2288  */
2289 /// @title StandardSnapshotToken Contract
2290 /// @author Jordi Baylina, Remco Bloemen, Marcin Rudolf
2291 /// @dev This token contract's goal is to make it easy for anyone to clone this
2292 ///  token using the token distribution at a given block, this will allow DAO's
2293 ///  and DApps to upgrade their features in a decentralized manner without
2294 ///  affecting the original token
2295 /// @dev It is ERC20 compliant, but still needs to under go further testing.
2296 /// @dev Various contracts are composed to provide required functionality of this token, different compositions are possible
2297 ///     MintableSnapshotToken provides transfer, miniting and snapshotting functions
2298 ///     TokenAllowance provides approve/transferFrom functions
2299 ///     TokenMetadata adds name, symbol and other token metadata
2300 /// @dev This token is still abstract, Snapshot, BasicSnapshotToken and TokenAllowance observe interfaces that must be implemented
2301 ///     MSnapshotPolicy - particular snapshot id creation mechanism
2302 ///     MTokenController - controlls approvals and transfers
2303 ///     see Neumark as an example
2304 /// @dev implements ERC223 token transfer
2305 contract StandardSnapshotToken is
2306     MintableSnapshotToken,
2307     TokenAllowance
2308 {
2309     ////////////////////////
2310     // Constructor
2311     ////////////////////////
2312 
2313     /// @notice Constructor to create a MiniMeToken
2314     ///  is a new token
2315     /// param tokenName Name of the new token
2316     /// param decimalUnits Number of decimals of the new token
2317     /// param tokenSymbol Token Symbol for the new token
2318     constructor(
2319         IClonedTokenParent parentToken,
2320         uint256 parentSnapshotId
2321     )
2322         MintableSnapshotToken(parentToken, parentSnapshotId)
2323         TokenAllowance()
2324         internal
2325     {}
2326 }
2327 
2328 /// @title old ERC223 callback function
2329 /// @dev as used in Neumark and ICBMEtherToken
2330 contract IERC223LegacyCallback {
2331 
2332     ////////////////////////
2333     // Public functions
2334     ////////////////////////
2335 
2336     function onTokenTransfer(address from, uint256 amount, bytes data)
2337         public;
2338 
2339 }
2340 
2341 contract IERC223Token is IERC20Token, ITokenMetadata {
2342 
2343     /// @dev Departure: We do not log data, it has no advantage over a standard
2344     ///     log event. By sticking to the standard log event we
2345     ///     stay compatible with constracts that expect and ERC20 token.
2346 
2347     // event Transfer(
2348     //    address indexed from,
2349     //    address indexed to,
2350     //    uint256 amount,
2351     //    bytes data);
2352 
2353 
2354     /// @dev Departure: We do not use the callback on regular transfer calls to
2355     ///     stay compatible with constracts that expect and ERC20 token.
2356 
2357     // function transfer(address to, uint256 amount)
2358     //     public
2359     //     returns (bool);
2360 
2361     ////////////////////////
2362     // Public functions
2363     ////////////////////////
2364 
2365     function transfer(address to, uint256 amount, bytes data)
2366         public
2367         returns (bool);
2368 }
2369 
2370 contract Neumark is
2371     AccessControlled,
2372     AccessRoles,
2373     Agreement,
2374     DailyAndSnapshotable,
2375     StandardSnapshotToken,
2376     TokenMetadata,
2377     IERC223Token,
2378     NeumarkIssuanceCurve,
2379     Reclaimable,
2380     IsContract
2381 {
2382 
2383     ////////////////////////
2384     // Constants
2385     ////////////////////////
2386 
2387     string private constant TOKEN_NAME = "Neumark";
2388 
2389     uint8  private constant TOKEN_DECIMALS = 18;
2390 
2391     string private constant TOKEN_SYMBOL = "NEU";
2392 
2393     string private constant VERSION = "NMK_1.0";
2394 
2395     ////////////////////////
2396     // Mutable state
2397     ////////////////////////
2398 
2399     // disable transfers when Neumark is created
2400     bool private _transferEnabled = false;
2401 
2402     // at which point on curve new Neumarks will be created, see NeumarkIssuanceCurve contract
2403     // do not use to get total invested funds. see burn(). this is just a cache for expensive inverse function
2404     uint256 private _totalEurUlps;
2405 
2406     ////////////////////////
2407     // Events
2408     ////////////////////////
2409 
2410     event LogNeumarksIssued(
2411         address indexed owner,
2412         uint256 euroUlps,
2413         uint256 neumarkUlps
2414     );
2415 
2416     event LogNeumarksBurned(
2417         address indexed owner,
2418         uint256 euroUlps,
2419         uint256 neumarkUlps
2420     );
2421 
2422     ////////////////////////
2423     // Constructor
2424     ////////////////////////
2425 
2426     constructor(
2427         IAccessPolicy accessPolicy,
2428         IEthereumForkArbiter forkArbiter
2429     )
2430         AccessRoles()
2431         Agreement(accessPolicy, forkArbiter)
2432         StandardSnapshotToken(
2433             IClonedTokenParent(0x0),
2434             0
2435         )
2436         TokenMetadata(
2437             TOKEN_NAME,
2438             TOKEN_DECIMALS,
2439             TOKEN_SYMBOL,
2440             VERSION
2441         )
2442         DailyAndSnapshotable(0)
2443         NeumarkIssuanceCurve()
2444         Reclaimable()
2445         public
2446     {}
2447 
2448     ////////////////////////
2449     // Public functions
2450     ////////////////////////
2451 
2452     /// @notice issues new Neumarks to msg.sender with reward at current curve position
2453     ///     moves curve position by euroUlps
2454     ///     callable only by ROLE_NEUMARK_ISSUER
2455     function issueForEuro(uint256 euroUlps)
2456         public
2457         only(ROLE_NEUMARK_ISSUER)
2458         acceptAgreement(msg.sender)
2459         returns (uint256)
2460     {
2461         require(_totalEurUlps + euroUlps >= _totalEurUlps);
2462         uint256 neumarkUlps = incremental(_totalEurUlps, euroUlps);
2463         _totalEurUlps += euroUlps;
2464         mGenerateTokens(msg.sender, neumarkUlps);
2465         emit LogNeumarksIssued(msg.sender, euroUlps, neumarkUlps);
2466         return neumarkUlps;
2467     }
2468 
2469     /// @notice used by ROLE_NEUMARK_ISSUER to transer newly issued neumarks
2470     ///     typically to the investor and platform operator
2471     function distribute(address to, uint256 neumarkUlps)
2472         public
2473         only(ROLE_NEUMARK_ISSUER)
2474         acceptAgreement(to)
2475     {
2476         mTransfer(msg.sender, to, neumarkUlps);
2477     }
2478 
2479     /// @notice msg.sender can burn their Neumarks, curve is rolled back using inverse
2480     ///     curve. as a result cost of Neumark gets lower (reward is higher)
2481     function burn(uint256 neumarkUlps)
2482         public
2483         only(ROLE_NEUMARK_BURNER)
2484     {
2485         burnPrivate(neumarkUlps, 0, _totalEurUlps);
2486     }
2487 
2488     /// @notice executes as function above but allows to provide search range for low gas burning
2489     function burn(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2490         public
2491         only(ROLE_NEUMARK_BURNER)
2492     {
2493         burnPrivate(neumarkUlps, minEurUlps, maxEurUlps);
2494     }
2495 
2496     function enableTransfer(bool enabled)
2497         public
2498         only(ROLE_TRANSFER_ADMIN)
2499     {
2500         _transferEnabled = enabled;
2501     }
2502 
2503     function createSnapshot()
2504         public
2505         only(ROLE_SNAPSHOT_CREATOR)
2506         returns (uint256)
2507     {
2508         return DailyAndSnapshotable.createSnapshot();
2509     }
2510 
2511     function transferEnabled()
2512         public
2513         constant
2514         returns (bool)
2515     {
2516         return _transferEnabled;
2517     }
2518 
2519     function totalEuroUlps()
2520         public
2521         constant
2522         returns (uint256)
2523     {
2524         return _totalEurUlps;
2525     }
2526 
2527     function incremental(uint256 euroUlps)
2528         public
2529         constant
2530         returns (uint256 neumarkUlps)
2531     {
2532         return incremental(_totalEurUlps, euroUlps);
2533     }
2534 
2535     //
2536     // Implements IERC223Token with IERC223Callback (onTokenTransfer) callback
2537     //
2538 
2539     // old implementation of ERC223 that was actual when ICBM was deployed
2540     // as Neumark is already deployed this function keeps old behavior for testing
2541     function transfer(address to, uint256 amount, bytes data)
2542         public
2543         returns (bool)
2544     {
2545         // it is necessary to point out implementation to be called
2546         BasicSnapshotToken.mTransfer(msg.sender, to, amount);
2547 
2548         // Notify the receiving contract.
2549         if (isContract(to)) {
2550             IERC223LegacyCallback(to).onTokenTransfer(msg.sender, amount, data);
2551         }
2552         return true;
2553     }
2554 
2555     ////////////////////////
2556     // Internal functions
2557     ////////////////////////
2558 
2559     //
2560     // Implements MTokenController
2561     //
2562 
2563     function mOnTransfer(
2564         address from,
2565         address, // to
2566         uint256 // amount
2567     )
2568         internal
2569         acceptAgreement(from)
2570         returns (bool allow)
2571     {
2572         // must have transfer enabled or msg.sender is Neumark issuer
2573         return _transferEnabled || accessPolicy().allowed(msg.sender, ROLE_NEUMARK_ISSUER, this, msg.sig);
2574     }
2575 
2576     function mOnApprove(
2577         address owner,
2578         address, // spender,
2579         uint256 // amount
2580     )
2581         internal
2582         acceptAgreement(owner)
2583         returns (bool allow)
2584     {
2585         return true;
2586     }
2587 
2588     ////////////////////////
2589     // Private functions
2590     ////////////////////////
2591 
2592     function burnPrivate(uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2593         private
2594     {
2595         uint256 prevEuroUlps = _totalEurUlps;
2596         // burn first in the token to make sure balance/totalSupply is not crossed
2597         mDestroyTokens(msg.sender, burnNeumarkUlps);
2598         _totalEurUlps = cumulativeInverse(totalSupply(), minEurUlps, maxEurUlps);
2599         // actually may overflow on non-monotonic inverse
2600         assert(prevEuroUlps >= _totalEurUlps);
2601         uint256 euroUlps = prevEuroUlps - _totalEurUlps;
2602         emit LogNeumarksBurned(msg.sender, euroUlps, burnNeumarkUlps);
2603     }
2604 }
2605 
2606 /// @title current ERC223 fallback function
2607 /// @dev to be used in all future token contract
2608 /// @dev NEU and ICBMEtherToken (obsolete) are the only contracts that still uses IERC223LegacyCallback
2609 contract IERC223Callback {
2610 
2611     ////////////////////////
2612     // Public functions
2613     ////////////////////////
2614 
2615     function tokenFallback(address from, uint256 amount, bytes data)
2616         public;
2617 
2618 }
2619 
2620 /// @title disburse payment token amount to snapshot token holders
2621 /// @dev payment token received via ERC223 Transfer
2622 contract IFeeDisbursal is IERC223Callback {
2623     // TODO: declare interface
2624     function claim() public;
2625 
2626     function recycle() public;
2627 }
2628 
2629 /// @title disburse payment token amount to snapshot token holders
2630 /// @dev payment token received via ERC223 Transfer
2631 contract IPlatformPortfolio is IERC223Callback {
2632     // TODO: declare interface
2633 }
2634 
2635 contract ITokenExchangeRateOracle {
2636     /// @notice provides actual price of 'numeratorToken' in 'denominatorToken'
2637     ///     returns timestamp at which price was obtained in oracle
2638     function getExchangeRate(address numeratorToken, address denominatorToken)
2639         public
2640         constant
2641         returns (uint256 rateFraction, uint256 timestamp);
2642 
2643     /// @notice allows to retreive multiple exchange rates in once call
2644     function getExchangeRates(address[] numeratorTokens, address[] denominatorTokens)
2645         public
2646         constant
2647         returns (uint256[] rateFractions, uint256[] timestamps);
2648 }
2649 
2650 /// @title root of trust and singletons + known interface registry
2651 /// provides a root which holds all interfaces platform trust, this includes
2652 /// singletons - for which accessors are provided
2653 /// collections of known instances of interfaces
2654 /// @dev interfaces are identified by bytes4, see KnownInterfaces.sol
2655 contract Universe is
2656     Agreement,
2657     IContractId,
2658     KnownInterfaces
2659 {
2660     ////////////////////////
2661     // Events
2662     ////////////////////////
2663 
2664     /// raised on any change of singleton instance
2665     /// @dev for convenience we provide previous instance of singleton in replacedInstance
2666     event LogSetSingleton(
2667         bytes4 interfaceId,
2668         address instance,
2669         address replacedInstance
2670     );
2671 
2672     /// raised on add/remove interface instance in collection
2673     event LogSetCollectionInterface(
2674         bytes4 interfaceId,
2675         address instance,
2676         bool isSet
2677     );
2678 
2679     ////////////////////////
2680     // Mutable state
2681     ////////////////////////
2682 
2683     // mapping of known contracts to addresses of singletons
2684     mapping(bytes4 => address) private _singletons;
2685 
2686     // mapping of known interfaces to collections of contracts
2687     mapping(bytes4 =>
2688         mapping(address => bool)) private _collections; // solium-disable-line indentation
2689 
2690     // known instances
2691     mapping(address => bytes4[]) private _instances;
2692 
2693 
2694     ////////////////////////
2695     // Constructor
2696     ////////////////////////
2697 
2698     constructor(
2699         IAccessPolicy accessPolicy,
2700         IEthereumForkArbiter forkArbiter
2701     )
2702         Agreement(accessPolicy, forkArbiter)
2703         public
2704     {
2705         setSingletonPrivate(KNOWN_INTERFACE_ACCESS_POLICY, accessPolicy);
2706         setSingletonPrivate(KNOWN_INTERFACE_FORK_ARBITER, forkArbiter);
2707     }
2708 
2709     ////////////////////////
2710     // Public methods
2711     ////////////////////////
2712 
2713     /// get singleton instance for 'interfaceId'
2714     function getSingleton(bytes4 interfaceId)
2715         public
2716         constant
2717         returns (address)
2718     {
2719         return _singletons[interfaceId];
2720     }
2721 
2722     function getManySingletons(bytes4[] interfaceIds)
2723         public
2724         constant
2725         returns (address[])
2726     {
2727         address[] memory addresses = new address[](interfaceIds.length);
2728         uint256 idx;
2729         while(idx < interfaceIds.length) {
2730             addresses[idx] = _singletons[interfaceIds[idx]];
2731             idx += 1;
2732         }
2733         return addresses;
2734     }
2735 
2736     /// checks of 'instance' is instance of interface 'interfaceId'
2737     function isSingleton(bytes4 interfaceId, address instance)
2738         public
2739         constant
2740         returns (bool)
2741     {
2742         return _singletons[interfaceId] == instance;
2743     }
2744 
2745     /// checks if 'instance' is one of instances of 'interfaceId'
2746     function isInterfaceCollectionInstance(bytes4 interfaceId, address instance)
2747         public
2748         constant
2749         returns (bool)
2750     {
2751         return _collections[interfaceId][instance];
2752     }
2753 
2754     function isAnyOfInterfaceCollectionInstance(bytes4[] interfaceIds, address instance)
2755         public
2756         constant
2757         returns (bool)
2758     {
2759         uint256 idx;
2760         while(idx < interfaceIds.length) {
2761             if (_collections[interfaceIds[idx]][instance]) {
2762                 return true;
2763             }
2764             idx += 1;
2765         }
2766         return false;
2767     }
2768 
2769     /// gets all interfaces of given instance
2770     function getInterfacesOfInstance(address instance)
2771         public
2772         constant
2773         returns (bytes4[] interfaces)
2774     {
2775         return _instances[instance];
2776     }
2777 
2778     /// sets 'instance' of singleton with interface 'interfaceId'
2779     function setSingleton(bytes4 interfaceId, address instance)
2780         public
2781         only(ROLE_UNIVERSE_MANAGER)
2782     {
2783         setSingletonPrivate(interfaceId, instance);
2784     }
2785 
2786     /// convenience method for setting many singleton instances
2787     function setManySingletons(bytes4[] interfaceIds, address[] instances)
2788         public
2789         only(ROLE_UNIVERSE_MANAGER)
2790     {
2791         require(interfaceIds.length == instances.length);
2792         uint256 idx;
2793         while(idx < interfaceIds.length) {
2794             setSingletonPrivate(interfaceIds[idx], instances[idx]);
2795             idx += 1;
2796         }
2797     }
2798 
2799     /// set or unset 'instance' with 'interfaceId' in collection of instances
2800     function setCollectionInterface(bytes4 interfaceId, address instance, bool set)
2801         public
2802         only(ROLE_UNIVERSE_MANAGER)
2803     {
2804         setCollectionPrivate(interfaceId, instance, set);
2805     }
2806 
2807     /// set or unset 'instance' in many collections of instances
2808     function setInterfaceInManyCollections(bytes4[] interfaceIds, address instance, bool set)
2809         public
2810         only(ROLE_UNIVERSE_MANAGER)
2811     {
2812         uint256 idx;
2813         while(idx < interfaceIds.length) {
2814             setCollectionPrivate(interfaceIds[idx], instance, set);
2815             idx += 1;
2816         }
2817     }
2818 
2819     /// set or unset array of collection
2820     function setCollectionsInterfaces(bytes4[] interfaceIds, address[] instances, bool[] set_flags)
2821         public
2822         only(ROLE_UNIVERSE_MANAGER)
2823     {
2824         require(interfaceIds.length == instances.length);
2825         require(interfaceIds.length == set_flags.length);
2826         uint256 idx;
2827         while(idx < interfaceIds.length) {
2828             setCollectionPrivate(interfaceIds[idx], instances[idx], set_flags[idx]);
2829             idx += 1;
2830         }
2831     }
2832 
2833     //
2834     // Implements IContractId
2835     //
2836 
2837     function contractId() public pure returns (bytes32 id, uint256 version) {
2838         return (0x8b57bfe21a3ef4854e19d702063b6cea03fa514162f8ff43fde551f06372fefd, 0);
2839     }
2840 
2841     ////////////////////////
2842     // Getters
2843     ////////////////////////
2844 
2845     function accessPolicy() public constant returns (IAccessPolicy) {
2846         return IAccessPolicy(_singletons[KNOWN_INTERFACE_ACCESS_POLICY]);
2847     }
2848 
2849     function forkArbiter() public constant returns (IEthereumForkArbiter) {
2850         return IEthereumForkArbiter(_singletons[KNOWN_INTERFACE_FORK_ARBITER]);
2851     }
2852 
2853     function neumark() public constant returns (Neumark) {
2854         return Neumark(_singletons[KNOWN_INTERFACE_NEUMARK]);
2855     }
2856 
2857     function etherToken() public constant returns (IERC223Token) {
2858         return IERC223Token(_singletons[KNOWN_INTERFACE_ETHER_TOKEN]);
2859     }
2860 
2861     function euroToken() public constant returns (IERC223Token) {
2862         return IERC223Token(_singletons[KNOWN_INTERFACE_EURO_TOKEN]);
2863     }
2864 
2865     function etherLock() public constant returns (address) {
2866         return _singletons[KNOWN_INTERFACE_ETHER_LOCK];
2867     }
2868 
2869     function euroLock() public constant returns (address) {
2870         return _singletons[KNOWN_INTERFACE_EURO_LOCK];
2871     }
2872 
2873     function icbmEtherLock() public constant returns (address) {
2874         return _singletons[KNOWN_INTERFACE_ICBM_ETHER_LOCK];
2875     }
2876 
2877     function icbmEuroLock() public constant returns (address) {
2878         return _singletons[KNOWN_INTERFACE_ICBM_EURO_LOCK];
2879     }
2880 
2881     function identityRegistry() public constant returns (address) {
2882         return IIdentityRegistry(_singletons[KNOWN_INTERFACE_IDENTITY_REGISTRY]);
2883     }
2884 
2885     function tokenExchangeRateOracle() public constant returns (address) {
2886         return ITokenExchangeRateOracle(_singletons[KNOWN_INTERFACE_TOKEN_EXCHANGE_RATE_ORACLE]);
2887     }
2888 
2889     function feeDisbursal() public constant returns (address) {
2890         return IFeeDisbursal(_singletons[KNOWN_INTERFACE_FEE_DISBURSAL]);
2891     }
2892 
2893     function platformPortfolio() public constant returns (address) {
2894         return IPlatformPortfolio(_singletons[KNOWN_INTERFACE_PLATFORM_PORTFOLIO]);
2895     }
2896 
2897     function tokenExchange() public constant returns (address) {
2898         return _singletons[KNOWN_INTERFACE_TOKEN_EXCHANGE];
2899     }
2900 
2901     function gasExchange() public constant returns (address) {
2902         return _singletons[KNOWN_INTERFACE_GAS_EXCHANGE];
2903     }
2904 
2905     function platformTerms() public constant returns (address) {
2906         return _singletons[KNOWN_INTERFACE_PLATFORM_TERMS];
2907     }
2908 
2909     ////////////////////////
2910     // Private methods
2911     ////////////////////////
2912 
2913     function setSingletonPrivate(bytes4 interfaceId, address instance)
2914         private
2915     {
2916         require(interfaceId != KNOWN_INTERFACE_UNIVERSE, "NF_UNI_NO_UNIVERSE_SINGLETON");
2917         address replacedInstance = _singletons[interfaceId];
2918         // do nothing if not changing
2919         if (replacedInstance != instance) {
2920             dropInstance(replacedInstance, interfaceId);
2921             addInstance(instance, interfaceId);
2922             _singletons[interfaceId] = instance;
2923         }
2924 
2925         emit LogSetSingleton(interfaceId, instance, replacedInstance);
2926     }
2927 
2928     function setCollectionPrivate(bytes4 interfaceId, address instance, bool set)
2929         private
2930     {
2931         // do nothing if not changing
2932         if (_collections[interfaceId][instance] == set) {
2933             return;
2934         }
2935         _collections[interfaceId][instance] = set;
2936         if (set) {
2937             addInstance(instance, interfaceId);
2938         } else {
2939             dropInstance(instance, interfaceId);
2940         }
2941         emit LogSetCollectionInterface(interfaceId, instance, set);
2942     }
2943 
2944     function addInstance(address instance, bytes4 interfaceId)
2945         private
2946     {
2947         if (instance == address(0)) {
2948             // do not add null instance
2949             return;
2950         }
2951         bytes4[] storage current = _instances[instance];
2952         uint256 idx;
2953         while(idx < current.length) {
2954             // instancy has this interface already, do nothing
2955             if (current[idx] == interfaceId)
2956                 return;
2957             idx += 1;
2958         }
2959         // new interface
2960         current.push(interfaceId);
2961     }
2962 
2963     function dropInstance(address instance, bytes4 interfaceId)
2964         private
2965     {
2966         if (instance == address(0)) {
2967             // do not drop null instance
2968             return;
2969         }
2970         bytes4[] storage current = _instances[instance];
2971         uint256 idx;
2972         uint256 last = current.length - 1;
2973         while(idx <= last) {
2974             if (current[idx] == interfaceId) {
2975                 // delete element
2976                 if (idx < last) {
2977                     // if not last element move last element to idx being deleted
2978                     current[idx] = current[last];
2979                 }
2980                 // delete last element
2981                 current.length -= 1;
2982                 return;
2983             }
2984             idx += 1;
2985         }
2986     }
2987 }
2988 
2989 /// @title token controller for EuroToken
2990 /// @notice permissions for transfer are divided in 'from' permission (address sends funds)
2991 ///  and 'to' permission (address receives funds). both transfer sides must have appropriate permission for transfer to happen
2992 ///  also controls for minimum amounts in deposit and withdraw permissions
2993 ///  whitelist several known singleton contracts from Universe to be able to receive and send EUR-T
2994 /// @dev if contracts are replaced in universe, `applySettings` function must be called
2995 contract EuroTokenController is
2996     ITokenController,
2997     IContractId,
2998     AccessControlled,
2999     AccessRoles,
3000     IdentityRecord,
3001     KnownInterfaces
3002 {
3003 
3004     ////////////////////////
3005     // Events
3006     ////////////////////////
3007 
3008     event LogAllowedFromAddress(
3009         address indexed from,
3010         bool allowed
3011     );
3012 
3013     event LogAllowedToAddress(
3014         address indexed to,
3015         bool allowed
3016     );
3017 
3018     // allowances for special contracts were made, see
3019     // allowFromUniverse function
3020     event LogUniverseReloaded();
3021 
3022     // new withdraw and deposit settings were made
3023     event LogSettingsChanged(
3024         uint256 minDepositAmountEurUlps,
3025         uint256 minWithdrawAmountEurUlps,
3026         uint256 maxSimpleExchangeAllowanceEurUlps
3027     );
3028 
3029     // new deposit/withdraw fees were set
3030     event LogFeeSettingsChanged(
3031         uint256 depositFeeFraction,
3032         uint256 withdrawFeeFraction
3033     );
3034 
3035     // deposit manager was changed
3036     event LogDepositManagerChanged(
3037         address oldDepositManager,
3038         address newDepositManager
3039     );
3040 
3041     ////////////////////////
3042     // Constants
3043     ////////////////////////
3044 
3045     bytes4[] private TRANSFER_ALLOWED_INTERFACES = [KNOWN_INTERFACE_COMMITMENT, KNOWN_INTERFACE_EQUITY_TOKEN_CONTROLLER];
3046 
3047     ////////////////////////
3048     // Immutable state
3049     ////////////////////////
3050 
3051     Universe private UNIVERSE;
3052 
3053     ////////////////////////
3054     // Mutable state
3055     ////////////////////////
3056 
3057     // a list of addresses that are allowed to receive EUR-T
3058     mapping(address => bool) private _allowedTransferTo;
3059 
3060     // a list of of addresses that are allowed to send EUR-T
3061     mapping(address => bool) private _allowedTransferFrom;
3062 
3063     // min deposit amount
3064     uint256 private _minDepositAmountEurUlps;
3065 
3066     // min withdraw amount
3067     uint256 private _minWithdrawAmountEurUlps;
3068 
3069     // max token exchange can make for gas purchase
3070     uint256 private _maxSimpleExchangeAllowanceEurUlps;
3071 
3072     // fraction of amount deposited to bank account takes as a fee - before deposit to token is made
3073     uint256 private _depositFeeFraction;
3074 
3075     // fraction of amount withdrawn to holder bank account taken as a fee - after withdraw from token is made
3076     uint256 private _withdrawalFeeFraction;
3077 
3078     // identity registry
3079     IIdentityRegistry private _identityRegistry;
3080 
3081     // issuer of the token, must have ROLE_EURT_DEPOSIT_MANAGER role
3082     // also is able to set deposit and withdraw fees
3083     // issuer is a legal representation of a bank, payment gateway or bank account holder where settlement happens
3084     // that settles incoming and outgoing bank transactions
3085     address private _depositManager;
3086 
3087     ////////////////////////
3088     // Constructor
3089     ////////////////////////
3090 
3091     modifier onlyDepositManager() {
3092         require(msg.sender == _depositManager);
3093         _;
3094     }
3095 
3096     ////////////////////////
3097     // Constructor
3098     ////////////////////////
3099 
3100     constructor(
3101         Universe universe,
3102         address depositManager
3103     )
3104         AccessControlled(universe.accessPolicy())
3105         public
3106     {
3107         UNIVERSE = universe;
3108         _depositManager = depositManager;
3109     }
3110 
3111     ////////////////////////
3112     // Public Functions
3113     ////////////////////////
3114 
3115     /// @notice enables or disables address to be receipient of EUR-T
3116     function setAllowedTransferTo(address to, bool allowed)
3117         public
3118         only(ROLE_EURT_LEGAL_MANAGER)
3119     {
3120         setAllowedTransferToPrivate(to, allowed);
3121     }
3122 
3123     /// @notice enables or disables address to be sender of EUR-T
3124     function setAllowedTransferFrom(address from, bool allowed)
3125         public
3126         only(ROLE_EURT_LEGAL_MANAGER)
3127     {
3128         setAllowedTransferFromPrivate(from, allowed);
3129     }
3130 
3131     /// @notice changes deposit manager
3132     function changeDepositManager(address newDepositManager)
3133         public
3134         only(ROLE_EURT_LEGAL_MANAGER)
3135     {
3136         require(newDepositManager != address(0));
3137         emit LogDepositManagerChanged(_depositManager, newDepositManager);
3138         _depositManager = newDepositManager;
3139     }
3140 
3141     /// @notice sets limits and whitelists contracts from universe
3142     function applySettings(
3143         uint256 minDepositAmountEurUlps,
3144         uint256 minWithdrawAmountEurUlps,
3145         uint256 maxSimpleExchangeAllowanceEurUlps
3146     )
3147         public
3148         only(ROLE_EURT_LEGAL_MANAGER)
3149     {
3150         applySettingsPrivate(
3151             minDepositAmountEurUlps,
3152             minWithdrawAmountEurUlps,
3153             maxSimpleExchangeAllowanceEurUlps
3154         );
3155         _identityRegistry = IIdentityRegistry(UNIVERSE.identityRegistry());
3156         allowFromUniverse();
3157     }
3158 
3159     /// @notice set official deposit and withdraw fees
3160     /// fees are fractions of amount of deposit/withdraw (volume based)
3161     /// deposit fees are taken by deposit manager before `deposit` is called on EuroToken, from amount sent to the bank
3162     /// withdraw fees are taken from amount burned via `withdraw` funtion of EuroToken, deposit manager informs on final settlement via settleWithdraw
3163     function applyFeeSettings(
3164         uint256 depositFeeFraction,
3165         uint256 withdrawalFeeFraction
3166     )
3167         public
3168         onlyDepositManager
3169         only(ROLE_EURT_DEPOSIT_MANAGER)
3170     {
3171         require(depositFeeFraction < 10**18);
3172         require(withdrawalFeeFraction < 10**18);
3173         _depositFeeFraction = depositFeeFraction;
3174         _withdrawalFeeFraction = withdrawalFeeFraction;
3175         emit LogFeeSettingsChanged(depositFeeFraction, withdrawalFeeFraction);
3176     }
3177 
3178     //
3179     // Public Getters
3180     //
3181 
3182     function allowedTransferTo(address to)
3183         public
3184         constant
3185         returns (bool)
3186     {
3187         return _allowedTransferTo[to];
3188     }
3189 
3190     function allowedTransferFrom(address from)
3191         public
3192         constant
3193         returns (bool)
3194     {
3195         return _allowedTransferFrom[from];
3196     }
3197 
3198     function minDepositAmountEurUlps()
3199         public
3200         constant
3201         returns (uint256)
3202     {
3203         return _minDepositAmountEurUlps;
3204     }
3205 
3206     function minWithdrawAmountEurUlps()
3207         public
3208         constant
3209         returns (uint256)
3210     {
3211         return _minWithdrawAmountEurUlps;
3212     }
3213 
3214     function maxSimpleExchangeAllowanceEurUlps()
3215         public
3216         constant
3217         returns (uint256)
3218     {
3219         return _maxSimpleExchangeAllowanceEurUlps;
3220     }
3221 
3222     function depositManager()
3223         public
3224         constant
3225         returns (address)
3226     {
3227         return _depositManager;
3228     }
3229 
3230     function depositFeeFraction()
3231         public
3232         constant
3233         returns (uint256)
3234     {
3235         return _depositFeeFraction;
3236     }
3237 
3238     function withdrawalFeeFraction()
3239         public
3240         constant
3241         returns (uint256)
3242     {
3243         return _withdrawalFeeFraction;
3244     }
3245 
3246     //
3247     // Implements ITokenController
3248     //
3249 
3250     function onTransfer(address broker, address from, address to, uint256 /*amount*/)
3251         public
3252         constant
3253         returns (bool allow)
3254     {
3255         // detect brokered (transferFrom) transfer when from is different address executing transfer
3256         bool isBrokeredTransfer = broker != from;
3257         // "from" must be allowed to transfer from to "to"
3258         bool isTransferAllowed = isTransferAllowedPrivate(from, to, isBrokeredTransfer);
3259         // broker must have direct permission to transfer from
3260         bool isBrokerAllowed = !isBrokeredTransfer || _allowedTransferFrom[broker];
3261         return isTransferAllowed && isBrokerAllowed;
3262     }
3263 
3264     /// always approve
3265     function onApprove(address, address, uint256)
3266         public
3267         constant
3268         returns (bool allow)
3269     {
3270         return true;
3271     }
3272 
3273     /// allows to deposit if user has kyc and deposit is >= minimum
3274     function onGenerateTokens(address /*sender*/, address owner, uint256 amount)
3275         public
3276         constant
3277         returns (bool allow)
3278     {
3279         if (amount < _minDepositAmountEurUlps) {
3280             return false;
3281         }
3282         if(_allowedTransferTo[owner]) {
3283             return true;
3284         }
3285         IdentityClaims memory claims = deserializeClaims(_identityRegistry.getClaims(owner));
3286         return claims.isVerified && !claims.accountFrozen;
3287     }
3288 
3289     /// allow to withdraw if user has a valid bank account, kyc and amount >= minium
3290     function onDestroyTokens(address /*sender*/, address owner, uint256 amount)
3291         public
3292         constant
3293         returns (bool allow)
3294     {
3295         if (amount < _minWithdrawAmountEurUlps) {
3296             return false;
3297         }
3298         if(_allowedTransferFrom[owner]) {
3299             return true;
3300         }
3301         IdentityClaims memory claims = deserializeClaims(_identityRegistry.getClaims(owner));
3302         return claims.isVerified && !claims.accountFrozen && claims.hasBankAccount;
3303     }
3304 
3305     function onChangeTokenController(address sender, address newController)
3306         public
3307         constant
3308         returns (bool)
3309     {
3310         // can change if original sender (sender) has role on ROLE_EURT_LEGAL_MANAGER on msg.sender (which is euro token)
3311         // this replaces only() modifier on euro token method
3312         return accessPolicy().allowed(sender, ROLE_EURT_LEGAL_MANAGER, msg.sender, msg.sig) && newController != address(0x0);
3313     }
3314 
3315     /// always allow to transfer from owner to simple exchange lte _maxSimpleExchangeAllowanceEurUlps
3316     function onAllowance(address /*owner*/, address spender)
3317         public
3318         constant
3319         returns (uint256)
3320     {
3321         address exchange = UNIVERSE.gasExchange();
3322         if (spender == address(exchange)) {
3323             // override on allowance to simple exchange
3324             return _maxSimpleExchangeAllowanceEurUlps;
3325         } else {
3326             return 0; // no override
3327         }
3328     }
3329 
3330     //
3331     // Implements IContractId
3332     //
3333 
3334     function contractId() public pure returns (bytes32 id, uint256 version) {
3335         return (0xddc22bc86ca8ebf8229756d3fd83791c143630f28e301fef65bbe3070a377f2a, 1);
3336     }
3337 
3338     ////////////////////////
3339     // Private Functions
3340     ////////////////////////
3341 
3342     function applySettingsPrivate(
3343         uint256 pMinDepositAmountEurUlps,
3344         uint256 pMinWithdrawAmountEurUlps,
3345         uint256 pMaxSimpleExchangeAllowanceEurUlps
3346     )
3347         private
3348     {
3349         _minDepositAmountEurUlps = pMinDepositAmountEurUlps;
3350         _minWithdrawAmountEurUlps = pMinWithdrawAmountEurUlps;
3351         _maxSimpleExchangeAllowanceEurUlps = pMaxSimpleExchangeAllowanceEurUlps;
3352         emit LogSettingsChanged(_minDepositAmountEurUlps, _minWithdrawAmountEurUlps, _maxSimpleExchangeAllowanceEurUlps);
3353     }
3354 
3355     /// enables to and from transfers for several Universe singletons
3356     function allowFromUniverse()
3357         private
3358     {
3359         // contracts below may send funds
3360         // euro lock must be able to send (invest)
3361         setAllowedTransferFromPrivate(UNIVERSE.euroLock(), true);
3362         // fee disbursal must be able to pay out
3363         setAllowedTransferFromPrivate(UNIVERSE.feeDisbursal(), true);
3364         // gas exchange must be able to act as a broker (from)
3365         setAllowedTransferFromPrivate(UNIVERSE.gasExchange(), true);
3366 
3367         // contracts below may receive funds
3368         // euro lock may receive refunds
3369         setAllowedTransferToPrivate(UNIVERSE.euroLock(), true);
3370         // fee disbursal may receive funds to disburse
3371         setAllowedTransferToPrivate(UNIVERSE.feeDisbursal(), true);
3372         // gas exchange must be able to receive euro token (as payment)
3373         setAllowedTransferToPrivate(UNIVERSE.gasExchange(), true);
3374 
3375         emit LogUniverseReloaded();
3376     }
3377 
3378     function setAllowedTransferToPrivate(address to, bool allowed)
3379         private
3380     {
3381         _allowedTransferTo[to] = allowed;
3382         emit LogAllowedToAddress(to, allowed);
3383     }
3384 
3385     function setAllowedTransferFromPrivate(address from, bool allowed)
3386         private
3387     {
3388         _allowedTransferFrom[from] = allowed;
3389         emit LogAllowedFromAddress(from, allowed);
3390     }
3391 
3392     // optionally allows peer to peer transfers of Verified users: for the transferFrom check
3393     function isTransferAllowedPrivate(address from, address to, bool allowPeerTransfers)
3394         private
3395         constant
3396         returns (bool)
3397     {
3398         // check if both parties are explicitely allowed for transfers
3399         bool explicitFrom = _allowedTransferFrom[from];
3400         bool explicitTo = _allowedTransferTo[to];
3401         if (explicitFrom && explicitTo) {
3402             return true;
3403         }
3404         // try to resolve 'from'
3405         if (!explicitFrom) {
3406             IdentityClaims memory claimsFrom = deserializeClaims(_identityRegistry.getClaims(from));
3407             explicitFrom = claimsFrom.isVerified && !claimsFrom.accountFrozen;
3408         }
3409         if (!explicitFrom) {
3410             // all ETO and ETC contracts may send funds (for example: refund)
3411             explicitFrom = UNIVERSE.isAnyOfInterfaceCollectionInstance(TRANSFER_ALLOWED_INTERFACES, from);
3412         }
3413         if (!explicitFrom) {
3414             // from will not be resolved, return immediately
3415             return false;
3416         }
3417         if (!explicitTo) {
3418             // all ETO and ETC contracts may receive funds
3419             explicitTo = UNIVERSE.isAnyOfInterfaceCollectionInstance(TRANSFER_ALLOWED_INTERFACES, to);
3420         }
3421         if (!explicitTo) {
3422             // if not, `to` address must have kyc (all addresses with KYC may receive transfers)
3423             IdentityClaims memory claims = deserializeClaims(_identityRegistry.getClaims(to));
3424             explicitTo = claims.isVerified && !claims.accountFrozen;
3425         }
3426         if (allowPeerTransfers) {
3427             return explicitTo;
3428         }
3429         if(claims.isVerified && !claims.accountFrozen && claimsFrom.isVerified && !claimsFrom.accountFrozen) {
3430             // user to user transfer not allowed
3431             return false;
3432         }
3433         // we only get here if explicitFrom was true
3434         return explicitTo;
3435     }
3436 }