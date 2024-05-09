1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 
27 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
28 
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
67      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
68      *
69      * Requirements:
70      *
71      * - `from` cannot be the zero address.
72      * - `to` cannot be the zero address.
73      * - `tokenId` token must exist and be owned by `from`.
74      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
75      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
76      *
77      * Emits a {Transfer} event.
78      */
79     function safeTransferFrom(
80         address from,
81         address to,
82         uint256 tokenId
83     ) external;
84 
85     /**
86      * @dev Transfers `tokenId` token from `from` to `to`.
87      *
88      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must be owned by `from`.
95      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
107      * The approval is cleared when the token is transferred.
108      *
109      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
110      *
111      * Requirements:
112      *
113      * - The caller must own the token or be an approved operator.
114      * - `tokenId` must exist.
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Returns the account approved for `tokenId` token.
122      *
123      * Requirements:
124      *
125      * - `tokenId` must exist.
126      */
127     function getApproved(uint256 tokenId) external view returns (address operator);
128 
129     /**
130      * @dev Approve or remove `operator` as an operator for the caller.
131      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
132      *
133      * Requirements:
134      *
135      * - The `operator` cannot be the caller.
136      *
137      * Emits an {ApprovalForAll} event.
138      */
139     function setApprovalForAll(address operator, bool _approved) external;
140 
141     /**
142      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
143      *
144      * See {setApprovalForAll}
145      */
146     function isApprovedForAll(address owner, address operator) external view returns (bool);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId,
165         bytes calldata data
166     ) external;
167 }
168 
169 
170 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
171 
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @title ERC721 token receiver interface
177  * @dev Interface for any contract that wants to support safeTransfers
178  * from ERC721 asset contracts.
179  */
180 interface IERC721Receiver {
181     /**
182      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
183      * by `operator` from `from`, this function is called.
184      *
185      * It must return its Solidity selector to confirm the token transfer.
186      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
187      *
188      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
189      */
190     function onERC721Received(
191         address operator,
192         address from,
193         uint256 tokenId,
194         bytes calldata data
195     ) external returns (bytes4);
196 }
197 
198 
199 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
200 
201 
202 pragma solidity ^0.8.0;
203 
204 /**
205  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
206  * @dev See https://eips.ethereum.org/EIPS/eip-721
207  */
208 interface IERC721Metadata is IERC721 {
209     /**
210      * @dev Returns the token collection name.
211      */
212     function name() external view returns (string memory);
213 
214     /**
215      * @dev Returns the token collection symbol.
216      */
217     function symbol() external view returns (string memory);
218 
219     /**
220      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
221      */
222     function tokenURI(uint256 tokenId) external view returns (string memory);
223 }
224 
225 
226 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
227 
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @dev Collection of functions related to the address type
233  */
234 library Address {
235     /**
236      * @dev Returns true if `account` is a contract.
237      *
238      * [IMPORTANT]
239      * ====
240      * It is unsafe to assume that an address for which this function returns
241      * false is an externally-owned account (EOA) and not a contract.
242      *
243      * Among others, `isContract` will return false for the following
244      * types of addresses:
245      *
246      *  - an externally-owned account
247      *  - a contract in construction
248      *  - an address where a contract will be created
249      *  - an address where a contract lived, but was destroyed
250      * ====
251      */
252     function isContract(address account) internal view returns (bool) {
253         // This method relies on extcodesize, which returns 0 for contracts in
254         // construction, since the code is only stored at the end of the
255         // constructor execution.
256 
257         uint256 size;
258         assembly {
259             size := extcodesize(account)
260         }
261         return size > 0;
262     }
263 
264     /**
265      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
266      * `recipient`, forwarding all available gas and reverting on errors.
267      *
268      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
269      * of certain opcodes, possibly making contracts go over the 2300 gas limit
270      * imposed by `transfer`, making them unable to receive funds via
271      * `transfer`. {sendValue} removes this limitation.
272      *
273      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
274      *
275      * IMPORTANT: because control is transferred to `recipient`, care must be
276      * taken to not create reentrancy vulnerabilities. Consider using
277      * {ReentrancyGuard} or the
278      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
279      */
280     function sendValue(address payable recipient, uint256 amount) internal {
281         require(address(this).balance >= amount, "Address: insufficient balance");
282 
283         (bool success, ) = recipient.call{value: amount}("");
284         require(success, "Address: unable to send value, recipient may have reverted");
285     }
286 
287     /**
288      * @dev Performs a Solidity function call using a low level `call`. A
289      * plain `call` is an unsafe replacement for a function call: use this
290      * function instead.
291      *
292      * If `target` reverts with a revert reason, it is bubbled up by this
293      * function (like regular Solidity function calls).
294      *
295      * Returns the raw returned data. To convert to the expected return value,
296      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
297      *
298      * Requirements:
299      *
300      * - `target` must be a contract.
301      * - calling `target` with `data` must not revert.
302      *
303      * _Available since v3.1._
304      */
305     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
306         return functionCall(target, data, "Address: low-level call failed");
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
311      * `errorMessage` as a fallback revert reason when `target` reverts.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(
316         address target,
317         bytes memory data,
318         string memory errorMessage
319     ) internal returns (bytes memory) {
320         return functionCallWithValue(target, data, 0, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but also transferring `value` wei to `target`.
326      *
327      * Requirements:
328      *
329      * - the calling contract must have an ETH balance of at least `value`.
330      * - the called Solidity function must be `payable`.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(
335         address target,
336         bytes memory data,
337         uint256 value
338     ) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
344      * with `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(
349         address target,
350         bytes memory data,
351         uint256 value,
352         string memory errorMessage
353     ) internal returns (bytes memory) {
354         require(address(this).balance >= value, "Address: insufficient balance for call");
355         require(isContract(target), "Address: call to non-contract");
356 
357         (bool success, bytes memory returndata) = target.call{value: value}(data);
358         return _verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but performing a static call.
364      *
365      * _Available since v3.3._
366      */
367     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
368         return functionStaticCall(target, data, "Address: low-level static call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
373      * but performing a static call.
374      *
375      * _Available since v3.3._
376      */
377     function functionStaticCall(
378         address target,
379         bytes memory data,
380         string memory errorMessage
381     ) internal view returns (bytes memory) {
382         require(isContract(target), "Address: static call to non-contract");
383 
384         (bool success, bytes memory returndata) = target.staticcall(data);
385         return _verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but performing a delegate call.
391      *
392      * _Available since v3.4._
393      */
394     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
395         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
400      * but performing a delegate call.
401      *
402      * _Available since v3.4._
403      */
404     function functionDelegateCall(
405         address target,
406         bytes memory data,
407         string memory errorMessage
408     ) internal returns (bytes memory) {
409         require(isContract(target), "Address: delegate call to non-contract");
410 
411         (bool success, bytes memory returndata) = target.delegatecall(data);
412         return _verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     function _verifyCallResult(
416         bool success,
417         bytes memory returndata,
418         string memory errorMessage
419     ) private pure returns (bytes memory) {
420         if (success) {
421             return returndata;
422         } else {
423             // Look for revert reason and bubble it up if present
424             if (returndata.length > 0) {
425                 // The easiest way to bubble the revert reason is using memory via assembly
426 
427                 assembly {
428                     let returndata_size := mload(returndata)
429                     revert(add(32, returndata), returndata_size)
430                 }
431             } else {
432                 revert(errorMessage);
433             }
434         }
435     }
436 }
437 
438 
439 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
440 
441 
442 pragma solidity ^0.8.0;
443 
444 /*
445  * @dev Provides information about the current execution context, including the
446  * sender of the transaction and its data. While these are generally available
447  * via msg.sender and msg.data, they should not be accessed in such a direct
448  * manner, since when dealing with meta-transactions the account sending and
449  * paying for execution may not be the actual sender (as far as an application
450  * is concerned).
451  *
452  * This contract is only required for intermediate, library-like contracts.
453  */
454 abstract contract Context {
455 
456     function _msgSender() internal view virtual returns (address) {
457         return msg.sender;
458     }
459 
460     function _msgData() internal view virtual returns (bytes calldata) {
461         return msg.data;
462     }
463 }
464 
465 // File @openzeppelin/contracts/utils/math/SaftMath.sol
466 pragma solidity ^0.8.0;
467 
468 // CAUTION
469 // This version of SafeMath should only be used with Solidity 0.8 or later,
470 // because it relies on the compiler's built in overflow checks.
471 
472 /**
473  * @dev Wrappers over Solidity's arithmetic operations.
474  *
475  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
476  * now has built in overflow checking.
477  */
478 library SafeMath {
479     /**
480      * @dev Returns the addition of two unsigned integers, with an overflow flag.
481      *
482      * _Available since v3.4._
483      */
484     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
485         unchecked {
486             uint256 c = a + b;
487             if (c < a) return (false, 0);
488             return (true, c);
489         }
490     }
491 
492     /**
493      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
494      *
495      * _Available since v3.4._
496      */
497     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
498         unchecked {
499             if (b > a) return (false, 0);
500             return (true, a - b);
501         }
502     }
503 
504     /**
505      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
506      *
507      * _Available since v3.4._
508      */
509     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
510         unchecked {
511             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
512             // benefit is lost if 'b' is also tested.
513             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
514             if (a == 0) return (true, 0);
515             uint256 c = a * b;
516             if (c / a != b) return (false, 0);
517             return (true, c);
518         }
519     }
520 
521     /**
522      * @dev Returns the division of two unsigned integers, with a division by zero flag.
523      *
524      * _Available since v3.4._
525      */
526     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
527         unchecked {
528             if (b == 0) return (false, 0);
529             return (true, a / b);
530         }
531     }
532 
533     /**
534      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
535      *
536      * _Available since v3.4._
537      */
538     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
539         unchecked {
540             if (b == 0) return (false, 0);
541             return (true, a % b);
542         }
543     }
544 
545     /**
546      * @dev Returns the addition of two unsigned integers, reverting on
547      * overflow.
548      *
549      * Counterpart to Solidity's `+` operator.
550      *
551      * Requirements:
552      *
553      * - Addition cannot overflow.
554      */
555     function add(uint256 a, uint256 b) internal pure returns (uint256) {
556         return a + b;
557     }
558 
559     /**
560      * @dev Returns the subtraction of two unsigned integers, reverting on
561      * overflow (when the result is negative).
562      *
563      * Counterpart to Solidity's `-` operator.
564      *
565      * Requirements:
566      *
567      * - Subtraction cannot overflow.
568      */
569     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
570         return a - b;
571     }
572 
573     /**
574      * @dev Returns the multiplication of two unsigned integers, reverting on
575      * overflow.
576      *
577      * Counterpart to Solidity's `*` operator.
578      *
579      * Requirements:
580      *
581      * - Multiplication cannot overflow.
582      */
583     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
584         return a * b;
585     }
586 
587     /**
588      * @dev Returns the integer division of two unsigned integers, reverting on
589      * division by zero. The result is rounded towards zero.
590      *
591      * Counterpart to Solidity's `/` operator.
592      *
593      * Requirements:
594      *
595      * - The divisor cannot be zero.
596      */
597     function div(uint256 a, uint256 b) internal pure returns (uint256) {
598         return a / b;
599     }
600 
601     /**
602      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
603      * reverting when dividing by zero.
604      *
605      * Counterpart to Solidity's `%` operator. This function uses a `revert`
606      * opcode (which leaves remaining gas untouched) while Solidity uses an
607      * invalid opcode to revert (consuming all remaining gas).
608      *
609      * Requirements:
610      *
611      * - The divisor cannot be zero.
612      */
613     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
614         return a % b;
615     }
616 
617     /**
618      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
619      * overflow (when the result is negative).
620      *
621      * CAUTION: This function is deprecated because it requires allocating memory for the error
622      * message unnecessarily. For custom revert reasons use {trySub}.
623      *
624      * Counterpart to Solidity's `-` operator.
625      *
626      * Requirements:
627      *
628      * - Subtraction cannot overflow.
629      */
630     function sub(
631         uint256 a,
632         uint256 b,
633         string memory errorMessage
634     ) internal pure returns (uint256) {
635         unchecked {
636             require(b <= a, errorMessage);
637             return a - b;
638         }
639     }
640 
641     /**
642      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
643      * division by zero. The result is rounded towards zero.
644      *
645      * Counterpart to Solidity's `/` operator. Note: this function uses a
646      * `revert` opcode (which leaves remaining gas untouched) while Solidity
647      * uses an invalid opcode to revert (consuming all remaining gas).
648      *
649      * Requirements:
650      *
651      * - The divisor cannot be zero.
652      */
653     function div(
654         uint256 a,
655         uint256 b,
656         string memory errorMessage
657     ) internal pure returns (uint256) {
658         unchecked {
659             require(b > 0, errorMessage);
660             return a / b;
661         }
662     }
663 
664     /**
665      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
666      * reverting with custom message when dividing by zero.
667      *
668      * CAUTION: This function is deprecated because it requires allocating memory for the error
669      * message unnecessarily. For custom revert reasons use {tryMod}.
670      *
671      * Counterpart to Solidity's `%` operator. This function uses a `revert`
672      * opcode (which leaves remaining gas untouched) while Solidity uses an
673      * invalid opcode to revert (consuming all remaining gas).
674      *
675      * Requirements:
676      *
677      * - The divisor cannot be zero.
678      */
679     function mod(
680         uint256 a,
681         uint256 b,
682         string memory errorMessage
683     ) internal pure returns (uint256) {
684         unchecked {
685             require(b > 0, errorMessage);
686             return a % b;
687         }
688     }
689 }
690 
691 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
692 
693 
694 
695 pragma solidity ^0.8.0;
696 
697 /**
698  * @dev String operations.
699  */
700 library Strings {
701     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
702 
703     /**
704      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
705      */
706     function toString(uint256 value) internal pure returns (string memory) {
707         // Inspired by OraclizeAPI's implementation - MIT licence
708         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
709 
710         if (value == 0) {
711             return "0";
712         }
713         uint256 temp = value;
714         uint256 digits;
715         while (temp != 0) {
716             digits++;
717             temp /= 10;
718         }
719         bytes memory buffer = new bytes(digits);
720         while (value != 0) {
721             digits -= 1;
722             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
723             value /= 10;
724         }
725         return string(buffer);
726     }
727 
728     /**
729      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
730      */
731     function toHexString(uint256 value) internal pure returns (string memory) {
732         if (value == 0) {
733             return "0x00";
734         }
735         uint256 temp = value;
736         uint256 length = 0;
737         while (temp != 0) {
738             length++;
739             temp >>= 8;
740         }
741         return toHexString(value, length);
742     }
743 
744     /**
745      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
746      */
747     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
748         bytes memory buffer = new bytes(2 * length + 2);
749         buffer[0] = "0";
750         buffer[1] = "x";
751         for (uint256 i = 2 * length + 1; i > 1; --i) {
752             buffer[i] = _HEX_SYMBOLS[value & 0xf];
753             value >>= 4;
754         }
755         require(value == 0, "Strings: hex length insufficient");
756         return string(buffer);
757     }
758 }
759 
760 
761 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
762 
763 
764 pragma solidity ^0.8.0;
765 
766 /**
767  * @dev Implementation of the {IERC165} interface.
768  *
769  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
770  * for the additional interface id that will be supported. For example:
771  *
772  * ```solidity
773  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
774  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
775  * }
776  * ```
777  *
778  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
779  */
780 abstract contract ERC165 is IERC165 {
781     /**
782      * @dev See {IERC165-supportsInterface}.
783      */
784     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
785         return interfaceId == type(IERC165).interfaceId;
786     }
787 }
788 
789 
790 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.2.0
791 
792 
793 pragma solidity ^0.8.0;
794 
795 
796 
797 
798 
799 
800 
801 /**
802  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
803  * the Metadata extension, but not including the Enumerable extension, which is available separately as
804  * {ERC721Enumerable}.
805  */
806 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
807     using Address for address;
808     using Strings for uint256;
809 
810     // Token name
811     string private _name;
812 
813     // Token symbol
814     string private _symbol;
815 
816     // Mapping from token ID to owner address
817     mapping(uint256 => address) private _owners;
818 
819     // Mapping owner address to token count
820     mapping(address => uint256) private _balances;
821 
822     // Mapping from token ID to approved address
823     mapping(uint256 => address) private _tokenApprovals;
824 
825     // Mapping from owner to operator approvals
826     mapping(address => mapping(address => bool)) private _operatorApprovals;
827 
828     /**
829      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
830      */
831     constructor(string memory name_, string memory symbol_) {
832         _name = name_;
833         _symbol = symbol_;
834     }
835 
836     /**
837      * @dev See {IERC165-supportsInterface}.
838      */
839     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
840         return
841             interfaceId == type(IERC721).interfaceId ||
842             interfaceId == type(IERC721Metadata).interfaceId ||
843             super.supportsInterface(interfaceId);
844     }
845 
846     /**
847      * @dev See {IERC721-balanceOf}.
848      */
849     function balanceOf(address owner) public view virtual override returns (uint256) {
850         require(owner != address(0), "ERC721: balance query for the zero address");
851         return _balances[owner];
852     }
853 
854     /**
855      * @dev See {IERC721-ownerOf}.
856      */
857     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
858         address owner = _owners[tokenId];
859         require(owner != address(0), "ERC721: owner query for nonexistent token");
860         return owner;
861     }
862 
863     /**
864      * @dev See {IERC721Metadata-name}.
865      */
866     function name() public view virtual override returns (string memory) {
867         return _name;
868     }
869 
870     /**
871      * @dev See {IERC721Metadata-symbol}.
872      */
873     function symbol() public view virtual override returns (string memory) {
874         return _symbol;
875     }
876 
877     /**
878      * @dev See {IERC721Metadata-tokenURI}.
879      */
880     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
881         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
882 
883         string memory baseURI = _baseURI();
884         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
885     }
886 
887     /**
888      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
889      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
890      * by default, can be overriden in child contracts.
891      */
892     function _baseURI() internal view virtual returns (string memory) {
893         return "";
894     }
895 
896     /**
897      * @dev See {IERC721-approve}.
898      */
899     function approve(address to, uint256 tokenId) public virtual override {
900         address owner = ERC721.ownerOf(tokenId);
901         require(to != owner, "ERC721: approval to current owner");
902 
903         require(
904             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
905             "ERC721: approve caller is not owner nor approved for all"
906         );
907 
908         _approve(to, tokenId);
909     }
910 
911     /**
912      * @dev See {IERC721-getApproved}.
913      */
914     function getApproved(uint256 tokenId) public view virtual override returns (address) {
915         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
916 
917         return _tokenApprovals[tokenId];
918     }
919 
920     /**
921      * @dev See {IERC721-setApprovalForAll}.
922      */
923     function setApprovalForAll(address operator, bool approved) public virtual override {
924         require(operator != _msgSender(), "ERC721: approve to caller");
925 
926         _operatorApprovals[_msgSender()][operator] = approved;
927         emit ApprovalForAll(_msgSender(), operator, approved);
928     }
929 
930     /**
931      * @dev See {IERC721-isApprovedForAll}.
932      */
933     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
934         return _operatorApprovals[owner][operator];
935     }
936 
937     /**
938      * @dev See {IERC721-transferFrom}.
939      */
940     function transferFrom(
941         address from,
942         address to,
943         uint256 tokenId
944     ) public virtual override {
945         //solhint-disable-next-line max-line-length
946         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
947 
948         _transfer(from, to, tokenId);
949     }
950 
951     /**
952      * @dev See {IERC721-safeTransferFrom}.
953      */
954     function safeTransferFrom(
955         address from,
956         address to,
957         uint256 tokenId
958     ) public virtual override {
959         safeTransferFrom(from, to, tokenId, "");
960     }
961 
962     /**
963      * @dev See {IERC721-safeTransferFrom}.
964      */
965     function safeTransferFrom(
966         address from,
967         address to,
968         uint256 tokenId,
969         bytes memory _data
970     ) public virtual override {
971         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
972         _safeTransfer(from, to, tokenId, _data);
973     }
974 
975     /**
976      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
977      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
978      *
979      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
980      *
981      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
982      * implement alternative mechanisms to perform token transfer, such as signature-based.
983      *
984      * Requirements:
985      *
986      * - `from` cannot be the zero address.
987      * - `to` cannot be the zero address.
988      * - `tokenId` token must exist and be owned by `from`.
989      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _safeTransfer(
994         address from,
995         address to,
996         uint256 tokenId,
997         bytes memory _data
998     ) internal virtual {
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
1046     function _safeMint(
1047         address to,
1048         uint256 tokenId,
1049         bytes memory _data
1050     ) internal virtual {
1051         _mint(to, tokenId);
1052         require(
1053             _checkOnERC721Received(address(0), to, tokenId, _data),
1054             "ERC721: transfer to non ERC721Receiver implementer"
1055         );
1056     }
1057 
1058     /**
1059      * @dev Mints `tokenId` and transfers it to `to`.
1060      *
1061      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1062      *
1063      * Requirements:
1064      *
1065      * - `tokenId` must not exist.
1066      * - `to` cannot be the zero address.
1067      *
1068      * Emits a {Transfer} event.
1069      */
1070     function _mint(address to, uint256 tokenId) internal virtual {
1071         require(to != address(0), "ERC721: mint to the zero address");
1072         require(!_exists(tokenId), "ERC721: token already minted");
1073 
1074         _beforeTokenTransfer(address(0), to, tokenId);
1075 
1076         _balances[to] += 1;
1077         _owners[tokenId] = to;
1078 
1079         emit Transfer(address(0), to, tokenId);
1080     }
1081 
1082     /**
1083      * @dev Destroys `tokenId`.
1084      * The approval is cleared when the token is burned.
1085      *
1086      * Requirements:
1087      *
1088      * - `tokenId` must exist.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _burn(uint256 tokenId) internal virtual {
1093         address owner = ERC721.ownerOf(tokenId);
1094 
1095         _beforeTokenTransfer(owner, address(0), tokenId);
1096 
1097         // Clear approvals
1098         _approve(address(0), tokenId);
1099 
1100         _balances[owner] -= 1;
1101         delete _owners[tokenId];
1102 
1103         emit Transfer(owner, address(0), tokenId);
1104     }
1105 
1106     /**
1107      * @dev Transfers `tokenId` from `from` to `to`.
1108      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1109      *
1110      * Requirements:
1111      *
1112      * - `to` cannot be the zero address.
1113      * - `tokenId` token must be owned by `from`.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function _transfer(
1118         address from,
1119         address to,
1120         uint256 tokenId
1121     ) internal virtual {
1122         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1123         require(to != address(0), "ERC721: transfer to the zero address");
1124 
1125         _beforeTokenTransfer(from, to, tokenId);
1126 
1127         // Clear approvals from the previous owner
1128         _approve(address(0), tokenId);
1129 
1130         _balances[from] -= 1;
1131         _balances[to] += 1;
1132         _owners[tokenId] = to;
1133 
1134         emit Transfer(from, to, tokenId);
1135     }
1136 
1137     /**
1138      * @dev Approve `to` to operate on `tokenId`
1139      *
1140      * Emits a {Approval} event.
1141      */
1142     function _approve(address to, uint256 tokenId) internal virtual {
1143         _tokenApprovals[tokenId] = to;
1144         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1145     }
1146 
1147     /**
1148      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1149      * The call is not executed if the target address is not a contract.
1150      *
1151      * @param from address representing the previous owner of the given token ID
1152      * @param to target address that will receive the tokens
1153      * @param tokenId uint256 ID of the token to be transferred
1154      * @param _data bytes optional data to send along with the call
1155      * @return bool whether the call correctly returned the expected magic value
1156      */
1157     function _checkOnERC721Received(
1158         address from,
1159         address to,
1160         uint256 tokenId,
1161         bytes memory _data
1162     ) private returns (bool) {
1163         if (to.isContract()) {
1164             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1165                 return retval == IERC721Receiver(to).onERC721Received.selector;
1166             } catch (bytes memory reason) {
1167                 if (reason.length == 0) {
1168                     revert("ERC721: transfer to non ERC721Receiver implementer");
1169                 } else {
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
1190      * - `from` and `to` are never both zero.
1191      *
1192      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1193      */
1194     function _beforeTokenTransfer(
1195         address from,
1196         address to,
1197         uint256 tokenId
1198     ) internal virtual {}
1199 }
1200 
1201 
1202 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
1203 
1204 
1205 pragma solidity ^0.8.0;
1206 
1207 /**
1208  * @dev Contract module which provides a basic access control mechanism, where
1209  * there is an account (an owner) that can be granted exclusive access to
1210  * specific functions.
1211  *
1212  * By default, the owner account will be the one that deploys the contract. This
1213  * can later be changed with {transferOwnership}.
1214  *
1215  * This module is used through inheritance. It will make available the modifier
1216  * `onlyOwner`, which can be applied to your functions to restrict their use to
1217  * the owner.
1218  */
1219 abstract contract Ownable is Context {
1220     address private _owner;
1221 
1222     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1223 
1224     /**
1225      * @dev Initializes the contract setting the deployer as the initial owner.
1226      */
1227     constructor() {
1228         _setOwner(_msgSender());
1229     }
1230 
1231     /**
1232      * @dev Returns the address of the current owner.
1233      */
1234     function owner() public view virtual returns (address) {
1235         return _owner;
1236     }
1237 
1238     /**
1239      * @dev Throws if called by any account other than the owner.
1240      */
1241     modifier onlyOwner() {
1242         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1243         _;
1244     }
1245 
1246     /**
1247      * @dev Leaves the contract without owner. It will not be possible to call
1248      * `onlyOwner` functions anymore. Can only be called by the current owner.
1249      * 
1250      * NOTE: Renouncing ownership will leave the contract without an owner,
1251      * thereby removing any functionality that is only available to the owner.
1252      */
1253     function renounceOwnership() public virtual onlyOwner {
1254         emit OwnershipTransferred(_owner, address(0));
1255         _owner = address(0);
1256     }
1257 
1258     /**
1259      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1260      * Can only be called by the current owner.
1261      */
1262     function transferOwnership(address newOwner) public virtual onlyOwner {
1263         require(newOwner != address(0), "Ownable: new owner is the zero address");
1264         _setOwner(newOwner);
1265     }
1266 
1267     function _setOwner(address newOwner) private {
1268         address oldOwner = _owner;
1269         _owner = newOwner;
1270         emit OwnershipTransferred(oldOwner, newOwner);
1271     }
1272 }
1273 
1274 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
1275 
1276 pragma solidity ^0.8.0;
1277 
1278 /**
1279  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1280  * @dev See https://eips.ethereum.org/EIPS/eip-721
1281  */
1282 interface IERC721Enumerable is IERC721 {
1283     /**
1284      * @dev Returns the total amount of tokens stored by the contract.
1285      */
1286     function totalSupply() external view returns (uint256);
1287 
1288     /**
1289      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1290      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1291      */
1292     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1293 
1294     /**
1295      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1296      * Use along with {totalSupply} to enumerate all tokens.
1297      */
1298     function tokenByIndex(uint256 index) external view returns (uint256);
1299 }
1300 
1301 
1302 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.2.0
1303 
1304 
1305 pragma solidity ^0.8.0;
1306 
1307 
1308 /**
1309  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1310  * enumerability of all the token ids in the contract as well as all token ids owned by each
1311  * account.
1312  */
1313 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1314     // Mapping from owner to list of owned token IDs
1315     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1316 
1317     // Mapping from token ID to index of the owner tokens list
1318     mapping(uint256 => uint256) private _ownedTokensIndex;
1319 
1320     // Array with all token ids, used for enumeration
1321     uint256[] private _allTokens;
1322 
1323     // Mapping from token id to position in the allTokens array
1324     mapping(uint256 => uint256) private _allTokensIndex;
1325 
1326     /**
1327      * @dev See {IERC165-supportsInterface}.
1328      */
1329     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1330         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1331     }
1332 
1333     /**
1334      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1335      */
1336     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1337         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1338         return _ownedTokens[owner][index];
1339     }
1340 
1341     /**
1342      * @dev See {IERC721Enumerable-totalSupply}.
1343      */
1344     function totalSupply() public view virtual override returns (uint256) {
1345         return _allTokens.length;
1346     }
1347 
1348     /**
1349      * @dev See {IERC721Enumerable-tokenByIndex}.
1350      */
1351     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1352         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1353         return _allTokens[index];
1354     }
1355 
1356     /**
1357      * @dev Hook that is called before any token transfer. This includes minting
1358      * and burning.
1359      *
1360      * Calling conditions:
1361      *
1362      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1363      * transferred to `to`.
1364      * - When `from` is zero, `tokenId` will be minted for `to`.
1365      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1366      * - `from` cannot be the zero address.
1367      * - `to` cannot be the zero address.
1368      *
1369      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1370      */
1371     function _beforeTokenTransfer(
1372         address from,
1373         address to,
1374         uint256 tokenId
1375     ) internal virtual override {
1376         super._beforeTokenTransfer(from, to, tokenId);
1377 
1378         if (from == address(0)) {
1379             _addTokenToAllTokensEnumeration(tokenId);
1380         } else if (from != to) {
1381             _removeTokenFromOwnerEnumeration(from, tokenId);
1382         }
1383         if (to == address(0)) {
1384             _removeTokenFromAllTokensEnumeration(tokenId);
1385         } else if (to != from) {
1386             _addTokenToOwnerEnumeration(to, tokenId);
1387         }
1388     }
1389 
1390     /**
1391      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1392      * @param to address representing the new owner of the given token ID
1393      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1394      */
1395     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1396         uint256 length = ERC721.balanceOf(to);
1397         _ownedTokens[to][length] = tokenId;
1398         _ownedTokensIndex[tokenId] = length;
1399     }
1400 
1401     /**
1402      * @dev Private function to add a token to this extension's token tracking data structures.
1403      * @param tokenId uint256 ID of the token to be added to the tokens list
1404      */
1405     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1406         _allTokensIndex[tokenId] = _allTokens.length;
1407         _allTokens.push(tokenId);
1408     }
1409 
1410     /**
1411      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1412      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1413      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1414      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1415      * @param from address representing the previous owner of the given token ID
1416      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1417      */
1418     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1419         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1420         // then delete the last slot (swap and pop).
1421 
1422         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1423         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1424 
1425         // When the token to delete is the last token, the swap operation is unnecessary
1426         if (tokenIndex != lastTokenIndex) {
1427             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1428 
1429             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1430             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1431         }
1432 
1433         // This also deletes the contents at the last position of the array
1434         delete _ownedTokensIndex[tokenId];
1435         delete _ownedTokens[from][lastTokenIndex];
1436     }
1437 
1438     /**
1439      * @dev Private function to remove a token from this extension's token tracking data structures.
1440      * This has O(1) time complexity, but alters the order of the _allTokens array.
1441      * @param tokenId uint256 ID of the token to be removed from the tokens list
1442      */
1443     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1444         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1445         // then delete the last slot (swap and pop).
1446 
1447         uint256 lastTokenIndex = _allTokens.length - 1;
1448         uint256 tokenIndex = _allTokensIndex[tokenId];
1449 
1450         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1451         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1452         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1453         uint256 lastTokenId = _allTokens[lastTokenIndex];
1454 
1455         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1456         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1457 
1458         // This also deletes the contents at the last position of the array
1459         delete _allTokensIndex[tokenId];
1460         _allTokens.pop();
1461     }
1462 }
1463 
1464 
1465 pragma solidity ^0.8.0;
1466 
1467 /**
1468  * @title Counters
1469  * @author Matt Condon (@shrugs)
1470  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1471  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1472  *
1473  * Include with `using Counters for Counters.Counter;`
1474  */
1475 library Counters {
1476     struct Counter {
1477         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1478         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1479         // this feature: see https://github.com/ethereum/solidity/issues/4637
1480         uint256 _value; // default: 0
1481     }
1482 
1483     function current(Counter storage counter) internal view returns (uint256) {
1484         return counter._value;
1485     }
1486 
1487     function increment(Counter storage counter) internal {
1488         unchecked {
1489             counter._value += 1;
1490         }
1491     }
1492 
1493     function decrement(Counter storage counter) internal {
1494         uint256 value = counter._value;
1495         require(value > 0, 'Counter: decrement overflow');
1496         unchecked {
1497             counter._value = value - 1;
1498         }
1499     }
1500 }
1501 
1502 pragma solidity ^0.8.0;
1503 
1504 /**
1505  * @title ERC721 Burnable Token
1506  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1507  */
1508 abstract contract ERC721Burnable is Context, ERC721 {
1509     /**
1510      * @dev Burns `tokenId`. See {ERC721-_burn}.
1511      *
1512      * Requirements:
1513      *
1514      * - The caller must own `tokenId` or be an approved operator.
1515      */
1516     function burn(uint256 tokenId) public virtual {
1517         //solhint-disable-next-line max-line-length
1518         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721Burnable: caller is not owner nor approved');
1519         _burn(tokenId);
1520     }
1521 }
1522 
1523 pragma solidity ^0.8.0;
1524 library MerkleProof {
1525     /**
1526      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1527      * defined by `root`. For this, a `proof` must be provided, containing
1528      * sibling hashes on the branch from the leaf to the root of the tree. Each
1529      * pair of leaves and each pair of pre-images are assumed to be sorted.
1530      */
1531     function verify(
1532         bytes32[] memory proof,
1533         bytes32 root,
1534         bytes32 leaf
1535     ) internal pure returns (bool) {
1536         return processProof(proof, leaf) == root;
1537     }
1538 
1539     /**
1540      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1541      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1542      * hash matches the root of the tree. When processing the proof, the pairs
1543      * of leafs & pre-images are assumed to be sorted.
1544      *
1545      * _Available since v4.4._
1546      */
1547     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1548         bytes32 computedHash = leaf;
1549         for (uint256 i = 0; i < proof.length; i++) {
1550             bytes32 proofElement = proof[i];
1551             if (computedHash <= proofElement) {
1552                 // Hash(current computed hash + current element of the proof)
1553                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1554             } else {
1555                 // Hash(current element of the proof + current computed hash)
1556                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1557             }
1558         }
1559         return computedHash;
1560     }
1561 }
1562 
1563 
1564 pragma solidity ^0.8.0;
1565 
1566 contract UnBankable is ERC721, ERC721Enumerable, Ownable,ERC721Burnable {
1567 
1568     using Counters for Counters.Counter;
1569     using SafeMath for uint256;
1570     using Strings for uint256;
1571 
1572     Counters.Counter private _tokenIdCounter;
1573     uint256 private  tokenPrice = 0; // 0.09 ETH 90000000000000000
1574     uint256 private  limitTransaction = 1;
1575     uint256 private  limitWallet      = 1;
1576     uint256 public maxSupply = 13462;
1577     bool public saleIsActive = true;
1578     bool public presaleActive = true;
1579     bool public revealed = false;
1580     string public notRevealedUri = "";
1581     string private _baseURIextended;
1582     string private baseExtension = ".json";
1583     bytes32 public merkleRoot = 0xe65be91ecf56e8c8ebe9fa90860753f9b58419ae72b8029371556efd370e4f08;
1584 
1585 
1586     constructor(string memory baseURI, string memory _notrevealURI) ERC721("UB SAFE", "UB") { 
1587         _baseURIextended = baseURI;
1588         notRevealedUri = _notrevealURI;
1589     }
1590  
1591  
1592     function setBaseURI(string memory baseURI_) external onlyOwner() {
1593         _baseURIextended = baseURI_;
1594     }
1595 
1596     function _baseURI() internal view virtual override returns (string memory) {
1597         return _baseURIextended;
1598     }
1599 
1600     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1601         notRevealedUri = _notRevealedURI;
1602     }
1603 
1604     function reveal() external onlyOwner {
1605         revealed = true;
1606     }
1607 
1608     function setBaseExtension(string memory _baseExtension) public onlyOwner {
1609         baseExtension = _baseExtension;
1610     }
1611 
1612     function setMerkleRoot(bytes32 merkleHash) public onlyOwner {
1613         merkleRoot = merkleHash;
1614     }
1615 
1616     function tokenURI(uint256 tokenId)
1617         public
1618         view
1619         virtual
1620         override
1621         returns (string memory)
1622     {
1623         require(
1624         _exists(tokenId),
1625         "ERC721Metadata: URI query for nonexistent token"
1626         );
1627         
1628         if(revealed == false) {
1629             return notRevealedUri;
1630         }
1631 
1632         string memory currentBaseURI = _baseURI();
1633         return bytes(currentBaseURI).length > 0
1634             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(),baseExtension))
1635             : "";
1636     }
1637 
1638     function setTokenPrice(uint256 _price) public onlyOwner {
1639         tokenPrice = _price;
1640     }
1641 
1642     function setLimitWallet(uint256 _limit) public onlyOwner {
1643         limitWallet = _limit;
1644     }
1645 
1646     function setMax(uint256 _supply) external onlyOwner() {
1647         maxSupply = _supply;
1648     }
1649 
1650     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1651         super._beforeTokenTransfer(from, to, tokenId);
1652     }
1653 
1654     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1655         return super.supportsInterface(interfaceId);
1656     }
1657 
1658     function toogleSale() external onlyOwner {
1659         saleIsActive = !saleIsActive;
1660     }
1661 
1662     function togglePresale() external onlyOwner {
1663         presaleActive = !presaleActive;
1664     }
1665 
1666     modifier saleIsOpen {
1667         require(totalToken() <= maxSupply, "Soldout!");
1668         require(saleIsActive, "Sales not open");
1669         _;
1670     }
1671 
1672     function totalToken() public view returns (uint256) {
1673         return _tokenIdCounter.current();
1674     }
1675 
1676     function mintToken(uint256 numberOfTokens, bytes32[] calldata _merkleProof) public payable saleIsOpen {
1677         uint256 total = totalToken();
1678         require(total + numberOfTokens <= maxSupply, "Max limit");
1679         require(numberOfTokens <= limitTransaction, "Exceeded max token purchase per transaction");
1680         require(balanceOf(msg.sender) + numberOfTokens <= limitWallet, "Exceeded max token purchase per wallet");
1681         require(tokenPrice * numberOfTokens <= msg.value, "Ether value sent is not correct");
1682 
1683         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1684         require(presaleActive == false || MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Not whitelist");
1685 
1686         for (uint256 i = 0; i < numberOfTokens; i++) internalMint(msg.sender);    
1687     }
1688 
1689     function internalMint(address to) internal {
1690         _tokenIdCounter.increment();
1691         _safeMint(to, totalToken());
1692     }
1693 
1694     function airdrop(uint8 numberofTokens, address to ) external onlyOwner {
1695         for (uint8 i = 0; i < numberofTokens; i++) internalMint(to);
1696     }
1697 
1698     function _widthdraw(address _address, uint256 _amount) public onlyOwner {
1699         (bool success, ) = _address.call{value: _amount}("");
1700         require(success, "Transfer failed.");
1701     }
1702 
1703     function withdrawAll() public onlyOwner {
1704         uint256 balance = address(this).balance;
1705         require(balance > 0);
1706         _widthdraw(msg.sender, balance);
1707     }
1708 
1709 }