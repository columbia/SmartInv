1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 pragma solidity ^0.8.0;
3 /**
4  * @dev Interface of the ERC165 standard, as defined in the
5  * https://eips.ethereum.org/EIPS/eip-165[EIP].
6  *
7  * Implementers can declare support of contract interfaces, which can then be
8  * queried by others ({ERC165Checker}).
9  *
10  * For an implementation, see {ERC165}.
11  */
12 interface IERC165 {
13     /**
14      * @dev Returns true if this contract implements the interface defined by
15      * `interfaceId`. See the corresponding
16      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
17      * to learn more about how these ids are created.
18      *
19      * This function call must use less than 30 000 gas.
20      */
21     function supportsInterface(bytes4 interfaceId) external view returns (bool);
22 }
23 
24 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
25 pragma solidity ^0.8.0;
26 /**
27  * @dev Required interface of an ERC721 compliant contract.
28  */
29 interface IERC721 is IERC165 {
30     /**
31      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
32      */
33     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
34 
35     /**
36      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
37      */
38     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
42      */
43     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
44 
45     /**
46      * @dev Returns the number of tokens in ``owner``'s account.
47      */
48     function balanceOf(address owner) external view returns (uint256 balance);
49 
50     /**
51      * @dev Returns the owner of the `tokenId` token.
52      *
53      * Requirements:
54      *
55      * - `tokenId` must exist.
56      */
57     function ownerOf(uint256 tokenId) external view returns (address owner);
58 
59     /**
60      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
61      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
62      *
63      * Requirements:
64      *
65      * - `from` cannot be the zero address.
66      * - `to` cannot be the zero address.
67      * - `tokenId` token must exist and be owned by `from`.
68      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
69      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
70      *
71      * Emits a {Transfer} event.
72      */
73     function safeTransferFrom(
74         address from,
75         address to,
76         uint256 tokenId
77     ) external;
78 
79     /**
80      * @dev Transfers `tokenId` token from `from` to `to`.
81      *
82      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must be owned by `from`.
89      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(
94         address from,
95         address to,
96         uint256 tokenId
97     ) external;
98 
99     /**
100      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
101      * The approval is cleared when the token is transferred.
102      *
103      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
104      *
105      * Requirements:
106      *
107      * - The caller must own the token or be an approved operator.
108      * - `tokenId` must exist.
109      *
110      * Emits an {Approval} event.
111      */
112     function approve(address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Returns the account approved for `tokenId` token.
116      *
117      * Requirements:
118      *
119      * - `tokenId` must exist.
120      */
121     function getApproved(uint256 tokenId) external view returns (address operator);
122 
123     /**
124      * @dev Approve or remove `operator` as an operator for the caller.
125      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
126      *
127      * Requirements:
128      *
129      * - The `operator` cannot be the caller.
130      *
131      * Emits an {ApprovalForAll} event.
132      */
133     function setApprovalForAll(address operator, bool _approved) external;
134 
135     /**
136      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
137      *
138      * See {setApprovalForAll}
139      */
140     function isApprovedForAll(address owner, address operator) external view returns (bool);
141 
142     /**
143      * @dev Safely transfers `tokenId` token from `from` to `to`.
144      *
145      * Requirements:
146      *
147      * - `from` cannot be the zero address.
148      * - `to` cannot be the zero address.
149      * - `tokenId` token must exist and be owned by `from`.
150      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
152      *
153      * Emits a {Transfer} event.
154      */
155     function safeTransferFrom(
156         address from,
157         address to,
158         uint256 tokenId,
159         bytes calldata data
160     ) external;
161 }
162 
163 
164 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
165 pragma solidity ^0.8.0;
166 /**
167  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
168  * @dev See https://eips.ethereum.org/EIPS/eip-721
169  */
170 interface IERC721Enumerable is IERC721 {
171     /**
172      * @dev Returns the total amount of tokens stored by the contract.
173      */
174     function totalSupply() external view returns (uint256);
175 
176     /**
177      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
178      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
179      */
180     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
181 
182     /**
183      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
184      * Use along with {totalSupply} to enumerate all tokens.
185      */
186     function tokenByIndex(uint256 index) external view returns (uint256);
187 }
188 
189 
190 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
191 pragma solidity ^0.8.0;
192 /**
193  * @dev Implementation of the {IERC165} interface.
194  *
195  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
196  * for the additional interface id that will be supported. For example:
197  *
198  * ```solidity
199  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
200  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
201  * }
202  * ```
203  *
204  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
205  */
206 abstract contract ERC165 is IERC165 {
207     /**
208      * @dev See {IERC165-supportsInterface}.
209      */
210     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
211         return interfaceId == type(IERC165).interfaceId;
212     }
213 }
214 
215 // File: @openzeppelin/contracts/utils/Strings.sol
216 
217 
218 
219 pragma solidity ^0.8.0;
220 
221 /**
222  * @dev String operations.
223  */
224 library Strings {
225     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
226 
227     /**
228      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
229      */
230     function toString(uint256 value) internal pure returns (string memory) {
231         // Inspired by OraclizeAPI's implementation - MIT licence
232         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
233 
234         if (value == 0) {
235             return "0";
236         }
237         uint256 temp = value;
238         uint256 digits;
239         while (temp != 0) {
240             digits++;
241             temp /= 10;
242         }
243         bytes memory buffer = new bytes(digits);
244         while (value != 0) {
245             digits -= 1;
246             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
247             value /= 10;
248         }
249         return string(buffer);
250     }
251 
252     /**
253      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
254      */
255     function toHexString(uint256 value) internal pure returns (string memory) {
256         if (value == 0) {
257             return "0x00";
258         }
259         uint256 temp = value;
260         uint256 length = 0;
261         while (temp != 0) {
262             length++;
263             temp >>= 8;
264         }
265         return toHexString(value, length);
266     }
267 
268     /**
269      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
270      */
271     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
272         bytes memory buffer = new bytes(2 * length + 2);
273         buffer[0] = "0";
274         buffer[1] = "x";
275         for (uint256 i = 2 * length + 1; i > 1; --i) {
276             buffer[i] = _HEX_SYMBOLS[value & 0xf];
277             value >>= 4;
278         }
279         require(value == 0, "Strings: hex length insufficient");
280         return string(buffer);
281     }
282 }
283 
284 // File: @openzeppelin/contracts/utils/Address.sol
285 
286 
287 
288 pragma solidity ^0.8.0;
289 
290 /**
291  * @dev Collection of functions related to the address type
292  */
293 library Address {
294     /**
295      * @dev Returns true if `account` is a contract.
296      *
297      * [IMPORTANT]
298      * ====
299      * It is unsafe to assume that an address for which this function returns
300      * false is an externally-owned account (EOA) and not a contract.
301      *
302      * Among others, `isContract` will return false for the following
303      * types of addresses:
304      *
305      *  - an externally-owned account
306      *  - a contract in construction
307      *  - an address where a contract will be created
308      *  - an address where a contract lived, but was destroyed
309      * ====
310      */
311     function isContract(address account) internal view returns (bool) {
312         // This method relies on extcodesize, which returns 0 for contracts in
313         // construction, since the code is only stored at the end of the
314         // constructor execution.
315 
316         uint256 size;
317         assembly {
318             size := extcodesize(account)
319         }
320         return size > 0;
321     }
322 
323     /**
324      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
325      * `recipient`, forwarding all available gas and reverting on errors.
326      *
327      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
328      * of certain opcodes, possibly making contracts go over the 2300 gas limit
329      * imposed by `transfer`, making them unable to receive funds via
330      * `transfer`. {sendValue} removes this limitation.
331      *
332      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
333      *
334      * IMPORTANT: because control is transferred to `recipient`, care must be
335      * taken to not create reentrancy vulnerabilities. Consider using
336      * {ReentrancyGuard} or the
337      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
338      */
339     function sendValue(address payable recipient, uint256 amount) internal {
340         require(address(this).balance >= amount, "Address: insufficient balance");
341 
342         (bool success, ) = recipient.call{value: amount}("");
343         require(success, "Address: unable to send value, recipient may have reverted");
344     }
345 
346     /**
347      * @dev Performs a Solidity function call using a low level `call`. A
348      * plain `call` is an unsafe replacement for a function call: use this
349      * function instead.
350      *
351      * If `target` reverts with a revert reason, it is bubbled up by this
352      * function (like regular Solidity function calls).
353      *
354      * Returns the raw returned data. To convert to the expected return value,
355      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
356      *
357      * Requirements:
358      *
359      * - `target` must be a contract.
360      * - calling `target` with `data` must not revert.
361      *
362      * _Available since v3.1._
363      */
364     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
365         return functionCall(target, data, "Address: low-level call failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
370      * `errorMessage` as a fallback revert reason when `target` reverts.
371      *
372      * _Available since v3.1._
373      */
374     function functionCall(
375         address target,
376         bytes memory data,
377         string memory errorMessage
378     ) internal returns (bytes memory) {
379         return functionCallWithValue(target, data, 0, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but also transferring `value` wei to `target`.
385      *
386      * Requirements:
387      *
388      * - the calling contract must have an ETH balance of at least `value`.
389      * - the called Solidity function must be `payable`.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(
394         address target,
395         bytes memory data,
396         uint256 value
397     ) internal returns (bytes memory) {
398         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
403      * with `errorMessage` as a fallback revert reason when `target` reverts.
404      *
405      * _Available since v3.1._
406      */
407     function functionCallWithValue(
408         address target,
409         bytes memory data,
410         uint256 value,
411         string memory errorMessage
412     ) internal returns (bytes memory) {
413         require(address(this).balance >= value, "Address: insufficient balance for call");
414         require(isContract(target), "Address: call to non-contract");
415 
416         (bool success, bytes memory returndata) = target.call{value: value}(data);
417         return verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
422      * but performing a static call.
423      *
424      * _Available since v3.3._
425      */
426     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
427         return functionStaticCall(target, data, "Address: low-level static call failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
432      * but performing a static call.
433      *
434      * _Available since v3.3._
435      */
436     function functionStaticCall(
437         address target,
438         bytes memory data,
439         string memory errorMessage
440     ) internal view returns (bytes memory) {
441         require(isContract(target), "Address: static call to non-contract");
442 
443         (bool success, bytes memory returndata) = target.staticcall(data);
444         return verifyCallResult(success, returndata, errorMessage);
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
449      * but performing a delegate call.
450      *
451      * _Available since v3.4._
452      */
453     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
454         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
459      * but performing a delegate call.
460      *
461      * _Available since v3.4._
462      */
463     function functionDelegateCall(
464         address target,
465         bytes memory data,
466         string memory errorMessage
467     ) internal returns (bytes memory) {
468         require(isContract(target), "Address: delegate call to non-contract");
469 
470         (bool success, bytes memory returndata) = target.delegatecall(data);
471         return verifyCallResult(success, returndata, errorMessage);
472     }
473 
474     /**
475      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
476      * revert reason using the provided one.
477      *
478      * _Available since v4.3._
479      */
480     function verifyCallResult(
481         bool success,
482         bytes memory returndata,
483         string memory errorMessage
484     ) internal pure returns (bytes memory) {
485         if (success) {
486             return returndata;
487         } else {
488             // Look for revert reason and bubble it up if present
489             if (returndata.length > 0) {
490                 // The easiest way to bubble the revert reason is using memory via assembly
491 
492                 assembly {
493                     let returndata_size := mload(returndata)
494                     revert(add(32, returndata), returndata_size)
495                 }
496             } else {
497                 revert(errorMessage);
498             }
499         }
500     }
501 }
502 
503 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
504 
505 
506 
507 pragma solidity ^0.8.0;
508 
509 
510 /**
511  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
512  * @dev See https://eips.ethereum.org/EIPS/eip-721
513  */
514 interface IERC721Metadata is IERC721 {
515     /**
516      * @dev Returns the token collection name.
517      */
518     function name() external view returns (string memory);
519 
520     /**
521      * @dev Returns the token collection symbol.
522      */
523     function symbol() external view returns (string memory);
524 
525     /**
526      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
527      */
528     function tokenURI(uint256 tokenId) external view returns (string memory);
529 }
530 
531 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
532 
533 
534 
535 pragma solidity ^0.8.0;
536 
537 /**
538  * @title ERC721 token receiver interface
539  * @dev Interface for any contract that wants to support safeTransfers
540  * from ERC721 asset contracts.
541  */
542 interface IERC721Receiver {
543     /**
544      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
545      * by `operator` from `from`, this function is called.
546      *
547      * It must return its Solidity selector to confirm the token transfer.
548      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
549      *
550      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
551      */
552     function onERC721Received(
553         address operator,
554         address from,
555         uint256 tokenId,
556         bytes calldata data
557     ) external returns (bytes4);
558 }
559 
560 // File: @openzeppelin/contracts/utils/Context.sol
561 pragma solidity ^0.8.0;
562 /**
563  * @dev Provides information about the current execution context, including the
564  * sender of the transaction and its data. While these are generally available
565  * via msg.sender and msg.data, they should not be accessed in such a direct
566  * manner, since when dealing with meta-transactions the account sending and
567  * paying for execution may not be the actual sender (as far as an application
568  * is concerned).
569  *
570  * This contract is only required for intermediate, library-like contracts.
571  */
572 abstract contract Context {
573     function _msgSender() internal view virtual returns (address) {
574         return msg.sender;
575     }
576 
577     function _msgData() internal view virtual returns (bytes calldata) {
578         return msg.data;
579     }
580 }
581 
582 
583 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
584 pragma solidity ^0.8.0;
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
708         require(operator != _msgSender(), "ERC721: approve to caller");
709 
710         _operatorApprovals[_msgSender()][operator] = approved;
711         emit ApprovalForAll(_msgSender(), operator, approved);
712     }
713 
714     /**
715      * @dev See {IERC721-isApprovedForAll}.
716      */
717     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
718         return _operatorApprovals[owner][operator];
719     }
720 
721     /**
722      * @dev See {IERC721-transferFrom}.
723      */
724     function transferFrom(
725         address from,
726         address to,
727         uint256 tokenId
728     ) public virtual override {
729         //solhint-disable-next-line max-line-length
730         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
731 
732         _transfer(from, to, tokenId);
733     }
734 
735     /**
736      * @dev See {IERC721-safeTransferFrom}.
737      */
738     function safeTransferFrom(
739         address from,
740         address to,
741         uint256 tokenId
742     ) public virtual override {
743         safeTransferFrom(from, to, tokenId, "");
744     }
745 
746     /**
747      * @dev See {IERC721-safeTransferFrom}.
748      */
749     function safeTransferFrom(
750         address from,
751         address to,
752         uint256 tokenId,
753         bytes memory _data
754     ) public virtual override {
755         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
756         _safeTransfer(from, to, tokenId, _data);
757     }
758 
759     /**
760      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
761      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
762      *
763      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
764      *
765      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
766      * implement alternative mechanisms to perform token transfer, such as signature-based.
767      *
768      * Requirements:
769      *
770      * - `from` cannot be the zero address.
771      * - `to` cannot be the zero address.
772      * - `tokenId` token must exist and be owned by `from`.
773      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
774      *
775      * Emits a {Transfer} event.
776      */
777     function _safeTransfer(
778         address from,
779         address to,
780         uint256 tokenId,
781         bytes memory _data
782     ) internal virtual {
783         _transfer(from, to, tokenId);
784         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
785     }
786 
787     /**
788      * @dev Returns whether `tokenId` exists.
789      *
790      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
791      *
792      * Tokens start existing when they are minted (`_mint`),
793      * and stop existing when they are burned (`_burn`).
794      */
795     function _exists(uint256 tokenId) internal view virtual returns (bool) {
796         return _owners[tokenId] != address(0);
797     }
798 
799     /**
800      * @dev Returns whether `spender` is allowed to manage `tokenId`.
801      *
802      * Requirements:
803      *
804      * - `tokenId` must exist.
805      */
806     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
807         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
808         address owner = ERC721.ownerOf(tokenId);
809         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
810     }
811 
812     /**
813      * @dev Safely mints `tokenId` and transfers it to `to`.
814      *
815      * Requirements:
816      *
817      * - `tokenId` must not exist.
818      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
819      *
820      * Emits a {Transfer} event.
821      */
822     function _safeMint(address to, uint256 tokenId) internal virtual {
823         _safeMint(to, tokenId, "");
824     }
825 
826     /**
827      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
828      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
829      */
830     function _safeMint(
831         address to,
832         uint256 tokenId,
833         bytes memory _data
834     ) internal virtual {
835         _mint(to, tokenId);
836         require(
837             _checkOnERC721Received(address(0), to, tokenId, _data),
838             "ERC721: transfer to non ERC721Receiver implementer"
839         );
840     }
841 
842     /**
843      * @dev Mints `tokenId` and transfers it to `to`.
844      *
845      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
846      *
847      * Requirements:
848      *
849      * - `tokenId` must not exist.
850      * - `to` cannot be the zero address.
851      *
852      * Emits a {Transfer} event.
853      */
854     function _mint(address to, uint256 tokenId) internal virtual {
855         require(to != address(0), "ERC721: mint to the zero address");
856         require(!_exists(tokenId), "ERC721: token already minted");
857 
858         _beforeTokenTransfer(address(0), to, tokenId);
859 
860         _balances[to] += 1;
861         _owners[tokenId] = to;
862 
863         emit Transfer(address(0), to, tokenId);
864     }
865 
866     /**
867      * @dev Destroys `tokenId`.
868      * The approval is cleared when the token is burned.
869      *
870      * Requirements:
871      *
872      * - `tokenId` must exist.
873      *
874      * Emits a {Transfer} event.
875      */
876     function _burn(uint256 tokenId) internal virtual {
877         address owner = ERC721.ownerOf(tokenId);
878 
879         _beforeTokenTransfer(owner, address(0), tokenId);
880 
881         // Clear approvals
882         _approve(address(0), tokenId);
883 
884         _balances[owner] -= 1;
885         delete _owners[tokenId];
886 
887         emit Transfer(owner, address(0), tokenId);
888     }
889 
890     /**
891      * @dev Transfers `tokenId` from `from` to `to`.
892      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
893      *
894      * Requirements:
895      *
896      * - `to` cannot be the zero address.
897      * - `tokenId` token must be owned by `from`.
898      *
899      * Emits a {Transfer} event.
900      */
901     function _transfer(
902         address from,
903         address to,
904         uint256 tokenId
905     ) internal virtual {
906         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
907         require(to != address(0), "ERC721: transfer to the zero address");
908 
909         _beforeTokenTransfer(from, to, tokenId);
910 
911         // Clear approvals from the previous owner
912         _approve(address(0), tokenId);
913 
914         _balances[from] -= 1;
915         _balances[to] += 1;
916         _owners[tokenId] = to;
917 
918         emit Transfer(from, to, tokenId);
919     }
920 
921     /**
922      * @dev Approve `to` to operate on `tokenId`
923      *
924      * Emits a {Approval} event.
925      */
926     function _approve(address to, uint256 tokenId) internal virtual {
927         _tokenApprovals[tokenId] = to;
928         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
929     }
930 
931     /**
932      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
933      * The call is not executed if the target address is not a contract.
934      *
935      * @param from address representing the previous owner of the given token ID
936      * @param to target address that will receive the tokens
937      * @param tokenId uint256 ID of the token to be transferred
938      * @param _data bytes optional data to send along with the call
939      * @return bool whether the call correctly returned the expected magic value
940      */
941     function _checkOnERC721Received(
942         address from,
943         address to,
944         uint256 tokenId,
945         bytes memory _data
946     ) private returns (bool) {
947         if (to.isContract()) {
948             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
949                 return retval == IERC721Receiver.onERC721Received.selector;
950             } catch (bytes memory reason) {
951                 if (reason.length == 0) {
952                     revert("ERC721: transfer to non ERC721Receiver implementer");
953                 } else {
954                     assembly {
955                         revert(add(32, reason), mload(reason))
956                     }
957                 }
958             }
959         } else {
960             return true;
961         }
962     }
963 
964     /**
965      * @dev Hook that is called before any token transfer. This includes minting
966      * and burning.
967      *
968      * Calling conditions:
969      *
970      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
971      * transferred to `to`.
972      * - When `from` is zero, `tokenId` will be minted for `to`.
973      * - When `to` is zero, ``from``'s `tokenId` will be burned.
974      * - `from` and `to` are never both zero.
975      *
976      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
977      */
978     function _beforeTokenTransfer(
979         address from,
980         address to,
981         uint256 tokenId
982     ) internal virtual {}
983 }
984 
985 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
986 
987 
988 
989 pragma solidity ^0.8.0;
990 
991 
992 
993 /**
994  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
995  * enumerability of all the token ids in the contract as well as all token ids owned by each
996  * account.
997  */
998 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
999     // Mapping from owner to list of owned token IDs
1000     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1001 
1002     // Mapping from token ID to index of the owner tokens list
1003     mapping(uint256 => uint256) private _ownedTokensIndex;
1004 
1005     // Array with all token ids, used for enumeration
1006     uint256[] private _allTokens;
1007 
1008     // Mapping from token id to position in the allTokens array
1009     mapping(uint256 => uint256) private _allTokensIndex;
1010 
1011     /**
1012      * @dev See {IERC165-supportsInterface}.
1013      */
1014     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1015         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1020      */
1021     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1022         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1023         return _ownedTokens[owner][index];
1024     }
1025 
1026     /**
1027      * @dev See {IERC721Enumerable-totalSupply}.
1028      */
1029     function totalSupply() public view virtual override returns (uint256) {
1030         return _allTokens.length;
1031     }
1032 
1033     /**
1034      * @dev See {IERC721Enumerable-tokenByIndex}.
1035      */
1036     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1037         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1038         return _allTokens[index];
1039     }
1040 
1041     /**
1042      * @dev Hook that is called before any token transfer. This includes minting
1043      * and burning.
1044      *
1045      * Calling conditions:
1046      *
1047      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1048      * transferred to `to`.
1049      * - When `from` is zero, `tokenId` will be minted for `to`.
1050      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1051      * - `from` cannot be the zero address.
1052      * - `to` cannot be the zero address.
1053      *
1054      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1055      */
1056     function _beforeTokenTransfer(
1057         address from,
1058         address to,
1059         uint256 tokenId
1060     ) internal virtual override {
1061         super._beforeTokenTransfer(from, to, tokenId);
1062 
1063         if (from == address(0)) {
1064             _addTokenToAllTokensEnumeration(tokenId);
1065         } else if (from != to) {
1066             _removeTokenFromOwnerEnumeration(from, tokenId);
1067         }
1068         if (to == address(0)) {
1069             _removeTokenFromAllTokensEnumeration(tokenId);
1070         } else if (to != from) {
1071             _addTokenToOwnerEnumeration(to, tokenId);
1072         }
1073     }
1074 
1075     /**
1076      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1077      * @param to address representing the new owner of the given token ID
1078      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1079      */
1080     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1081         uint256 length = ERC721.balanceOf(to);
1082         _ownedTokens[to][length] = tokenId;
1083         _ownedTokensIndex[tokenId] = length;
1084     }
1085 
1086     /**
1087      * @dev Private function to add a token to this extension's token tracking data structures.
1088      * @param tokenId uint256 ID of the token to be added to the tokens list
1089      */
1090     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1091         _allTokensIndex[tokenId] = _allTokens.length;
1092         _allTokens.push(tokenId);
1093     }
1094 
1095     /**
1096      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1097      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1098      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1099      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1100      * @param from address representing the previous owner of the given token ID
1101      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1102      */
1103     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1104         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1105         // then delete the last slot (swap and pop).
1106 
1107         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1108         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1109 
1110         // When the token to delete is the last token, the swap operation is unnecessary
1111         if (tokenIndex != lastTokenIndex) {
1112             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1113 
1114             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1115             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1116         }
1117 
1118         // This also deletes the contents at the last position of the array
1119         delete _ownedTokensIndex[tokenId];
1120         delete _ownedTokens[from][lastTokenIndex];
1121     }
1122 
1123     /**
1124      * @dev Private function to remove a token from this extension's token tracking data structures.
1125      * This has O(1) time complexity, but alters the order of the _allTokens array.
1126      * @param tokenId uint256 ID of the token to be removed from the tokens list
1127      */
1128     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1129         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1130         // then delete the last slot (swap and pop).
1131 
1132         uint256 lastTokenIndex = _allTokens.length - 1;
1133         uint256 tokenIndex = _allTokensIndex[tokenId];
1134 
1135         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1136         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1137         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1138         uint256 lastTokenId = _allTokens[lastTokenIndex];
1139 
1140         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1141         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1142 
1143         // This also deletes the contents at the last position of the array
1144         delete _allTokensIndex[tokenId];
1145         _allTokens.pop();
1146     }
1147 }
1148 
1149 
1150 // File: @openzeppelin/contracts/access/Ownable.sol
1151 pragma solidity ^0.8.0;
1152 /**
1153  * @dev Contract module which provides a basic access control mechanism, where
1154  * there is an account (an owner) that can be granted exclusive access to
1155  * specific functions.
1156  *
1157  * By default, the owner account will be the one that deploys the contract. This
1158  * can later be changed with {transferOwnership}.
1159  *
1160  * This module is used through inheritance. It will make available the modifier
1161  * `onlyOwner`, which can be applied to your functions to restrict their use to
1162  * the owner.
1163  */
1164 abstract contract Ownable is Context {
1165     address private _owner;
1166 
1167     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1168 
1169     /**
1170      * @dev Initializes the contract setting the deployer as the initial owner.
1171      */
1172     constructor() {
1173         _setOwner(_msgSender());
1174     }
1175 
1176     /**
1177      * @dev Returns the address of the current owner.
1178      */
1179     function owner() public view virtual returns (address) {
1180         return _owner;
1181     }
1182 
1183     /**
1184      * @dev Throws if called by any account other than the owner.
1185      */
1186     modifier onlyOwner() {
1187         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1188         _;
1189     }
1190 
1191     /**
1192      * @dev Leaves the contract without owner. It will not be possible to call
1193      * `onlyOwner` functions anymore. Can only be called by the current owner.
1194      *
1195      * NOTE: Renouncing ownership will leave the contract without an owner,
1196      * thereby removing any functionality that is only available to the owner.
1197      */
1198     function renounceOwnership() public virtual onlyOwner {
1199         _setOwner(address(0));
1200     }
1201 
1202     /**
1203      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1204      * Can only be called by the current owner.
1205      */
1206     function transferOwnership(address newOwner) public virtual onlyOwner {
1207         require(newOwner != address(0), "Ownable: new owner is the zero address");
1208         _setOwner(newOwner);
1209     }
1210 
1211     function _setOwner(address newOwner) private {
1212         address oldOwner = _owner;
1213         _owner = newOwner;
1214         emit OwnershipTransferred(oldOwner, newOwner);
1215     }
1216 }
1217 
1218 
1219 // SPDX-License-Identifier: GPL-3.0
1220 
1221 pragma solidity ^0.8.0;
1222 
1223 
1224 contract TimeVariants is ERC721Enumerable, Ownable {
1225   using Strings for uint256;
1226 
1227   string public baseURI;
1228   string public baseExtension = ".json";
1229   uint256 public cost = 0.1 ether;
1230   uint256 public maxSupply = 10000;
1231   uint256 public maxMintAmount = 20;
1232   bool public paused = false;
1233   mapping(address => bool) public whitelisted;
1234 
1235   constructor(
1236     string memory _name,
1237     string memory _symbol,
1238     string memory _initBaseURI
1239   ) ERC721(_name, _symbol) {
1240     setBaseURI(_initBaseURI);
1241     mint(msg.sender, 1);
1242   }
1243 
1244   // internal
1245   function _baseURI() internal view virtual override returns (string memory) {
1246     return baseURI;
1247   }
1248 
1249   // public
1250   function mint(address _to, uint256 _mintAmount) public payable {
1251     uint256 supply = totalSupply();
1252     require(!paused);
1253     require(_mintAmount > 0);
1254     require(_mintAmount <= maxMintAmount);
1255     require(supply + _mintAmount <= maxSupply);
1256 
1257     if (msg.sender != owner()) {
1258         if(whitelisted[msg.sender] != true) {
1259           require(msg.value >= cost * _mintAmount);
1260         }
1261     }
1262 
1263     for (uint256 i = 1; i <= _mintAmount; i++) {
1264       _safeMint(_to, supply + i);
1265     }
1266   }
1267 
1268   function walletOfOwner(address _owner)
1269     public
1270     view
1271     returns (uint256[] memory)
1272   {
1273     uint256 ownerTokenCount = balanceOf(_owner);
1274     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1275     for (uint256 i; i < ownerTokenCount; i++) {
1276       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1277     }
1278     return tokenIds;
1279   }
1280 
1281   function tokenURI(uint256 tokenId)
1282     public
1283     view
1284     virtual
1285     override
1286     returns (string memory)
1287   {
1288     require(
1289       _exists(tokenId),
1290       "ERC721Metadata: URI query for nonexistent token"
1291     );
1292 
1293     string memory currentBaseURI = _baseURI();
1294     return bytes(currentBaseURI).length > 0
1295         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1296         : "";
1297   }
1298 
1299   //only owner
1300   function setCost(uint256 _newCost) public onlyOwner() {
1301     cost = _newCost;
1302   }
1303 
1304   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1305     maxMintAmount = _newmaxMintAmount;
1306   }
1307 
1308   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1309     baseURI = _newBaseURI;
1310   }
1311 
1312   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1313     baseExtension = _newBaseExtension;
1314   }
1315 
1316   function pause(bool _state) public onlyOwner {
1317     paused = _state;
1318   }
1319  
1320  function whitelistUser(address _user) public onlyOwner {
1321     whitelisted[_user] = true;
1322   }
1323  
1324   function removeWhitelistUser(address _user) public onlyOwner {
1325     whitelisted[_user] = false;
1326   }
1327 
1328   function withdraw() public payable onlyOwner {
1329     require(payable(msg.sender).send(address(this).balance));
1330   }
1331 }