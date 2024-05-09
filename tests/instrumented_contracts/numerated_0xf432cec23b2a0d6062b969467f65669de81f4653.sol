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
398 contract IsContract {
399 
400     ////////////////////////
401     // Internal functions
402     ////////////////////////
403 
404     function isContract(address addr)
405         internal
406         constant
407         returns (bool)
408     {
409         uint256 size;
410         // takes 700 gas
411         assembly { size := extcodesize(addr) }
412         return size > 0;
413     }
414 }
415 
416 contract IBasicToken {
417 
418     ////////////////////////
419     // Events
420     ////////////////////////
421 
422     event Transfer(
423         address indexed from,
424         address indexed to,
425         uint256 amount);
426 
427     ////////////////////////
428     // Public functions
429     ////////////////////////
430 
431     /// @dev This function makes it easy to get the total number of tokens
432     /// @return The total number of tokens
433     function totalSupply()
434         public
435         constant
436         returns (uint256);
437 
438     /// @param owner The address that's balance is being requested
439     /// @return The balance of `owner` at the current block
440     function balanceOf(address owner)
441         public
442         constant
443         returns (uint256 balance);
444 
445     /// @notice Send `amount` tokens to `to` from `msg.sender`
446     /// @param to The address of the recipient
447     /// @param amount The amount of tokens to be transferred
448     /// @return Whether the transfer was successful or not
449     function transfer(address to, uint256 amount)
450         public
451         returns (bool success);
452 
453 }
454 
455 /// @title allows deriving contract to recover any token or ether that it has balance of
456 /// @notice note that this opens your contracts to claims from various people saying they lost tokens and they want them back
457 ///     be ready to handle such claims
458 /// @dev use with care!
459 ///     1. ROLE_RECLAIMER is allowed to claim tokens, it's not returning tokens to original owner
460 ///     2. in derived contract that holds any token by design you must override `reclaim` and block such possibility.
461 ///         see LockedAccount as an example
462 contract Reclaimable is AccessControlled, AccessRoles {
463 
464     ////////////////////////
465     // Constants
466     ////////////////////////
467 
468     IBasicToken constant internal RECLAIM_ETHER = IBasicToken(0x0);
469 
470     ////////////////////////
471     // Public functions
472     ////////////////////////
473 
474     function reclaim(IBasicToken token)
475         public
476         only(ROLE_RECLAIMER)
477     {
478         address reclaimer = msg.sender;
479         if(token == RECLAIM_ETHER) {
480             reclaimer.transfer(this.balance);
481         } else {
482             uint256 balance = token.balanceOf(this);
483             require(token.transfer(reclaimer, balance));
484         }
485     }
486 }
487 
488 contract ITokenMetadata {
489 
490     ////////////////////////
491     // Public functions
492     ////////////////////////
493 
494     function symbol()
495         public
496         constant
497         returns (string);
498 
499     function name()
500         public
501         constant
502         returns (string);
503 
504     function decimals()
505         public
506         constant
507         returns (uint8);
508 }
509 
510 /// @title adds token metadata to token contract
511 /// @dev see Neumark for example implementation
512 contract TokenMetadata is ITokenMetadata {
513 
514     ////////////////////////
515     // Immutable state
516     ////////////////////////
517 
518     // The Token's name: e.g. DigixDAO Tokens
519     string private NAME;
520 
521     // An identifier: e.g. REP
522     string private SYMBOL;
523 
524     // Number of decimals of the smallest unit
525     uint8 private DECIMALS;
526 
527     // An arbitrary versioning scheme
528     string private VERSION;
529 
530     ////////////////////////
531     // Constructor
532     ////////////////////////
533 
534     /// @notice Constructor to set metadata
535     /// @param tokenName Name of the new token
536     /// @param decimalUnits Number of decimals of the new token
537     /// @param tokenSymbol Token Symbol for the new token
538     /// @param version Token version ie. when cloning is used
539     function TokenMetadata(
540         string tokenName,
541         uint8 decimalUnits,
542         string tokenSymbol,
543         string version
544     )
545         public
546     {
547         NAME = tokenName;                                 // Set the name
548         SYMBOL = tokenSymbol;                             // Set the symbol
549         DECIMALS = decimalUnits;                          // Set the decimals
550         VERSION = version;
551     }
552 
553     ////////////////////////
554     // Public functions
555     ////////////////////////
556 
557     function name()
558         public
559         constant
560         returns (string)
561     {
562         return NAME;
563     }
564 
565     function symbol()
566         public
567         constant
568         returns (string)
569     {
570         return SYMBOL;
571     }
572 
573     function decimals()
574         public
575         constant
576         returns (uint8)
577     {
578         return DECIMALS;
579     }
580 
581     function version()
582         public
583         constant
584         returns (string)
585     {
586         return VERSION;
587     }
588 }
589 
590 contract IERC223Callback {
591 
592     ////////////////////////
593     // Public functions
594     ////////////////////////
595 
596     function onTokenTransfer(
597         address from,
598         uint256 amount,
599         bytes data
600     )
601         public;
602 
603 }
604 
605 contract IERC223Token is IBasicToken {
606 
607     /// @dev Departure: We do not log data, it has no advantage over a standard
608     ///     log event. By sticking to the standard log event we
609     ///     stay compatible with constracts that expect and ERC20 token.
610 
611     // event Transfer(
612     //    address indexed from,
613     //    address indexed to,
614     //    uint256 amount,
615     //    bytes data);
616 
617 
618     /// @dev Departure: We do not use the callback on regular transfer calls to
619     ///     stay compatible with constracts that expect and ERC20 token.
620 
621     // function transfer(address to, uint256 amount)
622     //     public
623     //     returns (bool);
624 
625     ////////////////////////
626     // Public functions
627     ////////////////////////
628 
629     function transfer(address to, uint256 amount, bytes data)
630         public
631         returns (bool);
632 }
633 
634 contract IERC20Allowance {
635 
636     ////////////////////////
637     // Events
638     ////////////////////////
639 
640     event Approval(
641         address indexed owner,
642         address indexed spender,
643         uint256 amount);
644 
645     ////////////////////////
646     // Public functions
647     ////////////////////////
648 
649     /// @dev This function makes it easy to read the `allowed[]` map
650     /// @param owner The address of the account that owns the token
651     /// @param spender The address of the account able to transfer the tokens
652     /// @return Amount of remaining tokens of owner that spender is allowed
653     ///  to spend
654     function allowance(address owner, address spender)
655         public
656         constant
657         returns (uint256 remaining);
658 
659     /// @notice `msg.sender` approves `spender` to spend `amount` tokens on
660     ///  its behalf. This is a modified version of the ERC20 approve function
661     ///  to be a little bit safer
662     /// @param spender The address of the account able to transfer the tokens
663     /// @param amount The amount of tokens to be approved for transfer
664     /// @return True if the approval was successful
665     function approve(address spender, uint256 amount)
666         public
667         returns (bool success);
668 
669     /// @notice Send `amount` tokens to `to` from `from` on the condition it
670     ///  is approved by `from`
671     /// @param from The address holding the tokens being transferred
672     /// @param to The address of the recipient
673     /// @param amount The amount of tokens to be transferred
674     /// @return True if the transfer was successful
675     function transferFrom(address from, address to, uint256 amount)
676         public
677         returns (bool success);
678 
679 }
680 
681 contract IERC20Token is IBasicToken, IERC20Allowance {
682 
683 }
684 
685 contract IERC677Callback {
686 
687     ////////////////////////
688     // Public functions
689     ////////////////////////
690 
691     // NOTE: This call can be initiated by anyone. You need to make sure that
692     // it is send by the token (`require(msg.sender == token)`) or make sure
693     // amount is valid (`require(token.allowance(this) >= amount)`).
694     function receiveApproval(
695         address from,
696         uint256 amount,
697         address token, // IERC667Token
698         bytes data
699     )
700         public
701         returns (bool success);
702 
703 }
704 
705 contract IERC677Allowance is IERC20Allowance {
706 
707     ////////////////////////
708     // Public functions
709     ////////////////////////
710 
711     /// @notice `msg.sender` approves `spender` to send `amount` tokens on
712     ///  its behalf, and then a function is triggered in the contract that is
713     ///  being approved, `spender`. This allows users to use their tokens to
714     ///  interact with contracts in one function call instead of two
715     /// @param spender The address of the contract able to transfer the tokens
716     /// @param amount The amount of tokens to be approved for transfer
717     /// @return True if the function call was successful
718     function approveAndCall(address spender, uint256 amount, bytes extraData)
719         public
720         returns (bool success);
721 
722 }
723 
724 contract IERC677Token is IERC20Token, IERC677Allowance {
725 }
726 
727 contract Math {
728 
729     ////////////////////////
730     // Internal functions
731     ////////////////////////
732 
733     // absolute difference: |v1 - v2|
734     function absDiff(uint256 v1, uint256 v2)
735         internal
736         constant
737         returns(uint256)
738     {
739         return v1 > v2 ? v1 - v2 : v2 - v1;
740     }
741 
742     // divide v by d, round up if remainder is 0.5 or more
743     function divRound(uint256 v, uint256 d)
744         internal
745         constant
746         returns(uint256)
747     {
748         return add(v, d/2) / d;
749     }
750 
751     // computes decimal decimalFraction 'frac' of 'amount' with maximum precision (multiplication first)
752     // both amount and decimalFraction must have 18 decimals precision, frac 10**18 represents a whole (100% of) amount
753     // mind loss of precision as decimal fractions do not have finite binary expansion
754     // do not use instead of division
755     function decimalFraction(uint256 amount, uint256 frac)
756         internal
757         constant
758         returns(uint256)
759     {
760         // it's like 1 ether is 100% proportion
761         return proportion(amount, frac, 10**18);
762     }
763 
764     // computes part/total of amount with maximum precision (multiplication first)
765     // part and total must have the same units
766     function proportion(uint256 amount, uint256 part, uint256 total)
767         internal
768         constant
769         returns(uint256)
770     {
771         return divRound(mul(amount, part), total);
772     }
773 
774     //
775     // Open Zeppelin Math library below
776     //
777 
778     function mul(uint256 a, uint256 b)
779         internal
780         constant
781         returns (uint256)
782     {
783         uint256 c = a * b;
784         assert(a == 0 || c / a == b);
785         return c;
786     }
787 
788     function sub(uint256 a, uint256 b)
789         internal
790         constant
791         returns (uint256)
792     {
793         assert(b <= a);
794         return a - b;
795     }
796 
797     function add(uint256 a, uint256 b)
798         internal
799         constant
800         returns (uint256)
801     {
802         uint256 c = a + b;
803         assert(c >= a);
804         return c;
805     }
806 
807     function min(uint256 a, uint256 b)
808         internal
809         constant
810         returns (uint256)
811     {
812         return a < b ? a : b;
813     }
814 
815     function max(uint256 a, uint256 b)
816         internal
817         constant
818         returns (uint256)
819     {
820         return a > b ? a : b;
821     }
822 }
823 
824 /**
825  * @title Basic token
826  * @dev Basic version of StandardToken, with no allowances.
827  */
828 contract BasicToken is IBasicToken, Math {
829 
830     ////////////////////////
831     // Mutable state
832     ////////////////////////
833 
834     mapping(address => uint256) internal _balances;
835 
836     uint256 internal _totalSupply;
837 
838     ////////////////////////
839     // Public functions
840     ////////////////////////
841 
842     /**
843     * @dev transfer token for a specified address
844     * @param to The address to transfer to.
845     * @param amount The amount to be transferred.
846     */
847     function transfer(address to, uint256 amount)
848         public
849         returns (bool)
850     {
851         transferInternal(msg.sender, to, amount);
852         return true;
853     }
854 
855     /// @dev This function makes it easy to get the total number of tokens
856     /// @return The total number of tokens
857     function totalSupply()
858         public
859         constant
860         returns (uint256)
861     {
862         return _totalSupply;
863     }
864 
865     /**
866     * @dev Gets the balance of the specified address.
867     * @param owner The address to query the the balance of.
868     * @return An uint256 representing the amount owned by the passed address.
869     */
870     function balanceOf(address owner)
871         public
872         constant
873         returns (uint256 balance)
874     {
875         return _balances[owner];
876     }
877 
878     ////////////////////////
879     // Internal functions
880     ////////////////////////
881 
882     // actual transfer function called by all public variants
883     function transferInternal(address from, address to, uint256 amount)
884         internal
885     {
886         require(to != address(0));
887 
888         _balances[from] = sub(_balances[from], amount);
889         _balances[to] = add(_balances[to], amount);
890         Transfer(from, to, amount);
891     }
892 }
893 
894 /**
895  * @title Standard ERC20 token
896  *
897  * @dev Implementation of the standard token.
898  * @dev https://github.com/ethereum/EIPs/issues/20
899  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
900  */
901 contract StandardToken is
902     IERC20Token,
903     BasicToken,
904     IERC677Token
905 {
906 
907     ////////////////////////
908     // Mutable state
909     ////////////////////////
910 
911     mapping (address => mapping (address => uint256)) private _allowed;
912 
913     ////////////////////////
914     // Public functions
915     ////////////////////////
916 
917     //
918     // Implements ERC20
919     //
920 
921     /**
922     * @dev Transfer tokens from one address to another
923     * @param from address The address which you want to send tokens from
924     * @param to address The address which you want to transfer to
925     * @param amount uint256 the amount of tokens to be transferred
926     */
927     function transferFrom(address from, address to, uint256 amount)
928         public
929         returns (bool)
930     {
931         // check and reset allowance
932         var allowance = _allowed[from][msg.sender];
933         _allowed[from][msg.sender] = sub(allowance, amount);
934         // do the transfer
935         transferInternal(from, to, amount);
936         return true;
937     }
938 
939     /**
940     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
941     * @param spender The address which will spend the funds.
942     * @param amount The amount of tokens to be spent.
943     */
944     function approve(address spender, uint256 amount)
945         public
946         returns (bool)
947     {
948 
949         // To change the approve amount you first have to reduce the addresses`
950         //  allowance to zero by calling `approve(_spender, 0)` if it is not
951         //  already 0 to mitigate the race condition described here:
952         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
953         require((amount == 0) || (_allowed[msg.sender][spender] == 0));
954 
955         _allowed[msg.sender][spender] = amount;
956         Approval(msg.sender, spender, amount);
957         return true;
958     }
959 
960     /**
961     * @dev Function to check the amount of tokens that an owner allowed to a spender.
962     * @param owner address The address which owns the funds.
963     * @param spender address The address which will spend the funds.
964     * @return A uint256 specifing the amount of tokens still avaible for the spender.
965     */
966     function allowance(address owner, address spender)
967         public
968         constant
969         returns (uint256 remaining)
970     {
971         return _allowed[owner][spender];
972     }
973 
974     //
975     // Implements IERC677Token
976     //
977 
978     function approveAndCall(
979         address spender,
980         uint256 amount,
981         bytes extraData
982     )
983         public
984         returns (bool)
985     {
986         require(approve(spender, amount));
987 
988         // in case of re-entry 1. approval is done 2. msg.sender is different
989         bool success = IERC677Callback(spender).receiveApproval(
990             msg.sender,
991             amount,
992             this,
993             extraData
994         );
995         require(success);
996 
997         return true;
998     }
999 }
1000 
1001 contract EtherToken is
1002     IsContract,
1003     AccessControlled,
1004     StandardToken,
1005     TokenMetadata,
1006     Reclaimable
1007 {
1008     ////////////////////////
1009     // Constants
1010     ////////////////////////
1011 
1012     string private constant NAME = "Ether Token";
1013 
1014     string private constant SYMBOL = "ETH-T";
1015 
1016     uint8 private constant DECIMALS = 18;
1017 
1018     ////////////////////////
1019     // Events
1020     ////////////////////////
1021 
1022     event LogDeposit(
1023         address indexed to,
1024         uint256 amount
1025     );
1026 
1027     event LogWithdrawal(
1028         address indexed from,
1029         uint256 amount
1030     );
1031 
1032     ////////////////////////
1033     // Constructor
1034     ////////////////////////
1035 
1036     function EtherToken(IAccessPolicy accessPolicy)
1037         AccessControlled(accessPolicy)
1038         StandardToken()
1039         TokenMetadata(NAME, DECIMALS, SYMBOL, "")
1040         Reclaimable()
1041         public
1042     {
1043     }
1044 
1045     ////////////////////////
1046     // Public functions
1047     ////////////////////////
1048 
1049     /// deposit msg.value of Ether to msg.sender balance
1050     function deposit()
1051         payable
1052         public
1053     {
1054         _balances[msg.sender] = add(_balances[msg.sender], msg.value);
1055         _totalSupply = add(_totalSupply, msg.value);
1056         LogDeposit(msg.sender, msg.value);
1057         Transfer(address(0), msg.sender, msg.value);
1058     }
1059 
1060     /// withdraws and sends 'amount' of ether to msg.sender
1061     function withdraw(uint256 amount)
1062         public
1063     {
1064         require(_balances[msg.sender] >= amount);
1065         _balances[msg.sender] = sub(_balances[msg.sender], amount);
1066         _totalSupply = sub(_totalSupply, amount);
1067         msg.sender.transfer(amount);
1068         LogWithdrawal(msg.sender, amount);
1069         Transfer(msg.sender, address(0), amount);
1070     }
1071 
1072     //
1073     // Implements IERC223Token
1074     //
1075 
1076     function transfer(address to, uint256 amount, bytes data)
1077         public
1078         returns (bool)
1079     {
1080         transferInternal(msg.sender, to, amount);
1081 
1082         // Notify the receiving contract.
1083         if (isContract(to)) {
1084             // in case of re-entry (1) transfer is done (2) msg.sender is different
1085             IERC223Callback(to).onTokenTransfer(msg.sender, amount, data);
1086         }
1087         return true;
1088     }
1089 
1090     //
1091     // Overrides Reclaimable
1092     //
1093 
1094     /// @notice allows EtherToken to reclaim tokens wrongly sent to its address
1095     /// @dev as EtherToken by design has balance of Ether (native Ethereum token)
1096     ///     such reclamation is not allowed
1097     function reclaim(IBasicToken token)
1098         public
1099     {
1100         // forbid reclaiming ETH hold in this contract.
1101         require(token != RECLAIM_ETHER);
1102         Reclaimable.reclaim(token);
1103     }
1104 }
1105 
1106 /// @notice implemented in the contract that is the target of state migration
1107 /// @dev implementation must provide actual function that will be called by source to migrate state
1108 contract IMigrationTarget {
1109 
1110     ////////////////////////
1111     // Public functions
1112     ////////////////////////
1113 
1114     // should return migration source address
1115     function currentMigrationSource()
1116         public
1117         constant
1118         returns (address);
1119 }
1120 
1121 /// @notice mixin that enables contract to receive migration
1122 /// @dev when derived from
1123 contract MigrationTarget is
1124     IMigrationTarget
1125 {
1126     ////////////////////////
1127     // Modifiers
1128     ////////////////////////
1129 
1130     // intended to be applied on migration receiving function
1131     modifier onlyMigrationSource() {
1132         require(msg.sender == currentMigrationSource());
1133         _;
1134     }
1135 }
1136 
1137 contract EuroTokenMigrationTarget is
1138     MigrationTarget
1139 {
1140     ////////////////////////
1141     // Public functions
1142     ////////////////////////
1143 
1144     /// @notice accepts migration of single eur-t token holder
1145     /// @dev allowed to be called only from migration source, do not forget to add accessor modifier in implementation
1146     function migrateEuroTokenOwner(address owner, uint256 amount)
1147         public
1148         onlyMigrationSource();
1149 }
1150 
1151 /// @notice implemented in the contract that stores state to be migrated
1152 /// @notice contract is called migration source
1153 /// @dev migration target implements IMigrationTarget interface, when it is passed in 'enableMigration' function
1154 /// @dev 'migrate' function may be called to migrate part of state owned by msg.sender
1155 /// @dev in legal terms this corresponds to amending/changing agreement terms by co-signature of parties
1156 contract IMigrationSource {
1157 
1158     ////////////////////////
1159     // Events
1160     ////////////////////////
1161 
1162     event LogMigrationEnabled(
1163         address target
1164     );
1165 
1166     ////////////////////////
1167     // Public functions
1168     ////////////////////////
1169 
1170     /// @notice should migrate state owned by msg.sender
1171     /// @dev intended flow is to: read source state, clear source state, call migrate function on target, log success event
1172     function migrate()
1173         public;
1174 
1175     /// @notice should enable migration to migration target
1176     /// @dev should limit access to specific role in implementation
1177     function enableMigration(IMigrationTarget migration)
1178         public;
1179 
1180     /// @notice returns current migration target
1181     function currentMigrationTarget()
1182         public
1183         constant
1184         returns (IMigrationTarget);
1185 }
1186 
1187 /// @notice mixin that enables migration pattern for a contract
1188 /// @dev when derived from
1189 contract MigrationSource is
1190     IMigrationSource,
1191     AccessControlled
1192 {
1193     ////////////////////////
1194     // Immutable state
1195     ////////////////////////
1196 
1197     /// stores role hash that can enable migration
1198     bytes32 private MIGRATION_ADMIN;
1199 
1200     ////////////////////////
1201     // Mutable state
1202     ////////////////////////
1203 
1204     // migration target contract
1205     IMigrationTarget internal _migration;
1206 
1207     ////////////////////////
1208     // Modifiers
1209     ////////////////////////
1210 
1211     /// @notice add to enableMigration function to prevent changing of migration
1212     ///     target once set
1213     modifier onlyMigrationEnabledOnce() {
1214         require(address(_migration) == 0);
1215         _;
1216     }
1217 
1218     modifier onlyMigrationEnabled() {
1219         require(address(_migration) != 0);
1220         _;
1221     }
1222 
1223     ////////////////////////
1224     // Constructor
1225     ////////////////////////
1226 
1227     function MigrationSource(
1228         IAccessPolicy policy,
1229         bytes32 migrationAdminRole
1230     )
1231         AccessControlled(policy)
1232         internal
1233     {
1234         MIGRATION_ADMIN = migrationAdminRole;
1235     }
1236 
1237     ////////////////////////
1238     // Public functions
1239     ////////////////////////
1240 
1241     /// @notice should migrate state that belongs to msg.sender
1242     /// @dev do not forget to add accessor modifier in implementation
1243     function migrate()
1244         onlyMigrationEnabled()
1245         public;
1246 
1247     /// @notice should enable migration to migration target
1248     /// @dev do not forget to add accessor modifier in override
1249     function enableMigration(IMigrationTarget migration)
1250         public
1251         onlyMigrationEnabledOnce()
1252         only(MIGRATION_ADMIN)
1253     {
1254         // this must be the source
1255         require(migration.currentMigrationSource() == address(this));
1256         _migration = migration;
1257         LogMigrationEnabled(_migration);
1258     }
1259 
1260     /// @notice returns current migration target
1261     function currentMigrationTarget()
1262         public
1263         constant
1264         returns (IMigrationTarget)
1265     {
1266         return _migration;
1267     }
1268 }
1269 
1270 /// Simple implementation of EuroToken which is pegged 1:1 to certain off-chain
1271 /// pool of Euro. Balances of this token are intended to be migrated to final
1272 /// implementation that will be available later
1273 contract EuroToken is
1274     IERC677Token,
1275     AccessControlled,
1276     StandardToken,
1277     TokenMetadata,
1278     MigrationSource,
1279     Reclaimable
1280 {
1281     ////////////////////////
1282     // Constants
1283     ////////////////////////
1284 
1285     string private constant NAME = "Euro Token";
1286 
1287     string private constant SYMBOL = "EUR-T";
1288 
1289     uint8 private constant DECIMALS = 18;
1290 
1291     ////////////////////////
1292     // Mutable state
1293     ////////////////////////
1294 
1295     // a list of addresses that are allowed to receive EUR-T
1296     mapping(address => bool) private _allowedTransferTo;
1297 
1298     // a list of of addresses that are allowed to send EUR-T
1299     mapping(address => bool) private _allowedTransferFrom;
1300 
1301     ////////////////////////
1302     // Events
1303     ////////////////////////
1304 
1305     event LogDeposit(
1306         address indexed to,
1307         uint256 amount
1308     );
1309 
1310     event LogWithdrawal(
1311         address indexed from,
1312         uint256 amount
1313     );
1314 
1315     event LogAllowedFromAddress(
1316         address indexed from,
1317         bool allowed
1318     );
1319 
1320     event LogAllowedToAddress(
1321         address indexed to,
1322         bool allowed
1323     );
1324 
1325     /// @notice migration was successful
1326     event LogEuroTokenOwnerMigrated(
1327         address indexed owner,
1328         uint256 amount
1329     );
1330 
1331     ////////////////////////
1332     // Modifiers
1333     ////////////////////////
1334 
1335     modifier onlyAllowedTransferFrom(address from) {
1336         require(_allowedTransferFrom[from]);
1337         _;
1338     }
1339 
1340     modifier onlyAllowedTransferTo(address to) {
1341         require(_allowedTransferTo[to]);
1342         _;
1343     }
1344 
1345     ////////////////////////
1346     // Constructor
1347     ////////////////////////
1348 
1349     function EuroToken(IAccessPolicy accessPolicy)
1350         AccessControlled(accessPolicy)
1351         StandardToken()
1352         TokenMetadata(NAME, DECIMALS, SYMBOL, "")
1353         MigrationSource(accessPolicy, ROLE_EURT_DEPOSIT_MANAGER)
1354         Reclaimable()
1355         public
1356     {
1357     }
1358 
1359     ////////////////////////
1360     // Public functions
1361     ////////////////////////
1362 
1363     /// @notice deposit 'amount' of EUR-T to address 'to'
1364     /// @dev address 'to' is whitelisted as recipient of future transfers
1365     /// @dev deposit may happen only in case of succesful KYC of recipient and validation of banking data
1366     /// @dev which in this implementation is an off-chain responsibility of EURT_DEPOSIT_MANAGER
1367     function deposit(address to, uint256 amount)
1368         public
1369         only(ROLE_EURT_DEPOSIT_MANAGER)
1370         returns (bool)
1371     {
1372         require(to != address(0));
1373         _balances[to] = add(_balances[to], amount);
1374         _totalSupply = add(_totalSupply, amount);
1375         setAllowedTransferTo(to, true);
1376         LogDeposit(to, amount);
1377         Transfer(address(0), to, amount);
1378         return true;
1379     }
1380 
1381     /// @notice withdraws 'amount' of EUR-T by burning required amount and providing a proof of whithdrawal
1382     /// @dev proof is provided in form of log entry on which EURT_DEPOSIT_MANAGER
1383     /// @dev will act off-chain to return required Euro amount to EUR-T holder
1384     function withdraw(uint256 amount)
1385         public
1386     {
1387         require(_balances[msg.sender] >= amount);
1388         _balances[msg.sender] = sub(_balances[msg.sender], amount);
1389         _totalSupply = sub(_totalSupply, amount);
1390         LogWithdrawal(msg.sender, amount);
1391         Transfer(msg.sender, address(0), amount);
1392     }
1393 
1394     /// @notice enables or disables address to be receipient of EUR-T
1395     function setAllowedTransferTo(address to, bool allowed)
1396         public
1397         only(ROLE_EURT_DEPOSIT_MANAGER)
1398     {
1399         _allowedTransferTo[to] = allowed;
1400         LogAllowedToAddress(to, allowed);
1401     }
1402 
1403     /// @notice enables or disables address to be sender of EUR-T
1404     function setAllowedTransferFrom(address from, bool allowed)
1405         public
1406         only(ROLE_EURT_DEPOSIT_MANAGER)
1407     {
1408         _allowedTransferFrom[from] = allowed;
1409         LogAllowedFromAddress(from, allowed);
1410     }
1411 
1412     function allowedTransferTo(address to)
1413         public
1414         constant
1415         returns (bool)
1416     {
1417         return _allowedTransferTo[to];
1418     }
1419 
1420     function allowedTransferFrom(address from)
1421         public
1422         constant
1423         returns (bool)
1424     {
1425         return _allowedTransferFrom[from];
1426     }
1427 
1428     //
1429     // Overrides ERC20 Interface to allow transfer from/to allowed addresses
1430     //
1431 
1432     function transfer(address to, uint256 amount)
1433         public
1434         onlyAllowedTransferFrom(msg.sender)
1435         onlyAllowedTransferTo(to)
1436         returns (bool success)
1437     {
1438         return BasicToken.transfer(to, amount);
1439     }
1440 
1441     /// @dev broker acts in the name of 'from' address so broker needs to have permission to transfer from
1442     ///  this way we may give permissions to brokering smart contracts while investors do not have permissions
1443     ///  to transfer. 'to' address requires standard transfer to permission
1444     function transferFrom(address from, address to, uint256 amount)
1445         public
1446         onlyAllowedTransferFrom(msg.sender)
1447         onlyAllowedTransferTo(to)
1448         returns (bool success)
1449     {
1450         return StandardToken.transferFrom(from, to, amount);
1451     }
1452 
1453     //
1454     // Overrides migration source
1455     //
1456 
1457     function migrate()
1458         public
1459         onlyMigrationEnabled()
1460         onlyAllowedTransferTo(msg.sender)
1461     {
1462         // burn deposit
1463         uint256 amount = _balances[msg.sender];
1464         if (amount > 0) {
1465             _balances[msg.sender] = 0;
1466             _totalSupply = sub(_totalSupply, amount);
1467         }
1468         // remove all transfer permissions
1469         _allowedTransferTo[msg.sender] = false;
1470         _allowedTransferFrom[msg.sender] = false;
1471         // migrate to
1472         EuroTokenMigrationTarget(_migration).migrateEuroTokenOwner(msg.sender, amount);
1473         // set event
1474         LogEuroTokenOwnerMigrated(msg.sender, amount);
1475     }
1476 }
1477 
1478 /// @notice implemented in the contract that is the target of LockedAccount migration
1479 ///  migration process is removing investors balance from source LockedAccount fully
1480 ///  target should re-create investor with the same balance, totalLockedAmount and totalInvestors are invariant during migration
1481 contract LockedAccountMigration is
1482     MigrationTarget
1483 {
1484     ////////////////////////
1485     // Public functions
1486     ////////////////////////
1487 
1488     // implemented in migration target, yes modifiers are inherited from base class
1489     function migrateInvestor(
1490         address investor,
1491         uint256 balance,
1492         uint256 neumarksDue,
1493         uint256 unlockDate
1494     )
1495         public
1496         onlyMigrationSource();
1497 }
1498 
1499 contract NeumarkIssuanceCurve {
1500 
1501     ////////////////////////
1502     // Constants
1503     ////////////////////////
1504 
1505     // maximum number of neumarks that may be created
1506     uint256 private constant NEUMARK_CAP = 1500000000000000000000000000;
1507 
1508     // initial neumark reward fraction (controls curve steepness)
1509     uint256 private constant INITIAL_REWARD_FRACTION = 6500000000000000000;
1510 
1511     // stop issuing new Neumarks above this Euro value (as it goes quickly to zero)
1512     uint256 private constant ISSUANCE_LIMIT_EUR_ULPS = 8300000000000000000000000000;
1513 
1514     // approximate curve linearly above this Euro value
1515     uint256 private constant LINEAR_APPROX_LIMIT_EUR_ULPS = 2100000000000000000000000000;
1516     uint256 private constant NEUMARKS_AT_LINEAR_LIMIT_ULPS = 1499832501287264827896539871;
1517 
1518     uint256 private constant TOT_LINEAR_NEUMARKS_ULPS = NEUMARK_CAP - NEUMARKS_AT_LINEAR_LIMIT_ULPS;
1519     uint256 private constant TOT_LINEAR_EUR_ULPS = ISSUANCE_LIMIT_EUR_ULPS - LINEAR_APPROX_LIMIT_EUR_ULPS;
1520 
1521     ////////////////////////
1522     // Public functions
1523     ////////////////////////
1524 
1525     /// @notice returns additional amount of neumarks issued for euroUlps at totalEuroUlps
1526     /// @param totalEuroUlps actual curve position from which neumarks will be issued
1527     /// @param euroUlps amount against which neumarks will be issued
1528     function incremental(uint256 totalEuroUlps, uint256 euroUlps)
1529         public
1530         constant
1531         returns (uint256 neumarkUlps)
1532     {
1533         require(totalEuroUlps + euroUlps >= totalEuroUlps);
1534         uint256 from = cumulative(totalEuroUlps);
1535         uint256 to = cumulative(totalEuroUlps + euroUlps);
1536         // as expansion is not monotonic for large totalEuroUlps, assert below may fail
1537         // example: totalEuroUlps=1.999999999999999999999000000e+27 and euroUlps=50
1538         assert(to >= from);
1539         return to - from;
1540     }
1541 
1542     /// @notice returns amount of euro corresponding to burned neumarks
1543     /// @param totalEuroUlps actual curve position from which neumarks will be burned
1544     /// @param burnNeumarkUlps amount of neumarks to burn
1545     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps)
1546         public
1547         constant
1548         returns (uint256 euroUlps)
1549     {
1550         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
1551         require(totalNeumarkUlps >= burnNeumarkUlps);
1552         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
1553         uint newTotalEuroUlps = cumulativeInverse(fromNmk, 0, totalEuroUlps);
1554         // yes, this may overflow due to non monotonic inverse function
1555         assert(totalEuroUlps >= newTotalEuroUlps);
1556         return totalEuroUlps - newTotalEuroUlps;
1557     }
1558 
1559     /// @notice returns amount of euro corresponding to burned neumarks
1560     /// @param totalEuroUlps actual curve position from which neumarks will be burned
1561     /// @param burnNeumarkUlps amount of neumarks to burn
1562     /// @param minEurUlps euro amount to start inverse search from, inclusive
1563     /// @param maxEurUlps euro amount to end inverse search to, inclusive
1564     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
1565         public
1566         constant
1567         returns (uint256 euroUlps)
1568     {
1569         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
1570         require(totalNeumarkUlps >= burnNeumarkUlps);
1571         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
1572         uint newTotalEuroUlps = cumulativeInverse(fromNmk, minEurUlps, maxEurUlps);
1573         // yes, this may overflow due to non monotonic inverse function
1574         assert(totalEuroUlps >= newTotalEuroUlps);
1575         return totalEuroUlps - newTotalEuroUlps;
1576     }
1577 
1578     /// @notice finds total amount of neumarks issued for given amount of Euro
1579     /// @dev binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
1580     ///     function below is not monotonic
1581     function cumulative(uint256 euroUlps)
1582         public
1583         constant
1584         returns(uint256 neumarkUlps)
1585     {
1586         // Return the cap if euroUlps is above the limit.
1587         if (euroUlps >= ISSUANCE_LIMIT_EUR_ULPS) {
1588             return NEUMARK_CAP;
1589         }
1590         // use linear approximation above limit below
1591         // binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
1592         if (euroUlps >= LINEAR_APPROX_LIMIT_EUR_ULPS) {
1593             // (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS) is small so expression does not overflow
1594             return NEUMARKS_AT_LINEAR_LIMIT_ULPS + (TOT_LINEAR_NEUMARKS_ULPS * (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS)) / TOT_LINEAR_EUR_ULPS;
1595         }
1596 
1597         // Approximate cap-cap·(1-1/D)^n using the Binomial expansion
1598         // http://galileo.phys.virginia.edu/classes/152.mf1i.spring02/Exponential_Function.htm
1599         // Function[imax, -CAP*Sum[(-IR*EUR/CAP)^i/Factorial[i], {i, imax}]]
1600         // which may be simplified to
1601         // Function[imax, -CAP*Sum[(EUR)^i/(Factorial[i]*(-d)^i), {i, 1, imax}]]
1602         // where d = cap/initial_reward
1603         uint256 d = 230769230769230769230769231; // NEUMARK_CAP / INITIAL_REWARD_FRACTION
1604         uint256 term = NEUMARK_CAP;
1605         uint256 sum = 0;
1606         uint256 denom = d;
1607         do assembly {
1608             // We use assembler primarily to avoid the expensive
1609             // divide-by-zero check solc inserts for the / operator.
1610             term  := div(mul(term, euroUlps), denom)
1611             sum   := add(sum, term)
1612             denom := add(denom, d)
1613             // sub next term as we have power of negative value in the binomial expansion
1614             term  := div(mul(term, euroUlps), denom)
1615             sum   := sub(sum, term)
1616             denom := add(denom, d)
1617         } while (term != 0);
1618         return sum;
1619     }
1620 
1621     /// @notice find issuance curve inverse by binary search
1622     /// @param neumarkUlps neumark amount to compute inverse for
1623     /// @param minEurUlps minimum search range for the inverse, inclusive
1624     /// @param maxEurUlps maxium search range for the inverse, inclusive
1625     /// @dev in case of approximate search (no exact inverse) upper element of minimal search range is returned
1626     /// @dev in case of many possible inverses, the lowest one will be used (if range permits)
1627     /// @dev corresponds to a linear search that returns first euroUlp value that has cumulative() equal or greater than neumarkUlps
1628     function cumulativeInverse(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
1629         public
1630         constant
1631         returns (uint256 euroUlps)
1632     {
1633         require(maxEurUlps >= minEurUlps);
1634         require(cumulative(minEurUlps) <= neumarkUlps);
1635         require(cumulative(maxEurUlps) >= neumarkUlps);
1636         uint256 min = minEurUlps;
1637         uint256 max = maxEurUlps;
1638 
1639         // Binary search
1640         while (max > min) {
1641             uint256 mid = (max + min) / 2;
1642             uint256 val = cumulative(mid);
1643             // exact solution should not be used, a late points of the curve when many euroUlps are needed to
1644             // increase by one nmkUlp this will lead to  "indeterministic" inverse values that depend on the initial min and max
1645             // and further binary division -> you can land at any of the euro value that is mapped to the same nmk value
1646             // with condition below removed, binary search will point to the lowest eur value possible which is good because it cannot be exploited even with 0 gas costs
1647             /* if (val == neumarkUlps) {
1648                 return mid;
1649             }*/
1650             // NOTE: approximate search (no inverse) must return upper element of the final range
1651             //  last step of approximate search is always (min, min+1) so new mid is (2*min+1)/2 => min
1652             //  so new min = mid + 1 = max which was upper range. and that ends the search
1653             // NOTE: when there are multiple inverses for the same neumarkUlps, the `max` will be dragged down
1654             //  by `max = mid` expression to the lowest eur value of inverse. works only for ranges that cover all points of multiple inverse
1655             if (val < neumarkUlps) {
1656                 min = mid + 1;
1657             } else {
1658                 max = mid;
1659             }
1660         }
1661         // NOTE: It is possible that there is no inverse
1662         //  for example curve(0) = 0 and curve(1) = 6, so
1663         //  there is no value y such that curve(y) = 5.
1664         //  When there is no inverse, we must return upper element of last search range.
1665         //  This has the effect of reversing the curve less when
1666         //  burning Neumarks. This ensures that Neumarks can always
1667         //  be burned. It also ensure that the total supply of Neumarks
1668         //  remains below the cap.
1669         return max;
1670     }
1671 
1672     function neumarkCap()
1673         public
1674         constant
1675         returns (uint256)
1676     {
1677         return NEUMARK_CAP;
1678     }
1679 
1680     function initialRewardFraction()
1681         public
1682         constant
1683         returns (uint256)
1684     {
1685         return INITIAL_REWARD_FRACTION;
1686     }
1687 }
1688 
1689 /// @title advances snapshot id on demand
1690 /// @dev see Snapshot folder for implementation examples ie. DailyAndSnapshotable contract
1691 contract ISnapshotable {
1692 
1693     ////////////////////////
1694     // Events
1695     ////////////////////////
1696 
1697     /// @dev should log each new snapshot id created, including snapshots created automatically via MSnapshotPolicy
1698     event LogSnapshotCreated(uint256 snapshotId);
1699 
1700     ////////////////////////
1701     // Public functions
1702     ////////////////////////
1703 
1704     /// always creates new snapshot id which gets returned
1705     /// however, there is no guarantee that any snapshot will be created with this id, this depends on the implementation of MSnaphotPolicy
1706     function createSnapshot()
1707         public
1708         returns (uint256);
1709 
1710     /// upper bound of series snapshotIds for which there's a value
1711     function currentSnapshotId()
1712         public
1713         constant
1714         returns (uint256);
1715 }
1716 
1717 /// @title Abstracts snapshot id creation logics
1718 /// @dev Mixin (internal interface) of the snapshot policy which abstracts snapshot id creation logics from Snapshot contract
1719 /// @dev to be implemented and such implementation should be mixed with Snapshot-derived contract, see EveryBlock for simplest example of implementation and StandardSnapshotToken
1720 contract MSnapshotPolicy {
1721 
1722     ////////////////////////
1723     // Internal functions
1724     ////////////////////////
1725 
1726     // The snapshot Ids need to be strictly increasing.
1727     // Whenever the snaspshot id changes, a new snapshot will be created.
1728     // As long as the same snapshot id is being returned, last snapshot will be updated as this indicates that snapshot id didn't change
1729     //
1730     // Values passed to `hasValueAt` and `valuteAt` are required
1731     // to be less or equal to `mCurrentSnapshotId()`.
1732     function mCurrentSnapshotId()
1733         internal
1734         returns (uint256);
1735 }
1736 
1737 /// @title creates snapshot id on each day boundary and allows to create additional snapshots within a given day
1738 /// @dev snapshots are encoded in single uint256, where high 128 bits represents a day number (from unix epoch) and low 128 bits represents additional snapshots within given day create via ISnapshotable
1739 contract DailyAndSnapshotable is
1740     MSnapshotPolicy,
1741     ISnapshotable
1742 {
1743     ////////////////////////
1744     // Constants
1745     ////////////////////////
1746 
1747     // Floor[2**128 / 1 days]
1748     uint256 private MAX_TIMESTAMP = 3938453320844195178974243141571391;
1749 
1750     ////////////////////////
1751     // Mutable state
1752     ////////////////////////
1753 
1754     uint256 private _currentSnapshotId;
1755 
1756     ////////////////////////
1757     // Constructor
1758     ////////////////////////
1759 
1760     /// @param start snapshotId from which to start generating values
1761     /// @dev start must be for the same day or 0, required for token cloning
1762     function DailyAndSnapshotable(uint256 start) internal {
1763         // 0 is invalid value as we are past unix epoch
1764         if (start > 0) {
1765             uint256 dayBase = snapshotAt(block.timestamp);
1766             require(start >= dayBase);
1767             // dayBase + 2**128 will not overflow as it is based on block.timestamp
1768             require(start < dayBase + 2**128);
1769             _currentSnapshotId = start;
1770         }
1771     }
1772 
1773     ////////////////////////
1774     // Public functions
1775     ////////////////////////
1776 
1777     function snapshotAt(uint256 timestamp)
1778         public
1779         constant
1780         returns (uint256)
1781     {
1782         require(timestamp < MAX_TIMESTAMP);
1783 
1784         uint256 dayBase = 2**128 * (timestamp / 1 days);
1785         return dayBase;
1786     }
1787 
1788     //
1789     // Implements ISnapshotable
1790     //
1791 
1792     function createSnapshot()
1793         public
1794         returns (uint256)
1795     {
1796         uint256 dayBase = 2**128 * (block.timestamp / 1 days);
1797 
1798         if (dayBase > _currentSnapshotId) {
1799             // New day has started, create snapshot for midnight
1800             _currentSnapshotId = dayBase;
1801         } else {
1802             // within single day, increase counter (assume 2**128 will not be crossed)
1803             _currentSnapshotId += 1;
1804         }
1805 
1806         // Log and return
1807         LogSnapshotCreated(_currentSnapshotId);
1808         return _currentSnapshotId;
1809     }
1810 
1811     function currentSnapshotId()
1812         public
1813         constant
1814         returns (uint256)
1815     {
1816         return mCurrentSnapshotId();
1817     }
1818 
1819     ////////////////////////
1820     // Internal functions
1821     ////////////////////////
1822 
1823     //
1824     // Implements MSnapshotPolicy
1825     //
1826 
1827     function mCurrentSnapshotId()
1828         internal
1829         returns (uint256)
1830     {
1831         uint256 dayBase = 2**128 * (block.timestamp / 1 days);
1832 
1833         // New day has started
1834         if (dayBase > _currentSnapshotId) {
1835             _currentSnapshotId = dayBase;
1836             LogSnapshotCreated(dayBase);
1837         }
1838 
1839         return _currentSnapshotId;
1840     }
1841 }
1842 
1843 /// @title controls spending approvals
1844 /// @dev TokenAllowance observes this interface, Neumark contract implements it
1845 contract MTokenAllowanceController {
1846 
1847     ////////////////////////
1848     // Internal functions
1849     ////////////////////////
1850 
1851     /// @notice Notifies the controller about an approval allowing the
1852     ///  controller to react if desired
1853     /// @param owner The address that calls `approve()`
1854     /// @param spender The spender in the `approve()` call
1855     /// @param amount The amount in the `approve()` call
1856     /// @return False if the controller does not authorize the approval
1857     function mOnApprove(
1858         address owner,
1859         address spender,
1860         uint256 amount
1861     )
1862         internal
1863         returns (bool allow);
1864 
1865 }
1866 
1867 /// @title controls token transfers
1868 /// @dev BasicSnapshotToken observes this interface, Neumark contract implements it
1869 contract MTokenTransferController {
1870 
1871     ////////////////////////
1872     // Internal functions
1873     ////////////////////////
1874 
1875     /// @notice Notifies the controller about a token transfer allowing the
1876     ///  controller to react if desired
1877     /// @param from The origin of the transfer
1878     /// @param to The destination of the transfer
1879     /// @param amount The amount of the transfer
1880     /// @return False if the controller does not authorize the transfer
1881     function mOnTransfer(
1882         address from,
1883         address to,
1884         uint256 amount
1885     )
1886         internal
1887         returns (bool allow);
1888 
1889 }
1890 
1891 /// @title controls approvals and transfers
1892 /// @dev The token controller contract must implement these functions, see Neumark as example
1893 /// @dev please note that controller may be a separate contract that is called from mOnTransfer and mOnApprove functions
1894 contract MTokenController is MTokenTransferController, MTokenAllowanceController {
1895 }
1896 
1897 /// @title internal token transfer function
1898 /// @dev see BasicSnapshotToken for implementation
1899 contract MTokenTransfer {
1900 
1901     ////////////////////////
1902     // Internal functions
1903     ////////////////////////
1904 
1905     /// @dev This is the actual transfer function in the token contract, it can
1906     ///  only be called by other functions in this contract.
1907     /// @param from The address holding the tokens being transferred
1908     /// @param to The address of the recipient
1909     /// @param amount The amount of tokens to be transferred
1910     /// @dev  reverts if transfer was not successful
1911     function mTransfer(
1912         address from,
1913         address to,
1914         uint256 amount
1915     )
1916         internal;
1917 }
1918 
1919 /// @title token spending approval and transfer
1920 /// @dev implements token approval and transfers and exposes relevant part of ERC20 and ERC677 approveAndCall
1921 ///     may be mixed in with any basic token (implementing mTransfer) like BasicSnapshotToken or MintableSnapshotToken to add approval mechanism
1922 ///     observes MTokenAllowanceController interface
1923 ///     observes MTokenTransfer
1924 contract TokenAllowance is
1925     MTokenTransfer,
1926     MTokenAllowanceController,
1927     IERC20Allowance,
1928     IERC677Token
1929 {
1930 
1931     ////////////////////////
1932     // Mutable state
1933     ////////////////////////
1934 
1935     // `allowed` tracks rights to spends others tokens as per ERC20
1936     mapping (address => mapping (address => uint256)) private _allowed;
1937 
1938     ////////////////////////
1939     // Constructor
1940     ////////////////////////
1941 
1942     function TokenAllowance()
1943         internal
1944     {
1945     }
1946 
1947     ////////////////////////
1948     // Public functions
1949     ////////////////////////
1950 
1951     //
1952     // Implements IERC20Token
1953     //
1954 
1955     /// @dev This function makes it easy to read the `allowed[]` map
1956     /// @param owner The address of the account that owns the token
1957     /// @param spender The address of the account able to transfer the tokens
1958     /// @return Amount of remaining tokens of _owner that _spender is allowed
1959     ///  to spend
1960     function allowance(address owner, address spender)
1961         public
1962         constant
1963         returns (uint256 remaining)
1964     {
1965         return _allowed[owner][spender];
1966     }
1967 
1968     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
1969     ///  its behalf. This is a modified version of the ERC20 approve function
1970     ///  where allowance per spender must be 0 to allow change of such allowance
1971     /// @param spender The address of the account able to transfer the tokens
1972     /// @param amount The amount of tokens to be approved for transfer
1973     /// @return True or reverts, False is never returned
1974     function approve(address spender, uint256 amount)
1975         public
1976         returns (bool success)
1977     {
1978         // Alerts the token controller of the approve function call
1979         require(mOnApprove(msg.sender, spender, amount));
1980 
1981         // To change the approve amount you first have to reduce the addresses`
1982         //  allowance to zero by calling `approve(_spender,0)` if it is not
1983         //  already 0 to mitigate the race condition described here:
1984         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1985         require((amount == 0) || (_allowed[msg.sender][spender] == 0));
1986 
1987         _allowed[msg.sender][spender] = amount;
1988         Approval(msg.sender, spender, amount);
1989         return true;
1990     }
1991 
1992     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
1993     ///  is approved by `_from`
1994     /// @param from The address holding the tokens being transferred
1995     /// @param to The address of the recipient
1996     /// @param amount The amount of tokens to be transferred
1997     /// @return True if the transfer was successful, reverts in any other case
1998     function transferFrom(address from, address to, uint256 amount)
1999         public
2000         returns (bool success)
2001     {
2002         // The standard ERC 20 transferFrom functionality
2003         bool amountApproved = _allowed[from][msg.sender] >= amount;
2004         require(amountApproved);
2005 
2006         _allowed[from][msg.sender] -= amount;
2007         mTransfer(from, to, amount);
2008 
2009         return true;
2010     }
2011 
2012     //
2013     // Implements IERC677Token
2014     //
2015 
2016     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
2017     ///  its behalf, and then a function is triggered in the contract that is
2018     ///  being approved, `_spender`. This allows users to use their tokens to
2019     ///  interact with contracts in one function call instead of two
2020     /// @param spender The address of the contract able to transfer the tokens
2021     /// @param amount The amount of tokens to be approved for transfer
2022     /// @return True or reverts, False is never returned
2023     function approveAndCall(
2024         address spender,
2025         uint256 amount,
2026         bytes extraData
2027     )
2028         public
2029         returns (bool success)
2030     {
2031         require(approve(spender, amount));
2032 
2033         success = IERC677Callback(spender).receiveApproval(
2034             msg.sender,
2035             amount,
2036             this,
2037             extraData
2038         );
2039         require(success);
2040 
2041         return true;
2042     }
2043 }
2044 
2045 /// @title Reads and writes snapshots
2046 /// @dev Manages reading and writing a series of values, where each value has assigned a snapshot id for access to historical data
2047 /// @dev may be added to any contract to provide snapshotting mechanism. should be mixed in with any of MSnapshotPolicy implementations to customize snapshot creation mechanics
2048 ///     observes MSnapshotPolicy
2049 /// based on MiniMe token
2050 contract Snapshot is MSnapshotPolicy {
2051 
2052     ////////////////////////
2053     // Types
2054     ////////////////////////
2055 
2056     /// @dev `Values` is the structure that attaches a snapshot id to a
2057     ///  given value, the snapshot id attached is the one that last changed the
2058     ///  value
2059     struct Values {
2060 
2061         // `snapshotId` is the snapshot id that the value was generated at
2062         uint256 snapshotId;
2063 
2064         // `value` at a specific snapshot id
2065         uint256 value;
2066     }
2067 
2068     ////////////////////////
2069     // Internal functions
2070     ////////////////////////
2071 
2072     function hasValue(
2073         Values[] storage values
2074     )
2075         internal
2076         constant
2077         returns (bool)
2078     {
2079         return values.length > 0;
2080     }
2081 
2082     /// @dev makes sure that 'snapshotId' between current snapshot id (mCurrentSnapshotId) and first snapshot id. this guarantees that getValueAt returns value from one of the snapshots.
2083     function hasValueAt(
2084         Values[] storage values,
2085         uint256 snapshotId
2086     )
2087         internal
2088         constant
2089         returns (bool)
2090     {
2091         require(snapshotId <= mCurrentSnapshotId());
2092         return values.length > 0 && values[0].snapshotId <= snapshotId;
2093     }
2094 
2095     /// gets last value in the series
2096     function getValue(
2097         Values[] storage values,
2098         uint256 defaultValue
2099     )
2100         internal
2101         constant
2102         returns (uint256)
2103     {
2104         if (values.length == 0) {
2105             return defaultValue;
2106         } else {
2107             uint256 last = values.length - 1;
2108             return values[last].value;
2109         }
2110     }
2111 
2112     /// @dev `getValueAt` retrieves value at a given snapshot id
2113     /// @param values The series of values being queried
2114     /// @param snapshotId Snapshot id to retrieve the value at
2115     /// @return Value in series being queried
2116     function getValueAt(
2117         Values[] storage values,
2118         uint256 snapshotId,
2119         uint256 defaultValue
2120     )
2121         internal
2122         constant
2123         returns (uint256)
2124     {
2125         require(snapshotId <= mCurrentSnapshotId());
2126 
2127         // Empty value
2128         if (values.length == 0) {
2129             return defaultValue;
2130         }
2131 
2132         // Shortcut for the out of bounds snapshots
2133         uint256 last = values.length - 1;
2134         uint256 lastSnapshot = values[last].snapshotId;
2135         if (snapshotId >= lastSnapshot) {
2136             return values[last].value;
2137         }
2138         uint256 firstSnapshot = values[0].snapshotId;
2139         if (snapshotId < firstSnapshot) {
2140             return defaultValue;
2141         }
2142         // Binary search of the value in the array
2143         uint256 min = 0;
2144         uint256 max = last;
2145         while (max > min) {
2146             uint256 mid = (max + min + 1) / 2;
2147             // must always return lower indice for approximate searches
2148             if (values[mid].snapshotId <= snapshotId) {
2149                 min = mid;
2150             } else {
2151                 max = mid - 1;
2152             }
2153         }
2154         return values[min].value;
2155     }
2156 
2157     /// @dev `setValue` used to update sequence at next snapshot
2158     /// @param values The sequence being updated
2159     /// @param value The new last value of sequence
2160     function setValue(
2161         Values[] storage values,
2162         uint256 value
2163     )
2164         internal
2165     {
2166         // TODO: simplify or break into smaller functions
2167 
2168         uint256 currentSnapshotId = mCurrentSnapshotId();
2169         // Always create a new entry if there currently is no value
2170         bool empty = values.length == 0;
2171         if (empty) {
2172             // Create a new entry
2173             values.push(
2174                 Values({
2175                     snapshotId: currentSnapshotId,
2176                     value: value
2177                 })
2178             );
2179             return;
2180         }
2181 
2182         uint256 last = values.length - 1;
2183         bool hasNewSnapshot = values[last].snapshotId < currentSnapshotId;
2184         if (hasNewSnapshot) {
2185 
2186             // Do nothing if the value was not modified
2187             bool unmodified = values[last].value == value;
2188             if (unmodified) {
2189                 return;
2190             }
2191 
2192             // Create new entry
2193             values.push(
2194                 Values({
2195                     snapshotId: currentSnapshotId,
2196                     value: value
2197                 })
2198             );
2199         } else {
2200 
2201             // We are updating the currentSnapshotId
2202             bool previousUnmodified = last > 0 && values[last - 1].value == value;
2203             if (previousUnmodified) {
2204                 // Remove current snapshot if current value was set to previous value
2205                 delete values[last];
2206                 values.length--;
2207                 return;
2208             }
2209 
2210             // Overwrite next snapshot entry
2211             values[last].value = value;
2212         }
2213     }
2214 }
2215 
2216 /// @title access to snapshots of a token
2217 /// @notice allows to implement complex token holder rights like revenue disbursal or voting
2218 /// @notice snapshots are series of values with assigned ids. ids increase strictly. particular id mechanism is not assumed
2219 contract ITokenSnapshots {
2220 
2221     ////////////////////////
2222     // Public functions
2223     ////////////////////////
2224 
2225     /// @notice Total amount of tokens at a specific `snapshotId`.
2226     /// @param snapshotId of snapshot at which totalSupply is queried
2227     /// @return The total amount of tokens at `snapshotId`
2228     /// @dev reverts on snapshotIds greater than currentSnapshotId()
2229     /// @dev returns 0 for snapshotIds less than snapshotId of first value
2230     function totalSupplyAt(uint256 snapshotId)
2231         public
2232         constant
2233         returns(uint256);
2234 
2235     /// @dev Queries the balance of `owner` at a specific `snapshotId`
2236     /// @param owner The address from which the balance will be retrieved
2237     /// @param snapshotId of snapshot at which the balance is queried
2238     /// @return The balance at `snapshotId`
2239     function balanceOfAt(address owner, uint256 snapshotId)
2240         public
2241         constant
2242         returns (uint256);
2243 
2244     /// @notice upper bound of series of snapshotIds for which there's a value in series
2245     /// @return snapshotId
2246     function currentSnapshotId()
2247         public
2248         constant
2249         returns (uint256);
2250 }
2251 
2252 /// @title represents link between cloned and parent token
2253 /// @dev when token is clone from other token, initial balances of the cloned token
2254 ///     correspond to balances of parent token at the moment of parent snapshot id specified
2255 /// @notice please note that other tokens beside snapshot token may be cloned
2256 contract IClonedTokenParent is ITokenSnapshots {
2257 
2258     ////////////////////////
2259     // Public functions
2260     ////////////////////////
2261 
2262 
2263     /// @return address of parent token, address(0) if root
2264     /// @dev parent token does not need to clonable, nor snapshottable, just a normal token
2265     function parentToken()
2266         public
2267         constant
2268         returns(IClonedTokenParent parent);
2269 
2270     /// @return snapshot at wchich initial token distribution was taken
2271     function parentSnapshotId()
2272         public
2273         constant
2274         returns(uint256 snapshotId);
2275 }
2276 
2277 /// @title token with snapshots and transfer functionality
2278 /// @dev observes MTokenTransferController interface
2279 ///     observes ISnapshotToken interface
2280 ///     implementes MTokenTransfer interface
2281 contract BasicSnapshotToken is
2282     MTokenTransfer,
2283     MTokenTransferController,
2284     IBasicToken,
2285     IClonedTokenParent,
2286     Snapshot
2287 {
2288     ////////////////////////
2289     // Immutable state
2290     ////////////////////////
2291 
2292     // `PARENT_TOKEN` is the Token address that was cloned to produce this token;
2293     //  it will be 0x0 for a token that was not cloned
2294     IClonedTokenParent private PARENT_TOKEN;
2295 
2296     // `PARENT_SNAPSHOT_ID` is the snapshot id from the Parent Token that was
2297     //  used to determine the initial distribution of the cloned token
2298     uint256 private PARENT_SNAPSHOT_ID;
2299 
2300     ////////////////////////
2301     // Mutable state
2302     ////////////////////////
2303 
2304     // `balances` is the map that tracks the balance of each address, in this
2305     //  contract when the balance changes the snapshot id that the change
2306     //  occurred is also included in the map
2307     mapping (address => Values[]) internal _balances;
2308 
2309     // Tracks the history of the `totalSupply` of the token
2310     Values[] internal _totalSupplyValues;
2311 
2312     ////////////////////////
2313     // Constructor
2314     ////////////////////////
2315 
2316     /// @notice Constructor to create snapshot token
2317     /// @param parentToken Address of the parent token, set to 0x0 if it is a
2318     ///  new token
2319     /// @param parentSnapshotId at which snapshot id clone was created, set to 0 to clone at upper bound
2320     /// @dev please not that as long as cloned token does not overwrite value at current snapshot id, it will refer
2321     ///     to parent token at which this snapshot still may change until snapshot id increases. for that time tokens are coupled
2322     ///     this is prevented by parentSnapshotId value of parentToken.currentSnapshotId() - 1 being the maxiumum
2323     ///     see SnapshotToken.js test to learn consequences coupling has.
2324     function BasicSnapshotToken(
2325         IClonedTokenParent parentToken,
2326         uint256 parentSnapshotId
2327     )
2328         Snapshot()
2329         internal
2330     {
2331         PARENT_TOKEN = parentToken;
2332         if (parentToken == address(0)) {
2333             require(parentSnapshotId == 0);
2334         } else {
2335             if (parentSnapshotId == 0) {
2336                 require(parentToken.currentSnapshotId() > 0);
2337                 PARENT_SNAPSHOT_ID = parentToken.currentSnapshotId() - 1;
2338             } else {
2339                 PARENT_SNAPSHOT_ID = parentSnapshotId;
2340             }
2341         }
2342     }
2343 
2344     ////////////////////////
2345     // Public functions
2346     ////////////////////////
2347 
2348     //
2349     // Implements IBasicToken
2350     //
2351 
2352     /// @dev This function makes it easy to get the total number of tokens
2353     /// @return The total number of tokens
2354     function totalSupply()
2355         public
2356         constant
2357         returns (uint256)
2358     {
2359         return totalSupplyAtInternal(mCurrentSnapshotId());
2360     }
2361 
2362     /// @param owner The address that's balance is being requested
2363     /// @return The balance of `owner` at the current block
2364     function balanceOf(address owner)
2365         public
2366         constant
2367         returns (uint256 balance)
2368     {
2369         return balanceOfAtInternal(owner, mCurrentSnapshotId());
2370     }
2371 
2372     /// @notice Send `amount` tokens to `to` from `msg.sender`
2373     /// @param to The address of the recipient
2374     /// @param amount The amount of tokens to be transferred
2375     /// @return True if the transfer was successful, reverts in any other case
2376     function transfer(address to, uint256 amount)
2377         public
2378         returns (bool success)
2379     {
2380         mTransfer(msg.sender, to, amount);
2381         return true;
2382     }
2383 
2384     //
2385     // Implements ITokenSnapshots
2386     //
2387 
2388     function totalSupplyAt(uint256 snapshotId)
2389         public
2390         constant
2391         returns(uint256)
2392     {
2393         return totalSupplyAtInternal(snapshotId);
2394     }
2395 
2396     function balanceOfAt(address owner, uint256 snapshotId)
2397         public
2398         constant
2399         returns (uint256)
2400     {
2401         return balanceOfAtInternal(owner, snapshotId);
2402     }
2403 
2404     function currentSnapshotId()
2405         public
2406         constant
2407         returns (uint256)
2408     {
2409         return mCurrentSnapshotId();
2410     }
2411 
2412     //
2413     // Implements IClonedTokenParent
2414     //
2415 
2416     function parentToken()
2417         public
2418         constant
2419         returns(IClonedTokenParent parent)
2420     {
2421         return PARENT_TOKEN;
2422     }
2423 
2424     /// @return snapshot at wchich initial token distribution was taken
2425     function parentSnapshotId()
2426         public
2427         constant
2428         returns(uint256 snapshotId)
2429     {
2430         return PARENT_SNAPSHOT_ID;
2431     }
2432 
2433     //
2434     // Other public functions
2435     //
2436 
2437     /// @notice gets all token balances of 'owner'
2438     /// @dev intended to be called via eth_call where gas limit is not an issue
2439     function allBalancesOf(address owner)
2440         external
2441         constant
2442         returns (uint256[2][])
2443     {
2444         /* very nice and working implementation below,
2445         // copy to memory
2446         Values[] memory values = _balances[owner];
2447         do assembly {
2448             // in memory structs have simple layout where every item occupies uint256
2449             balances := values
2450         } while (false);*/
2451 
2452         Values[] storage values = _balances[owner];
2453         uint256[2][] memory balances = new uint256[2][](values.length);
2454         for(uint256 ii = 0; ii < values.length; ++ii) {
2455             balances[ii] = [values[ii].snapshotId, values[ii].value];
2456         }
2457 
2458         return balances;
2459     }
2460 
2461     ////////////////////////
2462     // Internal functions
2463     ////////////////////////
2464 
2465     function totalSupplyAtInternal(uint256 snapshotId)
2466         public
2467         constant
2468         returns(uint256)
2469     {
2470         Values[] storage values = _totalSupplyValues;
2471 
2472         // If there is a value, return it, reverts if value is in the future
2473         if (hasValueAt(values, snapshotId)) {
2474             return getValueAt(values, snapshotId, 0);
2475         }
2476 
2477         // Try parent contract at or before the fork
2478         if (address(PARENT_TOKEN) != 0) {
2479             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
2480             return PARENT_TOKEN.totalSupplyAt(earlierSnapshotId);
2481         }
2482 
2483         // Default to an empty balance
2484         return 0;
2485     }
2486 
2487     // get balance at snapshot if with continuation in parent token
2488     function balanceOfAtInternal(address owner, uint256 snapshotId)
2489         internal
2490         constant
2491         returns (uint256)
2492     {
2493         Values[] storage values = _balances[owner];
2494 
2495         // If there is a value, return it, reverts if value is in the future
2496         if (hasValueAt(values, snapshotId)) {
2497             return getValueAt(values, snapshotId, 0);
2498         }
2499 
2500         // Try parent contract at or before the fork
2501         if (PARENT_TOKEN != address(0)) {
2502             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
2503             return PARENT_TOKEN.balanceOfAt(owner, earlierSnapshotId);
2504         }
2505 
2506         // Default to an empty balance
2507         return 0;
2508     }
2509 
2510     //
2511     // Implements MTokenTransfer
2512     //
2513 
2514     /// @dev This is the actual transfer function in the token contract, it can
2515     ///  only be called by other functions in this contract.
2516     /// @param from The address holding the tokens being transferred
2517     /// @param to The address of the recipient
2518     /// @param amount The amount of tokens to be transferred
2519     /// @return True if the transfer was successful, reverts in any other case
2520     function mTransfer(
2521         address from,
2522         address to,
2523         uint256 amount
2524     )
2525         internal
2526     {
2527         // never send to address 0
2528         require(to != address(0));
2529         // block transfers in clone that points to future/current snapshots of patent token
2530         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2531         // Alerts the token controller of the transfer
2532         require(mOnTransfer(from, to, amount));
2533 
2534         // If the amount being transfered is more than the balance of the
2535         //  account the transfer reverts
2536         var previousBalanceFrom = balanceOf(from);
2537         require(previousBalanceFrom >= amount);
2538 
2539         // First update the balance array with the new value for the address
2540         //  sending the tokens
2541         uint256 newBalanceFrom = previousBalanceFrom - amount;
2542         setValue(_balances[from], newBalanceFrom);
2543 
2544         // Then update the balance array with the new value for the address
2545         //  receiving the tokens
2546         uint256 previousBalanceTo = balanceOf(to);
2547         uint256 newBalanceTo = previousBalanceTo + amount;
2548         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
2549         setValue(_balances[to], newBalanceTo);
2550 
2551         // An event to make the transfer easy to find on the blockchain
2552         Transfer(from, to, amount);
2553     }
2554 }
2555 
2556 /// @title token generation and destruction
2557 /// @dev internal interface providing token generation and destruction, see MintableSnapshotToken for implementation
2558 contract MTokenMint {
2559 
2560     ////////////////////////
2561     // Internal functions
2562     ////////////////////////
2563 
2564     /// @notice Generates `amount` tokens that are assigned to `owner`
2565     /// @param owner The address that will be assigned the new tokens
2566     /// @param amount The quantity of tokens generated
2567     /// @dev reverts if tokens could not be generated
2568     function mGenerateTokens(address owner, uint256 amount)
2569         internal;
2570 
2571     /// @notice Burns `amount` tokens from `owner`
2572     /// @param owner The address that will lose the tokens
2573     /// @param amount The quantity of tokens to burn
2574     /// @dev reverts if tokens could not be destroyed
2575     function mDestroyTokens(address owner, uint256 amount)
2576         internal;
2577 }
2578 
2579 /// @title basic snapshot token with facitilites to generate and destroy tokens
2580 /// @dev implementes MTokenMint, does not expose any public functions that create/destroy tokens
2581 contract MintableSnapshotToken is
2582     BasicSnapshotToken,
2583     MTokenMint
2584 {
2585 
2586     ////////////////////////
2587     // Constructor
2588     ////////////////////////
2589 
2590     /// @notice Constructor to create a MintableSnapshotToken
2591     /// @param parentToken Address of the parent token, set to 0x0 if it is a
2592     ///  new token
2593     function MintableSnapshotToken(
2594         IClonedTokenParent parentToken,
2595         uint256 parentSnapshotId
2596     )
2597         BasicSnapshotToken(parentToken, parentSnapshotId)
2598         internal
2599     {}
2600 
2601     /// @notice Generates `amount` tokens that are assigned to `owner`
2602     /// @param owner The address that will be assigned the new tokens
2603     /// @param amount The quantity of tokens generated
2604     function mGenerateTokens(address owner, uint256 amount)
2605         internal
2606     {
2607         // never create for address 0
2608         require(owner != address(0));
2609         // block changes in clone that points to future/current snapshots of patent token
2610         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2611 
2612         uint256 curTotalSupply = totalSupply();
2613         uint256 newTotalSupply = curTotalSupply + amount;
2614         require(newTotalSupply >= curTotalSupply); // Check for overflow
2615 
2616         uint256 previousBalanceTo = balanceOf(owner);
2617         uint256 newBalanceTo = previousBalanceTo + amount;
2618         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
2619 
2620         setValue(_totalSupplyValues, newTotalSupply);
2621         setValue(_balances[owner], newBalanceTo);
2622 
2623         Transfer(0, owner, amount);
2624     }
2625 
2626     /// @notice Burns `amount` tokens from `owner`
2627     /// @param owner The address that will lose the tokens
2628     /// @param amount The quantity of tokens to burn
2629     function mDestroyTokens(address owner, uint256 amount)
2630         internal
2631     {
2632         // block changes in clone that points to future/current snapshots of patent token
2633         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2634 
2635         uint256 curTotalSupply = totalSupply();
2636         require(curTotalSupply >= amount);
2637 
2638         uint256 previousBalanceFrom = balanceOf(owner);
2639         require(previousBalanceFrom >= amount);
2640 
2641         uint256 newTotalSupply = curTotalSupply - amount;
2642         uint256 newBalanceFrom = previousBalanceFrom - amount;
2643         setValue(_totalSupplyValues, newTotalSupply);
2644         setValue(_balances[owner], newBalanceFrom);
2645 
2646         Transfer(owner, 0, amount);
2647     }
2648 }
2649 
2650 /*
2651     Copyright 2016, Jordi Baylina
2652     Copyright 2017, Remco Bloemen, Marcin Rudolf
2653 
2654     This program is free software: you can redistribute it and/or modify
2655     it under the terms of the GNU General Public License as published by
2656     the Free Software Foundation, either version 3 of the License, or
2657     (at your option) any later version.
2658 
2659     This program is distributed in the hope that it will be useful,
2660     but WITHOUT ANY WARRANTY; without even the implied warranty of
2661     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2662     GNU General Public License for more details.
2663 
2664     You should have received a copy of the GNU General Public License
2665     along with this program.  If not, see <http://www.gnu.org/licenses/>.
2666  */
2667 /// @title StandardSnapshotToken Contract
2668 /// @author Jordi Baylina, Remco Bloemen, Marcin Rudolf
2669 /// @dev This token contract's goal is to make it easy for anyone to clone this
2670 ///  token using the token distribution at a given block, this will allow DAO's
2671 ///  and DApps to upgrade their features in a decentralized manner without
2672 ///  affecting the original token
2673 /// @dev It is ERC20 compliant, but still needs to under go further testing.
2674 /// @dev Various contracts are composed to provide required functionality of this token, different compositions are possible
2675 ///     MintableSnapshotToken provides transfer, miniting and snapshotting functions
2676 ///     TokenAllowance provides approve/transferFrom functions
2677 ///     TokenMetadata adds name, symbol and other token metadata
2678 /// @dev This token is still abstract, Snapshot, BasicSnapshotToken and TokenAllowance observe interfaces that must be implemented
2679 ///     MSnapshotPolicy - particular snapshot id creation mechanism
2680 ///     MTokenController - controlls approvals and transfers
2681 ///     see Neumark as an example
2682 /// @dev implements ERC223 token transfer
2683 contract StandardSnapshotToken is
2684     IERC20Token,
2685     MintableSnapshotToken,
2686     TokenAllowance,
2687     IERC223Token,
2688     IsContract
2689 {
2690     ////////////////////////
2691     // Constructor
2692     ////////////////////////
2693 
2694     /// @notice Constructor to create a MiniMeToken
2695     ///  is a new token
2696     /// param tokenName Name of the new token
2697     /// param decimalUnits Number of decimals of the new token
2698     /// param tokenSymbol Token Symbol for the new token
2699     function StandardSnapshotToken(
2700         IClonedTokenParent parentToken,
2701         uint256 parentSnapshotId
2702     )
2703         MintableSnapshotToken(parentToken, parentSnapshotId)
2704         TokenAllowance()
2705         internal
2706     {}
2707 
2708     ////////////////////////
2709     // Public functions
2710     ////////////////////////
2711 
2712     //
2713     // Implements IERC223Token
2714     //
2715 
2716     function transfer(address to, uint256 amount, bytes data)
2717         public
2718         returns (bool)
2719     {
2720         // it is necessary to point out implementation to be called
2721         BasicSnapshotToken.mTransfer(msg.sender, to, amount);
2722 
2723         // Notify the receiving contract.
2724         if (isContract(to)) {
2725             IERC223Callback(to).onTokenTransfer(msg.sender, amount, data);
2726         }
2727         return true;
2728     }
2729 }
2730 
2731 contract Neumark is
2732     AccessControlled,
2733     AccessRoles,
2734     Agreement,
2735     DailyAndSnapshotable,
2736     StandardSnapshotToken,
2737     TokenMetadata,
2738     NeumarkIssuanceCurve,
2739     Reclaimable
2740 {
2741 
2742     ////////////////////////
2743     // Constants
2744     ////////////////////////
2745 
2746     string private constant TOKEN_NAME = "Neumark";
2747 
2748     uint8  private constant TOKEN_DECIMALS = 18;
2749 
2750     string private constant TOKEN_SYMBOL = "NEU";
2751 
2752     string private constant VERSION = "NMK_1.0";
2753 
2754     ////////////////////////
2755     // Mutable state
2756     ////////////////////////
2757 
2758     // disable transfers when Neumark is created
2759     bool private _transferEnabled = false;
2760 
2761     // at which point on curve new Neumarks will be created, see NeumarkIssuanceCurve contract
2762     // do not use to get total invested funds. see burn(). this is just a cache for expensive inverse function
2763     uint256 private _totalEurUlps;
2764 
2765     ////////////////////////
2766     // Events
2767     ////////////////////////
2768 
2769     event LogNeumarksIssued(
2770         address indexed owner,
2771         uint256 euroUlps,
2772         uint256 neumarkUlps
2773     );
2774 
2775     event LogNeumarksBurned(
2776         address indexed owner,
2777         uint256 euroUlps,
2778         uint256 neumarkUlps
2779     );
2780 
2781     ////////////////////////
2782     // Constructor
2783     ////////////////////////
2784 
2785     function Neumark(
2786         IAccessPolicy accessPolicy,
2787         IEthereumForkArbiter forkArbiter
2788     )
2789         AccessControlled(accessPolicy)
2790         AccessRoles()
2791         Agreement(accessPolicy, forkArbiter)
2792         StandardSnapshotToken(
2793             IClonedTokenParent(0x0),
2794             0
2795         )
2796         TokenMetadata(
2797             TOKEN_NAME,
2798             TOKEN_DECIMALS,
2799             TOKEN_SYMBOL,
2800             VERSION
2801         )
2802         DailyAndSnapshotable(0)
2803         NeumarkIssuanceCurve()
2804         Reclaimable()
2805         public
2806     {}
2807 
2808     ////////////////////////
2809     // Public functions
2810     ////////////////////////
2811 
2812     /// @notice issues new Neumarks to msg.sender with reward at current curve position
2813     ///     moves curve position by euroUlps
2814     ///     callable only by ROLE_NEUMARK_ISSUER
2815     function issueForEuro(uint256 euroUlps)
2816         public
2817         only(ROLE_NEUMARK_ISSUER)
2818         acceptAgreement(msg.sender)
2819         returns (uint256)
2820     {
2821         require(_totalEurUlps + euroUlps >= _totalEurUlps);
2822         uint256 neumarkUlps = incremental(_totalEurUlps, euroUlps);
2823         _totalEurUlps += euroUlps;
2824         mGenerateTokens(msg.sender, neumarkUlps);
2825         LogNeumarksIssued(msg.sender, euroUlps, neumarkUlps);
2826         return neumarkUlps;
2827     }
2828 
2829     /// @notice used by ROLE_NEUMARK_ISSUER to transer newly issued neumarks
2830     ///     typically to the investor and platform operator
2831     function distribute(address to, uint256 neumarkUlps)
2832         public
2833         only(ROLE_NEUMARK_ISSUER)
2834         acceptAgreement(to)
2835     {
2836         mTransfer(msg.sender, to, neumarkUlps);
2837     }
2838 
2839     /// @notice msg.sender can burn their Neumarks, curve is rolled back using inverse
2840     ///     curve. as a result cost of Neumark gets lower (reward is higher)
2841     function burn(uint256 neumarkUlps)
2842         public
2843         only(ROLE_NEUMARK_BURNER)
2844     {
2845         burnPrivate(neumarkUlps, 0, _totalEurUlps);
2846     }
2847 
2848     /// @notice executes as function above but allows to provide search range for low gas burning
2849     function burn(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2850         public
2851         only(ROLE_NEUMARK_BURNER)
2852     {
2853         burnPrivate(neumarkUlps, minEurUlps, maxEurUlps);
2854     }
2855 
2856     function enableTransfer(bool enabled)
2857         public
2858         only(ROLE_TRANSFER_ADMIN)
2859     {
2860         _transferEnabled = enabled;
2861     }
2862 
2863     function createSnapshot()
2864         public
2865         only(ROLE_SNAPSHOT_CREATOR)
2866         returns (uint256)
2867     {
2868         return DailyAndSnapshotable.createSnapshot();
2869     }
2870 
2871     function transferEnabled()
2872         public
2873         constant
2874         returns (bool)
2875     {
2876         return _transferEnabled;
2877     }
2878 
2879     function totalEuroUlps()
2880         public
2881         constant
2882         returns (uint256)
2883     {
2884         return _totalEurUlps;
2885     }
2886 
2887     function incremental(uint256 euroUlps)
2888         public
2889         constant
2890         returns (uint256 neumarkUlps)
2891     {
2892         return incremental(_totalEurUlps, euroUlps);
2893     }
2894 
2895     ////////////////////////
2896     // Internal functions
2897     ////////////////////////
2898 
2899     //
2900     // Implements MTokenController
2901     //
2902 
2903     function mOnTransfer(
2904         address from,
2905         address, // to
2906         uint256 // amount
2907     )
2908         internal
2909         acceptAgreement(from)
2910         returns (bool allow)
2911     {
2912         // must have transfer enabled or msg.sender is Neumark issuer
2913         return _transferEnabled || accessPolicy().allowed(msg.sender, ROLE_NEUMARK_ISSUER, this, msg.sig);
2914     }
2915 
2916     function mOnApprove(
2917         address owner,
2918         address, // spender,
2919         uint256 // amount
2920     )
2921         internal
2922         acceptAgreement(owner)
2923         returns (bool allow)
2924     {
2925         return true;
2926     }
2927 
2928     ////////////////////////
2929     // Private functions
2930     ////////////////////////
2931 
2932     function burnPrivate(uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2933         private
2934     {
2935         uint256 prevEuroUlps = _totalEurUlps;
2936         // burn first in the token to make sure balance/totalSupply is not crossed
2937         mDestroyTokens(msg.sender, burnNeumarkUlps);
2938         _totalEurUlps = cumulativeInverse(totalSupply(), minEurUlps, maxEurUlps);
2939         // actually may overflow on non-monotonic inverse
2940         assert(prevEuroUlps >= _totalEurUlps);
2941         uint256 euroUlps = prevEuroUlps - _totalEurUlps;
2942         LogNeumarksBurned(msg.sender, euroUlps, burnNeumarkUlps);
2943     }
2944 }
2945 
2946 contract TimeSource {
2947 
2948     ////////////////////////
2949     // Public functions
2950     ////////////////////////
2951 
2952     function currentTime() internal constant returns (uint256) {
2953         return block.timestamp;
2954     }
2955 }
2956 
2957 contract LockedAccount is
2958     AccessControlled,
2959     AccessRoles,
2960     TimeSource,
2961     Math,
2962     IsContract,
2963     MigrationSource,
2964     IERC677Callback,
2965     Reclaimable
2966 {
2967 
2968     ////////////////////////
2969     // Type declarations
2970     ////////////////////////
2971 
2972     // state space of LockedAccount
2973     enum LockState {
2974         // controller is not yet set
2975         Uncontrolled,
2976         // new funds lockd are accepted from investors
2977         AcceptingLocks,
2978         // funds may be unlocked by investors, final state
2979         AcceptingUnlocks,
2980         // funds may be unlocked by investors, without any constraints, final state
2981         ReleaseAll
2982     }
2983 
2984     // represents locked account of the investor
2985     struct Account {
2986         // funds locked in the account
2987         uint256 balance;
2988         // neumark amount that must be returned to unlock
2989         uint256 neumarksDue;
2990         // date with which unlock may happen without penalty
2991         uint256 unlockDate;
2992     }
2993 
2994     ////////////////////////
2995     // Immutable state
2996     ////////////////////////
2997 
2998     // a token controlled by LockedAccount, read ERC20 + extensions to read what
2999     // token is it (ETH/EUR etc.)
3000     IERC677Token private ASSET_TOKEN;
3001 
3002     Neumark private NEUMARK;
3003 
3004     // longstop period in seconds
3005     uint256 private LOCK_PERIOD;
3006 
3007     // penalty: decimalFraction of stored amount on escape hatch
3008     uint256 private PENALTY_FRACTION;
3009 
3010     ////////////////////////
3011     // Mutable state
3012     ////////////////////////
3013 
3014     // total amount of tokens locked
3015     uint256 private _totalLockedAmount;
3016 
3017     // total number of locked investors
3018     uint256 internal _totalInvestors;
3019 
3020     // current state of the locking contract
3021     LockState private _lockState;
3022 
3023     // controlling contract that may lock money or unlock all account if fails
3024     address private _controller;
3025 
3026     // fee distribution pool
3027     address private _penaltyDisbursalAddress;
3028 
3029     // LockedAccountMigration private migration;
3030     mapping(address => Account) internal _accounts;
3031 
3032     ////////////////////////
3033     // Events
3034     ////////////////////////
3035 
3036     /// @notice logged when funds are locked by investor
3037     /// @param investor address of investor locking funds
3038     /// @param amount amount of newly locked funds
3039     /// @param amount of neumarks that must be returned to unlock funds
3040     event LogFundsLocked(
3041         address indexed investor,
3042         uint256 amount,
3043         uint256 neumarks
3044     );
3045 
3046     /// @notice logged when investor unlocks funds
3047     /// @param investor address of investor unlocking funds
3048     /// @param amount amount of unlocked funds
3049     /// @param neumarks amount of Neumarks that was burned
3050     event LogFundsUnlocked(
3051         address indexed investor,
3052         uint256 amount,
3053         uint256 neumarks
3054     );
3055 
3056     /// @notice logged when unlock penalty is disbursed to Neumark holders
3057     /// @param disbursalPoolAddress address of disbursal pool receiving penalty
3058     /// @param amount penalty amount
3059     /// @param assetToken address of token contract penalty was paid with
3060     /// @param investor addres of investor paying penalty
3061     /// @dev assetToken and investor parameters are added for quick tallying penalty payouts
3062     event LogPenaltyDisbursed(
3063         address indexed disbursalPoolAddress,
3064         uint256 amount,
3065         address assetToken,
3066         address investor
3067     );
3068 
3069     /// @notice logs Locked Account state transitions
3070     event LogLockStateTransition(
3071         LockState oldState,
3072         LockState newState
3073     );
3074 
3075     event LogInvestorMigrated(
3076         address indexed investor,
3077         uint256 amount,
3078         uint256 neumarks,
3079         uint256 unlockDate
3080     );
3081 
3082     ////////////////////////
3083     // Modifiers
3084     ////////////////////////
3085 
3086     modifier onlyController() {
3087         require(msg.sender == address(_controller));
3088         _;
3089     }
3090 
3091     modifier onlyState(LockState state) {
3092         require(_lockState == state);
3093         _;
3094     }
3095 
3096     modifier onlyStates(LockState state1, LockState state2) {
3097         require(_lockState == state1 || _lockState == state2);
3098         _;
3099     }
3100 
3101     ////////////////////////
3102     // Constructor
3103     ////////////////////////
3104 
3105     /// @notice creates new LockedAccount instance
3106     /// @param policy governs execution permissions to admin functions
3107     /// @param assetToken token contract representing funds locked
3108     /// @param neumark Neumark token contract
3109     /// @param penaltyDisbursalAddress address of disbursal contract for penalty fees
3110     /// @param lockPeriod period for which funds are locked, in seconds
3111     /// @param penaltyFraction decimal fraction of unlocked amount paid as penalty,
3112     ///     if unlocked before lockPeriod is over
3113     /// @dev this implementation does not allow spending funds on ICOs but provides
3114     ///     a migration mechanism to final LockedAccount with such functionality
3115     function LockedAccount(
3116         IAccessPolicy policy,
3117         IERC677Token assetToken,
3118         Neumark neumark,
3119         address penaltyDisbursalAddress,
3120         uint256 lockPeriod,
3121         uint256 penaltyFraction
3122     )
3123         AccessControlled(policy)
3124         MigrationSource(policy, ROLE_LOCKED_ACCOUNT_ADMIN)
3125         Reclaimable()
3126         public
3127     {
3128         ASSET_TOKEN = assetToken;
3129         NEUMARK = neumark;
3130         LOCK_PERIOD = lockPeriod;
3131         PENALTY_FRACTION = penaltyFraction;
3132         _penaltyDisbursalAddress = penaltyDisbursalAddress;
3133     }
3134 
3135     ////////////////////////
3136     // Public functions
3137     ////////////////////////
3138 
3139     /// @notice locks funds of investors for a period of time
3140     /// @param investor funds owner
3141     /// @param amount amount of funds locked
3142     /// @param neumarks amount of neumarks that needs to be returned by investor to unlock funds
3143     /// @dev callable only from controller (Commitment) contract
3144     function lock(address investor, uint256 amount, uint256 neumarks)
3145         public
3146         onlyState(LockState.AcceptingLocks)
3147         onlyController()
3148     {
3149         require(amount > 0);
3150         // transfer to itself from Commitment contract allowance
3151         assert(ASSET_TOKEN.transferFrom(msg.sender, address(this), amount));
3152 
3153         Account storage account = _accounts[investor];
3154         account.balance = addBalance(account.balance, amount);
3155         account.neumarksDue = add(account.neumarksDue, neumarks);
3156 
3157         if (account.unlockDate == 0) {
3158             // this is new account - unlockDate always > 0
3159             _totalInvestors += 1;
3160             account.unlockDate = currentTime() + LOCK_PERIOD;
3161         }
3162         LogFundsLocked(investor, amount, neumarks);
3163     }
3164 
3165     /// @notice unlocks investors funds, see unlockInvestor for details
3166     /// @dev function requires that proper allowance on Neumark is made to LockedAccount by msg.sender
3167     ///     except in ReleaseAll state which does not burn Neumark
3168     function unlock()
3169         public
3170         onlyStates(LockState.AcceptingUnlocks, LockState.ReleaseAll)
3171     {
3172         unlockInvestor(msg.sender);
3173     }
3174 
3175     /// @notice unlocks investors funds, see unlockInvestor for details
3176     /// @dev this ERC667 callback by Neumark contract after successful approve
3177     ///     allows to unlock and allow neumarks to be burned in one transaction
3178     function receiveApproval(
3179         address from,
3180         uint256, // _amount,
3181         address _token,
3182         bytes _data
3183     )
3184         public
3185         onlyState(LockState.AcceptingUnlocks)
3186         returns (bool)
3187     {
3188         require(msg.sender == _token);
3189         require(_data.length == 0);
3190 
3191         // only from neumarks
3192         require(_token == address(NEUMARK));
3193 
3194         // this will check if allowance was made and if _amount is enough to
3195         //  unlock, reverts on any error condition
3196         unlockInvestor(from);
3197 
3198         // we assume external call so return value will be lost to clients
3199         // that's why we throw above
3200         return true;
3201     }
3202 
3203     /// allows to anyone to release all funds without burning Neumarks and any
3204     /// other penalties
3205     function controllerFailed()
3206         public
3207         onlyState(LockState.AcceptingLocks)
3208         onlyController()
3209     {
3210         changeState(LockState.ReleaseAll);
3211     }
3212 
3213     /// allows anyone to use escape hatch
3214     function controllerSucceeded()
3215         public
3216         onlyState(LockState.AcceptingLocks)
3217         onlyController()
3218     {
3219         changeState(LockState.AcceptingUnlocks);
3220     }
3221 
3222     function setController(address controller)
3223         public
3224         only(ROLE_LOCKED_ACCOUNT_ADMIN)
3225         onlyState(LockState.Uncontrolled)
3226     {
3227         _controller = controller;
3228         changeState(LockState.AcceptingLocks);
3229     }
3230 
3231     /// sets address to which tokens from unlock penalty are sent
3232     /// both simple addresses and contracts are allowed
3233     /// contract needs to implement ApproveAndCallCallback interface
3234     function setPenaltyDisbursal(address penaltyDisbursalAddress)
3235         public
3236         only(ROLE_LOCKED_ACCOUNT_ADMIN)
3237     {
3238         require(penaltyDisbursalAddress != address(0));
3239 
3240         // can be changed at any moment by admin
3241         _penaltyDisbursalAddress = penaltyDisbursalAddress;
3242     }
3243 
3244     function assetToken()
3245         public
3246         constant
3247         returns (IERC677Token)
3248     {
3249         return ASSET_TOKEN;
3250     }
3251 
3252     function neumark()
3253         public
3254         constant
3255         returns (Neumark)
3256     {
3257         return NEUMARK;
3258     }
3259 
3260     function lockPeriod()
3261         public
3262         constant
3263         returns (uint256)
3264     {
3265         return LOCK_PERIOD;
3266     }
3267 
3268     function penaltyFraction()
3269         public
3270         constant
3271         returns (uint256)
3272     {
3273         return PENALTY_FRACTION;
3274     }
3275 
3276     function balanceOf(address investor)
3277         public
3278         constant
3279         returns (uint256, uint256, uint256)
3280     {
3281         Account storage account = _accounts[investor];
3282         return (account.balance, account.neumarksDue, account.unlockDate);
3283     }
3284 
3285     function controller()
3286         public
3287         constant
3288         returns (address)
3289     {
3290         return _controller;
3291     }
3292 
3293     function lockState()
3294         public
3295         constant
3296         returns (LockState)
3297     {
3298         return _lockState;
3299     }
3300 
3301     function totalLockedAmount()
3302         public
3303         constant
3304         returns (uint256)
3305     {
3306         return _totalLockedAmount;
3307     }
3308 
3309     function totalInvestors()
3310         public
3311         constant
3312         returns (uint256)
3313     {
3314         return _totalInvestors;
3315     }
3316 
3317     function penaltyDisbursalAddress()
3318         public
3319         constant
3320         returns (address)
3321     {
3322         return _penaltyDisbursalAddress;
3323     }
3324 
3325     //
3326     // Overrides migration source
3327     //
3328 
3329     /// enables migration to new LockedAccount instance
3330     /// it can be set only once to prevent setting temporary migrations that let
3331     /// just one investor out
3332     /// may be set in AcceptingLocks state (in unlikely event that controller
3333     /// fails we let investors out)
3334     /// and AcceptingUnlocks - which is normal operational mode
3335     function enableMigration(IMigrationTarget migration)
3336         public
3337         onlyStates(LockState.AcceptingLocks, LockState.AcceptingUnlocks)
3338     {
3339         // will enforce other access controls
3340         MigrationSource.enableMigration(migration);
3341     }
3342 
3343     /// migrates single investor
3344     function migrate()
3345         public
3346         onlyMigrationEnabled()
3347     {
3348         // migrates
3349         Account memory account = _accounts[msg.sender];
3350 
3351         // return on non existing accounts silently
3352         if (account.balance == 0) {
3353             return;
3354         }
3355 
3356         // this will clear investor storage
3357         removeInvestor(msg.sender, account.balance);
3358 
3359         // let migration target to own asset balance that belongs to investor
3360         assert(ASSET_TOKEN.approve(address(_migration), account.balance));
3361         LockedAccountMigration(_migration).migrateInvestor(
3362             msg.sender,
3363             account.balance,
3364             account.neumarksDue,
3365             account.unlockDate
3366         );
3367         LogInvestorMigrated(msg.sender, account.balance, account.neumarksDue, account.unlockDate);
3368     }
3369 
3370     //
3371     // Overrides Reclaimable
3372     //
3373 
3374     /// @notice allows LockedAccount to reclaim tokens wrongly sent to its address
3375     /// @dev as LockedAccount by design has balance of assetToken (in the name of investors)
3376     ///     such reclamation is not allowed
3377     function reclaim(IBasicToken token)
3378         public
3379     {
3380         // forbid reclaiming locked tokens
3381         require(token != ASSET_TOKEN);
3382         Reclaimable.reclaim(token);
3383     }
3384 
3385     ////////////////////////
3386     // Internal functions
3387     ////////////////////////
3388 
3389     function addBalance(uint256 balance, uint256 amount)
3390         internal
3391         returns (uint256)
3392     {
3393         _totalLockedAmount = add(_totalLockedAmount, amount);
3394         uint256 newBalance = balance + amount;
3395         return newBalance;
3396     }
3397 
3398     ////////////////////////
3399     // Private functions
3400     ////////////////////////
3401 
3402     function subBalance(uint256 balance, uint256 amount)
3403         private
3404         returns (uint256)
3405     {
3406         _totalLockedAmount -= amount;
3407         return balance - amount;
3408     }
3409 
3410     function removeInvestor(address investor, uint256 balance)
3411         private
3412     {
3413         subBalance(balance, balance);
3414         _totalInvestors -= 1;
3415         delete _accounts[investor];
3416     }
3417 
3418     function changeState(LockState newState)
3419         private
3420     {
3421         assert(newState != _lockState);
3422         LogLockStateTransition(_lockState, newState);
3423         _lockState = newState;
3424     }
3425 
3426     /// @notice unlocks 'investor' tokens by making them withdrawable from assetToken
3427     /// @dev expects number of neumarks that is due on investor's account to be approved for LockedAccount for transfer
3428     /// @dev there are 3 unlock modes depending on contract and investor state
3429     ///     in 'AcceptingUnlocks' state Neumarks due will be burned and funds transferred to investors address in assetToken,
3430     ///         before unlockDate, penalty is deduced and distributed
3431     ///     in 'ReleaseAll' neumarks are not burned and unlockDate is not observed, funds are unlocked unconditionally
3432     function unlockInvestor(address investor)
3433         private
3434     {
3435         // use memory storage to obtain copy and be able to erase storage
3436         Account memory accountInMem = _accounts[investor];
3437 
3438         // silently return on non-existing accounts
3439         if (accountInMem.balance == 0) {
3440             return;
3441         }
3442         // remove investor account before external calls
3443         removeInvestor(investor, accountInMem.balance);
3444 
3445         // Neumark burning and penalty processing only in AcceptingUnlocks state
3446         if (_lockState == LockState.AcceptingUnlocks) {
3447             // transfer Neumarks to be burned to itself via allowance mechanism
3448             //  not enough allowance results in revert which is acceptable state so 'require' is used
3449             require(NEUMARK.transferFrom(investor, address(this), accountInMem.neumarksDue));
3450 
3451             // burn neumarks corresponding to unspent funds
3452             NEUMARK.burn(accountInMem.neumarksDue);
3453 
3454             // take the penalty if before unlockDate
3455             if (currentTime() < accountInMem.unlockDate) {
3456                 require(_penaltyDisbursalAddress != address(0));
3457                 uint256 penalty = decimalFraction(accountInMem.balance, PENALTY_FRACTION);
3458 
3459                 // distribute penalty
3460                 if (isContract(_penaltyDisbursalAddress)) {
3461                     require(
3462                         ASSET_TOKEN.approveAndCall(_penaltyDisbursalAddress,penalty, "")
3463                     );
3464                 } else {
3465                     // transfer to simple address
3466                     assert(ASSET_TOKEN.transfer(_penaltyDisbursalAddress, penalty));
3467                 }
3468                 LogPenaltyDisbursed(_penaltyDisbursalAddress, penalty, ASSET_TOKEN, investor);
3469                 accountInMem.balance -= penalty;
3470             }
3471         }
3472         if (_lockState == LockState.ReleaseAll) {
3473             accountInMem.neumarksDue = 0;
3474         }
3475         // transfer amount back to investor - now it can withdraw
3476         assert(ASSET_TOKEN.transfer(investor, accountInMem.balance));
3477         LogFundsUnlocked(investor, accountInMem.balance, accountInMem.neumarksDue);
3478     }
3479 }
3480 
3481 /// @title state machine for Commitment contract
3482 /// @notice implements following state progression Before --> Whitelist --> Public --> Finished
3483 /// @dev state switching via 'transitionTo' function
3484 /// @dev inherited contract must implement mAfterTransition which will be called just after state transition happened
3485 contract StateMachine {
3486 
3487     ////////////////////////
3488     // Types
3489     ////////////////////////
3490 
3491     enum State {
3492         Before,
3493         Whitelist,
3494         Public,
3495         Finished
3496     }
3497 
3498     ////////////////////////
3499     // Mutable state
3500     ////////////////////////
3501 
3502     // current state
3503     State private _state = State.Before;
3504 
3505     ////////////////////////
3506     // Events
3507     ////////////////////////
3508 
3509     event LogStateTransition(
3510         State oldState,
3511         State newState
3512     );
3513 
3514     ////////////////////////
3515     // Modifiers
3516     ////////////////////////
3517 
3518     modifier onlyState(State state) {
3519         require(_state == state);
3520         _;
3521     }
3522 
3523     modifier onlyStates(State state0, State state1) {
3524         require(_state == state0 || _state == state1);
3525         _;
3526     }
3527 
3528     /// @dev Multiple states can be handled by adding more modifiers.
3529     /* modifier notInState(State state) {
3530         require(_state != state);
3531         _;
3532     }*/
3533 
3534     ////////////////////////
3535     // Constructor
3536     ////////////////////////
3537 
3538     function StateMachine() internal {
3539     }
3540 
3541     ////////////////////////
3542     // Public functions
3543     ////////////////////////
3544 
3545     function state()
3546         public
3547         constant
3548         returns (State)
3549     {
3550         return _state;
3551     }
3552 
3553     ////////////////////////
3554     // Internal functions
3555     ////////////////////////
3556 
3557     // @dev Transitioning to the same state is silently ignored, no log events
3558     //  or handlers are called.
3559     function transitionTo(State newState)
3560         internal
3561     {
3562         State oldState = _state;
3563         require(validTransition(oldState, newState));
3564 
3565         _state = newState;
3566         LogStateTransition(oldState, newState);
3567 
3568         // should not change state and it is required here.
3569         mAfterTransition(oldState, newState);
3570         require(_state == newState);
3571     }
3572 
3573     function validTransition(State oldState, State newState)
3574         private
3575         constant
3576         returns (bool valid)
3577     {
3578         return (
3579             oldState == State.Before && newState == State.Whitelist) || (
3580             oldState == State.Whitelist && newState == State.Public) || (
3581             oldState == State.Public && newState == State.Finished
3582         );
3583     }
3584 
3585     /// @notice gets called after every state transition.
3586     /// @dev may not change state, transitionTo will revert on that condition
3587     function mAfterTransition(State oldState, State newState)
3588         internal;
3589 }
3590 
3591 /// @title time induced state machine
3592 /// @notice ------ time ----->
3593 ///
3594 ///  +--------+-----------+--------+------------
3595 ///  | Before | Whitelist | Public | Finished …
3596 ///  +--------+-----------+--------+------------
3597 /// @dev intended usage via 'withTimedTransitions' modifier which makes sure that state machine transitions into
3598 ///     correct state before executing function body. note that this is contract state changing modifier so use with care
3599 /// @dev state change request is publicly accessible via 'handleTimedTransitions'
3600 /// @dev time is based on block.timestamp
3601 contract TimedStateMachine is StateMachine {
3602 
3603     ////////////////////////
3604     // Constants
3605     ////////////////////////
3606 
3607     // duration of Whitelist state
3608     int256 private constant WHITELIST_DURATION = 5 days;
3609 
3610     // duration of Public state
3611     int256 private constant PUBLIC_DURATION = 30 days;
3612 
3613     ////////////////////////
3614     // Immutable state
3615     ////////////////////////
3616 
3617     // timestamp at which Whitelist phase of Commitment starts
3618     // @dev set in TimedStateMachine constructor, it is an exclusive reference point
3619     //      to all time induced state changes in this contract
3620     int256 internal WHITELIST_START;
3621 
3622     ////////////////////////
3623     // Modifiers
3624     ////////////////////////
3625 
3626     // @dev This modifier needs to be applied to all external non-constant
3627     //     functions.
3628     // @dev This modifier goes _before_ other state modifiers like `onlyState`.
3629     modifier withTimedTransitions() {
3630         handleTimedTransitions();
3631         _;
3632     }
3633 
3634     ////////////////////////
3635     // Constructor
3636     ////////////////////////
3637 
3638     function TimedStateMachine(int256 whitelistStart)
3639         internal
3640     {
3641         WHITELIST_START = whitelistStart;
3642     }
3643 
3644     ////////////////////////
3645     // Public functions
3646     ////////////////////////
3647 
3648     // @notice This function is public so that it can be called independently.
3649     function handleTimedTransitions()
3650         public
3651     {
3652         int256 t = int256(block.timestamp);
3653 
3654         // Time induced state transitions.
3655         // @dev Don't use `else if` and keep sorted by time and call `state()`
3656         //     or else multiple transitions won't cascade properly.
3657         if (state() == State.Before && t >= startOf(State.Whitelist)) {
3658             transitionTo(State.Whitelist);
3659         }
3660         if (state() == State.Whitelist && t >= startOf(State.Public)) {
3661             transitionTo(State.Public);
3662         }
3663         if (state() == State.Public && t >= startOf(State.Finished)) {
3664             transitionTo(State.Finished);
3665         }
3666     }
3667 
3668     function startOf(State state)
3669         public
3670         constant
3671         returns (int256)
3672     {
3673         if (state == State.Before) {
3674             return 0;
3675         }
3676         if (state == State.Whitelist) {
3677             return WHITELIST_START;
3678         }
3679         if (state == State.Public) {
3680             return WHITELIST_START + WHITELIST_DURATION;
3681         }
3682         if (state == State.Finished) {
3683             return WHITELIST_START + WHITELIST_DURATION + PUBLIC_DURATION;
3684         }
3685     }
3686 }
3687 
3688 /// @title processes capital commitments into Neufund ecosystem
3689 contract Commitment is
3690     AccessControlled,
3691     Agreement,
3692     TimedStateMachine,
3693     Reclaimable,
3694     Math
3695 {
3696     ////////////////////////
3697     // Types
3698     ////////////////////////
3699 
3700     // The two tokens accepted in a pre-allocated ticket.
3701     enum Token {
3702         None,
3703         Ether,
3704         Euro
3705     }
3706 
3707     // Pre-allocated tickets with a pre-allocated neumark reward.
3708     struct WhitelistTicket {
3709 
3710         // The currency the investor wants and is allowed to committed.
3711         Token token;
3712 
3713         // The amount the investor committed. The investor can invest more or
3714         // less than this amount. In units of least precision of the token.
3715         uint256 amountEurUlps;
3716 
3717         // The amount of Neumark reward for this commitment (computed by
3718         // contract). Investor can still invest more, but that would be at
3719         // spot price.
3720         uint256 rewardNmk;
3721     }
3722 
3723     ////////////////////////
3724     // Constants
3725     ////////////////////////
3726 
3727     // share of Neumark reward platform operator gets
3728     // actually this is a divisor that splits Neumark reward in two parts
3729     // the results of division belongs to platform operator, the remaining reward part belongs to investor
3730     uint256 private constant PLATFORM_NEUMARK_SHARE = 2; // 50:50 division
3731 
3732     ////////////////////////
3733     // Immutable state
3734     ////////////////////////
3735 
3736     // wallet that keeps Platform Operator share of neumarks
3737     address private PLATFORM_WALLET;
3738 
3739     Neumark private NEUMARK;
3740 
3741     EtherToken private ETHER_TOKEN;
3742 
3743     EuroToken private EURO_TOKEN;
3744 
3745     LockedAccount private ETHER_LOCK;
3746 
3747     LockedAccount private EURO_LOCK;
3748 
3749     // maximum amount of EuroToken that can be committed to generate Neumark reward
3750     // indirectly this is cap for Neumark amount generated as it is checked against NEUMARK.totalEuroUlps()
3751     uint256 private CAP_EUR_ULPS;
3752 
3753     // minimum amount of EuroToken that may be committed
3754     uint256 private MIN_TICKET_EUR_ULPS;
3755 
3756     // fixed ETH/EUR price during the commitment, used to convert ETH into EUR, see convertToEur
3757     uint256 private ETH_EUR_FRACTION;
3758 
3759     ////////////////////////
3760     // Mutable state
3761     ////////////////////////
3762 
3763     // Mapping of investor to pre-allocated tickets.
3764     mapping (address => WhitelistTicket) private _whitelist;
3765 
3766     // List of pre-allocated ticket investors.
3767     // NOTE: The order of of the investors matters when computing the reward.
3768     address[] private _whitelistInvestors;
3769 
3770     // amount of Neumarks reserved for Ether whitelist investors
3771     uint256 private _whitelistEtherNmk = 0;
3772 
3773     // amount of Neumarks reserved for Euro whitelist investors
3774     uint256 private _whitelistEuroNmk = 0;
3775 
3776     ////////////////////////
3777     // Events
3778     ////////////////////////
3779 
3780     /// on every commitment transaction
3781     /// `investor` committed `amount` in `paymentToken` currency which was
3782     /// converted to `eurEquivalent` that generates `grantedAmount` of
3783     /// `ofToken`.
3784     event LogFundsCommitted(
3785         address indexed investor,
3786         address indexed paymentToken,
3787         uint256 amount,
3788         uint256 eurEquivalent,
3789         uint256 grantedAmount,
3790         address ofToken
3791     );
3792 
3793     ////////////////////////
3794     // Constructor
3795     ////////////////////////
3796 
3797     /// @param accessPolicy access policy instance controlling access to admin public functions
3798     /// @param forkArbiter indicates supported fork
3799     /// @param startDate timestamp of Whitelist state beginning, see TimedStateMachine constructor
3800     /// @param platformWallet address of wallet storing platform operator's Neumarks
3801     /// @param neumark Neumark token contract
3802     /// @param etherToken ether-encapsulating token contract
3803     /// @param euroToken euro pegged stable coin
3804     /// @param etherLock manages locking mechanism for ether investors
3805     /// @param euroLock manages locking mechanism for euro token investors
3806     /// @param capEurUlps maxium amount of euro tokens committed
3807     /// @param minTicketEurUlps minimum ticket size
3808     /// @param ethEurFraction Ether to Euro rate, fixed during commitment
3809     function Commitment(
3810         IAccessPolicy accessPolicy,
3811         IEthereumForkArbiter forkArbiter,
3812         int256 startDate,
3813         address platformWallet,
3814         Neumark neumark,
3815         EtherToken etherToken,
3816         EuroToken euroToken,
3817         LockedAccount etherLock,
3818         LockedAccount euroLock,
3819         uint256 capEurUlps,
3820         uint256 minTicketEurUlps,
3821         uint256 ethEurFraction
3822     )
3823         AccessControlled(accessPolicy)
3824         Agreement(accessPolicy, forkArbiter)
3825         TimedStateMachine(startDate)
3826         public
3827     {
3828         require(platformWallet != 0x0);
3829         require(address(neumark) != 0x0);
3830         require(address(etherToken) != 0x0);
3831         require(address(euroToken) != 0x0);
3832         require(address(etherLock) != 0x0);
3833         require(etherLock.assetToken() == etherToken);
3834         require(address(euroLock) != 0x0);
3835         require(euroLock.assetToken() == euroToken);
3836         // Euro is represented internally with 18 decimals
3837         require(capEurUlps >= 10**18*10**6); // 1 M€
3838         require(capEurUlps <= 10**18*10**9); // 1 G€
3839         require(minTicketEurUlps >= 10**18*10**2); // 100 €
3840         require(minTicketEurUlps <= 10**18*10**5); // 100 k€
3841         require(ethEurFraction >= 10**18*10**2); // 100 € / ETH
3842         require(ethEurFraction <= 10**18*10**4); // 10 k€ / ETH
3843         PLATFORM_WALLET = platformWallet;
3844         NEUMARK = neumark;
3845         ETHER_TOKEN = etherToken;
3846         EURO_TOKEN = euroToken;
3847         ETHER_LOCK = etherLock;
3848         EURO_LOCK = euroLock;
3849         CAP_EUR_ULPS = capEurUlps;
3850         MIN_TICKET_EUR_ULPS = minTicketEurUlps;
3851         ETH_EUR_FRACTION = ethEurFraction;
3852     }
3853 
3854     ////////////////////////
3855     // External functions
3856     ////////////////////////
3857 
3858     function addWhitelisted(
3859         address[] investors,
3860         Token[] tokens,
3861         uint256[] amounts
3862     )
3863         external
3864         withTimedTransitions()
3865         onlyState(State.Before)
3866         only(ROLE_WHITELIST_ADMIN)
3867     {
3868         require(investors.length == tokens.length);
3869         require(investors.length == amounts.length);
3870 
3871         for (uint256 i = 0; i < investors.length; ++i) {
3872             addWhitelistInvestorPrivate(investors[i], tokens[i], amounts[i]);
3873         }
3874 
3875         // We don't go over the cap
3876         require(NEUMARK.totalEuroUlps() <= CAP_EUR_ULPS);
3877     }
3878 
3879     /// @notice used by WHITELIST_ADMIN to kill commitment process before it starts
3880     /// @dev by selfdestruct we make all LockContracts controlled by this contract dysfunctional
3881     function abort()
3882         external
3883         withTimedTransitions()
3884         onlyState(State.Before)
3885         only(ROLE_WHITELIST_ADMIN)
3886     {
3887         // Return all Neumarks that may have been reserved.
3888         NEUMARK.burn(NEUMARK.balanceOf(this));
3889 
3890         // At this point we can kill the contract, it can not have aquired any
3891         // other value.
3892         selfdestruct(msg.sender);
3893     }
3894 
3895     function commit()
3896         external
3897         payable
3898         withTimedTransitions()
3899         onlyStates(State.Whitelist, State.Public)
3900         acceptAgreement(msg.sender) // agreement accepted by act of reserving funds in this function
3901     {
3902         // Take with EtherToken allowance (if any)
3903         uint256 allowedAmount = ETHER_TOKEN.allowance(msg.sender, this);
3904         uint256 committedAmount = add(allowedAmount, msg.value);
3905         uint256 committedEurUlps = convertToEur(committedAmount);
3906         // check against minimum ticket before proceeding
3907         require(committedEurUlps >= MIN_TICKET_EUR_ULPS);
3908 
3909         if (allowedAmount > 0) {
3910             assert(ETHER_TOKEN.transferFrom(msg.sender, this, allowedAmount));
3911         }
3912         if (msg.value > 0) {
3913             ETHER_TOKEN.deposit.value(msg.value)();
3914         }
3915 
3916         // calculate Neumark reward and update Whitelist ticket
3917         uint256 investorNmk = getInvestorNeumarkReward(committedEurUlps, Token.Ether);
3918 
3919         // Lock EtherToken
3920         ETHER_TOKEN.approve(ETHER_LOCK, committedAmount);
3921         ETHER_LOCK.lock(msg.sender, committedAmount, investorNmk);
3922 
3923         // Log successful commitment
3924         LogFundsCommitted(
3925             msg.sender,
3926             ETHER_TOKEN,
3927             committedAmount,
3928             committedEurUlps,
3929             investorNmk,
3930             NEUMARK
3931         );
3932     }
3933 
3934     function commitEuro()
3935         external
3936         withTimedTransitions()
3937         onlyStates(State.Whitelist, State.Public)
3938         acceptAgreement(msg.sender) // agreement accepted by act of reserving funds in this function
3939     {
3940         // receive Euro tokens
3941         uint256 committedEurUlps = EURO_TOKEN.allowance(msg.sender, this);
3942         // check against minimum ticket before proceeding
3943         require(committedEurUlps >= MIN_TICKET_EUR_ULPS);
3944 
3945         assert(EURO_TOKEN.transferFrom(msg.sender, this, committedEurUlps));
3946 
3947         // calculate Neumark reward and update Whitelist ticket
3948         uint256 investorNmk = getInvestorNeumarkReward(committedEurUlps, Token.Euro);
3949 
3950         // Lock EuroToken
3951         EURO_TOKEN.approve(EURO_LOCK, committedEurUlps);
3952         EURO_LOCK.lock(msg.sender, committedEurUlps, investorNmk);
3953 
3954         // Log successful commitment
3955         LogFundsCommitted(
3956             msg.sender,
3957             EURO_TOKEN,
3958             committedEurUlps,
3959             committedEurUlps,
3960             investorNmk,
3961             NEUMARK
3962         );
3963     }
3964 
3965     function estimateNeumarkReward(uint256 amount)
3966         external
3967         constant
3968         returns (uint256)
3969     {
3970         uint256 amountEurUlps = convertToEur(amount);
3971         uint256 rewardNmk = NEUMARK.incremental(amountEurUlps);
3972         var (, investorNmk) = calculateNeumarkDistribtion(rewardNmk);
3973         return investorNmk;
3974     }
3975 
3976     ////////////////////////
3977     // Public functions
3978     ////////////////////////
3979 
3980     /// converts `amount` in wei into EUR with 18 decimals required by Curve
3981     /// Neufund public commitment uses fixed EUR rate during commitment to level playing field and
3982     /// prevent strategic behavior around ETH/EUR volatility. equity TOs will use oracles as they need spot prices
3983     ///
3984     /// @notice Considering the max possible ETH_EUR_FRACTION value (10**18*10**4 == ~2**73), the max
3985     ///       amount of ETH (not wei) that is safe to be passed as the argument
3986     ///       is ~10**(54 - 18) (~2**123).
3987     function convertToEur(uint256 amount)
3988         public
3989         constant
3990         returns (uint256)
3991     {
3992         require(amount < 2**123);
3993         return decimalFraction(amount, ETH_EUR_FRACTION);
3994     }
3995 
3996     function platformWalletAddress()
3997         public
3998         constant
3999         returns (address)
4000     {
4001         return PLATFORM_WALLET;
4002     }
4003 
4004     function neumark()
4005         public
4006         constant
4007         returns (Neumark)
4008     {
4009         return NEUMARK;
4010     }
4011 
4012     function etherLock()
4013         public
4014         constant
4015         returns (LockedAccount)
4016     {
4017         return ETHER_LOCK;
4018     }
4019 
4020     function euroLock()
4021         public
4022         constant
4023         returns (LockedAccount)
4024     {
4025         return EURO_LOCK;
4026     }
4027 
4028     function maxCapEur()
4029         public
4030         constant
4031         returns (uint256)
4032     {
4033         return CAP_EUR_ULPS;
4034     }
4035 
4036     function minTicketEur()
4037         public
4038         constant
4039         returns (uint256)
4040     {
4041         return MIN_TICKET_EUR_ULPS;
4042     }
4043 
4044     function ethEurFraction()
4045         public
4046         constant
4047         returns (uint256)
4048     {
4049         return ETH_EUR_FRACTION;
4050     }
4051 
4052     function platformOperatorNeumarkRewardShare()
4053         public
4054         constant
4055         returns (uint256)
4056     {
4057         return PLATFORM_NEUMARK_SHARE;
4058     }
4059 
4060     // used to enumerate investors in whitelist
4061     function whitelistInvestor(uint256 atWhitelistPosition)
4062         public
4063         constant
4064         returns (address)
4065     {
4066         return _whitelistInvestors[atWhitelistPosition];
4067     }
4068 
4069     // ticket information for particular investors
4070     function whitelistTicket(address investor)
4071         public
4072         constant
4073         returns (Token token, uint256 ticketEurUlps, uint256 /*investorNmk*/)
4074     {
4075         WhitelistTicket storage ticket = _whitelist[investor];
4076         //  could also use ( , investorNmk) but parser has problems in solium TODO fix solium
4077         var (, investorNmk) = calculateNeumarkDistribtion(ticket.rewardNmk);
4078         return (ticket.token, ticket.amountEurUlps, investorNmk);
4079     }
4080 
4081     ////////////////////////
4082     // Internal functions
4083     ////////////////////////
4084 
4085     //
4086     // Implements StateMachine
4087     //
4088 
4089     function mAfterTransition(State /* oldState */, State newState)
4090         internal
4091     {
4092         // nothing to do after entering Whitelist
4093         if (newState == State.Whitelist) {
4094             return;
4095         }
4096 
4097         uint256 nmkToBurn = 0;
4098         if (newState == State.Public) {
4099 
4100             // mark unfufilled Ether reservations for burning
4101             nmkToBurn = _whitelistEtherNmk;
4102             _whitelistEtherNmk = 0;
4103         }
4104         if (newState == State.Finished) {
4105 
4106             // mark unfufilled Euro reservations for burning
4107             nmkToBurn = _whitelistEuroNmk;
4108             _whitelistEuroNmk = 0;
4109 
4110             // enable escape hatch and end locking funds phase
4111             ETHER_LOCK.controllerSucceeded();
4112             EURO_LOCK.controllerSucceeded();
4113 
4114             // enable Neumark transfers
4115             NEUMARK.enableTransfer(true);
4116         }
4117         // burn Neumarks after state change to prevent theoretical re-entry
4118         NEUMARK.burn(nmkToBurn);
4119     }
4120 
4121     ////////////////////////
4122     // Private functions
4123     ////////////////////////
4124 
4125     function addWhitelistInvestorPrivate(
4126         address investor,
4127         Token token,
4128         uint256 amount
4129     )
4130         private
4131     {
4132         // Validate
4133         require(investor != 0x0);
4134         require(_whitelist[investor].token == Token.None);
4135         bool isEuro = token == Token.Euro;
4136         bool isEther = token == Token.Ether;
4137         require(isEuro || isEther);
4138         // Note: amount can be zero, indicating no pre-allocated NMK,
4139         //       but still the ability to commit before the public.
4140         uint256 amountEurUlps = isEuro ? amount : convertToEur(amount);
4141         require(amount == 0 || amountEurUlps >= MIN_TICKET_EUR_ULPS);
4142 
4143         // Register the investor on the list of investors to keep them
4144         // in order.
4145         _whitelistInvestors.push(investor);
4146 
4147         // Create a ticket without NEUMARK reward information and add it to
4148         // the pre-allocated tickets.
4149         _whitelist[investor] = WhitelistTicket({
4150             token: token,
4151             amountEurUlps: amountEurUlps,
4152             rewardNmk: 0
4153         });
4154 
4155         if (amountEurUlps > 0) {
4156             // Allocate Neumarks (will be issued to `this`).
4157             // Because `_whitelist[investor].token == Token.None` does not not hold
4158             // any more, this function is protected against reentrancy attack
4159             // conducted from NEUMARK.issueForEuro().
4160             uint256 rewardNmk = NEUMARK.issueForEuro(amountEurUlps);
4161             // Record the number of Neumarks for investor.
4162             _whitelist[investor].rewardNmk = rewardNmk;
4163 
4164             // Add to totals
4165             if (isEuro) {
4166                 _whitelistEuroNmk = add(_whitelistEuroNmk, rewardNmk);
4167             } else {
4168                 _whitelistEtherNmk = add(_whitelistEtherNmk, rewardNmk);
4169             }
4170         }
4171     }
4172 
4173     /// @dev Token.None should not be passed to 'tokenType' parameter
4174     function getInvestorNeumarkReward(uint256 committedEurUlps, Token tokenType)
4175         private
4176         returns (uint256)
4177     {
4178         // We don't go over the cap
4179         require(add(NEUMARK.totalEuroUlps(), committedEurUlps) <= CAP_EUR_ULPS);
4180 
4181         // Compute committed funds
4182         uint256 remainingEurUlps = committedEurUlps;
4183         uint256 rewardNmk = 0;
4184         uint256 ticketNmk = 0;
4185 
4186         // Whitelist part
4187         WhitelistTicket storage ticket = _whitelist[msg.sender];
4188 
4189         bool whitelisted = ticket.token == tokenType;
4190         require(whitelisted || state() == State.Public);
4191 
4192         bool whitelistActiveForToken = tokenType == Token.Euro || state() == State.Whitelist;
4193         if (whitelisted && whitelistActiveForToken && ticket.amountEurUlps > 0 ) {
4194             uint256 ticketEurUlps = min(remainingEurUlps, ticket.amountEurUlps);
4195             ticketNmk = proportion(
4196                 ticket.rewardNmk,
4197                 ticketEurUlps,
4198                 ticket.amountEurUlps
4199             );
4200             // update investor ticket
4201             ticket.amountEurUlps = sub(ticket.amountEurUlps, ticketEurUlps);
4202             ticket.rewardNmk = sub(ticket.rewardNmk, ticketNmk);
4203             // mark ticketEurUlps as spent
4204             remainingEurUlps = sub(remainingEurUlps, ticketEurUlps);
4205             // set neumark reward
4206             rewardNmk = ticketNmk;
4207             // decrease reserved Neumark pool accordingly
4208             if (tokenType == Token.Euro) {
4209                 _whitelistEuroNmk = sub(_whitelistEuroNmk, ticketNmk);
4210             } else {
4211                 _whitelistEtherNmk = sub(_whitelistEtherNmk, ticketNmk);
4212             }
4213         }
4214 
4215         // issue Neumarks against curve for amount left after pre-defined ticket was realized
4216         if (remainingEurUlps > 0) {
4217             rewardNmk = add(rewardNmk, NEUMARK.issueForEuro(remainingEurUlps));
4218             remainingEurUlps = 0; // not used later but we should keep variable semantics
4219         }
4220 
4221         // Split the Neumarks
4222         var (platformNmk, investorNmk) = calculateNeumarkDistribtion(rewardNmk);
4223 
4224         // Issue Neumarks and distribute
4225         NEUMARK.distribute(msg.sender, investorNmk);
4226         NEUMARK.distribute(PLATFORM_WALLET, platformNmk);
4227 
4228         return investorNmk;
4229     }
4230 
4231     // calculates investor's and platform operator's neumarks from total reward
4232     function calculateNeumarkDistribtion(uint256 rewardNmk)
4233         private
4234         returns (uint256 platformNmk, uint256 investorNmk)
4235     {
4236         // round down - platform may get 1 wei less than investor
4237         platformNmk = rewardNmk / PLATFORM_NEUMARK_SHARE;
4238         // rewardNmk > platformNmk always
4239         return (platformNmk, rewardNmk - platformNmk);
4240     }
4241 }