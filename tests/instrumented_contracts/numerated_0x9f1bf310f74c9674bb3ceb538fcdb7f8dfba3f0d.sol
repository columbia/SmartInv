1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-03
3 */
4 
5 interface IERC165 {
6 function supportsInterface(bytes4 interfaceId) external view returns (bool);
7 }
8 
9 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
10 pragma solidity ^0.8.0;
11 /**
12  * @dev Required interface of an ERC721 compliant contract.
13  */
14 interface IERC721 is IERC165 {
15     /**
16      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
19 
20     /**
21      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
22      */
23     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
24 
25     /**
26      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
27      */
28     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
29 
30     /**
31      * @dev Returns the number of tokens in ``owner``'s account.
32      */
33     function balanceOf(address owner) external view returns (uint256 balance);
34 
35     /**
36      * @dev Returns the owner of the `tokenId` token.
37      *
38      * Requirements:
39      *
40      * - `tokenId` must exist.
41      */
42     function ownerOf(uint256 tokenId) external view returns (address owner);
43 
44     /**
45      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
46      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
47      *
48      * Requirements:
49      *
50      * - `from` cannot be the zero address.
51      * - `to` cannot be the zero address.
52      * - `tokenId` token must exist and be owned by `from`.
53      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
54      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
55      *
56      * Emits a {Transfer} event.
57      */
58     function safeTransferFrom(
59         address from,
60         address to,
61         uint256 tokenId
62     ) external;
63 
64     /**
65      * @dev Transfers `tokenId` token from `from` to `to`.
66      *
67      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
68      *
69      * Requirements:
70      *
71      * - `from` cannot be the zero address.
72      * - `to` cannot be the zero address.
73      * - `tokenId` token must be owned by `from`.
74      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(
79         address from,
80         address to,
81         uint256 tokenId
82     ) external;
83 
84     /**
85      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
86      * The approval is cleared when the token is transferred.
87      *
88      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
89      *
90      * Requirements:
91      *
92      * - The caller must own the token or be an approved operator.
93      * - `tokenId` must exist.
94      *
95      * Emits an {Approval} event.
96      */
97     function approve(address to, uint256 tokenId) external;
98 
99     /**
100      * @dev Returns the account approved for `tokenId` token.
101      *
102      * Requirements:
103      *
104      * - `tokenId` must exist.
105      */
106     function getApproved(uint256 tokenId) external view returns (address operator);
107 
108     /**
109      * @dev Approve or remove `operator` as an operator for the caller.
110      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
111      *
112      * Requirements:
113      *
114      * - The `operator` cannot be the caller.
115      *
116      * Emits an {ApprovalForAll} event.
117      */
118     function setApprovalForAll(address operator, bool _approved) external;
119 
120     /**
121      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
122      *
123      * See {setApprovalForAll}
124      */
125     function isApprovedForAll(address owner, address operator) external view returns (bool);
126 
127     /**
128      * @dev Safely transfers `tokenId` token from `from` to `to`.
129      *
130      * Requirements:
131      *
132      * - `from` cannot be the zero address.
133      * - `to` cannot be the zero address.
134      * - `tokenId` token must exist and be owned by `from`.
135      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
136      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
137      *
138      * Emits a {Transfer} event.
139      */
140     function safeTransferFrom(
141         address from,
142         address to,
143         uint256 tokenId,
144         bytes calldata data
145     ) external;
146 }
147 
148 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
149 pragma solidity ^0.8.0;
150 /**
151  * @dev Implementation of the {IERC165} interface.
152  *
153  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
154  * for the additional interface id that will be supported. For example:
155  *
156  * ```solidity
157  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
158  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
159  * }
160  * ```
161  *
162  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
163  */
164 abstract contract ERC165 is IERC165 {
165     /**
166      * @dev See {IERC165-supportsInterface}.
167      */
168     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
169         return interfaceId == type(IERC165).interfaceId;
170     }
171 }
172 
173 // File: @openzeppelin/contracts/utils/Strings.sol
174 
175 
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @dev String operations.
181  */
182 library Strings {
183     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
184 
185     /**
186      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
187      */
188     function toString(uint256 value) internal pure returns (string memory) {
189         // Inspired by OraclizeAPI's implementation - MIT licence
190         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
191 
192         if (value == 0) {
193             return "0";
194         }
195         uint256 temp = value;
196         uint256 digits;
197         while (temp != 0) {
198             digits++;
199             temp /= 10;
200         }
201         bytes memory buffer = new bytes(digits);
202         while (value != 0) {
203             digits -= 1;
204             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
205             value /= 10;
206         }
207         return string(buffer);
208     }
209 
210     /**
211      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
212      */
213     function toHexString(uint256 value) internal pure returns (string memory) {
214         if (value == 0) {
215             return "0x00";
216         }
217         uint256 temp = value;
218         uint256 length = 0;
219         while (temp != 0) {
220             length++;
221             temp >>= 8;
222         }
223         return toHexString(value, length);
224     }
225 
226     /**
227      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
228      */
229     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
230         bytes memory buffer = new bytes(2 * length + 2);
231         buffer[0] = "0";
232         buffer[1] = "x";
233         for (uint256 i = 2 * length + 1; i > 1; --i) {
234             buffer[i] = _HEX_SYMBOLS[value & 0xf];
235             value >>= 4;
236         }
237         require(value == 0, "Strings: hex length insufficient");
238         return string(buffer);
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/Address.sol
243 
244 
245 
246 pragma solidity ^0.8.0;
247 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // This method relies on extcodesize, which returns 0 for contracts in
271         // construction, since the code is only stored at the end of the
272         // constructor execution.
273 
274         uint256 size;
275         assembly {
276             size := extcodesize(account)
277         }
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
300         (bool success, ) = recipient.call{value: amount}("");
301         require(success, "Address: unable to send value, recipient may have reverted");
302     }
303 
304     /**
305      * @dev Performs a Solidity function call using a low level `call`. A
306      * plain `call` is an unsafe replacement for a function call: use this
307      * function instead.
308      *
309      * If `target` reverts with a revert reason, it is bubbled up by this
310      * function (like regular Solidity function calls).
311      *
312      * Returns the raw returned data. To convert to the expected return value,
313      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
314      *
315      * Requirements:
316      *
317      * - `target` must be a contract.
318      * - calling `target` with `data` must not revert.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
323         return functionCall(target, data, "Address: low-level call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(
333         address target,
334         bytes memory data,
335         string memory errorMessage
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, 0, errorMessage);
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
351     function functionCallWithValue(
352         address target,
353         bytes memory data,
354         uint256 value
355     ) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
361      * with `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(
366         address target,
367         bytes memory data,
368         uint256 value,
369         string memory errorMessage
370     ) internal returns (bytes memory) {
371         require(address(this).balance >= value, "Address: insufficient balance for call");
372         require(isContract(target), "Address: call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.call{value: value}(data);
375         return verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380      * but performing a static call.
381      *
382      * _Available since v3.3._
383      */
384     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
385         return functionStaticCall(target, data, "Address: low-level static call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
390      * but performing a static call.
391      *
392      * _Available since v3.3._
393      */
394     function functionStaticCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal view returns (bytes memory) {
399         require(isContract(target), "Address: static call to non-contract");
400 
401         (bool success, bytes memory returndata) = target.staticcall(data);
402         return verifyCallResult(success, returndata, errorMessage);
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
407      * but performing a delegate call.
408      *
409      * _Available since v3.4._
410      */
411     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
412         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
417      * but performing a delegate call.
418      *
419      * _Available since v3.4._
420      */
421     function functionDelegateCall(
422         address target,
423         bytes memory data,
424         string memory errorMessage
425     ) internal returns (bytes memory) {
426         require(isContract(target), "Address: delegate call to non-contract");
427 
428         (bool success, bytes memory returndata) = target.delegatecall(data);
429         return verifyCallResult(success, returndata, errorMessage);
430     }
431 
432     /**
433      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
434      * revert reason using the provided one.
435      *
436      * _Available since v4.3._
437      */
438     function verifyCallResult(
439         bool success,
440         bytes memory returndata,
441         string memory errorMessage
442     ) internal pure returns (bytes memory) {
443         if (success) {
444             return returndata;
445         } else {
446             // Look for revert reason and bubble it up if present
447             if (returndata.length > 0) {
448                 // The easiest way to bubble the revert reason is using memory via assembly
449 
450                 assembly {
451                     let returndata_size := mload(returndata)
452                     revert(add(32, returndata), returndata_size)
453                 }
454             } else {
455                 revert(errorMessage);
456             }
457         }
458     }
459 }
460 
461 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
462 
463 
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
470  * @dev See https://eips.ethereum.org/EIPS/eip-721
471  */
472 interface IERC721Metadata is IERC721 {
473     /**
474      * @dev Returns the token collection name.
475      */
476     function name() external view returns (string memory);
477 
478     /**
479      * @dev Returns the token collection symbol.
480      */
481     function symbol() external view returns (string memory);
482 
483     /**
484      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
485      */
486     function tokenURI(uint256 tokenId) external view returns (string memory);
487 }
488 
489 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
490 
491 
492 
493 pragma solidity ^0.8.0;
494 
495 /**
496  * @title ERC721 token receiver interface
497  * @dev Interface for any contract that wants to support safeTransfers
498  * from ERC721 asset contracts.
499  */
500 interface IERC721Receiver {
501     /**
502      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
503      * by `operator` from `from`, this function is called.
504      *
505      * It must return its Solidity selector to confirm the token transfer.
506      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
507      *
508      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
509      */
510     function onERC721Received(
511         address operator,
512         address from,
513         uint256 tokenId,
514         bytes calldata data
515     ) external returns (bytes4);
516 }
517 
518 // File: @openzeppelin/contracts/utils/Context.sol
519 pragma solidity ^0.8.0;
520 /**
521  * @dev Provides information about the current execution context, including the
522  * sender of the transaction and its data. While these are generally available
523  * via msg.sender and msg.data, they should not be accessed in such a direct
524  * manner, since when dealing with meta-transactions the account sending and
525  * paying for execution may not be the actual sender (as far as an application
526  * is concerned).
527  *
528  * This contract is only required for intermediate, library-like contracts.
529  */
530 abstract contract Context {
531     function _msgSender() internal view virtual returns (address) {
532         return msg.sender;
533     }
534 
535     function _msgData() internal view virtual returns (bytes calldata) {
536         return msg.data;
537     }
538 }
539 
540 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 // CAUTION
545 // This version of SafeMath should only be used with Solidity 0.8 or later,
546 // because it relies on the compiler's built in overflow checks.
547 
548 /**
549  * @dev Wrappers over Solidity's arithmetic operations.
550  *
551  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
552  * now has built in overflow checking.
553  */
554 library SafeMath {
555     /**
556      * @dev Returns the addition of two unsigned integers, with an overflow flag.
557      *
558      * _Available since v3.4._
559      */
560     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
561         unchecked {
562             uint256 c = a + b;
563             if (c < a) return (false, 0);
564             return (true, c);
565         }
566     }
567 
568     /**
569      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
570      *
571      * _Available since v3.4._
572      */
573     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
574         unchecked {
575             if (b > a) return (false, 0);
576             return (true, a - b);
577         }
578     }
579 
580     /**
581      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
582      *
583      * _Available since v3.4._
584      */
585     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
586         unchecked {
587             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
588             // benefit is lost if 'b' is also tested.
589             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
590             if (a == 0) return (true, 0);
591             uint256 c = a * b;
592             if (c / a != b) return (false, 0);
593             return (true, c);
594         }
595     }
596 
597     /**
598      * @dev Returns the division of two unsigned integers, with a division by zero flag.
599      *
600      * _Available since v3.4._
601      */
602     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
603         unchecked {
604             if (b == 0) return (false, 0);
605             return (true, a / b);
606         }
607     }
608 
609     /**
610      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
611      *
612      * _Available since v3.4._
613      */
614     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
615         unchecked {
616             if (b == 0) return (false, 0);
617             return (true, a % b);
618         }
619     }
620 
621     /**
622      * @dev Returns the addition of two unsigned integers, reverting on
623      * overflow.
624      *
625      * Counterpart to Solidity's `+` operator.
626      *
627      * Requirements:
628      *
629      * - Addition cannot overflow.
630      */
631     function add(uint256 a, uint256 b) internal pure returns (uint256) {
632         return a + b;
633     }
634 
635     /**
636      * @dev Returns the subtraction of two unsigned integers, reverting on
637      * overflow (when the result is negative).
638      *
639      * Counterpart to Solidity's `-` operator.
640      *
641      * Requirements:
642      *
643      * - Subtraction cannot overflow.
644      */
645     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
646         return a - b;
647     }
648 
649     /**
650      * @dev Returns the multiplication of two unsigned integers, reverting on
651      * overflow.
652      *
653      * Counterpart to Solidity's `*` operator.
654      *
655      * Requirements:
656      *
657      * - Multiplication cannot overflow.
658      */
659     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
660         return a * b;
661     }
662 
663     /**
664      * @dev Returns the integer division of two unsigned integers, reverting on
665      * division by zero. The result is rounded towards zero.
666      *
667      * Counterpart to Solidity's `/` operator.
668      *
669      * Requirements:
670      *
671      * - The divisor cannot be zero.
672      */
673     function div(uint256 a, uint256 b) internal pure returns (uint256) {
674         return a / b;
675     }
676 
677     /**
678      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
679      * reverting when dividing by zero.
680      *
681      * Counterpart to Solidity's `%` operator. This function uses a `revert`
682      * opcode (which leaves remaining gas untouched) while Solidity uses an
683      * invalid opcode to revert (consuming all remaining gas).
684      *
685      * Requirements:
686      *
687      * - The divisor cannot be zero.
688      */
689     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
690         return a % b;
691     }
692 
693     /**
694      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
695      * overflow (when the result is negative).
696      *
697      * CAUTION: This function is deprecated because it requires allocating memory for the error
698      * message unnecessarily. For custom revert reasons use {trySub}.
699      *
700      * Counterpart to Solidity's `-` operator.
701      *
702      * Requirements:
703      *
704      * - Subtraction cannot overflow.
705      */
706     function sub(
707         uint256 a,
708         uint256 b,
709         string memory errorMessage
710     ) internal pure returns (uint256) {
711         unchecked {
712             require(b <= a, errorMessage);
713             return a - b;
714         }
715     }
716 
717     /**
718      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
719      * division by zero. The result is rounded towards zero.
720      *
721      * Counterpart to Solidity's `/` operator. Note: this function uses a
722      * `revert` opcode (which leaves remaining gas untouched) while Solidity
723      * uses an invalid opcode to revert (consuming all remaining gas).
724      *
725      * Requirements:
726      *
727      * - The divisor cannot be zero.
728      */
729     function div(
730         uint256 a,
731         uint256 b,
732         string memory errorMessage
733     ) internal pure returns (uint256) {
734         unchecked {
735             require(b > 0, errorMessage);
736             return a / b;
737         }
738     }
739 
740     /**
741      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
742      * reverting with custom message when dividing by zero.
743      *
744      * CAUTION: This function is deprecated because it requires allocating memory for the error
745      * message unnecessarily. For custom revert reasons use {tryMod}.
746      *
747      * Counterpart to Solidity's `%` operator. This function uses a `revert`
748      * opcode (which leaves remaining gas untouched) while Solidity uses an
749      * invalid opcode to revert (consuming all remaining gas).
750      *
751      * Requirements:
752      *
753      * - The divisor cannot be zero.
754      */
755     function mod(
756         uint256 a,
757         uint256 b,
758         string memory errorMessage
759     ) internal pure returns (uint256) {
760         unchecked {
761             require(b > 0, errorMessage);
762             return a % b;
763         }
764     }
765 }
766 
767 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
768 
769 pragma solidity ^0.8.0;
770 
771 /**
772  * @title Counters
773  * @author Matt Condon (@shrugs)
774  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
775  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
776  *
777  * Include with `using Counters for Counters.Counter;`
778  */
779 library Counters {
780     struct Counter {
781         // This variable should never be directly accessed by users of the library: interactions must be restricted to
782         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
783         // this feature: see https://github.com/ethereum/solidity/issues/4637
784         uint256 _value; // default: 0
785     }
786 
787     function current(Counter storage counter) internal view returns (uint256) {
788         return counter._value;
789     }
790 
791     function increment(Counter storage counter) internal {
792         unchecked {
793             counter._value += 1;
794         }
795     }
796 
797     function decrement(Counter storage counter) internal {
798         uint256 value = counter._value;
799         require(value > 0, "Counter: decrement overflow");
800         unchecked {
801             counter._value = value - 1;
802         }
803     }
804 
805     function reset(Counter storage counter) internal {
806         counter._value = 0;
807     }
808 }
809 
810 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
811 pragma solidity ^0.8.0;
812 /**
813  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
814  * the Metadata extension, but not including the Enumerable extension, which is available separately as
815  * {ERC721Enumerable}.
816  */
817 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
818     using Address for address;
819     using Strings for uint256;
820 
821     // Token name
822     string private _name;
823 
824     // Token symbol
825     string private _symbol;
826 
827     // Mapping from token ID to owner address
828     mapping(uint256 => address) private _owners;
829 
830     // Mapping owner address to token count
831     mapping(address => uint256) private _balances;
832 
833     // Mapping from token ID to approved address
834     mapping(uint256 => address) private _tokenApprovals;
835 
836     // Mapping from owner to operator approvals
837     mapping(address => mapping(address => bool)) private _operatorApprovals;
838 
839     /**
840      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
841      */
842     constructor(string memory name_, string memory symbol_) {
843         _name = name_;
844         _symbol = symbol_;
845     }
846 
847     /**
848      * @dev See {IERC165-supportsInterface}.
849      */
850     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
851         return
852             interfaceId == type(IERC721).interfaceId ||
853             interfaceId == type(IERC721Metadata).interfaceId ||
854             super.supportsInterface(interfaceId);
855     }
856 
857     /**
858      * @dev See {IERC721-balanceOf}.
859      */
860     function balanceOf(address owner) public view virtual override returns (uint256) {
861         require(owner != address(0), "ERC721: balance query for the zero address");
862         return _balances[owner];
863     }
864 
865     /**
866      * @dev See {IERC721-ownerOf}.
867      */
868     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
869         address owner = _owners[tokenId];
870         require(owner != address(0), "ERC721: owner query for nonexistent token");
871         return owner;
872     }
873 
874     /**
875      * @dev See {IERC721Metadata-name}.
876      */
877     function name() public view virtual override returns (string memory) {
878         return _name;
879     }
880 
881     /**
882      * @dev See {IERC721Metadata-symbol}.
883      */
884     function symbol() public view virtual override returns (string memory) {
885         return _symbol;
886     }
887 
888     /**
889      * @dev See {IERC721Metadata-tokenURI}.
890      */
891     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
892         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
893 
894         string memory baseURI = _baseURI();
895         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
896     }
897 
898     /**
899      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
900      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
901      * by default, can be overriden in child contracts.
902      */
903     function _baseURI() internal view virtual returns (string memory) {
904         return "";
905     }
906 
907     /**
908      * @dev See {IERC721-approve}.
909      */
910     function approve(address to, uint256 tokenId) public virtual override {
911         address owner = ERC721.ownerOf(tokenId);
912         require(to != owner, "ERC721: approval to current owner");
913 
914         require(
915             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
916             "ERC721: approve caller is not owner nor approved for all"
917         );
918 
919         _approve(to, tokenId);
920     }
921 
922     /**
923      * @dev See {IERC721-getApproved}.
924      */
925     function getApproved(uint256 tokenId) public view virtual override returns (address) {
926         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
927 
928         return _tokenApprovals[tokenId];
929     }
930 
931     /**
932      * @dev See {IERC721-setApprovalForAll}.
933      */
934     function setApprovalForAll(address operator, bool approved) public virtual override {
935         require(operator != _msgSender(), "ERC721: approve to caller");
936 
937         _operatorApprovals[_msgSender()][operator] = approved;
938         emit ApprovalForAll(_msgSender(), operator, approved);
939     }
940 
941     /**
942      * @dev See {IERC721-isApprovedForAll}.
943      */
944     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
945         return _operatorApprovals[owner][operator];
946     }
947 
948     /**
949      * @dev See {IERC721-transferFrom}.
950      */
951     function transferFrom(
952         address from,
953         address to,
954         uint256 tokenId
955     ) public virtual override {
956         //solhint-disable-next-line max-line-length
957         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
958 
959         _transfer(from, to, tokenId);
960     }
961 
962     /**
963      * @dev See {IERC721-safeTransferFrom}.
964      */
965     function safeTransferFrom(
966         address from,
967         address to,
968         uint256 tokenId
969     ) public virtual override {
970         safeTransferFrom(from, to, tokenId, "");
971     }
972 
973     /**
974      * @dev See {IERC721-safeTransferFrom}.
975      */
976     function safeTransferFrom(
977         address from,
978         address to,
979         uint256 tokenId,
980         bytes memory _data
981     ) public virtual override {
982         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
983         _safeTransfer(from, to, tokenId, _data);
984     }
985 
986     /**
987      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
988      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
989      *
990      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
991      *
992      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
993      * implement alternative mechanisms to perform token transfer, such as signature-based.
994      *
995      * Requirements:
996      *
997      * - `from` cannot be the zero address.
998      * - `to` cannot be the zero address.
999      * - `tokenId` token must exist and be owned by `from`.
1000      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _safeTransfer(
1005         address from,
1006         address to,
1007         uint256 tokenId,
1008         bytes memory _data
1009     ) internal virtual {
1010         _transfer(from, to, tokenId);
1011         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1012     }
1013 
1014     /**
1015      * @dev Returns whether `tokenId` exists.
1016      *
1017      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1018      *
1019      * Tokens start existing when they are minted (`_mint`),
1020      * and stop existing when they are burned (`_burn`).
1021      */
1022     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1023         return _owners[tokenId] != address(0);
1024     }
1025 
1026     /**
1027      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1028      *
1029      * Requirements:
1030      *
1031      * - `tokenId` must exist.
1032      */
1033     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1034         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1035         address owner = ERC721.ownerOf(tokenId);
1036         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1037     }
1038 
1039     /**
1040      * @dev Safely mints `tokenId` and transfers it to `to`.
1041      *
1042      * Requirements:
1043      *
1044      * - `tokenId` must not exist.
1045      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1046      *
1047      * Emits a {Transfer} event.
1048      */
1049     function _safeMint(address to, uint256 tokenId) internal virtual {
1050         _safeMint(to, tokenId, "");
1051     }
1052 
1053     /**
1054      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1055      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1056      */
1057     function _safeMint(
1058         address to,
1059         uint256 tokenId,
1060         bytes memory _data
1061     ) internal virtual {
1062         _mint(to, tokenId);
1063         require(
1064             _checkOnERC721Received(address(0), to, tokenId, _data),
1065             "ERC721: transfer to non ERC721Receiver implementer"
1066         );
1067     }
1068 
1069     /**
1070      * @dev Mints `tokenId` and transfers it to `to`.
1071      *
1072      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1073      *
1074      * Requirements:
1075      *
1076      * - `tokenId` must not exist.
1077      * - `to` cannot be the zero address.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _mint(address to, uint256 tokenId) internal virtual {
1082         require(to != address(0), "ERC721: mint to the zero address");
1083         require(!_exists(tokenId), "ERC721: token already minted");
1084 
1085         _beforeTokenTransfer(address(0), to, tokenId);
1086 
1087         _balances[to] += 1;
1088         _owners[tokenId] = to;
1089 
1090         emit Transfer(address(0), to, tokenId);
1091     }
1092 
1093     /**
1094      * @dev Destroys `tokenId`.
1095      * The approval is cleared when the token is burned.
1096      *
1097      * Requirements:
1098      *
1099      * - `tokenId` must exist.
1100      *
1101      * Emits a {Transfer} event.
1102      */
1103     function _burn(uint256 tokenId) internal virtual {
1104         address owner = ERC721.ownerOf(tokenId);
1105 
1106         _beforeTokenTransfer(owner, address(0), tokenId);
1107 
1108         // Clear approvals
1109         _approve(address(0), tokenId);
1110 
1111         _balances[owner] -= 1;
1112         delete _owners[tokenId];
1113 
1114         emit Transfer(owner, address(0), tokenId);
1115     }
1116 
1117     /**
1118      * @dev Transfers `tokenId` from `from` to `to`.
1119      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1120      *
1121      * Requirements:
1122      *
1123      * - `to` cannot be the zero address.
1124      * - `tokenId` token must be owned by `from`.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function _transfer(
1129         address from,
1130         address to,
1131         uint256 tokenId
1132     ) internal virtual {
1133         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1134         require(to != address(0), "ERC721: transfer to the zero address");
1135 
1136         _beforeTokenTransfer(from, to, tokenId);
1137 
1138         // Clear approvals from the previous owner
1139         _approve(address(0), tokenId);
1140 
1141         _balances[from] -= 1;
1142         _balances[to] += 1;
1143         _owners[tokenId] = to;
1144 
1145         emit Transfer(from, to, tokenId);
1146     }
1147 
1148     /**
1149      * @dev Approve `to` to operate on `tokenId`
1150      *
1151      * Emits a {Approval} event.
1152      */
1153     function _approve(address to, uint256 tokenId) internal virtual {
1154         _tokenApprovals[tokenId] = to;
1155         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1156     }
1157 
1158     /**
1159      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1160      * The call is not executed if the target address is not a contract.
1161      *
1162      * @param from address representing the previous owner of the given token ID
1163      * @param to target address that will receive the tokens
1164      * @param tokenId uint256 ID of the token to be transferred
1165      * @param _data bytes optional data to send along with the call
1166      * @return bool whether the call correctly returned the expected magic value
1167      */
1168     function _checkOnERC721Received(
1169         address from,
1170         address to,
1171         uint256 tokenId,
1172         bytes memory _data
1173     ) private returns (bool) {
1174         if (to.isContract()) {
1175             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1176                 return retval == IERC721Receiver.onERC721Received.selector;
1177             } catch (bytes memory reason) {
1178                 if (reason.length == 0) {
1179                     revert("ERC721: transfer to non ERC721Receiver implementer");
1180                 } else {
1181                     assembly {
1182                         revert(add(32, reason), mload(reason))
1183                     }
1184                 }
1185             }
1186         } else {
1187             return true;
1188         }
1189     }
1190 
1191     /**
1192      * @dev Hook that is called before any token transfer. This includes minting
1193      * and burning.
1194      *
1195      * Calling conditions:
1196      *
1197      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1198      * transferred to `to`.
1199      * - When `from` is zero, `tokenId` will be minted for `to`.
1200      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1201      * - `from` and `to` are never both zero.
1202      *
1203      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1204      */
1205     function _beforeTokenTransfer(
1206         address from,
1207         address to,
1208         uint256 tokenId
1209     ) internal virtual {}
1210 }
1211 
1212 
1213 
1214 // File: @openzeppelin/contracts/access/Ownable.sol
1215 pragma solidity ^0.8.0;
1216 /**
1217  * @dev Contract module which provides a basic access control mechanism, where
1218  * there is an account (an owner) that can be granted exclusive access to
1219  * specific functions.
1220  *
1221  * By default, the owner account will be the one that deploys the contract. This
1222  * can later be changed with {transferOwnership}.
1223  *
1224  * This module is used through inheritance. It will make available the modifier
1225  * `onlyOwner`, which can be applied to your functions to restrict their use to
1226  * the owner.
1227  */
1228 abstract contract Ownable is Context {
1229     address private _owner;
1230 
1231     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1232 
1233     /**
1234      * @dev Initializes the contract setting the deployer as the initial owner.
1235      */
1236     constructor() {
1237         _setOwner(_msgSender());
1238     }
1239 
1240     /**
1241      * @dev Returns the address of the current owner.
1242      */
1243     function owner() public view virtual returns (address) {
1244         return _owner;
1245     }
1246 
1247     /**
1248      * @dev Throws if called by any account other than the owner.
1249      */
1250     modifier onlyOwner() {
1251         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1252         _;
1253     }
1254 
1255     /**
1256      * @dev Leaves the contract without owner. It will not be possible to call
1257      * `onlyOwner` functions anymore. Can only be called by the current owner.
1258      *
1259      * NOTE: Renouncing ownership will leave the contract without an owner,
1260      * thereby removing any functionality that is only available to the owner.
1261      */
1262     function renounceOwnership() public virtual onlyOwner {
1263         _setOwner(address(0));
1264     }
1265 
1266     /**
1267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1268      * Can only be called by the current owner.
1269      */
1270     function transferOwnership(address newOwner) public virtual onlyOwner {
1271         require(newOwner != address(0), "Ownable: new owner is the zero address");
1272         _setOwner(newOwner);
1273     }
1274 
1275     function _setOwner(address newOwner) private {
1276         address oldOwner = _owner;
1277         _owner = newOwner;
1278         emit OwnershipTransferred(oldOwner, newOwner);
1279     }
1280 }
1281 
1282 pragma solidity ^0.8.0;
1283 
1284 contract LarvaDoodles is Ownable, ERC721 {
1285   
1286   using SafeMath for uint256;
1287   using Counters for Counters.Counter;
1288   Counters.Counter private _tokenIdCounter;
1289   
1290   uint256 public mintPrice = .016 ether;
1291   uint256 public maxSupply = 3333;
1292   uint256 public freeMintAmount =1000;
1293   uint256 private mintLimit = 10;
1294   string private baseURI = "ipfs://QmaR3mSaWu86pcZ1bbcFdanga5DhkL9JZaPLrPze1ouHCC/";
1295   bool public publicSaleState = true;
1296   bool public revealed = true;
1297   string private base_URI_tail = ".json";
1298   string private hiddenURI = "";
1299 
1300   constructor() ERC721("Larva Doodles", "LDOODLE") { 
1301   }
1302 
1303   function _hiddenURI() internal view returns (string memory) {
1304     return hiddenURI;
1305   }
1306   
1307   function _baseURI() internal view override returns (string memory) {
1308     return baseURI;
1309   }
1310 
1311   function setBaseURI(string calldata newBaseURI) external onlyOwner {
1312       baseURI = newBaseURI;
1313   }
1314 
1315   function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1316     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1317     if(revealed == false) {
1318         return hiddenURI; 
1319     }
1320   string memory currentBaseURI = _baseURI();
1321   return string(abi.encodePacked(currentBaseURI, Strings.toString(_tokenId), base_URI_tail));
1322   }  
1323 
1324   function reveal() public onlyOwner returns(bool) {
1325     revealed = !revealed;
1326     return revealed;
1327   }
1328       
1329   function changeStatePublicSale() public onlyOwner returns(bool) {
1330     publicSaleState = !publicSaleState;
1331     return publicSaleState;
1332   }
1333 
1334   function mint(uint numberOfTokens) external payable {
1335     require(publicSaleState, "Sale is not active");
1336     require(_tokenIdCounter.current() <= maxSupply, "Not enough tokens left");
1337     require(numberOfTokens <= mintLimit, "Too many tokens for one transaction");
1338     if(_tokenIdCounter.current() >= freeMintAmount){
1339         require(msg.value >= mintPrice.mul(numberOfTokens), "Insufficient payment");
1340     }
1341     mintInternal(msg.sender, numberOfTokens);
1342   }
1343  
1344   function mintInternal(address wallet, uint amount) internal {
1345     uint currentTokenSupply = _tokenIdCounter.current();
1346     require(currentTokenSupply.add(amount) <= maxSupply, "Not enough tokens left");
1347         for(uint i = 0; i< amount; i++){
1348         currentTokenSupply++;
1349         _safeMint(wallet, currentTokenSupply);
1350         _tokenIdCounter.increment();
1351     }
1352   }
1353   
1354   function reserve(uint256 numberOfTokens) external onlyOwner {
1355     mintInternal(msg.sender, numberOfTokens);
1356   }
1357   function setfreeAmount(uint16 _newFreeMints) public onlyOwner() {
1358     freeMintAmount = _newFreeMints;
1359   }
1360 
1361   function totalSupply() public view returns (uint){
1362     return _tokenIdCounter.current();
1363   }
1364 
1365   function withdraw() public onlyOwner {
1366     require(address(this).balance > 0, "No balance to withdraw");
1367     payable(owner()).transfer(address(this).balance); 
1368     }
1369 }