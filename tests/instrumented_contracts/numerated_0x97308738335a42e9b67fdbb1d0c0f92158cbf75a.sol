1 // SPDX-License-Identifier: GPL-3.0
2 // Based on HashLips code.
3 pragma solidity >=0.4.22 <0.9.0;
4 
5 
6 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 /**
32  * @dev Required interface of an ERC721 compliant contract.
33  */
34 interface IERC721 is IERC165 {
35     /**
36      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
37      */
38     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
42      */
43     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
47      */
48     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
49 
50     /**
51      * @dev Returns the number of tokens in ``owner``'s account.
52      */
53     function balanceOf(address owner) external view returns (uint256 balance);
54 
55     /**
56      * @dev Returns the owner of the `tokenId` token.
57      *
58      * Requirements:
59      *
60      * - `tokenId` must exist.
61      */
62     function ownerOf(uint256 tokenId) external view returns (address owner);
63 
64     /**
65      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
66      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(
79         address from,
80         address to,
81         uint256 tokenId
82     ) external;
83 
84     /**
85      * @dev Transfers `tokenId` token from `from` to `to`.
86      *
87      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must be owned by `from`.
94      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(
99         address from,
100         address to,
101         uint256 tokenId
102     ) external;
103 
104     /**
105      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
106      * The approval is cleared when the token is transferred.
107      *
108      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
109      *
110      * Requirements:
111      *
112      * - The caller must own the token or be an approved operator.
113      * - `tokenId` must exist.
114      *
115      * Emits an {Approval} event.
116      */
117     function approve(address to, uint256 tokenId) external;
118 
119     /**
120      * @dev Returns the account approved for `tokenId` token.
121      *
122      * Requirements:
123      *
124      * - `tokenId` must exist.
125      */
126     function getApproved(uint256 tokenId) external view returns (address operator);
127 
128     /**
129      * @dev Approve or remove `operator` as an operator for the caller.
130      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
131      *
132      * Requirements:
133      *
134      * - The `operator` cannot be the caller.
135      *
136      * Emits an {ApprovalForAll} event.
137      */
138     function setApprovalForAll(address operator, bool _approved) external;
139 
140     /**
141      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
142      *
143      * See {setApprovalForAll}
144      */
145     function isApprovedForAll(address owner, address operator) external view returns (bool);
146 
147     /**
148      * @dev Safely transfers `tokenId` token from `from` to `to`.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must exist and be owned by `from`.
155      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
157      *
158      * Emits a {Transfer} event.
159      */
160     function safeTransferFrom(
161         address from,
162         address to,
163         uint256 tokenId,
164         bytes calldata data
165     ) external;
166 }
167 
168 
169 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
170 
171 /**
172  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
173  * @dev See https://eips.ethereum.org/EIPS/eip-721
174  */
175 interface IERC721Enumerable is IERC721 {
176     /**
177      * @dev Returns the total amount of tokens stored by the contract.
178      */
179     function totalSupply() external view returns (uint256);
180 
181     /**
182      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
183      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
184      */
185     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
186 
187     /**
188      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
189      * Use along with {totalSupply} to enumerate all tokens.
190      */
191     function tokenByIndex(uint256 index) external view returns (uint256);
192 }
193 
194 
195 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
196 
197 /**
198  * @dev Implementation of the {IERC165} interface.
199  *
200  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
201  * for the additional interface id that will be supported. For example:
202  *
203  * ```solidity
204  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
205  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
206  * }
207  * ```
208  *
209  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
210  */
211 abstract contract ERC165 is IERC165 {
212     /**
213      * @dev See {IERC165-supportsInterface}.
214      */
215     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
216         return interfaceId == type(IERC165).interfaceId;
217     }
218 }
219 
220 // File: @openzeppelin/contracts/utils/Strings.sol
221 
222 /**
223  * @dev String operations.
224  */
225 library Strings {
226     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
227 
228     /**
229      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
230      */
231     function toString(uint256 value) internal pure returns (string memory) {
232         // Inspired by OraclizeAPI's implementation - MIT licence
233         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
234 
235         if (value == 0) {
236             return "0";
237         }
238         uint256 temp = value;
239         uint256 digits;
240         while (temp != 0) {
241             digits++;
242             temp /= 10;
243         }
244         bytes memory buffer = new bytes(digits);
245         while (value != 0) {
246             digits -= 1;
247             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
248             value /= 10;
249         }
250         return string(buffer);
251     }
252 
253     /**
254      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
255      */
256     function toHexString(uint256 value) internal pure returns (string memory) {
257         if (value == 0) {
258             return "0x00";
259         }
260         uint256 temp = value;
261         uint256 length = 0;
262         while (temp != 0) {
263             length++;
264             temp >>= 8;
265         }
266         return toHexString(value, length);
267     }
268 
269     /**
270      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
271      */
272     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
273         bytes memory buffer = new bytes(2 * length + 2);
274         buffer[0] = "0";
275         buffer[1] = "x";
276         for (uint256 i = 2 * length + 1; i > 1; --i) {
277             buffer[i] = _HEX_SYMBOLS[value & 0xf];
278             value >>= 4;
279         }
280         require(value == 0, "Strings: hex length insufficient");
281         return string(buffer);
282     }
283 }
284 
285 // File: @openzeppelin/contracts/utils/Address.sol
286 
287 
288 /**
289  * @dev Collection of functions related to the address type
290  */
291 library Address {
292     /**
293      * @dev Returns true if `account` is a contract.
294      *
295      * [IMPORTANT]
296      * ====
297      * It is unsafe to assume that an address for which this function returns
298      * false is an externally-owned account (EOA) and not a contract.
299      *
300      * Among others, `isContract` will return false for the following
301      * types of addresses:
302      *
303      *  - an externally-owned account
304      *  - a contract in construction
305      *  - an address where a contract will be created
306      *  - an address where a contract lived, but was destroyed
307      * ====
308      */
309     function isContract(address account) internal view returns (bool) {
310         // This method relies on extcodesize, which returns 0 for contracts in
311         // construction, since the code is only stored at the end of the
312         // constructor execution.
313 
314         uint256 size;
315         assembly {
316             size := extcodesize(account)
317         }
318         return size > 0;
319     }
320 
321     /**
322      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
323      * `recipient`, forwarding all available gas and reverting on errors.
324      *
325      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
326      * of certain opcodes, possibly making contracts go over the 2300 gas limit
327      * imposed by `transfer`, making them unable to receive funds via
328      * `transfer`. {sendValue} removes this limitation.
329      *
330      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
331      *
332      * IMPORTANT: because control is transferred to `recipient`, care must be
333      * taken to not create reentrancy vulnerabilities. Consider using
334      * {ReentrancyGuard} or the
335      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
336      */
337     function sendValue(address payable recipient, uint256 amount) internal {
338         require(address(this).balance >= amount, "Address: insufficient balance");
339 
340         (bool success, ) = recipient.call{value: amount}("");
341         require(success, "Address: unable to send value, recipient may have reverted");
342     }
343 
344     /**
345      * @dev Performs a Solidity function call using a low level `call`. A
346      * plain `call` is an unsafe replacement for a function call: use this
347      * function instead.
348      *
349      * If `target` reverts with a revert reason, it is bubbled up by this
350      * function (like regular Solidity function calls).
351      *
352      * Returns the raw returned data. To convert to the expected return value,
353      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
354      *
355      * Requirements:
356      *
357      * - `target` must be a contract.
358      * - calling `target` with `data` must not revert.
359      *
360      * _Available since v3.1._
361      */
362     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
363         return functionCall(target, data, "Address: low-level call failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
368      * `errorMessage` as a fallback revert reason when `target` reverts.
369      *
370      * _Available since v3.1._
371      */
372     function functionCall(
373         address target,
374         bytes memory data,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, 0, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but also transferring `value` wei to `target`.
383      *
384      * Requirements:
385      *
386      * - the calling contract must have an ETH balance of at least `value`.
387      * - the called Solidity function must be `payable`.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(
392         address target,
393         bytes memory data,
394         uint256 value
395     ) internal returns (bytes memory) {
396         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
401      * with `errorMessage` as a fallback revert reason when `target` reverts.
402      *
403      * _Available since v3.1._
404      */
405     function functionCallWithValue(
406         address target,
407         bytes memory data,
408         uint256 value,
409         string memory errorMessage
410     ) internal returns (bytes memory) {
411         require(address(this).balance >= value, "Address: insufficient balance for call");
412         require(isContract(target), "Address: call to non-contract");
413 
414         (bool success, bytes memory returndata) = target.call{value: value}(data);
415         return verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
420      * but performing a static call.
421      *
422      * _Available since v3.3._
423      */
424     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
425         return functionStaticCall(target, data, "Address: low-level static call failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
430      * but performing a static call.
431      *
432      * _Available since v3.3._
433      */
434     function functionStaticCall(
435         address target,
436         bytes memory data,
437         string memory errorMessage
438     ) internal view returns (bytes memory) {
439         require(isContract(target), "Address: static call to non-contract");
440 
441         (bool success, bytes memory returndata) = target.staticcall(data);
442         return verifyCallResult(success, returndata, errorMessage);
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
447      * but performing a delegate call.
448      *
449      * _Available since v3.4._
450      */
451     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
452         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
457      * but performing a delegate call.
458      *
459      * _Available since v3.4._
460      */
461     function functionDelegateCall(
462         address target,
463         bytes memory data,
464         string memory errorMessage
465     ) internal returns (bytes memory) {
466         require(isContract(target), "Address: delegate call to non-contract");
467 
468         (bool success, bytes memory returndata) = target.delegatecall(data);
469         return verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     /**
473      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
474      * revert reason using the provided one.
475      *
476      * _Available since v4.3._
477      */
478     function verifyCallResult(
479         bool success,
480         bytes memory returndata,
481         string memory errorMessage
482     ) internal pure returns (bytes memory) {
483         if (success) {
484             return returndata;
485         } else {
486             // Look for revert reason and bubble it up if present
487             if (returndata.length > 0) {
488                 // The easiest way to bubble the revert reason is using memory via assembly
489 
490                 assembly {
491                     let returndata_size := mload(returndata)
492                     revert(add(32, returndata), returndata_size)
493                 }
494             } else {
495                 revert(errorMessage);
496             }
497         }
498     }
499 }
500 
501 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
502 
503 
504 /**
505  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
506  * @dev See https://eips.ethereum.org/EIPS/eip-721
507  */
508 interface IERC721Metadata is IERC721 {
509     /**
510      * @dev Returns the token collection name.
511      */
512     function name() external view returns (string memory);
513 
514     /**
515      * @dev Returns the token collection symbol.
516      */
517     function symbol() external view returns (string memory);
518 
519     /**
520      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
521      */
522     function tokenURI(uint256 tokenId) external view returns (string memory);
523 }
524 
525 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
526 
527 
528 /**
529  * @title ERC721 token receiver interface
530  * @dev Interface for any contract that wants to support safeTransfers
531  * from ERC721 asset contracts.
532  */
533 interface IERC721Receiver {
534     /**
535      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
536      * by `operator` from `from`, this function is called.
537      *
538      * It must return its Solidity selector to confirm the token transfer.
539      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
540      *
541      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
542      */
543     function onERC721Received(
544         address operator,
545         address from,
546         uint256 tokenId,
547         bytes calldata data
548     ) external returns (bytes4);
549 }
550 
551 // File: @openzeppelin/contracts/utils/Context.sol
552 
553 /**
554  * @dev Provides information about the current execution context, including the
555  * sender of the transaction and its data. While these are generally available
556  * via msg.sender and msg.data, they should not be accessed in such a direct
557  * manner, since when dealing with meta-transactions the account sending and
558  * paying for execution may not be the actual sender (as far as an application
559  * is concerned).
560  *
561  * This contract is only required for intermediate, library-like contracts.
562  */
563 abstract contract Context {
564     function _msgSender() internal view virtual returns (address) {
565         return msg.sender;
566     }
567 
568     function _msgData() internal view virtual returns (bytes calldata) {
569         return msg.data;
570     }
571 }
572 
573 
574 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
575 
576 /**
577  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
578  * the Metadata extension, but not including the Enumerable extension, which is available separately as
579  * {ERC721Enumerable}.
580  */
581 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
582     using Address for address;
583     using Strings for uint256;
584 
585     // Token name
586     string private _name;
587 
588     // Token symbol
589     string private _symbol;
590 
591     // Mapping from token ID to owner address
592     mapping(uint256 => address) private _owners;
593 
594     // Mapping owner address to token count
595     mapping(address => uint256) private _balances;
596 
597     // Mapping from token ID to approved address
598     mapping(uint256 => address) private _tokenApprovals;
599 
600     // Mapping from owner to operator approvals
601     mapping(address => mapping(address => bool)) private _operatorApprovals;
602 
603     /**
604      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
605      */
606     constructor(string memory name_, string memory symbol_) {
607         _name = name_;
608         _symbol = symbol_;
609     }
610 
611     /**
612      * @dev See {IERC165-supportsInterface}.
613      */
614     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
615         return
616             interfaceId == type(IERC721).interfaceId ||
617             interfaceId == type(IERC721Metadata).interfaceId ||
618             super.supportsInterface(interfaceId);
619     }
620 
621     /**
622      * @dev See {IERC721-balanceOf}.
623      */
624     function balanceOf(address owner) public view virtual override returns (uint256) {
625         require(owner != address(0), "ERC721: balance query for the zero address");
626         return _balances[owner];
627     }
628 
629     /**
630      * @dev See {IERC721-ownerOf}.
631      */
632     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
633         address owner = _owners[tokenId];
634         require(owner != address(0), "ERC721: owner query for nonexistent token");
635         return owner;
636     }
637 
638     /**
639      * @dev See {IERC721Metadata-name}.
640      */
641     function name() public view virtual override returns (string memory) {
642         return _name;
643     }
644 
645     /**
646      * @dev See {IERC721Metadata-symbol}.
647      */
648     function symbol() public view virtual override returns (string memory) {
649         return _symbol;
650     }
651 
652     /**
653      * @dev See {IERC721Metadata-tokenURI}.
654      */
655     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
656         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
657 
658         string memory baseURI = _baseURI();
659         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
660     }
661 
662     /**
663      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
664      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
665      * by default, can be overriden in child contracts.
666      */
667     function _baseURI() internal view virtual returns (string memory) {
668         return "";
669     }
670 
671     /**
672      * @dev See {IERC721-approve}.
673      */
674     function approve(address to, uint256 tokenId) public virtual override {
675         address owner = ERC721.ownerOf(tokenId);
676         require(to != owner, "ERC721: approval to current owner");
677 
678         require(
679             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
680             "ERC721: approve caller is not owner nor approved for all"
681         );
682 
683         _approve(to, tokenId);
684     }
685 
686     /**
687      * @dev See {IERC721-getApproved}.
688      */
689     function getApproved(uint256 tokenId) public view virtual override returns (address) {
690         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
691 
692         return _tokenApprovals[tokenId];
693     }
694 
695     /**
696      * @dev See {IERC721-setApprovalForAll}.
697      */
698     function setApprovalForAll(address operator, bool approved) public virtual override {
699         require(operator != _msgSender(), "ERC721: approve to caller");
700 
701         _operatorApprovals[_msgSender()][operator] = approved;
702         emit ApprovalForAll(_msgSender(), operator, approved);
703     }
704 
705     /**
706      * @dev See {IERC721-isApprovedForAll}.
707      */
708     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
709         return _operatorApprovals[owner][operator];
710     }
711 
712     /**
713      * @dev See {IERC721-transferFrom}.
714      */
715     function transferFrom(
716         address from,
717         address to,
718         uint256 tokenId
719     ) public virtual override {
720         //solhint-disable-next-line max-line-length
721         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
722 
723         _transfer(from, to, tokenId);
724     }
725 
726     /**
727      * @dev See {IERC721-safeTransferFrom}.
728      */
729     function safeTransferFrom(
730         address from,
731         address to,
732         uint256 tokenId
733     ) public virtual override {
734         safeTransferFrom(from, to, tokenId, "");
735     }
736 
737     /**
738      * @dev See {IERC721-safeTransferFrom}.
739      */
740     function safeTransferFrom(
741         address from,
742         address to,
743         uint256 tokenId,
744         bytes memory _data
745     ) public virtual override {
746         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
747         _safeTransfer(from, to, tokenId, _data);
748     }
749 
750     /**
751      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
752      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
753      *
754      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
755      *
756      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
757      * implement alternative mechanisms to perform token transfer, such as signature-based.
758      *
759      * Requirements:
760      *
761      * - `from` cannot be the zero address.
762      * - `to` cannot be the zero address.
763      * - `tokenId` token must exist and be owned by `from`.
764      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
765      *
766      * Emits a {Transfer} event.
767      */
768     function _safeTransfer(
769         address from,
770         address to,
771         uint256 tokenId,
772         bytes memory _data
773     ) internal virtual {
774         _transfer(from, to, tokenId);
775         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
776     }
777 
778     /**
779      * @dev Returns whether `tokenId` exists.
780      *
781      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
782      *
783      * Tokens start existing when they are minted (`_mint`),
784      * and stop existing when they are burned (`_burn`).
785      */
786     function _exists(uint256 tokenId) internal view virtual returns (bool) {
787         return _owners[tokenId] != address(0);
788     }
789 
790     /**
791      * @dev Returns whether `spender` is allowed to manage `tokenId`.
792      *
793      * Requirements:
794      *
795      * - `tokenId` must exist.
796      */
797     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
798         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
799         address owner = ERC721.ownerOf(tokenId);
800         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
801     }
802 
803     /**
804      * @dev Safely mints `tokenId` and transfers it to `to`.
805      *
806      * Requirements:
807      *
808      * - `tokenId` must not exist.
809      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
810      *
811      * Emits a {Transfer} event.
812      */
813     function _safeMint(address to, uint256 tokenId) internal virtual {
814         _safeMint(to, tokenId, "");
815     }
816 
817     /**
818      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
819      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
820      */
821     function _safeMint(
822         address to,
823         uint256 tokenId,
824         bytes memory _data
825     ) internal virtual {
826         _mint(to, tokenId);
827         require(
828             _checkOnERC721Received(address(0), to, tokenId, _data),
829             "ERC721: transfer to non ERC721Receiver implementer"
830         );
831     }
832 
833     /**
834      * @dev Mints `tokenId` and transfers it to `to`.
835      *
836      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
837      *
838      * Requirements:
839      *
840      * - `tokenId` must not exist.
841      * - `to` cannot be the zero address.
842      *
843      * Emits a {Transfer} event.
844      */
845     function _mint(address to, uint256 tokenId) internal virtual {
846         require(to != address(0), "ERC721: mint to the zero address");
847         require(!_exists(tokenId), "ERC721: token already minted");
848 
849         _beforeTokenTransfer(address(0), to, tokenId);
850 
851         _balances[to] += 1;
852         _owners[tokenId] = to;
853 
854         emit Transfer(address(0), to, tokenId);
855     }
856 
857     /**
858      * @dev Destroys `tokenId`.
859      * The approval is cleared when the token is burned.
860      *
861      * Requirements:
862      *
863      * - `tokenId` must exist.
864      *
865      * Emits a {Transfer} event.
866      */
867     function _burn(uint256 tokenId) internal virtual {
868         address owner = ERC721.ownerOf(tokenId);
869 
870         _beforeTokenTransfer(owner, address(0), tokenId);
871 
872         // Clear approvals
873         _approve(address(0), tokenId);
874 
875         _balances[owner] -= 1;
876         delete _owners[tokenId];
877 
878         emit Transfer(owner, address(0), tokenId);
879     }
880 
881     /**
882      * @dev Transfers `tokenId` from `from` to `to`.
883      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
884      *
885      * Requirements:
886      *
887      * - `to` cannot be the zero address.
888      * - `tokenId` token must be owned by `from`.
889      *
890      * Emits a {Transfer} event.
891      */
892     function _transfer(
893         address from,
894         address to,
895         uint256 tokenId
896     ) internal virtual {
897         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
898         require(to != address(0), "ERC721: transfer to the zero address");
899 
900         _beforeTokenTransfer(from, to, tokenId);
901 
902         // Clear approvals from the previous owner
903         _approve(address(0), tokenId);
904 
905         _balances[from] -= 1;
906         _balances[to] += 1;
907         _owners[tokenId] = to;
908 
909         emit Transfer(from, to, tokenId);
910     }
911 
912     /**
913      * @dev Approve `to` to operate on `tokenId`
914      *
915      * Emits a {Approval} event.
916      */
917     function _approve(address to, uint256 tokenId) internal virtual {
918         _tokenApprovals[tokenId] = to;
919         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
920     }
921 
922     /**
923      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
924      * The call is not executed if the target address is not a contract.
925      *
926      * @param from address representing the previous owner of the given token ID
927      * @param to target address that will receive the tokens
928      * @param tokenId uint256 ID of the token to be transferred
929      * @param _data bytes optional data to send along with the call
930      * @return bool whether the call correctly returned the expected magic value
931      */
932     function _checkOnERC721Received(
933         address from,
934         address to,
935         uint256 tokenId,
936         bytes memory _data
937     ) private returns (bool) {
938         if (to.isContract()) {
939             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
940                 return retval == IERC721Receiver.onERC721Received.selector;
941             } catch (bytes memory reason) {
942                 if (reason.length == 0) {
943                     revert("ERC721: transfer to non ERC721Receiver implementer");
944                 } else {
945                     assembly {
946                         revert(add(32, reason), mload(reason))
947                     }
948                 }
949             }
950         } else {
951             return true;
952         }
953     }
954 
955     /**
956      * @dev Hook that is called before any token transfer. This includes minting
957      * and burning.
958      *
959      * Calling conditions:
960      *
961      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
962      * transferred to `to`.
963      * - When `from` is zero, `tokenId` will be minted for `to`.
964      * - When `to` is zero, ``from``'s `tokenId` will be burned.
965      * - `from` and `to` are never both zero.
966      *
967      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
968      */
969     function _beforeTokenTransfer(
970         address from,
971         address to,
972         uint256 tokenId
973     ) internal virtual {}
974 }
975 
976 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
977 
978 
979 /**
980  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
981  * enumerability of all the token ids in the contract as well as all token ids owned by each
982  * account.
983  */
984 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
985     // Mapping from owner to list of owned token IDs
986     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
987 
988     // Mapping from token ID to index of the owner tokens list
989     mapping(uint256 => uint256) private _ownedTokensIndex;
990 
991     // Array with all token ids, used for enumeration
992     uint256[] private _allTokens;
993 
994     // Mapping from token id to position in the allTokens array
995     mapping(uint256 => uint256) private _allTokensIndex;
996 
997     /**
998      * @dev See {IERC165-supportsInterface}.
999      */
1000     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1001         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1002     }
1003 
1004     /**
1005      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1006      */
1007     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1008         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1009         return _ownedTokens[owner][index];
1010     }
1011 
1012     /**
1013      * @dev See {IERC721Enumerable-totalSupply}.
1014      */
1015     function totalSupply() public view virtual override returns (uint256) {
1016         return _allTokens.length;
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Enumerable-tokenByIndex}.
1021      */
1022     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1023         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1024         return _allTokens[index];
1025     }
1026 
1027     /**
1028      * @dev Hook that is called before any token transfer. This includes minting
1029      * and burning.
1030      *
1031      * Calling conditions:
1032      *
1033      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1034      * transferred to `to`.
1035      * - When `from` is zero, `tokenId` will be minted for `to`.
1036      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1037      * - `from` cannot be the zero address.
1038      * - `to` cannot be the zero address.
1039      *
1040      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1041      */
1042     function _beforeTokenTransfer(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) internal virtual override {
1047         super._beforeTokenTransfer(from, to, tokenId);
1048 
1049         if (from == address(0)) {
1050             _addTokenToAllTokensEnumeration(tokenId);
1051         } else if (from != to) {
1052             _removeTokenFromOwnerEnumeration(from, tokenId);
1053         }
1054         if (to == address(0)) {
1055             _removeTokenFromAllTokensEnumeration(tokenId);
1056         } else if (to != from) {
1057             _addTokenToOwnerEnumeration(to, tokenId);
1058         }
1059     }
1060 
1061     /**
1062      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1063      * @param to address representing the new owner of the given token ID
1064      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1065      */
1066     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1067         uint256 length = ERC721.balanceOf(to);
1068         _ownedTokens[to][length] = tokenId;
1069         _ownedTokensIndex[tokenId] = length;
1070     }
1071 
1072     /**
1073      * @dev Private function to add a token to this extension's token tracking data structures.
1074      * @param tokenId uint256 ID of the token to be added to the tokens list
1075      */
1076     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1077         _allTokensIndex[tokenId] = _allTokens.length;
1078         _allTokens.push(tokenId);
1079     }
1080 
1081     /**
1082      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1083      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1084      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1085      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1086      * @param from address representing the previous owner of the given token ID
1087      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1088      */
1089     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1090         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1091         // then delete the last slot (swap and pop).
1092 
1093         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1094         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1095 
1096         // When the token to delete is the last token, the swap operation is unnecessary
1097         if (tokenIndex != lastTokenIndex) {
1098             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1099 
1100             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1101             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1102         }
1103 
1104         // This also deletes the contents at the last position of the array
1105         delete _ownedTokensIndex[tokenId];
1106         delete _ownedTokens[from][lastTokenIndex];
1107     }
1108 
1109     /**
1110      * @dev Private function to remove a token from this extension's token tracking data structures.
1111      * This has O(1) time complexity, but alters the order of the _allTokens array.
1112      * @param tokenId uint256 ID of the token to be removed from the tokens list
1113      */
1114     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1115         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1116         // then delete the last slot (swap and pop).
1117 
1118         uint256 lastTokenIndex = _allTokens.length - 1;
1119         uint256 tokenIndex = _allTokensIndex[tokenId];
1120 
1121         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1122         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1123         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1124         uint256 lastTokenId = _allTokens[lastTokenIndex];
1125 
1126         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1127         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1128 
1129         // This also deletes the contents at the last position of the array
1130         delete _allTokensIndex[tokenId];
1131         _allTokens.pop();
1132     }
1133 }
1134 
1135 
1136 // File: @openzeppelin/contracts/access/Ownable.sol
1137 
1138 /**
1139  * @dev Contract module which provides a basic access control mechanism, where
1140  * there is an account (an owner) that can be granted exclusive access to
1141  * specific functions.
1142  *
1143  * By default, the owner account will be the one that deploys the contract. This
1144  * can later be changed with {transferOwnership}.
1145  *
1146  * This module is used through inheritance. It will make available the modifier
1147  * `onlyOwner`, which can be applied to your functions to restrict their use to
1148  * the owner.
1149  */
1150 abstract contract Ownable is Context {
1151     address private _owner;
1152 
1153     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1154 
1155     /**
1156      * @dev Initializes the contract setting the deployer as the initial owner.
1157      */
1158     constructor() {
1159         _setOwner(_msgSender());
1160     }
1161 
1162     /**
1163      * @dev Returns the address of the current owner.
1164      */
1165     function owner() public view virtual returns (address) {
1166         return _owner;
1167     }
1168 
1169     /**
1170      * @dev Throws if called by any account other than the owner.
1171      */
1172     modifier onlyOwner() {
1173         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1174         _;
1175     }
1176 
1177     /**
1178      * @dev Leaves the contract without owner. It will not be possible to call
1179      * `onlyOwner` functions anymore. Can only be called by the current owner.
1180      *
1181      * NOTE: Renouncing ownership will leave the contract without an owner,
1182      * thereby removing any functionality that is only available to the owner.
1183      */
1184     function renounceOwnership() public virtual onlyOwner {
1185         _setOwner(address(0));
1186     }
1187 
1188     /**
1189      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1190      * Can only be called by the current owner.
1191      */
1192     function transferOwnership(address newOwner) public virtual onlyOwner {
1193         require(newOwner != address(0), "Ownable: new owner is the zero address");
1194         _setOwner(newOwner);
1195     }
1196 
1197     function _setOwner(address newOwner) private {
1198         address oldOwner = _owner;
1199         _owner = newOwner;
1200         emit OwnershipTransferred(oldOwner, newOwner);
1201     }
1202 }
1203 
1204 contract PunkachuNFT is ERC721Enumerable, Ownable {
1205   using Strings for uint256;
1206 
1207   string public baseURI;
1208   string public baseExtension = ".json";
1209   uint256 public cost = 30000000000000000; // 0.03 eth
1210   uint256 public maxSupply = 2900;
1211   uint256 public maxMintAmountPerTransaction = 20;
1212   uint256 public maxPresaleMintAmount = 3;
1213   uint256 public NFTPerAddressLimit = 20;
1214   bool public paused = true;
1215   bool public presale = true;
1216   address[] private airdropList;
1217   address[] private whiteList;
1218 
1219   constructor(string memory _initBaseURI) ERC721("Punkachus", "PKCHU") {
1220     setBaseURI(_initBaseURI);
1221     _safeMint(msg.sender, 1);
1222   }
1223 
1224   // internal
1225   function _baseURI() internal view virtual override returns (string memory) {
1226     return baseURI;
1227   }
1228 
1229   // public
1230   function mintPunkachus(uint256 _mintAmount) public payable {
1231 
1232     require(!paused, "The sale is paused");
1233     uint256 supply = totalSupply();
1234     require(_mintAmount > 0, "Need to mint at least 1 NFT");
1235     require(supply + _mintAmount <= maxSupply, "Max NFT limit exceeded");
1236 
1237     if (!presale)
1238     // Normal Minting code
1239     {
1240       if (msg.sender != owner()) 
1241       {
1242         require(_mintAmount <= maxMintAmountPerTransaction, "Max mint amount per session exceeded");
1243         require(balanceOf(msg.sender) + _mintAmount <= NFTPerAddressLimit, "NFT Limit per Account reached");
1244         require(msg.value >= cost * _mintAmount, "Insufficient funds");
1245       }
1246     }
1247     else
1248     // Presale code
1249     {
1250       require(isAccountWhiteListed(msg.sender), "Account not eligible for presale");
1251       require(balanceOf(msg.sender) + _mintAmount <= maxPresaleMintAmount, "NFT Limit per Account reached for presale");
1252     }
1253 
1254     for (uint256 i = 1; i <= _mintAmount; i++) {
1255       _safeMint(msg.sender, supply + i);
1256     }
1257   }
1258 
1259   function walletOfOwner(address _owner) public view returns (uint256[] memory)
1260   {
1261     uint256 ownerTokenCount = balanceOf(_owner);
1262     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1263     for (uint256 i; i < ownerTokenCount; i++) {
1264       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1265     }
1266     return tokenIds;
1267   }
1268 
1269   function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1270   {
1271     require(
1272       _exists(tokenId),
1273       "ERC721Metadata: URI query for nonexistent token"
1274     );
1275 
1276     string memory currentBaseURI = _baseURI();
1277     return bytes(currentBaseURI).length > 0
1278       ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1279       : "";
1280   }
1281 
1282   function isAccountWhiteListed(address _account) public view returns (bool) {
1283     for (uint256 i = 0; i < whiteList.length; i++)
1284     {
1285       if (_account == whiteList[i]){
1286         return true;
1287       }
1288     }
1289     return false;
1290   }
1291 
1292   //only contract owner
1293 
1294   function airdropToList() public payable onlyOwner {
1295     require(!paused, "The sale is paused");
1296     uint256 supply = totalSupply();
1297     require(supply + airdropList.length <= maxSupply, "Max NFT limit exceeded");
1298 
1299     for (uint256 i = 0; i < airdropList.length; i++) 
1300     {
1301       if (balanceOf(airdropList[i]) < NFTPerAddressLimit)
1302       {
1303         _safeMint(airdropList[i], supply + i + 1);
1304       }
1305     }
1306   }
1307 
1308   function setCost(uint256 _newCost) public onlyOwner {
1309     cost = _newCost;
1310   }
1311 
1312   function setMaxMintAmountPerTransaction(uint256 _newmaxMintAmount) public onlyOwner {
1313     maxMintAmountPerTransaction = _newmaxMintAmount;
1314   }
1315 
1316   function setNFTPerAddressLimit(uint256 _newNFTPerAddressLimit) public onlyOwner {
1317     NFTPerAddressLimit = _newNFTPerAddressLimit;
1318   }
1319 
1320   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1321     baseURI = _newBaseURI;
1322   }
1323 
1324   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1325     baseExtension = _newBaseExtension;
1326   }
1327 
1328   function flipPause() public onlyOwner {
1329     paused = !paused;
1330   }
1331 
1332   function flipPresale() public onlyOwner {
1333     presale = !presale;
1334   }
1335 
1336   function setAirdropList(address[] calldata _users) public onlyOwner {
1337     delete airdropList;
1338     airdropList = _users;
1339   }
1340 
1341   function getAirdropList() public view onlyOwner returns (address[] memory) {
1342     return airdropList;
1343   }
1344 
1345   function setWhiteList(address[] calldata _users) public onlyOwner {
1346     delete whiteList;
1347     whiteList = _users;
1348   }
1349 
1350   function getWhiteList() public view onlyOwner returns (address[] memory) {
1351     return whiteList;
1352   }
1353  
1354   function withdraw() public onlyOwner {
1355     uint256 balance = address(this).balance;
1356     payable(msg.sender).transfer(balance);
1357   }
1358 }