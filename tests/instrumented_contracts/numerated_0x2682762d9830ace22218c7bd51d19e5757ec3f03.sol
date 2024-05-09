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
140 /// @notice implemented in the contract that is the target of state migration
141 /// @dev implementation must provide actual function that will be called by source to migrate state
142 contract IMigrationTarget {
143 
144     ////////////////////////
145     // Public functions
146     ////////////////////////
147 
148     // should return migration source address
149     function currentMigrationSource()
150         public
151         constant
152         returns (address);
153 }
154 
155 /// @notice mixin that enables contract to receive migration
156 /// @dev when derived from
157 contract MigrationTarget is
158     IMigrationTarget
159 {
160     ////////////////////////
161     // Modifiers
162     ////////////////////////
163 
164     // intended to be applied on migration receiving function
165     modifier onlyMigrationSource() {
166         require(msg.sender == currentMigrationSource());
167         _;
168     }
169 }
170 
171 contract EuroTokenMigrationTarget is
172     MigrationTarget
173 {
174     ////////////////////////
175     // Public functions
176     ////////////////////////
177 
178     /// @notice accepts migration of single eur-t token holder
179     /// @dev allowed to be called only from migration source, do not forget to add accessor modifier in implementation
180     function migrateEuroTokenOwner(address owner, uint256 amount)
181         public
182         onlyMigrationSource();
183 }
184 
185 /// @notice implemented in the contract that stores state to be migrated
186 /// @notice contract is called migration source
187 /// @dev migration target implements IMigrationTarget interface, when it is passed in 'enableMigration' function
188 /// @dev 'migrate' function may be called to migrate part of state owned by msg.sender
189 /// @dev in legal terms this corresponds to amending/changing agreement terms by co-signature of parties
190 contract IMigrationSource {
191 
192     ////////////////////////
193     // Events
194     ////////////////////////
195 
196     event LogMigrationEnabled(
197         address target
198     );
199 
200     ////////////////////////
201     // Public functions
202     ////////////////////////
203 
204     /// @notice should migrate state owned by msg.sender
205     /// @dev intended flow is to: read source state, clear source state, call migrate function on target, log success event
206     function migrate()
207         public;
208 
209     /// @notice should enable migration to migration target
210     /// @dev should limit access to specific role in implementation
211     function enableMigration(IMigrationTarget migration)
212         public;
213 
214     /// @notice returns current migration target
215     function currentMigrationTarget()
216         public
217         constant
218         returns (IMigrationTarget);
219 }
220 
221 /// @notice mixin that enables migration pattern for a contract
222 /// @dev when derived from
223 contract MigrationSource is
224     IMigrationSource,
225     AccessControlled
226 {
227     ////////////////////////
228     // Immutable state
229     ////////////////////////
230 
231     /// stores role hash that can enable migration
232     bytes32 private MIGRATION_ADMIN;
233 
234     ////////////////////////
235     // Mutable state
236     ////////////////////////
237 
238     // migration target contract
239     IMigrationTarget internal _migration;
240 
241     ////////////////////////
242     // Modifiers
243     ////////////////////////
244 
245     /// @notice add to enableMigration function to prevent changing of migration
246     ///     target once set
247     modifier onlyMigrationEnabledOnce() {
248         require(address(_migration) == 0);
249         _;
250     }
251 
252     modifier onlyMigrationEnabled() {
253         require(address(_migration) != 0);
254         _;
255     }
256 
257     ////////////////////////
258     // Constructor
259     ////////////////////////
260 
261     function MigrationSource(
262         IAccessPolicy policy,
263         bytes32 migrationAdminRole
264     )
265         AccessControlled(policy)
266         internal
267     {
268         MIGRATION_ADMIN = migrationAdminRole;
269     }
270 
271     ////////////////////////
272     // Public functions
273     ////////////////////////
274 
275     /// @notice should migrate state that belongs to msg.sender
276     /// @dev do not forget to add accessor modifier in implementation
277     function migrate()
278         onlyMigrationEnabled()
279         public;
280 
281     /// @notice should enable migration to migration target
282     /// @dev do not forget to add accessor modifier in override
283     function enableMigration(IMigrationTarget migration)
284         public
285         onlyMigrationEnabledOnce()
286         only(MIGRATION_ADMIN)
287     {
288         // this must be the source
289         require(migration.currentMigrationSource() == address(this));
290         _migration = migration;
291         LogMigrationEnabled(_migration);
292     }
293 
294     /// @notice returns current migration target
295     function currentMigrationTarget()
296         public
297         constant
298         returns (IMigrationTarget)
299     {
300         return _migration;
301     }
302 }
303 
304 contract AccessRoles {
305 
306     ////////////////////////
307     // Constants
308     ////////////////////////
309 
310     // NOTE: All roles are set to the keccak256 hash of the
311     // CamelCased role name, i.e.
312     // ROLE_LOCKED_ACCOUNT_ADMIN = keccak256("LockedAccountAdmin")
313 
314     // may setup LockedAccount, change disbursal mechanism and set migration
315     bytes32 internal constant ROLE_LOCKED_ACCOUNT_ADMIN = 0x4675da546d2d92c5b86c4f726a9e61010dce91cccc2491ce6019e78b09d2572e;
316 
317     // may setup whitelists and abort whitelisting contract with curve rollback
318     bytes32 internal constant ROLE_WHITELIST_ADMIN = 0xaef456e7c864418e1d2a40d996ca4febf3a7e317fe3af5a7ea4dda59033bbe5c;
319 
320     // May issue (generate) Neumarks
321     bytes32 internal constant ROLE_NEUMARK_ISSUER = 0x921c3afa1f1fff707a785f953a1e197bd28c9c50e300424e015953cbf120c06c;
322 
323     // May burn Neumarks it owns
324     bytes32 internal constant ROLE_NEUMARK_BURNER = 0x19ce331285f41739cd3362a3ec176edffe014311c0f8075834fdd19d6718e69f;
325 
326     // May create new snapshots on Neumark
327     bytes32 internal constant ROLE_SNAPSHOT_CREATOR = 0x08c1785afc57f933523bc52583a72ce9e19b2241354e04dd86f41f887e3d8174;
328 
329     // May enable/disable transfers on Neumark
330     bytes32 internal constant ROLE_TRANSFER_ADMIN = 0xb6527e944caca3d151b1f94e49ac5e223142694860743e66164720e034ec9b19;
331 
332     // may reclaim tokens/ether from contracts supporting IReclaimable interface
333     bytes32 internal constant ROLE_RECLAIMER = 0x0542bbd0c672578966dcc525b30aa16723bb042675554ac5b0362f86b6e97dc5;
334 
335     // represents legally platform operator in case of forks and contracts with legal agreement attached. keccak256("PlatformOperatorRepresentative")
336     bytes32 internal constant ROLE_PLATFORM_OPERATOR_REPRESENTATIVE = 0xb2b321377653f655206f71514ff9f150d0822d062a5abcf220d549e1da7999f0;
337 
338     // allows to deposit EUR-T and allow addresses to send and receive EUR-T. keccak256("EurtDepositManager")
339     bytes32 internal constant ROLE_EURT_DEPOSIT_MANAGER = 0x7c8ecdcba80ce87848d16ad77ef57cc196c208fc95c5638e4a48c681a34d4fe7;
340 }
341 
342 contract IBasicToken {
343 
344     ////////////////////////
345     // Events
346     ////////////////////////
347 
348     event Transfer(
349         address indexed from,
350         address indexed to,
351         uint256 amount);
352 
353     ////////////////////////
354     // Public functions
355     ////////////////////////
356 
357     /// @dev This function makes it easy to get the total number of tokens
358     /// @return The total number of tokens
359     function totalSupply()
360         public
361         constant
362         returns (uint256);
363 
364     /// @param owner The address that's balance is being requested
365     /// @return The balance of `owner` at the current block
366     function balanceOf(address owner)
367         public
368         constant
369         returns (uint256 balance);
370 
371     /// @notice Send `amount` tokens to `to` from `msg.sender`
372     /// @param to The address of the recipient
373     /// @param amount The amount of tokens to be transferred
374     /// @return Whether the transfer was successful or not
375     function transfer(address to, uint256 amount)
376         public
377         returns (bool success);
378 
379 }
380 
381 /// @title allows deriving contract to recover any token or ether that it has balance of
382 /// @notice note that this opens your contracts to claims from various people saying they lost tokens and they want them back
383 ///     be ready to handle such claims
384 /// @dev use with care!
385 ///     1. ROLE_RECLAIMER is allowed to claim tokens, it's not returning tokens to original owner
386 ///     2. in derived contract that holds any token by design you must override `reclaim` and block such possibility.
387 ///         see LockedAccount as an example
388 contract Reclaimable is AccessControlled, AccessRoles {
389 
390     ////////////////////////
391     // Constants
392     ////////////////////////
393 
394     IBasicToken constant internal RECLAIM_ETHER = IBasicToken(0x0);
395 
396     ////////////////////////
397     // Public functions
398     ////////////////////////
399 
400     function reclaim(IBasicToken token)
401         public
402         only(ROLE_RECLAIMER)
403     {
404         address reclaimer = msg.sender;
405         if(token == RECLAIM_ETHER) {
406             reclaimer.transfer(this.balance);
407         } else {
408             uint256 balance = token.balanceOf(this);
409             require(token.transfer(reclaimer, balance));
410         }
411     }
412 }
413 
414 contract ITokenMetadata {
415 
416     ////////////////////////
417     // Public functions
418     ////////////////////////
419 
420     function symbol()
421         public
422         constant
423         returns (string);
424 
425     function name()
426         public
427         constant
428         returns (string);
429 
430     function decimals()
431         public
432         constant
433         returns (uint8);
434 }
435 
436 /// @title adds token metadata to token contract
437 /// @dev see Neumark for example implementation
438 contract TokenMetadata is ITokenMetadata {
439 
440     ////////////////////////
441     // Immutable state
442     ////////////////////////
443 
444     // The Token's name: e.g. DigixDAO Tokens
445     string private NAME;
446 
447     // An identifier: e.g. REP
448     string private SYMBOL;
449 
450     // Number of decimals of the smallest unit
451     uint8 private DECIMALS;
452 
453     // An arbitrary versioning scheme
454     string private VERSION;
455 
456     ////////////////////////
457     // Constructor
458     ////////////////////////
459 
460     /// @notice Constructor to set metadata
461     /// @param tokenName Name of the new token
462     /// @param decimalUnits Number of decimals of the new token
463     /// @param tokenSymbol Token Symbol for the new token
464     /// @param version Token version ie. when cloning is used
465     function TokenMetadata(
466         string tokenName,
467         uint8 decimalUnits,
468         string tokenSymbol,
469         string version
470     )
471         public
472     {
473         NAME = tokenName;                                 // Set the name
474         SYMBOL = tokenSymbol;                             // Set the symbol
475         DECIMALS = decimalUnits;                          // Set the decimals
476         VERSION = version;
477     }
478 
479     ////////////////////////
480     // Public functions
481     ////////////////////////
482 
483     function name()
484         public
485         constant
486         returns (string)
487     {
488         return NAME;
489     }
490 
491     function symbol()
492         public
493         constant
494         returns (string)
495     {
496         return SYMBOL;
497     }
498 
499     function decimals()
500         public
501         constant
502         returns (uint8)
503     {
504         return DECIMALS;
505     }
506 
507     function version()
508         public
509         constant
510         returns (string)
511     {
512         return VERSION;
513     }
514 }
515 
516 contract IERC20Allowance {
517 
518     ////////////////////////
519     // Events
520     ////////////////////////
521 
522     event Approval(
523         address indexed owner,
524         address indexed spender,
525         uint256 amount);
526 
527     ////////////////////////
528     // Public functions
529     ////////////////////////
530 
531     /// @dev This function makes it easy to read the `allowed[]` map
532     /// @param owner The address of the account that owns the token
533     /// @param spender The address of the account able to transfer the tokens
534     /// @return Amount of remaining tokens of owner that spender is allowed
535     ///  to spend
536     function allowance(address owner, address spender)
537         public
538         constant
539         returns (uint256 remaining);
540 
541     /// @notice `msg.sender` approves `spender` to spend `amount` tokens on
542     ///  its behalf. This is a modified version of the ERC20 approve function
543     ///  to be a little bit safer
544     /// @param spender The address of the account able to transfer the tokens
545     /// @param amount The amount of tokens to be approved for transfer
546     /// @return True if the approval was successful
547     function approve(address spender, uint256 amount)
548         public
549         returns (bool success);
550 
551     /// @notice Send `amount` tokens to `to` from `from` on the condition it
552     ///  is approved by `from`
553     /// @param from The address holding the tokens being transferred
554     /// @param to The address of the recipient
555     /// @param amount The amount of tokens to be transferred
556     /// @return True if the transfer was successful
557     function transferFrom(address from, address to, uint256 amount)
558         public
559         returns (bool success);
560 
561 }
562 
563 contract IERC20Token is IBasicToken, IERC20Allowance {
564 
565 }
566 
567 contract IERC677Callback {
568 
569     ////////////////////////
570     // Public functions
571     ////////////////////////
572 
573     // NOTE: This call can be initiated by anyone. You need to make sure that
574     // it is send by the token (`require(msg.sender == token)`) or make sure
575     // amount is valid (`require(token.allowance(this) >= amount)`).
576     function receiveApproval(
577         address from,
578         uint256 amount,
579         address token, // IERC667Token
580         bytes data
581     )
582         public
583         returns (bool success);
584 
585 }
586 
587 contract IERC677Allowance is IERC20Allowance {
588 
589     ////////////////////////
590     // Public functions
591     ////////////////////////
592 
593     /// @notice `msg.sender` approves `spender` to send `amount` tokens on
594     ///  its behalf, and then a function is triggered in the contract that is
595     ///  being approved, `spender`. This allows users to use their tokens to
596     ///  interact with contracts in one function call instead of two
597     /// @param spender The address of the contract able to transfer the tokens
598     /// @param amount The amount of tokens to be approved for transfer
599     /// @return True if the function call was successful
600     function approveAndCall(address spender, uint256 amount, bytes extraData)
601         public
602         returns (bool success);
603 
604 }
605 
606 contract IERC677Token is IERC20Token, IERC677Allowance {
607 }
608 
609 contract Math {
610 
611     ////////////////////////
612     // Internal functions
613     ////////////////////////
614 
615     // absolute difference: |v1 - v2|
616     function absDiff(uint256 v1, uint256 v2)
617         internal
618         constant
619         returns(uint256)
620     {
621         return v1 > v2 ? v1 - v2 : v2 - v1;
622     }
623 
624     // divide v by d, round up if remainder is 0.5 or more
625     function divRound(uint256 v, uint256 d)
626         internal
627         constant
628         returns(uint256)
629     {
630         return add(v, d/2) / d;
631     }
632 
633     // computes decimal decimalFraction 'frac' of 'amount' with maximum precision (multiplication first)
634     // both amount and decimalFraction must have 18 decimals precision, frac 10**18 represents a whole (100% of) amount
635     // mind loss of precision as decimal fractions do not have finite binary expansion
636     // do not use instead of division
637     function decimalFraction(uint256 amount, uint256 frac)
638         internal
639         constant
640         returns(uint256)
641     {
642         // it's like 1 ether is 100% proportion
643         return proportion(amount, frac, 10**18);
644     }
645 
646     // computes part/total of amount with maximum precision (multiplication first)
647     // part and total must have the same units
648     function proportion(uint256 amount, uint256 part, uint256 total)
649         internal
650         constant
651         returns(uint256)
652     {
653         return divRound(mul(amount, part), total);
654     }
655 
656     //
657     // Open Zeppelin Math library below
658     //
659 
660     function mul(uint256 a, uint256 b)
661         internal
662         constant
663         returns (uint256)
664     {
665         uint256 c = a * b;
666         assert(a == 0 || c / a == b);
667         return c;
668     }
669 
670     function sub(uint256 a, uint256 b)
671         internal
672         constant
673         returns (uint256)
674     {
675         assert(b <= a);
676         return a - b;
677     }
678 
679     function add(uint256 a, uint256 b)
680         internal
681         constant
682         returns (uint256)
683     {
684         uint256 c = a + b;
685         assert(c >= a);
686         return c;
687     }
688 
689     function min(uint256 a, uint256 b)
690         internal
691         constant
692         returns (uint256)
693     {
694         return a < b ? a : b;
695     }
696 
697     function max(uint256 a, uint256 b)
698         internal
699         constant
700         returns (uint256)
701     {
702         return a > b ? a : b;
703     }
704 }
705 
706 /**
707  * @title Basic token
708  * @dev Basic version of StandardToken, with no allowances.
709  */
710 contract BasicToken is IBasicToken, Math {
711 
712     ////////////////////////
713     // Mutable state
714     ////////////////////////
715 
716     mapping(address => uint256) internal _balances;
717 
718     uint256 internal _totalSupply;
719 
720     ////////////////////////
721     // Public functions
722     ////////////////////////
723 
724     /**
725     * @dev transfer token for a specified address
726     * @param to The address to transfer to.
727     * @param amount The amount to be transferred.
728     */
729     function transfer(address to, uint256 amount)
730         public
731         returns (bool)
732     {
733         transferInternal(msg.sender, to, amount);
734         return true;
735     }
736 
737     /// @dev This function makes it easy to get the total number of tokens
738     /// @return The total number of tokens
739     function totalSupply()
740         public
741         constant
742         returns (uint256)
743     {
744         return _totalSupply;
745     }
746 
747     /**
748     * @dev Gets the balance of the specified address.
749     * @param owner The address to query the the balance of.
750     * @return An uint256 representing the amount owned by the passed address.
751     */
752     function balanceOf(address owner)
753         public
754         constant
755         returns (uint256 balance)
756     {
757         return _balances[owner];
758     }
759 
760     ////////////////////////
761     // Internal functions
762     ////////////////////////
763 
764     // actual transfer function called by all public variants
765     function transferInternal(address from, address to, uint256 amount)
766         internal
767     {
768         require(to != address(0));
769 
770         _balances[from] = sub(_balances[from], amount);
771         _balances[to] = add(_balances[to], amount);
772         Transfer(from, to, amount);
773     }
774 }
775 
776 /**
777  * @title Standard ERC20 token
778  *
779  * @dev Implementation of the standard token.
780  * @dev https://github.com/ethereum/EIPs/issues/20
781  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
782  */
783 contract StandardToken is
784     IERC20Token,
785     BasicToken,
786     IERC677Token
787 {
788 
789     ////////////////////////
790     // Mutable state
791     ////////////////////////
792 
793     mapping (address => mapping (address => uint256)) private _allowed;
794 
795     ////////////////////////
796     // Public functions
797     ////////////////////////
798 
799     //
800     // Implements ERC20
801     //
802 
803     /**
804     * @dev Transfer tokens from one address to another
805     * @param from address The address which you want to send tokens from
806     * @param to address The address which you want to transfer to
807     * @param amount uint256 the amount of tokens to be transferred
808     */
809     function transferFrom(address from, address to, uint256 amount)
810         public
811         returns (bool)
812     {
813         // check and reset allowance
814         var allowance = _allowed[from][msg.sender];
815         _allowed[from][msg.sender] = sub(allowance, amount);
816         // do the transfer
817         transferInternal(from, to, amount);
818         return true;
819     }
820 
821     /**
822     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
823     * @param spender The address which will spend the funds.
824     * @param amount The amount of tokens to be spent.
825     */
826     function approve(address spender, uint256 amount)
827         public
828         returns (bool)
829     {
830 
831         // To change the approve amount you first have to reduce the addresses`
832         //  allowance to zero by calling `approve(_spender, 0)` if it is not
833         //  already 0 to mitigate the race condition described here:
834         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
835         require((amount == 0) || (_allowed[msg.sender][spender] == 0));
836 
837         _allowed[msg.sender][spender] = amount;
838         Approval(msg.sender, spender, amount);
839         return true;
840     }
841 
842     /**
843     * @dev Function to check the amount of tokens that an owner allowed to a spender.
844     * @param owner address The address which owns the funds.
845     * @param spender address The address which will spend the funds.
846     * @return A uint256 specifing the amount of tokens still avaible for the spender.
847     */
848     function allowance(address owner, address spender)
849         public
850         constant
851         returns (uint256 remaining)
852     {
853         return _allowed[owner][spender];
854     }
855 
856     //
857     // Implements IERC677Token
858     //
859 
860     function approveAndCall(
861         address spender,
862         uint256 amount,
863         bytes extraData
864     )
865         public
866         returns (bool)
867     {
868         require(approve(spender, amount));
869 
870         // in case of re-entry 1. approval is done 2. msg.sender is different
871         bool success = IERC677Callback(spender).receiveApproval(
872             msg.sender,
873             amount,
874             this,
875             extraData
876         );
877         require(success);
878 
879         return true;
880     }
881 }
882 
883 /// Simple implementation of EuroToken which is pegged 1:1 to certain off-chain
884 /// pool of Euro. Balances of this token are intended to be migrated to final
885 /// implementation that will be available later
886 contract EuroToken is
887     IERC677Token,
888     AccessControlled,
889     StandardToken,
890     TokenMetadata,
891     MigrationSource,
892     Reclaimable
893 {
894     ////////////////////////
895     // Constants
896     ////////////////////////
897 
898     string private constant NAME = "Euro Token";
899 
900     string private constant SYMBOL = "EUR-T";
901 
902     uint8 private constant DECIMALS = 18;
903 
904     ////////////////////////
905     // Mutable state
906     ////////////////////////
907 
908     // a list of addresses that are allowed to receive EUR-T
909     mapping(address => bool) private _allowedTransferTo;
910 
911     // a list of of addresses that are allowed to send EUR-T
912     mapping(address => bool) private _allowedTransferFrom;
913 
914     ////////////////////////
915     // Events
916     ////////////////////////
917 
918     event LogDeposit(
919         address indexed to,
920         uint256 amount
921     );
922 
923     event LogWithdrawal(
924         address indexed from,
925         uint256 amount
926     );
927 
928     event LogAllowedFromAddress(
929         address indexed from,
930         bool allowed
931     );
932 
933     event LogAllowedToAddress(
934         address indexed to,
935         bool allowed
936     );
937 
938     /// @notice migration was successful
939     event LogEuroTokenOwnerMigrated(
940         address indexed owner,
941         uint256 amount
942     );
943 
944     ////////////////////////
945     // Modifiers
946     ////////////////////////
947 
948     modifier onlyAllowedTransferFrom(address from) {
949         require(_allowedTransferFrom[from]);
950         _;
951     }
952 
953     modifier onlyAllowedTransferTo(address to) {
954         require(_allowedTransferTo[to]);
955         _;
956     }
957 
958     ////////////////////////
959     // Constructor
960     ////////////////////////
961 
962     function EuroToken(IAccessPolicy accessPolicy)
963         AccessControlled(accessPolicy)
964         StandardToken()
965         TokenMetadata(NAME, DECIMALS, SYMBOL, "")
966         MigrationSource(accessPolicy, ROLE_EURT_DEPOSIT_MANAGER)
967         Reclaimable()
968         public
969     {
970     }
971 
972     ////////////////////////
973     // Public functions
974     ////////////////////////
975 
976     /// @notice deposit 'amount' of EUR-T to address 'to'
977     /// @dev address 'to' is whitelisted as recipient of future transfers
978     /// @dev deposit may happen only in case of succesful KYC of recipient and validation of banking data
979     /// @dev which in this implementation is an off-chain responsibility of EURT_DEPOSIT_MANAGER
980     function deposit(address to, uint256 amount)
981         public
982         only(ROLE_EURT_DEPOSIT_MANAGER)
983         returns (bool)
984     {
985         require(to != address(0));
986         _balances[to] = add(_balances[to], amount);
987         _totalSupply = add(_totalSupply, amount);
988         setAllowedTransferTo(to, true);
989         LogDeposit(to, amount);
990         Transfer(address(0), to, amount);
991         return true;
992     }
993 
994     /// @notice withdraws 'amount' of EUR-T by burning required amount and providing a proof of whithdrawal
995     /// @dev proof is provided in form of log entry on which EURT_DEPOSIT_MANAGER
996     /// @dev will act off-chain to return required Euro amount to EUR-T holder
997     function withdraw(uint256 amount)
998         public
999     {
1000         require(_balances[msg.sender] >= amount);
1001         _balances[msg.sender] = sub(_balances[msg.sender], amount);
1002         _totalSupply = sub(_totalSupply, amount);
1003         LogWithdrawal(msg.sender, amount);
1004         Transfer(msg.sender, address(0), amount);
1005     }
1006 
1007     /// @notice enables or disables address to be receipient of EUR-T
1008     function setAllowedTransferTo(address to, bool allowed)
1009         public
1010         only(ROLE_EURT_DEPOSIT_MANAGER)
1011     {
1012         _allowedTransferTo[to] = allowed;
1013         LogAllowedToAddress(to, allowed);
1014     }
1015 
1016     /// @notice enables or disables address to be sender of EUR-T
1017     function setAllowedTransferFrom(address from, bool allowed)
1018         public
1019         only(ROLE_EURT_DEPOSIT_MANAGER)
1020     {
1021         _allowedTransferFrom[from] = allowed;
1022         LogAllowedFromAddress(from, allowed);
1023     }
1024 
1025     function allowedTransferTo(address to)
1026         public
1027         constant
1028         returns (bool)
1029     {
1030         return _allowedTransferTo[to];
1031     }
1032 
1033     function allowedTransferFrom(address from)
1034         public
1035         constant
1036         returns (bool)
1037     {
1038         return _allowedTransferFrom[from];
1039     }
1040 
1041     //
1042     // Overrides ERC20 Interface to allow transfer from/to allowed addresses
1043     //
1044 
1045     function transfer(address to, uint256 amount)
1046         public
1047         onlyAllowedTransferFrom(msg.sender)
1048         onlyAllowedTransferTo(to)
1049         returns (bool success)
1050     {
1051         return BasicToken.transfer(to, amount);
1052     }
1053 
1054     /// @dev broker acts in the name of 'from' address so broker needs to have permission to transfer from
1055     ///  this way we may give permissions to brokering smart contracts while investors do not have permissions
1056     ///  to transfer. 'to' address requires standard transfer to permission
1057     function transferFrom(address from, address to, uint256 amount)
1058         public
1059         onlyAllowedTransferFrom(msg.sender)
1060         onlyAllowedTransferTo(to)
1061         returns (bool success)
1062     {
1063         return StandardToken.transferFrom(from, to, amount);
1064     }
1065 
1066     //
1067     // Overrides migration source
1068     //
1069 
1070     function migrate()
1071         public
1072         onlyMigrationEnabled()
1073         onlyAllowedTransferTo(msg.sender)
1074     {
1075         // burn deposit
1076         uint256 amount = _balances[msg.sender];
1077         if (amount > 0) {
1078             _balances[msg.sender] = 0;
1079             _totalSupply = sub(_totalSupply, amount);
1080         }
1081         // remove all transfer permissions
1082         _allowedTransferTo[msg.sender] = false;
1083         _allowedTransferFrom[msg.sender] = false;
1084         // migrate to
1085         EuroTokenMigrationTarget(_migration).migrateEuroTokenOwner(msg.sender, amount);
1086         // set event
1087         LogEuroTokenOwnerMigrated(msg.sender, amount);
1088     }
1089 }