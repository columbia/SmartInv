1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 /*
162  * @dev Provides information about the current execution context, including the
163  * sender of the transaction and its data. While these are generally available
164  * via msg.sender and msg.data, they should not be accessed in such a direct
165  * manner, since when dealing with GSN meta-transactions the account sending and
166  * paying for execution may not be the actual sender (as far as an application
167  * is concerned).
168  *
169  * This contract is only required for intermediate, library-like contracts.
170  */
171 abstract contract Context {
172     function _msgSender() internal view virtual returns (address payable) {
173         return msg.sender;
174     }
175 
176     function _msgData() internal view virtual returns (bytes memory) {
177         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
178         return msg.data;
179     }
180 }
181 
182 /**
183  * @dev String operations.
184  */
185 library Strings {
186     /**
187      * @dev Converts a `uint256` to its ASCII `string` representation.
188      */
189     function toString(uint256 value) internal pure returns (string memory) {
190         // Inspired by OraclizeAPI's implementation - MIT licence
191         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
192 
193         if (value == 0) {
194             return "0";
195         }
196         uint256 temp = value;
197         uint256 digits;
198         while (temp != 0) {
199             digits++;
200             temp /= 10;
201         }
202         bytes memory buffer = new bytes(digits);
203         uint256 index = digits - 1;
204         temp = value;
205         while (temp != 0) {
206             buffer[index--] = byte(uint8(48 + temp % 10));
207             temp /= 10;
208         }
209         return string(buffer);
210     }
211 }
212 
213 
214 /**
215  * @dev Collection of functions related to the address type
216  */
217 library Address {
218     /**
219      * @dev Returns true if `account` is a contract.
220      *
221      * [IMPORTANT]
222      * ====
223      * It is unsafe to assume that an address for which this function returns
224      * false is an externally-owned account (EOA) and not a contract.
225      *
226      * Among others, `isContract` will return false for the following
227      * types of addresses:
228      *
229      *  - an externally-owned account
230      *  - a contract in construction
231      *  - an address where a contract will be created
232      *  - an address where a contract lived, but was destroyed
233      * ====
234      */
235     function isContract(address account) internal view returns (bool) {
236         // This method relies on extcodesize, which returns 0 for contracts in
237         // construction, since the code is only stored at the end of the
238         // constructor execution.
239 
240         uint256 size;
241         // solhint-disable-next-line no-inline-assembly
242         assembly { size := extcodesize(account) }
243         return size > 0;
244     }
245 
246     /**
247      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
248      * `recipient`, forwarding all available gas and reverting on errors.
249      *
250      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
251      * of certain opcodes, possibly making contracts go over the 2300 gas limit
252      * imposed by `transfer`, making them unable to receive funds via
253      * `transfer`. {sendValue} removes this limitation.
254      *
255      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
256      *
257      * IMPORTANT: because control is transferred to `recipient`, care must be
258      * taken to not create reentrancy vulnerabilities. Consider using
259      * {ReentrancyGuard} or the
260      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
261      */
262     function sendValue(address payable recipient, uint256 amount) internal {
263         require(address(this).balance >= amount, "Address: insufficient balance");
264 
265         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
266         (bool success, ) = recipient.call{ value: amount }("");
267         require(success, "Address: unable to send value, recipient may have reverted");
268     }
269 
270     /**
271      * @dev Performs a Solidity function call using a low level `call`. A
272      * plain`call` is an unsafe replacement for a function call: use this
273      * function instead.
274      *
275      * If `target` reverts with a revert reason, it is bubbled up by this
276      * function (like regular Solidity function calls).
277      *
278      * Returns the raw returned data. To convert to the expected return value,
279      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
280      *
281      * Requirements:
282      *
283      * - `target` must be a contract.
284      * - calling `target` with `data` must not revert.
285      *
286      * _Available since v3.1._
287      */
288     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
289       return functionCall(target, data, "Address: low-level call failed");
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
294      * `errorMessage` as a fallback revert reason when `target` reverts.
295      *
296      * _Available since v3.1._
297      */
298     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
299         return functionCallWithValue(target, data, 0, errorMessage);
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
304      * but also transferring `value` wei to `target`.
305      *
306      * Requirements:
307      *
308      * - the calling contract must have an ETH balance of at least `value`.
309      * - the called Solidity function must be `payable`.
310      *
311      * _Available since v3.1._
312      */
313     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
314         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
319      * with `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
324         require(address(this).balance >= value, "Address: insufficient balance for call");
325         require(isContract(target), "Address: call to non-contract");
326 
327         // solhint-disable-next-line avoid-low-level-calls
328         (bool success, bytes memory returndata) = target.call{ value: value }(data);
329         return _verifyCallResult(success, returndata, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but performing a static call.
335      *
336      * _Available since v3.3._
337      */
338     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
339         return functionStaticCall(target, data, "Address: low-level static call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
344      * but performing a static call.
345      *
346      * _Available since v3.3._
347      */
348     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
349         require(isContract(target), "Address: static call to non-contract");
350 
351         // solhint-disable-next-line avoid-low-level-calls
352         (bool success, bytes memory returndata) = target.staticcall(data);
353         return _verifyCallResult(success, returndata, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but performing a delegate call.
359      *
360      * _Available since v3.3._
361      */
362     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
363         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
368      * but performing a delegate call.
369      *
370      * _Available since v3.3._
371      */
372     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
373         require(isContract(target), "Address: delegate call to non-contract");
374 
375         // solhint-disable-next-line avoid-low-level-calls
376         (bool success, bytes memory returndata) = target.delegatecall(data);
377         return _verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
381         if (success) {
382             return returndata;
383         } else {
384             // Look for revert reason and bubble it up if present
385             if (returndata.length > 0) {
386                 // The easiest way to bubble the revert reason is using memory via assembly
387 
388                 // solhint-disable-next-line no-inline-assembly
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 /**
401  * @dev Interface of the ERC165 standard, as defined in the
402  * https://eips.ethereum.org/EIPS/eip-165[EIP].
403  *
404  * Implementers can declare support of contract interfaces, which can then be
405  * queried by others ({ERC165Checker}).
406  *
407  * For an implementation, see {ERC165}.
408  */
409 interface IERC165 {
410     /**
411      * @dev Returns true if this contract implements the interface defined by
412      * `interfaceId`. See the corresponding
413      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
414      * to learn more about how these ids are created.
415      *
416      * This function call must use less than 30 000 gas.
417      */
418     function supportsInterface(bytes4 interfaceId) external view returns (bool);
419 }
420 
421 /**
422  * @dev Implementation of the {IERC165} interface.
423  *
424  * Contracts may inherit from this and call {_registerInterface} to declare
425  * their support of an interface.
426  */
427 contract ERC165 is IERC165 {
428     /*
429      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
430      */
431     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
432 
433     /**
434      * @dev Mapping of interface ids to whether or not it's supported.
435      */
436     mapping(bytes4 => bool) private _supportedInterfaces;
437 
438     constructor () {
439         // Derived contracts need only register support for their own interfaces,
440         // we register support for ERC165 itself here
441         _registerInterface(_INTERFACE_ID_ERC165);
442     }
443 
444     /**
445      * @dev See {IERC165-supportsInterface}.
446      *
447      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
448      */
449     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
450         return _supportedInterfaces[interfaceId];
451     }
452 
453     /**
454      * @dev Registers the contract as an implementer of the interface defined by
455      * `interfaceId`. Support of the actual ERC165 interface is automatic and
456      * registering its interface id is not required.
457      *
458      * See {IERC165-supportsInterface}.
459      *
460      * Requirements:
461      *
462      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
463      */
464     function _registerInterface(bytes4 interfaceId) internal virtual {
465         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
466         _supportedInterfaces[interfaceId] = true;
467     }
468 }
469 
470 /**
471  * @dev Interface of the ERC20 standard as defined in the EIP.
472  */
473 interface IERC20 {
474     /**
475      * @dev Returns the amount of tokens in existence.
476      */
477     function totalSupply() external view returns (uint256);
478 
479     /**
480      * @dev Returns the amount of tokens owned by `account`.
481      */
482     function balanceOf(address account) external view returns (uint256);
483 
484     /**
485      * @dev Moves `amount` tokens from the caller's account to `recipient`.
486      *
487      * Returns a boolean value indicating whether the operation succeeded.
488      *
489      * Emits a {Transfer} event.
490      */
491     function transfer(address recipient, uint256 amount) external returns (bool);
492 
493     /**
494      * @dev Returns the remaining number of tokens that `spender` will be
495      * allowed to spend on behalf of `owner` through {transferFrom}. This is
496      * zero by default.
497      *
498      * This value changes when {approve} or {transferFrom} are called.
499      */
500     function allowance(address owner, address spender) external view returns (uint256);
501 
502     /**
503      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
504      *
505      * Returns a boolean value indicating whether the operation succeeded.
506      *
507      * IMPORTANT: Beware that changing an allowance with this method brings the risk
508      * that someone may use both the old and the new allowance by unfortunate
509      * transaction ordering. One possible solution to mitigate this race
510      * condition is to first reduce the spender's allowance to 0 and set the
511      * desired value afterwards:
512      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
513      *
514      * Emits an {Approval} event.
515      */
516     function approve(address spender, uint256 amount) external returns (bool);
517 
518     /**
519      * @dev Moves `amount` tokens from `sender` to `recipient` using the
520      * allowance mechanism. `amount` is then deducted from the caller's
521      * allowance.
522      *
523      * Returns a boolean value indicating whether the operation succeeded.
524      *
525      * Emits a {Transfer} event.
526      */
527     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
528 
529 
530     /**
531      * TODO: Add comment
532      */
533     function burn(uint256 burnQuantity) external returns (bool);
534 
535     /**
536      * @dev Emitted when `value` tokens are moved from one account (`from`) to
537      * another (`to`).
538      *
539      * Note that `value` may be zero.
540      */
541     event Transfer(address indexed from, address indexed to, uint256 value);
542 
543     /**
544      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
545      * a call to {approve}. `value` is the new allowance.
546      */
547     event Approval(address indexed owner, address indexed spender, uint256 value);
548 }
549 
550 /**
551  * @dev Required interface of an ERC721 compliant contract.
552  */
553 interface IERC721 is IERC165 {
554     /**
555      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
556      */
557     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
558 
559     /**
560      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
561      */
562     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
563 
564     /**
565      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
566      */
567     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
568 
569     /**
570      * @dev Returns the number of tokens in ``owner``'s account.
571      */
572     function balanceOf(address owner) external view returns (uint256 balance);
573 
574     /**
575      * @dev Returns the owner of the `tokenId` token.
576      *
577      * Requirements:
578      *
579      * - `tokenId` must exist.
580      */
581     function ownerOf(uint256 tokenId) external view returns (address owner);
582 
583     /**
584      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
585      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
586      *
587      * Requirements:
588      *
589      * - `from` cannot be the zero address.
590      * - `to` cannot be the zero address.
591      * - `tokenId` token must exist and be owned by `from`.
592      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
593      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
594      *
595      * Emits a {Transfer} event.
596      */
597     function safeTransferFrom(address from, address to, uint256 tokenId) external;
598 
599     /**
600      * @dev Transfers `tokenId` token from `from` to `to`.
601      *
602      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
603      *
604      * Requirements:
605      *
606      * - `from` cannot be the zero address.
607      * - `to` cannot be the zero address.
608      * - `tokenId` token must be owned by `from`.
609      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
610      *
611      * Emits a {Transfer} event.
612      */
613     function transferFrom(address from, address to, uint256 tokenId) external;
614 
615     /**
616      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
617      * The approval is cleared when the token is transferred.
618      *
619      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
620      *
621      * Requirements:
622      *
623      * - The caller must own the token or be an approved operator.
624      * - `tokenId` must exist.
625      *
626      * Emits an {Approval} event.
627      */
628     function approve(address to, uint256 tokenId) external;
629 
630     /**
631      * @dev Returns the account approved for `tokenId` token.
632      *
633      * Requirements:
634      *
635      * - `tokenId` must exist.
636      */
637     function getApproved(uint256 tokenId) external view returns (address operator);
638 
639     /**
640      * @dev Approve or remove `operator` as an operator for the caller.
641      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
642      *
643      * Requirements:
644      *
645      * - The `operator` cannot be the caller.
646      *
647      * Emits an {ApprovalForAll} event.
648      */
649     function setApprovalForAll(address operator, bool _approved) external;
650 
651     /**
652      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
653      *
654      * See {setApprovalForAll}
655      */
656     function isApprovedForAll(address owner, address operator) external view returns (bool);
657 
658     /**
659       * @dev Safely transfers `tokenId` token from `from` to `to`.
660       *
661       * Requirements:
662       *
663      * - `from` cannot be the zero address.
664      * - `to` cannot be the zero address.
665       * - `tokenId` token must exist and be owned by `from`.
666       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
667       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
668       *
669       * Emits a {Transfer} event.
670       */
671     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
672 }
673 
674 /**
675  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
676  * @dev See https://eips.ethereum.org/EIPS/eip-721
677  */
678 interface IERC721Enumerable is IERC721 {
679 
680     /**
681      * @dev Returns the total amount of tokens stored by the contract.
682      */
683     function totalSupply() external view returns (uint256);
684 
685     /**
686      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
687      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
688      */
689     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
690 
691     /**
692      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
693      * Use along with {totalSupply} to enumerate all tokens.
694      */
695     function tokenByIndex(uint256 index) external view returns (uint256);
696 }
697 
698 /**
699  * @dev Library for managing an enumerable variant of Solidity's
700  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
701  * type.
702  *
703  * Maps have the following properties:
704  *
705  * - Entries are added, removed, and checked for existence in constant time
706  * (O(1)).
707  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
708  *
709  * ```
710  * contract Example {
711  *     // Add the library methods
712  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
713  *
714  *     // Declare a set state variable
715  *     EnumerableMap.UintToAddressMap private myMap;
716  * }
717  * ```
718  *
719  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
720  * supported.
721  */
722 library EnumerableMap {
723     // To implement this library for multiple types with as little code
724     // repetition as possible, we write it in terms of a generic Map type with
725     // bytes32 keys and values.
726     // The Map implementation uses private functions, and user-facing
727     // implementations (such as Uint256ToAddressMap) are just wrappers around
728     // the underlying Map.
729     // This means that we can only create new EnumerableMaps for types that fit
730     // in bytes32.
731 
732     struct MapEntry {
733         bytes32 _key;
734         bytes32 _value;
735     }
736 
737     struct Map {
738         // Storage of map keys and values
739         MapEntry[] _entries;
740 
741         // Position of the entry defined by a key in the `entries` array, plus 1
742         // because index 0 means a key is not in the map.
743         mapping (bytes32 => uint256) _indexes;
744     }
745 
746     /**
747      * @dev Adds a key-value pair to a map, or updates the value for an existing
748      * key. O(1).
749      *
750      * Returns true if the key was added to the map, that is if it was not
751      * already present.
752      */
753     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
754         // We read and store the key's index to prevent multiple reads from the same storage slot
755         uint256 keyIndex = map._indexes[key];
756 
757         if (keyIndex == 0) { // Equivalent to !contains(map, key)
758             map._entries.push(MapEntry({ _key: key, _value: value }));
759             // The entry is stored at length-1, but we add 1 to all indexes
760             // and use 0 as a sentinel value
761             map._indexes[key] = map._entries.length;
762             return true;
763         } else {
764             map._entries[keyIndex - 1]._value = value;
765             return false;
766         }
767     }
768 
769     /**
770      * @dev Removes a key-value pair from a map. O(1).
771      *
772      * Returns true if the key was removed from the map, that is if it was present.
773      */
774     function _remove(Map storage map, bytes32 key) private returns (bool) {
775         // We read and store the key's index to prevent multiple reads from the same storage slot
776         uint256 keyIndex = map._indexes[key];
777 
778         if (keyIndex != 0) { // Equivalent to contains(map, key)
779             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
780             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
781             // This modifies the order of the array, as noted in {at}.
782 
783             uint256 toDeleteIndex = keyIndex - 1;
784             uint256 lastIndex = map._entries.length - 1;
785 
786             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
787             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
788 
789             MapEntry storage lastEntry = map._entries[lastIndex];
790 
791             // Move the last entry to the index where the entry to delete is
792             map._entries[toDeleteIndex] = lastEntry;
793             // Update the index for the moved entry
794             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
795 
796             // Delete the slot where the moved entry was stored
797             map._entries.pop();
798 
799             // Delete the index for the deleted slot
800             delete map._indexes[key];
801 
802             return true;
803         } else {
804             return false;
805         }
806     }
807 
808     /**
809      * @dev Returns true if the key is in the map. O(1).
810      */
811     function _contains(Map storage map, bytes32 key) private view returns (bool) {
812         return map._indexes[key] != 0;
813     }
814 
815     /**
816      * @dev Returns the number of key-value pairs in the map. O(1).
817      */
818     function _length(Map storage map) private view returns (uint256) {
819         return map._entries.length;
820     }
821 
822    /**
823     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
824     *
825     * Note that there are no guarantees on the ordering of entries inside the
826     * array, and it may change when more entries are added or removed.
827     *
828     * Requirements:
829     *
830     * - `index` must be strictly less than {length}.
831     */
832     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
833         require(map._entries.length > index, "EnumerableMap: index out of bounds");
834 
835         MapEntry storage entry = map._entries[index];
836         return (entry._key, entry._value);
837     }
838 
839     /**
840      * @dev Returns the value associated with `key`.  O(1).
841      *
842      * Requirements:
843      *
844      * - `key` must be in the map.
845      */
846     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
847         return _get(map, key, "EnumerableMap: nonexistent key");
848     }
849 
850     /**
851      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
852      */
853     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
854         uint256 keyIndex = map._indexes[key];
855         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
856         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
857     }
858 
859     // UintToAddressMap
860 
861     struct UintToAddressMap {
862         Map _inner;
863     }
864 
865     /**
866      * @dev Adds a key-value pair to a map, or updates the value for an existing
867      * key. O(1).
868      *
869      * Returns true if the key was added to the map, that is if it was not
870      * already present.
871      */
872     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
873         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
874     }
875 
876     /**
877      * @dev Removes a value from a set. O(1).
878      *
879      * Returns true if the key was removed from the map, that is if it was present.
880      */
881     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
882         return _remove(map._inner, bytes32(key));
883     }
884 
885     /**
886      * @dev Returns true if the key is in the map. O(1).
887      */
888     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
889         return _contains(map._inner, bytes32(key));
890     }
891 
892     /**
893      * @dev Returns the number of elements in the map. O(1).
894      */
895     function length(UintToAddressMap storage map) internal view returns (uint256) {
896         return _length(map._inner);
897     }
898 
899    /**
900     * @dev Returns the element stored at position `index` in the set. O(1).
901     * Note that there are no guarantees on the ordering of values inside the
902     * array, and it may change when more values are added or removed.
903     *
904     * Requirements:
905     *
906     * - `index` must be strictly less than {length}.
907     */
908     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
909         (bytes32 key, bytes32 value) = _at(map._inner, index);
910         return (uint256(key), address(uint256(value)));
911     }
912 
913     /**
914      * @dev Returns the value associated with `key`.  O(1).
915      *
916      * Requirements:
917      *
918      * - `key` must be in the map.
919      */
920     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
921         return address(uint256(_get(map._inner, bytes32(key))));
922     }
923 
924     /**
925      * @dev Same as {get}, with a custom error message when `key` is not in the map.
926      */
927     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
928         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
929     }
930 }
931 
932 /**
933  * @dev Library for managing
934  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
935  * types.
936  *
937  * Sets have the following properties:
938  *
939  * - Elements are added, removed, and checked for existence in constant time
940  * (O(1)).
941  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
942  *
943  * ```
944  * contract Example {
945  *     // Add the library methods
946  *     using EnumerableSet for EnumerableSet.AddressSet;
947  *
948  *     // Declare a set state variable
949  *     EnumerableSet.AddressSet private mySet;
950  * }
951  * ```
952  *
953  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
954  * (`UintSet`) are supported.
955  */
956 library EnumerableSet {
957     // To implement this library for multiple types with as little code
958     // repetition as possible, we write it in terms of a generic Set type with
959     // bytes32 values.
960     // The Set implementation uses private functions, and user-facing
961     // implementations (such as AddressSet) are just wrappers around the
962     // underlying Set.
963     // This means that we can only create new EnumerableSets for types that fit
964     // in bytes32.
965 
966     struct Set {
967         // Storage of set values
968         bytes32[] _values;
969 
970         // Position of the value in the `values` array, plus 1 because index 0
971         // means a value is not in the set.
972         mapping (bytes32 => uint256) _indexes;
973     }
974 
975     /**
976      * @dev Add a value to a set. O(1).
977      *
978      * Returns true if the value was added to the set, that is if it was not
979      * already present.
980      */
981     function _add(Set storage set, bytes32 value) private returns (bool) {
982         if (!_contains(set, value)) {
983             set._values.push(value);
984             // The value is stored at length-1, but we add 1 to all indexes
985             // and use 0 as a sentinel value
986             set._indexes[value] = set._values.length;
987             return true;
988         } else {
989             return false;
990         }
991     }
992 
993     /**
994      * @dev Removes a value from a set. O(1).
995      *
996      * Returns true if the value was removed from the set, that is if it was
997      * present.
998      */
999     function _remove(Set storage set, bytes32 value) private returns (bool) {
1000         // We read and store the value's index to prevent multiple reads from the same storage slot
1001         uint256 valueIndex = set._indexes[value];
1002 
1003         if (valueIndex != 0) { // Equivalent to contains(set, value)
1004             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1005             // the array, and then remove the last element (sometimes called as 'swap and pop').
1006             // This modifies the order of the array, as noted in {at}.
1007 
1008             uint256 toDeleteIndex = valueIndex - 1;
1009             uint256 lastIndex = set._values.length - 1;
1010 
1011             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1012             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1013 
1014             bytes32 lastvalue = set._values[lastIndex];
1015 
1016             // Move the last value to the index where the value to delete is
1017             set._values[toDeleteIndex] = lastvalue;
1018             // Update the index for the moved value
1019             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1020 
1021             // Delete the slot where the moved value was stored
1022             set._values.pop();
1023 
1024             // Delete the index for the deleted slot
1025             delete set._indexes[value];
1026 
1027             return true;
1028         } else {
1029             return false;
1030         }
1031     }
1032 
1033     /**
1034      * @dev Returns true if the value is in the set. O(1).
1035      */
1036     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1037         return set._indexes[value] != 0;
1038     }
1039 
1040     /**
1041      * @dev Returns the number of values on the set. O(1).
1042      */
1043     function _length(Set storage set) private view returns (uint256) {
1044         return set._values.length;
1045     }
1046 
1047    /**
1048     * @dev Returns the value stored at position `index` in the set. O(1).
1049     *
1050     * Note that there are no guarantees on the ordering of values inside the
1051     * array, and it may change when more values are added or removed.
1052     *
1053     * Requirements:
1054     *
1055     * - `index` must be strictly less than {length}.
1056     */
1057     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1058         require(set._values.length > index, "EnumerableSet: index out of bounds");
1059         return set._values[index];
1060     }
1061 
1062     // AddressSet
1063 
1064     struct AddressSet {
1065         Set _inner;
1066     }
1067 
1068     /**
1069      * @dev Add a value to a set. O(1).
1070      *
1071      * Returns true if the value was added to the set, that is if it was not
1072      * already present.
1073      */
1074     function add(AddressSet storage set, address value) internal returns (bool) {
1075         return _add(set._inner, bytes32(uint256(value)));
1076     }
1077 
1078     /**
1079      * @dev Removes a value from a set. O(1).
1080      *
1081      * Returns true if the value was removed from the set, that is if it was
1082      * present.
1083      */
1084     function remove(AddressSet storage set, address value) internal returns (bool) {
1085         return _remove(set._inner, bytes32(uint256(value)));
1086     }
1087 
1088     /**
1089      * @dev Returns true if the value is in the set. O(1).
1090      */
1091     function contains(AddressSet storage set, address value) internal view returns (bool) {
1092         return _contains(set._inner, bytes32(uint256(value)));
1093     }
1094 
1095     /**
1096      * @dev Returns the number of values in the set. O(1).
1097      */
1098     function length(AddressSet storage set) internal view returns (uint256) {
1099         return _length(set._inner);
1100     }
1101 
1102    /**
1103     * @dev Returns the value stored at position `index` in the set. O(1).
1104     *
1105     * Note that there are no guarantees on the ordering of values inside the
1106     * array, and it may change when more values are added or removed.
1107     *
1108     * Requirements:
1109     *
1110     * - `index` must be strictly less than {length}.
1111     */
1112     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1113         return address(uint256(_at(set._inner, index)));
1114     }
1115 
1116 
1117     // UintSet
1118 
1119     struct UintSet {
1120         Set _inner;
1121     }
1122 
1123     /**
1124      * @dev Add a value to a set. O(1).
1125      *
1126      * Returns true if the value was added to the set, that is if it was not
1127      * already present.
1128      */
1129     function add(UintSet storage set, uint256 value) internal returns (bool) {
1130         return _add(set._inner, bytes32(value));
1131     }
1132 
1133     /**
1134      * @dev Removes a value from a set. O(1).
1135      *
1136      * Returns true if the value was removed from the set, that is if it was
1137      * present.
1138      */
1139     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1140         return _remove(set._inner, bytes32(value));
1141     }
1142 
1143     /**
1144      * @dev Returns true if the value is in the set. O(1).
1145      */
1146     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1147         return _contains(set._inner, bytes32(value));
1148     }
1149 
1150     /**
1151      * @dev Returns the number of values on the set. O(1).
1152      */
1153     function length(UintSet storage set) internal view returns (uint256) {
1154         return _length(set._inner);
1155     }
1156 
1157    /**
1158     * @dev Returns the value stored at position `index` in the set. O(1).
1159     *
1160     * Note that there are no guarantees on the ordering of values inside the
1161     * array, and it may change when more values are added or removed.
1162     *
1163     * Requirements:
1164     *
1165     * - `index` must be strictly less than {length}.
1166     */
1167     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1168         return uint256(_at(set._inner, index));
1169     }
1170 }
1171 
1172 contract Ownable is Context {
1173     address private _owner;
1174 
1175     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1176 
1177     /**
1178      * @dev Initializes the contract setting the deployer as the initial owner.
1179      */
1180     constructor () {
1181         address msgSender = _msgSender();
1182         _owner = msgSender;
1183         emit OwnershipTransferred(address(0), msgSender);
1184     }
1185 
1186     /**
1187      * @dev Returns the address of the current owner.
1188      */
1189     function owner() public view returns (address) {
1190         return _owner;
1191     }
1192 
1193     /**
1194      * @dev Throws if called by any account other than the owner.
1195      */
1196     modifier onlyOwner() {
1197         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1198         _;
1199     }
1200 
1201     /**
1202      * @dev Leaves the contract without owner. It will not be possible to call
1203      * `onlyOwner` functions anymore. Can only be called by the current owner.
1204      *
1205      * NOTE: Renouncing ownership will leave the contract without an owner,
1206      * thereby removing any functionality that is only available to the owner.
1207      */
1208     function renounceOwnership() public virtual onlyOwner {
1209         emit OwnershipTransferred(_owner, address(0));
1210         _owner = address(0);
1211     }
1212 
1213     /**
1214      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1215      * Can only be called by the current owner.
1216      */
1217     function transferOwnership(address newOwner) public virtual onlyOwner {
1218         require(newOwner != address(0), "Ownable: new owner is the zero address");
1219         emit OwnershipTransferred(_owner, newOwner);
1220         _owner = newOwner;
1221     }
1222 }
1223 
1224 interface IWaifus is IERC721Enumerable {
1225     function isMintedBeforeReveal(uint256 index) external view returns (bool);
1226 }
1227 
1228 /**
1229  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1230  * @dev See https://eips.ethereum.org/EIPS/eip-721
1231  */
1232 interface IERC721Metadata is IERC721 {
1233 
1234     /**
1235      * @dev Returns the token collection name.
1236      */
1237     function name() external view returns (string memory);
1238 
1239     /**
1240      * @dev Returns the token collection symbol.
1241      */
1242     function symbol() external view returns (string memory);
1243 }
1244 
1245 /**
1246  * @title ERC721 token receiver interface
1247  * @dev Interface for any contract that wants to support safeTransfers
1248  * from ERC721 asset contracts.
1249  */
1250 interface IERC721Receiver {
1251     /**
1252      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1253      * by `operator` from `from`, this function is called.
1254      *
1255      * It must return its Solidity selector to confirm the token transfer.
1256      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1257      *
1258      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1259      */
1260     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1261 }
1262 
1263 /**
1264  * @title Waifus contract
1265  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1266  */
1267 contract Waifus is Context, Ownable, ERC165, IWaifus, IERC721Metadata {
1268     using SafeMath for uint256;
1269     using Address for address;
1270     using EnumerableSet for EnumerableSet.UintSet;
1271     using EnumerableMap for EnumerableMap.UintToAddressMap;
1272     using Strings for uint256;
1273 
1274     // Public variables
1275 
1276     // This is the provenance record of all Waifus artwork in existence
1277     string public constant WAIFUS_PROVENANCE = "b9e2ad47185076f3f43847eeec601e7bc4a1cb51a208b34b5eb1c650cf06a546";
1278 
1279     uint256 public constant SALE_START_TIMESTAMP = 1614624600;
1280 
1281     // Time after which waifus are randomized and allotted
1282     uint256 public constant REVEAL_TIMESTAMP = SALE_START_TIMESTAMP + (86400 * 14); 
1283 
1284     uint256 public constant NAME_CHANGE_PRICE = 1830 * (10 ** 18);
1285 
1286     uint256 public constant MAX_NFT_SUPPLY = 16384;
1287 
1288     uint256 public startingIndexBlock;
1289 
1290     uint256 public startingIndex;
1291 
1292     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1293     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1294     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1295 
1296     // Mapping from holder address to their (enumerable) set of owned tokens
1297     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1298 
1299     // Enumerable mapping from token ids to their owners
1300     EnumerableMap.UintToAddressMap private _tokenOwners;
1301 
1302     // Mapping from token ID to approved address
1303     mapping (uint256 => address) private _tokenApprovals;
1304 
1305     // Mapping from token ID to name
1306     mapping (uint256 => string) private _tokenName;
1307 
1308     // Mapping if certain name string has already been reserved
1309     mapping (string => bool) private _nameReserved;
1310 
1311     // Mapping from token ID to whether the Waifus was minted before reveal
1312     mapping (uint256 => bool) private _mintedBeforeReveal;
1313     
1314     // Mapping from owner to operator approvals
1315     mapping (address => mapping (address => bool)) private _operatorApprovals;
1316 
1317     // Token name
1318     string private _name;
1319 
1320     // Token symbol
1321     string private _symbol;
1322 
1323     // Waifu Enhancement Token address
1324     address private _wetAddress;
1325     
1326     
1327 
1328     /*
1329      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1330      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1331      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1332      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1333      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1334      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1335      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1336      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1337      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1338      *
1339      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1340      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1341      */
1342     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1343 
1344     /*
1345      *     bytes4(keccak256('name()')) == 0x06fdde03
1346      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1347      *
1348      *     => 0x06fdde03 ^ 0x95d89b41 == 0x93254542
1349      */
1350     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x93254542;
1351 
1352     /*
1353      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1354      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1355      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1356      *
1357      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1358      */
1359     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1360 
1361     // Events
1362     event NameChange (uint256 indexed maskIndex, string newName);
1363 
1364     /**
1365      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1366      */
1367     constructor (string memory name, string memory symbol, address wetAddress) {
1368         _name = name;
1369         _symbol = symbol;
1370         _wetAddress = wetAddress;
1371 
1372         // register the supported interfaces to conform to ERC721 via ERC165
1373         _registerInterface(_INTERFACE_ID_ERC721);
1374         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1375         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1376     }
1377 
1378     /**
1379      * @dev See {IERC721-balanceOf}.
1380      */
1381     function balanceOf(address owner) public view override returns (uint256) {
1382         require(owner != address(0), "ERC721: balance query for the zero address");
1383 
1384         return _holderTokens[owner].length();
1385     }
1386 
1387     /**
1388      * @dev See {IERC721-ownerOf}.
1389      */
1390     function ownerOf(uint256 tokenId) public view override returns (address) {
1391         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1392     }
1393 
1394     /**
1395      * @dev See {IERC721Metadata-name}.
1396      */
1397     function name() public view override returns (string memory) {
1398         return _name;
1399     }
1400 
1401     /**
1402      * @dev See {IERC721Metadata-symbol}.
1403      */
1404     function symbol() public view override returns (string memory) {
1405         return _symbol;
1406     }
1407 
1408     /**
1409      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1410      */
1411     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1412         return _holderTokens[owner].at(index);
1413     }
1414 
1415     /**
1416      * @dev See {IERC721Enumerable-totalSupply}.
1417      */
1418     function totalSupply() public view override returns (uint256) {
1419         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1420         return _tokenOwners.length();
1421     }
1422 
1423     /**
1424      * @dev See {IERC721Enumerable-tokenByIndex}.
1425      */
1426     function tokenByIndex(uint256 index) public view override returns (uint256) {
1427         (uint256 tokenId, ) = _tokenOwners.at(index);
1428         return tokenId;
1429     }
1430 
1431     /**
1432      * @dev Returns name of the NFT at index.
1433      */
1434     function tokenNameByIndex(uint256 index) public view returns (string memory) {
1435         return _tokenName[index];
1436     }
1437 
1438     /**
1439      * @dev Returns if the name has been reserved.
1440      */
1441     function isNameReserved(string memory nameString) public view returns (bool) {
1442         return _nameReserved[toLower(nameString)];
1443     }
1444 
1445     /**
1446      * @dev Returns if the NFT has been minted before reveal phase
1447      */
1448     function isMintedBeforeReveal(uint256 index) public view override returns (bool) {
1449         return _mintedBeforeReveal[index];
1450     }
1451 
1452     /**
1453      * @dev Gets current Waifus Price
1454      */
1455     function getNFTPrice() public view returns (uint256) {
1456         require(block.timestamp >= SALE_START_TIMESTAMP, "Sale has not started");
1457         require(totalSupply() < MAX_NFT_SUPPLY, "Sale has already ended");
1458 
1459         uint currentSupply = totalSupply();
1460 
1461         if (currentSupply >= 16381) {
1462             return 100000000000000000000; // 16381 - 16383 100 ETH
1463         } else if (currentSupply >= 16000) {
1464             return 2000000000000000000; // 16000 - 16380 2.0 ETH
1465         } else if (currentSupply >= 15000) {
1466             return 1300000000000000000; // 15000  - 15999 1.3 ETH
1467         } else if (currentSupply >= 13000) {
1468             return 1100000000000000000; // 13000 - 14999 1.1 ETH
1469         } else if (currentSupply >= 11000) {
1470             return 900000000000000000; // 11000 - 12999 0.9 ETH
1471         } else if (currentSupply >= 9000) {
1472             return 700000000000000000; // 9000 - 10999 0.7 ETH
1473         } else if (currentSupply >= 7000) {
1474             return 500000000000000000; // 7000 - 8999 0.5 ETH
1475         } else if (currentSupply >= 5000) {
1476             return 400000000000000000; // 5000 - 6999 0.4 ETH
1477         } else if (currentSupply >= 3000) {
1478             return 300000000000000000; // 3000 - 4999 0.3 ETH
1479         } else if (currentSupply >= 1500) {
1480             return 200000000000000000; // 1500 - 2999 0.2 ETH
1481         } else {
1482             return 100000000000000000; // 0 - 1499 0.1 ETH 
1483         }
1484     }
1485 
1486     /**
1487     * @dev Mints Waifus
1488     */
1489     function mintNFT(uint256 numberOfNfts) public payable {
1490         require(totalSupply() < MAX_NFT_SUPPLY, "Sale has already ended");
1491         require(numberOfNfts > 0, "numberOfNfts cannot be 0");
1492         require(numberOfNfts <= 20, "You may not buy more than 20 NFTs at once");
1493         require(totalSupply().add(numberOfNfts) <= MAX_NFT_SUPPLY, "Exceeds MAX_NFT_SUPPLY");
1494         require(getNFTPrice().mul(numberOfNfts) == msg.value, "Ether value sent is not correct");
1495 
1496         for (uint i = 0; i < numberOfNfts; i++) {
1497             uint mintIndex = totalSupply();
1498             if (block.timestamp < REVEAL_TIMESTAMP) {
1499                 _mintedBeforeReveal[mintIndex] = true;
1500             }
1501             _safeMint(msg.sender, mintIndex);
1502         }
1503 
1504         /**
1505         * Source of randomness. Theoretical miner withhold manipulation possible but should be sufficient in a pragmatic sense
1506         */
1507         if (startingIndexBlock == 0 && (totalSupply() == MAX_NFT_SUPPLY || block.timestamp >= REVEAL_TIMESTAMP)) {
1508             startingIndexBlock = block.number;
1509         }
1510     }
1511 
1512     /**
1513      * @dev Finalize starting index
1514      */
1515     function finalizeStartingIndex() public {
1516         require(startingIndex == 0, "Starting index is already set");
1517         require(startingIndexBlock != 0, "Starting index block must be set");
1518         
1519         startingIndex = uint(blockhash(startingIndexBlock)) % MAX_NFT_SUPPLY;
1520         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1521         if (block.number.sub(startingIndexBlock) > 255) {
1522             startingIndex = uint(blockhash(block.number-1)) % MAX_NFT_SUPPLY;
1523         }
1524         // Prevent default sequence
1525         if (startingIndex == 0) {
1526             startingIndex = startingIndex.add(1);
1527         }
1528     }
1529 
1530     /**
1531      * @dev Changes the name for Waifus tokenId
1532      */
1533     function changeName(uint256 tokenId, string memory newName) public {
1534         address owner = ownerOf(tokenId);
1535 
1536         require(_msgSender() == owner, "ERC721: caller is not the owner");
1537         require(validateName(newName) == true, "Not a valid new name");
1538         require(sha256(bytes(newName)) != sha256(bytes(_tokenName[tokenId])), "New name is same as the current one");
1539         require(isNameReserved(newName) == false, "Name already reserved");
1540 
1541         IERC20(_wetAddress).transferFrom(msg.sender, address(this), NAME_CHANGE_PRICE);
1542         // If already named, dereserve old name
1543         if (bytes(_tokenName[tokenId]).length > 0) {
1544             toggleReserveName(_tokenName[tokenId], false);
1545         }
1546         toggleReserveName(newName, true);
1547         _tokenName[tokenId] = newName;
1548         IERC20(_wetAddress).burn(NAME_CHANGE_PRICE);
1549         emit NameChange(tokenId, newName);
1550     }
1551 
1552     /**
1553      * @dev Withdraw ether from this contract (Callable by owner)
1554     */
1555     function withdraw() onlyOwner public {
1556         uint balance = address(this).balance;
1557         msg.sender.transfer(balance);
1558     }
1559 
1560     /**
1561      * @dev See {IERC721-approve}.
1562      */
1563     function approve(address to, uint256 tokenId) public virtual override {
1564         address owner = ownerOf(tokenId);
1565         require(to != owner, "ERC721: approval to current owner");
1566 
1567         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1568             "ERC721: approve caller is not owner nor approved for all"
1569         );
1570 
1571         _approve(to, tokenId);
1572     }
1573 
1574     /**
1575      * @dev See {IERC721-getApproved}.
1576      */
1577     function getApproved(uint256 tokenId) public view override returns (address) {
1578         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1579 
1580         return _tokenApprovals[tokenId];
1581     }
1582 
1583     /**
1584      * @dev See {IERC721-setApprovalForAll}.
1585      */
1586     function setApprovalForAll(address operator, bool approved) public virtual override {
1587         require(operator != _msgSender(), "ERC721: approve to caller");
1588 
1589         _operatorApprovals[_msgSender()][operator] = approved;
1590         emit ApprovalForAll(_msgSender(), operator, approved);
1591     }
1592 
1593     /**
1594      * @dev See {IERC721-isApprovedForAll}.
1595      */
1596     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1597         return _operatorApprovals[owner][operator];
1598     }
1599 
1600     /**
1601      * @dev See {IERC721-transferFrom}.
1602      */
1603     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1604         //solhint-disable-next-line max-line-length
1605         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1606 
1607         _transfer(from, to, tokenId);
1608     }
1609 
1610     /**
1611      * @dev See {IERC721-safeTransferFrom}.
1612      */
1613     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1614         safeTransferFrom(from, to, tokenId, "");
1615     }
1616 
1617     /**
1618      * @dev See {IERC721-safeTransferFrom}.
1619      */
1620     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1621         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1622         _safeTransfer(from, to, tokenId, _data);
1623     }
1624 
1625     /**
1626      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1627      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1628      *
1629      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1630      *
1631      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1632      * implement alternative mechanisms to perform token transfer, such as signature-based.
1633      *
1634      * Requirements:
1635      *
1636      * - `from` cannot be the zero address.
1637      * - `to` cannot be the zero address.
1638      * - `tokenId` token must exist and be owned by `from`.
1639      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1640      *
1641      * Emits a {Transfer} event.
1642      */
1643     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1644         _transfer(from, to, tokenId);
1645         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1646     }
1647 
1648     /**
1649      * @dev Returns whether `tokenId` exists.
1650      *
1651      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1652      *
1653      * Tokens start existing when they are minted (`_mint`),
1654      * and stop existing when they are burned (`_burn`).
1655      */
1656     function _exists(uint256 tokenId) internal view returns (bool) {
1657         return _tokenOwners.contains(tokenId);
1658     }
1659 
1660     /**
1661      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1662      *
1663      * Requirements:
1664      *
1665      * - `tokenId` must exist.
1666      */
1667     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1668         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1669         address owner = ownerOf(tokenId);
1670         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1671     }
1672 
1673     /**
1674      * @dev Safely mints `tokenId` and transfers it to `to`.
1675      *
1676      * Requirements:
1677      d*
1678      * - `tokenId` must not exist.
1679      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1680      *
1681      * Emits a {Transfer} event.
1682      */
1683     function _safeMint(address to, uint256 tokenId) internal virtual {
1684         require(totalSupply() < 16385);
1685         _safeMint(to, tokenId, "");
1686 
1687     }
1688 
1689     /**
1690      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1691      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1692      */
1693     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1694         _mint(to, tokenId);
1695         require(totalSupply() < 16385);
1696         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1697     }
1698 
1699     /**
1700      * @dev Mints `tokenId` and transfers it to `to`.
1701      *
1702      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1703      *
1704      * Requirements:
1705      *
1706      * - `tokenId` must not exist.
1707      * - `to` cannot be the zero address.
1708      *
1709      * Emits a {Transfer} event.
1710      */
1711     function _mint(address to, uint256 tokenId) internal virtual {
1712         require(to != address(0), "ERC721: mint to the zero address");
1713         require(!_exists(tokenId), "ERC721: token already minted");
1714 
1715         _beforeTokenTransfer(address(0), to, tokenId);
1716 
1717         _holderTokens[to].add(tokenId);
1718 
1719         _tokenOwners.set(tokenId, to);
1720 
1721         emit Transfer(address(0), to, tokenId);
1722     }
1723 
1724     /**
1725      * @dev Destroys `tokenId`.
1726      * The approval is cleared when the token is burned.
1727      *
1728      * Requirements:
1729      *
1730      * - `tokenId` must exist.
1731      *
1732      * Emits a {Transfer} event.
1733      */
1734     function _burn(uint256 tokenId) internal virtual {
1735         address owner = ownerOf(tokenId);
1736 
1737         _beforeTokenTransfer(owner, address(0), tokenId);
1738 
1739         // Clear approvals
1740         _approve(address(0), tokenId);
1741 
1742         _holderTokens[owner].remove(tokenId);
1743 
1744         _tokenOwners.remove(tokenId);
1745 
1746         emit Transfer(owner, address(0), tokenId);
1747     }
1748 
1749     /**
1750      * @dev Transfers `tokenId` from `from` to `to`.
1751      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1752      *
1753      * Requirements:
1754      *
1755      * - `to` cannot be the zero address.
1756      * - `tokenId` token must be owned by `from`.
1757      *
1758      * Emits a {Transfer} event.
1759      */
1760     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1761         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1762         require(to != address(0), "ERC721: transfer to the zero address");
1763 
1764         _beforeTokenTransfer(from, to, tokenId);
1765 
1766         // Clear approvals from the previous owner
1767         _approve(address(0), tokenId);
1768 
1769         _holderTokens[from].remove(tokenId);
1770         _holderTokens[to].add(tokenId);
1771 
1772         _tokenOwners.set(tokenId, to);
1773 
1774         emit Transfer(from, to, tokenId);
1775     }
1776 
1777 
1778     /**
1779      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1780      * The call is not executed if the target address is not a contract.
1781      *
1782      * @param from address representing the previous owner of the given token ID
1783      * @param to target address that will receive the tokens
1784      * @param tokenId uint256 ID of the token to be transferred
1785      * @param _data bytes optional data to send along with the call
1786      * @return bool whether the call correctly returned the expected magic value
1787      */
1788     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1789         private returns (bool)
1790     {
1791         if (!to.isContract()) {
1792             return true;
1793         }
1794         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1795             IERC721Receiver(to).onERC721Received.selector,
1796             _msgSender(),
1797             from,
1798             tokenId,
1799             _data
1800         ), "ERC721: transfer to non ERC721Receiver implementer");
1801         bytes4 retval = abi.decode(returndata, (bytes4));
1802         return (retval == _ERC721_RECEIVED);
1803     }
1804 
1805     function _approve(address to, uint256 tokenId) private {
1806         _tokenApprovals[tokenId] = to;
1807         emit Approval(ownerOf(tokenId), to, tokenId);
1808     }
1809 
1810     /**
1811      * @dev Hook that is called before any token transfer. This includes minting
1812      * and burning.
1813      *
1814      * Calling conditions:
1815      *
1816      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1817      * transferred to `to`.
1818      * - When `from` is zero, `tokenId` will be minted for `to`.
1819      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1820      * - `from` cannot be the zero address.
1821      * - `to` cannot be the zero address.
1822      *
1823      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1824      */
1825     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1826 
1827     /**
1828      * @dev Reserves the name if isReserve is set to true, de-reserves if set to false
1829      */
1830     function toggleReserveName(string memory str, bool isReserve) internal {
1831         _nameReserved[toLower(str)] = isReserve;
1832     }
1833 
1834     /**
1835      * @dev Check if the name string is valid (Alphanumeric and spaces without leading or trailing space)
1836      */
1837     function validateName(string memory str) public pure returns (bool){
1838         bytes memory b = bytes(str);
1839         if(b.length < 1) return false;
1840         if(b.length > 25) return false; // Cannot be longer than 25 characters
1841         if(b[0] == 0x20) return false; // Leading space
1842         if (b[b.length - 1] == 0x20) return false; // Trailing space
1843 
1844         bytes1 lastChar = b[0];
1845 
1846         for(uint i; i<b.length; i++){
1847             bytes1 char = b[i];
1848 
1849             if (char == 0x20 && lastChar == 0x20) return false; // Cannot contain continous spaces
1850 
1851             if(
1852                 !(char >= 0x30 && char <= 0x39) && //9-0
1853                 !(char >= 0x41 && char <= 0x5A) && //A-Z
1854                 !(char >= 0x61 && char <= 0x7A) && //a-z
1855                 !(char == 0x20) //space
1856             )
1857                 return false;
1858 
1859             lastChar = char;
1860         }
1861 
1862         return true;
1863     }
1864 
1865     /**
1866      * @dev Converts the string to lowercase
1867      */
1868     function toLower(string memory str) public pure returns (string memory){
1869         bytes memory bStr = bytes(str);
1870         bytes memory bLower = new bytes(bStr.length);
1871         for (uint i = 0; i < bStr.length; i++) {
1872             // Uppercase character
1873             if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
1874                 bLower[i] = bytes1(uint8(bStr[i]) + 32);
1875             } else {
1876                 bLower[i] = bStr[i];
1877             }
1878         }
1879         return string(bLower);
1880     }
1881 }