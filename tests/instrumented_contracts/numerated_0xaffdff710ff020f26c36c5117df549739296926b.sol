1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-28
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.6.12;
7 
8 // Subject to the MIT license.
9 
10 /**
11  * Rekeep3r.network 
12  * A standard implementation of kp3rv1 protocol
13  * Mint function capped 
14  * Kept most of the original functionality
15  */
16 library SafeMath {
17    
18     function add(uint a, uint b) internal pure returns (uint) {
19         uint c = a + b;
20         require(c >= a, "add: +");
21 
22         return c;
23     }
24 
25     
26     function add(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
27         uint c = a + b;
28         require(c >= a, errorMessage);
29 
30         return c;
31     }
32 
33     
34     function sub(uint a, uint b) internal pure returns (uint) {
35         return sub(a, b, "sub: -");
36     }
37 
38     
39     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
40         require(b <= a, errorMessage);
41         uint c = a - b;
42 
43         return c;
44     }
45 
46     
47     function mul(uint a, uint b) internal pure returns (uint) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51         if (a == 0) {
52             return 0;
53         }
54 
55         uint c = a * b;
56         require(c / a == b, "mul: *");
57 
58         return c;
59     }
60 
61     
62     function mul(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
63        
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint c = a * b;
69         require(c / a == b, errorMessage);
70 
71         return c;
72     }
73 
74     
75     function div(uint a, uint b) internal pure returns (uint) {
76         return div(a, b, "div: /");
77     }
78 
79     
80     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
81         // Solidity only automatically asserts when dividing by 0
82         require(b > 0, errorMessage);
83         uint c = a / b;
84         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85 
86         return c;
87     }
88 
89    
90     function mod(uint a, uint b) internal pure returns (uint) {
91         return mod(a, b, "mod: %");
92     }
93 
94     
95     function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
96         require(b != 0, errorMessage);
97         return a % b;
98     }
99 }
100 
101 /**
102  * @dev Contract module that helps prevent reentrant calls to a function.
103  *
104  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
105  * available, which can be applied to functions to make sure there are no nested
106  * (reentrant) calls to them.
107  *
108  * Note that because there is a single `nonReentrant` guard, functions marked as
109  * `nonReentrant` may not call one another. This can be worked around by making
110  * those functions `private`, and then adding `external` `nonReentrant` entry
111  * points to them.
112  *
113  * TIP: If you would like to learn more about reentrancy and alternative ways
114  * to protect against it, check out our blog post
115  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
116  */
117 contract ReentrancyGuard {
118     // Booleans are more expensive than uint256 or any type that takes up a full
119     // word because each write operation emits an extra SLOAD to first read the
120     // slot's contents, replace the bits taken up by the boolean, and then write
121     // back. This is the compiler's defense against contract upgrades and
122     // pointer aliasing, and it cannot be disabled.
123 
124     // The values being non-zero value makes deployment a bit more expensive,
125     // but in exchange the refund on every call to nonReentrant will be lower in
126     // amount. Since refunds are capped to a percentage of the total
127     // transaction's gas, it is best to keep them low in cases like this one, to
128     // increase the likelihood of the full refund coming into effect.
129     uint256 private constant _NOT_ENTERED = 1;
130     uint256 private constant _ENTERED = 2;
131 
132     uint256 private _status;
133 
134     constructor () internal {
135         _status = _NOT_ENTERED;
136     }
137 
138     /**
139      * @dev Prevents a contract from calling itself, directly or indirectly.
140      * Calling a `nonReentrant` function from another `nonReentrant`
141      * function is not supported. It is possible to prevent this from happening
142      * by making the `nonReentrant` function external, and make it call a
143      * `private` function that does the actual work.
144      */
145     modifier nonReentrant() {
146         // On the first call to nonReentrant, _notEntered will be true
147         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
148 
149         // Any calls to nonReentrant after this point will fail
150         _status = _ENTERED;
151 
152         _;
153 
154         // By storing the original value once again, a refund is triggered (see
155         // https://eips.ethereum.org/EIPS/eip-2200)
156         _status = _NOT_ENTERED;
157     }
158 }
159 
160 /**
161  * @dev Interface of the ERC20 standard as defined in the EIP.
162  */
163 interface IERC20 {
164     /**
165      * @dev Returns the amount of tokens in existence.
166      */
167     function totalSupply() external view returns (uint256);
168 
169     /**
170      * @dev Returns the amount of tokens owned by `account`.
171      */
172     function balanceOf(address account) external view returns (uint256);
173 
174     /**
175      * @dev Moves `amount` tokens from the caller's account to `recipient`.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transfer(address recipient, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Returns the remaining number of tokens that `spender` will be
185      * allowed to spend on behalf of `owner` through {transferFrom}. This is
186      * zero by default.
187      *
188      * This value changes when {approve} or {transferFrom} are called.
189      */
190     function allowance(address owner, address spender) external view returns (uint256);
191 
192     /**
193      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
194      *
195      * Returns a boolean value indicating whether the operation succeeded.
196      *
197      * IMPORTANT: Beware that changing an allowance with this method brings the risk
198      * that someone may use both the old and the new allowance by unfortunate
199      * transaction ordering. One possible solution to mitigate this race
200      * condition is to first reduce the spender's allowance to 0 and set the
201      * desired value afterwards:
202      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203      *
204      * Emits an {Approval} event.
205      */
206     function approve(address spender, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Moves `amount` tokens from `sender` to `recipient` using the
210      * allowance mechanism. `amount` is then deducted from the caller's
211      * allowance.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Emitted when `value` tokens are moved from one account (`from`) to
221      * another (`to`).
222      *
223      * Note that `value` may be zero.
224      */
225     event Transfer(address indexed from, address indexed to, uint256 value);
226 
227     /**
228      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
229      * a call to {approve}. `value` is the new allowance.
230      */
231     event Approval(address indexed owner, address indexed spender, uint256 value);
232 }
233 
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      */
255     function isContract(address account) internal view returns (bool) {
256         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
257         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
258         // for accounts without code, i.e. `keccak256('')`
259         bytes32 codehash;
260         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
261         // solhint-disable-next-line no-inline-assembly
262         assembly { codehash := extcodehash(account) }
263         return (codehash != accountHash && codehash != 0x0);
264     }
265 
266     /**
267      * @dev Converts an `address` into `address payable`. Note that this is
268      * simply a type cast: the actual underlying value is not changed.
269      *
270      * _Available since v2.4.0._
271      */
272     function toPayable(address account) internal pure returns (address payable) {
273         return address(uint160(account));
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      *
292      * _Available since v2.4.0._
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient");
296 
297         // solhint-disable-next-line avoid-call-value
298         (bool success, ) = recipient.call{value:amount}("");
299         require(success, "Address: reverted");
300     }
301 }
302 
303 /**
304  * @title SafeERC20
305  * @dev Wrappers around ERC20 operations that throw on failure (when the token
306  * contract returns false). Tokens that return no value (and instead revert or
307  * throw on failure) are also supported, non-reverting calls are assumed to be
308  * successful.
309  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
310  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
311  */
312 library SafeERC20 {
313     using SafeMath for uint256;
314     using Address for address;
315 
316     function safeTransfer(IERC20 token, address to, uint256 value) internal {
317         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
318     }
319 
320     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
321         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
322     }
323 
324     function safeApprove(IERC20 token, address spender, uint256 value) internal {
325         // safeApprove should only be called when setting an initial allowance,
326         // or when resetting it to zero. To increase and decrease it, use
327         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
328         // solhint-disable-next-line max-line-length
329         require((value == 0) || (token.allowance(address(this), spender) == 0),
330             "SafeERC20: approve from non-zero to non-zero allowance"
331         );
332         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
333     }
334 
335     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
336         uint256 newAllowance = token.allowance(address(this), spender).add(value);
337         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
338     }
339 
340     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
341         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: < 0");
342         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
343     }
344 
345     /**
346      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
347      * on the return value: the return value is optional (but if data is returned, it must not be false).
348      * @param token The token targeted by the call.
349      * @param data The call data (encoded using abi.encode or one of its variants).
350      */
351     function callOptionalReturn(IERC20 token, bytes memory data) private {
352         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
353         // we're implementing it ourselves.
354 
355         // A Solidity high level call has three parts:
356         //  1. The target address is checked to verify it contains contract code
357         //  2. The call itself is made, and success asserted
358         //  3. The return value is decoded, which in turn checks the size of the returned data.
359         // solhint-disable-next-line max-line-length
360         require(address(token).isContract(), "SafeERC20: !contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = address(token).call(data);
364         require(success, "SafeERC20: low-level call failed");
365 
366         if (returndata.length > 0) { // Return data is optional
367             // solhint-disable-next-line max-line-length
368             require(abi.decode(returndata, (bool)), "SafeERC20: !succeed");
369         }
370     }
371 }
372 
373 library Keep3rV1Library {
374     function getReserve(address pair, address reserve) external view returns (uint) {
375         (uint _r0, uint _r1,) = IUniswapV2Pair(pair).getReserves();
376         if (IUniswapV2Pair(pair).token0() == reserve) {
377             return _r0;
378         } else if (IUniswapV2Pair(pair).token1() == reserve) {
379             return _r1;
380         } else {
381             return 0;
382         }
383     }
384 }
385 
386 interface IUniswapV2Pair {
387     event Approval(address indexed owner, address indexed spender, uint value);
388     event Transfer(address indexed from, address indexed to, uint value);
389 
390     function name() external pure returns (string memory);
391     function symbol() external pure returns (string memory);
392     function decimals() external pure returns (uint8);
393     function totalSupply() external view returns (uint);
394     function balanceOf(address owner) external view returns (uint);
395     function allowance(address owner, address spender) external view returns (uint);
396 
397     function approve(address spender, uint value) external returns (bool);
398     function transfer(address to, uint value) external returns (bool);
399     function transferFrom(address from, address to, uint value) external returns (bool);
400 
401     function DOMAIN_SEPARATOR() external view returns (bytes32);
402     function PERMIT_TYPEHASH() external pure returns (bytes32);
403     function nonces(address owner) external view returns (uint);
404 
405     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
406 
407     event Mint(address indexed sender, uint amount0, uint amount1);
408     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
409     event Swap(
410         address indexed sender,
411         uint amount0In,
412         uint amount1In,
413         uint amount0Out,
414         uint amount1Out,
415         address indexed to
416     );
417     event Sync(uint112 reserve0, uint112 reserve1);
418 
419     function MINIMUM_LIQUIDITY() external pure returns (uint);
420     function factory() external view returns (address);
421     function token0() external view returns (address);
422     function token1() external view returns (address);
423     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
424     function price0CumulativeLast() external view returns (uint);
425     function price1CumulativeLast() external view returns (uint);
426     function kLast() external view returns (uint);
427 
428     function mint(address to) external returns (uint liquidity);
429     function burn(address to) external returns (uint amount0, uint amount1);
430     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
431     function skim(address to) external;
432     function sync() external;
433 
434     function initialize(address, address) external;
435 }
436 
437 interface IGovernance {
438     function proposeJob(address job) external;
439 }
440 
441 interface IKeep3rV1Helper {
442     function getQuoteLimit(uint gasUsed) external view returns (uint);
443 }
444 
445 contract Keep3rV1 is ReentrancyGuard {
446     using SafeMath for uint;
447     using SafeERC20 for IERC20;
448 
449     /// @notice Keep3r Helper to set max prices for the ecosystem
450     IKeep3rV1Helper public KPRH;
451 
452     /// @notice EIP-20 token name for this token
453     string public constant name = "reKeep3r";
454 
455     /// @notice EIP-20 token symbol for this token
456     string public constant symbol = "REKP3R";
457 
458     /// @notice EIP-20 token decimals for this token
459     uint8 public constant decimals = 18;
460     
461     // introducing max cap for owner 
462     uint256 public maxCap;
463 
464     /// @notice Total number of tokens in circulation
465     uint public totalSupply = 0; // Initial 0
466 
467     /// @notice A record of each accounts delegate
468     mapping (address => address) public delegates;
469 
470     /// @notice A record of votes checkpoints for each account, by index
471     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
472 
473     /// @notice The number of checkpoints for each account
474     mapping (address => uint32) public numCheckpoints;
475 
476     mapping (address => mapping (address => uint)) internal allowances;
477     mapping (address => uint) internal balances;
478 
479     /// @notice The EIP-712 typehash for the contract's domain
480     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint chainId,address verifyingContract)");
481     bytes32 public immutable DOMAINSEPARATOR;
482 
483     /// @notice The EIP-712 typehash for the delegation struct used by the contract
484     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint nonce,uint expiry)");
485 
486     /// @notice The EIP-712 typehash for the permit struct used by the contract
487     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint value,uint nonce,uint deadline)");
488 
489 
490     /// @notice A record of states for signing / validating signatures
491     mapping (address => uint) public nonces;
492 
493     /// @notice An event thats emitted when an account changes its delegate
494     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
495 
496     /// @notice An event thats emitted when a delegate account's vote balance changes
497     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
498 
499     /// @notice A checkpoint for marking number of votes from a given block
500     struct Checkpoint {
501         uint32 fromBlock;
502         uint votes;
503     }
504 
505     /**
506      * @notice Delegate votes from `msg.sender` to `delegatee`
507      * @param delegatee The address to delegate votes to
508      */
509     function delegate(address delegatee) public {
510         _delegate(msg.sender, delegatee);
511     }
512 
513     /**
514      * @notice Delegates votes from signatory to `delegatee`
515      * @param delegatee The address to delegate votes to
516      * @param nonce The contract state required to match the signature
517      * @param expiry The time at which to expire the signature
518      * @param v The recovery byte of the signature
519      * @param r Half of the ECDSA signature pair
520      * @param s Half of the ECDSA signature pair
521      */
522     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
523         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
524         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAINSEPARATOR, structHash));
525         address signatory = ecrecover(digest, v, r, s);
526         require(signatory != address(0), "delegateBySig: sig");
527         require(nonce == nonces[signatory]++, "delegateBySig: nonce");
528         require(now <= expiry, "delegateBySig: expired");
529         _delegate(signatory, delegatee);
530     }
531 
532     /**
533      * @notice Gets the current votes balance for `account`
534      * @param account The address to get votes balance
535      * @return The number of current votes for `account`
536      */
537     function getCurrentVotes(address account) external view returns (uint) {
538         uint32 nCheckpoints = numCheckpoints[account];
539         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
540     }
541 
542     /**
543      * @notice Determine the prior number of votes for an account as of a block number
544      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
545      * @param account The address of the account to check
546      * @param blockNumber The block number to get the vote balance at
547      * @return The number of votes the account had as of the given block
548      */
549     function getPriorVotes(address account, uint blockNumber) public view returns (uint) {
550         require(blockNumber < block.number, "getPriorVotes:");
551 
552         uint32 nCheckpoints = numCheckpoints[account];
553         if (nCheckpoints == 0) {
554             return 0;
555         }
556 
557         // First check most recent balance
558         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
559             return checkpoints[account][nCheckpoints - 1].votes;
560         }
561 
562         // Next check implicit zero balance
563         if (checkpoints[account][0].fromBlock > blockNumber) {
564             return 0;
565         }
566 
567         uint32 lower = 0;
568         uint32 upper = nCheckpoints - 1;
569         while (upper > lower) {
570             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
571             Checkpoint memory cp = checkpoints[account][center];
572             if (cp.fromBlock == blockNumber) {
573                 return cp.votes;
574             } else if (cp.fromBlock < blockNumber) {
575                 lower = center;
576             } else {
577                 upper = center - 1;
578             }
579         }
580         return checkpoints[account][lower].votes;
581     }
582 
583     function _delegate(address delegator, address delegatee) internal {
584         address currentDelegate = delegates[delegator];
585         uint delegatorBalance = votes[delegator].add(bonds[delegator][address(this)]);
586         delegates[delegator] = delegatee;
587 
588         emit DelegateChanged(delegator, currentDelegate, delegatee);
589 
590         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
591     }
592 
593     function _moveDelegates(address srcRep, address dstRep, uint amount) internal {
594         if (srcRep != dstRep && amount > 0) {
595             if (srcRep != address(0)) {
596                 uint32 srcRepNum = numCheckpoints[srcRep];
597                 uint srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
598                 uint srcRepNew = srcRepOld.sub(amount, "_moveVotes: underflows");
599                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
600             }
601 
602             if (dstRep != address(0)) {
603                 uint32 dstRepNum = numCheckpoints[dstRep];
604                 uint dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
605                 uint dstRepNew = dstRepOld.add(amount);
606                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
607             }
608         }
609     }
610 
611     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint oldVotes, uint newVotes) internal {
612       uint32 blockNumber = safe32(block.number, "_writeCheckpoint: 32 bits");
613 
614       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
615           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
616       } else {
617           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
618           numCheckpoints[delegatee] = nCheckpoints + 1;
619       }
620 
621       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
622     }
623 
624     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
625         require(n < 2**32, errorMessage);
626         return uint32(n);
627     }
628 
629     /// @notice The standard EIP-20 transfer event
630     event Transfer(address indexed from, address indexed to, uint amount);
631 
632     /// @notice The standard EIP-20 approval event
633     event Approval(address indexed owner, address indexed spender, uint amount);
634 
635     /// @notice Submit a job
636     event SubmitJob(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);
637 
638     /// @notice Apply credit to a job
639     event ApplyCredit(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);
640 
641     /// @notice Remove credit for a job
642     event RemoveJob(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);
643 
644     /// @notice Unbond credit for a job
645     event UnbondJob(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);
646 
647     /// @notice Added a Job
648     event JobAdded(address indexed job, uint block, address governance);
649 
650     /// @notice Removed a job
651     event JobRemoved(address indexed job, uint block, address governance);
652 
653     /// @notice Worked a job
654     event KeeperWorked(address indexed credit, address indexed job, address indexed keeper, uint block, uint amount);
655 
656     /// @notice Keeper bonding
657     event KeeperBonding(address indexed keeper, uint block, uint active, uint bond);
658 
659     /// @notice Keeper bonded
660     event KeeperBonded(address indexed keeper, uint block, uint activated, uint bond);
661 
662     /// @notice Keeper unbonding
663     event KeeperUnbonding(address indexed keeper, uint block, uint deactive, uint bond);
664 
665     /// @notice Keeper unbound
666     event KeeperUnbound(address indexed keeper, uint block, uint deactivated, uint bond);
667 
668     /// @notice Keeper slashed
669     event KeeperSlashed(address indexed keeper, address indexed slasher, uint block, uint slash);
670 
671     /// @notice Keeper disputed
672     event KeeperDispute(address indexed keeper, uint block);
673 
674     /// @notice Keeper resolved
675     event KeeperResolved(address indexed keeper, uint block);
676 
677     event AddCredit(address indexed credit, address indexed job, address indexed creditor, uint block, uint amount);
678 
679     /// @notice 1 day to bond to become a keeper
680     uint constant public BOND = 3 days;
681     /// @notice 14 days to unbond to remove funds from being a keeper
682     uint constant public UNBOND = 14 days;
683     /// @notice 3 days till liquidity can be bound
684     uint constant public LIQUIDITYBOND = 3 days;
685 
686     /// @notice direct liquidity fee 0.3%
687     uint constant public FEE = 30;
688     uint constant public BASE = 10000;
689 
690     /// @notice address used for ETH transfers
691     address constant public ETH = address(0xE);
692 
693     /// @notice tracks all current bondings (time)
694     mapping(address => mapping(address => uint)) public bondings;
695     /// @notice tracks all current unbondings (time)
696     mapping(address => mapping(address => uint)) public unbondings;
697     /// @notice allows for partial unbonding
698     mapping(address => mapping(address => uint)) public partialUnbonding;
699     /// @notice tracks all current pending bonds (amount)
700     mapping(address => mapping(address => uint)) public pendingbonds;
701     /// @notice tracks how much a keeper has bonded
702     mapping(address => mapping(address => uint)) public bonds;
703     /// @notice tracks underlying votes (that don't have bond)
704     mapping(address => uint) public votes;
705 
706     /// @notice total bonded (totalSupply for bonds)
707     uint public totalBonded = 0;
708     /// @notice tracks when a keeper was first registered
709     mapping(address => uint) public firstSeen;
710 
711     /// @notice tracks if a keeper has a pending dispute
712     mapping(address => bool) public disputes;
713 
714     /// @notice tracks last job performed for a keeper
715     mapping(address => uint) public lastJob;
716     /// @notice tracks the total job executions for a keeper
717     mapping(address => uint) public workCompleted;
718     /// @notice list of all jobs registered for the keeper system
719     mapping(address => bool) public jobs;
720     /// @notice the current credit available for a job
721     mapping(address => mapping(address => uint)) public credits;
722     /// @notice the balances for the liquidity providers
723     mapping(address => mapping(address => mapping(address => uint))) public liquidityProvided;
724     /// @notice liquidity unbonding days
725     mapping(address => mapping(address => mapping(address => uint))) public liquidityUnbonding;
726     /// @notice liquidity unbonding amounts
727     mapping(address => mapping(address => mapping(address => uint))) public liquidityAmountsUnbonding;
728     /// @notice job proposal delay
729     mapping(address => uint) public jobProposalDelay;
730     /// @notice liquidity apply date
731     mapping(address => mapping(address => mapping(address => uint))) public liquidityApplied;
732     /// @notice liquidity amount to apply
733     mapping(address => mapping(address => mapping(address => uint))) public liquidityAmount;
734 
735     /// @notice list of all current keepers
736     mapping(address => bool) public keepers;
737     /// @notice blacklist of keepers not allowed to participate
738     mapping(address => bool) public blacklist;
739 
740     /// @notice traversable array of keepers to make external management easier
741     address[] public keeperList;
742     /// @notice traversable array of jobs to make external management easier
743     address[] public jobList;
744 
745     /// @notice governance address for the governance contract
746     address public governance;
747     address public pendingGovernance;
748 
749     /// @notice the liquidity token supplied by users paying for jobs
750     mapping(address => bool) public liquidityAccepted;
751 
752     address[] public liquidityPairs;
753 
754     uint internal _gasUsed;
755 
756     constructor(address _kph, uint256 _maxCap) public {
757         // Set governance for this token
758 		// There will only be a limited supply of tokens ever
759         governance = msg.sender;
760         DOMAINSEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), _getChainId(), address(this)));
761         KPRH = IKeep3rV1Helper(_kph);
762         maxCap = _maxCap;
763     }
764 
765     /**
766      * @notice Add ETH credit to a job to be paid out for work
767      * @param job the job being credited
768      */
769     function addCreditETH(address job) external payable {
770         require(jobs[job], "addCreditETH: !job");
771         uint _fee = msg.value.mul(FEE).div(BASE);
772         credits[job][ETH] = credits[job][ETH].add(msg.value.sub(_fee));
773         payable(governance).transfer(_fee);
774 
775         emit AddCredit(ETH, job, msg.sender, block.number, msg.value);
776     }
777 
778     /**
779      * @notice Add credit to a job to be paid out for work
780      * @param credit the credit being assigned to the job
781      * @param job the job being credited
782      * @param amount the amount of credit being added to the job
783      */
784     function addCredit(address credit, address job, uint amount) external nonReentrant {
785         require(jobs[job], "addCreditETH: !job");
786         uint _before = IERC20(credit).balanceOf(address(this));
787         IERC20(credit).safeTransferFrom(msg.sender, address(this), amount);
788         uint _received = IERC20(credit).balanceOf(address(this)).sub(_before);
789         uint _fee = _received.mul(FEE).div(BASE);
790         credits[job][credit] = credits[job][credit].add(_received.sub(_fee));
791         IERC20(credit).safeTransfer(governance, _fee);
792 
793         emit AddCredit(credit, job, msg.sender, block.number, _received);
794     }
795 
796     /**
797      * @notice Add non transferable votes for governance
798      * @param voter to add the votes to
799      * @param amount of votes to add
800      */
801     function addVotes(address voter, uint amount) external {
802         require(msg.sender == governance, "addVotes: !gov");
803         _activate(voter, address(this));
804         votes[voter] = votes[voter].add(amount);
805         totalBonded = totalBonded.add(amount);
806         _moveDelegates(address(0), delegates[voter], amount);
807     }
808 
809     /**
810      * @notice Remove non transferable votes for governance
811      * @param voter to subtract the votes
812      * @param amount of votes to remove
813      */
814     function removeVotes(address voter, uint amount) external {
815         require(msg.sender == governance, "addVotes: !gov");
816         votes[voter] = votes[voter].sub(amount);
817         totalBonded = totalBonded.sub(amount);
818         _moveDelegates(delegates[voter], address(0), amount);
819     }
820 
821     /**
822      * @notice Add credit to a job to be paid out for work
823      * @param job the job being credited
824      * @param amount the amount of credit being added to the job
825      */
826     function addKPRCredit(address job, uint amount) external {
827         require(msg.sender == governance, "addKPRCredit: !gov");
828         require(jobs[job], "addKPRCredit: !job");
829         credits[job][address(this)] = credits[job][address(this)].add(amount);
830         _mint(address(this), amount);
831         emit AddCredit(address(this), job, msg.sender, block.number, amount);
832     }
833 
834     /**
835      * @notice Approve a liquidity pair for being accepted in future
836      * @param liquidity the liquidity no longer accepted
837      */
838     function approveLiquidity(address liquidity) external {
839         require(msg.sender == governance, "approveLiquidity: !gov");
840         require(!liquidityAccepted[liquidity], "approveLiquidity: !pair");
841         liquidityAccepted[liquidity] = true;
842         liquidityPairs.push(liquidity);
843     }
844 
845     /**
846      * @notice Revoke a liquidity pair from being accepted in future
847      * @param liquidity the liquidity no longer accepted
848      */
849     function revokeLiquidity(address liquidity) external {
850         require(msg.sender == governance, "revokeLiquidity: !gov");
851         liquidityAccepted[liquidity] = false;
852     }
853 
854     /**
855      * @notice Displays all accepted liquidity pairs
856      */
857     function pairs() external view returns (address[] memory) {
858         return liquidityPairs;
859     }
860 
861     /**
862      * @notice Allows liquidity providers to submit jobs
863      * @param liquidity the liquidity being added
864      * @param job the job to assign credit to
865      * @param amount the amount of liquidity tokens to use
866      */
867     function addLiquidityToJob(address liquidity, address job, uint amount) external nonReentrant {
868         require(liquidityAccepted[liquidity], "addLiquidityToJob: !pair");
869         IERC20(liquidity).safeTransferFrom(msg.sender, address(this), amount);
870         liquidityProvided[msg.sender][liquidity][job] = liquidityProvided[msg.sender][liquidity][job].add(amount);
871 
872         liquidityApplied[msg.sender][liquidity][job] = now.add(LIQUIDITYBOND);
873         liquidityAmount[msg.sender][liquidity][job] = liquidityAmount[msg.sender][liquidity][job].add(amount);
874 
875         if (!jobs[job] && jobProposalDelay[job] < now) {
876             IGovernance(governance).proposeJob(job);
877             jobProposalDelay[job] = now.add(UNBOND);
878         }
879         emit SubmitJob(job, liquidity, msg.sender, block.number, amount);
880     }
881 
882     /**
883      * @notice Applies the credit provided in addLiquidityToJob to the job
884      * @param provider the liquidity provider
885      * @param liquidity the pair being added as liquidity
886      * @param job the job that is receiving the credit
887      */
888     function applyCreditToJob(address provider, address liquidity, address job) external {
889         require(liquidityAccepted[liquidity], "addLiquidityToJob: !pair");
890         require(liquidityApplied[provider][liquidity][job] != 0, "credit: no bond");
891         require(liquidityApplied[provider][liquidity][job] < now, "credit: bonding");
892         uint _liquidity = Keep3rV1Library.getReserve(liquidity, address(this));
893         uint _credit = _liquidity.mul(liquidityAmount[provider][liquidity][job]).div(IERC20(liquidity).totalSupply());
894         _mint(address(this), _credit);
895         credits[job][address(this)] = credits[job][address(this)].add(_credit);
896         liquidityAmount[provider][liquidity][job] = 0;
897 
898         emit ApplyCredit(job, liquidity, provider, block.number, _credit);
899     }
900 
901     /**
902      * @notice Unbond liquidity for a job
903      * @param liquidity the pair being unbound
904      * @param job the job being unbound from
905      * @param amount the amount of liquidity being removed
906      */
907     function unbondLiquidityFromJob(address liquidity, address job, uint amount) external {
908         require(liquidityAmount[msg.sender][liquidity][job] == 0, "credit: pending credit");
909         liquidityUnbonding[msg.sender][liquidity][job] = now.add(UNBOND);
910         liquidityAmountsUnbonding[msg.sender][liquidity][job] = liquidityAmountsUnbonding[msg.sender][liquidity][job].add(amount);
911         require(liquidityAmountsUnbonding[msg.sender][liquidity][job] <= liquidityProvided[msg.sender][liquidity][job], "unbondLiquidityFromJob: insufficient funds");
912 
913         uint _liquidity = Keep3rV1Library.getReserve(liquidity, address(this));
914         uint _credit = _liquidity.mul(amount).div(IERC20(liquidity).totalSupply());
915         if (_credit > credits[job][address(this)]) {
916             _burn(address(this), credits[job][address(this)]);
917             credits[job][address(this)] = 0;
918         } else {
919             _burn(address(this), _credit);
920             credits[job][address(this)] = credits[job][address(this)].sub(_credit);
921         }
922 
923         emit UnbondJob(job, liquidity, msg.sender, block.number, amount);
924     }
925 
926     /**
927      * @notice Allows liquidity providers to remove liquidity
928      * @param liquidity the pair being unbound
929      * @param job the job being unbound from
930      */
931     function removeLiquidityFromJob(address liquidity, address job) external {
932         require(liquidityUnbonding[msg.sender][liquidity][job] != 0, "removeJob: unbond");
933         require(liquidityUnbonding[msg.sender][liquidity][job] < now, "removeJob: unbonding");
934         uint _amount = liquidityAmountsUnbonding[msg.sender][liquidity][job];
935         liquidityProvided[msg.sender][liquidity][job] = liquidityProvided[msg.sender][liquidity][job].sub(_amount);
936         liquidityAmountsUnbonding[msg.sender][liquidity][job] = 0;
937         IERC20(liquidity).safeTransfer(msg.sender, _amount);
938 
939         emit RemoveJob(job, liquidity, msg.sender, block.number, _amount);
940     }
941 
942     /**
943      * @notice Allows governance to mint new tokens to treasury
944      * @param amount the amount of tokens to mint to treasury
945 	 * fork from the original implementation limiting the max supply of tokens 
946      */
947     function mint(uint amount) external {
948         require(msg.sender == governance, "mint: !gov");
949         require(totalSupply.add(amount) <= maxCap);
950         _mint(governance, amount);
951     }
952 
953     /**
954      * @notice burn owned tokens
955      * @param amount the amount of tokens to burn
956      */
957     function burn(uint amount) external {
958         _burn(msg.sender, amount);
959     }
960 
961     function _mint(address dst, uint amount) internal {
962         // mint the amount
963         totalSupply = totalSupply.add(amount);
964         // transfer the amount to the recipient
965         balances[dst] = balances[dst].add(amount);
966         emit Transfer(address(0), dst, amount);
967     }
968 
969     function _burn(address dst, uint amount) internal {
970         require(dst != address(0), "_burn: zero address");
971         balances[dst] = balances[dst].sub(amount, "_burn: exceeds balance");
972         totalSupply = totalSupply.sub(amount);
973         emit Transfer(dst, address(0), amount);
974     }
975 
976     /**
977      * @notice Implemented by jobs to show that a keeper performed work
978      * @param keeper address of the keeper that performed the work
979      */
980     function worked(address keeper) external {
981         workReceipt(keeper, KPRH.getQuoteLimit(_gasUsed.sub(gasleft())));
982     }
983 
984     /**
985      * @notice Implemented by jobs to show that a keeper performed work
986      * @param keeper address of the keeper that performed the work
987      * @param amount the reward that should be allocated
988      */
989     function workReceipt(address keeper, uint amount) public {
990         require(jobs[msg.sender], "wRec: !job");
991         require(amount <= KPRH.getQuoteLimit(_gasUsed.sub(gasleft())), "wRec: max limit");
992         credits[msg.sender][address(this)] = credits[msg.sender][address(this)].sub(amount, "wRec: insuffient funds");
993         lastJob[keeper] = now;
994         _reward(keeper, amount);
995         workCompleted[keeper] = workCompleted[keeper].add(amount);
996         emit KeeperWorked(address(this), msg.sender, keeper, block.number, amount);
997     }
998 
999     /**
1000      * @notice Implemented by jobs to show that a keeper performed work
1001      * @param credit the asset being awarded to the keeper
1002      * @param keeper address of the keeper that performed the work
1003      * @param amount the reward that should be allocated
1004      */
1005     function receipt(address credit, address keeper, uint amount) external {
1006         require(jobs[msg.sender], "receipt: !job");
1007         credits[msg.sender][credit] = credits[msg.sender][credit].sub(amount, "wRec: insuffient funds");
1008         lastJob[keeper] = now;
1009         IERC20(credit).safeTransfer(keeper, amount);
1010         emit KeeperWorked(credit, msg.sender, keeper, block.number, amount);
1011     }
1012 
1013     /**
1014      * @notice Implemented by jobs to show that a keeper performed work
1015      * @param keeper address of the keeper that performed the work
1016      * @param amount the amount of ETH sent to the keeper
1017      */
1018     function receiptETH(address keeper, uint amount) external {
1019         require(jobs[msg.sender], "receipt: !job");
1020         credits[msg.sender][ETH] = credits[msg.sender][ETH].sub(amount, "wRec: insuffient funds");
1021         lastJob[keeper] = now;
1022         payable(keeper).transfer(amount);
1023         emit KeeperWorked(ETH, msg.sender, keeper, block.number, amount);
1024     }
1025 
1026     function _reward(address _from, uint _amount) internal {
1027         bonds[_from][address(this)] = bonds[_from][address(this)].add(_amount);
1028         totalBonded = totalBonded.add(_amount);
1029         _moveDelegates(address(0), delegates[_from], _amount);
1030         emit Transfer(msg.sender, _from, _amount);
1031     }
1032 
1033     function _bond(address bonding, address _from, uint _amount) internal {
1034         bonds[_from][bonding] = bonds[_from][bonding].add(_amount);
1035         if (bonding == address(this)) {
1036             totalBonded = totalBonded.add(_amount);
1037             _moveDelegates(address(0), delegates[_from], _amount);
1038         }
1039     }
1040 
1041     function _unbond(address bonding, address _from, uint _amount) internal {
1042         bonds[_from][bonding] = bonds[_from][bonding].sub(_amount);
1043         if (bonding == address(this)) {
1044             totalBonded = totalBonded.sub(_amount);
1045             _moveDelegates(delegates[_from], address(0), _amount);
1046         }
1047 
1048     }
1049 
1050     /**
1051      * @notice Allows governance to add new job systems
1052      * @param job address of the contract for which work should be performed
1053      */
1054     function addJob(address job) external {
1055         require(msg.sender == governance, "addJob: !gov");
1056         require(!jobs[job], "addJob: job known");
1057         jobs[job] = true;
1058         jobList.push(job);
1059         emit JobAdded(job, block.number, msg.sender);
1060     }
1061 
1062     /**
1063      * @notice Full listing of all jobs ever added
1064      * @return array blob
1065      */
1066     function getJobs() external view returns (address[] memory) {
1067         return jobList;
1068     }
1069 
1070     /**
1071      * @notice Allows governance to remove a job from the systems
1072      * @param job address of the contract for which work should be performed
1073      */
1074     function removeJob(address job) external {
1075         require(msg.sender == governance, "removeJob: !gov");
1076         jobs[job] = false;
1077         emit JobRemoved(job, block.number, msg.sender);
1078     }
1079 
1080     /**
1081      * @notice Allows governance to change the Keep3rHelper for max spend
1082      * @param _kprh new helper address to set
1083      */
1084     function setKeep3rHelper(IKeep3rV1Helper _kprh) external {
1085         require(msg.sender == governance, "setKeep3rHelper: !gov");
1086         KPRH = _kprh;
1087     }
1088 
1089     /**
1090      * @notice Allows governance to change governance (for future upgradability)
1091      * @param _governance new governance address to set
1092      */
1093     function setGovernance(address _governance) external {
1094         require(msg.sender == governance, "setGovernance: !gov");
1095         pendingGovernance = _governance;
1096     }
1097 
1098     /**
1099      * @notice Allows pendingGovernance to accept their role as governance (protection pattern)
1100      */
1101     function acceptGovernance() external {
1102         require(msg.sender == pendingGovernance, "acceptGovernance: !pendingGov");
1103         governance = pendingGovernance;
1104     }
1105 
1106     /**
1107      * @notice confirms if the current keeper is registered, can be used for general (non critical) functions
1108      * @param keeper the keeper being investigated
1109      * @return true/false if the address is a keeper
1110      */
1111     function isKeeper(address keeper) external returns (bool) {
1112         _gasUsed = gasleft();
1113         return keepers[keeper];
1114     }
1115 
1116     /**
1117      * @notice confirms if the current keeper is registered and has a minimum bond, should be used for protected functions
1118      * @param keeper the keeper being investigated
1119      * @param minBond the minimum requirement for the asset provided in bond
1120      * @param earned the total funds earned in the keepers lifetime
1121      * @param age the age of the keeper in the system
1122      * @return true/false if the address is a keeper and has more than the bond
1123      */
1124     function isMinKeeper(address keeper, uint minBond, uint earned, uint age) external returns (bool) {
1125         _gasUsed = gasleft();
1126         return keepers[keeper]
1127                 && bonds[keeper][address(this)].add(votes[keeper]) >= minBond
1128                 && workCompleted[keeper] >= earned
1129                 && now.sub(firstSeen[keeper]) >= age;
1130     }
1131 
1132     /**
1133      * @notice confirms if the current keeper is registered and has a minimum bond, should be used for protected functions
1134      * @param keeper the keeper being investigated
1135      * @param bond the bound asset being evaluated
1136      * @param minBond the minimum requirement for the asset provided in bond
1137      * @param earned the total funds earned in the keepers lifetime
1138      * @param age the age of the keeper in the system
1139      * @return true/false if the address is a keeper and has more than the bond
1140      */
1141     function isBondedKeeper(address keeper, address bond, uint minBond, uint earned, uint age) external returns (bool) {
1142         _gasUsed = gasleft();
1143         return keepers[keeper]
1144                 && bonds[keeper][bond] >= minBond
1145                 && workCompleted[keeper] >= earned
1146                 && now.sub(firstSeen[keeper]) >= age;
1147     }
1148 
1149     /**
1150      * @notice begin the bonding process for a new keeper
1151      * @param bonding the asset being bound
1152      * @param amount the amount of bonding asset being bound
1153      */
1154     function bond(address bonding, uint amount) external nonReentrant {
1155         require(!blacklist[msg.sender], "bond: blacklisted");
1156         bondings[msg.sender][bonding] = now.add(BOND);
1157         if (bonding == address(this)) {
1158             _transferTokens(msg.sender, address(this), amount);
1159         } else {
1160             uint _before = IERC20(bonding).balanceOf(address(this));
1161             IERC20(bonding).safeTransferFrom(msg.sender, address(this), amount);
1162             amount = IERC20(bonding).balanceOf(address(this)).sub(_before);
1163         }
1164         pendingbonds[msg.sender][bonding] = pendingbonds[msg.sender][bonding].add(amount);
1165         emit KeeperBonding(msg.sender, block.number, bondings[msg.sender][bonding], amount);
1166     }
1167 
1168     /**
1169      * @notice get full list of keepers in the system
1170      */
1171     function getKeepers() external view returns (address[] memory) {
1172         return keeperList;
1173     }
1174 
1175     /**
1176      * @notice allows a keeper to activate/register themselves after bonding
1177      * @param bonding the asset being activated as bond collateral
1178      */
1179     function activate(address bonding) external {
1180         require(!blacklist[msg.sender], "activate: blacklisted");
1181         require(bondings[msg.sender][bonding] != 0 && bondings[msg.sender][bonding] < now, "activate: bonding");
1182         _activate(msg.sender, bonding);
1183     }
1184     
1185     function _activate(address keeper, address bonding) internal {
1186         if (firstSeen[keeper] == 0) {
1187           firstSeen[keeper] = now;
1188           keeperList.push(keeper);
1189           lastJob[keeper] = now;
1190         }
1191         keepers[keeper] = true;
1192         _bond(bonding, keeper, pendingbonds[keeper][bonding]);
1193         pendingbonds[keeper][bonding] = 0;
1194         emit KeeperBonded(keeper, block.number, block.timestamp, bonds[keeper][bonding]);
1195     }
1196 
1197     /**
1198      * @notice begin the unbonding process to stop being a keeper
1199      * @param bonding the asset being unbound
1200      * @param amount allows for partial unbonding
1201      */
1202     function unbond(address bonding, uint amount) external {
1203         unbondings[msg.sender][bonding] = now.add(UNBOND);
1204         _unbond(bonding, msg.sender, amount);
1205         partialUnbonding[msg.sender][bonding] = partialUnbonding[msg.sender][bonding].add(amount);
1206         emit KeeperUnbonding(msg.sender, block.number, unbondings[msg.sender][bonding], amount);
1207     }
1208 
1209     /**
1210      * @notice withdraw funds after unbonding has finished
1211      * @param bonding the asset to withdraw from the bonding pool
1212      */
1213     function withdraw(address bonding) external nonReentrant {
1214         require(unbondings[msg.sender][bonding] != 0 && unbondings[msg.sender][bonding] < now, "withdraw: unbonding");
1215         require(!disputes[msg.sender], "withdraw: disputes");
1216 
1217         if (bonding == address(this)) {
1218             _transferTokens(address(this), msg.sender, partialUnbonding[msg.sender][bonding]);
1219         } else {
1220             IERC20(bonding).safeTransfer(msg.sender, partialUnbonding[msg.sender][bonding]);
1221         }
1222         emit KeeperUnbound(msg.sender, block.number, block.timestamp, partialUnbonding[msg.sender][bonding]);
1223         partialUnbonding[msg.sender][bonding] = 0;
1224     }
1225 
1226     /**
1227      * @notice allows governance to create a dispute for a given keeper
1228      * @param keeper the address in dispute
1229      */
1230     function dispute(address keeper) external {
1231         require(msg.sender == governance, "dispute: !gov");
1232         disputes[keeper] = true;
1233         emit KeeperDispute(keeper, block.number);
1234     }
1235 
1236     /**
1237      * @notice allows governance to slash a keeper based on a dispute
1238      * @param bonded the asset being slashed
1239      * @param keeper the address being slashed
1240      * @param amount the amount being slashed
1241      */
1242     function slash(address bonded, address keeper, uint amount) public nonReentrant {
1243         require(msg.sender == governance, "slash: !gov");
1244         if (bonded == address(this)) {
1245             _transferTokens(address(this), governance, amount);
1246         } else {
1247             IERC20(bonded).safeTransfer(governance, amount);
1248         }
1249         _unbond(bonded, keeper, amount);
1250         disputes[keeper] = false;
1251         emit KeeperSlashed(keeper, msg.sender, block.number, amount);
1252     }
1253 
1254     /**
1255      * @notice blacklists a keeper from participating in the network
1256      * @param keeper the address being slashed
1257      */
1258     function revoke(address keeper) external {
1259         require(msg.sender == governance, "slash: !gov");
1260         keepers[keeper] = false;
1261         blacklist[keeper] = true;
1262         slash(address(this), keeper, bonds[keeper][address(this)]);
1263     }
1264 
1265     /**
1266      * @notice allows governance to resolve a dispute on a keeper
1267      * @param keeper the address cleared
1268      */
1269     function resolve(address keeper) external {
1270         require(msg.sender == governance, "resolve: !gov");
1271         disputes[keeper] = false;
1272         emit KeeperResolved(keeper, block.number);
1273     }
1274 
1275     /**
1276      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
1277      * @param account The address of the account holding the funds
1278      * @param spender The address of the account spending the funds
1279      * @return The number of tokens approved
1280      */
1281     function allowance(address account, address spender) external view returns (uint) {
1282         return allowances[account][spender];
1283     }
1284 
1285     /**
1286      * @notice Approve `spender` to transfer up to `amount` from `src`
1287      * @dev This will overwrite the approval amount for `spender`
1288      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1289      * @param spender The address of the account which may transfer tokens
1290      * @param amount The number of tokens that are approved (2^256-1 means infinite)
1291      * @return Whether or not the approval succeeded
1292      */
1293     function approve(address spender, uint amount) public returns (bool) {
1294         allowances[msg.sender][spender] = amount;
1295 
1296         emit Approval(msg.sender, spender, amount);
1297         return true;
1298     }
1299 
1300     /**
1301      * @notice Triggers an approval from owner to spends
1302      * @param owner The address to approve from
1303      * @param spender The address to be approved
1304      * @param amount The number of tokens that are approved (2^256-1 means infinite)
1305      * @param deadline The time at which to expire the signature
1306      * @param v The recovery byte of the signature
1307      * @param r Half of the ECDSA signature pair
1308      * @param s Half of the ECDSA signature pair
1309      */
1310     function permit(address owner, address spender, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
1311         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, nonces[owner]++, deadline));
1312         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAINSEPARATOR, structHash));
1313         address signatory = ecrecover(digest, v, r, s);
1314         require(signatory != address(0), "permit: signature");
1315         require(signatory == owner, "permit: unauthorized");
1316         require(now <= deadline, "permit: expired");
1317 
1318         allowances[owner][spender] = amount;
1319 
1320         emit Approval(owner, spender, amount);
1321     }
1322 
1323     /**
1324      * @notice Get the number of tokens held by the `account`
1325      * @param account The address of the account to get the balance of
1326      * @return The number of tokens held
1327      */
1328     function balanceOf(address account) external view returns (uint) {
1329         return balances[account];
1330     }
1331 
1332     /**
1333      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1334      * @param dst The address of the destination account
1335      * @param amount The number of tokens to transfer
1336      * @return Whether or not the transfer succeeded
1337      */
1338     function transfer(address dst, uint amount) public returns (bool) {
1339         _transferTokens(msg.sender, dst, amount);
1340         return true;
1341     }
1342 
1343     /**
1344      * @notice Transfer `amount` tokens from `src` to `dst`
1345      * @param src The address of the source account
1346      * @param dst The address of the destination account
1347      * @param amount The number of tokens to transfer
1348      * @return Whether or not the transfer succeeded
1349      */
1350     function transferFrom(address src, address dst, uint amount) external returns (bool) {
1351         address spender = msg.sender;
1352         uint spenderAllowance = allowances[src][spender];
1353 
1354         if (spender != src && spenderAllowance != uint(-1)) {
1355             uint newAllowance = spenderAllowance.sub(amount, "transferFrom: exceeds spender allowance");
1356             allowances[src][spender] = newAllowance;
1357 
1358             emit Approval(src, spender, newAllowance);
1359         }
1360 
1361         _transferTokens(src, dst, amount);
1362         return true;
1363     }
1364 
1365     function _transferTokens(address src, address dst, uint amount) internal {
1366         require(src != address(0), "_transferTokens: zero address");
1367         require(dst != address(0), "_transferTokens: zero address");
1368 
1369         balances[src] = balances[src].sub(amount, "_transferTokens: exceeds balance");
1370         balances[dst] = balances[dst].add(amount, "_transferTokens: overflows");
1371         emit Transfer(src, dst, amount);
1372     }
1373 
1374     function _getChainId() internal pure returns (uint) {
1375         uint chainId;
1376         assembly { chainId := chainid() }
1377         return chainId;
1378     }
1379 }