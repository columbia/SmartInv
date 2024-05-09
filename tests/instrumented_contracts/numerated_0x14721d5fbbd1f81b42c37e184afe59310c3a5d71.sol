1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-25
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-10-07
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 // CAUTION
14 // This version of SafeMath should only be used with Solidity 0.8 or later,
15 // because it relies on the compiler's built in overflow checks.
16 
17 /**
18  * @dev Wrappers over Solidity's arithmetic operations.
19  *
20  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
21  * now has built in overflow checking.
22  */
23 library SafeMath {
24     /**
25      * @dev Returns the addition of two unsigned integers, with an overflow flag.
26      *
27      * _Available since v3.4._
28      */
29     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
30         unchecked {
31             uint256 c = a + b;
32             if (c < a) return (false, 0);
33             return (true, c);
34         }
35     }
36 
37     /**
38      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
39      *
40      * _Available since v3.4._
41      */
42     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
43         unchecked {
44             if (b > a) return (false, 0);
45             return (true, a - b);
46         }
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
51      *
52      * _Available since v3.4._
53      */
54     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
55         unchecked {
56             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
57             // benefit is lost if 'b' is also tested.
58             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
59             if (a == 0) return (true, 0);
60             uint256 c = a * b;
61             if (c / a != b) return (false, 0);
62             return (true, c);
63         }
64     }
65 
66     /**
67      * @dev Returns the division of two unsigned integers, with a division by zero flag.
68      *
69      * _Available since v3.4._
70      */
71     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
72         unchecked {
73             if (b == 0) return (false, 0);
74             return (true, a / b);
75         }
76     }
77 
78     /**
79      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
80      *
81      * _Available since v3.4._
82      */
83     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
84         unchecked {
85             if (b == 0) return (false, 0);
86             return (true, a % b);
87         }
88     }
89 
90     /**
91      * @dev Returns the addition of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `+` operator.
95      *
96      * Requirements:
97      *
98      * - Addition cannot overflow.
99      */
100     function add(uint256 a, uint256 b) internal pure returns (uint256) {
101         return a + b;
102     }
103 
104     /**
105      * @dev Returns the subtraction of two unsigned integers, reverting on
106      * overflow (when the result is negative).
107      *
108      * Counterpart to Solidity's `-` operator.
109      *
110      * Requirements:
111      *
112      * - Subtraction cannot overflow.
113      */
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         return a - b;
116     }
117 
118     /**
119      * @dev Returns the multiplication of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `*` operator.
123      *
124      * Requirements:
125      *
126      * - Multiplication cannot overflow.
127      */
128     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
129         return a * b;
130     }
131 
132     /**
133      * @dev Returns the integer division of two unsigned integers, reverting on
134      * division by zero. The result is rounded towards zero.
135      *
136      * Counterpart to Solidity's `/` operator.
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function div(uint256 a, uint256 b) internal pure returns (uint256) {
143         return a / b;
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
148      * reverting when dividing by zero.
149      *
150      * Counterpart to Solidity's `%` operator. This function uses a `revert`
151      * opcode (which leaves remaining gas untouched) while Solidity uses an
152      * invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
159         return a % b;
160     }
161 
162     /**
163      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
164      * overflow (when the result is negative).
165      *
166      * CAUTION: This function is deprecated because it requires allocating memory for the error
167      * message unnecessarily. For custom revert reasons use {trySub}.
168      *
169      * Counterpart to Solidity's `-` operator.
170      *
171      * Requirements:
172      *
173      * - Subtraction cannot overflow.
174      */
175     function sub(
176         uint256 a,
177         uint256 b,
178         string memory errorMessage
179     ) internal pure returns (uint256) {
180         unchecked {
181             require(b <= a, errorMessage);
182             return a - b;
183         }
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(
199         uint256 a,
200         uint256 b,
201         string memory errorMessage
202     ) internal pure returns (uint256) {
203         unchecked {
204             require(b > 0, errorMessage);
205             return a / b;
206         }
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * reverting with custom message when dividing by zero.
212      *
213      * CAUTION: This function is deprecated because it requires allocating memory for the error
214      * message unnecessarily. For custom revert reasons use {tryMod}.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function mod(
225         uint256 a,
226         uint256 b,
227         string memory errorMessage
228     ) internal pure returns (uint256) {
229         unchecked {
230             require(b > 0, errorMessage);
231             return a % b;
232         }
233     }
234 }
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev String operations.
240  */
241 library Strings {
242     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
243 
244     /**
245      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
246      */
247     function toString(uint256 value) internal pure returns (string memory) {
248         // Inspired by OraclizeAPI's implementation - MIT licence
249         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
250 
251         if (value == 0) {
252             return "0";
253         }
254         uint256 temp = value;
255         uint256 digits;
256         while (temp != 0) {
257             digits++;
258             temp /= 10;
259         }
260         bytes memory buffer = new bytes(digits);
261         while (value != 0) {
262             digits -= 1;
263             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
264             value /= 10;
265         }
266         return string(buffer);
267     }
268 
269     /**
270      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
271      */
272     function toHexString(uint256 value) internal pure returns (string memory) {
273         if (value == 0) {
274             return "0x00";
275         }
276         uint256 temp = value;
277         uint256 length = 0;
278         while (temp != 0) {
279             length++;
280             temp >>= 8;
281         }
282         return toHexString(value, length);
283     }
284 
285     /**
286      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
287      */
288     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
289         bytes memory buffer = new bytes(2 * length + 2);
290         buffer[0] = "0";
291         buffer[1] = "x";
292         for (uint256 i = 2 * length + 1; i > 1; --i) {
293             buffer[i] = _HEX_SYMBOLS[value & 0xf];
294             value >>= 4;
295         }
296         require(value == 0, "Strings: hex length insufficient");
297         return string(buffer);
298     }
299 }
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @dev Collection of functions related to the address type
305  */
306 library Address {
307     /**
308      * @dev Returns true if `account` is a contract.
309      *
310      * [IMPORTANT]
311      * ====
312      * It is unsafe to assume that an address for which this function returns
313      * false is an externally-owned account (EOA) and not a contract.
314      *
315      * Among others, `isContract` will return false for the following
316      * types of addresses:
317      *
318      *  - an externally-owned account
319      *  - a contract in construction
320      *  - an address where a contract will be created
321      *  - an address where a contract lived, but was destroyed
322      * ====
323      */
324     function isContract(address account) internal view returns (bool) {
325         // This method relies on extcodesize, which returns 0 for contracts in
326         // construction, since the code is only stored at the end of the
327         // constructor execution.
328 
329         uint256 size;
330         assembly {
331             size := extcodesize(account)
332         }
333         return size > 0;
334     }
335 
336     /**
337      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
338      * `recipient`, forwarding all available gas and reverting on errors.
339      *
340      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
341      * of certain opcodes, possibly making contracts go over the 2300 gas limit
342      * imposed by `transfer`, making them unable to receive funds via
343      * `transfer`. {sendValue} removes this limitation.
344      *
345      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
346      *
347      * IMPORTANT: because control is transferred to `recipient`, care must be
348      * taken to not create reentrancy vulnerabilities. Consider using
349      * {ReentrancyGuard} or the
350      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
351      */
352     function sendValue(address payable recipient, uint256 amount) internal {
353         require(address(this).balance >= amount, "Address: insufficient balance");
354 
355         (bool success, ) = recipient.call{value: amount}("");
356         require(success, "Address: unable to send value, recipient may have reverted");
357     }
358 
359     /**
360      * @dev Performs a Solidity function call using a low level `call`. A
361      * plain `call` is an unsafe replacement for a function call: use this
362      * function instead.
363      *
364      * If `target` reverts with a revert reason, it is bubbled up by this
365      * function (like regular Solidity function calls).
366      *
367      * Returns the raw returned data. To convert to the expected return value,
368      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
369      *
370      * Requirements:
371      *
372      * - `target` must be a contract.
373      * - calling `target` with `data` must not revert.
374      *
375      * _Available since v3.1._
376      */
377     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
378         return functionCall(target, data, "Address: low-level call failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
383      * `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387     function functionCall(
388         address target,
389         bytes memory data,
390         string memory errorMessage
391     ) internal returns (bytes memory) {
392         return functionCallWithValue(target, data, 0, errorMessage);
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
397      * but also transferring `value` wei to `target`.
398      *
399      * Requirements:
400      *
401      * - the calling contract must have an ETH balance of at least `value`.
402      * - the called Solidity function must be `payable`.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(
407         address target,
408         bytes memory data,
409         uint256 value
410     ) internal returns (bytes memory) {
411         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
416      * with `errorMessage` as a fallback revert reason when `target` reverts.
417      *
418      * _Available since v3.1._
419      */
420     function functionCallWithValue(
421         address target,
422         bytes memory data,
423         uint256 value,
424         string memory errorMessage
425     ) internal returns (bytes memory) {
426         require(address(this).balance >= value, "Address: insufficient balance for call");
427         require(isContract(target), "Address: call to non-contract");
428 
429         (bool success, bytes memory returndata) = target.call{value: value}(data);
430         return _verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
435      * but performing a static call.
436      *
437      * _Available since v3.3._
438      */
439     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
440         return functionStaticCall(target, data, "Address: low-level static call failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
445      * but performing a static call.
446      *
447      * _Available since v3.3._
448      */
449     function functionStaticCall(
450         address target,
451         bytes memory data,
452         string memory errorMessage
453     ) internal view returns (bytes memory) {
454         require(isContract(target), "Address: static call to non-contract");
455 
456         (bool success, bytes memory returndata) = target.staticcall(data);
457         return _verifyCallResult(success, returndata, errorMessage);
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
462      * but performing a delegate call.
463      *
464      * _Available since v3.4._
465      */
466     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
467         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
472      * but performing a delegate call.
473      *
474      * _Available since v3.4._
475      */
476     function functionDelegateCall(
477         address target,
478         bytes memory data,
479         string memory errorMessage
480     ) internal returns (bytes memory) {
481         require(isContract(target), "Address: delegate call to non-contract");
482 
483         (bool success, bytes memory returndata) = target.delegatecall(data);
484         return _verifyCallResult(success, returndata, errorMessage);
485     }
486 
487     function _verifyCallResult(
488         bool success,
489         bytes memory returndata,
490         string memory errorMessage
491     ) private pure returns (bytes memory) {
492         if (success) {
493             return returndata;
494         } else {
495             // Look for revert reason and bubble it up if present
496             if (returndata.length > 0) {
497                 // The easiest way to bubble the revert reason is using memory via assembly
498 
499                 assembly {
500                     let returndata_size := mload(returndata)
501                     revert(add(32, returndata), returndata_size)
502                 }
503             } else {
504                 revert(errorMessage);
505             }
506         }
507     }
508 }
509 
510 pragma solidity ^0.8.0;
511 
512 /**
513  * @title ERC721 token receiver interface
514  * @dev Interface for any contract that wants to support safeTransfers
515  * from ERC721 asset contracts.
516  */
517 interface IERC721Receiver {
518     /**
519      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
520      * by `operator` from `from`, this function is called.
521      *
522      * It must return its Solidity selector to confirm the token transfer.
523      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
524      *
525      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
526      */
527     function onERC721Received(
528         address operator,
529         address from,
530         uint256 tokenId,
531         bytes calldata data
532     ) external returns (bytes4);
533 }
534 
535 pragma solidity ^0.8.0;
536 
537 /**
538  * @dev Interface of the ERC165 standard, as defined in the
539  * https://eips.ethereum.org/EIPS/eip-165[EIP].
540  *
541  * Implementers can declare support of contract interfaces, which can then be
542  * queried by others ({ERC165Checker}).
543  *
544  * For an implementation, see {ERC165}.
545  */
546 interface IERC165 {
547     /**
548      * @dev Returns true if this contract implements the interface defined by
549      * `interfaceId`. See the corresponding
550      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
551      * to learn more about how these ids are created.
552      *
553      * This function call must use less than 30 000 gas.
554      */
555     function supportsInterface(bytes4 interfaceId) external view returns (bool);
556 }
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @dev Implementation of the {IERC165} interface.
562  *
563  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
564  * for the additional interface id that will be supported. For example:
565  *
566  * ```solidity
567  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
568  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
569  * }
570  * ```
571  *
572  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
573  */
574 abstract contract ERC165 is IERC165 {
575     /**
576      * @dev See {IERC165-supportsInterface}.
577      */
578     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
579         return interfaceId == type(IERC165).interfaceId;
580     }
581 }
582 
583 pragma solidity ^0.8.0;
584 
585 /**
586  * @dev Required interface of an ERC721 compliant contract.
587  */
588 interface IERC721 is IERC165 {
589     /**
590      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
591      */
592     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
593 
594     /**
595      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
596      */
597     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
598 
599     /**
600      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
601      */
602     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
603 
604     /**
605      * @dev Returns the number of tokens in ``owner``'s account.
606      */
607     function balanceOf(address owner) external view returns (uint256 balance);
608 
609     /**
610      * @dev Returns the owner of the `tokenId` token.
611      *
612      * Requirements:
613      *
614      * - `tokenId` must exist.
615      */
616     function ownerOf(uint256 tokenId) external view returns (address owner);
617 
618     /**
619      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
620      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
621      *
622      * Requirements:
623      *
624      * - `from` cannot be the zero address.
625      * - `to` cannot be the zero address.
626      * - `tokenId` token must exist and be owned by `from`.
627      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
628      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
629      *
630      * Emits a {Transfer} event.
631      */
632     function safeTransferFrom(
633         address from,
634         address to,
635         uint256 tokenId
636     ) external;
637 
638     /**
639      * @dev Transfers `tokenId` token from `from` to `to`.
640      *
641      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
642      *
643      * Requirements:
644      *
645      * - `from` cannot be the zero address.
646      * - `to` cannot be the zero address.
647      * - `tokenId` token must be owned by `from`.
648      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
649      *
650      * Emits a {Transfer} event.
651      */
652     function transferFrom(
653         address from,
654         address to,
655         uint256 tokenId
656     ) external;
657 
658     /**
659      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
660      * The approval is cleared when the token is transferred.
661      *
662      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
663      *
664      * Requirements:
665      *
666      * - The caller must own the token or be an approved operator.
667      * - `tokenId` must exist.
668      *
669      * Emits an {Approval} event.
670      */
671     function approve(address to, uint256 tokenId) external;
672 
673     /**
674      * @dev Returns the account approved for `tokenId` token.
675      *
676      * Requirements:
677      *
678      * - `tokenId` must exist.
679      */
680     function getApproved(uint256 tokenId) external view returns (address operator);
681 
682     /**
683      * @dev Approve or remove `operator` as an operator for the caller.
684      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
685      *
686      * Requirements:
687      *
688      * - The `operator` cannot be the caller.
689      *
690      * Emits an {ApprovalForAll} event.
691      */
692     function setApprovalForAll(address operator, bool _approved) external;
693 
694     /**
695      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
696      *
697      * See {setApprovalForAll}
698      */
699     function isApprovedForAll(address owner, address operator) external view returns (bool);
700 
701     /**
702      * @dev Safely transfers `tokenId` token from `from` to `to`.
703      *
704      * Requirements:
705      *
706      * - `from` cannot be the zero address.
707      * - `to` cannot be the zero address.
708      * - `tokenId` token must exist and be owned by `from`.
709      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
710      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
711      *
712      * Emits a {Transfer} event.
713      */
714     function safeTransferFrom(
715         address from,
716         address to,
717         uint256 tokenId,
718         bytes calldata data
719     ) external;
720 }
721 
722 pragma solidity ^0.8.0;
723 
724 /**
725  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
726  * @dev See https://eips.ethereum.org/EIPS/eip-721
727  */
728 interface IERC721Enumerable is IERC721 {
729     /**
730      * @dev Returns the total amount of tokens stored by the contract.
731      */
732     function totalSupply() external view returns (uint256);
733 
734     /**
735      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
736      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
737      */
738     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
739 
740     /**
741      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
742      * Use along with {totalSupply} to enumerate all tokens.
743      */
744     function tokenByIndex(uint256 index) external view returns (uint256);
745 }
746 
747 pragma solidity ^0.8.0;
748 
749 /**
750  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
751  * @dev See https://eips.ethereum.org/EIPS/eip-721
752  */
753 interface IERC721Metadata is IERC721 {
754     /**
755      * @dev Returns the token collection name.
756      */
757     function name() external view returns (string memory);
758 
759     /**
760      * @dev Returns the token collection symbol.
761      */
762     function symbol() external view returns (string memory);
763 
764     /**
765      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
766      */
767     function tokenURI(uint256 tokenId) external view returns (string memory);
768 }
769 
770 pragma solidity ^0.8.0;
771 
772 /*
773  * @dev Provides information about the current execution context, including the
774  * sender of the transaction and its data. While these are generally available
775  * via msg.sender and msg.data, they should not be accessed in such a direct
776  * manner, since when dealing with meta-transactions the account sending and
777  * paying for execution may not be the actual sender (as far as an application
778  * is concerned).
779  *
780  * This contract is only required for intermediate, library-like contracts.
781  */
782 abstract contract Context {
783     function _msgSender() internal view virtual returns (address) {
784         return msg.sender;
785     }
786 
787     function _msgData() internal view virtual returns (bytes calldata) {
788         return msg.data;
789     }
790 }
791 
792 pragma solidity ^0.8.0;
793 
794 /**
795  * @dev Contract module which provides a basic access control mechanism, where
796  * there is an account (an owner) that can be granted exclusive access to
797  * specific functions.
798  *
799  * By default, the owner account will be the one that deploys the contract. This
800  * can later be changed with {transferOwnership}.
801  *
802  * This module is used through inheritance. It will make available the modifier
803  * `onlyOwner`, which can be applied to your functions to restrict their use to
804  * the owner.
805  */
806 abstract contract Ownable is Context {
807     address private _owner;
808 
809     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
810 
811     /**
812      * @dev Initializes the contract setting the deployer as the initial owner.
813      */
814     constructor () {
815         address msgSender = _msgSender();
816         _owner = msgSender;
817         emit OwnershipTransferred(address(0), msgSender);
818     }
819 
820     /**
821      * @dev Returns the address of the current owner.
822      */
823     function owner() public view virtual returns (address) {
824         return _owner;
825     }
826 
827     /**
828      * @dev Throws if called by any account other than the owner.
829      */
830     modifier onlyOwner() {
831         require(owner() == _msgSender(), "Ownable: caller is not the owner");
832         _;
833     }
834 
835     /**
836      * @dev Leaves the contract without owner. It will not be possible to call
837      * `onlyOwner` functions anymore. Can only be called by the current owner.
838      *
839      * NOTE: Renouncing ownership will leave the contract without an owner,
840      * thereby removing any functionality that is only available to the owner.
841      */
842 
843     /**
844      * @dev Transfers ownership of the contract to a new account (`newOwner`).
845      * Can only be called by the current owner.
846      */
847     function transferOwnership(address newOwner) public virtual onlyOwner {
848         require(newOwner != address(0), "Ownable: new owner is the zero address");
849         _setOwner(newOwner);
850     }
851 
852     function _setOwner(address newOwner) private {
853         address oldOwner = _owner;
854         _owner = newOwner;
855         emit OwnershipTransferred(oldOwner, newOwner);
856     }
857 }
858 
859 pragma solidity ^0.8.0;
860 
861 /**
862  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
863  * the Metadata extension, but not including the Enumerable extension, which is available separately as
864  * {ERC721Enumerable}.
865  */
866 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
867     using Address for address;
868     using Strings for uint256;
869 
870     // Token name
871     string private _name;
872 
873     // Token symbol
874     string private _symbol;
875 
876     // Mapping from token ID to owner address
877     mapping(uint256 => address) private _owners;
878 
879     // Mapping owner address to token count
880     mapping(address => uint256) private _balances;
881 
882     // Mapping from token ID to approved address
883     mapping(uint256 => address) private _tokenApprovals;
884 
885     // Mapping from owner to operator approvals
886     mapping(address => mapping(address => bool)) private _operatorApprovals;
887 
888 
889     string public _baseURI;
890     /**
891      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
892      */
893     constructor(string memory name_, string memory symbol_) {
894         _name = name_;
895         _symbol = symbol_;
896     }
897 
898     /**
899      * @dev See {IERC165-supportsInterface}.
900      */
901     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
902         return
903             interfaceId == type(IERC721).interfaceId ||
904             interfaceId == type(IERC721Metadata).interfaceId ||
905             super.supportsInterface(interfaceId);
906     }
907 
908     /**
909      * @dev See {IERC721-balanceOf}.
910      */
911     function balanceOf(address owner) public view virtual override returns (uint256) {
912         require(owner != address(0), "ERC721: balance query for the zero address");
913         return _balances[owner];
914     }
915 
916     /**
917      * @dev See {IERC721-ownerOf}.
918      */
919     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
920         address owner = _owners[tokenId];
921         require(owner != address(0), "ERC721: owner query for nonexistent token");
922         return owner;
923     }
924 
925     /**
926      * @dev See {IERC721Metadata-name}.
927      */
928     function name() public view virtual override returns (string memory) {
929         return _name;
930     }
931 
932     /**
933      * @dev See {IERC721Metadata-symbol}.
934      */
935     function symbol() public view virtual override returns (string memory) {
936         return _symbol;
937     }
938 
939     /**
940      * @dev See {IERC721Metadata-tokenURI}.
941      */
942     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
943         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
944 
945         string memory base = baseURI();
946         return bytes(base).length > 0 ? string(abi.encodePacked(base, tokenId.toString())) : "";
947     }
948 
949     /**
950      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
951      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
952      * by default, can be overriden in child contracts.
953      */
954     function baseURI() internal view virtual returns (string memory) {
955         return _baseURI;
956     }
957 
958     /**
959      * @dev See {IERC721-approve}.
960      */
961     function approve(address to, uint256 tokenId) public virtual override {
962         address owner = ERC721.ownerOf(tokenId);
963         require(to != owner, "ERC721: approval to current owner");
964 
965         require(
966             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
967             "ERC721: approve caller is not owner nor approved for all"
968         );
969 
970         _approve(to, tokenId);
971     }
972 
973     /**
974      * @dev See {IERC721-getApproved}.
975      */
976     function getApproved(uint256 tokenId) public view virtual override returns (address) {
977         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
978 
979         return _tokenApprovals[tokenId];
980     }
981 
982     /**
983      * @dev See {IERC721-setApprovalForAll}.
984      */
985     function setApprovalForAll(address operator, bool approved) public virtual override {
986         require(operator != _msgSender(), "ERC721: approve to caller");
987 
988         _operatorApprovals[_msgSender()][operator] = approved;
989         emit ApprovalForAll(_msgSender(), operator, approved);
990     }
991 
992     /**
993      * @dev See {IERC721-isApprovedForAll}.
994      */
995     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
996         return _operatorApprovals[owner][operator];
997     }
998 
999     /**
1000      * @dev See {IERC721-transferFrom}.
1001      */
1002     function transferFrom(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) public virtual override {
1007         //solhint-disable-next-line max-line-length
1008         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1009 
1010         _transfer(from, to, tokenId);
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-safeTransferFrom}.
1015      */
1016     function safeTransferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) public virtual override {
1021         safeTransferFrom(from, to, tokenId, "");
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-safeTransferFrom}.
1026      */
1027     function safeTransferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId,
1031         bytes memory _data
1032     ) public virtual override {
1033         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1034         _safeTransfer(from, to, tokenId, _data);
1035     }
1036 
1037     /**
1038      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1039      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1040      *
1041      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1042      *
1043      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1044      * implement alternative mechanisms to perform token transfer, such as signature-based.
1045      *
1046      * Requirements:
1047      *
1048      * - `from` cannot be the zero address.
1049      * - `to` cannot be the zero address.
1050      * - `tokenId` token must exist and be owned by `from`.
1051      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _safeTransfer(
1056         address from,
1057         address to,
1058         uint256 tokenId,
1059         bytes memory _data
1060     ) internal virtual {
1061         _transfer(from, to, tokenId);
1062         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1063     }
1064 
1065     /**
1066      * @dev Returns whether `tokenId` exists.
1067      *
1068      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1069      *
1070      * Tokens start existing when they are minted (`_mint`),
1071      * and stop existing when they are burned (`_burn`).
1072      */
1073     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1074         return _owners[tokenId] != address(0);
1075     }
1076 
1077     /**
1078      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1079      *
1080      * Requirements:
1081      *
1082      * - `tokenId` must exist.
1083      */
1084     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1085         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1086         address owner = ERC721.ownerOf(tokenId);
1087         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1088     }
1089 
1090     /**
1091      * @dev Safely mints `tokenId` and transfers it to `to`.
1092      *
1093      * Requirements:
1094      *
1095      * - `tokenId` must not exist.
1096      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function _safeMint(address to, uint256 tokenId) internal virtual {
1101         _safeMint(to, tokenId, "");
1102     }
1103 
1104     /**
1105      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1106      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1107      */
1108     function _safeMint(
1109         address to,
1110         uint256 tokenId,
1111         bytes memory _data
1112     ) internal virtual {
1113         _mint(to, tokenId);
1114         require(
1115             _checkOnERC721Received(address(0), to, tokenId, _data),
1116             "ERC721: transfer to non ERC721Receiver implementer"
1117         );
1118     }
1119 
1120     /**
1121      * @dev Mints `tokenId` and transfers it to `to`.
1122      *
1123      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1124      *
1125      * Requirements:
1126      *
1127      * - `tokenId` must not exist.
1128      * - `to` cannot be the zero address.
1129      *
1130      * Emits a {Transfer} event.
1131      */
1132     function _mint(address to, uint256 tokenId) internal virtual {
1133         require(to != address(0), "ERC721: mint to the zero address");
1134         require(!_exists(tokenId), "ERC721: token already minted");
1135 
1136         _beforeTokenTransfer(address(0), to, tokenId);
1137 
1138         _balances[to] += 1;
1139         _owners[tokenId] = to;
1140 
1141         emit Transfer(address(0), to, tokenId);
1142     }
1143 
1144     /**
1145      * @dev Destroys `tokenId`.
1146      * The approval is cleared when the token is burned.
1147      *
1148      * Requirements:
1149      *
1150      * - `tokenId` must exist.
1151      *
1152      * Emits a {Transfer} event.
1153      */
1154     function _burn(uint256 tokenId) internal virtual {
1155         address owner = ERC721.ownerOf(tokenId);
1156 
1157         _beforeTokenTransfer(owner, address(0), tokenId);
1158 
1159         // Clear approvals
1160         _approve(address(0), tokenId);
1161 
1162         _balances[owner] -= 1;
1163         delete _owners[tokenId];
1164 
1165         emit Transfer(owner, address(0), tokenId);
1166     }
1167 
1168     /**
1169      * @dev Transfers `tokenId` from `from` to `to`.
1170      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1171      *
1172      * Requirements:
1173      *
1174      * - `to` cannot be the zero address.
1175      * - `tokenId` token must be owned by `from`.
1176      *
1177      * Emits a {Transfer} event.
1178      */
1179     function _transfer(
1180         address from,
1181         address to,
1182         uint256 tokenId
1183     ) internal virtual {
1184         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1185         require(to != address(0), "ERC721: transfer to the zero address");
1186 
1187         _beforeTokenTransfer(from, to, tokenId);
1188 
1189         // Clear approvals from the previous owner
1190         _approve(address(0), tokenId);
1191 
1192         _balances[from] -= 1;
1193         _balances[to] += 1;
1194         _owners[tokenId] = to;
1195 
1196         emit Transfer(from, to, tokenId);
1197     }
1198 
1199     /**
1200      * @dev Approve `to` to operate on `tokenId`
1201      *
1202      * Emits a {Approval} event.
1203      */
1204     function _approve(address to, uint256 tokenId) internal virtual {
1205         _tokenApprovals[tokenId] = to;
1206         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1207     }
1208 
1209     /**
1210      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1211      * The call is not executed if the target address is not a contract.
1212      *
1213      * @param from address representing the previous owner of the given token ID
1214      * @param to target address that will receive the tokens
1215      * @param tokenId uint256 ID of the token to be transferred
1216      * @param _data bytes optional data to send along with the call
1217      * @return bool whether the call correctly returned the expected magic value
1218      */
1219     function _checkOnERC721Received(
1220         address from,
1221         address to,
1222         uint256 tokenId,
1223         bytes memory _data
1224     ) private returns (bool) {
1225         if (to.isContract()) {
1226             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1227                 return retval == IERC721Receiver(to).onERC721Received.selector;
1228             } catch (bytes memory reason) {
1229                 if (reason.length == 0) {
1230                     revert("ERC721: transfer to non ERC721Receiver implementer");
1231                 } else {
1232                     assembly {
1233                         revert(add(32, reason), mload(reason))
1234                     }
1235                 }
1236             }
1237         } else {
1238             return true;
1239         }
1240     }
1241 
1242     /**
1243      * @dev Hook that is called before any token transfer. This includes minting
1244      * and burning.
1245      *
1246      * Calling conditions:
1247      *
1248      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1249      * transferred to `to`.
1250      * - When `from` is zero, `tokenId` will be minted for `to`.
1251      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1252      * - `from` and `to` are never both zero.
1253      *
1254      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1255      */
1256     function _beforeTokenTransfer(
1257         address from,
1258         address to,
1259         uint256 tokenId
1260     ) internal virtual {}
1261 }
1262 
1263 pragma solidity ^0.8.0;
1264 
1265 /**
1266  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1267  * enumerability of all the token ids in the contract as well as all token ids owned by each
1268  * account.
1269  */
1270 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1271     // Mapping from owner to list of owned token IDs
1272     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1273 
1274     // Mapping from token ID to index of the owner tokens list
1275     mapping(uint256 => uint256) private _ownedTokensIndex;
1276 
1277     // Array with all token ids, used for enumeration
1278     uint256[] private _allTokens;
1279 
1280     // Mapping from token id to position in the allTokens array
1281     mapping(uint256 => uint256) private _allTokensIndex;
1282 
1283     /**
1284      * @dev See {IERC165-supportsInterface}.
1285      */
1286     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1287         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1288     }
1289 
1290     /**
1291      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1292      */
1293     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1294         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1295         return _ownedTokens[owner][index];
1296     }
1297 
1298     /**
1299      * @dev See {IERC721Enumerable-totalSupply}.
1300      */
1301     function totalSupply() public view virtual override returns (uint256) {
1302         return _allTokens.length;
1303     }
1304 
1305     /**
1306      * @dev See {IERC721Enumerable-tokenByIndex}.
1307      */
1308     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1309         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1310         return _allTokens[index];
1311     }
1312 
1313     /**
1314      * @dev Hook that is called before any token transfer. This includes minting
1315      * and burning.
1316      *
1317      * Calling conditions:
1318      *
1319      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1320      * transferred to `to`.
1321      * - When `from` is zero, `tokenId` will be minted for `to`.
1322      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1323      * - `from` cannot be the zero address.
1324      * - `to` cannot be the zero address.
1325      *
1326      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1327      */
1328     function _beforeTokenTransfer(
1329         address from,
1330         address to,
1331         uint256 tokenId
1332     ) internal virtual override {
1333         super._beforeTokenTransfer(from, to, tokenId);
1334 
1335         if (from == address(0)) {
1336             _addTokenToAllTokensEnumeration(tokenId);
1337         } else if (from != to) {
1338             _removeTokenFromOwnerEnumeration(from, tokenId);
1339         }
1340         if (to == address(0)) {
1341             _removeTokenFromAllTokensEnumeration(tokenId);
1342         } else if (to != from) {
1343             _addTokenToOwnerEnumeration(to, tokenId);
1344         }
1345     }
1346 
1347     /**
1348      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1349      * @param to address representing the new owner of the given token ID
1350      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1351      */
1352     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1353         uint256 length = ERC721.balanceOf(to);
1354         _ownedTokens[to][length] = tokenId;
1355         _ownedTokensIndex[tokenId] = length;
1356     }
1357 
1358     /**
1359      * @dev Private function to add a token to this extension's token tracking data structures.
1360      * @param tokenId uint256 ID of the token to be added to the tokens list
1361      */
1362     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1363         _allTokensIndex[tokenId] = _allTokens.length;
1364         _allTokens.push(tokenId);
1365     }
1366 
1367     /**
1368      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1369      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1370      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1371      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1372      * @param from address representing the previous owner of the given token ID
1373      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1374      */
1375     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1376         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1377         // then delete the last slot (swap and pop).
1378 
1379         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1380         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1381 
1382         // When the token to delete is the last token, the swap operation is unnecessary
1383         if (tokenIndex != lastTokenIndex) {
1384             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1385 
1386             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1387             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1388         }
1389 
1390         // This also deletes the contents at the last position of the array
1391         delete _ownedTokensIndex[tokenId];
1392         delete _ownedTokens[from][lastTokenIndex];
1393     }
1394 
1395     /**
1396      * @dev Private function to remove a token from this extension's token tracking data structures.
1397      * This has O(1) time complexity, but alters the order of the _allTokens array.
1398      * @param tokenId uint256 ID of the token to be removed from the tokens list
1399      */
1400     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1401         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1402         // then delete the last slot (swap and pop).
1403 
1404         uint256 lastTokenIndex = _allTokens.length - 1;
1405         uint256 tokenIndex = _allTokensIndex[tokenId];
1406 
1407         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1408         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1409         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1410         uint256 lastTokenId = _allTokens[lastTokenIndex];
1411 
1412         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1413         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1414 
1415         // This also deletes the contents at the last position of the array
1416         delete _allTokensIndex[tokenId];
1417         _allTokens.pop();
1418     }
1419 }
1420 
1421 pragma solidity ^0.8.0;
1422 
1423 contract  NAKEDMETAS  is ERC721Enumerable, Ownable
1424 {
1425     using SafeMath for uint256;
1426 
1427     struct userAddress {
1428         address userAddress;
1429         uint counter;
1430     }
1431 
1432     uint public constant _TOTALSUPPLY   = 10000;
1433     uint private tokenId                = 1;
1434     uint public reserve                 = 250;
1435 
1436     uint public freeSaleSupply          = 2500;
1437     uint public freeSaleMaxQuantity     = 2;
1438     bool public isfreeSalePaused        = true;
1439     mapping(address => userAddress) public _freeSaleAddresses;
1440     mapping(address => bool) public _freeSaleAddressExist;
1441 
1442     uint256 public preSaleTwoprice      = 0.06 ether;
1443     uint public preSaleTwoSupply        = 2500;
1444     uint public preSaleTwoMaxQuantity   = 10;
1445     bool public isPreSaleTwoPaused      = true;
1446     mapping(address => userAddress) public _preSaleTwoAddresses;
1447     mapping(address => bool) public _preSaleTwoAddressExist;
1448 
1449     uint256 public publicSaleprice      = 0.07 ether;
1450     uint public publicSaleSupply        = 1900;
1451     uint public publicSaleMaxQuantity   = 10;
1452     bool public isPublicSalePaused      = true;
1453     mapping(address => userAddress) public _publicAddresses;
1454     mapping(address => bool) public _publicAddressExist;
1455 
1456     constructor(string memory baseURI) ERC721("Naked Metas", "NMetas")  {
1457         setBaseURI(baseURI);
1458     }
1459     
1460     function setBaseURI(string memory baseURI) public onlyOwner {
1461         _baseURI = baseURI;
1462     }
1463     
1464     function totalsupply() private view returns (uint) {
1465         return tokenId;
1466     }
1467 
1468     modifier isSaleOpen {
1469         require(totalSupply() < _TOTALSUPPLY, "Sale Ended");
1470         _;
1471     }
1472 
1473     // Set Price Functions For Public, PreSaleOne & PreSaleTwo
1474     function setPublicPrice(uint256 _newPrice) public onlyOwner() {
1475         publicSaleprice = _newPrice;
1476     }
1477    
1478     function setPreSaleTwoPrice(uint256 _newPrice) public onlyOwner() {
1479         preSaleTwoprice = _newPrice;
1480     }
1481 
1482     // Flip Status Functions For Free, Public, PreSaleOne & PreSaleTwo
1483     function flipFreeSalePauseStatus() public onlyOwner {
1484         isfreeSalePaused = !isfreeSalePaused;
1485     }
1486     function flipPublicSalePauseStatus() public onlyOwner {
1487         isPublicSalePaused = !isPublicSalePaused;
1488     }
1489     function flipPreSaleTwoPauseStatus() public onlyOwner {
1490         isPreSaleTwoPaused = !isPreSaleTwoPaused;
1491     }
1492 
1493     // Set Max Quantity Functions For Free, Public, PreSaleOne & PreSaleTwo
1494     function setFreeSaleMaxQuantity(uint256 _quantity) public onlyOwner {
1495         freeSaleMaxQuantity =_quantity;
1496     }
1497     function setPublicSaleMaxQuantity(uint256 _quantity) public onlyOwner {
1498         publicSaleMaxQuantity =_quantity;
1499     }
1500     function setPreSaleTwoMaxQuantity(uint256 _quantity) public onlyOwner {
1501         preSaleTwoMaxQuantity =_quantity;
1502     }
1503 
1504     // Set Price Functions For Public, PreSaleOne & PreSaleTwo
1505     function getPublicPrice(uint256 _quantity) public view returns (uint256) { 
1506         return _quantity * publicSaleprice;
1507     }
1508     
1509     function getPreSaleTwoPrice(uint256 _quantity) public view returns (uint256) { 
1510         return _quantity * preSaleTwoprice;
1511     }
1512 
1513     // Mint Functions For Free, Public, PreSaleOne & PreSaleTwo
1514     function freeMint(uint chosenAmount) public payable isSaleOpen {
1515         if (_freeSaleAddressExist[msg.sender] == false) {
1516             _freeSaleAddresses[msg.sender] = userAddress({
1517                 userAddress: msg.sender,
1518                 counter: 0
1519             });
1520             _freeSaleAddressExist[msg.sender] = true;
1521         }
1522         require(freeSaleSupply > 0, "Public sale ended");
1523         require(freeSaleSupply > chosenAmount, "Chosen amount is greater than supply");
1524         require(_freeSaleAddresses[msg.sender].counter + chosenAmount <= freeSaleMaxQuantity, "Quantity must be lesser than MaxSupply");
1525         require(isfreeSalePaused == false, "Sale is not active at the moment");
1526         require(totalSupply() + chosenAmount <= _TOTALSUPPLY - reserve, "Quantity must be lesser then MaxSupply");
1527         require(chosenAmount > 0, "Number of tokens can not be less than or equal to 0");
1528         require(chosenAmount <= freeSaleMaxQuantity, "Chosen Amount exceeds MaxQuantity");
1529         for (uint i = 0; i < chosenAmount; i++) {
1530             _safeMint(msg.sender, totalsupply());
1531             tokenId++;
1532             freeSaleSupply--;
1533         }
1534         _freeSaleAddresses[msg.sender].counter += chosenAmount;
1535     }
1536     function mint(uint chosenAmount) public payable isSaleOpen {
1537         if (_publicAddressExist[msg.sender] == false) {
1538             _publicAddresses[msg.sender] = userAddress({
1539                 userAddress: msg.sender,
1540                 counter: 0
1541             });
1542             _publicAddressExist[msg.sender] = true;
1543         }
1544         require(publicSaleSupply > 0, "Public sale ended");
1545         require(publicSaleSupply > chosenAmount, "Chosen amount is greater than supply");
1546         require(_publicAddresses[msg.sender].counter + chosenAmount <= publicSaleMaxQuantity, "Quantity must be lesser than MaxSupply");
1547         require(isPublicSalePaused == false, "Sale is not active at the moment");
1548         require(totalSupply() + chosenAmount <= _TOTALSUPPLY - reserve, "Quantity must be lesser then MaxSupply");
1549         require(chosenAmount > 0, "Number of tokens can not be less than or equal to 0");
1550         require(chosenAmount <= publicSaleMaxQuantity, "Chosen Amount exceeds MaxQuantity");
1551         require(publicSaleprice.mul(chosenAmount) == msg.value, "Sent ether value is incorrect");
1552         for (uint i = 0; i < chosenAmount; i++) {
1553             _safeMint(msg.sender, totalsupply());
1554             tokenId++;
1555             publicSaleSupply--;
1556         }
1557         _publicAddresses[msg.sender].counter += chosenAmount;
1558     }
1559     function preSaleTwoMint(uint chosenAmount) public payable isSaleOpen {
1560         if (_preSaleTwoAddressExist[msg.sender] == false) {
1561             _preSaleTwoAddresses[msg.sender] = userAddress({
1562                 userAddress: msg.sender,
1563                 counter: 0
1564             });
1565             _preSaleTwoAddressExist[msg.sender] = true;
1566         }
1567         require(preSaleTwoSupply > 0, "Pre sale two ended");
1568         require(preSaleTwoSupply > chosenAmount, "Chosen amount is greater than supply");
1569         require(_preSaleTwoAddresses[msg.sender].counter + chosenAmount <= preSaleTwoMaxQuantity, "Quantity must be lesser than MaxSupply");
1570         require(isPreSaleTwoPaused == false, "Sale is not active at the moment");
1571         require(totalSupply() + chosenAmount <= _TOTALSUPPLY - reserve, "Quantity must be lesser then MaxSupply");
1572         require(chosenAmount > 0, "Number of tokens can not be less than or equal to 0");
1573         require(chosenAmount <= preSaleTwoMaxQuantity, "Chosen Amount exceeds MaxQuantity");
1574         require(preSaleTwoprice.mul(chosenAmount) == msg.value, "Sent ether value is incorrect");
1575         for (uint i = 0; i < chosenAmount; i++) {
1576             _safeMint(msg.sender, totalsupply());
1577             tokenId++;
1578             preSaleTwoSupply--;
1579         }
1580         _preSaleTwoAddresses[msg.sender].counter += chosenAmount;
1581     }
1582 
1583     
1584     function setReserveTokens(uint256 _quantity) public onlyOwner {
1585         reserve=_quantity;
1586     }
1587     function reserveTokens(uint quantity) public onlyOwner {
1588         require(quantity <= reserve, "The quantity exceeds the reserve.");
1589         reserve -= quantity;
1590         for (uint i = 0; i < quantity; i++) {
1591             _safeMint(msg.sender,totalsupply());
1592             tokenId++;
1593         }
1594     }
1595     function tokensOfOwner(address _owner) public view returns (uint256[] memory) {
1596         uint256 count = balanceOf(_owner);
1597         uint256[] memory result = new uint256[](count);
1598         for (uint256 index = 0; index < count; index++) {
1599             result[index] = tokenOfOwnerByIndex(_owner, index);
1600         }
1601         return result;
1602     }
1603     function withdraw() public onlyOwner {
1604         uint balance = address(this).balance;
1605         payable(msg.sender).transfer(balance);
1606     }
1607 }