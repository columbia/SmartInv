1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.7.1;
3 
4 // File: @openzeppelin/contracts/math/SafeMath.sol
5 
6 
7 
8 
9 
10 /**
11  * @dev Wrappers over Solidity's arithmetic operations with added overflow
12  * checks.
13  *
14  * Arithmetic operations in Solidity wrap on overflow. This can easily result
15  * in bugs, because programmers usually assume that an overflow raises an
16  * error, which is the standard behavior in high level programming languages.
17  * `SafeMath` restores this intuition by reverting the transaction when an
18  * operation overflows.
19  *
20  * Using this library instead of the unchecked operations eliminates an entire
21  * class of bugs, so it's recommended to use it always.
22  */
23 library SafeMath {
24     /**
25      * @dev Returns the addition of two unsigned integers, reverting on
26      * overflow.
27      *
28      * Counterpart to Solidity's `+` operator.
29      *
30      * Requirements:
31      *
32      * - Addition cannot overflow.
33      */
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37 
38         return c;
39     }
40 
41     /**
42      * @dev Returns the subtraction of two unsigned integers, reverting on
43      * overflow (when the result is negative).
44      *
45      * Counterpart to Solidity's `-` operator.
46      *
47      * Requirements:
48      *
49      * - Subtraction cannot overflow.
50      */
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         return sub(a, b, "SafeMath: subtraction overflow");
53     }
54 
55     /**
56      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
57      * overflow (when the result is negative).
58      *
59      * Counterpart to Solidity's `-` operator.
60      *
61      * Requirements:
62      *
63      * - Subtraction cannot overflow.
64      */
65     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b <= a, errorMessage);
67         uint256 c = a - b;
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the multiplication of two unsigned integers, reverting on
74      * overflow.
75      *
76      * Counterpart to Solidity's `*` operator.
77      *
78      * Requirements:
79      *
80      * - Multiplication cannot overflow.
81      */
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
84         // benefit is lost if 'b' is also tested.
85         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
86         if (a == 0) {
87             return 0;
88         }
89 
90         uint256 c = a * b;
91         require(c / a == b, "SafeMath: multiplication overflow");
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the integer division of two unsigned integers. Reverts on
98      * division by zero. The result is rounded towards zero.
99      *
100      * Counterpart to Solidity's `/` operator. Note: this function uses a
101      * `revert` opcode (which leaves remaining gas untouched) while Solidity
102      * uses an invalid opcode to revert (consuming all remaining gas).
103      *
104      * Requirements:
105      *
106      * - The divisor cannot be zero.
107      */
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         return div(a, b, "SafeMath: division by zero");
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator. Note: this function uses a
117      * `revert` opcode (which leaves remaining gas untouched) while Solidity
118      * uses an invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      *
122      * - The divisor cannot be zero.
123      */
124     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
125         require(b > 0, errorMessage);
126         uint256 c = a / b;
127         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
134      * Reverts when dividing by zero.
135      *
136      * Counterpart to Solidity's `%` operator. This function uses a `revert`
137      * opcode (which leaves remaining gas untouched) while Solidity uses an
138      * invalid opcode to revert (consuming all remaining gas).
139      *
140      * Requirements:
141      *
142      * - The divisor cannot be zero.
143      */
144     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
145         return mod(a, b, "SafeMath: modulo by zero");
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
150      * Reverts with custom message when dividing by zero.
151      *
152      * Counterpart to Solidity's `%` operator. This function uses a `revert`
153      * opcode (which leaves remaining gas untouched) while Solidity uses an
154      * invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      *
158      * - The divisor cannot be zero.
159      */
160     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b != 0, errorMessage);
162         return a % b;
163     }
164 }
165 
166 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
167 
168 
169 
170 
171 
172 /**
173  * @dev Interface of the ERC20 standard as defined in the EIP.
174  */
175 interface IERC20 {
176     /**
177      * @dev Returns the amount of tokens in existence.
178      */
179     function totalSupply() external view returns (uint256);
180 
181     /**
182      * @dev Returns the amount of tokens owned by `account`.
183      */
184     function balanceOf(address account) external view returns (uint256);
185 
186     /**
187      * @dev Moves `amount` tokens from the caller's account to `recipient`.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * Emits a {Transfer} event.
192      */
193     function transfer(address recipient, uint256 amount) external returns (bool);
194 
195     /**
196      * @dev Returns the remaining number of tokens that `spender` will be
197      * allowed to spend on behalf of `owner` through {transferFrom}. This is
198      * zero by default.
199      *
200      * This value changes when {approve} or {transferFrom} are called.
201      */
202     function allowance(address owner, address spender) external view returns (uint256);
203 
204     /**
205      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * IMPORTANT: Beware that changing an allowance with this method brings the risk
210      * that someone may use both the old and the new allowance by unfortunate
211      * transaction ordering. One possible solution to mitigate this race
212      * condition is to first reduce the spender's allowance to 0 and set the
213      * desired value afterwards:
214      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215      *
216      * Emits an {Approval} event.
217      */
218     function approve(address spender, uint256 amount) external returns (bool);
219 
220     /**
221      * @dev Moves `amount` tokens from `sender` to `recipient` using the
222      * allowance mechanism. `amount` is then deducted from the caller's
223      * allowance.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * Emits a {Transfer} event.
228      */
229     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
230 
231     /**
232      * @dev Emitted when `value` tokens are moved from one account (`from`) to
233      * another (`to`).
234      *
235      * Note that `value` may be zero.
236      */
237     event Transfer(address indexed from, address indexed to, uint256 value);
238 
239     /**
240      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
241      * a call to {approve}. `value` is the new allowance.
242      */
243     event Approval(address indexed owner, address indexed spender, uint256 value);
244 }
245 
246 // File: @openzeppelin/contracts/utils/Address.sol
247 
248 
249 
250 
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      */
273     function isContract(address account) internal view returns (bool) {
274         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
275         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
276         // for accounts without code, i.e. `keccak256('')`
277         bytes32 codehash;
278         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
279         // solhint-disable-next-line no-inline-assembly
280         assembly { codehash := extcodehash(account) }
281         return (codehash != accountHash && codehash != 0x0);
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(address(this).balance >= amount, "Address: insufficient balance");
302 
303         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
304         (bool success, ) = recipient.call{ value: amount }("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain`call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327       return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
337         return _functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but also transferring `value` wei to `target`.
343      *
344      * Requirements:
345      *
346      * - the calling contract must have an ETH balance of at least `value`.
347      * - the called Solidity function must be `payable`.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         return _functionCallWithValue(target, data, value, errorMessage);
364     }
365 
366     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
367         require(isContract(target), "Address: call to non-contract");
368 
369         // solhint-disable-next-line avoid-low-level-calls
370         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
371         if (success) {
372             return returndata;
373         } else {
374             // Look for revert reason and bubble it up if present
375             if (returndata.length > 0) {
376                 // The easiest way to bubble the revert reason is using memory via assembly
377 
378                 // solhint-disable-next-line no-inline-assembly
379                 assembly {
380                     let returndata_size := mload(returndata)
381                     revert(add(32, returndata), returndata_size)
382                 }
383             } else {
384                 revert(errorMessage);
385             }
386         }
387     }
388 }
389 
390 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
391 
392 
393 
394 
395 
396 
397 
398 
399 /**
400  * @title SafeERC20
401  * @dev Wrappers around ERC20 operations that throw on failure (when the token
402  * contract returns false). Tokens that return no value (and instead revert or
403  * throw on failure) are also supported, non-reverting calls are assumed to be
404  * successful.
405  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
406  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
407  */
408 library SafeERC20 {
409     using SafeMath for uint256;
410     using Address for address;
411 
412     function safeTransfer(IERC20 token, address to, uint256 value) internal {
413         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
414     }
415 
416     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
417         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
418     }
419 
420     /**
421      * @dev Deprecated. This function has issues similar to the ones found in
422      * {IERC20-approve}, and its usage is discouraged.
423      *
424      * Whenever possible, use {safeIncreaseAllowance} and
425      * {safeDecreaseAllowance} instead.
426      */
427     function safeApprove(IERC20 token, address spender, uint256 value) internal {
428         // safeApprove should only be called when setting an initial allowance,
429         // or when resetting it to zero. To increase and decrease it, use
430         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
431         // solhint-disable-next-line max-line-length
432         require((value == 0) || (token.allowance(address(this), spender) == 0),
433             "SafeERC20: approve from non-zero to non-zero allowance"
434         );
435         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
436     }
437 
438     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
439         uint256 newAllowance = token.allowance(address(this), spender).add(value);
440         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
441     }
442 
443     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
444         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
445         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
446     }
447 
448     /**
449      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
450      * on the return value: the return value is optional (but if data is returned, it must not be false).
451      * @param token The token targeted by the call.
452      * @param data The call data (encoded using abi.encode or one of its variants).
453      */
454     function _callOptionalReturn(IERC20 token, bytes memory data) private {
455         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
456         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
457         // the target address contains contract code and also asserts for success in the low-level call.
458 
459         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
460         if (returndata.length > 0) { // Return data is optional
461             // solhint-disable-next-line max-line-length
462             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
463         }
464     }
465 }
466 
467 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
468 
469 
470 
471 
472 
473 /**
474  * @dev Contract module that helps prevent reentrant calls to a function.
475  *
476  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
477  * available, which can be applied to functions to make sure there are no nested
478  * (reentrant) calls to them.
479  *
480  * Note that because there is a single `nonReentrant` guard, functions marked as
481  * `nonReentrant` may not call one another. This can be worked around by making
482  * those functions `private`, and then adding `external` `nonReentrant` entry
483  * points to them.
484  *
485  * TIP: If you would like to learn more about reentrancy and alternative ways
486  * to protect against it, check out our blog post
487  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
488  */
489 abstract contract ReentrancyGuard {
490     // Booleans are more expensive than uint256 or any type that takes up a full
491     // word because each write operation emits an extra SLOAD to first read the
492     // slot's contents, replace the bits taken up by the boolean, and then write
493     // back. This is the compiler's defense against contract upgrades and
494     // pointer aliasing, and it cannot be disabled.
495 
496     // The values being non-zero value makes deployment a bit more expensive,
497     // but in exchange the refund on every call to nonReentrant will be lower in
498     // amount. Since refunds are capped to a percentage of the total
499     // transaction's gas, it is best to keep them low in cases like this one, to
500     // increase the likelihood of the full refund coming into effect.
501     uint256 private constant _NOT_ENTERED = 1;
502     uint256 private constant _ENTERED = 2;
503 
504     uint256 private _status;
505 
506     constructor () {
507         _status = _NOT_ENTERED;
508     }
509 
510     /**
511      * @dev Prevents a contract from calling itself, directly or indirectly.
512      * Calling a `nonReentrant` function from another `nonReentrant`
513      * function is not supported. It is possible to prevent this from happening
514      * by making the `nonReentrant` function external, and make it call a
515      * `private` function that does the actual work.
516      */
517     modifier nonReentrant() {
518         // On the first call to nonReentrant, _notEntered will be true
519         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
520 
521         // Any calls to nonReentrant after this point will fail
522         _status = _ENTERED;
523 
524         _;
525 
526         // By storing the original value once again, a refund is triggered (see
527         // https://eips.ethereum.org/EIPS/eip-2200)
528         _status = _NOT_ENTERED;
529     }
530 }
531 
532 // File: @openzeppelin/contracts/GSN/Context.sol
533 
534 
535 
536 
537 
538 /*
539  * @dev Provides information about the current execution context, including the
540  * sender of the transaction and its data. While these are generally available
541  * via msg.sender and msg.data, they should not be accessed in such a direct
542  * manner, since when dealing with GSN meta-transactions the account sending and
543  * paying for execution may not be the actual sender (as far as an application
544  * is concerned).
545  *
546  * This contract is only required for intermediate, library-like contracts.
547  */
548 abstract contract Context {
549     function _msgSender() internal view virtual returns (address payable) {
550         return msg.sender;
551     }
552 
553     function _msgData() internal view virtual returns (bytes memory) {
554         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
555         return msg.data;
556     }
557 }
558 
559 // File: @openzeppelin/contracts/access/Ownable.sol
560 
561 
562 
563 
564 
565 /**
566  * @dev Contract module which provides a basic access control mechanism, where
567  * there is an account (an owner) that can be granted exclusive access to
568  * specific functions.
569  *
570  * By default, the owner account will be the one that deploys the contract. This
571  * can later be changed with {transferOwnership}.
572  *
573  * This module is used through inheritance. It will make available the modifier
574  * `onlyOwner`, which can be applied to your functions to restrict their use to
575  * the owner.
576  */
577 abstract contract Ownable is Context {
578     address private _owner;
579 
580     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
581 
582     /**
583      * @dev Initializes the contract setting the deployer as the initial owner.
584      */
585     constructor () {
586         address msgSender = _msgSender();
587         _owner = msgSender;
588         emit OwnershipTransferred(address(0), msgSender);
589     }
590 
591     /**
592      * @dev Returns the address of the current owner.
593      */
594     function owner() public view returns (address) {
595         return _owner;
596     }
597 
598     /**
599      * @dev Throws if called by any account other than the owner.
600      */
601     modifier onlyOwner() {
602         require(_owner == _msgSender(), "Ownable: caller is not the owner");
603         _;
604     }
605 
606     /**
607      * @dev Leaves the contract without owner. It will not be possible to call
608      * `onlyOwner` functions anymore. Can only be called by the current owner.
609      *
610      * NOTE: Renouncing ownership will leave the contract without an owner,
611      * thereby removing any functionality that is only available to the owner.
612      */
613     function renounceOwnership() public virtual onlyOwner {
614         emit OwnershipTransferred(_owner, address(0));
615         _owner = address(0);
616     }
617 
618     /**
619      * @dev Transfers ownership of the contract to a new account (`newOwner`).
620      * Can only be called by the current owner.
621      */
622     function transferOwnership(address newOwner) public virtual onlyOwner {
623         require(newOwner != address(0), "Ownable: new owner is the zero address");
624         emit OwnershipTransferred(_owner, newOwner);
625         _owner = newOwner;
626     }
627 }
628 
629 // File: @openzeppelin/contracts/math/SignedSafeMath.sol
630 
631 
632 
633 
634 
635 /**
636  * @title SignedSafeMath
637  * @dev Signed math operations with safety checks that revert on error.
638  */
639 library SignedSafeMath {
640     int256 constant private _INT256_MIN = -2**255;
641 
642     /**
643      * @dev Returns the multiplication of two signed integers, reverting on
644      * overflow.
645      *
646      * Counterpart to Solidity's `*` operator.
647      *
648      * Requirements:
649      *
650      * - Multiplication cannot overflow.
651      */
652     function mul(int256 a, int256 b) internal pure returns (int256) {
653         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
654         // benefit is lost if 'b' is also tested.
655         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
656         if (a == 0) {
657             return 0;
658         }
659 
660         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
661 
662         int256 c = a * b;
663         require(c / a == b, "SignedSafeMath: multiplication overflow");
664 
665         return c;
666     }
667 
668     /**
669      * @dev Returns the integer division of two signed integers. Reverts on
670      * division by zero. The result is rounded towards zero.
671      *
672      * Counterpart to Solidity's `/` operator. Note: this function uses a
673      * `revert` opcode (which leaves remaining gas untouched) while Solidity
674      * uses an invalid opcode to revert (consuming all remaining gas).
675      *
676      * Requirements:
677      *
678      * - The divisor cannot be zero.
679      */
680     function div(int256 a, int256 b) internal pure returns (int256) {
681         require(b != 0, "SignedSafeMath: division by zero");
682         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
683 
684         int256 c = a / b;
685 
686         return c;
687     }
688 
689     /**
690      * @dev Returns the subtraction of two signed integers, reverting on
691      * overflow.
692      *
693      * Counterpart to Solidity's `-` operator.
694      *
695      * Requirements:
696      *
697      * - Subtraction cannot overflow.
698      */
699     function sub(int256 a, int256 b) internal pure returns (int256) {
700         int256 c = a - b;
701         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
702 
703         return c;
704     }
705 
706     /**
707      * @dev Returns the addition of two signed integers, reverting on
708      * overflow.
709      *
710      * Counterpart to Solidity's `+` operator.
711      *
712      * Requirements:
713      *
714      * - Addition cannot overflow.
715      */
716     function add(int256 a, int256 b) internal pure returns (int256) {
717         int256 c = a + b;
718         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
719 
720         return c;
721     }
722 }
723 
724 // File: @openzeppelin/contracts/utils/SafeCast.sol
725 
726 
727 
728 
729 
730 
731 /**
732  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
733  * checks.
734  *
735  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
736  * easily result in undesired exploitation or bugs, since developers usually
737  * assume that overflows raise errors. `SafeCast` restores this intuition by
738  * reverting the transaction when such an operation overflows.
739  *
740  * Using this library instead of the unchecked operations eliminates an entire
741  * class of bugs, so it's recommended to use it always.
742  *
743  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
744  * all math on `uint256` and `int256` and then downcasting.
745  */
746 library SafeCast {
747 
748     /**
749      * @dev Returns the downcasted uint128 from uint256, reverting on
750      * overflow (when the input is greater than largest uint128).
751      *
752      * Counterpart to Solidity's `uint128` operator.
753      *
754      * Requirements:
755      *
756      * - input must fit into 128 bits
757      */
758     function toUint128(uint256 value) internal pure returns (uint128) {
759         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
760         return uint128(value);
761     }
762 
763     /**
764      * @dev Returns the downcasted uint64 from uint256, reverting on
765      * overflow (when the input is greater than largest uint64).
766      *
767      * Counterpart to Solidity's `uint64` operator.
768      *
769      * Requirements:
770      *
771      * - input must fit into 64 bits
772      */
773     function toUint64(uint256 value) internal pure returns (uint64) {
774         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
775         return uint64(value);
776     }
777 
778     /**
779      * @dev Returns the downcasted uint32 from uint256, reverting on
780      * overflow (when the input is greater than largest uint32).
781      *
782      * Counterpart to Solidity's `uint32` operator.
783      *
784      * Requirements:
785      *
786      * - input must fit into 32 bits
787      */
788     function toUint32(uint256 value) internal pure returns (uint32) {
789         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
790         return uint32(value);
791     }
792 
793     /**
794      * @dev Returns the downcasted uint16 from uint256, reverting on
795      * overflow (when the input is greater than largest uint16).
796      *
797      * Counterpart to Solidity's `uint16` operator.
798      *
799      * Requirements:
800      *
801      * - input must fit into 16 bits
802      */
803     function toUint16(uint256 value) internal pure returns (uint16) {
804         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
805         return uint16(value);
806     }
807 
808     /**
809      * @dev Returns the downcasted uint8 from uint256, reverting on
810      * overflow (when the input is greater than largest uint8).
811      *
812      * Counterpart to Solidity's `uint8` operator.
813      *
814      * Requirements:
815      *
816      * - input must fit into 8 bits.
817      */
818     function toUint8(uint256 value) internal pure returns (uint8) {
819         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
820         return uint8(value);
821     }
822 
823     /**
824      * @dev Converts a signed int256 into an unsigned uint256.
825      *
826      * Requirements:
827      *
828      * - input must be greater than or equal to 0.
829      */
830     function toUint256(int256 value) internal pure returns (uint256) {
831         require(value >= 0, "SafeCast: value must be positive");
832         return uint256(value);
833     }
834 
835     /**
836      * @dev Returns the downcasted int128 from int256, reverting on
837      * overflow (when the input is less than smallest int128 or
838      * greater than largest int128).
839      *
840      * Counterpart to Solidity's `int128` operator.
841      *
842      * Requirements:
843      *
844      * - input must fit into 128 bits
845      *
846      * _Available since v3.1._
847      */
848     function toInt128(int256 value) internal pure returns (int128) {
849         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
850         return int128(value);
851     }
852 
853     /**
854      * @dev Returns the downcasted int64 from int256, reverting on
855      * overflow (when the input is less than smallest int64 or
856      * greater than largest int64).
857      *
858      * Counterpart to Solidity's `int64` operator.
859      *
860      * Requirements:
861      *
862      * - input must fit into 64 bits
863      *
864      * _Available since v3.1._
865      */
866     function toInt64(int256 value) internal pure returns (int64) {
867         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
868         return int64(value);
869     }
870 
871     /**
872      * @dev Returns the downcasted int32 from int256, reverting on
873      * overflow (when the input is less than smallest int32 or
874      * greater than largest int32).
875      *
876      * Counterpart to Solidity's `int32` operator.
877      *
878      * Requirements:
879      *
880      * - input must fit into 32 bits
881      *
882      * _Available since v3.1._
883      */
884     function toInt32(int256 value) internal pure returns (int32) {
885         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
886         return int32(value);
887     }
888 
889     /**
890      * @dev Returns the downcasted int16 from int256, reverting on
891      * overflow (when the input is less than smallest int16 or
892      * greater than largest int16).
893      *
894      * Counterpart to Solidity's `int16` operator.
895      *
896      * Requirements:
897      *
898      * - input must fit into 16 bits
899      *
900      * _Available since v3.1._
901      */
902     function toInt16(int256 value) internal pure returns (int16) {
903         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
904         return int16(value);
905     }
906 
907     /**
908      * @dev Returns the downcasted int8 from int256, reverting on
909      * overflow (when the input is less than smallest int8 or
910      * greater than largest int8).
911      *
912      * Counterpart to Solidity's `int8` operator.
913      *
914      * Requirements:
915      *
916      * - input must fit into 8 bits.
917      *
918      * _Available since v3.1._
919      */
920     function toInt8(int256 value) internal pure returns (int8) {
921         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
922         return int8(value);
923     }
924 
925     /**
926      * @dev Converts an unsigned uint256 into a signed int256.
927      *
928      * Requirements:
929      *
930      * - input must be less than or equal to maxInt256.
931      */
932     function toInt256(uint256 value) internal pure returns (int256) {
933         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
934         return int256(value);
935     }
936 }
937 
938 // File: contracts/Interfaces/StakingInterface.sol
939 
940 
941 
942 
943 interface StakingInterface {
944   function getStakingTokenAddress() external view returns (address);
945 
946   function getTokenInfo()
947     external
948     view
949     returns (
950       uint256 currentTerm,
951       uint256 latestTerm,
952       uint256 totalRemainingRewards,
953       uint256 currentTermRewards,
954       uint256 nextTermRewards,
955       uint128 currentStaking,
956       uint128 nextTermStaking
957     );
958 
959   function getConfigs() external view returns (uint256 startTimestamp, uint256 termInterval);
960 
961   function getTermInfo(uint256 term)
962     external
963     view
964     returns (
965       int128 stakeAdd,
966       uint128 stakeSum,
967       uint256 rewardSum
968     );
969 
970   function getAccountInfo(address account)
971     external
972     view
973     returns (
974       uint256 userTerm,
975       uint256 stakeAmount,
976       int128 nextAddedStakeAmount,
977       uint256 remaining,
978       uint256 currentTermUserRewards,
979       uint256 nextTermUserRewards,
980       uint128 depositAmount,
981       uint128 withdrawableStakingAmount
982     );
983 }
984 
985 // File: contracts/Staking/Staking.sol
986 
987 
988 
989 
990 
991 
992 
993 
994 
995 
996 contract Staking is ReentrancyGuard, StakingInterface {
997   using SafeMath for uint256;
998   using SafeMath for uint128;
999   using SignedSafeMath for int256;
1000   using SignedSafeMath for int128;
1001   using SafeCast for uint256;
1002   using SafeCast for uint128;
1003   using SafeCast for int256;
1004   using SafeCast for int128;
1005   using SafeERC20 for IERC20;
1006 
1007   /* ========== CONSTANT VARIABLES ========== */
1008 
1009   uint256 internal constant MAX_TERM = 100;
1010 
1011   IERC20 internal immutable _stakingToken;
1012   uint256 internal immutable _startTimestamp; // timestamp of the term 0
1013   uint256 internal immutable _termInterval; // time interval between terms in second
1014 
1015   /* ========== STATE VARIABLES ========== */
1016 
1017   uint256 internal _currentTerm; // the current term (all the info prior to this term is fixed)
1018   uint256 internal _totalRemaining; // total unsettled amount of rewards and withdrawal
1019   uint256 internal _totalRewardAdded; // total unsettled amount of rewards
1020 
1021   struct AccountInfo {
1022     int128 added; // the added amount of stake which will be merged to stakeAmount at the term+1.
1023     uint128 stakeAmount; // active stake amount of the user at userTerm
1024     uint256 remaining; // the total amount of rewards and withdrawal until userTerm
1025     uint256 userTerm; // the term when the user executed any function last time (all the terms before the term has been already settled)
1026   }
1027 
1028   /**
1029    * @dev account => data
1030    */
1031   mapping(address => AccountInfo) internal _accountInfoList;
1032 
1033   struct TermInfo {
1034     uint128 stakeAdd; // the total added amount of stake which will be merged to stakeSum at the term+1
1035     uint128 stakeRemove;
1036     uint128 stakeSum; // the total staking amount at the term
1037     uint256 rewardSum; // the total amount of rewards at the term
1038   }
1039 
1040   /**
1041    * @dev term => data
1042    */
1043   mapping(uint256 => TermInfo) internal _termInfoList;
1044 
1045   /* ========== EVENTS ========== */
1046 
1047   event Staked(address indexed account, uint128 amount);
1048   event Withdrawn(address indexed account, uint128 amount);
1049   event RewardPaid(address indexed account, uint256 amount);
1050   event TermUpdated(uint256 currentTerm);
1051   event RewardUpdated(address indexed account, uint256 currentTerm);
1052   event RewardAdded(address indexed account, uint256 indexed term, uint256 amount);
1053 
1054   /* ========== CONSTRUCTOR ========== */
1055 
1056   constructor(
1057     IERC20 stakingToken,
1058     uint256 startTimestamp,
1059     uint256 termInterval
1060   ) {
1061     require(startTimestamp <= block.timestamp, "startTimestamp should be past time");
1062     _startTimestamp = startTimestamp;
1063     _stakingToken = stakingToken;
1064     _termInterval = termInterval;
1065   }
1066 
1067   /* ========== MODIFIERS ========== */
1068 
1069   /**
1070    * @dev Update the info up to the current term.
1071    */
1072   modifier updateTerm() {
1073     uint256 latestTerm = _getLatestTerm();
1074     if (_currentTerm < latestTerm) {
1075       uint128 sendBackLater = _termInfoList[_currentTerm].stakeRemove;
1076       uint128 nextStakeSum = _getNextStakeSum();
1077       uint256 nextTerm = nextStakeSum == 0 ? latestTerm : _currentTerm + 1; // if next stakeSum is 0, skip to latest term
1078       uint256 nextTermReward = _getNextTermReward();
1079       _termInfoList[nextTerm] = TermInfo({
1080         stakeAdd: 0,
1081         stakeRemove: 0,
1082         stakeSum: nextStakeSum,
1083         rewardSum: nextTermReward
1084       });
1085 
1086       // write total stake amount since (nextTerm + 1) until latestTerm
1087       if (nextTerm < latestTerm) {
1088         // assert(_termInfoList[nextTerm].stakeSum != 0 && _termInfoList[nextTerm].stakeAdd == 0);
1089         _termInfoList[latestTerm] = TermInfo({
1090           stakeAdd: 0,
1091           stakeRemove: 0,
1092           stakeSum: nextStakeSum,
1093           rewardSum: 0
1094         });
1095       }
1096 
1097       _totalRemaining = _totalRemaining.add(_totalRewardAdded).add(sendBackLater);
1098       _totalRewardAdded = 0;
1099       _currentTerm = latestTerm;
1100     }
1101 
1102     emit TermUpdated(_currentTerm);
1103     _;
1104   }
1105 
1106   /**
1107    * @dev Calculate total rewards of the account until the current term.
1108    */
1109   modifier updateReward(address account) {
1110     AccountInfo memory accountInfo = _accountInfoList[account];
1111     uint256 startTerm = accountInfo.userTerm;
1112     for (uint256 term = startTerm; term < _currentTerm && term < startTerm + MAX_TERM; term++) {
1113       TermInfo memory termInfo = _termInfoList[term];
1114 
1115       if (termInfo.stakeSum != 0) {
1116         require(
1117           accountInfo.stakeAmount <= termInfo.stakeSum,
1118           "system error: stakeAmount is not more than stakeSum"
1119         );
1120 
1121         // `(total rewards) * (your stake amount) / (total stake amount)` in each term
1122         uint256 rewardsAdded = termInfo.rewardSum.mul(accountInfo.stakeAmount) / termInfo.stakeSum;
1123         accountInfo.remaining = accountInfo.remaining.add(rewardsAdded);
1124         emit RewardAdded(account, term, rewardsAdded);
1125       }
1126 
1127       accountInfo.stakeAmount = addDiff(accountInfo.stakeAmount, accountInfo.added).toUint128();
1128       if (accountInfo.added < 0) {
1129         accountInfo.remaining = addDiff(accountInfo.remaining, -accountInfo.added);
1130       }
1131       accountInfo.added = 0;
1132 
1133       if (accountInfo.stakeAmount == 0) {
1134         accountInfo.userTerm = _currentTerm;
1135         break; // skip unnecessary term
1136       }
1137 
1138       accountInfo.userTerm = term + 1; // calculated until this term
1139     }
1140 
1141     _accountInfoList[account] = accountInfo;
1142 
1143     // do not execute main function if `userTerm` is not the same with `_currentTerm`.
1144     if (accountInfo.userTerm < _currentTerm) {
1145       return;
1146     }
1147 
1148     emit RewardUpdated(account, _currentTerm);
1149     _;
1150   }
1151 
1152   /* ========== MUTATIVE FUNCTIONS ========== */
1153 
1154   /**
1155    * @notice Stake the staking token for the token to be paid as reward.
1156    */
1157   // function stake(uint128 amount)
1158   //   external
1159   //   override
1160   //   nonReentrant
1161   //   updateTerm()
1162   //   updateReward(msg.sender)
1163   // {
1164   //   require(amount != 0, "staking amount should be positive number");
1165 
1166   //   _stake(msg.sender, amount);
1167   //   _stakingToken.safeTransferFrom(msg.sender, address(this), amount);
1168   // }
1169 
1170   /**
1171    * @notice Withdraw the staking token for the token to be paid as reward.
1172    */
1173   // function withdraw(uint128 amount)
1174   //   external
1175   //   override
1176   //   nonReentrant
1177   //   updateTerm()
1178   //   updateReward(msg.sender)
1179   // {
1180   //   require(amount != 0, "withdrawing amount should be positive number");
1181 
1182   //   _withdraw(msg.sender, amount);
1183   //   // _stakingToken.safeTransfer(msg.sender, amount);
1184   // }
1185 
1186   /**
1187    * @notice Receive the reward and withdrawal from this contract.
1188    */
1189   // function receiveReward()
1190   //   external
1191   //   override
1192   //   nonReentrant
1193   //   updateTerm()
1194   //   updateReward(msg.sender)
1195   //   returns (uint256 remaining)
1196   // {
1197   //   remaining = _receiveReward(msg.sender);
1198   //   if (remaining != 0) {
1199   //     _stakingToken.safeTransfer(msg.sender, remaining);
1200   //   }
1201   //   return remaining;
1202   // }
1203 
1204   /**
1205    * @notice Add the reward to this contract.
1206    */
1207   function addReward(uint128 amount) external nonReentrant updateTerm() {
1208     _stakingToken.safeTransferFrom(msg.sender, address(this), amount);
1209     return _addReward(msg.sender, amount);
1210   }
1211 
1212   /* ========== INTERNAL FUNCTIONS ========== */
1213 
1214   /**
1215    * @dev The stake amount of `account` increaases by `amount`.
1216    * This function is staking if `amount` is positive, otherwise unstaking.
1217    */
1218   // function _stakeOrUnstake(address account, int128 amount) internal {
1219   //   uint256 term = _currentTerm;
1220   //   AccountInfo memory accountInfo = _accountInfoList[account];
1221   //   require(
1222   //     addDiff(accountInfo.stakeAmount, accountInfo.added) < type(uint128).max,
1223   //     "stake amount is out of range"
1224   //   );
1225 
1226   //   _accountInfoList[account].added = _accountInfoList[account].added.add(amount).toInt128(); // added when the term is shifted (the user)
1227   //   if (amount >= 0) {
1228   //     _termInfoList[term].stakeAdd = _termInfoList[term].stakeAdd.add(amount.toUint256()).toUint128(); // added when the term is shifted (global)
1229   //   } else {
1230   //     _termInfoList[term].stakeRemove = _termInfoList[term].stakeRemove.sub(-amount.toUint256()).toUint128(); // added when the term is shifted (global)
1231   //   }
1232   // }
1233 
1234   function _stake(address account, uint128 amount) internal returns (uint128 sendBack) {
1235     sendBack = 0;
1236     if (_accountInfoList[account].added < 0) {
1237       uint128 added = uint128(-_accountInfoList[account].added);
1238       sendBack = added < amount ? added : amount; // min(added, amount)
1239     }
1240 
1241     uint256 term = _currentTerm;
1242     AccountInfo memory accountInfo = _accountInfoList[account];
1243     require(
1244       addDiff(accountInfo.stakeAmount, accountInfo.added) < type(uint128).max,
1245       "stake amount is out of range"
1246     );
1247 
1248     _accountInfoList[account].added = _accountInfoList[account]
1249       .added
1250       .add(int256(amount))
1251       .toInt128(); // added when the term is shifted (the user)
1252     // assert(sendBack <= amount);
1253     TermInfo memory termInfo = _termInfoList[term];
1254     termInfo.stakeAdd = termInfo.stakeAdd.add(amount - sendBack).toUint128(); // added when the term is shifted (global)
1255     termInfo.stakeRemove = termInfo.stakeRemove.sub(sendBack).toUint128(); // added when the term is shifted (global)
1256     _termInfoList[term] = termInfo;
1257     emit Staked(account, amount);
1258   }
1259 
1260   /**
1261    * @dev Callee must send back staking token to sender instantly until `added` becomes zero.
1262    *  One can use the return value `sendBack` for it.
1263    */
1264   function _withdraw(address account, uint128 amount) internal returns (uint128 sendBack) {
1265     sendBack = 0;
1266     if (_accountInfoList[account].added > 0) {
1267       uint128 added = uint128(_accountInfoList[account].added);
1268       sendBack = added < amount ? added : amount; // min(added, amount)
1269     }
1270 
1271     uint256 term = _currentTerm;
1272     AccountInfo memory accountInfo = _accountInfoList[account];
1273     require(
1274       addDiff(accountInfo.stakeAmount, accountInfo.added) < type(uint128).max,
1275       "stake amount is out of range"
1276     );
1277 
1278     _accountInfoList[account].added = _accountInfoList[account].added.sub(amount).toInt128(); // added when the term is shifted (the user)
1279     // assert(sendBack <= amount);
1280     TermInfo memory termInfo = _termInfoList[term];
1281     termInfo.stakeAdd = termInfo.stakeAdd.sub(sendBack).toUint128(); // added when the term is shifted (global)
1282     termInfo.stakeRemove = termInfo.stakeRemove.add(amount - sendBack).toUint128(); // added when the term is shifted (global)
1283     _termInfoList[term] = termInfo;
1284 
1285     emit Withdrawn(account, amount);
1286   }
1287 
1288   function _receiveReward(address account) internal returns (uint256 remaining) {
1289     remaining = _accountInfoList[account].remaining;
1290     if (remaining != 0) {
1291       _totalRemaining = _totalRemaining.sub(remaining, "system error: _totalRemaining is invalid");
1292       _accountInfoList[account].remaining = 0;
1293       emit RewardPaid(account, remaining);
1294     }
1295   }
1296 
1297   function _addReward(address, uint128 amount) internal {
1298     _totalRewardAdded = _totalRewardAdded.add(amount);
1299   }
1300 
1301   function _getNextStakeSum() internal view returns (uint128 nextStakeSum) {
1302     TermInfo memory currentTermInfo = _termInfoList[_currentTerm];
1303     return
1304       currentTermInfo
1305         .stakeSum
1306         .add(currentTermInfo.stakeAdd)
1307         .sub(currentTermInfo.stakeRemove)
1308         .toUint128();
1309   }
1310 
1311   function _getCarriedReward() internal view returns (uint256 carriedReward) {
1312     TermInfo memory currentTermInfo = _termInfoList[_currentTerm];
1313     return currentTermInfo.stakeSum == 0 ? currentTermInfo.rewardSum : 0; // if stakeSum is 0, carried forward until someone stakes
1314   }
1315 
1316   function _getNextTermReward() internal view returns (uint256 rewards) {
1317     uint256 carriedReward = _getCarriedReward();
1318     return _totalRewardAdded.add(carriedReward);
1319   }
1320 
1321   function _getLatestTerm() internal view returns (uint256) {
1322     return (block.timestamp - _startTimestamp) / _termInterval;
1323   }
1324 
1325   /* ========== CALL FUNCTIONS ========== */
1326 
1327   /**
1328    * @return stakingTokenAddress is the token locked for staking
1329    */
1330   function getStakingTokenAddress() external view override returns (address stakingTokenAddress) {
1331     return address(_stakingToken);
1332   }
1333 
1334   /**
1335    * @return startTimestamp is the time when this contract was deployed
1336    * @return termInterval is the duration of a term
1337    */
1338   function getConfigs()
1339     external
1340     view
1341     override
1342     returns (uint256 startTimestamp, uint256 termInterval)
1343   {
1344     startTimestamp = _startTimestamp;
1345     termInterval = _termInterval;
1346   }
1347 
1348   function getTotalRewardAdded() external view returns (uint256 totalRewardAdded) {
1349     return _totalRewardAdded;
1350   }
1351 
1352   /**
1353    * @return currentTerm is the current latest term
1354    * @return latestTerm is the potential latest term
1355    * @return totalRemainingRewards is the as-of remaining rewards and withdrawal
1356    * @return currentTermRewards is the total rewards at the current term
1357    * @return nextTermRewards is the as-of total rewards to be paid at the next term
1358    * @return currentStaking is the total active staking amount
1359    * @return nextTermStaking is the total staking amount
1360    */
1361   function getTokenInfo()
1362     external
1363     view
1364     override
1365     returns (
1366       uint256 currentTerm,
1367       uint256 latestTerm,
1368       uint256 totalRemainingRewards,
1369       uint256 currentTermRewards,
1370       uint256 nextTermRewards,
1371       uint128 currentStaking,
1372       uint128 nextTermStaking
1373     )
1374   {
1375     currentTerm = _currentTerm;
1376     latestTerm = _getLatestTerm();
1377     totalRemainingRewards = _totalRemaining;
1378     TermInfo memory termInfo = _termInfoList[_currentTerm];
1379     currentTermRewards = termInfo.rewardSum;
1380     nextTermRewards = _getNextTermReward();
1381     currentStaking = termInfo.stakeSum;
1382     nextTermStaking = termInfo
1383       .stakeSum
1384       .add(termInfo.stakeAdd)
1385       .sub(termInfo.stakeRemove)
1386       .toUint128();
1387   }
1388 
1389   /**
1390    * @notice Returns _termInfoList[term].
1391    */
1392   function getTermInfo(uint256 term)
1393     external
1394     view
1395     override
1396     returns (
1397       int128 stakeAdd,
1398       uint128 stakeSum,
1399       uint256 rewardSum
1400     )
1401   {
1402     TermInfo memory termInfo = _termInfoList[term];
1403     stakeAdd = int256(termInfo.stakeAdd).sub(termInfo.stakeRemove).toInt128();
1404     stakeSum = termInfo.stakeSum;
1405     if (term == _currentTerm.add(1)) {
1406       rewardSum = _getNextTermReward();
1407     } else {
1408       rewardSum = termInfo.rewardSum;
1409     }
1410   }
1411 
1412   /**
1413    * @return userTerm is the latest term the user has updated to
1414    * @return stakeAmount is the latest amount of staking from the user has updated to
1415    * @return nextAddedStakeAmount is the next amount of adding to stake from the user has updated to
1416    * @return remaining is the reward and withdrawal getting by the user has updated to
1417    * @return currentTermUserRewards is the as-of user rewards to be paid at `_currentTerm`
1418    * @return nextTermUserRewards is the as-of user rewards to be paid at the next term of `_currentTerm`
1419    * @return depositAmount is the staking amount
1420    * @return withdrawableStakingAmount is the withdrawable staking amount
1421    */
1422   function getAccountInfo(address account)
1423     external
1424     view
1425     override
1426     returns (
1427       uint256 userTerm,
1428       uint256 stakeAmount,
1429       int128 nextAddedStakeAmount,
1430       uint256 remaining,
1431       uint256 currentTermUserRewards,
1432       uint256 nextTermUserRewards,
1433       uint128 depositAmount,
1434       uint128 withdrawableStakingAmount
1435     )
1436   {
1437     AccountInfo memory accountInfo = _accountInfoList[account];
1438     userTerm = accountInfo.userTerm;
1439     stakeAmount = accountInfo.stakeAmount;
1440     nextAddedStakeAmount = accountInfo.added;
1441     depositAmount = addDiff(stakeAmount, nextAddedStakeAmount).toUint128();
1442     withdrawableStakingAmount = depositAmount;
1443     remaining = accountInfo.remaining;
1444 
1445     TermInfo memory termInfo = _termInfoList[_currentTerm];
1446     uint256 currentTermRewards = termInfo.rewardSum;
1447     uint256 currentStakeSum = termInfo.stakeSum;
1448     currentTermUserRewards = currentStakeSum == 0
1449       ? 0
1450       : currentTermRewards.mul(userTerm < _currentTerm ? depositAmount : stakeAmount) /
1451         currentStakeSum;
1452     uint256 nextTermRewards = _getNextTermReward();
1453     uint256 nextStakeSum = currentStakeSum.add(termInfo.stakeAdd).sub(termInfo.stakeRemove);
1454     nextTermUserRewards = nextStakeSum == 0 ? 0 : nextTermRewards.mul(depositAmount) / nextStakeSum;
1455     // uint256 latestTermUserRewards = _getLatestTerm() > _currentTerm
1456     //   ? nextTermUserRewards
1457     //   : currentTermUserRewards;
1458   }
1459 
1460   /**
1461    * @dev Returns `base` added to `diff` which may be nagative number.
1462    */
1463   function addDiff(uint256 base, int256 diff) internal pure returns (uint256) {
1464     if (diff >= 0) {
1465       return base.add(uint256(diff));
1466     } else {
1467       return base.sub(uint256(-diff));
1468     }
1469   }
1470 }
1471 
1472 // File: contracts/Staking/StakingWithAggregator.sol
1473 
1474 
1475 
1476 
1477 
1478 
1479 
1480 contract StakingWithAggregator is Ownable, Staking {
1481   using SafeERC20 for IERC20;
1482 
1483   event Recovered(address tokenAddress, uint256 tokenAmount);
1484 
1485   constructor(
1486     IERC20 stakingToken,
1487     uint256 startTimestamp,
1488     uint256 termInterval
1489   ) Staking(stakingToken, startTimestamp, termInterval) {}
1490 
1491   /* ========== MUTATIVE FUNCTIONS ========== */
1492 
1493   /**
1494    * @notice Stake the staking token for the token to be paid as reward.
1495    */
1496   function stakeViaAggregator(address account, uint128 amount)
1497     external
1498     onlyOwner
1499     nonReentrant
1500     updateTerm()
1501     updateReward(account)
1502     returns (uint128 sendBack)
1503   {
1504     require(amount != 0, "staking amount should be positive number");
1505 
1506     sendBack = _stake(account, amount);
1507     // _stakingToken.safeTransferFrom(msg.sender, address(this), amount - sendBack);
1508   }
1509 
1510   /**
1511    * @notice Withdraw the staking token for the token to be paid as reward.
1512    */
1513   function withdrawViaAggregator(address account, uint128 amount)
1514     external
1515     onlyOwner
1516     nonReentrant
1517     updateTerm()
1518     updateReward(account)
1519     returns (uint128 sendBack)
1520   {
1521     require(amount != 0, "withdrawing amount should be positive number");
1522 
1523     return _withdraw(account, amount);
1524   }
1525 
1526   /**
1527    * @notice Receive the reward for your staking in the token.
1528    */
1529   function receiveRewardViaAggregator(address account)
1530     external
1531     onlyOwner
1532     nonReentrant
1533     updateTerm()
1534     updateReward(account)
1535     returns (uint256 remaining)
1536   {
1537     return _receiveReward(account);
1538   }
1539 
1540   function addRewardViaAggregator(address account, uint128 amount)
1541     external
1542     onlyOwner
1543     nonReentrant
1544     updateTerm()
1545   {
1546     // _stakingToken.safeTransferFrom(msg.sender, address(this), amount);
1547     return _addReward(account, amount);
1548   }
1549 
1550   /**
1551    * @notice If you have accidentally transferred token which is not `_stakingToken`,
1552    * you can use this function to get it back.
1553    */
1554   function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
1555     require(tokenAddress != address(_stakingToken), "Cannot recover the staking token");
1556     IERC20(tokenAddress).safeTransfer(msg.sender, tokenAmount);
1557     emit Recovered(tokenAddress, tokenAmount);
1558   }
1559 }
1560 
1561 // File: contracts/Interfaces/StakingAggregatorInterface.sol
1562 
1563 
1564 
1565 
1566 
1567 interface StakingAggregatorInterface {
1568   function stake(uint128 amount) external returns (uint128 totalSendBack);
1569 
1570   function withdraw(uint128 amount) external returns (uint256 totalSendBack);
1571 
1572   function receiveReward() external returns (uint256 remaining);
1573 
1574   function addReward(uint256 stakingContractIndex, uint128 amount) external;
1575 
1576   function getStakingTokenAddress() external view returns (address);
1577 
1578   function getStakingContracts() external view returns (StakingWithAggregator[] memory);
1579 
1580   function getConfigs()
1581     external
1582     view
1583     returns (uint256[] memory startTimestampList, uint256 termInterval);
1584 
1585   function getTokenInfo()
1586     external
1587     view
1588     returns (
1589       uint256[] memory latestTermList,
1590       uint256[] memory totalRemainingRewardsList,
1591       uint256[] memory currentTermRewardsList,
1592       uint256[] memory nextTermRewardsList,
1593       uint128[] memory currentStakingList,
1594       uint128[] memory nextTermStakingList
1595     );
1596 
1597   function getTermInfo(uint256 term)
1598     external
1599     view
1600     returns (
1601       int128[] memory stakeAddList,
1602       uint128[] memory stakeSumList,
1603       uint256[] memory rewardSumList
1604     );
1605 
1606   function getAccountInfo(address account)
1607     external
1608     view
1609     returns (
1610       uint256[] memory userTermList,
1611       uint256[] memory stakeAmountList,
1612       int128[] memory nextAddedStakeAmountList,
1613       uint256[] memory currentTermUserRewardsList,
1614       uint256[] memory nextTermUserRewardsList,
1615       uint128[] memory withdrawableStakingAmountList
1616     );
1617 }
1618 
1619 // File: contracts/Staking/StakingAggregator.sol
1620 
1621 
1622 
1623 
1624 
1625 
1626 
1627 
1628 
1629 contract StakingAggregator is StakingAggregatorInterface {
1630   using SafeMath for uint256;
1631   using SafeERC20 for IERC20;
1632 
1633   /* ========== CONSTANT VARIABLES ========== */
1634 
1635   uint256 internal immutable _termInterval;
1636   IERC20 internal immutable _stakingToken;
1637   StakingWithAggregator[] internal _stakingContracts; // immutable
1638   uint256[] internal _startTimestampList; // immutable
1639 
1640   /* ========== STATE VARIABLES ========== */
1641 
1642   /**
1643    * @dev if this contract is initialized
1644    */
1645   bool internal _enabled = false;
1646 
1647   /* ========== CONSTRUCTOR ========== */
1648 
1649   constructor(
1650     IERC20 stakingToken,
1651     uint256 termInterval,
1652     StakingWithAggregator[] memory stakingContracts
1653   ) {
1654     require(stakingContracts.length != 0, "staking contracts should not be empty");
1655     _stakingToken = stakingToken;
1656     _termInterval = termInterval;
1657     uint256 oldStartTimestamp = 0;
1658     for (uint256 i = 0; i < stakingContracts.length; i++) {
1659       require(
1660         stakingContracts[i].getStakingTokenAddress() == address(stakingToken),
1661         "staking token address differ from expected"
1662       );
1663       (uint256 ithStartTimestamp, uint256 ithTermInterval) = stakingContracts[i].getConfigs();
1664       require(ithTermInterval == termInterval, "term interval differ from expected");
1665       require(ithStartTimestamp > oldStartTimestamp, "startTimestamp should be sorted");
1666       oldStartTimestamp = ithStartTimestamp;
1667       _startTimestampList.push(ithStartTimestamp);
1668       _stakingContracts.push(stakingContracts[i]);
1669       // stakingToken.safeApprove(address(stakingContracts[i]), type(uint256).max);
1670     }
1671   }
1672 
1673   modifier isEnabled() {
1674     require(_enabled, "aggregator is not initialized");
1675     _;
1676   }
1677 
1678   /* ========== MUTATIVE FUNCTIONS ========== */
1679 
1680   function init() external {
1681     require(!_enabled, "already initialized");
1682 
1683     for (uint256 i = 0; i < _stakingContracts.length; i++) {
1684       require(_stakingContracts[i].owner() == address(this), "not owner");
1685     }
1686 
1687     _enabled = true;
1688   }
1689 
1690   /**
1691    * @notice Stake the staking token for the token to be paid as reward.
1692    */
1693   function stake(uint128 amount) external override isEnabled returns (uint128 totalSendBack) {
1694     uint256 maxUntilNextTerm;
1695     uint256 nextStakingContractIndex;
1696     for (uint256 i = 0; i < _startTimestampList.length; i++) {
1697       // assert(_startTimestampList[i] <= block.timestamp);
1698       uint256 untilNextTerm = (block.timestamp - _startTimestampList[i]) % _termInterval;
1699       if (untilNextTerm > maxUntilNextTerm) {
1700         maxUntilNextTerm = untilNextTerm;
1701         nextStakingContractIndex = i;
1702       }
1703     }
1704 
1705     totalSendBack = _stakingContracts[nextStakingContractIndex].stakeViaAggregator(
1706       msg.sender,
1707       amount
1708     );
1709 
1710     if (amount - totalSendBack != 0) {
1711       _stakingToken.safeTransferFrom(msg.sender, address(this), amount - totalSendBack);
1712     }
1713   }
1714 
1715   /**
1716    * @notice Withdraw the staking token for the token to be paid as reward.
1717    * @return totalSendBack is the amount returned instantly.
1718    */
1719   function withdraw(uint128 amount) external override isEnabled returns (uint256 totalSendBack) {
1720     require(amount != 0, "withdrawing amount should be positive number");
1721 
1722     uint256 maxUntilNextTerm;
1723     uint256 nextStakingContractIndex;
1724     for (uint256 i = 0; i < _startTimestampList.length; i++) {
1725       // assert(_startTimestampList[i] <= block.timestamp);
1726       uint256 untilNextTerm = (block.timestamp - _startTimestampList[i]) % _termInterval;
1727       if (untilNextTerm > maxUntilNextTerm) {
1728         maxUntilNextTerm = untilNextTerm;
1729         nextStakingContractIndex = i;
1730       }
1731     }
1732 
1733     for (
1734       uint256 i = nextStakingContractIndex;
1735       i < nextStakingContractIndex + _startTimestampList.length && amount != 0;
1736       i++
1737     ) {
1738       StakingWithAggregator ithStakingContract = _stakingContracts[i % _startTimestampList.length];
1739       (, , , , , , uint128 withdrawableAmount, ) = ithStakingContract.getAccountInfo(msg.sender);
1740       uint128 ithAmount = (amount < withdrawableAmount) ? amount : withdrawableAmount;
1741       // assert(amount >= ithAmount);
1742       amount -= ithAmount;
1743 
1744       if (ithAmount != 0) {
1745         uint128 sendBack = ithStakingContract.withdrawViaAggregator(msg.sender, ithAmount);
1746         totalSendBack = totalSendBack.add(sendBack);
1747       }
1748     }
1749 
1750     require(amount == 0, "exceed withdrawable amount");
1751 
1752     if (totalSendBack != 0) {
1753       _stakingToken.safeTransfer(msg.sender, totalSendBack);
1754     }
1755   }
1756 
1757   /**
1758    * @notice Receive the reward for your staking in the token.
1759    */
1760   function receiveReward() external override isEnabled returns (uint256 remaining) {
1761     for (uint256 i = 0; i < _stakingContracts.length; i++) {
1762       remaining = remaining.add(_stakingContracts[i].receiveRewardViaAggregator(msg.sender));
1763     }
1764 
1765     if (remaining != 0) {
1766       _stakingToken.safeTransfer(msg.sender, remaining);
1767     }
1768   }
1769 
1770   /**
1771    * @notice Add the reward to this contract.
1772    */
1773   function addReward(uint256 stakingContractIndex, uint128 amount) external override isEnabled {
1774     require(
1775       stakingContractIndex < _stakingContracts.length,
1776       "stakingContractIndex is out of index"
1777     );
1778     _stakingToken.safeTransferFrom(msg.sender, address(this), amount);
1779     return _stakingContracts[stakingContractIndex].addRewardViaAggregator(msg.sender, amount);
1780   }
1781 
1782   function getStakingTokenAddress() external view override returns (address) {
1783     return address(_stakingToken);
1784   }
1785 
1786   function getStakingContracts()
1787     external
1788     view
1789     override
1790     returns (StakingWithAggregator[] memory stakingContracts)
1791   {
1792     return _stakingContracts;
1793   }
1794 
1795   function getConfigs()
1796     external
1797     view
1798     override
1799     returns (uint256[] memory startTimestampList, uint256 termInterval)
1800   {
1801     startTimestampList = _startTimestampList;
1802     termInterval = _termInterval;
1803   }
1804 
1805   function getTokenInfo()
1806     external
1807     view
1808     override
1809     returns (
1810       uint256[] memory latestTermList,
1811       uint256[] memory totalRemainingRewardsList,
1812       uint256[] memory currentTermRewardsList,
1813       uint256[] memory nextTermRewardsList,
1814       uint128[] memory currentStakingList,
1815       uint128[] memory nextTermStakingList
1816     )
1817   {
1818     uint256 numOfStakingContracts = _stakingContracts.length;
1819     latestTermList = new uint256[](numOfStakingContracts);
1820     totalRemainingRewardsList = new uint256[](numOfStakingContracts);
1821     currentTermRewardsList = new uint256[](numOfStakingContracts);
1822     nextTermRewardsList = new uint256[](numOfStakingContracts);
1823     currentStakingList = new uint128[](numOfStakingContracts);
1824     nextTermStakingList = new uint128[](numOfStakingContracts);
1825     for (uint256 i = 0; i < numOfStakingContracts; i++) {
1826       (
1827         ,
1828         uint256 latestTerm,
1829         uint256 totalRemainingRewards,
1830         uint256 currentTermRewards,
1831         uint256 nextTermRewards,
1832         uint128 currentStaking,
1833         uint128 nextTermStaking
1834       ) = _stakingContracts[i].getTokenInfo();
1835       latestTermList[i] = latestTerm;
1836       totalRemainingRewardsList[i] = totalRemainingRewards;
1837       currentTermRewardsList[i] = currentTermRewards;
1838       nextTermRewardsList[i] = nextTermRewards;
1839       currentStakingList[i] = currentStaking;
1840       nextTermStakingList[i] = nextTermStaking;
1841     }
1842   }
1843 
1844   function getTermInfo(uint256 term)
1845     external
1846     view
1847     override
1848     returns (
1849       int128[] memory stakeAddList,
1850       uint128[] memory stakeSumList,
1851       uint256[] memory rewardSumList
1852     )
1853   {
1854     uint256 numOfStakingContracts = _stakingContracts.length;
1855     stakeAddList = new int128[](numOfStakingContracts);
1856     stakeSumList = new uint128[](numOfStakingContracts);
1857     rewardSumList = new uint256[](numOfStakingContracts);
1858     for (uint256 i = 0; i < numOfStakingContracts; i++) {
1859       (int128 stakeAdd, uint128 stakeSum, uint256 rewardSum) = _stakingContracts[i].getTermInfo(
1860         term
1861       );
1862       stakeAddList[i] = stakeAdd;
1863       stakeSumList[i] = stakeSum;
1864       rewardSumList[i] = rewardSum;
1865     }
1866   }
1867 
1868   function getAccountInfo(address account)
1869     external
1870     view
1871     override
1872     returns (
1873       uint256[] memory userTermList,
1874       uint256[] memory stakeAmountList,
1875       int128[] memory nextAddedStakeAmountList,
1876       uint256[] memory currentTermUserRewardsList,
1877       uint256[] memory nextTermUserRewardsList,
1878       uint128[] memory withdrawableStakingAmountList
1879     )
1880   {
1881     uint256 numOfStakingContracts = _stakingContracts.length;
1882     userTermList = new uint256[](numOfStakingContracts);
1883     stakeAmountList = new uint256[](numOfStakingContracts);
1884     nextAddedStakeAmountList = new int128[](numOfStakingContracts);
1885     currentTermUserRewardsList = new uint256[](numOfStakingContracts);
1886     nextTermUserRewardsList = new uint256[](numOfStakingContracts);
1887     withdrawableStakingAmountList = new uint128[](numOfStakingContracts);
1888     for (uint256 i = 0; i < numOfStakingContracts; i++) {
1889       address accountTmp = account;
1890       (
1891         uint256 userTerm,
1892         uint256 stakeAmount,
1893         int128 nextAddedStakeAmount,
1894         ,
1895         uint256 currentTermUserRewards,
1896         uint256 nextTermUserRewards,
1897         ,
1898         uint128 withdrawableStakingAmount
1899       ) = _stakingContracts[i].getAccountInfo(accountTmp);
1900       userTermList[i] = userTerm;
1901       stakeAmountList[i] = stakeAmount;
1902       nextAddedStakeAmountList[i] = nextAddedStakeAmount;
1903       currentTermUserRewardsList[i] = currentTermUserRewards;
1904       nextTermUserRewardsList[i] = nextTermUserRewards;
1905       withdrawableStakingAmountList[i] = withdrawableStakingAmount;
1906     }
1907   }
1908 }