1 // Sources flattened with hardhat v2.3.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
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
83 
84 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
85 
86 
87 pragma solidity >=0.6.0 <0.8.0;
88 
89 /*
90  * @dev Provides information about the current execution context, including the
91  * sender of the transaction and its data. While these are generally available
92  * via msg.sender and msg.data, they should not be accessed in such a direct
93  * manner, since when dealing with GSN meta-transactions the account sending and
94  * paying for execution may not be the actual sender (as far as an application
95  * is concerned).
96  *
97  * This contract is only required for intermediate, library-like contracts.
98  */
99 abstract contract Context {
100     function _msgSender() internal view virtual returns (address payable) {
101         return msg.sender;
102     }
103 
104     function _msgData() internal view virtual returns (bytes memory) {
105         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
106         return msg.data;
107     }
108 }
109 
110 
111 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
112 
113 
114 pragma solidity >=0.6.0 <0.8.0;
115 
116 /**
117  * @dev Contract module which provides a basic access control mechanism, where
118  * there is an account (an owner) that can be granted exclusive access to
119  * specific functions.
120  *
121  * By default, the owner account will be the one that deploys the contract. This
122  * can later be changed with {transferOwnership}.
123  *
124  * This module is used through inheritance. It will make available the modifier
125  * `onlyOwner`, which can be applied to your functions to restrict their use to
126  * the owner.
127  */
128 abstract contract Ownable is Context {
129     address private _owner;
130 
131     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
132 
133     /**
134      * @dev Initializes the contract setting the deployer as the initial owner.
135      */
136     constructor () internal {
137         address msgSender = _msgSender();
138         _owner = msgSender;
139         emit OwnershipTransferred(address(0), msgSender);
140     }
141 
142     /**
143      * @dev Returns the address of the current owner.
144      */
145     function owner() public view virtual returns (address) {
146         return _owner;
147     }
148 
149     /**
150      * @dev Throws if called by any account other than the owner.
151      */
152     modifier onlyOwner() {
153         require(owner() == _msgSender(), "Ownable: caller is not the owner");
154         _;
155     }
156 
157     /**
158      * @dev Leaves the contract without owner. It will not be possible to call
159      * `onlyOwner` functions anymore. Can only be called by the current owner.
160      *
161      * NOTE: Renouncing ownership will leave the contract without an owner,
162      * thereby removing any functionality that is only available to the owner.
163      */
164     function renounceOwnership() public virtual onlyOwner {
165         emit OwnershipTransferred(_owner, address(0));
166         _owner = address(0);
167     }
168 
169     /**
170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
171      * Can only be called by the current owner.
172      */
173     function transferOwnership(address newOwner) public virtual onlyOwner {
174         require(newOwner != address(0), "Ownable: new owner is the zero address");
175         emit OwnershipTransferred(_owner, newOwner);
176         _owner = newOwner;
177     }
178 }
179 
180 
181 // File @openzeppelin/contracts/utils/ReentrancyGuard.sol@v3.4.1
182 
183 
184 pragma solidity >=0.6.0 <0.8.0;
185 
186 /**
187  * @dev Contract module that helps prevent reentrant calls to a function.
188  *
189  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
190  * available, which can be applied to functions to make sure there are no nested
191  * (reentrant) calls to them.
192  *
193  * Note that because there is a single `nonReentrant` guard, functions marked as
194  * `nonReentrant` may not call one another. This can be worked around by making
195  * those functions `private`, and then adding `external` `nonReentrant` entry
196  * points to them.
197  *
198  * TIP: If you would like to learn more about reentrancy and alternative ways
199  * to protect against it, check out our blog post
200  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
201  */
202 abstract contract ReentrancyGuard {
203     // Booleans are more expensive than uint256 or any type that takes up a full
204     // word because each write operation emits an extra SLOAD to first read the
205     // slot's contents, replace the bits taken up by the boolean, and then write
206     // back. This is the compiler's defense against contract upgrades and
207     // pointer aliasing, and it cannot be disabled.
208 
209     // The values being non-zero value makes deployment a bit more expensive,
210     // but in exchange the refund on every call to nonReentrant will be lower in
211     // amount. Since refunds are capped to a percentage of the total
212     // transaction's gas, it is best to keep them low in cases like this one, to
213     // increase the likelihood of the full refund coming into effect.
214     uint256 private constant _NOT_ENTERED = 1;
215     uint256 private constant _ENTERED = 2;
216 
217     uint256 private _status;
218 
219     constructor () internal {
220         _status = _NOT_ENTERED;
221     }
222 
223     /**
224      * @dev Prevents a contract from calling itself, directly or indirectly.
225      * Calling a `nonReentrant` function from another `nonReentrant`
226      * function is not supported. It is possible to prevent this from happening
227      * by making the `nonReentrant` function external, and make it call a
228      * `private` function that does the actual work.
229      */
230     modifier nonReentrant() {
231         // On the first call to nonReentrant, _notEntered will be true
232         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
233 
234         // Any calls to nonReentrant after this point will fail
235         _status = _ENTERED;
236 
237         _;
238 
239         // By storing the original value once again, a refund is triggered (see
240         // https://eips.ethereum.org/EIPS/eip-2200)
241         _status = _NOT_ENTERED;
242     }
243 }
244 
245 
246 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
247 
248 
249 pragma solidity >=0.6.0 <0.8.0;
250 
251 /**
252  * @dev Wrappers over Solidity's arithmetic operations with added overflow
253  * checks.
254  *
255  * Arithmetic operations in Solidity wrap on overflow. This can easily result
256  * in bugs, because programmers usually assume that an overflow raises an
257  * error, which is the standard behavior in high level programming languages.
258  * `SafeMath` restores this intuition by reverting the transaction when an
259  * operation overflows.
260  *
261  * Using this library instead of the unchecked operations eliminates an entire
262  * class of bugs, so it's recommended to use it always.
263  */
264 library SafeMath {
265     /**
266      * @dev Returns the addition of two unsigned integers, with an overflow flag.
267      *
268      * _Available since v3.4._
269      */
270     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
271         uint256 c = a + b;
272         if (c < a) return (false, 0);
273         return (true, c);
274     }
275 
276     /**
277      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
278      *
279      * _Available since v3.4._
280      */
281     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
282         if (b > a) return (false, 0);
283         return (true, a - b);
284     }
285 
286     /**
287      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
288      *
289      * _Available since v3.4._
290      */
291     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
292         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
293         // benefit is lost if 'b' is also tested.
294         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
295         if (a == 0) return (true, 0);
296         uint256 c = a * b;
297         if (c / a != b) return (false, 0);
298         return (true, c);
299     }
300 
301     /**
302      * @dev Returns the division of two unsigned integers, with a division by zero flag.
303      *
304      * _Available since v3.4._
305      */
306     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
307         if (b == 0) return (false, 0);
308         return (true, a / b);
309     }
310 
311     /**
312      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
313      *
314      * _Available since v3.4._
315      */
316     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
317         if (b == 0) return (false, 0);
318         return (true, a % b);
319     }
320 
321     /**
322      * @dev Returns the addition of two unsigned integers, reverting on
323      * overflow.
324      *
325      * Counterpart to Solidity's `+` operator.
326      *
327      * Requirements:
328      *
329      * - Addition cannot overflow.
330      */
331     function add(uint256 a, uint256 b) internal pure returns (uint256) {
332         uint256 c = a + b;
333         require(c >= a, "SafeMath: addition overflow");
334         return c;
335     }
336 
337     /**
338      * @dev Returns the subtraction of two unsigned integers, reverting on
339      * overflow (when the result is negative).
340      *
341      * Counterpart to Solidity's `-` operator.
342      *
343      * Requirements:
344      *
345      * - Subtraction cannot overflow.
346      */
347     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
348         require(b <= a, "SafeMath: subtraction overflow");
349         return a - b;
350     }
351 
352     /**
353      * @dev Returns the multiplication of two unsigned integers, reverting on
354      * overflow.
355      *
356      * Counterpart to Solidity's `*` operator.
357      *
358      * Requirements:
359      *
360      * - Multiplication cannot overflow.
361      */
362     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
363         if (a == 0) return 0;
364         uint256 c = a * b;
365         require(c / a == b, "SafeMath: multiplication overflow");
366         return c;
367     }
368 
369     /**
370      * @dev Returns the integer division of two unsigned integers, reverting on
371      * division by zero. The result is rounded towards zero.
372      *
373      * Counterpart to Solidity's `/` operator. Note: this function uses a
374      * `revert` opcode (which leaves remaining gas untouched) while Solidity
375      * uses an invalid opcode to revert (consuming all remaining gas).
376      *
377      * Requirements:
378      *
379      * - The divisor cannot be zero.
380      */
381     function div(uint256 a, uint256 b) internal pure returns (uint256) {
382         require(b > 0, "SafeMath: division by zero");
383         return a / b;
384     }
385 
386     /**
387      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
388      * reverting when dividing by zero.
389      *
390      * Counterpart to Solidity's `%` operator. This function uses a `revert`
391      * opcode (which leaves remaining gas untouched) while Solidity uses an
392      * invalid opcode to revert (consuming all remaining gas).
393      *
394      * Requirements:
395      *
396      * - The divisor cannot be zero.
397      */
398     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
399         require(b > 0, "SafeMath: modulo by zero");
400         return a % b;
401     }
402 
403     /**
404      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
405      * overflow (when the result is negative).
406      *
407      * CAUTION: This function is deprecated because it requires allocating memory for the error
408      * message unnecessarily. For custom revert reasons use {trySub}.
409      *
410      * Counterpart to Solidity's `-` operator.
411      *
412      * Requirements:
413      *
414      * - Subtraction cannot overflow.
415      */
416     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
417         require(b <= a, errorMessage);
418         return a - b;
419     }
420 
421     /**
422      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
423      * division by zero. The result is rounded towards zero.
424      *
425      * CAUTION: This function is deprecated because it requires allocating memory for the error
426      * message unnecessarily. For custom revert reasons use {tryDiv}.
427      *
428      * Counterpart to Solidity's `/` operator. Note: this function uses a
429      * `revert` opcode (which leaves remaining gas untouched) while Solidity
430      * uses an invalid opcode to revert (consuming all remaining gas).
431      *
432      * Requirements:
433      *
434      * - The divisor cannot be zero.
435      */
436     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
437         require(b > 0, errorMessage);
438         return a / b;
439     }
440 
441     /**
442      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
443      * reverting with custom message when dividing by zero.
444      *
445      * CAUTION: This function is deprecated because it requires allocating memory for the error
446      * message unnecessarily. For custom revert reasons use {tryMod}.
447      *
448      * Counterpart to Solidity's `%` operator. This function uses a `revert`
449      * opcode (which leaves remaining gas untouched) while Solidity uses an
450      * invalid opcode to revert (consuming all remaining gas).
451      *
452      * Requirements:
453      *
454      * - The divisor cannot be zero.
455      */
456     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
457         require(b > 0, errorMessage);
458         return a % b;
459     }
460 }
461 
462 
463 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
464 
465 
466 pragma solidity >=0.6.2 <0.8.0;
467 
468 /**
469  * @dev Collection of functions related to the address type
470  */
471 library Address {
472     /**
473      * @dev Returns true if `account` is a contract.
474      *
475      * [IMPORTANT]
476      * ====
477      * It is unsafe to assume that an address for which this function returns
478      * false is an externally-owned account (EOA) and not a contract.
479      *
480      * Among others, `isContract` will return false for the following
481      * types of addresses:
482      *
483      *  - an externally-owned account
484      *  - a contract in construction
485      *  - an address where a contract will be created
486      *  - an address where a contract lived, but was destroyed
487      * ====
488      */
489     function isContract(address account) internal view returns (bool) {
490         // This method relies on extcodesize, which returns 0 for contracts in
491         // construction, since the code is only stored at the end of the
492         // constructor execution.
493 
494         uint256 size;
495         // solhint-disable-next-line no-inline-assembly
496         assembly { size := extcodesize(account) }
497         return size > 0;
498     }
499 
500     /**
501      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
502      * `recipient`, forwarding all available gas and reverting on errors.
503      *
504      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
505      * of certain opcodes, possibly making contracts go over the 2300 gas limit
506      * imposed by `transfer`, making them unable to receive funds via
507      * `transfer`. {sendValue} removes this limitation.
508      *
509      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
510      *
511      * IMPORTANT: because control is transferred to `recipient`, care must be
512      * taken to not create reentrancy vulnerabilities. Consider using
513      * {ReentrancyGuard} or the
514      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
515      */
516     function sendValue(address payable recipient, uint256 amount) internal {
517         require(address(this).balance >= amount, "Address: insufficient balance");
518 
519         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
520         (bool success, ) = recipient.call{ value: amount }("");
521         require(success, "Address: unable to send value, recipient may have reverted");
522     }
523 
524     /**
525      * @dev Performs a Solidity function call using a low level `call`. A
526      * plain`call` is an unsafe replacement for a function call: use this
527      * function instead.
528      *
529      * If `target` reverts with a revert reason, it is bubbled up by this
530      * function (like regular Solidity function calls).
531      *
532      * Returns the raw returned data. To convert to the expected return value,
533      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
534      *
535      * Requirements:
536      *
537      * - `target` must be a contract.
538      * - calling `target` with `data` must not revert.
539      *
540      * _Available since v3.1._
541      */
542     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
543       return functionCall(target, data, "Address: low-level call failed");
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
548      * `errorMessage` as a fallback revert reason when `target` reverts.
549      *
550      * _Available since v3.1._
551      */
552     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
553         return functionCallWithValue(target, data, 0, errorMessage);
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
558      * but also transferring `value` wei to `target`.
559      *
560      * Requirements:
561      *
562      * - the calling contract must have an ETH balance of at least `value`.
563      * - the called Solidity function must be `payable`.
564      *
565      * _Available since v3.1._
566      */
567     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
568         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
573      * with `errorMessage` as a fallback revert reason when `target` reverts.
574      *
575      * _Available since v3.1._
576      */
577     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
578         require(address(this).balance >= value, "Address: insufficient balance for call");
579         require(isContract(target), "Address: call to non-contract");
580 
581         // solhint-disable-next-line avoid-low-level-calls
582         (bool success, bytes memory returndata) = target.call{ value: value }(data);
583         return _verifyCallResult(success, returndata, errorMessage);
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
588      * but performing a static call.
589      *
590      * _Available since v3.3._
591      */
592     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
593         return functionStaticCall(target, data, "Address: low-level static call failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
598      * but performing a static call.
599      *
600      * _Available since v3.3._
601      */
602     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
603         require(isContract(target), "Address: static call to non-contract");
604 
605         // solhint-disable-next-line avoid-low-level-calls
606         (bool success, bytes memory returndata) = target.staticcall(data);
607         return _verifyCallResult(success, returndata, errorMessage);
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
612      * but performing a delegate call.
613      *
614      * _Available since v3.4._
615      */
616     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
617         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
618     }
619 
620     /**
621      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
622      * but performing a delegate call.
623      *
624      * _Available since v3.4._
625      */
626     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
627         require(isContract(target), "Address: delegate call to non-contract");
628 
629         // solhint-disable-next-line avoid-low-level-calls
630         (bool success, bytes memory returndata) = target.delegatecall(data);
631         return _verifyCallResult(success, returndata, errorMessage);
632     }
633 
634     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
635         if (success) {
636             return returndata;
637         } else {
638             // Look for revert reason and bubble it up if present
639             if (returndata.length > 0) {
640                 // The easiest way to bubble the revert reason is using memory via assembly
641 
642                 // solhint-disable-next-line no-inline-assembly
643                 assembly {
644                     let returndata_size := mload(returndata)
645                     revert(add(32, returndata), returndata_size)
646                 }
647             } else {
648                 revert(errorMessage);
649             }
650         }
651     }
652 }
653 
654 
655 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.1
656 
657 
658 pragma solidity >=0.6.0 <0.8.0;
659 
660 
661 
662 /**
663  * @title SafeERC20
664  * @dev Wrappers around ERC20 operations that throw on failure (when the token
665  * contract returns false). Tokens that return no value (and instead revert or
666  * throw on failure) are also supported, non-reverting calls are assumed to be
667  * successful.
668  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
669  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
670  */
671 library SafeERC20 {
672     using SafeMath for uint256;
673     using Address for address;
674 
675     function safeTransfer(IERC20 token, address to, uint256 value) internal {
676         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
677     }
678 
679     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
680         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
681     }
682 
683     /**
684      * @dev Deprecated. This function has issues similar to the ones found in
685      * {IERC20-approve}, and its usage is discouraged.
686      *
687      * Whenever possible, use {safeIncreaseAllowance} and
688      * {safeDecreaseAllowance} instead.
689      */
690     function safeApprove(IERC20 token, address spender, uint256 value) internal {
691         // safeApprove should only be called when setting an initial allowance,
692         // or when resetting it to zero. To increase and decrease it, use
693         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
694         // solhint-disable-next-line max-line-length
695         require((value == 0) || (token.allowance(address(this), spender) == 0),
696             "SafeERC20: approve from non-zero to non-zero allowance"
697         );
698         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
699     }
700 
701     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
702         uint256 newAllowance = token.allowance(address(this), spender).add(value);
703         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
704     }
705 
706     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
707         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
708         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
709     }
710 
711     /**
712      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
713      * on the return value: the return value is optional (but if data is returned, it must not be false).
714      * @param token The token targeted by the call.
715      * @param data The call data (encoded using abi.encode or one of its variants).
716      */
717     function _callOptionalReturn(IERC20 token, bytes memory data) private {
718         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
719         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
720         // the target address contains contract code and also asserts for success in the low-level call.
721 
722         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
723         if (returndata.length > 0) { // Return data is optional
724             // solhint-disable-next-line max-line-length
725             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
726         }
727     }
728 }
729 
730 
731 // File contracts/lib/FixedPointMath.sol
732 
733 /*
734     Copyright 2021 Cook Finance.
735 
736     Licensed under the Apache License, Version 2.0 (the "License");
737     you may not use this file except in compliance with the License.
738     You may obtain a copy of the License at
739 
740     http://www.apache.org/licenses/LICENSE-2.0
741 
742     Unless required by applicable law or agreed to in writing, software
743     distributed under the License is distributed on an "AS IS" BASIS,
744     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
745     See the License for the specific language governing permissions and
746     limitations under the License.
747 
748 */
749 pragma solidity ^0.6.2;
750 
751 library FixedPointMath {
752   uint256 public constant DECIMALS = 18;
753   uint256 public constant SCALAR = 10**DECIMALS;
754 
755   struct uq192x64 {
756     uint256 x;
757   }
758 
759   function fromU256(uint256 value) internal pure returns (uq192x64 memory) {
760     uint256 x;
761     require(value == 0 || (x = value * SCALAR) / SCALAR == value);
762     return uq192x64(x);
763   }
764 
765   function maximumValue() internal pure returns (uq192x64 memory) {
766     return uq192x64(uint256(-1));
767   }
768 
769   function add(uq192x64 memory self, uq192x64 memory value) internal pure returns (uq192x64 memory) {
770     uint256 x;
771     require((x = self.x + value.x) >= self.x);
772     return uq192x64(x);
773   }
774 
775   function add(uq192x64 memory self, uint256 value) internal pure returns (uq192x64 memory) {
776     return add(self, fromU256(value));
777   }
778 
779   function sub(uq192x64 memory self, uq192x64 memory value) internal pure returns (uq192x64 memory) {
780     uint256 x;
781     require((x = self.x - value.x) <= self.x);
782     return uq192x64(x);
783   }
784 
785   function sub(uq192x64 memory self, uint256 value) internal pure returns (uq192x64 memory) {
786     return sub(self, fromU256(value));
787   }
788 
789   function mul(uq192x64 memory self, uint256 value) internal pure returns (uq192x64 memory) {
790     uint256 x;
791     require(value == 0 || (x = self.x * value) / value == self.x);
792     return uq192x64(x);
793   }
794 
795   function div(uq192x64 memory self, uint256 value) internal pure returns (uq192x64 memory) {
796     require(value != 0);
797     return uq192x64(self.x / value);
798   }
799 
800   function cmp(uq192x64 memory self, uq192x64 memory value) internal pure returns (int256) {
801     if (self.x < value.x) {
802       return -1;
803     }
804 
805     if (self.x > value.x) {
806       return 1;
807     }
808 
809     return 0;
810   }
811 
812   function decode(uq192x64 memory self) internal pure returns (uint256) {
813     return self.x / SCALAR;
814   }
815 }
816 
817 
818 // File contracts/interfaces/IDetailedERC20.sol
819 
820 /*
821     Copyright 2021 Cook Finance.
822 
823     Licensed under the Apache License, Version 2.0 (the "License");
824     you may not use this file except in compliance with the License.
825     You may obtain a copy of the License at
826 
827     http://www.apache.org/licenses/LICENSE-2.0
828 
829     Unless required by applicable law or agreed to in writing, software
830     distributed under the License is distributed on an "AS IS" BASIS,
831     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
832     See the License for the specific language governing permissions and
833     limitations under the License.
834 */
835 pragma solidity ^0.6.2;
836 
837 interface IDetailedERC20 is IERC20 {
838   function name() external returns (string memory);
839   function symbol() external returns (string memory);
840   function decimals() external returns (uint8);
841 }
842 
843 
844 // File contracts/interfaces/IMintableERC20.sol
845 
846 /*
847     Copyright 2021 Cook Finance.
848 
849     Licensed under the Apache License, Version 2.0 (the "License");
850     you may not use this file except in compliance with the License.
851     You may obtain a copy of the License at
852 
853     http://www.apache.org/licenses/LICENSE-2.0
854 
855     Unless required by applicable law or agreed to in writing, software
856     distributed under the License is distributed on an "AS IS" BASIS,
857     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
858     See the License for the specific language governing permissions and
859     limitations under the License.
860 */
861 pragma solidity ^0.6.2;
862 
863 interface IMintableERC20 is IDetailedERC20{
864   function mint(address _recipient, uint256 _amount) external;
865   function burnFrom(address account, uint256 amount) external;
866   function lowerHasMinted(uint256 amount) external;
867   function lowerHasMintedIfNeeded(uint256 amount) external;
868 }
869 
870 
871 // File contracts/interfaces/IRewardVesting.sol
872 
873 /*
874     Copyright 2021 Cook Finance.
875 
876     Licensed under the Apache License, Version 2.0 (the "License");
877     you may not use this file except in compliance with the License.
878     You may obtain a copy of the License at
879 
880     http://www.apache.org/licenses/LICENSE-2.0
881 
882     Unless required by applicable law or agreed to in writing, software
883     distributed under the License is distributed on an "AS IS" BASIS,
884     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
885     See the License for the specific language governing permissions and
886     limitations under the License.
887 */
888 pragma solidity ^0.6.2;
889 
890 interface IRewardVesting  {
891     function addEarning(address user, uint256 amount, uint256 durationInSecs) external;
892     function userBalances(address user) external view returns (uint256 bal);
893 }
894 
895 
896 // File @openzeppelin/contracts/math/Math.sol@v3.4.1
897 
898 
899 pragma solidity >=0.6.0 <0.8.0;
900 
901 /**
902  * @dev Standard math utilities missing in the Solidity language.
903  */
904 library Math {
905     /**
906      * @dev Returns the largest of two numbers.
907      */
908     function max(uint256 a, uint256 b) internal pure returns (uint256) {
909         return a >= b ? a : b;
910     }
911 
912     /**
913      * @dev Returns the smallest of two numbers.
914      */
915     function min(uint256 a, uint256 b) internal pure returns (uint256) {
916         return a < b ? a : b;
917     }
918 
919     /**
920      * @dev Returns the average of two numbers. The result is rounded towards
921      * zero.
922      */
923     function average(uint256 a, uint256 b) internal pure returns (uint256) {
924         // (a + b) / 2 can overflow, so we distribute
925         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
926     }
927 }
928 
929 
930 // File contracts/farm/Pool.sol
931 
932 /*
933     Copyright 2021 Cook Finance.
934 
935     Licensed under the Apache License, Version 2.0 (the "License");
936     you may not use this file except in compliance with the License.
937     You may obtain a copy of the License at
938 
939     http://www.apache.org/licenses/LICENSE-2.0
940 
941     Unless required by applicable law or agreed to in writing, software
942     distributed under the License is distributed on an "AS IS" BASIS,
943     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
944     See the License for the specific language governing permissions and
945     limitations under the License.
946 
947 */
948 pragma solidity ^0.6.2;
949 pragma experimental ABIEncoderV2;
950 
951 
952 
953 
954 
955 /// @title Pool
956 ///
957 /// @dev A library which provides the Pool data struct and associated functions.
958 library Pool {
959   using FixedPointMath for FixedPointMath.uq192x64;
960   using Pool for Pool.Data;
961   using Pool for Pool.List;
962   using SafeMath for uint256;
963 
964   struct Context {
965     uint256 rewardRate;
966     uint256 totalRewardWeight;
967   }
968 
969   struct Data {
970     IERC20 token;
971     bool needVesting;
972     bool onReferralBonus;
973     uint256 totalDeposited;
974     uint256 rewardWeight;
975     FixedPointMath.uq192x64 accumulatedRewardWeight;
976     // for vesting
977     uint256 lastUpdatedBlock;
978     // for referral power calculation
979     uint256 vestingDurationInSecs;
980     uint256 totalReferralAmount; // deposited through referral
981     FixedPointMath.uq192x64 accumulatedReferralWeight;
982     uint256 lockUpPeriodInSecs;
983   }
984 
985   struct List {
986     Data[] elements;
987   }
988 
989   /// @dev Updates the pool.
990   ///
991   /// @param _ctx the pool context.
992   function update(Data storage _data, Context storage _ctx) internal {
993     _data.accumulatedRewardWeight = _data.getUpdatedAccumulatedRewardWeight(_ctx);
994 
995     if (_data.onReferralBonus) {
996       _data.accumulatedReferralWeight = _data.getUpdatedAccumulatedReferralWeight(_ctx);
997     }
998 
999     _data.lastUpdatedBlock = block.number;
1000   }
1001 
1002   /// @dev Gets the rate at which the pool will distribute rewards to stakers.
1003   ///
1004   /// @param _ctx the pool context.
1005   ///
1006   /// @return the reward rate of the pool in tokens per block.
1007   function getRewardRate(Data storage _data, Context storage _ctx)
1008     internal view
1009     returns (uint256)
1010   {
1011     return _ctx.rewardRate.mul(_data.rewardWeight).div(_ctx.totalRewardWeight);
1012   }
1013 
1014   /// @dev Gets the accumulated reward weight of a pool.
1015   ///
1016   /// @param _ctx the pool context.
1017   ///
1018   /// @return the accumulated reward weight.
1019   function getUpdatedAccumulatedRewardWeight(Data storage _data, Context storage _ctx)
1020     internal view
1021     returns (FixedPointMath.uq192x64 memory)
1022   {
1023     if (_data.totalDeposited == 0) {
1024       return _data.accumulatedRewardWeight;
1025     }
1026 
1027     uint256 _elapsedTime = block.number.sub(_data.lastUpdatedBlock);
1028     if (_elapsedTime == 0) {
1029       return _data.accumulatedRewardWeight;
1030     }
1031 
1032     uint256 _rewardRate = _data.getRewardRate(_ctx);
1033     uint256 _distributeAmount = _rewardRate.mul(_elapsedTime);
1034 
1035     if (_distributeAmount == 0) {
1036       return _data.accumulatedRewardWeight;
1037     }
1038 
1039     FixedPointMath.uq192x64 memory _rewardWeight = FixedPointMath.fromU256(_distributeAmount).div(_data.totalDeposited);
1040     return _data.accumulatedRewardWeight.add(_rewardWeight);
1041   }
1042 
1043   /// @dev Gets the accumulated referral weight of a pool.
1044   ///
1045   /// @param _ctx the pool context.
1046   ///
1047   /// @return the accumulated reward weight.
1048   function getUpdatedAccumulatedReferralWeight(Data storage _data, Context storage _ctx)
1049     internal view
1050     returns (FixedPointMath.uq192x64 memory)
1051   {
1052     if (_data.totalReferralAmount == 0) {
1053 
1054       return _data.accumulatedReferralWeight;
1055     }
1056 
1057     uint256 _elapsedTime = block.number.sub(_data.lastUpdatedBlock);
1058     if (_elapsedTime == 0) {
1059       return _data.accumulatedReferralWeight;
1060     }
1061 
1062     uint256 _rewardRate = _data.getRewardRate(_ctx);
1063     uint256 _distributeAmount = _rewardRate.mul(_elapsedTime);
1064 
1065     if (_distributeAmount == 0) {
1066       return _data.accumulatedReferralWeight;
1067     }
1068 
1069     FixedPointMath.uq192x64 memory _rewardWeight = FixedPointMath.fromU256(_distributeAmount).div(_data.totalReferralAmount);
1070     return _data.accumulatedReferralWeight.add(_rewardWeight);
1071   }  
1072 
1073   /// @dev Adds an element to the list.
1074   ///
1075   /// @param _element the element to add.
1076   function push(List storage _self, Data memory _element) internal {
1077     _self.elements.push(_element);
1078   }
1079 
1080   /// @dev Gets an element from the list.
1081   ///
1082   /// @param _index the index in the list.
1083   ///
1084   /// @return the element at the specified index.
1085   function get(List storage _self, uint256 _index) internal view returns (Data storage) {
1086     return _self.elements[_index];
1087   }
1088 
1089   /// @dev Gets the last element in the list.
1090   ///
1091   /// This function will revert if there are no elements in the list.
1092   ///ck
1093   /// @return the last element in the list.
1094   function last(List storage _self) internal view returns (Data storage) {
1095     return _self.elements[_self.lastIndex()];
1096   }
1097 
1098   /// @dev Gets the index of the last element in the list.
1099   ///
1100   /// This function will revert if there are no elements in the list.
1101   ///
1102   /// @return the index of the last element.
1103   function lastIndex(List storage _self) internal view returns (uint256) {
1104     uint256 _length = _self.length();
1105     return _length.sub(1, "Pool.List: list is empty");
1106   }
1107 
1108   /// @dev Gets the number of elements in the list.
1109   ///
1110   /// @return the number of elements.
1111   function length(List storage _self) internal view returns (uint256) {
1112     return _self.elements.length;
1113   }
1114 }
1115 
1116 
1117 // File contracts/farm/Stake.sol
1118 
1119 /*
1120     Copyright 2021 Cook Finance.
1121 
1122     Licensed under the Apache License, Version 2.0 (the "License");
1123     you may not use this file except in compliance with the License.
1124     You may obtain a copy of the License at
1125 
1126     http://www.apache.org/licenses/LICENSE-2.0
1127 
1128     Unless required by applicable law or agreed to in writing, software
1129     distributed under the License is distributed on an "AS IS" BASIS,
1130     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1131     See the License for the specific language governing permissions and
1132     limitations under the License.
1133 
1134 */
1135 pragma solidity ^0.6.2;
1136 
1137 
1138 
1139 
1140 
1141 /// @title Stake
1142 ///
1143 /// @dev A library which provides the Stake data struct and associated functions.
1144 library Stake {
1145   using FixedPointMath for FixedPointMath.uq192x64;
1146   using Pool for Pool.Data;
1147   using SafeMath for uint256;
1148   using Stake for Stake.Data;
1149 
1150   struct Data {
1151     Deposit[] deposits;
1152     uint256 totalDeposited;
1153     uint256 totalUnclaimed;
1154     FixedPointMath.uq192x64 lastAccumulatedWeight;
1155   }
1156 
1157   function update(Data storage _self, Pool.Data storage _pool, Pool.Context storage _ctx) internal {
1158     _self.totalUnclaimed = _self.getUpdatedTotalUnclaimed(_pool, _ctx);
1159     _self.lastAccumulatedWeight = _pool.getUpdatedAccumulatedRewardWeight(_ctx);
1160   }
1161 
1162   function getUpdatedTotalUnclaimed(Data storage _self, Pool.Data storage _pool, Pool.Context storage _ctx)
1163     internal view
1164     returns (uint256)
1165   {
1166     FixedPointMath.uq192x64 memory _currentAccumulatedWeight = _pool.getUpdatedAccumulatedRewardWeight(_ctx);
1167     FixedPointMath.uq192x64 memory _lastAccumulatedWeight = _self.lastAccumulatedWeight;
1168 
1169     if (_currentAccumulatedWeight.cmp(_lastAccumulatedWeight) == 0) {
1170       return _self.totalUnclaimed;
1171     }
1172 
1173     uint256 _distributedAmount = _currentAccumulatedWeight
1174       .sub(_lastAccumulatedWeight)
1175       .mul(_self.totalDeposited)
1176       .decode();
1177 
1178     return _self.totalUnclaimed.add(_distributedAmount);
1179   }
1180 }
1181 
1182 struct Deposit {
1183   uint256 amount;
1184   uint256 timestamp;
1185 }
1186 
1187 
1188 // File contracts/farm/ReferralPower.sol
1189 
1190 /*
1191     Copyright 2021 Cook Finance.
1192 
1193     Licensed under the Apache License, Version 2.0 (the "License");
1194     you may not use this file except in compliance with the License.
1195     You may obtain a copy of the License at
1196 
1197     http://www.apache.org/licenses/LICENSE-2.0
1198 
1199     Unless required by applicable law or agreed to in writing, software
1200     distributed under the License is distributed on an "AS IS" BASIS,
1201     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1202     See the License for the specific language governing permissions and
1203     limitations under the License.
1204 
1205 */
1206 pragma solidity ^0.6.2;
1207 
1208 
1209 
1210 
1211 /// @title ReferralPower
1212 ///
1213 /// @dev A library which provides the ReferralPower data struct and associated functions.
1214 library ReferralPower {
1215   using FixedPointMath for FixedPointMath.uq192x64;
1216   using Pool for Pool.Data;
1217   using SafeMath for uint256;
1218   using ReferralPower for ReferralPower.Data;
1219 
1220   struct Data {
1221     uint256 totalDeposited;
1222     uint256 totalReferralPower;
1223     FixedPointMath.uq192x64 lastAccumulatedReferralPower;
1224   }
1225 
1226   function update(Data storage _self, Pool.Data storage _pool, Pool.Context storage _ctx) internal {
1227     _self.totalReferralPower = _self.getUpdatedTotalReferralPower(_pool, _ctx);
1228     _self.lastAccumulatedReferralPower = _pool.getUpdatedAccumulatedReferralWeight(_ctx);
1229   }
1230 
1231   function getUpdatedTotalReferralPower(Data storage _self, Pool.Data storage _pool, Pool.Context storage _ctx)
1232     internal view
1233     returns (uint256)
1234   {
1235     FixedPointMath.uq192x64 memory _currentAccumulatedReferralPower = _pool.getUpdatedAccumulatedReferralWeight(_ctx);
1236     FixedPointMath.uq192x64 memory lastAccumulatedReferralPower = _self.lastAccumulatedReferralPower;
1237 
1238     if (_currentAccumulatedReferralPower.cmp(lastAccumulatedReferralPower) == 0) {
1239       return _self.totalReferralPower;
1240     }
1241 
1242     uint256 _distributedAmount = _currentAccumulatedReferralPower
1243       .sub(lastAccumulatedReferralPower)
1244       .mul(_self.totalDeposited)
1245       .decode();
1246 
1247     return _self.totalReferralPower.add(_distributedAmount);
1248   }
1249 }
1250 
1251 
1252 // File contracts/farm/StakingPool.sol
1253 
1254 /*
1255     Copyright 2021 Cook Finance.
1256 
1257     Licensed under the Apache License, Version 2.0 (the "License");
1258     you may not use this file except in compliance with the License.
1259     You may obtain a copy of the License at
1260 
1261     http://www.apache.org/licenses/LICENSE-2.0
1262 
1263     Unless required by applicable law or agreed to in writing, software
1264     distributed under the License is distributed on an "AS IS" BASIS,
1265     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1266     See the License for the specific language governing permissions and
1267     limitations under the License.
1268 
1269 */
1270 pragma solidity ^0.6.2;
1271 
1272 
1273 
1274 
1275 
1276 
1277 
1278 
1279 
1280 
1281 // import "hardhat/console.sol";
1282 
1283 /// @dev A contract which allows users to stake to farm tokens.
1284 ///
1285 /// This contract was inspired by Chef Nomi's 'MasterChef' contract which can be found in this
1286 /// repository: https://github.com/sushiswap/sushiswap.
1287 contract StakingPools is ReentrancyGuard {
1288   using FixedPointMath for FixedPointMath.uq192x64;
1289   using Pool for Pool.Data;
1290   using Pool for Pool.List;
1291   using SafeERC20 for IERC20;
1292   using SafeMath for uint256;
1293   using Stake for Stake.Data;
1294   using ReferralPower for ReferralPower.Data;
1295 
1296   event PendingGovernanceUpdated(
1297     address pendingGovernance
1298   );
1299 
1300   event GovernanceUpdated(
1301     address governance
1302   );
1303 
1304   event RewardRateUpdated(
1305     uint256 rewardRate
1306   );
1307 
1308   event PoolRewardWeightUpdated(
1309     uint256 indexed poolId,
1310     uint256 rewardWeight
1311   );
1312 
1313   event PoolCreated(
1314     uint256 indexed poolId,
1315     IERC20 indexed token,
1316     uint256 vestingDurationInSecs, 
1317     uint256 depositLockPeriodInSecs
1318   );
1319 
1320   event TokensDeposited(
1321     address indexed user,
1322     uint256 indexed poolId,
1323     uint256 amount
1324   );
1325 
1326   event TokensWithdrawn(
1327     address indexed user,
1328     uint256 indexed poolId,
1329     uint256 amount
1330   );
1331 
1332   event TokensClaimed(
1333     address indexed user,
1334     uint256 indexed poolId,
1335     uint256 amount
1336   );
1337 
1338   event PauseUpdated(
1339     bool status
1340   );
1341 
1342   event SentinelUpdated(
1343     address sentinel
1344   );
1345 
1346   event RewardVestingUpdated(
1347     IRewardVesting rewardVesting
1348   );
1349 
1350   event NewReferralAdded(
1351     address referral, address referee
1352   );
1353 
1354   event StartPoolReferralCompetition(
1355     uint256 indexed poolId
1356   );
1357 
1358   event StopPoolReferralCompetition(
1359     uint256 indexed poolId
1360   );
1361 
1362   event LockUpPeriodInSecsUpdated (
1363     uint256 indexed poolId,
1364     uint256 oldLockPeriodInSecs,
1365     uint256 newLockPeriodInSecs
1366   );
1367 
1368   event VestingDurationInSecsUpdated (
1369     uint256 indexed poolId,
1370     uint256 oldDurationInSecs,
1371     uint256 newDurationInSecs
1372   );
1373 
1374   /// @dev The token which will be minted as a reward for staking.
1375   IERC20 public reward;
1376 
1377   /// @dev The address of reward vesting.
1378   IRewardVesting public rewardVesting;
1379 
1380   /// @dev The address of the account which currently has administrative capabilities over this contract.
1381   address public governance;
1382 
1383   address public pendingGovernance;
1384 
1385   /// @dev The address of the account which can perform emergency activities
1386   address public sentinel;
1387 
1388   /// @dev Tokens are mapped to their pool identifier plus one. Tokens that do not have an associated pool
1389   /// will return an identifier of zero.
1390   mapping(IERC20 => uint256) public tokenPoolIds;
1391 
1392   /// @dev The context shared between the pools.
1393   Pool.Context private _ctx;
1394 
1395   /// @dev A list of all of the pools.
1396   Pool.List private _pools;
1397 
1398   uint256 constant public SECONDS_PER_DAY = 86400;
1399 
1400   /// @dev A mapping of all of the user stakes mapped first by pool and then by address.
1401   mapping(address => mapping(uint256 => Stake.Data)) private _stakes;
1402 
1403   /// @dev A mapping of all of the referral power mapped first by pool and then by address.
1404   mapping(address => mapping(uint256 => ReferralPower.Data)) private _referralPowers;
1405 
1406 /// @dev A mapping of all of the referee staker power mapped first by referee and then by pool id to get referral address.
1407   mapping(address => mapping(uint256 => address)) public myReferral;
1408 
1409   /// @dev A mapping of known referrals mapped first by pool and then by address.
1410   mapping(address => mapping(uint256 => bool)) public referralIsKnown;
1411 
1412   /// @dev A mapping of referral Address mapped first by pool and then by nextReferral.
1413   mapping(uint256 => mapping(uint256 => address)) public referralList;
1414 
1415   /// @dev index record next user index mapped by pool
1416   mapping(uint256 => uint256) public nextReferral;
1417 
1418   // @dev A mapping of all of the referee staker referred by me. Mapping as by pool id and then by my address then referee array
1419   mapping(uint256 => mapping(address => address[])) public myreferees;
1420 
1421   /// @dev A flag indicating if claim should be halted
1422   bool public pause;
1423 
1424   constructor(
1425     IMintableERC20 _reward,
1426     address _governance,
1427     address _sentinel,
1428     IRewardVesting _rewardVesting
1429   ) public {
1430     require(_governance != address(0), "StakingPools: governance address cannot be 0x0");
1431     require(_sentinel != address(0), "StakingPools: sentinel address cannot be 0x0");
1432 
1433     reward = _reward;
1434     governance = _governance;
1435     sentinel = _sentinel;
1436     rewardVesting = _rewardVesting;
1437   }
1438 
1439   /// @dev A modifier which reverts when the caller is not the governance.
1440   modifier onlyGovernance() {
1441     require(msg.sender == governance, "StakingPools: only governance");
1442     _;
1443   }
1444 
1445   ///@dev modifier add referral to referrallist. Users are indexed in order to keep track of
1446   modifier checkIfNewReferral(uint256 pid, address referral) {
1447     Pool.Data storage _pool = _pools.get(pid);
1448 
1449     if (_pool.onReferralBonus && referral != address(0)) {
1450       if (!referralIsKnown[referral][pid]) {
1451           referralList[pid][nextReferral[pid]] = referral;
1452           referralIsKnown[referral][pid] = true;
1453           nextReferral[pid]++;
1454 
1455           emit NewReferralAdded(referral, msg.sender);
1456       }
1457 
1458       // add referee to referral's myreferee array
1459       bool toAdd = true;
1460       address refereeAddr = msg.sender;
1461       address[] storage  referees = myreferees[pid][referral];
1462       for (uint256 i = 0; i < referees.length; i++) {
1463         if (referees[i] == refereeAddr) {
1464           toAdd = false;
1465         }
1466       }
1467 
1468       if (toAdd) {
1469         referees.push(refereeAddr);
1470       }
1471     } 
1472 
1473     _;
1474   }
1475 
1476   /// @dev Sets the governance.
1477   ///
1478   /// This function can only called by the current governance.
1479   ///
1480   /// @param _pendingGovernance the new pending governance.
1481   function setPendingGovernance(address _pendingGovernance) external onlyGovernance {
1482     require(_pendingGovernance != address(0), "StakingPools: pending governance address cannot be 0x0");
1483     pendingGovernance = _pendingGovernance;
1484 
1485     emit PendingGovernanceUpdated(_pendingGovernance);
1486   }
1487 
1488   function acceptGovernance() external {
1489     require(msg.sender == pendingGovernance, "StakingPools: only pending governance");
1490 
1491     address _pendingGovernance = pendingGovernance;
1492     governance = _pendingGovernance;
1493 
1494     emit GovernanceUpdated(_pendingGovernance);
1495   }
1496 
1497   /// @dev Sets the distribution reward rate.
1498   ///
1499   /// This will update all of the pools.
1500   ///
1501   /// @param _rewardRate The number of tokens to distribute per second.
1502   function setRewardRate(uint256 _rewardRate) external onlyGovernance {
1503     _updatePools();
1504 
1505     _ctx.rewardRate = _rewardRate;
1506 
1507     emit RewardRateUpdated(_rewardRate);
1508   }
1509 
1510   /// @dev Creates a new pool.
1511   function createPool(IERC20 _token, bool _needVesting, uint256 _vestingDurationInSecs, uint256 _depositLockPeriodInSecs) external onlyGovernance returns (uint256) {
1512     require(tokenPoolIds[_token] == 0, "StakingPools: token already has a pool");
1513 
1514     uint256 _poolId = _pools.length();
1515 
1516     _pools.push(Pool.Data({
1517       token: _token,
1518       needVesting: _needVesting,
1519       onReferralBonus: false,
1520       totalDeposited: 0,
1521       rewardWeight: 0,
1522       accumulatedRewardWeight: FixedPointMath.uq192x64(0),
1523       lastUpdatedBlock: block.number,
1524       vestingDurationInSecs: _vestingDurationInSecs,
1525       totalReferralAmount: 0,
1526       accumulatedReferralWeight: FixedPointMath.uq192x64(0),
1527       lockUpPeriodInSecs: _depositLockPeriodInSecs
1528     }));
1529 
1530     tokenPoolIds[_token] = _poolId + 1;
1531 
1532     emit PoolCreated(_poolId, _token, _vestingDurationInSecs, _depositLockPeriodInSecs);
1533     return _poolId;
1534   }
1535 
1536   /// @dev Sets the reward weights of all of the pools.
1537   ///
1538   /// @param _rewardWeights The reward weights of all of the pools.
1539   function setRewardWeights(uint256[] calldata _rewardWeights) external onlyGovernance {
1540     require(_rewardWeights.length == _pools.length(), "StakingPools: weights length mismatch");
1541 
1542     _updatePools();
1543 
1544     uint256 _totalRewardWeight = _ctx.totalRewardWeight;
1545     for (uint256 _poolId = 0; _poolId < _pools.length(); _poolId++) {
1546       Pool.Data storage _pool = _pools.get(_poolId);
1547 
1548       uint256 _currentRewardWeight = _pool.rewardWeight;
1549       if (_currentRewardWeight == _rewardWeights[_poolId]) {
1550         continue;
1551       }
1552 
1553       // FIXME
1554       _totalRewardWeight = _totalRewardWeight.sub(_currentRewardWeight).add(_rewardWeights[_poolId]);
1555       _pool.rewardWeight = _rewardWeights[_poolId];
1556 
1557       emit PoolRewardWeightUpdated(_poolId, _rewardWeights[_poolId]);
1558     }
1559 
1560     _ctx.totalRewardWeight = _totalRewardWeight;
1561   }
1562 
1563   /// @dev Stakes tokens into a pool.
1564   ///
1565   /// @param _poolId        the pool to deposit tokens into.
1566   /// @param _depositAmount the amount of tokens to deposit.
1567   /// @param referral       the address of referral.
1568   function deposit(uint256 _poolId, uint256 _depositAmount, address referral) external nonReentrant checkIfNewReferral(_poolId, referral) {
1569     require(_depositAmount > 0, "zero deposit");
1570 
1571     Pool.Data storage _pool = _pools.get(_poolId);
1572     _pool.update(_ctx);
1573 
1574     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1575     _stake.update(_pool, _ctx);
1576 
1577     address _referral = myReferral[msg.sender][_poolId];
1578     if (_pool.onReferralBonus) {
1579       if (referral != address(0)) {
1580         require (_referral == address(0) || _referral == referral, "referred already");
1581         myReferral[msg.sender][_poolId] = referral;
1582       }
1583 
1584       _referral = myReferral[msg.sender][_poolId];
1585       if (_referral != address(0)) {
1586         ReferralPower.Data storage _referralPower = _referralPowers[_referral][_poolId];
1587         _referralPower.update(_pool, _ctx);
1588       }
1589     }
1590 
1591     _deposit(_poolId, _depositAmount, _referral);
1592   }
1593 
1594   /// @dev Withdraws staked tokens from a pool.
1595   ///
1596   /// @param _poolId          The pool to withdraw staked tokens from.
1597   /// @param _withdrawAmount  The number of tokens to withdraw.
1598   function withdraw(uint256 _poolId, uint256 _withdrawAmount) external nonReentrant {
1599     require(_withdrawAmount > 0, "to withdraw zero");
1600     uint256 withdrawAbleAmount = getWithdrawableAmount(_poolId, msg.sender);
1601     require(withdrawAbleAmount >= _withdrawAmount, "amount exceeds withdrawAble");
1602 
1603     Pool.Data storage _pool = _pools.get(_poolId);
1604     _pool.update(_ctx);
1605 
1606     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1607     _stake.update(_pool, _ctx);
1608 
1609     address _referral = _pool.onReferralBonus ? myReferral[msg.sender][_poolId] : address(0);
1610 
1611     if (_pool.onReferralBonus && _referral != address(0)) {
1612       ReferralPower.Data storage _referralPower = _referralPowers[_referral][_poolId];
1613       _referralPower.update(_pool, _ctx);
1614     }
1615 
1616     _claim(_poolId);
1617     _withdraw(_poolId, _withdrawAmount, _referral);
1618   }
1619 
1620   /// @dev Claims all rewarded tokens from a pool.
1621   ///
1622   /// @param _poolId The pool to claim rewards from.
1623   ///
1624   /// @notice use this function to claim the tokens from a corresponding pool by ID.
1625   function claim(uint256 _poolId) external nonReentrant {
1626     Pool.Data storage _pool = _pools.get(_poolId);
1627     _pool.update(_ctx);
1628 
1629     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1630 
1631     _stake.update(_pool, _ctx);
1632 
1633     _claim(_poolId);
1634   }
1635 
1636   /// @dev Claims all rewards from a pool and then withdraws all withdrawAble tokens.
1637   ///
1638   /// @param _poolId the pool to exit from.
1639   function exit(uint256 _poolId) external nonReentrant {
1640     uint256 withdrawAbleAmount = getWithdrawableAmount(_poolId, msg.sender);
1641     require(withdrawAbleAmount > 0, "all deposited still locked");
1642 
1643     Pool.Data storage _pool = _pools.get(_poolId);
1644     _pool.update(_ctx);
1645 
1646     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1647     _stake.update(_pool, _ctx);
1648 
1649     address _referral = _pool.onReferralBonus ? myReferral[msg.sender][_poolId] : address(0);
1650 
1651     if (_pool.onReferralBonus && _referral != address(0)) {
1652       ReferralPower.Data storage _referralPower = _referralPowers[_referral][_poolId];
1653       _referralPower.update(_pool, _ctx);
1654     }
1655 
1656     _claim(_poolId);
1657     _withdraw(_poolId, withdrawAbleAmount, _referral);
1658   }
1659 
1660   /// @dev Gets the rate at which tokens are minted to stakers for all pools.
1661   ///
1662   /// @return the reward rate.
1663   function rewardRate() external view returns (uint256) {
1664     return _ctx.rewardRate;
1665   }
1666 
1667   /// @dev Gets the total reward weight between all the pools.
1668   ///
1669   /// @return the total reward weight.
1670   function totalRewardWeight() external view returns (uint256) {
1671     return _ctx.totalRewardWeight;
1672   }
1673 
1674   /// @dev Gets the number of pools that exist.
1675   ///
1676   /// @return the pool count.
1677   function poolCount() external view returns (uint256) {
1678     return _pools.length();
1679   }
1680 
1681   /// @dev Gets the token a pool accepts.
1682   ///
1683   /// @param _poolId the identifier of the pool.
1684   ///
1685   /// @return the token.
1686   function getPoolToken(uint256 _poolId) external view returns (IERC20) {
1687     Pool.Data storage _pool = _pools.get(_poolId);
1688     return _pool.token;
1689   }
1690 
1691   /// @dev Gets the total amount of funds staked in a pool.
1692   ///
1693   /// @param _poolId the identifier of the pool.
1694   ///
1695   /// @return the total amount of staked or deposited tokens.
1696   function getPoolTotalDeposited(uint256 _poolId) external view returns (uint256) {
1697     Pool.Data storage _pool = _pools.get(_poolId);
1698     return _pool.totalDeposited;
1699   }
1700 
1701   /// @dev Gets the total amount of referreal power in a pool.
1702   ///
1703   /// @param _poolId the identifier of the pool.
1704   ///
1705   /// @return the total amount of referreal power in pool.
1706   function getPoolTotalReferralAmount(uint256 _poolId) external view returns (uint256) {
1707     Pool.Data storage _pool = _pools.get(_poolId);
1708     return _pool.totalReferralAmount;
1709   }
1710 
1711   /// @dev Gets the reward weight of a pool which determines how much of the total rewards it receives per block.
1712   ///
1713   /// @param _poolId the identifier of the pool.
1714   ///
1715   /// @return the pool reward weight.
1716   function getPoolRewardWeight(uint256 _poolId) external view returns (uint256) {
1717     Pool.Data storage _pool = _pools.get(_poolId);
1718     return _pool.rewardWeight;
1719   }
1720 
1721   /// @dev Gets the amount of tokens per block being distributed to stakers for a pool.
1722   ///
1723   /// @param _poolId the identifier of the pool.
1724   ///
1725   /// @return the pool reward rate.
1726   function getPoolRewardRate(uint256 _poolId) external view returns (uint256) {
1727     Pool.Data storage _pool = _pools.get(_poolId);
1728     return _pool.getRewardRate(_ctx);
1729   }
1730 
1731   /// @dev Gets the number of tokens a user has staked into a pool.
1732   ///
1733   /// @param _account The account to query.
1734   /// @param _poolId  the identifier of the pool.
1735   ///
1736   /// @return the amount of deposited tokens.
1737   function getStakeTotalDeposited(address _account, uint256 _poolId) external view returns (uint256) {
1738     Stake.Data storage _stake = _stakes[_account][_poolId];
1739     return _stake.totalDeposited;
1740   }
1741 
1742   /// @dev Gets the number of unclaimed reward tokens a user can claim from a pool.
1743   ///
1744   /// @param _account The account to get the unclaimed balance of.
1745   /// @param _poolId  The pool to check for unclaimed rewards.
1746   ///
1747   /// @return the amount of unclaimed reward tokens a user has in a pool.
1748   function getStakeTotalUnclaimed(address _account, uint256 _poolId) external view returns (uint256) {
1749     Stake.Data storage _stake = _stakes[_account][_poolId];
1750     return _stake.getUpdatedTotalUnclaimed(_pools.get(_poolId), _ctx);
1751   }
1752 
1753   /// @dev Gets address accumulated power.
1754   ///
1755   /// @param _referral The referral account to get accumulated power.
1756   /// @param _poolId  The pool to check for accumulated referral power.
1757   ///
1758   /// @return the amount of accumulated power a user has in a pool.
1759   function getAccumulatedReferralPower(address _referral, uint256 _poolId) external view returns (uint256) {
1760     ReferralPower.Data storage _referralPower = _referralPowers[_referral][_poolId];
1761     return _referralPower.getUpdatedTotalReferralPower(_pools.get(_poolId), _ctx);
1762   }
1763 
1764   /// @dev Gets address of referral address by index
1765   ///
1766   /// @param _poolId The pool to get referral address
1767   /// @param _referralIndex the index to get referral address
1768   ///
1769   /// @return the referral address in a specifgic pool with index. 
1770   function getPoolReferral(uint256 _poolId, uint256 _referralIndex) external view returns (address) {
1771     return referralList[_poolId][_referralIndex];
1772   }
1773 
1774   /// @dev Gets addressed of referee referred by a referral
1775   ///
1776   /// @param _poolId The pool to get referral address
1777   /// @param referral the address of referral to find all its referees
1778   ///
1779   /// @return the address array of referees
1780   function getPoolreferee(uint256 _poolId, address referral) external view returns(address[] memory) {
1781     return myreferees[_poolId][referral];
1782   }
1783 
1784   /// @dev To get withdrawable amount that has passed lockup period of a pool
1785   function getWithdrawableAmount(uint256 _poolId, address _account) public view returns (uint256) {
1786     Pool.Data storage _pool = _pools.get(_poolId);
1787     Stake.Data storage _stake = _stakes[_account][_poolId];
1788     uint256 withdrawAble = 0;
1789 
1790     for (uint32 i = 0; i < _stake.deposits.length; i++) {
1791       uint256 unlockTimesteamp = _stake.deposits[i].timestamp.div(SECONDS_PER_DAY).mul(SECONDS_PER_DAY).add(_pool.lockUpPeriodInSecs);
1792 
1793       if (block.timestamp >= unlockTimesteamp) {
1794         withdrawAble = withdrawAble + _stake.deposits[i].amount;
1795       }
1796     }
1797 
1798     return withdrawAble;
1799   }
1800 
1801   /// @dev To get a pool lockup period in seconds
1802   function getPoolLockPeriodInSecs(uint256 _poolId) external view returns(uint256) {
1803     Pool.Data storage _pool = _pools.get(_poolId); 
1804     return _pool.lockUpPeriodInSecs;
1805   }
1806 
1807   /// @dev To get a reward vesting period in seconds
1808   function getPoolVestingDurationInSecs(uint256 _poolId) external view returns(uint256) {
1809     Pool.Data storage _pool = _pools.get(_poolId); 
1810     return _pool.vestingDurationInSecs;
1811   }
1812 
1813   /// @dev get all user current deposits
1814   function getUserDeposits(uint256 _poolId, address _account) public view returns(Deposit[] memory) {
1815     Stake.Data storage _stake = _stakes[_account][_poolId];
1816     Deposit[] memory deposits = _stake.deposits;
1817     return deposits;
1818   }
1819 
1820   /// @dev Updates all of the pools.
1821   function _updatePools() internal {
1822     for (uint256 _poolId = 0; _poolId < _pools.length(); _poolId++) {
1823       Pool.Data storage _pool = _pools.get(_poolId);
1824       _pool.update(_ctx);
1825     }
1826   }
1827 
1828   /// @dev Stakes tokens into a pool.
1829   ///
1830   /// The pool and stake MUST be updated before calling this function.
1831   ///
1832   /// @param _poolId        the pool to deposit tokens into.
1833   /// @param _depositAmount the amount of tokens to deposit.
1834   /// @param _referral      the address of referral.
1835   function _deposit(uint256 _poolId, uint256 _depositAmount, address _referral) internal {
1836     Pool.Data storage _pool = _pools.get(_poolId);
1837     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1838 
1839     _pool.totalDeposited = _pool.totalDeposited.add(_depositAmount);
1840 
1841     Deposit memory userDeposit = Deposit(_depositAmount, block.timestamp);
1842     _stake.deposits.push(userDeposit);
1843     _stake.totalDeposited = _stake.totalDeposited.add(_depositAmount);
1844 
1845     if (_pool.onReferralBonus && _referral != address(0)) {
1846       require(msg.sender != _referral, "Can not referral yourself");
1847       ReferralPower.Data storage _referralPower = _referralPowers[_referral][_poolId];
1848       _pool.totalReferralAmount = _pool.totalReferralAmount.add(_depositAmount);
1849       _referralPower.totalDeposited = _referralPower.totalDeposited.add(_depositAmount);
1850     }
1851 
1852     _pool.token.safeTransferFrom(msg.sender, address(this), _depositAmount);
1853 
1854     emit TokensDeposited(msg.sender, _poolId, _depositAmount);
1855   }
1856 
1857   /// @dev Withdraws staked tokens from a pool.
1858   ///
1859   /// The pool and stake MUST be updated before calling this function.
1860   ///
1861   /// @param _poolId          The pool to withdraw staked tokens from.
1862   /// @param _withdrawAmount  The number of tokens to withdraw.
1863   /// @param _referral        The referral's address for reducing referral power accumulation.
1864   function _withdraw(uint256 _poolId, uint256 _withdrawAmount, address _referral) internal {
1865     Pool.Data storage _pool = _pools.get(_poolId);
1866     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1867 
1868     _pool.totalDeposited = _pool.totalDeposited.sub(_withdrawAmount);
1869     _stake.totalDeposited = _stake.totalDeposited.sub(_withdrawAmount);
1870 
1871     // for lockup period
1872     uint256 remainingAmount = _withdrawAmount;
1873     for (uint256 i = 0; i < _stake.deposits.length; i++) {
1874       if (remainingAmount == 0) {
1875         break;
1876       }
1877       uint256 depositAmount = _stake.deposits[i].amount;
1878       uint256 unstakeAmount =  depositAmount > remainingAmount
1879                               ? remainingAmount : depositAmount;
1880       _stake.deposits[i].amount = depositAmount.sub(unstakeAmount);
1881       remainingAmount = remainingAmount.sub(unstakeAmount);
1882     }
1883 
1884     // for referral
1885     if (_pool.onReferralBonus && _referral != address(0)) {
1886       ReferralPower.Data storage _referralPower = _referralPowers[_referral][_poolId];
1887       _pool.totalReferralAmount = _pool.totalReferralAmount.sub(_withdrawAmount);
1888       _referralPower.totalDeposited = _referralPower.totalDeposited.sub(_withdrawAmount);
1889     }
1890 
1891     _pool.token.safeTransfer(msg.sender, _withdrawAmount);
1892 
1893     emit TokensWithdrawn(msg.sender, _poolId, _withdrawAmount);
1894   }
1895 
1896   /// @dev Claims all rewarded tokens from a pool.
1897   ///
1898   /// The pool and stake MUST be updated before calling this function.
1899   ///
1900   /// @param _poolId The pool to claim rewards from.
1901   ///
1902   /// @notice use this function to claim the tokens from a corresponding pool by ID.
1903   function _claim(uint256 _poolId) internal {
1904     require(!pause, "StakingPools: emergency pause enabled");
1905 
1906     Pool.Data storage _pool = _pools.get(_poolId);
1907     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1908 
1909     uint256 _claimAmount = _stake.totalUnclaimed;
1910     _stake.totalUnclaimed = 0;
1911 
1912     if(_pool.needVesting){
1913       reward.approve(address(rewardVesting),uint(-1));
1914       rewardVesting.addEarning(msg.sender, _claimAmount, _pool.vestingDurationInSecs);
1915     } else {
1916       reward.safeTransfer(msg.sender, _claimAmount);
1917     }
1918 
1919     emit TokensClaimed(msg.sender, _poolId, _claimAmount);
1920   }
1921 
1922   /// @dev Updates the reward vesting contract
1923   ///
1924   /// @param _rewardVesting the new reward vesting contract
1925   function setRewardVesting(IRewardVesting _rewardVesting) external {
1926     require(pause && (msg.sender == governance || msg.sender == sentinel), "StakingPools: not paused, or not governance or sentinel");
1927     rewardVesting = _rewardVesting;
1928     emit RewardVestingUpdated(_rewardVesting);
1929   }
1930 
1931   /// @dev Sets the address of the sentinel
1932   ///
1933   /// @param _sentinel address of the new sentinel
1934   function setSentinel(address _sentinel) external onlyGovernance {
1935       require(_sentinel != address(0), "StakingPools: sentinel address cannot be 0x0.");
1936       sentinel = _sentinel;
1937       emit SentinelUpdated(_sentinel);
1938   }
1939 
1940   /// @dev Sets if the contract should enter emergency pause mode.
1941   ///
1942   /// There are 2 main reasons to pause:
1943   ///     1. Need to shut down claims in case of any issues in the reward vesting contract
1944   ///     2. Need to migrate to a new reward vesting contract
1945   ///
1946   /// While this contract is paused, claim is disabled
1947   ///
1948   /// @param _pause if the contract should enter emergency pause mode.
1949   function setPause(bool _pause) external {
1950       require(msg.sender == governance || msg.sender == sentinel, "StakingPools: !(gov || sentinel)");
1951       pause = _pause;
1952       emit PauseUpdated(_pause);
1953   }
1954 
1955   /// @dev To update a pool's lockup period.
1956   ///
1957   /// Update a pool's lockup period will affect all current deposits. i.e. if set lock up period to 0, will
1958   /// unlock all current desposits.
1959   function setPoolLockUpPeriodInSecs(uint256 _poolId, uint256 _newLockUpPeriodInSecs) external  {
1960     require(msg.sender == governance || msg.sender == sentinel, "StakingPools: !(gov || sentinel)");
1961     Pool.Data storage _pool = _pools.get(_poolId); 
1962     uint256 oldLockUpPeriodInSecs = _pool.lockUpPeriodInSecs;
1963     _pool.lockUpPeriodInSecs = _newLockUpPeriodInSecs;
1964     emit LockUpPeriodInSecsUpdated(_poolId, oldLockUpPeriodInSecs, _pool.lockUpPeriodInSecs);
1965   }
1966 
1967 
1968   /// @dev to change a pool's reward vesting period.
1969   ///
1970   /// Change a pool's reward vesting period. Reward already in vesting schedule won't be affected by this update.
1971   function setPoolVestingDurationInSecs(uint256 _poolId, uint256 _newVestingDurationInSecs) external {
1972     require(msg.sender == governance || msg.sender == sentinel, "StakingPools: !(gov || sentinel)");
1973     Pool.Data storage _pool = _pools.get(_poolId); 
1974     uint256 oldVestingDurationInSecs = _pool.vestingDurationInSecs;
1975     _pool.vestingDurationInSecs = _newVestingDurationInSecs;
1976     emit VestingDurationInSecsUpdated(_poolId, oldVestingDurationInSecs, _pool.vestingDurationInSecs);
1977   }
1978 
1979   /// @dev To start referral power calculation for a pool, referral power caculation won't turn on if the onReferralBonus is not set
1980   ///
1981   /// @param _poolId the pool to start referral power accumulation
1982   function startReferralBonus(uint256 _poolId) external {
1983       require(msg.sender == governance || msg.sender == sentinel, "startReferralBonus: !(gov || sentinel)");
1984       Pool.Data storage _pool = _pools.get(_poolId);
1985       require(_pool.onReferralBonus == false, "referral bonus already on");
1986       _pool.onReferralBonus = true;
1987       emit StartPoolReferralCompetition(_poolId);
1988   }
1989 
1990   /// @dev To stop referral power calculation for a pool, referral power caculation won't turn on if the onReferralBonus is not set
1991   ///
1992   /// @param _poolId the pool to stop referral power accumulation
1993   function stoptReferralBonus(uint256 _poolId) external {
1994       require(msg.sender == governance || msg.sender == sentinel, "stoptReferralBonus: !(gov || sentinel)");
1995       Pool.Data storage _pool = _pools.get(_poolId);
1996       require(_pool.onReferralBonus == true, "referral not turned on");
1997       _pool.onReferralBonus = false;
1998       emit StopPoolReferralCompetition(_poolId);
1999   }
2000 
2001   function isPoolReferralProgramOn(uint256 _poolId) external view returns (bool) {
2002       Pool.Data storage _pool = _pools.get(_poolId);
2003       return _pool.onReferralBonus;
2004   }
2005 }