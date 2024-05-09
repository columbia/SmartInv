1 // Dependency file: @openzeppelin/contracts/utils/Address.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Collection of functions related to the address type
9  */
10 library Address {
11     /**
12      * @dev Returns true if `account` is a contract.
13      *
14      * [IMPORTANT]
15      * ====
16      * It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      *
19      * Among others, `isContract` will return false for the following
20      * types of addresses:
21      *
22      *  - an externally-owned account
23      *  - a contract in construction
24      *  - an address where a contract will be created
25      *  - an address where a contract lived, but was destroyed
26      * ====
27      */
28     function isContract(address account) internal view returns (bool) {
29         // This method relies on extcodesize, which returns 0 for contracts in
30         // construction, since the code is only stored at the end of the
31         // constructor execution.
32 
33         uint256 size;
34         assembly {
35             size := extcodesize(account)
36         }
37         return size > 0;
38     }
39 
40     /**
41      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
42      * `recipient`, forwarding all available gas and reverting on errors.
43      *
44      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
45      * of certain opcodes, possibly making contracts go over the 2300 gas limit
46      * imposed by `transfer`, making them unable to receive funds via
47      * `transfer`. {sendValue} removes this limitation.
48      *
49      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
50      *
51      * IMPORTANT: because control is transferred to `recipient`, care must be
52      * taken to not create reentrancy vulnerabilities. Consider using
53      * {ReentrancyGuard} or the
54      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
55      */
56     function sendValue(address payable recipient, uint256 amount) internal {
57         require(address(this).balance >= amount, "Address: insufficient balance");
58 
59         (bool success, ) = recipient.call{value: amount}("");
60         require(success, "Address: unable to send value, recipient may have reverted");
61     }
62 
63     /**
64      * @dev Performs a Solidity function call using a low level `call`. A
65      * plain `call` is an unsafe replacement for a function call: use this
66      * function instead.
67      *
68      * If `target` reverts with a revert reason, it is bubbled up by this
69      * function (like regular Solidity function calls).
70      *
71      * Returns the raw returned data. To convert to the expected return value,
72      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
73      *
74      * Requirements:
75      *
76      * - `target` must be a contract.
77      * - calling `target` with `data` must not revert.
78      *
79      * _Available since v3.1._
80      */
81     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
82         return functionCall(target, data, "Address: low-level call failed");
83     }
84 
85     /**
86      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
87      * `errorMessage` as a fallback revert reason when `target` reverts.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(
92         address target,
93         bytes memory data,
94         string memory errorMessage
95     ) internal returns (bytes memory) {
96         return functionCallWithValue(target, data, 0, errorMessage);
97     }
98 
99     /**
100      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
101      * but also transferring `value` wei to `target`.
102      *
103      * Requirements:
104      *
105      * - the calling contract must have an ETH balance of at least `value`.
106      * - the called Solidity function must be `payable`.
107      *
108      * _Available since v3.1._
109      */
110     function functionCallWithValue(
111         address target,
112         bytes memory data,
113         uint256 value
114     ) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
116     }
117 
118     /**
119      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
120      * with `errorMessage` as a fallback revert reason when `target` reverts.
121      *
122      * _Available since v3.1._
123      */
124     function functionCallWithValue(
125         address target,
126         bytes memory data,
127         uint256 value,
128         string memory errorMessage
129     ) internal returns (bytes memory) {
130         require(address(this).balance >= value, "Address: insufficient balance for call");
131         require(isContract(target), "Address: call to non-contract");
132 
133         (bool success, bytes memory returndata) = target.call{value: value}(data);
134         return _verifyCallResult(success, returndata, errorMessage);
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
144         return functionStaticCall(target, data, "Address: low-level static call failed");
145     }
146 
147     /**
148      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
149      * but performing a static call.
150      *
151      * _Available since v3.3._
152      */
153     function functionStaticCall(
154         address target,
155         bytes memory data,
156         string memory errorMessage
157     ) internal view returns (bytes memory) {
158         require(isContract(target), "Address: static call to non-contract");
159 
160         (bool success, bytes memory returndata) = target.staticcall(data);
161         return _verifyCallResult(success, returndata, errorMessage);
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
166      * but performing a delegate call.
167      *
168      * _Available since v3.4._
169      */
170     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
171         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
176      * but performing a delegate call.
177      *
178      * _Available since v3.4._
179      */
180     function functionDelegateCall(
181         address target,
182         bytes memory data,
183         string memory errorMessage
184     ) internal returns (bytes memory) {
185         require(isContract(target), "Address: delegate call to non-contract");
186 
187         (bool success, bytes memory returndata) = target.delegatecall(data);
188         return _verifyCallResult(success, returndata, errorMessage);
189     }
190 
191     function _verifyCallResult(
192         bool success,
193         bytes memory returndata,
194         string memory errorMessage
195     ) private pure returns (bytes memory) {
196         if (success) {
197             return returndata;
198         } else {
199             // Look for revert reason and bubble it up if present
200             if (returndata.length > 0) {
201                 // The easiest way to bubble the revert reason is using memory via assembly
202 
203                 assembly {
204                     let returndata_size := mload(returndata)
205                     revert(add(32, returndata), returndata_size)
206                 }
207             } else {
208                 revert(errorMessage);
209             }
210         }
211     }
212 }
213 
214 
215 // Dependency file: @openzeppelin/contracts/utils/math/SafeMath.sol
216 
217 
218 // pragma solidity ^0.8.0;
219 
220 // CAUTION
221 // This version of SafeMath should only be used with Solidity 0.8 or later,
222 // because it relies on the compiler's built in overflow checks.
223 
224 /**
225  * @dev Wrappers over Solidity's arithmetic operations.
226  *
227  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
228  * now has built in overflow checking.
229  */
230 library SafeMath {
231     /**
232      * @dev Returns the addition of two unsigned integers, with an overflow flag.
233      *
234      * _Available since v3.4._
235      */
236     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
237         unchecked {
238             uint256 c = a + b;
239             if (c < a) return (false, 0);
240             return (true, c);
241         }
242     }
243 
244     /**
245      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
246      *
247      * _Available since v3.4._
248      */
249     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
250         unchecked {
251             if (b > a) return (false, 0);
252             return (true, a - b);
253         }
254     }
255 
256     /**
257      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
258      *
259      * _Available since v3.4._
260      */
261     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
262         unchecked {
263             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
264             // benefit is lost if 'b' is also tested.
265             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
266             if (a == 0) return (true, 0);
267             uint256 c = a * b;
268             if (c / a != b) return (false, 0);
269             return (true, c);
270         }
271     }
272 
273     /**
274      * @dev Returns the division of two unsigned integers, with a division by zero flag.
275      *
276      * _Available since v3.4._
277      */
278     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
279         unchecked {
280             if (b == 0) return (false, 0);
281             return (true, a / b);
282         }
283     }
284 
285     /**
286      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
287      *
288      * _Available since v3.4._
289      */
290     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
291         unchecked {
292             if (b == 0) return (false, 0);
293             return (true, a % b);
294         }
295     }
296 
297     /**
298      * @dev Returns the addition of two unsigned integers, reverting on
299      * overflow.
300      *
301      * Counterpart to Solidity's `+` operator.
302      *
303      * Requirements:
304      *
305      * - Addition cannot overflow.
306      */
307     function add(uint256 a, uint256 b) internal pure returns (uint256) {
308         return a + b;
309     }
310 
311     /**
312      * @dev Returns the subtraction of two unsigned integers, reverting on
313      * overflow (when the result is negative).
314      *
315      * Counterpart to Solidity's `-` operator.
316      *
317      * Requirements:
318      *
319      * - Subtraction cannot overflow.
320      */
321     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
322         return a - b;
323     }
324 
325     /**
326      * @dev Returns the multiplication of two unsigned integers, reverting on
327      * overflow.
328      *
329      * Counterpart to Solidity's `*` operator.
330      *
331      * Requirements:
332      *
333      * - Multiplication cannot overflow.
334      */
335     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
336         return a * b;
337     }
338 
339     /**
340      * @dev Returns the integer division of two unsigned integers, reverting on
341      * division by zero. The result is rounded towards zero.
342      *
343      * Counterpart to Solidity's `/` operator.
344      *
345      * Requirements:
346      *
347      * - The divisor cannot be zero.
348      */
349     function div(uint256 a, uint256 b) internal pure returns (uint256) {
350         return a / b;
351     }
352 
353     /**
354      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
355      * reverting when dividing by zero.
356      *
357      * Counterpart to Solidity's `%` operator. This function uses a `revert`
358      * opcode (which leaves remaining gas untouched) while Solidity uses an
359      * invalid opcode to revert (consuming all remaining gas).
360      *
361      * Requirements:
362      *
363      * - The divisor cannot be zero.
364      */
365     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
366         return a % b;
367     }
368 
369     /**
370      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
371      * overflow (when the result is negative).
372      *
373      * CAUTION: This function is deprecated because it requires allocating memory for the error
374      * message unnecessarily. For custom revert reasons use {trySub}.
375      *
376      * Counterpart to Solidity's `-` operator.
377      *
378      * Requirements:
379      *
380      * - Subtraction cannot overflow.
381      */
382     function sub(
383         uint256 a,
384         uint256 b,
385         string memory errorMessage
386     ) internal pure returns (uint256) {
387         unchecked {
388             require(b <= a, errorMessage);
389             return a - b;
390         }
391     }
392 
393     /**
394      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
395      * division by zero. The result is rounded towards zero.
396      *
397      * Counterpart to Solidity's `/` operator. Note: this function uses a
398      * `revert` opcode (which leaves remaining gas untouched) while Solidity
399      * uses an invalid opcode to revert (consuming all remaining gas).
400      *
401      * Requirements:
402      *
403      * - The divisor cannot be zero.
404      */
405     function div(
406         uint256 a,
407         uint256 b,
408         string memory errorMessage
409     ) internal pure returns (uint256) {
410         unchecked {
411             require(b > 0, errorMessage);
412             return a / b;
413         }
414     }
415 
416     /**
417      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
418      * reverting with custom message when dividing by zero.
419      *
420      * CAUTION: This function is deprecated because it requires allocating memory for the error
421      * message unnecessarily. For custom revert reasons use {tryMod}.
422      *
423      * Counterpart to Solidity's `%` operator. This function uses a `revert`
424      * opcode (which leaves remaining gas untouched) while Solidity uses an
425      * invalid opcode to revert (consuming all remaining gas).
426      *
427      * Requirements:
428      *
429      * - The divisor cannot be zero.
430      */
431     function mod(
432         uint256 a,
433         uint256 b,
434         string memory errorMessage
435     ) internal pure returns (uint256) {
436         unchecked {
437             require(b > 0, errorMessage);
438             return a % b;
439         }
440     }
441 }
442 
443 
444 // Dependency file: @openzeppelin/contracts/utils/introspection/IERC165.sol
445 
446 
447 // pragma solidity ^0.8.0;
448 
449 /**
450  * @dev Interface of the ERC165 standard, as defined in the
451  * https://eips.ethereum.org/EIPS/eip-165[EIP].
452  *
453  * Implementers can declare support of contract interfaces, which can then be
454  * queried by others ({ERC165Checker}).
455  *
456  * For an implementation, see {ERC165}.
457  */
458 interface IERC165 {
459     /**
460      * @dev Returns true if this contract implements the interface defined by
461      * `interfaceId`. See the corresponding
462      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
463      * to learn more about how these ids are created.
464      *
465      * This function call must use less than 30 000 gas.
466      */
467     function supportsInterface(bytes4 interfaceId) external view returns (bool);
468 }
469 
470 
471 // Dependency file: @openzeppelin/contracts/token/ERC721/IERC721.sol
472 
473 
474 // pragma solidity ^0.8.0;
475 
476 // import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
477 
478 /**
479  * @dev Required interface of an ERC721 compliant contract.
480  */
481 interface IERC721 is IERC165 {
482     /**
483      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
484      */
485     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
486 
487     /**
488      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
489      */
490     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
491 
492     /**
493      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
494      */
495     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
496 
497     /**
498      * @dev Returns the number of tokens in ``owner``'s account.
499      */
500     function balanceOf(address owner) external view returns (uint256 balance);
501 
502     /**
503      * @dev Returns the owner of the `tokenId` token.
504      *
505      * Requirements:
506      *
507      * - `tokenId` must exist.
508      */
509     function ownerOf(uint256 tokenId) external view returns (address owner);
510 
511     /**
512      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
513      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
514      *
515      * Requirements:
516      *
517      * - `from` cannot be the zero address.
518      * - `to` cannot be the zero address.
519      * - `tokenId` token must exist and be owned by `from`.
520      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
521      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
522      *
523      * Emits a {Transfer} event.
524      */
525     function safeTransferFrom(
526         address from,
527         address to,
528         uint256 tokenId
529     ) external;
530 
531     /**
532      * @dev Transfers `tokenId` token from `from` to `to`.
533      *
534      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
535      *
536      * Requirements:
537      *
538      * - `from` cannot be the zero address.
539      * - `to` cannot be the zero address.
540      * - `tokenId` token must be owned by `from`.
541      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
542      *
543      * Emits a {Transfer} event.
544      */
545     function transferFrom(
546         address from,
547         address to,
548         uint256 tokenId
549     ) external;
550 
551     /**
552      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
553      * The approval is cleared when the token is transferred.
554      *
555      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
556      *
557      * Requirements:
558      *
559      * - The caller must own the token or be an approved operator.
560      * - `tokenId` must exist.
561      *
562      * Emits an {Approval} event.
563      */
564     function approve(address to, uint256 tokenId) external;
565 
566     /**
567      * @dev Returns the account approved for `tokenId` token.
568      *
569      * Requirements:
570      *
571      * - `tokenId` must exist.
572      */
573     function getApproved(uint256 tokenId) external view returns (address operator);
574 
575     /**
576      * @dev Approve or remove `operator` as an operator for the caller.
577      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
578      *
579      * Requirements:
580      *
581      * - The `operator` cannot be the caller.
582      *
583      * Emits an {ApprovalForAll} event.
584      */
585     function setApprovalForAll(address operator, bool _approved) external;
586 
587     /**
588      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
589      *
590      * See {setApprovalForAll}
591      */
592     function isApprovedForAll(address owner, address operator) external view returns (bool);
593 
594     /**
595      * @dev Safely transfers `tokenId` token from `from` to `to`.
596      *
597      * Requirements:
598      *
599      * - `from` cannot be the zero address.
600      * - `to` cannot be the zero address.
601      * - `tokenId` token must exist and be owned by `from`.
602      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
603      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
604      *
605      * Emits a {Transfer} event.
606      */
607     function safeTransferFrom(
608         address from,
609         address to,
610         uint256 tokenId,
611         bytes calldata data
612     ) external;
613 }
614 
615 
616 // Dependency file: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
617 
618 
619 // pragma solidity ^0.8.0;
620 
621 /**
622  * @title ERC721 token receiver interface
623  * @dev Interface for any contract that wants to support safeTransfers
624  * from ERC721 asset contracts.
625  */
626 interface IERC721Receiver {
627     /**
628      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
629      * by `operator` from `from`, this function is called.
630      *
631      * It must return its Solidity selector to confirm the token transfer.
632      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
633      *
634      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
635      */
636     function onERC721Received(
637         address operator,
638         address from,
639         uint256 tokenId,
640         bytes calldata data
641     ) external returns (bytes4);
642 }
643 
644 
645 // Dependency file: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
646 
647 
648 // pragma solidity ^0.8.0;
649 
650 // import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
651 
652 /**
653  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
654  * @dev See https://eips.ethereum.org/EIPS/eip-721
655  */
656 interface IERC721Metadata is IERC721 {
657     /**
658      * @dev Returns the token collection name.
659      */
660     function name() external view returns (string memory);
661 
662     /**
663      * @dev Returns the token collection symbol.
664      */
665     function symbol() external view returns (string memory);
666 
667     /**
668      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
669      */
670     function tokenURI(uint256 tokenId) external view returns (string memory);
671 }
672 
673 
674 // Dependency file: @openzeppelin/contracts/utils/Context.sol
675 
676 
677 // pragma solidity ^0.8.0;
678 
679 /*
680  * @dev Provides information about the current execution context, including the
681  * sender of the transaction and its data. While these are generally available
682  * via msg.sender and msg.data, they should not be accessed in such a direct
683  * manner, since when dealing with meta-transactions the account sending and
684  * paying for execution may not be the actual sender (as far as an application
685  * is concerned).
686  *
687  * This contract is only required for intermediate, library-like contracts.
688  */
689 abstract contract Context {
690     function _msgSender() internal view virtual returns (address) {
691         return msg.sender;
692     }
693 
694     function _msgData() internal view virtual returns (bytes calldata) {
695         return msg.data;
696     }
697 }
698 
699 
700 // Dependency file: @openzeppelin/contracts/utils/Strings.sol
701 
702 
703 // pragma solidity ^0.8.0;
704 
705 /**
706  * @dev String operations.
707  */
708 library Strings {
709     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
710 
711     /**
712      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
713      */
714     function toString(uint256 value) internal pure returns (string memory) {
715         // Inspired by OraclizeAPI's implementation - MIT licence
716         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
717 
718         if (value == 0) {
719             return "0";
720         }
721         uint256 temp = value;
722         uint256 digits;
723         while (temp != 0) {
724             digits++;
725             temp /= 10;
726         }
727         bytes memory buffer = new bytes(digits);
728         while (value != 0) {
729             digits -= 1;
730             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
731             value /= 10;
732         }
733         return string(buffer);
734     }
735 
736     /**
737      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
738      */
739     function toHexString(uint256 value) internal pure returns (string memory) {
740         if (value == 0) {
741             return "0x00";
742         }
743         uint256 temp = value;
744         uint256 length = 0;
745         while (temp != 0) {
746             length++;
747             temp >>= 8;
748         }
749         return toHexString(value, length);
750     }
751 
752     /**
753      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
754      */
755     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
756         bytes memory buffer = new bytes(2 * length + 2);
757         buffer[0] = "0";
758         buffer[1] = "x";
759         for (uint256 i = 2 * length + 1; i > 1; --i) {
760             buffer[i] = _HEX_SYMBOLS[value & 0xf];
761             value >>= 4;
762         }
763         require(value == 0, "Strings: hex length insufficient");
764         return string(buffer);
765     }
766 }
767 
768 
769 // Dependency file: @openzeppelin/contracts/utils/introspection/ERC165.sol
770 
771 
772 // pragma solidity ^0.8.0;
773 
774 // import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
775 
776 /**
777  * @dev Implementation of the {IERC165} interface.
778  *
779  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
780  * for the additional interface id that will be supported. For example:
781  *
782  * ```solidity
783  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
784  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
785  * }
786  * ```
787  *
788  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
789  */
790 abstract contract ERC165 is IERC165 {
791     /**
792      * @dev See {IERC165-supportsInterface}.
793      */
794     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
795         return interfaceId == type(IERC165).interfaceId;
796     }
797 }
798 
799 
800 // Dependency file: @openzeppelin/contracts/token/ERC721/ERC721.sol
801 
802 
803 // pragma solidity ^0.8.0;
804 
805 // import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
806 // import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
807 // import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
808 // import "@openzeppelin/contracts/utils/Address.sol";
809 // import "@openzeppelin/contracts/utils/Context.sol";
810 // import "@openzeppelin/contracts/utils/Strings.sol";
811 // import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
812 
813 /**
814  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
815  * the Metadata extension, but not including the Enumerable extension, which is available separately as
816  * {ERC721Enumerable}.
817  */
818 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
819     using Address for address;
820     using Strings for uint256;
821 
822     // Token name
823     string private _name;
824 
825     // Token symbol
826     string private _symbol;
827 
828     // Mapping from token ID to owner address
829     mapping(uint256 => address) private _owners;
830 
831     // Mapping owner address to token count
832     mapping(address => uint256) private _balances;
833 
834     // Mapping from token ID to approved address
835     mapping(uint256 => address) private _tokenApprovals;
836 
837     // Mapping from owner to operator approvals
838     mapping(address => mapping(address => bool)) private _operatorApprovals;
839 
840     /**
841      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
842      */
843     constructor(string memory name_, string memory symbol_) {
844         _name = name_;
845         _symbol = symbol_;
846     }
847 
848     /**
849      * @dev See {IERC165-supportsInterface}.
850      */
851     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
852         return
853             interfaceId == type(IERC721).interfaceId ||
854             interfaceId == type(IERC721Metadata).interfaceId ||
855             super.supportsInterface(interfaceId);
856     }
857 
858     /**
859      * @dev See {IERC721-balanceOf}.
860      */
861     function balanceOf(address owner) public view virtual override returns (uint256) {
862         require(owner != address(0), "ERC721: balance query for the zero address");
863         return _balances[owner];
864     }
865 
866     /**
867      * @dev See {IERC721-ownerOf}.
868      */
869     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
870         address owner = _owners[tokenId];
871         require(owner != address(0), "ERC721: owner query for nonexistent token");
872         return owner;
873     }
874 
875     /**
876      * @dev See {IERC721Metadata-name}.
877      */
878     function name() public view virtual override returns (string memory) {
879         return _name;
880     }
881 
882     /**
883      * @dev See {IERC721Metadata-symbol}.
884      */
885     function symbol() public view virtual override returns (string memory) {
886         return _symbol;
887     }
888 
889     /**
890      * @dev See {IERC721Metadata-tokenURI}.
891      */
892     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
893         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
894 
895         string memory baseURI = _baseURI();
896         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
897     }
898 
899     /**
900      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
901      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
902      * by default, can be overriden in child contracts.
903      */
904     function _baseURI() internal view virtual returns (string memory) {
905         return "";
906     }
907 
908     /**
909      * @dev See {IERC721-approve}.
910      */
911     function approve(address to, uint256 tokenId) public virtual override {
912         address owner = ERC721.ownerOf(tokenId);
913         require(to != owner, "ERC721: approval to current owner");
914 
915         require(
916             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
917             "ERC721: approve caller is not owner nor approved for all"
918         );
919 
920         _approve(to, tokenId);
921     }
922 
923     /**
924      * @dev See {IERC721-getApproved}.
925      */
926     function getApproved(uint256 tokenId) public view virtual override returns (address) {
927         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
928 
929         return _tokenApprovals[tokenId];
930     }
931 
932     /**
933      * @dev See {IERC721-setApprovalForAll}.
934      */
935     function setApprovalForAll(address operator, bool approved) public virtual override {
936         require(operator != _msgSender(), "ERC721: approve to caller");
937 
938         _operatorApprovals[_msgSender()][operator] = approved;
939         emit ApprovalForAll(_msgSender(), operator, approved);
940     }
941 
942     /**
943      * @dev See {IERC721-isApprovedForAll}.
944      */
945     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
946         return _operatorApprovals[owner][operator];
947     }
948 
949     /**
950      * @dev See {IERC721-transferFrom}.
951      */
952     function transferFrom(
953         address from,
954         address to,
955         uint256 tokenId
956     ) public virtual override {
957         //solhint-disable-next-line max-line-length
958         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
959 
960         _transfer(from, to, tokenId);
961     }
962 
963     /**
964      * @dev See {IERC721-safeTransferFrom}.
965      */
966     function safeTransferFrom(
967         address from,
968         address to,
969         uint256 tokenId
970     ) public virtual override {
971         safeTransferFrom(from, to, tokenId, "");
972     }
973 
974     /**
975      * @dev See {IERC721-safeTransferFrom}.
976      */
977     function safeTransferFrom(
978         address from,
979         address to,
980         uint256 tokenId,
981         bytes memory _data
982     ) public virtual override {
983         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
984         _safeTransfer(from, to, tokenId, _data);
985     }
986 
987     /**
988      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
989      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
990      *
991      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
992      *
993      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
994      * implement alternative mechanisms to perform token transfer, such as signature-based.
995      *
996      * Requirements:
997      *
998      * - `from` cannot be the zero address.
999      * - `to` cannot be the zero address.
1000      * - `tokenId` token must exist and be owned by `from`.
1001      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _safeTransfer(
1006         address from,
1007         address to,
1008         uint256 tokenId,
1009         bytes memory _data
1010     ) internal virtual {
1011         _transfer(from, to, tokenId);
1012         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1013     }
1014 
1015     /**
1016      * @dev Returns whether `tokenId` exists.
1017      *
1018      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1019      *
1020      * Tokens start existing when they are minted (`_mint`),
1021      * and stop existing when they are burned (`_burn`).
1022      */
1023     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1024         return _owners[tokenId] != address(0);
1025     }
1026 
1027     /**
1028      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1029      *
1030      * Requirements:
1031      *
1032      * - `tokenId` must exist.
1033      */
1034     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1035         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1036         address owner = ERC721.ownerOf(tokenId);
1037         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1038     }
1039 
1040     /**
1041      * @dev Safely mints `tokenId` and transfers it to `to`.
1042      *
1043      * Requirements:
1044      *
1045      * - `tokenId` must not exist.
1046      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1047      *
1048      * Emits a {Transfer} event.
1049      */
1050     function _safeMint(address to, uint256 tokenId) internal virtual {
1051         _safeMint(to, tokenId, "");
1052     }
1053 
1054     /**
1055      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1056      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1057      */
1058     function _safeMint(
1059         address to,
1060         uint256 tokenId,
1061         bytes memory _data
1062     ) internal virtual {
1063         _mint(to, tokenId);
1064         require(
1065             _checkOnERC721Received(address(0), to, tokenId, _data),
1066             "ERC721: transfer to non ERC721Receiver implementer"
1067         );
1068     }
1069 
1070     /**
1071      * @dev Mints `tokenId` and transfers it to `to`.
1072      *
1073      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1074      *
1075      * Requirements:
1076      *
1077      * - `tokenId` must not exist.
1078      * - `to` cannot be the zero address.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _mint(address to, uint256 tokenId) internal virtual {
1083         require(to != address(0), "ERC721: mint to the zero address");
1084         require(!_exists(tokenId), "ERC721: token already minted");
1085 
1086         _beforeTokenTransfer(address(0), to, tokenId);
1087 
1088         _balances[to] += 1;
1089         _owners[tokenId] = to;
1090 
1091         emit Transfer(address(0), to, tokenId);
1092     }
1093 
1094     /**
1095      * @dev Destroys `tokenId`.
1096      * The approval is cleared when the token is burned.
1097      *
1098      * Requirements:
1099      *
1100      * - `tokenId` must exist.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function _burn(uint256 tokenId) internal virtual {
1105         address owner = ERC721.ownerOf(tokenId);
1106 
1107         _beforeTokenTransfer(owner, address(0), tokenId);
1108 
1109         // Clear approvals
1110         _approve(address(0), tokenId);
1111 
1112         _balances[owner] -= 1;
1113         delete _owners[tokenId];
1114 
1115         emit Transfer(owner, address(0), tokenId);
1116     }
1117 
1118     /**
1119      * @dev Transfers `tokenId` from `from` to `to`.
1120      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1121      *
1122      * Requirements:
1123      *
1124      * - `to` cannot be the zero address.
1125      * - `tokenId` token must be owned by `from`.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129     function _transfer(
1130         address from,
1131         address to,
1132         uint256 tokenId
1133     ) internal virtual {
1134         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1135         require(to != address(0), "ERC721: transfer to the zero address");
1136 
1137         _beforeTokenTransfer(from, to, tokenId);
1138 
1139         // Clear approvals from the previous owner
1140         _approve(address(0), tokenId);
1141 
1142         _balances[from] -= 1;
1143         _balances[to] += 1;
1144         _owners[tokenId] = to;
1145 
1146         emit Transfer(from, to, tokenId);
1147     }
1148 
1149     /**
1150      * @dev Approve `to` to operate on `tokenId`
1151      *
1152      * Emits a {Approval} event.
1153      */
1154     function _approve(address to, uint256 tokenId) internal virtual {
1155         _tokenApprovals[tokenId] = to;
1156         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1157     }
1158 
1159     /**
1160      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1161      * The call is not executed if the target address is not a contract.
1162      *
1163      * @param from address representing the previous owner of the given token ID
1164      * @param to target address that will receive the tokens
1165      * @param tokenId uint256 ID of the token to be transferred
1166      * @param _data bytes optional data to send along with the call
1167      * @return bool whether the call correctly returned the expected magic value
1168      */
1169     function _checkOnERC721Received(
1170         address from,
1171         address to,
1172         uint256 tokenId,
1173         bytes memory _data
1174     ) private returns (bool) {
1175         if (to.isContract()) {
1176             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1177                 return retval == IERC721Receiver(to).onERC721Received.selector;
1178             } catch (bytes memory reason) {
1179                 if (reason.length == 0) {
1180                     revert("ERC721: transfer to non ERC721Receiver implementer");
1181                 } else {
1182                     assembly {
1183                         revert(add(32, reason), mload(reason))
1184                     }
1185                 }
1186             }
1187         } else {
1188             return true;
1189         }
1190     }
1191 
1192     /**
1193      * @dev Hook that is called before any token transfer. This includes minting
1194      * and burning.
1195      *
1196      * Calling conditions:
1197      *
1198      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1199      * transferred to `to`.
1200      * - When `from` is zero, `tokenId` will be minted for `to`.
1201      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1202      * - `from` and `to` are never both zero.
1203      *
1204      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1205      */
1206     function _beforeTokenTransfer(
1207         address from,
1208         address to,
1209         uint256 tokenId
1210     ) internal virtual {}
1211 }
1212 
1213 
1214 // Dependency file: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1215 
1216 
1217 // pragma solidity ^0.8.0;
1218 
1219 // import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
1220 
1221 /**
1222  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1223  * @dev See https://eips.ethereum.org/EIPS/eip-721
1224  */
1225 interface IERC721Enumerable is IERC721 {
1226     /**
1227      * @dev Returns the total amount of tokens stored by the contract.
1228      */
1229     function totalSupply() external view returns (uint256);
1230 
1231     /**
1232      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1233      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1234      */
1235     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1236 
1237     /**
1238      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1239      * Use along with {totalSupply} to enumerate all tokens.
1240      */
1241     function tokenByIndex(uint256 index) external view returns (uint256);
1242 }
1243 
1244 
1245 // Dependency file: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1246 
1247 
1248 // pragma solidity ^0.8.0;
1249 
1250 // import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
1251 // import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
1252 
1253 /**
1254  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1255  * enumerability of all the token ids in the contract as well as all token ids owned by each
1256  * account.
1257  */
1258 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1259     // Mapping from owner to list of owned token IDs
1260     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1261 
1262     // Mapping from token ID to index of the owner tokens list
1263     mapping(uint256 => uint256) private _ownedTokensIndex;
1264 
1265     // Array with all token ids, used for enumeration
1266     uint256[] private _allTokens;
1267 
1268     // Mapping from token id to position in the allTokens array
1269     mapping(uint256 => uint256) private _allTokensIndex;
1270 
1271     /**
1272      * @dev See {IERC165-supportsInterface}.
1273      */
1274     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1275         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1276     }
1277 
1278     /**
1279      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1280      */
1281     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1282         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1283         return _ownedTokens[owner][index];
1284     }
1285 
1286     /**
1287      * @dev See {IERC721Enumerable-totalSupply}.
1288      */
1289     function totalSupply() public view virtual override returns (uint256) {
1290         return _allTokens.length;
1291     }
1292 
1293     /**
1294      * @dev See {IERC721Enumerable-tokenByIndex}.
1295      */
1296     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1297         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1298         return _allTokens[index];
1299     }
1300 
1301     /**
1302      * @dev Hook that is called before any token transfer. This includes minting
1303      * and burning.
1304      *
1305      * Calling conditions:
1306      *
1307      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1308      * transferred to `to`.
1309      * - When `from` is zero, `tokenId` will be minted for `to`.
1310      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1311      * - `from` cannot be the zero address.
1312      * - `to` cannot be the zero address.
1313      *
1314      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1315      */
1316     function _beforeTokenTransfer(
1317         address from,
1318         address to,
1319         uint256 tokenId
1320     ) internal virtual override {
1321         super._beforeTokenTransfer(from, to, tokenId);
1322 
1323         if (from == address(0)) {
1324             _addTokenToAllTokensEnumeration(tokenId);
1325         } else if (from != to) {
1326             _removeTokenFromOwnerEnumeration(from, tokenId);
1327         }
1328         if (to == address(0)) {
1329             _removeTokenFromAllTokensEnumeration(tokenId);
1330         } else if (to != from) {
1331             _addTokenToOwnerEnumeration(to, tokenId);
1332         }
1333     }
1334 
1335     /**
1336      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1337      * @param to address representing the new owner of the given token ID
1338      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1339      */
1340     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1341         uint256 length = ERC721.balanceOf(to);
1342         _ownedTokens[to][length] = tokenId;
1343         _ownedTokensIndex[tokenId] = length;
1344     }
1345 
1346     /**
1347      * @dev Private function to add a token to this extension's token tracking data structures.
1348      * @param tokenId uint256 ID of the token to be added to the tokens list
1349      */
1350     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1351         _allTokensIndex[tokenId] = _allTokens.length;
1352         _allTokens.push(tokenId);
1353     }
1354 
1355     /**
1356      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1357      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1358      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1359      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1360      * @param from address representing the previous owner of the given token ID
1361      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1362      */
1363     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1364         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1365         // then delete the last slot (swap and pop).
1366 
1367         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1368         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1369 
1370         // When the token to delete is the last token, the swap operation is unnecessary
1371         if (tokenIndex != lastTokenIndex) {
1372             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1373 
1374             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1375             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1376         }
1377 
1378         // This also deletes the contents at the last position of the array
1379         delete _ownedTokensIndex[tokenId];
1380         delete _ownedTokens[from][lastTokenIndex];
1381     }
1382 
1383     /**
1384      * @dev Private function to remove a token from this extension's token tracking data structures.
1385      * This has O(1) time complexity, but alters the order of the _allTokens array.
1386      * @param tokenId uint256 ID of the token to be removed from the tokens list
1387      */
1388     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1389         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1390         // then delete the last slot (swap and pop).
1391 
1392         uint256 lastTokenIndex = _allTokens.length - 1;
1393         uint256 tokenIndex = _allTokensIndex[tokenId];
1394 
1395         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1396         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1397         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1398         uint256 lastTokenId = _allTokens[lastTokenIndex];
1399 
1400         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1401         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1402 
1403         // This also deletes the contents at the last position of the array
1404         delete _allTokensIndex[tokenId];
1405         _allTokens.pop();
1406     }
1407 }
1408 
1409 
1410 // Dependency file: contracts/interfaces/ICollectible.sol
1411 
1412 
1413 // pragma solidity >=0.8.0 <1.0.0;
1414 
1415 
1416 interface ICollectible is IERC721Enumerable {
1417     function mint(address to, uint256 amount) external;
1418     function createdAt(uint256 _tokenId) external view returns (uint256 timestamp);
1419     function createdAtBlock(uint256 _tokenId) external view returns (uint256 blockNumber);
1420 }
1421 
1422 // Dependency file: contracts/interfaces/ICowRegistry.sol
1423 
1424 
1425 // pragma solidity >=0.8.0 <1.0.0;
1426 
1427 interface ICowsRegistry {
1428 
1429     enum Gender {
1430         MALE,
1431         FEMALE
1432     }
1433 
1434     struct Cow {
1435         Gender gender;
1436         uint power;
1437         uint rarity;
1438     }
1439 
1440     function store(uint256 _cowId, Cow memory _data) external;
1441 
1442     function update(uint256 _cowId, Cow memory _data) external;
1443 
1444     function data(uint256 _cowId) external view returns (Cow memory _data);
1445 }
1446 
1447 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
1448 
1449 
1450 // pragma solidity ^0.8.0;
1451 
1452 // import "@openzeppelin/contracts/utils/Context.sol";
1453 
1454 /**
1455  * @dev Contract module which provides a basic access control mechanism, where
1456  * there is an account (an owner) that can be granted exclusive access to
1457  * specific functions.
1458  *
1459  * By default, the owner account will be the one that deploys the contract. This
1460  * can later be changed with {transferOwnership}.
1461  *
1462  * This module is used through inheritance. It will make available the modifier
1463  * `onlyOwner`, which can be applied to your functions to restrict their use to
1464  * the owner.
1465  */
1466 abstract contract Ownable is Context {
1467     address private _owner;
1468 
1469     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1470 
1471     /**
1472      * @dev Initializes the contract setting the deployer as the initial owner.
1473      */
1474     constructor() {
1475         _setOwner(_msgSender());
1476     }
1477 
1478     /**
1479      * @dev Returns the address of the current owner.
1480      */
1481     function owner() public view virtual returns (address) {
1482         return _owner;
1483     }
1484 
1485     /**
1486      * @dev Throws if called by any account other than the owner.
1487      */
1488     modifier onlyOwner() {
1489         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1490         _;
1491     }
1492 
1493     /**
1494      * @dev Leaves the contract without owner. It will not be possible to call
1495      * `onlyOwner` functions anymore. Can only be called by the current owner.
1496      *
1497      * NOTE: Renouncing ownership will leave the contract without an owner,
1498      * thereby removing any functionality that is only available to the owner.
1499      */
1500     function renounceOwnership() public virtual onlyOwner {
1501         _setOwner(address(0));
1502     }
1503 
1504     /**
1505      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1506      * Can only be called by the current owner.
1507      */
1508     function transferOwnership(address newOwner) public virtual onlyOwner {
1509         require(newOwner != address(0), "Ownable: new owner is the zero address");
1510         _setOwner(newOwner);
1511     }
1512 
1513     function _setOwner(address newOwner) private {
1514         address oldOwner = _owner;
1515         _owner = newOwner;
1516         emit OwnershipTransferred(oldOwner, newOwner);
1517     }
1518 }
1519 
1520 
1521 // Dependency file: contracts/access/Whitelist.sol
1522 
1523 
1524 // pragma solidity >=0.8.0 <1.0.0;
1525 
1526 // import "@openzeppelin/contracts/access/Ownable.sol";
1527 
1528 abstract contract Whitelist is Ownable {
1529     event MemberAdded(address member);
1530     event MemberRemoved(address member);
1531 
1532     mapping(address => bool) private members;
1533 
1534     /**
1535      * @dev A method to verify whether an address is a member of the whitelist
1536      * @param _member The address to verify.
1537      * @return Whether the address is a member of the whitelist.
1538      */
1539     function isMember(address _member) public view returns (bool) {
1540         return members[_member];
1541     }
1542 
1543     /**
1544      * @dev A method to add a member to the whitelist
1545      * @param _member The member to add as a member.
1546      */
1547     function addMember(address _member) external onlyOwner {
1548         require(!isMember(_member), "Whitelist: Address is member already");
1549 
1550         members[_member] = true;
1551         emit MemberAdded(_member);
1552     }
1553 
1554     /**
1555      * @dev A method to add a member to the whitelist
1556      * @param _members The members to add as a member.
1557      */
1558     function addMembers(address[] calldata _members) external onlyOwner {
1559         _addMembers(_members);
1560     }
1561 
1562     /**
1563      * @dev A method to remove a member from the whitelist
1564      * @param _member The member to remove as a member.
1565      */
1566     function removeMember(address _member) external onlyOwner {
1567         require(isMember(_member), "Whitelist: Not member of whitelist");
1568 
1569         delete members[_member];
1570         emit MemberRemoved(_member);
1571     }
1572 
1573     /**
1574      * @dev A method to remove a members from the whitelist
1575      * @param _members The members to remove as a member.
1576      */
1577     function removeMembers(address[] calldata _members) external onlyOwner {
1578         _removeMembers(_members);
1579     }
1580 
1581     function _addMembers(address[] memory _members) internal {
1582         uint256 l = _members.length;
1583         uint256 i;
1584         for (i; i < l; i++) {
1585             require(
1586                 !isMember(_members[i]),
1587                 "Whitelist: Address is member already"
1588             );
1589 
1590             members[_members[i]] = true;
1591             emit MemberAdded(_members[i]);
1592         }
1593     }
1594 
1595     function _removeMembers(address[] memory _members) internal {
1596         uint256 l = _members.length;
1597         uint256 i;
1598         for (i; i < l; i++) {
1599             require(
1600                 isMember(_members[i]),
1601                 "Whitelist: Address is no member"
1602             );
1603 
1604             delete members[_members[i]];
1605             emit MemberRemoved(_members[i]);
1606         }
1607     }
1608 }
1609 
1610 // Root file: contracts/CowMarket.sol
1611 
1612 
1613 pragma solidity >=0.8.0 <1.0.0;
1614 
1615 // import "contracts/interfaces/ICollectible.sol";
1616 // import "contracts/interfaces/ICowRegistry.sol";
1617 // import "contracts/access/Whitelist.sol";
1618 
1619 contract CowMarket is Whitelist {
1620     using SafeMath for uint256;
1621 
1622     enum SaleStatus {
1623         DISABLED,
1624         WHITELIST,
1625         GENERAL
1626     }
1627 
1628     uint256 public tokenPrice = 80000000000000000; // 0.08 ETH
1629     uint256 public maxTokenPurchase = 5;
1630     uint256 public constant maxTokens = 3333;
1631 
1632     address public fund;
1633     SaleStatus public saleStatus;
1634 
1635     ICollectible public cows;
1636 
1637     event TokenPriceChanged(uint256 price);
1638     event MaxPurchaseChanged(uint256 value);
1639     event FundSet(address bankAccount);
1640     event RolledOver(SaleStatus status);
1641 
1642     constructor(ICollectible _cows, address _fund) {
1643         require(
1644             address(_cows) != address(0) &&
1645             _fund != address(0),
1646             "Unacceptable address set"
1647         );
1648 
1649         cows = _cows;
1650         fund = _fund;
1651     }
1652 
1653     receive() external payable {
1654         uint256 deposit = msg.value;
1655         uint256 amount = deposit.div(tokenPrice);
1656 
1657         require(
1658             SaleStatus.DISABLED != saleStatus,
1659             "Collection: sale is not active"
1660         );
1661         
1662         if (SaleStatus.WHITELIST == saleStatus) {
1663             require(isMember(_msgSender()), "Whitelist: not in the list");
1664         }
1665  
1666         require(
1667             amount <= maxTokenPurchase,
1668             "Collection: exceeds max number of Tokens in one transaction"
1669         );
1670         require(
1671             cows.totalSupply().add(amount) <= maxTokens,
1672             "Collection: purchase would exceed max supply of Tokens"
1673         );
1674         require(tokenPrice.mul(amount) == deposit,
1675             "Collection: ether value sent is not correct"
1676         );
1677 
1678         if (fund != address(this)) {
1679             Address.sendValue(payable(fund), deposit);
1680         }
1681 
1682         cows.mint(msg.sender, amount);
1683     }
1684 
1685     function buy(uint _amount) external payable {
1686         require(SaleStatus.DISABLED != saleStatus, "Collection: sale is not active");
1687 
1688         if (SaleStatus.WHITELIST == saleStatus) {
1689             require(isMember(_msgSender()), "Whitelist: not in the list");
1690         }
1691 
1692         require(
1693             _amount <= maxTokenPurchase,
1694             "Collection: exceeds max number of Tokens in one transaction"
1695         );
1696         require(
1697             cows.totalSupply().add(_amount) <= maxTokens,
1698             "Collection: purchase would exceed max supply of Tokens"
1699         );
1700 
1701         uint256 deposit = msg.value;
1702 
1703         require(tokenPrice.mul(_amount) == deposit,
1704             "Collection: ether value sent is not correct"
1705         );
1706 
1707         if (fund != address(this)) {
1708             Address.sendValue(payable(fund), deposit);
1709         }
1710 
1711         cows.mint(msg.sender, _amount);
1712     }
1713 
1714     // @dev Changes sale status.
1715     // Permission: only owner
1716     function setSaleStatus(SaleStatus _status) public onlyOwner {
1717         saleStatus = _status;
1718         emit RolledOver(_status);
1719     }
1720 
1721 
1722     // @dev Setup new token sale price.
1723     // Permission: only owner
1724     function setPrice(uint256 _price) external onlyOwner {
1725         require(_price != 0, "Zero price");
1726 
1727         tokenPrice = _price;
1728         emit TokenPriceChanged(_price);
1729     }
1730 
1731     // @dev Setup max tokens purchase per transaction.
1732     // Permission: only owner
1733     function setMaxPurchase(uint256 _value) external onlyOwner {
1734         require(_value != 0, "Very low value");
1735 
1736         maxTokenPurchase = _value;
1737         emit MaxPurchaseChanged(_value);
1738     }
1739 
1740     // @dev Setup new bank account.
1741     // Permission: only owner
1742     function setFund(address _account) external onlyOwner {
1743         require(_account != address(0), "Zero address set");
1744 
1745         fund = _account;
1746         emit FundSet(_account);
1747     }
1748 
1749     // @dev Withdraw ethereum from contract balance.
1750     // Permission: only owner
1751     function withdraw() public onlyOwner {
1752         uint balance = address(this).balance;
1753         Address.sendValue(payable(_msgSender()), balance);
1754     }
1755 }