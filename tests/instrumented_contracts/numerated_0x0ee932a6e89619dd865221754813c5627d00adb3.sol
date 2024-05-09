1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: value }(data);
124         return _verifyCallResult(success, returndata, errorMessage);
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
129      * but performing a static call.
130      *
131      * _Available since v3.3._
132      */
133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
134         return functionStaticCall(target, data, "Address: low-level static call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
144         require(isContract(target), "Address: static call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.staticcall(data);
148         return _verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
153      * but performing a delegate call.
154      *
155      * _Available since v3.4._
156      */
157     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
163      * but performing a delegate call.
164      *
165      * _Available since v3.4._
166      */
167     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
168         require(isContract(target), "Address: delegate call to non-contract");
169 
170         // solhint-disable-next-line avoid-low-level-calls
171         (bool success, bytes memory returndata) = target.delegatecall(data);
172         return _verifyCallResult(success, returndata, errorMessage);
173     }
174 
175     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
176         if (success) {
177             return returndata;
178         } else {
179             // Look for revert reason and bubble it up if present
180             if (returndata.length > 0) {
181                 // The easiest way to bubble the revert reason is using memory via assembly
182 
183                 // solhint-disable-next-line no-inline-assembly
184                 assembly {
185                     let returndata_size := mload(returndata)
186                     revert(add(32, returndata), returndata_size)
187                 }
188             } else {
189                 revert(errorMessage);
190             }
191         }
192     }
193 }
194 
195 // Part: Context
196 
197 /*
198  * @dev Provides information about the current execution context, including the
199  * sender of the transaction and its data. While these are generally available
200  * via msg.sender and msg.data, they should not be accessed in such a direct
201  * manner, since when dealing with GSN meta-transactions the account sending and
202  * paying for execution may not be the actual sender (as far as an application
203  * is concerned).
204  *
205  * This contract is only required for intermediate, library-like contracts.
206  */
207 abstract contract Context {
208     function _msgSender() internal view virtual returns (address payable) {
209         return msg.sender;
210     }
211 
212     function _msgData() internal view virtual returns (bytes memory) {
213         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
214         return msg.data;
215     }
216 }
217 
218 // Part: IERC20
219 
220 /**
221  * @dev Interface of the ERC20 standard as defined in the EIP.
222  */
223 interface IERC20 {
224     /**
225      * @dev Returns the amount of tokens in existence.
226      */
227     function totalSupply() external view returns (uint256);
228 
229     /**
230      * @dev Returns the amount of tokens owned by `account`.
231      */
232     function balanceOf(address account) external view returns (uint256);
233 
234     /**
235      * @dev Moves `amount` tokens from the caller's account to `recipient`.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * Emits a {Transfer} event.
240      */
241     function transfer(address recipient, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Returns the remaining number of tokens that `spender` will be
245      * allowed to spend on behalf of `owner` through {transferFrom}. This is
246      * zero by default.
247      *
248      * This value changes when {approve} or {transferFrom} are called.
249      */
250     function allowance(address owner, address spender) external view returns (uint256);
251 
252     /**
253      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
257      * IMPORTANT: Beware that changing an allowance with this method brings the risk
258      * that someone may use both the old and the new allowance by unfortunate
259      * transaction ordering. One possible solution to mitigate this race
260      * condition is to first reduce the spender's allowance to 0 and set the
261      * desired value afterwards:
262      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263      *
264      * Emits an {Approval} event.
265      */
266     function approve(address spender, uint256 amount) external returns (bool);
267 
268     /**
269      * @dev Moves `amount` tokens from `sender` to `recipient` using the
270      * allowance mechanism. `amount` is then deducted from the caller's
271      * allowance.
272      *
273      * Returns a boolean value indicating whether the operation succeeded.
274      *
275      * Emits a {Transfer} event.
276      */
277     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
278 
279     /**
280      * @dev Emitted when `value` tokens are moved from one account (`from`) to
281      * another (`to`).
282      *
283      * Note that `value` may be zero.
284      */
285     event Transfer(address indexed from, address indexed to, uint256 value);
286 
287     /**
288      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
289      * a call to {approve}. `value` is the new allowance.
290      */
291     event Approval(address indexed owner, address indexed spender, uint256 value);
292 }
293 
294 // Part: ReentrancyGuard
295 
296 /**
297  * @dev Contract module that helps prevent reentrant calls to a function.
298  *
299  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
300  * available, which can be applied to functions to make sure there are no nested
301  * (reentrant) calls to them.
302  *
303  * Note that because there is a single `nonReentrant` guard, functions marked as
304  * `nonReentrant` may not call one another. This can be worked around by making
305  * those functions `private`, and then adding `external` `nonReentrant` entry
306  * points to them.
307  *
308  * TIP: If you would like to learn more about reentrancy and alternative ways
309  * to protect against it, check out our blog post
310  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
311  */
312 abstract contract ReentrancyGuard {
313     // Booleans are more expensive than uint256 or any type that takes up a full
314     // word because each write operation emits an extra SLOAD to first read the
315     // slot's contents, replace the bits taken up by the boolean, and then write
316     // back. This is the compiler's defense against contract upgrades and
317     // pointer aliasing, and it cannot be disabled.
318 
319     // The values being non-zero value makes deployment a bit more expensive,
320     // but in exchange the refund on every call to nonReentrant will be lower in
321     // amount. Since refunds are capped to a percentage of the total
322     // transaction's gas, it is best to keep them low in cases like this one, to
323     // increase the likelihood of the full refund coming into effect.
324     uint256 private constant _NOT_ENTERED = 1;
325     uint256 private constant _ENTERED = 2;
326 
327     uint256 private _status;
328 
329     constructor () internal {
330         _status = _NOT_ENTERED;
331     }
332 
333     /**
334      * @dev Prevents a contract from calling itself, directly or indirectly.
335      * Calling a `nonReentrant` function from another `nonReentrant`
336      * function is not supported. It is possible to prevent this from happening
337      * by making the `nonReentrant` function external, and make it call a
338      * `private` function that does the actual work.
339      */
340     modifier nonReentrant() {
341         // On the first call to nonReentrant, _notEntered will be true
342         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
343 
344         // Any calls to nonReentrant after this point will fail
345         _status = _ENTERED;
346 
347         _;
348 
349         // By storing the original value once again, a refund is triggered (see
350         // https://eips.ethereum.org/EIPS/eip-2200)
351         _status = _NOT_ENTERED;
352     }
353 }
354 
355 // Part: SafeMath
356 
357 /**
358  * @dev Wrappers over Solidity's arithmetic operations with added overflow
359  * checks.
360  *
361  * Arithmetic operations in Solidity wrap on overflow. This can easily result
362  * in bugs, because programmers usually assume that an overflow raises an
363  * error, which is the standard behavior in high level programming languages.
364  * `SafeMath` restores this intuition by reverting the transaction when an
365  * operation overflows.
366  *
367  * Using this library instead of the unchecked operations eliminates an entire
368  * class of bugs, so it's recommended to use it always.
369  */
370 library SafeMath {
371     /**
372      * @dev Returns the addition of two unsigned integers, with an overflow flag.
373      *
374      * _Available since v3.4._
375      */
376     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
377         uint256 c = a + b;
378         if (c < a) return (false, 0);
379         return (true, c);
380     }
381 
382     /**
383      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
384      *
385      * _Available since v3.4._
386      */
387     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
388         if (b > a) return (false, 0);
389         return (true, a - b);
390     }
391 
392     /**
393      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
394      *
395      * _Available since v3.4._
396      */
397     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
398         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
399         // benefit is lost if 'b' is also tested.
400         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
401         if (a == 0) return (true, 0);
402         uint256 c = a * b;
403         if (c / a != b) return (false, 0);
404         return (true, c);
405     }
406 
407     /**
408      * @dev Returns the division of two unsigned integers, with a division by zero flag.
409      *
410      * _Available since v3.4._
411      */
412     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
413         if (b == 0) return (false, 0);
414         return (true, a / b);
415     }
416 
417     /**
418      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
419      *
420      * _Available since v3.4._
421      */
422     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
423         if (b == 0) return (false, 0);
424         return (true, a % b);
425     }
426 
427     /**
428      * @dev Returns the addition of two unsigned integers, reverting on
429      * overflow.
430      *
431      * Counterpart to Solidity's `+` operator.
432      *
433      * Requirements:
434      *
435      * - Addition cannot overflow.
436      */
437     function add(uint256 a, uint256 b) internal pure returns (uint256) {
438         uint256 c = a + b;
439         require(c >= a, "SafeMath: addition overflow");
440         return c;
441     }
442 
443     /**
444      * @dev Returns the subtraction of two unsigned integers, reverting on
445      * overflow (when the result is negative).
446      *
447      * Counterpart to Solidity's `-` operator.
448      *
449      * Requirements:
450      *
451      * - Subtraction cannot overflow.
452      */
453     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
454         require(b <= a, "SafeMath: subtraction overflow");
455         return a - b;
456     }
457 
458     /**
459      * @dev Returns the multiplication of two unsigned integers, reverting on
460      * overflow.
461      *
462      * Counterpart to Solidity's `*` operator.
463      *
464      * Requirements:
465      *
466      * - Multiplication cannot overflow.
467      */
468     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
469         if (a == 0) return 0;
470         uint256 c = a * b;
471         require(c / a == b, "SafeMath: multiplication overflow");
472         return c;
473     }
474 
475     /**
476      * @dev Returns the integer division of two unsigned integers, reverting on
477      * division by zero. The result is rounded towards zero.
478      *
479      * Counterpart to Solidity's `/` operator. Note: this function uses a
480      * `revert` opcode (which leaves remaining gas untouched) while Solidity
481      * uses an invalid opcode to revert (consuming all remaining gas).
482      *
483      * Requirements:
484      *
485      * - The divisor cannot be zero.
486      */
487     function div(uint256 a, uint256 b) internal pure returns (uint256) {
488         require(b > 0, "SafeMath: division by zero");
489         return a / b;
490     }
491 
492     /**
493      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
494      * reverting when dividing by zero.
495      *
496      * Counterpart to Solidity's `%` operator. This function uses a `revert`
497      * opcode (which leaves remaining gas untouched) while Solidity uses an
498      * invalid opcode to revert (consuming all remaining gas).
499      *
500      * Requirements:
501      *
502      * - The divisor cannot be zero.
503      */
504     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
505         require(b > 0, "SafeMath: modulo by zero");
506         return a % b;
507     }
508 
509     /**
510      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
511      * overflow (when the result is negative).
512      *
513      * CAUTION: This function is deprecated because it requires allocating memory for the error
514      * message unnecessarily. For custom revert reasons use {trySub}.
515      *
516      * Counterpart to Solidity's `-` operator.
517      *
518      * Requirements:
519      *
520      * - Subtraction cannot overflow.
521      */
522     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
523         require(b <= a, errorMessage);
524         return a - b;
525     }
526 
527     /**
528      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
529      * division by zero. The result is rounded towards zero.
530      *
531      * CAUTION: This function is deprecated because it requires allocating memory for the error
532      * message unnecessarily. For custom revert reasons use {tryDiv}.
533      *
534      * Counterpart to Solidity's `/` operator. Note: this function uses a
535      * `revert` opcode (which leaves remaining gas untouched) while Solidity
536      * uses an invalid opcode to revert (consuming all remaining gas).
537      *
538      * Requirements:
539      *
540      * - The divisor cannot be zero.
541      */
542     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
543         require(b > 0, errorMessage);
544         return a / b;
545     }
546 
547     /**
548      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
549      * reverting with custom message when dividing by zero.
550      *
551      * CAUTION: This function is deprecated because it requires allocating memory for the error
552      * message unnecessarily. For custom revert reasons use {tryMod}.
553      *
554      * Counterpart to Solidity's `%` operator. This function uses a `revert`
555      * opcode (which leaves remaining gas untouched) while Solidity uses an
556      * invalid opcode to revert (consuming all remaining gas).
557      *
558      * Requirements:
559      *
560      * - The divisor cannot be zero.
561      */
562     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
563         require(b > 0, errorMessage);
564         return a % b;
565     }
566 }
567 
568 // Part: IO3
569 
570 interface IO3 is IERC20 {
571     function getUnlockFactor(address token) external view returns (uint256);
572     function getUnlockBlockGap(address token) external view returns (uint256);
573 
574     function totalUnlocked() external view returns (uint256);
575     function unlockedOf(address account) external view returns (uint256);
576     function lockedOf(address account) external view returns (uint256);
577 
578     function getStaked(address token) external view returns (uint256);
579     function getUnlockSpeed(address staker, address token) external view returns (uint256);
580     function claimableUnlocked(address token) external view returns (uint256);
581 
582     function setUnlockFactor(address token, uint256 _factor) external;
583     function setUnlockBlockGap(address token, uint256 _blockGap) external;
584 
585     function stake(address token, uint256 amount) external returns (bool);
586     function unstake(address token, uint256 amount) external returns (bool);
587     function claimUnlocked(address token) external returns (bool);
588 
589     function setAuthorizedMintCaller(address caller) external;
590     function removeAuthorizedMintCaller(address caller) external;
591 
592     function mintUnlockedToken(address to, uint256 amount) external;
593     function mintLockedToken(address to, uint256 amount) external;
594 }
595 
596 // Part: Ownable
597 
598 /**
599  * @dev Contract module which provides a basic access control mechanism, where
600  * there is an account (an owner) that can be granted exclusive access to
601  * specific functions.
602  *
603  * By default, the owner account will be the one that deploys the contract. This
604  * can later be changed with {transferOwnership}.
605  *
606  * This module is used through inheritance. It will make available the modifier
607  * `onlyOwner`, which can be applied to your functions to restrict their use to
608  * the owner.
609  */
610 abstract contract Ownable is Context {
611     address private _owner;
612 
613     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
614 
615     /**
616      * @dev Initializes the contract setting the deployer as the initial owner.
617      */
618     constructor () internal {
619         address msgSender = _msgSender();
620         _owner = msgSender;
621         emit OwnershipTransferred(address(0), msgSender);
622     }
623 
624     /**
625      * @dev Returns the address of the current owner.
626      */
627     function owner() public view virtual returns (address) {
628         return _owner;
629     }
630 
631     /**
632      * @dev Throws if called by any account other than the owner.
633      */
634     modifier onlyOwner() {
635         require(owner() == _msgSender(), "Ownable: caller is not the owner");
636         _;
637     }
638 
639     /**
640      * @dev Leaves the contract without owner. It will not be possible to call
641      * `onlyOwner` functions anymore. Can only be called by the current owner.
642      *
643      * NOTE: Renouncing ownership will leave the contract without an owner,
644      * thereby removing any functionality that is only available to the owner.
645      */
646     function renounceOwnership() public virtual onlyOwner {
647         emit OwnershipTransferred(_owner, address(0));
648         _owner = address(0);
649     }
650 
651     /**
652      * @dev Transfers ownership of the contract to a new account (`newOwner`).
653      * Can only be called by the current owner.
654      */
655     function transferOwnership(address newOwner) public virtual onlyOwner {
656         require(newOwner != address(0), "Ownable: new owner is the zero address");
657         emit OwnershipTransferred(_owner, newOwner);
658         _owner = newOwner;
659     }
660 }
661 
662 // Part: SafeERC20
663 
664 /**
665  * @title SafeERC20
666  * @dev Wrappers around ERC20 operations that throw on failure (when the token
667  * contract returns false). Tokens that return no value (and instead revert or
668  * throw on failure) are also supported, non-reverting calls are assumed to be
669  * successful.
670  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
671  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
672  */
673 library SafeERC20 {
674     using SafeMath for uint256;
675     using Address for address;
676 
677     function safeTransfer(IERC20 token, address to, uint256 value) internal {
678         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
679     }
680 
681     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
682         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
683     }
684 
685     /**
686      * @dev Deprecated. This function has issues similar to the ones found in
687      * {IERC20-approve}, and its usage is discouraged.
688      *
689      * Whenever possible, use {safeIncreaseAllowance} and
690      * {safeDecreaseAllowance} instead.
691      */
692     function safeApprove(IERC20 token, address spender, uint256 value) internal {
693         // safeApprove should only be called when setting an initial allowance,
694         // or when resetting it to zero. To increase and decrease it, use
695         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
696         // solhint-disable-next-line max-line-length
697         require((value == 0) || (token.allowance(address(this), spender) == 0),
698             "SafeERC20: approve from non-zero to non-zero allowance"
699         );
700         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
701     }
702 
703     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
704         uint256 newAllowance = token.allowance(address(this), spender).add(value);
705         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
706     }
707 
708     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
709         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
710         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
711     }
712 
713     /**
714      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
715      * on the return value: the return value is optional (but if data is returned, it must not be false).
716      * @param token The token targeted by the call.
717      * @param data The call data (encoded using abi.encode or one of its variants).
718      */
719     function _callOptionalReturn(IERC20 token, bytes memory data) private {
720         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
721         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
722         // the target address contains contract code and also asserts for success in the low-level call.
723 
724         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
725         if (returndata.length > 0) { // Return data is optional
726             // solhint-disable-next-line max-line-length
727             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
728         }
729     }
730 }
731 
732 // File: O3Staking.sol
733 
734 contract O3Staking is Context, Ownable, ReentrancyGuard {
735     using SafeMath for uint;
736     using SafeMath for uint256;
737     using SafeERC20 for IERC20;
738 
739     struct StakingRecord {
740         address staker;
741         uint blockIndex;
742         uint staked;
743         uint totalProfit;
744     }
745 
746     event LOG_STAKE (
747         address indexed staker,
748         uint stakeAmount
749     );
750 
751     event LOG_UNSTAKE (
752         address indexed staker,
753         uint withdrawAmount
754     );
755 
756     event LOG_CLAIM_PROFIT (
757         address indexed staker,
758         uint profit
759     );
760 
761     event LOG_CALL (
762         bytes4 indexed sig,
763         address indexed caller,
764         bytes data
765     ) anonymous;
766 
767     modifier _logs_() {
768         emit LOG_CALL(msg.sig, _msgSender(), _msgData());
769         _;
770     }
771 
772     address public StakingToken;
773     address public O3Token;
774     uint public startStakingBlockIndex;
775     uint public startUnstakeBlockIndex;
776     uint public startClaimBlockIndex;
777     uint public totalStaked;
778 
779     mapping(address => StakingRecord) private _stakingRecords;
780     mapping(uint => uint) private _unitProfitAccumu;
781 
782     uint private _unitProfit; // Latest unit profit.
783     uint private _upBlockIndex; // The block index `_unitProfit` refreshed.
784 
785     uint private _sharePerBlock;
786     bool private _stakingPaused;
787     bool private _withdarawPaused;
788     bool private _claimProfitPaused;
789 
790     uint public constant ONE = 10**18;
791 
792     constructor(
793         address _stakingToken,
794         address _o3Token,
795         uint _startStakingBlockIndex,
796         uint _startUnstakeBlockIndex,
797         uint _startClaimBlockIndex
798     ) public {
799         require(_stakingToken != address(0), "O3Staking: ZERO_STAKING_ADDRESS");
800         require(_o3Token != address(0), "O3Staking: ZERO_O3TOKEN_ADDRESS");
801         require(_startClaimBlockIndex >= _startStakingBlockIndex, "O3Staking: INVALID_START_CLAIM_BLOCK_INDEX");
802 
803         StakingToken = _stakingToken;
804         O3Token = _o3Token;
805         startStakingBlockIndex = _startStakingBlockIndex;
806         startUnstakeBlockIndex = _startUnstakeBlockIndex;
807         startClaimBlockIndex = _startClaimBlockIndex;
808     }
809 
810     function getTotalProfit(address staker) external view returns (uint) {
811         if (block.number <= startStakingBlockIndex) {
812             return 0;
813         }
814 
815         uint currentProfitAccumu = _unitProfitAccumu[block.number];
816         if (_upBlockIndex < block.number) {
817             uint unitProfitIncrease = _unitProfit.mul(block.number.sub(_upBlockIndex));
818             currentProfitAccumu = _unitProfitAccumu[_upBlockIndex].add(unitProfitIncrease);
819         }
820 
821         StakingRecord storage rec = _stakingRecords[staker];
822 
823         uint preUnitProfit = _unitProfitAccumu[rec.blockIndex];
824         uint currentProfit = (currentProfitAccumu.sub(preUnitProfit)).mul(rec.staked).div(ONE);
825 
826         return rec.totalProfit.add(currentProfit);
827     }
828 
829     function getStakingAmount(address staker) external view returns (uint) {
830         StakingRecord storage rec = _stakingRecords[staker];
831         return rec.staked;
832     }
833 
834     function getSharePerBlock() external view returns (uint) {
835         return _sharePerBlock;
836     }
837 
838     function setStakingToke(address _token) external onlyOwner _logs_ {
839         StakingToken = _token;
840     }
841 
842     function setSharePerBlock(uint sharePerBlock) external onlyOwner _logs_ {
843         _sharePerBlock = sharePerBlock;
844         _updateUnitProfitState();
845     }
846 
847     function setStartUnstakeBlockIndex(uint _startUnstakeBlockIndex) external onlyOwner _logs_ {
848         startUnstakeBlockIndex = _startUnstakeBlockIndex;
849     }
850 
851     function setStartClaimBlockIndex(uint _startClaimBlockIndex) external onlyOwner _logs_ {
852         startClaimBlockIndex = _startClaimBlockIndex;
853     }
854 
855     function stake(uint amount) external nonReentrant _logs_ {
856         require(!_stakingPaused, "O3Staking: STAKING_PAUSED");
857         require(amount > 0, "O3Staking: INVALID_STAKING_AMOUNT");
858 
859         totalStaked = amount.add(totalStaked);
860         _updateUnitProfitState();
861 
862         StakingRecord storage rec = _stakingRecords[_msgSender()];
863 
864         uint userTotalProfit = _settleCurrentUserProfit(_msgSender());
865         _updateUserStakingRecord(_msgSender(), rec.staked.add(amount), userTotalProfit);
866 
867         emit LOG_STAKE(_msgSender(), amount);
868 
869         _pullToken(StakingToken, _msgSender(), amount);
870     }
871 
872     function unstake(uint amount) external nonReentrant _logs_ {
873         require(!_withdarawPaused, "O3Staking: UNSTAKE_PAUSED");
874         require(block.number >= startUnstakeBlockIndex, "O3Staking: UNSTAKE_NOT_STARTED");
875 
876         StakingRecord storage rec = _stakingRecords[_msgSender()];
877 
878         require(amount > 0, "O3Staking: ZERO_UNSTAKE_AMOUNT");
879         require(amount <= rec.staked, "O3Staking: UNSTAKE_AMOUNT_EXCEEDED");
880 
881         totalStaked = totalStaked.sub(amount);
882         _updateUnitProfitState();
883 
884         uint userTotalProfit = _settleCurrentUserProfit(_msgSender());
885         _updateUserStakingRecord(_msgSender(), rec.staked.sub(amount), userTotalProfit);
886 
887         emit LOG_UNSTAKE(_msgSender(), amount);
888 
889         _pushToken(StakingToken, _msgSender(), amount);
890     }
891 
892     function claimProfit() external nonReentrant _logs_ {
893         require(!_claimProfitPaused, "O3Staking: CLAIM_PROFIT_PAUSED");
894         require(block.number >= startClaimBlockIndex, "O3Staking: CLAIM_NOT_STARTED");
895 
896         uint totalProfit = _getTotalProfit(_msgSender());
897         require(totalProfit > 0, "O3Staking: ZERO_PROFIT");
898 
899         StakingRecord storage rec = _stakingRecords[_msgSender()];
900         _updateUserStakingRecord(_msgSender(), rec.staked, 0);
901 
902         emit LOG_CLAIM_PROFIT(_msgSender(), totalProfit);
903 
904         _pushShareToken(_msgSender(), totalProfit);
905     }
906 
907     function _getTotalProfit(address staker) internal returns (uint) {
908         _updateUnitProfitState();
909 
910         uint totalProfit = _settleCurrentUserProfit(staker);
911         return totalProfit;
912     }
913 
914     function _updateUserStakingRecord(address staker, uint staked, uint totalProfit) internal {
915         _stakingRecords[staker].staked = staked;
916         _stakingRecords[staker].totalProfit = totalProfit;
917         _stakingRecords[staker].blockIndex = block.number;
918 
919         // Any action before `startStakingBlockIndex` is treated as acted in block `startStakingBlockIndex`.
920         if (block.number < startStakingBlockIndex) {
921             _stakingRecords[staker].blockIndex = startStakingBlockIndex;
922         }
923     }
924 
925     function _settleCurrentUserProfit(address staker) internal view returns (uint) {
926         if (block.number <= startStakingBlockIndex) {
927             return 0;
928         }
929 
930         StakingRecord storage rec = _stakingRecords[staker];
931 
932         uint preUnitProfit = _unitProfitAccumu[rec.blockIndex];
933         uint currUnitProfit = _unitProfitAccumu[block.number];
934         uint currentProfit = (currUnitProfit.sub(preUnitProfit)).mul(rec.staked).div(ONE);
935 
936         return rec.totalProfit.add(currentProfit);
937     }
938 
939     function _updateUnitProfitState() internal {
940         uint currentBlockIndex = block.number;
941         if (_upBlockIndex >= currentBlockIndex) {
942             _updateUnitProfit();
943             return;
944         }
945 
946         // Accumulate unit profit.
947         uint unitStakeProfitIncrease = _unitProfit.mul(currentBlockIndex.sub(_upBlockIndex));
948         _unitProfitAccumu[currentBlockIndex] = unitStakeProfitIncrease.add(_unitProfitAccumu[_upBlockIndex]);
949 
950         _upBlockIndex = block.number;
951 
952         if (currentBlockIndex <= startStakingBlockIndex) {
953             _unitProfitAccumu[startStakingBlockIndex] = _unitProfitAccumu[currentBlockIndex];
954             _upBlockIndex = startStakingBlockIndex;
955         }
956 
957         _updateUnitProfit();
958     }
959 
960     function _updateUnitProfit() internal {
961         if (totalStaked > 0) {
962             _unitProfit = _sharePerBlock.mul(ONE).div(totalStaked);
963         }
964     }
965 
966     function pauseStaking() external onlyOwner _logs_ {
967         _stakingPaused = true;
968     }
969 
970     function unpauseStaking() external onlyOwner _logs_ {
971         _stakingPaused = false;
972     }
973 
974     function pauseUnstake() external onlyOwner _logs_ {
975         _withdarawPaused = true;
976     }
977 
978     function unpauseUnstake() external onlyOwner _logs_ {
979         _withdarawPaused = false;
980     }
981 
982     function pauseClaimProfit() external onlyOwner _logs_ {
983         _claimProfitPaused = true;
984     }
985 
986     function unpauseClaimProfit() external onlyOwner _logs_ {
987         _claimProfitPaused = false;
988     }
989 
990     function collect(address token, address to) external nonReentrant onlyOwner _logs_ {
991         require(token != StakingToken, "O3Staking: COLLECT_NOT_ALLOWED");
992         uint balance = IERC20(token).balanceOf(address(this));
993         _pushToken(token, to, balance);
994     }
995 
996     function _pushToken(address token, address to, uint amount) internal {
997         SafeERC20.safeTransfer(IERC20(token), to, amount);
998     }
999 
1000     function _pushShareToken(address to, uint amount) internal {
1001         IO3(O3Token).mintLockedToken(to, amount);
1002     }
1003 
1004     function _pullToken(address token, address from, uint amount) internal {
1005         SafeERC20.safeTransferFrom(IERC20(token), from, address(this), amount);
1006     }
1007 }
