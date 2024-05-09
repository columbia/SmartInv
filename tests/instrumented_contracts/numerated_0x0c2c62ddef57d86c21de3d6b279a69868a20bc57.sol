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
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(
191         uint256 a,
192         uint256 b,
193         string memory errorMessage
194     ) internal pure returns (uint256) {
195         unchecked {
196             require(b > 0, errorMessage);
197             return a / b;
198         }
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * reverting with custom message when dividing by zero.
204      *
205      * CAUTION: This function is deprecated because it requires allocating memory for the error
206      * message unnecessarily. For custom revert reasons use {tryMod}.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(
217         uint256 a,
218         uint256 b,
219         string memory errorMessage
220     ) internal pure returns (uint256) {
221         unchecked {
222             require(b > 0, errorMessage);
223             return a % b;
224         }
225     }
226 }
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev String operations.
232  */
233 library Strings {
234     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
235 
236     /**
237      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
238      */
239     function toString(uint256 value) internal pure returns (string memory) {
240         // Inspired by OraclizeAPI's implementation - MIT licence
241         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
242 
243         if (value == 0) {
244             return "0";
245         }
246         uint256 temp = value;
247         uint256 digits;
248         while (temp != 0) {
249             digits++;
250             temp /= 10;
251         }
252         bytes memory buffer = new bytes(digits);
253         while (value != 0) {
254             digits -= 1;
255             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
256             value /= 10;
257         }
258         return string(buffer);
259     }
260 
261     /**
262      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
263      */
264     function toHexString(uint256 value) internal pure returns (string memory) {
265         if (value == 0) {
266             return "0x00";
267         }
268         uint256 temp = value;
269         uint256 length = 0;
270         while (temp != 0) {
271             length++;
272             temp >>= 8;
273         }
274         return toHexString(value, length);
275     }
276 
277     /**
278      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
279      */
280     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
281         bytes memory buffer = new bytes(2 * length + 2);
282         buffer[0] = "0";
283         buffer[1] = "x";
284         for (uint256 i = 2 * length + 1; i > 1; --i) {
285             buffer[i] = _HEX_SYMBOLS[value & 0xf];
286             value >>= 4;
287         }
288         require(value == 0, "Strings: hex length insufficient");
289         return string(buffer);
290     }
291 }
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @dev Collection of functions related to the address type
297  */
298 library Address {
299     /**
300      * @dev Returns true if `account` is a contract.
301      *
302      * [IMPORTANT]
303      * ====
304      * It is unsafe to assume that an address for which this function returns
305      * false is an externally-owned account (EOA) and not a contract.
306      *
307      * Among others, `isContract` will return false for the following
308      * types of addresses:
309      *
310      *  - an externally-owned account
311      *  - a contract in construction
312      *  - an address where a contract will be created
313      *  - an address where a contract lived, but was destroyed
314      * ====
315      */
316     function isContract(address account) internal view returns (bool) {
317         // This method relies on extcodesize, which returns 0 for contracts in
318         // construction, since the code is only stored at the end of the
319         // constructor execution.
320 
321         uint256 size;
322         assembly {
323             size := extcodesize(account)
324         }
325         return size > 0;
326     }
327 
328     /**
329      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
330      * `recipient`, forwarding all available gas and reverting on errors.
331      *
332      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
333      * of certain opcodes, possibly making contracts go over the 2300 gas limit
334      * imposed by `transfer`, making them unable to receive funds via
335      * `transfer`. {sendValue} removes this limitation.
336      *
337      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
338      *
339      * IMPORTANT: because control is transferred to `recipient`, care must be
340      * taken to not create reentrancy vulnerabilities. Consider using
341      * {ReentrancyGuard} or the
342      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
343      */
344     function sendValue(address payable recipient, uint256 amount) internal {
345         require(address(this).balance >= amount, "Address: insufficient balance");
346 
347         (bool success, ) = recipient.call{value: amount}("");
348         require(success, "Address: unable to send value, recipient may have reverted");
349     }
350 
351     /**
352      * @dev Performs a Solidity function call using a low level `call`. A
353      * plain `call` is an unsafe replacement for a function call: use this
354      * function instead.
355      *
356      * If `target` reverts with a revert reason, it is bubbled up by this
357      * function (like regular Solidity function calls).
358      *
359      * Returns the raw returned data. To convert to the expected return value,
360      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
361      *
362      * Requirements:
363      *
364      * - `target` must be a contract.
365      * - calling `target` with `data` must not revert.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
370         return functionCall(target, data, "Address: low-level call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
375      * `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, 0, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but also transferring `value` wei to `target`.
390      *
391      * Requirements:
392      *
393      * - the calling contract must have an ETH balance of at least `value`.
394      * - the called Solidity function must be `payable`.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(
399         address target,
400         bytes memory data,
401         uint256 value
402     ) internal returns (bytes memory) {
403         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
408      * with `errorMessage` as a fallback revert reason when `target` reverts.
409      *
410      * _Available since v3.1._
411      */
412     function functionCallWithValue(
413         address target,
414         bytes memory data,
415         uint256 value,
416         string memory errorMessage
417     ) internal returns (bytes memory) {
418         require(address(this).balance >= value, "Address: insufficient balance for call");
419         require(isContract(target), "Address: call to non-contract");
420 
421         (bool success, bytes memory returndata) = target.call{value: value}(data);
422         return _verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but performing a static call.
428      *
429      * _Available since v3.3._
430      */
431     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
432         return functionStaticCall(target, data, "Address: low-level static call failed");
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
437      * but performing a static call.
438      *
439      * _Available since v3.3._
440      */
441     function functionStaticCall(
442         address target,
443         bytes memory data,
444         string memory errorMessage
445     ) internal view returns (bytes memory) {
446         require(isContract(target), "Address: static call to non-contract");
447 
448         (bool success, bytes memory returndata) = target.staticcall(data);
449         return _verifyCallResult(success, returndata, errorMessage);
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
454      * but performing a delegate call.
455      *
456      * _Available since v3.4._
457      */
458     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
459         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
464      * but performing a delegate call.
465      *
466      * _Available since v3.4._
467      */
468     function functionDelegateCall(
469         address target,
470         bytes memory data,
471         string memory errorMessage
472     ) internal returns (bytes memory) {
473         require(isContract(target), "Address: delegate call to non-contract");
474 
475         (bool success, bytes memory returndata) = target.delegatecall(data);
476         return _verifyCallResult(success, returndata, errorMessage);
477     }
478 
479     function _verifyCallResult(
480         bool success,
481         bytes memory returndata,
482         string memory errorMessage
483     ) private pure returns (bytes memory) {
484         if (success) {
485             return returndata;
486         } else {
487             // Look for revert reason and bubble it up if present
488             if (returndata.length > 0) {
489                 // The easiest way to bubble the revert reason is using memory via assembly
490 
491                 assembly {
492                     let returndata_size := mload(returndata)
493                     revert(add(32, returndata), returndata_size)
494                 }
495             } else {
496                 revert(errorMessage);
497             }
498         }
499     }
500 }
501 
502 pragma solidity ^0.8.0;
503 
504 /**
505  * @title ERC721 token receiver interface
506  * @dev Interface for any contract that wants to support safeTransfers
507  * from ERC721 asset contracts.
508  */
509 interface IERC721Receiver {
510     /**
511      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
512      * by `operator` from `from`, this function is called.
513      *
514      * It must return its Solidity selector to confirm the token transfer.
515      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
516      *
517      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
518      */
519     function onERC721Received(
520         address operator,
521         address from,
522         uint256 tokenId,
523         bytes calldata data
524     ) external returns (bytes4);
525 }
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @dev Interface of the ERC165 standard, as defined in the
531  * https://eips.ethereum.org/EIPS/eip-165[EIP].
532  *
533  * Implementers can declare support of contract interfaces, which can then be
534  * queried by others ({ERC165Checker}).
535  *
536  * For an implementation, see {ERC165}.
537  */
538 interface IERC165 {
539     /**
540      * @dev Returns true if this contract implements the interface defined by
541      * `interfaceId`. See the corresponding
542      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
543      * to learn more about how these ids are created.
544      *
545      * This function call must use less than 30 000 gas.
546      */
547     function supportsInterface(bytes4 interfaceId) external view returns (bool);
548 }
549 
550 pragma solidity ^0.8.0;
551 
552 /**
553  * @dev Implementation of the {IERC165} interface.
554  *
555  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
556  * for the additional interface id that will be supported. For example:
557  *
558  * ```solidity
559  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
560  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
561  * }
562  * ```
563  *
564  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
565  */
566 abstract contract ERC165 is IERC165 {
567     /**
568      * @dev See {IERC165-supportsInterface}.
569      */
570     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
571         return interfaceId == type(IERC165).interfaceId;
572     }
573 }
574 
575 pragma solidity ^0.8.0;
576 
577 /**
578  * @dev Required interface of an ERC721 compliant contract.
579  */
580 interface IERC721 is IERC165 {
581     /**
582      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
583      */
584     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
585 
586     /**
587      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
588      */
589     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
590 
591     /**
592      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
593      */
594     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
595 
596     /**
597      * @dev Returns the number of tokens in ``owner``'s account.
598      */
599     function balanceOf(address owner) external view returns (uint256 balance);
600 
601     /**
602      * @dev Returns the owner of the `tokenId` token.
603      *
604      * Requirements:
605      *
606      * - `tokenId` must exist.
607      */
608     function ownerOf(uint256 tokenId) external view returns (address owner);
609 
610     /**
611      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
612      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
613      *
614      * Requirements:
615      *
616      * - `from` cannot be the zero address.
617      * - `to` cannot be the zero address.
618      * - `tokenId` token must exist and be owned by `from`.
619      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
620      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
621      *
622      * Emits a {Transfer} event.
623      */
624     function safeTransferFrom(
625         address from,
626         address to,
627         uint256 tokenId
628     ) external;
629 
630     /**
631      * @dev Transfers `tokenId` token from `from` to `to`.
632      *
633      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
634      *
635      * Requirements:
636      *
637      * - `from` cannot be the zero address.
638      * - `to` cannot be the zero address.
639      * - `tokenId` token must be owned by `from`.
640      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
641      *
642      * Emits a {Transfer} event.
643      */
644     function transferFrom(
645         address from,
646         address to,
647         uint256 tokenId
648     ) external;
649 
650     /**
651      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
652      * The approval is cleared when the token is transferred.
653      *
654      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
655      *
656      * Requirements:
657      *
658      * - The caller must own the token or be an approved operator.
659      * - `tokenId` must exist.
660      *
661      * Emits an {Approval} event.
662      */
663     function approve(address to, uint256 tokenId) external;
664 
665     /**
666      * @dev Returns the account approved for `tokenId` token.
667      *
668      * Requirements:
669      *
670      * - `tokenId` must exist.
671      */
672     function getApproved(uint256 tokenId) external view returns (address operator);
673 
674     /**
675      * @dev Approve or remove `operator` as an operator for the caller.
676      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
677      *
678      * Requirements:
679      *
680      * - The `operator` cannot be the caller.
681      *
682      * Emits an {ApprovalForAll} event.
683      */
684     function setApprovalForAll(address operator, bool _approved) external;
685 
686     /**
687      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
688      *
689      * See {setApprovalForAll}
690      */
691     function isApprovedForAll(address owner, address operator) external view returns (bool);
692 
693     /**
694      * @dev Safely transfers `tokenId` token from `from` to `to`.
695      *
696      * Requirements:
697      *
698      * - `from` cannot be the zero address.
699      * - `to` cannot be the zero address.
700      * - `tokenId` token must exist and be owned by `from`.
701      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
702      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
703      *
704      * Emits a {Transfer} event.
705      */
706     function safeTransferFrom(
707         address from,
708         address to,
709         uint256 tokenId,
710         bytes calldata data
711     ) external;
712 }
713 
714 pragma solidity ^0.8.0;
715 
716 /**
717  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
718  * @dev See https://eips.ethereum.org/EIPS/eip-721
719  */
720 interface IERC721Enumerable is IERC721 {
721     /**
722      * @dev Returns the total amount of tokens stored by the contract.
723      */
724     function totalSupply() external view returns (uint256);
725 
726     /**
727      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
728      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
729      */
730     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
731 
732     /**
733      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
734      * Use along with {totalSupply} to enumerate all tokens.
735      */
736     function tokenByIndex(uint256 index) external view returns (uint256);
737 }
738 
739 pragma solidity ^0.8.0;
740 
741 /**
742  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
743  * @dev See https://eips.ethereum.org/EIPS/eip-721
744  */
745 interface IERC721Metadata is IERC721 {
746     /**
747      * @dev Returns the token collection name.
748      */
749     function name() external view returns (string memory);
750 
751     /**
752      * @dev Returns the token collection symbol.
753      */
754     function symbol() external view returns (string memory);
755 
756     /**
757      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
758      */
759     function tokenURI(uint256 tokenId) external view returns (string memory);
760 }
761 
762 pragma solidity ^0.8.0;
763 
764 /*
765  * @dev Provides information about the current execution context, including the
766  * sender of the transaction and its data. While these are generally available
767  * via msg.sender and msg.data, they should not be accessed in such a direct
768  * manner, since when dealing with meta-transactions the account sending and
769  * paying for execution may not be the actual sender (as far as an application
770  * is concerned).
771  *
772  * This contract is only required for intermediate, library-like contracts.
773  */
774 abstract contract Context {
775     function _msgSender() internal view virtual returns (address) {
776         return msg.sender;
777     }
778 
779     function _msgData() internal view virtual returns (bytes calldata) {
780         return msg.data;
781     }
782 }
783 
784 pragma solidity ^0.8.0;
785 
786 /**
787  * @dev Contract module which provides a basic access control mechanism, where
788  * there is an account (an owner) that can be granted exclusive access to
789  * specific functions.
790  *
791  * By default, the owner account will be the one that deploys the contract. This
792  * can later be changed with {transferOwnership}.
793  *
794  * This module is used through inheritance. It will make available the modifier
795  * `onlyOwner`, which can be applied to your functions to restrict their use to
796  * the owner.
797  */
798 abstract contract Ownable is Context {
799     address private _owner;
800 
801     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
802 
803     /**
804      * @dev Initializes the contract setting the deployer as the initial owner.
805      */
806     constructor () {
807         address msgSender = _msgSender();
808         _owner = msgSender;
809         emit OwnershipTransferred(address(0), msgSender);
810     }
811 
812     /**
813      * @dev Returns the address of the current owner.
814      */
815     function owner() public view virtual returns (address) {
816         return _owner;
817     }
818 
819     /**
820      * @dev Throws if called by any account other than the owner.
821      */
822     modifier onlyOwner() {
823         require(owner() == _msgSender(), "Ownable: caller is not the owner");
824         _;
825     }
826 
827     /**
828      * @dev Leaves the contract without owner. It will not be possible to call
829      * `onlyOwner` functions anymore. Can only be called by the current owner.
830      *
831      * NOTE: Renouncing ownership will leave the contract without an owner,
832      * thereby removing any functionality that is only available to the owner.
833      */
834 
835     /**
836      * @dev Transfers ownership of the contract to a new account (`newOwner`).
837      * Can only be called by the current owner.
838      */
839     function transferOwnership(address newOwner) public virtual onlyOwner {
840         require(newOwner != address(0), "Ownable: new owner is the zero address");
841         _setOwner(newOwner);
842     }
843 
844     function _setOwner(address newOwner) private {
845         address oldOwner = _owner;
846         _owner = newOwner;
847         emit OwnershipTransferred(oldOwner, newOwner);
848     }
849 }
850 
851 pragma solidity ^0.8.0;
852 
853 /**
854  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
855  * the Metadata extension, but not including the Enumerable extension, which is available separately as
856  * {ERC721Enumerable}.
857  */
858 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
859     using Address for address;
860     using Strings for uint256;
861 
862     // Token name
863     string private _name;
864 
865     // Token symbol
866     string private _symbol;
867 
868     // Mapping from token ID to owner address
869     mapping(uint256 => address) private _owners;
870 
871     // Mapping owner address to token count
872     mapping(address => uint256) private _balances;
873 
874     // Mapping from token ID to approved address
875     mapping(uint256 => address) private _tokenApprovals;
876 
877     // Mapping from owner to operator approvals
878     mapping(address => mapping(address => bool)) private _operatorApprovals;
879 
880 
881     string public _baseURI;
882     /**
883      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
884      */
885     constructor(string memory name_, string memory symbol_) {
886         _name = name_;
887         _symbol = symbol_;
888     }
889 
890     /**
891      * @dev See {IERC165-supportsInterface}.
892      */
893     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
894         return
895             interfaceId == type(IERC721).interfaceId ||
896             interfaceId == type(IERC721Metadata).interfaceId ||
897             super.supportsInterface(interfaceId);
898     }
899 
900     /**
901      * @dev See {IERC721-balanceOf}.
902      */
903     function balanceOf(address owner) public view virtual override returns (uint256) {
904         require(owner != address(0), "ERC721: balance query for the zero address");
905         return _balances[owner];
906     }
907 
908     /**
909      * @dev See {IERC721-ownerOf}.
910      */
911     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
912         address owner = _owners[tokenId];
913         require(owner != address(0), "ERC721: owner query for nonexistent token");
914         return owner;
915     }
916 
917     /**
918      * @dev See {IERC721Metadata-name}.
919      */
920     function name() public view virtual override returns (string memory) {
921         return _name;
922     }
923 
924     /**
925      * @dev See {IERC721Metadata-symbol}.
926      */
927     function symbol() public view virtual override returns (string memory) {
928         return _symbol;
929     }
930 
931     /**
932      * @dev See {IERC721Metadata-tokenURI}.
933      */
934     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
935         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
936 
937         string memory base = baseURI();
938         return bytes(base).length > 0 ? string(abi.encodePacked(base, tokenId.toString())) : "";
939     }
940 
941     /**
942      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
943      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
944      * by default, can be overriden in child contracts.
945      */
946     function baseURI() internal view virtual returns (string memory) {
947         return _baseURI;
948     }
949 
950     /**
951      * @dev See {IERC721-approve}.
952      */
953     function approve(address to, uint256 tokenId) public virtual override {
954         address owner = ERC721.ownerOf(tokenId);
955         require(to != owner, "ERC721: approval to current owner");
956 
957         require(
958             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
959             "ERC721: approve caller is not owner nor approved for all"
960         );
961 
962         _approve(to, tokenId);
963     }
964 
965     /**
966      * @dev See {IERC721-getApproved}.
967      */
968     function getApproved(uint256 tokenId) public view virtual override returns (address) {
969         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
970 
971         return _tokenApprovals[tokenId];
972     }
973 
974     /**
975      * @dev See {IERC721-setApprovalForAll}.
976      */
977     function setApprovalForAll(address operator, bool approved) public virtual override {
978         require(operator != _msgSender(), "ERC721: approve to caller");
979 
980         _operatorApprovals[_msgSender()][operator] = approved;
981         emit ApprovalForAll(_msgSender(), operator, approved);
982     }
983 
984     /**
985      * @dev See {IERC721-isApprovedForAll}.
986      */
987     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
988         return _operatorApprovals[owner][operator];
989     }
990 
991     /**
992      * @dev See {IERC721-transferFrom}.
993      */
994     function transferFrom(
995         address from,
996         address to,
997         uint256 tokenId
998     ) public virtual override {
999         //solhint-disable-next-line max-line-length
1000         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1001 
1002         _transfer(from, to, tokenId);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-safeTransferFrom}.
1007      */
1008     function safeTransferFrom(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) public virtual override {
1013         safeTransferFrom(from, to, tokenId, "");
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-safeTransferFrom}.
1018      */
1019     function safeTransferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId,
1023         bytes memory _data
1024     ) public virtual override {
1025         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1026         _safeTransfer(from, to, tokenId, _data);
1027     }
1028 
1029     /**
1030      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1031      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1032      *
1033      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1034      *
1035      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1036      * implement alternative mechanisms to perform token transfer, such as signature-based.
1037      *
1038      * Requirements:
1039      *
1040      * - `from` cannot be the zero address.
1041      * - `to` cannot be the zero address.
1042      * - `tokenId` token must exist and be owned by `from`.
1043      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function _safeTransfer(
1048         address from,
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) internal virtual {
1053         _transfer(from, to, tokenId);
1054         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1055     }
1056 
1057     /**
1058      * @dev Returns whether `tokenId` exists.
1059      *
1060      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1061      *
1062      * Tokens start existing when they are minted (`_mint`),
1063      * and stop existing when they are burned (`_burn`).
1064      */
1065     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1066         return _owners[tokenId] != address(0);
1067     }
1068 
1069     /**
1070      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1071      *
1072      * Requirements:
1073      *
1074      * - `tokenId` must exist.
1075      */
1076     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1077         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1078         address owner = ERC721.ownerOf(tokenId);
1079         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1080     }
1081 
1082     /**
1083      * @dev Safely mints `tokenId` and transfers it to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - `tokenId` must not exist.
1088      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _safeMint(address to, uint256 tokenId) internal virtual {
1093         _safeMint(to, tokenId, "");
1094     }
1095 
1096     /**
1097      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1098      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1099      */
1100     function _safeMint(
1101         address to,
1102         uint256 tokenId,
1103         bytes memory _data
1104     ) internal virtual {
1105         _mint(to, tokenId);
1106         require(
1107             _checkOnERC721Received(address(0), to, tokenId, _data),
1108             "ERC721: transfer to non ERC721Receiver implementer"
1109         );
1110     }
1111 
1112     /**
1113      * @dev Mints `tokenId` and transfers it to `to`.
1114      *
1115      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1116      *
1117      * Requirements:
1118      *
1119      * - `tokenId` must not exist.
1120      * - `to` cannot be the zero address.
1121      *
1122      * Emits a {Transfer} event.
1123      */
1124     function _mint(address to, uint256 tokenId) internal virtual {
1125         require(to != address(0), "ERC721: mint to the zero address");
1126         require(!_exists(tokenId), "ERC721: token already minted");
1127 
1128         _beforeTokenTransfer(address(0), to, tokenId);
1129 
1130         _balances[to] += 1;
1131         _owners[tokenId] = to;
1132 
1133         emit Transfer(address(0), to, tokenId);
1134     }
1135 
1136     /**
1137      * @dev Destroys `tokenId`.
1138      * The approval is cleared when the token is burned.
1139      *
1140      * Requirements:
1141      *
1142      * - `tokenId` must exist.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _burn(uint256 tokenId) internal virtual {
1147         address owner = ERC721.ownerOf(tokenId);
1148 
1149         _beforeTokenTransfer(owner, address(0), tokenId);
1150 
1151         // Clear approvals
1152         _approve(address(0), tokenId);
1153 
1154         _balances[owner] -= 1;
1155         delete _owners[tokenId];
1156 
1157         emit Transfer(owner, address(0), tokenId);
1158     }
1159 
1160     /**
1161      * @dev Transfers `tokenId` from `from` to `to`.
1162      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1163      *
1164      * Requirements:
1165      *
1166      * - `to` cannot be the zero address.
1167      * - `tokenId` token must be owned by `from`.
1168      *
1169      * Emits a {Transfer} event.
1170      */
1171     function _transfer(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) internal virtual {
1176         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1177         require(to != address(0), "ERC721: transfer to the zero address");
1178 
1179         _beforeTokenTransfer(from, to, tokenId);
1180 
1181         // Clear approvals from the previous owner
1182         _approve(address(0), tokenId);
1183 
1184         _balances[from] -= 1;
1185         _balances[to] += 1;
1186         _owners[tokenId] = to;
1187 
1188         emit Transfer(from, to, tokenId);
1189     }
1190 
1191     /**
1192      * @dev Approve `to` to operate on `tokenId`
1193      *
1194      * Emits a {Approval} event.
1195      */
1196     function _approve(address to, uint256 tokenId) internal virtual {
1197         _tokenApprovals[tokenId] = to;
1198         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1199     }
1200 
1201     /**
1202      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1203      * The call is not executed if the target address is not a contract.
1204      *
1205      * @param from address representing the previous owner of the given token ID
1206      * @param to target address that will receive the tokens
1207      * @param tokenId uint256 ID of the token to be transferred
1208      * @param _data bytes optional data to send along with the call
1209      * @return bool whether the call correctly returned the expected magic value
1210      */
1211     function _checkOnERC721Received(
1212         address from,
1213         address to,
1214         uint256 tokenId,
1215         bytes memory _data
1216     ) private returns (bool) {
1217         if (to.isContract()) {
1218             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1219                 return retval == IERC721Receiver(to).onERC721Received.selector;
1220             } catch (bytes memory reason) {
1221                 if (reason.length == 0) {
1222                     revert("ERC721: transfer to non ERC721Receiver implementer");
1223                 } else {
1224                     assembly {
1225                         revert(add(32, reason), mload(reason))
1226                     }
1227                 }
1228             }
1229         } else {
1230             return true;
1231         }
1232     }
1233 
1234     /**
1235      * @dev Hook that is called before any token transfer. This includes minting
1236      * and burning.
1237      *
1238      * Calling conditions:
1239      *
1240      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1241      * transferred to `to`.
1242      * - When `from` is zero, `tokenId` will be minted for `to`.
1243      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1244      * - `from` and `to` are never both zero.
1245      *
1246      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1247      */
1248     function _beforeTokenTransfer(
1249         address from,
1250         address to,
1251         uint256 tokenId
1252     ) internal virtual {}
1253 }
1254 
1255 pragma solidity ^0.8.0;
1256 
1257 /**
1258  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1259  * enumerability of all the token ids in the contract as well as all token ids owned by each
1260  * account.
1261  */
1262 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1263     // Mapping from owner to list of owned token IDs
1264     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1265 
1266     // Mapping from token ID to index of the owner tokens list
1267     mapping(uint256 => uint256) private _ownedTokensIndex;
1268 
1269     // Array with all token ids, used for enumeration
1270     uint256[] private _allTokens;
1271 
1272     // Mapping from token id to position in the allTokens array
1273     mapping(uint256 => uint256) private _allTokensIndex;
1274 
1275     /**
1276      * @dev See {IERC165-supportsInterface}.
1277      */
1278     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1279         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1280     }
1281 
1282     /**
1283      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1284      */
1285     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1286         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1287         return _ownedTokens[owner][index];
1288     }
1289 
1290     /**
1291      * @dev See {IERC721Enumerable-totalSupply}.
1292      */
1293     function totalSupply() public view virtual override returns (uint256) {
1294         return _allTokens.length;
1295     }
1296 
1297     /**
1298      * @dev See {IERC721Enumerable-tokenByIndex}.
1299      */
1300     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1301         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1302         return _allTokens[index];
1303     }
1304 
1305     /**
1306      * @dev Hook that is called before any token transfer. This includes minting
1307      * and burning.
1308      *
1309      * Calling conditions:
1310      *
1311      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1312      * transferred to `to`.
1313      * - When `from` is zero, `tokenId` will be minted for `to`.
1314      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1315      * - `from` cannot be the zero address.
1316      * - `to` cannot be the zero address.
1317      *
1318      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1319      */
1320     function _beforeTokenTransfer(
1321         address from,
1322         address to,
1323         uint256 tokenId
1324     ) internal virtual override {
1325         super._beforeTokenTransfer(from, to, tokenId);
1326 
1327         if (from == address(0)) {
1328             _addTokenToAllTokensEnumeration(tokenId);
1329         } else if (from != to) {
1330             _removeTokenFromOwnerEnumeration(from, tokenId);
1331         }
1332         if (to == address(0)) {
1333             _removeTokenFromAllTokensEnumeration(tokenId);
1334         } else if (to != from) {
1335             _addTokenToOwnerEnumeration(to, tokenId);
1336         }
1337     }
1338 
1339     /**
1340      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1341      * @param to address representing the new owner of the given token ID
1342      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1343      */
1344     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1345         uint256 length = ERC721.balanceOf(to);
1346         _ownedTokens[to][length] = tokenId;
1347         _ownedTokensIndex[tokenId] = length;
1348     }
1349 
1350     /**
1351      * @dev Private function to add a token to this extension's token tracking data structures.
1352      * @param tokenId uint256 ID of the token to be added to the tokens list
1353      */
1354     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1355         _allTokensIndex[tokenId] = _allTokens.length;
1356         _allTokens.push(tokenId);
1357     }
1358 
1359     /**
1360      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1361      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1362      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1363      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1364      * @param from address representing the previous owner of the given token ID
1365      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1366      */
1367     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1368         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1369         // then delete the last slot (swap and pop).
1370 
1371         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1372         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1373 
1374         // When the token to delete is the last token, the swap operation is unnecessary
1375         if (tokenIndex != lastTokenIndex) {
1376             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1377 
1378             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1379             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1380         }
1381 
1382         // This also deletes the contents at the last position of the array
1383         delete _ownedTokensIndex[tokenId];
1384         delete _ownedTokens[from][lastTokenIndex];
1385     }
1386 
1387     /**
1388      * @dev Private function to remove a token from this extension's token tracking data structures.
1389      * This has O(1) time complexity, but alters the order of the _allTokens array.
1390      * @param tokenId uint256 ID of the token to be removed from the tokens list
1391      */
1392     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1393         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1394         // then delete the last slot (swap and pop).
1395 
1396         uint256 lastTokenIndex = _allTokens.length - 1;
1397         uint256 tokenIndex = _allTokensIndex[tokenId];
1398 
1399         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1400         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1401         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1402         uint256 lastTokenId = _allTokens[lastTokenIndex];
1403 
1404         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1405         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1406 
1407         // This also deletes the contents at the last position of the array
1408         delete _allTokensIndex[tokenId];
1409         _allTokens.pop();
1410     }
1411 }
1412 
1413 
1414 /**
1415  * @dev Interface of the ERC165 standard, as defined in the
1416  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1417  *
1418  * Implementers can declare support of contract interfaces, which can then be
1419  * queried by others ({ERC165Checker}).
1420  *
1421  * For an implementation, see {ERC165}.
1422  */
1423  
1424 
1425 pragma solidity ^0.8.0;
1426 
1427 contract  DegenSantas  is ERC721Enumerable, Ownable
1428 {
1429     using SafeMath for uint256;
1430     uint maxSupply=10000;
1431     uint private tokenId=1;
1432     bool public isPreSalePaused=true;
1433     bool public isPaused=true;
1434     uint public publicMintCounter=3;
1435         struct SpecificAddresses{
1436         
1437         
1438         address userAddress;
1439         uint counter;
1440     }
1441     struct PublicMintAddresses{
1442         
1443         
1444         address userAddress;
1445         uint counter;
1446     }
1447     mapping(address => SpecificAddresses) public _whiteList;
1448     mapping(address => PublicMintAddresses) public _publicMintList;
1449 
1450     mapping(address=>bool) public _addressExist;
1451     mapping(address=>bool) public _publicAddressExist;
1452     constructor(string memory baseURI) ERC721("Degen Santas", "SANTA")  {
1453         setBaseURI(baseURI);
1454     }
1455     function setBaseURI(string memory baseURI) public onlyOwner {
1456         _baseURI = baseURI;
1457     }
1458     function flipPauseStatus() public onlyOwner {
1459         isPaused = !isPaused;
1460     }
1461     function updatePublicMintCounter(uint counter) public onlyOwner {
1462         publicMintCounter = counter;
1463     }
1464     function flipPreSalePauseStatus() public onlyOwner {
1465         isPreSalePaused = !isPreSalePaused;
1466     }
1467     function addWhiteListBundle(address[] memory whiteAddress,uint [] memory counter)public onlyOwner {
1468             for (uint i = 0; i < whiteAddress.length; i++)
1469             {
1470 
1471         require(!_addressExist[whiteAddress[i]],"Address already Exist");
1472         _whiteList[whiteAddress[i]]=SpecificAddresses({
1473              userAddress :whiteAddress[i],
1474             counter:counter[i]
1475            });
1476            _addressExist[whiteAddress[i]]=true;
1477     }
1478         }
1479         
1480    function preSalemint(uint quantity) public {
1481          
1482         
1483      require(isPreSalePaused == false, "Sale is not active at the moment");
1484       require(totalSupply()+quantity<=maxSupply,"Quantity is greater than remaining Supply");
1485         require(_addressExist[msg.sender]==true,"Address not Found in whitelist");
1486         SpecificAddresses storage myaddress = _whiteList[msg.sender];
1487         require(myaddress.counter>=quantity,"The Amount Selected is Greater than the Remaining Amount of the Token at this Address");
1488 
1489          for (uint256 i; i < quantity; i++) {
1490             _safeMint(msg.sender, totalsupply());
1491             tokenId++;
1492             
1493         }
1494     
1495         myaddress.counter-=quantity;
1496        
1497     }
1498      function mint(uint quantity) public {
1499     
1500         require(isPaused == false, "Sale is not active at the moment");
1501         require(quantity>0,"quantity less than one");
1502         require(totalSupply()+quantity<=maxSupply,"Quantity is greater than remaining Supply");
1503         if(_publicAddressExist[msg.sender]==false)
1504         {
1505              _publicMintList[msg.sender]=PublicMintAddresses({
1506              userAddress :msg.sender,
1507             counter:publicMintCounter
1508           });
1509         PublicMintAddresses storage myaddress = _publicMintList[msg.sender];
1510         require(quantity<=myaddress.counter,"The Amount Selected is Greater than the Remaining Amount of the Token at this Address");
1511          for (uint256 i; i < quantity; i++) {
1512             _safeMint(msg.sender, totalsupply());
1513             tokenId++;
1514             
1515         }
1516           
1517           _publicAddressExist[msg.sender]=true;
1518           myaddress.counter-=quantity;
1519         }
1520         else
1521         {
1522        
1523      
1524         PublicMintAddresses storage myaddress = _publicMintList[msg.sender];
1525         require(quantity<=myaddress.counter,"The Amount Selected is Greater than the Remaining Amount of the Token at this Address");
1526          for (uint256 i; i < quantity; i++) {
1527             _safeMint(msg.sender, totalsupply());
1528             tokenId++;
1529             
1530         }
1531         myaddress.counter-=quantity;
1532        
1533         
1534     }
1535     
1536    
1537         
1538      }
1539 
1540     
1541  
1542     function tokensOfOwner(address _owner) public view returns (uint256[] memory)
1543     {
1544         uint256 count = balanceOf(_owner);
1545         uint256[] memory result = new uint256[](count);
1546         for (uint256 index = 0; index < count; index++) {
1547             result[index] = tokenOfOwnerByIndex(_owner, index);
1548         }
1549         return result;
1550     }
1551 
1552     function withdraw() public onlyOwner {
1553         uint balance = address(this).balance;
1554         payable(msg.sender).transfer(balance);
1555     }
1556     function totalsupply() private view returns (uint)
1557    
1558     {
1559         return tokenId;
1560     }
1561 }