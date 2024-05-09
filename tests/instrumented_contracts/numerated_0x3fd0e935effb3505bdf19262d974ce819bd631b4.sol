1 // SPDX-License-Identifier: MIT
2 
3 // Amended by HashLips
4 /**
5     !Disclaimer!
6 
7     These contracts have been used to create tutorials,
8     and was created for the purpose to teach people
9     how to create smart contracts on the blockchain.
10     please review this code on your own before using any of
11     the following code for production.
12     The developer will not be responsible or liable for all loss or 
13     damage whatsoever caused by you participating in any way in the 
14     experimental code, whether putting money into the contract or 
15     using the code for your own project.
16 */
17 
18 
19 
20 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @title ERC721 token receiver interface
26  * @dev Interface for any contract that wants to support safeTransfers
27  * from ERC721 asset contracts.
28  */
29 interface IERC721Receiver {
30     /**
31      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
32      * by `operator` from `from`, this function is called.
33      *
34      * It must return its Solidity selector to confirm the token transfer.
35      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
36      *
37      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
38      */
39     function onERC721Received(
40         address operator,
41         address from,
42         uint256 tokenId,
43         bytes calldata data
44     ) external returns (bytes4);
45 }
46 
47 
48 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
49 
50 pragma solidity ^0.8.0;
51 
52 /**
53  * @dev Collection of functions related to the address type
54  */
55 library Address {
56     /**
57      * @dev Returns true if `account` is a contract.
58      *
59      * [IMPORTANT]
60      * ====
61      * It is unsafe to assume that an address for which this function returns
62      * false is an externally-owned account (EOA) and not a contract.
63      *
64      * Among others, `isContract` will return false for the following
65      * types of addresses:
66      *
67      *  - an externally-owned account
68      *  - a contract in construction
69      *  - an address where a contract will be created
70      *  - an address where a contract lived, but was destroyed
71      * ====
72      *
73      * [IMPORTANT]
74      * ====
75      * You shouldn't rely on `isContract` to protect against flash loan attacks!
76      *
77      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
78      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
79      * constructor.
80      * ====
81      */
82     function isContract(address account) internal view returns (bool) {
83         // This method relies on extcodesize/address.code.length, which returns 0
84         // for contracts in construction, since the code is only stored at the end
85         // of the constructor execution.
86 
87         return account.code.length > 0;
88     }
89 
90     /**
91      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
92      * `recipient`, forwarding all available gas and reverting on errors.
93      *
94      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
95      * of certain opcodes, possibly making contracts go over the 2300 gas limit
96      * imposed by `transfer`, making them unable to receive funds via
97      * `transfer`. {sendValue} removes this limitation.
98      *
99      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
100      *
101      * IMPORTANT: because control is transferred to `recipient`, care must be
102      * taken to not create reentrancy vulnerabilities. Consider using
103      * {ReentrancyGuard} or the
104      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
105      */
106     function sendValue(address payable recipient, uint256 amount) internal {
107         require(address(this).balance >= amount, "Address: insufficient balance");
108 
109         (bool success, ) = recipient.call{value: amount}("");
110         require(success, "Address: unable to send value, recipient may have reverted");
111     }
112 
113     /**
114      * @dev Performs a Solidity function call using a low level `call`. A
115      * plain `call` is an unsafe replacement for a function call: use this
116      * function instead.
117      *
118      * If `target` reverts with a revert reason, it is bubbled up by this
119      * function (like regular Solidity function calls).
120      *
121      * Returns the raw returned data. To convert to the expected return value,
122      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
123      *
124      * Requirements:
125      *
126      * - `target` must be a contract.
127      * - calling `target` with `data` must not revert.
128      *
129      * _Available since v3.1._
130      */
131     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
132         return functionCall(target, data, "Address: low-level call failed");
133     }
134 
135     /**
136      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
137      * `errorMessage` as a fallback revert reason when `target` reverts.
138      *
139      * _Available since v3.1._
140      */
141     function functionCall(
142         address target,
143         bytes memory data,
144         string memory errorMessage
145     ) internal returns (bytes memory) {
146         return functionCallWithValue(target, data, 0, errorMessage);
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
151      * but also transferring `value` wei to `target`.
152      *
153      * Requirements:
154      *
155      * - the calling contract must have an ETH balance of at least `value`.
156      * - the called Solidity function must be `payable`.
157      *
158      * _Available since v3.1._
159      */
160     function functionCallWithValue(
161         address target,
162         bytes memory data,
163         uint256 value
164     ) internal returns (bytes memory) {
165         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
170      * with `errorMessage` as a fallback revert reason when `target` reverts.
171      *
172      * _Available since v3.1._
173      */
174     function functionCallWithValue(
175         address target,
176         bytes memory data,
177         uint256 value,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         require(address(this).balance >= value, "Address: insufficient balance for call");
181         require(isContract(target), "Address: call to non-contract");
182 
183         (bool success, bytes memory returndata) = target.call{value: value}(data);
184         return verifyCallResult(success, returndata, errorMessage);
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
189      * but performing a static call.
190      *
191      * _Available since v3.3._
192      */
193     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
194         return functionStaticCall(target, data, "Address: low-level static call failed");
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
199      * but performing a static call.
200      *
201      * _Available since v3.3._
202      */
203     function functionStaticCall(
204         address target,
205         bytes memory data,
206         string memory errorMessage
207     ) internal view returns (bytes memory) {
208         require(isContract(target), "Address: static call to non-contract");
209 
210         (bool success, bytes memory returndata) = target.staticcall(data);
211         return verifyCallResult(success, returndata, errorMessage);
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
216      * but performing a delegate call.
217      *
218      * _Available since v3.4._
219      */
220     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
221         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
226      * but performing a delegate call.
227      *
228      * _Available since v3.4._
229      */
230     function functionDelegateCall(
231         address target,
232         bytes memory data,
233         string memory errorMessage
234     ) internal returns (bytes memory) {
235         require(isContract(target), "Address: delegate call to non-contract");
236 
237         (bool success, bytes memory returndata) = target.delegatecall(data);
238         return verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     /**
242      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
243      * revert reason using the provided one.
244      *
245      * _Available since v4.3._
246      */
247     function verifyCallResult(
248         bool success,
249         bytes memory returndata,
250         string memory errorMessage
251     ) internal pure returns (bytes memory) {
252         if (success) {
253             return returndata;
254         } else {
255             // Look for revert reason and bubble it up if present
256             if (returndata.length > 0) {
257                 // The easiest way to bubble the revert reason is using memory via assembly
258 
259                 assembly {
260                     let returndata_size := mload(returndata)
261                     revert(add(32, returndata), returndata_size)
262                 }
263             } else {
264                 revert(errorMessage);
265             }
266         }
267     }
268 }
269 
270 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
271 
272 pragma solidity ^0.8.0;
273 
274 /**
275  * @dev Provides information about the current execution context, including the
276  * sender of the transaction and its data. While these are generally available
277  * via msg.sender and msg.data, they should not be accessed in such a direct
278  * manner, since when dealing with meta-transactions the account sending and
279  * paying for execution may not be the actual sender (as far as an application
280  * is concerned).
281  *
282  * This contract is only required for intermediate, library-like contracts.
283  */
284 abstract contract Context {
285     function _msgSender() internal view virtual returns (address) {
286         return msg.sender;
287     }
288 
289     function _msgData() internal view virtual returns (bytes calldata) {
290         return msg.data;
291     }
292 }
293 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
294 
295 pragma solidity ^0.8.0;
296 
297 /**
298  * @dev String operations.
299  */
300 library Strings {
301     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
302 
303     /**
304      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
305      */
306     function toString(uint256 value) internal pure returns (string memory) {
307         // Inspired by OraclizeAPI's implementation - MIT licence
308         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
309 
310         if (value == 0) {
311             return "0";
312         }
313         uint256 temp = value;
314         uint256 digits;
315         while (temp != 0) {
316             digits++;
317             temp /= 10;
318         }
319         bytes memory buffer = new bytes(digits);
320         while (value != 0) {
321             digits -= 1;
322             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
323             value /= 10;
324         }
325         return string(buffer);
326     }
327 
328     /**
329      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
330      */
331     function toHexString(uint256 value) internal pure returns (string memory) {
332         if (value == 0) {
333             return "0x00";
334         }
335         uint256 temp = value;
336         uint256 length = 0;
337         while (temp != 0) {
338             length++;
339             temp >>= 8;
340         }
341         return toHexString(value, length);
342     }
343 
344     /**
345      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
346      */
347     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
348         bytes memory buffer = new bytes(2 * length + 2);
349         buffer[0] = "0";
350         buffer[1] = "x";
351         for (uint256 i = 2 * length + 1; i > 1; --i) {
352             buffer[i] = _HEX_SYMBOLS[value & 0xf];
353             value >>= 4;
354         }
355         require(value == 0, "Strings: hex length insufficient");
356         return string(buffer);
357     }
358 }
359 
360 
361 
362 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
363 
364 pragma solidity ^0.8.0;
365 
366 /**
367  * @dev Interface of the ERC165 standard, as defined in the
368  * https://eips.ethereum.org/EIPS/eip-165[EIP].
369  *
370  * Implementers can declare support of contract interfaces, which can then be
371  * queried by others ({ERC165Checker}).
372  *
373  * For an implementation, see {ERC165}.
374  */
375 interface IERC165 {
376     /**
377      * @dev Returns true if this contract implements the interface defined by
378      * `interfaceId`. See the corresponding
379      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
380      * to learn more about how these ids are created.
381      *
382      * This function call must use less than 30 000 gas.
383      */
384     function supportsInterface(bytes4 interfaceId) external view returns (bool);
385 }
386 
387 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
388 
389 pragma solidity ^0.8.0;
390 /**
391  * @dev Required interface of an ERC721 compliant contract.
392  */
393 interface IERC721 is IERC165 {
394     /**
395      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
396      */
397     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
398 
399     /**
400      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
401      */
402     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
403 
404     /**
405      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
406      */
407     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
408 
409     /**
410      * @dev Returns the number of tokens in ``owner``'s account.
411      */
412     function balanceOf(address owner) external view returns (uint256 balance);
413 
414     /**
415      * @dev Returns the owner of the `tokenId` token.
416      *
417      * Requirements:
418      *
419      * - `tokenId` must exist.
420      */
421     function ownerOf(uint256 tokenId) external view returns (address owner);
422 
423     /**
424      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
425      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
426      *
427      * Requirements:
428      *
429      * - `from` cannot be the zero address.
430      * - `to` cannot be the zero address.
431      * - `tokenId` token must exist and be owned by `from`.
432      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
433      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
434      *
435      * Emits a {Transfer} event.
436      */
437     function safeTransferFrom(
438         address from,
439         address to,
440         uint256 tokenId
441     ) external;
442 
443     /**
444      * @dev Transfers `tokenId` token from `from` to `to`.
445      *
446      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
447      *
448      * Requirements:
449      *
450      * - `from` cannot be the zero address.
451      * - `to` cannot be the zero address.
452      * - `tokenId` token must be owned by `from`.
453      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
454      *
455      * Emits a {Transfer} event.
456      */
457     function transferFrom(
458         address from,
459         address to,
460         uint256 tokenId
461     ) external;
462 
463     /**
464      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
465      * The approval is cleared when the token is transferred.
466      *
467      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
468      *
469      * Requirements:
470      *
471      * - The caller must own the token or be an approved operator.
472      * - `tokenId` must exist.
473      *
474      * Emits an {Approval} event.
475      */
476     function approve(address to, uint256 tokenId) external;
477 
478     /**
479      * @dev Returns the account approved for `tokenId` token.
480      *
481      * Requirements:
482      *
483      * - `tokenId` must exist.
484      */
485     function getApproved(uint256 tokenId) external view returns (address operator);
486 
487     /**
488      * @dev Approve or remove `operator` as an operator for the caller.
489      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
490      *
491      * Requirements:
492      *
493      * - The `operator` cannot be the caller.
494      *
495      * Emits an {ApprovalForAll} event.
496      */
497     function setApprovalForAll(address operator, bool _approved) external;
498 
499     /**
500      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
501      *
502      * See {setApprovalForAll}
503      */
504     function isApprovedForAll(address owner, address operator) external view returns (bool);
505 
506     /**
507      * @dev Safely transfers `tokenId` token from `from` to `to`.
508      *
509      * Requirements:
510      *
511      * - `from` cannot be the zero address.
512      * - `to` cannot be the zero address.
513      * - `tokenId` token must exist and be owned by `from`.
514      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
515      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
516      *
517      * Emits a {Transfer} event.
518      */
519     function safeTransferFrom(
520         address from,
521         address to,
522         uint256 tokenId,
523         bytes calldata data
524     ) external;
525 }
526 
527 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @dev Implementation of the {IERC165} interface.
533  *
534  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
535  * for the additional interface id that will be supported. For example:
536  *
537  * ```solidity
538  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
539  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
540  * }
541  * ```
542  *
543  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
544  */
545 abstract contract ERC165 is IERC165 {
546     /**
547      * @dev See {IERC165-supportsInterface}.
548      */
549     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
550         return interfaceId == type(IERC165).interfaceId;
551     }
552 }
553 
554 
555 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 /**
560  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
561  * @dev See https://eips.ethereum.org/EIPS/eip-721
562  */
563 interface IERC721Metadata is IERC721 {
564     /**
565      * @dev Returns the token collection name.
566      */
567     function name() external view returns (string memory);
568 
569     /**
570      * @dev Returns the token collection symbol.
571      */
572     function symbol() external view returns (string memory);
573 
574     /**
575      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
576      */
577     function tokenURI(uint256 tokenId) external view returns (string memory);
578 }
579 
580 
581 
582 
583 
584 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
585 
586 pragma solidity ^0.8.0;
587 /**
588  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
589  * the Metadata extension, but not including the Enumerable extension, which is available separately as
590  * {ERC721Enumerable}.
591  */
592 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
593     using Address for address;
594     using Strings for uint256;
595 
596     // Token name
597     string private _name;
598 
599     // Token symbol
600     string private _symbol;
601 
602     // Mapping from token ID to owner address
603     mapping(uint256 => address) private _owners;
604 
605     // Mapping owner address to token count
606     mapping(address => uint256) private _balances;
607 
608     // Mapping from token ID to approved address
609     mapping(uint256 => address) private _tokenApprovals;
610 
611     // Mapping from owner to operator approvals
612     mapping(address => mapping(address => bool)) private _operatorApprovals;
613 
614     /**
615      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
616      */
617     constructor(string memory name_, string memory symbol_) {
618         _name = name_;
619         _symbol = symbol_;
620     }
621 
622     /**
623      * @dev See {IERC165-supportsInterface}.
624      */
625     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
626         return
627             interfaceId == type(IERC721).interfaceId ||
628             interfaceId == type(IERC721Metadata).interfaceId ||
629             super.supportsInterface(interfaceId);
630     }
631 
632     /**
633      * @dev See {IERC721-balanceOf}.
634      */
635     function balanceOf(address owner) public view virtual override returns (uint256) {
636         require(owner != address(0), "ERC721: balance query for the zero address");
637         return _balances[owner];
638     }
639 
640     /**
641      * @dev See {IERC721-ownerOf}.
642      */
643     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
644         address owner = _owners[tokenId];
645         require(owner != address(0), "ERC721: owner query for nonexistent token");
646         return owner;
647     }
648 
649     /**
650      * @dev See {IERC721Metadata-name}.
651      */
652     function name() public view virtual override returns (string memory) {
653         return _name;
654     }
655 
656     /**
657      * @dev See {IERC721Metadata-symbol}.
658      */
659     function symbol() public view virtual override returns (string memory) {
660         return _symbol;
661     }
662 
663     /**
664      * @dev See {IERC721Metadata-tokenURI}.
665      */
666     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
667         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
668 
669         string memory baseURI = _baseURI();
670         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
671     }
672 
673     /**
674      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
675      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
676      * by default, can be overriden in child contracts.
677      */
678     function _baseURI() internal view virtual returns (string memory) {
679         return "";
680     }
681 
682     /**
683      * @dev See {IERC721-approve}.
684      */
685     function approve(address to, uint256 tokenId) public virtual override {
686         address owner = ERC721.ownerOf(tokenId);
687         require(to != owner, "ERC721: approval to current owner");
688 
689         require(
690             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
691             "ERC721: approve caller is not owner nor approved for all"
692         );
693 
694         _approve(to, tokenId);
695     }
696 
697     /**
698      * @dev See {IERC721-getApproved}.
699      */
700     function getApproved(uint256 tokenId) public view virtual override returns (address) {
701         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
702 
703         return _tokenApprovals[tokenId];
704     }
705 
706     /**
707      * @dev See {IERC721-setApprovalForAll}.
708      */
709     function setApprovalForAll(address operator, bool approved) public virtual override {
710         _setApprovalForAll(_msgSender(), operator, approved);
711     }
712 
713     /**
714      * @dev See {IERC721-isApprovedForAll}.
715      */
716     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
717         return _operatorApprovals[owner][operator];
718     }
719 
720     /**
721      * @dev See {IERC721-transferFrom}.
722      */
723     function transferFrom(
724         address from,
725         address to,
726         uint256 tokenId
727     ) public virtual override {
728         //solhint-disable-next-line max-line-length
729         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
730 
731         _transfer(from, to, tokenId);
732     }
733 
734     /**
735      * @dev See {IERC721-safeTransferFrom}.
736      */
737     function safeTransferFrom(
738         address from,
739         address to,
740         uint256 tokenId
741     ) public virtual override {
742         safeTransferFrom(from, to, tokenId, "");
743     }
744 
745     /**
746      * @dev See {IERC721-safeTransferFrom}.
747      */
748     function safeTransferFrom(
749         address from,
750         address to,
751         uint256 tokenId,
752         bytes memory _data
753     ) public virtual override {
754         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
755         _safeTransfer(from, to, tokenId, _data);
756     }
757 
758     /**
759      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
760      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
761      *
762      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
763      *
764      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
765      * implement alternative mechanisms to perform token transfer, such as signature-based.
766      *
767      * Requirements:
768      *
769      * - `from` cannot be the zero address.
770      * - `to` cannot be the zero address.
771      * - `tokenId` token must exist and be owned by `from`.
772      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
773      *
774      * Emits a {Transfer} event.
775      */
776     function _safeTransfer(
777         address from,
778         address to,
779         uint256 tokenId,
780         bytes memory _data
781     ) internal virtual {
782         _transfer(from, to, tokenId);
783         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
784     }
785 
786     /**
787      * @dev Returns whether `tokenId` exists.
788      *
789      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
790      *
791      * Tokens start existing when they are minted (`_mint`),
792      * and stop existing when they are burned (`_burn`).
793      */
794     function _exists(uint256 tokenId) internal view virtual returns (bool) {
795         return _owners[tokenId] != address(0);
796     }
797 
798     /**
799      * @dev Returns whether `spender` is allowed to manage `tokenId`.
800      *
801      * Requirements:
802      *
803      * - `tokenId` must exist.
804      */
805     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
806         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
807         address owner = ERC721.ownerOf(tokenId);
808         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
809     }
810 
811     /**
812      * @dev Safely mints `tokenId` and transfers it to `to`.
813      *
814      * Requirements:
815      *
816      * - `tokenId` must not exist.
817      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
818      *
819      * Emits a {Transfer} event.
820      */
821     function _safeMint(address to, uint256 tokenId) internal virtual {
822         _safeMint(to, tokenId, "");
823     }
824 
825     /**
826      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
827      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
828      */
829     function _safeMint(
830         address to,
831         uint256 tokenId,
832         bytes memory _data
833     ) internal virtual {
834         _mint(to, tokenId);
835         require(
836             _checkOnERC721Received(address(0), to, tokenId, _data),
837             "ERC721: transfer to non ERC721Receiver implementer"
838         );
839     }
840 
841     /**
842      * @dev Mints `tokenId` and transfers it to `to`.
843      *
844      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
845      *
846      * Requirements:
847      *
848      * - `tokenId` must not exist.
849      * - `to` cannot be the zero address.
850      *
851      * Emits a {Transfer} event.
852      */
853     function _mint(address to, uint256 tokenId) internal virtual {
854         require(to != address(0), "ERC721: mint to the zero address");
855         require(!_exists(tokenId), "ERC721: token already minted");
856 
857         _beforeTokenTransfer(address(0), to, tokenId);
858 
859         _balances[to] += 1;
860         _owners[tokenId] = to;
861 
862         emit Transfer(address(0), to, tokenId);
863 
864         _afterTokenTransfer(address(0), to, tokenId);
865     }
866 
867     /**
868      * @dev Destroys `tokenId`.
869      * The approval is cleared when the token is burned.
870      *
871      * Requirements:
872      *
873      * - `tokenId` must exist.
874      *
875      * Emits a {Transfer} event.
876      */
877     function _burn(uint256 tokenId) internal virtual {
878         address owner = ERC721.ownerOf(tokenId);
879 
880         _beforeTokenTransfer(owner, address(0), tokenId);
881 
882         // Clear approvals
883         _approve(address(0), tokenId);
884 
885         _balances[owner] -= 1;
886         delete _owners[tokenId];
887 
888         emit Transfer(owner, address(0), tokenId);
889 
890         _afterTokenTransfer(owner, address(0), tokenId);
891     }
892 
893     /**
894      * @dev Transfers `tokenId` from `from` to `to`.
895      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
896      *
897      * Requirements:
898      *
899      * - `to` cannot be the zero address.
900      * - `tokenId` token must be owned by `from`.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _transfer(
905         address from,
906         address to,
907         uint256 tokenId
908     ) internal virtual {
909         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
910         require(to != address(0), "ERC721: transfer to the zero address");
911 
912         _beforeTokenTransfer(from, to, tokenId);
913 
914         // Clear approvals from the previous owner
915         _approve(address(0), tokenId);
916 
917         _balances[from] -= 1;
918         _balances[to] += 1;
919         _owners[tokenId] = to;
920 
921         emit Transfer(from, to, tokenId);
922 
923         _afterTokenTransfer(from, to, tokenId);
924     }
925 
926     /**
927      * @dev Approve `to` to operate on `tokenId`
928      *
929      * Emits a {Approval} event.
930      */
931     function _approve(address to, uint256 tokenId) internal virtual {
932         _tokenApprovals[tokenId] = to;
933         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
934     }
935 
936     /**
937      * @dev Approve `operator` to operate on all of `owner` tokens
938      *
939      * Emits a {ApprovalForAll} event.
940      */
941     function _setApprovalForAll(
942         address owner,
943         address operator,
944         bool approved
945     ) internal virtual {
946         require(owner != operator, "ERC721: approve to caller");
947         _operatorApprovals[owner][operator] = approved;
948         emit ApprovalForAll(owner, operator, approved);
949     }
950 
951     /**
952      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
953      * The call is not executed if the target address is not a contract.
954      *
955      * @param from address representing the previous owner of the given token ID
956      * @param to target address that will receive the tokens
957      * @param tokenId uint256 ID of the token to be transferred
958      * @param _data bytes optional data to send along with the call
959      * @return bool whether the call correctly returned the expected magic value
960      */
961     function _checkOnERC721Received(
962         address from,
963         address to,
964         uint256 tokenId,
965         bytes memory _data
966     ) private returns (bool) {
967         if (to.isContract()) {
968             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
969                 return retval == IERC721Receiver.onERC721Received.selector;
970             } catch (bytes memory reason) {
971                 if (reason.length == 0) {
972                     revert("ERC721: transfer to non ERC721Receiver implementer");
973                 } else {
974                     assembly {
975                         revert(add(32, reason), mload(reason))
976                     }
977                 }
978             }
979         } else {
980             return true;
981         }
982     }
983 
984     /**
985      * @dev Hook that is called before any token transfer. This includes minting
986      * and burning.
987      *
988      * Calling conditions:
989      *
990      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
991      * transferred to `to`.
992      * - When `from` is zero, `tokenId` will be minted for `to`.
993      * - When `to` is zero, ``from``'s `tokenId` will be burned.
994      * - `from` and `to` are never both zero.
995      *
996      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
997      */
998     function _beforeTokenTransfer(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) internal virtual {}
1003 
1004     /**
1005      * @dev Hook that is called after any transfer of tokens. This includes
1006      * minting and burning.
1007      *
1008      * Calling conditions:
1009      *
1010      * - when `from` and `to` are both non-zero.
1011      * - `from` and `to` are never both zero.
1012      *
1013      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1014      */
1015     function _afterTokenTransfer(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) internal virtual {}
1020 }
1021 
1022 
1023 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1024 
1025 pragma solidity ^0.8.0;
1026 
1027 /**
1028  * @title Counters
1029  * @author Matt Condon (@shrugs)
1030  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1031  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1032  *
1033  * Include with `using Counters for Counters.Counter;`
1034  */
1035 library Counters {
1036     struct Counter {
1037         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1038         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1039         // this feature: see https://github.com/ethereum/solidity/issues/4637
1040         uint256 _value; // default: 0
1041     }
1042 
1043     function current(Counter storage counter) internal view returns (uint256) {
1044         return counter._value;
1045     }
1046 
1047     function increment(Counter storage counter) internal {
1048         unchecked {
1049             counter._value += 1;
1050         }
1051     }
1052 
1053     function decrement(Counter storage counter) internal {
1054         uint256 value = counter._value;
1055         require(value > 0, "Counter: decrement overflow");
1056         unchecked {
1057             counter._value = value - 1;
1058         }
1059     }
1060 
1061     function reset(Counter storage counter) internal {
1062         counter._value = 0;
1063     }
1064 }
1065 
1066 
1067 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1068 
1069 pragma solidity ^0.8.0;
1070 
1071 /**
1072  * @dev Provides information about the current execution context, including the
1073  * sender of the transaction and its data. While these are generally available
1074  * via msg.sender and msg.data, they should not be accessed in such a direct
1075  * manner, since when dealing with meta-transactions the account sending and
1076  * paying for execution may not be the actual sender (as far as an application
1077  * is concerned).
1078  *
1079  * This contract is only required for intermediate, library-like contracts.
1080  */
1081 // abstract contract Context {
1082 //     function _msgSender() internal view virtual returns (address) {
1083 //         return msg.sender;
1084 //     }
1085 
1086 //     function _msgData() internal view virtual returns (bytes calldata) {
1087 //         return msg.data;
1088 //     }
1089 // }
1090 
1091 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1092 
1093 pragma solidity ^0.8.0;
1094 
1095 /**
1096  * @dev Contract module which provides a basic access control mechanism, where
1097  * there is an account (an owner) that can be granted exclusive access to
1098  * specific functions.
1099  *
1100  * By default, the owner account will be the one that deploys the contract. This
1101  * can later be changed with {transferOwnership}.
1102  *
1103  * This module is used through inheritance. It will make available the modifier
1104  * `onlyOwner`, which can be applied to your functions to restrict their use to
1105  * the owner.
1106  */
1107 abstract contract Ownable is Context {
1108     address private _owner;
1109 
1110     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1111 
1112     /**
1113      * @dev Initializes the contract setting the deployer as the initial owner.
1114      */
1115     constructor() {
1116         _transferOwnership(_msgSender());
1117     }
1118 
1119     /**
1120      * @dev Returns the address of the current owner.
1121      */
1122     function owner() public view virtual returns (address) {
1123         return _owner;
1124     }
1125 
1126     /**
1127      * @dev Throws if called by any account other than the owner.
1128      */
1129     modifier onlyOwner() {
1130         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1131         _;
1132     }
1133 
1134     /**
1135      * @dev Leaves the contract without owner. It will not be possible to call
1136      * `onlyOwner` functions anymore. Can only be called by the current owner.
1137      *
1138      * NOTE: Renouncing ownership will leave the contract without an owner,
1139      * thereby removing any functionality that is only available to the owner.
1140      */
1141     function renounceOwnership() public virtual onlyOwner {
1142         _transferOwnership(address(0));
1143     }
1144 
1145     /**
1146      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1147      * Can only be called by the current owner.
1148      */
1149     function transferOwnership(address newOwner) public virtual onlyOwner {
1150         require(newOwner != address(0), "Ownable: new owner is the zero address");
1151         _transferOwnership(newOwner);
1152     }
1153 
1154     /**
1155      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1156      * Internal function without access restriction.
1157      */
1158     function _transferOwnership(address newOwner) internal virtual {
1159         address oldOwner = _owner;
1160         _owner = newOwner;
1161         emit OwnershipTransferred(oldOwner, newOwner);
1162     }
1163 }
1164 
1165 pragma solidity >=0.7.0 <0.9.0;
1166 
1167 contract Feelgangdeploy is ERC721, Ownable {
1168   using Strings for uint256;
1169   using Counters for Counters.Counter;
1170 
1171   Counters.Counter private supply;
1172 
1173   string public uriPrefix = "";
1174   string public uriSuffix = ".json";
1175   string public hiddenMetadataUri;
1176   
1177   uint256 public cost = 0.04 ether;
1178   uint256 public maxSupply = 10000;
1179   uint256 public maxMintAmountPerTx = 20;
1180   uint256 public nftPerAddressLimit = 5;
1181 
1182   bool public paused = true;
1183   bool public revealed = false;
1184   bool public onlyWhitelisted = true;
1185 
1186   address[] public whitelistedAddresses;
1187 
1188   mapping(address => uint256) public addressMintedBalance;
1189 
1190   constructor() ERC721("FeelGang", "FG") {
1191     setHiddenMetadataUri("ipfs://QmZJnM4GK7rNbznNdekmR5ieTi1Ckh2PTpRVpjvq9Uq44p/hidden.json");
1192   }
1193 
1194   modifier mintCompliance(uint256 _mintAmount) {
1195     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1196     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1197     _;
1198   }
1199 
1200   function totalSupply() public view returns (uint256) {
1201     return supply.current();
1202   }
1203 
1204   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1205     require(!paused, "The contract is paused!");
1206     require(msg.value >= cost * _mintAmount, "insufficient funds");
1207 
1208     if(onlyWhitelisted == true) {
1209         require(isWhitelisted(msg.sender), "user is not whitelisted");
1210         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1211         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1212     }
1213 
1214     _mintLoop(msg.sender, _mintAmount);
1215   }
1216   
1217   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1218     _mintLoop(_receiver, _mintAmount);
1219   }
1220 
1221   function walletOfOwner(address _owner)
1222     public
1223     view
1224     returns (uint256[] memory)
1225   {
1226     uint256 ownerTokenCount = balanceOf(_owner);
1227     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1228     uint256 currentTokenId = 1;
1229     uint256 ownedTokenIndex = 0;
1230 
1231     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1232       address currentTokenOwner = ownerOf(currentTokenId);
1233 
1234       if (currentTokenOwner == _owner) {
1235         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1236 
1237         ownedTokenIndex++;
1238       }
1239 
1240       currentTokenId++;
1241     }
1242 
1243     return ownedTokenIds;
1244   }
1245 
1246   function tokenURI(uint256 _tokenId)
1247     public
1248     view
1249     virtual
1250     override
1251     returns (string memory)
1252   {
1253     require(
1254       _exists(_tokenId),
1255       "ERC721Metadata: URI query for nonexistent token"
1256     );
1257 
1258     if (revealed == false) {
1259       return hiddenMetadataUri;
1260     }
1261 
1262     string memory currentBaseURI = _baseURI();
1263     return bytes(currentBaseURI).length > 0
1264         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1265         : "";
1266   }
1267 
1268   function isWhitelisted(address _user) public view returns (bool) {
1269     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1270       if (whitelistedAddresses[i] == _user) {
1271           return true;
1272       }
1273     }
1274     return false;
1275   }
1276 
1277   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1278     nftPerAddressLimit = _limit;
1279   }
1280 
1281   function setOnlyWhitelisted(bool _state) public onlyOwner {
1282     onlyWhitelisted = _state;
1283   }
1284   
1285   function whitelistUsers(address[] calldata _users) public onlyOwner {
1286     whitelistedAddresses = _users;
1287   }
1288 
1289   function setRevealed(bool _state) public onlyOwner {
1290     revealed = _state;
1291   }
1292 
1293   function setCost(uint256 _cost) public onlyOwner {
1294     cost = _cost;
1295   }
1296 
1297   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1298     maxMintAmountPerTx = _maxMintAmountPerTx;
1299   }
1300 
1301   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1302     hiddenMetadataUri = _hiddenMetadataUri;
1303   }
1304 
1305   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1306     uriPrefix = _uriPrefix;
1307   }
1308 
1309   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1310     uriSuffix = _uriSuffix;
1311   }
1312 
1313   function setPaused(bool _state) public onlyOwner {
1314     paused = _state;
1315   }
1316 
1317   function withdraw() public onlyOwner {
1318 
1319     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1320     require(os);
1321   
1322   }
1323 
1324   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1325     for (uint256 i = 0; i < _mintAmount; i++) {
1326       addressMintedBalance[msg.sender]++;
1327       supply.increment();
1328       _safeMint(_receiver, supply.current());
1329     }
1330   }
1331 
1332   function _baseURI() internal view virtual override returns (string memory) {
1333     return uriPrefix;
1334   }
1335 }