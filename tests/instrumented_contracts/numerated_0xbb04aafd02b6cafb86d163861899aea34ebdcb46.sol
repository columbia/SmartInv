1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
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
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         uint256 c = a + b;
26         if (c < a) return (false, 0);
27         return (true, c);
28     }
29 
30     /**
31      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
32      *
33      * _Available since v3.4._
34      */
35     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         if (b > a) return (false, 0);
37         return (true, a - b);
38     }
39 
40     /**
41      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
49         if (a == 0) return (true, 0);
50         uint256 c = a * b;
51         if (c / a != b) return (false, 0);
52         return (true, c);
53     }
54 
55     /**
56      * @dev Returns the division of two unsigned integers, with a division by zero flag.
57      *
58      * _Available since v3.4._
59      */
60     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
61         if (b == 0) return (false, 0);
62         return (true, a / b);
63     }
64 
65     /**
66      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
67      *
68      * _Available since v3.4._
69      */
70     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         if (b == 0) return (false, 0);
72         return (true, a % b);
73     }
74 
75     /**
76      * @dev Returns the addition of two unsigned integers, reverting on
77      * overflow.
78      *
79      * Counterpart to Solidity's `+` operator.
80      *
81      * Requirements:
82      *
83      * - Addition cannot overflow.
84      */
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88         return c;
89     }
90 
91     /**
92      * @dev Returns the subtraction of two unsigned integers, reverting on
93      * overflow (when the result is negative).
94      *
95      * Counterpart to Solidity's `-` operator.
96      *
97      * Requirements:
98      *
99      * - Subtraction cannot overflow.
100      */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         require(b <= a, "SafeMath: subtraction overflow");
103         return a - b;
104     }
105 
106     /**
107      * @dev Returns the multiplication of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `*` operator.
111      *
112      * Requirements:
113      *
114      * - Multiplication cannot overflow.
115      */
116     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117         if (a == 0) return 0;
118         uint256 c = a * b;
119         require(c / a == b, "SafeMath: multiplication overflow");
120         return c;
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers, reverting on
125      * division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator. Note: this function uses a
128      * `revert` opcode (which leaves remaining gas untouched) while Solidity
129      * uses an invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      *
133      * - The divisor cannot be zero.
134      */
135     function div(uint256 a, uint256 b) internal pure returns (uint256) {
136         require(b > 0, "SafeMath: division by zero");
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         require(b > 0, "SafeMath: modulo by zero");
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         return a - b;
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
177      * division by zero. The result is rounded towards zero.
178      *
179      * CAUTION: This function is deprecated because it requires allocating memory for the error
180      * message unnecessarily. For custom revert reasons use {tryDiv}.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b > 0, errorMessage);
192         return a / b;
193     }
194 
195     /**
196      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
197      * reverting with custom message when dividing by zero.
198      *
199      * CAUTION: This function is deprecated because it requires allocating memory for the error
200      * message unnecessarily. For custom revert reasons use {tryMod}.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b > 0, errorMessage);
212         return a % b;
213     }
214 }
215 
216 /**
217  * @dev Interface of the ERC165 standard, as defined in the
218  * https://eips.ethereum.org/EIPS/eip-165[EIP].
219  *
220  * Implementers can declare support of contract interfaces, which can then be
221  * queried by others ({ERC165Checker}).
222  *
223  * For an implementation, see {ERC165}.
224  */
225 interface IERC165 {
226     /**
227      * @dev Returns true if this contract implements the interface defined by
228      * `interfaceId`. See the corresponding
229      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
230      * to learn more about how these ids are created.
231      *
232      * This function call must use less than 30 000 gas.
233      */
234     function supportsInterface(bytes4 interfaceId) external view returns (bool);
235 }
236 
237 /**
238  * @dev Required interface of an ERC721 compliant contract.
239  */
240 interface IERC721 is IERC165 {
241     /**
242      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
243      */
244     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
245 
246     /**
247      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
248      */
249     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
250 
251     /**
252      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
253      */
254     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
255 
256     /**
257      * @dev Returns the number of tokens in ``owner``'s account.
258      */
259     function balanceOf(address owner) external view returns (uint256 balance);
260 
261     /**
262      * @dev Returns the owner of the `tokenId` token.
263      *
264      * Requirements:
265      *
266      * - `tokenId` must exist.
267      */
268     function ownerOf(uint256 tokenId) external view returns (address owner);
269 
270     /**
271      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
272      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
273      *
274      * Requirements:
275      *
276      * - `from` cannot be the zero address.
277      * - `to` cannot be the zero address.
278      * - `tokenId` token must exist and be owned by `from`.
279      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
280      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
281      *
282      * Emits a {Transfer} event.
283      */
284     function safeTransferFrom(
285         address from,
286         address to,
287         uint256 tokenId
288     ) external;
289 
290     /**
291      * @dev Transfers `tokenId` token from `from` to `to`.
292      *
293      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
294      *
295      * Requirements:
296      *
297      * - `from` cannot be the zero address.
298      * - `to` cannot be the zero address.
299      * - `tokenId` token must be owned by `from`.
300      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
301      *
302      * Emits a {Transfer} event.
303      */
304     function transferFrom(
305         address from,
306         address to,
307         uint256 tokenId
308     ) external;
309 
310     /**
311      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
312      * The approval is cleared when the token is transferred.
313      *
314      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
315      *
316      * Requirements:
317      *
318      * - The caller must own the token or be an approved operator.
319      * - `tokenId` must exist.
320      *
321      * Emits an {Approval} event.
322      */
323     function approve(address to, uint256 tokenId) external;
324 
325     /**
326      * @dev Returns the account approved for `tokenId` token.
327      *
328      * Requirements:
329      *
330      * - `tokenId` must exist.
331      */
332     function getApproved(uint256 tokenId) external view returns (address operator);
333 
334     /**
335      * @dev Approve or remove `operator` as an operator for the caller.
336      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
337      *
338      * Requirements:
339      *
340      * - The `operator` cannot be the caller.
341      *
342      * Emits an {ApprovalForAll} event.
343      */
344     function setApprovalForAll(address operator, bool _approved) external;
345 
346     /**
347      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
348      *
349      * See {setApprovalForAll}
350      */
351     function isApprovedForAll(address owner, address operator) external view returns (bool);
352 
353     /**
354      * @dev Safely transfers `tokenId` token from `from` to `to`.
355      *
356      * Requirements:
357      *
358      * - `from` cannot be the zero address.
359      * - `to` cannot be the zero address.
360      * - `tokenId` token must exist and be owned by `from`.
361      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
362      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
363      *
364      * Emits a {Transfer} event.
365      */
366     function safeTransferFrom(
367         address from,
368         address to,
369         uint256 tokenId,
370         bytes calldata data
371     ) external;
372 }
373 
374 /**
375  * @title ERC721 token receiver interface
376  * @dev Interface for any contract that wants to support safeTransfers
377  * from ERC721 asset contracts.
378  */
379 interface IERC721Receiver {
380     /**
381      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
382      * by `operator` from `from`, this function is called.
383      *
384      * It must return its Solidity selector to confirm the token transfer.
385      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
386      *
387      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
388      */
389     function onERC721Received(
390         address operator,
391         address from,
392         uint256 tokenId,
393         bytes calldata data
394     ) external returns (bytes4);
395 }
396 
397 /**
398  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
399  * @dev See https://eips.ethereum.org/EIPS/eip-721
400  */
401 interface IERC721Metadata is IERC721 {
402     /**
403      * @dev Returns the token collection name.
404      */
405     function name() external view returns (string memory);
406 
407     /**
408      * @dev Returns the token collection symbol.
409      */
410     function symbol() external view returns (string memory);
411 
412     /**
413      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
414      */
415     function tokenURI(uint256 tokenId) external view returns (string memory);
416 }
417 
418 /**
419  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
420  * @dev See https://eips.ethereum.org/EIPS/eip-721
421  */
422 interface IERC721Enumerable is IERC721 {
423     /**
424      * @dev Returns the total amount of tokens stored by the contract.
425      */
426     function totalSupply() external view returns (uint256);
427 
428     /**
429      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
430      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
431      */
432     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
433 
434     /**
435      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
436      * Use along with {totalSupply} to enumerate all tokens.
437      */
438     function tokenByIndex(uint256 index) external view returns (uint256);
439 }
440 
441 /**
442  * @dev Collection of functions related to the address type
443  */
444 library Address {
445     /**
446      * @dev Returns true if `account` is a contract.
447      *
448      * [IMPORTANT]
449      * ====
450      * It is unsafe to assume that an address for which this function returns
451      * false is an externally-owned account (EOA) and not a contract.
452      *
453      * Among others, `isContract` will return false for the following
454      * types of addresses:
455      *
456      *  - an externally-owned account
457      *  - a contract in construction
458      *  - an address where a contract will be created
459      *  - an address where a contract lived, but was destroyed
460      * ====
461      *
462      * [IMPORTANT]
463      * ====
464      * You shouldn't rely on `isContract` to protect against flash loan attacks!
465      *
466      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
467      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
468      * constructor.
469      * ====
470      */
471     function isContract(address account) internal view returns (bool) {
472         // This method relies on extcodesize/address.code.length, which returns 0
473         // for contracts in construction, since the code is only stored at the end
474         // of the constructor execution.
475 
476         return account.code.length > 0;
477     }
478 
479     /**
480      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
481      * `recipient`, forwarding all available gas and reverting on errors.
482      *
483      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
484      * of certain opcodes, possibly making contracts go over the 2300 gas limit
485      * imposed by `transfer`, making them unable to receive funds via
486      * `transfer`. {sendValue} removes this limitation.
487      *
488      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
489      *
490      * IMPORTANT: because control is transferred to `recipient`, care must be
491      * taken to not create reentrancy vulnerabilities. Consider using
492      * {ReentrancyGuard} or the
493      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
494      */
495     function sendValue(address payable recipient, uint256 amount) internal {
496         require(address(this).balance >= amount, "Address: insufficient balance");
497 
498         (bool success, ) = recipient.call{value: amount}("");
499         require(success, "Address: unable to send value, recipient may have reverted");
500     }
501 
502     /**
503      * @dev Performs a Solidity function call using a low level `call`. A
504      * plain `call` is an unsafe replacement for a function call: use this
505      * function instead.
506      *
507      * If `target` reverts with a revert reason, it is bubbled up by this
508      * function (like regular Solidity function calls).
509      *
510      * Returns the raw returned data. To convert to the expected return value,
511      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
512      *
513      * Requirements:
514      *
515      * - `target` must be a contract.
516      * - calling `target` with `data` must not revert.
517      *
518      * _Available since v3.1._
519      */
520     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
521         return functionCall(target, data, "Address: low-level call failed");
522     }
523 
524     /**
525      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
526      * `errorMessage` as a fallback revert reason when `target` reverts.
527      *
528      * _Available since v3.1._
529      */
530     function functionCall(
531         address target,
532         bytes memory data,
533         string memory errorMessage
534     ) internal returns (bytes memory) {
535         return functionCallWithValue(target, data, 0, errorMessage);
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
540      * but also transferring `value` wei to `target`.
541      *
542      * Requirements:
543      *
544      * - the calling contract must have an ETH balance of at least `value`.
545      * - the called Solidity function must be `payable`.
546      *
547      * _Available since v3.1._
548      */
549     function functionCallWithValue(
550         address target,
551         bytes memory data,
552         uint256 value
553     ) internal returns (bytes memory) {
554         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
559      * with `errorMessage` as a fallback revert reason when `target` reverts.
560      *
561      * _Available since v3.1._
562      */
563     function functionCallWithValue(
564         address target,
565         bytes memory data,
566         uint256 value,
567         string memory errorMessage
568     ) internal returns (bytes memory) {
569         require(address(this).balance >= value, "Address: insufficient balance for call");
570         require(isContract(target), "Address: call to non-contract");
571 
572         (bool success, bytes memory returndata) = target.call{value: value}(data);
573         return verifyCallResult(success, returndata, errorMessage);
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
578      * but performing a static call.
579      *
580      * _Available since v3.3._
581      */
582     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
583         return functionStaticCall(target, data, "Address: low-level static call failed");
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
588      * but performing a static call.
589      *
590      * _Available since v3.3._
591      */
592     function functionStaticCall(
593         address target,
594         bytes memory data,
595         string memory errorMessage
596     ) internal view returns (bytes memory) {
597         require(isContract(target), "Address: static call to non-contract");
598 
599         (bool success, bytes memory returndata) = target.staticcall(data);
600         return verifyCallResult(success, returndata, errorMessage);
601     }
602 
603     /**
604      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
605      * but performing a delegate call.
606      *
607      * _Available since v3.4._
608      */
609     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
610         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
611     }
612 
613     /**
614      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
615      * but performing a delegate call.
616      *
617      * _Available since v3.4._
618      */
619     function functionDelegateCall(
620         address target,
621         bytes memory data,
622         string memory errorMessage
623     ) internal returns (bytes memory) {
624         require(isContract(target), "Address: delegate call to non-contract");
625 
626         (bool success, bytes memory returndata) = target.delegatecall(data);
627         return verifyCallResult(success, returndata, errorMessage);
628     }
629 
630     /**
631      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
632      * revert reason using the provided one.
633      *
634      * _Available since v4.3._
635      */
636     function verifyCallResult(
637         bool success,
638         bytes memory returndata,
639         string memory errorMessage
640     ) internal pure returns (bytes memory) {
641         if (success) {
642             return returndata;
643         } else {
644             // Look for revert reason and bubble it up if present
645             if (returndata.length > 0) {
646                 // The easiest way to bubble the revert reason is using memory via assembly
647 
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
659 /**
660  * @dev Provides information about the current execution context, including the
661  * sender of the transaction and its data. While these are generally available
662  * via msg.sender and msg.data, they should not be accessed in such a direct
663  * manner, since when dealing with meta-transactions the account sending and
664  * paying for execution may not be the actual sender (as far as an application
665  * is concerned).
666  *
667  * This contract is only required for intermediate, library-like contracts.
668  */
669 abstract contract Context {
670     function _msgSender() internal view virtual returns (address) {
671         return msg.sender;
672     }
673 
674     function _msgData() internal view virtual returns (bytes calldata) {
675         return msg.data;
676     }
677 }
678 
679 /**
680  * @dev String operations.
681  */
682 library Strings {
683     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
684 
685     /**
686      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
687      */
688     function toString(uint256 value) internal pure returns (string memory) {
689         // Inspired by OraclizeAPI's implementation - MIT licence
690         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
691 
692         if (value == 0) {
693             return "0";
694         }
695         uint256 temp = value;
696         uint256 digits;
697         while (temp != 0) {
698             digits++;
699             temp /= 10;
700         }
701         bytes memory buffer = new bytes(digits);
702         while (value != 0) {
703             digits -= 1;
704             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
705             value /= 10;
706         }
707         return string(buffer);
708     }
709 
710     /**
711      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
712      */
713     function toHexString(uint256 value) internal pure returns (string memory) {
714         if (value == 0) {
715             return "0x00";
716         }
717         uint256 temp = value;
718         uint256 length = 0;
719         while (temp != 0) {
720             length++;
721             temp >>= 8;
722         }
723         return toHexString(value, length);
724     }
725 
726     /**
727      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
728      */
729     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
730         bytes memory buffer = new bytes(2 * length + 2);
731         buffer[0] = "0";
732         buffer[1] = "x";
733         for (uint256 i = 2 * length + 1; i > 1; --i) {
734             buffer[i] = _HEX_SYMBOLS[value & 0xf];
735             value >>= 4;
736         }
737         require(value == 0, "Strings: hex length insufficient");
738         return string(buffer);
739     }
740 }
741 
742 /**
743  * @dev Implementation of the {IERC165} interface.
744  *
745  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
746  * for the additional interface id that will be supported. For example:
747  *
748  * ```solidity
749  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
750  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
751  * }
752  * ```
753  *
754  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
755  */
756 abstract contract ERC165 is IERC165 {
757     /**
758      * @dev See {IERC165-supportsInterface}.
759      */
760     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
761         return interfaceId == type(IERC165).interfaceId;
762     }
763 }
764 
765 
766 error ApprovalCallerNotOwnerNorApproved();
767 error ApprovalQueryForNonexistentToken();
768 error ApproveToCaller();
769 error ApprovalToCurrentOwner();
770 error BalanceQueryForZeroAddress();
771 error MintedQueryForZeroAddress();
772 error BurnedQueryForZeroAddress();
773 error AuxQueryForZeroAddress();
774 error MintToZeroAddress();
775 error MintZeroQuantity();
776 error OwnerIndexOutOfBounds();
777 error OwnerQueryForNonexistentToken();
778 error TokenIndexOutOfBounds();
779 error TransferCallerNotOwnerNorApproved();
780 error TransferFromIncorrectOwner();
781 error TransferToNonERC721ReceiverImplementer();
782 error TransferToZeroAddress();
783 error URIQueryForNonexistentToken();
784 
785 /**
786  * @dev Contract module which provides a basic access control mechanism, where
787  * there is an account (an owner) that can be granted exclusive access to
788  * specific functions.
789  *
790  * By default, the owner account will be the one that deploys the contract. This
791  * can later be changed with {transferOwnership}.
792  *
793  * This module is used through inheritance. It will make available the modifier
794  * `onlyOwner`, which can be applied to your functions to restrict their use to
795  * the owner.
796  */
797 abstract contract Ownable is Context {
798     address private _owner;
799 
800     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
801 
802     /**
803      * @dev Initializes the contract setting the deployer as the initial owner.
804      */
805     constructor () {
806         address msgSender = _msgSender();
807         _owner = msgSender;
808         emit OwnershipTransferred(address(0), msgSender);
809     }
810 
811     /**
812      * @dev Returns the address of the current owner.
813      */
814     function owner() public view virtual returns (address) {
815         return _owner;
816     }
817 
818     /**
819      * @dev Throws if called by any account other than the owner.
820      */
821     modifier onlyOwner() {
822         require(owner() == _msgSender(), "Ownable: caller is not the owner");
823         _;
824     }
825 
826     /**
827      * @dev Leaves the contract without owner. It will not be possible to call
828      * `onlyOwner` functions anymore. Can only be called by the current owner.
829      *
830      * NOTE: Renouncing ownership will leave the contract without an owner,
831      * thereby removing any functionality that is only available to the owner.
832      */
833     function renounceOwnership() public virtual onlyOwner {
834         emit OwnershipTransferred(_owner, address(0));
835         _owner = address(0);
836     }
837 
838     /**
839      * @dev Transfers ownership of the contract to a new account (`newOwner`).
840      * Can only be called by the current owner.
841      */
842     function transferOwnership(address newOwner) public virtual onlyOwner {
843         require(newOwner != address(0), "Ownable: new owner is the zero address");
844         emit OwnershipTransferred(_owner, newOwner);
845         _owner = newOwner;
846     }
847 }
848 
849 
850 /**
851  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
852  * the Metadata extension. Built to optimize for lower gas during batch mints.
853  *
854  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
855  *
856  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
857  *
858  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
859  */
860 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
861     using Address for address;
862     using Strings for uint256;
863 
864     // Compiler will pack this into a single 256bit word.
865     struct TokenOwnership {
866         // The address of the owner.
867         address addr;
868         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
869         uint64 startTimestamp;
870         // Whether the token has been burned.
871         bool burned;
872     }
873 
874     // Compiler will pack this into a single 256bit word.
875     struct AddressData {
876         // Realistically, 2**64-1 is more than enough.
877         uint64 balance;
878         // Keeps track of mint count with minimal overhead for tokenomics.
879         uint64 numberMinted;
880         // Keeps track of burn count with minimal overhead for tokenomics.
881         uint64 numberBurned;
882         // For miscellaneous variable(s) pertaining to the address
883         // (e.g. number of whitelist mint slots used).
884         // If there are multiple variables, please pack them into a uint64.
885         uint64 aux;
886     }
887 
888     // The tokenId of the next token to be minted.
889     uint256 internal _currentIndex;
890 
891     // The number of tokens burned.
892     uint256 internal _burnCounter;
893 
894     // Token name
895     string private _name;
896 
897     // Token symbol
898     string private _symbol;
899 
900     // Mapping from token ID to ownership details
901     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
902     mapping(uint256 => TokenOwnership) internal _ownerships;
903 
904     // Mapping owner address to address data
905     mapping(address => AddressData) private _addressData;
906 
907     // Mapping from token ID to approved address
908     mapping(uint256 => address) private _tokenApprovals;
909 
910     // Mapping from owner to operator approvals
911     mapping(address => mapping(address => bool)) private _operatorApprovals;
912 
913     constructor(string memory name_, string memory symbol_) {
914         _name = name_;
915         _symbol = symbol_;
916         _currentIndex = _startTokenId();
917     }
918 
919     /**
920      * To change the starting tokenId, please override this function.
921      */
922     function _startTokenId() internal view virtual returns (uint256) {
923         return 0;
924     }
925 
926     /**
927      * @dev See {IERC721Enumerable-totalSupply}.
928      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
929      */
930     function totalSupply() public view returns (uint256) {
931         // Counter underflow is impossible as _burnCounter cannot be incremented
932         // more than _currentIndex - _startTokenId() times
933         unchecked {
934             return _currentIndex - _burnCounter - _startTokenId();
935         }
936     }
937 
938     /**
939      * Returns the total amount of tokens minted in the contract.
940      */
941     function _totalMinted() internal view returns (uint256) {
942         // Counter underflow is impossible as _currentIndex does not decrement,
943         // and it is initialized to _startTokenId()
944         unchecked {
945             return _currentIndex - _startTokenId();
946         }
947     }
948 
949     /**
950      * @dev See {IERC165-supportsInterface}.
951      */
952     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
953         return
954             interfaceId == type(IERC721).interfaceId ||
955             interfaceId == type(IERC721Metadata).interfaceId ||
956             super.supportsInterface(interfaceId);
957     }
958 
959     /**
960      * @dev See {IERC721-balanceOf}.
961      */
962     function balanceOf(address owner) public view override returns (uint256) {
963         if (owner == address(0)) revert BalanceQueryForZeroAddress();
964         return uint256(_addressData[owner].balance);
965     }
966 
967     /**
968      * Returns the number of tokens minted by `owner`.
969      */
970     function _numberMinted(address owner) internal view returns (uint256) {
971         if (owner == address(0)) revert MintedQueryForZeroAddress();
972         return uint256(_addressData[owner].numberMinted);
973     }
974 
975     /**
976      * Returns the number of tokens burned by or on behalf of `owner`.
977      */
978     function _numberBurned(address owner) internal view returns (uint256) {
979         if (owner == address(0)) revert BurnedQueryForZeroAddress();
980         return uint256(_addressData[owner].numberBurned);
981     }
982 
983     /**
984      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
985      */
986     function _getAux(address owner) internal view returns (uint64) {
987         if (owner == address(0)) revert AuxQueryForZeroAddress();
988         return _addressData[owner].aux;
989     }
990 
991     /**
992      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
993      * If there are multiple variables, please pack them into a uint64.
994      */
995     function _setAux(address owner, uint64 aux) internal {
996         if (owner == address(0)) revert AuxQueryForZeroAddress();
997         _addressData[owner].aux = aux;
998     }
999 
1000     /**
1001      * Gas spent here starts off proportional to the maximum mint batch size.
1002      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1003      */
1004     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1005         uint256 curr = tokenId;
1006 
1007         unchecked {
1008             if (_startTokenId() <= curr && curr < _currentIndex) {
1009                 TokenOwnership memory ownership = _ownerships[curr];
1010                 if (!ownership.burned) {
1011                     if (ownership.addr != address(0)) {
1012                         return ownership;
1013                     }
1014                     // Invariant:
1015                     // There will always be an ownership that has an address and is not burned
1016                     // before an ownership that does not have an address and is not burned.
1017                     // Hence, curr will not underflow.
1018                     while (true) {
1019                         curr--;
1020                         ownership = _ownerships[curr];
1021                         if (ownership.addr != address(0)) {
1022                             return ownership;
1023                         }
1024                     }
1025                 }
1026             }
1027         }
1028         revert OwnerQueryForNonexistentToken();
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-ownerOf}.
1033      */
1034     function ownerOf(uint256 tokenId) public view override returns (address) {
1035         return ownershipOf(tokenId).addr;
1036     }
1037 
1038     /**
1039      * @dev See {IERC721Metadata-name}.
1040      */
1041     function name() public view virtual override returns (string memory) {
1042         return _name;
1043     }
1044 
1045     /**
1046      * @dev See {IERC721Metadata-symbol}.
1047      */
1048     function symbol() public view virtual override returns (string memory) {
1049         return _symbol;
1050     }
1051 
1052     /**
1053      * @dev See {IERC721Metadata-tokenURI}.
1054      */
1055     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1056         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1057 
1058         string memory baseURI = _baseURI();
1059         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1060     }
1061 
1062     /**
1063      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1064      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1065      * by default, can be overriden in child contracts.
1066      */
1067     function _baseURI() internal view virtual returns (string memory) {
1068         return '';
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-approve}.
1073      */
1074     function approve(address to, uint256 tokenId) public override {
1075         address owner = ERC721A.ownerOf(tokenId);
1076         if (to == owner) revert ApprovalToCurrentOwner();
1077 
1078         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1079             revert ApprovalCallerNotOwnerNorApproved();
1080         }
1081 
1082         _approve(to, tokenId, owner);
1083     }
1084 
1085     /**
1086      * @dev See {IERC721-getApproved}.
1087      */
1088     function getApproved(uint256 tokenId) public view override returns (address) {
1089         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1090 
1091         return _tokenApprovals[tokenId];
1092     }
1093 
1094     /**
1095      * @dev See {IERC721-setApprovalForAll}.
1096      */
1097     function setApprovalForAll(address operator, bool approved) public virtual override {
1098         if (operator == _msgSender()) revert ApproveToCaller();
1099 
1100         _operatorApprovals[_msgSender()][operator] = approved;
1101         emit ApprovalForAll(_msgSender(), operator, approved);
1102     }
1103 
1104     /**
1105      * @dev See {IERC721-isApprovedForAll}.
1106      */
1107     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1108         return _operatorApprovals[owner][operator];
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-transferFrom}.
1113      */
1114     function transferFrom(
1115         address from,
1116         address to,
1117         uint256 tokenId
1118     ) public virtual override {
1119         _transfer(from, to, tokenId);
1120     }
1121 
1122     /**
1123      * @dev See {IERC721-safeTransferFrom}.
1124      */
1125     function safeTransferFrom(
1126         address from,
1127         address to,
1128         uint256 tokenId
1129     ) public virtual override {
1130         safeTransferFrom(from, to, tokenId, '');
1131     }
1132 
1133     /**
1134      * @dev See {IERC721-safeTransferFrom}.
1135      */
1136     function safeTransferFrom(
1137         address from,
1138         address to,
1139         uint256 tokenId,
1140         bytes memory _data
1141     ) public virtual override {
1142         _transfer(from, to, tokenId);
1143         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1144             revert TransferToNonERC721ReceiverImplementer();
1145         }
1146     }
1147 
1148     /**
1149      * @dev Returns whether `tokenId` exists.
1150      *
1151      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1152      *
1153      * Tokens start existing when they are minted (`_mint`),
1154      */
1155     function _exists(uint256 tokenId) internal view returns (bool) {
1156         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1157             !_ownerships[tokenId].burned;
1158     }
1159 
1160     function _safeMint(address to, uint256 quantity) internal {
1161         _safeMint(to, quantity, '');
1162     }
1163 
1164     /**
1165      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1166      *
1167      * Requirements:
1168      *
1169      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1170      * - `quantity` must be greater than 0.
1171      *
1172      * Emits a {Transfer} event.
1173      */
1174     function _safeMint(
1175         address to,
1176         uint256 quantity,
1177         bytes memory _data
1178     ) internal {
1179         _mint(to, quantity, _data, true);
1180     }
1181 
1182     /**
1183      * @dev Mints `quantity` tokens and transfers them to `to`.
1184      *
1185      * Requirements:
1186      *
1187      * - `to` cannot be the zero address.
1188      * - `quantity` must be greater than 0.
1189      *
1190      * Emits a {Transfer} event.
1191      */
1192     function _mint(
1193         address to,
1194         uint256 quantity,
1195         bytes memory _data,
1196         bool safe
1197     ) internal {
1198         uint256 startTokenId = _currentIndex;
1199         if (to == address(0)) revert MintToZeroAddress();
1200         if (quantity == 0) revert MintZeroQuantity();
1201 
1202         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1203 
1204         // Overflows are incredibly unrealistic.
1205         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1206         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1207         unchecked {
1208             _addressData[to].balance += uint64(quantity);
1209             _addressData[to].numberMinted += uint64(quantity);
1210 
1211             _ownerships[startTokenId].addr = to;
1212             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1213 
1214             uint256 updatedIndex = startTokenId;
1215             uint256 end = updatedIndex + quantity;
1216 
1217             if (safe && to.isContract()) {
1218                 do {
1219                     emit Transfer(address(0), to, updatedIndex);
1220                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1221                         revert TransferToNonERC721ReceiverImplementer();
1222                     }
1223                 } while (updatedIndex != end);
1224                 // Reentrancy protection
1225                 if (_currentIndex != startTokenId) revert();
1226             } else {
1227                 do {
1228                     emit Transfer(address(0), to, updatedIndex++);
1229                 } while (updatedIndex != end);
1230             }
1231             _currentIndex = updatedIndex;
1232         }
1233         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1234     }
1235 
1236     /**
1237      * @dev Transfers `tokenId` from `from` to `to`.
1238      *
1239      * Requirements:
1240      *
1241      * - `to` cannot be the zero address.
1242      * - `tokenId` token must be owned by `from`.
1243      *
1244      * Emits a {Transfer} event.
1245      */
1246     function _transfer(
1247         address from,
1248         address to,
1249         uint256 tokenId
1250     ) private {
1251         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1252 
1253         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1254             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1255             getApproved(tokenId) == _msgSender());
1256 
1257         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1258         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1259         if (to == address(0)) revert TransferToZeroAddress();
1260 
1261         _beforeTokenTransfers(from, to, tokenId, 1);
1262 
1263         // Clear approvals from the previous owner
1264         _approve(address(0), tokenId, prevOwnership.addr);
1265 
1266         // Underflow of the sender's balance is impossible because we check for
1267         // ownership above and the recipient's balance can't realistically overflow.
1268         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1269         unchecked {
1270             _addressData[from].balance -= 1;
1271             _addressData[to].balance += 1;
1272 
1273             _ownerships[tokenId].addr = to;
1274             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1275 
1276             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1277             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1278             uint256 nextTokenId = tokenId + 1;
1279             if (_ownerships[nextTokenId].addr == address(0)) {
1280                 // This will suffice for checking _exists(nextTokenId),
1281                 // as a burned slot cannot contain the zero address.
1282                 if (nextTokenId < _currentIndex) {
1283                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1284                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1285                 }
1286             }
1287         }
1288 
1289         emit Transfer(from, to, tokenId);
1290         _afterTokenTransfers(from, to, tokenId, 1);
1291     }
1292 
1293     /**
1294      * @dev Destroys `tokenId`.
1295      * The approval is cleared when the token is burned.
1296      *
1297      * Requirements:
1298      *
1299      * - `tokenId` must exist.
1300      *
1301      * Emits a {Transfer} event.
1302      */
1303     function _burn(uint256 tokenId) internal virtual {
1304         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1305 
1306         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1307 
1308         // Clear approvals from the previous owner
1309         _approve(address(0), tokenId, prevOwnership.addr);
1310 
1311         // Underflow of the sender's balance is impossible because we check for
1312         // ownership above and the recipient's balance can't realistically overflow.
1313         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1314         unchecked {
1315             _addressData[prevOwnership.addr].balance -= 1;
1316             _addressData[prevOwnership.addr].numberBurned += 1;
1317 
1318             // Keep track of who burned the token, and the timestamp of burning.
1319             _ownerships[tokenId].addr = prevOwnership.addr;
1320             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1321             _ownerships[tokenId].burned = true;
1322 
1323             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1324             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1325             uint256 nextTokenId = tokenId + 1;
1326             if (_ownerships[nextTokenId].addr == address(0)) {
1327                 // This will suffice for checking _exists(nextTokenId),
1328                 // as a burned slot cannot contain the zero address.
1329                 if (nextTokenId < _currentIndex) {
1330                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1331                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1332                 }
1333             }
1334         }
1335 
1336         emit Transfer(prevOwnership.addr, address(0), tokenId);
1337         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1338 
1339         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1340         unchecked {
1341             _burnCounter++;
1342         }
1343     }
1344 
1345     /**
1346      * @dev Approve `to` to operate on `tokenId`
1347      *
1348      * Emits a {Approval} event.
1349      */
1350     function _approve(
1351         address to,
1352         uint256 tokenId,
1353         address owner
1354     ) private {
1355         _tokenApprovals[tokenId] = to;
1356         emit Approval(owner, to, tokenId);
1357     }
1358 
1359     /**
1360      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1361      *
1362      * @param from address representing the previous owner of the given token ID
1363      * @param to target address that will receive the tokens
1364      * @param tokenId uint256 ID of the token to be transferred
1365      * @param _data bytes optional data to send along with the call
1366      * @return bool whether the call correctly returned the expected magic value
1367      */
1368     function _checkContractOnERC721Received(
1369         address from,
1370         address to,
1371         uint256 tokenId,
1372         bytes memory _data
1373     ) private returns (bool) {
1374         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1375             return retval == IERC721Receiver(to).onERC721Received.selector;
1376         } catch (bytes memory reason) {
1377             if (reason.length == 0) {
1378                 revert TransferToNonERC721ReceiverImplementer();
1379             } else {
1380                 assembly {
1381                     revert(add(32, reason), mload(reason))
1382                 }
1383             }
1384         }
1385     }
1386 
1387     /**
1388      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1389      * And also called before burning one token.
1390      *
1391      * startTokenId - the first token id to be transferred
1392      * quantity - the amount to be transferred
1393      *
1394      * Calling conditions:
1395      *
1396      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1397      * transferred to `to`.
1398      * - When `from` is zero, `tokenId` will be minted for `to`.
1399      * - When `to` is zero, `tokenId` will be burned by `from`.
1400      * - `from` and `to` are never both zero.
1401      */
1402     function _beforeTokenTransfers(
1403         address from,
1404         address to,
1405         uint256 startTokenId,
1406         uint256 quantity
1407     ) internal virtual {}
1408 
1409     /**
1410      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1411      * minting.
1412      * And also called after one token has been burned.
1413      *
1414      * startTokenId - the first token id to be transferred
1415      * quantity - the amount to be transferred
1416      *
1417      * Calling conditions:
1418      *
1419      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1420      * transferred to `to`.
1421      * - When `from` is zero, `tokenId` has been minted for `to`.
1422      * - When `to` is zero, `tokenId` has been burned by `from`.
1423      * - `from` and `to` are never both zero.
1424      */
1425     function _afterTokenTransfers(
1426         address from,
1427         address to,
1428         uint256 startTokenId,
1429         uint256 quantity
1430     ) internal virtual {}
1431 }
1432 
1433 
1434 
1435 contract DVN is ERC721A , Ownable  {
1436     using SafeMath for uint256;
1437 
1438     uint256 public price = 120000000000000000; // 0.12 ether
1439     string public baseUri;
1440     address private signatureContract;
1441 
1442 
1443     uint public maxPurchase = 5;
1444 
1445     uint256 public MAX = 5000;
1446     uint256 public MAXWhitelist1 = 1000;
1447     uint256 public MAXWhitelist2 = 2500;
1448 
1449 
1450     bool public saleIsActive = false;
1451     bool public whitelistPhase1 = true;
1452     bool public whitelistPhase2 = false;
1453     bool public publicSale = false;
1454 
1455      function changePrice(uint256 newPrice) public onlyOwner {
1456         price = newPrice;
1457     }
1458 
1459      function changeSigner(address signer) public onlyOwner {
1460         signatureContract = signer;
1461       }
1462 
1463     function changeMaxMint(uint256 maxMint) public onlyOwner {
1464         maxPurchase = maxMint;
1465     }
1466 
1467      constructor() ERC721A("DRIVEN Alpha Collection", "DVN") {}
1468 
1469         function withdraw() public onlyOwner {
1470         uint balance = address(this).balance;
1471         
1472         address payable one = payable(0x85DA080d0fd6D35A1cA565F868cd4F84c897B119);
1473         address payable two = payable(0xBd33e3Db1b52C1D35964a439748071f7db69e8D3);
1474    
1475         one.transfer(balance.mul(97500000000000000000).div(100000000000000000000));
1476         two.transfer(balance.mul(2500000000000000000).div(100000000000000000000));
1477         
1478     }
1479 
1480     function mint(uint256 quantity , uint256 deadline , uint8 v, bytes32 r, bytes32 s) external payable {
1481 
1482          require(saleIsActive, "Sale must be active to mint nft");
1483         require(quantity <= maxPurchase, "Can only mint certain tokens at a time");
1484         require(price.mul(quantity) <= msg.value, "Not Enough Ether Sent");
1485 
1486          if(whitelistPhase1){
1487             require(totalSupply().add(quantity) <= MAXWhitelist1, "Purchase would exceed max first whitelist supply of nfts");
1488             require(deadline >= block.timestamp, "deadline passed");
1489             require(signatureContract == ecrecover(getSignedHash(keccak256(abi.encodePacked(this, msg.sender , deadline , quantity))), v, r, s), "owner should sign Transactioon");
1490         } else if(whitelistPhase2){
1491             require(totalSupply().add(quantity) <= MAXWhitelist2, "Purchase would exceed max second whitelist supply of nfts");
1492             require(deadline >= block.timestamp, "deadline passed");
1493             require(signatureContract == ecrecover(getSignedHash(keccak256(abi.encodePacked(this, msg.sender , deadline , quantity))), v, r, s), "owner should sign Transactioon");
1494         }else if(publicSale){
1495             require(totalSupply().add(quantity) <= MAX, "Purchase would exceed max supply of nfts");
1496         }else{
1497             revert();
1498         }
1499 
1500         // _safeMint's second argument now takes in a quantity, not a tokenId.
1501         _safeMint(msg.sender, quantity);
1502      }
1503     
1504     function setBaseURI(string memory baseURI_) public onlyOwner {
1505         baseUri = baseURI_;
1506     }
1507 
1508     /*
1509     * Pause sale if active, make active if paused
1510     */
1511     function flipSaleState() public onlyOwner {
1512         saleIsActive = !saleIsActive;
1513     }
1514 
1515      /*
1516     * 
1517     */
1518     function changeWhitelist1(bool state) public onlyOwner {
1519         whitelistPhase1 = state;
1520     }
1521     
1522     function changeWhitelist2(bool state) public onlyOwner {
1523         whitelistPhase2 = state;
1524     }
1525 
1526     function changePublicSale(bool state) public onlyOwner {
1527         publicSale = state;
1528     }
1529       /**
1530      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1531      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1532      * by default
1533      */
1534     function _baseURI() internal view override returns (string memory) {
1535         return baseUri;
1536     }
1537 
1538     function getSignedHash(bytes32 _messageHash) private pure returns(bytes32){
1539         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
1540     }
1541 }