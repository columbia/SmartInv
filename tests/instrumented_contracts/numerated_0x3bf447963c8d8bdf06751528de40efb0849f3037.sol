1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol
28 
29 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Required interface of an ERC721 compliant contract.
36  */
37 interface IERC721 is IERC165 {
38     /**
39      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
40      */
41     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
45      */
46     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
50      */
51     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
52 
53     /**
54      * @dev Returns the number of tokens in ``owner``'s account.
55      */
56     function balanceOf(address owner) external view returns (uint256 balance);
57 
58     /**
59      * @dev Returns the owner of the `tokenId` token.
60      *
61      * Requirements:
62      *
63      * - `tokenId` must exist.
64      */
65     function ownerOf(uint256 tokenId) external view returns (address owner);
66 
67     /**
68      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
69      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
70      *
71      * Requirements:
72      *
73      * - `from` cannot be the zero address.
74      * - `to` cannot be the zero address.
75      * - `tokenId` token must exist and be owned by `from`.
76      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
77      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
78      *
79      * Emits a {Transfer} event.
80      */
81     function safeTransferFrom(
82         address from,
83         address to,
84         uint256 tokenId
85     ) external;
86 
87     /**
88      * @dev Transfers `tokenId` token from `from` to `to`.
89      *
90      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must be owned by `from`.
97      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transferFrom(
102         address from,
103         address to,
104         uint256 tokenId
105     ) external;
106 
107     /**
108      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
109      * The approval is cleared when the token is transferred.
110      *
111      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
112      *
113      * Requirements:
114      *
115      * - The caller must own the token or be an approved operator.
116      * - `tokenId` must exist.
117      *
118      * Emits an {Approval} event.
119      */
120     function approve(address to, uint256 tokenId) external;
121 
122     /**
123      * @dev Returns the account approved for `tokenId` token.
124      *
125      * Requirements:
126      *
127      * - `tokenId` must exist.
128      */
129     function getApproved(uint256 tokenId) external view returns (address operator);
130 
131     /**
132      * @dev Approve or remove `operator` as an operator for the caller.
133      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
134      *
135      * Requirements:
136      *
137      * - The `operator` cannot be the caller.
138      *
139      * Emits an {ApprovalForAll} event.
140      */
141     function setApprovalForAll(address operator, bool _approved) external;
142 
143     /**
144      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
145      *
146      * See {setApprovalForAll}
147      */
148     function isApprovedForAll(address owner, address operator) external view returns (bool);
149 
150     /**
151      * @dev Safely transfers `tokenId` token from `from` to `to`.
152      *
153      * Requirements:
154      *
155      * - `from` cannot be the zero address.
156      * - `to` cannot be the zero address.
157      * - `tokenId` token must exist and be owned by `from`.
158      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
159      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
160      *
161      * Emits a {Transfer} event.
162      */
163     function safeTransferFrom(
164         address from,
165         address to,
166         uint256 tokenId,
167         bytes calldata data
168     ) external;
169 }
170 
171 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
172 
173 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
174 
175 pragma solidity ^0.8.0;
176 
177 /**
178  * @title ERC721 token receiver interface
179  * @dev Interface for any contract that wants to support safeTransfers
180  * from ERC721 asset contracts.
181  */
182 interface IERC721Receiver {
183     /**
184      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
185      * by `operator` from `from`, this function is called.
186      *
187      * It must return its Solidity selector to confirm the token transfer.
188      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
189      *
190      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
191      */
192     function onERC721Received(
193         address operator,
194         address from,
195         uint256 tokenId,
196         bytes calldata data
197     ) external returns (bytes4);
198 }
199 
200 // File: node_modules\@openzeppelin\contracts\token\ERC721\extensions\IERC721Metadata.sol
201 
202 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 
207 /**
208  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
209  * @dev See https://eips.ethereum.org/EIPS/eip-721
210  */
211 interface IERC721Metadata is IERC721 {
212     /**
213      * @dev Returns the token collection name.
214      */
215     function name() external view returns (string memory);
216 
217     /**
218      * @dev Returns the token collection symbol.
219      */
220     function symbol() external view returns (string memory);
221 
222     /**
223      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
224      */
225     function tokenURI(uint256 tokenId) external view returns (string memory);
226 }
227 
228 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
229 
230 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      */
255     function isContract(address account) internal view returns (bool) {
256         // This method relies on extcodesize, which returns 0 for contracts in
257         // construction, since the code is only stored at the end of the
258         // constructor execution.
259 
260         uint256 size;
261         assembly {
262             size := extcodesize(account)
263         }
264         return size > 0;
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(address(this).balance >= amount, "Address: insufficient balance");
285 
286         (bool success, ) = recipient.call{value: amount}("");
287         require(success, "Address: unable to send value, recipient may have reverted");
288     }
289 
290     /**
291      * @dev Performs a Solidity function call using a low level `call`. A
292      * plain `call` is an unsafe replacement for a function call: use this
293      * function instead.
294      *
295      * If `target` reverts with a revert reason, it is bubbled up by this
296      * function (like regular Solidity function calls).
297      *
298      * Returns the raw returned data. To convert to the expected return value,
299      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
300      *
301      * Requirements:
302      *
303      * - `target` must be a contract.
304      * - calling `target` with `data` must not revert.
305      *
306      * _Available since v3.1._
307      */
308     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
309         return functionCall(target, data, "Address: low-level call failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
314      * `errorMessage` as a fallback revert reason when `target` reverts.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(
319         address target,
320         bytes memory data,
321         string memory errorMessage
322     ) internal returns (bytes memory) {
323         return functionCallWithValue(target, data, 0, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but also transferring `value` wei to `target`.
329      *
330      * Requirements:
331      *
332      * - the calling contract must have an ETH balance of at least `value`.
333      * - the called Solidity function must be `payable`.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(
338         address target,
339         bytes memory data,
340         uint256 value
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
347      * with `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(
352         address target,
353         bytes memory data,
354         uint256 value,
355         string memory errorMessage
356     ) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         require(isContract(target), "Address: call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.call{value: value}(data);
361         return verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but performing a static call.
367      *
368      * _Available since v3.3._
369      */
370     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
371         return functionStaticCall(target, data, "Address: low-level static call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal view returns (bytes memory) {
385         require(isContract(target), "Address: static call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.staticcall(data);
388         return verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but performing a delegate call.
394      *
395      * _Available since v3.4._
396      */
397     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
398         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403      * but performing a delegate call.
404      *
405      * _Available since v3.4._
406      */
407     function functionDelegateCall(
408         address target,
409         bytes memory data,
410         string memory errorMessage
411     ) internal returns (bytes memory) {
412         require(isContract(target), "Address: delegate call to non-contract");
413 
414         (bool success, bytes memory returndata) = target.delegatecall(data);
415         return verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     /**
419      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
420      * revert reason using the provided one.
421      *
422      * _Available since v4.3._
423      */
424     function verifyCallResult(
425         bool success,
426         bytes memory returndata,
427         string memory errorMessage
428     ) internal pure returns (bytes memory) {
429         if (success) {
430             return returndata;
431         } else {
432             // Look for revert reason and bubble it up if present
433             if (returndata.length > 0) {
434                 // The easiest way to bubble the revert reason is using memory via assembly
435 
436                 assembly {
437                     let returndata_size := mload(returndata)
438                     revert(add(32, returndata), returndata_size)
439                 }
440             } else {
441                 revert(errorMessage);
442             }
443         }
444     }
445 }
446 
447 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
448 
449 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 /**
454  * @dev Provides information about the current execution context, including the
455  * sender of the transaction and its data. While these are generally available
456  * via msg.sender and msg.data, they should not be accessed in such a direct
457  * manner, since when dealing with meta-transactions the account sending and
458  * paying for execution may not be the actual sender (as far as an application
459  * is concerned).
460  *
461  * This contract is only required for intermediate, library-like contracts.
462  */
463 abstract contract Context {
464     function _msgSender() internal view virtual returns (address) {
465         return msg.sender;
466     }
467 
468     function _msgData() internal view virtual returns (bytes calldata) {
469         return msg.data;
470     }
471 }
472 
473 // File: node_modules\@openzeppelin\contracts\utils\Strings.sol
474 
475 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 /**
480  * @dev String operations.
481  */
482 library Strings {
483     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
484 
485     /**
486      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
487      */
488     function toString(uint256 value) internal pure returns (string memory) {
489         // Inspired by OraclizeAPI's implementation - MIT licence
490         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
491 
492         if (value == 0) {
493             return "0";
494         }
495         uint256 temp = value;
496         uint256 digits;
497         while (temp != 0) {
498             digits++;
499             temp /= 10;
500         }
501         bytes memory buffer = new bytes(digits);
502         while (value != 0) {
503             digits -= 1;
504             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
505             value /= 10;
506         }
507         return string(buffer);
508     }
509 
510     /**
511      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
512      */
513     function toHexString(uint256 value) internal pure returns (string memory) {
514         if (value == 0) {
515             return "0x00";
516         }
517         uint256 temp = value;
518         uint256 length = 0;
519         while (temp != 0) {
520             length++;
521             temp >>= 8;
522         }
523         return toHexString(value, length);
524     }
525 
526     /**
527      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
528      */
529     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
530         bytes memory buffer = new bytes(2 * length + 2);
531         buffer[0] = "0";
532         buffer[1] = "x";
533         for (uint256 i = 2 * length + 1; i > 1; --i) {
534             buffer[i] = _HEX_SYMBOLS[value & 0xf];
535             value >>= 4;
536         }
537         require(value == 0, "Strings: hex length insufficient");
538         return string(buffer);
539     }
540 }
541 
542 // File: node_modules\@openzeppelin\contracts\utils\introspection\ERC165.sol
543 
544 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 
549 /**
550  * @dev Implementation of the {IERC165} interface.
551  *
552  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
553  * for the additional interface id that will be supported. For example:
554  *
555  * ```solidity
556  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
557  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
558  * }
559  * ```
560  *
561  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
562  */
563 abstract contract ERC165 is IERC165 {
564     /**
565      * @dev See {IERC165-supportsInterface}.
566      */
567     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
568         return interfaceId == type(IERC165).interfaceId;
569     }
570 }
571 
572 // File: @openzeppelin\contracts\token\ERC721\ERC721.sol
573 
574 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
575 
576 pragma solidity ^0.8.0;
577 
578 
579 
580 
581 
582 
583 
584 
585 /**
586  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
587  * the Metadata extension, but not including the Enumerable extension, which is available separately as
588  * {ERC721Enumerable}.
589  */
590 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
591     using Address for address;
592     using Strings for uint256;
593 
594     // Token name
595     string private _name;
596 
597     // Token symbol
598     string private _symbol;
599 
600     // Mapping from token ID to owner address
601     mapping(uint256 => address) private _owners;
602 
603     // Mapping owner address to token count
604     mapping(address => uint256) private _balances;
605 
606     // Mapping from token ID to approved address
607     mapping(uint256 => address) private _tokenApprovals;
608 
609     // Mapping from owner to operator approvals
610     mapping(address => mapping(address => bool)) private _operatorApprovals;
611 
612     /**
613      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
614      */
615     constructor(string memory name_, string memory symbol_) {
616         _name = name_;
617         _symbol = symbol_;
618     }
619 
620     /**
621      * @dev See {IERC165-supportsInterface}.
622      */
623     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
624         return
625             interfaceId == type(IERC721).interfaceId ||
626             interfaceId == type(IERC721Metadata).interfaceId ||
627             super.supportsInterface(interfaceId);
628     }
629 
630     /**
631      * @dev See {IERC721-balanceOf}.
632      */
633     function balanceOf(address owner) public view virtual override returns (uint256) {
634         require(owner != address(0), "ERC721: balance query for the zero address");
635         return _balances[owner];
636     }
637 
638     /**
639      * @dev See {IERC721-ownerOf}.
640      */
641     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
642         address owner = _owners[tokenId];
643         require(owner != address(0), "ERC721: owner query for nonexistent token");
644         return owner;
645     }
646 
647     /**
648      * @dev See {IERC721Metadata-name}.
649      */
650     function name() public view virtual override returns (string memory) {
651         return _name;
652     }
653 
654     /**
655      * @dev See {IERC721Metadata-symbol}.
656      */
657     function symbol() public view virtual override returns (string memory) {
658         return _symbol;
659     }
660 
661     /**
662      * @dev See {IERC721Metadata-tokenURI}.
663      */
664     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
665         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
666 
667         string memory baseURI = _baseURI();
668         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
669     }
670 
671     /**
672      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
673      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
674      * by default, can be overriden in child contracts.
675      */
676     function _baseURI() internal view virtual returns (string memory) {
677         return "";
678     }
679 
680     /**
681      * @dev See {IERC721-approve}.
682      */
683     function approve(address to, uint256 tokenId) public virtual override {
684         address owner = ERC721.ownerOf(tokenId);
685         require(to != owner, "ERC721: approval to current owner");
686 
687         require(
688             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
689             "ERC721: approve caller is not owner nor approved for all"
690         );
691 
692         _approve(to, tokenId);
693     }
694 
695     /**
696      * @dev See {IERC721-getApproved}.
697      */
698     function getApproved(uint256 tokenId) public view virtual override returns (address) {
699         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
700 
701         return _tokenApprovals[tokenId];
702     }
703 
704     /**
705      * @dev See {IERC721-setApprovalForAll}.
706      */
707     function setApprovalForAll(address operator, bool approved) public virtual override {
708         _setApprovalForAll(_msgSender(), operator, approved);
709     }
710 
711     /**
712      * @dev See {IERC721-isApprovedForAll}.
713      */
714     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
715         return _operatorApprovals[owner][operator];
716     }
717 
718     /**
719      * @dev See {IERC721-transferFrom}.
720      */
721     function transferFrom(
722         address from,
723         address to,
724         uint256 tokenId
725     ) public virtual override {
726         //solhint-disable-next-line max-line-length
727         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
728 
729         _transfer(from, to, tokenId);
730     }
731 
732     /**
733      * @dev See {IERC721-safeTransferFrom}.
734      */
735     function safeTransferFrom(
736         address from,
737         address to,
738         uint256 tokenId
739     ) public virtual override {
740         safeTransferFrom(from, to, tokenId, "");
741     }
742 
743     /**
744      * @dev See {IERC721-safeTransferFrom}.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId,
750         bytes memory _data
751     ) public virtual override {
752         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
753         _safeTransfer(from, to, tokenId, _data);
754     }
755 
756     /**
757      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
758      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
759      *
760      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
761      *
762      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
763      * implement alternative mechanisms to perform token transfer, such as signature-based.
764      *
765      * Requirements:
766      *
767      * - `from` cannot be the zero address.
768      * - `to` cannot be the zero address.
769      * - `tokenId` token must exist and be owned by `from`.
770      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
771      *
772      * Emits a {Transfer} event.
773      */
774     function _safeTransfer(
775         address from,
776         address to,
777         uint256 tokenId,
778         bytes memory _data
779     ) internal virtual {
780         _transfer(from, to, tokenId);
781         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
782     }
783 
784     /**
785      * @dev Returns whether `tokenId` exists.
786      *
787      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
788      *
789      * Tokens start existing when they are minted (`_mint`),
790      * and stop existing when they are burned (`_burn`).
791      */
792     function _exists(uint256 tokenId) internal view virtual returns (bool) {
793         return _owners[tokenId] != address(0);
794     }
795 
796     /**
797      * @dev Returns whether `spender` is allowed to manage `tokenId`.
798      *
799      * Requirements:
800      *
801      * - `tokenId` must exist.
802      */
803     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
804         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
805         address owner = ERC721.ownerOf(tokenId);
806         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
807     }
808 
809     /**
810      * @dev Safely mints `tokenId` and transfers it to `to`.
811      *
812      * Requirements:
813      *
814      * - `tokenId` must not exist.
815      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
816      *
817      * Emits a {Transfer} event.
818      */
819     function _safeMint(address to, uint256 tokenId) internal virtual {
820         _safeMint(to, tokenId, "");
821     }
822 
823     /**
824      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
825      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
826      */
827     function _safeMint(
828         address to,
829         uint256 tokenId,
830         bytes memory _data
831     ) internal virtual {
832         _mint(to, tokenId);
833         require(
834             _checkOnERC721Received(address(0), to, tokenId, _data),
835             "ERC721: transfer to non ERC721Receiver implementer"
836         );
837     }
838 
839     /**
840      * @dev Mints `tokenId` and transfers it to `to`.
841      *
842      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
843      *
844      * Requirements:
845      *
846      * - `tokenId` must not exist.
847      * - `to` cannot be the zero address.
848      *
849      * Emits a {Transfer} event.
850      */
851     function _mint(address to, uint256 tokenId) internal virtual {
852         require(to != address(0), "ERC721: mint to the zero address");
853         require(!_exists(tokenId), "ERC721: token already minted");
854 
855         _beforeTokenTransfer(address(0), to, tokenId);
856 
857         _balances[to] += 1;
858         _owners[tokenId] = to;
859 
860         emit Transfer(address(0), to, tokenId);
861     }
862 
863     /**
864      * @dev Destroys `tokenId`.
865      * The approval is cleared when the token is burned.
866      *
867      * Requirements:
868      *
869      * - `tokenId` must exist.
870      *
871      * Emits a {Transfer} event.
872      */
873     function _burn(uint256 tokenId) internal virtual {
874         address owner = ERC721.ownerOf(tokenId);
875 
876         _beforeTokenTransfer(owner, address(0), tokenId);
877 
878         // Clear approvals
879         _approve(address(0), tokenId);
880 
881         _balances[owner] -= 1;
882         delete _owners[tokenId];
883 
884         emit Transfer(owner, address(0), tokenId);
885     }
886 
887     /**
888      * @dev Transfers `tokenId` from `from` to `to`.
889      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
890      *
891      * Requirements:
892      *
893      * - `to` cannot be the zero address.
894      * - `tokenId` token must be owned by `from`.
895      *
896      * Emits a {Transfer} event.
897      */
898     function _transfer(
899         address from,
900         address to,
901         uint256 tokenId
902     ) internal virtual {
903         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
904         require(to != address(0), "ERC721: transfer to the zero address");
905 
906         _beforeTokenTransfer(from, to, tokenId);
907 
908         // Clear approvals from the previous owner
909         _approve(address(0), tokenId);
910 
911         _balances[from] -= 1;
912         _balances[to] += 1;
913         _owners[tokenId] = to;
914 
915         emit Transfer(from, to, tokenId);
916     }
917 
918     /**
919      * @dev Approve `to` to operate on `tokenId`
920      *
921      * Emits a {Approval} event.
922      */
923     function _approve(address to, uint256 tokenId) internal virtual {
924         _tokenApprovals[tokenId] = to;
925         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
926     }
927 
928     /**
929      * @dev Approve `operator` to operate on all of `owner` tokens
930      *
931      * Emits a {ApprovalForAll} event.
932      */
933     function _setApprovalForAll(
934         address owner,
935         address operator,
936         bool approved
937     ) internal virtual {
938         require(owner != operator, "ERC721: approve to caller");
939         _operatorApprovals[owner][operator] = approved;
940         emit ApprovalForAll(owner, operator, approved);
941     }
942 
943     /**
944      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
945      * The call is not executed if the target address is not a contract.
946      *
947      * @param from address representing the previous owner of the given token ID
948      * @param to target address that will receive the tokens
949      * @param tokenId uint256 ID of the token to be transferred
950      * @param _data bytes optional data to send along with the call
951      * @return bool whether the call correctly returned the expected magic value
952      */
953     function _checkOnERC721Received(
954         address from,
955         address to,
956         uint256 tokenId,
957         bytes memory _data
958     ) private returns (bool) {
959         if (to.isContract()) {
960             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
961                 return retval == IERC721Receiver.onERC721Received.selector;
962             } catch (bytes memory reason) {
963                 if (reason.length == 0) {
964                     revert("ERC721: transfer to non ERC721Receiver implementer");
965                 } else {
966                     assembly {
967                         revert(add(32, reason), mload(reason))
968                     }
969                 }
970             }
971         } else {
972             return true;
973         }
974     }
975 
976     /**
977      * @dev Hook that is called before any token transfer. This includes minting
978      * and burning.
979      *
980      * Calling conditions:
981      *
982      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
983      * transferred to `to`.
984      * - When `from` is zero, `tokenId` will be minted for `to`.
985      * - When `to` is zero, ``from``'s `tokenId` will be burned.
986      * - `from` and `to` are never both zero.
987      *
988      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
989      */
990     function _beforeTokenTransfer(
991         address from,
992         address to,
993         uint256 tokenId
994     ) internal virtual {}
995 }
996 
997 // File: @openzeppelin\contracts\access\Ownable.sol
998 
999 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1000 
1001 pragma solidity ^0.8.0;
1002 
1003 
1004 /**
1005  * @dev Contract module which provides a basic access control mechanism, where
1006  * there is an account (an owner) that can be granted exclusive access to
1007  * specific functions.
1008  *
1009  * By default, the owner account will be the one that deploys the contract. This
1010  * can later be changed with {transferOwnership}.
1011  *
1012  * This module is used through inheritance. It will make available the modifier
1013  * `onlyOwner`, which can be applied to your functions to restrict their use to
1014  * the owner.
1015  */
1016 abstract contract Ownable is Context {
1017     address private _owner;
1018 
1019     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1020 
1021     /**
1022      * @dev Initializes the contract setting the deployer as the initial owner.
1023      */
1024     constructor() {
1025         _transferOwnership(_msgSender());
1026     }
1027 
1028     /**
1029      * @dev Returns the address of the current owner.
1030      */
1031     function owner() public view virtual returns (address) {
1032         return _owner;
1033     }
1034 
1035     /**
1036      * @dev Throws if called by any account other than the owner.
1037      */
1038     modifier onlyOwner() {
1039         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1040         _;
1041     }
1042 
1043     /**
1044      * @dev Leaves the contract without owner. It will not be possible to call
1045      * `onlyOwner` functions anymore. Can only be called by the current owner.
1046      *
1047      * NOTE: Renouncing ownership will leave the contract without an owner,
1048      * thereby removing any functionality that is only available to the owner.
1049      */
1050     function renounceOwnership() public virtual onlyOwner {
1051         _transferOwnership(address(0));
1052     }
1053 
1054     /**
1055      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1056      * Can only be called by the current owner.
1057      */
1058     function transferOwnership(address newOwner) public virtual onlyOwner {
1059         require(newOwner != address(0), "Ownable: new owner is the zero address");
1060         _transferOwnership(newOwner);
1061     }
1062 
1063     /**
1064      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1065      * Internal function without access restriction.
1066      */
1067     function _transferOwnership(address newOwner) internal virtual {
1068         address oldOwner = _owner;
1069         _owner = newOwner;
1070         emit OwnershipTransferred(oldOwner, newOwner);
1071     }
1072 }
1073 
1074 // File: @openzeppelin\contracts\utils\cryptography\MerkleProof.sol
1075 
1076 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1077 
1078 pragma solidity ^0.8.0;
1079 
1080 /**
1081  * @dev These functions deal with verification of Merkle Trees proofs.
1082  *
1083  * The proofs can be generated using the JavaScript library
1084  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1085  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1086  *
1087  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1088  */
1089 library MerkleProof {
1090     /**
1091      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1092      * defined by `root`. For this, a `proof` must be provided, containing
1093      * sibling hashes on the branch from the leaf to the root of the tree. Each
1094      * pair of leaves and each pair of pre-images are assumed to be sorted.
1095      */
1096     function verify(
1097         bytes32[] memory proof,
1098         bytes32 root,
1099         bytes32 leaf
1100     ) internal pure returns (bool) {
1101         return processProof(proof, leaf) == root;
1102     }
1103 
1104     /**
1105      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1106      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1107      * hash matches the root of the tree. When processing the proof, the pairs
1108      * of leafs & pre-images are assumed to be sorted.
1109      *
1110      * _Available since v4.4._
1111      */
1112     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1113         bytes32 computedHash = leaf;
1114         for (uint256 i = 0; i < proof.length; i++) {
1115             bytes32 proofElement = proof[i];
1116             if (computedHash <= proofElement) {
1117                 // Hash(current computed hash + current element of the proof)
1118                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1119             } else {
1120                 // Hash(current element of the proof + current computed hash)
1121                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1122             }
1123         }
1124         return computedHash;
1125     }
1126 }
1127 
1128 // File: contracts\GossapeGirl.sol
1129 
1130 
1131 pragma solidity ^0.8.0;
1132 
1133 
1134 
1135 
1136 contract GossApeGirl is ERC721, Ownable  {
1137     //static variables
1138     uint256 public mintPrice = 0.049 ether;
1139     uint256 public mintPriceWhitelist = 0.03 ether;
1140     uint256 public maxSupply = 7000;
1141     uint256 public whitelistMaxPerTransaction = 5;
1142     uint256 public whitelistMaxPerWallet = 5;
1143     uint256 public publicMaxPerTransaction = 5;
1144 
1145     //state variables
1146     uint256 public whitelistStartSaleTimestamp = 0;
1147     uint256 public publicStartSaleTimestamp = 0; 
1148 
1149     //whitelisting variables
1150     bytes32 public root;
1151 
1152     //contract variables
1153     string public _baseURI_;
1154 
1155     //trackers
1156     uint256 public totalSupply = 0;
1157     mapping(address => uint256) public whitelistWalletMints;
1158 
1159     //withdraw wallet
1160     address payable public withdrawTo = payable(0x2C9bc65010D5ECC8d2F7dCe5DC492bE506593DfB);
1161 
1162     constructor() ERC721("GossApeGirl", "GG") {
1163         
1164     }
1165 
1166     //minting
1167     function mintMany(address _address, uint256 quantity) private {
1168         for (uint256 i = 0; i < quantity; i++) {
1169             mint(_address);
1170         }
1171     }
1172     function mint(address _address) internal {
1173         uint256 tokenId = totalSupply + 1;
1174         _safeMint(_address, tokenId);
1175         totalSupply++;
1176     }
1177 
1178     function whitelistMint(uint quantity, bytes32[] memory proof) public payable
1179     {
1180         require(totalSupply + quantity <= maxSupply, "Quantity exceeds max supply");
1181         require(quantity <= whitelistMaxPerTransaction, "Quantity exceeds max per transaction");
1182 
1183         require(isContract(msg.sender) == false, "Cannot mint from a contract");
1184         require(whitelistStartSaleTimestamp > 0 && block.timestamp - whitelistStartSaleTimestamp > 0, "Minting is not started");
1185         require(msg.value == mintPriceWhitelist * quantity, "Not enough ethers sent");
1186         require(whitelistWalletMints[msg.sender] + quantity <= whitelistMaxPerWallet,"Quantity exceeds max whitelist mints per wallet");
1187 
1188         require(verify(getLeaf(msg.sender), proof), "Invalid merkle proof");
1189 
1190         whitelistWalletMints[msg.sender] += quantity;
1191         mintMany(msg.sender, quantity);
1192     }
1193 
1194     function publicMint(uint quantity) public payable
1195     {
1196         require(totalSupply + quantity <= maxSupply, "Quantity exceeds max supply");
1197         require(quantity <= publicMaxPerTransaction, "Quantity exceeds max per transaction");
1198 
1199         require(isContract(msg.sender) == false, "Cannot mint from a contract");
1200         require(publicStartSaleTimestamp > 0 && block.timestamp - publicStartSaleTimestamp > 0, "Minting is not started");
1201         require(msg.value == mintPrice * quantity, "Not enough ethers sent");
1202 
1203         mintMany(msg.sender, quantity);
1204     }
1205 
1206     function ownerMint(address _address, uint quantity) public payable onlyOwner 
1207     {
1208         require(totalSupply + quantity <= maxSupply, "Quantity exceeds max supply");
1209 
1210         mintMany(_address, quantity);
1211     }
1212 
1213     //whitelisting
1214     function setMerkleRoot(bytes32 merkleroot) onlyOwner public 
1215     {
1216         root = merkleroot;
1217     }
1218 
1219     function verify(bytes32 leaf, bytes32[] memory proof) private view returns (bool)
1220     {
1221         return MerkleProof.verify(proof, root, leaf);
1222     }
1223 
1224     function getLeaf(address _address) private pure returns (bytes32)
1225     {
1226         return keccak256(abi.encodePacked(_address));
1227     }
1228 
1229     //owner functions
1230     function withdraw() onlyOwner public  {
1231         uint256 balance = address(this).balance;
1232         payable(withdrawTo).transfer(balance);
1233     }
1234 
1235     function setWithdrawTo(address _address) onlyOwner public  {
1236         withdrawTo = payable(_address);
1237     }
1238 
1239     function setMaxSupply(uint256 value) onlyOwner public  {
1240         maxSupply = value;
1241     }
1242 
1243     function setWhitelistStartSaleTimestamp(uint256 value) onlyOwner public  {
1244         whitelistStartSaleTimestamp = value;
1245     }
1246 
1247     function setPublicStartSaleTimestamp(uint256 value) onlyOwner public  {
1248         publicStartSaleTimestamp = value;
1249     }
1250 
1251     function setWhitelistMaxPerTransaction(uint256 value) onlyOwner public  {
1252         whitelistMaxPerTransaction = value;
1253     }
1254 
1255     function setPublicMaxPerTransaction(uint256 value) onlyOwner public  {
1256         publicMaxPerTransaction = value;
1257     }
1258 
1259     function setWhitelistMaxPerWallet(uint256 value) onlyOwner public  {
1260         whitelistMaxPerWallet = value;
1261     }
1262 
1263     function setMintPrice(uint256 priceWei) onlyOwner public  {
1264         mintPrice = priceWei;
1265     }
1266 
1267     function setMintPriceWhitelist(uint256 priceWei) onlyOwner public  {
1268         mintPriceWhitelist = priceWei;
1269     }
1270 
1271     function setBaseTokenURI(string memory uri) onlyOwner public {
1272         _baseURI_ = uri;
1273     }
1274 
1275     //helpers
1276     function isContract(address _address) private view returns (bool){
1277         uint32 size;
1278         assembly {
1279             size := extcodesize(_address)
1280         }
1281         return (size > 0);
1282     }
1283 
1284     function baseTokenURI() public view returns (string memory) {
1285         return _baseURI_;
1286     }
1287 
1288     function _baseURI() override internal view virtual returns (string memory) {
1289         return _baseURI_;
1290     }
1291 }