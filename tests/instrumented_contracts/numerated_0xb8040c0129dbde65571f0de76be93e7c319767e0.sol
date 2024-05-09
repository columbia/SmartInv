1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-16
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
26     unchecked {
27         uint256 c = a + b;
28         if (c < a) return (false, 0);
29         return (true, c);
30     }
31     }
32 
33     /**
34      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
35      *
36      * _Available since v3.4._
37      */
38     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39     unchecked {
40         if (b > a) return (false, 0);
41         return (true, a - b);
42     }
43     }
44 
45     /**
46      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
47      *
48      * _Available since v3.4._
49      */
50     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51     unchecked {
52         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53         // benefit is lost if 'b' is also tested.
54         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
55         if (a == 0) return (true, 0);
56         uint256 c = a * b;
57         if (c / a != b) return (false, 0);
58         return (true, c);
59     }
60     }
61 
62     /**
63      * @dev Returns the division of two unsigned integers, with a division by zero flag.
64      *
65      * _Available since v3.4._
66      */
67     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68     unchecked {
69         if (b == 0) return (false, 0);
70         return (true, a / b);
71     }
72     }
73 
74     /**
75      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80     unchecked {
81         if (b == 0) return (false, 0);
82         return (true, a % b);
83     }
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
171     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172     unchecked {
173         require(b <= a, errorMessage);
174         return a - b;
175     }
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
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195     unchecked {
196         require(b > 0, errorMessage);
197         return a / b;
198     }
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
216     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217     unchecked {
218         require(b > 0, errorMessage);
219         return a % b;
220     }
221     }
222 }
223 
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @dev String operations.
229  */
230 library Strings {
231     bytes16 private constant alphabet = "0123456789abcdef";
232 
233     /**
234      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
235      */
236     function toString(uint256 value) internal pure returns (string memory) {
237         // Inspired by OraclizeAPI's implementation - MIT licence
238         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
239 
240         if (value == 0) {
241             return "0";
242         }
243         uint256 temp = value;
244         uint256 digits;
245         while (temp != 0) {
246             digits++;
247             temp /= 10;
248         }
249         bytes memory buffer = new bytes(digits);
250         while (value != 0) {
251             digits -= 1;
252             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
253             value /= 10;
254         }
255         return string(buffer);
256     }
257 
258     /**
259      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
260      */
261     function toHexString(uint256 value) internal pure returns (string memory) {
262         if (value == 0) {
263             return "0x00";
264         }
265         uint256 temp = value;
266         uint256 length = 0;
267         while (temp != 0) {
268             length++;
269             temp >>= 8;
270         }
271         return toHexString(value, length);
272     }
273 
274     /**
275      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
276      */
277     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
278         bytes memory buffer = new bytes(2 * length + 2);
279         buffer[0] = "0";
280         buffer[1] = "x";
281         for (uint256 i = 2 * length + 1; i > 1; --i) {
282             buffer[i] = alphabet[value & 0xf];
283             value >>= 4;
284         }
285         require(value == 0, "Strings: hex length insufficient");
286         return string(buffer);
287     }
288 
289 }
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @dev Collection of functions related to the address type
295  */
296 library Address {
297     /**
298      * @dev Returns true if `account` is a contract.
299      *
300      * [IMPORTANT]
301      * ====
302      * It is unsafe to assume that an address for which this function returns
303      * false is an externally-owned account (EOA) and not a contract.
304      *
305      * Among others, `isContract` will return false for the following
306      * types of addresses:
307      *
308      *  - an externally-owned account
309      *  - a contract in construction
310      *  - an address where a contract will be created
311      *  - an address where a contract lived, but was destroyed
312      * ====
313      */
314     function isContract(address account) internal view returns (bool) {
315         // This method relies on extcodesize, which returns 0 for contracts in
316         // construction, since the code is only stored at the end of the
317         // constructor execution.
318 
319         uint256 size;
320         // solhint-disable-next-line no-inline-assembly
321         assembly { size := extcodesize(account) }
322         return size > 0;
323     }
324 
325     /**
326      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
327      * `recipient`, forwarding all available gas and reverting on errors.
328      *
329      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
330      * of certain opcodes, possibly making contracts go over the 2300 gas limit
331      * imposed by `transfer`, making them unable to receive funds via
332      * `transfer`. {sendValue} removes this limitation.
333      *
334      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
335      *
336      * IMPORTANT: because control is transferred to `recipient`, care must be
337      * taken to not create reentrancy vulnerabilities. Consider using
338      * {ReentrancyGuard} or the
339      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
340      */
341     function sendValue(address payable recipient, uint256 amount) internal {
342         require(address(this).balance >= amount, "Address: insufficient balance");
343 
344         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
345         (bool success, ) = recipient.call{ value: amount }("");
346         require(success, "Address: unable to send value, recipient may have reverted");
347     }
348 
349     /**
350      * @dev Performs a Solidity function call using a low level `call`. A
351      * plain`call` is an unsafe replacement for a function call: use this
352      * function instead.
353      *
354      * If `target` reverts with a revert reason, it is bubbled up by this
355      * function (like regular Solidity function calls).
356      *
357      * Returns the raw returned data. To convert to the expected return value,
358      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
359      *
360      * Requirements:
361      *
362      * - `target` must be a contract.
363      * - calling `target` with `data` must not revert.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
368         return functionCall(target, data, "Address: low-level call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
373      * `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
378         return functionCallWithValue(target, data, 0, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but also transferring `value` wei to `target`.
384      *
385      * Requirements:
386      *
387      * - the calling contract must have an ETH balance of at least `value`.
388      * - the called Solidity function must be `payable`.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
393         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
398      * with `errorMessage` as a fallback revert reason when `target` reverts.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
403         require(address(this).balance >= value, "Address: insufficient balance for call");
404         require(isContract(target), "Address: call to non-contract");
405 
406         // solhint-disable-next-line avoid-low-level-calls
407         (bool success, bytes memory returndata) = target.call{ value: value }(data);
408         return _verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but performing a static call.
414      *
415      * _Available since v3.3._
416      */
417     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
418         return functionStaticCall(target, data, "Address: low-level static call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
423      * but performing a static call.
424      *
425      * _Available since v3.3._
426      */
427     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
428         require(isContract(target), "Address: static call to non-contract");
429 
430         // solhint-disable-next-line avoid-low-level-calls
431         (bool success, bytes memory returndata) = target.staticcall(data);
432         return _verifyCallResult(success, returndata, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but performing a delegate call.
438      *
439      * _Available since v3.4._
440      */
441     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
442         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
447      * but performing a delegate call.
448      *
449      * _Available since v3.4._
450      */
451     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
452         require(isContract(target), "Address: delegate call to non-contract");
453 
454         // solhint-disable-next-line avoid-low-level-calls
455         (bool success, bytes memory returndata) = target.delegatecall(data);
456         return _verifyCallResult(success, returndata, errorMessage);
457     }
458 
459     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
460         if (success) {
461             return returndata;
462         } else {
463             // Look for revert reason and bubble it up if present
464             if (returndata.length > 0) {
465                 // The easiest way to bubble the revert reason is using memory via assembly
466 
467                 // solhint-disable-next-line no-inline-assembly
468                 assembly {
469                     let returndata_size := mload(returndata)
470                     revert(add(32, returndata), returndata_size)
471                 }
472             } else {
473                 revert(errorMessage);
474             }
475         }
476     }
477 }
478 
479 pragma solidity ^0.8.0;
480 
481 /**
482  * @title ERC721 token receiver interface
483  * @dev Interface for any contract that wants to support safeTransfers
484  * from ERC721 asset contracts.
485  */
486 interface IERC721Receiver {
487     /**
488      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
489      * by `operator` from `from`, this function is called.
490      *
491      * It must return its Solidity selector to confirm the token transfer.
492      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
493      *
494      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
495      */
496     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
497 }
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @dev Interface of the ERC165 standard, as defined in the
503  * https://eips.ethereum.org/EIPS/eip-165[EIP].
504  *
505  * Implementers can declare support of contract interfaces, which can then be
506  * queried by others ({ERC165Checker}).
507  *
508  * For an implementation, see {ERC165}.
509  */
510 interface IERC165 {
511     /**
512      * @dev Returns true if this contract implements the interface defined by
513      * `interfaceId`. See the corresponding
514      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
515      * to learn more about how these ids are created.
516      *
517      * This function call must use less than 30 000 gas.
518      */
519     function supportsInterface(bytes4 interfaceId) external view returns (bool);
520 }
521 
522 
523 pragma solidity ^0.8.0;
524 
525 /**
526  * @dev Implementation of the {IERC165} interface.
527  *
528  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
529  * for the additional interface id that will be supported. For example:
530  *
531  * ```solidity
532  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
533  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
534  * }
535  * ```
536  *
537  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
538  */
539 abstract contract ERC165 is IERC165 {
540     /**
541      * @dev See {IERC165-supportsInterface}.
542      */
543     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
544         return interfaceId == type(IERC165).interfaceId;
545     }
546 }
547 
548 
549 pragma solidity ^0.8.0;
550 
551 /**
552  * @dev Required interface of an ERC721 compliant contract.
553  */
554 interface IERC721 is IERC165 {
555     /**
556      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
557      */
558     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
559 
560     /**
561      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
562      */
563     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
564 
565     /**
566      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
567      */
568     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
569 
570     /**
571      * @dev Returns the number of tokens in ``owner``'s account.
572      */
573     function balanceOf(address owner) external view returns (uint256 balance);
574 
575     /**
576      * @dev Returns the owner of the `tokenId` token.
577      *
578      * Requirements:
579      *
580      * - `tokenId` must exist.
581      */
582     function ownerOf(uint256 tokenId) external view returns (address owner);
583 
584     /**
585      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
586      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
587      *
588      * Requirements:
589      *
590      * - `from` cannot be the zero address.
591      * - `to` cannot be the zero address.
592      * - `tokenId` token must exist and be owned by `from`.
593      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
594      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
595      *
596      * Emits a {Transfer} event.
597      */
598     function safeTransferFrom(address from, address to, uint256 tokenId) external;
599 
600     /**
601      * @dev Transfers `tokenId` token from `from` to `to`.
602      *
603      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
604      *
605      * Requirements:
606      *
607      * - `from` cannot be the zero address.
608      * - `to` cannot be the zero address.
609      * - `tokenId` token must be owned by `from`.
610      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
611      *
612      * Emits a {Transfer} event.
613      */
614     function transferFrom(address from, address to, uint256 tokenId) external;
615 
616     /**
617      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
618      * The approval is cleared when the token is transferred.
619      *
620      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
621      *
622      * Requirements:
623      *
624      * - The caller must own the token or be an approved operator.
625      * - `tokenId` must exist.
626      *
627      * Emits an {Approval} event.
628      */
629     function approve(address to, uint256 tokenId) external;
630 
631     /**
632      * @dev Returns the account approved for `tokenId` token.
633      *
634      * Requirements:
635      *
636      * - `tokenId` must exist.
637      */
638     function getApproved(uint256 tokenId) external view returns (address operator);
639 
640     /**
641      * @dev Approve or remove `operator` as an operator for the caller.
642      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
643      *
644      * Requirements:
645      *
646      * - The `operator` cannot be the caller.
647      *
648      * Emits an {ApprovalForAll} event.
649      */
650     function setApprovalForAll(address operator, bool _approved) external;
651 
652     /**
653      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
654      *
655      * See {setApprovalForAll}
656      */
657     function isApprovedForAll(address owner, address operator) external view returns (bool);
658 
659     /**
660       * @dev Safely transfers `tokenId` token from `from` to `to`.
661       *
662       * Requirements:
663       *
664       * - `from` cannot be the zero address.
665       * - `to` cannot be the zero address.
666       * - `tokenId` token must exist and be owned by `from`.
667       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
668       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
669       *
670       * Emits a {Transfer} event.
671       */
672     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
673 }
674 
675 pragma solidity ^0.8.0;
676 
677 /**
678  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
679  * @dev See https://eips.ethereum.org/EIPS/eip-721
680  */
681 interface IERC721Enumerable is IERC721 {
682 
683     /**
684      * @dev Returns the total amount of tokens stored by the contract.
685      */
686     function totalSupply() external view returns (uint256);
687 
688     /**
689      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
690      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
691      */
692     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
693 
694     /**
695      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
696      * Use along with {totalSupply} to enumerate all tokens.
697      */
698     function tokenByIndex(uint256 index) external view returns (uint256);
699 }
700 
701 pragma solidity ^0.8.0;
702 
703 /**
704  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
705  * @dev See https://eips.ethereum.org/EIPS/eip-721
706  */
707 interface IERC721Metadata is IERC721 {
708 
709     /**
710      * @dev Returns the token collection name.
711      */
712     function name() external view returns (string memory);
713 
714     /**
715      * @dev Returns the token collection symbol.
716      */
717     function symbol() external view returns (string memory);
718 
719     /**
720      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
721      */
722     function tokenURI(uint256 tokenId) external view returns (string memory);
723 }
724 
725 
726 
727 
728 pragma solidity ^0.8.0;
729 
730 /*
731  * @dev Provides information about the current execution context, including the
732  * sender of the transaction and its data. While these are generally available
733  * via msg.sender and msg.data, they should not be accessed in such a direct
734  * manner, since when dealing with meta-transactions the account sending and
735  * paying for execution may not be the actual sender (as far as an application
736  * is concerned).
737  *
738  * This contract is only required for intermediate, library-like contracts.
739  */
740 abstract contract Context {
741     function _msgSender() internal view virtual returns (address) {
742         return msg.sender;
743     }
744 
745     function _msgData() internal view virtual returns (bytes calldata) {
746         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
747         return msg.data;
748     }
749 }
750 
751 pragma solidity ^0.8.0;
752 
753 /**
754  * @dev Contract module which provides a basic access control mechanism, where
755  * there is an account (an owner) that can be granted exclusive access to
756  * specific functions.
757  *
758  * By default, the owner account will be the one that deploys the contract. This
759  * can later be changed with {transferOwnership}.
760  *
761  * This module is used through inheritance. It will make available the modifier
762  * `onlyOwner`, which can be applied to your functions to restrict their use to
763  * the owner.
764  */
765 abstract contract Ownable is Context {
766     address private _owner;
767 
768     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
769 
770     /**
771      * @dev Initializes the contract setting the deployer as the initial owner.
772      */
773     constructor () {
774         address msgSender = _msgSender();
775         _owner = msgSender;
776         emit OwnershipTransferred(address(0), msgSender);
777     }
778 
779     /**
780      * @dev Returns the address of the current owner.
781      */
782     function owner() public view virtual returns (address) {
783         return _owner;
784     }
785 
786     /**
787      * @dev Throws if called by any account other than the owner.
788      */
789     modifier onlyOwner() {
790         require(owner() == _msgSender(), "Ownable: caller is not the owner");
791         _;
792     }
793 
794     /**
795      * @dev Leaves the contract without owner. It will not be possible to call
796      * `onlyOwner` functions anymore. Can only be called by the current owner.
797      *
798      * NOTE: Renouncing ownership will leave the contract without an owner,
799      * thereby removing any functionality that is only available to the owner.
800      */
801     function renounceOwnership() public virtual onlyOwner {
802         emit OwnershipTransferred(_owner, address(0));
803         _owner = address(0);
804     }
805 
806     /**
807      * @dev Transfers ownership of the contract to a new account (`newOwner`).
808      * Can only be called by the current owner.
809      */
810     function transferOwnership(address newOwner) public virtual onlyOwner {
811         require(newOwner != address(0), "Ownable: new owner is the zero address");
812         emit OwnershipTransferred(_owner, newOwner);
813         _owner = newOwner;
814     }
815 }
816 
817 
818 pragma solidity ^0.8.0;
819 
820 /**
821  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
822  * the Metadata extension, but not including the Enumerable extension, which is available separately as
823  * {ERC721Enumerable}.
824  */
825 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
826     using Address for address;
827     using Strings for uint256;
828 
829     // Token name
830     string private _name;
831 
832     // Token symbol
833     string private _symbol;
834 
835     // Mapping from token ID to owner address
836     mapping (uint256 => address) private _owners;
837 
838     // Mapping owner address to token count
839     mapping (address => uint256) private _balances;
840 
841     // Mapping from token ID to approved address
842     mapping (uint256 => address) private _tokenApprovals;
843 
844     // Mapping from owner to operator approvals
845     mapping (address => mapping (address => bool)) private _operatorApprovals;
846 
847     /**
848      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
849      */
850     constructor (string memory name_, string memory symbol_) {
851         _name = name_;
852         _symbol = symbol_;
853     }
854 
855     /**
856      * @dev See {IERC165-supportsInterface}.
857      */
858     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
859         return interfaceId == type(IERC721).interfaceId
860         || interfaceId == type(IERC721Metadata).interfaceId
861         || super.supportsInterface(interfaceId);
862     }
863 
864     /**
865      * @dev See {IERC721-balanceOf}.
866      */
867     function balanceOf(address owner) public view virtual override returns (uint256) {
868         require(owner != address(0), "ERC721: balance query for the zero address");
869         return _balances[owner];
870     }
871 
872     /**
873      * @dev See {IERC721-ownerOf}.
874      */
875     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
876         address owner = _owners[tokenId];
877         require(owner != address(0), "ERC721: owner query for nonexistent token");
878         return owner;
879     }
880 
881     /**
882      * @dev See {IERC721Metadata-name}.
883      */
884     function name() public view virtual override returns (string memory) {
885         return _name;
886     }
887 
888     /**
889      * @dev See {IERC721Metadata-symbol}.
890      */
891     function symbol() public view virtual override returns (string memory) {
892         return _symbol;
893     }
894 
895     /**
896      * @dev See {IERC721Metadata-tokenURI}.
897      */
898     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
899         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
900 
901         string memory baseURI = _baseURI();
902         return bytes(baseURI).length > 0
903         ? string(abi.encodePacked(baseURI, tokenId.toString()))
904         : '';
905     }
906 
907     /**
908      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
909      * in child contracts.
910      */
911     function _baseURI() internal view virtual returns (string memory) {
912         return "";
913     }
914 
915     /**
916      * @dev See {IERC721-approve}.
917      */
918     function approve(address to, uint256 tokenId) public virtual override {
919         address owner = ERC721.ownerOf(tokenId);
920         require(to != owner, "ERC721: approval to current owner");
921 
922         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
923             "ERC721: approve caller is not owner nor approved for all"
924         );
925 
926         _approve(to, tokenId);
927     }
928 
929     /**
930      * @dev See {IERC721-getApproved}.
931      */
932     function getApproved(uint256 tokenId) public view virtual override returns (address) {
933         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
934 
935         return _tokenApprovals[tokenId];
936     }
937 
938     /**
939      * @dev See {IERC721-setApprovalForAll}.
940      */
941     function setApprovalForAll(address operator, bool approved) public virtual override {
942         require(operator != _msgSender(), "ERC721: approve to caller");
943 
944         _operatorApprovals[_msgSender()][operator] = approved;
945         emit ApprovalForAll(_msgSender(), operator, approved);
946     }
947 
948     /**
949      * @dev See {IERC721-isApprovedForAll}.
950      */
951     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
952         return _operatorApprovals[owner][operator];
953     }
954 
955     /**
956      * @dev See {IERC721-transferFrom}.
957      */
958     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
959         //solhint-disable-next-line max-line-length
960         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
961 
962         _transfer(from, to, tokenId);
963     }
964 
965     /**
966      * @dev See {IERC721-safeTransferFrom}.
967      */
968     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
969         safeTransferFrom(from, to, tokenId, "");
970     }
971 
972     /**
973      * @dev See {IERC721-safeTransferFrom}.
974      */
975     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
976         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
977         _safeTransfer(from, to, tokenId, _data);
978     }
979 
980     /**
981      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
982      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
983      *
984      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
985      *
986      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
987      * implement alternative mechanisms to perform token transfer, such as signature-based.
988      *
989      * Requirements:
990      *
991      * - `from` cannot be the zero address.
992      * - `to` cannot be the zero address.
993      * - `tokenId` token must exist and be owned by `from`.
994      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
995      *
996      * Emits a {Transfer} event.
997      */
998     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
999         _transfer(from, to, tokenId);
1000         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1001     }
1002 
1003     /**
1004      * @dev Returns whether `tokenId` exists.
1005      *
1006      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1007      *
1008      * Tokens start existing when they are minted (`_mint`),
1009      * and stop existing when they are burned (`_burn`).
1010      */
1011     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1012         return _owners[tokenId] != address(0);
1013     }
1014 
1015     /**
1016      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1017      *
1018      * Requirements:
1019      *
1020      * - `tokenId` must exist.
1021      */
1022     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1023         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1024         address owner = ERC721.ownerOf(tokenId);
1025         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1026     }
1027 
1028     /**
1029      * @dev Safely mints `tokenId` and transfers it to `to`.
1030      *
1031      * Requirements:
1032      *
1033      * - `tokenId` must not exist.
1034      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _safeMint(address to, uint256 tokenId) internal virtual {
1039         _safeMint(to, tokenId, "");
1040     }
1041 
1042     /**
1043      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1044      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1045      */
1046     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1047         _mint(to, tokenId);
1048         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1049     }
1050 
1051     /**
1052      * @dev Mints `tokenId` and transfers it to `to`.
1053      *
1054      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must not exist.
1059      * - `to` cannot be the zero address.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _mint(address to, uint256 tokenId) internal virtual {
1064         require(to != address(0), "ERC721: mint to the zero address");
1065         require(!_exists(tokenId), "ERC721: token already minted");
1066 
1067         _beforeTokenTransfer(address(0), to, tokenId, true);
1068 
1069         _balances[to] += 1;
1070         _owners[tokenId] = to;
1071 
1072         emit Transfer(address(0), to, tokenId);
1073     }
1074 
1075     /**
1076      * @dev Destroys `tokenId`.
1077      * The approval is cleared when the token is burned.
1078      *
1079      * Requirements:
1080      *
1081      * - `tokenId` must exist.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _burn(uint256 tokenId) internal virtual {
1086         address owner = ERC721.ownerOf(tokenId);
1087 
1088         _beforeTokenTransfer(owner, address(0), tokenId, true);
1089 
1090         // Clear approvals
1091         _approve(address(0), tokenId);
1092 
1093         _balances[owner] -= 1;
1094         delete _owners[tokenId];
1095 
1096         emit Transfer(owner, address(0), tokenId);
1097     }
1098 
1099     function _burnSave(address owner, uint256 tokenId) internal virtual {
1100 
1101         _beforeTokenTransfer(owner, address(0), tokenId, false);
1102 
1103         // Clear approvals
1104         _approve(address(0), tokenId);
1105 
1106         _balances[owner] -= 1;
1107         delete _owners[tokenId];
1108 
1109         emit Transfer(owner, address(0), tokenId);
1110     }
1111 
1112     /**
1113      * @dev Transfers `tokenId` from `from` to `to`.
1114      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1115      *
1116      * Requirements:
1117      *
1118      * - `to` cannot be the zero address.
1119      * - `tokenId` token must be owned by `from`.
1120      *
1121      * Emits a {Transfer} event.
1122      */
1123     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1124         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1125         require(to != address(0), "ERC721: transfer to the zero address");
1126 
1127         _beforeTokenTransfer(from, to, tokenId, true);
1128 
1129         // Clear approvals from the previous owner
1130         _approve(address(0), tokenId);
1131 
1132         _balances[from] -= 1;
1133         _balances[to] += 1;
1134         _owners[tokenId] = to;
1135 
1136         emit Transfer(from, to, tokenId);
1137     }
1138 
1139     /**
1140      * @dev Approve `to` to operate on `tokenId`
1141      *
1142      * Emits a {Approval} event.
1143      */
1144     function _approve(address to, uint256 tokenId) internal virtual {
1145         _tokenApprovals[tokenId] = to;
1146         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1147     }
1148 
1149     /**
1150      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1151      * The call is not executed if the target address is not a contract.
1152      *
1153      * @param from address representing the previous owner of the given token ID
1154      * @param to target address that will receive the tokens
1155      * @param tokenId uint256 ID of the token to be transferred
1156      * @param _data bytes optional data to send along with the call
1157      * @return bool whether the call correctly returned the expected magic value
1158      */
1159     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1160     private returns (bool)
1161     {
1162         if (to.isContract()) {
1163             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1164                 return retval == IERC721Receiver(to).onERC721Received.selector;
1165             } catch (bytes memory reason) {
1166                 if (reason.length == 0) {
1167                     revert("ERC721: transfer to non ERC721Receiver implementer");
1168                 } else {
1169                     // solhint-disable-next-line no-inline-assembly
1170                     assembly {
1171                         revert(add(32, reason), mload(reason))
1172                     }
1173                 }
1174             }
1175         } else {
1176             return true;
1177         }
1178     }
1179 
1180     /**
1181      * @dev Hook that is called before any token transfer. This includes minting
1182      * and burning.
1183      *
1184      * Calling conditions:
1185      *
1186      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1187      * transferred to `to`.
1188      * - When `from` is zero, `tokenId` will be minted for `to`.
1189      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1190      * - `from` cannot be the zero address.
1191      * - `to` cannot be the zero address.
1192      *
1193      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1194      */
1195     function _beforeTokenTransfer(address from, address to, uint256 tokenId, bool isDelete) internal virtual { }
1196 }
1197 
1198 pragma solidity ^0.8.0;
1199 
1200 /**
1201  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1202  * enumerability of all the token ids in the contract as well as all token ids owned by each
1203  * account.
1204  */
1205 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1206     // Mapping from owner to list of owned token IDs
1207     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1208 
1209     // Mapping from token ID to index of the owner tokens list
1210     mapping(uint256 => uint256) private _ownedTokensIndex;
1211 
1212     // Array with all token ids, used for enumeration
1213     uint256[] private _allTokens;
1214 
1215     // Mapping from token id to position in the allTokens array
1216     mapping(uint256 => uint256) private _allTokensIndex;
1217 
1218     /**
1219      * @dev See {IERC165-supportsInterface}.
1220      */
1221     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1222         return interfaceId == type(IERC721Enumerable).interfaceId
1223         || super.supportsInterface(interfaceId);
1224     }
1225 
1226     /**
1227      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1228      */
1229     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1230         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1231         return _ownedTokens[owner][index];
1232     }
1233 
1234     /**
1235      * @dev See {IERC721Enumerable-totalSupply}.
1236      */
1237     function totalSupply() public view virtual override returns (uint256) {
1238         return _allTokens.length;
1239     }
1240 
1241     /**
1242      * @dev See {IERC721Enumerable-tokenByIndex}.
1243      */
1244     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1245         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1246         return _allTokens[index];
1247     }
1248 
1249     /**
1250      * @dev Hook that is called before any token transfer. This includes minting
1251      * and burning.
1252      *
1253      * Calling conditions:
1254      *
1255      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1256      * transferred to `to`.
1257      * - When `from` is zero, `tokenId` will be minted for `to`.
1258      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1259      * - `from` cannot be the zero address.
1260      * - `to` cannot be the zero address.
1261      *
1262      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1263      */
1264     function _beforeTokenTransfer(address from, address to, uint256 tokenId, bool isDelete) internal virtual override {
1265         super._beforeTokenTransfer(from, to, tokenId, isDelete);
1266 
1267         if (from == address(0)) {
1268             _addTokenToAllTokensEnumeration(tokenId);
1269         } else if (from != to) {
1270             _removeTokenFromOwnerEnumeration(from, tokenId);
1271         }
1272         if (to == address(0) && isDelete) {
1273             _removeTokenFromAllTokensEnumeration(tokenId);
1274         } else if (to != from && isDelete) {
1275             _addTokenToOwnerEnumeration(to, tokenId);
1276         }
1277     }
1278 
1279     /**
1280      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1281      * @param to address representing the new owner of the given token ID
1282      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1283      */
1284     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1285         uint256 length = ERC721.balanceOf(to);
1286         _ownedTokens[to][length] = tokenId;
1287         _ownedTokensIndex[tokenId] = length;
1288     }
1289 
1290     /**
1291      * @dev Private function to add a token to this extension's token tracking data structures.
1292      * @param tokenId uint256 ID of the token to be added to the tokens list
1293      */
1294     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1295         _allTokensIndex[tokenId] = _allTokens.length;
1296         _allTokens.push(tokenId);
1297     }
1298 
1299     /**
1300      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1301      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1302      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1303      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1304      * @param from address representing the previous owner of the given token ID
1305      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1306      */
1307     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1308         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1309         // then delete the last slot (swap and pop).
1310 
1311         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1312         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1313 
1314         // When the token to delete is the last token, the swap operation is unnecessary
1315         if (tokenIndex != lastTokenIndex) {
1316             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1317 
1318             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1319             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1320         }
1321 
1322         // This also deletes the contents at the last position of the array
1323         delete _ownedTokensIndex[tokenId];
1324         delete _ownedTokens[from][lastTokenIndex];
1325     }
1326 
1327     /**
1328      * @dev Private function to remove a token from this extension's token tracking data structures.
1329      * This has O(1) time complexity, but alters the order of the _allTokens array.
1330      * @param tokenId uint256 ID of the token to be removed from the tokens list
1331      */
1332     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1333         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1334         // then delete the last slot (swap and pop).
1335 
1336         uint256 lastTokenIndex = _allTokens.length - 1;
1337         uint256 tokenIndex = _allTokensIndex[tokenId];
1338 
1339         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1340         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1341         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1342         uint256 lastTokenId = _allTokens[lastTokenIndex];
1343 
1344         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1345         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1346 
1347         // This also deletes the contents at the last position of the array
1348         delete _allTokensIndex[tokenId];
1349         _allTokens.pop();
1350     }
1351 }
1352 
1353 pragma solidity ^0.8.0;
1354 
1355 
1356 contract pixelplanets is ERC721Enumerable, Ownable{
1357     using SafeMath for uint256;
1358     using Address for address;
1359     using Strings for uint256;
1360 
1361 
1362     uint256 public constant NFT_PRICE = 20000000000000000; // 0.02 ETH
1363     uint public constant MAX_NFT_PURCHASE = 5;
1364     uint256 public MAX_SUPPLY = 1000;
1365     bool public saleIsActive = false;
1366 
1367     uint256 public startingIndex;
1368     uint256 public startingIndexBlock;
1369 
1370     string private _baseURIExtended;
1371     mapping (uint256 => string) _tokenURIs;
1372 
1373     constructor() ERC721("Pixel Planets","PLANETS"){
1374     }
1375 
1376 
1377     function flipSaleState() public onlyOwner {
1378         saleIsActive = !saleIsActive;
1379     }
1380 
1381     function withdraw() public onlyOwner {
1382         uint balance = address(this).balance;
1383         payable(msg.sender).transfer(balance);
1384     }
1385 
1386     function reserveTokens(uint256 num) public onlyOwner {
1387         uint supply = totalSupply();
1388         uint i;
1389         for (i = 0; i < num; i++) {
1390             _safeMint(msg.sender, supply + i);
1391         }
1392 
1393         if (startingIndexBlock == 0) {
1394             startingIndexBlock = block.number;
1395         }
1396     }
1397 
1398     function setMaxTokenSupply(uint256 maxSupply) public onlyOwner {
1399         MAX_SUPPLY = maxSupply;
1400     }
1401     
1402     function mint() public payable {
1403         require(saleIsActive, "Sale is not active at the moment");
1404         require((totalSupply() + 1) <= MAX_SUPPLY, "Purchase would exceed max supply");
1405         require(NFT_PRICE == msg.value, "Sent ether value is incorrect, mint cost is 0.02 ether");
1406         
1407         if ((totalSupply() + 1) <= MAX_SUPPLY) {
1408             _safeMint(msg.sender, totalSupply());
1409         }
1410         
1411     }
1412 
1413     function mint5() public payable {
1414         require(saleIsActive, "Sale is not active at the moment");
1415         require(totalSupply().add(5) <= MAX_SUPPLY, "Purchase would exceed max supply");
1416         require(NFT_PRICE.mul(5) == msg.value, "Must Send 0.1 ETH to Mint 5 NFTs");
1417 
1418         for (uint i = 0; i < 5; i++) {
1419             _safeMint(msg.sender, totalSupply());
1420         }
1421     }
1422 
1423 
1424     function calcStartingIndex() public onlyOwner {
1425         require(startingIndex == 0, "Starting index has already been set");
1426         require(startingIndexBlock != 0, "Starting index has not been set yet");
1427 
1428         startingIndex = uint(blockhash(startingIndexBlock)) % MAX_SUPPLY;
1429         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1430         if(block.number.sub(startingIndexBlock) > 255) {
1431             startingIndex = uint(blockhash(block.number - 1)) % MAX_SUPPLY;
1432         }
1433 
1434         // To prevent original sequence
1435         if (startingIndex == 0) {
1436             startingIndex = startingIndex.add(1);
1437         }
1438     }
1439 
1440     function emergencySetStartingIndexBlock() public onlyOwner {
1441         require(startingIndex == 0, "Starting index is already set");
1442         startingIndexBlock = block.number;
1443     }
1444 
1445     function _baseURI() internal view virtual override returns (string memory) {
1446         return _baseURIExtended;
1447     }
1448 
1449     // Sets base URI for all tokens, only able to be called by contract owner
1450     function setBaseURI(string memory baseURI_) external onlyOwner {
1451         _baseURIExtended = baseURI_;
1452     }
1453     
1454 
1455     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1456         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1457 
1458         string memory _tokenURI = _tokenURIs[tokenId];
1459         string memory base = _baseURI();
1460 
1461         // If there is no base URI, return the token URI.
1462         if (bytes(base).length == 0) {
1463             return _tokenURI;
1464         }
1465         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1466         if (bytes(_tokenURI).length > 0) {
1467             return string(abi.encodePacked(base, _tokenURI));
1468         }
1469         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1470         return string(abi.encodePacked(base, tokenId.toString()));
1471     }
1472 }