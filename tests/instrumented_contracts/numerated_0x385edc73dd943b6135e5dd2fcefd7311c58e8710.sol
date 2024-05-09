1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 // CAUTION
6 // This version of SafeMath should only be used with Solidity 0.8 or later,
7 // because it relies on the compiler's built in overflow checks.
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations.
11  *
12  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
13  * now has built in overflow checking.
14  */
15 library SafeMath {
16     /**
17      * @dev Returns the addition of two unsigned integers, with an overflow flag.
18      *
19      * _Available since v3.4._
20      */
21     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
22         unchecked {
23             uint256 c = a + b;
24             if (c < a) return (false, 0);
25             return (true, c);
26         }
27     }
28 
29     /**
30      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {
36             if (b > a) return (false, 0);
37             return (true, a - b);
38         }
39     }
40 
41     /**
42      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
43      *
44      * _Available since v3.4._
45      */
46     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {
48             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49             // benefit is lost if 'b' is also tested.
50             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51             if (a == 0) return (true, 0);
52             uint256 c = a * b;
53             if (c / a != b) return (false, 0);
54             return (true, c);
55         }
56     }
57 
58     /**
59      * @dev Returns the division of two unsigned integers, with a division by zero flag.
60      *
61      * _Available since v3.4._
62      */
63     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             if (b == 0) return (false, 0);
66             return (true, a / b);
67         }
68     }
69 
70     /**
71      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
72      *
73      * _Available since v3.4._
74      */
75     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         unchecked {
77             if (b == 0) return (false, 0);
78             return (true, a % b);
79         }
80     }
81 
82     /**
83      * @dev Returns the addition of two unsigned integers, reverting on
84      * overflow.
85      *
86      * Counterpart to Solidity's `+` operator.
87      *
88      * Requirements:
89      *
90      * - Addition cannot overflow.
91      */
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         return a + b;
94     }
95 
96     /**
97      * @dev Returns the subtraction of two unsigned integers, reverting on
98      * overflow (when the result is negative).
99      *
100      * Counterpart to Solidity's `-` operator.
101      *
102      * Requirements:
103      *
104      * - Subtraction cannot overflow.
105      */
106     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107         return a - b;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `*` operator.
115      *
116      * Requirements:
117      *
118      * - Multiplication cannot overflow.
119      */
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         return a * b;
122     }
123 
124     /**
125      * @dev Returns the integer division of two unsigned integers, reverting on
126      * division by zero. The result is rounded towards zero.
127      *
128      * Counterpart to Solidity's `/` operator.
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return a / b;
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * reverting when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
151         return a % b;
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
156      * overflow (when the result is negative).
157      *
158      * CAUTION: This function is deprecated because it requires allocating memory for the error
159      * message unnecessarily. For custom revert reasons use {trySub}.
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(
168         uint256 a,
169         uint256 b,
170         string memory errorMessage
171     ) internal pure returns (uint256) {
172         unchecked {
173             require(b <= a, errorMessage);
174             return a - b;
175         }
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `%` operator. This function uses a `revert`
183      * opcode (which leaves remaining gas untouched) while Solidity uses an
184      * invalid opcode to revert (consuming all remaining gas).
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
238     bytes16 private constant alphabet = '0123456789abcdef';
239 
240     /**
241      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
242      */
243     function toString(uint256 value) internal pure returns (string memory) {
244         // Inspired by OraclizeAPI's implementation - MIT licence
245         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
246 
247         if (value == 0) {
248             return '0';
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
270             return '0x00';
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
286         buffer[0] = '0';
287         buffer[1] = 'x';
288         for (uint256 i = 2 * length + 1; i > 1; --i) {
289             buffer[i] = alphabet[value & 0xf];
290             value >>= 4;
291         }
292         require(value == 0, 'Strings: hex length insufficient');
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
326         // solhint-disable-next-line no-inline-assembly
327         assembly {
328             size := extcodesize(account)
329         }
330         return size > 0;
331     }
332 
333     /**
334      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
335      * `recipient`, forwarding all available gas and reverting on errors.
336      *
337      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
338      * of certain opcodes, possibly making contracts go over the 2300 gas limit
339      * imposed by `transfer`, making them unable to receive funds via
340      * `transfer`. {sendValue} removes this limitation.
341      *
342      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
343      *
344      * IMPORTANT: because control is transferred to `recipient`, care must be
345      * taken to not create reentrancy vulnerabilities. Consider using
346      * {ReentrancyGuard} or the
347      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
348      */
349     function sendValue(address payable recipient, uint256 amount) internal {
350         require(address(this).balance >= amount, 'Address: insufficient balance');
351 
352         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
353         (bool success, ) = recipient.call{value: amount}('');
354         require(success, 'Address: unable to send value, recipient may have reverted');
355     }
356 
357     /**
358      * @dev Performs a Solidity function call using a low level `call`. A
359      * plain`call` is an unsafe replacement for a function call: use this
360      * function instead.
361      *
362      * If `target` reverts with a revert reason, it is bubbled up by this
363      * function (like regular Solidity function calls).
364      *
365      * Returns the raw returned data. To convert to the expected return value,
366      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
367      *
368      * Requirements:
369      *
370      * - `target` must be a contract.
371      * - calling `target` with `data` must not revert.
372      *
373      * _Available since v3.1._
374      */
375     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
376         return functionCall(target, data, 'Address: low-level call failed');
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
381      * `errorMessage` as a fallback revert reason when `target` reverts.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, 0, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but also transferring `value` wei to `target`.
396      *
397      * Requirements:
398      *
399      * - the calling contract must have an ETH balance of at least `value`.
400      * - the called Solidity function must be `payable`.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(
405         address target,
406         bytes memory data,
407         uint256 value
408     ) internal returns (bytes memory) {
409         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
414      * with `errorMessage` as a fallback revert reason when `target` reverts.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         require(address(this).balance >= value, 'Address: insufficient balance for call');
425         require(isContract(target), 'Address: call to non-contract');
426 
427         // solhint-disable-next-line avoid-low-level-calls
428         (bool success, bytes memory returndata) = target.call{value: value}(data);
429         return _verifyCallResult(success, returndata, errorMessage);
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434      * but performing a static call.
435      *
436      * _Available since v3.3._
437      */
438     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
439         return functionStaticCall(target, data, 'Address: low-level static call failed');
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
444      * but performing a static call.
445      *
446      * _Available since v3.3._
447      */
448     function functionStaticCall(
449         address target,
450         bytes memory data,
451         string memory errorMessage
452     ) internal view returns (bytes memory) {
453         require(isContract(target), 'Address: static call to non-contract');
454 
455         // solhint-disable-next-line avoid-low-level-calls
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
467         return functionDelegateCall(target, data, 'Address: low-level delegate call failed');
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
481         require(isContract(target), 'Address: delegate call to non-contract');
482 
483         // solhint-disable-next-line avoid-low-level-calls
484         (bool success, bytes memory returndata) = target.delegatecall(data);
485         return _verifyCallResult(success, returndata, errorMessage);
486     }
487 
488     function _verifyCallResult(
489         bool success,
490         bytes memory returndata,
491         string memory errorMessage
492     ) private pure returns (bytes memory) {
493         if (success) {
494             return returndata;
495         } else {
496             // Look for revert reason and bubble it up if present
497             if (returndata.length > 0) {
498                 // The easiest way to bubble the revert reason is using memory via assembly
499 
500                 // solhint-disable-next-line no-inline-assembly
501                 assembly {
502                     let returndata_size := mload(returndata)
503                     revert(add(32, returndata), returndata_size)
504                 }
505             } else {
506                 revert(errorMessage);
507             }
508         }
509     }
510 }
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @title ERC721 token receiver interface
516  * @dev Interface for any contract that wants to support safeTransfers
517  * from ERC721 asset contracts.
518  */
519 interface IERC721Receiver {
520     /**
521      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
522      * by `operator` from `from`, this function is called.
523      *
524      * It must return its Solidity selector to confirm the token transfer.
525      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
526      *
527      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
528      */
529     function onERC721Received(
530         address operator,
531         address from,
532         uint256 tokenId,
533         bytes calldata data
534     ) external returns (bytes4);
535 }
536 
537 pragma solidity ^0.8.0;
538 
539 /**
540  * @dev Interface of the ERC165 standard, as defined in the
541  * https://eips.ethereum.org/EIPS/eip-165[EIP].
542  *
543  * Implementers can declare support of contract interfaces, which can then be
544  * queried by others ({ERC165Checker}).
545  *
546  * For an implementation, see {ERC165}.
547  */
548 interface IERC165 {
549     /**
550      * @dev Returns true if this contract implements the interface defined by
551      * `interfaceId`. See the corresponding
552      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
553      * to learn more about how these ids are created.
554      *
555      * This function call must use less than 30 000 gas.
556      */
557     function supportsInterface(bytes4 interfaceId) external view returns (bool);
558 }
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @dev Implementation of the {IERC165} interface.
564  *
565  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
566  * for the additional interface id that will be supported. For example:
567  *
568  * ```solidity
569  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
570  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
571  * }
572  * ```
573  *
574  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
575  */
576 abstract contract ERC165 is IERC165 {
577     /**
578      * @dev See {IERC165-supportsInterface}.
579      */
580     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
581         return interfaceId == type(IERC165).interfaceId;
582     }
583 }
584 
585 pragma solidity ^0.8.0;
586 
587 /**
588  * @dev Required interface of an ERC721 compliant contract.
589  */
590 interface IERC721 is IERC165 {
591     /**
592      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
593      */
594     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
595 
596     /**
597      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
598      */
599     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
600 
601     /**
602      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
603      */
604     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
605 
606     /**
607      * @dev Returns the number of tokens in ``owner``'s account.
608      */
609     function balanceOf(address owner) external view returns (uint256 balance);
610 
611     /**
612      * @dev Returns the owner of the `tokenId` token.
613      *
614      * Requirements:
615      *
616      * - `tokenId` must exist.
617      */
618     function ownerOf(uint256 tokenId) external view returns (address owner);
619 
620     /**
621      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
622      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
623      *
624      * Requirements:
625      *
626      * - `from` cannot be the zero address.
627      * - `to` cannot be the zero address.
628      * - `tokenId` token must exist and be owned by `from`.
629      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
630      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
631      *
632      * Emits a {Transfer} event.
633      */
634     function safeTransferFrom(
635         address from,
636         address to,
637         uint256 tokenId
638     ) external;
639 
640     /**
641      * @dev Transfers `tokenId` token from `from` to `to`.
642      *
643      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
644      *
645      * Requirements:
646      *
647      * - `from` cannot be the zero address.
648      * - `to` cannot be the zero address.
649      * - `tokenId` token must be owned by `from`.
650      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
651      *
652      * Emits a {Transfer} event.
653      */
654     function transferFrom(
655         address from,
656         address to,
657         uint256 tokenId
658     ) external;
659 
660     /**
661      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
662      * The approval is cleared when the token is transferred.
663      *
664      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
665      *
666      * Requirements:
667      *
668      * - The caller must own the token or be an approved operator.
669      * - `tokenId` must exist.
670      *
671      * Emits an {Approval} event.
672      */
673     function approve(address to, uint256 tokenId) external;
674 
675     /**
676      * @dev Returns the account approved for `tokenId` token.
677      *
678      * Requirements:
679      *
680      * - `tokenId` must exist.
681      */
682     function getApproved(uint256 tokenId) external view returns (address operator);
683 
684     /**
685      * @dev Approve or remove `operator` as an operator for the caller.
686      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
687      *
688      * Requirements:
689      *
690      * - The `operator` cannot be the caller.
691      *
692      * Emits an {ApprovalForAll} event.
693      */
694     function setApprovalForAll(address operator, bool _approved) external;
695 
696     /**
697      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
698      *
699      * See {setApprovalForAll}
700      */
701     function isApprovedForAll(address owner, address operator) external view returns (bool);
702 
703     /**
704      * @dev Safely transfers `tokenId` token from `from` to `to`.
705      *
706      * Requirements:
707      *
708      * - `from` cannot be the zero address.
709      * - `to` cannot be the zero address.
710      * - `tokenId` token must exist and be owned by `from`.
711      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
712      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
713      *
714      * Emits a {Transfer} event.
715      */
716     function safeTransferFrom(
717         address from,
718         address to,
719         uint256 tokenId,
720         bytes calldata data
721     ) external;
722 }
723 
724 pragma solidity ^0.8.0;
725 
726 /**
727  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
728  * @dev See https://eips.ethereum.org/EIPS/eip-721
729  */
730 interface IERC721Enumerable is IERC721 {
731     /**
732      * @dev Returns the total amount of tokens stored by the contract.
733      */
734     function totalSupply() external view returns (uint256);
735 
736     /**
737      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
738      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
739      */
740     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
741 
742     /**
743      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
744      * Use along with {totalSupply} to enumerate all tokens.
745      */
746     function tokenByIndex(uint256 index) external view returns (uint256);
747 }
748 
749 pragma solidity ^0.8.0;
750 
751 /**
752  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
753  * @dev See https://eips.ethereum.org/EIPS/eip-721
754  */
755 interface IERC721Metadata is IERC721 {
756     /**
757      * @dev Returns the token collection name.
758      */
759     function name() external view returns (string memory);
760 
761     /**
762      * @dev Returns the token collection symbol.
763      */
764     function symbol() external view returns (string memory);
765 
766     /**
767      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
768      */
769     function tokenURI(uint256 tokenId) external view returns (string memory);
770 }
771 
772 pragma solidity ^0.8.0;
773 
774 /*
775  * @dev Provides information about the current execution context, including the
776  * sender of the transaction and its data. While these are generally available
777  * via msg.sender and msg.data, they should not be accessed in such a direct
778  * manner, since when dealing with meta-transactions the account sending and
779  * paying for execution may not be the actual sender (as far as an application
780  * is concerned).
781  *
782  * This contract is only required for intermediate, library-like contracts.
783  */
784 abstract contract Context {
785     function _msgSender() internal view virtual returns (address) {
786         return msg.sender;
787     }
788 
789     function _msgData() internal view virtual returns (bytes calldata) {
790         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
791         return msg.data;
792     }
793 }
794 
795 pragma solidity ^0.8.0;
796 
797 /**
798  * @dev Contract module which provides a basic access control mechanism, where
799  * there is an account (an owner) that can be granted exclusive access to
800  * specific functions.
801  *
802  * By default, the owner account will be the one that deploys the contract. This
803  * can later be changed with {transferOwnership}.
804  *
805  * This module is used through inheritance. It will make available the modifier
806  * `onlyOwner`, which can be applied to your functions to restrict their use to
807  * the owner.
808  */
809 abstract contract Ownable is Context {
810     address private _owner;
811 
812     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
813 
814     /**
815      * @dev Initializes the contract setting the deployer as the initial owner.
816      */
817     constructor() {
818         address msgSender = _msgSender();
819         _owner = msgSender;
820         emit OwnershipTransferred(address(0), msgSender);
821     }
822 
823     /**
824      * @dev Returns the address of the current owner.
825      */
826     function owner() public view virtual returns (address) {
827         return _owner;
828     }
829 
830     /**
831      * @dev Throws if called by any account other than the owner.
832      */
833     modifier onlyOwner() {
834         require(owner() == _msgSender(), 'Ownable: caller is not the owner');
835         _;
836     }
837 
838     /**
839      * @dev Leaves the contract without owner. It will not be possible to call
840      * `onlyOwner` functions anymore. Can only be called by the current owner.
841      *
842      * NOTE: Renouncing ownership will leave the contract without an owner,
843      * thereby removing any functionality that is only available to the owner.
844      */
845     function renounceOwnership() public virtual onlyOwner {
846         emit OwnershipTransferred(_owner, address(0));
847         _owner = address(0);
848     }
849 
850     /**
851      * @dev Transfers ownership of the contract to a new account (`newOwner`).
852      * Can only be called by the current owner.
853      */
854     function transferOwnership(address newOwner) public virtual onlyOwner {
855         require(newOwner != address(0), 'Ownable: new owner is the zero address');
856         emit OwnershipTransferred(_owner, newOwner);
857         _owner = newOwner;
858     }
859 }
860 
861 pragma solidity ^0.8.0;
862 
863 /**
864  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
865  * the Metadata extension, but not including the Enumerable extension, which is available separately as
866  * {ERC721Enumerable}.
867  */
868 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
869     using Address for address;
870     using Strings for uint256;
871 
872     // Token name
873     string private _name;
874 
875     // Token symbol
876     string private _symbol;
877 
878     // Mapping from token ID to owner address
879     mapping(uint256 => address) private _owners;
880 
881     // Mapping owner address to token count
882     mapping(address => uint256) private _balances;
883 
884     // Mapping from token ID to approved address
885     mapping(uint256 => address) private _tokenApprovals;
886 
887     // Mapping from owner to operator approvals
888     mapping(address => mapping(address => bool)) private _operatorApprovals;
889 
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
912         require(owner != address(0), 'ERC721: balance query for the zero address');
913         return _balances[owner];
914     }
915 
916     /**
917      * @dev See {IERC721-ownerOf}.
918      */
919     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
920         address owner = _owners[tokenId];
921         require(owner != address(0), 'ERC721: owner query for nonexistent token');
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
943         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
944 
945         string memory baseURI = _baseURI();
946         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
947     }
948 
949     /**
950      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
951      * in child contracts.
952      */
953     function _baseURI() internal view virtual returns (string memory) {
954         return '';
955     }
956 
957     /**
958      * @dev See {IERC721-approve}.
959      */
960     function approve(address to, uint256 tokenId) public virtual override {
961         address owner = ERC721.ownerOf(tokenId);
962         require(to != owner, 'ERC721: approval to current owner');
963 
964         require(
965             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
966             'ERC721: approve caller is not owner nor approved for all'
967         );
968 
969         _approve(to, tokenId);
970     }
971 
972     /**
973      * @dev See {IERC721-getApproved}.
974      */
975     function getApproved(uint256 tokenId) public view virtual override returns (address) {
976         require(_exists(tokenId), 'ERC721: approved query for nonexistent token');
977 
978         return _tokenApprovals[tokenId];
979     }
980 
981     /**
982      * @dev See {IERC721-setApprovalForAll}.
983      */
984     function setApprovalForAll(address operator, bool approved) public virtual override {
985         require(operator != _msgSender(), 'ERC721: approve to caller');
986 
987         _operatorApprovals[_msgSender()][operator] = approved;
988         emit ApprovalForAll(_msgSender(), operator, approved);
989     }
990 
991     /**
992      * @dev See {IERC721-isApprovedForAll}.
993      */
994     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
995         return _operatorApprovals[owner][operator];
996     }
997 
998     /**
999      * @dev See {IERC721-transferFrom}.
1000      */
1001     function transferFrom(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) public virtual override {
1006         //solhint-disable-next-line max-line-length
1007         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
1008 
1009         _transfer(from, to, tokenId);
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-safeTransferFrom}.
1014      */
1015     function safeTransferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) public virtual override {
1020         safeTransferFrom(from, to, tokenId, '');
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-safeTransferFrom}.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId,
1030         bytes memory _data
1031     ) public virtual override {
1032         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
1033         _safeTransfer(from, to, tokenId, _data);
1034     }
1035 
1036     /**
1037      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1038      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1039      *
1040      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1041      *
1042      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1043      * implement alternative mechanisms to perform token transfer, such as signature-based.
1044      *
1045      * Requirements:
1046      *
1047      * - `from` cannot be the zero address.
1048      * - `to` cannot be the zero address.
1049      * - `tokenId` token must exist and be owned by `from`.
1050      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1051      *
1052      * Emits a {Transfer} event.
1053      */
1054     function _safeTransfer(
1055         address from,
1056         address to,
1057         uint256 tokenId,
1058         bytes memory _data
1059     ) internal virtual {
1060         _transfer(from, to, tokenId);
1061         require(_checkOnERC721Received(from, to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
1062     }
1063 
1064     /**
1065      * @dev Returns whether `tokenId` exists.
1066      *
1067      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1068      *
1069      * Tokens start existing when they are minted (`_mint`),
1070      * and stop existing when they are burned (`_burn`).
1071      */
1072     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1073         return _owners[tokenId] != address(0);
1074     }
1075 
1076     /**
1077      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1078      *
1079      * Requirements:
1080      *
1081      * - `tokenId` must exist.
1082      */
1083     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1084         require(_exists(tokenId), 'ERC721: operator query for nonexistent token');
1085         address owner = ERC721.ownerOf(tokenId);
1086         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1087     }
1088 
1089     /**
1090      * @dev Safely mints `tokenId` and transfers it to `to`.
1091      *
1092      * Requirements:
1093      *
1094      * - `tokenId` must not exist.
1095      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function _safeMint(address to, uint256 tokenId) internal virtual {
1100         _safeMint(to, tokenId, '');
1101     }
1102 
1103     /**
1104      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1105      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1106      */
1107     function _safeMint(
1108         address to,
1109         uint256 tokenId,
1110         bytes memory _data
1111     ) internal virtual {
1112         _mint(to, tokenId);
1113         require(
1114             _checkOnERC721Received(address(0), to, tokenId, _data),
1115             'ERC721: transfer to non ERC721Receiver implementer'
1116         );
1117     }
1118 
1119     /**
1120      * @dev Mints `tokenId` and transfers it to `to`.
1121      *
1122      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1123      *
1124      * Requirements:
1125      *
1126      * - `tokenId` must not exist.
1127      * - `to` cannot be the zero address.
1128      *
1129      * Emits a {Transfer} event.
1130      */
1131     function _mint(address to, uint256 tokenId) internal virtual {
1132         require(to != address(0), 'ERC721: mint to the zero address');
1133         require(!_exists(tokenId), 'ERC721: token already minted');
1134 
1135         _beforeTokenTransfer(address(0), to, tokenId);
1136 
1137         _balances[to] += 1;
1138         _owners[tokenId] = to;
1139 
1140         emit Transfer(address(0), to, tokenId);
1141     }
1142 
1143     /**
1144      * @dev Destroys `tokenId`.
1145      * The approval is cleared when the token is burned.
1146      *
1147      * Requirements:
1148      *
1149      * - `tokenId` must exist.
1150      *
1151      * Emits a {Transfer} event.
1152      */
1153     function _burn(uint256 tokenId) internal virtual {
1154         address owner = ERC721.ownerOf(tokenId);
1155 
1156         _beforeTokenTransfer(owner, address(0), tokenId);
1157 
1158         // Clear approvals
1159         _approve(address(0), tokenId);
1160 
1161         _balances[owner] -= 1;
1162         delete _owners[tokenId];
1163 
1164         emit Transfer(owner, address(0), tokenId);
1165     }
1166 
1167     /**
1168      * @dev Transfers `tokenId` from `from` to `to`.
1169      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1170      *
1171      * Requirements:
1172      *
1173      * - `to` cannot be the zero address.
1174      * - `tokenId` token must be owned by `from`.
1175      *
1176      * Emits a {Transfer} event.
1177      */
1178     function _transfer(
1179         address from,
1180         address to,
1181         uint256 tokenId
1182     ) internal virtual {
1183         require(ERC721.ownerOf(tokenId) == from, 'ERC721: transfer of token that is not own');
1184         require(to != address(0), 'ERC721: transfer to the zero address');
1185 
1186         _beforeTokenTransfer(from, to, tokenId);
1187 
1188         // Clear approvals from the previous owner
1189         _approve(address(0), tokenId);
1190 
1191         _balances[from] -= 1;
1192         _balances[to] += 1;
1193         _owners[tokenId] = to;
1194 
1195         emit Transfer(from, to, tokenId);
1196     }
1197 
1198     /**
1199      * @dev Approve `to` to operate on `tokenId`
1200      *
1201      * Emits a {Approval} event.
1202      */
1203     function _approve(address to, uint256 tokenId) internal virtual {
1204         _tokenApprovals[tokenId] = to;
1205         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1206     }
1207 
1208     /**
1209      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1210      * The call is not executed if the target address is not a contract.
1211      *
1212      * @param from address representing the previous owner of the given token ID
1213      * @param to target address that will receive the tokens
1214      * @param tokenId uint256 ID of the token to be transferred
1215      * @param _data bytes optional data to send along with the call
1216      * @return bool whether the call correctly returned the expected magic value
1217      */
1218     function _checkOnERC721Received(
1219         address from,
1220         address to,
1221         uint256 tokenId,
1222         bytes memory _data
1223     ) private returns (bool) {
1224         if (to.isContract()) {
1225             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1226                 return retval == IERC721Receiver(to).onERC721Received.selector;
1227             } catch (bytes memory reason) {
1228                 if (reason.length == 0) {
1229                     revert('ERC721: transfer to non ERC721Receiver implementer');
1230                 } else {
1231                     // solhint-disable-next-line no-inline-assembly
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
1252      * - `from` cannot be the zero address.
1253      * - `to` cannot be the zero address.
1254      *
1255      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1256      */
1257     function _beforeTokenTransfer(
1258         address from,
1259         address to,
1260         uint256 tokenId
1261     ) internal virtual {}
1262 }
1263 
1264 pragma solidity ^0.8.0;
1265 
1266 /**
1267  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1268  * enumerability of all the token ids in the contract as well as all token ids owned by each
1269  * account.
1270  */
1271 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1272     // Mapping from owner to list of owned token IDs
1273     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1274 
1275     // Mapping from token ID to index of the owner tokens list
1276     mapping(uint256 => uint256) private _ownedTokensIndex;
1277 
1278     // Array with all token ids, used for enumeration
1279     uint256[] private _allTokens;
1280 
1281     // Mapping from token id to position in the allTokens array
1282     mapping(uint256 => uint256) private _allTokensIndex;
1283 
1284     /**
1285      * @dev See {IERC165-supportsInterface}.
1286      */
1287     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1288         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1289     }
1290 
1291     /**
1292      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1293      */
1294     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1295         require(index < ERC721.balanceOf(owner), 'ERC721Enumerable: owner index out of bounds');
1296         return _ownedTokens[owner][index];
1297     }
1298 
1299     /**
1300      * @dev See {IERC721Enumerable-totalSupply}.
1301      */
1302     function totalSupply() public view virtual override returns (uint256) {
1303         return _allTokens.length;
1304     }
1305 
1306     /**
1307      * @dev See {IERC721Enumerable-tokenByIndex}.
1308      */
1309     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1310         require(index < ERC721Enumerable.totalSupply(), 'ERC721Enumerable: global index out of bounds');
1311         return _allTokens[index];
1312     }
1313 
1314     /**
1315      * @dev Hook that is called before any token transfer. This includes minting
1316      * and burning.
1317      *
1318      * Calling conditions:
1319      *
1320      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1321      * transferred to `to`.
1322      * - When `from` is zero, `tokenId` will be minted for `to`.
1323      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1324      * - `from` cannot be the zero address.
1325      * - `to` cannot be the zero address.
1326      *
1327      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1328      */
1329     function _beforeTokenTransfer(
1330         address from,
1331         address to,
1332         uint256 tokenId
1333     ) internal virtual override {
1334         super._beforeTokenTransfer(from, to, tokenId);
1335 
1336         if (from == address(0)) {
1337             _addTokenToAllTokensEnumeration(tokenId);
1338         } else if (from != to) {
1339             _removeTokenFromOwnerEnumeration(from, tokenId);
1340         }
1341         if (to == address(0)) {
1342             _removeTokenFromAllTokensEnumeration(tokenId);
1343         } else if (to != from) {
1344             _addTokenToOwnerEnumeration(to, tokenId);
1345         }
1346     }
1347 
1348     /**
1349      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1350      * @param to address representing the new owner of the given token ID
1351      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1352      */
1353     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1354         uint256 length = ERC721.balanceOf(to);
1355         _ownedTokens[to][length] = tokenId;
1356         _ownedTokensIndex[tokenId] = length;
1357     }
1358 
1359     /**
1360      * @dev Private function to add a token to this extension's token tracking data structures.
1361      * @param tokenId uint256 ID of the token to be added to the tokens list
1362      */
1363     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1364         _allTokensIndex[tokenId] = _allTokens.length;
1365         _allTokens.push(tokenId);
1366     }
1367 
1368     /**
1369      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1370      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1371      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1372      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1373      * @param from address representing the previous owner of the given token ID
1374      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1375      */
1376     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1377         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1378         // then delete the last slot (swap and pop).
1379 
1380         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1381         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1382 
1383         // When the token to delete is the last token, the swap operation is unnecessary
1384         if (tokenIndex != lastTokenIndex) {
1385             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1386 
1387             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1388             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1389         }
1390 
1391         // This also deletes the contents at the last position of the array
1392         delete _ownedTokensIndex[tokenId];
1393         delete _ownedTokens[from][lastTokenIndex];
1394     }
1395 
1396     /**
1397      * @dev Private function to remove a token from this extension's token tracking data structures.
1398      * This has O(1) time complexity, but alters the order of the _allTokens array.
1399      * @param tokenId uint256 ID of the token to be removed from the tokens list
1400      */
1401     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1402         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1403         // then delete the last slot (swap and pop).
1404 
1405         uint256 lastTokenIndex = _allTokens.length - 1;
1406         uint256 tokenIndex = _allTokensIndex[tokenId];
1407 
1408         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1409         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1410         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1411         uint256 lastTokenId = _allTokens[lastTokenIndex];
1412 
1413         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1414         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1415 
1416         // This also deletes the contents at the last position of the array
1417         delete _allTokensIndex[tokenId];
1418         _allTokens.pop();
1419     }
1420 }
1421 
1422 pragma solidity ^0.8.0;
1423 
1424 contract SillyOldBear is ERC721Enumerable, Ownable {
1425     using SafeMath for uint256;
1426     using Address for address;
1427     using Strings for uint256;
1428 
1429     uint256 public constant NFT_PRICE = 64000000000000000; // 0.08 ETH
1430     uint public constant MAX_NFT_PURCHASE = 20;
1431     uint256 public MAX_SUPPLY = 10000;
1432     bool public saleIsActive = false;
1433 
1434     string private _baseURIExtended;
1435     mapping(uint256 => string) _tokenURIs;
1436     mapping(address => bool) minted;
1437     mapping(address => uint256) purchased;
1438 
1439     modifier mintOnlyOnce() {
1440         require(!minted[_msgSender()], 'Can only mint once');
1441         minted[_msgSender()] = true;
1442         _;
1443     }
1444 
1445     constructor() ERC721('Silly Old Bear', 'SOB') {}
1446 
1447     function flipSaleState() public onlyOwner {
1448         saleIsActive = !saleIsActive;
1449     }
1450 
1451     function withdraw() public onlyOwner {
1452         uint256 balance = address(this).balance;
1453         payable(msg.sender).transfer(balance);
1454     }
1455 
1456 
1457     function mintSOB(uint numberOfTokens) public payable {
1458         require(purchased[msg.sender].add(numberOfTokens) <= MAX_NFT_PURCHASE, 'Can only mint up to 20 per address');
1459         require(saleIsActive, 'Sale is not active at the moment');
1460         require(numberOfTokens > 0, "Number of tokens can not be less than or equal to 0");
1461         require(totalSupply().add(numberOfTokens) <= MAX_SUPPLY, "Purchase would exceed max supply of tokens");
1462         require(numberOfTokens <= MAX_NFT_PURCHASE,"Can only mint up to 20 per purchase");
1463         require(NFT_PRICE.mul(numberOfTokens) == msg.value, "Sent ether value is incorrect");
1464         purchased[msg.sender] = purchased[msg.sender].add(numberOfTokens);
1465         for (uint i = 0; i < numberOfTokens; i++) {
1466             _safeMint(msg.sender, totalSupply());
1467         }
1468     }
1469 
1470     function mintSOBForFree() public mintOnlyOnce {
1471         require(saleIsActive, 'Sale is not active at the moment');
1472         require(totalSupply().add(1) <= MAX_SUPPLY, 'Purchase would exceed max supply of tokens');
1473         _safeMint(msg.sender, totalSupply());
1474     }
1475     function reserveTokens() public onlyOwner {
1476         uint supply = totalSupply();
1477         uint i;
1478         for (i = 0; i < 30; i++) {
1479             _safeMint(msg.sender, supply + i);
1480         }
1481     }
1482 
1483     function _baseURI() internal view virtual override returns (string memory) {
1484         return _baseURIExtended;
1485     }
1486 
1487     // Sets base URI for all tokens, only able to be called by contract owner
1488     function setBaseURI(string memory baseURI_) external onlyOwner {
1489         _baseURIExtended = baseURI_;
1490     }
1491 
1492     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1493         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1494 
1495         string memory _tokenURI = _tokenURIs[tokenId];
1496         string memory base = _baseURI();
1497 
1498         // If there is no base URI, return the token URI.
1499         if (bytes(base).length == 0) {
1500             return _tokenURI;
1501         }
1502         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1503         if (bytes(_tokenURI).length > 0) {
1504             return string(abi.encodePacked(base, _tokenURI));
1505         }
1506         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1507         return string(abi.encodePacked(base, tokenId.toString()));
1508     }
1509 }