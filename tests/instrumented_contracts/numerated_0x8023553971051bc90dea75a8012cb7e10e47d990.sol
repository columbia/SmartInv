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
834     function renounceOwnership() public virtual onlyOwner {
835         emit OwnershipTransferred(_owner, address(0));
836         _setOwner(address(0));
837     }
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
1419 contract FlyTops  is ERC721Enumerable, Ownable
1420 {
1421     using SafeMath for uint256;
1422     using Address for address;
1423     using Strings for uint256;
1424 
1425     uint public constant _TOTALSUPPLY = 999;
1426     uint public maxQuantity = 10;
1427     uint256 public price = 80000000000000000; // 0.08 ETH
1428     bool public isPaused = true;
1429     uint public reserve = 55;
1430     uint256 public nextTokenId=1;
1431 
1432     constructor(string memory baseURI) ERC721("Fly-Tops", "MVX1")  {
1433         setBaseURI(baseURI);
1434     }
1435     function setBaseURI(string memory baseURI) public onlyOwner {
1436         _baseURI = baseURI;
1437     }
1438 
1439     function setPrice(uint256 _newPrice) public onlyOwner() {
1440         price = _newPrice;
1441     }
1442     function setMaxQtPerTx(uint256 _quantity) public onlyOwner {
1443         maxQuantity=_quantity;
1444     }
1445 
1446     function mintReserveForOwner(uint quantity) public onlyOwner {
1447         require(quantity <= reserve, "The quantity exceeds the reserve.");
1448         reserve -= quantity;
1449         for (uint i = 0; i < quantity; i++) {
1450             _safeMint(msg.sender, nextTokenId++);
1451         }
1452     }
1453 
1454     function mintReserveForOthers(address walletAddress, uint quantity) public onlyOwner {
1455         require(quantity <= reserve, "The quantity exceeds the reserve.");
1456         reserve -= quantity;
1457         for (uint i = 0; i < quantity; i++) {
1458             _safeMint(walletAddress, nextTokenId++);
1459         }
1460     }
1461 
1462 
1463     modifier isSaleOpen{
1464         require(totalSupply() < _TOTALSUPPLY, "Sale end");
1465         _;
1466     }
1467     function flipPauseStatus() public onlyOwner {
1468         isPaused = !isPaused;
1469     }
1470 
1471     function mint(uint chosenAmount) public payable isSaleOpen{
1472         require(isPaused == false, "Sale is not active at the moment");
1473         require(chosenAmount > 0, "Number of tokens can not be less than or equal to 0");
1474         require(chosenAmount <= maxQuantity,"Chosen Amount exceeds MaxQuantity");
1475         require((nextTokenId-1).add(chosenAmount + reserve) <= _TOTALSUPPLY, "Purchase would exceed max supply");
1476         require(price.mul(chosenAmount) == msg.value, "Sent ether value is incorrect");
1477 
1478         for (uint i = 0; i < chosenAmount; i++) {
1479             _safeMint(msg.sender, nextTokenId++);
1480         }
1481     }
1482  
1483     function tokensOfOwner(address _owner) public view returns (uint256[] memory)
1484     {
1485         uint256 count = balanceOf(_owner);
1486         uint256[] memory result = new uint256[](count);
1487         for (uint256 index = 0; index < count; index++) {
1488             result[index] = tokenOfOwnerByIndex(_owner, index);
1489         }
1490         return result;
1491     }
1492 
1493     function withdraw() public onlyOwner {
1494         uint balance = address(this).balance;
1495         payable(msg.sender).transfer(balance);
1496     }
1497 }