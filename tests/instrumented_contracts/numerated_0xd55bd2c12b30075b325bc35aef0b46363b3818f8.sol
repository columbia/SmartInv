1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-13
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-08-11
7 */
8 
9 pragma solidity 0.5.17;
10 
11 
12 library SafeMath {
13     /**
14      * @dev Returns the addition of two unsigned integers, reverting on
15      * overflow.
16      *
17      * Counterpart to Solidity's `+` operator.
18      *
19      * Requirements:
20      *
21      * - Addition cannot overflow.
22      */
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26 
27         return c;
28     }
29 
30     /**
31      * @dev Returns the subtraction of two unsigned integers, reverting on
32      * overflow (when the result is negative).
33      *
34      * Counterpart to Solidity's `-` operator.
35      *
36      * Requirements:
37      *
38      * - Subtraction cannot overflow.
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     /**
45      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
46      * overflow (when the result is negative).
47      *
48      * Counterpart to Solidity's `-` operator.
49      *
50      * Requirements:
51      *
52      * - Subtraction cannot overflow.
53      */
54     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b <= a, errorMessage);
56         uint256 c = a - b;
57 
58         return c;
59     }
60 
61     /**
62      * @dev Returns the multiplication of two unsigned integers, reverting on
63      * overflow.
64      *
65      * Counterpart to Solidity's `*` operator.
66      *
67      * Requirements:
68      *
69      * - Multiplication cannot overflow.
70      */
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
73         // benefit is lost if 'b' is also tested.
74         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
75         if (a == 0) {
76             return 0;
77         }
78 
79         uint256 c = a * b;
80         require(c / a == b, "SafeMath: multiplication overflow");
81 
82         return c;
83     }
84 
85     /**
86      * @dev Returns the integer division of two unsigned integers. Reverts on
87      * division by zero. The result is rounded towards zero.
88      *
89      * Counterpart to Solidity's `/` operator. Note: this function uses a
90      * `revert` opcode (which leaves remaining gas untouched) while Solidity
91      * uses an invalid opcode to revert (consuming all remaining gas).
92      *
93      * Requirements:
94      *
95      * - The divisor cannot be zero.
96      */
97     function div(uint256 a, uint256 b) internal pure returns (uint256) {
98         return div(a, b, "SafeMath: division by zero");
99     }
100 
101     /**
102      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
103      * division by zero. The result is rounded towards zero.
104      *
105      * Counterpart to Solidity's `/` operator. Note: this function uses a
106      * `revert` opcode (which leaves remaining gas untouched) while Solidity
107      * uses an invalid opcode to revert (consuming all remaining gas).
108      *
109      * Requirements:
110      *
111      * - The divisor cannot be zero.
112      */
113     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
114         require(b > 0, errorMessage);
115         uint256 c = a / b;
116         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
123      * Reverts when dividing by zero.
124      *
125      * Counterpart to Solidity's `%` operator. This function uses a `revert`
126      * opcode (which leaves remaining gas untouched) while Solidity uses an
127      * invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      *
131      * - The divisor cannot be zero.
132      */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         return mod(a, b, "SafeMath: modulo by zero");
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
139      * Reverts with custom message when dividing by zero.
140      *
141      * Counterpart to Solidity's `%` operator. This function uses a `revert`
142      * opcode (which leaves remaining gas untouched) while Solidity uses an
143      * invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      *
147      * - The divisor cannot be zero.
148      */
149     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         require(b != 0, errorMessage);
151         return a % b;
152     }
153 }
154 
155 
156 contract YAMTokenStorage {
157 
158     using SafeMath for uint256;
159 
160     /**
161      * @dev Guard variable for re-entrancy checks. Not currently used
162      */
163     bool internal _notEntered;
164 
165     /**
166      * @notice EIP-20 token name for this token
167      */
168     string public name;
169 
170     /**
171      * @notice EIP-20 token symbol for this token
172      */
173     string public symbol;
174 
175     /**
176      * @notice EIP-20 token decimals for this token
177      */
178     uint8 public decimals;
179 
180     /**
181      * @notice Governor for this contract
182      */
183     address public gov;
184 
185     /**
186      * @notice Pending governance for this contract
187      */
188     address public pendingGov;
189 
190     /**
191      * @notice Approved rebaser for this contract
192      */
193     address public rebaser;
194 
195     /**
196      * @notice Reserve address of YAM protocol
197      */
198     address public incentivizer;
199 
200     /**
201      * @notice Total supply of YAMs
202      */
203     uint256 public totalSupply;
204 
205     /**
206      * @notice Internal decimals used to handle scaling factor
207      */
208     uint256 public constant internalDecimals = 10**24;
209 
210     /**
211      * @notice Used for percentage maths
212      */
213     uint256 public constant BASE = 10**18;
214 
215     /**
216      * @notice Scaling factor that adjusts everyone's balances
217      */
218     uint256 public yamsScalingFactor;
219     /**
220      * @notice Last rebase time
221      */
222     uint256 public lastScalingTime;
223     /**
224      * @notice game start
225      */
226     bool public gameStart;
227 
228     mapping (address => uint256) internal _yamBalances;
229 
230     mapping (address => mapping (address => uint256)) internal _allowedFragments;
231 
232     uint256 public initSupply;
233     
234     address[] public addressWhiteList;
235 }
236 
237 
238 contract YAMGovernanceStorage {
239     /// @notice A record of each accounts delegate
240     mapping (address => address) internal _delegates;
241 
242     /// @notice A checkpoint for marking number of votes from a given block
243     struct Checkpoint {
244         uint32 fromBlock;
245         uint256 votes;
246     }
247 
248     /// @notice A record of votes checkpoints for each account, by index
249     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
250 
251     /// @notice The number of checkpoints for each account
252     mapping (address => uint32) public numCheckpoints;
253 
254     /// @notice The EIP-712 typehash for the contract's domain
255     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
256 
257     /// @notice The EIP-712 typehash for the delegation struct used by the contract
258     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
259 
260     /// @notice A record of states for signing / validating signatures
261     mapping (address => uint) public nonces;
262 }
263 
264 
265 contract YAMTokenInterface is YAMTokenStorage, YAMGovernanceStorage {
266 
267     /// @notice An event thats emitted when an account changes its delegate
268     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
269 
270     /// @notice An event thats emitted when a delegate account's vote balance changes
271     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
272 
273     /**
274      * @notice Event emitted when tokens are rebased
275      */
276     event Rebase(uint256 epoch, uint256 prevYamsScalingFactor, uint256 newYamsScalingFactor);
277 
278     /*** Gov Events ***/
279 
280     /**
281      * @notice Event emitted when pendingGov is changed
282      */
283     event NewPendingGov(address oldPendingGov, address newPendingGov);
284 
285     /**
286      * @notice Event emitted when gov is changed
287      */
288     event NewGov(address oldGov, address newGov);
289 
290     /**
291      * @notice Sets the rebaser contract
292      */
293     event NewRebaser(address oldRebaser, address newRebaser);
294 
295     /**
296      * @notice Sets the incentivizer contract
297      */
298     event NewIncentivizer(address oldIncentivizer, address newIncentivizer);
299 
300     /* - ERC20 Events - */
301 
302     /**
303      * @notice EIP20 Transfer event
304      */
305     event Transfer(address indexed from, address indexed to, uint amount);
306 
307     /**
308      * @notice EIP20 Approval event
309      */
310     event Approval(address indexed owner, address indexed spender, uint amount);
311 
312     /* - Extra Events - */
313     /**
314      * @notice Tokens minted event
315      */
316     event Mint(address to, uint256 amount);
317 
318     // Public functions
319     function transfer(address to, uint256 value) external returns(bool);
320     function transferFrom(address from, address to, uint256 value) external returns(bool);
321     function balanceOf(address who) external view returns(uint256);
322     function balanceOfUnderlying(address who) external view returns(uint256);
323     function allowance(address owner_, address spender) external view returns(uint256);
324     function approve(address spender, uint256 value) external returns (bool);
325     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
326     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
327     function maxScalingFactor() external view returns (uint256);
328 
329     /* - Governance Functions - */
330     function getPriorVotes(address account, uint blockNumber) external view returns (uint256);
331     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external;
332     function delegate(address delegatee) external;
333     function delegates(address delegator) external view returns (address);
334     function getCurrentVotes(address account) external view returns (uint256);
335 
336     /* - Permissioned/Governance functions - */
337     function mint(address to, uint256 amount) external returns (bool);
338     function rebase(uint256 epoch, uint256 indexDelta, bool positive) external returns (uint256);
339     function _setRebaser(address rebaser_) external;
340     function _setIncentivizer(address incentivizer_) external;
341     function _setPendingGov(address pendingGov_) external;
342     function _acceptGov() external;
343 }
344 
345 
346 contract YAMDelegationStorage {
347     /**
348      * @notice Implementation address for this contract
349      */
350     address public implementation;
351 }
352 
353 contract YAMDelegatorInterface is YAMDelegationStorage {
354     /**
355      * @notice Emitted when implementation is changed
356      */
357     event NewImplementation(address oldImplementation, address newImplementation);
358 
359     /**
360      * @notice Called by the gov to update the implementation of the delegator
361      * @param implementation_ The address of the new implementation for delegation
362      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
363      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
364      */
365     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public;
366 }
367 
368 contract ZOMBIEDelegator is YAMTokenInterface, YAMDelegatorInterface {
369     // /**
370     //  * @notice Construct a new YAM
371     //  * @param name_ ERC-20 name of this token
372     //  * @param symbol_ ERC-20 symbol of this token
373     //  * @param decimals_ ERC-20 decimal precision of this token
374     //  * @param initSupply_ Initial token amount
375     //  * @param implementation_ The address of the implementation the contract delegates to
376     //  * @param becomeImplementationData The encoded args for becomeImplementation
377     //  */
378     constructor(
379         // string memory name_,
380         // string memory symbol_,
381         // uint8 decimals_,
382         // uint256 initSupply_,
383         // address implementation_,
384         // bytes memory becomeImplementationData
385     )
386         public
387     {
388 
389 
390         // Creator of the contract is gov during initialization
391         gov = msg.sender;
392 
393         // First delegate gets to initialize the delegator (i.e. storage contract)
394         delegateTo(
395             0xAEeC749ef06BDc879594F6d77D22eadB84E5d827,
396             abi.encodeWithSignature(
397                 "initialize(string,string,uint8,address,uint256)",
398                 // name_,
399                 // symbol_,
400                 // decimals_,
401                 // msg.sender,
402                 // initSupply_
403                 "ZOMBIE.FINANCE",
404                 "ZOMBIE",
405                 18,
406                 msg.sender,
407                 306780000000000000000000
408             )
409         );
410 
411         // New implementations always get set via the settor (post-initialize)
412         _setImplementation(0xAEeC749ef06BDc879594F6d77D22eadB84E5d827, false, "");
413 
414     }
415 
416     /**
417      * @notice Called by the gov to update the implementation of the delegator
418      * @param implementation_ The address of the new implementation for delegation
419      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
420      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
421      */
422     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public {
423         require(msg.sender == gov, "YAMDelegator::_setImplementation: Caller must be gov");
424 
425         if (allowResign) {
426             delegateToImplementation(abi.encodeWithSignature("_resignImplementation()"));
427         }
428 
429         address oldImplementation = implementation;
430         implementation = implementation_;
431 
432         delegateToImplementation(abi.encodeWithSignature("_becomeImplementation(bytes)", becomeImplementationData));
433 
434         emit NewImplementation(oldImplementation, implementation);
435     }
436 
437     /**
438      * @notice Sender supplies assets into the market and receives cTokens in exchange
439      * @dev Accrues interest whether or not the operation succeeds, unless reverted
440      * @param mintAmount The amount of the underlying asset to supply
441      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
442      */
443     function mint(address to, uint256 mintAmount)
444         external
445         returns (bool)
446     {
447         to; mintAmount; // Shh
448         delegateAndReturn();
449     }
450 
451     /**
452      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
453      * @param dst The address of the destination account
454      * @param amount The number of tokens to transfer
455      * @return Whether or not the transfer succeeded
456      */
457     function transfer(address dst, uint256 amount)
458         external
459         returns (bool)
460     {
461         dst; amount; // Shh
462         delegateAndReturn();
463     }
464 
465     /**
466      * @notice Transfer `amount` tokens from `src` to `dst`
467      * @param src The address of the source account
468      * @param dst The address of the destination account
469      * @param amount The number of tokens to transfer
470      * @return Whether or not the transfer succeeded
471      */
472     function transferFrom(
473         address src,
474         address dst,
475         uint256 amount
476     )
477         external
478         returns (bool)
479     {
480         src; dst; amount; // Shh
481         delegateAndReturn();
482     }
483 
484     /**
485      * @notice Approve `spender` to transfer up to `amount` from `src`
486      * @dev This will overwrite the approval amount for `spender`
487      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
488      * @param spender The address of the account which may transfer tokens
489      * @param amount The number of tokens that are approved (-1 means infinite)
490      * @return Whether or not the approval succeeded
491      */
492     function approve(
493         address spender,
494         uint256 amount
495     )
496         external
497         returns (bool)
498     {
499         spender; amount; // Shh
500         delegateAndReturn();
501     }
502 
503     /**
504      * @dev Increase the amount of tokens that an owner has allowed to a spender.
505      * This method should be used instead of approve() to avoid the double approval vulnerability
506      * described above.
507      * @param spender The address which will spend the funds.
508      * @param addedValue The amount of tokens to increase the allowance by.
509      */
510     function increaseAllowance(
511         address spender,
512         uint256 addedValue
513     )
514         external
515         returns (bool)
516     {
517         spender; addedValue; // Shh
518         delegateAndReturn();
519     }
520 
521     function maxScalingFactor()
522         external
523         view
524         returns (uint256)
525     {
526         delegateToViewAndReturn();
527     }
528 
529     function rebase(
530         uint256 epoch,
531         uint256 indexDelta,
532         bool positive
533     )
534         external
535         returns (uint256)
536     {
537         epoch; indexDelta; positive;
538         delegateAndReturn();
539     }
540 
541     /**
542      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
543      *
544      * @param spender The address which will spend the funds.
545      * @param subtractedValue The amount of tokens to decrease the allowance by.
546      */
547     function decreaseAllowance(
548         address spender,
549         uint256 subtractedValue
550     )
551         external
552         returns (bool)
553     {
554         spender; subtractedValue; // Shh
555         delegateAndReturn();
556     }
557 
558     /**
559      * @notice Get the current allowance from `owner` for `spender`
560      * @param owner The address of the account which owns the tokens to be spent
561      * @param spender The address of the account which may transfer tokens
562      * @return The number of tokens allowed to be spent (-1 means infinite)
563      */
564     function allowance(
565         address owner,
566         address spender
567     )
568         external
569         view
570         returns (uint256)
571     {
572         owner; spender; // Shh
573         delegateToViewAndReturn();
574     }
575 
576     /**
577      * @notice Get the current allowance from `owner` for `spender`
578      * @param delegator The address of the account which has designated a delegate
579      * @return Address of delegatee
580      */
581     function delegates(
582         address delegator
583     )
584         external
585         view
586         returns (address)
587     {
588         delegator; // Shh
589         delegateToViewAndReturn();
590     }
591 
592     /**
593      * @notice Get the token balance of the `owner`
594      * @param owner The address of the account to query
595      * @return The number of tokens owned by `owner`
596      */
597     function balanceOf(address owner)
598         external
599         view
600         returns (uint256)
601     {
602         owner; // Shh
603         delegateToViewAndReturn();
604     }
605 
606     /**
607      * @notice Currently unused. For future compatability
608      * @param owner The address of the account to query
609      * @return The number of underlying tokens owned by `owner`
610      */
611     function balanceOfUnderlying(address owner)
612         external
613         view
614         returns (uint256)
615     {
616         owner; // Shh
617         delegateToViewAndReturn();
618     }
619 
620     /*** Gov Functions ***/
621 
622     /**
623       * @notice Begins transfer of gov rights. The newPendingGov must call `_acceptGov` to finalize the transfer.
624       * @dev Gov function to begin change of gov. The newPendingGov must call `_acceptGov` to finalize the transfer.
625       * @param newPendingGov New pending gov.
626       */
627     function _setPendingGov(address newPendingGov)
628         external
629     {
630         newPendingGov; // Shh
631         delegateAndReturn();
632     }
633 
634     function _setRebaser(address rebaser_)
635         external
636     {
637         rebaser_; // Shh
638         delegateAndReturn();
639     }
640 
641     function _setIncentivizer(address incentivizer_)
642         external
643     {
644         incentivizer_; // Shh
645         delegateAndReturn();
646     }
647 
648     /**
649       * @notice Accepts transfer of gov rights. msg.sender must be pendingGov
650       * @dev Gov function for pending gov to accept role and update gov
651       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
652       */
653     function _acceptGov()
654         external
655     {
656         delegateAndReturn();
657     }
658 
659 
660     function getPriorVotes(address account, uint blockNumber)
661         external
662         view
663         returns (uint256)
664     {
665         account; blockNumber;
666         delegateToViewAndReturn();
667     }
668 
669     function delegateBySig(
670         address delegatee,
671         uint nonce,
672         uint expiry,
673         uint8 v,
674         bytes32 r,
675         bytes32 s
676     )
677         external
678     {
679         delegatee; nonce; expiry; v; r; s;
680         delegateAndReturn();
681     }
682 
683     function delegate(address delegatee)
684         external
685     {
686         delegatee;
687         delegateAndReturn();
688     }
689 
690     function getCurrentVotes(address account)
691         external
692         view
693         returns (uint256)
694     {
695         account;
696         delegateToViewAndReturn();
697     }
698 
699     /**
700      * @notice Internal method to delegate execution to another contract
701      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
702      * @param callee The contract to delegatecall
703      * @param data The raw data to delegatecall
704      * @return The returned bytes from the delegatecall
705      */
706     function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
707         (bool success, bytes memory returnData) = callee.delegatecall(data);
708         assembly {
709             if eq(success, 0) {
710                 revert(add(returnData, 0x20), returndatasize)
711             }
712         }
713         return returnData;
714     }
715 
716     /**
717      * @notice Delegates execution to the implementation contract
718      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
719      * @param data The raw data to delegatecall
720      * @return The returned bytes from the delegatecall
721      */
722     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
723         return delegateTo(implementation, data);
724     }
725 
726     /**
727      * @notice Delegates execution to an implementation contract
728      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
729      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
730      * @param data The raw data to delegatecall
731      * @return The returned bytes from the delegatecall
732      */
733     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
734         (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
735         assembly {
736             if eq(success, 0) {
737                 revert(add(returnData, 0x20), returndatasize)
738             }
739         }
740         return abi.decode(returnData, (bytes));
741     }
742 
743     function delegateToViewAndReturn() private view returns (bytes memory) {
744         (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));
745 
746         assembly {
747             let free_mem_ptr := mload(0x40)
748             returndatacopy(free_mem_ptr, 0, returndatasize)
749 
750             switch success
751             case 0 { revert(free_mem_ptr, returndatasize) }
752             default { return(add(free_mem_ptr, 0x40), returndatasize) }
753         }
754     }
755 
756     function delegateAndReturn() private returns (bytes memory) {
757         (bool success, ) = implementation.delegatecall(msg.data);
758 
759         assembly {
760             let free_mem_ptr := mload(0x40)
761             returndatacopy(free_mem_ptr, 0, returndatasize)
762 
763             switch success
764             case 0 { revert(free_mem_ptr, returndatasize) }
765             default { return(free_mem_ptr, returndatasize) }
766         }
767     }
768 
769     /**
770      * @notice Delegates execution to an implementation contract
771      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
772      */
773     function () external payable {
774         require(msg.value == 0,"YAMDelegator:fallback: cannot send value to fallback");
775 
776         // delegate all other functions to current implementation
777         delegateAndReturn();
778     }
779 }