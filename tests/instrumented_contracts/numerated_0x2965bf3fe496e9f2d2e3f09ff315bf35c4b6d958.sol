1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
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
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
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
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 // SPDX-License-Identifier: MIT
84 
85 pragma solidity ^0.6.0;
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100 library SafeMath {
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
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 // SPDX-License-Identifier: MIT
246 
247 pragma solidity ^0.6.2;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
272         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
273         // for accounts without code, i.e. `keccak256('')`
274         bytes32 codehash;
275         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { codehash := extcodehash(account) }
278         return (codehash != accountHash && codehash != 0x0);
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
388 
389 // SPDX-License-Identifier: MIT
390 
391 pragma solidity ^0.6.0;
392 
393 
394 
395 
396 /**
397  * @title SafeERC20
398  * @dev Wrappers around ERC20 operations that throw on failure (when the token
399  * contract returns false). Tokens that return no value (and instead revert or
400  * throw on failure) are also supported, non-reverting calls are assumed to be
401  * successful.
402  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
403  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
404  */
405 library SafeERC20 {
406     using SafeMath for uint256;
407     using Address for address;
408 
409     function safeTransfer(IERC20 token, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
411     }
412 
413     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
415     }
416 
417     /**
418      * @dev Deprecated. This function has issues similar to the ones found in
419      * {IERC20-approve}, and its usage is discouraged.
420      *
421      * Whenever possible, use {safeIncreaseAllowance} and
422      * {safeDecreaseAllowance} instead.
423      */
424     function safeApprove(IERC20 token, address spender, uint256 value) internal {
425         // safeApprove should only be called when setting an initial allowance,
426         // or when resetting it to zero. To increase and decrease it, use
427         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
428         // solhint-disable-next-line max-line-length
429         require((value == 0) || (token.allowance(address(this), spender) == 0),
430             "SafeERC20: approve from non-zero to non-zero allowance"
431         );
432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
433     }
434 
435     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
436         uint256 newAllowance = token.allowance(address(this), spender).add(value);
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
438     }
439 
440     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
441         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
442         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
443     }
444 
445     /**
446      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
447      * on the return value: the return value is optional (but if data is returned, it must not be false).
448      * @param token The token targeted by the call.
449      * @param data The call data (encoded using abi.encode or one of its variants).
450      */
451     function _callOptionalReturn(IERC20 token, bytes memory data) private {
452         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
453         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
454         // the target address contains contract code and also asserts for success in the low-level call.
455 
456         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
457         if (returndata.length > 0) { // Return data is optional
458             // solhint-disable-next-line max-line-length
459             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
460         }
461     }
462 }
463 
464 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
465 
466 // SPDX-License-Identifier: MIT
467 
468 pragma solidity ^0.6.0;
469 
470 /**
471  * @dev Contract module that helps prevent reentrant calls to a function.
472  *
473  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
474  * available, which can be applied to functions to make sure there are no nested
475  * (reentrant) calls to them.
476  *
477  * Note that because there is a single `nonReentrant` guard, functions marked as
478  * `nonReentrant` may not call one another. This can be worked around by making
479  * those functions `private`, and then adding `external` `nonReentrant` entry
480  * points to them.
481  *
482  * TIP: If you would like to learn more about reentrancy and alternative ways
483  * to protect against it, check out our blog post
484  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
485  */
486 contract ReentrancyGuard {
487     // Booleans are more expensive than uint256 or any type that takes up a full
488     // word because each write operation emits an extra SLOAD to first read the
489     // slot's contents, replace the bits taken up by the boolean, and then write
490     // back. This is the compiler's defense against contract upgrades and
491     // pointer aliasing, and it cannot be disabled.
492 
493     // The values being non-zero value makes deployment a bit more expensive,
494     // but in exchange the refund on every call to nonReentrant will be lower in
495     // amount. Since refunds are capped to a percentage of the total
496     // transaction's gas, it is best to keep them low in cases like this one, to
497     // increase the likelihood of the full refund coming into effect.
498     uint256 private constant _NOT_ENTERED = 1;
499     uint256 private constant _ENTERED = 2;
500 
501     uint256 private _status;
502 
503     constructor () internal {
504         _status = _NOT_ENTERED;
505     }
506 
507     /**
508      * @dev Prevents a contract from calling itself, directly or indirectly.
509      * Calling a `nonReentrant` function from another `nonReentrant`
510      * function is not supported. It is possible to prevent this from happening
511      * by making the `nonReentrant` function external, and make it call a
512      * `private` function that does the actual work.
513      */
514     modifier nonReentrant() {
515         // On the first call to nonReentrant, _notEntered will be true
516         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
517 
518         // Any calls to nonReentrant after this point will fail
519         _status = _ENTERED;
520 
521         _;
522 
523         // By storing the original value once again, a refund is triggered (see
524         // https://eips.ethereum.org/EIPS/eip-2200)
525         _status = _NOT_ENTERED;
526     }
527 }
528 
529 // File: @openzeppelin/contracts/GSN/Context.sol
530 
531 // SPDX-License-Identifier: MIT
532 
533 pragma solidity ^0.6.0;
534 
535 /*
536  * @dev Provides information about the current execution context, including the
537  * sender of the transaction and its data. While these are generally available
538  * via msg.sender and msg.data, they should not be accessed in such a direct
539  * manner, since when dealing with GSN meta-transactions the account sending and
540  * paying for execution may not be the actual sender (as far as an application
541  * is concerned).
542  *
543  * This contract is only required for intermediate, library-like contracts.
544  */
545 abstract contract Context {
546     function _msgSender() internal view virtual returns (address payable) {
547         return msg.sender;
548     }
549 
550     function _msgData() internal view virtual returns (bytes memory) {
551         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
552         return msg.data;
553     }
554 }
555 
556 // File: @openzeppelin/contracts/access/Ownable.sol
557 
558 // SPDX-License-Identifier: MIT
559 
560 pragma solidity ^0.6.0;
561 
562 /**
563  * @dev Contract module which provides a basic access control mechanism, where
564  * there is an account (an owner) that can be granted exclusive access to
565  * specific functions.
566  *
567  * By default, the owner account will be the one that deploys the contract. This
568  * can later be changed with {transferOwnership}.
569  *
570  * This module is used through inheritance. It will make available the modifier
571  * `onlyOwner`, which can be applied to your functions to restrict their use to
572  * the owner.
573  */
574 contract Ownable is Context {
575     address private _owner;
576 
577     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
578 
579     /**
580      * @dev Initializes the contract setting the deployer as the initial owner.
581      */
582     constructor () internal {
583         address msgSender = _msgSender();
584         _owner = msgSender;
585         emit OwnershipTransferred(address(0), msgSender);
586     }
587 
588     /**
589      * @dev Returns the address of the current owner.
590      */
591     function owner() public view returns (address) {
592         return _owner;
593     }
594 
595     /**
596      * @dev Throws if called by any account other than the owner.
597      */
598     modifier onlyOwner() {
599         require(_owner == _msgSender(), "Ownable: caller is not the owner");
600         _;
601     }
602 
603     /**
604      * @dev Leaves the contract without owner. It will not be possible to call
605      * `onlyOwner` functions anymore. Can only be called by the current owner.
606      *
607      * NOTE: Renouncing ownership will leave the contract without an owner,
608      * thereby removing any functionality that is only available to the owner.
609      */
610     function renounceOwnership() public virtual onlyOwner {
611         emit OwnershipTransferred(_owner, address(0));
612         _owner = address(0);
613     }
614 
615     /**
616      * @dev Transfers ownership of the contract to a new account (`newOwner`).
617      * Can only be called by the current owner.
618      */
619     function transferOwnership(address newOwner) public virtual onlyOwner {
620         require(newOwner != address(0), "Ownable: new owner is the zero address");
621         emit OwnershipTransferred(_owner, newOwner);
622         _owner = newOwner;
623     }
624 }
625 
626 // File: contracts/DexKitSale.sol
627 
628 // contracts/DexKit.sol
629 // SPDX-License-Identifier: MIT
630 pragma solidity ^0.6.0;
631 
632 
633 
634 
635 
636 
637 /**
638 *
639 * DexKit Sale contract, used to distribute tokens by contract address.
640 * This sale has 3 rounds
641 * OTC Price 1 = 750 KIT per ETH --> capped to 400 ETH
642 * OTC Price 2 = 600 KIT per ETH --> capped to 750 ETH
643 * OTC Price 3 = 500 KIT per ETH --> capped to 1500 ETH
644 * Max Cap is 2650 ETH
645 * How it works? User send ETH to contract, min 1 ETH, max 25 ETH, the otc price is computed according to raised amount
646 * User can only interact with smartcontract only one time, after that smartcontract not allow to send ETH again
647 * 
648 * Sale opens at 14 of November UTC time 00:00:00
649 */
650 
651 contract DexKitSale is  ReentrancyGuard, Ownable {
652 
653     using SafeMath for uint256;
654     using SafeERC20 for IERC20;
655  
656     uint256 private _startSaleTime;
657 
658     uint256 private _endSaleTime;
659 
660     uint256 private _raisedETH;
661 
662     uint256 private _priceOTC1 = 750;
663     // Cap with price with OTC1
664     uint256 private _thresholdOTC1 = 400 ether;
665 
666     uint256 private _priceOTC2 = 600;
667     // Threshold OTC 2 here is cappedOTC1 plus cappedOTC2
668     uint256 private _thresholdOTC2 = 1150 ether;
669 
670     uint256 private _priceOTC3 = 500;
671 
672     uint256 private _maxCap = 2650 ether;
673 
674     bool private _isWithdrawAllowed = false;
675 
676     IERC20 private _token;
677 
678     mapping (address => uint256) private _withdrawBalances;
679     
680 
681     address payable private _wallet;
682 
683 
684     constructor(uint256 startSaleTime, IERC20 token) public{
685         require(startSaleTime > block.timestamp, "DexKitSale: Start sale time needs to be bigger than current time");
686         _startSaleTime = startSaleTime;
687         _endSaleTime = startSaleTime + 7 days;
688         _wallet = msg.sender;
689         _token = token;
690     }
691 
692 
693     /**
694      * @dev Returns wallet which receives OTC funds
695      */
696     function wallet() public view returns (address) {
697         return _wallet;
698     }
699 
700     /**
701      * @dev Returns token
702      */
703     function token() public view returns (address) {
704         return address(_token);
705     }
706 
707     /**
708      * @dev Returns sale starting time
709      */
710     function startSaleTime() public view returns (uint256) {
711         return _startSaleTime;
712     }
713 
714     /**
715      * @dev Returns end sale time
716      */
717     function endSaleTime() public view returns (uint256) {
718         return _endSaleTime;
719     }
720 
721     /**
722      * @dev Returns max cap
723      */
724     function maxCap() public view returns (uint256) {
725         return _maxCap;
726     }
727 
728     /**
729      * @dev Returns raised ETH
730      */
731     function raisedETH() public view returns (uint256) {
732         return _raisedETH;
733     }
734 
735      /**
736      * @dev user withdraw balance
737      */
738     function userWithdrawBalance() public view returns (uint256) {
739         return _withdrawBalances[msg.sender];
740     }
741 
742      /**
743      * @dev user withdraw balance
744      */
745     function userWithdrawBalanceOf(address user) public view returns (uint256) {
746         return _withdrawBalances[user];
747     }
748 
749 
750     /**
751      * @dev check if withdraw is allowed already
752      */
753     function withdrawAllowed() public view returns (bool) {
754         return _isWithdrawAllowed || block.timestamp > endSaleTime();
755     }
756 
757 
758     /**
759     *  @dev When receive ETH register tokens to be withdraw later after sale
760     *
761     *
762      */
763     receive() external payable {
764         require(block.timestamp > startSaleTime(), "DexKitSale: Sale not started");
765         require(block.timestamp < endSaleTime(), "DexKitSale: Sale finished");
766         require(msg.value >= 1 ether, "DexKitSale: Minimum value is 1 ETH");
767         require(msg.value <= 25 ether, "DexKitSale: Maximum value is 25 ETH");
768         require(_withdrawBalances[msg.sender] == 0, "DexKitSale: already invested");
769         require(!_isWithdrawAllowed, "DexKitSale: Withdraw was enabled");
770         uint256 amount = msg.value;
771         // Price it starts at OTC1 price
772         uint256 price = _priceOTC1;
773 
774         _raisedETH = _raisedETH.add(amount);
775         require(_raisedETH <= _maxCap, "DexKitSale: sale sold out");
776         // If first cap is reached, OTC price is updated to round 2
777         if(_raisedETH > _thresholdOTC1){
778             price = _priceOTC2;
779         }
780         // If second cap is reached, OTC price is updated to round 3
781         if(_raisedETH > _thresholdOTC2){
782             price = _priceOTC3;
783         }
784        
785         _withdrawBalances[msg.sender] = _withdrawBalances[msg.sender].add(amount.mul(price));
786         emit Boughted(msg.sender, amount, price);
787     }
788     /**
789     * @dev call this if you want to allow withdraw before sale time, this could happen if sold out happen.
790     * It is recommended allow withdraw only after Uniswap pool is set
791     *   
792      */
793     function allowWithdraw() public onlyOwner{
794         _isWithdrawAllowed = true;
795     }
796 
797       /**
798     *
799     * @dev User can withdraw after end of sale time or if withdraw is allowed
800      */
801     function withdrawTokens() external nonReentrant {
802       require(block.timestamp > endSaleTime()  || _isWithdrawAllowed, "DexKitSale: Sale not finished");
803       uint256 amount = _withdrawBalances[msg.sender];
804       require(amount > 0, "DexKitSale: Amount needs to be bigger than zero");
805        _withdrawBalances[msg.sender] = 0;
806       _token.safeTransfer(msg.sender, amount);
807       emit Withdrawed(msg.sender, amount);
808     }
809 
810     /**
811      *
812      * @dev call this if user not know how to call withdraw tokens function, this withdraw tokens to user in their behalf
813      */
814     function withdrawByTokens(address user) external nonReentrant {
815       require(block.timestamp > endSaleTime() || _isWithdrawAllowed, "DexKitSale: Sale not finished");
816       uint256 amount = _withdrawBalances[user];
817       require(amount > 0, "DexKitSale: Amount needs to be bigger than zero");
818       _withdrawBalances[user] = 0;
819       _token.safeTransfer(user, amount);
820       emit Withdrawed(user, amount);
821     }
822 
823     /**
824     *
825     * @dev Return ETH raised to project. Dev can withdraw at any time, part of OTC value is needed to setup Uniswap Liquidity, 
826     * so it is needed to withdraw before users
827      */
828     function withdrawETH() public {
829       uint256 amount = address(this).balance;
830       require(amount > 0, "No ETH to Withraw");
831       _wallet.transfer(amount);
832     }
833       /**
834      * @notice Transfers tokens held by sale smartcontract back to dev after 5 days of sale finished. Transfer tokens back to user 
835      * before call this function
836      */
837     function release() public {
838         // solhint-disable-next-line not-rely-on-time
839         require(block.timestamp >= endSaleTime() + 5 days, "DexKitSale: Not passed lock time");
840 
841         uint256 amount = _token.balanceOf(address(this));
842         require(amount > 0, "DexKitSale: no tokens to release");
843 
844         _token.safeTransfer(_wallet, amount);
845     }
846 
847     event Withdrawed(address indexed user, uint256 amount);
848     event Boughted(address indexed user, uint256 amount, uint256 price);
849 }
