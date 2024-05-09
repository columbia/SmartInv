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
495 /// @title access to snapshots of a token
496 /// @notice allows to implement complex token holder rights like revenue disbursal or voting
497 /// @notice snapshots are series of values with assigned ids. ids increase strictly. particular id mechanism is not assumed
498 contract ITokenSnapshots {
499 
500     ////////////////////////
501     // Public functions
502     ////////////////////////
503 
504     /// @notice Total amount of tokens at a specific `snapshotId`.
505     /// @param snapshotId of snapshot at which totalSupply is queried
506     /// @return The total amount of tokens at `snapshotId`
507     /// @dev reverts on snapshotIds greater than currentSnapshotId()
508     /// @dev returns 0 for snapshotIds less than snapshotId of first value
509     function totalSupplyAt(uint256 snapshotId)
510         public
511         constant
512         returns(uint256);
513 
514     /// @dev Queries the balance of `owner` at a specific `snapshotId`
515     /// @param owner The address from which the balance will be retrieved
516     /// @param snapshotId of snapshot at which the balance is queried
517     /// @return The balance at `snapshotId`
518     function balanceOfAt(address owner, uint256 snapshotId)
519         public
520         constant
521         returns (uint256);
522 
523     /// @notice upper bound of series of snapshotIds for which there's a value in series
524     /// @return snapshotId
525     function currentSnapshotId()
526         public
527         constant
528         returns (uint256);
529 }
530 
531 /// @title represents link between cloned and parent token
532 /// @dev when token is clone from other token, initial balances of the cloned token
533 ///     correspond to balances of parent token at the moment of parent snapshot id specified
534 /// @notice please note that other tokens beside snapshot token may be cloned
535 contract IClonedTokenParent is ITokenSnapshots {
536 
537     ////////////////////////
538     // Public functions
539     ////////////////////////
540 
541 
542     /// @return address of parent token, address(0) if root
543     /// @dev parent token does not need to clonable, nor snapshottable, just a normal token
544     function parentToken()
545         public
546         constant
547         returns(IClonedTokenParent parent);
548 
549     /// @return snapshot at wchich initial token distribution was taken
550     function parentSnapshotId()
551         public
552         constant
553         returns(uint256 snapshotId);
554 }
555 
556 contract IBasicToken {
557 
558     ////////////////////////
559     // Events
560     ////////////////////////
561 
562     event Transfer(
563         address indexed from,
564         address indexed to,
565         uint256 amount
566     );
567 
568     ////////////////////////
569     // Public functions
570     ////////////////////////
571 
572     /// @dev This function makes it easy to get the total number of tokens
573     /// @return The total number of tokens
574     function totalSupply()
575         public
576         constant
577         returns (uint256);
578 
579     /// @param owner The address that's balance is being requested
580     /// @return The balance of `owner` at the current block
581     function balanceOf(address owner)
582         public
583         constant
584         returns (uint256 balance);
585 
586     /// @notice Send `amount` tokens to `to` from `msg.sender`
587     /// @param to The address of the recipient
588     /// @param amount The amount of tokens to be transferred
589     /// @return Whether the transfer was successful or not
590     function transfer(address to, uint256 amount)
591         public
592         returns (bool success);
593 
594 }
595 
596 contract IERC20Allowance {
597 
598     ////////////////////////
599     // Events
600     ////////////////////////
601 
602     event Approval(
603         address indexed owner,
604         address indexed spender,
605         uint256 amount
606     );
607 
608     ////////////////////////
609     // Public functions
610     ////////////////////////
611 
612     /// @dev This function makes it easy to read the `allowed[]` map
613     /// @param owner The address of the account that owns the token
614     /// @param spender The address of the account able to transfer the tokens
615     /// @return Amount of remaining tokens of owner that spender is allowed
616     ///  to spend
617     function allowance(address owner, address spender)
618         public
619         constant
620         returns (uint256 remaining);
621 
622     /// @notice `msg.sender` approves `spender` to spend `amount` tokens on
623     ///  its behalf. This is a modified version of the ERC20 approve function
624     ///  to be a little bit safer
625     /// @param spender The address of the account able to transfer the tokens
626     /// @param amount The amount of tokens to be approved for transfer
627     /// @return True if the approval was successful
628     function approve(address spender, uint256 amount)
629         public
630         returns (bool success);
631 
632     /// @notice Send `amount` tokens to `to` from `from` on the condition it
633     ///  is approved by `from`
634     /// @param from The address holding the tokens being transferred
635     /// @param to The address of the recipient
636     /// @param amount The amount of tokens to be transferred
637     /// @return True if the transfer was successful
638     function transferFrom(address from, address to, uint256 amount)
639         public
640         returns (bool success);
641 
642 }
643 
644 contract IERC20Token is IBasicToken, IERC20Allowance {
645 
646 }
647 
648 contract ITokenMetadata {
649 
650     ////////////////////////
651     // Public functions
652     ////////////////////////
653 
654     function symbol()
655         public
656         constant
657         returns (string);
658 
659     function name()
660         public
661         constant
662         returns (string);
663 
664     function decimals()
665         public
666         constant
667         returns (uint8);
668 }
669 
670 contract IERC223Token is IERC20Token, ITokenMetadata {
671 
672     /// @dev Departure: We do not log data, it has no advantage over a standard
673     ///     log event. By sticking to the standard log event we
674     ///     stay compatible with constracts that expect and ERC20 token.
675 
676     // event Transfer(
677     //    address indexed from,
678     //    address indexed to,
679     //    uint256 amount,
680     //    bytes data);
681 
682 
683     /// @dev Departure: We do not use the callback on regular transfer calls to
684     ///     stay compatible with constracts that expect and ERC20 token.
685 
686     // function transfer(address to, uint256 amount)
687     //     public
688     //     returns (bool);
689 
690     ////////////////////////
691     // Public functions
692     ////////////////////////
693 
694     function transfer(address to, uint256 amount, bytes data)
695         public
696         returns (bool);
697 }
698 
699 contract IERC677Allowance is IERC20Allowance {
700 
701     ////////////////////////
702     // Public functions
703     ////////////////////////
704 
705     /// @notice `msg.sender` approves `spender` to send `amount` tokens on
706     ///  its behalf, and then a function is triggered in the contract that is
707     ///  being approved, `spender`. This allows users to use their tokens to
708     ///  interact with contracts in one function call instead of two
709     /// @param spender The address of the contract able to transfer the tokens
710     /// @param amount The amount of tokens to be approved for transfer
711     /// @return True if the function call was successful
712     function approveAndCall(address spender, uint256 amount, bytes extraData)
713         public
714         returns (bool success);
715 
716 }
717 
718 contract IERC677Token is IERC20Token, IERC677Allowance {
719 }
720 
721 /// @title hooks token controller to token contract and allows to replace it
722 contract ITokenControllerHook {
723 
724     ////////////////////////
725     // Events
726     ////////////////////////
727 
728     event LogChangeTokenController(
729         address oldController,
730         address newController,
731         address by
732     );
733 
734     ////////////////////////
735     // Public functions
736     ////////////////////////
737 
738     /// @notice replace current token controller
739     /// @dev please note that this process is also controlled by existing controller
740     function changeTokenController(address newController)
741         public;
742 
743     /// @notice returns current controller
744     function tokenController()
745         public
746         constant
747         returns (address currentController);
748 
749 }
750 
751 /// @title state space of ETOCommitment
752 contract IETOCommitmentStates {
753     ////////////////////////
754     // Types
755     ////////////////////////
756 
757     // order must reflect time precedence, do not change order below
758     enum ETOState {
759         Setup, // Initial state
760         Whitelist,
761         Public,
762         Signing,
763         Claim,
764         Payout, // Terminal state
765         Refund // Terminal state
766     }
767 
768     // number of states in enum
769     uint256 constant internal ETO_STATES_COUNT = 7;
770 }
771 
772 /// @title provides callback on state transitions
773 /// @dev observer called after the state() of commitment contract was set
774 contract IETOCommitmentObserver is IETOCommitmentStates {
775     function commitmentObserver() public constant returns (address);
776     function onStateTransition(ETOState oldState, ETOState newState) public;
777 }
778 
779 /// @title current ERC223 fallback function
780 /// @dev to be used in all future token contract
781 /// @dev NEU and ICBMEtherToken (obsolete) are the only contracts that still uses IERC223LegacyCallback
782 contract IERC223Callback {
783 
784     ////////////////////////
785     // Public functions
786     ////////////////////////
787 
788     function tokenFallback(address from, uint256 amount, bytes data)
789         public;
790 
791 }
792 
793 /// @title granular token controller based on MSnapshotToken observer pattern
794 contract ITokenController {
795 
796     ////////////////////////
797     // Public functions
798     ////////////////////////
799 
800     /// @notice see MTokenTransferController
801     /// @dev additionally passes broker that is executing transaction between from and to
802     ///      for unbrokered transfer, broker == from
803     function onTransfer(address broker, address from, address to, uint256 amount)
804         public
805         constant
806         returns (bool allow);
807 
808     /// @notice see MTokenAllowanceController
809     function onApprove(address owner, address spender, uint256 amount)
810         public
811         constant
812         returns (bool allow);
813 
814     /// @notice see MTokenMint
815     function onGenerateTokens(address sender, address owner, uint256 amount)
816         public
817         constant
818         returns (bool allow);
819 
820     /// @notice see MTokenMint
821     function onDestroyTokens(address sender, address owner, uint256 amount)
822         public
823         constant
824         returns (bool allow);
825 
826     /// @notice controls if sender can change controller to newController
827     /// @dev for this to succeed TYPICALLY current controller must be already migrated to a new one
828     function onChangeTokenController(address sender, address newController)
829         public
830         constant
831         returns (bool);
832 
833     /// @notice overrides spender allowance
834     /// @dev may be used to implemented forced transfers in which token controller may override approved allowance
835     ///      with any > 0 value and then use transferFrom to execute such transfer
836     ///      This by definition creates non-trustless token so do not implement this call if you do not need trustless transfers!
837     ///      Implementer should not allow approve() to be executed if there is an overrride
838     //       Implemented should return allowance() taking into account override
839     function onAllowance(address owner, address spender)
840         public
841         constant
842         returns (uint256 allowanceOverride);
843 }
844 
845 contract IEquityTokenController is
846     IAgreement,
847     ITokenController,
848     IETOCommitmentObserver,
849     IERC223Callback
850 {
851     /// controls if sender can change old nominee to new nominee
852     /// @dev for this to succeed typically a voting of the token holders should happen and new nominee should be set
853     function onChangeNominee(address sender, address oldNominee, address newNominee)
854         public
855         constant
856         returns (bool);
857 }
858 
859 contract IEquityToken is
860     IAgreement,
861     IClonedTokenParent,
862     IERC223Token,
863     ITokenControllerHook
864 {
865     /// @dev equity token is not divisible (Decimals == 0) but single share is represented by
866     ///  tokensPerShare tokens
867     function tokensPerShare() public constant returns (uint256);
868 
869     // number of shares represented by tokens. we round to the closest value.
870     function sharesTotalSupply() public constant returns (uint256);
871 
872     /// nominal value of a share in EUR decimal(18) precision
873     function shareNominalValueEurUlps() public constant returns (uint256);
874 
875     // returns company legal representative account that never changes
876     function companyLegalRepresentative() public constant returns (address);
877 
878     /// returns current nominee which is contract legal rep
879     function nominee() public constant returns (address);
880 
881     /// only by previous nominee
882     function changeNominee(address newNominee) public;
883 
884     /// controlled, always issues to msg.sender
885     function issueTokens(uint256 amount) public;
886 
887     /// controlled, may send tokens even when transfer are disabled: to active ETO only
888     function distributeTokens(address to, uint256 amount) public;
889 
890     // controlled, msg.sender is typically failed ETO
891     function destroyTokens(uint256 amount) public;
892 }
893 
894 /// @title describes layout of claims in 256bit records stored for identities
895 /// @dev intended to be derived by contracts requiring access to particular claims
896 contract IdentityRecord {
897 
898     ////////////////////////
899     // Types
900     ////////////////////////
901 
902     /// @dev here the idea is to have claims of size of uint256 and use this struct
903     ///     to translate in and out of this struct. until we do not cross uint256 we
904     ///     have binary compatibility
905     struct IdentityClaims {
906         bool isVerified; // 1 bit
907         bool isSophisticatedInvestor; // 1 bit
908         bool hasBankAccount; // 1 bit
909         bool accountFrozen; // 1 bit
910         // uint252 reserved
911     }
912 
913     ////////////////////////
914     // Internal functions
915     ////////////////////////
916 
917     /// translates uint256 to struct
918     function deserializeClaims(bytes32 data) internal pure returns (IdentityClaims memory claims) {
919         // for memory layout of struct, each field below word length occupies whole word
920         assembly {
921             mstore(claims, and(data, 0x1))
922             mstore(add(claims, 0x20), div(and(data, 0x2), 0x2))
923             mstore(add(claims, 0x40), div(and(data, 0x4), 0x4))
924             mstore(add(claims, 0x60), div(and(data, 0x8), 0x8))
925         }
926     }
927 }
928 
929 
930 /// @title interface storing and retrieve 256bit claims records for identity
931 /// actual format of record is decoupled from storage (except maximum size)
932 contract IIdentityRegistry {
933 
934     ////////////////////////
935     // Events
936     ////////////////////////
937 
938     /// provides information on setting claims
939     event LogSetClaims(
940         address indexed identity,
941         bytes32 oldClaims,
942         bytes32 newClaims
943     );
944 
945     ////////////////////////
946     // Public functions
947     ////////////////////////
948 
949     /// get claims for identity
950     function getClaims(address identity) public constant returns (bytes32);
951 
952     /// set claims for identity
953     /// @dev odlClaims and newClaims used for optimistic locking. to override with newClaims
954     ///     current claims must be oldClaims
955     function setClaims(address identity, bytes32 oldClaims, bytes32 newClaims) public;
956 }
957 
958 /// @title known interfaces (services) of the platform
959 /// "known interface" is a unique id of service provided by the platform and discovered via Universe contract
960 ///  it does not refer to particular contract/interface ABI, particular service may be delivered via different implementations
961 ///  however for a few contracts we commit platform to particular implementation (all ICBM Contracts, Universe itself etc.)
962 /// @dev constants are kept in CODE not in STORAGE so they are comparatively cheap
963 contract KnownInterfaces {
964 
965     ////////////////////////
966     // Constants
967     ////////////////////////
968 
969     // NOTE: All interface are set to the keccak256 hash of the
970     // CamelCased interface or singleton name, i.e.
971     // KNOWN_INTERFACE_NEUMARK = keccak256("Neumark")
972 
973     // EIP 165 + EIP 820 should be use instead but it seems they are far from finished
974     // also interface signature should be build automatically by solidity. otherwise it is a pure hassle
975 
976     // neumark token interface and sigleton keccak256("Neumark")
977     bytes4 internal constant KNOWN_INTERFACE_NEUMARK = 0xeb41a1bd;
978 
979     // ether token interface and singleton keccak256("EtherToken")
980     bytes4 internal constant KNOWN_INTERFACE_ETHER_TOKEN = 0x8cf73cf1;
981 
982     // euro token interface and singleton keccak256("EuroToken")
983     bytes4 internal constant KNOWN_INTERFACE_EURO_TOKEN = 0x83c3790b;
984 
985     // identity registry interface and singleton keccak256("IIdentityRegistry")
986     bytes4 internal constant KNOWN_INTERFACE_IDENTITY_REGISTRY = 0x0a72e073;
987 
988     // currency rates oracle interface and singleton keccak256("ITokenExchangeRateOracle")
989     bytes4 internal constant KNOWN_INTERFACE_TOKEN_EXCHANGE_RATE_ORACLE = 0xc6e5349e;
990 
991     // fee disbursal interface and singleton keccak256("IFeeDisbursal")
992     bytes4 internal constant KNOWN_INTERFACE_FEE_DISBURSAL = 0xf4c848e8;
993 
994     // platform portfolio holding equity tokens belonging to NEU holders keccak256("IPlatformPortfolio");
995     bytes4 internal constant KNOWN_INTERFACE_PLATFORM_PORTFOLIO = 0xaa1590d0;
996 
997     // token exchange interface and singleton keccak256("ITokenExchange")
998     bytes4 internal constant KNOWN_INTERFACE_TOKEN_EXCHANGE = 0xddd7a521;
999 
1000     // service exchanging euro token for gas ("IGasTokenExchange")
1001     bytes4 internal constant KNOWN_INTERFACE_GAS_EXCHANGE = 0x89dbc6de;
1002 
1003     // access policy interface and singleton keccak256("IAccessPolicy")
1004     bytes4 internal constant KNOWN_INTERFACE_ACCESS_POLICY = 0xb05049d9;
1005 
1006     // euro lock account (upgraded) keccak256("LockedAccount:Euro")
1007     bytes4 internal constant KNOWN_INTERFACE_EURO_LOCK = 0x2347a19e;
1008 
1009     // ether lock account (upgraded) keccak256("LockedAccount:Ether")
1010     bytes4 internal constant KNOWN_INTERFACE_ETHER_LOCK = 0x978a6823;
1011 
1012     // icbm euro lock account keccak256("ICBMLockedAccount:Euro")
1013     bytes4 internal constant KNOWN_INTERFACE_ICBM_EURO_LOCK = 0x36021e14;
1014 
1015     // ether lock account (upgraded) keccak256("ICBMLockedAccount:Ether")
1016     bytes4 internal constant KNOWN_INTERFACE_ICBM_ETHER_LOCK = 0x0b58f006;
1017 
1018     // ether token interface and singleton keccak256("ICBMEtherToken")
1019     bytes4 internal constant KNOWN_INTERFACE_ICBM_ETHER_TOKEN = 0xae8b50b9;
1020 
1021     // euro token interface and singleton keccak256("ICBMEuroToken")
1022     bytes4 internal constant KNOWN_INTERFACE_ICBM_EURO_TOKEN = 0xc2c6cd72;
1023 
1024     // ICBM commitment interface interface and singleton keccak256("ICBMCommitment")
1025     bytes4 internal constant KNOWN_INTERFACE_ICBM_COMMITMENT = 0x7f2795ef;
1026 
1027     // ethereum fork arbiter interface and singleton keccak256("IEthereumForkArbiter")
1028     bytes4 internal constant KNOWN_INTERFACE_FORK_ARBITER = 0x2fe7778c;
1029 
1030     // Platform terms interface and singletong keccak256("PlatformTerms")
1031     bytes4 internal constant KNOWN_INTERFACE_PLATFORM_TERMS = 0x75ecd7f8;
1032 
1033     // for completness we define Universe service keccak256("Universe");
1034     bytes4 internal constant KNOWN_INTERFACE_UNIVERSE = 0xbf202454;
1035 
1036     // ETO commitment interface (collection) keccak256("ICommitment")
1037     bytes4 internal constant KNOWN_INTERFACE_COMMITMENT = 0xfa0e0c60;
1038 
1039     // Equity Token Controller interface (collection) keccak256("IEquityTokenController")
1040     bytes4 internal constant KNOWN_INTERFACE_EQUITY_TOKEN_CONTROLLER = 0xfa30b2f1;
1041 
1042     // Equity Token interface (collection) keccak256("IEquityToken")
1043     bytes4 internal constant KNOWN_INTERFACE_EQUITY_TOKEN = 0xab9885bb;
1044 }
1045 
1046 /// @notice implemented in the contract that is the target of state migration
1047 /// @dev implementation must provide actual function that will be called by source to migrate state
1048 contract IMigrationTarget {
1049 
1050     ////////////////////////
1051     // Public functions
1052     ////////////////////////
1053 
1054     // should return migration source address
1055     function currentMigrationSource()
1056         public
1057         constant
1058         returns (address);
1059 }
1060 
1061 /// @notice implemented in the contract that stores state to be migrated
1062 /// @notice contract is called migration source
1063 /// @dev migration target implements IMigrationTarget interface, when it is passed in 'enableMigration' function
1064 /// @dev 'migrate' function may be called to migrate part of state owned by msg.sender
1065 /// @dev in legal terms this corresponds to amending/changing agreement terms by co-signature of parties
1066 contract IMigrationSource {
1067 
1068     ////////////////////////
1069     // Events
1070     ////////////////////////
1071 
1072     event LogMigrationEnabled(
1073         address target
1074     );
1075 
1076     ////////////////////////
1077     // Public functions
1078     ////////////////////////
1079 
1080     /// @notice should migrate state owned by msg.sender
1081     /// @dev intended flow is to: read source state, clear source state, call migrate function on target, log success event
1082     function migrate()
1083         public;
1084 
1085     /// @notice should enable migration to migration target
1086     /// @dev should limit access to specific role in implementation
1087     function enableMigration(IMigrationTarget migration)
1088         public;
1089 
1090     /// @notice returns current migration target
1091     function currentMigrationTarget()
1092         public
1093         constant
1094         returns (IMigrationTarget);
1095 }
1096 
1097 /// @notice mixin that enables migration pattern for a contract
1098 /// @dev when derived from
1099 contract MigrationSource is
1100     IMigrationSource,
1101     AccessControlled
1102 {
1103     ////////////////////////
1104     // Immutable state
1105     ////////////////////////
1106 
1107     /// stores role hash that can enable migration
1108     bytes32 private MIGRATION_ADMIN;
1109 
1110     ////////////////////////
1111     // Mutable state
1112     ////////////////////////
1113 
1114     // migration target contract
1115     IMigrationTarget internal _migration;
1116 
1117     ////////////////////////
1118     // Modifiers
1119     ////////////////////////
1120 
1121     /// @notice add to enableMigration function to prevent changing of migration
1122     ///     target once set
1123     modifier onlyMigrationEnabledOnce() {
1124         require(address(_migration) == 0);
1125         _;
1126     }
1127 
1128     modifier onlyMigrationEnabled() {
1129         require(address(_migration) != 0);
1130         _;
1131     }
1132 
1133     ////////////////////////
1134     // Constructor
1135     ////////////////////////
1136 
1137     constructor(
1138         IAccessPolicy policy,
1139         bytes32 migrationAdminRole
1140     )
1141         AccessControlled(policy)
1142         internal
1143     {
1144         MIGRATION_ADMIN = migrationAdminRole;
1145     }
1146 
1147     ////////////////////////
1148     // Public functions
1149     ////////////////////////
1150 
1151     /// @notice should migrate state that belongs to msg.sender
1152     /// @dev do not forget to add accessor `onlyMigrationEnabled` modifier in implementation
1153     function migrate()
1154         public;
1155 
1156     /// @notice should enable migration to migration target
1157     /// @dev do not forget to add accessor modifier in override
1158     function enableMigration(IMigrationTarget migration)
1159         public
1160         onlyMigrationEnabledOnce()
1161         only(MIGRATION_ADMIN)
1162     {
1163         // this must be the source
1164         require(migration.currentMigrationSource() == address(this));
1165         _migration = migration;
1166         emit LogMigrationEnabled(_migration);
1167     }
1168 
1169     /// @notice returns current migration target
1170     function currentMigrationTarget()
1171         public
1172         constant
1173         returns (IMigrationTarget)
1174     {
1175         return _migration;
1176     }
1177 }
1178 
1179 contract IsContract {
1180 
1181     ////////////////////////
1182     // Internal functions
1183     ////////////////////////
1184 
1185     function isContract(address addr)
1186         internal
1187         constant
1188         returns (bool)
1189     {
1190         uint256 size;
1191         // takes 700 gas
1192         assembly { size := extcodesize(addr) }
1193         return size > 0;
1194     }
1195 }
1196 
1197 /// @title allows deriving contract to recover any token or ether that it has balance of
1198 /// @notice note that this opens your contracts to claims from various people saying they lost tokens and they want them back
1199 ///     be ready to handle such claims
1200 /// @dev use with care!
1201 ///     1. ROLE_RECLAIMER is allowed to claim tokens, it's not returning tokens to original owner
1202 ///     2. in derived contract that holds any token by design you must override `reclaim` and block such possibility.
1203 ///         see ICBMLockedAccount as an example
1204 contract Reclaimable is AccessControlled, AccessRoles {
1205 
1206     ////////////////////////
1207     // Constants
1208     ////////////////////////
1209 
1210     IBasicToken constant internal RECLAIM_ETHER = IBasicToken(0x0);
1211 
1212     ////////////////////////
1213     // Public functions
1214     ////////////////////////
1215 
1216     function reclaim(IBasicToken token)
1217         public
1218         only(ROLE_RECLAIMER)
1219     {
1220         address reclaimer = msg.sender;
1221         if(token == RECLAIM_ETHER) {
1222             reclaimer.transfer(address(this).balance);
1223         } else {
1224             uint256 balance = token.balanceOf(this);
1225             require(token.transfer(reclaimer, balance));
1226         }
1227     }
1228 }
1229 
1230 /// @title adds token metadata to token contract
1231 /// @dev see Neumark for example implementation
1232 contract TokenMetadata is ITokenMetadata {
1233 
1234     ////////////////////////
1235     // Immutable state
1236     ////////////////////////
1237 
1238     // The Token's name: e.g. DigixDAO Tokens
1239     string private NAME;
1240 
1241     // An identifier: e.g. REP
1242     string private SYMBOL;
1243 
1244     // Number of decimals of the smallest unit
1245     uint8 private DECIMALS;
1246 
1247     // An arbitrary versioning scheme
1248     string private VERSION;
1249 
1250     ////////////////////////
1251     // Constructor
1252     ////////////////////////
1253 
1254     /// @notice Constructor to set metadata
1255     /// @param tokenName Name of the new token
1256     /// @param decimalUnits Number of decimals of the new token
1257     /// @param tokenSymbol Token Symbol for the new token
1258     /// @param version Token version ie. when cloning is used
1259     constructor(
1260         string tokenName,
1261         uint8 decimalUnits,
1262         string tokenSymbol,
1263         string version
1264     )
1265         public
1266     {
1267         NAME = tokenName;                                 // Set the name
1268         SYMBOL = tokenSymbol;                             // Set the symbol
1269         DECIMALS = decimalUnits;                          // Set the decimals
1270         VERSION = version;
1271     }
1272 
1273     ////////////////////////
1274     // Public functions
1275     ////////////////////////
1276 
1277     function name()
1278         public
1279         constant
1280         returns (string)
1281     {
1282         return NAME;
1283     }
1284 
1285     function symbol()
1286         public
1287         constant
1288         returns (string)
1289     {
1290         return SYMBOL;
1291     }
1292 
1293     function decimals()
1294         public
1295         constant
1296         returns (uint8)
1297     {
1298         return DECIMALS;
1299     }
1300 
1301     function version()
1302         public
1303         constant
1304         returns (string)
1305     {
1306         return VERSION;
1307     }
1308 }
1309 
1310 /// @title controls spending approvals
1311 /// @dev TokenAllowance observes this interface, Neumark contract implements it
1312 contract MTokenAllowanceController {
1313 
1314     ////////////////////////
1315     // Internal functions
1316     ////////////////////////
1317 
1318     /// @notice Notifies the controller about an approval allowing the
1319     ///  controller to react if desired
1320     /// @param owner The address that calls `approve()`
1321     /// @param spender The spender in the `approve()` call
1322     /// @param amount The amount in the `approve()` call
1323     /// @return False if the controller does not authorize the approval
1324     function mOnApprove(
1325         address owner,
1326         address spender,
1327         uint256 amount
1328     )
1329         internal
1330         returns (bool allow);
1331 
1332     /// @notice Allows to override allowance approved by the owner
1333     ///         Primary role is to enable forced transfers, do not override if you do not like it
1334     ///         Following behavior is expected in the observer
1335     ///         approve() - should revert if mAllowanceOverride() > 0
1336     ///         allowance() - should return mAllowanceOverride() if set
1337     ///         transferFrom() - should override allowance if mAllowanceOverride() > 0
1338     /// @param owner An address giving allowance to spender
1339     /// @param spender An address getting  a right to transfer allowance amount from the owner
1340     /// @return current allowance amount
1341     function mAllowanceOverride(
1342         address owner,
1343         address spender
1344     )
1345         internal
1346         constant
1347         returns (uint256 allowance);
1348 }
1349 
1350 /// @title controls token transfers
1351 /// @dev BasicSnapshotToken observes this interface, Neumark contract implements it
1352 contract MTokenTransferController {
1353 
1354     ////////////////////////
1355     // Internal functions
1356     ////////////////////////
1357 
1358     /// @notice Notifies the controller about a token transfer allowing the
1359     ///  controller to react if desired
1360     /// @param from The origin of the transfer
1361     /// @param to The destination of the transfer
1362     /// @param amount The amount of the transfer
1363     /// @return False if the controller does not authorize the transfer
1364     function mOnTransfer(
1365         address from,
1366         address to,
1367         uint256 amount
1368     )
1369         internal
1370         returns (bool allow);
1371 
1372 }
1373 
1374 /// @title controls approvals and transfers
1375 /// @dev The token controller contract must implement these functions, see Neumark as example
1376 /// @dev please note that controller may be a separate contract that is called from mOnTransfer and mOnApprove functions
1377 contract MTokenController is MTokenTransferController, MTokenAllowanceController {
1378 }
1379 
1380 contract TrustlessTokenController is
1381     MTokenController
1382 {
1383     ////////////////////////
1384     // Internal functions
1385     ////////////////////////
1386 
1387     //
1388     // Implements MTokenController
1389     //
1390 
1391     function mOnTransfer(
1392         address /*from*/,
1393         address /*to*/,
1394         uint256 /*amount*/
1395     )
1396         internal
1397         returns (bool allow)
1398     {
1399         return true;
1400     }
1401 
1402     function mOnApprove(
1403         address /*owner*/,
1404         address /*spender*/,
1405         uint256 /*amount*/
1406     )
1407         internal
1408         returns (bool allow)
1409     {
1410         return true;
1411     }
1412 }
1413 
1414 contract IERC677Callback {
1415 
1416     ////////////////////////
1417     // Public functions
1418     ////////////////////////
1419 
1420     // NOTE: This call can be initiated by anyone. You need to make sure that
1421     // it is send by the token (`require(msg.sender == token)`) or make sure
1422     // amount is valid (`require(token.allowance(this) >= amount)`).
1423     function receiveApproval(
1424         address from,
1425         uint256 amount,
1426         address token, // IERC667Token
1427         bytes data
1428     )
1429         public
1430         returns (bool success);
1431 
1432 }
1433 
1434 contract Math {
1435 
1436     ////////////////////////
1437     // Internal functions
1438     ////////////////////////
1439 
1440     // absolute difference: |v1 - v2|
1441     function absDiff(uint256 v1, uint256 v2)
1442         internal
1443         pure
1444         returns(uint256)
1445     {
1446         return v1 > v2 ? v1 - v2 : v2 - v1;
1447     }
1448 
1449     // divide v by d, round up if remainder is 0.5 or more
1450     function divRound(uint256 v, uint256 d)
1451         internal
1452         pure
1453         returns(uint256)
1454     {
1455         return add(v, d/2) / d;
1456     }
1457 
1458     // computes decimal decimalFraction 'frac' of 'amount' with maximum precision (multiplication first)
1459     // both amount and decimalFraction must have 18 decimals precision, frac 10**18 represents a whole (100% of) amount
1460     // mind loss of precision as decimal fractions do not have finite binary expansion
1461     // do not use instead of division
1462     function decimalFraction(uint256 amount, uint256 frac)
1463         internal
1464         pure
1465         returns(uint256)
1466     {
1467         // it's like 1 ether is 100% proportion
1468         return proportion(amount, frac, 10**18);
1469     }
1470 
1471     // computes part/total of amount with maximum precision (multiplication first)
1472     // part and total must have the same units
1473     function proportion(uint256 amount, uint256 part, uint256 total)
1474         internal
1475         pure
1476         returns(uint256)
1477     {
1478         return divRound(mul(amount, part), total);
1479     }
1480 
1481     //
1482     // Open Zeppelin Math library below
1483     //
1484 
1485     function mul(uint256 a, uint256 b)
1486         internal
1487         pure
1488         returns (uint256)
1489     {
1490         uint256 c = a * b;
1491         assert(a == 0 || c / a == b);
1492         return c;
1493     }
1494 
1495     function sub(uint256 a, uint256 b)
1496         internal
1497         pure
1498         returns (uint256)
1499     {
1500         assert(b <= a);
1501         return a - b;
1502     }
1503 
1504     function add(uint256 a, uint256 b)
1505         internal
1506         pure
1507         returns (uint256)
1508     {
1509         uint256 c = a + b;
1510         assert(c >= a);
1511         return c;
1512     }
1513 
1514     function min(uint256 a, uint256 b)
1515         internal
1516         pure
1517         returns (uint256)
1518     {
1519         return a < b ? a : b;
1520     }
1521 
1522     function max(uint256 a, uint256 b)
1523         internal
1524         pure
1525         returns (uint256)
1526     {
1527         return a > b ? a : b;
1528     }
1529 }
1530 
1531 /// @title internal token transfer function
1532 /// @dev see BasicSnapshotToken for implementation
1533 contract MTokenTransfer {
1534 
1535     ////////////////////////
1536     // Internal functions
1537     ////////////////////////
1538 
1539     /// @dev This is the actual transfer function in the token contract, it can
1540     ///  only be called by other functions in this contract.
1541     /// @param from The address holding the tokens being transferred
1542     /// @param to The address of the recipient
1543     /// @param amount The amount of tokens to be transferred
1544     /// @dev  reverts if transfer was not successful
1545     function mTransfer(
1546         address from,
1547         address to,
1548         uint256 amount
1549     )
1550         internal;
1551 }
1552 
1553 /**
1554  * @title Basic token
1555  * @dev Basic version of StandardToken, with no allowances.
1556  */
1557 contract BasicToken is
1558     MTokenTransfer,
1559     MTokenTransferController,
1560     IBasicToken,
1561     Math
1562 {
1563 
1564     ////////////////////////
1565     // Mutable state
1566     ////////////////////////
1567 
1568     mapping(address => uint256) internal _balances;
1569 
1570     uint256 internal _totalSupply;
1571 
1572     ////////////////////////
1573     // Public functions
1574     ////////////////////////
1575 
1576     /**
1577     * @dev transfer token for a specified address
1578     * @param to The address to transfer to.
1579     * @param amount The amount to be transferred.
1580     */
1581     function transfer(address to, uint256 amount)
1582         public
1583         returns (bool)
1584     {
1585         mTransfer(msg.sender, to, amount);
1586         return true;
1587     }
1588 
1589     /// @dev This function makes it easy to get the total number of tokens
1590     /// @return The total number of tokens
1591     function totalSupply()
1592         public
1593         constant
1594         returns (uint256)
1595     {
1596         return _totalSupply;
1597     }
1598 
1599     /**
1600     * @dev Gets the balance of the specified address.
1601     * @param owner The address to query the the balance of.
1602     * @return An uint256 representing the amount owned by the passed address.
1603     */
1604     function balanceOf(address owner)
1605         public
1606         constant
1607         returns (uint256 balance)
1608     {
1609         return _balances[owner];
1610     }
1611 
1612     ////////////////////////
1613     // Internal functions
1614     ////////////////////////
1615 
1616     //
1617     // Implements MTokenTransfer
1618     //
1619 
1620     function mTransfer(address from, address to, uint256 amount)
1621         internal
1622     {
1623         require(to != address(0));
1624         require(mOnTransfer(from, to, amount));
1625 
1626         _balances[from] = sub(_balances[from], amount);
1627         _balances[to] = add(_balances[to], amount);
1628         emit Transfer(from, to, amount);
1629     }
1630 }
1631 
1632 /// @title token spending approval and transfer
1633 /// @dev implements token approval and transfers and exposes relevant part of ERC20 and ERC677 approveAndCall
1634 ///     may be mixed in with any basic token (implementing mTransfer) like BasicSnapshotToken or MintableSnapshotToken to add approval mechanism
1635 ///     observes MTokenAllowanceController interface
1636 ///     observes MTokenTransfer
1637 contract TokenAllowance is
1638     MTokenTransfer,
1639     MTokenAllowanceController,
1640     IERC20Allowance,
1641     IERC677Token
1642 {
1643 
1644     ////////////////////////
1645     // Mutable state
1646     ////////////////////////
1647 
1648     // `allowed` tracks rights to spends others tokens as per ERC20
1649     // owner => spender => amount
1650     mapping (address => mapping (address => uint256)) private _allowed;
1651 
1652     ////////////////////////
1653     // Constructor
1654     ////////////////////////
1655 
1656     constructor()
1657         internal
1658     {
1659     }
1660 
1661     ////////////////////////
1662     // Public functions
1663     ////////////////////////
1664 
1665     //
1666     // Implements IERC20Token
1667     //
1668 
1669     /// @dev This function makes it easy to read the `allowed[]` map
1670     /// @param owner The address of the account that owns the token
1671     /// @param spender The address of the account able to transfer the tokens
1672     /// @return Amount of remaining tokens of _owner that _spender is allowed
1673     ///  to spend
1674     function allowance(address owner, address spender)
1675         public
1676         constant
1677         returns (uint256 remaining)
1678     {
1679         uint256 override = mAllowanceOverride(owner, spender);
1680         if (override > 0) {
1681             return override;
1682         }
1683         return _allowed[owner][spender];
1684     }
1685 
1686     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
1687     ///  its behalf. This is a modified version of the ERC20 approve function
1688     ///  where allowance per spender must be 0 to allow change of such allowance
1689     /// @param spender The address of the account able to transfer the tokens
1690     /// @param amount The amount of tokens to be approved for transfer
1691     /// @return True or reverts, False is never returned
1692     function approve(address spender, uint256 amount)
1693         public
1694         returns (bool success)
1695     {
1696         // Alerts the token controller of the approve function call
1697         require(mOnApprove(msg.sender, spender, amount));
1698 
1699         // To change the approve amount you first have to reduce the addresses`
1700         //  allowance to zero by calling `approve(_spender,0)` if it is not
1701         //  already 0 to mitigate the race condition described here:
1702         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1703         require((amount == 0 || _allowed[msg.sender][spender] == 0) && mAllowanceOverride(msg.sender, spender) == 0);
1704 
1705         _allowed[msg.sender][spender] = amount;
1706         emit Approval(msg.sender, spender, amount);
1707         return true;
1708     }
1709 
1710     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
1711     ///  is approved by `_from`
1712     /// @param from The address holding the tokens being transferred
1713     /// @param to The address of the recipient
1714     /// @param amount The amount of tokens to be transferred
1715     /// @return True if the transfer was successful, reverts in any other case
1716     function transferFrom(address from, address to, uint256 amount)
1717         public
1718         returns (bool success)
1719     {
1720         uint256 allowed = mAllowanceOverride(from, msg.sender);
1721         if (allowed == 0) {
1722             // The standard ERC 20 transferFrom functionality
1723             allowed = _allowed[from][msg.sender];
1724             // yes this will underflow but then we'll revert. will cost gas however so don't underflow
1725             _allowed[from][msg.sender] -= amount;
1726         }
1727         require(allowed >= amount);
1728         mTransfer(from, to, amount);
1729         return true;
1730     }
1731 
1732     //
1733     // Implements IERC677Token
1734     //
1735 
1736     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
1737     ///  its behalf, and then a function is triggered in the contract that is
1738     ///  being approved, `_spender`. This allows users to use their tokens to
1739     ///  interact with contracts in one function call instead of two
1740     /// @param spender The address of the contract able to transfer the tokens
1741     /// @param amount The amount of tokens to be approved for transfer
1742     /// @return True or reverts, False is never returned
1743     function approveAndCall(
1744         address spender,
1745         uint256 amount,
1746         bytes extraData
1747     )
1748         public
1749         returns (bool success)
1750     {
1751         require(approve(spender, amount));
1752 
1753         success = IERC677Callback(spender).receiveApproval(
1754             msg.sender,
1755             amount,
1756             this,
1757             extraData
1758         );
1759         require(success);
1760 
1761         return true;
1762     }
1763 
1764     ////////////////////////
1765     // Internal functions
1766     ////////////////////////
1767 
1768     //
1769     // Implements default MTokenAllowanceController
1770     //
1771 
1772     // no override in default implementation
1773     function mAllowanceOverride(
1774         address /*owner*/,
1775         address /*spender*/
1776     )
1777         internal
1778         constant
1779         returns (uint256)
1780     {
1781         return 0;
1782     }
1783 }
1784 
1785 /**
1786  * @title Standard ERC20 token
1787  *
1788  * @dev Implementation of the standard token.
1789  * @dev https://github.com/ethereum/EIPs/issues/20
1790  */
1791 contract StandardToken is
1792     IERC20Token,
1793     BasicToken,
1794     TokenAllowance
1795 {
1796 
1797 }
1798 
1799 /// @title uniquely identifies deployable (non-abstract) platform contract
1800 /// @notice cheap way of assigning implementations to knownInterfaces which represent system services
1801 ///         unfortunatelly ERC165 does not include full public interface (ABI) and does not provide way to list implemented interfaces
1802 ///         EIP820 still in the making
1803 /// @dev ids are generated as follows keccak256("neufund-platform:<contract name>")
1804 ///      ids roughly correspond to ABIs
1805 contract IContractId {
1806     /// @param id defined as above
1807     /// @param version implementation version
1808     function contractId() public pure returns (bytes32 id, uint256 version);
1809 }
1810 
1811 contract IWithdrawableToken {
1812 
1813     ////////////////////////
1814     // Public functions
1815     ////////////////////////
1816 
1817     /// @notice withdraws from a token holding assets
1818     /// @dev amount of asset should be returned to msg.sender and corresponding balance burned
1819     function withdraw(uint256 amount)
1820         public;
1821 }
1822 
1823 contract EtherToken is
1824     IsContract,
1825     IContractId,
1826     AccessControlled,
1827     StandardToken,
1828     TrustlessTokenController,
1829     IWithdrawableToken,
1830     TokenMetadata,
1831     IERC223Token,
1832     Reclaimable
1833 {
1834     ////////////////////////
1835     // Constants
1836     ////////////////////////
1837 
1838     string private constant NAME = "Ether Token";
1839 
1840     string private constant SYMBOL = "ETH-T";
1841 
1842     uint8 private constant DECIMALS = 18;
1843 
1844     ////////////////////////
1845     // Events
1846     ////////////////////////
1847 
1848     event LogDeposit(
1849         address indexed to,
1850         uint256 amount
1851     );
1852 
1853     event LogWithdrawal(
1854         address indexed from,
1855         uint256 amount
1856     );
1857 
1858     event LogWithdrawAndSend(
1859         address indexed from,
1860         address indexed to,
1861         uint256 amount
1862     );
1863 
1864     ////////////////////////
1865     // Constructor
1866     ////////////////////////
1867 
1868     constructor(IAccessPolicy accessPolicy)
1869         AccessControlled(accessPolicy)
1870         StandardToken()
1871         TokenMetadata(NAME, DECIMALS, SYMBOL, "")
1872         Reclaimable()
1873         public
1874     {
1875     }
1876 
1877     ////////////////////////
1878     // Public functions
1879     ////////////////////////
1880 
1881     /// deposit msg.value of Ether to msg.sender balance
1882     function deposit()
1883         public
1884         payable
1885     {
1886         depositPrivate();
1887         emit Transfer(address(0), msg.sender, msg.value);
1888     }
1889 
1890     /// @notice convenience function to deposit and immediately transfer amount
1891     /// @param transferTo where to transfer after deposit
1892     /// @param amount total amount to transfer, must be <= balance after deposit
1893     /// @param data erc223 data
1894     /// @dev intended to deposit from simple account and invest in ETO
1895     function depositAndTransfer(address transferTo, uint256 amount, bytes data)
1896         public
1897         payable
1898     {
1899         depositPrivate();
1900         transfer(transferTo, amount, data);
1901     }
1902 
1903     /// withdraws and sends 'amount' of ether to msg.sender
1904     function withdraw(uint256 amount)
1905         public
1906     {
1907         withdrawPrivate(amount);
1908         msg.sender.transfer(amount);
1909     }
1910 
1911     /// @notice convenience function to withdraw and transfer to external account
1912     /// @param sendTo address to which send total amount
1913     /// @param amount total amount to withdraw and send
1914     /// @dev function is payable and is meant to withdraw funds on accounts balance and token in single transaction
1915     /// @dev BEWARE that msg.sender of the funds is Ether Token contract and not simple account calling it.
1916     /// @dev  when sent to smart conctract funds may be lost, so this is prevented below
1917     function withdrawAndSend(address sendTo, uint256 amount)
1918         public
1919         payable
1920     {
1921         // must send at least what is in msg.value to being another deposit function
1922         require(amount >= msg.value, "NF_ET_NO_DEPOSIT");
1923         if (amount > msg.value) {
1924             uint256 withdrawRemainder = amount - msg.value;
1925             withdrawPrivate(withdrawRemainder);
1926         }
1927         emit LogWithdrawAndSend(msg.sender, sendTo, amount);
1928         sendTo.transfer(amount);
1929     }
1930 
1931     //
1932     // Implements IERC223Token
1933     //
1934 
1935     function transfer(address to, uint256 amount, bytes data)
1936         public
1937         returns (bool)
1938     {
1939         BasicToken.mTransfer(msg.sender, to, amount);
1940 
1941         // Notify the receiving contract.
1942         if (isContract(to)) {
1943             // in case of re-entry (1) transfer is done (2) msg.sender is different
1944             IERC223Callback(to).tokenFallback(msg.sender, amount, data);
1945         }
1946         return true;
1947     }
1948 
1949     //
1950     // Overrides Reclaimable
1951     //
1952 
1953     /// @notice allows EtherToken to reclaim tokens wrongly sent to its address
1954     /// @dev as EtherToken by design has balance of Ether (native Ethereum token)
1955     ///     such reclamation is not allowed
1956     function reclaim(IBasicToken token)
1957         public
1958     {
1959         // forbid reclaiming ETH hold in this contract.
1960         require(token != RECLAIM_ETHER);
1961         Reclaimable.reclaim(token);
1962     }
1963 
1964     //
1965     // Implements IContractId
1966     //
1967 
1968     function contractId() public pure returns (bytes32 id, uint256 version) {
1969         return (0x75b86bc24f77738576716a36431588ae768d80d077231d1661c2bea674c6373a, 0);
1970     }
1971 
1972 
1973     ////////////////////////
1974     // Private functions
1975     ////////////////////////
1976 
1977     function depositPrivate()
1978         private
1979     {
1980         _balances[msg.sender] = add(_balances[msg.sender], msg.value);
1981         _totalSupply = add(_totalSupply, msg.value);
1982         emit LogDeposit(msg.sender, msg.value);
1983     }
1984 
1985     function withdrawPrivate(uint256 amount)
1986         private
1987     {
1988         require(_balances[msg.sender] >= amount);
1989         _balances[msg.sender] = sub(_balances[msg.sender], amount);
1990         _totalSupply = sub(_totalSupply, amount);
1991         emit LogWithdrawal(msg.sender, amount);
1992         emit Transfer(msg.sender, address(0), amount);
1993     }
1994 }
1995 
1996 contract EuroToken is
1997     Agreement,
1998     IERC677Token,
1999     StandardToken,
2000     IWithdrawableToken,
2001     ITokenControllerHook,
2002     TokenMetadata,
2003     IERC223Token,
2004     IsContract,
2005     IContractId
2006 {
2007     ////////////////////////
2008     // Constants
2009     ////////////////////////
2010 
2011     string private constant NAME = "Euro Token";
2012 
2013     string private constant SYMBOL = "EUR-T";
2014 
2015     uint8 private constant DECIMALS = 18;
2016 
2017     ////////////////////////
2018     // Mutable state
2019     ////////////////////////
2020 
2021     ITokenController private _tokenController;
2022 
2023     ////////////////////////
2024     // Events
2025     ////////////////////////
2026 
2027     /// on each deposit (increase of supply) of EUR-T
2028     /// 'by' indicates account that executed the deposit function for 'to' (typically bank connector)
2029     event LogDeposit(
2030         address indexed to,
2031         address by,
2032         uint256 amount,
2033         bytes32 reference
2034     );
2035 
2036     // proof of requested deposit initiated by token holder
2037     event LogWithdrawal(
2038         address indexed from,
2039         uint256 amount
2040     );
2041 
2042     // proof of settled deposit
2043     event LogWithdrawSettled(
2044         address from,
2045         address by, // who settled
2046         uint256 amount, // settled amount, after fees, negative interest rates etc.
2047         uint256 originalAmount, // original amount withdrawn
2048         bytes32 withdrawTxHash, // hash of withdraw transaction
2049         bytes32 reference // reference number of withdraw operation at deposit manager
2050     );
2051 
2052     /// on destroying the tokens without withdraw (see `destroyTokens` function below)
2053     event LogDestroy(
2054         address indexed from,
2055         address by,
2056         uint256 amount
2057     );
2058 
2059     ////////////////////////
2060     // Modifiers
2061     ////////////////////////
2062 
2063     modifier onlyIfDepositAllowed(address to, uint256 amount) {
2064         require(_tokenController.onGenerateTokens(msg.sender, to, amount));
2065         _;
2066     }
2067 
2068     modifier onlyIfWithdrawAllowed(address from, uint256 amount) {
2069         require(_tokenController.onDestroyTokens(msg.sender, from, amount));
2070         _;
2071     }
2072 
2073     ////////////////////////
2074     // Constructor
2075     ////////////////////////
2076 
2077     constructor(
2078         IAccessPolicy accessPolicy,
2079         IEthereumForkArbiter forkArbiter,
2080         ITokenController tokenController
2081     )
2082         Agreement(accessPolicy, forkArbiter)
2083         StandardToken()
2084         TokenMetadata(NAME, DECIMALS, SYMBOL, "")
2085         public
2086     {
2087         require(tokenController != ITokenController(0x0));
2088         _tokenController = tokenController;
2089     }
2090 
2091     ////////////////////////
2092     // Public functions
2093     ////////////////////////
2094 
2095     /// @notice deposit 'amount' of EUR-T to address 'to', attaching correlating `reference` to LogDeposit event
2096     /// @dev deposit may happen only in case 'to' can receive transfer in token controller
2097     ///     by default KYC is required to receive deposits
2098     function deposit(address to, uint256 amount, bytes32 reference)
2099         public
2100         only(ROLE_EURT_DEPOSIT_MANAGER)
2101         onlyIfDepositAllowed(to, amount)
2102         acceptAgreement(to)
2103     {
2104         require(to != address(0));
2105         _balances[to] = add(_balances[to], amount);
2106         _totalSupply = add(_totalSupply, amount);
2107         emit LogDeposit(to, msg.sender, amount, reference);
2108         emit Transfer(address(0), to, amount);
2109     }
2110 
2111     /// @notice runs many deposits within one transaction
2112     /// @dev deposit may happen only in case 'to' can receive transfer in token controller
2113     ///     by default KYC is required to receive deposits
2114     function depositMany(address[] to, uint256[] amount, bytes32[] reference)
2115         public
2116     {
2117         require(to.length == amount.length);
2118         require(to.length == reference.length);
2119         for (uint256 i = 0; i < to.length; i++) {
2120             deposit(to[i], amount[i], reference[i]);
2121         }
2122     }
2123 
2124     /// @notice withdraws 'amount' of EUR-T by burning required amount and providing a proof of whithdrawal
2125     /// @dev proof is provided in form of log entry. based on that proof deposit manager will make a bank transfer
2126     ///     by default controller will check the following: KYC and existence of working bank account
2127     function withdraw(uint256 amount)
2128         public
2129         onlyIfWithdrawAllowed(msg.sender, amount)
2130         acceptAgreement(msg.sender)
2131     {
2132         destroyTokensPrivate(msg.sender, amount);
2133         emit LogWithdrawal(msg.sender, amount);
2134     }
2135 
2136     /// @notice issued by deposit manager when withdraw request was settled. typicaly amount that could be settled will be lower
2137     ///         than amount withdrawn: banks charge negative interest rates and various fees that must be deduced
2138     ///         reference number is attached that may be used to identify withdraw operation at deposit manager
2139     function settleWithdraw(address from, uint256 amount, uint256 originalAmount, bytes32 withdrawTxHash, bytes32 reference)
2140         public
2141         only(ROLE_EURT_DEPOSIT_MANAGER)
2142     {
2143         emit LogWithdrawSettled(from, msg.sender, amount, originalAmount, withdrawTxHash, reference);
2144     }
2145 
2146     /// @notice this method allows to destroy EUR-T belonging to any account
2147     ///     note that EURO is fiat currency and is not trustless, EUR-T is also
2148     ///     just internal currency of Neufund platform, not general purpose stable coin
2149     ///     we need to be able to destroy EUR-T if ordered by authorities
2150     function destroy(address owner, uint256 amount)
2151         public
2152         only(ROLE_EURT_LEGAL_MANAGER)
2153     {
2154         destroyTokensPrivate(owner, amount);
2155         emit LogDestroy(owner, msg.sender, amount);
2156     }
2157 
2158     //
2159     // Implements ITokenControllerHook
2160     //
2161 
2162     function changeTokenController(address newController)
2163         public
2164     {
2165         require(_tokenController.onChangeTokenController(msg.sender, newController));
2166         _tokenController = ITokenController(newController);
2167         emit LogChangeTokenController(_tokenController, newController, msg.sender);
2168     }
2169 
2170     function tokenController()
2171         public
2172         constant
2173         returns (address)
2174     {
2175         return _tokenController;
2176     }
2177 
2178     //
2179     // Implements IERC223Token
2180     //
2181     function transfer(address to, uint256 amount, bytes data)
2182         public
2183         returns (bool success)
2184     {
2185         return ierc223TransferInternal(msg.sender, to, amount, data);
2186     }
2187 
2188     /// @notice convenience function to deposit and immediately transfer amount
2189     /// @param depositTo which account to deposit to and then transfer from
2190     /// @param transferTo where to transfer after deposit
2191     /// @param depositAmount amount to deposit
2192     /// @param transferAmount total amount to transfer, must be <= balance after deposit
2193     /// @dev intended to deposit from bank account and invest in ETO
2194     function depositAndTransfer(
2195         address depositTo,
2196         address transferTo,
2197         uint256 depositAmount,
2198         uint256 transferAmount,
2199         bytes data,
2200         bytes32 reference
2201     )
2202         public
2203         returns (bool success)
2204     {
2205         deposit(depositTo, depositAmount, reference);
2206         return ierc223TransferInternal(depositTo, transferTo, transferAmount, data);
2207     }
2208 
2209     //
2210     // Implements IContractId
2211     //
2212 
2213     function contractId() public pure returns (bytes32 id, uint256 version) {
2214         return (0xfb5c7e43558c4f3f5a2d87885881c9b10ff4be37e3308579c178bf4eaa2c29cd, 0);
2215     }
2216 
2217     ////////////////////////
2218     // Internal functions
2219     ////////////////////////
2220 
2221     //
2222     // Implements MTokenController
2223     //
2224 
2225     function mOnTransfer(
2226         address from,
2227         address to,
2228         uint256 amount
2229     )
2230         internal
2231         acceptAgreement(from)
2232         returns (bool allow)
2233     {
2234         address broker = msg.sender;
2235         if (broker != from) {
2236             // if called by the depositor (deposit and send), ignore the broker flag
2237             bool isDepositor = accessPolicy().allowed(msg.sender, ROLE_EURT_DEPOSIT_MANAGER, this, msg.sig);
2238             // this is not very clean but alternative (give brokerage rights to all depositors) is maintenance hell
2239             if (isDepositor) {
2240                 broker = from;
2241             }
2242         }
2243         return _tokenController.onTransfer(broker, from, to, amount);
2244     }
2245 
2246     function mOnApprove(
2247         address owner,
2248         address spender,
2249         uint256 amount
2250     )
2251         internal
2252         acceptAgreement(owner)
2253         returns (bool allow)
2254     {
2255         return _tokenController.onApprove(owner, spender, amount);
2256     }
2257 
2258     function mAllowanceOverride(
2259         address owner,
2260         address spender
2261     )
2262         internal
2263         constant
2264         returns (uint256)
2265     {
2266         return _tokenController.onAllowance(owner, spender);
2267     }
2268 
2269     //
2270     // Observes MAgreement internal interface
2271     //
2272 
2273     /// @notice euro token is legally represented by separate entity ROLE_EURT_LEGAL_MANAGER
2274     function mCanAmend(address legalRepresentative)
2275         internal
2276         returns (bool)
2277     {
2278         return accessPolicy().allowed(legalRepresentative, ROLE_EURT_LEGAL_MANAGER, this, msg.sig);
2279     }
2280 
2281     ////////////////////////
2282     // Private functions
2283     ////////////////////////
2284 
2285     function destroyTokensPrivate(address owner, uint256 amount)
2286         private
2287     {
2288         require(_balances[owner] >= amount);
2289         _balances[owner] = sub(_balances[owner], amount);
2290         _totalSupply = sub(_totalSupply, amount);
2291         emit Transfer(owner, address(0), amount);
2292     }
2293 
2294     /// @notice internal transfer function that checks permissions and calls the tokenFallback
2295     function ierc223TransferInternal(address from, address to, uint256 amount, bytes data)
2296         private
2297         returns (bool success)
2298     {
2299         BasicToken.mTransfer(from, to, amount);
2300 
2301         // Notify the receiving contract.
2302         if (isContract(to)) {
2303             // in case of re-entry (1) transfer is done (2) msg.sender is different
2304             IERC223Callback(to).tokenFallback(from, amount, data);
2305         }
2306         return true;
2307     }
2308 }
2309 
2310 /// @title serialization of basic types from/to bytes
2311 contract Serialization {
2312     ////////////////////////
2313     // Internal functions
2314     ////////////////////////
2315     function decodeAddress(bytes b)
2316         internal
2317         pure
2318         returns (address a)
2319     {
2320         require(b.length == 20);
2321         assembly {
2322             // load memory area that is address "carved out" of 64 byte bytes. prefix is zeroed
2323             a := and(mload(add(b, 20)), 0x00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
2324         }
2325     }
2326 }
2327 
2328 contract NeumarkIssuanceCurve {
2329 
2330     ////////////////////////
2331     // Constants
2332     ////////////////////////
2333 
2334     // maximum number of neumarks that may be created
2335     uint256 private constant NEUMARK_CAP = 1500000000000000000000000000;
2336 
2337     // initial neumark reward fraction (controls curve steepness)
2338     uint256 private constant INITIAL_REWARD_FRACTION = 6500000000000000000;
2339 
2340     // stop issuing new Neumarks above this Euro value (as it goes quickly to zero)
2341     uint256 private constant ISSUANCE_LIMIT_EUR_ULPS = 8300000000000000000000000000;
2342 
2343     // approximate curve linearly above this Euro value
2344     uint256 private constant LINEAR_APPROX_LIMIT_EUR_ULPS = 2100000000000000000000000000;
2345     uint256 private constant NEUMARKS_AT_LINEAR_LIMIT_ULPS = 1499832501287264827896539871;
2346 
2347     uint256 private constant TOT_LINEAR_NEUMARKS_ULPS = NEUMARK_CAP - NEUMARKS_AT_LINEAR_LIMIT_ULPS;
2348     uint256 private constant TOT_LINEAR_EUR_ULPS = ISSUANCE_LIMIT_EUR_ULPS - LINEAR_APPROX_LIMIT_EUR_ULPS;
2349 
2350     ////////////////////////
2351     // Public functions
2352     ////////////////////////
2353 
2354     /// @notice returns additional amount of neumarks issued for euroUlps at totalEuroUlps
2355     /// @param totalEuroUlps actual curve position from which neumarks will be issued
2356     /// @param euroUlps amount against which neumarks will be issued
2357     function incremental(uint256 totalEuroUlps, uint256 euroUlps)
2358         public
2359         pure
2360         returns (uint256 neumarkUlps)
2361     {
2362         require(totalEuroUlps + euroUlps >= totalEuroUlps);
2363         uint256 from = cumulative(totalEuroUlps);
2364         uint256 to = cumulative(totalEuroUlps + euroUlps);
2365         // as expansion is not monotonic for large totalEuroUlps, assert below may fail
2366         // example: totalEuroUlps=1.999999999999999999999000000e+27 and euroUlps=50
2367         assert(to >= from);
2368         return to - from;
2369     }
2370 
2371     /// @notice returns amount of euro corresponding to burned neumarks
2372     /// @param totalEuroUlps actual curve position from which neumarks will be burned
2373     /// @param burnNeumarkUlps amount of neumarks to burn
2374     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps)
2375         public
2376         pure
2377         returns (uint256 euroUlps)
2378     {
2379         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
2380         require(totalNeumarkUlps >= burnNeumarkUlps);
2381         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
2382         uint newTotalEuroUlps = cumulativeInverse(fromNmk, 0, totalEuroUlps);
2383         // yes, this may overflow due to non monotonic inverse function
2384         assert(totalEuroUlps >= newTotalEuroUlps);
2385         return totalEuroUlps - newTotalEuroUlps;
2386     }
2387 
2388     /// @notice returns amount of euro corresponding to burned neumarks
2389     /// @param totalEuroUlps actual curve position from which neumarks will be burned
2390     /// @param burnNeumarkUlps amount of neumarks to burn
2391     /// @param minEurUlps euro amount to start inverse search from, inclusive
2392     /// @param maxEurUlps euro amount to end inverse search to, inclusive
2393     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2394         public
2395         pure
2396         returns (uint256 euroUlps)
2397     {
2398         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
2399         require(totalNeumarkUlps >= burnNeumarkUlps);
2400         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
2401         uint newTotalEuroUlps = cumulativeInverse(fromNmk, minEurUlps, maxEurUlps);
2402         // yes, this may overflow due to non monotonic inverse function
2403         assert(totalEuroUlps >= newTotalEuroUlps);
2404         return totalEuroUlps - newTotalEuroUlps;
2405     }
2406 
2407     /// @notice finds total amount of neumarks issued for given amount of Euro
2408     /// @dev binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
2409     ///     function below is not monotonic
2410     function cumulative(uint256 euroUlps)
2411         public
2412         pure
2413         returns(uint256 neumarkUlps)
2414     {
2415         // Return the cap if euroUlps is above the limit.
2416         if (euroUlps >= ISSUANCE_LIMIT_EUR_ULPS) {
2417             return NEUMARK_CAP;
2418         }
2419         // use linear approximation above limit below
2420         // binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
2421         if (euroUlps >= LINEAR_APPROX_LIMIT_EUR_ULPS) {
2422             // (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS) is small so expression does not overflow
2423             return NEUMARKS_AT_LINEAR_LIMIT_ULPS + (TOT_LINEAR_NEUMARKS_ULPS * (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS)) / TOT_LINEAR_EUR_ULPS;
2424         }
2425 
2426         // Approximate cap-cap·(1-1/D)^n using the Binomial expansion
2427         // http://galileo.phys.virginia.edu/classes/152.mf1i.spring02/Exponential_Function.htm
2428         // Function[imax, -CAP*Sum[(-IR*EUR/CAP)^i/Factorial[i], {i, imax}]]
2429         // which may be simplified to
2430         // Function[imax, -CAP*Sum[(EUR)^i/(Factorial[i]*(-d)^i), {i, 1, imax}]]
2431         // where d = cap/initial_reward
2432         uint256 d = 230769230769230769230769231; // NEUMARK_CAP / INITIAL_REWARD_FRACTION
2433         uint256 term = NEUMARK_CAP;
2434         uint256 sum = 0;
2435         uint256 denom = d;
2436         do assembly {
2437             // We use assembler primarily to avoid the expensive
2438             // divide-by-zero check solc inserts for the / operator.
2439             term  := div(mul(term, euroUlps), denom)
2440             sum   := add(sum, term)
2441             denom := add(denom, d)
2442             // sub next term as we have power of negative value in the binomial expansion
2443             term  := div(mul(term, euroUlps), denom)
2444             sum   := sub(sum, term)
2445             denom := add(denom, d)
2446         } while (term != 0);
2447         return sum;
2448     }
2449 
2450     /// @notice find issuance curve inverse by binary search
2451     /// @param neumarkUlps neumark amount to compute inverse for
2452     /// @param minEurUlps minimum search range for the inverse, inclusive
2453     /// @param maxEurUlps maxium search range for the inverse, inclusive
2454     /// @dev in case of approximate search (no exact inverse) upper element of minimal search range is returned
2455     /// @dev in case of many possible inverses, the lowest one will be used (if range permits)
2456     /// @dev corresponds to a linear search that returns first euroUlp value that has cumulative() equal or greater than neumarkUlps
2457     function cumulativeInverse(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2458         public
2459         pure
2460         returns (uint256 euroUlps)
2461     {
2462         require(maxEurUlps >= minEurUlps);
2463         require(cumulative(minEurUlps) <= neumarkUlps);
2464         require(cumulative(maxEurUlps) >= neumarkUlps);
2465         uint256 min = minEurUlps;
2466         uint256 max = maxEurUlps;
2467 
2468         // Binary search
2469         while (max > min) {
2470             uint256 mid = (max + min) / 2;
2471             uint256 val = cumulative(mid);
2472             // exact solution should not be used, a late points of the curve when many euroUlps are needed to
2473             // increase by one nmkUlp this will lead to  "indeterministic" inverse values that depend on the initial min and max
2474             // and further binary division -> you can land at any of the euro value that is mapped to the same nmk value
2475             // with condition below removed, binary search will point to the lowest eur value possible which is good because it cannot be exploited even with 0 gas costs
2476             /* if (val == neumarkUlps) {
2477                 return mid;
2478             }*/
2479             // NOTE: approximate search (no inverse) must return upper element of the final range
2480             //  last step of approximate search is always (min, min+1) so new mid is (2*min+1)/2 => min
2481             //  so new min = mid + 1 = max which was upper range. and that ends the search
2482             // NOTE: when there are multiple inverses for the same neumarkUlps, the `max` will be dragged down
2483             //  by `max = mid` expression to the lowest eur value of inverse. works only for ranges that cover all points of multiple inverse
2484             if (val < neumarkUlps) {
2485                 min = mid + 1;
2486             } else {
2487                 max = mid;
2488             }
2489         }
2490         // NOTE: It is possible that there is no inverse
2491         //  for example curve(0) = 0 and curve(1) = 6, so
2492         //  there is no value y such that curve(y) = 5.
2493         //  When there is no inverse, we must return upper element of last search range.
2494         //  This has the effect of reversing the curve less when
2495         //  burning Neumarks. This ensures that Neumarks can always
2496         //  be burned. It also ensure that the total supply of Neumarks
2497         //  remains below the cap.
2498         return max;
2499     }
2500 
2501     function neumarkCap()
2502         public
2503         pure
2504         returns (uint256)
2505     {
2506         return NEUMARK_CAP;
2507     }
2508 
2509     function initialRewardFraction()
2510         public
2511         pure
2512         returns (uint256)
2513     {
2514         return INITIAL_REWARD_FRACTION;
2515     }
2516 }
2517 
2518 /// @title advances snapshot id on demand
2519 /// @dev see Snapshot folder for implementation examples ie. DailyAndSnapshotable contract
2520 contract ISnapshotable {
2521 
2522     ////////////////////////
2523     // Events
2524     ////////////////////////
2525 
2526     /// @dev should log each new snapshot id created, including snapshots created automatically via MSnapshotPolicy
2527     event LogSnapshotCreated(uint256 snapshotId);
2528 
2529     ////////////////////////
2530     // Public functions
2531     ////////////////////////
2532 
2533     /// always creates new snapshot id which gets returned
2534     /// however, there is no guarantee that any snapshot will be created with this id, this depends on the implementation of MSnaphotPolicy
2535     function createSnapshot()
2536         public
2537         returns (uint256);
2538 
2539     /// upper bound of series snapshotIds for which there's a value
2540     function currentSnapshotId()
2541         public
2542         constant
2543         returns (uint256);
2544 }
2545 
2546 /// @title Abstracts snapshot id creation logics
2547 /// @dev Mixin (internal interface) of the snapshot policy which abstracts snapshot id creation logics from Snapshot contract
2548 /// @dev to be implemented and such implementation should be mixed with Snapshot-derived contract, see EveryBlock for simplest example of implementation and StandardSnapshotToken
2549 contract MSnapshotPolicy {
2550 
2551     ////////////////////////
2552     // Internal functions
2553     ////////////////////////
2554 
2555     // The snapshot Ids need to be strictly increasing.
2556     // Whenever the snaspshot id changes, a new snapshot will be created.
2557     // As long as the same snapshot id is being returned, last snapshot will be updated as this indicates that snapshot id didn't change
2558     //
2559     // Values passed to `hasValueAt` and `valuteAt` are required
2560     // to be less or equal to `mCurrentSnapshotId()`.
2561     function mAdvanceSnapshotId()
2562         internal
2563         returns (uint256);
2564 
2565     // this is a version of mAdvanceSnapshotId that does not modify state but MUST return the same value
2566     // it is required to implement ITokenSnapshots interface cleanly
2567     function mCurrentSnapshotId()
2568         internal
2569         constant
2570         returns (uint256);
2571 
2572 }
2573 
2574 /// @title creates new snapshot id on each day boundary
2575 /// @dev snapshot id is unix timestamp of current day boundary
2576 contract Daily is MSnapshotPolicy {
2577 
2578     ////////////////////////
2579     // Constants
2580     ////////////////////////
2581 
2582     // Floor[2**128 / 1 days]
2583     uint256 private MAX_TIMESTAMP = 3938453320844195178974243141571391;
2584 
2585     ////////////////////////
2586     // Constructor
2587     ////////////////////////
2588 
2589     /// @param start snapshotId from which to start generating values, used to prevent cloning from incompatible schemes
2590     /// @dev start must be for the same day or 0, required for token cloning
2591     constructor(uint256 start) internal {
2592         // 0 is invalid value as we are past unix epoch
2593         if (start > 0) {
2594             uint256 base = dayBase(uint128(block.timestamp));
2595             // must be within current day base
2596             require(start >= base);
2597             // dayBase + 2**128 will not overflow as it is based on block.timestamp
2598             require(start < base + 2**128);
2599         }
2600     }
2601 
2602     ////////////////////////
2603     // Public functions
2604     ////////////////////////
2605 
2606     function snapshotAt(uint256 timestamp)
2607         public
2608         constant
2609         returns (uint256)
2610     {
2611         require(timestamp < MAX_TIMESTAMP);
2612 
2613         return dayBase(uint128(timestamp));
2614     }
2615 
2616     ////////////////////////
2617     // Internal functions
2618     ////////////////////////
2619 
2620     //
2621     // Implements MSnapshotPolicy
2622     //
2623 
2624     function mAdvanceSnapshotId()
2625         internal
2626         returns (uint256)
2627     {
2628         return mCurrentSnapshotId();
2629     }
2630 
2631     function mCurrentSnapshotId()
2632         internal
2633         constant
2634         returns (uint256)
2635     {
2636         // disregard overflows on block.timestamp, see MAX_TIMESTAMP
2637         return dayBase(uint128(block.timestamp));
2638     }
2639 
2640     function dayBase(uint128 timestamp)
2641         internal
2642         pure
2643         returns (uint256)
2644     {
2645         // Round down to the start of the day (00:00 UTC) and place in higher 128bits
2646         return 2**128 * (uint256(timestamp) / 1 days);
2647     }
2648 }
2649 
2650 /// @title creates snapshot id on each day boundary and allows to create additional snapshots within a given day
2651 /// @dev snapshots are encoded in single uint256, where high 128 bits represents a day number (from unix epoch) and low 128 bits represents additional snapshots within given day create via ISnapshotable
2652 contract DailyAndSnapshotable is
2653     Daily,
2654     ISnapshotable
2655 {
2656 
2657     ////////////////////////
2658     // Mutable state
2659     ////////////////////////
2660 
2661     uint256 private _currentSnapshotId;
2662 
2663     ////////////////////////
2664     // Constructor
2665     ////////////////////////
2666 
2667     /// @param start snapshotId from which to start generating values
2668     /// @dev start must be for the same day or 0, required for token cloning
2669     constructor(uint256 start)
2670         internal
2671         Daily(start)
2672     {
2673         if (start > 0) {
2674             _currentSnapshotId = start;
2675         }
2676     }
2677 
2678     ////////////////////////
2679     // Public functions
2680     ////////////////////////
2681 
2682     //
2683     // Implements ISnapshotable
2684     //
2685 
2686     function createSnapshot()
2687         public
2688         returns (uint256)
2689     {
2690         uint256 base = dayBase(uint128(block.timestamp));
2691 
2692         if (base > _currentSnapshotId) {
2693             // New day has started, create snapshot for midnight
2694             _currentSnapshotId = base;
2695         } else {
2696             // within single day, increase counter (assume 2**128 will not be crossed)
2697             _currentSnapshotId += 1;
2698         }
2699 
2700         // Log and return
2701         emit LogSnapshotCreated(_currentSnapshotId);
2702         return _currentSnapshotId;
2703     }
2704 
2705     ////////////////////////
2706     // Internal functions
2707     ////////////////////////
2708 
2709     //
2710     // Implements MSnapshotPolicy
2711     //
2712 
2713     function mAdvanceSnapshotId()
2714         internal
2715         returns (uint256)
2716     {
2717         uint256 base = dayBase(uint128(block.timestamp));
2718 
2719         // New day has started
2720         if (base > _currentSnapshotId) {
2721             _currentSnapshotId = base;
2722             emit LogSnapshotCreated(base);
2723         }
2724 
2725         return _currentSnapshotId;
2726     }
2727 
2728     function mCurrentSnapshotId()
2729         internal
2730         constant
2731         returns (uint256)
2732     {
2733         uint256 base = dayBase(uint128(block.timestamp));
2734 
2735         return base > _currentSnapshotId ? base : _currentSnapshotId;
2736     }
2737 }
2738 
2739 /// @title Reads and writes snapshots
2740 /// @dev Manages reading and writing a series of values, where each value has assigned a snapshot id for access to historical data
2741 /// @dev may be added to any contract to provide snapshotting mechanism. should be mixed in with any of MSnapshotPolicy implementations to customize snapshot creation mechanics
2742 ///     observes MSnapshotPolicy
2743 /// based on MiniMe token
2744 contract Snapshot is MSnapshotPolicy {
2745 
2746     ////////////////////////
2747     // Types
2748     ////////////////////////
2749 
2750     /// @dev `Values` is the structure that attaches a snapshot id to a
2751     ///  given value, the snapshot id attached is the one that last changed the
2752     ///  value
2753     struct Values {
2754 
2755         // `snapshotId` is the snapshot id that the value was generated at
2756         uint256 snapshotId;
2757 
2758         // `value` at a specific snapshot id
2759         uint256 value;
2760     }
2761 
2762     ////////////////////////
2763     // Internal functions
2764     ////////////////////////
2765 
2766     function hasValue(
2767         Values[] storage values
2768     )
2769         internal
2770         constant
2771         returns (bool)
2772     {
2773         return values.length > 0;
2774     }
2775 
2776     /// @dev makes sure that 'snapshotId' between current snapshot id (mCurrentSnapshotId) and first snapshot id. this guarantees that getValueAt returns value from one of the snapshots.
2777     function hasValueAt(
2778         Values[] storage values,
2779         uint256 snapshotId
2780     )
2781         internal
2782         constant
2783         returns (bool)
2784     {
2785         require(snapshotId <= mCurrentSnapshotId());
2786         return values.length > 0 && values[0].snapshotId <= snapshotId;
2787     }
2788 
2789     /// gets last value in the series
2790     function getValue(
2791         Values[] storage values,
2792         uint256 defaultValue
2793     )
2794         internal
2795         constant
2796         returns (uint256)
2797     {
2798         if (values.length == 0) {
2799             return defaultValue;
2800         } else {
2801             uint256 last = values.length - 1;
2802             return values[last].value;
2803         }
2804     }
2805 
2806     /// @dev `getValueAt` retrieves value at a given snapshot id
2807     /// @param values The series of values being queried
2808     /// @param snapshotId Snapshot id to retrieve the value at
2809     /// @return Value in series being queried
2810     function getValueAt(
2811         Values[] storage values,
2812         uint256 snapshotId,
2813         uint256 defaultValue
2814     )
2815         internal
2816         constant
2817         returns (uint256)
2818     {
2819         require(snapshotId <= mCurrentSnapshotId());
2820 
2821         // Empty value
2822         if (values.length == 0) {
2823             return defaultValue;
2824         }
2825 
2826         // Shortcut for the out of bounds snapshots
2827         uint256 last = values.length - 1;
2828         uint256 lastSnapshot = values[last].snapshotId;
2829         if (snapshotId >= lastSnapshot) {
2830             return values[last].value;
2831         }
2832         uint256 firstSnapshot = values[0].snapshotId;
2833         if (snapshotId < firstSnapshot) {
2834             return defaultValue;
2835         }
2836         // Binary search of the value in the array
2837         uint256 min = 0;
2838         uint256 max = last;
2839         while (max > min) {
2840             uint256 mid = (max + min + 1) / 2;
2841             // must always return lower indice for approximate searches
2842             if (values[mid].snapshotId <= snapshotId) {
2843                 min = mid;
2844             } else {
2845                 max = mid - 1;
2846             }
2847         }
2848         return values[min].value;
2849     }
2850 
2851     /// @dev `setValue` used to update sequence at next snapshot
2852     /// @param values The sequence being updated
2853     /// @param value The new last value of sequence
2854     function setValue(
2855         Values[] storage values,
2856         uint256 value
2857     )
2858         internal
2859     {
2860         // TODO: simplify or break into smaller functions
2861 
2862         uint256 currentSnapshotId = mAdvanceSnapshotId();
2863         // Always create a new entry if there currently is no value
2864         bool empty = values.length == 0;
2865         if (empty) {
2866             // Create a new entry
2867             values.push(
2868                 Values({
2869                     snapshotId: currentSnapshotId,
2870                     value: value
2871                 })
2872             );
2873             return;
2874         }
2875 
2876         uint256 last = values.length - 1;
2877         bool hasNewSnapshot = values[last].snapshotId < currentSnapshotId;
2878         if (hasNewSnapshot) {
2879 
2880             // Do nothing if the value was not modified
2881             bool unmodified = values[last].value == value;
2882             if (unmodified) {
2883                 return;
2884             }
2885 
2886             // Create new entry
2887             values.push(
2888                 Values({
2889                     snapshotId: currentSnapshotId,
2890                     value: value
2891                 })
2892             );
2893         } else {
2894 
2895             // We are updating the currentSnapshotId
2896             bool previousUnmodified = last > 0 && values[last - 1].value == value;
2897             if (previousUnmodified) {
2898                 // Remove current snapshot if current value was set to previous value
2899                 delete values[last];
2900                 values.length--;
2901                 return;
2902             }
2903 
2904             // Overwrite next snapshot entry
2905             values[last].value = value;
2906         }
2907     }
2908 }
2909 
2910 /// @title token with snapshots and transfer functionality
2911 /// @dev observes MTokenTransferController interface
2912 ///     observes ISnapshotToken interface
2913 ///     implementes MTokenTransfer interface
2914 contract BasicSnapshotToken is
2915     MTokenTransfer,
2916     MTokenTransferController,
2917     IClonedTokenParent,
2918     IBasicToken,
2919     Snapshot
2920 {
2921     ////////////////////////
2922     // Immutable state
2923     ////////////////////////
2924 
2925     // `PARENT_TOKEN` is the Token address that was cloned to produce this token;
2926     //  it will be 0x0 for a token that was not cloned
2927     IClonedTokenParent private PARENT_TOKEN;
2928 
2929     // `PARENT_SNAPSHOT_ID` is the snapshot id from the Parent Token that was
2930     //  used to determine the initial distribution of the cloned token
2931     uint256 private PARENT_SNAPSHOT_ID;
2932 
2933     ////////////////////////
2934     // Mutable state
2935     ////////////////////////
2936 
2937     // `balances` is the map that tracks the balance of each address, in this
2938     //  contract when the balance changes the snapshot id that the change
2939     //  occurred is also included in the map
2940     mapping (address => Values[]) internal _balances;
2941 
2942     // Tracks the history of the `totalSupply` of the token
2943     Values[] internal _totalSupplyValues;
2944 
2945     ////////////////////////
2946     // Constructor
2947     ////////////////////////
2948 
2949     /// @notice Constructor to create snapshot token
2950     /// @param parentToken Address of the parent token, set to 0x0 if it is a
2951     ///  new token
2952     /// @param parentSnapshotId at which snapshot id clone was created, set to 0 to clone at upper bound
2953     /// @dev please not that as long as cloned token does not overwrite value at current snapshot id, it will refer
2954     ///     to parent token at which this snapshot still may change until snapshot id increases. for that time tokens are coupled
2955     ///     this is prevented by parentSnapshotId value of parentToken.currentSnapshotId() - 1 being the maxiumum
2956     ///     see SnapshotToken.js test to learn consequences coupling has.
2957     constructor(
2958         IClonedTokenParent parentToken,
2959         uint256 parentSnapshotId
2960     )
2961         Snapshot()
2962         internal
2963     {
2964         PARENT_TOKEN = parentToken;
2965         if (parentToken == address(0)) {
2966             require(parentSnapshotId == 0);
2967         } else {
2968             if (parentSnapshotId == 0) {
2969                 require(parentToken.currentSnapshotId() > 0);
2970                 PARENT_SNAPSHOT_ID = parentToken.currentSnapshotId() - 1;
2971             } else {
2972                 PARENT_SNAPSHOT_ID = parentSnapshotId;
2973             }
2974         }
2975     }
2976 
2977     ////////////////////////
2978     // Public functions
2979     ////////////////////////
2980 
2981     //
2982     // Implements IBasicToken
2983     //
2984 
2985     /// @dev This function makes it easy to get the total number of tokens
2986     /// @return The total number of tokens
2987     function totalSupply()
2988         public
2989         constant
2990         returns (uint256)
2991     {
2992         return totalSupplyAtInternal(mCurrentSnapshotId());
2993     }
2994 
2995     /// @param owner The address that's balance is being requested
2996     /// @return The balance of `owner` at the current block
2997     function balanceOf(address owner)
2998         public
2999         constant
3000         returns (uint256 balance)
3001     {
3002         return balanceOfAtInternal(owner, mCurrentSnapshotId());
3003     }
3004 
3005     /// @notice Send `amount` tokens to `to` from `msg.sender`
3006     /// @param to The address of the recipient
3007     /// @param amount The amount of tokens to be transferred
3008     /// @return True if the transfer was successful, reverts in any other case
3009     function transfer(address to, uint256 amount)
3010         public
3011         returns (bool success)
3012     {
3013         mTransfer(msg.sender, to, amount);
3014         return true;
3015     }
3016 
3017     //
3018     // Implements ITokenSnapshots
3019     //
3020 
3021     function totalSupplyAt(uint256 snapshotId)
3022         public
3023         constant
3024         returns(uint256)
3025     {
3026         return totalSupplyAtInternal(snapshotId);
3027     }
3028 
3029     function balanceOfAt(address owner, uint256 snapshotId)
3030         public
3031         constant
3032         returns (uint256)
3033     {
3034         return balanceOfAtInternal(owner, snapshotId);
3035     }
3036 
3037     function currentSnapshotId()
3038         public
3039         constant
3040         returns (uint256)
3041     {
3042         return mCurrentSnapshotId();
3043     }
3044 
3045     //
3046     // Implements IClonedTokenParent
3047     //
3048 
3049     function parentToken()
3050         public
3051         constant
3052         returns(IClonedTokenParent parent)
3053     {
3054         return PARENT_TOKEN;
3055     }
3056 
3057     /// @return snapshot at wchich initial token distribution was taken
3058     function parentSnapshotId()
3059         public
3060         constant
3061         returns(uint256 snapshotId)
3062     {
3063         return PARENT_SNAPSHOT_ID;
3064     }
3065 
3066     //
3067     // Other public functions
3068     //
3069 
3070     /// @notice gets all token balances of 'owner'
3071     /// @dev intended to be called via eth_call where gas limit is not an issue
3072     function allBalancesOf(address owner)
3073         external
3074         constant
3075         returns (uint256[2][])
3076     {
3077         /* very nice and working implementation below,
3078         // copy to memory
3079         Values[] memory values = _balances[owner];
3080         do assembly {
3081             // in memory structs have simple layout where every item occupies uint256
3082             balances := values
3083         } while (false);*/
3084 
3085         Values[] storage values = _balances[owner];
3086         uint256[2][] memory balances = new uint256[2][](values.length);
3087         for(uint256 ii = 0; ii < values.length; ++ii) {
3088             balances[ii] = [values[ii].snapshotId, values[ii].value];
3089         }
3090 
3091         return balances;
3092     }
3093 
3094     ////////////////////////
3095     // Internal functions
3096     ////////////////////////
3097 
3098     function totalSupplyAtInternal(uint256 snapshotId)
3099         internal
3100         constant
3101         returns(uint256)
3102     {
3103         Values[] storage values = _totalSupplyValues;
3104 
3105         // If there is a value, return it, reverts if value is in the future
3106         if (hasValueAt(values, snapshotId)) {
3107             return getValueAt(values, snapshotId, 0);
3108         }
3109 
3110         // Try parent contract at or before the fork
3111         if (address(PARENT_TOKEN) != 0) {
3112             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
3113             return PARENT_TOKEN.totalSupplyAt(earlierSnapshotId);
3114         }
3115 
3116         // Default to an empty balance
3117         return 0;
3118     }
3119 
3120     // get balance at snapshot if with continuation in parent token
3121     function balanceOfAtInternal(address owner, uint256 snapshotId)
3122         internal
3123         constant
3124         returns (uint256)
3125     {
3126         Values[] storage values = _balances[owner];
3127 
3128         // If there is a value, return it, reverts if value is in the future
3129         if (hasValueAt(values, snapshotId)) {
3130             return getValueAt(values, snapshotId, 0);
3131         }
3132 
3133         // Try parent contract at or before the fork
3134         if (PARENT_TOKEN != address(0)) {
3135             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
3136             return PARENT_TOKEN.balanceOfAt(owner, earlierSnapshotId);
3137         }
3138 
3139         // Default to an empty balance
3140         return 0;
3141     }
3142 
3143     //
3144     // Implements MTokenTransfer
3145     //
3146 
3147     /// @dev This is the actual transfer function in the token contract, it can
3148     ///  only be called by other functions in this contract.
3149     /// @param from The address holding the tokens being transferred
3150     /// @param to The address of the recipient
3151     /// @param amount The amount of tokens to be transferred
3152     /// @return True if the transfer was successful, reverts in any other case
3153     function mTransfer(
3154         address from,
3155         address to,
3156         uint256 amount
3157     )
3158         internal
3159     {
3160         // never send to address 0
3161         require(to != address(0));
3162         // block transfers in clone that points to future/current snapshots of parent token
3163         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
3164         // Alerts the token controller of the transfer
3165         require(mOnTransfer(from, to, amount));
3166 
3167         // If the amount being transfered is more than the balance of the
3168         //  account the transfer reverts
3169         uint256 previousBalanceFrom = balanceOf(from);
3170         require(previousBalanceFrom >= amount);
3171 
3172         // First update the balance array with the new value for the address
3173         //  sending the tokens
3174         uint256 newBalanceFrom = previousBalanceFrom - amount;
3175         setValue(_balances[from], newBalanceFrom);
3176 
3177         // Then update the balance array with the new value for the address
3178         //  receiving the tokens
3179         uint256 previousBalanceTo = balanceOf(to);
3180         uint256 newBalanceTo = previousBalanceTo + amount;
3181         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
3182         setValue(_balances[to], newBalanceTo);
3183 
3184         // An event to make the transfer easy to find on the blockchain
3185         emit Transfer(from, to, amount);
3186     }
3187 }
3188 
3189 /// @title token generation and destruction
3190 /// @dev internal interface providing token generation and destruction, see MintableSnapshotToken for implementation
3191 contract MTokenMint {
3192 
3193     ////////////////////////
3194     // Internal functions
3195     ////////////////////////
3196 
3197     /// @notice Generates `amount` tokens that are assigned to `owner`
3198     /// @param owner The address that will be assigned the new tokens
3199     /// @param amount The quantity of tokens generated
3200     /// @dev reverts if tokens could not be generated
3201     function mGenerateTokens(address owner, uint256 amount)
3202         internal;
3203 
3204     /// @notice Burns `amount` tokens from `owner`
3205     /// @param owner The address that will lose the tokens
3206     /// @param amount The quantity of tokens to burn
3207     /// @dev reverts if tokens could not be destroyed
3208     function mDestroyTokens(address owner, uint256 amount)
3209         internal;
3210 }
3211 
3212 /// @title basic snapshot token with facitilites to generate and destroy tokens
3213 /// @dev implementes MTokenMint, does not expose any public functions that create/destroy tokens
3214 contract MintableSnapshotToken is
3215     BasicSnapshotToken,
3216     MTokenMint
3217 {
3218 
3219     ////////////////////////
3220     // Constructor
3221     ////////////////////////
3222 
3223     /// @notice Constructor to create a MintableSnapshotToken
3224     /// @param parentToken Address of the parent token, set to 0x0 if it is a
3225     ///  new token
3226     constructor(
3227         IClonedTokenParent parentToken,
3228         uint256 parentSnapshotId
3229     )
3230         BasicSnapshotToken(parentToken, parentSnapshotId)
3231         internal
3232     {}
3233 
3234     /// @notice Generates `amount` tokens that are assigned to `owner`
3235     /// @param owner The address that will be assigned the new tokens
3236     /// @param amount The quantity of tokens generated
3237     function mGenerateTokens(address owner, uint256 amount)
3238         internal
3239     {
3240         // never create for address 0
3241         require(owner != address(0));
3242         // block changes in clone that points to future/current snapshots of patent token
3243         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
3244 
3245         uint256 curTotalSupply = totalSupply();
3246         uint256 newTotalSupply = curTotalSupply + amount;
3247         require(newTotalSupply >= curTotalSupply); // Check for overflow
3248 
3249         uint256 previousBalanceTo = balanceOf(owner);
3250         uint256 newBalanceTo = previousBalanceTo + amount;
3251         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
3252 
3253         setValue(_totalSupplyValues, newTotalSupply);
3254         setValue(_balances[owner], newBalanceTo);
3255 
3256         emit Transfer(0, owner, amount);
3257     }
3258 
3259     /// @notice Burns `amount` tokens from `owner`
3260     /// @param owner The address that will lose the tokens
3261     /// @param amount The quantity of tokens to burn
3262     function mDestroyTokens(address owner, uint256 amount)
3263         internal
3264     {
3265         // block changes in clone that points to future/current snapshots of patent token
3266         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
3267 
3268         uint256 curTotalSupply = totalSupply();
3269         require(curTotalSupply >= amount);
3270 
3271         uint256 previousBalanceFrom = balanceOf(owner);
3272         require(previousBalanceFrom >= amount);
3273 
3274         uint256 newTotalSupply = curTotalSupply - amount;
3275         uint256 newBalanceFrom = previousBalanceFrom - amount;
3276         setValue(_totalSupplyValues, newTotalSupply);
3277         setValue(_balances[owner], newBalanceFrom);
3278 
3279         emit Transfer(owner, 0, amount);
3280     }
3281 }
3282 
3283 /*
3284     Copyright 2016, Jordi Baylina
3285     Copyright 2017, Remco Bloemen, Marcin Rudolf
3286 
3287     This program is free software: you can redistribute it and/or modify
3288     it under the terms of the GNU General Public License as published by
3289     the Free Software Foundation, either version 3 of the License, or
3290     (at your option) any later version.
3291 
3292     This program is distributed in the hope that it will be useful,
3293     but WITHOUT ANY WARRANTY; without even the implied warranty of
3294     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
3295     GNU General Public License for more details.
3296 
3297     You should have received a copy of the GNU General Public License
3298     along with this program.  If not, see <http://www.gnu.org/licenses/>.
3299  */
3300 /// @title StandardSnapshotToken Contract
3301 /// @author Jordi Baylina, Remco Bloemen, Marcin Rudolf
3302 /// @dev This token contract's goal is to make it easy for anyone to clone this
3303 ///  token using the token distribution at a given block, this will allow DAO's
3304 ///  and DApps to upgrade their features in a decentralized manner without
3305 ///  affecting the original token
3306 /// @dev It is ERC20 compliant, but still needs to under go further testing.
3307 /// @dev Various contracts are composed to provide required functionality of this token, different compositions are possible
3308 ///     MintableSnapshotToken provides transfer, miniting and snapshotting functions
3309 ///     TokenAllowance provides approve/transferFrom functions
3310 ///     TokenMetadata adds name, symbol and other token metadata
3311 /// @dev This token is still abstract, Snapshot, BasicSnapshotToken and TokenAllowance observe interfaces that must be implemented
3312 ///     MSnapshotPolicy - particular snapshot id creation mechanism
3313 ///     MTokenController - controlls approvals and transfers
3314 ///     see Neumark as an example
3315 /// @dev implements ERC223 token transfer
3316 contract StandardSnapshotToken is
3317     MintableSnapshotToken,
3318     TokenAllowance
3319 {
3320     ////////////////////////
3321     // Constructor
3322     ////////////////////////
3323 
3324     /// @notice Constructor to create a MiniMeToken
3325     ///  is a new token
3326     /// param tokenName Name of the new token
3327     /// param decimalUnits Number of decimals of the new token
3328     /// param tokenSymbol Token Symbol for the new token
3329     constructor(
3330         IClonedTokenParent parentToken,
3331         uint256 parentSnapshotId
3332     )
3333         MintableSnapshotToken(parentToken, parentSnapshotId)
3334         TokenAllowance()
3335         internal
3336     {}
3337 }
3338 
3339 /// @title old ERC223 callback function
3340 /// @dev as used in Neumark and ICBMEtherToken
3341 contract IERC223LegacyCallback {
3342 
3343     ////////////////////////
3344     // Public functions
3345     ////////////////////////
3346 
3347     function onTokenTransfer(address from, uint256 amount, bytes data)
3348         public;
3349 
3350 }
3351 
3352 contract Neumark is
3353     AccessControlled,
3354     AccessRoles,
3355     Agreement,
3356     DailyAndSnapshotable,
3357     StandardSnapshotToken,
3358     TokenMetadata,
3359     IERC223Token,
3360     NeumarkIssuanceCurve,
3361     Reclaimable,
3362     IsContract
3363 {
3364 
3365     ////////////////////////
3366     // Constants
3367     ////////////////////////
3368 
3369     string private constant TOKEN_NAME = "Neumark";
3370 
3371     uint8  private constant TOKEN_DECIMALS = 18;
3372 
3373     string private constant TOKEN_SYMBOL = "NEU";
3374 
3375     string private constant VERSION = "NMK_1.0";
3376 
3377     ////////////////////////
3378     // Mutable state
3379     ////////////////////////
3380 
3381     // disable transfers when Neumark is created
3382     bool private _transferEnabled = false;
3383 
3384     // at which point on curve new Neumarks will be created, see NeumarkIssuanceCurve contract
3385     // do not use to get total invested funds. see burn(). this is just a cache for expensive inverse function
3386     uint256 private _totalEurUlps;
3387 
3388     ////////////////////////
3389     // Events
3390     ////////////////////////
3391 
3392     event LogNeumarksIssued(
3393         address indexed owner,
3394         uint256 euroUlps,
3395         uint256 neumarkUlps
3396     );
3397 
3398     event LogNeumarksBurned(
3399         address indexed owner,
3400         uint256 euroUlps,
3401         uint256 neumarkUlps
3402     );
3403 
3404     ////////////////////////
3405     // Constructor
3406     ////////////////////////
3407 
3408     constructor(
3409         IAccessPolicy accessPolicy,
3410         IEthereumForkArbiter forkArbiter
3411     )
3412         AccessRoles()
3413         Agreement(accessPolicy, forkArbiter)
3414         StandardSnapshotToken(
3415             IClonedTokenParent(0x0),
3416             0
3417         )
3418         TokenMetadata(
3419             TOKEN_NAME,
3420             TOKEN_DECIMALS,
3421             TOKEN_SYMBOL,
3422             VERSION
3423         )
3424         DailyAndSnapshotable(0)
3425         NeumarkIssuanceCurve()
3426         Reclaimable()
3427         public
3428     {}
3429 
3430     ////////////////////////
3431     // Public functions
3432     ////////////////////////
3433 
3434     /// @notice issues new Neumarks to msg.sender with reward at current curve position
3435     ///     moves curve position by euroUlps
3436     ///     callable only by ROLE_NEUMARK_ISSUER
3437     function issueForEuro(uint256 euroUlps)
3438         public
3439         only(ROLE_NEUMARK_ISSUER)
3440         acceptAgreement(msg.sender)
3441         returns (uint256)
3442     {
3443         require(_totalEurUlps + euroUlps >= _totalEurUlps);
3444         uint256 neumarkUlps = incremental(_totalEurUlps, euroUlps);
3445         _totalEurUlps += euroUlps;
3446         mGenerateTokens(msg.sender, neumarkUlps);
3447         emit LogNeumarksIssued(msg.sender, euroUlps, neumarkUlps);
3448         return neumarkUlps;
3449     }
3450 
3451     /// @notice used by ROLE_NEUMARK_ISSUER to transer newly issued neumarks
3452     ///     typically to the investor and platform operator
3453     function distribute(address to, uint256 neumarkUlps)
3454         public
3455         only(ROLE_NEUMARK_ISSUER)
3456         acceptAgreement(to)
3457     {
3458         mTransfer(msg.sender, to, neumarkUlps);
3459     }
3460 
3461     /// @notice msg.sender can burn their Neumarks, curve is rolled back using inverse
3462     ///     curve. as a result cost of Neumark gets lower (reward is higher)
3463     function burn(uint256 neumarkUlps)
3464         public
3465         only(ROLE_NEUMARK_BURNER)
3466     {
3467         burnPrivate(neumarkUlps, 0, _totalEurUlps);
3468     }
3469 
3470     /// @notice executes as function above but allows to provide search range for low gas burning
3471     function burn(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
3472         public
3473         only(ROLE_NEUMARK_BURNER)
3474     {
3475         burnPrivate(neumarkUlps, minEurUlps, maxEurUlps);
3476     }
3477 
3478     function enableTransfer(bool enabled)
3479         public
3480         only(ROLE_TRANSFER_ADMIN)
3481     {
3482         _transferEnabled = enabled;
3483     }
3484 
3485     function createSnapshot()
3486         public
3487         only(ROLE_SNAPSHOT_CREATOR)
3488         returns (uint256)
3489     {
3490         return DailyAndSnapshotable.createSnapshot();
3491     }
3492 
3493     function transferEnabled()
3494         public
3495         constant
3496         returns (bool)
3497     {
3498         return _transferEnabled;
3499     }
3500 
3501     function totalEuroUlps()
3502         public
3503         constant
3504         returns (uint256)
3505     {
3506         return _totalEurUlps;
3507     }
3508 
3509     function incremental(uint256 euroUlps)
3510         public
3511         constant
3512         returns (uint256 neumarkUlps)
3513     {
3514         return incremental(_totalEurUlps, euroUlps);
3515     }
3516 
3517     //
3518     // Implements IERC223Token with IERC223Callback (onTokenTransfer) callback
3519     //
3520 
3521     // old implementation of ERC223 that was actual when ICBM was deployed
3522     // as Neumark is already deployed this function keeps old behavior for testing
3523     function transfer(address to, uint256 amount, bytes data)
3524         public
3525         returns (bool)
3526     {
3527         // it is necessary to point out implementation to be called
3528         BasicSnapshotToken.mTransfer(msg.sender, to, amount);
3529 
3530         // Notify the receiving contract.
3531         if (isContract(to)) {
3532             IERC223LegacyCallback(to).onTokenTransfer(msg.sender, amount, data);
3533         }
3534         return true;
3535     }
3536 
3537     ////////////////////////
3538     // Internal functions
3539     ////////////////////////
3540 
3541     //
3542     // Implements MTokenController
3543     //
3544 
3545     function mOnTransfer(
3546         address from,
3547         address, // to
3548         uint256 // amount
3549     )
3550         internal
3551         acceptAgreement(from)
3552         returns (bool allow)
3553     {
3554         // must have transfer enabled or msg.sender is Neumark issuer
3555         return _transferEnabled || accessPolicy().allowed(msg.sender, ROLE_NEUMARK_ISSUER, this, msg.sig);
3556     }
3557 
3558     function mOnApprove(
3559         address owner,
3560         address, // spender,
3561         uint256 // amount
3562     )
3563         internal
3564         acceptAgreement(owner)
3565         returns (bool allow)
3566     {
3567         return true;
3568     }
3569 
3570     ////////////////////////
3571     // Private functions
3572     ////////////////////////
3573 
3574     function burnPrivate(uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
3575         private
3576     {
3577         uint256 prevEuroUlps = _totalEurUlps;
3578         // burn first in the token to make sure balance/totalSupply is not crossed
3579         mDestroyTokens(msg.sender, burnNeumarkUlps);
3580         _totalEurUlps = cumulativeInverse(totalSupply(), minEurUlps, maxEurUlps);
3581         // actually may overflow on non-monotonic inverse
3582         assert(prevEuroUlps >= _totalEurUlps);
3583         uint256 euroUlps = prevEuroUlps - _totalEurUlps;
3584         emit LogNeumarksBurned(msg.sender, euroUlps, burnNeumarkUlps);
3585     }
3586 }
3587 
3588 /// @title disburse payment token amount to snapshot token holders
3589 /// @dev payment token received via ERC223 Transfer
3590 contract IFeeDisbursal is IERC223Callback {
3591     // TODO: declare interface
3592 }
3593 
3594 /// @title disburse payment token amount to snapshot token holders
3595 /// @dev payment token received via ERC223 Transfer
3596 contract IPlatformPortfolio is IERC223Callback {
3597     // TODO: declare interface
3598 }
3599 
3600 contract ITokenExchangeRateOracle {
3601     /// @notice provides actual price of 'numeratorToken' in 'denominatorToken'
3602     ///     returns timestamp at which price was obtained in oracle
3603     function getExchangeRate(address numeratorToken, address denominatorToken)
3604         public
3605         constant
3606         returns (uint256 rateFraction, uint256 timestamp);
3607 
3608     /// @notice allows to retreive multiple exchange rates in once call
3609     function getExchangeRates(address[] numeratorTokens, address[] denominatorTokens)
3610         public
3611         constant
3612         returns (uint256[] rateFractions, uint256[] timestamps);
3613 }
3614 
3615 /// @title root of trust and singletons + known interface registry
3616 /// provides a root which holds all interfaces platform trust, this includes
3617 /// singletons - for which accessors are provided
3618 /// collections of known instances of interfaces
3619 /// @dev interfaces are identified by bytes4, see KnownInterfaces.sol
3620 contract Universe is
3621     Agreement,
3622     IContractId,
3623     KnownInterfaces
3624 {
3625     ////////////////////////
3626     // Events
3627     ////////////////////////
3628 
3629     /// raised on any change of singleton instance
3630     /// @dev for convenience we provide previous instance of singleton in replacedInstance
3631     event LogSetSingleton(
3632         bytes4 interfaceId,
3633         address instance,
3634         address replacedInstance
3635     );
3636 
3637     /// raised on add/remove interface instance in collection
3638     event LogSetCollectionInterface(
3639         bytes4 interfaceId,
3640         address instance,
3641         bool isSet
3642     );
3643 
3644     ////////////////////////
3645     // Mutable state
3646     ////////////////////////
3647 
3648     // mapping of known contracts to addresses of singletons
3649     mapping(bytes4 => address) private _singletons;
3650 
3651     // mapping of known interfaces to collections of contracts
3652     mapping(bytes4 =>
3653         mapping(address => bool)) private _collections; // solium-disable-line indentation
3654 
3655     // known instances
3656     mapping(address => bytes4[]) private _instances;
3657 
3658 
3659     ////////////////////////
3660     // Constructor
3661     ////////////////////////
3662 
3663     constructor(
3664         IAccessPolicy accessPolicy,
3665         IEthereumForkArbiter forkArbiter
3666     )
3667         Agreement(accessPolicy, forkArbiter)
3668         public
3669     {
3670         setSingletonPrivate(KNOWN_INTERFACE_ACCESS_POLICY, accessPolicy);
3671         setSingletonPrivate(KNOWN_INTERFACE_FORK_ARBITER, forkArbiter);
3672     }
3673 
3674     ////////////////////////
3675     // Public methods
3676     ////////////////////////
3677 
3678     /// get singleton instance for 'interfaceId'
3679     function getSingleton(bytes4 interfaceId)
3680         public
3681         constant
3682         returns (address)
3683     {
3684         return _singletons[interfaceId];
3685     }
3686 
3687     function getManySingletons(bytes4[] interfaceIds)
3688         public
3689         constant
3690         returns (address[])
3691     {
3692         address[] memory addresses = new address[](interfaceIds.length);
3693         uint256 idx;
3694         while(idx < interfaceIds.length) {
3695             addresses[idx] = _singletons[interfaceIds[idx]];
3696             idx += 1;
3697         }
3698         return addresses;
3699     }
3700 
3701     /// checks of 'instance' is instance of interface 'interfaceId'
3702     function isSingleton(bytes4 interfaceId, address instance)
3703         public
3704         constant
3705         returns (bool)
3706     {
3707         return _singletons[interfaceId] == instance;
3708     }
3709 
3710     /// checks if 'instance' is one of instances of 'interfaceId'
3711     function isInterfaceCollectionInstance(bytes4 interfaceId, address instance)
3712         public
3713         constant
3714         returns (bool)
3715     {
3716         return _collections[interfaceId][instance];
3717     }
3718 
3719     function isAnyOfInterfaceCollectionInstance(bytes4[] interfaceIds, address instance)
3720         public
3721         constant
3722         returns (bool)
3723     {
3724         uint256 idx;
3725         while(idx < interfaceIds.length) {
3726             if (_collections[interfaceIds[idx]][instance]) {
3727                 return true;
3728             }
3729             idx += 1;
3730         }
3731         return false;
3732     }
3733 
3734     /// gets all interfaces of given instance
3735     function getInterfacesOfInstance(address instance)
3736         public
3737         constant
3738         returns (bytes4[] interfaces)
3739     {
3740         return _instances[instance];
3741     }
3742 
3743     /// sets 'instance' of singleton with interface 'interfaceId'
3744     function setSingleton(bytes4 interfaceId, address instance)
3745         public
3746         only(ROLE_UNIVERSE_MANAGER)
3747     {
3748         setSingletonPrivate(interfaceId, instance);
3749     }
3750 
3751     /// convenience method for setting many singleton instances
3752     function setManySingletons(bytes4[] interfaceIds, address[] instances)
3753         public
3754         only(ROLE_UNIVERSE_MANAGER)
3755     {
3756         require(interfaceIds.length == instances.length);
3757         uint256 idx;
3758         while(idx < interfaceIds.length) {
3759             setSingletonPrivate(interfaceIds[idx], instances[idx]);
3760             idx += 1;
3761         }
3762     }
3763 
3764     /// set or unset 'instance' with 'interfaceId' in collection of instances
3765     function setCollectionInterface(bytes4 interfaceId, address instance, bool set)
3766         public
3767         only(ROLE_UNIVERSE_MANAGER)
3768     {
3769         setCollectionPrivate(interfaceId, instance, set);
3770     }
3771 
3772     /// set or unset 'instance' in many collections of instances
3773     function setInterfaceInManyCollections(bytes4[] interfaceIds, address instance, bool set)
3774         public
3775         only(ROLE_UNIVERSE_MANAGER)
3776     {
3777         uint256 idx;
3778         while(idx < interfaceIds.length) {
3779             setCollectionPrivate(interfaceIds[idx], instance, set);
3780             idx += 1;
3781         }
3782     }
3783 
3784     /// set or unset array of collection
3785     function setCollectionsInterfaces(bytes4[] interfaceIds, address[] instances, bool[] set_flags)
3786         public
3787         only(ROLE_UNIVERSE_MANAGER)
3788     {
3789         require(interfaceIds.length == instances.length);
3790         require(interfaceIds.length == set_flags.length);
3791         uint256 idx;
3792         while(idx < interfaceIds.length) {
3793             setCollectionPrivate(interfaceIds[idx], instances[idx], set_flags[idx]);
3794             idx += 1;
3795         }
3796     }
3797 
3798     //
3799     // Implements IContractId
3800     //
3801 
3802     function contractId() public pure returns (bytes32 id, uint256 version) {
3803         return (0x8b57bfe21a3ef4854e19d702063b6cea03fa514162f8ff43fde551f06372fefd, 0);
3804     }
3805 
3806     ////////////////////////
3807     // Getters
3808     ////////////////////////
3809 
3810     function accessPolicy() public constant returns (IAccessPolicy) {
3811         return IAccessPolicy(_singletons[KNOWN_INTERFACE_ACCESS_POLICY]);
3812     }
3813 
3814     function forkArbiter() public constant returns (IEthereumForkArbiter) {
3815         return IEthereumForkArbiter(_singletons[KNOWN_INTERFACE_FORK_ARBITER]);
3816     }
3817 
3818     function neumark() public constant returns (Neumark) {
3819         return Neumark(_singletons[KNOWN_INTERFACE_NEUMARK]);
3820     }
3821 
3822     function etherToken() public constant returns (IERC223Token) {
3823         return IERC223Token(_singletons[KNOWN_INTERFACE_ETHER_TOKEN]);
3824     }
3825 
3826     function euroToken() public constant returns (IERC223Token) {
3827         return IERC223Token(_singletons[KNOWN_INTERFACE_EURO_TOKEN]);
3828     }
3829 
3830     function etherLock() public constant returns (address) {
3831         return _singletons[KNOWN_INTERFACE_ETHER_LOCK];
3832     }
3833 
3834     function euroLock() public constant returns (address) {
3835         return _singletons[KNOWN_INTERFACE_EURO_LOCK];
3836     }
3837 
3838     function icbmEtherLock() public constant returns (address) {
3839         return _singletons[KNOWN_INTERFACE_ICBM_ETHER_LOCK];
3840     }
3841 
3842     function icbmEuroLock() public constant returns (address) {
3843         return _singletons[KNOWN_INTERFACE_ICBM_EURO_LOCK];
3844     }
3845 
3846     function identityRegistry() public constant returns (address) {
3847         return IIdentityRegistry(_singletons[KNOWN_INTERFACE_IDENTITY_REGISTRY]);
3848     }
3849 
3850     function tokenExchangeRateOracle() public constant returns (address) {
3851         return ITokenExchangeRateOracle(_singletons[KNOWN_INTERFACE_TOKEN_EXCHANGE_RATE_ORACLE]);
3852     }
3853 
3854     function feeDisbursal() public constant returns (address) {
3855         return IFeeDisbursal(_singletons[KNOWN_INTERFACE_FEE_DISBURSAL]);
3856     }
3857 
3858     function platformPortfolio() public constant returns (address) {
3859         return IPlatformPortfolio(_singletons[KNOWN_INTERFACE_PLATFORM_PORTFOLIO]);
3860     }
3861 
3862     function tokenExchange() public constant returns (address) {
3863         return _singletons[KNOWN_INTERFACE_TOKEN_EXCHANGE];
3864     }
3865 
3866     function gasExchange() public constant returns (address) {
3867         return _singletons[KNOWN_INTERFACE_GAS_EXCHANGE];
3868     }
3869 
3870     function platformTerms() public constant returns (address) {
3871         return _singletons[KNOWN_INTERFACE_PLATFORM_TERMS];
3872     }
3873 
3874     ////////////////////////
3875     // Private methods
3876     ////////////////////////
3877 
3878     function setSingletonPrivate(bytes4 interfaceId, address instance)
3879         private
3880     {
3881         require(interfaceId != KNOWN_INTERFACE_UNIVERSE, "NF_UNI_NO_UNIVERSE_SINGLETON");
3882         address replacedInstance = _singletons[interfaceId];
3883         // do nothing if not changing
3884         if (replacedInstance != instance) {
3885             dropInstance(replacedInstance, interfaceId);
3886             addInstance(instance, interfaceId);
3887             _singletons[interfaceId] = instance;
3888         }
3889 
3890         emit LogSetSingleton(interfaceId, instance, replacedInstance);
3891     }
3892 
3893     function setCollectionPrivate(bytes4 interfaceId, address instance, bool set)
3894         private
3895     {
3896         // do nothing if not changing
3897         if (_collections[interfaceId][instance] == set) {
3898             return;
3899         }
3900         _collections[interfaceId][instance] = set;
3901         if (set) {
3902             addInstance(instance, interfaceId);
3903         } else {
3904             dropInstance(instance, interfaceId);
3905         }
3906         emit LogSetCollectionInterface(interfaceId, instance, set);
3907     }
3908 
3909     function addInstance(address instance, bytes4 interfaceId)
3910         private
3911     {
3912         if (instance == address(0)) {
3913             // do not add null instance
3914             return;
3915         }
3916         bytes4[] storage current = _instances[instance];
3917         uint256 idx;
3918         while(idx < current.length) {
3919             // instancy has this interface already, do nothing
3920             if (current[idx] == interfaceId)
3921                 return;
3922             idx += 1;
3923         }
3924         // new interface
3925         current.push(interfaceId);
3926     }
3927 
3928     function dropInstance(address instance, bytes4 interfaceId)
3929         private
3930     {
3931         if (instance == address(0)) {
3932             // do not drop null instance
3933             return;
3934         }
3935         bytes4[] storage current = _instances[instance];
3936         uint256 idx;
3937         uint256 last = current.length - 1;
3938         while(idx <= last) {
3939             if (current[idx] == interfaceId) {
3940                 // delete element
3941                 if (idx < last) {
3942                     // if not last element move last element to idx being deleted
3943                     current[idx] = current[last];
3944                 }
3945                 // delete last element
3946                 current.length -= 1;
3947                 return;
3948             }
3949             idx += 1;
3950         }
3951     }
3952 }
3953 
3954 /// @notice mixin that enables contract to receive migration
3955 /// @dev when derived from
3956 contract MigrationTarget is
3957     IMigrationTarget
3958 {
3959     ////////////////////////
3960     // Modifiers
3961     ////////////////////////
3962 
3963     // intended to be applied on migration receiving function
3964     modifier onlyMigrationSource() {
3965         require(msg.sender == currentMigrationSource(), "NF_INV_SOURCE");
3966         _;
3967     }
3968 }
3969 
3970 /// @notice implemented in the contract that is the target of LockedAccount migration
3971 ///  migration process is removing investors balance from source LockedAccount fully
3972 ///  target should re-create investor with the same balance, totalLockedAmount and totalInvestors are invariant during migration
3973 contract ICBMLockedAccountMigration is
3974     MigrationTarget
3975 {
3976     ////////////////////////
3977     // Public functions
3978     ////////////////////////
3979 
3980     // implemented in migration target, apply `onlyMigrationSource()` modifier, modifiers are not inherited
3981     function migrateInvestor(
3982         address investor,
3983         uint256 balance,
3984         uint256 neumarksDue,
3985         uint256 unlockDate
3986     )
3987         public;
3988 
3989 }
3990 
3991 /// @title standard access roles of the Platform
3992 /// @dev constants are kept in CODE not in STORAGE so they are comparatively cheap
3993 contract ICBMRoles {
3994 
3995     ////////////////////////
3996     // Constants
3997     ////////////////////////
3998 
3999     // NOTE: All roles are set to the keccak256 hash of the
4000     // CamelCased role name, i.e.
4001     // ROLE_LOCKED_ACCOUNT_ADMIN = keccak256("LockedAccountAdmin")
4002 
4003     // may setup LockedAccount, change disbursal mechanism and set migration
4004     bytes32 internal constant ROLE_LOCKED_ACCOUNT_ADMIN = 0x4675da546d2d92c5b86c4f726a9e61010dce91cccc2491ce6019e78b09d2572e;
4005 
4006     // may setup whitelists and abort whitelisting contract with curve rollback
4007     bytes32 internal constant ROLE_WHITELIST_ADMIN = 0xaef456e7c864418e1d2a40d996ca4febf3a7e317fe3af5a7ea4dda59033bbe5c;
4008 }
4009 
4010 contract TimeSource {
4011 
4012     ////////////////////////
4013     // Internal functions
4014     ////////////////////////
4015 
4016     function currentTime() internal constant returns (uint256) {
4017         return block.timestamp;
4018     }
4019 }
4020 
4021 contract ICBMLockedAccount is
4022     AccessControlled,
4023     ICBMRoles,
4024     TimeSource,
4025     Math,
4026     IsContract,
4027     MigrationSource,
4028     IERC677Callback,
4029     Reclaimable
4030 {
4031 
4032     ////////////////////////
4033     // Type declarations
4034     ////////////////////////
4035 
4036     // state space of LockedAccount
4037     enum LockState {
4038         // controller is not yet set
4039         Uncontrolled,
4040         // new funds lockd are accepted from investors
4041         AcceptingLocks,
4042         // funds may be unlocked by investors, final state
4043         AcceptingUnlocks,
4044         // funds may be unlocked by investors, without any constraints, final state
4045         ReleaseAll
4046     }
4047 
4048     // represents locked account of the investor
4049     struct Account {
4050         // funds locked in the account
4051         uint256 balance;
4052         // neumark amount that must be returned to unlock
4053         uint256 neumarksDue;
4054         // date with which unlock may happen without penalty
4055         uint256 unlockDate;
4056     }
4057 
4058     ////////////////////////
4059     // Immutable state
4060     ////////////////////////
4061 
4062     // a token controlled by LockedAccount, read ERC20 + extensions to read what
4063     // token is it (ETH/EUR etc.)
4064     IERC677Token private ASSET_TOKEN;
4065 
4066     Neumark private NEUMARK;
4067 
4068     // longstop period in seconds
4069     uint256 private LOCK_PERIOD;
4070 
4071     // penalty: decimalFraction of stored amount on escape hatch
4072     uint256 private PENALTY_FRACTION;
4073 
4074     ////////////////////////
4075     // Mutable state
4076     ////////////////////////
4077 
4078     // total amount of tokens locked
4079     uint256 private _totalLockedAmount;
4080 
4081     // total number of locked investors
4082     uint256 internal _totalInvestors;
4083 
4084     // current state of the locking contract
4085     LockState private _lockState;
4086 
4087     // controlling contract that may lock money or unlock all account if fails
4088     address private _controller;
4089 
4090     // fee distribution pool
4091     address private _penaltyDisbursalAddress;
4092 
4093     // LockedAccountMigration private migration;
4094     mapping(address => Account) internal _accounts;
4095 
4096     ////////////////////////
4097     // Events
4098     ////////////////////////
4099 
4100     /// @notice logged when funds are locked by investor
4101     /// @param investor address of investor locking funds
4102     /// @param amount amount of newly locked funds
4103     /// @param amount of neumarks that must be returned to unlock funds
4104     event LogFundsLocked(
4105         address indexed investor,
4106         uint256 amount,
4107         uint256 neumarks
4108     );
4109 
4110     /// @notice logged when investor unlocks funds
4111     /// @param investor address of investor unlocking funds
4112     /// @param amount amount of unlocked funds
4113     /// @param neumarks amount of Neumarks that was burned
4114     event LogFundsUnlocked(
4115         address indexed investor,
4116         uint256 amount,
4117         uint256 neumarks
4118     );
4119 
4120     /// @notice logged when unlock penalty is disbursed to Neumark holders
4121     /// @param disbursalPoolAddress address of disbursal pool receiving penalty
4122     /// @param amount penalty amount
4123     /// @param assetToken address of token contract penalty was paid with
4124     /// @param investor addres of investor paying penalty
4125     /// @dev assetToken and investor parameters are added for quick tallying penalty payouts
4126     event LogPenaltyDisbursed(
4127         address indexed disbursalPoolAddress,
4128         uint256 amount,
4129         address assetToken,
4130         address investor
4131     );
4132 
4133     /// @notice logs Locked Account state transitions
4134     event LogLockStateTransition(
4135         LockState oldState,
4136         LockState newState
4137     );
4138 
4139     event LogInvestorMigrated(
4140         address indexed investor,
4141         uint256 amount,
4142         uint256 neumarks,
4143         uint256 unlockDate
4144     );
4145 
4146     ////////////////////////
4147     // Modifiers
4148     ////////////////////////
4149 
4150     modifier onlyController() {
4151         require(msg.sender == address(_controller));
4152         _;
4153     }
4154 
4155     modifier onlyState(LockState state) {
4156         require(_lockState == state);
4157         _;
4158     }
4159 
4160     modifier onlyStates(LockState state1, LockState state2) {
4161         require(_lockState == state1 || _lockState == state2);
4162         _;
4163     }
4164 
4165     ////////////////////////
4166     // Constructor
4167     ////////////////////////
4168 
4169     /// @notice creates new LockedAccount instance
4170     /// @param policy governs execution permissions to admin functions
4171     /// @param assetToken token contract representing funds locked
4172     /// @param neumark Neumark token contract
4173     /// @param penaltyDisbursalAddress address of disbursal contract for penalty fees
4174     /// @param lockPeriod period for which funds are locked, in seconds
4175     /// @param penaltyFraction decimal fraction of unlocked amount paid as penalty,
4176     ///     if unlocked before lockPeriod is over
4177     /// @dev this implementation does not allow spending funds on ICOs but provides
4178     ///     a migration mechanism to final LockedAccount with such functionality
4179     constructor(
4180         IAccessPolicy policy,
4181         IERC677Token assetToken,
4182         Neumark neumark,
4183         address penaltyDisbursalAddress,
4184         uint256 lockPeriod,
4185         uint256 penaltyFraction
4186     )
4187         MigrationSource(policy, ROLE_LOCKED_ACCOUNT_ADMIN)
4188         Reclaimable()
4189         public
4190     {
4191         ASSET_TOKEN = assetToken;
4192         NEUMARK = neumark;
4193         LOCK_PERIOD = lockPeriod;
4194         PENALTY_FRACTION = penaltyFraction;
4195         _penaltyDisbursalAddress = penaltyDisbursalAddress;
4196     }
4197 
4198     ////////////////////////
4199     // Public functions
4200     ////////////////////////
4201 
4202     /// @notice locks funds of investors for a period of time
4203     /// @param investor funds owner
4204     /// @param amount amount of funds locked
4205     /// @param neumarks amount of neumarks that needs to be returned by investor to unlock funds
4206     /// @dev callable only from controller (Commitment) contract
4207     function lock(address investor, uint256 amount, uint256 neumarks)
4208         public
4209         onlyState(LockState.AcceptingLocks)
4210         onlyController()
4211     {
4212         require(amount > 0);
4213         // transfer to itself from Commitment contract allowance
4214         assert(ASSET_TOKEN.transferFrom(msg.sender, address(this), amount));
4215 
4216         Account storage account = _accounts[investor];
4217         account.balance = addBalance(account.balance, amount);
4218         account.neumarksDue = add(account.neumarksDue, neumarks);
4219 
4220         if (account.unlockDate == 0) {
4221             // this is new account - unlockDate always > 0
4222             _totalInvestors += 1;
4223             account.unlockDate = currentTime() + LOCK_PERIOD;
4224         }
4225         emit LogFundsLocked(investor, amount, neumarks);
4226     }
4227 
4228     /// @notice unlocks investors funds, see unlockInvestor for details
4229     /// @dev function requires that proper allowance on Neumark is made to LockedAccount by msg.sender
4230     ///     except in ReleaseAll state which does not burn Neumark
4231     function unlock()
4232         public
4233         onlyStates(LockState.AcceptingUnlocks, LockState.ReleaseAll)
4234     {
4235         unlockInvestor(msg.sender);
4236     }
4237 
4238     /// @notice unlocks investors funds, see unlockInvestor for details
4239     /// @dev this ERC667 callback by Neumark contract after successful approve
4240     ///     allows to unlock and allow neumarks to be burned in one transaction
4241     function receiveApproval(
4242         address from,
4243         uint256, // _amount,
4244         address _token,
4245         bytes _data
4246     )
4247         public
4248         onlyState(LockState.AcceptingUnlocks)
4249         returns (bool)
4250     {
4251         require(msg.sender == _token);
4252         require(_data.length == 0);
4253 
4254         // only from neumarks
4255         require(_token == address(NEUMARK));
4256 
4257         // this will check if allowance was made and if _amount is enough to
4258         //  unlock, reverts on any error condition
4259         unlockInvestor(from);
4260 
4261         // we assume external call so return value will be lost to clients
4262         // that's why we throw above
4263         return true;
4264     }
4265 
4266     /// allows to anyone to release all funds without burning Neumarks and any
4267     /// other penalties
4268     function controllerFailed()
4269         public
4270         onlyState(LockState.AcceptingLocks)
4271         onlyController()
4272     {
4273         changeState(LockState.ReleaseAll);
4274     }
4275 
4276     /// allows anyone to use escape hatch
4277     function controllerSucceeded()
4278         public
4279         onlyState(LockState.AcceptingLocks)
4280         onlyController()
4281     {
4282         changeState(LockState.AcceptingUnlocks);
4283     }
4284 
4285     function setController(address controller)
4286         public
4287         only(ROLE_LOCKED_ACCOUNT_ADMIN)
4288         onlyState(LockState.Uncontrolled)
4289     {
4290         _controller = controller;
4291         changeState(LockState.AcceptingLocks);
4292     }
4293 
4294     /// sets address to which tokens from unlock penalty are sent
4295     /// both simple addresses and contracts are allowed
4296     /// contract needs to implement ApproveAndCallCallback interface
4297     function setPenaltyDisbursal(address penaltyDisbursalAddress)
4298         public
4299         only(ROLE_LOCKED_ACCOUNT_ADMIN)
4300     {
4301         require(penaltyDisbursalAddress != address(0));
4302 
4303         // can be changed at any moment by admin
4304         _penaltyDisbursalAddress = penaltyDisbursalAddress;
4305     }
4306 
4307     function assetToken()
4308         public
4309         constant
4310         returns (IERC677Token)
4311     {
4312         return ASSET_TOKEN;
4313     }
4314 
4315     function neumark()
4316         public
4317         constant
4318         returns (Neumark)
4319     {
4320         return NEUMARK;
4321     }
4322 
4323     function lockPeriod()
4324         public
4325         constant
4326         returns (uint256)
4327     {
4328         return LOCK_PERIOD;
4329     }
4330 
4331     function penaltyFraction()
4332         public
4333         constant
4334         returns (uint256)
4335     {
4336         return PENALTY_FRACTION;
4337     }
4338 
4339     function balanceOf(address investor)
4340         public
4341         constant
4342         returns (uint256, uint256, uint256)
4343     {
4344         Account storage account = _accounts[investor];
4345         return (account.balance, account.neumarksDue, account.unlockDate);
4346     }
4347 
4348     function controller()
4349         public
4350         constant
4351         returns (address)
4352     {
4353         return _controller;
4354     }
4355 
4356     function lockState()
4357         public
4358         constant
4359         returns (LockState)
4360     {
4361         return _lockState;
4362     }
4363 
4364     function totalLockedAmount()
4365         public
4366         constant
4367         returns (uint256)
4368     {
4369         return _totalLockedAmount;
4370     }
4371 
4372     function totalInvestors()
4373         public
4374         constant
4375         returns (uint256)
4376     {
4377         return _totalInvestors;
4378     }
4379 
4380     function penaltyDisbursalAddress()
4381         public
4382         constant
4383         returns (address)
4384     {
4385         return _penaltyDisbursalAddress;
4386     }
4387 
4388     //
4389     // Overrides migration source
4390     //
4391 
4392     /// enables migration to new LockedAccount instance
4393     /// it can be set only once to prevent setting temporary migrations that let
4394     /// just one investor out
4395     /// may be set in AcceptingLocks state (in unlikely event that controller
4396     /// fails we let investors out)
4397     /// and AcceptingUnlocks - which is normal operational mode
4398     function enableMigration(IMigrationTarget migration)
4399         public
4400         onlyStates(LockState.AcceptingLocks, LockState.AcceptingUnlocks)
4401     {
4402         // will enforce other access controls
4403         MigrationSource.enableMigration(migration);
4404     }
4405 
4406     /// migrates single investor
4407     function migrate()
4408         public
4409         onlyMigrationEnabled()
4410     {
4411         // migrates
4412         Account memory account = _accounts[msg.sender];
4413 
4414         // return on non existing accounts silently
4415         if (account.balance == 0) {
4416             return;
4417         }
4418 
4419         // this will clear investor storage
4420         removeInvestor(msg.sender, account.balance);
4421 
4422         // let migration target to own asset balance that belongs to investor
4423         assert(ASSET_TOKEN.approve(address(_migration), account.balance));
4424         ICBMLockedAccountMigration(_migration).migrateInvestor(
4425             msg.sender,
4426             account.balance,
4427             account.neumarksDue,
4428             account.unlockDate
4429         );
4430         emit LogInvestorMigrated(msg.sender, account.balance, account.neumarksDue, account.unlockDate);
4431     }
4432 
4433     //
4434     // Overrides Reclaimable
4435     //
4436 
4437     /// @notice allows LockedAccount to reclaim tokens wrongly sent to its address
4438     /// @dev as LockedAccount by design has balance of assetToken (in the name of investors)
4439     ///     such reclamation is not allowed
4440     function reclaim(IBasicToken token)
4441         public
4442     {
4443         // forbid reclaiming locked tokens
4444         require(token != ASSET_TOKEN);
4445         Reclaimable.reclaim(token);
4446     }
4447 
4448     ////////////////////////
4449     // Internal functions
4450     ////////////////////////
4451 
4452     function addBalance(uint256 balance, uint256 amount)
4453         internal
4454         returns (uint256)
4455     {
4456         _totalLockedAmount = add(_totalLockedAmount, amount);
4457         uint256 newBalance = balance + amount;
4458         return newBalance;
4459     }
4460 
4461     ////////////////////////
4462     // Private functions
4463     ////////////////////////
4464 
4465     function subBalance(uint256 balance, uint256 amount)
4466         private
4467         returns (uint256)
4468     {
4469         _totalLockedAmount -= amount;
4470         return balance - amount;
4471     }
4472 
4473     function removeInvestor(address investor, uint256 balance)
4474         private
4475     {
4476         subBalance(balance, balance);
4477         _totalInvestors -= 1;
4478         delete _accounts[investor];
4479     }
4480 
4481     function changeState(LockState newState)
4482         private
4483     {
4484         assert(newState != _lockState);
4485         emit LogLockStateTransition(_lockState, newState);
4486         _lockState = newState;
4487     }
4488 
4489     /// @notice unlocks 'investor' tokens by making them withdrawable from assetToken
4490     /// @dev expects number of neumarks that is due on investor's account to be approved for LockedAccount for transfer
4491     /// @dev there are 3 unlock modes depending on contract and investor state
4492     ///     in 'AcceptingUnlocks' state Neumarks due will be burned and funds transferred to investors address in assetToken,
4493     ///         before unlockDate, penalty is deduced and distributed
4494     ///     in 'ReleaseAll' neumarks are not burned and unlockDate is not observed, funds are unlocked unconditionally
4495     function unlockInvestor(address investor)
4496         private
4497     {
4498         // use memory storage to obtain copy and be able to erase storage
4499         Account memory accountInMem = _accounts[investor];
4500 
4501         // silently return on non-existing accounts
4502         if (accountInMem.balance == 0) {
4503             return;
4504         }
4505         // remove investor account before external calls
4506         removeInvestor(investor, accountInMem.balance);
4507 
4508         // Neumark burning and penalty processing only in AcceptingUnlocks state
4509         if (_lockState == LockState.AcceptingUnlocks) {
4510             // transfer Neumarks to be burned to itself via allowance mechanism
4511             //  not enough allowance results in revert which is acceptable state so 'require' is used
4512             require(NEUMARK.transferFrom(investor, address(this), accountInMem.neumarksDue));
4513 
4514             // burn neumarks corresponding to unspent funds
4515             NEUMARK.burn(accountInMem.neumarksDue);
4516 
4517             // take the penalty if before unlockDate
4518             if (currentTime() < accountInMem.unlockDate) {
4519                 require(_penaltyDisbursalAddress != address(0));
4520                 uint256 penalty = decimalFraction(accountInMem.balance, PENALTY_FRACTION);
4521 
4522                 // distribute penalty
4523                 if (isContract(_penaltyDisbursalAddress)) {
4524                     require(
4525                         ASSET_TOKEN.approveAndCall(_penaltyDisbursalAddress, penalty, "")
4526                     );
4527                 } else {
4528                     // transfer to simple address
4529                     assert(ASSET_TOKEN.transfer(_penaltyDisbursalAddress, penalty));
4530                 }
4531                 emit LogPenaltyDisbursed(_penaltyDisbursalAddress, penalty, ASSET_TOKEN, investor);
4532                 accountInMem.balance -= penalty;
4533             }
4534         }
4535         if (_lockState == LockState.ReleaseAll) {
4536             accountInMem.neumarksDue = 0;
4537         }
4538         // transfer amount back to investor - now it can withdraw
4539         assert(ASSET_TOKEN.transfer(investor, accountInMem.balance));
4540         emit LogFundsUnlocked(investor, accountInMem.balance, accountInMem.neumarksDue);
4541     }
4542 }
4543 
4544 contract LockedAccount is
4545     Agreement,
4546     Math,
4547     Serialization,
4548     ICBMLockedAccountMigration,
4549     IdentityRecord,
4550     KnownInterfaces,
4551     Reclaimable,
4552     IContractId
4553 {
4554     ////////////////////////
4555     // Type declarations
4556     ////////////////////////
4557 
4558     /// represents locked account of the investor
4559     struct Account {
4560         // funds locked in the account
4561         uint112 balance;
4562         // neumark amount that must be returned to unlock
4563         uint112 neumarksDue;
4564         // date with which unlock may happen without penalty
4565         uint32 unlockDate;
4566     }
4567 
4568     /// represents account migration destination
4569     /// @notice migration destinations require KYC when being set
4570     /// @dev used to setup migration to different wallet if for some reason investors
4571     ///   wants to use different wallet in the Platform than ICBM.
4572     /// @dev it also allows to split the tickets, neumarks due will be split proportionally
4573     struct Destination {
4574         // destination wallet
4575         address investor;
4576         // amount to be migrated to wallet above. 0 means all funds
4577         uint112 amount;
4578     }
4579 
4580     ////////////////////////
4581     // Immutable state
4582     ////////////////////////
4583 
4584     // token that stores investors' funds
4585     IERC223Token private PAYMENT_TOKEN;
4586 
4587     Neumark private NEUMARK;
4588 
4589     // longstop period in seconds
4590     uint256 private LOCK_PERIOD;
4591 
4592     // penalty: decimalFraction of stored amount on escape hatch
4593     uint256 private PENALTY_FRACTION;
4594 
4595     // interface registry
4596     Universe private UNIVERSE;
4597 
4598     // icbm locked account which is migration source
4599     ICBMLockedAccount private MIGRATION_SOURCE;
4600 
4601     // old payment token
4602     IERC677Token private OLD_PAYMENT_TOKEN;
4603 
4604     ////////////////////////
4605     // Mutable state
4606     ////////////////////////
4607 
4608     // total amount of tokens locked
4609     uint112 private _totalLockedAmount;
4610 
4611     // total number of locked investors
4612     uint256 internal _totalInvestors;
4613 
4614     // all accounts
4615     mapping(address => Account) internal _accounts;
4616 
4617     // tracks investment to be able to control refunds (commitment => investor => account)
4618     mapping(address => mapping(address => Account)) internal _commitments;
4619 
4620     // account migration destinations
4621     mapping(address => Destination[]) private _destinations;
4622 
4623     ////////////////////////
4624     // Events
4625     ////////////////////////
4626 
4627     /// @notice logged when funds are committed to token offering
4628     /// @param investor address
4629     /// @param commitment commitment contract where funds were sent
4630     /// @param amount amount of invested funds
4631     /// @param amount of corresponging Neumarks that successful offering will "unlock"
4632     event LogFundsCommitted(
4633         address indexed investor,
4634         address indexed commitment,
4635         uint256 amount,
4636         uint256 neumarks
4637     );
4638 
4639     /// @notice logged when investor unlocks funds
4640     /// @param investor address of investor unlocking funds
4641     /// @param amount amount of unlocked funds
4642     /// @param neumarks amount of Neumarks that was burned
4643     event LogFundsUnlocked(
4644         address indexed investor,
4645         uint256 amount,
4646         uint256 neumarks
4647     );
4648 
4649     /// @notice logged when investor account is migrated
4650     /// @param investor address receiving the migration
4651     /// @param amount amount of newly migrated funds
4652     /// @param amount of neumarks that must be returned to unlock funds
4653     event LogFundsLocked(
4654         address indexed investor,
4655         uint256 amount,
4656         uint256 neumarks
4657     );
4658 
4659     /// @notice logged when investor funds/obligations moved to different address
4660     /// @param oldInvestor current address
4661     /// @param newInvestor destination address
4662     /// @dev see move function for comments
4663     /*event LogInvestorMoved(
4664         address indexed oldInvestor,
4665         address indexed newInvestor
4666     );*/
4667 
4668     /// @notice logged when funds are locked as a refund by commitment contract
4669     /// @param investor address of refunded investor
4670     /// @param commitment commitment contract sending the refund
4671     /// @param amount refund amount
4672     /// @param amount of neumarks corresponding to the refund
4673     event LogFundsRefunded(
4674         address indexed investor,
4675         address indexed commitment,
4676         uint256 amount,
4677         uint256 neumarks
4678     );
4679 
4680     /// @notice logged when unlock penalty is disbursed to Neumark holders
4681     /// @param disbursalPoolAddress address of disbursal pool receiving penalty
4682     /// @param amount penalty amount
4683     /// @param paymentToken address of token contract penalty was paid with
4684     /// @param investor addres of investor paying penalty
4685     /// @dev paymentToken and investor parameters are added for quick tallying penalty payouts
4686     event LogPenaltyDisbursed(
4687         address indexed disbursalPoolAddress,
4688         address indexed investor,
4689         uint256 amount,
4690         address paymentToken
4691     );
4692 
4693     /// @notice logged when migration destination is set for an investor
4694     event LogMigrationDestination(
4695         address indexed investor,
4696         address indexed destination,
4697         uint256 amount
4698     );
4699 
4700     ////////////////////////
4701     // Modifiers
4702     ////////////////////////
4703 
4704     modifier onlyIfCommitment(address commitment) {
4705         // is allowed token offering
4706         require(UNIVERSE.isInterfaceCollectionInstance(KNOWN_INTERFACE_COMMITMENT, commitment), "NF_LOCKED_ONLY_COMMITMENT");
4707         _;
4708     }
4709 
4710     ////////////////////////
4711     // Constructor
4712     ////////////////////////
4713 
4714     /// @notice creates new LockedAccount instance
4715     /// @param universe provides interface and identity registries
4716     /// @param paymentToken token contract representing funds locked
4717     /// @param migrationSource old locked account
4718     constructor(
4719         Universe universe,
4720         Neumark neumark,
4721         IERC223Token paymentToken,
4722         ICBMLockedAccount migrationSource
4723     )
4724         Agreement(universe.accessPolicy(), universe.forkArbiter())
4725         Reclaimable()
4726         public
4727     {
4728         PAYMENT_TOKEN = paymentToken;
4729         MIGRATION_SOURCE = migrationSource;
4730         OLD_PAYMENT_TOKEN = MIGRATION_SOURCE.assetToken();
4731         UNIVERSE = universe;
4732         NEUMARK = neumark;
4733         LOCK_PERIOD = migrationSource.lockPeriod();
4734         PENALTY_FRACTION = migrationSource.penaltyFraction();
4735         // this is not super sexy but it's very practical against attaching ETH wallet to EUR wallet
4736         // we decrease chances of migration lethal setup errors in non migrated wallets
4737         require(keccak256(abi.encodePacked(ITokenMetadata(OLD_PAYMENT_TOKEN).symbol())) == keccak256(abi.encodePacked(PAYMENT_TOKEN.symbol())));
4738     }
4739 
4740     ////////////////////////
4741     // Public functions
4742     ////////////////////////
4743 
4744     /// @notice commits funds in one of offerings on the platform
4745     /// @param commitment commitment contract with token offering
4746     /// @param amount amount of funds to invest
4747     /// @dev data ignored, to keep compatibility with ERC223
4748     /// @dev happens via ERC223 transfer and callback
4749     function transfer(address commitment, uint256 amount, bytes /*data*/)
4750         public
4751         onlyIfCommitment(commitment)
4752     {
4753         require(amount > 0, "NF_LOCKED_NO_ZERO");
4754         Account storage account = _accounts[msg.sender];
4755         // no overflow with account.balance which is uint112
4756         require(account.balance >= amount, "NF_LOCKED_NO_FUNDS");
4757         // calculate unlocked NEU as proportion of invested amount to account balance
4758         uint112 unlockedNmkUlps = uint112(
4759             proportion(
4760                 account.neumarksDue,
4761                 amount,
4762                 account.balance
4763             )
4764         );
4765         account.balance = subBalance(account.balance, uint112(amount));
4766         // will not overflow as amount < account.balance so unlockedNmkUlps must be >= account.neumarksDue
4767         account.neumarksDue -= unlockedNmkUlps;
4768         // track investment
4769         Account storage investment = _commitments[address(commitment)][msg.sender];
4770         investment.balance += uint112(amount);
4771         investment.neumarksDue += unlockedNmkUlps;
4772         // invest via ERC223 interface
4773         assert(PAYMENT_TOKEN.transfer(commitment, amount, abi.encodePacked(msg.sender)));
4774         emit LogFundsCommitted(msg.sender, commitment, amount, unlockedNmkUlps);
4775     }
4776 
4777     /// @notice unlocks investors funds, see unlockInvestor for details
4778     /// @dev function requires that proper allowance on Neumark is made to LockedAccount by msg.sender
4779     ///     except in ReleaseAll state which does not burn Neumark
4780     function unlock()
4781         public
4782     {
4783         unlockInvestor(msg.sender);
4784     }
4785 
4786     /// @notice unlocks investors funds, see unlockInvestor for details
4787     /// @dev this ERC667 callback by Neumark contract after successful approve
4788     ///     allows to unlock and allow neumarks to be burned in one transaction
4789     function receiveApproval(address from, uint256, address _token, bytes _data)
4790         public
4791         returns (bool)
4792     {
4793         require(msg.sender == _token);
4794         require(_data.length == 0);
4795         // only from neumarks
4796         require(_token == address(NEUMARK), "NF_ONLY_NEU");
4797         // this will check if allowance was made and if _amount is enough to
4798         //  unlock, reverts on any error condition
4799         unlockInvestor(from);
4800         return true;
4801     }
4802 
4803     /// @notice refunds investor in case of failed offering
4804     /// @param investor funds owner
4805     /// @dev callable only by ETO contract, bookkeeping in LockedAccount::_commitments
4806     /// @dev expected that ETO makes allowance for transferFrom
4807     function refunded(address investor)
4808         public
4809     {
4810         Account memory investment = _commitments[msg.sender][investor];
4811         // return silently when there is no refund (so commitment contracts can blank-call, less gas used)
4812         if (investment.balance == 0)
4813             return;
4814         // free gas here
4815         delete _commitments[msg.sender][investor];
4816         Account storage account = _accounts[investor];
4817         // account must exist
4818         require(account.unlockDate > 0, "NF_LOCKED_ACCOUNT_LIQUIDATED");
4819         // add refunded amount
4820         account.balance = addBalance(account.balance, investment.balance);
4821         account.neumarksDue = add112(account.neumarksDue, investment.neumarksDue);
4822         // transfer to itself from Commitment contract allowance
4823         assert(PAYMENT_TOKEN.transferFrom(msg.sender, address(this), investment.balance));
4824         emit LogFundsRefunded(investor, msg.sender, investment.balance, investment.neumarksDue);
4825     }
4826 
4827     /// @notice may be used by commitment contract to refund gas for commitment bookkeeping
4828     /// @dev https://gastoken.io/ (15000 - 900 for a call)
4829     function claimed(address investor) public {
4830         delete _commitments[msg.sender][investor];
4831     }
4832 
4833     /// checks commitments made from locked account that were not settled by ETO via refunded or claimed functions
4834     function pendingCommitments(address commitment, address investor)
4835         public
4836         constant
4837         returns (uint256 balance, uint256 neumarkDue)
4838     {
4839         Account storage i = _commitments[commitment][investor];
4840         return (i.balance, i.neumarksDue);
4841     }
4842 
4843     //
4844     // Implements LockedAccountMigrationTarget
4845     //
4846 
4847     function migrateInvestor(
4848         address investor,
4849         uint256 balance256,
4850         uint256 neumarksDue256,
4851         uint256 unlockDate256
4852     )
4853         public
4854         onlyMigrationSource()
4855     {
4856         // internally we use 112 bits to store amounts
4857         require(balance256 < 2**112, "NF_OVR");
4858         uint112 balance = uint112(balance256);
4859         assert(neumarksDue256 < 2**112);
4860         uint112 neumarksDue = uint112(neumarksDue256);
4861         assert(unlockDate256 < 2**32);
4862         uint32 unlockDate = uint32(unlockDate256);
4863 
4864         // transfer assets
4865         require(OLD_PAYMENT_TOKEN.transferFrom(msg.sender, address(this), balance));
4866         IWithdrawableToken(OLD_PAYMENT_TOKEN).withdraw(balance);
4867         // migrate previous asset token depends on token type, unfortunatelly deposit function differs so we have to cast. this is weak...
4868         if (PAYMENT_TOKEN == UNIVERSE.etherToken()) {
4869             // after EtherToken withdraw, deposit ether into new token
4870             EtherToken(PAYMENT_TOKEN).deposit.value(balance)();
4871         } else {
4872             EuroToken(PAYMENT_TOKEN).deposit(this, balance, 0x0);
4873         }
4874         Destination[] storage destinations = _destinations[investor];
4875         if (destinations.length == 0) {
4876             // if no destinations defined then migrate to original investor wallet
4877             lock(investor, balance, neumarksDue, unlockDate);
4878         } else {
4879             // enumerate all destinations and migrate balance piece by piece
4880             uint256 idx;
4881             while(idx < destinations.length) {
4882                 Destination storage destination = destinations[idx];
4883                 // get partial amount to migrate, if 0 specified then take all, as a result 0 must be the last destination
4884                 uint112 partialAmount = destination.amount == 0 ? balance : destination.amount;
4885                 require(partialAmount <= balance, "NF_LOCKED_ACCOUNT_SPLIT_OVERSPENT");
4886                 // compute corresponding NEU proportionally, result < 10**18 as partialAmount <= balance
4887                 uint112 partialNmkUlps = uint112(
4888                     proportion(
4889                         neumarksDue,
4890                         partialAmount,
4891                         balance
4892                     )
4893                 );
4894                 // no overflow see above
4895                 balance -= partialAmount;
4896                 // no overflow partialNmkUlps <= neumarksDue as as partialAmount <= balance, see proportion
4897                 neumarksDue -= partialNmkUlps;
4898                 // lock partial to destination investor
4899                 lock(destination.investor, partialAmount, partialNmkUlps, unlockDate);
4900                 idx += 1;
4901             }
4902             // all funds and NEU must be migrated
4903             require(balance == 0, "NF_LOCKED_ACCOUNT_SPLIT_UNDERSPENT");
4904             assert(neumarksDue == 0);
4905             // free up gas
4906             delete _destinations[investor];
4907         }
4908     }
4909 
4910     /// @notice changes migration destination for msg.sender
4911     /// @param destinationWallet where migrate funds to, must have valid verification claims
4912     /// @dev msg.sender has funds in old icbm wallet and calls this function on new icbm wallet before s/he migrates
4913     function setInvestorMigrationWallet(address destinationWallet)
4914         public
4915     {
4916         Destination[] storage destinations = _destinations[msg.sender];
4917         // delete old destinations
4918         if(destinations.length > 0) {
4919             delete _destinations[msg.sender];
4920         }
4921         // new destination for the whole amount
4922         addDestination(destinations, destinationWallet, 0);
4923     }
4924 
4925     /// @dev if one of amounts is > 2**112, solidity will pass modulo value, so for 2**112 + 1, we'll get 1
4926     ///      and that's fine
4927     function setInvestorMigrationWallets(address[] wallets, uint112[] amounts)
4928         public
4929     {
4930         require(wallets.length == amounts.length);
4931         Destination[] storage destinations = _destinations[msg.sender];
4932         // delete old destinations
4933         if(destinations.length > 0) {
4934             delete _destinations[msg.sender];
4935         }
4936         uint256 idx;
4937         while(idx < wallets.length) {
4938             addDestination(destinations, wallets[idx], amounts[idx]);
4939             idx += 1;
4940         }
4941     }
4942 
4943     /// @notice returns current set of destination wallets for investor migration
4944     function getInvestorMigrationWallets(address investor)
4945         public
4946         constant
4947         returns (address[] wallets, uint112[] amounts)
4948     {
4949         Destination[] storage destinations = _destinations[investor];
4950         wallets = new address[](destinations.length);
4951         amounts = new uint112[](destinations.length);
4952         uint256 idx;
4953         while(idx < destinations.length) {
4954             wallets[idx] = destinations[idx].investor;
4955             amounts[idx] = destinations[idx].amount;
4956             idx += 1;
4957         }
4958     }
4959 
4960     //
4961     // Implements IMigrationTarget
4962     //
4963 
4964     function currentMigrationSource()
4965         public
4966         constant
4967         returns (address)
4968     {
4969         return address(MIGRATION_SOURCE);
4970     }
4971 
4972     //
4973     // Implements IContractId
4974     //
4975 
4976     function contractId() public pure returns (bytes32 id, uint256 version) {
4977         return (0x15fbe12e85e3698f22c35480f7c66bc38590bb8cfe18cbd6dc3d49355670e561, 0);
4978     }
4979 
4980     //
4981     // Payable default function to receive ether during migration
4982     //
4983     function ()
4984         public
4985         payable
4986     {
4987         require(msg.sender == address(OLD_PAYMENT_TOKEN));
4988     }
4989 
4990     //
4991     // Overrides Reclaimable
4992     //
4993 
4994     /// @notice allows LockedAccount to reclaim tokens wrongly sent to its address
4995     /// @dev as LockedAccount by design has balance of paymentToken (in the name of investors)
4996     ///     such reclamation is not allowed
4997     function reclaim(IBasicToken token)
4998         public
4999     {
5000         // forbid reclaiming locked tokens
5001         require(token != PAYMENT_TOKEN, "NO_PAYMENT_TOKEN_RECLAIM");
5002         Reclaimable.reclaim(token);
5003     }
5004 
5005     //
5006     // Public accessors
5007     //
5008 
5009     function paymentToken()
5010         public
5011         constant
5012         returns (IERC223Token)
5013     {
5014         return PAYMENT_TOKEN;
5015     }
5016 
5017     function neumark()
5018         public
5019         constant
5020         returns (Neumark)
5021     {
5022         return NEUMARK;
5023     }
5024 
5025     function lockPeriod()
5026         public
5027         constant
5028         returns (uint256)
5029     {
5030         return LOCK_PERIOD;
5031     }
5032 
5033     function penaltyFraction()
5034         public
5035         constant
5036         returns (uint256)
5037     {
5038         return PENALTY_FRACTION;
5039     }
5040 
5041     function balanceOf(address investor)
5042         public
5043         constant
5044         returns (uint256 balance, uint256 neumarksDue, uint32 unlockDate)
5045     {
5046         Account storage account = _accounts[investor];
5047         return (account.balance, account.neumarksDue, account.unlockDate);
5048     }
5049 
5050     function totalLockedAmount()
5051         public
5052         constant
5053         returns (uint256)
5054     {
5055         return _totalLockedAmount;
5056     }
5057 
5058     function totalInvestors()
5059         public
5060         constant
5061         returns (uint256)
5062     {
5063         return _totalInvestors;
5064     }
5065 
5066     ////////////////////////
5067     // Internal functions
5068     ////////////////////////
5069 
5070     function addBalance(uint112 balance, uint112 amount)
5071         internal
5072         returns (uint112)
5073     {
5074         _totalLockedAmount = add112(_totalLockedAmount, amount);
5075         // will not overflow as _totalLockedAmount >= balance
5076         return balance + amount;
5077     }
5078 
5079     ////////////////////////
5080     // Private functions
5081     ////////////////////////
5082 
5083     function subBalance(uint112 balance, uint112 amount)
5084         private
5085         returns (uint112)
5086     {
5087         _totalLockedAmount = sub112(_totalLockedAmount, amount);
5088         return sub112(balance, amount);
5089     }
5090 
5091     function removeInvestor(address investor, uint112 balance)
5092         private
5093     {
5094         subBalance(balance, balance);
5095         _totalInvestors -= 1;
5096         delete _accounts[investor];
5097     }
5098 
5099     /// @notice unlocks 'investor' tokens by making them withdrawable from paymentToken
5100     /// @dev expects number of neumarks that is due on investor's account to be approved for LockedAccount for transfer
5101     /// @dev there are 3 unlock modes depending on contract and investor state
5102     ///     in 'AcceptingUnlocks' state Neumarks due will be burned and funds transferred to investors address in paymentToken,
5103     ///         before unlockDate, penalty is deduced and distributed
5104     function unlockInvestor(address investor)
5105         private
5106     {
5107         // use memory storage to obtain copy and be able to erase storage
5108         Account memory accountInMem = _accounts[investor];
5109 
5110         // silently return on non-existing accounts
5111         if (accountInMem.balance == 0) {
5112             return;
5113         }
5114         // remove investor account before external calls
5115         removeInvestor(investor, accountInMem.balance);
5116 
5117         // transfer Neumarks to be burned to itself via allowance mechanism
5118         //  not enough allowance results in revert which is acceptable state so 'require' is used
5119         require(NEUMARK.transferFrom(investor, address(this), accountInMem.neumarksDue));
5120 
5121         // burn neumarks corresponding to unspent funds
5122         NEUMARK.burn(accountInMem.neumarksDue);
5123 
5124         // take the penalty if before unlockDate
5125         if (block.timestamp < accountInMem.unlockDate) {
5126             address penaltyDisbursalAddress = UNIVERSE.feeDisbursal();
5127             require(penaltyDisbursalAddress != address(0));
5128             uint112 penalty = uint112(decimalFraction(accountInMem.balance, PENALTY_FRACTION));
5129             // distribution via ERC223 to contract or simple address
5130             assert(PAYMENT_TOKEN.transfer(penaltyDisbursalAddress, penalty, abi.encodePacked(NEUMARK)));
5131             emit LogPenaltyDisbursed(penaltyDisbursalAddress, investor, penalty, PAYMENT_TOKEN);
5132             accountInMem.balance -= penalty;
5133         }
5134         // transfer amount back to investor - now it can withdraw
5135         assert(PAYMENT_TOKEN.transfer(investor, accountInMem.balance, ""));
5136         emit LogFundsUnlocked(investor, accountInMem.balance, accountInMem.neumarksDue);
5137     }
5138 
5139     /// @notice locks funds of investors for a period of time, called by migration
5140     /// @param investor funds owner
5141     /// @param amount amount of funds locked
5142     /// @param neumarks amount of neumarks that needs to be returned by investor to unlock funds
5143     /// @param unlockDate unlockDate of migrating account
5144     /// @dev used only by migration
5145     function lock(address investor, uint112 amount, uint112 neumarks, uint32 unlockDate)
5146         private
5147         acceptAgreement(investor)
5148     {
5149         require(amount > 0);
5150         Account storage account = _accounts[investor];
5151         if (account.unlockDate == 0) {
5152             // this is new account - unlockDate always > 0
5153             _totalInvestors += 1;
5154         }
5155 
5156         // update holdings
5157         account.balance = addBalance(account.balance, amount);
5158         account.neumarksDue = add112(account.neumarksDue, neumarks);
5159         // overwrite unlockDate if it is earler. we do not supporting joining tickets from different investors
5160         // this will discourage sending 1 wei to move unlock date
5161         if (unlockDate > account.unlockDate) {
5162             account.unlockDate = unlockDate;
5163         }
5164 
5165         emit LogFundsLocked(investor, amount, neumarks);
5166     }
5167 
5168     function addDestination(Destination[] storage destinations, address wallet, uint112 amount)
5169         private
5170     {
5171         // only verified destinations
5172         IIdentityRegistry identityRegistry = IIdentityRegistry(UNIVERSE.identityRegistry());
5173         IdentityClaims memory claims = deserializeClaims(identityRegistry.getClaims(wallet));
5174         require(claims.isVerified && !claims.accountFrozen, "NF_DEST_NO_VERIFICATION");
5175         if (wallet != msg.sender) {
5176             // prevent squatting - cannot set destination for not yet migrated investor
5177             (,,uint256 unlockDate) = MIGRATION_SOURCE.balanceOf(wallet);
5178             require(unlockDate == 0, "NF_DEST_NO_SQUATTING");
5179         }
5180 
5181         destinations.push(
5182             Destination({investor: wallet, amount: amount})
5183         );
5184         emit LogMigrationDestination(msg.sender, wallet, amount);
5185     }
5186 
5187     function sub112(uint112 a, uint112 b) internal pure returns (uint112)
5188     {
5189         assert(b <= a);
5190         return a - b;
5191     }
5192 
5193     function add112(uint112 a, uint112 b) internal pure returns (uint112)
5194     {
5195         uint112 c = a + b;
5196         assert(c >= a);
5197         return c;
5198     }
5199 }
5200 
5201 contract ShareholderRights is IContractId {
5202 
5203     ////////////////////////
5204     // Types
5205     ////////////////////////
5206 
5207     enum VotingRule {
5208         // nominee has no voting rights
5209         NoVotingRights,
5210         // nominee votes yes if token holders do not say otherwise
5211         Positive,
5212         // nominee votes against if token holders do not say otherwise
5213         Negative,
5214         // nominee passes the vote as is giving yes/no split
5215         Proportional
5216     }
5217 
5218     ////////////////////////
5219     // Constants state
5220     ////////////////////////
5221 
5222     bytes32 private constant EMPTY_STRING_HASH = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
5223 
5224     ////////////////////////
5225     // Immutable state
5226     ////////////////////////
5227 
5228     // a right to drag along (or be dragged) on exit
5229     bool public constant HAS_DRAG_ALONG_RIGHTS = true;
5230     // a right to tag along
5231     bool public constant HAS_TAG_ALONG_RIGHTS = true;
5232     // information is fundamental right that cannot be removed
5233     bool public constant HAS_GENERAL_INFORMATION_RIGHTS = true;
5234     // voting Right
5235     VotingRule public GENERAL_VOTING_RULE;
5236     // voting rights in tag along
5237     VotingRule public TAG_ALONG_VOTING_RULE;
5238     // liquidation preference multiplicator as decimal fraction
5239     uint256 public LIQUIDATION_PREFERENCE_MULTIPLIER_FRAC;
5240     // founder's vesting
5241     bool public HAS_FOUNDERS_VESTING;
5242     // duration of general voting
5243     uint256 public GENERAL_VOTING_DURATION;
5244     // duration of restricted act votings (like exit etc.)
5245     uint256 public RESTRICTED_ACT_VOTING_DURATION;
5246     // offchain time to finalize and execute voting;
5247     uint256 public VOTING_FINALIZATION_DURATION;
5248     // quorum of tokenholders for the vote to count as decimal fraction
5249     uint256 public TOKENHOLDERS_QUORUM_FRAC = 10**17; // 10%
5250     // number of tokens voting / total supply must be more than this to count the vote
5251     uint256 public VOTING_MAJORITY_FRAC = 10**17; // 10%
5252     // url (typically IPFS hash) to investment agreement between nominee and company
5253     string public INVESTMENT_AGREEMENT_TEMPLATE_URL;
5254 
5255     ////////////////////////
5256     // Constructor
5257     ////////////////////////
5258 
5259     constructor(
5260         VotingRule generalVotingRule,
5261         VotingRule tagAlongVotingRule,
5262         uint256 liquidationPreferenceMultiplierFrac,
5263         bool hasFoundersVesting,
5264         uint256 generalVotingDuration,
5265         uint256 restrictedActVotingDuration,
5266         uint256 votingFinalizationDuration,
5267         uint256 tokenholdersQuorumFrac,
5268         uint256 votingMajorityFrac,
5269         string investmentAgreementTemplateUrl
5270     )
5271         public
5272     {
5273         // todo: revise requires
5274         require(uint(generalVotingRule) < 4);
5275         require(uint(tagAlongVotingRule) < 4);
5276         // quorum < 100%
5277         require(tokenholdersQuorumFrac < 10**18);
5278         require(keccak256(abi.encodePacked(investmentAgreementTemplateUrl)) != EMPTY_STRING_HASH);
5279 
5280         GENERAL_VOTING_RULE = generalVotingRule;
5281         TAG_ALONG_VOTING_RULE = tagAlongVotingRule;
5282         LIQUIDATION_PREFERENCE_MULTIPLIER_FRAC = liquidationPreferenceMultiplierFrac;
5283         HAS_FOUNDERS_VESTING = hasFoundersVesting;
5284         GENERAL_VOTING_DURATION = generalVotingDuration;
5285         RESTRICTED_ACT_VOTING_DURATION = restrictedActVotingDuration;
5286         VOTING_FINALIZATION_DURATION = votingFinalizationDuration;
5287         TOKENHOLDERS_QUORUM_FRAC = tokenholdersQuorumFrac;
5288         VOTING_MAJORITY_FRAC = votingMajorityFrac;
5289         INVESTMENT_AGREEMENT_TEMPLATE_URL = investmentAgreementTemplateUrl;
5290     }
5291 
5292     //
5293     // Implements IContractId
5294     //
5295 
5296     function contractId() public pure returns (bytes32 id, uint256 version) {
5297         return (0x7f46caed28b4e7a90dc4db9bba18d1565e6c4824f0dc1b96b3b88d730da56e57, 0);
5298     }
5299 }
5300 
5301 /// @title set terms of Platform (investor's network) of the ETO
5302 contract PlatformTerms is Math, IContractId {
5303 
5304     ////////////////////////
5305     // Constants
5306     ////////////////////////
5307 
5308     // fraction of fee deduced on successful ETO (see Math.sol for fraction definition)
5309     uint256 public constant PLATFORM_FEE_FRACTION = 3 * 10**16;
5310     // fraction of tokens deduced on succesful ETO
5311     uint256 public constant TOKEN_PARTICIPATION_FEE_FRACTION = 2 * 10**16;
5312     // share of Neumark reward platform operator gets
5313     // actually this is a divisor that splits Neumark reward in two parts
5314     // the results of division belongs to platform operator, the remaining reward part belongs to investor
5315     uint256 public constant PLATFORM_NEUMARK_SHARE = 2; // 50:50 division
5316     // ICBM investors whitelisted by default
5317     bool public constant IS_ICBM_INVESTOR_WHITELISTED = true;
5318 
5319     // minimum ticket size Platform accepts in EUR ULPS
5320     uint256 public constant MIN_TICKET_EUR_ULPS = 100 * 10**18;
5321     // maximum ticket size Platform accepts in EUR ULPS
5322     // no max ticket in general prospectus regulation
5323     // uint256 public constant MAX_TICKET_EUR_ULPS = 10000000 * 10**18;
5324 
5325     // min duration from setting the date to ETO start
5326     uint256 public constant DATE_TO_WHITELIST_MIN_DURATION = 5 days;
5327     // token rate expires after
5328     uint256 public constant TOKEN_RATE_EXPIRES_AFTER = 4 hours;
5329 
5330     // duration constraints
5331     uint256 public constant MIN_WHITELIST_DURATION = 0 days;
5332     uint256 public constant MAX_WHITELIST_DURATION = 30 days;
5333     uint256 public constant MIN_PUBLIC_DURATION = 0 days;
5334     uint256 public constant MAX_PUBLIC_DURATION = 60 days;
5335 
5336     // minimum length of whole offer
5337     uint256 public constant MIN_OFFER_DURATION = 1 days;
5338     // quarter should be enough for everyone
5339     uint256 public constant MAX_OFFER_DURATION = 90 days;
5340 
5341     uint256 public constant MIN_SIGNING_DURATION = 14 days;
5342     uint256 public constant MAX_SIGNING_DURATION = 60 days;
5343 
5344     uint256 public constant MIN_CLAIM_DURATION = 7 days;
5345     uint256 public constant MAX_CLAIM_DURATION = 30 days;
5346 
5347     ////////////////////////
5348     // Public Function
5349     ////////////////////////
5350 
5351     // calculates investor's and platform operator's neumarks from total reward
5352     function calculateNeumarkDistribution(uint256 rewardNmk)
5353         public
5354         pure
5355         returns (uint256 platformNmk, uint256 investorNmk)
5356     {
5357         // round down - platform may get 1 wei less than investor
5358         platformNmk = rewardNmk / PLATFORM_NEUMARK_SHARE;
5359         // rewardNmk > platformNmk always
5360         return (platformNmk, rewardNmk - platformNmk);
5361     }
5362 
5363     function calculatePlatformTokenFee(uint256 tokenAmount)
5364         public
5365         pure
5366         returns (uint256)
5367     {
5368         // mind tokens having 0 precision
5369         return proportion(tokenAmount, TOKEN_PARTICIPATION_FEE_FRACTION, 10**18);
5370     }
5371 
5372     function calculatePlatformFee(uint256 amount)
5373         public
5374         pure
5375         returns (uint256)
5376     {
5377         return decimalFraction(amount, PLATFORM_FEE_FRACTION);
5378     }
5379 
5380     //
5381     // Implements IContractId
5382     //
5383 
5384     function contractId() public pure returns (bytes32 id, uint256 version) {
5385         return (0x95482babc4e32de6c4dc3910ee7ae62c8e427efde6bc4e9ce0d6d93e24c39323, 0);
5386     }
5387 }
5388 
5389 /// @title sets duration of states in ETO
5390 contract ETODurationTerms is IContractId {
5391 
5392     ////////////////////////
5393     // Immutable state
5394     ////////////////////////
5395 
5396     // duration of Whitelist state
5397     uint32 public WHITELIST_DURATION;
5398 
5399     // duration of Public state
5400     uint32 public PUBLIC_DURATION;
5401 
5402     // time for Nominee and Company to sign Investment Agreement offchain and present proof on-chain
5403     uint32 public SIGNING_DURATION;
5404 
5405     // time for Claim before fee payout from ETO to NEU holders
5406     uint32 public CLAIM_DURATION;
5407 
5408     ////////////////////////
5409     // Constructor
5410     ////////////////////////
5411 
5412     constructor(
5413         uint32 whitelistDuration,
5414         uint32 publicDuration,
5415         uint32 signingDuration,
5416         uint32 claimDuration
5417     )
5418         public
5419     {
5420         WHITELIST_DURATION = whitelistDuration;
5421         PUBLIC_DURATION = publicDuration;
5422         SIGNING_DURATION = signingDuration;
5423         CLAIM_DURATION = claimDuration;
5424     }
5425 
5426     //
5427     // Implements IContractId
5428     //
5429 
5430     function contractId() public pure returns (bytes32 id, uint256 version) {
5431         return (0x5fb50201b453799d95f8a80291b940f1c543537b95bff2e3c78c2e36070494c0, 0);
5432     }
5433 }
5434 
5435 /// @title sets terms for tokens in ETO
5436 contract ETOTokenTerms is IContractId {
5437 
5438     ////////////////////////
5439     // Immutable state
5440     ////////////////////////
5441 
5442     // minimum number of tokens being offered. will set min cap
5443     uint256 public MIN_NUMBER_OF_TOKENS;
5444     // maximum number of tokens being offered. will set max cap
5445     uint256 public MAX_NUMBER_OF_TOKENS;
5446     // base token price in EUR-T, without any discount scheme
5447     uint256 public TOKEN_PRICE_EUR_ULPS;
5448     // maximum number of tokens in whitelist phase
5449     uint256 public MAX_NUMBER_OF_TOKENS_IN_WHITELIST;
5450     // equity tokens per share
5451     uint256 public constant EQUITY_TOKENS_PER_SHARE = 10000;
5452     // equity tokens decimals (precision)
5453     uint8 public constant EQUITY_TOKENS_PRECISION = 0; // indivisible
5454 
5455 
5456     ////////////////////////
5457     // Constructor
5458     ////////////////////////
5459 
5460     constructor(
5461         uint256 minNumberOfTokens,
5462         uint256 maxNumberOfTokens,
5463         uint256 tokenPriceEurUlps,
5464         uint256 maxNumberOfTokensInWhitelist
5465     )
5466         public
5467     {
5468         require(maxNumberOfTokensInWhitelist <= maxNumberOfTokens);
5469         require(maxNumberOfTokens >= minNumberOfTokens);
5470         // min cap must be > single share
5471         require(minNumberOfTokens >= EQUITY_TOKENS_PER_SHARE, "NF_ETO_TERMS_ONE_SHARE");
5472 
5473         MIN_NUMBER_OF_TOKENS = minNumberOfTokens;
5474         MAX_NUMBER_OF_TOKENS = maxNumberOfTokens;
5475         TOKEN_PRICE_EUR_ULPS = tokenPriceEurUlps;
5476         MAX_NUMBER_OF_TOKENS_IN_WHITELIST = maxNumberOfTokensInWhitelist;
5477     }
5478 
5479     //
5480     // Implements IContractId
5481     //
5482 
5483     function contractId() public pure returns (bytes32 id, uint256 version) {
5484         return (0x591e791aab2b14c80194b729a2abcba3e8cce1918be4061be170e7223357ae5c, 0);
5485     }
5486 }
5487 
5488 /// @title base terms of Equity Token Offering
5489 /// encapsulates pricing, discounts and whitelisting mechanism
5490 /// @dev to be split is mixins
5491 contract ETOTerms is
5492     IdentityRecord,
5493     Math,
5494     IContractId
5495 {
5496 
5497     ////////////////////////
5498     // Types
5499     ////////////////////////
5500 
5501     // @notice whitelist entry with a discount
5502     struct WhitelistTicket {
5503         // this also overrides maximum ticket
5504         uint128 discountAmountEurUlps;
5505         // a percentage of full price to be paid (1 - discount)
5506         uint128 fullTokenPriceFrac;
5507     }
5508 
5509     ////////////////////////
5510     // Constants state
5511     ////////////////////////
5512 
5513     bytes32 private constant EMPTY_STRING_HASH = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
5514     uint256 public constant MIN_QUALIFIED_INVESTOR_TICKET_EUR_ULPS = 100000 * 10**18;
5515 
5516     ////////////////////////
5517     // Immutable state
5518     ////////////////////////
5519 
5520     // reference to duration terms
5521     ETODurationTerms public DURATION_TERMS;
5522     // reference to token terms
5523     ETOTokenTerms public TOKEN_TERMS;
5524     // total number of shares in the company (incl. Authorized Shares) at moment of sale
5525     uint256 public EXISTING_COMPANY_SHARES;
5526     // sets nominal value of a share
5527     uint256 public SHARE_NOMINAL_VALUE_EUR_ULPS;
5528     // maximum discount on token price that may be given to investor (as decimal fraction)
5529     // uint256 public MAXIMUM_TOKEN_PRICE_DISCOUNT_FRAC;
5530     // minimum ticket
5531     uint256 public MIN_TICKET_EUR_ULPS;
5532     // maximum ticket for sophisiticated investors
5533     uint256 public MAX_TICKET_EUR_ULPS;
5534     // maximum ticket for simple investors
5535     uint256 public MAX_TICKET_SIMPLE_EUR_ULPS;
5536     // should enable transfers on ETO success
5537     // transfers are always disabled during token offering
5538     // if set to False transfers on Equity Token will remain disabled after offering
5539     // once those terms are on-chain this flags fully controls token transferability
5540     bool public ENABLE_TRANSFERS_ON_SUCCESS;
5541     // tells if offering accepts retail investors. if so, registered prospectus is required
5542     // and ENABLE_TRANSFERS_ON_SUCCESS is forced to be false as per current platform policy
5543     bool public ALLOW_RETAIL_INVESTORS;
5544     // represents the discount % for whitelist participants
5545     uint256 public WHITELIST_DISCOUNT_FRAC;
5546     // represents the discount % for public participants, using values > 0 will result
5547     // in automatic downround shareholder resolution
5548     uint256 public PUBLIC_DISCOUNT_FRAC;
5549 
5550     // paperwork
5551     // prospectus / investment memorandum / crowdfunding pamphlet etc.
5552     string public INVESTOR_OFFERING_DOCUMENT_URL;
5553     // settings for shareholder rights
5554     ShareholderRights public SHAREHOLDER_RIGHTS;
5555 
5556     // equity token setup
5557     string public EQUITY_TOKEN_NAME;
5558     string public EQUITY_TOKEN_SYMBOL;
5559 
5560     // manages whitelist
5561     address public WHITELIST_MANAGER;
5562     // wallet registry of KYC procedure
5563     IIdentityRegistry public IDENTITY_REGISTRY;
5564     Universe public UNIVERSE;
5565 
5566     // variables from token terms for local use
5567     // minimum number of tokens being offered. will set min cap
5568     uint256 private MIN_NUMBER_OF_TOKENS;
5569     // maximum number of tokens being offered. will set max cap
5570     uint256 private MAX_NUMBER_OF_TOKENS;
5571     // base token price in EUR-T, without any discount scheme
5572     uint256 private TOKEN_PRICE_EUR_ULPS;
5573 
5574 
5575     ////////////////////////
5576     // Mutable state
5577     ////////////////////////
5578 
5579     // mapping of investors allowed in whitelist
5580     mapping (address => WhitelistTicket) private _whitelist;
5581 
5582     ////////////////////////
5583     // Modifiers
5584     ////////////////////////
5585 
5586     modifier onlyWhitelistManager() {
5587         require(msg.sender == WHITELIST_MANAGER);
5588         _;
5589     }
5590 
5591     ////////////////////////
5592     // Events
5593     ////////////////////////
5594 
5595     // raised on invesor added to whitelist
5596     event LogInvestorWhitelisted(
5597         address indexed investor,
5598         uint256 discountAmountEurUlps,
5599         uint256 fullTokenPriceFrac
5600     );
5601 
5602     ////////////////////////
5603     // Constructor
5604     ////////////////////////
5605 
5606     constructor(
5607         Universe universe,
5608         ETODurationTerms durationTerms,
5609         ETOTokenTerms tokenTerms,
5610         uint256 existingCompanyShares,
5611         uint256 minTicketEurUlps,
5612         uint256 maxTicketEurUlps,
5613         bool allowRetailInvestors,
5614         bool enableTransfersOnSuccess,
5615         string investorOfferingDocumentUrl,
5616         ShareholderRights shareholderRights,
5617         string equityTokenName,
5618         string equityTokenSymbol,
5619         uint256 shareNominalValueEurUlps,
5620         uint256 whitelistDiscountFrac,
5621         uint256 publicDiscountFrac
5622     )
5623         public
5624     {
5625         require(durationTerms != address(0));
5626         require(tokenTerms != address(0));
5627         require(existingCompanyShares > 0);
5628         require(keccak256(abi.encodePacked(investorOfferingDocumentUrl)) != EMPTY_STRING_HASH);
5629         require(keccak256(abi.encodePacked(equityTokenName)) != EMPTY_STRING_HASH);
5630         require(keccak256(abi.encodePacked(equityTokenSymbol)) != EMPTY_STRING_HASH);
5631         require(shareholderRights != address(0));
5632         // test interface
5633         // require(shareholderRights.HAS_GENERAL_INFORMATION_RIGHTS());
5634         require(shareNominalValueEurUlps > 0);
5635         require(whitelistDiscountFrac >= 0 && whitelistDiscountFrac <= 99*10**16);
5636         require(publicDiscountFrac >= 0 && publicDiscountFrac <= 99*10**16);
5637         require(minTicketEurUlps<=maxTicketEurUlps);
5638 
5639         // copy token terms variables
5640         MIN_NUMBER_OF_TOKENS = tokenTerms.MIN_NUMBER_OF_TOKENS();
5641         MAX_NUMBER_OF_TOKENS = tokenTerms.MAX_NUMBER_OF_TOKENS();
5642         TOKEN_PRICE_EUR_ULPS = tokenTerms.TOKEN_PRICE_EUR_ULPS();
5643 
5644         DURATION_TERMS = durationTerms;
5645         TOKEN_TERMS = tokenTerms;
5646         EXISTING_COMPANY_SHARES = existingCompanyShares;
5647         MIN_TICKET_EUR_ULPS = minTicketEurUlps;
5648         MAX_TICKET_EUR_ULPS = maxTicketEurUlps;
5649         ALLOW_RETAIL_INVESTORS = allowRetailInvestors;
5650         ENABLE_TRANSFERS_ON_SUCCESS = enableTransfersOnSuccess;
5651         INVESTOR_OFFERING_DOCUMENT_URL = investorOfferingDocumentUrl;
5652         SHAREHOLDER_RIGHTS = shareholderRights;
5653         EQUITY_TOKEN_NAME = equityTokenName;
5654         EQUITY_TOKEN_SYMBOL = equityTokenSymbol;
5655         SHARE_NOMINAL_VALUE_EUR_ULPS = shareNominalValueEurUlps;
5656         WHITELIST_DISCOUNT_FRAC = whitelistDiscountFrac;
5657         PUBLIC_DISCOUNT_FRAC = publicDiscountFrac;
5658         WHITELIST_MANAGER = msg.sender;
5659         IDENTITY_REGISTRY = IIdentityRegistry(universe.identityRegistry());
5660         UNIVERSE = universe;
5661     }
5662 
5663     ////////////////////////
5664     // Public methods
5665     ////////////////////////
5666 
5667     // calculates token amount for a given commitment at a position of the curve
5668     // we require that equity token precision is 0
5669     function calculateTokenAmount(uint256 /*totalEurUlps*/, uint256 committedEurUlps)
5670         public
5671         constant
5672         returns (uint256 tokenAmountInt)
5673     {
5674         // we may disregard totalEurUlps as curve is flat, round down when calculating tokens
5675         return committedEurUlps / calculatePriceFraction(10**18 - PUBLIC_DISCOUNT_FRAC);
5676     }
5677 
5678     // calculates amount of euro required to acquire amount of tokens at a position of the (inverse) curve
5679     // we require that equity token precision is 0
5680     function calculateEurUlpsAmount(uint256 /*totalTokensInt*/, uint256 tokenAmountInt)
5681         public
5682         constant
5683         returns (uint256 committedEurUlps)
5684     {
5685         // we may disregard totalTokensInt as curve is flat
5686         return mul(tokenAmountInt, calculatePriceFraction(10**18 - PUBLIC_DISCOUNT_FRAC));
5687     }
5688 
5689     // get mincap in EUR
5690     function ESTIMATED_MIN_CAP_EUR_ULPS() public constant returns(uint256) {
5691         return calculateEurUlpsAmount(0, MIN_NUMBER_OF_TOKENS);
5692     }
5693 
5694     // get max cap in EUR
5695     function ESTIMATED_MAX_CAP_EUR_ULPS() public constant returns(uint256) {
5696         return calculateEurUlpsAmount(0, MAX_NUMBER_OF_TOKENS);
5697     }
5698 
5699     function calculatePriceFraction(uint256 priceFrac) public constant returns(uint256) {
5700         if (priceFrac == 1) {
5701             return TOKEN_PRICE_EUR_ULPS;
5702         } else {
5703             return decimalFraction(priceFrac, TOKEN_PRICE_EUR_ULPS);
5704         }
5705     }
5706 
5707     function addWhitelisted(
5708         address[] investors,
5709         uint256[] discountAmountsEurUlps,
5710         uint256[] discountsFrac
5711     )
5712         external
5713         onlyWhitelistManager
5714     {
5715         require(investors.length == discountAmountsEurUlps.length);
5716         require(investors.length == discountsFrac.length);
5717 
5718         for (uint256 i = 0; i < investors.length; i += 1) {
5719             addWhitelistInvestorPrivate(investors[i], discountAmountsEurUlps[i], discountsFrac[i]);
5720         }
5721     }
5722 
5723     function whitelistTicket(address investor)
5724         public
5725         constant
5726         returns (bool isWhitelisted, uint256 discountAmountEurUlps, uint256 fullTokenPriceFrac)
5727     {
5728         WhitelistTicket storage wlTicket = _whitelist[investor];
5729         isWhitelisted = wlTicket.fullTokenPriceFrac > 0;
5730         discountAmountEurUlps = wlTicket.discountAmountEurUlps;
5731         fullTokenPriceFrac = wlTicket.fullTokenPriceFrac;
5732     }
5733 
5734     // calculate contribution of investor
5735     function calculateContribution(
5736         address investor,
5737         uint256 totalContributedEurUlps,
5738         uint256 existingInvestorContributionEurUlps,
5739         uint256 newInvestorContributionEurUlps,
5740         bool applyWhitelistDiscounts
5741     )
5742         public
5743         constant
5744         returns (
5745             bool isWhitelisted,
5746             bool isEligible,
5747             uint256 minTicketEurUlps,
5748             uint256 maxTicketEurUlps,
5749             uint256 equityTokenInt,
5750             uint256 fixedSlotEquityTokenInt
5751             )
5752     {
5753         (
5754             isWhitelisted,
5755             minTicketEurUlps,
5756             maxTicketEurUlps,
5757             equityTokenInt,
5758             fixedSlotEquityTokenInt
5759         ) = calculateContributionPrivate(
5760             investor,
5761             totalContributedEurUlps,
5762             existingInvestorContributionEurUlps,
5763             newInvestorContributionEurUlps,
5764             applyWhitelistDiscounts);
5765         // check if is eligible for investment
5766         IdentityClaims memory claims = deserializeClaims(IDENTITY_REGISTRY.getClaims(investor));
5767         isEligible = claims.isVerified && !claims.accountFrozen;
5768     }
5769 
5770     function equityTokensToShares(uint256 amount)
5771         public
5772         constant
5773         returns (uint256)
5774     {
5775         return divRound(amount, TOKEN_TERMS.EQUITY_TOKENS_PER_SHARE());
5776     }
5777 
5778     /// @notice checks terms against platform terms, reverts on invalid
5779     function requireValidTerms(PlatformTerms platformTerms)
5780         public
5781         constant
5782         returns (bool)
5783     {
5784         // apply constraints on retail fundraising
5785         if (ALLOW_RETAIL_INVESTORS) {
5786             // make sure transfers are disabled after offering for retail investors
5787             require(!ENABLE_TRANSFERS_ON_SUCCESS, "NF_MUST_DISABLE_TRANSFERS");
5788         } else {
5789             // only qualified investors allowed defined as tickets > 100000 EUR
5790             require(MIN_TICKET_EUR_ULPS >= MIN_QUALIFIED_INVESTOR_TICKET_EUR_ULPS, "NF_MIN_QUALIFIED_INVESTOR_TICKET");
5791         }
5792         // min ticket must be > token price
5793         require(MIN_TICKET_EUR_ULPS >= TOKEN_TERMS.TOKEN_PRICE_EUR_ULPS(), "NF_MIN_TICKET_LT_TOKEN_PRICE");
5794         // it must be possible to collect more funds than max number of tokens
5795         require(ESTIMATED_MAX_CAP_EUR_ULPS() >= MIN_TICKET_EUR_ULPS, "NF_MAX_FUNDS_LT_MIN_TICKET");
5796 
5797         require(MIN_TICKET_EUR_ULPS >= platformTerms.MIN_TICKET_EUR_ULPS(), "NF_ETO_TERMS_MIN_TICKET_EUR_ULPS");
5798         // duration checks
5799         require(DURATION_TERMS.WHITELIST_DURATION() >= platformTerms.MIN_WHITELIST_DURATION(), "NF_ETO_TERMS_WL_D_MIN");
5800         require(DURATION_TERMS.WHITELIST_DURATION() <= platformTerms.MAX_WHITELIST_DURATION(), "NF_ETO_TERMS_WL_D_MAX");
5801 
5802         require(DURATION_TERMS.PUBLIC_DURATION() >= platformTerms.MIN_PUBLIC_DURATION(), "NF_ETO_TERMS_PUB_D_MIN");
5803         require(DURATION_TERMS.PUBLIC_DURATION() <= platformTerms.MAX_PUBLIC_DURATION(), "NF_ETO_TERMS_PUB_D_MAX");
5804 
5805         uint256 totalDuration = DURATION_TERMS.WHITELIST_DURATION() + DURATION_TERMS.PUBLIC_DURATION();
5806         require(totalDuration >= platformTerms.MIN_OFFER_DURATION(), "NF_ETO_TERMS_TOT_O_MIN");
5807         require(totalDuration <= platformTerms.MAX_OFFER_DURATION(), "NF_ETO_TERMS_TOT_O_MAX");
5808 
5809         require(DURATION_TERMS.SIGNING_DURATION() >= platformTerms.MIN_SIGNING_DURATION(), "NF_ETO_TERMS_SIG_MIN");
5810         require(DURATION_TERMS.SIGNING_DURATION() <= platformTerms.MAX_SIGNING_DURATION(), "NF_ETO_TERMS_SIG_MAX");
5811 
5812         require(DURATION_TERMS.CLAIM_DURATION() >= platformTerms.MIN_CLAIM_DURATION(), "NF_ETO_TERMS_CLAIM_MIN");
5813         require(DURATION_TERMS.CLAIM_DURATION() <= platformTerms.MAX_CLAIM_DURATION(), "NF_ETO_TERMS_CLAIM_MAX");
5814 
5815         return true;
5816     }
5817 
5818     //
5819     // Implements IContractId
5820     //
5821 
5822     function contractId() public pure returns (bytes32 id, uint256 version) {
5823         return (0x3468b14073c33fa00ee7f8a289b14f4a10c78ab72726033b27003c31c47b3f6a, 0);
5824     }
5825 
5826     ////////////////////////
5827     // Private methods
5828     ////////////////////////
5829 
5830     function calculateContributionPrivate(
5831         address investor,
5832         uint256 totalContributedEurUlps,
5833         uint256 existingInvestorContributionEurUlps,
5834         uint256 newInvestorContributionEurUlps,
5835         bool applyWhitelistDiscounts
5836     )
5837         private
5838         constant
5839         returns (
5840             bool isWhitelisted,
5841             uint256 minTicketEurUlps,
5842             uint256 maxTicketEurUlps,
5843             uint256 equityTokenInt,
5844             uint256 fixedSlotEquityTokenInt
5845         )
5846     {
5847         uint256 discountedAmount;
5848         minTicketEurUlps = MIN_TICKET_EUR_ULPS;
5849         maxTicketEurUlps = MAX_TICKET_EUR_ULPS;
5850         WhitelistTicket storage wlTicket = _whitelist[investor];
5851         // check if has access to discount
5852         isWhitelisted = wlTicket.fullTokenPriceFrac > 0;
5853         // whitelist use discount is possible
5854         if (applyWhitelistDiscounts) {
5855             // can invest more than general max ticket
5856             maxTicketEurUlps = max(wlTicket.discountAmountEurUlps, maxTicketEurUlps);
5857             // can invest less than general min ticket
5858             if (wlTicket.discountAmountEurUlps > 0) {
5859                 minTicketEurUlps = min(wlTicket.discountAmountEurUlps, minTicketEurUlps);
5860             }
5861             if (existingInvestorContributionEurUlps < wlTicket.discountAmountEurUlps) {
5862                 discountedAmount = min(newInvestorContributionEurUlps, wlTicket.discountAmountEurUlps - existingInvestorContributionEurUlps);
5863                 // discount is fixed so use base token price
5864                 if (discountedAmount > 0) {
5865                     // always round down when calculating tokens
5866                     fixedSlotEquityTokenInt = discountedAmount / calculatePriceFraction(wlTicket.fullTokenPriceFrac);
5867                 }
5868             }
5869         }
5870         // if any amount above discount
5871         uint256 remainingAmount = newInvestorContributionEurUlps - discountedAmount;
5872         if (remainingAmount > 0) {
5873             if (applyWhitelistDiscounts && WHITELIST_DISCOUNT_FRAC > 0) {
5874                 // will not overflow, WHITELIST_DISCOUNT_FRAC < Q18 from constructor, also round down
5875                 equityTokenInt = remainingAmount / calculatePriceFraction(10**18 - WHITELIST_DISCOUNT_FRAC);
5876             } else {
5877                 // use pricing along the curve
5878                 equityTokenInt = calculateTokenAmount(totalContributedEurUlps + discountedAmount, remainingAmount);
5879             }
5880         }
5881         // should have all issued tokens
5882         equityTokenInt += fixedSlotEquityTokenInt;
5883 
5884     }
5885 
5886     function addWhitelistInvestorPrivate(
5887         address investor,
5888         uint256 discountAmountEurUlps,
5889         uint256 fullTokenPriceFrac
5890     )
5891         private
5892     {
5893         // Validate
5894         require(investor != address(0));
5895         require(fullTokenPriceFrac > 0 && fullTokenPriceFrac <= 10**18, "NF_DISCOUNT_RANGE");
5896         require(discountAmountEurUlps < 2**128);
5897 
5898 
5899         _whitelist[investor] = WhitelistTicket({
5900             discountAmountEurUlps: uint128(discountAmountEurUlps),
5901             fullTokenPriceFrac: uint128(fullTokenPriceFrac)
5902         });
5903 
5904         emit LogInvestorWhitelisted(investor, discountAmountEurUlps, fullTokenPriceFrac);
5905     }
5906 
5907 }
5908 
5909 /// @title default interface of commitment process
5910 ///  investment always happens via payment token ERC223 callback
5911 ///  methods for checking finality and success/fail of the process are vailable
5912 ///  commitment event is standardized for tracking
5913 contract ICommitment is
5914     IAgreement,
5915     IERC223Callback
5916 {
5917 
5918     ////////////////////////
5919     // Events
5920     ////////////////////////
5921 
5922     /// on every commitment transaction
5923     /// `investor` committed `amount` in `paymentToken` currency which was
5924     /// converted to `baseCurrencyEquivalent` that generates `grantedAmount` of
5925     /// `assetToken` and `neuReward` NEU
5926     /// for investment funds could be provided from `wallet` (like icbm wallet) controlled by investor
5927     event LogFundsCommitted(
5928         address indexed investor,
5929         address wallet,
5930         address paymentToken,
5931         uint256 amount,
5932         uint256 baseCurrencyEquivalent,
5933         uint256 grantedAmount,
5934         address assetToken,
5935         uint256 neuReward
5936     );
5937 
5938     ////////////////////////
5939     // Public functions
5940     ////////////////////////
5941 
5942     // says if state is final
5943     function finalized() public constant returns (bool);
5944 
5945     // says if state is success
5946     function success() public constant returns (bool);
5947 
5948     // says if state is failure
5949     function failed() public constant returns (bool);
5950 
5951     // currently committed funds
5952     function totalInvestment()
5953         public
5954         constant
5955         returns (
5956             uint256 totalEquivEurUlps,
5957             uint256 totalTokensInt,
5958             uint256 totalInvestors
5959         );
5960 
5961     /// commit function happens via ERC223 callback that must happen from trusted payment token
5962     /// @param investor address of the investor
5963     /// @param amount amount commited
5964     /// @param data may have meaning in particular ETO implementation
5965     function tokenFallback(address investor, uint256 amount, bytes data)
5966         public;
5967 
5968 }
5969 
5970 /// @title default interface of commitment process
5971 contract IETOCommitment is
5972     ICommitment,
5973     IETOCommitmentStates
5974 {
5975 
5976     ////////////////////////
5977     // Events
5978     ////////////////////////
5979 
5980     // on every state transition
5981     event LogStateTransition(
5982         uint32 oldState,
5983         uint32 newState,
5984         uint32 timestamp
5985     );
5986 
5987     /// on a claim by invester
5988     ///   `investor` claimed `amount` of `assetToken` and claimed `nmkReward` amount of NEU
5989     event LogTokensClaimed(
5990         address indexed investor,
5991         address indexed assetToken,
5992         uint256 amount,
5993         uint256 nmkReward
5994     );
5995 
5996     /// on a refund to investor
5997     ///   `investor` was refunded `amount` of `paymentToken`
5998     /// @dev may be raised multiple times per refund operation
5999     event LogFundsRefunded(
6000         address indexed investor,
6001         address indexed paymentToken,
6002         uint256 amount
6003     );
6004 
6005     // logged at the moment of Company setting terms
6006     event LogTermsSet(
6007         address companyLegalRep,
6008         address etoTerms,
6009         address equityToken
6010     );
6011 
6012     // logged at the moment Company sets/resets Whitelisting start date
6013     event LogETOStartDateSet(
6014         address companyLegalRep,
6015         uint256 previousTimestamp,
6016         uint256 newTimestamp
6017     );
6018 
6019     // logged at the moment Signing procedure starts
6020     event LogSigningStarted(
6021         address nominee,
6022         address companyLegalRep,
6023         uint256 newShares,
6024         uint256 capitalIncreaseEurUlps
6025     );
6026 
6027     // logged when company presents signed investment agreement
6028     event LogCompanySignedAgreement(
6029         address companyLegalRep,
6030         address nominee,
6031         string signedInvestmentAgreementUrl
6032     );
6033 
6034     // logged when nominee presents and verifies its copy of investment agreement
6035     event LogNomineeConfirmedAgreement(
6036         address nominee,
6037         address companyLegalRep,
6038         string signedInvestmentAgreementUrl
6039     );
6040 
6041     // logged on refund transition to mark destroyed tokens
6042     event LogRefundStarted(
6043         address assetToken,
6044         uint256 totalTokenAmountInt,
6045         uint256 totalRewardNmkUlps
6046     );
6047 
6048     ////////////////////////
6049     // Public functions
6050     ////////////////////////
6051 
6052     //
6053     // ETOState control
6054     //
6055 
6056     // returns current ETO state
6057     function state() public constant returns (ETOState);
6058 
6059     // returns start of given state
6060     function startOf(ETOState s) public constant returns (uint256);
6061 
6062     // returns commitment observer (typically equity token controller)
6063     function commitmentObserver() public constant returns (IETOCommitmentObserver);
6064 
6065     //
6066     // Commitment process
6067     //
6068 
6069     /// refunds investor if ETO failed
6070     function refund() external;
6071 
6072     function refundMany(address[] investors) external;
6073 
6074     /// claims tokens if ETO is a success
6075     function claim() external;
6076 
6077     function claimMany(address[] investors) external;
6078 
6079     // initiate fees payout
6080     function payout() external;
6081 
6082 
6083     //
6084     // Offering terms
6085     //
6086 
6087     function etoTerms() public constant returns (ETOTerms);
6088 
6089     // equity token
6090     function equityToken() public constant returns (IEquityToken);
6091 
6092     // nominee
6093     function nominee() public constant returns (address);
6094 
6095     function companyLegalRep() public constant returns (address);
6096 
6097     /// signed agreement as provided by company and nominee
6098     /// @dev available on Claim state transition
6099     function signedInvestmentAgreementUrl() public constant returns (string);
6100 
6101     /// financial outcome of token offering set on Signing state transition
6102     /// @dev in preceding states 0 is returned
6103     function contributionSummary()
6104         public
6105         constant
6106         returns (
6107             uint256 newShares, uint256 capitalIncreaseEurUlps,
6108             uint256 additionalContributionEth, uint256 additionalContributionEurUlps,
6109             uint256 tokenParticipationFeeInt, uint256 platformFeeEth, uint256 platformFeeEurUlps,
6110             uint256 sharePriceEurUlps
6111         );
6112 
6113     /// method to obtain current investors ticket
6114     function investorTicket(address investor)
6115         public
6116         constant
6117         returns (
6118             uint256 equivEurUlps,
6119             uint256 rewardNmkUlps,
6120             uint256 equityTokenInt,
6121             uint256 sharesInt,
6122             uint256 tokenPrice,
6123             uint256 neuRate,
6124             uint256 amountEth,
6125             uint256 amountEurUlps,
6126             bool claimOrRefundSettled,
6127             bool usedLockedAccount
6128         );
6129 }
6130 
6131 contract METOStateMachineObserver is IETOCommitmentStates {
6132     /// @notice called before state transitions, allows override transition due to additional business logic
6133     /// @dev advance due to time implemented in advanceTimedState, here implement other conditions like
6134     ///     max cap reached -> we go to signing
6135     function mBeforeStateTransition(ETOState oldState, ETOState newState)
6136         internal
6137         constant
6138         returns (ETOState newStateOverride);
6139 
6140     /// @notice gets called after every state transition.
6141     function mAfterTransition(ETOState oldState, ETOState newState)
6142         internal;
6143 
6144     /// @notice gets called after business logic, may induce state transition
6145     function mAdavanceLogicState(ETOState oldState)
6146         internal
6147         constant
6148         returns (ETOState);
6149 }
6150 
6151 /// @title time induced state machine for Equity Token Offering
6152 /// @notice implements ETO state machine with setup, whitelist, public, signing, claim, refund and payout phases
6153 /// @dev inherited contract must implement internal interface, see comments
6154 ///  intended usage via 'withStateTransition' modifier which makes sure that state machine transitions into
6155 ///  correct state before executing function body. note that this is contract state changing modifier so use with care
6156 /// @dev timed state change request is publicly accessible via 'handleTimedTransitions'
6157 /// @dev time is based on block.timestamp
6158 contract ETOTimedStateMachine is
6159     IETOCommitment,
6160     METOStateMachineObserver
6161 {
6162 
6163     ////////////////////////
6164     // CONSTANTS
6165     ////////////////////////
6166 
6167     // uint32 private constant TS_STATE_NOT_SET = 1;
6168 
6169     ////////////////////////
6170     // Immutable state
6171     ////////////////////////
6172 
6173     // maps states to durations (index is ETOState)
6174     uint32[] private ETO_STATE_DURATIONS;
6175 
6176     // observer receives notifications on all state changes
6177     IETOCommitmentObserver private COMMITMENT_OBSERVER;
6178 
6179     ////////////////////////
6180     // Mutable state
6181     ////////////////////////
6182 
6183     // current state
6184     ETOState private _state = ETOState.Setup;
6185 
6186     // historical times of state transition (index is ETOState)
6187     // internal access used to allow mocking time
6188     uint32[7] internal _pastStateTransitionTimes;
6189 
6190     ////////////////////////
6191     // Modifiers
6192     ////////////////////////
6193 
6194     // @dev This modifier needs to be applied to all external non-constant functions.
6195     //  this modifier goes _before_ other state modifiers like `onlyState`.
6196     //  after function body execution state may transition again in `advanceLogicState`
6197     modifier withStateTransition() {
6198         // switch state due to time
6199         advanceTimedState();
6200         // execute function body
6201         _;
6202         // switch state due to business logic
6203         advanceLogicState();
6204     }
6205 
6206     modifier onlyState(ETOState state) {
6207         require(_state == state);
6208         _;
6209     }
6210 
6211     modifier onlyStates(ETOState state0, ETOState state1) {
6212         require(_state == state0 || _state == state1);
6213         _;
6214     }
6215 
6216     /// @dev Multiple states can be handled by adding more modifiers.
6217     /* modifier notInState(ETOState state) {
6218         require(_state != state);
6219         _;
6220     }*/
6221 
6222     ////////////////////////
6223     // Public functions
6224     ////////////////////////
6225 
6226     // @notice This function is public so that it can be called independently.
6227     function handleStateTransitions()
6228         public
6229     {
6230         advanceTimedState();
6231     }
6232 
6233     //
6234     // Implements ICommitment
6235     //
6236 
6237     // says if state is final
6238     function finalized()
6239         public
6240         constant
6241         returns (bool)
6242     {
6243         return (_state == ETOState.Refund || _state == ETOState.Payout || _state == ETOState.Claim);
6244     }
6245 
6246     // says if state is success
6247     function success()
6248         public
6249         constant
6250         returns (bool)
6251     {
6252         return (_state == ETOState.Claim || _state == ETOState.Payout);
6253     }
6254 
6255     // says if state is filure
6256     function failed()
6257         public
6258         constant
6259         returns (bool)
6260     {
6261         return _state == ETOState.Refund;
6262     }
6263 
6264     //
6265     // Implement IETOCommitment
6266     //
6267 
6268     function state()
6269         public
6270         constant
6271         returns (ETOState)
6272     {
6273         return _state;
6274     }
6275 
6276     function startOf(ETOState s)
6277         public
6278         constant
6279         returns (uint256)
6280     {
6281         return startOfInternal(s);
6282     }
6283 
6284     // returns time induced state which differs from storage state if transition is overdue
6285     function timedState()
6286         external
6287         constant
6288         returns (ETOState)
6289     {
6290         // below we change state but function is constant. the intention is to force this function to be eth_called
6291         advanceTimedState();
6292         return _state;
6293     }
6294 
6295     function startOfStates()
6296         public
6297         constant
6298         returns (uint256[7] startOfs)
6299     {
6300         // 7 is number of states
6301         for(uint256 ii = 0;ii<ETO_STATES_COUNT;ii += 1) {
6302             startOfs[ii] = startOfInternal(ETOState(ii));
6303         }
6304     }
6305 
6306     function commitmentObserver() public constant returns (IETOCommitmentObserver) {
6307         return COMMITMENT_OBSERVER;
6308     }
6309 
6310     ////////////////////////
6311     // Internal functions
6312     ////////////////////////
6313 
6314     function setupStateMachine(ETODurationTerms durationTerms, IETOCommitmentObserver observer)
6315         internal
6316     {
6317         require(COMMITMENT_OBSERVER == address(0), "NF_STM_SET_ONCE");
6318         require(observer != address(0));
6319 
6320         COMMITMENT_OBSERVER = observer;
6321         ETO_STATE_DURATIONS = [
6322             0, durationTerms.WHITELIST_DURATION(), durationTerms.PUBLIC_DURATION(), durationTerms.SIGNING_DURATION(),
6323             durationTerms.CLAIM_DURATION(), 0, 0
6324             ];
6325     }
6326 
6327     function runStateMachine(uint32 startDate)
6328         internal
6329     {
6330         // this sets expiration of setup state
6331         _pastStateTransitionTimes[uint32(ETOState.Setup)] = startDate;
6332     }
6333 
6334     function startOfInternal(ETOState s)
6335         internal
6336         constant
6337         returns (uint256)
6338     {
6339         // initial state does not have start time
6340         if (s == ETOState.Setup) {
6341             return 0;
6342         }
6343 
6344         // if timed state machine was not run, the next state will never come
6345         // if (_pastStateTransitionTimes[uint32(ETOState.Setup)] == 0) {
6346         //    return 0xFFFFFFFF;
6347         // }
6348 
6349         // special case for Refund
6350         if (s == ETOState.Refund) {
6351             return _state == s ? _pastStateTransitionTimes[uint32(_state)] : 0;
6352         }
6353         // current and previous states: just take s - 1 which is the end of previous state
6354         if (uint32(s) - 1 <= uint32(_state)) {
6355             return _pastStateTransitionTimes[uint32(s) - 1];
6356         }
6357         // for future states
6358         uint256 currStateExpiration = _pastStateTransitionTimes[uint32(_state)];
6359         // this trick gets start of required state by adding all durations between current and required states
6360         // note that past and current state were handled above so required state is in the future
6361         // we also rely on terminal states having duration of 0
6362         for (uint256 stateIdx = uint32(_state) + 1; stateIdx < uint32(s); stateIdx++) {
6363             currStateExpiration += ETO_STATE_DURATIONS[stateIdx];
6364         }
6365         return currStateExpiration;
6366     }
6367 
6368     ////////////////////////
6369     // Private functions
6370     ////////////////////////
6371 
6372     // @notice time induced state transitions, called before logic
6373     // @dev don't use `else if` and keep sorted by time and call `state()`
6374     //     or else multiple transitions won't cascade properly.
6375     function advanceTimedState()
6376         private
6377     {
6378         // if timed state machine was not run, the next state will never come
6379         if (_pastStateTransitionTimes[uint32(ETOState.Setup)] == 0) {
6380             return;
6381         }
6382 
6383         uint256 t = block.timestamp;
6384         if (_state == ETOState.Setup && t >= startOfInternal(ETOState.Whitelist)) {
6385             transitionTo(ETOState.Whitelist);
6386         }
6387         if (_state == ETOState.Whitelist && t >= startOfInternal(ETOState.Public)) {
6388             transitionTo(ETOState.Public);
6389         }
6390         if (_state == ETOState.Public && t >= startOfInternal(ETOState.Signing)) {
6391             transitionTo(ETOState.Signing);
6392         }
6393         // signing to refund: first we check if it's claim time and if it we go
6394         // for refund. to go to claim agreement MUST be signed, no time transition
6395         if (_state == ETOState.Signing && t >= startOfInternal(ETOState.Claim)) {
6396             transitionTo(ETOState.Refund);
6397         }
6398         // claim to payout
6399         if (_state == ETOState.Claim && t >= startOfInternal(ETOState.Payout)) {
6400             transitionTo(ETOState.Payout);
6401         }
6402     }
6403 
6404     // @notice transitions due to business logic
6405     // @dev called after logic
6406     function advanceLogicState()
6407         private
6408     {
6409         ETOState newState = mAdavanceLogicState(_state);
6410         if (_state != newState) {
6411             transitionTo(newState);
6412             // if we had state transition, we may have another
6413             advanceLogicState();
6414         }
6415     }
6416 
6417     /// @notice executes transition state function
6418     function transitionTo(ETOState newState)
6419         private
6420     {
6421         ETOState oldState = _state;
6422         ETOState effectiveNewState = mBeforeStateTransition(oldState, newState);
6423         // require(validTransition(oldState, effectiveNewState));
6424 
6425         _state = effectiveNewState;
6426         // store deadline for previous state
6427         uint32 deadline = _pastStateTransitionTimes[uint256(oldState)];
6428         // if transition came before deadline, count time from timestamp, if after always count from deadline
6429         if (uint32(block.timestamp) < deadline) {
6430             deadline = uint32(block.timestamp);
6431         }
6432         // we have 60+ years for 2^32 overflow on epoch so disregard
6433         _pastStateTransitionTimes[uint256(oldState)] = deadline;
6434         // set deadline on next state
6435         _pastStateTransitionTimes[uint256(effectiveNewState)] = deadline + ETO_STATE_DURATIONS[uint256(effectiveNewState)];
6436         // should not change _state
6437         mAfterTransition(oldState, effectiveNewState);
6438         assert(_state == effectiveNewState);
6439         // should notify observer after internal state is settled
6440         COMMITMENT_OBSERVER.onStateTransition(oldState, effectiveNewState);
6441         emit LogStateTransition(uint32(oldState), uint32(effectiveNewState), deadline);
6442     }
6443 
6444     /*function validTransition(ETOState oldState, ETOState newState)
6445         private
6446         pure
6447         returns (bool valid)
6448     {
6449         // TODO: think about disabling it before production deployment
6450         // (oldState == ETOState.Setup && newState == ETOState.Public) ||
6451         // (oldState == ETOState.Setup && newState == ETOState.Refund) ||
6452         return
6453             (oldState == ETOState.Setup && newState == ETOState.Whitelist) ||
6454             (oldState == ETOState.Whitelist && newState == ETOState.Public) ||
6455             (oldState == ETOState.Whitelist && newState == ETOState.Signing) ||
6456             (oldState == ETOState.Public && newState == ETOState.Signing) ||
6457             (oldState == ETOState.Public && newState == ETOState.Refund) ||
6458             (oldState == ETOState.Signing && newState == ETOState.Refund) ||
6459             (oldState == ETOState.Signing && newState == ETOState.Claim) ||
6460             (oldState == ETOState.Claim && newState == ETOState.Payout);
6461     }*/
6462 }
6463 
6464 /// @title represents token offering organized by Company
6465 ///  token offering goes through states as defined in ETOTimedStateMachine
6466 ///  setup phase requires several parties to provide documents and information
6467 ///   (deployment (by anyone) -> eto terms (company) -> RAAA agreement (nominee) -> adding to universe (platform) + issue NEU -> start date (company))
6468 ///   price curves, whitelists, discounts and other offer terms are extracted to ETOTerms
6469 /// todo: review all divisions for rounding errors
6470 contract ETOCommitment is
6471     AccessControlled,
6472     Agreement,
6473     ETOTimedStateMachine,
6474     Math,
6475     Serialization,
6476     IContractId
6477 {
6478 
6479     ////////////////////////
6480     // Types
6481     ////////////////////////
6482 
6483     /// @notice state of individual investment
6484     /// @dev mind uint size: allows ticket to occupy two storage slots
6485     struct InvestmentTicket {
6486         // euro equivalent of both currencies.
6487         //  for ether equivalent is generated per ETH/EUR spot price provided by ITokenExchangeRateOracle
6488         uint96 equivEurUlps;
6489         // NEU reward issued
6490         uint96 rewardNmkUlps;
6491         // Equity Tokens issued, no precision
6492         uint96 equityTokenInt;
6493         // total Ether invested
6494         uint96 amountEth;
6495         // total Euro invested
6496         uint96 amountEurUlps;
6497         // claimed or refunded
6498         bool claimOrRefundSettled;
6499         // locked account was used
6500         bool usedLockedAccount;
6501         // uint30 reserved // still some bits free
6502     }
6503 
6504     ////////////////////////
6505     // Immutable state
6506     ////////////////////////
6507 
6508     // a root of trust contract
6509     Universe private UNIVERSE;
6510     // NEU tokens issued as reward for investment
6511     Neumark private NEUMARK;
6512     // ether token to store and transfer ether
6513     IERC223Token private ETHER_TOKEN;
6514     // euro token to store and transfer euro
6515     IERC223Token private EURO_TOKEN;
6516     // allowed icbm investor accounts
6517     LockedAccount private ETHER_LOCK;
6518     LockedAccount private EURO_LOCK;
6519     // equity token issued
6520     IEquityToken private EQUITY_TOKEN;
6521     // currency rate oracle
6522     ITokenExchangeRateOracle private CURRENCY_RATES;
6523 
6524     // max cap taken from ETOTerms for low gas costs
6525     uint256 private MIN_NUMBER_OF_TOKENS;
6526     // min cap taken from ETOTerms for low gas costs
6527     uint256 private MAX_NUMBER_OF_TOKENS;
6528     // max cap of tokens in whitelist (without fixed slots)
6529     uint256 private MAX_NUMBER_OF_TOKENS_IN_WHITELIST;
6530     // minimum ticket in tokens with base price
6531     uint256 private MIN_TICKET_TOKENS;
6532     // platform operator share for low gas costs
6533     uint128 private PLATFORM_NEUMARK_SHARE;
6534     // token rate expires after
6535     uint128 private TOKEN_RATE_EXPIRES_AFTER;
6536 
6537     // wallet that keeps Platform Operator share of neumarks
6538     //  and where token participation fee is temporarily stored
6539     address private PLATFORM_WALLET;
6540     // company representative address
6541     address private COMPANY_LEGAL_REPRESENTATIVE;
6542     // nominee address
6543     address private NOMINEE;
6544 
6545     // terms contracts
6546     ETOTerms private ETO_TERMS;
6547     // reference to platform terms
6548     PlatformTerms private PLATFORM_TERMS;
6549 
6550     ////////////////////////
6551     // Mutable state
6552     ////////////////////////
6553 
6554     // investment tickets
6555     mapping (address => InvestmentTicket) private _tickets;
6556 
6557     // data below start at 32 bytes boundary and pack into 32 bytes word
6558     // total investment in euro equivalent (ETH converted on spot prices)
6559     uint112 private _totalEquivEurUlps;
6560 
6561     // total equity tokens acquired
6562     uint56 private _totalTokensInt;
6563 
6564     // total equity tokens acquired in fixed slots
6565     uint56 private _totalFixedSlotsTokensInt;
6566 
6567     // total investors that participated
6568     uint32 private _totalInvestors;
6569 
6570     // nominee investment agreement url confirmation hash
6571     bytes32 private _nomineeSignedInvestmentAgreementUrlHash;
6572 
6573     // successful ETO bookeeping
6574     // amount of new shares generated
6575     uint96 private _newShares;
6576     // how many equity tokens goes to platform portfolio as a fee
6577     uint96 private _tokenParticipationFeeInt;
6578     // platform fee in eth
6579     uint96 private _platformFeeEth;
6580     // platform fee in eur
6581     uint96 private _platformFeeEurUlps;
6582     // additonal contribution (investment amount) eth
6583     uint96 private _additionalContributionEth;
6584     // additonal contribution (investment amount) eur
6585     uint96 private _additionalContributionEurUlps;
6586 
6587     // signed investment agreement url
6588     string private _signedInvestmentAgreementUrl;
6589 
6590     ////////////////////////
6591     // Modifiers
6592     ////////////////////////
6593 
6594     modifier onlyCompany() {
6595         require(msg.sender == COMPANY_LEGAL_REPRESENTATIVE);
6596         _;
6597     }
6598 
6599     modifier onlyNominee() {
6600         require(msg.sender == NOMINEE);
6601         _;
6602     }
6603 
6604     modifier onlyWithAgreement {
6605         require(amendmentsCount() > 0);
6606         _;
6607     }
6608 
6609     ////////////////////////
6610     // Events
6611     ////////////////////////
6612 
6613     // logged on claim state transition indicating that additional contribution was released to company
6614     event LogAdditionalContribution(
6615         address companyLegalRep,
6616         address paymentToken,
6617         uint256 amount
6618     );
6619 
6620     // logged on claim state transition indicating NEU reward available
6621     event LogPlatformNeuReward(
6622         address platformWallet,
6623         uint256 totalRewardNmkUlps,
6624         uint256 platformRewardNmkUlps
6625     );
6626 
6627     // logged on payout transition to mark cash payout to NEU holders
6628     event LogPlatformFeePayout(
6629         address paymentToken,
6630         address disbursalPool,
6631         uint256 amount
6632     );
6633 
6634     // logged on payout transition to mark equity token payout to portfolio smart contract
6635     event LogPlatformPortfolioPayout(
6636         address assetToken,
6637         address platformPortfolio,
6638         uint256 amount
6639     );
6640 
6641     ////////////////////////
6642     // Constructor
6643     ////////////////////////
6644 
6645     /// anyone may be a deployer, the platform acknowledges the contract by adding it to Universe Commitment collection
6646     constructor(
6647         Universe universe,
6648         address platformWallet,
6649         address nominee,
6650         address companyLegalRep,
6651         ETOTerms etoTerms,
6652         IEquityToken equityToken
6653     )
6654         Agreement(universe.accessPolicy(), universe.forkArbiter())
6655         ETOTimedStateMachine()
6656         public
6657     {
6658         UNIVERSE = universe;
6659         PLATFORM_TERMS = PlatformTerms(universe.platformTerms());
6660 
6661         require(equityToken.decimals() == etoTerms.TOKEN_TERMS().EQUITY_TOKENS_PRECISION());
6662         require(platformWallet != address(0) && nominee != address(0) && companyLegalRep != address(0));
6663         require(etoTerms.requireValidTerms(PLATFORM_TERMS));
6664 
6665         PLATFORM_WALLET = platformWallet;
6666         COMPANY_LEGAL_REPRESENTATIVE = companyLegalRep;
6667         NOMINEE = nominee;
6668         PLATFORM_NEUMARK_SHARE = uint128(PLATFORM_TERMS.PLATFORM_NEUMARK_SHARE());
6669         TOKEN_RATE_EXPIRES_AFTER = uint128(PLATFORM_TERMS.TOKEN_RATE_EXPIRES_AFTER());
6670 
6671         NEUMARK = universe.neumark();
6672         ETHER_TOKEN = universe.etherToken();
6673         EURO_TOKEN = universe.euroToken();
6674         ETHER_LOCK = LockedAccount(universe.etherLock());
6675         EURO_LOCK = LockedAccount(universe.euroLock());
6676         CURRENCY_RATES = ITokenExchangeRateOracle(universe.tokenExchangeRateOracle());
6677 
6678         ETO_TERMS = etoTerms;
6679         EQUITY_TOKEN = equityToken;
6680 
6681         MAX_NUMBER_OF_TOKENS = etoTerms.TOKEN_TERMS().MAX_NUMBER_OF_TOKENS();
6682         MAX_NUMBER_OF_TOKENS_IN_WHITELIST = etoTerms.TOKEN_TERMS().MAX_NUMBER_OF_TOKENS_IN_WHITELIST();
6683         MIN_NUMBER_OF_TOKENS = etoTerms.TOKEN_TERMS().MIN_NUMBER_OF_TOKENS();
6684         MIN_TICKET_TOKENS = etoTerms.calculateTokenAmount(0, etoTerms.MIN_TICKET_EUR_ULPS());
6685 
6686         setupStateMachine(
6687             ETO_TERMS.DURATION_TERMS(),
6688             IETOCommitmentObserver(EQUITY_TOKEN.tokenController())
6689         );
6690     }
6691 
6692     ////////////////////////
6693     // External functions
6694     ////////////////////////
6695 
6696     /// @dev sets timed state machine in motion
6697     function setStartDate(
6698         ETOTerms etoTerms,
6699         IEquityToken equityToken,
6700         uint256 startDate
6701     )
6702         external
6703         onlyCompany
6704         onlyWithAgreement
6705         withStateTransition()
6706         onlyState(ETOState.Setup)
6707     {
6708         require(etoTerms == ETO_TERMS);
6709         require(equityToken == EQUITY_TOKEN);
6710         assert(startDate < 0xFFFFFFFF);
6711         // must be more than NNN days (platform terms!)
6712         require(
6713             startDate > block.timestamp && startDate - block.timestamp > PLATFORM_TERMS.DATE_TO_WHITELIST_MIN_DURATION(),
6714             "NF_ETO_DATE_TOO_EARLY");
6715         // prevent re-setting start date if ETO starts too soon
6716         uint256 startAt = startOfInternal(ETOState.Whitelist);
6717         // block.timestamp must be less than startAt, otherwise timed state transition is done
6718         require(
6719             startAt == 0 || (startAt - block.timestamp > PLATFORM_TERMS.DATE_TO_WHITELIST_MIN_DURATION()),
6720             "NF_ETO_START_TOO_SOON");
6721         runStateMachine(uint32(startDate));
6722         // todo: lock ETO_TERMS whitelist to be more trustless
6723 
6724         emit LogTermsSet(msg.sender, address(etoTerms), address(equityToken));
6725         emit LogETOStartDateSet(msg.sender, startAt, startDate);
6726     }
6727 
6728     function companySignsInvestmentAgreement(string signedInvestmentAgreementUrl)
6729         public
6730         withStateTransition()
6731         onlyState(ETOState.Signing)
6732         onlyCompany
6733     {
6734         _signedInvestmentAgreementUrl = signedInvestmentAgreementUrl;
6735         emit LogCompanySignedAgreement(msg.sender, NOMINEE, signedInvestmentAgreementUrl);
6736     }
6737 
6738     function nomineeConfirmsInvestmentAgreement(string signedInvestmentAgreementUrl)
6739         public
6740         withStateTransition()
6741         onlyState(ETOState.Signing)
6742         onlyNominee
6743     {
6744         bytes32 nomineeHash = keccak256(abi.encodePacked(signedInvestmentAgreementUrl));
6745         require(keccak256(abi.encodePacked(_signedInvestmentAgreementUrl)) == nomineeHash, "NF_INV_HASH");
6746         // setting this variable will induce state transition to Claim via mAdavanceLogicState
6747         _nomineeSignedInvestmentAgreementUrlHash = nomineeHash;
6748         emit LogNomineeConfirmedAgreement(msg.sender, COMPANY_LEGAL_REPRESENTATIVE, signedInvestmentAgreementUrl);
6749     }
6750 
6751     //
6752     // Implements ICommitment
6753     //
6754 
6755     /// commit function happens via ERC223 callback that must happen from trusted payment token
6756     /// @dev data in case of LockedAccount contains investor address and investor is LockedAccount address
6757     function tokenFallback(address wallet, uint256 amount, bytes data)
6758         public
6759         withStateTransition()
6760         onlyStates(ETOState.Whitelist, ETOState.Public)
6761     {
6762         uint256 equivEurUlps = amount;
6763         bool isEuroInvestment = msg.sender == address(EURO_TOKEN);
6764         bool isEtherInvestment = msg.sender == address(ETHER_TOKEN);
6765         // we trust only tokens below
6766         require(isEtherInvestment || isEuroInvestment, "NF_ETO_UNK_TOKEN");
6767         // check if LockedAccount
6768         bool isLockedAccount = (wallet == address(ETHER_LOCK) || wallet == address(EURO_LOCK));
6769         address investor = wallet;
6770         if (isLockedAccount) {
6771             // data contains investor address
6772             investor = decodeAddress(data);
6773         }
6774         if (isEtherInvestment) {
6775             // compute EUR eurEquivalent via oracle if ether
6776             (uint256 rate, uint256 rateTimestamp) = CURRENCY_RATES.getExchangeRate(ETHER_TOKEN, EURO_TOKEN);
6777             // require if rate older than 4 hours
6778             require(block.timestamp - rateTimestamp < TOKEN_RATE_EXPIRES_AFTER, "NF_ETO_INVALID_ETH_RATE");
6779             equivEurUlps = decimalFraction(amount, rate);
6780         }
6781         // agreement accepted by act of reserving funds in this function
6782         acceptAgreementInternal(investor);
6783         // we modify state and emit events in function below
6784         processTicket(investor, wallet, amount, equivEurUlps, isEuroInvestment);
6785     }
6786 
6787     //
6788     // Implements IETOCommitment
6789     //
6790 
6791     function claim()
6792         external
6793         withStateTransition()
6794         onlyStates(ETOState.Claim, ETOState.Payout)
6795 
6796     {
6797         claimTokensPrivate(msg.sender);
6798     }
6799 
6800     function claimMany(address[] investors)
6801         external
6802         withStateTransition()
6803         onlyStates(ETOState.Claim, ETOState.Payout)
6804     {
6805         for(uint256 ii = 0; ii < investors.length; ii++) {
6806             claimTokensPrivate(investors[ii]);
6807         }
6808     }
6809 
6810     function refund()
6811         external
6812         withStateTransition()
6813         onlyState(ETOState.Refund)
6814 
6815     {
6816         refundTokensPrivate(msg.sender);
6817     }
6818 
6819     function refundMany(address[] investors)
6820         external
6821         withStateTransition()
6822         onlyState(ETOState.Refund)
6823     {
6824         for(uint256 ii = 0; ii < investors.length; ii++) {
6825             refundTokensPrivate(investors[ii]);
6826         }
6827     }
6828 
6829     function payout()
6830         external
6831         withStateTransition()
6832         onlyState(ETOState.Payout)
6833     {
6834         // does nothing - all hapens in state transition
6835     }
6836 
6837     //
6838     // Getters
6839     //
6840 
6841     //
6842     // IETOCommitment getters
6843     //
6844 
6845     function signedInvestmentAgreementUrl()
6846         public
6847         constant
6848         returns (string)
6849     {
6850         return _signedInvestmentAgreementUrl;
6851     }
6852 
6853     function contributionSummary()
6854         public
6855         constant
6856         returns (
6857             uint256 newShares, uint256 capitalIncreaseEurUlps,
6858             uint256 additionalContributionEth, uint256 additionalContributionEurUlps,
6859             uint256 tokenParticipationFeeInt, uint256 platformFeeEth, uint256 platformFeeEurUlps,
6860             uint256 sharePriceEurUlps
6861         )
6862     {
6863         return (
6864             _newShares, _newShares * EQUITY_TOKEN.shareNominalValueEurUlps(),
6865             _additionalContributionEth, _additionalContributionEurUlps,
6866             _tokenParticipationFeeInt, _platformFeeEth, _platformFeeEurUlps,
6867             _newShares == 0 ? 0 : divRound(_totalEquivEurUlps, _newShares)
6868         );
6869     }
6870 
6871     function etoTerms() public constant returns (ETOTerms) {
6872         return ETO_TERMS;
6873     }
6874 
6875     function equityToken() public constant returns (IEquityToken) {
6876         return EQUITY_TOKEN;
6877     }
6878 
6879     function nominee() public constant returns (address) {
6880         return NOMINEE;
6881     }
6882 
6883     function companyLegalRep() public constant returns (address) {
6884         return COMPANY_LEGAL_REPRESENTATIVE;
6885     }
6886 
6887     function singletons()
6888         public
6889         constant
6890         returns (
6891             address platformWallet,
6892             address universe,
6893             address platformTerms
6894             )
6895     {
6896         platformWallet = PLATFORM_WALLET;
6897         universe = UNIVERSE;
6898         platformTerms = PLATFORM_TERMS;
6899     }
6900 
6901     function totalInvestment()
6902         public
6903         constant
6904         returns (
6905             uint256 totalEquivEurUlps,
6906             uint256 totalTokensInt,
6907             uint256 totalInvestors
6908             )
6909     {
6910         return (_totalEquivEurUlps, _totalTokensInt, _totalInvestors);
6911     }
6912 
6913     function calculateContribution(address investor, bool fromIcbmWallet, uint256 newInvestorContributionEurUlps)
6914         external
6915         constant
6916         // use timed state so we show what should be
6917         withStateTransition()
6918         returns (
6919             bool isWhitelisted,
6920             bool isEligible,
6921             uint256 minTicketEurUlps,
6922             uint256 maxTicketEurUlps,
6923             uint256 equityTokenInt,
6924             uint256 neuRewardUlps,
6925             bool maxCapExceeded
6926             )
6927     {
6928         InvestmentTicket storage ticket = _tickets[investor];
6929         // we use state() here because time was forwarded by withStateTransition
6930         bool applyDiscounts = state() == ETOState.Whitelist;
6931         uint256 fixedSlotsEquityTokenInt;
6932         (
6933             isWhitelisted,
6934             isEligible,
6935             minTicketEurUlps,
6936             maxTicketEurUlps,
6937             equityTokenInt,
6938             fixedSlotsEquityTokenInt
6939         ) = ETO_TERMS.calculateContribution(
6940             investor,
6941             _totalEquivEurUlps,
6942             ticket.equivEurUlps,
6943             newInvestorContributionEurUlps,
6944             applyDiscounts
6945         );
6946         isWhitelisted = isWhitelisted || fromIcbmWallet;
6947         if (!fromIcbmWallet) {
6948             (,neuRewardUlps) = calculateNeumarkDistribution(NEUMARK.incremental(newInvestorContributionEurUlps));
6949         }
6950         // crossing max cap can always happen
6951         maxCapExceeded = isCapExceeded(applyDiscounts, equityTokenInt, fixedSlotsEquityTokenInt);
6952     }
6953 
6954     function investorTicket(address investor)
6955         public
6956         constant
6957         returns (
6958             uint256 equivEurUlps,
6959             uint256 rewardNmkUlps,
6960             uint256 equityTokenInt,
6961             uint256 sharesInt,
6962             uint256 tokenPrice,
6963             uint256 neuRate,
6964             uint256 amountEth,
6965             uint256 amountEurUlps,
6966             bool claimedOrRefunded,
6967             bool usedLockedAccount
6968         )
6969     {
6970         InvestmentTicket storage ticket = _tickets[investor];
6971         // here we assume that equity token precisions is 0
6972         equivEurUlps = ticket.equivEurUlps;
6973         rewardNmkUlps = ticket.rewardNmkUlps;
6974         equityTokenInt = ticket.equityTokenInt;
6975         sharesInt = ETO_TERMS.equityTokensToShares(ticket.equityTokenInt);
6976         tokenPrice = equityTokenInt > 0 ? equivEurUlps / equityTokenInt : 0;
6977         neuRate = rewardNmkUlps > 0 ? proportion(equivEurUlps, 10**18, rewardNmkUlps) : 0;
6978         amountEth = ticket.amountEth;
6979         amountEurUlps = ticket.amountEurUlps;
6980         claimedOrRefunded = ticket.claimOrRefundSettled;
6981         usedLockedAccount = ticket.usedLockedAccount;
6982     }
6983 
6984     //
6985     // Implements IContractId
6986     //
6987 
6988     function contractId() public pure returns (bytes32 id, uint256 version) {
6989         return (0x70ef68fc8c585f9edc7af1bfac26c4b1b9e98ba05cf5ddd99e4b3dc46ea70073, 0);
6990     }
6991 
6992     ////////////////////////
6993     // Internal functions
6994     ////////////////////////
6995 
6996     //
6997     // Overrides internal interface
6998     //
6999 
7000     function mAdavanceLogicState(ETOState oldState)
7001         internal
7002         constant
7003         returns (ETOState)
7004     {
7005         // add 1 to MIN_TICKET_TOKEN because it was produced by floor and check only MAX CAP
7006         // WHITELIST CAP will not induce state transition as fixed slots should be able to invest till the end of Whitelist
7007         bool capExceeded = isCapExceeded(false, MIN_TICKET_TOKENS + 1, 0);
7008         if (capExceeded) {
7009             if (oldState == ETOState.Whitelist) {
7010                 return ETOState.Public;
7011             }
7012             if (oldState == ETOState.Public) {
7013                 return ETOState.Signing;
7014             }
7015         }
7016         if (oldState == ETOState.Signing && _nomineeSignedInvestmentAgreementUrlHash != bytes32(0)) {
7017             return ETOState.Claim;
7018         }
7019         return oldState;
7020     }
7021 
7022     function mBeforeStateTransition(ETOState /*oldState*/, ETOState newState)
7023         internal
7024         constant
7025         returns (ETOState)
7026     {
7027         // force refund if floor criteria are not met
7028         // todo: allow for super edge case when MIN_NUMBER_OF_TOKENS is very close to MAX_NUMBER_OF_TOKENS and we are within minimum ticket
7029         if (newState == ETOState.Signing && _totalTokensInt < MIN_NUMBER_OF_TOKENS) {
7030             return ETOState.Refund;
7031         }
7032         // go to refund if attempt to go to Claim without nominee agreement confirmation
7033         // if (newState == ETOState.Claim && _nomineeSignedInvestmentAgreementUrlHash == bytes32(0)) {
7034         //     return ETOState.Refund;
7035         // }
7036 
7037         return newState;
7038     }
7039 
7040     function mAfterTransition(ETOState /*oldState*/, ETOState newState)
7041         internal
7042     {
7043         if (newState == ETOState.Signing) {
7044             onSigningTransition();
7045         }
7046         if (newState == ETOState.Claim) {
7047             onClaimTransition();
7048         }
7049         if (newState == ETOState.Refund) {
7050             onRefundTransition();
7051         }
7052         if (newState == ETOState.Payout) {
7053             onPayoutTransition();
7054         }
7055     }
7056 
7057     //
7058     // Overrides Agreement internal interface
7059     //
7060 
7061     function mCanAmend(address legalRepresentative)
7062         internal
7063         returns (bool)
7064     {
7065         return legalRepresentative == NOMINEE && startOfInternal(ETOState.Whitelist) == 0;
7066     }
7067 
7068     ////////////////////////
7069     // Private functions
7070     ////////////////////////
7071 
7072     // a copy of PlatformTerms working on local storage
7073     function calculateNeumarkDistribution(uint256 rewardNmk)
7074         private
7075         constant
7076         returns (uint256 platformNmk, uint256 investorNmk)
7077     {
7078         // round down - platform may get 1 wei less than investor
7079         platformNmk = rewardNmk / PLATFORM_NEUMARK_SHARE;
7080         // rewardNmk > platformNmk always
7081         return (platformNmk, rewardNmk - platformNmk);
7082     }
7083 
7084     /// called on transition to Signing
7085     function onSigningTransition()
7086         private
7087     {
7088         // get final balances
7089         uint256 etherBalance = ETHER_TOKEN.balanceOf(this);
7090         uint256 euroBalance = EURO_TOKEN.balanceOf(this);
7091         // additional equity tokens are issued and sent to platform operator (temporarily)
7092         uint256 tokensPerShare = EQUITY_TOKEN.tokensPerShare();
7093         uint256 tokenParticipationFeeInt = PLATFORM_TERMS.calculatePlatformTokenFee(_totalTokensInt);
7094         // we must have integer number of shares
7095         uint256 tokensRemainder = (_totalTokensInt + tokenParticipationFeeInt) % tokensPerShare;
7096         if (tokensRemainder > 0) {
7097             // round up to whole share
7098             tokenParticipationFeeInt += tokensPerShare - tokensRemainder;
7099         }
7100         // assert 96bit values 2**96 / 10**18 ~ 78 bln
7101         assert(_totalTokensInt + tokenParticipationFeeInt < 2 ** 96);
7102         assert(etherBalance < 2 ** 96 && euroBalance < 2 ** 96);
7103         // we save 30k gas on 96 bit resolution, we can live with 98 bln euro max investment amount
7104         _newShares = uint96((_totalTokensInt + tokenParticipationFeeInt) / tokensPerShare);
7105         // preserve platform token participation fee to be send out on claim transition
7106         _tokenParticipationFeeInt = uint96(tokenParticipationFeeInt);
7107         // compute fees to be sent on payout transition
7108         _platformFeeEth = uint96(PLATFORM_TERMS.calculatePlatformFee(etherBalance));
7109         _platformFeeEurUlps = uint96(PLATFORM_TERMS.calculatePlatformFee(euroBalance));
7110         // compute additional contributions to be sent on claim transition
7111         _additionalContributionEth = uint96(etherBalance) - _platformFeeEth;
7112         _additionalContributionEurUlps = uint96(euroBalance) - _platformFeeEurUlps;
7113         // nominee gets nominal share value immediately to be added to cap table
7114         uint256 capitalIncreaseEurUlps = EQUITY_TOKEN.shareNominalValueEurUlps() * _newShares;
7115         // limit the amount if balance on EURO_TOKEN < capitalIncreaseEurUlps. in that case Nomine must handle it offchain
7116         // no overflow as smaller one is uint96
7117         uint96 availableCapitalEurUlps = uint96(min(capitalIncreaseEurUlps, _additionalContributionEurUlps));
7118         assert(EURO_TOKEN.transfer(NOMINEE, availableCapitalEurUlps, ""));
7119         // decrease additional contribution by value that was sent to nominee
7120         _additionalContributionEurUlps -= availableCapitalEurUlps;
7121 
7122         emit LogSigningStarted(NOMINEE, COMPANY_LEGAL_REPRESENTATIVE, _newShares, capitalIncreaseEurUlps);
7123     }
7124 
7125     /// called on transition to ETOState.Claim
7126     function onClaimTransition()
7127         private
7128     {
7129         // platform operator gets share of NEU
7130         uint256 rewardNmk = NEUMARK.balanceOf(this);
7131         (uint256 platformNmk,) = calculateNeumarkDistribution(rewardNmk);
7132         assert(NEUMARK.transfer(PLATFORM_WALLET, platformNmk, ""));
7133         // company legal rep receives funds
7134         if (_additionalContributionEth > 0) {
7135             assert(ETHER_TOKEN.transfer(COMPANY_LEGAL_REPRESENTATIVE, _additionalContributionEth, ""));
7136         }
7137 
7138         if (_additionalContributionEurUlps > 0) {
7139             assert(EURO_TOKEN.transfer(COMPANY_LEGAL_REPRESENTATIVE, _additionalContributionEurUlps, ""));
7140         }
7141         // issue missing tokens
7142         EQUITY_TOKEN.issueTokens(_tokenParticipationFeeInt);
7143         emit LogPlatformNeuReward(PLATFORM_WALLET, rewardNmk, platformNmk);
7144         emit LogAdditionalContribution(COMPANY_LEGAL_REPRESENTATIVE, ETHER_TOKEN, _additionalContributionEth);
7145         emit LogAdditionalContribution(COMPANY_LEGAL_REPRESENTATIVE, EURO_TOKEN, _additionalContributionEurUlps);
7146     }
7147 
7148     /// called on transtion to ETOState.Refund
7149     function onRefundTransition()
7150         private
7151     {
7152         // burn all neumark generated in this ETO
7153         uint256 balanceNmk = NEUMARK.balanceOf(this);
7154         uint256 balanceTokenInt = EQUITY_TOKEN.balanceOf(this);
7155         if (balanceNmk > 0) {
7156             NEUMARK.burn(balanceNmk);
7157         }
7158         // destroy all tokens generated in ETO
7159         if (balanceTokenInt > 0) {
7160             EQUITY_TOKEN.destroyTokens(balanceTokenInt);
7161         }
7162         emit LogRefundStarted(EQUITY_TOKEN, balanceTokenInt, balanceNmk);
7163     }
7164 
7165     /// called on transition to ETOState.Payout
7166     function onPayoutTransition()
7167         private
7168     {
7169         // distribute what's left in balances: company took funds on claim
7170         address disbursal = UNIVERSE.feeDisbursal();
7171         assert(disbursal != address(0));
7172         address platformPortfolio = UNIVERSE.platformPortfolio();
7173         assert(platformPortfolio != address(0));
7174         bytes memory serializedAddress = abi.encodePacked(address(NEUMARK));
7175         // assert(decodeAddress(serializedAddress) == address(NEUMARK));
7176         if (_platformFeeEth > 0) {
7177             // disburse via ERC223, where we encode token used to provide pro-rata in `data` parameter
7178             assert(ETHER_TOKEN.transfer(disbursal, _platformFeeEth, serializedAddress));
7179         }
7180         if (_platformFeeEurUlps > 0) {
7181             // disburse via ERC223
7182             assert(EURO_TOKEN.transfer(disbursal, _platformFeeEurUlps, serializedAddress));
7183         }
7184         // add token participation fee to platfrom portfolio
7185         EQUITY_TOKEN.distributeTokens(platformPortfolio, _tokenParticipationFeeInt);
7186 
7187         emit LogPlatformFeePayout(ETHER_TOKEN, disbursal, _platformFeeEth);
7188         emit LogPlatformFeePayout(EURO_TOKEN, disbursal, _platformFeeEurUlps);
7189         emit LogPlatformPortfolioPayout(EQUITY_TOKEN, platformPortfolio, _tokenParticipationFeeInt);
7190     }
7191 
7192     function processTicket(
7193         address investor,
7194         address wallet,
7195         uint256 amount,
7196         uint256 equivEurUlps,
7197         bool isEuroInvestment
7198     )
7199         private
7200     {
7201         // read current ticket
7202         InvestmentTicket storage ticket = _tickets[investor];
7203         // should we apply whitelist discounts
7204         bool applyDiscounts = state() == ETOState.Whitelist;
7205         // calculate contribution
7206         (
7207             bool isWhitelisted,
7208             bool isEligible,
7209             uint minTicketEurUlps,
7210             uint256 maxTicketEurUlps,
7211             uint256 equityTokenInt256,
7212             uint256 fixedSlotEquityTokenInt256
7213         ) = ETO_TERMS.calculateContribution(investor, _totalEquivEurUlps, ticket.equivEurUlps, equivEurUlps, applyDiscounts);
7214         // kick out on KYC
7215         require(isEligible, "NF_ETO_INV_NOT_VER");
7216         assert(equityTokenInt256 < 2 ** 32 && fixedSlotEquityTokenInt256 < 2 ** 32);
7217         // kick on minimum ticket and you must buy at least one token!
7218         require(equivEurUlps + ticket.equivEurUlps >= minTicketEurUlps && equityTokenInt256 > 0, "NF_ETO_MIN_TICKET");
7219         // kick on max ticket exceeded
7220         require(equivEurUlps + ticket.equivEurUlps <= maxTicketEurUlps, "NF_ETO_MAX_TICKET");
7221         // kick on cap exceeded
7222         require(!isCapExceeded(applyDiscounts, equityTokenInt256, fixedSlotEquityTokenInt256), "NF_ETO_MAX_TOK_CAP");
7223         // when that sent money is not the same as investor it must be icbm locked wallet
7224         // bool isLockedAccount = wallet != investor;
7225         // kick out not whitelist or not LockedAccount
7226         if (applyDiscounts) {
7227             require(isWhitelisted || wallet != investor, "NF_ETO_NOT_ON_WL");
7228         }
7229         // we trust NEU token so we issue NEU before writing state
7230         // issue only for "new money" so LockedAccount from ICBM is excluded
7231         if (wallet == investor) {
7232             (, uint256 investorNmk) = calculateNeumarkDistribution(NEUMARK.issueForEuro(equivEurUlps));
7233             if (investorNmk > 0) {
7234                 // now there is rounding danger as we calculate the above for any investor but then just once to get platform share in onClaimTransition
7235                 // it is much cheaper to just round down than to book keep to a single wei which will use additional storage
7236                 // small amount of NEU ( no of investors * (PLATFORM_NEUMARK_SHARE-1)) may be left in contract
7237                 assert(investorNmk > PLATFORM_NEUMARK_SHARE - 1);
7238                 investorNmk -= PLATFORM_NEUMARK_SHARE - 1;
7239             }
7240         }
7241         // issue equity token
7242         assert(equityTokenInt256 + ticket.equityTokenInt < 2**32);
7243         // this will also check ticket.amountEurUlps + uint96(amount) as ticket.equivEurUlps is always >= ticket.amountEurUlps
7244         assert(equivEurUlps + ticket.equivEurUlps < 2**96);
7245         assert(amount < 2**96);
7246         // practically impossible: would require price of ETH smaller than 1 EUR and > 2**96 amount of ether
7247         assert(uint256(ticket.amountEth) + amount < 2**96);
7248         EQUITY_TOKEN.issueTokens(uint32(equityTokenInt256));
7249         // update total investment
7250         _totalEquivEurUlps += uint96(equivEurUlps);
7251         _totalTokensInt += uint32(equityTokenInt256);
7252         _totalFixedSlotsTokensInt += uint32(fixedSlotEquityTokenInt256);
7253         _totalInvestors += ticket.equivEurUlps == 0 ? 1 : 0;
7254         // write new ticket values
7255         ticket.equivEurUlps += uint96(equivEurUlps);
7256         // uint96 is much more than 1.5 bln of NEU so no overflow
7257         ticket.rewardNmkUlps += uint96(investorNmk);
7258         ticket.equityTokenInt += uint32(equityTokenInt256);
7259         if (isEuroInvestment) {
7260             ticket.amountEurUlps += uint96(amount);
7261         } else {
7262             ticket.amountEth += uint96(amount);
7263         }
7264         ticket.usedLockedAccount = ticket.usedLockedAccount || wallet != investor;
7265         // log successful commitment
7266         emit LogFundsCommitted(
7267             investor,
7268             wallet,
7269             msg.sender,
7270             amount,
7271             equivEurUlps,
7272             equityTokenInt256,
7273             EQUITY_TOKEN,
7274             investorNmk
7275         );
7276     }
7277 
7278     function isCapExceeded(bool applyDiscounts, uint256 equityTokenInt, uint256 fixedSlotsEquityTokenInt)
7279         private
7280         constant
7281         returns (bool maxCapExceeded)
7282     {
7283         maxCapExceeded = _totalTokensInt + equityTokenInt > MAX_NUMBER_OF_TOKENS;
7284         if (applyDiscounts && !maxCapExceeded) {
7285             maxCapExceeded = _totalTokensInt + equityTokenInt - _totalFixedSlotsTokensInt - fixedSlotsEquityTokenInt > MAX_NUMBER_OF_TOKENS_IN_WHITELIST;
7286         }
7287     }
7288 
7289     function claimTokensPrivate(address investor)
7290         private
7291     {
7292         InvestmentTicket storage ticket = _tickets[investor];
7293         if (ticket.claimOrRefundSettled) {
7294             return;
7295         }
7296         if (ticket.equivEurUlps == 0) {
7297             return;
7298         }
7299         ticket.claimOrRefundSettled = true;
7300 
7301         if (ticket.rewardNmkUlps > 0) {
7302             NEUMARK.distribute(investor, ticket.rewardNmkUlps);
7303         }
7304         if (ticket.equityTokenInt > 0) {
7305             EQUITY_TOKEN.distributeTokens(investor, ticket.equityTokenInt);
7306         }
7307         if (ticket.usedLockedAccount) {
7308             ETHER_LOCK.claimed(investor);
7309             EURO_LOCK.claimed(investor);
7310         }
7311         emit LogTokensClaimed(investor, EQUITY_TOKEN, ticket.equityTokenInt, ticket.rewardNmkUlps);
7312     }
7313 
7314     function refundTokensPrivate(address investor)
7315         private
7316     {
7317         InvestmentTicket storage ticket = _tickets[investor];
7318         if (ticket.claimOrRefundSettled) {
7319             return;
7320         }
7321         if (ticket.equivEurUlps == 0) {
7322             return;
7323         }
7324         ticket.claimOrRefundSettled = true;
7325         refundSingleToken(investor, ticket.amountEth, ticket.usedLockedAccount, ETHER_LOCK, ETHER_TOKEN);
7326         refundSingleToken(investor, ticket.amountEurUlps, ticket.usedLockedAccount, EURO_LOCK, EURO_TOKEN);
7327 
7328         emit LogFundsRefunded(investor, ETHER_TOKEN, ticket.amountEth);
7329         emit LogFundsRefunded(investor, EURO_TOKEN, ticket.amountEurUlps);
7330     }
7331 
7332     function refundSingleToken(
7333         address investor,
7334         uint256 amount,
7335         bool usedLockedAccount,
7336         LockedAccount lockedAccount,
7337         IERC223Token token
7338     )
7339         private
7340     {
7341         if (amount == 0) {
7342             return;
7343         }
7344         uint256 a = amount;
7345         // possible partial refund to locked account
7346         if (usedLockedAccount) {
7347             (uint256 balance,) = lockedAccount.pendingCommitments(this, investor);
7348             assert(balance <= a);
7349             if (balance > 0) {
7350                 assert(token.approve(address(lockedAccount), balance));
7351                 lockedAccount.refunded(investor);
7352                 a -= balance;
7353             }
7354         }
7355         if (a > 0) {
7356             assert(token.transfer(investor, a, ""));
7357         }
7358     }
7359 }