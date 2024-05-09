1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // CAUTION
5 // This version of SafeMath should only be used with Solidity 0.8 or later,
6 // because it relies on the compiler's built in overflow checks.
7 
8 /**
9  * @dev Wrappers over Solidity's arithmetic operations.
10  *
11  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
12  * now has built in overflow checking.
13  */
14 library SafeMath {
15     /**
16      * @dev Returns the addition of two unsigned integers, with an overflow flag.
17      *
18      * _Available since v3.4._
19      */
20     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
21         unchecked {
22             uint256 c = a + b;
23             if (c < a) return (false, 0);
24             return (true, c);
25         }
26     }
27 
28     /**
29      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
30      *
31      * _Available since v3.4._
32      */
33     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         unchecked {
35             if (b > a) return (false, 0);
36             return (true, a - b);
37         }
38     }
39 
40     /**
41      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         unchecked {
47             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48             // benefit is lost if 'b' is also tested.
49             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
50             if (a == 0) return (true, 0);
51             uint256 c = a * b;
52             if (c / a != b) return (false, 0);
53             return (true, c);
54         }
55     }
56 
57     /**
58      * @dev Returns the division of two unsigned integers, with a division by zero flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         unchecked {
64             if (b == 0) return (false, 0);
65             return (true, a / b);
66         }
67     }
68 
69     /**
70      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         unchecked {
76             if (b == 0) return (false, 0);
77             return (true, a % b);
78         }
79     }
80 
81     /**
82      * @dev Returns the addition of two unsigned integers, reverting on
83      * overflow.
84      *
85      * Counterpart to Solidity's `+` operator.
86      *
87      * Requirements:
88      *
89      * - Addition cannot overflow.
90      */
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         return a + b;
93     }
94 
95     /**
96      * @dev Returns the subtraction of two unsigned integers, reverting on
97      * overflow (when the result is negative).
98      *
99      * Counterpart to Solidity's `-` operator.
100      *
101      * Requirements:
102      *
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         return a - b;
107     }
108 
109     /**
110      * @dev Returns the multiplication of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `*` operator.
114      *
115      * Requirements:
116      *
117      * - Multiplication cannot overflow.
118      */
119     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
120         return a * b;
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers, reverting on
125      * division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator.
128      *
129      * Requirements:
130      *
131      * - The divisor cannot be zero.
132      */
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a / b;
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
139      * reverting when dividing by zero.
140      *
141      * Counterpart to Solidity's `%` operator. This function uses a `revert`
142      * opcode (which leaves remaining gas untouched) while Solidity uses an
143      * invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      *
147      * - The divisor cannot be zero.
148      */
149     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
150         return a % b;
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * CAUTION: This function is deprecated because it requires allocating memory for the error
158      * message unnecessarily. For custom revert reasons use {trySub}.
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         unchecked {
168             require(b <= a, errorMessage);
169             return a - b;
170         }
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         unchecked {
191             require(b > 0, errorMessage);
192             return a / b;
193         }
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * reverting with custom message when dividing by zero.
199      *
200      * CAUTION: This function is deprecated because it requires allocating memory for the error
201      * message unnecessarily. For custom revert reasons use {tryMod}.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
212         unchecked {
213             require(b > 0, errorMessage);
214             return a % b;
215         }
216     }
217 }
218 
219 /**
220  * @dev Interface of the ERC165 standard, as defined in the
221  * https://eips.ethereum.org/EIPS/eip-165[EIP].
222  *
223  * Implementers can declare support of contract interfaces, which can then be
224  * queried by others ({ERC165Checker}).
225  *
226  * For an implementation, see {ERC165}.
227  */
228 interface IERC165 {
229     /**
230      * @dev Returns true if this contract implements the interface defined by
231      * `interfaceId`. See the corresponding
232      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
233      * to learn more about how these ids are created.
234      *
235      * This function call must use less than 30 000 gas.
236      */
237     function supportsInterface(bytes4 interfaceId) external view returns (bool);
238 }
239 
240 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
241 
242 /**
243  * @dev Required interface of an ERC721 compliant contract.
244  */
245 interface IERC721 is IERC165 {
246     /**
247      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
248      */
249     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
250 
251     /**
252      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
253      */
254     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
255 
256     /**
257      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
258      */
259     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
260 
261     /**
262      * @dev Returns the number of tokens in ``owner``'s account.
263      */
264     function balanceOf(address owner) external view returns (uint256 balance);
265 
266     /**
267      * @dev Returns the owner of the `tokenId` token.
268      *
269      * Requirements:
270      *
271      * - `tokenId` must exist.
272      */
273     function ownerOf(uint256 tokenId) external view returns (address owner);
274 
275     /**
276      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
277      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
278      *
279      * Requirements:
280      *
281      * - `from` cannot be the zero address.
282      * - `to` cannot be the zero address.
283      * - `tokenId` token must exist and be owned by `from`.
284      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
285      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
286      *
287      * Emits a {Transfer} event.
288      */
289     function safeTransferFrom(address from, address to, uint256 tokenId) external;
290 
291     /**
292      * @dev Transfers `tokenId` token from `from` to `to`.
293      *
294      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
295      *
296      * Requirements:
297      *
298      * - `from` cannot be the zero address.
299      * - `to` cannot be the zero address.
300      * - `tokenId` token must be owned by `from`.
301      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
302      *
303      * Emits a {Transfer} event.
304      */
305     function transferFrom(address from, address to, uint256 tokenId) external;
306 
307     /**
308      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
309      * The approval is cleared when the token is transferred.
310      *
311      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
312      *
313      * Requirements:
314      *
315      * - The caller must own the token or be an approved operator.
316      * - `tokenId` must exist.
317      *
318      * Emits an {Approval} event.
319      */
320     function approve(address to, uint256 tokenId) external;
321 
322     /**
323      * @dev Returns the account approved for `tokenId` token.
324      *
325      * Requirements:
326      *
327      * - `tokenId` must exist.
328      */
329     function getApproved(uint256 tokenId) external view returns (address operator);
330 
331     /**
332      * @dev Approve or remove `operator` as an operator for the caller.
333      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
334      *
335      * Requirements:
336      *
337      * - The `operator` cannot be the caller.
338      *
339      * Emits an {ApprovalForAll} event.
340      */
341     function setApprovalForAll(address operator, bool _approved) external;
342 
343     /**
344      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
345      *
346      * See {setApprovalForAll}
347      */
348     function isApprovedForAll(address owner, address operator) external view returns (bool);
349 
350     /**
351       * @dev Safely transfers `tokenId` token from `from` to `to`.
352       *
353       * Requirements:
354       *
355       * - `from` cannot be the zero address.
356       * - `to` cannot be the zero address.
357       * - `tokenId` token must exist and be owned by `from`.
358       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
359       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
360       *
361       * Emits a {Transfer} event.
362       */
363     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
364 }
365 
366 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
367 
368 /**
369  * @title ERC721 token receiver interface
370  * @dev Interface for any contract that wants to support safeTransfers
371  * from ERC721 asset contracts.
372  */
373 interface IERC721Receiver {
374     /**
375      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
376      * by `operator` from `from`, this function is called.
377      *
378      * It must return its Solidity selector to confirm the token transfer.
379      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
380      *
381      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
382      */
383     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
384 }
385 
386 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
387 
388 /**
389  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
390  * @dev See https://eips.ethereum.org/EIPS/eip-721
391  */
392 interface IERC721Metadata is IERC721 {
393 
394     /**
395      * @dev Returns the token collection name.
396      */
397     function name() external view returns (string memory);
398 
399     /**
400      * @dev Returns the token collection symbol.
401      */
402     function symbol() external view returns (string memory);
403 
404     /**
405      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
406      */
407     function tokenURI(uint256 tokenId) external view returns (string memory);
408 }
409 
410 // File: @openzeppelin/contracts/utils/Address.sol
411 
412 /**
413  * @dev Collection of functions related to the address type
414  */
415 library Address {
416     /**
417      * @dev Returns true if `account` is a contract.
418      *
419      * [IMPORTANT]
420      * ====
421      * It is unsafe to assume that an address for which this function returns
422      * false is an externally-owned account (EOA) and not a contract.
423      *
424      * Among others, `isContract` will return false for the following
425      * types of addresses:
426      *
427      *  - an externally-owned account
428      *  - a contract in construction
429      *  - an address where a contract will be created
430      *  - an address where a contract lived, but was destroyed
431      * ====
432      */
433     function isContract(address account) internal view returns (bool) {
434         // This method relies on extcodesize, which returns 0 for contracts in
435         // construction, since the code is only stored at the end of the
436         // constructor execution.
437 
438         uint256 size;
439         // solhint-disable-next-line no-inline-assembly
440         assembly { size := extcodesize(account) }
441         return size > 0;
442     }
443 
444     /**
445      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
446      * `recipient`, forwarding all available gas and reverting on errors.
447      *
448      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
449      * of certain opcodes, possibly making contracts go over the 2300 gas limit
450      * imposed by `transfer`, making them unable to receive funds via
451      * `transfer`. {sendValue} removes this limitation.
452      *
453      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
454      *
455      * IMPORTANT: because control is transferred to `recipient`, care must be
456      * taken to not create reentrancy vulnerabilities. Consider using
457      * {ReentrancyGuard} or the
458      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
459      */
460     function sendValue(address payable recipient, uint256 amount) internal {
461         require(address(this).balance >= amount, "Address: insufficient balance");
462 
463         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
464         (bool success, ) = recipient.call{ value: amount }("");
465         require(success, "Address: unable to send value, recipient may have reverted");
466     }
467 
468     /**
469      * @dev Performs a Solidity function call using a low level `call`. A
470      * plain`call` is an unsafe replacement for a function call: use this
471      * function instead.
472      *
473      * If `target` reverts with a revert reason, it is bubbled up by this
474      * function (like regular Solidity function calls).
475      *
476      * Returns the raw returned data. To convert to the expected return value,
477      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
478      *
479      * Requirements:
480      *
481      * - `target` must be a contract.
482      * - calling `target` with `data` must not revert.
483      *
484      * _Available since v3.1._
485      */
486     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
487       return functionCall(target, data, "Address: low-level call failed");
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
492      * `errorMessage` as a fallback revert reason when `target` reverts.
493      *
494      * _Available since v3.1._
495      */
496     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
497         return functionCallWithValue(target, data, 0, errorMessage);
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
502      * but also transferring `value` wei to `target`.
503      *
504      * Requirements:
505      *
506      * - the calling contract must have an ETH balance of at least `value`.
507      * - the called Solidity function must be `payable`.
508      *
509      * _Available since v3.1._
510      */
511     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
512         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
517      * with `errorMessage` as a fallback revert reason when `target` reverts.
518      *
519      * _Available since v3.1._
520      */
521     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
522         require(address(this).balance >= value, "Address: insufficient balance for call");
523         require(isContract(target), "Address: call to non-contract");
524 
525         // solhint-disable-next-line avoid-low-level-calls
526         (bool success, bytes memory returndata) = target.call{ value: value }(data);
527         return _verifyCallResult(success, returndata, errorMessage);
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
532      * but performing a static call.
533      *
534      * _Available since v3.3._
535      */
536     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
537         return functionStaticCall(target, data, "Address: low-level static call failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
542      * but performing a static call.
543      *
544      * _Available since v3.3._
545      */
546     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
547         require(isContract(target), "Address: static call to non-contract");
548 
549         // solhint-disable-next-line avoid-low-level-calls
550         (bool success, bytes memory returndata) = target.staticcall(data);
551         return _verifyCallResult(success, returndata, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but performing a delegate call.
557      *
558      * _Available since v3.4._
559      */
560     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
561         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
566      * but performing a delegate call.
567      *
568      * _Available since v3.4._
569      */
570     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
571         require(isContract(target), "Address: delegate call to non-contract");
572 
573         // solhint-disable-next-line avoid-low-level-calls
574         (bool success, bytes memory returndata) = target.delegatecall(data);
575         return _verifyCallResult(success, returndata, errorMessage);
576     }
577 
578     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
579         if (success) {
580             return returndata;
581         } else {
582             // Look for revert reason and bubble it up if present
583             if (returndata.length > 0) {
584                 // The easiest way to bubble the revert reason is using memory via assembly
585 
586                 // solhint-disable-next-line no-inline-assembly
587                 assembly {
588                     let returndata_size := mload(returndata)
589                     revert(add(32, returndata), returndata_size)
590                 }
591             } else {
592                 revert(errorMessage);
593             }
594         }
595     }
596 }
597 
598 // File: @openzeppelin/contracts/utils/Context.sol
599 
600 /*
601  * @dev Provides information about the current execution context, including the
602  * sender of the transaction and its data. While these are generally available
603  * via msg.sender and msg.data, they should not be accessed in such a direct
604  * manner, since when dealing with meta-transactions the account sending and
605  * paying for execution may not be the actual sender (as far as an application
606  * is concerned).
607  *
608  * This contract is only required for intermediate, library-like contracts.
609  */
610 abstract contract Context {
611     function _msgSender() internal view virtual returns (address) {
612         return msg.sender;
613     }
614 
615     function _msgData() internal view virtual returns (bytes calldata) {
616         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
617         return msg.data;
618     }
619 }
620 
621 // File: @openzeppelin/contracts/utils/Strings.sol
622 
623 /**
624  * @dev String operations.
625  */
626 library Strings {
627     bytes16 private constant alphabet = "0123456789abcdef";
628 
629     /**
630      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
631      */
632     function toString(uint256 value) internal pure returns (string memory) {
633         // Inspired by OraclizeAPI's implementation - MIT licence
634         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
635 
636         if (value == 0) {
637             return "0";
638         }
639         uint256 temp = value;
640         uint256 digits;
641         while (temp != 0) {
642             digits++;
643             temp /= 10;
644         }
645         bytes memory buffer = new bytes(digits);
646         while (value != 0) {
647             digits -= 1;
648             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
649             value /= 10;
650         }
651         return string(buffer);
652     }
653 
654     /**
655      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
656      */
657     function toHexString(uint256 value) internal pure returns (string memory) {
658         if (value == 0) {
659             return "0x00";
660         }
661         uint256 temp = value;
662         uint256 length = 0;
663         while (temp != 0) {
664             length++;
665             temp >>= 8;
666         }
667         return toHexString(value, length);
668     }
669 
670     /**
671      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
672      */
673     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
674         bytes memory buffer = new bytes(2 * length + 2);
675         buffer[0] = "0";
676         buffer[1] = "x";
677         for (uint256 i = 2 * length + 1; i > 1; --i) {
678             buffer[i] = alphabet[value & 0xf];
679             value >>= 4;
680         }
681         require(value == 0, "Strings: hex length insufficient");
682         return string(buffer);
683     }
684 
685 }
686 
687 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
688 
689 
690 /**
691  * @dev Implementation of the {IERC165} interface.
692  *
693  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
694  * for the additional interface id that will be supported. For example:
695  *
696  * ```solidity
697  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
698  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
699  * }
700  * ```
701  *
702  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
703  */
704 abstract contract ERC165 is IERC165 {
705     /**
706      * @dev See {IERC165-supportsInterface}.
707      */
708     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
709         return interfaceId == type(IERC165).interfaceId;
710     }
711 }
712 
713 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
714 
715 /**
716  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
717  * the Metadata extension, but not including the Enumerable extension, which is available separately as
718  * {ERC721Enumerable}.
719  */
720 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
721     using Address for address;
722     using Strings for uint256;
723 
724     // Token name
725     string private _name;
726 
727     // Token symbol
728     string private _symbol;
729 
730     // Mapping from token ID to owner address
731     mapping (uint256 => address) private _owners;
732 
733     // Mapping owner address to token count
734     mapping (address => uint256) private _balances;
735 
736     // Mapping from token ID to approved address
737     mapping (uint256 => address) private _tokenApprovals;
738 
739     // Mapping from owner to operator approvals
740     mapping (address => mapping (address => bool)) private _operatorApprovals;
741 
742     /**
743      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
744      */
745     constructor (string memory name_, string memory symbol_) {
746         _name = name_;
747         _symbol = symbol_;
748     }
749 
750     /**
751      * @dev See {IERC165-supportsInterface}.
752      */
753     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
754         return interfaceId == type(IERC721).interfaceId
755             || interfaceId == type(IERC721Metadata).interfaceId
756             || super.supportsInterface(interfaceId);
757     }
758 
759     /**
760      * @dev See {IERC721-balanceOf}.
761      */
762     function balanceOf(address owner) public view virtual override returns (uint256) {
763         require(owner != address(0), "ERC721: balance query for the zero address");
764         return _balances[owner];
765     }
766 
767     /**
768      * @dev See {IERC721-ownerOf}.
769      */
770     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
771         address owner = _owners[tokenId];
772         require(owner != address(0), "ERC721: owner query for nonexistent token");
773         return owner;
774     }
775 
776     /**
777      * @dev See {IERC721Metadata-name}.
778      */
779     function name() public view virtual override returns (string memory) {
780         return _name;
781     }
782 
783     /**
784      * @dev See {IERC721Metadata-symbol}.
785      */
786     function symbol() public view virtual override returns (string memory) {
787         return _symbol;
788     }
789 
790     /**
791      * @dev See {IERC721Metadata-tokenURI}.
792      */
793     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
794         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
795 
796         string memory baseURI = _baseURI();
797         return bytes(baseURI).length > 0
798             ? string(abi.encodePacked(baseURI, tokenId.toString()))
799             : '';
800     }
801 
802     /**
803      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
804      * in child contracts.
805      */
806     function _baseURI() internal view virtual returns (string memory) {
807         return "";
808     }
809 
810     /**
811      * @dev See {IERC721-approve}.
812      */
813     function approve(address to, uint256 tokenId) public virtual override {
814         address owner = ERC721.ownerOf(tokenId);
815         require(to != owner, "ERC721: approval to current owner");
816 
817         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
818             "ERC721: approve caller is not owner nor approved for all"
819         );
820 
821         _approve(to, tokenId);
822     }
823 
824     /**
825      * @dev See {IERC721-getApproved}.
826      */
827     function getApproved(uint256 tokenId) public view virtual override returns (address) {
828         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
829 
830         return _tokenApprovals[tokenId];
831     }
832 
833     /**
834      * @dev See {IERC721-setApprovalForAll}.
835      */
836     function setApprovalForAll(address operator, bool approved) public virtual override {
837         require(operator != _msgSender(), "ERC721: approve to caller");
838 
839         _operatorApprovals[_msgSender()][operator] = approved;
840         emit ApprovalForAll(_msgSender(), operator, approved);
841     }
842 
843     /**
844      * @dev See {IERC721-isApprovedForAll}.
845      */
846     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
847         return _operatorApprovals[owner][operator];
848     }
849 
850     /**
851      * @dev See {IERC721-transferFrom}.
852      */
853     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
854         //solhint-disable-next-line max-line-length
855         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
856 
857         _transfer(from, to, tokenId);
858     }
859 
860     /**
861      * @dev See {IERC721-safeTransferFrom}.
862      */
863     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
864         safeTransferFrom(from, to, tokenId, "");
865     }
866 
867     /**
868      * @dev See {IERC721-safeTransferFrom}.
869      */
870     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
871         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
872         _safeTransfer(from, to, tokenId, _data);
873     }
874 
875     /**
876      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
877      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
878      *
879      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
880      *
881      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
882      * implement alternative mechanisms to perform token transfer, such as signature-based.
883      *
884      * Requirements:
885      *
886      * - `from` cannot be the zero address.
887      * - `to` cannot be the zero address.
888      * - `tokenId` token must exist and be owned by `from`.
889      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
890      *
891      * Emits a {Transfer} event.
892      */
893     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
894         _transfer(from, to, tokenId);
895         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
896     }
897 
898     /**
899      * @dev Returns whether `tokenId` exists.
900      *
901      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
902      *
903      * Tokens start existing when they are minted (`_mint`),
904      * and stop existing when they are burned (`_burn`).
905      */
906     function _exists(uint256 tokenId) internal view virtual returns (bool) {
907         return _owners[tokenId] != address(0);
908     }
909 
910     /**
911      * @dev Returns whether `spender` is allowed to manage `tokenId`.
912      *
913      * Requirements:
914      *
915      * - `tokenId` must exist.
916      */
917     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
918         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
919         address owner = ERC721.ownerOf(tokenId);
920         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
921     }
922 
923     /**
924      * @dev Safely mints `tokenId` and transfers it to `to`.
925      *
926      * Requirements:
927      *
928      * - `tokenId` must not exist.
929      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
930      *
931      * Emits a {Transfer} event.
932      */
933     function _safeMint(address to, uint256 tokenId) internal virtual {
934         _safeMint(to, tokenId, "");
935     }
936 
937     /**
938      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
939      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
940      */
941     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
942         _mint(to, tokenId);
943         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
944     }
945 
946     /**
947      * @dev Mints `tokenId` and transfers it to `to`.
948      *
949      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
950      *
951      * Requirements:
952      *
953      * - `tokenId` must not exist.
954      * - `to` cannot be the zero address.
955      *
956      * Emits a {Transfer} event.
957      */
958     function _mint(address to, uint256 tokenId) internal virtual {
959         require(to != address(0), "ERC721: mint to the zero address");
960         require(!_exists(tokenId), "ERC721: token already minted");
961 
962         _beforeTokenTransfer(address(0), to, tokenId);
963 
964         _balances[to] += 1;
965         _owners[tokenId] = to;
966 
967         emit Transfer(address(0), to, tokenId);
968     }
969 
970     /**
971      * @dev Destroys `tokenId`.
972      * The approval is cleared when the token is burned.
973      *
974      * Requirements:
975      *
976      * - `tokenId` must exist.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _burn(uint256 tokenId) internal virtual {
981         address owner = ERC721.ownerOf(tokenId);
982 
983         _beforeTokenTransfer(owner, address(0), tokenId);
984 
985         // Clear approvals
986         _approve(address(0), tokenId);
987 
988         _balances[owner] -= 1;
989         delete _owners[tokenId];
990 
991         emit Transfer(owner, address(0), tokenId);
992     }
993 
994     /**
995      * @dev Transfers `tokenId` from `from` to `to`.
996      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
997      *
998      * Requirements:
999      *
1000      * - `to` cannot be the zero address.
1001      * - `tokenId` token must be owned by `from`.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1006         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1007         require(to != address(0), "ERC721: transfer to the zero address");
1008 
1009         _beforeTokenTransfer(from, to, tokenId);
1010 
1011         // Clear approvals from the previous owner
1012         _approve(address(0), tokenId);
1013 
1014         _balances[from] -= 1;
1015         _balances[to] += 1;
1016         _owners[tokenId] = to;
1017 
1018         emit Transfer(from, to, tokenId);
1019     }
1020 
1021     /**
1022      * @dev Approve `to` to operate on `tokenId`
1023      *
1024      * Emits a {Approval} event.
1025      */
1026     function _approve(address to, uint256 tokenId) internal virtual {
1027         _tokenApprovals[tokenId] = to;
1028         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1029     }
1030 
1031     /**
1032      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1033      * The call is not executed if the target address is not a contract.
1034      *
1035      * @param from address representing the previous owner of the given token ID
1036      * @param to target address that will receive the tokens
1037      * @param tokenId uint256 ID of the token to be transferred
1038      * @param _data bytes optional data to send along with the call
1039      * @return bool whether the call correctly returned the expected magic value
1040      */
1041     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1042         private returns (bool)
1043     {
1044         if (to.isContract()) {
1045             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1046                 return retval == IERC721Receiver(to).onERC721Received.selector;
1047             } catch (bytes memory reason) {
1048                 if (reason.length == 0) {
1049                     revert("ERC721: transfer to non ERC721Receiver implementer");
1050                 } else {
1051                     // solhint-disable-next-line no-inline-assembly
1052                     assembly {
1053                         revert(add(32, reason), mload(reason))
1054                     }
1055                 }
1056             }
1057         } else {
1058             return true;
1059         }
1060     }
1061 
1062     /**
1063      * @dev Hook that is called before any token transfer. This includes minting
1064      * and burning.
1065      *
1066      * Calling conditions:
1067      *
1068      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1069      * transferred to `to`.
1070      * - When `from` is zero, `tokenId` will be minted for `to`.
1071      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1072      * - `from` cannot be the zero address.
1073      * - `to` cannot be the zero address.
1074      *
1075      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1076      */
1077     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1078 }
1079 
1080 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1081 
1082 /**
1083  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1084  * @dev See https://eips.ethereum.org/EIPS/eip-721
1085  */
1086 interface IERC721Enumerable is IERC721 {
1087 
1088     /**
1089      * @dev Returns the total amount of tokens stored by the contract.
1090      */
1091     function totalSupply() external view returns (uint256);
1092 
1093     /**
1094      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1095      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1096      */
1097     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1098 
1099     /**
1100      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1101      * Use along with {totalSupply} to enumerate all tokens.
1102      */
1103     function tokenByIndex(uint256 index) external view returns (uint256);
1104 }
1105 
1106 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1107 
1108 /**
1109  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1110  * enumerability of all the token ids in the contract as well as all token ids owned by each
1111  * account.
1112  */
1113 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1114     // Mapping from owner to list of owned token IDs
1115     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1116 
1117     // Mapping from token ID to index of the owner tokens list
1118     mapping(uint256 => uint256) private _ownedTokensIndex;
1119 
1120     // Array with all token ids, used for enumeration
1121     uint256[] private _allTokens;
1122 
1123     // Mapping from token id to position in the allTokens array
1124     mapping(uint256 => uint256) private _allTokensIndex;
1125 
1126     /**
1127      * @dev See {IERC165-supportsInterface}.
1128      */
1129     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1130         return interfaceId == type(IERC721Enumerable).interfaceId
1131             || super.supportsInterface(interfaceId);
1132     }
1133 
1134     /**
1135      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1136      */
1137     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1138         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1139         return _ownedTokens[owner][index];
1140     }
1141 
1142     /**
1143      * @dev See {IERC721Enumerable-totalSupply}.
1144      */
1145     function totalSupply() public view virtual override returns (uint256) {
1146         return _allTokens.length;
1147     }
1148 
1149     /**
1150      * @dev See {IERC721Enumerable-tokenByIndex}.
1151      */
1152     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1153         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1154         return _allTokens[index];
1155     }
1156 
1157     /**
1158      * @dev Hook that is called before any token transfer. This includes minting
1159      * and burning.
1160      *
1161      * Calling conditions:
1162      *
1163      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1164      * transferred to `to`.
1165      * - When `from` is zero, `tokenId` will be minted for `to`.
1166      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1167      * - `from` cannot be the zero address.
1168      * - `to` cannot be the zero address.
1169      *
1170      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1171      */
1172     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1173         super._beforeTokenTransfer(from, to, tokenId);
1174 
1175         if (from == address(0)) {
1176             _addTokenToAllTokensEnumeration(tokenId);
1177         } else if (from != to) {
1178             _removeTokenFromOwnerEnumeration(from, tokenId);
1179         }
1180         if (to == address(0)) {
1181             _removeTokenFromAllTokensEnumeration(tokenId);
1182         } else if (to != from) {
1183             _addTokenToOwnerEnumeration(to, tokenId);
1184         }
1185     }
1186 
1187     /**
1188      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1189      * @param to address representing the new owner of the given token ID
1190      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1191      */
1192     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1193         uint256 length = ERC721.balanceOf(to);
1194         _ownedTokens[to][length] = tokenId;
1195         _ownedTokensIndex[tokenId] = length;
1196     }
1197 
1198     /**
1199      * @dev Private function to add a token to this extension's token tracking data structures.
1200      * @param tokenId uint256 ID of the token to be added to the tokens list
1201      */
1202     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1203         _allTokensIndex[tokenId] = _allTokens.length;
1204         _allTokens.push(tokenId);
1205     }
1206 
1207     /**
1208      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1209      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1210      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1211      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1212      * @param from address representing the previous owner of the given token ID
1213      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1214      */
1215     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1216         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1217         // then delete the last slot (swap and pop).
1218 
1219         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1220         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1221 
1222         // When the token to delete is the last token, the swap operation is unnecessary
1223         if (tokenIndex != lastTokenIndex) {
1224             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1225 
1226             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1227             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1228         }
1229 
1230         // This also deletes the contents at the last position of the array
1231         delete _ownedTokensIndex[tokenId];
1232         delete _ownedTokens[from][lastTokenIndex];
1233     }
1234 
1235     /**
1236      * @dev Private function to remove a token from this extension's token tracking data structures.
1237      * This has O(1) time complexity, but alters the order of the _allTokens array.
1238      * @param tokenId uint256 ID of the token to be removed from the tokens list
1239      */
1240     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1241         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1242         // then delete the last slot (swap and pop).
1243 
1244         uint256 lastTokenIndex = _allTokens.length - 1;
1245         uint256 tokenIndex = _allTokensIndex[tokenId];
1246 
1247         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1248         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1249         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1250         uint256 lastTokenId = _allTokens[lastTokenIndex];
1251 
1252         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1253         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1254 
1255         // This also deletes the contents at the last position of the array
1256         delete _allTokensIndex[tokenId];
1257         _allTokens.pop();
1258     }
1259 }
1260 
1261 // File: @openzeppelin/contracts/access/Ownable.sol
1262 
1263 /**
1264  * @dev Contract module which provides a basic access control mechanism, where
1265  * there is an account (an owner) that can be granted exclusive access to
1266  * specific functions.
1267  *
1268  * By default, the owner account will be the one that deploys the contract. This
1269  * can later be changed with {transferOwnership}.
1270  *
1271  * This module is used through inheritance. It will make available the modifier
1272  * `onlyOwner`, which can be applied to your functions to restrict their use to
1273  * the owner.
1274  */
1275 abstract contract Ownable is Context {
1276     address private _owner;
1277 
1278     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1279 
1280     /**
1281      * @dev Initializes the contract setting the deployer as the initial owner.
1282      */
1283     constructor () {
1284         address msgSender = _msgSender();
1285         _owner = msgSender;
1286         emit OwnershipTransferred(address(0), msgSender);
1287     }
1288 
1289     /**
1290      * @dev Returns the address of the current owner.
1291      */
1292     function owner() public view virtual returns (address) {
1293         return _owner;
1294     }
1295 
1296     /**
1297      * @dev Throws if called by any account other than the owner.
1298      */
1299     modifier onlyOwner() {
1300         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1301         _;
1302     }
1303 
1304     /**
1305      * @dev Leaves the contract without owner. It will not be possible to call
1306      * `onlyOwner` functions anymore. Can only be called by the current owner.
1307      *
1308      * NOTE: Renouncing ownership will leave the contract without an owner,
1309      * thereby removing any functionality that is only available to the owner.
1310      */
1311     function renounceOwnership() public virtual onlyOwner {
1312         emit OwnershipTransferred(_owner, address(0));
1313         _owner = address(0);
1314     }
1315 
1316     /**
1317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1318      * Can only be called by the current owner.
1319      */
1320     function transferOwnership(address newOwner) public virtual onlyOwner {
1321         require(newOwner != address(0), "Ownable: new owner is the zero address");
1322         emit OwnershipTransferred(_owner, newOwner);
1323         _owner = newOwner;
1324     }
1325 }
1326 
1327 // File: contracts/Lostboy.sol
1328 contract Lostboy is ERC721Enumerable, Ownable {
1329 
1330     using SafeMath for uint256;
1331 
1332     // Private members
1333     enum MemberClaimStatus { Invalid, Listed }                                  // Members, listed? 
1334     mapping (address => MemberClaimStatus) private _whiteListedMembers;         // Whitelisted members for presale
1335     mapping (address => uint256) private _whiteListMints;                       // Whitelisted mints per address
1336     string private m_BaseURI = "";                                              // Base URI
1337 
1338     // Supply / sale variables
1339     uint256 public MAX_LOSTBOYS = 10000;                                        // Maximum supply
1340     uint256 public MAX_PRESALE_BOYS_PER_ADDRESS = 50;                           // Total maximum boys for whitelisted wallet
1341     uint256 public lostBoyPrice = 50000000000000000;                            // 0.05 ETH
1342 
1343     // Per TX
1344     uint public maxBoysPerMint = 15;                                            // Max lostboys in one go !
1345     uint public maxBoysPerPresaleMint = 25;                                     // Max pre-sale lostboys in one go !
1346 
1347     // Active?!
1348     bool public mintingActive = false;                                          // Minting active
1349     bool public isPresaleActive = false;                                        // Presale active
1350 
1351     // Provenance
1352     string public provenanceHash = "";                                          // Provencance, data integrity
1353 
1354     // Donation
1355     uint public donationPercentage = 10;                                        // Percent to donate to charity wallet
1356     address public donationWallet = 0x9715f6a7510AA98D4F8eB8E17C9e01859a05937A; // The charity wallet all donations will go to when balance is withdrawn
1357 
1358     constructor(
1359         string memory name,
1360         string memory symbol,
1361         string memory baseURI
1362     ) ERC721(name, symbol) {
1363         m_BaseURI = baseURI;
1364     }
1365 
1366     // withdrawBalance
1367     //  -   Withdraws balance to contract owner
1368     //  -   Automatic withdrawal of donation 
1369     function withdrawBalance() public onlyOwner {
1370         // Get the total balance
1371         uint256 balance = address(this).balance;
1372 
1373         // Get share to send to donation wallet (10 % charity donation)
1374         uint256 donationShare = balance.mul(donationPercentage).div(100);
1375         uint256 ownerShare = balance.sub(donationShare);
1376         
1377         // Transfer respective amounts
1378         payable(msg.sender).transfer(ownerShare);
1379         payable(donationWallet).transfer(donationShare);
1380     }
1381 
1382     // reserveBoys
1383     //  -   Reserves lostboys for owner
1384     //  -   Used for giveaways/etc
1385     function reserveBoys(uint256 quantity) public onlyOwner {
1386         for(uint i = 0; i < quantity; i++) {
1387             uint mintIndex = totalSupply();
1388             if (mintIndex < MAX_LOSTBOYS) {
1389                 _safeMint(msg.sender, mintIndex);
1390             }
1391         }
1392     }
1393 
1394     // Mint boy
1395     //  -   Mints lostboys by quantities
1396     function mintBoy(uint numberOfBoys) public payable  {
1397         require(mintingActive, "Minting is not activated yet.");
1398         require(numberOfBoys > 0, "Why are you minting less than zero boys.");
1399         require(
1400             totalSupply().add(numberOfBoys) <= MAX_LOSTBOYS,
1401             'Only 10,000 boys are available'
1402         );
1403         require(numberOfBoys <= maxBoysPerMint, "Cannot mint this number of boys in one go !");
1404         require(lostBoyPrice.mul(numberOfBoys) <= msg.value, 'Ethereum sent is not sufficient.');
1405 
1406         for(uint i = 0; i < numberOfBoys; i++) {
1407             uint mintIndex = totalSupply();
1408             if (totalSupply() < MAX_LOSTBOYS) {
1409                 _safeMint(msg.sender, mintIndex);
1410             }
1411         }
1412     }
1413     
1414     // mintBoyAsMember
1415     //  -   Mints lostboy as whitelisted member
1416      function mintBoyAsMember(uint numberOfBoys) public payable {
1417         require(isPresaleActive, "Presale is not active yet.");
1418         require(numberOfBoys > 0, "Why are you minting less than zero boys.");
1419         require(_whiteListedMembers[msg.sender] == MemberClaimStatus.Listed, "You are not a whitelisted member !");
1420         require(_whiteListMints[msg.sender].add(numberOfBoys) <= MAX_PRESALE_BOYS_PER_ADDRESS, "You are minting more than your allowed presale boys!");
1421         require(totalSupply().add(numberOfBoys) <= MAX_LOSTBOYS, "Only 10,000 boys are available");
1422         require(numberOfBoys <= maxBoysPerPresaleMint, "Cannot mint this number of presale boys in one go !");
1423         require(lostBoyPrice.mul(numberOfBoys) <= msg.value, 'Ethereum sent is not sufficient.');
1424         
1425         for(uint i = 0; i < numberOfBoys; i++) {
1426             uint mintIndex = totalSupply();
1427             if (totalSupply() < MAX_LOSTBOYS) {
1428                 _safeMint(msg.sender, mintIndex);
1429                 _whiteListMints[msg.sender] = _whiteListMints[msg.sender].add(1);
1430             }
1431         }
1432     }
1433 
1434     // addToWhitelist
1435     //  -   Adds discord/invited members to presale whitelist
1436     function addToWhitelist(address[] memory members) public onlyOwner {
1437         for (uint256 i = 0; i < members.length; i++) {
1438             _whiteListedMembers[members[i]] = MemberClaimStatus.Listed;
1439             _whiteListMints[members[i]] = 0;
1440         }
1441     }
1442 
1443     // isWhitelisted
1444     //  -   Public helper to check if an address is whitelisted
1445     function isWhitelisted (address addr) public view returns (bool) {
1446         return _whiteListedMembers[addr] == MemberClaimStatus.Listed;
1447     }
1448 
1449     // setDonationAddress
1450     //  -   Emergency function to update the donation charity wallet in case
1451     function setCharityWalletAddress (address charityAddress) public onlyOwner {
1452         donationWallet = charityAddress;
1453     }
1454 
1455     // switchMinting
1456     //  -   Allows, disallows minting
1457     function switchMinting() public onlyOwner {
1458         mintingActive = !mintingActive;
1459     }
1460 
1461     // switchPresale
1462     //  -   Allows, disallows presale
1463     function switchPresale() public onlyOwner {
1464         isPresaleActive = !isPresaleActive;
1465     }
1466 
1467     // setMaxQuantityPerMint
1468     //  -   Sets the maximum mints per tx
1469     function setMaxQuantityPerMint (uint256 quantity) public onlyOwner {
1470         maxBoysPerMint = quantity;
1471     }
1472 
1473      // setMaxQuantityPerPresaleMint
1474     //  -   Sets the maximum mints per tx for presale
1475     function setMaxQuantityPerPresaleMint (uint256 quantity) public onlyOwner {
1476         maxBoysPerPresaleMint = quantity;
1477     }
1478     
1479     // setPresaleMaxPerWallet
1480     //  -   Emergency function to update the max per presale wallet
1481     function setMaxPerPresaleWallet (uint256 quantity) public onlyOwner {
1482         MAX_PRESALE_BOYS_PER_ADDRESS = quantity;
1483     }
1484     
1485     // setBaseURI
1486     //  -  Metadata lives here
1487     function setBaseURI(string memory baseURI) external onlyOwner() {
1488         m_BaseURI = baseURI;
1489     }
1490 
1491     // _baseURI
1492     function _baseURI() internal view override returns (string memory) {
1493         return m_BaseURI;
1494     }
1495 
1496     // setProvenance
1497     //  -   Provenance for data integrity
1498     function setProvenance(string memory _provenance)
1499         external
1500         onlyOwner
1501     {
1502         provenanceHash = _provenance;
1503     }
1504 
1505 }