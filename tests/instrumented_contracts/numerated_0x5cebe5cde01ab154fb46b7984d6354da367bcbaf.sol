1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 // CAUTION
79 // This version of SafeMath should only be used with Solidity 0.8 or later,
80 // because it relies on the compiler's built in overflow checks.
81 
82 /**
83  * @dev Wrappers over Solidity's arithmetic operations.
84  *
85  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
86  * now has built in overflow checking.
87  */
88 library SafeMath {
89     /**
90      * @dev Returns the addition of two unsigned integers, with an overflow flag.
91      *
92      * _Available since v3.4._
93      */
94     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
95         unchecked {
96             uint256 c = a + b;
97             if (c < a) return (false, 0);
98             return (true, c);
99         }
100     }
101 
102     /**
103      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
104      *
105      * _Available since v3.4._
106      */
107     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
108         unchecked {
109             if (b > a) return (false, 0);
110             return (true, a - b);
111         }
112     }
113 
114     /**
115      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
116      *
117      * _Available since v3.4._
118      */
119     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
120         unchecked {
121             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
122             // benefit is lost if 'b' is also tested.
123             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
124             if (a == 0) return (true, 0);
125             uint256 c = a * b;
126             if (c / a != b) return (false, 0);
127             return (true, c);
128         }
129     }
130 
131     /**
132      * @dev Returns the division of two unsigned integers, with a division by zero flag.
133      *
134      * _Available since v3.4._
135      */
136     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
137         unchecked {
138             if (b == 0) return (false, 0);
139             return (true, a / b);
140         }
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
145      *
146      * _Available since v3.4._
147      */
148     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
149         unchecked {
150             if (b == 0) return (false, 0);
151             return (true, a % b);
152         }
153     }
154 
155     /**
156      * @dev Returns the addition of two unsigned integers, reverting on
157      * overflow.
158      *
159      * Counterpart to Solidity's `+` operator.
160      *
161      * Requirements:
162      *
163      * - Addition cannot overflow.
164      */
165     function add(uint256 a, uint256 b) internal pure returns (uint256) {
166         return a + b;
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting on
171      * overflow (when the result is negative).
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      *
177      * - Subtraction cannot overflow.
178      */
179     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
180         return a - b;
181     }
182 
183     /**
184      * @dev Returns the multiplication of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `*` operator.
188      *
189      * Requirements:
190      *
191      * - Multiplication cannot overflow.
192      */
193     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194         return a * b;
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers, reverting on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator.
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b) internal pure returns (uint256) {
208         return a / b;
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213      * reverting when dividing by zero.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
224         return a % b;
225     }
226 
227     /**
228      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
229      * overflow (when the result is negative).
230      *
231      * CAUTION: This function is deprecated because it requires allocating memory for the error
232      * message unnecessarily. For custom revert reasons use {trySub}.
233      *
234      * Counterpart to Solidity's `-` operator.
235      *
236      * Requirements:
237      *
238      * - Subtraction cannot overflow.
239      */
240     function sub(
241         uint256 a,
242         uint256 b,
243         string memory errorMessage
244     ) internal pure returns (uint256) {
245         unchecked {
246             require(b <= a, errorMessage);
247             return a - b;
248         }
249     }
250 
251     /**
252      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
253      * division by zero. The result is rounded towards zero.
254      *
255      * Counterpart to Solidity's `/` operator. Note: this function uses a
256      * `revert` opcode (which leaves remaining gas untouched) while Solidity
257      * uses an invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function div(
264         uint256 a,
265         uint256 b,
266         string memory errorMessage
267     ) internal pure returns (uint256) {
268         unchecked {
269             require(b > 0, errorMessage);
270             return a / b;
271         }
272     }
273 
274     /**
275      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
276      * reverting with custom message when dividing by zero.
277      *
278      * CAUTION: This function is deprecated because it requires allocating memory for the error
279      * message unnecessarily. For custom revert reasons use {tryMod}.
280      *
281      * Counterpart to Solidity's `%` operator. This function uses a `revert`
282      * opcode (which leaves remaining gas untouched) while Solidity uses an
283      * invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function mod(
290         uint256 a,
291         uint256 b,
292         string memory errorMessage
293     ) internal pure returns (uint256) {
294         unchecked {
295             require(b > 0, errorMessage);
296             return a % b;
297         }
298     }
299 }
300 
301 // File: contracts/Blimpie/IERC721Batch.sol
302 
303 
304 
305 pragma solidity ^0.8.0;
306 
307 interface IERC721Batch {
308   function isOwnerOf( address account, uint[] calldata tokenIds ) external view returns( bool );
309   function transferBatch( address from, address to, uint[] calldata tokenIds, bytes calldata data ) external;
310   function walletOfOwner( address account ) external view returns( uint[] memory );
311 }
312 // File: @openzeppelin/contracts/utils/Address.sol
313 
314 
315 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 /**
320  * @dev Collection of functions related to the address type
321  */
322 library Address {
323     /**
324      * @dev Returns true if `account` is a contract.
325      *
326      * [IMPORTANT]
327      * ====
328      * It is unsafe to assume that an address for which this function returns
329      * false is an externally-owned account (EOA) and not a contract.
330      *
331      * Among others, `isContract` will return false for the following
332      * types of addresses:
333      *
334      *  - an externally-owned account
335      *  - a contract in construction
336      *  - an address where a contract will be created
337      *  - an address where a contract lived, but was destroyed
338      * ====
339      */
340     function isContract(address account) internal view returns (bool) {
341         // This method relies on extcodesize, which returns 0 for contracts in
342         // construction, since the code is only stored at the end of the
343         // constructor execution.
344 
345         uint256 size;
346         assembly {
347             size := extcodesize(account)
348         }
349         return size > 0;
350     }
351 
352     /**
353      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
354      * `recipient`, forwarding all available gas and reverting on errors.
355      *
356      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
357      * of certain opcodes, possibly making contracts go over the 2300 gas limit
358      * imposed by `transfer`, making them unable to receive funds via
359      * `transfer`. {sendValue} removes this limitation.
360      *
361      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
362      *
363      * IMPORTANT: because control is transferred to `recipient`, care must be
364      * taken to not create reentrancy vulnerabilities. Consider using
365      * {ReentrancyGuard} or the
366      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
367      */
368     function sendValue(address payable recipient, uint256 amount) internal {
369         require(address(this).balance >= amount, "Address: insufficient balance");
370 
371         (bool success, ) = recipient.call{value: amount}("");
372         require(success, "Address: unable to send value, recipient may have reverted");
373     }
374 
375     /**
376      * @dev Performs a Solidity function call using a low level `call`. A
377      * plain `call` is an unsafe replacement for a function call: use this
378      * function instead.
379      *
380      * If `target` reverts with a revert reason, it is bubbled up by this
381      * function (like regular Solidity function calls).
382      *
383      * Returns the raw returned data. To convert to the expected return value,
384      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
385      *
386      * Requirements:
387      *
388      * - `target` must be a contract.
389      * - calling `target` with `data` must not revert.
390      *
391      * _Available since v3.1._
392      */
393     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
394         return functionCall(target, data, "Address: low-level call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
399      * `errorMessage` as a fallback revert reason when `target` reverts.
400      *
401      * _Available since v3.1._
402      */
403     function functionCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, 0, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but also transferring `value` wei to `target`.
414      *
415      * Requirements:
416      *
417      * - the calling contract must have an ETH balance of at least `value`.
418      * - the called Solidity function must be `payable`.
419      *
420      * _Available since v3.1._
421      */
422     function functionCallWithValue(
423         address target,
424         bytes memory data,
425         uint256 value
426     ) internal returns (bytes memory) {
427         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
432      * with `errorMessage` as a fallback revert reason when `target` reverts.
433      *
434      * _Available since v3.1._
435      */
436     function functionCallWithValue(
437         address target,
438         bytes memory data,
439         uint256 value,
440         string memory errorMessage
441     ) internal returns (bytes memory) {
442         require(address(this).balance >= value, "Address: insufficient balance for call");
443         require(isContract(target), "Address: call to non-contract");
444 
445         (bool success, bytes memory returndata) = target.call{value: value}(data);
446         return verifyCallResult(success, returndata, errorMessage);
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
451      * but performing a static call.
452      *
453      * _Available since v3.3._
454      */
455     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
456         return functionStaticCall(target, data, "Address: low-level static call failed");
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
461      * but performing a static call.
462      *
463      * _Available since v3.3._
464      */
465     function functionStaticCall(
466         address target,
467         bytes memory data,
468         string memory errorMessage
469     ) internal view returns (bytes memory) {
470         require(isContract(target), "Address: static call to non-contract");
471 
472         (bool success, bytes memory returndata) = target.staticcall(data);
473         return verifyCallResult(success, returndata, errorMessage);
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
478      * but performing a delegate call.
479      *
480      * _Available since v3.4._
481      */
482     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
483         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
488      * but performing a delegate call.
489      *
490      * _Available since v3.4._
491      */
492     function functionDelegateCall(
493         address target,
494         bytes memory data,
495         string memory errorMessage
496     ) internal returns (bytes memory) {
497         require(isContract(target), "Address: delegate call to non-contract");
498 
499         (bool success, bytes memory returndata) = target.delegatecall(data);
500         return verifyCallResult(success, returndata, errorMessage);
501     }
502 
503     /**
504      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
505      * revert reason using the provided one.
506      *
507      * _Available since v4.3._
508      */
509     function verifyCallResult(
510         bool success,
511         bytes memory returndata,
512         string memory errorMessage
513     ) internal pure returns (bytes memory) {
514         if (success) {
515             return returndata;
516         } else {
517             // Look for revert reason and bubble it up if present
518             if (returndata.length > 0) {
519                 // The easiest way to bubble the revert reason is using memory via assembly
520 
521                 assembly {
522                     let returndata_size := mload(returndata)
523                     revert(add(32, returndata), returndata_size)
524                 }
525             } else {
526                 revert(errorMessage);
527             }
528         }
529     }
530 }
531 
532 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 /**
540  * @title ERC721 token receiver interface
541  * @dev Interface for any contract that wants to support safeTransfers
542  * from ERC721 asset contracts.
543  */
544 interface IERC721Receiver {
545     /**
546      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
547      * by `operator` from `from`, this function is called.
548      *
549      * It must return its Solidity selector to confirm the token transfer.
550      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
551      *
552      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
553      */
554     function onERC721Received(
555         address operator,
556         address from,
557         uint256 tokenId,
558         bytes calldata data
559     ) external returns (bytes4);
560 }
561 
562 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
563 
564 
565 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 /**
570  * @dev Interface of the ERC165 standard, as defined in the
571  * https://eips.ethereum.org/EIPS/eip-165[EIP].
572  *
573  * Implementers can declare support of contract interfaces, which can then be
574  * queried by others ({ERC165Checker}).
575  *
576  * For an implementation, see {ERC165}.
577  */
578 interface IERC165 {
579     /**
580      * @dev Returns true if this contract implements the interface defined by
581      * `interfaceId`. See the corresponding
582      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
583      * to learn more about how these ids are created.
584      *
585      * This function call must use less than 30 000 gas.
586      */
587     function supportsInterface(bytes4 interfaceId) external view returns (bool);
588 }
589 
590 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
591 
592 
593 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 
598 /**
599  * @dev Implementation of the {IERC165} interface.
600  *
601  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
602  * for the additional interface id that will be supported. For example:
603  *
604  * ```solidity
605  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
606  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
607  * }
608  * ```
609  *
610  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
611  */
612 abstract contract ERC165 is IERC165 {
613     /**
614      * @dev See {IERC165-supportsInterface}.
615      */
616     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
617         return interfaceId == type(IERC165).interfaceId;
618     }
619 }
620 
621 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
622 
623 
624 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
625 
626 pragma solidity ^0.8.0;
627 
628 
629 /**
630  * @dev Required interface of an ERC721 compliant contract.
631  */
632 interface IERC721 is IERC165 {
633     /**
634      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
635      */
636     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
637 
638     /**
639      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
640      */
641     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
642 
643     /**
644      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
645      */
646     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
647 
648     /**
649      * @dev Returns the number of tokens in ``owner``'s account.
650      */
651     function balanceOf(address owner) external view returns (uint256 balance);
652 
653     /**
654      * @dev Returns the owner of the `tokenId` token.
655      *
656      * Requirements:
657      *
658      * - `tokenId` must exist.
659      */
660     function ownerOf(uint256 tokenId) external view returns (address owner);
661 
662     /**
663      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
664      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
665      *
666      * Requirements:
667      *
668      * - `from` cannot be the zero address.
669      * - `to` cannot be the zero address.
670      * - `tokenId` token must exist and be owned by `from`.
671      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
672      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
673      *
674      * Emits a {Transfer} event.
675      */
676     function safeTransferFrom(
677         address from,
678         address to,
679         uint256 tokenId
680     ) external;
681 
682     /**
683      * @dev Transfers `tokenId` token from `from` to `to`.
684      *
685      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
686      *
687      * Requirements:
688      *
689      * - `from` cannot be the zero address.
690      * - `to` cannot be the zero address.
691      * - `tokenId` token must be owned by `from`.
692      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
693      *
694      * Emits a {Transfer} event.
695      */
696     function transferFrom(
697         address from,
698         address to,
699         uint256 tokenId
700     ) external;
701 
702     /**
703      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
704      * The approval is cleared when the token is transferred.
705      *
706      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
707      *
708      * Requirements:
709      *
710      * - The caller must own the token or be an approved operator.
711      * - `tokenId` must exist.
712      *
713      * Emits an {Approval} event.
714      */
715     function approve(address to, uint256 tokenId) external;
716 
717     /**
718      * @dev Returns the account approved for `tokenId` token.
719      *
720      * Requirements:
721      *
722      * - `tokenId` must exist.
723      */
724     function getApproved(uint256 tokenId) external view returns (address operator);
725 
726     /**
727      * @dev Approve or remove `operator` as an operator for the caller.
728      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
729      *
730      * Requirements:
731      *
732      * - The `operator` cannot be the caller.
733      *
734      * Emits an {ApprovalForAll} event.
735      */
736     function setApprovalForAll(address operator, bool _approved) external;
737 
738     /**
739      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
740      *
741      * See {setApprovalForAll}
742      */
743     function isApprovedForAll(address owner, address operator) external view returns (bool);
744 
745     /**
746      * @dev Safely transfers `tokenId` token from `from` to `to`.
747      *
748      * Requirements:
749      *
750      * - `from` cannot be the zero address.
751      * - `to` cannot be the zero address.
752      * - `tokenId` token must exist and be owned by `from`.
753      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
754      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
755      *
756      * Emits a {Transfer} event.
757      */
758     function safeTransferFrom(
759         address from,
760         address to,
761         uint256 tokenId,
762         bytes calldata data
763     ) external;
764 }
765 
766 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
767 
768 
769 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
770 
771 pragma solidity ^0.8.0;
772 
773 
774 /**
775  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
776  * @dev See https://eips.ethereum.org/EIPS/eip-721
777  */
778 interface IERC721Enumerable is IERC721 {
779     /**
780      * @dev Returns the total amount of tokens stored by the contract.
781      */
782     function totalSupply() external view returns (uint256);
783 
784     /**
785      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
786      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
787      */
788     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
789 
790     /**
791      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
792      * Use along with {totalSupply} to enumerate all tokens.
793      */
794     function tokenByIndex(uint256 index) external view returns (uint256);
795 }
796 
797 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
798 
799 
800 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
801 
802 pragma solidity ^0.8.0;
803 
804 
805 /**
806  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
807  * @dev See https://eips.ethereum.org/EIPS/eip-721
808  */
809 interface IERC721Metadata is IERC721 {
810     /**
811      * @dev Returns the token collection name.
812      */
813     function name() external view returns (string memory);
814 
815     /**
816      * @dev Returns the token collection symbol.
817      */
818     function symbol() external view returns (string memory);
819 
820     /**
821      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
822      */
823     function tokenURI(uint256 tokenId) external view returns (string memory);
824 }
825 
826 // File: @openzeppelin/contracts/utils/Context.sol
827 
828 
829 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
830 
831 pragma solidity ^0.8.0;
832 
833 /**
834  * @dev Provides information about the current execution context, including the
835  * sender of the transaction and its data. While these are generally available
836  * via msg.sender and msg.data, they should not be accessed in such a direct
837  * manner, since when dealing with meta-transactions the account sending and
838  * paying for execution may not be the actual sender (as far as an application
839  * is concerned).
840  *
841  * This contract is only required for intermediate, library-like contracts.
842  */
843 abstract contract Context {
844     function _msgSender() internal view virtual returns (address) {
845         return msg.sender;
846     }
847 
848     function _msgData() internal view virtual returns (bytes calldata) {
849         return msg.data;
850     }
851 }
852 
853 // File: contracts/Blimpie/PaymentSplitterMod.sol
854 
855 
856 
857 pragma solidity ^0.8.0;
858 
859 
860 
861 
862 /**
863  * @title PaymentSplitter
864  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
865  * that the Ether will be split in this way, since it is handled transparently by the contract.
866  *
867  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
868  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
869  * an amount proportional to the percentage of total shares they were assigned.
870  *
871  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
872  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
873  * function.
874  */
875 contract PaymentSplitterMod is Context {
876     event PayeeAdded(address account, uint256 shares);
877     event PaymentReleased(address to, uint256 amount);
878     event PaymentReceived(address from, uint256 amount);
879 
880     uint256 private _totalShares;
881     uint256 private _totalReleased;
882 
883     mapping(address => uint256) private _shares;
884     mapping(address => uint256) private _released;
885     address[] private _payees;
886 
887     /**
888      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
889      * the matching position in the `shares` array.
890      *
891      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
892      * duplicates in `payees`.
893      */
894     constructor(address[] memory payees, uint256[] memory shares_) payable {
895         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
896         require(payees.length > 0, "PaymentSplitter: no payees");
897 
898         for (uint256 i = 0; i < payees.length; i++) {
899             _addPayee(payees[i], shares_[i]);
900         }
901     }
902 
903     /**
904      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
905      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
906      * reliability of the events, and not the actual splitting of Ether.
907      *
908      * To learn more about this see the Solidity documentation for
909      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
910      * functions].
911      */
912     receive() external payable {
913         emit PaymentReceived(_msgSender(), msg.value);
914     }
915 
916     /**
917      * @dev Getter for the total shares held by payees.
918      */
919     function totalShares() public view returns (uint256) {
920         return _totalShares;
921     }
922 
923     /**
924      * @dev Getter for the total amount of Ether already released.
925      */
926     function totalReleased() public view returns (uint256) {
927         return _totalReleased;
928     }
929 
930     /**
931      * @dev Getter for the amount of shares held by an account.
932      */
933     function shares(address account) public view returns (uint256) {
934         return _shares[account];
935     }
936 
937     /**
938      * @dev Getter for the amount of Ether already released to a payee.
939      */
940     function released(address account) public view returns (uint256) {
941         return _released[account];
942     }
943 
944     /**
945      * @dev Getter for the address of the payee number `index`.
946      */
947     function payee(uint256 index) public view returns (address) {
948         return _payees[index];
949     }
950 
951     /**
952      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
953      * total shares and their previous withdrawals.
954      */
955     function release(address payable account) public virtual {
956         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
957 
958         uint256 totalReceived = address(this).balance + _totalReleased;
959         uint256 payment = (totalReceived * _shares[account]) / _totalShares - _released[account];
960         require(payment != 0, "PaymentSplitter: account is not due payment");
961 
962         _released[account] = _released[account] + payment;
963         _totalReleased = _totalReleased + payment;
964 
965         Address.sendValue(account, payment);
966         emit PaymentReleased(account, payment);
967     }
968 
969     function _addPayee(address account, uint256 shares_) internal {
970         require(account != address(0), "PaymentSplitter: account is the zero address");
971         require(shares_ > 0, "PaymentSplitter: shares are 0");
972         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
973 
974         _payees.push(account);
975         _shares[account] = shares_;
976         _totalShares = _totalShares + shares_;
977         emit PayeeAdded(account, shares_);
978     }
979 
980     function _setPayee( uint index, address account, uint newShares ) internal {
981         _totalShares = _totalShares - _shares[ account ] + newShares;
982         _shares[ account ] = newShares;
983         _payees[ index ] = account;
984     }
985 }
986 // File: contracts/Blimpie/ERC721B.sol
987 
988 
989 
990 pragma solidity ^0.8.0;
991 
992 /****************************************
993  * @author: squeebo_nft                 *
994  * @team:   GoldenX                     *
995  ****************************************
996  *   Blimpie-ERC721 provides low-gas    *
997  *           mints + transfers          *
998  ****************************************/
999 
1000 
1001 
1002 
1003 
1004 
1005 
1006 abstract contract ERC721B is Context, ERC165, IERC721, IERC721Metadata {
1007     using Address for address;
1008 
1009     string private _name;
1010     string private _symbol;
1011 
1012     uint internal _burned;
1013     uint internal _offset;
1014     address[] internal _owners;
1015 
1016     mapping(uint => address) internal _tokenApprovals;
1017     mapping(address => mapping(address => bool)) private _operatorApprovals;
1018 
1019     constructor(string memory name_, string memory symbol_, uint offset) {
1020         _name = name_;
1021         _symbol = symbol_;
1022         _offset = offset;
1023         for(uint i; i < _offset; ++i ){
1024             _owners.push(address(0));
1025         }
1026     }
1027 
1028     //public
1029     function balanceOf(address owner) public view virtual override returns (uint) {
1030         require(owner != address(0), "ERC721: balance query for the zero address");
1031 
1032         uint count;
1033         for( uint i; i < _owners.length; ++i ){
1034           if( owner == _owners[i] )
1035             ++count;
1036         }
1037         return count;
1038     }
1039 
1040     function name() external view virtual override returns (string memory) {
1041         return _name;
1042     }
1043 
1044     function ownerOf(uint tokenId) public view virtual override returns (address) {
1045         address owner = _owners[tokenId];
1046         require(owner != address(0), "ERC721: owner query for nonexistent token");
1047         return owner;
1048     }
1049 
1050     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1051         return
1052             interfaceId == type(IERC721).interfaceId ||
1053             interfaceId == type(IERC721Metadata).interfaceId ||
1054             super.supportsInterface(interfaceId);
1055     }
1056 
1057     function symbol() external view virtual override returns (string memory) {
1058         return _symbol;
1059     }
1060 
1061     function totalSupply() public view virtual returns (uint) {
1062         return _owners.length - (_offset + _burned);
1063     }
1064 
1065 
1066     function approve(address to, uint tokenId) external virtual override {
1067         address owner = ERC721B.ownerOf(tokenId);
1068         require(to != owner, "ERC721: approval to current owner");
1069 
1070         require(
1071             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1072             "ERC721: approve caller is not owner nor approved for all"
1073         );
1074 
1075         _approve(to, tokenId);
1076     }
1077 
1078     function getApproved(uint tokenId) public view virtual override returns (address) {
1079         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1080         return _tokenApprovals[tokenId];
1081     }
1082 
1083     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1084         return _operatorApprovals[owner][operator];
1085     }
1086 
1087     function setApprovalForAll(address operator, bool approved) external virtual override {
1088         require(operator != _msgSender(), "ERC721: approve to caller");
1089         _operatorApprovals[_msgSender()][operator] = approved;
1090         emit ApprovalForAll(_msgSender(), operator, approved);
1091     }
1092 
1093     function transferFrom(
1094         address from,
1095         address to,
1096         uint tokenId
1097     ) public virtual override {
1098         //solhint-disable-next-line max-line-length
1099         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1100         _transfer(from, to, tokenId);
1101     }
1102 
1103     function safeTransferFrom(
1104         address from,
1105         address to,
1106         uint tokenId
1107     ) external virtual override {
1108         safeTransferFrom(from, to, tokenId, "");
1109     }
1110 
1111     function safeTransferFrom(
1112         address from,
1113         address to,
1114         uint tokenId,
1115         bytes memory _data
1116     ) public virtual override {
1117         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1118         _safeTransfer(from, to, tokenId, _data);
1119     }
1120 
1121 
1122     //internal
1123     function _approve(address to, uint tokenId) internal virtual {
1124         _tokenApprovals[tokenId] = to;
1125         emit Approval(ERC721B.ownerOf(tokenId), to, tokenId);
1126     }
1127 
1128     function _beforeTokenTransfer(
1129         address from,
1130         address to,
1131         uint tokenId
1132     ) internal virtual {}
1133 
1134     function _burn(uint tokenId) internal virtual {
1135         address owner = ERC721B.ownerOf(tokenId);
1136 
1137         _beforeTokenTransfer(owner, address(0), tokenId);
1138 
1139         // Clear approvals
1140         _approve(address(0), tokenId);
1141         _owners[tokenId] = address(0);
1142 
1143         emit Transfer(owner, address(0), tokenId);
1144     }
1145 
1146     function _checkOnERC721Received(
1147         address from,
1148         address to,
1149         uint tokenId,
1150         bytes memory _data
1151     ) private returns (bool) {
1152         if (to.isContract()) {
1153             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1154                 return retval == IERC721Receiver.onERC721Received.selector;
1155             } catch (bytes memory reason) {
1156                 if (reason.length == 0) {
1157                     revert("ERC721: transfer to non ERC721Receiver implementer");
1158                 } else {
1159                     assembly {
1160                         revert(add(32, reason), mload(reason))
1161                     }
1162                 }
1163             }
1164         } else {
1165             return true;
1166         }
1167     }
1168 
1169     function _exists(uint tokenId) internal view virtual returns (bool) {
1170         return tokenId < _owners.length && _owners[tokenId] != address(0);
1171     }
1172 
1173     function _isApprovedOrOwner(address spender, uint tokenId) internal view virtual returns (bool) {
1174         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1175         address owner = ERC721B.ownerOf(tokenId);
1176         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1177     }
1178 
1179     function _mint(address to, uint tokenId) internal virtual {
1180         require(to != address(0), "ERC721: mint to the zero address");
1181         require(!_exists(tokenId), "ERC721: token already minted");
1182 
1183         _beforeTokenTransfer(address(0), to, tokenId);
1184         _owners.push(to);
1185 
1186         emit Transfer(address(0), to, tokenId);
1187     }
1188 
1189     function _next() internal view virtual returns( uint ){
1190         return _owners.length;
1191     }
1192 
1193     function _safeMint(address to, uint tokenId) internal virtual {
1194         _safeMint(to, tokenId, "");
1195     }
1196 
1197     function _safeMint(
1198         address to,
1199         uint tokenId,
1200         bytes memory _data
1201     ) internal virtual {
1202         _mint(to, tokenId);
1203         require(
1204             _checkOnERC721Received(address(0), to, tokenId, _data),
1205             "ERC721: transfer to non ERC721Receiver implementer"
1206         );
1207     }
1208 
1209     function _safeTransfer(
1210         address from,
1211         address to,
1212         uint tokenId,
1213         bytes memory _data
1214     ) internal virtual {
1215         _transfer(from, to, tokenId);
1216         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1217     }
1218 
1219     function _transfer(
1220         address from,
1221         address to,
1222         uint tokenId
1223     ) internal virtual {
1224         require(ERC721B.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1225         require(to != address(0), "ERC721: transfer to the zero address");
1226 
1227         _beforeTokenTransfer(from, to, tokenId);
1228 
1229         // Clear approvals from the previous owner
1230         _approve(address(0), tokenId);
1231         _owners[tokenId] = to;
1232 
1233         emit Transfer(from, to, tokenId);
1234     }
1235 }
1236 // File: contracts/Blimpie/ERC721EnumerableLite.sol
1237 
1238 
1239 
1240 pragma solidity ^0.8.0;
1241 
1242 /****************************************
1243  * @author: squeebo_nft                 *
1244  ****************************************
1245  *   Blimpie-ERC721 provides low-gas    *
1246  *           mints + transfers          *
1247  ****************************************/
1248 
1249 
1250 
1251 
1252 abstract contract ERC721EnumerableLite is ERC721B, IERC721Batch, IERC721Enumerable {
1253     mapping(address => uint) internal _balances;
1254 
1255     function isOwnerOf( address account, uint[] calldata tokenIds ) external view virtual override returns( bool ){
1256         for(uint i; i < tokenIds.length; ++i ){
1257             if( _owners[ tokenIds[i] ] != account )
1258                 return false;
1259         }
1260 
1261         return true;
1262     }
1263 
1264     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721B) returns (bool) {
1265         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1266     }
1267 
1268     function tokenOfOwnerByIndex(address owner, uint index) public view override returns (uint tokenId) {
1269         uint count;
1270         for( uint i; i < _owners.length; ++i ){
1271             if( owner == _owners[i] ){
1272                 if( count == index )
1273                     return i;
1274                 else
1275                     ++count;
1276             }
1277         }
1278 
1279         revert("ERC721Enumerable: owner index out of bounds");
1280     }
1281 
1282     function tokenByIndex(uint index) external view virtual override returns (uint) {
1283         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
1284         return index;
1285     }
1286 
1287     function totalSupply() public view virtual override( ERC721B, IERC721Enumerable ) returns (uint) {
1288         return _owners.length - (_offset + _burned);
1289     }
1290 
1291     function transferBatch( address from, address to, uint[] calldata tokenIds, bytes calldata data ) external override{
1292         for(uint i; i < tokenIds.length; ++i ){
1293             safeTransferFrom( from, to, tokenIds[i], data );
1294         }
1295     }
1296 
1297     function walletOfOwner( address account ) external view virtual override returns( uint[] memory ){
1298         uint quantity = balanceOf( account );
1299         uint[] memory wallet = new uint[]( quantity );
1300         for( uint i; i < quantity; ++i ){
1301             wallet[i] = tokenOfOwnerByIndex( account, i );
1302         }
1303         return wallet;
1304     }
1305 }
1306 // File: @openzeppelin/contracts/access/Ownable.sol
1307 
1308 
1309 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1310 
1311 pragma solidity ^0.8.0;
1312 
1313 
1314 /**
1315  * @dev Contract module which provides a basic access control mechanism, where
1316  * there is an account (an owner) that can be granted exclusive access to
1317  * specific functions.
1318  *
1319  * By default, the owner account will be the one that deploys the contract. This
1320  * can later be changed with {transferOwnership}.
1321  *
1322  * This module is used through inheritance. It will make available the modifier
1323  * `onlyOwner`, which can be applied to your functions to restrict their use to
1324  * the owner.
1325  */
1326 abstract contract Ownable is Context {
1327     address private _owner;
1328 
1329     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1330 
1331     /**
1332      * @dev Initializes the contract setting the deployer as the initial owner.
1333      */
1334     constructor() {
1335         _transferOwnership(_msgSender());
1336     }
1337 
1338     /**
1339      * @dev Returns the address of the current owner.
1340      */
1341     function owner() public view virtual returns (address) {
1342         return _owner;
1343     }
1344 
1345     /**
1346      * @dev Throws if called by any account other than the owner.
1347      */
1348     modifier onlyOwner() {
1349         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1350         _;
1351     }
1352 
1353     /**
1354      * @dev Leaves the contract without owner. It will not be possible to call
1355      * `onlyOwner` functions anymore. Can only be called by the current owner.
1356      *
1357      * NOTE: Renouncing ownership will leave the contract without an owner,
1358      * thereby removing any functionality that is only available to the owner.
1359      */
1360     function renounceOwnership() public virtual onlyOwner {
1361         _transferOwnership(address(0));
1362     }
1363 
1364     /**
1365      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1366      * Can only be called by the current owner.
1367      */
1368     function transferOwnership(address newOwner) public virtual onlyOwner {
1369         require(newOwner != address(0), "Ownable: new owner is the zero address");
1370         _transferOwnership(newOwner);
1371     }
1372 
1373     /**
1374      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1375      * Internal function without access restriction.
1376      */
1377     function _transferOwnership(address newOwner) internal virtual {
1378         address oldOwner = _owner;
1379         _owner = newOwner;
1380         emit OwnershipTransferred(oldOwner, newOwner);
1381     }
1382 }
1383 
1384 // File: contracts/Blimpie/Delegated.sol
1385 
1386 
1387 
1388 pragma solidity ^0.8.0;
1389 
1390 /***********************
1391 * @author: squeebo_nft *
1392 ************************/
1393 
1394 
1395 contract Delegated is Ownable{
1396   mapping(address => bool) internal _delegates;
1397 
1398   constructor(){
1399     _delegates[owner()] = true;
1400   }
1401 
1402   modifier onlyDelegates {
1403     require(_delegates[msg.sender], "Invalid delegate" );
1404     _;
1405   }
1406 
1407   //onlyOwner
1408   function isDelegate( address addr ) external view onlyOwner returns ( bool ){
1409     return _delegates[addr];
1410   }
1411 
1412   function setDelegate( address addr, bool isDelegate_ ) external onlyOwner{
1413     _delegates[addr] = isDelegate_;
1414   }
1415 
1416   function transferOwnership(address newOwner) public virtual override onlyOwner {
1417     _delegates[newOwner] = true;
1418     super.transferOwnership( newOwner );
1419   }
1420 }
1421 // File: contracts/goadgauds.sol
1422 
1423 
1424 
1425 pragma solidity ^0.8.0;
1426 
1427 
1428 
1429 
1430 
1431 contract _goatgauds is Delegated, ERC721EnumerableLite, PaymentSplitterMod {
1432   using Strings for uint;
1433 
1434   uint public MAX_ORDER      = 2;
1435   uint public MAX_SUPPLY     = 2222;
1436   uint public MAINSALE_PRICE = 0.125 ether;
1437   uint public PRESALE_PRICE  = 0.1 ether;
1438 
1439   bool public isMintActive   = false;
1440   bool public isPresaleActive   = false;
1441   mapping(address=>uint) public accessList;
1442 
1443   string private _tokenURIPrefix = '';
1444   string private _tokenURISuffix = '';
1445 
1446   address[] private addressList = [
1447     0xF5c774b504C1D82fb59e3B826555D67033A13b01,
1448     0x7Cf39e8D6F6f9F25E925Dad7EB371276231780d7,
1449     0xC02Dd50b25364e747410730A1df9B72A92C3C68B,
1450     0x286777D6ad08EbE395C377078a17a32c21564a8a,
1451     0x00eCb19318d98ff57173Ac8EdFb7a5D90ba2005d,
1452     0x2E169A7c3D8EBeC11D5b43Dade06Ac29FEf59cb3,
1453     0x693B22BB92727Fb2a9a4D7e1b1D65B3E8168B774
1454   ];
1455 
1456   uint[] private shareList = [
1457     5,
1458     5,
1459     5,
1460     5,
1461     30,
1462     25,
1463     25
1464   ];
1465 
1466   constructor()
1467     Delegated()
1468     ERC721B("Goat Gauds", "GG", 0)
1469     PaymentSplitterMod( addressList, shareList ){
1470   }
1471 
1472   //public view
1473   fallback() external payable {}
1474 
1475   function tokenURI(uint tokenId) external view override returns (string memory) {
1476     require(_exists(tokenId), "Query for nonexistent token");
1477     return string(abi.encodePacked(_tokenURIPrefix, tokenId.toString(), _tokenURISuffix));
1478   }
1479 
1480 
1481   //public payable
1482   function presale( uint quantity ) external payable {
1483     require( isPresaleActive,               "Presale is not active"     );
1484     require( quantity <= MAX_ORDER,         "Order too big"             );
1485     require( msg.value >= PRESALE_PRICE * quantity, "Ether sent is not correct" );
1486     require( accessList[msg.sender] > 0,    "Not authorized"            );
1487 
1488     uint supply = totalSupply();
1489     require( supply + quantity <= MAX_SUPPLY, "Mint/order exceeds supply" );
1490     accessList[msg.sender] -= quantity;
1491 
1492     for(uint i; i < quantity; ++i){
1493       _mint( msg.sender, supply++ );
1494     }
1495   }
1496 
1497   function mint( uint quantity ) external payable {
1498     require( isMintActive,                  "Sale is not active"        );
1499     require( quantity <= MAX_ORDER,         "Order too big"             );
1500     require( msg.value >= MAINSALE_PRICE * quantity, "Ether sent is not correct" );
1501 
1502     uint supply = totalSupply();
1503     require( supply + quantity <= MAX_SUPPLY, "Mint/order exceeds supply" );
1504     for(uint i; i < quantity; ++i){
1505       _mint( msg.sender, supply++ );
1506     }
1507   }
1508 
1509 
1510   //delegated payable
1511   function burnFrom( address owner, uint[] calldata tokenIds ) external payable onlyDelegates{
1512     for(uint i; i < tokenIds.length; ++i ){
1513       require( _exists( tokenIds[i] ), "Burn for nonexistent token" );
1514       require( _owners[ tokenIds[i] ] == owner, "Owner mismatch" );
1515       _burn( tokenIds[i] );
1516     }
1517   }
1518 
1519   function mintTo(uint[] calldata quantity, address[] calldata recipient) external payable onlyDelegates{
1520     require(quantity.length == recipient.length, "Must provide equal quantities and recipients" );
1521 
1522     uint totalQuantity;
1523     uint supply = totalSupply();
1524     for(uint i; i < quantity.length; ++i){
1525       totalQuantity += quantity[i];
1526     }
1527     require( supply + totalQuantity <= MAX_SUPPLY, "Mint/order exceeds supply" );
1528 
1529     for(uint i; i < recipient.length; ++i){
1530       for(uint j; j < quantity[i]; ++j){
1531         _mint( recipient[i], supply++ );
1532       }
1533     }
1534   }
1535 
1536 
1537   //delegated nonpayable
1538   function resurrect( uint[] calldata tokenIds, address[] calldata recipients ) external onlyDelegates{
1539     require(tokenIds.length == recipients.length,   "Must provide equal tokenIds and recipients" );
1540 
1541     address to;
1542     uint tokenId;
1543     address zero = address(0);
1544     for(uint i; i < tokenIds.length; ++i ){
1545       to = recipients[i];
1546       require(recipients[i] != address(0), "resurrect to the zero address" );
1547 
1548       tokenId = tokenIds[i];
1549       require( !_exists( tokenId ), "can't resurrect existing token" );
1550 
1551       
1552       _owners[tokenId] = to;
1553       // Clear approvals
1554       _approve(zero, tokenId);
1555       emit Transfer(zero, to, tokenId);
1556     }
1557   }
1558 
1559   function setAccessList(address[] calldata accounts, uint[] calldata quantities) external onlyDelegates{
1560     require(accounts.length == quantities.length, "Must provide equal accounts and quantities" );
1561     for(uint i; i < accounts.length; ++i){
1562       accessList[ accounts[i] ] = quantities[i];
1563     }
1564   }
1565 
1566   function setActive(bool isPresaleActive_, bool isMintActive_) external onlyDelegates{
1567     require( isPresaleActive != isPresaleActive_ || isMintActive != isMintActive_, "New value matches old" );
1568     isPresaleActive = isPresaleActive_;
1569     isMintActive = isMintActive_;
1570   }
1571 
1572   function setBaseURI(string calldata newPrefix, string calldata newSuffix) external onlyDelegates{
1573     _tokenURIPrefix = newPrefix;
1574     _tokenURISuffix = newSuffix;
1575   }
1576 
1577   function setMax(uint maxOrder, uint maxSupply) external onlyDelegates{
1578     require( MAX_ORDER != maxOrder || MAX_SUPPLY != maxSupply, "New value matches old" );
1579     require(maxSupply >= totalSupply(), "Specified supply is lower than current balance" );
1580     MAX_ORDER = maxOrder;
1581     MAX_SUPPLY = maxSupply;
1582   }
1583 
1584   function setPrice(uint presalePrice, uint mainsalePrice ) external onlyDelegates{
1585     require( PRESALE_PRICE != presalePrice || MAINSALE_PRICE != mainsalePrice, "New value matches old" );
1586     PRESALE_PRICE = presalePrice;
1587     MAINSALE_PRICE = mainsalePrice;
1588   }
1589 
1590 
1591   //owner
1592   function addPayee(address account, uint256 shares_) external onlyOwner {
1593     _addPayee(account, shares_);
1594   }
1595 
1596   function setPayee( uint index, address account, uint newShares ) external onlyOwner {
1597     _setPayee(index, account, newShares);
1598   }
1599 
1600 
1601   //internal
1602   function _burn(uint tokenId) internal override {
1603     address curOwner = ERC721B.ownerOf(tokenId);
1604 
1605     // Clear approvals
1606     _approve(owner(), tokenId);
1607     _owners[tokenId] = address(0);
1608     emit Transfer(curOwner, address(0), tokenId);
1609   }
1610 
1611   function _mint(address to, uint tokenId) internal override {
1612     _owners.push(to);
1613     emit Transfer(address(0), to, tokenId);
1614   }
1615 }