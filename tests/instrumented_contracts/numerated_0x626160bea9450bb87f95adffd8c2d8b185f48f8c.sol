1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-10
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-01-10
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
175     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
186      * Counterpart to Solidity's `%` operator. This function uses a `revert`
187      * opcode (which leaves remaining gas untouched) while Solidity uses an
188      * invalid opcode to revert (consuming all remaining gas).
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
220     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         unchecked {
222             require(b > 0, errorMessage);
223             return a % b;
224         }
225     }
226 }
227 
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @dev String operations.
233  */
234 library Strings {
235     bytes16 private constant alphabet = "0123456789abcdef";
236 
237     /**
238      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
239      */
240     function toString(uint256 value) internal pure returns (string memory) {
241         // Inspired by OraclizeAPI's implementation - MIT licence
242         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
243 
244         if (value == 0) {
245             return "0";
246         }
247         uint256 temp = value;
248         uint256 digits;
249         while (temp != 0) {
250             digits++;
251             temp /= 10;
252         }
253         bytes memory buffer = new bytes(digits);
254         while (value != 0) {
255             digits -= 1;
256             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
257             value /= 10;
258         }
259         return string(buffer);
260     }
261 
262     /**
263      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
264      */
265     function toHexString(uint256 value) internal pure returns (string memory) {
266         if (value == 0) {
267             return "0x00";
268         }
269         uint256 temp = value;
270         uint256 length = 0;
271         while (temp != 0) {
272             length++;
273             temp >>= 8;
274         }
275         return toHexString(value, length);
276     }
277 
278     /**
279      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
280      */
281     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
282         bytes memory buffer = new bytes(2 * length + 2);
283         buffer[0] = "0";
284         buffer[1] = "x";
285         for (uint256 i = 2 * length + 1; i > 1; --i) {
286             buffer[i] = alphabet[value & 0xf];
287             value >>= 4;
288         }
289         require(value == 0, "Strings: hex length insufficient");
290         return string(buffer);
291     }
292 
293 }
294 
295 pragma solidity ^0.8.0;
296 
297 /**
298  * @dev Collection of functions related to the address type
299  */
300 library Address {
301     /**
302      * @dev Returns true if `account` is a contract.
303      *
304      * [IMPORTANT]
305      * ====
306      * It is unsafe to assume that an address for which this function returns
307      * false is an externally-owned account (EOA) and not a contract.
308      *
309      * Among others, `isContract` will return false for the following
310      * types of addresses:
311      *
312      *  - an externally-owned account
313      *  - a contract in construction
314      *  - an address where a contract will be created
315      *  - an address where a contract lived, but was destroyed
316      * ====
317      */
318     function isContract(address account) internal view returns (bool) {
319         // This method relies on extcodesize, which returns 0 for contracts in
320         // construction, since the code is only stored at the end of the
321         // constructor execution.
322 
323         uint256 size;
324         // solhint-disable-next-line no-inline-assembly
325         assembly { size := extcodesize(account) }
326         return size > 0;
327     }
328 
329     /**
330      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
331      * `recipient`, forwarding all available gas and reverting on errors.
332      *
333      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
334      * of certain opcodes, possibly making contracts go over the 2300 gas limit
335      * imposed by `transfer`, making them unable to receive funds via
336      * `transfer`. {sendValue} removes this limitation.
337      *
338      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
339      *
340      * IMPORTANT: because control is transferred to `recipient`, care must be
341      * taken to not create reentrancy vulnerabilities. Consider using
342      * {ReentrancyGuard} or the
343      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
344      */
345     function sendValue(address payable recipient, uint256 amount) internal {
346         require(address(this).balance >= amount, "Address: insufficient balance");
347 
348         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
349         (bool success, ) = recipient.call{ value: amount }("");
350         require(success, "Address: unable to send value, recipient may have reverted");
351     }
352 
353     /**
354      * @dev Performs a Solidity function call using a low level `call`. A
355      * plain`call` is an unsafe replacement for a function call: use this
356      * function instead.
357      *
358      * If `target` reverts with a revert reason, it is bubbled up by this
359      * function (like regular Solidity function calls).
360      *
361      * Returns the raw returned data. To convert to the expected return value,
362      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
363      *
364      * Requirements:
365      *
366      * - `target` must be a contract.
367      * - calling `target` with `data` must not revert.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
372       return functionCall(target, data, "Address: low-level call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
377      * `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, 0, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but also transferring `value` wei to `target`.
388      *
389      * Requirements:
390      *
391      * - the calling contract must have an ETH balance of at least `value`.
392      * - the called Solidity function must be `payable`.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
397         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
402      * with `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
407         require(address(this).balance >= value, "Address: insufficient balance for call");
408         require(isContract(target), "Address: call to non-contract");
409 
410         // solhint-disable-next-line avoid-low-level-calls
411         (bool success, bytes memory returndata) = target.call{ value: value }(data);
412         return _verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a static call.
418      *
419      * _Available since v3.3._
420      */
421     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
422         return functionStaticCall(target, data, "Address: low-level static call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
427      * but performing a static call.
428      *
429      * _Available since v3.3._
430      */
431     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
432         require(isContract(target), "Address: static call to non-contract");
433 
434         // solhint-disable-next-line avoid-low-level-calls
435         (bool success, bytes memory returndata) = target.staticcall(data);
436         return _verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441      * but performing a delegate call.
442      *
443      * _Available since v3.4._
444      */
445     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
446         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
451      * but performing a delegate call.
452      *
453      * _Available since v3.4._
454      */
455     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
456         require(isContract(target), "Address: delegate call to non-contract");
457 
458         // solhint-disable-next-line avoid-low-level-calls
459         (bool success, bytes memory returndata) = target.delegatecall(data);
460         return _verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
464         if (success) {
465             return returndata;
466         } else {
467             // Look for revert reason and bubble it up if present
468             if (returndata.length > 0) {
469                 // The easiest way to bubble the revert reason is using memory via assembly
470 
471                 // solhint-disable-next-line no-inline-assembly
472                 assembly {
473                     let returndata_size := mload(returndata)
474                     revert(add(32, returndata), returndata_size)
475                 }
476             } else {
477                 revert(errorMessage);
478             }
479         }
480     }
481 }
482 
483 pragma solidity ^0.8.0;
484 
485 /**
486  * @title ERC721 token receiver interface
487  * @dev Interface for any contract that wants to support safeTransfers
488  * from ERC721 asset contracts.
489  */
490 interface IERC721Receiver {
491     /**
492      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
493      * by `operator` from `from`, this function is called.
494      *
495      * It must return its Solidity selector to confirm the token transfer.
496      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
497      *
498      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
499      */
500     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
501 }
502 
503 pragma solidity ^0.8.0;
504 
505 /**
506  * @dev Interface of the ERC165 standard, as defined in the
507  * https://eips.ethereum.org/EIPS/eip-165[EIP].
508  *
509  * Implementers can declare support of contract interfaces, which can then be
510  * queried by others ({ERC165Checker}).
511  *
512  * For an implementation, see {ERC165}.
513  */
514 interface IERC165 {
515     /**
516      * @dev Returns true if this contract implements the interface defined by
517      * `interfaceId`. See the corresponding
518      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
519      * to learn more about how these ids are created.
520      *
521      * This function call must use less than 30 000 gas.
522      */
523     function supportsInterface(bytes4 interfaceId) external view returns (bool);
524 }
525 
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @dev Implementation of the {IERC165} interface.
531  *
532  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
533  * for the additional interface id that will be supported. For example:
534  *
535  * ```solidity
536  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
537  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
538  * }
539  * ```
540  *
541  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
542  */
543 abstract contract ERC165 is IERC165 {
544     /**
545      * @dev See {IERC165-supportsInterface}.
546      */
547     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
548         return interfaceId == type(IERC165).interfaceId;
549     }
550 }
551 
552 
553 pragma solidity ^0.8.0;
554 
555 /**
556  * @dev Required interface of an ERC721 compliant contract.
557  */
558 interface IERC721 is IERC165 {
559     /**
560      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
561      */
562     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
563 
564     /**
565      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
566      */
567     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
568 
569     /**
570      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
571      */
572     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
573 
574     /**
575      * @dev Returns the number of tokens in ``owner``'s account.
576      */
577     function balanceOf(address owner) external view returns (uint256 balance);
578 
579     /**
580      * @dev Returns the owner of the `tokenId` token.
581      *
582      * Requirements:
583      *
584      * - `tokenId` must exist.
585      */
586     function ownerOf(uint256 tokenId) external view returns (address owner);
587 
588     /**
589      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
590      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
591      *
592      * Requirements:
593      *
594      * - `from` cannot be the zero address.
595      * - `to` cannot be the zero address.
596      * - `tokenId` token must exist and be owned by `from`.
597      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
598      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
599      *
600      * Emits a {Transfer} event.
601      */
602     function safeTransferFrom(address from, address to, uint256 tokenId) external;
603 
604     /**
605      * @dev Transfers `tokenId` token from `from` to `to`.
606      *
607      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
608      *
609      * Requirements:
610      *
611      * - `from` cannot be the zero address.
612      * - `to` cannot be the zero address.
613      * - `tokenId` token must be owned by `from`.
614      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
615      *
616      * Emits a {Transfer} event.
617      */
618     function transferFrom(address from, address to, uint256 tokenId) external;
619 
620     /**
621      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
622      * The approval is cleared when the token is transferred.
623      *
624      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
625      *
626      * Requirements:
627      *
628      * - The caller must own the token or be an approved operator.
629      * - `tokenId` must exist.
630      *
631      * Emits an {Approval} event.
632      */
633     function approve(address to, uint256 tokenId) external;
634 
635     /**
636      * @dev Returns the account approved for `tokenId` token.
637      *
638      * Requirements:
639      *
640      * - `tokenId` must exist.
641      */
642     function getApproved(uint256 tokenId) external view returns (address operator);
643 
644     /**
645      * @dev Approve or remove `operator` as an operator for the caller.
646      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
647      *
648      * Requirements:
649      *
650      * - The `operator` cannot be the caller.
651      *
652      * Emits an {ApprovalForAll} event.
653      */
654     function setApprovalForAll(address operator, bool _approved) external;
655 
656     /**
657      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
658      *
659      * See {setApprovalForAll}
660      */
661     function isApprovedForAll(address owner, address operator) external view returns (bool);
662 
663     /**
664       * @dev Safely transfers `tokenId` token from `from` to `to`.
665       *
666       * Requirements:
667       *
668       * - `from` cannot be the zero address.
669       * - `to` cannot be the zero address.
670       * - `tokenId` token must exist and be owned by `from`.
671       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
672       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
673       *
674       * Emits a {Transfer} event.
675       */
676     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
677 }
678 
679 pragma solidity ^0.8.0;
680 
681 /**
682  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
683  * @dev See https://eips.ethereum.org/EIPS/eip-721
684  */
685 interface IERC721Enumerable is IERC721 {
686 
687     /**
688      * @dev Returns the total amount of tokens stored by the contract.
689      */
690     function totalSupply() external view returns (uint256);
691 
692     /**
693      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
694      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
695      */
696     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
697 
698     /**
699      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
700      * Use along with {totalSupply} to enumerate all tokens.
701      */
702     function tokenByIndex(uint256 index) external view returns (uint256);
703 }
704 
705 pragma solidity ^0.8.0;
706 
707 /**
708  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
709  * @dev See https://eips.ethereum.org/EIPS/eip-721
710  */
711 interface IERC721Metadata is IERC721 {
712 
713     /**
714      * @dev Returns the token collection name.
715      */
716     function name() external view returns (string memory);
717 
718     /**
719      * @dev Returns the token collection symbol.
720      */
721     function symbol() external view returns (string memory);
722 
723     /**
724      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
725      */
726     function tokenURI(uint256 tokenId) external view returns (string memory);
727 }
728 
729 
730 
731 
732 pragma solidity ^0.8.0;
733 
734 /*
735  * @dev Provides information about the current execution context, including the
736  * sender of the transaction and its data. While these are generally available
737  * via msg.sender and msg.data, they should not be accessed in such a direct
738  * manner, since when dealing with meta-transactions the account sending and
739  * paying for execution may not be the actual sender (as far as an application
740  * is concerned).
741  *
742  * This contract is only required for intermediate, library-like contracts.
743  */
744 abstract contract Context {
745     function _msgSender() internal view virtual returns (address) {
746         return msg.sender;
747     }
748 
749     function _msgData() internal view virtual returns (bytes calldata) {
750         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
751         return msg.data;
752     }
753 }
754 
755 pragma solidity ^0.8.0;
756 
757 /**
758  * @dev Contract module which provides a basic access control mechanism, where
759  * there is an account (an owner) that can be granted exclusive access to
760  * specific functions.
761  *
762  * By default, the owner account will be the one that deploys the contract. This
763  * can later be changed with {transferOwnership}.
764  *
765  * This module is used through inheritance. It will make available the modifier
766  * `onlyOwner`, which can be applied to your functions to restrict their use to
767  * the owner.
768  */
769 abstract contract Ownable is Context {
770     address private _owner;
771 
772     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
773 
774     /**
775      * @dev Initializes the contract setting the deployer as the initial owner.
776      */
777     constructor () {
778         address msgSender = _msgSender();
779         _owner = msgSender;
780         emit OwnershipTransferred(address(0), msgSender);
781     }
782 
783     /**
784      * @dev Returns the address of the current owner.
785      */
786     function owner() public view virtual returns (address) {
787         return _owner;
788     }
789 
790     /**
791      * @dev Throws if called by any account other than the owner.
792      */
793     modifier onlyOwner() {
794         require(owner() == _msgSender(), "Ownable: caller is not the owner");
795         _;
796     }
797 
798     /**
799      * @dev Leaves the contract without owner. It will not be possible to call
800      * `onlyOwner` functions anymore. Can only be called by the current owner.
801      *
802      * NOTE: Renouncing ownership will leave the contract without an owner,
803      * thereby removing any functionality that is only available to the owner.
804      */
805     function renounceOwnership() public virtual onlyOwner {
806         emit OwnershipTransferred(_owner, address(0));
807         _owner = address(0);
808     }
809 
810     /**
811      * @dev Transfers ownership of the contract to a new account (`newOwner`).
812      * Can only be called by the current owner.
813      */
814     function transferOwnership(address newOwner) public virtual onlyOwner {
815         require(newOwner != address(0), "Ownable: new owner is the zero address");
816         emit OwnershipTransferred(_owner, newOwner);
817         _owner = newOwner;
818     }
819 }
820 
821 
822 pragma solidity ^0.8.0;
823 
824 /**
825  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
826  * the Metadata extension, but not including the Enumerable extension, which is available separately as
827  * {ERC721Enumerable}.
828  */
829 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
830     using Address for address;
831     using Strings for uint256;
832 
833     // Token name
834     string private _name;
835 
836     // Token symbol
837     string private _symbol;
838 
839     // Mapping from token ID to owner address
840     mapping (uint256 => address) private _owners;
841 
842     // Mapping owner address to token count
843     mapping (address => uint256) private _balances;
844 
845     // Mapping from token ID to approved address
846     mapping (uint256 => address) private _tokenApprovals;
847 
848     // Mapping from owner to operator approvals
849     mapping (address => mapping (address => bool)) private _operatorApprovals;
850 
851     /**
852      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
853      */
854     constructor (string memory name_, string memory symbol_) {
855         _name = name_;
856         _symbol = symbol_;
857     }
858 
859     /**
860      * @dev See {IERC165-supportsInterface}.
861      */
862     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
863         return interfaceId == type(IERC721).interfaceId
864             || interfaceId == type(IERC721Metadata).interfaceId
865             || super.supportsInterface(interfaceId);
866     }
867 
868     /**
869      * @dev See {IERC721-balanceOf}.
870      */
871     function balanceOf(address owner) public view virtual override returns (uint256) {
872         require(owner != address(0), "ERC721: balance query for the zero address");
873         return _balances[owner];
874     }
875 
876     /**
877      * @dev See {IERC721-ownerOf}.
878      */
879     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
880         address owner = _owners[tokenId];
881         require(owner != address(0), "ERC721: owner query for nonexistent token");
882         return owner;
883     }
884 
885     /**
886      * @dev See {IERC721Metadata-name}.
887      */
888     function name() public view virtual override returns (string memory) {
889         return _name;
890     }
891 
892     /**
893      * @dev See {IERC721Metadata-symbol}.
894      */
895     function symbol() public view virtual override returns (string memory) {
896         return _symbol;
897     }
898 
899     /**
900      * @dev See {IERC721Metadata-tokenURI}.
901      */
902     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
903         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
904 
905         string memory baseURI = _baseURI();
906         return bytes(baseURI).length > 0
907             ? string(abi.encodePacked(baseURI, tokenId.toString()))
908             : '';
909     }
910 
911     /**
912      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
913      * in child contracts.
914      */
915     function _baseURI() internal view virtual returns (string memory) {
916         return "";
917     }
918 
919     /**
920      * @dev See {IERC721-approve}.
921      */
922     function approve(address to, uint256 tokenId) public virtual override {
923         address owner = ERC721.ownerOf(tokenId);
924         require(to != owner, "ERC721: approval to current owner");
925 
926         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
927             "ERC721: approve caller is not owner nor approved for all"
928         );
929 
930         _approve(to, tokenId);
931     }
932 
933     /**
934      * @dev See {IERC721-getApproved}.
935      */
936     function getApproved(uint256 tokenId) public view virtual override returns (address) {
937         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
938 
939         return _tokenApprovals[tokenId];
940     }
941 
942     /**
943      * @dev See {IERC721-setApprovalForAll}.
944      */
945     function setApprovalForAll(address operator, bool approved) public virtual override {
946         require(operator != _msgSender(), "ERC721: approve to caller");
947 
948         _operatorApprovals[_msgSender()][operator] = approved;
949         emit ApprovalForAll(_msgSender(), operator, approved);
950     }
951 
952     /**
953      * @dev See {IERC721-isApprovedForAll}.
954      */
955     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
956         return _operatorApprovals[owner][operator];
957     }
958 
959     /**
960      * @dev See {IERC721-transferFrom}.
961      */
962     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
963         //solhint-disable-next-line max-line-length
964         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
965 
966         _transfer(from, to, tokenId);
967     }
968 
969     /**
970      * @dev See {IERC721-safeTransferFrom}.
971      */
972     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
973         safeTransferFrom(from, to, tokenId, "");
974     }
975 
976     /**
977      * @dev See {IERC721-safeTransferFrom}.
978      */
979     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
980         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
981         _safeTransfer(from, to, tokenId, _data);
982     }
983 
984     /**
985      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
986      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
987      *
988      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
989      *
990      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
991      * implement alternative mechanisms to perform token transfer, such as signature-based.
992      *
993      * Requirements:
994      *
995      * - `from` cannot be the zero address.
996      * - `to` cannot be the zero address.
997      * - `tokenId` token must exist and be owned by `from`.
998      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1003         _transfer(from, to, tokenId);
1004         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1005     }
1006 
1007     /**
1008      * @dev Returns whether `tokenId` exists.
1009      *
1010      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1011      *
1012      * Tokens start existing when they are minted (`_mint`),
1013      * and stop existing when they are burned (`_burn`).
1014      */
1015     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1016         return _owners[tokenId] != address(0);
1017     }
1018 
1019     /**
1020      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1021      *
1022      * Requirements:
1023      *
1024      * - `tokenId` must exist.
1025      */
1026     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1027         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1028         address owner = ERC721.ownerOf(tokenId);
1029         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1030     }
1031 
1032     /**
1033      * @dev Safely mints `tokenId` and transfers it to `to`.
1034      *
1035      * Requirements:
1036      *
1037      * - `tokenId` must not exist.
1038      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function _safeMint(address to, uint256 tokenId) internal virtual {
1043         _safeMint(to, tokenId, "");
1044     }
1045 
1046     /**
1047      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1048      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1049      */
1050     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1051         _mint(to, tokenId);
1052         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1053     }
1054 
1055     /**
1056      * @dev Mints `tokenId` and transfers it to `to`.
1057      *
1058      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1059      *
1060      * Requirements:
1061      *
1062      * - `tokenId` must not exist.
1063      * - `to` cannot be the zero address.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _mint(address to, uint256 tokenId) internal virtual {
1068         require(to != address(0), "ERC721: mint to the zero address");
1069         require(!_exists(tokenId), "ERC721: token already minted");
1070 
1071         _beforeTokenTransfer(address(0), to, tokenId);
1072 
1073         _balances[to] += 1;
1074         _owners[tokenId] = to;
1075 
1076         emit Transfer(address(0), to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev Destroys `tokenId`.
1081      * The approval is cleared when the token is burned.
1082      *
1083      * Requirements:
1084      *
1085      * - `tokenId` must exist.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _burn(uint256 tokenId) internal virtual {
1090         address owner = ERC721.ownerOf(tokenId);
1091 
1092         _beforeTokenTransfer(owner, address(0), tokenId);
1093 
1094         // Clear approvals
1095         _approve(address(0), tokenId);
1096 
1097         _balances[owner] -= 1;
1098         delete _owners[tokenId];
1099 
1100         emit Transfer(owner, address(0), tokenId);
1101     }
1102 
1103     /**
1104      * @dev Transfers `tokenId` from `from` to `to`.
1105      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1106      *
1107      * Requirements:
1108      *
1109      * - `to` cannot be the zero address.
1110      * - `tokenId` token must be owned by `from`.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1115         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1116         require(to != address(0), "ERC721: transfer to the zero address");
1117 
1118         _beforeTokenTransfer(from, to, tokenId);
1119 
1120         // Clear approvals from the previous owner
1121         _approve(address(0), tokenId);
1122 
1123         _balances[from] -= 1;
1124         _balances[to] += 1;
1125         _owners[tokenId] = to;
1126 
1127         emit Transfer(from, to, tokenId);
1128     }
1129 
1130     /**
1131      * @dev Approve `to` to operate on `tokenId`
1132      *
1133      * Emits a {Approval} event.
1134      */
1135     function _approve(address to, uint256 tokenId) internal virtual {
1136         _tokenApprovals[tokenId] = to;
1137         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1138     }
1139 
1140     /**
1141      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1142      * The call is not executed if the target address is not a contract.
1143      *
1144      * @param from address representing the previous owner of the given token ID
1145      * @param to target address that will receive the tokens
1146      * @param tokenId uint256 ID of the token to be transferred
1147      * @param _data bytes optional data to send along with the call
1148      * @return bool whether the call correctly returned the expected magic value
1149      */
1150     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1151         private returns (bool)
1152     {
1153         if (to.isContract()) {
1154             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1155                 return retval == IERC721Receiver(to).onERC721Received.selector;
1156             } catch (bytes memory reason) {
1157                 if (reason.length == 0) {
1158                     revert("ERC721: transfer to non ERC721Receiver implementer");
1159                 } else {
1160                     // solhint-disable-next-line no-inline-assembly
1161                     assembly {
1162                         revert(add(32, reason), mload(reason))
1163                     }
1164                 }
1165             }
1166         } else {
1167             return true;
1168         }
1169     }
1170 
1171     /**
1172      * @dev Hook that is called before any token transfer. This includes minting
1173      * and burning.
1174      *
1175      * Calling conditions:
1176      *
1177      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1178      * transferred to `to`.
1179      * - When `from` is zero, `tokenId` will be minted for `to`.
1180      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1181      * - `from` cannot be the zero address.
1182      * - `to` cannot be the zero address.
1183      *
1184      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1185      */
1186     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1187 }
1188 
1189 pragma solidity ^0.8.0;
1190 
1191 /**
1192  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1193  * enumerability of all the token ids in the contract as well as all token ids owned by each
1194  * account.
1195  */
1196 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1197     // Mapping from owner to list of owned token IDs
1198     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1199 
1200     // Mapping from token ID to index of the owner tokens list
1201     mapping(uint256 => uint256) private _ownedTokensIndex;
1202 
1203     // Array with all token ids, used for enumeration
1204     uint256[] private _allTokens;
1205 
1206     // Mapping from token id to position in the allTokens array
1207     mapping(uint256 => uint256) private _allTokensIndex;
1208 
1209     /**
1210      * @dev See {IERC165-supportsInterface}.
1211      */
1212     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1213         return interfaceId == type(IERC721Enumerable).interfaceId
1214             || super.supportsInterface(interfaceId);
1215     }
1216 
1217     /**
1218      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1219      */
1220     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1221         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1222         return _ownedTokens[owner][index];
1223     }
1224 
1225     /**
1226      * @dev See {IERC721Enumerable-totalSupply}.
1227      */
1228     function totalSupply() public view virtual override returns (uint256) {
1229         return _allTokens.length;
1230     }
1231 
1232     /**
1233      * @dev See {IERC721Enumerable-tokenByIndex}.
1234      */
1235     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1236         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1237         return _allTokens[index];
1238     }
1239 
1240     /**
1241      * @dev Hook that is called before any token transfer. This includes minting
1242      * and burning.
1243      *
1244      * Calling conditions:
1245      *
1246      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1247      * transferred to `to`.
1248      * - When `from` is zero, `tokenId` will be minted for `to`.
1249      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1250      * - `from` cannot be the zero address.
1251      * - `to` cannot be the zero address.
1252      *
1253      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1254      */
1255     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1256         super._beforeTokenTransfer(from, to, tokenId);
1257 
1258         if (from == address(0)) {
1259             _addTokenToAllTokensEnumeration(tokenId);
1260         } else if (from != to) {
1261             _removeTokenFromOwnerEnumeration(from, tokenId);
1262         }
1263         if (to == address(0)) {
1264             _removeTokenFromAllTokensEnumeration(tokenId);
1265         } else if (to != from) {
1266             _addTokenToOwnerEnumeration(to, tokenId);
1267         }
1268     }
1269 
1270     /**
1271      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1272      * @param to address representing the new owner of the given token ID
1273      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1274      */
1275     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1276         uint256 length = ERC721.balanceOf(to);
1277         _ownedTokens[to][length] = tokenId;
1278         _ownedTokensIndex[tokenId] = length;
1279     }
1280 
1281     /**
1282      * @dev Private function to add a token to this extension's token tracking data structures.
1283      * @param tokenId uint256 ID of the token to be added to the tokens list
1284      */
1285     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1286         _allTokensIndex[tokenId] = _allTokens.length;
1287         _allTokens.push(tokenId);
1288     }
1289 
1290     /**
1291      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1292      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1293      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1294      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1295      * @param from address representing the previous owner of the given token ID
1296      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1297      */
1298     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1299         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1300         // then delete the last slot (swap and pop).
1301 
1302         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1303         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1304 
1305         // When the token to delete is the last token, the swap operation is unnecessary
1306         if (tokenIndex != lastTokenIndex) {
1307             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1308 
1309             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1310             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1311         }
1312 
1313         // This also deletes the contents at the last position of the array
1314         delete _ownedTokensIndex[tokenId];
1315         delete _ownedTokens[from][lastTokenIndex];
1316     }
1317 
1318     /**
1319      * @dev Private function to remove a token from this extension's token tracking data structures.
1320      * This has O(1) time complexity, but alters the order of the _allTokens array.
1321      * @param tokenId uint256 ID of the token to be removed from the tokens list
1322      */
1323     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1324         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1325         // then delete the last slot (swap and pop).
1326 
1327         uint256 lastTokenIndex = _allTokens.length - 1;
1328         uint256 tokenIndex = _allTokensIndex[tokenId];
1329 
1330         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1331         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1332         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1333         uint256 lastTokenId = _allTokens[lastTokenIndex];
1334 
1335         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1336         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1337 
1338         // This also deletes the contents at the last position of the array
1339         delete _allTokensIndex[tokenId];
1340         _allTokens.pop();
1341     }
1342 }
1343 
1344 pragma solidity ^0.8.0;
1345 
1346 contract Metabits {
1347     function updateTimeForMetaKidzGC(uint256 _tokenId) external {}
1348 }
1349 
1350 contract Genesis is ERC721Enumerable, Ownable {
1351     using SafeMath for uint256;
1352     using Address for address;
1353     using Strings for uint256;
1354 
1355     address public metabitsContractAddress;
1356     uint256 public MAX_SUPPLY = 1000;
1357     uint256 public RESERVED = 50;
1358     bool public saleIsActive = false;
1359     string private _baseURIExtended;
1360     address public admin = 0x1097fd1777409Ff30fF32191891A9a9752b61F01;
1361     Metabits public metabits;
1362 
1363     constructor(string memory _name, string memory _symbol, string memory _BaseURI,address _metabitsContractAddress) ERC721(_name, _symbol){
1364         _baseURIExtended = _BaseURI;
1365         metabitsContractAddress = _metabitsContractAddress;
1366         metabits = Metabits(_metabitsContractAddress);
1367     }
1368     function flipSaleState() public {
1369         require(msg.sender == admin || msg.sender == owner(), "Invalid sender");
1370         saleIsActive = !saleIsActive;
1371     }
1372 
1373     function mintGenesis(uint numberOfToken) public payable {
1374         require(saleIsActive, "Sale is not active at the moment");
1375         require(balanceOf(msg.sender) < 1, "You have exceeded max genesis limit per wallet");
1376         require(totalSupply().add(numberOfToken) <= MAX_SUPPLY.sub(RESERVED), "Purchase would exceed max supply of genesis");
1377         require(numberOfToken <= 1, "You have exceeded max Genesis limit per transaction");
1378         require(numberOfToken > 0, "Number of tokens can not be less than or equal to 0");
1379         _safeMint(msg.sender, totalSupply());
1380         uint256 mintIndex =  totalSupply();
1381         if(metabitsContractAddress != 0x000000000000000000000000000000000000dEaD){
1382         metabits.updateTimeForMetaKidzGC(mintIndex);
1383         }
1384     }
1385 
1386     function mintReserveGenesis(uint numberOfToken) public payable {
1387         require(msg.sender == admin || msg.sender == owner(), "Invalid sender");
1388         require(numberOfToken > 0 && numberOfToken <= RESERVED, "Not enough reserve left");
1389         for(uint256 i = 0; i < numberOfToken; i++) {
1390             uint256 mintIndex = totalSupply();
1391             _safeMint(msg.sender, mintIndex);
1392         if(metabitsContractAddress != 0x000000000000000000000000000000000000dEaD){
1393         metabits.updateTimeForMetaKidzGC(mintIndex);
1394         }
1395         }
1396 
1397         RESERVED = RESERVED.sub(numberOfToken);
1398     }
1399     
1400     function _baseURI() internal view virtual override returns (string memory) {
1401         return _baseURIExtended;
1402     }
1403 
1404     function transferFrom(address from, address to, uint256 tokenId) public override {
1405         if(metabitsContractAddress != 0x000000000000000000000000000000000000dEaD){
1406         metabits.updateTimeForMetaKidzGC(tokenId);
1407         }
1408         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1409         _transfer(from, to, tokenId);
1410     }
1411 
1412     function setBaseURI(string memory baseURI_) external {
1413         require(msg.sender == admin || msg.sender == owner(), "Invalid sender");
1414         _baseURIExtended = baseURI_;
1415     }
1416 
1417      function setMetaBitsContractAddress(address _addr) public {
1418         require(msg.sender == admin || msg.sender == owner(), "Invalid sender");
1419         metabitsContractAddress = _addr;
1420         metabits = Metabits(_addr);
1421     }
1422 }