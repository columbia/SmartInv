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
82 // Dependency file: @openzeppelin/contracts/introspection/IERC165.sol
83 
84 
85 // pragma solidity ^0.6.0;
86 
87 /**
88  * @dev Interface of the ERC165 standard, as defined in the
89  * https://eips.ethereum.org/EIPS/eip-165[EIP].
90  *
91  * Implementers can declare support of contract interfaces, which can then be
92  * queried by others ({ERC165Checker}).
93  *
94  * For an implementation, see {ERC165}.
95  */
96 interface IERC165 {
97     /**
98      * @dev Returns true if this contract implements the interface defined by
99      * `interfaceId`. See the corresponding
100      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
101      * to learn more about how these ids are created.
102      *
103      * This function call must use less than 30 000 gas.
104      */
105     function supportsInterface(bytes4 interfaceId) external view returns (bool);
106 }
107 
108 
109 // Dependency file: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
110 
111 
112 // pragma solidity ^0.6.0;
113 
114 // import "@openzeppelin/contracts/introspection/IERC165.sol";
115 
116 /**
117  * _Available since v3.1._
118  */
119 interface IERC1155Receiver is IERC165 {
120 
121     /**
122         @dev Handles the receipt of a single ERC1155 token type. This function is
123         called at the end of a `safeTransferFrom` after the balance has been updated.
124         To accept the transfer, this must return
125         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
126         (i.e. 0xf23a6e61, or its own function selector).
127         @param operator The address which initiated the transfer (i.e. msg.sender)
128         @param from The address which previously owned the token
129         @param id The ID of the token being transferred
130         @param value The amount of tokens being transferred
131         @param data Additional data with no specified format
132         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
133     */
134     function onERC1155Received(
135         address operator,
136         address from,
137         uint256 id,
138         uint256 value,
139         bytes calldata data
140     )
141         external
142         returns(bytes4);
143 
144     /**
145         @dev Handles the receipt of a multiple ERC1155 token types. This function
146         is called at the end of a `safeBatchTransferFrom` after the balances have
147         been updated. To accept the transfer(s), this must return
148         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
149         (i.e. 0xbc197c81, or its own function selector).
150         @param operator The address which initiated the batch transfer (i.e. msg.sender)
151         @param from The address which previously owned the token
152         @param ids An array containing ids of each token being transferred (order and length must match values array)
153         @param values An array containing amounts of each token being transferred (order and length must match ids array)
154         @param data Additional data with no specified format
155         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
156     */
157     function onERC1155BatchReceived(
158         address operator,
159         address from,
160         uint256[] calldata ids,
161         uint256[] calldata values,
162         bytes calldata data
163     )
164         external
165         returns(bytes4);
166 }
167 
168 
169 // Dependency file: @openzeppelin/contracts/introspection/ERC165.sol
170 
171 
172 // pragma solidity ^0.6.0;
173 
174 // import "@openzeppelin/contracts/introspection/IERC165.sol";
175 
176 /**
177  * @dev Implementation of the {IERC165} interface.
178  *
179  * Contracts may inherit from this and call {_registerInterface} to declare
180  * their support of an interface.
181  */
182 contract ERC165 is IERC165 {
183     /*
184      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
185      */
186     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
187 
188     /**
189      * @dev Mapping of interface ids to whether or not it's supported.
190      */
191     mapping(bytes4 => bool) private _supportedInterfaces;
192 
193     constructor () internal {
194         // Derived contracts need only register support for their own interfaces,
195         // we register support for ERC165 itself here
196         _registerInterface(_INTERFACE_ID_ERC165);
197     }
198 
199     /**
200      * @dev See {IERC165-supportsInterface}.
201      *
202      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
203      */
204     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
205         return _supportedInterfaces[interfaceId];
206     }
207 
208     /**
209      * @dev Registers the contract as an implementer of the interface defined by
210      * `interfaceId`. Support of the actual ERC165 interface is automatic and
211      * registering its interface id is not required.
212      *
213      * See {IERC165-supportsInterface}.
214      *
215      * Requirements:
216      *
217      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
218      */
219     function _registerInterface(bytes4 interfaceId) internal virtual {
220         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
221         _supportedInterfaces[interfaceId] = true;
222     }
223 }
224 
225 
226 // Dependency file: @openzeppelin/contracts/token/ERC1155/ERC1155Receiver.sol
227 
228 
229 // pragma solidity ^0.6.0;
230 
231 // import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
232 // import "@openzeppelin/contracts/introspection/ERC165.sol";
233 
234 /**
235  * @dev _Available since v3.1._
236  */
237 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
238     constructor() public {
239         _registerInterface(
240             ERC1155Receiver(0).onERC1155Received.selector ^
241             ERC1155Receiver(0).onERC1155BatchReceived.selector
242         );
243     }
244 }
245 
246 
247 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
248 
249 
250 // pragma solidity ^0.6.0;
251 
252 /**
253  * @dev Wrappers over Solidity's arithmetic operations with added overflow
254  * checks.
255  *
256  * Arithmetic operations in Solidity wrap on overflow. This can easily result
257  * in bugs, because programmers usually assume that an overflow raises an
258  * error, which is the standard behavior in high level programming languages.
259  * `SafeMath` restores this intuition by reverting the transaction when an
260  * operation overflows.
261  *
262  * Using this library instead of the unchecked operations eliminates an entire
263  * class of bugs, so it's recommended to use it always.
264  */
265 library SafeMath {
266     /**
267      * @dev Returns the addition of two unsigned integers, reverting on
268      * overflow.
269      *
270      * Counterpart to Solidity's `+` operator.
271      *
272      * Requirements:
273      *
274      * - Addition cannot overflow.
275      */
276     function add(uint256 a, uint256 b) internal pure returns (uint256) {
277         uint256 c = a + b;
278         require(c >= a, "SafeMath: addition overflow");
279 
280         return c;
281     }
282 
283     /**
284      * @dev Returns the subtraction of two unsigned integers, reverting on
285      * overflow (when the result is negative).
286      *
287      * Counterpart to Solidity's `-` operator.
288      *
289      * Requirements:
290      *
291      * - Subtraction cannot overflow.
292      */
293     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
294         return sub(a, b, "SafeMath: subtraction overflow");
295     }
296 
297     /**
298      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
299      * overflow (when the result is negative).
300      *
301      * Counterpart to Solidity's `-` operator.
302      *
303      * Requirements:
304      *
305      * - Subtraction cannot overflow.
306      */
307     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
308         require(b <= a, errorMessage);
309         uint256 c = a - b;
310 
311         return c;
312     }
313 
314     /**
315      * @dev Returns the multiplication of two unsigned integers, reverting on
316      * overflow.
317      *
318      * Counterpart to Solidity's `*` operator.
319      *
320      * Requirements:
321      *
322      * - Multiplication cannot overflow.
323      */
324     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
325         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
326         // benefit is lost if 'b' is also tested.
327         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
328         if (a == 0) {
329             return 0;
330         }
331 
332         uint256 c = a * b;
333         require(c / a == b, "SafeMath: multiplication overflow");
334 
335         return c;
336     }
337 
338     /**
339      * @dev Returns the integer division of two unsigned integers. Reverts on
340      * division by zero. The result is rounded towards zero.
341      *
342      * Counterpart to Solidity's `/` operator. Note: this function uses a
343      * `revert` opcode (which leaves remaining gas untouched) while Solidity
344      * uses an invalid opcode to revert (consuming all remaining gas).
345      *
346      * Requirements:
347      *
348      * - The divisor cannot be zero.
349      */
350     function div(uint256 a, uint256 b) internal pure returns (uint256) {
351         return div(a, b, "SafeMath: division by zero");
352     }
353 
354     /**
355      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
356      * division by zero. The result is rounded towards zero.
357      *
358      * Counterpart to Solidity's `/` operator. Note: this function uses a
359      * `revert` opcode (which leaves remaining gas untouched) while Solidity
360      * uses an invalid opcode to revert (consuming all remaining gas).
361      *
362      * Requirements:
363      *
364      * - The divisor cannot be zero.
365      */
366     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
367         require(b > 0, errorMessage);
368         uint256 c = a / b;
369         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
370 
371         return c;
372     }
373 
374     /**
375      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
376      * Reverts when dividing by zero.
377      *
378      * Counterpart to Solidity's `%` operator. This function uses a `revert`
379      * opcode (which leaves remaining gas untouched) while Solidity uses an
380      * invalid opcode to revert (consuming all remaining gas).
381      *
382      * Requirements:
383      *
384      * - The divisor cannot be zero.
385      */
386     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
387         return mod(a, b, "SafeMath: modulo by zero");
388     }
389 
390     /**
391      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
392      * Reverts with custom message when dividing by zero.
393      *
394      * Counterpart to Solidity's `%` operator. This function uses a `revert`
395      * opcode (which leaves remaining gas untouched) while Solidity uses an
396      * invalid opcode to revert (consuming all remaining gas).
397      *
398      * Requirements:
399      *
400      * - The divisor cannot be zero.
401      */
402     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
403         require(b != 0, errorMessage);
404         return a % b;
405     }
406 }
407 
408 
409 // Dependency file: @openzeppelin/contracts/utils/Address.sol
410 
411 
412 // pragma solidity ^0.6.2;
413 
414 /**
415  * @dev Collection of functions related to the address type
416  */
417 library Address {
418     /**
419      * @dev Returns true if `account` is a contract.
420      *
421      * [// importANT]
422      * ====
423      * It is unsafe to assume that an address for which this function returns
424      * false is an externally-owned account (EOA) and not a contract.
425      *
426      * Among others, `isContract` will return false for the following
427      * types of addresses:
428      *
429      *  - an externally-owned account
430      *  - a contract in construction
431      *  - an address where a contract will be created
432      *  - an address where a contract lived, but was destroyed
433      * ====
434      */
435     function isContract(address account) internal view returns (bool) {
436         // This method relies in extcodesize, which returns 0 for contracts in
437         // construction, since the code is only stored at the end of the
438         // constructor execution.
439 
440         uint256 size;
441         // solhint-disable-next-line no-inline-assembly
442         assembly { size := extcodesize(account) }
443         return size > 0;
444     }
445 
446     /**
447      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
448      * `recipient`, forwarding all available gas and reverting on errors.
449      *
450      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
451      * of certain opcodes, possibly making contracts go over the 2300 gas limit
452      * imposed by `transfer`, making them unable to receive funds via
453      * `transfer`. {sendValue} removes this limitation.
454      *
455      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
456      *
457      * // importANT: because control is transferred to `recipient`, care must be
458      * taken to not create reentrancy vulnerabilities. Consider using
459      * {ReentrancyGuard} or the
460      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
461      */
462     function sendValue(address payable recipient, uint256 amount) internal {
463         require(address(this).balance >= amount, "Address: insufficient balance");
464 
465         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
466         (bool success, ) = recipient.call{ value: amount }("");
467         require(success, "Address: unable to send value, recipient may have reverted");
468     }
469 
470     /**
471      * @dev Performs a Solidity function call using a low level `call`. A
472      * plain`call` is an unsafe replacement for a function call: use this
473      * function instead.
474      *
475      * If `target` reverts with a revert reason, it is bubbled up by this
476      * function (like regular Solidity function calls).
477      *
478      * Returns the raw returned data. To convert to the expected return value,
479      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
480      *
481      * Requirements:
482      *
483      * - `target` must be a contract.
484      * - calling `target` with `data` must not revert.
485      *
486      * _Available since v3.1._
487      */
488     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
489       return functionCall(target, data, "Address: low-level call failed");
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
494      * `errorMessage` as a fallback revert reason when `target` reverts.
495      *
496      * _Available since v3.1._
497      */
498     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
499         return _functionCallWithValue(target, data, 0, errorMessage);
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
504      * but also transferring `value` wei to `target`.
505      *
506      * Requirements:
507      *
508      * - the calling contract must have an ETH balance of at least `value`.
509      * - the called Solidity function must be `payable`.
510      *
511      * _Available since v3.1._
512      */
513     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
514         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
519      * with `errorMessage` as a fallback revert reason when `target` reverts.
520      *
521      * _Available since v3.1._
522      */
523     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
524         require(address(this).balance >= value, "Address: insufficient balance for call");
525         return _functionCallWithValue(target, data, value, errorMessage);
526     }
527 
528     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
529         require(isContract(target), "Address: call to non-contract");
530 
531         // solhint-disable-next-line avoid-low-level-calls
532         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
533         if (success) {
534             return returndata;
535         } else {
536             // Look for revert reason and bubble it up if present
537             if (returndata.length > 0) {
538                 // The easiest way to bubble the revert reason is using memory via assembly
539 
540                 // solhint-disable-next-line no-inline-assembly
541                 assembly {
542                     let returndata_size := mload(returndata)
543                     revert(add(32, returndata), returndata_size)
544                 }
545             } else {
546                 revert(errorMessage);
547             }
548         }
549     }
550 }
551 
552 
553 // Dependency file: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
554 
555 
556 // pragma solidity ^0.6.0;
557 
558 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
559 // import "@openzeppelin/contracts/math/SafeMath.sol";
560 // import "@openzeppelin/contracts/utils/Address.sol";
561 
562 /**
563  * @title SafeERC20
564  * @dev Wrappers around ERC20 operations that throw on failure (when the token
565  * contract returns false). Tokens that return no value (and instead revert or
566  * throw on failure) are also supported, non-reverting calls are assumed to be
567  * successful.
568  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
569  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
570  */
571 library SafeERC20 {
572     using SafeMath for uint256;
573     using Address for address;
574 
575     function safeTransfer(IERC20 token, address to, uint256 value) internal {
576         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
577     }
578 
579     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
580         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
581     }
582 
583     /**
584      * @dev Deprecated. This function has issues similar to the ones found in
585      * {IERC20-approve}, and its usage is discouraged.
586      *
587      * Whenever possible, use {safeIncreaseAllowance} and
588      * {safeDecreaseAllowance} instead.
589      */
590     function safeApprove(IERC20 token, address spender, uint256 value) internal {
591         // safeApprove should only be called when setting an initial allowance,
592         // or when resetting it to zero. To increase and decrease it, use
593         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
594         // solhint-disable-next-line max-line-length
595         require((value == 0) || (token.allowance(address(this), spender) == 0),
596             "SafeERC20: approve from non-zero to non-zero allowance"
597         );
598         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
599     }
600 
601     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
602         uint256 newAllowance = token.allowance(address(this), spender).add(value);
603         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
604     }
605 
606     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
607         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
608         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
609     }
610 
611     /**
612      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
613      * on the return value: the return value is optional (but if data is returned, it must not be false).
614      * @param token The token targeted by the call.
615      * @param data The call data (encoded using abi.encode or one of its variants).
616      */
617     function _callOptionalReturn(IERC20 token, bytes memory data) private {
618         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
619         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
620         // the target address contains contract code and also asserts for success in the low-level call.
621 
622         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
623         if (returndata.length > 0) { // Return data is optional
624             // solhint-disable-next-line max-line-length
625             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
626         }
627     }
628 }
629 
630 
631 // Dependency file: @openzeppelin/contracts/utils/EnumerableMap.sol
632 
633 
634 // pragma solidity ^0.6.0;
635 
636 /**
637  * @dev Library for managing an enumerable variant of Solidity's
638  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
639  * type.
640  *
641  * Maps have the following properties:
642  *
643  * - Entries are added, removed, and checked for existence in constant time
644  * (O(1)).
645  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
646  *
647  * ```
648  * contract Example {
649  *     // Add the library methods
650  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
651  *
652  *     // Declare a set state variable
653  *     EnumerableMap.UintToAddressMap private myMap;
654  * }
655  * ```
656  *
657  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
658  * supported.
659  */
660 library EnumerableMap {
661     // To implement this library for multiple types with as little code
662     // repetition as possible, we write it in terms of a generic Map type with
663     // bytes32 keys and values.
664     // The Map implementation uses private functions, and user-facing
665     // implementations (such as Uint256ToAddressMap) are just wrappers around
666     // the underlying Map.
667     // This means that we can only create new EnumerableMaps for types that fit
668     // in bytes32.
669 
670     struct MapEntry {
671         bytes32 _key;
672         bytes32 _value;
673     }
674 
675     struct Map {
676         // Storage of map keys and values
677         MapEntry[] _entries;
678 
679         // Position of the entry defined by a key in the `entries` array, plus 1
680         // because index 0 means a key is not in the map.
681         mapping (bytes32 => uint256) _indexes;
682     }
683 
684     /**
685      * @dev Adds a key-value pair to a map, or updates the value for an existing
686      * key. O(1).
687      *
688      * Returns true if the key was added to the map, that is if it was not
689      * already present.
690      */
691     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
692         // We read and store the key's index to prevent multiple reads from the same storage slot
693         uint256 keyIndex = map._indexes[key];
694 
695         if (keyIndex == 0) { // Equivalent to !contains(map, key)
696             map._entries.push(MapEntry({ _key: key, _value: value }));
697             // The entry is stored at length-1, but we add 1 to all indexes
698             // and use 0 as a sentinel value
699             map._indexes[key] = map._entries.length;
700             return true;
701         } else {
702             map._entries[keyIndex - 1]._value = value;
703             return false;
704         }
705     }
706 
707     /**
708      * @dev Removes a key-value pair from a map. O(1).
709      *
710      * Returns true if the key was removed from the map, that is if it was present.
711      */
712     function _remove(Map storage map, bytes32 key) private returns (bool) {
713         // We read and store the key's index to prevent multiple reads from the same storage slot
714         uint256 keyIndex = map._indexes[key];
715 
716         if (keyIndex != 0) { // Equivalent to contains(map, key)
717             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
718             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
719             // This modifies the order of the array, as noted in {at}.
720 
721             uint256 toDeleteIndex = keyIndex - 1;
722             uint256 lastIndex = map._entries.length - 1;
723 
724             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
725             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
726 
727             MapEntry storage lastEntry = map._entries[lastIndex];
728 
729             // Move the last entry to the index where the entry to delete is
730             map._entries[toDeleteIndex] = lastEntry;
731             // Update the index for the moved entry
732             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
733 
734             // Delete the slot where the moved entry was stored
735             map._entries.pop();
736 
737             // Delete the index for the deleted slot
738             delete map._indexes[key];
739 
740             return true;
741         } else {
742             return false;
743         }
744     }
745 
746     /**
747      * @dev Returns true if the key is in the map. O(1).
748      */
749     function _contains(Map storage map, bytes32 key) private view returns (bool) {
750         return map._indexes[key] != 0;
751     }
752 
753     /**
754      * @dev Returns the number of key-value pairs in the map. O(1).
755      */
756     function _length(Map storage map) private view returns (uint256) {
757         return map._entries.length;
758     }
759 
760    /**
761     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
762     *
763     * Note that there are no guarantees on the ordering of entries inside the
764     * array, and it may change when more entries are added or removed.
765     *
766     * Requirements:
767     *
768     * - `index` must be strictly less than {length}.
769     */
770     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
771         require(map._entries.length > index, "EnumerableMap: index out of bounds");
772 
773         MapEntry storage entry = map._entries[index];
774         return (entry._key, entry._value);
775     }
776 
777     /**
778      * @dev Returns the value associated with `key`.  O(1).
779      *
780      * Requirements:
781      *
782      * - `key` must be in the map.
783      */
784     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
785         return _get(map, key, "EnumerableMap: nonexistent key");
786     }
787 
788     /**
789      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
790      */
791     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
792         uint256 keyIndex = map._indexes[key];
793         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
794         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
795     }
796 
797     // UintToAddressMap
798 
799     struct UintToAddressMap {
800         Map _inner;
801     }
802 
803     /**
804      * @dev Adds a key-value pair to a map, or updates the value for an existing
805      * key. O(1).
806      *
807      * Returns true if the key was added to the map, that is if it was not
808      * already present.
809      */
810     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
811         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
812     }
813 
814     /**
815      * @dev Removes a value from a set. O(1).
816      *
817      * Returns true if the key was removed from the map, that is if it was present.
818      */
819     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
820         return _remove(map._inner, bytes32(key));
821     }
822 
823     /**
824      * @dev Returns true if the key is in the map. O(1).
825      */
826     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
827         return _contains(map._inner, bytes32(key));
828     }
829 
830     /**
831      * @dev Returns the number of elements in the map. O(1).
832      */
833     function length(UintToAddressMap storage map) internal view returns (uint256) {
834         return _length(map._inner);
835     }
836 
837    /**
838     * @dev Returns the element stored at position `index` in the set. O(1).
839     * Note that there are no guarantees on the ordering of values inside the
840     * array, and it may change when more values are added or removed.
841     *
842     * Requirements:
843     *
844     * - `index` must be strictly less than {length}.
845     */
846     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
847         (bytes32 key, bytes32 value) = _at(map._inner, index);
848         return (uint256(key), address(uint256(value)));
849     }
850 
851     /**
852      * @dev Returns the value associated with `key`.  O(1).
853      *
854      * Requirements:
855      *
856      * - `key` must be in the map.
857      */
858     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
859         return address(uint256(_get(map._inner, bytes32(key))));
860     }
861 
862     /**
863      * @dev Same as {get}, with a custom error message when `key` is not in the map.
864      */
865     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
866         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
867     }
868 }
869 
870 
871 // Dependency file: @openzeppelin/contracts/utils/ReentrancyGuard.sol
872 
873 
874 // pragma solidity ^0.6.0;
875 
876 /**
877  * @dev Contract module that helps prevent reentrant calls to a function.
878  *
879  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
880  * available, which can be applied to functions to make sure there are no nested
881  * (reentrant) calls to them.
882  *
883  * Note that because there is a single `nonReentrant` guard, functions marked as
884  * `nonReentrant` may not call one another. This can be worked around by making
885  * those functions `private`, and then adding `external` `nonReentrant` entry
886  * points to them.
887  *
888  * TIP: If you would like to learn more about reentrancy and alternative ways
889  * to protect against it, check out our blog post
890  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
891  */
892 contract ReentrancyGuard {
893     // Booleans are more expensive than uint256 or any type that takes up a full
894     // word because each write operation emits an extra SLOAD to first read the
895     // slot's contents, replace the bits taken up by the boolean, and then write
896     // back. This is the compiler's defense against contract upgrades and
897     // pointer aliasing, and it cannot be disabled.
898 
899     // The values being non-zero value makes deployment a bit more expensive,
900     // but in exchange the refund on every call to nonReentrant will be lower in
901     // amount. Since refunds are capped to a percentage of the total
902     // transaction's gas, it is best to keep them low in cases like this one, to
903     // increase the likelihood of the full refund coming into effect.
904     uint256 private constant _NOT_ENTERED = 1;
905     uint256 private constant _ENTERED = 2;
906 
907     uint256 private _status;
908 
909     constructor () internal {
910         _status = _NOT_ENTERED;
911     }
912 
913     /**
914      * @dev Prevents a contract from calling itself, directly or indirectly.
915      * Calling a `nonReentrant` function from another `nonReentrant`
916      * function is not supported. It is possible to prevent this from happening
917      * by making the `nonReentrant` function external, and make it call a
918      * `private` function that does the actual work.
919      */
920     modifier nonReentrant() {
921         // On the first call to nonReentrant, _notEntered will be true
922         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
923 
924         // Any calls to nonReentrant after this point will fail
925         _status = _ENTERED;
926 
927         _;
928 
929         // By storing the original value once again, a refund is triggered (see
930         // https://eips.ethereum.org/EIPS/eip-2200)
931         _status = _NOT_ENTERED;
932     }
933 }
934 
935 
936 // Dependency file: @openzeppelin/contracts/math/Math.sol
937 
938 
939 // pragma solidity ^0.6.0;
940 
941 /**
942  * @dev Standard math utilities missing in the Solidity language.
943  */
944 library Math {
945     /**
946      * @dev Returns the largest of two numbers.
947      */
948     function max(uint256 a, uint256 b) internal pure returns (uint256) {
949         return a >= b ? a : b;
950     }
951 
952     /**
953      * @dev Returns the smallest of two numbers.
954      */
955     function min(uint256 a, uint256 b) internal pure returns (uint256) {
956         return a < b ? a : b;
957     }
958 
959     /**
960      * @dev Returns the average of two numbers. The result is rounded towards
961      * zero.
962      */
963     function average(uint256 a, uint256 b) internal pure returns (uint256) {
964         // (a + b) / 2 can overflow, so we distribute
965         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
966     }
967 }
968 
969 
970 // Dependency file: @openzeppelin/contracts/GSN/Context.sol
971 
972 
973 // pragma solidity ^0.6.0;
974 
975 /*
976  * @dev Provides information about the current execution context, including the
977  * sender of the transaction and its data. While these are generally available
978  * via msg.sender and msg.data, they should not be accessed in such a direct
979  * manner, since when dealing with GSN meta-transactions the account sending and
980  * paying for execution may not be the actual sender (as far as an application
981  * is concerned).
982  *
983  * This contract is only required for intermediate, library-like contracts.
984  */
985 abstract contract Context {
986     function _msgSender() internal view virtual returns (address payable) {
987         return msg.sender;
988     }
989 
990     function _msgData() internal view virtual returns (bytes memory) {
991         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
992         return msg.data;
993     }
994 }
995 
996 
997 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
998 
999 
1000 // pragma solidity ^0.6.0;
1001 
1002 // import "@openzeppelin/contracts/GSN/Context.sol";
1003 /**
1004  * @dev Contract module which provides a basic access control mechanism, where
1005  * there is an account (an owner) that can be granted exclusive access to
1006  * specific functions.
1007  *
1008  * By default, the owner account will be the one that deploys the contract. This
1009  * can later be changed with {transferOwnership}.
1010  *
1011  * This module is used through inheritance. It will make available the modifier
1012  * `onlyOwner`, which can be applied to your functions to restrict their use to
1013  * the owner.
1014  */
1015 contract Ownable is Context {
1016     address private _owner;
1017 
1018     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1019 
1020     /**
1021      * @dev Initializes the contract setting the deployer as the initial owner.
1022      */
1023     constructor () internal {
1024         address msgSender = _msgSender();
1025         _owner = msgSender;
1026         emit OwnershipTransferred(address(0), msgSender);
1027     }
1028 
1029     /**
1030      * @dev Returns the address of the current owner.
1031      */
1032     function owner() public view returns (address) {
1033         return _owner;
1034     }
1035 
1036     /**
1037      * @dev Throws if called by any account other than the owner.
1038      */
1039     modifier onlyOwner() {
1040         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1041         _;
1042     }
1043 
1044     /**
1045      * @dev Leaves the contract without owner. It will not be possible to call
1046      * `onlyOwner` functions anymore. Can only be called by the current owner.
1047      *
1048      * NOTE: Renouncing ownership will leave the contract without an owner,
1049      * thereby removing any functionality that is only available to the owner.
1050      */
1051     function renounceOwnership() public virtual onlyOwner {
1052         emit OwnershipTransferred(_owner, address(0));
1053         _owner = address(0);
1054     }
1055 
1056     /**
1057      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1058      * Can only be called by the current owner.
1059      */
1060     function transferOwnership(address newOwner) public virtual onlyOwner {
1061         require(newOwner != address(0), "Ownable: new owner is the zero address");
1062         emit OwnershipTransferred(_owner, newOwner);
1063         _owner = newOwner;
1064     }
1065 }
1066 
1067 
1068 // Dependency file: contracts/interfaces/IAlpaToken.sol
1069 
1070 
1071 // pragma solidity 0.6.12;
1072 
1073 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1074 // import "@openzeppelin/contracts/access/Ownable.sol";
1075 
1076 interface IAlpaToken is IERC20 {
1077     function mint(address _to, uint256 _amount) external;
1078 }
1079 
1080 
1081 // Dependency file: contracts/interfaces/IAlpaSupplier.sol
1082 
1083 
1084 // pragma solidity 0.6.12;
1085 
1086 interface IAlpaSupplier {
1087     /**
1088      * @dev mint and distribute ALPA to caller
1089      * NOTE: caller must be approved consumer
1090      */
1091     function distribute(uint256 _since) external returns (uint256);
1092 
1093     /**
1094      * @dev returns number of ALPA _consumer is expected to recieved at current block
1095      */
1096     function preview(address _consumer, uint256 _since)
1097         external
1098         view
1099         returns (uint256);
1100 }
1101 
1102 
1103 // Dependency file: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1104 
1105 
1106 // pragma solidity ^0.6.2;
1107 
1108 // import "@openzeppelin/contracts/introspection/IERC165.sol";
1109 
1110 /**
1111  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1112  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1113  *
1114  * _Available since v3.1._
1115  */
1116 interface IERC1155 is IERC165 {
1117     /**
1118      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1119      */
1120     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1121 
1122     /**
1123      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1124      * transfers.
1125      */
1126     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
1127 
1128     /**
1129      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1130      * `approved`.
1131      */
1132     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1133 
1134     /**
1135      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1136      *
1137      * If an {URI} event was emitted for `id`, the standard
1138      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1139      * returned by {IERC1155MetadataURI-uri}.
1140      */
1141     event URI(string value, uint256 indexed id);
1142 
1143     /**
1144      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1145      *
1146      * Requirements:
1147      *
1148      * - `account` cannot be the zero address.
1149      */
1150     function balanceOf(address account, uint256 id) external view returns (uint256);
1151 
1152     /**
1153      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1154      *
1155      * Requirements:
1156      *
1157      * - `accounts` and `ids` must have the same length.
1158      */
1159     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
1160 
1161     /**
1162      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1163      *
1164      * Emits an {ApprovalForAll} event.
1165      *
1166      * Requirements:
1167      *
1168      * - `operator` cannot be the caller.
1169      */
1170     function setApprovalForAll(address operator, bool approved) external;
1171 
1172     /**
1173      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1174      *
1175      * See {setApprovalForAll}.
1176      */
1177     function isApprovedForAll(address account, address operator) external view returns (bool);
1178 
1179     /**
1180      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1181      *
1182      * Emits a {TransferSingle} event.
1183      *
1184      * Requirements:
1185      *
1186      * - `to` cannot be the zero address.
1187      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1188      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1189      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1190      * acceptance magic value.
1191      */
1192     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
1193 
1194     /**
1195      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1196      *
1197      * Emits a {TransferBatch} event.
1198      *
1199      * Requirements:
1200      *
1201      * - `ids` and `amounts` must have the same length.
1202      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1203      * acceptance magic value.
1204      */
1205     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
1206 }
1207 
1208 
1209 // Dependency file: contracts/interfaces/ICryptoAlpaca.sol
1210 
1211 
1212 // pragma solidity =0.6.12;
1213 
1214 // import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
1215 
1216 interface ICryptoAlpaca is IERC1155 {
1217     function getAlpaca(uint256 _id)
1218         external
1219         view
1220         returns (
1221             uint256 id,
1222             bool isReady,
1223             uint256 cooldownEndBlock,
1224             uint256 birthTime,
1225             uint256 matronId,
1226             uint256 sireId,
1227             uint256 hatchingCost,
1228             uint256 hatchingCostMultiplier,
1229             uint256 hatchCostMultiplierEndBlock,
1230             uint256 generation,
1231             uint256 gene,
1232             uint256 energy,
1233             uint256 state
1234         );
1235 
1236     function hasPermissionToBreedAsSire(address _addr, uint256 _id)
1237         external
1238         view
1239         returns (bool);
1240 
1241     function grandPermissionToBreed(address _addr, uint256 _sireId) external;
1242 
1243     function clearPermissionToBreed(uint256 _alpacaId) external;
1244 
1245     function hatch(uint256 _matronId, uint256 _sireId)
1246         external
1247         payable
1248         returns (uint256);
1249 
1250     function crack(uint256 _id) external;
1251 }
1252 
1253 
1254 // Dependency file: contracts/interfaces/ICryptoAlpacaEnergyListener.sol
1255 
1256 
1257 // pragma solidity 0.6.12;
1258 
1259 // import "@openzeppelin/contracts/introspection/IERC165.sol";
1260 
1261 interface ICryptoAlpacaEnergyListener is IERC165 {
1262     /**
1263         @dev Handles the Alpaca energy change callback.
1264         @param id The id of the Alpaca which the energy changed
1265         @param oldEnergy The ID of the token being transferred
1266         @param newEnergy The amount of tokens being transferred
1267     */
1268     function onCryptoAlpacaEnergyChanged(
1269         uint256 id,
1270         uint256 oldEnergy,
1271         uint256 newEnergy
1272     ) external;
1273 }
1274 
1275 
1276 // Dependency file: contracts/interfaces/CryptoAlpacaEnergyListener.sol
1277 
1278 
1279 // pragma solidity 0.6.12;
1280 
1281 // import "@openzeppelin/contracts/introspection/ERC165.sol";
1282 // import "contracts/interfaces/ICryptoAlpacaEnergyListener.sol";
1283 
1284 abstract contract CryptoAlpacaEnergyListener is
1285     ERC165,
1286     ICryptoAlpacaEnergyListener
1287 {
1288     constructor() public {
1289         _registerInterface(
1290             CryptoAlpacaEnergyListener(0).onCryptoAlpacaEnergyChanged.selector
1291         );
1292     }
1293 }
1294 
1295 
1296 // Root file: contracts/AlpacaSquad/AlpacaSquad.sol
1297 
1298 
1299 pragma solidity 0.6.12;
1300 
1301 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1302 // import "@openzeppelin/contracts/token/ERC1155/ERC1155Receiver.sol";
1303 // import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
1304 // import "@openzeppelin/contracts/utils/EnumerableMap.sol";
1305 // import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
1306 // import "@openzeppelin/contracts/math/SafeMath.sol";
1307 // import "@openzeppelin/contracts/math/Math.sol";
1308 // import "@openzeppelin/contracts/access/Ownable.sol";
1309 
1310 // import "contracts/interfaces/IAlpaToken.sol";
1311 // import "contracts/interfaces/IAlpaSupplier.sol";
1312 // import "contracts/interfaces/ICryptoAlpaca.sol";
1313 // import "contracts/interfaces/CryptoAlpacaEnergyListener.sol";
1314 
1315 // Alpaca Squad manages your you alpacas
1316 contract AlpacaSquad is
1317     Ownable,
1318     ReentrancyGuard,
1319     ERC1155Receiver,
1320     CryptoAlpacaEnergyListener
1321 {
1322     using SafeMath for uint256;
1323     using Math for uint256;
1324     using SafeERC20 for IERC20;
1325     using EnumerableMap for EnumerableMap.UintToAddressMap;
1326 
1327     // Info of each user.
1328     struct UserInfo {
1329         // Reward debt
1330         uint256 rewardDebt;
1331         // share
1332         uint256 share;
1333         // number of alpacas in this squad
1334         uint256 numAlpacas;
1335         // sum of alpaca energy
1336         uint256 sumEnergy;
1337     }
1338 
1339     // Info of Reward.
1340     struct RewardInfo {
1341         // Last block number that ALPAs distribution occurs.
1342         uint256 lastRewardBlock;
1343         // Accumulated ALPAs per share. Share is determined by LP deposit and total alpaca's energy
1344         uint256 accAlpaPerShare;
1345         // Accumulated Share
1346         uint256 accShare;
1347     }
1348 
1349     /* ========== STATES ========== */
1350 
1351     // The ALPA ERC20 token
1352     IAlpaToken public alpa;
1353 
1354     // Crypto alpaca contract
1355     ICryptoAlpaca public cryptoAlpaca;
1356 
1357     // Alpa Supplier
1358     IAlpaSupplier public supplier;
1359 
1360     // farm pool info
1361     RewardInfo public rewardInfo;
1362 
1363     uint256 public maxAlpacaSquadCount = 20;
1364 
1365     // Info of each user.
1366     mapping(address => UserInfo) public userInfo;
1367 
1368     // map that keep tracks of the alpaca's original owner so contract knows where to send back when
1369     // users retrieves their alpacas
1370     EnumerableMap.UintToAddressMap private alpacaOriginalOwner;
1371 
1372     uint256 public constant SAFE_MULTIPLIER = 1e16;
1373 
1374     /* ========== CONSTRUCTOR ========== */
1375 
1376     constructor(
1377         IAlpaToken _alpa,
1378         ICryptoAlpaca _cryptoAlpaca,
1379         IAlpaSupplier _supplier,
1380         uint256 _startBlock
1381     ) public {
1382         alpa = _alpa;
1383         cryptoAlpaca = _cryptoAlpaca;
1384         supplier = _supplier;
1385         rewardInfo = RewardInfo({
1386             lastRewardBlock: block.number.max(_startBlock),
1387             accAlpaPerShare: 0,
1388             accShare: 0
1389         });
1390     }
1391 
1392     /* ========== PUBLIC ========== */
1393 
1394     /**
1395      * @dev View `_user` pending ALPAs
1396      */
1397     function pendingAlpa(address _user) external view returns (uint256) {
1398         UserInfo storage user = userInfo[_user];
1399 
1400         uint256 accAlpaPerShare = rewardInfo.accAlpaPerShare;
1401 
1402         if (
1403             block.number > rewardInfo.lastRewardBlock &&
1404             rewardInfo.accShare != 0
1405         ) {
1406             uint256 total = supplier.preview(
1407                 address(this),
1408                 rewardInfo.lastRewardBlock
1409             );
1410 
1411             accAlpaPerShare = accAlpaPerShare.add(
1412                 total.mul(SAFE_MULTIPLIER).div(rewardInfo.accShare)
1413             );
1414         }
1415 
1416         return
1417             user.share.mul(accAlpaPerShare).div(SAFE_MULTIPLIER).sub(
1418                 user.rewardDebt
1419             );
1420     }
1421 
1422     /**
1423      * @dev Update reward variables of the given pool to be up-to-date.
1424      */
1425     function updatePool() public {
1426         if (block.number <= rewardInfo.lastRewardBlock) {
1427             return;
1428         }
1429 
1430         if (rewardInfo.accShare == 0) {
1431             rewardInfo.lastRewardBlock = block.number;
1432             return;
1433         }
1434 
1435         uint256 reward = supplier.distribute(rewardInfo.lastRewardBlock);
1436         rewardInfo.accAlpaPerShare = rewardInfo.accAlpaPerShare.add(
1437             reward.mul(SAFE_MULTIPLIER).div(rewardInfo.accShare)
1438         );
1439 
1440         rewardInfo.lastRewardBlock = block.number;
1441     }
1442 
1443     /**
1444      * @dev Retrieve caller's alpacas
1445      */
1446     function retrieve(uint256[] memory _ids) public nonReentrant {
1447         require(_ids.length > 0, "AlpacaSquad: invalid argument");
1448 
1449         address sender = msg.sender;
1450         UserInfo storage user = userInfo[sender];
1451         (
1452             uint256 share,
1453             uint256 numAlpacas,
1454             uint256 sumEnergy
1455         ) = _calculateDeletion(sender, user, _ids);
1456 
1457         updatePool();
1458 
1459         uint256 pending = user
1460             .share
1461             .mul(rewardInfo.accAlpaPerShare)
1462             .div(SAFE_MULTIPLIER)
1463             .sub(user.rewardDebt);
1464         if (pending > 0) {
1465             _safeAlpaTransfer(sender, pending);
1466         }
1467 
1468         // Update user reward debt with new share
1469         user.rewardDebt = share.mul(rewardInfo.accAlpaPerShare).div(
1470             SAFE_MULTIPLIER
1471         );
1472 
1473         // Update reward info accumulated share
1474         rewardInfo.accShare = rewardInfo.accShare.add(share).sub(user.share);
1475 
1476         user.share = share;
1477         user.numAlpacas = numAlpacas;
1478         user.sumEnergy = sumEnergy;
1479 
1480         for (uint256 i = 0; i < _ids.length; i++) {
1481             alpacaOriginalOwner.remove(_ids[i]);
1482             cryptoAlpaca.safeTransferFrom(
1483                 address(this),
1484                 sender,
1485                 _ids[i],
1486                 1,
1487                 ""
1488             );
1489         }
1490     }
1491 
1492     /**
1493      * @dev Claim user reward
1494      */
1495     function claim() public nonReentrant {
1496         updatePool();
1497         address sender = msg.sender;
1498 
1499         UserInfo storage user = userInfo[sender];
1500         if (user.sumEnergy > 0) {
1501             uint256 pending = user
1502                 .share
1503                 .mul(rewardInfo.accAlpaPerShare)
1504                 .div(SAFE_MULTIPLIER)
1505                 .sub(user.rewardDebt);
1506 
1507             if (pending > 0) {
1508                 _safeAlpaTransfer(sender, pending);
1509             }
1510 
1511             user.rewardDebt = user.share.mul(rewardInfo.accAlpaPerShare).div(
1512                 SAFE_MULTIPLIER
1513             );
1514         }
1515     }
1516 
1517     /* ========== ERC1155Receiver ========== */
1518 
1519     /**
1520      * @dev onERC1155Received implementation per IERC1155Receiver spec
1521      */
1522     function onERC1155Received(
1523         address,
1524         address _from,
1525         uint256 _id,
1526         uint256,
1527         bytes memory
1528     ) external override nonReentrant fromCryptoAlpaca returns (bytes4) {
1529         UserInfo storage user = userInfo[_from];
1530         uint256[] memory ids = _asSingletonArray(_id);
1531         (
1532             uint256 share,
1533             uint256 numAlpacas,
1534             uint256 sumEnergy
1535         ) = _calculateAddition(user, ids);
1536 
1537         updatePool();
1538 
1539         if (user.sumEnergy > 0) {
1540             uint256 pending = user
1541                 .share
1542                 .mul(rewardInfo.accAlpaPerShare)
1543                 .div(SAFE_MULTIPLIER)
1544                 .sub(user.rewardDebt);
1545             if (pending > 0) {
1546                 _safeAlpaTransfer(_from, pending);
1547             }
1548         }
1549 
1550         // Update user reward debt with new share
1551         user.rewardDebt = share.mul(rewardInfo.accAlpaPerShare).div(
1552             SAFE_MULTIPLIER
1553         );
1554 
1555         // Update reward info accumulated share
1556         rewardInfo.accShare = rewardInfo.accShare.add(share).sub(user.share);
1557 
1558         user.share = share;
1559         user.numAlpacas = numAlpacas;
1560         user.sumEnergy = sumEnergy;
1561 
1562         // Give original owner the right to breed
1563         cryptoAlpaca.grandPermissionToBreed(_from, _id);
1564 
1565         // store original owner
1566         alpacaOriginalOwner.set(_id, _from);
1567 
1568         return
1569             bytes4(
1570                 keccak256(
1571                     "onERC1155Received(address,address,uint256,uint256,bytes)"
1572                 )
1573             );
1574     }
1575 
1576     /**
1577      * @dev onERC1155BatchReceived implementation per IERC1155Receiver spec
1578      */
1579     function onERC1155BatchReceived(
1580         address,
1581         address _from,
1582         uint256[] memory _ids,
1583         uint256[] memory,
1584         bytes memory
1585     ) external override nonReentrant fromCryptoAlpaca returns (bytes4) {
1586         UserInfo storage user = userInfo[_from];
1587         (
1588             uint256 share,
1589             uint256 numAlpacas,
1590             uint256 sumEnergy
1591         ) = _calculateAddition(user, _ids);
1592 
1593         updatePool();
1594 
1595         if (user.sumEnergy > 0) {
1596             uint256 pending = user
1597                 .share
1598                 .mul(rewardInfo.accAlpaPerShare)
1599                 .div(SAFE_MULTIPLIER)
1600                 .sub(user.rewardDebt);
1601             if (pending > 0) {
1602                 _safeAlpaTransfer(_from, pending);
1603             }
1604         }
1605 
1606         // Update user reward debt with new share
1607         user.rewardDebt = share.mul(rewardInfo.accAlpaPerShare).div(
1608             SAFE_MULTIPLIER
1609         );
1610 
1611         // Update reward info accumulated share
1612         rewardInfo.accShare = rewardInfo.accShare.add(share).sub(user.share);
1613 
1614         user.share = share;
1615         user.numAlpacas = numAlpacas;
1616         user.sumEnergy = sumEnergy;
1617 
1618         // Give original owner the right to breed
1619         for (uint256 i = 0; i < _ids.length; i++) {
1620             // store original owner
1621             alpacaOriginalOwner.set(_ids[i], _from);
1622 
1623             // Give original owner the right to breed
1624             cryptoAlpaca.grandPermissionToBreed(_from, _ids[i]);
1625         }
1626 
1627         return
1628             bytes4(
1629                 keccak256(
1630                     "onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"
1631                 )
1632             );
1633     }
1634 
1635     /* ========== ICryptoAlpacaEnergyListener ========== */
1636 
1637     /**
1638         @dev Handles the Alpaca energy change callback.
1639         @param _id The id of the Alpaca which the energy changed
1640         @param _newEnergy The new alpaca energy it changed to
1641     */
1642     function onCryptoAlpacaEnergyChanged(
1643         uint256 _id,
1644         uint256 _oldEnergy,
1645         uint256 _newEnergy
1646     ) external override fromCryptoAlpaca ownsAlpaca(_id) {
1647         address from = alpacaOriginalOwner.get(_id);
1648         UserInfo storage user = userInfo[from];
1649 
1650         uint256 sumEnergy = user.sumEnergy.add(_newEnergy).sub(_oldEnergy);
1651         uint256 share = sumEnergy.mul(sumEnergy).div(user.numAlpacas);
1652 
1653         updatePool();
1654 
1655         if (user.sumEnergy > 0) {
1656             uint256 pending = user
1657                 .share
1658                 .mul(rewardInfo.accAlpaPerShare)
1659                 .div(SAFE_MULTIPLIER)
1660                 .sub(user.rewardDebt);
1661             if (pending > 0) {
1662                 _safeAlpaTransfer(from, pending);
1663             }
1664         }
1665         // Update user reward debt with new share
1666         user.rewardDebt = share.mul(rewardInfo.accAlpaPerShare).div(
1667             SAFE_MULTIPLIER
1668         );
1669 
1670         // Update reward info accumulated share
1671         rewardInfo.accShare = rewardInfo.accShare.add(share).sub(user.share);
1672 
1673         user.share = share;
1674         user.sumEnergy = sumEnergy;
1675     }
1676 
1677     /* ========== PRIVATE ========== */
1678 
1679     /**
1680      * @dev given user and array of alpacas ids, it validate the alpacas
1681      * and calculates the user share, numAlpacas, and sumEnergy after the addition
1682      */
1683     function _calculateAddition(UserInfo storage _user, uint256[] memory _ids)
1684         private
1685         view
1686         returns (
1687             uint256 share,
1688             uint256 numAlpacas,
1689             uint256 sumEnergy
1690         )
1691     {
1692         require(
1693             _user.numAlpacas + _ids.length <= maxAlpacaSquadCount,
1694             "AlpacaSquad: Max alpaca reached"
1695         );
1696         numAlpacas = _user.numAlpacas + _ids.length;
1697         sumEnergy = _user.sumEnergy;
1698 
1699         for (uint256 i = 0; i < _ids.length; i++) {
1700             uint256 id = _ids[i];
1701             require(id != 0, "AlpacaSquad: invalid alpaca");
1702 
1703             // Fetch alpaca energy and state
1704             (, , , , , , , , , , , uint256 energy, uint256 state) = cryptoAlpaca
1705                 .getAlpaca(id);
1706             require(state == 1, "AlpacaFarm: invalid alpaca state");
1707             require(energy > 0, "AlpacaFarm: invalid alpaca energy");
1708             sumEnergy = sumEnergy.add(energy);
1709         }
1710 
1711         share = sumEnergy.mul(sumEnergy).div(numAlpacas);
1712     }
1713 
1714     function _calculateDeletion(
1715         address owner,
1716         UserInfo storage _user,
1717         uint256[] memory _ids
1718     )
1719         private
1720         view
1721         returns (
1722             uint256 share,
1723             uint256 numAlpacas,
1724             uint256 sumEnergy
1725         )
1726     {
1727         numAlpacas = _user.numAlpacas.sub(_ids.length);
1728         sumEnergy = _user.sumEnergy;
1729 
1730         for (uint256 i = 0; i < _ids.length; i++) {
1731             uint256 id = _ids[i];
1732             require(
1733                 alpacaOriginalOwner.get(id) == owner,
1734                 "AlpacaFarm: original owner not found"
1735             );
1736 
1737             // Fetch alpaca energy and state
1738             (, , , , , , , , , , , uint256 energy, ) = cryptoAlpaca.getAlpaca(
1739                 id
1740             );
1741             sumEnergy = sumEnergy.sub(energy);
1742         }
1743 
1744         if (numAlpacas > 0) {
1745             share = sumEnergy.mul(sumEnergy).div(numAlpacas);
1746         }
1747     }
1748 
1749     function _asSingletonArray(uint256 element)
1750         private
1751         pure
1752         returns (uint256[] memory)
1753     {
1754         uint256[] memory array = new uint256[](1);
1755         array[0] = element;
1756 
1757         return array;
1758     }
1759 
1760     // Safe alpa transfer function, just in case if rounding error causes pool to not have enough ALPAs.
1761     function _safeAlpaTransfer(address _to, uint256 _amount) private {
1762         uint256 alpaBal = alpa.balanceOf(address(this));
1763         if (_amount > alpaBal) {
1764             alpa.transfer(_to, alpaBal);
1765         } else {
1766             alpa.transfer(_to, _amount);
1767         }
1768     }
1769 
1770     /* ========== Owner ========== */
1771 
1772     function setMaxAlpacaSquadCount(uint256 _count) public onlyOwner {
1773         maxAlpacaSquadCount = _count;
1774     }
1775 
1776     /* ========== MODIFIER ========== */
1777 
1778     modifier fromCryptoAlpaca() {
1779         require(
1780             msg.sender == address(cryptoAlpaca),
1781             "AlpacaFarm: received alpaca from unauthenticated contract"
1782         );
1783         _;
1784     }
1785 
1786     modifier ownsAlpaca(uint256 _id) {
1787         require(
1788             alpacaOriginalOwner.contains(_id),
1789             "AlpacaFarm: original owner not found"
1790         );
1791         _;
1792     }
1793 }