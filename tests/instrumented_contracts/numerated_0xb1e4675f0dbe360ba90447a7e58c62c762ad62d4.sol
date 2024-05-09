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
178 contract IsContract {
179 
180     ////////////////////////
181     // Internal functions
182     ////////////////////////
183 
184     function isContract(address addr)
185         internal
186         constant
187         returns (bool)
188     {
189         uint256 size;
190         // takes 700 gas
191         assembly { size := extcodesize(addr) }
192         return size > 0;
193     }
194 }
195 
196 contract IBasicToken {
197 
198     ////////////////////////
199     // Events
200     ////////////////////////
201 
202     event Transfer(
203         address indexed from,
204         address indexed to,
205         uint256 amount);
206 
207     ////////////////////////
208     // Public functions
209     ////////////////////////
210 
211     /// @dev This function makes it easy to get the total number of tokens
212     /// @return The total number of tokens
213     function totalSupply()
214         public
215         constant
216         returns (uint256);
217 
218     /// @param owner The address that's balance is being requested
219     /// @return The balance of `owner` at the current block
220     function balanceOf(address owner)
221         public
222         constant
223         returns (uint256 balance);
224 
225     /// @notice Send `amount` tokens to `to` from `msg.sender`
226     /// @param to The address of the recipient
227     /// @param amount The amount of tokens to be transferred
228     /// @return Whether the transfer was successful or not
229     function transfer(address to, uint256 amount)
230         public
231         returns (bool success);
232 
233 }
234 
235 /// @title allows deriving contract to recover any token or ether that it has balance of
236 /// @notice note that this opens your contracts to claims from various people saying they lost tokens and they want them back
237 ///     be ready to handle such claims
238 /// @dev use with care!
239 ///     1. ROLE_RECLAIMER is allowed to claim tokens, it's not returning tokens to original owner
240 ///     2. in derived contract that holds any token by design you must override `reclaim` and block such possibility.
241 ///         see LockedAccount as an example
242 contract Reclaimable is AccessControlled, AccessRoles {
243 
244     ////////////////////////
245     // Constants
246     ////////////////////////
247 
248     IBasicToken constant internal RECLAIM_ETHER = IBasicToken(0x0);
249 
250     ////////////////////////
251     // Public functions
252     ////////////////////////
253 
254     function reclaim(IBasicToken token)
255         public
256         only(ROLE_RECLAIMER)
257     {
258         address reclaimer = msg.sender;
259         if(token == RECLAIM_ETHER) {
260             reclaimer.transfer(this.balance);
261         } else {
262             uint256 balance = token.balanceOf(this);
263             require(token.transfer(reclaimer, balance));
264         }
265     }
266 }
267 
268 contract ITokenMetadata {
269 
270     ////////////////////////
271     // Public functions
272     ////////////////////////
273 
274     function symbol()
275         public
276         constant
277         returns (string);
278 
279     function name()
280         public
281         constant
282         returns (string);
283 
284     function decimals()
285         public
286         constant
287         returns (uint8);
288 }
289 
290 /// @title adds token metadata to token contract
291 /// @dev see Neumark for example implementation
292 contract TokenMetadata is ITokenMetadata {
293 
294     ////////////////////////
295     // Immutable state
296     ////////////////////////
297 
298     // The Token's name: e.g. DigixDAO Tokens
299     string private NAME;
300 
301     // An identifier: e.g. REP
302     string private SYMBOL;
303 
304     // Number of decimals of the smallest unit
305     uint8 private DECIMALS;
306 
307     // An arbitrary versioning scheme
308     string private VERSION;
309 
310     ////////////////////////
311     // Constructor
312     ////////////////////////
313 
314     /// @notice Constructor to set metadata
315     /// @param tokenName Name of the new token
316     /// @param decimalUnits Number of decimals of the new token
317     /// @param tokenSymbol Token Symbol for the new token
318     /// @param version Token version ie. when cloning is used
319     function TokenMetadata(
320         string tokenName,
321         uint8 decimalUnits,
322         string tokenSymbol,
323         string version
324     )
325         public
326     {
327         NAME = tokenName;                                 // Set the name
328         SYMBOL = tokenSymbol;                             // Set the symbol
329         DECIMALS = decimalUnits;                          // Set the decimals
330         VERSION = version;
331     }
332 
333     ////////////////////////
334     // Public functions
335     ////////////////////////
336 
337     function name()
338         public
339         constant
340         returns (string)
341     {
342         return NAME;
343     }
344 
345     function symbol()
346         public
347         constant
348         returns (string)
349     {
350         return SYMBOL;
351     }
352 
353     function decimals()
354         public
355         constant
356         returns (uint8)
357     {
358         return DECIMALS;
359     }
360 
361     function version()
362         public
363         constant
364         returns (string)
365     {
366         return VERSION;
367     }
368 }
369 
370 contract IERC223Callback {
371 
372     ////////////////////////
373     // Public functions
374     ////////////////////////
375 
376     function onTokenTransfer(
377         address from,
378         uint256 amount,
379         bytes data
380     )
381         public;
382 
383 }
384 
385 contract IERC223Token is IBasicToken {
386 
387     /// @dev Departure: We do not log data, it has no advantage over a standard
388     ///     log event. By sticking to the standard log event we
389     ///     stay compatible with constracts that expect and ERC20 token.
390 
391     // event Transfer(
392     //    address indexed from,
393     //    address indexed to,
394     //    uint256 amount,
395     //    bytes data);
396 
397 
398     /// @dev Departure: We do not use the callback on regular transfer calls to
399     ///     stay compatible with constracts that expect and ERC20 token.
400 
401     // function transfer(address to, uint256 amount)
402     //     public
403     //     returns (bool);
404 
405     ////////////////////////
406     // Public functions
407     ////////////////////////
408 
409     function transfer(address to, uint256 amount, bytes data)
410         public
411         returns (bool);
412 }
413 
414 contract IERC20Allowance {
415 
416     ////////////////////////
417     // Events
418     ////////////////////////
419 
420     event Approval(
421         address indexed owner,
422         address indexed spender,
423         uint256 amount);
424 
425     ////////////////////////
426     // Public functions
427     ////////////////////////
428 
429     /// @dev This function makes it easy to read the `allowed[]` map
430     /// @param owner The address of the account that owns the token
431     /// @param spender The address of the account able to transfer the tokens
432     /// @return Amount of remaining tokens of owner that spender is allowed
433     ///  to spend
434     function allowance(address owner, address spender)
435         public
436         constant
437         returns (uint256 remaining);
438 
439     /// @notice `msg.sender` approves `spender` to spend `amount` tokens on
440     ///  its behalf. This is a modified version of the ERC20 approve function
441     ///  to be a little bit safer
442     /// @param spender The address of the account able to transfer the tokens
443     /// @param amount The amount of tokens to be approved for transfer
444     /// @return True if the approval was successful
445     function approve(address spender, uint256 amount)
446         public
447         returns (bool success);
448 
449     /// @notice Send `amount` tokens to `to` from `from` on the condition it
450     ///  is approved by `from`
451     /// @param from The address holding the tokens being transferred
452     /// @param to The address of the recipient
453     /// @param amount The amount of tokens to be transferred
454     /// @return True if the transfer was successful
455     function transferFrom(address from, address to, uint256 amount)
456         public
457         returns (bool success);
458 
459 }
460 
461 contract IERC20Token is IBasicToken, IERC20Allowance {
462 
463 }
464 
465 contract IERC677Callback {
466 
467     ////////////////////////
468     // Public functions
469     ////////////////////////
470 
471     // NOTE: This call can be initiated by anyone. You need to make sure that
472     // it is send by the token (`require(msg.sender == token)`) or make sure
473     // amount is valid (`require(token.allowance(this) >= amount)`).
474     function receiveApproval(
475         address from,
476         uint256 amount,
477         address token, // IERC667Token
478         bytes data
479     )
480         public
481         returns (bool success);
482 
483 }
484 
485 contract IERC677Allowance is IERC20Allowance {
486 
487     ////////////////////////
488     // Public functions
489     ////////////////////////
490 
491     /// @notice `msg.sender` approves `spender` to send `amount` tokens on
492     ///  its behalf, and then a function is triggered in the contract that is
493     ///  being approved, `spender`. This allows users to use their tokens to
494     ///  interact with contracts in one function call instead of two
495     /// @param spender The address of the contract able to transfer the tokens
496     /// @param amount The amount of tokens to be approved for transfer
497     /// @return True if the function call was successful
498     function approveAndCall(address spender, uint256 amount, bytes extraData)
499         public
500         returns (bool success);
501 
502 }
503 
504 contract IERC677Token is IERC20Token, IERC677Allowance {
505 }
506 
507 contract Math {
508 
509     ////////////////////////
510     // Internal functions
511     ////////////////////////
512 
513     // absolute difference: |v1 - v2|
514     function absDiff(uint256 v1, uint256 v2)
515         internal
516         constant
517         returns(uint256)
518     {
519         return v1 > v2 ? v1 - v2 : v2 - v1;
520     }
521 
522     // divide v by d, round up if remainder is 0.5 or more
523     function divRound(uint256 v, uint256 d)
524         internal
525         constant
526         returns(uint256)
527     {
528         return add(v, d/2) / d;
529     }
530 
531     // computes decimal decimalFraction 'frac' of 'amount' with maximum precision (multiplication first)
532     // both amount and decimalFraction must have 18 decimals precision, frac 10**18 represents a whole (100% of) amount
533     // mind loss of precision as decimal fractions do not have finite binary expansion
534     // do not use instead of division
535     function decimalFraction(uint256 amount, uint256 frac)
536         internal
537         constant
538         returns(uint256)
539     {
540         // it's like 1 ether is 100% proportion
541         return proportion(amount, frac, 10**18);
542     }
543 
544     // computes part/total of amount with maximum precision (multiplication first)
545     // part and total must have the same units
546     function proportion(uint256 amount, uint256 part, uint256 total)
547         internal
548         constant
549         returns(uint256)
550     {
551         return divRound(mul(amount, part), total);
552     }
553 
554     //
555     // Open Zeppelin Math library below
556     //
557 
558     function mul(uint256 a, uint256 b)
559         internal
560         constant
561         returns (uint256)
562     {
563         uint256 c = a * b;
564         assert(a == 0 || c / a == b);
565         return c;
566     }
567 
568     function sub(uint256 a, uint256 b)
569         internal
570         constant
571         returns (uint256)
572     {
573         assert(b <= a);
574         return a - b;
575     }
576 
577     function add(uint256 a, uint256 b)
578         internal
579         constant
580         returns (uint256)
581     {
582         uint256 c = a + b;
583         assert(c >= a);
584         return c;
585     }
586 
587     function min(uint256 a, uint256 b)
588         internal
589         constant
590         returns (uint256)
591     {
592         return a < b ? a : b;
593     }
594 
595     function max(uint256 a, uint256 b)
596         internal
597         constant
598         returns (uint256)
599     {
600         return a > b ? a : b;
601     }
602 }
603 
604 /**
605  * @title Basic token
606  * @dev Basic version of StandardToken, with no allowances.
607  */
608 contract BasicToken is IBasicToken, Math {
609 
610     ////////////////////////
611     // Mutable state
612     ////////////////////////
613 
614     mapping(address => uint256) internal _balances;
615 
616     uint256 internal _totalSupply;
617 
618     ////////////////////////
619     // Public functions
620     ////////////////////////
621 
622     /**
623     * @dev transfer token for a specified address
624     * @param to The address to transfer to.
625     * @param amount The amount to be transferred.
626     */
627     function transfer(address to, uint256 amount)
628         public
629         returns (bool)
630     {
631         transferInternal(msg.sender, to, amount);
632         return true;
633     }
634 
635     /// @dev This function makes it easy to get the total number of tokens
636     /// @return The total number of tokens
637     function totalSupply()
638         public
639         constant
640         returns (uint256)
641     {
642         return _totalSupply;
643     }
644 
645     /**
646     * @dev Gets the balance of the specified address.
647     * @param owner The address to query the the balance of.
648     * @return An uint256 representing the amount owned by the passed address.
649     */
650     function balanceOf(address owner)
651         public
652         constant
653         returns (uint256 balance)
654     {
655         return _balances[owner];
656     }
657 
658     ////////////////////////
659     // Internal functions
660     ////////////////////////
661 
662     // actual transfer function called by all public variants
663     function transferInternal(address from, address to, uint256 amount)
664         internal
665     {
666         require(to != address(0));
667 
668         _balances[from] = sub(_balances[from], amount);
669         _balances[to] = add(_balances[to], amount);
670         Transfer(from, to, amount);
671     }
672 }
673 
674 /**
675  * @title Standard ERC20 token
676  *
677  * @dev Implementation of the standard token.
678  * @dev https://github.com/ethereum/EIPs/issues/20
679  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
680  */
681 contract StandardToken is
682     IERC20Token,
683     BasicToken,
684     IERC677Token
685 {
686 
687     ////////////////////////
688     // Mutable state
689     ////////////////////////
690 
691     mapping (address => mapping (address => uint256)) private _allowed;
692 
693     ////////////////////////
694     // Public functions
695     ////////////////////////
696 
697     //
698     // Implements ERC20
699     //
700 
701     /**
702     * @dev Transfer tokens from one address to another
703     * @param from address The address which you want to send tokens from
704     * @param to address The address which you want to transfer to
705     * @param amount uint256 the amount of tokens to be transferred
706     */
707     function transferFrom(address from, address to, uint256 amount)
708         public
709         returns (bool)
710     {
711         // check and reset allowance
712         var allowance = _allowed[from][msg.sender];
713         _allowed[from][msg.sender] = sub(allowance, amount);
714         // do the transfer
715         transferInternal(from, to, amount);
716         return true;
717     }
718 
719     /**
720     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
721     * @param spender The address which will spend the funds.
722     * @param amount The amount of tokens to be spent.
723     */
724     function approve(address spender, uint256 amount)
725         public
726         returns (bool)
727     {
728 
729         // To change the approve amount you first have to reduce the addresses`
730         //  allowance to zero by calling `approve(_spender, 0)` if it is not
731         //  already 0 to mitigate the race condition described here:
732         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
733         require((amount == 0) || (_allowed[msg.sender][spender] == 0));
734 
735         _allowed[msg.sender][spender] = amount;
736         Approval(msg.sender, spender, amount);
737         return true;
738     }
739 
740     /**
741     * @dev Function to check the amount of tokens that an owner allowed to a spender.
742     * @param owner address The address which owns the funds.
743     * @param spender address The address which will spend the funds.
744     * @return A uint256 specifing the amount of tokens still avaible for the spender.
745     */
746     function allowance(address owner, address spender)
747         public
748         constant
749         returns (uint256 remaining)
750     {
751         return _allowed[owner][spender];
752     }
753 
754     //
755     // Implements IERC677Token
756     //
757 
758     function approveAndCall(
759         address spender,
760         uint256 amount,
761         bytes extraData
762     )
763         public
764         returns (bool)
765     {
766         require(approve(spender, amount));
767 
768         // in case of re-entry 1. approval is done 2. msg.sender is different
769         bool success = IERC677Callback(spender).receiveApproval(
770             msg.sender,
771             amount,
772             this,
773             extraData
774         );
775         require(success);
776 
777         return true;
778     }
779 }
780 
781 contract EtherToken is
782     IsContract,
783     AccessControlled,
784     StandardToken,
785     TokenMetadata,
786     Reclaimable
787 {
788     ////////////////////////
789     // Constants
790     ////////////////////////
791 
792     string private constant NAME = "Ether Token";
793 
794     string private constant SYMBOL = "ETH-T";
795 
796     uint8 private constant DECIMALS = 18;
797 
798     ////////////////////////
799     // Events
800     ////////////////////////
801 
802     event LogDeposit(
803         address indexed to,
804         uint256 amount
805     );
806 
807     event LogWithdrawal(
808         address indexed from,
809         uint256 amount
810     );
811 
812     ////////////////////////
813     // Constructor
814     ////////////////////////
815 
816     function EtherToken(IAccessPolicy accessPolicy)
817         AccessControlled(accessPolicy)
818         StandardToken()
819         TokenMetadata(NAME, DECIMALS, SYMBOL, "")
820         Reclaimable()
821         public
822     {
823     }
824 
825     ////////////////////////
826     // Public functions
827     ////////////////////////
828 
829     /// deposit msg.value of Ether to msg.sender balance
830     function deposit()
831         payable
832         public
833     {
834         _balances[msg.sender] = add(_balances[msg.sender], msg.value);
835         _totalSupply = add(_totalSupply, msg.value);
836         LogDeposit(msg.sender, msg.value);
837         Transfer(address(0), msg.sender, msg.value);
838     }
839 
840     /// withdraws and sends 'amount' of ether to msg.sender
841     function withdraw(uint256 amount)
842         public
843     {
844         require(_balances[msg.sender] >= amount);
845         _balances[msg.sender] = sub(_balances[msg.sender], amount);
846         _totalSupply = sub(_totalSupply, amount);
847         msg.sender.transfer(amount);
848         LogWithdrawal(msg.sender, amount);
849         Transfer(msg.sender, address(0), amount);
850     }
851 
852     //
853     // Implements IERC223Token
854     //
855 
856     function transfer(address to, uint256 amount, bytes data)
857         public
858         returns (bool)
859     {
860         transferInternal(msg.sender, to, amount);
861 
862         // Notify the receiving contract.
863         if (isContract(to)) {
864             // in case of re-entry (1) transfer is done (2) msg.sender is different
865             IERC223Callback(to).onTokenTransfer(msg.sender, amount, data);
866         }
867         return true;
868     }
869 
870     //
871     // Overrides Reclaimable
872     //
873 
874     /// @notice allows EtherToken to reclaim tokens wrongly sent to its address
875     /// @dev as EtherToken by design has balance of Ether (native Ethereum token)
876     ///     such reclamation is not allowed
877     function reclaim(IBasicToken token)
878         public
879     {
880         // forbid reclaiming ETH hold in this contract.
881         require(token != RECLAIM_ETHER);
882         Reclaimable.reclaim(token);
883     }
884 }
885 
886 /// @notice implemented in the contract that is the target of state migration
887 /// @dev implementation must provide actual function that will be called by source to migrate state
888 contract IMigrationTarget {
889 
890     ////////////////////////
891     // Public functions
892     ////////////////////////
893 
894     // should return migration source address
895     function currentMigrationSource()
896         public
897         constant
898         returns (address);
899 }
900 
901 /// @notice mixin that enables contract to receive migration
902 /// @dev when derived from
903 contract MigrationTarget is
904     IMigrationTarget
905 {
906     ////////////////////////
907     // Modifiers
908     ////////////////////////
909 
910     // intended to be applied on migration receiving function
911     modifier onlyMigrationSource() {
912         require(msg.sender == currentMigrationSource());
913         _;
914     }
915 }
916 
917 /// @notice implemented in the contract that is the target of LockedAccount migration
918 ///  migration process is removing investors balance from source LockedAccount fully
919 ///  target should re-create investor with the same balance, totalLockedAmount and totalInvestors are invariant during migration
920 contract LockedAccountMigration is
921     MigrationTarget
922 {
923     ////////////////////////
924     // Public functions
925     ////////////////////////
926 
927     // implemented in migration target, yes modifiers are inherited from base class
928     function migrateInvestor(
929         address investor,
930         uint256 balance,
931         uint256 neumarksDue,
932         uint256 unlockDate
933     )
934         public
935         onlyMigrationSource();
936 }
937 
938 /// @notice implemented in the contract that stores state to be migrated
939 /// @notice contract is called migration source
940 /// @dev migration target implements IMigrationTarget interface, when it is passed in 'enableMigration' function
941 /// @dev 'migrate' function may be called to migrate part of state owned by msg.sender
942 /// @dev in legal terms this corresponds to amending/changing agreement terms by co-signature of parties
943 contract IMigrationSource {
944 
945     ////////////////////////
946     // Events
947     ////////////////////////
948 
949     event LogMigrationEnabled(
950         address target
951     );
952 
953     ////////////////////////
954     // Public functions
955     ////////////////////////
956 
957     /// @notice should migrate state owned by msg.sender
958     /// @dev intended flow is to: read source state, clear source state, call migrate function on target, log success event
959     function migrate()
960         public;
961 
962     /// @notice should enable migration to migration target
963     /// @dev should limit access to specific role in implementation
964     function enableMigration(IMigrationTarget migration)
965         public;
966 
967     /// @notice returns current migration target
968     function currentMigrationTarget()
969         public
970         constant
971         returns (IMigrationTarget);
972 }
973 
974 /// @notice mixin that enables migration pattern for a contract
975 /// @dev when derived from
976 contract MigrationSource is
977     IMigrationSource,
978     AccessControlled
979 {
980     ////////////////////////
981     // Immutable state
982     ////////////////////////
983 
984     /// stores role hash that can enable migration
985     bytes32 private MIGRATION_ADMIN;
986 
987     ////////////////////////
988     // Mutable state
989     ////////////////////////
990 
991     // migration target contract
992     IMigrationTarget internal _migration;
993 
994     ////////////////////////
995     // Modifiers
996     ////////////////////////
997 
998     /// @notice add to enableMigration function to prevent changing of migration
999     ///     target once set
1000     modifier onlyMigrationEnabledOnce() {
1001         require(address(_migration) == 0);
1002         _;
1003     }
1004 
1005     modifier onlyMigrationEnabled() {
1006         require(address(_migration) != 0);
1007         _;
1008     }
1009 
1010     ////////////////////////
1011     // Constructor
1012     ////////////////////////
1013 
1014     function MigrationSource(
1015         IAccessPolicy policy,
1016         bytes32 migrationAdminRole
1017     )
1018         AccessControlled(policy)
1019         internal
1020     {
1021         MIGRATION_ADMIN = migrationAdminRole;
1022     }
1023 
1024     ////////////////////////
1025     // Public functions
1026     ////////////////////////
1027 
1028     /// @notice should migrate state that belongs to msg.sender
1029     /// @dev do not forget to add accessor modifier in implementation
1030     function migrate()
1031         onlyMigrationEnabled()
1032         public;
1033 
1034     /// @notice should enable migration to migration target
1035     /// @dev do not forget to add accessor modifier in override
1036     function enableMigration(IMigrationTarget migration)
1037         public
1038         onlyMigrationEnabledOnce()
1039         only(MIGRATION_ADMIN)
1040     {
1041         // this must be the source
1042         require(migration.currentMigrationSource() == address(this));
1043         _migration = migration;
1044         LogMigrationEnabled(_migration);
1045     }
1046 
1047     /// @notice returns current migration target
1048     function currentMigrationTarget()
1049         public
1050         constant
1051         returns (IMigrationTarget)
1052     {
1053         return _migration;
1054     }
1055 }
1056 
1057 contract IEthereumForkArbiter {
1058 
1059     ////////////////////////
1060     // Events
1061     ////////////////////////
1062 
1063     event LogForkAnnounced(
1064         string name,
1065         string url,
1066         uint256 blockNumber
1067     );
1068 
1069     event LogForkSigned(
1070         uint256 blockNumber,
1071         bytes32 blockHash
1072     );
1073 
1074     ////////////////////////
1075     // Public functions
1076     ////////////////////////
1077 
1078     function nextForkName()
1079         public
1080         constant
1081         returns (string);
1082 
1083     function nextForkUrl()
1084         public
1085         constant
1086         returns (string);
1087 
1088     function nextForkBlockNumber()
1089         public
1090         constant
1091         returns (uint256);
1092 
1093     function lastSignedBlockNumber()
1094         public
1095         constant
1096         returns (uint256);
1097 
1098     function lastSignedBlockHash()
1099         public
1100         constant
1101         returns (bytes32);
1102 
1103     function lastSignedTimestamp()
1104         public
1105         constant
1106         returns (uint256);
1107 
1108 }
1109 
1110 /**
1111  * @title legally binding smart contract
1112  * @dev General approach to paring legal and smart contracts:
1113  * 1. All terms and agreement are between two parties: here between legal representation of platform operator representative and platform investor.
1114  * 2. Parties are represented by public Ethereum addresses. Platform investor is and address that holds and controls funds and receives and controls Neumark token
1115  * 3. Legal agreement has immutable part that corresponds to smart contract code and mutable part that may change for example due to changing regulations or other externalities that smart contract does not control.
1116  * 4. There should be a provision in legal document that future changes in mutable part cannot change terms of immutable part.
1117  * 5. Immutable part links to corresponding smart contract via its address.
1118  * 6. Additional provision should be added if smart contract supports it
1119  *  a. Fork provision
1120  *  b. Bugfixing provision (unilateral code update mechanism)
1121  *  c. Migration provision (bilateral code update mechanism)
1122  *
1123  * Details on Agreement base class:
1124  * 1. We bind smart contract to legal contract by storing uri (preferably ipfs or hash) of the legal contract in the smart contract. It is however crucial that such binding is done by platform operator representation so transaction establishing the link must be signed by respective wallet ('amendAgreement')
1125  * 2. Mutable part of agreement may change. We should be able to amend the uri later. Previous amendments should not be lost and should be retrievable (`amendAgreement` and 'pastAgreement' functions).
1126  * 3. It is up to deriving contract to decide where to put 'acceptAgreement' modifier. However situation where there is no cryptographic proof that given address was really acting in the transaction should be avoided, simplest example being 'to' address in `transfer` function of ERC20.
1127  *
1128 **/
1129 contract Agreement is
1130     AccessControlled,
1131     AccessRoles
1132 {
1133 
1134     ////////////////////////
1135     // Type declarations
1136     ////////////////////////
1137 
1138     /// @notice agreement with signature of the platform operator representative
1139     struct SignedAgreement {
1140         address platformOperatorRepresentative;
1141         uint256 signedBlockTimestamp;
1142         string agreementUri;
1143     }
1144 
1145     ////////////////////////
1146     // Immutable state
1147     ////////////////////////
1148 
1149     IEthereumForkArbiter private ETHEREUM_FORK_ARBITER;
1150 
1151     ////////////////////////
1152     // Mutable state
1153     ////////////////////////
1154 
1155     // stores all amendments to the agreement, first amendment is the original
1156     SignedAgreement[] private _amendments;
1157 
1158     // stores block numbers of all addresses that signed the agreement (signatory => block number)
1159     mapping(address => uint256) private _signatories;
1160 
1161     ////////////////////////
1162     // Events
1163     ////////////////////////
1164 
1165     event LogAgreementAccepted(
1166         address indexed accepter
1167     );
1168 
1169     event LogAgreementAmended(
1170         address platformOperatorRepresentative,
1171         string agreementUri
1172     );
1173 
1174     ////////////////////////
1175     // Modifiers
1176     ////////////////////////
1177 
1178     /// @notice logs that agreement was accepted by platform user
1179     /// @dev intended to be added to functions that if used make 'accepter' origin to enter legally binding agreement
1180     modifier acceptAgreement(address accepter) {
1181         if(_signatories[accepter] == 0) {
1182             require(_amendments.length > 0);
1183             _signatories[accepter] = block.number;
1184             LogAgreementAccepted(accepter);
1185         }
1186         _;
1187     }
1188 
1189     ////////////////////////
1190     // Constructor
1191     ////////////////////////
1192 
1193     function Agreement(IAccessPolicy accessPolicy, IEthereumForkArbiter forkArbiter)
1194         AccessControlled(accessPolicy)
1195         internal
1196     {
1197         require(forkArbiter != IEthereumForkArbiter(0x0));
1198         ETHEREUM_FORK_ARBITER = forkArbiter;
1199     }
1200 
1201     ////////////////////////
1202     // Public functions
1203     ////////////////////////
1204 
1205     function amendAgreement(string agreementUri)
1206         public
1207         only(ROLE_PLATFORM_OPERATOR_REPRESENTATIVE)
1208     {
1209         SignedAgreement memory amendment = SignedAgreement({
1210             platformOperatorRepresentative: msg.sender,
1211             signedBlockTimestamp: block.timestamp,
1212             agreementUri: agreementUri
1213         });
1214         _amendments.push(amendment);
1215         LogAgreementAmended(msg.sender, agreementUri);
1216     }
1217 
1218     function ethereumForkArbiter()
1219         public
1220         constant
1221         returns (IEthereumForkArbiter)
1222     {
1223         return ETHEREUM_FORK_ARBITER;
1224     }
1225 
1226     function currentAgreement()
1227         public
1228         constant
1229         returns
1230         (
1231             address platformOperatorRepresentative,
1232             uint256 signedBlockTimestamp,
1233             string agreementUri,
1234             uint256 index
1235         )
1236     {
1237         require(_amendments.length > 0);
1238         uint256 last = _amendments.length - 1;
1239         SignedAgreement storage amendment = _amendments[last];
1240         return (
1241             amendment.platformOperatorRepresentative,
1242             amendment.signedBlockTimestamp,
1243             amendment.agreementUri,
1244             last
1245         );
1246     }
1247 
1248     function pastAgreement(uint256 amendmentIndex)
1249         public
1250         constant
1251         returns
1252         (
1253             address platformOperatorRepresentative,
1254             uint256 signedBlockTimestamp,
1255             string agreementUri,
1256             uint256 index
1257         )
1258     {
1259         SignedAgreement storage amendment = _amendments[amendmentIndex];
1260         return (
1261             amendment.platformOperatorRepresentative,
1262             amendment.signedBlockTimestamp,
1263             amendment.agreementUri,
1264             amendmentIndex
1265         );
1266     }
1267 
1268     function agreementSignedAtBlock(address signatory)
1269         public
1270         constant
1271         returns (uint256)
1272     {
1273         return _signatories[signatory];
1274     }
1275 }
1276 
1277 contract NeumarkIssuanceCurve {
1278 
1279     ////////////////////////
1280     // Constants
1281     ////////////////////////
1282 
1283     // maximum number of neumarks that may be created
1284     uint256 private constant NEUMARK_CAP = 1500000000000000000000000000;
1285 
1286     // initial neumark reward fraction (controls curve steepness)
1287     uint256 private constant INITIAL_REWARD_FRACTION = 6500000000000000000;
1288 
1289     // stop issuing new Neumarks above this Euro value (as it goes quickly to zero)
1290     uint256 private constant ISSUANCE_LIMIT_EUR_ULPS = 8300000000000000000000000000;
1291 
1292     // approximate curve linearly above this Euro value
1293     uint256 private constant LINEAR_APPROX_LIMIT_EUR_ULPS = 2100000000000000000000000000;
1294     uint256 private constant NEUMARKS_AT_LINEAR_LIMIT_ULPS = 1499832501287264827896539871;
1295 
1296     uint256 private constant TOT_LINEAR_NEUMARKS_ULPS = NEUMARK_CAP - NEUMARKS_AT_LINEAR_LIMIT_ULPS;
1297     uint256 private constant TOT_LINEAR_EUR_ULPS = ISSUANCE_LIMIT_EUR_ULPS - LINEAR_APPROX_LIMIT_EUR_ULPS;
1298 
1299     ////////////////////////
1300     // Public functions
1301     ////////////////////////
1302 
1303     /// @notice returns additional amount of neumarks issued for euroUlps at totalEuroUlps
1304     /// @param totalEuroUlps actual curve position from which neumarks will be issued
1305     /// @param euroUlps amount against which neumarks will be issued
1306     function incremental(uint256 totalEuroUlps, uint256 euroUlps)
1307         public
1308         constant
1309         returns (uint256 neumarkUlps)
1310     {
1311         require(totalEuroUlps + euroUlps >= totalEuroUlps);
1312         uint256 from = cumulative(totalEuroUlps);
1313         uint256 to = cumulative(totalEuroUlps + euroUlps);
1314         // as expansion is not monotonic for large totalEuroUlps, assert below may fail
1315         // example: totalEuroUlps=1.999999999999999999999000000e+27 and euroUlps=50
1316         assert(to >= from);
1317         return to - from;
1318     }
1319 
1320     /// @notice returns amount of euro corresponding to burned neumarks
1321     /// @param totalEuroUlps actual curve position from which neumarks will be burned
1322     /// @param burnNeumarkUlps amount of neumarks to burn
1323     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps)
1324         public
1325         constant
1326         returns (uint256 euroUlps)
1327     {
1328         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
1329         require(totalNeumarkUlps >= burnNeumarkUlps);
1330         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
1331         uint newTotalEuroUlps = cumulativeInverse(fromNmk, 0, totalEuroUlps);
1332         // yes, this may overflow due to non monotonic inverse function
1333         assert(totalEuroUlps >= newTotalEuroUlps);
1334         return totalEuroUlps - newTotalEuroUlps;
1335     }
1336 
1337     /// @notice returns amount of euro corresponding to burned neumarks
1338     /// @param totalEuroUlps actual curve position from which neumarks will be burned
1339     /// @param burnNeumarkUlps amount of neumarks to burn
1340     /// @param minEurUlps euro amount to start inverse search from, inclusive
1341     /// @param maxEurUlps euro amount to end inverse search to, inclusive
1342     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
1343         public
1344         constant
1345         returns (uint256 euroUlps)
1346     {
1347         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
1348         require(totalNeumarkUlps >= burnNeumarkUlps);
1349         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
1350         uint newTotalEuroUlps = cumulativeInverse(fromNmk, minEurUlps, maxEurUlps);
1351         // yes, this may overflow due to non monotonic inverse function
1352         assert(totalEuroUlps >= newTotalEuroUlps);
1353         return totalEuroUlps - newTotalEuroUlps;
1354     }
1355 
1356     /// @notice finds total amount of neumarks issued for given amount of Euro
1357     /// @dev binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
1358     ///     function below is not monotonic
1359     function cumulative(uint256 euroUlps)
1360         public
1361         constant
1362         returns(uint256 neumarkUlps)
1363     {
1364         // Return the cap if euroUlps is above the limit.
1365         if (euroUlps >= ISSUANCE_LIMIT_EUR_ULPS) {
1366             return NEUMARK_CAP;
1367         }
1368         // use linear approximation above limit below
1369         // binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
1370         if (euroUlps >= LINEAR_APPROX_LIMIT_EUR_ULPS) {
1371             // (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS) is small so expression does not overflow
1372             return NEUMARKS_AT_LINEAR_LIMIT_ULPS + (TOT_LINEAR_NEUMARKS_ULPS * (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS)) / TOT_LINEAR_EUR_ULPS;
1373         }
1374 
1375         // Approximate cap-cap·(1-1/D)^n using the Binomial expansion
1376         // http://galileo.phys.virginia.edu/classes/152.mf1i.spring02/Exponential_Function.htm
1377         // Function[imax, -CAP*Sum[(-IR*EUR/CAP)^i/Factorial[i], {i, imax}]]
1378         // which may be simplified to
1379         // Function[imax, -CAP*Sum[(EUR)^i/(Factorial[i]*(-d)^i), {i, 1, imax}]]
1380         // where d = cap/initial_reward
1381         uint256 d = 230769230769230769230769231; // NEUMARK_CAP / INITIAL_REWARD_FRACTION
1382         uint256 term = NEUMARK_CAP;
1383         uint256 sum = 0;
1384         uint256 denom = d;
1385         do assembly {
1386             // We use assembler primarily to avoid the expensive
1387             // divide-by-zero check solc inserts for the / operator.
1388             term  := div(mul(term, euroUlps), denom)
1389             sum   := add(sum, term)
1390             denom := add(denom, d)
1391             // sub next term as we have power of negative value in the binomial expansion
1392             term  := div(mul(term, euroUlps), denom)
1393             sum   := sub(sum, term)
1394             denom := add(denom, d)
1395         } while (term != 0);
1396         return sum;
1397     }
1398 
1399     /// @notice find issuance curve inverse by binary search
1400     /// @param neumarkUlps neumark amount to compute inverse for
1401     /// @param minEurUlps minimum search range for the inverse, inclusive
1402     /// @param maxEurUlps maxium search range for the inverse, inclusive
1403     /// @dev in case of approximate search (no exact inverse) upper element of minimal search range is returned
1404     /// @dev in case of many possible inverses, the lowest one will be used (if range permits)
1405     /// @dev corresponds to a linear search that returns first euroUlp value that has cumulative() equal or greater than neumarkUlps
1406     function cumulativeInverse(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
1407         public
1408         constant
1409         returns (uint256 euroUlps)
1410     {
1411         require(maxEurUlps >= minEurUlps);
1412         require(cumulative(minEurUlps) <= neumarkUlps);
1413         require(cumulative(maxEurUlps) >= neumarkUlps);
1414         uint256 min = minEurUlps;
1415         uint256 max = maxEurUlps;
1416 
1417         // Binary search
1418         while (max > min) {
1419             uint256 mid = (max + min) / 2;
1420             uint256 val = cumulative(mid);
1421             // exact solution should not be used, a late points of the curve when many euroUlps are needed to
1422             // increase by one nmkUlp this will lead to  "indeterministic" inverse values that depend on the initial min and max
1423             // and further binary division -> you can land at any of the euro value that is mapped to the same nmk value
1424             // with condition below removed, binary search will point to the lowest eur value possible which is good because it cannot be exploited even with 0 gas costs
1425             /* if (val == neumarkUlps) {
1426                 return mid;
1427             }*/
1428             // NOTE: approximate search (no inverse) must return upper element of the final range
1429             //  last step of approximate search is always (min, min+1) so new mid is (2*min+1)/2 => min
1430             //  so new min = mid + 1 = max which was upper range. and that ends the search
1431             // NOTE: when there are multiple inverses for the same neumarkUlps, the `max` will be dragged down
1432             //  by `max = mid` expression to the lowest eur value of inverse. works only for ranges that cover all points of multiple inverse
1433             if (val < neumarkUlps) {
1434                 min = mid + 1;
1435             } else {
1436                 max = mid;
1437             }
1438         }
1439         // NOTE: It is possible that there is no inverse
1440         //  for example curve(0) = 0 and curve(1) = 6, so
1441         //  there is no value y such that curve(y) = 5.
1442         //  When there is no inverse, we must return upper element of last search range.
1443         //  This has the effect of reversing the curve less when
1444         //  burning Neumarks. This ensures that Neumarks can always
1445         //  be burned. It also ensure that the total supply of Neumarks
1446         //  remains below the cap.
1447         return max;
1448     }
1449 
1450     function neumarkCap()
1451         public
1452         constant
1453         returns (uint256)
1454     {
1455         return NEUMARK_CAP;
1456     }
1457 
1458     function initialRewardFraction()
1459         public
1460         constant
1461         returns (uint256)
1462     {
1463         return INITIAL_REWARD_FRACTION;
1464     }
1465 }
1466 
1467 /// @title advances snapshot id on demand
1468 /// @dev see Snapshot folder for implementation examples ie. DailyAndSnapshotable contract
1469 contract ISnapshotable {
1470 
1471     ////////////////////////
1472     // Events
1473     ////////////////////////
1474 
1475     /// @dev should log each new snapshot id created, including snapshots created automatically via MSnapshotPolicy
1476     event LogSnapshotCreated(uint256 snapshotId);
1477 
1478     ////////////////////////
1479     // Public functions
1480     ////////////////////////
1481 
1482     /// always creates new snapshot id which gets returned
1483     /// however, there is no guarantee that any snapshot will be created with this id, this depends on the implementation of MSnaphotPolicy
1484     function createSnapshot()
1485         public
1486         returns (uint256);
1487 
1488     /// upper bound of series snapshotIds for which there's a value
1489     function currentSnapshotId()
1490         public
1491         constant
1492         returns (uint256);
1493 }
1494 
1495 /// @title Abstracts snapshot id creation logics
1496 /// @dev Mixin (internal interface) of the snapshot policy which abstracts snapshot id creation logics from Snapshot contract
1497 /// @dev to be implemented and such implementation should be mixed with Snapshot-derived contract, see EveryBlock for simplest example of implementation and StandardSnapshotToken
1498 contract MSnapshotPolicy {
1499 
1500     ////////////////////////
1501     // Internal functions
1502     ////////////////////////
1503 
1504     // The snapshot Ids need to be strictly increasing.
1505     // Whenever the snaspshot id changes, a new snapshot will be created.
1506     // As long as the same snapshot id is being returned, last snapshot will be updated as this indicates that snapshot id didn't change
1507     //
1508     // Values passed to `hasValueAt` and `valuteAt` are required
1509     // to be less or equal to `mCurrentSnapshotId()`.
1510     function mCurrentSnapshotId()
1511         internal
1512         returns (uint256);
1513 }
1514 
1515 /// @title creates snapshot id on each day boundary and allows to create additional snapshots within a given day
1516 /// @dev snapshots are encoded in single uint256, where high 128 bits represents a day number (from unix epoch) and low 128 bits represents additional snapshots within given day create via ISnapshotable
1517 contract DailyAndSnapshotable is
1518     MSnapshotPolicy,
1519     ISnapshotable
1520 {
1521     ////////////////////////
1522     // Constants
1523     ////////////////////////
1524 
1525     // Floor[2**128 / 1 days]
1526     uint256 private MAX_TIMESTAMP = 3938453320844195178974243141571391;
1527 
1528     ////////////////////////
1529     // Mutable state
1530     ////////////////////////
1531 
1532     uint256 private _currentSnapshotId;
1533 
1534     ////////////////////////
1535     // Constructor
1536     ////////////////////////
1537 
1538     /// @param start snapshotId from which to start generating values
1539     /// @dev start must be for the same day or 0, required for token cloning
1540     function DailyAndSnapshotable(uint256 start) internal {
1541         // 0 is invalid value as we are past unix epoch
1542         if (start > 0) {
1543             uint256 dayBase = snapshotAt(block.timestamp);
1544             require(start >= dayBase);
1545             // dayBase + 2**128 will not overflow as it is based on block.timestamp
1546             require(start < dayBase + 2**128);
1547             _currentSnapshotId = start;
1548         }
1549     }
1550 
1551     ////////////////////////
1552     // Public functions
1553     ////////////////////////
1554 
1555     function snapshotAt(uint256 timestamp)
1556         public
1557         constant
1558         returns (uint256)
1559     {
1560         require(timestamp < MAX_TIMESTAMP);
1561 
1562         uint256 dayBase = 2**128 * (timestamp / 1 days);
1563         return dayBase;
1564     }
1565 
1566     //
1567     // Implements ISnapshotable
1568     //
1569 
1570     function createSnapshot()
1571         public
1572         returns (uint256)
1573     {
1574         uint256 dayBase = 2**128 * (block.timestamp / 1 days);
1575 
1576         if (dayBase > _currentSnapshotId) {
1577             // New day has started, create snapshot for midnight
1578             _currentSnapshotId = dayBase;
1579         } else {
1580             // within single day, increase counter (assume 2**128 will not be crossed)
1581             _currentSnapshotId += 1;
1582         }
1583 
1584         // Log and return
1585         LogSnapshotCreated(_currentSnapshotId);
1586         return _currentSnapshotId;
1587     }
1588 
1589     function currentSnapshotId()
1590         public
1591         constant
1592         returns (uint256)
1593     {
1594         return mCurrentSnapshotId();
1595     }
1596 
1597     ////////////////////////
1598     // Internal functions
1599     ////////////////////////
1600 
1601     //
1602     // Implements MSnapshotPolicy
1603     //
1604 
1605     function mCurrentSnapshotId()
1606         internal
1607         returns (uint256)
1608     {
1609         uint256 dayBase = 2**128 * (block.timestamp / 1 days);
1610 
1611         // New day has started
1612         if (dayBase > _currentSnapshotId) {
1613             _currentSnapshotId = dayBase;
1614             LogSnapshotCreated(dayBase);
1615         }
1616 
1617         return _currentSnapshotId;
1618     }
1619 }
1620 
1621 /// @title controls spending approvals
1622 /// @dev TokenAllowance observes this interface, Neumark contract implements it
1623 contract MTokenAllowanceController {
1624 
1625     ////////////////////////
1626     // Internal functions
1627     ////////////////////////
1628 
1629     /// @notice Notifies the controller about an approval allowing the
1630     ///  controller to react if desired
1631     /// @param owner The address that calls `approve()`
1632     /// @param spender The spender in the `approve()` call
1633     /// @param amount The amount in the `approve()` call
1634     /// @return False if the controller does not authorize the approval
1635     function mOnApprove(
1636         address owner,
1637         address spender,
1638         uint256 amount
1639     )
1640         internal
1641         returns (bool allow);
1642 
1643 }
1644 
1645 /// @title controls token transfers
1646 /// @dev BasicSnapshotToken observes this interface, Neumark contract implements it
1647 contract MTokenTransferController {
1648 
1649     ////////////////////////
1650     // Internal functions
1651     ////////////////////////
1652 
1653     /// @notice Notifies the controller about a token transfer allowing the
1654     ///  controller to react if desired
1655     /// @param from The origin of the transfer
1656     /// @param to The destination of the transfer
1657     /// @param amount The amount of the transfer
1658     /// @return False if the controller does not authorize the transfer
1659     function mOnTransfer(
1660         address from,
1661         address to,
1662         uint256 amount
1663     )
1664         internal
1665         returns (bool allow);
1666 
1667 }
1668 
1669 /// @title controls approvals and transfers
1670 /// @dev The token controller contract must implement these functions, see Neumark as example
1671 /// @dev please note that controller may be a separate contract that is called from mOnTransfer and mOnApprove functions
1672 contract MTokenController is MTokenTransferController, MTokenAllowanceController {
1673 }
1674 
1675 /// @title internal token transfer function
1676 /// @dev see BasicSnapshotToken for implementation
1677 contract MTokenTransfer {
1678 
1679     ////////////////////////
1680     // Internal functions
1681     ////////////////////////
1682 
1683     /// @dev This is the actual transfer function in the token contract, it can
1684     ///  only be called by other functions in this contract.
1685     /// @param from The address holding the tokens being transferred
1686     /// @param to The address of the recipient
1687     /// @param amount The amount of tokens to be transferred
1688     /// @dev  reverts if transfer was not successful
1689     function mTransfer(
1690         address from,
1691         address to,
1692         uint256 amount
1693     )
1694         internal;
1695 }
1696 
1697 /// @title token spending approval and transfer
1698 /// @dev implements token approval and transfers and exposes relevant part of ERC20 and ERC677 approveAndCall
1699 ///     may be mixed in with any basic token (implementing mTransfer) like BasicSnapshotToken or MintableSnapshotToken to add approval mechanism
1700 ///     observes MTokenAllowanceController interface
1701 ///     observes MTokenTransfer
1702 contract TokenAllowance is
1703     MTokenTransfer,
1704     MTokenAllowanceController,
1705     IERC20Allowance,
1706     IERC677Token
1707 {
1708 
1709     ////////////////////////
1710     // Mutable state
1711     ////////////////////////
1712 
1713     // `allowed` tracks rights to spends others tokens as per ERC20
1714     mapping (address => mapping (address => uint256)) private _allowed;
1715 
1716     ////////////////////////
1717     // Constructor
1718     ////////////////////////
1719 
1720     function TokenAllowance()
1721         internal
1722     {
1723     }
1724 
1725     ////////////////////////
1726     // Public functions
1727     ////////////////////////
1728 
1729     //
1730     // Implements IERC20Token
1731     //
1732 
1733     /// @dev This function makes it easy to read the `allowed[]` map
1734     /// @param owner The address of the account that owns the token
1735     /// @param spender The address of the account able to transfer the tokens
1736     /// @return Amount of remaining tokens of _owner that _spender is allowed
1737     ///  to spend
1738     function allowance(address owner, address spender)
1739         public
1740         constant
1741         returns (uint256 remaining)
1742     {
1743         return _allowed[owner][spender];
1744     }
1745 
1746     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
1747     ///  its behalf. This is a modified version of the ERC20 approve function
1748     ///  where allowance per spender must be 0 to allow change of such allowance
1749     /// @param spender The address of the account able to transfer the tokens
1750     /// @param amount The amount of tokens to be approved for transfer
1751     /// @return True or reverts, False is never returned
1752     function approve(address spender, uint256 amount)
1753         public
1754         returns (bool success)
1755     {
1756         // Alerts the token controller of the approve function call
1757         require(mOnApprove(msg.sender, spender, amount));
1758 
1759         // To change the approve amount you first have to reduce the addresses`
1760         //  allowance to zero by calling `approve(_spender,0)` if it is not
1761         //  already 0 to mitigate the race condition described here:
1762         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1763         require((amount == 0) || (_allowed[msg.sender][spender] == 0));
1764 
1765         _allowed[msg.sender][spender] = amount;
1766         Approval(msg.sender, spender, amount);
1767         return true;
1768     }
1769 
1770     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
1771     ///  is approved by `_from`
1772     /// @param from The address holding the tokens being transferred
1773     /// @param to The address of the recipient
1774     /// @param amount The amount of tokens to be transferred
1775     /// @return True if the transfer was successful, reverts in any other case
1776     function transferFrom(address from, address to, uint256 amount)
1777         public
1778         returns (bool success)
1779     {
1780         // The standard ERC 20 transferFrom functionality
1781         bool amountApproved = _allowed[from][msg.sender] >= amount;
1782         require(amountApproved);
1783 
1784         _allowed[from][msg.sender] -= amount;
1785         mTransfer(from, to, amount);
1786 
1787         return true;
1788     }
1789 
1790     //
1791     // Implements IERC677Token
1792     //
1793 
1794     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
1795     ///  its behalf, and then a function is triggered in the contract that is
1796     ///  being approved, `_spender`. This allows users to use their tokens to
1797     ///  interact with contracts in one function call instead of two
1798     /// @param spender The address of the contract able to transfer the tokens
1799     /// @param amount The amount of tokens to be approved for transfer
1800     /// @return True or reverts, False is never returned
1801     function approveAndCall(
1802         address spender,
1803         uint256 amount,
1804         bytes extraData
1805     )
1806         public
1807         returns (bool success)
1808     {
1809         require(approve(spender, amount));
1810 
1811         success = IERC677Callback(spender).receiveApproval(
1812             msg.sender,
1813             amount,
1814             this,
1815             extraData
1816         );
1817         require(success);
1818 
1819         return true;
1820     }
1821 }
1822 
1823 /// @title Reads and writes snapshots
1824 /// @dev Manages reading and writing a series of values, where each value has assigned a snapshot id for access to historical data
1825 /// @dev may be added to any contract to provide snapshotting mechanism. should be mixed in with any of MSnapshotPolicy implementations to customize snapshot creation mechanics
1826 ///     observes MSnapshotPolicy
1827 /// based on MiniMe token
1828 contract Snapshot is MSnapshotPolicy {
1829 
1830     ////////////////////////
1831     // Types
1832     ////////////////////////
1833 
1834     /// @dev `Values` is the structure that attaches a snapshot id to a
1835     ///  given value, the snapshot id attached is the one that last changed the
1836     ///  value
1837     struct Values {
1838 
1839         // `snapshotId` is the snapshot id that the value was generated at
1840         uint256 snapshotId;
1841 
1842         // `value` at a specific snapshot id
1843         uint256 value;
1844     }
1845 
1846     ////////////////////////
1847     // Internal functions
1848     ////////////////////////
1849 
1850     function hasValue(
1851         Values[] storage values
1852     )
1853         internal
1854         constant
1855         returns (bool)
1856     {
1857         return values.length > 0;
1858     }
1859 
1860     /// @dev makes sure that 'snapshotId' between current snapshot id (mCurrentSnapshotId) and first snapshot id. this guarantees that getValueAt returns value from one of the snapshots.
1861     function hasValueAt(
1862         Values[] storage values,
1863         uint256 snapshotId
1864     )
1865         internal
1866         constant
1867         returns (bool)
1868     {
1869         require(snapshotId <= mCurrentSnapshotId());
1870         return values.length > 0 && values[0].snapshotId <= snapshotId;
1871     }
1872 
1873     /// gets last value in the series
1874     function getValue(
1875         Values[] storage values,
1876         uint256 defaultValue
1877     )
1878         internal
1879         constant
1880         returns (uint256)
1881     {
1882         if (values.length == 0) {
1883             return defaultValue;
1884         } else {
1885             uint256 last = values.length - 1;
1886             return values[last].value;
1887         }
1888     }
1889 
1890     /// @dev `getValueAt` retrieves value at a given snapshot id
1891     /// @param values The series of values being queried
1892     /// @param snapshotId Snapshot id to retrieve the value at
1893     /// @return Value in series being queried
1894     function getValueAt(
1895         Values[] storage values,
1896         uint256 snapshotId,
1897         uint256 defaultValue
1898     )
1899         internal
1900         constant
1901         returns (uint256)
1902     {
1903         require(snapshotId <= mCurrentSnapshotId());
1904 
1905         // Empty value
1906         if (values.length == 0) {
1907             return defaultValue;
1908         }
1909 
1910         // Shortcut for the out of bounds snapshots
1911         uint256 last = values.length - 1;
1912         uint256 lastSnapshot = values[last].snapshotId;
1913         if (snapshotId >= lastSnapshot) {
1914             return values[last].value;
1915         }
1916         uint256 firstSnapshot = values[0].snapshotId;
1917         if (snapshotId < firstSnapshot) {
1918             return defaultValue;
1919         }
1920         // Binary search of the value in the array
1921         uint256 min = 0;
1922         uint256 max = last;
1923         while (max > min) {
1924             uint256 mid = (max + min + 1) / 2;
1925             // must always return lower indice for approximate searches
1926             if (values[mid].snapshotId <= snapshotId) {
1927                 min = mid;
1928             } else {
1929                 max = mid - 1;
1930             }
1931         }
1932         return values[min].value;
1933     }
1934 
1935     /// @dev `setValue` used to update sequence at next snapshot
1936     /// @param values The sequence being updated
1937     /// @param value The new last value of sequence
1938     function setValue(
1939         Values[] storage values,
1940         uint256 value
1941     )
1942         internal
1943     {
1944         // TODO: simplify or break into smaller functions
1945 
1946         uint256 currentSnapshotId = mCurrentSnapshotId();
1947         // Always create a new entry if there currently is no value
1948         bool empty = values.length == 0;
1949         if (empty) {
1950             // Create a new entry
1951             values.push(
1952                 Values({
1953                     snapshotId: currentSnapshotId,
1954                     value: value
1955                 })
1956             );
1957             return;
1958         }
1959 
1960         uint256 last = values.length - 1;
1961         bool hasNewSnapshot = values[last].snapshotId < currentSnapshotId;
1962         if (hasNewSnapshot) {
1963 
1964             // Do nothing if the value was not modified
1965             bool unmodified = values[last].value == value;
1966             if (unmodified) {
1967                 return;
1968             }
1969 
1970             // Create new entry
1971             values.push(
1972                 Values({
1973                     snapshotId: currentSnapshotId,
1974                     value: value
1975                 })
1976             );
1977         } else {
1978 
1979             // We are updating the currentSnapshotId
1980             bool previousUnmodified = last > 0 && values[last - 1].value == value;
1981             if (previousUnmodified) {
1982                 // Remove current snapshot if current value was set to previous value
1983                 delete values[last];
1984                 values.length--;
1985                 return;
1986             }
1987 
1988             // Overwrite next snapshot entry
1989             values[last].value = value;
1990         }
1991     }
1992 }
1993 
1994 /// @title access to snapshots of a token
1995 /// @notice allows to implement complex token holder rights like revenue disbursal or voting
1996 /// @notice snapshots are series of values with assigned ids. ids increase strictly. particular id mechanism is not assumed
1997 contract ITokenSnapshots {
1998 
1999     ////////////////////////
2000     // Public functions
2001     ////////////////////////
2002 
2003     /// @notice Total amount of tokens at a specific `snapshotId`.
2004     /// @param snapshotId of snapshot at which totalSupply is queried
2005     /// @return The total amount of tokens at `snapshotId`
2006     /// @dev reverts on snapshotIds greater than currentSnapshotId()
2007     /// @dev returns 0 for snapshotIds less than snapshotId of first value
2008     function totalSupplyAt(uint256 snapshotId)
2009         public
2010         constant
2011         returns(uint256);
2012 
2013     /// @dev Queries the balance of `owner` at a specific `snapshotId`
2014     /// @param owner The address from which the balance will be retrieved
2015     /// @param snapshotId of snapshot at which the balance is queried
2016     /// @return The balance at `snapshotId`
2017     function balanceOfAt(address owner, uint256 snapshotId)
2018         public
2019         constant
2020         returns (uint256);
2021 
2022     /// @notice upper bound of series of snapshotIds for which there's a value in series
2023     /// @return snapshotId
2024     function currentSnapshotId()
2025         public
2026         constant
2027         returns (uint256);
2028 }
2029 
2030 /// @title represents link between cloned and parent token
2031 /// @dev when token is clone from other token, initial balances of the cloned token
2032 ///     correspond to balances of parent token at the moment of parent snapshot id specified
2033 /// @notice please note that other tokens beside snapshot token may be cloned
2034 contract IClonedTokenParent is ITokenSnapshots {
2035 
2036     ////////////////////////
2037     // Public functions
2038     ////////////////////////
2039 
2040 
2041     /// @return address of parent token, address(0) if root
2042     /// @dev parent token does not need to clonable, nor snapshottable, just a normal token
2043     function parentToken()
2044         public
2045         constant
2046         returns(IClonedTokenParent parent);
2047 
2048     /// @return snapshot at wchich initial token distribution was taken
2049     function parentSnapshotId()
2050         public
2051         constant
2052         returns(uint256 snapshotId);
2053 }
2054 
2055 /// @title token with snapshots and transfer functionality
2056 /// @dev observes MTokenTransferController interface
2057 ///     observes ISnapshotToken interface
2058 ///     implementes MTokenTransfer interface
2059 contract BasicSnapshotToken is
2060     MTokenTransfer,
2061     MTokenTransferController,
2062     IBasicToken,
2063     IClonedTokenParent,
2064     Snapshot
2065 {
2066     ////////////////////////
2067     // Immutable state
2068     ////////////////////////
2069 
2070     // `PARENT_TOKEN` is the Token address that was cloned to produce this token;
2071     //  it will be 0x0 for a token that was not cloned
2072     IClonedTokenParent private PARENT_TOKEN;
2073 
2074     // `PARENT_SNAPSHOT_ID` is the snapshot id from the Parent Token that was
2075     //  used to determine the initial distribution of the cloned token
2076     uint256 private PARENT_SNAPSHOT_ID;
2077 
2078     ////////////////////////
2079     // Mutable state
2080     ////////////////////////
2081 
2082     // `balances` is the map that tracks the balance of each address, in this
2083     //  contract when the balance changes the snapshot id that the change
2084     //  occurred is also included in the map
2085     mapping (address => Values[]) internal _balances;
2086 
2087     // Tracks the history of the `totalSupply` of the token
2088     Values[] internal _totalSupplyValues;
2089 
2090     ////////////////////////
2091     // Constructor
2092     ////////////////////////
2093 
2094     /// @notice Constructor to create snapshot token
2095     /// @param parentToken Address of the parent token, set to 0x0 if it is a
2096     ///  new token
2097     /// @param parentSnapshotId at which snapshot id clone was created, set to 0 to clone at upper bound
2098     /// @dev please not that as long as cloned token does not overwrite value at current snapshot id, it will refer
2099     ///     to parent token at which this snapshot still may change until snapshot id increases. for that time tokens are coupled
2100     ///     this is prevented by parentSnapshotId value of parentToken.currentSnapshotId() - 1 being the maxiumum
2101     ///     see SnapshotToken.js test to learn consequences coupling has.
2102     function BasicSnapshotToken(
2103         IClonedTokenParent parentToken,
2104         uint256 parentSnapshotId
2105     )
2106         Snapshot()
2107         internal
2108     {
2109         PARENT_TOKEN = parentToken;
2110         if (parentToken == address(0)) {
2111             require(parentSnapshotId == 0);
2112         } else {
2113             if (parentSnapshotId == 0) {
2114                 require(parentToken.currentSnapshotId() > 0);
2115                 PARENT_SNAPSHOT_ID = parentToken.currentSnapshotId() - 1;
2116             } else {
2117                 PARENT_SNAPSHOT_ID = parentSnapshotId;
2118             }
2119         }
2120     }
2121 
2122     ////////////////////////
2123     // Public functions
2124     ////////////////////////
2125 
2126     //
2127     // Implements IBasicToken
2128     //
2129 
2130     /// @dev This function makes it easy to get the total number of tokens
2131     /// @return The total number of tokens
2132     function totalSupply()
2133         public
2134         constant
2135         returns (uint256)
2136     {
2137         return totalSupplyAtInternal(mCurrentSnapshotId());
2138     }
2139 
2140     /// @param owner The address that's balance is being requested
2141     /// @return The balance of `owner` at the current block
2142     function balanceOf(address owner)
2143         public
2144         constant
2145         returns (uint256 balance)
2146     {
2147         return balanceOfAtInternal(owner, mCurrentSnapshotId());
2148     }
2149 
2150     /// @notice Send `amount` tokens to `to` from `msg.sender`
2151     /// @param to The address of the recipient
2152     /// @param amount The amount of tokens to be transferred
2153     /// @return True if the transfer was successful, reverts in any other case
2154     function transfer(address to, uint256 amount)
2155         public
2156         returns (bool success)
2157     {
2158         mTransfer(msg.sender, to, amount);
2159         return true;
2160     }
2161 
2162     //
2163     // Implements ITokenSnapshots
2164     //
2165 
2166     function totalSupplyAt(uint256 snapshotId)
2167         public
2168         constant
2169         returns(uint256)
2170     {
2171         return totalSupplyAtInternal(snapshotId);
2172     }
2173 
2174     function balanceOfAt(address owner, uint256 snapshotId)
2175         public
2176         constant
2177         returns (uint256)
2178     {
2179         return balanceOfAtInternal(owner, snapshotId);
2180     }
2181 
2182     function currentSnapshotId()
2183         public
2184         constant
2185         returns (uint256)
2186     {
2187         return mCurrentSnapshotId();
2188     }
2189 
2190     //
2191     // Implements IClonedTokenParent
2192     //
2193 
2194     function parentToken()
2195         public
2196         constant
2197         returns(IClonedTokenParent parent)
2198     {
2199         return PARENT_TOKEN;
2200     }
2201 
2202     /// @return snapshot at wchich initial token distribution was taken
2203     function parentSnapshotId()
2204         public
2205         constant
2206         returns(uint256 snapshotId)
2207     {
2208         return PARENT_SNAPSHOT_ID;
2209     }
2210 
2211     //
2212     // Other public functions
2213     //
2214 
2215     /// @notice gets all token balances of 'owner'
2216     /// @dev intended to be called via eth_call where gas limit is not an issue
2217     function allBalancesOf(address owner)
2218         external
2219         constant
2220         returns (uint256[2][])
2221     {
2222         /* very nice and working implementation below,
2223         // copy to memory
2224         Values[] memory values = _balances[owner];
2225         do assembly {
2226             // in memory structs have simple layout where every item occupies uint256
2227             balances := values
2228         } while (false);*/
2229 
2230         Values[] storage values = _balances[owner];
2231         uint256[2][] memory balances = new uint256[2][](values.length);
2232         for(uint256 ii = 0; ii < values.length; ++ii) {
2233             balances[ii] = [values[ii].snapshotId, values[ii].value];
2234         }
2235 
2236         return balances;
2237     }
2238 
2239     ////////////////////////
2240     // Internal functions
2241     ////////////////////////
2242 
2243     function totalSupplyAtInternal(uint256 snapshotId)
2244         public
2245         constant
2246         returns(uint256)
2247     {
2248         Values[] storage values = _totalSupplyValues;
2249 
2250         // If there is a value, return it, reverts if value is in the future
2251         if (hasValueAt(values, snapshotId)) {
2252             return getValueAt(values, snapshotId, 0);
2253         }
2254 
2255         // Try parent contract at or before the fork
2256         if (address(PARENT_TOKEN) != 0) {
2257             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
2258             return PARENT_TOKEN.totalSupplyAt(earlierSnapshotId);
2259         }
2260 
2261         // Default to an empty balance
2262         return 0;
2263     }
2264 
2265     // get balance at snapshot if with continuation in parent token
2266     function balanceOfAtInternal(address owner, uint256 snapshotId)
2267         internal
2268         constant
2269         returns (uint256)
2270     {
2271         Values[] storage values = _balances[owner];
2272 
2273         // If there is a value, return it, reverts if value is in the future
2274         if (hasValueAt(values, snapshotId)) {
2275             return getValueAt(values, snapshotId, 0);
2276         }
2277 
2278         // Try parent contract at or before the fork
2279         if (PARENT_TOKEN != address(0)) {
2280             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
2281             return PARENT_TOKEN.balanceOfAt(owner, earlierSnapshotId);
2282         }
2283 
2284         // Default to an empty balance
2285         return 0;
2286     }
2287 
2288     //
2289     // Implements MTokenTransfer
2290     //
2291 
2292     /// @dev This is the actual transfer function in the token contract, it can
2293     ///  only be called by other functions in this contract.
2294     /// @param from The address holding the tokens being transferred
2295     /// @param to The address of the recipient
2296     /// @param amount The amount of tokens to be transferred
2297     /// @return True if the transfer was successful, reverts in any other case
2298     function mTransfer(
2299         address from,
2300         address to,
2301         uint256 amount
2302     )
2303         internal
2304     {
2305         // never send to address 0
2306         require(to != address(0));
2307         // block transfers in clone that points to future/current snapshots of patent token
2308         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2309         // Alerts the token controller of the transfer
2310         require(mOnTransfer(from, to, amount));
2311 
2312         // If the amount being transfered is more than the balance of the
2313         //  account the transfer reverts
2314         var previousBalanceFrom = balanceOf(from);
2315         require(previousBalanceFrom >= amount);
2316 
2317         // First update the balance array with the new value for the address
2318         //  sending the tokens
2319         uint256 newBalanceFrom = previousBalanceFrom - amount;
2320         setValue(_balances[from], newBalanceFrom);
2321 
2322         // Then update the balance array with the new value for the address
2323         //  receiving the tokens
2324         uint256 previousBalanceTo = balanceOf(to);
2325         uint256 newBalanceTo = previousBalanceTo + amount;
2326         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
2327         setValue(_balances[to], newBalanceTo);
2328 
2329         // An event to make the transfer easy to find on the blockchain
2330         Transfer(from, to, amount);
2331     }
2332 }
2333 
2334 /// @title token generation and destruction
2335 /// @dev internal interface providing token generation and destruction, see MintableSnapshotToken for implementation
2336 contract MTokenMint {
2337 
2338     ////////////////////////
2339     // Internal functions
2340     ////////////////////////
2341 
2342     /// @notice Generates `amount` tokens that are assigned to `owner`
2343     /// @param owner The address that will be assigned the new tokens
2344     /// @param amount The quantity of tokens generated
2345     /// @dev reverts if tokens could not be generated
2346     function mGenerateTokens(address owner, uint256 amount)
2347         internal;
2348 
2349     /// @notice Burns `amount` tokens from `owner`
2350     /// @param owner The address that will lose the tokens
2351     /// @param amount The quantity of tokens to burn
2352     /// @dev reverts if tokens could not be destroyed
2353     function mDestroyTokens(address owner, uint256 amount)
2354         internal;
2355 }
2356 
2357 /// @title basic snapshot token with facitilites to generate and destroy tokens
2358 /// @dev implementes MTokenMint, does not expose any public functions that create/destroy tokens
2359 contract MintableSnapshotToken is
2360     BasicSnapshotToken,
2361     MTokenMint
2362 {
2363 
2364     ////////////////////////
2365     // Constructor
2366     ////////////////////////
2367 
2368     /// @notice Constructor to create a MintableSnapshotToken
2369     /// @param parentToken Address of the parent token, set to 0x0 if it is a
2370     ///  new token
2371     function MintableSnapshotToken(
2372         IClonedTokenParent parentToken,
2373         uint256 parentSnapshotId
2374     )
2375         BasicSnapshotToken(parentToken, parentSnapshotId)
2376         internal
2377     {}
2378 
2379     /// @notice Generates `amount` tokens that are assigned to `owner`
2380     /// @param owner The address that will be assigned the new tokens
2381     /// @param amount The quantity of tokens generated
2382     function mGenerateTokens(address owner, uint256 amount)
2383         internal
2384     {
2385         // never create for address 0
2386         require(owner != address(0));
2387         // block changes in clone that points to future/current snapshots of patent token
2388         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2389 
2390         uint256 curTotalSupply = totalSupply();
2391         uint256 newTotalSupply = curTotalSupply + amount;
2392         require(newTotalSupply >= curTotalSupply); // Check for overflow
2393 
2394         uint256 previousBalanceTo = balanceOf(owner);
2395         uint256 newBalanceTo = previousBalanceTo + amount;
2396         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
2397 
2398         setValue(_totalSupplyValues, newTotalSupply);
2399         setValue(_balances[owner], newBalanceTo);
2400 
2401         Transfer(0, owner, amount);
2402     }
2403 
2404     /// @notice Burns `amount` tokens from `owner`
2405     /// @param owner The address that will lose the tokens
2406     /// @param amount The quantity of tokens to burn
2407     function mDestroyTokens(address owner, uint256 amount)
2408         internal
2409     {
2410         // block changes in clone that points to future/current snapshots of patent token
2411         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
2412 
2413         uint256 curTotalSupply = totalSupply();
2414         require(curTotalSupply >= amount);
2415 
2416         uint256 previousBalanceFrom = balanceOf(owner);
2417         require(previousBalanceFrom >= amount);
2418 
2419         uint256 newTotalSupply = curTotalSupply - amount;
2420         uint256 newBalanceFrom = previousBalanceFrom - amount;
2421         setValue(_totalSupplyValues, newTotalSupply);
2422         setValue(_balances[owner], newBalanceFrom);
2423 
2424         Transfer(owner, 0, amount);
2425     }
2426 }
2427 
2428 /*
2429     Copyright 2016, Jordi Baylina
2430     Copyright 2017, Remco Bloemen, Marcin Rudolf
2431 
2432     This program is free software: you can redistribute it and/or modify
2433     it under the terms of the GNU General Public License as published by
2434     the Free Software Foundation, either version 3 of the License, or
2435     (at your option) any later version.
2436 
2437     This program is distributed in the hope that it will be useful,
2438     but WITHOUT ANY WARRANTY; without even the implied warranty of
2439     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2440     GNU General Public License for more details.
2441 
2442     You should have received a copy of the GNU General Public License
2443     along with this program.  If not, see <http://www.gnu.org/licenses/>.
2444  */
2445 /// @title StandardSnapshotToken Contract
2446 /// @author Jordi Baylina, Remco Bloemen, Marcin Rudolf
2447 /// @dev This token contract's goal is to make it easy for anyone to clone this
2448 ///  token using the token distribution at a given block, this will allow DAO's
2449 ///  and DApps to upgrade their features in a decentralized manner without
2450 ///  affecting the original token
2451 /// @dev It is ERC20 compliant, but still needs to under go further testing.
2452 /// @dev Various contracts are composed to provide required functionality of this token, different compositions are possible
2453 ///     MintableSnapshotToken provides transfer, miniting and snapshotting functions
2454 ///     TokenAllowance provides approve/transferFrom functions
2455 ///     TokenMetadata adds name, symbol and other token metadata
2456 /// @dev This token is still abstract, Snapshot, BasicSnapshotToken and TokenAllowance observe interfaces that must be implemented
2457 ///     MSnapshotPolicy - particular snapshot id creation mechanism
2458 ///     MTokenController - controlls approvals and transfers
2459 ///     see Neumark as an example
2460 /// @dev implements ERC223 token transfer
2461 contract StandardSnapshotToken is
2462     IERC20Token,
2463     MintableSnapshotToken,
2464     TokenAllowance,
2465     IERC223Token,
2466     IsContract
2467 {
2468     ////////////////////////
2469     // Constructor
2470     ////////////////////////
2471 
2472     /// @notice Constructor to create a MiniMeToken
2473     ///  is a new token
2474     /// param tokenName Name of the new token
2475     /// param decimalUnits Number of decimals of the new token
2476     /// param tokenSymbol Token Symbol for the new token
2477     function StandardSnapshotToken(
2478         IClonedTokenParent parentToken,
2479         uint256 parentSnapshotId
2480     )
2481         MintableSnapshotToken(parentToken, parentSnapshotId)
2482         TokenAllowance()
2483         internal
2484     {}
2485 
2486     ////////////////////////
2487     // Public functions
2488     ////////////////////////
2489 
2490     //
2491     // Implements IERC223Token
2492     //
2493 
2494     function transfer(address to, uint256 amount, bytes data)
2495         public
2496         returns (bool)
2497     {
2498         // it is necessary to point out implementation to be called
2499         BasicSnapshotToken.mTransfer(msg.sender, to, amount);
2500 
2501         // Notify the receiving contract.
2502         if (isContract(to)) {
2503             IERC223Callback(to).onTokenTransfer(msg.sender, amount, data);
2504         }
2505         return true;
2506     }
2507 }
2508 
2509 contract Neumark is
2510     AccessControlled,
2511     AccessRoles,
2512     Agreement,
2513     DailyAndSnapshotable,
2514     StandardSnapshotToken,
2515     TokenMetadata,
2516     NeumarkIssuanceCurve,
2517     Reclaimable
2518 {
2519 
2520     ////////////////////////
2521     // Constants
2522     ////////////////////////
2523 
2524     string private constant TOKEN_NAME = "Neumark";
2525 
2526     uint8  private constant TOKEN_DECIMALS = 18;
2527 
2528     string private constant TOKEN_SYMBOL = "NEU";
2529 
2530     string private constant VERSION = "NMK_1.0";
2531 
2532     ////////////////////////
2533     // Mutable state
2534     ////////////////////////
2535 
2536     // disable transfers when Neumark is created
2537     bool private _transferEnabled = false;
2538 
2539     // at which point on curve new Neumarks will be created, see NeumarkIssuanceCurve contract
2540     // do not use to get total invested funds. see burn(). this is just a cache for expensive inverse function
2541     uint256 private _totalEurUlps;
2542 
2543     ////////////////////////
2544     // Events
2545     ////////////////////////
2546 
2547     event LogNeumarksIssued(
2548         address indexed owner,
2549         uint256 euroUlps,
2550         uint256 neumarkUlps
2551     );
2552 
2553     event LogNeumarksBurned(
2554         address indexed owner,
2555         uint256 euroUlps,
2556         uint256 neumarkUlps
2557     );
2558 
2559     ////////////////////////
2560     // Constructor
2561     ////////////////////////
2562 
2563     function Neumark(
2564         IAccessPolicy accessPolicy,
2565         IEthereumForkArbiter forkArbiter
2566     )
2567         AccessControlled(accessPolicy)
2568         AccessRoles()
2569         Agreement(accessPolicy, forkArbiter)
2570         StandardSnapshotToken(
2571             IClonedTokenParent(0x0),
2572             0
2573         )
2574         TokenMetadata(
2575             TOKEN_NAME,
2576             TOKEN_DECIMALS,
2577             TOKEN_SYMBOL,
2578             VERSION
2579         )
2580         DailyAndSnapshotable(0)
2581         NeumarkIssuanceCurve()
2582         Reclaimable()
2583         public
2584     {}
2585 
2586     ////////////////////////
2587     // Public functions
2588     ////////////////////////
2589 
2590     /// @notice issues new Neumarks to msg.sender with reward at current curve position
2591     ///     moves curve position by euroUlps
2592     ///     callable only by ROLE_NEUMARK_ISSUER
2593     function issueForEuro(uint256 euroUlps)
2594         public
2595         only(ROLE_NEUMARK_ISSUER)
2596         acceptAgreement(msg.sender)
2597         returns (uint256)
2598     {
2599         require(_totalEurUlps + euroUlps >= _totalEurUlps);
2600         uint256 neumarkUlps = incremental(_totalEurUlps, euroUlps);
2601         _totalEurUlps += euroUlps;
2602         mGenerateTokens(msg.sender, neumarkUlps);
2603         LogNeumarksIssued(msg.sender, euroUlps, neumarkUlps);
2604         return neumarkUlps;
2605     }
2606 
2607     /// @notice used by ROLE_NEUMARK_ISSUER to transer newly issued neumarks
2608     ///     typically to the investor and platform operator
2609     function distribute(address to, uint256 neumarkUlps)
2610         public
2611         only(ROLE_NEUMARK_ISSUER)
2612         acceptAgreement(to)
2613     {
2614         mTransfer(msg.sender, to, neumarkUlps);
2615     }
2616 
2617     /// @notice msg.sender can burn their Neumarks, curve is rolled back using inverse
2618     ///     curve. as a result cost of Neumark gets lower (reward is higher)
2619     function burn(uint256 neumarkUlps)
2620         public
2621         only(ROLE_NEUMARK_BURNER)
2622     {
2623         burnPrivate(neumarkUlps, 0, _totalEurUlps);
2624     }
2625 
2626     /// @notice executes as function above but allows to provide search range for low gas burning
2627     function burn(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2628         public
2629         only(ROLE_NEUMARK_BURNER)
2630     {
2631         burnPrivate(neumarkUlps, minEurUlps, maxEurUlps);
2632     }
2633 
2634     function enableTransfer(bool enabled)
2635         public
2636         only(ROLE_TRANSFER_ADMIN)
2637     {
2638         _transferEnabled = enabled;
2639     }
2640 
2641     function createSnapshot()
2642         public
2643         only(ROLE_SNAPSHOT_CREATOR)
2644         returns (uint256)
2645     {
2646         return DailyAndSnapshotable.createSnapshot();
2647     }
2648 
2649     function transferEnabled()
2650         public
2651         constant
2652         returns (bool)
2653     {
2654         return _transferEnabled;
2655     }
2656 
2657     function totalEuroUlps()
2658         public
2659         constant
2660         returns (uint256)
2661     {
2662         return _totalEurUlps;
2663     }
2664 
2665     function incremental(uint256 euroUlps)
2666         public
2667         constant
2668         returns (uint256 neumarkUlps)
2669     {
2670         return incremental(_totalEurUlps, euroUlps);
2671     }
2672 
2673     ////////////////////////
2674     // Internal functions
2675     ////////////////////////
2676 
2677     //
2678     // Implements MTokenController
2679     //
2680 
2681     function mOnTransfer(
2682         address from,
2683         address, // to
2684         uint256 // amount
2685     )
2686         internal
2687         acceptAgreement(from)
2688         returns (bool allow)
2689     {
2690         // must have transfer enabled or msg.sender is Neumark issuer
2691         return _transferEnabled || accessPolicy().allowed(msg.sender, ROLE_NEUMARK_ISSUER, this, msg.sig);
2692     }
2693 
2694     function mOnApprove(
2695         address owner,
2696         address, // spender,
2697         uint256 // amount
2698     )
2699         internal
2700         acceptAgreement(owner)
2701         returns (bool allow)
2702     {
2703         return true;
2704     }
2705 
2706     ////////////////////////
2707     // Private functions
2708     ////////////////////////
2709 
2710     function burnPrivate(uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2711         private
2712     {
2713         uint256 prevEuroUlps = _totalEurUlps;
2714         // burn first in the token to make sure balance/totalSupply is not crossed
2715         mDestroyTokens(msg.sender, burnNeumarkUlps);
2716         _totalEurUlps = cumulativeInverse(totalSupply(), minEurUlps, maxEurUlps);
2717         // actually may overflow on non-monotonic inverse
2718         assert(prevEuroUlps >= _totalEurUlps);
2719         uint256 euroUlps = prevEuroUlps - _totalEurUlps;
2720         LogNeumarksBurned(msg.sender, euroUlps, burnNeumarkUlps);
2721     }
2722 }
2723 
2724 contract TimeSource {
2725 
2726     ////////////////////////
2727     // Public functions
2728     ////////////////////////
2729 
2730     function currentTime() internal constant returns (uint256) {
2731         return block.timestamp;
2732     }
2733 }
2734 
2735 contract LockedAccount is
2736     AccessControlled,
2737     AccessRoles,
2738     TimeSource,
2739     Math,
2740     IsContract,
2741     MigrationSource,
2742     IERC677Callback,
2743     Reclaimable
2744 {
2745 
2746     ////////////////////////
2747     // Type declarations
2748     ////////////////////////
2749 
2750     // state space of LockedAccount
2751     enum LockState {
2752         // controller is not yet set
2753         Uncontrolled,
2754         // new funds lockd are accepted from investors
2755         AcceptingLocks,
2756         // funds may be unlocked by investors, final state
2757         AcceptingUnlocks,
2758         // funds may be unlocked by investors, without any constraints, final state
2759         ReleaseAll
2760     }
2761 
2762     // represents locked account of the investor
2763     struct Account {
2764         // funds locked in the account
2765         uint256 balance;
2766         // neumark amount that must be returned to unlock
2767         uint256 neumarksDue;
2768         // date with which unlock may happen without penalty
2769         uint256 unlockDate;
2770     }
2771 
2772     ////////////////////////
2773     // Immutable state
2774     ////////////////////////
2775 
2776     // a token controlled by LockedAccount, read ERC20 + extensions to read what
2777     // token is it (ETH/EUR etc.)
2778     IERC677Token private ASSET_TOKEN;
2779 
2780     Neumark private NEUMARK;
2781 
2782     // longstop period in seconds
2783     uint256 private LOCK_PERIOD;
2784 
2785     // penalty: decimalFraction of stored amount on escape hatch
2786     uint256 private PENALTY_FRACTION;
2787 
2788     ////////////////////////
2789     // Mutable state
2790     ////////////////////////
2791 
2792     // total amount of tokens locked
2793     uint256 private _totalLockedAmount;
2794 
2795     // total number of locked investors
2796     uint256 internal _totalInvestors;
2797 
2798     // current state of the locking contract
2799     LockState private _lockState;
2800 
2801     // controlling contract that may lock money or unlock all account if fails
2802     address private _controller;
2803 
2804     // fee distribution pool
2805     address private _penaltyDisbursalAddress;
2806 
2807     // LockedAccountMigration private migration;
2808     mapping(address => Account) internal _accounts;
2809 
2810     ////////////////////////
2811     // Events
2812     ////////////////////////
2813 
2814     /// @notice logged when funds are locked by investor
2815     /// @param investor address of investor locking funds
2816     /// @param amount amount of newly locked funds
2817     /// @param amount of neumarks that must be returned to unlock funds
2818     event LogFundsLocked(
2819         address indexed investor,
2820         uint256 amount,
2821         uint256 neumarks
2822     );
2823 
2824     /// @notice logged when investor unlocks funds
2825     /// @param investor address of investor unlocking funds
2826     /// @param amount amount of unlocked funds
2827     /// @param neumarks amount of Neumarks that was burned
2828     event LogFundsUnlocked(
2829         address indexed investor,
2830         uint256 amount,
2831         uint256 neumarks
2832     );
2833 
2834     /// @notice logged when unlock penalty is disbursed to Neumark holders
2835     /// @param disbursalPoolAddress address of disbursal pool receiving penalty
2836     /// @param amount penalty amount
2837     /// @param assetToken address of token contract penalty was paid with
2838     /// @param investor addres of investor paying penalty
2839     /// @dev assetToken and investor parameters are added for quick tallying penalty payouts
2840     event LogPenaltyDisbursed(
2841         address indexed disbursalPoolAddress,
2842         uint256 amount,
2843         address assetToken,
2844         address investor
2845     );
2846 
2847     /// @notice logs Locked Account state transitions
2848     event LogLockStateTransition(
2849         LockState oldState,
2850         LockState newState
2851     );
2852 
2853     event LogInvestorMigrated(
2854         address indexed investor,
2855         uint256 amount,
2856         uint256 neumarks,
2857         uint256 unlockDate
2858     );
2859 
2860     ////////////////////////
2861     // Modifiers
2862     ////////////////////////
2863 
2864     modifier onlyController() {
2865         require(msg.sender == address(_controller));
2866         _;
2867     }
2868 
2869     modifier onlyState(LockState state) {
2870         require(_lockState == state);
2871         _;
2872     }
2873 
2874     modifier onlyStates(LockState state1, LockState state2) {
2875         require(_lockState == state1 || _lockState == state2);
2876         _;
2877     }
2878 
2879     ////////////////////////
2880     // Constructor
2881     ////////////////////////
2882 
2883     /// @notice creates new LockedAccount instance
2884     /// @param policy governs execution permissions to admin functions
2885     /// @param assetToken token contract representing funds locked
2886     /// @param neumark Neumark token contract
2887     /// @param penaltyDisbursalAddress address of disbursal contract for penalty fees
2888     /// @param lockPeriod period for which funds are locked, in seconds
2889     /// @param penaltyFraction decimal fraction of unlocked amount paid as penalty,
2890     ///     if unlocked before lockPeriod is over
2891     /// @dev this implementation does not allow spending funds on ICOs but provides
2892     ///     a migration mechanism to final LockedAccount with such functionality
2893     function LockedAccount(
2894         IAccessPolicy policy,
2895         IERC677Token assetToken,
2896         Neumark neumark,
2897         address penaltyDisbursalAddress,
2898         uint256 lockPeriod,
2899         uint256 penaltyFraction
2900     )
2901         AccessControlled(policy)
2902         MigrationSource(policy, ROLE_LOCKED_ACCOUNT_ADMIN)
2903         Reclaimable()
2904         public
2905     {
2906         ASSET_TOKEN = assetToken;
2907         NEUMARK = neumark;
2908         LOCK_PERIOD = lockPeriod;
2909         PENALTY_FRACTION = penaltyFraction;
2910         _penaltyDisbursalAddress = penaltyDisbursalAddress;
2911     }
2912 
2913     ////////////////////////
2914     // Public functions
2915     ////////////////////////
2916 
2917     /// @notice locks funds of investors for a period of time
2918     /// @param investor funds owner
2919     /// @param amount amount of funds locked
2920     /// @param neumarks amount of neumarks that needs to be returned by investor to unlock funds
2921     /// @dev callable only from controller (Commitment) contract
2922     function lock(address investor, uint256 amount, uint256 neumarks)
2923         public
2924         onlyState(LockState.AcceptingLocks)
2925         onlyController()
2926     {
2927         require(amount > 0);
2928         // transfer to itself from Commitment contract allowance
2929         assert(ASSET_TOKEN.transferFrom(msg.sender, address(this), amount));
2930 
2931         Account storage account = _accounts[investor];
2932         account.balance = addBalance(account.balance, amount);
2933         account.neumarksDue = add(account.neumarksDue, neumarks);
2934 
2935         if (account.unlockDate == 0) {
2936             // this is new account - unlockDate always > 0
2937             _totalInvestors += 1;
2938             account.unlockDate = currentTime() + LOCK_PERIOD;
2939         }
2940         LogFundsLocked(investor, amount, neumarks);
2941     }
2942 
2943     /// @notice unlocks investors funds, see unlockInvestor for details
2944     /// @dev function requires that proper allowance on Neumark is made to LockedAccount by msg.sender
2945     ///     except in ReleaseAll state which does not burn Neumark
2946     function unlock()
2947         public
2948         onlyStates(LockState.AcceptingUnlocks, LockState.ReleaseAll)
2949     {
2950         unlockInvestor(msg.sender);
2951     }
2952 
2953     /// @notice unlocks investors funds, see unlockInvestor for details
2954     /// @dev this ERC667 callback by Neumark contract after successful approve
2955     ///     allows to unlock and allow neumarks to be burned in one transaction
2956     function receiveApproval(
2957         address from,
2958         uint256, // _amount,
2959         address _token,
2960         bytes _data
2961     )
2962         public
2963         onlyState(LockState.AcceptingUnlocks)
2964         returns (bool)
2965     {
2966         require(msg.sender == _token);
2967         require(_data.length == 0);
2968 
2969         // only from neumarks
2970         require(_token == address(NEUMARK));
2971 
2972         // this will check if allowance was made and if _amount is enough to
2973         //  unlock, reverts on any error condition
2974         unlockInvestor(from);
2975 
2976         // we assume external call so return value will be lost to clients
2977         // that's why we throw above
2978         return true;
2979     }
2980 
2981     /// allows to anyone to release all funds without burning Neumarks and any
2982     /// other penalties
2983     function controllerFailed()
2984         public
2985         onlyState(LockState.AcceptingLocks)
2986         onlyController()
2987     {
2988         changeState(LockState.ReleaseAll);
2989     }
2990 
2991     /// allows anyone to use escape hatch
2992     function controllerSucceeded()
2993         public
2994         onlyState(LockState.AcceptingLocks)
2995         onlyController()
2996     {
2997         changeState(LockState.AcceptingUnlocks);
2998     }
2999 
3000     function setController(address controller)
3001         public
3002         only(ROLE_LOCKED_ACCOUNT_ADMIN)
3003         onlyState(LockState.Uncontrolled)
3004     {
3005         _controller = controller;
3006         changeState(LockState.AcceptingLocks);
3007     }
3008 
3009     /// sets address to which tokens from unlock penalty are sent
3010     /// both simple addresses and contracts are allowed
3011     /// contract needs to implement ApproveAndCallCallback interface
3012     function setPenaltyDisbursal(address penaltyDisbursalAddress)
3013         public
3014         only(ROLE_LOCKED_ACCOUNT_ADMIN)
3015     {
3016         require(penaltyDisbursalAddress != address(0));
3017 
3018         // can be changed at any moment by admin
3019         _penaltyDisbursalAddress = penaltyDisbursalAddress;
3020     }
3021 
3022     function assetToken()
3023         public
3024         constant
3025         returns (IERC677Token)
3026     {
3027         return ASSET_TOKEN;
3028     }
3029 
3030     function neumark()
3031         public
3032         constant
3033         returns (Neumark)
3034     {
3035         return NEUMARK;
3036     }
3037 
3038     function lockPeriod()
3039         public
3040         constant
3041         returns (uint256)
3042     {
3043         return LOCK_PERIOD;
3044     }
3045 
3046     function penaltyFraction()
3047         public
3048         constant
3049         returns (uint256)
3050     {
3051         return PENALTY_FRACTION;
3052     }
3053 
3054     function balanceOf(address investor)
3055         public
3056         constant
3057         returns (uint256, uint256, uint256)
3058     {
3059         Account storage account = _accounts[investor];
3060         return (account.balance, account.neumarksDue, account.unlockDate);
3061     }
3062 
3063     function controller()
3064         public
3065         constant
3066         returns (address)
3067     {
3068         return _controller;
3069     }
3070 
3071     function lockState()
3072         public
3073         constant
3074         returns (LockState)
3075     {
3076         return _lockState;
3077     }
3078 
3079     function totalLockedAmount()
3080         public
3081         constant
3082         returns (uint256)
3083     {
3084         return _totalLockedAmount;
3085     }
3086 
3087     function totalInvestors()
3088         public
3089         constant
3090         returns (uint256)
3091     {
3092         return _totalInvestors;
3093     }
3094 
3095     function penaltyDisbursalAddress()
3096         public
3097         constant
3098         returns (address)
3099     {
3100         return _penaltyDisbursalAddress;
3101     }
3102 
3103     //
3104     // Overrides migration source
3105     //
3106 
3107     /// enables migration to new LockedAccount instance
3108     /// it can be set only once to prevent setting temporary migrations that let
3109     /// just one investor out
3110     /// may be set in AcceptingLocks state (in unlikely event that controller
3111     /// fails we let investors out)
3112     /// and AcceptingUnlocks - which is normal operational mode
3113     function enableMigration(IMigrationTarget migration)
3114         public
3115         onlyStates(LockState.AcceptingLocks, LockState.AcceptingUnlocks)
3116     {
3117         // will enforce other access controls
3118         MigrationSource.enableMigration(migration);
3119     }
3120 
3121     /// migrates single investor
3122     function migrate()
3123         public
3124         onlyMigrationEnabled()
3125     {
3126         // migrates
3127         Account memory account = _accounts[msg.sender];
3128 
3129         // return on non existing accounts silently
3130         if (account.balance == 0) {
3131             return;
3132         }
3133 
3134         // this will clear investor storage
3135         removeInvestor(msg.sender, account.balance);
3136 
3137         // let migration target to own asset balance that belongs to investor
3138         assert(ASSET_TOKEN.approve(address(_migration), account.balance));
3139         LockedAccountMigration(_migration).migrateInvestor(
3140             msg.sender,
3141             account.balance,
3142             account.neumarksDue,
3143             account.unlockDate
3144         );
3145         LogInvestorMigrated(msg.sender, account.balance, account.neumarksDue, account.unlockDate);
3146     }
3147 
3148     //
3149     // Overrides Reclaimable
3150     //
3151 
3152     /// @notice allows LockedAccount to reclaim tokens wrongly sent to its address
3153     /// @dev as LockedAccount by design has balance of assetToken (in the name of investors)
3154     ///     such reclamation is not allowed
3155     function reclaim(IBasicToken token)
3156         public
3157     {
3158         // forbid reclaiming locked tokens
3159         require(token != ASSET_TOKEN);
3160         Reclaimable.reclaim(token);
3161     }
3162 
3163     ////////////////////////
3164     // Internal functions
3165     ////////////////////////
3166 
3167     function addBalance(uint256 balance, uint256 amount)
3168         internal
3169         returns (uint256)
3170     {
3171         _totalLockedAmount = add(_totalLockedAmount, amount);
3172         uint256 newBalance = balance + amount;
3173         return newBalance;
3174     }
3175 
3176     ////////////////////////
3177     // Private functions
3178     ////////////////////////
3179 
3180     function subBalance(uint256 balance, uint256 amount)
3181         private
3182         returns (uint256)
3183     {
3184         _totalLockedAmount -= amount;
3185         return balance - amount;
3186     }
3187 
3188     function removeInvestor(address investor, uint256 balance)
3189         private
3190     {
3191         subBalance(balance, balance);
3192         _totalInvestors -= 1;
3193         delete _accounts[investor];
3194     }
3195 
3196     function changeState(LockState newState)
3197         private
3198     {
3199         assert(newState != _lockState);
3200         LogLockStateTransition(_lockState, newState);
3201         _lockState = newState;
3202     }
3203 
3204     /// @notice unlocks 'investor' tokens by making them withdrawable from assetToken
3205     /// @dev expects number of neumarks that is due on investor's account to be approved for LockedAccount for transfer
3206     /// @dev there are 3 unlock modes depending on contract and investor state
3207     ///     in 'AcceptingUnlocks' state Neumarks due will be burned and funds transferred to investors address in assetToken,
3208     ///         before unlockDate, penalty is deduced and distributed
3209     ///     in 'ReleaseAll' neumarks are not burned and unlockDate is not observed, funds are unlocked unconditionally
3210     function unlockInvestor(address investor)
3211         private
3212     {
3213         // use memory storage to obtain copy and be able to erase storage
3214         Account memory accountInMem = _accounts[investor];
3215 
3216         // silently return on non-existing accounts
3217         if (accountInMem.balance == 0) {
3218             return;
3219         }
3220         // remove investor account before external calls
3221         removeInvestor(investor, accountInMem.balance);
3222 
3223         // Neumark burning and penalty processing only in AcceptingUnlocks state
3224         if (_lockState == LockState.AcceptingUnlocks) {
3225             // transfer Neumarks to be burned to itself via allowance mechanism
3226             //  not enough allowance results in revert which is acceptable state so 'require' is used
3227             require(NEUMARK.transferFrom(investor, address(this), accountInMem.neumarksDue));
3228 
3229             // burn neumarks corresponding to unspent funds
3230             NEUMARK.burn(accountInMem.neumarksDue);
3231 
3232             // take the penalty if before unlockDate
3233             if (currentTime() < accountInMem.unlockDate) {
3234                 require(_penaltyDisbursalAddress != address(0));
3235                 uint256 penalty = decimalFraction(accountInMem.balance, PENALTY_FRACTION);
3236 
3237                 // distribute penalty
3238                 if (isContract(_penaltyDisbursalAddress)) {
3239                     require(
3240                         ASSET_TOKEN.approveAndCall(_penaltyDisbursalAddress,penalty, "")
3241                     );
3242                 } else {
3243                     // transfer to simple address
3244                     assert(ASSET_TOKEN.transfer(_penaltyDisbursalAddress, penalty));
3245                 }
3246                 LogPenaltyDisbursed(_penaltyDisbursalAddress, penalty, ASSET_TOKEN, investor);
3247                 accountInMem.balance -= penalty;
3248             }
3249         }
3250         if (_lockState == LockState.ReleaseAll) {
3251             accountInMem.neumarksDue = 0;
3252         }
3253         // transfer amount back to investor - now it can withdraw
3254         assert(ASSET_TOKEN.transfer(investor, accountInMem.balance));
3255         LogFundsUnlocked(investor, accountInMem.balance, accountInMem.neumarksDue);
3256     }
3257 }