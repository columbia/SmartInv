1 // File: @openzeppelin/contracts/utils/Strings.sol
2 // SPDX-License-Identifier: None
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Address.sol
71 
72 
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Collection of functions related to the address type
78  */
79 library Address {
80     /**
81      * @dev Returns true if `account` is a contract.
82      *
83      * [IMPORTANT]
84      * ====
85      * It is unsafe to assume that an address for which this function returns
86      * false is an externally-owned account (EOA) and not a contract.
87      *
88      * Among others, `isContract` will return false for the following
89      * types of addresses:
90      *
91      *  - an externally-owned account
92      *  - a contract in construction
93      *  - an address where a contract will be created
94      *  - an address where a contract lived, but was destroyed
95      * ====
96      */
97     function isContract(address account) internal view returns (bool) {
98         // This method relies on extcodesize, which returns 0 for contracts in
99         // construction, since the code is only stored at the end of the
100         // constructor execution.
101 
102         uint256 size;
103         assembly {
104             size := extcodesize(account)
105         }
106         return size > 0;
107     }
108 
109     /**
110      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
111      * `recipient`, forwarding all available gas and reverting on errors.
112      *
113      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
114      * of certain opcodes, possibly making contracts go over the 2300 gas limit
115      * imposed by `transfer`, making them unable to receive funds via
116      * `transfer`. {sendValue} removes this limitation.
117      *
118      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
119      *
120      * IMPORTANT: because control is transferred to `recipient`, care must be
121      * taken to not create reentrancy vulnerabilities. Consider using
122      * {ReentrancyGuard} or the
123      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
124      */
125     function sendValue(address payable recipient, uint256 amount) internal {
126         require(address(this).balance >= amount, "Address: insufficient balance");
127 
128         (bool success, ) = recipient.call{value: amount}("");
129         require(success, "Address: unable to send value, recipient may have reverted");
130     }
131 
132     /**
133      * @dev Performs a Solidity function call using a low level `call`. A
134      * plain `call` is an unsafe replacement for a function call: use this
135      * function instead.
136      *
137      * If `target` reverts with a revert reason, it is bubbled up by this
138      * function (like regular Solidity function calls).
139      *
140      * Returns the raw returned data. To convert to the expected return value,
141      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
142      *
143      * Requirements:
144      *
145      * - `target` must be a contract.
146      * - calling `target` with `data` must not revert.
147      *
148      * _Available since v3.1._
149      */
150     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
151         return functionCall(target, data, "Address: low-level call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
156      * `errorMessage` as a fallback revert reason when `target` reverts.
157      *
158      * _Available since v3.1._
159      */
160     function functionCall(
161         address target,
162         bytes memory data,
163         string memory errorMessage
164     ) internal returns (bytes memory) {
165         return functionCallWithValue(target, data, 0, errorMessage);
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
170      * but also transferring `value` wei to `target`.
171      *
172      * Requirements:
173      *
174      * - the calling contract must have an ETH balance of at least `value`.
175      * - the called Solidity function must be `payable`.
176      *
177      * _Available since v3.1._
178      */
179     function functionCallWithValue(
180         address target,
181         bytes memory data,
182         uint256 value
183     ) internal returns (bytes memory) {
184         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
189      * with `errorMessage` as a fallback revert reason when `target` reverts.
190      *
191      * _Available since v3.1._
192      */
193     function functionCallWithValue(
194         address target,
195         bytes memory data,
196         uint256 value,
197         string memory errorMessage
198     ) internal returns (bytes memory) {
199         require(address(this).balance >= value, "Address: insufficient balance for call");
200         require(isContract(target), "Address: call to non-contract");
201 
202         (bool success, bytes memory returndata) = target.call{value: value}(data);
203         return verifyCallResult(success, returndata, errorMessage);
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
208      * but performing a static call.
209      *
210      * _Available since v3.3._
211      */
212     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
213         return functionStaticCall(target, data, "Address: low-level static call failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
218      * but performing a static call.
219      *
220      * _Available since v3.3._
221      */
222     function functionStaticCall(
223         address target,
224         bytes memory data,
225         string memory errorMessage
226     ) internal view returns (bytes memory) {
227         require(isContract(target), "Address: static call to non-contract");
228 
229         (bool success, bytes memory returndata) = target.staticcall(data);
230         return verifyCallResult(success, returndata, errorMessage);
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
235      * but performing a delegate call.
236      *
237      * _Available since v3.4._
238      */
239     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
240         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
245      * but performing a delegate call.
246      *
247      * _Available since v3.4._
248      */
249     function functionDelegateCall(
250         address target,
251         bytes memory data,
252         string memory errorMessage
253     ) internal returns (bytes memory) {
254         require(isContract(target), "Address: delegate call to non-contract");
255 
256         (bool success, bytes memory returndata) = target.delegatecall(data);
257         return verifyCallResult(success, returndata, errorMessage);
258     }
259 
260     /**
261      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
262      * revert reason using the provided one.
263      *
264      * _Available since v4.3._
265      */
266     function verifyCallResult(
267         bool success,
268         bytes memory returndata,
269         string memory errorMessage
270     ) internal pure returns (bytes memory) {
271         if (success) {
272             return returndata;
273         } else {
274             // Look for revert reason and bubble it up if present
275             if (returndata.length > 0) {
276                 // The easiest way to bubble the revert reason is using memory via assembly
277 
278                 assembly {
279                     let returndata_size := mload(returndata)
280                     revert(add(32, returndata), returndata_size)
281                 }
282             } else {
283                 revert(errorMessage);
284             }
285         }
286     }
287 }
288 
289 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
290 
291 
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @title ERC721 token receiver interface
297  * @dev Interface for any contract that wants to support safeTransfers
298  * from ERC721 asset contracts.
299  */
300 interface IERC721Receiver {
301     /**
302      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
303      * by `operator` from `from`, this function is called.
304      *
305      * It must return its Solidity selector to confirm the token transfer.
306      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
307      *
308      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
309      */
310     function onERC721Received(
311         address operator,
312         address from,
313         uint256 tokenId,
314         bytes calldata data
315     ) external returns (bytes4);
316 }
317 
318 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
319 
320 
321 
322 pragma solidity ^0.8.0;
323 
324 /**
325  * @dev Interface of the ERC165 standard, as defined in the
326  * https://eips.ethereum.org/EIPS/eip-165[EIP].
327  *
328  * Implementers can declare support of contract interfaces, which can then be
329  * queried by others ({ERC165Checker}).
330  *
331  * For an implementation, see {ERC165}.
332  */
333 interface IERC165 {
334     /**
335      * @dev Returns true if this contract implements the interface defined by
336      * `interfaceId`. See the corresponding
337      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
338      * to learn more about how these ids are created.
339      *
340      * This function call must use less than 30 000 gas.
341      */
342     function supportsInterface(bytes4 interfaceId) external view returns (bool);
343 }
344 
345 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
346 
347 
348 
349 pragma solidity ^0.8.0;
350 
351 
352 /**
353  * @dev Implementation of the {IERC165} interface.
354  *
355  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
356  * for the additional interface id that will be supported. For example:
357  *
358  * ```solidity
359  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
360  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
361  * }
362  * ```
363  *
364  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
365  */
366 abstract contract ERC165 is IERC165 {
367     /**
368      * @dev See {IERC165-supportsInterface}.
369      */
370     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
371         return interfaceId == type(IERC165).interfaceId;
372     }
373 }
374 
375 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
376 
377 
378 
379 pragma solidity ^0.8.0;
380 
381 
382 /**
383  * @dev Required interface of an ERC721 compliant contract.
384  */
385 interface IERC721 is IERC165 {
386     /**
387      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
388      */
389     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
390 
391     /**
392      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
393      */
394     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
395 
396     /**
397      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
398      */
399     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
400 
401     /**
402      * @dev Returns the number of tokens in ``owner``'s account.
403      */
404     function balanceOf(address owner) external view returns (uint256 balance);
405 
406     /**
407      * @dev Returns the owner of the `tokenId` token.
408      *
409      * Requirements:
410      *
411      * - `tokenId` must exist.
412      */
413     function ownerOf(uint256 tokenId) external view returns (address owner);
414 
415     /**
416      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
417      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
418      *
419      * Requirements:
420      *
421      * - `from` cannot be the zero address.
422      * - `to` cannot be the zero address.
423      * - `tokenId` token must exist and be owned by `from`.
424      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
425      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
426      *
427      * Emits a {Transfer} event.
428      */
429     function safeTransferFrom(
430         address from,
431         address to,
432         uint256 tokenId
433     ) external;
434 
435     /**
436      * @dev Transfers `tokenId` token from `from` to `to`.
437      *
438      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
439      *
440      * Requirements:
441      *
442      * - `from` cannot be the zero address.
443      * - `to` cannot be the zero address.
444      * - `tokenId` token must be owned by `from`.
445      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
446      *
447      * Emits a {Transfer} event.
448      */
449     function transferFrom(
450         address from,
451         address to,
452         uint256 tokenId
453     ) external;
454 
455     /**
456      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
457      * The approval is cleared when the token is transferred.
458      *
459      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
460      *
461      * Requirements:
462      *
463      * - The caller must own the token or be an approved operator.
464      * - `tokenId` must exist.
465      *
466      * Emits an {Approval} event.
467      */
468     function approve(address to, uint256 tokenId) external;
469 
470     /**
471      * @dev Returns the account approved for `tokenId` token.
472      *
473      * Requirements:
474      *
475      * - `tokenId` must exist.
476      */
477     function getApproved(uint256 tokenId) external view returns (address operator);
478 
479     /**
480      * @dev Approve or remove `operator` as an operator for the caller.
481      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
482      *
483      * Requirements:
484      *
485      * - The `operator` cannot be the caller.
486      *
487      * Emits an {ApprovalForAll} event.
488      */
489     function setApprovalForAll(address operator, bool _approved) external;
490 
491     /**
492      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
493      *
494      * See {setApprovalForAll}
495      */
496     function isApprovedForAll(address owner, address operator) external view returns (bool);
497 
498     /**
499      * @dev Safely transfers `tokenId` token from `from` to `to`.
500      *
501      * Requirements:
502      *
503      * - `from` cannot be the zero address.
504      * - `to` cannot be the zero address.
505      * - `tokenId` token must exist and be owned by `from`.
506      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
507      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
508      *
509      * Emits a {Transfer} event.
510      */
511     function safeTransferFrom(
512         address from,
513         address to,
514         uint256 tokenId,
515         bytes calldata data
516     ) external;
517 }
518 
519 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
520 
521 
522 
523 pragma solidity ^0.8.0;
524 
525 
526 /**
527  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
528  * @dev See https://eips.ethereum.org/EIPS/eip-721
529  */
530 interface IERC721Enumerable is IERC721 {
531     /**
532      * @dev Returns the total amount of tokens stored by the contract.
533      */
534     function totalSupply() external view returns (uint256);
535 
536     /**
537      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
538      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
539      */
540     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
541 
542     /**
543      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
544      * Use along with {totalSupply} to enumerate all tokens.
545      */
546     function tokenByIndex(uint256 index) external view returns (uint256);
547 }
548 
549 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
550 
551 
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
558  * @dev See https://eips.ethereum.org/EIPS/eip-721
559  */
560 interface IERC721Metadata is IERC721 {
561     /**
562      * @dev Returns the token collection name.
563      */
564     function name() external view returns (string memory);
565 
566     /**
567      * @dev Returns the token collection symbol.
568      */
569     function symbol() external view returns (string memory);
570 
571     /**
572      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
573      */
574     function tokenURI(uint256 tokenId) external view returns (string memory);
575 }
576 
577 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
578 
579 
580 
581 pragma solidity ^0.8.0;
582 
583 // CAUTION
584 // This version of SafeMath should only be used with Solidity 0.8 or later,
585 // because it relies on the compiler's built in overflow checks.
586 
587 /**
588  * @dev Wrappers over Solidity's arithmetic operations.
589  *
590  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
591  * now has built in overflow checking.
592  */
593 library SafeMath {
594     /**
595      * @dev Returns the addition of two unsigned integers, with an overflow flag.
596      *
597      * _Available since v3.4._
598      */
599     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
600         unchecked {
601             uint256 c = a + b;
602             if (c < a) return (false, 0);
603             return (true, c);
604         }
605     }
606 
607     /**
608      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
609      *
610      * _Available since v3.4._
611      */
612     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
613         unchecked {
614             if (b > a) return (false, 0);
615             return (true, a - b);
616         }
617     }
618 
619     /**
620      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
621      *
622      * _Available since v3.4._
623      */
624     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
625         unchecked {
626             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
627             // benefit is lost if 'b' is also tested.
628             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
629             if (a == 0) return (true, 0);
630             uint256 c = a * b;
631             if (c / a != b) return (false, 0);
632             return (true, c);
633         }
634     }
635 
636     /**
637      * @dev Returns the division of two unsigned integers, with a division by zero flag.
638      *
639      * _Available since v3.4._
640      */
641     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
642         unchecked {
643             if (b == 0) return (false, 0);
644             return (true, a / b);
645         }
646     }
647 
648     /**
649      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
650      *
651      * _Available since v3.4._
652      */
653     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
654         unchecked {
655             if (b == 0) return (false, 0);
656             return (true, a % b);
657         }
658     }
659 
660     /**
661      * @dev Returns the addition of two unsigned integers, reverting on
662      * overflow.
663      *
664      * Counterpart to Solidity's `+` operator.
665      *
666      * Requirements:
667      *
668      * - Addition cannot overflow.
669      */
670     function add(uint256 a, uint256 b) internal pure returns (uint256) {
671         return a + b;
672     }
673 
674     /**
675      * @dev Returns the subtraction of two unsigned integers, reverting on
676      * overflow (when the result is negative).
677      *
678      * Counterpart to Solidity's `-` operator.
679      *
680      * Requirements:
681      *
682      * - Subtraction cannot overflow.
683      */
684     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
685         return a - b;
686     }
687 
688     /**
689      * @dev Returns the multiplication of two unsigned integers, reverting on
690      * overflow.
691      *
692      * Counterpart to Solidity's `*` operator.
693      *
694      * Requirements:
695      *
696      * - Multiplication cannot overflow.
697      */
698     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
699         return a * b;
700     }
701 
702     /**
703      * @dev Returns the integer division of two unsigned integers, reverting on
704      * division by zero. The result is rounded towards zero.
705      *
706      * Counterpart to Solidity's `/` operator.
707      *
708      * Requirements:
709      *
710      * - The divisor cannot be zero.
711      */
712     function div(uint256 a, uint256 b) internal pure returns (uint256) {
713         return a / b;
714     }
715 
716     /**
717      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
718      * reverting when dividing by zero.
719      *
720      * Counterpart to Solidity's `%` operator. This function uses a `revert`
721      * opcode (which leaves remaining gas untouched) while Solidity uses an
722      * invalid opcode to revert (consuming all remaining gas).
723      *
724      * Requirements:
725      *
726      * - The divisor cannot be zero.
727      */
728     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
729         return a % b;
730     }
731 
732     /**
733      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
734      * overflow (when the result is negative).
735      *
736      * CAUTION: This function is deprecated because it requires allocating memory for the error
737      * message unnecessarily. For custom revert reasons use {trySub}.
738      *
739      * Counterpart to Solidity's `-` operator.
740      *
741      * Requirements:
742      *
743      * - Subtraction cannot overflow.
744      */
745     function sub(
746         uint256 a,
747         uint256 b,
748         string memory errorMessage
749     ) internal pure returns (uint256) {
750         unchecked {
751             require(b <= a, errorMessage);
752             return a - b;
753         }
754     }
755 
756     /**
757      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
758      * division by zero. The result is rounded towards zero.
759      *
760      * Counterpart to Solidity's `/` operator. Note: this function uses a
761      * `revert` opcode (which leaves remaining gas untouched) while Solidity
762      * uses an invalid opcode to revert (consuming all remaining gas).
763      *
764      * Requirements:
765      *
766      * - The divisor cannot be zero.
767      */
768     function div(
769         uint256 a,
770         uint256 b,
771         string memory errorMessage
772     ) internal pure returns (uint256) {
773         unchecked {
774             require(b > 0, errorMessage);
775             return a / b;
776         }
777     }
778 
779     /**
780      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
781      * reverting with custom message when dividing by zero.
782      *
783      * CAUTION: This function is deprecated because it requires allocating memory for the error
784      * message unnecessarily. For custom revert reasons use {tryMod}.
785      *
786      * Counterpart to Solidity's `%` operator. This function uses a `revert`
787      * opcode (which leaves remaining gas untouched) while Solidity uses an
788      * invalid opcode to revert (consuming all remaining gas).
789      *
790      * Requirements:
791      *
792      * - The divisor cannot be zero.
793      */
794     function mod(
795         uint256 a,
796         uint256 b,
797         string memory errorMessage
798     ) internal pure returns (uint256) {
799         unchecked {
800             require(b > 0, errorMessage);
801             return a % b;
802         }
803     }
804 }
805 
806 // File: @openzeppelin/contracts/utils/Context.sol
807 
808 
809 
810 pragma solidity ^0.8.0;
811 
812 /**
813  * @dev Provides information about the current execution context, including the
814  * sender of the transaction and its data. While these are generally available
815  * via msg.sender and msg.data, they should not be accessed in such a direct
816  * manner, since when dealing with meta-transactions the account sending and
817  * paying for execution may not be the actual sender (as far as an application
818  * is concerned).
819  *
820  * This contract is only required for intermediate, library-like contracts.
821  */
822 abstract contract Context {
823     function _msgSender() internal view virtual returns (address) {
824         return msg.sender;
825     }
826 
827     function _msgData() internal view virtual returns (bytes calldata) {
828         return msg.data;
829     }
830 }
831 
832 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
833 
834 
835 
836 pragma solidity ^0.8.0;
837 
838 
839 
840 
841 
842 
843 
844 
845 /**
846  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
847  * the Metadata extension, but not including the Enumerable extension, which is available separately as
848  * {ERC721Enumerable}.
849  */
850 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
851     using Address for address;
852     using Strings for uint256;
853 
854     // Token name
855     string private _name;
856 
857     // Token symbol
858     string private _symbol;
859 
860     // Mapping from token ID to owner address
861     mapping(uint256 => address) private _owners;
862 
863     // Mapping owner address to token count
864     mapping(address => uint256) private _balances;
865 
866     // Mapping from token ID to approved address
867     mapping(uint256 => address) private _tokenApprovals;
868 
869     // Mapping from owner to operator approvals
870     mapping(address => mapping(address => bool)) private _operatorApprovals;
871 
872     /**
873      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
874      */
875     constructor(string memory name_, string memory symbol_) {
876         _name = name_;
877         _symbol = symbol_;
878     }
879 
880     /**
881      * @dev See {IERC165-supportsInterface}.
882      */
883     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
884         return
885             interfaceId == type(IERC721).interfaceId ||
886             interfaceId == type(IERC721Metadata).interfaceId ||
887             super.supportsInterface(interfaceId);
888     }
889 
890     /**
891      * @dev See {IERC721-balanceOf}.
892      */
893     function balanceOf(address owner) public view virtual override returns (uint256) {
894         require(owner != address(0), "ERC721: balance query for the zero address");
895         return _balances[owner];
896     }
897 
898     /**
899      * @dev See {IERC721-ownerOf}.
900      */
901     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
902         address owner = _owners[tokenId];
903         require(owner != address(0), "ERC721: owner query for nonexistent token");
904         return owner;
905     }
906 
907     /**
908      * @dev See {IERC721Metadata-name}.
909      */
910     function name() public view virtual override returns (string memory) {
911         return _name;
912     }
913 
914     /**
915      * @dev See {IERC721Metadata-symbol}.
916      */
917     function symbol() public view virtual override returns (string memory) {
918         return _symbol;
919     }
920 
921     /**
922      * @dev See {IERC721Metadata-tokenURI}.
923      */
924     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
925         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
926 
927         string memory baseURI = _baseURI();
928         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
929     }
930 
931     /**
932      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
933      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
934      * by default, can be overriden in child contracts.
935      */
936     function _baseURI() internal view virtual returns (string memory) {
937         return "";
938     }
939 
940     /**
941      * @dev See {IERC721-approve}.
942      */
943     function approve(address to, uint256 tokenId) public virtual override {
944         address owner = ERC721.ownerOf(tokenId);
945         require(to != owner, "ERC721: approval to current owner");
946 
947         require(
948             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
949             "ERC721: approve caller is not owner nor approved for all"
950         );
951 
952         _approve(to, tokenId);
953     }
954 
955     /**
956      * @dev See {IERC721-getApproved}.
957      */
958     function getApproved(uint256 tokenId) public view virtual override returns (address) {
959         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
960 
961         return _tokenApprovals[tokenId];
962     }
963 
964     /**
965      * @dev See {IERC721-setApprovalForAll}.
966      */
967     function setApprovalForAll(address operator, bool approved) public virtual override {
968         require(operator != _msgSender(), "ERC721: approve to caller");
969 
970         _operatorApprovals[_msgSender()][operator] = approved;
971         emit ApprovalForAll(_msgSender(), operator, approved);
972     }
973 
974     /**
975      * @dev See {IERC721-isApprovedForAll}.
976      */
977     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
978         return _operatorApprovals[owner][operator];
979     }
980 
981     /**
982      * @dev See {IERC721-transferFrom}.
983      */
984     function transferFrom(
985         address from,
986         address to,
987         uint256 tokenId
988     ) public virtual override {
989         //solhint-disable-next-line max-line-length
990         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
991 
992         _transfer(from, to, tokenId);
993     }
994 
995     /**
996      * @dev See {IERC721-safeTransferFrom}.
997      */
998     function safeTransferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) public virtual override {
1003         safeTransferFrom(from, to, tokenId, "");
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-safeTransferFrom}.
1008      */
1009     function safeTransferFrom(
1010         address from,
1011         address to,
1012         uint256 tokenId,
1013         bytes memory _data
1014     ) public virtual override {
1015         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1016         _safeTransfer(from, to, tokenId, _data);
1017     }
1018 
1019     /**
1020      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1021      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1022      *
1023      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1024      *
1025      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1026      * implement alternative mechanisms to perform token transfer, such as signature-based.
1027      *
1028      * Requirements:
1029      *
1030      * - `from` cannot be the zero address.
1031      * - `to` cannot be the zero address.
1032      * - `tokenId` token must exist and be owned by `from`.
1033      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1034      *
1035      * Emits a {Transfer} event.
1036      */
1037     function _safeTransfer(
1038         address from,
1039         address to,
1040         uint256 tokenId,
1041         bytes memory _data
1042     ) internal virtual {
1043         _transfer(from, to, tokenId);
1044         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1045     }
1046 
1047     /**
1048      * @dev Returns whether `tokenId` exists.
1049      *
1050      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1051      *
1052      * Tokens start existing when they are minted (`_mint`),
1053      * and stop existing when they are burned (`_burn`).
1054      */
1055     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1056         return _owners[tokenId] != address(0);
1057     }
1058 
1059     /**
1060      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1061      *
1062      * Requirements:
1063      *
1064      * - `tokenId` must exist.
1065      */
1066     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1067         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1068         address owner = ERC721.ownerOf(tokenId);
1069         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1070     }
1071 
1072     /**
1073      * @dev Safely mints `tokenId` and transfers it to `to`.
1074      *
1075      * Requirements:
1076      *
1077      * - `tokenId` must not exist.
1078      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _safeMint(address to, uint256 tokenId) internal virtual {
1083         _safeMint(to, tokenId, "");
1084     }
1085 
1086     /**
1087      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1088      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1089      */
1090     function _safeMint(
1091         address to,
1092         uint256 tokenId,
1093         bytes memory _data
1094     ) internal virtual {
1095         _mint(to, tokenId);
1096         require(
1097             _checkOnERC721Received(address(0), to, tokenId, _data),
1098             "ERC721: transfer to non ERC721Receiver implementer"
1099         );
1100     }
1101 
1102     /**
1103      * @dev Mints `tokenId` and transfers it to `to`.
1104      *
1105      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1106      *
1107      * Requirements:
1108      *
1109      * - `tokenId` must not exist.
1110      * - `to` cannot be the zero address.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function _mint(address to, uint256 tokenId) internal virtual {
1115         require(to != address(0), "ERC721: mint to the zero address");
1116         require(!_exists(tokenId), "ERC721: token already minted");
1117 
1118         _beforeTokenTransfer(address(0), to, tokenId);
1119 
1120         _balances[to] += 1;
1121         _owners[tokenId] = to;
1122 
1123         emit Transfer(address(0), to, tokenId);
1124     }
1125 
1126     /**
1127      * @dev Destroys `tokenId`.
1128      * The approval is cleared when the token is burned.
1129      *
1130      * Requirements:
1131      *
1132      * - `tokenId` must exist.
1133      *
1134      * Emits a {Transfer} event.
1135      */
1136     function _burn(uint256 tokenId) internal virtual {
1137         address owner = ERC721.ownerOf(tokenId);
1138 
1139         _beforeTokenTransfer(owner, address(0), tokenId);
1140 
1141         // Clear approvals
1142         _approve(address(0), tokenId);
1143 
1144         _balances[owner] -= 1;
1145         delete _owners[tokenId];
1146 
1147         emit Transfer(owner, address(0), tokenId);
1148     }
1149 
1150     /**
1151      * @dev Transfers `tokenId` from `from` to `to`.
1152      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1153      *
1154      * Requirements:
1155      *
1156      * - `to` cannot be the zero address.
1157      * - `tokenId` token must be owned by `from`.
1158      *
1159      * Emits a {Transfer} event.
1160      */
1161     function _transfer(
1162         address from,
1163         address to,
1164         uint256 tokenId
1165     ) internal virtual {
1166         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1167         require(to != address(0), "ERC721: transfer to the zero address");
1168 
1169         _beforeTokenTransfer(from, to, tokenId);
1170 
1171         // Clear approvals from the previous owner
1172         _approve(address(0), tokenId);
1173 
1174         _balances[from] -= 1;
1175         _balances[to] += 1;
1176         _owners[tokenId] = to;
1177 
1178         emit Transfer(from, to, tokenId);
1179     }
1180 
1181     /**
1182      * @dev Approve `to` to operate on `tokenId`
1183      *
1184      * Emits a {Approval} event.
1185      */
1186     function _approve(address to, uint256 tokenId) internal virtual {
1187         _tokenApprovals[tokenId] = to;
1188         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1189     }
1190 
1191     /**
1192      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1193      * The call is not executed if the target address is not a contract.
1194      *
1195      * @param from address representing the previous owner of the given token ID
1196      * @param to target address that will receive the tokens
1197      * @param tokenId uint256 ID of the token to be transferred
1198      * @param _data bytes optional data to send along with the call
1199      * @return bool whether the call correctly returned the expected magic value
1200      */
1201     function _checkOnERC721Received(
1202         address from,
1203         address to,
1204         uint256 tokenId,
1205         bytes memory _data
1206     ) private returns (bool) {
1207         if (to.isContract()) {
1208             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1209                 return retval == IERC721Receiver.onERC721Received.selector;
1210             } catch (bytes memory reason) {
1211                 if (reason.length == 0) {
1212                     revert("ERC721: transfer to non ERC721Receiver implementer");
1213                 } else {
1214                     assembly {
1215                         revert(add(32, reason), mload(reason))
1216                     }
1217                 }
1218             }
1219         } else {
1220             return true;
1221         }
1222     }
1223 
1224     /**
1225      * @dev Hook that is called before any token transfer. This includes minting
1226      * and burning.
1227      *
1228      * Calling conditions:
1229      *
1230      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1231      * transferred to `to`.
1232      * - When `from` is zero, `tokenId` will be minted for `to`.
1233      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1234      * - `from` and `to` are never both zero.
1235      *
1236      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1237      */
1238     function _beforeTokenTransfer(
1239         address from,
1240         address to,
1241         uint256 tokenId
1242     ) internal virtual {}
1243 }
1244 
1245 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1246 
1247 
1248 
1249 pragma solidity ^0.8.0;
1250 
1251 
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
1409 // File: @openzeppelin/contracts/access/Ownable.sol
1410 
1411 
1412 
1413 pragma solidity ^0.8.0;
1414 
1415 
1416 /**
1417  * @dev Contract module which provides a basic access control mechanism, where
1418  * there is an account (an owner) that can be granted exclusive access to
1419  * specific functions.
1420  *
1421  * By default, the owner account will be the one that deploys the contract. This
1422  * can later be changed with {transferOwnership}.
1423  *
1424  * This module is used through inheritance. It will make available the modifier
1425  * `onlyOwner`, which can be applied to your functions to restrict their use to
1426  * the owner.
1427  */
1428 abstract contract Ownable is Context {
1429     address private _owner;
1430 
1431     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1432 
1433     /**
1434      * @dev Initializes the contract setting the deployer as the initial owner.
1435      */
1436     constructor() {
1437         _setOwner(_msgSender());
1438     }
1439 
1440     /**
1441      * @dev Returns the address of the current owner.
1442      */
1443     function owner() public view virtual returns (address) {
1444         return _owner;
1445     }
1446 
1447     /**
1448      * @dev Throws if called by any account other than the owner.
1449      */
1450     modifier onlyOwner() {
1451         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1452         _;
1453     }
1454 
1455     /**
1456      * @dev Leaves the contract without owner. It will not be possible to call
1457      * `onlyOwner` functions anymore. Can only be called by the current owner.
1458      *
1459      * NOTE: Renouncing ownership will leave the contract without an owner,
1460      * thereby removing any functionality that is only available to the owner.
1461      */
1462     function renounceOwnership() public virtual onlyOwner {
1463         _setOwner(address(0));
1464     }
1465 
1466     /**
1467      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1468      * Can only be called by the current owner.
1469      */
1470     function transferOwnership(address newOwner) public virtual onlyOwner {
1471         require(newOwner != address(0), "Ownable: new owner is the zero address");
1472         _setOwner(newOwner);
1473     }
1474 
1475     function _setOwner(address newOwner) private {
1476         address oldOwner = _owner;
1477         _owner = newOwner;
1478         emit OwnershipTransferred(oldOwner, newOwner);
1479     }
1480 }
1481 
1482 // File: contracts/fishtank.sol
1483 
1484 
1485 
1486 pragma solidity ^0.8.4;
1487 
1488 
1489 
1490 
1491 contract FishTank is Ownable, ERC721Enumerable {
1492     using SafeMath for uint256;
1493 
1494     uint256 public constant mintPrice = 0.05555 ether;
1495     uint256 public constant mintLimit = 1;
1496     uint256 public supplyLimit = 5555;
1497     string public baseURI;
1498     bool public mintOpen = false;
1499     bool public mintPublic = false;
1500 
1501     address private creatorAddress = 0x96feA1d069f99c93A0A2726c06d4B99c2540a1CF;
1502     
1503     mapping(address => uint) public tokenBalance;
1504     mapping(uint => uint) public staked;
1505     string str = "TheFishTankNFT";
1506     address signer = 0x17488eBd429854b52669B956A555030f4b16DA41;
1507 
1508     constructor(string memory inputBaseUri) ERC721("Fish Tank NFT", "FISHTANK") {
1509         baseURI = inputBaseUri;
1510     }
1511     
1512     modifier onlyValidAccess(uint8 _v, bytes32 _r, bytes32 _s) {
1513         if (!mintPublic) require(isValidAccessMessage(msg.sender, _v, _r, _s), "No access");
1514         _;
1515     }
1516  
1517     function isValidAccessMessage(address _add, uint8 _v, bytes32 _r, bytes32 _s) view public returns (bool) {
1518         bytes32 hash = keccak256(abi.encode(_add));
1519         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
1520         bytes32 prefixedProof = keccak256(abi.encodePacked(prefix, hash));
1521         address recovered = ecrecover(prefixedProof, _v, _r, _s);
1522         return recovered == signer;
1523     }
1524 
1525     function _baseURI() internal view override returns (string memory) {
1526         return baseURI;
1527     }
1528 
1529     function setBaseURI(string calldata newBaseUri) external onlyOwner {
1530         baseURI = newBaseUri;
1531     }
1532     
1533     function setMintOpen(bool _open) public onlyOwner {
1534         mintOpen = _open;
1535     }
1536     
1537     function setMintPublic(bool _open) public onlyOwner {
1538         mintPublic = _open;
1539     }
1540     
1541     function buy(uint numberOfTokens, uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v, _r, _s) external payable {
1542         require(mintOpen, "Mint is not open");
1543         require(tokensOwnedBy(msg.sender).length + numberOfTokens <= mintLimit, "Too many tokens for one address");
1544         require(msg.value >= mintPrice.mul(numberOfTokens), "Insufficient payment");
1545 
1546         _mint(numberOfTokens);
1547     }
1548 
1549     function _mint(uint numberOfTokens) private {
1550         require(totalSupply().add(numberOfTokens) <= supplyLimit, "Not enough tokens left");
1551 
1552         uint256 newId = totalSupply();
1553         for(uint i = 0; i < numberOfTokens; i++) {
1554             newId += 1;
1555             _safeMint(msg.sender, newId);
1556         }
1557     }
1558 
1559     function withdraw() external onlyOwner {
1560         require(address(this).balance > 0, "No balance to withdraw");
1561 
1562         (bool success, ) = creatorAddress.call{value: address(this).balance}("");
1563         require(success, "Withdrawal failed");
1564     }
1565 
1566     function tokensOwnedBy(address wallet) public view returns(uint256[] memory) {
1567         uint tokenCount = balanceOf(wallet);
1568 
1569         uint256[] memory ownedTokenIds = new uint256[](tokenCount);
1570         for(uint i = 0; i < tokenCount; i++){
1571             ownedTokenIds[i] = tokenOfOwnerByIndex(wallet, i);
1572         }
1573 
1574         return ownedTokenIds;
1575     }
1576     
1577     function stake(uint tokenId) public {
1578         require(ownerOf(tokenId) == msg.sender, "Not your token");
1579         require(staked[tokenId] == 0, "Token already staked");
1580         staked[tokenId] = block.number;
1581     }
1582     
1583     function unstake(uint tokenId) public {
1584         require(ownerOf(tokenId) == msg.sender, "Not your token");
1585         require(staked[tokenId] > 0, "Token not staked");
1586         uint dif = block.number-staked[tokenId];
1587         uint tokensEarned = dif.div(100);
1588         staked[tokenId] = 0;
1589         tokenBalance[msg.sender] += tokensEarned;
1590     }
1591     
1592     function collectTokens(uint tokenId) public {
1593         require(ownerOf(tokenId) == msg.sender, "Not your token");
1594         require(staked[tokenId] > 0, "Token not staked");
1595         uint dif = block.number-staked[tokenId];
1596         uint tokensEarned = dif.div(100);
1597         staked[tokenId] = block.number;
1598         tokenBalance[msg.sender] += tokensEarned;
1599     }
1600     
1601     function _transfer(address from, address to, uint256 tokenId) internal override {
1602         require(staked[tokenId] == 0, "Token being staked");
1603         require(mintPublic, "No transfers until public mint");
1604         super._transfer(from, to, tokenId);
1605     }
1606     
1607     function transferToken(address to, uint amount) public {
1608         require(tokenBalance[msg.sender] >= amount, "NSF");
1609         tokenBalance[msg.sender] = tokenBalance[msg.sender].sub(amount);
1610         tokenBalance[to] = tokenBalance[to].add(amount);
1611     }
1612     
1613 }