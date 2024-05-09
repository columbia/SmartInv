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
158 /// @title standard access roles of the Platform
159 /// @dev constants are kept in CODE not in STORAGE so they are comparatively cheap
160 contract AccessRoles {
161 
162     ////////////////////////
163     // Constants
164     ////////////////////////
165 
166     // NOTE: All roles are set to the keccak256 hash of the
167     // CamelCased role name, i.e.
168     // ROLE_LOCKED_ACCOUNT_ADMIN = keccak256("LockedAccountAdmin")
169 
170     // May issue (generate) Neumarks
171     bytes32 internal constant ROLE_NEUMARK_ISSUER = 0x921c3afa1f1fff707a785f953a1e197bd28c9c50e300424e015953cbf120c06c;
172 
173     // May burn Neumarks it owns
174     bytes32 internal constant ROLE_NEUMARK_BURNER = 0x19ce331285f41739cd3362a3ec176edffe014311c0f8075834fdd19d6718e69f;
175 
176     // May create new snapshots on Neumark
177     bytes32 internal constant ROLE_SNAPSHOT_CREATOR = 0x08c1785afc57f933523bc52583a72ce9e19b2241354e04dd86f41f887e3d8174;
178 
179     // May enable/disable transfers on Neumark
180     bytes32 internal constant ROLE_TRANSFER_ADMIN = 0xb6527e944caca3d151b1f94e49ac5e223142694860743e66164720e034ec9b19;
181 
182     // may reclaim tokens/ether from contracts supporting IReclaimable interface
183     bytes32 internal constant ROLE_RECLAIMER = 0x0542bbd0c672578966dcc525b30aa16723bb042675554ac5b0362f86b6e97dc5;
184 
185     // represents legally platform operator in case of forks and contracts with legal agreement attached. keccak256("PlatformOperatorRepresentative")
186     bytes32 internal constant ROLE_PLATFORM_OPERATOR_REPRESENTATIVE = 0xb2b321377653f655206f71514ff9f150d0822d062a5abcf220d549e1da7999f0;
187 
188     // allows to deposit EUR-T and allow addresses to send and receive EUR-T. keccak256("EurtDepositManager")
189     bytes32 internal constant ROLE_EURT_DEPOSIT_MANAGER = 0x7c8ecdcba80ce87848d16ad77ef57cc196c208fc95c5638e4a48c681a34d4fe7;
190 
191     // allows to register identities and change associated claims keccak256("IdentityManager")
192     bytes32 internal constant ROLE_IDENTITY_MANAGER = 0x32964e6bc50f2aaab2094a1d311be8bda920fc4fb32b2fb054917bdb153a9e9e;
193 
194     // allows to replace controller on euro token and to destroy tokens without withdraw kecckak256("EurtLegalManager")
195     bytes32 internal constant ROLE_EURT_LEGAL_MANAGER = 0x4eb6b5806954a48eb5659c9e3982d5e75bfb2913f55199877d877f157bcc5a9b;
196 
197     // allows to change known interfaces in universe kecckak256("UniverseManager")
198     bytes32 internal constant ROLE_UNIVERSE_MANAGER = 0xe8d8f8f9ea4b19a5a4368dbdace17ad71a69aadeb6250e54c7b4c7b446301738;
199 
200     // allows to exchange gas for EUR-T keccak("GasExchange")
201     bytes32 internal constant ROLE_GAS_EXCHANGE = 0x9fe43636e0675246c99e96d7abf9f858f518b9442c35166d87f0934abef8a969;
202 
203     // allows to set token exchange rates keccak("TokenRateOracle")
204     bytes32 internal constant ROLE_TOKEN_RATE_ORACLE = 0xa80c3a0c8a5324136e4c806a778583a2a980f378bdd382921b8d28dcfe965585;
205 }
206 
207 contract IBasicToken {
208 
209     ////////////////////////
210     // Events
211     ////////////////////////
212 
213     event Transfer(
214         address indexed from,
215         address indexed to,
216         uint256 amount
217     );
218 
219     ////////////////////////
220     // Public functions
221     ////////////////////////
222 
223     /// @dev This function makes it easy to get the total number of tokens
224     /// @return The total number of tokens
225     function totalSupply()
226         public
227         constant
228         returns (uint256);
229 
230     /// @param owner The address that's balance is being requested
231     /// @return The balance of `owner` at the current block
232     function balanceOf(address owner)
233         public
234         constant
235         returns (uint256 balance);
236 
237     /// @notice Send `amount` tokens to `to` from `msg.sender`
238     /// @param to The address of the recipient
239     /// @param amount The amount of tokens to be transferred
240     /// @return Whether the transfer was successful or not
241     function transfer(address to, uint256 amount)
242         public
243         returns (bool success);
244 
245 }
246 
247 /// @title allows deriving contract to recover any token or ether that it has balance of
248 /// @notice note that this opens your contracts to claims from various people saying they lost tokens and they want them back
249 ///     be ready to handle such claims
250 /// @dev use with care!
251 ///     1. ROLE_RECLAIMER is allowed to claim tokens, it's not returning tokens to original owner
252 ///     2. in derived contract that holds any token by design you must override `reclaim` and block such possibility.
253 ///         see ICBMLockedAccount as an example
254 contract Reclaimable is AccessControlled, AccessRoles {
255 
256     ////////////////////////
257     // Constants
258     ////////////////////////
259 
260     IBasicToken constant internal RECLAIM_ETHER = IBasicToken(0x0);
261 
262     ////////////////////////
263     // Public functions
264     ////////////////////////
265 
266     function reclaim(IBasicToken token)
267         public
268         only(ROLE_RECLAIMER)
269     {
270         address reclaimer = msg.sender;
271         if(token == RECLAIM_ETHER) {
272             reclaimer.transfer(address(this).balance);
273         } else {
274             uint256 balance = token.balanceOf(this);
275             require(token.transfer(reclaimer, balance));
276         }
277     }
278 }
279 
280 contract ITokenMetadata {
281 
282     ////////////////////////
283     // Public functions
284     ////////////////////////
285 
286     function symbol()
287         public
288         constant
289         returns (string);
290 
291     function name()
292         public
293         constant
294         returns (string);
295 
296     function decimals()
297         public
298         constant
299         returns (uint8);
300 }
301 
302 /// @title adds token metadata to token contract
303 /// @dev see Neumark for example implementation
304 contract TokenMetadata is ITokenMetadata {
305 
306     ////////////////////////
307     // Immutable state
308     ////////////////////////
309 
310     // The Token's name: e.g. DigixDAO Tokens
311     string private NAME;
312 
313     // An identifier: e.g. REP
314     string private SYMBOL;
315 
316     // Number of decimals of the smallest unit
317     uint8 private DECIMALS;
318 
319     // An arbitrary versioning scheme
320     string private VERSION;
321 
322     ////////////////////////
323     // Constructor
324     ////////////////////////
325 
326     /// @notice Constructor to set metadata
327     /// @param tokenName Name of the new token
328     /// @param decimalUnits Number of decimals of the new token
329     /// @param tokenSymbol Token Symbol for the new token
330     /// @param version Token version ie. when cloning is used
331     constructor(
332         string tokenName,
333         uint8 decimalUnits,
334         string tokenSymbol,
335         string version
336     )
337         public
338     {
339         NAME = tokenName;                                 // Set the name
340         SYMBOL = tokenSymbol;                             // Set the symbol
341         DECIMALS = decimalUnits;                          // Set the decimals
342         VERSION = version;
343     }
344 
345     ////////////////////////
346     // Public functions
347     ////////////////////////
348 
349     function name()
350         public
351         constant
352         returns (string)
353     {
354         return NAME;
355     }
356 
357     function symbol()
358         public
359         constant
360         returns (string)
361     {
362         return SYMBOL;
363     }
364 
365     function decimals()
366         public
367         constant
368         returns (uint8)
369     {
370         return DECIMALS;
371     }
372 
373     function version()
374         public
375         constant
376         returns (string)
377     {
378         return VERSION;
379     }
380 }
381 
382 /// @title controls spending approvals
383 /// @dev TokenAllowance observes this interface, Neumark contract implements it
384 contract MTokenAllowanceController {
385 
386     ////////////////////////
387     // Internal functions
388     ////////////////////////
389 
390     /// @notice Notifies the controller about an approval allowing the
391     ///  controller to react if desired
392     /// @param owner The address that calls `approve()`
393     /// @param spender The spender in the `approve()` call
394     /// @param amount The amount in the `approve()` call
395     /// @return False if the controller does not authorize the approval
396     function mOnApprove(
397         address owner,
398         address spender,
399         uint256 amount
400     )
401         internal
402         returns (bool allow);
403 
404     /// @notice Allows to override allowance approved by the owner
405     ///         Primary role is to enable forced transfers, do not override if you do not like it
406     ///         Following behavior is expected in the observer
407     ///         approve() - should revert if mAllowanceOverride() > 0
408     ///         allowance() - should return mAllowanceOverride() if set
409     ///         transferFrom() - should override allowance if mAllowanceOverride() > 0
410     /// @param owner An address giving allowance to spender
411     /// @param spender An address getting  a right to transfer allowance amount from the owner
412     /// @return current allowance amount
413     function mAllowanceOverride(
414         address owner,
415         address spender
416     )
417         internal
418         constant
419         returns (uint256 allowance);
420 }
421 
422 /// @title controls token transfers
423 /// @dev BasicSnapshotToken observes this interface, Neumark contract implements it
424 contract MTokenTransferController {
425 
426     ////////////////////////
427     // Internal functions
428     ////////////////////////
429 
430     /// @notice Notifies the controller about a token transfer allowing the
431     ///  controller to react if desired
432     /// @param from The origin of the transfer
433     /// @param to The destination of the transfer
434     /// @param amount The amount of the transfer
435     /// @return False if the controller does not authorize the transfer
436     function mOnTransfer(
437         address from,
438         address to,
439         uint256 amount
440     )
441         internal
442         returns (bool allow);
443 
444 }
445 
446 /// @title controls approvals and transfers
447 /// @dev The token controller contract must implement these functions, see Neumark as example
448 /// @dev please note that controller may be a separate contract that is called from mOnTransfer and mOnApprove functions
449 contract MTokenController is MTokenTransferController, MTokenAllowanceController {
450 }
451 
452 contract TrustlessTokenController is
453     MTokenController
454 {
455     ////////////////////////
456     // Internal functions
457     ////////////////////////
458 
459     //
460     // Implements MTokenController
461     //
462 
463     function mOnTransfer(
464         address /*from*/,
465         address /*to*/,
466         uint256 /*amount*/
467     )
468         internal
469         returns (bool allow)
470     {
471         return true;
472     }
473 
474     function mOnApprove(
475         address /*owner*/,
476         address /*spender*/,
477         uint256 /*amount*/
478     )
479         internal
480         returns (bool allow)
481     {
482         return true;
483     }
484 }
485 
486 contract IERC20Allowance {
487 
488     ////////////////////////
489     // Events
490     ////////////////////////
491 
492     event Approval(
493         address indexed owner,
494         address indexed spender,
495         uint256 amount
496     );
497 
498     ////////////////////////
499     // Public functions
500     ////////////////////////
501 
502     /// @dev This function makes it easy to read the `allowed[]` map
503     /// @param owner The address of the account that owns the token
504     /// @param spender The address of the account able to transfer the tokens
505     /// @return Amount of remaining tokens of owner that spender is allowed
506     ///  to spend
507     function allowance(address owner, address spender)
508         public
509         constant
510         returns (uint256 remaining);
511 
512     /// @notice `msg.sender` approves `spender` to spend `amount` tokens on
513     ///  its behalf. This is a modified version of the ERC20 approve function
514     ///  to be a little bit safer
515     /// @param spender The address of the account able to transfer the tokens
516     /// @param amount The amount of tokens to be approved for transfer
517     /// @return True if the approval was successful
518     function approve(address spender, uint256 amount)
519         public
520         returns (bool success);
521 
522     /// @notice Send `amount` tokens to `to` from `from` on the condition it
523     ///  is approved by `from`
524     /// @param from The address holding the tokens being transferred
525     /// @param to The address of the recipient
526     /// @param amount The amount of tokens to be transferred
527     /// @return True if the transfer was successful
528     function transferFrom(address from, address to, uint256 amount)
529         public
530         returns (bool success);
531 
532 }
533 
534 contract IERC20Token is IBasicToken, IERC20Allowance {
535 
536 }
537 
538 contract IERC677Callback {
539 
540     ////////////////////////
541     // Public functions
542     ////////////////////////
543 
544     // NOTE: This call can be initiated by anyone. You need to make sure that
545     // it is send by the token (`require(msg.sender == token)`) or make sure
546     // amount is valid (`require(token.allowance(this) >= amount)`).
547     function receiveApproval(
548         address from,
549         uint256 amount,
550         address token, // IERC667Token
551         bytes data
552     )
553         public
554         returns (bool success);
555 
556 }
557 
558 contract IERC677Allowance is IERC20Allowance {
559 
560     ////////////////////////
561     // Public functions
562     ////////////////////////
563 
564     /// @notice `msg.sender` approves `spender` to send `amount` tokens on
565     ///  its behalf, and then a function is triggered in the contract that is
566     ///  being approved, `spender`. This allows users to use their tokens to
567     ///  interact with contracts in one function call instead of two
568     /// @param spender The address of the contract able to transfer the tokens
569     /// @param amount The amount of tokens to be approved for transfer
570     /// @return True if the function call was successful
571     function approveAndCall(address spender, uint256 amount, bytes extraData)
572         public
573         returns (bool success);
574 
575 }
576 
577 contract IERC677Token is IERC20Token, IERC677Allowance {
578 }
579 
580 contract Math {
581 
582     ////////////////////////
583     // Internal functions
584     ////////////////////////
585 
586     // absolute difference: |v1 - v2|
587     function absDiff(uint256 v1, uint256 v2)
588         internal
589         pure
590         returns(uint256)
591     {
592         return v1 > v2 ? v1 - v2 : v2 - v1;
593     }
594 
595     // divide v by d, round up if remainder is 0.5 or more
596     function divRound(uint256 v, uint256 d)
597         internal
598         pure
599         returns(uint256)
600     {
601         return add(v, d/2) / d;
602     }
603 
604     // computes decimal decimalFraction 'frac' of 'amount' with maximum precision (multiplication first)
605     // both amount and decimalFraction must have 18 decimals precision, frac 10**18 represents a whole (100% of) amount
606     // mind loss of precision as decimal fractions do not have finite binary expansion
607     // do not use instead of division
608     function decimalFraction(uint256 amount, uint256 frac)
609         internal
610         pure
611         returns(uint256)
612     {
613         // it's like 1 ether is 100% proportion
614         return proportion(amount, frac, 10**18);
615     }
616 
617     // computes part/total of amount with maximum precision (multiplication first)
618     // part and total must have the same units
619     function proportion(uint256 amount, uint256 part, uint256 total)
620         internal
621         pure
622         returns(uint256)
623     {
624         return divRound(mul(amount, part), total);
625     }
626 
627     //
628     // Open Zeppelin Math library below
629     //
630 
631     function mul(uint256 a, uint256 b)
632         internal
633         pure
634         returns (uint256)
635     {
636         uint256 c = a * b;
637         assert(a == 0 || c / a == b);
638         return c;
639     }
640 
641     function sub(uint256 a, uint256 b)
642         internal
643         pure
644         returns (uint256)
645     {
646         assert(b <= a);
647         return a - b;
648     }
649 
650     function add(uint256 a, uint256 b)
651         internal
652         pure
653         returns (uint256)
654     {
655         uint256 c = a + b;
656         assert(c >= a);
657         return c;
658     }
659 
660     function min(uint256 a, uint256 b)
661         internal
662         pure
663         returns (uint256)
664     {
665         return a < b ? a : b;
666     }
667 
668     function max(uint256 a, uint256 b)
669         internal
670         pure
671         returns (uint256)
672     {
673         return a > b ? a : b;
674     }
675 }
676 
677 /// @title internal token transfer function
678 /// @dev see BasicSnapshotToken for implementation
679 contract MTokenTransfer {
680 
681     ////////////////////////
682     // Internal functions
683     ////////////////////////
684 
685     /// @dev This is the actual transfer function in the token contract, it can
686     ///  only be called by other functions in this contract.
687     /// @param from The address holding the tokens being transferred
688     /// @param to The address of the recipient
689     /// @param amount The amount of tokens to be transferred
690     /// @dev  reverts if transfer was not successful
691     function mTransfer(
692         address from,
693         address to,
694         uint256 amount
695     )
696         internal;
697 }
698 
699 /**
700  * @title Basic token
701  * @dev Basic version of StandardToken, with no allowances.
702  */
703 contract BasicToken is
704     MTokenTransfer,
705     MTokenTransferController,
706     IBasicToken,
707     Math
708 {
709 
710     ////////////////////////
711     // Mutable state
712     ////////////////////////
713 
714     mapping(address => uint256) internal _balances;
715 
716     uint256 internal _totalSupply;
717 
718     ////////////////////////
719     // Public functions
720     ////////////////////////
721 
722     /**
723     * @dev transfer token for a specified address
724     * @param to The address to transfer to.
725     * @param amount The amount to be transferred.
726     */
727     function transfer(address to, uint256 amount)
728         public
729         returns (bool)
730     {
731         mTransfer(msg.sender, to, amount);
732         return true;
733     }
734 
735     /// @dev This function makes it easy to get the total number of tokens
736     /// @return The total number of tokens
737     function totalSupply()
738         public
739         constant
740         returns (uint256)
741     {
742         return _totalSupply;
743     }
744 
745     /**
746     * @dev Gets the balance of the specified address.
747     * @param owner The address to query the the balance of.
748     * @return An uint256 representing the amount owned by the passed address.
749     */
750     function balanceOf(address owner)
751         public
752         constant
753         returns (uint256 balance)
754     {
755         return _balances[owner];
756     }
757 
758     ////////////////////////
759     // Internal functions
760     ////////////////////////
761 
762     //
763     // Implements MTokenTransfer
764     //
765 
766     function mTransfer(address from, address to, uint256 amount)
767         internal
768     {
769         require(to != address(0));
770         require(mOnTransfer(from, to, amount));
771 
772         _balances[from] = sub(_balances[from], amount);
773         _balances[to] = add(_balances[to], amount);
774         emit Transfer(from, to, amount);
775     }
776 }
777 
778 /// @title token spending approval and transfer
779 /// @dev implements token approval and transfers and exposes relevant part of ERC20 and ERC677 approveAndCall
780 ///     may be mixed in with any basic token (implementing mTransfer) like BasicSnapshotToken or MintableSnapshotToken to add approval mechanism
781 ///     observes MTokenAllowanceController interface
782 ///     observes MTokenTransfer
783 contract TokenAllowance is
784     MTokenTransfer,
785     MTokenAllowanceController,
786     IERC20Allowance,
787     IERC677Token
788 {
789 
790     ////////////////////////
791     // Mutable state
792     ////////////////////////
793 
794     // `allowed` tracks rights to spends others tokens as per ERC20
795     // owner => spender => amount
796     mapping (address => mapping (address => uint256)) private _allowed;
797 
798     ////////////////////////
799     // Constructor
800     ////////////////////////
801 
802     constructor()
803         internal
804     {
805     }
806 
807     ////////////////////////
808     // Public functions
809     ////////////////////////
810 
811     //
812     // Implements IERC20Token
813     //
814 
815     /// @dev This function makes it easy to read the `allowed[]` map
816     /// @param owner The address of the account that owns the token
817     /// @param spender The address of the account able to transfer the tokens
818     /// @return Amount of remaining tokens of _owner that _spender is allowed
819     ///  to spend
820     function allowance(address owner, address spender)
821         public
822         constant
823         returns (uint256 remaining)
824     {
825         uint256 override = mAllowanceOverride(owner, spender);
826         if (override > 0) {
827             return override;
828         }
829         return _allowed[owner][spender];
830     }
831 
832     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
833     ///  its behalf. This is a modified version of the ERC20 approve function
834     ///  where allowance per spender must be 0 to allow change of such allowance
835     /// @param spender The address of the account able to transfer the tokens
836     /// @param amount The amount of tokens to be approved for transfer
837     /// @return True or reverts, False is never returned
838     function approve(address spender, uint256 amount)
839         public
840         returns (bool success)
841     {
842         // Alerts the token controller of the approve function call
843         require(mOnApprove(msg.sender, spender, amount));
844 
845         // To change the approve amount you first have to reduce the addresses`
846         //  allowance to zero by calling `approve(_spender,0)` if it is not
847         //  already 0 to mitigate the race condition described here:
848         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
849         require((amount == 0 || _allowed[msg.sender][spender] == 0) && mAllowanceOverride(msg.sender, spender) == 0);
850 
851         _allowed[msg.sender][spender] = amount;
852         emit Approval(msg.sender, spender, amount);
853         return true;
854     }
855 
856     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
857     ///  is approved by `_from`
858     /// @param from The address holding the tokens being transferred
859     /// @param to The address of the recipient
860     /// @param amount The amount of tokens to be transferred
861     /// @return True if the transfer was successful, reverts in any other case
862     function transferFrom(address from, address to, uint256 amount)
863         public
864         returns (bool success)
865     {
866         uint256 allowed = mAllowanceOverride(from, msg.sender);
867         if (allowed == 0) {
868             // The standard ERC 20 transferFrom functionality
869             allowed = _allowed[from][msg.sender];
870             // yes this will underflow but then we'll revert. will cost gas however so don't underflow
871             _allowed[from][msg.sender] -= amount;
872         }
873         require(allowed >= amount);
874         mTransfer(from, to, amount);
875         return true;
876     }
877 
878     //
879     // Implements IERC677Token
880     //
881 
882     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
883     ///  its behalf, and then a function is triggered in the contract that is
884     ///  being approved, `_spender`. This allows users to use their tokens to
885     ///  interact with contracts in one function call instead of two
886     /// @param spender The address of the contract able to transfer the tokens
887     /// @param amount The amount of tokens to be approved for transfer
888     /// @return True or reverts, False is never returned
889     function approveAndCall(
890         address spender,
891         uint256 amount,
892         bytes extraData
893     )
894         public
895         returns (bool success)
896     {
897         require(approve(spender, amount));
898 
899         success = IERC677Callback(spender).receiveApproval(
900             msg.sender,
901             amount,
902             this,
903             extraData
904         );
905         require(success);
906 
907         return true;
908     }
909 
910     ////////////////////////
911     // Internal functions
912     ////////////////////////
913 
914     //
915     // Implements default MTokenAllowanceController
916     //
917 
918     // no override in default implementation
919     function mAllowanceOverride(
920         address /*owner*/,
921         address /*spender*/
922     )
923         internal
924         constant
925         returns (uint256)
926     {
927         return 0;
928     }
929 }
930 
931 /**
932  * @title Standard ERC20 token
933  *
934  * @dev Implementation of the standard token.
935  * @dev https://github.com/ethereum/EIPs/issues/20
936  */
937 contract StandardToken is
938     IERC20Token,
939     BasicToken,
940     TokenAllowance
941 {
942 
943 }
944 
945 /// @title uniquely identifies deployable (non-abstract) platform contract
946 /// @notice cheap way of assigning implementations to knownInterfaces which represent system services
947 ///         unfortunatelly ERC165 does not include full public interface (ABI) and does not provide way to list implemented interfaces
948 ///         EIP820 still in the making
949 /// @dev ids are generated as follows keccak256("neufund-platform:<contract name>")
950 ///      ids roughly correspond to ABIs
951 contract IContractId {
952     /// @param id defined as above
953     /// @param version implementation version
954     function contractId() public pure returns (bytes32 id, uint256 version);
955 }
956 
957 /// @title current ERC223 fallback function
958 /// @dev to be used in all future token contract
959 /// @dev NEU and ICBMEtherToken (obsolete) are the only contracts that still uses IERC223LegacyCallback
960 contract IERC223Callback {
961 
962     ////////////////////////
963     // Public functions
964     ////////////////////////
965 
966     function tokenFallback(address from, uint256 amount, bytes data)
967         public;
968 
969 }
970 
971 contract IERC223Token is IERC20Token, ITokenMetadata {
972 
973     /// @dev Departure: We do not log data, it has no advantage over a standard
974     ///     log event. By sticking to the standard log event we
975     ///     stay compatible with constracts that expect and ERC20 token.
976 
977     // event Transfer(
978     //    address indexed from,
979     //    address indexed to,
980     //    uint256 amount,
981     //    bytes data);
982 
983 
984     /// @dev Departure: We do not use the callback on regular transfer calls to
985     ///     stay compatible with constracts that expect and ERC20 token.
986 
987     // function transfer(address to, uint256 amount)
988     //     public
989     //     returns (bool);
990 
991     ////////////////////////
992     // Public functions
993     ////////////////////////
994 
995     function transfer(address to, uint256 amount, bytes data)
996         public
997         returns (bool);
998 }
999 
1000 contract IWithdrawableToken {
1001 
1002     ////////////////////////
1003     // Public functions
1004     ////////////////////////
1005 
1006     /// @notice withdraws from a token holding assets
1007     /// @dev amount of asset should be returned to msg.sender and corresponding balance burned
1008     function withdraw(uint256 amount)
1009         public;
1010 }
1011 
1012 contract EtherToken is
1013     IsContract,
1014     IContractId,
1015     AccessControlled,
1016     StandardToken,
1017     TrustlessTokenController,
1018     IWithdrawableToken,
1019     TokenMetadata,
1020     IERC223Token,
1021     Reclaimable
1022 {
1023     ////////////////////////
1024     // Constants
1025     ////////////////////////
1026 
1027     string private constant NAME = "Ether Token";
1028 
1029     string private constant SYMBOL = "ETH-T";
1030 
1031     uint8 private constant DECIMALS = 18;
1032 
1033     ////////////////////////
1034     // Events
1035     ////////////////////////
1036 
1037     event LogDeposit(
1038         address indexed to,
1039         uint256 amount
1040     );
1041 
1042     event LogWithdrawal(
1043         address indexed from,
1044         uint256 amount
1045     );
1046 
1047     event LogWithdrawAndSend(
1048         address indexed from,
1049         address indexed to,
1050         uint256 amount
1051     );
1052 
1053     ////////////////////////
1054     // Constructor
1055     ////////////////////////
1056 
1057     constructor(IAccessPolicy accessPolicy)
1058         AccessControlled(accessPolicy)
1059         StandardToken()
1060         TokenMetadata(NAME, DECIMALS, SYMBOL, "")
1061         Reclaimable()
1062         public
1063     {
1064     }
1065 
1066     ////////////////////////
1067     // Public functions
1068     ////////////////////////
1069 
1070     /// deposit msg.value of Ether to msg.sender balance
1071     function deposit()
1072         public
1073         payable
1074     {
1075         depositPrivate();
1076         emit Transfer(address(0), msg.sender, msg.value);
1077     }
1078 
1079     /// @notice convenience function to deposit and immediately transfer amount
1080     /// @param transferTo where to transfer after deposit
1081     /// @param amount total amount to transfer, must be <= balance after deposit
1082     /// @param data erc223 data
1083     /// @dev intended to deposit from simple account and invest in ETO
1084     function depositAndTransfer(address transferTo, uint256 amount, bytes data)
1085         public
1086         payable
1087     {
1088         depositPrivate();
1089         transfer(transferTo, amount, data);
1090     }
1091 
1092     /// withdraws and sends 'amount' of ether to msg.sender
1093     function withdraw(uint256 amount)
1094         public
1095     {
1096         withdrawPrivate(amount);
1097         msg.sender.transfer(amount);
1098     }
1099 
1100     /// @notice convenience function to withdraw and transfer to external account
1101     /// @param sendTo address to which send total amount
1102     /// @param amount total amount to withdraw and send
1103     /// @dev function is payable and is meant to withdraw funds on accounts balance and token in single transaction
1104     /// @dev BEWARE that msg.sender of the funds is Ether Token contract and not simple account calling it.
1105     /// @dev  when sent to smart conctract funds may be lost, so this is prevented below
1106     function withdrawAndSend(address sendTo, uint256 amount)
1107         public
1108         payable
1109     {
1110         // must send at least what is in msg.value to being another deposit function
1111         require(amount >= msg.value, "NF_ET_NO_DEPOSIT");
1112         if (amount > msg.value) {
1113             uint256 withdrawRemainder = amount - msg.value;
1114             withdrawPrivate(withdrawRemainder);
1115         }
1116         emit LogWithdrawAndSend(msg.sender, sendTo, amount);
1117         sendTo.transfer(amount);
1118     }
1119 
1120     //
1121     // Implements IERC223Token
1122     //
1123 
1124     function transfer(address to, uint256 amount, bytes data)
1125         public
1126         returns (bool)
1127     {
1128         BasicToken.mTransfer(msg.sender, to, amount);
1129 
1130         // Notify the receiving contract.
1131         if (isContract(to)) {
1132             // in case of re-entry (1) transfer is done (2) msg.sender is different
1133             IERC223Callback(to).tokenFallback(msg.sender, amount, data);
1134         }
1135         return true;
1136     }
1137 
1138     //
1139     // Overrides Reclaimable
1140     //
1141 
1142     /// @notice allows EtherToken to reclaim tokens wrongly sent to its address
1143     /// @dev as EtherToken by design has balance of Ether (native Ethereum token)
1144     ///     such reclamation is not allowed
1145     function reclaim(IBasicToken token)
1146         public
1147     {
1148         // forbid reclaiming ETH hold in this contract.
1149         require(token != RECLAIM_ETHER);
1150         Reclaimable.reclaim(token);
1151     }
1152 
1153     //
1154     // Implements IContractId
1155     //
1156 
1157     function contractId() public pure returns (bytes32 id, uint256 version) {
1158         return (0x75b86bc24f77738576716a36431588ae768d80d077231d1661c2bea674c6373a, 0);
1159     }
1160 
1161 
1162     ////////////////////////
1163     // Private functions
1164     ////////////////////////
1165 
1166     function depositPrivate()
1167         private
1168     {
1169         _balances[msg.sender] = add(_balances[msg.sender], msg.value);
1170         _totalSupply = add(_totalSupply, msg.value);
1171         emit LogDeposit(msg.sender, msg.value);
1172     }
1173 
1174     function withdrawPrivate(uint256 amount)
1175         private
1176     {
1177         require(_balances[msg.sender] >= amount);
1178         _balances[msg.sender] = sub(_balances[msg.sender], amount);
1179         _totalSupply = sub(_totalSupply, amount);
1180         emit LogWithdrawal(msg.sender, amount);
1181         emit Transfer(msg.sender, address(0), amount);
1182     }
1183 }