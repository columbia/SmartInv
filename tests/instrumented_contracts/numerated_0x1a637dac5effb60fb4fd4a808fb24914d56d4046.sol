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
196 contract IEthereumForkArbiter {
197 
198     ////////////////////////
199     // Events
200     ////////////////////////
201 
202     event LogForkAnnounced(
203         string name,
204         string url,
205         uint256 blockNumber
206     );
207 
208     event LogForkSigned(
209         uint256 blockNumber,
210         bytes32 blockHash
211     );
212 
213     ////////////////////////
214     // Public functions
215     ////////////////////////
216 
217     function nextForkName()
218         public
219         constant
220         returns (string);
221 
222     function nextForkUrl()
223         public
224         constant
225         returns (string);
226 
227     function nextForkBlockNumber()
228         public
229         constant
230         returns (uint256);
231 
232     function lastSignedBlockNumber()
233         public
234         constant
235         returns (uint256);
236 
237     function lastSignedBlockHash()
238         public
239         constant
240         returns (bytes32);
241 
242     function lastSignedTimestamp()
243         public
244         constant
245         returns (uint256);
246 
247 }
248 
249 /**
250  * @title legally binding smart contract
251  * @dev General approach to paring legal and smart contracts:
252  * 1. All terms and agreement are between two parties: here between smart conctract legal representation and platform investor.
253  * 2. Parties are represented by public Ethereum addresses. Platform investor is and address that holds and controls funds and receives and controls Neumark token
254  * 3. Legal agreement has immutable part that corresponds to smart contract code and mutable part that may change for example due to changing regulations or other externalities that smart contract does not control.
255  * 4. There should be a provision in legal document that future changes in mutable part cannot change terms of immutable part.
256  * 5. Immutable part links to corresponding smart contract via its address.
257  * 6. Additional provision should be added if smart contract supports it
258  *  a. Fork provision
259  *  b. Bugfixing provision (unilateral code update mechanism)
260  *  c. Migration provision (bilateral code update mechanism)
261  *
262  * Details on Agreement base class:
263  * 1. We bind smart contract to legal contract by storing uri (preferably ipfs or hash) of the legal contract in the smart contract. It is however crucial that such binding is done by smart contract legal representation so transaction establishing the link must be signed by respective wallet ('amendAgreement')
264  * 2. Mutable part of agreement may change. We should be able to amend the uri later. Previous amendments should not be lost and should be retrievable (`amendAgreement` and 'pastAgreement' functions).
265  * 3. It is up to deriving contract to decide where to put 'acceptAgreement' modifier. However situation where there is no cryptographic proof that given address was really acting in the transaction should be avoided, simplest example being 'to' address in `transfer` function of ERC20.
266  *
267 **/
268 contract IAgreement {
269 
270     ////////////////////////
271     // Events
272     ////////////////////////
273 
274     event LogAgreementAccepted(
275         address indexed accepter
276     );
277 
278     event LogAgreementAmended(
279         address contractLegalRepresentative,
280         string agreementUri
281     );
282 
283     /// @dev should have access restrictions so only contractLegalRepresentative may call
284     function amendAgreement(string agreementUri) public;
285 
286     /// returns information on last amendment of the agreement
287     /// @dev MUST revert if no agreements were set
288     function currentAgreement()
289         public
290         constant
291         returns
292         (
293             address contractLegalRepresentative,
294             uint256 signedBlockTimestamp,
295             string agreementUri,
296             uint256 index
297         );
298 
299     /// returns information on amendment with index
300     /// @dev MAY revert on non existing amendment, indexing starts from 0
301     function pastAgreement(uint256 amendmentIndex)
302         public
303         constant
304         returns
305         (
306             address contractLegalRepresentative,
307             uint256 signedBlockTimestamp,
308             string agreementUri,
309             uint256 index
310         );
311 
312     /// returns the number of block at wchich `signatory` signed agreement
313     /// @dev MUST return 0 if not signed
314     function agreementSignedAtBlock(address signatory)
315         public
316         constant
317         returns (uint256 blockNo);
318 
319     /// returns number of amendments made by contractLegalRepresentative
320     function amendmentsCount()
321         public
322         constant
323         returns (uint256);
324 }
325 
326 /**
327  * @title legally binding smart contract
328  * @dev read IAgreement for details
329 **/
330 contract Agreement is
331     IAgreement,
332     AccessControlled,
333     AccessRoles
334 {
335 
336     ////////////////////////
337     // Type declarations
338     ////////////////////////
339 
340     /// @notice agreement with signature of the platform operator representative
341     struct SignedAgreement {
342         address contractLegalRepresentative;
343         uint256 signedBlockTimestamp;
344         string agreementUri;
345     }
346 
347     ////////////////////////
348     // Immutable state
349     ////////////////////////
350 
351     IEthereumForkArbiter private ETHEREUM_FORK_ARBITER;
352 
353     ////////////////////////
354     // Mutable state
355     ////////////////////////
356 
357     // stores all amendments to the agreement, first amendment is the original
358     SignedAgreement[] private _amendments;
359 
360     // stores block numbers of all addresses that signed the agreement (signatory => block number)
361     mapping(address => uint256) private _signatories;
362 
363     ////////////////////////
364     // Modifiers
365     ////////////////////////
366 
367     /// @notice logs that agreement was accepted by platform user
368     /// @dev intended to be added to functions that if used make 'accepter' origin to enter legally binding agreement
369     modifier acceptAgreement(address accepter) {
370         acceptAgreementInternal(accepter);
371         _;
372     }
373 
374     modifier onlyLegalRepresentative(address legalRepresentative) {
375         require(mCanAmend(legalRepresentative));
376         _;
377     }
378 
379     ////////////////////////
380     // Constructor
381     ////////////////////////
382 
383     constructor(IAccessPolicy accessPolicy, IEthereumForkArbiter forkArbiter)
384         AccessControlled(accessPolicy)
385         internal
386     {
387         require(forkArbiter != IEthereumForkArbiter(0x0));
388         ETHEREUM_FORK_ARBITER = forkArbiter;
389     }
390 
391     ////////////////////////
392     // Public functions
393     ////////////////////////
394 
395     function amendAgreement(string agreementUri)
396         public
397         onlyLegalRepresentative(msg.sender)
398     {
399         SignedAgreement memory amendment = SignedAgreement({
400             contractLegalRepresentative: msg.sender,
401             signedBlockTimestamp: block.timestamp,
402             agreementUri: agreementUri
403         });
404         _amendments.push(amendment);
405         emit LogAgreementAmended(msg.sender, agreementUri);
406     }
407 
408     function ethereumForkArbiter()
409         public
410         constant
411         returns (IEthereumForkArbiter)
412     {
413         return ETHEREUM_FORK_ARBITER;
414     }
415 
416     function currentAgreement()
417         public
418         constant
419         returns
420         (
421             address contractLegalRepresentative,
422             uint256 signedBlockTimestamp,
423             string agreementUri,
424             uint256 index
425         )
426     {
427         require(_amendments.length > 0);
428         uint256 last = _amendments.length - 1;
429         SignedAgreement storage amendment = _amendments[last];
430         return (
431             amendment.contractLegalRepresentative,
432             amendment.signedBlockTimestamp,
433             amendment.agreementUri,
434             last
435         );
436     }
437 
438     function pastAgreement(uint256 amendmentIndex)
439         public
440         constant
441         returns
442         (
443             address contractLegalRepresentative,
444             uint256 signedBlockTimestamp,
445             string agreementUri,
446             uint256 index
447         )
448     {
449         SignedAgreement storage amendment = _amendments[amendmentIndex];
450         return (
451             amendment.contractLegalRepresentative,
452             amendment.signedBlockTimestamp,
453             amendment.agreementUri,
454             amendmentIndex
455         );
456     }
457 
458     function agreementSignedAtBlock(address signatory)
459         public
460         constant
461         returns (uint256 blockNo)
462     {
463         return _signatories[signatory];
464     }
465 
466     function amendmentsCount()
467         public
468         constant
469         returns (uint256)
470     {
471         return _amendments.length;
472     }
473 
474     ////////////////////////
475     // Internal functions
476     ////////////////////////
477 
478     /// provides direct access to derived contract
479     function acceptAgreementInternal(address accepter)
480         internal
481     {
482         if(_signatories[accepter] == 0) {
483             require(_amendments.length > 0);
484             _signatories[accepter] = block.number;
485             emit LogAgreementAccepted(accepter);
486         }
487     }
488 
489     //
490     // MAgreement Internal interface (todo: extract)
491     //
492 
493     /// default amend permission goes to ROLE_PLATFORM_OPERATOR_REPRESENTATIVE
494     function mCanAmend(address legalRepresentative)
495         internal
496         returns (bool)
497     {
498         return accessPolicy().allowed(legalRepresentative, ROLE_PLATFORM_OPERATOR_REPRESENTATIVE, this, msg.sig);
499     }
500 }
501 
502 /// @title access to snapshots of a token
503 /// @notice allows to implement complex token holder rights like revenue disbursal or voting
504 /// @notice snapshots are series of values with assigned ids. ids increase strictly. particular id mechanism is not assumed
505 contract ITokenSnapshots {
506 
507     ////////////////////////
508     // Public functions
509     ////////////////////////
510 
511     /// @notice Total amount of tokens at a specific `snapshotId`.
512     /// @param snapshotId of snapshot at which totalSupply is queried
513     /// @return The total amount of tokens at `snapshotId`
514     /// @dev reverts on snapshotIds greater than currentSnapshotId()
515     /// @dev returns 0 for snapshotIds less than snapshotId of first value
516     function totalSupplyAt(uint256 snapshotId)
517         public
518         constant
519         returns(uint256);
520 
521     /// @dev Queries the balance of `owner` at a specific `snapshotId`
522     /// @param owner The address from which the balance will be retrieved
523     /// @param snapshotId of snapshot at which the balance is queried
524     /// @return The balance at `snapshotId`
525     function balanceOfAt(address owner, uint256 snapshotId)
526         public
527         constant
528         returns (uint256);
529 
530     /// @notice upper bound of series of snapshotIds for which there's a value in series
531     /// @return snapshotId
532     function currentSnapshotId()
533         public
534         constant
535         returns (uint256);
536 }
537 
538 /// @title represents link between cloned and parent token
539 /// @dev when token is clone from other token, initial balances of the cloned token
540 ///     correspond to balances of parent token at the moment of parent snapshot id specified
541 /// @notice please note that other tokens beside snapshot token may be cloned
542 contract IClonedTokenParent is ITokenSnapshots {
543 
544     ////////////////////////
545     // Public functions
546     ////////////////////////
547 
548 
549     /// @return address of parent token, address(0) if root
550     /// @dev parent token does not need to clonable, nor snapshottable, just a normal token
551     function parentToken()
552         public
553         constant
554         returns(IClonedTokenParent parent);
555 
556     /// @return snapshot at wchich initial token distribution was taken
557     function parentSnapshotId()
558         public
559         constant
560         returns(uint256 snapshotId);
561 }
562 
563 contract IBasicToken {
564 
565     ////////////////////////
566     // Events
567     ////////////////////////
568 
569     event Transfer(
570         address indexed from,
571         address indexed to,
572         uint256 amount
573     );
574 
575     ////////////////////////
576     // Public functions
577     ////////////////////////
578 
579     /// @dev This function makes it easy to get the total number of tokens
580     /// @return The total number of tokens
581     function totalSupply()
582         public
583         constant
584         returns (uint256);
585 
586     /// @param owner The address that's balance is being requested
587     /// @return The balance of `owner` at the current block
588     function balanceOf(address owner)
589         public
590         constant
591         returns (uint256 balance);
592 
593     /// @notice Send `amount` tokens to `to` from `msg.sender`
594     /// @param to The address of the recipient
595     /// @param amount The amount of tokens to be transferred
596     /// @return Whether the transfer was successful or not
597     function transfer(address to, uint256 amount)
598         public
599         returns (bool success);
600 
601 }
602 
603 contract IERC20Allowance {
604 
605     ////////////////////////
606     // Events
607     ////////////////////////
608 
609     event Approval(
610         address indexed owner,
611         address indexed spender,
612         uint256 amount
613     );
614 
615     ////////////////////////
616     // Public functions
617     ////////////////////////
618 
619     /// @dev This function makes it easy to read the `allowed[]` map
620     /// @param owner The address of the account that owns the token
621     /// @param spender The address of the account able to transfer the tokens
622     /// @return Amount of remaining tokens of owner that spender is allowed
623     ///  to spend
624     function allowance(address owner, address spender)
625         public
626         constant
627         returns (uint256 remaining);
628 
629     /// @notice `msg.sender` approves `spender` to spend `amount` tokens on
630     ///  its behalf. This is a modified version of the ERC20 approve function
631     ///  to be a little bit safer
632     /// @param spender The address of the account able to transfer the tokens
633     /// @param amount The amount of tokens to be approved for transfer
634     /// @return True if the approval was successful
635     function approve(address spender, uint256 amount)
636         public
637         returns (bool success);
638 
639     /// @notice Send `amount` tokens to `to` from `from` on the condition it
640     ///  is approved by `from`
641     /// @param from The address holding the tokens being transferred
642     /// @param to The address of the recipient
643     /// @param amount The amount of tokens to be transferred
644     /// @return True if the transfer was successful
645     function transferFrom(address from, address to, uint256 amount)
646         public
647         returns (bool success);
648 
649 }
650 
651 contract IERC20Token is IBasicToken, IERC20Allowance {
652 
653 }
654 
655 contract ITokenMetadata {
656 
657     ////////////////////////
658     // Public functions
659     ////////////////////////
660 
661     function symbol()
662         public
663         constant
664         returns (string);
665 
666     function name()
667         public
668         constant
669         returns (string);
670 
671     function decimals()
672         public
673         constant
674         returns (uint8);
675 }
676 
677 contract IERC223Token is IERC20Token, ITokenMetadata {
678 
679     /// @dev Departure: We do not log data, it has no advantage over a standard
680     ///     log event. By sticking to the standard log event we
681     ///     stay compatible with constracts that expect and ERC20 token.
682 
683     // event Transfer(
684     //    address indexed from,
685     //    address indexed to,
686     //    uint256 amount,
687     //    bytes data);
688 
689 
690     /// @dev Departure: We do not use the callback on regular transfer calls to
691     ///     stay compatible with constracts that expect and ERC20 token.
692 
693     // function transfer(address to, uint256 amount)
694     //     public
695     //     returns (bool);
696 
697     ////////////////////////
698     // Public functions
699     ////////////////////////
700 
701     function transfer(address to, uint256 amount, bytes data)
702         public
703         returns (bool);
704 }
705 
706 contract IERC677Allowance is IERC20Allowance {
707 
708     ////////////////////////
709     // Public functions
710     ////////////////////////
711 
712     /// @notice `msg.sender` approves `spender` to send `amount` tokens on
713     ///  its behalf, and then a function is triggered in the contract that is
714     ///  being approved, `spender`. This allows users to use their tokens to
715     ///  interact with contracts in one function call instead of two
716     /// @param spender The address of the contract able to transfer the tokens
717     /// @param amount The amount of tokens to be approved for transfer
718     /// @return True if the function call was successful
719     function approveAndCall(address spender, uint256 amount, bytes extraData)
720         public
721         returns (bool success);
722 
723 }
724 
725 contract IERC677Token is IERC20Token, IERC677Allowance {
726 }
727 
728 /// @title hooks token controller to token contract and allows to replace it
729 contract ITokenControllerHook {
730 
731     ////////////////////////
732     // Events
733     ////////////////////////
734 
735     event LogChangeTokenController(
736         address oldController,
737         address newController,
738         address by
739     );
740 
741     ////////////////////////
742     // Public functions
743     ////////////////////////
744 
745     /// @notice replace current token controller
746     /// @dev please note that this process is also controlled by existing controller
747     function changeTokenController(address newController)
748         public;
749 
750     /// @notice returns current controller
751     function tokenController()
752         public
753         constant
754         returns (address currentController);
755 
756 }
757 
758 /// @title state space of ETOCommitment
759 contract IETOCommitmentStates {
760     ////////////////////////
761     // Types
762     ////////////////////////
763 
764     // order must reflect time precedence, do not change order below
765     enum ETOState {
766         Setup, // Initial state
767         Whitelist,
768         Public,
769         Signing,
770         Claim,
771         Payout, // Terminal state
772         Refund // Terminal state
773     }
774 
775     // number of states in enum
776     uint256 constant internal ETO_STATES_COUNT = 7;
777 }
778 
779 /// @title provides callback on state transitions
780 /// @dev observer called after the state() of commitment contract was set
781 contract IETOCommitmentObserver is IETOCommitmentStates {
782     function commitmentObserver() public constant returns (address);
783     function onStateTransition(ETOState oldState, ETOState newState) public;
784 }
785 
786 /// @title current ERC223 fallback function
787 /// @dev to be used in all future token contract
788 /// @dev NEU and ICBMEtherToken (obsolete) are the only contracts that still uses IERC223LegacyCallback
789 contract IERC223Callback {
790 
791     ////////////////////////
792     // Public functions
793     ////////////////////////
794 
795     function tokenFallback(address from, uint256 amount, bytes data)
796         public;
797 
798 }
799 
800 /// @title granular token controller based on MSnapshotToken observer pattern
801 contract ITokenController {
802 
803     ////////////////////////
804     // Public functions
805     ////////////////////////
806 
807     /// @notice see MTokenTransferController
808     /// @dev additionally passes broker that is executing transaction between from and to
809     ///      for unbrokered transfer, broker == from
810     function onTransfer(address broker, address from, address to, uint256 amount)
811         public
812         constant
813         returns (bool allow);
814 
815     /// @notice see MTokenAllowanceController
816     function onApprove(address owner, address spender, uint256 amount)
817         public
818         constant
819         returns (bool allow);
820 
821     /// @notice see MTokenMint
822     function onGenerateTokens(address sender, address owner, uint256 amount)
823         public
824         constant
825         returns (bool allow);
826 
827     /// @notice see MTokenMint
828     function onDestroyTokens(address sender, address owner, uint256 amount)
829         public
830         constant
831         returns (bool allow);
832 
833     /// @notice controls if sender can change controller to newController
834     /// @dev for this to succeed TYPICALLY current controller must be already migrated to a new one
835     function onChangeTokenController(address sender, address newController)
836         public
837         constant
838         returns (bool);
839 
840     /// @notice overrides spender allowance
841     /// @dev may be used to implemented forced transfers in which token controller may override approved allowance
842     ///      with any > 0 value and then use transferFrom to execute such transfer
843     ///      This by definition creates non-trustless token so do not implement this call if you do not need trustless transfers!
844     ///      Implementer should not allow approve() to be executed if there is an overrride
845     //       Implemented should return allowance() taking into account override
846     function onAllowance(address owner, address spender)
847         public
848         constant
849         returns (uint256 allowanceOverride);
850 }
851 
852 contract IEquityTokenController is
853     IAgreement,
854     ITokenController,
855     IETOCommitmentObserver,
856     IERC223Callback
857 {
858     /// controls if sender can change old nominee to new nominee
859     /// @dev for this to succeed typically a voting of the token holders should happen and new nominee should be set
860     function onChangeNominee(address sender, address oldNominee, address newNominee)
861         public
862         constant
863         returns (bool);
864 }
865 
866 contract IEquityToken is
867     IAgreement,
868     IClonedTokenParent,
869     IERC223Token,
870     ITokenControllerHook
871 {
872     /// @dev equity token is not divisible (Decimals == 0) but single share is represented by
873     ///  tokensPerShare tokens
874     function tokensPerShare() public constant returns (uint256);
875 
876     // number of shares represented by tokens. we round to the closest value.
877     function sharesTotalSupply() public constant returns (uint256);
878 
879     /// nominal value of a share in EUR decimal(18) precision
880     function shareNominalValueEurUlps() public constant returns (uint256);
881 
882     // returns company legal representative account that never changes
883     function companyLegalRepresentative() public constant returns (address);
884 
885     /// returns current nominee which is contract legal rep
886     function nominee() public constant returns (address);
887 
888     /// only by previous nominee
889     function changeNominee(address newNominee) public;
890 
891     /// controlled, always issues to msg.sender
892     function issueTokens(uint256 amount) public;
893 
894     /// controlled, may send tokens even when transfer are disabled: to active ETO only
895     function distributeTokens(address to, uint256 amount) public;
896 
897     // controlled, msg.sender is typically failed ETO
898     function destroyTokens(uint256 amount) public;
899 }
900 
901 /// @title uniquely identifies deployable (non-abstract) platform contract
902 /// @notice cheap way of assigning implementations to knownInterfaces which represent system services
903 ///         unfortunatelly ERC165 does not include full public interface (ABI) and does not provide way to list implemented interfaces
904 ///         EIP820 still in the making
905 /// @dev ids are generated as follows keccak256("neufund-platform:<contract name>")
906 ///      ids roughly correspond to ABIs
907 contract IContractId {
908     /// @param id defined as above
909     /// @param version implementation version
910     function contractId() public pure returns (bytes32 id, uint256 version);
911 }
912 
913 contract ShareholderRights is IContractId {
914 
915     ////////////////////////
916     // Types
917     ////////////////////////
918 
919     enum VotingRule {
920         // nominee has no voting rights
921         NoVotingRights,
922         // nominee votes yes if token holders do not say otherwise
923         Positive,
924         // nominee votes against if token holders do not say otherwise
925         Negative,
926         // nominee passes the vote as is giving yes/no split
927         Proportional
928     }
929 
930     ////////////////////////
931     // Constants state
932     ////////////////////////
933 
934     bytes32 private constant EMPTY_STRING_HASH = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
935 
936     ////////////////////////
937     // Immutable state
938     ////////////////////////
939 
940     // a right to drag along (or be dragged) on exit
941     bool public constant HAS_DRAG_ALONG_RIGHTS = true;
942     // a right to tag along
943     bool public constant HAS_TAG_ALONG_RIGHTS = true;
944     // information is fundamental right that cannot be removed
945     bool public constant HAS_GENERAL_INFORMATION_RIGHTS = true;
946     // voting Right
947     VotingRule public GENERAL_VOTING_RULE;
948     // voting rights in tag along
949     VotingRule public TAG_ALONG_VOTING_RULE;
950     // liquidation preference multiplicator as decimal fraction
951     uint256 public LIQUIDATION_PREFERENCE_MULTIPLIER_FRAC;
952     // founder's vesting
953     bool public HAS_FOUNDERS_VESTING;
954     // duration of general voting
955     uint256 public GENERAL_VOTING_DURATION;
956     // duration of restricted act votings (like exit etc.)
957     uint256 public RESTRICTED_ACT_VOTING_DURATION;
958     // offchain time to finalize and execute voting;
959     uint256 public VOTING_FINALIZATION_DURATION;
960     // quorum of tokenholders for the vote to count as decimal fraction
961     uint256 public TOKENHOLDERS_QUORUM_FRAC = 10**17; // 10%
962     // number of tokens voting / total supply must be more than this to count the vote
963     uint256 public VOTING_MAJORITY_FRAC = 10**17; // 10%
964     // url (typically IPFS hash) to investment agreement between nominee and company
965     string public INVESTMENT_AGREEMENT_TEMPLATE_URL;
966 
967     ////////////////////////
968     // Constructor
969     ////////////////////////
970 
971     constructor(
972         VotingRule generalVotingRule,
973         VotingRule tagAlongVotingRule,
974         uint256 liquidationPreferenceMultiplierFrac,
975         bool hasFoundersVesting,
976         uint256 generalVotingDuration,
977         uint256 restrictedActVotingDuration,
978         uint256 votingFinalizationDuration,
979         uint256 tokenholdersQuorumFrac,
980         uint256 votingMajorityFrac,
981         string investmentAgreementTemplateUrl
982     )
983         public
984     {
985         // todo: revise requires
986         require(uint(generalVotingRule) < 4);
987         require(uint(tagAlongVotingRule) < 4);
988         // quorum < 100%
989         require(tokenholdersQuorumFrac < 10**18);
990         require(keccak256(abi.encodePacked(investmentAgreementTemplateUrl)) != EMPTY_STRING_HASH);
991 
992         GENERAL_VOTING_RULE = generalVotingRule;
993         TAG_ALONG_VOTING_RULE = tagAlongVotingRule;
994         LIQUIDATION_PREFERENCE_MULTIPLIER_FRAC = liquidationPreferenceMultiplierFrac;
995         HAS_FOUNDERS_VESTING = hasFoundersVesting;
996         GENERAL_VOTING_DURATION = generalVotingDuration;
997         RESTRICTED_ACT_VOTING_DURATION = restrictedActVotingDuration;
998         VOTING_FINALIZATION_DURATION = votingFinalizationDuration;
999         TOKENHOLDERS_QUORUM_FRAC = tokenholdersQuorumFrac;
1000         VOTING_MAJORITY_FRAC = votingMajorityFrac;
1001         INVESTMENT_AGREEMENT_TEMPLATE_URL = investmentAgreementTemplateUrl;
1002     }
1003 
1004     //
1005     // Implements IContractId
1006     //
1007 
1008     function contractId() public pure returns (bytes32 id, uint256 version) {
1009         return (0x7f46caed28b4e7a90dc4db9bba18d1565e6c4824f0dc1b96b3b88d730da56e57, 0);
1010     }
1011 }
1012 
1013 contract Math {
1014 
1015     ////////////////////////
1016     // Internal functions
1017     ////////////////////////
1018 
1019     // absolute difference: |v1 - v2|
1020     function absDiff(uint256 v1, uint256 v2)
1021         internal
1022         pure
1023         returns(uint256)
1024     {
1025         return v1 > v2 ? v1 - v2 : v2 - v1;
1026     }
1027 
1028     // divide v by d, round up if remainder is 0.5 or more
1029     function divRound(uint256 v, uint256 d)
1030         internal
1031         pure
1032         returns(uint256)
1033     {
1034         return add(v, d/2) / d;
1035     }
1036 
1037     // computes decimal decimalFraction 'frac' of 'amount' with maximum precision (multiplication first)
1038     // both amount and decimalFraction must have 18 decimals precision, frac 10**18 represents a whole (100% of) amount
1039     // mind loss of precision as decimal fractions do not have finite binary expansion
1040     // do not use instead of division
1041     function decimalFraction(uint256 amount, uint256 frac)
1042         internal
1043         pure
1044         returns(uint256)
1045     {
1046         // it's like 1 ether is 100% proportion
1047         return proportion(amount, frac, 10**18);
1048     }
1049 
1050     // computes part/total of amount with maximum precision (multiplication first)
1051     // part and total must have the same units
1052     function proportion(uint256 amount, uint256 part, uint256 total)
1053         internal
1054         pure
1055         returns(uint256)
1056     {
1057         return divRound(mul(amount, part), total);
1058     }
1059 
1060     //
1061     // Open Zeppelin Math library below
1062     //
1063 
1064     function mul(uint256 a, uint256 b)
1065         internal
1066         pure
1067         returns (uint256)
1068     {
1069         uint256 c = a * b;
1070         assert(a == 0 || c / a == b);
1071         return c;
1072     }
1073 
1074     function sub(uint256 a, uint256 b)
1075         internal
1076         pure
1077         returns (uint256)
1078     {
1079         assert(b <= a);
1080         return a - b;
1081     }
1082 
1083     function add(uint256 a, uint256 b)
1084         internal
1085         pure
1086         returns (uint256)
1087     {
1088         uint256 c = a + b;
1089         assert(c >= a);
1090         return c;
1091     }
1092 
1093     function min(uint256 a, uint256 b)
1094         internal
1095         pure
1096         returns (uint256)
1097     {
1098         return a < b ? a : b;
1099     }
1100 
1101     function max(uint256 a, uint256 b)
1102         internal
1103         pure
1104         returns (uint256)
1105     {
1106         return a > b ? a : b;
1107     }
1108 }
1109 
1110 /// @title set terms of Platform (investor's network) of the ETO
1111 contract PlatformTerms is Math, IContractId {
1112 
1113     ////////////////////////
1114     // Constants
1115     ////////////////////////
1116 
1117     // fraction of fee deduced on successful ETO (see Math.sol for fraction definition)
1118     uint256 public constant PLATFORM_FEE_FRACTION = 3 * 10**16;
1119     // fraction of tokens deduced on succesful ETO
1120     uint256 public constant TOKEN_PARTICIPATION_FEE_FRACTION = 2 * 10**16;
1121     // share of Neumark reward platform operator gets
1122     // actually this is a divisor that splits Neumark reward in two parts
1123     // the results of division belongs to platform operator, the remaining reward part belongs to investor
1124     uint256 public constant PLATFORM_NEUMARK_SHARE = 2; // 50:50 division
1125     // ICBM investors whitelisted by default
1126     bool public constant IS_ICBM_INVESTOR_WHITELISTED = true;
1127 
1128     // minimum ticket size Platform accepts in EUR ULPS
1129     uint256 public constant MIN_TICKET_EUR_ULPS = 100 * 10**18;
1130     // maximum ticket size Platform accepts in EUR ULPS
1131     // no max ticket in general prospectus regulation
1132     // uint256 public constant MAX_TICKET_EUR_ULPS = 10000000 * 10**18;
1133 
1134     // min duration from setting the date to ETO start
1135     uint256 public constant DATE_TO_WHITELIST_MIN_DURATION = 7 days;
1136     // token rate expires after
1137     uint256 public constant TOKEN_RATE_EXPIRES_AFTER = 4 hours;
1138 
1139     // duration constraints
1140     uint256 public constant MIN_WHITELIST_DURATION = 0 days;
1141     uint256 public constant MAX_WHITELIST_DURATION = 30 days;
1142     uint256 public constant MIN_PUBLIC_DURATION = 0 days;
1143     uint256 public constant MAX_PUBLIC_DURATION = 60 days;
1144 
1145     // minimum length of whole offer
1146     uint256 public constant MIN_OFFER_DURATION = 1 days;
1147     // quarter should be enough for everyone
1148     uint256 public constant MAX_OFFER_DURATION = 90 days;
1149 
1150     uint256 public constant MIN_SIGNING_DURATION = 14 days;
1151     uint256 public constant MAX_SIGNING_DURATION = 60 days;
1152 
1153     uint256 public constant MIN_CLAIM_DURATION = 7 days;
1154     uint256 public constant MAX_CLAIM_DURATION = 30 days;
1155 
1156     // time after which claimable tokens become recycleable in fee disbursal pool
1157     uint256 public constant DEFAULT_DISBURSAL_RECYCLE_AFTER_DURATION = 4 * 365 days;
1158 
1159     ////////////////////////
1160     // Public Function
1161     ////////////////////////
1162 
1163     // calculates investor's and platform operator's neumarks from total reward
1164     function calculateNeumarkDistribution(uint256 rewardNmk)
1165         public
1166         pure
1167         returns (uint256 platformNmk, uint256 investorNmk)
1168     {
1169         // round down - platform may get 1 wei less than investor
1170         platformNmk = rewardNmk / PLATFORM_NEUMARK_SHARE;
1171         // rewardNmk > platformNmk always
1172         return (platformNmk, rewardNmk - platformNmk);
1173     }
1174 
1175     function calculatePlatformTokenFee(uint256 tokenAmount)
1176         public
1177         pure
1178         returns (uint256)
1179     {
1180         // mind tokens having 0 precision
1181         return proportion(tokenAmount, TOKEN_PARTICIPATION_FEE_FRACTION, 10**18);
1182     }
1183 
1184     function calculatePlatformFee(uint256 amount)
1185         public
1186         pure
1187         returns (uint256)
1188     {
1189         return decimalFraction(amount, PLATFORM_FEE_FRACTION);
1190     }
1191 
1192     //
1193     // Implements IContractId
1194     //
1195 
1196     function contractId() public pure returns (bytes32 id, uint256 version) {
1197         return (0x95482babc4e32de6c4dc3910ee7ae62c8e427efde6bc4e9ce0d6d93e24c39323, 1);
1198     }
1199 }
1200 
1201 /// @title describes layout of claims in 256bit records stored for identities
1202 /// @dev intended to be derived by contracts requiring access to particular claims
1203 contract IdentityRecord {
1204 
1205     ////////////////////////
1206     // Types
1207     ////////////////////////
1208 
1209     /// @dev here the idea is to have claims of size of uint256 and use this struct
1210     ///     to translate in and out of this struct. until we do not cross uint256 we
1211     ///     have binary compatibility
1212     struct IdentityClaims {
1213         bool isVerified; // 1 bit
1214         bool isSophisticatedInvestor; // 1 bit
1215         bool hasBankAccount; // 1 bit
1216         bool accountFrozen; // 1 bit
1217         // uint252 reserved
1218     }
1219 
1220     ////////////////////////
1221     // Internal functions
1222     ////////////////////////
1223 
1224     /// translates uint256 to struct
1225     function deserializeClaims(bytes32 data) internal pure returns (IdentityClaims memory claims) {
1226         // for memory layout of struct, each field below word length occupies whole word
1227         assembly {
1228             mstore(claims, and(data, 0x1))
1229             mstore(add(claims, 0x20), div(and(data, 0x2), 0x2))
1230             mstore(add(claims, 0x40), div(and(data, 0x4), 0x4))
1231             mstore(add(claims, 0x60), div(and(data, 0x8), 0x8))
1232         }
1233     }
1234 }
1235 
1236 
1237 /// @title interface storing and retrieve 256bit claims records for identity
1238 /// actual format of record is decoupled from storage (except maximum size)
1239 contract IIdentityRegistry {
1240 
1241     ////////////////////////
1242     // Events
1243     ////////////////////////
1244 
1245     /// provides information on setting claims
1246     event LogSetClaims(
1247         address indexed identity,
1248         bytes32 oldClaims,
1249         bytes32 newClaims
1250     );
1251 
1252     ////////////////////////
1253     // Public functions
1254     ////////////////////////
1255 
1256     /// get claims for identity
1257     function getClaims(address identity) public constant returns (bytes32);
1258 
1259     /// set claims for identity
1260     /// @dev odlClaims and newClaims used for optimistic locking. to override with newClaims
1261     ///     current claims must be oldClaims
1262     function setClaims(address identity, bytes32 oldClaims, bytes32 newClaims) public;
1263 }
1264 
1265 /// @title known interfaces (services) of the platform
1266 /// "known interface" is a unique id of service provided by the platform and discovered via Universe contract
1267 ///  it does not refer to particular contract/interface ABI, particular service may be delivered via different implementations
1268 ///  however for a few contracts we commit platform to particular implementation (all ICBM Contracts, Universe itself etc.)
1269 /// @dev constants are kept in CODE not in STORAGE so they are comparatively cheap
1270 contract KnownInterfaces {
1271 
1272     ////////////////////////
1273     // Constants
1274     ////////////////////////
1275 
1276     // NOTE: All interface are set to the keccak256 hash of the
1277     // CamelCased interface or singleton name, i.e.
1278     // KNOWN_INTERFACE_NEUMARK = keccak256("Neumark")
1279 
1280     // EIP 165 + EIP 820 should be use instead but it seems they are far from finished
1281     // also interface signature should be build automatically by solidity. otherwise it is a pure hassle
1282 
1283     // neumark token interface and sigleton keccak256("Neumark")
1284     bytes4 internal constant KNOWN_INTERFACE_NEUMARK = 0xeb41a1bd;
1285 
1286     // ether token interface and singleton keccak256("EtherToken")
1287     bytes4 internal constant KNOWN_INTERFACE_ETHER_TOKEN = 0x8cf73cf1;
1288 
1289     // euro token interface and singleton keccak256("EuroToken")
1290     bytes4 internal constant KNOWN_INTERFACE_EURO_TOKEN = 0x83c3790b;
1291 
1292     // identity registry interface and singleton keccak256("IIdentityRegistry")
1293     bytes4 internal constant KNOWN_INTERFACE_IDENTITY_REGISTRY = 0x0a72e073;
1294 
1295     // currency rates oracle interface and singleton keccak256("ITokenExchangeRateOracle")
1296     bytes4 internal constant KNOWN_INTERFACE_TOKEN_EXCHANGE_RATE_ORACLE = 0xc6e5349e;
1297 
1298     // fee disbursal interface and singleton keccak256("IFeeDisbursal")
1299     bytes4 internal constant KNOWN_INTERFACE_FEE_DISBURSAL = 0xf4c848e8;
1300 
1301     // platform portfolio holding equity tokens belonging to NEU holders keccak256("IPlatformPortfolio");
1302     bytes4 internal constant KNOWN_INTERFACE_PLATFORM_PORTFOLIO = 0xaa1590d0;
1303 
1304     // token exchange interface and singleton keccak256("ITokenExchange")
1305     bytes4 internal constant KNOWN_INTERFACE_TOKEN_EXCHANGE = 0xddd7a521;
1306 
1307     // service exchanging euro token for gas ("IGasTokenExchange")
1308     bytes4 internal constant KNOWN_INTERFACE_GAS_EXCHANGE = 0x89dbc6de;
1309 
1310     // access policy interface and singleton keccak256("IAccessPolicy")
1311     bytes4 internal constant KNOWN_INTERFACE_ACCESS_POLICY = 0xb05049d9;
1312 
1313     // euro lock account (upgraded) keccak256("LockedAccount:Euro")
1314     bytes4 internal constant KNOWN_INTERFACE_EURO_LOCK = 0x2347a19e;
1315 
1316     // ether lock account (upgraded) keccak256("LockedAccount:Ether")
1317     bytes4 internal constant KNOWN_INTERFACE_ETHER_LOCK = 0x978a6823;
1318 
1319     // icbm euro lock account keccak256("ICBMLockedAccount:Euro")
1320     bytes4 internal constant KNOWN_INTERFACE_ICBM_EURO_LOCK = 0x36021e14;
1321 
1322     // ether lock account (upgraded) keccak256("ICBMLockedAccount:Ether")
1323     bytes4 internal constant KNOWN_INTERFACE_ICBM_ETHER_LOCK = 0x0b58f006;
1324 
1325     // ether token interface and singleton keccak256("ICBMEtherToken")
1326     bytes4 internal constant KNOWN_INTERFACE_ICBM_ETHER_TOKEN = 0xae8b50b9;
1327 
1328     // euro token interface and singleton keccak256("ICBMEuroToken")
1329     bytes4 internal constant KNOWN_INTERFACE_ICBM_EURO_TOKEN = 0xc2c6cd72;
1330 
1331     // ICBM commitment interface interface and singleton keccak256("ICBMCommitment")
1332     bytes4 internal constant KNOWN_INTERFACE_ICBM_COMMITMENT = 0x7f2795ef;
1333 
1334     // ethereum fork arbiter interface and singleton keccak256("IEthereumForkArbiter")
1335     bytes4 internal constant KNOWN_INTERFACE_FORK_ARBITER = 0x2fe7778c;
1336 
1337     // Platform terms interface and singletong keccak256("PlatformTerms")
1338     bytes4 internal constant KNOWN_INTERFACE_PLATFORM_TERMS = 0x75ecd7f8;
1339 
1340     // for completness we define Universe service keccak256("Universe");
1341     bytes4 internal constant KNOWN_INTERFACE_UNIVERSE = 0xbf202454;
1342 
1343     // ETO commitment interface (collection) keccak256("ICommitment")
1344     bytes4 internal constant KNOWN_INTERFACE_COMMITMENT = 0xfa0e0c60;
1345 
1346     // Equity Token Controller interface (collection) keccak256("IEquityTokenController")
1347     bytes4 internal constant KNOWN_INTERFACE_EQUITY_TOKEN_CONTROLLER = 0xfa30b2f1;
1348 
1349     // Equity Token interface (collection) keccak256("IEquityToken")
1350     bytes4 internal constant KNOWN_INTERFACE_EQUITY_TOKEN = 0xab9885bb;
1351 
1352     // Payment tokens (collection) keccak256("PaymentToken")
1353     bytes4 internal constant KNOWN_INTERFACE_PAYMENT_TOKEN = 0xb2a0042a;
1354 }
1355 
1356 contract IsContract {
1357 
1358     ////////////////////////
1359     // Internal functions
1360     ////////////////////////
1361 
1362     function isContract(address addr)
1363         internal
1364         constant
1365         returns (bool)
1366     {
1367         uint256 size;
1368         // takes 700 gas
1369         assembly { size := extcodesize(addr) }
1370         return size > 0;
1371     }
1372 }
1373 
1374 contract NeumarkIssuanceCurve {
1375 
1376     ////////////////////////
1377     // Constants
1378     ////////////////////////
1379 
1380     // maximum number of neumarks that may be created
1381     uint256 private constant NEUMARK_CAP = 1500000000000000000000000000;
1382 
1383     // initial neumark reward fraction (controls curve steepness)
1384     uint256 private constant INITIAL_REWARD_FRACTION = 6500000000000000000;
1385 
1386     // stop issuing new Neumarks above this Euro value (as it goes quickly to zero)
1387     uint256 private constant ISSUANCE_LIMIT_EUR_ULPS = 8300000000000000000000000000;
1388 
1389     // approximate curve linearly above this Euro value
1390     uint256 private constant LINEAR_APPROX_LIMIT_EUR_ULPS = 2100000000000000000000000000;
1391     uint256 private constant NEUMARKS_AT_LINEAR_LIMIT_ULPS = 1499832501287264827896539871;
1392 
1393     uint256 private constant TOT_LINEAR_NEUMARKS_ULPS = NEUMARK_CAP - NEUMARKS_AT_LINEAR_LIMIT_ULPS;
1394     uint256 private constant TOT_LINEAR_EUR_ULPS = ISSUANCE_LIMIT_EUR_ULPS - LINEAR_APPROX_LIMIT_EUR_ULPS;
1395 
1396     ////////////////////////
1397     // Public functions
1398     ////////////////////////
1399 
1400     /// @notice returns additional amount of neumarks issued for euroUlps at totalEuroUlps
1401     /// @param totalEuroUlps actual curve position from which neumarks will be issued
1402     /// @param euroUlps amount against which neumarks will be issued
1403     function incremental(uint256 totalEuroUlps, uint256 euroUlps)
1404         public
1405         pure
1406         returns (uint256 neumarkUlps)
1407     {
1408         require(totalEuroUlps + euroUlps >= totalEuroUlps);
1409         uint256 from = cumulative(totalEuroUlps);
1410         uint256 to = cumulative(totalEuroUlps + euroUlps);
1411         // as expansion is not monotonic for large totalEuroUlps, assert below may fail
1412         // example: totalEuroUlps=1.999999999999999999999000000e+27 and euroUlps=50
1413         assert(to >= from);
1414         return to - from;
1415     }
1416 
1417     /// @notice returns amount of euro corresponding to burned neumarks
1418     /// @param totalEuroUlps actual curve position from which neumarks will be burned
1419     /// @param burnNeumarkUlps amount of neumarks to burn
1420     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps)
1421         public
1422         pure
1423         returns (uint256 euroUlps)
1424     {
1425         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
1426         require(totalNeumarkUlps >= burnNeumarkUlps);
1427         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
1428         uint newTotalEuroUlps = cumulativeInverse(fromNmk, 0, totalEuroUlps);
1429         // yes, this may overflow due to non monotonic inverse function
1430         assert(totalEuroUlps >= newTotalEuroUlps);
1431         return totalEuroUlps - newTotalEuroUlps;
1432     }
1433 
1434     /// @notice returns amount of euro corresponding to burned neumarks
1435     /// @param totalEuroUlps actual curve position from which neumarks will be burned
1436     /// @param burnNeumarkUlps amount of neumarks to burn
1437     /// @param minEurUlps euro amount to start inverse search from, inclusive
1438     /// @param maxEurUlps euro amount to end inverse search to, inclusive
1439     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
1440         public
1441         pure
1442         returns (uint256 euroUlps)
1443     {
1444         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
1445         require(totalNeumarkUlps >= burnNeumarkUlps);
1446         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
1447         uint newTotalEuroUlps = cumulativeInverse(fromNmk, minEurUlps, maxEurUlps);
1448         // yes, this may overflow due to non monotonic inverse function
1449         assert(totalEuroUlps >= newTotalEuroUlps);
1450         return totalEuroUlps - newTotalEuroUlps;
1451     }
1452 
1453     /// @notice finds total amount of neumarks issued for given amount of Euro
1454     /// @dev binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
1455     ///     function below is not monotonic
1456     function cumulative(uint256 euroUlps)
1457         public
1458         pure
1459         returns(uint256 neumarkUlps)
1460     {
1461         // Return the cap if euroUlps is above the limit.
1462         if (euroUlps >= ISSUANCE_LIMIT_EUR_ULPS) {
1463             return NEUMARK_CAP;
1464         }
1465         // use linear approximation above limit below
1466         // binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
1467         if (euroUlps >= LINEAR_APPROX_LIMIT_EUR_ULPS) {
1468             // (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS) is small so expression does not overflow
1469             return NEUMARKS_AT_LINEAR_LIMIT_ULPS + (TOT_LINEAR_NEUMARKS_ULPS * (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS)) / TOT_LINEAR_EUR_ULPS;
1470         }
1471 
1472         // Approximate cap-cap·(1-1/D)^n using the Binomial expansion
1473         // http://galileo.phys.virginia.edu/classes/152.mf1i.spring02/Exponential_Function.htm
1474         // Function[imax, -CAP*Sum[(-IR*EUR/CAP)^i/Factorial[i], {i, imax}]]
1475         // which may be simplified to
1476         // Function[imax, -CAP*Sum[(EUR)^i/(Factorial[i]*(-d)^i), {i, 1, imax}]]
1477         // where d = cap/initial_reward
1478         uint256 d = 230769230769230769230769231; // NEUMARK_CAP / INITIAL_REWARD_FRACTION
1479         uint256 term = NEUMARK_CAP;
1480         uint256 sum = 0;
1481         uint256 denom = d;
1482         do assembly {
1483             // We use assembler primarily to avoid the expensive
1484             // divide-by-zero check solc inserts for the / operator.
1485             term  := div(mul(term, euroUlps), denom)
1486             sum   := add(sum, term)
1487             denom := add(denom, d)
1488             // sub next term as we have power of negative value in the binomial expansion
1489             term  := div(mul(term, euroUlps), denom)
1490             sum   := sub(sum, term)
1491             denom := add(denom, d)
1492         } while (term != 0);
1493         return sum;
1494     }
1495 
1496     /// @notice find issuance curve inverse by binary search
1497     /// @param neumarkUlps neumark amount to compute inverse for
1498     /// @param minEurUlps minimum search range for the inverse, inclusive
1499     /// @param maxEurUlps maxium search range for the inverse, inclusive
1500     /// @dev in case of approximate search (no exact inverse) upper element of minimal search range is returned
1501     /// @dev in case of many possible inverses, the lowest one will be used (if range permits)
1502     /// @dev corresponds to a linear search that returns first euroUlp value that has cumulative() equal or greater than neumarkUlps
1503     function cumulativeInverse(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
1504         public
1505         pure
1506         returns (uint256 euroUlps)
1507     {
1508         require(maxEurUlps >= minEurUlps);
1509         require(cumulative(minEurUlps) <= neumarkUlps);
1510         require(cumulative(maxEurUlps) >= neumarkUlps);
1511         uint256 min = minEurUlps;
1512         uint256 max = maxEurUlps;
1513 
1514         // Binary search
1515         while (max > min) {
1516             uint256 mid = (max + min) / 2;
1517             uint256 val = cumulative(mid);
1518             // exact solution should not be used, a late points of the curve when many euroUlps are needed to
1519             // increase by one nmkUlp this will lead to  "indeterministic" inverse values that depend on the initial min and max
1520             // and further binary division -> you can land at any of the euro value that is mapped to the same nmk value
1521             // with condition below removed, binary search will point to the lowest eur value possible which is good because it cannot be exploited even with 0 gas costs
1522             /* if (val == neumarkUlps) {
1523                 return mid;
1524             }*/
1525             // NOTE: approximate search (no inverse) must return upper element of the final range
1526             //  last step of approximate search is always (min, min+1) so new mid is (2*min+1)/2 => min
1527             //  so new min = mid + 1 = max which was upper range. and that ends the search
1528             // NOTE: when there are multiple inverses for the same neumarkUlps, the `max` will be dragged down
1529             //  by `max = mid` expression to the lowest eur value of inverse. works only for ranges that cover all points of multiple inverse
1530             if (val < neumarkUlps) {
1531                 min = mid + 1;
1532             } else {
1533                 max = mid;
1534             }
1535         }
1536         // NOTE: It is possible that there is no inverse
1537         //  for example curve(0) = 0 and curve(1) = 6, so
1538         //  there is no value y such that curve(y) = 5.
1539         //  When there is no inverse, we must return upper element of last search range.
1540         //  This has the effect of reversing the curve less when
1541         //  burning Neumarks. This ensures that Neumarks can always
1542         //  be burned. It also ensure that the total supply of Neumarks
1543         //  remains below the cap.
1544         return max;
1545     }
1546 
1547     function neumarkCap()
1548         public
1549         pure
1550         returns (uint256)
1551     {
1552         return NEUMARK_CAP;
1553     }
1554 
1555     function initialRewardFraction()
1556         public
1557         pure
1558         returns (uint256)
1559     {
1560         return INITIAL_REWARD_FRACTION;
1561     }
1562 }
1563 
1564 /// @title allows deriving contract to recover any token or ether that it has balance of
1565 /// @notice note that this opens your contracts to claims from various people saying they lost tokens and they want them back
1566 ///     be ready to handle such claims
1567 /// @dev use with care!
1568 ///     1. ROLE_RECLAIMER is allowed to claim tokens, it's not returning tokens to original owner
1569 ///     2. in derived contract that holds any token by design you must override `reclaim` and block such possibility.
1570 ///         see ICBMLockedAccount as an example
1571 contract Reclaimable is AccessControlled, AccessRoles {
1572 
1573     ////////////////////////
1574     // Constants
1575     ////////////////////////
1576 
1577     IBasicToken constant internal RECLAIM_ETHER = IBasicToken(0x0);
1578 
1579     ////////////////////////
1580     // Public functions
1581     ////////////////////////
1582 
1583     function reclaim(IBasicToken token)
1584         public
1585         only(ROLE_RECLAIMER)
1586     {
1587         address reclaimer = msg.sender;
1588         if(token == RECLAIM_ETHER) {
1589             reclaimer.transfer(address(this).balance);
1590         } else {
1591             uint256 balance = token.balanceOf(this);
1592             require(token.transfer(reclaimer, balance));
1593         }
1594     }
1595 }
1596 
1597 /// @title advances snapshot id on demand
1598 /// @dev see Snapshot folder for implementation examples ie. DailyAndSnapshotable contract
1599 contract ISnapshotable {
1600 
1601     ////////////////////////
1602     // Events
1603     ////////////////////////
1604 
1605     /// @dev should log each new snapshot id created, including snapshots created automatically via MSnapshotPolicy
1606     event LogSnapshotCreated(uint256 snapshotId);
1607 
1608     ////////////////////////
1609     // Public functions
1610     ////////////////////////
1611 
1612     /// always creates new snapshot id which gets returned
1613     /// however, there is no guarantee that any snapshot will be created with this id, this depends on the implementation of MSnaphotPolicy
1614     function createSnapshot()
1615         public
1616         returns (uint256);
1617 
1618     /// upper bound of series snapshotIds for which there's a value
1619     function currentSnapshotId()
1620         public
1621         constant
1622         returns (uint256);
1623 }
1624 
1625 /// @title Abstracts snapshot id creation logics
1626 /// @dev Mixin (internal interface) of the snapshot policy which abstracts snapshot id creation logics from Snapshot contract
1627 /// @dev to be implemented and such implementation should be mixed with Snapshot-derived contract, see EveryBlock for simplest example of implementation and StandardSnapshotToken
1628 contract MSnapshotPolicy {
1629 
1630     ////////////////////////
1631     // Internal functions
1632     ////////////////////////
1633 
1634     // The snapshot Ids need to be strictly increasing.
1635     // Whenever the snaspshot id changes, a new snapshot will be created.
1636     // As long as the same snapshot id is being returned, last snapshot will be updated as this indicates that snapshot id didn't change
1637     //
1638     // Values passed to `hasValueAt` and `valuteAt` are required
1639     // to be less or equal to `mCurrentSnapshotId()`.
1640     function mAdvanceSnapshotId()
1641         internal
1642         returns (uint256);
1643 
1644     // this is a version of mAdvanceSnapshotId that does not modify state but MUST return the same value
1645     // it is required to implement ITokenSnapshots interface cleanly
1646     function mCurrentSnapshotId()
1647         internal
1648         constant
1649         returns (uint256);
1650 
1651 }
1652 
1653 /// @title creates new snapshot id on each day boundary
1654 /// @dev snapshot id is unix timestamp of current day boundary
1655 contract Daily is MSnapshotPolicy {
1656 
1657     ////////////////////////
1658     // Constants
1659     ////////////////////////
1660 
1661     // Floor[2**128 / 1 days]
1662     uint256 private MAX_TIMESTAMP = 3938453320844195178974243141571391;
1663 
1664     ////////////////////////
1665     // Constructor
1666     ////////////////////////
1667 
1668     /// @param start snapshotId from which to start generating values, used to prevent cloning from incompatible schemes
1669     /// @dev start must be for the same day or 0, required for token cloning
1670     constructor(uint256 start) internal {
1671         // 0 is invalid value as we are past unix epoch
1672         if (start > 0) {
1673             uint256 base = dayBase(uint128(block.timestamp));
1674             // must be within current day base
1675             require(start >= base);
1676             // dayBase + 2**128 will not overflow as it is based on block.timestamp
1677             require(start < base + 2**128);
1678         }
1679     }
1680 
1681     ////////////////////////
1682     // Public functions
1683     ////////////////////////
1684 
1685     function snapshotAt(uint256 timestamp)
1686         public
1687         constant
1688         returns (uint256)
1689     {
1690         require(timestamp < MAX_TIMESTAMP);
1691 
1692         return dayBase(uint128(timestamp));
1693     }
1694 
1695     ////////////////////////
1696     // Internal functions
1697     ////////////////////////
1698 
1699     //
1700     // Implements MSnapshotPolicy
1701     //
1702 
1703     function mAdvanceSnapshotId()
1704         internal
1705         returns (uint256)
1706     {
1707         return mCurrentSnapshotId();
1708     }
1709 
1710     function mCurrentSnapshotId()
1711         internal
1712         constant
1713         returns (uint256)
1714     {
1715         // disregard overflows on block.timestamp, see MAX_TIMESTAMP
1716         return dayBase(uint128(block.timestamp));
1717     }
1718 
1719     function dayBase(uint128 timestamp)
1720         internal
1721         pure
1722         returns (uint256)
1723     {
1724         // Round down to the start of the day (00:00 UTC) and place in higher 128bits
1725         return 2**128 * (uint256(timestamp) / 1 days);
1726     }
1727 }
1728 
1729 /// @title creates snapshot id on each day boundary and allows to create additional snapshots within a given day
1730 /// @dev snapshots are encoded in single uint256, where high 128 bits represents a day number (from unix epoch) and low 128 bits represents additional snapshots within given day create via ISnapshotable
1731 contract DailyAndSnapshotable is
1732     Daily,
1733     ISnapshotable
1734 {
1735 
1736     ////////////////////////
1737     // Mutable state
1738     ////////////////////////
1739 
1740     uint256 private _currentSnapshotId;
1741 
1742     ////////////////////////
1743     // Constructor
1744     ////////////////////////
1745 
1746     /// @param start snapshotId from which to start generating values
1747     /// @dev start must be for the same day or 0, required for token cloning
1748     constructor(uint256 start)
1749         internal
1750         Daily(start)
1751     {
1752         if (start > 0) {
1753             _currentSnapshotId = start;
1754         }
1755     }
1756 
1757     ////////////////////////
1758     // Public functions
1759     ////////////////////////
1760 
1761     //
1762     // Implements ISnapshotable
1763     //
1764 
1765     function createSnapshot()
1766         public
1767         returns (uint256)
1768     {
1769         uint256 base = dayBase(uint128(block.timestamp));
1770 
1771         if (base > _currentSnapshotId) {
1772             // New day has started, create snapshot for midnight
1773             _currentSnapshotId = base;
1774         } else {
1775             // within single day, increase counter (assume 2**128 will not be crossed)
1776             _currentSnapshotId += 1;
1777         }
1778 
1779         // Log and return
1780         emit LogSnapshotCreated(_currentSnapshotId);
1781         return _currentSnapshotId;
1782     }
1783 
1784     ////////////////////////
1785     // Internal functions
1786     ////////////////////////
1787 
1788     //
1789     // Implements MSnapshotPolicy
1790     //
1791 
1792     function mAdvanceSnapshotId()
1793         internal
1794         returns (uint256)
1795     {
1796         uint256 base = dayBase(uint128(block.timestamp));
1797 
1798         // New day has started
1799         if (base > _currentSnapshotId) {
1800             _currentSnapshotId = base;
1801             emit LogSnapshotCreated(base);
1802         }
1803 
1804         return _currentSnapshotId;
1805     }
1806 
1807     function mCurrentSnapshotId()
1808         internal
1809         constant
1810         returns (uint256)
1811     {
1812         uint256 base = dayBase(uint128(block.timestamp));
1813 
1814         return base > _currentSnapshotId ? base : _currentSnapshotId;
1815     }
1816 }
1817 
1818 /// @title adds token metadata to token contract
1819 /// @dev see Neumark for example implementation
1820 contract TokenMetadata is ITokenMetadata {
1821 
1822     ////////////////////////
1823     // Immutable state
1824     ////////////////////////
1825 
1826     // The Token's name: e.g. DigixDAO Tokens
1827     string private NAME;
1828 
1829     // An identifier: e.g. REP
1830     string private SYMBOL;
1831 
1832     // Number of decimals of the smallest unit
1833     uint8 private DECIMALS;
1834 
1835     // An arbitrary versioning scheme
1836     string private VERSION;
1837 
1838     ////////////////////////
1839     // Constructor
1840     ////////////////////////
1841 
1842     /// @notice Constructor to set metadata
1843     /// @param tokenName Name of the new token
1844     /// @param decimalUnits Number of decimals of the new token
1845     /// @param tokenSymbol Token Symbol for the new token
1846     /// @param version Token version ie. when cloning is used
1847     constructor(
1848         string tokenName,
1849         uint8 decimalUnits,
1850         string tokenSymbol,
1851         string version
1852     )
1853         public
1854     {
1855         NAME = tokenName;                                 // Set the name
1856         SYMBOL = tokenSymbol;                             // Set the symbol
1857         DECIMALS = decimalUnits;                          // Set the decimals
1858         VERSION = version;
1859     }
1860 
1861     ////////////////////////
1862     // Public functions
1863     ////////////////////////
1864 
1865     function name()
1866         public
1867         constant
1868         returns (string)
1869     {
1870         return NAME;
1871     }
1872 
1873     function symbol()
1874         public
1875         constant
1876         returns (string)
1877     {
1878         return SYMBOL;
1879     }
1880 
1881     function decimals()
1882         public
1883         constant
1884         returns (uint8)
1885     {
1886         return DECIMALS;
1887     }
1888 
1889     function version()
1890         public
1891         constant
1892         returns (string)
1893     {
1894         return VERSION;
1895     }
1896 }
1897 
1898 /// @title controls spending approvals
1899 /// @dev TokenAllowance observes this interface, Neumark contract implements it
1900 contract MTokenAllowanceController {
1901 
1902     ////////////////////////
1903     // Internal functions
1904     ////////////////////////
1905 
1906     /// @notice Notifies the controller about an approval allowing the
1907     ///  controller to react if desired
1908     /// @param owner The address that calls `approve()`
1909     /// @param spender The spender in the `approve()` call
1910     /// @param amount The amount in the `approve()` call
1911     /// @return False if the controller does not authorize the approval
1912     function mOnApprove(
1913         address owner,
1914         address spender,
1915         uint256 amount
1916     )
1917         internal
1918         returns (bool allow);
1919 
1920     /// @notice Allows to override allowance approved by the owner
1921     ///         Primary role is to enable forced transfers, do not override if you do not like it
1922     ///         Following behavior is expected in the observer
1923     ///         approve() - should revert if mAllowanceOverride() > 0
1924     ///         allowance() - should return mAllowanceOverride() if set
1925     ///         transferFrom() - should override allowance if mAllowanceOverride() > 0
1926     /// @param owner An address giving allowance to spender
1927     /// @param spender An address getting  a right to transfer allowance amount from the owner
1928     /// @return current allowance amount
1929     function mAllowanceOverride(
1930         address owner,
1931         address spender
1932     )
1933         internal
1934         constant
1935         returns (uint256 allowance);
1936 }
1937 
1938 /// @title controls token transfers
1939 /// @dev BasicSnapshotToken observes this interface, Neumark contract implements it
1940 contract MTokenTransferController {
1941 
1942     ////////////////////////
1943     // Internal functions
1944     ////////////////////////
1945 
1946     /// @notice Notifies the controller about a token transfer allowing the
1947     ///  controller to react if desired
1948     /// @param from The origin of the transfer
1949     /// @param to The destination of the transfer
1950     /// @param amount The amount of the transfer
1951     /// @return False if the controller does not authorize the transfer
1952     function mOnTransfer(
1953         address from,
1954         address to,
1955         uint256 amount
1956     )
1957         internal
1958         returns (bool allow);
1959 
1960 }
1961 
1962 /// @title controls approvals and transfers
1963 /// @dev The token controller contract must implement these functions, see Neumark as example
1964 /// @dev please note that controller may be a separate contract that is called from mOnTransfer and mOnApprove functions
1965 contract MTokenController is MTokenTransferController, MTokenAllowanceController {
1966 }
1967 
1968 /// @title internal token transfer function
1969 /// @dev see BasicSnapshotToken for implementation
1970 contract MTokenTransfer {
1971 
1972     ////////////////////////
1973     // Internal functions
1974     ////////////////////////
1975 
1976     /// @dev This is the actual transfer function in the token contract, it can
1977     ///  only be called by other functions in this contract.
1978     /// @param from The address holding the tokens being transferred
1979     /// @param to The address of the recipient
1980     /// @param amount The amount of tokens to be transferred
1981     /// @dev  reverts if transfer was not successful
1982     function mTransfer(
1983         address from,
1984         address to,
1985         uint256 amount
1986     )
1987         internal;
1988 }
1989 
1990 contract IERC677Callback {
1991 
1992     ////////////////////////
1993     // Public functions
1994     ////////////////////////
1995 
1996     // NOTE: This call can be initiated by anyone. You need to make sure that
1997     // it is send by the token (`require(msg.sender == token)`) or make sure
1998     // amount is valid (`require(token.allowance(this) >= amount)`).
1999     function receiveApproval(
2000         address from,
2001         uint256 amount,
2002         address token, // IERC667Token
2003         bytes data
2004     )
2005         public
2006         returns (bool success);
2007 
2008 }
2009 
2010 /// @title token spending approval and transfer
2011 /// @dev implements token approval and transfers and exposes relevant part of ERC20 and ERC677 approveAndCall
2012 ///     may be mixed in with any basic token (implementing mTransfer) like BasicSnapshotToken or MintableSnapshotToken to add approval mechanism
2013 ///     observes MTokenAllowanceController interface
2014 ///     observes MTokenTransfer
2015 contract TokenAllowance is
2016     MTokenTransfer,
2017     MTokenAllowanceController,
2018     IERC20Allowance,
2019     IERC677Token
2020 {
2021 
2022     ////////////////////////
2023     // Mutable state
2024     ////////////////////////
2025 
2026     // `allowed` tracks rights to spends others tokens as per ERC20
2027     // owner => spender => amount
2028     mapping (address => mapping (address => uint256)) private _allowed;
2029 
2030     ////////////////////////
2031     // Constructor
2032     ////////////////////////
2033 
2034     constructor()
2035         internal
2036     {
2037     }
2038 
2039     ////////////////////////
2040     // Public functions
2041     ////////////////////////
2042 
2043     //
2044     // Implements IERC20Token
2045     //
2046 
2047     /// @dev This function makes it easy to read the `allowed[]` map
2048     /// @param owner The address of the account that owns the token
2049     /// @param spender The address of the account able to transfer the tokens
2050     /// @return Amount of remaining tokens of _owner that _spender is allowed
2051     ///  to spend
2052     function allowance(address owner, address spender)
2053         public
2054         constant
2055         returns (uint256 remaining)
2056     {
2057         uint256 override = mAllowanceOverride(owner, spender);
2058         if (override > 0) {
2059             return override;
2060         }
2061         return _allowed[owner][spender];
2062     }
2063 
2064     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
2065     ///  its behalf. This is a modified version of the ERC20 approve function
2066     ///  where allowance per spender must be 0 to allow change of such allowance
2067     /// @param spender The address of the account able to transfer the tokens
2068     /// @param amount The amount of tokens to be approved for transfer
2069     /// @return True or reverts, False is never returned
2070     function approve(address spender, uint256 amount)
2071         public
2072         returns (bool success)
2073     {
2074         // Alerts the token controller of the approve function call
2075         require(mOnApprove(msg.sender, spender, amount));
2076 
2077         // To change the approve amount you first have to reduce the addresses`
2078         //  allowance to zero by calling `approve(_spender,0)` if it is not
2079         //  already 0 to mitigate the race condition described here:
2080         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2081         require((amount == 0 || _allowed[msg.sender][spender] == 0) && mAllowanceOverride(msg.sender, spender) == 0);
2082 
2083         _allowed[msg.sender][spender] = amount;
2084         emit Approval(msg.sender, spender, amount);
2085         return true;
2086     }
2087 
2088     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
2089     ///  is approved by `_from`
2090     /// @param from The address holding the tokens being transferred
2091     /// @param to The address of the recipient
2092     /// @param amount The amount of tokens to be transferred
2093     /// @return True if the transfer was successful, reverts in any other case
2094     function transferFrom(address from, address to, uint256 amount)
2095         public
2096         returns (bool success)
2097     {
2098         uint256 allowed = mAllowanceOverride(from, msg.sender);
2099         if (allowed == 0) {
2100             // The standard ERC 20 transferFrom functionality
2101             allowed = _allowed[from][msg.sender];
2102             // yes this will underflow but then we'll revert. will cost gas however so don't underflow
2103             _allowed[from][msg.sender] -= amount;
2104         }
2105         require(allowed >= amount);
2106         mTransfer(from, to, amount);
2107         return true;
2108     }
2109 
2110     //
2111     // Implements IERC677Token
2112     //
2113 
2114     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
2115     ///  its behalf, and then a function is triggered in the contract that is
2116     ///  being approved, `_spender`. This allows users to use their tokens to
2117     ///  interact with contracts in one function call instead of two
2118     /// @param spender The address of the contract able to transfer the tokens
2119     /// @param amount The amount of tokens to be approved for transfer
2120     /// @return True or reverts, False is never returned
2121     function approveAndCall(
2122         address spender,
2123         uint256 amount,
2124         bytes extraData
2125     )
2126         public
2127         returns (bool success)
2128     {
2129         require(approve(spender, amount));
2130 
2131         success = IERC677Callback(spender).receiveApproval(
2132             msg.sender,
2133             amount,
2134             this,
2135             extraData
2136         );
2137         require(success);
2138 
2139         return true;
2140     }
2141 
2142     ////////////////////////
2143     // Internal functions
2144     ////////////////////////
2145 
2146     //
2147     // Implements default MTokenAllowanceController
2148     //
2149 
2150     // no override in default implementation
2151     function mAllowanceOverride(
2152         address /*owner*/,
2153         address /*spender*/
2154     )
2155         internal
2156         constant
2157         returns (uint256)
2158     {
2159         return 0;
2160     }
2161 }
2162 
2163 /// @title Reads and writes snapshots
2164 /// @dev Manages reading and writing a series of values, where each value has assigned a snapshot id for access to historical data
2165 /// @dev may be added to any contract to provide snapshotting mechanism. should be mixed in with any of MSnapshotPolicy implementations to customize snapshot creation mechanics
2166 ///     observes MSnapshotPolicy
2167 /// based on MiniMe token
2168 contract Snapshot is MSnapshotPolicy {
2169 
2170     ////////////////////////
2171     // Types
2172     ////////////////////////
2173 
2174     /// @dev `Values` is the structure that attaches a snapshot id to a
2175     ///  given value, the snapshot id attached is the one that last changed the
2176     ///  value
2177     struct Values {
2178 
2179         // `snapshotId` is the snapshot id that the value was generated at
2180         uint256 snapshotId;
2181 
2182         // `value` at a specific snapshot id
2183         uint256 value;
2184     }
2185 
2186     ////////////////////////
2187     // Internal functions
2188     ////////////////////////
2189 
2190     function hasValue(
2191         Values[] storage values
2192     )
2193         internal
2194         constant
2195         returns (bool)
2196     {
2197         return values.length > 0;
2198     }
2199 
2200     /// @dev makes sure that 'snapshotId' between current snapshot id (mCurrentSnapshotId) and first snapshot id. this guarantees that getValueAt returns value from one of the snapshots.
2201     function hasValueAt(
2202         Values[] storage values,
2203         uint256 snapshotId
2204     )
2205         internal
2206         constant
2207         returns (bool)
2208     {
2209         require(snapshotId <= mCurrentSnapshotId());
2210         return values.length > 0 && values[0].snapshotId <= snapshotId;
2211     }
2212 
2213     /// gets last value in the series
2214     function getValue(
2215         Values[] storage values,
2216         uint256 defaultValue
2217     )
2218         internal
2219         constant
2220         returns (uint256)
2221     {
2222         if (values.length == 0) {
2223             return defaultValue;
2224         } else {
2225             uint256 last = values.length - 1;
2226             return values[last].value;
2227         }
2228     }
2229 
2230     /// @dev `getValueAt` retrieves value at a given snapshot id
2231     /// @param values The series of values being queried
2232     /// @param snapshotId Snapshot id to retrieve the value at
2233     /// @return Value in series being queried
2234     function getValueAt(
2235         Values[] storage values,
2236         uint256 snapshotId,
2237         uint256 defaultValue
2238     )
2239         internal
2240         constant
2241         returns (uint256)
2242     {
2243         require(snapshotId <= mCurrentSnapshotId());
2244 
2245         // Empty value
2246         if (values.length == 0) {
2247             return defaultValue;
2248         }
2249 
2250         // Shortcut for the out of bounds snapshots
2251         uint256 last = values.length - 1;
2252         uint256 lastSnapshot = values[last].snapshotId;
2253         if (snapshotId >= lastSnapshot) {
2254             return values[last].value;
2255         }
2256         uint256 firstSnapshot = values[0].snapshotId;
2257         if (snapshotId < firstSnapshot) {
2258             return defaultValue;
2259         }
2260         // Binary search of the value in the array
2261         uint256 min = 0;
2262         uint256 max = last;
2263         while (max > min) {
2264             uint256 mid = (max + min + 1) / 2;
2265             // must always return lower indice for approximate searches
2266             if (values[mid].snapshotId <= snapshotId) {
2267                 min = mid;
2268             } else {
2269                 max = mid - 1;
2270             }
2271         }
2272         return values[min].value;
2273     }
2274 
2275     /// @dev `setValue` used to update sequence at next snapshot
2276     /// @param values The sequence being updated
2277     /// @param value The new last value of sequence
2278     function setValue(
2279         Values[] storage values,
2280         uint256 value
2281     )
2282         internal
2283     {
2284         // TODO: simplify or break into smaller functions
2285 
2286         uint256 currentSnapshotId = mAdvanceSnapshotId();
2287         // Always create a new entry if there currently is no value
2288         bool empty = values.length == 0;
2289         if (empty) {
2290             // Create a new entry
2291             values.push(
2292                 Values({
2293                     snapshotId: currentSnapshotId,
2294                     value: value
2295                 })
2296             );
2297             return;
2298         }
2299 
2300         uint256 last = values.length - 1;
2301         bool hasNewSnapshot = values[last].snapshotId < currentSnapshotId;
2302         if (hasNewSnapshot) {
2303 
2304             // Do nothing if the value was not modified
2305             bool unmodified = values[last].value == value;
2306             if (unmodified) {
2307                 return;
2308             }
2309 
2310             // Create new entry
2311             values.push(
2312                 Values({
2313                     snapshotId: currentSnapshotId,
2314                     value: value
2315                 })
2316             );
2317         } else {
2318 
2319             // We are updating the currentSnapshotId
2320             bool previousUnmodified = last > 0 && values[last - 1].value == value;
2321             if (previousUnmodified) {
2322                 // Remove current snapshot if current value was set to previous value
2323                 delete values[last];
2324                 values.length--;
2325                 return;
2326             }
2327 
2328             // Overwrite next snapshot entry
2329             values[last].value = value;
2330         }
2331     }
2332 }
2333 
2334 /// @title token with snapshots and transfer functionality
2335 /// @dev observes MTokenTransferController interface
2336 ///     observes ISnapshotToken interface
2337 ///     implementes MTokenTransfer interface
2338 contract BasicSnapshotToken is
2339     MTokenTransfer,
2340     MTokenTransferController,
2341     IClonedTokenParent,
2342     IBasicToken,
2343     Snapshot
2344 {
2345     ////////////////////////
2346     // Immutable state
2347     ////////////////////////
2348 
2349     // `PARENT_TOKEN` is the Token address that was cloned to produce this token;
2350     //  it will be 0x0 for a token that was not cloned
2351     IClonedTokenParent private PARENT_TOKEN;
2352 
2353     // `PARENT_SNAPSHOT_ID` is the snapshot id from the Parent Token that was
2354     //  used to determine the initial distribution of the cloned token
2355     uint256 private PARENT_SNAPSHOT_ID;
2356 
2357     ////////////////////////
2358     // Mutable state
2359     ////////////////////////
2360 
2361     // `balances` is the map that tracks the balance of each address, in this
2362     //  contract when the balance changes the snapshot id that the change
2363     //  occurred is also included in the map
2364     mapping (address => Values[]) internal _balances;
2365 
2366     // Tracks the history of the `totalSupply` of the token
2367     Values[] internal _totalSupplyValues;
2368 
2369     ////////////////////////
2370     // Constructor
2371     ////////////////////////
2372 
2373     /// @notice Constructor to create snapshot token
2374     /// @param parentToken Address of the parent token, set to 0x0 if it is a
2375     ///  new token
2376     /// @param parentSnapshotId at which snapshot id clone was created, set to 0 to clone at upper bound
2377     /// @dev please not that as long as cloned token does not overwrite value at current snapshot id, it will refer
2378     ///     to parent token at which this snapshot still may change until snapshot id increases. for that time tokens are coupled
2379     ///     this is prevented by parentSnapshotId value of parentToken.currentSnapshotId() - 1 being the maxiumum
2380     ///     see SnapshotToken.js test to learn consequences coupling has.
2381     constructor(
2382         IClonedTokenParent parentToken,
2383         uint256 parentSnapshotId
2384     )
2385         Snapshot()
2386         internal
2387     {
2388         PARENT_TOKEN = parentToken;
2389         if (parentToken == address(0)) {
2390             require(parentSnapshotId == 0);
2391         } else {
2392             if (parentSnapshotId == 0) {
2393                 require(parentToken.currentSnapshotId() > 0);
2394                 PARENT_SNAPSHOT_ID = parentToken.currentSnapshotId() - 1;
2395             } else {
2396                 PARENT_SNAPSHOT_ID = parentSnapshotId;
2397             }
2398         }
2399     }
2400 
2401     ////////////////////////
2402     // Public functions
2403     ////////////////////////
2404 
2405     //
2406     // Implements IBasicToken
2407     //
2408 
2409     /// @dev This function makes it easy to get the total number of tokens
2410     /// @return The total number of tokens
2411     function totalSupply()
2412         public
2413         constant
2414         returns (uint256)
2415     {
2416         return totalSupplyAtInternal(mCurrentSnapshotId());
2417     }
2418 
2419     /// @param owner The address that's balance is being requested
2420     /// @return The balance of `owner` at the current block
2421     function balanceOf(address owner)
2422         public
2423         constant
2424         returns (uint256 balance)
2425     {
2426         return balanceOfAtInternal(owner, mCurrentSnapshotId());
2427     }
2428 
2429     /// @notice Send `amount` tokens to `to` from `msg.sender`
2430     /// @param to The address of the recipient
2431     /// @param amount The amount of tokens to be transferred
2432     /// @return True if the transfer was successful, reverts in any other case
2433     function transfer(address to, uint256 amount)
2434         public
2435         returns (bool success)
2436     {
2437         mTransfer(msg.sender, to, amount);
2438         return true;
2439     }
2440 
2441     //
2442     // Implements ITokenSnapshots
2443     //
2444 
2445     function totalSupplyAt(uint256 snapshotId)
2446         public
2447         constant
2448         returns(uint256)
2449     {
2450         return totalSupplyAtInternal(snapshotId);
2451     }
2452 
2453     function balanceOfAt(address owner, uint256 snapshotId)
2454         public
2455         constant
2456         returns (uint256)
2457     {
2458         return balanceOfAtInternal(owner, snapshotId);
2459     }
2460 
2461     function currentSnapshotId()
2462         public
2463         constant
2464         returns (uint256)
2465     {
2466         return mCurrentSnapshotId();
2467     }
2468 
2469     //
2470     // Implements IClonedTokenParent
2471     //
2472 
2473     function parentToken()
2474         public
2475         constant
2476         returns(IClonedTokenParent parent)
2477     {
2478         return PARENT_TOKEN;
2479     }
2480 
2481     /// @return snapshot at wchich initial token distribution was taken
2482     function parentSnapshotId()
2483         public
2484         constant
2485         returns(uint256 snapshotId)
2486     {
2487         return PARENT_SNAPSHOT_ID;
2488     }
2489 
2490     //
2491     // Other public functions
2492     //
2493 
2494     /// @notice gets all token balances of 'owner'
2495     /// @dev intended to be called via eth_call where gas limit is not an issue
2496     function allBalancesOf(address owner)
2497         external
2498         constant
2499         returns (uint256[2][])
2500     {
2501         /* very nice and working implementation below,
2502         // copy to memory
2503         Values[] memory values = _balances[owner];
2504         do assembly {
2505             // in memory structs have simple layout where every item occupies uint256
2506             balances := values
2507         } while (false);*/
2508 
2509         Values[] storage values = _balances[owner];
2510         uint256[2][] memory balances = new uint256[2][](values.length);
2511         for(uint256 ii = 0; ii < values.length; ++ii) {
2512             balances[ii] = [values[ii].snapshotId, values[ii].value];
2513         }
2514 
2515         return balances;
2516     }
2517 
2518     ////////////////////////
2519     // Internal functions
2520     ////////////////////////
2521 
2522     function totalSupplyAtInternal(uint256 snapshotId)
2523         internal
2524         constant
2525         returns(uint256)
2526     {
2527         Values[] storage values = _totalSupplyValues;
2528 
2529         // If there is a value, return it, reverts if value is in the future
2530         if (hasValueAt(values, snapshotId)) {
2531             return getValueAt(values, snapshotId, 0);
2532         }
2533 
2534         // Try parent contract at or before the fork
2535         if (address(PARENT_TOKEN) != 0) {
2536             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
2537             return PARENT_TOKEN.totalSupplyAt(earlierSnapshotId);
2538         }
2539 
2540         // Default to an empty balance
2541         return 0;
2542     }
2543 
2544     // get balance at snapshot if with continuation in parent token
2545     function balanceOfAtInternal(address owner, uint256 snapshotId)
2546         internal
2547         constant
2548         returns (uint256)
2549     {
2550         Values[] storage values = _balances[owner];
2551 
2552         // If there is a value, return it, reverts if value is in the future
2553         if (hasValueAt(values, snapshotId)) {
2554             return getValueAt(values, snapshotId, 0);
2555         }
2556 
2557         // Try parent contract at or before the fork
2558         if (PARENT_TOKEN != address(0)) {
2559             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
2560             return PARENT_TOKEN.balanceOfAt(owner, earlierSnapshotId);
2561         }
2562 
2563         // Default to an empty balance
2564         return 0;
2565     }
2566 
2567     //
2568     // Implements MTokenTransfer
2569     //
2570 
2571     /// @dev This is the actual transfer function in the token contract, it can
2572     ///  only be called by other functions in this contract.
2573     /// @param from The address holding the tokens being transferred
2574     /// @param to The address of the recipient
2575     /// @param amount The amount of tokens to be transferred
2576     /// @return True if the transfer was successful, reverts in any other case
2577     function mTransfer(
2578         address from,
2579         address to,
2580         uint256 amount
2581     )
2582         internal
2583     {
2584         // never send to address 0
2585         require(to != address(0));
2586         // block transfers in clone that points to future/current snapshots of parent token
2587         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2588         // Alerts the token controller of the transfer
2589         require(mOnTransfer(from, to, amount));
2590 
2591         // If the amount being transfered is more than the balance of the
2592         //  account the transfer reverts
2593         uint256 previousBalanceFrom = balanceOf(from);
2594         require(previousBalanceFrom >= amount);
2595 
2596         // First update the balance array with the new value for the address
2597         //  sending the tokens
2598         uint256 newBalanceFrom = previousBalanceFrom - amount;
2599         setValue(_balances[from], newBalanceFrom);
2600 
2601         // Then update the balance array with the new value for the address
2602         //  receiving the tokens
2603         uint256 previousBalanceTo = balanceOf(to);
2604         uint256 newBalanceTo = previousBalanceTo + amount;
2605         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
2606         setValue(_balances[to], newBalanceTo);
2607 
2608         // An event to make the transfer easy to find on the blockchain
2609         emit Transfer(from, to, amount);
2610     }
2611 }
2612 
2613 /// @title token generation and destruction
2614 /// @dev internal interface providing token generation and destruction, see MintableSnapshotToken for implementation
2615 contract MTokenMint {
2616 
2617     ////////////////////////
2618     // Internal functions
2619     ////////////////////////
2620 
2621     /// @notice Generates `amount` tokens that are assigned to `owner`
2622     /// @param owner The address that will be assigned the new tokens
2623     /// @param amount The quantity of tokens generated
2624     /// @dev reverts if tokens could not be generated
2625     function mGenerateTokens(address owner, uint256 amount)
2626         internal;
2627 
2628     /// @notice Burns `amount` tokens from `owner`
2629     /// @param owner The address that will lose the tokens
2630     /// @param amount The quantity of tokens to burn
2631     /// @dev reverts if tokens could not be destroyed
2632     function mDestroyTokens(address owner, uint256 amount)
2633         internal;
2634 }
2635 
2636 /// @title basic snapshot token with facitilites to generate and destroy tokens
2637 /// @dev implementes MTokenMint, does not expose any public functions that create/destroy tokens
2638 contract MintableSnapshotToken is
2639     BasicSnapshotToken,
2640     MTokenMint
2641 {
2642 
2643     ////////////////////////
2644     // Constructor
2645     ////////////////////////
2646 
2647     /// @notice Constructor to create a MintableSnapshotToken
2648     /// @param parentToken Address of the parent token, set to 0x0 if it is a
2649     ///  new token
2650     constructor(
2651         IClonedTokenParent parentToken,
2652         uint256 parentSnapshotId
2653     )
2654         BasicSnapshotToken(parentToken, parentSnapshotId)
2655         internal
2656     {}
2657 
2658     /// @notice Generates `amount` tokens that are assigned to `owner`
2659     /// @param owner The address that will be assigned the new tokens
2660     /// @param amount The quantity of tokens generated
2661     function mGenerateTokens(address owner, uint256 amount)
2662         internal
2663     {
2664         // never create for address 0
2665         require(owner != address(0));
2666         // block changes in clone that points to future/current snapshots of patent token
2667         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2668 
2669         uint256 curTotalSupply = totalSupply();
2670         uint256 newTotalSupply = curTotalSupply + amount;
2671         require(newTotalSupply >= curTotalSupply); // Check for overflow
2672 
2673         uint256 previousBalanceTo = balanceOf(owner);
2674         uint256 newBalanceTo = previousBalanceTo + amount;
2675         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
2676 
2677         setValue(_totalSupplyValues, newTotalSupply);
2678         setValue(_balances[owner], newBalanceTo);
2679 
2680         emit Transfer(0, owner, amount);
2681     }
2682 
2683     /// @notice Burns `amount` tokens from `owner`
2684     /// @param owner The address that will lose the tokens
2685     /// @param amount The quantity of tokens to burn
2686     function mDestroyTokens(address owner, uint256 amount)
2687         internal
2688     {
2689         // block changes in clone that points to future/current snapshots of patent token
2690         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2691 
2692         uint256 curTotalSupply = totalSupply();
2693         require(curTotalSupply >= amount);
2694 
2695         uint256 previousBalanceFrom = balanceOf(owner);
2696         require(previousBalanceFrom >= amount);
2697 
2698         uint256 newTotalSupply = curTotalSupply - amount;
2699         uint256 newBalanceFrom = previousBalanceFrom - amount;
2700         setValue(_totalSupplyValues, newTotalSupply);
2701         setValue(_balances[owner], newBalanceFrom);
2702 
2703         emit Transfer(owner, 0, amount);
2704     }
2705 }
2706 
2707 /*
2708     Copyright 2016, Jordi Baylina
2709     Copyright 2017, Remco Bloemen, Marcin Rudolf
2710 
2711     This program is free software: you can redistribute it and/or modify
2712     it under the terms of the GNU General Public License as published by
2713     the Free Software Foundation, either version 3 of the License, or
2714     (at your option) any later version.
2715 
2716     This program is distributed in the hope that it will be useful,
2717     but WITHOUT ANY WARRANTY; without even the implied warranty of
2718     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2719     GNU General Public License for more details.
2720 
2721     You should have received a copy of the GNU General Public License
2722     along with this program.  If not, see <http://www.gnu.org/licenses/>.
2723  */
2724 /// @title StandardSnapshotToken Contract
2725 /// @author Jordi Baylina, Remco Bloemen, Marcin Rudolf
2726 /// @dev This token contract's goal is to make it easy for anyone to clone this
2727 ///  token using the token distribution at a given block, this will allow DAO's
2728 ///  and DApps to upgrade their features in a decentralized manner without
2729 ///  affecting the original token
2730 /// @dev It is ERC20 compliant, but still needs to under go further testing.
2731 /// @dev Various contracts are composed to provide required functionality of this token, different compositions are possible
2732 ///     MintableSnapshotToken provides transfer, miniting and snapshotting functions
2733 ///     TokenAllowance provides approve/transferFrom functions
2734 ///     TokenMetadata adds name, symbol and other token metadata
2735 /// @dev This token is still abstract, Snapshot, BasicSnapshotToken and TokenAllowance observe interfaces that must be implemented
2736 ///     MSnapshotPolicy - particular snapshot id creation mechanism
2737 ///     MTokenController - controlls approvals and transfers
2738 ///     see Neumark as an example
2739 /// @dev implements ERC223 token transfer
2740 contract StandardSnapshotToken is
2741     MintableSnapshotToken,
2742     TokenAllowance
2743 {
2744     ////////////////////////
2745     // Constructor
2746     ////////////////////////
2747 
2748     /// @notice Constructor to create a MiniMeToken
2749     ///  is a new token
2750     /// param tokenName Name of the new token
2751     /// param decimalUnits Number of decimals of the new token
2752     /// param tokenSymbol Token Symbol for the new token
2753     constructor(
2754         IClonedTokenParent parentToken,
2755         uint256 parentSnapshotId
2756     )
2757         MintableSnapshotToken(parentToken, parentSnapshotId)
2758         TokenAllowance()
2759         internal
2760     {}
2761 }
2762 
2763 /// @title old ERC223 callback function
2764 /// @dev as used in Neumark and ICBMEtherToken
2765 contract IERC223LegacyCallback {
2766 
2767     ////////////////////////
2768     // Public functions
2769     ////////////////////////
2770 
2771     function onTokenTransfer(address from, uint256 amount, bytes data)
2772         public;
2773 
2774 }
2775 
2776 contract Neumark is
2777     AccessControlled,
2778     AccessRoles,
2779     Agreement,
2780     DailyAndSnapshotable,
2781     StandardSnapshotToken,
2782     TokenMetadata,
2783     IERC223Token,
2784     NeumarkIssuanceCurve,
2785     Reclaimable,
2786     IsContract
2787 {
2788 
2789     ////////////////////////
2790     // Constants
2791     ////////////////////////
2792 
2793     string private constant TOKEN_NAME = "Neumark";
2794 
2795     uint8  private constant TOKEN_DECIMALS = 18;
2796 
2797     string private constant TOKEN_SYMBOL = "NEU";
2798 
2799     string private constant VERSION = "NMK_1.0";
2800 
2801     ////////////////////////
2802     // Mutable state
2803     ////////////////////////
2804 
2805     // disable transfers when Neumark is created
2806     bool private _transferEnabled = false;
2807 
2808     // at which point on curve new Neumarks will be created, see NeumarkIssuanceCurve contract
2809     // do not use to get total invested funds. see burn(). this is just a cache for expensive inverse function
2810     uint256 private _totalEurUlps;
2811 
2812     ////////////////////////
2813     // Events
2814     ////////////////////////
2815 
2816     event LogNeumarksIssued(
2817         address indexed owner,
2818         uint256 euroUlps,
2819         uint256 neumarkUlps
2820     );
2821 
2822     event LogNeumarksBurned(
2823         address indexed owner,
2824         uint256 euroUlps,
2825         uint256 neumarkUlps
2826     );
2827 
2828     ////////////////////////
2829     // Constructor
2830     ////////////////////////
2831 
2832     constructor(
2833         IAccessPolicy accessPolicy,
2834         IEthereumForkArbiter forkArbiter
2835     )
2836         AccessRoles()
2837         Agreement(accessPolicy, forkArbiter)
2838         StandardSnapshotToken(
2839             IClonedTokenParent(0x0),
2840             0
2841         )
2842         TokenMetadata(
2843             TOKEN_NAME,
2844             TOKEN_DECIMALS,
2845             TOKEN_SYMBOL,
2846             VERSION
2847         )
2848         DailyAndSnapshotable(0)
2849         NeumarkIssuanceCurve()
2850         Reclaimable()
2851         public
2852     {}
2853 
2854     ////////////////////////
2855     // Public functions
2856     ////////////////////////
2857 
2858     /// @notice issues new Neumarks to msg.sender with reward at current curve position
2859     ///     moves curve position by euroUlps
2860     ///     callable only by ROLE_NEUMARK_ISSUER
2861     function issueForEuro(uint256 euroUlps)
2862         public
2863         only(ROLE_NEUMARK_ISSUER)
2864         acceptAgreement(msg.sender)
2865         returns (uint256)
2866     {
2867         require(_totalEurUlps + euroUlps >= _totalEurUlps);
2868         uint256 neumarkUlps = incremental(_totalEurUlps, euroUlps);
2869         _totalEurUlps += euroUlps;
2870         mGenerateTokens(msg.sender, neumarkUlps);
2871         emit LogNeumarksIssued(msg.sender, euroUlps, neumarkUlps);
2872         return neumarkUlps;
2873     }
2874 
2875     /// @notice used by ROLE_NEUMARK_ISSUER to transer newly issued neumarks
2876     ///     typically to the investor and platform operator
2877     function distribute(address to, uint256 neumarkUlps)
2878         public
2879         only(ROLE_NEUMARK_ISSUER)
2880         acceptAgreement(to)
2881     {
2882         mTransfer(msg.sender, to, neumarkUlps);
2883     }
2884 
2885     /// @notice msg.sender can burn their Neumarks, curve is rolled back using inverse
2886     ///     curve. as a result cost of Neumark gets lower (reward is higher)
2887     function burn(uint256 neumarkUlps)
2888         public
2889         only(ROLE_NEUMARK_BURNER)
2890     {
2891         burnPrivate(neumarkUlps, 0, _totalEurUlps);
2892     }
2893 
2894     /// @notice executes as function above but allows to provide search range for low gas burning
2895     function burn(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2896         public
2897         only(ROLE_NEUMARK_BURNER)
2898     {
2899         burnPrivate(neumarkUlps, minEurUlps, maxEurUlps);
2900     }
2901 
2902     function enableTransfer(bool enabled)
2903         public
2904         only(ROLE_TRANSFER_ADMIN)
2905     {
2906         _transferEnabled = enabled;
2907     }
2908 
2909     function createSnapshot()
2910         public
2911         only(ROLE_SNAPSHOT_CREATOR)
2912         returns (uint256)
2913     {
2914         return DailyAndSnapshotable.createSnapshot();
2915     }
2916 
2917     function transferEnabled()
2918         public
2919         constant
2920         returns (bool)
2921     {
2922         return _transferEnabled;
2923     }
2924 
2925     function totalEuroUlps()
2926         public
2927         constant
2928         returns (uint256)
2929     {
2930         return _totalEurUlps;
2931     }
2932 
2933     function incremental(uint256 euroUlps)
2934         public
2935         constant
2936         returns (uint256 neumarkUlps)
2937     {
2938         return incremental(_totalEurUlps, euroUlps);
2939     }
2940 
2941     //
2942     // Implements IERC223Token with IERC223Callback (onTokenTransfer) callback
2943     //
2944 
2945     // old implementation of ERC223 that was actual when ICBM was deployed
2946     // as Neumark is already deployed this function keeps old behavior for testing
2947     function transfer(address to, uint256 amount, bytes data)
2948         public
2949         returns (bool)
2950     {
2951         // it is necessary to point out implementation to be called
2952         BasicSnapshotToken.mTransfer(msg.sender, to, amount);
2953 
2954         // Notify the receiving contract.
2955         if (isContract(to)) {
2956             IERC223LegacyCallback(to).onTokenTransfer(msg.sender, amount, data);
2957         }
2958         return true;
2959     }
2960 
2961     ////////////////////////
2962     // Internal functions
2963     ////////////////////////
2964 
2965     //
2966     // Implements MTokenController
2967     //
2968 
2969     function mOnTransfer(
2970         address from,
2971         address, // to
2972         uint256 // amount
2973     )
2974         internal
2975         acceptAgreement(from)
2976         returns (bool allow)
2977     {
2978         // must have transfer enabled or msg.sender is Neumark issuer
2979         return _transferEnabled || accessPolicy().allowed(msg.sender, ROLE_NEUMARK_ISSUER, this, msg.sig);
2980     }
2981 
2982     function mOnApprove(
2983         address owner,
2984         address, // spender,
2985         uint256 // amount
2986     )
2987         internal
2988         acceptAgreement(owner)
2989         returns (bool allow)
2990     {
2991         return true;
2992     }
2993 
2994     ////////////////////////
2995     // Private functions
2996     ////////////////////////
2997 
2998     function burnPrivate(uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2999         private
3000     {
3001         uint256 prevEuroUlps = _totalEurUlps;
3002         // burn first in the token to make sure balance/totalSupply is not crossed
3003         mDestroyTokens(msg.sender, burnNeumarkUlps);
3004         _totalEurUlps = cumulativeInverse(totalSupply(), minEurUlps, maxEurUlps);
3005         // actually may overflow on non-monotonic inverse
3006         assert(prevEuroUlps >= _totalEurUlps);
3007         uint256 euroUlps = prevEuroUlps - _totalEurUlps;
3008         emit LogNeumarksBurned(msg.sender, euroUlps, burnNeumarkUlps);
3009     }
3010 }
3011 
3012 /// @title disburse payment token amount to snapshot token holders
3013 /// @dev payment token received via ERC223 Transfer
3014 contract IFeeDisbursal is IERC223Callback {
3015     // TODO: declare interface
3016     function claim() public;
3017 
3018     function recycle() public;
3019 }
3020 
3021 /// @title disburse payment token amount to snapshot token holders
3022 /// @dev payment token received via ERC223 Transfer
3023 contract IPlatformPortfolio is IERC223Callback {
3024     // TODO: declare interface
3025 }
3026 
3027 contract ITokenExchangeRateOracle {
3028     /// @notice provides actual price of 'numeratorToken' in 'denominatorToken'
3029     ///     returns timestamp at which price was obtained in oracle
3030     function getExchangeRate(address numeratorToken, address denominatorToken)
3031         public
3032         constant
3033         returns (uint256 rateFraction, uint256 timestamp);
3034 
3035     /// @notice allows to retreive multiple exchange rates in once call
3036     function getExchangeRates(address[] numeratorTokens, address[] denominatorTokens)
3037         public
3038         constant
3039         returns (uint256[] rateFractions, uint256[] timestamps);
3040 }
3041 
3042 /// @title root of trust and singletons + known interface registry
3043 /// provides a root which holds all interfaces platform trust, this includes
3044 /// singletons - for which accessors are provided
3045 /// collections of known instances of interfaces
3046 /// @dev interfaces are identified by bytes4, see KnownInterfaces.sol
3047 contract Universe is
3048     Agreement,
3049     IContractId,
3050     KnownInterfaces
3051 {
3052     ////////////////////////
3053     // Events
3054     ////////////////////////
3055 
3056     /// raised on any change of singleton instance
3057     /// @dev for convenience we provide previous instance of singleton in replacedInstance
3058     event LogSetSingleton(
3059         bytes4 interfaceId,
3060         address instance,
3061         address replacedInstance
3062     );
3063 
3064     /// raised on add/remove interface instance in collection
3065     event LogSetCollectionInterface(
3066         bytes4 interfaceId,
3067         address instance,
3068         bool isSet
3069     );
3070 
3071     ////////////////////////
3072     // Mutable state
3073     ////////////////////////
3074 
3075     // mapping of known contracts to addresses of singletons
3076     mapping(bytes4 => address) private _singletons;
3077 
3078     // mapping of known interfaces to collections of contracts
3079     mapping(bytes4 =>
3080         mapping(address => bool)) private _collections; // solium-disable-line indentation
3081 
3082     // known instances
3083     mapping(address => bytes4[]) private _instances;
3084 
3085 
3086     ////////////////////////
3087     // Constructor
3088     ////////////////////////
3089 
3090     constructor(
3091         IAccessPolicy accessPolicy,
3092         IEthereumForkArbiter forkArbiter
3093     )
3094         Agreement(accessPolicy, forkArbiter)
3095         public
3096     {
3097         setSingletonPrivate(KNOWN_INTERFACE_ACCESS_POLICY, accessPolicy);
3098         setSingletonPrivate(KNOWN_INTERFACE_FORK_ARBITER, forkArbiter);
3099     }
3100 
3101     ////////////////////////
3102     // Public methods
3103     ////////////////////////
3104 
3105     /// get singleton instance for 'interfaceId'
3106     function getSingleton(bytes4 interfaceId)
3107         public
3108         constant
3109         returns (address)
3110     {
3111         return _singletons[interfaceId];
3112     }
3113 
3114     function getManySingletons(bytes4[] interfaceIds)
3115         public
3116         constant
3117         returns (address[])
3118     {
3119         address[] memory addresses = new address[](interfaceIds.length);
3120         uint256 idx;
3121         while(idx < interfaceIds.length) {
3122             addresses[idx] = _singletons[interfaceIds[idx]];
3123             idx += 1;
3124         }
3125         return addresses;
3126     }
3127 
3128     /// checks of 'instance' is instance of interface 'interfaceId'
3129     function isSingleton(bytes4 interfaceId, address instance)
3130         public
3131         constant
3132         returns (bool)
3133     {
3134         return _singletons[interfaceId] == instance;
3135     }
3136 
3137     /// checks if 'instance' is one of instances of 'interfaceId'
3138     function isInterfaceCollectionInstance(bytes4 interfaceId, address instance)
3139         public
3140         constant
3141         returns (bool)
3142     {
3143         return _collections[interfaceId][instance];
3144     }
3145 
3146     function isAnyOfInterfaceCollectionInstance(bytes4[] interfaceIds, address instance)
3147         public
3148         constant
3149         returns (bool)
3150     {
3151         uint256 idx;
3152         while(idx < interfaceIds.length) {
3153             if (_collections[interfaceIds[idx]][instance]) {
3154                 return true;
3155             }
3156             idx += 1;
3157         }
3158         return false;
3159     }
3160 
3161     /// gets all interfaces of given instance
3162     function getInterfacesOfInstance(address instance)
3163         public
3164         constant
3165         returns (bytes4[] interfaces)
3166     {
3167         return _instances[instance];
3168     }
3169 
3170     /// sets 'instance' of singleton with interface 'interfaceId'
3171     function setSingleton(bytes4 interfaceId, address instance)
3172         public
3173         only(ROLE_UNIVERSE_MANAGER)
3174     {
3175         setSingletonPrivate(interfaceId, instance);
3176     }
3177 
3178     /// convenience method for setting many singleton instances
3179     function setManySingletons(bytes4[] interfaceIds, address[] instances)
3180         public
3181         only(ROLE_UNIVERSE_MANAGER)
3182     {
3183         require(interfaceIds.length == instances.length);
3184         uint256 idx;
3185         while(idx < interfaceIds.length) {
3186             setSingletonPrivate(interfaceIds[idx], instances[idx]);
3187             idx += 1;
3188         }
3189     }
3190 
3191     /// set or unset 'instance' with 'interfaceId' in collection of instances
3192     function setCollectionInterface(bytes4 interfaceId, address instance, bool set)
3193         public
3194         only(ROLE_UNIVERSE_MANAGER)
3195     {
3196         setCollectionPrivate(interfaceId, instance, set);
3197     }
3198 
3199     /// set or unset 'instance' in many collections of instances
3200     function setInterfaceInManyCollections(bytes4[] interfaceIds, address instance, bool set)
3201         public
3202         only(ROLE_UNIVERSE_MANAGER)
3203     {
3204         uint256 idx;
3205         while(idx < interfaceIds.length) {
3206             setCollectionPrivate(interfaceIds[idx], instance, set);
3207             idx += 1;
3208         }
3209     }
3210 
3211     /// set or unset array of collection
3212     function setCollectionsInterfaces(bytes4[] interfaceIds, address[] instances, bool[] set_flags)
3213         public
3214         only(ROLE_UNIVERSE_MANAGER)
3215     {
3216         require(interfaceIds.length == instances.length);
3217         require(interfaceIds.length == set_flags.length);
3218         uint256 idx;
3219         while(idx < interfaceIds.length) {
3220             setCollectionPrivate(interfaceIds[idx], instances[idx], set_flags[idx]);
3221             idx += 1;
3222         }
3223     }
3224 
3225     //
3226     // Implements IContractId
3227     //
3228 
3229     function contractId() public pure returns (bytes32 id, uint256 version) {
3230         return (0x8b57bfe21a3ef4854e19d702063b6cea03fa514162f8ff43fde551f06372fefd, 0);
3231     }
3232 
3233     ////////////////////////
3234     // Getters
3235     ////////////////////////
3236 
3237     function accessPolicy() public constant returns (IAccessPolicy) {
3238         return IAccessPolicy(_singletons[KNOWN_INTERFACE_ACCESS_POLICY]);
3239     }
3240 
3241     function forkArbiter() public constant returns (IEthereumForkArbiter) {
3242         return IEthereumForkArbiter(_singletons[KNOWN_INTERFACE_FORK_ARBITER]);
3243     }
3244 
3245     function neumark() public constant returns (Neumark) {
3246         return Neumark(_singletons[KNOWN_INTERFACE_NEUMARK]);
3247     }
3248 
3249     function etherToken() public constant returns (IERC223Token) {
3250         return IERC223Token(_singletons[KNOWN_INTERFACE_ETHER_TOKEN]);
3251     }
3252 
3253     function euroToken() public constant returns (IERC223Token) {
3254         return IERC223Token(_singletons[KNOWN_INTERFACE_EURO_TOKEN]);
3255     }
3256 
3257     function etherLock() public constant returns (address) {
3258         return _singletons[KNOWN_INTERFACE_ETHER_LOCK];
3259     }
3260 
3261     function euroLock() public constant returns (address) {
3262         return _singletons[KNOWN_INTERFACE_EURO_LOCK];
3263     }
3264 
3265     function icbmEtherLock() public constant returns (address) {
3266         return _singletons[KNOWN_INTERFACE_ICBM_ETHER_LOCK];
3267     }
3268 
3269     function icbmEuroLock() public constant returns (address) {
3270         return _singletons[KNOWN_INTERFACE_ICBM_EURO_LOCK];
3271     }
3272 
3273     function identityRegistry() public constant returns (address) {
3274         return IIdentityRegistry(_singletons[KNOWN_INTERFACE_IDENTITY_REGISTRY]);
3275     }
3276 
3277     function tokenExchangeRateOracle() public constant returns (address) {
3278         return ITokenExchangeRateOracle(_singletons[KNOWN_INTERFACE_TOKEN_EXCHANGE_RATE_ORACLE]);
3279     }
3280 
3281     function feeDisbursal() public constant returns (address) {
3282         return IFeeDisbursal(_singletons[KNOWN_INTERFACE_FEE_DISBURSAL]);
3283     }
3284 
3285     function platformPortfolio() public constant returns (address) {
3286         return IPlatformPortfolio(_singletons[KNOWN_INTERFACE_PLATFORM_PORTFOLIO]);
3287     }
3288 
3289     function tokenExchange() public constant returns (address) {
3290         return _singletons[KNOWN_INTERFACE_TOKEN_EXCHANGE];
3291     }
3292 
3293     function gasExchange() public constant returns (address) {
3294         return _singletons[KNOWN_INTERFACE_GAS_EXCHANGE];
3295     }
3296 
3297     function platformTerms() public constant returns (address) {
3298         return _singletons[KNOWN_INTERFACE_PLATFORM_TERMS];
3299     }
3300 
3301     ////////////////////////
3302     // Private methods
3303     ////////////////////////
3304 
3305     function setSingletonPrivate(bytes4 interfaceId, address instance)
3306         private
3307     {
3308         require(interfaceId != KNOWN_INTERFACE_UNIVERSE, "NF_UNI_NO_UNIVERSE_SINGLETON");
3309         address replacedInstance = _singletons[interfaceId];
3310         // do nothing if not changing
3311         if (replacedInstance != instance) {
3312             dropInstance(replacedInstance, interfaceId);
3313             addInstance(instance, interfaceId);
3314             _singletons[interfaceId] = instance;
3315         }
3316 
3317         emit LogSetSingleton(interfaceId, instance, replacedInstance);
3318     }
3319 
3320     function setCollectionPrivate(bytes4 interfaceId, address instance, bool set)
3321         private
3322     {
3323         // do nothing if not changing
3324         if (_collections[interfaceId][instance] == set) {
3325             return;
3326         }
3327         _collections[interfaceId][instance] = set;
3328         if (set) {
3329             addInstance(instance, interfaceId);
3330         } else {
3331             dropInstance(instance, interfaceId);
3332         }
3333         emit LogSetCollectionInterface(interfaceId, instance, set);
3334     }
3335 
3336     function addInstance(address instance, bytes4 interfaceId)
3337         private
3338     {
3339         if (instance == address(0)) {
3340             // do not add null instance
3341             return;
3342         }
3343         bytes4[] storage current = _instances[instance];
3344         uint256 idx;
3345         while(idx < current.length) {
3346             // instancy has this interface already, do nothing
3347             if (current[idx] == interfaceId)
3348                 return;
3349             idx += 1;
3350         }
3351         // new interface
3352         current.push(interfaceId);
3353     }
3354 
3355     function dropInstance(address instance, bytes4 interfaceId)
3356         private
3357     {
3358         if (instance == address(0)) {
3359             // do not drop null instance
3360             return;
3361         }
3362         bytes4[] storage current = _instances[instance];
3363         uint256 idx;
3364         uint256 last = current.length - 1;
3365         while(idx <= last) {
3366             if (current[idx] == interfaceId) {
3367                 // delete element
3368                 if (idx < last) {
3369                     // if not last element move last element to idx being deleted
3370                     current[idx] = current[last];
3371                 }
3372                 // delete last element
3373                 current.length -= 1;
3374                 return;
3375             }
3376             idx += 1;
3377         }
3378     }
3379 }
3380 
3381 /// @title sets duration of states in ETO
3382 contract ETODurationTerms is IContractId {
3383 
3384     ////////////////////////
3385     // Immutable state
3386     ////////////////////////
3387 
3388     // duration of Whitelist state
3389     uint32 public WHITELIST_DURATION;
3390 
3391     // duration of Public state
3392     uint32 public PUBLIC_DURATION;
3393 
3394     // time for Nominee and Company to sign Investment Agreement offchain and present proof on-chain
3395     uint32 public SIGNING_DURATION;
3396 
3397     // time for Claim before fee payout from ETO to NEU holders
3398     uint32 public CLAIM_DURATION;
3399 
3400     ////////////////////////
3401     // Constructor
3402     ////////////////////////
3403 
3404     constructor(
3405         uint32 whitelistDuration,
3406         uint32 publicDuration,
3407         uint32 signingDuration,
3408         uint32 claimDuration
3409     )
3410         public
3411     {
3412         WHITELIST_DURATION = whitelistDuration;
3413         PUBLIC_DURATION = publicDuration;
3414         SIGNING_DURATION = signingDuration;
3415         CLAIM_DURATION = claimDuration;
3416     }
3417 
3418     //
3419     // Implements IContractId
3420     //
3421 
3422     function contractId() public pure returns (bytes32 id, uint256 version) {
3423         return (0x5fb50201b453799d95f8a80291b940f1c543537b95bff2e3c78c2e36070494c0, 0);
3424     }
3425 }
3426 
3427 /// @title sets terms for tokens in ETO
3428 contract ETOTokenTerms is IContractId {
3429 
3430     ////////////////////////
3431     // Immutable state
3432     ////////////////////////
3433 
3434     // minimum number of tokens being offered. will set min cap
3435     uint256 public MIN_NUMBER_OF_TOKENS;
3436     // maximum number of tokens being offered. will set max cap
3437     uint256 public MAX_NUMBER_OF_TOKENS;
3438     // base token price in EUR-T, without any discount scheme
3439     uint256 public TOKEN_PRICE_EUR_ULPS;
3440     // maximum number of tokens in whitelist phase
3441     uint256 public MAX_NUMBER_OF_TOKENS_IN_WHITELIST;
3442     // equity tokens per share
3443     uint256 public constant EQUITY_TOKENS_PER_SHARE = 10000;
3444     // equity tokens decimals (precision)
3445     uint8 public constant EQUITY_TOKENS_PRECISION = 0; // indivisible
3446 
3447 
3448     ////////////////////////
3449     // Constructor
3450     ////////////////////////
3451 
3452     constructor(
3453         uint256 minNumberOfTokens,
3454         uint256 maxNumberOfTokens,
3455         uint256 tokenPriceEurUlps,
3456         uint256 maxNumberOfTokensInWhitelist
3457     )
3458         public
3459     {
3460         require(maxNumberOfTokensInWhitelist <= maxNumberOfTokens);
3461         require(maxNumberOfTokens >= minNumberOfTokens);
3462         // min cap must be > single share
3463         require(minNumberOfTokens >= EQUITY_TOKENS_PER_SHARE, "NF_ETO_TERMS_ONE_SHARE");
3464 
3465         MIN_NUMBER_OF_TOKENS = minNumberOfTokens;
3466         MAX_NUMBER_OF_TOKENS = maxNumberOfTokens;
3467         TOKEN_PRICE_EUR_ULPS = tokenPriceEurUlps;
3468         MAX_NUMBER_OF_TOKENS_IN_WHITELIST = maxNumberOfTokensInWhitelist;
3469     }
3470 
3471     //
3472     // Implements IContractId
3473     //
3474 
3475     function contractId() public pure returns (bytes32 id, uint256 version) {
3476         return (0x591e791aab2b14c80194b729a2abcba3e8cce1918be4061be170e7223357ae5c, 0);
3477     }
3478 }
3479 
3480 /// @title base terms of Equity Token Offering
3481 /// encapsulates pricing, discounts and whitelisting mechanism
3482 /// @dev to be split is mixins
3483 contract ETOTerms is
3484     IdentityRecord,
3485     Math,
3486     IContractId
3487 {
3488 
3489     ////////////////////////
3490     // Types
3491     ////////////////////////
3492 
3493     // @notice whitelist entry with a discount
3494     struct WhitelistTicket {
3495         // this also overrides maximum ticket
3496         uint128 discountAmountEurUlps;
3497         // a percentage of full price to be paid (1 - discount)
3498         uint128 fullTokenPriceFrac;
3499     }
3500 
3501     ////////////////////////
3502     // Constants state
3503     ////////////////////////
3504 
3505     bytes32 private constant EMPTY_STRING_HASH = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
3506     uint256 public constant MIN_QUALIFIED_INVESTOR_TICKET_EUR_ULPS = 100000 * 10**18;
3507 
3508     ////////////////////////
3509     // Immutable state
3510     ////////////////////////
3511 
3512     // reference to duration terms
3513     ETODurationTerms public DURATION_TERMS;
3514     // reference to token terms
3515     ETOTokenTerms public TOKEN_TERMS;
3516     // total number of shares in the company (incl. Authorized Shares) at moment of sale
3517     uint256 public EXISTING_COMPANY_SHARES;
3518     // sets nominal value of a share
3519     uint256 public SHARE_NOMINAL_VALUE_EUR_ULPS;
3520     // maximum discount on token price that may be given to investor (as decimal fraction)
3521     // uint256 public MAXIMUM_TOKEN_PRICE_DISCOUNT_FRAC;
3522     // minimum ticket
3523     uint256 public MIN_TICKET_EUR_ULPS;
3524     // maximum ticket for sophisiticated investors
3525     uint256 public MAX_TICKET_EUR_ULPS;
3526     // maximum ticket for simple investors
3527     uint256 public MAX_TICKET_SIMPLE_EUR_ULPS;
3528     // should enable transfers on ETO success
3529     // transfers are always disabled during token offering
3530     // if set to False transfers on Equity Token will remain disabled after offering
3531     // once those terms are on-chain this flags fully controls token transferability
3532     bool public ENABLE_TRANSFERS_ON_SUCCESS;
3533     // tells if offering accepts retail investors. if so, registered prospectus is required
3534     // and ENABLE_TRANSFERS_ON_SUCCESS is forced to be false as per current platform policy
3535     bool public ALLOW_RETAIL_INVESTORS;
3536     // represents the discount % for whitelist participants
3537     uint256 public WHITELIST_DISCOUNT_FRAC;
3538     // represents the discount % for public participants, using values > 0 will result
3539     // in automatic downround shareholder resolution
3540     uint256 public PUBLIC_DISCOUNT_FRAC;
3541 
3542     // paperwork
3543     // prospectus / investment memorandum / crowdfunding pamphlet etc.
3544     string public INVESTOR_OFFERING_DOCUMENT_URL;
3545     // settings for shareholder rights
3546     ShareholderRights public SHAREHOLDER_RIGHTS;
3547 
3548     // equity token setup
3549     string public EQUITY_TOKEN_NAME;
3550     string public EQUITY_TOKEN_SYMBOL;
3551 
3552     // manages whitelist
3553     address public WHITELIST_MANAGER;
3554     // wallet registry of KYC procedure
3555     IIdentityRegistry public IDENTITY_REGISTRY;
3556     Universe public UNIVERSE;
3557 
3558     // variables from token terms for local use
3559     // minimum number of tokens being offered. will set min cap
3560     uint256 private MIN_NUMBER_OF_TOKENS;
3561     // maximum number of tokens being offered. will set max cap
3562     uint256 private MAX_NUMBER_OF_TOKENS;
3563     // base token price in EUR-T, without any discount scheme
3564     uint256 private TOKEN_PRICE_EUR_ULPS;
3565     // equity tokens per share
3566     uint256 private EQUITY_TOKENS_PER_SHARE;
3567 
3568 
3569     ////////////////////////
3570     // Mutable state
3571     ////////////////////////
3572 
3573     // mapping of investors allowed in whitelist
3574     mapping (address => WhitelistTicket) private _whitelist;
3575 
3576     ////////////////////////
3577     // Modifiers
3578     ////////////////////////
3579 
3580     modifier onlyWhitelistManager() {
3581         require(msg.sender == WHITELIST_MANAGER);
3582         _;
3583     }
3584 
3585     ////////////////////////
3586     // Events
3587     ////////////////////////
3588 
3589     // raised on invesor added to whitelist
3590     event LogInvestorWhitelisted(
3591         address indexed investor,
3592         uint256 discountAmountEurUlps,
3593         uint256 fullTokenPriceFrac
3594     );
3595 
3596     ////////////////////////
3597     // Constructor
3598     ////////////////////////
3599 
3600     constructor(
3601         Universe universe,
3602         ETODurationTerms durationTerms,
3603         ETOTokenTerms tokenTerms,
3604         uint256 existingCompanyShares,
3605         uint256 minTicketEurUlps,
3606         uint256 maxTicketEurUlps,
3607         bool allowRetailInvestors,
3608         bool enableTransfersOnSuccess,
3609         string investorOfferingDocumentUrl,
3610         ShareholderRights shareholderRights,
3611         string equityTokenName,
3612         string equityTokenSymbol,
3613         uint256 shareNominalValueEurUlps,
3614         uint256 whitelistDiscountFrac,
3615         uint256 publicDiscountFrac
3616     )
3617         public
3618     {
3619         require(durationTerms != address(0));
3620         require(tokenTerms != address(0));
3621         require(existingCompanyShares > 0);
3622         require(keccak256(abi.encodePacked(investorOfferingDocumentUrl)) != EMPTY_STRING_HASH);
3623         require(keccak256(abi.encodePacked(equityTokenName)) != EMPTY_STRING_HASH);
3624         require(keccak256(abi.encodePacked(equityTokenSymbol)) != EMPTY_STRING_HASH);
3625         require(shareholderRights != address(0));
3626         // test interface
3627         require(shareholderRights.HAS_GENERAL_INFORMATION_RIGHTS());
3628         require(shareNominalValueEurUlps > 0);
3629         require(whitelistDiscountFrac >= 0 && whitelistDiscountFrac <= 99*10**16);
3630         require(publicDiscountFrac >= 0 && publicDiscountFrac <= 99*10**16);
3631         require(minTicketEurUlps<=maxTicketEurUlps);
3632         require(tokenTerms.EQUITY_TOKENS_PRECISION() == 0);
3633 
3634         // copy token terms variables
3635         MIN_NUMBER_OF_TOKENS = tokenTerms.MIN_NUMBER_OF_TOKENS();
3636         MAX_NUMBER_OF_TOKENS = tokenTerms.MAX_NUMBER_OF_TOKENS();
3637         TOKEN_PRICE_EUR_ULPS = tokenTerms.TOKEN_PRICE_EUR_ULPS();
3638         EQUITY_TOKENS_PER_SHARE = tokenTerms.EQUITY_TOKENS_PER_SHARE();
3639 
3640         DURATION_TERMS = durationTerms;
3641         TOKEN_TERMS = tokenTerms;
3642         EXISTING_COMPANY_SHARES = existingCompanyShares;
3643         MIN_TICKET_EUR_ULPS = minTicketEurUlps;
3644         MAX_TICKET_EUR_ULPS = maxTicketEurUlps;
3645         ALLOW_RETAIL_INVESTORS = allowRetailInvestors;
3646         ENABLE_TRANSFERS_ON_SUCCESS = enableTransfersOnSuccess;
3647         INVESTOR_OFFERING_DOCUMENT_URL = investorOfferingDocumentUrl;
3648         SHAREHOLDER_RIGHTS = shareholderRights;
3649         EQUITY_TOKEN_NAME = equityTokenName;
3650         EQUITY_TOKEN_SYMBOL = equityTokenSymbol;
3651         SHARE_NOMINAL_VALUE_EUR_ULPS = shareNominalValueEurUlps;
3652         WHITELIST_DISCOUNT_FRAC = whitelistDiscountFrac;
3653         PUBLIC_DISCOUNT_FRAC = publicDiscountFrac;
3654         WHITELIST_MANAGER = msg.sender;
3655         IDENTITY_REGISTRY = IIdentityRegistry(universe.identityRegistry());
3656         UNIVERSE = universe;
3657     }
3658 
3659     ////////////////////////
3660     // Public methods
3661     ////////////////////////
3662 
3663     // calculates token amount for a given commitment at a position of the curve
3664     // we require that equity token precision is 0
3665     function calculateTokenAmount(uint256 /*totalEurUlps*/, uint256 committedEurUlps)
3666         public
3667         constant
3668         returns (uint256 tokenAmountInt)
3669     {
3670         // we may disregard totalEurUlps as curve is flat, round down when calculating tokens
3671         return committedEurUlps / calculatePriceFraction(10**18 - PUBLIC_DISCOUNT_FRAC);
3672     }
3673 
3674     // calculates amount of euro required to acquire amount of tokens at a position of the (inverse) curve
3675     // we require that equity token precision is 0
3676     function calculateEurUlpsAmount(uint256 /*totalTokensInt*/, uint256 tokenAmountInt)
3677         public
3678         constant
3679         returns (uint256 committedEurUlps)
3680     {
3681         // we may disregard totalTokensInt as curve is flat
3682         return mul(tokenAmountInt, calculatePriceFraction(10**18 - PUBLIC_DISCOUNT_FRAC));
3683     }
3684 
3685     // get mincap in EUR
3686     function ESTIMATED_MIN_CAP_EUR_ULPS() public constant returns(uint256) {
3687         return calculateEurUlpsAmount(0, MIN_NUMBER_OF_TOKENS);
3688     }
3689 
3690     // get max cap in EUR
3691     function ESTIMATED_MAX_CAP_EUR_ULPS() public constant returns(uint256) {
3692         return calculateEurUlpsAmount(0, MAX_NUMBER_OF_TOKENS);
3693     }
3694 
3695     function calculatePriceFraction(uint256 priceFrac) public constant returns(uint256) {
3696         if (priceFrac == 1) {
3697             return TOKEN_PRICE_EUR_ULPS;
3698         } else {
3699             return decimalFraction(priceFrac, TOKEN_PRICE_EUR_ULPS);
3700         }
3701     }
3702 
3703     /// @notice returns number of shares as a decimal fraction
3704     function equityTokensToShares(uint256 amount)
3705         public
3706         constant
3707         returns (uint256)
3708     {
3709         return proportion(amount, 10**18, EQUITY_TOKENS_PER_SHARE);
3710     }
3711 
3712     function addWhitelisted(
3713         address[] investors,
3714         uint256[] discountAmountsEurUlps,
3715         uint256[] discountsFrac
3716     )
3717         external
3718         onlyWhitelistManager
3719     {
3720         require(investors.length == discountAmountsEurUlps.length);
3721         require(investors.length == discountsFrac.length);
3722 
3723         for (uint256 i = 0; i < investors.length; i += 1) {
3724             addWhitelistInvestorPrivate(investors[i], discountAmountsEurUlps[i], discountsFrac[i]);
3725         }
3726     }
3727 
3728     function whitelistTicket(address investor)
3729         public
3730         constant
3731         returns (bool isWhitelisted, uint256 discountAmountEurUlps, uint256 fullTokenPriceFrac)
3732     {
3733         WhitelistTicket storage wlTicket = _whitelist[investor];
3734         isWhitelisted = wlTicket.fullTokenPriceFrac > 0;
3735         discountAmountEurUlps = wlTicket.discountAmountEurUlps;
3736         fullTokenPriceFrac = wlTicket.fullTokenPriceFrac;
3737     }
3738 
3739     // calculate contribution of investor
3740     function calculateContribution(
3741         address investor,
3742         uint256 totalContributedEurUlps,
3743         uint256 existingInvestorContributionEurUlps,
3744         uint256 newInvestorContributionEurUlps,
3745         bool applyWhitelistDiscounts
3746     )
3747         public
3748         constant
3749         returns (
3750             bool isWhitelisted,
3751             bool isEligible,
3752             uint256 minTicketEurUlps,
3753             uint256 maxTicketEurUlps,
3754             uint256 equityTokenInt,
3755             uint256 fixedSlotEquityTokenInt
3756             )
3757     {
3758         (
3759             isWhitelisted,
3760             minTicketEurUlps,
3761             maxTicketEurUlps,
3762             equityTokenInt,
3763             fixedSlotEquityTokenInt
3764         ) = calculateContributionPrivate(
3765             investor,
3766             totalContributedEurUlps,
3767             existingInvestorContributionEurUlps,
3768             newInvestorContributionEurUlps,
3769             applyWhitelistDiscounts);
3770         // check if is eligible for investment
3771         IdentityClaims memory claims = deserializeClaims(IDENTITY_REGISTRY.getClaims(investor));
3772         isEligible = claims.isVerified && !claims.accountFrozen;
3773     }
3774 
3775     /// @notice checks terms against platform terms, reverts on invalid
3776     function requireValidTerms(PlatformTerms platformTerms)
3777         public
3778         constant
3779         returns (bool)
3780     {
3781         // apply constraints on retail fundraising
3782         if (ALLOW_RETAIL_INVESTORS) {
3783             // make sure transfers are disabled after offering for retail investors
3784             require(!ENABLE_TRANSFERS_ON_SUCCESS, "NF_MUST_DISABLE_TRANSFERS");
3785         } else {
3786             // only qualified investors allowed defined as tickets > 100000 EUR
3787             require(MIN_TICKET_EUR_ULPS >= MIN_QUALIFIED_INVESTOR_TICKET_EUR_ULPS, "NF_MIN_QUALIFIED_INVESTOR_TICKET");
3788         }
3789         // min ticket must be > token price
3790         require(MIN_TICKET_EUR_ULPS >= TOKEN_TERMS.TOKEN_PRICE_EUR_ULPS(), "NF_MIN_TICKET_LT_TOKEN_PRICE");
3791         // it must be possible to collect more funds than max number of tokens
3792         require(ESTIMATED_MAX_CAP_EUR_ULPS() >= MIN_TICKET_EUR_ULPS, "NF_MAX_FUNDS_LT_MIN_TICKET");
3793 
3794         require(MIN_TICKET_EUR_ULPS >= platformTerms.MIN_TICKET_EUR_ULPS(), "NF_ETO_TERMS_MIN_TICKET_EUR_ULPS");
3795         // duration checks
3796         require(DURATION_TERMS.WHITELIST_DURATION() >= platformTerms.MIN_WHITELIST_DURATION(), "NF_ETO_TERMS_WL_D_MIN");
3797         require(DURATION_TERMS.WHITELIST_DURATION() <= platformTerms.MAX_WHITELIST_DURATION(), "NF_ETO_TERMS_WL_D_MAX");
3798 
3799         require(DURATION_TERMS.PUBLIC_DURATION() >= platformTerms.MIN_PUBLIC_DURATION(), "NF_ETO_TERMS_PUB_D_MIN");
3800         require(DURATION_TERMS.PUBLIC_DURATION() <= platformTerms.MAX_PUBLIC_DURATION(), "NF_ETO_TERMS_PUB_D_MAX");
3801 
3802         uint256 totalDuration = DURATION_TERMS.WHITELIST_DURATION() + DURATION_TERMS.PUBLIC_DURATION();
3803         require(totalDuration >= platformTerms.MIN_OFFER_DURATION(), "NF_ETO_TERMS_TOT_O_MIN");
3804         require(totalDuration <= platformTerms.MAX_OFFER_DURATION(), "NF_ETO_TERMS_TOT_O_MAX");
3805 
3806         require(DURATION_TERMS.SIGNING_DURATION() >= platformTerms.MIN_SIGNING_DURATION(), "NF_ETO_TERMS_SIG_MIN");
3807         require(DURATION_TERMS.SIGNING_DURATION() <= platformTerms.MAX_SIGNING_DURATION(), "NF_ETO_TERMS_SIG_MAX");
3808 
3809         require(DURATION_TERMS.CLAIM_DURATION() >= platformTerms.MIN_CLAIM_DURATION(), "NF_ETO_TERMS_CLAIM_MIN");
3810         require(DURATION_TERMS.CLAIM_DURATION() <= platformTerms.MAX_CLAIM_DURATION(), "NF_ETO_TERMS_CLAIM_MAX");
3811 
3812         return true;
3813     }
3814 
3815     //
3816     // Implements IContractId
3817     //
3818 
3819     function contractId() public pure returns (bytes32 id, uint256 version) {
3820         return (0x3468b14073c33fa00ee7f8a289b14f4a10c78ab72726033b27003c31c47b3f6a, 0);
3821     }
3822 
3823     ////////////////////////
3824     // Private methods
3825     ////////////////////////
3826 
3827     function calculateContributionPrivate(
3828         address investor,
3829         uint256 totalContributedEurUlps,
3830         uint256 existingInvestorContributionEurUlps,
3831         uint256 newInvestorContributionEurUlps,
3832         bool applyWhitelistDiscounts
3833     )
3834         private
3835         constant
3836         returns (
3837             bool isWhitelisted,
3838             uint256 minTicketEurUlps,
3839             uint256 maxTicketEurUlps,
3840             uint256 equityTokenInt,
3841             uint256 fixedSlotEquityTokenInt
3842         )
3843     {
3844         uint256 discountedAmount;
3845         minTicketEurUlps = MIN_TICKET_EUR_ULPS;
3846         maxTicketEurUlps = MAX_TICKET_EUR_ULPS;
3847         WhitelistTicket storage wlTicket = _whitelist[investor];
3848         // check if has access to discount
3849         isWhitelisted = wlTicket.fullTokenPriceFrac > 0;
3850         // whitelist use discount is possible
3851         if (applyWhitelistDiscounts) {
3852             // can invest more than general max ticket
3853             maxTicketEurUlps = max(wlTicket.discountAmountEurUlps, maxTicketEurUlps);
3854             // can invest less than general min ticket
3855             if (wlTicket.discountAmountEurUlps > 0) {
3856                 minTicketEurUlps = min(wlTicket.discountAmountEurUlps, minTicketEurUlps);
3857             }
3858             if (existingInvestorContributionEurUlps < wlTicket.discountAmountEurUlps) {
3859                 discountedAmount = min(newInvestorContributionEurUlps, wlTicket.discountAmountEurUlps - existingInvestorContributionEurUlps);
3860                 // discount is fixed so use base token price
3861                 if (discountedAmount > 0) {
3862                     // always round down when calculating tokens
3863                     fixedSlotEquityTokenInt = discountedAmount / calculatePriceFraction(wlTicket.fullTokenPriceFrac);
3864                 }
3865             }
3866         }
3867         // if any amount above discount
3868         uint256 remainingAmount = newInvestorContributionEurUlps - discountedAmount;
3869         if (remainingAmount > 0) {
3870             if (applyWhitelistDiscounts && WHITELIST_DISCOUNT_FRAC > 0) {
3871                 // will not overflow, WHITELIST_DISCOUNT_FRAC < Q18 from constructor, also round down
3872                 equityTokenInt = remainingAmount / calculatePriceFraction(10**18 - WHITELIST_DISCOUNT_FRAC);
3873             } else {
3874                 // use pricing along the curve
3875                 equityTokenInt = calculateTokenAmount(totalContributedEurUlps + discountedAmount, remainingAmount);
3876             }
3877         }
3878         // should have all issued tokens
3879         equityTokenInt += fixedSlotEquityTokenInt;
3880 
3881     }
3882 
3883     function addWhitelistInvestorPrivate(
3884         address investor,
3885         uint256 discountAmountEurUlps,
3886         uint256 fullTokenPriceFrac
3887     )
3888         private
3889     {
3890         // Validate
3891         require(investor != address(0));
3892         require(fullTokenPriceFrac > 0 && fullTokenPriceFrac <= 10**18, "NF_DISCOUNT_RANGE");
3893         require(discountAmountEurUlps < 2**128);
3894 
3895 
3896         _whitelist[investor] = WhitelistTicket({
3897             discountAmountEurUlps: uint128(discountAmountEurUlps),
3898             fullTokenPriceFrac: uint128(fullTokenPriceFrac)
3899         });
3900 
3901         emit LogInvestorWhitelisted(investor, discountAmountEurUlps, fullTokenPriceFrac);
3902     }
3903 
3904 }
3905 
3906 /// @title default interface of commitment process
3907 ///  investment always happens via payment token ERC223 callback
3908 ///  methods for checking finality and success/fail of the process are vailable
3909 ///  commitment event is standardized for tracking
3910 contract ICommitment is
3911     IAgreement,
3912     IERC223Callback
3913 {
3914 
3915     ////////////////////////
3916     // Events
3917     ////////////////////////
3918 
3919     /// on every commitment transaction
3920     /// `investor` committed `amount` in `paymentToken` currency which was
3921     /// converted to `baseCurrencyEquivalent` that generates `grantedAmount` of
3922     /// `assetToken` and `neuReward` NEU
3923     /// for investment funds could be provided from `wallet` (like icbm wallet) controlled by investor
3924     event LogFundsCommitted(
3925         address indexed investor,
3926         address wallet,
3927         address paymentToken,
3928         uint256 amount,
3929         uint256 baseCurrencyEquivalent,
3930         uint256 grantedAmount,
3931         address assetToken,
3932         uint256 neuReward
3933     );
3934 
3935     ////////////////////////
3936     // Public functions
3937     ////////////////////////
3938 
3939     // says if state is final
3940     function finalized() public constant returns (bool);
3941 
3942     // says if state is success
3943     function success() public constant returns (bool);
3944 
3945     // says if state is failure
3946     function failed() public constant returns (bool);
3947 
3948     // currently committed funds
3949     function totalInvestment()
3950         public
3951         constant
3952         returns (
3953             uint256 totalEquivEurUlps,
3954             uint256 totalTokensInt,
3955             uint256 totalInvestors
3956         );
3957 
3958     /// commit function happens via ERC223 callback that must happen from trusted payment token
3959     /// @param investor address of the investor
3960     /// @param amount amount commited
3961     /// @param data may have meaning in particular ETO implementation
3962     function tokenFallback(address investor, uint256 amount, bytes data)
3963         public;
3964 
3965 }
3966 
3967 /// @title default interface of commitment process
3968 contract IETOCommitment is
3969     ICommitment,
3970     IETOCommitmentStates
3971 {
3972 
3973     ////////////////////////
3974     // Events
3975     ////////////////////////
3976 
3977     // on every state transition
3978     event LogStateTransition(
3979         uint32 oldState,
3980         uint32 newState,
3981         uint32 timestamp
3982     );
3983 
3984     /// on a claim by invester
3985     ///   `investor` claimed `amount` of `assetToken` and claimed `nmkReward` amount of NEU
3986     event LogTokensClaimed(
3987         address indexed investor,
3988         address indexed assetToken,
3989         uint256 amount,
3990         uint256 nmkReward
3991     );
3992 
3993     /// on a refund to investor
3994     ///   `investor` was refunded `amount` of `paymentToken`
3995     /// @dev may be raised multiple times per refund operation
3996     event LogFundsRefunded(
3997         address indexed investor,
3998         address indexed paymentToken,
3999         uint256 amount
4000     );
4001 
4002     // logged at the moment of Company setting terms
4003     event LogTermsSet(
4004         address companyLegalRep,
4005         address etoTerms,
4006         address equityToken
4007     );
4008 
4009     // logged at the moment Company sets/resets Whitelisting start date
4010     event LogETOStartDateSet(
4011         address companyLegalRep,
4012         uint256 previousTimestamp,
4013         uint256 newTimestamp
4014     );
4015 
4016     // logged at the moment Signing procedure starts
4017     event LogSigningStarted(
4018         address nominee,
4019         address companyLegalRep,
4020         uint256 newShares,
4021         uint256 capitalIncreaseEurUlps
4022     );
4023 
4024     // logged when company presents signed investment agreement
4025     event LogCompanySignedAgreement(
4026         address companyLegalRep,
4027         address nominee,
4028         string signedInvestmentAgreementUrl
4029     );
4030 
4031     // logged when nominee presents and verifies its copy of investment agreement
4032     event LogNomineeConfirmedAgreement(
4033         address nominee,
4034         address companyLegalRep,
4035         string signedInvestmentAgreementUrl
4036     );
4037 
4038     // logged on refund transition to mark destroyed tokens
4039     event LogRefundStarted(
4040         address assetToken,
4041         uint256 totalTokenAmountInt,
4042         uint256 totalRewardNmkUlps
4043     );
4044 
4045     ////////////////////////
4046     // Public functions
4047     ////////////////////////
4048 
4049     //
4050     // ETOState control
4051     //
4052 
4053     // returns current ETO state
4054     function state() public constant returns (ETOState);
4055 
4056     // returns start of given state
4057     function startOf(ETOState s) public constant returns (uint256);
4058 
4059     // returns commitment observer (typically equity token controller)
4060     function commitmentObserver() public constant returns (IETOCommitmentObserver);
4061 
4062     //
4063     // Commitment process
4064     //
4065 
4066     /// refunds investor if ETO failed
4067     function refund() external;
4068 
4069     function refundMany(address[] investors) external;
4070 
4071     /// claims tokens if ETO is a success
4072     function claim() external;
4073 
4074     function claimMany(address[] investors) external;
4075 
4076     // initiate fees payout
4077     function payout() external;
4078 
4079 
4080     //
4081     // Offering terms
4082     //
4083 
4084     function etoTerms() public constant returns (ETOTerms);
4085 
4086     // equity token
4087     function equityToken() public constant returns (IEquityToken);
4088 
4089     // nominee
4090     function nominee() public constant returns (address);
4091 
4092     function companyLegalRep() public constant returns (address);
4093 
4094     /// signed agreement as provided by company and nominee
4095     /// @dev available on Claim state transition
4096     function signedInvestmentAgreementUrl() public constant returns (string);
4097 
4098     /// financial outcome of token offering set on Signing state transition
4099     /// @dev in preceding states 0 is returned
4100     function contributionSummary()
4101         public
4102         constant
4103         returns (
4104             uint256 newShares, uint256 capitalIncreaseEurUlps,
4105             uint256 additionalContributionEth, uint256 additionalContributionEurUlps,
4106             uint256 tokenParticipationFeeInt, uint256 platformFeeEth, uint256 platformFeeEurUlps,
4107             uint256 sharePriceEurUlps
4108         );
4109 
4110     /// method to obtain current investors ticket
4111     function investorTicket(address investor)
4112         public
4113         constant
4114         returns (
4115             uint256 equivEurUlps,
4116             uint256 rewardNmkUlps,
4117             uint256 equityTokenInt,
4118             uint256 sharesInt,
4119             uint256 tokenPrice,
4120             uint256 neuRate,
4121             uint256 amountEth,
4122             uint256 amountEurUlps,
4123             bool claimOrRefundSettled,
4124             bool usedLockedAccount
4125         );
4126 }
4127 
4128 contract IControllerGovernance is
4129     IAgreement
4130 {
4131 
4132     ////////////////////////
4133     // Types
4134     ////////////////////////
4135 
4136     // defines state machine of the token controller which goes from I to T without loops
4137     enum GovState {
4138         Setup, // Initial state
4139         Offering, // primary token offering in progress
4140         Funded, // token offering succeeded, execution of shareholder rights possible
4141         Closing, // company is being closed
4142         Closed, // terminal state, company closed
4143         Migrated // terminal state, contract migrated
4144     }
4145 
4146     enum Action {
4147         None, // no on-chain action on resolution
4148         StopToken, // blocks transfers
4149         ContinueToken, // enables transfers
4150         CloseToken, // any liquidation: dissolution, tag, drag, exit (settlement time, amount eur, amount eth)
4151         Payout, // any dividend payout (amount eur, amount eth)
4152         RegisterOffer, // start new token offering
4153         ChangeTokenController, // (new token controller)
4154         AmendISHA, // for example off-chain investment (agreement url, new number of shares, new shareholder rights, new valuation eur)
4155         IssueTokensForExistingShares, // (number of converted shares, allocation (address => balance))
4156         ChangeNominee,
4157         Downround // results in issuance of new equity token and disbursing it to current token holders
4158     }
4159 
4160     ////////////////////////
4161     // Events
4162     ////////////////////////
4163 
4164     // logged on controller state transition
4165     event LogGovStateTransition(
4166         uint32 oldState,
4167         uint32 newState,
4168         uint32 timestamp
4169     );
4170 
4171     // logged on action that is a result of shareholder resolution (on-chain, off-chain), or should be shareholder resolution
4172     event LogResolutionExecuted(
4173         bytes32 resolutionId,
4174         Action action
4175     );
4176 
4177     // logged when transferability of given token was changed
4178     event LogTransfersStateChanged(
4179         bytes32 resolutionId,
4180         address equityToken,
4181         bool transfersEnabled
4182     );
4183 
4184     // logged when ISHA was amended (new text, new shareholders, new cap table, offline round etc.)
4185     event LogISHAAmended(
4186         bytes32 resolutionId,
4187         string ISHAUrl,
4188         uint256 totalShares,
4189         uint256 companyValuationEurUlps,
4190         address newShareholderRights
4191     );
4192 
4193     // offering of the token in ETO failed (Refund)
4194     event LogOfferingFailed(
4195         address etoCommitment,
4196         address equityToken
4197     );
4198 
4199     // offering of the token in ETO succeeded (with all on-chain consequences)
4200     event LogOfferingSucceeded(
4201         address etoCommitment,
4202         address equityToken,
4203         uint256 newShares
4204     );
4205 
4206     // logs when company issues official information to shareholders
4207     event LogGeneralInformation(
4208         address companyLegalRep,
4209         string informationType,
4210         string informationUrl
4211     );
4212 
4213     //
4214     event LogOfferingRegistered(
4215         bytes32 resolutionId,
4216         address etoCommitment,
4217         address equityToken
4218     );
4219 
4220     event LogMigratedTokenController(
4221         bytes32 resolutionId,
4222         address newController
4223     );
4224 
4225     ////////////////////////
4226     // Interface methods
4227     ////////////////////////
4228 
4229     // returns current state of the controller
4230     function state()
4231         public
4232         constant
4233         returns (GovState);
4234 
4235     // address of company legal representative able to sign agreements
4236     function companyLegalRepresentative()
4237         public
4238         constant
4239         returns (address);
4240 
4241     // return basic shareholder information
4242     function shareholderInformation()
4243         public
4244         constant
4245         returns (
4246             uint256 totalCompanyShares,
4247             uint256 companyValuationEurUlps,
4248             ShareholderRights shareholderRights
4249         );
4250 
4251     // returns cap table
4252     function capTable()
4253         public
4254         constant
4255         returns (
4256             address[] equityTokens,
4257             uint256[] shares
4258         );
4259 
4260     // returns all started offerings
4261     function tokenOfferings()
4262         public
4263         constant
4264         returns (
4265             address[] offerings,
4266             address[] equityTokens
4267         );
4268 
4269     // officially inform shareholders, can be quarterly report, yearly closing
4270     // @dev this can be called only by company wallet
4271     function issueGeneralInformation(
4272         string informationType,
4273         string informationUrl
4274     )
4275         public;
4276 
4277     // start new resolution vs shareholders. required due to General Information Rights even in case of no voting right
4278     // @dev payload in RLP encoded and will be parsed in the implementation
4279     // @dev this can be called only by company wallet
4280     function startResolution(string title, string resolutionUri, Action action, bytes payload)
4281         public
4282         returns (bytes32 resolutionId);
4283 
4284     // execute on-chain action of the given resolution if it has passed accordint to implemented governance
4285     function executeResolution(bytes32 resolutionId) public;
4286 
4287     // this will close company (transition to terminal state) and close all associated tokens
4288     // requires decision to be made before according to implemented governance
4289     // also requires that certain obligations are met like proceeds were distributed
4290     // so anyone should be able to call this function
4291     function closeCompany() public;
4292 
4293     // this will cancel closing of the company due to obligations not met in time
4294     // being able to cancel closing should not depend on who is calling the function.
4295     function cancelCompanyClosing() public;
4296 
4297     /// @notice replace current token controller
4298     /// @dev please note that this process is also controlled by existing controller so for example resolution may be required
4299     function changeTokenController(IControllerGovernance newController) public;
4300 
4301     // in Migrated state - an address of actual token controller
4302     /// @dev should return zero address on other states
4303     function newTokenController() public constant returns (address);
4304 
4305     // an address of previous controller (in Migrated state)
4306     /// @dev should return zero address if is the first controller
4307     function oldTokenController() public constant returns (address);
4308 }
4309 
4310 /// @title placeholder for on-chain company management
4311 /// several simplifications apply:
4312 ///   - there is just one (primary) offering. no more offerings may be executed
4313 ///   - transfer rights are executed as per ETO_TERMS
4314 ///   - general information rights are executed
4315 ///   - no other rights can be executed and no on-chain shareholder resolution results are in place
4316 ///   - allows changing to better token controller by company
4317 contract PlaceholderEquityTokenController is
4318     IEquityTokenController,
4319     IControllerGovernance,
4320     IContractId,
4321     Agreement,
4322     KnownInterfaces
4323 {
4324     ////////////////////////
4325     // Immutable state
4326     ////////////////////////
4327 
4328     // a root of trust contract
4329     Universe private UNIVERSE;
4330 
4331     // company representative address
4332     address private COMPANY_LEGAL_REPRESENTATIVE;
4333 
4334     // old token controller
4335     address private OLD_TOKEN_CONTROLLER;
4336 
4337     ////////////////////////
4338     // Mutable state
4339     ////////////////////////
4340 
4341     // controller lifecycle state
4342     GovState private _state;
4343 
4344     // total number of shares owned by Company
4345     uint256 private _totalCompanyShares;
4346 
4347     // valuation of the company
4348     uint256 private _companyValuationEurUlps;
4349 
4350     // set of shareholder rights that will be executed
4351     ShareholderRights private _shareholderRights;
4352 
4353     // new controller when migrating
4354     address private _newController;
4355 
4356     // equity token from ETO
4357     IEquityToken private _equityToken;
4358 
4359     // ETO contract
4360     address private _commitment;
4361 
4362     // are transfers on token enabled
4363     bool private _transfersEnabled;
4364 
4365     ////////////////////////
4366     // Modifiers
4367     ////////////////////////
4368 
4369     // require caller is ETO in universe
4370     modifier onlyUniverseETO() {
4371         require(UNIVERSE.isInterfaceCollectionInstance(KNOWN_INTERFACE_COMMITMENT, msg.sender), "NF_ETC_ETO_NOT_U");
4372         _;
4373     }
4374 
4375     modifier onlyCompany() {
4376         require(msg.sender == COMPANY_LEGAL_REPRESENTATIVE, "NF_ONLY_COMPANY");
4377         _;
4378     }
4379 
4380     modifier onlyOperational() {
4381         require(_state == GovState.Offering || _state == GovState.Funded || _state == GovState.Closing, "NF_INV_STATE");
4382         _;
4383     }
4384 
4385     modifier onlyState(GovState state) {
4386         require(_state == state, "NF_INV_STATE");
4387         _;
4388     }
4389 
4390     modifier onlyStates(GovState state1, GovState state2) {
4391         require(_state == state1 || _state == state2, "NF_INV_STATE");
4392         _;
4393     }
4394 
4395     ////////////////////////
4396     // Constructor
4397     ////////////////////////
4398 
4399     constructor(
4400         Universe universe,
4401         address companyLegalRep
4402     )
4403         public
4404         Agreement(universe.accessPolicy(), universe.forkArbiter())
4405     {
4406         UNIVERSE = universe;
4407         COMPANY_LEGAL_REPRESENTATIVE = companyLegalRep;
4408     }
4409 
4410     //
4411     // Implements IControllerGovernance
4412     //
4413 
4414     function state()
4415         public
4416         constant
4417         returns (GovState)
4418     {
4419         return _state;
4420     }
4421 
4422     function companyLegalRepresentative()
4423         public
4424         constant
4425         returns (address)
4426     {
4427         return COMPANY_LEGAL_REPRESENTATIVE;
4428     }
4429 
4430     function shareholderInformation()
4431         public
4432         constant
4433         returns (
4434             uint256 totalCompanyShares,
4435             uint256 companyValuationEurUlps,
4436             ShareholderRights shareholderRights
4437         )
4438     {
4439         return (
4440             _totalCompanyShares,
4441             _companyValuationEurUlps,
4442             _shareholderRights
4443         );
4444     }
4445 
4446     function capTable()
4447         public
4448         constant
4449         returns (
4450             address[] equityTokens,
4451             uint256[] shares
4452         )
4453     {
4454         // no cap table before ETO completed
4455         if (_state == GovState.Setup || _state == GovState.Offering) {
4456             return;
4457         }
4458         equityTokens = new address[](1);
4459         shares = new uint256[](1);
4460 
4461         equityTokens[0] = _equityToken;
4462         shares[0] = _equityToken.sharesTotalSupply();
4463     }
4464 
4465     function tokenOfferings()
4466         public
4467         constant
4468         returns (
4469             address[] offerings,
4470             address[] equityTokens
4471         )
4472     {
4473         // no offerings in setup mode
4474         if (_state == GovState.Setup) {
4475             return;
4476         }
4477         offerings = new address[](1);
4478         equityTokens = new address[](1);
4479 
4480         equityTokens[0] = _equityToken;
4481         offerings[0] = _commitment;
4482     }
4483 
4484     function issueGeneralInformation(
4485         string informationType,
4486         string informationUrl
4487     )
4488         public
4489         onlyOperational
4490         onlyCompany
4491     {
4492         // we emit this as Ethereum event, no need to store this in contract storage
4493         emit LogGeneralInformation(COMPANY_LEGAL_REPRESENTATIVE, informationType, informationUrl);
4494     }
4495 
4496     function startResolution(string /*title*/, string /*resolutionUri*/, Action /*action*/, bytes /*payload*/)
4497         public
4498         onlyStates(GovState.Offering, GovState.Funded)
4499         onlyCompany
4500         returns (bytes32 /*resolutionId*/)
4501     {
4502         revert("NF_NOT_IMPL");
4503     }
4504 
4505 
4506     function executeResolution(bytes32 /*resolutionId*/)
4507         public
4508         onlyOperational
4509     {
4510         revert("NF_NOT_IMPL");
4511     }
4512 
4513     function closeCompany()
4514         public
4515         onlyState(GovState.Closing)
4516     {
4517         revert("NF_NOT_IMPL");
4518     }
4519 
4520     function cancelCompanyClosing()
4521         public
4522         onlyState(GovState.Closing)
4523     {
4524         revert("NF_NOT_IMPL");
4525     }
4526 
4527     function changeTokenController(IControllerGovernance newController)
4528         public
4529         onlyStates(GovState.Funded, GovState.Closed)
4530         onlyCompany
4531     {
4532         require(newController != address(this));
4533         // must be migrated with us as a source
4534         require(newController.oldTokenController() == address(this), "NF_NOT_MIGRATED_FROM_US");
4535         _newController = newController;
4536         transitionTo(GovState.Migrated);
4537         emit LogResolutionExecuted(0, Action.ChangeTokenController);
4538         emit LogMigratedTokenController(0, newController);
4539     }
4540 
4541     function newTokenController()
4542         public
4543         constant
4544         returns (address)
4545     {
4546         // _newController is set only in Migrated state, otherwise zero address is returned as required
4547         return _newController;
4548     }
4549 
4550     function oldTokenController()
4551         public
4552         constant
4553         returns (address)
4554     {
4555         return OLD_TOKEN_CONTROLLER;
4556     }
4557 
4558     //
4559     // Implements ITokenController
4560     //
4561 
4562     function onTransfer(address broker, address from, address /*to*/, uint256 /*amount*/)
4563         public
4564         constant
4565         returns (bool allow)
4566     {
4567         return _transfersEnabled || (from == _commitment && broker == from);
4568     }
4569 
4570     /// always approve
4571     function onApprove(address, address, uint256)
4572         public
4573         constant
4574         returns (bool allow)
4575     {
4576         return true;
4577     }
4578 
4579     function onGenerateTokens(address sender, address, uint256)
4580         public
4581         constant
4582         returns (bool allow)
4583     {
4584         return sender == _commitment && _state == GovState.Offering;
4585     }
4586 
4587     function onDestroyTokens(address sender, address, uint256)
4588         public
4589         constant
4590         returns (bool allow)
4591     {
4592         return sender == _commitment && _state == GovState.Offering;
4593     }
4594 
4595     function onChangeTokenController(address /*sender*/, address newController)
4596         public
4597         constant
4598         returns (bool)
4599     {
4600         return newController == _newController;
4601     }
4602 
4603     // no forced transfers allowed in this controller
4604     function onAllowance(address /*owner*/, address /*spender*/)
4605         public
4606         constant
4607         returns (uint256)
4608     {
4609         return 0;
4610     }
4611 
4612     //
4613     // Implements IEquityTokenController
4614     //
4615 
4616     function onChangeNominee(address, address, address)
4617         public
4618         constant
4619         returns (bool)
4620     {
4621         return false;
4622     }
4623 
4624     //
4625     // IERC223TokenCallback (proceeds disbursal)
4626     //
4627 
4628     /// allows contract to receive and distribure proceeds
4629     function tokenFallback(address, uint256, bytes)
4630         public
4631     {
4632         revert("NF_NOT_IMPL");
4633     }
4634 
4635     //
4636     // Implements IETOCommitmentObserver
4637     //
4638 
4639     function commitmentObserver() public
4640         constant
4641         returns (address)
4642     {
4643         return _commitment;
4644     }
4645 
4646     function onStateTransition(ETOState, ETOState newState)
4647         public
4648         onlyUniverseETO
4649     {
4650         if (newState == ETOState.Whitelist) {
4651             require(_state == GovState.Setup, "NF_ETC_BAD_STATE");
4652             registerTokenOfferingPrivate(IETOCommitment(msg.sender));
4653             return;
4654         }
4655         // must be same eto that started offering
4656         require(msg.sender == _commitment, "NF_ETC_UNREG_COMMITMENT");
4657         if (newState == ETOState.Claim) {
4658             require(_state == GovState.Offering, "NF_ETC_BAD_STATE");
4659             aproveTokenOfferingPrivate(IETOCommitment(msg.sender));
4660         }
4661         if (newState == ETOState.Refund) {
4662             require(_state == GovState.Offering, "NF_ETC_BAD_STATE");
4663             failTokenOfferingPrivate(IETOCommitment(msg.sender));
4664         }
4665     }
4666 
4667     //
4668     // Implements IContractId
4669     //
4670 
4671     function contractId() public pure returns (bytes32 id, uint256 version) {
4672         return (0xf7e00d1a4168be33cbf27d32a37a5bc694b3a839684a8c2bef236e3594345d70, 1);
4673     }
4674 
4675     //
4676     // Other functions
4677     //
4678 
4679     function migrateTokenController(IControllerGovernance oldController, bool transfersEnables)
4680         public
4681         onlyState(GovState.Setup)
4682         onlyCompany
4683     {
4684         require(oldController.newTokenController() == address(0), "NF_OLD_CONTROLLED_ALREADY_MIGRATED");
4685         // migrate cap table
4686         (address[] memory equityTokens, ) = oldController.capTable();
4687         (address[] memory offerings, ) = oldController.tokenOfferings();
4688         // migrate ISHA
4689         (,,string memory ISHAUrl,) = oldController.currentAgreement();
4690         (
4691             _totalCompanyShares,
4692             _companyValuationEurUlps,
4693             _shareholderRights
4694         ) = oldController.shareholderInformation();
4695         _equityToken = IEquityToken(equityTokens[0]);
4696         _commitment = offerings[0];
4697         // set ISHA. use this.<> to call externally so msg.sender is correct in mCanAmend
4698         this.amendAgreement(ISHAUrl);
4699         // transfer flag may be changed during migration of the controller
4700         enableTransfers(transfersEnables);
4701         transitionTo(GovState.Funded);
4702         OLD_TOKEN_CONTROLLER = oldController;
4703     }
4704 
4705     ////////////////////////
4706     // Internal functions
4707     ////////////////////////
4708 
4709     function newOffering(IEquityToken equityToken, address tokenOffering)
4710         internal
4711     {
4712         _equityToken = equityToken;
4713         _commitment = tokenOffering;
4714 
4715         emit LogResolutionExecuted(0, Action.RegisterOffer);
4716         emit LogOfferingRegistered(0, tokenOffering, equityToken);
4717     }
4718 
4719     function amendISHA(
4720         string memory ISHAUrl,
4721         uint256 totalShares,
4722         uint256 companyValuationEurUlps,
4723         ShareholderRights newShareholderRights
4724     )
4725         internal
4726     {
4727         // set ISHA. use this.<> to call externally so msg.sender is correct in mCanAmend
4728         this.amendAgreement(ISHAUrl);
4729         // set new number of shares
4730         _totalCompanyShares = totalShares;
4731         // set new valuation
4732         _companyValuationEurUlps = companyValuationEurUlps;
4733         // set shareholder rights corresponding to SHA part of ISHA
4734         _shareholderRights = newShareholderRights;
4735         emit LogResolutionExecuted(0, Action.AmendISHA);
4736         emit LogISHAAmended(0, ISHAUrl, totalShares, companyValuationEurUlps, newShareholderRights);
4737     }
4738 
4739     function enableTransfers(bool transfersEnabled)
4740         internal
4741     {
4742         if (_transfersEnabled != transfersEnabled) {
4743             _transfersEnabled = transfersEnabled;
4744         }
4745         emit LogResolutionExecuted(0, transfersEnabled ? Action.ContinueToken : Action.StopToken);
4746         emit LogTransfersStateChanged(0, _equityToken, transfersEnabled);
4747     }
4748 
4749     function transitionTo(GovState newState)
4750         internal
4751     {
4752         emit LogGovStateTransition(uint32(_state), uint32(newState), uint32(block.timestamp));
4753         _state = newState;
4754     }
4755 
4756     //
4757     // Overrides Agreement
4758     //
4759 
4760     function mCanAmend(address legalRepresentative)
4761         internal
4762         returns (bool)
4763     {
4764         // only this contract can amend ISHA typically due to resolution
4765         return legalRepresentative == address(this);
4766     }
4767 
4768     ////////////////////////
4769     // Private functions
4770     ////////////////////////
4771 
4772     function registerTokenOfferingPrivate(IETOCommitment tokenOffering)
4773         private
4774     {
4775         IEquityToken equityToken = tokenOffering.equityToken();
4776         // require nominee match and agreement signature
4777         (address nomineeToken,,,) = equityToken.currentAgreement();
4778         // require token controller match
4779         require(equityToken.tokenController() == address(this), "NF_NDT_ET_TC_MIS");
4780         // require nominee and agreement match
4781         (address nomineOffering,,,) = tokenOffering.currentAgreement();
4782         require(nomineOffering == nomineeToken, "NF_NDT_ETO_A_MIS");
4783         // require terms set and legalRep match
4784         require(tokenOffering.etoTerms() != address(0), "NF_NDT_ETO_NO_TERMS");
4785         require(tokenOffering.companyLegalRep() == COMPANY_LEGAL_REPRESENTATIVE, "NF_NDT_ETO_LREP_MIS");
4786 
4787         newOffering(equityToken, tokenOffering);
4788         transitionTo(GovState.Offering);
4789     }
4790 
4791     function aproveTokenOfferingPrivate(IETOCommitment tokenOffering)
4792         private
4793     {
4794         // execute pending resolutions on completed ETO
4795         (uint256 newShares,,,,,,,) = tokenOffering.contributionSummary();
4796         uint256 totalShares = tokenOffering.etoTerms().EXISTING_COMPANY_SHARES() + newShares;
4797         uint256 marginalTokenPrice = tokenOffering.etoTerms().TOKEN_TERMS().TOKEN_PRICE_EUR_ULPS();
4798         string memory ISHAUrl = tokenOffering.signedInvestmentAgreementUrl();
4799         // set new ISHA, increase number of shares, company valuations and establish shareholder rights matrix
4800         amendISHA(
4801             ISHAUrl,
4802             totalShares,
4803             totalShares * marginalTokenPrice * tokenOffering.etoTerms().TOKEN_TERMS().EQUITY_TOKENS_PER_SHARE(),
4804             tokenOffering.etoTerms().SHAREHOLDER_RIGHTS()
4805         );
4806         // enable/disable transfers per ETO Terms
4807         enableTransfers(tokenOffering.etoTerms().ENABLE_TRANSFERS_ON_SUCCESS());
4808         // move state to funded
4809         transitionTo(GovState.Funded);
4810         emit LogOfferingSucceeded(tokenOffering, tokenOffering.equityToken(), newShares);
4811     }
4812 
4813     function failTokenOfferingPrivate(IETOCommitment tokenOffering)
4814         private
4815     {
4816         // we failed. may try again
4817         _equityToken = IEquityToken(0);
4818         _commitment = IETOCommitment(0);
4819         _totalCompanyShares = 0;
4820         _companyValuationEurUlps = 0;
4821         transitionTo(GovState.Setup);
4822         emit LogOfferingFailed(tokenOffering, tokenOffering.equityToken());
4823     }
4824 }