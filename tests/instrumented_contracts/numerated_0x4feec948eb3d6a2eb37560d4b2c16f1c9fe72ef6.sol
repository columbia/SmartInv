1 /** 
2  *  SourceUnit: /home/highpofly/Documents/code/wob/blockend/contracts/MPRN721.sol
3 */
4             
5 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
6 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 
32 
33 /** 
34  *  SourceUnit: /home/highpofly/Documents/code/wob/blockend/contracts/MPRN721.sol
35 */
36             
37 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
38 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
39 
40 pragma solidity ^0.8.0;
41 
42 /**
43  * @dev Interface of the ERC165 standard, as defined in the
44  * https://eips.ethereum.org/EIPS/eip-165[EIP].
45  *
46  * Implementers can declare support of contract interfaces, which can then be
47  * queried by others ({ERC165Checker}).
48  *
49  * For an implementation, see {ERC165}.
50  */
51 interface IERC165 {
52     /**
53      * @dev Returns true if this contract implements the interface defined by
54      * `interfaceId`. See the corresponding
55      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
56      * to learn more about how these ids are created.
57      *
58      * This function call must use less than 30 000 gas.
59      */
60     function supportsInterface(bytes4 interfaceId) external view returns (bool);
61 }
62 
63 
64 
65 
66 /** 
67  *  SourceUnit: /home/highpofly/Documents/code/wob/blockend/contracts/MPRN721.sol
68 */
69             
70 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
71 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 ////import "../../utils/introspection/IERC165.sol";
76 
77 /**
78  * @dev Required interface of an ERC721 compliant contract.
79  */
80 interface IERC721 is IERC165 {
81     /**
82      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
85 
86     /**
87      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
88      */
89     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
90 
91     /**
92      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
93      */
94     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
95 
96     /**
97      * @dev Returns the number of tokens in ``owner``'s account.
98      */
99     function balanceOf(address owner) external view returns (uint256 balance);
100 
101     /**
102      * @dev Returns the owner of the `tokenId` token.
103      *
104      * Requirements:
105      *
106      * - `tokenId` must exist.
107      */
108     function ownerOf(uint256 tokenId) external view returns (address owner);
109 
110     /**
111      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
112      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
113      *
114      * Requirements:
115      *
116      * - `from` cannot be the zero address.
117      * - `to` cannot be the zero address.
118      * - `tokenId` token must exist and be owned by `from`.
119      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
120      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
121      *
122      * Emits a {Transfer} event.
123      */
124     function safeTransferFrom(
125         address from,
126         address to,
127         uint256 tokenId
128     ) external;
129 
130     /**
131      * @dev Transfers `tokenId` token from `from` to `to`.
132      *
133      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
134      *
135      * Requirements:
136      *
137      * - `from` cannot be the zero address.
138      * - `to` cannot be the zero address.
139      * - `tokenId` token must be owned by `from`.
140      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transferFrom(
145         address from,
146         address to,
147         uint256 tokenId
148     ) external;
149 
150     /**
151      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
152      * The approval is cleared when the token is transferred.
153      *
154      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
155      *
156      * Requirements:
157      *
158      * - The caller must own the token or be an approved operator.
159      * - `tokenId` must exist.
160      *
161      * Emits an {Approval} event.
162      */
163     function approve(address to, uint256 tokenId) external;
164 
165     /**
166      * @dev Returns the account approved for `tokenId` token.
167      *
168      * Requirements:
169      *
170      * - `tokenId` must exist.
171      */
172     function getApproved(uint256 tokenId) external view returns (address operator);
173 
174     /**
175      * @dev Approve or remove `operator` as an operator for the caller.
176      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
177      *
178      * Requirements:
179      *
180      * - The `operator` cannot be the caller.
181      *
182      * Emits an {ApprovalForAll} event.
183      */
184     function setApprovalForAll(address operator, bool _approved) external;
185 
186     /**
187      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
188      *
189      * See {setApprovalForAll}
190      */
191     function isApprovedForAll(address owner, address operator) external view returns (bool);
192 
193     /**
194      * @dev Safely transfers `tokenId` token from `from` to `to`.
195      *
196      * Requirements:
197      *
198      * - `from` cannot be the zero address.
199      * - `to` cannot be the zero address.
200      * - `tokenId` token must exist and be owned by `from`.
201      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
202      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
203      *
204      * Emits a {Transfer} event.
205      */
206     function safeTransferFrom(
207         address from,
208         address to,
209         uint256 tokenId,
210         bytes calldata data
211     ) external;
212 }
213 
214 
215 
216 
217 /** 
218  *  SourceUnit: /home/highpofly/Documents/code/wob/blockend/contracts/MPRN721.sol
219 */
220             
221 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
222 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
223 
224 pragma solidity ^0.8.0;
225 
226 ////import "./IERC165.sol";
227 
228 /**
229  * @dev Implementation of the {IERC165} interface.
230  *
231  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
232  * for the additional interface id that will be supported. For example:
233  *
234  * ```solidity
235  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
236  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
237  * }
238  * ```
239  *
240  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
241  */
242 abstract contract ERC165 is IERC165 {
243     /**
244      * @dev See {IERC165-supportsInterface}.
245      */
246     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
247         return interfaceId == type(IERC165).interfaceId;
248     }
249 }
250 
251 
252 
253 
254 /** 
255  *  SourceUnit: /home/highpofly/Documents/code/wob/blockend/contracts/MPRN721.sol
256 */
257             
258 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
259 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev String operations.
265  */
266 library Strings {
267     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
268 
269     /**
270      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
271      */
272     function toString(uint256 value) internal pure returns (string memory) {
273         // Inspired by OraclizeAPI's implementation - MIT licence
274         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
275 
276         if (value == 0) {
277             return "0";
278         }
279         uint256 temp = value;
280         uint256 digits;
281         while (temp != 0) {
282             digits++;
283             temp /= 10;
284         }
285         bytes memory buffer = new bytes(digits);
286         while (value != 0) {
287             digits -= 1;
288             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
289             value /= 10;
290         }
291         return string(buffer);
292     }
293 
294     /**
295      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
296      */
297     function toHexString(uint256 value) internal pure returns (string memory) {
298         if (value == 0) {
299             return "0x00";
300         }
301         uint256 temp = value;
302         uint256 length = 0;
303         while (temp != 0) {
304             length++;
305             temp >>= 8;
306         }
307         return toHexString(value, length);
308     }
309 
310     /**
311      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
312      */
313     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
314         bytes memory buffer = new bytes(2 * length + 2);
315         buffer[0] = "0";
316         buffer[1] = "x";
317         for (uint256 i = 2 * length + 1; i > 1; --i) {
318             buffer[i] = _HEX_SYMBOLS[value & 0xf];
319             value >>= 4;
320         }
321         require(value == 0, "Strings: hex length insufficient");
322         return string(buffer);
323     }
324 }
325 
326 
327 
328 
329 /** 
330  *  SourceUnit: /home/highpofly/Documents/code/wob/blockend/contracts/MPRN721.sol
331 */
332             
333 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
334 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
335 
336 pragma solidity ^0.8.0;
337 
338 /**
339  * @dev Collection of functions related to the address type
340  */
341 library Address {
342     /**
343      * @dev Returns true if `account` is a contract.
344      *
345      * [////IMPORTANT]
346      * ====
347      * It is unsafe to assume that an address for which this function returns
348      * false is an externally-owned account (EOA) and not a contract.
349      *
350      * Among others, `isContract` will return false for the following
351      * types of addresses:
352      *
353      *  - an externally-owned account
354      *  - a contract in construction
355      *  - an address where a contract will be created
356      *  - an address where a contract lived, but was destroyed
357      * ====
358      */
359     function isContract(address account) internal view returns (bool) {
360         // This method relies on extcodesize, which returns 0 for contracts in
361         // construction, since the code is only stored at the end of the
362         // constructor execution.
363 
364         uint256 size;
365         assembly {
366             size := extcodesize(account)
367         }
368         return size > 0;
369     }
370 
371     /**
372      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
373      * `recipient`, forwarding all available gas and reverting on errors.
374      *
375      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
376      * of certain opcodes, possibly making contracts go over the 2300 gas limit
377      * imposed by `transfer`, making them unable to receive funds via
378      * `transfer`. {sendValue} removes this limitation.
379      *
380      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
381      *
382      * ////IMPORTANT: because control is transferred to `recipient`, care must be
383      * taken to not create reentrancy vulnerabilities. Consider using
384      * {ReentrancyGuard} or the
385      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
386      */
387     function sendValue(address payable recipient, uint256 amount) internal {
388         require(address(this).balance >= amount, "Address: insufficient balance");
389 
390         (bool success, ) = recipient.call{value: amount}("");
391         require(success, "Address: unable to send value, recipient may have reverted");
392     }
393 
394     /**
395      * @dev Performs a Solidity function call using a low level `call`. A
396      * plain `call` is an unsafe replacement for a function call: use this
397      * function instead.
398      *
399      * If `target` reverts with a revert reason, it is bubbled up by this
400      * function (like regular Solidity function calls).
401      *
402      * Returns the raw returned data. To convert to the expected return value,
403      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
404      *
405      * Requirements:
406      *
407      * - `target` must be a contract.
408      * - calling `target` with `data` must not revert.
409      *
410      * _Available since v3.1._
411      */
412     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
413         return functionCall(target, data, "Address: low-level call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
418      * `errorMessage` as a fallback revert reason when `target` reverts.
419      *
420      * _Available since v3.1._
421      */
422     function functionCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         return functionCallWithValue(target, data, 0, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but also transferring `value` wei to `target`.
433      *
434      * Requirements:
435      *
436      * - the calling contract must have an ETH balance of at least `value`.
437      * - the called Solidity function must be `payable`.
438      *
439      * _Available since v3.1._
440      */
441     function functionCallWithValue(
442         address target,
443         bytes memory data,
444         uint256 value
445     ) internal returns (bytes memory) {
446         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
451      * with `errorMessage` as a fallback revert reason when `target` reverts.
452      *
453      * _Available since v3.1._
454      */
455     function functionCallWithValue(
456         address target,
457         bytes memory data,
458         uint256 value,
459         string memory errorMessage
460     ) internal returns (bytes memory) {
461         require(address(this).balance >= value, "Address: insufficient balance for call");
462         require(isContract(target), "Address: call to non-contract");
463 
464         (bool success, bytes memory returndata) = target.call{value: value}(data);
465         return verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
470      * but performing a static call.
471      *
472      * _Available since v3.3._
473      */
474     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
475         return functionStaticCall(target, data, "Address: low-level static call failed");
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
480      * but performing a static call.
481      *
482      * _Available since v3.3._
483      */
484     function functionStaticCall(
485         address target,
486         bytes memory data,
487         string memory errorMessage
488     ) internal view returns (bytes memory) {
489         require(isContract(target), "Address: static call to non-contract");
490 
491         (bool success, bytes memory returndata) = target.staticcall(data);
492         return verifyCallResult(success, returndata, errorMessage);
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
497      * but performing a delegate call.
498      *
499      * _Available since v3.4._
500      */
501     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
502         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
507      * but performing a delegate call.
508      *
509      * _Available since v3.4._
510      */
511     function functionDelegateCall(
512         address target,
513         bytes memory data,
514         string memory errorMessage
515     ) internal returns (bytes memory) {
516         require(isContract(target), "Address: delegate call to non-contract");
517 
518         (bool success, bytes memory returndata) = target.delegatecall(data);
519         return verifyCallResult(success, returndata, errorMessage);
520     }
521 
522     /**
523      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
524      * revert reason using the provided one.
525      *
526      * _Available since v4.3._
527      */
528     function verifyCallResult(
529         bool success,
530         bytes memory returndata,
531         string memory errorMessage
532     ) internal pure returns (bytes memory) {
533         if (success) {
534             return returndata;
535         } else {
536             // Look for revert reason and bubble it up if present
537             if (returndata.length > 0) {
538                 // The easiest way to bubble the revert reason is using memory via assembly
539 
540                 assembly {
541                     let returndata_size := mload(returndata)
542                     revert(add(32, returndata), returndata_size)
543                 }
544             } else {
545                 revert(errorMessage);
546             }
547         }
548     }
549 }
550 
551 
552 
553 
554 /** 
555  *  SourceUnit: /home/highpofly/Documents/code/wob/blockend/contracts/MPRN721.sol
556 */
557             
558 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
559 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 ////import "../IERC721.sol";
564 
565 /**
566  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
567  * @dev See https://eips.ethereum.org/EIPS/eip-721
568  */
569 interface IERC721Metadata is IERC721 {
570     /**
571      * @dev Returns the token collection name.
572      */
573     function name() external view returns (string memory);
574 
575     /**
576      * @dev Returns the token collection symbol.
577      */
578     function symbol() external view returns (string memory);
579 
580     /**
581      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
582      */
583     function tokenURI(uint256 tokenId) external view returns (string memory);
584 }
585 
586 
587 
588 
589 /** 
590  *  SourceUnit: /home/highpofly/Documents/code/wob/blockend/contracts/MPRN721.sol
591 */
592             
593 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
594 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 /**
599  * @title ERC721 token receiver interface
600  * @dev Interface for any contract that wants to support safeTransfers
601  * from ERC721 asset contracts.
602  */
603 interface IERC721Receiver {
604     /**
605      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
606      * by `operator` from `from`, this function is called.
607      *
608      * It must return its Solidity selector to confirm the token transfer.
609      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
610      *
611      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
612      */
613     function onERC721Received(
614         address operator,
615         address from,
616         uint256 tokenId,
617         bytes calldata data
618     ) external returns (bytes4);
619 }
620 
621 
622 
623 
624 /** 
625  *  SourceUnit: /home/highpofly/Documents/code/wob/blockend/contracts/MPRN721.sol
626 */
627             
628 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
629 // OpenZeppelin Contracts v4.4.0 (security/Pausable.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 ////import "../utils/Context.sol";
634 
635 /**
636  * @dev Contract module which allows children to implement an emergency stop
637  * mechanism that can be triggered by an authorized account.
638  *
639  * This module is used through inheritance. It will make available the
640  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
641  * the functions of your contract. Note that they will not be pausable by
642  * simply including this module, only once the modifiers are put in place.
643  */
644 abstract contract Pausable is Context {
645     /**
646      * @dev Emitted when the pause is triggered by `account`.
647      */
648     event Paused(address account);
649 
650     /**
651      * @dev Emitted when the pause is lifted by `account`.
652      */
653     event Unpaused(address account);
654 
655     bool private _paused;
656 
657     /**
658      * @dev Initializes the contract in unpaused state.
659      */
660     constructor() {
661         _paused = false;
662     }
663 
664     /**
665      * @dev Returns true if the contract is paused, and false otherwise.
666      */
667     function paused() public view virtual returns (bool) {
668         return _paused;
669     }
670 
671     /**
672      * @dev Modifier to make a function callable only when the contract is not paused.
673      *
674      * Requirements:
675      *
676      * - The contract must not be paused.
677      */
678     modifier whenNotPaused() {
679         require(!paused(), "Pausable: paused");
680         _;
681     }
682 
683     /**
684      * @dev Modifier to make a function callable only when the contract is paused.
685      *
686      * Requirements:
687      *
688      * - The contract must be paused.
689      */
690     modifier whenPaused() {
691         require(paused(), "Pausable: not paused");
692         _;
693     }
694 
695     /**
696      * @dev Triggers stopped state.
697      *
698      * Requirements:
699      *
700      * - The contract must not be paused.
701      */
702     function _pause() internal virtual whenNotPaused {
703         _paused = true;
704         emit Paused(_msgSender());
705     }
706 
707     /**
708      * @dev Returns to normal state.
709      *
710      * Requirements:
711      *
712      * - The contract must be paused.
713      */
714     function _unpause() internal virtual whenPaused {
715         _paused = false;
716         emit Unpaused(_msgSender());
717     }
718 }
719 
720 
721 
722 
723 /** 
724  *  SourceUnit: /home/highpofly/Documents/code/wob/blockend/contracts/MPRN721.sol
725 */
726             
727 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
728 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
729 
730 pragma solidity ^0.8.0;
731 
732 ////import "./IERC721.sol";
733 ////import "./IERC721Receiver.sol";
734 ////import "./extensions/IERC721Metadata.sol";
735 ////import "../../utils/Address.sol";
736 ////import "../../utils/Context.sol";
737 ////import "../../utils/Strings.sol";
738 ////import "../../utils/introspection/ERC165.sol";
739 
740 /**
741  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
742  * the Metadata extension, but not including the Enumerable extension, which is available separately as
743  * {ERC721Enumerable}.
744  */
745 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
746     using Address for address;
747     using Strings for uint256;
748 
749     // Token name
750     string private _name;
751 
752     // Token symbol
753     string private _symbol;
754 
755     // Mapping from token ID to owner address
756     mapping(uint256 => address) private _owners;
757 
758     // Mapping owner address to token count
759     mapping(address => uint256) private _balances;
760 
761     // Mapping from token ID to approved address
762     mapping(uint256 => address) private _tokenApprovals;
763 
764     // Mapping from owner to operator approvals
765     mapping(address => mapping(address => bool)) private _operatorApprovals;
766 
767     /**
768      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
769      */
770     constructor(string memory name_, string memory symbol_) {
771         _name = name_;
772         _symbol = symbol_;
773     }
774 
775     /**
776      * @dev See {IERC165-supportsInterface}.
777      */
778     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
779         return
780             interfaceId == type(IERC721).interfaceId ||
781             interfaceId == type(IERC721Metadata).interfaceId ||
782             super.supportsInterface(interfaceId);
783     }
784 
785     /**
786      * @dev See {IERC721-balanceOf}.
787      */
788     function balanceOf(address owner) public view virtual override returns (uint256) {
789         require(owner != address(0), "ERC721: balance query for the zero address");
790         return _balances[owner];
791     }
792 
793     /**
794      * @dev See {IERC721-ownerOf}.
795      */
796     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
797         address owner = _owners[tokenId];
798         require(owner != address(0), "ERC721: owner query for nonexistent token");
799         return owner;
800     }
801 
802     /**
803      * @dev See {IERC721Metadata-name}.
804      */
805     function name() public view virtual override returns (string memory) {
806         return _name;
807     }
808 
809     /**
810      * @dev See {IERC721Metadata-symbol}.
811      */
812     function symbol() public view virtual override returns (string memory) {
813         return _symbol;
814     }
815 
816     /**
817      * @dev See {IERC721Metadata-tokenURI}.
818      */
819     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
820         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
821 
822         string memory baseURI = _baseURI();
823         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
824     }
825 
826     /**
827      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
828      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
829      * by default, can be overriden in child contracts.
830      */
831     function _baseURI() internal view virtual returns (string memory) {
832         return "";
833     }
834 
835     /**
836      * @dev See {IERC721-approve}.
837      */
838     function approve(address to, uint256 tokenId) public virtual override {
839         address owner = ERC721.ownerOf(tokenId);
840         require(to != owner, "ERC721: approval to current owner");
841 
842         require(
843             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
844             "ERC721: approve caller is not owner nor approved for all"
845         );
846 
847         _approve(to, tokenId);
848     }
849 
850     /**
851      * @dev See {IERC721-getApproved}.
852      */
853     function getApproved(uint256 tokenId) public view virtual override returns (address) {
854         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
855 
856         return _tokenApprovals[tokenId];
857     }
858 
859     /**
860      * @dev See {IERC721-setApprovalForAll}.
861      */
862     function setApprovalForAll(address operator, bool approved) public virtual override {
863         _setApprovalForAll(_msgSender(), operator, approved);
864     }
865 
866     /**
867      * @dev See {IERC721-isApprovedForAll}.
868      */
869     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
870         return _operatorApprovals[owner][operator];
871     }
872 
873     /**
874      * @dev See {IERC721-transferFrom}.
875      */
876     function transferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) public virtual override {
881         //solhint-disable-next-line max-line-length
882         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
883 
884         _transfer(from, to, tokenId);
885     }
886 
887     /**
888      * @dev See {IERC721-safeTransferFrom}.
889      */
890     function safeTransferFrom(
891         address from,
892         address to,
893         uint256 tokenId
894     ) public virtual override {
895         safeTransferFrom(from, to, tokenId, "");
896     }
897 
898     /**
899      * @dev See {IERC721-safeTransferFrom}.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId,
905         bytes memory _data
906     ) public virtual override {
907         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
908         _safeTransfer(from, to, tokenId, _data);
909     }
910 
911     /**
912      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
913      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
914      *
915      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
916      *
917      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
918      * implement alternative mechanisms to perform token transfer, such as signature-based.
919      *
920      * Requirements:
921      *
922      * - `from` cannot be the zero address.
923      * - `to` cannot be the zero address.
924      * - `tokenId` token must exist and be owned by `from`.
925      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
926      *
927      * Emits a {Transfer} event.
928      */
929     function _safeTransfer(
930         address from,
931         address to,
932         uint256 tokenId,
933         bytes memory _data
934     ) internal virtual {
935         _transfer(from, to, tokenId);
936         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
937     }
938 
939     /**
940      * @dev Returns whether `tokenId` exists.
941      *
942      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
943      *
944      * Tokens start existing when they are minted (`_mint`),
945      * and stop existing when they are burned (`_burn`).
946      */
947     function _exists(uint256 tokenId) internal view virtual returns (bool) {
948         return _owners[tokenId] != address(0);
949     }
950 
951     /**
952      * @dev Returns whether `spender` is allowed to manage `tokenId`.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must exist.
957      */
958     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
959         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
960         address owner = ERC721.ownerOf(tokenId);
961         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
962     }
963 
964     /**
965      * @dev Safely mints `tokenId` and transfers it to `to`.
966      *
967      * Requirements:
968      *
969      * - `tokenId` must not exist.
970      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
971      *
972      * Emits a {Transfer} event.
973      */
974     function _safeMint(address to, uint256 tokenId) internal virtual {
975         _safeMint(to, tokenId, "");
976     }
977 
978     /**
979      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
980      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
981      */
982     function _safeMint(
983         address to,
984         uint256 tokenId,
985         bytes memory _data
986     ) internal virtual {
987         _mint(to, tokenId);
988         require(
989             _checkOnERC721Received(address(0), to, tokenId, _data),
990             "ERC721: transfer to non ERC721Receiver implementer"
991         );
992     }
993 
994     /**
995      * @dev Mints `tokenId` and transfers it to `to`.
996      *
997      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must not exist.
1002      * - `to` cannot be the zero address.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _mint(address to, uint256 tokenId) internal virtual {
1007         require(to != address(0), "ERC721: mint to the zero address");
1008         require(!_exists(tokenId), "ERC721: token already minted");
1009 
1010         _beforeTokenTransfer(address(0), to, tokenId);
1011 
1012         _balances[to] += 1;
1013         _owners[tokenId] = to;
1014 
1015         emit Transfer(address(0), to, tokenId);
1016     }
1017 
1018     /**
1019      * @dev Destroys `tokenId`.
1020      * The approval is cleared when the token is burned.
1021      *
1022      * Requirements:
1023      *
1024      * - `tokenId` must exist.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _burn(uint256 tokenId) internal virtual {
1029         address owner = ERC721.ownerOf(tokenId);
1030 
1031         _beforeTokenTransfer(owner, address(0), tokenId);
1032 
1033         // Clear approvals
1034         _approve(address(0), tokenId);
1035 
1036         _balances[owner] -= 1;
1037         delete _owners[tokenId];
1038 
1039         emit Transfer(owner, address(0), tokenId);
1040     }
1041 
1042     /**
1043      * @dev Transfers `tokenId` from `from` to `to`.
1044      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1045      *
1046      * Requirements:
1047      *
1048      * - `to` cannot be the zero address.
1049      * - `tokenId` token must be owned by `from`.
1050      *
1051      * Emits a {Transfer} event.
1052      */
1053     function _transfer(
1054         address from,
1055         address to,
1056         uint256 tokenId
1057     ) internal virtual {
1058         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1059         require(to != address(0), "ERC721: transfer to the zero address");
1060 
1061         _beforeTokenTransfer(from, to, tokenId);
1062 
1063         // Clear approvals from the previous owner
1064         _approve(address(0), tokenId);
1065 
1066         _balances[from] -= 1;
1067         _balances[to] += 1;
1068         _owners[tokenId] = to;
1069 
1070         emit Transfer(from, to, tokenId);
1071     }
1072 
1073     /**
1074      * @dev Approve `to` to operate on `tokenId`
1075      *
1076      * Emits a {Approval} event.
1077      */
1078     function _approve(address to, uint256 tokenId) internal virtual {
1079         _tokenApprovals[tokenId] = to;
1080         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1081     }
1082 
1083     /**
1084      * @dev Approve `operator` to operate on all of `owner` tokens
1085      *
1086      * Emits a {ApprovalForAll} event.
1087      */
1088     function _setApprovalForAll(
1089         address owner,
1090         address operator,
1091         bool approved
1092     ) internal virtual {
1093         require(owner != operator, "ERC721: approve to caller");
1094         _operatorApprovals[owner][operator] = approved;
1095         emit ApprovalForAll(owner, operator, approved);
1096     }
1097 
1098     /**
1099      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1100      * The call is not executed if the target address is not a contract.
1101      *
1102      * @param from address representing the previous owner of the given token ID
1103      * @param to target address that will receive the tokens
1104      * @param tokenId uint256 ID of the token to be transferred
1105      * @param _data bytes optional data to send along with the call
1106      * @return bool whether the call correctly returned the expected magic value
1107      */
1108     function _checkOnERC721Received(
1109         address from,
1110         address to,
1111         uint256 tokenId,
1112         bytes memory _data
1113     ) private returns (bool) {
1114         if (to.isContract()) {
1115             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1116                 return retval == IERC721Receiver.onERC721Received.selector;
1117             } catch (bytes memory reason) {
1118                 if (reason.length == 0) {
1119                     revert("ERC721: transfer to non ERC721Receiver implementer");
1120                 } else {
1121                     assembly {
1122                         revert(add(32, reason), mload(reason))
1123                     }
1124                 }
1125             }
1126         } else {
1127             return true;
1128         }
1129     }
1130 
1131     /**
1132      * @dev Hook that is called before any token transfer. This includes minting
1133      * and burning.
1134      *
1135      * Calling conditions:
1136      *
1137      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1138      * transferred to `to`.
1139      * - When `from` is zero, `tokenId` will be minted for `to`.
1140      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1141      * - `from` and `to` are never both zero.
1142      *
1143      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1144      */
1145     function _beforeTokenTransfer(
1146         address from,
1147         address to,
1148         uint256 tokenId
1149     ) internal virtual {}
1150 }
1151 
1152 
1153 
1154 
1155 /** 
1156  *  SourceUnit: /home/highpofly/Documents/code/wob/blockend/contracts/MPRN721.sol
1157 */
1158             
1159 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1160 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
1161 
1162 pragma solidity ^0.8.0;
1163 
1164 /**
1165  * @title Counters
1166  * @author Matt Condon (@shrugs)
1167  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1168  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1169  *
1170  * Include with `using Counters for Counters.Counter;`
1171  */
1172 library Counters {
1173     struct Counter {
1174         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1175         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1176         // this feature: see https://github.com/ethereum/solidity/issues/4637
1177         uint256 _value; // default: 0
1178     }
1179 
1180     function current(Counter storage counter) internal view returns (uint256) {
1181         return counter._value;
1182     }
1183 
1184     function increment(Counter storage counter) internal {
1185         unchecked {
1186             counter._value += 1;
1187         }
1188     }
1189 
1190     function decrement(Counter storage counter) internal {
1191         uint256 value = counter._value;
1192         require(value > 0, "Counter: decrement overflow");
1193         unchecked {
1194             counter._value = value - 1;
1195         }
1196     }
1197 
1198     function reset(Counter storage counter) internal {
1199         counter._value = 0;
1200     }
1201 }
1202 
1203 
1204 
1205 
1206 /** 
1207  *  SourceUnit: /home/highpofly/Documents/code/wob/blockend/contracts/MPRN721.sol
1208 */
1209             
1210 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1211 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
1212 
1213 pragma solidity ^0.8.0;
1214 
1215 // CAUTION
1216 // This version of SafeMath should only be used with Solidity 0.8 or later,
1217 // because it relies on the compiler's built in overflow checks.
1218 
1219 /**
1220  * @dev Wrappers over Solidity's arithmetic operations.
1221  *
1222  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1223  * now has built in overflow checking.
1224  */
1225 library SafeMath {
1226     /**
1227      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1228      *
1229      * _Available since v3.4._
1230      */
1231     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1232         unchecked {
1233             uint256 c = a + b;
1234             if (c < a) return (false, 0);
1235             return (true, c);
1236         }
1237     }
1238 
1239     /**
1240      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1241      *
1242      * _Available since v3.4._
1243      */
1244     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1245         unchecked {
1246             if (b > a) return (false, 0);
1247             return (true, a - b);
1248         }
1249     }
1250 
1251     /**
1252      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1253      *
1254      * _Available since v3.4._
1255      */
1256     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1257         unchecked {
1258             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1259             // benefit is lost if 'b' is also tested.
1260             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1261             if (a == 0) return (true, 0);
1262             uint256 c = a * b;
1263             if (c / a != b) return (false, 0);
1264             return (true, c);
1265         }
1266     }
1267 
1268     /**
1269      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1270      *
1271      * _Available since v3.4._
1272      */
1273     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1274         unchecked {
1275             if (b == 0) return (false, 0);
1276             return (true, a / b);
1277         }
1278     }
1279 
1280     /**
1281      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1282      *
1283      * _Available since v3.4._
1284      */
1285     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1286         unchecked {
1287             if (b == 0) return (false, 0);
1288             return (true, a % b);
1289         }
1290     }
1291 
1292     /**
1293      * @dev Returns the addition of two unsigned integers, reverting on
1294      * overflow.
1295      *
1296      * Counterpart to Solidity's `+` operator.
1297      *
1298      * Requirements:
1299      *
1300      * - Addition cannot overflow.
1301      */
1302     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1303         return a + b;
1304     }
1305 
1306     /**
1307      * @dev Returns the subtraction of two unsigned integers, reverting on
1308      * overflow (when the result is negative).
1309      *
1310      * Counterpart to Solidity's `-` operator.
1311      *
1312      * Requirements:
1313      *
1314      * - Subtraction cannot overflow.
1315      */
1316     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1317         return a - b;
1318     }
1319 
1320     /**
1321      * @dev Returns the multiplication of two unsigned integers, reverting on
1322      * overflow.
1323      *
1324      * Counterpart to Solidity's `*` operator.
1325      *
1326      * Requirements:
1327      *
1328      * - Multiplication cannot overflow.
1329      */
1330     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1331         return a * b;
1332     }
1333 
1334     /**
1335      * @dev Returns the integer division of two unsigned integers, reverting on
1336      * division by zero. The result is rounded towards zero.
1337      *
1338      * Counterpart to Solidity's `/` operator.
1339      *
1340      * Requirements:
1341      *
1342      * - The divisor cannot be zero.
1343      */
1344     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1345         return a / b;
1346     }
1347 
1348     /**
1349      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1350      * reverting when dividing by zero.
1351      *
1352      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1353      * opcode (which leaves remaining gas untouched) while Solidity uses an
1354      * invalid opcode to revert (consuming all remaining gas).
1355      *
1356      * Requirements:
1357      *
1358      * - The divisor cannot be zero.
1359      */
1360     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1361         return a % b;
1362     }
1363 
1364     /**
1365      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1366      * overflow (when the result is negative).
1367      *
1368      * CAUTION: This function is deprecated because it requires allocating memory for the error
1369      * message unnecessarily. For custom revert reasons use {trySub}.
1370      *
1371      * Counterpart to Solidity's `-` operator.
1372      *
1373      * Requirements:
1374      *
1375      * - Subtraction cannot overflow.
1376      */
1377     function sub(
1378         uint256 a,
1379         uint256 b,
1380         string memory errorMessage
1381     ) internal pure returns (uint256) {
1382         unchecked {
1383             require(b <= a, errorMessage);
1384             return a - b;
1385         }
1386     }
1387 
1388     /**
1389      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1390      * division by zero. The result is rounded towards zero.
1391      *
1392      * Counterpart to Solidity's `/` operator. Note: this function uses a
1393      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1394      * uses an invalid opcode to revert (consuming all remaining gas).
1395      *
1396      * Requirements:
1397      *
1398      * - The divisor cannot be zero.
1399      */
1400     function div(
1401         uint256 a,
1402         uint256 b,
1403         string memory errorMessage
1404     ) internal pure returns (uint256) {
1405         unchecked {
1406             require(b > 0, errorMessage);
1407             return a / b;
1408         }
1409     }
1410 
1411     /**
1412      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1413      * reverting with custom message when dividing by zero.
1414      *
1415      * CAUTION: This function is deprecated because it requires allocating memory for the error
1416      * message unnecessarily. For custom revert reasons use {tryMod}.
1417      *
1418      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1419      * opcode (which leaves remaining gas untouched) while Solidity uses an
1420      * invalid opcode to revert (consuming all remaining gas).
1421      *
1422      * Requirements:
1423      *
1424      * - The divisor cannot be zero.
1425      */
1426     function mod(
1427         uint256 a,
1428         uint256 b,
1429         string memory errorMessage
1430     ) internal pure returns (uint256) {
1431         unchecked {
1432             require(b > 0, errorMessage);
1433             return a % b;
1434         }
1435     }
1436 }
1437 
1438 
1439 
1440 
1441 /** 
1442  *  SourceUnit: /home/highpofly/Documents/code/wob/blockend/contracts/MPRN721.sol
1443 */
1444             
1445 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1446 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/MerkleProof.sol)
1447 
1448 pragma solidity ^0.8.0;
1449 
1450 /**
1451  * @dev These functions deal with verification of Merkle Trees proofs.
1452  *
1453  * The proofs can be generated using the JavaScript library
1454  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1455  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1456  *
1457  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1458  */
1459 library MerkleProof {
1460     /**
1461      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1462      * defined by `root`. For this, a `proof` must be provided, containing
1463      * sibling hashes on the branch from the leaf to the root of the tree. Each
1464      * pair of leaves and each pair of pre-images are assumed to be sorted.
1465      */
1466     function verify(
1467         bytes32[] memory proof,
1468         bytes32 root,
1469         bytes32 leaf
1470     ) internal pure returns (bool) {
1471         return processProof(proof, leaf) == root;
1472     }
1473 
1474     /**
1475      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1476      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1477      * hash matches the root of the tree. When processing the proof, the pairs
1478      * of leafs & pre-images are assumed to be sorted.
1479      *
1480      * _Available since v4.4._
1481      */
1482     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1483         bytes32 computedHash = leaf;
1484         for (uint256 i = 0; i < proof.length; i++) {
1485             bytes32 proofElement = proof[i];
1486             if (computedHash <= proofElement) {
1487                 // Hash(current computed hash + current element of the proof)
1488                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1489             } else {
1490                 // Hash(current element of the proof + current computed hash)
1491                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1492             }
1493         }
1494         return computedHash;
1495     }
1496 }
1497 
1498 
1499 
1500 
1501 /** 
1502  *  SourceUnit: /home/highpofly/Documents/code/wob/blockend/contracts/MPRN721.sol
1503 */
1504             
1505 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1506 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1507 
1508 pragma solidity ^0.8.0;
1509 
1510 ////import "../utils/Context.sol";
1511 
1512 /**
1513  * @dev Contract module which provides a basic access control mechanism, where
1514  * there is an account (an owner) that can be granted exclusive access to
1515  * specific functions.
1516  *
1517  * By default, the owner account will be the one that deploys the contract. This
1518  * can later be changed with {transferOwnership}.
1519  *
1520  * This module is used through inheritance. It will make available the modifier
1521  * `onlyOwner`, which can be applied to your functions to restrict their use to
1522  * the owner.
1523  */
1524 abstract contract Ownable is Context {
1525     address private _owner;
1526 
1527     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1528 
1529     /**
1530      * @dev Initializes the contract setting the deployer as the initial owner.
1531      */
1532     constructor() {
1533         _transferOwnership(_msgSender());
1534     }
1535 
1536     /**
1537      * @dev Returns the address of the current owner.
1538      */
1539     function owner() public view virtual returns (address) {
1540         return _owner;
1541     }
1542 
1543     /**
1544      * @dev Throws if called by any account other than the owner.
1545      */
1546     modifier onlyOwner() {
1547         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1548         _;
1549     }
1550 
1551     /**
1552      * @dev Leaves the contract without owner. It will not be possible to call
1553      * `onlyOwner` functions anymore. Can only be called by the current owner.
1554      *
1555      * NOTE: Renouncing ownership will leave the contract without an owner,
1556      * thereby removing any functionality that is only available to the owner.
1557      */
1558     function renounceOwnership() public virtual onlyOwner {
1559         _transferOwnership(address(0));
1560     }
1561 
1562     /**
1563      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1564      * Can only be called by the current owner.
1565      */
1566     function transferOwnership(address newOwner) public virtual onlyOwner {
1567         require(newOwner != address(0), "Ownable: new owner is the zero address");
1568         _transferOwnership(newOwner);
1569     }
1570 
1571     /**
1572      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1573      * Internal function without access restriction.
1574      */
1575     function _transferOwnership(address newOwner) internal virtual {
1576         address oldOwner = _owner;
1577         _owner = newOwner;
1578         emit OwnershipTransferred(oldOwner, newOwner);
1579     }
1580 }
1581 
1582 
1583 
1584 
1585 /** 
1586  *  SourceUnit: /home/highpofly/Documents/code/wob/blockend/contracts/MPRN721.sol
1587 */
1588             
1589 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1590 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Pausable.sol)
1591 
1592 pragma solidity ^0.8.0;
1593 
1594 ////import "../ERC721.sol";
1595 ////import "../../../security/Pausable.sol";
1596 
1597 /**
1598  * @dev ERC721 token with pausable token transfers, minting and burning.
1599  *
1600  * Useful for scenarios such as preventing trades until the end of an evaluation
1601  * period, or having an emergency switch for freezing all token transfers in the
1602  * event of a large bug.
1603  */
1604 abstract contract ERC721Pausable is ERC721, Pausable {
1605     /**
1606      * @dev See {ERC721-_beforeTokenTransfer}.
1607      *
1608      * Requirements:
1609      *
1610      * - the contract must not be paused.
1611      */
1612     function _beforeTokenTransfer(
1613         address from,
1614         address to,
1615         uint256 tokenId
1616     ) internal virtual override {
1617         super._beforeTokenTransfer(from, to, tokenId);
1618 
1619         require(!paused(), "ERC721Pausable: token transfer while paused");
1620     }
1621 }
1622 
1623 
1624 
1625 
1626 /** 
1627  *  SourceUnit: /home/highpofly/Documents/code/wob/blockend/contracts/MPRN721.sol
1628 */
1629             
1630 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1631 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Burnable.sol)
1632 
1633 pragma solidity ^0.8.0;
1634 
1635 ////import "../ERC721.sol";
1636 ////import "../../../utils/Context.sol";
1637 
1638 /**
1639  * @title ERC721 Burnable Token
1640  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1641  */
1642 abstract contract ERC721Burnable is Context, ERC721 {
1643     /**
1644      * @dev Burns `tokenId`. See {ERC721-_burn}.
1645      *
1646      * Requirements:
1647      *
1648      * - The caller must own `tokenId` or be an approved operator.
1649      */
1650     function burn(uint256 tokenId) public virtual {
1651         //solhint-disable-next-line max-line-length
1652         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1653         _burn(tokenId);
1654     }
1655 }
1656 
1657 
1658 /** 
1659  *  SourceUnit: /home/highpofly/Documents/code/wob/blockend/contracts/MPRN721.sol
1660 */
1661 
1662 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1663 pragma solidity ^0.8.0;
1664 
1665 /// @notice ERC721
1666 ////import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
1667 ////import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
1668 ////import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
1669 
1670 /// @notice peripheral
1671 ////import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
1672 
1673 /// @notice libraries
1674 ////import "../node_modules/@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
1675 ////import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
1676 ////import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";
1677 
1678 /**
1679  * @title MPRN721
1680  * @notice ERC721-ready MPRN721 contract
1681  * @author cryptoware.eth | Metapreneurs
1682 **/
1683 contract MPRN721 is Ownable, ERC721, ERC721Burnable, ERC721Pausable {
1684     /// @notice using safe math for uints
1685     using SafeMath for uint256;
1686     using SafeMath for uint32;
1687 
1688     /// @notice using Strings for uints conversion (tokenId)
1689     using Strings for uint256;
1690 
1691     /// @notice using Address for addresses extended functionality
1692     using Address for address;
1693 
1694     /// @notice using MerkleProof Library to verify Merkle proofs
1695 	using MerkleProof for bytes32[];
1696 
1697     /// @notice using a counter to increment next Id to be minted
1698     using Counters for Counters.Counter;
1699 
1700     /// @notice Enum representing minting phases
1701     enum Phase {
1702         Presale,
1703         Public
1704     }
1705 
1706     /// @notice EIP721-required Base URI
1707     string private _baseTokenURI;
1708 
1709     /// @notice URI to hide NFTS during minting
1710     string public _notRevealedUri;
1711 
1712     /// @notice Base extension for metadata
1713     string private _baseExtension;
1714 
1715     /// @notice the current phase of the minting
1716     Phase private _phase;
1717 
1718     /// @notice token id to be minted next
1719     Counters.Counter private _tokenIdTracker;
1720 
1721     /// @notice root of the Merkle tree
1722     bytes32 private _merkleRoot;
1723 
1724     /// @notice The rate of minting per phase
1725     mapping(Phase => uint256) public _mintPrice;
1726 
1727     /// @notice Max number of NFTs to be minted
1728     uint32 private _maxTokenId;
1729 
1730     /// @notice max amount of nfts that can be minted per wallet address
1731     uint32 private _presaleLimit;
1732 
1733     /// @notice Splitter Contract that will collect mint fees
1734     address payable private _mintingBeneficiary;
1735 
1736     /// @notice public metadata locked flag
1737     bool public locked;
1738 
1739     /// @notice public revealed state
1740     bool public revealed;
1741 
1742     /// @notice Minting events definition
1743     event AdminMinted(address indexed to, uint indexed tokenId);
1744     event Minted(address indexed to, uint indexed tokenId);
1745 
1746     /**
1747      * @notice Event published when a phase is triggered
1748      * @param phase next minting phase
1749      * @param mintCost minting cost in next phase
1750      * @param presaleLimit minting limit per wallet address
1751     **/
1752     event PhaseTriggered(Phase indexed phase, uint256 indexed mintCost, uint indexed presaleLimit);
1753 
1754     /// @notice metadata not locked modifier
1755     modifier notLocked() {
1756         require(!locked, "MPRN721: Metadata URIs are locked");
1757         _;
1758     }
1759 
1760     /// @notice Art not revealed modifier
1761     modifier notRevealed() {
1762         require(!revealed, "MPRN721: Art is already revealed");
1763         _;
1764     }
1765 
1766     /// @notice Art revealed modifier
1767     modifier Revealed() {
1768         require(revealed, "MPRN721: Art is not revealed");
1769         _;
1770     }
1771 
1772     /**
1773      * @notice constructor
1774      * @param name the name of the EIP721 Contract
1775      * @param symbol the token symbol
1776      * @param baseTokenURI EIP721-required Base URI
1777      * @param notRevealedUri URI to hide NFTs during minting
1778      * @param merkleRoot merkle tree root of the hashed whitelist addresses
1779      * @param mbeneficiary the contract Splitter that will receive minting funds
1780     **/
1781     constructor(
1782         string memory name,
1783         string memory symbol,
1784         string memory baseTokenURI,
1785         string memory notRevealedUri,
1786         bytes32 merkleRoot,
1787         address mbeneficiary
1788     ) ERC721(name, symbol) Ownable() {
1789         _phase = Phase.Presale;
1790         _mintPrice[_phase] = 0.1 ether;
1791 
1792         _presaleLimit = 3;
1793 
1794         _maxTokenId = 11111;
1795 
1796         _merkleRoot = merkleRoot;
1797 
1798         _baseExtension = ".json";
1799         _baseTokenURI = baseTokenURI;
1800         _notRevealedUri = notRevealedUri;
1801 
1802         _mintingBeneficiary = payable(mbeneficiary);
1803 
1804         _tokenIdTracker.increment();
1805     }
1806 
1807     /// @notice receive fallback should revert
1808     receive() external payable {
1809         revert("MPRN721: Please use Mint or Admin calls");
1810     }
1811 
1812     /// @notice default fallback should revert
1813     fallback() external payable {
1814         revert("MPRN721: Please use Mint or Admin calls");
1815     }
1816 
1817     /// @notice returns the base URI for the contract
1818     function _baseURI() internal view virtual override returns (string memory) {
1819         return _baseTokenURI;
1820     }
1821 
1822     /**
1823      * @dev See {IERC721Metadata-tokenURI}.
1824     */
1825     function tokenURI(uint256 tokenId)
1826         public
1827         view
1828         virtual
1829         override
1830         returns (string memory)
1831     {
1832         return revealed ?
1833             string(abi.encodePacked(super.tokenURI(tokenId), _baseExtension)) : _notRevealedUri;
1834     }
1835 
1836     /**
1837      * @notice updates the 2 addresses invovled in the contract flow
1838      * @param mintingBeneficiary the contract Splitter that will receive minting and royalties funds
1839      * @param _owner the new admin address
1840     **/
1841     function updateAddressesAndTransferOwnership(
1842         address mintingBeneficiary,
1843         address _owner
1844     ) public onlyOwner {
1845         changeMintBeneficiary(mintingBeneficiary);
1846         transferOwnership(_owner);
1847     }
1848 
1849     /**
1850      * @notice a function for admins to mint cost-free
1851      * @param to the address to send the minted token to
1852     **/
1853     function adminMint(address to)
1854         external
1855         whenNotPaused
1856         onlyOwner
1857     {
1858         require(to != address(0), "MPRN721: Address cannot be 0");
1859         
1860         maxSupplyNotExceeded(1);
1861 
1862         _safeMint(to, _tokenIdTracker.current());
1863 
1864         emit AdminMinted(to, _tokenIdTracker.current());
1865 
1866         _tokenIdTracker.increment();
1867     }
1868 
1869     /**
1870      * @notice the public minting function -- requires 1 ether sent
1871      * @param to the address to send the minted token to
1872      * @param amount amount of tokens to mint
1873      * @param _proof verify if msg.sender is whitelisted whenever presale
1874     **/
1875     function mint(address to, uint32 amount,  bytes32[] memory _proof)
1876         external
1877         payable
1878         whenNotPaused
1879     {
1880         uint256 received = msg.value;
1881 
1882         require(to != address(0), "MPRN721: Address cannot be 0");
1883         require(
1884             received == _mintPrice[_phase].mul(amount),
1885             "MPRN721: Ether sent mismatch with mint price"
1886         );
1887 
1888         maxSupplyNotExceeded(amount);
1889 
1890         if(_phase == Phase.Presale){
1891             require(amount <= 3, 'MPRN721: Allowed amount to mint exceeded');
1892 
1893             isAllowedToMint(_proof);
1894 
1895             walletLimitNotExceeded(to, amount);
1896         } else {
1897             require(amount <= 10, 'MPRN721: Allowed amount to mint exceeded');
1898             walletLimitNotExceeded(to, amount);
1899         }
1900 
1901         for(uint32 i=amount; i>0; i--){
1902             _safeMint(to, _tokenIdTracker.current());
1903 
1904             emit Minted(to, _tokenIdTracker.current());
1905 
1906             _tokenIdTracker.increment();
1907         }
1908 
1909         _forwardFunds(received);
1910     }
1911 
1912     /// @notice pausing the contract minting and token transfer
1913     function pause() public virtual onlyOwner {
1914         _pause();
1915     }
1916 
1917     /// @notice unpausing the contract minting and token transfer
1918     function unpause() public virtual onlyOwner {
1919         _unpause();
1920     }
1921 
1922     /**
1923      * @notice changes the minting beneficiary payable address
1924      * @param beneficiary the contract Splitter that will receive minting funds
1925     **/
1926     function changeMintBeneficiary(address beneficiary) public onlyOwner {
1927         require(
1928             beneficiary != address(0),
1929             "MPRN721: Minting beneficiary cannot be address 0"
1930         );
1931         require(
1932             beneficiary != _mintingBeneficiary,
1933             "MPRN721: beneficiary cannot be same as previous"
1934         );
1935         _mintingBeneficiary = payable(beneficiary);
1936     }
1937 
1938     /**
1939      * @notice Updates the phase and minting cost
1940      * @param phase the phase ID to set next
1941      * @param mintCost the cost of minting next phase
1942      * @param presaleLimit set limit per wallet address
1943     **/
1944     function setPhase(
1945         Phase phase, 
1946         uint256 mintCost,
1947         uint32 presaleLimit
1948     ) public onlyOwner{
1949         require(mintCost > 0, "MPRN721 : rate is 0");
1950         require(_phase != phase, "MPRN721 : Phase cannot be the same");
1951         
1952         /// @notice set phase
1953         _phase = phase;
1954 
1955         _presaleLimit = presaleLimit;
1956 
1957         /// @notice set phase cost
1958         changeMintCost(mintCost);
1959 
1960         emit PhaseTriggered(_phase, mintCost, presaleLimit);
1961     }
1962 
1963     /// @notice gets the current phase of minting
1964     function getPhase() public view returns (Phase) {
1965         return _phase;
1966     }
1967 
1968     /**
1969      * @notice changes the minting cost
1970      * @param mintCost new minting cost
1971     **/
1972     function changeMintCost(uint256 mintCost) public onlyOwner {
1973         require(
1974             mintCost != _mintPrice[_phase],
1975             "MPRN721: mint Cost cannot be same as previous"
1976         );
1977         _mintPrice[_phase] = mintCost;
1978     }
1979 
1980     /**
1981      * @notice changes the Base URI
1982      * @param newBaseURI the new Base URI
1983     **/
1984     function changeBaseURI(string memory newBaseURI)
1985         public
1986         onlyOwner
1987         notLocked
1988     {
1989         require((keccak256(abi.encodePacked((_baseTokenURI))) != keccak256(abi.encodePacked((newBaseURI)))), "MPRN721: Base URI cannot be same as previous");
1990         _baseTokenURI = newBaseURI;
1991     }
1992 
1993     /**
1994      * @notice changes to not revealed URI
1995      * @param newNotRevealedUri the new notRevealed URI
1996     **/
1997     function changeNotRevealedURI(string memory newNotRevealedUri)
1998         public
1999         onlyOwner
2000         notRevealed
2001     {
2002         require((keccak256(abi.encodePacked((newNotRevealedUri))) != keccak256(abi.encodePacked((_notRevealedUri)))), "MPRN721: Base URI cannot be same as previous");
2003         _notRevealedUri = newNotRevealedUri;
2004     }
2005     
2006     /**
2007      * @notice reveal NFTs
2008     **/
2009     function reveal() 
2010         public 
2011         onlyOwner 
2012         notRevealed
2013     {
2014       revealed = true;
2015     }
2016 
2017     /**
2018      * @notice lock metadata forever
2019     **/
2020     function lockMetadata() 
2021         public 
2022         onlyOwner 
2023         notLocked 
2024         Revealed
2025     {
2026         locked = true;
2027     }
2028 
2029     /**
2030      * @notice changes merkleRoot in case whitelist updated
2031      * @param merkleRoot root of the Merkle tree
2032     **/
2033     function changeMerkleRoot(bytes32 merkleRoot)
2034         public
2035         onlyOwner
2036     {
2037         require(
2038             merkleRoot != _merkleRoot, 
2039             "MPRN721: Merkle root cannot be same as previous"
2040         );
2041         _merkleRoot = merkleRoot;
2042     }
2043 
2044     /**
2045      * @notice the public function for checking if more tokens can be minted
2046     **/
2047     function maxSupplyNotExceeded(uint32 amount) public view returns (bool) {
2048          require(_tokenIdTracker.current().add(amount.sub(1)) <= _maxTokenId, "MPRN721: max NFT limit exceeded");
2049          return true;
2050     }
2051 
2052     /**
2053      * @notice the public function validating addresses to presale phase
2054      * @param _proof hashes validating that a leaf exists inside merkle tree aka _merkleRoot
2055     **/
2056     function isAllowedToMint(bytes32[] memory _proof) internal view returns (bool) {
2057         require(
2058             MerkleProof.verify(_proof, _merkleRoot, keccak256(abi.encodePacked(msg.sender))),
2059             "MPRN721: Caller is not whitelisted for Presale"
2060         );
2061         return true;
2062     }
2063 
2064     /**
2065      * @notice checks if an address reached limit per wallet
2066      * @param minter address user minting nft
2067      * @param amount nfts amount to mint
2068     **/
2069     function walletLimitNotExceeded(address minter, uint32 amount) internal view returns (bool) {
2070         require(balanceOf(minter).add(amount) <= _presaleLimit, "MPRN721: max NFT per address exceeded");
2071         return true;
2072     }
2073 
2074     /**
2075      * @notice Current totalSupply
2076     **/
2077     function currentSupply() external view returns (uint256) {
2078         return (_tokenIdTracker.current()).sub(1);
2079     }
2080 
2081     /**
2082      * @notice Determines how ETH is stored/forwarded on purchases.
2083      * @param received amount to forward
2084     **/
2085     function _forwardFunds(uint256 received) internal {
2086         /// @notice forward fund to Splitter contract using CALL to avoid 2300 stipend limit
2087         (bool success, ) = _mintingBeneficiary.call{value: received}("");
2088         require(success, "MPRN721: Failed to forward funds");
2089     }
2090 
2091     /**
2092      * @notice before transfer hook function
2093      * @param from the address to send the token from
2094      * @param to the address to send the token to
2095      * @param tokenId to token ID to be sent
2096     **/
2097     function _beforeTokenTransfer(
2098         address from,
2099         address to,
2100         uint256 tokenId
2101     ) internal virtual override(ERC721, ERC721Pausable) {
2102         super._beforeTokenTransfer(from, to, tokenId);
2103     }
2104 }