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
894 /// @title uniquely identifies deployable (non-abstract) platform contract
895 /// @notice cheap way of assigning implementations to knownInterfaces which represent system services
896 ///         unfortunatelly ERC165 does not include full public interface (ABI) and does not provide way to list implemented interfaces
897 ///         EIP820 still in the making
898 /// @dev ids are generated as follows keccak256("neufund-platform:<contract name>")
899 ///      ids roughly correspond to ABIs
900 contract IContractId {
901     /// @param id defined as above
902     /// @param version implementation version
903     function contractId() public pure returns (bytes32 id, uint256 version);
904 }
905 
906 contract ShareholderRights is IContractId {
907 
908     ////////////////////////
909     // Types
910     ////////////////////////
911 
912     enum VotingRule {
913         // nominee has no voting rights
914         NoVotingRights,
915         // nominee votes yes if token holders do not say otherwise
916         Positive,
917         // nominee votes against if token holders do not say otherwise
918         Negative,
919         // nominee passes the vote as is giving yes/no split
920         Proportional
921     }
922 
923     ////////////////////////
924     // Constants state
925     ////////////////////////
926 
927     bytes32 private constant EMPTY_STRING_HASH = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
928 
929     ////////////////////////
930     // Immutable state
931     ////////////////////////
932 
933     // a right to drag along (or be dragged) on exit
934     bool public constant HAS_DRAG_ALONG_RIGHTS = true;
935     // a right to tag along
936     bool public constant HAS_TAG_ALONG_RIGHTS = true;
937     // information is fundamental right that cannot be removed
938     bool public constant HAS_GENERAL_INFORMATION_RIGHTS = true;
939     // voting Right
940     VotingRule public GENERAL_VOTING_RULE;
941     // voting rights in tag along
942     VotingRule public TAG_ALONG_VOTING_RULE;
943     // liquidation preference multiplicator as decimal fraction
944     uint256 public LIQUIDATION_PREFERENCE_MULTIPLIER_FRAC;
945     // founder's vesting
946     bool public HAS_FOUNDERS_VESTING;
947     // duration of general voting
948     uint256 public GENERAL_VOTING_DURATION;
949     // duration of restricted act votings (like exit etc.)
950     uint256 public RESTRICTED_ACT_VOTING_DURATION;
951     // offchain time to finalize and execute voting;
952     uint256 public VOTING_FINALIZATION_DURATION;
953     // quorum of tokenholders for the vote to count as decimal fraction
954     uint256 public TOKENHOLDERS_QUORUM_FRAC = 10**17; // 10%
955     // number of tokens voting / total supply must be more than this to count the vote
956     uint256 public VOTING_MAJORITY_FRAC = 10**17; // 10%
957     // url (typically IPFS hash) to investment agreement between nominee and company
958     string public INVESTMENT_AGREEMENT_TEMPLATE_URL;
959 
960     ////////////////////////
961     // Constructor
962     ////////////////////////
963 
964     constructor(
965         VotingRule generalVotingRule,
966         VotingRule tagAlongVotingRule,
967         uint256 liquidationPreferenceMultiplierFrac,
968         bool hasFoundersVesting,
969         uint256 generalVotingDuration,
970         uint256 restrictedActVotingDuration,
971         uint256 votingFinalizationDuration,
972         uint256 tokenholdersQuorumFrac,
973         uint256 votingMajorityFrac,
974         string investmentAgreementTemplateUrl
975     )
976         public
977     {
978         // todo: revise requires
979         require(uint(generalVotingRule) < 4);
980         require(uint(tagAlongVotingRule) < 4);
981         // quorum < 100%
982         require(tokenholdersQuorumFrac < 10**18);
983         require(keccak256(abi.encodePacked(investmentAgreementTemplateUrl)) != EMPTY_STRING_HASH);
984 
985         GENERAL_VOTING_RULE = generalVotingRule;
986         TAG_ALONG_VOTING_RULE = tagAlongVotingRule;
987         LIQUIDATION_PREFERENCE_MULTIPLIER_FRAC = liquidationPreferenceMultiplierFrac;
988         HAS_FOUNDERS_VESTING = hasFoundersVesting;
989         GENERAL_VOTING_DURATION = generalVotingDuration;
990         RESTRICTED_ACT_VOTING_DURATION = restrictedActVotingDuration;
991         VOTING_FINALIZATION_DURATION = votingFinalizationDuration;
992         TOKENHOLDERS_QUORUM_FRAC = tokenholdersQuorumFrac;
993         VOTING_MAJORITY_FRAC = votingMajorityFrac;
994         INVESTMENT_AGREEMENT_TEMPLATE_URL = investmentAgreementTemplateUrl;
995     }
996 
997     //
998     // Implements IContractId
999     //
1000 
1001     function contractId() public pure returns (bytes32 id, uint256 version) {
1002         return (0x7f46caed28b4e7a90dc4db9bba18d1565e6c4824f0dc1b96b3b88d730da56e57, 0);
1003     }
1004 }
1005 
1006 contract Math {
1007 
1008     ////////////////////////
1009     // Internal functions
1010     ////////////////////////
1011 
1012     // absolute difference: |v1 - v2|
1013     function absDiff(uint256 v1, uint256 v2)
1014         internal
1015         pure
1016         returns(uint256)
1017     {
1018         return v1 > v2 ? v1 - v2 : v2 - v1;
1019     }
1020 
1021     // divide v by d, round up if remainder is 0.5 or more
1022     function divRound(uint256 v, uint256 d)
1023         internal
1024         pure
1025         returns(uint256)
1026     {
1027         return add(v, d/2) / d;
1028     }
1029 
1030     // computes decimal decimalFraction 'frac' of 'amount' with maximum precision (multiplication first)
1031     // both amount and decimalFraction must have 18 decimals precision, frac 10**18 represents a whole (100% of) amount
1032     // mind loss of precision as decimal fractions do not have finite binary expansion
1033     // do not use instead of division
1034     function decimalFraction(uint256 amount, uint256 frac)
1035         internal
1036         pure
1037         returns(uint256)
1038     {
1039         // it's like 1 ether is 100% proportion
1040         return proportion(amount, frac, 10**18);
1041     }
1042 
1043     // computes part/total of amount with maximum precision (multiplication first)
1044     // part and total must have the same units
1045     function proportion(uint256 amount, uint256 part, uint256 total)
1046         internal
1047         pure
1048         returns(uint256)
1049     {
1050         return divRound(mul(amount, part), total);
1051     }
1052 
1053     //
1054     // Open Zeppelin Math library below
1055     //
1056 
1057     function mul(uint256 a, uint256 b)
1058         internal
1059         pure
1060         returns (uint256)
1061     {
1062         uint256 c = a * b;
1063         assert(a == 0 || c / a == b);
1064         return c;
1065     }
1066 
1067     function sub(uint256 a, uint256 b)
1068         internal
1069         pure
1070         returns (uint256)
1071     {
1072         assert(b <= a);
1073         return a - b;
1074     }
1075 
1076     function add(uint256 a, uint256 b)
1077         internal
1078         pure
1079         returns (uint256)
1080     {
1081         uint256 c = a + b;
1082         assert(c >= a);
1083         return c;
1084     }
1085 
1086     function min(uint256 a, uint256 b)
1087         internal
1088         pure
1089         returns (uint256)
1090     {
1091         return a < b ? a : b;
1092     }
1093 
1094     function max(uint256 a, uint256 b)
1095         internal
1096         pure
1097         returns (uint256)
1098     {
1099         return a > b ? a : b;
1100     }
1101 }
1102 
1103 /// @title set terms of Platform (investor's network) of the ETO
1104 contract PlatformTerms is Math, IContractId {
1105 
1106     ////////////////////////
1107     // Constants
1108     ////////////////////////
1109 
1110     // fraction of fee deduced on successful ETO (see Math.sol for fraction definition)
1111     uint256 public constant PLATFORM_FEE_FRACTION = 3 * 10**16;
1112     // fraction of tokens deduced on succesful ETO
1113     uint256 public constant TOKEN_PARTICIPATION_FEE_FRACTION = 2 * 10**16;
1114     // share of Neumark reward platform operator gets
1115     // actually this is a divisor that splits Neumark reward in two parts
1116     // the results of division belongs to platform operator, the remaining reward part belongs to investor
1117     uint256 public constant PLATFORM_NEUMARK_SHARE = 2; // 50:50 division
1118     // ICBM investors whitelisted by default
1119     bool public constant IS_ICBM_INVESTOR_WHITELISTED = true;
1120 
1121     // minimum ticket size Platform accepts in EUR ULPS
1122     uint256 public constant MIN_TICKET_EUR_ULPS = 100 * 10**18;
1123     // maximum ticket size Platform accepts in EUR ULPS
1124     // no max ticket in general prospectus regulation
1125     // uint256 public constant MAX_TICKET_EUR_ULPS = 10000000 * 10**18;
1126 
1127     // min duration from setting the date to ETO start
1128     uint256 public constant DATE_TO_WHITELIST_MIN_DURATION = 5 days;
1129     // token rate expires after
1130     uint256 public constant TOKEN_RATE_EXPIRES_AFTER = 4 hours;
1131 
1132     // duration constraints
1133     uint256 public constant MIN_WHITELIST_DURATION = 0 days;
1134     uint256 public constant MAX_WHITELIST_DURATION = 30 days;
1135     uint256 public constant MIN_PUBLIC_DURATION = 0 days;
1136     uint256 public constant MAX_PUBLIC_DURATION = 60 days;
1137 
1138     // minimum length of whole offer
1139     uint256 public constant MIN_OFFER_DURATION = 1 days;
1140     // quarter should be enough for everyone
1141     uint256 public constant MAX_OFFER_DURATION = 90 days;
1142 
1143     uint256 public constant MIN_SIGNING_DURATION = 14 days;
1144     uint256 public constant MAX_SIGNING_DURATION = 60 days;
1145 
1146     uint256 public constant MIN_CLAIM_DURATION = 7 days;
1147     uint256 public constant MAX_CLAIM_DURATION = 30 days;
1148 
1149     ////////////////////////
1150     // Public Function
1151     ////////////////////////
1152 
1153     // calculates investor's and platform operator's neumarks from total reward
1154     function calculateNeumarkDistribution(uint256 rewardNmk)
1155         public
1156         pure
1157         returns (uint256 platformNmk, uint256 investorNmk)
1158     {
1159         // round down - platform may get 1 wei less than investor
1160         platformNmk = rewardNmk / PLATFORM_NEUMARK_SHARE;
1161         // rewardNmk > platformNmk always
1162         return (platformNmk, rewardNmk - platformNmk);
1163     }
1164 
1165     function calculatePlatformTokenFee(uint256 tokenAmount)
1166         public
1167         pure
1168         returns (uint256)
1169     {
1170         // mind tokens having 0 precision
1171         return proportion(tokenAmount, TOKEN_PARTICIPATION_FEE_FRACTION, 10**18);
1172     }
1173 
1174     function calculatePlatformFee(uint256 amount)
1175         public
1176         pure
1177         returns (uint256)
1178     {
1179         return decimalFraction(amount, PLATFORM_FEE_FRACTION);
1180     }
1181 
1182     //
1183     // Implements IContractId
1184     //
1185 
1186     function contractId() public pure returns (bytes32 id, uint256 version) {
1187         return (0x95482babc4e32de6c4dc3910ee7ae62c8e427efde6bc4e9ce0d6d93e24c39323, 0);
1188     }
1189 }
1190 
1191 /// @title describes layout of claims in 256bit records stored for identities
1192 /// @dev intended to be derived by contracts requiring access to particular claims
1193 contract IdentityRecord {
1194 
1195     ////////////////////////
1196     // Types
1197     ////////////////////////
1198 
1199     /// @dev here the idea is to have claims of size of uint256 and use this struct
1200     ///     to translate in and out of this struct. until we do not cross uint256 we
1201     ///     have binary compatibility
1202     struct IdentityClaims {
1203         bool isVerified; // 1 bit
1204         bool isSophisticatedInvestor; // 1 bit
1205         bool hasBankAccount; // 1 bit
1206         bool accountFrozen; // 1 bit
1207         // uint252 reserved
1208     }
1209 
1210     ////////////////////////
1211     // Internal functions
1212     ////////////////////////
1213 
1214     /// translates uint256 to struct
1215     function deserializeClaims(bytes32 data) internal pure returns (IdentityClaims memory claims) {
1216         // for memory layout of struct, each field below word length occupies whole word
1217         assembly {
1218             mstore(claims, and(data, 0x1))
1219             mstore(add(claims, 0x20), div(and(data, 0x2), 0x2))
1220             mstore(add(claims, 0x40), div(and(data, 0x4), 0x4))
1221             mstore(add(claims, 0x60), div(and(data, 0x8), 0x8))
1222         }
1223     }
1224 }
1225 
1226 
1227 /// @title interface storing and retrieve 256bit claims records for identity
1228 /// actual format of record is decoupled from storage (except maximum size)
1229 contract IIdentityRegistry {
1230 
1231     ////////////////////////
1232     // Events
1233     ////////////////////////
1234 
1235     /// provides information on setting claims
1236     event LogSetClaims(
1237         address indexed identity,
1238         bytes32 oldClaims,
1239         bytes32 newClaims
1240     );
1241 
1242     ////////////////////////
1243     // Public functions
1244     ////////////////////////
1245 
1246     /// get claims for identity
1247     function getClaims(address identity) public constant returns (bytes32);
1248 
1249     /// set claims for identity
1250     /// @dev odlClaims and newClaims used for optimistic locking. to override with newClaims
1251     ///     current claims must be oldClaims
1252     function setClaims(address identity, bytes32 oldClaims, bytes32 newClaims) public;
1253 }
1254 
1255 /// @title known interfaces (services) of the platform
1256 /// "known interface" is a unique id of service provided by the platform and discovered via Universe contract
1257 ///  it does not refer to particular contract/interface ABI, particular service may be delivered via different implementations
1258 ///  however for a few contracts we commit platform to particular implementation (all ICBM Contracts, Universe itself etc.)
1259 /// @dev constants are kept in CODE not in STORAGE so they are comparatively cheap
1260 contract KnownInterfaces {
1261 
1262     ////////////////////////
1263     // Constants
1264     ////////////////////////
1265 
1266     // NOTE: All interface are set to the keccak256 hash of the
1267     // CamelCased interface or singleton name, i.e.
1268     // KNOWN_INTERFACE_NEUMARK = keccak256("Neumark")
1269 
1270     // EIP 165 + EIP 820 should be use instead but it seems they are far from finished
1271     // also interface signature should be build automatically by solidity. otherwise it is a pure hassle
1272 
1273     // neumark token interface and sigleton keccak256("Neumark")
1274     bytes4 internal constant KNOWN_INTERFACE_NEUMARK = 0xeb41a1bd;
1275 
1276     // ether token interface and singleton keccak256("EtherToken")
1277     bytes4 internal constant KNOWN_INTERFACE_ETHER_TOKEN = 0x8cf73cf1;
1278 
1279     // euro token interface and singleton keccak256("EuroToken")
1280     bytes4 internal constant KNOWN_INTERFACE_EURO_TOKEN = 0x83c3790b;
1281 
1282     // identity registry interface and singleton keccak256("IIdentityRegistry")
1283     bytes4 internal constant KNOWN_INTERFACE_IDENTITY_REGISTRY = 0x0a72e073;
1284 
1285     // currency rates oracle interface and singleton keccak256("ITokenExchangeRateOracle")
1286     bytes4 internal constant KNOWN_INTERFACE_TOKEN_EXCHANGE_RATE_ORACLE = 0xc6e5349e;
1287 
1288     // fee disbursal interface and singleton keccak256("IFeeDisbursal")
1289     bytes4 internal constant KNOWN_INTERFACE_FEE_DISBURSAL = 0xf4c848e8;
1290 
1291     // platform portfolio holding equity tokens belonging to NEU holders keccak256("IPlatformPortfolio");
1292     bytes4 internal constant KNOWN_INTERFACE_PLATFORM_PORTFOLIO = 0xaa1590d0;
1293 
1294     // token exchange interface and singleton keccak256("ITokenExchange")
1295     bytes4 internal constant KNOWN_INTERFACE_TOKEN_EXCHANGE = 0xddd7a521;
1296 
1297     // service exchanging euro token for gas ("IGasTokenExchange")
1298     bytes4 internal constant KNOWN_INTERFACE_GAS_EXCHANGE = 0x89dbc6de;
1299 
1300     // access policy interface and singleton keccak256("IAccessPolicy")
1301     bytes4 internal constant KNOWN_INTERFACE_ACCESS_POLICY = 0xb05049d9;
1302 
1303     // euro lock account (upgraded) keccak256("LockedAccount:Euro")
1304     bytes4 internal constant KNOWN_INTERFACE_EURO_LOCK = 0x2347a19e;
1305 
1306     // ether lock account (upgraded) keccak256("LockedAccount:Ether")
1307     bytes4 internal constant KNOWN_INTERFACE_ETHER_LOCK = 0x978a6823;
1308 
1309     // icbm euro lock account keccak256("ICBMLockedAccount:Euro")
1310     bytes4 internal constant KNOWN_INTERFACE_ICBM_EURO_LOCK = 0x36021e14;
1311 
1312     // ether lock account (upgraded) keccak256("ICBMLockedAccount:Ether")
1313     bytes4 internal constant KNOWN_INTERFACE_ICBM_ETHER_LOCK = 0x0b58f006;
1314 
1315     // ether token interface and singleton keccak256("ICBMEtherToken")
1316     bytes4 internal constant KNOWN_INTERFACE_ICBM_ETHER_TOKEN = 0xae8b50b9;
1317 
1318     // euro token interface and singleton keccak256("ICBMEuroToken")
1319     bytes4 internal constant KNOWN_INTERFACE_ICBM_EURO_TOKEN = 0xc2c6cd72;
1320 
1321     // ICBM commitment interface interface and singleton keccak256("ICBMCommitment")
1322     bytes4 internal constant KNOWN_INTERFACE_ICBM_COMMITMENT = 0x7f2795ef;
1323 
1324     // ethereum fork arbiter interface and singleton keccak256("IEthereumForkArbiter")
1325     bytes4 internal constant KNOWN_INTERFACE_FORK_ARBITER = 0x2fe7778c;
1326 
1327     // Platform terms interface and singletong keccak256("PlatformTerms")
1328     bytes4 internal constant KNOWN_INTERFACE_PLATFORM_TERMS = 0x75ecd7f8;
1329 
1330     // for completness we define Universe service keccak256("Universe");
1331     bytes4 internal constant KNOWN_INTERFACE_UNIVERSE = 0xbf202454;
1332 
1333     // ETO commitment interface (collection) keccak256("ICommitment")
1334     bytes4 internal constant KNOWN_INTERFACE_COMMITMENT = 0xfa0e0c60;
1335 
1336     // Equity Token Controller interface (collection) keccak256("IEquityTokenController")
1337     bytes4 internal constant KNOWN_INTERFACE_EQUITY_TOKEN_CONTROLLER = 0xfa30b2f1;
1338 
1339     // Equity Token interface (collection) keccak256("IEquityToken")
1340     bytes4 internal constant KNOWN_INTERFACE_EQUITY_TOKEN = 0xab9885bb;
1341 }
1342 
1343 contract IsContract {
1344 
1345     ////////////////////////
1346     // Internal functions
1347     ////////////////////////
1348 
1349     function isContract(address addr)
1350         internal
1351         constant
1352         returns (bool)
1353     {
1354         uint256 size;
1355         // takes 700 gas
1356         assembly { size := extcodesize(addr) }
1357         return size > 0;
1358     }
1359 }
1360 
1361 contract NeumarkIssuanceCurve {
1362 
1363     ////////////////////////
1364     // Constants
1365     ////////////////////////
1366 
1367     // maximum number of neumarks that may be created
1368     uint256 private constant NEUMARK_CAP = 1500000000000000000000000000;
1369 
1370     // initial neumark reward fraction (controls curve steepness)
1371     uint256 private constant INITIAL_REWARD_FRACTION = 6500000000000000000;
1372 
1373     // stop issuing new Neumarks above this Euro value (as it goes quickly to zero)
1374     uint256 private constant ISSUANCE_LIMIT_EUR_ULPS = 8300000000000000000000000000;
1375 
1376     // approximate curve linearly above this Euro value
1377     uint256 private constant LINEAR_APPROX_LIMIT_EUR_ULPS = 2100000000000000000000000000;
1378     uint256 private constant NEUMARKS_AT_LINEAR_LIMIT_ULPS = 1499832501287264827896539871;
1379 
1380     uint256 private constant TOT_LINEAR_NEUMARKS_ULPS = NEUMARK_CAP - NEUMARKS_AT_LINEAR_LIMIT_ULPS;
1381     uint256 private constant TOT_LINEAR_EUR_ULPS = ISSUANCE_LIMIT_EUR_ULPS - LINEAR_APPROX_LIMIT_EUR_ULPS;
1382 
1383     ////////////////////////
1384     // Public functions
1385     ////////////////////////
1386 
1387     /// @notice returns additional amount of neumarks issued for euroUlps at totalEuroUlps
1388     /// @param totalEuroUlps actual curve position from which neumarks will be issued
1389     /// @param euroUlps amount against which neumarks will be issued
1390     function incremental(uint256 totalEuroUlps, uint256 euroUlps)
1391         public
1392         pure
1393         returns (uint256 neumarkUlps)
1394     {
1395         require(totalEuroUlps + euroUlps >= totalEuroUlps);
1396         uint256 from = cumulative(totalEuroUlps);
1397         uint256 to = cumulative(totalEuroUlps + euroUlps);
1398         // as expansion is not monotonic for large totalEuroUlps, assert below may fail
1399         // example: totalEuroUlps=1.999999999999999999999000000e+27 and euroUlps=50
1400         assert(to >= from);
1401         return to - from;
1402     }
1403 
1404     /// @notice returns amount of euro corresponding to burned neumarks
1405     /// @param totalEuroUlps actual curve position from which neumarks will be burned
1406     /// @param burnNeumarkUlps amount of neumarks to burn
1407     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps)
1408         public
1409         pure
1410         returns (uint256 euroUlps)
1411     {
1412         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
1413         require(totalNeumarkUlps >= burnNeumarkUlps);
1414         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
1415         uint newTotalEuroUlps = cumulativeInverse(fromNmk, 0, totalEuroUlps);
1416         // yes, this may overflow due to non monotonic inverse function
1417         assert(totalEuroUlps >= newTotalEuroUlps);
1418         return totalEuroUlps - newTotalEuroUlps;
1419     }
1420 
1421     /// @notice returns amount of euro corresponding to burned neumarks
1422     /// @param totalEuroUlps actual curve position from which neumarks will be burned
1423     /// @param burnNeumarkUlps amount of neumarks to burn
1424     /// @param minEurUlps euro amount to start inverse search from, inclusive
1425     /// @param maxEurUlps euro amount to end inverse search to, inclusive
1426     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
1427         public
1428         pure
1429         returns (uint256 euroUlps)
1430     {
1431         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
1432         require(totalNeumarkUlps >= burnNeumarkUlps);
1433         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
1434         uint newTotalEuroUlps = cumulativeInverse(fromNmk, minEurUlps, maxEurUlps);
1435         // yes, this may overflow due to non monotonic inverse function
1436         assert(totalEuroUlps >= newTotalEuroUlps);
1437         return totalEuroUlps - newTotalEuroUlps;
1438     }
1439 
1440     /// @notice finds total amount of neumarks issued for given amount of Euro
1441     /// @dev binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
1442     ///     function below is not monotonic
1443     function cumulative(uint256 euroUlps)
1444         public
1445         pure
1446         returns(uint256 neumarkUlps)
1447     {
1448         // Return the cap if euroUlps is above the limit.
1449         if (euroUlps >= ISSUANCE_LIMIT_EUR_ULPS) {
1450             return NEUMARK_CAP;
1451         }
1452         // use linear approximation above limit below
1453         // binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
1454         if (euroUlps >= LINEAR_APPROX_LIMIT_EUR_ULPS) {
1455             // (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS) is small so expression does not overflow
1456             return NEUMARKS_AT_LINEAR_LIMIT_ULPS + (TOT_LINEAR_NEUMARKS_ULPS * (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS)) / TOT_LINEAR_EUR_ULPS;
1457         }
1458 
1459         // Approximate cap-cap·(1-1/D)^n using the Binomial expansion
1460         // http://galileo.phys.virginia.edu/classes/152.mf1i.spring02/Exponential_Function.htm
1461         // Function[imax, -CAP*Sum[(-IR*EUR/CAP)^i/Factorial[i], {i, imax}]]
1462         // which may be simplified to
1463         // Function[imax, -CAP*Sum[(EUR)^i/(Factorial[i]*(-d)^i), {i, 1, imax}]]
1464         // where d = cap/initial_reward
1465         uint256 d = 230769230769230769230769231; // NEUMARK_CAP / INITIAL_REWARD_FRACTION
1466         uint256 term = NEUMARK_CAP;
1467         uint256 sum = 0;
1468         uint256 denom = d;
1469         do assembly {
1470             // We use assembler primarily to avoid the expensive
1471             // divide-by-zero check solc inserts for the / operator.
1472             term  := div(mul(term, euroUlps), denom)
1473             sum   := add(sum, term)
1474             denom := add(denom, d)
1475             // sub next term as we have power of negative value in the binomial expansion
1476             term  := div(mul(term, euroUlps), denom)
1477             sum   := sub(sum, term)
1478             denom := add(denom, d)
1479         } while (term != 0);
1480         return sum;
1481     }
1482 
1483     /// @notice find issuance curve inverse by binary search
1484     /// @param neumarkUlps neumark amount to compute inverse for
1485     /// @param minEurUlps minimum search range for the inverse, inclusive
1486     /// @param maxEurUlps maxium search range for the inverse, inclusive
1487     /// @dev in case of approximate search (no exact inverse) upper element of minimal search range is returned
1488     /// @dev in case of many possible inverses, the lowest one will be used (if range permits)
1489     /// @dev corresponds to a linear search that returns first euroUlp value that has cumulative() equal or greater than neumarkUlps
1490     function cumulativeInverse(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
1491         public
1492         pure
1493         returns (uint256 euroUlps)
1494     {
1495         require(maxEurUlps >= minEurUlps);
1496         require(cumulative(minEurUlps) <= neumarkUlps);
1497         require(cumulative(maxEurUlps) >= neumarkUlps);
1498         uint256 min = minEurUlps;
1499         uint256 max = maxEurUlps;
1500 
1501         // Binary search
1502         while (max > min) {
1503             uint256 mid = (max + min) / 2;
1504             uint256 val = cumulative(mid);
1505             // exact solution should not be used, a late points of the curve when many euroUlps are needed to
1506             // increase by one nmkUlp this will lead to  "indeterministic" inverse values that depend on the initial min and max
1507             // and further binary division -> you can land at any of the euro value that is mapped to the same nmk value
1508             // with condition below removed, binary search will point to the lowest eur value possible which is good because it cannot be exploited even with 0 gas costs
1509             /* if (val == neumarkUlps) {
1510                 return mid;
1511             }*/
1512             // NOTE: approximate search (no inverse) must return upper element of the final range
1513             //  last step of approximate search is always (min, min+1) so new mid is (2*min+1)/2 => min
1514             //  so new min = mid + 1 = max which was upper range. and that ends the search
1515             // NOTE: when there are multiple inverses for the same neumarkUlps, the `max` will be dragged down
1516             //  by `max = mid` expression to the lowest eur value of inverse. works only for ranges that cover all points of multiple inverse
1517             if (val < neumarkUlps) {
1518                 min = mid + 1;
1519             } else {
1520                 max = mid;
1521             }
1522         }
1523         // NOTE: It is possible that there is no inverse
1524         //  for example curve(0) = 0 and curve(1) = 6, so
1525         //  there is no value y such that curve(y) = 5.
1526         //  When there is no inverse, we must return upper element of last search range.
1527         //  This has the effect of reversing the curve less when
1528         //  burning Neumarks. This ensures that Neumarks can always
1529         //  be burned. It also ensure that the total supply of Neumarks
1530         //  remains below the cap.
1531         return max;
1532     }
1533 
1534     function neumarkCap()
1535         public
1536         pure
1537         returns (uint256)
1538     {
1539         return NEUMARK_CAP;
1540     }
1541 
1542     function initialRewardFraction()
1543         public
1544         pure
1545         returns (uint256)
1546     {
1547         return INITIAL_REWARD_FRACTION;
1548     }
1549 }
1550 
1551 /// @title allows deriving contract to recover any token or ether that it has balance of
1552 /// @notice note that this opens your contracts to claims from various people saying they lost tokens and they want them back
1553 ///     be ready to handle such claims
1554 /// @dev use with care!
1555 ///     1. ROLE_RECLAIMER is allowed to claim tokens, it's not returning tokens to original owner
1556 ///     2. in derived contract that holds any token by design you must override `reclaim` and block such possibility.
1557 ///         see ICBMLockedAccount as an example
1558 contract Reclaimable is AccessControlled, AccessRoles {
1559 
1560     ////////////////////////
1561     // Constants
1562     ////////////////////////
1563 
1564     IBasicToken constant internal RECLAIM_ETHER = IBasicToken(0x0);
1565 
1566     ////////////////////////
1567     // Public functions
1568     ////////////////////////
1569 
1570     function reclaim(IBasicToken token)
1571         public
1572         only(ROLE_RECLAIMER)
1573     {
1574         address reclaimer = msg.sender;
1575         if(token == RECLAIM_ETHER) {
1576             reclaimer.transfer(address(this).balance);
1577         } else {
1578             uint256 balance = token.balanceOf(this);
1579             require(token.transfer(reclaimer, balance));
1580         }
1581     }
1582 }
1583 
1584 /// @title advances snapshot id on demand
1585 /// @dev see Snapshot folder for implementation examples ie. DailyAndSnapshotable contract
1586 contract ISnapshotable {
1587 
1588     ////////////////////////
1589     // Events
1590     ////////////////////////
1591 
1592     /// @dev should log each new snapshot id created, including snapshots created automatically via MSnapshotPolicy
1593     event LogSnapshotCreated(uint256 snapshotId);
1594 
1595     ////////////////////////
1596     // Public functions
1597     ////////////////////////
1598 
1599     /// always creates new snapshot id which gets returned
1600     /// however, there is no guarantee that any snapshot will be created with this id, this depends on the implementation of MSnaphotPolicy
1601     function createSnapshot()
1602         public
1603         returns (uint256);
1604 
1605     /// upper bound of series snapshotIds for which there's a value
1606     function currentSnapshotId()
1607         public
1608         constant
1609         returns (uint256);
1610 }
1611 
1612 /// @title Abstracts snapshot id creation logics
1613 /// @dev Mixin (internal interface) of the snapshot policy which abstracts snapshot id creation logics from Snapshot contract
1614 /// @dev to be implemented and such implementation should be mixed with Snapshot-derived contract, see EveryBlock for simplest example of implementation and StandardSnapshotToken
1615 contract MSnapshotPolicy {
1616 
1617     ////////////////////////
1618     // Internal functions
1619     ////////////////////////
1620 
1621     // The snapshot Ids need to be strictly increasing.
1622     // Whenever the snaspshot id changes, a new snapshot will be created.
1623     // As long as the same snapshot id is being returned, last snapshot will be updated as this indicates that snapshot id didn't change
1624     //
1625     // Values passed to `hasValueAt` and `valuteAt` are required
1626     // to be less or equal to `mCurrentSnapshotId()`.
1627     function mAdvanceSnapshotId()
1628         internal
1629         returns (uint256);
1630 
1631     // this is a version of mAdvanceSnapshotId that does not modify state but MUST return the same value
1632     // it is required to implement ITokenSnapshots interface cleanly
1633     function mCurrentSnapshotId()
1634         internal
1635         constant
1636         returns (uint256);
1637 
1638 }
1639 
1640 /// @title creates new snapshot id on each day boundary
1641 /// @dev snapshot id is unix timestamp of current day boundary
1642 contract Daily is MSnapshotPolicy {
1643 
1644     ////////////////////////
1645     // Constants
1646     ////////////////////////
1647 
1648     // Floor[2**128 / 1 days]
1649     uint256 private MAX_TIMESTAMP = 3938453320844195178974243141571391;
1650 
1651     ////////////////////////
1652     // Constructor
1653     ////////////////////////
1654 
1655     /// @param start snapshotId from which to start generating values, used to prevent cloning from incompatible schemes
1656     /// @dev start must be for the same day or 0, required for token cloning
1657     constructor(uint256 start) internal {
1658         // 0 is invalid value as we are past unix epoch
1659         if (start > 0) {
1660             uint256 base = dayBase(uint128(block.timestamp));
1661             // must be within current day base
1662             require(start >= base);
1663             // dayBase + 2**128 will not overflow as it is based on block.timestamp
1664             require(start < base + 2**128);
1665         }
1666     }
1667 
1668     ////////////////////////
1669     // Public functions
1670     ////////////////////////
1671 
1672     function snapshotAt(uint256 timestamp)
1673         public
1674         constant
1675         returns (uint256)
1676     {
1677         require(timestamp < MAX_TIMESTAMP);
1678 
1679         return dayBase(uint128(timestamp));
1680     }
1681 
1682     ////////////////////////
1683     // Internal functions
1684     ////////////////////////
1685 
1686     //
1687     // Implements MSnapshotPolicy
1688     //
1689 
1690     function mAdvanceSnapshotId()
1691         internal
1692         returns (uint256)
1693     {
1694         return mCurrentSnapshotId();
1695     }
1696 
1697     function mCurrentSnapshotId()
1698         internal
1699         constant
1700         returns (uint256)
1701     {
1702         // disregard overflows on block.timestamp, see MAX_TIMESTAMP
1703         return dayBase(uint128(block.timestamp));
1704     }
1705 
1706     function dayBase(uint128 timestamp)
1707         internal
1708         pure
1709         returns (uint256)
1710     {
1711         // Round down to the start of the day (00:00 UTC) and place in higher 128bits
1712         return 2**128 * (uint256(timestamp) / 1 days);
1713     }
1714 }
1715 
1716 /// @title creates snapshot id on each day boundary and allows to create additional snapshots within a given day
1717 /// @dev snapshots are encoded in single uint256, where high 128 bits represents a day number (from unix epoch) and low 128 bits represents additional snapshots within given day create via ISnapshotable
1718 contract DailyAndSnapshotable is
1719     Daily,
1720     ISnapshotable
1721 {
1722 
1723     ////////////////////////
1724     // Mutable state
1725     ////////////////////////
1726 
1727     uint256 private _currentSnapshotId;
1728 
1729     ////////////////////////
1730     // Constructor
1731     ////////////////////////
1732 
1733     /// @param start snapshotId from which to start generating values
1734     /// @dev start must be for the same day or 0, required for token cloning
1735     constructor(uint256 start)
1736         internal
1737         Daily(start)
1738     {
1739         if (start > 0) {
1740             _currentSnapshotId = start;
1741         }
1742     }
1743 
1744     ////////////////////////
1745     // Public functions
1746     ////////////////////////
1747 
1748     //
1749     // Implements ISnapshotable
1750     //
1751 
1752     function createSnapshot()
1753         public
1754         returns (uint256)
1755     {
1756         uint256 base = dayBase(uint128(block.timestamp));
1757 
1758         if (base > _currentSnapshotId) {
1759             // New day has started, create snapshot for midnight
1760             _currentSnapshotId = base;
1761         } else {
1762             // within single day, increase counter (assume 2**128 will not be crossed)
1763             _currentSnapshotId += 1;
1764         }
1765 
1766         // Log and return
1767         emit LogSnapshotCreated(_currentSnapshotId);
1768         return _currentSnapshotId;
1769     }
1770 
1771     ////////////////////////
1772     // Internal functions
1773     ////////////////////////
1774 
1775     //
1776     // Implements MSnapshotPolicy
1777     //
1778 
1779     function mAdvanceSnapshotId()
1780         internal
1781         returns (uint256)
1782     {
1783         uint256 base = dayBase(uint128(block.timestamp));
1784 
1785         // New day has started
1786         if (base > _currentSnapshotId) {
1787             _currentSnapshotId = base;
1788             emit LogSnapshotCreated(base);
1789         }
1790 
1791         return _currentSnapshotId;
1792     }
1793 
1794     function mCurrentSnapshotId()
1795         internal
1796         constant
1797         returns (uint256)
1798     {
1799         uint256 base = dayBase(uint128(block.timestamp));
1800 
1801         return base > _currentSnapshotId ? base : _currentSnapshotId;
1802     }
1803 }
1804 
1805 /// @title adds token metadata to token contract
1806 /// @dev see Neumark for example implementation
1807 contract TokenMetadata is ITokenMetadata {
1808 
1809     ////////////////////////
1810     // Immutable state
1811     ////////////////////////
1812 
1813     // The Token's name: e.g. DigixDAO Tokens
1814     string private NAME;
1815 
1816     // An identifier: e.g. REP
1817     string private SYMBOL;
1818 
1819     // Number of decimals of the smallest unit
1820     uint8 private DECIMALS;
1821 
1822     // An arbitrary versioning scheme
1823     string private VERSION;
1824 
1825     ////////////////////////
1826     // Constructor
1827     ////////////////////////
1828 
1829     /// @notice Constructor to set metadata
1830     /// @param tokenName Name of the new token
1831     /// @param decimalUnits Number of decimals of the new token
1832     /// @param tokenSymbol Token Symbol for the new token
1833     /// @param version Token version ie. when cloning is used
1834     constructor(
1835         string tokenName,
1836         uint8 decimalUnits,
1837         string tokenSymbol,
1838         string version
1839     )
1840         public
1841     {
1842         NAME = tokenName;                                 // Set the name
1843         SYMBOL = tokenSymbol;                             // Set the symbol
1844         DECIMALS = decimalUnits;                          // Set the decimals
1845         VERSION = version;
1846     }
1847 
1848     ////////////////////////
1849     // Public functions
1850     ////////////////////////
1851 
1852     function name()
1853         public
1854         constant
1855         returns (string)
1856     {
1857         return NAME;
1858     }
1859 
1860     function symbol()
1861         public
1862         constant
1863         returns (string)
1864     {
1865         return SYMBOL;
1866     }
1867 
1868     function decimals()
1869         public
1870         constant
1871         returns (uint8)
1872     {
1873         return DECIMALS;
1874     }
1875 
1876     function version()
1877         public
1878         constant
1879         returns (string)
1880     {
1881         return VERSION;
1882     }
1883 }
1884 
1885 /// @title controls spending approvals
1886 /// @dev TokenAllowance observes this interface, Neumark contract implements it
1887 contract MTokenAllowanceController {
1888 
1889     ////////////////////////
1890     // Internal functions
1891     ////////////////////////
1892 
1893     /// @notice Notifies the controller about an approval allowing the
1894     ///  controller to react if desired
1895     /// @param owner The address that calls `approve()`
1896     /// @param spender The spender in the `approve()` call
1897     /// @param amount The amount in the `approve()` call
1898     /// @return False if the controller does not authorize the approval
1899     function mOnApprove(
1900         address owner,
1901         address spender,
1902         uint256 amount
1903     )
1904         internal
1905         returns (bool allow);
1906 
1907     /// @notice Allows to override allowance approved by the owner
1908     ///         Primary role is to enable forced transfers, do not override if you do not like it
1909     ///         Following behavior is expected in the observer
1910     ///         approve() - should revert if mAllowanceOverride() > 0
1911     ///         allowance() - should return mAllowanceOverride() if set
1912     ///         transferFrom() - should override allowance if mAllowanceOverride() > 0
1913     /// @param owner An address giving allowance to spender
1914     /// @param spender An address getting  a right to transfer allowance amount from the owner
1915     /// @return current allowance amount
1916     function mAllowanceOverride(
1917         address owner,
1918         address spender
1919     )
1920         internal
1921         constant
1922         returns (uint256 allowance);
1923 }
1924 
1925 /// @title controls token transfers
1926 /// @dev BasicSnapshotToken observes this interface, Neumark contract implements it
1927 contract MTokenTransferController {
1928 
1929     ////////////////////////
1930     // Internal functions
1931     ////////////////////////
1932 
1933     /// @notice Notifies the controller about a token transfer allowing the
1934     ///  controller to react if desired
1935     /// @param from The origin of the transfer
1936     /// @param to The destination of the transfer
1937     /// @param amount The amount of the transfer
1938     /// @return False if the controller does not authorize the transfer
1939     function mOnTransfer(
1940         address from,
1941         address to,
1942         uint256 amount
1943     )
1944         internal
1945         returns (bool allow);
1946 
1947 }
1948 
1949 /// @title controls approvals and transfers
1950 /// @dev The token controller contract must implement these functions, see Neumark as example
1951 /// @dev please note that controller may be a separate contract that is called from mOnTransfer and mOnApprove functions
1952 contract MTokenController is MTokenTransferController, MTokenAllowanceController {
1953 }
1954 
1955 /// @title internal token transfer function
1956 /// @dev see BasicSnapshotToken for implementation
1957 contract MTokenTransfer {
1958 
1959     ////////////////////////
1960     // Internal functions
1961     ////////////////////////
1962 
1963     /// @dev This is the actual transfer function in the token contract, it can
1964     ///  only be called by other functions in this contract.
1965     /// @param from The address holding the tokens being transferred
1966     /// @param to The address of the recipient
1967     /// @param amount The amount of tokens to be transferred
1968     /// @dev  reverts if transfer was not successful
1969     function mTransfer(
1970         address from,
1971         address to,
1972         uint256 amount
1973     )
1974         internal;
1975 }
1976 
1977 contract IERC677Callback {
1978 
1979     ////////////////////////
1980     // Public functions
1981     ////////////////////////
1982 
1983     // NOTE: This call can be initiated by anyone. You need to make sure that
1984     // it is send by the token (`require(msg.sender == token)`) or make sure
1985     // amount is valid (`require(token.allowance(this) >= amount)`).
1986     function receiveApproval(
1987         address from,
1988         uint256 amount,
1989         address token, // IERC667Token
1990         bytes data
1991     )
1992         public
1993         returns (bool success);
1994 
1995 }
1996 
1997 /// @title token spending approval and transfer
1998 /// @dev implements token approval and transfers and exposes relevant part of ERC20 and ERC677 approveAndCall
1999 ///     may be mixed in with any basic token (implementing mTransfer) like BasicSnapshotToken or MintableSnapshotToken to add approval mechanism
2000 ///     observes MTokenAllowanceController interface
2001 ///     observes MTokenTransfer
2002 contract TokenAllowance is
2003     MTokenTransfer,
2004     MTokenAllowanceController,
2005     IERC20Allowance,
2006     IERC677Token
2007 {
2008 
2009     ////////////////////////
2010     // Mutable state
2011     ////////////////////////
2012 
2013     // `allowed` tracks rights to spends others tokens as per ERC20
2014     // owner => spender => amount
2015     mapping (address => mapping (address => uint256)) private _allowed;
2016 
2017     ////////////////////////
2018     // Constructor
2019     ////////////////////////
2020 
2021     constructor()
2022         internal
2023     {
2024     }
2025 
2026     ////////////////////////
2027     // Public functions
2028     ////////////////////////
2029 
2030     //
2031     // Implements IERC20Token
2032     //
2033 
2034     /// @dev This function makes it easy to read the `allowed[]` map
2035     /// @param owner The address of the account that owns the token
2036     /// @param spender The address of the account able to transfer the tokens
2037     /// @return Amount of remaining tokens of _owner that _spender is allowed
2038     ///  to spend
2039     function allowance(address owner, address spender)
2040         public
2041         constant
2042         returns (uint256 remaining)
2043     {
2044         uint256 override = mAllowanceOverride(owner, spender);
2045         if (override > 0) {
2046             return override;
2047         }
2048         return _allowed[owner][spender];
2049     }
2050 
2051     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
2052     ///  its behalf. This is a modified version of the ERC20 approve function
2053     ///  where allowance per spender must be 0 to allow change of such allowance
2054     /// @param spender The address of the account able to transfer the tokens
2055     /// @param amount The amount of tokens to be approved for transfer
2056     /// @return True or reverts, False is never returned
2057     function approve(address spender, uint256 amount)
2058         public
2059         returns (bool success)
2060     {
2061         // Alerts the token controller of the approve function call
2062         require(mOnApprove(msg.sender, spender, amount));
2063 
2064         // To change the approve amount you first have to reduce the addresses`
2065         //  allowance to zero by calling `approve(_spender,0)` if it is not
2066         //  already 0 to mitigate the race condition described here:
2067         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2068         require((amount == 0 || _allowed[msg.sender][spender] == 0) && mAllowanceOverride(msg.sender, spender) == 0);
2069 
2070         _allowed[msg.sender][spender] = amount;
2071         emit Approval(msg.sender, spender, amount);
2072         return true;
2073     }
2074 
2075     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
2076     ///  is approved by `_from`
2077     /// @param from The address holding the tokens being transferred
2078     /// @param to The address of the recipient
2079     /// @param amount The amount of tokens to be transferred
2080     /// @return True if the transfer was successful, reverts in any other case
2081     function transferFrom(address from, address to, uint256 amount)
2082         public
2083         returns (bool success)
2084     {
2085         uint256 allowed = mAllowanceOverride(from, msg.sender);
2086         if (allowed == 0) {
2087             // The standard ERC 20 transferFrom functionality
2088             allowed = _allowed[from][msg.sender];
2089             // yes this will underflow but then we'll revert. will cost gas however so don't underflow
2090             _allowed[from][msg.sender] -= amount;
2091         }
2092         require(allowed >= amount);
2093         mTransfer(from, to, amount);
2094         return true;
2095     }
2096 
2097     //
2098     // Implements IERC677Token
2099     //
2100 
2101     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
2102     ///  its behalf, and then a function is triggered in the contract that is
2103     ///  being approved, `_spender`. This allows users to use their tokens to
2104     ///  interact with contracts in one function call instead of two
2105     /// @param spender The address of the contract able to transfer the tokens
2106     /// @param amount The amount of tokens to be approved for transfer
2107     /// @return True or reverts, False is never returned
2108     function approveAndCall(
2109         address spender,
2110         uint256 amount,
2111         bytes extraData
2112     )
2113         public
2114         returns (bool success)
2115     {
2116         require(approve(spender, amount));
2117 
2118         success = IERC677Callback(spender).receiveApproval(
2119             msg.sender,
2120             amount,
2121             this,
2122             extraData
2123         );
2124         require(success);
2125 
2126         return true;
2127     }
2128 
2129     ////////////////////////
2130     // Internal functions
2131     ////////////////////////
2132 
2133     //
2134     // Implements default MTokenAllowanceController
2135     //
2136 
2137     // no override in default implementation
2138     function mAllowanceOverride(
2139         address /*owner*/,
2140         address /*spender*/
2141     )
2142         internal
2143         constant
2144         returns (uint256)
2145     {
2146         return 0;
2147     }
2148 }
2149 
2150 /// @title Reads and writes snapshots
2151 /// @dev Manages reading and writing a series of values, where each value has assigned a snapshot id for access to historical data
2152 /// @dev may be added to any contract to provide snapshotting mechanism. should be mixed in with any of MSnapshotPolicy implementations to customize snapshot creation mechanics
2153 ///     observes MSnapshotPolicy
2154 /// based on MiniMe token
2155 contract Snapshot is MSnapshotPolicy {
2156 
2157     ////////////////////////
2158     // Types
2159     ////////////////////////
2160 
2161     /// @dev `Values` is the structure that attaches a snapshot id to a
2162     ///  given value, the snapshot id attached is the one that last changed the
2163     ///  value
2164     struct Values {
2165 
2166         // `snapshotId` is the snapshot id that the value was generated at
2167         uint256 snapshotId;
2168 
2169         // `value` at a specific snapshot id
2170         uint256 value;
2171     }
2172 
2173     ////////////////////////
2174     // Internal functions
2175     ////////////////////////
2176 
2177     function hasValue(
2178         Values[] storage values
2179     )
2180         internal
2181         constant
2182         returns (bool)
2183     {
2184         return values.length > 0;
2185     }
2186 
2187     /// @dev makes sure that 'snapshotId' between current snapshot id (mCurrentSnapshotId) and first snapshot id. this guarantees that getValueAt returns value from one of the snapshots.
2188     function hasValueAt(
2189         Values[] storage values,
2190         uint256 snapshotId
2191     )
2192         internal
2193         constant
2194         returns (bool)
2195     {
2196         require(snapshotId <= mCurrentSnapshotId());
2197         return values.length > 0 && values[0].snapshotId <= snapshotId;
2198     }
2199 
2200     /// gets last value in the series
2201     function getValue(
2202         Values[] storage values,
2203         uint256 defaultValue
2204     )
2205         internal
2206         constant
2207         returns (uint256)
2208     {
2209         if (values.length == 0) {
2210             return defaultValue;
2211         } else {
2212             uint256 last = values.length - 1;
2213             return values[last].value;
2214         }
2215     }
2216 
2217     /// @dev `getValueAt` retrieves value at a given snapshot id
2218     /// @param values The series of values being queried
2219     /// @param snapshotId Snapshot id to retrieve the value at
2220     /// @return Value in series being queried
2221     function getValueAt(
2222         Values[] storage values,
2223         uint256 snapshotId,
2224         uint256 defaultValue
2225     )
2226         internal
2227         constant
2228         returns (uint256)
2229     {
2230         require(snapshotId <= mCurrentSnapshotId());
2231 
2232         // Empty value
2233         if (values.length == 0) {
2234             return defaultValue;
2235         }
2236 
2237         // Shortcut for the out of bounds snapshots
2238         uint256 last = values.length - 1;
2239         uint256 lastSnapshot = values[last].snapshotId;
2240         if (snapshotId >= lastSnapshot) {
2241             return values[last].value;
2242         }
2243         uint256 firstSnapshot = values[0].snapshotId;
2244         if (snapshotId < firstSnapshot) {
2245             return defaultValue;
2246         }
2247         // Binary search of the value in the array
2248         uint256 min = 0;
2249         uint256 max = last;
2250         while (max > min) {
2251             uint256 mid = (max + min + 1) / 2;
2252             // must always return lower indice for approximate searches
2253             if (values[mid].snapshotId <= snapshotId) {
2254                 min = mid;
2255             } else {
2256                 max = mid - 1;
2257             }
2258         }
2259         return values[min].value;
2260     }
2261 
2262     /// @dev `setValue` used to update sequence at next snapshot
2263     /// @param values The sequence being updated
2264     /// @param value The new last value of sequence
2265     function setValue(
2266         Values[] storage values,
2267         uint256 value
2268     )
2269         internal
2270     {
2271         // TODO: simplify or break into smaller functions
2272 
2273         uint256 currentSnapshotId = mAdvanceSnapshotId();
2274         // Always create a new entry if there currently is no value
2275         bool empty = values.length == 0;
2276         if (empty) {
2277             // Create a new entry
2278             values.push(
2279                 Values({
2280                     snapshotId: currentSnapshotId,
2281                     value: value
2282                 })
2283             );
2284             return;
2285         }
2286 
2287         uint256 last = values.length - 1;
2288         bool hasNewSnapshot = values[last].snapshotId < currentSnapshotId;
2289         if (hasNewSnapshot) {
2290 
2291             // Do nothing if the value was not modified
2292             bool unmodified = values[last].value == value;
2293             if (unmodified) {
2294                 return;
2295             }
2296 
2297             // Create new entry
2298             values.push(
2299                 Values({
2300                     snapshotId: currentSnapshotId,
2301                     value: value
2302                 })
2303             );
2304         } else {
2305 
2306             // We are updating the currentSnapshotId
2307             bool previousUnmodified = last > 0 && values[last - 1].value == value;
2308             if (previousUnmodified) {
2309                 // Remove current snapshot if current value was set to previous value
2310                 delete values[last];
2311                 values.length--;
2312                 return;
2313             }
2314 
2315             // Overwrite next snapshot entry
2316             values[last].value = value;
2317         }
2318     }
2319 }
2320 
2321 /// @title token with snapshots and transfer functionality
2322 /// @dev observes MTokenTransferController interface
2323 ///     observes ISnapshotToken interface
2324 ///     implementes MTokenTransfer interface
2325 contract BasicSnapshotToken is
2326     MTokenTransfer,
2327     MTokenTransferController,
2328     IClonedTokenParent,
2329     IBasicToken,
2330     Snapshot
2331 {
2332     ////////////////////////
2333     // Immutable state
2334     ////////////////////////
2335 
2336     // `PARENT_TOKEN` is the Token address that was cloned to produce this token;
2337     //  it will be 0x0 for a token that was not cloned
2338     IClonedTokenParent private PARENT_TOKEN;
2339 
2340     // `PARENT_SNAPSHOT_ID` is the snapshot id from the Parent Token that was
2341     //  used to determine the initial distribution of the cloned token
2342     uint256 private PARENT_SNAPSHOT_ID;
2343 
2344     ////////////////////////
2345     // Mutable state
2346     ////////////////////////
2347 
2348     // `balances` is the map that tracks the balance of each address, in this
2349     //  contract when the balance changes the snapshot id that the change
2350     //  occurred is also included in the map
2351     mapping (address => Values[]) internal _balances;
2352 
2353     // Tracks the history of the `totalSupply` of the token
2354     Values[] internal _totalSupplyValues;
2355 
2356     ////////////////////////
2357     // Constructor
2358     ////////////////////////
2359 
2360     /// @notice Constructor to create snapshot token
2361     /// @param parentToken Address of the parent token, set to 0x0 if it is a
2362     ///  new token
2363     /// @param parentSnapshotId at which snapshot id clone was created, set to 0 to clone at upper bound
2364     /// @dev please not that as long as cloned token does not overwrite value at current snapshot id, it will refer
2365     ///     to parent token at which this snapshot still may change until snapshot id increases. for that time tokens are coupled
2366     ///     this is prevented by parentSnapshotId value of parentToken.currentSnapshotId() - 1 being the maxiumum
2367     ///     see SnapshotToken.js test to learn consequences coupling has.
2368     constructor(
2369         IClonedTokenParent parentToken,
2370         uint256 parentSnapshotId
2371     )
2372         Snapshot()
2373         internal
2374     {
2375         PARENT_TOKEN = parentToken;
2376         if (parentToken == address(0)) {
2377             require(parentSnapshotId == 0);
2378         } else {
2379             if (parentSnapshotId == 0) {
2380                 require(parentToken.currentSnapshotId() > 0);
2381                 PARENT_SNAPSHOT_ID = parentToken.currentSnapshotId() - 1;
2382             } else {
2383                 PARENT_SNAPSHOT_ID = parentSnapshotId;
2384             }
2385         }
2386     }
2387 
2388     ////////////////////////
2389     // Public functions
2390     ////////////////////////
2391 
2392     //
2393     // Implements IBasicToken
2394     //
2395 
2396     /// @dev This function makes it easy to get the total number of tokens
2397     /// @return The total number of tokens
2398     function totalSupply()
2399         public
2400         constant
2401         returns (uint256)
2402     {
2403         return totalSupplyAtInternal(mCurrentSnapshotId());
2404     }
2405 
2406     /// @param owner The address that's balance is being requested
2407     /// @return The balance of `owner` at the current block
2408     function balanceOf(address owner)
2409         public
2410         constant
2411         returns (uint256 balance)
2412     {
2413         return balanceOfAtInternal(owner, mCurrentSnapshotId());
2414     }
2415 
2416     /// @notice Send `amount` tokens to `to` from `msg.sender`
2417     /// @param to The address of the recipient
2418     /// @param amount The amount of tokens to be transferred
2419     /// @return True if the transfer was successful, reverts in any other case
2420     function transfer(address to, uint256 amount)
2421         public
2422         returns (bool success)
2423     {
2424         mTransfer(msg.sender, to, amount);
2425         return true;
2426     }
2427 
2428     //
2429     // Implements ITokenSnapshots
2430     //
2431 
2432     function totalSupplyAt(uint256 snapshotId)
2433         public
2434         constant
2435         returns(uint256)
2436     {
2437         return totalSupplyAtInternal(snapshotId);
2438     }
2439 
2440     function balanceOfAt(address owner, uint256 snapshotId)
2441         public
2442         constant
2443         returns (uint256)
2444     {
2445         return balanceOfAtInternal(owner, snapshotId);
2446     }
2447 
2448     function currentSnapshotId()
2449         public
2450         constant
2451         returns (uint256)
2452     {
2453         return mCurrentSnapshotId();
2454     }
2455 
2456     //
2457     // Implements IClonedTokenParent
2458     //
2459 
2460     function parentToken()
2461         public
2462         constant
2463         returns(IClonedTokenParent parent)
2464     {
2465         return PARENT_TOKEN;
2466     }
2467 
2468     /// @return snapshot at wchich initial token distribution was taken
2469     function parentSnapshotId()
2470         public
2471         constant
2472         returns(uint256 snapshotId)
2473     {
2474         return PARENT_SNAPSHOT_ID;
2475     }
2476 
2477     //
2478     // Other public functions
2479     //
2480 
2481     /// @notice gets all token balances of 'owner'
2482     /// @dev intended to be called via eth_call where gas limit is not an issue
2483     function allBalancesOf(address owner)
2484         external
2485         constant
2486         returns (uint256[2][])
2487     {
2488         /* very nice and working implementation below,
2489         // copy to memory
2490         Values[] memory values = _balances[owner];
2491         do assembly {
2492             // in memory structs have simple layout where every item occupies uint256
2493             balances := values
2494         } while (false);*/
2495 
2496         Values[] storage values = _balances[owner];
2497         uint256[2][] memory balances = new uint256[2][](values.length);
2498         for(uint256 ii = 0; ii < values.length; ++ii) {
2499             balances[ii] = [values[ii].snapshotId, values[ii].value];
2500         }
2501 
2502         return balances;
2503     }
2504 
2505     ////////////////////////
2506     // Internal functions
2507     ////////////////////////
2508 
2509     function totalSupplyAtInternal(uint256 snapshotId)
2510         internal
2511         constant
2512         returns(uint256)
2513     {
2514         Values[] storage values = _totalSupplyValues;
2515 
2516         // If there is a value, return it, reverts if value is in the future
2517         if (hasValueAt(values, snapshotId)) {
2518             return getValueAt(values, snapshotId, 0);
2519         }
2520 
2521         // Try parent contract at or before the fork
2522         if (address(PARENT_TOKEN) != 0) {
2523             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
2524             return PARENT_TOKEN.totalSupplyAt(earlierSnapshotId);
2525         }
2526 
2527         // Default to an empty balance
2528         return 0;
2529     }
2530 
2531     // get balance at snapshot if with continuation in parent token
2532     function balanceOfAtInternal(address owner, uint256 snapshotId)
2533         internal
2534         constant
2535         returns (uint256)
2536     {
2537         Values[] storage values = _balances[owner];
2538 
2539         // If there is a value, return it, reverts if value is in the future
2540         if (hasValueAt(values, snapshotId)) {
2541             return getValueAt(values, snapshotId, 0);
2542         }
2543 
2544         // Try parent contract at or before the fork
2545         if (PARENT_TOKEN != address(0)) {
2546             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
2547             return PARENT_TOKEN.balanceOfAt(owner, earlierSnapshotId);
2548         }
2549 
2550         // Default to an empty balance
2551         return 0;
2552     }
2553 
2554     //
2555     // Implements MTokenTransfer
2556     //
2557 
2558     /// @dev This is the actual transfer function in the token contract, it can
2559     ///  only be called by other functions in this contract.
2560     /// @param from The address holding the tokens being transferred
2561     /// @param to The address of the recipient
2562     /// @param amount The amount of tokens to be transferred
2563     /// @return True if the transfer was successful, reverts in any other case
2564     function mTransfer(
2565         address from,
2566         address to,
2567         uint256 amount
2568     )
2569         internal
2570     {
2571         // never send to address 0
2572         require(to != address(0));
2573         // block transfers in clone that points to future/current snapshots of parent token
2574         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2575         // Alerts the token controller of the transfer
2576         require(mOnTransfer(from, to, amount));
2577 
2578         // If the amount being transfered is more than the balance of the
2579         //  account the transfer reverts
2580         uint256 previousBalanceFrom = balanceOf(from);
2581         require(previousBalanceFrom >= amount);
2582 
2583         // First update the balance array with the new value for the address
2584         //  sending the tokens
2585         uint256 newBalanceFrom = previousBalanceFrom - amount;
2586         setValue(_balances[from], newBalanceFrom);
2587 
2588         // Then update the balance array with the new value for the address
2589         //  receiving the tokens
2590         uint256 previousBalanceTo = balanceOf(to);
2591         uint256 newBalanceTo = previousBalanceTo + amount;
2592         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
2593         setValue(_balances[to], newBalanceTo);
2594 
2595         // An event to make the transfer easy to find on the blockchain
2596         emit Transfer(from, to, amount);
2597     }
2598 }
2599 
2600 /// @title token generation and destruction
2601 /// @dev internal interface providing token generation and destruction, see MintableSnapshotToken for implementation
2602 contract MTokenMint {
2603 
2604     ////////////////////////
2605     // Internal functions
2606     ////////////////////////
2607 
2608     /// @notice Generates `amount` tokens that are assigned to `owner`
2609     /// @param owner The address that will be assigned the new tokens
2610     /// @param amount The quantity of tokens generated
2611     /// @dev reverts if tokens could not be generated
2612     function mGenerateTokens(address owner, uint256 amount)
2613         internal;
2614 
2615     /// @notice Burns `amount` tokens from `owner`
2616     /// @param owner The address that will lose the tokens
2617     /// @param amount The quantity of tokens to burn
2618     /// @dev reverts if tokens could not be destroyed
2619     function mDestroyTokens(address owner, uint256 amount)
2620         internal;
2621 }
2622 
2623 /// @title basic snapshot token with facitilites to generate and destroy tokens
2624 /// @dev implementes MTokenMint, does not expose any public functions that create/destroy tokens
2625 contract MintableSnapshotToken is
2626     BasicSnapshotToken,
2627     MTokenMint
2628 {
2629 
2630     ////////////////////////
2631     // Constructor
2632     ////////////////////////
2633 
2634     /// @notice Constructor to create a MintableSnapshotToken
2635     /// @param parentToken Address of the parent token, set to 0x0 if it is a
2636     ///  new token
2637     constructor(
2638         IClonedTokenParent parentToken,
2639         uint256 parentSnapshotId
2640     )
2641         BasicSnapshotToken(parentToken, parentSnapshotId)
2642         internal
2643     {}
2644 
2645     /// @notice Generates `amount` tokens that are assigned to `owner`
2646     /// @param owner The address that will be assigned the new tokens
2647     /// @param amount The quantity of tokens generated
2648     function mGenerateTokens(address owner, uint256 amount)
2649         internal
2650     {
2651         // never create for address 0
2652         require(owner != address(0));
2653         // block changes in clone that points to future/current snapshots of patent token
2654         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2655 
2656         uint256 curTotalSupply = totalSupply();
2657         uint256 newTotalSupply = curTotalSupply + amount;
2658         require(newTotalSupply >= curTotalSupply); // Check for overflow
2659 
2660         uint256 previousBalanceTo = balanceOf(owner);
2661         uint256 newBalanceTo = previousBalanceTo + amount;
2662         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
2663 
2664         setValue(_totalSupplyValues, newTotalSupply);
2665         setValue(_balances[owner], newBalanceTo);
2666 
2667         emit Transfer(0, owner, amount);
2668     }
2669 
2670     /// @notice Burns `amount` tokens from `owner`
2671     /// @param owner The address that will lose the tokens
2672     /// @param amount The quantity of tokens to burn
2673     function mDestroyTokens(address owner, uint256 amount)
2674         internal
2675     {
2676         // block changes in clone that points to future/current snapshots of patent token
2677         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2678 
2679         uint256 curTotalSupply = totalSupply();
2680         require(curTotalSupply >= amount);
2681 
2682         uint256 previousBalanceFrom = balanceOf(owner);
2683         require(previousBalanceFrom >= amount);
2684 
2685         uint256 newTotalSupply = curTotalSupply - amount;
2686         uint256 newBalanceFrom = previousBalanceFrom - amount;
2687         setValue(_totalSupplyValues, newTotalSupply);
2688         setValue(_balances[owner], newBalanceFrom);
2689 
2690         emit Transfer(owner, 0, amount);
2691     }
2692 }
2693 
2694 /*
2695     Copyright 2016, Jordi Baylina
2696     Copyright 2017, Remco Bloemen, Marcin Rudolf
2697 
2698     This program is free software: you can redistribute it and/or modify
2699     it under the terms of the GNU General Public License as published by
2700     the Free Software Foundation, either version 3 of the License, or
2701     (at your option) any later version.
2702 
2703     This program is distributed in the hope that it will be useful,
2704     but WITHOUT ANY WARRANTY; without even the implied warranty of
2705     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2706     GNU General Public License for more details.
2707 
2708     You should have received a copy of the GNU General Public License
2709     along with this program.  If not, see <http://www.gnu.org/licenses/>.
2710  */
2711 /// @title StandardSnapshotToken Contract
2712 /// @author Jordi Baylina, Remco Bloemen, Marcin Rudolf
2713 /// @dev This token contract's goal is to make it easy for anyone to clone this
2714 ///  token using the token distribution at a given block, this will allow DAO's
2715 ///  and DApps to upgrade their features in a decentralized manner without
2716 ///  affecting the original token
2717 /// @dev It is ERC20 compliant, but still needs to under go further testing.
2718 /// @dev Various contracts are composed to provide required functionality of this token, different compositions are possible
2719 ///     MintableSnapshotToken provides transfer, miniting and snapshotting functions
2720 ///     TokenAllowance provides approve/transferFrom functions
2721 ///     TokenMetadata adds name, symbol and other token metadata
2722 /// @dev This token is still abstract, Snapshot, BasicSnapshotToken and TokenAllowance observe interfaces that must be implemented
2723 ///     MSnapshotPolicy - particular snapshot id creation mechanism
2724 ///     MTokenController - controlls approvals and transfers
2725 ///     see Neumark as an example
2726 /// @dev implements ERC223 token transfer
2727 contract StandardSnapshotToken is
2728     MintableSnapshotToken,
2729     TokenAllowance
2730 {
2731     ////////////////////////
2732     // Constructor
2733     ////////////////////////
2734 
2735     /// @notice Constructor to create a MiniMeToken
2736     ///  is a new token
2737     /// param tokenName Name of the new token
2738     /// param decimalUnits Number of decimals of the new token
2739     /// param tokenSymbol Token Symbol for the new token
2740     constructor(
2741         IClonedTokenParent parentToken,
2742         uint256 parentSnapshotId
2743     )
2744         MintableSnapshotToken(parentToken, parentSnapshotId)
2745         TokenAllowance()
2746         internal
2747     {}
2748 }
2749 
2750 /// @title old ERC223 callback function
2751 /// @dev as used in Neumark and ICBMEtherToken
2752 contract IERC223LegacyCallback {
2753 
2754     ////////////////////////
2755     // Public functions
2756     ////////////////////////
2757 
2758     function onTokenTransfer(address from, uint256 amount, bytes data)
2759         public;
2760 
2761 }
2762 
2763 contract Neumark is
2764     AccessControlled,
2765     AccessRoles,
2766     Agreement,
2767     DailyAndSnapshotable,
2768     StandardSnapshotToken,
2769     TokenMetadata,
2770     IERC223Token,
2771     NeumarkIssuanceCurve,
2772     Reclaimable,
2773     IsContract
2774 {
2775 
2776     ////////////////////////
2777     // Constants
2778     ////////////////////////
2779 
2780     string private constant TOKEN_NAME = "Neumark";
2781 
2782     uint8  private constant TOKEN_DECIMALS = 18;
2783 
2784     string private constant TOKEN_SYMBOL = "NEU";
2785 
2786     string private constant VERSION = "NMK_1.0";
2787 
2788     ////////////////////////
2789     // Mutable state
2790     ////////////////////////
2791 
2792     // disable transfers when Neumark is created
2793     bool private _transferEnabled = false;
2794 
2795     // at which point on curve new Neumarks will be created, see NeumarkIssuanceCurve contract
2796     // do not use to get total invested funds. see burn(). this is just a cache for expensive inverse function
2797     uint256 private _totalEurUlps;
2798 
2799     ////////////////////////
2800     // Events
2801     ////////////////////////
2802 
2803     event LogNeumarksIssued(
2804         address indexed owner,
2805         uint256 euroUlps,
2806         uint256 neumarkUlps
2807     );
2808 
2809     event LogNeumarksBurned(
2810         address indexed owner,
2811         uint256 euroUlps,
2812         uint256 neumarkUlps
2813     );
2814 
2815     ////////////////////////
2816     // Constructor
2817     ////////////////////////
2818 
2819     constructor(
2820         IAccessPolicy accessPolicy,
2821         IEthereumForkArbiter forkArbiter
2822     )
2823         AccessRoles()
2824         Agreement(accessPolicy, forkArbiter)
2825         StandardSnapshotToken(
2826             IClonedTokenParent(0x0),
2827             0
2828         )
2829         TokenMetadata(
2830             TOKEN_NAME,
2831             TOKEN_DECIMALS,
2832             TOKEN_SYMBOL,
2833             VERSION
2834         )
2835         DailyAndSnapshotable(0)
2836         NeumarkIssuanceCurve()
2837         Reclaimable()
2838         public
2839     {}
2840 
2841     ////////////////////////
2842     // Public functions
2843     ////////////////////////
2844 
2845     /// @notice issues new Neumarks to msg.sender with reward at current curve position
2846     ///     moves curve position by euroUlps
2847     ///     callable only by ROLE_NEUMARK_ISSUER
2848     function issueForEuro(uint256 euroUlps)
2849         public
2850         only(ROLE_NEUMARK_ISSUER)
2851         acceptAgreement(msg.sender)
2852         returns (uint256)
2853     {
2854         require(_totalEurUlps + euroUlps >= _totalEurUlps);
2855         uint256 neumarkUlps = incremental(_totalEurUlps, euroUlps);
2856         _totalEurUlps += euroUlps;
2857         mGenerateTokens(msg.sender, neumarkUlps);
2858         emit LogNeumarksIssued(msg.sender, euroUlps, neumarkUlps);
2859         return neumarkUlps;
2860     }
2861 
2862     /// @notice used by ROLE_NEUMARK_ISSUER to transer newly issued neumarks
2863     ///     typically to the investor and platform operator
2864     function distribute(address to, uint256 neumarkUlps)
2865         public
2866         only(ROLE_NEUMARK_ISSUER)
2867         acceptAgreement(to)
2868     {
2869         mTransfer(msg.sender, to, neumarkUlps);
2870     }
2871 
2872     /// @notice msg.sender can burn their Neumarks, curve is rolled back using inverse
2873     ///     curve. as a result cost of Neumark gets lower (reward is higher)
2874     function burn(uint256 neumarkUlps)
2875         public
2876         only(ROLE_NEUMARK_BURNER)
2877     {
2878         burnPrivate(neumarkUlps, 0, _totalEurUlps);
2879     }
2880 
2881     /// @notice executes as function above but allows to provide search range for low gas burning
2882     function burn(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2883         public
2884         only(ROLE_NEUMARK_BURNER)
2885     {
2886         burnPrivate(neumarkUlps, minEurUlps, maxEurUlps);
2887     }
2888 
2889     function enableTransfer(bool enabled)
2890         public
2891         only(ROLE_TRANSFER_ADMIN)
2892     {
2893         _transferEnabled = enabled;
2894     }
2895 
2896     function createSnapshot()
2897         public
2898         only(ROLE_SNAPSHOT_CREATOR)
2899         returns (uint256)
2900     {
2901         return DailyAndSnapshotable.createSnapshot();
2902     }
2903 
2904     function transferEnabled()
2905         public
2906         constant
2907         returns (bool)
2908     {
2909         return _transferEnabled;
2910     }
2911 
2912     function totalEuroUlps()
2913         public
2914         constant
2915         returns (uint256)
2916     {
2917         return _totalEurUlps;
2918     }
2919 
2920     function incremental(uint256 euroUlps)
2921         public
2922         constant
2923         returns (uint256 neumarkUlps)
2924     {
2925         return incremental(_totalEurUlps, euroUlps);
2926     }
2927 
2928     //
2929     // Implements IERC223Token with IERC223Callback (onTokenTransfer) callback
2930     //
2931 
2932     // old implementation of ERC223 that was actual when ICBM was deployed
2933     // as Neumark is already deployed this function keeps old behavior for testing
2934     function transfer(address to, uint256 amount, bytes data)
2935         public
2936         returns (bool)
2937     {
2938         // it is necessary to point out implementation to be called
2939         BasicSnapshotToken.mTransfer(msg.sender, to, amount);
2940 
2941         // Notify the receiving contract.
2942         if (isContract(to)) {
2943             IERC223LegacyCallback(to).onTokenTransfer(msg.sender, amount, data);
2944         }
2945         return true;
2946     }
2947 
2948     ////////////////////////
2949     // Internal functions
2950     ////////////////////////
2951 
2952     //
2953     // Implements MTokenController
2954     //
2955 
2956     function mOnTransfer(
2957         address from,
2958         address, // to
2959         uint256 // amount
2960     )
2961         internal
2962         acceptAgreement(from)
2963         returns (bool allow)
2964     {
2965         // must have transfer enabled or msg.sender is Neumark issuer
2966         return _transferEnabled || accessPolicy().allowed(msg.sender, ROLE_NEUMARK_ISSUER, this, msg.sig);
2967     }
2968 
2969     function mOnApprove(
2970         address owner,
2971         address, // spender,
2972         uint256 // amount
2973     )
2974         internal
2975         acceptAgreement(owner)
2976         returns (bool allow)
2977     {
2978         return true;
2979     }
2980 
2981     ////////////////////////
2982     // Private functions
2983     ////////////////////////
2984 
2985     function burnPrivate(uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2986         private
2987     {
2988         uint256 prevEuroUlps = _totalEurUlps;
2989         // burn first in the token to make sure balance/totalSupply is not crossed
2990         mDestroyTokens(msg.sender, burnNeumarkUlps);
2991         _totalEurUlps = cumulativeInverse(totalSupply(), minEurUlps, maxEurUlps);
2992         // actually may overflow on non-monotonic inverse
2993         assert(prevEuroUlps >= _totalEurUlps);
2994         uint256 euroUlps = prevEuroUlps - _totalEurUlps;
2995         emit LogNeumarksBurned(msg.sender, euroUlps, burnNeumarkUlps);
2996     }
2997 }
2998 
2999 /// @title disburse payment token amount to snapshot token holders
3000 /// @dev payment token received via ERC223 Transfer
3001 contract IFeeDisbursal is IERC223Callback {
3002     // TODO: declare interface
3003 }
3004 
3005 /// @title disburse payment token amount to snapshot token holders
3006 /// @dev payment token received via ERC223 Transfer
3007 contract IPlatformPortfolio is IERC223Callback {
3008     // TODO: declare interface
3009 }
3010 
3011 contract ITokenExchangeRateOracle {
3012     /// @notice provides actual price of 'numeratorToken' in 'denominatorToken'
3013     ///     returns timestamp at which price was obtained in oracle
3014     function getExchangeRate(address numeratorToken, address denominatorToken)
3015         public
3016         constant
3017         returns (uint256 rateFraction, uint256 timestamp);
3018 
3019     /// @notice allows to retreive multiple exchange rates in once call
3020     function getExchangeRates(address[] numeratorTokens, address[] denominatorTokens)
3021         public
3022         constant
3023         returns (uint256[] rateFractions, uint256[] timestamps);
3024 }
3025 
3026 /// @title root of trust and singletons + known interface registry
3027 /// provides a root which holds all interfaces platform trust, this includes
3028 /// singletons - for which accessors are provided
3029 /// collections of known instances of interfaces
3030 /// @dev interfaces are identified by bytes4, see KnownInterfaces.sol
3031 contract Universe is
3032     Agreement,
3033     IContractId,
3034     KnownInterfaces
3035 {
3036     ////////////////////////
3037     // Events
3038     ////////////////////////
3039 
3040     /// raised on any change of singleton instance
3041     /// @dev for convenience we provide previous instance of singleton in replacedInstance
3042     event LogSetSingleton(
3043         bytes4 interfaceId,
3044         address instance,
3045         address replacedInstance
3046     );
3047 
3048     /// raised on add/remove interface instance in collection
3049     event LogSetCollectionInterface(
3050         bytes4 interfaceId,
3051         address instance,
3052         bool isSet
3053     );
3054 
3055     ////////////////////////
3056     // Mutable state
3057     ////////////////////////
3058 
3059     // mapping of known contracts to addresses of singletons
3060     mapping(bytes4 => address) private _singletons;
3061 
3062     // mapping of known interfaces to collections of contracts
3063     mapping(bytes4 =>
3064         mapping(address => bool)) private _collections; // solium-disable-line indentation
3065 
3066     // known instances
3067     mapping(address => bytes4[]) private _instances;
3068 
3069 
3070     ////////////////////////
3071     // Constructor
3072     ////////////////////////
3073 
3074     constructor(
3075         IAccessPolicy accessPolicy,
3076         IEthereumForkArbiter forkArbiter
3077     )
3078         Agreement(accessPolicy, forkArbiter)
3079         public
3080     {
3081         setSingletonPrivate(KNOWN_INTERFACE_ACCESS_POLICY, accessPolicy);
3082         setSingletonPrivate(KNOWN_INTERFACE_FORK_ARBITER, forkArbiter);
3083     }
3084 
3085     ////////////////////////
3086     // Public methods
3087     ////////////////////////
3088 
3089     /// get singleton instance for 'interfaceId'
3090     function getSingleton(bytes4 interfaceId)
3091         public
3092         constant
3093         returns (address)
3094     {
3095         return _singletons[interfaceId];
3096     }
3097 
3098     function getManySingletons(bytes4[] interfaceIds)
3099         public
3100         constant
3101         returns (address[])
3102     {
3103         address[] memory addresses = new address[](interfaceIds.length);
3104         uint256 idx;
3105         while(idx < interfaceIds.length) {
3106             addresses[idx] = _singletons[interfaceIds[idx]];
3107             idx += 1;
3108         }
3109         return addresses;
3110     }
3111 
3112     /// checks of 'instance' is instance of interface 'interfaceId'
3113     function isSingleton(bytes4 interfaceId, address instance)
3114         public
3115         constant
3116         returns (bool)
3117     {
3118         return _singletons[interfaceId] == instance;
3119     }
3120 
3121     /// checks if 'instance' is one of instances of 'interfaceId'
3122     function isInterfaceCollectionInstance(bytes4 interfaceId, address instance)
3123         public
3124         constant
3125         returns (bool)
3126     {
3127         return _collections[interfaceId][instance];
3128     }
3129 
3130     function isAnyOfInterfaceCollectionInstance(bytes4[] interfaceIds, address instance)
3131         public
3132         constant
3133         returns (bool)
3134     {
3135         uint256 idx;
3136         while(idx < interfaceIds.length) {
3137             if (_collections[interfaceIds[idx]][instance]) {
3138                 return true;
3139             }
3140             idx += 1;
3141         }
3142         return false;
3143     }
3144 
3145     /// gets all interfaces of given instance
3146     function getInterfacesOfInstance(address instance)
3147         public
3148         constant
3149         returns (bytes4[] interfaces)
3150     {
3151         return _instances[instance];
3152     }
3153 
3154     /// sets 'instance' of singleton with interface 'interfaceId'
3155     function setSingleton(bytes4 interfaceId, address instance)
3156         public
3157         only(ROLE_UNIVERSE_MANAGER)
3158     {
3159         setSingletonPrivate(interfaceId, instance);
3160     }
3161 
3162     /// convenience method for setting many singleton instances
3163     function setManySingletons(bytes4[] interfaceIds, address[] instances)
3164         public
3165         only(ROLE_UNIVERSE_MANAGER)
3166     {
3167         require(interfaceIds.length == instances.length);
3168         uint256 idx;
3169         while(idx < interfaceIds.length) {
3170             setSingletonPrivate(interfaceIds[idx], instances[idx]);
3171             idx += 1;
3172         }
3173     }
3174 
3175     /// set or unset 'instance' with 'interfaceId' in collection of instances
3176     function setCollectionInterface(bytes4 interfaceId, address instance, bool set)
3177         public
3178         only(ROLE_UNIVERSE_MANAGER)
3179     {
3180         setCollectionPrivate(interfaceId, instance, set);
3181     }
3182 
3183     /// set or unset 'instance' in many collections of instances
3184     function setInterfaceInManyCollections(bytes4[] interfaceIds, address instance, bool set)
3185         public
3186         only(ROLE_UNIVERSE_MANAGER)
3187     {
3188         uint256 idx;
3189         while(idx < interfaceIds.length) {
3190             setCollectionPrivate(interfaceIds[idx], instance, set);
3191             idx += 1;
3192         }
3193     }
3194 
3195     /// set or unset array of collection
3196     function setCollectionsInterfaces(bytes4[] interfaceIds, address[] instances, bool[] set_flags)
3197         public
3198         only(ROLE_UNIVERSE_MANAGER)
3199     {
3200         require(interfaceIds.length == instances.length);
3201         require(interfaceIds.length == set_flags.length);
3202         uint256 idx;
3203         while(idx < interfaceIds.length) {
3204             setCollectionPrivate(interfaceIds[idx], instances[idx], set_flags[idx]);
3205             idx += 1;
3206         }
3207     }
3208 
3209     //
3210     // Implements IContractId
3211     //
3212 
3213     function contractId() public pure returns (bytes32 id, uint256 version) {
3214         return (0x8b57bfe21a3ef4854e19d702063b6cea03fa514162f8ff43fde551f06372fefd, 0);
3215     }
3216 
3217     ////////////////////////
3218     // Getters
3219     ////////////////////////
3220 
3221     function accessPolicy() public constant returns (IAccessPolicy) {
3222         return IAccessPolicy(_singletons[KNOWN_INTERFACE_ACCESS_POLICY]);
3223     }
3224 
3225     function forkArbiter() public constant returns (IEthereumForkArbiter) {
3226         return IEthereumForkArbiter(_singletons[KNOWN_INTERFACE_FORK_ARBITER]);
3227     }
3228 
3229     function neumark() public constant returns (Neumark) {
3230         return Neumark(_singletons[KNOWN_INTERFACE_NEUMARK]);
3231     }
3232 
3233     function etherToken() public constant returns (IERC223Token) {
3234         return IERC223Token(_singletons[KNOWN_INTERFACE_ETHER_TOKEN]);
3235     }
3236 
3237     function euroToken() public constant returns (IERC223Token) {
3238         return IERC223Token(_singletons[KNOWN_INTERFACE_EURO_TOKEN]);
3239     }
3240 
3241     function etherLock() public constant returns (address) {
3242         return _singletons[KNOWN_INTERFACE_ETHER_LOCK];
3243     }
3244 
3245     function euroLock() public constant returns (address) {
3246         return _singletons[KNOWN_INTERFACE_EURO_LOCK];
3247     }
3248 
3249     function icbmEtherLock() public constant returns (address) {
3250         return _singletons[KNOWN_INTERFACE_ICBM_ETHER_LOCK];
3251     }
3252 
3253     function icbmEuroLock() public constant returns (address) {
3254         return _singletons[KNOWN_INTERFACE_ICBM_EURO_LOCK];
3255     }
3256 
3257     function identityRegistry() public constant returns (address) {
3258         return IIdentityRegistry(_singletons[KNOWN_INTERFACE_IDENTITY_REGISTRY]);
3259     }
3260 
3261     function tokenExchangeRateOracle() public constant returns (address) {
3262         return ITokenExchangeRateOracle(_singletons[KNOWN_INTERFACE_TOKEN_EXCHANGE_RATE_ORACLE]);
3263     }
3264 
3265     function feeDisbursal() public constant returns (address) {
3266         return IFeeDisbursal(_singletons[KNOWN_INTERFACE_FEE_DISBURSAL]);
3267     }
3268 
3269     function platformPortfolio() public constant returns (address) {
3270         return IPlatformPortfolio(_singletons[KNOWN_INTERFACE_PLATFORM_PORTFOLIO]);
3271     }
3272 
3273     function tokenExchange() public constant returns (address) {
3274         return _singletons[KNOWN_INTERFACE_TOKEN_EXCHANGE];
3275     }
3276 
3277     function gasExchange() public constant returns (address) {
3278         return _singletons[KNOWN_INTERFACE_GAS_EXCHANGE];
3279     }
3280 
3281     function platformTerms() public constant returns (address) {
3282         return _singletons[KNOWN_INTERFACE_PLATFORM_TERMS];
3283     }
3284 
3285     ////////////////////////
3286     // Private methods
3287     ////////////////////////
3288 
3289     function setSingletonPrivate(bytes4 interfaceId, address instance)
3290         private
3291     {
3292         require(interfaceId != KNOWN_INTERFACE_UNIVERSE, "NF_UNI_NO_UNIVERSE_SINGLETON");
3293         address replacedInstance = _singletons[interfaceId];
3294         // do nothing if not changing
3295         if (replacedInstance != instance) {
3296             dropInstance(replacedInstance, interfaceId);
3297             addInstance(instance, interfaceId);
3298             _singletons[interfaceId] = instance;
3299         }
3300 
3301         emit LogSetSingleton(interfaceId, instance, replacedInstance);
3302     }
3303 
3304     function setCollectionPrivate(bytes4 interfaceId, address instance, bool set)
3305         private
3306     {
3307         // do nothing if not changing
3308         if (_collections[interfaceId][instance] == set) {
3309             return;
3310         }
3311         _collections[interfaceId][instance] = set;
3312         if (set) {
3313             addInstance(instance, interfaceId);
3314         } else {
3315             dropInstance(instance, interfaceId);
3316         }
3317         emit LogSetCollectionInterface(interfaceId, instance, set);
3318     }
3319 
3320     function addInstance(address instance, bytes4 interfaceId)
3321         private
3322     {
3323         if (instance == address(0)) {
3324             // do not add null instance
3325             return;
3326         }
3327         bytes4[] storage current = _instances[instance];
3328         uint256 idx;
3329         while(idx < current.length) {
3330             // instancy has this interface already, do nothing
3331             if (current[idx] == interfaceId)
3332                 return;
3333             idx += 1;
3334         }
3335         // new interface
3336         current.push(interfaceId);
3337     }
3338 
3339     function dropInstance(address instance, bytes4 interfaceId)
3340         private
3341     {
3342         if (instance == address(0)) {
3343             // do not drop null instance
3344             return;
3345         }
3346         bytes4[] storage current = _instances[instance];
3347         uint256 idx;
3348         uint256 last = current.length - 1;
3349         while(idx <= last) {
3350             if (current[idx] == interfaceId) {
3351                 // delete element
3352                 if (idx < last) {
3353                     // if not last element move last element to idx being deleted
3354                     current[idx] = current[last];
3355                 }
3356                 // delete last element
3357                 current.length -= 1;
3358                 return;
3359             }
3360             idx += 1;
3361         }
3362     }
3363 }
3364 
3365 /// @title sets duration of states in ETO
3366 contract ETODurationTerms is IContractId {
3367 
3368     ////////////////////////
3369     // Immutable state
3370     ////////////////////////
3371 
3372     // duration of Whitelist state
3373     uint32 public WHITELIST_DURATION;
3374 
3375     // duration of Public state
3376     uint32 public PUBLIC_DURATION;
3377 
3378     // time for Nominee and Company to sign Investment Agreement offchain and present proof on-chain
3379     uint32 public SIGNING_DURATION;
3380 
3381     // time for Claim before fee payout from ETO to NEU holders
3382     uint32 public CLAIM_DURATION;
3383 
3384     ////////////////////////
3385     // Constructor
3386     ////////////////////////
3387 
3388     constructor(
3389         uint32 whitelistDuration,
3390         uint32 publicDuration,
3391         uint32 signingDuration,
3392         uint32 claimDuration
3393     )
3394         public
3395     {
3396         WHITELIST_DURATION = whitelistDuration;
3397         PUBLIC_DURATION = publicDuration;
3398         SIGNING_DURATION = signingDuration;
3399         CLAIM_DURATION = claimDuration;
3400     }
3401 
3402     //
3403     // Implements IContractId
3404     //
3405 
3406     function contractId() public pure returns (bytes32 id, uint256 version) {
3407         return (0x5fb50201b453799d95f8a80291b940f1c543537b95bff2e3c78c2e36070494c0, 0);
3408     }
3409 }
3410 
3411 /// @title sets terms for tokens in ETO
3412 contract ETOTokenTerms is IContractId {
3413 
3414     ////////////////////////
3415     // Immutable state
3416     ////////////////////////
3417 
3418     // minimum number of tokens being offered. will set min cap
3419     uint256 public MIN_NUMBER_OF_TOKENS;
3420     // maximum number of tokens being offered. will set max cap
3421     uint256 public MAX_NUMBER_OF_TOKENS;
3422     // base token price in EUR-T, without any discount scheme
3423     uint256 public TOKEN_PRICE_EUR_ULPS;
3424     // maximum number of tokens in whitelist phase
3425     uint256 public MAX_NUMBER_OF_TOKENS_IN_WHITELIST;
3426     // equity tokens per share
3427     uint256 public constant EQUITY_TOKENS_PER_SHARE = 10000;
3428     // equity tokens decimals (precision)
3429     uint8 public constant EQUITY_TOKENS_PRECISION = 0; // indivisible
3430 
3431 
3432     ////////////////////////
3433     // Constructor
3434     ////////////////////////
3435 
3436     constructor(
3437         uint256 minNumberOfTokens,
3438         uint256 maxNumberOfTokens,
3439         uint256 tokenPriceEurUlps,
3440         uint256 maxNumberOfTokensInWhitelist
3441     )
3442         public
3443     {
3444         require(maxNumberOfTokensInWhitelist <= maxNumberOfTokens);
3445         require(maxNumberOfTokens >= minNumberOfTokens);
3446         // min cap must be > single share
3447         require(minNumberOfTokens >= EQUITY_TOKENS_PER_SHARE, "NF_ETO_TERMS_ONE_SHARE");
3448 
3449         MIN_NUMBER_OF_TOKENS = minNumberOfTokens;
3450         MAX_NUMBER_OF_TOKENS = maxNumberOfTokens;
3451         TOKEN_PRICE_EUR_ULPS = tokenPriceEurUlps;
3452         MAX_NUMBER_OF_TOKENS_IN_WHITELIST = maxNumberOfTokensInWhitelist;
3453     }
3454 
3455     //
3456     // Implements IContractId
3457     //
3458 
3459     function contractId() public pure returns (bytes32 id, uint256 version) {
3460         return (0x591e791aab2b14c80194b729a2abcba3e8cce1918be4061be170e7223357ae5c, 0);
3461     }
3462 }
3463 
3464 /// @title base terms of Equity Token Offering
3465 /// encapsulates pricing, discounts and whitelisting mechanism
3466 /// @dev to be split is mixins
3467 contract ETOTerms is
3468     IdentityRecord,
3469     Math,
3470     IContractId
3471 {
3472 
3473     ////////////////////////
3474     // Types
3475     ////////////////////////
3476 
3477     // @notice whitelist entry with a discount
3478     struct WhitelistTicket {
3479         // this also overrides maximum ticket
3480         uint128 discountAmountEurUlps;
3481         // a percentage of full price to be paid (1 - discount)
3482         uint128 fullTokenPriceFrac;
3483     }
3484 
3485     ////////////////////////
3486     // Constants state
3487     ////////////////////////
3488 
3489     bytes32 private constant EMPTY_STRING_HASH = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
3490     uint256 public constant MIN_QUALIFIED_INVESTOR_TICKET_EUR_ULPS = 100000 * 10**18;
3491 
3492     ////////////////////////
3493     // Immutable state
3494     ////////////////////////
3495 
3496     // reference to duration terms
3497     ETODurationTerms public DURATION_TERMS;
3498     // reference to token terms
3499     ETOTokenTerms public TOKEN_TERMS;
3500     // total number of shares in the company (incl. Authorized Shares) at moment of sale
3501     uint256 public EXISTING_COMPANY_SHARES;
3502     // sets nominal value of a share
3503     uint256 public SHARE_NOMINAL_VALUE_EUR_ULPS;
3504     // maximum discount on token price that may be given to investor (as decimal fraction)
3505     // uint256 public MAXIMUM_TOKEN_PRICE_DISCOUNT_FRAC;
3506     // minimum ticket
3507     uint256 public MIN_TICKET_EUR_ULPS;
3508     // maximum ticket for sophisiticated investors
3509     uint256 public MAX_TICKET_EUR_ULPS;
3510     // maximum ticket for simple investors
3511     uint256 public MAX_TICKET_SIMPLE_EUR_ULPS;
3512     // should enable transfers on ETO success
3513     // transfers are always disabled during token offering
3514     // if set to False transfers on Equity Token will remain disabled after offering
3515     // once those terms are on-chain this flags fully controls token transferability
3516     bool public ENABLE_TRANSFERS_ON_SUCCESS;
3517     // tells if offering accepts retail investors. if so, registered prospectus is required
3518     // and ENABLE_TRANSFERS_ON_SUCCESS is forced to be false as per current platform policy
3519     bool public ALLOW_RETAIL_INVESTORS;
3520     // represents the discount % for whitelist participants
3521     uint256 public WHITELIST_DISCOUNT_FRAC;
3522     // represents the discount % for public participants, using values > 0 will result
3523     // in automatic downround shareholder resolution
3524     uint256 public PUBLIC_DISCOUNT_FRAC;
3525 
3526     // paperwork
3527     // prospectus / investment memorandum / crowdfunding pamphlet etc.
3528     string public INVESTOR_OFFERING_DOCUMENT_URL;
3529     // settings for shareholder rights
3530     ShareholderRights public SHAREHOLDER_RIGHTS;
3531 
3532     // equity token setup
3533     string public EQUITY_TOKEN_NAME;
3534     string public EQUITY_TOKEN_SYMBOL;
3535 
3536     // manages whitelist
3537     address public WHITELIST_MANAGER;
3538     // wallet registry of KYC procedure
3539     IIdentityRegistry public IDENTITY_REGISTRY;
3540     Universe public UNIVERSE;
3541 
3542     // variables from token terms for local use
3543     // minimum number of tokens being offered. will set min cap
3544     uint256 private MIN_NUMBER_OF_TOKENS;
3545     // maximum number of tokens being offered. will set max cap
3546     uint256 private MAX_NUMBER_OF_TOKENS;
3547     // base token price in EUR-T, without any discount scheme
3548     uint256 private TOKEN_PRICE_EUR_ULPS;
3549 
3550 
3551     ////////////////////////
3552     // Mutable state
3553     ////////////////////////
3554 
3555     // mapping of investors allowed in whitelist
3556     mapping (address => WhitelistTicket) private _whitelist;
3557 
3558     ////////////////////////
3559     // Modifiers
3560     ////////////////////////
3561 
3562     modifier onlyWhitelistManager() {
3563         require(msg.sender == WHITELIST_MANAGER);
3564         _;
3565     }
3566 
3567     ////////////////////////
3568     // Events
3569     ////////////////////////
3570 
3571     // raised on invesor added to whitelist
3572     event LogInvestorWhitelisted(
3573         address indexed investor,
3574         uint256 discountAmountEurUlps,
3575         uint256 fullTokenPriceFrac
3576     );
3577 
3578     ////////////////////////
3579     // Constructor
3580     ////////////////////////
3581 
3582     constructor(
3583         Universe universe,
3584         ETODurationTerms durationTerms,
3585         ETOTokenTerms tokenTerms,
3586         uint256 existingCompanyShares,
3587         uint256 minTicketEurUlps,
3588         uint256 maxTicketEurUlps,
3589         bool allowRetailInvestors,
3590         bool enableTransfersOnSuccess,
3591         string investorOfferingDocumentUrl,
3592         ShareholderRights shareholderRights,
3593         string equityTokenName,
3594         string equityTokenSymbol,
3595         uint256 shareNominalValueEurUlps,
3596         uint256 whitelistDiscountFrac,
3597         uint256 publicDiscountFrac
3598     )
3599         public
3600     {
3601         require(durationTerms != address(0));
3602         require(tokenTerms != address(0));
3603         require(existingCompanyShares > 0);
3604         require(keccak256(abi.encodePacked(investorOfferingDocumentUrl)) != EMPTY_STRING_HASH);
3605         require(keccak256(abi.encodePacked(equityTokenName)) != EMPTY_STRING_HASH);
3606         require(keccak256(abi.encodePacked(equityTokenSymbol)) != EMPTY_STRING_HASH);
3607         require(shareholderRights != address(0));
3608         // test interface
3609         // require(shareholderRights.HAS_GENERAL_INFORMATION_RIGHTS());
3610         require(shareNominalValueEurUlps > 0);
3611         require(whitelistDiscountFrac >= 0 && whitelistDiscountFrac <= 99*10**16);
3612         require(publicDiscountFrac >= 0 && publicDiscountFrac <= 99*10**16);
3613         require(minTicketEurUlps<=maxTicketEurUlps);
3614 
3615         // copy token terms variables
3616         MIN_NUMBER_OF_TOKENS = tokenTerms.MIN_NUMBER_OF_TOKENS();
3617         MAX_NUMBER_OF_TOKENS = tokenTerms.MAX_NUMBER_OF_TOKENS();
3618         TOKEN_PRICE_EUR_ULPS = tokenTerms.TOKEN_PRICE_EUR_ULPS();
3619 
3620         DURATION_TERMS = durationTerms;
3621         TOKEN_TERMS = tokenTerms;
3622         EXISTING_COMPANY_SHARES = existingCompanyShares;
3623         MIN_TICKET_EUR_ULPS = minTicketEurUlps;
3624         MAX_TICKET_EUR_ULPS = maxTicketEurUlps;
3625         ALLOW_RETAIL_INVESTORS = allowRetailInvestors;
3626         ENABLE_TRANSFERS_ON_SUCCESS = enableTransfersOnSuccess;
3627         INVESTOR_OFFERING_DOCUMENT_URL = investorOfferingDocumentUrl;
3628         SHAREHOLDER_RIGHTS = shareholderRights;
3629         EQUITY_TOKEN_NAME = equityTokenName;
3630         EQUITY_TOKEN_SYMBOL = equityTokenSymbol;
3631         SHARE_NOMINAL_VALUE_EUR_ULPS = shareNominalValueEurUlps;
3632         WHITELIST_DISCOUNT_FRAC = whitelistDiscountFrac;
3633         PUBLIC_DISCOUNT_FRAC = publicDiscountFrac;
3634         WHITELIST_MANAGER = msg.sender;
3635         IDENTITY_REGISTRY = IIdentityRegistry(universe.identityRegistry());
3636         UNIVERSE = universe;
3637     }
3638 
3639     ////////////////////////
3640     // Public methods
3641     ////////////////////////
3642 
3643     // calculates token amount for a given commitment at a position of the curve
3644     // we require that equity token precision is 0
3645     function calculateTokenAmount(uint256 /*totalEurUlps*/, uint256 committedEurUlps)
3646         public
3647         constant
3648         returns (uint256 tokenAmountInt)
3649     {
3650         // we may disregard totalEurUlps as curve is flat, round down when calculating tokens
3651         return committedEurUlps / calculatePriceFraction(10**18 - PUBLIC_DISCOUNT_FRAC);
3652     }
3653 
3654     // calculates amount of euro required to acquire amount of tokens at a position of the (inverse) curve
3655     // we require that equity token precision is 0
3656     function calculateEurUlpsAmount(uint256 /*totalTokensInt*/, uint256 tokenAmountInt)
3657         public
3658         constant
3659         returns (uint256 committedEurUlps)
3660     {
3661         // we may disregard totalTokensInt as curve is flat
3662         return mul(tokenAmountInt, calculatePriceFraction(10**18 - PUBLIC_DISCOUNT_FRAC));
3663     }
3664 
3665     // get mincap in EUR
3666     function ESTIMATED_MIN_CAP_EUR_ULPS() public constant returns(uint256) {
3667         return calculateEurUlpsAmount(0, MIN_NUMBER_OF_TOKENS);
3668     }
3669 
3670     // get max cap in EUR
3671     function ESTIMATED_MAX_CAP_EUR_ULPS() public constant returns(uint256) {
3672         return calculateEurUlpsAmount(0, MAX_NUMBER_OF_TOKENS);
3673     }
3674 
3675     function calculatePriceFraction(uint256 priceFrac) public constant returns(uint256) {
3676         if (priceFrac == 1) {
3677             return TOKEN_PRICE_EUR_ULPS;
3678         } else {
3679             return decimalFraction(priceFrac, TOKEN_PRICE_EUR_ULPS);
3680         }
3681     }
3682 
3683     function addWhitelisted(
3684         address[] investors,
3685         uint256[] discountAmountsEurUlps,
3686         uint256[] discountsFrac
3687     )
3688         external
3689         onlyWhitelistManager
3690     {
3691         require(investors.length == discountAmountsEurUlps.length);
3692         require(investors.length == discountsFrac.length);
3693 
3694         for (uint256 i = 0; i < investors.length; i += 1) {
3695             addWhitelistInvestorPrivate(investors[i], discountAmountsEurUlps[i], discountsFrac[i]);
3696         }
3697     }
3698 
3699     function whitelistTicket(address investor)
3700         public
3701         constant
3702         returns (bool isWhitelisted, uint256 discountAmountEurUlps, uint256 fullTokenPriceFrac)
3703     {
3704         WhitelistTicket storage wlTicket = _whitelist[investor];
3705         isWhitelisted = wlTicket.fullTokenPriceFrac > 0;
3706         discountAmountEurUlps = wlTicket.discountAmountEurUlps;
3707         fullTokenPriceFrac = wlTicket.fullTokenPriceFrac;
3708     }
3709 
3710     // calculate contribution of investor
3711     function calculateContribution(
3712         address investor,
3713         uint256 totalContributedEurUlps,
3714         uint256 existingInvestorContributionEurUlps,
3715         uint256 newInvestorContributionEurUlps,
3716         bool applyWhitelistDiscounts
3717     )
3718         public
3719         constant
3720         returns (
3721             bool isWhitelisted,
3722             bool isEligible,
3723             uint256 minTicketEurUlps,
3724             uint256 maxTicketEurUlps,
3725             uint256 equityTokenInt,
3726             uint256 fixedSlotEquityTokenInt
3727             )
3728     {
3729         (
3730             isWhitelisted,
3731             minTicketEurUlps,
3732             maxTicketEurUlps,
3733             equityTokenInt,
3734             fixedSlotEquityTokenInt
3735         ) = calculateContributionPrivate(
3736             investor,
3737             totalContributedEurUlps,
3738             existingInvestorContributionEurUlps,
3739             newInvestorContributionEurUlps,
3740             applyWhitelistDiscounts);
3741         // check if is eligible for investment
3742         IdentityClaims memory claims = deserializeClaims(IDENTITY_REGISTRY.getClaims(investor));
3743         isEligible = claims.isVerified && !claims.accountFrozen;
3744     }
3745 
3746     function equityTokensToShares(uint256 amount)
3747         public
3748         constant
3749         returns (uint256)
3750     {
3751         return divRound(amount, TOKEN_TERMS.EQUITY_TOKENS_PER_SHARE());
3752     }
3753 
3754     /// @notice checks terms against platform terms, reverts on invalid
3755     function requireValidTerms(PlatformTerms platformTerms)
3756         public
3757         constant
3758         returns (bool)
3759     {
3760         // apply constraints on retail fundraising
3761         if (ALLOW_RETAIL_INVESTORS) {
3762             // make sure transfers are disabled after offering for retail investors
3763             require(!ENABLE_TRANSFERS_ON_SUCCESS, "NF_MUST_DISABLE_TRANSFERS");
3764         } else {
3765             // only qualified investors allowed defined as tickets > 100000 EUR
3766             require(MIN_TICKET_EUR_ULPS >= MIN_QUALIFIED_INVESTOR_TICKET_EUR_ULPS, "NF_MIN_QUALIFIED_INVESTOR_TICKET");
3767         }
3768         // min ticket must be > token price
3769         require(MIN_TICKET_EUR_ULPS >= TOKEN_TERMS.TOKEN_PRICE_EUR_ULPS(), "NF_MIN_TICKET_LT_TOKEN_PRICE");
3770         // it must be possible to collect more funds than max number of tokens
3771         require(ESTIMATED_MAX_CAP_EUR_ULPS() >= MIN_TICKET_EUR_ULPS, "NF_MAX_FUNDS_LT_MIN_TICKET");
3772 
3773         require(MIN_TICKET_EUR_ULPS >= platformTerms.MIN_TICKET_EUR_ULPS(), "NF_ETO_TERMS_MIN_TICKET_EUR_ULPS");
3774         // duration checks
3775         require(DURATION_TERMS.WHITELIST_DURATION() >= platformTerms.MIN_WHITELIST_DURATION(), "NF_ETO_TERMS_WL_D_MIN");
3776         require(DURATION_TERMS.WHITELIST_DURATION() <= platformTerms.MAX_WHITELIST_DURATION(), "NF_ETO_TERMS_WL_D_MAX");
3777 
3778         require(DURATION_TERMS.PUBLIC_DURATION() >= platformTerms.MIN_PUBLIC_DURATION(), "NF_ETO_TERMS_PUB_D_MIN");
3779         require(DURATION_TERMS.PUBLIC_DURATION() <= platformTerms.MAX_PUBLIC_DURATION(), "NF_ETO_TERMS_PUB_D_MAX");
3780 
3781         uint256 totalDuration = DURATION_TERMS.WHITELIST_DURATION() + DURATION_TERMS.PUBLIC_DURATION();
3782         require(totalDuration >= platformTerms.MIN_OFFER_DURATION(), "NF_ETO_TERMS_TOT_O_MIN");
3783         require(totalDuration <= platformTerms.MAX_OFFER_DURATION(), "NF_ETO_TERMS_TOT_O_MAX");
3784 
3785         require(DURATION_TERMS.SIGNING_DURATION() >= platformTerms.MIN_SIGNING_DURATION(), "NF_ETO_TERMS_SIG_MIN");
3786         require(DURATION_TERMS.SIGNING_DURATION() <= platformTerms.MAX_SIGNING_DURATION(), "NF_ETO_TERMS_SIG_MAX");
3787 
3788         require(DURATION_TERMS.CLAIM_DURATION() >= platformTerms.MIN_CLAIM_DURATION(), "NF_ETO_TERMS_CLAIM_MIN");
3789         require(DURATION_TERMS.CLAIM_DURATION() <= platformTerms.MAX_CLAIM_DURATION(), "NF_ETO_TERMS_CLAIM_MAX");
3790 
3791         return true;
3792     }
3793 
3794     //
3795     // Implements IContractId
3796     //
3797 
3798     function contractId() public pure returns (bytes32 id, uint256 version) {
3799         return (0x3468b14073c33fa00ee7f8a289b14f4a10c78ab72726033b27003c31c47b3f6a, 0);
3800     }
3801 
3802     ////////////////////////
3803     // Private methods
3804     ////////////////////////
3805 
3806     function calculateContributionPrivate(
3807         address investor,
3808         uint256 totalContributedEurUlps,
3809         uint256 existingInvestorContributionEurUlps,
3810         uint256 newInvestorContributionEurUlps,
3811         bool applyWhitelistDiscounts
3812     )
3813         private
3814         constant
3815         returns (
3816             bool isWhitelisted,
3817             uint256 minTicketEurUlps,
3818             uint256 maxTicketEurUlps,
3819             uint256 equityTokenInt,
3820             uint256 fixedSlotEquityTokenInt
3821         )
3822     {
3823         uint256 discountedAmount;
3824         minTicketEurUlps = MIN_TICKET_EUR_ULPS;
3825         maxTicketEurUlps = MAX_TICKET_EUR_ULPS;
3826         WhitelistTicket storage wlTicket = _whitelist[investor];
3827         // check if has access to discount
3828         isWhitelisted = wlTicket.fullTokenPriceFrac > 0;
3829         // whitelist use discount is possible
3830         if (applyWhitelistDiscounts) {
3831             // can invest more than general max ticket
3832             maxTicketEurUlps = max(wlTicket.discountAmountEurUlps, maxTicketEurUlps);
3833             // can invest less than general min ticket
3834             if (wlTicket.discountAmountEurUlps > 0) {
3835                 minTicketEurUlps = min(wlTicket.discountAmountEurUlps, minTicketEurUlps);
3836             }
3837             if (existingInvestorContributionEurUlps < wlTicket.discountAmountEurUlps) {
3838                 discountedAmount = min(newInvestorContributionEurUlps, wlTicket.discountAmountEurUlps - existingInvestorContributionEurUlps);
3839                 // discount is fixed so use base token price
3840                 if (discountedAmount > 0) {
3841                     // always round down when calculating tokens
3842                     fixedSlotEquityTokenInt = discountedAmount / calculatePriceFraction(wlTicket.fullTokenPriceFrac);
3843                 }
3844             }
3845         }
3846         // if any amount above discount
3847         uint256 remainingAmount = newInvestorContributionEurUlps - discountedAmount;
3848         if (remainingAmount > 0) {
3849             if (applyWhitelistDiscounts && WHITELIST_DISCOUNT_FRAC > 0) {
3850                 // will not overflow, WHITELIST_DISCOUNT_FRAC < Q18 from constructor, also round down
3851                 equityTokenInt = remainingAmount / calculatePriceFraction(10**18 - WHITELIST_DISCOUNT_FRAC);
3852             } else {
3853                 // use pricing along the curve
3854                 equityTokenInt = calculateTokenAmount(totalContributedEurUlps + discountedAmount, remainingAmount);
3855             }
3856         }
3857         // should have all issued tokens
3858         equityTokenInt += fixedSlotEquityTokenInt;
3859 
3860     }
3861 
3862     function addWhitelistInvestorPrivate(
3863         address investor,
3864         uint256 discountAmountEurUlps,
3865         uint256 fullTokenPriceFrac
3866     )
3867         private
3868     {
3869         // Validate
3870         require(investor != address(0));
3871         require(fullTokenPriceFrac > 0 && fullTokenPriceFrac <= 10**18, "NF_DISCOUNT_RANGE");
3872         require(discountAmountEurUlps < 2**128);
3873 
3874 
3875         _whitelist[investor] = WhitelistTicket({
3876             discountAmountEurUlps: uint128(discountAmountEurUlps),
3877             fullTokenPriceFrac: uint128(fullTokenPriceFrac)
3878         });
3879 
3880         emit LogInvestorWhitelisted(investor, discountAmountEurUlps, fullTokenPriceFrac);
3881     }
3882 
3883 }
3884 
3885 /// @title default interface of commitment process
3886 ///  investment always happens via payment token ERC223 callback
3887 ///  methods for checking finality and success/fail of the process are vailable
3888 ///  commitment event is standardized for tracking
3889 contract ICommitment is
3890     IAgreement,
3891     IERC223Callback
3892 {
3893 
3894     ////////////////////////
3895     // Events
3896     ////////////////////////
3897 
3898     /// on every commitment transaction
3899     /// `investor` committed `amount` in `paymentToken` currency which was
3900     /// converted to `baseCurrencyEquivalent` that generates `grantedAmount` of
3901     /// `assetToken` and `neuReward` NEU
3902     /// for investment funds could be provided from `wallet` (like icbm wallet) controlled by investor
3903     event LogFundsCommitted(
3904         address indexed investor,
3905         address wallet,
3906         address paymentToken,
3907         uint256 amount,
3908         uint256 baseCurrencyEquivalent,
3909         uint256 grantedAmount,
3910         address assetToken,
3911         uint256 neuReward
3912     );
3913 
3914     ////////////////////////
3915     // Public functions
3916     ////////////////////////
3917 
3918     // says if state is final
3919     function finalized() public constant returns (bool);
3920 
3921     // says if state is success
3922     function success() public constant returns (bool);
3923 
3924     // says if state is failure
3925     function failed() public constant returns (bool);
3926 
3927     // currently committed funds
3928     function totalInvestment()
3929         public
3930         constant
3931         returns (
3932             uint256 totalEquivEurUlps,
3933             uint256 totalTokensInt,
3934             uint256 totalInvestors
3935         );
3936 
3937     /// commit function happens via ERC223 callback that must happen from trusted payment token
3938     /// @param investor address of the investor
3939     /// @param amount amount commited
3940     /// @param data may have meaning in particular ETO implementation
3941     function tokenFallback(address investor, uint256 amount, bytes data)
3942         public;
3943 
3944 }
3945 
3946 /// @title default interface of commitment process
3947 contract IETOCommitment is
3948     ICommitment,
3949     IETOCommitmentStates
3950 {
3951 
3952     ////////////////////////
3953     // Events
3954     ////////////////////////
3955 
3956     // on every state transition
3957     event LogStateTransition(
3958         uint32 oldState,
3959         uint32 newState,
3960         uint32 timestamp
3961     );
3962 
3963     /// on a claim by invester
3964     ///   `investor` claimed `amount` of `assetToken` and claimed `nmkReward` amount of NEU
3965     event LogTokensClaimed(
3966         address indexed investor,
3967         address indexed assetToken,
3968         uint256 amount,
3969         uint256 nmkReward
3970     );
3971 
3972     /// on a refund to investor
3973     ///   `investor` was refunded `amount` of `paymentToken`
3974     /// @dev may be raised multiple times per refund operation
3975     event LogFundsRefunded(
3976         address indexed investor,
3977         address indexed paymentToken,
3978         uint256 amount
3979     );
3980 
3981     // logged at the moment of Company setting terms
3982     event LogTermsSet(
3983         address companyLegalRep,
3984         address etoTerms,
3985         address equityToken
3986     );
3987 
3988     // logged at the moment Company sets/resets Whitelisting start date
3989     event LogETOStartDateSet(
3990         address companyLegalRep,
3991         uint256 previousTimestamp,
3992         uint256 newTimestamp
3993     );
3994 
3995     // logged at the moment Signing procedure starts
3996     event LogSigningStarted(
3997         address nominee,
3998         address companyLegalRep,
3999         uint256 newShares,
4000         uint256 capitalIncreaseEurUlps
4001     );
4002 
4003     // logged when company presents signed investment agreement
4004     event LogCompanySignedAgreement(
4005         address companyLegalRep,
4006         address nominee,
4007         string signedInvestmentAgreementUrl
4008     );
4009 
4010     // logged when nominee presents and verifies its copy of investment agreement
4011     event LogNomineeConfirmedAgreement(
4012         address nominee,
4013         address companyLegalRep,
4014         string signedInvestmentAgreementUrl
4015     );
4016 
4017     // logged on refund transition to mark destroyed tokens
4018     event LogRefundStarted(
4019         address assetToken,
4020         uint256 totalTokenAmountInt,
4021         uint256 totalRewardNmkUlps
4022     );
4023 
4024     ////////////////////////
4025     // Public functions
4026     ////////////////////////
4027 
4028     //
4029     // ETOState control
4030     //
4031 
4032     // returns current ETO state
4033     function state() public constant returns (ETOState);
4034 
4035     // returns start of given state
4036     function startOf(ETOState s) public constant returns (uint256);
4037 
4038     // returns commitment observer (typically equity token controller)
4039     function commitmentObserver() public constant returns (IETOCommitmentObserver);
4040 
4041     //
4042     // Commitment process
4043     //
4044 
4045     /// refunds investor if ETO failed
4046     function refund() external;
4047 
4048     function refundMany(address[] investors) external;
4049 
4050     /// claims tokens if ETO is a success
4051     function claim() external;
4052 
4053     function claimMany(address[] investors) external;
4054 
4055     // initiate fees payout
4056     function payout() external;
4057 
4058 
4059     //
4060     // Offering terms
4061     //
4062 
4063     function etoTerms() public constant returns (ETOTerms);
4064 
4065     // equity token
4066     function equityToken() public constant returns (IEquityToken);
4067 
4068     // nominee
4069     function nominee() public constant returns (address);
4070 
4071     function companyLegalRep() public constant returns (address);
4072 
4073     /// signed agreement as provided by company and nominee
4074     /// @dev available on Claim state transition
4075     function signedInvestmentAgreementUrl() public constant returns (string);
4076 
4077     /// financial outcome of token offering set on Signing state transition
4078     /// @dev in preceding states 0 is returned
4079     function contributionSummary()
4080         public
4081         constant
4082         returns (
4083             uint256 newShares, uint256 capitalIncreaseEurUlps,
4084             uint256 additionalContributionEth, uint256 additionalContributionEurUlps,
4085             uint256 tokenParticipationFeeInt, uint256 platformFeeEth, uint256 platformFeeEurUlps,
4086             uint256 sharePriceEurUlps
4087         );
4088 
4089     /// method to obtain current investors ticket
4090     function investorTicket(address investor)
4091         public
4092         constant
4093         returns (
4094             uint256 equivEurUlps,
4095             uint256 rewardNmkUlps,
4096             uint256 equityTokenInt,
4097             uint256 sharesInt,
4098             uint256 tokenPrice,
4099             uint256 neuRate,
4100             uint256 amountEth,
4101             uint256 amountEurUlps,
4102             bool claimOrRefundSettled,
4103             bool usedLockedAccount
4104         );
4105 }
4106 
4107 contract IControllerGovernance is
4108     IAgreement
4109 {
4110 
4111     ////////////////////////
4112     // Types
4113     ////////////////////////
4114 
4115     // defines state machine of the token controller which goes from I to T without loops
4116     enum GovState {
4117         Setup, // Initial state
4118         Offering, // primary token offering in progress
4119         Funded, // token offering succeeded, execution of shareholder rights possible
4120         Closing, // company is being closed
4121         Closed, // terminal state, company closed
4122         Migrated // terminal state, contract migrated
4123     }
4124 
4125     enum Action {
4126         None, // no on-chain action on resolution
4127         StopToken, // blocks transfers
4128         ContinueToken, // enables transfers
4129         CloseToken, // any liquidation: dissolution, tag, drag, exit (settlement time, amount eur, amount eth)
4130         Payout, // any dividend payout (amount eur, amount eth)
4131         RegisterOffer, // start new token offering
4132         ChangeTokenController, // (new token controller)
4133         AmendISHA, // for example off-chain investment (agreement url, new number of shares, new shareholder rights, new valuation eur)
4134         IssueTokensForExistingShares, // (number of converted shares, allocation (address => balance))
4135         ChangeNominee,
4136         Downround // results in issuance of new equity token and disbursing it to current token holders
4137     }
4138 
4139     ////////////////////////
4140     // Events
4141     ////////////////////////
4142 
4143     // logged on controller state transition
4144     event LogGovStateTransition(
4145         uint32 oldState,
4146         uint32 newState,
4147         uint32 timestamp
4148     );
4149 
4150     // logged on action that is a result of shareholder resolution (on-chain, off-chain), or should be shareholder resolution
4151     event LogResolutionExecuted(
4152         bytes32 resolutionId,
4153         Action action
4154     );
4155 
4156     // logged when transferability of given token was changed
4157     event LogTransfersStateChanged(
4158         bytes32 resolutionId,
4159         address equityToken,
4160         bool transfersEnabled
4161     );
4162 
4163     // logged when ISHA was amended (new text, new shareholders, new cap table, offline round etc.)
4164     event LogISHAAmended(
4165         bytes32 resolutionId,
4166         string ISHAUrl,
4167         uint256 totalShares,
4168         uint256 companyValuationEurUlps,
4169         address newShareholderRights
4170     );
4171 
4172     // offering of the token in ETO failed (Refund)
4173     event LogOfferingFailed(
4174         address etoCommitment,
4175         address equityToken
4176     );
4177 
4178     // offering of the token in ETO succeeded (with all on-chain consequences)
4179     event LogOfferingSucceeded(
4180         address etoCommitment,
4181         address equityToken,
4182         uint256 newShares
4183     );
4184 
4185     // logs when company issues official information to shareholders
4186     event LogGeneralInformation(
4187         address companyLegalRep,
4188         string informationType,
4189         string informationUrl
4190     );
4191 
4192     //
4193     event LogOfferingRegistered(
4194         bytes32 resolutionId,
4195         address etoCommitment,
4196         address equityToken
4197     );
4198 
4199     event LogMigratedTokenController(
4200         bytes32 resolutionId,
4201         address newController
4202     );
4203 
4204     ////////////////////////
4205     // Interface methods
4206     ////////////////////////
4207 
4208     // returns current state of the controller
4209     function state()
4210         public
4211         constant
4212         returns (GovState);
4213 
4214     // address of company legal representative able to sign agreements
4215     function companyLegalRepresentative()
4216         public
4217         constant
4218         returns (address);
4219 
4220     // return basic shareholder information
4221     function shareholderInformation()
4222         public
4223         constant
4224         returns (
4225             uint256 totalCompanyShares,
4226             uint256 companyValuationEurUlps,
4227             ShareholderRights shareholderRights
4228         );
4229 
4230     // returns cap table
4231     function capTable()
4232         public
4233         constant
4234         returns (
4235             address[] equityTokens,
4236             uint256[] shares
4237         );
4238 
4239     // returns all started offerings
4240     function tokenOfferings()
4241         public
4242         constant
4243         returns (
4244             address[] offerings,
4245             address[] equityTokens
4246         );
4247 
4248     // officially inform shareholders, can be quarterly report, yearly closing
4249     // @dev this can be called only by company wallet
4250     function issueGeneralInformation(
4251         string informationType,
4252         string informationUrl
4253     )
4254         public;
4255 
4256     // start new resolution vs shareholders. required due to General Information Rights even in case of no voting right
4257     // @dev payload in RLP encoded and will be parsed in the implementation
4258     // @dev this can be called only by company wallet
4259     function startResolution(string title, string resolutionUri, Action action, bytes payload)
4260         public
4261         returns (bytes32 resolutionId);
4262 
4263     // execute on-chain action of the given resolution if it has passed accordint to implemented governance
4264     function executeResolution(bytes32 resolutionId) public;
4265 
4266     // this will close company (transition to terminal state) and close all associated tokens
4267     // requires decision to be made before according to implemented governance
4268     // also requires that certain obligations are met like proceeds were distributed
4269     // so anyone should be able to call this function
4270     function closeCompany() public;
4271 
4272     // this will cancel closing of the company due to obligations not met in time
4273     // being able to cancel closing should not depend on who is calling the function.
4274     function cancelCompanyClosing() public;
4275 
4276     /// @notice replace current token controller
4277     /// @dev please note that this process is also controlled by existing controller so for example resolution may be required
4278     function changeTokenController(address newController) public;
4279 
4280     // in Migrated state - an address of actual token controller
4281     /// @dev should return zero address on other states
4282     function newTokenController() public constant returns (address);
4283 
4284     // an address of previous controller (in Migrated state)
4285     /// @dev should return zero address if is the first controller
4286     function oldTokenController() public constant returns (address);
4287 }
4288 
4289 /// @title placeholder for on-chain company management
4290 /// several simplifications apply:
4291 ///   - there is just one (primary) offering. no more offerings may be executed
4292 ///   - transfer rights are executed as per ETO_TERMS
4293 ///   - general information rights are executed
4294 ///   - no other rights can be executed and no on-chain shareholder resolution results are in place
4295 ///   - allows changing to better token controller by company
4296 contract PlaceholderEquityTokenController is
4297     IEquityTokenController,
4298     IControllerGovernance,
4299     IContractId,
4300     Agreement,
4301     KnownInterfaces
4302 {
4303     ////////////////////////
4304     // Immutable state
4305     ////////////////////////
4306 
4307     // a root of trust contract
4308     Universe private UNIVERSE;
4309 
4310     // company representative address
4311     address private COMPANY_LEGAL_REPRESENTATIVE;
4312 
4313     ////////////////////////
4314     // Mutable state
4315     ////////////////////////
4316 
4317     // controller lifecycle state
4318     GovState private _state;
4319 
4320     // total number of shares owned by Company
4321     uint256 private _totalCompanyShares;
4322 
4323     // valuation of the company
4324     uint256 private _companyValuationEurUlps;
4325 
4326     // set of shareholder rights that will be executed
4327     ShareholderRights private _shareholderRights;
4328 
4329     // new controller when migrating
4330     address private _newController;
4331 
4332     // equity token from ETO
4333     IEquityToken private _equityToken;
4334 
4335     // ETO contract
4336     address private _commitment;
4337 
4338     // are transfers on token enabled
4339     bool private _transfersEnabled;
4340 
4341     ////////////////////////
4342     // Modifiers
4343     ////////////////////////
4344 
4345     // require caller is ETO in universe
4346     modifier onlyUniverseETO() {
4347         require(UNIVERSE.isInterfaceCollectionInstance(KNOWN_INTERFACE_COMMITMENT, msg.sender), "NF_ETC_ETO_NOT_U");
4348         _;
4349     }
4350 
4351     modifier onlyCompany() {
4352         require(msg.sender == COMPANY_LEGAL_REPRESENTATIVE, "NF_ONLY_COMPANY");
4353         _;
4354     }
4355 
4356     modifier onlyOperational() {
4357         require(_state == GovState.Offering || _state == GovState.Funded || _state == GovState.Closing, "NF_INV_STATE");
4358         _;
4359     }
4360 
4361     modifier onlyState(GovState state) {
4362         require(_state == state, "NF_INV_STATE");
4363         _;
4364     }
4365 
4366     modifier onlyStates(GovState state1, GovState state2) {
4367         require(_state == state1 || _state == state2, "NF_INV_STATE");
4368         _;
4369     }
4370 
4371     ////////////////////////
4372     // Constructor
4373     ////////////////////////
4374 
4375     constructor(
4376         Universe universe,
4377         address companyLegalRep
4378     )
4379         public
4380         Agreement(universe.accessPolicy(), universe.forkArbiter())
4381     {
4382         UNIVERSE = universe;
4383         COMPANY_LEGAL_REPRESENTATIVE = companyLegalRep;
4384     }
4385 
4386     //
4387     // Implements IControllerGovernance
4388     //
4389 
4390     function state()
4391         public
4392         constant
4393         returns (GovState)
4394     {
4395         return _state;
4396     }
4397 
4398     function companyLegalRepresentative()
4399         public
4400         constant
4401         returns (address)
4402     {
4403         return COMPANY_LEGAL_REPRESENTATIVE;
4404     }
4405 
4406     function shareholderInformation()
4407         public
4408         constant
4409         returns (
4410             uint256 totalCompanyShares,
4411             uint256 companyValuationEurUlps,
4412             ShareholderRights shareholderRights
4413         )
4414     {
4415         return (
4416             _totalCompanyShares,
4417             _companyValuationEurUlps,
4418             _shareholderRights
4419         );
4420     }
4421 
4422     function capTable()
4423         public
4424         constant
4425         returns (
4426             address[] equityTokens,
4427             uint256[] shares
4428         )
4429     {
4430         // no cap table before ETO completed
4431         if (_state == GovState.Setup || _state == GovState.Offering) {
4432             return;
4433         }
4434         equityTokens = new address[](1);
4435         shares = new uint256[](1);
4436 
4437         equityTokens[0] = _equityToken;
4438         shares[0] = _equityToken.sharesTotalSupply();
4439     }
4440 
4441     function tokenOfferings()
4442         public
4443         constant
4444         returns (
4445             address[] offerings,
4446             address[] equityTokens
4447         )
4448     {
4449         // no offerings in setup mode
4450         if (_state == GovState.Setup) {
4451             return;
4452         }
4453         offerings = new address[](1);
4454         equityTokens = new address[](1);
4455 
4456         equityTokens[0] = _equityToken;
4457         offerings[0] = _commitment;
4458     }
4459 
4460     function issueGeneralInformation(
4461         string informationType,
4462         string informationUrl
4463     )
4464         public
4465         onlyOperational
4466         onlyCompany
4467     {
4468         // we emit this as Ethereum event, no need to store this in contract storage
4469         emit LogGeneralInformation(COMPANY_LEGAL_REPRESENTATIVE, informationType, informationUrl);
4470     }
4471 
4472     function startResolution(string /*title*/, string /*resolutionUri*/, Action /*action*/, bytes /*payload*/)
4473         public
4474         onlyStates(GovState.Offering, GovState.Funded)
4475         onlyCompany
4476         returns (bytes32 /*resolutionId*/)
4477     {
4478         revert("NF_NOT_IMPL");
4479     }
4480 
4481 
4482     function executeResolution(bytes32 /*resolutionId*/)
4483         public
4484         onlyOperational
4485     {
4486         revert("NF_NOT_IMPL");
4487     }
4488 
4489     function closeCompany()
4490         public
4491         onlyState(GovState.Closing)
4492     {
4493         revert("NF_NOT_IMPL");
4494     }
4495 
4496     function cancelCompanyClosing()
4497         public
4498         onlyState(GovState.Closing)
4499     {
4500         revert("NF_NOT_IMPL");
4501     }
4502 
4503     function changeTokenController(address newController)
4504         public
4505         onlyState(GovState.Funded)
4506         onlyCompany
4507     {
4508         require(newController != address(0));
4509         require(newController != address(this));
4510         _newController = newController;
4511         transitionTo(GovState.Migrated);
4512         emit LogResolutionExecuted(0, Action.ChangeTokenController);
4513         emit LogMigratedTokenController(0, newController);
4514     }
4515 
4516     function newTokenController()
4517         public
4518         constant
4519         returns (address)
4520     {
4521         // _newController is set only in Migrated state, otherwise zero address is returned as required
4522         return _newController;
4523     }
4524 
4525     function oldTokenController()
4526         public
4527         constant
4528         returns (address)
4529     {
4530         return address(0);
4531     }
4532 
4533     //
4534     // Implements ITokenController
4535     //
4536 
4537     function onTransfer(address broker, address from, address /*to*/, uint256 /*amount*/)
4538         public
4539         constant
4540         returns (bool allow)
4541     {
4542         return _transfersEnabled || (from == _commitment && broker == from);
4543     }
4544 
4545     /// always approve
4546     function onApprove(address, address, uint256)
4547         public
4548         constant
4549         returns (bool allow)
4550     {
4551         return true;
4552     }
4553 
4554     function onGenerateTokens(address sender, address, uint256)
4555         public
4556         constant
4557         returns (bool allow)
4558     {
4559         return sender == _commitment && _state == GovState.Offering;
4560     }
4561 
4562     function onDestroyTokens(address sender, address, uint256)
4563         public
4564         constant
4565         returns (bool allow)
4566     {
4567         return sender == _commitment && _state == GovState.Offering;
4568     }
4569 
4570     function onChangeTokenController(address /*sender*/, address newController)
4571         public
4572         constant
4573         returns (bool)
4574     {
4575         return newController == _newController;
4576     }
4577 
4578     // no forced transfers allowed in this controller
4579     function onAllowance(address /*owner*/, address /*spender*/)
4580         public
4581         constant
4582         returns (uint256)
4583     {
4584         return 0;
4585     }
4586 
4587     //
4588     // Implements IEquityTokenController
4589     //
4590 
4591     function onChangeNominee(address, address, address)
4592         public
4593         constant
4594         returns (bool)
4595     {
4596         return false;
4597     }
4598 
4599     //
4600     // IERC223TokenCallback (proceeds disbursal)
4601     //
4602 
4603     /// allows contract to receive and distribure proceeds
4604     function tokenFallback(address, uint256, bytes)
4605         public
4606     {
4607         revert("NF_NOT_IMPL");
4608     }
4609 
4610     //
4611     // Implements IETOCommitmentObserver
4612     //
4613 
4614     function commitmentObserver() public
4615         constant
4616         returns (address)
4617     {
4618         return _commitment;
4619     }
4620 
4621     function onStateTransition(ETOState, ETOState newState)
4622         public
4623         onlyUniverseETO
4624     {
4625         if (newState == ETOState.Whitelist) {
4626             require(_state == GovState.Setup, "NF_ETC_BAD_STATE");
4627             registerTokenOfferingPrivate(IETOCommitment(msg.sender));
4628             return;
4629         }
4630         // must be same eto that started offering
4631         require(msg.sender == _commitment, "NF_ETC_UNREG_COMMITMENT");
4632         if (newState == ETOState.Claim) {
4633             require(_state == GovState.Offering, "NF_ETC_BAD_STATE");
4634             aproveTokenOfferingPrivate(IETOCommitment(msg.sender));
4635         }
4636         if (newState == ETOState.Refund) {
4637             require(_state == GovState.Offering, "NF_ETC_BAD_STATE");
4638             failTokenOfferingPrivate(IETOCommitment(msg.sender));
4639         }
4640     }
4641 
4642     //
4643     // Implements IContractId
4644     //
4645 
4646     function contractId() public pure returns (bytes32 id, uint256 version) {
4647         return (0xf7e00d1a4168be33cbf27d32a37a5bc694b3a839684a8c2bef236e3594345d70, 0);
4648     }
4649 
4650     ////////////////////////
4651     // Internal functions
4652     ////////////////////////
4653 
4654     function newOffering(IEquityToken equityToken, address tokenOffering)
4655         internal
4656     {
4657         _equityToken = equityToken;
4658         _commitment = tokenOffering;
4659 
4660         emit LogResolutionExecuted(0, Action.RegisterOffer);
4661         emit LogOfferingRegistered(0, tokenOffering, equityToken);
4662     }
4663 
4664     function amendISHA(
4665         string memory ISHAUrl,
4666         uint256 totalShares,
4667         uint256 companyValuationEurUlps,
4668         ShareholderRights newShareholderRights
4669     )
4670         internal
4671     {
4672         // set ISHA. use this.<> to call externally so msg.sender is correct in mCanAmend
4673         this.amendAgreement(ISHAUrl);
4674         // set new number of shares
4675         _totalCompanyShares = totalShares;
4676         // set new valuation
4677         _companyValuationEurUlps = companyValuationEurUlps;
4678         // set shareholder rights corresponding to SHA part of ISHA
4679         _shareholderRights = newShareholderRights;
4680         emit LogResolutionExecuted(0, Action.AmendISHA);
4681         emit LogISHAAmended(0, ISHAUrl, totalShares, companyValuationEurUlps, newShareholderRights);
4682     }
4683 
4684     function enableTransfers(bool transfersEnabled)
4685         internal
4686     {
4687         if (_transfersEnabled != transfersEnabled) {
4688             _transfersEnabled = transfersEnabled;
4689         }
4690         emit LogResolutionExecuted(0, transfersEnabled ? Action.ContinueToken : Action.StopToken);
4691         emit LogTransfersStateChanged(0, _equityToken, transfersEnabled);
4692     }
4693 
4694     function transitionTo(GovState newState)
4695         internal
4696     {
4697         emit LogGovStateTransition(uint32(_state), uint32(newState), uint32(block.timestamp));
4698         _state = newState;
4699     }
4700 
4701     //
4702     // Overrides Agreement
4703     //
4704 
4705     function mCanAmend(address legalRepresentative)
4706         internal
4707         returns (bool)
4708     {
4709         // only this contract can amend ISHA typically due to resolution
4710         return legalRepresentative == address(this);
4711     }
4712 
4713     ////////////////////////
4714     // Private functions
4715     ////////////////////////
4716 
4717     function registerTokenOfferingPrivate(IETOCommitment tokenOffering)
4718         private
4719     {
4720         IEquityToken equityToken = tokenOffering.equityToken();
4721         // require nominee match and agreement signature
4722         (address nomineeToken,,,) = equityToken.currentAgreement();
4723         // require token controller match
4724         require(equityToken.tokenController() == address(this), "NF_NDT_ET_TC_MIS");
4725         // require nominee and agreement match
4726         (address nomineOffering,,,) = tokenOffering.currentAgreement();
4727         require(nomineOffering == nomineeToken, "NF_NDT_ETO_A_MIS");
4728         // require terms set and legalRep match
4729         require(tokenOffering.etoTerms() != address(0), "NF_NDT_ETO_NO_TERMS");
4730         require(tokenOffering.companyLegalRep() == COMPANY_LEGAL_REPRESENTATIVE, "NF_NDT_ETO_LREP_MIS");
4731 
4732         newOffering(equityToken, tokenOffering);
4733         transitionTo(GovState.Offering);
4734     }
4735 
4736     function aproveTokenOfferingPrivate(IETOCommitment tokenOffering)
4737         private
4738     {
4739         // execute pending resolutions on completed ETO
4740         (uint256 newShares,,,,,,,) = tokenOffering.contributionSummary();
4741         uint256 totalShares = tokenOffering.etoTerms().EXISTING_COMPANY_SHARES() + newShares;
4742         uint256 marginalTokenPrice = tokenOffering.etoTerms().TOKEN_TERMS().TOKEN_PRICE_EUR_ULPS();
4743         string memory ISHAUrl = tokenOffering.signedInvestmentAgreementUrl();
4744         // set new ISHA, increase number of shares, company valuations and establish shareholder rights matrix
4745         amendISHA(
4746             ISHAUrl,
4747             totalShares,
4748             totalShares * marginalTokenPrice * tokenOffering.etoTerms().TOKEN_TERMS().EQUITY_TOKENS_PER_SHARE(),
4749             tokenOffering.etoTerms().SHAREHOLDER_RIGHTS()
4750         );
4751         // enable/disable transfers per ETO Terms
4752         enableTransfers(tokenOffering.etoTerms().ENABLE_TRANSFERS_ON_SUCCESS());
4753         // move state to funded
4754         transitionTo(GovState.Funded);
4755         emit LogOfferingSucceeded(tokenOffering, tokenOffering.equityToken(), newShares);
4756     }
4757 
4758     function failTokenOfferingPrivate(IETOCommitment tokenOffering)
4759         private
4760     {
4761         // we failed. may try again
4762         _equityToken = IEquityToken(0);
4763         _commitment = IETOCommitment(0);
4764         _totalCompanyShares = 0;
4765         _companyValuationEurUlps = 0;
4766         transitionTo(GovState.Setup);
4767         emit LogOfferingFailed(tokenOffering, tokenOffering.equityToken());
4768     }
4769 }