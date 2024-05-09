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
140 contract IsContract {
141 
142     ////////////////////////
143     // Internal functions
144     ////////////////////////
145 
146     function isContract(address addr)
147         internal
148         constant
149         returns (bool)
150     {
151         uint256 size;
152         // takes 700 gas
153         assembly { size := extcodesize(addr) }
154         return size > 0;
155     }
156 }
157 
158 contract AccessRoles {
159 
160     ////////////////////////
161     // Constants
162     ////////////////////////
163 
164     // NOTE: All roles are set to the keccak256 hash of the
165     // CamelCased role name, i.e.
166     // ROLE_LOCKED_ACCOUNT_ADMIN = keccak256("LockedAccountAdmin")
167 
168     // may setup LockedAccount, change disbursal mechanism and set migration
169     bytes32 internal constant ROLE_LOCKED_ACCOUNT_ADMIN = 0x4675da546d2d92c5b86c4f726a9e61010dce91cccc2491ce6019e78b09d2572e;
170 
171     // may setup whitelists and abort whitelisting contract with curve rollback
172     bytes32 internal constant ROLE_WHITELIST_ADMIN = 0xaef456e7c864418e1d2a40d996ca4febf3a7e317fe3af5a7ea4dda59033bbe5c;
173 
174     // May issue (generate) Neumarks
175     bytes32 internal constant ROLE_NEUMARK_ISSUER = 0x921c3afa1f1fff707a785f953a1e197bd28c9c50e300424e015953cbf120c06c;
176 
177     // May burn Neumarks it owns
178     bytes32 internal constant ROLE_NEUMARK_BURNER = 0x19ce331285f41739cd3362a3ec176edffe014311c0f8075834fdd19d6718e69f;
179 
180     // May create new snapshots on Neumark
181     bytes32 internal constant ROLE_SNAPSHOT_CREATOR = 0x08c1785afc57f933523bc52583a72ce9e19b2241354e04dd86f41f887e3d8174;
182 
183     // May enable/disable transfers on Neumark
184     bytes32 internal constant ROLE_TRANSFER_ADMIN = 0xb6527e944caca3d151b1f94e49ac5e223142694860743e66164720e034ec9b19;
185 
186     // may reclaim tokens/ether from contracts supporting IReclaimable interface
187     bytes32 internal constant ROLE_RECLAIMER = 0x0542bbd0c672578966dcc525b30aa16723bb042675554ac5b0362f86b6e97dc5;
188 
189     // represents legally platform operator in case of forks and contracts with legal agreement attached. keccak256("PlatformOperatorRepresentative")
190     bytes32 internal constant ROLE_PLATFORM_OPERATOR_REPRESENTATIVE = 0xb2b321377653f655206f71514ff9f150d0822d062a5abcf220d549e1da7999f0;
191 
192     // allows to deposit EUR-T and allow addresses to send and receive EUR-T. keccak256("EurtDepositManager")
193     bytes32 internal constant ROLE_EURT_DEPOSIT_MANAGER = 0x7c8ecdcba80ce87848d16ad77ef57cc196c208fc95c5638e4a48c681a34d4fe7;
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