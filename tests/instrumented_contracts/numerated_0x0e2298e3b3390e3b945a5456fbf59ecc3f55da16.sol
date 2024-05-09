1 pragma solidity 0.5.17;
2 
3 
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, reverting on
7      * overflow.
8      *
9      * Counterpart to Solidity's `+` operator.
10      *
11      * Requirements:
12      *
13      * - Addition cannot overflow.
14      */
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18 
19         return c;
20     }
21 
22     /**
23      * @dev Returns the subtraction of two unsigned integers, reverting on
24      * overflow (when the result is negative).
25      *
26      * Counterpart to Solidity's `-` operator.
27      *
28      * Requirements:
29      *
30      * - Subtraction cannot overflow.
31      */
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     /**
54      * @dev Returns the multiplication of two unsigned integers, reverting on
55      * overflow.
56      *
57      * Counterpart to Solidity's `*` operator.
58      *
59      * Requirements:
60      *
61      * - Multiplication cannot overflow.
62      */
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65         // benefit is lost if 'b' is also tested.
66         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
67         if (a == 0) {
68             return 0;
69         }
70 
71         uint256 c = a * b;
72         require(c / a == b, "SafeMath: multiplication overflow");
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the integer division of two unsigned integers. Reverts on
79      * division by zero. The result is rounded towards zero.
80      *
81      * Counterpart to Solidity's `/` operator. Note: this function uses a
82      * `revert` opcode (which leaves remaining gas untouched) while Solidity
83      * uses an invalid opcode to revert (consuming all remaining gas).
84      *
85      * Requirements:
86      *
87      * - The divisor cannot be zero.
88      */
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         return div(a, b, "SafeMath: division by zero");
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
106         require(b > 0, errorMessage);
107         uint256 c = a / b;
108         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
115      * Reverts when dividing by zero.
116      *
117      * Counterpart to Solidity's `%` operator. This function uses a `revert`
118      * opcode (which leaves remaining gas untouched) while Solidity uses an
119      * invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      *
123      * - The divisor cannot be zero.
124      */
125     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
126         return mod(a, b, "SafeMath: modulo by zero");
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts with custom message when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b != 0, errorMessage);
143         return a % b;
144     }
145 }
146 
147 
148 contract YAMTokenStorage {
149 
150     using SafeMath for uint256;
151 
152     /**
153      * @dev Guard variable for re-entrancy checks. Not currently used
154      */
155     bool internal _notEntered;
156 
157     /**
158      * @notice EIP-20 token name for this token
159      */
160     string public name;
161 
162     /**
163      * @notice EIP-20 token symbol for this token
164      */
165     string public symbol;
166 
167     /**
168      * @notice EIP-20 token decimals for this token
169      */
170     uint8 public decimals;
171 
172     /**
173      * @notice Governor for this contract
174      */
175     address public gov;
176 
177     /**
178      * @notice Pending governance for this contract
179      */
180     address public pendingGov;
181 
182     /**
183      * @notice Approved rebaser for this contract
184      */
185     address public rebaser;
186 
187     /**
188      * @notice Reserve address of YAM protocol
189      */
190     address public incentivizer;
191 
192     /**
193      * @notice Total supply of YAMs
194      */
195     uint256 public totalSupply;
196 
197     /**
198      * @notice Internal decimals used to handle scaling factor
199      */
200     uint256 public constant internalDecimals = 10**24;
201 
202     /**
203      * @notice Used for percentage maths
204      */
205     uint256 public constant BASE = 10**18;
206 
207     /**
208      * @notice Scaling factor that adjusts everyone's balances
209      */
210     uint256 public yamsScalingFactor;
211 
212     mapping (address => uint256) internal _yamBalances;
213 
214     mapping (address => mapping (address => uint256)) internal _allowedFragments;
215 
216     uint256 public initSupply;
217 
218 }
219 
220 
221 contract YAMGovernanceStorage {
222     /// @notice A record of each accounts delegate
223     mapping (address => address) internal _delegates;
224 
225     /// @notice A checkpoint for marking number of votes from a given block
226     struct Checkpoint {
227         uint32 fromBlock;
228         uint256 votes;
229     }
230 
231     /// @notice A record of votes checkpoints for each account, by index
232     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
233 
234     /// @notice The number of checkpoints for each account
235     mapping (address => uint32) public numCheckpoints;
236 
237     /// @notice The EIP-712 typehash for the contract's domain
238     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
239 
240     /// @notice The EIP-712 typehash for the delegation struct used by the contract
241     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
242 
243     /// @notice A record of states for signing / validating signatures
244     mapping (address => uint) public nonces;
245 }
246 
247 
248 contract YAMTokenInterface is YAMTokenStorage, YAMGovernanceStorage {
249 
250     /// @notice An event thats emitted when an account changes its delegate
251     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
252 
253     /// @notice An event thats emitted when a delegate account's vote balance changes
254     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
255 
256     /**
257      * @notice Event emitted when tokens are rebased
258      */
259     event Rebase(uint256 epoch, uint256 prevYamsScalingFactor, uint256 newYamsScalingFactor);
260 
261     /*** Gov Events ***/
262 
263     /**
264      * @notice Event emitted when pendingGov is changed
265      */
266     event NewPendingGov(address oldPendingGov, address newPendingGov);
267 
268     /**
269      * @notice Event emitted when gov is changed
270      */
271     event NewGov(address oldGov, address newGov);
272 
273     /**
274      * @notice Sets the rebaser contract
275      */
276     event NewRebaser(address oldRebaser, address newRebaser);
277 
278     /**
279      * @notice Sets the incentivizer contract
280      */
281     event NewIncentivizer(address oldIncentivizer, address newIncentivizer);
282 
283     /* - ERC20 Events - */
284 
285     /**
286      * @notice EIP20 Transfer event
287      */
288     event Transfer(address indexed from, address indexed to, uint amount);
289 
290     /**
291      * @notice EIP20 Approval event
292      */
293     event Approval(address indexed owner, address indexed spender, uint amount);
294 
295     /* - Extra Events - */
296     /**
297      * @notice Tokens minted event
298      */
299     event Mint(address to, uint256 amount);
300 
301     // Public functions
302     function transfer(address to, uint256 value) external returns(bool);
303     function transferFrom(address from, address to, uint256 value) external returns(bool);
304     function balanceOf(address who) external view returns(uint256);
305     function balanceOfUnderlying(address who) external view returns(uint256);
306     function allowance(address owner_, address spender) external view returns(uint256);
307     function approve(address spender, uint256 value) external returns (bool);
308     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
309     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
310     function maxScalingFactor() external view returns (uint256);
311 
312     /* - Governance Functions - */
313     function getPriorVotes(address account, uint blockNumber) external view returns (uint256);
314     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external;
315     function delegate(address delegatee) external;
316     function delegates(address delegator) external view returns (address);
317     function getCurrentVotes(address account) external view returns (uint256);
318 
319     /* - Permissioned/Governance functions - */
320     function mint(address to, uint256 amount) external returns (bool);
321     function rebase(uint256 epoch, uint256 indexDelta, bool positive) external returns (uint256);
322     function _setRebaser(address rebaser_) external;
323     function _setIncentivizer(address incentivizer_) external;
324     function _setPendingGov(address pendingGov_) external;
325     function _acceptGov() external;
326 }
327 
328 
329 contract YAMDelegationStorage {
330     /**
331      * @notice Implementation address for this contract
332      */
333     address public implementation;
334 }
335 
336 contract YAMDelegatorInterface is YAMDelegationStorage {
337     /**
338      * @notice Emitted when implementation is changed
339      */
340     event NewImplementation(address oldImplementation, address newImplementation);
341 
342     /**
343      * @notice Called by the gov to update the implementation of the delegator
344      * @param implementation_ The address of the new implementation for delegation
345      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
346      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
347      */
348     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public;
349 }
350 
351 contract YAMDelegator is YAMTokenInterface, YAMDelegatorInterface {
352     /**
353      * @notice Construct a new YAM
354      * @param name_ ERC-20 name of this token
355      * @param symbol_ ERC-20 symbol of this token
356      * @param decimals_ ERC-20 decimal precision of this token
357      * @param initSupply_ Initial token amount
358      * @param implementation_ The address of the implementation the contract delegates to
359      * @param becomeImplementationData The encoded args for becomeImplementation
360      */
361     constructor(
362         string memory name_,
363         string memory symbol_,
364         uint8 decimals_,
365         uint256 initSupply_,
366         address implementation_,
367         bytes memory becomeImplementationData
368     )
369         public
370     {
371 
372 
373         // Creator of the contract is gov during initialization
374         gov = msg.sender;
375 
376         // First delegate gets to initialize the delegator (i.e. storage contract)
377         delegateTo(
378             implementation_,
379             abi.encodeWithSignature(
380                 "initialize(string,string,uint8,address,uint256)",
381                 name_,
382                 symbol_,
383                 decimals_,
384                 msg.sender,
385                 initSupply_
386             )
387         );
388 
389         // New implementations always get set via the settor (post-initialize)
390         _setImplementation(implementation_, false, becomeImplementationData);
391 
392     }
393 
394     /**
395      * @notice Called by the gov to update the implementation of the delegator
396      * @param implementation_ The address of the new implementation for delegation
397      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
398      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
399      */
400     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public {
401         require(msg.sender == gov, "YAMDelegator::_setImplementation: Caller must be gov");
402 
403         if (allowResign) {
404             delegateToImplementation(abi.encodeWithSignature("_resignImplementation()"));
405         }
406 
407         address oldImplementation = implementation;
408         implementation = implementation_;
409 
410         delegateToImplementation(abi.encodeWithSignature("_becomeImplementation(bytes)", becomeImplementationData));
411 
412         emit NewImplementation(oldImplementation, implementation);
413     }
414 
415     /**
416      * @notice Sender supplies assets into the market and receives cTokens in exchange
417      * @dev Accrues interest whether or not the operation succeeds, unless reverted
418      * @param mintAmount The amount of the underlying asset to supply
419      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
420      */
421     function mint(address to, uint256 mintAmount)
422         external
423         returns (bool)
424     {
425         to; mintAmount; // Shh
426         delegateAndReturn();
427     }
428 
429     /**
430      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
431      * @param dst The address of the destination account
432      * @param amount The number of tokens to transfer
433      * @return Whether or not the transfer succeeded
434      */
435     function transfer(address dst, uint256 amount)
436         external
437         returns (bool)
438     {
439         dst; amount; // Shh
440         delegateAndReturn();
441     }
442 
443     /**
444      * @notice Transfer `amount` tokens from `src` to `dst`
445      * @param src The address of the source account
446      * @param dst The address of the destination account
447      * @param amount The number of tokens to transfer
448      * @return Whether or not the transfer succeeded
449      */
450     function transferFrom(
451         address src,
452         address dst,
453         uint256 amount
454     )
455         external
456         returns (bool)
457     {
458         src; dst; amount; // Shh
459         delegateAndReturn();
460     }
461 
462     /**
463      * @notice Approve `spender` to transfer up to `amount` from `src`
464      * @dev This will overwrite the approval amount for `spender`
465      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
466      * @param spender The address of the account which may transfer tokens
467      * @param amount The number of tokens that are approved (-1 means infinite)
468      * @return Whether or not the approval succeeded
469      */
470     function approve(
471         address spender,
472         uint256 amount
473     )
474         external
475         returns (bool)
476     {
477         spender; amount; // Shh
478         delegateAndReturn();
479     }
480 
481     /**
482      * @dev Increase the amount of tokens that an owner has allowed to a spender.
483      * This method should be used instead of approve() to avoid the double approval vulnerability
484      * described above.
485      * @param spender The address which will spend the funds.
486      * @param addedValue The amount of tokens to increase the allowance by.
487      */
488     function increaseAllowance(
489         address spender,
490         uint256 addedValue
491     )
492         external
493         returns (bool)
494     {
495         spender; addedValue; // Shh
496         delegateAndReturn();
497     }
498 
499     function maxScalingFactor()
500         external
501         view
502         returns (uint256)
503     {
504         delegateToViewAndReturn();
505     }
506 
507     function rebase(
508         uint256 epoch,
509         uint256 indexDelta,
510         bool positive
511     )
512         external
513         returns (uint256)
514     {
515         epoch; indexDelta; positive;
516         delegateAndReturn();
517     }
518 
519     /**
520      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
521      *
522      * @param spender The address which will spend the funds.
523      * @param subtractedValue The amount of tokens to decrease the allowance by.
524      */
525     function decreaseAllowance(
526         address spender,
527         uint256 subtractedValue
528     )
529         external
530         returns (bool)
531     {
532         spender; subtractedValue; // Shh
533         delegateAndReturn();
534     }
535 
536     /**
537      * @notice Get the current allowance from `owner` for `spender`
538      * @param owner The address of the account which owns the tokens to be spent
539      * @param spender The address of the account which may transfer tokens
540      * @return The number of tokens allowed to be spent (-1 means infinite)
541      */
542     function allowance(
543         address owner,
544         address spender
545     )
546         external
547         view
548         returns (uint256)
549     {
550         owner; spender; // Shh
551         delegateToViewAndReturn();
552     }
553 
554     /**
555      * @notice Get the current allowance from `owner` for `spender`
556      * @param delegator The address of the account which has designated a delegate
557      * @return Address of delegatee
558      */
559     function delegates(
560         address delegator
561     )
562         external
563         view
564         returns (address)
565     {
566         delegator; // Shh
567         delegateToViewAndReturn();
568     }
569 
570     /**
571      * @notice Get the token balance of the `owner`
572      * @param owner The address of the account to query
573      * @return The number of tokens owned by `owner`
574      */
575     function balanceOf(address owner)
576         external
577         view
578         returns (uint256)
579     {
580         owner; // Shh
581         delegateToViewAndReturn();
582     }
583 
584     /**
585      * @notice Currently unused. For future compatability
586      * @param owner The address of the account to query
587      * @return The number of underlying tokens owned by `owner`
588      */
589     function balanceOfUnderlying(address owner)
590         external
591         view
592         returns (uint256)
593     {
594         owner; // Shh
595         delegateToViewAndReturn();
596     }
597 
598     /*** Gov Functions ***/
599 
600     /**
601       * @notice Begins transfer of gov rights. The newPendingGov must call `_acceptGov` to finalize the transfer.
602       * @dev Gov function to begin change of gov. The newPendingGov must call `_acceptGov` to finalize the transfer.
603       * @param newPendingGov New pending gov.
604       */
605     function _setPendingGov(address newPendingGov)
606         external
607     {
608         newPendingGov; // Shh
609         delegateAndReturn();
610     }
611 
612     function _setRebaser(address rebaser_)
613         external
614     {
615         rebaser_; // Shh
616         delegateAndReturn();
617     }
618 
619     function _setIncentivizer(address incentivizer_)
620         external
621     {
622         incentivizer_; // Shh
623         delegateAndReturn();
624     }
625 
626     /**
627       * @notice Accepts transfer of gov rights. msg.sender must be pendingGov
628       * @dev Gov function for pending gov to accept role and update gov
629       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
630       */
631     function _acceptGov()
632         external
633     {
634         delegateAndReturn();
635     }
636 
637 
638     function getPriorVotes(address account, uint blockNumber)
639         external
640         view
641         returns (uint256)
642     {
643         account; blockNumber;
644         delegateToViewAndReturn();
645     }
646 
647     function delegateBySig(
648         address delegatee,
649         uint nonce,
650         uint expiry,
651         uint8 v,
652         bytes32 r,
653         bytes32 s
654     )
655         external
656     {
657         delegatee; nonce; expiry; v; r; s;
658         delegateAndReturn();
659     }
660 
661     function delegate(address delegatee)
662         external
663     {
664         delegatee;
665         delegateAndReturn();
666     }
667 
668     function getCurrentVotes(address account)
669         external
670         view
671         returns (uint256)
672     {
673         account;
674         delegateToViewAndReturn();
675     }
676 
677     /**
678      * @notice Internal method to delegate execution to another contract
679      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
680      * @param callee The contract to delegatecall
681      * @param data The raw data to delegatecall
682      * @return The returned bytes from the delegatecall
683      */
684     function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
685         (bool success, bytes memory returnData) = callee.delegatecall(data);
686         assembly {
687             if eq(success, 0) {
688                 revert(add(returnData, 0x20), returndatasize)
689             }
690         }
691         return returnData;
692     }
693 
694     /**
695      * @notice Delegates execution to the implementation contract
696      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
697      * @param data The raw data to delegatecall
698      * @return The returned bytes from the delegatecall
699      */
700     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
701         return delegateTo(implementation, data);
702     }
703 
704     /**
705      * @notice Delegates execution to an implementation contract
706      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
707      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
708      * @param data The raw data to delegatecall
709      * @return The returned bytes from the delegatecall
710      */
711     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
712         (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
713         assembly {
714             if eq(success, 0) {
715                 revert(add(returnData, 0x20), returndatasize)
716             }
717         }
718         return abi.decode(returnData, (bytes));
719     }
720 
721     function delegateToViewAndReturn() private view returns (bytes memory) {
722         (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));
723 
724         assembly {
725             let free_mem_ptr := mload(0x40)
726             returndatacopy(free_mem_ptr, 0, returndatasize)
727 
728             switch success
729             case 0 { revert(free_mem_ptr, returndatasize) }
730             default { return(add(free_mem_ptr, 0x40), returndatasize) }
731         }
732     }
733 
734     function delegateAndReturn() private returns (bytes memory) {
735         (bool success, ) = implementation.delegatecall(msg.data);
736 
737         assembly {
738             let free_mem_ptr := mload(0x40)
739             returndatacopy(free_mem_ptr, 0, returndatasize)
740 
741             switch success
742             case 0 { revert(free_mem_ptr, returndatasize) }
743             default { return(free_mem_ptr, returndatasize) }
744         }
745     }
746 
747     /**
748      * @notice Delegates execution to an implementation contract
749      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
750      */
751     function () external payable {
752         require(msg.value == 0,"YAMDelegator:fallback: cannot send value to fallback");
753 
754         // delegate all other functions to current implementation
755         delegateAndReturn();
756     }
757 }