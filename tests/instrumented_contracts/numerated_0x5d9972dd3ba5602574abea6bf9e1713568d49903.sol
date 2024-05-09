1 // SPDX-License-Identifier: MIT
2 
3 
4 /******************************************/
5 /*       IERC20 starts here               */
6 /******************************************/
7 
8 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
9 
10 pragma solidity ^0.6.0;
11 
12 /**
13  * @dev Interface of the ERC20 standard as defined in the EIP.
14  */
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 
87 /******************************************/
88 /*       SafeMath starts here             */
89 /******************************************/
90 
91 // File: @openzeppelin/contracts/math/SafeMath.sol
92 
93 pragma solidity ^0.6.0;
94 
95 /**
96  * @dev Wrappers over Solidity's arithmetic operations with added overflow
97  * checks.
98  *
99  * Arithmetic operations in Solidity wrap on overflow. This can easily result
100  * in bugs, because programmers usually assume that an overflow raises an
101  * error, which is the standard behavior in high level programming languages.
102  * `SafeMath` restores this intuition by reverting the transaction when an
103  * operation overflows.
104  *
105  * Using this library instead of the unchecked operations eliminates an entire
106  * class of bugs, so it's recommended to use it always.
107  */
108 library SafeMath {
109     /**
110      * @dev Returns the addition of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `+` operator.
114      *
115      * Requirements:
116      *
117      * - Addition cannot overflow.
118      */
119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
120         uint256 c = a + b;
121         require(c >= a, "SafeMath: addition overflow");
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the subtraction of two unsigned integers, reverting on
128      * overflow (when the result is negative).
129      *
130      * Counterpart to Solidity's `-` operator.
131      *
132      * Requirements:
133      *
134      * - Subtraction cannot overflow.
135      */
136     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137         return sub(a, b, "SafeMath: subtraction overflow");
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      *
148      * - Subtraction cannot overflow.
149      */
150     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151         require(b <= a, errorMessage);
152         uint256 c = a - b;
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the multiplication of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `*` operator.
162      *
163      * Requirements:
164      *
165      * - Multiplication cannot overflow.
166      */
167     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
169         // benefit is lost if 'b' is also tested.
170         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
171         if (a == 0) {
172             return 0;
173         }
174 
175         uint256 c = a * b;
176         require(c / a == b, "SafeMath: multiplication overflow");
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b) internal pure returns (uint256) {
194         return div(a, b, "SafeMath: division by zero");
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
210         require(b > 0, errorMessage);
211         uint256 c = a / b;
212         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
213 
214         return c;
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
230         return mod(a, b, "SafeMath: modulo by zero");
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts with custom message when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         require(b != 0, errorMessage);
247         return a % b;
248     }
249 }
250 
251 
252 /******************************************/
253 /*       Address starts here              */
254 /******************************************/
255 
256 // File: @openzeppelin/contracts/utils/Address.sol
257 
258 pragma solidity ^0.6.2;
259 
260 /**
261  * @dev Collection of functions related to the address type
262  */
263 library Address {
264     /**
265      * @dev Returns true if `account` is a contract.
266      *
267      * [IMPORTANT]
268      * ====
269      * It is unsafe to assume that an address for which this function returns
270      * false is an externally-owned account (EOA) and not a contract.
271      *
272      * Among others, `isContract` will return false for the following
273      * types of addresses:
274      *
275      *  - an externally-owned account
276      *  - a contract in construction
277      *  - an address where a contract will be created
278      *  - an address where a contract lived, but was destroyed
279      * ====
280      */
281     function isContract(address account) internal view returns (bool) {
282         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
283         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
284         // for accounts without code, i.e. `keccak256('')`
285         bytes32 codehash;
286         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
287         // solhint-disable-next-line no-inline-assembly
288         assembly { codehash := extcodehash(account) }
289         return (codehash != accountHash && codehash != 0x0);
290     }
291 
292     /**
293      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
294      * `recipient`, forwarding all available gas and reverting on errors.
295      *
296      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
297      * of certain opcodes, possibly making contracts go over the 2300 gas limit
298      * imposed by `transfer`, making them unable to receive funds via
299      * `transfer`. {sendValue} removes this limitation.
300      *
301      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
302      *
303      * IMPORTANT: because control is transferred to `recipient`, care must be
304      * taken to not create reentrancy vulnerabilities. Consider using
305      * {ReentrancyGuard} or the
306      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
307      */
308     function sendValue(address payable recipient, uint256 amount) internal {
309         require(address(this).balance >= amount, "Address: insufficient balance");
310 
311         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
312         (bool success, ) = recipient.call{ value: amount }("");
313         require(success, "Address: unable to send value, recipient may have reverted");
314     }
315 
316     /**
317      * @dev Performs a Solidity function call using a low level `call`. A
318      * plain`call` is an unsafe replacement for a function call: use this
319      * function instead.
320      *
321      * If `target` reverts with a revert reason, it is bubbled up by this
322      * function (like regular Solidity function calls).
323      *
324      * Returns the raw returned data. To convert to the expected return value,
325      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
326      *
327      * Requirements:
328      *
329      * - `target` must be a contract.
330      * - calling `target` with `data` must not revert.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
335       return functionCall(target, data, "Address: low-level call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
340      * `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
345         return _functionCallWithValue(target, data, 0, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but also transferring `value` wei to `target`.
351      *
352      * Requirements:
353      *
354      * - the calling contract must have an ETH balance of at least `value`.
355      * - the called Solidity function must be `payable`.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
365      * with `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
370         require(address(this).balance >= value, "Address: insufficient balance for call");
371         return _functionCallWithValue(target, data, value, errorMessage);
372     }
373 
374     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
375         require(isContract(target), "Address: call to non-contract");
376 
377         // solhint-disable-next-line avoid-low-level-calls
378         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
379         if (success) {
380             return returndata;
381         } else {
382             // Look for revert reason and bubble it up if present
383             if (returndata.length > 0) {
384                 // The easiest way to bubble the revert reason is using memory via assembly
385 
386                 // solhint-disable-next-line no-inline-assembly
387                 assembly {
388                     let returndata_size := mload(returndata)
389                     revert(add(32, returndata), returndata_size)
390                 }
391             } else {
392                 revert(errorMessage);
393             }
394         }
395     }
396 }
397 
398 
399 /******************************************/
400 /*       SafeERC20 starts here            */
401 /******************************************/
402 
403 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
404 
405 pragma solidity ^0.6.0;
406 
407 /**
408  * @title SafeERC20
409  * @dev Wrappers around ERC20 operations that throw on failure (when the token
410  * contract returns false). Tokens that return no value (and instead revert or
411  * throw on failure) are also supported, non-reverting calls are assumed to be
412  * successful.
413  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
414  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
415  */
416 library SafeERC20 {
417     using SafeMath for uint256;
418     using Address for address;
419 
420     function safeTransfer(IERC20 token, address to, uint256 value) internal {
421         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
422     }
423 
424     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
425         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
426     }
427 
428     /**
429      * @dev Deprecated. This function has issues similar to the ones found in
430      * {IERC20-approve}, and its usage is discouraged.
431      *
432      * Whenever possible, use {safeIncreaseAllowance} and
433      * {safeDecreaseAllowance} instead.
434      */
435     function safeApprove(IERC20 token, address spender, uint256 value) internal {
436         // safeApprove should only be called when setting an initial allowance,
437         // or when resetting it to zero. To increase and decrease it, use
438         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
439         // solhint-disable-next-line max-line-length
440         require((value == 0) || (token.allowance(address(this), spender) == 0),
441             "SafeERC20: approve from non-zero to non-zero allowance"
442         );
443         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
444     }
445 
446     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
447         uint256 newAllowance = token.allowance(address(this), spender).add(value);
448         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
449     }
450 
451     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
452         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
453         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
454     }
455 
456     /**
457      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
458      * on the return value: the return value is optional (but if data is returned, it must not be false).
459      * @param token The token targeted by the call.
460      * @param data The call data (encoded using abi.encode or one of its variants).
461      */
462     function _callOptionalReturn(IERC20 token, bytes memory data) private {
463         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
464         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
465         // the target address contains contract code and also asserts for success in the low-level call.
466 
467         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
468         if (returndata.length > 0) { // Return data is optional
469             // solhint-disable-next-line max-line-length
470             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
471         }
472     }
473 }
474 
475 /******************************************/
476 /*       Context starts here              */
477 /******************************************/
478 
479 // File: @openzeppelin/contracts/GSN/Context.sol
480 
481 pragma solidity ^0.6.0;
482 
483 /*
484  * @dev Provides information about the current execution context, including the
485  * sender of the transaction and its data. While these are generally available
486  * via msg.sender and msg.data, they should not be accessed in such a direct
487  * manner, since when dealing with GSN meta-transactions the account sending and
488  * paying for execution may not be the actual sender (as far as an application
489  * is concerned).
490  *
491  * This contract is only required for intermediate, library-like contracts.
492  */
493 abstract contract Context {
494     function _msgSender() internal view virtual returns (address payable) {
495         return msg.sender;
496     }
497 
498     function _msgData() internal view virtual returns (bytes memory) {
499         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
500         return msg.data;
501     }
502 }
503 
504 
505 /******************************************/
506 /*       Ownable starts here              */
507 /******************************************/
508 
509 // File: @openzeppelin/contracts/access/Ownable.sol
510 
511 pragma solidity ^0.6.0;
512 
513 /**
514  * @dev Contract module which provides a basic access control mechanism, where
515  * there is an account (an owner) that can be granted exclusive access to
516  * specific functions.
517  *
518  * By default, the owner account will be the one that deploys the contract. This
519  * can later be changed with {transferOwnership}.
520  *
521  * This module is used through inheritance. It will make available the modifier
522  * `onlyOwner`, which can be applied to your functions to restrict their use to
523  * the owner.
524  */
525 contract Ownable is Context {
526     address private _owner;
527 
528     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
529 
530     /**
531      * @dev Initializes the contract setting the deployer as the initial owner.
532      */
533     constructor () internal {
534         address msgSender = _msgSender();
535         _owner = msgSender;
536         emit OwnershipTransferred(address(0), msgSender);
537     }
538 
539     /**
540      * @dev Returns the address of the current owner.
541      */
542     function owner() public view returns (address) {
543         return _owner;
544     }
545 
546     /**
547      * @dev Throws if called by any account other than the owner.
548      */
549     modifier onlyOwner() {
550         require(_owner == _msgSender(), "Ownable: caller is not the owner");
551         _;
552     }
553 
554     /**
555      * @dev Leaves the contract without owner. It will not be possible to call
556      * `onlyOwner` functions anymore. Can only be called by the current owner.
557      *
558      * NOTE: Renouncing ownership will leave the contract without an owner,
559      * thereby removing any functionality that is only available to the owner.
560      */
561     function renounceOwnership() public virtual onlyOwner {
562         emit OwnershipTransferred(_owner, address(0));
563         _owner = address(0);
564     }
565 
566     /**
567      * @dev Transfers ownership of the contract to a new account (`newOwner`).
568      * Can only be called by the current owner.
569      */
570     function transferOwnership(address newOwner) public virtual onlyOwner {
571         require(newOwner != address(0), "Ownable: new owner is the zero address");
572         emit OwnershipTransferred(_owner, newOwner);
573         _owner = newOwner;
574     }
575 }
576 
577 /******************************************/
578 /*       Faucet starts here          */
579 /******************************************/
580 
581 pragma solidity ^0.6.12;
582 
583 contract Faucet is Ownable {
584 
585     using SafeMath for uint256;
586     using SafeERC20 for IERC20;
587 
588     struct UserInfo 
589     {
590         uint256 amount;                 // How many LP tokens the user has provided.
591         uint256 rewardDebt;             // Reward debt. See explanation below.
592     }
593 
594     struct PoolInfo 
595     {
596         IERC20 lpToken;                 // Address of LP token contract.
597         uint256 allocPoint;             // How many allocation points assigned to this pool.
598         uint256 lastRewardBlock;        // Last block number that MARK distribution occured.
599         uint256 accMarkPerShare;        // Accumulated MARK per share, times 1e12. See below.
600     }
601 
602     IERC20 public MARK;                 // MARK token
603     PoolInfo[] public poolInfo;         // Info of each pool.
604     uint256 public markPerBlock;        // MARK tokens created per block.
605     uint256 public startBlock;          // The block number at which MARK distribution starts.
606     uint256 public endBlock;            // The block number at which MARK distribution ends.
607     uint256 public totalAllocPoint = 0; // Total allocation poitns. Must be the sum of all allocation points in all pools.
608 
609     mapping (uint256 => mapping (address => UserInfo)) public userInfo;     // Info of each user that stakes LP tokens.
610 
611     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
612     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
613     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
614 
615     constructor(IERC20 _MARK, uint256 _markPerBlock, uint256 _startBlock, uint256 _endBlock) public {
616         MARK = _MARK;
617         markPerBlock = _markPerBlock;
618         startBlock = _startBlock;
619         endBlock = _endBlock;
620     }
621 
622     /**
623      * @dev Adds a new lp to the pool. Can only be called by the owner. DO NOT add the same LP token more than once.
624      * @param _allocPoint How many allocation points to assign to this pool.
625      * @param _lpToken Address of LP token contract.
626      * @param _withUpdate Whether to update all LP token contracts. Should be true if MARK distribution has already begun.
627      */
628     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
629         if (_withUpdate) {
630             massUpdatePools();
631         }
632         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
633         totalAllocPoint = totalAllocPoint.add(_allocPoint);
634         poolInfo.push(PoolInfo({
635             lpToken: _lpToken,
636             allocPoint: _allocPoint,
637             lastRewardBlock: lastRewardBlock,
638             accMarkPerShare: 0
639         }));
640     }
641 
642     /**
643      * @dev Update the given pool's MARK allocation point. Can only be called by the owner.
644      * @param _pid ID of a specific LP token pool. See index of PoolInfo[].
645      * @param _allocPoint How many allocation points to assign to this pool.
646      * @param _withUpdate Whether to update all LP token contracts. Should be true if MARK distribution has already begun.
647      */
648     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
649         if (_withUpdate) {
650             massUpdatePools();
651         }
652         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
653         poolInfo[_pid].allocPoint = _allocPoint;
654     }
655 
656     /**
657      * @dev Return reward multiplier over the given _from to _to blocks based on block count.
658      * @param _from First block.
659      * @param _to Last block.
660      * @return Number of blocks.
661      */
662     function getMultiplier(uint256 _from, uint256 _to) internal view returns (uint256) {
663         if (_to < endBlock) {
664             return _to.sub(_from);
665         } else if (_from >= endBlock) {
666             return 0;
667         } else {
668             return endBlock.sub(_from);
669         }     
670     }
671 
672     /**
673      * @dev View function to see pending MARK on frontend.
674      * @param _pid ID of a specific LP token pool. See index of PoolInfo[].
675      * @param _user Address of a specific user.
676      * @return Pending MARK.
677      */
678     function pendingMark(uint256 _pid, address _user) external view returns (uint256) {
679         PoolInfo storage pool = poolInfo[_pid];
680         UserInfo storage user = userInfo[_pid][_user];
681         uint256 accMarkPerShare = pool.accMarkPerShare;
682         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
683         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
684             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
685             uint256 markReward = multiplier.mul(markPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
686             accMarkPerShare = accMarkPerShare.add(markReward.mul(1e12).div(lpSupply));
687         }
688         return user.amount.mul(accMarkPerShare).div(1e12).sub(user.rewardDebt);
689     }
690 
691     /**
692      * @dev Update reward vairables for all pools. Be careful of gas spending!
693      */
694     function massUpdatePools() public {
695         uint256 length = poolInfo.length;
696         for (uint256 pid = 0; pid < length; ++pid) {
697             updatePool(pid);
698         }
699     }
700 
701     /**
702      * @dev Update reward variables of the given pool to be up-to-date.
703      * @param _pid ID of a specific LP token pool. See index of PoolInfo[].
704      */
705     function updatePool(uint256 _pid) public {
706         PoolInfo storage pool = poolInfo[_pid];
707         if (block.number <= pool.lastRewardBlock) {
708             return;
709         }
710         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
711         if (lpSupply == 0) {
712             pool.lastRewardBlock = block.number;
713             return;
714         }
715         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
716         uint256 markReward = multiplier.mul(markPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
717         pool.accMarkPerShare = pool.accMarkPerShare.add(markReward.mul(1e12).div(lpSupply));
718         pool.lastRewardBlock = block.number;
719     }
720 
721     /**
722      * @dev Deposit LP tokens to Faucet for MARK allocation.
723      * @param _pid ID of a specific LP token pool. See index of PoolInfo[].
724      * @param _amount Amount of LP tokens to deposit.
725      */
726     function deposit(uint256 _pid, uint256 _amount) public {
727         PoolInfo storage pool = poolInfo[_pid];
728         UserInfo storage user = userInfo[_pid][msg.sender];
729         updatePool(_pid);
730         if (user.amount > 0) {
731             uint256 pending = user.amount.mul(pool.accMarkPerShare).div(1e12).sub(user.rewardDebt);
732             safeMarkTransfer(msg.sender, pending);
733         }
734         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
735         user.amount = user.amount.add(_amount);
736         user.rewardDebt = user.amount.mul(pool.accMarkPerShare).div(1e12);
737         emit Deposit(msg.sender, _pid, _amount);
738     }
739 
740     /**
741      * @dev Withdraw LP tokens from MasterChef.
742      * @param _pid ID of a specific LP token pool. See index of PoolInfo[].
743      * @param _amount Amount of LP tokens to withdraw.
744      */
745     function withdraw(uint256 _pid, uint256 _amount) public {
746         PoolInfo storage pool = poolInfo[_pid];
747         UserInfo storage user = userInfo[_pid][msg.sender];
748         require(user.amount >= _amount, "Can't withdraw more token than previously deposited.");
749         updatePool(_pid);
750         uint256 pending = user.amount.mul(pool.accMarkPerShare).div(1e12).sub(user.rewardDebt);
751         safeMarkTransfer(msg.sender, pending);
752         user.amount = user.amount.sub(_amount);
753         user.rewardDebt = user.amount.mul(pool.accMarkPerShare).div(1e12);
754         pool.lpToken.safeTransfer(address(msg.sender), _amount);
755         emit Withdraw(msg.sender, _pid, _amount);
756     }
757 
758     /**
759      * @dev Withdraw without caring about rewards. EMERGENCY ONLY.
760      * @param _pid ID of a specific LP token pool. See index of PoolInfo[].
761      */
762     function emergencyWithdraw(uint256 _pid) public {
763         PoolInfo storage pool = poolInfo[_pid];
764         UserInfo storage user = userInfo[_pid][msg.sender];
765         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
766         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
767         user.amount = 0;
768         user.rewardDebt = 0;
769     }
770 
771     /**
772      * @dev Safe mark transfer function, just in case if rounding error causes faucet to not have enough MARK.
773      * @param _to Target address.
774      * @param _amount Amount of MARK to transfer.
775      */
776     function safeMarkTransfer(address _to, uint256 _amount) internal {
777         uint256 markBalance = MARK.balanceOf(address(this));
778         if (_amount > markBalance) {
779             MARK.transfer(_to, markBalance);
780         } else {
781             MARK.transfer(_to, _amount);
782         }
783     }
784 
785     /**
786      * @dev Views total number of LP token pools.
787      * @return Size of poolInfo array.
788      */
789     function poolLength() external view returns (uint256) {
790         return poolInfo.length;
791     }
792     
793     /**
794      * @dev Views total number of MARK tokens deposited for rewards.
795      * @return MARK token balance of the faucet.
796      */
797     function balance() public view returns (uint256) {
798         return MARK.balanceOf(address(this));
799     }
800 
801     /**
802      * @dev Transfer MARK tokens.
803      * @return Success.
804      */
805     function transfer(address to, uint256 value) external onlyOwner returns (bool) {
806         return MARK.transfer(to, value);
807     }
808 
809 
810     /**
811      * @dev Update MARK per block.
812      * @return MARK per block.
813      */
814     function updateMARKPerBlock(uint256 _markPerBlock) external onlyOwner returns (uint256) {
815         require(_markPerBlock > 0, "Mark per Block must be greater than 0.");
816         massUpdatePools();
817         markPerBlock = _markPerBlock;
818         return markPerBlock;
819     }
820 
821     /**
822      * @dev Define last block on which MARK reward distribution occurs.
823      * @return Last block number.
824      */
825     function setEndBlock(uint256 _endBlock) external onlyOwner returns (uint256) {
826         require(block.number < endBlock, "Reward distribution already ended.");
827         require(_endBlock > block.number, "Block needs to be in the future.");
828         endBlock = _endBlock;
829         return endBlock;
830     }
831 
832 }