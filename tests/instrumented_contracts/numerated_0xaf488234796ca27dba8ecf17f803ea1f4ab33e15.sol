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
271         // This method relies in extcodesize, which returns 0 for contracts in
272         // construction, since the code is only stored at the end of the
273         // constructor execution.
274 
275         uint256 size;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { size := extcodesize(account) }
278         return size > 0;
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
464 // File: @openzeppelin/contracts/utils/Counters.sol
465 
466 // SPDX-License-Identifier: MIT
467 
468 pragma solidity ^0.6.0;
469 
470 
471 /**
472  * @title Counters
473  * @author Matt Condon (@shrugs)
474  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
475  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
476  *
477  * Include with `using Counters for Counters.Counter;`
478  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
479  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
480  * directly accessed.
481  */
482 library Counters {
483     using SafeMath for uint256;
484 
485     struct Counter {
486         // This variable should never be directly accessed by users of the library: interactions must be restricted to
487         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
488         // this feature: see https://github.com/ethereum/solidity/issues/4637
489         uint256 _value; // default: 0
490     }
491 
492     function current(Counter storage counter) internal view returns (uint256) {
493         return counter._value;
494     }
495 
496     function increment(Counter storage counter) internal {
497         // The {SafeMath} overflow check can be skipped here, see the comment at the top
498         counter._value += 1;
499     }
500 
501     function decrement(Counter storage counter) internal {
502         counter._value = counter._value.sub(1);
503     }
504 }
505 
506 // File: @openzeppelin/contracts/GSN/Context.sol
507 
508 // SPDX-License-Identifier: MIT
509 
510 pragma solidity ^0.6.0;
511 
512 /*
513  * @dev Provides information about the current execution context, including the
514  * sender of the transaction and its data. While these are generally available
515  * via msg.sender and msg.data, they should not be accessed in such a direct
516  * manner, since when dealing with GSN meta-transactions the account sending and
517  * paying for execution may not be the actual sender (as far as an application
518  * is concerned).
519  *
520  * This contract is only required for intermediate, library-like contracts.
521  */
522 abstract contract Context {
523     function _msgSender() internal view virtual returns (address payable) {
524         return msg.sender;
525     }
526 
527     function _msgData() internal view virtual returns (bytes memory) {
528         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
529         return msg.data;
530     }
531 }
532 
533 // File: @openzeppelin/contracts/access/Ownable.sol
534 
535 // SPDX-License-Identifier: MIT
536 
537 pragma solidity ^0.6.0;
538 
539 /**
540  * @dev Contract module which provides a basic access control mechanism, where
541  * there is an account (an owner) that can be granted exclusive access to
542  * specific functions.
543  *
544  * By default, the owner account will be the one that deploys the contract. This
545  * can later be changed with {transferOwnership}.
546  *
547  * This module is used through inheritance. It will make available the modifier
548  * `onlyOwner`, which can be applied to your functions to restrict their use to
549  * the owner.
550  */
551 contract Ownable is Context {
552     address private _owner;
553 
554     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
555 
556     /**
557      * @dev Initializes the contract setting the deployer as the initial owner.
558      */
559     constructor () internal {
560         address msgSender = _msgSender();
561         _owner = msgSender;
562         emit OwnershipTransferred(address(0), msgSender);
563     }
564 
565     /**
566      * @dev Returns the address of the current owner.
567      */
568     function owner() public view returns (address) {
569         return _owner;
570     }
571 
572     /**
573      * @dev Throws if called by any account other than the owner.
574      */
575     modifier onlyOwner() {
576         require(_owner == _msgSender(), "Ownable: caller is not the owner");
577         _;
578     }
579 
580     /**
581      * @dev Leaves the contract without owner. It will not be possible to call
582      * `onlyOwner` functions anymore. Can only be called by the current owner.
583      *
584      * NOTE: Renouncing ownership will leave the contract without an owner,
585      * thereby removing any functionality that is only available to the owner.
586      */
587     function renounceOwnership() public virtual onlyOwner {
588         emit OwnershipTransferred(_owner, address(0));
589         _owner = address(0);
590     }
591 
592     /**
593      * @dev Transfers ownership of the contract to a new account (`newOwner`).
594      * Can only be called by the current owner.
595      */
596     function transferOwnership(address newOwner) public virtual onlyOwner {
597         require(newOwner != address(0), "Ownable: new owner is the zero address");
598         emit OwnershipTransferred(_owner, newOwner);
599         _owner = newOwner;
600     }
601 }
602 
603 // File: @openzeppelin/contracts/introspection/IERC165.sol
604 
605 // SPDX-License-Identifier: MIT
606 
607 pragma solidity ^0.6.0;
608 
609 /**
610  * @dev Interface of the ERC165 standard, as defined in the
611  * https://eips.ethereum.org/EIPS/eip-165[EIP].
612  *
613  * Implementers can declare support of contract interfaces, which can then be
614  * queried by others ({ERC165Checker}).
615  *
616  * For an implementation, see {ERC165}.
617  */
618 interface IERC165 {
619     /**
620      * @dev Returns true if this contract implements the interface defined by
621      * `interfaceId`. See the corresponding
622      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
623      * to learn more about how these ids are created.
624      *
625      * This function call must use less than 30 000 gas.
626      */
627     function supportsInterface(bytes4 interfaceId) external view returns (bool);
628 }
629 
630 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
631 
632 // SPDX-License-Identifier: MIT
633 
634 pragma solidity ^0.6.2;
635 
636 
637 /**
638  * @dev Required interface of an ERC721 compliant contract.
639  */
640 interface IERC721 is IERC165 {
641     /**
642      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
643      */
644     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
645 
646     /**
647      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
648      */
649     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
650 
651     /**
652      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
653      */
654     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
655 
656     /**
657      * @dev Returns the number of tokens in ``owner``'s account.
658      */
659     function balanceOf(address owner) external view returns (uint256 balance);
660 
661     /**
662      * @dev Returns the owner of the `tokenId` token.
663      *
664      * Requirements:
665      *
666      * - `tokenId` must exist.
667      */
668     function ownerOf(uint256 tokenId) external view returns (address owner);
669 
670     /**
671      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
672      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
673      *
674      * Requirements:
675      *
676      * - `from` cannot be the zero address.
677      * - `to` cannot be the zero address.
678      * - `tokenId` token must exist and be owned by `from`.
679      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
680      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
681      *
682      * Emits a {Transfer} event.
683      */
684     function safeTransferFrom(address from, address to, uint256 tokenId) external;
685 
686     /**
687      * @dev Transfers `tokenId` token from `from` to `to`.
688      *
689      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
690      *
691      * Requirements:
692      *
693      * - `from` cannot be the zero address.
694      * - `to` cannot be the zero address.
695      * - `tokenId` token must be owned by `from`.
696      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
697      *
698      * Emits a {Transfer} event.
699      */
700     function transferFrom(address from, address to, uint256 tokenId) external;
701 
702     /**
703      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
704      * The approval is cleared when the token is transferred.
705      *
706      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
707      *
708      * Requirements:
709      *
710      * - The caller must own the token or be an approved operator.
711      * - `tokenId` must exist.
712      *
713      * Emits an {Approval} event.
714      */
715     function approve(address to, uint256 tokenId) external;
716 
717     /**
718      * @dev Returns the account approved for `tokenId` token.
719      *
720      * Requirements:
721      *
722      * - `tokenId` must exist.
723      */
724     function getApproved(uint256 tokenId) external view returns (address operator);
725 
726     /**
727      * @dev Approve or remove `operator` as an operator for the caller.
728      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
729      *
730      * Requirements:
731      *
732      * - The `operator` cannot be the caller.
733      *
734      * Emits an {ApprovalForAll} event.
735      */
736     function setApprovalForAll(address operator, bool _approved) external;
737 
738     /**
739      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
740      *
741      * See {setApprovalForAll}
742      */
743     function isApprovedForAll(address owner, address operator) external view returns (bool);
744 
745     /**
746       * @dev Safely transfers `tokenId` token from `from` to `to`.
747       *
748       * Requirements:
749       *
750      * - `from` cannot be the zero address.
751      * - `to` cannot be the zero address.
752       * - `tokenId` token must exist and be owned by `from`.
753       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
754       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
755       *
756       * Emits a {Transfer} event.
757       */
758     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
759 }
760 
761 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
762 
763 // SPDX-License-Identifier: MIT
764 
765 pragma solidity ^0.6.2;
766 
767 
768 /**
769  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
770  * @dev See https://eips.ethereum.org/EIPS/eip-721
771  */
772 interface IERC721Metadata is IERC721 {
773 
774     /**
775      * @dev Returns the token collection name.
776      */
777     function name() external view returns (string memory);
778 
779     /**
780      * @dev Returns the token collection symbol.
781      */
782     function symbol() external view returns (string memory);
783 
784     /**
785      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
786      */
787     function tokenURI(uint256 tokenId) external view returns (string memory);
788 }
789 
790 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
791 
792 // SPDX-License-Identifier: MIT
793 
794 pragma solidity ^0.6.2;
795 
796 
797 /**
798  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
799  * @dev See https://eips.ethereum.org/EIPS/eip-721
800  */
801 interface IERC721Enumerable is IERC721 {
802 
803     /**
804      * @dev Returns the total amount of tokens stored by the contract.
805      */
806     function totalSupply() external view returns (uint256);
807 
808     /**
809      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
810      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
811      */
812     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
813 
814     /**
815      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
816      * Use along with {totalSupply} to enumerate all tokens.
817      */
818     function tokenByIndex(uint256 index) external view returns (uint256);
819 }
820 
821 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
822 
823 // SPDX-License-Identifier: MIT
824 
825 pragma solidity ^0.6.0;
826 
827 /**
828  * @title ERC721 token receiver interface
829  * @dev Interface for any contract that wants to support safeTransfers
830  * from ERC721 asset contracts.
831  */
832 interface IERC721Receiver {
833     /**
834      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
835      * by `operator` from `from`, this function is called.
836      *
837      * It must return its Solidity selector to confirm the token transfer.
838      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
839      *
840      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
841      */
842     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
843     external returns (bytes4);
844 }
845 
846 // File: @openzeppelin/contracts/introspection/ERC165.sol
847 
848 // SPDX-License-Identifier: MIT
849 
850 pragma solidity ^0.6.0;
851 
852 
853 /**
854  * @dev Implementation of the {IERC165} interface.
855  *
856  * Contracts may inherit from this and call {_registerInterface} to declare
857  * their support of an interface.
858  */
859 contract ERC165 is IERC165 {
860     /*
861      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
862      */
863     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
864 
865     /**
866      * @dev Mapping of interface ids to whether or not it's supported.
867      */
868     mapping(bytes4 => bool) private _supportedInterfaces;
869 
870     constructor () internal {
871         // Derived contracts need only register support for their own interfaces,
872         // we register support for ERC165 itself here
873         _registerInterface(_INTERFACE_ID_ERC165);
874     }
875 
876     /**
877      * @dev See {IERC165-supportsInterface}.
878      *
879      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
880      */
881     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
882         return _supportedInterfaces[interfaceId];
883     }
884 
885     /**
886      * @dev Registers the contract as an implementer of the interface defined by
887      * `interfaceId`. Support of the actual ERC165 interface is automatic and
888      * registering its interface id is not required.
889      *
890      * See {IERC165-supportsInterface}.
891      *
892      * Requirements:
893      *
894      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
895      */
896     function _registerInterface(bytes4 interfaceId) internal virtual {
897         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
898         _supportedInterfaces[interfaceId] = true;
899     }
900 }
901 
902 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
903 
904 // SPDX-License-Identifier: MIT
905 
906 pragma solidity ^0.6.0;
907 
908 /**
909  * @dev Library for managing
910  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
911  * types.
912  *
913  * Sets have the following properties:
914  *
915  * - Elements are added, removed, and checked for existence in constant time
916  * (O(1)).
917  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
918  *
919  * ```
920  * contract Example {
921  *     // Add the library methods
922  *     using EnumerableSet for EnumerableSet.AddressSet;
923  *
924  *     // Declare a set state variable
925  *     EnumerableSet.AddressSet private mySet;
926  * }
927  * ```
928  *
929  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
930  * (`UintSet`) are supported.
931  */
932 library EnumerableSet {
933     // To implement this library for multiple types with as little code
934     // repetition as possible, we write it in terms of a generic Set type with
935     // bytes32 values.
936     // The Set implementation uses private functions, and user-facing
937     // implementations (such as AddressSet) are just wrappers around the
938     // underlying Set.
939     // This means that we can only create new EnumerableSets for types that fit
940     // in bytes32.
941 
942     struct Set {
943         // Storage of set values
944         bytes32[] _values;
945 
946         // Position of the value in the `values` array, plus 1 because index 0
947         // means a value is not in the set.
948         mapping (bytes32 => uint256) _indexes;
949     }
950 
951     /**
952      * @dev Add a value to a set. O(1).
953      *
954      * Returns true if the value was added to the set, that is if it was not
955      * already present.
956      */
957     function _add(Set storage set, bytes32 value) private returns (bool) {
958         if (!_contains(set, value)) {
959             set._values.push(value);
960             // The value is stored at length-1, but we add 1 to all indexes
961             // and use 0 as a sentinel value
962             set._indexes[value] = set._values.length;
963             return true;
964         } else {
965             return false;
966         }
967     }
968 
969     /**
970      * @dev Removes a value from a set. O(1).
971      *
972      * Returns true if the value was removed from the set, that is if it was
973      * present.
974      */
975     function _remove(Set storage set, bytes32 value) private returns (bool) {
976         // We read and store the value's index to prevent multiple reads from the same storage slot
977         uint256 valueIndex = set._indexes[value];
978 
979         if (valueIndex != 0) { // Equivalent to contains(set, value)
980             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
981             // the array, and then remove the last element (sometimes called as 'swap and pop').
982             // This modifies the order of the array, as noted in {at}.
983 
984             uint256 toDeleteIndex = valueIndex - 1;
985             uint256 lastIndex = set._values.length - 1;
986 
987             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
988             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
989 
990             bytes32 lastvalue = set._values[lastIndex];
991 
992             // Move the last value to the index where the value to delete is
993             set._values[toDeleteIndex] = lastvalue;
994             // Update the index for the moved value
995             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
996 
997             // Delete the slot where the moved value was stored
998             set._values.pop();
999 
1000             // Delete the index for the deleted slot
1001             delete set._indexes[value];
1002 
1003             return true;
1004         } else {
1005             return false;
1006         }
1007     }
1008 
1009     /**
1010      * @dev Returns true if the value is in the set. O(1).
1011      */
1012     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1013         return set._indexes[value] != 0;
1014     }
1015 
1016     /**
1017      * @dev Returns the number of values on the set. O(1).
1018      */
1019     function _length(Set storage set) private view returns (uint256) {
1020         return set._values.length;
1021     }
1022 
1023    /**
1024     * @dev Returns the value stored at position `index` in the set. O(1).
1025     *
1026     * Note that there are no guarantees on the ordering of values inside the
1027     * array, and it may change when more values are added or removed.
1028     *
1029     * Requirements:
1030     *
1031     * - `index` must be strictly less than {length}.
1032     */
1033     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1034         require(set._values.length > index, "EnumerableSet: index out of bounds");
1035         return set._values[index];
1036     }
1037 
1038     // AddressSet
1039 
1040     struct AddressSet {
1041         Set _inner;
1042     }
1043 
1044     /**
1045      * @dev Add a value to a set. O(1).
1046      *
1047      * Returns true if the value was added to the set, that is if it was not
1048      * already present.
1049      */
1050     function add(AddressSet storage set, address value) internal returns (bool) {
1051         return _add(set._inner, bytes32(uint256(value)));
1052     }
1053 
1054     /**
1055      * @dev Removes a value from a set. O(1).
1056      *
1057      * Returns true if the value was removed from the set, that is if it was
1058      * present.
1059      */
1060     function remove(AddressSet storage set, address value) internal returns (bool) {
1061         return _remove(set._inner, bytes32(uint256(value)));
1062     }
1063 
1064     /**
1065      * @dev Returns true if the value is in the set. O(1).
1066      */
1067     function contains(AddressSet storage set, address value) internal view returns (bool) {
1068         return _contains(set._inner, bytes32(uint256(value)));
1069     }
1070 
1071     /**
1072      * @dev Returns the number of values in the set. O(1).
1073      */
1074     function length(AddressSet storage set) internal view returns (uint256) {
1075         return _length(set._inner);
1076     }
1077 
1078    /**
1079     * @dev Returns the value stored at position `index` in the set. O(1).
1080     *
1081     * Note that there are no guarantees on the ordering of values inside the
1082     * array, and it may change when more values are added or removed.
1083     *
1084     * Requirements:
1085     *
1086     * - `index` must be strictly less than {length}.
1087     */
1088     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1089         return address(uint256(_at(set._inner, index)));
1090     }
1091 
1092 
1093     // UintSet
1094 
1095     struct UintSet {
1096         Set _inner;
1097     }
1098 
1099     /**
1100      * @dev Add a value to a set. O(1).
1101      *
1102      * Returns true if the value was added to the set, that is if it was not
1103      * already present.
1104      */
1105     function add(UintSet storage set, uint256 value) internal returns (bool) {
1106         return _add(set._inner, bytes32(value));
1107     }
1108 
1109     /**
1110      * @dev Removes a value from a set. O(1).
1111      *
1112      * Returns true if the value was removed from the set, that is if it was
1113      * present.
1114      */
1115     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1116         return _remove(set._inner, bytes32(value));
1117     }
1118 
1119     /**
1120      * @dev Returns true if the value is in the set. O(1).
1121      */
1122     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1123         return _contains(set._inner, bytes32(value));
1124     }
1125 
1126     /**
1127      * @dev Returns the number of values on the set. O(1).
1128      */
1129     function length(UintSet storage set) internal view returns (uint256) {
1130         return _length(set._inner);
1131     }
1132 
1133    /**
1134     * @dev Returns the value stored at position `index` in the set. O(1).
1135     *
1136     * Note that there are no guarantees on the ordering of values inside the
1137     * array, and it may change when more values are added or removed.
1138     *
1139     * Requirements:
1140     *
1141     * - `index` must be strictly less than {length}.
1142     */
1143     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1144         return uint256(_at(set._inner, index));
1145     }
1146 }
1147 
1148 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1149 
1150 // SPDX-License-Identifier: MIT
1151 
1152 pragma solidity ^0.6.0;
1153 
1154 /**
1155  * @dev Library for managing an enumerable variant of Solidity's
1156  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1157  * type.
1158  *
1159  * Maps have the following properties:
1160  *
1161  * - Entries are added, removed, and checked for existence in constant time
1162  * (O(1)).
1163  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1164  *
1165  * ```
1166  * contract Example {
1167  *     // Add the library methods
1168  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1169  *
1170  *     // Declare a set state variable
1171  *     EnumerableMap.UintToAddressMap private myMap;
1172  * }
1173  * ```
1174  *
1175  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1176  * supported.
1177  */
1178 library EnumerableMap {
1179     // To implement this library for multiple types with as little code
1180     // repetition as possible, we write it in terms of a generic Map type with
1181     // bytes32 keys and values.
1182     // The Map implementation uses private functions, and user-facing
1183     // implementations (such as Uint256ToAddressMap) are just wrappers around
1184     // the underlying Map.
1185     // This means that we can only create new EnumerableMaps for types that fit
1186     // in bytes32.
1187 
1188     struct MapEntry {
1189         bytes32 _key;
1190         bytes32 _value;
1191     }
1192 
1193     struct Map {
1194         // Storage of map keys and values
1195         MapEntry[] _entries;
1196 
1197         // Position of the entry defined by a key in the `entries` array, plus 1
1198         // because index 0 means a key is not in the map.
1199         mapping (bytes32 => uint256) _indexes;
1200     }
1201 
1202     /**
1203      * @dev Adds a key-value pair to a map, or updates the value for an existing
1204      * key. O(1).
1205      *
1206      * Returns true if the key was added to the map, that is if it was not
1207      * already present.
1208      */
1209     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1210         // We read and store the key's index to prevent multiple reads from the same storage slot
1211         uint256 keyIndex = map._indexes[key];
1212 
1213         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1214             map._entries.push(MapEntry({ _key: key, _value: value }));
1215             // The entry is stored at length-1, but we add 1 to all indexes
1216             // and use 0 as a sentinel value
1217             map._indexes[key] = map._entries.length;
1218             return true;
1219         } else {
1220             map._entries[keyIndex - 1]._value = value;
1221             return false;
1222         }
1223     }
1224 
1225     /**
1226      * @dev Removes a key-value pair from a map. O(1).
1227      *
1228      * Returns true if the key was removed from the map, that is if it was present.
1229      */
1230     function _remove(Map storage map, bytes32 key) private returns (bool) {
1231         // We read and store the key's index to prevent multiple reads from the same storage slot
1232         uint256 keyIndex = map._indexes[key];
1233 
1234         if (keyIndex != 0) { // Equivalent to contains(map, key)
1235             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1236             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1237             // This modifies the order of the array, as noted in {at}.
1238 
1239             uint256 toDeleteIndex = keyIndex - 1;
1240             uint256 lastIndex = map._entries.length - 1;
1241 
1242             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1243             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1244 
1245             MapEntry storage lastEntry = map._entries[lastIndex];
1246 
1247             // Move the last entry to the index where the entry to delete is
1248             map._entries[toDeleteIndex] = lastEntry;
1249             // Update the index for the moved entry
1250             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1251 
1252             // Delete the slot where the moved entry was stored
1253             map._entries.pop();
1254 
1255             // Delete the index for the deleted slot
1256             delete map._indexes[key];
1257 
1258             return true;
1259         } else {
1260             return false;
1261         }
1262     }
1263 
1264     /**
1265      * @dev Returns true if the key is in the map. O(1).
1266      */
1267     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1268         return map._indexes[key] != 0;
1269     }
1270 
1271     /**
1272      * @dev Returns the number of key-value pairs in the map. O(1).
1273      */
1274     function _length(Map storage map) private view returns (uint256) {
1275         return map._entries.length;
1276     }
1277 
1278    /**
1279     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1280     *
1281     * Note that there are no guarantees on the ordering of entries inside the
1282     * array, and it may change when more entries are added or removed.
1283     *
1284     * Requirements:
1285     *
1286     * - `index` must be strictly less than {length}.
1287     */
1288     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1289         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1290 
1291         MapEntry storage entry = map._entries[index];
1292         return (entry._key, entry._value);
1293     }
1294 
1295     /**
1296      * @dev Returns the value associated with `key`.  O(1).
1297      *
1298      * Requirements:
1299      *
1300      * - `key` must be in the map.
1301      */
1302     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1303         return _get(map, key, "EnumerableMap: nonexistent key");
1304     }
1305 
1306     /**
1307      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1308      */
1309     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1310         uint256 keyIndex = map._indexes[key];
1311         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1312         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1313     }
1314 
1315     // UintToAddressMap
1316 
1317     struct UintToAddressMap {
1318         Map _inner;
1319     }
1320 
1321     /**
1322      * @dev Adds a key-value pair to a map, or updates the value for an existing
1323      * key. O(1).
1324      *
1325      * Returns true if the key was added to the map, that is if it was not
1326      * already present.
1327      */
1328     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1329         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1330     }
1331 
1332     /**
1333      * @dev Removes a value from a set. O(1).
1334      *
1335      * Returns true if the key was removed from the map, that is if it was present.
1336      */
1337     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1338         return _remove(map._inner, bytes32(key));
1339     }
1340 
1341     /**
1342      * @dev Returns true if the key is in the map. O(1).
1343      */
1344     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1345         return _contains(map._inner, bytes32(key));
1346     }
1347 
1348     /**
1349      * @dev Returns the number of elements in the map. O(1).
1350      */
1351     function length(UintToAddressMap storage map) internal view returns (uint256) {
1352         return _length(map._inner);
1353     }
1354 
1355    /**
1356     * @dev Returns the element stored at position `index` in the set. O(1).
1357     * Note that there are no guarantees on the ordering of values inside the
1358     * array, and it may change when more values are added or removed.
1359     *
1360     * Requirements:
1361     *
1362     * - `index` must be strictly less than {length}.
1363     */
1364     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1365         (bytes32 key, bytes32 value) = _at(map._inner, index);
1366         return (uint256(key), address(uint256(value)));
1367     }
1368 
1369     /**
1370      * @dev Returns the value associated with `key`.  O(1).
1371      *
1372      * Requirements:
1373      *
1374      * - `key` must be in the map.
1375      */
1376     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1377         return address(uint256(_get(map._inner, bytes32(key))));
1378     }
1379 
1380     /**
1381      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1382      */
1383     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1384         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1385     }
1386 }
1387 
1388 // File: @openzeppelin/contracts/utils/Strings.sol
1389 
1390 // SPDX-License-Identifier: MIT
1391 
1392 pragma solidity ^0.6.0;
1393 
1394 /**
1395  * @dev String operations.
1396  */
1397 library Strings {
1398     /**
1399      * @dev Converts a `uint256` to its ASCII `string` representation.
1400      */
1401     function toString(uint256 value) internal pure returns (string memory) {
1402         // Inspired by OraclizeAPI's implementation - MIT licence
1403         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1404 
1405         if (value == 0) {
1406             return "0";
1407         }
1408         uint256 temp = value;
1409         uint256 digits;
1410         while (temp != 0) {
1411             digits++;
1412             temp /= 10;
1413         }
1414         bytes memory buffer = new bytes(digits);
1415         uint256 index = digits - 1;
1416         temp = value;
1417         while (temp != 0) {
1418             buffer[index--] = byte(uint8(48 + temp % 10));
1419             temp /= 10;
1420         }
1421         return string(buffer);
1422     }
1423 }
1424 
1425 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1426 
1427 // SPDX-License-Identifier: MIT
1428 
1429 pragma solidity ^0.6.0;
1430 
1431 
1432 
1433 
1434 
1435 
1436 
1437 
1438 
1439 
1440 
1441 
1442 /**
1443  * @title ERC721 Non-Fungible Token Standard basic implementation
1444  * @dev see https://eips.ethereum.org/EIPS/eip-721
1445  */
1446 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1447     using SafeMath for uint256;
1448     using Address for address;
1449     using EnumerableSet for EnumerableSet.UintSet;
1450     using EnumerableMap for EnumerableMap.UintToAddressMap;
1451     using Strings for uint256;
1452 
1453     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1454     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1455     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1456 
1457     // Mapping from holder address to their (enumerable) set of owned tokens
1458     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1459 
1460     // Enumerable mapping from token ids to their owners
1461     EnumerableMap.UintToAddressMap private _tokenOwners;
1462 
1463     // Mapping from token ID to approved address
1464     mapping (uint256 => address) private _tokenApprovals;
1465 
1466     // Mapping from owner to operator approvals
1467     mapping (address => mapping (address => bool)) private _operatorApprovals;
1468 
1469     // Token name
1470     string private _name;
1471 
1472     // Token symbol
1473     string private _symbol;
1474 
1475     // Optional mapping for token URIs
1476     mapping (uint256 => string) private _tokenURIs;
1477 
1478     // Base URI
1479     string private _baseURI;
1480 
1481     /*
1482      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1483      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1484      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1485      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1486      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1487      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1488      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1489      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1490      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1491      *
1492      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1493      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1494      */
1495     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1496 
1497     /*
1498      *     bytes4(keccak256('name()')) == 0x06fdde03
1499      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1500      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1501      *
1502      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1503      */
1504     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1505 
1506     /*
1507      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1508      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1509      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1510      *
1511      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1512      */
1513     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1514 
1515     /**
1516      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1517      */
1518     constructor (string memory name, string memory symbol) public {
1519         _name = name;
1520         _symbol = symbol;
1521 
1522         // register the supported interfaces to conform to ERC721 via ERC165
1523         _registerInterface(_INTERFACE_ID_ERC721);
1524         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1525         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1526     }
1527 
1528     /**
1529      * @dev See {IERC721-balanceOf}.
1530      */
1531     function balanceOf(address owner) public view override returns (uint256) {
1532         require(owner != address(0), "ERC721: balance query for the zero address");
1533 
1534         return _holderTokens[owner].length();
1535     }
1536 
1537     /**
1538      * @dev See {IERC721-ownerOf}.
1539      */
1540     function ownerOf(uint256 tokenId) public view override returns (address) {
1541         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1542     }
1543 
1544     /**
1545      * @dev See {IERC721Metadata-name}.
1546      */
1547     function name() public view override returns (string memory) {
1548         return _name;
1549     }
1550 
1551     /**
1552      * @dev See {IERC721Metadata-symbol}.
1553      */
1554     function symbol() public view override returns (string memory) {
1555         return _symbol;
1556     }
1557 
1558     /**
1559      * @dev See {IERC721Metadata-tokenURI}.
1560      */
1561     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1562         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1563 
1564         string memory _tokenURI = _tokenURIs[tokenId];
1565 
1566         // If there is no base URI, return the token URI.
1567         if (bytes(_baseURI).length == 0) {
1568             return _tokenURI;
1569         }
1570         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1571         if (bytes(_tokenURI).length > 0) {
1572             return string(abi.encodePacked(_baseURI, _tokenURI));
1573         }
1574         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1575         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1576     }
1577 
1578     /**
1579     * @dev Returns the base URI set via {_setBaseURI}. This will be
1580     * automatically added as a prefix in {tokenURI} to each token's URI, or
1581     * to the token ID if no specific URI is set for that token ID.
1582     */
1583     function baseURI() public view returns (string memory) {
1584         return _baseURI;
1585     }
1586 
1587     /**
1588      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1589      */
1590     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1591         return _holderTokens[owner].at(index);
1592     }
1593 
1594     /**
1595      * @dev See {IERC721Enumerable-totalSupply}.
1596      */
1597     function totalSupply() public view override returns (uint256) {
1598         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1599         return _tokenOwners.length();
1600     }
1601 
1602     /**
1603      * @dev See {IERC721Enumerable-tokenByIndex}.
1604      */
1605     function tokenByIndex(uint256 index) public view override returns (uint256) {
1606         (uint256 tokenId, ) = _tokenOwners.at(index);
1607         return tokenId;
1608     }
1609 
1610     /**
1611      * @dev See {IERC721-approve}.
1612      */
1613     function approve(address to, uint256 tokenId) public virtual override {
1614         address owner = ownerOf(tokenId);
1615         require(to != owner, "ERC721: approval to current owner");
1616 
1617         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1618             "ERC721: approve caller is not owner nor approved for all"
1619         );
1620 
1621         _approve(to, tokenId);
1622     }
1623 
1624     /**
1625      * @dev See {IERC721-getApproved}.
1626      */
1627     function getApproved(uint256 tokenId) public view override returns (address) {
1628         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1629 
1630         return _tokenApprovals[tokenId];
1631     }
1632 
1633     /**
1634      * @dev See {IERC721-setApprovalForAll}.
1635      */
1636     function setApprovalForAll(address operator, bool approved) public virtual override {
1637         require(operator != _msgSender(), "ERC721: approve to caller");
1638 
1639         _operatorApprovals[_msgSender()][operator] = approved;
1640         emit ApprovalForAll(_msgSender(), operator, approved);
1641     }
1642 
1643     /**
1644      * @dev See {IERC721-isApprovedForAll}.
1645      */
1646     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1647         return _operatorApprovals[owner][operator];
1648     }
1649 
1650     /**
1651      * @dev See {IERC721-transferFrom}.
1652      */
1653     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1654         //solhint-disable-next-line max-line-length
1655         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1656 
1657         _transfer(from, to, tokenId);
1658     }
1659 
1660     /**
1661      * @dev See {IERC721-safeTransferFrom}.
1662      */
1663     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1664         safeTransferFrom(from, to, tokenId, "");
1665     }
1666 
1667     /**
1668      * @dev See {IERC721-safeTransferFrom}.
1669      */
1670     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1671         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1672         _safeTransfer(from, to, tokenId, _data);
1673     }
1674 
1675     /**
1676      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1677      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1678      *
1679      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1680      *
1681      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1682      * implement alternative mechanisms to perform token transfer, such as signature-based.
1683      *
1684      * Requirements:
1685      *
1686      * - `from` cannot be the zero address.
1687      * - `to` cannot be the zero address.
1688      * - `tokenId` token must exist and be owned by `from`.
1689      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1690      *
1691      * Emits a {Transfer} event.
1692      */
1693     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1694         _transfer(from, to, tokenId);
1695         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1696     }
1697 
1698     /**
1699      * @dev Returns whether `tokenId` exists.
1700      *
1701      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1702      *
1703      * Tokens start existing when they are minted (`_mint`),
1704      * and stop existing when they are burned (`_burn`).
1705      */
1706     function _exists(uint256 tokenId) internal view returns (bool) {
1707         return _tokenOwners.contains(tokenId);
1708     }
1709 
1710     /**
1711      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1712      *
1713      * Requirements:
1714      *
1715      * - `tokenId` must exist.
1716      */
1717     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1718         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1719         address owner = ownerOf(tokenId);
1720         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1721     }
1722 
1723     /**
1724      * @dev Safely mints `tokenId` and transfers it to `to`.
1725      *
1726      * Requirements:
1727      d*
1728      * - `tokenId` must not exist.
1729      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1730      *
1731      * Emits a {Transfer} event.
1732      */
1733     function _safeMint(address to, uint256 tokenId) internal virtual {
1734         _safeMint(to, tokenId, "");
1735     }
1736 
1737     /**
1738      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1739      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1740      */
1741     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1742         _mint(to, tokenId);
1743         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1744     }
1745 
1746     /**
1747      * @dev Mints `tokenId` and transfers it to `to`.
1748      *
1749      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1750      *
1751      * Requirements:
1752      *
1753      * - `tokenId` must not exist.
1754      * - `to` cannot be the zero address.
1755      *
1756      * Emits a {Transfer} event.
1757      */
1758     function _mint(address to, uint256 tokenId) internal virtual {
1759         require(to != address(0), "ERC721: mint to the zero address");
1760         require(!_exists(tokenId), "ERC721: token already minted");
1761 
1762         _beforeTokenTransfer(address(0), to, tokenId);
1763 
1764         _holderTokens[to].add(tokenId);
1765 
1766         _tokenOwners.set(tokenId, to);
1767 
1768         emit Transfer(address(0), to, tokenId);
1769     }
1770 
1771     /**
1772      * @dev Destroys `tokenId`.
1773      * The approval is cleared when the token is burned.
1774      *
1775      * Requirements:
1776      *
1777      * - `tokenId` must exist.
1778      *
1779      * Emits a {Transfer} event.
1780      */
1781     function _burn(uint256 tokenId) internal virtual {
1782         address owner = ownerOf(tokenId);
1783 
1784         _beforeTokenTransfer(owner, address(0), tokenId);
1785 
1786         // Clear approvals
1787         _approve(address(0), tokenId);
1788 
1789         // Clear metadata (if any)
1790         if (bytes(_tokenURIs[tokenId]).length != 0) {
1791             delete _tokenURIs[tokenId];
1792         }
1793 
1794         _holderTokens[owner].remove(tokenId);
1795 
1796         _tokenOwners.remove(tokenId);
1797 
1798         emit Transfer(owner, address(0), tokenId);
1799     }
1800 
1801     /**
1802      * @dev Transfers `tokenId` from `from` to `to`.
1803      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1804      *
1805      * Requirements:
1806      *
1807      * - `to` cannot be the zero address.
1808      * - `tokenId` token must be owned by `from`.
1809      *
1810      * Emits a {Transfer} event.
1811      */
1812     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1813         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1814         require(to != address(0), "ERC721: transfer to the zero address");
1815 
1816         _beforeTokenTransfer(from, to, tokenId);
1817 
1818         // Clear approvals from the previous owner
1819         _approve(address(0), tokenId);
1820 
1821         _holderTokens[from].remove(tokenId);
1822         _holderTokens[to].add(tokenId);
1823 
1824         _tokenOwners.set(tokenId, to);
1825 
1826         emit Transfer(from, to, tokenId);
1827     }
1828 
1829     /**
1830      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1831      *
1832      * Requirements:
1833      *
1834      * - `tokenId` must exist.
1835      */
1836     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1837         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1838         _tokenURIs[tokenId] = _tokenURI;
1839     }
1840 
1841     /**
1842      * @dev Internal function to set the base URI for all token IDs. It is
1843      * automatically added as a prefix to the value returned in {tokenURI},
1844      * or to the token ID if {tokenURI} is empty.
1845      */
1846     function _setBaseURI(string memory baseURI_) internal virtual {
1847         _baseURI = baseURI_;
1848     }
1849 
1850     /**
1851      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1852      * The call is not executed if the target address is not a contract.
1853      *
1854      * @param from address representing the previous owner of the given token ID
1855      * @param to target address that will receive the tokens
1856      * @param tokenId uint256 ID of the token to be transferred
1857      * @param _data bytes optional data to send along with the call
1858      * @return bool whether the call correctly returned the expected magic value
1859      */
1860     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1861         private returns (bool)
1862     {
1863         if (!to.isContract()) {
1864             return true;
1865         }
1866         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1867             IERC721Receiver(to).onERC721Received.selector,
1868             _msgSender(),
1869             from,
1870             tokenId,
1871             _data
1872         ), "ERC721: transfer to non ERC721Receiver implementer");
1873         bytes4 retval = abi.decode(returndata, (bytes4));
1874         return (retval == _ERC721_RECEIVED);
1875     }
1876 
1877     function _approve(address to, uint256 tokenId) private {
1878         _tokenApprovals[tokenId] = to;
1879         emit Approval(ownerOf(tokenId), to, tokenId);
1880     }
1881 
1882     /**
1883      * @dev Hook that is called before any token transfer. This includes minting
1884      * and burning.
1885      *
1886      * Calling conditions:
1887      *
1888      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1889      * transferred to `to`.
1890      * - When `from` is zero, `tokenId` will be minted for `to`.
1891      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1892      * - `from` cannot be the zero address.
1893      * - `to` cannot be the zero address.
1894      *
1895      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1896      */
1897     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1898 }
1899 
1900 // File: contracts/INFTStaker.sol
1901 
1902 // SPDX-License-Identifier: MIT
1903 
1904 pragma solidity ^0.6.2;
1905 
1906 
1907 /**
1908  * @dev Required interface of an ERC721 compliant contract.
1909  */
1910 interface INFTStaker is IERC165 {
1911 
1912   struct Reward {
1913     address minter;
1914     uint256 amount;
1915     uint256 startBlock;
1916     uint256 endBlock;
1917     bool isStaked;
1918   }
1919 
1920   function rewardRecords(uint256 id) external view returns (address, uint256, uint256, uint256, bool);
1921 
1922   /**
1923     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1924     */
1925   event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1926 
1927   /**
1928     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1929     */
1930   event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1931 
1932   /**
1933     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1934     */
1935   event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1936 
1937   /**
1938     * @dev Returns the number of tokens in ``owner``'s account.
1939     */
1940   function balanceOf(address owner) external view returns (uint256 balance);
1941 
1942   /**
1943     * @dev Returns the owner of the `tokenId` token.
1944     *
1945     * Requirements:
1946     *
1947     * - `tokenId` must exist.
1948     */
1949   function ownerOf(uint256 tokenId) external view returns (address owner);
1950 
1951   /**
1952     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1953     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1954     *
1955     * Requirements:
1956     *
1957     * - `from` cannot be the zero address.
1958     * - `to` cannot be the zero address.
1959     * - `tokenId` token must exist and be owned by `from`.
1960     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1961     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1962     *
1963     * Emits a {Transfer} event.
1964     */
1965   function safeTransferFrom(address from, address to, uint256 tokenId) external;
1966 
1967   /**
1968     * @dev Transfers `tokenId` token from `from` to `to`.
1969     *
1970     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1971     *
1972     * Requirements:
1973     *
1974     * - `from` cannot be the zero address.
1975     * - `to` cannot be the zero address.
1976     * - `tokenId` token must be owned by `from`.
1977     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1978     *
1979     * Emits a {Transfer} event.
1980     */
1981   function transferFrom(address from, address to, uint256 tokenId) external;
1982 
1983   /**
1984     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1985     * The approval is cleared when the token is transferred.
1986     *
1987     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1988     *
1989     * Requirements:
1990     *
1991     * - The caller must own the token or be an approved operator.
1992     * - `tokenId` must exist.
1993     *
1994     * Emits an {Approval} event.
1995     */
1996   function approve(address to, uint256 tokenId) external;
1997 
1998   /**
1999     * @dev Returns the account approved for `tokenId` token.
2000     *
2001     * Requirements:
2002     *
2003     * - `tokenId` must exist.
2004     */
2005   function getApproved(uint256 tokenId) external view returns (address operator);
2006 
2007   /**
2008     * @dev Approve or remove `operator` as an operator for the caller.
2009     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2010     *
2011     * Requirements:
2012     *
2013     * - The `operator` cannot be the caller.
2014     *
2015     * Emits an {ApprovalForAll} event.
2016     */
2017   function setApprovalForAll(address operator, bool _approved) external;
2018 
2019   /**
2020     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2021     *
2022     * See {setApprovalForAll}
2023     */
2024   function isApprovedForAll(address owner, address operator) external view returns (bool);
2025 
2026   /**
2027     * @dev Safely transfers `tokenId` token from `from` to `to`.
2028     *
2029     * Requirements:
2030     *
2031     * - `from` cannot be the zero address.
2032     * - `to` cannot be the zero address.
2033     * - `tokenId` token must exist and be owned by `from`.
2034     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2035     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2036     *
2037     * Emits a {Transfer} event.
2038     */
2039   function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
2040 
2041   /**
2042     * @dev Burns `tokenId`. See {ERC721-_burn}.
2043     *
2044     * Requirements:
2045     *
2046     * - The caller must own `tokenId` or be an approved operator.
2047     */
2048   function burn(uint256 tokenId) external; 
2049 }
2050 
2051 // File: contracts/Blockmon.sol
2052 
2053 pragma solidity ^0.6.1;
2054 
2055 
2056 
2057 
2058 
2059 
2060 
2061 contract Blockmon is ERC721, Ownable {
2062 
2063   using SafeERC20 for IERC20;
2064   using Counters for Counters.Counter;
2065 
2066   Counters.Counter private _rewardIds;
2067 
2068   string public _contractURI;
2069 
2070   IERC20 public token;
2071   INFTStaker public nft;
2072 
2073   // number of created mons (not counting merges)
2074   uint256 public numMonsCreated;
2075 
2076   // tinkerable variables
2077   uint256 public minStakeTime;
2078   uint256 public minStakeAmt;
2079   uint256 public tokenPrice;
2080   uint256 public series;
2081   uint256 public maxMons;
2082   uint256 public mergePrice;
2083   uint256 public mergeTime;
2084   uint256 public genMergeLag;
2085 
2086   bool public canMerge;
2087 
2088   struct Mon {
2089     address miner;
2090     uint256 unlockBlock;
2091     uint256 parent1;
2092     uint256 parent2;
2093     uint256 gen;
2094     uint256 amount;
2095     uint256 duration;
2096     uint256 powerBits;
2097     uint256 series;
2098   }
2099   mapping(uint256 => Mon) public monRecords;
2100 
2101   constructor(string memory name, 
2102               string memory symbol) ERC721(name, symbol) public {
2103     minStakeAmt = 1;
2104     minStakeTime = 10000;
2105     tokenPrice = 1e18;
2106   }
2107 
2108   function _createNewMonster(address to,
2109                              uint256 unlockBlock,
2110                              uint256 parent1,
2111                              uint256 parent2,
2112                              uint256 gen,
2113                              uint256 amount, 
2114                              uint256 duration
2115                              // series is a global variable so no need to pass it in
2116                              ) private {
2117     _rewardIds.increment();
2118     uint256 currId = _rewardIds.current();
2119     monRecords[currId] = Mon(
2120       to,
2121       unlockBlock,
2122       parent1,
2123       parent2,
2124       gen,
2125       amount,
2126       duration,
2127       uint256(blockhash(block.number-1))+amount+duration,
2128       series
2129     );
2130     _safeMint(to, currId);
2131   }
2132 
2133   // Burn gem to get a new monster
2134   function mineMonster(uint256 gemId) public {
2135     require(nft.ownerOf(gemId) == msg.sender, "must use nft you own");
2136 
2137     (, uint256 amount, uint256 start, uint256 end, ) = nft.rewardRecords(gemId);
2138     if (end == 0) {
2139       end = block.number;
2140     }
2141 
2142     require((end-start) >= minStakeTime, "nft is not ready");
2143     require(amount >= minStakeAmt, "staked amt is not high enough");
2144     require(numMonsCreated < maxMons, "no new mons out yet");
2145 
2146     _createNewMonster(msg.sender,
2147                       0,
2148                       0,
2149                       0,
2150                       0,
2151                       amount, 
2152                       end-start);
2153     numMonsCreated += 1;
2154     nft.burn(gemId);
2155   }
2156 
2157   // Directly purchase monster with the set token
2158   function buyMonster() public {
2159     require(numMonsCreated < maxMons, "no new mons out yet");
2160     token.safeTransferFrom(msg.sender, address(this), tokenPrice);
2161     _createNewMonster(msg.sender,
2162                       0,
2163                       0,
2164                       0,
2165                       0,
2166                       0, 
2167                       0);
2168     numMonsCreated += 1;
2169   }
2170  
2171   // Breed a monster
2172   // Only allowed during certain times
2173   function mergeMonsters(uint256 id1, uint256 id2) public {
2174     require(canMerge == true, "can't merge yet");
2175     require(id1 != id2, "can't merge the same monster");
2176 
2177     // get refs to structs
2178     Mon memory mon1 = monRecords[id1];
2179     Mon memory mon2 = monRecords[id2];
2180 
2181     // ensure they are valid for merging
2182     require(mon1.unlockBlock < block.number, "not ready yet");
2183     require(mon2.unlockBlock < block.number, "not ready yet");
2184     require(ownerOf(id1) == msg.sender, "need to own monster");
2185     require(ownerOf(id2) == msg.sender, "need to own monster");
2186 
2187     // set both parent monsters to the new unlock date
2188     monRecords[id1].unlockBlock = block.number + mergeTime + mon1.gen*genMergeLag;
2189     monRecords[id2].unlockBlock = block.number + mergeTime + mon2.gen*genMergeLag;
2190 
2191     // set numAncestors1 to be the minimum of both
2192     uint256 gen1 = mon1.gen;
2193     uint256 gen2 = mon2.gen;
2194     if (gen2 < gen1) {
2195       gen1 = gen2;
2196     }
2197 
2198     // mint the user their merged monster
2199     _createNewMonster(
2200       msg.sender,
2201       block.number + mergeTime + gen1*genMergeLag,
2202       id1,
2203       id2,
2204       gen1+1,
2205       mon1.amount + mon2.amount,
2206       mon1.duration + mon2.duration
2207     );
2208 
2209     // Pay the merge fee
2210     token.safeTransferFrom(msg.sender, address(this), mergePrice);
2211   }
2212 
2213   function setMinStakeAmt(uint256 a) public onlyOwner {
2214     minStakeAmt = a;
2215   }
2216 
2217   function setMinStakeTime(uint256 t) public onlyOwner {
2218     minStakeTime = t;
2219   }
2220 
2221   function setTokenPrice(uint256 p) public onlyOwner {
2222     tokenPrice = p;
2223   }
2224 
2225   function setSeries(uint256 s) public onlyOwner {
2226     series = s;
2227   }
2228 
2229   function setMaxMons(uint256 m) public onlyOwner {
2230     maxMons = m;
2231   }
2232 
2233   function setMergePrice(uint256 p) public onlyOwner {
2234     mergePrice = p;
2235   }
2236 
2237   function setMergeTime(uint256 t) public onlyOwner {
2238     mergeTime = t;
2239   }
2240 
2241   function setGenMergeLag(uint256 g) public onlyOwner {
2242     genMergeLag = g;
2243   }
2244 
2245   function setCanMerge(bool b) public onlyOwner{
2246     canMerge = b;
2247   }
2248 
2249   function setTokenAddress(address tokenAddress) public onlyOwner {
2250     token = IERC20(tokenAddress);
2251   }
2252 
2253   function setNFTAddress(address nftAddress) public onlyOwner {
2254     nft = INFTStaker(nftAddress);
2255   }
2256 
2257   function setBaseURI(string memory uri) public onlyOwner {
2258     _setBaseURI(uri);
2259   }
2260 
2261   function setContractURI(string memory uri) public onlyOwner {
2262     _contractURI = uri;
2263   }
2264 
2265   function moveTokens(address tokenAddress, address to, uint256 numTokens) public onlyOwner {
2266     IERC20 _token = IERC20(tokenAddress);
2267     _token.safeTransfer(to, numTokens);
2268   }
2269 
2270   function contractURI() public view returns (string memory) {
2271     return _contractURI;
2272   }
2273 
2274   function getTotalMons() public view returns (uint256) {
2275     return _rewardIds.current();
2276   }
2277 }