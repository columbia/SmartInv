1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
4 pragma solidity ^0.8.11;
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
27 pragma solidity ^0.8.11;
28 /**
29  * @dev Required interface of an ERC721 compliant contract.
30  */
31 interface IERC721 is IERC165 {
32     /**
33      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
34      */
35     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
36 
37     /**
38      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
39      */
40     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
44      */
45     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
46 
47     /**
48      * @dev Returns the number of tokens in ``owner``'s account.
49      */
50     function balanceOf(address owner) external view returns (uint256 balance);
51 
52     /**
53      * @dev Returns the owner of the `tokenId` token.
54      *
55      * Requirements:
56      *
57      * - `tokenId` must exist.
58      */
59     function ownerOf(uint256 tokenId) external view returns (address owner);
60 
61     /**
62      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
63      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
64      *
65      * Requirements:
66      *
67      * - `from` cannot be the zero address.
68      * - `to` cannot be the zero address.
69      * - `tokenId` token must exist and be owned by `from`.
70      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
71      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
72      *
73      * Emits a {Transfer} event.
74      */
75     function safeTransferFrom(
76         address from,
77         address to,
78         uint256 tokenId
79     ) external;
80 
81     /**
82      * @dev Transfers `tokenId` token from `from` to `to`.
83      *
84      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must be owned by `from`.
91      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(
96         address from,
97         address to,
98         uint256 tokenId
99     ) external;
100 
101     /**
102      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
103      * The approval is cleared when the token is transferred.
104      *
105      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
106      *
107      * Requirements:
108      *
109      * - The caller must own the token or be an approved operator.
110      * - `tokenId` must exist.
111      *
112      * Emits an {Approval} event.
113      */
114     function approve(address to, uint256 tokenId) external;
115 
116     /**
117      * @dev Returns the account approved for `tokenId` token.
118      *
119      * Requirements:
120      *
121      * - `tokenId` must exist.
122      */
123     function getApproved(uint256 tokenId) external view returns (address operator);
124 
125     /**
126      * @dev Approve or remove `operator` as an operator for the caller.
127      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
128      *
129      * Requirements:
130      *
131      * - The `operator` cannot be the caller.
132      *
133      * Emits an {ApprovalForAll} event.
134      */
135     function setApprovalForAll(address operator, bool _approved) external;
136 
137     /**
138      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
139      *
140      * See {setApprovalForAll}
141      */
142     function isApprovedForAll(address owner, address operator) external view returns (bool);
143 
144     /**
145      * @dev Safely transfers `tokenId` token from `from` to `to`.
146      *
147      * Requirements:
148      *
149      * - `from` cannot be the zero address.
150      * - `to` cannot be the zero address.
151      * - `tokenId` token must exist and be owned by `from`.
152      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
153      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
154      *
155      * Emits a {Transfer} event.
156      */
157     function safeTransferFrom(
158         address from,
159         address to,
160         uint256 tokenId,
161         bytes calldata data
162     ) external;
163 }
164 
165 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
166 pragma solidity ^0.8.11;
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
192 pragma solidity ^0.8.11;
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
289 pragma solidity ^0.8.11;
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
504 // File: @openzeppelin/contracts/utils/Context.sol
505 pragma solidity ^0.8.11;
506 /**
507  * @dev Provides information about the current execution context, including the
508  * sender of the transaction and its data. While these are generally available
509  * via msg.sender and msg.data, they should not be accessed in such a direct
510  * manner, since when dealing with meta-transactions the account sending and
511  * paying for execution may not be the actual sender (as far as an application
512  * is concerned).
513  *
514  * This contract is only required for intermediate, library-like contracts.
515  */
516 abstract contract Context {
517     function _msgSender() internal view virtual returns (address) {
518         return msg.sender;
519     }
520 
521     function _msgData() internal view virtual returns (bytes calldata) {
522         return msg.data;
523     }
524 }
525 
526 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
527 
528 
529 
530 pragma solidity ^0.8.11;
531 
532 
533 /**
534  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
535  * @dev See https://eips.ethereum.org/EIPS/eip-721
536  */
537 interface IERC721Metadata is IERC721 {
538     /**
539      * @dev Returns the token collection name.
540      */
541     function name() external view returns (string memory);
542 
543     /**
544      * @dev Returns the token collection symbol.
545      */
546     function symbol() external view returns (string memory);
547 
548     /**
549      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
550      */
551     function tokenURI(uint256 tokenId) external view returns (string memory);
552 }
553 
554 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
555 
556 
557 
558 pragma solidity ^0.8.11;
559 
560 /**
561  * @title ERC721 token receiver interface
562  * @dev Interface for any contract that wants to support safeTransfers
563  * from ERC721 asset contracts.
564  */
565 interface IERC721Receiver {
566     /**
567      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
568      * by `operator` from `from`, this function is called.
569      *
570      * It must return its Solidity selector to confirm the token transfer.
571      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
572      *
573      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
574      */
575     function onERC721Received(
576         address operator,
577         address from,
578         uint256 tokenId,
579         bytes calldata data
580     ) external returns (bytes4);
581 }
582 
583 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
584 pragma solidity ^0.8.11;
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
989 pragma solidity ^0.8.11;
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
1149 // File: @openzeppelin/contracts/access/Ownable.sol
1150 pragma solidity ^0.8.11;
1151 /**
1152  * @dev Contract module which provides a basic access control mechanism, where
1153  * there is an account (an owner) that can be granted exclusive access to
1154  * specific functions.
1155  *
1156  * By default, the owner account will be the one that deploys the contract. This
1157  * can later be changed with {transferOwnership}.
1158  *
1159  * This module is used through inheritance. It will make available the modifier
1160  * `onlyOwner`, which can be applied to your functions to restrict their use to
1161  * the owner.
1162  */
1163 abstract contract Ownable is Context {
1164     address private _owner;
1165 
1166     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1167 
1168     /**
1169      * @dev Initializes the contract setting the deployer as the initial owner.
1170      */
1171     constructor() {
1172         _setOwner(_msgSender());
1173     }
1174 
1175     /**
1176      * @dev Returns the address of the current owner.
1177      */
1178     function owner() public view virtual returns (address) {
1179         return _owner;
1180     }
1181 
1182     /**
1183      * @dev Throws if called by any account other than the owner.
1184      */
1185     modifier onlyOwner() {
1186         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1187         _;
1188     }
1189 
1190     /**
1191      * @dev Leaves the contract without owner. It will not be possible to call
1192      * `onlyOwner` functions anymore. Can only be called by the current owner.
1193      *
1194      * NOTE: Renouncing ownership will leave the contract without an owner,
1195      * thereby removing any functionality that is only available to the owner.
1196      */
1197     function renounceOwnership() public virtual onlyOwner {
1198         _setOwner(address(0));
1199     }
1200 
1201     /**
1202      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1203      * Can only be called by the current owner.
1204      */
1205     function transferOwnership(address newOwner) public virtual onlyOwner {
1206         require(newOwner != address(0), "Ownable: new owner is the zero address");
1207         _setOwner(newOwner);
1208     }
1209 
1210     function _setOwner(address newOwner) private {
1211         address oldOwner = _owner;
1212         _owner = newOwner;
1213         emit OwnershipTransferred(oldOwner, newOwner);
1214     }
1215 }
1216 
1217 pragma solidity >=0.8.11;
1218 
1219 contract RainbowCats is ERC721Enumerable, Ownable {
1220   using Strings for uint256;
1221 
1222   string public baseURI;
1223   string public baseExtension = ".json";
1224   string public notRevealedUri;
1225   uint256 public cost = 0.0 ether;
1226   uint256 public maxSupply = 5000;
1227   uint256 public maxMintAmount = 5;
1228   uint256 public reserved = 150;
1229   uint256 public nftPerAddressLimit = 1;
1230   bool public isPublicSaleActive = false;
1231   bool public isWhitelistSaleActive = false;
1232   bool public revealed = false;
1233   bool public onlyWhitelisted = true;
1234   address[] public whitelistedAddresses;
1235   mapping(address => uint256) public addressMintedBalance;
1236 
1237 
1238   constructor (
1239     string memory _initBaseURI,
1240     string memory _initNotRevealedUri)
1241     ERC721 ("Rainbow Cats", "RCATS") {
1242         setBaseURI(_initBaseURI);
1243         setNotRevealedURI(_initNotRevealedUri);
1244     }
1245 
1246   // internal
1247   function _baseURI() internal view virtual override returns (string memory) {
1248     return baseURI;
1249   }
1250 
1251   // public
1252   function mint(uint256 _mintAmount) public payable {
1253     require(isPublicSaleActive, "Main Sale is Paused");
1254     uint256 supply = totalSupply();
1255     require(_mintAmount > 0, "need to mint at least 1 NFT");
1256     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1257     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1258     for (uint256 i = 1; i <= _mintAmount; i++) {
1259         addressMintedBalance[msg.sender]++;
1260       _safeMint(msg.sender, supply + i);
1261     }
1262   }
1263   
1264 
1265   function mintPresale(uint256 _mintAmount) external payable {
1266         require(isWhitelistSaleActive, "Whitelist sale is still inactive");
1267         uint256 supply = totalSupply();
1268         require(isWhitelisted(msg.sender), "user is not whitelisted");
1269         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1270         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1271         require(msg.value >= cost * _mintAmount, "insufficient funds");
1272         for (uint256 i = 1; i <= _mintAmount; i++) {
1273         addressMintedBalance[msg.sender]++;
1274       _safeMint(msg.sender, supply + i);
1275     }
1276   }
1277   
1278   function isWhitelisted(address _user) public view returns (bool) {
1279     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1280       if (whitelistedAddresses[i] == _user) {
1281           return true;
1282       }
1283     }
1284     return false;
1285   }
1286 
1287   function walletOfOwner(address _owner)
1288     public
1289     view
1290     returns (uint256[] memory)
1291   {
1292     uint256 ownerTokenCount = balanceOf(_owner);
1293     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1294     for (uint256 i; i < ownerTokenCount; i++) {
1295       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1296     }
1297     return tokenIds;
1298   }
1299 
1300   function tokenURI(uint256 tokenId)
1301     public
1302     view
1303     virtual
1304     override
1305     returns (string memory)
1306   {
1307     require(
1308       _exists(tokenId),
1309       "ERC721Metadata: URI query for nonexistent token"
1310     );
1311     
1312     if(revealed == false) {
1313         return notRevealedUri;
1314     }
1315 
1316     string memory currentBaseURI = _baseURI();
1317     return bytes(currentBaseURI).length > 0
1318         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1319         : "";
1320   }
1321 
1322   //only owner
1323   function reveal() public onlyOwner {
1324       revealed = true;
1325   }
1326   
1327   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1328     nftPerAddressLimit = _limit;
1329   }
1330   
1331   function setCost(uint256 _newCost) public onlyOwner {
1332     cost = _newCost;
1333   }
1334 
1335   function checkWhiteList(address addr) external view returns (uint256) {
1336         return addressMintedBalance[addr];
1337     }
1338 
1339   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1340     maxMintAmount = _newmaxMintAmount;
1341   }
1342 
1343   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1344     baseURI = _newBaseURI;
1345   }
1346 
1347   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1348     baseExtension = _newBaseExtension;
1349   }
1350   
1351   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1352     notRevealedUri = _notRevealedURI;
1353   }
1354 
1355   function setPublicSaleStatus(bool val) public onlyOwner {
1356         isPublicSaleActive = val;
1357     }
1358 
1359   function setWhiteListSaleStatus(bool val) public onlyOwner {
1360         isWhitelistSaleActive = val;
1361     }  
1362   
1363   function setOnlyWhitelisted(bool _state) public onlyOwner {
1364     onlyWhitelisted = _state;
1365   }
1366   
1367   function whitelistUsers(address[] calldata _users) public onlyOwner {
1368     delete whitelistedAddresses;
1369     whitelistedAddresses = _users;
1370   }
1371 
1372   function mintReserved(uint256 _amount) public onlyOwner {
1373         require( _amount <= reserved, "Can't reserve more than set amount" );
1374         reserved -= _amount;
1375         uint256 supply = totalSupply();
1376         for(uint256 i; i < _amount; i++){
1377             _safeMint( msg.sender, supply + i );
1378         }
1379     }
1380  
1381   function withdraw() public payable onlyOwner {
1382     (bool dc, ) = payable(owner()).call{value: address(this).balance}("");
1383     require(dc);
1384   }
1385 }