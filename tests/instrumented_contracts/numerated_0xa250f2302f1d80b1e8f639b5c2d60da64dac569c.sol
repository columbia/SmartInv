1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.6.12;
4 
5 
6 // 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 //
29 
30 // 
31 /**
32  * @dev Wrappers over Solidity's arithmetic operations with added overflow
33  * checks.
34  *
35  * Arithmetic operations in Solidity wrap on overflow. This can easily result
36  * in bugs, because programmers usually assume that an overflow raises an
37  * error, which is the standard behavior in high level programming languages.
38  * `SafeMath` restores this intuition by reverting the transaction when an
39  * operation overflows.
40  *
41  * Using this library instead of the unchecked operations eliminates an entire
42  * class of bugs, so it's recommended to use it always.
43  */
44 library SafeMath {
45     /**
46      * @dev Returns the addition of two unsigned integers, with an overflow flag.
47      *
48      * _Available since v3.4._
49      */
50     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         uint256 c = a + b;
52         if (c < a) return (false, 0);
53         return (true, c);
54     }
55 
56     /**
57      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
58      *
59      * _Available since v3.4._
60      */
61     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         if (b > a) return (false, 0);
63         return (true, a - b);
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
68      *
69      * _Available since v3.4._
70      */
71     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
72         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
73         // benefit is lost if 'b' is also tested.
74         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
75         if (a == 0) return (true, 0);
76         uint256 c = a * b;
77         if (c / a != b) return (false, 0);
78         return (true, c);
79     }
80 
81     /**
82      * @dev Returns the division of two unsigned integers, with a division by zero flag.
83      *
84      * _Available since v3.4._
85      */
86     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
87         if (b == 0) return (false, 0);
88         return (true, a / b);
89     }
90 
91     /**
92      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
93      *
94      * _Available since v3.4._
95      */
96     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
97         if (b == 0) return (false, 0);
98         return (true, a % b);
99     }
100 
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         require(b <= a, "SafeMath: subtraction overflow");
129         return a - b;
130     }
131 
132     /**
133      * @dev Returns the multiplication of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `*` operator.
137      *
138      * Requirements:
139      *
140      * - Multiplication cannot overflow.
141      */
142     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143         if (a == 0) return 0;
144         uint256 c = a * b;
145         require(c / a == b, "SafeMath: multiplication overflow");
146         return c;
147     }
148 
149     /**
150      * @dev Returns the integer division of two unsigned integers, reverting on
151      * division by zero. The result is rounded towards zero.
152      *
153      * Counterpart to Solidity's `/` operator. Note: this function uses a
154      * `revert` opcode (which leaves remaining gas untouched) while Solidity
155      * uses an invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         require(b > 0, "SafeMath: division by zero");
163         return a / b;
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
168      * reverting when dividing by zero.
169      *
170      * Counterpart to Solidity's `%` operator. This function uses a `revert`
171      * opcode (which leaves remaining gas untouched) while Solidity uses an
172      * invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179         require(b > 0, "SafeMath: modulo by zero");
180         return a % b;
181     }
182 
183     /**
184      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
185      * overflow (when the result is negative).
186      *
187      * CAUTION: This function is deprecated because it requires allocating memory for the error
188      * message unnecessarily. For custom revert reasons use {trySub}.
189      *
190      * Counterpart to Solidity's `-` operator.
191      *
192      * Requirements:
193      *
194      * - Subtraction cannot overflow.
195      */
196     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         require(b <= a, errorMessage);
198         return a - b;
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
203      * division by zero. The result is rounded towards zero.
204      *
205      * CAUTION: This function is deprecated because it requires allocating memory for the error
206      * message unnecessarily. For custom revert reasons use {tryDiv}.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         require(b > 0, errorMessage);
218         return a / b;
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * reverting with custom message when dividing by zero.
224      *
225      * CAUTION: This function is deprecated because it requires allocating memory for the error
226      * message unnecessarily. For custom revert reasons use {tryMod}.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b > 0, errorMessage);
238         return a % b;
239     }
240 }
241 
242 // 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * [IMPORTANT]
251      * ====
252      * It is unsafe to assume that an address for which this function returns
253      * false is an externally-owned account (EOA) and not a contract.
254      *
255      * Among others, `isContract` will return false for the following
256      * types of addresses:
257      *
258      *  - an externally-owned account
259      *  - a contract in construction
260      *  - an address where a contract will be created
261      *  - an address where a contract lived, but was destroyed
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // This method relies on extcodesize, which returns 0 for contracts in
266         // construction, since the code is only stored at the end of the
267         // constructor execution.
268 
269         uint256 size;
270         // solhint-disable-next-line no-inline-assembly
271         assembly { size := extcodesize(account) }
272         return size > 0;
273     }
274 
275     /**
276      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
277      * `recipient`, forwarding all available gas and reverting on errors.
278      *
279      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
280      * of certain opcodes, possibly making contracts go over the 2300 gas limit
281      * imposed by `transfer`, making them unable to receive funds via
282      * `transfer`. {sendValue} removes this limitation.
283      *
284      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
285      *
286      * IMPORTANT: because control is transferred to `recipient`, care must be
287      * taken to not create reentrancy vulnerabilities. Consider using
288      * {ReentrancyGuard} or the
289      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
290      */
291     function sendValue(address payable recipient, uint256 amount) internal {
292         require(address(this).balance >= amount, "Address: insufficient balance");
293 
294         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
295         (bool success, ) = recipient.call{ value: amount }("");
296         require(success, "Address: unable to send value, recipient may have reverted");
297     }
298 
299     /**
300      * @dev Performs a Solidity function call using a low level `call`. A
301      * plain`call` is an unsafe replacement for a function call: use this
302      * function instead.
303      *
304      * If `target` reverts with a revert reason, it is bubbled up by this
305      * function (like regular Solidity function calls).
306      *
307      * Returns the raw returned data. To convert to the expected return value,
308      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
309      *
310      * Requirements:
311      *
312      * - `target` must be a contract.
313      * - calling `target` with `data` must not revert.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
318       return functionCall(target, data, "Address: low-level call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
323      * `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
348      * with `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         require(isContract(target), "Address: call to non-contract");
355 
356         // solhint-disable-next-line avoid-low-level-calls
357         (bool success, bytes memory returndata) = target.call{ value: value }(data);
358         return _verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but performing a static call.
364      *
365      * _Available since v3.3._
366      */
367     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
368         return functionStaticCall(target, data, "Address: low-level static call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
373      * but performing a static call.
374      *
375      * _Available since v3.3._
376      */
377     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
378         require(isContract(target), "Address: static call to non-contract");
379 
380         // solhint-disable-next-line avoid-low-level-calls
381         (bool success, bytes memory returndata) = target.staticcall(data);
382         return _verifyCallResult(success, returndata, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but performing a delegate call.
388      *
389      * _Available since v3.4._
390      */
391     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
392         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
397      * but performing a delegate call.
398      *
399      * _Available since v3.4._
400      */
401     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
402         require(isContract(target), "Address: delegate call to non-contract");
403 
404         // solhint-disable-next-line avoid-low-level-calls
405         (bool success, bytes memory returndata) = target.delegatecall(data);
406         return _verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
410         if (success) {
411             return returndata;
412         } else {
413             // Look for revert reason and bubble it up if present
414             if (returndata.length > 0) {
415                 // The easiest way to bubble the revert reason is using memory via assembly
416 
417                 // solhint-disable-next-line no-inline-assembly
418                 assembly {
419                     let returndata_size := mload(returndata)
420                     revert(add(32, returndata), returndata_size)
421                 }
422             } else {
423                 revert(errorMessage);
424             }
425         }
426     }
427 }
428 
429 // 
430 /**
431  * @dev Contract module which provides a basic access control mechanism, where
432  * there is an account (an owner) that can be granted exclusive access to
433  * specific functions.
434  *
435  * By default, the owner account will be the one that deploys the contract. This
436  * can later be changed with {transferOwnership}.
437  *
438  * This module is used through inheritance. It will make available the modifier
439  * `onlyOwner`, which can be applied to your functions to restrict their use to
440  * the owner.
441  */
442 abstract contract Ownable is Context {
443     address private _owner;
444 
445     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
446 
447     /**
448      * @dev Initializes the contract setting the deployer as the initial owner.
449      */
450     constructor () internal {
451         address msgSender = _msgSender();
452         _owner = msgSender;
453         emit OwnershipTransferred(address(0), msgSender);
454     }
455 
456     /**
457      * @dev Returns the address of the current owner.
458      */
459     function owner() public view virtual returns (address) {
460         return _owner;
461     }
462 
463     /**
464      * @dev Throws if called by any account other than the owner.
465      */
466     modifier onlyOwner() {
467         require(owner() == _msgSender(), "Ownable: caller is not the owner");
468         _;
469     }
470 
471     /**
472      * @dev Leaves the contract without owner. It will not be possible to call
473      * `onlyOwner` functions anymore. Can only be called by the current owner.
474      *
475      * NOTE: Renouncing ownership will leave the contract without an owner,
476      * thereby removing any functionality that is only available to the owner.
477      */
478     function renounceOwnership() public virtual onlyOwner {
479         emit OwnershipTransferred(_owner, address(0));
480         _owner = address(0);
481     }
482 
483     /**
484      * @dev Transfers ownership of the contract to a new account (`newOwner`).
485      * Can only be called by the current owner.
486      */
487     function transferOwnership(address newOwner) public virtual onlyOwner {
488         require(newOwner != address(0), "Ownable: new owner is the zero address");
489         emit OwnershipTransferred(_owner, newOwner);
490         _owner = newOwner;
491     }
492 }
493 
494 // 
495 /**
496  * @dev Interface of the ERC20 standard as defined in the EIP.
497  */
498 interface IERC20 {
499     /**
500      * @dev Returns the amount of tokens in existence.
501      */
502     function totalSupply() external view returns (uint256);
503 
504     /**
505      * @dev Returns the amount of tokens owned by `account`.
506      */
507     function balanceOf(address account) external view returns (uint256);
508 
509     /**
510      * @dev Moves `amount` tokens from the caller's account to `recipient`.
511      *
512      * Returns a boolean value indicating whether the operation succeeded.
513      *
514      * Emits a {Transfer} event.
515      */
516     function transfer(address recipient, uint256 amount) external returns (bool);
517 
518     /**
519      * @dev Returns the remaining number of tokens that `spender` will be
520      * allowed to spend on behalf of `owner` through {transferFrom}. This is
521      * zero by default.
522      *
523      * This value changes when {approve} or {transferFrom} are called.
524      */
525     function allowance(address owner, address spender) external view returns (uint256);
526 
527     /**
528      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
529      *
530      * Returns a boolean value indicating whether the operation succeeded.
531      *
532      * IMPORTANT: Beware that changing an allowance with this method brings the risk
533      * that someone may use both the old and the new allowance by unfortunate
534      * transaction ordering. One possible solution to mitigate this race
535      * condition is to first reduce the spender's allowance to 0 and set the
536      * desired value afterwards:
537      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
538      *
539      * Emits an {Approval} event.
540      */
541     function approve(address spender, uint256 amount) external returns (bool);
542 
543     /**
544      * @dev Moves `amount` tokens from `sender` to `recipient` using the
545      * allowance mechanism. `amount` is then deducted from the caller's
546      * allowance.
547      *
548      * Returns a boolean value indicating whether the operation succeeded.
549      *
550      * Emits a {Transfer} event.
551      */
552     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
553     
554     function mint(address to, uint256 amount) external;
555     
556     function burnFrom(address account, uint256 amount) external;
557 
558     /**
559      * @dev Emitted when `value` tokens are moved from one account (`from`) to
560      * another (`to`).
561      *
562      * Note that `value` may be zero.
563      */
564     event Transfer(address indexed from, address indexed to, uint256 value);
565 
566     /**
567      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
568      * a call to {approve}. `value` is the new allowance.
569      */
570     event Approval(address indexed owner, address indexed spender, uint256 value);
571 }
572 
573 // MasterChef is the master of xVEMP. He can make xVEMP and he is a fair guy.
574 //
575 // Note that it's ownable and the owner wields tremendous power. The ownership
576 // will be transferred to a governance smart contract once xVEMP is sufficiently
577 // distributed and the community can show to govern itself.
578 //
579 // Have fun reading it. Hopefully it's bug-free. God bless.
580 contract MasterChefVemp is Ownable {
581     using SafeMath for uint256;
582 
583     // Info of each user.
584     struct UserInfo {
585         uint256 amount;     // How many LP tokens the user has provided.
586         uint256 rewardDebt; // Reward debt. See explanation below.
587         //
588         // We do some fancy math here. Basically, any point in time, the amount of xVEMPs
589         // entitled to a user but is pending to be distributed is:
590         //
591         //   pending reward = (user.amount * pool.accxVEMPPerShare) - user.rewardDebt
592         //
593         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
594         //   1. The pool's `accxVEMPPerShare` (and `lastRewardBlock`) gets updated.
595         //   2. User receives the pending reward sent to his/her address.
596         //   3. User's `amount` gets updated.
597         //   4. User's `rewardDebt` gets updated.
598     }
599 
600     // Info of each pool.
601     struct PoolInfo {
602         IERC20 lpToken;           // Address of LP token contract.
603         uint256 allocPoint;       // How many allocation points assigned to this pool. xVEMPs to distribute per block.
604         uint256 lastRewardBlock;  // Last block number that xVEMPs distribution occurs.
605         uint256 accxVEMPPerShare; // Accumulated xVEMPs per share, times 1e12. See below.
606     }
607 
608     // The xVEMP TOKEN!
609     IERC20 public xVEMP;
610     // admin address.
611     address public adminaddr;
612     // Block number when bonus SUSHI period ends.
613     uint256 public bonusEndBlock;
614     // xVEMP tokens created per block.
615     uint256 public xVEMPPerBlock;
616     // Bonus muliplier for early xVEMP makers.
617     uint256 public constant BONUS_MULTIPLIER = 1;
618 
619     // Info of each pool.
620     PoolInfo[] public poolInfo;
621     // Info of each user that stakes LP tokens.
622     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
623     // Total allocation poitns. Must be the sum of all allocation points in all pools.
624     uint256 public totalAllocPoint = 0;
625     // The block number when xVEMP mining starts.
626     uint256 public startBlock;
627     // Total VEMP Staked
628     uint256 public totalVempStaked;
629 
630     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
631     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
632     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
633 
634     constructor(
635         IERC20 _xVEMP,
636         address _adminaddr,
637         uint256 _xVEMPPerBlock,
638         uint256 _startBlock,
639         uint256 _bonusEndBlock
640     ) public {
641         xVEMP = _xVEMP;
642         adminaddr = _adminaddr;
643         xVEMPPerBlock = _xVEMPPerBlock;
644         bonusEndBlock = _bonusEndBlock;
645         startBlock = _startBlock;
646     }
647 
648     function poolLength() external view returns (uint256) {
649         return poolInfo.length;
650     }
651 
652     // Add a new lp to the pool. Can only be called by the owner.
653     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
654     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
655         if (_withUpdate) {
656             massUpdatePools();
657         }
658         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
659         totalAllocPoint = totalAllocPoint.add(_allocPoint);
660         poolInfo.push(PoolInfo({
661             lpToken: _lpToken,
662             allocPoint: _allocPoint,
663             lastRewardBlock: lastRewardBlock,
664             accxVEMPPerShare: 0
665         }));
666     }
667 
668     // Update the given pool's xVEMP allocation point. Can only be called by the owner.
669     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
670         if (_withUpdate) {
671             massUpdatePools();
672         }
673         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
674         poolInfo[_pid].allocPoint = _allocPoint;
675     }
676     
677     // Return reward multiplier over the given _from to _to block.
678     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
679         if (_to <= bonusEndBlock) {
680             return _to.sub(_from).mul(BONUS_MULTIPLIER);
681         } else if (_from >= bonusEndBlock) {
682             return _to.sub(_from);
683         } else {
684             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
685                 _to.sub(bonusEndBlock)
686             );
687         }
688     }
689 
690     // View function to see pending xVEMPs on frontend.
691     function pendingxVEMP(uint256 _pid, address _user) external view returns (uint256) {
692         PoolInfo storage pool = poolInfo[_pid];
693         UserInfo storage user = userInfo[_pid][_user];
694         uint256 accxVEMPPerShare = pool.accxVEMPPerShare;
695         uint256 PoolEndBlock =  block.number;
696         if(block.number > bonusEndBlock){
697             PoolEndBlock = bonusEndBlock;
698         }
699         uint256 lpSupply = totalVempStaked;
700         if (PoolEndBlock > pool.lastRewardBlock && lpSupply != 0) {
701             uint256 multiplier = getMultiplier(pool.lastRewardBlock, PoolEndBlock);
702             uint256 xVEMPReward = multiplier.mul(xVEMPPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
703             accxVEMPPerShare = accxVEMPPerShare.add(xVEMPReward.mul(1e12).div(lpSupply));
704         }
705         return user.amount.mul(accxVEMPPerShare).div(1e12).sub(user.rewardDebt);
706     }
707 
708     // Update reward vairables for all pools. Be careful of gas spending!
709     function massUpdatePools() public {
710         uint256 length = poolInfo.length;
711         for (uint256 pid = 0; pid < length; ++pid) {
712             updatePool(pid);
713         }
714     }
715 
716     // Update reward variables of the given pool to be up-to-date.
717     function updatePool(uint256 _pid) public {
718         PoolInfo storage pool = poolInfo[_pid];
719         if (block.number <= pool.lastRewardBlock) {
720             return;
721         }
722         uint256 lpSupply = totalVempStaked;
723         if (lpSupply == 0) {
724             pool.lastRewardBlock = block.number;
725             return;
726         }
727         uint256 PoolEndBlock =  block.number;
728         if(block.number > bonusEndBlock){
729             PoolEndBlock = bonusEndBlock;
730         }
731         uint256 multiplier = getMultiplier(pool.lastRewardBlock, PoolEndBlock);
732         uint256 xVEMPReward = multiplier.mul(xVEMPPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
733         pool.accxVEMPPerShare = pool.accxVEMPPerShare.add(xVEMPReward.mul(1e12).div(lpSupply));
734         pool.lastRewardBlock = PoolEndBlock;
735     }
736 
737     // Deposit LP tokens to MasterChef for xVEMP allocation.
738     function deposit(uint256 _pid, uint256 _amount) public {
739         PoolInfo storage pool = poolInfo[_pid];
740         UserInfo storage user = userInfo[_pid][msg.sender];
741         updatePool(_pid);
742         if (user.amount > 0) {
743             uint256 pending = user.amount.mul(pool.accxVEMPPerShare).div(1e12).sub(user.rewardDebt);
744             safeVEMPTransfer(_pid, address(msg.sender), pending);
745         }
746         pool.lpToken.transferFrom(address(msg.sender), address(this), _amount);
747         xVEMP.mint(address(msg.sender), _amount);
748         user.amount = user.amount.add(_amount);
749         user.rewardDebt = user.amount.mul(pool.accxVEMPPerShare).div(1e12);
750         totalVempStaked = totalVempStaked.add(_amount);
751         emit Deposit(msg.sender, _pid, _amount);
752     }
753     
754     // Withdraw LP tokens from MasterChef.
755     function withdraw(uint256 _pid, uint256 _amount) public {
756         PoolInfo storage pool = poolInfo[_pid];
757         UserInfo storage user = userInfo[_pid][msg.sender];
758         require(user.amount >= _amount, "withdraw: not good");
759         updatePool(_pid);
760         uint256 pending = user.amount.mul(pool.accxVEMPPerShare).div(1e12).sub(user.rewardDebt);
761         safeVEMPTransfer(_pid, address(msg.sender), pending);
762         user.amount = user.amount.sub(_amount);
763         user.rewardDebt = user.amount.mul(pool.accxVEMPPerShare).div(1e12);
764         totalVempStaked = totalVempStaked.sub(_amount);
765         xVEMP.burnFrom(address(msg.sender), _amount);
766         pool.lpToken.transfer(address(msg.sender), _amount);
767         emit Withdraw(msg.sender, _pid, _amount);
768     }
769 
770     // Withdraw without caring about rewards. EMERGENCY ONLY.
771     function emergencyWithdraw(uint256 _pid) public {
772         PoolInfo storage pool = poolInfo[_pid];
773         UserInfo storage user = userInfo[_pid][msg.sender];
774         xVEMP.burnFrom(address(msg.sender), user.amount);
775         pool.lpToken.transfer(address(msg.sender), user.amount);
776         totalVempStaked = totalVempStaked.sub(user.amount);
777         user.amount = 0;
778         user.rewardDebt = 0;
779         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
780     }
781     
782     // Safe MANA transfer function to admin.
783     function emergencyWithdrawRewardTokens(uint256 _pid, address _to, uint256 _amount) public {
784         require(msg.sender == adminaddr, "sender must be admin address");
785         PoolInfo storage pool = poolInfo[_pid];
786         uint256 vempBal = pool.lpToken.balanceOf(address(this));
787         require(vempBal.sub(totalVempStaked) > _amount, "Insufficiently reward amount");
788         safeVEMPTransfer(_pid, _to, _amount);
789     }
790     
791     // Safe VEMP transfer function, just in case if rounding error causes pool to not have enough xVEMPs.
792     function safeVEMPTransfer(uint256 _pid, address _to, uint256 _amount) internal {
793         PoolInfo storage pool = poolInfo[_pid];
794         uint256 VEMPBal = pool.lpToken.balanceOf(address(this)).sub(totalVempStaked);
795         if (_amount > VEMPBal) {
796             pool.lpToken.transfer(_to, VEMPBal);
797         } else {
798             pool.lpToken.transfer(_to, _amount);
799         }
800     }
801     
802     // Update Reward per block
803     function updateRewardPerBlock(uint256 _newRewardPerBlock) public onlyOwner {
804         massUpdatePools();
805         xVEMPPerBlock = _newRewardPerBlock;
806     }
807 
808     // Update admin address by the previous admin.
809     function admin(address _adminaddr) public {
810         require(msg.sender == adminaddr, "admin: wut?");
811         adminaddr = _adminaddr;
812     }
813 }