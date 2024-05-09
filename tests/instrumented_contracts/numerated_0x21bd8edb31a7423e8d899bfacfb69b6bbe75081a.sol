1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4  
5 library SafeMath {
6     /**
7      * @dev Returns the addition of two unsigned integers, with an overflow flag.
8      *
9      * _Available since v3.4._
10      */
11     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
12         unchecked {
13             uint256 c = a + b;
14             if (c < a) return (false, 0);
15             return (true, c);
16         }
17     }
18 
19     /**
20      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             if (b > a) return (false, 0);
27             return (true, a - b);
28         }
29     }
30 
31     /**
32      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39             // benefit is lost if 'b' is also tested.
40             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
41             if (a == 0) return (true, 0);
42             uint256 c = a * b;
43             if (c / a != b) return (false, 0);
44             return (true, c);
45         }
46     }
47 
48     /**
49      * @dev Returns the division of two unsigned integers, with a division by zero flag.
50      *
51      * _Available since v3.4._
52      */
53     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
54         unchecked {
55             if (b == 0) return (false, 0);
56             return (true, a / b);
57         }
58     }
59 
60     /**
61      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a % b);
69         }
70     }
71 
72     /**
73      * @dev Returns the addition of two unsigned integers, reverting on
74      * overflow.
75      *
76      * Counterpart to Solidity's `+` operator.
77      *
78      * Requirements:
79      *
80      * - Addition cannot overflow.
81      */
82     function add(uint256 a, uint256 b) internal pure returns (uint256) {
83         return a + b;
84     }
85 
86     /**
87      * @dev Returns the subtraction of two unsigned integers, reverting on
88      * overflow (when the result is negative).
89      *
90      * Counterpart to Solidity's `-` operator.
91      *
92      * Requirements:
93      *
94      * - Subtraction cannot overflow.
95      */
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         return a - b;
98     }
99 
100     /**
101      * @dev Returns the multiplication of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `*` operator.
105      *
106      * Requirements:
107      *
108      * - Multiplication cannot overflow.
109      */
110     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a * b;
112     }
113 
114     /**
115      * @dev Returns the integer division of two unsigned integers, reverting on
116      * division by zero. The result is rounded towards zero.
117      *
118      * Counterpart to Solidity's `/` operator.
119      *
120      * Requirements:
121      *
122      * - The divisor cannot be zero.
123      */
124     function div(uint256 a, uint256 b) internal pure returns (uint256) {
125         return a / b;
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * reverting when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         return a % b;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
146      * overflow (when the result is negative).
147      *
148      * CAUTION: This function is deprecated because it requires allocating memory for the error
149      * message unnecessarily. For custom revert reasons use {trySub}.
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(
158         uint256 a,
159         uint256 b,
160         string memory errorMessage
161     ) internal pure returns (uint256) {
162         unchecked {
163             require(b <= a, errorMessage);
164             return a - b;
165         }
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      *
178      * - The divisor cannot be zero.
179      */
180     function div(
181         uint256 a,
182         uint256 b,
183         string memory errorMessage
184     ) internal pure returns (uint256) {
185         unchecked {
186             require(b > 0, errorMessage);
187             return a / b;
188         }
189     }
190 
191     /**
192      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
193      * reverting with custom message when dividing by zero.
194      *
195      * CAUTION: This function is deprecated because it requires allocating memory for the error
196      * message unnecessarily. For custom revert reasons use {tryMod}.
197      *
198      * Counterpart to Solidity's `%` operator. This function uses a `revert`
199      * opcode (which leaves remaining gas untouched) while Solidity uses an
200      * invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function mod(
207         uint256 a,
208         uint256 b,
209         string memory errorMessage
210     ) internal pure returns (uint256) {
211         unchecked {
212             require(b > 0, errorMessage);
213             return a % b;
214         }
215     }
216 }
217 
218 pragma solidity ^0.8.0;
219 
220 /**
221  * @dev String operations.
222  */
223 library Strings {
224     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
225 
226     /**
227      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
228      */
229     function toString(uint256 value) internal pure returns (string memory) {
230         // Inspired by OraclizeAPI's implementation - MIT licence
231         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
232 
233         if (value == 0) {
234             return "0";
235         }
236         uint256 temp = value;
237         uint256 digits;
238         while (temp != 0) {
239             digits++;
240             temp /= 10;
241         }
242         bytes memory buffer = new bytes(digits);
243         while (value != 0) {
244             digits -= 1;
245             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
246             value /= 10;
247         }
248         return string(buffer);
249     }
250 
251     /**
252      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
253      */
254     function toHexString(uint256 value) internal pure returns (string memory) {
255         if (value == 0) {
256             return "0x00";
257         }
258         uint256 temp = value;
259         uint256 length = 0;
260         while (temp != 0) {
261             length++;
262             temp >>= 8;
263         }
264         return toHexString(value, length);
265     }
266 
267     /**
268      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
269      */
270     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
271         bytes memory buffer = new bytes(2 * length + 2);
272         buffer[0] = "0";
273         buffer[1] = "x";
274         for (uint256 i = 2 * length + 1; i > 1; --i) {
275             buffer[i] = _HEX_SYMBOLS[value & 0xf];
276             value >>= 4;
277         }
278         require(value == 0, "Strings: hex length insufficient");
279         return string(buffer);
280     }
281 }
282 
283 pragma solidity ^0.8.0;
284 
285 /**
286  * @dev Collection of functions related to the address type
287  */
288 library Address {
289     /**
290      * @dev Returns true if `account` is a contract.
291      *
292      * [IMPORTANT]
293      * ====
294      * It is unsafe to assume that an address for which this function returns
295      * false is an externally-owned account (EOA) and not a contract.
296      *
297      * Among others, `isContract` will return false for the following
298      * types of addresses:
299      *
300      *  - an externally-owned account
301      *  - a contract in construction
302      *  - an address where a contract will be created
303      *  - an address where a contract lived, but was destroyed
304      * ====
305      */
306     function isContract(address account) internal view returns (bool) {
307         // This method relies on extcodesize, which returns 0 for contracts in
308         // construction, since the code is only stored at the end of the
309         // constructor execution.
310 
311         uint256 size;
312         assembly {
313             size := extcodesize(account)
314         }
315         return size > 0;
316     }
317 
318     /**
319      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
320      * `recipient`, forwarding all available gas and reverting on errors.
321      *
322      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
323      * of certain opcodes, possibly making contracts go over the 2300 gas limit
324      * imposed by `transfer`, making them unable to receive funds via
325      * `transfer`. {sendValue} removes this limitation.
326      *
327      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
328      *
329      * IMPORTANT: because control is transferred to `recipient`, care must be
330      * taken to not create reentrancy vulnerabilities. Consider using
331      * {ReentrancyGuard} or the
332      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
333      */
334     function sendValue(address payable recipient, uint256 amount) internal {
335         require(address(this).balance >= amount, "Address: insufficient balance");
336 
337         (bool success, ) = recipient.call{value: amount}("");
338         require(success, "Address: unable to send value, recipient may have reverted");
339     }
340 
341     /**
342      * @dev Performs a Solidity function call using a low level `call`. A
343      * plain `call` is an unsafe replacement for a function call: use this
344      * function instead.
345      *
346      * If `target` reverts with a revert reason, it is bubbled up by this
347      * function (like regular Solidity function calls).
348      *
349      * Returns the raw returned data. To convert to the expected return value,
350      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
351      *
352      * Requirements:
353      *
354      * - `target` must be a contract.
355      * - calling `target` with `data` must not revert.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
360         return functionCall(target, data, "Address: low-level call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
365      * `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, 0, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but also transferring `value` wei to `target`.
380      *
381      * Requirements:
382      *
383      * - the calling contract must have an ETH balance of at least `value`.
384      * - the called Solidity function must be `payable`.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(
389         address target,
390         bytes memory data,
391         uint256 value
392     ) internal returns (bytes memory) {
393         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
398      * with `errorMessage` as a fallback revert reason when `target` reverts.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(
403         address target,
404         bytes memory data,
405         uint256 value,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(address(this).balance >= value, "Address: insufficient balance for call");
409         require(isContract(target), "Address: call to non-contract");
410 
411         (bool success, bytes memory returndata) = target.call{value: value}(data);
412         return _verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a static call.
418      *
419      * _Available since v3.3._
420      */
421     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
422         return functionStaticCall(target, data, "Address: low-level static call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
427      * but performing a static call.
428      *
429      * _Available since v3.3._
430      */
431     function functionStaticCall(
432         address target,
433         bytes memory data,
434         string memory errorMessage
435     ) internal view returns (bytes memory) {
436         require(isContract(target), "Address: static call to non-contract");
437 
438         (bool success, bytes memory returndata) = target.staticcall(data);
439         return _verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but performing a delegate call.
445      *
446      * _Available since v3.4._
447      */
448     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
449         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
454      * but performing a delegate call.
455      *
456      * _Available since v3.4._
457      */
458     function functionDelegateCall(
459         address target,
460         bytes memory data,
461         string memory errorMessage
462     ) internal returns (bytes memory) {
463         require(isContract(target), "Address: delegate call to non-contract");
464 
465         (bool success, bytes memory returndata) = target.delegatecall(data);
466         return _verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     function _verifyCallResult(
470         bool success,
471         bytes memory returndata,
472         string memory errorMessage
473     ) private pure returns (bytes memory) {
474         if (success) {
475             return returndata;
476         } else {
477             // Look for revert reason and bubble it up if present
478             if (returndata.length > 0) {
479                 // The easiest way to bubble the revert reason is using memory via assembly
480 
481                 assembly {
482                     let returndata_size := mload(returndata)
483                     revert(add(32, returndata), returndata_size)
484                 }
485             } else {
486                 revert(errorMessage);
487             }
488         }
489     }
490 }
491 
492 pragma solidity ^0.8.0;
493 
494 /**
495  * @title ERC721 token receiver interface
496  * @dev Interface for any contract that wants to support safeTransfers
497  * from ERC721 asset contracts.
498  */
499 interface IERC721Receiver {
500     /**
501      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
502      * by `operator` from `from`, this function is called.
503      *
504      * It must return its Solidity selector to confirm the token transfer.
505      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
506      *
507      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
508      */
509     function onERC721Received(
510         address operator,
511         address from,
512         uint256 tokenId,
513         bytes calldata data
514     ) external returns (bytes4);
515 }
516 
517 pragma solidity ^0.8.0;
518 
519 /**
520  * @dev Interface of the ERC165 standard, as defined in the
521  * https://eips.ethereum.org/EIPS/eip-165[EIP].
522  *
523  * Implementers can declare support of contract interfaces, which can then be
524  * queried by others ({ERC165Checker}).
525  *
526  * For an implementation, see {ERC165}.
527  */
528 interface IERC165 {
529     /**
530      * @dev Returns true if this contract implements the interface defined by
531      * `interfaceId`. See the corresponding
532      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
533      * to learn more about how these ids are created.
534      *
535      * This function call must use less than 30 000 gas.
536      */
537     function supportsInterface(bytes4 interfaceId) external view returns (bool);
538 }
539 
540 pragma solidity ^0.8.0;
541 
542 /**
543  * @dev Implementation of the {IERC165} interface.
544  *
545  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
546  * for the additional interface id that will be supported. For example:
547  *
548  * ```solidity
549  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
550  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
551  * }
552  * ```
553  *
554  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
555  */
556 abstract contract ERC165 is IERC165 {
557     /**
558      * @dev See {IERC165-supportsInterface}.
559      */
560     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
561         return interfaceId == type(IERC165).interfaceId;
562     }
563 }
564 
565 pragma solidity ^0.8.0;
566 
567 /**
568  * @dev Required interface of an ERC721 compliant contract.
569  */
570 interface IERC721 is IERC165 {
571     /**
572      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
573      */
574     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
575 
576     /**
577      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
578      */
579     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
580 
581     /**
582      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
583      */
584     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
585 
586     /**
587      * @dev Returns the number of tokens in ``owner``'s account.
588      */
589     function balanceOf(address owner) external view returns (uint256 balance);
590 
591     /**
592      * @dev Returns the owner of the `tokenId` token.
593      *
594      * Requirements:
595      *
596      * - `tokenId` must exist.
597      */
598     function ownerOf(uint256 tokenId) external view returns (address owner);
599 
600     /**
601      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
602      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
603      *
604      * Requirements:
605      *
606      * - `from` cannot be the zero address.
607      * - `to` cannot be the zero address.
608      * - `tokenId` token must exist and be owned by `from`.
609      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
610      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
611      *
612      * Emits a {Transfer} event.
613      */
614     function safeTransferFrom(
615         address from,
616         address to,
617         uint256 tokenId
618     ) external;
619 
620     /**
621      * @dev Transfers `tokenId` token from `from` to `to`.
622      *
623      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
624      *
625      * Requirements:
626      *
627      * - `from` cannot be the zero address.
628      * - `to` cannot be the zero address.
629      * - `tokenId` token must be owned by `from`.
630      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
631      *
632      * Emits a {Transfer} event.
633      */
634     function transferFrom(
635         address from,
636         address to,
637         uint256 tokenId
638     ) external;
639 
640     /**
641      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
642      * The approval is cleared when the token is transferred.
643      *
644      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
645      *
646      * Requirements:
647      *
648      * - The caller must own the token or be an approved operator.
649      * - `tokenId` must exist.
650      *
651      * Emits an {Approval} event.
652      */
653     function approve(address to, uint256 tokenId) external;
654 
655     /**
656      * @dev Returns the account approved for `tokenId` token.
657      *
658      * Requirements:
659      *
660      * - `tokenId` must exist.
661      */
662     function getApproved(uint256 tokenId) external view returns (address operator);
663 
664     /**
665      * @dev Approve or remove `operator` as an operator for the caller.
666      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
667      *
668      * Requirements:
669      *
670      * - The `operator` cannot be the caller.
671      *
672      * Emits an {ApprovalForAll} event.
673      */
674     function setApprovalForAll(address operator, bool _approved) external;
675 
676     /**
677      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
678      *
679      * See {setApprovalForAll}
680      */
681     function isApprovedForAll(address owner, address operator) external view returns (bool);
682 
683     /**
684      * @dev Safely transfers `tokenId` token from `from` to `to`.
685      *
686      * Requirements:
687      *
688      * - `from` cannot be the zero address.
689      * - `to` cannot be the zero address.
690      * - `tokenId` token must exist and be owned by `from`.
691      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
692      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
693      *
694      * Emits a {Transfer} event.
695      */
696     function safeTransferFrom(
697         address from,
698         address to,
699         uint256 tokenId,
700         bytes calldata data
701     ) external;
702 }
703 
704 pragma solidity ^0.8.0;
705 
706 /**
707  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
708  * @dev See https://eips.ethereum.org/EIPS/eip-721
709  */
710 interface IERC721Enumerable is IERC721 {
711     /**
712      * @dev Returns the total amount of tokens stored by the contract.
713      */
714     function totalSupply() external view returns (uint256);
715 
716     /**
717      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
718      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
719      */
720     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
721 
722     /**
723      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
724      * Use along with {totalSupply} to enumerate all tokens.
725      */
726     function tokenByIndex(uint256 index) external view returns (uint256);
727 }
728 
729 pragma solidity ^0.8.0;
730 
731 /**
732  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
733  * @dev See https://eips.ethereum.org/EIPS/eip-721
734  */
735 interface IERC721Metadata is IERC721 {
736     /**
737      * @dev Returns the token collection name.
738      */
739     function name() external view returns (string memory);
740 
741     /**
742      * @dev Returns the token collection symbol.
743      */
744     function symbol() external view returns (string memory);
745 
746     /**
747      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
748      */
749     function tokenURI(uint256 tokenId) external view returns (string memory);
750 }
751 
752 pragma solidity ^0.8.0;
753 
754 /*
755  * @dev Provides information about the current execution context, including the
756  * sender of the transaction and its data. While these are generally available
757  * via msg.sender and msg.data, they should not be accessed in such a direct
758  * manner, since when dealing with meta-transactions the account sending and
759  * paying for execution may not be the actual sender (as far as an application
760  * is concerned).
761  *
762  * This contract is only required for intermediate, library-like contracts.
763  */
764 abstract contract Context {
765     function _msgSender() internal view virtual returns (address) {
766         return msg.sender;
767     }
768 
769     function _msgData() internal view virtual returns (bytes calldata) {
770         return msg.data;
771     }
772 }
773 
774 pragma solidity ^0.8.0;
775 
776 /**
777  * @dev Contract module which provides a basic access control mechanism, where
778  * there is an account (an owner) that can be granted exclusive access to
779  * specific functions.
780  *
781  * By default, the owner account will be the one that deploys the contract. This
782  * can later be changed with {transferOwnership}.
783  *
784  * This module is used through inheritance. It will make available the modifier
785  * `onlyOwner`, which can be applied to your functions to restrict their use to
786  * the owner.
787  */
788 abstract contract Ownable is Context {
789     address private _owner;
790 
791     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
792 
793     /**
794      * @dev Initializes the contract setting the deployer as the initial owner.
795      */
796     constructor () {
797         address msgSender = _msgSender();
798         _owner = msgSender;
799         emit OwnershipTransferred(address(0), msgSender);
800     }
801 
802     /**
803      * @dev Returns the address of the current owner.
804      */
805     function owner() public view virtual returns (address) {
806         return _owner;
807     }
808 
809     /**
810      * @dev Throws if called by any account other than the owner.
811      */
812     modifier onlyOwner() {
813         require(owner() == _msgSender(), "Ownable: caller is not the owner");
814         _;
815     }
816 
817     /**
818      * @dev Leaves the contract without owner. It will not be possible to call
819      * `onlyOwner` functions anymore. Can only be called by the current owner.
820      *
821      * NOTE: Renouncing ownership will leave the contract without an owner,
822      * thereby removing any functionality that is only available to the owner.
823      */
824  
825 
826     /**
827      * @dev Transfers ownership of the contract to a new account (`newOwner`).
828      * Can only be called by the current owner.
829      */
830     function transferOwnership(address newOwner) public virtual onlyOwner {
831         require(newOwner != address(0), "Ownable: new owner is the zero address");
832         _setOwner(newOwner);
833     }
834 
835     function _setOwner(address newOwner) private {
836         address oldOwner = _owner;
837         _owner = newOwner;
838         emit OwnershipTransferred(oldOwner, newOwner);
839     }
840 }
841 
842 pragma solidity ^0.8.0;
843 
844 /**
845  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
846  * the Metadata extension, but not including the Enumerable extension, which is available separately as
847  * {ERC721Enumerable}.
848  */
849 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
850     using Address for address;
851     using Strings for uint256;
852 
853     // Token name
854     string private _name;
855 
856     // Token symbol
857     string private _symbol;
858 
859     // Mapping from token ID to owner address
860     mapping(uint256 => address) private _owners;
861 
862     // Mapping owner address to token count
863     mapping(address => uint256) private _balances;
864 
865     // Mapping from token ID to approved address
866     mapping(uint256 => address) private _tokenApprovals;
867 
868     // Mapping from owner to operator approvals
869     mapping(address => mapping(address => bool)) private _operatorApprovals;
870 
871 
872     string public _baseURI;
873     /**
874      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
875      */
876     constructor(string memory name_, string memory symbol_) {
877         _name = name_;
878         _symbol = symbol_;
879     }
880 
881     /**
882      * @dev See {IERC165-supportsInterface}.
883      */
884     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
885         return
886             interfaceId == type(IERC721).interfaceId ||
887             interfaceId == type(IERC721Metadata).interfaceId ||
888             super.supportsInterface(interfaceId);
889     }
890 
891     /**
892      * @dev See {IERC721-balanceOf}.
893      */
894     function balanceOf(address owner) public view virtual override returns (uint256) {
895         require(owner != address(0), "ERC721: balance query for the zero address");
896         return _balances[owner];
897     }
898 
899     /**
900      * @dev See {IERC721-ownerOf}.
901      */
902     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
903         address owner = _owners[tokenId];
904         require(owner != address(0), "ERC721: owner query for nonexistent token");
905         return owner;
906     }
907 
908     /**
909      * @dev See {IERC721Metadata-name}.
910      */
911     function name() public view virtual override returns (string memory) {
912         return _name;
913     }
914 
915     /**
916      * @dev See {IERC721Metadata-symbol}.
917      */
918     function symbol() public view virtual override returns (string memory) {
919         return _symbol;
920     }
921 
922     /**
923      * @dev See {IERC721Metadata-tokenURI}.
924      */
925     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
926         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
927 
928         string memory base = baseURI();
929         return bytes(base).length > 0 ? string(abi.encodePacked(base, tokenId.toString())) : "";
930     }
931 
932     /**
933      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
934      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
935      * by default, can be overriden in child contracts.
936      */
937     function baseURI() internal view virtual returns (string memory) {
938         return _baseURI;
939     }
940 
941     /**
942      * @dev See {IERC721-approve}.
943      */
944     function approve(address to, uint256 tokenId) public virtual override {
945         address owner = ERC721.ownerOf(tokenId);
946         require(to != owner, "ERC721: approval to current owner");
947 
948         require(
949             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
950             "ERC721: approve caller is not owner nor approved for all"
951         );
952 
953         _approve(to, tokenId);
954     }
955 
956     /**
957      * @dev See {IERC721-getApproved}.
958      */
959     function getApproved(uint256 tokenId) public view virtual override returns (address) {
960         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
961 
962         return _tokenApprovals[tokenId];
963     }
964 
965     /**
966      * @dev See {IERC721-setApprovalForAll}.
967      */
968     function setApprovalForAll(address operator, bool approved) public virtual override {
969         require(operator != _msgSender(), "ERC721: approve to caller");
970 
971         _operatorApprovals[_msgSender()][operator] = approved;
972         emit ApprovalForAll(_msgSender(), operator, approved);
973     }
974 
975     /**
976      * @dev See {IERC721-isApprovedForAll}.
977      */
978     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
979         return _operatorApprovals[owner][operator];
980     }
981 
982     /**
983      * @dev See {IERC721-transferFrom}.
984      */
985     function transferFrom(
986         address from,
987         address to,
988         uint256 tokenId
989     ) public virtual override {
990         //solhint-disable-next-line max-line-length
991         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
992 
993         _transfer(from, to, tokenId);
994     }
995 
996     /**
997      * @dev See {IERC721-safeTransferFrom}.
998      */
999     function safeTransferFrom(
1000         address from,
1001         address to,
1002         uint256 tokenId
1003     ) public virtual override {
1004         safeTransferFrom(from, to, tokenId, "");
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-safeTransferFrom}.
1009      */
1010     function safeTransferFrom(
1011         address from,
1012         address to,
1013         uint256 tokenId,
1014         bytes memory _data
1015     ) public virtual override {
1016         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1017         _safeTransfer(from, to, tokenId, _data);
1018     }
1019 
1020     /**
1021      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1022      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1023      *
1024      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1025      *
1026      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1027      * implement alternative mechanisms to perform token transfer, such as signature-based.
1028      *
1029      * Requirements:
1030      *
1031      * - `from` cannot be the zero address.
1032      * - `to` cannot be the zero address.
1033      * - `tokenId` token must exist and be owned by `from`.
1034      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _safeTransfer(
1039         address from,
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) internal virtual {
1044         _transfer(from, to, tokenId);
1045         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1046     }
1047 
1048     /**
1049      * @dev Returns whether `tokenId` exists.
1050      *
1051      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1052      *
1053      * Tokens start existing when they are minted (`_mint`),
1054      * and stop existing when they are burned (`_burn`).
1055      */
1056     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1057         return _owners[tokenId] != address(0);
1058     }
1059 
1060     /**
1061      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1062      *
1063      * Requirements:
1064      *
1065      * - `tokenId` must exist.
1066      */
1067     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1068         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1069         address owner = ERC721.ownerOf(tokenId);
1070         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1071     }
1072 
1073     /**
1074      * @dev Safely mints `tokenId` and transfers it to `to`.
1075      *
1076      * Requirements:
1077      *
1078      * - `tokenId` must not exist.
1079      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1080      *
1081      * Emits a {Transfer} event.
1082      */
1083     function _safeMint(address to, uint256 tokenId) internal virtual {
1084         _safeMint(to, tokenId, "");
1085     }
1086 
1087     /**
1088      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1089      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1090      */
1091     function _safeMint(
1092         address to,
1093         uint256 tokenId,
1094         bytes memory _data
1095     ) internal virtual {
1096         _mint(to, tokenId);
1097         require(
1098             _checkOnERC721Received(address(0), to, tokenId, _data),
1099             "ERC721: transfer to non ERC721Receiver implementer"
1100         );
1101     }
1102 
1103     /**
1104      * @dev Mints `tokenId` and transfers it to `to`.
1105      *
1106      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1107      *
1108      * Requirements:
1109      *
1110      * - `tokenId` must not exist.
1111      * - `to` cannot be the zero address.
1112      *
1113      * Emits a {Transfer} event.
1114      */
1115     function _mint(address to, uint256 tokenId) internal virtual {
1116         require(to != address(0), "ERC721: mint to the zero address");
1117         require(!_exists(tokenId), "ERC721: token already minted");
1118 
1119         _beforeTokenTransfer(address(0), to, tokenId);
1120 
1121         _balances[to] += 1;
1122         _owners[tokenId] = to;
1123 
1124         emit Transfer(address(0), to, tokenId);
1125     }
1126 
1127     /**
1128      * @dev Destroys `tokenId`.
1129      * The approval is cleared when the token is burned.
1130      *
1131      * Requirements:
1132      *
1133      * - `tokenId` must exist.
1134      *
1135      * Emits a {Transfer} event.
1136      */
1137     function _burn(uint256 tokenId) internal virtual {
1138         address owner = ERC721.ownerOf(tokenId);
1139 
1140         _beforeTokenTransfer(owner, address(0), tokenId);
1141 
1142         // Clear approvals
1143         _approve(address(0), tokenId);
1144 
1145         _balances[owner] -= 1;
1146         delete _owners[tokenId];
1147 
1148         emit Transfer(owner, address(0), tokenId);
1149     }
1150 
1151     /**
1152      * @dev Transfers `tokenId` from `from` to `to`.
1153      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1154      *
1155      * Requirements:
1156      *
1157      * - `to` cannot be the zero address.
1158      * - `tokenId` token must be owned by `from`.
1159      *
1160      * Emits a {Transfer} event.
1161      */
1162     function _transfer(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) internal virtual {
1167         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1168         require(to != address(0), "ERC721: transfer to the zero address");
1169 
1170         _beforeTokenTransfer(from, to, tokenId);
1171 
1172         // Clear approvals from the previous owner
1173         _approve(address(0), tokenId);
1174 
1175         _balances[from] -= 1;
1176         _balances[to] += 1;
1177         _owners[tokenId] = to;
1178 
1179         emit Transfer(from, to, tokenId);
1180     }
1181 
1182     /**
1183      * @dev Approve `to` to operate on `tokenId`
1184      *
1185      * Emits a {Approval} event.
1186      */
1187     function _approve(address to, uint256 tokenId) internal virtual {
1188         _tokenApprovals[tokenId] = to;
1189         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1190     }
1191 
1192     /**
1193      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1194      * The call is not executed if the target address is not a contract.
1195      *
1196      * @param from address representing the previous owner of the given token ID
1197      * @param to target address that will receive the tokens
1198      * @param tokenId uint256 ID of the token to be transferred
1199      * @param _data bytes optional data to send along with the call
1200      * @return bool whether the call correctly returned the expected magic value
1201      */
1202     function _checkOnERC721Received(
1203         address from,
1204         address to,
1205         uint256 tokenId,
1206         bytes memory _data
1207     ) private returns (bool) {
1208         if (to.isContract()) {
1209             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1210                 return retval == IERC721Receiver(to).onERC721Received.selector;
1211             } catch (bytes memory reason) {
1212                 if (reason.length == 0) {
1213                     revert("ERC721: transfer to non ERC721Receiver implementer");
1214                 } else {
1215                     assembly {
1216                         revert(add(32, reason), mload(reason))
1217                     }
1218                 }
1219             }
1220         } else {
1221             return true;
1222         }
1223     }
1224 
1225     /**
1226      * @dev Hook that is called before any token transfer. This includes minting
1227      * and burning.
1228      *
1229      * Calling conditions:
1230      *
1231      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1232      * transferred to `to`.
1233      * - When `from` is zero, `tokenId` will be minted for `to`.
1234      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1235      * - `from` and `to` are never both zero.
1236      *
1237      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1238      */
1239     function _beforeTokenTransfer(
1240         address from,
1241         address to,
1242         uint256 tokenId
1243     ) internal virtual {}
1244 }
1245 
1246 
1247 
1248 pragma solidity ^0.8.0;
1249 
1250 /**
1251  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1252  * enumerability of all the token ids in the contract as well as all token ids owned by each
1253  * account.
1254  */
1255 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1256     // Mapping from owner to list of owned token IDs
1257     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1258 
1259     // Mapping from token ID to index of the owner tokens list
1260     mapping(uint256 => uint256) private _ownedTokensIndex;
1261 
1262     // Array with all token ids, used for enumeration
1263     uint256[] private _allTokens;
1264 
1265     // Mapping from token id to position in the allTokens array
1266     mapping(uint256 => uint256) private _allTokensIndex;
1267 
1268     /**
1269      * @dev See {IERC165-supportsInterface}.
1270      */
1271     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1272         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1273     }
1274 
1275     /**
1276      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1277      */
1278     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1279         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1280         return _ownedTokens[owner][index];
1281     }
1282 
1283     /**
1284      * @dev See {IERC721Enumerable-totalSupply}.
1285      */
1286     function totalSupply() public view virtual override returns (uint256) {
1287         return _allTokens.length;
1288     }
1289 
1290     /**
1291      * @dev See {IERC721Enumerable-tokenByIndex}.
1292      */
1293     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1294         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1295         return _allTokens[index];
1296     }
1297 
1298     /**
1299      * @dev Hook that is called before any token transfer. This includes minting
1300      * and burning.
1301      *
1302      * Calling conditions:
1303      *
1304      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1305      * transferred to `to`.
1306      * - When `from` is zero, `tokenId` will be minted for `to`.
1307      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1308      * - `from` cannot be the zero address.
1309      * - `to` cannot be the zero address.
1310      *
1311      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1312      */
1313     function _beforeTokenTransfer(
1314         address from,
1315         address to,
1316         uint256 tokenId
1317     ) internal virtual override {
1318         super._beforeTokenTransfer(from, to, tokenId);
1319 
1320         if (from == address(0)) {
1321             _addTokenToAllTokensEnumeration(tokenId);
1322         } else if (from != to) {
1323             _removeTokenFromOwnerEnumeration(from, tokenId);
1324         }
1325         if (to == address(0)) {
1326             _removeTokenFromAllTokensEnumeration(tokenId);
1327         } else if (to != from) {
1328             _addTokenToOwnerEnumeration(to, tokenId);
1329         }
1330     }
1331 
1332     /**
1333      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1334      * @param to address representing the new owner of the given token ID
1335      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1336      */
1337     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1338         uint256 length = ERC721.balanceOf(to);
1339         _ownedTokens[to][length] = tokenId;
1340         _ownedTokensIndex[tokenId] = length;
1341     }
1342 
1343     /**
1344      * @dev Private function to add a token to this extension's token tracking data structures.
1345      * @param tokenId uint256 ID of the token to be added to the tokens list
1346      */
1347     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1348         _allTokensIndex[tokenId] = _allTokens.length;
1349         _allTokens.push(tokenId);
1350     }
1351 
1352     /**
1353      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1354      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1355      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1356      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1357      * @param from address representing the previous owner of the given token ID
1358      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1359      */
1360     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1361         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1362         // then delete the last slot (swap and pop).
1363 
1364         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1365         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1366 
1367         // When the token to delete is the last token, the swap operation is unnecessary
1368         if (tokenIndex != lastTokenIndex) {
1369             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1370 
1371             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1372             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1373         }
1374 
1375         // This also deletes the contents at the last position of the array
1376         delete _ownedTokensIndex[tokenId];
1377         delete _ownedTokens[from][lastTokenIndex];
1378     }
1379 
1380     /**
1381      * @dev Private function to remove a token from this extension's token tracking data structures.
1382      * This has O(1) time complexity, but alters the order of the _allTokens array.
1383      * @param tokenId uint256 ID of the token to be removed from the tokens list
1384      */
1385     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1386         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1387         // then delete the last slot (swap and pop).
1388 
1389         uint256 lastTokenIndex = _allTokens.length - 1;
1390         uint256 tokenIndex = _allTokensIndex[tokenId];
1391 
1392         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1393         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1394         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1395         uint256 lastTokenId = _allTokens[lastTokenIndex];
1396 
1397         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1398         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1399 
1400         // This also deletes the contents at the last position of the array
1401         delete _allTokensIndex[tokenId];
1402         _allTokens.pop();
1403     }
1404 }
1405 library Counters {
1406     struct Counter {
1407         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1408         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1409         // this feature: see https://github.com/ethereum/solidity/issues/4637
1410         uint256 _value; // default: 0
1411     }
1412 
1413     function current(Counter storage counter) internal view returns (uint256) {
1414         return counter._value;
1415     }
1416 
1417     function increment(Counter storage counter) internal {
1418         unchecked {
1419             counter._value += 1;
1420         }
1421     }
1422 
1423     function decrement(Counter storage counter) internal {
1424         uint256 value = counter._value;
1425         require(value > 0, "Counter: decrement overflow");
1426         unchecked {
1427             counter._value = value - 1;
1428         }
1429     }
1430 
1431     function reset(Counter storage counter) internal {
1432         counter._value = 0;
1433     }
1434 }
1435 
1436 pragma solidity ^0.8.0;
1437 
1438 contract DragonsOfMidgard is ERC721Enumerable, Ownable
1439 {
1440     using Counters for Counters.Counter;
1441     using SafeMath for uint256;
1442     Counters.Counter private _basetokenIds;
1443     string private juvenile = 'juvenile';
1444     string private ancient = 'ancient';
1445     string private greatWyrm = 'greatWyrm';
1446     uint public basePrice = 0.07 ether;
1447     uint public juvenilePrice;
1448     uint public ancientPrice;
1449     uint public greatWyrmPrice ;
1450     uint public maxQuantity =30;
1451     uint public maxNewColQuantity=30;
1452     uint public maxPreSaleQuantity=20;
1453     uint public baseSupply=9999;
1454     uint private ageSupply=10000;
1455     uint public preSaleSupply=3000;
1456     bool public isPaused = true;
1457     bool public isNewColPaused=true;
1458     bool public isMintAgePaused=true;
1459     bool public isPreSalePaused=true;
1460 
1461     struct EVOLVING{
1462         bool juvenileAge ;
1463         bool ancientAge;
1464         bool greatWyrmAge;
1465     }
1466 
1467     struct NewCollection{
1468         string name;
1469         uint quantity;
1470         uint price;
1471     }
1472     
1473     mapping(uint => EVOLVING) public evolving;
1474     mapping(string => NewCollection) public _newCollection;
1475     constructor(string memory baseURI) ERC721("Dragon Of Midgard", "DRAGON")  {
1476         setBaseURI(baseURI);
1477     }
1478     function setBaseURI(string memory baseURI) public onlyOwner {
1479         _baseURI = baseURI;
1480     }
1481     
1482         function getPrice(string memory _type) public view returns(uint256) {
1483         if (keccak256(bytes(_type)) == keccak256(bytes(juvenile))) {
1484             return juvenilePrice;
1485         } else if (keccak256(bytes(_type)) == keccak256(bytes(ancient))) {
1486             return ancientPrice;
1487         } else if (keccak256(bytes(_type)) == keccak256(bytes(greatWyrm))) {
1488             return greatWyrmPrice;
1489         } else {
1490             revert("HDHDF");
1491         }
1492     }
1493 
1494    
1495     function mint(uint chosenAmount) public payable   {
1496         require(isPaused == false, "Sale is not active at the moment");
1497         require(chosenAmount > 0, "Number of tokens can not be less than or equal to 0");
1498         require(chosenAmount <= maxQuantity,"Chosen Amount exceeds MaxQuantity");
1499         require(baseSupply>=baseTotalSupply()+chosenAmount,"Quantity is greater than remainig base supply");
1500         require(basePrice.mul(chosenAmount) == msg.value, "Sent ether value is incorrect");
1501         for (uint i = 0; i < chosenAmount; i++) {
1502         _basetokenIds.increment();
1503         _safeMint(msg.sender, baseTotalSupply());
1504         evolving[baseTotalSupply()] = EVOLVING({
1505             
1506         juvenileAge:false,
1507         ancientAge:false,
1508         greatWyrmAge:false
1509             
1510          });
1511           
1512         }
1513         
1514 
1515         }
1516         function mintAges(uint _tokenId,string memory _age) public payable   {
1517         require(isMintAgePaused == false, "MintAge is not active at the moment");
1518         require(_tokenId>=0&&_tokenId<=9999,"Base Token Id is not correct");
1519         require(ownerOf(_tokenId)==msg.sender,"user are not owner of this token");
1520         require(getPrice(_age)==msg.value,"incorrect price");
1521         EVOLVING storage evolvData = evolving[_tokenId];
1522          if (keccak256(bytes(_age)) == keccak256(bytes(juvenile))) {
1523             require(evolvData.juvenileAge==false,"juvenileAge is already Minted");
1524             _safeMint(msg.sender, ageSupply);
1525             ageSupply++;
1526             evolvData.juvenileAge=true;
1527         } else if (keccak256(bytes(_age)) == keccak256(bytes(ancient))) {
1528             require(evolvData.ancientAge==false,"ancientAge is already Minted");
1529             require(evolvData.juvenileAge==true,"First Mint JuvenileAge ");
1530             _safeMint(msg.sender, ageSupply);
1531             ageSupply++;
1532             evolvData.ancientAge=true;
1533         } else if (keccak256(bytes(_age)) == keccak256(bytes(greatWyrm))) {
1534             require(evolvData.ancientAge==true,"First Mint ancientAge");
1535             require(evolvData.juvenileAge==true,"First Mint JuvenileAge ");
1536             require(evolvData.greatWyrmAge==false,"greatWyrmAge is already Minted");
1537             _safeMint(msg.sender, ageSupply);
1538             ageSupply++;
1539             evolvData.greatWyrmAge=true;
1540         } else {
1541             revert("Wrong Age Entered");
1542         }
1543         
1544     }
1545      function burn(uint256 tokenId) public onlyOwner {
1546       _burn(tokenId);
1547     }
1548     
1549     function baseTotalSupply() public view returns (uint)
1550     {
1551         return _basetokenIds.current();
1552     }
1553      function ageTotalSupply() private view returns (uint)
1554     {
1555         return ageSupply;
1556     }
1557      function ageTotalsupply() public view returns (uint)
1558     {
1559         return ageSupply-10000;
1560     }
1561     
1562      function reserveTokens(uint quantity) public onlyOwner {
1563         require(quantity <=200, "quantity is greater than 200.");
1564         require(baseSupply>=baseTotalSupply()+quantity,"quantity is greater than remaining base Supply");
1565         for (uint i = 0; i < quantity; i++) {
1566         _basetokenIds.increment();
1567         _safeMint(msg.sender, baseTotalSupply());
1568         evolving[baseTotalSupply()] = EVOLVING({
1569         juvenileAge:false,
1570         ancientAge:false,
1571         greatWyrmAge:false
1572             
1573             
1574          });
1575            
1576         }
1577     }
1578     function addNewCollection(string memory _artName,uint _quantity,uint _price)public onlyOwner
1579     {
1580           _newCollection[_artName]=NewCollection({
1581             name :_artName,
1582             quantity:_quantity,
1583             price:_price
1584            });
1585     }
1586     
1587     function newCollectionMint(string memory _artName, uint _chosenAmount) public payable 
1588     {
1589         require(isNewColPaused == false, "Sale is not active at the moment");
1590         require(_chosenAmount > 0, "Number of tokens can not be less than or equal to 0");
1591         require(_chosenAmount <= maxNewColQuantity,"Chosen Amount exceeds MaxQuantity");
1592         NewCollection storage newArt = _newCollection[_artName];
1593         require(newArt.quantity>0,"Sold Out");
1594         require(newArt.quantity>=_chosenAmount,"Quantity is greater than remaining Supply");
1595         require(newArt.price.mul(_chosenAmount) == msg.value, "Sent ether value is incorrect");
1596         for (uint i = 0; i < _chosenAmount; i++) {
1597             _safeMint(msg.sender, ageTotalSupply());
1598             ageSupply++;
1599             
1600             }
1601             newArt.quantity-=_chosenAmount;
1602         
1603         
1604     }
1605     
1606     
1607     
1608     function preSaleMint(uint quantity)  public payable   {
1609 
1610         require(isPreSalePaused == false, "Sale is not active at the moment");
1611         require(quantity>0,"quantity less than zero");
1612         require(quantity<=maxPreSaleQuantity,"quantity is greater than maxPreSaleQuantity");
1613         require(preSaleSupply>0,"Sold Out");
1614         require(preSaleSupply>=quantity,"Quantity is greater than remaining Supply");
1615         require(basePrice.mul(quantity) == msg.value, "Sent ether value is incorrect");
1616         
1617         for (uint i = 0; i < quantity; i++) {
1618         _basetokenIds.increment();
1619         _safeMint(msg.sender, baseTotalSupply());
1620         evolving[baseTotalSupply()] = EVOLVING({
1621         juvenileAge:false,
1622         ancientAge:false,
1623         greatWyrmAge:false
1624             
1625             
1626          });
1627             
1628         }
1629         preSaleSupply-=quantity;
1630     }
1631 
1632 
1633     function withdraw() public onlyOwner {
1634        uint amount = address(this).balance;
1635         (bool success, ) = payable(owner()).call {
1636             value: amount
1637         }("");
1638         require(success, "Failed to send Ether");
1639         
1640     }
1641  
1642     function flipPauseStatus() public onlyOwner {
1643         isPaused = !isPaused;
1644     }
1645     function flipNewColPauseStatus() public onlyOwner {
1646         isNewColPaused = !isNewColPaused;
1647     }
1648     function flipMintAgePauseStatus() public onlyOwner {
1649         isMintAgePaused = !isMintAgePaused;
1650     }
1651         function flipPreSalePauseStatus() public onlyOwner {
1652         isPreSalePaused = !isPreSalePaused;
1653     }
1654 
1655     function updateBasePrice(uint _basePrice ) public onlyOwner {
1656         basePrice = _basePrice;
1657     }
1658     function updateNewColMaxQuantity(uint _maxNewColQuantity ) public onlyOwner {
1659         maxNewColQuantity =_maxNewColQuantity;
1660     }
1661      function updateAgePrices(uint _juvPrice,uint _ancientPrice,uint _greatwymPrice) public onlyOwner {
1662         juvenilePrice=_juvPrice;
1663         ancientPrice=_ancientPrice;
1664         greatWyrmPrice=_greatwymPrice;
1665     }
1666     function update (uint quantity) public onlyOwner
1667     {
1668         baseSupply=quantity;
1669     }
1670 
1671 }