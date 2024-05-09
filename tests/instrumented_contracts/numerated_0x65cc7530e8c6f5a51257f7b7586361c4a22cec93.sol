1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/Strings.sol
232 
233 
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @dev String operations.
239  */
240 library Strings {
241     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
242 
243     /**
244      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
245      */
246     function toString(uint256 value) internal pure returns (string memory) {
247         // Inspired by OraclizeAPI's implementation - MIT licence
248         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
249 
250         if (value == 0) {
251             return "0";
252         }
253         uint256 temp = value;
254         uint256 digits;
255         while (temp != 0) {
256             digits++;
257             temp /= 10;
258         }
259         bytes memory buffer = new bytes(digits);
260         while (value != 0) {
261             digits -= 1;
262             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
263             value /= 10;
264         }
265         return string(buffer);
266     }
267 
268     /**
269      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
270      */
271     function toHexString(uint256 value) internal pure returns (string memory) {
272         if (value == 0) {
273             return "0x00";
274         }
275         uint256 temp = value;
276         uint256 length = 0;
277         while (temp != 0) {
278             length++;
279             temp >>= 8;
280         }
281         return toHexString(value, length);
282     }
283 
284     /**
285      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
286      */
287     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
288         bytes memory buffer = new bytes(2 * length + 2);
289         buffer[0] = "0";
290         buffer[1] = "x";
291         for (uint256 i = 2 * length + 1; i > 1; --i) {
292             buffer[i] = _HEX_SYMBOLS[value & 0xf];
293             value >>= 4;
294         }
295         require(value == 0, "Strings: hex length insufficient");
296         return string(buffer);
297     }
298 }
299 
300 // File: @openzeppelin/contracts/utils/Address.sol
301 
302 
303 
304 pragma solidity ^0.8.0;
305 
306 /**
307  * @dev Collection of functions related to the address type
308  */
309 library Address {
310     /**
311      * @dev Returns true if `account` is a contract.
312      *
313      * [IMPORTANT]
314      * ====
315      * It is unsafe to assume that an address for which this function returns
316      * false is an externally-owned account (EOA) and not a contract.
317      *
318      * Among others, `isContract` will return false for the following
319      * types of addresses:
320      *
321      *  - an externally-owned account
322      *  - a contract in construction
323      *  - an address where a contract will be created
324      *  - an address where a contract lived, but was destroyed
325      * ====
326      */
327     function isContract(address account) internal view returns (bool) {
328         // This method relies on extcodesize, which returns 0 for contracts in
329         // construction, since the code is only stored at the end of the
330         // constructor execution.
331 
332         uint256 size;
333         assembly {
334             size := extcodesize(account)
335         }
336         return size > 0;
337     }
338 
339     /**
340      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
341      * `recipient`, forwarding all available gas and reverting on errors.
342      *
343      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
344      * of certain opcodes, possibly making contracts go over the 2300 gas limit
345      * imposed by `transfer`, making them unable to receive funds via
346      * `transfer`. {sendValue} removes this limitation.
347      *
348      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
349      *
350      * IMPORTANT: because control is transferred to `recipient`, care must be
351      * taken to not create reentrancy vulnerabilities. Consider using
352      * {ReentrancyGuard} or the
353      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
354      */
355     function sendValue(address payable recipient, uint256 amount) internal {
356         require(address(this).balance >= amount, "Address: insufficient balance");
357 
358         (bool success, ) = recipient.call{value: amount}("");
359         require(success, "Address: unable to send value, recipient may have reverted");
360     }
361 
362     /**
363      * @dev Performs a Solidity function call using a low level `call`. A
364      * plain `call` is an unsafe replacement for a function call: use this
365      * function instead.
366      *
367      * If `target` reverts with a revert reason, it is bubbled up by this
368      * function (like regular Solidity function calls).
369      *
370      * Returns the raw returned data. To convert to the expected return value,
371      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
372      *
373      * Requirements:
374      *
375      * - `target` must be a contract.
376      * - calling `target` with `data` must not revert.
377      *
378      * _Available since v3.1._
379      */
380     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
381         return functionCall(target, data, "Address: low-level call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
386      * `errorMessage` as a fallback revert reason when `target` reverts.
387      *
388      * _Available since v3.1._
389      */
390     function functionCall(
391         address target,
392         bytes memory data,
393         string memory errorMessage
394     ) internal returns (bytes memory) {
395         return functionCallWithValue(target, data, 0, errorMessage);
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
400      * but also transferring `value` wei to `target`.
401      *
402      * Requirements:
403      *
404      * - the calling contract must have an ETH balance of at least `value`.
405      * - the called Solidity function must be `payable`.
406      *
407      * _Available since v3.1._
408      */
409     function functionCallWithValue(
410         address target,
411         bytes memory data,
412         uint256 value
413     ) internal returns (bytes memory) {
414         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
419      * with `errorMessage` as a fallback revert reason when `target` reverts.
420      *
421      * _Available since v3.1._
422      */
423     function functionCallWithValue(
424         address target,
425         bytes memory data,
426         uint256 value,
427         string memory errorMessage
428     ) internal returns (bytes memory) {
429         require(address(this).balance >= value, "Address: insufficient balance for call");
430         require(isContract(target), "Address: call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.call{value: value}(data);
433         return verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
438      * but performing a static call.
439      *
440      * _Available since v3.3._
441      */
442     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
443         return functionStaticCall(target, data, "Address: low-level static call failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
448      * but performing a static call.
449      *
450      * _Available since v3.3._
451      */
452     function functionStaticCall(
453         address target,
454         bytes memory data,
455         string memory errorMessage
456     ) internal view returns (bytes memory) {
457         require(isContract(target), "Address: static call to non-contract");
458 
459         (bool success, bytes memory returndata) = target.staticcall(data);
460         return verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
465      * but performing a delegate call.
466      *
467      * _Available since v3.4._
468      */
469     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
470         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
475      * but performing a delegate call.
476      *
477      * _Available since v3.4._
478      */
479     function functionDelegateCall(
480         address target,
481         bytes memory data,
482         string memory errorMessage
483     ) internal returns (bytes memory) {
484         require(isContract(target), "Address: delegate call to non-contract");
485 
486         (bool success, bytes memory returndata) = target.delegatecall(data);
487         return verifyCallResult(success, returndata, errorMessage);
488     }
489 
490     /**
491      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
492      * revert reason using the provided one.
493      *
494      * _Available since v4.3._
495      */
496     function verifyCallResult(
497         bool success,
498         bytes memory returndata,
499         string memory errorMessage
500     ) internal pure returns (bytes memory) {
501         if (success) {
502             return returndata;
503         } else {
504             // Look for revert reason and bubble it up if present
505             if (returndata.length > 0) {
506                 // The easiest way to bubble the revert reason is using memory via assembly
507 
508                 assembly {
509                     let returndata_size := mload(returndata)
510                     revert(add(32, returndata), returndata_size)
511                 }
512             } else {
513                 revert(errorMessage);
514             }
515         }
516     }
517 }
518 
519 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
520 
521 
522 
523 pragma solidity ^0.8.0;
524 
525 /**
526  * @title ERC721 token receiver interface
527  * @dev Interface for any contract that wants to support safeTransfers
528  * from ERC721 asset contracts.
529  */
530 interface IERC721Receiver {
531     /**
532      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
533      * by `operator` from `from`, this function is called.
534      *
535      * It must return its Solidity selector to confirm the token transfer.
536      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
537      *
538      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
539      */
540     function onERC721Received(
541         address operator,
542         address from,
543         uint256 tokenId,
544         bytes calldata data
545     ) external returns (bytes4);
546 }
547 
548 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
549 
550 
551 
552 pragma solidity ^0.8.0;
553 
554 /**
555  * @dev Interface of the ERC165 standard, as defined in the
556  * https://eips.ethereum.org/EIPS/eip-165[EIP].
557  *
558  * Implementers can declare support of contract interfaces, which can then be
559  * queried by others ({ERC165Checker}).
560  *
561  * For an implementation, see {ERC165}.
562  */
563 interface IERC165 {
564     /**
565      * @dev Returns true if this contract implements the interface defined by
566      * `interfaceId`. See the corresponding
567      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
568      * to learn more about how these ids are created.
569      *
570      * This function call must use less than 30 000 gas.
571      */
572     function supportsInterface(bytes4 interfaceId) external view returns (bool);
573 }
574 
575 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
576 
577 
578 
579 pragma solidity ^0.8.0;
580 
581 
582 /**
583  * @dev Implementation of the {IERC165} interface.
584  *
585  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
586  * for the additional interface id that will be supported. For example:
587  *
588  * ```solidity
589  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
590  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
591  * }
592  * ```
593  *
594  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
595  */
596 abstract contract ERC165 is IERC165 {
597     /**
598      * @dev See {IERC165-supportsInterface}.
599      */
600     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
601         return interfaceId == type(IERC165).interfaceId;
602     }
603 }
604 
605 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
606 
607 
608 
609 pragma solidity ^0.8.0;
610 
611 
612 /**
613  * @dev Required interface of an ERC721 compliant contract.
614  */
615 interface IERC721 is IERC165 {
616     /**
617      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
618      */
619     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
620 
621     /**
622      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
623      */
624     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
625 
626     /**
627      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
628      */
629     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
630 
631     /**
632      * @dev Returns the number of tokens in ``owner``'s account.
633      */
634     function balanceOf(address owner) external view returns (uint256 balance);
635 
636     /**
637      * @dev Returns the owner of the `tokenId` token.
638      *
639      * Requirements:
640      *
641      * - `tokenId` must exist.
642      */
643     function ownerOf(uint256 tokenId) external view returns (address owner);
644 
645     /**
646      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
647      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
648      *
649      * Requirements:
650      *
651      * - `from` cannot be the zero address.
652      * - `to` cannot be the zero address.
653      * - `tokenId` token must exist and be owned by `from`.
654      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
655      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
656      *
657      * Emits a {Transfer} event.
658      */
659     function safeTransferFrom(
660         address from,
661         address to,
662         uint256 tokenId
663     ) external;
664 
665     /**
666      * @dev Transfers `tokenId` token from `from` to `to`.
667      *
668      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
669      *
670      * Requirements:
671      *
672      * - `from` cannot be the zero address.
673      * - `to` cannot be the zero address.
674      * - `tokenId` token must be owned by `from`.
675      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
676      *
677      * Emits a {Transfer} event.
678      */
679     function transferFrom(
680         address from,
681         address to,
682         uint256 tokenId
683     ) external;
684 
685     /**
686      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
687      * The approval is cleared when the token is transferred.
688      *
689      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
690      *
691      * Requirements:
692      *
693      * - The caller must own the token or be an approved operator.
694      * - `tokenId` must exist.
695      *
696      * Emits an {Approval} event.
697      */
698     function approve(address to, uint256 tokenId) external;
699 
700     /**
701      * @dev Returns the account approved for `tokenId` token.
702      *
703      * Requirements:
704      *
705      * - `tokenId` must exist.
706      */
707     function getApproved(uint256 tokenId) external view returns (address operator);
708 
709     /**
710      * @dev Approve or remove `operator` as an operator for the caller.
711      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
712      *
713      * Requirements:
714      *
715      * - The `operator` cannot be the caller.
716      *
717      * Emits an {ApprovalForAll} event.
718      */
719     function setApprovalForAll(address operator, bool _approved) external;
720 
721     /**
722      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
723      *
724      * See {setApprovalForAll}
725      */
726     function isApprovedForAll(address owner, address operator) external view returns (bool);
727 
728     /**
729      * @dev Safely transfers `tokenId` token from `from` to `to`.
730      *
731      * Requirements:
732      *
733      * - `from` cannot be the zero address.
734      * - `to` cannot be the zero address.
735      * - `tokenId` token must exist and be owned by `from`.
736      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
737      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
738      *
739      * Emits a {Transfer} event.
740      */
741     function safeTransferFrom(
742         address from,
743         address to,
744         uint256 tokenId,
745         bytes calldata data
746     ) external;
747 }
748 
749 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
750 
751 
752 
753 pragma solidity ^0.8.0;
754 
755 
756 /**
757  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
758  * @dev See https://eips.ethereum.org/EIPS/eip-721
759  */
760 interface IERC721Enumerable is IERC721 {
761     /**
762      * @dev Returns the total amount of tokens stored by the contract.
763      */
764     function totalSupply() external view returns (uint256);
765 
766     /**
767      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
768      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
769      */
770     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
771 
772     /**
773      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
774      * Use along with {totalSupply} to enumerate all tokens.
775      */
776     function tokenByIndex(uint256 index) external view returns (uint256);
777 }
778 
779 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
780 
781 
782 
783 pragma solidity ^0.8.0;
784 
785 
786 /**
787  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
788  * @dev See https://eips.ethereum.org/EIPS/eip-721
789  */
790 interface IERC721Metadata is IERC721 {
791     /**
792      * @dev Returns the token collection name.
793      */
794     function name() external view returns (string memory);
795 
796     /**
797      * @dev Returns the token collection symbol.
798      */
799     function symbol() external view returns (string memory);
800 
801     /**
802      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
803      */
804     function tokenURI(uint256 tokenId) external view returns (string memory);
805 }
806 
807 // File: @openzeppelin/contracts/utils/Context.sol
808 
809 
810 
811 pragma solidity ^0.8.0;
812 
813 /**
814  * @dev Provides information about the current execution context, including the
815  * sender of the transaction and its data. While these are generally available
816  * via msg.sender and msg.data, they should not be accessed in such a direct
817  * manner, since when dealing with meta-transactions the account sending and
818  * paying for execution may not be the actual sender (as far as an application
819  * is concerned).
820  *
821  * This contract is only required for intermediate, library-like contracts.
822  */
823 abstract contract Context {
824     function _msgSender() internal view virtual returns (address) {
825         return msg.sender;
826     }
827 
828     function _msgData() internal view virtual returns (bytes calldata) {
829         return msg.data;
830     }
831 }
832 
833 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
834 
835 
836 
837 pragma solidity ^0.8.0;
838 
839 
840 
841 
842 
843 
844 
845 
846 /**
847  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
848  * the Metadata extension, but not including the Enumerable extension, which is available separately as
849  * {ERC721Enumerable}.
850  */
851 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
852     using Address for address;
853     using Strings for uint256;
854 
855     // Token name
856     string private _name;
857 
858     // Token symbol
859     string private _symbol;
860 
861     // Mapping from token ID to owner address
862     mapping(uint256 => address) private _owners;
863 
864     // Mapping owner address to token count
865     mapping(address => uint256) private _balances;
866 
867     // Mapping from token ID to approved address
868     mapping(uint256 => address) private _tokenApprovals;
869 
870     // Mapping from owner to operator approvals
871     mapping(address => mapping(address => bool)) private _operatorApprovals;
872 
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
928         string memory baseURI = _baseURI();
929         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
930     }
931 
932     /**
933      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
934      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
935      * by default, can be overriden in child contracts.
936      */
937     function _baseURI() internal view virtual returns (string memory) {
938         return "";
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
1210                 return retval == IERC721Receiver.onERC721Received.selector;
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
1246 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1247 
1248 
1249 
1250 pragma solidity ^0.8.0;
1251 
1252 
1253 
1254 /**
1255  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1256  * enumerability of all the token ids in the contract as well as all token ids owned by each
1257  * account.
1258  */
1259 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1260     // Mapping from owner to list of owned token IDs
1261     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1262 
1263     // Mapping from token ID to index of the owner tokens list
1264     mapping(uint256 => uint256) private _ownedTokensIndex;
1265 
1266     // Array with all token ids, used for enumeration
1267     uint256[] private _allTokens;
1268 
1269     // Mapping from token id to position in the allTokens array
1270     mapping(uint256 => uint256) private _allTokensIndex;
1271 
1272     /**
1273      * @dev See {IERC165-supportsInterface}.
1274      */
1275     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1276         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1277     }
1278 
1279     /**
1280      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1281      */
1282     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1283         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1284         return _ownedTokens[owner][index];
1285     }
1286 
1287     /**
1288      * @dev See {IERC721Enumerable-totalSupply}.
1289      */
1290     function totalSupply() public view virtual override returns (uint256) {
1291         return _allTokens.length;
1292     }
1293 
1294     /**
1295      * @dev See {IERC721Enumerable-tokenByIndex}.
1296      */
1297     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1298         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1299         return _allTokens[index];
1300     }
1301 
1302     /**
1303      * @dev Hook that is called before any token transfer. This includes minting
1304      * and burning.
1305      *
1306      * Calling conditions:
1307      *
1308      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1309      * transferred to `to`.
1310      * - When `from` is zero, `tokenId` will be minted for `to`.
1311      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1312      * - `from` cannot be the zero address.
1313      * - `to` cannot be the zero address.
1314      *
1315      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1316      */
1317     function _beforeTokenTransfer(
1318         address from,
1319         address to,
1320         uint256 tokenId
1321     ) internal virtual override {
1322         super._beforeTokenTransfer(from, to, tokenId);
1323 
1324         if (from == address(0)) {
1325             _addTokenToAllTokensEnumeration(tokenId);
1326         } else if (from != to) {
1327             _removeTokenFromOwnerEnumeration(from, tokenId);
1328         }
1329         if (to == address(0)) {
1330             _removeTokenFromAllTokensEnumeration(tokenId);
1331         } else if (to != from) {
1332             _addTokenToOwnerEnumeration(to, tokenId);
1333         }
1334     }
1335 
1336     /**
1337      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1338      * @param to address representing the new owner of the given token ID
1339      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1340      */
1341     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1342         uint256 length = ERC721.balanceOf(to);
1343         _ownedTokens[to][length] = tokenId;
1344         _ownedTokensIndex[tokenId] = length;
1345     }
1346 
1347     /**
1348      * @dev Private function to add a token to this extension's token tracking data structures.
1349      * @param tokenId uint256 ID of the token to be added to the tokens list
1350      */
1351     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1352         _allTokensIndex[tokenId] = _allTokens.length;
1353         _allTokens.push(tokenId);
1354     }
1355 
1356     /**
1357      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1358      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1359      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1360      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1361      * @param from address representing the previous owner of the given token ID
1362      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1363      */
1364     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1365         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1366         // then delete the last slot (swap and pop).
1367 
1368         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1369         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1370 
1371         // When the token to delete is the last token, the swap operation is unnecessary
1372         if (tokenIndex != lastTokenIndex) {
1373             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1374 
1375             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1376             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1377         }
1378 
1379         // This also deletes the contents at the last position of the array
1380         delete _ownedTokensIndex[tokenId];
1381         delete _ownedTokens[from][lastTokenIndex];
1382     }
1383 
1384     /**
1385      * @dev Private function to remove a token from this extension's token tracking data structures.
1386      * This has O(1) time complexity, but alters the order of the _allTokens array.
1387      * @param tokenId uint256 ID of the token to be removed from the tokens list
1388      */
1389     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1390         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1391         // then delete the last slot (swap and pop).
1392 
1393         uint256 lastTokenIndex = _allTokens.length - 1;
1394         uint256 tokenIndex = _allTokensIndex[tokenId];
1395 
1396         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1397         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1398         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1399         uint256 lastTokenId = _allTokens[lastTokenIndex];
1400 
1401         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1402         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1403 
1404         // This also deletes the contents at the last position of the array
1405         delete _allTokensIndex[tokenId];
1406         _allTokens.pop();
1407     }
1408 }
1409 
1410 // File: @openzeppelin/contracts/access/Ownable.sol
1411 
1412 
1413 
1414 pragma solidity ^0.8.0;
1415 
1416 
1417 /**
1418  * @dev Contract module which provides a basic access control mechanism, where
1419  * there is an account (an owner) that can be granted exclusive access to
1420  * specific functions.
1421  *
1422  * By default, the owner account will be the one that deploys the contract. This
1423  * can later be changed with {transferOwnership}.
1424  *
1425  * This module is used through inheritance. It will make available the modifier
1426  * `onlyOwner`, which can be applied to your functions to restrict their use to
1427  * the owner.
1428  */
1429 abstract contract Ownable is Context {
1430     address private _owner;
1431 
1432     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1433 
1434     /**
1435      * @dev Initializes the contract setting the deployer as the initial owner.
1436      */
1437     constructor() {
1438         _setOwner(_msgSender());
1439     }
1440 
1441     /**
1442      * @dev Returns the address of the current owner.
1443      */
1444     function owner() public view virtual returns (address) {
1445         return _owner;
1446     }
1447 
1448     /**
1449      * @dev Throws if called by any account other than the owner.
1450      */
1451     modifier onlyOwner() {
1452         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1453         _;
1454     }
1455 
1456     /**
1457      * @dev Leaves the contract without owner. It will not be possible to call
1458      * `onlyOwner` functions anymore. Can only be called by the current owner.
1459      *
1460      * NOTE: Renouncing ownership will leave the contract without an owner,
1461      * thereby removing any functionality that is only available to the owner.
1462      */
1463     function renounceOwnership() public virtual onlyOwner {
1464         _setOwner(address(0));
1465     }
1466 
1467     /**
1468      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1469      * Can only be called by the current owner.
1470      */
1471     function transferOwnership(address newOwner) public virtual onlyOwner {
1472         require(newOwner != address(0), "Ownable: new owner is the zero address");
1473         _setOwner(newOwner);
1474     }
1475 
1476     function _setOwner(address newOwner) private {
1477         address oldOwner = _owner;
1478         _owner = newOwner;
1479         emit OwnershipTransferred(oldOwner, newOwner);
1480     }
1481 }
1482 
1483 // File: BadFaceBots.sol
1484 
1485 
1486 
1487 pragma solidity ^0.8.0;
1488 
1489 
1490 
1491 
1492 contract InterfaceTokens {
1493     function transferTokens(address _from, address _to) external{}
1494     function burn(address from, uint256 amount) external{}
1495 } 
1496 
1497 contract BadFaceBots is ERC721Enumerable, Ownable {
1498     using SafeMath for uint256;
1499     
1500     bool private _saleActive = false;
1501     bool private _presaleActive = true;
1502     bool public _customNameActive = false;
1503 
1504     uint256 constant PUBLIC_PRICE = 0.08 ether;
1505     uint256 constant PRESALES_PRICE = 0.06 ether;
1506     uint256 constant public MAX_CLAIM = 10;
1507     uint256 constant public MAX_MINT_WHITELIST = 3;
1508     uint256 constant MAX_NFT_SUPPLY = 5555;
1509     uint256 constant public UPDATE_NAME_PRICE = 100 ether;
1510     
1511     string private _contractURI = "";
1512     string private _baseTokenURI;
1513     
1514 	mapping(address => uint256) public botsBalance;
1515     
1516     mapping(address => MintData) public whitelist;
1517     address[] whitelistAddr;
1518 
1519     mapping(address => MintData) public freeMintList;
1520     address[] freeMintListAddr;
1521 
1522     mapping(uint256 => string) public botInfo;
1523 
1524     InterfaceTokens public coinToken;
1525     
1526     struct MintData {
1527         address addr;
1528         uint claimAmount;
1529         uint hasMinted;
1530     }
1531 
1532     event StateUpdated();
1533     event UpdateName(uint256 tokenId, string name);
1534     event TokenMinted(uint256 supply);
1535   
1536     constructor () ERC721 ("Bad Face Bots", "BFBS") {
1537         //init
1538         coinToken = new InterfaceTokens();
1539     }
1540     
1541     function startSale() public onlyOwner {
1542         _saleActive = true;
1543         emit StateUpdated();
1544     }
1545 
1546     function pauseSale() public onlyOwner {
1547         _saleActive = false;
1548         emit StateUpdated();
1549     }
1550 
1551     function startPrivateSale() public onlyOwner {
1552         _presaleActive = true;
1553         emit StateUpdated();
1554     }
1555 
1556     function pausePrivateSale() public onlyOwner {
1557         _presaleActive = false;
1558         emit StateUpdated();
1559     }
1560     
1561     function filpCustomNameActive() public onlyOwner{
1562         _customNameActive = !_customNameActive;
1563     }
1564       
1565     function isSaleActive() public view returns (bool) {
1566         return _saleActive;
1567     }  
1568     
1569     function isPrivateSaleActive() public view returns (bool) {
1570         return _presaleActive;
1571     }
1572 
1573     function setCoinToken(address _token) external onlyOwner {
1574 		coinToken = InterfaceTokens(_token);
1575 	}
1576     
1577     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1578         uint256 tokenCount = balanceOf(_owner);
1579 
1580         uint256[] memory tokensId = new uint256[](tokenCount);
1581         for(uint256 i; i < tokenCount; i++){
1582             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1583         }
1584         return tokensId;
1585     }
1586     
1587     modifier botOwner(uint256 tokenId) {
1588         require(ownerOf(tokenId) == msg.sender, "Sender is not the token owner");
1589         _;
1590     }
1591     
1592     function addListAddressToWhitelist(address[] memory addrs) public onlyOwner {
1593         for(uint i = 0; i < addrs.length; i++) {
1594             addAddressToWhitelist(addrs[i]);
1595         }
1596     }
1597     
1598     function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
1599         require(!isWhitelisted(addr), "Already whitelisted");
1600         whitelist[addr].addr = addr;
1601         whitelist[addr].claimAmount = MAX_MINT_WHITELIST;
1602         whitelist[addr].hasMinted = 0;
1603         success = true;
1604     }
1605 
1606     function addListAddressToFreeMint(address[] memory addrs, uint[] memory claimAmounts) public onlyOwner {
1607         for(uint i = 0; i < addrs.length; i++) {
1608             addAddressToFreeMint(addrs[i], claimAmounts[i]);
1609         }
1610     }
1611 
1612     function addAddressToFreeMint(address addr, uint claimAmount) onlyOwner public returns(bool success) {
1613         require(freeMintList[addr].addr != addr, "Already in");
1614         freeMintList[addr].addr = addr;
1615         freeMintList[addr].claimAmount = claimAmount;
1616         freeMintList[addr].hasMinted = 0;
1617         success = true;
1618     }
1619 
1620     function mintPrice() public view returns (uint256 num){
1621         if(_presaleActive){
1622             return PRESALES_PRICE;
1623         }
1624         return PUBLIC_PRICE;
1625     }
1626     
1627     function isWhitelisted(address addr) public view returns (bool isWhiteListed) {
1628         return whitelist[addr].addr == addr;
1629     }
1630     
1631     function getPublicLeft() public view returns (uint256) {
1632         return MAX_NFT_SUPPLY - totalSupply();
1633     }
1634     
1635     function numWhitelistCanMint() public view returns (uint256 num){
1636         if(whitelist[msg.sender].addr != msg.sender){
1637             return 0;
1638         }
1639         return MAX_MINT_WHITELIST - whitelist[msg.sender].hasMinted;
1640     }
1641 
1642     function numFreeMint() public view returns (uint256 num){
1643         if(freeMintList[msg.sender].addr != msg.sender){
1644             return 0;
1645         }
1646         return freeMintList[msg.sender].claimAmount - freeMintList[msg.sender].hasMinted;
1647     }
1648 
1649     function freemint(uint256 num) public payable{
1650         require( _saleActive, "Sale not ready" );
1651         require( totalSupply() + num <= MAX_NFT_SUPPLY, "Exceeds maximum supply" );
1652         require( freeMintList[msg.sender].addr == msg.sender, "Not in Free Mint" );
1653         require( freeMintList[msg.sender].hasMinted.add(num) <= freeMintList[msg.sender].claimAmount, "You already minted" );
1654         
1655         freeMintList[msg.sender].hasMinted = freeMintList[msg.sender].hasMinted.add(num);
1656         for(uint256 i; i < num; i++){
1657             _safeMint( msg.sender, totalSupply() + 1 );
1658             botsBalance[msg.sender]++;
1659         }
1660         emit TokenMinted(totalSupply());
1661     }
1662 
1663     function mint(uint256 num) public payable {
1664         require( _saleActive, "Sale not ready" );
1665         require( num <= MAX_CLAIM, "You can mint a maximum of 10" );
1666         require( totalSupply() + num <= MAX_NFT_SUPPLY, "Exceeds maximum supply" );
1667         if(_presaleActive){
1668             require( PRESALES_PRICE.mul(num) <= msg.value, "Ether sent is not correct" );
1669             require( isWhitelisted(msg.sender), "Is not whitelisted" );
1670             require( whitelist[msg.sender].hasMinted.add(num) <= MAX_MINT_WHITELIST, "Can only mint 3 while whitelisted" );
1671             require( whitelist[msg.sender].hasMinted <= MAX_MINT_WHITELIST, "Can only mint 3 while whitelisted" );
1672             whitelist[msg.sender].hasMinted = whitelist[msg.sender].hasMinted.add(num);
1673         }else{
1674             require( PUBLIC_PRICE.mul(num) <= msg.value, "Ether sent is not correct" );
1675         }
1676         for(uint256 i; i < num; i++){
1677             _safeMint( msg.sender, totalSupply() + 1 );
1678             botsBalance[msg.sender]++;
1679         }
1680         emit TokenMinted(totalSupply());
1681     }
1682 
1683     function updateName(uint256 tokenId, string memory name) public botOwner(tokenId) {
1684         require(_customNameActive,"Not Yet");
1685         require(validateName(name) == true, "Invalid name length");
1686         require(sha256(bytes(name)) != sha256(bytes(botInfo[tokenId])), "New name is same as current name");
1687 
1688         coinToken.burn(msg.sender, UPDATE_NAME_PRICE);
1689         botInfo[tokenId] = name;
1690         emit UpdateName(tokenId, name);
1691     }
1692 
1693     function validateName(string memory str) public pure returns (bool){
1694         bytes memory b = bytes(str);
1695         if(b.length < 1) return false;
1696         if(b.length > 25) return false;
1697         if(b[0] == 0x20) return false;
1698         if (b[b.length - 1] == 0x20) return false;
1699 
1700         bytes1 lastChar = b[0];
1701 
1702         for(uint i; i<b.length; i++){
1703             bytes1 char = b[i];
1704 
1705             if (char == 0x20 && lastChar == 0x20) return false; 
1706 
1707             if(
1708                 !(char >= 0x30 && char <= 0x39) && //9-0
1709                 !(char >= 0x41 && char <= 0x5A) && //A-Z
1710                 !(char >= 0x61 && char <= 0x7A) && //a-z
1711                 !(char == 0x20) //space
1712             )
1713                 return false;
1714             lastChar = char;
1715         }
1716         return true;
1717     }
1718 
1719     //reserve for team and some for community
1720     function reserve(address addr, uint256 amount) public onlyOwner {
1721         for (uint i = 0; i < amount; i++) {
1722             _safeMint(addr, totalSupply() + 1);
1723             botsBalance[addr]++;
1724         }
1725         emit TokenMinted(totalSupply());
1726     }
1727 
1728 	function transferFrom(address from, address to, uint256 tokenId) public override {
1729 		coinToken.transferTokens(from, to);
1730         botsBalance[from]--;
1731         botsBalance[to]++;
1732 		ERC721.transferFrom(from, to, tokenId);
1733 	}
1734 
1735 	function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public override {
1736 		coinToken.transferTokens(from, to);
1737         botsBalance[from]--;
1738         botsBalance[to]++;
1739 		ERC721.safeTransferFrom(from, to, tokenId, _data);
1740 	}
1741     
1742     function _baseURI() internal view virtual override returns (string memory) {
1743         return _baseTokenURI;
1744     }
1745 
1746     function setBaseURI(string memory baseURI) public onlyOwner {
1747         _baseTokenURI = baseURI;
1748     }
1749 
1750     function setContractURI(string memory newContractURI) external onlyOwner {
1751         _contractURI = newContractURI;
1752     }
1753     
1754     function contractURI() external view returns (string memory){
1755         return _contractURI;
1756     }
1757   
1758     function withdraw() public onlyOwner {
1759         require(payable(msg.sender).send(address(this).balance));
1760     }
1761 }