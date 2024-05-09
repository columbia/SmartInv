1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-12
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 /*
8      _     _             _     _    ______
9     | |   (_)           (_)   | |   |  ___|
10     | |    _  __ _ _   _ _  __| |   | |_ ___  _ __ __ _  ___
11     | |   | |/ _` | | | | |/ _` |   |  _/ _ \| '__/ _` |/ _ \
12     | |___| | (_| | |_| | | (_| |   | || (_) | | | (_| |  __/
13     \_____/_|\__, |\__,_|_|\__,_|   \_| \___/|_|  \__, |\___|
14                 | |                              __/ |
15                 |_|                             |___/
16     ______                                     ______                           _
17     | ___ \                           ___      | ___ \                         | |
18     | |_/ / ___  _ __  _   _ ___     ( _ )     | |_/ /_____      ____ _ _ __ __| |___
19     | ___ \/ _ \| '_ \| | | / __|    / _ \/\   |    // _ \ \ /\ / / _` | '__/ _` / __|
20     | |_/ / (_) | | | | |_| \__ \   | (_>  <   | |\ \  __/\ V  V / (_| | | | (_| \__ \
21     \____/ \___/|_| |_|\__,_|___/    \___/\/   \_| \_\___| \_/\_/ \__,_|_|  \__,_|___/
22 
23 */
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Interface of the ERC165 standard, as defined in the
29  * https://eips.ethereum.org/EIPS/eip-165[EIP].
30  *
31  * Implementers can declare support of contract interfaces, which can then be
32  * queried by others ({ERC165Checker}).
33  *
34  * For an implementation, see {ERC165}.
35  */
36 interface IERC165 {
37     /**
38      * @dev Returns true if this contract implements the interface defined by
39      * `interfaceId`. See the corresponding
40      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
41      * to learn more about how these ids are created.
42      *
43      * This function call must use less than 30 000 gas.
44      */
45     function supportsInterface(bytes4 interfaceId) external view returns (bool);
46 }
47 
48 pragma solidity ^0.8.0;
49 
50 /**
51  * @dev Implementation of the {IERC165} interface.
52  *
53  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
54  * for the additional interface id that will be supported. For example:
55  *
56  * ```solidity
57  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
58  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
59  * }
60  * ```
61  *
62  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
63  */
64 abstract contract ERC165 is IERC165 {
65     /**
66      * @dev See {IERC165-supportsInterface}.
67      */
68     function supportsInterface(bytes4 interfaceId)
69         public
70         view
71         virtual
72         override
73         returns (bool)
74     {
75         return interfaceId == type(IERC165).interfaceId;
76     }
77 }
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev String operations.
83  */
84 library Strings {
85     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
86 
87     /**
88      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
89      */
90     function toString(uint256 value) internal pure returns (string memory) {
91         // Inspired by OraclizeAPI's implementation - MIT licence
92         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
93 
94         if (value == 0) {
95             return "0";
96         }
97         uint256 temp = value;
98         uint256 digits;
99         while (temp != 0) {
100             digits++;
101             temp /= 10;
102         }
103         bytes memory buffer = new bytes(digits);
104         while (value != 0) {
105             digits -= 1;
106             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
107             value /= 10;
108         }
109         return string(buffer);
110     }
111 
112     /**
113      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
114      */
115     function toHexString(uint256 value) internal pure returns (string memory) {
116         if (value == 0) {
117             return "0x00";
118         }
119         uint256 temp = value;
120         uint256 length = 0;
121         while (temp != 0) {
122             length++;
123             temp >>= 8;
124         }
125         return toHexString(value, length);
126     }
127 
128     /**
129      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
130      */
131     function toHexString(uint256 value, uint256 length)
132         internal
133         pure
134         returns (string memory)
135     {
136         bytes memory buffer = new bytes(2 * length + 2);
137         buffer[0] = "0";
138         buffer[1] = "x";
139         for (uint256 i = 2 * length + 1; i > 1; --i) {
140             buffer[i] = _HEX_SYMBOLS[value & 0xf];
141             value >>= 4;
142         }
143         require(value == 0, "Strings: hex length insufficient");
144         return string(buffer);
145     }
146 }
147 
148 pragma solidity ^0.8.0;
149 
150 /**
151  * @dev Provides information about the current execution context, including the
152  * sender of the transaction and its data. While these are generally available
153  * via msg.sender and msg.data, they should not be accessed in such a direct
154  * manner, since when dealing with meta-transactions the account sending and
155  * paying for execution may not be the actual sender (as far as an application
156  * is concerned).
157  *
158  * This contract is only required for intermediate, library-like contracts.
159  */
160 abstract contract Context {
161     function _msgSender() internal view virtual returns (address) {
162         return msg.sender;
163     }
164 
165     function _msgData() internal view virtual returns (bytes calldata) {
166         return msg.data;
167     }
168 }
169 
170 pragma solidity ^0.8.0;
171 
172 /**
173  * @dev Collection of functions related to the address type
174  */
175 library Address {
176     /**
177      * @dev Returns true if `account` is a contract.
178      *
179      * [IMPORTANT]
180      * ====
181      * It is unsafe to assume that an address for which this function returns
182      * false is an externally-owned account (EOA) and not a contract.
183      *
184      * Among others, `isContract` will return false for the following
185      * types of addresses:
186      *
187      *  - an externally-owned account
188      *  - a contract in construction
189      *  - an address where a contract will be created
190      *  - an address where a contract lived, but was destroyed
191      * ====
192      */
193     function isContract(address account) internal view returns (bool) {
194         // This method relies on extcodesize, which returns 0 for contracts in
195         // construction, since the code is only stored at the end of the
196         // constructor execution.
197 
198         uint256 size;
199         assembly {
200             size := extcodesize(account)
201         }
202         return size > 0;
203     }
204 
205     /**
206      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
207      * `recipient`, forwarding all available gas and reverting on errors.
208      *
209      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
210      * of certain opcodes, possibly making contracts go over the 2300 gas limit
211      * imposed by `transfer`, making them unable to receive funds via
212      * `transfer`. {sendValue} removes this limitation.
213      *
214      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
215      *
216      * IMPORTANT: because control is transferred to `recipient`, care must be
217      * taken to not create reentrancy vulnerabilities. Consider using
218      * {ReentrancyGuard} or the
219      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
220      */
221     function sendValue(address payable recipient, uint256 amount) internal {
222         require(
223             address(this).balance >= amount,
224             "Address: insufficient balance"
225         );
226 
227         (bool success, ) = recipient.call{value: amount}("");
228         require(
229             success,
230             "Address: unable to send value, recipient may have reverted"
231         );
232     }
233 
234     /**
235      * @dev Performs a Solidity function call using a low level `call`. A
236      * plain `call` is an unsafe replacement for a function call: use this
237      * function instead.
238      *
239      * If `target` reverts with a revert reason, it is bubbled up by this
240      * function (like regular Solidity function calls).
241      *
242      * Returns the raw returned data. To convert to the expected return value,
243      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
244      *
245      * Requirements:
246      *
247      * - `target` must be a contract.
248      * - calling `target` with `data` must not revert.
249      *
250      * _Available since v3.1._
251      */
252     function functionCall(address target, bytes memory data)
253         internal
254         returns (bytes memory)
255     {
256         return functionCall(target, data, "Address: low-level call failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
261      * `errorMessage` as a fallback revert reason when `target` reverts.
262      *
263      * _Available since v3.1._
264      */
265     function functionCall(
266         address target,
267         bytes memory data,
268         string memory errorMessage
269     ) internal returns (bytes memory) {
270         return functionCallWithValue(target, data, 0, errorMessage);
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
275      * but also transferring `value` wei to `target`.
276      *
277      * Requirements:
278      *
279      * - the calling contract must have an ETH balance of at least `value`.
280      * - the called Solidity function must be `payable`.
281      *
282      * _Available since v3.1._
283      */
284     function functionCallWithValue(
285         address target,
286         bytes memory data,
287         uint256 value
288     ) internal returns (bytes memory) {
289         return
290             functionCallWithValue(
291                 target,
292                 data,
293                 value,
294                 "Address: low-level call with value failed"
295             );
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
300      * with `errorMessage` as a fallback revert reason when `target` reverts.
301      *
302      * _Available since v3.1._
303      */
304     function functionCallWithValue(
305         address target,
306         bytes memory data,
307         uint256 value,
308         string memory errorMessage
309     ) internal returns (bytes memory) {
310         require(
311             address(this).balance >= value,
312             "Address: insufficient balance for call"
313         );
314         require(isContract(target), "Address: call to non-contract");
315 
316         (bool success, bytes memory returndata) = target.call{value: value}(
317             data
318         );
319         return verifyCallResult(success, returndata, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but performing a static call.
325      *
326      * _Available since v3.3._
327      */
328     function functionStaticCall(address target, bytes memory data)
329         internal
330         view
331         returns (bytes memory)
332     {
333         return
334             functionStaticCall(
335                 target,
336                 data,
337                 "Address: low-level static call failed"
338             );
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
343      * but performing a static call.
344      *
345      * _Available since v3.3._
346      */
347     function functionStaticCall(
348         address target,
349         bytes memory data,
350         string memory errorMessage
351     ) internal view returns (bytes memory) {
352         require(isContract(target), "Address: static call to non-contract");
353 
354         (bool success, bytes memory returndata) = target.staticcall(data);
355         return verifyCallResult(success, returndata, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but performing a delegate call.
361      *
362      * _Available since v3.4._
363      */
364     function functionDelegateCall(address target, bytes memory data)
365         internal
366         returns (bytes memory)
367     {
368         return
369             functionDelegateCall(
370                 target,
371                 data,
372                 "Address: low-level delegate call failed"
373             );
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
378      * but performing a delegate call.
379      *
380      * _Available since v3.4._
381      */
382     function functionDelegateCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal returns (bytes memory) {
387         require(isContract(target), "Address: delegate call to non-contract");
388 
389         (bool success, bytes memory returndata) = target.delegatecall(data);
390         return verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
395      * revert reason using the provided one.
396      *
397      * _Available since v4.3._
398      */
399     function verifyCallResult(
400         bool success,
401         bytes memory returndata,
402         string memory errorMessage
403     ) internal pure returns (bytes memory) {
404         if (success) {
405             return returndata;
406         } else {
407             // Look for revert reason and bubble it up if present
408             if (returndata.length > 0) {
409                 // The easiest way to bubble the revert reason is using memory via assembly
410 
411                 assembly {
412                     let returndata_size := mload(returndata)
413                     revert(add(32, returndata), returndata_size)
414                 }
415             } else {
416                 revert(errorMessage);
417             }
418         }
419     }
420 }
421 
422 pragma solidity ^0.8.0;
423 
424 /**
425  * @title ERC721 token receiver interface
426  * @dev Interface for any contract that wants to support safeTransfers
427  * from ERC721 asset contracts.
428  */
429 interface IERC721Receiver {
430     /**
431      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
432      * by `operator` from `from`, this function is called.
433      *
434      * It must return its Solidity selector to confirm the token transfer.
435      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
436      *
437      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
438      */
439     function onERC721Received(
440         address operator,
441         address from,
442         uint256 tokenId,
443         bytes calldata data
444     ) external returns (bytes4);
445 }
446 
447 pragma solidity ^0.8.0;
448 
449 pragma solidity ^0.8.0;
450 
451 /**
452  * @dev Required interface of an ERC721 compliant contract.
453  */
454 interface IERC721 is IERC165 {
455     /**
456      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
457      */
458     event Transfer(
459         address indexed from,
460         address indexed to,
461         uint256 indexed tokenId
462     );
463 
464     /**
465      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
466      */
467     event Approval(
468         address indexed owner,
469         address indexed approved,
470         uint256 indexed tokenId
471     );
472 
473     /**
474      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
475      */
476     event ApprovalForAll(
477         address indexed owner,
478         address indexed operator,
479         bool approved
480     );
481 
482     /**
483      * @dev Returns the number of tokens in ``owner``'s account.
484      */
485     function balanceOf(address owner) external view returns (uint256 balance);
486 
487     /**
488      * @dev Returns the owner of the `tokenId` token.
489      *
490      * Requirements:
491      *
492      * - `tokenId` must exist.
493      */
494     function ownerOf(uint256 tokenId) external view returns (address owner);
495 
496     /**
497      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
498      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
499      *
500      * Requirements:
501      *
502      * - `from` cannot be the zero address.
503      * - `to` cannot be the zero address.
504      * - `tokenId` token must exist and be owned by `from`.
505      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
506      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
507      *
508      * Emits a {Transfer} event.
509      */
510     function safeTransferFrom(
511         address from,
512         address to,
513         uint256 tokenId
514     ) external;
515 
516     /**
517      * @dev Transfers `tokenId` token from `from` to `to`.
518      *
519      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
520      *
521      * Requirements:
522      *
523      * - `from` cannot be the zero address.
524      * - `to` cannot be the zero address.
525      * - `tokenId` token must be owned by `from`.
526      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
527      *
528      * Emits a {Transfer} event.
529      */
530     function transferFrom(
531         address from,
532         address to,
533         uint256 tokenId
534     ) external;
535 
536     /**
537      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
538      * The approval is cleared when the token is transferred.
539      *
540      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
541      *
542      * Requirements:
543      *
544      * - The caller must own the token or be an approved operator.
545      * - `tokenId` must exist.
546      *
547      * Emits an {Approval} event.
548      */
549     function approve(address to, uint256 tokenId) external;
550 
551     /**
552      * @dev Returns the account approved for `tokenId` token.
553      *
554      * Requirements:
555      *
556      * - `tokenId` must exist.
557      */
558     function getApproved(uint256 tokenId)
559         external
560         view
561         returns (address operator);
562 
563     /**
564      * @dev Approve or remove `operator` as an operator for the caller.
565      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
566      *
567      * Requirements:
568      *
569      * - The `operator` cannot be the caller.
570      *
571      * Emits an {ApprovalForAll} event.
572      */
573     function setApprovalForAll(address operator, bool _approved) external;
574 
575     /**
576      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
577      *
578      * See {setApprovalForAll}
579      */
580     function isApprovedForAll(address owner, address operator)
581         external
582         view
583         returns (bool);
584 
585     /**
586      * @dev Safely transfers `tokenId` token from `from` to `to`.
587      *
588      * Requirements:
589      *
590      * - `from` cannot be the zero address.
591      * - `to` cannot be the zero address.
592      * - `tokenId` token must exist and be owned by `from`.
593      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
594      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
595      *
596      * Emits a {Transfer} event.
597      */
598     function safeTransferFrom(
599         address from,
600         address to,
601         uint256 tokenId,
602         bytes calldata data
603     ) external;
604 }
605 
606 /**
607  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
608  * @dev See https://eips.ethereum.org/EIPS/eip-721
609  */
610 interface IERC721Enumerable is IERC721 {
611     /**
612      * @dev Returns the total amount of tokens stored by the contract.
613      */
614     function totalSupply() external view returns (uint256);
615 
616     /**
617      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
618      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
619      */
620     function tokenOfOwnerByIndex(address owner, uint256 index)
621         external
622         view
623         returns (uint256 tokenId);
624 
625     /**
626      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
627      * Use along with {totalSupply} to enumerate all tokens.
628      */
629     function tokenByIndex(uint256 index) external view returns (uint256);
630 }
631 
632 pragma solidity ^0.8.0;
633 
634 /**
635  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
636  * @dev See https://eips.ethereum.org/EIPS/eip-721
637  */
638 interface IERC721Metadata is IERC721 {
639     /**
640      * @dev Returns the token collection name.
641      */
642     function name() external view returns (string memory);
643 
644     /**
645      * @dev Returns the token collection symbol.
646      */
647     function symbol() external view returns (string memory);
648 
649     /**
650      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
651      */
652     function tokenURI(uint256 tokenId) external view returns (string memory);
653 }
654 
655 pragma solidity ^0.8.0;
656 
657 /**
658  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
659  * the Metadata extension, but not including the Enumerable extension, which is available separately as
660  * {ERC721Enumerable}.
661  */
662 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
663     using Address for address;
664     using Strings for uint256;
665 
666     // Token name
667     string private _name;
668 
669     // Token symbol
670     string private _symbol;
671 
672     // Mapping from token ID to owner address
673     mapping(uint256 => address) private _owners;
674 
675     // Mapping owner address to token count
676     mapping(address => uint256) private _balances;
677 
678     // Mapping from token ID to approved address
679     mapping(uint256 => address) private _tokenApprovals;
680 
681     // Mapping from owner to operator approvals
682     mapping(address => mapping(address => bool)) private _operatorApprovals;
683 
684     /**
685      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
686      */
687     constructor(string memory name_, string memory symbol_) {
688         _name = name_;
689         _symbol = symbol_;
690     }
691 
692     /**
693      * @dev See {IERC165-supportsInterface}.
694      */
695     function supportsInterface(bytes4 interfaceId)
696         public
697         view
698         virtual
699         override(ERC165, IERC165)
700         returns (bool)
701     {
702         return
703             interfaceId == type(IERC721).interfaceId ||
704             interfaceId == type(IERC721Metadata).interfaceId ||
705             super.supportsInterface(interfaceId);
706     }
707 
708     /**
709      * @dev See {IERC721-balanceOf}.
710      */
711     function balanceOf(address owner)
712         public
713         view
714         virtual
715         override
716         returns (uint256)
717     {
718         require(
719             owner != address(0),
720             "ERC721: balance query for the zero address"
721         );
722         return _balances[owner];
723     }
724 
725     /**
726      * @dev See {IERC721-ownerOf}.
727      */
728     function ownerOf(uint256 tokenId)
729         public
730         view
731         virtual
732         override
733         returns (address)
734     {
735         address owner = _owners[tokenId];
736         require(
737             owner != address(0),
738             "ERC721: owner query for nonexistent token"
739         );
740         return owner;
741     }
742 
743     /**
744      * @dev See {IERC721Metadata-name}.
745      */
746     function name() public view virtual override returns (string memory) {
747         return _name;
748     }
749 
750     /**
751      * @dev See {IERC721Metadata-symbol}.
752      */
753     function symbol() public view virtual override returns (string memory) {
754         return _symbol;
755     }
756 
757     /**
758      * @dev See {IERC721Metadata-tokenURI}.
759      */
760     function tokenURI(uint256 tokenId)
761         public
762         view
763         virtual
764         override
765         returns (string memory)
766     {
767         require(
768             _exists(tokenId),
769             "ERC721Metadata: URI query for nonexistent token"
770         );
771 
772         string memory baseURI = _baseURI();
773         return
774             bytes(baseURI).length > 0
775                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
776                 : "";
777     }
778 
779     /**
780      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
781      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
782      * by default, can be overriden in child contracts.
783      */
784     function _baseURI() internal view virtual returns (string memory) {
785         return "";
786     }
787 
788     /**
789      * @dev See {IERC721-approve}.
790      */
791     function approve(address to, uint256 tokenId) public virtual override {
792         address owner = ERC721.ownerOf(tokenId);
793         require(to != owner, "ERC721: approval to current owner");
794 
795         require(
796             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
797             "ERC721: approve caller is not owner nor approved for all"
798         );
799 
800         _approve(to, tokenId);
801     }
802 
803     /**
804      * @dev See {IERC721-getApproved}.
805      */
806     function getApproved(uint256 tokenId)
807         public
808         view
809         virtual
810         override
811         returns (address)
812     {
813         require(
814             _exists(tokenId),
815             "ERC721: approved query for nonexistent token"
816         );
817 
818         return _tokenApprovals[tokenId];
819     }
820 
821     /**
822      * @dev See {IERC721-setApprovalForAll}.
823      */
824     function setApprovalForAll(address operator, bool approved)
825         public
826         virtual
827         override
828     {
829         _setApprovalForAll(_msgSender(), operator, approved);
830     }
831 
832     /**
833      * @dev See {IERC721-isApprovedForAll}.
834      */
835     function isApprovedForAll(address owner, address operator)
836         public
837         view
838         virtual
839         override
840         returns (bool)
841     {
842         return _operatorApprovals[owner][operator];
843     }
844 
845     /**
846      * @dev See {IERC721-transferFrom}.
847      */
848     function transferFrom(
849         address from,
850         address to,
851         uint256 tokenId
852     ) public virtual override {
853         //solhint-disable-next-line max-line-length
854         require(
855             _isApprovedOrOwner(_msgSender(), tokenId),
856             "ERC721: transfer caller is not owner nor approved"
857         );
858 
859         _transfer(from, to, tokenId);
860     }
861 
862     /**
863      * @dev See {IERC721-safeTransferFrom}.
864      */
865     function safeTransferFrom(
866         address from,
867         address to,
868         uint256 tokenId
869     ) public virtual override {
870         safeTransferFrom(from, to, tokenId, "");
871     }
872 
873     /**
874      * @dev See {IERC721-safeTransferFrom}.
875      */
876     function safeTransferFrom(
877         address from,
878         address to,
879         uint256 tokenId,
880         bytes memory _data
881     ) public virtual override {
882         require(
883             _isApprovedOrOwner(_msgSender(), tokenId),
884             "ERC721: transfer caller is not owner nor approved"
885         );
886         _safeTransfer(from, to, tokenId, _data);
887     }
888 
889     /**
890      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
891      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
892      *
893      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
894      *
895      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
896      * implement alternative mechanisms to perform token transfer, such as signature-based.
897      *
898      * Requirements:
899      *
900      * - `from` cannot be the zero address.
901      * - `to` cannot be the zero address.
902      * - `tokenId` token must exist and be owned by `from`.
903      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _safeTransfer(
908         address from,
909         address to,
910         uint256 tokenId,
911         bytes memory _data
912     ) internal virtual {
913         _transfer(from, to, tokenId);
914         require(
915             _checkOnERC721Received(from, to, tokenId, _data),
916             "ERC721: transfer to non ERC721Receiver implementer"
917         );
918     }
919 
920     /**
921      * @dev Returns whether `tokenId` exists.
922      *
923      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
924      *
925      * Tokens start existing when they are minted (`_mint`),
926      * and stop existing when they are burned (`_burn`).
927      */
928     function _exists(uint256 tokenId) internal view virtual returns (bool) {
929         return _owners[tokenId] != address(0);
930     }
931 
932     /**
933      * @dev Returns whether `spender` is allowed to manage `tokenId`.
934      *
935      * Requirements:
936      *
937      * - `tokenId` must exist.
938      */
939     function _isApprovedOrOwner(address spender, uint256 tokenId)
940         internal
941         view
942         virtual
943         returns (bool)
944     {
945         require(
946             _exists(tokenId),
947             "ERC721: operator query for nonexistent token"
948         );
949         address owner = ERC721.ownerOf(tokenId);
950         return (spender == owner ||
951             getApproved(tokenId) == spender ||
952             isApprovedForAll(owner, spender));
953     }
954 
955     /**
956      * @dev Safely mints `tokenId` and transfers it to `to`.
957      *
958      * Requirements:
959      *
960      * - `tokenId` must not exist.
961      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
962      *
963      * Emits a {Transfer} event.
964      */
965     function _safeMint(address to, uint256 tokenId) internal virtual {
966         _safeMint(to, tokenId, "");
967     }
968 
969     /**
970      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
971      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
972      */
973     function _safeMint(
974         address to,
975         uint256 tokenId,
976         bytes memory _data
977     ) internal virtual {
978         _mint(to, tokenId);
979         require(
980             _checkOnERC721Received(address(0), to, tokenId, _data),
981             "ERC721: transfer to non ERC721Receiver implementer"
982         );
983     }
984 
985     /**
986      * @dev Mints `tokenId` and transfers it to `to`.
987      *
988      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
989      *
990      * Requirements:
991      *
992      * - `tokenId` must not exist.
993      * - `to` cannot be the zero address.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _mint(address to, uint256 tokenId) internal virtual {
998         require(to != address(0), "ERC721: mint to the zero address");
999         require(!_exists(tokenId), "ERC721: token already minted");
1000 
1001         _beforeTokenTransfer(address(0), to, tokenId);
1002 
1003         _balances[to] += 1;
1004         _owners[tokenId] = to;
1005 
1006         emit Transfer(address(0), to, tokenId);
1007     }
1008 
1009     /**
1010      * @dev Destroys `tokenId`.
1011      * The approval is cleared when the token is burned.
1012      *
1013      * Requirements:
1014      *
1015      * - `tokenId` must exist.
1016      *
1017      * Emits a {Transfer} event.
1018      */
1019     function _burn(uint256 tokenId) internal virtual {
1020         address owner = ERC721.ownerOf(tokenId);
1021 
1022         _beforeTokenTransfer(owner, address(0), tokenId);
1023 
1024         // Clear approvals
1025         _approve(address(0), tokenId);
1026 
1027         _balances[owner] -= 1;
1028         delete _owners[tokenId];
1029 
1030         emit Transfer(owner, address(0), tokenId);
1031     }
1032 
1033     /**
1034      * @dev Transfers `tokenId` from `from` to `to`.
1035      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1036      *
1037      * Requirements:
1038      *
1039      * - `to` cannot be the zero address.
1040      * - `tokenId` token must be owned by `from`.
1041      *
1042      * Emits a {Transfer} event.
1043      */
1044     function _transfer(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) internal virtual {
1049         require(
1050             ERC721.ownerOf(tokenId) == from,
1051             "ERC721: transfer of token that is not own"
1052         );
1053         require(to != address(0), "ERC721: transfer to the zero address");
1054 
1055         _beforeTokenTransfer(from, to, tokenId);
1056 
1057         // Clear approvals from the previous owner
1058         _approve(address(0), tokenId);
1059 
1060         _balances[from] -= 1;
1061         _balances[to] += 1;
1062         _owners[tokenId] = to;
1063 
1064         emit Transfer(from, to, tokenId);
1065     }
1066 
1067     /**
1068      * @dev Approve `to` to operate on `tokenId`
1069      *
1070      * Emits a {Approval} event.
1071      */
1072     function _approve(address to, uint256 tokenId) internal virtual {
1073         _tokenApprovals[tokenId] = to;
1074         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1075     }
1076 
1077     /**
1078      * @dev Approve `operator` to operate on all of `owner` tokens
1079      *
1080      * Emits a {ApprovalForAll} event.
1081      */
1082     function _setApprovalForAll(
1083         address owner,
1084         address operator,
1085         bool approved
1086     ) internal virtual {
1087         require(owner != operator, "ERC721: approve to caller");
1088         _operatorApprovals[owner][operator] = approved;
1089         emit ApprovalForAll(owner, operator, approved);
1090     }
1091 
1092     /**
1093      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1094      * The call is not executed if the target address is not a contract.
1095      *
1096      * @param from address representing the previous owner of the given token ID
1097      * @param to target address that will receive the tokens
1098      * @param tokenId uint256 ID of the token to be transferred
1099      * @param _data bytes optional data to send along with the call
1100      * @return bool whether the call correctly returned the expected magic value
1101      */
1102     function _checkOnERC721Received(
1103         address from,
1104         address to,
1105         uint256 tokenId,
1106         bytes memory _data
1107     ) private returns (bool) {
1108         if (to.isContract()) {
1109             try
1110                 IERC721Receiver(to).onERC721Received(
1111                     _msgSender(),
1112                     from,
1113                     tokenId,
1114                     _data
1115                 )
1116             returns (bytes4 retval) {
1117                 return retval == IERC721Receiver.onERC721Received.selector;
1118             } catch (bytes memory reason) {
1119                 if (reason.length == 0) {
1120                     revert(
1121                         "ERC721: transfer to non ERC721Receiver implementer"
1122                     );
1123                 } else {
1124                     assembly {
1125                         revert(add(32, reason), mload(reason))
1126                     }
1127                 }
1128             }
1129         } else {
1130             return true;
1131         }
1132     }
1133 
1134     /**
1135      * @dev Hook that is called before any token transfer. This includes minting
1136      * and burning.
1137      *
1138      * Calling conditions:
1139      *
1140      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1141      * transferred to `to`.
1142      * - When `from` is zero, `tokenId` will be minted for `to`.
1143      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1144      * - `from` and `to` are never both zero.
1145      *
1146      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1147      */
1148     function _beforeTokenTransfer(
1149         address from,
1150         address to,
1151         uint256 tokenId
1152     ) internal virtual {}
1153 }
1154 
1155 pragma solidity ^0.8.0;
1156 
1157 /**
1158  * @title SafeERC20
1159  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1160  * contract returns false). Tokens that return no value (and instead revert or
1161  * throw on failure) are also supported, non-reverting calls are assumed to be
1162  * successful.
1163  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1164  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1165  */
1166 library SafeERC20 {
1167     using Address for address;
1168 
1169     function safeTransfer(
1170         IERC20 token,
1171         address to,
1172         uint256 value
1173     ) internal {
1174         _callOptionalReturn(
1175             token,
1176             abi.encodeWithSelector(token.transfer.selector, to, value)
1177         );
1178     }
1179 
1180     function safeTransferFrom(
1181         IERC20 token,
1182         address from,
1183         address to,
1184         uint256 value
1185     ) internal {
1186         _callOptionalReturn(
1187             token,
1188             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
1189         );
1190     }
1191 
1192     /**
1193      * @dev Deprecated. This function has issues similar to the ones found in
1194      * {IERC20-approve}, and its usage is discouraged.
1195      *
1196      * Whenever possible, use {safeIncreaseAllowance} and
1197      * {safeDecreaseAllowance} instead.
1198      */
1199     function safeApprove(
1200         IERC20 token,
1201         address spender,
1202         uint256 value
1203     ) internal {
1204         // safeApprove should only be called when setting an initial allowance,
1205         // or when resetting it to zero. To increase and decrease it, use
1206         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1207         require(
1208             (value == 0) || (token.allowance(address(this), spender) == 0),
1209             "SafeERC20: approve from non-zero to non-zero allowance"
1210         );
1211         _callOptionalReturn(
1212             token,
1213             abi.encodeWithSelector(token.approve.selector, spender, value)
1214         );
1215     }
1216 
1217     function safeIncreaseAllowance(
1218         IERC20 token,
1219         address spender,
1220         uint256 value
1221     ) internal {
1222         uint256 newAllowance = token.allowance(address(this), spender) + value;
1223         _callOptionalReturn(
1224             token,
1225             abi.encodeWithSelector(
1226                 token.approve.selector,
1227                 spender,
1228                 newAllowance
1229             )
1230         );
1231     }
1232 
1233     function safeDecreaseAllowance(
1234         IERC20 token,
1235         address spender,
1236         uint256 value
1237     ) internal {
1238         unchecked {
1239             uint256 oldAllowance = token.allowance(address(this), spender);
1240             require(
1241                 oldAllowance >= value,
1242                 "SafeERC20: decreased allowance below zero"
1243             );
1244             uint256 newAllowance = oldAllowance - value;
1245             _callOptionalReturn(
1246                 token,
1247                 abi.encodeWithSelector(
1248                     token.approve.selector,
1249                     spender,
1250                     newAllowance
1251                 )
1252             );
1253         }
1254     }
1255 
1256     /**
1257      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract),
1258      * relaxing the requirement
1259      * on the return value: the return value is optional (but if data is returned, it must not be false).
1260      * @param token The token targeted by the call.
1261      * @param data The call data (encoded using abi.encode or one of its variants).
1262      */
1263     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1264         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1265         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1266         // the target address contains contract code and also asserts for success in the low-level call.
1267 
1268         bytes memory returndata = address(token).functionCall(
1269             data,
1270             "SafeERC20: low-level call failed"
1271         );
1272         if (returndata.length > 0) {
1273             // Return data is optional
1274             require(
1275                 abi.decode(returndata, (bool)),
1276                 "SafeERC20: ERC20 operation did not succeed"
1277             );
1278         }
1279     }
1280 }
1281 
1282 pragma solidity ^0.8.0;
1283 
1284 /**
1285  * @dev Interface of the ERC20 standard as defined in the EIP.
1286  */
1287 interface IERC20 {
1288     /**
1289      * @dev Returns the amount of tokens in existence.
1290      */
1291     function totalSupply() external view returns (uint256);
1292 
1293     /**
1294      * @dev Returns the amount of tokens owned by `account`.
1295      */
1296     function balanceOf(address account) external view returns (uint256);
1297 
1298     /**
1299      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1300      *
1301      * Returns a boolean value indicating whether the operation succeeded.
1302      *
1303      * Emits a {Transfer} event.
1304      */
1305     function transfer(address recipient, uint256 amount)
1306         external
1307         returns (bool);
1308 
1309     /**
1310      * @dev Returns the remaining number of tokens that `spender` will be
1311      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1312      * zero by default.
1313      *
1314      * This value changes when {approve} or {transferFrom} are called.
1315      */
1316     function allowance(address owner, address spender)
1317         external
1318         view
1319         returns (uint256);
1320 
1321     /**
1322      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1323      *
1324      * Returns a boolean value indicating whether the operation succeeded.
1325      *
1326      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1327      * that someone may use both the old and the new allowance by unfortunate
1328      * transaction ordering. One possible solution to mitigate this race
1329      * condition is to first reduce the spender's allowance to 0 and set the
1330      * desired value afterwards:
1331      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1332      *
1333      * Emits an {Approval} event.
1334      */
1335     function approve(address spender, uint256 amount) external returns (bool);
1336 
1337     /**
1338      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1339      * allowance mechanism. `amount` is then deducted from the caller's
1340      * allowance.
1341      *
1342      * Returns a boolean value indicating whether the operation succeeded.
1343      *
1344      * Emits a {Transfer} event.
1345      */
1346     function transferFrom(
1347         address sender,
1348         address recipient,
1349         uint256 amount
1350     ) external returns (bool);
1351 
1352     /**
1353      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1354      * another (`to`).
1355      *
1356      * Note that `value` may be zero.
1357      */
1358     event Transfer(address indexed from, address indexed to, uint256 value);
1359 
1360     /**
1361      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1362      * a call to {approve}. `value` is the new allowance.
1363      */
1364     event Approval(
1365         address indexed owner,
1366         address indexed spender,
1367         uint256 value
1368     );
1369 }
1370 
1371 pragma solidity ^0.8.0;
1372 
1373 /**
1374  * @dev Contract module which allows children to implement an emergency stop
1375  * mechanism that can be triggered by an authorized account.
1376  *
1377  * This module is used through inheritance. It will make available the
1378  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1379  * the functions of your contract. Note that they will not be pausable by
1380  * simply including this module, only once the modifiers are put in place.
1381  */
1382 abstract contract Pausable is Context {
1383     /**
1384      * @dev Emitted when the pause is triggered by `account`.
1385      */
1386     event Paused(address account);
1387 
1388     /**
1389      * @dev Emitted when the pause is lifted by `account`.
1390      */
1391     event Unpaused(address account);
1392 
1393     bool private _paused;
1394 
1395     /**
1396      * @dev Initializes the contract in unpaused state.
1397      */
1398     constructor() {
1399         _paused = false;
1400     }
1401 
1402     /**
1403      * @dev Returns true if the contract is paused, and false otherwise.
1404      */
1405     function paused() public view virtual returns (bool) {
1406         return _paused;
1407     }
1408 
1409     /**
1410      * @dev Modifier to make a function callable only when the contract is not paused.
1411      *
1412      * Requirements:
1413      *
1414      * - The contract must not be paused.
1415      */
1416     modifier whenNotPaused() {
1417         require(!paused(), "Pausable: paused");
1418         _;
1419     }
1420 
1421     /**
1422      * @dev Modifier to make a function callable only when the contract is paused.
1423      *
1424      * Requirements:
1425      *
1426      * - The contract must be paused.
1427      */
1428     modifier whenPaused() {
1429         require(paused(), "Pausable: not paused");
1430         _;
1431     }
1432 
1433     /**
1434      * @dev Triggers stopped state.
1435      *
1436      * Requirements:
1437      *
1438      * - The contract must not be paused.
1439      */
1440     function _pause() internal virtual whenNotPaused {
1441         _paused = true;
1442         emit Paused(_msgSender());
1443     }
1444 
1445     /**
1446      * @dev Returns to normal state.
1447      *
1448      * Requirements:
1449      *
1450      * - The contract must be paused.
1451      */
1452     function _unpause() internal virtual whenPaused {
1453         _paused = false;
1454         emit Unpaused(_msgSender());
1455     }
1456 }
1457 
1458 pragma solidity ^0.8.0;
1459 
1460 /**
1461  * @dev Contract module which provides a basic access control mechanism, where
1462  * there is an account (an owner) that can be granted exclusive access to
1463  * specific functions.
1464  *
1465  * By default, the owner account will be the one that deploys the contract. This
1466  * can later be changed with {transferOwnership}.
1467  *
1468  * This module is used through inheritance. It will make available the modifier
1469  * `onlyOwner`, which can be applied to your functions to restrict their use to
1470  * the owner.
1471  */
1472 abstract contract Ownable is Context {
1473     address private _owner;
1474 
1475     event OwnershipTransferred(
1476         address indexed previousOwner,
1477         address indexed newOwner
1478     );
1479 
1480     /**
1481      * @dev Initializes the contract setting the deployer as the initial owner.
1482      */
1483     constructor() {
1484         _transferOwnership(_msgSender());
1485     }
1486 
1487     /**
1488      * @dev Returns the address of the current owner.
1489      */
1490     function owner() public view virtual returns (address) {
1491         return _owner;
1492     }
1493 
1494     /**
1495      * @dev Throws if called by any account other than the owner.
1496      */
1497     modifier onlyOwner() {
1498         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1499         _;
1500     }
1501 
1502     /**
1503      * @dev Leaves the contract without owner. It will not be possible to call
1504      * `onlyOwner` functions anymore. Can only be called by the current owner.
1505      *
1506      * NOTE: Renouncing ownership will leave the contract without an owner,
1507      * thereby removing any functionality that is only available to the owner.
1508      */
1509     function renounceOwnership() public virtual onlyOwner {
1510         _transferOwnership(address(0));
1511     }
1512 
1513     /**
1514      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1515      * Can only be called by the current owner.
1516      */
1517     function transferOwnership(address newOwner) public virtual onlyOwner {
1518         require(
1519             newOwner != address(0),
1520             "Ownable: new owner is the zero address"
1521         );
1522         _transferOwnership(newOwner);
1523     }
1524 
1525     /**
1526      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1527      * Internal function without access restriction.
1528      */
1529     function _transferOwnership(address newOwner) internal virtual {
1530         address oldOwner = _owner;
1531         _owner = newOwner;
1532         emit OwnershipTransferred(oldOwner, newOwner);
1533     }
1534 }
1535 
1536 pragma solidity ^0.8.0;
1537 
1538 /**
1539  * @dev Standard math utilities missing in the Solidity language.
1540  */
1541 library Math {
1542     /**
1543      * @dev Returns the largest of two numbers.
1544      */
1545     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1546         return a >= b ? a : b;
1547     }
1548 
1549     /**
1550      * @dev Returns the smallest of two numbers.
1551      */
1552     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1553         return a < b ? a : b;
1554     }
1555 
1556     /**
1557      * @dev Returns the average of two numbers. The result is rounded towards
1558      * zero.
1559      */
1560     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1561         // (a + b) / 2 can overflow.
1562         return (a & b) + (a ^ b) / 2;
1563     }
1564 
1565     /**
1566      * @dev Returns the ceiling of the division of two numbers.
1567      *
1568      * This differs from standard division with `/` in that it rounds up instead
1569      * of rounding down.
1570      */
1571     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1572         // (a + b - 1) / b can overflow on addition, so we distribute.
1573         return a / b + (a % b == 0 ? 0 : 1);
1574     }
1575 }
1576 
1577 interface iMetalStaking {
1578     function _legendsForgeBlocks(uint256) external view returns (uint256);
1579 
1580     function _tigerForgeBlocks(uint256) external view returns (uint256);
1581 
1582     function _cubsForgeBlocks(uint256) external view returns (uint256);
1583 
1584     function _fundaeForgeBlocks(uint256) external view returns (uint256);
1585 
1586     function _azukiForgeBlocks(uint256) external view returns (uint256);
1587 
1588     function _legendsTokenForges(uint256) external view returns (address);
1589 
1590     function _tigerTokenForges(uint256) external view returns (address);
1591 
1592     function _cubsTokenForges(uint256) external view returns (address);
1593 
1594     function _fundaeTokenForges(uint256) external view returns (address);
1595 
1596     function _azukiTokenForges(uint256) external view returns (address);
1597 
1598     function _membershipForgeBlocks(address) external view returns (uint256);
1599 
1600     function membershipForgesOf(address account)
1601         external
1602         view
1603         returns (uint256[] memory);
1604 }
1605 
1606 pragma solidity ^0.8.0;
1607 
1608 contract LiquidForgeRewards is Ownable, Pausable {
1609     uint256 public TIGER_DISTRIBUTION_AMOUNT;
1610     uint256 public FUNDAE_DISTRIBUTION_AMOUNT;
1611     uint256 public LEGENDS_DISTRIBUTION_AMOUNT;
1612     uint256 public AZUKI_DISTRIBUTION_AMOUNT;
1613 
1614     // mappings
1615     mapping(uint256 => bool) public tigerClaimed;
1616     mapping(uint256 => bool) public fundaeClaimed;
1617     mapping(uint256 => bool) public legendsClaimed;
1618     mapping(uint256 => bool) public azukiClaimed;
1619 
1620     mapping(uint256 => uint256) public _newLegendsForgeBlocks;
1621     mapping(uint256 => uint256) public _newTigerForgeBlocks;
1622     mapping(uint256 => uint256) public _newCubsForgeBlocks;
1623     mapping(uint256 => uint256) public _newFundaeForgeBlocks;
1624     mapping(uint256 => uint256) public _newAzukiForgeBlocks;
1625 
1626     //addresses
1627     address public legendsAddress;
1628     address public tigerAddress;
1629     address public cubsAddress;
1630     address public fundaeAddress;
1631     address public azukiAddress;
1632     address public forgeAddress;
1633 
1634     address public erc20Address;
1635 
1636     //uint256's
1637     uint256 public expiration;
1638     uint256 public minBlockToClaim;
1639     //rate governs how often you receive your token
1640     uint256 public legendsRate;
1641     uint256 public tigerRate;
1642     uint256 public cubsRate;
1643     uint256 public fundaeRate;
1644     uint256 public azukiRate;
1645 
1646     uint256 public _totalSupply;
1647 
1648     mapping(address => uint256) private _balances;
1649 
1650     constructor(
1651         address _legendsAddress,
1652         address _tigerAddress,
1653         address _cubsAddress,
1654         address _fundaeAddress,
1655         address _azukiAddress,
1656         address _erc20Address
1657     ) {
1658         legendsAddress = _legendsAddress;
1659         legendsRate = 0;
1660         tigerAddress = _tigerAddress;
1661         tigerRate = 0;
1662         cubsAddress = _cubsAddress;
1663         cubsRate = 0;
1664         fundaeAddress = _fundaeAddress;
1665         fundaeRate = 0;
1666         azukiAddress = _azukiAddress;
1667         azukiRate = 0;
1668         expiration = block.number + 0;
1669         erc20Address = _erc20Address;
1670         forgeAddress = 0x78406Ee8e2Ed3D14654150D2aC5dBB67710B3492;
1671         TIGER_DISTRIBUTION_AMOUNT = 5000000000000000000;
1672         FUNDAE_DISTRIBUTION_AMOUNT = 5000000000000000000;
1673         AZUKI_DISTRIBUTION_AMOUNT = 5000000000000000000;
1674         LEGENDS_DISTRIBUTION_AMOUNT = 25000000000000000000;
1675     }
1676 
1677     function pause() public onlyOwner {
1678         _pause();
1679     }
1680 
1681     function unpause() public onlyOwner {
1682         _unpause();
1683     }
1684 
1685     function stakeOnBehalfBulk(
1686         uint256[] calldata _amounts,
1687         address[] calldata _accounts,
1688         uint256 totalAmount
1689     ) external onlyOwner {
1690         for (uint256 i = 0; i < _amounts.length; i++) {
1691             address account;
1692             account = _accounts[i];
1693             _totalSupply += _amounts[i];
1694             _balances[_accounts[i]] += _amounts[i];
1695         }
1696         IERC20(erc20Address).transferFrom(
1697             msg.sender,
1698             address(this),
1699             totalAmount
1700         );
1701     }
1702 
1703     function addressClaim() external {
1704         require(0 < _balances[msg.sender], "withdraw amount over stake");
1705         require(
1706             iMetalStaking(forgeAddress).membershipForgesOf(msg.sender).length >
1707                 0,
1708             "No Membership Forged"
1709         );
1710         uint256 reward = _balances[msg.sender];
1711         _totalSupply -= _balances[msg.sender];
1712         _balances[msg.sender] -= _balances[msg.sender];
1713         IERC20(erc20Address).transfer(msg.sender, reward);
1714         
1715     }
1716 
1717     function claimBalanceOf(address account) external view returns (uint256) {
1718         return _balances[account];
1719     }
1720 
1721     function revokeBonusReward(uint256[] calldata tokenIds, address nftaddress)
1722         public
1723         onlyOwner
1724     {
1725         if (nftaddress == legendsAddress) {
1726             for (uint256 i; i < tokenIds.length; ++i) {
1727                 uint256 tokenId = tokenIds[i];
1728                 if (!legendsClaimed[tokenId]) {
1729                     legendsClaimed[tokenId] = true;
1730                 }
1731             }
1732         }
1733         if (nftaddress == tigerAddress) {
1734             for (uint256 i; i < tokenIds.length; ++i) {
1735                 uint256 tokenId = tokenIds[i];
1736                 if (!tigerClaimed[tokenId]) {
1737                     tigerClaimed[tokenId] = true;
1738                 }
1739             }
1740         }
1741         if (nftaddress == fundaeAddress) {
1742             for (uint256 i; i < tokenIds.length; ++i) {
1743                 uint256 tokenId = tokenIds[i];
1744                 if (!fundaeClaimed[tokenId]) {
1745                     fundaeClaimed[tokenId] = true;
1746                 }
1747             }
1748         }
1749         if (nftaddress == azukiAddress) {
1750             for (uint256 i; i < tokenIds.length; ++i) {
1751                 uint256 tokenId = tokenIds[i];
1752                 if (!azukiClaimed[tokenId]) {
1753                     azukiClaimed[tokenId] = true;
1754                 }
1755             }
1756         }
1757     }
1758 
1759     
1760     // Set this to a expiration block to disable the ability to continue accruing tokens past that block number.
1761     // which is caclculated as current block plus the parm
1762     //
1763     // Set a multiplier for how many tokens to earn each time a block passes.
1764     // and the min number of blocks needed to pass to claim rewards
1765 
1766     function setRates(
1767         uint256 _legendsRate,
1768         uint256 _cubsRate,
1769         uint256 _tigerRate,
1770         uint256 _fundaeRate,
1771         uint256 _azukiRate,
1772         uint256 _minBlockToClaim,
1773         uint256 _expiration
1774     ) public onlyOwner {
1775         legendsRate = _legendsRate;
1776         cubsRate = _cubsRate;
1777         tigerRate = _tigerRate;
1778         fundaeRate = _fundaeRate;
1779         azukiRate = _azukiRate;
1780         minBlockToClaim = _minBlockToClaim;
1781         expiration = block.number + _expiration;
1782     }
1783 
1784     function rewardClaimable(uint256 tokenId, address nftaddress)
1785         public
1786         view
1787         returns (bool)
1788     {
1789         uint256 blockCur = Math.min(block.number, expiration);
1790         if (
1791             nftaddress == legendsAddress &&
1792             iMetalStaking(forgeAddress)._legendsForgeBlocks(tokenId) > 0
1793         ) {
1794             return (blockCur -
1795                 Math.max(
1796                     iMetalStaking(forgeAddress)._legendsForgeBlocks(tokenId),
1797                     _newLegendsForgeBlocks[tokenId]
1798                 ) >
1799                 minBlockToClaim);
1800         }
1801         if (
1802             nftaddress == tigerAddress &&
1803             iMetalStaking(forgeAddress)._tigerForgeBlocks(tokenId) > 0
1804         ) {
1805             return (blockCur -
1806                 Math.max(
1807                     iMetalStaking(forgeAddress)._tigerForgeBlocks(tokenId),
1808                     _newTigerForgeBlocks[tokenId]
1809                 ) >
1810                 minBlockToClaim);
1811         }
1812         if (
1813             nftaddress == cubsAddress &&
1814             iMetalStaking(forgeAddress)._cubsForgeBlocks(tokenId) > 0
1815         ) {
1816             return (blockCur -
1817                 Math.max(
1818                     iMetalStaking(forgeAddress)._cubsForgeBlocks(tokenId),
1819                     _newCubsForgeBlocks[tokenId]
1820                 ) >
1821                 minBlockToClaim);
1822         }
1823         if (
1824             nftaddress == fundaeAddress &&
1825             iMetalStaking(forgeAddress)._fundaeForgeBlocks(tokenId) > 0
1826         ) {
1827             return (blockCur -
1828                 Math.max(
1829                     iMetalStaking(forgeAddress)._fundaeForgeBlocks(tokenId),
1830                     _newFundaeForgeBlocks[tokenId]
1831                 ) >
1832                 minBlockToClaim);
1833         }
1834         if (
1835             nftaddress == azukiAddress &&
1836             iMetalStaking(forgeAddress)._azukiForgeBlocks(tokenId) > 0
1837         ) {
1838             return (blockCur -
1839                 Math.max(
1840                     iMetalStaking(forgeAddress)._azukiForgeBlocks(tokenId),
1841                     _newAzukiForgeBlocks[tokenId]
1842                 ) >
1843                 minBlockToClaim);
1844         }
1845         return false;
1846     }
1847 
1848     function oldLegendsForgeBlocks(uint256 tokenId)
1849         public
1850         view
1851         returns (uint256)
1852     {
1853         return iMetalStaking(forgeAddress)._legendsForgeBlocks(tokenId);
1854     }
1855 
1856     function oldLegendsTokenForges(uint256 tokenId)
1857         public
1858         view
1859         returns (address)
1860     {
1861         return iMetalStaking(forgeAddress)._legendsTokenForges(tokenId);
1862     }
1863 
1864     //reward amount by address/tokenIds[]
1865     function calculateReward(
1866         address account,
1867         uint256 tokenId,
1868         address nftaddress
1869     ) public view returns (uint256) {
1870         if (nftaddress == legendsAddress) {
1871             uint256 tmp = Math.max(
1872                 iMetalStaking(forgeAddress)._legendsForgeBlocks(tokenId),
1873                 iMetalStaking(forgeAddress)._membershipForgeBlocks(account)
1874             );
1875             require(
1876                 Math.min(block.number, expiration) >
1877                     iMetalStaking(forgeAddress)._legendsForgeBlocks(tokenId),
1878                 "Invalid blocks"
1879             );
1880             return
1881                 legendsRate *
1882                 (
1883                     iMetalStaking(forgeAddress)._legendsTokenForges(tokenId) ==
1884                         account
1885                         ? 1
1886                         : 0
1887                 ) *
1888                 (Math.min(block.number, expiration) -
1889                     Math.max(tmp, _newLegendsForgeBlocks[tokenId]));
1890         }
1891         if (nftaddress == tigerAddress) {
1892             uint256 tmp = Math.max(
1893                 iMetalStaking(forgeAddress)._tigerForgeBlocks(tokenId),
1894                 iMetalStaking(forgeAddress)._membershipForgeBlocks(account)
1895             );
1896             require(
1897                 Math.min(block.number, expiration) >
1898                     iMetalStaking(forgeAddress)._tigerForgeBlocks(tokenId),
1899                 "Invalid blocks"
1900             );
1901             return
1902                 tigerRate *
1903                 (
1904                     iMetalStaking(forgeAddress)._tigerTokenForges(tokenId) ==
1905                         account
1906                         ? 1
1907                         : 0
1908                 ) *
1909                 (Math.min(block.number, expiration) -
1910                     Math.max(tmp, _newTigerForgeBlocks[tokenId]));
1911         }
1912         if (nftaddress == cubsAddress) {
1913             uint256 tmp = Math.max(
1914                 iMetalStaking(forgeAddress)._cubsForgeBlocks(tokenId),
1915                 iMetalStaking(forgeAddress)._membershipForgeBlocks(account)
1916             );
1917             require(
1918                 Math.min(block.number, expiration) >
1919                     iMetalStaking(forgeAddress)._cubsForgeBlocks(tokenId),
1920                 "Invalid blocks"
1921             );
1922             return
1923                 cubsRate *
1924                 (
1925                     iMetalStaking(forgeAddress)._cubsTokenForges(tokenId) ==
1926                         account
1927                         ? 1
1928                         : 0
1929                 ) *
1930                 (Math.min(block.number, expiration) -
1931                     Math.max(tmp, _newCubsForgeBlocks[tokenId]));
1932         }
1933         if (nftaddress == azukiAddress) {
1934             uint256 tmp = Math.max(
1935                 iMetalStaking(forgeAddress)._azukiForgeBlocks(tokenId),
1936                 iMetalStaking(forgeAddress)._membershipForgeBlocks(account)
1937             );
1938             require(
1939                 Math.min(block.number, expiration) >
1940                     iMetalStaking(forgeAddress)._azukiForgeBlocks(tokenId),
1941                 "Invalid blocks"
1942             );
1943             return
1944                 azukiRate *
1945                 (
1946                     iMetalStaking(forgeAddress)._azukiTokenForges(tokenId) ==
1947                         account
1948                         ? 1
1949                         : 0
1950                 ) *
1951                 (Math.min(block.number, expiration) -
1952                     Math.max(tmp, _newAzukiForgeBlocks[tokenId]));
1953         }
1954         if (nftaddress == fundaeAddress) {
1955             uint256 tmp = Math.max(
1956                 iMetalStaking(forgeAddress)._fundaeForgeBlocks(tokenId),
1957                 iMetalStaking(forgeAddress)._membershipForgeBlocks(account)
1958             );
1959             require(
1960                 Math.min(block.number, expiration) >
1961                     iMetalStaking(forgeAddress)._azukiForgeBlocks(tokenId),
1962                 "Invalid blocks"
1963             );
1964             return
1965                 fundaeRate *
1966                 (
1967                     iMetalStaking(forgeAddress)._fundaeTokenForges(tokenId) ==
1968                         account
1969                         ? 1
1970                         : 0
1971                 ) *
1972                 (Math.min(block.number, expiration) -
1973                     Math.max(tmp, _newAzukiForgeBlocks[tokenId]));
1974         }
1975         return 0;
1976     }
1977 
1978     //reward claim function
1979     function ClaimRewards(uint256[] calldata tokenIds, address nftaddress)
1980         public
1981         whenNotPaused
1982     {
1983         uint256 reward;
1984         uint256 blockCur = Math.min(block.number, expiration);
1985 
1986         require(
1987             iMetalStaking(forgeAddress).membershipForgesOf(msg.sender).length >
1988                 0,
1989             "No Membership Forged"
1990         );
1991 
1992         if (nftaddress == legendsAddress) {
1993             for (uint256 i; i < tokenIds.length; i++) {
1994                 require(
1995                     IERC721(legendsAddress).ownerOf(tokenIds[i]) == msg.sender
1996                 );
1997                 require(
1998                     blockCur -
1999                         Math.max(
2000                             iMetalStaking(forgeAddress)._legendsForgeBlocks(
2001                                 tokenIds[i]
2002                             ),
2003                             _newLegendsForgeBlocks[tokenIds[i]]
2004                         ) >
2005                         minBlockToClaim
2006                 );
2007             }
2008 
2009             for (uint256 i; i < tokenIds.length; i++) {
2010                 reward += calculateReward(
2011                     msg.sender,
2012                     tokenIds[i],
2013                     legendsAddress
2014                 );
2015                 _newLegendsForgeBlocks[tokenIds[i]] = blockCur;
2016             }
2017 
2018             for (uint256 i; i < tokenIds.length; ++i) {
2019                 uint256 tokenId = tokenIds[i];
2020                 if (!legendsClaimed[tokenId]) {
2021                     legendsClaimed[tokenId] = true;
2022                     reward += LEGENDS_DISTRIBUTION_AMOUNT;
2023                 }
2024             }
2025         }
2026 
2027         if (nftaddress == tigerAddress) {
2028             for (uint256 i; i < tokenIds.length; i++) {
2029                 require(
2030                     IERC721(tigerAddress).ownerOf(tokenIds[i]) == msg.sender
2031                 );
2032                 require(
2033                     blockCur -
2034                         Math.max(
2035                             iMetalStaking(forgeAddress)._tigerForgeBlocks(
2036                                 tokenIds[i]
2037                             ),
2038                             _newTigerForgeBlocks[tokenIds[i]]
2039                         ) >
2040                         minBlockToClaim
2041                 );
2042             }
2043 
2044             for (uint256 i; i < tokenIds.length; i++) {
2045                 reward += calculateReward(
2046                     msg.sender,
2047                     tokenIds[i],
2048                     tigerAddress
2049                 );
2050                 _newTigerForgeBlocks[tokenIds[i]] = blockCur;
2051             }
2052 
2053             for (uint256 i; i < tokenIds.length; ++i) {
2054                 uint256 tokenId = tokenIds[i];
2055                 if (!tigerClaimed[tokenId]) {
2056                     tigerClaimed[tokenId] = true;
2057                     reward += TIGER_DISTRIBUTION_AMOUNT;
2058                 }
2059             }
2060         }
2061 
2062         if (nftaddress == cubsAddress) {
2063             for (uint256 i; i < tokenIds.length; i++) {
2064                 require(
2065                     IERC721(cubsAddress).ownerOf(tokenIds[i]) == msg.sender
2066                 );
2067                 require(
2068                     blockCur -
2069                         Math.max(
2070                             iMetalStaking(forgeAddress)._cubsForgeBlocks(
2071                                 tokenIds[i]
2072                             ),
2073                             _newCubsForgeBlocks[tokenIds[i]]
2074                         ) >
2075                         minBlockToClaim
2076                 );
2077             }
2078 
2079             for (uint256 i; i < tokenIds.length; i++) {
2080                 reward += calculateReward(msg.sender, tokenIds[i], cubsAddress);
2081                 _newCubsForgeBlocks[tokenIds[i]] = blockCur;
2082             }
2083         }
2084 
2085         if (nftaddress == fundaeAddress) {
2086             for (uint256 i; i < tokenIds.length; i++) {
2087                 require(
2088                     IERC721(fundaeAddress).ownerOf(tokenIds[i]) == msg.sender
2089                 );
2090                 require(
2091                     blockCur -
2092                         Math.max(
2093                             iMetalStaking(forgeAddress)._fundaeForgeBlocks(
2094                                 tokenIds[i]
2095                             ),
2096                             _newFundaeForgeBlocks[tokenIds[i]]
2097                         ) >
2098                         minBlockToClaim
2099                 );
2100             }
2101 
2102             for (uint256 i; i < tokenIds.length; i++) {
2103                 reward += calculateReward(
2104                     msg.sender,
2105                     tokenIds[i],
2106                     fundaeAddress
2107                 );
2108                 _newFundaeForgeBlocks[tokenIds[i]] = blockCur;
2109             }
2110 
2111             for (uint256 i; i < tokenIds.length; ++i) {
2112                 uint256 tokenId = tokenIds[i];
2113                 if (!fundaeClaimed[tokenId]) {
2114                     fundaeClaimed[tokenId] = true;
2115                     reward += FUNDAE_DISTRIBUTION_AMOUNT;
2116                 }
2117             }
2118         }
2119 
2120         if (nftaddress == azukiAddress) {
2121             for (uint256 i; i < tokenIds.length; i++) {
2122                 require(
2123                     IERC721(azukiAddress).ownerOf(tokenIds[i]) == msg.sender
2124                 );
2125                 require(
2126                     blockCur -
2127                         Math.max(
2128                             iMetalStaking(forgeAddress)._azukiForgeBlocks(
2129                                 tokenIds[i]
2130                             ),
2131                             _newAzukiForgeBlocks[tokenIds[i]]
2132                         ) >
2133                         minBlockToClaim
2134                 );
2135             }
2136             for (uint256 i; i < tokenIds.length; i++) {
2137                 reward += calculateReward(
2138                     msg.sender,
2139                     tokenIds[i],
2140                     azukiAddress
2141                 );
2142                 _newAzukiForgeBlocks[tokenIds[i]] = blockCur;
2143             }
2144 
2145             for (uint256 i; i < tokenIds.length; ++i) {
2146                 uint256 tokenId = tokenIds[i];
2147                 if (!azukiClaimed[tokenId]) {
2148                     azukiClaimed[tokenId] = true;
2149                     reward += AZUKI_DISTRIBUTION_AMOUNT;
2150                 }
2151             }
2152         }
2153 
2154         if (reward > 0) {
2155             IERC20(erc20Address).transfer(msg.sender, reward);
2156         }
2157     }
2158 
2159     //withdrawal function.
2160     function withdrawTokens() external onlyOwner {
2161         uint256 tokenSupply = IERC20(erc20Address).balanceOf(address(this));
2162         IERC20(erc20Address).transfer(msg.sender, tokenSupply);
2163     }
2164 }