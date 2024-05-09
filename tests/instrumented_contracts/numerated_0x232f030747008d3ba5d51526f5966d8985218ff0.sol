1 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * // importANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 
82 // Dependency file: @openzeppelin/contracts/GSN/Context.sol
83 
84 
85 // pragma solidity ^0.6.0;
86 
87 /*
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with GSN meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address payable) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes memory) {
103         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
104         return msg.data;
105     }
106 }
107 
108 
109 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
110 
111 
112 // pragma solidity ^0.6.0;
113 
114 // import "@openzeppelin/contracts/GSN/Context.sol";
115 /**
116  * @dev Contract module which provides a basic access control mechanism, where
117  * there is an account (an owner) that can be granted exclusive access to
118  * specific functions.
119  *
120  * By default, the owner account will be the one that deploys the contract. This
121  * can later be changed with {transferOwnership}.
122  *
123  * This module is used through inheritance. It will make available the modifier
124  * `onlyOwner`, which can be applied to your functions to restrict their use to
125  * the owner.
126  */
127 contract Ownable is Context {
128     address private _owner;
129 
130     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
131 
132     /**
133      * @dev Initializes the contract setting the deployer as the initial owner.
134      */
135     constructor () internal {
136         address msgSender = _msgSender();
137         _owner = msgSender;
138         emit OwnershipTransferred(address(0), msgSender);
139     }
140 
141     /**
142      * @dev Returns the address of the current owner.
143      */
144     function owner() public view returns (address) {
145         return _owner;
146     }
147 
148     /**
149      * @dev Throws if called by any account other than the owner.
150      */
151     modifier onlyOwner() {
152         require(_owner == _msgSender(), "Ownable: caller is not the owner");
153         _;
154     }
155 
156     /**
157      * @dev Leaves the contract without owner. It will not be possible to call
158      * `onlyOwner` functions anymore. Can only be called by the current owner.
159      *
160      * NOTE: Renouncing ownership will leave the contract without an owner,
161      * thereby removing any functionality that is only available to the owner.
162      */
163     function renounceOwnership() public virtual onlyOwner {
164         emit OwnershipTransferred(_owner, address(0));
165         _owner = address(0);
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Can only be called by the current owner.
171      */
172     function transferOwnership(address newOwner) public virtual onlyOwner {
173         require(newOwner != address(0), "Ownable: new owner is the zero address");
174         emit OwnershipTransferred(_owner, newOwner);
175         _owner = newOwner;
176     }
177 }
178 
179 
180 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
181 
182 
183 // pragma solidity ^0.6.0;
184 
185 /**
186  * @dev Wrappers over Solidity's arithmetic operations with added overflow
187  * checks.
188  *
189  * Arithmetic operations in Solidity wrap on overflow. This can easily result
190  * in bugs, because programmers usually assume that an overflow raises an
191  * error, which is the standard behavior in high level programming languages.
192  * `SafeMath` restores this intuition by reverting the transaction when an
193  * operation overflows.
194  *
195  * Using this library instead of the unchecked operations eliminates an entire
196  * class of bugs, so it's recommended to use it always.
197  */
198 library SafeMath {
199     /**
200      * @dev Returns the addition of two unsigned integers, reverting on
201      * overflow.
202      *
203      * Counterpart to Solidity's `+` operator.
204      *
205      * Requirements:
206      *
207      * - Addition cannot overflow.
208      */
209     function add(uint256 a, uint256 b) internal pure returns (uint256) {
210         uint256 c = a + b;
211         require(c >= a, "SafeMath: addition overflow");
212 
213         return c;
214     }
215 
216     /**
217      * @dev Returns the subtraction of two unsigned integers, reverting on
218      * overflow (when the result is negative).
219      *
220      * Counterpart to Solidity's `-` operator.
221      *
222      * Requirements:
223      *
224      * - Subtraction cannot overflow.
225      */
226     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
227         return sub(a, b, "SafeMath: subtraction overflow");
228     }
229 
230     /**
231      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
232      * overflow (when the result is negative).
233      *
234      * Counterpart to Solidity's `-` operator.
235      *
236      * Requirements:
237      *
238      * - Subtraction cannot overflow.
239      */
240     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
241         require(b <= a, errorMessage);
242         uint256 c = a - b;
243 
244         return c;
245     }
246 
247     /**
248      * @dev Returns the multiplication of two unsigned integers, reverting on
249      * overflow.
250      *
251      * Counterpart to Solidity's `*` operator.
252      *
253      * Requirements:
254      *
255      * - Multiplication cannot overflow.
256      */
257     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
258         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
259         // benefit is lost if 'b' is also tested.
260         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
261         if (a == 0) {
262             return 0;
263         }
264 
265         uint256 c = a * b;
266         require(c / a == b, "SafeMath: multiplication overflow");
267 
268         return c;
269     }
270 
271     /**
272      * @dev Returns the integer division of two unsigned integers. Reverts on
273      * division by zero. The result is rounded towards zero.
274      *
275      * Counterpart to Solidity's `/` operator. Note: this function uses a
276      * `revert` opcode (which leaves remaining gas untouched) while Solidity
277      * uses an invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function div(uint256 a, uint256 b) internal pure returns (uint256) {
284         return div(a, b, "SafeMath: division by zero");
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
289      * division by zero. The result is rounded towards zero.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         require(b > 0, errorMessage);
301         uint256 c = a / b;
302         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
303 
304         return c;
305     }
306 
307     /**
308      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
309      * Reverts when dividing by zero.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
320         return mod(a, b, "SafeMath: modulo by zero");
321     }
322 
323     /**
324      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
325      * Reverts with custom message when dividing by zero.
326      *
327      * Counterpart to Solidity's `%` operator. This function uses a `revert`
328      * opcode (which leaves remaining gas untouched) while Solidity uses an
329      * invalid opcode to revert (consuming all remaining gas).
330      *
331      * Requirements:
332      *
333      * - The divisor cannot be zero.
334      */
335     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
336         require(b != 0, errorMessage);
337         return a % b;
338     }
339 }
340 
341 
342 // Dependency file: @openzeppelin/contracts/utils/Address.sol
343 
344 
345 // pragma solidity ^0.6.2;
346 
347 /**
348  * @dev Collection of functions related to the address type
349  */
350 library Address {
351     /**
352      * @dev Returns true if `account` is a contract.
353      *
354      * [// importANT]
355      * ====
356      * It is unsafe to assume that an address for which this function returns
357      * false is an externally-owned account (EOA) and not a contract.
358      *
359      * Among others, `isContract` will return false for the following
360      * types of addresses:
361      *
362      *  - an externally-owned account
363      *  - a contract in construction
364      *  - an address where a contract will be created
365      *  - an address where a contract lived, but was destroyed
366      * ====
367      */
368     function isContract(address account) internal view returns (bool) {
369         // This method relies in extcodesize, which returns 0 for contracts in
370         // construction, since the code is only stored at the end of the
371         // constructor execution.
372 
373         uint256 size;
374         // solhint-disable-next-line no-inline-assembly
375         assembly { size := extcodesize(account) }
376         return size > 0;
377     }
378 
379     /**
380      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
381      * `recipient`, forwarding all available gas and reverting on errors.
382      *
383      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
384      * of certain opcodes, possibly making contracts go over the 2300 gas limit
385      * imposed by `transfer`, making them unable to receive funds via
386      * `transfer`. {sendValue} removes this limitation.
387      *
388      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
389      *
390      * // importANT: because control is transferred to `recipient`, care must be
391      * taken to not create reentrancy vulnerabilities. Consider using
392      * {ReentrancyGuard} or the
393      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
394      */
395     function sendValue(address payable recipient, uint256 amount) internal {
396         require(address(this).balance >= amount, "Address: insufficient balance");
397 
398         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
399         (bool success, ) = recipient.call{ value: amount }("");
400         require(success, "Address: unable to send value, recipient may have reverted");
401     }
402 
403     /**
404      * @dev Performs a Solidity function call using a low level `call`. A
405      * plain`call` is an unsafe replacement for a function call: use this
406      * function instead.
407      *
408      * If `target` reverts with a revert reason, it is bubbled up by this
409      * function (like regular Solidity function calls).
410      *
411      * Returns the raw returned data. To convert to the expected return value,
412      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
413      *
414      * Requirements:
415      *
416      * - `target` must be a contract.
417      * - calling `target` with `data` must not revert.
418      *
419      * _Available since v3.1._
420      */
421     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
422       return functionCall(target, data, "Address: low-level call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
427      * `errorMessage` as a fallback revert reason when `target` reverts.
428      *
429      * _Available since v3.1._
430      */
431     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
432         return _functionCallWithValue(target, data, 0, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but also transferring `value` wei to `target`.
438      *
439      * Requirements:
440      *
441      * - the calling contract must have an ETH balance of at least `value`.
442      * - the called Solidity function must be `payable`.
443      *
444      * _Available since v3.1._
445      */
446     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
447         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
452      * with `errorMessage` as a fallback revert reason when `target` reverts.
453      *
454      * _Available since v3.1._
455      */
456     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
457         require(address(this).balance >= value, "Address: insufficient balance for call");
458         return _functionCallWithValue(target, data, value, errorMessage);
459     }
460 
461     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
462         require(isContract(target), "Address: call to non-contract");
463 
464         // solhint-disable-next-line avoid-low-level-calls
465         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
466         if (success) {
467             return returndata;
468         } else {
469             // Look for revert reason and bubble it up if present
470             if (returndata.length > 0) {
471                 // The easiest way to bubble the revert reason is using memory via assembly
472 
473                 // solhint-disable-next-line no-inline-assembly
474                 assembly {
475                     let returndata_size := mload(returndata)
476                     revert(add(32, returndata), returndata_size)
477                 }
478             } else {
479                 revert(errorMessage);
480             }
481         }
482     }
483 }
484 
485 
486 // Dependency file: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
487 
488 
489 // pragma solidity ^0.6.0;
490 
491 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
492 // import "@openzeppelin/contracts/math/SafeMath.sol";
493 // import "@openzeppelin/contracts/utils/Address.sol";
494 
495 /**
496  * @title SafeERC20
497  * @dev Wrappers around ERC20 operations that throw on failure (when the token
498  * contract returns false). Tokens that return no value (and instead revert or
499  * throw on failure) are also supported, non-reverting calls are assumed to be
500  * successful.
501  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
502  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
503  */
504 library SafeERC20 {
505     using SafeMath for uint256;
506     using Address for address;
507 
508     function safeTransfer(IERC20 token, address to, uint256 value) internal {
509         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
510     }
511 
512     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
513         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
514     }
515 
516     /**
517      * @dev Deprecated. This function has issues similar to the ones found in
518      * {IERC20-approve}, and its usage is discouraged.
519      *
520      * Whenever possible, use {safeIncreaseAllowance} and
521      * {safeDecreaseAllowance} instead.
522      */
523     function safeApprove(IERC20 token, address spender, uint256 value) internal {
524         // safeApprove should only be called when setting an initial allowance,
525         // or when resetting it to zero. To increase and decrease it, use
526         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
527         // solhint-disable-next-line max-line-length
528         require((value == 0) || (token.allowance(address(this), spender) == 0),
529             "SafeERC20: approve from non-zero to non-zero allowance"
530         );
531         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
532     }
533 
534     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
535         uint256 newAllowance = token.allowance(address(this), spender).add(value);
536         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
537     }
538 
539     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
540         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
541         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
542     }
543 
544     /**
545      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
546      * on the return value: the return value is optional (but if data is returned, it must not be false).
547      * @param token The token targeted by the call.
548      * @param data The call data (encoded using abi.encode or one of its variants).
549      */
550     function _callOptionalReturn(IERC20 token, bytes memory data) private {
551         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
552         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
553         // the target address contains contract code and also asserts for success in the low-level call.
554 
555         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
556         if (returndata.length > 0) { // Return data is optional
557             // solhint-disable-next-line max-line-length
558             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
559         }
560     }
561 }
562 
563 
564 // Dependency file: contracts/interfaces/IWoolController.sol
565 
566 
567 // pragma solidity 0.6.12;
568 
569 interface IWoolController {
570     /**
571      * @dev mint and distribute ALPA to caller
572      * NOTE: caller must be approved user
573      */
574     function mint(address _to, uint256 _amount) external;
575 
576     /**
577      * @dev burn `_amount` from `_from`
578      * NOTE: caller must be approved user
579      */
580     function burn(address _from, uint256 _amount) external;
581 }
582 
583 
584 // Root file: contracts/WoolReward/WoolReward.sol
585 
586 
587 pragma solidity =0.6.12;
588 
589 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
590 // import "@openzeppelin/contracts/access/Ownable.sol";
591 // import "@openzeppelin/contracts/math/SafeMath.sol";
592 // import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
593 
594 // import "contracts/interfaces/IWoolController.sol";
595 
596 // WoolReward
597 contract WoolReward is Ownable {
598     using SafeMath for uint256;
599     using SafeERC20 for IERC20;
600 
601     /* ========== STATE VARIABLES ========== */
602 
603     IERC20 public alpa;
604 
605     // Wool controller
606     IWoolController public woolController;
607 
608     // wool per alpa per block in inverse.
609     uint256 public woolPerAlpaPerBlockInverse = 11520;
610 
611     // Info of each user that stakes LP tokens.
612     mapping(address => UserInfo) public userInfo;
613 
614     /* ========== STRUCT ========== */
615 
616     // Info of each user.
617     struct UserInfo {
618         // How many ALPA tokens the user has provided.
619         uint256 amount;
620         // last reward block
621         uint256 lastRewardBlock;
622     }
623 
624     /* ========== CONSTRUCTOR ========== */
625 
626     /**
627      * Define the ALPA token contract
628      */
629 
630     constructor(IERC20 _alpa, IWoolController _woolController) public {
631         alpa = _alpa;
632         woolController = _woolController;
633     }
634 
635     /* ========== EXTERNAL MUTATIVE FUNCTIONS ========== */
636 
637     function pendingWool(address _user) external view returns (uint256) {
638         UserInfo storage user = userInfo[_user];
639         uint256 pending = user
640             .amount
641             .mul(_getMultiplier(user.lastRewardBlock, block.number))
642             .div(woolPerAlpaPerBlockInverse);
643         return pending;
644     }
645 
646     function deposit(uint256 _amount) public {
647         address sender = _msgSender();
648 
649         UserInfo storage user = userInfo[sender];
650 
651         if (user.amount > 0 && block.number > user.lastRewardBlock) {
652             uint256 pending = user
653                 .amount
654                 .mul(_getMultiplier(user.lastRewardBlock, block.number))
655                 .div(woolPerAlpaPerBlockInverse);
656             if (pending > 0) {
657                 woolController.mint(sender, pending);
658             }
659         }
660 
661         if (_amount > 0) {
662             user.amount = user.amount.add(_amount);
663             alpa.safeTransferFrom(address(msg.sender), address(this), _amount);
664         }
665         user.lastRewardBlock = block.number;
666     }
667 
668     function withdraw(uint256 _amount) public {
669         address sender = _msgSender();
670 
671         UserInfo storage user = userInfo[sender];
672 
673         if (block.number > user.lastRewardBlock) {
674             uint256 pending = user
675                 .amount
676                 .mul(_getMultiplier(user.lastRewardBlock, block.number))
677                 .div(woolPerAlpaPerBlockInverse);
678 
679             if (pending > 0) {
680                 woolController.mint(sender, pending);
681             }
682         }
683 
684         if (_amount > 0) {
685             user.amount = user.amount.sub(_amount);
686             _safeAlpaTransfer(sender, _amount);
687         }
688         user.lastRewardBlock = block.number;
689     }
690 
691     function emergencyWithdraw() public {
692         address sender = _msgSender();
693 
694         UserInfo storage user = userInfo[sender];
695         require(user.amount > 0, "WoolReward: insufficient balance");
696 
697         uint256 amount = user.amount;
698         delete userInfo[sender];
699         _safeAlpaTransfer(sender, amount);
700     }
701 
702     /* ========== PRIVATE FUNCTIONS ========== */
703 
704     // Return reward multiplier over the given _from to _to block.
705     function _getMultiplier(uint256 _from, uint256 _to)
706         private
707         pure
708         returns (uint256)
709     {
710         return _to.sub(_from);
711     }
712 
713     // Safe alpa transfer function, just in case if rounding error causes pool to not have enough ALPAs.
714     function _safeAlpaTransfer(address _to, uint256 _amount) private {
715         uint256 alpaBal = alpa.balanceOf(address(this));
716         if (_amount > alpaBal) {
717             alpa.transfer(_to, alpaBal);
718         } else {
719             alpa.transfer(_to, _amount);
720         }
721     }
722 
723     /* ========== OWNER ONLY ========== */
724     /**
725      * @dev Allow owner to change woolPerAlpaPerBlockInverse
726      */
727     function setWoolPerAlpaPerBlockInverse(uint256 _value) public onlyOwner {
728         woolPerAlpaPerBlockInverse = _value;
729     }
730 }