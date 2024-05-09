1 // Sources flattened with hardhat v2.8.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 
33 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
34 
35 
36 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Required interface of an ERC721 compliant contract.
42  */
43 interface IERC721 is IERC165 {
44     /**
45      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
46      */
47     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
51      */
52     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
53 
54     /**
55      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
56      */
57     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
58 
59     /**
60      * @dev Returns the number of tokens in ``owner``'s account.
61      */
62     function balanceOf(address owner) external view returns (uint256 balance);
63 
64     /**
65      * @dev Returns the owner of the `tokenId` token.
66      *
67      * Requirements:
68      *
69      * - `tokenId` must exist.
70      */
71     function ownerOf(uint256 tokenId) external view returns (address owner);
72 
73     /**
74      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
75      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
76      *
77      * Requirements:
78      *
79      * - `from` cannot be the zero address.
80      * - `to` cannot be the zero address.
81      * - `tokenId` token must exist and be owned by `from`.
82      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
83      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
84      *
85      * Emits a {Transfer} event.
86      */
87     function safeTransferFrom(
88         address from,
89         address to,
90         uint256 tokenId
91     ) external;
92 
93     /**
94      * @dev Transfers `tokenId` token from `from` to `to`.
95      *
96      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
97      *
98      * Requirements:
99      *
100      * - `from` cannot be the zero address.
101      * - `to` cannot be the zero address.
102      * - `tokenId` token must be owned by `from`.
103      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transferFrom(
108         address from,
109         address to,
110         uint256 tokenId
111     ) external;
112 
113     /**
114      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
115      * The approval is cleared when the token is transferred.
116      *
117      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
118      *
119      * Requirements:
120      *
121      * - The caller must own the token or be an approved operator.
122      * - `tokenId` must exist.
123      *
124      * Emits an {Approval} event.
125      */
126     function approve(address to, uint256 tokenId) external;
127 
128     /**
129      * @dev Returns the account approved for `tokenId` token.
130      *
131      * Requirements:
132      *
133      * - `tokenId` must exist.
134      */
135     function getApproved(uint256 tokenId) external view returns (address operator);
136 
137     /**
138      * @dev Approve or remove `operator` as an operator for the caller.
139      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
140      *
141      * Requirements:
142      *
143      * - The `operator` cannot be the caller.
144      *
145      * Emits an {ApprovalForAll} event.
146      */
147     function setApprovalForAll(address operator, bool _approved) external;
148 
149     /**
150      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
151      *
152      * See {setApprovalForAll}
153      */
154     function isApprovedForAll(address owner, address operator) external view returns (bool);
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`.
158      *
159      * Requirements:
160      *
161      * - `from` cannot be the zero address.
162      * - `to` cannot be the zero address.
163      * - `tokenId` token must exist and be owned by `from`.
164      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
165      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
166      *
167      * Emits a {Transfer} event.
168      */
169     function safeTransferFrom(
170         address from,
171         address to,
172         uint256 tokenId,
173         bytes calldata data
174     ) external;
175 }
176 
177 
178 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
179 
180 
181 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
182 
183 pragma solidity ^0.8.0;
184 
185 /**
186  * @title ERC721 token receiver interface
187  * @dev Interface for any contract that wants to support safeTransfers
188  * from ERC721 asset contracts.
189  */
190 interface IERC721Receiver {
191     /**
192      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
193      * by `operator` from `from`, this function is called.
194      *
195      * It must return its Solidity selector to confirm the token transfer.
196      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
197      *
198      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
199      */
200     function onERC721Received(
201         address operator,
202         address from,
203         uint256 tokenId,
204         bytes calldata data
205     ) external returns (bytes4);
206 }
207 
208 
209 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
210 
211 
212 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
213 
214 pragma solidity ^0.8.0;
215 
216 /**
217  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
218  * @dev See https://eips.ethereum.org/EIPS/eip-721
219  */
220 interface IERC721Metadata is IERC721 {
221     /**
222      * @dev Returns the token collection name.
223      */
224     function name() external view returns (string memory);
225 
226     /**
227      * @dev Returns the token collection symbol.
228      */
229     function symbol() external view returns (string memory);
230 
231     /**
232      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
233      */
234     function tokenURI(uint256 tokenId) external view returns (string memory);
235 }
236 
237 
238 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
239 
240 
241 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
242 
243 pragma solidity ^0.8.1;
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      *
266      * [IMPORTANT]
267      * ====
268      * You shouldn't rely on `isContract` to protect against flash loan attacks!
269      *
270      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
271      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
272      * constructor.
273      * ====
274      */
275     function isContract(address account) internal view returns (bool) {
276         // This method relies on extcodesize/address.code.length, which returns 0
277         // for contracts in construction, since the code is only stored at the end
278         // of the constructor execution.
279 
280         return account.code.length > 0;
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      */
299     function sendValue(address payable recipient, uint256 amount) internal {
300         require(address(this).balance >= amount, "Address: insufficient balance");
301 
302         (bool success, ) = recipient.call{value: amount}("");
303         require(success, "Address: unable to send value, recipient may have reverted");
304     }
305 
306     /**
307      * @dev Performs a Solidity function call using a low level `call`. A
308      * plain `call` is an unsafe replacement for a function call: use this
309      * function instead.
310      *
311      * If `target` reverts with a revert reason, it is bubbled up by this
312      * function (like regular Solidity function calls).
313      *
314      * Returns the raw returned data. To convert to the expected return value,
315      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
316      *
317      * Requirements:
318      *
319      * - `target` must be a contract.
320      * - calling `target` with `data` must not revert.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
325         return functionCall(target, data, "Address: low-level call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
330      * `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, 0, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but also transferring `value` wei to `target`.
345      *
346      * Requirements:
347      *
348      * - the calling contract must have an ETH balance of at least `value`.
349      * - the called Solidity function must be `payable`.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(
354         address target,
355         bytes memory data,
356         uint256 value
357     ) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
363      * with `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(
368         address target,
369         bytes memory data,
370         uint256 value,
371         string memory errorMessage
372     ) internal returns (bytes memory) {
373         require(address(this).balance >= value, "Address: insufficient balance for call");
374         require(isContract(target), "Address: call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.call{value: value}(data);
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
387         return functionStaticCall(target, data, "Address: low-level static call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
392      * but performing a static call.
393      *
394      * _Available since v3.3._
395      */
396     function functionStaticCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal view returns (bytes memory) {
401         require(isContract(target), "Address: static call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.staticcall(data);
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
414         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
419      * but performing a delegate call.
420      *
421      * _Available since v3.4._
422      */
423     function functionDelegateCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         require(isContract(target), "Address: delegate call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.delegatecall(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
436      * revert reason using the provided one.
437      *
438      * _Available since v4.3._
439      */
440     function verifyCallResult(
441         bool success,
442         bytes memory returndata,
443         string memory errorMessage
444     ) internal pure returns (bytes memory) {
445         if (success) {
446             return returndata;
447         } else {
448             // Look for revert reason and bubble it up if present
449             if (returndata.length > 0) {
450                 // The easiest way to bubble the revert reason is using memory via assembly
451 
452                 assembly {
453                     let returndata_size := mload(returndata)
454                     revert(add(32, returndata), returndata_size)
455                 }
456             } else {
457                 revert(errorMessage);
458             }
459         }
460     }
461 }
462 
463 
464 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
465 
466 
467 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 /**
472  * @dev Provides information about the current execution context, including the
473  * sender of the transaction and its data. While these are generally available
474  * via msg.sender and msg.data, they should not be accessed in such a direct
475  * manner, since when dealing with meta-transactions the account sending and
476  * paying for execution may not be the actual sender (as far as an application
477  * is concerned).
478  *
479  * This contract is only required for intermediate, library-like contracts.
480  */
481 abstract contract Context {
482     function _msgSender() internal view virtual returns (address) {
483         return msg.sender;
484     }
485 
486     function _msgData() internal view virtual returns (bytes calldata) {
487         return msg.data;
488     }
489 }
490 
491 
492 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
493 
494 
495 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 /**
500  * @dev String operations.
501  */
502 library Strings {
503     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
504 
505     /**
506      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
507      */
508     function toString(uint256 value) internal pure returns (string memory) {
509         // Inspired by OraclizeAPI's implementation - MIT licence
510         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
511 
512         if (value == 0) {
513             return "0";
514         }
515         uint256 temp = value;
516         uint256 digits;
517         while (temp != 0) {
518             digits++;
519             temp /= 10;
520         }
521         bytes memory buffer = new bytes(digits);
522         while (value != 0) {
523             digits -= 1;
524             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
525             value /= 10;
526         }
527         return string(buffer);
528     }
529 
530     /**
531      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
532      */
533     function toHexString(uint256 value) internal pure returns (string memory) {
534         if (value == 0) {
535             return "0x00";
536         }
537         uint256 temp = value;
538         uint256 length = 0;
539         while (temp != 0) {
540             length++;
541             temp >>= 8;
542         }
543         return toHexString(value, length);
544     }
545 
546     /**
547      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
548      */
549     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
550         bytes memory buffer = new bytes(2 * length + 2);
551         buffer[0] = "0";
552         buffer[1] = "x";
553         for (uint256 i = 2 * length + 1; i > 1; --i) {
554             buffer[i] = _HEX_SYMBOLS[value & 0xf];
555             value >>= 4;
556         }
557         require(value == 0, "Strings: hex length insufficient");
558         return string(buffer);
559     }
560 }
561 
562 
563 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
564 
565 
566 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
567 
568 pragma solidity ^0.8.0;
569 
570 /**
571  * @dev Implementation of the {IERC165} interface.
572  *
573  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
574  * for the additional interface id that will be supported. For example:
575  *
576  * ```solidity
577  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
578  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
579  * }
580  * ```
581  *
582  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
583  */
584 abstract contract ERC165 is IERC165 {
585     /**
586      * @dev See {IERC165-supportsInterface}.
587      */
588     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
589         return interfaceId == type(IERC165).interfaceId;
590     }
591 }
592 
593 
594 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.5.0
595 
596 
597 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
598 
599 pragma solidity ^0.8.0;
600 
601 
602 
603 
604 
605 
606 
607 /**
608  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
609  * the Metadata extension, but not including the Enumerable extension, which is available separately as
610  * {ERC721Enumerable}.
611  */
612 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
613     using Address for address;
614     using Strings for uint256;
615 
616     // Token name
617     string private _name;
618 
619     // Token symbol
620     string private _symbol;
621 
622     // Mapping from token ID to owner address
623     mapping(uint256 => address) private _owners;
624 
625     // Mapping owner address to token count
626     mapping(address => uint256) private _balances;
627 
628     // Mapping from token ID to approved address
629     mapping(uint256 => address) private _tokenApprovals;
630 
631     // Mapping from owner to operator approvals
632     mapping(address => mapping(address => bool)) private _operatorApprovals;
633 
634     /**
635      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
636      */
637     constructor(string memory name_, string memory symbol_) {
638         _name = name_;
639         _symbol = symbol_;
640     }
641 
642     /**
643      * @dev See {IERC165-supportsInterface}.
644      */
645     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
646         return
647             interfaceId == type(IERC721).interfaceId ||
648             interfaceId == type(IERC721Metadata).interfaceId ||
649             super.supportsInterface(interfaceId);
650     }
651 
652     /**
653      * @dev See {IERC721-balanceOf}.
654      */
655     function balanceOf(address owner) public view virtual override returns (uint256) {
656         require(owner != address(0), "ERC721: balance query for the zero address");
657         return _balances[owner];
658     }
659 
660     /**
661      * @dev See {IERC721-ownerOf}.
662      */
663     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
664         address owner = _owners[tokenId];
665         require(owner != address(0), "ERC721: owner query for nonexistent token");
666         return owner;
667     }
668 
669     /**
670      * @dev See {IERC721Metadata-name}.
671      */
672     function name() public view virtual override returns (string memory) {
673         return _name;
674     }
675 
676     /**
677      * @dev See {IERC721Metadata-symbol}.
678      */
679     function symbol() public view virtual override returns (string memory) {
680         return _symbol;
681     }
682 
683     /**
684      * @dev See {IERC721Metadata-tokenURI}.
685      */
686     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
687         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
688 
689         string memory baseURI = _baseURI();
690         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
691     }
692 
693     /**
694      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
695      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
696      * by default, can be overriden in child contracts.
697      */
698     function _baseURI() internal view virtual returns (string memory) {
699         return "";
700     }
701 
702     /**
703      * @dev See {IERC721-approve}.
704      */
705     function approve(address to, uint256 tokenId) public virtual override {
706         address owner = ERC721.ownerOf(tokenId);
707         require(to != owner, "ERC721: approval to current owner");
708 
709         require(
710             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
711             "ERC721: approve caller is not owner nor approved for all"
712         );
713 
714         _approve(to, tokenId);
715     }
716 
717     /**
718      * @dev See {IERC721-getApproved}.
719      */
720     function getApproved(uint256 tokenId) public view virtual override returns (address) {
721         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
722 
723         return _tokenApprovals[tokenId];
724     }
725 
726     /**
727      * @dev See {IERC721-setApprovalForAll}.
728      */
729     function setApprovalForAll(address operator, bool approved) public virtual override {
730         _setApprovalForAll(_msgSender(), operator, approved);
731     }
732 
733     /**
734      * @dev See {IERC721-isApprovedForAll}.
735      */
736     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
737         return _operatorApprovals[owner][operator];
738     }
739 
740     /**
741      * @dev See {IERC721-transferFrom}.
742      */
743     function transferFrom(
744         address from,
745         address to,
746         uint256 tokenId
747     ) public virtual override {
748         //solhint-disable-next-line max-line-length
749         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
750 
751         _transfer(from, to, tokenId);
752     }
753 
754     /**
755      * @dev See {IERC721-safeTransferFrom}.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId
761     ) public virtual override {
762         safeTransferFrom(from, to, tokenId, "");
763     }
764 
765     /**
766      * @dev See {IERC721-safeTransferFrom}.
767      */
768     function safeTransferFrom(
769         address from,
770         address to,
771         uint256 tokenId,
772         bytes memory _data
773     ) public virtual override {
774         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
775         _safeTransfer(from, to, tokenId, _data);
776     }
777 
778     /**
779      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
780      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
781      *
782      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
783      *
784      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
785      * implement alternative mechanisms to perform token transfer, such as signature-based.
786      *
787      * Requirements:
788      *
789      * - `from` cannot be the zero address.
790      * - `to` cannot be the zero address.
791      * - `tokenId` token must exist and be owned by `from`.
792      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
793      *
794      * Emits a {Transfer} event.
795      */
796     function _safeTransfer(
797         address from,
798         address to,
799         uint256 tokenId,
800         bytes memory _data
801     ) internal virtual {
802         _transfer(from, to, tokenId);
803         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
804     }
805 
806     /**
807      * @dev Returns whether `tokenId` exists.
808      *
809      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
810      *
811      * Tokens start existing when they are minted (`_mint`),
812      * and stop existing when they are burned (`_burn`).
813      */
814     function _exists(uint256 tokenId) internal view virtual returns (bool) {
815         return _owners[tokenId] != address(0);
816     }
817 
818     /**
819      * @dev Returns whether `spender` is allowed to manage `tokenId`.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must exist.
824      */
825     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
826         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
827         address owner = ERC721.ownerOf(tokenId);
828         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
829     }
830 
831     /**
832      * @dev Safely mints `tokenId` and transfers it to `to`.
833      *
834      * Requirements:
835      *
836      * - `tokenId` must not exist.
837      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
838      *
839      * Emits a {Transfer} event.
840      */
841     function _safeMint(address to, uint256 tokenId) internal virtual {
842         _safeMint(to, tokenId, "");
843     }
844 
845     /**
846      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
847      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
848      */
849     function _safeMint(
850         address to,
851         uint256 tokenId,
852         bytes memory _data
853     ) internal virtual {
854         _mint(to, tokenId);
855         require(
856             _checkOnERC721Received(address(0), to, tokenId, _data),
857             "ERC721: transfer to non ERC721Receiver implementer"
858         );
859     }
860 
861     /**
862      * @dev Mints `tokenId` and transfers it to `to`.
863      *
864      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
865      *
866      * Requirements:
867      *
868      * - `tokenId` must not exist.
869      * - `to` cannot be the zero address.
870      *
871      * Emits a {Transfer} event.
872      */
873     function _mint(address to, uint256 tokenId) internal virtual {
874         require(to != address(0), "ERC721: mint to the zero address");
875         require(!_exists(tokenId), "ERC721: token already minted");
876 
877         _beforeTokenTransfer(address(0), to, tokenId);
878 
879         _balances[to] += 1;
880         _owners[tokenId] = to;
881 
882         emit Transfer(address(0), to, tokenId);
883 
884         _afterTokenTransfer(address(0), to, tokenId);
885     }
886 
887     /**
888      * @dev Destroys `tokenId`.
889      * The approval is cleared when the token is burned.
890      *
891      * Requirements:
892      *
893      * - `tokenId` must exist.
894      *
895      * Emits a {Transfer} event.
896      */
897     function _burn(uint256 tokenId) internal virtual {
898         address owner = ERC721.ownerOf(tokenId);
899 
900         _beforeTokenTransfer(owner, address(0), tokenId);
901 
902         // Clear approvals
903         _approve(address(0), tokenId);
904 
905         _balances[owner] -= 1;
906         delete _owners[tokenId];
907 
908         emit Transfer(owner, address(0), tokenId);
909 
910         _afterTokenTransfer(owner, address(0), tokenId);
911     }
912 
913     /**
914      * @dev Transfers `tokenId` from `from` to `to`.
915      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
916      *
917      * Requirements:
918      *
919      * - `to` cannot be the zero address.
920      * - `tokenId` token must be owned by `from`.
921      *
922      * Emits a {Transfer} event.
923      */
924     function _transfer(
925         address from,
926         address to,
927         uint256 tokenId
928     ) internal virtual {
929         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
930         require(to != address(0), "ERC721: transfer to the zero address");
931 
932         _beforeTokenTransfer(from, to, tokenId);
933 
934         // Clear approvals from the previous owner
935         _approve(address(0), tokenId);
936 
937         _balances[from] -= 1;
938         _balances[to] += 1;
939         _owners[tokenId] = to;
940 
941         emit Transfer(from, to, tokenId);
942 
943         _afterTokenTransfer(from, to, tokenId);
944     }
945 
946     /**
947      * @dev Approve `to` to operate on `tokenId`
948      *
949      * Emits a {Approval} event.
950      */
951     function _approve(address to, uint256 tokenId) internal virtual {
952         _tokenApprovals[tokenId] = to;
953         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
954     }
955 
956     /**
957      * @dev Approve `operator` to operate on all of `owner` tokens
958      *
959      * Emits a {ApprovalForAll} event.
960      */
961     function _setApprovalForAll(
962         address owner,
963         address operator,
964         bool approved
965     ) internal virtual {
966         require(owner != operator, "ERC721: approve to caller");
967         _operatorApprovals[owner][operator] = approved;
968         emit ApprovalForAll(owner, operator, approved);
969     }
970 
971     /**
972      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
973      * The call is not executed if the target address is not a contract.
974      *
975      * @param from address representing the previous owner of the given token ID
976      * @param to target address that will receive the tokens
977      * @param tokenId uint256 ID of the token to be transferred
978      * @param _data bytes optional data to send along with the call
979      * @return bool whether the call correctly returned the expected magic value
980      */
981     function _checkOnERC721Received(
982         address from,
983         address to,
984         uint256 tokenId,
985         bytes memory _data
986     ) private returns (bool) {
987         if (to.isContract()) {
988             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
989                 return retval == IERC721Receiver.onERC721Received.selector;
990             } catch (bytes memory reason) {
991                 if (reason.length == 0) {
992                     revert("ERC721: transfer to non ERC721Receiver implementer");
993                 } else {
994                     assembly {
995                         revert(add(32, reason), mload(reason))
996                     }
997                 }
998             }
999         } else {
1000             return true;
1001         }
1002     }
1003 
1004     /**
1005      * @dev Hook that is called before any token transfer. This includes minting
1006      * and burning.
1007      *
1008      * Calling conditions:
1009      *
1010      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1011      * transferred to `to`.
1012      * - When `from` is zero, `tokenId` will be minted for `to`.
1013      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1014      * - `from` and `to` are never both zero.
1015      *
1016      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1017      */
1018     function _beforeTokenTransfer(
1019         address from,
1020         address to,
1021         uint256 tokenId
1022     ) internal virtual {}
1023 
1024     /**
1025      * @dev Hook that is called after any transfer of tokens. This includes
1026      * minting and burning.
1027      *
1028      * Calling conditions:
1029      *
1030      * - when `from` and `to` are both non-zero.
1031      * - `from` and `to` are never both zero.
1032      *
1033      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1034      */
1035     function _afterTokenTransfer(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) internal virtual {}
1040 }
1041 
1042 
1043 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
1044 
1045 
1046 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1047 
1048 pragma solidity ^0.8.0;
1049 
1050 /**
1051  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1052  * @dev See https://eips.ethereum.org/EIPS/eip-721
1053  */
1054 interface IERC721Enumerable is IERC721 {
1055     /**
1056      * @dev Returns the total amount of tokens stored by the contract.
1057      */
1058     function totalSupply() external view returns (uint256);
1059 
1060     /**
1061      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1062      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1063      */
1064     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1065 
1066     /**
1067      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1068      * Use along with {totalSupply} to enumerate all tokens.
1069      */
1070     function tokenByIndex(uint256 index) external view returns (uint256);
1071 }
1072 
1073 
1074 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.5.0
1075 
1076 
1077 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1078 
1079 pragma solidity ^0.8.0;
1080 
1081 
1082 /**
1083  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1084  * enumerability of all the token ids in the contract as well as all token ids owned by each
1085  * account.
1086  */
1087 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1088     // Mapping from owner to list of owned token IDs
1089     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1090 
1091     // Mapping from token ID to index of the owner tokens list
1092     mapping(uint256 => uint256) private _ownedTokensIndex;
1093 
1094     // Array with all token ids, used for enumeration
1095     uint256[] private _allTokens;
1096 
1097     // Mapping from token id to position in the allTokens array
1098     mapping(uint256 => uint256) private _allTokensIndex;
1099 
1100     /**
1101      * @dev See {IERC165-supportsInterface}.
1102      */
1103     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1104         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1105     }
1106 
1107     /**
1108      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1109      */
1110     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1111         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1112         return _ownedTokens[owner][index];
1113     }
1114 
1115     /**
1116      * @dev See {IERC721Enumerable-totalSupply}.
1117      */
1118     function totalSupply() public view virtual override returns (uint256) {
1119         return _allTokens.length;
1120     }
1121 
1122     /**
1123      * @dev See {IERC721Enumerable-tokenByIndex}.
1124      */
1125     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1126         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1127         return _allTokens[index];
1128     }
1129 
1130     /**
1131      * @dev Hook that is called before any token transfer. This includes minting
1132      * and burning.
1133      *
1134      * Calling conditions:
1135      *
1136      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1137      * transferred to `to`.
1138      * - When `from` is zero, `tokenId` will be minted for `to`.
1139      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1140      * - `from` cannot be the zero address.
1141      * - `to` cannot be the zero address.
1142      *
1143      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1144      */
1145     function _beforeTokenTransfer(
1146         address from,
1147         address to,
1148         uint256 tokenId
1149     ) internal virtual override {
1150         super._beforeTokenTransfer(from, to, tokenId);
1151 
1152         if (from == address(0)) {
1153             _addTokenToAllTokensEnumeration(tokenId);
1154         } else if (from != to) {
1155             _removeTokenFromOwnerEnumeration(from, tokenId);
1156         }
1157         if (to == address(0)) {
1158             _removeTokenFromAllTokensEnumeration(tokenId);
1159         } else if (to != from) {
1160             _addTokenToOwnerEnumeration(to, tokenId);
1161         }
1162     }
1163 
1164     /**
1165      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1166      * @param to address representing the new owner of the given token ID
1167      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1168      */
1169     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1170         uint256 length = ERC721.balanceOf(to);
1171         _ownedTokens[to][length] = tokenId;
1172         _ownedTokensIndex[tokenId] = length;
1173     }
1174 
1175     /**
1176      * @dev Private function to add a token to this extension's token tracking data structures.
1177      * @param tokenId uint256 ID of the token to be added to the tokens list
1178      */
1179     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1180         _allTokensIndex[tokenId] = _allTokens.length;
1181         _allTokens.push(tokenId);
1182     }
1183 
1184     /**
1185      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1186      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1187      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1188      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1189      * @param from address representing the previous owner of the given token ID
1190      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1191      */
1192     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1193         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1194         // then delete the last slot (swap and pop).
1195 
1196         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1197         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1198 
1199         // When the token to delete is the last token, the swap operation is unnecessary
1200         if (tokenIndex != lastTokenIndex) {
1201             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1202 
1203             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1204             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1205         }
1206 
1207         // This also deletes the contents at the last position of the array
1208         delete _ownedTokensIndex[tokenId];
1209         delete _ownedTokens[from][lastTokenIndex];
1210     }
1211 
1212     /**
1213      * @dev Private function to remove a token from this extension's token tracking data structures.
1214      * This has O(1) time complexity, but alters the order of the _allTokens array.
1215      * @param tokenId uint256 ID of the token to be removed from the tokens list
1216      */
1217     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1218         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1219         // then delete the last slot (swap and pop).
1220 
1221         uint256 lastTokenIndex = _allTokens.length - 1;
1222         uint256 tokenIndex = _allTokensIndex[tokenId];
1223 
1224         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1225         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1226         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1227         uint256 lastTokenId = _allTokens[lastTokenIndex];
1228 
1229         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1230         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1231 
1232         // This also deletes the contents at the last position of the array
1233         delete _allTokensIndex[tokenId];
1234         _allTokens.pop();
1235     }
1236 }
1237 
1238 
1239 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1240 
1241 
1242 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1243 
1244 pragma solidity ^0.8.0;
1245 
1246 /**
1247  * @dev Contract module which provides a basic access control mechanism, where
1248  * there is an account (an owner) that can be granted exclusive access to
1249  * specific functions.
1250  *
1251  * By default, the owner account will be the one that deploys the contract. This
1252  * can later be changed with {transferOwnership}.
1253  *
1254  * This module is used through inheritance. It will make available the modifier
1255  * `onlyOwner`, which can be applied to your functions to restrict their use to
1256  * the owner.
1257  */
1258 abstract contract Ownable is Context {
1259     address private _owner;
1260 
1261     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1262 
1263     /**
1264      * @dev Initializes the contract setting the deployer as the initial owner.
1265      */
1266     constructor() {
1267         _transferOwnership(_msgSender());
1268     }
1269 
1270     /**
1271      * @dev Returns the address of the current owner.
1272      */
1273     function owner() public view virtual returns (address) {
1274         return _owner;
1275     }
1276 
1277     /**
1278      * @dev Throws if called by any account other than the owner.
1279      */
1280     modifier onlyOwner() {
1281         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1282         _;
1283     }
1284 
1285     /**
1286      * @dev Leaves the contract without owner. It will not be possible to call
1287      * `onlyOwner` functions anymore. Can only be called by the current owner.
1288      *
1289      * NOTE: Renouncing ownership will leave the contract without an owner,
1290      * thereby removing any functionality that is only available to the owner.
1291      */
1292     function renounceOwnership() public virtual onlyOwner {
1293         _transferOwnership(address(0));
1294     }
1295 
1296     /**
1297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1298      * Can only be called by the current owner.
1299      */
1300     function transferOwnership(address newOwner) public virtual onlyOwner {
1301         require(newOwner != address(0), "Ownable: new owner is the zero address");
1302         _transferOwnership(newOwner);
1303     }
1304 
1305     /**
1306      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1307      * Internal function without access restriction.
1308      */
1309     function _transferOwnership(address newOwner) internal virtual {
1310         address oldOwner = _owner;
1311         _owner = newOwner;
1312         emit OwnershipTransferred(oldOwner, newOwner);
1313     }
1314 }
1315 
1316 
1317 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
1318 
1319 
1320 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1321 
1322 pragma solidity ^0.8.0;
1323 
1324 /**
1325  * @dev Contract module that helps prevent reentrant calls to a function.
1326  *
1327  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1328  * available, which can be applied to functions to make sure there are no nested
1329  * (reentrant) calls to them.
1330  *
1331  * Note that because there is a single `nonReentrant` guard, functions marked as
1332  * `nonReentrant` may not call one another. This can be worked around by making
1333  * those functions `private`, and then adding `external` `nonReentrant` entry
1334  * points to them.
1335  *
1336  * TIP: If you would like to learn more about reentrancy and alternative ways
1337  * to protect against it, check out our blog post
1338  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1339  */
1340 abstract contract ReentrancyGuard {
1341     // Booleans are more expensive than uint256 or any type that takes up a full
1342     // word because each write operation emits an extra SLOAD to first read the
1343     // slot's contents, replace the bits taken up by the boolean, and then write
1344     // back. This is the compiler's defense against contract upgrades and
1345     // pointer aliasing, and it cannot be disabled.
1346 
1347     // The values being non-zero value makes deployment a bit more expensive,
1348     // but in exchange the refund on every call to nonReentrant will be lower in
1349     // amount. Since refunds are capped to a percentage of the total
1350     // transaction's gas, it is best to keep them low in cases like this one, to
1351     // increase the likelihood of the full refund coming into effect.
1352     uint256 private constant _NOT_ENTERED = 1;
1353     uint256 private constant _ENTERED = 2;
1354 
1355     uint256 private _status;
1356 
1357     constructor() {
1358         _status = _NOT_ENTERED;
1359     }
1360 
1361     /**
1362      * @dev Prevents a contract from calling itself, directly or indirectly.
1363      * Calling a `nonReentrant` function from another `nonReentrant`
1364      * function is not supported. It is possible to prevent this from happening
1365      * by making the `nonReentrant` function external, and making it call a
1366      * `private` function that does the actual work.
1367      */
1368     modifier nonReentrant() {
1369         // On the first call to nonReentrant, _notEntered will be true
1370         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1371 
1372         // Any calls to nonReentrant after this point will fail
1373         _status = _ENTERED;
1374 
1375         _;
1376 
1377         // By storing the original value once again, a refund is triggered (see
1378         // https://eips.ethereum.org/EIPS/eip-2200)
1379         _status = _NOT_ENTERED;
1380     }
1381 }
1382 
1383 
1384 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
1385 
1386 
1387 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1388 
1389 pragma solidity ^0.8.0;
1390 
1391 /**
1392  * @dev These functions deal with verification of Merkle Trees proofs.
1393  *
1394  * The proofs can be generated using the JavaScript library
1395  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1396  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1397  *
1398  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1399  */
1400 library MerkleProof {
1401     /**
1402      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1403      * defined by `root`. For this, a `proof` must be provided, containing
1404      * sibling hashes on the branch from the leaf to the root of the tree. Each
1405      * pair of leaves and each pair of pre-images are assumed to be sorted.
1406      */
1407     function verify(
1408         bytes32[] memory proof,
1409         bytes32 root,
1410         bytes32 leaf
1411     ) internal pure returns (bool) {
1412         return processProof(proof, leaf) == root;
1413     }
1414 
1415     /**
1416      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1417      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1418      * hash matches the root of the tree. When processing the proof, the pairs
1419      * of leafs & pre-images are assumed to be sorted.
1420      *
1421      * _Available since v4.4._
1422      */
1423     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1424         bytes32 computedHash = leaf;
1425         for (uint256 i = 0; i < proof.length; i++) {
1426             bytes32 proofElement = proof[i];
1427             if (computedHash <= proofElement) {
1428                 // Hash(current computed hash + current element of the proof)
1429                 computedHash = _efficientHash(computedHash, proofElement);
1430             } else {
1431                 // Hash(current element of the proof + current computed hash)
1432                 computedHash = _efficientHash(proofElement, computedHash);
1433             }
1434         }
1435         return computedHash;
1436     }
1437 
1438     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1439         assembly {
1440             mstore(0x00, a)
1441             mstore(0x20, b)
1442             value := keccak256(0x00, 0x40)
1443         }
1444     }
1445 }
1446 
1447 
1448 // File erc721a/contracts/ERC721A.sol@v3.2.0
1449 
1450 
1451 // Creator: Chiru Labs
1452 
1453 pragma solidity ^0.8.4;
1454 
1455 
1456 
1457 
1458 
1459 
1460 
1461 error ApprovalCallerNotOwnerNorApproved();
1462 error ApprovalQueryForNonexistentToken();
1463 error ApproveToCaller();
1464 error ApprovalToCurrentOwner();
1465 error BalanceQueryForZeroAddress();
1466 error MintToZeroAddress();
1467 error MintZeroQuantity();
1468 error OwnerQueryForNonexistentToken();
1469 error TransferCallerNotOwnerNorApproved();
1470 error TransferFromIncorrectOwner();
1471 error TransferToNonERC721ReceiverImplementer();
1472 error TransferToZeroAddress();
1473 error URIQueryForNonexistentToken();
1474 
1475 /**
1476  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1477  * the Metadata extension. Built to optimize for lower gas during batch mints.
1478  *
1479  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1480  *
1481  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1482  *
1483  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1484  */
1485 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1486     using Address for address;
1487     using Strings for uint256;
1488 
1489     // Compiler will pack this into a single 256bit word.
1490     struct TokenOwnership {
1491         // The address of the owner.
1492         address addr;
1493         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1494         uint64 startTimestamp;
1495         // Whether the token has been burned.
1496         bool burned;
1497     }
1498 
1499     // Compiler will pack this into a single 256bit word.
1500     struct AddressData {
1501         // Realistically, 2**64-1 is more than enough.
1502         uint64 balance;
1503         // Keeps track of mint count with minimal overhead for tokenomics.
1504         uint64 numberMinted;
1505         // Keeps track of burn count with minimal overhead for tokenomics.
1506         uint64 numberBurned;
1507         // For miscellaneous variable(s) pertaining to the address
1508         // (e.g. number of whitelist mint slots used).
1509         // If there are multiple variables, please pack them into a uint64.
1510         uint64 aux;
1511     }
1512 
1513     // The tokenId of the next token to be minted.
1514     uint256 internal _currentIndex;
1515 
1516     // The number of tokens burned.
1517     uint256 internal _burnCounter;
1518 
1519     // Token name
1520     string private _name;
1521 
1522     // Token symbol
1523     string private _symbol;
1524 
1525     // Mapping from token ID to ownership details
1526     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1527     mapping(uint256 => TokenOwnership) internal _ownerships;
1528 
1529     // Mapping owner address to address data
1530     mapping(address => AddressData) private _addressData;
1531 
1532     // Mapping from token ID to approved address
1533     mapping(uint256 => address) private _tokenApprovals;
1534 
1535     // Mapping from owner to operator approvals
1536     mapping(address => mapping(address => bool)) private _operatorApprovals;
1537 
1538     constructor(string memory name_, string memory symbol_) {
1539         _name = name_;
1540         _symbol = symbol_;
1541         _currentIndex = _startTokenId();
1542     }
1543 
1544     /**
1545      * To change the starting tokenId, please override this function.
1546      */
1547     function _startTokenId() internal view virtual returns (uint256) {
1548         return 0;
1549     }
1550 
1551     /**
1552      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1553      */
1554     function totalSupply() public view returns (uint256) {
1555         // Counter underflow is impossible as _burnCounter cannot be incremented
1556         // more than _currentIndex - _startTokenId() times
1557         unchecked {
1558             return _currentIndex - _burnCounter - _startTokenId();
1559         }
1560     }
1561 
1562     /**
1563      * Returns the total amount of tokens minted in the contract.
1564      */
1565     function _totalMinted() internal view returns (uint256) {
1566         // Counter underflow is impossible as _currentIndex does not decrement,
1567         // and it is initialized to _startTokenId()
1568         unchecked {
1569             return _currentIndex - _startTokenId();
1570         }
1571     }
1572 
1573     /**
1574      * @dev See {IERC165-supportsInterface}.
1575      */
1576     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1577         return
1578             interfaceId == type(IERC721).interfaceId ||
1579             interfaceId == type(IERC721Metadata).interfaceId ||
1580             super.supportsInterface(interfaceId);
1581     }
1582 
1583     /**
1584      * @dev See {IERC721-balanceOf}.
1585      */
1586     function balanceOf(address owner) public view override returns (uint256) {
1587         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1588         return uint256(_addressData[owner].balance);
1589     }
1590 
1591     /**
1592      * Returns the number of tokens minted by `owner`.
1593      */
1594     function _numberMinted(address owner) internal view returns (uint256) {
1595         return uint256(_addressData[owner].numberMinted);
1596     }
1597 
1598     /**
1599      * Returns the number of tokens burned by or on behalf of `owner`.
1600      */
1601     function _numberBurned(address owner) internal view returns (uint256) {
1602         return uint256(_addressData[owner].numberBurned);
1603     }
1604 
1605     /**
1606      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1607      */
1608     function _getAux(address owner) internal view returns (uint64) {
1609         return _addressData[owner].aux;
1610     }
1611 
1612     /**
1613      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1614      * If there are multiple variables, please pack them into a uint64.
1615      */
1616     function _setAux(address owner, uint64 aux) internal {
1617         _addressData[owner].aux = aux;
1618     }
1619 
1620     /**
1621      * Gas spent here starts off proportional to the maximum mint batch size.
1622      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1623      */
1624     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1625         uint256 curr = tokenId;
1626 
1627         unchecked {
1628             if (_startTokenId() <= curr && curr < _currentIndex) {
1629                 TokenOwnership memory ownership = _ownerships[curr];
1630                 if (!ownership.burned) {
1631                     if (ownership.addr != address(0)) {
1632                         return ownership;
1633                     }
1634                     // Invariant:
1635                     // There will always be an ownership that has an address and is not burned
1636                     // before an ownership that does not have an address and is not burned.
1637                     // Hence, curr will not underflow.
1638                     while (true) {
1639                         curr--;
1640                         ownership = _ownerships[curr];
1641                         if (ownership.addr != address(0)) {
1642                             return ownership;
1643                         }
1644                     }
1645                 }
1646             }
1647         }
1648         revert OwnerQueryForNonexistentToken();
1649     }
1650 
1651     /**
1652      * @dev See {IERC721-ownerOf}.
1653      */
1654     function ownerOf(uint256 tokenId) public view override returns (address) {
1655         return _ownershipOf(tokenId).addr;
1656     }
1657 
1658     /**
1659      * @dev See {IERC721Metadata-name}.
1660      */
1661     function name() public view virtual override returns (string memory) {
1662         return _name;
1663     }
1664 
1665     /**
1666      * @dev See {IERC721Metadata-symbol}.
1667      */
1668     function symbol() public view virtual override returns (string memory) {
1669         return _symbol;
1670     }
1671 
1672     /**
1673      * @dev See {IERC721Metadata-tokenURI}.
1674      */
1675     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1676         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1677 
1678         string memory baseURI = _baseURI();
1679         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1680     }
1681 
1682     /**
1683      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1684      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1685      * by default, can be overriden in child contracts.
1686      */
1687     function _baseURI() internal view virtual returns (string memory) {
1688         return '';
1689     }
1690 
1691     /**
1692      * @dev See {IERC721-approve}.
1693      */
1694     function approve(address to, uint256 tokenId) public override {
1695         address owner = ERC721A.ownerOf(tokenId);
1696         if (to == owner) revert ApprovalToCurrentOwner();
1697 
1698         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1699             revert ApprovalCallerNotOwnerNorApproved();
1700         }
1701 
1702         _approve(to, tokenId, owner);
1703     }
1704 
1705     /**
1706      * @dev See {IERC721-getApproved}.
1707      */
1708     function getApproved(uint256 tokenId) public view override returns (address) {
1709         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1710 
1711         return _tokenApprovals[tokenId];
1712     }
1713 
1714     /**
1715      * @dev See {IERC721-setApprovalForAll}.
1716      */
1717     function setApprovalForAll(address operator, bool approved) public virtual override {
1718         if (operator == _msgSender()) revert ApproveToCaller();
1719 
1720         _operatorApprovals[_msgSender()][operator] = approved;
1721         emit ApprovalForAll(_msgSender(), operator, approved);
1722     }
1723 
1724     /**
1725      * @dev See {IERC721-isApprovedForAll}.
1726      */
1727     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1728         return _operatorApprovals[owner][operator];
1729     }
1730 
1731     /**
1732      * @dev See {IERC721-transferFrom}.
1733      */
1734     function transferFrom(
1735         address from,
1736         address to,
1737         uint256 tokenId
1738     ) public virtual override {
1739         _transfer(from, to, tokenId);
1740     }
1741 
1742     /**
1743      * @dev See {IERC721-safeTransferFrom}.
1744      */
1745     function safeTransferFrom(
1746         address from,
1747         address to,
1748         uint256 tokenId
1749     ) public virtual override {
1750         safeTransferFrom(from, to, tokenId, '');
1751     }
1752 
1753     /**
1754      * @dev See {IERC721-safeTransferFrom}.
1755      */
1756     function safeTransferFrom(
1757         address from,
1758         address to,
1759         uint256 tokenId,
1760         bytes memory _data
1761     ) public virtual override {
1762         _transfer(from, to, tokenId);
1763         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1764             revert TransferToNonERC721ReceiverImplementer();
1765         }
1766     }
1767 
1768     /**
1769      * @dev Returns whether `tokenId` exists.
1770      *
1771      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1772      *
1773      * Tokens start existing when they are minted (`_mint`),
1774      */
1775     function _exists(uint256 tokenId) internal view returns (bool) {
1776         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1777     }
1778 
1779     function _safeMint(address to, uint256 quantity) internal {
1780         _safeMint(to, quantity, '');
1781     }
1782 
1783     /**
1784      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1785      *
1786      * Requirements:
1787      *
1788      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1789      * - `quantity` must be greater than 0.
1790      *
1791      * Emits a {Transfer} event.
1792      */
1793     function _safeMint(
1794         address to,
1795         uint256 quantity,
1796         bytes memory _data
1797     ) internal {
1798         _mint(to, quantity, _data, true);
1799     }
1800 
1801     /**
1802      * @dev Mints `quantity` tokens and transfers them to `to`.
1803      *
1804      * Requirements:
1805      *
1806      * - `to` cannot be the zero address.
1807      * - `quantity` must be greater than 0.
1808      *
1809      * Emits a {Transfer} event.
1810      */
1811     function _mint(
1812         address to,
1813         uint256 quantity,
1814         bytes memory _data,
1815         bool safe
1816     ) internal {
1817         uint256 startTokenId = _currentIndex;
1818         if (to == address(0)) revert MintToZeroAddress();
1819         if (quantity == 0) revert MintZeroQuantity();
1820 
1821         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1822 
1823         // Overflows are incredibly unrealistic.
1824         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1825         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1826         unchecked {
1827             _addressData[to].balance += uint64(quantity);
1828             _addressData[to].numberMinted += uint64(quantity);
1829 
1830             _ownerships[startTokenId].addr = to;
1831             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1832 
1833             uint256 updatedIndex = startTokenId;
1834             uint256 end = updatedIndex + quantity;
1835 
1836             if (safe && to.isContract()) {
1837                 do {
1838                     emit Transfer(address(0), to, updatedIndex);
1839                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1840                         revert TransferToNonERC721ReceiverImplementer();
1841                     }
1842                 } while (updatedIndex != end);
1843                 // Reentrancy protection
1844                 if (_currentIndex != startTokenId) revert();
1845             } else {
1846                 do {
1847                     emit Transfer(address(0), to, updatedIndex++);
1848                 } while (updatedIndex != end);
1849             }
1850             _currentIndex = updatedIndex;
1851         }
1852         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1853     }
1854 
1855     /**
1856      * @dev Transfers `tokenId` from `from` to `to`.
1857      *
1858      * Requirements:
1859      *
1860      * - `to` cannot be the zero address.
1861      * - `tokenId` token must be owned by `from`.
1862      *
1863      * Emits a {Transfer} event.
1864      */
1865     function _transfer(
1866         address from,
1867         address to,
1868         uint256 tokenId
1869     ) private {
1870         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1871 
1872         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1873 
1874         bool isApprovedOrOwner = (_msgSender() == from ||
1875             isApprovedForAll(from, _msgSender()) ||
1876             getApproved(tokenId) == _msgSender());
1877 
1878         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1879         if (to == address(0)) revert TransferToZeroAddress();
1880 
1881         _beforeTokenTransfers(from, to, tokenId, 1);
1882 
1883         // Clear approvals from the previous owner
1884         _approve(address(0), tokenId, from);
1885 
1886         // Underflow of the sender's balance is impossible because we check for
1887         // ownership above and the recipient's balance can't realistically overflow.
1888         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1889         unchecked {
1890             _addressData[from].balance -= 1;
1891             _addressData[to].balance += 1;
1892 
1893             TokenOwnership storage currSlot = _ownerships[tokenId];
1894             currSlot.addr = to;
1895             currSlot.startTimestamp = uint64(block.timestamp);
1896 
1897             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1898             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1899             uint256 nextTokenId = tokenId + 1;
1900             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1901             if (nextSlot.addr == address(0)) {
1902                 // This will suffice for checking _exists(nextTokenId),
1903                 // as a burned slot cannot contain the zero address.
1904                 if (nextTokenId != _currentIndex) {
1905                     nextSlot.addr = from;
1906                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1907                 }
1908             }
1909         }
1910 
1911         emit Transfer(from, to, tokenId);
1912         _afterTokenTransfers(from, to, tokenId, 1);
1913     }
1914 
1915     /**
1916      * @dev This is equivalent to _burn(tokenId, false)
1917      */
1918     function _burn(uint256 tokenId) internal virtual {
1919         _burn(tokenId, false);
1920     }
1921 
1922     /**
1923      * @dev Destroys `tokenId`.
1924      * The approval is cleared when the token is burned.
1925      *
1926      * Requirements:
1927      *
1928      * - `tokenId` must exist.
1929      *
1930      * Emits a {Transfer} event.
1931      */
1932     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1933         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1934 
1935         address from = prevOwnership.addr;
1936 
1937         if (approvalCheck) {
1938             bool isApprovedOrOwner = (_msgSender() == from ||
1939                 isApprovedForAll(from, _msgSender()) ||
1940                 getApproved(tokenId) == _msgSender());
1941 
1942             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1943         }
1944 
1945         _beforeTokenTransfers(from, address(0), tokenId, 1);
1946 
1947         // Clear approvals from the previous owner
1948         _approve(address(0), tokenId, from);
1949 
1950         // Underflow of the sender's balance is impossible because we check for
1951         // ownership above and the recipient's balance can't realistically overflow.
1952         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1953         unchecked {
1954             AddressData storage addressData = _addressData[from];
1955             addressData.balance -= 1;
1956             addressData.numberBurned += 1;
1957 
1958             // Keep track of who burned the token, and the timestamp of burning.
1959             TokenOwnership storage currSlot = _ownerships[tokenId];
1960             currSlot.addr = from;
1961             currSlot.startTimestamp = uint64(block.timestamp);
1962             currSlot.burned = true;
1963 
1964             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1965             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1966             uint256 nextTokenId = tokenId + 1;
1967             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1968             if (nextSlot.addr == address(0)) {
1969                 // This will suffice for checking _exists(nextTokenId),
1970                 // as a burned slot cannot contain the zero address.
1971                 if (nextTokenId != _currentIndex) {
1972                     nextSlot.addr = from;
1973                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1974                 }
1975             }
1976         }
1977 
1978         emit Transfer(from, address(0), tokenId);
1979         _afterTokenTransfers(from, address(0), tokenId, 1);
1980 
1981         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1982         unchecked {
1983             _burnCounter++;
1984         }
1985     }
1986 
1987     /**
1988      * @dev Approve `to` to operate on `tokenId`
1989      *
1990      * Emits a {Approval} event.
1991      */
1992     function _approve(
1993         address to,
1994         uint256 tokenId,
1995         address owner
1996     ) private {
1997         _tokenApprovals[tokenId] = to;
1998         emit Approval(owner, to, tokenId);
1999     }
2000 
2001     /**
2002      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2003      *
2004      * @param from address representing the previous owner of the given token ID
2005      * @param to target address that will receive the tokens
2006      * @param tokenId uint256 ID of the token to be transferred
2007      * @param _data bytes optional data to send along with the call
2008      * @return bool whether the call correctly returned the expected magic value
2009      */
2010     function _checkContractOnERC721Received(
2011         address from,
2012         address to,
2013         uint256 tokenId,
2014         bytes memory _data
2015     ) private returns (bool) {
2016         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2017             return retval == IERC721Receiver(to).onERC721Received.selector;
2018         } catch (bytes memory reason) {
2019             if (reason.length == 0) {
2020                 revert TransferToNonERC721ReceiverImplementer();
2021             } else {
2022                 assembly {
2023                     revert(add(32, reason), mload(reason))
2024                 }
2025             }
2026         }
2027     }
2028 
2029     /**
2030      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2031      * And also called before burning one token.
2032      *
2033      * startTokenId - the first token id to be transferred
2034      * quantity - the amount to be transferred
2035      *
2036      * Calling conditions:
2037      *
2038      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2039      * transferred to `to`.
2040      * - When `from` is zero, `tokenId` will be minted for `to`.
2041      * - When `to` is zero, `tokenId` will be burned by `from`.
2042      * - `from` and `to` are never both zero.
2043      */
2044     function _beforeTokenTransfers(
2045         address from,
2046         address to,
2047         uint256 startTokenId,
2048         uint256 quantity
2049     ) internal virtual {}
2050 
2051     /**
2052      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2053      * minting.
2054      * And also called after one token has been burned.
2055      *
2056      * startTokenId - the first token id to be transferred
2057      * quantity - the amount to be transferred
2058      *
2059      * Calling conditions:
2060      *
2061      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2062      * transferred to `to`.
2063      * - When `from` is zero, `tokenId` has been minted for `to`.
2064      * - When `to` is zero, `tokenId` has been burned by `from`.
2065      * - `from` and `to` are never both zero.
2066      */
2067     function _afterTokenTransfers(
2068         address from,
2069         address to,
2070         uint256 startTokenId,
2071         uint256 quantity
2072     ) internal virtual {}
2073 }
2074 
2075 
2076 // File contracts/DopersA.sol
2077 
2078 pragma solidity ^0.8.9;
2079 
2080 
2081 
2082 
2083 
2084 
2085 contract DopersA is ERC721A, Ownable, ReentrancyGuard {
2086   /***** Enums *****/
2087   enum SalesEnum {
2088     INACTIVE,
2089     INVESTORS,
2090     DOPELIST,
2091     PUBLIC
2092   }
2093 
2094   /***** States *****/
2095   string public dopeProvenance;
2096 
2097   uint256 public constant MAX_SUPPLY = 10000;
2098   uint256 public constant DOPE_INVESTORS_MINT_AMOUNT = 1000;
2099   uint256 public constant DOPE_FRIENDS_MINT_AMOUNT = 5;
2100   uint256 public constant PRIMARY_DOPELIST_MINT_AMOUNT = 3;
2101   uint256 public constant SECONDARY_DOPELIST_MINT_AMOUNT = 2;
2102   uint256 public constant PUBLIC_MINT_AMOUNT = 10;
2103 
2104   string private _baseDopeURI;
2105   mapping(address => uint256) private _addressMintCount;
2106 
2107   /* DOPELIST */
2108   bytes32 public dopeInvestorsMR;
2109   bytes32 public dopeFriendsMR;
2110   bytes32 public primaryDopelistMR;
2111   bytes32 public secondaryDopelistMR;
2112 
2113   uint256 public priceDopeInvestors = 0.1 ether;
2114   uint256 public priceDopeFriends = 0.1 ether;
2115   uint256 public pricePrimaryDopelist = 0.1 ether;
2116   uint256 public priceSecondaryDopelist = 0.1 ether;
2117   uint256 public pricePublic = 0.15 ether;
2118 
2119   SalesEnum public salesPeriod;
2120 
2121   /***** Modifiers *****/
2122 
2123   modifier callerIsUser() {
2124     /* solhint-disable avoid-tx-origin */
2125     // for only call eoa
2126     require(tx.origin == _msgSender(), "The caller isn't a user");
2127     _;
2128   }
2129 
2130   /***** Functions *****/
2131 
2132   constructor() ERC721A("Dope", "DOPE") {
2133     salesPeriod = SalesEnum.INACTIVE;
2134   }
2135 
2136   function _baseURI() internal view virtual override returns (string memory) {
2137     return _baseDopeURI;
2138   }
2139 
2140   /*************
2141    * Configuration *
2142    *************/
2143 
2144   function setBaseURI(string calldata baseURI) external onlyOwner {
2145     _baseDopeURI = baseURI;
2146   }
2147 
2148   /*************
2149    * Provenance Hash *
2150    *************/
2151   function setProvenance(string calldata provenance) external onlyOwner {
2152     dopeProvenance = provenance;
2153   }
2154 
2155   /*************
2156    * Ownership *
2157    *************/
2158 
2159   function withdraw() external onlyOwner nonReentrant {
2160     payable(_msgSender()).transfer(address(this).balance);
2161   }
2162 
2163   function gift(address giftReceiver, uint256 amount) external onlyOwner {
2164     require(totalSupply() + amount <= MAX_SUPPLY, "exceeds max supply");
2165 
2166     _safeMint(giftReceiver, amount);
2167   }
2168 
2169   function teamReserve(uint256 amount) external onlyOwner {
2170     require(totalSupply() + amount <= MAX_SUPPLY, "exceeds max supply");
2171 
2172     _safeMint(_msgSender(), amount);
2173   }
2174 
2175   function transferPrepaidInvestors(address investorAddress, uint256 amount) external onlyOwner {
2176     require(totalSupply() + amount <= MAX_SUPPLY, "exceeds max supply");
2177 
2178     _safeMint(investorAddress, amount);
2179   }
2180 
2181   function beginInvestorSale() external onlyOwner {
2182     salesPeriod = SalesEnum.INVESTORS;
2183   }
2184 
2185   function beginDopelistSale() external onlyOwner {
2186     salesPeriod = SalesEnum.DOPELIST;
2187   }
2188 
2189   function beginPublicSale() external onlyOwner {
2190     salesPeriod = SalesEnum.PUBLIC;
2191   }
2192 
2193   function endSale() external onlyOwner {
2194     salesPeriod = SalesEnum.INACTIVE;
2195   }
2196 
2197   /*************
2198    * Mint *
2199    *************/
2200 
2201   function mintDopeInvestors(bytes32[] calldata proof, uint256 amount)
2202     external
2203     payable
2204     callerIsUser
2205   {
2206     require(salesPeriod == SalesEnum.INVESTORS, "sale not started");
2207     require(isDopeInvestors(_msgSender(), proof), "not a dope investor");
2208     require(
2209       _addressMintCount[_msgSender()] + amount <= DOPE_INVESTORS_MINT_AMOUNT,
2210       "Can only mint maximum 100"
2211     );
2212     require(totalSupply() + amount <= MAX_SUPPLY, "exceed max supply.");
2213 
2214     _addressMintCount[_msgSender()] += amount;
2215     _safeMint(_msgSender(), amount);
2216 
2217     refundIfOver(priceDopeInvestors * amount);
2218   }
2219 
2220   function mintDopeFriends(bytes32[] calldata proof, uint256 amount)
2221     external
2222     payable
2223     callerIsUser
2224   {
2225     require(salesPeriod == SalesEnum.DOPELIST, "sale not started");
2226     require(isDopeFriends(_msgSender(), proof), "not a dope friend.");
2227     require(
2228       _addressMintCount[_msgSender()] + amount <= DOPE_FRIENDS_MINT_AMOUNT,
2229       "Can only mint maximum 5"
2230     );
2231     require(totalSupply() + amount <= MAX_SUPPLY, "exceeds max supply.");
2232 
2233     _addressMintCount[_msgSender()] += amount;
2234     _safeMint(_msgSender(), amount);
2235 
2236     refundIfOver(priceDopeFriends * amount);
2237   }
2238 
2239   function mintPrimaryDopelist(bytes32[] calldata proof, uint256 amount)
2240     external
2241     payable
2242     callerIsUser
2243   {
2244     require(salesPeriod == SalesEnum.DOPELIST, "sale not started");
2245     require(
2246       isPrimaryDopelisted(_msgSender(), proof),
2247       "not a primary dope lister."
2248     );
2249     require(
2250       _addressMintCount[_msgSender()] + amount <= PRIMARY_DOPELIST_MINT_AMOUNT,
2251       "Can only mint maximum 3"
2252     );
2253     require(totalSupply() + amount <= MAX_SUPPLY, "exceeds max supply.");
2254 
2255     _addressMintCount[_msgSender()] += amount;
2256     _safeMint(_msgSender(), amount);
2257 
2258     refundIfOver(pricePrimaryDopelist * amount);
2259   }
2260 
2261   function mintSecondaryDopelist(bytes32[] calldata proof, uint256 amount)
2262     external
2263     payable
2264     callerIsUser
2265   {
2266     require(salesPeriod == SalesEnum.DOPELIST, "sale not started");
2267     require(isSecondaryDopelisted(_msgSender(), proof), "not a secondary dope lister.");
2268     require(
2269       _addressMintCount[_msgSender()] + amount <= SECONDARY_DOPELIST_MINT_AMOUNT,
2270       "Can only mint maximum 2"
2271     );
2272     require(totalSupply() + amount <= MAX_SUPPLY, "exceeds max supply.");
2273 
2274     _addressMintCount[_msgSender()] += amount;
2275     _safeMint(_msgSender(), amount);
2276 
2277     refundIfOver(priceSecondaryDopelist * amount);
2278   }
2279 
2280   function mintPublic(uint256 amount) external payable callerIsUser {
2281     require(salesPeriod == SalesEnum.PUBLIC, "sale not started");
2282     require(totalSupply() + amount <= MAX_SUPPLY, "exceeds max supply.");
2283     require(amount <= PUBLIC_MINT_AMOUNT, "Can't mint more than 10");
2284 
2285     _safeMint(_msgSender(), amount);
2286 
2287     refundIfOver(pricePublic * amount);
2288   }
2289 
2290   /*************
2291    * DOPELIST (Merkle Proof) *
2292    *************/
2293 
2294   /* Setter */
2295 
2296   function setDopeInvestorsMR(bytes32 merkleRoot) external onlyOwner {
2297     dopeInvestorsMR = merkleRoot;
2298   }
2299 
2300   function setDopeFriendsMR(bytes32 merkleRoot) external onlyOwner {
2301     dopeFriendsMR = merkleRoot;
2302   }
2303 
2304   function setPrimaryDopelistMR(bytes32 merkleRoot) external onlyOwner {
2305     primaryDopelistMR = merkleRoot;
2306   }
2307 
2308   function setSecondaryDopelistMR(bytes32 merkleRoot) external onlyOwner {
2309     secondaryDopelistMR = merkleRoot;
2310   }
2311 
2312   /* Verifier */
2313 
2314   function isDopeInvestors(address account, bytes32[] calldata proof)
2315     internal
2316     view
2317     returns (bool)
2318   {
2319     return MerkleProof.verify(proof, dopeInvestorsMR, merkleLeaf(account));
2320   }
2321 
2322   function isDopeFriends(address account, bytes32[] calldata proof)
2323     internal
2324     view
2325     returns (bool)
2326   {
2327     return MerkleProof.verify(proof, dopeFriendsMR, merkleLeaf(account));
2328   }
2329 
2330   function isPrimaryDopelisted(address account, bytes32[] calldata proof)
2331     internal
2332     view
2333     returns (bool)
2334   {
2335     return MerkleProof.verify(proof, primaryDopelistMR, merkleLeaf(account));
2336   }
2337 
2338   function isSecondaryDopelisted(address account, bytes32[] calldata proof)
2339     internal
2340     view
2341     returns (bool)
2342   {
2343     return MerkleProof.verify(proof, secondaryDopelistMR, merkleLeaf(account));
2344   }
2345 
2346   /* Utils */
2347 
2348   function merkleLeaf(address account) private pure returns (bytes32) {
2349     return keccak256(abi.encodePacked(account));
2350   }
2351 
2352   function refundIfOver(uint256 price) private {
2353     require(msg.value >= price, "Need to send more ETH.");
2354     if (msg.value > price) {
2355       payable(_msgSender()).transfer(msg.value - price);
2356     }
2357   }
2358 
2359   function getOwnershipData(uint256 tokenId)
2360     external
2361     view
2362     returns (TokenOwnership memory)
2363   {
2364     return _ownershipOf(tokenId);
2365   }
2366 
2367   function numberMinted(address owner) public view returns (uint256) {
2368     return _numberMinted(owner);
2369   }
2370 }