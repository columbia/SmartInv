1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-13
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
232 /**
233  * @dev String operations.
234  */
235 library Strings {
236     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
237 
238     /**
239      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
240      */
241     function toString(uint256 value) internal pure returns (string memory) {
242         // Inspired by OraclizeAPI's implementation - MIT licence
243         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
244 
245         if (value == 0) {
246             return "0";
247         }
248         uint256 temp = value;
249         uint256 digits;
250         while (temp != 0) {
251             digits++;
252             temp /= 10;
253         }
254         bytes memory buffer = new bytes(digits);
255         while (value != 0) {
256             digits -= 1;
257             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
258             value /= 10;
259         }
260         return string(buffer);
261     }
262 
263     /**
264      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
265      */
266     function toHexString(uint256 value) internal pure returns (string memory) {
267         if (value == 0) {
268             return "0x00";
269         }
270         uint256 temp = value;
271         uint256 length = 0;
272         while (temp != 0) {
273             length++;
274             temp >>= 8;
275         }
276         return toHexString(value, length);
277     }
278 
279     /**
280      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
281      */
282     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
283         bytes memory buffer = new bytes(2 * length + 2);
284         buffer[0] = "0";
285         buffer[1] = "x";
286         for (uint256 i = 2 * length + 1; i > 1; --i) {
287             buffer[i] = _HEX_SYMBOLS[value & 0xf];
288             value >>= 4;
289         }
290         require(value == 0, "Strings: hex length insufficient");
291         return string(buffer);
292     }
293 }
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
502 
503 /*
504  * @title MerkleProof
505  * @dev Merkle proof verification
506  * @note Based on https://github.com/ameensol/merkle-tree-solidity/blob/master/src/MerkleProof.sol
507  */
508 library MerkleProof {
509   
510   function verify(
511         bytes32[] memory proof,
512         bytes32 root,
513         bytes32 leaf,
514         uint index
515     ) public pure returns (bool) {
516         bytes32 hash = leaf;
517 
518         for (uint i = 0; i < proof.length; i++) {
519             bytes32 proofElement = proof[i];
520 
521             if (index % 2 == 0) {
522                 hash = keccak256(abi.encodePacked(hash, proofElement));
523             } else {
524                 hash = keccak256(abi.encodePacked(proofElement, hash));
525             }
526 
527             index = index / 2;
528         }
529 
530         return hash == root;
531     }
532 }
533 
534 /**
535  * @title ERC721 token receiver interface
536  * @dev Interface for any contract that wants to support safeTransfers
537  * from ERC721 asset contracts.
538  */
539 interface IERC721Receiver {
540     /**
541      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
542      * by `operator` from `from`, this function is called.
543      *
544      * It must return its Solidity selector to confirm the token transfer.
545      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
546      *
547      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
548      */
549     function onERC721Received(
550         address operator,
551         address from,
552         uint256 tokenId,
553         bytes calldata data
554     ) external returns (bytes4);
555 }
556 
557 /**
558  * @dev Interface of the ERC165 standard, as defined in the
559  * https://eips.ethereum.org/EIPS/eip-165[EIP].
560  *
561  * Implementers can declare support of contract interfaces, which can then be
562  * queried by others ({ERC165Checker}).
563  *
564  * For an implementation, see {ERC165}.
565  */
566 interface IERC165 {
567     /**
568      * @dev Returns true if this contract implements the interface defined by
569      * `interfaceId`. See the corresponding
570      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
571      * to learn more about how these ids are created.
572      *
573      * This function call must use less than 30 000 gas.
574      */
575     function supportsInterface(bytes4 interfaceId) external view returns (bool);
576 }
577 
578 /**
579  * @dev Implementation of the {IERC165} interface.
580  *
581  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
582  * for the additional interface id that will be supported. For example:
583  *
584  * ```solidity
585  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
586  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
587  * }
588  * ```
589  *
590  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
591  */
592 abstract contract ERC165 is IERC165 {
593     /**
594      * @dev See {IERC165-supportsInterface}.
595      */
596     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
597         return interfaceId == type(IERC165).interfaceId;
598     }
599 }
600 
601 /**
602  * @dev Required interface of an ERC721 compliant contract.
603  */
604 interface IERC721 is IERC165 {
605     /**
606      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
607      */
608     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
609 
610     /**
611      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
612      */
613     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
614 
615     /**
616      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
617      */
618     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
619 
620     /**
621      * @dev Returns the number of tokens in ``owner``'s account.
622      */
623     function balanceOf(address owner) external view returns (uint256 balance);
624 
625     /**
626      * @dev Returns the owner of the `tokenId` token.
627      *
628      * Requirements:
629      *
630      * - `tokenId` must exist.
631      */
632     function ownerOf(uint256 tokenId) external view returns (address owner);
633 
634     /**
635      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
636      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
637      *
638      * Requirements:
639      *
640      * - `from` cannot be the zero address.
641      * - `to` cannot be the zero address.
642      * - `tokenId` token must exist and be owned by `from`.
643      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
644      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
645      *
646      * Emits a {Transfer} event.
647      */
648     function safeTransferFrom(
649         address from,
650         address to,
651         uint256 tokenId
652     ) external;
653 
654     /**
655      * @dev Transfers `tokenId` token from `from` to `to`.
656      *
657      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
658      *
659      * Requirements:
660      *
661      * - `from` cannot be the zero address.
662      * - `to` cannot be the zero address.
663      * - `tokenId` token must be owned by `from`.
664      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
665      *
666      * Emits a {Transfer} event.
667      */
668     function transferFrom(
669         address from,
670         address to,
671         uint256 tokenId
672     ) external;
673 
674     /**
675      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
676      * The approval is cleared when the token is transferred.
677      *
678      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
679      *
680      * Requirements:
681      *
682      * - The caller must own the token or be an approved operator.
683      * - `tokenId` must exist.
684      *
685      * Emits an {Approval} event.
686      */
687     function approve(address to, uint256 tokenId) external;
688 
689     /**
690      * @dev Returns the account approved for `tokenId` token.
691      *
692      * Requirements:
693      *
694      * - `tokenId` must exist.
695      */
696     function getApproved(uint256 tokenId) external view returns (address operator);
697 
698     /**
699      * @dev Approve or remove `operator` as an operator for the caller.
700      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
701      *
702      * Requirements:
703      *
704      * - The `operator` cannot be the caller.
705      *
706      * Emits an {ApprovalForAll} event.
707      */
708     function setApprovalForAll(address operator, bool _approved) external;
709 
710     /**
711      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
712      *
713      * See {setApprovalForAll}
714      */
715     function isApprovedForAll(address owner, address operator) external view returns (bool);
716 
717     /**
718      * @dev Safely transfers `tokenId` token from `from` to `to`.
719      *
720      * Requirements:
721      *
722      * - `from` cannot be the zero address.
723      * - `to` cannot be the zero address.
724      * - `tokenId` token must exist and be owned by `from`.
725      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
726      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
727      *
728      * Emits a {Transfer} event.
729      */
730     function safeTransferFrom(
731         address from,
732         address to,
733         uint256 tokenId,
734         bytes calldata data
735     ) external;
736 }
737 
738 /**
739  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
740  * @dev See https://eips.ethereum.org/EIPS/eip-721
741  */
742 interface IERC721Enumerable is IERC721 {
743     /**
744      * @dev Returns the total amount of tokens stored by the contract.
745      */
746     function totalSupply() external view returns (uint256);
747 
748     /**
749      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
750      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
751      */
752     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
753 
754     /**
755      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
756      * Use along with {totalSupply} to enumerate all tokens.
757      */
758     function tokenByIndex(uint256 index) external view returns (uint256);
759 }
760 
761 /**
762  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
763  * @dev See https://eips.ethereum.org/EIPS/eip-721
764  */
765 interface IERC721Metadata is IERC721 {
766     /**
767      * @dev Returns the token collection name.
768      */
769     function name() external view returns (string memory);
770 
771     /**
772      * @dev Returns the token collection symbol.
773      */
774     function symbol() external view returns (string memory);
775 
776     /**
777      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
778      */
779     function tokenURI(uint256 tokenId) external view returns (string memory);
780 }
781 
782 /*
783  * @dev Provides information about the current execution context, including the
784  * sender of the transaction and its data. While these are generally available
785  * via msg.sender and msg.data, they should not be accessed in such a direct
786  * manner, since when dealing with meta-transactions the account sending and
787  * paying for execution may not be the actual sender (as far as an application
788  * is concerned).
789  *
790  * This contract is only required for intermediate, library-like contracts.
791  */
792 abstract contract Context {
793     function _msgSender() internal view virtual returns (address) {
794         return msg.sender;
795     }
796 
797     function _msgData() internal view virtual returns (bytes calldata) {
798         return msg.data;
799     }
800 }
801 
802 /**
803  * @dev Contract module which provides a basic access control mechanism, where
804  * there is an account (an owner) that can be granted exclusive access to
805  * specific functions.
806  *
807  * By default, the owner account will be the one that deploys the contract. This
808  * can later be changed with {transferOwnership}.
809  *
810  * This module is used through inheritance. It will make available the modifier
811  * `onlyOwner`, which can be applied to your functions to restrict their use to
812  * the owner.
813  */
814 abstract contract Ownable is Context {
815     address private _owner;
816 
817     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
818 
819     /**
820      * @dev Initializes the contract setting the deployer as the initial owner.
821      */
822     constructor () {
823         address msgSender = _msgSender();
824         _owner = msgSender;
825         emit OwnershipTransferred(address(0), msgSender);
826     }
827 
828     /**
829      * @dev Returns the address of the current owner.
830      */
831     function owner() public view virtual returns (address) {
832         return _owner;
833     }
834 
835     /**
836      * @dev Throws if called by any account other than the owner.
837      */
838     modifier onlyOwner() {
839         require(owner() == _msgSender(), "Ownable: caller is not the owner");
840         _;
841     }
842 
843     /**
844      * @dev Leaves the contract without owner. It will not be possible to call
845      * `onlyOwner` functions anymore. Can only be called by the current owner.
846      *
847      * NOTE: Renouncing ownership will leave the contract without an owner,
848      * thereby removing any functionality that is only available to the owner.
849      */
850     function renounceOwnership() public virtual onlyOwner {
851         emit OwnershipTransferred(_owner, address(0));
852         _setOwner(address(0));
853     }
854 
855     /**
856      * @dev Transfers ownership of the contract to a new account (`newOwner`).
857      * Can only be called by the current owner.
858      */
859     function transferOwnership(address newOwner) public virtual onlyOwner {
860         require(newOwner != address(0), "Ownable: new owner is the zero address");
861         _setOwner(newOwner);
862     }
863 
864     function _setOwner(address newOwner) private {
865         address oldOwner = _owner;
866         _owner = newOwner;
867         emit OwnershipTransferred(oldOwner, newOwner);
868     }
869 }
870 
871 /**
872  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
873  * the Metadata extension, but not including the Enumerable extension, which is available separately as
874  * {ERC721Enumerable}.
875  */
876 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
877     using Address for address;
878     using Strings for uint256;
879 
880     // Token name
881     string private _name;
882 
883     // Token symbol
884     string private _symbol;
885 
886     // Mapping from token ID to owner address
887     mapping(uint256 => address) private _owners;
888 
889     // Mapping owner address to token count
890     mapping(address => uint256) private _balances;
891 
892     // Mapping from token ID to approved address
893     mapping(uint256 => address) private _tokenApprovals;
894 
895     // Mapping from owner to operator approvals
896     mapping(address => mapping(address => bool)) private _operatorApprovals;
897 
898 
899     string public _baseURI;
900     /**
901      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
902      */
903     constructor(string memory name_, string memory symbol_) {
904         _name = name_;
905         _symbol = symbol_;
906     }
907 
908     /**
909      * @dev See {IERC165-supportsInterface}.
910      */
911     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
912         return
913             interfaceId == type(IERC721).interfaceId ||
914             interfaceId == type(IERC721Metadata).interfaceId ||
915             super.supportsInterface(interfaceId);
916     }
917 
918     /**
919      * @dev See {IERC721-balanceOf}.
920      */
921     function balanceOf(address owner) public view virtual override returns (uint256) {
922         require(owner != address(0), "ERC721: balance query for the zero address");
923         return _balances[owner];
924     }
925 
926     /**
927      * @dev See {IERC721-ownerOf}.
928      */
929     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
930         address owner = _owners[tokenId];
931         require(owner != address(0), "ERC721: owner query for nonexistent token");
932         return owner;
933     }
934 
935     /**
936      * @dev See {IERC721Metadata-name}.
937      */
938     function name() public view virtual override returns (string memory) {
939         return _name;
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-symbol}.
944      */
945     function symbol() public view virtual override returns (string memory) {
946         return _symbol;
947     }
948 
949     /**
950      * @dev See {IERC721Metadata-tokenURI}.
951      */
952     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
953         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
954 
955         string memory base = baseURI();
956         string memory baseExtension = ".json";
957         return bytes(base).length > 0 ? string(abi.encodePacked(base, tokenId.toString(), baseExtension)) : "";
958     }
959 
960     /**
961      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
962      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
963      * by default, can be overriden in child contracts.
964      */
965     function baseURI() internal view virtual returns (string memory) {
966         return _baseURI;
967     }
968 
969     /**
970      * @dev See {IERC721-approve}.
971      */
972     function approve(address to, uint256 tokenId) public virtual override {
973         address owner = ERC721.ownerOf(tokenId);
974         require(to != owner, "ERC721: approval to current owner");
975 
976         require(
977             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
978             "ERC721: approve caller is not owner nor approved for all"
979         );
980 
981         _approve(to, tokenId);
982     }
983 
984     /**
985      * @dev See {IERC721-getApproved}.
986      */
987     function getApproved(uint256 tokenId) public view virtual override returns (address) {
988         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
989 
990         return _tokenApprovals[tokenId];
991     }
992 
993     /**
994      * @dev See {IERC721-setApprovalForAll}.
995      */
996     function setApprovalForAll(address operator, bool approved) public virtual override {
997         require(operator != _msgSender(), "ERC721: approve to caller");
998 
999         _operatorApprovals[_msgSender()][operator] = approved;
1000         emit ApprovalForAll(_msgSender(), operator, approved);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-isApprovedForAll}.
1005      */
1006     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1007         return _operatorApprovals[owner][operator];
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-transferFrom}.
1012      */
1013     function transferFrom(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) public virtual override {
1018         //solhint-disable-next-line max-line-length
1019         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1020 
1021         _transfer(from, to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-safeTransferFrom}.
1026      */
1027     function safeTransferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) public virtual override {
1032         safeTransferFrom(from, to, tokenId, "");
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-safeTransferFrom}.
1037      */
1038     function safeTransferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) public virtual override {
1044         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1045         _safeTransfer(from, to, tokenId, _data);
1046     }
1047 
1048     /**
1049      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1050      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1051      *
1052      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1053      *
1054      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1055      * implement alternative mechanisms to perform token transfer, such as signature-based.
1056      *
1057      * Requirements:
1058      *
1059      * - `from` cannot be the zero address.
1060      * - `to` cannot be the zero address.
1061      * - `tokenId` token must exist and be owned by `from`.
1062      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1063      *
1064      * Emits a {Transfer} event.
1065      */
1066     function _safeTransfer(
1067         address from,
1068         address to,
1069         uint256 tokenId,
1070         bytes memory _data
1071     ) internal virtual {
1072         _transfer(from, to, tokenId);
1073         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1074     }
1075 
1076     /**
1077      * @dev Returns whether `tokenId` exists.
1078      *
1079      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1080      *
1081      * Tokens start existing when they are minted (`_mint`),
1082      * and stop existing when they are burned (`_burn`).
1083      */
1084     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1085         return _owners[tokenId] != address(0);
1086     }
1087 
1088     /**
1089      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1090      *
1091      * Requirements:
1092      *
1093      * - `tokenId` must exist.
1094      */
1095     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1096         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1097         address owner = ERC721.ownerOf(tokenId);
1098         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1099     }
1100 
1101     /**
1102      * @dev Safely mints `tokenId` and transfers it to `to`.
1103      *
1104      * Requirements:
1105      *
1106      * - `tokenId` must not exist.
1107      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _safeMint(address to, uint256 tokenId) internal virtual {
1112         _safeMint(to, tokenId, "");
1113     }
1114 
1115     /**
1116      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1117      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1118      */
1119     function _safeMint(
1120         address to,
1121         uint256 tokenId,
1122         bytes memory _data
1123     ) internal virtual {
1124         _mint(to, tokenId);
1125         require(
1126             _checkOnERC721Received(address(0), to, tokenId, _data),
1127             "ERC721: transfer to non ERC721Receiver implementer"
1128         );
1129     }
1130 
1131     /**
1132      * @dev Mints `tokenId` and transfers it to `to`.
1133      *
1134      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1135      *
1136      * Requirements:
1137      *
1138      * - `tokenId` must not exist.
1139      * - `to` cannot be the zero address.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function _mint(address to, uint256 tokenId) internal virtual {
1144         require(to != address(0), "ERC721: mint to the zero address");
1145         require(!_exists(tokenId), "ERC721: token already minted");
1146 
1147         _beforeTokenTransfer(address(0), to, tokenId);
1148 
1149         _balances[to] += 1;
1150         _owners[tokenId] = to;
1151 
1152         emit Transfer(address(0), to, tokenId);
1153     }
1154 
1155     /**
1156      * @dev Destroys `tokenId`.
1157      * The approval is cleared when the token is burned.
1158      *
1159      * Requirements:
1160      *
1161      * - `tokenId` must exist.
1162      *
1163      * Emits a {Transfer} event.
1164      */
1165     function _burn(uint256 tokenId) internal virtual {
1166         address owner = ERC721.ownerOf(tokenId);
1167 
1168         _beforeTokenTransfer(owner, address(0), tokenId);
1169 
1170         // Clear approvals
1171         _approve(address(0), tokenId);
1172 
1173         _balances[owner] -= 1;
1174         delete _owners[tokenId];
1175 
1176         emit Transfer(owner, address(0), tokenId);
1177     }
1178 
1179     /**
1180      * @dev Transfers `tokenId` from `from` to `to`.
1181      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1182      *
1183      * Requirements:
1184      *
1185      * - `to` cannot be the zero address.
1186      * - `tokenId` token must be owned by `from`.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _transfer(
1191         address from,
1192         address to,
1193         uint256 tokenId
1194     ) internal virtual {
1195         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1196         require(to != address(0), "ERC721: transfer to the zero address");
1197 
1198         _beforeTokenTransfer(from, to, tokenId);
1199 
1200         // Clear approvals from the previous owner
1201         _approve(address(0), tokenId);
1202 
1203         _balances[from] -= 1;
1204         _balances[to] += 1;
1205         _owners[tokenId] = to;
1206 
1207         emit Transfer(from, to, tokenId);
1208     }
1209 
1210     /**
1211      * @dev Approve `to` to operate on `tokenId`
1212      *
1213      * Emits a {Approval} event.
1214      */
1215     function _approve(address to, uint256 tokenId) internal virtual {
1216         _tokenApprovals[tokenId] = to;
1217         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1218     }
1219 
1220     /**
1221      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1222      * The call is not executed if the target address is not a contract.
1223      *
1224      * @param from address representing the previous owner of the given token ID
1225      * @param to target address that will receive the tokens
1226      * @param tokenId uint256 ID of the token to be transferred
1227      * @param _data bytes optional data to send along with the call
1228      * @return bool whether the call correctly returned the expected magic value
1229      */
1230     function _checkOnERC721Received(
1231         address from,
1232         address to,
1233         uint256 tokenId,
1234         bytes memory _data
1235     ) private returns (bool) {
1236         if (to.isContract()) {
1237             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1238                 return retval == IERC721Receiver(to).onERC721Received.selector;
1239             } catch (bytes memory reason) {
1240                 if (reason.length == 0) {
1241                     revert("ERC721: transfer to non ERC721Receiver implementer");
1242                 } else {
1243                     assembly {
1244                         revert(add(32, reason), mload(reason))
1245                     }
1246                 }
1247             }
1248         } else {
1249             return true;
1250         }
1251     }
1252 
1253     /**
1254      * @dev Hook that is called before any token transfer. This includes minting
1255      * and burning.
1256      *
1257      * Calling conditions:
1258      *
1259      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1260      * transferred to `to`.
1261      * - When `from` is zero, `tokenId` will be minted for `to`.
1262      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1263      * - `from` and `to` are never both zero.
1264      *
1265      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1266      */
1267     function _beforeTokenTransfer(
1268         address from,
1269         address to,
1270         uint256 tokenId
1271     ) internal virtual {}
1272 }
1273 
1274 /**
1275  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1276  * enumerability of all the token ids in the contract as well as all token ids owned by each
1277  * account.
1278  */
1279 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1280     // Mapping from owner to list of owned token IDs
1281     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1282 
1283     // Mapping from token ID to index of the owner tokens list
1284     mapping(uint256 => uint256) private _ownedTokensIndex;
1285 
1286     // Array with all token ids, used for enumeration
1287     uint256[] private _allTokens;
1288 
1289     // Mapping from token id to position in the allTokens array
1290     mapping(uint256 => uint256) private _allTokensIndex;
1291 
1292     /**
1293      * @dev See {IERC165-supportsInterface}.
1294      */
1295     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1296         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1297     }
1298 
1299     /**
1300      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1301      */
1302     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1303         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1304         return _ownedTokens[owner][index];
1305     }
1306 
1307     /**
1308      * @dev See {IERC721Enumerable-totalSupply}.
1309      */
1310     function totalSupply() public view virtual override returns (uint256) {
1311         return _allTokens.length;
1312     }
1313 
1314     /**
1315      * @dev See {IERC721Enumerable-tokenByIndex}.
1316      */
1317     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1318         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1319         return _allTokens[index];
1320     }
1321 
1322     /**
1323      * @dev Hook that is called before any token transfer. This includes minting
1324      * and burning.
1325      *
1326      * Calling conditions:
1327      *
1328      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1329      * transferred to `to`.
1330      * - When `from` is zero, `tokenId` will be minted for `to`.
1331      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1332      * - `from` cannot be the zero address.
1333      * - `to` cannot be the zero address.
1334      *
1335      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1336      */
1337     function _beforeTokenTransfer(
1338         address from,
1339         address to,
1340         uint256 tokenId
1341     ) internal virtual override {
1342         super._beforeTokenTransfer(from, to, tokenId);
1343 
1344         if (from == address(0)) {
1345             _addTokenToAllTokensEnumeration(tokenId);
1346         } else if (from != to) {
1347             _removeTokenFromOwnerEnumeration(from, tokenId);
1348         }
1349         if (to == address(0)) {
1350             _removeTokenFromAllTokensEnumeration(tokenId);
1351         } else if (to != from) {
1352             _addTokenToOwnerEnumeration(to, tokenId);
1353         }
1354     }
1355 
1356     /**
1357      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1358      * @param to address representing the new owner of the given token ID
1359      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1360      */
1361     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1362         uint256 length = ERC721.balanceOf(to);
1363         _ownedTokens[to][length] = tokenId;
1364         _ownedTokensIndex[tokenId] = length;
1365     }
1366 
1367     /**
1368      * @dev Private function to add a token to this extension's token tracking data structures.
1369      * @param tokenId uint256 ID of the token to be added to the tokens list
1370      */
1371     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1372         _allTokensIndex[tokenId] = _allTokens.length;
1373         _allTokens.push(tokenId);
1374     }
1375 
1376     /**
1377      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1378      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1379      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1380      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1381      * @param from address representing the previous owner of the given token ID
1382      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1383      */
1384     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1385         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1386         // then delete the last slot (swap and pop).
1387 
1388         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1389         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1390 
1391         // When the token to delete is the last token, the swap operation is unnecessary
1392         if (tokenIndex != lastTokenIndex) {
1393             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1394 
1395             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1396             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1397         }
1398 
1399         // This also deletes the contents at the last position of the array
1400         delete _ownedTokensIndex[tokenId];
1401         delete _ownedTokens[from][lastTokenIndex];
1402     }
1403 
1404     /**
1405      * @dev Private function to remove a token from this extension's token tracking data structures.
1406      * This has O(1) time complexity, but alters the order of the _allTokens array.
1407      * @param tokenId uint256 ID of the token to be removed from the tokens list
1408      */
1409     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1410         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1411         // then delete the last slot (swap and pop).
1412 
1413         uint256 lastTokenIndex = _allTokens.length - 1;
1414         uint256 tokenIndex = _allTokensIndex[tokenId];
1415 
1416         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1417         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1418         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1419         uint256 lastTokenId = _allTokens[lastTokenIndex];
1420 
1421         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1422         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1423 
1424         // This also deletes the contents at the last position of the array
1425         delete _allTokensIndex[tokenId];
1426         _allTokens.pop();
1427     }
1428 }
1429 
1430 contract DoodleAS is ERC721Enumerable, Ownable
1431 {
1432     using SafeMath for uint256;
1433     using Address for address;
1434     using Strings for uint256;
1435 
1436     uint public constant _TOTALSUPPLY = 2500;
1437     uint256 public price = 50000000000000000; // 0.05 ETH
1438     bool public isPaused = true;
1439     bool public presale = true;
1440     bytes32 public merkleRoot = 0x3f755a721590785731b83e135c98ec66732bb48abffc88a341b88ab94e37cac4;
1441 
1442     mapping(address => bool) blacklistuser;
1443 
1444     constructor(string memory baseURI) ERC721("Doodle Apes Society", "DAS") {
1445         setBaseURI(baseURI);
1446     }
1447 
1448     function mint(address _to, uint256 quantity, bytes32[] memory _merkleProof, uint index) public payable isSaleOpen {
1449         require(isPaused == false, "Sale is not active at the moment");
1450         require(_to != address(0), "Mint to the zero address");
1451 
1452         uint256 maxquantity = 5;
1453         if (presale == true) {
1454             maxquantity = 3;
1455             require(blacklistuser[msg.sender] == false, "Already Minted User");
1456             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1457             require(MerkleProof.verify(_merkleProof, merkleRoot, leaf, index), "Invalid proof");
1458         }
1459 
1460         require(quantity <= maxquantity, "Exceed max quantity");
1461 
1462         uint256 tokenId = totalSupply();
1463 
1464         require(price * quantity <= msg.value, "Wrong amount sent");
1465         for (uint256 i = 0; i < quantity; i++) {
1466             _safeMint(_to, tokenId);
1467             if (presale == true) {
1468                 blacklistuser[msg.sender] = true;
1469             }
1470             tokenId++;
1471         }
1472     }
1473 
1474     function setBaseURI(string memory baseURI) public onlyOwner {
1475         _baseURI = baseURI;
1476     }
1477 
1478     function setWhitelistUser(bytes32 merkleRootHash) public onlyOwner {
1479         merkleRoot = merkleRootHash;
1480     }
1481 
1482     function getWhitelistUser() public view returns (bytes32) {
1483         return merkleRoot;
1484     }
1485 
1486     function flipPauseStatus() public onlyOwner {
1487         isPaused = !isPaused;
1488     }
1489 
1490     function flipPresaleStatus() public onlyOwner {
1491         presale = !presale;
1492     }
1493 
1494     function setPrice(uint256 _newPrice) public onlyOwner() {
1495         price = _newPrice;
1496     }
1497 
1498     function mintByOwner(address _to, uint256 quantity) public onlyOwner{
1499         require(_to != address(0), "Mint to the zero address");
1500 
1501         uint256 tokenId = totalSupply();
1502         for (uint256 i = 0; i < quantity; i++) {
1503             _safeMint(_to, tokenId);
1504             tokenId++;
1505         }
1506     }
1507 
1508     function setBlackList(address user) public onlyOwner {
1509         blacklistuser[user] = true;
1510     }
1511 
1512     function removeBlackList(address user) public onlyOwner {
1513         blacklistuser[user] = false;
1514     }
1515 
1516     function isBlackList(address user) public view returns (bool) {
1517         return blacklistuser[user];
1518     }
1519 
1520     modifier isSaleOpen{
1521         require(totalSupply() < _TOTALSUPPLY, "Mint wourd exceed totalSupply");
1522         _;
1523     }
1524 
1525     function tokensOfOwner(address _owner) public view returns (uint256[] memory)
1526     {
1527         uint256 count = balanceOf(_owner);
1528         uint256[] memory result = new uint256[](count);
1529         for (uint256 index = 0; index < count; index++) {
1530             result[index] = tokenOfOwnerByIndex(_owner, index);
1531         }
1532         return result;
1533     }
1534 
1535     function withdraw() public onlyOwner {
1536         uint balance = address(this).balance;
1537         payable(msg.sender).transfer(balance);
1538     }
1539 }