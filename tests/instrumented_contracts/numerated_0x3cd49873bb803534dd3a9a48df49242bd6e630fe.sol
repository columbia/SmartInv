1 /** 
2  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
3 */
4             
5 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 
30 
31 
32 /** 
33  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
34 */
35             
36 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Interface of the ERC165 standard, as defined in the
42  * https://eips.ethereum.org/EIPS/eip-165[EIP].
43  *
44  * Implementers can declare support of contract interfaces, which can then be
45  * queried by others ({ERC165Checker}).
46  *
47  * For an implementation, see {ERC165}.
48  */
49 interface IERC165 {
50     /**
51      * @dev Returns true if this contract implements the interface defined by
52      * `interfaceId`. See the corresponding
53      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
54      * to learn more about how these ids are created.
55      *
56      * This function call must use less than 30 000 gas.
57      */
58     function supportsInterface(bytes4 interfaceId) external view returns (bool);
59 }
60 
61 
62 
63 
64 /** 
65  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
66 */
67             
68 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
69 
70 pragma solidity ^0.8.0;
71 
72 ////import "../utils/introspection/IERC165.sol";
73 
74 
75 
76 
77 /** 
78  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
79 */
80             
81 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
82 
83 pragma solidity ^0.8.0;
84 
85 ////import "../../utils/introspection/IERC165.sol";
86 
87 /**
88  * @dev Required interface of an ERC721 compliant contract.
89  */
90 interface IERC721 is IERC165 {
91     /**
92      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
95 
96     /**
97      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
98      */
99     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
100 
101     /**
102      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
103      */
104     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
105 
106     /**
107      * @dev Returns the number of tokens in ``owner``'s account.
108      */
109     function balanceOf(address owner) external view returns (uint256 balance);
110 
111     /**
112      * @dev Returns the owner of the `tokenId` token.
113      *
114      * Requirements:
115      *
116      * - `tokenId` must exist.
117      */
118     function ownerOf(uint256 tokenId) external view returns (address owner);
119 
120     /**
121      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
122      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
123      *
124      * Requirements:
125      *
126      * - `from` cannot be the zero address.
127      * - `to` cannot be the zero address.
128      * - `tokenId` token must exist and be owned by `from`.
129      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
130      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
131      *
132      * Emits a {Transfer} event.
133      */
134     function safeTransferFrom(
135         address from,
136         address to,
137         uint256 tokenId
138     ) external;
139 
140     /**
141      * @dev Transfers `tokenId` token from `from` to `to`.
142      *
143      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
144      *
145      * Requirements:
146      *
147      * - `from` cannot be the zero address.
148      * - `to` cannot be the zero address.
149      * - `tokenId` token must be owned by `from`.
150      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
151      *
152      * Emits a {Transfer} event.
153      */
154     function transferFrom(
155         address from,
156         address to,
157         uint256 tokenId
158     ) external;
159 
160     /**
161      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
162      * The approval is cleared when the token is transferred.
163      *
164      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
165      *
166      * Requirements:
167      *
168      * - The caller must own the token or be an approved operator.
169      * - `tokenId` must exist.
170      *
171      * Emits an {Approval} event.
172      */
173     function approve(address to, uint256 tokenId) external;
174 
175     /**
176      * @dev Returns the account approved for `tokenId` token.
177      *
178      * Requirements:
179      *
180      * - `tokenId` must exist.
181      */
182     function getApproved(uint256 tokenId) external view returns (address operator);
183 
184     /**
185      * @dev Approve or remove `operator` as an operator for the caller.
186      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
187      *
188      * Requirements:
189      *
190      * - The `operator` cannot be the caller.
191      *
192      * Emits an {ApprovalForAll} event.
193      */
194     function setApprovalForAll(address operator, bool _approved) external;
195 
196     /**
197      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
198      *
199      * See {setApprovalForAll}
200      */
201     function isApprovedForAll(address owner, address operator) external view returns (bool);
202 
203     /**
204      * @dev Safely transfers `tokenId` token from `from` to `to`.
205      *
206      * Requirements:
207      *
208      * - `from` cannot be the zero address.
209      * - `to` cannot be the zero address.
210      * - `tokenId` token must exist and be owned by `from`.
211      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
212      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
213      *
214      * Emits a {Transfer} event.
215      */
216     function safeTransferFrom(
217         address from,
218         address to,
219         uint256 tokenId,
220         bytes calldata data
221     ) external;
222 }
223 
224 
225 
226 
227 /** 
228  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
229 */
230             
231 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
232 
233 pragma solidity ^0.8.0;
234 
235 ////import "./IERC165.sol";
236 
237 /**
238  * @dev Implementation of the {IERC165} interface.
239  *
240  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
241  * for the additional interface id that will be supported. For example:
242  *
243  * ```solidity
244  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
245  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
246  * }
247  * ```
248  *
249  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
250  */
251 abstract contract ERC165 is IERC165 {
252     /**
253      * @dev See {IERC165-supportsInterface}.
254      */
255     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
256         return interfaceId == type(IERC165).interfaceId;
257     }
258 }
259 
260 
261 
262 
263 /** 
264  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
265 */
266             
267 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
268 
269 pragma solidity ^0.8.0;
270 
271 /**
272  * @dev String operations.
273  */
274 library Strings {
275     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
276 
277     /**
278      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
279      */
280     function toString(uint256 value) internal pure returns (string memory) {
281         // Inspired by OraclizeAPI's implementation - MIT licence
282         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
283 
284         if (value == 0) {
285             return "0";
286         }
287         uint256 temp = value;
288         uint256 digits;
289         while (temp != 0) {
290             digits++;
291             temp /= 10;
292         }
293         bytes memory buffer = new bytes(digits);
294         while (value != 0) {
295             digits -= 1;
296             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
297             value /= 10;
298         }
299         return string(buffer);
300     }
301 
302     /**
303      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
304      */
305     function toHexString(uint256 value) internal pure returns (string memory) {
306         if (value == 0) {
307             return "0x00";
308         }
309         uint256 temp = value;
310         uint256 length = 0;
311         while (temp != 0) {
312             length++;
313             temp >>= 8;
314         }
315         return toHexString(value, length);
316     }
317 
318     /**
319      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
320      */
321     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
322         bytes memory buffer = new bytes(2 * length + 2);
323         buffer[0] = "0";
324         buffer[1] = "x";
325         for (uint256 i = 2 * length + 1; i > 1; --i) {
326             buffer[i] = _HEX_SYMBOLS[value & 0xf];
327             value >>= 4;
328         }
329         require(value == 0, "Strings: hex length insufficient");
330         return string(buffer);
331     }
332 }
333 
334 
335 
336 
337 /** 
338  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
339 */
340             
341 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @dev Collection of functions related to the address type
347  */
348 library Address {
349     /**
350      * @dev Returns true if `account` is a contract.
351      *
352      * [////IMPORTANT]
353      * ====
354      * It is unsafe to assume that an address for which this function returns
355      * false is an externally-owned account (EOA) and not a contract.
356      *
357      * Among others, `isContract` will return false for the following
358      * types of addresses:
359      *
360      *  - an externally-owned account
361      *  - a contract in construction
362      *  - an address where a contract will be created
363      *  - an address where a contract lived, but was destroyed
364      * ====
365      */
366     function isContract(address account) internal view returns (bool) {
367         // This method relies on extcodesize, which returns 0 for contracts in
368         // construction, since the code is only stored at the end of the
369         // constructor execution.
370 
371         uint256 size;
372         assembly {
373             size := extcodesize(account)
374         }
375         return size > 0;
376     }
377 
378     /**
379      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
380      * `recipient`, forwarding all available gas and reverting on errors.
381      *
382      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
383      * of certain opcodes, possibly making contracts go over the 2300 gas limit
384      * imposed by `transfer`, making them unable to receive funds via
385      * `transfer`. {sendValue} removes this limitation.
386      *
387      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
388      *
389      * ////IMPORTANT: because control is transferred to `recipient`, care must be
390      * taken to not create reentrancy vulnerabilities. Consider using
391      * {ReentrancyGuard} or the
392      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
393      */
394     function sendValue(address payable recipient, uint256 amount) internal {
395         require(address(this).balance >= amount, "Address: insufficient balance");
396 
397         (bool success, ) = recipient.call{value: amount}("");
398         require(success, "Address: unable to send value, recipient may have reverted");
399     }
400 
401     /**
402      * @dev Performs a Solidity function call using a low level `call`. A
403      * plain `call` is an unsafe replacement for a function call: use this
404      * function instead.
405      *
406      * If `target` reverts with a revert reason, it is bubbled up by this
407      * function (like regular Solidity function calls).
408      *
409      * Returns the raw returned data. To convert to the expected return value,
410      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
411      *
412      * Requirements:
413      *
414      * - `target` must be a contract.
415      * - calling `target` with `data` must not revert.
416      *
417      * _Available since v3.1._
418      */
419     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
420         return functionCall(target, data, "Address: low-level call failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
425      * `errorMessage` as a fallback revert reason when `target` reverts.
426      *
427      * _Available since v3.1._
428      */
429     function functionCall(
430         address target,
431         bytes memory data,
432         string memory errorMessage
433     ) internal returns (bytes memory) {
434         return functionCallWithValue(target, data, 0, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but also transferring `value` wei to `target`.
440      *
441      * Requirements:
442      *
443      * - the calling contract must have an ETH balance of at least `value`.
444      * - the called Solidity function must be `payable`.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(
449         address target,
450         bytes memory data,
451         uint256 value
452     ) internal returns (bytes memory) {
453         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
458      * with `errorMessage` as a fallback revert reason when `target` reverts.
459      *
460      * _Available since v3.1._
461      */
462     function functionCallWithValue(
463         address target,
464         bytes memory data,
465         uint256 value,
466         string memory errorMessage
467     ) internal returns (bytes memory) {
468         require(address(this).balance >= value, "Address: insufficient balance for call");
469         require(isContract(target), "Address: call to non-contract");
470 
471         (bool success, bytes memory returndata) = target.call{value: value}(data);
472         return verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but performing a static call.
478      *
479      * _Available since v3.3._
480      */
481     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
482         return functionStaticCall(target, data, "Address: low-level static call failed");
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
487      * but performing a static call.
488      *
489      * _Available since v3.3._
490      */
491     function functionStaticCall(
492         address target,
493         bytes memory data,
494         string memory errorMessage
495     ) internal view returns (bytes memory) {
496         require(isContract(target), "Address: static call to non-contract");
497 
498         (bool success, bytes memory returndata) = target.staticcall(data);
499         return verifyCallResult(success, returndata, errorMessage);
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
504      * but performing a delegate call.
505      *
506      * _Available since v3.4._
507      */
508     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
509         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
514      * but performing a delegate call.
515      *
516      * _Available since v3.4._
517      */
518     function functionDelegateCall(
519         address target,
520         bytes memory data,
521         string memory errorMessage
522     ) internal returns (bytes memory) {
523         require(isContract(target), "Address: delegate call to non-contract");
524 
525         (bool success, bytes memory returndata) = target.delegatecall(data);
526         return verifyCallResult(success, returndata, errorMessage);
527     }
528 
529     /**
530      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
531      * revert reason using the provided one.
532      *
533      * _Available since v4.3._
534      */
535     function verifyCallResult(
536         bool success,
537         bytes memory returndata,
538         string memory errorMessage
539     ) internal pure returns (bytes memory) {
540         if (success) {
541             return returndata;
542         } else {
543             // Look for revert reason and bubble it up if present
544             if (returndata.length > 0) {
545                 // The easiest way to bubble the revert reason is using memory via assembly
546 
547                 assembly {
548                     let returndata_size := mload(returndata)
549                     revert(add(32, returndata), returndata_size)
550                 }
551             } else {
552                 revert(errorMessage);
553             }
554         }
555     }
556 }
557 
558 
559 
560 
561 /** 
562  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
563 */
564             
565 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
566 
567 pragma solidity ^0.8.0;
568 
569 ////import "../IERC721.sol";
570 
571 /**
572  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
573  * @dev See https://eips.ethereum.org/EIPS/eip-721
574  */
575 interface IERC721Metadata is IERC721 {
576     /**
577      * @dev Returns the token collection name.
578      */
579     function name() external view returns (string memory);
580 
581     /**
582      * @dev Returns the token collection symbol.
583      */
584     function symbol() external view returns (string memory);
585 
586     /**
587      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
588      */
589     function tokenURI(uint256 tokenId) external view returns (string memory);
590 }
591 
592 
593 
594 
595 /** 
596  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
597 */
598             
599 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
600 
601 pragma solidity ^0.8.0;
602 
603 /**
604  * @title ERC721 token receiver interface
605  * @dev Interface for any contract that wants to support safeTransfers
606  * from ERC721 asset contracts.
607  */
608 interface IERC721Receiver {
609     /**
610      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
611      * by `operator` from `from`, this function is called.
612      *
613      * It must return its Solidity selector to confirm the token transfer.
614      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
615      *
616      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
617      */
618     function onERC721Received(
619         address operator,
620         address from,
621         uint256 tokenId,
622         bytes calldata data
623     ) external returns (bytes4);
624 }
625 
626 
627 
628 
629 /** 
630  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
631 */
632             
633 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
634 
635 pragma solidity ^0.8.0;
636 
637 ////import "../utils/Context.sol";
638 
639 /**
640  * @dev Contract module which allows children to implement an emergency stop
641  * mechanism that can be triggered by an authorized account.
642  *
643  * This module is used through inheritance. It will make available the
644  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
645  * the functions of your contract. Note that they will not be pausable by
646  * simply including this module, only once the modifiers are put in place.
647  */
648 abstract contract Pausable is Context {
649     /**
650      * @dev Emitted when the pause is triggered by `account`.
651      */
652     event Paused(address account);
653 
654     /**
655      * @dev Emitted when the pause is lifted by `account`.
656      */
657     event Unpaused(address account);
658 
659     bool private _paused;
660 
661     /**
662      * @dev Initializes the contract in unpaused state.
663      */
664     constructor() {
665         _paused = false;
666     }
667 
668     /**
669      * @dev Returns true if the contract is paused, and false otherwise.
670      */
671     function paused() public view virtual returns (bool) {
672         return _paused;
673     }
674 
675     /**
676      * @dev Modifier to make a function callable only when the contract is not paused.
677      *
678      * Requirements:
679      *
680      * - The contract must not be paused.
681      */
682     modifier whenNotPaused() {
683         require(!paused(), "Pausable: paused");
684         _;
685     }
686 
687     /**
688      * @dev Modifier to make a function callable only when the contract is paused.
689      *
690      * Requirements:
691      *
692      * - The contract must be paused.
693      */
694     modifier whenPaused() {
695         require(paused(), "Pausable: not paused");
696         _;
697     }
698 
699     /**
700      * @dev Triggers stopped state.
701      *
702      * Requirements:
703      *
704      * - The contract must not be paused.
705      */
706     function _pause() internal virtual whenNotPaused {
707         _paused = true;
708         emit Paused(_msgSender());
709     }
710 
711     /**
712      * @dev Returns to normal state.
713      *
714      * Requirements:
715      *
716      * - The contract must be paused.
717      */
718     function _unpause() internal virtual whenPaused {
719         _paused = false;
720         emit Unpaused(_msgSender());
721     }
722 }
723 
724 
725 
726 
727 /** 
728  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
729 */
730             
731 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
732 
733 pragma solidity ^0.8.0;
734 
735 ////import "./IERC721.sol";
736 ////import "./IERC721Receiver.sol";
737 ////import "./extensions/IERC721Metadata.sol";
738 ////import "../../utils/Address.sol";
739 ////import "../../utils/Context.sol";
740 ////import "../../utils/Strings.sol";
741 ////import "../../utils/introspection/ERC165.sol";
742 
743 /**
744  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
745  * the Metadata extension, but not including the Enumerable extension, which is available separately as
746  * {ERC721Enumerable}.
747  */
748 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
749     using Address for address;
750     using Strings for uint256;
751 
752     // Token name
753     string private _name;
754 
755     // Token symbol
756     string private _symbol;
757 
758     // Mapping from token ID to owner address
759     mapping(uint256 => address) private _owners;
760 
761     // Mapping owner address to token count
762     mapping(address => uint256) private _balances;
763 
764     // Mapping from token ID to approved address
765     mapping(uint256 => address) private _tokenApprovals;
766 
767     // Mapping from owner to operator approvals
768     mapping(address => mapping(address => bool)) private _operatorApprovals;
769 
770     /**
771      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
772      */
773     constructor(string memory name_, string memory symbol_) {
774         _name = name_;
775         _symbol = symbol_;
776     }
777 
778     /**
779      * @dev See {IERC165-supportsInterface}.
780      */
781     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
782         return
783             interfaceId == type(IERC721).interfaceId ||
784             interfaceId == type(IERC721Metadata).interfaceId ||
785             super.supportsInterface(interfaceId);
786     }
787 
788     /**
789      * @dev See {IERC721-balanceOf}.
790      */
791     function balanceOf(address owner) public view virtual override returns (uint256) {
792         require(owner != address(0), "ERC721: balance query for the zero address");
793         return _balances[owner];
794     }
795 
796     /**
797      * @dev See {IERC721-ownerOf}.
798      */
799     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
800         address owner = _owners[tokenId];
801         require(owner != address(0), "ERC721: owner query for nonexistent token");
802         return owner;
803     }
804 
805     /**
806      * @dev See {IERC721Metadata-name}.
807      */
808     function name() public view virtual override returns (string memory) {
809         return _name;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-symbol}.
814      */
815     function symbol() public view virtual override returns (string memory) {
816         return _symbol;
817     }
818 
819     /**
820      * @dev See {IERC721Metadata-tokenURI}.
821      */
822     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
823         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
824 
825         string memory baseURI = _baseURI();
826         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
827     }
828 
829     /**
830      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
831      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
832      * by default, can be overriden in child contracts.
833      */
834     function _baseURI() internal view virtual returns (string memory) {
835         return "";
836     }
837 
838     /**
839      * @dev See {IERC721-approve}.
840      */
841     function approve(address to, uint256 tokenId) public virtual override {
842         address owner = ERC721.ownerOf(tokenId);
843         require(to != owner, "ERC721: approval to current owner");
844 
845         require(
846             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
847             "ERC721: approve caller is not owner nor approved for all"
848         );
849 
850         _approve(to, tokenId);
851     }
852 
853     /**
854      * @dev See {IERC721-getApproved}.
855      */
856     function getApproved(uint256 tokenId) public view virtual override returns (address) {
857         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
858 
859         return _tokenApprovals[tokenId];
860     }
861 
862     /**
863      * @dev See {IERC721-setApprovalForAll}.
864      */
865     function setApprovalForAll(address operator, bool approved) public virtual override {
866         require(operator != _msgSender(), "ERC721: approve to caller");
867 
868         _operatorApprovals[_msgSender()][operator] = approved;
869         emit ApprovalForAll(_msgSender(), operator, approved);
870     }
871 
872     /**
873      * @dev See {IERC721-isApprovedForAll}.
874      */
875     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
876         return _operatorApprovals[owner][operator];
877     }
878 
879     /**
880      * @dev See {IERC721-transferFrom}.
881      */
882     function transferFrom(
883         address from,
884         address to,
885         uint256 tokenId
886     ) public virtual override {
887         //solhint-disable-next-line max-line-length
888         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
889 
890         _transfer(from, to, tokenId);
891     }
892 
893     /**
894      * @dev See {IERC721-safeTransferFrom}.
895      */
896     function safeTransferFrom(
897         address from,
898         address to,
899         uint256 tokenId
900     ) public virtual override {
901         safeTransferFrom(from, to, tokenId, "");
902     }
903 
904     /**
905      * @dev See {IERC721-safeTransferFrom}.
906      */
907     function safeTransferFrom(
908         address from,
909         address to,
910         uint256 tokenId,
911         bytes memory _data
912     ) public virtual override {
913         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
914         _safeTransfer(from, to, tokenId, _data);
915     }
916 
917     /**
918      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
919      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
920      *
921      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
922      *
923      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
924      * implement alternative mechanisms to perform token transfer, such as signature-based.
925      *
926      * Requirements:
927      *
928      * - `from` cannot be the zero address.
929      * - `to` cannot be the zero address.
930      * - `tokenId` token must exist and be owned by `from`.
931      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
932      *
933      * Emits a {Transfer} event.
934      */
935     function _safeTransfer(
936         address from,
937         address to,
938         uint256 tokenId,
939         bytes memory _data
940     ) internal virtual {
941         _transfer(from, to, tokenId);
942         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
943     }
944 
945     /**
946      * @dev Returns whether `tokenId` exists.
947      *
948      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
949      *
950      * Tokens start existing when they are minted (`_mint`),
951      * and stop existing when they are burned (`_burn`).
952      */
953     function _exists(uint256 tokenId) internal view virtual returns (bool) {
954         return _owners[tokenId] != address(0);
955     }
956 
957     /**
958      * @dev Returns whether `spender` is allowed to manage `tokenId`.
959      *
960      * Requirements:
961      *
962      * - `tokenId` must exist.
963      */
964     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
965         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
966         address owner = ERC721.ownerOf(tokenId);
967         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
968     }
969 
970     /**
971      * @dev Safely mints `tokenId` and transfers it to `to`.
972      *
973      * Requirements:
974      *
975      * - `tokenId` must not exist.
976      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _safeMint(address to, uint256 tokenId) internal virtual {
981         _safeMint(to, tokenId, "");
982     }
983 
984     /**
985      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
986      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
987      */
988     function _safeMint(
989         address to,
990         uint256 tokenId,
991         bytes memory _data
992     ) internal virtual {
993         _mint(to, tokenId);
994         require(
995             _checkOnERC721Received(address(0), to, tokenId, _data),
996             "ERC721: transfer to non ERC721Receiver implementer"
997         );
998     }
999 
1000     /**
1001      * @dev Mints `tokenId` and transfers it to `to`.
1002      *
1003      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1004      *
1005      * Requirements:
1006      *
1007      * - `tokenId` must not exist.
1008      * - `to` cannot be the zero address.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function _mint(address to, uint256 tokenId) internal virtual {
1013         require(to != address(0), "ERC721: mint to the zero address");
1014         require(!_exists(tokenId), "ERC721: token already minted");
1015 
1016         _beforeTokenTransfer(address(0), to, tokenId);
1017 
1018         _balances[to] += 1;
1019         _owners[tokenId] = to;
1020 
1021         emit Transfer(address(0), to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev Destroys `tokenId`.
1026      * The approval is cleared when the token is burned.
1027      *
1028      * Requirements:
1029      *
1030      * - `tokenId` must exist.
1031      *
1032      * Emits a {Transfer} event.
1033      */
1034     function _burn(uint256 tokenId) internal virtual {
1035         address owner = ERC721.ownerOf(tokenId);
1036 
1037         _beforeTokenTransfer(owner, address(0), tokenId);
1038 
1039         // Clear approvals
1040         _approve(address(0), tokenId);
1041 
1042         _balances[owner] -= 1;
1043         delete _owners[tokenId];
1044 
1045         emit Transfer(owner, address(0), tokenId);
1046     }
1047 
1048     /**
1049      * @dev Transfers `tokenId` from `from` to `to`.
1050      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1051      *
1052      * Requirements:
1053      *
1054      * - `to` cannot be the zero address.
1055      * - `tokenId` token must be owned by `from`.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _transfer(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) internal virtual {
1064         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1065         require(to != address(0), "ERC721: transfer to the zero address");
1066 
1067         _beforeTokenTransfer(from, to, tokenId);
1068 
1069         // Clear approvals from the previous owner
1070         _approve(address(0), tokenId);
1071 
1072         _balances[from] -= 1;
1073         _balances[to] += 1;
1074         _owners[tokenId] = to;
1075 
1076         emit Transfer(from, to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev Approve `to` to operate on `tokenId`
1081      *
1082      * Emits a {Approval} event.
1083      */
1084     function _approve(address to, uint256 tokenId) internal virtual {
1085         _tokenApprovals[tokenId] = to;
1086         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1087     }
1088 
1089     /**
1090      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1091      * The call is not executed if the target address is not a contract.
1092      *
1093      * @param from address representing the previous owner of the given token ID
1094      * @param to target address that will receive the tokens
1095      * @param tokenId uint256 ID of the token to be transferred
1096      * @param _data bytes optional data to send along with the call
1097      * @return bool whether the call correctly returned the expected magic value
1098      */
1099     function _checkOnERC721Received(
1100         address from,
1101         address to,
1102         uint256 tokenId,
1103         bytes memory _data
1104     ) private returns (bool) {
1105         if (to.isContract()) {
1106             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1107                 return retval == IERC721Receiver.onERC721Received.selector;
1108             } catch (bytes memory reason) {
1109                 if (reason.length == 0) {
1110                     revert("ERC721: transfer to non ERC721Receiver implementer");
1111                 } else {
1112                     assembly {
1113                         revert(add(32, reason), mload(reason))
1114                     }
1115                 }
1116             }
1117         } else {
1118             return true;
1119         }
1120     }
1121 
1122     /**
1123      * @dev Hook that is called before any token transfer. This includes minting
1124      * and burning.
1125      *
1126      * Calling conditions:
1127      *
1128      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1129      * transferred to `to`.
1130      * - When `from` is zero, `tokenId` will be minted for `to`.
1131      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1132      * - `from` and `to` are never both zero.
1133      *
1134      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1135      */
1136     function _beforeTokenTransfer(
1137         address from,
1138         address to,
1139         uint256 tokenId
1140     ) internal virtual {}
1141 }
1142 
1143 
1144 
1145 
1146 /** 
1147  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
1148 */
1149             
1150 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1151 
1152 pragma solidity ^0.8.0;
1153 
1154 ////import "../IERC721.sol";
1155 
1156 /**
1157  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1158  * @dev See https://eips.ethereum.org/EIPS/eip-721
1159  */
1160 interface IERC721Enumerable is IERC721 {
1161     /**
1162      * @dev Returns the total amount of tokens stored by the contract.
1163      */
1164     function totalSupply() external view returns (uint256);
1165 
1166     /**
1167      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1168      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1169      */
1170     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1171 
1172     /**
1173      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1174      * Use along with {totalSupply} to enumerate all tokens.
1175      */
1176     function tokenByIndex(uint256 index) external view returns (uint256);
1177 }
1178 
1179 
1180 
1181 
1182 /** 
1183  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
1184 */
1185             
1186 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1187 
1188 pragma solidity ^0.8.0;
1189 
1190 /**
1191  * @dev Contract module that helps prevent reentrant calls to a function.
1192  *
1193  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1194  * available, which can be applied to functions to make sure there are no nested
1195  * (reentrant) calls to them.
1196  *
1197  * Note that because there is a single `nonReentrant` guard, functions marked as
1198  * `nonReentrant` may not call one another. This can be worked around by making
1199  * those functions `private`, and then adding `external` `nonReentrant` entry
1200  * points to them.
1201  *
1202  * TIP: If you would like to learn more about reentrancy and alternative ways
1203  * to protect against it, check out our blog post
1204  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1205  */
1206 abstract contract ReentrancyGuard {
1207     // Booleans are more expensive than uint256 or any type that takes up a full
1208     // word because each write operation emits an extra SLOAD to first read the
1209     // slot's contents, replace the bits taken up by the boolean, and then write
1210     // back. This is the compiler's defense against contract upgrades and
1211     // pointer aliasing, and it cannot be disabled.
1212 
1213     // The values being non-zero value makes deployment a bit more expensive,
1214     // but in exchange the refund on every call to nonReentrant will be lower in
1215     // amount. Since refunds are capped to a percentage of the total
1216     // transaction's gas, it is best to keep them low in cases like this one, to
1217     // increase the likelihood of the full refund coming into effect.
1218     uint256 private constant _NOT_ENTERED = 1;
1219     uint256 private constant _ENTERED = 2;
1220 
1221     uint256 private _status;
1222 
1223     constructor() {
1224         _status = _NOT_ENTERED;
1225     }
1226 
1227     /**
1228      * @dev Prevents a contract from calling itself, directly or indirectly.
1229      * Calling a `nonReentrant` function from another `nonReentrant`
1230      * function is not supported. It is possible to prevent this from happening
1231      * by making the `nonReentrant` function external, and make it call a
1232      * `private` function that does the actual work.
1233      */
1234     modifier nonReentrant() {
1235         // On the first call to nonReentrant, _notEntered will be true
1236         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1237 
1238         // Any calls to nonReentrant after this point will fail
1239         _status = _ENTERED;
1240 
1241         _;
1242 
1243         // By storing the original value once again, a refund is triggered (see
1244         // https://eips.ethereum.org/EIPS/eip-2200)
1245         _status = _NOT_ENTERED;
1246     }
1247 }
1248 
1249 
1250 
1251 
1252 /** 
1253  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
1254 */
1255             
1256 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1257 
1258 pragma solidity ^0.8.0;
1259 
1260 // CAUTION
1261 // This version of SafeMath should only be used with Solidity 0.8 or later,
1262 // because it relies on the compiler's built in overflow checks.
1263 
1264 /**
1265  * @dev Wrappers over Solidity's arithmetic operations.
1266  *
1267  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1268  * now has built in overflow checking.
1269  */
1270 library SafeMath {
1271     /**
1272      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1273      *
1274      * _Available since v3.4._
1275      */
1276     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1277         unchecked {
1278             uint256 c = a + b;
1279             if (c < a) return (false, 0);
1280             return (true, c);
1281         }
1282     }
1283 
1284     /**
1285      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1286      *
1287      * _Available since v3.4._
1288      */
1289     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1290         unchecked {
1291             if (b > a) return (false, 0);
1292             return (true, a - b);
1293         }
1294     }
1295 
1296     /**
1297      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1298      *
1299      * _Available since v3.4._
1300      */
1301     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1302         unchecked {
1303             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1304             // benefit is lost if 'b' is also tested.
1305             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1306             if (a == 0) return (true, 0);
1307             uint256 c = a * b;
1308             if (c / a != b) return (false, 0);
1309             return (true, c);
1310         }
1311     }
1312 
1313     /**
1314      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1315      *
1316      * _Available since v3.4._
1317      */
1318     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1319         unchecked {
1320             if (b == 0) return (false, 0);
1321             return (true, a / b);
1322         }
1323     }
1324 
1325     /**
1326      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1327      *
1328      * _Available since v3.4._
1329      */
1330     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1331         unchecked {
1332             if (b == 0) return (false, 0);
1333             return (true, a % b);
1334         }
1335     }
1336 
1337     /**
1338      * @dev Returns the addition of two unsigned integers, reverting on
1339      * overflow.
1340      *
1341      * Counterpart to Solidity's `+` operator.
1342      *
1343      * Requirements:
1344      *
1345      * - Addition cannot overflow.
1346      */
1347     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1348         return a + b;
1349     }
1350 
1351     /**
1352      * @dev Returns the subtraction of two unsigned integers, reverting on
1353      * overflow (when the result is negative).
1354      *
1355      * Counterpart to Solidity's `-` operator.
1356      *
1357      * Requirements:
1358      *
1359      * - Subtraction cannot overflow.
1360      */
1361     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1362         return a - b;
1363     }
1364 
1365     /**
1366      * @dev Returns the multiplication of two unsigned integers, reverting on
1367      * overflow.
1368      *
1369      * Counterpart to Solidity's `*` operator.
1370      *
1371      * Requirements:
1372      *
1373      * - Multiplication cannot overflow.
1374      */
1375     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1376         return a * b;
1377     }
1378 
1379     /**
1380      * @dev Returns the integer division of two unsigned integers, reverting on
1381      * division by zero. The result is rounded towards zero.
1382      *
1383      * Counterpart to Solidity's `/` operator.
1384      *
1385      * Requirements:
1386      *
1387      * - The divisor cannot be zero.
1388      */
1389     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1390         return a / b;
1391     }
1392 
1393     /**
1394      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1395      * reverting when dividing by zero.
1396      *
1397      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1398      * opcode (which leaves remaining gas untouched) while Solidity uses an
1399      * invalid opcode to revert (consuming all remaining gas).
1400      *
1401      * Requirements:
1402      *
1403      * - The divisor cannot be zero.
1404      */
1405     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1406         return a % b;
1407     }
1408 
1409     /**
1410      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1411      * overflow (when the result is negative).
1412      *
1413      * CAUTION: This function is deprecated because it requires allocating memory for the error
1414      * message unnecessarily. For custom revert reasons use {trySub}.
1415      *
1416      * Counterpart to Solidity's `-` operator.
1417      *
1418      * Requirements:
1419      *
1420      * - Subtraction cannot overflow.
1421      */
1422     function sub(
1423         uint256 a,
1424         uint256 b,
1425         string memory errorMessage
1426     ) internal pure returns (uint256) {
1427         unchecked {
1428             require(b <= a, errorMessage);
1429             return a - b;
1430         }
1431     }
1432 
1433     /**
1434      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1435      * division by zero. The result is rounded towards zero.
1436      *
1437      * Counterpart to Solidity's `/` operator. Note: this function uses a
1438      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1439      * uses an invalid opcode to revert (consuming all remaining gas).
1440      *
1441      * Requirements:
1442      *
1443      * - The divisor cannot be zero.
1444      */
1445     function div(
1446         uint256 a,
1447         uint256 b,
1448         string memory errorMessage
1449     ) internal pure returns (uint256) {
1450         unchecked {
1451             require(b > 0, errorMessage);
1452             return a / b;
1453         }
1454     }
1455 
1456     /**
1457      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1458      * reverting with custom message when dividing by zero.
1459      *
1460      * CAUTION: This function is deprecated because it requires allocating memory for the error
1461      * message unnecessarily. For custom revert reasons use {tryMod}.
1462      *
1463      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1464      * opcode (which leaves remaining gas untouched) while Solidity uses an
1465      * invalid opcode to revert (consuming all remaining gas).
1466      *
1467      * Requirements:
1468      *
1469      * - The divisor cannot be zero.
1470      */
1471     function mod(
1472         uint256 a,
1473         uint256 b,
1474         string memory errorMessage
1475     ) internal pure returns (uint256) {
1476         unchecked {
1477             require(b > 0, errorMessage);
1478             return a % b;
1479         }
1480     }
1481 }
1482 
1483 
1484 
1485 
1486 /** 
1487  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
1488 */
1489             
1490 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1491 
1492 pragma solidity ^0.8.0;
1493 
1494 ////import "../utils/Context.sol";
1495 
1496 /**
1497  * @dev Contract module which provides a basic access control mechanism, where
1498  * there is an account (an owner) that can be granted exclusive access to
1499  * specific functions.
1500  *
1501  * By default, the owner account will be the one that deploys the contract. This
1502  * can later be changed with {transferOwnership}.
1503  *
1504  * This module is used through inheritance. It will make available the modifier
1505  * `onlyOwner`, which can be applied to your functions to restrict their use to
1506  * the owner.
1507  */
1508 abstract contract Ownable is Context {
1509     address private _owner;
1510 
1511     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1512 
1513     /**
1514      * @dev Initializes the contract setting the deployer as the initial owner.
1515      */
1516     constructor() {
1517         _setOwner(_msgSender());
1518     }
1519 
1520     /**
1521      * @dev Returns the address of the current owner.
1522      */
1523     function owner() public view virtual returns (address) {
1524         return _owner;
1525     }
1526 
1527     /**
1528      * @dev Throws if called by any account other than the owner.
1529      */
1530     modifier onlyOwner() {
1531         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1532         _;
1533     }
1534 
1535     /**
1536      * @dev Leaves the contract without owner. It will not be possible to call
1537      * `onlyOwner` functions anymore. Can only be called by the current owner.
1538      *
1539      * NOTE: Renouncing ownership will leave the contract without an owner,
1540      * thereby removing any functionality that is only available to the owner.
1541      */
1542     function renounceOwnership() public virtual onlyOwner {
1543         _setOwner(address(0));
1544     }
1545 
1546     /**
1547      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1548      * Can only be called by the current owner.
1549      */
1550     function transferOwnership(address newOwner) public virtual onlyOwner {
1551         require(newOwner != address(0), "Ownable: new owner is the zero address");
1552         _setOwner(newOwner);
1553     }
1554 
1555     function _setOwner(address newOwner) private {
1556         address oldOwner = _owner;
1557         _owner = newOwner;
1558         emit OwnershipTransferred(oldOwner, newOwner);
1559     }
1560 }
1561 
1562 
1563 
1564 
1565 /** 
1566  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
1567 */
1568             
1569 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1570 
1571 pragma solidity ^0.8.0;
1572 
1573 ////import "./IERC165.sol";
1574 
1575 /**
1576  * @dev Interface for the NFT Royalty Standard
1577  */
1578 interface IERC2981 is IERC165 {
1579     /**
1580      * @dev Called with the sale price to determine how much royalty is owed and to whom.
1581      * @param tokenId - the NFT asset queried for royalty information
1582      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
1583      * @return receiver - address of who should be sent the royalty payment
1584      * @return royaltyAmount - the royalty payment amount for `salePrice`
1585      */
1586     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1587         external
1588         view
1589         returns (address receiver, uint256 royaltyAmount);
1590 }
1591 
1592 
1593 
1594 
1595 /** 
1596  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
1597 */
1598             
1599 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1600 
1601 pragma solidity ^0.8.0;
1602 
1603 ////import "../ERC721.sol";
1604 ////import "../../../security/Pausable.sol";
1605 
1606 /**
1607  * @dev ERC721 token with pausable token transfers, minting and burning.
1608  *
1609  * Useful for scenarios such as preventing trades until the end of an evaluation
1610  * period, or having an emergency switch for freezing all token transfers in the
1611  * event of a large bug.
1612  */
1613 abstract contract ERC721Pausable is ERC721, Pausable {
1614     /**
1615      * @dev See {ERC721-_beforeTokenTransfer}.
1616      *
1617      * Requirements:
1618      *
1619      * - the contract must not be paused.
1620      */
1621     function _beforeTokenTransfer(
1622         address from,
1623         address to,
1624         uint256 tokenId
1625     ) internal virtual override {
1626         super._beforeTokenTransfer(from, to, tokenId);
1627 
1628         require(!paused(), "ERC721Pausable: token transfer while paused");
1629     }
1630 }
1631 
1632 
1633 
1634 
1635 /** 
1636  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
1637 */
1638             
1639 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1640 
1641 pragma solidity ^0.8.0;
1642 
1643 ////import "../ERC721.sol";
1644 ////import "./IERC721Enumerable.sol";
1645 
1646 /**
1647  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1648  * enumerability of all the token ids in the contract as well as all token ids owned by each
1649  * account.
1650  */
1651 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1652     // Mapping from owner to list of owned token IDs
1653     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1654 
1655     // Mapping from token ID to index of the owner tokens list
1656     mapping(uint256 => uint256) private _ownedTokensIndex;
1657 
1658     // Array with all token ids, used for enumeration
1659     uint256[] private _allTokens;
1660 
1661     // Mapping from token id to position in the allTokens array
1662     mapping(uint256 => uint256) private _allTokensIndex;
1663 
1664     /**
1665      * @dev See {IERC165-supportsInterface}.
1666      */
1667     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1668         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1669     }
1670 
1671     /**
1672      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1673      */
1674     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1675         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1676         return _ownedTokens[owner][index];
1677     }
1678 
1679     /**
1680      * @dev See {IERC721Enumerable-totalSupply}.
1681      */
1682     function totalSupply() public view virtual override returns (uint256) {
1683         return _allTokens.length;
1684     }
1685 
1686     /**
1687      * @dev See {IERC721Enumerable-tokenByIndex}.
1688      */
1689     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1690         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1691         return _allTokens[index];
1692     }
1693 
1694     /**
1695      * @dev Hook that is called before any token transfer. This includes minting
1696      * and burning.
1697      *
1698      * Calling conditions:
1699      *
1700      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1701      * transferred to `to`.
1702      * - When `from` is zero, `tokenId` will be minted for `to`.
1703      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1704      * - `from` cannot be the zero address.
1705      * - `to` cannot be the zero address.
1706      *
1707      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1708      */
1709     function _beforeTokenTransfer(
1710         address from,
1711         address to,
1712         uint256 tokenId
1713     ) internal virtual override {
1714         super._beforeTokenTransfer(from, to, tokenId);
1715 
1716         if (from == address(0)) {
1717             _addTokenToAllTokensEnumeration(tokenId);
1718         } else if (from != to) {
1719             _removeTokenFromOwnerEnumeration(from, tokenId);
1720         }
1721         if (to == address(0)) {
1722             _removeTokenFromAllTokensEnumeration(tokenId);
1723         } else if (to != from) {
1724             _addTokenToOwnerEnumeration(to, tokenId);
1725         }
1726     }
1727 
1728     /**
1729      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1730      * @param to address representing the new owner of the given token ID
1731      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1732      */
1733     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1734         uint256 length = ERC721.balanceOf(to);
1735         _ownedTokens[to][length] = tokenId;
1736         _ownedTokensIndex[tokenId] = length;
1737     }
1738 
1739     /**
1740      * @dev Private function to add a token to this extension's token tracking data structures.
1741      * @param tokenId uint256 ID of the token to be added to the tokens list
1742      */
1743     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1744         _allTokensIndex[tokenId] = _allTokens.length;
1745         _allTokens.push(tokenId);
1746     }
1747 
1748     /**
1749      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1750      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1751      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1752      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1753      * @param from address representing the previous owner of the given token ID
1754      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1755      */
1756     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1757         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1758         // then delete the last slot (swap and pop).
1759 
1760         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1761         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1762 
1763         // When the token to delete is the last token, the swap operation is unnecessary
1764         if (tokenIndex != lastTokenIndex) {
1765             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1766 
1767             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1768             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1769         }
1770 
1771         // This also deletes the contents at the last position of the array
1772         delete _ownedTokensIndex[tokenId];
1773         delete _ownedTokens[from][lastTokenIndex];
1774     }
1775 
1776     /**
1777      * @dev Private function to remove a token from this extension's token tracking data structures.
1778      * This has O(1) time complexity, but alters the order of the _allTokens array.
1779      * @param tokenId uint256 ID of the token to be removed from the tokens list
1780      */
1781     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1782         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1783         // then delete the last slot (swap and pop).
1784 
1785         uint256 lastTokenIndex = _allTokens.length - 1;
1786         uint256 tokenIndex = _allTokensIndex[tokenId];
1787 
1788         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1789         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1790         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1791         uint256 lastTokenId = _allTokens[lastTokenIndex];
1792 
1793         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1794         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1795 
1796         // This also deletes the contents at the last position of the array
1797         delete _allTokensIndex[tokenId];
1798         _allTokens.pop();
1799     }
1800 }
1801 
1802 
1803 /** 
1804  *  SourceUnit: c:\Users\Jad\Documents\code\Cryptoware\dcb-lottery\blockend\contracts\DCBW721.sol
1805 */
1806 
1807 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1808 pragma solidity ^0.8.0;
1809 
1810 /// @notice ERC721
1811 ////import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
1812 ////import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
1813 ////import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
1814 ////import "../node_modules/@openzeppelin/contracts/interfaces/IERC2981.sol";
1815 
1816 /// @notice peripheral
1817 ////import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
1818 
1819 /// @notice libraries
1820 ////import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
1821 
1822 /// @notice 
1823 ////import "../node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";
1824 
1825 /// @notice RNG middleware contract interface
1826 interface IRNG {
1827     function request() external returns(bytes32 requestId);
1828 }
1829 
1830 /**
1831  * @title DCBW721
1832  * @notice ERC721-ready VRF DCBW721 contract
1833  * @author cryptoware.eth | DCB.world
1834  **/
1835 contract DCBW721 is IERC2981, Ownable, ERC721, ERC721Enumerable, ERC721Pausable, ReentrancyGuard {
1836     /// @notice using safe math for uints
1837     using SafeMath for uint256;
1838 
1839     /// @notice using safe math for uints
1840     using SafeMath for uint32;
1841 
1842     /// @notice using safe math for uints
1843     using SafeMath for uint64;
1844 
1845     /// @notice using safe math for uints
1846     using SafeMath for uint96;
1847 
1848     /// @notice using Strings for uints conversion (tokenId)
1849     using Strings for uint256;
1850 
1851     /// @notice using Address for addresses extended functionality
1852     using Address for address;
1853 
1854     /// @notice sate of the draw process
1855     enum DrawState {
1856         Open,
1857         Closed
1858     }
1859 
1860     /// @notice struct used to store each draw's data
1861     struct DrawData {
1862         uint64 drawId;
1863         uint64 start_time;
1864         uint64 winningEdition;
1865         uint64 isGrandPrize;
1866         address winner;
1867         uint96 prizePoolWon;
1868         DrawState state;
1869         bytes32 randomNumberRequestId;
1870     }
1871 
1872     /// @notice EIP2981-compliant struct
1873     struct RoyaltyReceiver {
1874         address account;
1875         uint96 shares; // per thousands
1876     }
1877 
1878     /// @notice EIP721-required Base URI
1879     string private _baseTokenURI;
1880 
1881     /// @notice Base extension for metadata
1882     string private _baseExtension;
1883 
1884     /// @notice minting, draws, reserve(public), grandPrize(public) and royalties-traking parameters
1885     uint256 public _reserves;
1886     uint256 public _grandPrizePool;
1887     uint256 public _mintPrice;
1888     uint32 public _drawsToDate;
1889 
1890     uint256 private _reservesRate;
1891     uint256 private _maxTokenId;
1892 
1893     /// @notice the lottery draw state
1894     DrawState private _state;
1895 
1896     /// @notice beneficiary wallet that will collect mint fees
1897     address payable private _mintingBeneficiary;
1898 
1899     /// @notice VRF-compliant contract to request randomness from
1900     address private _rngContract;
1901 
1902     /// @notice Chainlink Keeper-compliant contract to trigger draw
1903     address private _alarmContract;
1904 
1905     /// @notice minter address
1906     address private _minter;
1907 
1908     /// @notice public metadata locked flag
1909     bool public locked;
1910 
1911     /// @notice Mapping draws id => details of the draw
1912     mapping(uint => DrawData) public draws;
1913 
1914     /// @notice Mapping token id => royalty details
1915     mapping(uint => RoyaltyReceiver) public royalties;
1916 
1917     /// @notice Minting events definition
1918     event AdminMinted(address indexed to, uint indexed tokenId);
1919     event Minted(address indexed to, uint indexed tokenId);
1920 
1921     /// @notice Draw events definition
1922     event DrawInitiated(bytes32 requestId);
1923     event DrawFinished(address winner, uint winningEdition);
1924 
1925     /// @notice metadata not locked modifier
1926     modifier notLocked() {
1927         require(!locked, "DCBW721: Metadata URIs are locked");
1928         _;
1929     }
1930 
1931     /// @notice allows only closed lottery state
1932     modifier requireState(DrawState state) {
1933         require(_state == state, "DCBW721: Invalid state for this action");
1934         _;
1935     }
1936 
1937     /// @notice allows only address to perform action
1938     modifier requireAccount(address account) {
1939         require(
1940             _msgSender() == account,
1941             "DCBW721: Invalid account for this action"
1942         );
1943         _;
1944     }
1945 
1946     /// @notice owner or minter
1947     modifier ownerOrMinter() {
1948         require(
1949             _msgSender() == _minter || _msgSender() == owner(),
1950             "DCBW721: Invalid account for this action"
1951         );
1952         _;
1953     }
1954 
1955     /**
1956      * @notice constructor
1957      * @param name the name of the EIP721 Contract
1958      * @param symbol the token symbol
1959      * @param baseTokenURI EIP721-required Base URI
1960      * @param mbeneficiary the contract Splitter that will receive minting funds
1961      * @param rbeneficiary the royalties beneficiary
1962      * @param alarmContract the alarm contract address to trigger DrawNumber on interval (TO BE SET POST-DEPLOYMENT)
1963      * @param rngContract the RNG contract address to get randomness (TO BE SET POST-DEPLOYMENT)
1964      **/
1965     constructor(
1966         string memory name,
1967         string memory symbol,
1968         string memory baseTokenURI,
1969         address mbeneficiary,
1970         address rbeneficiary,
1971         address alarmContract,
1972         address rngContract
1973     ) ERC721(name, symbol) Ownable() {
1974         locked = false;
1975 
1976         _mintPrice = 1 ether;
1977         _reservesRate = 200;
1978         _maxTokenId = 1000000;
1979 
1980         _baseExtension = ".json";
1981         _baseTokenURI = baseTokenURI;
1982 
1983         _mintingBeneficiary = payable(mbeneficiary);
1984         _rngContract = rngContract;
1985         _alarmContract = alarmContract;
1986         _minter = _msgSender();
1987 
1988         _state = DrawState.Closed;
1989 
1990         royalties[0] = RoyaltyReceiver(rbeneficiary, 100);
1991     }
1992 
1993     /// @notice feed eth into the contract
1994     function feed(uint256 intoReserves, uint256 intoGrandPrize)
1995         external
1996         payable
1997         onlyOwner
1998     {
1999         require(
2000             msg.value > 0 && intoReserves.add(intoGrandPrize) == msg.value,
2001             "DCBW721: Balance-Value Mismatch"
2002         );
2003         _updateGrandPrizePool(_grandPrizePool.add(intoGrandPrize));
2004         _updateReserves(_reserves.add(intoReserves));
2005     }
2006 
2007     /// @notice receive fallback should revert
2008     receive() external payable {
2009         revert("DCBW721: Please use Mint or Admin calls");
2010     }
2011 
2012     /// @notice default fallback should revert
2013     fallback() external payable {
2014         revert("DCBW721: Please use Mint or Admin calls");
2015     }
2016 
2017     /// @notice returns the base URI for the contract
2018     function _baseURI() internal view virtual override returns (string memory) {
2019         return _baseTokenURI;
2020     }
2021 
2022     /**
2023      * @dev See {IERC721Metadata-tokenURI}.
2024      */
2025     function tokenURI(uint256 tokenId)
2026         public
2027         view
2028         virtual
2029         override
2030         returns (string memory)
2031     {
2032         return
2033             string(abi.encodePacked(super.tokenURI(tokenId), _baseExtension));
2034     }
2035 
2036     /**
2037      * @notice updates the all 4 addresses invovled in the contract flow
2038      * @param mintingBeneficiary the contract Splitter that will receive minting funds
2039      * @param alarmContract the alarm contract address to trigger DrawNumber on interval
2040      * @param rngContract the RNG contract address to trigger drawnNumber and pick winner
2041      * @param minter minter address
2042      * @param _owner the new admin address
2043      **/
2044     function updateAddressesAndTransferOwnership(
2045         address mintingBeneficiary,
2046         address alarmContract,
2047         address rngContract,
2048         address minter,
2049         address _owner
2050     ) external onlyOwner {
2051         changeMintBeneficiary(mintingBeneficiary);
2052         changeMinter(minter);
2053 
2054         setAlarmAccount(alarmContract);
2055         setVRFAccount(rngContract);
2056 
2057         transferOwnership(_owner);
2058     }
2059 
2060     /**
2061      * @dev Called with the sale price to determine how much royalty is owed and to whom.
2062      * @param tokenId - the NFT asset queried for royalty information
2063      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
2064      * @return receiver - address of who should be sent the royalty payment
2065      * @return royaltyAmount - the royalty payment amount for `salePrice`
2066      */
2067     function royaltyInfo(uint tokenId, uint salePrice)
2068         external
2069         view
2070         returns (address, uint) {
2071         /// @notice all tokens have same royalty receiver
2072         tokenId = 0; // silence unused var warning
2073         return (royalties[tokenId].account, royalties[tokenId].shares.mul(salePrice).div(1000));
2074     }
2075 
2076     /**
2077      * @notice a function for admins to mint cost-free
2078      * @param to the address to send the minted token to
2079      * @param _tokenId to token ID to be minted
2080      **/
2081     function adminMint(address to, uint256 _tokenId)
2082         external
2083         whenNotPaused
2084         ownerOrMinter
2085         requireState(DrawState.Closed)
2086     {
2087         require(to != address(0), "DCBW721: Address cannot be 0");
2088 
2089         validateTokenId(_tokenId);
2090 
2091         _safeMint(to, _tokenId);
2092 
2093         emit AdminMinted(to, _tokenId);
2094     }
2095 
2096     /**
2097      * @notice the public minting function -- requires 1 ether sent
2098      * @param to the address to send the minted token to
2099      * @param _tokenId to token ID to be minted
2100      **/
2101     function mint(address to, uint256 _tokenId)
2102         external
2103         payable
2104         whenNotPaused
2105         requireState(DrawState.Closed)
2106     {
2107         uint256 received = msg.value;
2108 
2109         require(to != address(0), "DCBW721: Address cannot be 0");
2110         require(
2111             received == _mintPrice,
2112             "DCBW721: Ether sent mismatch with mint price"
2113         );
2114 
2115         validateTokenId(_tokenId);
2116 
2117         _safeMint(to, _tokenId);
2118 
2119         _forwardFunds(received);
2120         _updateReserves(_reserves.add(received.mul(_reservesRate).div(1000)));
2121 
2122         emit Minted(to, _tokenId);
2123     }
2124 
2125     /// @notice a function called by Alarm on each _interval and requests VRF to get randomness
2126     function drawNumber()
2127         external
2128         whenNotPaused
2129         requireAccount(_alarmContract)
2130         requireState(DrawState.Closed)
2131         nonReentrant
2132         returns (bool)
2133     {
2134         require(_reserves > 0, "DCBW721: Not enough reserves for draw");
2135         require(totalSupply() >= 500, "DCBW721: Supply of 500 not reached yet");
2136 
2137         require(
2138             _reserves != 0 && address(this).balance.sub(_grandPrizePool) >= _reserves,
2139             "DCBW721: Not enough balance for draw prize"
2140         );
2141 
2142         bytes32 reqId = IRNG(_rngContract).request();
2143 
2144         _state = DrawState.Open;
2145         draws[_drawsToDate] = DrawData(
2146             _drawsToDate,
2147             uint32(block.timestamp), /* solium-disable-line */
2148             0,
2149             0,
2150             address(0),
2151             0,
2152             _state,
2153             reqId
2154         );
2155 
2156         emit DrawInitiated(reqId);
2157 
2158         return true;
2159     }
2160 
2161     /// @notice a function called by Owner to request GrandPrize random number
2162     function drawNumberGrandPrize()
2163         external
2164         payable
2165         whenNotPaused
2166         onlyOwner
2167         requireState(DrawState.Closed)
2168         nonReentrant
2169         returns (bool)
2170     {
2171         if(msg.value > 0){
2172             _updateGrandPrizePool(_grandPrizePool.add(msg.value));
2173         }
2174 
2175         require(
2176             _grandPrizePool != 0 && address(this).balance.sub(_reserves) >= _grandPrizePool,
2177             "DCBW721: Not enough balance for grand prize"
2178         );
2179 
2180         bytes32 reqId = IRNG(_rngContract).request();
2181 
2182         _state = DrawState.Open;
2183         draws[_drawsToDate] = DrawData(
2184             _drawsToDate,
2185             uint32(block.timestamp), /* solium-disable-line */
2186             0,
2187             1,
2188             address(0),
2189             0,
2190             _state,
2191             reqId
2192         );
2193 
2194         emit DrawInitiated(reqId);
2195 
2196         return true;
2197     }
2198 
2199     /**
2200      * @notice a function called by DCBW721RNG fulfillRandomness Callback function to pick winner if it exists
2201      * @param _requestId The Id initially returned by DCBW721RNG requestRandomness
2202      * @param _randomness Random number generated by Chainlink VRF
2203      **/
2204     function numberDrawn(bytes32 _requestId, uint256 _randomness)
2205         external
2206         whenNotPaused
2207         requireAccount(_rngContract)
2208         nonReentrant
2209     {
2210         DrawData storage current = draws[_drawsToDate];
2211         require(
2212             current.randomNumberRequestId == _requestId,
2213             "DCBW721: Request ID mismatch"
2214         );
2215 
2216         current.winningEdition = uint64(uint256(_randomness % _maxTokenId).add(1));
2217 
2218         if (_exists(current.winningEdition)) {
2219             current.winner = ownerOf(current.winningEdition);
2220             current.prizePoolWon = current.isGrandPrize == uint96(1)
2221                 ? uint96(_grandPrizePool)
2222                 : uint96(_reserves);
2223             _payout(current);
2224         }
2225 
2226         emit DrawFinished(current.winner, current.winningEdition);
2227 
2228         /// @notice update state
2229         _drawsToDate++;
2230         _state = DrawState.Closed;
2231 
2232         /// @notice update draw record
2233         current.state = _state;
2234     }
2235 
2236     /**
2237      * @notice prize payout function
2238      * @param current DrawData object having a draw data
2239      **/
2240     function _payout(DrawData memory current) private {
2241         require(current.winner != address(0), "DCBW721: Address cannot be 0");
2242         require(current.prizePoolWon > 0, "DCBW721: Prize pool is empty");
2243 
2244         /// @notice updating reserve pool & grand prize pool
2245         if (current.isGrandPrize == 1) {
2246             _updateGrandPrizePool(0);
2247         } else {
2248             _updateReserves(0);
2249         }
2250 
2251         /// @notice forward prize to winner wallet using CALL to avoid 2300 stipend limit
2252         (bool success, ) = payable(current.winner).call{value: current.prizePoolWon}("");
2253         require(success, "DCBW721: Failed to forward prize");
2254     }
2255 
2256     /// @notice pausing the contract minting and token transfer
2257     function pause() public virtual onlyOwner {
2258         _pause();
2259     }
2260 
2261     /// @notice unpausing the contract minting and token transfer
2262     function unpause() public virtual onlyOwner {
2263         _unpause();
2264     }
2265 
2266     /**
2267      * @notice sets the state of the draw to closed
2268      * @dev for if the numberDrawn reverted
2269      */
2270     function resetDrawState() public onlyOwner {
2271         _state = DrawState.Closed;
2272     }
2273 
2274     /**
2275      * @notice changes the minter address
2276      * @param minter the new minter address
2277      **/
2278     function changeMinter(address minter) public onlyOwner {
2279         require(
2280             minter != address(0),
2281             "DCBW721: Minter cannot be address 0"
2282         );
2283         require(
2284             minter != _minter,
2285             "DCBW721: Minter cannot be same as previous"
2286         );
2287         _minter = minter;
2288     }
2289 
2290     /**
2291      * @notice changes the minting beneficiary payable address
2292      * @param beneficiary the contract Splitter that will receive minting funds
2293      **/
2294     function changeMintBeneficiary(address beneficiary) public onlyOwner {
2295         require(
2296             beneficiary != address(0),
2297             "DCBW721: Minting beneficiary cannot be address 0"
2298         );
2299         require(
2300             beneficiary != _mintingBeneficiary,
2301             "DCBW721: beneficiary cannot be same as previous"
2302         );
2303         _mintingBeneficiary = payable(beneficiary);
2304     }
2305 
2306     /**
2307      * @notice changes the royalties beneficiary EIP2981
2308      * @param beneficiary the address that will receive royalties
2309      * @param shares the shares as royalties
2310      **/
2311     function changeRoyaltiesBeneficiary(address beneficiary, uint32 shares) public onlyOwner {
2312         require(
2313             beneficiary != address(0),
2314             "DCBW721: Royalties beneficiary cannot be address 0"
2315         );
2316         require(shares > 0, 'DCBW721: Royalty shares cannot be 0');
2317 
2318         RoyaltyReceiver storage rr = royalties[0];
2319         rr.account = beneficiary;
2320         rr.shares = shares;
2321     }
2322 
2323     /**
2324      * @notice changes the minting cost
2325      * @param mintCost new minting cost
2326      **/
2327     function changeMintCost(uint256 mintCost) public onlyOwner {
2328         require(
2329             mintCost != _mintPrice,
2330             "DCBW721: mint Cost cannot be same as previous"
2331         );
2332         _mintPrice = mintCost;
2333     }
2334 
2335     /**
2336      * @notice changes the minting cost
2337      * @param newBaseURI the new Base URI
2338      **/
2339     function changeBaseURI(string memory newBaseURI)
2340         public
2341         onlyOwner
2342         notLocked
2343     {
2344         require((keccak256(abi.encodePacked((_baseTokenURI))) != keccak256(abi.encodePacked((newBaseURI)))), "DCBW721: Base URI cannot be same as previous");
2345         _baseTokenURI = newBaseURI;
2346     }
2347 
2348     /**
2349      * @notice changes the reserve rate
2350      * @param reservesRate new reserve rate
2351      **/
2352     function changeReserveRate(uint256 reservesRate) public onlyOwner {
2353         require(
2354             _reservesRate != reservesRate,
2355             "DCBW721: reservesRate cannot be same as previous"
2356         );
2357         _reservesRate = reservesRate;
2358     }
2359 
2360     /**
2361      * @notice grants alarm role to supplied address
2362      * @param account the address to receive the ALARM role
2363      */
2364     function setAlarmAccount(address account) public virtual onlyOwner {
2365         require(account != address(0), "DCBW721: Alarm cannot be address 0");
2366         require(
2367             account != _alarmContract,
2368             "DCBW721: Alarm Contract cannot be same as previous"
2369         );
2370         _alarmContract = account;
2371     }
2372 
2373     /**
2374      * @notice grants vrf role to supplied address
2375      * @param account the address to receive the VRF role
2376      */
2377     function setVRFAccount(address account) public virtual onlyOwner {
2378         require(account != address(0), "DCBW721: VRF/RNG cannot be address 0");
2379         require(
2380             account != _rngContract,
2381             "DCBW721: RNG cannot be same as previous"
2382         );
2383         _rngContract = account;
2384     }
2385 
2386     /// @notice lock metadata forever
2387     function lockMetadata() public onlyOwner notLocked {
2388         locked = true;
2389     }
2390 
2391     /**
2392      * @notice the public function for checking if a token ID has been minted
2393      * @param _tokenId to token ID to be checked
2394      **/
2395     function isTokenMinted(uint256 _tokenId) public view returns (bool) {
2396         return validateTokenId(_tokenId) && _exists(_tokenId);
2397     }
2398 
2399     /**
2400      * @notice the public function for validation of specific token ID
2401      * @param _tokenId to token ID to be validated
2402      **/
2403     function validateTokenId(uint256 _tokenId) public view returns (bool) {
2404         require(_tokenId >= 1, "DCBW721: Invalid token ID");
2405         require(_tokenId <= _maxTokenId, "DCBW721: Invalid token ID");
2406         return true;
2407     }
2408 
2409     /**
2410      * @notice updates the store reserves tracker
2411      * @param reserves current reserves after new minting
2412      **/
2413     function _updateReserves(uint256 reserves) internal {
2414         require(
2415             reserves <= address(this).balance.sub(_grandPrizePool),
2416             "DCBW721: Reserve-Balance Mismatch"
2417         );
2418         _reserves = reserves;
2419     }
2420 
2421     /**
2422      * @notice updates the store grandPrizePool tracker
2423      * @param grandPrize current grandPrize pool after receiving royalties
2424      **/
2425     function _updateGrandPrizePool(uint256 grandPrize) internal {
2426         require(
2427             grandPrize <= address(this).balance.sub(_reserves),
2428             "DCBW721: GrandPrize-Balance Mismatch"
2429         );
2430         _grandPrizePool = grandPrize;
2431     }
2432 
2433     /**
2434      * @notice Determines how ETH is stored/forwarded on purchases.
2435      * @param received amount to forward
2436      **/
2437     function _forwardFunds(uint256 received) internal {
2438         /// @notice forward fund to receiver wallet using CALL to avoid 2300 stipend limit
2439         (bool success, ) = _mintingBeneficiary.call{value: received.mul(uint256(1000).sub(_reservesRate)).div(1000)}("");
2440         require(success, "DCBW721: Failed to forward funds");
2441     }
2442 
2443     /**
2444      * @notice before transfer hook function
2445      * @param from the address to send the token from
2446      * @param to the address to send the token to
2447      * @param tokenId to token ID to be sent
2448      **/
2449     function _beforeTokenTransfer(
2450         address from,
2451         address to,
2452         uint256 tokenId
2453     ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
2454         super._beforeTokenTransfer(from, to, tokenId);
2455     }
2456 
2457     /**
2458      * @dev See {IERC165-supportsInterface}.
2459      */
2460     function supportsInterface(bytes4 interfaceId)
2461         public
2462         view
2463         virtual
2464         override(IERC165, ERC721, ERC721Enumerable)
2465         returns (bool)
2466     {
2467         return super.supportsInterface(interfaceId);
2468     }
2469 }