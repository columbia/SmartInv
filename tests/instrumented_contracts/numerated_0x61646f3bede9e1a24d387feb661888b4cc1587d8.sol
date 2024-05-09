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
495 contract IsContract {
496 
497     ////////////////////////
498     // Internal functions
499     ////////////////////////
500 
501     function isContract(address addr)
502         internal
503         constant
504         returns (bool)
505     {
506         uint256 size;
507         // takes 700 gas
508         assembly { size := extcodesize(addr) }
509         return size > 0;
510     }
511 }
512 
513 contract ITokenMetadata {
514 
515     ////////////////////////
516     // Public functions
517     ////////////////////////
518 
519     function symbol()
520         public
521         constant
522         returns (string);
523 
524     function name()
525         public
526         constant
527         returns (string);
528 
529     function decimals()
530         public
531         constant
532         returns (uint8);
533 }
534 
535 /// @title adds token metadata to token contract
536 /// @dev see Neumark for example implementation
537 contract TokenMetadata is ITokenMetadata {
538 
539     ////////////////////////
540     // Immutable state
541     ////////////////////////
542 
543     // The Token's name: e.g. DigixDAO Tokens
544     string private NAME;
545 
546     // An identifier: e.g. REP
547     string private SYMBOL;
548 
549     // Number of decimals of the smallest unit
550     uint8 private DECIMALS;
551 
552     // An arbitrary versioning scheme
553     string private VERSION;
554 
555     ////////////////////////
556     // Constructor
557     ////////////////////////
558 
559     /// @notice Constructor to set metadata
560     /// @param tokenName Name of the new token
561     /// @param decimalUnits Number of decimals of the new token
562     /// @param tokenSymbol Token Symbol for the new token
563     /// @param version Token version ie. when cloning is used
564     constructor(
565         string tokenName,
566         uint8 decimalUnits,
567         string tokenSymbol,
568         string version
569     )
570         public
571     {
572         NAME = tokenName;                                 // Set the name
573         SYMBOL = tokenSymbol;                             // Set the symbol
574         DECIMALS = decimalUnits;                          // Set the decimals
575         VERSION = version;
576     }
577 
578     ////////////////////////
579     // Public functions
580     ////////////////////////
581 
582     function name()
583         public
584         constant
585         returns (string)
586     {
587         return NAME;
588     }
589 
590     function symbol()
591         public
592         constant
593         returns (string)
594     {
595         return SYMBOL;
596     }
597 
598     function decimals()
599         public
600         constant
601         returns (uint8)
602     {
603         return DECIMALS;
604     }
605 
606     function version()
607         public
608         constant
609         returns (string)
610     {
611         return VERSION;
612     }
613 }
614 
615 contract IBasicToken {
616 
617     ////////////////////////
618     // Events
619     ////////////////////////
620 
621     event Transfer(
622         address indexed from,
623         address indexed to,
624         uint256 amount
625     );
626 
627     ////////////////////////
628     // Public functions
629     ////////////////////////
630 
631     /// @dev This function makes it easy to get the total number of tokens
632     /// @return The total number of tokens
633     function totalSupply()
634         public
635         constant
636         returns (uint256);
637 
638     /// @param owner The address that's balance is being requested
639     /// @return The balance of `owner` at the current block
640     function balanceOf(address owner)
641         public
642         constant
643         returns (uint256 balance);
644 
645     /// @notice Send `amount` tokens to `to` from `msg.sender`
646     /// @param to The address of the recipient
647     /// @param amount The amount of tokens to be transferred
648     /// @return Whether the transfer was successful or not
649     function transfer(address to, uint256 amount)
650         public
651         returns (bool success);
652 
653 }
654 
655 contract IERC20Allowance {
656 
657     ////////////////////////
658     // Events
659     ////////////////////////
660 
661     event Approval(
662         address indexed owner,
663         address indexed spender,
664         uint256 amount
665     );
666 
667     ////////////////////////
668     // Public functions
669     ////////////////////////
670 
671     /// @dev This function makes it easy to read the `allowed[]` map
672     /// @param owner The address of the account that owns the token
673     /// @param spender The address of the account able to transfer the tokens
674     /// @return Amount of remaining tokens of owner that spender is allowed
675     ///  to spend
676     function allowance(address owner, address spender)
677         public
678         constant
679         returns (uint256 remaining);
680 
681     /// @notice `msg.sender` approves `spender` to spend `amount` tokens on
682     ///  its behalf. This is a modified version of the ERC20 approve function
683     ///  to be a little bit safer
684     /// @param spender The address of the account able to transfer the tokens
685     /// @param amount The amount of tokens to be approved for transfer
686     /// @return True if the approval was successful
687     function approve(address spender, uint256 amount)
688         public
689         returns (bool success);
690 
691     /// @notice Send `amount` tokens to `to` from `from` on the condition it
692     ///  is approved by `from`
693     /// @param from The address holding the tokens being transferred
694     /// @param to The address of the recipient
695     /// @param amount The amount of tokens to be transferred
696     /// @return True if the transfer was successful
697     function transferFrom(address from, address to, uint256 amount)
698         public
699         returns (bool success);
700 
701 }
702 
703 contract IERC20Token is IBasicToken, IERC20Allowance {
704 
705 }
706 
707 contract IERC677Callback {
708 
709     ////////////////////////
710     // Public functions
711     ////////////////////////
712 
713     // NOTE: This call can be initiated by anyone. You need to make sure that
714     // it is send by the token (`require(msg.sender == token)`) or make sure
715     // amount is valid (`require(token.allowance(this) >= amount)`).
716     function receiveApproval(
717         address from,
718         uint256 amount,
719         address token, // IERC667Token
720         bytes data
721     )
722         public
723         returns (bool success);
724 
725 }
726 
727 contract IERC677Allowance is IERC20Allowance {
728 
729     ////////////////////////
730     // Public functions
731     ////////////////////////
732 
733     /// @notice `msg.sender` approves `spender` to send `amount` tokens on
734     ///  its behalf, and then a function is triggered in the contract that is
735     ///  being approved, `spender`. This allows users to use their tokens to
736     ///  interact with contracts in one function call instead of two
737     /// @param spender The address of the contract able to transfer the tokens
738     /// @param amount The amount of tokens to be approved for transfer
739     /// @return True if the function call was successful
740     function approveAndCall(address spender, uint256 amount, bytes extraData)
741         public
742         returns (bool success);
743 
744 }
745 
746 contract IERC677Token is IERC20Token, IERC677Allowance {
747 }
748 
749 contract Math {
750 
751     ////////////////////////
752     // Internal functions
753     ////////////////////////
754 
755     // absolute difference: |v1 - v2|
756     function absDiff(uint256 v1, uint256 v2)
757         internal
758         pure
759         returns(uint256)
760     {
761         return v1 > v2 ? v1 - v2 : v2 - v1;
762     }
763 
764     // divide v by d, round up if remainder is 0.5 or more
765     function divRound(uint256 v, uint256 d)
766         internal
767         pure
768         returns(uint256)
769     {
770         return add(v, d/2) / d;
771     }
772 
773     // computes decimal decimalFraction 'frac' of 'amount' with maximum precision (multiplication first)
774     // both amount and decimalFraction must have 18 decimals precision, frac 10**18 represents a whole (100% of) amount
775     // mind loss of precision as decimal fractions do not have finite binary expansion
776     // do not use instead of division
777     function decimalFraction(uint256 amount, uint256 frac)
778         internal
779         pure
780         returns(uint256)
781     {
782         // it's like 1 ether is 100% proportion
783         return proportion(amount, frac, 10**18);
784     }
785 
786     // computes part/total of amount with maximum precision (multiplication first)
787     // part and total must have the same units
788     function proportion(uint256 amount, uint256 part, uint256 total)
789         internal
790         pure
791         returns(uint256)
792     {
793         return divRound(mul(amount, part), total);
794     }
795 
796     //
797     // Open Zeppelin Math library below
798     //
799 
800     function mul(uint256 a, uint256 b)
801         internal
802         pure
803         returns (uint256)
804     {
805         uint256 c = a * b;
806         assert(a == 0 || c / a == b);
807         return c;
808     }
809 
810     function sub(uint256 a, uint256 b)
811         internal
812         pure
813         returns (uint256)
814     {
815         assert(b <= a);
816         return a - b;
817     }
818 
819     function add(uint256 a, uint256 b)
820         internal
821         pure
822         returns (uint256)
823     {
824         uint256 c = a + b;
825         assert(c >= a);
826         return c;
827     }
828 
829     function min(uint256 a, uint256 b)
830         internal
831         pure
832         returns (uint256)
833     {
834         return a < b ? a : b;
835     }
836 
837     function max(uint256 a, uint256 b)
838         internal
839         pure
840         returns (uint256)
841     {
842         return a > b ? a : b;
843     }
844 }
845 
846 /// @title internal token transfer function
847 /// @dev see BasicSnapshotToken for implementation
848 contract MTokenTransfer {
849 
850     ////////////////////////
851     // Internal functions
852     ////////////////////////
853 
854     /// @dev This is the actual transfer function in the token contract, it can
855     ///  only be called by other functions in this contract.
856     /// @param from The address holding the tokens being transferred
857     /// @param to The address of the recipient
858     /// @param amount The amount of tokens to be transferred
859     /// @dev  reverts if transfer was not successful
860     function mTransfer(
861         address from,
862         address to,
863         uint256 amount
864     )
865         internal;
866 }
867 
868 /// @title controls token transfers
869 /// @dev BasicSnapshotToken observes this interface, Neumark contract implements it
870 contract MTokenTransferController {
871 
872     ////////////////////////
873     // Internal functions
874     ////////////////////////
875 
876     /// @notice Notifies the controller about a token transfer allowing the
877     ///  controller to react if desired
878     /// @param from The origin of the transfer
879     /// @param to The destination of the transfer
880     /// @param amount The amount of the transfer
881     /// @return False if the controller does not authorize the transfer
882     function mOnTransfer(
883         address from,
884         address to,
885         uint256 amount
886     )
887         internal
888         returns (bool allow);
889 
890 }
891 
892 /**
893  * @title Basic token
894  * @dev Basic version of StandardToken, with no allowances.
895  */
896 contract BasicToken is
897     MTokenTransfer,
898     MTokenTransferController,
899     IBasicToken,
900     Math
901 {
902 
903     ////////////////////////
904     // Mutable state
905     ////////////////////////
906 
907     mapping(address => uint256) internal _balances;
908 
909     uint256 internal _totalSupply;
910 
911     ////////////////////////
912     // Public functions
913     ////////////////////////
914 
915     /**
916     * @dev transfer token for a specified address
917     * @param to The address to transfer to.
918     * @param amount The amount to be transferred.
919     */
920     function transfer(address to, uint256 amount)
921         public
922         returns (bool)
923     {
924         mTransfer(msg.sender, to, amount);
925         return true;
926     }
927 
928     /// @dev This function makes it easy to get the total number of tokens
929     /// @return The total number of tokens
930     function totalSupply()
931         public
932         constant
933         returns (uint256)
934     {
935         return _totalSupply;
936     }
937 
938     /**
939     * @dev Gets the balance of the specified address.
940     * @param owner The address to query the the balance of.
941     * @return An uint256 representing the amount owned by the passed address.
942     */
943     function balanceOf(address owner)
944         public
945         constant
946         returns (uint256 balance)
947     {
948         return _balances[owner];
949     }
950 
951     ////////////////////////
952     // Internal functions
953     ////////////////////////
954 
955     //
956     // Implements MTokenTransfer
957     //
958 
959     function mTransfer(address from, address to, uint256 amount)
960         internal
961     {
962         require(to != address(0));
963         require(mOnTransfer(from, to, amount));
964 
965         _balances[from] = sub(_balances[from], amount);
966         _balances[to] = add(_balances[to], amount);
967         emit Transfer(from, to, amount);
968     }
969 }
970 
971 /// @title controls spending approvals
972 /// @dev TokenAllowance observes this interface, Neumark contract implements it
973 contract MTokenAllowanceController {
974 
975     ////////////////////////
976     // Internal functions
977     ////////////////////////
978 
979     /// @notice Notifies the controller about an approval allowing the
980     ///  controller to react if desired
981     /// @param owner The address that calls `approve()`
982     /// @param spender The spender in the `approve()` call
983     /// @param amount The amount in the `approve()` call
984     /// @return False if the controller does not authorize the approval
985     function mOnApprove(
986         address owner,
987         address spender,
988         uint256 amount
989     )
990         internal
991         returns (bool allow);
992 
993     /// @notice Allows to override allowance approved by the owner
994     ///         Primary role is to enable forced transfers, do not override if you do not like it
995     ///         Following behavior is expected in the observer
996     ///         approve() - should revert if mAllowanceOverride() > 0
997     ///         allowance() - should return mAllowanceOverride() if set
998     ///         transferFrom() - should override allowance if mAllowanceOverride() > 0
999     /// @param owner An address giving allowance to spender
1000     /// @param spender An address getting  a right to transfer allowance amount from the owner
1001     /// @return current allowance amount
1002     function mAllowanceOverride(
1003         address owner,
1004         address spender
1005     )
1006         internal
1007         constant
1008         returns (uint256 allowance);
1009 }
1010 
1011 /// @title token spending approval and transfer
1012 /// @dev implements token approval and transfers and exposes relevant part of ERC20 and ERC677 approveAndCall
1013 ///     may be mixed in with any basic token (implementing mTransfer) like BasicSnapshotToken or MintableSnapshotToken to add approval mechanism
1014 ///     observes MTokenAllowanceController interface
1015 ///     observes MTokenTransfer
1016 contract TokenAllowance is
1017     MTokenTransfer,
1018     MTokenAllowanceController,
1019     IERC20Allowance,
1020     IERC677Token
1021 {
1022 
1023     ////////////////////////
1024     // Mutable state
1025     ////////////////////////
1026 
1027     // `allowed` tracks rights to spends others tokens as per ERC20
1028     // owner => spender => amount
1029     mapping (address => mapping (address => uint256)) private _allowed;
1030 
1031     ////////////////////////
1032     // Constructor
1033     ////////////////////////
1034 
1035     constructor()
1036         internal
1037     {
1038     }
1039 
1040     ////////////////////////
1041     // Public functions
1042     ////////////////////////
1043 
1044     //
1045     // Implements IERC20Token
1046     //
1047 
1048     /// @dev This function makes it easy to read the `allowed[]` map
1049     /// @param owner The address of the account that owns the token
1050     /// @param spender The address of the account able to transfer the tokens
1051     /// @return Amount of remaining tokens of _owner that _spender is allowed
1052     ///  to spend
1053     function allowance(address owner, address spender)
1054         public
1055         constant
1056         returns (uint256 remaining)
1057     {
1058         uint256 override = mAllowanceOverride(owner, spender);
1059         if (override > 0) {
1060             return override;
1061         }
1062         return _allowed[owner][spender];
1063     }
1064 
1065     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
1066     ///  its behalf. This is a modified version of the ERC20 approve function
1067     ///  where allowance per spender must be 0 to allow change of such allowance
1068     /// @param spender The address of the account able to transfer the tokens
1069     /// @param amount The amount of tokens to be approved for transfer
1070     /// @return True or reverts, False is never returned
1071     function approve(address spender, uint256 amount)
1072         public
1073         returns (bool success)
1074     {
1075         // Alerts the token controller of the approve function call
1076         require(mOnApprove(msg.sender, spender, amount));
1077 
1078         // To change the approve amount you first have to reduce the addresses`
1079         //  allowance to zero by calling `approve(_spender,0)` if it is not
1080         //  already 0 to mitigate the race condition described here:
1081         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1082         require((amount == 0 || _allowed[msg.sender][spender] == 0) && mAllowanceOverride(msg.sender, spender) == 0);
1083 
1084         _allowed[msg.sender][spender] = amount;
1085         emit Approval(msg.sender, spender, amount);
1086         return true;
1087     }
1088 
1089     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
1090     ///  is approved by `_from`
1091     /// @param from The address holding the tokens being transferred
1092     /// @param to The address of the recipient
1093     /// @param amount The amount of tokens to be transferred
1094     /// @return True if the transfer was successful, reverts in any other case
1095     function transferFrom(address from, address to, uint256 amount)
1096         public
1097         returns (bool success)
1098     {
1099         uint256 allowed = mAllowanceOverride(from, msg.sender);
1100         if (allowed == 0) {
1101             // The standard ERC 20 transferFrom functionality
1102             allowed = _allowed[from][msg.sender];
1103             // yes this will underflow but then we'll revert. will cost gas however so don't underflow
1104             _allowed[from][msg.sender] -= amount;
1105         }
1106         require(allowed >= amount);
1107         mTransfer(from, to, amount);
1108         return true;
1109     }
1110 
1111     //
1112     // Implements IERC677Token
1113     //
1114 
1115     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
1116     ///  its behalf, and then a function is triggered in the contract that is
1117     ///  being approved, `_spender`. This allows users to use their tokens to
1118     ///  interact with contracts in one function call instead of two
1119     /// @param spender The address of the contract able to transfer the tokens
1120     /// @param amount The amount of tokens to be approved for transfer
1121     /// @return True or reverts, False is never returned
1122     function approveAndCall(
1123         address spender,
1124         uint256 amount,
1125         bytes extraData
1126     )
1127         public
1128         returns (bool success)
1129     {
1130         require(approve(spender, amount));
1131 
1132         success = IERC677Callback(spender).receiveApproval(
1133             msg.sender,
1134             amount,
1135             this,
1136             extraData
1137         );
1138         require(success);
1139 
1140         return true;
1141     }
1142 
1143     ////////////////////////
1144     // Internal functions
1145     ////////////////////////
1146 
1147     //
1148     // Implements default MTokenAllowanceController
1149     //
1150 
1151     // no override in default implementation
1152     function mAllowanceOverride(
1153         address /*owner*/,
1154         address /*spender*/
1155     )
1156         internal
1157         constant
1158         returns (uint256)
1159     {
1160         return 0;
1161     }
1162 }
1163 
1164 /**
1165  * @title Standard ERC20 token
1166  *
1167  * @dev Implementation of the standard token.
1168  * @dev https://github.com/ethereum/EIPs/issues/20
1169  */
1170 contract StandardToken is
1171     IERC20Token,
1172     BasicToken,
1173     TokenAllowance
1174 {
1175 
1176 }
1177 
1178 /// @title uniquely identifies deployable (non-abstract) platform contract
1179 /// @notice cheap way of assigning implementations to knownInterfaces which represent system services
1180 ///         unfortunatelly ERC165 does not include full public interface (ABI) and does not provide way to list implemented interfaces
1181 ///         EIP820 still in the making
1182 /// @dev ids are generated as follows keccak256("neufund-platform:<contract name>")
1183 ///      ids roughly correspond to ABIs
1184 contract IContractId {
1185     /// @param id defined as above
1186     /// @param version implementation version
1187     function contractId() public pure returns (bytes32 id, uint256 version);
1188 }
1189 
1190 /// @title current ERC223 fallback function
1191 /// @dev to be used in all future token contract
1192 /// @dev NEU and ICBMEtherToken (obsolete) are the only contracts that still uses IERC223LegacyCallback
1193 contract IERC223Callback {
1194 
1195     ////////////////////////
1196     // Public functions
1197     ////////////////////////
1198 
1199     function tokenFallback(address from, uint256 amount, bytes data)
1200         public;
1201 
1202 }
1203 
1204 contract IERC223Token is IERC20Token, ITokenMetadata {
1205 
1206     /// @dev Departure: We do not log data, it has no advantage over a standard
1207     ///     log event. By sticking to the standard log event we
1208     ///     stay compatible with constracts that expect and ERC20 token.
1209 
1210     // event Transfer(
1211     //    address indexed from,
1212     //    address indexed to,
1213     //    uint256 amount,
1214     //    bytes data);
1215 
1216 
1217     /// @dev Departure: We do not use the callback on regular transfer calls to
1218     ///     stay compatible with constracts that expect and ERC20 token.
1219 
1220     // function transfer(address to, uint256 amount)
1221     //     public
1222     //     returns (bool);
1223 
1224     ////////////////////////
1225     // Public functions
1226     ////////////////////////
1227 
1228     function transfer(address to, uint256 amount, bytes data)
1229         public
1230         returns (bool);
1231 }
1232 
1233 /// @title granular token controller based on MSnapshotToken observer pattern
1234 contract ITokenController {
1235 
1236     ////////////////////////
1237     // Public functions
1238     ////////////////////////
1239 
1240     /// @notice see MTokenTransferController
1241     /// @dev additionally passes broker that is executing transaction between from and to
1242     ///      for unbrokered transfer, broker == from
1243     function onTransfer(address broker, address from, address to, uint256 amount)
1244         public
1245         constant
1246         returns (bool allow);
1247 
1248     /// @notice see MTokenAllowanceController
1249     function onApprove(address owner, address spender, uint256 amount)
1250         public
1251         constant
1252         returns (bool allow);
1253 
1254     /// @notice see MTokenMint
1255     function onGenerateTokens(address sender, address owner, uint256 amount)
1256         public
1257         constant
1258         returns (bool allow);
1259 
1260     /// @notice see MTokenMint
1261     function onDestroyTokens(address sender, address owner, uint256 amount)
1262         public
1263         constant
1264         returns (bool allow);
1265 
1266     /// @notice controls if sender can change controller to newController
1267     /// @dev for this to succeed TYPICALLY current controller must be already migrated to a new one
1268     function onChangeTokenController(address sender, address newController)
1269         public
1270         constant
1271         returns (bool);
1272 
1273     /// @notice overrides spender allowance
1274     /// @dev may be used to implemented forced transfers in which token controller may override approved allowance
1275     ///      with any > 0 value and then use transferFrom to execute such transfer
1276     ///      This by definition creates non-trustless token so do not implement this call if you do not need trustless transfers!
1277     ///      Implementer should not allow approve() to be executed if there is an overrride
1278     //       Implemented should return allowance() taking into account override
1279     function onAllowance(address owner, address spender)
1280         public
1281         constant
1282         returns (uint256 allowanceOverride);
1283 }
1284 
1285 /// @title hooks token controller to token contract and allows to replace it
1286 contract ITokenControllerHook {
1287 
1288     ////////////////////////
1289     // Events
1290     ////////////////////////
1291 
1292     event LogChangeTokenController(
1293         address oldController,
1294         address newController,
1295         address by
1296     );
1297 
1298     ////////////////////////
1299     // Public functions
1300     ////////////////////////
1301 
1302     /// @notice replace current token controller
1303     /// @dev please note that this process is also controlled by existing controller
1304     function changeTokenController(address newController)
1305         public;
1306 
1307     /// @notice returns current controller
1308     function tokenController()
1309         public
1310         constant
1311         returns (address currentController);
1312 
1313 }
1314 
1315 contract IWithdrawableToken {
1316 
1317     ////////////////////////
1318     // Public functions
1319     ////////////////////////
1320 
1321     /// @notice withdraws from a token holding assets
1322     /// @dev amount of asset should be returned to msg.sender and corresponding balance burned
1323     function withdraw(uint256 amount)
1324         public;
1325 }
1326 
1327 contract EuroToken is
1328     Agreement,
1329     IERC677Token,
1330     StandardToken,
1331     IWithdrawableToken,
1332     ITokenControllerHook,
1333     TokenMetadata,
1334     IERC223Token,
1335     IsContract,
1336     IContractId
1337 {
1338     ////////////////////////
1339     // Constants
1340     ////////////////////////
1341 
1342     string private constant NAME = "Euro Token";
1343 
1344     string private constant SYMBOL = "EUR-T";
1345 
1346     uint8 private constant DECIMALS = 18;
1347 
1348     ////////////////////////
1349     // Mutable state
1350     ////////////////////////
1351 
1352     ITokenController private _tokenController;
1353 
1354     ////////////////////////
1355     // Events
1356     ////////////////////////
1357 
1358     /// on each deposit (increase of supply) of EUR-T
1359     /// 'by' indicates account that executed the deposit function for 'to' (typically bank connector)
1360     event LogDeposit(
1361         address indexed to,
1362         address by,
1363         uint256 amount,
1364         bytes32 reference
1365     );
1366 
1367     // proof of requested deposit initiated by token holder
1368     event LogWithdrawal(
1369         address indexed from,
1370         uint256 amount
1371     );
1372 
1373     // proof of settled deposit
1374     event LogWithdrawSettled(
1375         address from,
1376         address by, // who settled
1377         uint256 amount, // settled amount, after fees, negative interest rates etc.
1378         uint256 originalAmount, // original amount withdrawn
1379         bytes32 withdrawTxHash, // hash of withdraw transaction
1380         bytes32 reference // reference number of withdraw operation at deposit manager
1381     );
1382 
1383     /// on destroying the tokens without withdraw (see `destroyTokens` function below)
1384     event LogDestroy(
1385         address indexed from,
1386         address by,
1387         uint256 amount
1388     );
1389 
1390     ////////////////////////
1391     // Modifiers
1392     ////////////////////////
1393 
1394     modifier onlyIfDepositAllowed(address to, uint256 amount) {
1395         require(_tokenController.onGenerateTokens(msg.sender, to, amount));
1396         _;
1397     }
1398 
1399     modifier onlyIfWithdrawAllowed(address from, uint256 amount) {
1400         require(_tokenController.onDestroyTokens(msg.sender, from, amount));
1401         _;
1402     }
1403 
1404     ////////////////////////
1405     // Constructor
1406     ////////////////////////
1407 
1408     constructor(
1409         IAccessPolicy accessPolicy,
1410         IEthereumForkArbiter forkArbiter,
1411         ITokenController tokenController
1412     )
1413         Agreement(accessPolicy, forkArbiter)
1414         StandardToken()
1415         TokenMetadata(NAME, DECIMALS, SYMBOL, "")
1416         public
1417     {
1418         require(tokenController != ITokenController(0x0));
1419         _tokenController = tokenController;
1420     }
1421 
1422     ////////////////////////
1423     // Public functions
1424     ////////////////////////
1425 
1426     /// @notice deposit 'amount' of EUR-T to address 'to', attaching correlating `reference` to LogDeposit event
1427     /// @dev deposit may happen only in case 'to' can receive transfer in token controller
1428     ///     by default KYC is required to receive deposits
1429     function deposit(address to, uint256 amount, bytes32 reference)
1430         public
1431         only(ROLE_EURT_DEPOSIT_MANAGER)
1432         onlyIfDepositAllowed(to, amount)
1433         acceptAgreement(to)
1434     {
1435         require(to != address(0));
1436         _balances[to] = add(_balances[to], amount);
1437         _totalSupply = add(_totalSupply, amount);
1438         emit LogDeposit(to, msg.sender, amount, reference);
1439         emit Transfer(address(0), to, amount);
1440     }
1441 
1442     /// @notice runs many deposits within one transaction
1443     /// @dev deposit may happen only in case 'to' can receive transfer in token controller
1444     ///     by default KYC is required to receive deposits
1445     function depositMany(address[] to, uint256[] amount, bytes32[] reference)
1446         public
1447     {
1448         require(to.length == amount.length);
1449         require(to.length == reference.length);
1450         for (uint256 i = 0; i < to.length; i++) {
1451             deposit(to[i], amount[i], reference[i]);
1452         }
1453     }
1454 
1455     /// @notice withdraws 'amount' of EUR-T by burning required amount and providing a proof of whithdrawal
1456     /// @dev proof is provided in form of log entry. based on that proof deposit manager will make a bank transfer
1457     ///     by default controller will check the following: KYC and existence of working bank account
1458     function withdraw(uint256 amount)
1459         public
1460         onlyIfWithdrawAllowed(msg.sender, amount)
1461         acceptAgreement(msg.sender)
1462     {
1463         destroyTokensPrivate(msg.sender, amount);
1464         emit LogWithdrawal(msg.sender, amount);
1465     }
1466 
1467     /// @notice issued by deposit manager when withdraw request was settled. typicaly amount that could be settled will be lower
1468     ///         than amount withdrawn: banks charge negative interest rates and various fees that must be deduced
1469     ///         reference number is attached that may be used to identify withdraw operation at deposit manager
1470     function settleWithdraw(address from, uint256 amount, uint256 originalAmount, bytes32 withdrawTxHash, bytes32 reference)
1471         public
1472         only(ROLE_EURT_DEPOSIT_MANAGER)
1473     {
1474         emit LogWithdrawSettled(from, msg.sender, amount, originalAmount, withdrawTxHash, reference);
1475     }
1476 
1477     /// @notice this method allows to destroy EUR-T belonging to any account
1478     ///     note that EURO is fiat currency and is not trustless, EUR-T is also
1479     ///     just internal currency of Neufund platform, not general purpose stable coin
1480     ///     we need to be able to destroy EUR-T if ordered by authorities
1481     function destroy(address owner, uint256 amount)
1482         public
1483         only(ROLE_EURT_LEGAL_MANAGER)
1484     {
1485         destroyTokensPrivate(owner, amount);
1486         emit LogDestroy(owner, msg.sender, amount);
1487     }
1488 
1489     //
1490     // Implements ITokenControllerHook
1491     //
1492 
1493     function changeTokenController(address newController)
1494         public
1495     {
1496         require(_tokenController.onChangeTokenController(msg.sender, newController));
1497         _tokenController = ITokenController(newController);
1498         emit LogChangeTokenController(_tokenController, newController, msg.sender);
1499     }
1500 
1501     function tokenController()
1502         public
1503         constant
1504         returns (address)
1505     {
1506         return _tokenController;
1507     }
1508 
1509     //
1510     // Implements IERC223Token
1511     //
1512     function transfer(address to, uint256 amount, bytes data)
1513         public
1514         returns (bool success)
1515     {
1516         return ierc223TransferInternal(msg.sender, to, amount, data);
1517     }
1518 
1519     /// @notice convenience function to deposit and immediately transfer amount
1520     /// @param depositTo which account to deposit to and then transfer from
1521     /// @param transferTo where to transfer after deposit
1522     /// @param depositAmount amount to deposit
1523     /// @param transferAmount total amount to transfer, must be <= balance after deposit
1524     /// @dev intended to deposit from bank account and invest in ETO
1525     function depositAndTransfer(
1526         address depositTo,
1527         address transferTo,
1528         uint256 depositAmount,
1529         uint256 transferAmount,
1530         bytes data,
1531         bytes32 reference
1532     )
1533         public
1534         returns (bool success)
1535     {
1536         deposit(depositTo, depositAmount, reference);
1537         return ierc223TransferInternal(depositTo, transferTo, transferAmount, data);
1538     }
1539 
1540     //
1541     // Implements IContractId
1542     //
1543 
1544     function contractId() public pure returns (bytes32 id, uint256 version) {
1545         return (0xfb5c7e43558c4f3f5a2d87885881c9b10ff4be37e3308579c178bf4eaa2c29cd, 0);
1546     }
1547 
1548     ////////////////////////
1549     // Internal functions
1550     ////////////////////////
1551 
1552     //
1553     // Implements MTokenController
1554     //
1555 
1556     function mOnTransfer(
1557         address from,
1558         address to,
1559         uint256 amount
1560     )
1561         internal
1562         acceptAgreement(from)
1563         returns (bool allow)
1564     {
1565         address broker = msg.sender;
1566         if (broker != from) {
1567             // if called by the depositor (deposit and send), ignore the broker flag
1568             bool isDepositor = accessPolicy().allowed(msg.sender, ROLE_EURT_DEPOSIT_MANAGER, this, msg.sig);
1569             // this is not very clean but alternative (give brokerage rights to all depositors) is maintenance hell
1570             if (isDepositor) {
1571                 broker = from;
1572             }
1573         }
1574         return _tokenController.onTransfer(broker, from, to, amount);
1575     }
1576 
1577     function mOnApprove(
1578         address owner,
1579         address spender,
1580         uint256 amount
1581     )
1582         internal
1583         acceptAgreement(owner)
1584         returns (bool allow)
1585     {
1586         return _tokenController.onApprove(owner, spender, amount);
1587     }
1588 
1589     function mAllowanceOverride(
1590         address owner,
1591         address spender
1592     )
1593         internal
1594         constant
1595         returns (uint256)
1596     {
1597         return _tokenController.onAllowance(owner, spender);
1598     }
1599 
1600     //
1601     // Observes MAgreement internal interface
1602     //
1603 
1604     /// @notice euro token is legally represented by separate entity ROLE_EURT_LEGAL_MANAGER
1605     function mCanAmend(address legalRepresentative)
1606         internal
1607         returns (bool)
1608     {
1609         return accessPolicy().allowed(legalRepresentative, ROLE_EURT_LEGAL_MANAGER, this, msg.sig);
1610     }
1611 
1612     ////////////////////////
1613     // Private functions
1614     ////////////////////////
1615 
1616     function destroyTokensPrivate(address owner, uint256 amount)
1617         private
1618     {
1619         require(_balances[owner] >= amount);
1620         _balances[owner] = sub(_balances[owner], amount);
1621         _totalSupply = sub(_totalSupply, amount);
1622         emit Transfer(owner, address(0), amount);
1623     }
1624 
1625     /// @notice internal transfer function that checks permissions and calls the tokenFallback
1626     function ierc223TransferInternal(address from, address to, uint256 amount, bytes data)
1627         private
1628         returns (bool success)
1629     {
1630         BasicToken.mTransfer(from, to, amount);
1631 
1632         // Notify the receiving contract.
1633         if (isContract(to)) {
1634             // in case of re-entry (1) transfer is done (2) msg.sender is different
1635             IERC223Callback(to).tokenFallback(from, amount, data);
1636         }
1637         return true;
1638     }
1639 }