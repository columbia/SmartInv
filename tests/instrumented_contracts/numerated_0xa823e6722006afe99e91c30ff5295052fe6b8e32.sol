1 pragma solidity 0.4.15;
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
101     function AccessControlled(IAccessPolicy policy) internal {
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
128         LogAccessPolicyChanged(msg.sender, oldPolicy, newPolicy);
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
140 contract AccessRoles {
141 
142     ////////////////////////
143     // Constants
144     ////////////////////////
145 
146     // NOTE: All roles are set to the keccak256 hash of the
147     // CamelCased role name, i.e.
148     // ROLE_LOCKED_ACCOUNT_ADMIN = keccak256("LockedAccountAdmin")
149 
150     // may setup LockedAccount, change disbursal mechanism and set migration
151     bytes32 internal constant ROLE_LOCKED_ACCOUNT_ADMIN = 0x4675da546d2d92c5b86c4f726a9e61010dce91cccc2491ce6019e78b09d2572e;
152 
153     // may setup whitelists and abort whitelisting contract with curve rollback
154     bytes32 internal constant ROLE_WHITELIST_ADMIN = 0xaef456e7c864418e1d2a40d996ca4febf3a7e317fe3af5a7ea4dda59033bbe5c;
155 
156     // May issue (generate) Neumarks
157     bytes32 internal constant ROLE_NEUMARK_ISSUER = 0x921c3afa1f1fff707a785f953a1e197bd28c9c50e300424e015953cbf120c06c;
158 
159     // May burn Neumarks it owns
160     bytes32 internal constant ROLE_NEUMARK_BURNER = 0x19ce331285f41739cd3362a3ec176edffe014311c0f8075834fdd19d6718e69f;
161 
162     // May create new snapshots on Neumark
163     bytes32 internal constant ROLE_SNAPSHOT_CREATOR = 0x08c1785afc57f933523bc52583a72ce9e19b2241354e04dd86f41f887e3d8174;
164 
165     // May enable/disable transfers on Neumark
166     bytes32 internal constant ROLE_TRANSFER_ADMIN = 0xb6527e944caca3d151b1f94e49ac5e223142694860743e66164720e034ec9b19;
167 
168     // may reclaim tokens/ether from contracts supporting IReclaimable interface
169     bytes32 internal constant ROLE_RECLAIMER = 0x0542bbd0c672578966dcc525b30aa16723bb042675554ac5b0362f86b6e97dc5;
170 
171     // represents legally platform operator in case of forks and contracts with legal agreement attached. keccak256("PlatformOperatorRepresentative")
172     bytes32 internal constant ROLE_PLATFORM_OPERATOR_REPRESENTATIVE = 0xb2b321377653f655206f71514ff9f150d0822d062a5abcf220d549e1da7999f0;
173 
174     // allows to deposit EUR-T and allow addresses to send and receive EUR-T. keccak256("EurtDepositManager")
175     bytes32 internal constant ROLE_EURT_DEPOSIT_MANAGER = 0x7c8ecdcba80ce87848d16ad77ef57cc196c208fc95c5638e4a48c681a34d4fe7;
176 }
177 
178 contract IEthereumForkArbiter {
179 
180     ////////////////////////
181     // Events
182     ////////////////////////
183 
184     event LogForkAnnounced(
185         string name,
186         string url,
187         uint256 blockNumber
188     );
189 
190     event LogForkSigned(
191         uint256 blockNumber,
192         bytes32 blockHash
193     );
194 
195     ////////////////////////
196     // Public functions
197     ////////////////////////
198 
199     function nextForkName()
200         public
201         constant
202         returns (string);
203 
204     function nextForkUrl()
205         public
206         constant
207         returns (string);
208 
209     function nextForkBlockNumber()
210         public
211         constant
212         returns (uint256);
213 
214     function lastSignedBlockNumber()
215         public
216         constant
217         returns (uint256);
218 
219     function lastSignedBlockHash()
220         public
221         constant
222         returns (bytes32);
223 
224     function lastSignedTimestamp()
225         public
226         constant
227         returns (uint256);
228 
229 }
230 
231 /**
232  * @title legally binding smart contract
233  * @dev General approach to paring legal and smart contracts:
234  * 1. All terms and agreement are between two parties: here between legal representation of platform operator representative and platform investor.
235  * 2. Parties are represented by public Ethereum addresses. Platform investor is and address that holds and controls funds and receives and controls Neumark token
236  * 3. Legal agreement has immutable part that corresponds to smart contract code and mutable part that may change for example due to changing regulations or other externalities that smart contract does not control.
237  * 4. There should be a provision in legal document that future changes in mutable part cannot change terms of immutable part.
238  * 5. Immutable part links to corresponding smart contract via its address.
239  * 6. Additional provision should be added if smart contract supports it
240  *  a. Fork provision
241  *  b. Bugfixing provision (unilateral code update mechanism)
242  *  c. Migration provision (bilateral code update mechanism)
243  *
244  * Details on Agreement base class:
245  * 1. We bind smart contract to legal contract by storing uri (preferably ipfs or hash) of the legal contract in the smart contract. It is however crucial that such binding is done by platform operator representation so transaction establishing the link must be signed by respective wallet ('amendAgreement')
246  * 2. Mutable part of agreement may change. We should be able to amend the uri later. Previous amendments should not be lost and should be retrievable (`amendAgreement` and 'pastAgreement' functions).
247  * 3. It is up to deriving contract to decide where to put 'acceptAgreement' modifier. However situation where there is no cryptographic proof that given address was really acting in the transaction should be avoided, simplest example being 'to' address in `transfer` function of ERC20.
248  *
249 **/
250 contract Agreement is
251     AccessControlled,
252     AccessRoles
253 {
254 
255     ////////////////////////
256     // Type declarations
257     ////////////////////////
258 
259     /// @notice agreement with signature of the platform operator representative
260     struct SignedAgreement {
261         address platformOperatorRepresentative;
262         uint256 signedBlockTimestamp;
263         string agreementUri;
264     }
265 
266     ////////////////////////
267     // Immutable state
268     ////////////////////////
269 
270     IEthereumForkArbiter private ETHEREUM_FORK_ARBITER;
271 
272     ////////////////////////
273     // Mutable state
274     ////////////////////////
275 
276     // stores all amendments to the agreement, first amendment is the original
277     SignedAgreement[] private _amendments;
278 
279     // stores block numbers of all addresses that signed the agreement (signatory => block number)
280     mapping(address => uint256) private _signatories;
281 
282     ////////////////////////
283     // Events
284     ////////////////////////
285 
286     event LogAgreementAccepted(
287         address indexed accepter
288     );
289 
290     event LogAgreementAmended(
291         address platformOperatorRepresentative,
292         string agreementUri
293     );
294 
295     ////////////////////////
296     // Modifiers
297     ////////////////////////
298 
299     /// @notice logs that agreement was accepted by platform user
300     /// @dev intended to be added to functions that if used make 'accepter' origin to enter legally binding agreement
301     modifier acceptAgreement(address accepter) {
302         if(_signatories[accepter] == 0) {
303             require(_amendments.length > 0);
304             _signatories[accepter] = block.number;
305             LogAgreementAccepted(accepter);
306         }
307         _;
308     }
309 
310     ////////////////////////
311     // Constructor
312     ////////////////////////
313 
314     function Agreement(IAccessPolicy accessPolicy, IEthereumForkArbiter forkArbiter)
315         AccessControlled(accessPolicy)
316         internal
317     {
318         require(forkArbiter != IEthereumForkArbiter(0x0));
319         ETHEREUM_FORK_ARBITER = forkArbiter;
320     }
321 
322     ////////////////////////
323     // Public functions
324     ////////////////////////
325 
326     function amendAgreement(string agreementUri)
327         public
328         only(ROLE_PLATFORM_OPERATOR_REPRESENTATIVE)
329     {
330         SignedAgreement memory amendment = SignedAgreement({
331             platformOperatorRepresentative: msg.sender,
332             signedBlockTimestamp: block.timestamp,
333             agreementUri: agreementUri
334         });
335         _amendments.push(amendment);
336         LogAgreementAmended(msg.sender, agreementUri);
337     }
338 
339     function ethereumForkArbiter()
340         public
341         constant
342         returns (IEthereumForkArbiter)
343     {
344         return ETHEREUM_FORK_ARBITER;
345     }
346 
347     function currentAgreement()
348         public
349         constant
350         returns
351         (
352             address platformOperatorRepresentative,
353             uint256 signedBlockTimestamp,
354             string agreementUri,
355             uint256 index
356         )
357     {
358         require(_amendments.length > 0);
359         uint256 last = _amendments.length - 1;
360         SignedAgreement storage amendment = _amendments[last];
361         return (
362             amendment.platformOperatorRepresentative,
363             amendment.signedBlockTimestamp,
364             amendment.agreementUri,
365             last
366         );
367     }
368 
369     function pastAgreement(uint256 amendmentIndex)
370         public
371         constant
372         returns
373         (
374             address platformOperatorRepresentative,
375             uint256 signedBlockTimestamp,
376             string agreementUri,
377             uint256 index
378         )
379     {
380         SignedAgreement storage amendment = _amendments[amendmentIndex];
381         return (
382             amendment.platformOperatorRepresentative,
383             amendment.signedBlockTimestamp,
384             amendment.agreementUri,
385             amendmentIndex
386         );
387     }
388 
389     function agreementSignedAtBlock(address signatory)
390         public
391         constant
392         returns (uint256)
393     {
394         return _signatories[signatory];
395     }
396 }
397 
398 contract NeumarkIssuanceCurve {
399 
400     ////////////////////////
401     // Constants
402     ////////////////////////
403 
404     // maximum number of neumarks that may be created
405     uint256 private constant NEUMARK_CAP = 1500000000000000000000000000;
406 
407     // initial neumark reward fraction (controls curve steepness)
408     uint256 private constant INITIAL_REWARD_FRACTION = 6500000000000000000;
409 
410     // stop issuing new Neumarks above this Euro value (as it goes quickly to zero)
411     uint256 private constant ISSUANCE_LIMIT_EUR_ULPS = 8300000000000000000000000000;
412 
413     // approximate curve linearly above this Euro value
414     uint256 private constant LINEAR_APPROX_LIMIT_EUR_ULPS = 2100000000000000000000000000;
415     uint256 private constant NEUMARKS_AT_LINEAR_LIMIT_ULPS = 1499832501287264827896539871;
416 
417     uint256 private constant TOT_LINEAR_NEUMARKS_ULPS = NEUMARK_CAP - NEUMARKS_AT_LINEAR_LIMIT_ULPS;
418     uint256 private constant TOT_LINEAR_EUR_ULPS = ISSUANCE_LIMIT_EUR_ULPS - LINEAR_APPROX_LIMIT_EUR_ULPS;
419 
420     ////////////////////////
421     // Public functions
422     ////////////////////////
423 
424     /// @notice returns additional amount of neumarks issued for euroUlps at totalEuroUlps
425     /// @param totalEuroUlps actual curve position from which neumarks will be issued
426     /// @param euroUlps amount against which neumarks will be issued
427     function incremental(uint256 totalEuroUlps, uint256 euroUlps)
428         public
429         constant
430         returns (uint256 neumarkUlps)
431     {
432         require(totalEuroUlps + euroUlps >= totalEuroUlps);
433         uint256 from = cumulative(totalEuroUlps);
434         uint256 to = cumulative(totalEuroUlps + euroUlps);
435         // as expansion is not monotonic for large totalEuroUlps, assert below may fail
436         // example: totalEuroUlps=1.999999999999999999999000000e+27 and euroUlps=50
437         assert(to >= from);
438         return to - from;
439     }
440 
441     /// @notice returns amount of euro corresponding to burned neumarks
442     /// @param totalEuroUlps actual curve position from which neumarks will be burned
443     /// @param burnNeumarkUlps amount of neumarks to burn
444     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps)
445         public
446         constant
447         returns (uint256 euroUlps)
448     {
449         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
450         require(totalNeumarkUlps >= burnNeumarkUlps);
451         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
452         uint newTotalEuroUlps = cumulativeInverse(fromNmk, 0, totalEuroUlps);
453         // yes, this may overflow due to non monotonic inverse function
454         assert(totalEuroUlps >= newTotalEuroUlps);
455         return totalEuroUlps - newTotalEuroUlps;
456     }
457 
458     /// @notice returns amount of euro corresponding to burned neumarks
459     /// @param totalEuroUlps actual curve position from which neumarks will be burned
460     /// @param burnNeumarkUlps amount of neumarks to burn
461     /// @param minEurUlps euro amount to start inverse search from, inclusive
462     /// @param maxEurUlps euro amount to end inverse search to, inclusive
463     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
464         public
465         constant
466         returns (uint256 euroUlps)
467     {
468         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
469         require(totalNeumarkUlps >= burnNeumarkUlps);
470         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
471         uint newTotalEuroUlps = cumulativeInverse(fromNmk, minEurUlps, maxEurUlps);
472         // yes, this may overflow due to non monotonic inverse function
473         assert(totalEuroUlps >= newTotalEuroUlps);
474         return totalEuroUlps - newTotalEuroUlps;
475     }
476 
477     /// @notice finds total amount of neumarks issued for given amount of Euro
478     /// @dev binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
479     ///     function below is not monotonic
480     function cumulative(uint256 euroUlps)
481         public
482         constant
483         returns(uint256 neumarkUlps)
484     {
485         // Return the cap if euroUlps is above the limit.
486         if (euroUlps >= ISSUANCE_LIMIT_EUR_ULPS) {
487             return NEUMARK_CAP;
488         }
489         // use linear approximation above limit below
490         // binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
491         if (euroUlps >= LINEAR_APPROX_LIMIT_EUR_ULPS) {
492             // (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS) is small so expression does not overflow
493             return NEUMARKS_AT_LINEAR_LIMIT_ULPS + (TOT_LINEAR_NEUMARKS_ULPS * (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS)) / TOT_LINEAR_EUR_ULPS;
494         }
495 
496         // Approximate cap-cap·(1-1/D)^n using the Binomial expansion
497         // http://galileo.phys.virginia.edu/classes/152.mf1i.spring02/Exponential_Function.htm
498         // Function[imax, -CAP*Sum[(-IR*EUR/CAP)^i/Factorial[i], {i, imax}]]
499         // which may be simplified to
500         // Function[imax, -CAP*Sum[(EUR)^i/(Factorial[i]*(-d)^i), {i, 1, imax}]]
501         // where d = cap/initial_reward
502         uint256 d = 230769230769230769230769231; // NEUMARK_CAP / INITIAL_REWARD_FRACTION
503         uint256 term = NEUMARK_CAP;
504         uint256 sum = 0;
505         uint256 denom = d;
506         do assembly {
507             // We use assembler primarily to avoid the expensive
508             // divide-by-zero check solc inserts for the / operator.
509             term  := div(mul(term, euroUlps), denom)
510             sum   := add(sum, term)
511             denom := add(denom, d)
512             // sub next term as we have power of negative value in the binomial expansion
513             term  := div(mul(term, euroUlps), denom)
514             sum   := sub(sum, term)
515             denom := add(denom, d)
516         } while (term != 0);
517         return sum;
518     }
519 
520     /// @notice find issuance curve inverse by binary search
521     /// @param neumarkUlps neumark amount to compute inverse for
522     /// @param minEurUlps minimum search range for the inverse, inclusive
523     /// @param maxEurUlps maxium search range for the inverse, inclusive
524     /// @dev in case of approximate search (no exact inverse) upper element of minimal search range is returned
525     /// @dev in case of many possible inverses, the lowest one will be used (if range permits)
526     /// @dev corresponds to a linear search that returns first euroUlp value that has cumulative() equal or greater than neumarkUlps
527     function cumulativeInverse(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
528         public
529         constant
530         returns (uint256 euroUlps)
531     {
532         require(maxEurUlps >= minEurUlps);
533         require(cumulative(minEurUlps) <= neumarkUlps);
534         require(cumulative(maxEurUlps) >= neumarkUlps);
535         uint256 min = minEurUlps;
536         uint256 max = maxEurUlps;
537 
538         // Binary search
539         while (max > min) {
540             uint256 mid = (max + min) / 2;
541             uint256 val = cumulative(mid);
542             // exact solution should not be used, a late points of the curve when many euroUlps are needed to
543             // increase by one nmkUlp this will lead to  "indeterministic" inverse values that depend on the initial min and max
544             // and further binary division -> you can land at any of the euro value that is mapped to the same nmk value
545             // with condition below removed, binary search will point to the lowest eur value possible which is good because it cannot be exploited even with 0 gas costs
546             /* if (val == neumarkUlps) {
547                 return mid;
548             }*/
549             // NOTE: approximate search (no inverse) must return upper element of the final range
550             //  last step of approximate search is always (min, min+1) so new mid is (2*min+1)/2 => min
551             //  so new min = mid + 1 = max which was upper range. and that ends the search
552             // NOTE: when there are multiple inverses for the same neumarkUlps, the `max` will be dragged down
553             //  by `max = mid` expression to the lowest eur value of inverse. works only for ranges that cover all points of multiple inverse
554             if (val < neumarkUlps) {
555                 min = mid + 1;
556             } else {
557                 max = mid;
558             }
559         }
560         // NOTE: It is possible that there is no inverse
561         //  for example curve(0) = 0 and curve(1) = 6, so
562         //  there is no value y such that curve(y) = 5.
563         //  When there is no inverse, we must return upper element of last search range.
564         //  This has the effect of reversing the curve less when
565         //  burning Neumarks. This ensures that Neumarks can always
566         //  be burned. It also ensure that the total supply of Neumarks
567         //  remains below the cap.
568         return max;
569     }
570 
571     function neumarkCap()
572         public
573         constant
574         returns (uint256)
575     {
576         return NEUMARK_CAP;
577     }
578 
579     function initialRewardFraction()
580         public
581         constant
582         returns (uint256)
583     {
584         return INITIAL_REWARD_FRACTION;
585     }
586 }
587 
588 contract IBasicToken {
589 
590     ////////////////////////
591     // Events
592     ////////////////////////
593 
594     event Transfer(
595         address indexed from,
596         address indexed to,
597         uint256 amount);
598 
599     ////////////////////////
600     // Public functions
601     ////////////////////////
602 
603     /// @dev This function makes it easy to get the total number of tokens
604     /// @return The total number of tokens
605     function totalSupply()
606         public
607         constant
608         returns (uint256);
609 
610     /// @param owner The address that's balance is being requested
611     /// @return The balance of `owner` at the current block
612     function balanceOf(address owner)
613         public
614         constant
615         returns (uint256 balance);
616 
617     /// @notice Send `amount` tokens to `to` from `msg.sender`
618     /// @param to The address of the recipient
619     /// @param amount The amount of tokens to be transferred
620     /// @return Whether the transfer was successful or not
621     function transfer(address to, uint256 amount)
622         public
623         returns (bool success);
624 
625 }
626 
627 /// @title allows deriving contract to recover any token or ether that it has balance of
628 /// @notice note that this opens your contracts to claims from various people saying they lost tokens and they want them back
629 ///     be ready to handle such claims
630 /// @dev use with care!
631 ///     1. ROLE_RECLAIMER is allowed to claim tokens, it's not returning tokens to original owner
632 ///     2. in derived contract that holds any token by design you must override `reclaim` and block such possibility.
633 ///         see LockedAccount as an example
634 contract Reclaimable is AccessControlled, AccessRoles {
635 
636     ////////////////////////
637     // Constants
638     ////////////////////////
639 
640     IBasicToken constant internal RECLAIM_ETHER = IBasicToken(0x0);
641 
642     ////////////////////////
643     // Public functions
644     ////////////////////////
645 
646     function reclaim(IBasicToken token)
647         public
648         only(ROLE_RECLAIMER)
649     {
650         address reclaimer = msg.sender;
651         if(token == RECLAIM_ETHER) {
652             reclaimer.transfer(this.balance);
653         } else {
654             uint256 balance = token.balanceOf(this);
655             require(token.transfer(reclaimer, balance));
656         }
657     }
658 }
659 
660 /// @title advances snapshot id on demand
661 /// @dev see Snapshot folder for implementation examples ie. DailyAndSnapshotable contract
662 contract ISnapshotable {
663 
664     ////////////////////////
665     // Events
666     ////////////////////////
667 
668     /// @dev should log each new snapshot id created, including snapshots created automatically via MSnapshotPolicy
669     event LogSnapshotCreated(uint256 snapshotId);
670 
671     ////////////////////////
672     // Public functions
673     ////////////////////////
674 
675     /// always creates new snapshot id which gets returned
676     /// however, there is no guarantee that any snapshot will be created with this id, this depends on the implementation of MSnaphotPolicy
677     function createSnapshot()
678         public
679         returns (uint256);
680 
681     /// upper bound of series snapshotIds for which there's a value
682     function currentSnapshotId()
683         public
684         constant
685         returns (uint256);
686 }
687 
688 /// @title Abstracts snapshot id creation logics
689 /// @dev Mixin (internal interface) of the snapshot policy which abstracts snapshot id creation logics from Snapshot contract
690 /// @dev to be implemented and such implementation should be mixed with Snapshot-derived contract, see EveryBlock for simplest example of implementation and StandardSnapshotToken
691 contract MSnapshotPolicy {
692 
693     ////////////////////////
694     // Internal functions
695     ////////////////////////
696 
697     // The snapshot Ids need to be strictly increasing.
698     // Whenever the snaspshot id changes, a new snapshot will be created.
699     // As long as the same snapshot id is being returned, last snapshot will be updated as this indicates that snapshot id didn't change
700     //
701     // Values passed to `hasValueAt` and `valuteAt` are required
702     // to be less or equal to `mCurrentSnapshotId()`.
703     function mCurrentSnapshotId()
704         internal
705         returns (uint256);
706 }
707 
708 /// @title creates snapshot id on each day boundary and allows to create additional snapshots within a given day
709 /// @dev snapshots are encoded in single uint256, where high 128 bits represents a day number (from unix epoch) and low 128 bits represents additional snapshots within given day create via ISnapshotable
710 contract DailyAndSnapshotable is
711     MSnapshotPolicy,
712     ISnapshotable
713 {
714     ////////////////////////
715     // Constants
716     ////////////////////////
717 
718     // Floor[2**128 / 1 days]
719     uint256 private MAX_TIMESTAMP = 3938453320844195178974243141571391;
720 
721     ////////////////////////
722     // Mutable state
723     ////////////////////////
724 
725     uint256 private _currentSnapshotId;
726 
727     ////////////////////////
728     // Constructor
729     ////////////////////////
730 
731     /// @param start snapshotId from which to start generating values
732     /// @dev start must be for the same day or 0, required for token cloning
733     function DailyAndSnapshotable(uint256 start) internal {
734         // 0 is invalid value as we are past unix epoch
735         if (start > 0) {
736             uint256 dayBase = snapshotAt(block.timestamp);
737             require(start >= dayBase);
738             // dayBase + 2**128 will not overflow as it is based on block.timestamp
739             require(start < dayBase + 2**128);
740             _currentSnapshotId = start;
741         }
742     }
743 
744     ////////////////////////
745     // Public functions
746     ////////////////////////
747 
748     function snapshotAt(uint256 timestamp)
749         public
750         constant
751         returns (uint256)
752     {
753         require(timestamp < MAX_TIMESTAMP);
754 
755         uint256 dayBase = 2**128 * (timestamp / 1 days);
756         return dayBase;
757     }
758 
759     //
760     // Implements ISnapshotable
761     //
762 
763     function createSnapshot()
764         public
765         returns (uint256)
766     {
767         uint256 dayBase = 2**128 * (block.timestamp / 1 days);
768 
769         if (dayBase > _currentSnapshotId) {
770             // New day has started, create snapshot for midnight
771             _currentSnapshotId = dayBase;
772         } else {
773             // within single day, increase counter (assume 2**128 will not be crossed)
774             _currentSnapshotId += 1;
775         }
776 
777         // Log and return
778         LogSnapshotCreated(_currentSnapshotId);
779         return _currentSnapshotId;
780     }
781 
782     function currentSnapshotId()
783         public
784         constant
785         returns (uint256)
786     {
787         return mCurrentSnapshotId();
788     }
789 
790     ////////////////////////
791     // Internal functions
792     ////////////////////////
793 
794     //
795     // Implements MSnapshotPolicy
796     //
797 
798     function mCurrentSnapshotId()
799         internal
800         returns (uint256)
801     {
802         uint256 dayBase = 2**128 * (block.timestamp / 1 days);
803 
804         // New day has started
805         if (dayBase > _currentSnapshotId) {
806             _currentSnapshotId = dayBase;
807             LogSnapshotCreated(dayBase);
808         }
809 
810         return _currentSnapshotId;
811     }
812 }
813 
814 contract ITokenMetadata {
815 
816     ////////////////////////
817     // Public functions
818     ////////////////////////
819 
820     function symbol()
821         public
822         constant
823         returns (string);
824 
825     function name()
826         public
827         constant
828         returns (string);
829 
830     function decimals()
831         public
832         constant
833         returns (uint8);
834 }
835 
836 /// @title adds token metadata to token contract
837 /// @dev see Neumark for example implementation
838 contract TokenMetadata is ITokenMetadata {
839 
840     ////////////////////////
841     // Immutable state
842     ////////////////////////
843 
844     // The Token's name: e.g. DigixDAO Tokens
845     string private NAME;
846 
847     // An identifier: e.g. REP
848     string private SYMBOL;
849 
850     // Number of decimals of the smallest unit
851     uint8 private DECIMALS;
852 
853     // An arbitrary versioning scheme
854     string private VERSION;
855 
856     ////////////////////////
857     // Constructor
858     ////////////////////////
859 
860     /// @notice Constructor to set metadata
861     /// @param tokenName Name of the new token
862     /// @param decimalUnits Number of decimals of the new token
863     /// @param tokenSymbol Token Symbol for the new token
864     /// @param version Token version ie. when cloning is used
865     function TokenMetadata(
866         string tokenName,
867         uint8 decimalUnits,
868         string tokenSymbol,
869         string version
870     )
871         public
872     {
873         NAME = tokenName;                                 // Set the name
874         SYMBOL = tokenSymbol;                             // Set the symbol
875         DECIMALS = decimalUnits;                          // Set the decimals
876         VERSION = version;
877     }
878 
879     ////////////////////////
880     // Public functions
881     ////////////////////////
882 
883     function name()
884         public
885         constant
886         returns (string)
887     {
888         return NAME;
889     }
890 
891     function symbol()
892         public
893         constant
894         returns (string)
895     {
896         return SYMBOL;
897     }
898 
899     function decimals()
900         public
901         constant
902         returns (uint8)
903     {
904         return DECIMALS;
905     }
906 
907     function version()
908         public
909         constant
910         returns (string)
911     {
912         return VERSION;
913     }
914 }
915 
916 contract IsContract {
917 
918     ////////////////////////
919     // Internal functions
920     ////////////////////////
921 
922     function isContract(address addr)
923         internal
924         constant
925         returns (bool)
926     {
927         uint256 size;
928         // takes 700 gas
929         assembly { size := extcodesize(addr) }
930         return size > 0;
931     }
932 }
933 
934 contract IERC20Allowance {
935 
936     ////////////////////////
937     // Events
938     ////////////////////////
939 
940     event Approval(
941         address indexed owner,
942         address indexed spender,
943         uint256 amount);
944 
945     ////////////////////////
946     // Public functions
947     ////////////////////////
948 
949     /// @dev This function makes it easy to read the `allowed[]` map
950     /// @param owner The address of the account that owns the token
951     /// @param spender The address of the account able to transfer the tokens
952     /// @return Amount of remaining tokens of owner that spender is allowed
953     ///  to spend
954     function allowance(address owner, address spender)
955         public
956         constant
957         returns (uint256 remaining);
958 
959     /// @notice `msg.sender` approves `spender` to spend `amount` tokens on
960     ///  its behalf. This is a modified version of the ERC20 approve function
961     ///  to be a little bit safer
962     /// @param spender The address of the account able to transfer the tokens
963     /// @param amount The amount of tokens to be approved for transfer
964     /// @return True if the approval was successful
965     function approve(address spender, uint256 amount)
966         public
967         returns (bool success);
968 
969     /// @notice Send `amount` tokens to `to` from `from` on the condition it
970     ///  is approved by `from`
971     /// @param from The address holding the tokens being transferred
972     /// @param to The address of the recipient
973     /// @param amount The amount of tokens to be transferred
974     /// @return True if the transfer was successful
975     function transferFrom(address from, address to, uint256 amount)
976         public
977         returns (bool success);
978 
979 }
980 
981 contract IERC20Token is IBasicToken, IERC20Allowance {
982 
983 }
984 
985 contract IERC223Callback {
986 
987     ////////////////////////
988     // Public functions
989     ////////////////////////
990 
991     function onTokenTransfer(
992         address from,
993         uint256 amount,
994         bytes data
995     )
996         public;
997 
998 }
999 
1000 contract IERC223Token is IBasicToken {
1001 
1002     /// @dev Departure: We do not log data, it has no advantage over a standard
1003     ///     log event. By sticking to the standard log event we
1004     ///     stay compatible with constracts that expect and ERC20 token.
1005 
1006     // event Transfer(
1007     //    address indexed from,
1008     //    address indexed to,
1009     //    uint256 amount,
1010     //    bytes data);
1011 
1012 
1013     /// @dev Departure: We do not use the callback on regular transfer calls to
1014     ///     stay compatible with constracts that expect and ERC20 token.
1015 
1016     // function transfer(address to, uint256 amount)
1017     //     public
1018     //     returns (bool);
1019 
1020     ////////////////////////
1021     // Public functions
1022     ////////////////////////
1023 
1024     function transfer(address to, uint256 amount, bytes data)
1025         public
1026         returns (bool);
1027 }
1028 
1029 /// @title controls spending approvals
1030 /// @dev TokenAllowance observes this interface, Neumark contract implements it
1031 contract MTokenAllowanceController {
1032 
1033     ////////////////////////
1034     // Internal functions
1035     ////////////////////////
1036 
1037     /// @notice Notifies the controller about an approval allowing the
1038     ///  controller to react if desired
1039     /// @param owner The address that calls `approve()`
1040     /// @param spender The spender in the `approve()` call
1041     /// @param amount The amount in the `approve()` call
1042     /// @return False if the controller does not authorize the approval
1043     function mOnApprove(
1044         address owner,
1045         address spender,
1046         uint256 amount
1047     )
1048         internal
1049         returns (bool allow);
1050 
1051 }
1052 
1053 /// @title controls token transfers
1054 /// @dev BasicSnapshotToken observes this interface, Neumark contract implements it
1055 contract MTokenTransferController {
1056 
1057     ////////////////////////
1058     // Internal functions
1059     ////////////////////////
1060 
1061     /// @notice Notifies the controller about a token transfer allowing the
1062     ///  controller to react if desired
1063     /// @param from The origin of the transfer
1064     /// @param to The destination of the transfer
1065     /// @param amount The amount of the transfer
1066     /// @return False if the controller does not authorize the transfer
1067     function mOnTransfer(
1068         address from,
1069         address to,
1070         uint256 amount
1071     )
1072         internal
1073         returns (bool allow);
1074 
1075 }
1076 
1077 /// @title controls approvals and transfers
1078 /// @dev The token controller contract must implement these functions, see Neumark as example
1079 /// @dev please note that controller may be a separate contract that is called from mOnTransfer and mOnApprove functions
1080 contract MTokenController is MTokenTransferController, MTokenAllowanceController {
1081 }
1082 
1083 /// @title internal token transfer function
1084 /// @dev see BasicSnapshotToken for implementation
1085 contract MTokenTransfer {
1086 
1087     ////////////////////////
1088     // Internal functions
1089     ////////////////////////
1090 
1091     /// @dev This is the actual transfer function in the token contract, it can
1092     ///  only be called by other functions in this contract.
1093     /// @param from The address holding the tokens being transferred
1094     /// @param to The address of the recipient
1095     /// @param amount The amount of tokens to be transferred
1096     /// @dev  reverts if transfer was not successful
1097     function mTransfer(
1098         address from,
1099         address to,
1100         uint256 amount
1101     )
1102         internal;
1103 }
1104 
1105 contract IERC677Callback {
1106 
1107     ////////////////////////
1108     // Public functions
1109     ////////////////////////
1110 
1111     // NOTE: This call can be initiated by anyone. You need to make sure that
1112     // it is send by the token (`require(msg.sender == token)`) or make sure
1113     // amount is valid (`require(token.allowance(this) >= amount)`).
1114     function receiveApproval(
1115         address from,
1116         uint256 amount,
1117         address token, // IERC667Token
1118         bytes data
1119     )
1120         public
1121         returns (bool success);
1122 
1123 }
1124 
1125 contract IERC677Allowance is IERC20Allowance {
1126 
1127     ////////////////////////
1128     // Public functions
1129     ////////////////////////
1130 
1131     /// @notice `msg.sender` approves `spender` to send `amount` tokens on
1132     ///  its behalf, and then a function is triggered in the contract that is
1133     ///  being approved, `spender`. This allows users to use their tokens to
1134     ///  interact with contracts in one function call instead of two
1135     /// @param spender The address of the contract able to transfer the tokens
1136     /// @param amount The amount of tokens to be approved for transfer
1137     /// @return True if the function call was successful
1138     function approveAndCall(address spender, uint256 amount, bytes extraData)
1139         public
1140         returns (bool success);
1141 
1142 }
1143 
1144 contract IERC677Token is IERC20Token, IERC677Allowance {
1145 }
1146 
1147 /// @title token spending approval and transfer
1148 /// @dev implements token approval and transfers and exposes relevant part of ERC20 and ERC677 approveAndCall
1149 ///     may be mixed in with any basic token (implementing mTransfer) like BasicSnapshotToken or MintableSnapshotToken to add approval mechanism
1150 ///     observes MTokenAllowanceController interface
1151 ///     observes MTokenTransfer
1152 contract TokenAllowance is
1153     MTokenTransfer,
1154     MTokenAllowanceController,
1155     IERC20Allowance,
1156     IERC677Token
1157 {
1158 
1159     ////////////////////////
1160     // Mutable state
1161     ////////////////////////
1162 
1163     // `allowed` tracks rights to spends others tokens as per ERC20
1164     mapping (address => mapping (address => uint256)) private _allowed;
1165 
1166     ////////////////////////
1167     // Constructor
1168     ////////////////////////
1169 
1170     function TokenAllowance()
1171         internal
1172     {
1173     }
1174 
1175     ////////////////////////
1176     // Public functions
1177     ////////////////////////
1178 
1179     //
1180     // Implements IERC20Token
1181     //
1182 
1183     /// @dev This function makes it easy to read the `allowed[]` map
1184     /// @param owner The address of the account that owns the token
1185     /// @param spender The address of the account able to transfer the tokens
1186     /// @return Amount of remaining tokens of _owner that _spender is allowed
1187     ///  to spend
1188     function allowance(address owner, address spender)
1189         public
1190         constant
1191         returns (uint256 remaining)
1192     {
1193         return _allowed[owner][spender];
1194     }
1195 
1196     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
1197     ///  its behalf. This is a modified version of the ERC20 approve function
1198     ///  where allowance per spender must be 0 to allow change of such allowance
1199     /// @param spender The address of the account able to transfer the tokens
1200     /// @param amount The amount of tokens to be approved for transfer
1201     /// @return True or reverts, False is never returned
1202     function approve(address spender, uint256 amount)
1203         public
1204         returns (bool success)
1205     {
1206         // Alerts the token controller of the approve function call
1207         require(mOnApprove(msg.sender, spender, amount));
1208 
1209         // To change the approve amount you first have to reduce the addresses`
1210         //  allowance to zero by calling `approve(_spender,0)` if it is not
1211         //  already 0 to mitigate the race condition described here:
1212         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1213         require((amount == 0) || (_allowed[msg.sender][spender] == 0));
1214 
1215         _allowed[msg.sender][spender] = amount;
1216         Approval(msg.sender, spender, amount);
1217         return true;
1218     }
1219 
1220     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
1221     ///  is approved by `_from`
1222     /// @param from The address holding the tokens being transferred
1223     /// @param to The address of the recipient
1224     /// @param amount The amount of tokens to be transferred
1225     /// @return True if the transfer was successful, reverts in any other case
1226     function transferFrom(address from, address to, uint256 amount)
1227         public
1228         returns (bool success)
1229     {
1230         // The standard ERC 20 transferFrom functionality
1231         bool amountApproved = _allowed[from][msg.sender] >= amount;
1232         require(amountApproved);
1233 
1234         _allowed[from][msg.sender] -= amount;
1235         mTransfer(from, to, amount);
1236 
1237         return true;
1238     }
1239 
1240     //
1241     // Implements IERC677Token
1242     //
1243 
1244     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
1245     ///  its behalf, and then a function is triggered in the contract that is
1246     ///  being approved, `_spender`. This allows users to use their tokens to
1247     ///  interact with contracts in one function call instead of two
1248     /// @param spender The address of the contract able to transfer the tokens
1249     /// @param amount The amount of tokens to be approved for transfer
1250     /// @return True or reverts, False is never returned
1251     function approveAndCall(
1252         address spender,
1253         uint256 amount,
1254         bytes extraData
1255     )
1256         public
1257         returns (bool success)
1258     {
1259         require(approve(spender, amount));
1260 
1261         success = IERC677Callback(spender).receiveApproval(
1262             msg.sender,
1263             amount,
1264             this,
1265             extraData
1266         );
1267         require(success);
1268 
1269         return true;
1270     }
1271 }
1272 
1273 /// @title Reads and writes snapshots
1274 /// @dev Manages reading and writing a series of values, where each value has assigned a snapshot id for access to historical data
1275 /// @dev may be added to any contract to provide snapshotting mechanism. should be mixed in with any of MSnapshotPolicy implementations to customize snapshot creation mechanics
1276 ///     observes MSnapshotPolicy
1277 /// based on MiniMe token
1278 contract Snapshot is MSnapshotPolicy {
1279 
1280     ////////////////////////
1281     // Types
1282     ////////////////////////
1283 
1284     /// @dev `Values` is the structure that attaches a snapshot id to a
1285     ///  given value, the snapshot id attached is the one that last changed the
1286     ///  value
1287     struct Values {
1288 
1289         // `snapshotId` is the snapshot id that the value was generated at
1290         uint256 snapshotId;
1291 
1292         // `value` at a specific snapshot id
1293         uint256 value;
1294     }
1295 
1296     ////////////////////////
1297     // Internal functions
1298     ////////////////////////
1299 
1300     function hasValue(
1301         Values[] storage values
1302     )
1303         internal
1304         constant
1305         returns (bool)
1306     {
1307         return values.length > 0;
1308     }
1309 
1310     /// @dev makes sure that 'snapshotId' between current snapshot id (mCurrentSnapshotId) and first snapshot id. this guarantees that getValueAt returns value from one of the snapshots.
1311     function hasValueAt(
1312         Values[] storage values,
1313         uint256 snapshotId
1314     )
1315         internal
1316         constant
1317         returns (bool)
1318     {
1319         require(snapshotId <= mCurrentSnapshotId());
1320         return values.length > 0 && values[0].snapshotId <= snapshotId;
1321     }
1322 
1323     /// gets last value in the series
1324     function getValue(
1325         Values[] storage values,
1326         uint256 defaultValue
1327     )
1328         internal
1329         constant
1330         returns (uint256)
1331     {
1332         if (values.length == 0) {
1333             return defaultValue;
1334         } else {
1335             uint256 last = values.length - 1;
1336             return values[last].value;
1337         }
1338     }
1339 
1340     /// @dev `getValueAt` retrieves value at a given snapshot id
1341     /// @param values The series of values being queried
1342     /// @param snapshotId Snapshot id to retrieve the value at
1343     /// @return Value in series being queried
1344     function getValueAt(
1345         Values[] storage values,
1346         uint256 snapshotId,
1347         uint256 defaultValue
1348     )
1349         internal
1350         constant
1351         returns (uint256)
1352     {
1353         require(snapshotId <= mCurrentSnapshotId());
1354 
1355         // Empty value
1356         if (values.length == 0) {
1357             return defaultValue;
1358         }
1359 
1360         // Shortcut for the out of bounds snapshots
1361         uint256 last = values.length - 1;
1362         uint256 lastSnapshot = values[last].snapshotId;
1363         if (snapshotId >= lastSnapshot) {
1364             return values[last].value;
1365         }
1366         uint256 firstSnapshot = values[0].snapshotId;
1367         if (snapshotId < firstSnapshot) {
1368             return defaultValue;
1369         }
1370         // Binary search of the value in the array
1371         uint256 min = 0;
1372         uint256 max = last;
1373         while (max > min) {
1374             uint256 mid = (max + min + 1) / 2;
1375             // must always return lower indice for approximate searches
1376             if (values[mid].snapshotId <= snapshotId) {
1377                 min = mid;
1378             } else {
1379                 max = mid - 1;
1380             }
1381         }
1382         return values[min].value;
1383     }
1384 
1385     /// @dev `setValue` used to update sequence at next snapshot
1386     /// @param values The sequence being updated
1387     /// @param value The new last value of sequence
1388     function setValue(
1389         Values[] storage values,
1390         uint256 value
1391     )
1392         internal
1393     {
1394         // TODO: simplify or break into smaller functions
1395 
1396         uint256 currentSnapshotId = mCurrentSnapshotId();
1397         // Always create a new entry if there currently is no value
1398         bool empty = values.length == 0;
1399         if (empty) {
1400             // Create a new entry
1401             values.push(
1402                 Values({
1403                     snapshotId: currentSnapshotId,
1404                     value: value
1405                 })
1406             );
1407             return;
1408         }
1409 
1410         uint256 last = values.length - 1;
1411         bool hasNewSnapshot = values[last].snapshotId < currentSnapshotId;
1412         if (hasNewSnapshot) {
1413 
1414             // Do nothing if the value was not modified
1415             bool unmodified = values[last].value == value;
1416             if (unmodified) {
1417                 return;
1418             }
1419 
1420             // Create new entry
1421             values.push(
1422                 Values({
1423                     snapshotId: currentSnapshotId,
1424                     value: value
1425                 })
1426             );
1427         } else {
1428 
1429             // We are updating the currentSnapshotId
1430             bool previousUnmodified = last > 0 && values[last - 1].value == value;
1431             if (previousUnmodified) {
1432                 // Remove current snapshot if current value was set to previous value
1433                 delete values[last];
1434                 values.length--;
1435                 return;
1436             }
1437 
1438             // Overwrite next snapshot entry
1439             values[last].value = value;
1440         }
1441     }
1442 }
1443 
1444 /// @title access to snapshots of a token
1445 /// @notice allows to implement complex token holder rights like revenue disbursal or voting
1446 /// @notice snapshots are series of values with assigned ids. ids increase strictly. particular id mechanism is not assumed
1447 contract ITokenSnapshots {
1448 
1449     ////////////////////////
1450     // Public functions
1451     ////////////////////////
1452 
1453     /// @notice Total amount of tokens at a specific `snapshotId`.
1454     /// @param snapshotId of snapshot at which totalSupply is queried
1455     /// @return The total amount of tokens at `snapshotId`
1456     /// @dev reverts on snapshotIds greater than currentSnapshotId()
1457     /// @dev returns 0 for snapshotIds less than snapshotId of first value
1458     function totalSupplyAt(uint256 snapshotId)
1459         public
1460         constant
1461         returns(uint256);
1462 
1463     /// @dev Queries the balance of `owner` at a specific `snapshotId`
1464     /// @param owner The address from which the balance will be retrieved
1465     /// @param snapshotId of snapshot at which the balance is queried
1466     /// @return The balance at `snapshotId`
1467     function balanceOfAt(address owner, uint256 snapshotId)
1468         public
1469         constant
1470         returns (uint256);
1471 
1472     /// @notice upper bound of series of snapshotIds for which there's a value in series
1473     /// @return snapshotId
1474     function currentSnapshotId()
1475         public
1476         constant
1477         returns (uint256);
1478 }
1479 
1480 /// @title represents link between cloned and parent token
1481 /// @dev when token is clone from other token, initial balances of the cloned token
1482 ///     correspond to balances of parent token at the moment of parent snapshot id specified
1483 /// @notice please note that other tokens beside snapshot token may be cloned
1484 contract IClonedTokenParent is ITokenSnapshots {
1485 
1486     ////////////////////////
1487     // Public functions
1488     ////////////////////////
1489 
1490 
1491     /// @return address of parent token, address(0) if root
1492     /// @dev parent token does not need to clonable, nor snapshottable, just a normal token
1493     function parentToken()
1494         public
1495         constant
1496         returns(IClonedTokenParent parent);
1497 
1498     /// @return snapshot at wchich initial token distribution was taken
1499     function parentSnapshotId()
1500         public
1501         constant
1502         returns(uint256 snapshotId);
1503 }
1504 
1505 /// @title token with snapshots and transfer functionality
1506 /// @dev observes MTokenTransferController interface
1507 ///     observes ISnapshotToken interface
1508 ///     implementes MTokenTransfer interface
1509 contract BasicSnapshotToken is
1510     MTokenTransfer,
1511     MTokenTransferController,
1512     IBasicToken,
1513     IClonedTokenParent,
1514     Snapshot
1515 {
1516     ////////////////////////
1517     // Immutable state
1518     ////////////////////////
1519 
1520     // `PARENT_TOKEN` is the Token address that was cloned to produce this token;
1521     //  it will be 0x0 for a token that was not cloned
1522     IClonedTokenParent private PARENT_TOKEN;
1523 
1524     // `PARENT_SNAPSHOT_ID` is the snapshot id from the Parent Token that was
1525     //  used to determine the initial distribution of the cloned token
1526     uint256 private PARENT_SNAPSHOT_ID;
1527 
1528     ////////////////////////
1529     // Mutable state
1530     ////////////////////////
1531 
1532     // `balances` is the map that tracks the balance of each address, in this
1533     //  contract when the balance changes the snapshot id that the change
1534     //  occurred is also included in the map
1535     mapping (address => Values[]) internal _balances;
1536 
1537     // Tracks the history of the `totalSupply` of the token
1538     Values[] internal _totalSupplyValues;
1539 
1540     ////////////////////////
1541     // Constructor
1542     ////////////////////////
1543 
1544     /// @notice Constructor to create snapshot token
1545     /// @param parentToken Address of the parent token, set to 0x0 if it is a
1546     ///  new token
1547     /// @param parentSnapshotId at which snapshot id clone was created, set to 0 to clone at upper bound
1548     /// @dev please not that as long as cloned token does not overwrite value at current snapshot id, it will refer
1549     ///     to parent token at which this snapshot still may change until snapshot id increases. for that time tokens are coupled
1550     ///     this is prevented by parentSnapshotId value of parentToken.currentSnapshotId() - 1 being the maxiumum
1551     ///     see SnapshotToken.js test to learn consequences coupling has.
1552     function BasicSnapshotToken(
1553         IClonedTokenParent parentToken,
1554         uint256 parentSnapshotId
1555     )
1556         Snapshot()
1557         internal
1558     {
1559         PARENT_TOKEN = parentToken;
1560         if (parentToken == address(0)) {
1561             require(parentSnapshotId == 0);
1562         } else {
1563             if (parentSnapshotId == 0) {
1564                 require(parentToken.currentSnapshotId() > 0);
1565                 PARENT_SNAPSHOT_ID = parentToken.currentSnapshotId() - 1;
1566             } else {
1567                 PARENT_SNAPSHOT_ID = parentSnapshotId;
1568             }
1569         }
1570     }
1571 
1572     ////////////////////////
1573     // Public functions
1574     ////////////////////////
1575 
1576     //
1577     // Implements IBasicToken
1578     //
1579 
1580     /// @dev This function makes it easy to get the total number of tokens
1581     /// @return The total number of tokens
1582     function totalSupply()
1583         public
1584         constant
1585         returns (uint256)
1586     {
1587         return totalSupplyAtInternal(mCurrentSnapshotId());
1588     }
1589 
1590     /// @param owner The address that's balance is being requested
1591     /// @return The balance of `owner` at the current block
1592     function balanceOf(address owner)
1593         public
1594         constant
1595         returns (uint256 balance)
1596     {
1597         return balanceOfAtInternal(owner, mCurrentSnapshotId());
1598     }
1599 
1600     /// @notice Send `amount` tokens to `to` from `msg.sender`
1601     /// @param to The address of the recipient
1602     /// @param amount The amount of tokens to be transferred
1603     /// @return True if the transfer was successful, reverts in any other case
1604     function transfer(address to, uint256 amount)
1605         public
1606         returns (bool success)
1607     {
1608         mTransfer(msg.sender, to, amount);
1609         return true;
1610     }
1611 
1612     //
1613     // Implements ITokenSnapshots
1614     //
1615 
1616     function totalSupplyAt(uint256 snapshotId)
1617         public
1618         constant
1619         returns(uint256)
1620     {
1621         return totalSupplyAtInternal(snapshotId);
1622     }
1623 
1624     function balanceOfAt(address owner, uint256 snapshotId)
1625         public
1626         constant
1627         returns (uint256)
1628     {
1629         return balanceOfAtInternal(owner, snapshotId);
1630     }
1631 
1632     function currentSnapshotId()
1633         public
1634         constant
1635         returns (uint256)
1636     {
1637         return mCurrentSnapshotId();
1638     }
1639 
1640     //
1641     // Implements IClonedTokenParent
1642     //
1643 
1644     function parentToken()
1645         public
1646         constant
1647         returns(IClonedTokenParent parent)
1648     {
1649         return PARENT_TOKEN;
1650     }
1651 
1652     /// @return snapshot at wchich initial token distribution was taken
1653     function parentSnapshotId()
1654         public
1655         constant
1656         returns(uint256 snapshotId)
1657     {
1658         return PARENT_SNAPSHOT_ID;
1659     }
1660 
1661     //
1662     // Other public functions
1663     //
1664 
1665     /// @notice gets all token balances of 'owner'
1666     /// @dev intended to be called via eth_call where gas limit is not an issue
1667     function allBalancesOf(address owner)
1668         external
1669         constant
1670         returns (uint256[2][])
1671     {
1672         /* very nice and working implementation below,
1673         // copy to memory
1674         Values[] memory values = _balances[owner];
1675         do assembly {
1676             // in memory structs have simple layout where every item occupies uint256
1677             balances := values
1678         } while (false);*/
1679 
1680         Values[] storage values = _balances[owner];
1681         uint256[2][] memory balances = new uint256[2][](values.length);
1682         for(uint256 ii = 0; ii < values.length; ++ii) {
1683             balances[ii] = [values[ii].snapshotId, values[ii].value];
1684         }
1685 
1686         return balances;
1687     }
1688 
1689     ////////////////////////
1690     // Internal functions
1691     ////////////////////////
1692 
1693     function totalSupplyAtInternal(uint256 snapshotId)
1694         public
1695         constant
1696         returns(uint256)
1697     {
1698         Values[] storage values = _totalSupplyValues;
1699 
1700         // If there is a value, return it, reverts if value is in the future
1701         if (hasValueAt(values, snapshotId)) {
1702             return getValueAt(values, snapshotId, 0);
1703         }
1704 
1705         // Try parent contract at or before the fork
1706         if (address(PARENT_TOKEN) != 0) {
1707             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
1708             return PARENT_TOKEN.totalSupplyAt(earlierSnapshotId);
1709         }
1710 
1711         // Default to an empty balance
1712         return 0;
1713     }
1714 
1715     // get balance at snapshot if with continuation in parent token
1716     function balanceOfAtInternal(address owner, uint256 snapshotId)
1717         internal
1718         constant
1719         returns (uint256)
1720     {
1721         Values[] storage values = _balances[owner];
1722 
1723         // If there is a value, return it, reverts if value is in the future
1724         if (hasValueAt(values, snapshotId)) {
1725             return getValueAt(values, snapshotId, 0);
1726         }
1727 
1728         // Try parent contract at or before the fork
1729         if (PARENT_TOKEN != address(0)) {
1730             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
1731             return PARENT_TOKEN.balanceOfAt(owner, earlierSnapshotId);
1732         }
1733 
1734         // Default to an empty balance
1735         return 0;
1736     }
1737 
1738     //
1739     // Implements MTokenTransfer
1740     //
1741 
1742     /// @dev This is the actual transfer function in the token contract, it can
1743     ///  only be called by other functions in this contract.
1744     /// @param from The address holding the tokens being transferred
1745     /// @param to The address of the recipient
1746     /// @param amount The amount of tokens to be transferred
1747     /// @return True if the transfer was successful, reverts in any other case
1748     function mTransfer(
1749         address from,
1750         address to,
1751         uint256 amount
1752     )
1753         internal
1754     {
1755         // never send to address 0
1756         require(to != address(0));
1757         // block transfers in clone that points to future/current snapshots of patent token
1758         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
1759         // Alerts the token controller of the transfer
1760         require(mOnTransfer(from, to, amount));
1761 
1762         // If the amount being transfered is more than the balance of the
1763         //  account the transfer reverts
1764         var previousBalanceFrom = balanceOf(from);
1765         require(previousBalanceFrom >= amount);
1766 
1767         // First update the balance array with the new value for the address
1768         //  sending the tokens
1769         uint256 newBalanceFrom = previousBalanceFrom - amount;
1770         setValue(_balances[from], newBalanceFrom);
1771 
1772         // Then update the balance array with the new value for the address
1773         //  receiving the tokens
1774         uint256 previousBalanceTo = balanceOf(to);
1775         uint256 newBalanceTo = previousBalanceTo + amount;
1776         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
1777         setValue(_balances[to], newBalanceTo);
1778 
1779         // An event to make the transfer easy to find on the blockchain
1780         Transfer(from, to, amount);
1781     }
1782 }
1783 
1784 /// @title token generation and destruction
1785 /// @dev internal interface providing token generation and destruction, see MintableSnapshotToken for implementation
1786 contract MTokenMint {
1787 
1788     ////////////////////////
1789     // Internal functions
1790     ////////////////////////
1791 
1792     /// @notice Generates `amount` tokens that are assigned to `owner`
1793     /// @param owner The address that will be assigned the new tokens
1794     /// @param amount The quantity of tokens generated
1795     /// @dev reverts if tokens could not be generated
1796     function mGenerateTokens(address owner, uint256 amount)
1797         internal;
1798 
1799     /// @notice Burns `amount` tokens from `owner`
1800     /// @param owner The address that will lose the tokens
1801     /// @param amount The quantity of tokens to burn
1802     /// @dev reverts if tokens could not be destroyed
1803     function mDestroyTokens(address owner, uint256 amount)
1804         internal;
1805 }
1806 
1807 /// @title basic snapshot token with facitilites to generate and destroy tokens
1808 /// @dev implementes MTokenMint, does not expose any public functions that create/destroy tokens
1809 contract MintableSnapshotToken is
1810     BasicSnapshotToken,
1811     MTokenMint
1812 {
1813 
1814     ////////////////////////
1815     // Constructor
1816     ////////////////////////
1817 
1818     /// @notice Constructor to create a MintableSnapshotToken
1819     /// @param parentToken Address of the parent token, set to 0x0 if it is a
1820     ///  new token
1821     function MintableSnapshotToken(
1822         IClonedTokenParent parentToken,
1823         uint256 parentSnapshotId
1824     )
1825         BasicSnapshotToken(parentToken, parentSnapshotId)
1826         internal
1827     {}
1828 
1829     /// @notice Generates `amount` tokens that are assigned to `owner`
1830     /// @param owner The address that will be assigned the new tokens
1831     /// @param amount The quantity of tokens generated
1832     function mGenerateTokens(address owner, uint256 amount)
1833         internal
1834     {
1835         // never create for address 0
1836         require(owner != address(0));
1837         // block changes in clone that points to future/current snapshots of patent token
1838         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
1839 
1840         uint256 curTotalSupply = totalSupply();
1841         uint256 newTotalSupply = curTotalSupply + amount;
1842         require(newTotalSupply >= curTotalSupply); // Check for overflow
1843 
1844         uint256 previousBalanceTo = balanceOf(owner);
1845         uint256 newBalanceTo = previousBalanceTo + amount;
1846         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
1847 
1848         setValue(_totalSupplyValues, newTotalSupply);
1849         setValue(_balances[owner], newBalanceTo);
1850 
1851         Transfer(0, owner, amount);
1852     }
1853 
1854     /// @notice Burns `amount` tokens from `owner`
1855     /// @param owner The address that will lose the tokens
1856     /// @param amount The quantity of tokens to burn
1857     function mDestroyTokens(address owner, uint256 amount)
1858         internal
1859     {
1860         // block changes in clone that points to future/current snapshots of patent token
1861         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
1862 
1863         uint256 curTotalSupply = totalSupply();
1864         require(curTotalSupply >= amount);
1865 
1866         uint256 previousBalanceFrom = balanceOf(owner);
1867         require(previousBalanceFrom >= amount);
1868 
1869         uint256 newTotalSupply = curTotalSupply - amount;
1870         uint256 newBalanceFrom = previousBalanceFrom - amount;
1871         setValue(_totalSupplyValues, newTotalSupply);
1872         setValue(_balances[owner], newBalanceFrom);
1873 
1874         Transfer(owner, 0, amount);
1875     }
1876 }
1877 
1878 /*
1879     Copyright 2016, Jordi Baylina
1880     Copyright 2017, Remco Bloemen, Marcin Rudolf
1881 
1882     This program is free software: you can redistribute it and/or modify
1883     it under the terms of the GNU General Public License as published by
1884     the Free Software Foundation, either version 3 of the License, or
1885     (at your option) any later version.
1886 
1887     This program is distributed in the hope that it will be useful,
1888     but WITHOUT ANY WARRANTY; without even the implied warranty of
1889     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1890     GNU General Public License for more details.
1891 
1892     You should have received a copy of the GNU General Public License
1893     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1894  */
1895 /// @title StandardSnapshotToken Contract
1896 /// @author Jordi Baylina, Remco Bloemen, Marcin Rudolf
1897 /// @dev This token contract's goal is to make it easy for anyone to clone this
1898 ///  token using the token distribution at a given block, this will allow DAO's
1899 ///  and DApps to upgrade their features in a decentralized manner without
1900 ///  affecting the original token
1901 /// @dev It is ERC20 compliant, but still needs to under go further testing.
1902 /// @dev Various contracts are composed to provide required functionality of this token, different compositions are possible
1903 ///     MintableSnapshotToken provides transfer, miniting and snapshotting functions
1904 ///     TokenAllowance provides approve/transferFrom functions
1905 ///     TokenMetadata adds name, symbol and other token metadata
1906 /// @dev This token is still abstract, Snapshot, BasicSnapshotToken and TokenAllowance observe interfaces that must be implemented
1907 ///     MSnapshotPolicy - particular snapshot id creation mechanism
1908 ///     MTokenController - controlls approvals and transfers
1909 ///     see Neumark as an example
1910 /// @dev implements ERC223 token transfer
1911 contract StandardSnapshotToken is
1912     IERC20Token,
1913     MintableSnapshotToken,
1914     TokenAllowance,
1915     IERC223Token,
1916     IsContract
1917 {
1918     ////////////////////////
1919     // Constructor
1920     ////////////////////////
1921 
1922     /// @notice Constructor to create a MiniMeToken
1923     ///  is a new token
1924     /// param tokenName Name of the new token
1925     /// param decimalUnits Number of decimals of the new token
1926     /// param tokenSymbol Token Symbol for the new token
1927     function StandardSnapshotToken(
1928         IClonedTokenParent parentToken,
1929         uint256 parentSnapshotId
1930     )
1931         MintableSnapshotToken(parentToken, parentSnapshotId)
1932         TokenAllowance()
1933         internal
1934     {}
1935 
1936     ////////////////////////
1937     // Public functions
1938     ////////////////////////
1939 
1940     //
1941     // Implements IERC223Token
1942     //
1943 
1944     function transfer(address to, uint256 amount, bytes data)
1945         public
1946         returns (bool)
1947     {
1948         // it is necessary to point out implementation to be called
1949         BasicSnapshotToken.mTransfer(msg.sender, to, amount);
1950 
1951         // Notify the receiving contract.
1952         if (isContract(to)) {
1953             IERC223Callback(to).onTokenTransfer(msg.sender, amount, data);
1954         }
1955         return true;
1956     }
1957 }
1958 
1959 contract Neumark is
1960     AccessControlled,
1961     AccessRoles,
1962     Agreement,
1963     DailyAndSnapshotable,
1964     StandardSnapshotToken,
1965     TokenMetadata,
1966     NeumarkIssuanceCurve,
1967     Reclaimable
1968 {
1969 
1970     ////////////////////////
1971     // Constants
1972     ////////////////////////
1973 
1974     string private constant TOKEN_NAME = "Neumark";
1975 
1976     uint8  private constant TOKEN_DECIMALS = 18;
1977 
1978     string private constant TOKEN_SYMBOL = "NEU";
1979 
1980     string private constant VERSION = "NMK_1.0";
1981 
1982     ////////////////////////
1983     // Mutable state
1984     ////////////////////////
1985 
1986     // disable transfers when Neumark is created
1987     bool private _transferEnabled = false;
1988 
1989     // at which point on curve new Neumarks will be created, see NeumarkIssuanceCurve contract
1990     // do not use to get total invested funds. see burn(). this is just a cache for expensive inverse function
1991     uint256 private _totalEurUlps;
1992 
1993     ////////////////////////
1994     // Events
1995     ////////////////////////
1996 
1997     event LogNeumarksIssued(
1998         address indexed owner,
1999         uint256 euroUlps,
2000         uint256 neumarkUlps
2001     );
2002 
2003     event LogNeumarksBurned(
2004         address indexed owner,
2005         uint256 euroUlps,
2006         uint256 neumarkUlps
2007     );
2008 
2009     ////////////////////////
2010     // Constructor
2011     ////////////////////////
2012 
2013     function Neumark(
2014         IAccessPolicy accessPolicy,
2015         IEthereumForkArbiter forkArbiter
2016     )
2017         AccessControlled(accessPolicy)
2018         AccessRoles()
2019         Agreement(accessPolicy, forkArbiter)
2020         StandardSnapshotToken(
2021             IClonedTokenParent(0x0),
2022             0
2023         )
2024         TokenMetadata(
2025             TOKEN_NAME,
2026             TOKEN_DECIMALS,
2027             TOKEN_SYMBOL,
2028             VERSION
2029         )
2030         DailyAndSnapshotable(0)
2031         NeumarkIssuanceCurve()
2032         Reclaimable()
2033         public
2034     {}
2035 
2036     ////////////////////////
2037     // Public functions
2038     ////////////////////////
2039 
2040     /// @notice issues new Neumarks to msg.sender with reward at current curve position
2041     ///     moves curve position by euroUlps
2042     ///     callable only by ROLE_NEUMARK_ISSUER
2043     function issueForEuro(uint256 euroUlps)
2044         public
2045         only(ROLE_NEUMARK_ISSUER)
2046         acceptAgreement(msg.sender)
2047         returns (uint256)
2048     {
2049         require(_totalEurUlps + euroUlps >= _totalEurUlps);
2050         uint256 neumarkUlps = incremental(_totalEurUlps, euroUlps);
2051         _totalEurUlps += euroUlps;
2052         mGenerateTokens(msg.sender, neumarkUlps);
2053         LogNeumarksIssued(msg.sender, euroUlps, neumarkUlps);
2054         return neumarkUlps;
2055     }
2056 
2057     /// @notice used by ROLE_NEUMARK_ISSUER to transer newly issued neumarks
2058     ///     typically to the investor and platform operator
2059     function distribute(address to, uint256 neumarkUlps)
2060         public
2061         only(ROLE_NEUMARK_ISSUER)
2062         acceptAgreement(to)
2063     {
2064         mTransfer(msg.sender, to, neumarkUlps);
2065     }
2066 
2067     /// @notice msg.sender can burn their Neumarks, curve is rolled back using inverse
2068     ///     curve. as a result cost of Neumark gets lower (reward is higher)
2069     function burn(uint256 neumarkUlps)
2070         public
2071         only(ROLE_NEUMARK_BURNER)
2072     {
2073         burnPrivate(neumarkUlps, 0, _totalEurUlps);
2074     }
2075 
2076     /// @notice executes as function above but allows to provide search range for low gas burning
2077     function burn(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2078         public
2079         only(ROLE_NEUMARK_BURNER)
2080     {
2081         burnPrivate(neumarkUlps, minEurUlps, maxEurUlps);
2082     }
2083 
2084     function enableTransfer(bool enabled)
2085         public
2086         only(ROLE_TRANSFER_ADMIN)
2087     {
2088         _transferEnabled = enabled;
2089     }
2090 
2091     function createSnapshot()
2092         public
2093         only(ROLE_SNAPSHOT_CREATOR)
2094         returns (uint256)
2095     {
2096         return DailyAndSnapshotable.createSnapshot();
2097     }
2098 
2099     function transferEnabled()
2100         public
2101         constant
2102         returns (bool)
2103     {
2104         return _transferEnabled;
2105     }
2106 
2107     function totalEuroUlps()
2108         public
2109         constant
2110         returns (uint256)
2111     {
2112         return _totalEurUlps;
2113     }
2114 
2115     function incremental(uint256 euroUlps)
2116         public
2117         constant
2118         returns (uint256 neumarkUlps)
2119     {
2120         return incremental(_totalEurUlps, euroUlps);
2121     }
2122 
2123     ////////////////////////
2124     // Internal functions
2125     ////////////////////////
2126 
2127     //
2128     // Implements MTokenController
2129     //
2130 
2131     function mOnTransfer(
2132         address from,
2133         address, // to
2134         uint256 // amount
2135     )
2136         internal
2137         acceptAgreement(from)
2138         returns (bool allow)
2139     {
2140         // must have transfer enabled or msg.sender is Neumark issuer
2141         return _transferEnabled || accessPolicy().allowed(msg.sender, ROLE_NEUMARK_ISSUER, this, msg.sig);
2142     }
2143 
2144     function mOnApprove(
2145         address owner,
2146         address, // spender,
2147         uint256 // amount
2148     )
2149         internal
2150         acceptAgreement(owner)
2151         returns (bool allow)
2152     {
2153         return true;
2154     }
2155 
2156     ////////////////////////
2157     // Private functions
2158     ////////////////////////
2159 
2160     function burnPrivate(uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2161         private
2162     {
2163         uint256 prevEuroUlps = _totalEurUlps;
2164         // burn first in the token to make sure balance/totalSupply is not crossed
2165         mDestroyTokens(msg.sender, burnNeumarkUlps);
2166         _totalEurUlps = cumulativeInverse(totalSupply(), minEurUlps, maxEurUlps);
2167         // actually may overflow on non-monotonic inverse
2168         assert(prevEuroUlps >= _totalEurUlps);
2169         uint256 euroUlps = prevEuroUlps - _totalEurUlps;
2170         LogNeumarksBurned(msg.sender, euroUlps, burnNeumarkUlps);
2171     }
2172 }