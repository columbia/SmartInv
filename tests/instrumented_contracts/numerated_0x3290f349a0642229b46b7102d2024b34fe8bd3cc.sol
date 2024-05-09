1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 
5 library SafeMath {
6     /**
7      * @dev Returns the addition of two unsigned integers, with an overflow flag.
8      *
9      * _Available since v3.4._
10      */
11     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
12         unchecked {
13             uint256 c = a + b;
14             if (c < a) return (false, 0);
15             return (true, c);
16         }
17     }
18 
19     /**
20      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             if (b > a) return (false, 0);
27             return (true, a - b);
28         }
29     }
30 
31     /**
32      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39             // benefit is lost if 'b' is also tested.
40             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
41             if (a == 0) return (true, 0);
42             uint256 c = a * b;
43             if (c / a != b) return (false, 0);
44             return (true, c);
45         }
46     }
47 
48     /**
49      * @dev Returns the division of two unsigned integers, with a division by zero flag.
50      *
51      * _Available since v3.4._
52      */
53     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
54         unchecked {
55             if (b == 0) return (false, 0);
56             return (true, a / b);
57         }
58     }
59 
60     /**
61      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a % b);
69         }
70     }
71 
72     /**
73      * @dev Returns the addition of two unsigned integers, reverting on
74      * overflow.
75      *
76      * Counterpart to Solidity's `+` operator.
77      *
78      * Requirements:
79      *
80      * - Addition cannot overflow.
81      */
82     function add(uint256 a, uint256 b) internal pure returns (uint256) {
83         return a + b;
84     }
85 
86     /**
87      * @dev Returns the subtraction of two unsigned integers, reverting on
88      * overflow (when the result is negative).
89      *
90      * Counterpart to Solidity's `-` operator.
91      *
92      * Requirements:
93      *
94      * - Subtraction cannot overflow.
95      */
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         return a - b;
98     }
99 
100     /**
101      * @dev Returns the multiplication of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `*` operator.
105      *
106      * Requirements:
107      *
108      * - Multiplication cannot overflow.
109      */
110     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a * b;
112     }
113 
114     /**
115      * @dev Returns the integer division of two unsigned integers, reverting on
116      * division by zero. The result is rounded towards zero.
117      *
118      * Counterpart to Solidity's `/` operator.
119      *
120      * Requirements:
121      *
122      * - The divisor cannot be zero.
123      */
124     function div(uint256 a, uint256 b) internal pure returns (uint256) {
125         return a / b;
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * reverting when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         return a % b;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
146      * overflow (when the result is negative).
147      *
148      * CAUTION: This function is deprecated because it requires allocating memory for the error
149      * message unnecessarily. For custom revert reasons use {trySub}.
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(
158         uint256 a,
159         uint256 b,
160         string memory errorMessage
161     ) internal pure returns (uint256) {
162         unchecked {
163             require(b <= a, errorMessage);
164             return a - b;
165         }
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      *
178      * - The divisor cannot be zero.
179      */
180     function div(
181         uint256 a,
182         uint256 b,
183         string memory errorMessage
184     ) internal pure returns (uint256) {
185         unchecked {
186             require(b > 0, errorMessage);
187             return a / b;
188         }
189     }
190 
191     /**
192      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
193      * reverting with custom message when dividing by zero.
194      *
195      * CAUTION: This function is deprecated because it requires allocating memory for the error
196      * message unnecessarily. For custom revert reasons use {tryMod}.
197      *
198      * Counterpart to Solidity's `%` operator. This function uses a `revert`
199      * opcode (which leaves remaining gas untouched) while Solidity uses an
200      * invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function mod(
207         uint256 a,
208         uint256 b,
209         string memory errorMessage
210     ) internal pure returns (uint256) {
211         unchecked {
212             require(b > 0, errorMessage);
213             return a % b;
214         }
215     }
216 }
217 
218 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
219 
220 pragma solidity ^0.8.0;
221 
222 /**
223  * @dev Interface of the ERC165 standard, as defined in the
224  * https://eips.ethereum.org/EIPS/eip-165[EIP].
225  *
226  * Implementers can declare support of contract interfaces, which can then be
227  * queried by others ({ERC165Checker}).
228  *
229  * For an implementation, see {ERC165}.
230  */
231 interface IERC165 {
232     /**
233      * @dev Returns true if this contract implements the interface defined by
234      * `interfaceId`. See the corresponding
235      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
236      * to learn more about how these ids are created.
237      *
238      * This function call must use less than 30 000 gas.
239      */
240     function supportsInterface(bytes4 interfaceId) external view returns (bool);
241 }
242 
243 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
244 
245 pragma solidity ^0.8.0;
246 
247 /**
248  * @dev Implementation of the {IERC165} interface.
249  *
250  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
251  * for the additional interface id that will be supported. For example:
252  *
253  * ```solidity
254  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
255  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
256  * }
257  * ```
258  *
259  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
260  */
261 abstract contract ERC165 is IERC165 {
262     /**
263      * @dev See {IERC165-supportsInterface}.
264      */
265     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
266         return interfaceId == type(IERC165).interfaceId;
267     }
268 }
269 
270 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
271 
272 pragma solidity ^0.8.0;
273 
274 /**
275  * @dev String operations.
276  */
277 library Strings {
278     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
279 
280     /**
281      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
282      */
283     function toString(uint256 value) internal pure returns (string memory) {
284         // Inspired by OraclizeAPI's implementation - MIT licence
285         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
286 
287         if (value == 0) {
288             return "0";
289         }
290         uint256 temp = value;
291         uint256 digits;
292         while (temp != 0) {
293             digits++;
294             temp /= 10;
295         }
296         bytes memory buffer = new bytes(digits);
297         while (value != 0) {
298             digits -= 1;
299             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
300             value /= 10;
301         }
302         return string(buffer);
303     }
304 
305     /**
306      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
307      */
308     function toHexString(uint256 value) internal pure returns (string memory) {
309         if (value == 0) {
310             return "0x00";
311         }
312         uint256 temp = value;
313         uint256 length = 0;
314         while (temp != 0) {
315             length++;
316             temp >>= 8;
317         }
318         return toHexString(value, length);
319     }
320 
321     /**
322      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
323      */
324     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
325         bytes memory buffer = new bytes(2 * length + 2);
326         buffer[0] = "0";
327         buffer[1] = "x";
328         for (uint256 i = 2 * length + 1; i > 1; --i) {
329             buffer[i] = _HEX_SYMBOLS[value & 0xf];
330             value >>= 4;
331         }
332         require(value == 0, "Strings: hex length insufficient");
333         return string(buffer);
334     }
335 }
336 
337 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @dev Provides information about the current execution context, including the
343  * sender of the transaction and its data. While these are generally available
344  * via msg.sender and msg.data, they should not be accessed in such a direct
345  * manner, since when dealing with meta-transactions the account sending and
346  * paying for execution may not be the actual sender (as far as an application
347  * is concerned).
348  *
349  * This contract is only required for intermediate, library-like contracts.
350  */
351 abstract contract Context {
352     function _msgSender() internal view virtual returns (address) {
353         return msg.sender;
354     }
355 
356     function _msgData() internal view virtual returns (bytes calldata) {
357         return msg.data;
358     }
359 }
360 
361 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
362 
363 pragma solidity ^0.8.0;
364 
365 /**
366  * @dev Collection of functions related to the address type
367  */
368 library Address {
369     /**
370      * @dev Returns true if `account` is a contract.
371      *
372      * [IMPORTANT]
373      * ====
374      * It is unsafe to assume that an address for which this function returns
375      * false is an externally-owned account (EOA) and not a contract.
376      *
377      * Among others, `isContract` will return false for the following
378      * types of addresses:
379      *
380      *  - an externally-owned account
381      *  - a contract in construction
382      *  - an address where a contract will be created
383      *  - an address where a contract lived, but was destroyed
384      * ====
385      */
386     function isContract(address account) internal view returns (bool) {
387         // This method relies on extcodesize, which returns 0 for contracts in
388         // construction, since the code is only stored at the end of the
389         // constructor execution.
390 
391         uint256 size;
392         assembly {
393             size := extcodesize(account)
394         }
395         return size > 0;
396     }
397 
398     /**
399      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
400      * `recipient`, forwarding all available gas and reverting on errors.
401      *
402      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
403      * of certain opcodes, possibly making contracts go over the 2300 gas limit
404      * imposed by `transfer`, making them unable to receive funds via
405      * `transfer`. {sendValue} removes this limitation.
406      *
407      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
408      *
409      * IMPORTANT: because control is transferred to `recipient`, care must be
410      * taken to not create reentrancy vulnerabilities. Consider using
411      * {ReentrancyGuard} or the
412      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
413      */
414     function sendValue(address payable recipient, uint256 amount) internal {
415         require(address(this).balance >= amount, "Address: insufficient balance");
416 
417         (bool success, ) = recipient.call{value: amount}("");
418         require(success, "Address: unable to send value, recipient may have reverted");
419     }
420 
421     /**
422      * @dev Performs a Solidity function call using a low level `call`. A
423      * plain `call` is an unsafe replacement for a function call: use this
424      * function instead.
425      *
426      * If `target` reverts with a revert reason, it is bubbled up by this
427      * function (like regular Solidity function calls).
428      *
429      * Returns the raw returned data. To convert to the expected return value,
430      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
431      *
432      * Requirements:
433      *
434      * - `target` must be a contract.
435      * - calling `target` with `data` must not revert.
436      *
437      * _Available since v3.1._
438      */
439     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
440         return functionCall(target, data, "Address: low-level call failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
445      * `errorMessage` as a fallback revert reason when `target` reverts.
446      *
447      * _Available since v3.1._
448      */
449     function functionCall(
450         address target,
451         bytes memory data,
452         string memory errorMessage
453     ) internal returns (bytes memory) {
454         return functionCallWithValue(target, data, 0, errorMessage);
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
459      * but also transferring `value` wei to `target`.
460      *
461      * Requirements:
462      *
463      * - the calling contract must have an ETH balance of at least `value`.
464      * - the called Solidity function must be `payable`.
465      *
466      * _Available since v3.1._
467      */
468     function functionCallWithValue(
469         address target,
470         bytes memory data,
471         uint256 value
472     ) internal returns (bytes memory) {
473         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
478      * with `errorMessage` as a fallback revert reason when `target` reverts.
479      *
480      * _Available since v3.1._
481      */
482     function functionCallWithValue(
483         address target,
484         bytes memory data,
485         uint256 value,
486         string memory errorMessage
487     ) internal returns (bytes memory) {
488         require(address(this).balance >= value, "Address: insufficient balance for call");
489         require(isContract(target), "Address: call to non-contract");
490 
491         (bool success, bytes memory returndata) = target.call{value: value}(data);
492         return verifyCallResult(success, returndata, errorMessage);
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
497      * but performing a static call.
498      *
499      * _Available since v3.3._
500      */
501     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
502         return functionStaticCall(target, data, "Address: low-level static call failed");
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
507      * but performing a static call.
508      *
509      * _Available since v3.3._
510      */
511     function functionStaticCall(
512         address target,
513         bytes memory data,
514         string memory errorMessage
515     ) internal view returns (bytes memory) {
516         require(isContract(target), "Address: static call to non-contract");
517 
518         (bool success, bytes memory returndata) = target.staticcall(data);
519         return verifyCallResult(success, returndata, errorMessage);
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
524      * but performing a delegate call.
525      *
526      * _Available since v3.4._
527      */
528     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
529         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
534      * but performing a delegate call.
535      *
536      * _Available since v3.4._
537      */
538     function functionDelegateCall(
539         address target,
540         bytes memory data,
541         string memory errorMessage
542     ) internal returns (bytes memory) {
543         require(isContract(target), "Address: delegate call to non-contract");
544 
545         (bool success, bytes memory returndata) = target.delegatecall(data);
546         return verifyCallResult(success, returndata, errorMessage);
547     }
548 
549     /**
550      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
551      * revert reason using the provided one.
552      *
553      * _Available since v4.3._
554      */
555     function verifyCallResult(
556         bool success,
557         bytes memory returndata,
558         string memory errorMessage
559     ) internal pure returns (bytes memory) {
560         if (success) {
561             return returndata;
562         } else {
563             // Look for revert reason and bubble it up if present
564             if (returndata.length > 0) {
565                 // The easiest way to bubble the revert reason is using memory via assembly
566 
567                 assembly {
568                     let returndata_size := mload(returndata)
569                     revert(add(32, returndata), returndata_size)
570                 }
571             } else {
572                 revert(errorMessage);
573             }
574         }
575     }
576 }
577 
578 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
579 
580 pragma solidity ^0.8.0;
581 
582 
583 /**
584  * @dev Required interface of an ERC721 compliant contract.
585  */
586 interface IERC721 is IERC165 {
587     /**
588      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
589      */
590     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
591 
592     /**
593      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
594      */
595     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
596 
597     /**
598      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
599      */
600     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
601 
602     /**
603      * @dev Returns the number of tokens in ``owner``'s account.
604      */
605     function balanceOf(address owner) external view returns (uint256 balance);
606 
607     /**
608      * @dev Returns the owner of the `tokenId` token.
609      *
610      * Requirements:
611      *
612      * - `tokenId` must exist.
613      */
614     function ownerOf(uint256 tokenId) external view returns (address owner);
615 
616     /**
617      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
618      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
619      *
620      * Requirements:
621      *
622      * - `from` cannot be the zero address.
623      * - `to` cannot be the zero address.
624      * - `tokenId` token must exist and be owned by `from`.
625      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
626      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
627      *
628      * Emits a {Transfer} event.
629      */
630     function safeTransferFrom(
631         address from,
632         address to,
633         uint256 tokenId
634     ) external;
635 
636     /**
637      * @dev Transfers `tokenId` token from `from` to `to`.
638      *
639      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
640      *
641      * Requirements:
642      *
643      * - `from` cannot be the zero address.
644      * - `to` cannot be the zero address.
645      * - `tokenId` token must be owned by `from`.
646      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
647      *
648      * Emits a {Transfer} event.
649      */
650     function transferFrom(
651         address from,
652         address to,
653         uint256 tokenId
654     ) external;
655 
656     /**
657      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
658      * The approval is cleared when the token is transferred.
659      *
660      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
661      *
662      * Requirements:
663      *
664      * - The caller must own the token or be an approved operator.
665      * - `tokenId` must exist.
666      *
667      * Emits an {Approval} event.
668      */
669     function approve(address to, uint256 tokenId) external;
670 
671     /**
672      * @dev Returns the account approved for `tokenId` token.
673      *
674      * Requirements:
675      *
676      * - `tokenId` must exist.
677      */
678     function getApproved(uint256 tokenId) external view returns (address operator);
679 
680     /**
681      * @dev Approve or remove `operator` as an operator for the caller.
682      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
683      *
684      * Requirements:
685      *
686      * - The `operator` cannot be the caller.
687      *
688      * Emits an {ApprovalForAll} event.
689      */
690     function setApprovalForAll(address operator, bool _approved) external;
691 
692     /**
693      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
694      *
695      * See {setApprovalForAll}
696      */
697     function isApprovedForAll(address owner, address operator) external view returns (bool);
698 
699     /**
700      * @dev Safely transfers `tokenId` token from `from` to `to`.
701      *
702      * Requirements:
703      *
704      * - `from` cannot be the zero address.
705      * - `to` cannot be the zero address.
706      * - `tokenId` token must exist and be owned by `from`.
707      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
708      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
709      *
710      * Emits a {Transfer} event.
711      */
712     function safeTransferFrom(
713         address from,
714         address to,
715         uint256 tokenId,
716         bytes calldata data
717     ) external;
718 }
719 
720 
721 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
722 
723 pragma solidity ^0.8.0;
724 
725 /**
726  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
727  * @dev See https://eips.ethereum.org/EIPS/eip-721
728  */
729 interface IERC721Metadata is IERC721 {
730     /**
731      * @dev Returns the token collection name.
732      */
733     function name() external view returns (string memory);
734 
735     /**
736      * @dev Returns the token collection symbol.
737      */
738     function symbol() external view returns (string memory);
739 
740     /**
741      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
742      */
743     function tokenURI(uint256 tokenId) external view returns (string memory);
744 }
745 
746 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
747 
748 pragma solidity ^0.8.0;
749 
750 /**
751  * @title ERC721 token receiver interface
752  * @dev Interface for any contract that wants to support safeTransfers
753  * from ERC721 asset contracts.
754  */
755 interface IERC721Receiver {
756     /**
757      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
758      * by `operator` from `from`, this function is called.
759      *
760      * It must return its Solidity selector to confirm the token transfer.
761      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
762      *
763      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
764      */
765     function onERC721Received(
766         address operator,
767         address from,
768         uint256 tokenId,
769         bytes calldata data
770     ) external returns (bytes4);
771 }
772 
773 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
774 
775 pragma solidity ^0.8.0;
776 
777 /**
778  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
779  * the Metadata extension, but not including the Enumerable extension, which is available separately as
780  * {ERC721Enumerable}.
781  */
782 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
783     using Address for address;
784     using Strings for uint256;
785 
786     // Token name
787     string private _name;
788 
789     // Token symbol
790     string private _symbol;
791 
792     // Mapping from token ID to owner address
793     mapping(uint256 => address) private _owners;
794 
795     // Mapping owner address to token count
796     mapping(address => uint256) private _balances;
797 
798     // Mapping from token ID to approved address
799     mapping(uint256 => address) private _tokenApprovals;
800 
801     // Mapping from owner to operator approvals
802     mapping(address => mapping(address => bool)) private _operatorApprovals;
803 
804     /**
805      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
806      */
807     constructor(string memory name_, string memory symbol_) {
808         _name = name_;
809         _symbol = symbol_;
810     }
811 
812     /**
813      * @dev See {IERC165-supportsInterface}.
814      */
815     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
816         return
817             interfaceId == type(IERC721).interfaceId ||
818             interfaceId == type(IERC721Metadata).interfaceId ||
819             super.supportsInterface(interfaceId);
820     }
821 
822     /**
823      * @dev See {IERC721-balanceOf}.
824      */
825     function balanceOf(address owner) public view virtual override returns (uint256) {
826         require(owner != address(0), "ERC721: balance query for the zero address");
827         return _balances[owner];
828     }
829 
830     /**
831      * @dev See {IERC721-ownerOf}.
832      */
833     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
834         address owner = _owners[tokenId];
835         require(owner != address(0), "ERC721: owner query for nonexistent token");
836         return owner;
837     }
838 
839     /**
840      * @dev See {IERC721Metadata-name}.
841      */
842     function name() public view virtual override returns (string memory) {
843         return _name;
844     }
845 
846     /**
847      * @dev See {IERC721Metadata-symbol}.
848      */
849     function symbol() public view virtual override returns (string memory) {
850         return _symbol;
851     }
852 
853     /**
854      * @dev See {IERC721Metadata-tokenURI}.
855      */
856     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
857         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
858 
859         string memory baseURI = _baseURI();
860         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
861     }
862 
863     /**
864      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
865      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
866      * by default, can be overriden in child contracts.
867      */
868     function _baseURI() internal view virtual returns (string memory) {
869         return "";
870     }
871 
872     /**
873      * @dev See {IERC721-approve}.
874      */
875     function approve(address to, uint256 tokenId) public virtual override {
876         address owner = ERC721.ownerOf(tokenId);
877         require(to != owner, "ERC721: approval to current owner");
878 
879         require(
880             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
881             "ERC721: approve caller is not owner nor approved for all"
882         );
883 
884         _approve(to, tokenId);
885     }
886 
887     /**
888      * @dev See {IERC721-getApproved}.
889      */
890     function getApproved(uint256 tokenId) public view virtual override returns (address) {
891         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
892 
893         return _tokenApprovals[tokenId];
894     }
895 
896     /**
897      * @dev See {IERC721-setApprovalForAll}.
898      */
899     function setApprovalForAll(address operator, bool approved) public virtual override {
900         require(operator != _msgSender(), "ERC721: approve to caller");
901 
902         _operatorApprovals[_msgSender()][operator] = approved;
903         emit ApprovalForAll(_msgSender(), operator, approved);
904     }
905 
906     /**
907      * @dev See {IERC721-isApprovedForAll}.
908      */
909     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
910         return _operatorApprovals[owner][operator];
911     }
912 
913     /**
914      * @dev See {IERC721-transferFrom}.
915      */
916     function transferFrom(
917         address from,
918         address to,
919         uint256 tokenId
920     ) public virtual override {
921         //solhint-disable-next-line max-line-length
922         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
923 
924         _transfer(from, to, tokenId);
925     }
926 
927     /**
928      * @dev See {IERC721-safeTransferFrom}.
929      */
930     function safeTransferFrom(
931         address from,
932         address to,
933         uint256 tokenId
934     ) public virtual override {
935         safeTransferFrom(from, to, tokenId, "");
936     }
937 
938     /**
939      * @dev See {IERC721-safeTransferFrom}.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId,
945         bytes memory _data
946     ) public virtual override {
947         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
948         _safeTransfer(from, to, tokenId, _data);
949     }
950 
951     /**
952      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
953      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
954      *
955      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
956      *
957      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
958      * implement alternative mechanisms to perform token transfer, such as signature-based.
959      *
960      * Requirements:
961      *
962      * - `from` cannot be the zero address.
963      * - `to` cannot be the zero address.
964      * - `tokenId` token must exist and be owned by `from`.
965      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _safeTransfer(
970         address from,
971         address to,
972         uint256 tokenId,
973         bytes memory _data
974     ) internal virtual {
975         _transfer(from, to, tokenId);
976         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
977     }
978 
979     /**
980      * @dev Returns whether `tokenId` exists.
981      *
982      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
983      *
984      * Tokens start existing when they are minted (`_mint`),
985      * and stop existing when they are burned (`_burn`).
986      */
987     function _exists(uint256 tokenId) internal view virtual returns (bool) {
988         return _owners[tokenId] != address(0);
989     }
990 
991     /**
992      * @dev Returns whether `spender` is allowed to manage `tokenId`.
993      *
994      * Requirements:
995      *
996      * - `tokenId` must exist.
997      */
998     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
999         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1000         address owner = ERC721.ownerOf(tokenId);
1001         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1002     }
1003 
1004     /**
1005      * @dev Safely mints `tokenId` and transfers it to `to`.
1006      *
1007      * Requirements:
1008      *
1009      * - `tokenId` must not exist.
1010      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _safeMint(address to, uint256 tokenId) internal virtual {
1015         _safeMint(to, tokenId, "");
1016     }
1017 
1018     /**
1019      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1020      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1021      */
1022     function _safeMint(
1023         address to,
1024         uint256 tokenId,
1025         bytes memory _data
1026     ) internal virtual {
1027         _mint(to, tokenId);
1028         require(
1029             _checkOnERC721Received(address(0), to, tokenId, _data),
1030             "ERC721: transfer to non ERC721Receiver implementer"
1031         );
1032     }
1033 
1034     /**
1035      * @dev Mints `tokenId` and transfers it to `to`.
1036      *
1037      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1038      *
1039      * Requirements:
1040      *
1041      * - `tokenId` must not exist.
1042      * - `to` cannot be the zero address.
1043      *
1044      * Emits a {Transfer} event.
1045      */
1046     function _mint(address to, uint256 tokenId) internal virtual {
1047         require(to != address(0), "ERC721: mint to the zero address");
1048         require(!_exists(tokenId), "ERC721: token already minted");
1049 
1050         _beforeTokenTransfer(address(0), to, tokenId);
1051 
1052         _balances[to] += 1;
1053         _owners[tokenId] = to;
1054 
1055         emit Transfer(address(0), to, tokenId);
1056     }
1057 
1058     /**
1059      * @dev Destroys `tokenId`.
1060      * The approval is cleared when the token is burned.
1061      *
1062      * Requirements:
1063      *
1064      * - `tokenId` must exist.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _burn(uint256 tokenId) internal virtual {
1069         address owner = ERC721.ownerOf(tokenId);
1070 
1071         _beforeTokenTransfer(owner, address(0), tokenId);
1072 
1073         // Clear approvals
1074         _approve(address(0), tokenId);
1075 
1076         _balances[owner] -= 1;
1077         delete _owners[tokenId];
1078 
1079         emit Transfer(owner, address(0), tokenId);
1080     }
1081 
1082     /**
1083      * @dev Transfers `tokenId` from `from` to `to`.
1084      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1085      *
1086      * Requirements:
1087      *
1088      * - `to` cannot be the zero address.
1089      * - `tokenId` token must be owned by `from`.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function _transfer(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) internal virtual {
1098         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1099         require(to != address(0), "ERC721: transfer to the zero address");
1100 
1101         _beforeTokenTransfer(from, to, tokenId);
1102 
1103         // Clear approvals from the previous owner
1104         _approve(address(0), tokenId);
1105 
1106         _balances[from] -= 1;
1107         _balances[to] += 1;
1108         _owners[tokenId] = to;
1109 
1110         emit Transfer(from, to, tokenId);
1111     }
1112 
1113     /**
1114      * @dev Approve `to` to operate on `tokenId`
1115      *
1116      * Emits a {Approval} event.
1117      */
1118     function _approve(address to, uint256 tokenId) internal virtual {
1119         _tokenApprovals[tokenId] = to;
1120         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1121     }
1122 
1123     /**
1124      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1125      * The call is not executed if the target address is not a contract.
1126      *
1127      * @param from address representing the previous owner of the given token ID
1128      * @param to target address that will receive the tokens
1129      * @param tokenId uint256 ID of the token to be transferred
1130      * @param _data bytes optional data to send along with the call
1131      * @return bool whether the call correctly returned the expected magic value
1132      */
1133     function _checkOnERC721Received(
1134         address from,
1135         address to,
1136         uint256 tokenId,
1137         bytes memory _data
1138     ) private returns (bool) {
1139         if (to.isContract()) {
1140             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1141                 return retval == IERC721Receiver.onERC721Received.selector;
1142             } catch (bytes memory reason) {
1143                 if (reason.length == 0) {
1144                     revert("ERC721: transfer to non ERC721Receiver implementer");
1145                 } else {
1146                     assembly {
1147                         revert(add(32, reason), mload(reason))
1148                     }
1149                 }
1150             }
1151         } else {
1152             return true;
1153         }
1154     }
1155 
1156     /**
1157      * @dev Hook that is called before any token transfer. This includes minting
1158      * and burning.
1159      *
1160      * Calling conditions:
1161      *
1162      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1163      * transferred to `to`.
1164      * - When `from` is zero, `tokenId` will be minted for `to`.
1165      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1166      * - `from` and `to` are never both zero.
1167      *
1168      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1169      */
1170     function _beforeTokenTransfer(
1171         address from,
1172         address to,
1173         uint256 tokenId
1174     ) internal virtual {}
1175 }
1176 
1177 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1178 
1179 
1180 
1181 pragma solidity ^0.8.0;
1182 
1183 
1184 /**
1185  * @dev ERC721 token with storage based token URI management.
1186  */
1187 abstract contract ERC721URIStorage is ERC721 {
1188     using Strings for uint256;
1189 
1190     // Optional mapping for token URIs
1191     mapping(uint256 => string) private _tokenURIs;
1192 
1193     /**
1194      * @dev See {IERC721Metadata-tokenURI}.
1195      */
1196     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1197         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1198 
1199         string memory _tokenURI = _tokenURIs[tokenId];
1200         string memory base = _baseURI();
1201 
1202         // If there is no base URI, return the token URI.
1203         if (bytes(base).length == 0) {
1204             return _tokenURI;
1205         }
1206         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1207         if (bytes(_tokenURI).length > 0) {
1208             return string(abi.encodePacked(base, _tokenURI));
1209         }
1210 
1211         return super.tokenURI(tokenId);
1212     }
1213 
1214     /**
1215      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1216      *
1217      * Requirements:
1218      *
1219      * - `tokenId` must exist.
1220      */
1221     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1222         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1223         _tokenURIs[tokenId] = _tokenURI;
1224     }
1225 
1226     /**
1227      * @dev Destroys `tokenId`.
1228      * The approval is cleared when the token is burned.
1229      *
1230      * Requirements:
1231      *
1232      * - `tokenId` must exist.
1233      *
1234      * Emits a {Transfer} event.
1235      */
1236     function _burn(uint256 tokenId) internal virtual override {
1237         super._burn(tokenId);
1238 
1239         if (bytes(_tokenURIs[tokenId]).length != 0) {
1240             delete _tokenURIs[tokenId];
1241         }
1242     }
1243 }
1244 
1245 /**
1246  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1247  * @dev See https://eips.ethereum.org/EIPS/eip-721
1248  */
1249 interface IERC721Enumerable is IERC721 {
1250     /**
1251      * @dev Returns the total amount of tokens stored by the contract.
1252      */
1253     function totalSupply() external view returns (uint256);
1254 
1255     /**
1256      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1257      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1258      */
1259     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1260 
1261     /**
1262      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1263      * Use along with {totalSupply} to enumerate all tokens.
1264      */
1265     function tokenByIndex(uint256 index) external view returns (uint256);
1266 }
1267 
1268 /**
1269  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1270  * enumerability of all the token ids in the contract as well as all token ids owned by each
1271  * account.
1272  */
1273 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1274     // Mapping from owner to list of owned token IDs
1275     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1276 
1277     // Mapping from token ID to index of the owner tokens list
1278     mapping(uint256 => uint256) private _ownedTokensIndex;
1279 
1280     // Array with all token ids, used for enumeration
1281     uint256[] private _allTokens;
1282 
1283     // Mapping from token id to position in the allTokens array
1284     mapping(uint256 => uint256) private _allTokensIndex;
1285 
1286     /**
1287      * @dev See {IERC165-supportsInterface}.
1288      */
1289     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1290         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1291     }
1292 
1293     /**
1294      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1295      */
1296     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1297         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1298         return _ownedTokens[owner][index];
1299     }
1300 
1301     /**
1302      * @dev See {IERC721Enumerable-totalSupply}.
1303      */
1304     function totalSupply() public view virtual override returns (uint256) {
1305         return _allTokens.length;
1306     }
1307 
1308     /**
1309      * @dev See {IERC721Enumerable-tokenByIndex}.
1310      */
1311     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1312         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1313         return _allTokens[index];
1314     }
1315 
1316     /**
1317      * @dev Hook that is called before any token transfer. This includes minting
1318      * and burning.
1319      *
1320      * Calling conditions:
1321      *
1322      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1323      * transferred to `to`.
1324      * - When `from` is zero, `tokenId` will be minted for `to`.
1325      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1326      * - `from` cannot be the zero address.
1327      * - `to` cannot be the zero address.
1328      *
1329      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1330      */
1331     function _beforeTokenTransfer(
1332         address from,
1333         address to,
1334         uint256 tokenId
1335     ) internal virtual override {
1336         super._beforeTokenTransfer(from, to, tokenId);
1337 
1338         if (from == address(0)) {
1339             _addTokenToAllTokensEnumeration(tokenId);
1340         } else if (from != to) {
1341             _removeTokenFromOwnerEnumeration(from, tokenId);
1342         }
1343         if (to == address(0)) {
1344             _removeTokenFromAllTokensEnumeration(tokenId);
1345         } else if (to != from) {
1346             _addTokenToOwnerEnumeration(to, tokenId);
1347         }
1348     }
1349 
1350     /**
1351      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1352      * @param to address representing the new owner of the given token ID
1353      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1354      */
1355     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1356         uint256 length = ERC721.balanceOf(to);
1357         _ownedTokens[to][length] = tokenId;
1358         _ownedTokensIndex[tokenId] = length;
1359     }
1360 
1361     /**
1362      * @dev Private function to add a token to this extension's token tracking data structures.
1363      * @param tokenId uint256 ID of the token to be added to the tokens list
1364      */
1365     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1366         _allTokensIndex[tokenId] = _allTokens.length;
1367         _allTokens.push(tokenId);
1368     }
1369 
1370     /**
1371      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1372      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1373      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1374      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1375      * @param from address representing the previous owner of the given token ID
1376      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1377      */
1378     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1379         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1380         // then delete the last slot (swap and pop).
1381 
1382         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1383         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1384 
1385         // When the token to delete is the last token, the swap operation is unnecessary
1386         if (tokenIndex != lastTokenIndex) {
1387             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1388 
1389             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1390             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1391         }
1392 
1393         // This also deletes the contents at the last position of the array
1394         delete _ownedTokensIndex[tokenId];
1395         delete _ownedTokens[from][lastTokenIndex];
1396     }
1397 
1398     /**
1399      * @dev Private function to remove a token from this extension's token tracking data structures.
1400      * This has O(1) time complexity, but alters the order of the _allTokens array.
1401      * @param tokenId uint256 ID of the token to be removed from the tokens list
1402      */
1403     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1404         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1405         // then delete the last slot (swap and pop).
1406 
1407         uint256 lastTokenIndex = _allTokens.length - 1;
1408         uint256 tokenIndex = _allTokensIndex[tokenId];
1409 
1410         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1411         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1412         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1413         uint256 lastTokenId = _allTokens[lastTokenIndex];
1414 
1415         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1416         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1417 
1418         // This also deletes the contents at the last position of the array
1419         delete _allTokensIndex[tokenId];
1420         _allTokens.pop();
1421     }
1422 }
1423 
1424 
1425 // File: NFT.sol
1426 
1427 
1428 pragma solidity ^0.8.0;
1429 
1430 
1431 /**
1432  * @dev Contract module which provides a basic access control mechanism, where
1433  * there is an account (an owner) that can be granted exclusive access to
1434  * specific functions.
1435  *
1436  * By default, the owner account will be the one that deploys the contract. This
1437  * can later be changed with {transferOwnership}.
1438  *
1439  * This module is used through inheritance. It will make available the modifier
1440  * `onlyOwner`, which can be applied to your functions to restrict their use to
1441  * the owner.
1442  */
1443 abstract contract Ownable is Context {
1444     address private _owner;
1445 
1446     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1447 
1448     /**
1449      * @dev Initializes the contract setting the deployer as the initial owner.
1450      */
1451     constructor() {
1452         _transferOwnership(_msgSender());
1453     }
1454 
1455     /**
1456      * @dev Returns the address of the current owner.
1457      */
1458     function owner() public view virtual returns (address) {
1459         return _owner;
1460     }
1461 
1462     /**
1463      * @dev Throws if called by any account other than the owner.
1464      */
1465     modifier onlyOwner() {
1466         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1467         _;
1468     }
1469 
1470     /**
1471      * @dev Leaves the contract without owner. It will not be possible to call
1472      * `onlyOwner` functions anymore. Can only be called by the current owner.
1473      *
1474      * NOTE: Renouncing ownership will leave the contract without an owner,
1475      * thereby removing any functionality that is only available to the owner.
1476      */
1477     function renounceOwnership() public virtual onlyOwner {
1478         _transferOwnership(address(0));
1479     }
1480 
1481     /**
1482      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1483      * Can only be called by the current owner.
1484      */
1485     function transferOwnership(address newOwner) public virtual onlyOwner {
1486         require(newOwner != address(0), "Ownable: new owner is the zero address");
1487         _transferOwnership(newOwner);
1488     }
1489 
1490     /**
1491      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1492      * Internal function without access restriction.
1493      */
1494     function _transferOwnership(address newOwner) internal virtual {
1495         address oldOwner = _owner;
1496         _owner = newOwner;
1497         emit OwnershipTransferred(oldOwner, newOwner);
1498     }
1499 }
1500 
1501 contract DiamondHands is ERC721Enumerable, Ownable{
1502     using Strings for uint256;
1503     using SafeMath for uint;
1504     
1505     string public baseURI;
1506 
1507     uint256 public constant TOTAL_SUPPLY = 11111;
1508     
1509     uint256 public constant NFT_MINT_PRICE = 0.09 ether;
1510     
1511     uint256 public constant MAX_BULK_TOKEN = 20;
1512     
1513     bool public saleActivated;
1514 
1515     constructor()
1516         ERC721("DiamondHands", "DH")
1517     {
1518     }
1519     
1520     function setSaleActivatedPauseOrUnpause(bool _value) public onlyOwner{
1521         saleActivated = _value;
1522     }
1523 
1524     function setBaseURI(string memory _newBaseURI) public onlyOwner{
1525         baseURI = _newBaseURI;
1526     }
1527 
1528     function bulkMint(uint256 _amount) public payable {
1529         require(saleActivated, "bulkMint: Mint process is pause");
1530         
1531         require(_amount > 0, "bulkMint: amount cannot be 0");
1532         require(totalSupply() < TOTAL_SUPPLY, "bulkMint: sale has already ended");
1533         require(totalSupply().add(_amount) <= TOTAL_SUPPLY, "bulkMint: sale has already ended");
1534         require(_amount <= MAX_BULK_TOKEN, "bulkMint: You may not buy more than MAX_BULK_TOKEN NFTs at once");
1535         require(msg.value == _amount.mul(NFT_MINT_PRICE), "bulkMint: Ether value sent is not correct");
1536         for (uint256 i = 0; i < _amount; i++) {
1537             uint idx = totalSupply();
1538             if(totalSupply() < TOTAL_SUPPLY){
1539                 _safeMint(msg.sender, idx);
1540             }
1541         }
1542     }
1543     
1544     function assignNFT(address[] calldata destinations, uint256 _amount) public onlyOwner{
1545 
1546         require(_amount > 0, "assignNFT: amount cannot be 0");
1547         require(totalSupply() < TOTAL_SUPPLY, "assignNFT: sale has already ended");
1548         require(totalSupply().add(_amount) <= TOTAL_SUPPLY, "assignNFT: sale has already ended");
1549         require(_amount <= MAX_BULK_TOKEN, "assignNFT: You may not buy more than MAX_BULK_TOKEN NFTs at once");
1550         require(destinations.length > 0, "assignNFT: destinations list cannot be empty");
1551         for(uint256 k = 0; k < destinations.length; k++){
1552             for (uint256 i = 0; i < _amount; i++) {
1553                 uint idx = totalSupply();
1554                 if(totalSupply() < TOTAL_SUPPLY){
1555                     _safeMint(destinations[k], idx);
1556                 }
1557             }
1558         }
1559     }
1560     
1561     function tokenOwnedByUser(address _owner) public view returns (uint256[] memory){
1562         uint256 ownerTokenCount = balanceOf(_owner);
1563         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1564         for (uint256 i = 0; i < ownerTokenCount; i++) {
1565           tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1566         }
1567         return tokenIds;
1568     }
1569 
1570     function tokenURI(uint256 tokenId)
1571         public
1572         view
1573         virtual
1574         override
1575         returns (string memory)
1576     {
1577         require(
1578           _exists(tokenId),
1579           "ERC721Metadata: URI query for nonexistent token"
1580         );
1581     
1582         return bytes(baseURI).length > 0
1583             ? string(abi.encodePacked(baseURI, tokenId.toString()))
1584             : "";
1585     }
1586 
1587     function withdrawFund(address destination) public onlyOwner returns(bool){
1588         uint balance = address(this).balance;
1589         (bool success, ) = destination.call{value:balance}("");
1590         return success;
1591     }
1592 }