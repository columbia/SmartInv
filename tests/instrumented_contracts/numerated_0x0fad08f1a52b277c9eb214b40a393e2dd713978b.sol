1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-03
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
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
167     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         unchecked {
169             require(b <= a, errorMessage);
170             return a - b;
171         }
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `%` operator. This function uses a `revert`
179      * opcode (which leaves remaining gas untouched) while Solidity uses an
180      * invalid opcode to revert (consuming all remaining gas).
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         unchecked {
192             require(b > 0, errorMessage);
193             return a / b;
194         }
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * reverting with custom message when dividing by zero.
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {tryMod}.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         unchecked {
214             require(b > 0, errorMessage);
215             return a % b;
216         }
217     }
218 }
219 
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev String operations.
225  */
226 library Strings {
227     bytes16 private constant alphabet = "0123456789abcdef";
228 
229     /**
230      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
231      */
232     function toString(uint256 value) internal pure returns (string memory) {
233         // Inspired by OraclizeAPI's implementation - MIT licence
234         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
235 
236         if (value == 0) {
237             return "0";
238         }
239         uint256 temp = value;
240         uint256 digits;
241         while (temp != 0) {
242             digits++;
243             temp /= 10;
244         }
245         bytes memory buffer = new bytes(digits);
246         while (value != 0) {
247             digits -= 1;
248             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
249             value /= 10;
250         }
251         return string(buffer);
252     }
253 
254     /**
255      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
256      */
257     function toHexString(uint256 value) internal pure returns (string memory) {
258         if (value == 0) {
259             return "0x00";
260         }
261         uint256 temp = value;
262         uint256 length = 0;
263         while (temp != 0) {
264             length++;
265             temp >>= 8;
266         }
267         return toHexString(value, length);
268     }
269 
270     /**
271      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
272      */
273     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
274         bytes memory buffer = new bytes(2 * length + 2);
275         buffer[0] = "0";
276         buffer[1] = "x";
277         for (uint256 i = 2 * length + 1; i > 1; --i) {
278             buffer[i] = alphabet[value & 0xf];
279             value >>= 4;
280         }
281         require(value == 0, "Strings: hex length insufficient");
282         return string(buffer);
283     }
284 
285 }
286 
287 pragma solidity ^0.8.0;
288 
289 /**
290  * @dev Collection of functions related to the address type
291  */
292 library Address {
293     /**
294      * @dev Returns true if `account` is a contract.
295      *
296      * [IMPORTANT]
297      * ====
298      * It is unsafe to assume that an address for which this function returns
299      * false is an externally-owned account (EOA) and not a contract.
300      *
301      * Among others, `isContract` will return false for the following
302      * types of addresses:
303      *
304      *  - an externally-owned account
305      *  - a contract in construction
306      *  - an address where a contract will be created
307      *  - an address where a contract lived, but was destroyed
308      * ====
309      */
310     function isContract(address account) internal view returns (bool) {
311         // This method relies on extcodesize, which returns 0 for contracts in
312         // construction, since the code is only stored at the end of the
313         // constructor execution.
314 
315         uint256 size;
316         // solhint-disable-next-line no-inline-assembly
317         assembly { size := extcodesize(account) }
318         return size > 0;
319     }
320 
321     /**
322      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
323      * `recipient`, forwarding all available gas and reverting on errors.
324      *
325      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
326      * of certain opcodes, possibly making contracts go over the 2300 gas limit
327      * imposed by `transfer`, making them unable to receive funds via
328      * `transfer`. {sendValue} removes this limitation.
329      *
330      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
331      *
332      * IMPORTANT: because control is transferred to `recipient`, care must be
333      * taken to not create reentrancy vulnerabilities. Consider using
334      * {ReentrancyGuard} or the
335      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
336      */
337     function sendValue(address payable recipient, uint256 amount) internal {
338         require(address(this).balance >= amount, "Address: insufficient balance");
339 
340         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
341         (bool success, ) = recipient.call{ value: amount }("");
342         require(success, "Address: unable to send value, recipient may have reverted");
343     }
344 
345     /**
346      * @dev Performs a Solidity function call using a low level `call`. A
347      * plain`call` is an unsafe replacement for a function call: use this
348      * function instead.
349      *
350      * If `target` reverts with a revert reason, it is bubbled up by this
351      * function (like regular Solidity function calls).
352      *
353      * Returns the raw returned data. To convert to the expected return value,
354      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
355      *
356      * Requirements:
357      *
358      * - `target` must be a contract.
359      * - calling `target` with `data` must not revert.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
364       return functionCall(target, data, "Address: low-level call failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
369      * `errorMessage` as a fallback revert reason when `target` reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
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
388     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
389         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
394      * with `errorMessage` as a fallback revert reason when `target` reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
399         require(address(this).balance >= value, "Address: insufficient balance for call");
400         require(isContract(target), "Address: call to non-contract");
401 
402         // solhint-disable-next-line avoid-low-level-calls
403         (bool success, bytes memory returndata) = target.call{ value: value }(data);
404         return _verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but performing a static call.
410      *
411      * _Available since v3.3._
412      */
413     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
414         return functionStaticCall(target, data, "Address: low-level static call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
419      * but performing a static call.
420      *
421      * _Available since v3.3._
422      */
423     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
424         require(isContract(target), "Address: static call to non-contract");
425 
426         // solhint-disable-next-line avoid-low-level-calls
427         (bool success, bytes memory returndata) = target.staticcall(data);
428         return _verifyCallResult(success, returndata, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but performing a delegate call.
434      *
435      * _Available since v3.4._
436      */
437     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
438         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
443      * but performing a delegate call.
444      *
445      * _Available since v3.4._
446      */
447     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
448         require(isContract(target), "Address: delegate call to non-contract");
449 
450         // solhint-disable-next-line avoid-low-level-calls
451         (bool success, bytes memory returndata) = target.delegatecall(data);
452         return _verifyCallResult(success, returndata, errorMessage);
453     }
454 
455     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
456         if (success) {
457             return returndata;
458         } else {
459             // Look for revert reason and bubble it up if present
460             if (returndata.length > 0) {
461                 // The easiest way to bubble the revert reason is using memory via assembly
462 
463                 // solhint-disable-next-line no-inline-assembly
464                 assembly {
465                     let returndata_size := mload(returndata)
466                     revert(add(32, returndata), returndata_size)
467                 }
468             } else {
469                 revert(errorMessage);
470             }
471         }
472     }
473 }
474 
475 pragma solidity ^0.8.0;
476 
477 /**
478  * @title ERC721 token receiver interface
479  * @dev Interface for any contract that wants to support safeTransfers
480  * from ERC721 asset contracts.
481  */
482 interface IERC721Receiver {
483     /**
484      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
485      * by `operator` from `from`, this function is called.
486      *
487      * It must return its Solidity selector to confirm the token transfer.
488      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
489      *
490      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
491      */
492     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
493 }
494 
495 pragma solidity ^0.8.0;
496 
497 /**
498  * @dev Interface of the ERC165 standard, as defined in the
499  * https://eips.ethereum.org/EIPS/eip-165[EIP].
500  *
501  * Implementers can declare support of contract interfaces, which can then be
502  * queried by others ({ERC165Checker}).
503  *
504  * For an implementation, see {ERC165}.
505  */
506 interface IERC165 {
507     /**
508      * @dev Returns true if this contract implements the interface defined by
509      * `interfaceId`. See the corresponding
510      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
511      * to learn more about how these ids are created.
512      *
513      * This function call must use less than 30 000 gas.
514      */
515     function supportsInterface(bytes4 interfaceId) external view returns (bool);
516 }
517 
518 
519 pragma solidity ^0.8.0;
520 
521 /**
522  * @dev Implementation of the {IERC165} interface.
523  *
524  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
525  * for the additional interface id that will be supported. For example:
526  *
527  * ```solidity
528  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
529  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
530  * }
531  * ```
532  *
533  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
534  */
535 abstract contract ERC165 is IERC165 {
536     /**
537      * @dev See {IERC165-supportsInterface}.
538      */
539     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
540         return interfaceId == type(IERC165).interfaceId;
541     }
542 }
543 
544 
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @dev Required interface of an ERC721 compliant contract.
549  */
550 interface IERC721 is IERC165 {
551     /**
552      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
553      */
554     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
555 
556     /**
557      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
558      */
559     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
560 
561     /**
562      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
563      */
564     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
565 
566     /**
567      * @dev Returns the number of tokens in ``owner``'s account.
568      */
569     function balanceOf(address owner) external view returns (uint256 balance);
570 
571     /**
572      * @dev Returns the owner of the `tokenId` token.
573      *
574      * Requirements:
575      *
576      * - `tokenId` must exist.
577      */
578     function ownerOf(uint256 tokenId) external view returns (address owner);
579 
580     /**
581      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
582      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
583      *
584      * Requirements:
585      *
586      * - `from` cannot be the zero address.
587      * - `to` cannot be the zero address.
588      * - `tokenId` token must exist and be owned by `from`.
589      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
590      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
591      *
592      * Emits a {Transfer} event.
593      */
594     function safeTransferFrom(address from, address to, uint256 tokenId) external;
595 
596     /**
597      * @dev Transfers `tokenId` token from `from` to `to`.
598      *
599      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must be owned by `from`.
606      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
607      *
608      * Emits a {Transfer} event.
609      */
610     function transferFrom(address from, address to, uint256 tokenId) external;
611 
612     /**
613      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
614      * The approval is cleared when the token is transferred.
615      *
616      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
617      *
618      * Requirements:
619      *
620      * - The caller must own the token or be an approved operator.
621      * - `tokenId` must exist.
622      *
623      * Emits an {Approval} event.
624      */
625     function approve(address to, uint256 tokenId) external;
626 
627     /**
628      * @dev Returns the account approved for `tokenId` token.
629      *
630      * Requirements:
631      *
632      * - `tokenId` must exist.
633      */
634     function getApproved(uint256 tokenId) external view returns (address operator);
635 
636     /**
637      * @dev Approve or remove `operator` as an operator for the caller.
638      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
639      *
640      * Requirements:
641      *
642      * - The `operator` cannot be the caller.
643      *
644      * Emits an {ApprovalForAll} event.
645      */
646     function setApprovalForAll(address operator, bool _approved) external;
647 
648     /**
649      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
650      *
651      * See {setApprovalForAll}
652      */
653     function isApprovedForAll(address owner, address operator) external view returns (bool);
654 
655     /**
656       * @dev Safely transfers `tokenId` token from `from` to `to`.
657       *
658       * Requirements:
659       *
660       * - `from` cannot be the zero address.
661       * - `to` cannot be the zero address.
662       * - `tokenId` token must exist and be owned by `from`.
663       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
664       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
665       *
666       * Emits a {Transfer} event.
667       */
668     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
669 }
670 
671 pragma solidity ^0.8.0;
672 
673 /**
674  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
675  * @dev See https://eips.ethereum.org/EIPS/eip-721
676  */
677 interface IERC721Enumerable is IERC721 {
678 
679     /**
680      * @dev Returns the total amount of tokens stored by the contract.
681      */
682     function totalSupply() external view returns (uint256);
683 
684     /**
685      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
686      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
687      */
688     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
689 
690     /**
691      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
692      * Use along with {totalSupply} to enumerate all tokens.
693      */
694     function tokenByIndex(uint256 index) external view returns (uint256);
695 }
696 
697 pragma solidity ^0.8.0;
698 
699 /**
700  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
701  * @dev See https://eips.ethereum.org/EIPS/eip-721
702  */
703 interface IERC721Metadata is IERC721 {
704 
705     /**
706      * @dev Returns the token collection name.
707      */
708     function name() external view returns (string memory);
709 
710     /**
711      * @dev Returns the token collection symbol.
712      */
713     function symbol() external view returns (string memory);
714 
715     /**
716      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
717      */
718     function tokenURI(uint256 tokenId) external view returns (string memory);
719 }
720 
721 
722 
723 
724 pragma solidity ^0.8.0;
725 
726 /*
727  * @dev Provides information about the current execution context, including the
728  * sender of the transaction and its data. While these are generally available
729  * via msg.sender and msg.data, they should not be accessed in such a direct
730  * manner, since when dealing with meta-transactions the account sending and
731  * paying for execution may not be the actual sender (as far as an application
732  * is concerned).
733  *
734  * This contract is only required for intermediate, library-like contracts.
735  */
736 abstract contract Context {
737     function _msgSender() internal view virtual returns (address) {
738         return msg.sender;
739     }
740 
741     function _msgData() internal view virtual returns (bytes calldata) {
742         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
743         return msg.data;
744     }
745 }
746 
747 pragma solidity ^0.8.0;
748 
749 /**
750  * @dev Contract module which provides a basic access control mechanism, where
751  * there is an account (an owner) that can be granted exclusive access to
752  * specific functions.
753  *
754  * By default, the owner account will be the one that deploys the contract. This
755  * can later be changed with {transferOwnership}.
756  *
757  * This module is used through inheritance. It will make available the modifier
758  * `onlyOwner`, which can be applied to your functions to restrict their use to
759  * the owner.
760  */
761 abstract contract Ownable is Context {
762     address private _owner;
763 
764     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
765 
766     /**
767      * @dev Initializes the contract setting the deployer as the initial owner.
768      */
769     constructor () {
770         address msgSender = _msgSender();
771         _owner = msgSender;
772         emit OwnershipTransferred(address(0), msgSender);
773     }
774 
775     /**
776      * @dev Returns the address of the current owner.
777      */
778     function owner() public view virtual returns (address) {
779         return _owner;
780     }
781 
782     /**
783      * @dev Throws if called by any account other than the owner.
784      */
785     modifier onlyOwner() {
786         require(owner() == _msgSender(), "Ownable: caller is not the owner");
787         _;
788     }
789 
790     /**
791      * @dev Leaves the contract without owner. It will not be possible to call
792      * `onlyOwner` functions anymore. Can only be called by the current owner.
793      *
794      * NOTE: Renouncing ownership will leave the contract without an owner,
795      * thereby removing any functionality that is only available to the owner.
796      */
797     function renounceOwnership() public virtual onlyOwner {
798         emit OwnershipTransferred(_owner, address(0));
799         _owner = address(0);
800     }
801 
802     /**
803      * @dev Transfers ownership of the contract to a new account (`newOwner`).
804      * Can only be called by the current owner.
805      */
806     function transferOwnership(address newOwner) public virtual onlyOwner {
807         require(newOwner != address(0), "Ownable: new owner is the zero address");
808         emit OwnershipTransferred(_owner, newOwner);
809         _owner = newOwner;
810     }
811 }
812 
813 
814 pragma solidity ^0.8.0;
815 
816 /**
817  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
818  * the Metadata extension, but not including the Enumerable extension, which is available separately as
819  * {ERC721Enumerable}.
820  */
821 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
822     using Address for address;
823     using Strings for uint256;
824 
825     // Token name
826     string private _name;
827 
828     // Token symbol
829     string private _symbol;
830 
831     // Mapping from token ID to owner address
832     mapping (uint256 => address) private _owners;
833 
834     // Mapping owner address to token count
835     mapping (address => uint256) private _balances;
836 
837     // Mapping from token ID to approved address
838     mapping (uint256 => address) private _tokenApprovals;
839 
840     // Mapping from owner to operator approvals
841     mapping (address => mapping (address => bool)) private _operatorApprovals;
842 
843     /**
844      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
845      */
846     constructor (string memory name_, string memory symbol_) {
847         _name = name_;
848         _symbol = symbol_;
849     }
850 
851     /**
852      * @dev See {IERC165-supportsInterface}.
853      */
854     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
855         return interfaceId == type(IERC721).interfaceId
856             || interfaceId == type(IERC721Metadata).interfaceId
857             || super.supportsInterface(interfaceId);
858     }
859 
860     /**
861      * @dev See {IERC721-balanceOf}.
862      */
863     function balanceOf(address owner) public view virtual override returns (uint256) {
864         require(owner != address(0), "ERC721: balance query for the zero address");
865         return _balances[owner];
866     }
867 
868     /**
869      * @dev See {IERC721-ownerOf}.
870      */
871     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
872         address owner = _owners[tokenId];
873         require(owner != address(0), "ERC721: owner query for nonexistent token");
874         return owner;
875     }
876 
877     /**
878      * @dev See {IERC721Metadata-name}.
879      */
880     function name() public view virtual override returns (string memory) {
881         return _name;
882     }
883 
884     /**
885      * @dev See {IERC721Metadata-symbol}.
886      */
887     function symbol() public view virtual override returns (string memory) {
888         return _symbol;
889     }
890 
891     /**
892      * @dev See {IERC721Metadata-tokenURI}.
893      */
894     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
895         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
896 
897         string memory baseURI = _baseURI();
898         return bytes(baseURI).length > 0
899             ? string(abi.encodePacked(baseURI, tokenId.toString(),".json"))
900             : '';
901     }
902 
903     /**
904      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
905      * in child contracts.
906      */
907     function _baseURI() internal view virtual returns (string memory) {
908         return "";
909     }
910 
911     /**
912      * @dev See {IERC721-approve}.
913      */
914     function approve(address to, uint256 tokenId) public virtual override {
915         address owner = ERC721.ownerOf(tokenId);
916         require(to != owner, "ERC721: approval to current owner");
917 
918         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
919             "ERC721: approve caller is not owner nor approved for all"
920         );
921 
922         _approve(to, tokenId);
923     }
924 
925     /**
926      * @dev See {IERC721-getApproved}.
927      */
928     function getApproved(uint256 tokenId) public view virtual override returns (address) {
929         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
930 
931         return _tokenApprovals[tokenId];
932     }
933 
934     /**
935      * @dev See {IERC721-setApprovalForAll}.
936      */
937     function setApprovalForAll(address operator, bool approved) public virtual override {
938         require(operator != _msgSender(), "ERC721: approve to caller");
939 
940         _operatorApprovals[_msgSender()][operator] = approved;
941         emit ApprovalForAll(_msgSender(), operator, approved);
942     }
943 
944     /**
945      * @dev See {IERC721-isApprovedForAll}.
946      */
947     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
948         return _operatorApprovals[owner][operator];
949     }
950 
951     /**
952      * @dev See {IERC721-transferFrom}.
953      */
954     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
955         //solhint-disable-next-line max-line-length
956         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
957 
958         _transfer(from, to, tokenId);
959     }
960 
961     /**
962      * @dev See {IERC721-safeTransferFrom}.
963      */
964     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
965         safeTransferFrom(from, to, tokenId, "");
966     }
967 
968     /**
969      * @dev See {IERC721-safeTransferFrom}.
970      */
971     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
972         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
973         _safeTransfer(from, to, tokenId, _data);
974     }
975 
976     /**
977      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
978      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
979      *
980      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
981      *
982      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
983      * implement alternative mechanisms to perform token transfer, such as signature-based.
984      *
985      * Requirements:
986      *
987      * - `from` cannot be the zero address.
988      * - `to` cannot be the zero address.
989      * - `tokenId` token must exist and be owned by `from`.
990      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
991      *
992      * Emits a {Transfer} event.
993      */
994     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
995         _transfer(from, to, tokenId);
996         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
997     }
998 
999     /**
1000      * @dev Returns whether `tokenId` exists.
1001      *
1002      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1003      *
1004      * Tokens start existing when they are minted (`_mint`),
1005      * and stop existing when they are burned (`_burn`).
1006      */
1007     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1008         return _owners[tokenId] != address(0);
1009     }
1010 
1011     /**
1012      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1013      *
1014      * Requirements:
1015      *
1016      * - `tokenId` must exist.
1017      */
1018     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1019         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1020         address owner = ERC721.ownerOf(tokenId);
1021         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1022     }
1023 
1024     /**
1025      * @dev Safely mints `tokenId` and transfers it to `to`.
1026      *
1027      * Requirements:
1028      *
1029      * - `tokenId` must not exist.
1030      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1031      *
1032      * Emits a {Transfer} event.
1033      */
1034     function _safeMint(address to, uint256 tokenId) internal virtual {
1035         _safeMint(to, tokenId, "");
1036     }
1037 
1038     /**
1039      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1040      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1041      */
1042     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1043         _mint(to, tokenId);
1044         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1045     }
1046 
1047     /**
1048      * @dev Mints `tokenId` and transfers it to `to`.
1049      *
1050      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1051      *
1052      * Requirements:
1053      *
1054      * - `tokenId` must not exist.
1055      * - `to` cannot be the zero address.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _mint(address to, uint256 tokenId) internal virtual {
1060         require(to != address(0), "ERC721: mint to the zero address");
1061         require(!_exists(tokenId), "ERC721: token already minted");
1062 
1063         _beforeTokenTransfer(address(0), to, tokenId);
1064 
1065         _balances[to] += 1;
1066         _owners[tokenId] = to;
1067 
1068         emit Transfer(address(0), to, tokenId);
1069     }
1070     /**
1071      * @dev Destroys `tokenId`.
1072      * The approval is cleared when the token is burned.
1073      *
1074      * Requirements:
1075      *
1076      * - `tokenId` must exist.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _burn(uint256 tokenId) internal virtual {
1081         address owner = ERC721.ownerOf(tokenId);
1082 
1083         _beforeTokenTransfer(owner, address(0), tokenId);
1084 
1085         // Clear approvals
1086         _approve(address(0), tokenId);
1087 
1088         _balances[owner] -= 1;
1089         delete _owners[tokenId];
1090 
1091         emit Transfer(owner, address(0), tokenId);
1092     }
1093 
1094     /**
1095      * @dev Transfers `tokenId` from `from` to `to`.
1096      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1097      *
1098      * Requirements:
1099      *
1100      * - `to` cannot be the zero address.
1101      * - `tokenId` token must be owned by `from`.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1106         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1107         require(to != address(0), "ERC721: transfer to the zero address");
1108 
1109         _beforeTokenTransfer(from, to, tokenId);
1110 
1111         // Clear approvals from the previous owner
1112         _approve(address(0), tokenId);
1113 
1114         _balances[from] -= 1;
1115         _balances[to] += 1;
1116         _owners[tokenId] = to;
1117 
1118         emit Transfer(from, to, tokenId);
1119     }
1120 
1121     /**
1122      * @dev Approve `to` to operate on `tokenId`
1123      *
1124      * Emits a {Approval} event.
1125      */
1126     function _approve(address to, uint256 tokenId) internal virtual {
1127         _tokenApprovals[tokenId] = to;
1128         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1129     }
1130 
1131     /**
1132      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1133      * The call is not executed if the target address is not a contract.
1134      *
1135      * @param from address representing the previous owner of the given token ID
1136      * @param to target address that will receive the tokens
1137      * @param tokenId uint256 ID of the token to be transferred
1138      * @param _data bytes optional data to send along with the call
1139      * @return bool whether the call correctly returned the expected magic value
1140      */
1141     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1142         private returns (bool)
1143     {
1144         if (to.isContract()) {
1145             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1146                 return retval == IERC721Receiver(to).onERC721Received.selector;
1147             } catch (bytes memory reason) {
1148                 if (reason.length == 0) {
1149                     revert("ERC721: transfer to non ERC721Receiver implementer");
1150                 } else {
1151                     // solhint-disable-next-line no-inline-assembly
1152                     assembly {
1153                         revert(add(32, reason), mload(reason))
1154                     }
1155                 }
1156             }
1157         } else {
1158             return true;
1159         }
1160     }
1161 
1162     /**
1163      * @dev Hook that is called before any token transfer. This includes minting
1164      * and burning.
1165      *
1166      * Calling conditions:
1167      *
1168      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1169      * transferred to `to`.
1170      * - When `from` is zero, `tokenId` will be minted for `to`.
1171      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1172      * - `from` cannot be the zero address.
1173      * - `to` cannot be the zero address.
1174      *
1175      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1176      */
1177     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1178 }
1179 
1180 pragma solidity ^0.8.0;
1181 
1182 /**
1183  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1184  * enumerability of all the token ids in the contract as well as all token ids owned by each
1185  * account.
1186  */
1187 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1188     // Mapping from owner to list of owned token IDs
1189     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1190 
1191     // Mapping from token ID to index of the owner tokens list
1192     mapping(uint256 => uint256) private _ownedTokensIndex;
1193 
1194     // Array with all token ids, used for enumeration
1195     uint256[] private _allTokens;
1196 
1197     // Mapping from token id to position in the allTokens array
1198     mapping(uint256 => uint256) private _allTokensIndex;
1199 
1200     /**
1201      * @dev See {IERC165-supportsInterface}.
1202      */
1203     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1204         return interfaceId == type(IERC721Enumerable).interfaceId
1205             || super.supportsInterface(interfaceId);
1206     }
1207 
1208     /**
1209      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1210      */
1211     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1212         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1213         return _ownedTokens[owner][index];
1214     }
1215 
1216     /**
1217      * @dev See {IERC721Enumerable-totalSupply}.
1218      */
1219     function totalSupply() public view virtual override returns (uint256) {
1220         return _allTokens.length;
1221     }
1222 
1223     /**
1224      * @dev See {IERC721Enumerable-tokenByIndex}.
1225      */
1226     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1227         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1228         return _allTokens[index];
1229     }
1230 
1231     /**
1232      * @dev Hook that is called before any token transfer. This includes minting
1233      * and burning.
1234      *
1235      * Calling conditions:
1236      *
1237      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1238      * transferred to `to`.
1239      * - When `from` is zero, `tokenId` will be minted for `to`.
1240      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1241      * - `from` cannot be the zero address.
1242      * - `to` cannot be the zero address.
1243      *
1244      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1245      */
1246     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1247         super._beforeTokenTransfer(from, to, tokenId);
1248 
1249         if (from == address(0)) {
1250             _addTokenToAllTokensEnumeration(tokenId);
1251         } else if (from != to) {
1252             _removeTokenFromOwnerEnumeration(from, tokenId);
1253         }
1254         if (to == address(0)) {
1255             _removeTokenFromAllTokensEnumeration(tokenId);
1256         } else if (to != from) {
1257             _addTokenToOwnerEnumeration(to, tokenId);
1258         }
1259     }
1260 
1261     /**
1262      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1263      * @param to address representing the new owner of the given token ID
1264      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1265      */
1266     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1267         uint256 length = ERC721.balanceOf(to);
1268         _ownedTokens[to][length] = tokenId;
1269         _ownedTokensIndex[tokenId] = length;
1270     }
1271 
1272     /**
1273      * @dev Private function to add a token to this extension's token tracking data structures.
1274      * @param tokenId uint256 ID of the token to be added to the tokens list
1275      */
1276     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1277         _allTokensIndex[tokenId] = _allTokens.length;
1278         _allTokens.push(tokenId);
1279     }
1280 
1281     /**
1282      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1283      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1284      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1285      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1286      * @param from address representing the previous owner of the given token ID
1287      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1288      */
1289     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1290         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1291         // then delete the last slot (swap and pop).
1292 
1293         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1294         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1295 
1296         // When the token to delete is the last token, the swap operation is unnecessary
1297         if (tokenIndex != lastTokenIndex) {
1298             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1299 
1300             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1301             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1302         }
1303 
1304         // This also deletes the contents at the last position of the array
1305         delete _ownedTokensIndex[tokenId];
1306         delete _ownedTokens[from][lastTokenIndex];
1307     }
1308 
1309     /**
1310      * @dev Private function to remove a token from this extension's token tracking data structures.
1311      * This has O(1) time complexity, but alters the order of the _allTokens array.
1312      * @param tokenId uint256 ID of the token to be removed from the tokens list
1313      */
1314     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1315         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1316         // then delete the last slot (swap and pop).
1317 
1318         uint256 lastTokenIndex = _allTokens.length - 1;
1319         uint256 tokenIndex = _allTokensIndex[tokenId];
1320 
1321         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1322         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1323         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1324         uint256 lastTokenId = _allTokens[lastTokenIndex];
1325 
1326         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1327         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1328 
1329         // This also deletes the contents at the last position of the array
1330         delete _allTokensIndex[tokenId];
1331         _allTokens.pop();
1332     }
1333 }
1334 
1335 pragma solidity ^0.8.0;
1336 
1337 
1338 contract CoolBoysExclusiveClub is ERC721Enumerable, Ownable {
1339     using SafeMath for uint256;
1340     using Address for address;
1341     using Strings for uint256;
1342 
1343 
1344     uint256 public MAX_SUPPLY = 10000;
1345     uint256 public price = 70000000000000000; // 0.07 ETH
1346     bool public saleIsActive = true;
1347     string private _baseURIExtended = "https://gateway.pinata.cloud/ipfs/QmRNv1GVboXpGh9zRv8uokpzN3cmKya2bvVKzXdRkZccxR/";
1348 
1349     constructor() ERC721("CoolBoysExclusiveClub","CBEC"){
1350         
1351     }
1352     function flipSaleState() public onlyOwner {
1353         saleIsActive = !saleIsActive;
1354     }
1355 
1356     function setprice(uint _price) public  onlyOwner{
1357         price = _price;
1358     }
1359 
1360     function mintCoolBoy(uint numberOfToken) public payable {
1361         require(saleIsActive, "Sale is not active at the moment");
1362         require(msg.value >= price * numberOfToken, "Ether value sent is not correct");      
1363         require(totalSupply().add(1).add(numberOfToken) <= MAX_SUPPLY, "Purchase would exceed max supply of CoolBoys");
1364         require(numberOfToken <= 5, "You have exceeded max CoolBoys limit per transaction");
1365         require(numberOfToken > 0, "Number of tokens can not be less than or equal to 0");
1366 
1367            for(uint i=0; i < numberOfToken; i++){
1368             _safeMint(msg.sender, totalSupply().add(1));
1369         }
1370         payable(owner()).transfer(address(this).balance);
1371     }
1372 
1373     function mintForAdmin(uint numberOfToken) public onlyOwner{
1374         require(totalSupply().add(1).add(numberOfToken) <= MAX_SUPPLY, "Purchase would exceed max supply of CoolBoys");
1375         require(numberOfToken <= 50, "You have exceeded max CoolBoys limit per transaction");
1376         require(numberOfToken > 0, "Number of tokens can not be less than or equal to 0");
1377         for(uint i=0; i < numberOfToken; i++){
1378             _safeMint(msg.sender, totalSupply().add(1));
1379         }
1380         payable(owner()).transfer(address(this).balance);
1381     }
1382     
1383     function _baseURI() internal view virtual override returns (string memory) {
1384         return _baseURIExtended;
1385     }
1386 
1387     function setBaseURI(string memory baseURI_) external onlyOwner {
1388         _baseURIExtended = baseURI_;
1389     }
1390 }