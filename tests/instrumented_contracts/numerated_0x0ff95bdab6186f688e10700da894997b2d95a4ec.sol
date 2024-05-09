1 // Sources flattened with hardhat v2.2.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1-solc-0.7-2
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.7.0;
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
84 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1-solc-0.7-2
85 
86 
87 
88 pragma solidity ^0.7.0;
89 
90 /**
91  * @dev Wrappers over Solidity's arithmetic operations with added overflow
92  * checks.
93  *
94  * Arithmetic operations in Solidity wrap on overflow. This can easily result
95  * in bugs, because programmers usually assume that an overflow raises an
96  * error, which is the standard behavior in high level programming languages.
97  * `SafeMath` restores this intuition by reverting the transaction when an
98  * operation overflows.
99  *
100  * Using this library instead of the unchecked operations eliminates an entire
101  * class of bugs, so it's recommended to use it always.
102  */
103 library SafeMath {
104     /**
105      * @dev Returns the addition of two unsigned integers, with an overflow flag.
106      *
107      * _Available since v3.4._
108      */
109     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
110         uint256 c = a + b;
111         if (c < a) return (false, 0);
112         return (true, c);
113     }
114 
115     /**
116      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
117      *
118      * _Available since v3.4._
119      */
120     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
121         if (b > a) return (false, 0);
122         return (true, a - b);
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
127      *
128      * _Available since v3.4._
129      */
130     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
132         // benefit is lost if 'b' is also tested.
133         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
134         if (a == 0) return (true, 0);
135         uint256 c = a * b;
136         if (c / a != b) return (false, 0);
137         return (true, c);
138     }
139 
140     /**
141      * @dev Returns the division of two unsigned integers, with a division by zero flag.
142      *
143      * _Available since v3.4._
144      */
145     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         if (b == 0) return (false, 0);
147         return (true, a / b);
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
152      *
153      * _Available since v3.4._
154      */
155     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
156         if (b == 0) return (false, 0);
157         return (true, a % b);
158     }
159 
160     /**
161      * @dev Returns the addition of two unsigned integers, reverting on
162      * overflow.
163      *
164      * Counterpart to Solidity's `+` operator.
165      *
166      * Requirements:
167      *
168      * - Addition cannot overflow.
169      */
170     function add(uint256 a, uint256 b) internal pure returns (uint256) {
171         uint256 c = a + b;
172         require(c >= a, "SafeMath: addition overflow");
173         return c;
174     }
175 
176     /**
177      * @dev Returns the subtraction of two unsigned integers, reverting on
178      * overflow (when the result is negative).
179      *
180      * Counterpart to Solidity's `-` operator.
181      *
182      * Requirements:
183      *
184      * - Subtraction cannot overflow.
185      */
186     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
187         require(b <= a, "SafeMath: subtraction overflow");
188         return a - b;
189     }
190 
191     /**
192      * @dev Returns the multiplication of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `*` operator.
196      *
197      * Requirements:
198      *
199      * - Multiplication cannot overflow.
200      */
201     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202         if (a == 0) return 0;
203         uint256 c = a * b;
204         require(c / a == b, "SafeMath: multiplication overflow");
205         return c;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers, reverting on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b) internal pure returns (uint256) {
221         require(b > 0, "SafeMath: division by zero");
222         return a / b;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * reverting when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         require(b > 0, "SafeMath: modulo by zero");
239         return a % b;
240     }
241 
242     /**
243      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
244      * overflow (when the result is negative).
245      *
246      * CAUTION: This function is deprecated because it requires allocating memory for the error
247      * message unnecessarily. For custom revert reasons use {trySub}.
248      *
249      * Counterpart to Solidity's `-` operator.
250      *
251      * Requirements:
252      *
253      * - Subtraction cannot overflow.
254      */
255     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b <= a, errorMessage);
257         return a - b;
258     }
259 
260     /**
261      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
262      * division by zero. The result is rounded towards zero.
263      *
264      * CAUTION: This function is deprecated because it requires allocating memory for the error
265      * message unnecessarily. For custom revert reasons use {tryDiv}.
266      *
267      * Counterpart to Solidity's `/` operator. Note: this function uses a
268      * `revert` opcode (which leaves remaining gas untouched) while Solidity
269      * uses an invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      *
273      * - The divisor cannot be zero.
274      */
275     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         require(b > 0, errorMessage);
277         return a / b;
278     }
279 
280     /**
281      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
282      * reverting with custom message when dividing by zero.
283      *
284      * CAUTION: This function is deprecated because it requires allocating memory for the error
285      * message unnecessarily. For custom revert reasons use {tryMod}.
286      *
287      * Counterpart to Solidity's `%` operator. This function uses a `revert`
288      * opcode (which leaves remaining gas untouched) while Solidity uses an
289      * invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296         require(b > 0, errorMessage);
297         return a % b;
298     }
299 }
300 
301 
302 // File @openzeppelin/contracts/utils/ReentrancyGuard.sol@v3.4.1-solc-0.7-2
303 
304 
305 
306 pragma solidity ^0.7.0;
307 
308 /**
309  * @dev Contract module that helps prevent reentrant calls to a function.
310  *
311  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
312  * available, which can be applied to functions to make sure there are no nested
313  * (reentrant) calls to them.
314  *
315  * Note that because there is a single `nonReentrant` guard, functions marked as
316  * `nonReentrant` may not call one another. This can be worked around by making
317  * those functions `private`, and then adding `external` `nonReentrant` entry
318  * points to them.
319  *
320  * TIP: If you would like to learn more about reentrancy and alternative ways
321  * to protect against it, check out our blog post
322  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
323  */
324 abstract contract ReentrancyGuard {
325     // Booleans are more expensive than uint256 or any type that takes up a full
326     // word because each write operation emits an extra SLOAD to first read the
327     // slot's contents, replace the bits taken up by the boolean, and then write
328     // back. This is the compiler's defense against contract upgrades and
329     // pointer aliasing, and it cannot be disabled.
330 
331     // The values being non-zero value makes deployment a bit more expensive,
332     // but in exchange the refund on every call to nonReentrant will be lower in
333     // amount. Since refunds are capped to a percentage of the total
334     // transaction's gas, it is best to keep them low in cases like this one, to
335     // increase the likelihood of the full refund coming into effect.
336     uint256 private constant _NOT_ENTERED = 1;
337     uint256 private constant _ENTERED = 2;
338 
339     uint256 private _status;
340 
341     constructor () {
342         _status = _NOT_ENTERED;
343     }
344 
345     /**
346      * @dev Prevents a contract from calling itself, directly or indirectly.
347      * Calling a `nonReentrant` function from another `nonReentrant`
348      * function is not supported. It is possible to prevent this from happening
349      * by making the `nonReentrant` function external, and make it call a
350      * `private` function that does the actual work.
351      */
352     modifier nonReentrant() {
353         // On the first call to nonReentrant, _notEntered will be true
354         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
355 
356         // Any calls to nonReentrant after this point will fail
357         _status = _ENTERED;
358 
359         _;
360 
361         // By storing the original value once again, a refund is triggered (see
362         // https://eips.ethereum.org/EIPS/eip-2200)
363         _status = _NOT_ENTERED;
364     }
365 }
366 
367 
368 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1-solc-0.7-2
369 
370 
371 
372 pragma solidity >=0.6.0 <0.8.0;
373 
374 /*
375  * @dev Provides information about the current execution context, including the
376  * sender of the transaction and its data. While these are generally available
377  * via msg.sender and msg.data, they should not be accessed in such a direct
378  * manner, since when dealing with GSN meta-transactions the account sending and
379  * paying for execution may not be the actual sender (as far as an application
380  * is concerned).
381  *
382  * This contract is only required for intermediate, library-like contracts.
383  */
384 abstract contract Context {
385     function _msgSender() internal view virtual returns (address payable) {
386         return msg.sender;
387     }
388 
389     function _msgData() internal view virtual returns (bytes memory) {
390         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
391         return msg.data;
392     }
393 }
394 
395 
396 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1-solc-0.7-2
397 
398 
399 
400 pragma solidity ^0.7.0;
401 
402 /**
403  * @dev Contract module which provides a basic access control mechanism, where
404  * there is an account (an owner) that can be granted exclusive access to
405  * specific functions.
406  *
407  * By default, the owner account will be the one that deploys the contract. This
408  * can later be changed with {transferOwnership}.
409  *
410  * This module is used through inheritance. It will make available the modifier
411  * `onlyOwner`, which can be applied to your functions to restrict their use to
412  * the owner.
413  */
414 abstract contract Ownable is Context {
415     address private _owner;
416 
417     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
418 
419     /**
420      * @dev Initializes the contract setting the deployer as the initial owner.
421      */
422     constructor () {
423         address msgSender = _msgSender();
424         _owner = msgSender;
425         emit OwnershipTransferred(address(0), msgSender);
426     }
427 
428     /**
429      * @dev Returns the address of the current owner.
430      */
431     function owner() public view virtual returns (address) {
432         return _owner;
433     }
434 
435     /**
436      * @dev Throws if called by any account other than the owner.
437      */
438     modifier onlyOwner() {
439         require(owner() == _msgSender(), "Ownable: caller is not the owner");
440         _;
441     }
442 
443     /**
444      * @dev Leaves the contract without owner. It will not be possible to call
445      * `onlyOwner` functions anymore. Can only be called by the current owner.
446      *
447      * NOTE: Renouncing ownership will leave the contract without an owner,
448      * thereby removing any functionality that is only available to the owner.
449      */
450     function renounceOwnership() public virtual onlyOwner {
451         emit OwnershipTransferred(_owner, address(0));
452         _owner = address(0);
453     }
454 
455     /**
456      * @dev Transfers ownership of the contract to a new account (`newOwner`).
457      * Can only be called by the current owner.
458      */
459     function transferOwnership(address newOwner) public virtual onlyOwner {
460         require(newOwner != address(0), "Ownable: new owner is the zero address");
461         emit OwnershipTransferred(_owner, newOwner);
462         _owner = newOwner;
463     }
464 }
465 
466 
467 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1-solc-0.7-2
468 
469 
470 
471 pragma solidity ^0.7.0;
472 
473 /**
474  * @dev Collection of functions related to the address type
475  */
476 library Address {
477     /**
478      * @dev Returns true if `account` is a contract.
479      *
480      * [IMPORTANT]
481      * ====
482      * It is unsafe to assume that an address for which this function returns
483      * false is an externally-owned account (EOA) and not a contract.
484      *
485      * Among others, `isContract` will return false for the following
486      * types of addresses:
487      *
488      *  - an externally-owned account
489      *  - a contract in construction
490      *  - an address where a contract will be created
491      *  - an address where a contract lived, but was destroyed
492      * ====
493      */
494     function isContract(address account) internal view returns (bool) {
495         // This method relies on extcodesize, which returns 0 for contracts in
496         // construction, since the code is only stored at the end of the
497         // constructor execution.
498 
499         uint256 size;
500         // solhint-disable-next-line no-inline-assembly
501         assembly { size := extcodesize(account) }
502         return size > 0;
503     }
504 
505     /**
506      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
507      * `recipient`, forwarding all available gas and reverting on errors.
508      *
509      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
510      * of certain opcodes, possibly making contracts go over the 2300 gas limit
511      * imposed by `transfer`, making them unable to receive funds via
512      * `transfer`. {sendValue} removes this limitation.
513      *
514      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
515      *
516      * IMPORTANT: because control is transferred to `recipient`, care must be
517      * taken to not create reentrancy vulnerabilities. Consider using
518      * {ReentrancyGuard} or the
519      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
520      */
521     function sendValue(address payable recipient, uint256 amount) internal {
522         require(address(this).balance >= amount, "Address: insufficient balance");
523 
524         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
525         (bool success, ) = recipient.call{ value: amount }("");
526         require(success, "Address: unable to send value, recipient may have reverted");
527     }
528 
529     /**
530      * @dev Performs a Solidity function call using a low level `call`. A
531      * plain`call` is an unsafe replacement for a function call: use this
532      * function instead.
533      *
534      * If `target` reverts with a revert reason, it is bubbled up by this
535      * function (like regular Solidity function calls).
536      *
537      * Returns the raw returned data. To convert to the expected return value,
538      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
539      *
540      * Requirements:
541      *
542      * - `target` must be a contract.
543      * - calling `target` with `data` must not revert.
544      *
545      * _Available since v3.1._
546      */
547     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
548       return functionCall(target, data, "Address: low-level call failed");
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
553      * `errorMessage` as a fallback revert reason when `target` reverts.
554      *
555      * _Available since v3.1._
556      */
557     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
558         return functionCallWithValue(target, data, 0, errorMessage);
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
563      * but also transferring `value` wei to `target`.
564      *
565      * Requirements:
566      *
567      * - the calling contract must have an ETH balance of at least `value`.
568      * - the called Solidity function must be `payable`.
569      *
570      * _Available since v3.1._
571      */
572     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
573         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
578      * with `errorMessage` as a fallback revert reason when `target` reverts.
579      *
580      * _Available since v3.1._
581      */
582     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
583         require(address(this).balance >= value, "Address: insufficient balance for call");
584         require(isContract(target), "Address: call to non-contract");
585 
586         // solhint-disable-next-line avoid-low-level-calls
587         (bool success, bytes memory returndata) = target.call{ value: value }(data);
588         return _verifyCallResult(success, returndata, errorMessage);
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
593      * but performing a static call.
594      *
595      * _Available since v3.3._
596      */
597     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
598         return functionStaticCall(target, data, "Address: low-level static call failed");
599     }
600 
601     /**
602      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
603      * but performing a static call.
604      *
605      * _Available since v3.3._
606      */
607     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
608         require(isContract(target), "Address: static call to non-contract");
609 
610         // solhint-disable-next-line avoid-low-level-calls
611         (bool success, bytes memory returndata) = target.staticcall(data);
612         return _verifyCallResult(success, returndata, errorMessage);
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
617      * but performing a delegate call.
618      *
619      * _Available since v3.4._
620      */
621     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
622         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
627      * but performing a delegate call.
628      *
629      * _Available since v3.4._
630      */
631     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
632         require(isContract(target), "Address: delegate call to non-contract");
633 
634         // solhint-disable-next-line avoid-low-level-calls
635         (bool success, bytes memory returndata) = target.delegatecall(data);
636         return _verifyCallResult(success, returndata, errorMessage);
637     }
638 
639     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
640         if (success) {
641             return returndata;
642         } else {
643             // Look for revert reason and bubble it up if present
644             if (returndata.length > 0) {
645                 // The easiest way to bubble the revert reason is using memory via assembly
646 
647                 // solhint-disable-next-line no-inline-assembly
648                 assembly {
649                     let returndata_size := mload(returndata)
650                     revert(add(32, returndata), returndata_size)
651                 }
652             } else {
653                 revert(errorMessage);
654             }
655         }
656     }
657 }
658 
659 
660 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.1-solc-0.7-2
661 
662 
663 
664 pragma solidity ^0.7.0;
665 
666 
667 
668 /**
669  * @title SafeERC20
670  * @dev Wrappers around ERC20 operations that throw on failure (when the token
671  * contract returns false). Tokens that return no value (and instead revert or
672  * throw on failure) are also supported, non-reverting calls are assumed to be
673  * successful.
674  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
675  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
676  */
677 library SafeERC20 {
678     using SafeMath for uint256;
679     using Address for address;
680 
681     function safeTransfer(IERC20 token, address to, uint256 value) internal {
682         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
683     }
684 
685     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
686         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
687     }
688 
689     /**
690      * @dev Deprecated. This function has issues similar to the ones found in
691      * {IERC20-approve}, and its usage is discouraged.
692      *
693      * Whenever possible, use {safeIncreaseAllowance} and
694      * {safeDecreaseAllowance} instead.
695      */
696     function safeApprove(IERC20 token, address spender, uint256 value) internal {
697         // safeApprove should only be called when setting an initial allowance,
698         // or when resetting it to zero. To increase and decrease it, use
699         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
700         // solhint-disable-next-line max-line-length
701         require((value == 0) || (token.allowance(address(this), spender) == 0),
702             "SafeERC20: approve from non-zero to non-zero allowance"
703         );
704         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
705     }
706 
707     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
708         uint256 newAllowance = token.allowance(address(this), spender).add(value);
709         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
710     }
711 
712     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
713         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
714         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
715     }
716 
717     /**
718      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
719      * on the return value: the return value is optional (but if data is returned, it must not be false).
720      * @param token The token targeted by the call.
721      * @param data The call data (encoded using abi.encode or one of its variants).
722      */
723     function _callOptionalReturn(IERC20 token, bytes memory data) private {
724         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
725         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
726         // the target address contains contract code and also asserts for success in the low-level call.
727 
728         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
729         if (returndata.length > 0) { // Return data is optional
730             // solhint-disable-next-line max-line-length
731             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
732         }
733     }
734 }
735 
736 
737 // File contracts/Staking.sol
738 
739 
740 pragma solidity >=0.6.0 <0.8.0;
741 
742 
743 
744 
745 
746 contract Staking is ReentrancyGuard, Ownable {
747     using SafeMath for uint256;
748     using SafeERC20 for IERC20;
749     using SafeERC20 for IERC20;
750 
751     uint128 private constant BASE_MULTIPLIER = uint128(1 * 10**18);
752 
753     // timestamp for the epoch 1
754     // everything before that is considered epoch 0 which won't have a reward but allows for the initial stake
755     uint256 public epoch1Start;
756 
757     // duration of each epoch
758     uint256 public epochDuration;
759 
760     //allowed contracts to call deposit for function
761     mapping(address => bool) public allowedYieldFarms;
762 
763     // community vault address
764     address public communityVault;
765 
766     // holds the current balance of the user for each token
767     mapping(address => mapping(address => uint256)) private balances;
768 
769     struct Pool {
770         uint256 size;
771         bool set;
772     }
773 
774     // for each token, we store the total pool size
775     mapping(address => mapping(uint256 => Pool)) private poolSize;
776 
777     // a checkpoint of the valid balance of a user for an epoch
778     struct Checkpoint {
779         uint128 epochId;
780         uint128 multiplier;
781         uint256 startBalance;
782         uint256 newDeposits;
783     }
784 
785     // balanceCheckpoints[user][token][]
786     mapping(address => mapping(address => Checkpoint[]))
787         private balanceCheckpoints;
788 
789     mapping(address => uint128) private lastWithdrawEpochId;
790 
791     event Deposit(
792         address indexed user,
793         address indexed tokenAddress,
794         uint256 amount
795     );
796     event Withdraw(
797         address indexed user,
798         address indexed tokenAddress,
799         uint256 amount
800     );
801     event ManualEpochInit(
802         address indexed caller,
803         uint128 indexed epochId,
804         address[] tokens
805     );
806     event EmergencyWithdraw(
807         address indexed user,
808         address indexed tokenAddress,
809         uint256 amount
810     );
811 
812     constructor(
813         uint256 _epoch1Start,
814         uint256 _epochDuration,
815         address _communityVault
816     ) public {
817         epoch1Start = _epoch1Start;
818         epochDuration = _epochDuration;
819         communityVault = _communityVault;
820     }
821 
822     /*
823      * Stores `amount` of `tokenAddress` tokens for the `user` into the vault
824      */
825     function deposit(address tokenAddress, uint256 amount) public nonReentrant {
826         IERC20 token = IERC20(tokenAddress);
827         uint256 allowance = token.allowance(msg.sender, address(this));
828         require(allowance >= amount, "Staking: Token allowance too small");
829         require(amount > 0, "Staking: Amount must be > 0");
830         balances[msg.sender][tokenAddress] = balances[msg.sender][tokenAddress]
831             .add(amount);
832         token.safeTransferFrom(msg.sender, address(this), amount);
833         _deposit(token, msg.sender, amount);
834     }
835 
836     function depositFor(
837         address tokenAddress,
838         address userAddress,
839         uint256 amount
840     ) external nonReentrant {
841         require(
842             allowedYieldFarms[msg.sender],
843             "Staking: Calling this function not allowed."
844         );
845         IERC20 token = IERC20(tokenAddress);
846         uint256 allowance = token.allowance(communityVault, address(this));
847         require(allowance >= amount, "Staking: Token allowance too small");
848         require(amount > 0, "Staking: Amount must be > 0");
849         balances[userAddress][tokenAddress] = balances[userAddress][
850             tokenAddress
851         ]
852             .add(amount);
853         token.safeTransferFrom(communityVault, address(this), amount);
854         _deposit(token, userAddress, amount);
855     }
856 
857     function _deposit(
858         IERC20 token,
859         address userAddress,
860         uint256 amount
861     ) internal {
862         address tokenAddress = address(token);
863 
864         // epoch logic
865         uint128 currentEpoch = getCurrentEpoch();
866         uint128 currentMultiplier = currentEpochMultiplier();
867 
868         if (!epochIsInitialized(tokenAddress, currentEpoch)) {
869             address[] memory tokens = new address[](1);
870             tokens[0] = tokenAddress;
871             manualEpochInit(tokens, currentEpoch);
872         }
873 
874         // update the next epoch pool size
875         Pool storage pNextEpoch = poolSize[tokenAddress][currentEpoch + 1];
876         pNextEpoch.size = token.balanceOf(address(this));
877         pNextEpoch.set = true;
878 
879         Checkpoint[] storage checkpoints =
880             balanceCheckpoints[userAddress][tokenAddress];
881 
882         uint256 balanceBefore =
883             getEpochUserBalance(userAddress, tokenAddress, currentEpoch);
884 
885         // if there's no checkpoint yet, it means the user didn't have any activity
886         // we want to store checkpoints both for the current epoch and next epoch because
887         // if a user does a withdraw, the current epoch can also be modified and
888         // we don't want to insert another checkpoint in the middle of the array as that could be expensive
889         if (checkpoints.length == 0) {
890             checkpoints.push(
891                 Checkpoint(currentEpoch, currentMultiplier, 0, amount)
892             );
893 
894             // next epoch => multiplier is 1, epoch deposits is 0
895             checkpoints.push(
896                 Checkpoint(currentEpoch + 1, BASE_MULTIPLIER, amount, 0)
897             );
898         } else {
899             uint256 last = checkpoints.length - 1;
900 
901             // the last action happened in an older epoch (e.g. a deposit in epoch 3, current epoch is >=5)
902             if (checkpoints[last].epochId < currentEpoch) {
903                 uint128 multiplier =
904                     computeNewMultiplier(
905                         getCheckpointBalance(checkpoints[last]),
906                         BASE_MULTIPLIER,
907                         amount,
908                         currentMultiplier
909                     );
910                 checkpoints.push(
911                     Checkpoint(
912                         currentEpoch,
913                         multiplier,
914                         getCheckpointBalance(checkpoints[last]),
915                         amount
916                     )
917                 );
918                 uint256 startBal = balances[userAddress][tokenAddress];
919                 checkpoints.push(
920                     Checkpoint(currentEpoch + 1, BASE_MULTIPLIER, startBal, 0)
921                 );
922             }
923             // the last action happened in the previous epoch
924             else if (checkpoints[last].epochId == currentEpoch) {
925                 checkpoints[last].multiplier = computeNewMultiplier(
926                     getCheckpointBalance(checkpoints[last]),
927                     checkpoints[last].multiplier,
928                     amount,
929                     currentMultiplier
930                 );
931                 checkpoints[last].newDeposits = checkpoints[last]
932                     .newDeposits
933                     .add(amount);
934 
935                 checkpoints.push(
936                     Checkpoint(
937                         currentEpoch + 1,
938                         BASE_MULTIPLIER,
939                         balances[userAddress][tokenAddress],
940                         0
941                     )
942                 );
943             }
944             // the last action happened in the current epoch
945             else {
946                 if (
947                     last >= 1 && checkpoints[last - 1].epochId == currentEpoch
948                 ) {
949                     checkpoints[last - 1].multiplier = computeNewMultiplier(
950                         getCheckpointBalance(checkpoints[last - 1]),
951                         checkpoints[last - 1].multiplier,
952                         amount,
953                         currentMultiplier
954                     );
955                     checkpoints[last - 1].newDeposits = checkpoints[last - 1]
956                         .newDeposits
957                         .add(amount);
958                 }
959 
960                 checkpoints[last].startBalance = balances[userAddress][
961                     tokenAddress
962                 ];
963             }
964         }
965 
966         uint256 balanceAfter =
967             getEpochUserBalance(userAddress, tokenAddress, currentEpoch);
968 
969         poolSize[tokenAddress][currentEpoch].size = poolSize[tokenAddress][
970             currentEpoch
971         ]
972             .size
973             .add(balanceAfter.sub(balanceBefore));
974 
975         emit Deposit(userAddress, tokenAddress, amount);
976     }
977 
978     /*
979      * Removes the deposit of the user and sends the amount of `tokenAddress` back to the `user`
980      */
981     function withdraw(address tokenAddress, uint256 amount)
982         public
983         nonReentrant
984     {
985         require(
986             balances[msg.sender][tokenAddress] >= amount,
987             "Staking: balance too small"
988         );
989 
990         balances[msg.sender][tokenAddress] = balances[msg.sender][tokenAddress]
991             .sub(amount);
992 
993         IERC20 token = IERC20(tokenAddress);
994         token.safeTransfer(msg.sender, amount);
995 
996         // epoch logic
997         uint128 currentEpoch = getCurrentEpoch();
998 
999         lastWithdrawEpochId[tokenAddress] = currentEpoch;
1000 
1001         if (!epochIsInitialized(tokenAddress, currentEpoch)) {
1002             address[] memory tokens = new address[](1);
1003             tokens[0] = tokenAddress;
1004             manualEpochInit(tokens, currentEpoch);
1005         }
1006 
1007         // update the pool size of the next epoch to its current balance
1008         Pool storage pNextEpoch = poolSize[tokenAddress][currentEpoch + 1];
1009         pNextEpoch.size = token.balanceOf(address(this));
1010         pNextEpoch.set = true;
1011 
1012         Checkpoint[] storage checkpoints =
1013             balanceCheckpoints[msg.sender][tokenAddress];
1014         uint256 last = checkpoints.length - 1;
1015 
1016         // note: it's impossible to have a withdraw and no checkpoints because the balance would be 0 and revert
1017 
1018         // there was a deposit in an older epoch (more than 1 behind [eg: previous 0, now 5]) but no other action since then
1019         if (checkpoints[last].epochId < currentEpoch) {
1020             checkpoints.push(
1021                 Checkpoint(
1022                     currentEpoch,
1023                     BASE_MULTIPLIER,
1024                     balances[msg.sender][tokenAddress],
1025                     0
1026                 )
1027             );
1028 
1029             poolSize[tokenAddress][currentEpoch].size = poolSize[tokenAddress][
1030                 currentEpoch
1031             ]
1032                 .size
1033                 .sub(amount);
1034         }
1035         // there was a deposit in the `epochId - 1` epoch => we have a checkpoint for the current epoch
1036         else if (checkpoints[last].epochId == currentEpoch) {
1037             checkpoints[last].startBalance = balances[msg.sender][tokenAddress];
1038             checkpoints[last].newDeposits = 0;
1039             checkpoints[last].multiplier = BASE_MULTIPLIER;
1040 
1041             poolSize[tokenAddress][currentEpoch].size = poolSize[tokenAddress][
1042                 currentEpoch
1043             ]
1044                 .size
1045                 .sub(amount);
1046         }
1047         // there was a deposit in the current epoch
1048         else {
1049             Checkpoint storage currentEpochCheckpoint = checkpoints[last - 1];
1050 
1051             uint256 balanceBefore =
1052                 getCheckpointEffectiveBalance(currentEpochCheckpoint);
1053 
1054             // in case of withdraw, we have 2 branches:
1055             // 1. the user withdraws less than he added in the current epoch
1056             // 2. the user withdraws more than he added in the current epoch (including 0)
1057             if (amount < currentEpochCheckpoint.newDeposits) {
1058                 uint128 avgDepositMultiplier =
1059                     uint128(
1060                         balanceBefore
1061                             .sub(currentEpochCheckpoint.startBalance)
1062                             .mul(BASE_MULTIPLIER)
1063                             .div(currentEpochCheckpoint.newDeposits)
1064                     );
1065 
1066                 currentEpochCheckpoint.newDeposits = currentEpochCheckpoint
1067                     .newDeposits
1068                     .sub(amount);
1069 
1070                 currentEpochCheckpoint.multiplier = computeNewMultiplier(
1071                     currentEpochCheckpoint.startBalance,
1072                     BASE_MULTIPLIER,
1073                     currentEpochCheckpoint.newDeposits,
1074                     avgDepositMultiplier
1075                 );
1076             } else {
1077                 currentEpochCheckpoint.startBalance = currentEpochCheckpoint
1078                     .startBalance
1079                     .sub(amount.sub(currentEpochCheckpoint.newDeposits));
1080                 currentEpochCheckpoint.newDeposits = 0;
1081                 currentEpochCheckpoint.multiplier = BASE_MULTIPLIER;
1082             }
1083 
1084             uint256 balanceAfter =
1085                 getCheckpointEffectiveBalance(currentEpochCheckpoint);
1086 
1087             poolSize[tokenAddress][currentEpoch].size = poolSize[tokenAddress][
1088                 currentEpoch
1089             ]
1090                 .size
1091                 .sub(balanceBefore.sub(balanceAfter));
1092 
1093             checkpoints[last].startBalance = balances[msg.sender][tokenAddress];
1094         }
1095 
1096         emit Withdraw(msg.sender, tokenAddress, amount);
1097     }
1098 
1099     /*
1100      * manualEpochInit can be used by anyone to initialize an epoch based on the previous one
1101      * This is only applicable if there was no action (deposit/withdraw) in the current epoch.
1102      * Any deposit and withdraw will automatically initialize the current and next epoch.
1103      */
1104     function manualEpochInit(address[] memory tokens, uint128 epochId) public {
1105         require(epochId <= getCurrentEpoch(), "can't init a future epoch");
1106 
1107         for (uint256 i = 0; i < tokens.length; i++) {
1108             Pool storage p = poolSize[tokens[i]][epochId];
1109 
1110             if (epochId == 0) {
1111                 p.size = uint256(0);
1112                 p.set = true;
1113             } else {
1114                 require(
1115                     !epochIsInitialized(tokens[i], epochId),
1116                     "Staking: epoch already initialized"
1117                 );
1118                 require(
1119                     epochIsInitialized(tokens[i], epochId - 1),
1120                     "Staking: previous epoch not initialized"
1121                 );
1122 
1123                 p.size = poolSize[tokens[i]][epochId - 1].size;
1124                 p.set = true;
1125             }
1126         }
1127 
1128         emit ManualEpochInit(msg.sender, epochId, tokens);
1129     }
1130 
1131     function emergencyWithdraw(address tokenAddress) public {
1132         require(
1133             (getCurrentEpoch() - lastWithdrawEpochId[tokenAddress]) >= 10,
1134             "At least 10 epochs must pass without success"
1135         );
1136 
1137         uint256 totalUserBalance = balances[msg.sender][tokenAddress];
1138         require(totalUserBalance > 0, "Amount must be > 0");
1139 
1140         balances[msg.sender][tokenAddress] = 0;
1141 
1142         IERC20 token = IERC20(tokenAddress);
1143         token.safeTransfer(msg.sender, totalUserBalance);
1144 
1145         emit EmergencyWithdraw(msg.sender, tokenAddress, totalUserBalance);
1146     }
1147 
1148     /*
1149      * Returns the valid balance of a user that was taken into consideration in the total pool size for the epoch
1150      * A deposit will only change the next epoch balance.
1151      * A withdraw will decrease the current epoch (and subsequent) balance.
1152      */
1153     function getEpochUserBalance(
1154         address user,
1155         address token,
1156         uint128 epochId
1157     ) public view returns (uint256) {
1158         Checkpoint[] storage checkpoints = balanceCheckpoints[user][token];
1159 
1160         // if there are no checkpoints, it means the user never deposited any tokens, so the balance is 0
1161         if (checkpoints.length == 0 || epochId < checkpoints[0].epochId) {
1162             return 0;
1163         }
1164 
1165         uint256 min = 0;
1166         uint256 max = checkpoints.length - 1;
1167 
1168         // shortcut for blocks newer than the latest checkpoint == current balance
1169         if (epochId >= checkpoints[max].epochId) {
1170             return getCheckpointEffectiveBalance(checkpoints[max]);
1171         }
1172 
1173         // binary search of the value in the array
1174         while (max > min) {
1175             uint256 mid = (max + min + 1) / 2;
1176             if (checkpoints[mid].epochId <= epochId) {
1177                 min = mid;
1178             } else {
1179                 max = mid - 1;
1180             }
1181         }
1182 
1183         return getCheckpointEffectiveBalance(checkpoints[min]);
1184     }
1185 
1186     /*
1187      * Returns the amount of `token` that the `user` has currently staked
1188      */
1189     function balanceOf(address user, address token)
1190         public
1191         view
1192         returns (uint256)
1193     {
1194         return balances[user][token];
1195     }
1196 
1197     /*
1198      * Returns the id of the current epoch derived from block.timestamp
1199      */
1200     function getCurrentEpoch() public view returns (uint128) {
1201         if (block.timestamp < epoch1Start) {
1202             return 0;
1203         }
1204 
1205         return uint128((block.timestamp - epoch1Start) / epochDuration + 1);
1206     }
1207 
1208     /*
1209      * Returns the total amount of `tokenAddress` that was locked from beginning to end of epoch identified by `epochId`
1210      */
1211     function getEpochPoolSize(address tokenAddress, uint128 epochId)
1212         public
1213         view
1214         returns (uint256)
1215     {
1216         // Premises:
1217         // 1. it's impossible to have gaps of uninitialized epochs
1218         // - any deposit or withdraw initialize the current epoch which requires the previous one to be initialized
1219         if (epochIsInitialized(tokenAddress, epochId)) {
1220             return poolSize[tokenAddress][epochId].size;
1221         }
1222 
1223         // epochId not initialized and epoch 0 not initialized => there was never any action on this pool
1224         if (!epochIsInitialized(tokenAddress, 0)) {
1225             return 0;
1226         }
1227 
1228         // epoch 0 is initialized => there was an action at some point but none that initialized the epochId
1229         // which means the current pool size is equal to the current balance of token held by the staking contract
1230         IERC20 token = IERC20(tokenAddress);
1231         return token.balanceOf(address(this));
1232     }
1233 
1234     /*
1235      * Returns the percentage of time left in the current epoch
1236      */
1237     function currentEpochMultiplier() public view returns (uint128) {
1238         uint128 currentEpoch = getCurrentEpoch();
1239         uint256 currentEpochEnd = epoch1Start + currentEpoch * epochDuration;
1240         uint256 timeLeft = currentEpochEnd - block.timestamp;
1241         uint128 multiplier =
1242             uint128((timeLeft * BASE_MULTIPLIER) / epochDuration);
1243 
1244         return multiplier;
1245     }
1246 
1247     function computeNewMultiplier(
1248         uint256 prevBalance,
1249         uint128 prevMultiplier,
1250         uint256 amount,
1251         uint128 currentMultiplier
1252     ) public pure returns (uint128) {
1253         uint256 prevAmount =
1254             prevBalance.mul(prevMultiplier).div(BASE_MULTIPLIER);
1255         uint256 addAmount = amount.mul(currentMultiplier).div(BASE_MULTIPLIER);
1256         uint128 newMultiplier =
1257             uint128(
1258                 prevAmount.add(addAmount).mul(BASE_MULTIPLIER).div(
1259                     prevBalance.add(amount)
1260                 )
1261             );
1262 
1263         return newMultiplier;
1264     }
1265 
1266     /*
1267      * Checks if an epoch is initialized, meaning we have a pool size set for it
1268      */
1269     function epochIsInitialized(address token, uint128 epochId)
1270         public
1271         view
1272         returns (bool)
1273     {
1274         return poolSize[token][epochId].set;
1275     }
1276 
1277     function getCheckpointBalance(Checkpoint memory c)
1278         internal
1279         pure
1280         returns (uint256)
1281     {
1282         return c.startBalance.add(c.newDeposits);
1283     }
1284 
1285     function getCheckpointEffectiveBalance(Checkpoint memory c)
1286         internal
1287         pure
1288         returns (uint256)
1289     {
1290         return getCheckpointBalance(c).mul(c.multiplier).div(BASE_MULTIPLIER);
1291     }
1292 
1293     function addAllowedYieldFarm(address contractAddress) public onlyOwner {
1294         require(
1295             contractAddress != address(0),
1296             "Staking Contract: Contract address cannot be zero address"
1297         );
1298         allowedYieldFarms[contractAddress] = true;
1299     }
1300 
1301     function deleteAllowedYieldFarm(address contractAddress) public onlyOwner {
1302         require(
1303             contractAddress != address(0),
1304             "Staking Contract: Contract address cannot be zero address"
1305         );
1306         allowedYieldFarms[contractAddress] = false;
1307     }
1308 }