1 pragma solidity ^0.6.6;
2 
3 
4 // SPDX-License-Identifier: MIT
5 /**
6  * @dev Standard math utilities missing in the Solidity language.
7  */
8 library Math {
9     /**
10      * @dev Returns the largest of two numbers.
11      */
12     function max(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a >= b ? a : b;
14     }
15 
16     /**
17      * @dev Returns the smallest of two numbers.
18      */
19     function min(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a < b ? a : b;
21     }
22 
23     /**
24      * @dev Returns the average of two numbers. The result is rounded towards
25      * zero.
26      */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30     }
31 }
32 
33 // SPDX-License-Identifier: MIT
34 /**
35  * @dev Wrappers over Solidity's arithmetic operations with added overflow
36  * checks.
37  *
38  * Arithmetic operations in Solidity wrap on overflow. This can easily result
39  * in bugs, because programmers usually assume that an overflow raises an
40  * error, which is the standard behavior in high level programming languages.
41  * `SafeMath` restores this intuition by reverting the transaction when an
42  * operation overflows.
43  *
44  * Using this library instead of the unchecked operations eliminates an entire
45  * class of bugs, so it's recommended to use it always.
46  */
47 library SafeMath {
48     /**
49      * @dev Returns the addition of two unsigned integers, reverting on
50      * overflow.
51      *
52      * Counterpart to Solidity's `+` operator.
53      *
54      * Requirements:
55      *
56      * - Addition cannot overflow.
57      */
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a, "SafeMath: addition overflow");
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the subtraction of two unsigned integers, reverting on
67      * overflow (when the result is negative).
68      *
69      * Counterpart to Solidity's `-` operator.
70      *
71      * Requirements:
72      *
73      * - Subtraction cannot overflow.
74      */
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         return sub(a, b, "SafeMath: subtraction overflow");
77     }
78 
79     /**
80      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
81      * overflow (when the result is negative).
82      *
83      * Counterpart to Solidity's `-` operator.
84      *
85      * Requirements:
86      *
87      * - Subtraction cannot overflow.
88      */
89     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
90         require(b <= a, errorMessage);
91         uint256 c = a - b;
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the multiplication of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `*` operator.
101      *
102      * Requirements:
103      *
104      * - Multiplication cannot overflow.
105      */
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
108         // benefit is lost if 'b' is also tested.
109         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
110         if (a == 0) {
111             return 0;
112         }
113 
114         uint256 c = a * b;
115         require(c / a == b, "SafeMath: multiplication overflow");
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the integer division of two unsigned integers. Reverts on
122      * division by zero. The result is rounded towards zero.
123      *
124      * Counterpart to Solidity's `/` operator. Note: this function uses a
125      * `revert` opcode (which leaves remaining gas untouched) while Solidity
126      * uses an invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      *
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return div(a, b, "SafeMath: division by zero");
134     }
135 
136     /**
137      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
138      * division by zero. The result is rounded towards zero.
139      *
140      * Counterpart to Solidity's `/` operator. Note: this function uses a
141      * `revert` opcode (which leaves remaining gas untouched) while Solidity
142      * uses an invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      *
146      * - The divisor cannot be zero.
147      */
148     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b > 0, errorMessage);
150         uint256 c = a / b;
151         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
158      * Reverts when dividing by zero.
159      *
160      * Counterpart to Solidity's `%` operator. This function uses a `revert`
161      * opcode (which leaves remaining gas untouched) while Solidity uses an
162      * invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      *
166      * - The divisor cannot be zero.
167      */
168     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
169         return mod(a, b, "SafeMath: modulo by zero");
170     }
171 
172     /**
173      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
174      * Reverts with custom message when dividing by zero.
175      *
176      * Counterpart to Solidity's `%` operator. This function uses a `revert`
177      * opcode (which leaves remaining gas untouched) while Solidity uses an
178      * invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         require(b != 0, errorMessage);
186         return a % b;
187     }
188 }
189 
190 // SPDX-License-Identifier: MIT
191 /*
192  * @dev Provides information about the current execution context, including the
193  * sender of the transaction and its data. While these are generally available
194  * via msg.sender and msg.data, they should not be accessed in such a direct
195  * manner, since when dealing with GSN meta-transactions the account sending and
196  * paying for execution may not be the actual sender (as far as an application
197  * is concerned).
198  *
199  * This contract is only required for intermediate, library-like contracts.
200  */
201 abstract contract Context {
202     function _msgSender() internal view virtual returns (address payable) {
203         return msg.sender;
204     }
205 
206     function _msgData() internal view virtual returns (bytes memory) {
207         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
208         return msg.data;
209     }
210 }
211 
212 // SPDX-License-Identifier: MIT
213 /**
214  * @dev Contract module which provides a basic access control mechanism, where
215  * there is an account (an owner) that can be granted exclusive access to
216  * specific functions.
217  *
218  * By default, the owner account will be the one that deploys the contract. This
219  * can later be changed with {transferOwnership}.
220  *
221  * This module is used through inheritance. It will make available the modifier
222  * `onlyOwner`, which can be applied to your functions to restrict their use to
223  * the owner.
224  */
225 abstract contract Ownable is Context {
226     address private _owner;
227 
228     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
229 
230     /**
231      * @dev Initializes the contract setting the deployer as the initial owner.
232      */
233     constructor () internal {
234         address msgSender = _msgSender();
235         _owner = msgSender;
236         emit OwnershipTransferred(address(0), msgSender);
237     }
238 
239     /**
240      * @dev Returns the address of the current owner.
241      */
242     function owner() public view returns (address) {
243         return _owner;
244     }
245 
246     /**
247      * @dev Throws if called by any account other than the owner.
248      */
249     modifier onlyOwner() {
250         require(_owner == _msgSender(), "Ownable: caller is not the owner");
251         _;
252     }
253 
254     /**
255      * @dev Leaves the contract without owner. It will not be possible to call
256      * `onlyOwner` functions anymore. Can only be called by the current owner.
257      *
258      * NOTE: Renouncing ownership will leave the contract without an owner,
259      * thereby removing any functionality that is only available to the owner.
260      */
261     function renounceOwnership() public virtual onlyOwner {
262         emit OwnershipTransferred(_owner, address(0));
263         _owner = address(0);
264     }
265 
266     /**
267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
268      * Can only be called by the current owner.
269      */
270     function transferOwnership(address newOwner) public virtual onlyOwner {
271         require(newOwner != address(0), "Ownable: new owner is the zero address");
272         emit OwnershipTransferred(_owner, newOwner);
273         _owner = newOwner;
274     }
275 }
276 
277 // SPDX-License-Identifier: MIT
278 /**
279  * @dev Interface of the ERC20 standard as defined in the EIP.
280  */
281 interface IERC20 {
282     /**
283      * @dev Returns the amount of tokens in existence.
284      */
285     function totalSupply() external view returns (uint256);
286 
287     /**
288      * @dev Returns the amount of tokens owned by `account`.
289      */
290     function balanceOf(address account) external view returns (uint256);
291 
292     /**
293      * @dev Moves `amount` tokens from the caller's account to `recipient`.
294      *
295      * Returns a boolean value indicating whether the operation succeeded.
296      *
297      * Emits a {Transfer} event.
298      */
299     function transfer(address recipient, uint256 amount) external returns (bool);
300 
301     /**
302      * @dev Returns the remaining number of tokens that `spender` will be
303      * allowed to spend on behalf of `owner` through {transferFrom}. This is
304      * zero by default.
305      *
306      * This value changes when {approve} or {transferFrom} are called.
307      */
308     function allowance(address owner, address spender) external view returns (uint256);
309 
310     /**
311      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
312      *
313      * Returns a boolean value indicating whether the operation succeeded.
314      *
315      * IMPORTANT: Beware that changing an allowance with this method brings the risk
316      * that someone may use both the old and the new allowance by unfortunate
317      * transaction ordering. One possible solution to mitigate this race
318      * condition is to first reduce the spender's allowance to 0 and set the
319      * desired value afterwards:
320      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
321      *
322      * Emits an {Approval} event.
323      */
324     function approve(address spender, uint256 amount) external returns (bool);
325 
326     /**
327      * @dev Moves `amount` tokens from `sender` to `recipient` using the
328      * allowance mechanism. `amount` is then deducted from the caller's
329      * allowance.
330      *
331      * Returns a boolean value indicating whether the operation succeeded.
332      *
333      * Emits a {Transfer} event.
334      */
335     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
336 
337     /**
338      * @dev Emitted when `value` tokens are moved from one account (`from`) to
339      * another (`to`).
340      *
341      * Note that `value` may be zero.
342      */
343     event Transfer(address indexed from, address indexed to, uint256 value);
344 
345     /**
346      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
347      * a call to {approve}. `value` is the new allowance.
348      */
349     event Approval(address indexed owner, address indexed spender, uint256 value);
350 }
351 
352 // SPDX-License-Identifier: MIT
353 /**
354  * @dev Collection of functions related to the address type
355  */
356 library Address {
357     /**
358      * @dev Returns true if `account` is a contract.
359      *
360      * [IMPORTANT]
361      * ====
362      * It is unsafe to assume that an address for which this function returns
363      * false is an externally-owned account (EOA) and not a contract.
364      *
365      * Among others, `isContract` will return false for the following
366      * types of addresses:
367      *
368      *  - an externally-owned account
369      *  - a contract in construction
370      *  - an address where a contract will be created
371      *  - an address where a contract lived, but was destroyed
372      * ====
373      */
374     function isContract(address account) internal view returns (bool) {
375         // This method relies on extcodesize, which returns 0 for contracts in
376         // construction, since the code is only stored at the end of the
377         // constructor execution.
378 
379         uint256 size;
380         // solhint-disable-next-line no-inline-assembly
381         assembly { size := extcodesize(account) }
382         return size > 0;
383     }
384 
385     /**
386      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
387      * `recipient`, forwarding all available gas and reverting on errors.
388      *
389      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
390      * of certain opcodes, possibly making contracts go over the 2300 gas limit
391      * imposed by `transfer`, making them unable to receive funds via
392      * `transfer`. {sendValue} removes this limitation.
393      *
394      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
395      *
396      * IMPORTANT: because control is transferred to `recipient`, care must be
397      * taken to not create reentrancy vulnerabilities. Consider using
398      * {ReentrancyGuard} or the
399      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
400      */
401     function sendValue(address payable recipient, uint256 amount) internal {
402         require(address(this).balance >= amount, "Address: insufficient balance");
403 
404         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
405         (bool success, ) = recipient.call{ value: amount }("");
406         require(success, "Address: unable to send value, recipient may have reverted");
407     }
408 
409     /**
410      * @dev Performs a Solidity function call using a low level `call`. A
411      * plain`call` is an unsafe replacement for a function call: use this
412      * function instead.
413      *
414      * If `target` reverts with a revert reason, it is bubbled up by this
415      * function (like regular Solidity function calls).
416      *
417      * Returns the raw returned data. To convert to the expected return value,
418      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
419      *
420      * Requirements:
421      *
422      * - `target` must be a contract.
423      * - calling `target` with `data` must not revert.
424      *
425      * _Available since v3.1._
426      */
427     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
428       return functionCall(target, data, "Address: low-level call failed");
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
433      * `errorMessage` as a fallback revert reason when `target` reverts.
434      *
435      * _Available since v3.1._
436      */
437     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
438         return functionCallWithValue(target, data, 0, errorMessage);
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
443      * but also transferring `value` wei to `target`.
444      *
445      * Requirements:
446      *
447      * - the calling contract must have an ETH balance of at least `value`.
448      * - the called Solidity function must be `payable`.
449      *
450      * _Available since v3.1._
451      */
452     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
453         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
458      * with `errorMessage` as a fallback revert reason when `target` reverts.
459      *
460      * _Available since v3.1._
461      */
462     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
463         require(address(this).balance >= value, "Address: insufficient balance for call");
464         require(isContract(target), "Address: call to non-contract");
465 
466         // solhint-disable-next-line avoid-low-level-calls
467         (bool success, bytes memory returndata) = target.call{ value: value }(data);
468         return _verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
473      * but performing a static call.
474      *
475      * _Available since v3.3._
476      */
477     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
478         return functionStaticCall(target, data, "Address: low-level static call failed");
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
483      * but performing a static call.
484      *
485      * _Available since v3.3._
486      */
487     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
488         require(isContract(target), "Address: static call to non-contract");
489 
490         // solhint-disable-next-line avoid-low-level-calls
491         (bool success, bytes memory returndata) = target.staticcall(data);
492         return _verifyCallResult(success, returndata, errorMessage);
493     }
494 
495     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
496         if (success) {
497             return returndata;
498         } else {
499             // Look for revert reason and bubble it up if present
500             if (returndata.length > 0) {
501                 // The easiest way to bubble the revert reason is using memory via assembly
502 
503                 // solhint-disable-next-line no-inline-assembly
504                 assembly {
505                     let returndata_size := mload(returndata)
506                     revert(add(32, returndata), returndata_size)
507                 }
508             } else {
509                 revert(errorMessage);
510             }
511         }
512     }
513 }
514 
515 // SPDX-License-Identifier: MIT
516 /**
517  * @dev Contract module that helps prevent reentrant calls to a function.
518  *
519  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
520  * available, which can be applied to functions to make sure there are no nested
521  * (reentrant) calls to them.
522  *
523  * Note that because there is a single `nonReentrant` guard, functions marked as
524  * `nonReentrant` may not call one another. This can be worked around by making
525  * those functions `private`, and then adding `external` `nonReentrant` entry
526  * points to them.
527  *
528  * TIP: If you would like to learn more about reentrancy and alternative ways
529  * to protect against it, check out our blog post
530  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
531  */
532 abstract contract ReentrancyGuard {
533     // Booleans are more expensive than uint256 or any type that takes up a full
534     // word because each write operation emits an extra SLOAD to first read the
535     // slot's contents, replace the bits taken up by the boolean, and then write
536     // back. This is the compiler's defense against contract upgrades and
537     // pointer aliasing, and it cannot be disabled.
538 
539     // The values being non-zero value makes deployment a bit more expensive,
540     // but in exchange the refund on every call to nonReentrant will be lower in
541     // amount. Since refunds are capped to a percentage of the total
542     // transaction's gas, it is best to keep them low in cases like this one, to
543     // increase the likelihood of the full refund coming into effect.
544     uint256 private constant _NOT_ENTERED = 1;
545     uint256 private constant _ENTERED = 2;
546 
547     uint256 private _status;
548 
549     constructor () internal {
550         _status = _NOT_ENTERED;
551     }
552 
553     /**
554      * @dev Prevents a contract from calling itself, directly or indirectly.
555      * Calling a `nonReentrant` function from another `nonReentrant`
556      * function is not supported. It is possible to prevent this from happening
557      * by making the `nonReentrant` function external, and make it call a
558      * `private` function that does the actual work.
559      */
560     modifier nonReentrant() {
561         // On the first call to nonReentrant, _notEntered will be true
562         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
563 
564         // Any calls to nonReentrant after this point will fail
565         _status = _ENTERED;
566 
567         _;
568 
569         // By storing the original value once again, a refund is triggered (see
570         // https://eips.ethereum.org/EIPS/eip-2200)
571         _status = _NOT_ENTERED;
572     }
573 }
574 
575 // SPDX-License-Identifier: MIT
576 /**
577  * @title SafeERC20
578  * @dev Wrappers around ERC20 operations that throw on failure (when the token
579  * contract returns false). Tokens that return no value (and instead revert or
580  * throw on failure) are also supported, non-reverting calls are assumed to be
581  * successful.
582  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
583  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
584  */
585 library SafeERC20 {
586     using SafeMath for uint256;
587     using Address for address;
588 
589     function safeTransfer(IERC20 token, address to, uint256 value) internal {
590         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
591     }
592 
593     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
594         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
595     }
596 
597     /**
598      * @dev Deprecated. This function has issues similar to the ones found in
599      * {IERC20-approve}, and its usage is discouraged.
600      *
601      * Whenever possible, use {safeIncreaseAllowance} and
602      * {safeDecreaseAllowance} instead.
603      */
604     function safeApprove(IERC20 token, address spender, uint256 value) internal {
605         // safeApprove should only be called when setting an initial allowance,
606         // or when resetting it to zero. To increase and decrease it, use
607         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
608         // solhint-disable-next-line max-line-length
609         require((value == 0) || (token.allowance(address(this), spender) == 0),
610             "SafeERC20: approve from non-zero to non-zero allowance"
611         );
612         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
613     }
614 
615     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
616         uint256 newAllowance = token.allowance(address(this), spender).add(value);
617         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
618     }
619 
620     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
621         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
622         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
623     }
624 
625     /**
626      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
627      * on the return value: the return value is optional (but if data is returned, it must not be false).
628      * @param token The token targeted by the call.
629      * @param data The call data (encoded using abi.encode or one of its variants).
630      */
631     function _callOptionalReturn(IERC20 token, bytes memory data) private {
632         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
633         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
634         // the target address contains contract code and also asserts for success in the low-level call.
635 
636         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
637         if (returndata.length > 0) { // Return data is optional
638             // solhint-disable-next-line max-line-length
639             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
640         }
641     }
642 }
643 
644 // Inheritance
645 abstract contract IRewardDistributionRecipient is Ownable {
646   address rewardDistribution;
647 
648   function notifyRewardAmount(uint256 reward) external virtual;
649 
650   modifier onlyRewardDistribution() {
651     require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
652     _;
653   }
654 
655   function setRewardDistribution(address _rewardDistribution) external onlyOwner {
656     rewardDistribution = _rewardDistribution;
657   }
658 }
659 
660 // SPDX-License-Identifier: UNLICENSED
661 contract LPTokenWrapper {
662   using SafeMath for uint256;
663   using SafeERC20 for IERC20;
664 
665   IERC20 public lp;
666 
667   uint256 private _totalSupply;
668   mapping(address => uint256) private _balances;
669 
670   constructor(address _lp) public {
671     lp = IERC20(_lp);
672   }
673 
674   function totalSupply() public view returns (uint256) {
675     return _totalSupply;
676   }
677 
678   function balanceOf(address account) public view returns (uint256) {
679     return _balances[account];
680   }
681 
682   function stake(uint256 amount) public virtual {
683     _totalSupply = _totalSupply.add(amount);
684     _balances[msg.sender] = _balances[msg.sender].add(amount);
685     lp.safeTransferFrom(msg.sender, address(this), amount);
686   }
687 
688   function withdraw(uint256 amount) public virtual {
689     _totalSupply = _totalSupply.sub(amount);
690     _balances[msg.sender] = _balances[msg.sender].sub(amount);
691     lp.safeTransfer(msg.sender, amount);
692   }
693 }
694 
695 // File: @openzeppelin/contracts/math/Math.sol
696 contract RewardsPool is LPTokenWrapper, IRewardDistributionRecipient, ReentrancyGuard {
697   IERC20 public outToken;
698 
699   uint256 public constant DURATION = 7 days;
700   uint256 public stakeDurationSeconds = 3 days;
701   uint256 public constant MIN_STAKE_DURATION_SECONDS = 2 minutes;
702   uint256 public constant REWARD_DELAY_SECONDS = 1 minutes;
703 
704   uint256 public periodFinish = 0;
705   uint256 public rewardRate = 0;
706   uint256 public lastUpdateTime;
707   uint256 public rewardPerTokenStored;
708   mapping(address => uint256) public userRewardPerTokenPaid;
709   mapping(address => uint256) public rewards;
710   mapping(address => uint256) public canWithdrawTime;
711   mapping(address => uint256) public canGetRewardTime;
712 
713   event RewardAdded(uint256 reward);
714   event Staked(address indexed user, uint256 amount);
715   event Withdrawn(address indexed user, uint256 amount);
716   event RewardPaid(address indexed user, uint256 reward);
717 
718   constructor(
719     address lp_,
720     IERC20 outToken_,
721     address rewardDistribution_,
722     uint256 stakeDurationSeconds_
723   ) public LPTokenWrapper(lp_) {
724     require(stakeDurationSeconds_ >= MIN_STAKE_DURATION_SECONDS, "!minStakeDurationSeconds");
725     rewardDistribution = rewardDistribution_;
726     outToken = outToken_;
727     stakeDurationSeconds = stakeDurationSeconds_;
728   }
729 
730   modifier updateReward(address account) {
731     rewardPerTokenStored = rewardPerToken();
732     lastUpdateTime = lastTimeRewardApplicable();
733     if (account != address(0)) {
734       rewards[account] = earned(account);
735       userRewardPerTokenPaid[account] = rewardPerTokenStored;
736     }
737     _;
738   }
739 
740   function lastTimeRewardApplicable() public view returns (uint256) {
741     return Math.min(block.timestamp, periodFinish);
742   }
743 
744   function rewardPerToken() public view returns (uint256) {
745     if (totalSupply() == 0) {
746       return rewardPerTokenStored;
747     }
748     return
749       rewardPerTokenStored.add(
750         lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(totalSupply())
751       );
752   }
753 
754   function earned(address account) public view returns (uint256) {
755     return
756       balanceOf(account).mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
757   }
758 
759   function stake(uint256 amount) public override nonReentrant updateReward(msg.sender) {
760     require(amount > 0, "Cannot stake 0");
761     canWithdrawTime[msg.sender] = now + stakeDurationSeconds;
762     canGetRewardTime[msg.sender] = now + REWARD_DELAY_SECONDS;
763     emit Staked(msg.sender, amount);
764     super.stake(amount);
765   }
766 
767   function withdraw(uint256 amount) public override nonReentrant updateReward(msg.sender) {
768     require(amount > 0, "Cannot withdraw 0");
769     require(now > canWithdrawTime[msg.sender], "The mortgage will take some time to redeem");
770     emit Withdrawn(msg.sender, amount);
771     super.withdraw(amount);
772   }
773 
774   // Is not `nonReentrant` because of calls have this modifier.
775   function exit() external {
776     withdraw(balanceOf(msg.sender));
777     getReward();
778   }
779 
780   function getReward() public nonReentrant updateReward(msg.sender) {
781     require(now > canGetRewardTime[msg.sender], "Delay after Stake is required");
782     uint256 reward = earned(msg.sender);
783     if (reward > 0) {
784       rewards[msg.sender] = 0;
785       emit RewardPaid(msg.sender, reward);
786       outToken.safeTransfer(msg.sender, reward);
787     }
788   }
789 
790   function notifyRewardAmount(uint256 reward)
791     external
792     override
793     nonReentrant
794     onlyRewardDistribution
795     updateReward(address(0))
796   {
797     if (block.timestamp >= periodFinish) {
798       rewardRate = reward.div(DURATION);
799     } else {
800       uint256 remaining = periodFinish.sub(block.timestamp);
801       uint256 leftover = remaining.mul(rewardRate);
802       rewardRate = reward.add(leftover).div(DURATION);
803     }
804     lastUpdateTime = block.timestamp;
805     periodFinish = block.timestamp.add(DURATION);
806     emit RewardAdded(reward);
807   }
808 
809   function lockedDetails() external view returns (bool, uint256) {
810     return (false, periodFinish);
811   }
812 
813   function voteLock(address account) external view returns (uint256) {
814     return (canWithdrawTime[account]);
815   }
816 }
817 
818 contract EDDARewardsPool is RewardsPool {
819   constructor(
820     address lp_,
821     IERC20 outToken_,
822     address rewardDistribution_,
823     uint256 stakeDurationSeconds_
824   ) public RewardsPool(lp_, outToken_, rewardDistribution_, stakeDurationSeconds_) {}
825 }