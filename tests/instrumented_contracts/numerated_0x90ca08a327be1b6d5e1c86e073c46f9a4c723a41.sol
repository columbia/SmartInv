1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-29
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 // CAUTION
10 // This version of SafeMath should only be used with Solidity 0.8 or later,
11 // because it relies on the compiler's built in overflow checks.
12 
13 /**
14  * @dev Wrappers over Solidity's arithmetic operations.
15  *
16  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
17  * now has built in overflow checking.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, with an overflow flag.
22      *
23      * _Available since v3.4._
24      */
25     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {
27             uint256 c = a + b;
28             if (c < a) return (false, 0);
29             return (true, c);
30         }
31     }
32 
33     /**
34      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
35      *
36      * _Available since v3.4._
37      */
38     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {
40             if (b > a) return (false, 0);
41             return (true, a - b);
42         }
43     }
44 
45     /**
46      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
47      *
48      * _Available since v3.4._
49      */
50     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53             // benefit is lost if 'b' is also tested.
54             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
55             if (a == 0) return (true, 0);
56             uint256 c = a * b;
57             if (c / a != b) return (false, 0);
58             return (true, c);
59         }
60     }
61 
62     /**
63      * @dev Returns the division of two unsigned integers, with a division by zero flag.
64      *
65      * _Available since v3.4._
66      */
67     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         unchecked {
69             if (b == 0) return (false, 0);
70             return (true, a / b);
71         }
72     }
73 
74     /**
75      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a % b);
83         }
84     }
85 
86     /**
87      * @dev Returns the addition of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `+` operator.
91      *
92      * Requirements:
93      *
94      * - Addition cannot overflow.
95      */
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         return a + b;
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      *
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a - b;
112     }
113 
114     /**
115      * @dev Returns the multiplication of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `*` operator.
119      *
120      * Requirements:
121      *
122      * - Multiplication cannot overflow.
123      */
124     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125         return a * b;
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers, reverting on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's `/` operator.
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         return a % b;
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * CAUTION: This function is deprecated because it requires allocating memory for the error
163      * message unnecessarily. For custom revert reasons use {trySub}.
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(
172         uint256 a,
173         uint256 b,
174         string memory errorMessage
175     ) internal pure returns (uint256) {
176         unchecked {
177             require(b <= a, errorMessage);
178             return a - b;
179         }
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(
195         uint256 a,
196         uint256 b,
197         string memory errorMessage
198     ) internal pure returns (uint256) {
199         unchecked {
200             require(b > 0, errorMessage);
201             return a / b;
202         }
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * reverting with custom message when dividing by zero.
208      *
209      * CAUTION: This function is deprecated because it requires allocating memory for the error
210      * message unnecessarily. For custom revert reasons use {tryMod}.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(
221         uint256 a,
222         uint256 b,
223         string memory errorMessage
224     ) internal pure returns (uint256) {
225         unchecked {
226             require(b > 0, errorMessage);
227             return a % b;
228         }
229     }
230 }
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev String operations.
236  */
237 library Strings {
238     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
239 
240     /**
241      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
242      */
243     function toString(uint256 value) internal pure returns (string memory) {
244         // Inspired by OraclizeAPI's implementation - MIT licence
245         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
246 
247         if (value == 0) {
248             return "0";
249         }
250         uint256 temp = value;
251         uint256 digits;
252         while (temp != 0) {
253             digits++;
254             temp /= 10;
255         }
256         bytes memory buffer = new bytes(digits);
257         while (value != 0) {
258             digits -= 1;
259             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
260             value /= 10;
261         }
262         return string(buffer);
263     }
264 
265     /**
266      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
267      */
268     function toHexString(uint256 value) internal pure returns (string memory) {
269         if (value == 0) {
270             return "0x00";
271         }
272         uint256 temp = value;
273         uint256 length = 0;
274         while (temp != 0) {
275             length++;
276             temp >>= 8;
277         }
278         return toHexString(value, length);
279     }
280 
281     /**
282      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
283      */
284     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
285         bytes memory buffer = new bytes(2 * length + 2);
286         buffer[0] = "0";
287         buffer[1] = "x";
288         for (uint256 i = 2 * length + 1; i > 1; --i) {
289             buffer[i] = _HEX_SYMBOLS[value & 0xf];
290             value >>= 4;
291         }
292         require(value == 0, "Strings: hex length insufficient");
293         return string(buffer);
294     }
295 }
296 
297 pragma solidity ^0.8.0;
298 
299 /**
300  * @dev Collection of functions related to the address type
301  */
302 library Address {
303     /**
304      * @dev Returns true if `account` is a contract.
305      *
306      * [IMPORTANT]
307      * ====
308      * It is unsafe to assume that an address for which this function returns
309      * false is an externally-owned account (EOA) and not a contract.
310      *
311      * Among others, `isContract` will return false for the following
312      * types of addresses:
313      *
314      *  - an externally-owned account
315      *  - a contract in construction
316      *  - an address where a contract will be created
317      *  - an address where a contract lived, but was destroyed
318      * ====
319      */
320     function isContract(address account) internal view returns (bool) {
321         // This method relies on extcodesize, which returns 0 for contracts in
322         // construction, since the code is only stored at the end of the
323         // constructor execution.
324 
325         uint256 size;
326         assembly {
327             size := extcodesize(account)
328         }
329         return size > 0;
330     }
331 
332     /**
333      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
334      * `recipient`, forwarding all available gas and reverting on errors.
335      *
336      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
337      * of certain opcodes, possibly making contracts go over the 2300 gas limit
338      * imposed by `transfer`, making them unable to receive funds via
339      * `transfer`. {sendValue} removes this limitation.
340      *
341      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
342      *
343      * IMPORTANT: because control is transferred to `recipient`, care must be
344      * taken to not create reentrancy vulnerabilities. Consider using
345      * {ReentrancyGuard} or the
346      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
347      */
348     function sendValue(address payable recipient, uint256 amount) internal {
349         require(address(this).balance >= amount, "Address: insufficient balance");
350 
351         (bool success, ) = recipient.call{value: amount}("");
352         require(success, "Address: unable to send value, recipient may have reverted");
353     }
354 
355     /**
356      * @dev Performs a Solidity function call using a low level `call`. A
357      * plain `call` is an unsafe replacement for a function call: use this
358      * function instead.
359      *
360      * If `target` reverts with a revert reason, it is bubbled up by this
361      * function (like regular Solidity function calls).
362      *
363      * Returns the raw returned data. To convert to the expected return value,
364      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
365      *
366      * Requirements:
367      *
368      * - `target` must be a contract.
369      * - calling `target` with `data` must not revert.
370      *
371      * _Available since v3.1._
372      */
373     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
374         return functionCall(target, data, "Address: low-level call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
379      * `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCall(
384         address target,
385         bytes memory data,
386         string memory errorMessage
387     ) internal returns (bytes memory) {
388         return functionCallWithValue(target, data, 0, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but also transferring `value` wei to `target`.
394      *
395      * Requirements:
396      *
397      * - the calling contract must have an ETH balance of at least `value`.
398      * - the called Solidity function must be `payable`.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(
403         address target,
404         bytes memory data,
405         uint256 value
406     ) internal returns (bytes memory) {
407         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
412      * with `errorMessage` as a fallback revert reason when `target` reverts.
413      *
414      * _Available since v3.1._
415      */
416     function functionCallWithValue(
417         address target,
418         bytes memory data,
419         uint256 value,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         require(address(this).balance >= value, "Address: insufficient balance for call");
423         require(isContract(target), "Address: call to non-contract");
424 
425         (bool success, bytes memory returndata) = target.call{value: value}(data);
426         return _verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but performing a static call.
432      *
433      * _Available since v3.3._
434      */
435     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
436         return functionStaticCall(target, data, "Address: low-level static call failed");
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
441      * but performing a static call.
442      *
443      * _Available since v3.3._
444      */
445     function functionStaticCall(
446         address target,
447         bytes memory data,
448         string memory errorMessage
449     ) internal view returns (bytes memory) {
450         require(isContract(target), "Address: static call to non-contract");
451 
452         (bool success, bytes memory returndata) = target.staticcall(data);
453         return _verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
458      * but performing a delegate call.
459      *
460      * _Available since v3.4._
461      */
462     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
463         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
468      * but performing a delegate call.
469      *
470      * _Available since v3.4._
471      */
472     function functionDelegateCall(
473         address target,
474         bytes memory data,
475         string memory errorMessage
476     ) internal returns (bytes memory) {
477         require(isContract(target), "Address: delegate call to non-contract");
478 
479         (bool success, bytes memory returndata) = target.delegatecall(data);
480         return _verifyCallResult(success, returndata, errorMessage);
481     }
482 
483     function _verifyCallResult(
484         bool success,
485         bytes memory returndata,
486         string memory errorMessage
487     ) private pure returns (bytes memory) {
488         if (success) {
489             return returndata;
490         } else {
491             // Look for revert reason and bubble it up if present
492             if (returndata.length > 0) {
493                 // The easiest way to bubble the revert reason is using memory via assembly
494 
495                 assembly {
496                     let returndata_size := mload(returndata)
497                     revert(add(32, returndata), returndata_size)
498                 }
499             } else {
500                 revert(errorMessage);
501             }
502         }
503     }
504 }
505 
506 pragma solidity ^0.8.0;
507 
508 /**
509  * @title ERC721 token receiver interface
510  * @dev Interface for any contract that wants to support safeTransfers
511  * from ERC721 asset contracts.
512  */
513 interface IERC721Receiver {
514     /**
515      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
516      * by `operator` from `from`, this function is called.
517      *
518      * It must return its Solidity selector to confirm the token transfer.
519      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
520      *
521      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
522      */
523     function onERC721Received(
524         address operator,
525         address from,
526         uint256 tokenId,
527         bytes calldata data
528     ) external returns (bytes4);
529 }
530 
531 pragma solidity ^0.8.0;
532 
533 /**
534  * @dev Interface of the ERC165 standard, as defined in the
535  * https://eips.ethereum.org/EIPS/eip-165[EIP].
536  *
537  * Implementers can declare support of contract interfaces, which can then be
538  * queried by others ({ERC165Checker}).
539  *
540  * For an implementation, see {ERC165}.
541  */
542 interface IERC165 {
543     /**
544      * @dev Returns true if this contract implements the interface defined by
545      * `interfaceId`. See the corresponding
546      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
547      * to learn more about how these ids are created.
548      *
549      * This function call must use less than 30 000 gas.
550      */
551     function supportsInterface(bytes4 interfaceId) external view returns (bool);
552 }
553 
554 pragma solidity ^0.8.0;
555 
556 /**
557  * @dev Implementation of the {IERC165} interface.
558  *
559  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
560  * for the additional interface id that will be supported. For example:
561  *
562  * ```solidity
563  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
565  * }
566  * ```
567  *
568  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
569  */
570 abstract contract ERC165 is IERC165 {
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
575         return interfaceId == type(IERC165).interfaceId;
576     }
577 }
578 
579 pragma solidity ^0.8.0;
580 
581 /**
582  * @dev Required interface of an ERC721 compliant contract.
583  */
584 interface IERC721 is IERC165 {
585     /**
586      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
587      */
588     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
589 
590     /**
591      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
592      */
593     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
594 
595     /**
596      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
597      */
598     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
599 
600     /**
601      * @dev Returns the number of tokens in ``owner``'s account.
602      */
603     function balanceOf(address owner) external view returns (uint256 balance);
604 
605     /**
606      * @dev Returns the owner of the `tokenId` token.
607      *
608      * Requirements:
609      *
610      * - `tokenId` must exist.
611      */
612     function ownerOf(uint256 tokenId) external view returns (address owner);
613 
614     /**
615      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
616      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must exist and be owned by `from`.
623      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
624      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
625      *
626      * Emits a {Transfer} event.
627      */
628     function safeTransferFrom(
629         address from,
630         address to,
631         uint256 tokenId
632     ) external;
633 
634     /**
635      * @dev Transfers `tokenId` token from `from` to `to`.
636      *
637      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
638      *
639      * Requirements:
640      *
641      * - `from` cannot be the zero address.
642      * - `to` cannot be the zero address.
643      * - `tokenId` token must be owned by `from`.
644      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
645      *
646      * Emits a {Transfer} event.
647      */
648     function transferFrom(
649         address from,
650         address to,
651         uint256 tokenId
652     ) external;
653 
654     /**
655      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
656      * The approval is cleared when the token is transferred.
657      *
658      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
659      *
660      * Requirements:
661      *
662      * - The caller must own the token or be an approved operator.
663      * - `tokenId` must exist.
664      *
665      * Emits an {Approval} event.
666      */
667     function approve(address to, uint256 tokenId) external;
668 
669     /**
670      * @dev Returns the account approved for `tokenId` token.
671      *
672      * Requirements:
673      *
674      * - `tokenId` must exist.
675      */
676     function getApproved(uint256 tokenId) external view returns (address operator);
677 
678     /**
679      * @dev Approve or remove `operator` as an operator for the caller.
680      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
681      *
682      * Requirements:
683      *
684      * - The `operator` cannot be the caller.
685      *
686      * Emits an {ApprovalForAll} event.
687      */
688     function setApprovalForAll(address operator, bool _approved) external;
689 
690     /**
691      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
692      *
693      * See {setApprovalForAll}
694      */
695     function isApprovedForAll(address owner, address operator) external view returns (bool);
696 
697     /**
698      * @dev Safely transfers `tokenId` token from `from` to `to`.
699      *
700      * Requirements:
701      *
702      * - `from` cannot be the zero address.
703      * - `to` cannot be the zero address.
704      * - `tokenId` token must exist and be owned by `from`.
705      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
706      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
707      *
708      * Emits a {Transfer} event.
709      */
710     function safeTransferFrom(
711         address from,
712         address to,
713         uint256 tokenId,
714         bytes calldata data
715     ) external;
716 }
717 
718 pragma solidity ^0.8.0;
719 
720 /**
721  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
722  * @dev See https://eips.ethereum.org/EIPS/eip-721
723  */
724 interface IERC721Enumerable is IERC721 {
725     /**
726      * @dev Returns the total amount of tokens stored by the contract.
727      */
728     function totalSupply() external view returns (uint256);
729 
730     /**
731      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
732      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
733      */
734     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
735 
736     /**
737      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
738      * Use along with {totalSupply} to enumerate all tokens.
739      */
740     function tokenByIndex(uint256 index) external view returns (uint256);
741 }
742 
743 pragma solidity ^0.8.0;
744 
745 /**
746  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
747  * @dev See https://eips.ethereum.org/EIPS/eip-721
748  */
749 interface IERC721Metadata is IERC721 {
750     /**
751      * @dev Returns the token collection name.
752      */
753     function name() external view returns (string memory);
754 
755     /**
756      * @dev Returns the token collection symbol.
757      */
758     function symbol() external view returns (string memory);
759 
760     /**
761      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
762      */
763     function tokenURI(uint256 tokenId) external view returns (string memory);
764 }
765 
766 pragma solidity ^0.8.0;
767 
768 /*
769  * @dev Provides information about the current execution context, including the
770  * sender of the transaction and its data. While these are generally available
771  * via msg.sender and msg.data, they should not be accessed in such a direct
772  * manner, since when dealing with meta-transactions the account sending and
773  * paying for execution may not be the actual sender (as far as an application
774  * is concerned).
775  *
776  * This contract is only required for intermediate, library-like contracts.
777  */
778 abstract contract Context {
779     function _msgSender() internal view virtual returns (address) {
780         return msg.sender;
781     }
782 
783     function _msgData() internal view virtual returns (bytes calldata) {
784         return msg.data;
785     }
786 }
787 
788 pragma solidity ^0.8.0;
789 
790 /**
791  * @dev Contract module which provides a basic access control mechanism, where
792  * there is an account (an owner) that can be granted exclusive access to
793  * specific functions.
794  *
795  * By default, the owner account will be the one that deploys the contract. This
796  * can later be changed with {transferOwnership}.
797  *
798  * This module is used through inheritance. It will make available the modifier
799  * `onlyOwner`, which can be applied to your functions to restrict their use to
800  * the owner.
801  */
802 abstract contract Ownable is Context {
803     address private _owner;
804 
805     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
806 
807     /**
808      * @dev Initializes the contract setting the deployer as the initial owner.
809      */
810     constructor () {
811         address msgSender = _msgSender();
812         _owner = msgSender;
813         emit OwnershipTransferred(address(0), msgSender);
814     }
815 
816     /**
817      * @dev Returns the address of the current owner.
818      */
819     function owner() public view virtual returns (address) {
820         return _owner;
821     }
822 
823     /**
824      * @dev Throws if called by any account other than the owner.
825      */
826     modifier onlyOwner() {
827         require(owner() == _msgSender(), "Ownable: caller is not the owner");
828         _;
829     }
830 
831     /**
832      * @dev Leaves the contract without owner. It will not be possible to call
833      * `onlyOwner` functions anymore. Can only be called by the current owner.
834      *
835      * NOTE: Renouncing ownership will leave the contract without an owner,
836      * thereby removing any functionality that is only available to the owner.
837      */
838 
839     /**
840      * @dev Transfers ownership of the contract to a new account (`newOwner`).
841      * Can only be called by the current owner.
842      */
843     function transferOwnership(address newOwner) public virtual onlyOwner {
844         require(newOwner != address(0), "Ownable: new owner is the zero address");
845         _setOwner(newOwner);
846     }
847 
848     function _setOwner(address newOwner) private {
849         address oldOwner = _owner;
850         _owner = newOwner;
851         emit OwnershipTransferred(oldOwner, newOwner);
852     }
853 }
854 
855 pragma solidity ^0.8.0;
856 
857 /**
858  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
859  * the Metadata extension, but not including the Enumerable extension, which is available separately as
860  * {ERC721Enumerable}.
861  */
862 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
863     using Address for address;
864     using Strings for uint256;
865 
866     // Token name
867     string private _name;
868 
869     // Token symbol
870     string private _symbol;
871 
872     // Mapping from token ID to owner address
873     mapping(uint256 => address) private _owners;
874 
875     // Mapping owner address to token count
876     mapping(address => uint256) private _balances;
877 
878     // Mapping from token ID to approved address
879     mapping(uint256 => address) private _tokenApprovals;
880 
881     // Mapping from owner to operator approvals
882     mapping(address => mapping(address => bool)) private _operatorApprovals;
883 
884 
885     string public _baseURI;
886     /**
887      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
888      */
889     constructor(string memory name_, string memory symbol_) {
890         _name = name_;
891         _symbol = symbol_;
892     }
893 
894     /**
895      * @dev See {IERC165-supportsInterface}.
896      */
897     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
898         return
899             interfaceId == type(IERC721).interfaceId ||
900             interfaceId == type(IERC721Metadata).interfaceId ||
901             super.supportsInterface(interfaceId);
902     }
903 
904     /**
905      * @dev See {IERC721-balanceOf}.
906      */
907     function balanceOf(address owner) public view virtual override returns (uint256) {
908         require(owner != address(0), "ERC721: balance query for the zero address");
909         return _balances[owner];
910     }
911 
912     /**
913      * @dev See {IERC721-ownerOf}.
914      */
915     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
916         address owner = _owners[tokenId];
917         require(owner != address(0), "ERC721: owner query for nonexistent token");
918         return owner;
919     }
920 
921     /**
922      * @dev See {IERC721Metadata-name}.
923      */
924     function name() public view virtual override returns (string memory) {
925         return _name;
926     }
927 
928     /**
929      * @dev See {IERC721Metadata-symbol}.
930      */
931     function symbol() public view virtual override returns (string memory) {
932         return _symbol;
933     }
934 
935     /**
936      * @dev See {IERC721Metadata-tokenURI}.
937      */
938     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
939         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
940 
941         string memory base = baseURI();
942         return bytes(base).length > 0 ? string(abi.encodePacked(base, tokenId.toString())) : "";
943     }
944 
945     /**
946      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
947      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
948      * by default, can be overriden in child contracts.
949      */
950     function baseURI() internal view virtual returns (string memory) {
951         return _baseURI;
952     }
953 
954     /**
955      * @dev See {IERC721-approve}.
956      */
957     function approve(address to, uint256 tokenId) public virtual override {
958         address owner = ERC721.ownerOf(tokenId);
959         require(to != owner, "ERC721: approval to current owner");
960 
961         require(
962             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
963             "ERC721: approve caller is not owner nor approved for all"
964         );
965 
966         _approve(to, tokenId);
967     }
968 
969     /**
970      * @dev See {IERC721-getApproved}.
971      */
972     function getApproved(uint256 tokenId) public view virtual override returns (address) {
973         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
974 
975         return _tokenApprovals[tokenId];
976     }
977 
978     /**
979      * @dev See {IERC721-setApprovalForAll}.
980      */
981     function setApprovalForAll(address operator, bool approved) public virtual override {
982         require(operator != _msgSender(), "ERC721: approve to caller");
983 
984         _operatorApprovals[_msgSender()][operator] = approved;
985         emit ApprovalForAll(_msgSender(), operator, approved);
986     }
987 
988     /**
989      * @dev See {IERC721-isApprovedForAll}.
990      */
991     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
992         return _operatorApprovals[owner][operator];
993     }
994 
995     /**
996      * @dev See {IERC721-transferFrom}.
997      */
998     function transferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) public virtual override {
1003         //solhint-disable-next-line max-line-length
1004         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1005 
1006         _transfer(from, to, tokenId);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-safeTransferFrom}.
1011      */
1012     function safeTransferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) public virtual override {
1017         safeTransferFrom(from, to, tokenId, "");
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-safeTransferFrom}.
1022      */
1023     function safeTransferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId,
1027         bytes memory _data
1028     ) public virtual override {
1029         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1030         _safeTransfer(from, to, tokenId, _data);
1031     }
1032 
1033     /**
1034      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1035      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1036      *
1037      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1038      *
1039      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1040      * implement alternative mechanisms to perform token transfer, such as signature-based.
1041      *
1042      * Requirements:
1043      *
1044      * - `from` cannot be the zero address.
1045      * - `to` cannot be the zero address.
1046      * - `tokenId` token must exist and be owned by `from`.
1047      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _safeTransfer(
1052         address from,
1053         address to,
1054         uint256 tokenId,
1055         bytes memory _data
1056     ) internal virtual {
1057         _transfer(from, to, tokenId);
1058         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1059     }
1060 
1061     /**
1062      * @dev Returns whether `tokenId` exists.
1063      *
1064      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1065      *
1066      * Tokens start existing when they are minted (`_mint`),
1067      * and stop existing when they are burned (`_burn`).
1068      */
1069     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1070         return _owners[tokenId] != address(0);
1071     }
1072 
1073     /**
1074      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1075      *
1076      * Requirements:
1077      *
1078      * - `tokenId` must exist.
1079      */
1080     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1081         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1082         address owner = ERC721.ownerOf(tokenId);
1083         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1084     }
1085 
1086     /**
1087      * @dev Safely mints `tokenId` and transfers it to `to`.
1088      *
1089      * Requirements:
1090      *
1091      * - `tokenId` must not exist.
1092      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function _safeMint(address to, uint256 tokenId) internal virtual {
1097         _safeMint(to, tokenId, "");
1098     }
1099 
1100     /**
1101      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1102      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1103      */
1104     function _safeMint(
1105         address to,
1106         uint256 tokenId,
1107         bytes memory _data
1108     ) internal virtual {
1109         _mint(to, tokenId);
1110         require(
1111             _checkOnERC721Received(address(0), to, tokenId, _data),
1112             "ERC721: transfer to non ERC721Receiver implementer"
1113         );
1114     }
1115 
1116     /**
1117      * @dev Mints `tokenId` and transfers it to `to`.
1118      *
1119      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1120      *
1121      * Requirements:
1122      *
1123      * - `tokenId` must not exist.
1124      * - `to` cannot be the zero address.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function _mint(address to, uint256 tokenId) internal virtual {
1129         require(to != address(0), "ERC721: mint to the zero address");
1130         require(!_exists(tokenId), "ERC721: token already minted");
1131 
1132         _beforeTokenTransfer(address(0), to, tokenId);
1133 
1134         _balances[to] += 1;
1135         _owners[tokenId] = to;
1136 
1137         emit Transfer(address(0), to, tokenId);
1138     }
1139 
1140     /**
1141      * @dev Destroys `tokenId`.
1142      * The approval is cleared when the token is burned.
1143      *
1144      * Requirements:
1145      *
1146      * - `tokenId` must exist.
1147      *
1148      * Emits a {Transfer} event.
1149      */
1150     function _burn(uint256 tokenId) internal virtual {
1151         address owner = ERC721.ownerOf(tokenId);
1152 
1153         _beforeTokenTransfer(owner, address(0), tokenId);
1154 
1155         // Clear approvals
1156         _approve(address(0), tokenId);
1157 
1158         _balances[owner] -= 1;
1159         delete _owners[tokenId];
1160 
1161         emit Transfer(owner, address(0), tokenId);
1162     }
1163 
1164     /**
1165      * @dev Transfers `tokenId` from `from` to `to`.
1166      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1167      *
1168      * Requirements:
1169      *
1170      * - `to` cannot be the zero address.
1171      * - `tokenId` token must be owned by `from`.
1172      *
1173      * Emits a {Transfer} event.
1174      */
1175     function _transfer(
1176         address from,
1177         address to,
1178         uint256 tokenId
1179     ) internal virtual {
1180         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1181         require(to != address(0), "ERC721: transfer to the zero address");
1182 
1183         _beforeTokenTransfer(from, to, tokenId);
1184 
1185         // Clear approvals from the previous owner
1186         _approve(address(0), tokenId);
1187 
1188         _balances[from] -= 1;
1189         _balances[to] += 1;
1190         _owners[tokenId] = to;
1191 
1192         emit Transfer(from, to, tokenId);
1193     }
1194 
1195     /**
1196      * @dev Approve `to` to operate on `tokenId`
1197      *
1198      * Emits a {Approval} event.
1199      */
1200     function _approve(address to, uint256 tokenId) internal virtual {
1201         _tokenApprovals[tokenId] = to;
1202         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1203     }
1204 
1205     /**
1206      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1207      * The call is not executed if the target address is not a contract.
1208      *
1209      * @param from address representing the previous owner of the given token ID
1210      * @param to target address that will receive the tokens
1211      * @param tokenId uint256 ID of the token to be transferred
1212      * @param _data bytes optional data to send along with the call
1213      * @return bool whether the call correctly returned the expected magic value
1214      */
1215     function _checkOnERC721Received(
1216         address from,
1217         address to,
1218         uint256 tokenId,
1219         bytes memory _data
1220     ) private returns (bool) {
1221         if (to.isContract()) {
1222             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1223                 return retval == IERC721Receiver(to).onERC721Received.selector;
1224             } catch (bytes memory reason) {
1225                 if (reason.length == 0) {
1226                     revert("ERC721: transfer to non ERC721Receiver implementer");
1227                 } else {
1228                     assembly {
1229                         revert(add(32, reason), mload(reason))
1230                     }
1231                 }
1232             }
1233         } else {
1234             return true;
1235         }
1236     }
1237 
1238     /**
1239      * @dev Hook that is called before any token transfer. This includes minting
1240      * and burning.
1241      *
1242      * Calling conditions:
1243      *
1244      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1245      * transferred to `to`.
1246      * - When `from` is zero, `tokenId` will be minted for `to`.
1247      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1248      * - `from` and `to` are never both zero.
1249      *
1250      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1251      */
1252     function _beforeTokenTransfer(
1253         address from,
1254         address to,
1255         uint256 tokenId
1256     ) internal virtual {}
1257 }
1258 
1259 pragma solidity ^0.8.0;
1260 
1261 /**
1262  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1263  * enumerability of all the token ids in the contract as well as all token ids owned by each
1264  * account.
1265  */
1266 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1267     // Mapping from owner to list of owned token IDs
1268     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1269 
1270     // Mapping from token ID to index of the owner tokens list
1271     mapping(uint256 => uint256) private _ownedTokensIndex;
1272 
1273     // Array with all token ids, used for enumeration
1274     uint256[] private _allTokens;
1275 
1276     // Mapping from token id to position in the allTokens array
1277     mapping(uint256 => uint256) private _allTokensIndex;
1278 
1279     /**
1280      * @dev See {IERC165-supportsInterface}.
1281      */
1282     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1283         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1284     }
1285 
1286     /**
1287      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1288      */
1289     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1290         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1291         return _ownedTokens[owner][index];
1292     }
1293 
1294     /**
1295      * @dev See {IERC721Enumerable-totalSupply}.
1296      */
1297     function totalSupply() public view virtual override returns (uint256) {
1298         return _allTokens.length;
1299     }
1300 
1301     /**
1302      * @dev See {IERC721Enumerable-tokenByIndex}.
1303      */
1304     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1305         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1306         return _allTokens[index];
1307     }
1308 
1309     /**
1310      * @dev Hook that is called before any token transfer. This includes minting
1311      * and burning.
1312      *
1313      * Calling conditions:
1314      *
1315      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1316      * transferred to `to`.
1317      * - When `from` is zero, `tokenId` will be minted for `to`.
1318      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1319      * - `from` cannot be the zero address.
1320      * - `to` cannot be the zero address.
1321      *
1322      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1323      */
1324     function _beforeTokenTransfer(
1325         address from,
1326         address to,
1327         uint256 tokenId
1328     ) internal virtual override {
1329         super._beforeTokenTransfer(from, to, tokenId);
1330 
1331         if (from == address(0)) {
1332             _addTokenToAllTokensEnumeration(tokenId);
1333         } else if (from != to) {
1334             _removeTokenFromOwnerEnumeration(from, tokenId);
1335         }
1336         if (to == address(0)) {
1337             _removeTokenFromAllTokensEnumeration(tokenId);
1338         } else if (to != from) {
1339             _addTokenToOwnerEnumeration(to, tokenId);
1340         }
1341     }
1342 
1343     /**
1344      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1345      * @param to address representing the new owner of the given token ID
1346      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1347      */
1348     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1349         uint256 length = ERC721.balanceOf(to);
1350         _ownedTokens[to][length] = tokenId;
1351         _ownedTokensIndex[tokenId] = length;
1352     }
1353 
1354     /**
1355      * @dev Private function to add a token to this extension's token tracking data structures.
1356      * @param tokenId uint256 ID of the token to be added to the tokens list
1357      */
1358     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1359         _allTokensIndex[tokenId] = _allTokens.length;
1360         _allTokens.push(tokenId);
1361     }
1362 
1363     /**
1364      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1365      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1366      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1367      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1368      * @param from address representing the previous owner of the given token ID
1369      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1370      */
1371     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1372         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1373         // then delete the last slot (swap and pop).
1374 
1375         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1376         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1377 
1378         // When the token to delete is the last token, the swap operation is unnecessary
1379         if (tokenIndex != lastTokenIndex) {
1380             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1381 
1382             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1383             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1384         }
1385 
1386         // This also deletes the contents at the last position of the array
1387         delete _ownedTokensIndex[tokenId];
1388         delete _ownedTokens[from][lastTokenIndex];
1389     }
1390 
1391     /**
1392      * @dev Private function to remove a token from this extension's token tracking data structures.
1393      * This has O(1) time complexity, but alters the order of the _allTokens array.
1394      * @param tokenId uint256 ID of the token to be removed from the tokens list
1395      */
1396     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1397         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1398         // then delete the last slot (swap and pop).
1399 
1400         uint256 lastTokenIndex = _allTokens.length - 1;
1401         uint256 tokenIndex = _allTokensIndex[tokenId];
1402 
1403         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1404         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1405         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1406         uint256 lastTokenId = _allTokens[lastTokenIndex];
1407 
1408         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1409         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1410 
1411         // This also deletes the contents at the last position of the array
1412         delete _allTokensIndex[tokenId];
1413         _allTokens.pop();
1414     }
1415 }
1416 
1417 pragma solidity ^0.8.0;
1418 
1419 contract  METAHOUSE  is ERC721Enumerable, Ownable
1420 {
1421     using SafeMath for uint256;
1422     using Address for address;
1423     using Strings for uint256;
1424 
1425     uint public  maxSupply =5000;
1426     uint public maxQuantity =3;
1427     uint public phase=2520;
1428     uint256 public price = 0.1 ether; 
1429     bool public isPaused = true;
1430     uint private tokenId=1;
1431     
1432 
1433 
1434 
1435     constructor(string memory baseURI) ERC721("METAHOUSE", "MH")  {
1436         setBaseURI(baseURI);
1437     }
1438     function setBaseURI(string memory baseURI) public onlyOwner {
1439         _baseURI = baseURI;
1440     }
1441 
1442     function setPrice(uint256 _newPrice) public onlyOwner() {
1443         price = _newPrice;
1444     }
1445     function setPhase(uint256 _newPhase) public onlyOwner() {
1446         phase = _newPhase;
1447     }
1448     function setMaxxQtPerTx(uint256 _quantity) public onlyOwner {
1449         maxQuantity=_quantity;
1450     }
1451 
1452     function setMaxSupply(uint256 _quantity) public onlyOwner {
1453         maxSupply=_quantity;
1454     }
1455 
1456 
1457     function flipPauseStatus() public onlyOwner {
1458         isPaused = !isPaused;
1459     }
1460 
1461     function getPrice(uint256 _quantity) public view returns (uint256) {
1462        
1463            return _quantity*price ;
1464      }
1465 
1466         
1467   
1468 
1469     function mint(uint chosenAmount) public payable {
1470         require(isPaused == false, "Sale is not active at the moment");
1471         require(totalSupply()+chosenAmount<=phase,"Quantity must be lesser then MaxSupply");
1472         require(chosenAmount > 0, "Number of tokens can not be less than or equal to 0");
1473         require(chosenAmount <= maxQuantity,"Chosen Amount exceeds MaxQuantity");
1474         require(price.mul(chosenAmount) == msg.value, "Sent ether value is incorrect");
1475         for (uint i = 0; i < chosenAmount; i++) {
1476             _safeMint(msg.sender, totalsupply());
1477             tokenId++;
1478             }
1479     }
1480     
1481  
1482     function tokensOfOwner(address _owner) public view returns (uint256[] memory)
1483     {
1484         uint256 count = balanceOf(_owner);
1485         uint256[] memory result = new uint256[](count);
1486         for (uint256 index = 0; index < count; index++) {
1487             result[index] = tokenOfOwnerByIndex(_owner, index);
1488         }
1489         return result;
1490     }
1491 
1492     function withdraw() public onlyOwner {
1493         uint balance = address(this).balance;
1494         payable(msg.sender).transfer(balance);
1495     }
1496     function totalsupply() private view returns (uint)
1497    
1498     {
1499         return tokenId;
1500     }
1501 }