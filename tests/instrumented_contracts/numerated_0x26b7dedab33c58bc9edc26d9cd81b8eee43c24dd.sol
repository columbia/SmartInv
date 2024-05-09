1 pragma solidity 0.4.25;
2 
3 /// @title makes modern ERC223 contracts compatible with the legacy implementation
4 /// @dev should be used for all receivers of tokens sent by ICBMEtherToken and NEU
5 contract ERC223LegacyCallbackCompat {
6 
7     ////////////////////////
8     // Public functions
9     ////////////////////////
10 
11     function onTokenTransfer(address wallet, uint256 amount, bytes data)
12         public
13     {
14         tokenFallback(wallet, amount, data);
15     }
16 
17     function tokenFallback(address wallet, uint256 amount, bytes data)
18         public;
19 
20 }
21 
22 /// @title known contracts of the platform
23 /// should be returned by contractId() method of IContradId.sol. caluclated like so: keccak256("neufund-platform:Neumark")
24 /// @dev constants are kept in CODE not in STORAGE so they are comparatively cheap
25 contract KnownContracts {
26 
27     ////////////////////////
28     // Constants
29     ////////////////////////
30 
31     // keccak256("neufund-platform:FeeDisbursalController")
32     bytes32 internal constant FEE_DISBURSAL_CONTROLLER = 0xfc72936b568fd5fc632b76e8feac0b717b4db1fce26a1b3b623b7fb6149bd8ae;
33 
34 }
35 
36 /// @title known interfaces (services) of the platform
37 /// "known interface" is a unique id of service provided by the platform and discovered via Universe contract
38 ///  it does not refer to particular contract/interface ABI, particular service may be delivered via different implementations
39 ///  however for a few contracts we commit platform to particular implementation (all ICBM Contracts, Universe itself etc.)
40 /// @dev constants are kept in CODE not in STORAGE so they are comparatively cheap
41 contract KnownInterfaces {
42 
43     ////////////////////////
44     // Constants
45     ////////////////////////
46 
47     // NOTE: All interface are set to the keccak256 hash of the
48     // CamelCased interface or singleton name, i.e.
49     // KNOWN_INTERFACE_NEUMARK = keccak256("Neumark")
50 
51     // EIP 165 + EIP 820 should be use instead but it seems they are far from finished
52     // also interface signature should be build automatically by solidity. otherwise it is a pure hassle
53 
54     // neumark token interface and sigleton keccak256("Neumark")
55     bytes4 internal constant KNOWN_INTERFACE_NEUMARK = 0xeb41a1bd;
56 
57     // ether token interface and singleton keccak256("EtherToken")
58     bytes4 internal constant KNOWN_INTERFACE_ETHER_TOKEN = 0x8cf73cf1;
59 
60     // euro token interface and singleton keccak256("EuroToken")
61     bytes4 internal constant KNOWN_INTERFACE_EURO_TOKEN = 0x83c3790b;
62 
63     // identity registry interface and singleton keccak256("IIdentityRegistry")
64     bytes4 internal constant KNOWN_INTERFACE_IDENTITY_REGISTRY = 0x0a72e073;
65 
66     // currency rates oracle interface and singleton keccak256("ITokenExchangeRateOracle")
67     bytes4 internal constant KNOWN_INTERFACE_TOKEN_EXCHANGE_RATE_ORACLE = 0xc6e5349e;
68 
69     // fee disbursal interface and singleton keccak256("IFeeDisbursal")
70     bytes4 internal constant KNOWN_INTERFACE_FEE_DISBURSAL = 0xf4c848e8;
71 
72     // platform portfolio holding equity tokens belonging to NEU holders keccak256("IPlatformPortfolio");
73     bytes4 internal constant KNOWN_INTERFACE_PLATFORM_PORTFOLIO = 0xaa1590d0;
74 
75     // token exchange interface and singleton keccak256("ITokenExchange")
76     bytes4 internal constant KNOWN_INTERFACE_TOKEN_EXCHANGE = 0xddd7a521;
77 
78     // service exchanging euro token for gas ("IGasTokenExchange")
79     bytes4 internal constant KNOWN_INTERFACE_GAS_EXCHANGE = 0x89dbc6de;
80 
81     // access policy interface and singleton keccak256("IAccessPolicy")
82     bytes4 internal constant KNOWN_INTERFACE_ACCESS_POLICY = 0xb05049d9;
83 
84     // euro lock account (upgraded) keccak256("LockedAccount:Euro")
85     bytes4 internal constant KNOWN_INTERFACE_EURO_LOCK = 0x2347a19e;
86 
87     // ether lock account (upgraded) keccak256("LockedAccount:Ether")
88     bytes4 internal constant KNOWN_INTERFACE_ETHER_LOCK = 0x978a6823;
89 
90     // icbm euro lock account keccak256("ICBMLockedAccount:Euro")
91     bytes4 internal constant KNOWN_INTERFACE_ICBM_EURO_LOCK = 0x36021e14;
92 
93     // ether lock account (upgraded) keccak256("ICBMLockedAccount:Ether")
94     bytes4 internal constant KNOWN_INTERFACE_ICBM_ETHER_LOCK = 0x0b58f006;
95 
96     // ether token interface and singleton keccak256("ICBMEtherToken")
97     bytes4 internal constant KNOWN_INTERFACE_ICBM_ETHER_TOKEN = 0xae8b50b9;
98 
99     // euro token interface and singleton keccak256("ICBMEuroToken")
100     bytes4 internal constant KNOWN_INTERFACE_ICBM_EURO_TOKEN = 0xc2c6cd72;
101 
102     // ICBM commitment interface interface and singleton keccak256("ICBMCommitment")
103     bytes4 internal constant KNOWN_INTERFACE_ICBM_COMMITMENT = 0x7f2795ef;
104 
105     // ethereum fork arbiter interface and singleton keccak256("IEthereumForkArbiter")
106     bytes4 internal constant KNOWN_INTERFACE_FORK_ARBITER = 0x2fe7778c;
107 
108     // Platform terms interface and singletong keccak256("PlatformTerms")
109     bytes4 internal constant KNOWN_INTERFACE_PLATFORM_TERMS = 0x75ecd7f8;
110 
111     // for completness we define Universe service keccak256("Universe");
112     bytes4 internal constant KNOWN_INTERFACE_UNIVERSE = 0xbf202454;
113 
114     // ETO commitment interface (collection) keccak256("ICommitment")
115     bytes4 internal constant KNOWN_INTERFACE_COMMITMENT = 0xfa0e0c60;
116 
117     // Equity Token Controller interface (collection) keccak256("IEquityTokenController")
118     bytes4 internal constant KNOWN_INTERFACE_EQUITY_TOKEN_CONTROLLER = 0xfa30b2f1;
119 
120     // Equity Token interface (collection) keccak256("IEquityToken")
121     bytes4 internal constant KNOWN_INTERFACE_EQUITY_TOKEN = 0xab9885bb;
122 
123     // Payment tokens (collection) keccak256("PaymentToken")
124     bytes4 internal constant KNOWN_INTERFACE_PAYMENT_TOKEN = 0xb2a0042a;
125 }
126 
127 contract Math {
128 
129     ////////////////////////
130     // Internal functions
131     ////////////////////////
132 
133     // absolute difference: |v1 - v2|
134     function absDiff(uint256 v1, uint256 v2)
135         internal
136         pure
137         returns(uint256)
138     {
139         return v1 > v2 ? v1 - v2 : v2 - v1;
140     }
141 
142     // divide v by d, round up if remainder is 0.5 or more
143     function divRound(uint256 v, uint256 d)
144         internal
145         pure
146         returns(uint256)
147     {
148         return add(v, d/2) / d;
149     }
150 
151     // computes decimal decimalFraction 'frac' of 'amount' with maximum precision (multiplication first)
152     // both amount and decimalFraction must have 18 decimals precision, frac 10**18 represents a whole (100% of) amount
153     // mind loss of precision as decimal fractions do not have finite binary expansion
154     // do not use instead of division
155     function decimalFraction(uint256 amount, uint256 frac)
156         internal
157         pure
158         returns(uint256)
159     {
160         // it's like 1 ether is 100% proportion
161         return proportion(amount, frac, 10**18);
162     }
163 
164     // computes part/total of amount with maximum precision (multiplication first)
165     // part and total must have the same units
166     function proportion(uint256 amount, uint256 part, uint256 total)
167         internal
168         pure
169         returns(uint256)
170     {
171         return divRound(mul(amount, part), total);
172     }
173 
174     //
175     // Open Zeppelin Math library below
176     //
177 
178     function mul(uint256 a, uint256 b)
179         internal
180         pure
181         returns (uint256)
182     {
183         uint256 c = a * b;
184         assert(a == 0 || c / a == b);
185         return c;
186     }
187 
188     function sub(uint256 a, uint256 b)
189         internal
190         pure
191         returns (uint256)
192     {
193         assert(b <= a);
194         return a - b;
195     }
196 
197     function add(uint256 a, uint256 b)
198         internal
199         pure
200         returns (uint256)
201     {
202         uint256 c = a + b;
203         assert(c >= a);
204         return c;
205     }
206 
207     function min(uint256 a, uint256 b)
208         internal
209         pure
210         returns (uint256)
211     {
212         return a < b ? a : b;
213     }
214 
215     function max(uint256 a, uint256 b)
216         internal
217         pure
218         returns (uint256)
219     {
220         return a > b ? a : b;
221     }
222 }
223 
224 /// @title provides subject to role checking logic
225 contract IAccessPolicy {
226 
227     ////////////////////////
228     // Public functions
229     ////////////////////////
230 
231     /// @notice We don't make this function constant to allow for state-updating access controls such as rate limiting.
232     /// @dev checks if subject belongs to requested role for particular object
233     /// @param subject address to be checked against role, typically msg.sender
234     /// @param role identifier of required role
235     /// @param object contract instance context for role checking, typically contract requesting the check
236     /// @param verb additional data, in current AccessControll implementation msg.sig
237     /// @return if subject belongs to a role
238     function allowed(
239         address subject,
240         bytes32 role,
241         address object,
242         bytes4 verb
243     )
244         public
245         returns (bool);
246 }
247 
248 /// @title enables access control in implementing contract
249 /// @dev see AccessControlled for implementation
250 contract IAccessControlled {
251 
252     ////////////////////////
253     // Events
254     ////////////////////////
255 
256     /// @dev must log on access policy change
257     event LogAccessPolicyChanged(
258         address controller,
259         IAccessPolicy oldPolicy,
260         IAccessPolicy newPolicy
261     );
262 
263     ////////////////////////
264     // Public functions
265     ////////////////////////
266 
267     /// @dev allows to change access control mechanism for this contract
268     ///     this method must be itself access controlled, see AccessControlled implementation and notice below
269     /// @notice it is a huge issue for Solidity that modifiers are not part of function signature
270     ///     then interfaces could be used for example to control access semantics
271     /// @param newPolicy new access policy to controll this contract
272     /// @param newAccessController address of ROLE_ACCESS_CONTROLLER of new policy that can set access to this contract
273     function setAccessPolicy(IAccessPolicy newPolicy, address newAccessController)
274         public;
275 
276     function accessPolicy()
277         public
278         constant
279         returns (IAccessPolicy);
280 
281 }
282 
283 contract StandardRoles {
284 
285     ////////////////////////
286     // Constants
287     ////////////////////////
288 
289     // @notice Soldity somehow doesn't evaluate this compile time
290     // @dev role which has rights to change permissions and set new policy in contract, keccak256("AccessController")
291     bytes32 internal constant ROLE_ACCESS_CONTROLLER = 0xac42f8beb17975ed062dcb80c63e6d203ef1c2c335ced149dc5664cc671cb7da;
292 }
293 
294 /// @title Granular code execution permissions
295 /// @notice Intended to replace existing Ownable pattern with more granular permissions set to execute smart contract functions
296 ///     for each function where 'only' modifier is applied, IAccessPolicy implementation is called to evaluate if msg.sender belongs to required role for contract being called.
297 ///     Access evaluation specific belong to IAccessPolicy implementation, see RoleBasedAccessPolicy for details.
298 /// @dev Should be inherited by a contract requiring such permissions controll. IAccessPolicy must be provided in constructor. Access policy may be replaced to a different one
299 ///     by msg.sender with ROLE_ACCESS_CONTROLLER role
300 contract AccessControlled is IAccessControlled, StandardRoles {
301 
302     ////////////////////////
303     // Mutable state
304     ////////////////////////
305 
306     IAccessPolicy private _accessPolicy;
307 
308     ////////////////////////
309     // Modifiers
310     ////////////////////////
311 
312     /// @dev limits function execution only to senders assigned to required 'role'
313     modifier only(bytes32 role) {
314         require(_accessPolicy.allowed(msg.sender, role, this, msg.sig));
315         _;
316     }
317 
318     ////////////////////////
319     // Constructor
320     ////////////////////////
321 
322     constructor(IAccessPolicy policy) internal {
323         require(address(policy) != 0x0);
324         _accessPolicy = policy;
325     }
326 
327     ////////////////////////
328     // Public functions
329     ////////////////////////
330 
331     //
332     // Implements IAccessControlled
333     //
334 
335     function setAccessPolicy(IAccessPolicy newPolicy, address newAccessController)
336         public
337         only(ROLE_ACCESS_CONTROLLER)
338     {
339         // ROLE_ACCESS_CONTROLLER must be present
340         // under the new policy. This provides some
341         // protection against locking yourself out.
342         require(newPolicy.allowed(newAccessController, ROLE_ACCESS_CONTROLLER, this, msg.sig));
343 
344         // We can now safely set the new policy without foot shooting.
345         IAccessPolicy oldPolicy = _accessPolicy;
346         _accessPolicy = newPolicy;
347 
348         // Log event
349         emit LogAccessPolicyChanged(msg.sender, oldPolicy, newPolicy);
350     }
351 
352     function accessPolicy()
353         public
354         constant
355         returns (IAccessPolicy)
356     {
357         return _accessPolicy;
358     }
359 }
360 
361 contract IsContract {
362 
363     ////////////////////////
364     // Internal functions
365     ////////////////////////
366 
367     function isContract(address addr)
368         internal
369         constant
370         returns (bool)
371     {
372         uint256 size;
373         // takes 700 gas
374         assembly { size := extcodesize(addr) }
375         return size > 0;
376     }
377 }
378 
379 /// @title standard access roles of the Platform
380 /// @dev constants are kept in CODE not in STORAGE so they are comparatively cheap
381 contract AccessRoles {
382 
383     ////////////////////////
384     // Constants
385     ////////////////////////
386 
387     // NOTE: All roles are set to the keccak256 hash of the
388     // CamelCased role name, i.e.
389     // ROLE_LOCKED_ACCOUNT_ADMIN = keccak256("LockedAccountAdmin")
390 
391     // May issue (generate) Neumarks
392     bytes32 internal constant ROLE_NEUMARK_ISSUER = 0x921c3afa1f1fff707a785f953a1e197bd28c9c50e300424e015953cbf120c06c;
393 
394     // May burn Neumarks it owns
395     bytes32 internal constant ROLE_NEUMARK_BURNER = 0x19ce331285f41739cd3362a3ec176edffe014311c0f8075834fdd19d6718e69f;
396 
397     // May create new snapshots on Neumark
398     bytes32 internal constant ROLE_SNAPSHOT_CREATOR = 0x08c1785afc57f933523bc52583a72ce9e19b2241354e04dd86f41f887e3d8174;
399 
400     // May enable/disable transfers on Neumark
401     bytes32 internal constant ROLE_TRANSFER_ADMIN = 0xb6527e944caca3d151b1f94e49ac5e223142694860743e66164720e034ec9b19;
402 
403     // may reclaim tokens/ether from contracts supporting IReclaimable interface
404     bytes32 internal constant ROLE_RECLAIMER = 0x0542bbd0c672578966dcc525b30aa16723bb042675554ac5b0362f86b6e97dc5;
405 
406     // represents legally platform operator in case of forks and contracts with legal agreement attached. keccak256("PlatformOperatorRepresentative")
407     bytes32 internal constant ROLE_PLATFORM_OPERATOR_REPRESENTATIVE = 0xb2b321377653f655206f71514ff9f150d0822d062a5abcf220d549e1da7999f0;
408 
409     // allows to deposit EUR-T and allow addresses to send and receive EUR-T. keccak256("EurtDepositManager")
410     bytes32 internal constant ROLE_EURT_DEPOSIT_MANAGER = 0x7c8ecdcba80ce87848d16ad77ef57cc196c208fc95c5638e4a48c681a34d4fe7;
411 
412     // allows to register identities and change associated claims keccak256("IdentityManager")
413     bytes32 internal constant ROLE_IDENTITY_MANAGER = 0x32964e6bc50f2aaab2094a1d311be8bda920fc4fb32b2fb054917bdb153a9e9e;
414 
415     // allows to replace controller on euro token and to destroy tokens without withdraw kecckak256("EurtLegalManager")
416     bytes32 internal constant ROLE_EURT_LEGAL_MANAGER = 0x4eb6b5806954a48eb5659c9e3982d5e75bfb2913f55199877d877f157bcc5a9b;
417 
418     // allows to change known interfaces in universe kecckak256("UniverseManager")
419     bytes32 internal constant ROLE_UNIVERSE_MANAGER = 0xe8d8f8f9ea4b19a5a4368dbdace17ad71a69aadeb6250e54c7b4c7b446301738;
420 
421     // allows to exchange gas for EUR-T keccak("GasExchange")
422     bytes32 internal constant ROLE_GAS_EXCHANGE = 0x9fe43636e0675246c99e96d7abf9f858f518b9442c35166d87f0934abef8a969;
423 
424     // allows to set token exchange rates keccak("TokenRateOracle")
425     bytes32 internal constant ROLE_TOKEN_RATE_ORACLE = 0xa80c3a0c8a5324136e4c806a778583a2a980f378bdd382921b8d28dcfe965585;
426 
427     // allows to disburse to the fee disbursal contract keccak("Disburser")
428     bytes32 internal constant ROLE_DISBURSER = 0xd7ea6093d11d866c9e8449f8bffd9da1387c530ee40ad54f0641425bb0ca33b7;
429 
430     // allows to manage feedisbursal controller keccak("DisbursalManager")
431     bytes32 internal constant ROLE_DISBURSAL_MANAGER = 0x677f87f7b7ef7c97e42a7e6c85c295cf020c9f11eea1e49f6bf847d7aeae1475;
432 
433 }
434 
435 contract IBasicToken {
436 
437     ////////////////////////
438     // Events
439     ////////////////////////
440 
441     event Transfer(
442         address indexed from,
443         address indexed to,
444         uint256 amount
445     );
446 
447     ////////////////////////
448     // Public functions
449     ////////////////////////
450 
451     /// @dev This function makes it easy to get the total number of tokens
452     /// @return The total number of tokens
453     function totalSupply()
454         public
455         constant
456         returns (uint256);
457 
458     /// @param owner The address that's balance is being requested
459     /// @return The balance of `owner` at the current block
460     function balanceOf(address owner)
461         public
462         constant
463         returns (uint256 balance);
464 
465     /// @notice Send `amount` tokens to `to` from `msg.sender`
466     /// @param to The address of the recipient
467     /// @param amount The amount of tokens to be transferred
468     /// @return Whether the transfer was successful or not
469     function transfer(address to, uint256 amount)
470         public
471         returns (bool success);
472 
473 }
474 
475 /// @title allows deriving contract to recover any token or ether that it has balance of
476 /// @notice note that this opens your contracts to claims from various people saying they lost tokens and they want them back
477 ///     be ready to handle such claims
478 /// @dev use with care!
479 ///     1. ROLE_RECLAIMER is allowed to claim tokens, it's not returning tokens to original owner
480 ///     2. in derived contract that holds any token by design you must override `reclaim` and block such possibility.
481 ///         see ICBMLockedAccount as an example
482 contract Reclaimable is AccessControlled, AccessRoles {
483 
484     ////////////////////////
485     // Constants
486     ////////////////////////
487 
488     IBasicToken constant internal RECLAIM_ETHER = IBasicToken(0x0);
489 
490     ////////////////////////
491     // Public functions
492     ////////////////////////
493 
494     function reclaim(IBasicToken token)
495         public
496         only(ROLE_RECLAIMER)
497     {
498         address reclaimer = msg.sender;
499         if(token == RECLAIM_ETHER) {
500             reclaimer.transfer(address(this).balance);
501         } else {
502             uint256 balance = token.balanceOf(this);
503             require(token.transfer(reclaimer, balance));
504         }
505     }
506 }
507 
508 contract ITokenMetadata {
509 
510     ////////////////////////
511     // Public functions
512     ////////////////////////
513 
514     function symbol()
515         public
516         constant
517         returns (string);
518 
519     function name()
520         public
521         constant
522         returns (string);
523 
524     function decimals()
525         public
526         constant
527         returns (uint8);
528 }
529 
530 /// @title adds token metadata to token contract
531 /// @dev see Neumark for example implementation
532 contract TokenMetadata is ITokenMetadata {
533 
534     ////////////////////////
535     // Immutable state
536     ////////////////////////
537 
538     // The Token's name: e.g. DigixDAO Tokens
539     string private NAME;
540 
541     // An identifier: e.g. REP
542     string private SYMBOL;
543 
544     // Number of decimals of the smallest unit
545     uint8 private DECIMALS;
546 
547     // An arbitrary versioning scheme
548     string private VERSION;
549 
550     ////////////////////////
551     // Constructor
552     ////////////////////////
553 
554     /// @notice Constructor to set metadata
555     /// @param tokenName Name of the new token
556     /// @param decimalUnits Number of decimals of the new token
557     /// @param tokenSymbol Token Symbol for the new token
558     /// @param version Token version ie. when cloning is used
559     constructor(
560         string tokenName,
561         uint8 decimalUnits,
562         string tokenSymbol,
563         string version
564     )
565         public
566     {
567         NAME = tokenName;                                 // Set the name
568         SYMBOL = tokenSymbol;                             // Set the symbol
569         DECIMALS = decimalUnits;                          // Set the decimals
570         VERSION = version;
571     }
572 
573     ////////////////////////
574     // Public functions
575     ////////////////////////
576 
577     function name()
578         public
579         constant
580         returns (string)
581     {
582         return NAME;
583     }
584 
585     function symbol()
586         public
587         constant
588         returns (string)
589     {
590         return SYMBOL;
591     }
592 
593     function decimals()
594         public
595         constant
596         returns (uint8)
597     {
598         return DECIMALS;
599     }
600 
601     function version()
602         public
603         constant
604         returns (string)
605     {
606         return VERSION;
607     }
608 }
609 
610 /// @title controls spending approvals
611 /// @dev TokenAllowance observes this interface, Neumark contract implements it
612 contract MTokenAllowanceController {
613 
614     ////////////////////////
615     // Internal functions
616     ////////////////////////
617 
618     /// @notice Notifies the controller about an approval allowing the
619     ///  controller to react if desired
620     /// @param owner The address that calls `approve()`
621     /// @param spender The spender in the `approve()` call
622     /// @param amount The amount in the `approve()` call
623     /// @return False if the controller does not authorize the approval
624     function mOnApprove(
625         address owner,
626         address spender,
627         uint256 amount
628     )
629         internal
630         returns (bool allow);
631 
632     /// @notice Allows to override allowance approved by the owner
633     ///         Primary role is to enable forced transfers, do not override if you do not like it
634     ///         Following behavior is expected in the observer
635     ///         approve() - should revert if mAllowanceOverride() > 0
636     ///         allowance() - should return mAllowanceOverride() if set
637     ///         transferFrom() - should override allowance if mAllowanceOverride() > 0
638     /// @param owner An address giving allowance to spender
639     /// @param spender An address getting  a right to transfer allowance amount from the owner
640     /// @return current allowance amount
641     function mAllowanceOverride(
642         address owner,
643         address spender
644     )
645         internal
646         constant
647         returns (uint256 allowance);
648 }
649 
650 /// @title controls token transfers
651 /// @dev BasicSnapshotToken observes this interface, Neumark contract implements it
652 contract MTokenTransferController {
653 
654     ////////////////////////
655     // Internal functions
656     ////////////////////////
657 
658     /// @notice Notifies the controller about a token transfer allowing the
659     ///  controller to react if desired
660     /// @param from The origin of the transfer
661     /// @param to The destination of the transfer
662     /// @param amount The amount of the transfer
663     /// @return False if the controller does not authorize the transfer
664     function mOnTransfer(
665         address from,
666         address to,
667         uint256 amount
668     )
669         internal
670         returns (bool allow);
671 
672 }
673 
674 /// @title controls approvals and transfers
675 /// @dev The token controller contract must implement these functions, see Neumark as example
676 /// @dev please note that controller may be a separate contract that is called from mOnTransfer and mOnApprove functions
677 contract MTokenController is MTokenTransferController, MTokenAllowanceController {
678 }
679 
680 contract TrustlessTokenController is
681     MTokenController
682 {
683     ////////////////////////
684     // Internal functions
685     ////////////////////////
686 
687     //
688     // Implements MTokenController
689     //
690 
691     function mOnTransfer(
692         address /*from*/,
693         address /*to*/,
694         uint256 /*amount*/
695     )
696         internal
697         returns (bool allow)
698     {
699         return true;
700     }
701 
702     function mOnApprove(
703         address /*owner*/,
704         address /*spender*/,
705         uint256 /*amount*/
706     )
707         internal
708         returns (bool allow)
709     {
710         return true;
711     }
712 }
713 
714 contract IERC20Allowance {
715 
716     ////////////////////////
717     // Events
718     ////////////////////////
719 
720     event Approval(
721         address indexed owner,
722         address indexed spender,
723         uint256 amount
724     );
725 
726     ////////////////////////
727     // Public functions
728     ////////////////////////
729 
730     /// @dev This function makes it easy to read the `allowed[]` map
731     /// @param owner The address of the account that owns the token
732     /// @param spender The address of the account able to transfer the tokens
733     /// @return Amount of remaining tokens of owner that spender is allowed
734     ///  to spend
735     function allowance(address owner, address spender)
736         public
737         constant
738         returns (uint256 remaining);
739 
740     /// @notice `msg.sender` approves `spender` to spend `amount` tokens on
741     ///  its behalf. This is a modified version of the ERC20 approve function
742     ///  to be a little bit safer
743     /// @param spender The address of the account able to transfer the tokens
744     /// @param amount The amount of tokens to be approved for transfer
745     /// @return True if the approval was successful
746     function approve(address spender, uint256 amount)
747         public
748         returns (bool success);
749 
750     /// @notice Send `amount` tokens to `to` from `from` on the condition it
751     ///  is approved by `from`
752     /// @param from The address holding the tokens being transferred
753     /// @param to The address of the recipient
754     /// @param amount The amount of tokens to be transferred
755     /// @return True if the transfer was successful
756     function transferFrom(address from, address to, uint256 amount)
757         public
758         returns (bool success);
759 
760 }
761 
762 contract IERC20Token is IBasicToken, IERC20Allowance {
763 
764 }
765 
766 contract IERC677Callback {
767 
768     ////////////////////////
769     // Public functions
770     ////////////////////////
771 
772     // NOTE: This call can be initiated by anyone. You need to make sure that
773     // it is send by the token (`require(msg.sender == token)`) or make sure
774     // amount is valid (`require(token.allowance(this) >= amount)`).
775     function receiveApproval(
776         address from,
777         uint256 amount,
778         address token, // IERC667Token
779         bytes data
780     )
781         public
782         returns (bool success);
783 
784 }
785 
786 contract IERC677Allowance is IERC20Allowance {
787 
788     ////////////////////////
789     // Public functions
790     ////////////////////////
791 
792     /// @notice `msg.sender` approves `spender` to send `amount` tokens on
793     ///  its behalf, and then a function is triggered in the contract that is
794     ///  being approved, `spender`. This allows users to use their tokens to
795     ///  interact with contracts in one function call instead of two
796     /// @param spender The address of the contract able to transfer the tokens
797     /// @param amount The amount of tokens to be approved for transfer
798     /// @return True if the function call was successful
799     function approveAndCall(address spender, uint256 amount, bytes extraData)
800         public
801         returns (bool success);
802 
803 }
804 
805 contract IERC677Token is IERC20Token, IERC677Allowance {
806 }
807 
808 /// @title internal token transfer function
809 /// @dev see BasicSnapshotToken for implementation
810 contract MTokenTransfer {
811 
812     ////////////////////////
813     // Internal functions
814     ////////////////////////
815 
816     /// @dev This is the actual transfer function in the token contract, it can
817     ///  only be called by other functions in this contract.
818     /// @param from The address holding the tokens being transferred
819     /// @param to The address of the recipient
820     /// @param amount The amount of tokens to be transferred
821     /// @dev  reverts if transfer was not successful
822     function mTransfer(
823         address from,
824         address to,
825         uint256 amount
826     )
827         internal;
828 }
829 
830 /**
831  * @title Basic token
832  * @dev Basic version of StandardToken, with no allowances.
833  */
834 contract BasicToken is
835     MTokenTransfer,
836     MTokenTransferController,
837     IBasicToken,
838     Math
839 {
840 
841     ////////////////////////
842     // Mutable state
843     ////////////////////////
844 
845     mapping(address => uint256) internal _balances;
846 
847     uint256 internal _totalSupply;
848 
849     ////////////////////////
850     // Public functions
851     ////////////////////////
852 
853     /**
854     * @dev transfer token for a specified address
855     * @param to The address to transfer to.
856     * @param amount The amount to be transferred.
857     */
858     function transfer(address to, uint256 amount)
859         public
860         returns (bool)
861     {
862         mTransfer(msg.sender, to, amount);
863         return true;
864     }
865 
866     /// @dev This function makes it easy to get the total number of tokens
867     /// @return The total number of tokens
868     function totalSupply()
869         public
870         constant
871         returns (uint256)
872     {
873         return _totalSupply;
874     }
875 
876     /**
877     * @dev Gets the balance of the specified address.
878     * @param owner The address to query the the balance of.
879     * @return An uint256 representing the amount owned by the passed address.
880     */
881     function balanceOf(address owner)
882         public
883         constant
884         returns (uint256 balance)
885     {
886         return _balances[owner];
887     }
888 
889     ////////////////////////
890     // Internal functions
891     ////////////////////////
892 
893     //
894     // Implements MTokenTransfer
895     //
896 
897     function mTransfer(address from, address to, uint256 amount)
898         internal
899     {
900         require(to != address(0));
901         require(mOnTransfer(from, to, amount));
902 
903         _balances[from] = sub(_balances[from], amount);
904         _balances[to] = add(_balances[to], amount);
905         emit Transfer(from, to, amount);
906     }
907 }
908 
909 /// @title token spending approval and transfer
910 /// @dev implements token approval and transfers and exposes relevant part of ERC20 and ERC677 approveAndCall
911 ///     may be mixed in with any basic token (implementing mTransfer) like BasicSnapshotToken or MintableSnapshotToken to add approval mechanism
912 ///     observes MTokenAllowanceController interface
913 ///     observes MTokenTransfer
914 contract TokenAllowance is
915     MTokenTransfer,
916     MTokenAllowanceController,
917     IERC20Allowance,
918     IERC677Token
919 {
920 
921     ////////////////////////
922     // Mutable state
923     ////////////////////////
924 
925     // `allowed` tracks rights to spends others tokens as per ERC20
926     // owner => spender => amount
927     mapping (address => mapping (address => uint256)) private _allowed;
928 
929     ////////////////////////
930     // Constructor
931     ////////////////////////
932 
933     constructor()
934         internal
935     {
936     }
937 
938     ////////////////////////
939     // Public functions
940     ////////////////////////
941 
942     //
943     // Implements IERC20Token
944     //
945 
946     /// @dev This function makes it easy to read the `allowed[]` map
947     /// @param owner The address of the account that owns the token
948     /// @param spender The address of the account able to transfer the tokens
949     /// @return Amount of remaining tokens of _owner that _spender is allowed
950     ///  to spend
951     function allowance(address owner, address spender)
952         public
953         constant
954         returns (uint256 remaining)
955     {
956         uint256 override = mAllowanceOverride(owner, spender);
957         if (override > 0) {
958             return override;
959         }
960         return _allowed[owner][spender];
961     }
962 
963     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
964     ///  its behalf. This is a modified version of the ERC20 approve function
965     ///  where allowance per spender must be 0 to allow change of such allowance
966     /// @param spender The address of the account able to transfer the tokens
967     /// @param amount The amount of tokens to be approved for transfer
968     /// @return True or reverts, False is never returned
969     function approve(address spender, uint256 amount)
970         public
971         returns (bool success)
972     {
973         // Alerts the token controller of the approve function call
974         require(mOnApprove(msg.sender, spender, amount));
975 
976         // To change the approve amount you first have to reduce the addresses`
977         //  allowance to zero by calling `approve(_spender,0)` if it is not
978         //  already 0 to mitigate the race condition described here:
979         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
980         require((amount == 0 || _allowed[msg.sender][spender] == 0) && mAllowanceOverride(msg.sender, spender) == 0);
981 
982         _allowed[msg.sender][spender] = amount;
983         emit Approval(msg.sender, spender, amount);
984         return true;
985     }
986 
987     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
988     ///  is approved by `_from`
989     /// @param from The address holding the tokens being transferred
990     /// @param to The address of the recipient
991     /// @param amount The amount of tokens to be transferred
992     /// @return True if the transfer was successful, reverts in any other case
993     function transferFrom(address from, address to, uint256 amount)
994         public
995         returns (bool success)
996     {
997         uint256 allowed = mAllowanceOverride(from, msg.sender);
998         if (allowed == 0) {
999             // The standard ERC 20 transferFrom functionality
1000             allowed = _allowed[from][msg.sender];
1001             // yes this will underflow but then we'll revert. will cost gas however so don't underflow
1002             _allowed[from][msg.sender] -= amount;
1003         }
1004         require(allowed >= amount);
1005         mTransfer(from, to, amount);
1006         return true;
1007     }
1008 
1009     //
1010     // Implements IERC677Token
1011     //
1012 
1013     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
1014     ///  its behalf, and then a function is triggered in the contract that is
1015     ///  being approved, `_spender`. This allows users to use their tokens to
1016     ///  interact with contracts in one function call instead of two
1017     /// @param spender The address of the contract able to transfer the tokens
1018     /// @param amount The amount of tokens to be approved for transfer
1019     /// @return True or reverts, False is never returned
1020     function approveAndCall(
1021         address spender,
1022         uint256 amount,
1023         bytes extraData
1024     )
1025         public
1026         returns (bool success)
1027     {
1028         require(approve(spender, amount));
1029 
1030         success = IERC677Callback(spender).receiveApproval(
1031             msg.sender,
1032             amount,
1033             this,
1034             extraData
1035         );
1036         require(success);
1037 
1038         return true;
1039     }
1040 
1041     ////////////////////////
1042     // Internal functions
1043     ////////////////////////
1044 
1045     //
1046     // Implements default MTokenAllowanceController
1047     //
1048 
1049     // no override in default implementation
1050     function mAllowanceOverride(
1051         address /*owner*/,
1052         address /*spender*/
1053     )
1054         internal
1055         constant
1056         returns (uint256)
1057     {
1058         return 0;
1059     }
1060 }
1061 
1062 /**
1063  * @title Standard ERC20 token
1064  *
1065  * @dev Implementation of the standard token.
1066  * @dev https://github.com/ethereum/EIPs/issues/20
1067  */
1068 contract StandardToken is
1069     IERC20Token,
1070     BasicToken,
1071     TokenAllowance
1072 {
1073 
1074 }
1075 
1076 /// @title uniquely identifies deployable (non-abstract) platform contract
1077 /// @notice cheap way of assigning implementations to knownInterfaces which represent system services
1078 ///         unfortunatelly ERC165 does not include full public interface (ABI) and does not provide way to list implemented interfaces
1079 ///         EIP820 still in the making
1080 /// @dev ids are generated as follows keccak256("neufund-platform:<contract name>")
1081 ///      ids roughly correspond to ABIs
1082 contract IContractId {
1083     /// @param id defined as above
1084     /// @param version implementation version
1085     function contractId() public pure returns (bytes32 id, uint256 version);
1086 }
1087 
1088 /// @title current ERC223 fallback function
1089 /// @dev to be used in all future token contract
1090 /// @dev NEU and ICBMEtherToken (obsolete) are the only contracts that still uses IERC223LegacyCallback
1091 contract IERC223Callback {
1092 
1093     ////////////////////////
1094     // Public functions
1095     ////////////////////////
1096 
1097     function tokenFallback(address from, uint256 amount, bytes data)
1098         public;
1099 
1100 }
1101 
1102 contract IERC223Token is IERC20Token, ITokenMetadata {
1103 
1104     /// @dev Departure: We do not log data, it has no advantage over a standard
1105     ///     log event. By sticking to the standard log event we
1106     ///     stay compatible with constracts that expect and ERC20 token.
1107 
1108     // event Transfer(
1109     //    address indexed from,
1110     //    address indexed to,
1111     //    uint256 amount,
1112     //    bytes data);
1113 
1114 
1115     /// @dev Departure: We do not use the callback on regular transfer calls to
1116     ///     stay compatible with constracts that expect and ERC20 token.
1117 
1118     // function transfer(address to, uint256 amount)
1119     //     public
1120     //     returns (bool);
1121 
1122     ////////////////////////
1123     // Public functions
1124     ////////////////////////
1125 
1126     function transfer(address to, uint256 amount, bytes data)
1127         public
1128         returns (bool);
1129 }
1130 
1131 contract IWithdrawableToken {
1132 
1133     ////////////////////////
1134     // Public functions
1135     ////////////////////////
1136 
1137     /// @notice withdraws from a token holding assets
1138     /// @dev amount of asset should be returned to msg.sender and corresponding balance burned
1139     function withdraw(uint256 amount)
1140         public;
1141 }
1142 
1143 contract EtherToken is
1144     IsContract,
1145     IContractId,
1146     AccessControlled,
1147     StandardToken,
1148     TrustlessTokenController,
1149     IWithdrawableToken,
1150     TokenMetadata,
1151     IERC223Token,
1152     Reclaimable
1153 {
1154     ////////////////////////
1155     // Constants
1156     ////////////////////////
1157 
1158     string private constant NAME = "Ether Token";
1159 
1160     string private constant SYMBOL = "ETH-T";
1161 
1162     uint8 private constant DECIMALS = 18;
1163 
1164     ////////////////////////
1165     // Events
1166     ////////////////////////
1167 
1168     event LogDeposit(
1169         address indexed to,
1170         uint256 amount
1171     );
1172 
1173     event LogWithdrawal(
1174         address indexed from,
1175         uint256 amount
1176     );
1177 
1178     event LogWithdrawAndSend(
1179         address indexed from,
1180         address indexed to,
1181         uint256 amount
1182     );
1183 
1184     ////////////////////////
1185     // Constructor
1186     ////////////////////////
1187 
1188     constructor(IAccessPolicy accessPolicy)
1189         AccessControlled(accessPolicy)
1190         StandardToken()
1191         TokenMetadata(NAME, DECIMALS, SYMBOL, "")
1192         Reclaimable()
1193         public
1194     {
1195     }
1196 
1197     ////////////////////////
1198     // Public functions
1199     ////////////////////////
1200 
1201     /// deposit msg.value of Ether to msg.sender balance
1202     function deposit()
1203         public
1204         payable
1205     {
1206         depositPrivate();
1207         emit Transfer(address(0), msg.sender, msg.value);
1208     }
1209 
1210     /// @notice convenience function to deposit and immediately transfer amount
1211     /// @param transferTo where to transfer after deposit
1212     /// @param amount total amount to transfer, must be <= balance after deposit
1213     /// @param data erc223 data
1214     /// @dev intended to deposit from simple account and invest in ETO
1215     function depositAndTransfer(address transferTo, uint256 amount, bytes data)
1216         public
1217         payable
1218     {
1219         depositPrivate();
1220         transfer(transferTo, amount, data);
1221     }
1222 
1223     /// withdraws and sends 'amount' of ether to msg.sender
1224     function withdraw(uint256 amount)
1225         public
1226     {
1227         withdrawPrivate(amount);
1228         msg.sender.transfer(amount);
1229     }
1230 
1231     /// @notice convenience function to withdraw and transfer to external account
1232     /// @param sendTo address to which send total amount
1233     /// @param amount total amount to withdraw and send
1234     /// @dev function is payable and is meant to withdraw funds on accounts balance and token in single transaction
1235     /// @dev BEWARE that msg.sender of the funds is Ether Token contract and not simple account calling it.
1236     /// @dev  when sent to smart conctract funds may be lost, so this is prevented below
1237     function withdrawAndSend(address sendTo, uint256 amount)
1238         public
1239         payable
1240     {
1241         // must send at least what is in msg.value to being another deposit function
1242         require(amount >= msg.value, "NF_ET_NO_DEPOSIT");
1243         if (amount > msg.value) {
1244             uint256 withdrawRemainder = amount - msg.value;
1245             withdrawPrivate(withdrawRemainder);
1246         }
1247         emit LogWithdrawAndSend(msg.sender, sendTo, amount);
1248         sendTo.transfer(amount);
1249     }
1250 
1251     //
1252     // Implements IERC223Token
1253     //
1254 
1255     function transfer(address to, uint256 amount, bytes data)
1256         public
1257         returns (bool)
1258     {
1259         BasicToken.mTransfer(msg.sender, to, amount);
1260 
1261         // Notify the receiving contract.
1262         if (isContract(to)) {
1263             // in case of re-entry (1) transfer is done (2) msg.sender is different
1264             IERC223Callback(to).tokenFallback(msg.sender, amount, data);
1265         }
1266         return true;
1267     }
1268 
1269     //
1270     // Overrides Reclaimable
1271     //
1272 
1273     /// @notice allows EtherToken to reclaim tokens wrongly sent to its address
1274     /// @dev as EtherToken by design has balance of Ether (native Ethereum token)
1275     ///     such reclamation is not allowed
1276     function reclaim(IBasicToken token)
1277         public
1278     {
1279         // forbid reclaiming ETH hold in this contract.
1280         require(token != RECLAIM_ETHER);
1281         Reclaimable.reclaim(token);
1282     }
1283 
1284     //
1285     // Implements IContractId
1286     //
1287 
1288     function contractId() public pure returns (bytes32 id, uint256 version) {
1289         return (0x75b86bc24f77738576716a36431588ae768d80d077231d1661c2bea674c6373a, 0);
1290     }
1291 
1292 
1293     ////////////////////////
1294     // Private functions
1295     ////////////////////////
1296 
1297     function depositPrivate()
1298         private
1299     {
1300         _balances[msg.sender] = add(_balances[msg.sender], msg.value);
1301         _totalSupply = add(_totalSupply, msg.value);
1302         emit LogDeposit(msg.sender, msg.value);
1303     }
1304 
1305     function withdrawPrivate(uint256 amount)
1306         private
1307     {
1308         require(_balances[msg.sender] >= amount);
1309         _balances[msg.sender] = sub(_balances[msg.sender], amount);
1310         _totalSupply = sub(_totalSupply, amount);
1311         emit LogWithdrawal(msg.sender, amount);
1312         emit Transfer(msg.sender, address(0), amount);
1313     }
1314 }
1315 
1316 contract IEthereumForkArbiter {
1317 
1318     ////////////////////////
1319     // Events
1320     ////////////////////////
1321 
1322     event LogForkAnnounced(
1323         string name,
1324         string url,
1325         uint256 blockNumber
1326     );
1327 
1328     event LogForkSigned(
1329         uint256 blockNumber,
1330         bytes32 blockHash
1331     );
1332 
1333     ////////////////////////
1334     // Public functions
1335     ////////////////////////
1336 
1337     function nextForkName()
1338         public
1339         constant
1340         returns (string);
1341 
1342     function nextForkUrl()
1343         public
1344         constant
1345         returns (string);
1346 
1347     function nextForkBlockNumber()
1348         public
1349         constant
1350         returns (uint256);
1351 
1352     function lastSignedBlockNumber()
1353         public
1354         constant
1355         returns (uint256);
1356 
1357     function lastSignedBlockHash()
1358         public
1359         constant
1360         returns (bytes32);
1361 
1362     function lastSignedTimestamp()
1363         public
1364         constant
1365         returns (uint256);
1366 
1367 }
1368 
1369 /**
1370  * @title legally binding smart contract
1371  * @dev General approach to paring legal and smart contracts:
1372  * 1. All terms and agreement are between two parties: here between smart conctract legal representation and platform investor.
1373  * 2. Parties are represented by public Ethereum addresses. Platform investor is and address that holds and controls funds and receives and controls Neumark token
1374  * 3. Legal agreement has immutable part that corresponds to smart contract code and mutable part that may change for example due to changing regulations or other externalities that smart contract does not control.
1375  * 4. There should be a provision in legal document that future changes in mutable part cannot change terms of immutable part.
1376  * 5. Immutable part links to corresponding smart contract via its address.
1377  * 6. Additional provision should be added if smart contract supports it
1378  *  a. Fork provision
1379  *  b. Bugfixing provision (unilateral code update mechanism)
1380  *  c. Migration provision (bilateral code update mechanism)
1381  *
1382  * Details on Agreement base class:
1383  * 1. We bind smart contract to legal contract by storing uri (preferably ipfs or hash) of the legal contract in the smart contract. It is however crucial that such binding is done by smart contract legal representation so transaction establishing the link must be signed by respective wallet ('amendAgreement')
1384  * 2. Mutable part of agreement may change. We should be able to amend the uri later. Previous amendments should not be lost and should be retrievable (`amendAgreement` and 'pastAgreement' functions).
1385  * 3. It is up to deriving contract to decide where to put 'acceptAgreement' modifier. However situation where there is no cryptographic proof that given address was really acting in the transaction should be avoided, simplest example being 'to' address in `transfer` function of ERC20.
1386  *
1387 **/
1388 contract IAgreement {
1389 
1390     ////////////////////////
1391     // Events
1392     ////////////////////////
1393 
1394     event LogAgreementAccepted(
1395         address indexed accepter
1396     );
1397 
1398     event LogAgreementAmended(
1399         address contractLegalRepresentative,
1400         string agreementUri
1401     );
1402 
1403     /// @dev should have access restrictions so only contractLegalRepresentative may call
1404     function amendAgreement(string agreementUri) public;
1405 
1406     /// returns information on last amendment of the agreement
1407     /// @dev MUST revert if no agreements were set
1408     function currentAgreement()
1409         public
1410         constant
1411         returns
1412         (
1413             address contractLegalRepresentative,
1414             uint256 signedBlockTimestamp,
1415             string agreementUri,
1416             uint256 index
1417         );
1418 
1419     /// returns information on amendment with index
1420     /// @dev MAY revert on non existing amendment, indexing starts from 0
1421     function pastAgreement(uint256 amendmentIndex)
1422         public
1423         constant
1424         returns
1425         (
1426             address contractLegalRepresentative,
1427             uint256 signedBlockTimestamp,
1428             string agreementUri,
1429             uint256 index
1430         );
1431 
1432     /// returns the number of block at wchich `signatory` signed agreement
1433     /// @dev MUST return 0 if not signed
1434     function agreementSignedAtBlock(address signatory)
1435         public
1436         constant
1437         returns (uint256 blockNo);
1438 
1439     /// returns number of amendments made by contractLegalRepresentative
1440     function amendmentsCount()
1441         public
1442         constant
1443         returns (uint256);
1444 }
1445 
1446 /**
1447  * @title legally binding smart contract
1448  * @dev read IAgreement for details
1449 **/
1450 contract Agreement is
1451     IAgreement,
1452     AccessControlled,
1453     AccessRoles
1454 {
1455 
1456     ////////////////////////
1457     // Type declarations
1458     ////////////////////////
1459 
1460     /// @notice agreement with signature of the platform operator representative
1461     struct SignedAgreement {
1462         address contractLegalRepresentative;
1463         uint256 signedBlockTimestamp;
1464         string agreementUri;
1465     }
1466 
1467     ////////////////////////
1468     // Immutable state
1469     ////////////////////////
1470 
1471     IEthereumForkArbiter private ETHEREUM_FORK_ARBITER;
1472 
1473     ////////////////////////
1474     // Mutable state
1475     ////////////////////////
1476 
1477     // stores all amendments to the agreement, first amendment is the original
1478     SignedAgreement[] private _amendments;
1479 
1480     // stores block numbers of all addresses that signed the agreement (signatory => block number)
1481     mapping(address => uint256) private _signatories;
1482 
1483     ////////////////////////
1484     // Modifiers
1485     ////////////////////////
1486 
1487     /// @notice logs that agreement was accepted by platform user
1488     /// @dev intended to be added to functions that if used make 'accepter' origin to enter legally binding agreement
1489     modifier acceptAgreement(address accepter) {
1490         acceptAgreementInternal(accepter);
1491         _;
1492     }
1493 
1494     modifier onlyLegalRepresentative(address legalRepresentative) {
1495         require(mCanAmend(legalRepresentative));
1496         _;
1497     }
1498 
1499     ////////////////////////
1500     // Constructor
1501     ////////////////////////
1502 
1503     constructor(IAccessPolicy accessPolicy, IEthereumForkArbiter forkArbiter)
1504         AccessControlled(accessPolicy)
1505         internal
1506     {
1507         require(forkArbiter != IEthereumForkArbiter(0x0));
1508         ETHEREUM_FORK_ARBITER = forkArbiter;
1509     }
1510 
1511     ////////////////////////
1512     // Public functions
1513     ////////////////////////
1514 
1515     function amendAgreement(string agreementUri)
1516         public
1517         onlyLegalRepresentative(msg.sender)
1518     {
1519         SignedAgreement memory amendment = SignedAgreement({
1520             contractLegalRepresentative: msg.sender,
1521             signedBlockTimestamp: block.timestamp,
1522             agreementUri: agreementUri
1523         });
1524         _amendments.push(amendment);
1525         emit LogAgreementAmended(msg.sender, agreementUri);
1526     }
1527 
1528     function ethereumForkArbiter()
1529         public
1530         constant
1531         returns (IEthereumForkArbiter)
1532     {
1533         return ETHEREUM_FORK_ARBITER;
1534     }
1535 
1536     function currentAgreement()
1537         public
1538         constant
1539         returns
1540         (
1541             address contractLegalRepresentative,
1542             uint256 signedBlockTimestamp,
1543             string agreementUri,
1544             uint256 index
1545         )
1546     {
1547         require(_amendments.length > 0);
1548         uint256 last = _amendments.length - 1;
1549         SignedAgreement storage amendment = _amendments[last];
1550         return (
1551             amendment.contractLegalRepresentative,
1552             amendment.signedBlockTimestamp,
1553             amendment.agreementUri,
1554             last
1555         );
1556     }
1557 
1558     function pastAgreement(uint256 amendmentIndex)
1559         public
1560         constant
1561         returns
1562         (
1563             address contractLegalRepresentative,
1564             uint256 signedBlockTimestamp,
1565             string agreementUri,
1566             uint256 index
1567         )
1568     {
1569         SignedAgreement storage amendment = _amendments[amendmentIndex];
1570         return (
1571             amendment.contractLegalRepresentative,
1572             amendment.signedBlockTimestamp,
1573             amendment.agreementUri,
1574             amendmentIndex
1575         );
1576     }
1577 
1578     function agreementSignedAtBlock(address signatory)
1579         public
1580         constant
1581         returns (uint256 blockNo)
1582     {
1583         return _signatories[signatory];
1584     }
1585 
1586     function amendmentsCount()
1587         public
1588         constant
1589         returns (uint256)
1590     {
1591         return _amendments.length;
1592     }
1593 
1594     ////////////////////////
1595     // Internal functions
1596     ////////////////////////
1597 
1598     /// provides direct access to derived contract
1599     function acceptAgreementInternal(address accepter)
1600         internal
1601     {
1602         if(_signatories[accepter] == 0) {
1603             require(_amendments.length > 0);
1604             _signatories[accepter] = block.number;
1605             emit LogAgreementAccepted(accepter);
1606         }
1607     }
1608 
1609     //
1610     // MAgreement Internal interface (todo: extract)
1611     //
1612 
1613     /// default amend permission goes to ROLE_PLATFORM_OPERATOR_REPRESENTATIVE
1614     function mCanAmend(address legalRepresentative)
1615         internal
1616         returns (bool)
1617     {
1618         return accessPolicy().allowed(legalRepresentative, ROLE_PLATFORM_OPERATOR_REPRESENTATIVE, this, msg.sig);
1619     }
1620 }
1621 
1622 /// @title granular token controller based on MSnapshotToken observer pattern
1623 contract ITokenController {
1624 
1625     ////////////////////////
1626     // Public functions
1627     ////////////////////////
1628 
1629     /// @notice see MTokenTransferController
1630     /// @dev additionally passes broker that is executing transaction between from and to
1631     ///      for unbrokered transfer, broker == from
1632     function onTransfer(address broker, address from, address to, uint256 amount)
1633         public
1634         constant
1635         returns (bool allow);
1636 
1637     /// @notice see MTokenAllowanceController
1638     function onApprove(address owner, address spender, uint256 amount)
1639         public
1640         constant
1641         returns (bool allow);
1642 
1643     /// @notice see MTokenMint
1644     function onGenerateTokens(address sender, address owner, uint256 amount)
1645         public
1646         constant
1647         returns (bool allow);
1648 
1649     /// @notice see MTokenMint
1650     function onDestroyTokens(address sender, address owner, uint256 amount)
1651         public
1652         constant
1653         returns (bool allow);
1654 
1655     /// @notice controls if sender can change controller to newController
1656     /// @dev for this to succeed TYPICALLY current controller must be already migrated to a new one
1657     function onChangeTokenController(address sender, address newController)
1658         public
1659         constant
1660         returns (bool);
1661 
1662     /// @notice overrides spender allowance
1663     /// @dev may be used to implemented forced transfers in which token controller may override approved allowance
1664     ///      with any > 0 value and then use transferFrom to execute such transfer
1665     ///      This by definition creates non-trustless token so do not implement this call if you do not need trustless transfers!
1666     ///      Implementer should not allow approve() to be executed if there is an overrride
1667     //       Implemented should return allowance() taking into account override
1668     function onAllowance(address owner, address spender)
1669         public
1670         constant
1671         returns (uint256 allowanceOverride);
1672 }
1673 
1674 /// @title hooks token controller to token contract and allows to replace it
1675 contract ITokenControllerHook {
1676 
1677     ////////////////////////
1678     // Events
1679     ////////////////////////
1680 
1681     event LogChangeTokenController(
1682         address oldController,
1683         address newController,
1684         address by
1685     );
1686 
1687     ////////////////////////
1688     // Public functions
1689     ////////////////////////
1690 
1691     /// @notice replace current token controller
1692     /// @dev please note that this process is also controlled by existing controller
1693     function changeTokenController(address newController)
1694         public;
1695 
1696     /// @notice returns current controller
1697     function tokenController()
1698         public
1699         constant
1700         returns (address currentController);
1701 
1702 }
1703 
1704 contract EuroToken is
1705     Agreement,
1706     IERC677Token,
1707     StandardToken,
1708     IWithdrawableToken,
1709     ITokenControllerHook,
1710     TokenMetadata,
1711     IERC223Token,
1712     IsContract,
1713     IContractId
1714 {
1715     ////////////////////////
1716     // Constants
1717     ////////////////////////
1718 
1719     string private constant NAME = "Euro Token";
1720 
1721     string private constant SYMBOL = "EUR-T";
1722 
1723     uint8 private constant DECIMALS = 18;
1724 
1725     ////////////////////////
1726     // Mutable state
1727     ////////////////////////
1728 
1729     ITokenController private _tokenController;
1730 
1731     ////////////////////////
1732     // Events
1733     ////////////////////////
1734 
1735     /// on each deposit (increase of supply) of EUR-T
1736     /// 'by' indicates account that executed the deposit function for 'to' (typically bank connector)
1737     event LogDeposit(
1738         address indexed to,
1739         address by,
1740         uint256 amount,
1741         bytes32 reference
1742     );
1743 
1744     // proof of requested deposit initiated by token holder
1745     event LogWithdrawal(
1746         address indexed from,
1747         uint256 amount
1748     );
1749 
1750     // proof of settled deposit
1751     event LogWithdrawSettled(
1752         address from,
1753         address by, // who settled
1754         uint256 amount, // settled amount, after fees, negative interest rates etc.
1755         uint256 originalAmount, // original amount withdrawn
1756         bytes32 withdrawTxHash, // hash of withdraw transaction
1757         bytes32 reference // reference number of withdraw operation at deposit manager
1758     );
1759 
1760     /// on destroying the tokens without withdraw (see `destroyTokens` function below)
1761     event LogDestroy(
1762         address indexed from,
1763         address by,
1764         uint256 amount
1765     );
1766 
1767     ////////////////////////
1768     // Modifiers
1769     ////////////////////////
1770 
1771     modifier onlyIfDepositAllowed(address to, uint256 amount) {
1772         require(_tokenController.onGenerateTokens(msg.sender, to, amount));
1773         _;
1774     }
1775 
1776     modifier onlyIfWithdrawAllowed(address from, uint256 amount) {
1777         require(_tokenController.onDestroyTokens(msg.sender, from, amount));
1778         _;
1779     }
1780 
1781     ////////////////////////
1782     // Constructor
1783     ////////////////////////
1784 
1785     constructor(
1786         IAccessPolicy accessPolicy,
1787         IEthereumForkArbiter forkArbiter,
1788         ITokenController tokenController
1789     )
1790         Agreement(accessPolicy, forkArbiter)
1791         StandardToken()
1792         TokenMetadata(NAME, DECIMALS, SYMBOL, "")
1793         public
1794     {
1795         require(tokenController != ITokenController(0x0));
1796         _tokenController = tokenController;
1797     }
1798 
1799     ////////////////////////
1800     // Public functions
1801     ////////////////////////
1802 
1803     /// @notice deposit 'amount' of EUR-T to address 'to', attaching correlating `reference` to LogDeposit event
1804     /// @dev deposit may happen only in case 'to' can receive transfer in token controller
1805     ///     by default KYC is required to receive deposits
1806     function deposit(address to, uint256 amount, bytes32 reference)
1807         public
1808         only(ROLE_EURT_DEPOSIT_MANAGER)
1809         onlyIfDepositAllowed(to, amount)
1810         acceptAgreement(to)
1811     {
1812         require(to != address(0));
1813         _balances[to] = add(_balances[to], amount);
1814         _totalSupply = add(_totalSupply, amount);
1815         emit LogDeposit(to, msg.sender, amount, reference);
1816         emit Transfer(address(0), to, amount);
1817     }
1818 
1819     /// @notice runs many deposits within one transaction
1820     /// @dev deposit may happen only in case 'to' can receive transfer in token controller
1821     ///     by default KYC is required to receive deposits
1822     function depositMany(address[] to, uint256[] amount, bytes32[] reference)
1823         public
1824     {
1825         require(to.length == amount.length);
1826         require(to.length == reference.length);
1827         for (uint256 i = 0; i < to.length; i++) {
1828             deposit(to[i], amount[i], reference[i]);
1829         }
1830     }
1831 
1832     /// @notice withdraws 'amount' of EUR-T by burning required amount and providing a proof of whithdrawal
1833     /// @dev proof is provided in form of log entry. based on that proof deposit manager will make a bank transfer
1834     ///     by default controller will check the following: KYC and existence of working bank account
1835     function withdraw(uint256 amount)
1836         public
1837         onlyIfWithdrawAllowed(msg.sender, amount)
1838         acceptAgreement(msg.sender)
1839     {
1840         destroyTokensPrivate(msg.sender, amount);
1841         emit LogWithdrawal(msg.sender, amount);
1842     }
1843 
1844     /// @notice issued by deposit manager when withdraw request was settled. typicaly amount that could be settled will be lower
1845     ///         than amount withdrawn: banks charge negative interest rates and various fees that must be deduced
1846     ///         reference number is attached that may be used to identify withdraw operation at deposit manager
1847     function settleWithdraw(address from, uint256 amount, uint256 originalAmount, bytes32 withdrawTxHash, bytes32 reference)
1848         public
1849         only(ROLE_EURT_DEPOSIT_MANAGER)
1850     {
1851         emit LogWithdrawSettled(from, msg.sender, amount, originalAmount, withdrawTxHash, reference);
1852     }
1853 
1854     /// @notice this method allows to destroy EUR-T belonging to any account
1855     ///     note that EURO is fiat currency and is not trustless, EUR-T is also
1856     ///     just internal currency of Neufund platform, not general purpose stable coin
1857     ///     we need to be able to destroy EUR-T if ordered by authorities
1858     function destroy(address owner, uint256 amount)
1859         public
1860         only(ROLE_EURT_LEGAL_MANAGER)
1861     {
1862         destroyTokensPrivate(owner, amount);
1863         emit LogDestroy(owner, msg.sender, amount);
1864     }
1865 
1866     //
1867     // Implements ITokenControllerHook
1868     //
1869 
1870     function changeTokenController(address newController)
1871         public
1872     {
1873         require(_tokenController.onChangeTokenController(msg.sender, newController));
1874         _tokenController = ITokenController(newController);
1875         emit LogChangeTokenController(_tokenController, newController, msg.sender);
1876     }
1877 
1878     function tokenController()
1879         public
1880         constant
1881         returns (address)
1882     {
1883         return _tokenController;
1884     }
1885 
1886     //
1887     // Implements IERC223Token
1888     //
1889     function transfer(address to, uint256 amount, bytes data)
1890         public
1891         returns (bool success)
1892     {
1893         return ierc223TransferInternal(msg.sender, to, amount, data);
1894     }
1895 
1896     /// @notice convenience function to deposit and immediately transfer amount
1897     /// @param depositTo which account to deposit to and then transfer from
1898     /// @param transferTo where to transfer after deposit
1899     /// @param depositAmount amount to deposit
1900     /// @param transferAmount total amount to transfer, must be <= balance after deposit
1901     /// @dev intended to deposit from bank account and invest in ETO
1902     function depositAndTransfer(
1903         address depositTo,
1904         address transferTo,
1905         uint256 depositAmount,
1906         uint256 transferAmount,
1907         bytes data,
1908         bytes32 reference
1909     )
1910         public
1911         returns (bool success)
1912     {
1913         deposit(depositTo, depositAmount, reference);
1914         return ierc223TransferInternal(depositTo, transferTo, transferAmount, data);
1915     }
1916 
1917     //
1918     // Implements IContractId
1919     //
1920 
1921     function contractId() public pure returns (bytes32 id, uint256 version) {
1922         return (0xfb5c7e43558c4f3f5a2d87885881c9b10ff4be37e3308579c178bf4eaa2c29cd, 0);
1923     }
1924 
1925     ////////////////////////
1926     // Internal functions
1927     ////////////////////////
1928 
1929     //
1930     // Implements MTokenController
1931     //
1932 
1933     function mOnTransfer(
1934         address from,
1935         address to,
1936         uint256 amount
1937     )
1938         internal
1939         acceptAgreement(from)
1940         returns (bool allow)
1941     {
1942         address broker = msg.sender;
1943         if (broker != from) {
1944             // if called by the depositor (deposit and send), ignore the broker flag
1945             bool isDepositor = accessPolicy().allowed(msg.sender, ROLE_EURT_DEPOSIT_MANAGER, this, msg.sig);
1946             // this is not very clean but alternative (give brokerage rights to all depositors) is maintenance hell
1947             if (isDepositor) {
1948                 broker = from;
1949             }
1950         }
1951         return _tokenController.onTransfer(broker, from, to, amount);
1952     }
1953 
1954     function mOnApprove(
1955         address owner,
1956         address spender,
1957         uint256 amount
1958     )
1959         internal
1960         acceptAgreement(owner)
1961         returns (bool allow)
1962     {
1963         return _tokenController.onApprove(owner, spender, amount);
1964     }
1965 
1966     function mAllowanceOverride(
1967         address owner,
1968         address spender
1969     )
1970         internal
1971         constant
1972         returns (uint256)
1973     {
1974         return _tokenController.onAllowance(owner, spender);
1975     }
1976 
1977     //
1978     // Observes MAgreement internal interface
1979     //
1980 
1981     /// @notice euro token is legally represented by separate entity ROLE_EURT_LEGAL_MANAGER
1982     function mCanAmend(address legalRepresentative)
1983         internal
1984         returns (bool)
1985     {
1986         return accessPolicy().allowed(legalRepresentative, ROLE_EURT_LEGAL_MANAGER, this, msg.sig);
1987     }
1988 
1989     ////////////////////////
1990     // Private functions
1991     ////////////////////////
1992 
1993     function destroyTokensPrivate(address owner, uint256 amount)
1994         private
1995     {
1996         require(_balances[owner] >= amount);
1997         _balances[owner] = sub(_balances[owner], amount);
1998         _totalSupply = sub(_totalSupply, amount);
1999         emit Transfer(owner, address(0), amount);
2000     }
2001 
2002     /// @notice internal transfer function that checks permissions and calls the tokenFallback
2003     function ierc223TransferInternal(address from, address to, uint256 amount, bytes data)
2004         private
2005         returns (bool success)
2006     {
2007         BasicToken.mTransfer(from, to, amount);
2008 
2009         // Notify the receiving contract.
2010         if (isContract(to)) {
2011             // in case of re-entry (1) transfer is done (2) msg.sender is different
2012             IERC223Callback(to).tokenFallback(from, amount, data);
2013         }
2014         return true;
2015     }
2016 }
2017 
2018 /// @title set terms of Platform (investor's network) of the ETO
2019 contract PlatformTerms is Math, IContractId {
2020 
2021     ////////////////////////
2022     // Constants
2023     ////////////////////////
2024 
2025     // fraction of fee deduced on successful ETO (see Math.sol for fraction definition)
2026     uint256 public constant PLATFORM_FEE_FRACTION = 3 * 10**16;
2027     // fraction of tokens deduced on succesful ETO
2028     uint256 public constant TOKEN_PARTICIPATION_FEE_FRACTION = 2 * 10**16;
2029     // share of Neumark reward platform operator gets
2030     // actually this is a divisor that splits Neumark reward in two parts
2031     // the results of division belongs to platform operator, the remaining reward part belongs to investor
2032     uint256 public constant PLATFORM_NEUMARK_SHARE = 2; // 50:50 division
2033     // ICBM investors whitelisted by default
2034     bool public constant IS_ICBM_INVESTOR_WHITELISTED = true;
2035 
2036     // minimum ticket size Platform accepts in EUR ULPS
2037     uint256 public constant MIN_TICKET_EUR_ULPS = 100 * 10**18;
2038     // maximum ticket size Platform accepts in EUR ULPS
2039     // no max ticket in general prospectus regulation
2040     // uint256 public constant MAX_TICKET_EUR_ULPS = 10000000 * 10**18;
2041 
2042     // min duration from setting the date to ETO start
2043     uint256 public constant DATE_TO_WHITELIST_MIN_DURATION = 7 days;
2044     // token rate expires after
2045     uint256 public constant TOKEN_RATE_EXPIRES_AFTER = 4 hours;
2046 
2047     // duration constraints
2048     uint256 public constant MIN_WHITELIST_DURATION = 0 days;
2049     uint256 public constant MAX_WHITELIST_DURATION = 30 days;
2050     uint256 public constant MIN_PUBLIC_DURATION = 0 days;
2051     uint256 public constant MAX_PUBLIC_DURATION = 60 days;
2052 
2053     // minimum length of whole offer
2054     uint256 public constant MIN_OFFER_DURATION = 1 days;
2055     // quarter should be enough for everyone
2056     uint256 public constant MAX_OFFER_DURATION = 90 days;
2057 
2058     uint256 public constant MIN_SIGNING_DURATION = 14 days;
2059     uint256 public constant MAX_SIGNING_DURATION = 60 days;
2060 
2061     uint256 public constant MIN_CLAIM_DURATION = 7 days;
2062     uint256 public constant MAX_CLAIM_DURATION = 30 days;
2063 
2064     // time after which claimable tokens become recycleable in fee disbursal pool
2065     uint256 public constant DEFAULT_DISBURSAL_RECYCLE_AFTER_DURATION = 4 * 365 days;
2066 
2067     ////////////////////////
2068     // Public Function
2069     ////////////////////////
2070 
2071     // calculates investor's and platform operator's neumarks from total reward
2072     function calculateNeumarkDistribution(uint256 rewardNmk)
2073         public
2074         pure
2075         returns (uint256 platformNmk, uint256 investorNmk)
2076     {
2077         // round down - platform may get 1 wei less than investor
2078         platformNmk = rewardNmk / PLATFORM_NEUMARK_SHARE;
2079         // rewardNmk > platformNmk always
2080         return (platformNmk, rewardNmk - platformNmk);
2081     }
2082 
2083     function calculatePlatformTokenFee(uint256 tokenAmount)
2084         public
2085         pure
2086         returns (uint256)
2087     {
2088         // mind tokens having 0 precision
2089         return proportion(tokenAmount, TOKEN_PARTICIPATION_FEE_FRACTION, 10**18);
2090     }
2091 
2092     function calculatePlatformFee(uint256 amount)
2093         public
2094         pure
2095         returns (uint256)
2096     {
2097         return decimalFraction(amount, PLATFORM_FEE_FRACTION);
2098     }
2099 
2100     //
2101     // Implements IContractId
2102     //
2103 
2104     function contractId() public pure returns (bytes32 id, uint256 version) {
2105         return (0x95482babc4e32de6c4dc3910ee7ae62c8e427efde6bc4e9ce0d6d93e24c39323, 1);
2106     }
2107 }
2108 
2109 /// @title serialization of basic types from/to bytes
2110 contract Serialization {
2111 
2112     ////////////////////////
2113     // Internal functions
2114     ////////////////////////
2115     function decodeAddress(bytes b)
2116         internal
2117         pure
2118         returns (address a)
2119     {
2120         require(b.length == 20);
2121         assembly {
2122             // load memory area that is address "carved out" of 64 byte bytes. prefix is zeroed
2123             a := and(mload(add(b, 20)), 0x00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
2124         }
2125     }
2126 
2127     function decodeAddressUInt256(bytes b)
2128         internal
2129         pure
2130         returns (address a, uint256 i)
2131     {
2132         require(b.length == 52);
2133         assembly {
2134             // load memory area that is address "carved out" of 64 byte bytes. prefix is zeroed
2135             a := and(mload(add(b, 20)), 0x00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
2136             i := mload(add(b, 52))
2137         }
2138     }
2139 }
2140 
2141 /// @title old ERC223 callback function
2142 /// @dev as used in Neumark and ICBMEtherToken
2143 contract IERC223LegacyCallback {
2144 
2145     ////////////////////////
2146     // Public functions
2147     ////////////////////////
2148 
2149     function onTokenTransfer(address from, uint256 amount, bytes data)
2150         public;
2151 
2152 }
2153 
2154 /// @title disburse payment token amount to snapshot token holders
2155 /// @dev payment token received via ERC223 Transfer
2156 contract IFeeDisbursal is IERC223Callback {
2157     // TODO: declare interface
2158     function claim() public;
2159 
2160     function recycle() public;
2161 }
2162 
2163 /// @title granular fee disbursal controller
2164 contract IFeeDisbursalController is
2165     IContractId
2166 {
2167 
2168 
2169     ////////////////////////
2170     // Public functions
2171     ////////////////////////
2172 
2173     /// @notice check whether claimer can accept disbursal offer
2174     function onAccept(address /*token*/, address /*proRataToken*/, address claimer)
2175         public
2176         constant
2177         returns (bool allow);
2178 
2179     /// @notice check whether claimer can reject disbursal offer
2180     function onReject(address /*token*/, address /*proRataToken*/, address claimer)
2181         public
2182         constant
2183         returns (bool allow);
2184 
2185     /// @notice check wether this disbursal can happen
2186     function onDisburse(address token, address disburser, uint256 amount, address proRataToken, uint256 recycleAfterPeriod)
2187         public
2188         constant
2189         returns (bool allow);
2190 
2191     /// @notice check wether this recycling can happen
2192     function onRecycle(address token, address /*proRataToken*/, address[] investors, uint256 until)
2193         public
2194         constant
2195         returns (bool allow);
2196 
2197     /// @notice check wether the disbursal controller may be changed
2198     function onChangeFeeDisbursalController(address sender, IFeeDisbursalController newController)
2199         public
2200         constant
2201         returns (bool);
2202 
2203 }
2204 
2205 /// @title access to snapshots of a token
2206 /// @notice allows to implement complex token holder rights like revenue disbursal or voting
2207 /// @notice snapshots are series of values with assigned ids. ids increase strictly. particular id mechanism is not assumed
2208 contract ITokenSnapshots {
2209 
2210     ////////////////////////
2211     // Public functions
2212     ////////////////////////
2213 
2214     /// @notice Total amount of tokens at a specific `snapshotId`.
2215     /// @param snapshotId of snapshot at which totalSupply is queried
2216     /// @return The total amount of tokens at `snapshotId`
2217     /// @dev reverts on snapshotIds greater than currentSnapshotId()
2218     /// @dev returns 0 for snapshotIds less than snapshotId of first value
2219     function totalSupplyAt(uint256 snapshotId)
2220         public
2221         constant
2222         returns(uint256);
2223 
2224     /// @dev Queries the balance of `owner` at a specific `snapshotId`
2225     /// @param owner The address from which the balance will be retrieved
2226     /// @param snapshotId of snapshot at which the balance is queried
2227     /// @return The balance at `snapshotId`
2228     function balanceOfAt(address owner, uint256 snapshotId)
2229         public
2230         constant
2231         returns (uint256);
2232 
2233     /// @notice upper bound of series of snapshotIds for which there's a value in series
2234     /// @return snapshotId
2235     function currentSnapshotId()
2236         public
2237         constant
2238         returns (uint256);
2239 }
2240 
2241 /// @title describes layout of claims in 256bit records stored for identities
2242 /// @dev intended to be derived by contracts requiring access to particular claims
2243 contract IdentityRecord {
2244 
2245     ////////////////////////
2246     // Types
2247     ////////////////////////
2248 
2249     /// @dev here the idea is to have claims of size of uint256 and use this struct
2250     ///     to translate in and out of this struct. until we do not cross uint256 we
2251     ///     have binary compatibility
2252     struct IdentityClaims {
2253         bool isVerified; // 1 bit
2254         bool isSophisticatedInvestor; // 1 bit
2255         bool hasBankAccount; // 1 bit
2256         bool accountFrozen; // 1 bit
2257         // uint252 reserved
2258     }
2259 
2260     ////////////////////////
2261     // Internal functions
2262     ////////////////////////
2263 
2264     /// translates uint256 to struct
2265     function deserializeClaims(bytes32 data) internal pure returns (IdentityClaims memory claims) {
2266         // for memory layout of struct, each field below word length occupies whole word
2267         assembly {
2268             mstore(claims, and(data, 0x1))
2269             mstore(add(claims, 0x20), div(and(data, 0x2), 0x2))
2270             mstore(add(claims, 0x40), div(and(data, 0x4), 0x4))
2271             mstore(add(claims, 0x60), div(and(data, 0x8), 0x8))
2272         }
2273     }
2274 }
2275 
2276 
2277 /// @title interface storing and retrieve 256bit claims records for identity
2278 /// actual format of record is decoupled from storage (except maximum size)
2279 contract IIdentityRegistry {
2280 
2281     ////////////////////////
2282     // Events
2283     ////////////////////////
2284 
2285     /// provides information on setting claims
2286     event LogSetClaims(
2287         address indexed identity,
2288         bytes32 oldClaims,
2289         bytes32 newClaims
2290     );
2291 
2292     ////////////////////////
2293     // Public functions
2294     ////////////////////////
2295 
2296     /// get claims for identity
2297     function getClaims(address identity) public constant returns (bytes32);
2298 
2299     /// set claims for identity
2300     /// @dev odlClaims and newClaims used for optimistic locking. to override with newClaims
2301     ///     current claims must be oldClaims
2302     function setClaims(address identity, bytes32 oldClaims, bytes32 newClaims) public;
2303 }
2304 
2305 contract NeumarkIssuanceCurve {
2306 
2307     ////////////////////////
2308     // Constants
2309     ////////////////////////
2310 
2311     // maximum number of neumarks that may be created
2312     uint256 private constant NEUMARK_CAP = 1500000000000000000000000000;
2313 
2314     // initial neumark reward fraction (controls curve steepness)
2315     uint256 private constant INITIAL_REWARD_FRACTION = 6500000000000000000;
2316 
2317     // stop issuing new Neumarks above this Euro value (as it goes quickly to zero)
2318     uint256 private constant ISSUANCE_LIMIT_EUR_ULPS = 8300000000000000000000000000;
2319 
2320     // approximate curve linearly above this Euro value
2321     uint256 private constant LINEAR_APPROX_LIMIT_EUR_ULPS = 2100000000000000000000000000;
2322     uint256 private constant NEUMARKS_AT_LINEAR_LIMIT_ULPS = 1499832501287264827896539871;
2323 
2324     uint256 private constant TOT_LINEAR_NEUMARKS_ULPS = NEUMARK_CAP - NEUMARKS_AT_LINEAR_LIMIT_ULPS;
2325     uint256 private constant TOT_LINEAR_EUR_ULPS = ISSUANCE_LIMIT_EUR_ULPS - LINEAR_APPROX_LIMIT_EUR_ULPS;
2326 
2327     ////////////////////////
2328     // Public functions
2329     ////////////////////////
2330 
2331     /// @notice returns additional amount of neumarks issued for euroUlps at totalEuroUlps
2332     /// @param totalEuroUlps actual curve position from which neumarks will be issued
2333     /// @param euroUlps amount against which neumarks will be issued
2334     function incremental(uint256 totalEuroUlps, uint256 euroUlps)
2335         public
2336         pure
2337         returns (uint256 neumarkUlps)
2338     {
2339         require(totalEuroUlps + euroUlps >= totalEuroUlps);
2340         uint256 from = cumulative(totalEuroUlps);
2341         uint256 to = cumulative(totalEuroUlps + euroUlps);
2342         // as expansion is not monotonic for large totalEuroUlps, assert below may fail
2343         // example: totalEuroUlps=1.999999999999999999999000000e+27 and euroUlps=50
2344         assert(to >= from);
2345         return to - from;
2346     }
2347 
2348     /// @notice returns amount of euro corresponding to burned neumarks
2349     /// @param totalEuroUlps actual curve position from which neumarks will be burned
2350     /// @param burnNeumarkUlps amount of neumarks to burn
2351     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps)
2352         public
2353         pure
2354         returns (uint256 euroUlps)
2355     {
2356         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
2357         require(totalNeumarkUlps >= burnNeumarkUlps);
2358         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
2359         uint newTotalEuroUlps = cumulativeInverse(fromNmk, 0, totalEuroUlps);
2360         // yes, this may overflow due to non monotonic inverse function
2361         assert(totalEuroUlps >= newTotalEuroUlps);
2362         return totalEuroUlps - newTotalEuroUlps;
2363     }
2364 
2365     /// @notice returns amount of euro corresponding to burned neumarks
2366     /// @param totalEuroUlps actual curve position from which neumarks will be burned
2367     /// @param burnNeumarkUlps amount of neumarks to burn
2368     /// @param minEurUlps euro amount to start inverse search from, inclusive
2369     /// @param maxEurUlps euro amount to end inverse search to, inclusive
2370     function incrementalInverse(uint256 totalEuroUlps, uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2371         public
2372         pure
2373         returns (uint256 euroUlps)
2374     {
2375         uint256 totalNeumarkUlps = cumulative(totalEuroUlps);
2376         require(totalNeumarkUlps >= burnNeumarkUlps);
2377         uint256 fromNmk = totalNeumarkUlps - burnNeumarkUlps;
2378         uint newTotalEuroUlps = cumulativeInverse(fromNmk, minEurUlps, maxEurUlps);
2379         // yes, this may overflow due to non monotonic inverse function
2380         assert(totalEuroUlps >= newTotalEuroUlps);
2381         return totalEuroUlps - newTotalEuroUlps;
2382     }
2383 
2384     /// @notice finds total amount of neumarks issued for given amount of Euro
2385     /// @dev binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
2386     ///     function below is not monotonic
2387     function cumulative(uint256 euroUlps)
2388         public
2389         pure
2390         returns(uint256 neumarkUlps)
2391     {
2392         // Return the cap if euroUlps is above the limit.
2393         if (euroUlps >= ISSUANCE_LIMIT_EUR_ULPS) {
2394             return NEUMARK_CAP;
2395         }
2396         // use linear approximation above limit below
2397         // binomial expansion does not guarantee monotonicity on uint256 precision for large euroUlps
2398         if (euroUlps >= LINEAR_APPROX_LIMIT_EUR_ULPS) {
2399             // (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS) is small so expression does not overflow
2400             return NEUMARKS_AT_LINEAR_LIMIT_ULPS + (TOT_LINEAR_NEUMARKS_ULPS * (euroUlps - LINEAR_APPROX_LIMIT_EUR_ULPS)) / TOT_LINEAR_EUR_ULPS;
2401         }
2402 
2403         // Approximate cap-cap·(1-1/D)^n using the Binomial expansion
2404         // http://galileo.phys.virginia.edu/classes/152.mf1i.spring02/Exponential_Function.htm
2405         // Function[imax, -CAP*Sum[(-IR*EUR/CAP)^i/Factorial[i], {i, imax}]]
2406         // which may be simplified to
2407         // Function[imax, -CAP*Sum[(EUR)^i/(Factorial[i]*(-d)^i), {i, 1, imax}]]
2408         // where d = cap/initial_reward
2409         uint256 d = 230769230769230769230769231; // NEUMARK_CAP / INITIAL_REWARD_FRACTION
2410         uint256 term = NEUMARK_CAP;
2411         uint256 sum = 0;
2412         uint256 denom = d;
2413         do assembly {
2414             // We use assembler primarily to avoid the expensive
2415             // divide-by-zero check solc inserts for the / operator.
2416             term  := div(mul(term, euroUlps), denom)
2417             sum   := add(sum, term)
2418             denom := add(denom, d)
2419             // sub next term as we have power of negative value in the binomial expansion
2420             term  := div(mul(term, euroUlps), denom)
2421             sum   := sub(sum, term)
2422             denom := add(denom, d)
2423         } while (term != 0);
2424         return sum;
2425     }
2426 
2427     /// @notice find issuance curve inverse by binary search
2428     /// @param neumarkUlps neumark amount to compute inverse for
2429     /// @param minEurUlps minimum search range for the inverse, inclusive
2430     /// @param maxEurUlps maxium search range for the inverse, inclusive
2431     /// @dev in case of approximate search (no exact inverse) upper element of minimal search range is returned
2432     /// @dev in case of many possible inverses, the lowest one will be used (if range permits)
2433     /// @dev corresponds to a linear search that returns first euroUlp value that has cumulative() equal or greater than neumarkUlps
2434     function cumulativeInverse(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
2435         public
2436         pure
2437         returns (uint256 euroUlps)
2438     {
2439         require(maxEurUlps >= minEurUlps);
2440         require(cumulative(minEurUlps) <= neumarkUlps);
2441         require(cumulative(maxEurUlps) >= neumarkUlps);
2442         uint256 min = minEurUlps;
2443         uint256 max = maxEurUlps;
2444 
2445         // Binary search
2446         while (max > min) {
2447             uint256 mid = (max + min) / 2;
2448             uint256 val = cumulative(mid);
2449             // exact solution should not be used, a late points of the curve when many euroUlps are needed to
2450             // increase by one nmkUlp this will lead to  "indeterministic" inverse values that depend on the initial min and max
2451             // and further binary division -> you can land at any of the euro value that is mapped to the same nmk value
2452             // with condition below removed, binary search will point to the lowest eur value possible which is good because it cannot be exploited even with 0 gas costs
2453             /* if (val == neumarkUlps) {
2454                 return mid;
2455             }*/
2456             // NOTE: approximate search (no inverse) must return upper element of the final range
2457             //  last step of approximate search is always (min, min+1) so new mid is (2*min+1)/2 => min
2458             //  so new min = mid + 1 = max which was upper range. and that ends the search
2459             // NOTE: when there are multiple inverses for the same neumarkUlps, the `max` will be dragged down
2460             //  by `max = mid` expression to the lowest eur value of inverse. works only for ranges that cover all points of multiple inverse
2461             if (val < neumarkUlps) {
2462                 min = mid + 1;
2463             } else {
2464                 max = mid;
2465             }
2466         }
2467         // NOTE: It is possible that there is no inverse
2468         //  for example curve(0) = 0 and curve(1) = 6, so
2469         //  there is no value y such that curve(y) = 5.
2470         //  When there is no inverse, we must return upper element of last search range.
2471         //  This has the effect of reversing the curve less when
2472         //  burning Neumarks. This ensures that Neumarks can always
2473         //  be burned. It also ensure that the total supply of Neumarks
2474         //  remains below the cap.
2475         return max;
2476     }
2477 
2478     function neumarkCap()
2479         public
2480         pure
2481         returns (uint256)
2482     {
2483         return NEUMARK_CAP;
2484     }
2485 
2486     function initialRewardFraction()
2487         public
2488         pure
2489         returns (uint256)
2490     {
2491         return INITIAL_REWARD_FRACTION;
2492     }
2493 }
2494 
2495 /// @title advances snapshot id on demand
2496 /// @dev see Snapshot folder for implementation examples ie. DailyAndSnapshotable contract
2497 contract ISnapshotable {
2498 
2499     ////////////////////////
2500     // Events
2501     ////////////////////////
2502 
2503     /// @dev should log each new snapshot id created, including snapshots created automatically via MSnapshotPolicy
2504     event LogSnapshotCreated(uint256 snapshotId);
2505 
2506     ////////////////////////
2507     // Public functions
2508     ////////////////////////
2509 
2510     /// always creates new snapshot id which gets returned
2511     /// however, there is no guarantee that any snapshot will be created with this id, this depends on the implementation of MSnaphotPolicy
2512     function createSnapshot()
2513         public
2514         returns (uint256);
2515 
2516     /// upper bound of series snapshotIds for which there's a value
2517     function currentSnapshotId()
2518         public
2519         constant
2520         returns (uint256);
2521 }
2522 
2523 /// @title Abstracts snapshot id creation logics
2524 /// @dev Mixin (internal interface) of the snapshot policy which abstracts snapshot id creation logics from Snapshot contract
2525 /// @dev to be implemented and such implementation should be mixed with Snapshot-derived contract, see EveryBlock for simplest example of implementation and StandardSnapshotToken
2526 contract MSnapshotPolicy {
2527 
2528     ////////////////////////
2529     // Internal functions
2530     ////////////////////////
2531 
2532     // The snapshot Ids need to be strictly increasing.
2533     // Whenever the snaspshot id changes, a new snapshot will be created.
2534     // As long as the same snapshot id is being returned, last snapshot will be updated as this indicates that snapshot id didn't change
2535     //
2536     // Values passed to `hasValueAt` and `valuteAt` are required
2537     // to be less or equal to `mCurrentSnapshotId()`.
2538     function mAdvanceSnapshotId()
2539         internal
2540         returns (uint256);
2541 
2542     // this is a version of mAdvanceSnapshotId that does not modify state but MUST return the same value
2543     // it is required to implement ITokenSnapshots interface cleanly
2544     function mCurrentSnapshotId()
2545         internal
2546         constant
2547         returns (uint256);
2548 
2549 }
2550 
2551 /// @title creates new snapshot id on each day boundary
2552 /// @dev snapshot id is unix timestamp of current day boundary
2553 contract Daily is MSnapshotPolicy {
2554 
2555     ////////////////////////
2556     // Constants
2557     ////////////////////////
2558 
2559     // Floor[2**128 / 1 days]
2560     uint256 private MAX_TIMESTAMP = 3938453320844195178974243141571391;
2561 
2562     ////////////////////////
2563     // Constructor
2564     ////////////////////////
2565 
2566     /// @param start snapshotId from which to start generating values, used to prevent cloning from incompatible schemes
2567     /// @dev start must be for the same day or 0, required for token cloning
2568     constructor(uint256 start) internal {
2569         // 0 is invalid value as we are past unix epoch
2570         if (start > 0) {
2571             uint256 base = dayBase(uint128(block.timestamp));
2572             // must be within current day base
2573             require(start >= base);
2574             // dayBase + 2**128 will not overflow as it is based on block.timestamp
2575             require(start < base + 2**128);
2576         }
2577     }
2578 
2579     ////////////////////////
2580     // Public functions
2581     ////////////////////////
2582 
2583     function snapshotAt(uint256 timestamp)
2584         public
2585         constant
2586         returns (uint256)
2587     {
2588         require(timestamp < MAX_TIMESTAMP);
2589 
2590         return dayBase(uint128(timestamp));
2591     }
2592 
2593     ////////////////////////
2594     // Internal functions
2595     ////////////////////////
2596 
2597     //
2598     // Implements MSnapshotPolicy
2599     //
2600 
2601     function mAdvanceSnapshotId()
2602         internal
2603         returns (uint256)
2604     {
2605         return mCurrentSnapshotId();
2606     }
2607 
2608     function mCurrentSnapshotId()
2609         internal
2610         constant
2611         returns (uint256)
2612     {
2613         // disregard overflows on block.timestamp, see MAX_TIMESTAMP
2614         return dayBase(uint128(block.timestamp));
2615     }
2616 
2617     function dayBase(uint128 timestamp)
2618         internal
2619         pure
2620         returns (uint256)
2621     {
2622         // Round down to the start of the day (00:00 UTC) and place in higher 128bits
2623         return 2**128 * (uint256(timestamp) / 1 days);
2624     }
2625 }
2626 
2627 /// @title creates snapshot id on each day boundary and allows to create additional snapshots within a given day
2628 /// @dev snapshots are encoded in single uint256, where high 128 bits represents a day number (from unix epoch) and low 128 bits represents additional snapshots within given day create via ISnapshotable
2629 contract DailyAndSnapshotable is
2630     Daily,
2631     ISnapshotable
2632 {
2633 
2634     ////////////////////////
2635     // Mutable state
2636     ////////////////////////
2637 
2638     uint256 private _currentSnapshotId;
2639 
2640     ////////////////////////
2641     // Constructor
2642     ////////////////////////
2643 
2644     /// @param start snapshotId from which to start generating values
2645     /// @dev start must be for the same day or 0, required for token cloning
2646     constructor(uint256 start)
2647         internal
2648         Daily(start)
2649     {
2650         if (start > 0) {
2651             _currentSnapshotId = start;
2652         }
2653     }
2654 
2655     ////////////////////////
2656     // Public functions
2657     ////////////////////////
2658 
2659     //
2660     // Implements ISnapshotable
2661     //
2662 
2663     function createSnapshot()
2664         public
2665         returns (uint256)
2666     {
2667         uint256 base = dayBase(uint128(block.timestamp));
2668 
2669         if (base > _currentSnapshotId) {
2670             // New day has started, create snapshot for midnight
2671             _currentSnapshotId = base;
2672         } else {
2673             // within single day, increase counter (assume 2**128 will not be crossed)
2674             _currentSnapshotId += 1;
2675         }
2676 
2677         // Log and return
2678         emit LogSnapshotCreated(_currentSnapshotId);
2679         return _currentSnapshotId;
2680     }
2681 
2682     ////////////////////////
2683     // Internal functions
2684     ////////////////////////
2685 
2686     //
2687     // Implements MSnapshotPolicy
2688     //
2689 
2690     function mAdvanceSnapshotId()
2691         internal
2692         returns (uint256)
2693     {
2694         uint256 base = dayBase(uint128(block.timestamp));
2695 
2696         // New day has started
2697         if (base > _currentSnapshotId) {
2698             _currentSnapshotId = base;
2699             emit LogSnapshotCreated(base);
2700         }
2701 
2702         return _currentSnapshotId;
2703     }
2704 
2705     function mCurrentSnapshotId()
2706         internal
2707         constant
2708         returns (uint256)
2709     {
2710         uint256 base = dayBase(uint128(block.timestamp));
2711 
2712         return base > _currentSnapshotId ? base : _currentSnapshotId;
2713     }
2714 }
2715 
2716 /// @title Reads and writes snapshots
2717 /// @dev Manages reading and writing a series of values, where each value has assigned a snapshot id for access to historical data
2718 /// @dev may be added to any contract to provide snapshotting mechanism. should be mixed in with any of MSnapshotPolicy implementations to customize snapshot creation mechanics
2719 ///     observes MSnapshotPolicy
2720 /// based on MiniMe token
2721 contract Snapshot is MSnapshotPolicy {
2722 
2723     ////////////////////////
2724     // Types
2725     ////////////////////////
2726 
2727     /// @dev `Values` is the structure that attaches a snapshot id to a
2728     ///  given value, the snapshot id attached is the one that last changed the
2729     ///  value
2730     struct Values {
2731 
2732         // `snapshotId` is the snapshot id that the value was generated at
2733         uint256 snapshotId;
2734 
2735         // `value` at a specific snapshot id
2736         uint256 value;
2737     }
2738 
2739     ////////////////////////
2740     // Internal functions
2741     ////////////////////////
2742 
2743     function hasValue(
2744         Values[] storage values
2745     )
2746         internal
2747         constant
2748         returns (bool)
2749     {
2750         return values.length > 0;
2751     }
2752 
2753     /// @dev makes sure that 'snapshotId' between current snapshot id (mCurrentSnapshotId) and first snapshot id. this guarantees that getValueAt returns value from one of the snapshots.
2754     function hasValueAt(
2755         Values[] storage values,
2756         uint256 snapshotId
2757     )
2758         internal
2759         constant
2760         returns (bool)
2761     {
2762         require(snapshotId <= mCurrentSnapshotId());
2763         return values.length > 0 && values[0].snapshotId <= snapshotId;
2764     }
2765 
2766     /// gets last value in the series
2767     function getValue(
2768         Values[] storage values,
2769         uint256 defaultValue
2770     )
2771         internal
2772         constant
2773         returns (uint256)
2774     {
2775         if (values.length == 0) {
2776             return defaultValue;
2777         } else {
2778             uint256 last = values.length - 1;
2779             return values[last].value;
2780         }
2781     }
2782 
2783     /// @dev `getValueAt` retrieves value at a given snapshot id
2784     /// @param values The series of values being queried
2785     /// @param snapshotId Snapshot id to retrieve the value at
2786     /// @return Value in series being queried
2787     function getValueAt(
2788         Values[] storage values,
2789         uint256 snapshotId,
2790         uint256 defaultValue
2791     )
2792         internal
2793         constant
2794         returns (uint256)
2795     {
2796         require(snapshotId <= mCurrentSnapshotId());
2797 
2798         // Empty value
2799         if (values.length == 0) {
2800             return defaultValue;
2801         }
2802 
2803         // Shortcut for the out of bounds snapshots
2804         uint256 last = values.length - 1;
2805         uint256 lastSnapshot = values[last].snapshotId;
2806         if (snapshotId >= lastSnapshot) {
2807             return values[last].value;
2808         }
2809         uint256 firstSnapshot = values[0].snapshotId;
2810         if (snapshotId < firstSnapshot) {
2811             return defaultValue;
2812         }
2813         // Binary search of the value in the array
2814         uint256 min = 0;
2815         uint256 max = last;
2816         while (max > min) {
2817             uint256 mid = (max + min + 1) / 2;
2818             // must always return lower indice for approximate searches
2819             if (values[mid].snapshotId <= snapshotId) {
2820                 min = mid;
2821             } else {
2822                 max = mid - 1;
2823             }
2824         }
2825         return values[min].value;
2826     }
2827 
2828     /// @dev `setValue` used to update sequence at next snapshot
2829     /// @param values The sequence being updated
2830     /// @param value The new last value of sequence
2831     function setValue(
2832         Values[] storage values,
2833         uint256 value
2834     )
2835         internal
2836     {
2837         // TODO: simplify or break into smaller functions
2838 
2839         uint256 currentSnapshotId = mAdvanceSnapshotId();
2840         // Always create a new entry if there currently is no value
2841         bool empty = values.length == 0;
2842         if (empty) {
2843             // Create a new entry
2844             values.push(
2845                 Values({
2846                     snapshotId: currentSnapshotId,
2847                     value: value
2848                 })
2849             );
2850             return;
2851         }
2852 
2853         uint256 last = values.length - 1;
2854         bool hasNewSnapshot = values[last].snapshotId < currentSnapshotId;
2855         if (hasNewSnapshot) {
2856 
2857             // Do nothing if the value was not modified
2858             bool unmodified = values[last].value == value;
2859             if (unmodified) {
2860                 return;
2861             }
2862 
2863             // Create new entry
2864             values.push(
2865                 Values({
2866                     snapshotId: currentSnapshotId,
2867                     value: value
2868                 })
2869             );
2870         } else {
2871 
2872             // We are updating the currentSnapshotId
2873             bool previousUnmodified = last > 0 && values[last - 1].value == value;
2874             if (previousUnmodified) {
2875                 // Remove current snapshot if current value was set to previous value
2876                 delete values[last];
2877                 values.length--;
2878                 return;
2879             }
2880 
2881             // Overwrite next snapshot entry
2882             values[last].value = value;
2883         }
2884     }
2885 }
2886 
2887 /// @title represents link between cloned and parent token
2888 /// @dev when token is clone from other token, initial balances of the cloned token
2889 ///     correspond to balances of parent token at the moment of parent snapshot id specified
2890 /// @notice please note that other tokens beside snapshot token may be cloned
2891 contract IClonedTokenParent is ITokenSnapshots {
2892 
2893     ////////////////////////
2894     // Public functions
2895     ////////////////////////
2896 
2897 
2898     /// @return address of parent token, address(0) if root
2899     /// @dev parent token does not need to clonable, nor snapshottable, just a normal token
2900     function parentToken()
2901         public
2902         constant
2903         returns(IClonedTokenParent parent);
2904 
2905     /// @return snapshot at wchich initial token distribution was taken
2906     function parentSnapshotId()
2907         public
2908         constant
2909         returns(uint256 snapshotId);
2910 }
2911 
2912 /// @title token with snapshots and transfer functionality
2913 /// @dev observes MTokenTransferController interface
2914 ///     observes ISnapshotToken interface
2915 ///     implementes MTokenTransfer interface
2916 contract BasicSnapshotToken is
2917     MTokenTransfer,
2918     MTokenTransferController,
2919     IClonedTokenParent,
2920     IBasicToken,
2921     Snapshot
2922 {
2923     ////////////////////////
2924     // Immutable state
2925     ////////////////////////
2926 
2927     // `PARENT_TOKEN` is the Token address that was cloned to produce this token;
2928     //  it will be 0x0 for a token that was not cloned
2929     IClonedTokenParent private PARENT_TOKEN;
2930 
2931     // `PARENT_SNAPSHOT_ID` is the snapshot id from the Parent Token that was
2932     //  used to determine the initial distribution of the cloned token
2933     uint256 private PARENT_SNAPSHOT_ID;
2934 
2935     ////////////////////////
2936     // Mutable state
2937     ////////////////////////
2938 
2939     // `balances` is the map that tracks the balance of each address, in this
2940     //  contract when the balance changes the snapshot id that the change
2941     //  occurred is also included in the map
2942     mapping (address => Values[]) internal _balances;
2943 
2944     // Tracks the history of the `totalSupply` of the token
2945     Values[] internal _totalSupplyValues;
2946 
2947     ////////////////////////
2948     // Constructor
2949     ////////////////////////
2950 
2951     /// @notice Constructor to create snapshot token
2952     /// @param parentToken Address of the parent token, set to 0x0 if it is a
2953     ///  new token
2954     /// @param parentSnapshotId at which snapshot id clone was created, set to 0 to clone at upper bound
2955     /// @dev please not that as long as cloned token does not overwrite value at current snapshot id, it will refer
2956     ///     to parent token at which this snapshot still may change until snapshot id increases. for that time tokens are coupled
2957     ///     this is prevented by parentSnapshotId value of parentToken.currentSnapshotId() - 1 being the maxiumum
2958     ///     see SnapshotToken.js test to learn consequences coupling has.
2959     constructor(
2960         IClonedTokenParent parentToken,
2961         uint256 parentSnapshotId
2962     )
2963         Snapshot()
2964         internal
2965     {
2966         PARENT_TOKEN = parentToken;
2967         if (parentToken == address(0)) {
2968             require(parentSnapshotId == 0);
2969         } else {
2970             if (parentSnapshotId == 0) {
2971                 require(parentToken.currentSnapshotId() > 0);
2972                 PARENT_SNAPSHOT_ID = parentToken.currentSnapshotId() - 1;
2973             } else {
2974                 PARENT_SNAPSHOT_ID = parentSnapshotId;
2975             }
2976         }
2977     }
2978 
2979     ////////////////////////
2980     // Public functions
2981     ////////////////////////
2982 
2983     //
2984     // Implements IBasicToken
2985     //
2986 
2987     /// @dev This function makes it easy to get the total number of tokens
2988     /// @return The total number of tokens
2989     function totalSupply()
2990         public
2991         constant
2992         returns (uint256)
2993     {
2994         return totalSupplyAtInternal(mCurrentSnapshotId());
2995     }
2996 
2997     /// @param owner The address that's balance is being requested
2998     /// @return The balance of `owner` at the current block
2999     function balanceOf(address owner)
3000         public
3001         constant
3002         returns (uint256 balance)
3003     {
3004         return balanceOfAtInternal(owner, mCurrentSnapshotId());
3005     }
3006 
3007     /// @notice Send `amount` tokens to `to` from `msg.sender`
3008     /// @param to The address of the recipient
3009     /// @param amount The amount of tokens to be transferred
3010     /// @return True if the transfer was successful, reverts in any other case
3011     function transfer(address to, uint256 amount)
3012         public
3013         returns (bool success)
3014     {
3015         mTransfer(msg.sender, to, amount);
3016         return true;
3017     }
3018 
3019     //
3020     // Implements ITokenSnapshots
3021     //
3022 
3023     function totalSupplyAt(uint256 snapshotId)
3024         public
3025         constant
3026         returns(uint256)
3027     {
3028         return totalSupplyAtInternal(snapshotId);
3029     }
3030 
3031     function balanceOfAt(address owner, uint256 snapshotId)
3032         public
3033         constant
3034         returns (uint256)
3035     {
3036         return balanceOfAtInternal(owner, snapshotId);
3037     }
3038 
3039     function currentSnapshotId()
3040         public
3041         constant
3042         returns (uint256)
3043     {
3044         return mCurrentSnapshotId();
3045     }
3046 
3047     //
3048     // Implements IClonedTokenParent
3049     //
3050 
3051     function parentToken()
3052         public
3053         constant
3054         returns(IClonedTokenParent parent)
3055     {
3056         return PARENT_TOKEN;
3057     }
3058 
3059     /// @return snapshot at wchich initial token distribution was taken
3060     function parentSnapshotId()
3061         public
3062         constant
3063         returns(uint256 snapshotId)
3064     {
3065         return PARENT_SNAPSHOT_ID;
3066     }
3067 
3068     //
3069     // Other public functions
3070     //
3071 
3072     /// @notice gets all token balances of 'owner'
3073     /// @dev intended to be called via eth_call where gas limit is not an issue
3074     function allBalancesOf(address owner)
3075         external
3076         constant
3077         returns (uint256[2][])
3078     {
3079         /* very nice and working implementation below,
3080         // copy to memory
3081         Values[] memory values = _balances[owner];
3082         do assembly {
3083             // in memory structs have simple layout where every item occupies uint256
3084             balances := values
3085         } while (false);*/
3086 
3087         Values[] storage values = _balances[owner];
3088         uint256[2][] memory balances = new uint256[2][](values.length);
3089         for(uint256 ii = 0; ii < values.length; ++ii) {
3090             balances[ii] = [values[ii].snapshotId, values[ii].value];
3091         }
3092 
3093         return balances;
3094     }
3095 
3096     ////////////////////////
3097     // Internal functions
3098     ////////////////////////
3099 
3100     function totalSupplyAtInternal(uint256 snapshotId)
3101         internal
3102         constant
3103         returns(uint256)
3104     {
3105         Values[] storage values = _totalSupplyValues;
3106 
3107         // If there is a value, return it, reverts if value is in the future
3108         if (hasValueAt(values, snapshotId)) {
3109             return getValueAt(values, snapshotId, 0);
3110         }
3111 
3112         // Try parent contract at or before the fork
3113         if (address(PARENT_TOKEN) != 0) {
3114             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
3115             return PARENT_TOKEN.totalSupplyAt(earlierSnapshotId);
3116         }
3117 
3118         // Default to an empty balance
3119         return 0;
3120     }
3121 
3122     // get balance at snapshot if with continuation in parent token
3123     function balanceOfAtInternal(address owner, uint256 snapshotId)
3124         internal
3125         constant
3126         returns (uint256)
3127     {
3128         Values[] storage values = _balances[owner];
3129 
3130         // If there is a value, return it, reverts if value is in the future
3131         if (hasValueAt(values, snapshotId)) {
3132             return getValueAt(values, snapshotId, 0);
3133         }
3134 
3135         // Try parent contract at or before the fork
3136         if (PARENT_TOKEN != address(0)) {
3137             uint256 earlierSnapshotId = PARENT_SNAPSHOT_ID > snapshotId ? snapshotId : PARENT_SNAPSHOT_ID;
3138             return PARENT_TOKEN.balanceOfAt(owner, earlierSnapshotId);
3139         }
3140 
3141         // Default to an empty balance
3142         return 0;
3143     }
3144 
3145     //
3146     // Implements MTokenTransfer
3147     //
3148 
3149     /// @dev This is the actual transfer function in the token contract, it can
3150     ///  only be called by other functions in this contract.
3151     /// @param from The address holding the tokens being transferred
3152     /// @param to The address of the recipient
3153     /// @param amount The amount of tokens to be transferred
3154     /// @return True if the transfer was successful, reverts in any other case
3155     function mTransfer(
3156         address from,
3157         address to,
3158         uint256 amount
3159     )
3160         internal
3161     {
3162         // never send to address 0
3163         require(to != address(0));
3164         // block transfers in clone that points to future/current snapshots of parent token
3165         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
3166         // Alerts the token controller of the transfer
3167         require(mOnTransfer(from, to, amount));
3168 
3169         // If the amount being transfered is more than the balance of the
3170         //  account the transfer reverts
3171         uint256 previousBalanceFrom = balanceOf(from);
3172         require(previousBalanceFrom >= amount);
3173 
3174         // First update the balance array with the new value for the address
3175         //  sending the tokens
3176         uint256 newBalanceFrom = previousBalanceFrom - amount;
3177         setValue(_balances[from], newBalanceFrom);
3178 
3179         // Then update the balance array with the new value for the address
3180         //  receiving the tokens
3181         uint256 previousBalanceTo = balanceOf(to);
3182         uint256 newBalanceTo = previousBalanceTo + amount;
3183         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
3184         setValue(_balances[to], newBalanceTo);
3185 
3186         // An event to make the transfer easy to find on the blockchain
3187         emit Transfer(from, to, amount);
3188     }
3189 }
3190 
3191 /// @title token generation and destruction
3192 /// @dev internal interface providing token generation and destruction, see MintableSnapshotToken for implementation
3193 contract MTokenMint {
3194 
3195     ////////////////////////
3196     // Internal functions
3197     ////////////////////////
3198 
3199     /// @notice Generates `amount` tokens that are assigned to `owner`
3200     /// @param owner The address that will be assigned the new tokens
3201     /// @param amount The quantity of tokens generated
3202     /// @dev reverts if tokens could not be generated
3203     function mGenerateTokens(address owner, uint256 amount)
3204         internal;
3205 
3206     /// @notice Burns `amount` tokens from `owner`
3207     /// @param owner The address that will lose the tokens
3208     /// @param amount The quantity of tokens to burn
3209     /// @dev reverts if tokens could not be destroyed
3210     function mDestroyTokens(address owner, uint256 amount)
3211         internal;
3212 }
3213 
3214 /// @title basic snapshot token with facitilites to generate and destroy tokens
3215 /// @dev implementes MTokenMint, does not expose any public functions that create/destroy tokens
3216 contract MintableSnapshotToken is
3217     BasicSnapshotToken,
3218     MTokenMint
3219 {
3220 
3221     ////////////////////////
3222     // Constructor
3223     ////////////////////////
3224 
3225     /// @notice Constructor to create a MintableSnapshotToken
3226     /// @param parentToken Address of the parent token, set to 0x0 if it is a
3227     ///  new token
3228     constructor(
3229         IClonedTokenParent parentToken,
3230         uint256 parentSnapshotId
3231     )
3232         BasicSnapshotToken(parentToken, parentSnapshotId)
3233         internal
3234     {}
3235 
3236     /// @notice Generates `amount` tokens that are assigned to `owner`
3237     /// @param owner The address that will be assigned the new tokens
3238     /// @param amount The quantity of tokens generated
3239     function mGenerateTokens(address owner, uint256 amount)
3240         internal
3241     {
3242         // never create for address 0
3243         require(owner != address(0));
3244         // block changes in clone that points to future/current snapshots of patent token
3245         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
3246 
3247         uint256 curTotalSupply = totalSupply();
3248         uint256 newTotalSupply = curTotalSupply + amount;
3249         require(newTotalSupply >= curTotalSupply); // Check for overflow
3250 
3251         uint256 previousBalanceTo = balanceOf(owner);
3252         uint256 newBalanceTo = previousBalanceTo + amount;
3253         assert(newBalanceTo >= previousBalanceTo); // Check for overflow
3254 
3255         setValue(_totalSupplyValues, newTotalSupply);
3256         setValue(_balances[owner], newBalanceTo);
3257 
3258         emit Transfer(0, owner, amount);
3259     }
3260 
3261     /// @notice Burns `amount` tokens from `owner`
3262     /// @param owner The address that will lose the tokens
3263     /// @param amount The quantity of tokens to burn
3264     function mDestroyTokens(address owner, uint256 amount)
3265         internal
3266     {
3267         // block changes in clone that points to future/current snapshots of patent token
3268         require(parentToken() == address(0) || parentSnapshotId() < parentToken().currentSnapshotId());
3269 
3270         uint256 curTotalSupply = totalSupply();
3271         require(curTotalSupply >= amount);
3272 
3273         uint256 previousBalanceFrom = balanceOf(owner);
3274         require(previousBalanceFrom >= amount);
3275 
3276         uint256 newTotalSupply = curTotalSupply - amount;
3277         uint256 newBalanceFrom = previousBalanceFrom - amount;
3278         setValue(_totalSupplyValues, newTotalSupply);
3279         setValue(_balances[owner], newBalanceFrom);
3280 
3281         emit Transfer(owner, 0, amount);
3282     }
3283 }
3284 
3285 /*
3286     Copyright 2016, Jordi Baylina
3287     Copyright 2017, Remco Bloemen, Marcin Rudolf
3288 
3289     This program is free software: you can redistribute it and/or modify
3290     it under the terms of the GNU General Public License as published by
3291     the Free Software Foundation, either version 3 of the License, or
3292     (at your option) any later version.
3293 
3294     This program is distributed in the hope that it will be useful,
3295     but WITHOUT ANY WARRANTY; without even the implied warranty of
3296     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
3297     GNU General Public License for more details.
3298 
3299     You should have received a copy of the GNU General Public License
3300     along with this program.  If not, see <http://www.gnu.org/licenses/>.
3301  */
3302 /// @title StandardSnapshotToken Contract
3303 /// @author Jordi Baylina, Remco Bloemen, Marcin Rudolf
3304 /// @dev This token contract's goal is to make it easy for anyone to clone this
3305 ///  token using the token distribution at a given block, this will allow DAO's
3306 ///  and DApps to upgrade their features in a decentralized manner without
3307 ///  affecting the original token
3308 /// @dev It is ERC20 compliant, but still needs to under go further testing.
3309 /// @dev Various contracts are composed to provide required functionality of this token, different compositions are possible
3310 ///     MintableSnapshotToken provides transfer, miniting and snapshotting functions
3311 ///     TokenAllowance provides approve/transferFrom functions
3312 ///     TokenMetadata adds name, symbol and other token metadata
3313 /// @dev This token is still abstract, Snapshot, BasicSnapshotToken and TokenAllowance observe interfaces that must be implemented
3314 ///     MSnapshotPolicy - particular snapshot id creation mechanism
3315 ///     MTokenController - controlls approvals and transfers
3316 ///     see Neumark as an example
3317 /// @dev implements ERC223 token transfer
3318 contract StandardSnapshotToken is
3319     MintableSnapshotToken,
3320     TokenAllowance
3321 {
3322     ////////////////////////
3323     // Constructor
3324     ////////////////////////
3325 
3326     /// @notice Constructor to create a MiniMeToken
3327     ///  is a new token
3328     /// param tokenName Name of the new token
3329     /// param decimalUnits Number of decimals of the new token
3330     /// param tokenSymbol Token Symbol for the new token
3331     constructor(
3332         IClonedTokenParent parentToken,
3333         uint256 parentSnapshotId
3334     )
3335         MintableSnapshotToken(parentToken, parentSnapshotId)
3336         TokenAllowance()
3337         internal
3338     {}
3339 }
3340 
3341 contract Neumark is
3342     AccessControlled,
3343     AccessRoles,
3344     Agreement,
3345     DailyAndSnapshotable,
3346     StandardSnapshotToken,
3347     TokenMetadata,
3348     IERC223Token,
3349     NeumarkIssuanceCurve,
3350     Reclaimable,
3351     IsContract
3352 {
3353 
3354     ////////////////////////
3355     // Constants
3356     ////////////////////////
3357 
3358     string private constant TOKEN_NAME = "Neumark";
3359 
3360     uint8  private constant TOKEN_DECIMALS = 18;
3361 
3362     string private constant TOKEN_SYMBOL = "NEU";
3363 
3364     string private constant VERSION = "NMK_1.0";
3365 
3366     ////////////////////////
3367     // Mutable state
3368     ////////////////////////
3369 
3370     // disable transfers when Neumark is created
3371     bool private _transferEnabled = false;
3372 
3373     // at which point on curve new Neumarks will be created, see NeumarkIssuanceCurve contract
3374     // do not use to get total invested funds. see burn(). this is just a cache for expensive inverse function
3375     uint256 private _totalEurUlps;
3376 
3377     ////////////////////////
3378     // Events
3379     ////////////////////////
3380 
3381     event LogNeumarksIssued(
3382         address indexed owner,
3383         uint256 euroUlps,
3384         uint256 neumarkUlps
3385     );
3386 
3387     event LogNeumarksBurned(
3388         address indexed owner,
3389         uint256 euroUlps,
3390         uint256 neumarkUlps
3391     );
3392 
3393     ////////////////////////
3394     // Constructor
3395     ////////////////////////
3396 
3397     constructor(
3398         IAccessPolicy accessPolicy,
3399         IEthereumForkArbiter forkArbiter
3400     )
3401         AccessRoles()
3402         Agreement(accessPolicy, forkArbiter)
3403         StandardSnapshotToken(
3404             IClonedTokenParent(0x0),
3405             0
3406         )
3407         TokenMetadata(
3408             TOKEN_NAME,
3409             TOKEN_DECIMALS,
3410             TOKEN_SYMBOL,
3411             VERSION
3412         )
3413         DailyAndSnapshotable(0)
3414         NeumarkIssuanceCurve()
3415         Reclaimable()
3416         public
3417     {}
3418 
3419     ////////////////////////
3420     // Public functions
3421     ////////////////////////
3422 
3423     /// @notice issues new Neumarks to msg.sender with reward at current curve position
3424     ///     moves curve position by euroUlps
3425     ///     callable only by ROLE_NEUMARK_ISSUER
3426     function issueForEuro(uint256 euroUlps)
3427         public
3428         only(ROLE_NEUMARK_ISSUER)
3429         acceptAgreement(msg.sender)
3430         returns (uint256)
3431     {
3432         require(_totalEurUlps + euroUlps >= _totalEurUlps);
3433         uint256 neumarkUlps = incremental(_totalEurUlps, euroUlps);
3434         _totalEurUlps += euroUlps;
3435         mGenerateTokens(msg.sender, neumarkUlps);
3436         emit LogNeumarksIssued(msg.sender, euroUlps, neumarkUlps);
3437         return neumarkUlps;
3438     }
3439 
3440     /// @notice used by ROLE_NEUMARK_ISSUER to transer newly issued neumarks
3441     ///     typically to the investor and platform operator
3442     function distribute(address to, uint256 neumarkUlps)
3443         public
3444         only(ROLE_NEUMARK_ISSUER)
3445         acceptAgreement(to)
3446     {
3447         mTransfer(msg.sender, to, neumarkUlps);
3448     }
3449 
3450     /// @notice msg.sender can burn their Neumarks, curve is rolled back using inverse
3451     ///     curve. as a result cost of Neumark gets lower (reward is higher)
3452     function burn(uint256 neumarkUlps)
3453         public
3454         only(ROLE_NEUMARK_BURNER)
3455     {
3456         burnPrivate(neumarkUlps, 0, _totalEurUlps);
3457     }
3458 
3459     /// @notice executes as function above but allows to provide search range for low gas burning
3460     function burn(uint256 neumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
3461         public
3462         only(ROLE_NEUMARK_BURNER)
3463     {
3464         burnPrivate(neumarkUlps, minEurUlps, maxEurUlps);
3465     }
3466 
3467     function enableTransfer(bool enabled)
3468         public
3469         only(ROLE_TRANSFER_ADMIN)
3470     {
3471         _transferEnabled = enabled;
3472     }
3473 
3474     function createSnapshot()
3475         public
3476         only(ROLE_SNAPSHOT_CREATOR)
3477         returns (uint256)
3478     {
3479         return DailyAndSnapshotable.createSnapshot();
3480     }
3481 
3482     function transferEnabled()
3483         public
3484         constant
3485         returns (bool)
3486     {
3487         return _transferEnabled;
3488     }
3489 
3490     function totalEuroUlps()
3491         public
3492         constant
3493         returns (uint256)
3494     {
3495         return _totalEurUlps;
3496     }
3497 
3498     function incremental(uint256 euroUlps)
3499         public
3500         constant
3501         returns (uint256 neumarkUlps)
3502     {
3503         return incremental(_totalEurUlps, euroUlps);
3504     }
3505 
3506     //
3507     // Implements IERC223Token with IERC223Callback (onTokenTransfer) callback
3508     //
3509 
3510     // old implementation of ERC223 that was actual when ICBM was deployed
3511     // as Neumark is already deployed this function keeps old behavior for testing
3512     function transfer(address to, uint256 amount, bytes data)
3513         public
3514         returns (bool)
3515     {
3516         // it is necessary to point out implementation to be called
3517         BasicSnapshotToken.mTransfer(msg.sender, to, amount);
3518 
3519         // Notify the receiving contract.
3520         if (isContract(to)) {
3521             IERC223LegacyCallback(to).onTokenTransfer(msg.sender, amount, data);
3522         }
3523         return true;
3524     }
3525 
3526     ////////////////////////
3527     // Internal functions
3528     ////////////////////////
3529 
3530     //
3531     // Implements MTokenController
3532     //
3533 
3534     function mOnTransfer(
3535         address from,
3536         address, // to
3537         uint256 // amount
3538     )
3539         internal
3540         acceptAgreement(from)
3541         returns (bool allow)
3542     {
3543         // must have transfer enabled or msg.sender is Neumark issuer
3544         return _transferEnabled || accessPolicy().allowed(msg.sender, ROLE_NEUMARK_ISSUER, this, msg.sig);
3545     }
3546 
3547     function mOnApprove(
3548         address owner,
3549         address, // spender,
3550         uint256 // amount
3551     )
3552         internal
3553         acceptAgreement(owner)
3554         returns (bool allow)
3555     {
3556         return true;
3557     }
3558 
3559     ////////////////////////
3560     // Private functions
3561     ////////////////////////
3562 
3563     function burnPrivate(uint256 burnNeumarkUlps, uint256 minEurUlps, uint256 maxEurUlps)
3564         private
3565     {
3566         uint256 prevEuroUlps = _totalEurUlps;
3567         // burn first in the token to make sure balance/totalSupply is not crossed
3568         mDestroyTokens(msg.sender, burnNeumarkUlps);
3569         _totalEurUlps = cumulativeInverse(totalSupply(), minEurUlps, maxEurUlps);
3570         // actually may overflow on non-monotonic inverse
3571         assert(prevEuroUlps >= _totalEurUlps);
3572         uint256 euroUlps = prevEuroUlps - _totalEurUlps;
3573         emit LogNeumarksBurned(msg.sender, euroUlps, burnNeumarkUlps);
3574     }
3575 }
3576 
3577 /// @title disburse payment token amount to snapshot token holders
3578 /// @dev payment token received via ERC223 Transfer
3579 contract IPlatformPortfolio is IERC223Callback {
3580     // TODO: declare interface
3581 }
3582 
3583 contract ITokenExchangeRateOracle {
3584     /// @notice provides actual price of 'numeratorToken' in 'denominatorToken'
3585     ///     returns timestamp at which price was obtained in oracle
3586     function getExchangeRate(address numeratorToken, address denominatorToken)
3587         public
3588         constant
3589         returns (uint256 rateFraction, uint256 timestamp);
3590 
3591     /// @notice allows to retreive multiple exchange rates in once call
3592     function getExchangeRates(address[] numeratorTokens, address[] denominatorTokens)
3593         public
3594         constant
3595         returns (uint256[] rateFractions, uint256[] timestamps);
3596 }
3597 
3598 /// @title root of trust and singletons + known interface registry
3599 /// provides a root which holds all interfaces platform trust, this includes
3600 /// singletons - for which accessors are provided
3601 /// collections of known instances of interfaces
3602 /// @dev interfaces are identified by bytes4, see KnownInterfaces.sol
3603 contract Universe is
3604     Agreement,
3605     IContractId,
3606     KnownInterfaces
3607 {
3608     ////////////////////////
3609     // Events
3610     ////////////////////////
3611 
3612     /// raised on any change of singleton instance
3613     /// @dev for convenience we provide previous instance of singleton in replacedInstance
3614     event LogSetSingleton(
3615         bytes4 interfaceId,
3616         address instance,
3617         address replacedInstance
3618     );
3619 
3620     /// raised on add/remove interface instance in collection
3621     event LogSetCollectionInterface(
3622         bytes4 interfaceId,
3623         address instance,
3624         bool isSet
3625     );
3626 
3627     ////////////////////////
3628     // Mutable state
3629     ////////////////////////
3630 
3631     // mapping of known contracts to addresses of singletons
3632     mapping(bytes4 => address) private _singletons;
3633 
3634     // mapping of known interfaces to collections of contracts
3635     mapping(bytes4 =>
3636         mapping(address => bool)) private _collections; // solium-disable-line indentation
3637 
3638     // known instances
3639     mapping(address => bytes4[]) private _instances;
3640 
3641 
3642     ////////////////////////
3643     // Constructor
3644     ////////////////////////
3645 
3646     constructor(
3647         IAccessPolicy accessPolicy,
3648         IEthereumForkArbiter forkArbiter
3649     )
3650         Agreement(accessPolicy, forkArbiter)
3651         public
3652     {
3653         setSingletonPrivate(KNOWN_INTERFACE_ACCESS_POLICY, accessPolicy);
3654         setSingletonPrivate(KNOWN_INTERFACE_FORK_ARBITER, forkArbiter);
3655     }
3656 
3657     ////////////////////////
3658     // Public methods
3659     ////////////////////////
3660 
3661     /// get singleton instance for 'interfaceId'
3662     function getSingleton(bytes4 interfaceId)
3663         public
3664         constant
3665         returns (address)
3666     {
3667         return _singletons[interfaceId];
3668     }
3669 
3670     function getManySingletons(bytes4[] interfaceIds)
3671         public
3672         constant
3673         returns (address[])
3674     {
3675         address[] memory addresses = new address[](interfaceIds.length);
3676         uint256 idx;
3677         while(idx < interfaceIds.length) {
3678             addresses[idx] = _singletons[interfaceIds[idx]];
3679             idx += 1;
3680         }
3681         return addresses;
3682     }
3683 
3684     /// checks of 'instance' is instance of interface 'interfaceId'
3685     function isSingleton(bytes4 interfaceId, address instance)
3686         public
3687         constant
3688         returns (bool)
3689     {
3690         return _singletons[interfaceId] == instance;
3691     }
3692 
3693     /// checks if 'instance' is one of instances of 'interfaceId'
3694     function isInterfaceCollectionInstance(bytes4 interfaceId, address instance)
3695         public
3696         constant
3697         returns (bool)
3698     {
3699         return _collections[interfaceId][instance];
3700     }
3701 
3702     function isAnyOfInterfaceCollectionInstance(bytes4[] interfaceIds, address instance)
3703         public
3704         constant
3705         returns (bool)
3706     {
3707         uint256 idx;
3708         while(idx < interfaceIds.length) {
3709             if (_collections[interfaceIds[idx]][instance]) {
3710                 return true;
3711             }
3712             idx += 1;
3713         }
3714         return false;
3715     }
3716 
3717     /// gets all interfaces of given instance
3718     function getInterfacesOfInstance(address instance)
3719         public
3720         constant
3721         returns (bytes4[] interfaces)
3722     {
3723         return _instances[instance];
3724     }
3725 
3726     /// sets 'instance' of singleton with interface 'interfaceId'
3727     function setSingleton(bytes4 interfaceId, address instance)
3728         public
3729         only(ROLE_UNIVERSE_MANAGER)
3730     {
3731         setSingletonPrivate(interfaceId, instance);
3732     }
3733 
3734     /// convenience method for setting many singleton instances
3735     function setManySingletons(bytes4[] interfaceIds, address[] instances)
3736         public
3737         only(ROLE_UNIVERSE_MANAGER)
3738     {
3739         require(interfaceIds.length == instances.length);
3740         uint256 idx;
3741         while(idx < interfaceIds.length) {
3742             setSingletonPrivate(interfaceIds[idx], instances[idx]);
3743             idx += 1;
3744         }
3745     }
3746 
3747     /// set or unset 'instance' with 'interfaceId' in collection of instances
3748     function setCollectionInterface(bytes4 interfaceId, address instance, bool set)
3749         public
3750         only(ROLE_UNIVERSE_MANAGER)
3751     {
3752         setCollectionPrivate(interfaceId, instance, set);
3753     }
3754 
3755     /// set or unset 'instance' in many collections of instances
3756     function setInterfaceInManyCollections(bytes4[] interfaceIds, address instance, bool set)
3757         public
3758         only(ROLE_UNIVERSE_MANAGER)
3759     {
3760         uint256 idx;
3761         while(idx < interfaceIds.length) {
3762             setCollectionPrivate(interfaceIds[idx], instance, set);
3763             idx += 1;
3764         }
3765     }
3766 
3767     /// set or unset array of collection
3768     function setCollectionsInterfaces(bytes4[] interfaceIds, address[] instances, bool[] set_flags)
3769         public
3770         only(ROLE_UNIVERSE_MANAGER)
3771     {
3772         require(interfaceIds.length == instances.length);
3773         require(interfaceIds.length == set_flags.length);
3774         uint256 idx;
3775         while(idx < interfaceIds.length) {
3776             setCollectionPrivate(interfaceIds[idx], instances[idx], set_flags[idx]);
3777             idx += 1;
3778         }
3779     }
3780 
3781     //
3782     // Implements IContractId
3783     //
3784 
3785     function contractId() public pure returns (bytes32 id, uint256 version) {
3786         return (0x8b57bfe21a3ef4854e19d702063b6cea03fa514162f8ff43fde551f06372fefd, 0);
3787     }
3788 
3789     ////////////////////////
3790     // Getters
3791     ////////////////////////
3792 
3793     function accessPolicy() public constant returns (IAccessPolicy) {
3794         return IAccessPolicy(_singletons[KNOWN_INTERFACE_ACCESS_POLICY]);
3795     }
3796 
3797     function forkArbiter() public constant returns (IEthereumForkArbiter) {
3798         return IEthereumForkArbiter(_singletons[KNOWN_INTERFACE_FORK_ARBITER]);
3799     }
3800 
3801     function neumark() public constant returns (Neumark) {
3802         return Neumark(_singletons[KNOWN_INTERFACE_NEUMARK]);
3803     }
3804 
3805     function etherToken() public constant returns (IERC223Token) {
3806         return IERC223Token(_singletons[KNOWN_INTERFACE_ETHER_TOKEN]);
3807     }
3808 
3809     function euroToken() public constant returns (IERC223Token) {
3810         return IERC223Token(_singletons[KNOWN_INTERFACE_EURO_TOKEN]);
3811     }
3812 
3813     function etherLock() public constant returns (address) {
3814         return _singletons[KNOWN_INTERFACE_ETHER_LOCK];
3815     }
3816 
3817     function euroLock() public constant returns (address) {
3818         return _singletons[KNOWN_INTERFACE_EURO_LOCK];
3819     }
3820 
3821     function icbmEtherLock() public constant returns (address) {
3822         return _singletons[KNOWN_INTERFACE_ICBM_ETHER_LOCK];
3823     }
3824 
3825     function icbmEuroLock() public constant returns (address) {
3826         return _singletons[KNOWN_INTERFACE_ICBM_EURO_LOCK];
3827     }
3828 
3829     function identityRegistry() public constant returns (address) {
3830         return IIdentityRegistry(_singletons[KNOWN_INTERFACE_IDENTITY_REGISTRY]);
3831     }
3832 
3833     function tokenExchangeRateOracle() public constant returns (address) {
3834         return ITokenExchangeRateOracle(_singletons[KNOWN_INTERFACE_TOKEN_EXCHANGE_RATE_ORACLE]);
3835     }
3836 
3837     function feeDisbursal() public constant returns (address) {
3838         return IFeeDisbursal(_singletons[KNOWN_INTERFACE_FEE_DISBURSAL]);
3839     }
3840 
3841     function platformPortfolio() public constant returns (address) {
3842         return IPlatformPortfolio(_singletons[KNOWN_INTERFACE_PLATFORM_PORTFOLIO]);
3843     }
3844 
3845     function tokenExchange() public constant returns (address) {
3846         return _singletons[KNOWN_INTERFACE_TOKEN_EXCHANGE];
3847     }
3848 
3849     function gasExchange() public constant returns (address) {
3850         return _singletons[KNOWN_INTERFACE_GAS_EXCHANGE];
3851     }
3852 
3853     function platformTerms() public constant returns (address) {
3854         return _singletons[KNOWN_INTERFACE_PLATFORM_TERMS];
3855     }
3856 
3857     ////////////////////////
3858     // Private methods
3859     ////////////////////////
3860 
3861     function setSingletonPrivate(bytes4 interfaceId, address instance)
3862         private
3863     {
3864         require(interfaceId != KNOWN_INTERFACE_UNIVERSE, "NF_UNI_NO_UNIVERSE_SINGLETON");
3865         address replacedInstance = _singletons[interfaceId];
3866         // do nothing if not changing
3867         if (replacedInstance != instance) {
3868             dropInstance(replacedInstance, interfaceId);
3869             addInstance(instance, interfaceId);
3870             _singletons[interfaceId] = instance;
3871         }
3872 
3873         emit LogSetSingleton(interfaceId, instance, replacedInstance);
3874     }
3875 
3876     function setCollectionPrivate(bytes4 interfaceId, address instance, bool set)
3877         private
3878     {
3879         // do nothing if not changing
3880         if (_collections[interfaceId][instance] == set) {
3881             return;
3882         }
3883         _collections[interfaceId][instance] = set;
3884         if (set) {
3885             addInstance(instance, interfaceId);
3886         } else {
3887             dropInstance(instance, interfaceId);
3888         }
3889         emit LogSetCollectionInterface(interfaceId, instance, set);
3890     }
3891 
3892     function addInstance(address instance, bytes4 interfaceId)
3893         private
3894     {
3895         if (instance == address(0)) {
3896             // do not add null instance
3897             return;
3898         }
3899         bytes4[] storage current = _instances[instance];
3900         uint256 idx;
3901         while(idx < current.length) {
3902             // instancy has this interface already, do nothing
3903             if (current[idx] == interfaceId)
3904                 return;
3905             idx += 1;
3906         }
3907         // new interface
3908         current.push(interfaceId);
3909     }
3910 
3911     function dropInstance(address instance, bytes4 interfaceId)
3912         private
3913     {
3914         if (instance == address(0)) {
3915             // do not drop null instance
3916             return;
3917         }
3918         bytes4[] storage current = _instances[instance];
3919         uint256 idx;
3920         uint256 last = current.length - 1;
3921         while(idx <= last) {
3922             if (current[idx] == interfaceId) {
3923                 // delete element
3924                 if (idx < last) {
3925                     // if not last element move last element to idx being deleted
3926                     current[idx] = current[last];
3927                 }
3928                 // delete last element
3929                 current.length -= 1;
3930                 return;
3931             }
3932             idx += 1;
3933         }
3934     }
3935 }
3936 
3937 /// @title granular fee disbursal contract
3938 contract FeeDisbursal is
3939     IERC223Callback,
3940     IERC677Callback,
3941     IERC223LegacyCallback,
3942     ERC223LegacyCallbackCompat,
3943     Serialization,
3944     Math,
3945     KnownContracts,
3946     KnownInterfaces,
3947     IContractId
3948 {
3949 
3950     ////////////////////////
3951     // Events
3952     ////////////////////////
3953 
3954     event LogDisbursalCreated(
3955         address indexed proRataToken,
3956         address indexed token,
3957         uint256 amount,
3958         uint256 recycleAfterDuration,
3959         address disburser,
3960         uint256 index
3961     );
3962 
3963     event LogDisbursalAccepted(
3964         address indexed claimer,
3965         address token,
3966         address proRataToken,
3967         uint256 amount,
3968         uint256 nextIndex
3969     );
3970 
3971     event LogDisbursalRejected(
3972         address indexed claimer,
3973         address token,
3974         address proRataToken,
3975         uint256 amount,
3976         uint256 nextIndex
3977     );
3978 
3979     event LogFundsRecycled(
3980         address indexed proRataToken,
3981         address indexed token,
3982         uint256 amount,
3983         address by
3984     );
3985 
3986     event LogChangeFeeDisbursalController(
3987         address oldController,
3988         address newController,
3989         address by
3990     );
3991 
3992     ////////////////////////
3993     // Types
3994     ////////////////////////
3995     struct Disbursal {
3996         // snapshop ID of the pro-rata token, which will define which amounts to disburse against
3997         uint256 snapshotId;
3998         // amount of tokens to disburse
3999         uint256 amount;
4000         // timestamp after which claims to this token can be recycled
4001         uint128 recycleableAfterTimestamp;
4002         // timestamp on which token were disbursed
4003         uint128 disbursalTimestamp;
4004         // contract sending the disbursal
4005         address disburser;
4006     }
4007 
4008     ////////////////////////
4009     // Constants
4010     ////////////////////////
4011     uint256 constant UINT256_MAX = 2**256 - 1;
4012 
4013 
4014     ////////////////////////
4015     // Immutable state
4016     ////////////////////////
4017     Universe private UNIVERSE;
4018 
4019     // must be cached - otherwise default func runs out of gas
4020     address private ICBM_ETHER_TOKEN;
4021 
4022     ////////////////////////
4023     // Mutable state
4024     ////////////////////////
4025 
4026     // controller instance
4027     IFeeDisbursalController private _feeDisbursalController;
4028     // map disbursable token address to pro rata token adresses to a list of disbursal events of that token
4029     mapping (address => mapping(address => Disbursal[])) private _disbursals;
4030     // mapping to track what disbursals have already been paid out to which user
4031     // disbursable token address => pro rata token address => user address => next disbursal index to be claimed
4032     mapping (address => mapping(address => mapping(address => uint256))) _disbursalProgress;
4033 
4034 
4035     ////////////////////////
4036     // Constructor
4037     ////////////////////////
4038     constructor(Universe universe, IFeeDisbursalController controller)
4039         public
4040     {
4041         require(universe != address(0x0));
4042         (bytes32 controllerContractId, ) = controller.contractId();
4043         require(controllerContractId == FEE_DISBURSAL_CONTROLLER);
4044         UNIVERSE = universe;
4045         ICBM_ETHER_TOKEN = universe.getSingleton(KNOWN_INTERFACE_ICBM_ETHER_TOKEN);
4046         _feeDisbursalController = controller;
4047     }
4048 
4049     ////////////////////////
4050     // Public functions
4051     ////////////////////////
4052 
4053     /// @notice get the disbursal at a given index for a given token
4054     /// @param token address of the disbursable token
4055     /// @param proRataToken address of the token used to determine the user pro rata amount, must be a snapshottoken
4056     /// @param index until what index to claim to
4057     function getDisbursal(address token, address proRataToken, uint256 index)
4058         public
4059         constant
4060     returns (
4061         uint256 snapshotId,
4062         uint256 amount,
4063         uint256 recycleableAfterTimestamp,
4064         uint256 disburseTimestamp,
4065         address disburser
4066     )
4067     {
4068         Disbursal storage disbursal = _disbursals[token][proRataToken][index];
4069         snapshotId = disbursal.snapshotId;
4070         amount = disbursal.amount;
4071         recycleableAfterTimestamp = disbursal.recycleableAfterTimestamp;
4072         disburseTimestamp = disbursal.disbursalTimestamp;
4073         disburser = disbursal.disburser;
4074     }
4075 
4076     /// @notice get disbursals for current snapshot id of the proRataToken that cannot be claimed yet
4077     /// @param token address of the disbursable token
4078     /// @param proRataToken address of the token used to determine the user pro rata amount, must be a snapshottoken
4079     /// @return array of (snapshotId, amount, index) ordered by index. full disbursal information can be retrieved via index
4080     function getNonClaimableDisbursals(address token, address proRataToken)
4081         public
4082         constant
4083     returns (uint256[3][] memory disbursals)
4084     {
4085         uint256 len = _disbursals[token][proRataToken].length;
4086         if (len == 0) {
4087             return;
4088         }
4089         // count elements with current snapshot id
4090         uint256 snapshotId = ITokenSnapshots(proRataToken).currentSnapshotId();
4091         uint256 ii = len;
4092         while(_disbursals[token][proRataToken][ii-1].snapshotId == snapshotId && --ii > 0) {}
4093         disbursals = new uint256[3][](len-ii);
4094         for(uint256 jj = 0; jj < len - ii; jj += 1) {
4095             disbursals[jj][0] = snapshotId;
4096             disbursals[jj][1] = _disbursals[token][proRataToken][ii+jj].amount;
4097             disbursals[jj][2] = ii+jj;
4098         }
4099     }
4100 
4101     /// @notice get count of disbursals for given token
4102     /// @param token address of the disbursable token
4103     /// @param proRataToken address of the token used to determine the user pro rata amount, must be a snapshottoken
4104     function getDisbursalCount(address token, address proRataToken)
4105         public
4106         constant
4107         returns (uint256)
4108     {
4109         return _disbursals[token][proRataToken].length;
4110     }
4111 
4112     /// @notice accepts the token disbursal offer and claim offered tokens, to be called by an investor
4113     /// @param token address of the disbursable token
4114     /// @param proRataToken address of the token used to determine the user pro rata amount, must be a snapshottoken
4115     /// @param until until what index to claim to, noninclusive, use 2**256 to accept all disbursals
4116     function accept(address token, ITokenSnapshots proRataToken, uint256 until)
4117         public
4118     {
4119         // only allow verified and active accounts to claim tokens
4120         require(_feeDisbursalController.onAccept(token, proRataToken, msg.sender), "NF_ACCEPT_REJECTED");
4121         (uint256 claimedAmount, , uint256 nextIndex) = claimPrivate(token, proRataToken, msg.sender, until);
4122 
4123         // do the actual token transfer
4124         if (claimedAmount > 0) {
4125             IERC223Token ierc223Token = IERC223Token(token);
4126             assert(ierc223Token.transfer(msg.sender, claimedAmount, ""));
4127         }
4128         // log
4129         emit LogDisbursalAccepted(msg.sender, token, proRataToken, claimedAmount, nextIndex);
4130     }
4131 
4132     /// @notice accepts disbursals of multiple tokens and receives them, to be called an investor
4133     /// @param tokens addresses of the disbursable token
4134     /// @param proRataToken address of the token used to determine the user pro rata amount, must be a snapshottoken
4135     function acceptMultipleByToken(address[] tokens, ITokenSnapshots proRataToken)
4136         public
4137     {
4138         uint256[2][] memory claimed = new uint256[2][](tokens.length);
4139         // first gather the funds
4140         uint256 i;
4141         for (i = 0; i < tokens.length; i += 1) {
4142             // only allow verified and active accounts to claim tokens
4143             require(_feeDisbursalController.onAccept(tokens[i], proRataToken, msg.sender), "NF_ACCEPT_REJECTED");
4144             (claimed[i][0], ,claimed[i][1]) = claimPrivate(tokens[i], proRataToken, msg.sender, UINT256_MAX);
4145         }
4146         // then perform actual transfers, after all state changes are done, to prevent re-entry
4147         for (i = 0; i < tokens.length; i += 1) {
4148             if (claimed[i][0] > 0) {
4149                 // do the actual token transfer
4150                 IERC223Token ierc223Token = IERC223Token(tokens[i]);
4151                 assert(ierc223Token.transfer(msg.sender, claimed[i][0], ""));
4152             }
4153             // always log, even empty amounts
4154             emit LogDisbursalAccepted(msg.sender, tokens[i], proRataToken, claimed[i][0], claimed[i][1]);
4155         }
4156     }
4157 
4158     /// @notice accepts disbursals for single token against many pro rata tokens
4159     /// @param token address of the disbursable token
4160     /// @param proRataTokens addresses of the tokens used to determine the user pro rata amount, must be a snapshottoken
4161     /// @dev this should let save a lot on gas by eliminating multiple transfers and some checks
4162     function acceptMultipleByProRataToken(address token, ITokenSnapshots[] proRataTokens)
4163         public
4164     {
4165         uint256 i;
4166         uint256 fullAmount;
4167         for (i = 0; i < proRataTokens.length; i += 1) {
4168             require(_feeDisbursalController.onAccept(token, proRataTokens[i], msg.sender), "NF_ACCEPT_REJECTED");
4169             (uint256 amount, , uint256 nextIndex) = claimPrivate(token, proRataTokens[i], msg.sender, UINT256_MAX);
4170             fullAmount += amount;
4171             // emit here, that's how we avoid second loop and storing particular claims
4172             emit LogDisbursalAccepted(msg.sender, token, proRataTokens[i], amount, nextIndex);
4173         }
4174         if (fullAmount > 0) {
4175             // and now why this method exits - one single transfer of token from many distributions
4176             IERC223Token ierc223Token = IERC223Token(token);
4177             assert(ierc223Token.transfer(msg.sender, fullAmount, ""));
4178         }
4179     }
4180 
4181     /// @notice rejects disbursal of token which leads to recycle and disbursal of rejected amount
4182     /// @param token address of the disbursable token
4183     /// @param proRataToken address of the token used to determine the user pro rata amount, must be a snapshottoken
4184     /// @param until until what index to claim to, noninclusive, use 2**256 to reject all disbursals
4185     function reject(address token, ITokenSnapshots proRataToken, uint256 until)
4186         public
4187     {
4188         // only allow verified and active accounts to claim tokens
4189         require(_feeDisbursalController.onReject(token, address(0), msg.sender), "NF_REJECT_REJECTED");
4190         (uint256 claimedAmount, , uint256 nextIndex) = claimPrivate(token, proRataToken, msg.sender, until);
4191         // what was rejected will be recycled
4192         if (claimedAmount > 0) {
4193             PlatformTerms terms = PlatformTerms(UNIVERSE.platformTerms());
4194             disburse(token, this, claimedAmount, proRataToken, terms.DEFAULT_DISBURSAL_RECYCLE_AFTER_DURATION());
4195         }
4196         // log
4197         emit LogDisbursalRejected(msg.sender, token, proRataToken, claimedAmount, nextIndex);
4198     }
4199 
4200     /// @notice check how many tokens of a certain kind can be claimed by an account
4201     /// @param token address of the disbursable token
4202     /// @param proRataToken address of the token used to determine the user pro rata amount, must be a snapshottoken
4203     /// @param claimer address of the claimer that would receive the funds
4204     /// @param until until what index to claim to, noninclusive, use 2**256 to reject all disbursals
4205     /// @return (amount that can be claimed, total disbursed amount, time to recycle of first disbursal, first disbursal index)
4206     function claimable(address token, ITokenSnapshots proRataToken, address claimer, uint256 until)
4207         public
4208         constant
4209     returns (uint256 claimableAmount, uint256 totalAmount, uint256 recycleableAfterTimestamp, uint256 firstIndex)
4210     {
4211         firstIndex = _disbursalProgress[token][proRataToken][claimer];
4212         if (firstIndex < _disbursals[token][proRataToken].length) {
4213             recycleableAfterTimestamp = _disbursals[token][proRataToken][firstIndex].recycleableAfterTimestamp;
4214         }
4215         // we don't do to a verified check here, this serves purely to check how much is claimable for an address
4216         (claimableAmount, totalAmount,) = claimablePrivate(token, proRataToken, claimer, until, false);
4217     }
4218 
4219     /// @notice check how much fund for each disbursable tokens can be claimed by claimer
4220     /// @param tokens addresses of the disbursable token
4221     /// @param proRataToken address of the token used to determine the user pro rata amount, must be a snapshottoken
4222     /// @param claimer address of the claimer that would receive the funds
4223     /// @return array of (amount that can be claimed, total disbursed amount, time to recycle of first disbursal, first disbursal index)
4224     /// @dev claimbles are returned in the same order as tokens were specified
4225     function claimableMutipleByToken(address[] tokens, ITokenSnapshots proRataToken, address claimer)
4226         public
4227         constant
4228     returns (uint256[4][] claimables)
4229     {
4230         claimables = new uint256[4][](tokens.length);
4231         for (uint256 i = 0; i < tokens.length; i += 1) {
4232             claimables[i][3] = _disbursalProgress[tokens[i]][proRataToken][claimer];
4233             if (claimables[i][3] < _disbursals[tokens[i]][proRataToken].length) {
4234                 claimables[i][2] = _disbursals[tokens[i]][proRataToken][claimables[i][3]].recycleableAfterTimestamp;
4235             }
4236             (claimables[i][0], claimables[i][1], ) = claimablePrivate(tokens[i], proRataToken, claimer, UINT256_MAX, false);
4237         }
4238     }
4239 
4240     /// @notice check how many tokens can be claimed against many pro rata tokens
4241     /// @param token address of the disbursable token
4242     /// @param proRataTokens addresses of the tokens used to determine the user pro rata amount, must be a snapshottoken
4243     /// @param claimer address of the claimer that would receive the funds
4244     /// @return array of (amount that can be claimed, total disbursed amount, time to recycle of first disbursal, first disbursal index)
4245     function claimableMutipleByProRataToken(address token, ITokenSnapshots[] proRataTokens, address claimer)
4246         public
4247         constant
4248     returns (uint256[4][] claimables)
4249     {
4250         claimables = new uint256[4][](proRataTokens.length);
4251         for (uint256 i = 0; i < proRataTokens.length; i += 1) {
4252             claimables[i][3] = _disbursalProgress[token][proRataTokens[i]][claimer];
4253             if (claimables[i][3] < _disbursals[token][proRataTokens[i]].length) {
4254                 claimables[i][2] = _disbursals[token][proRataTokens[i]][claimables[i][3]].recycleableAfterTimestamp;
4255             }
4256             (claimables[i][0], claimables[i][1], ) = claimablePrivate(token, proRataTokens[i], claimer, UINT256_MAX, false);
4257         }
4258     }
4259 
4260     /// @notice recycle a token for multiple investors
4261     /// @param token address of the recyclable token
4262     /// @param proRataToken address of the token used to determine the user pro rata amount, must be a snapshottoken
4263     /// @param investors list of investors we want to recycle tokens for
4264     /// @param until until what index to recycle to
4265     function recycle(address token, ITokenSnapshots proRataToken, address[] investors, uint256 until)
4266         public
4267     {
4268         require(_feeDisbursalController.onRecycle(token, proRataToken, investors, until), "");
4269         // cycle through all investors collect the claimable and recycleable funds
4270         // also move the _disbursalProgress pointer
4271         uint256 totalClaimableAmount = 0;
4272         for (uint256 i = 0; i < investors.length; i += 1) {
4273             (uint256 claimableAmount, ,uint256 nextIndex) = claimablePrivate(token, ITokenSnapshots(proRataToken), investors[i], until, true);
4274             totalClaimableAmount += claimableAmount;
4275             _disbursalProgress[token][proRataToken][investors[i]] = nextIndex;
4276         }
4277 
4278         // skip disbursal if amount == 0
4279         if (totalClaimableAmount > 0) {
4280             // now re-disburse, we're now the disburser
4281             PlatformTerms terms = PlatformTerms(UNIVERSE.platformTerms());
4282             disburse(token, this, totalClaimableAmount, proRataToken, terms.DEFAULT_DISBURSAL_RECYCLE_AFTER_DURATION());
4283         }
4284 
4285         // log
4286         emit LogFundsRecycled(proRataToken, token, totalClaimableAmount, msg.sender);
4287     }
4288 
4289     /// @notice check how much we can recycle for multiple investors
4290     /// @param token address of the recyclable token
4291     /// @param proRataToken address of the token used to determine the user pro rata amount, must be a snapshottoken
4292     /// @param investors list of investors we want to recycle tokens for
4293     /// @param until until what index to recycle to
4294     function recycleable(address token, ITokenSnapshots proRataToken, address[] investors, uint256 until)
4295         public
4296         constant
4297     returns (uint256)
4298     {
4299         // cycle through all investors collect the claimable and recycleable funds
4300         uint256 totalAmount = 0;
4301         for (uint256 i = 0; i < investors.length; i += 1) {
4302             (uint256 claimableAmount,,) = claimablePrivate(token, proRataToken, investors[i], until, true);
4303             totalAmount += claimableAmount;
4304         }
4305         return totalAmount;
4306     }
4307 
4308     /// @notice get current controller
4309     function feeDisbursalController()
4310         public
4311         constant
4312         returns (IFeeDisbursalController)
4313     {
4314         return _feeDisbursalController;
4315     }
4316 
4317     /// @notice update current controller
4318     function changeFeeDisbursalController(IFeeDisbursalController newController)
4319         public
4320     {
4321         require(_feeDisbursalController.onChangeFeeDisbursalController(msg.sender, newController), "NF_CHANGING_CONTROLLER_REJECTED");
4322         address oldController = address(_feeDisbursalController);
4323         _feeDisbursalController = newController;
4324         emit LogChangeFeeDisbursalController(oldController, address(newController), msg.sender);
4325     }
4326 
4327     /// @notice implementation of tokenfallback, calls the internal disburse function
4328 
4329     function tokenFallback(address wallet, uint256 amount, bytes data)
4330         public
4331     {
4332         tokenFallbackPrivate(msg.sender, wallet, amount, data);
4333     }
4334 
4335     /// @notice legacy callback used by ICBMLockedAccount: approve and call pattern
4336     function receiveApproval(address from, uint256 amount, address tokenAddress, bytes data)
4337         public
4338         returns (bool success)
4339     {
4340         // sender must be token
4341         require(msg.sender == tokenAddress);
4342         // transfer assets
4343         IERC20Token token = IERC20Token(tokenAddress);
4344         // this needs a special permission in case of ICBM Euro Token
4345         require(token.transferFrom(from, address(this), amount));
4346 
4347         // now in case we convert from icbm token
4348         // migrate previous asset token depends on token type, unfortunatelly deposit function differs so we have to cast. this is weak...
4349         if (tokenAddress == ICBM_ETHER_TOKEN) {
4350             // after EtherToken withdraw, deposit ether into new token
4351             IWithdrawableToken(tokenAddress).withdraw(amount);
4352             token = IERC20Token(UNIVERSE.etherToken());
4353             EtherToken(token).deposit.value(amount)();
4354         }
4355         if(tokenAddress == UNIVERSE.getSingleton(KNOWN_INTERFACE_ICBM_EURO_TOKEN)) {
4356             IWithdrawableToken(tokenAddress).withdraw(amount);
4357             token = IERC20Token(UNIVERSE.euroToken());
4358             // this requires EuroToken DEPOSIT_MANAGER role
4359             EuroToken(token).deposit(this, amount, 0x0);
4360         }
4361         tokenFallbackPrivate(address(token), from, amount, data);
4362         return true;
4363     }
4364 
4365     //
4366     // IContractId Implementation
4367     //
4368 
4369     function contractId()
4370         public
4371         pure
4372         returns (bytes32 id, uint256 version)
4373     {
4374         return (0x2e1a7e4ac88445368dddb31fe43d29638868837724e9be8ffd156f21a971a4d7, 0);
4375     }
4376 
4377     //
4378     // Payable default function to receive ether during migration
4379     //
4380     function ()
4381         public
4382         payable
4383     {
4384         require(msg.sender == ICBM_ETHER_TOKEN);
4385     }
4386 
4387 
4388     ////////////////////////
4389     // Private functions
4390     ////////////////////////
4391 
4392     function tokenFallbackPrivate(address token, address wallet, uint256 amount, bytes data)
4393         private
4394     {
4395         ITokenSnapshots proRataToken;
4396         PlatformTerms terms = PlatformTerms(UNIVERSE.platformTerms());
4397         uint256 recycleAfterDuration = terms.DEFAULT_DISBURSAL_RECYCLE_AFTER_DURATION();
4398         if (data.length == 20) {
4399             proRataToken = ITokenSnapshots(decodeAddress(data));
4400         }
4401         else if (data.length == 52) {
4402             address proRataTokenAddress;
4403             (proRataTokenAddress, recycleAfterDuration) = decodeAddressUInt256(data);
4404             proRataToken = ITokenSnapshots(proRataTokenAddress);
4405         } else {
4406             // legacy ICBMLockedAccount compat mode which does not send pro rata token address and we assume NEU
4407             proRataToken = UNIVERSE.neumark();
4408         }
4409         disburse(token, wallet, amount, proRataToken, recycleAfterDuration);
4410     }
4411 
4412     /// @notice create a new disbursal
4413     /// @param token address of the token to disburse
4414     /// @param disburser address of the actor disbursing (e.g. eto commitment)
4415     /// @param amount amount of the disbursable tokens
4416     /// @param proRataToken address of the token that defines the pro rata
4417     function disburse(address token, address disburser, uint256 amount, ITokenSnapshots proRataToken, uint256 recycleAfterDuration)
4418         private
4419     {
4420         require(
4421             _feeDisbursalController.onDisburse(token, disburser, amount, address(proRataToken), recycleAfterDuration), "NF_DISBURSAL_REJECTED");
4422 
4423         uint256 snapshotId = proRataToken.currentSnapshotId();
4424         uint256 proRataTokenTotalSupply = proRataToken.totalSupplyAt(snapshotId);
4425         // if token disburses itself we cannot disburse full total supply
4426         if (token == address(proRataToken)) {
4427             proRataTokenTotalSupply -= proRataToken.balanceOfAt(address(this), snapshotId);
4428         }
4429         require(proRataTokenTotalSupply > 0, "NF_NO_DISBURSE_EMPTY_TOKEN");
4430         uint256 recycleAfter = add(block.timestamp, recycleAfterDuration);
4431         assert(recycleAfter<2**128);
4432 
4433         Disbursal[] storage disbursals = _disbursals[token][proRataToken];
4434         // try to merge with an existing disbursal
4435         bool merged = false;
4436         for ( uint256 i = disbursals.length - 1; i != UINT256_MAX; i-- ) {
4437             // we can only merge if we have the same snapshot id
4438             // we can break here, as continuing down the loop the snapshot ids will decrease
4439             Disbursal storage disbursal = disbursals[i];
4440             if ( disbursal.snapshotId < snapshotId) {
4441                 break;
4442             }
4443             // the existing disbursal must be the same on number of params so we can merge
4444             // disbursal.snapshotId is guaranteed to == proRataToken.currentSnapshotId()
4445             if ( disbursal.disburser == disburser ) {
4446                 merged = true;
4447                 disbursal.amount += amount;
4448                 disbursal.recycleableAfterTimestamp = uint128(recycleAfter);
4449                 disbursal.disbursalTimestamp = uint128(block.timestamp);
4450                 break;
4451             }
4452         }
4453 
4454         // create a new disbursal entry
4455         if (!merged) {
4456             disbursals.push(Disbursal({
4457                 recycleableAfterTimestamp: uint128(recycleAfter),
4458                 disbursalTimestamp: uint128(block.timestamp),
4459                 amount: amount,
4460                 snapshotId: snapshotId,
4461                 disburser: disburser
4462             }));
4463         }
4464         emit LogDisbursalCreated(proRataToken, token, amount, recycleAfterDuration, disburser, merged ? i : disbursals.length - 1);
4465     }
4466 
4467 
4468     /// @notice claim a token for an claimer, returns the amount of tokens claimed
4469     /// @param token address of the disbursable token
4470     /// @param claimer address of the claimer that will receive the funds
4471     /// @param until until what index to claim to
4472     function claimPrivate(address token, ITokenSnapshots proRataToken, address claimer, uint256 until)
4473         private
4474     returns (uint256 claimedAmount, uint256 totalAmount, uint256 nextIndex)
4475     {
4476         (claimedAmount, totalAmount, nextIndex) = claimablePrivate(token, proRataToken, claimer, until, false);
4477 
4478         // mark claimer disbursal progress
4479         _disbursalProgress[token][proRataToken][claimer] = nextIndex;
4480     }
4481 
4482     /// @notice get the amount of tokens that can be claimed by a given claimer
4483     /// @param token address of the disbursable token
4484     /// @param claimer address of the claimer that will receive the funds
4485     /// @param until until what index to claim to, use UINT256_MAX for all
4486     /// @param onlyRecycleable show only disbursable funds that can be recycled
4487     /// @return a tuple of (amount claimed, total amount disbursed, next disbursal index to be claimed)
4488     function claimablePrivate(address token, ITokenSnapshots proRataToken, address claimer, uint256 until, bool onlyRecycleable)
4489         private
4490         constant
4491         returns (uint256 claimableAmount, uint256 totalAmount, uint256 nextIndex)
4492     {
4493         nextIndex = min(until, _disbursals[token][proRataToken].length);
4494         uint256 currentIndex = _disbursalProgress[token][proRataToken][claimer];
4495         uint256 currentSnapshotId = proRataToken.currentSnapshotId();
4496         for (; currentIndex < nextIndex; currentIndex += 1) {
4497             Disbursal storage disbursal = _disbursals[token][proRataToken][currentIndex];
4498             uint256 snapshotId = disbursal.snapshotId;
4499             // do not pay out claims from the current snapshot
4500             if ( snapshotId == currentSnapshotId )
4501                 break;
4502             // in case of just determining the recyclable amount of tokens, break when we
4503             // cross this time, this also assumes disbursal.recycleableAfterTimestamp in each disbursal is the same or increases
4504             // in case it decreases, recycle will not be possible until 'blocking' disbursal also expires
4505             if ( onlyRecycleable && disbursal.recycleableAfterTimestamp > block.timestamp )
4506                 break;
4507             // add to total amount
4508             totalAmount += disbursal.amount;
4509             // add claimable amount
4510             claimableAmount += calculateClaimableAmount(claimer, disbursal.amount, token, proRataToken, snapshotId);
4511         }
4512         return (claimableAmount, totalAmount, currentIndex);
4513     }
4514 
4515     function calculateClaimableAmount(address claimer, uint256 disbursalAmount, address token, ITokenSnapshots proRataToken, uint256 snapshotId)
4516         private
4517         constant
4518         returns (uint256)
4519     {
4520         uint256 proRataClaimerBalance = proRataToken.balanceOfAt(claimer, snapshotId);
4521         // if no balance then continue
4522         if (proRataClaimerBalance == 0) {
4523             return 0;
4524         }
4525         // compute pro rata amount
4526         uint256 proRataTokenTotalSupply = proRataToken.totalSupplyAt(snapshotId);
4527         // if we disburse token that is pro rata token (downround) then remove what fee disbursal holds from total supply
4528         if (token == address(proRataToken)) {
4529             proRataTokenTotalSupply -= proRataToken.balanceOfAt(address(this), snapshotId);
4530         }
4531         // using round HALF_UP we risks rounding errors to accumulate and overflow balance at the last claimer
4532         // example: disbursalAmount = 3, total supply = 2 and two claimers with 1 pro rata token balance
4533         // with HALF_UP first claims 2 and seconds claims2 but balance is 1 at that point
4534         // thus we round down here saving tons of gas by not doing additional bookkeeping
4535         // consequence: small amounts of disbursed funds will be left in the contract
4536         return mul(disbursalAmount, proRataClaimerBalance) / proRataTokenTotalSupply;
4537     }
4538 }