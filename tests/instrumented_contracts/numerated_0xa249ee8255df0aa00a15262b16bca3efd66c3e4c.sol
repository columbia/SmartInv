1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 /**
84  * @dev Wrappers over Solidity's arithmetic operations with added overflow
85  * checks.
86  *
87  * Arithmetic operations in Solidity wrap on overflow. This can easily result
88  * in bugs, because programmers usually assume that an overflow raises an
89  * error, which is the standard behavior in high level programming languages.
90  * `SafeMath` restores this intuition by reverting the transaction when an
91  * operation overflows.
92  *
93  * Using this library instead of the unchecked operations eliminates an entire
94  * class of bugs, so it's recommended to use it always.
95  */
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `+` operator.
102      *
103      * Requirements:
104      *
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      *
122      * - Subtraction cannot overflow.
123      */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
137      */
138     function sub(
139         uint256 a,
140         uint256 b,
141         string memory errorMessage
142     ) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(
202         uint256 a,
203         uint256 b,
204         string memory errorMessage
205     ) internal pure returns (uint256) {
206         require(b > 0, errorMessage);
207         uint256 c = a / b;
208         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
226         return mod(a, b, "SafeMath: modulo by zero");
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts with custom message when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function mod(
242         uint256 a,
243         uint256 b,
244         string memory errorMessage
245     ) internal pure returns (uint256) {
246         require(b != 0, errorMessage);
247         return a % b;
248     }
249 }
250 
251 /**
252  * @dev Collection of functions related to the address type
253  */
254 library Address {
255     /**
256      * @dev Returns true if `account` is a contract.
257      *
258      * [IMPORTANT]
259      * ====
260      * It is unsafe to assume that an address for which this function returns
261      * false is an externally-owned account (EOA) and not a contract.
262      *
263      * Among others, `isContract` will return false for the following
264      * types of addresses:
265      *
266      *  - an externally-owned account
267      *  - a contract in construction
268      *  - an address where a contract will be created
269      *  - an address where a contract lived, but was destroyed
270      * ====
271      */
272     function isContract(address account) internal view returns (bool) {
273         // This method relies in extcodesize, which returns 0 for contracts in
274         // construction, since the code is only stored at the end of the
275         // constructor execution.
276 
277         uint256 size;
278         // solhint-disable-next-line no-inline-assembly
279         assembly {
280             size := extcodesize(account)
281         }
282         return size > 0;
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
305         (bool success, ) = recipient.call{value: amount}("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 
309     /**
310      * @dev Performs a Solidity function call using a low level `call`. A
311      * plain`call` is an unsafe replacement for a function call: use this
312      * function instead.
313      *
314      * If `target` reverts with a revert reason, it is bubbled up by this
315      * function (like regular Solidity function calls).
316      *
317      * Returns the raw returned data. To convert to the expected return value,
318      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
319      *
320      * Requirements:
321      *
322      * - `target` must be a contract.
323      * - calling `target` with `data` must not revert.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
328         return functionCall(target, data, "Address: low-level call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
333      * `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal returns (bytes memory) {
342         return _functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but also transferring `value` wei to `target`.
348      *
349      * Requirements:
350      *
351      * - the calling contract must have an ETH balance of at least `value`.
352      * - the called Solidity function must be `payable`.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value
360     ) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366      * with `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(
371         address target,
372         bytes memory data,
373         uint256 value,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         require(address(this).balance >= value, "Address: insufficient balance for call");
377         return _functionCallWithValue(target, data, value, errorMessage);
378     }
379 
380     function _functionCallWithValue(
381         address target,
382         bytes memory data,
383         uint256 weiValue,
384         string memory errorMessage
385     ) private returns (bytes memory) {
386         require(isContract(target), "Address: call to non-contract");
387 
388         // solhint-disable-next-line avoid-low-level-calls
389         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
390         if (success) {
391             return returndata;
392         } else {
393             // Look for revert reason and bubble it up if present
394             if (returndata.length > 0) {
395                 // The easiest way to bubble the revert reason is using memory via assembly
396 
397                 // solhint-disable-next-line no-inline-assembly
398                 assembly {
399                     let returndata_size := mload(returndata)
400                     revert(add(32, returndata), returndata_size)
401                 }
402             } else {
403                 revert(errorMessage);
404             }
405         }
406     }
407 }
408 
409 /**
410  * @title SafeERC20
411  * @dev Wrappers around ERC20 operations that throw on failure (when the token
412  * contract returns false). Tokens that return no value (and instead revert or
413  * throw on failure) are also supported, non-reverting calls are assumed to be
414  * successful.
415  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
416  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
417  */
418 library SafeERC20 {
419     using SafeMath for uint256;
420     using Address for address;
421 
422     function safeTransfer(
423         IERC20 token,
424         address to,
425         uint256 value
426     ) internal {
427         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
428     }
429 
430     function safeTransferFrom(
431         IERC20 token,
432         address from,
433         address to,
434         uint256 value
435     ) internal {
436         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
437     }
438 
439     /**
440      * @dev Deprecated. This function has issues similar to the ones found in
441      * {IERC20-approve}, and its usage is discouraged.
442      *
443      * Whenever possible, use {safeIncreaseAllowance} and
444      * {safeDecreaseAllowance} instead.
445      */
446     function safeApprove(
447         IERC20 token,
448         address spender,
449         uint256 value
450     ) internal {
451         // safeApprove should only be called when setting an initial allowance,
452         // or when resetting it to zero. To increase and decrease it, use
453         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
454         // solhint-disable-next-line max-line-length
455         require((value == 0) || (token.allowance(address(this), spender) == 0), "SafeERC20: approve from non-zero to non-zero allowance");
456         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
457     }
458 
459     function safeIncreaseAllowance(
460         IERC20 token,
461         address spender,
462         uint256 value
463     ) internal {
464         uint256 newAllowance = token.allowance(address(this), spender).add(value);
465         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
466     }
467 
468     function safeDecreaseAllowance(
469         IERC20 token,
470         address spender,
471         uint256 value
472     ) internal {
473         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
474         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
475     }
476 
477     /**
478      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
479      * on the return value: the return value is optional (but if data is returned, it must not be false).
480      * @param token The token targeted by the call.
481      * @param data The call data (encoded using abi.encode or one of its variants).
482      */
483     function _callOptionalReturn(IERC20 token, bytes memory data) private {
484         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
485         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
486         // the target address contains contract code and also asserts for success in the low-level call.
487 
488         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
489         if (returndata.length > 0) {
490             // Return data is optional
491             // solhint-disable-next-line max-line-length
492             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
493         }
494     }
495 }
496 
497 // Note that this pool has no minter key of BSD (rewards).
498 // Instead, the governance will call BSD.distributeReward and send reward to this pool at the beginning.
499 contract StablesPool {
500     using SafeMath for uint256;
501     using SafeERC20 for IERC20;
502 
503     address public governance;
504 
505     // Info of each user.
506     struct UserInfo {
507         uint256 amount; // How many LP tokens the user has provided.
508         uint256 rewardDebt; // Reward debt. See explanation below.
509         //
510         // We do some fancy math here. Basically, any point in time, the amount of BSDs
511         // entitled to a user but is pending to be distributed is:
512         //
513         //   pending reward = (user.amount * pool.accBsdPerShare) - user.rewardDebt
514         //
515         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
516         //   1. The pool's `accBsdPerShare` (and `lastRewardBlock`) gets updated.
517         //   2. User receives the pending reward sent to his/her address.
518         //   3. User's `amount` gets updated.
519         //   4. User's `rewardDebt` gets updated.
520         uint256 accumulatedStakingPower; // will accumulate every time user harvest
521     }
522 
523     // Info of each pool.
524     struct PoolInfo {
525         IERC20 lpToken; // Address of LP token contract.
526         uint256 lastRewardBlock; // Last block number that BSDs distribution occurs.
527         uint256 accBsdPerShare; // Accumulated BSDs per share, times 1e18. See below.
528     }
529 
530     // The BSD TOKEN!
531     IERC20 public bsd = IERC20(0x003e0af2916e598Fa5eA5Cb2Da4EDfdA9aEd9Fde);
532 
533     // Info of each pool.
534     PoolInfo[] public poolInfo;
535 
536     // Info of each user that stakes LP tokens.
537     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
538 
539     uint256 public startBlock;
540 
541     uint256 public poolLength = 5; // DAI, USDC, USDT, BUSD, ESD
542 
543     uint256 public constant BLOCKS_PER_WEEK = 46500;
544 
545     uint256[] public epochTotalRewards = [200000 ether, 150000 ether, 100000 ether, 50000 ether];
546 
547     // Block number when each epoch ends.
548     uint256[4] public epochEndBlocks;
549 
550     // Reward per block for each of 4 epochs (last item is equal to 0 - for sanity).
551     uint256[5] public epochBsdPerBlock;
552 
553     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
554     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
555     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
556     event RewardPaid(address indexed user, uint256 amount);
557 
558     constructor(
559         address _bsd,
560         uint256 _startBlock,
561         address[] memory _lpTokens
562     ) public {
563         require(block.number < _startBlock, "late");
564         if (_bsd != address(0)) bsd = IERC20(_bsd);
565         startBlock = _startBlock; // supposed to be 11,465,000 (Wed Dec 16 2020 15:00:00 UTC)
566         epochEndBlocks[0] = startBlock + BLOCKS_PER_WEEK;
567         uint256 i;
568         for (i = 1; i <= 3; ++i) {
569             epochEndBlocks[i] = epochEndBlocks[i - 1] + BLOCKS_PER_WEEK;
570         }
571         for (i = 0; i <= 3; ++i) {
572             epochBsdPerBlock[i] = epochTotalRewards[i].div(BLOCKS_PER_WEEK);
573         }
574         epochBsdPerBlock[4] = 0;
575         if (_lpTokens.length == 0) {
576             _addPool(address(0x6B175474E89094C44Da98b954EedeAC495271d0F)); // DAI
577             _addPool(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)); // USDC
578             _addPool(address(0xdAC17F958D2ee523a2206206994597C13D831ec7)); // USDT
579             _addPool(address(0x4Fabb145d64652a948d72533023f6E7A623C7C53)); // BUSD
580             _addPool(address(0x36F3FD68E7325a35EB768F1AedaAe9EA0689d723)); // ESD
581         } else {
582             require(_lpTokens.length == poolLength, "Need exactly 5 lpToken address");
583             for (i = 0; i < poolLength; ++i) {
584                 _addPool(_lpTokens[i]);
585             }
586         }
587     }
588 
589     // Add a new lp to the pool. Called in the constructor only.
590     function _addPool(address _lpToken) internal {
591         require(_lpToken != address(0), "!_lpToken");
592         poolInfo.push(PoolInfo({lpToken: IERC20(_lpToken), lastRewardBlock: startBlock, accBsdPerShare: 0}));
593     }
594 
595     // Return reward multiplier over the given _from to _to block.
596     function getGeneratedReward(uint256 _from, uint256 _to) public view returns (uint256) {
597         for (uint8 epochId = 4; epochId >= 1; --epochId) {
598             if (_to >= epochEndBlocks[epochId - 1]) {
599                 if (_from >= epochEndBlocks[epochId - 1]) return _to.sub(_from).mul(epochBsdPerBlock[epochId]);
600                 uint256 _generatedReward = _to.sub(epochEndBlocks[epochId - 1]).mul(epochBsdPerBlock[epochId]);
601                 if (epochId == 1) return _generatedReward.add(epochEndBlocks[0].sub(_from).mul(epochBsdPerBlock[0]));
602                 for (epochId = epochId - 1; epochId >= 1; --epochId) {
603                     if (_from >= epochEndBlocks[epochId - 1]) return _generatedReward.add(epochEndBlocks[epochId].sub(_from).mul(epochBsdPerBlock[epochId]));
604                     _generatedReward = _generatedReward.add(epochEndBlocks[epochId].sub(epochEndBlocks[epochId - 1]).mul(epochBsdPerBlock[epochId]));
605                 }
606                 return _generatedReward.add(epochEndBlocks[0].sub(_from).mul(epochBsdPerBlock[0]));
607             }
608         }
609         return _to.sub(_from).mul(epochBsdPerBlock[0]);
610     }
611 
612     // View function to see pending BSDs on frontend.
613     function pendingBasisDollar(uint256 _pid, address _user) external view returns (uint256) {
614         PoolInfo storage pool = poolInfo[_pid];
615         UserInfo storage user = userInfo[_pid][_user];
616         uint256 accBsdPerShare = pool.accBsdPerShare;
617         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
618         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
619             uint256 _generatedReward = getGeneratedReward(pool.lastRewardBlock, block.number);
620             accBsdPerShare = accBsdPerShare.add(_generatedReward.div(poolLength).mul(1e18).div(lpSupply));
621         }
622         return user.amount.mul(accBsdPerShare).div(1e18).sub(user.rewardDebt);
623     }
624 
625     // Update reward variables of the given pool to be up-to-date.
626     function updatePool(uint256 _pid) public {
627         PoolInfo storage pool = poolInfo[_pid];
628         if (block.number <= pool.lastRewardBlock) {
629             return;
630         }
631         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
632         if (lpSupply == 0) {
633             pool.lastRewardBlock = block.number;
634             return;
635         }
636         uint256 _generatedReward = getGeneratedReward(pool.lastRewardBlock, block.number);
637         pool.accBsdPerShare = pool.accBsdPerShare.add(_generatedReward.div(poolLength).mul(1e18).div(lpSupply));
638         pool.lastRewardBlock = block.number;
639     }
640 
641     // Deposit LP tokens.
642     function deposit(uint256 _pid, uint256 _amount) public {
643         address _sender = msg.sender;
644         PoolInfo storage pool = poolInfo[_pid];
645         UserInfo storage user = userInfo[_pid][_sender];
646         updatePool(_pid);
647         if (user.amount > 0) {
648             uint256 _pending = user.amount.mul(pool.accBsdPerShare).div(1e18).sub(user.rewardDebt);
649             if (_pending > 0) {
650                 safeBsdTransfer(_sender, _pending);
651                 emit RewardPaid(_sender, _pending);
652             }
653         }
654         if (_amount > 0) {
655             pool.lpToken.safeTransferFrom(_sender, address(this), _amount);
656             user.amount = user.amount.add(_amount);
657         }
658         user.rewardDebt = user.amount.mul(pool.accBsdPerShare).div(1e18);
659         emit Deposit(_sender, _pid, _amount);
660     }
661 
662     // Withdraw LP tokens.
663     function withdraw(uint256 _pid, uint256 _amount) public {
664         address _sender = msg.sender;
665         PoolInfo storage pool = poolInfo[_pid];
666         UserInfo storage user = userInfo[_pid][_sender];
667         require(user.amount >= _amount, "withdraw: not good");
668         updatePool(_pid);
669         uint256 _pending = user.amount.mul(pool.accBsdPerShare).div(1e18).sub(user.rewardDebt);
670         if (_pending > 0) {
671             safeBsdTransfer(_sender, _pending);
672             emit RewardPaid(_sender, _pending);
673         }
674         if (_amount > 0) {
675             user.amount = user.amount.sub(_amount);
676             pool.lpToken.safeTransfer(_sender, _amount);
677         }
678         user.rewardDebt = user.amount.mul(pool.accBsdPerShare).div(1e18);
679         emit Withdraw(_sender, _pid, _amount);
680     }
681 
682     // Withdraw without caring about rewards. EMERGENCY ONLY.
683     function emergencyWithdraw(uint256 _pid) public {
684         PoolInfo storage pool = poolInfo[_pid];
685         UserInfo storage user = userInfo[_pid][msg.sender];
686         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
687         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
688         user.amount = 0;
689         user.rewardDebt = 0;
690     }
691 
692     // Safe bsd transfer function, just in case if rounding error causes pool to not have enough BSDs.
693     function safeBsdTransfer(address _to, uint256 _amount) internal {
694         uint256 _bsdBal = bsd.balanceOf(address(this));
695         if (_bsdBal > 0) {
696             if (_amount > _bsdBal) {
697                 bsd.transfer(_to, _bsdBal);
698             } else {
699                 bsd.transfer(_to, _amount);
700             }
701         }
702     }
703 
704     function setGovernance(address _governance) external {
705         require(msg.sender == governance, "!governance");
706         require(_governance != address(0), "zero");
707         governance = _governance;
708     }
709 
710     function governanceRecoverUnsupported(
711         IERC20 _token,
712         uint256 amount,
713         address to
714     ) external {
715         require(msg.sender == governance, "!governance");
716         if (block.number < epochEndBlocks[3] + BLOCKS_PER_WEEK * 12) {
717             // do not allow to drain lpToken if less than 3 months after farming
718             require(_token != bsd, "!bsd");
719             for (uint256 pid = 0; pid < poolLength; ++pid) {
720                 PoolInfo storage pool = poolInfo[pid];
721                 require(_token != pool.lpToken, "!pool.lpToken");
722             }
723         }
724         _token.safeTransfer(to, amount);
725     }
726 }