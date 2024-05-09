1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
3 pragma solidity ^0.8.0;
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
26 pragma solidity ^0.8.0;
27 /**
28  * @dev Required interface of an ERC721 compliant contract.
29  */
30 interface IERC721 is IERC165 {
31     /**
32      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
33      */
34     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
35 
36     /**
37      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
38      */
39     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
43      */
44     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
45 
46     /**
47      * @dev Returns the number of tokens in ``owner``'s account.
48      */
49     function balanceOf(address owner) external view returns (uint256 balance);
50 
51     /**
52      * @dev Returns the owner of the `tokenId` token.
53      *
54      * Requirements:
55      *
56      * - `tokenId` must exist.
57      */
58     function ownerOf(uint256 tokenId) external view returns (address owner);
59 
60     /**
61      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
62      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
63      *
64      * Requirements:
65      *
66      * - `from` cannot be the zero address.
67      * - `to` cannot be the zero address.
68      * - `tokenId` token must exist and be owned by `from`.
69      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
70      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
71      *
72      * Emits a {Transfer} event.
73      */
74     function safeTransferFrom(
75         address from,
76         address to,
77         uint256 tokenId
78     ) external;
79 
80     /**
81      * @dev Transfers `tokenId` token from `from` to `to`.
82      *
83      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
84      *
85      * Requirements:
86      *
87      * - `from` cannot be the zero address.
88      * - `to` cannot be the zero address.
89      * - `tokenId` token must be owned by `from`.
90      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(
95         address from,
96         address to,
97         uint256 tokenId
98     ) external;
99 
100     /**
101      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
102      * The approval is cleared when the token is transferred.
103      *
104      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
105      *
106      * Requirements:
107      *
108      * - The caller must own the token or be an approved operator.
109      * - `tokenId` must exist.
110      *
111      * Emits an {Approval} event.
112      */
113     function approve(address to, uint256 tokenId) external;
114 
115     /**
116      * @dev Returns the account approved for `tokenId` token.
117      *
118      * Requirements:
119      *
120      * - `tokenId` must exist.
121      */
122     function getApproved(uint256 tokenId) external view returns (address operator);
123 
124     /**
125      * @dev Approve or remove `operator` as an operator for the caller.
126      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
127      *
128      * Requirements:
129      *
130      * - The `operator` cannot be the caller.
131      *
132      * Emits an {ApprovalForAll} event.
133      */
134     function setApprovalForAll(address operator, bool _approved) external;
135 
136     /**
137      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
138      *
139      * See {setApprovalForAll}
140      */
141     function isApprovedForAll(address owner, address operator) external view returns (bool);
142 
143     /**
144      * @dev Safely transfers `tokenId` token from `from` to `to`.
145      *
146      * Requirements:
147      *
148      * - `from` cannot be the zero address.
149      * - `to` cannot be the zero address.
150      * - `tokenId` token must exist and be owned by `from`.
151      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
152      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
153      *
154      * Emits a {Transfer} event.
155      */
156     function safeTransferFrom(
157         address from,
158         address to,
159         uint256 tokenId,
160         bytes calldata data
161     ) external;
162 }
163 
164 
165 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
166 pragma solidity ^0.8.0;
167 /**
168  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
169  * @dev See https://eips.ethereum.org/EIPS/eip-721
170  */
171 interface IERC721Enumerable is IERC721 {
172     /**
173      * @dev Returns the total amount of tokens stored by the contract.
174      */
175     function totalSupply() external view returns (uint256);
176 
177     /**
178      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
179      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
180      */
181     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
182 
183     /**
184      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
185      * Use along with {totalSupply} to enumerate all tokens.
186      */
187     function tokenByIndex(uint256 index) external view returns (uint256);
188 }
189 
190 
191 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
192 pragma solidity ^0.8.0;
193 /**
194  * @dev Implementation of the {IERC165} interface.
195  *
196  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
197  * for the additional interface id that will be supported. For example:
198  *
199  * ```solidity
200  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
201  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
202  * }
203  * ```
204  *
205  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
206  */
207 abstract contract ERC165 is IERC165 {
208     /**
209      * @dev See {IERC165-supportsInterface}.
210      */
211     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
212         return interfaceId == type(IERC165).interfaceId;
213     }
214 }
215 
216 // File: @openzeppelin/contracts/utils/Strings.sol
217 
218 
219 
220 pragma solidity ^0.8.0;
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
288 
289 pragma solidity ^0.8.0;
290 
291 /**
292  * @dev Collection of functions related to the address type
293  */
294 library Address {
295     /**
296      * @dev Returns true if `account` is a contract.
297      *
298      * [IMPORTANT]
299      * ====
300      * It is unsafe to assume that an address for which this function returns
301      * false is an externally-owned account (EOA) and not a contract.
302      *
303      * Among others, `isContract` will return false for the following
304      * types of addresses:
305      *
306      *  - an externally-owned account
307      *  - a contract in construction
308      *  - an address where a contract will be created
309      *  - an address where a contract lived, but was destroyed
310      * ====
311      */
312     function isContract(address account) internal view returns (bool) {
313         // This method relies on extcodesize, which returns 0 for contracts in
314         // construction, since the code is only stored at the end of the
315         // constructor execution.
316 
317         uint256 size;
318         assembly {
319             size := extcodesize(account)
320         }
321         return size > 0;
322     }
323 
324     /**
325      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
326      * `recipient`, forwarding all available gas and reverting on errors.
327      *
328      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
329      * of certain opcodes, possibly making contracts go over the 2300 gas limit
330      * imposed by `transfer`, making them unable to receive funds via
331      * `transfer`. {sendValue} removes this limitation.
332      *
333      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
334      *
335      * IMPORTANT: because control is transferred to `recipient`, care must be
336      * taken to not create reentrancy vulnerabilities. Consider using
337      * {ReentrancyGuard} or the
338      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
339      */
340     function sendValue(address payable recipient, uint256 amount) internal {
341         require(address(this).balance >= amount, "Address: insufficient balance");
342 
343         (bool success, ) = recipient.call{value: amount}("");
344         require(success, "Address: unable to send value, recipient may have reverted");
345     }
346 
347     /**
348      * @dev Performs a Solidity function call using a low level `call`. A
349      * plain `call` is an unsafe replacement for a function call: use this
350      * function instead.
351      *
352      * If `target` reverts with a revert reason, it is bubbled up by this
353      * function (like regular Solidity function calls).
354      *
355      * Returns the raw returned data. To convert to the expected return value,
356      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
357      *
358      * Requirements:
359      *
360      * - `target` must be a contract.
361      * - calling `target` with `data` must not revert.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
366         return functionCall(target, data, "Address: low-level call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
371      * `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, 0, errorMessage);
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
385      * but also transferring `value` wei to `target`.
386      *
387      * Requirements:
388      *
389      * - the calling contract must have an ETH balance of at least `value`.
390      * - the called Solidity function must be `payable`.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(
395         address target,
396         bytes memory data,
397         uint256 value
398     ) internal returns (bytes memory) {
399         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
404      * with `errorMessage` as a fallback revert reason when `target` reverts.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(
409         address target,
410         bytes memory data,
411         uint256 value,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         require(address(this).balance >= value, "Address: insufficient balance for call");
415         require(isContract(target), "Address: call to non-contract");
416 
417         (bool success, bytes memory returndata) = target.call{value: value}(data);
418         return verifyCallResult(success, returndata, errorMessage);
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
423      * but performing a static call.
424      *
425      * _Available since v3.3._
426      */
427     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
428         return functionStaticCall(target, data, "Address: low-level static call failed");
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
433      * but performing a static call.
434      *
435      * _Available since v3.3._
436      */
437     function functionStaticCall(
438         address target,
439         bytes memory data,
440         string memory errorMessage
441     ) internal view returns (bytes memory) {
442         require(isContract(target), "Address: static call to non-contract");
443 
444         (bool success, bytes memory returndata) = target.staticcall(data);
445         return verifyCallResult(success, returndata, errorMessage);
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
450      * but performing a delegate call.
451      *
452      * _Available since v3.4._
453      */
454     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
455         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
460      * but performing a delegate call.
461      *
462      * _Available since v3.4._
463      */
464     function functionDelegateCall(
465         address target,
466         bytes memory data,
467         string memory errorMessage
468     ) internal returns (bytes memory) {
469         require(isContract(target), "Address: delegate call to non-contract");
470 
471         (bool success, bytes memory returndata) = target.delegatecall(data);
472         return verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     /**
476      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
477      * revert reason using the provided one.
478      *
479      * _Available since v4.3._
480      */
481     function verifyCallResult(
482         bool success,
483         bytes memory returndata,
484         string memory errorMessage
485     ) internal pure returns (bytes memory) {
486         if (success) {
487             return returndata;
488         } else {
489             // Look for revert reason and bubble it up if present
490             if (returndata.length > 0) {
491                 // The easiest way to bubble the revert reason is using memory via assembly
492 
493                 assembly {
494                     let returndata_size := mload(returndata)
495                     revert(add(32, returndata), returndata_size)
496                 }
497             } else {
498                 revert(errorMessage);
499             }
500         }
501     }
502 }
503 
504 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
505 
506 
507 
508 pragma solidity ^0.8.0;
509 
510 
511 /**
512  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
513  * @dev See https://eips.ethereum.org/EIPS/eip-721
514  */
515 interface IERC721Metadata is IERC721 {
516     /**
517      * @dev Returns the token collection name.
518      */
519     function name() external view returns (string memory);
520 
521     /**
522      * @dev Returns the token collection symbol.
523      */
524     function symbol() external view returns (string memory);
525 
526     /**
527      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
528      */
529     function tokenURI(uint256 tokenId) external view returns (string memory);
530 }
531 
532 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
533 
534 
535 
536 pragma solidity ^0.8.0;
537 
538 /**
539  * @title ERC721 token receiver interface
540  * @dev Interface for any contract that wants to support safeTransfers
541  * from ERC721 asset contracts.
542  */
543 interface IERC721Receiver {
544     /**
545      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
546      * by `operator` from `from`, this function is called.
547      *
548      * It must return its Solidity selector to confirm the token transfer.
549      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
550      *
551      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
552      */
553     function onERC721Received(
554         address operator,
555         address from,
556         uint256 tokenId,
557         bytes calldata data
558     ) external returns (bytes4);
559 }
560 
561 // File: @openzeppelin/contracts/utils/Context.sol
562 pragma solidity ^0.8.0;
563 /**
564  * @dev Provides information about the current execution context, including the
565  * sender of the transaction and its data. While these are generally available
566  * via msg.sender and msg.data, they should not be accessed in such a direct
567  * manner, since when dealing with meta-transactions the account sending and
568  * paying for execution may not be the actual sender (as far as an application
569  * is concerned).
570  *
571  * This contract is only required for intermediate, library-like contracts.
572  */
573 abstract contract Context {
574     function _msgSender() internal view virtual returns (address) {
575         return msg.sender;
576     }
577 
578     function _msgData() internal view virtual returns (bytes calldata) {
579         return msg.data;
580     }
581 }
582 
583 
584 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
585 pragma solidity ^0.8.0;
586 /**
587  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
588  * the Metadata extension, but not including the Enumerable extension, which is available separately as
589  * {ERC721Enumerable}.
590  */
591 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
592     using Address for address;
593     using Strings for uint256;
594     
595     string private baseExtension = ".json";
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
670         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString() , baseExtension)) : "";
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
710         require(operator != _msgSender(), "ERC721: approve to caller");
711 
712         _operatorApprovals[_msgSender()][operator] = approved;
713         emit ApprovalForAll(_msgSender(), operator, approved);
714     }
715 
716     /**
717      * @dev See {IERC721-isApprovedForAll}.
718      */
719     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
720         return _operatorApprovals[owner][operator];
721     }
722 
723     /**
724      * @dev See {IERC721-transferFrom}.
725      */
726     function transferFrom(
727         address from,
728         address to,
729         uint256 tokenId
730     ) public virtual override {
731         //solhint-disable-next-line max-line-length
732         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
733 
734         _transfer(from, to, tokenId);
735     }
736 
737     /**
738      * @dev See {IERC721-safeTransferFrom}.
739      */
740     function safeTransferFrom(
741         address from,
742         address to,
743         uint256 tokenId
744     ) public virtual override {
745         safeTransferFrom(from, to, tokenId, "");
746     }
747 
748     /**
749      * @dev See {IERC721-safeTransferFrom}.
750      */
751     function safeTransferFrom(
752         address from,
753         address to,
754         uint256 tokenId,
755         bytes memory _data
756     ) public virtual override {
757         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
758         _safeTransfer(from, to, tokenId, _data);
759     }
760 
761     /**
762      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
763      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
764      *
765      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
766      *
767      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
768      * implement alternative mechanisms to perform token transfer, such as signature-based.
769      *
770      * Requirements:
771      *
772      * - `from` cannot be the zero address.
773      * - `to` cannot be the zero address.
774      * - `tokenId` token must exist and be owned by `from`.
775      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
776      *
777      * Emits a {Transfer} event.
778      */
779     function _safeTransfer(
780         address from,
781         address to,
782         uint256 tokenId,
783         bytes memory _data
784     ) internal virtual {
785         _transfer(from, to, tokenId);
786         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
787     }
788 
789     /**
790      * @dev Returns whether `tokenId` exists.
791      *
792      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
793      *
794      * Tokens start existing when they are minted (`_mint`),
795      * and stop existing when they are burned (`_burn`).
796      */
797     function _exists(uint256 tokenId) internal view virtual returns (bool) {
798         return _owners[tokenId] != address(0);
799     }
800 
801     /**
802      * @dev Returns whether `spender` is allowed to manage `tokenId`.
803      *
804      * Requirements:
805      *
806      * - `tokenId` must exist.
807      */
808     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
809         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
810         address owner = ERC721.ownerOf(tokenId);
811         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
812     }
813 
814     /**
815      * @dev Safely mints `tokenId` and transfers it to `to`.
816      *
817      * Requirements:
818      *
819      * - `tokenId` must not exist.
820      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
821      *
822      * Emits a {Transfer} event.
823      */
824     function _safeMint(address to, uint256 tokenId) internal virtual {
825         _safeMint(to, tokenId, "");
826     }
827 
828     /**
829      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
830      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
831      */
832     function _safeMint(
833         address to,
834         uint256 tokenId,
835         bytes memory _data
836     ) internal virtual {
837         _mint(to, tokenId);
838         require(
839             _checkOnERC721Received(address(0), to, tokenId, _data),
840             "ERC721: transfer to non ERC721Receiver implementer"
841         );
842     }
843 
844     /**
845      * @dev Mints `tokenId` and transfers it to `to`.
846      *
847      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
848      *
849      * Requirements:
850      *
851      * - `tokenId` must not exist.
852      * - `to` cannot be the zero address.
853      *
854      * Emits a {Transfer} event.
855      */
856     function _mint(address to, uint256 tokenId) internal virtual {
857         require(to != address(0), "ERC721: mint to the zero address");
858         require(!_exists(tokenId), "ERC721: token already minted");
859 
860         _beforeTokenTransfer(address(0), to, tokenId);
861 
862         _balances[to] += 1;
863         _owners[tokenId] = to;
864 
865         emit Transfer(address(0), to, tokenId);
866     }
867 
868     /**
869      * @dev Destroys `tokenId`.
870      * The approval is cleared when the token is burned.
871      *
872      * Requirements:
873      *
874      * - `tokenId` must exist.
875      *
876      * Emits a {Transfer} event.
877      */
878     function _burn(uint256 tokenId) internal virtual {
879         address owner = ERC721.ownerOf(tokenId);
880 
881         _beforeTokenTransfer(owner, address(0), tokenId);
882 
883         // Clear approvals
884         _approve(address(0), tokenId);
885 
886         _balances[owner] -= 1;
887         delete _owners[tokenId];
888 
889         emit Transfer(owner, address(0), tokenId);
890     }
891 
892     /**
893      * @dev Transfers `tokenId` from `from` to `to`.
894      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
895      *
896      * Requirements:
897      *
898      * - `to` cannot be the zero address.
899      * - `tokenId` token must be owned by `from`.
900      *
901      * Emits a {Transfer} event.
902      */
903     function _transfer(
904         address from,
905         address to,
906         uint256 tokenId
907     ) internal virtual {
908         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
909         require(to != address(0), "ERC721: transfer to the zero address");
910 
911         _beforeTokenTransfer(from, to, tokenId);
912 
913         // Clear approvals from the previous owner
914         _approve(address(0), tokenId);
915 
916         _balances[from] -= 1;
917         _balances[to] += 1;
918         _owners[tokenId] = to;
919 
920         emit Transfer(from, to, tokenId);
921     }
922 
923     /**
924      * @dev Approve `to` to operate on `tokenId`
925      *
926      * Emits a {Approval} event.
927      */
928     function _approve(address to, uint256 tokenId) internal virtual {
929         _tokenApprovals[tokenId] = to;
930         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
931     }
932 
933     /**
934      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
935      * The call is not executed if the target address is not a contract.
936      *
937      * @param from address representing the previous owner of the given token ID
938      * @param to target address that will receive the tokens
939      * @param tokenId uint256 ID of the token to be transferred
940      * @param _data bytes optional data to send along with the call
941      * @return bool whether the call correctly returned the expected magic value
942      */
943     function _checkOnERC721Received(
944         address from,
945         address to,
946         uint256 tokenId,
947         bytes memory _data
948     ) private returns (bool) {
949         if (to.isContract()) {
950             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
951                 return retval == IERC721Receiver.onERC721Received.selector;
952             } catch (bytes memory reason) {
953                 if (reason.length == 0) {
954                     revert("ERC721: transfer to non ERC721Receiver implementer");
955                 } else {
956                     assembly {
957                         revert(add(32, reason), mload(reason))
958                     }
959                 }
960             }
961         } else {
962             return true;
963         }
964     }
965 
966     /**
967      * @dev Hook that is called before any token transfer. This includes minting
968      * and burning.
969      *
970      * Calling conditions:
971      *
972      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
973      * transferred to `to`.
974      * - When `from` is zero, `tokenId` will be minted for `to`.
975      * - When `to` is zero, ``from``'s `tokenId` will be burned.
976      * - `from` and `to` are never both zero.
977      *
978      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
979      */
980     function _beforeTokenTransfer(
981         address from,
982         address to,
983         uint256 tokenId
984     ) internal virtual {}
985 }
986 
987 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
988 
989 
990 
991 pragma solidity ^0.8.0;
992 
993 
994 
995 /**
996  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
997  * enumerability of all the token ids in the contract as well as all token ids owned by each
998  * account.
999  */
1000 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1001     // Mapping from owner to list of owned token IDs
1002     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1003 
1004     // Mapping from token ID to index of the owner tokens list
1005     mapping(uint256 => uint256) private _ownedTokensIndex;
1006 
1007     // Array with all token ids, used for enumeration
1008     uint256[] private _allTokens;
1009 
1010     // Mapping from token id to position in the allTokens array
1011     mapping(uint256 => uint256) private _allTokensIndex;
1012 
1013     /**
1014      * @dev See {IERC165-supportsInterface}.
1015      */
1016     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1017         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1022      */
1023     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1024         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1025         return _ownedTokens[owner][index];
1026     }
1027 
1028     /**
1029      * @dev See {IERC721Enumerable-totalSupply}.
1030      */
1031     function totalSupply() public view virtual override returns (uint256) {
1032         return _allTokens.length;
1033     }
1034 
1035     /**
1036      * @dev See {IERC721Enumerable-tokenByIndex}.
1037      */
1038     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1039         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1040         return _allTokens[index];
1041     }
1042 
1043     /**
1044      * @dev Hook that is called before any token transfer. This includes minting
1045      * and burning.
1046      *
1047      * Calling conditions:
1048      *
1049      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1050      * transferred to `to`.
1051      * - When `from` is zero, `tokenId` will be minted for `to`.
1052      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1053      * - `from` cannot be the zero address.
1054      * - `to` cannot be the zero address.
1055      *
1056      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1057      */
1058     function _beforeTokenTransfer(
1059         address from,
1060         address to,
1061         uint256 tokenId
1062     ) internal virtual override {
1063         super._beforeTokenTransfer(from, to, tokenId);
1064 
1065         if (from == address(0)) {
1066             _addTokenToAllTokensEnumeration(tokenId);
1067         } else if (from != to) {
1068             _removeTokenFromOwnerEnumeration(from, tokenId);
1069         }
1070         if (to == address(0)) {
1071             _removeTokenFromAllTokensEnumeration(tokenId);
1072         } else if (to != from) {
1073             _addTokenToOwnerEnumeration(to, tokenId);
1074         }
1075     }
1076 
1077     /**
1078      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1079      * @param to address representing the new owner of the given token ID
1080      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1081      */
1082     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1083         uint256 length = ERC721.balanceOf(to);
1084         _ownedTokens[to][length] = tokenId;
1085         _ownedTokensIndex[tokenId] = length;
1086     }
1087 
1088     /**
1089      * @dev Private function to add a token to this extension's token tracking data structures.
1090      * @param tokenId uint256 ID of the token to be added to the tokens list
1091      */
1092     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1093         _allTokensIndex[tokenId] = _allTokens.length;
1094         _allTokens.push(tokenId);
1095     }
1096 
1097     /**
1098      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1099      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1100      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1101      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1102      * @param from address representing the previous owner of the given token ID
1103      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1104      */
1105     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1106         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1107         // then delete the last slot (swap and pop).
1108 
1109         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1110         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1111 
1112         // When the token to delete is the last token, the swap operation is unnecessary
1113         if (tokenIndex != lastTokenIndex) {
1114             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1115 
1116             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1117             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1118         }
1119 
1120         // This also deletes the contents at the last position of the array
1121         delete _ownedTokensIndex[tokenId];
1122         delete _ownedTokens[from][lastTokenIndex];
1123     }
1124 
1125     /**
1126      * @dev Private function to remove a token from this extension's token tracking data structures.
1127      * This has O(1) time complexity, but alters the order of the _allTokens array.
1128      * @param tokenId uint256 ID of the token to be removed from the tokens list
1129      */
1130     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1131         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1132         // then delete the last slot (swap and pop).
1133 
1134         uint256 lastTokenIndex = _allTokens.length - 1;
1135         uint256 tokenIndex = _allTokensIndex[tokenId];
1136 
1137         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1138         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1139         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1140         uint256 lastTokenId = _allTokens[lastTokenIndex];
1141 
1142         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1143         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1144 
1145         // This also deletes the contents at the last position of the array
1146         delete _allTokensIndex[tokenId];
1147         _allTokens.pop();
1148     }
1149 }
1150 
1151 
1152 // File: @openzeppelin/contracts/access/Ownable.sol
1153 pragma solidity ^0.8.0;
1154 /**
1155  * @dev Contract module which provides a basic access control mechanism, where
1156  * there is an account (an owner) that can be granted exclusive access to
1157  * specific functions.
1158  *
1159  * By default, the owner account will be the one that deploys the contract. This
1160  * can later be changed with {transferOwnership}.
1161  *
1162  * This module is used through inheritance. It will make available the modifier
1163  * `onlyOwner`, which can be applied to your functions to restrict their use to
1164  * the owner.
1165  */
1166 abstract contract Ownable is Context {
1167     address private _owner;
1168 
1169     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1170 
1171     /**
1172      * @dev Initializes the contract setting the deployer as the initial owner.
1173      */
1174     constructor() {
1175         _setOwner(_msgSender());
1176     }
1177 
1178     /**
1179      * @dev Returns the address of the current owner.
1180      */
1181     function owner() public view virtual returns (address) {
1182         return _owner;
1183     }
1184 
1185     /**
1186      * @dev Throws if called by any account other than the owner.
1187      */
1188     modifier onlyOwner() {
1189         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1190         _;
1191     }
1192 
1193     /**
1194      * @dev Leaves the contract without owner. It will not be possible to call
1195      * `onlyOwner` functions anymore. Can only be called by the current owner.
1196      *
1197      * NOTE: Renouncing ownership will leave the contract without an owner,
1198      * thereby removing any functionality that is only available to the owner.
1199      */
1200     function renounceOwnership() public virtual onlyOwner {
1201         _setOwner(address(0));
1202     }
1203 
1204     /**
1205      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1206      * Can only be called by the current owner.
1207      */
1208     function transferOwnership(address newOwner) public virtual onlyOwner {
1209         require(newOwner != address(0), "Ownable: new owner is the zero address");
1210         _setOwner(newOwner);
1211     }
1212 
1213     function _setOwner(address newOwner) private {
1214         address oldOwner = _owner;
1215         _owner = newOwner;
1216         emit OwnershipTransferred(oldOwner, newOwner);
1217     }
1218 }
1219 
1220 
1221 pragma solidity >=0.7.0 <0.9.0;
1222 
1223 contract NFT is ERC721Enumerable, Ownable {
1224     string public baseExtension = ".json";
1225     uint256 public constant maxAirdrop = 20;
1226     uint256 public constant freeSupply = 888;
1227     uint256 public constant paidSupply = 8000;
1228     uint256 public constant maxMintTx = 10;
1229     uint256 public constant maxSupply = freeSupply + paidSupply;
1230     uint256 public constant price = 30000000000000000; // 0.030000000000000000 ETH
1231     string private tokenUri;
1232     uint256 public freeMint = 2;
1233     uint256 public maxMintWallet = 20;
1234     uint256 public minted = 0;
1235     uint256 public totalAirdrop = 0;
1236     mapping(address => uint256) public addressMint;
1237     bool public paused = false;
1238     address[] public listedAirdrop;
1239 
1240     constructor() ERC721("Genetically Spliced Ape Labs", "GSAL") {
1241     }
1242 
1243     function totalSupply() public view override returns (uint256) {
1244         return minted;
1245     }
1246 
1247     function airdrop() external onlyOwner {
1248         require(totalAirdrop + listedAirdrop.length <= maxAirdrop, "Limit Airdrop");
1249 
1250         uint256 lastTotalSupply = totalSupply();
1251         totalAirdrop += listedAirdrop.length;
1252         for (uint256 i = 0; i < listedAirdrop.length; i++) {
1253             _mint(listedAirdrop[i], ++lastTotalSupply);
1254             minted += lastTotalSupply;
1255         }
1256     }
1257 
1258     function isAirdrop(address _user) public view returns (bool) {
1259         for (uint i = 0; i < listedAirdrop.length; i++) {
1260         if (listedAirdrop[i] == _user) {
1261             return true;
1262         }
1263         }
1264         return false;
1265     }
1266     function airdropUsers(address[] calldata _users) public onlyOwner {
1267         delete listedAirdrop;
1268         listedAirdrop = _users;
1269     }
1270 
1271     function pause(bool _state) public onlyOwner {
1272         paused = _state;
1273     }
1274   
1275     function mint(uint256 amount) external payable {
1276         require(!paused, "the contract is paused");
1277         if (minted < freeSupply) {
1278             require(minted + amount <= freeSupply, "Free Mint Closed");
1279             require(addressMint[msg.sender] + amount <= freeMint,"Limit");
1280         }
1281         else {
1282             require(amount <= maxMintTx,"Max 10 Amount");
1283             require(minted + amount <= maxSupply, "Sold Out");
1284             require(addressMint[msg.sender] + amount <= maxMintWallet,"Limit");
1285             require(msg.value >= price * amount, "Out of ETH");
1286         }
1287         uint256 lastTotalSupply = totalSupply();
1288         minted += amount;
1289         addressMint[msg.sender] += amount;
1290         for (uint256 i = 0; i < amount; i++) {
1291             _mint(msg.sender, ++lastTotalSupply);
1292         }
1293     }
1294     function _baseURI() internal view override(ERC721) returns (string memory) {
1295         return tokenUri;
1296     }
1297     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1298         baseExtension = _newBaseExtension;
1299     }
1300     function withdrawAll() external onlyOwner {
1301         require(address(this).balance > 0, "No balance");
1302         payable(msg.sender).transfer(address(this).balance);
1303     }
1304 
1305     function setMaxFreeMint(uint256 amount) external onlyOwner {
1306         freeMint = amount;
1307     }
1308     function setMaxWalletMint(uint256 amount) external onlyOwner {
1309         maxMintWallet = amount;
1310     }
1311 
1312     function setBaseURI(string calldata URI) external onlyOwner {
1313         tokenUri = URI;
1314     }
1315 
1316 }