1 // SPDX-License-Identifier: Unlimited
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations.
6  *
7  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
8  * now has built in overflow checking.
9  */
10 library SafeMath {
11     /**
12      * @dev Returns the addition of two unsigned integers, with an overflow flag.
13      *
14      * _Available since v3.4._
15      */
16     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
17         unchecked {
18             uint256 c = a + b;
19             if (c < a) return (false, 0);
20             return (true, c);
21         }
22     }
23 
24     /**
25      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
26      *
27      * _Available since v3.4._
28      */
29     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
30         unchecked {
31             if (b > a) return (false, 0);
32             return (true, a - b);
33         }
34     }
35 
36     /**
37      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
38      *
39      * _Available since v3.4._
40      */
41     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
42         unchecked {
43             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
44             // benefit is lost if 'b' is also tested.
45             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
46             if (a == 0) return (true, 0);
47             uint256 c = a * b;
48             if (c / a != b) return (false, 0);
49             return (true, c);
50         }
51     }
52 
53     /**
54      * @dev Returns the division of two unsigned integers, with a division by zero flag.
55      *
56      * _Available since v3.4._
57      */
58     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
59         unchecked {
60             if (b == 0) return (false, 0);
61             return (true, a / b);
62         }
63     }
64 
65     /**
66      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
67      *
68      * _Available since v3.4._
69      */
70     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         unchecked {
72             if (b == 0) return (false, 0);
73             return (true, a % b);
74         }
75     }
76 
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      *
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         return a + b;
89     }
90 
91     /**
92      * @dev Returns the subtraction of two unsigned integers, reverting on
93      * overflow (when the result is negative).
94      *
95      * Counterpart to Solidity's `-` operator.
96      *
97      * Requirements:
98      *
99      * - Subtraction cannot overflow.
100      */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         return a - b;
103     }
104 
105     /**
106      * @dev Returns the multiplication of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `*` operator.
110      *
111      * Requirements:
112      *
113      * - Multiplication cannot overflow.
114      */
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         return a * b;
117     }
118 
119     /**
120      * @dev Returns the integer division of two unsigned integers, reverting on
121      * division by zero. The result is rounded towards zero.
122      *
123      * Counterpart to Solidity's `/` operator.
124      *
125      * Requirements:
126      *
127      * - The divisor cannot be zero.
128      */
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a / b;
131     }
132 
133     /**
134      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
135      * reverting when dividing by zero.
136      *
137      * Counterpart to Solidity's `%` operator. This function uses a `revert`
138      * opcode (which leaves remaining gas untouched) while Solidity uses an
139      * invalid opcode to revert (consuming all remaining gas).
140      *
141      * Requirements:
142      *
143      * - The divisor cannot be zero.
144      */
145     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
146         return a % b;
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * CAUTION: This function is deprecated because it requires allocating memory for the error
154      * message unnecessarily. For custom revert reasons use {trySub}.
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      *
160      * - Subtraction cannot overflow.
161      */
162     function sub(
163         uint256 a,
164         uint256 b,
165         string memory errorMessage
166     ) internal pure returns (uint256) {
167         unchecked {
168             require(b <= a, errorMessage);
169             return a - b;
170         }
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(
186         uint256 a,
187         uint256 b,
188         string memory errorMessage
189     ) internal pure returns (uint256) {
190         unchecked {
191             require(b > 0, errorMessage);
192             return a / b;
193         }
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * reverting with custom message when dividing by zero.
199      *
200      * CAUTION: This function is deprecated because it requires allocating memory for the error
201      * message unnecessarily. For custom revert reasons use {tryMod}.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function mod(
212         uint256 a,
213         uint256 b,
214         string memory errorMessage
215     ) internal pure returns (uint256) {
216         unchecked {
217             require(b > 0, errorMessage);
218             return a % b;
219         }
220     }
221 }
222 
223 /**
224  * @dev Interface of the ERC165 standard, as defined in the
225  * https://eips.ethereum.org/EIPS/eip-165[EIP].
226  *
227  * Implementers can declare support of contract interfaces, which can then be
228  * queried by others ({ERC165Checker}).
229  *
230  * For an implementation, see {ERC165}.
231  */
232 interface IERC165 {
233     /**
234      * @dev Returns true if this contract implements the interface defined by
235      * `interfaceId`. See the corresponding
236      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
237      * to learn more about how these ids are created.
238      *
239      * This function call must use less than 30 000 gas.
240      */
241     function supportsInterface(bytes4 interfaceId) external view returns (bool);
242 }
243 
244 /**
245  * @dev Implementation of the {IERC165} interface.
246  *
247  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
248  * for the additional interface id that will be supported. For example:
249  *
250  * ```solidity
251  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
252  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
253  * }
254  * ```
255  *
256  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
257  */
258 abstract contract ERC165 is IERC165 {
259     /**
260      * @dev See {IERC165-supportsInterface}.
261      */
262     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
263         return interfaceId == type(IERC165).interfaceId;
264     }
265 }
266 
267 /**
268  * @dev Required interface of an ERC721 compliant contract.
269  */
270 interface IERC721 is IERC165 {
271     /**
272      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
273      */
274     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
275 
276     /**
277      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
278      */
279     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
280 
281     /**
282      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
283      */
284     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
285 
286     /**
287      * @dev Returns the number of tokens in ``owner``'s account.
288      */
289     function balanceOf(address owner) external view returns (uint256 balance);
290 
291     /**
292      * @dev Returns the owner of the `tokenId` token.
293      *
294      * Requirements:
295      *
296      * - `tokenId` must exist.
297      */
298     function ownerOf(uint256 tokenId) external view returns (address owner);
299 
300     /**
301      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
302      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
303      *
304      * Requirements:
305      *
306      * - `from` cannot be the zero address.
307      * - `to` cannot be the zero address.
308      * - `tokenId` token must exist and be owned by `from`.
309      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
310      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
311      *
312      * Emits a {Transfer} event.
313      */
314     function safeTransferFrom(
315         address from,
316         address to,
317         uint256 tokenId
318     ) external;
319 
320     /**
321      * @dev Transfers `tokenId` token from `from` to `to`.
322      *
323      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
324      *
325      * Requirements:
326      *
327      * - `from` cannot be the zero address.
328      * - `to` cannot be the zero address.
329      * - `tokenId` token must be owned by `from`.
330      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
331      *
332      * Emits a {Transfer} event.
333      */
334     function transferFrom(
335         address from,
336         address to,
337         uint256 tokenId
338     ) external;
339 
340     /**
341      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
342      * The approval is cleared when the token is transferred.
343      *
344      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
345      *
346      * Requirements:
347      *
348      * - The caller must own the token or be an approved operator.
349      * - `tokenId` must exist.
350      *
351      * Emits an {Approval} event.
352      */
353     function approve(address to, uint256 tokenId) external;
354 
355     /**
356      * @dev Returns the account approved for `tokenId` token.
357      *
358      * Requirements:
359      *
360      * - `tokenId` must exist.
361      */
362     function getApproved(uint256 tokenId) external view returns (address operator);
363 
364     /**
365      * @dev Approve or remove `operator` as an operator for the caller.
366      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
367      *
368      * Requirements:
369      *
370      * - The `operator` cannot be the caller.
371      *
372      * Emits an {ApprovalForAll} event.
373      */
374     function setApprovalForAll(address operator, bool _approved) external;
375 
376     /**
377      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
378      *
379      * See {setApprovalForAll}
380      */
381     function isApprovedForAll(address owner, address operator) external view returns (bool);
382 
383     /**
384      * @dev Safely transfers `tokenId` token from `from` to `to`.
385      *
386      * Requirements:
387      *
388      * - `from` cannot be the zero address.
389      * - `to` cannot be the zero address.
390      * - `tokenId` token must exist and be owned by `from`.
391      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
392      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
393      *
394      * Emits a {Transfer} event.
395      */
396     function safeTransferFrom(
397         address from,
398         address to,
399         uint256 tokenId,
400         bytes calldata data
401     ) external;
402 }
403 
404 /**
405  * @title ERC721 token receiver interface
406  * @dev Interface for any contract that wants to support safeTransfers
407  * from ERC721 asset contracts.
408  */
409 interface IERC721Receiver {
410     /**
411      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
412      * by `operator` from `from`, this function is called.
413      *
414      * It must return its Solidity selector to confirm the token transfer.
415      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
416      *
417      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
418      */
419     function onERC721Received(
420         address operator,
421         address from,
422         uint256 tokenId,
423         bytes calldata data
424     ) external returns (bytes4);
425 }
426 
427 /**
428  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
429  * @dev See https://eips.ethereum.org/EIPS/eip-721
430  */
431 interface IERC721Metadata is IERC721 {
432     /**
433      * @dev Returns the token collection name.
434      */
435     function name() external view returns (string memory);
436 
437     /**
438      * @dev Returns the token collection symbol.
439      */
440     function symbol() external view returns (string memory);
441 
442     /**
443      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
444      */
445     function tokenURI(uint256 tokenId) external view returns (string memory);
446 }
447 
448 /**
449  * @dev Collection of functions related to the address type
450  */
451 library Address {
452     /**
453      * @dev Returns true if `account` is a contract.
454      *
455      * [IMPORTANT]
456      * ====
457      * It is unsafe to assume that an address for which this function returns
458      * false is an externally-owned account (EOA) and not a contract.
459      *
460      * Among others, `isContract` will return false for the following
461      * types of addresses:
462      *
463      *  - an externally-owned account
464      *  - a contract in construction
465      *  - an address where a contract will be created
466      *  - an address where a contract lived, but was destroyed
467      * ====
468      */
469     function isContract(address account) internal view returns (bool) {
470         // This method relies on extcodesize, which returns 0 for contracts in
471         // construction, since the code is only stored at the end of the
472         // constructor execution.
473 
474         uint256 size;
475         assembly {
476             size := extcodesize(account)
477         }
478         return size > 0;
479     }
480 
481     /**
482      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
483      * `recipient`, forwarding all available gas and reverting on errors.
484      *
485      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
486      * of certain opcodes, possibly making contracts go over the 2300 gas limit
487      * imposed by `transfer`, making them unable to receive funds via
488      * `transfer`. {sendValue} removes this limitation.
489      *
490      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
491      *
492      * IMPORTANT: because control is transferred to `recipient`, care must be
493      * taken to not create reentrancy vulnerabilities. Consider using
494      * {ReentrancyGuard} or the
495      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
496      */
497     function sendValue(address payable recipient, uint256 amount) internal {
498         require(address(this).balance >= amount, "Address: insufficient balance");
499 
500         (bool success, ) = recipient.call{value: amount}("");
501         require(success, "Address: unable to send value, recipient may have reverted");
502     }
503 
504     /**
505      * @dev Performs a Solidity function call using a low level `call`. A
506      * plain `call` is an unsafe replacement for a function call: use this
507      * function instead.
508      *
509      * If `target` reverts with a revert reason, it is bubbled up by this
510      * function (like regular Solidity function calls).
511      *
512      * Returns the raw returned data. To convert to the expected return value,
513      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
514      *
515      * Requirements:
516      *
517      * - `target` must be a contract.
518      * - calling `target` with `data` must not revert.
519      *
520      * _Available since v3.1._
521      */
522     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
523         return functionCall(target, data, "Address: low-level call failed");
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
528      * `errorMessage` as a fallback revert reason when `target` reverts.
529      *
530      * _Available since v3.1._
531      */
532     function functionCall(
533         address target,
534         bytes memory data,
535         string memory errorMessage
536     ) internal returns (bytes memory) {
537         return functionCallWithValue(target, data, 0, errorMessage);
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
542      * but also transferring `value` wei to `target`.
543      *
544      * Requirements:
545      *
546      * - the calling contract must have an ETH balance of at least `value`.
547      * - the called Solidity function must be `payable`.
548      *
549      * _Available since v3.1._
550      */
551     function functionCallWithValue(
552         address target,
553         bytes memory data,
554         uint256 value
555     ) internal returns (bytes memory) {
556         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
561      * with `errorMessage` as a fallback revert reason when `target` reverts.
562      *
563      * _Available since v3.1._
564      */
565     function functionCallWithValue(
566         address target,
567         bytes memory data,
568         uint256 value,
569         string memory errorMessage
570     ) internal returns (bytes memory) {
571         require(address(this).balance >= value, "Address: insufficient balance for call");
572         require(isContract(target), "Address: call to non-contract");
573 
574         (bool success, bytes memory returndata) = target.call{value: value}(data);
575         return _verifyCallResult(success, returndata, errorMessage);
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
580      * but performing a static call.
581      *
582      * _Available since v3.3._
583      */
584     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
585         return functionStaticCall(target, data, "Address: low-level static call failed");
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
590      * but performing a static call.
591      *
592      * _Available since v3.3._
593      */
594     function functionStaticCall(
595         address target,
596         bytes memory data,
597         string memory errorMessage
598     ) internal view returns (bytes memory) {
599         require(isContract(target), "Address: static call to non-contract");
600 
601         (bool success, bytes memory returndata) = target.staticcall(data);
602         return _verifyCallResult(success, returndata, errorMessage);
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
607      * but performing a delegate call.
608      *
609      * _Available since v3.4._
610      */
611     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
612         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
617      * but performing a delegate call.
618      *
619      * _Available since v3.4._
620      */
621     function functionDelegateCall(
622         address target,
623         bytes memory data,
624         string memory errorMessage
625     ) internal returns (bytes memory) {
626         require(isContract(target), "Address: delegate call to non-contract");
627 
628         (bool success, bytes memory returndata) = target.delegatecall(data);
629         return _verifyCallResult(success, returndata, errorMessage);
630     }
631 
632     function _verifyCallResult(
633         bool success,
634         bytes memory returndata,
635         string memory errorMessage
636     ) private pure returns (bytes memory) {
637         if (success) {
638             return returndata;
639         } else {
640             // Look for revert reason and bubble it up if present
641             if (returndata.length > 0) {
642                 // The easiest way to bubble the revert reason is using memory via assembly
643 
644                 assembly {
645                     let returndata_size := mload(returndata)
646                     revert(add(32, returndata), returndata_size)
647                 }
648             } else {
649                 revert(errorMessage);
650             }
651         }
652     }
653 }
654 
655 /*
656  * @dev Provides information about the current execution context, including the
657  * sender of the transaction and its data. While these are generally available
658  * via msg.sender and msg.data, they should not be accessed in such a direct
659  * manner, since when dealing with meta-transactions the account sending and
660  * paying for execution may not be the actual sender (as far as an application
661  * is concerned).
662  *
663  * This contract is only required for intermediate, library-like contracts.
664  */
665 abstract contract Context {
666     function _msgSender() internal view virtual returns (address) {
667         return msg.sender;
668     }
669 
670     function _msgData() internal view virtual returns (bytes calldata) {
671         return msg.data;
672     }
673 }
674 
675 /**
676  * @dev String operations.
677  */
678 library Strings {
679     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
680 
681     /**
682      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
683      */
684     function toString(uint256 value) internal pure returns (string memory) {
685         // Inspired by OraclizeAPI's implementation - MIT licence
686         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
687 
688         if (value == 0) {
689             return "0";
690         }
691         uint256 temp = value;
692         uint256 digits;
693         while (temp != 0) {
694             digits++;
695             temp /= 10;
696         }
697         bytes memory buffer = new bytes(digits);
698         while (value != 0) {
699             digits -= 1;
700             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
701             value /= 10;
702         }
703         return string(buffer);
704     }
705 
706     /**
707      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
708      */
709     function toHexString(uint256 value) internal pure returns (string memory) {
710         if (value == 0) {
711             return "0x00";
712         }
713         uint256 temp = value;
714         uint256 length = 0;
715         while (temp != 0) {
716             length++;
717             temp >>= 8;
718         }
719         return toHexString(value, length);
720     }
721 
722     /**
723      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
724      */
725     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
726         bytes memory buffer = new bytes(2 * length + 2);
727         buffer[0] = "0";
728         buffer[1] = "x";
729         for (uint256 i = 2 * length + 1; i > 1; --i) {
730             buffer[i] = _HEX_SYMBOLS[value & 0xf];
731             value >>= 4;
732         }
733         require(value == 0, "Strings: hex length insufficient");
734         return string(buffer);
735     }
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
762  * @dev Contract module which provides a basic access control mechanism, where
763  * there is an account (an owner) that can be granted exclusive access to
764  * specific functions.
765  *
766  * By default, the owner account will be the one that deploys the contract. This
767  * can later be changed with {transferOwnership}.
768  *
769  * This module is used through inheritance. It will make available the modifier
770  * `onlyOwner`, which can be applied to your functions to restrict their use to
771  * the owner.
772  */
773 abstract contract Ownable is Context {
774     address private _owner;
775 
776     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
777 
778     /**
779      * @dev Initializes the contract setting the deployer as the initial owner.
780      */
781     constructor() {
782         _setOwner(_msgSender());
783     }
784 
785     /**
786      * @dev Returns the address of the current owner.
787      */
788     function owner() public view virtual returns (address) {
789         return _owner;
790     }
791 
792     /**
793      * @dev Throws if called by any account other than the owner.
794      */
795     modifier onlyOwner() {
796         require(owner() == _msgSender(), "Ownable: caller is not the owner");
797         _;
798     }
799 
800     /**
801      * @dev Leaves the contract without owner. It will not be possible to call
802      * `onlyOwner` functions anymore. Can only be called by the current owner.
803      *
804      * NOTE: Renouncing ownership will leave the contract without an owner,
805      * thereby removing any functionality that is only available to the owner.
806      */
807     function renounceOwnership() public virtual onlyOwner {
808         _setOwner(address(0));
809     }
810 
811     /**
812      * @dev Transfers ownership of the contract to a new account (`newOwner`).
813      * Can only be called by the current owner.
814      */
815     function transferOwnership(address newOwner) public virtual onlyOwner {
816         require(newOwner != address(0), "Ownable: new owner is the zero address");
817         _setOwner(newOwner);
818     }
819 
820     function _setOwner(address newOwner) private {
821         address oldOwner = _owner;
822         _owner = newOwner;
823         emit OwnershipTransferred(oldOwner, newOwner);
824     }
825 }
826 
827 /**
828  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
829  * the Metadata extension, but not including the Enumerable extension, which is available separately as
830  * {ERC721Enumerable}.
831  */
832 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
833     using Address for address;
834     using Strings for uint256;
835 
836     // Token name
837     string private _name;
838 
839     // Token symbol
840     string private _symbol;
841 
842     // Mapping from token ID to owner address
843     mapping(uint256 => address) private _owners;
844 
845     // Mapping owner address to token count
846     mapping(address => uint256) private _balances;
847 
848     // Mapping from token ID to approved address
849     mapping(uint256 => address) private _tokenApprovals;
850 
851     // Mapping from owner to operator approvals
852     mapping(address => mapping(address => bool)) private _operatorApprovals;
853 
854     /**
855      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
856      */
857     constructor(string memory name_, string memory symbol_) {
858         _name = name_;
859         _symbol = symbol_;
860     }
861 
862     /**
863      * @dev See {IERC165-supportsInterface}.
864      */
865     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
866         return
867             interfaceId == type(IERC721).interfaceId ||
868             interfaceId == type(IERC721Metadata).interfaceId ||
869             super.supportsInterface(interfaceId);
870     }
871 
872     /**
873      * @dev See {IERC721-balanceOf}.
874      */
875     function balanceOf(address owner) public view virtual override returns (uint256) {
876         require(owner != address(0), "ERC721: balance query for the zero address");
877         return _balances[owner];
878     }
879 
880     /**
881      * @dev See {IERC721-ownerOf}.
882      */
883     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
884         address owner = _owners[tokenId];
885         require(owner != address(0), "ERC721: owner query for nonexistent token");
886         return owner;
887     }
888 
889     /**
890      * @dev See {IERC721Metadata-name}.
891      */
892     function name() public view virtual override returns (string memory) {
893         return _name;
894     }
895 
896     /**
897      * @dev See {IERC721Metadata-symbol}.
898      */
899     function symbol() public view virtual override returns (string memory) {
900         return _symbol;
901     }
902 
903     /**
904      * @dev See {IERC721Metadata-tokenURI}.
905      */
906     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
907         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
908 
909         string memory baseURI = _baseURI();
910         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
911     }
912 
913     /**
914      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
915      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
916      * by default, can be overriden in child contracts.
917      */
918     function _baseURI() internal view virtual returns (string memory) {
919         return "";
920     }
921 
922     /**
923      * @dev See {IERC721-approve}.
924      */
925     function approve(address to, uint256 tokenId) public virtual override {
926         address owner = ERC721.ownerOf(tokenId);
927         require(to != owner, "ERC721: approval to current owner");
928 
929         require(
930             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
931             "ERC721: approve caller is not owner nor approved for all"
932         );
933 
934         _approve(to, tokenId);
935     }
936 
937     /**
938      * @dev See {IERC721-getApproved}.
939      */
940     function getApproved(uint256 tokenId) public view virtual override returns (address) {
941         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
942 
943         return _tokenApprovals[tokenId];
944     }
945 
946     /**
947      * @dev See {IERC721-setApprovalForAll}.
948      */
949     function setApprovalForAll(address operator, bool approved) public virtual override {
950         require(operator != _msgSender(), "ERC721: approve to caller");
951 
952         _operatorApprovals[_msgSender()][operator] = approved;
953         emit ApprovalForAll(_msgSender(), operator, approved);
954     }
955 
956     /**
957      * @dev See {IERC721-isApprovedForAll}.
958      */
959     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
960         return _operatorApprovals[owner][operator];
961     }
962 
963     /**
964      * @dev See {IERC721-transferFrom}.
965      */
966     function transferFrom(
967         address from,
968         address to,
969         uint256 tokenId
970     ) public virtual override {
971         //solhint-disable-next-line max-line-length
972         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
973 
974         _transfer(from, to, tokenId);
975     }
976 
977     /**
978      * @dev See {IERC721-safeTransferFrom}.
979      */
980     function safeTransferFrom(
981         address from,
982         address to,
983         uint256 tokenId
984     ) public virtual override {
985         safeTransferFrom(from, to, tokenId, "");
986     }
987 
988     /**
989      * @dev See {IERC721-safeTransferFrom}.
990      */
991     function safeTransferFrom(
992         address from,
993         address to,
994         uint256 tokenId,
995         bytes memory _data
996     ) public virtual override {
997         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
998         _safeTransfer(from, to, tokenId, _data);
999     }
1000 
1001     /**
1002      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1003      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1004      *
1005      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1006      *
1007      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1008      * implement alternative mechanisms to perform token transfer, such as signature-based.
1009      *
1010      * Requirements:
1011      *
1012      * - `from` cannot be the zero address.
1013      * - `to` cannot be the zero address.
1014      * - `tokenId` token must exist and be owned by `from`.
1015      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1016      *
1017      * Emits a {Transfer} event.
1018      */
1019     function _safeTransfer(
1020         address from,
1021         address to,
1022         uint256 tokenId,
1023         bytes memory _data
1024     ) internal virtual {
1025         _transfer(from, to, tokenId);
1026         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1027     }
1028 
1029     /**
1030      * @dev Returns whether `tokenId` exists.
1031      *
1032      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1033      *
1034      * Tokens start existing when they are minted (`_mint`),
1035      * and stop existing when they are burned (`_burn`).
1036      */
1037     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1038         return _owners[tokenId] != address(0);
1039     }
1040 
1041     /**
1042      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1043      *
1044      * Requirements:
1045      *
1046      * - `tokenId` must exist.
1047      */
1048     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1049         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1050         address owner = ERC721.ownerOf(tokenId);
1051         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1052     }
1053 
1054     /**
1055      * @dev Safely mints `tokenId` and transfers it to `to`.
1056      *
1057      * Requirements:
1058      *
1059      * - `tokenId` must not exist.
1060      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function _safeMint(address to, uint256 tokenId) internal virtual {
1065         _safeMint(to, tokenId, "");
1066     }
1067 
1068     /**
1069      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1070      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1071      */
1072     function _safeMint(
1073         address to,
1074         uint256 tokenId,
1075         bytes memory _data
1076     ) internal virtual {
1077         _mint(to, tokenId);
1078         require(
1079             _checkOnERC721Received(address(0), to, tokenId, _data),
1080             "ERC721: transfer to non ERC721Receiver implementer"
1081         );
1082     }
1083 
1084     /**
1085      * @dev Mints `tokenId` and transfers it to `to`.
1086      *
1087      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1088      *
1089      * Requirements:
1090      *
1091      * - `tokenId` must not exist.
1092      * - `to` cannot be the zero address.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function _mint(address to, uint256 tokenId) internal virtual {
1097         require(to != address(0), "ERC721: mint to the zero address");
1098         require(!_exists(tokenId), "ERC721: token already minted");
1099 
1100         _beforeTokenTransfer(address(0), to, tokenId);
1101 
1102         _balances[to] += 1;
1103         _owners[tokenId] = to;
1104 
1105         emit Transfer(address(0), to, tokenId);
1106     }
1107 
1108     /**
1109      * @dev Destroys `tokenId`.
1110      * The approval is cleared when the token is burned.
1111      *
1112      * Requirements:
1113      *
1114      * - `tokenId` must exist.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function _burn(uint256 tokenId) internal virtual {
1119         address owner = ERC721.ownerOf(tokenId);
1120 
1121         _beforeTokenTransfer(owner, address(0), tokenId);
1122 
1123         // Clear approvals
1124         _approve(address(0), tokenId);
1125 
1126         _balances[owner] -= 1;
1127         delete _owners[tokenId];
1128 
1129         emit Transfer(owner, address(0), tokenId);
1130     }
1131 
1132     /**
1133      * @dev Transfers `tokenId` from `from` to `to`.
1134      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1135      *
1136      * Requirements:
1137      *
1138      * - `to` cannot be the zero address.
1139      * - `tokenId` token must be owned by `from`.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function _transfer(
1144         address from,
1145         address to,
1146         uint256 tokenId
1147     ) internal virtual {
1148         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1149         require(to != address(0), "ERC721: transfer to the zero address");
1150 
1151         _beforeTokenTransfer(from, to, tokenId);
1152 
1153         // Clear approvals from the previous owner
1154         _approve(address(0), tokenId);
1155 
1156         _balances[from] -= 1;
1157         _balances[to] += 1;
1158         _owners[tokenId] = to;
1159 
1160         emit Transfer(from, to, tokenId);
1161     }
1162 
1163     /**
1164      * @dev Approve `to` to operate on `tokenId`
1165      *
1166      * Emits a {Approval} event.
1167      */
1168     function _approve(address to, uint256 tokenId) internal virtual {
1169         _tokenApprovals[tokenId] = to;
1170         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1171     }
1172 
1173     /**
1174      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1175      * The call is not executed if the target address is not a contract.
1176      *
1177      * @param from address representing the previous owner of the given token ID
1178      * @param to target address that will receive the tokens
1179      * @param tokenId uint256 ID of the token to be transferred
1180      * @param _data bytes optional data to send along with the call
1181      * @return bool whether the call correctly returned the expected magic value
1182      */
1183     function _checkOnERC721Received(
1184         address from,
1185         address to,
1186         uint256 tokenId,
1187         bytes memory _data
1188     ) private returns (bool) {
1189         if (to.isContract()) {
1190             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1191                 return retval == IERC721Receiver(to).onERC721Received.selector;
1192             } catch (bytes memory reason) {
1193                 if (reason.length == 0) {
1194                     revert("ERC721: transfer to non ERC721Receiver implementer");
1195                 } else {
1196                     assembly {
1197                         revert(add(32, reason), mload(reason))
1198                     }
1199                 }
1200             }
1201         } else {
1202             return true;
1203         }
1204     }
1205 
1206     /**
1207      * @dev Hook that is called before any token transfer. This includes minting
1208      * and burning.
1209      *
1210      * Calling conditions:
1211      *
1212      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1213      * transferred to `to`.
1214      * - When `from` is zero, `tokenId` will be minted for `to`.
1215      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1216      * - `from` and `to` are never both zero.
1217      *
1218      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1219      */
1220     function _beforeTokenTransfer(
1221         address from,
1222         address to,
1223         uint256 tokenId
1224     ) internal virtual {}
1225 }
1226 
1227 /**
1228  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1229  * enumerability of all the token ids in the contract as well as all token ids owned by each
1230  * account.
1231  */
1232 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1233     // Mapping from owner to list of owned token IDs
1234     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1235 
1236     // Mapping from token ID to index of the owner tokens list
1237     mapping(uint256 => uint256) private _ownedTokensIndex;
1238 
1239     // Array with all token ids, used for enumeration
1240     uint256[] private _allTokens;
1241 
1242     // Mapping from token id to position in the allTokens array
1243     mapping(uint256 => uint256) private _allTokensIndex;
1244 
1245     /**
1246      * @dev See {IERC165-supportsInterface}.
1247      */
1248     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1249         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1250     }
1251 
1252     /**
1253      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1254      */
1255     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1256         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1257         return _ownedTokens[owner][index];
1258     }
1259 
1260     /**
1261      * @dev See {IERC721Enumerable-totalSupply}.
1262      */
1263     function totalSupply() public view virtual override returns (uint256) {
1264         return _allTokens.length;
1265     }
1266 
1267     /**
1268      * @dev See {IERC721Enumerable-tokenByIndex}.
1269      */
1270     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1271         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1272         return _allTokens[index];
1273     }
1274 
1275     /**
1276      * @dev Hook that is called before any token transfer. This includes minting
1277      * and burning.
1278      *
1279      * Calling conditions:
1280      *
1281      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1282      * transferred to `to`.
1283      * - When `from` is zero, `tokenId` will be minted for `to`.
1284      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1285      * - `from` cannot be the zero address.
1286      * - `to` cannot be the zero address.
1287      *
1288      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1289      */
1290     function _beforeTokenTransfer(
1291         address from,
1292         address to,
1293         uint256 tokenId
1294     ) internal virtual override {
1295         super._beforeTokenTransfer(from, to, tokenId);
1296 
1297         if (from == address(0)) {
1298             _addTokenToAllTokensEnumeration(tokenId);
1299         } else if (from != to) {
1300             _removeTokenFromOwnerEnumeration(from, tokenId);
1301         }
1302         if (to == address(0)) {
1303             _removeTokenFromAllTokensEnumeration(tokenId);
1304         } else if (to != from) {
1305             _addTokenToOwnerEnumeration(to, tokenId);
1306         }
1307     }
1308 
1309     /**
1310      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1311      * @param to address representing the new owner of the given token ID
1312      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1313      */
1314     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1315         uint256 length = ERC721.balanceOf(to);
1316         _ownedTokens[to][length] = tokenId;
1317         _ownedTokensIndex[tokenId] = length;
1318     }
1319 
1320     /**
1321      * @dev Private function to add a token to this extension's token tracking data structures.
1322      * @param tokenId uint256 ID of the token to be added to the tokens list
1323      */
1324     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1325         _allTokensIndex[tokenId] = _allTokens.length;
1326         _allTokens.push(tokenId);
1327     }
1328 
1329     /**
1330      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1331      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1332      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1333      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1334      * @param from address representing the previous owner of the given token ID
1335      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1336      */
1337     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1338         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1339         // then delete the last slot (swap and pop).
1340 
1341         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1342         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1343 
1344         // When the token to delete is the last token, the swap operation is unnecessary
1345         if (tokenIndex != lastTokenIndex) {
1346             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1347 
1348             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1349             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1350         }
1351 
1352         // This also deletes the contents at the last position of the array
1353         delete _ownedTokensIndex[tokenId];
1354         delete _ownedTokens[from][lastTokenIndex];
1355     }
1356 
1357     /**
1358      * @dev Private function to remove a token from this extension's token tracking data structures.
1359      * This has O(1) time complexity, but alters the order of the _allTokens array.
1360      * @param tokenId uint256 ID of the token to be removed from the tokens list
1361      */
1362     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1363         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1364         // then delete the last slot (swap and pop).
1365 
1366         uint256 lastTokenIndex = _allTokens.length - 1;
1367         uint256 tokenIndex = _allTokensIndex[tokenId];
1368 
1369         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1370         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1371         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1372         uint256 lastTokenId = _allTokens[lastTokenIndex];
1373 
1374         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1375         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1376 
1377         // This also deletes the contents at the last position of the array
1378         delete _allTokensIndex[tokenId];
1379         _allTokens.pop();
1380     }
1381 
1382     function walletOfOwner(address _owner) external view returns(uint256[] memory) {
1383         uint tokenCount = balanceOf(_owner);
1384         uint256[] memory tokensId = new uint256[](tokenCount);
1385         for(uint i = 0; i < tokenCount; i++){
1386             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1387         }
1388         return tokensId;
1389     }
1390 }
1391 
1392 abstract contract ReentrancyGuard {
1393     // Booleans are more expensive than uint256 or any type that takes up a full
1394     // word because each write operation emits an extra SLOAD to first read the
1395     // slot's contents, replace the bits taken up by the boolean, and then write
1396     // back. This is the compiler's defense against contract upgrades and
1397     // pointer aliasing, and it cannot be disabled.
1398 
1399     // The values being non-zero value makes deployment a bit more expensive,
1400     // but in exchange the refund on every call to nonReentrant will be lower in
1401     // amount. Since refunds are capped to a percentage of the total
1402     // transaction's gas, it is best to keep them low in cases like this one, to
1403     // increase the likelihood of the full refund coming into effect.
1404     uint256 private constant _NOT_ENTERED = 1;
1405     uint256 private constant _ENTERED = 2;
1406 
1407     uint256 private _status;
1408 
1409     constructor() {
1410         _status = _NOT_ENTERED;
1411     }
1412 
1413     /**
1414      * @dev Prevents a contract from calling itself, directly or indirectly.
1415      * Calling a `nonReentrant` function from another `nonReentrant`
1416      * function is not supported. It is possible to prevent this from happening
1417      * by making the `nonReentrant` function external, and making it call a
1418      * `private` function that does the actual work.
1419      */
1420     modifier nonReentrant() {
1421         // On the first call to nonReentrant, _notEntered will be true
1422         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1423 
1424         // Any calls to nonReentrant after this point will fail
1425         _status = _ENTERED;
1426 
1427         _;
1428 
1429         // By storing the original value once again, a refund is triggered (see
1430         // https://eips.ethereum.org/EIPS/eip-2200)
1431         _status = _NOT_ENTERED;
1432     }
1433 }
1434 
1435 contract SoftStakingMPHOLD is Ownable, ReentrancyGuard {
1436     using SafeMath for uint256;
1437 
1438     uint256 public totalSupply = 150000000000000000000000000;
1439 
1440 	mapping (address => bool) public _validators;
1441 
1442     // Mapping from token ID to owner address
1443     mapping(uint256 => address) private _owners;
1444 
1445     // Mapping token ID to total time
1446     mapping(uint256 => uint256) private _totalTime;
1447 
1448     // Mapping token ID to total balance
1449     mapping(uint256 => uint256) private _balance;
1450 
1451     // Mapping token ID to timestamp
1452     mapping(uint256 => uint256) private _time;
1453 
1454     // Mapping token ID to timestamp
1455     mapping(uint256 => uint256) private _timeStart;
1456 
1457     // Mapping token ID to ProofOfPet
1458     mapping(uint256 => bool) private _proofOfPet;
1459 
1460     // Mapping token ID to ProofOfPet
1461     mapping(uint256 => address) private _proofOfPetOwner;
1462 
1463     uint256 public proofOfPetPeriod = 15780000;
1464 
1465     // Mapping token ID to application of ProofOfPet
1466     mapping(uint256 => bool) private _applyProofOfPet;
1467 
1468     Factions factions = Factions(0xaf66FcffE806049B82208594868BCEE18201c08a);
1469 
1470     bool killed = false;
1471     bool proofOfPetInitialActivation = true;
1472 
1473     ERC721Enumerable officialContract = ERC721Enumerable(0x09233d553058c2F42ba751C87816a8E9FaE7Ef10);
1474 
1475     function softStake(uint256[] calldata tokenIds) public nonReentrant {
1476         for (uint256 index = 0; index < tokenIds.length; index++) {
1477             require(officialContract.ownerOf(tokenIds[index]) == msg.sender, "SoftStakingMPH: You don't own that token.");
1478             
1479             _time[tokenIds[index]] = block.timestamp;
1480             _timeStart[tokenIds[index]] = block.timestamp;
1481             _owners[tokenIds[index]] = msg.sender;
1482         }
1483     }
1484 
1485     function useFromToken(address addr, uint256 tokenId, uint256 amount) public nonReentrant {
1486         require(_validators[msg.sender] == true, "SoftStakingMPH: Not a valid validator.");
1487         require(_balance[tokenId] >= amount, "SoftStakingMPH: You don't own that token.");
1488         require(officialContract.ownerOf(tokenId) == addr, "SoftStakingMPH: The holder does not own this hooligan.");
1489         
1490         _balance[tokenId] = _balance[tokenId].sub(amount);
1491     }
1492 
1493     function isStakedBy(uint256 tokenId, address addr) public view returns (bool) {
1494         bool temp = false;
1495         if (_time[tokenId] > 0 && _owners[tokenId] == addr) {
1496             temp = true;
1497         }
1498         return temp;
1499     }
1500 
1501     function time(uint256 tokenId) public view returns (uint256) {
1502         return _time[tokenId];
1503     }
1504 
1505     function stakeOwnerOf(uint256 tokenId) public view returns (address) {
1506         return _owners[tokenId];
1507     }
1508 
1509     function balance(address addr) public view returns (uint256) {
1510         uint256[] memory hoolis = officialContract.walletOfOwner(addr);
1511         uint256 total = 0;
1512         for (uint256 hooli = 0; hooli < hoolis.length; hooli++) {
1513             total = total.add(_balance[hoolis[hooli]]);
1514         }
1515         return total;
1516     }
1517 
1518     function balanceOfToken(uint256 tokenId) public view returns (uint256) {
1519         return _balance[tokenId];
1520     }
1521 
1522     function unSoftStake(uint256[] calldata tokenIds) public nonReentrant {
1523 
1524         for (uint256 tokenId = 0; tokenId < tokenIds.length; tokenId++) {
1525             require(officialContract.ownerOf(tokenIds[tokenId]) == msg.sender, "SoftStakingMPH: You don't own that token.");
1526             require(_time[tokenIds[tokenId]] != 0, "SoftStakingMPH: This token is not staked.");
1527 
1528             _totalTime[tokenIds[tokenId]] = _totalTime[tokenIds[tokenId]].add(block.timestamp.sub(_time[tokenIds[tokenId]]));
1529             _timeStart[tokenIds[tokenId]] = block.timestamp;
1530             _time[tokenIds[tokenId]] = 0;
1531         }
1532     }
1533 
1534     function unSoftStakeWith(uint256[] calldata tokenIds, uint16[7][] memory all) public {
1535         allFaction(msg.sender, all);
1536 
1537         for (uint256 tokenId = 0; tokenId < tokenIds.length; tokenId++) {
1538             require(officialContract.ownerOf(tokenIds[tokenId]) == msg.sender, "SoftStakingMPH: You don't own that token.");
1539             require(_time[tokenIds[tokenId]] != 0, "SoftStakingMPH: This token is not staked.");
1540 
1541             _totalTime[tokenIds[tokenId]] = _totalTime[tokenIds[tokenId]].add(block.timestamp.sub(_time[tokenIds[tokenId]]));
1542             _timeStart[tokenIds[tokenId]] = block.timestamp;
1543             _time[tokenIds[tokenId]] = 0;
1544         }
1545     }
1546 
1547     function killIt() public onlyOwner {
1548         killed = true;
1549     }
1550 
1551     function unlock(address addr, uint tokenId, uint256 level) internal {
1552         require(killed == false, "SoftStakingMPH: Switched to Karrots.");
1553         require(officialContract.ownerOf(tokenId) == addr, "SoftStakingMPH: You don't own that token.");
1554         require(_owners[tokenId] == addr, "SoftStakingMPH: You are not the staker of this Hooligan.");
1555 
1556         uint256 amount = 0;
1557 
1558         if (level == 0) {
1559             if (_proofOfPet[tokenId] == true && _proofOfPetOwner[tokenId] == addr) {
1560                 amount = (block.timestamp.sub(_time[tokenId])).mul(1000000000000000000).div(8640).div(10).mul(13);
1561                 _balance[tokenId] = _balance[tokenId].add(amount);
1562                 require(totalSupply >= amount, "SoftStakingMPH: There is no more tokens in the allocation to mint from.");
1563                 totalSupply = totalSupply.sub(amount);
1564             } else {
1565                 amount = (block.timestamp.sub(_time[tokenId])).mul(1000000000000000000).div(8640);
1566                 _balance[tokenId] = _balance[tokenId].add(amount);
1567                 require(totalSupply >= amount, "SoftStakingMPH: There is no more tokens in the allocation to mint from.");
1568                 totalSupply = totalSupply.sub(amount);
1569             }
1570         } else if (level == 1) {
1571             if (_proofOfPet[tokenId] == true && _proofOfPetOwner[tokenId] == addr) {
1572                 amount = (block.timestamp.sub(_time[tokenId])).mul(1000000000000000000).div(8640).div(10).mul(13);
1573                 _balance[tokenId] = _balance[tokenId].add(amount);
1574                 require(totalSupply >= amount, "SoftStakingMPH: There is no more tokens in the allocation to mint from.");
1575                 totalSupply = totalSupply.sub(amount);
1576             } else {
1577                 amount = (block.timestamp.sub(_time[tokenId])).mul(1000000000000000000).div(8640).div(10).mul(12);
1578                 _balance[tokenId] = _balance[tokenId].add(amount);
1579                 require(totalSupply >= amount, "SoftStakingMPH: There is no more tokens in the allocation to mint from.");
1580                 totalSupply = totalSupply.sub(amount);
1581             }
1582         } else if (level == 2) {
1583             amount = (block.timestamp.sub(_time[tokenId]).mul(1000000000000000000).div(8640)).div(10).mul(15);
1584             _balance[tokenId] = _balance[tokenId].add(amount);
1585             require(totalSupply >= amount, "SoftStakingMPH: There is no more tokens in the allocation to mint from.");
1586             totalSupply = totalSupply.sub(amount);
1587         }
1588         _totalTime[tokenId] = _totalTime[tokenId].add(block.timestamp.sub(_time[tokenId]));
1589         _time[tokenId] = block.timestamp;
1590     }
1591 
1592     function allFaction(uint16[7][] memory all) public {
1593 
1594         allFaction(msg.sender, all);
1595     }
1596 
1597     function allFaction(address addr, uint16[7][] memory all) internal {
1598 
1599         uint256 howMany7s = 0;
1600 
1601         for (uint256 eachRow = 0; eachRow < all.length; eachRow++) {
1602             bool isA7 = true;
1603             for (uint256 eachCol = 0; eachCol < all[eachRow].length; eachCol++) {
1604                 if (all[eachRow][eachCol] == 9999) {
1605                     isA7 = false;
1606                 }
1607             }
1608             if (isA7) {
1609                 howMany7s += 1;
1610                 for (uint256 eachCol = 0; eachCol < all[eachRow].length; eachCol++) {
1611                     
1612                     require(eachCol == factions.getFactions(uint256(all[eachRow][eachCol])), "SoftStakingMPH: The Hooligan mentioned does not match the faction given.");
1613                     unlock(addr, uint256(all[eachRow][eachCol]), 2);
1614                 }
1615             }
1616         }
1617 
1618         uint256 howMany3s = 0;
1619 
1620         for (uint256 eachRow = 0; eachRow < all.length; eachRow++) {
1621             uint256 howManyInARow = 0;
1622             for (uint256 eachCol = 0; eachCol < all[eachRow].length; eachCol++) {
1623                 if (all[eachRow][eachCol] != 9999) {
1624                     howManyInARow += 1;
1625                 }
1626             }
1627             if (howManyInARow >= 3 && howManyInARow < 7) {
1628                 howMany3s += 1;
1629                 for (uint256 eachCol = 0; eachCol < all[eachRow].length; eachCol++) {
1630                     uint256 count = 0;
1631                     if (all[eachRow][eachCol] != 9999 && count <= 3) {
1632                         require(eachCol == factions.getFactions(uint256(all[eachRow][eachCol])), "SoftStakingMPH: The Hooligan mentioned does not match the faction given.");
1633                         unlock(addr, uint256(all[eachRow][eachCol]), 1);
1634                         count += 1;
1635                     } else if (all[eachRow][eachCol] != 9999) {
1636                         require(eachCol == factions.getFactions(uint256(all[eachRow][eachCol])), "SoftStakingMPH: The Hooligan mentioned does not match the faction given.");
1637                         unlock(addr, uint256(all[eachRow][eachCol]), 0);
1638                     }
1639                 }
1640             } else {
1641                 for (uint256 eachCol = 0; eachCol < all[eachRow].length; eachCol++) {
1642                     if (all[eachRow][eachCol] != 9999) {
1643                         require(eachCol == factions.getFactions(uint256(all[eachRow][eachCol])), "SoftStakingMPH: The Hooligan mentioned does not match the faction given.");
1644                         unlock(addr, uint256(all[eachRow][eachCol]), 0);
1645                     }
1646                 }
1647             }
1648         }
1649     }
1650 
1651     function displayTimestamp(uint256 tokenId) public view returns (uint256) {
1652         return _time[tokenId];
1653     }
1654 
1655     function applyProofOfPet(uint256 tokenId) public {
1656         require(officialContract.ownerOf(tokenId) == msg.sender, "SoftStakingMPH: You do not own this Hooligan.");
1657 
1658         if (block.timestamp.sub(_timeStart[tokenId]) >= proofOfPetPeriod && _owners[tokenId] == msg.sender) {
1659             _proofOfPet[tokenId] = true;
1660             _applyProofOfPet[tokenId] = false;
1661             _proofOfPetOwner[tokenId] = msg.sender;
1662         } else {
1663             _applyProofOfPet[tokenId] = true;
1664             _proofOfPetOwner[tokenId] = msg.sender;
1665         }
1666     }
1667 
1668     function setProofOfPetPeriod(uint256 period) public onlyOwner {
1669         proofOfPetPeriod = period;
1670     }
1671 
1672     function endInitialProofOfPetActivationPeriod() public onlyOwner {
1673         proofOfPetInitialActivation = false;
1674     }
1675 
1676     function approveProofOfPet(uint256 tokenId, address addr) public {
1677         require(_validators[msg.sender] == true, "SoftStakingMPH: Not a valid validator.");
1678         require(officialContract.ownerOf(tokenId) == addr, "SoftStakingMPH: The address does not own this Hooligan.");
1679         require(_proofOfPetOwner[tokenId] == addr, "SoftStakingMPH: The address did not apply for Proof Of Pet.");
1680         require(_applyProofOfPet[tokenId] == true, "SoftStakingMPH: The Hooligan was not applied for Proof Of Pet validation.");
1681         _proofOfPet[tokenId] = true;
1682         _applyProofOfPet[tokenId] = false;
1683     }
1684 
1685     function approveProofOfPetInitial(uint256[] calldata tokenIds, address[] calldata addr) public onlyOwner {
1686         require(_validators[msg.sender] == true, "SoftStakingMPH: Not a valid validator.");
1687         require(proofOfPetInitialActivation == true, "SoftStakingMPH: This function has been discarded.");
1688         for (uint256 index = 0; index < tokenIds.length; index++) {
1689             require(officialContract.ownerOf(tokenIds[index]) == addr[index], "SoftStakingMPH: The address does not own this Hooligan.");
1690             _proofOfPet[tokenIds[index]] = true;
1691             _applyProofOfPet[tokenIds[index]] = false;
1692             _proofOfPetOwner[tokenIds[index]] = addr[index];
1693         }
1694     }
1695 
1696     function showApplicationOfProofOfPet(uint256 tokenId) public view returns (bool) {
1697         return _applyProofOfPet[tokenId];
1698     }
1699 
1700     function showProofOfPet(uint256 tokenId) public view returns (bool) {
1701         return _proofOfPet[tokenId];
1702     }
1703 
1704     function showProofOfPetOwner(uint256 tokenId) public view returns (address) {
1705         return _proofOfPetOwner[tokenId];
1706     }
1707 
1708     function toggleValidator(address addr) public onlyOwner {
1709         if (_validators[addr]) {
1710             _validators[addr] = false;
1711         } else {
1712             _validators[addr] = true;
1713         }
1714     }
1715 
1716 }
1717 
1718 contract MPHSoftStakingValidator is Ownable, ReentrancyGuard {
1719     using SafeMath for uint256;
1720 
1721     uint256 public totalSupply = 150000000000000000000000000;
1722 
1723 	mapping (address => bool) public _validators;
1724 
1725     // Mapping from token ID to owner address
1726     mapping(uint256 => address) private _owners;
1727 
1728     // Mapping token ID to total time
1729     mapping(uint256 => uint256) private _totalTime;
1730 
1731     // Mapping token ID to total balance
1732     mapping(uint256 => uint256) private _balance;
1733 
1734     // Mapping token ID to timestamp
1735     mapping(uint256 => uint256) private _time;
1736 
1737     // Mapping token ID to timestamp
1738     mapping(uint256 => uint256) public _timeStart;
1739 
1740     // Mapping token ID to ProofOfPet
1741     mapping(uint256 => bool) private _proofOfPet;
1742 
1743     // Mapping token ID to Migration
1744     mapping(uint256 => bool) public _migrated;
1745 
1746     // Mapping token ID to ProofOfPet
1747     mapping(uint256 => address) private _proofOfPetOwner;
1748 
1749     uint256 public proofOfPetPeriod = 15780000;
1750 
1751     // Mapping token ID to application of ProofOfPet
1752     mapping(uint256 => bool) private _applyProofOfPet;
1753 
1754     Factions factions = Factions(0xaf66FcffE806049B82208594868BCEE18201c08a);
1755 
1756     bool killed = false;
1757     bool proofOfPetInitialActivation = true;
1758 
1759     uint256 public cooldownPeriod = 0;
1760 
1761     ERC721Enumerable officialContract = ERC721Enumerable(0x09233d553058c2F42ba751C87816a8E9FaE7Ef10);
1762 
1763     SoftStakingMPHOLD oldSofty = SoftStakingMPHOLD(0x034B7071a1096DBb392b3F9326950BD4aE72D91a);
1764 
1765     function softStake(uint256[] calldata tokenIds) public nonReentrant {
1766 
1767         for (uint256 index = 0; index < tokenIds.length; index++) {
1768             require(officialContract.ownerOf(tokenIds[index]) == msg.sender, "SoftStakingMPH: You don't own that token.");
1769             
1770             importPreviousData(tokenIds[index], msg.sender);
1771 
1772             _time[tokenIds[index]] = block.timestamp;
1773             _timeStart[tokenIds[index]] = block.timestamp;
1774             _owners[tokenIds[index]] = msg.sender;
1775         }
1776     }
1777 
1778     function useFromToken(address addr, uint256 tokenId, uint256 amount) public nonReentrant {
1779 
1780         importPreviousData(tokenId, addr);
1781 
1782         require(_validators[msg.sender] == true, "SoftStakingMPH: Not a valid validator.");
1783         require(_balance[tokenId] >= amount, "SoftStakingMPH: You don't own that token.");
1784         require(officialContract.ownerOf(tokenId) == addr, "SoftStakingMPH: The holder does not own this hooligan.");
1785         
1786         _balance[tokenId] = _balance[tokenId].sub(amount);
1787     }
1788 
1789     function addToToken(address addr, uint256 tokenId, uint256 amount) public nonReentrant {
1790 
1791         importPreviousData(tokenId, addr);
1792 
1793         require(_validators[msg.sender] == true, "SoftStakingMPH: Not a valid validator.");
1794         require(officialContract.ownerOf(tokenId) == addr, "SoftStakingMPH: The holder does not own this hooligan.");
1795         require(totalSupply >= amount, "SoftStakingMPH: Not enough in the supply.");
1796         
1797         totalSupply = totalSupply.sub(amount);
1798         _balance[tokenId] = _balance[tokenId].add(amount);
1799     }
1800 
1801     function isStakedBy(uint256 tokenId, address addr) public view returns (bool) {
1802         bool temp = false;
1803         if (_time[tokenId] > 0 && _owners[tokenId] == addr) {
1804             temp = true;
1805         }
1806         return temp;
1807     }
1808 
1809     function time(uint256 tokenId) public view returns (uint256) {
1810         return _time[tokenId];
1811     }
1812 
1813     function stakeOwnerOf(uint256 tokenId) public view returns (address) {
1814         return _owners[tokenId];
1815     }
1816 
1817     function changeCooldownPeriod(uint256 newPeriod) public onlyOwner {
1818         cooldownPeriod = newPeriod;
1819     }
1820 
1821     function balance(address addr) public view returns (uint256) {
1822         uint256[] memory hoolis = officialContract.walletOfOwner(addr);
1823         uint256 total = 0;
1824         for (uint256 hooli = 0; hooli < hoolis.length; hooli++) {
1825             total = total.add(_balance[hoolis[hooli]]);
1826         }
1827         return total;
1828     }
1829 
1830     function balanceOfToken(uint256 tokenId) public view returns (uint256) {
1831         return _balance[tokenId];
1832     }
1833 
1834     function unSoftStake(uint256[] calldata tokenIds) public nonReentrant {
1835 
1836         for (uint256 tokenId = 0; tokenId < tokenIds.length; tokenId++) {
1837             require(officialContract.ownerOf(tokenIds[tokenId]) == msg.sender, "SoftStakingMPH: You don't own that token.");
1838             importPreviousData(tokenIds[tokenId], msg.sender);
1839             require(_time[tokenIds[tokenId]] != 0, "SoftStakingMPH: This token is not staked.");
1840 
1841             _totalTime[tokenIds[tokenId]] = _totalTime[tokenIds[tokenId]].add(block.timestamp.sub(_time[tokenIds[tokenId]]));
1842             _timeStart[tokenIds[tokenId]] = block.timestamp;
1843             _time[tokenIds[tokenId]] = 0;
1844         }
1845     }
1846 
1847     function unSoftStakeWith(uint256[] calldata tokenIds, uint16[7][] memory all) public {
1848 
1849         allFaction(msg.sender, all);
1850 
1851         for (uint256 tokenId = 0; tokenId < tokenIds.length; tokenId++) {
1852             require(officialContract.ownerOf(tokenIds[tokenId]) == msg.sender, "SoftStakingMPH: You don't own that token.");
1853             require(_time[tokenIds[tokenId]] != 0, "SoftStakingMPH: This token is not staked.");
1854 
1855             _totalTime[tokenIds[tokenId]] = _totalTime[tokenIds[tokenId]].add(block.timestamp.sub(_time[tokenIds[tokenId]]));
1856             _timeStart[tokenIds[tokenId]] = block.timestamp;
1857             _time[tokenIds[tokenId]] = 0;
1858         }
1859     }
1860 
1861     function killIt() public onlyOwner {
1862         killed = true;
1863     }
1864 
1865     function importPreviousData(uint tokenId, address addr) internal {
1866         
1867         if (_migrated[tokenId] == false) {
1868             _balance[tokenId] = _balance[tokenId].add(oldSofty.balanceOfToken(tokenId));
1869             totalSupply = totalSupply.sub(oldSofty.balanceOfToken(tokenId));
1870 
1871             _time[tokenId] = oldSofty.time(tokenId);
1872             _timeStart[tokenId] = oldSofty.time(tokenId);
1873             _owners[tokenId] = addr;
1874             _migrated[tokenId] = true;
1875         }
1876     }
1877 
1878     function unlock(address addr, uint tokenId, uint256 level) internal {
1879         require(killed == false, "SoftStakingMPH: Switched to Karrots.");
1880         require(officialContract.ownerOf(tokenId) == addr, "SoftStakingMPH: You don't own that token.");
1881         importPreviousData(tokenId, addr);
1882         require(_owners[tokenId] == addr, "SoftStakingMPH: You are not the staker of this Hooligan.");
1883         require(_time[tokenId] != 0, "SoftStakingMPH: Hooligan not staked.");
1884         require(block.timestamp.sub(_time[tokenId]) > cooldownPeriod, "SoftStakingMPH: Hooligan still in cooldown.");
1885 
1886         uint256 amount = 0;
1887 
1888         if (level == 0) {
1889             if (_proofOfPet[tokenId] == true && _proofOfPetOwner[tokenId] == addr) {
1890                 amount = (block.timestamp.sub(_time[tokenId])).mul(1000000000000000000).div(8640).div(10).mul(13);
1891                 _balance[tokenId] = _balance[tokenId].add(amount);
1892                 require(totalSupply >= amount, "SoftStakingMPH: There is no more tokens in the allocation to mint from.");
1893                 totalSupply = totalSupply.sub(amount);
1894             } else {
1895                 amount = (block.timestamp.sub(_time[tokenId])).mul(1000000000000000000).div(8640);
1896                 _balance[tokenId] = _balance[tokenId].add(amount);
1897                 require(totalSupply >= amount, "SoftStakingMPH: There is no more tokens in the allocation to mint from.");
1898                 totalSupply = totalSupply.sub(amount);
1899             }
1900         } else if (level == 1) {
1901             if (_proofOfPet[tokenId] == true && _proofOfPetOwner[tokenId] == addr) {
1902                 amount = (block.timestamp.sub(_time[tokenId])).mul(1000000000000000000).div(8640).div(10).mul(13);
1903                 _balance[tokenId] = _balance[tokenId].add(amount);
1904                 require(totalSupply >= amount, "SoftStakingMPH: There is no more tokens in the allocation to mint from.");
1905                 totalSupply = totalSupply.sub(amount);
1906             } else {
1907                 amount = (block.timestamp.sub(_time[tokenId])).mul(1000000000000000000).div(8640).div(10).mul(12);
1908                 _balance[tokenId] = _balance[tokenId].add(amount);
1909                 require(totalSupply >= amount, "SoftStakingMPH: There is no more tokens in the allocation to mint from.");
1910                 totalSupply = totalSupply.sub(amount);
1911             }
1912         } else if (level == 2) {
1913             amount = (block.timestamp.sub(_time[tokenId]).mul(1000000000000000000).div(8640)).div(10).mul(15);
1914             _balance[tokenId] = _balance[tokenId].add(amount);
1915             require(totalSupply >= amount, "SoftStakingMPH: There is no more tokens in the allocation to mint from.");
1916             totalSupply = totalSupply.sub(amount);
1917         }
1918         _totalTime[tokenId] = _totalTime[tokenId].add(block.timestamp.sub(_time[tokenId]));
1919         _time[tokenId] = block.timestamp;
1920     }
1921 
1922     function allFaction(uint16[7][] memory all) public {
1923 
1924         allFaction(msg.sender, all);
1925     }
1926 
1927     function allFaction(address addr, uint16[7][] memory all) internal {
1928 
1929         uint256 howMany7s = 0;
1930 
1931         for (uint256 eachRow = 0; eachRow < all.length; eachRow++) {
1932             bool isA7 = true;
1933             for (uint256 eachCol = 0; eachCol < all[eachRow].length; eachCol++) {
1934                 if (all[eachRow][eachCol] == 9999) {
1935                     isA7 = false;
1936                 }
1937             }
1938             if (isA7) {
1939                 howMany7s += 1;
1940                 for (uint256 eachCol = 0; eachCol < all[eachRow].length; eachCol++) {
1941                     
1942                     require(eachCol == factions.getFactions(uint256(all[eachRow][eachCol])), "SoftStakingMPH: The Hooligan mentioned does not match the faction given.");
1943                     unlock(addr, uint256(all[eachRow][eachCol]), 2);
1944                 }
1945             }
1946         }
1947 
1948         uint256 howMany3s = 0;
1949 
1950         for (uint256 eachRow = 0; eachRow < all.length; eachRow++) {
1951             uint256 howManyInARow = 0;
1952             for (uint256 eachCol = 0; eachCol < all[eachRow].length; eachCol++) {
1953                 if (all[eachRow][eachCol] != 9999) {
1954                     howManyInARow += 1;
1955                 }
1956             }
1957             if (howManyInARow >= 3 && howManyInARow < 7) {
1958                 howMany3s += 1;
1959                 for (uint256 eachCol = 0; eachCol < all[eachRow].length; eachCol++) {
1960                     uint256 count = 0;
1961                     if (all[eachRow][eachCol] != 9999 && count <= 3) {
1962                         require(eachCol == factions.getFactions(uint256(all[eachRow][eachCol])), "SoftStakingMPH: The Hooligan mentioned does not match the faction given.");
1963                         unlock(addr, uint256(all[eachRow][eachCol]), 1);
1964                         count += 1;
1965                     } else if (all[eachRow][eachCol] != 9999) {
1966                         require(eachCol == factions.getFactions(uint256(all[eachRow][eachCol])), "SoftStakingMPH: The Hooligan mentioned does not match the faction given.");
1967                         unlock(addr, uint256(all[eachRow][eachCol]), 0);
1968                     }
1969                 }
1970             } else {
1971                 for (uint256 eachCol = 0; eachCol < all[eachRow].length; eachCol++) {
1972                     if (all[eachRow][eachCol] != 9999) {
1973                         require(eachCol == factions.getFactions(uint256(all[eachRow][eachCol])), "SoftStakingMPH: The Hooligan mentioned does not match the faction given.");
1974                         unlock(addr, uint256(all[eachRow][eachCol]), 0);
1975                     }
1976                 }
1977             }
1978         }
1979     }
1980 
1981     function applyProofOfPet(uint256 tokenId) public {
1982         require(officialContract.ownerOf(tokenId) == msg.sender, "SoftStakingMPH: You do not own this Hooligan.");
1983 
1984         if (block.timestamp.sub(_timeStart[tokenId]) >= proofOfPetPeriod && _owners[tokenId] == msg.sender) {
1985             _proofOfPet[tokenId] = true;
1986             _applyProofOfPet[tokenId] = false;
1987             _proofOfPetOwner[tokenId] = msg.sender;
1988         } else {
1989             _applyProofOfPet[tokenId] = true;
1990             _proofOfPetOwner[tokenId] = msg.sender;
1991         }
1992     }
1993 
1994     function setProofOfPetPeriod(uint256 period) public onlyOwner {
1995         proofOfPetPeriod = period;
1996     }
1997 
1998     function endInitialProofOfPetActivationPeriod() public onlyOwner {
1999         proofOfPetInitialActivation = false;
2000     }
2001 
2002     function approveProofOfPet(uint256 tokenId, address addr) public {
2003         require(_validators[msg.sender] == true, "SoftStakingMPH: Not a valid validator.");
2004         require(officialContract.ownerOf(tokenId) == addr, "SoftStakingMPH: The address does not own this Hooligan.");
2005         require(_proofOfPetOwner[tokenId] == addr, "SoftStakingMPH: The address did not apply for Proof Of Pet.");
2006         require(_applyProofOfPet[tokenId] == true, "SoftStakingMPH: The Hooligan was not applied for Proof Of Pet validation.");
2007         _proofOfPet[tokenId] = true;
2008         _applyProofOfPet[tokenId] = false;
2009     }
2010 
2011     function approveProofOfPetInitial(uint256[] calldata tokenIds, address[] calldata addr) public onlyOwner {
2012         require(_validators[msg.sender] == true, "SoftStakingMPH: Not a valid validator.");
2013         require(proofOfPetInitialActivation == true, "SoftStakingMPH: This function has been discarded.");
2014         for (uint256 index = 0; index < tokenIds.length; index++) {
2015             require(officialContract.ownerOf(tokenIds[index]) == addr[index], "SoftStakingMPH: The address does not own this Hooligan.");
2016             _proofOfPet[tokenIds[index]] = true;
2017             _applyProofOfPet[tokenIds[index]] = false;
2018             _proofOfPetOwner[tokenIds[index]] = addr[index];
2019         }
2020     }
2021 
2022     function showApplicationOfProofOfPet(uint256 tokenId) public view returns (bool) {
2023         return _applyProofOfPet[tokenId];
2024     }
2025 
2026     function showProofOfPet(uint256 tokenId) public view returns (bool) {
2027         return _proofOfPet[tokenId];
2028     }
2029 
2030     function showProofOfPetOwner(uint256 tokenId) public view returns (address) {
2031         return _proofOfPetOwner[tokenId];
2032     }
2033 
2034     function toggleValidator(address addr) public onlyOwner {
2035         if (_validators[addr]) {
2036             _validators[addr] = false;
2037         } else {
2038             _validators[addr] = true;
2039         }
2040     }
2041 
2042 }
2043 
2044 
2045 
2046 contract MPHSoftStakingValidatorV2 is Ownable, ReentrancyGuard {
2047     using SafeMath for uint256;
2048 
2049     uint256 public totalSupply = 150000000000000000000000000;
2050 
2051 	mapping (address => bool) public _validators;
2052 
2053     // Mapping from token ID to owner address
2054     mapping(uint256 => address) private _owners;
2055 
2056     // Mapping token ID to total time
2057     mapping(uint256 => uint256) private _totalTime;
2058 
2059     // Mapping token ID to total balance
2060     mapping(uint256 => uint256) private _balance;
2061 
2062     // Mapping token ID to timestamp
2063     mapping(uint256 => uint256) private _time;
2064 
2065     // Mapping token ID to timestamp
2066     mapping(uint256 => uint256) public _timeStart;
2067 
2068     // Mapping token ID to ProofOfPet
2069     mapping(uint256 => bool) private _proofOfPet;
2070 
2071     // Mapping token ID to Migration
2072     mapping(uint256 => bool) public _migrated;
2073 
2074     // Mapping token ID to ProofOfPet
2075     mapping(uint256 => address) private _proofOfPetOwner;
2076 
2077     uint256 public proofOfPetPeriod = 15780000;
2078 
2079     // Mapping token ID to application of ProofOfPet
2080     mapping(uint256 => bool) private _applyProofOfPet;
2081 
2082     Factions factions = Factions(0xaf66FcffE806049B82208594868BCEE18201c08a);
2083 
2084     bool killed = false;
2085     bool proofOfPetInitialActivation = true;
2086 
2087     uint256 public cooldownPeriod = 0;
2088 
2089     ERC721Enumerable officialContract = ERC721Enumerable(0x09233d553058c2F42ba751C87816a8E9FaE7Ef10);
2090 
2091     SoftStakingMPHOLD oldSofty = SoftStakingMPHOLD(0x034B7071a1096DBb392b3F9326950BD4aE72D91a);
2092 
2093     MPHSoftStakingValidator oldSoftyV2 = MPHSoftStakingValidator(0x67BA6b9fe26C6459e9C5D7799D6a0bc4280a25bf);
2094 
2095     function softStake(uint256[] calldata tokenIds) public nonReentrant {
2096 
2097         for (uint256 index = 0; index < tokenIds.length; index++) {
2098             require(officialContract.ownerOf(tokenIds[index]) == msg.sender, "SoftStakingMPH: You don't own that token.");
2099             
2100             importPreviousData(tokenIds[index], msg.sender);
2101 
2102             _time[tokenIds[index]] = block.timestamp;
2103             _timeStart[tokenIds[index]] = block.timestamp;
2104             _owners[tokenIds[index]] = msg.sender;
2105         }
2106     }
2107 
2108     function useFromToken(address addr, uint256 tokenId, uint256 amount) public nonReentrant {
2109 
2110         importPreviousData(tokenId, addr);
2111 
2112         require(_validators[msg.sender] == true, "SoftStakingMPH: Not a valid validator.");
2113         require(_balance[tokenId] >= amount, "SoftStakingMPH: You don't own that token.");
2114         require(officialContract.ownerOf(tokenId) == addr, "SoftStakingMPH: The holder does not own this hooligan.");
2115         
2116         _balance[tokenId] = _balance[tokenId].sub(amount);
2117     }
2118 
2119     function addToToken(address addr, uint256 tokenId, uint256 amount) public nonReentrant {
2120 
2121         importPreviousData(tokenId, addr);
2122 
2123         require(_validators[msg.sender] == true, "SoftStakingMPH: Not a valid validator.");
2124         require(officialContract.ownerOf(tokenId) == addr, "SoftStakingMPH: The holder does not own this hooligan.");
2125         require(totalSupply >= amount, "SoftStakingMPH: Not enough in the supply.");
2126         
2127         totalSupply = totalSupply.sub(amount);
2128         _balance[tokenId] = _balance[tokenId].add(amount);
2129     }
2130 
2131     function isStakedBy(uint256 tokenId, address addr) public view returns (bool) {
2132         bool temp = false;
2133         if (_time[tokenId] > 0 && _owners[tokenId] == addr) {
2134             temp = true;
2135         }
2136         return temp;
2137     }
2138 
2139     function time(uint256 tokenId) public view returns (uint256) {
2140         return _time[tokenId];
2141     }
2142 
2143     function stakeOwnerOf(uint256 tokenId) public view returns (address) {
2144         return _owners[tokenId];
2145     }
2146 
2147     function changeCooldownPeriod(uint256 newPeriod) public onlyOwner {
2148         cooldownPeriod = newPeriod;
2149     }
2150 
2151     function balance(address addr) public view returns (uint256) {
2152         uint256[] memory hoolis = officialContract.walletOfOwner(addr);
2153         uint256 total = 0;
2154         for (uint256 hooli = 0; hooli < hoolis.length; hooli++) {
2155             total = total.add(_balance[hoolis[hooli]]);
2156         }
2157         return total;
2158     }
2159 
2160     function balanceOfToken(uint256 tokenId) public view returns (uint256) {
2161         return _balance[tokenId];
2162     }
2163 
2164     function unSoftStake(uint256[] calldata tokenIds) public nonReentrant {
2165 
2166         for (uint256 tokenId = 0; tokenId < tokenIds.length; tokenId++) {
2167             require(officialContract.ownerOf(tokenIds[tokenId]) == msg.sender, "SoftStakingMPH: You don't own that token.");
2168             importPreviousData(tokenIds[tokenId], msg.sender);
2169             require(_time[tokenIds[tokenId]] != 0, "SoftStakingMPH: This token is not staked.");
2170 
2171             _totalTime[tokenIds[tokenId]] = _totalTime[tokenIds[tokenId]].add(block.timestamp.sub(_time[tokenIds[tokenId]]));
2172             _timeStart[tokenIds[tokenId]] = block.timestamp;
2173             _time[tokenIds[tokenId]] = 0;
2174         }
2175     }
2176 
2177     function unSoftStakeWith(uint256[] calldata tokenIds, uint16[7][] memory all) public {
2178 
2179         allFaction(msg.sender, all);
2180 
2181         for (uint256 tokenId = 0; tokenId < tokenIds.length; tokenId++) {
2182             require(officialContract.ownerOf(tokenIds[tokenId]) == msg.sender, "SoftStakingMPH: You don't own that token.");
2183             require(_time[tokenIds[tokenId]] != 0, "SoftStakingMPH: This token is not staked.");
2184 
2185             _totalTime[tokenIds[tokenId]] = _totalTime[tokenIds[tokenId]].add(block.timestamp.sub(_time[tokenIds[tokenId]]));
2186             _timeStart[tokenIds[tokenId]] = block.timestamp;
2187             _time[tokenIds[tokenId]] = 0;
2188         }
2189     }
2190 
2191     function killIt() public onlyOwner {
2192         killed = true;
2193     }
2194 
2195     function importPreviousData(uint tokenId, address addr) internal {
2196         
2197         if (_migrated[tokenId] == false) {
2198             if (oldSoftyV2._migrated(tokenId) == true) {
2199                 _balance[tokenId] = _balance[tokenId].add(oldSoftyV2.balanceOfToken(tokenId));
2200                 totalSupply = totalSupply.sub(oldSoftyV2.balanceOfToken(tokenId));
2201 
2202                 _time[tokenId] = oldSoftyV2.time(tokenId);
2203                 _timeStart[tokenId] = oldSoftyV2._timeStart(tokenId);
2204                 _owners[tokenId] = addr;
2205                 _migrated[tokenId] = true;
2206             } else {
2207                 
2208                 _balance[tokenId] = _balance[tokenId].add(oldSofty.balanceOfToken(tokenId));
2209                 totalSupply = totalSupply.sub(oldSofty.balanceOfToken(tokenId));
2210 
2211                 _time[tokenId] = oldSofty.time(tokenId);
2212                 _timeStart[tokenId] = oldSofty.time(tokenId);
2213                 _owners[tokenId] = addr;
2214                 _migrated[tokenId] = true;
2215             }
2216         }
2217 
2218     }
2219 
2220     function unlock(address addr, uint tokenId, uint256 level) internal {
2221         require(killed == false, "SoftStakingMPH: Switched to Karrots.");
2222         require(officialContract.ownerOf(tokenId) == addr, "SoftStakingMPH: You don't own that token.");
2223         importPreviousData(tokenId, addr);
2224         require(_owners[tokenId] == addr, "SoftStakingMPH: You are not the staker of this Hooligan.");
2225         require(_time[tokenId] != 0, "SoftStakingMPH: Hooligan not staked.");
2226         require(block.timestamp.sub(_time[tokenId]) > cooldownPeriod, "SoftStakingMPH: Hooligan still in cooldown.");
2227 
2228         uint256 amount = 0;
2229 
2230         if (level == 0) {
2231             if (_proofOfPet[tokenId] == true && _proofOfPetOwner[tokenId] == addr) {
2232                 amount = (block.timestamp.sub(_time[tokenId])).mul(1000000000000000000).div(8640).div(10).mul(13);
2233                 _balance[tokenId] = _balance[tokenId].add(amount);
2234                 require(totalSupply >= amount, "SoftStakingMPH: There is no more tokens in the allocation to mint from.");
2235                 totalSupply = totalSupply.sub(amount);
2236             } else {
2237                 amount = (block.timestamp.sub(_time[tokenId])).mul(1000000000000000000).div(8640);
2238                 _balance[tokenId] = _balance[tokenId].add(amount);
2239                 require(totalSupply >= amount, "SoftStakingMPH: There is no more tokens in the allocation to mint from.");
2240                 totalSupply = totalSupply.sub(amount);
2241             }
2242         } else if (level == 1) {
2243             if (_proofOfPet[tokenId] == true && _proofOfPetOwner[tokenId] == addr) {
2244                 amount = (block.timestamp.sub(_time[tokenId])).mul(1000000000000000000).div(8640).div(10).mul(13);
2245                 _balance[tokenId] = _balance[tokenId].add(amount);
2246                 require(totalSupply >= amount, "SoftStakingMPH: There is no more tokens in the allocation to mint from.");
2247                 totalSupply = totalSupply.sub(amount);
2248             } else {
2249                 amount = (block.timestamp.sub(_time[tokenId])).mul(1000000000000000000).div(8640).div(10).mul(12);
2250                 _balance[tokenId] = _balance[tokenId].add(amount);
2251                 require(totalSupply >= amount, "SoftStakingMPH: There is no more tokens in the allocation to mint from.");
2252                 totalSupply = totalSupply.sub(amount);
2253             }
2254         } else if (level == 2) {
2255             amount = (block.timestamp.sub(_time[tokenId]).mul(1000000000000000000).div(8640)).div(10).mul(15);
2256             _balance[tokenId] = _balance[tokenId].add(amount);
2257             require(totalSupply >= amount, "SoftStakingMPH: There is no more tokens in the allocation to mint from.");
2258             totalSupply = totalSupply.sub(amount);
2259         }
2260         _totalTime[tokenId] = _totalTime[tokenId].add(block.timestamp.sub(_time[tokenId]));
2261         _time[tokenId] = block.timestamp;
2262     }
2263 
2264     function allFaction(uint16[7][] memory all) public {
2265 
2266         allFaction(msg.sender, all);
2267     }
2268 
2269     function allFaction(address addr, uint16[7][] memory all) internal {
2270 
2271         uint256 howMany7s = 0;
2272 
2273         for (uint256 eachRow = 0; eachRow < all.length; eachRow++) {
2274             bool isA7 = true;
2275             for (uint256 eachCol = 0; eachCol < all[eachRow].length; eachCol++) {
2276                 if (all[eachRow][eachCol] == 9999) {
2277                     isA7 = false;
2278                 }
2279             }
2280             if (isA7) {
2281                 howMany7s += 1;
2282                 for (uint256 eachCol = 0; eachCol < all[eachRow].length; eachCol++) {
2283                     
2284                     require(eachCol == factions.getFactions(uint256(all[eachRow][eachCol])), "SoftStakingMPH: The Hooligan mentioned does not match the faction given.");
2285                     unlock(addr, uint256(all[eachRow][eachCol]), 2);
2286                 }
2287             }
2288         }
2289 
2290         uint256 howMany3s = 0;
2291 
2292         for (uint256 eachRow = 0; eachRow < all.length; eachRow++) {
2293             uint256 howManyInARow = 0;
2294             for (uint256 eachCol = 0; eachCol < all[eachRow].length; eachCol++) {
2295                 if (all[eachRow][eachCol] != 9999) {
2296                     howManyInARow += 1;
2297                 }
2298             }
2299             if (howManyInARow >= 3 && howManyInARow < 7) {
2300                 howMany3s += 1;
2301                 for (uint256 eachCol = 0; eachCol < all[eachRow].length; eachCol++) {
2302                     uint256 count = 0;
2303                     if (all[eachRow][eachCol] != 9999 && count <= 3) {
2304                         require(eachCol == factions.getFactions(uint256(all[eachRow][eachCol])), "SoftStakingMPH: The Hooligan mentioned does not match the faction given.");
2305                         unlock(addr, uint256(all[eachRow][eachCol]), 1);
2306                         count += 1;
2307                     } else if (all[eachRow][eachCol] != 9999) {
2308                         require(eachCol == factions.getFactions(uint256(all[eachRow][eachCol])), "SoftStakingMPH: The Hooligan mentioned does not match the faction given.");
2309                         unlock(addr, uint256(all[eachRow][eachCol]), 0);
2310                     }
2311                 }
2312             } else if (howManyInARow != 7) {
2313                 for (uint256 eachCol = 0; eachCol < all[eachRow].length; eachCol++) {
2314                     if (all[eachRow][eachCol] != 9999) {
2315                         require(eachCol == factions.getFactions(uint256(all[eachRow][eachCol])), "SoftStakingMPH: The Hooligan mentioned does not match the faction given.");
2316                         unlock(addr, uint256(all[eachRow][eachCol]), 0);
2317                     }
2318                 }
2319             }
2320         }
2321     }
2322 
2323     function applyProofOfPet(uint256 tokenId) public {
2324         require(officialContract.ownerOf(tokenId) == msg.sender, "SoftStakingMPH: You do not own this Hooligan.");
2325 
2326         if (block.timestamp.sub(_timeStart[tokenId]) >= proofOfPetPeriod && _owners[tokenId] == msg.sender) {
2327             _proofOfPet[tokenId] = true;
2328             _applyProofOfPet[tokenId] = false;
2329             _proofOfPetOwner[tokenId] = msg.sender;
2330         } else {
2331             _applyProofOfPet[tokenId] = true;
2332             _proofOfPetOwner[tokenId] = msg.sender;
2333         }
2334     }
2335 
2336     function setProofOfPetPeriod(uint256 period) public onlyOwner {
2337         proofOfPetPeriod = period;
2338     }
2339 
2340     function endInitialProofOfPetActivationPeriod() public onlyOwner {
2341         proofOfPetInitialActivation = false;
2342     }
2343 
2344     function approveProofOfPet(uint256 tokenId, address addr) public {
2345         require(_validators[msg.sender] == true, "SoftStakingMPH: Not a valid validator.");
2346         require(officialContract.ownerOf(tokenId) == addr, "SoftStakingMPH: The address does not own this Hooligan.");
2347         require(_proofOfPetOwner[tokenId] == addr, "SoftStakingMPH: The address did not apply for Proof Of Pet.");
2348         require(_applyProofOfPet[tokenId] == true, "SoftStakingMPH: The Hooligan was not applied for Proof Of Pet validation.");
2349         _proofOfPet[tokenId] = true;
2350         _applyProofOfPet[tokenId] = false;
2351     }
2352 
2353     function approveProofOfPetInitial(uint256[] calldata tokenIds, address[] calldata addr) public onlyOwner {
2354         require(_validators[msg.sender] == true, "SoftStakingMPH: Not a valid validator.");
2355         require(proofOfPetInitialActivation == true, "SoftStakingMPH: This function has been discarded.");
2356         for (uint256 index = 0; index < tokenIds.length; index++) {
2357             require(officialContract.ownerOf(tokenIds[index]) == addr[index], "SoftStakingMPH: The address does not own this Hooligan.");
2358             _proofOfPet[tokenIds[index]] = true;
2359             _applyProofOfPet[tokenIds[index]] = false;
2360             _proofOfPetOwner[tokenIds[index]] = addr[index];
2361         }
2362     }
2363 
2364     function showApplicationOfProofOfPet(uint256 tokenId) public view returns (bool) {
2365         return _applyProofOfPet[tokenId];
2366     }
2367 
2368     function showProofOfPet(uint256 tokenId) public view returns (bool) {
2369         return _proofOfPet[tokenId];
2370     }
2371 
2372     function showProofOfPetOwner(uint256 tokenId) public view returns (address) {
2373         return _proofOfPetOwner[tokenId];
2374     }
2375 
2376     function toggleValidator(address addr) public onlyOwner {
2377         if (_validators[addr]) {
2378             _validators[addr] = false;
2379         } else {
2380             _validators[addr] = true;
2381         }
2382     }
2383 
2384 }
2385 
2386 contract Factions {
2387     uint8[] public factions;
2388 
2389     function getFactions(uint256 number) public view returns (uint256) {
2390         return factions[number];
2391     }
2392 
2393     function addFactions(uint8[] memory numbers) public {
2394         for (uint256 x = 0; x < numbers.length; x++) {
2395             factions.push(numbers[x]);
2396         }
2397     }
2398 
2399 }
2400 
2401 // Developed with <3 by Bleiserman for My Pet Hooligan