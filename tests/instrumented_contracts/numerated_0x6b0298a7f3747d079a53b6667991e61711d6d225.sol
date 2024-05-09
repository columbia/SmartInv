1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
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
27 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Required interface of an ERC721 compliant contract.
32  */
33 interface IERC721 is IERC165 {
34     /**
35      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
36      */
37     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
38 
39     /**
40      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
41      */
42     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
46      */
47     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
48 
49     /**
50      * @dev Returns the number of tokens in ``owner``'s account.
51      */
52     function balanceOf(address owner) external view returns (uint256 balance);
53 
54     /**
55      * @dev Returns the owner of the `tokenId` token.
56      *
57      * Requirements:
58      *
59      * - `tokenId` must exist.
60      */
61     function ownerOf(uint256 tokenId) external view returns (address owner);
62 
63     /**
64      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
65      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
66      *
67      * Requirements:
68      *
69      * - `from` cannot be the zero address.
70      * - `to` cannot be the zero address.
71      * - `tokenId` token must exist and be owned by `from`.
72      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
73      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
74      *
75      * Emits a {Transfer} event.
76      */
77     function safeTransferFrom(
78         address from,
79         address to,
80         uint256 tokenId
81     ) external;
82 
83     /**
84      * @dev Transfers `tokenId` token from `from` to `to`.
85      *
86      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must be owned by `from`.
93      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(
98         address from,
99         address to,
100         uint256 tokenId
101     ) external;
102 
103     /**
104      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
105      * The approval is cleared when the token is transferred.
106      *
107      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
108      *
109      * Requirements:
110      *
111      * - The caller must own the token or be an approved operator.
112      * - `tokenId` must exist.
113      *
114      * Emits an {Approval} event.
115      */
116     function approve(address to, uint256 tokenId) external;
117 
118     /**
119      * @dev Returns the account approved for `tokenId` token.
120      *
121      * Requirements:
122      *
123      * - `tokenId` must exist.
124      */
125     function getApproved(uint256 tokenId) external view returns (address operator);
126 
127     /**
128      * @dev Approve or remove `operator` as an operator for the caller.
129      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
130      *
131      * Requirements:
132      *
133      * - The `operator` cannot be the caller.
134      *
135      * Emits an {ApprovalForAll} event.
136      */
137     function setApprovalForAll(address operator, bool _approved) external;
138 
139     /**
140      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
141      *
142      * See {setApprovalForAll}
143      */
144     function isApprovedForAll(address owner, address operator) external view returns (bool);
145 
146     /**
147      * @dev Safely transfers `tokenId` token from `from` to `to`.
148      *
149      * Requirements:
150      *
151      * - `from` cannot be the zero address.
152      * - `to` cannot be the zero address.
153      * - `tokenId` token must exist and be owned by `from`.
154      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
155      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
156      *
157      * Emits a {Transfer} event.
158      */
159     function safeTransferFrom(
160         address from,
161         address to,
162         uint256 tokenId,
163         bytes calldata data
164     ) external;
165 }
166 
167 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
168 pragma solidity ^0.8.0;
169 
170 /**
171  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
172  * @dev See https://eips.ethereum.org/EIPS/eip-721
173  */
174 interface IERC721Enumerable is IERC721 {
175     /**
176      * @dev Returns the total amount of tokens stored by the contract.
177      */
178     function totalSupply() external view returns (uint256);
179 
180     /**
181      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
182      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
183      */
184     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
185 
186     /**
187      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
188      * Use along with {totalSupply} to enumerate all tokens.
189      */
190     function tokenByIndex(uint256 index) external view returns (uint256);
191 }
192 
193 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
194 pragma solidity ^0.8.0;
195 
196 /**
197  * @dev Implementation of the {IERC165} interface.
198  *
199  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
200  * for the additional interface id that will be supported. For example:
201  *
202  * ```solidity
203  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
204  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
205  * }
206  * ```
207  *
208  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
209  */
210 abstract contract ERC165 is IERC165 {
211     /**
212      * @dev See {IERC165-supportsInterface}.
213      */
214     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
215         return interfaceId == type(IERC165).interfaceId;
216     }
217 }
218 
219 // File: @openzeppelin/contracts/utils/Strings.sol
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev String operations.
225  */
226 library Strings {
227     bytes16 private constant _HEX_SYMBOLS = '0123456789abcdef';
228 
229     /**
230      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
231      */
232     function toString(uint256 value) internal pure returns (string memory) {
233         // Inspired by OraclizeAPI's implementation - MIT licence
234         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
235 
236         if (value == 0) {
237             return '0';
238         }
239         uint256 temp = value;
240         uint256 digits;
241         while (temp != 0) {
242             digits++;
243             temp /= 10;
244         }
245         bytes memory buffer = new bytes(digits);
246         while (value != 0) {
247             digits -= 1;
248             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
249             value /= 10;
250         }
251         return string(buffer);
252     }
253 
254     /**
255      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
256      */
257     function toHexString(uint256 value) internal pure returns (string memory) {
258         if (value == 0) {
259             return '0x00';
260         }
261         uint256 temp = value;
262         uint256 length = 0;
263         while (temp != 0) {
264             length++;
265             temp >>= 8;
266         }
267         return toHexString(value, length);
268     }
269 
270     /**
271      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
272      */
273     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
274         bytes memory buffer = new bytes(2 * length + 2);
275         buffer[0] = '0';
276         buffer[1] = 'x';
277         for (uint256 i = 2 * length + 1; i > 1; --i) {
278             buffer[i] = _HEX_SYMBOLS[value & 0xf];
279             value >>= 4;
280         }
281         require(value == 0, 'Strings: hex length insufficient');
282         return string(buffer);
283     }
284 }
285 
286 // File: @openzeppelin/contracts/utils/Address.sol
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
340         require(address(this).balance >= amount, 'Address: insufficient balance');
341 
342         (bool success, ) = recipient.call{value: amount}('');
343         require(success, 'Address: unable to send value, recipient may have reverted');
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
365         return functionCall(target, data, 'Address: low-level call failed');
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
398         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
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
413         require(address(this).balance >= value, 'Address: insufficient balance for call');
414         require(isContract(target), 'Address: call to non-contract');
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
427         return functionStaticCall(target, data, 'Address: low-level static call failed');
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
441         require(isContract(target), 'Address: static call to non-contract');
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
454         return functionDelegateCall(target, data, 'Address: low-level delegate call failed');
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
468         require(isContract(target), 'Address: delegate call to non-contract');
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
505 pragma solidity ^0.8.0;
506 
507 /**
508  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
509  * @dev See https://eips.ethereum.org/EIPS/eip-721
510  */
511 interface IERC721Metadata is IERC721 {
512     /**
513      * @dev Returns the token collection name.
514      */
515     function name() external view returns (string memory);
516 
517     /**
518      * @dev Returns the token collection symbol.
519      */
520     function symbol() external view returns (string memory);
521 
522     /**
523      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
524      */
525     function tokenURI(uint256 tokenId) external view returns (string memory);
526 }
527 
528 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
529 
530 pragma solidity ^0.8.0;
531 
532 /**
533  * @title ERC721 token receiver interface
534  * @dev Interface for any contract that wants to support safeTransfers
535  * from ERC721 asset contracts.
536  */
537 interface IERC721Receiver {
538     /**
539      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
540      * by `operator` from `from`, this function is called.
541      *
542      * It must return its Solidity selector to confirm the token transfer.
543      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
544      *
545      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
546      */
547     function onERC721Received(
548         address operator,
549         address from,
550         uint256 tokenId,
551         bytes calldata data
552     ) external returns (bytes4);
553 }
554 
555 // File: @openzeppelin/contracts/utils/Context.sol
556 pragma solidity ^0.8.0;
557 
558 /**
559  * @dev Provides information about the current execution context, including the
560  * sender of the transaction and its data. While these are generally available
561  * via msg.sender and msg.data, they should not be accessed in such a direct
562  * manner, since when dealing with meta-transactions the account sending and
563  * paying for execution may not be the actual sender (as far as an application
564  * is concerned).
565  *
566  * This contract is only required for intermediate, library-like contracts.
567  */
568 abstract contract Context {
569     function _msgSender() internal view virtual returns (address) {
570         return msg.sender;
571     }
572 
573     function _msgData() internal view virtual returns (bytes calldata) {
574         return msg.data;
575     }
576 }
577 
578 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
579 pragma solidity ^0.8.0;
580 
581 /**
582  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
583  * the Metadata extension, but not including the Enumerable extension, which is available separately as
584  * {ERC721Enumerable}.
585  */
586 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
587     using Address for address;
588     using Strings for uint256;
589 
590     // Token name
591     string private _name;
592 
593     // Token symbol
594     string private _symbol;
595 
596     // Mapping from token ID to owner address
597     mapping(uint256 => address) private _owners;
598 
599     // Mapping owner address to token count
600     mapping(address => uint256) private _balances;
601 
602     // Mapping from token ID to approved address
603     mapping(uint256 => address) private _tokenApprovals;
604 
605     // Mapping from owner to operator approvals
606     mapping(address => mapping(address => bool)) private _operatorApprovals;
607 
608     /**
609      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
610      */
611     constructor(string memory name_, string memory symbol_) {
612         _name = name_;
613         _symbol = symbol_;
614     }
615 
616     /**
617      * @dev See {IERC165-supportsInterface}.
618      */
619     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
620         return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || super.supportsInterface(interfaceId);
621     }
622 
623     /**
624      * @dev See {IERC721-balanceOf}.
625      */
626     function balanceOf(address owner) public view virtual override returns (uint256) {
627         require(owner != address(0), 'ERC721: balance query for the zero address');
628         return _balances[owner];
629     }
630 
631     /**
632      * @dev See {IERC721-ownerOf}.
633      */
634     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
635         address owner = _owners[tokenId];
636         require(owner != address(0), 'ERC721: owner query for nonexistent token');
637         return owner;
638     }
639 
640     /**
641      * @dev See {IERC721Metadata-name}.
642      */
643     function name() public view virtual override returns (string memory) {
644         return _name;
645     }
646 
647     /**
648      * @dev See {IERC721Metadata-symbol}.
649      */
650     function symbol() public view virtual override returns (string memory) {
651         return _symbol;
652     }
653 
654     /**
655      * @dev See {IERC721Metadata-tokenURI}.
656      */
657     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
658         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
659 
660         string memory baseURI = _baseURI();
661         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
662     }
663 
664     /**
665      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
666      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
667      * by default, can be overriden in child contracts.
668      */
669     function _baseURI() internal view virtual returns (string memory) {
670         return '';
671     }
672 
673     /**
674      * @dev See {IERC721-approve}.
675      */
676     function approve(address to, uint256 tokenId) public virtual override {
677         address owner = ERC721.ownerOf(tokenId);
678         require(to != owner, 'ERC721: approval to current owner');
679 
680         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), 'ERC721: approve caller is not owner nor approved for all');
681 
682         _approve(to, tokenId);
683     }
684 
685     /**
686      * @dev See {IERC721-getApproved}.
687      */
688     function getApproved(uint256 tokenId) public view virtual override returns (address) {
689         require(_exists(tokenId), 'ERC721: approved query for nonexistent token');
690 
691         return _tokenApprovals[tokenId];
692     }
693 
694     /**
695      * @dev See {IERC721-setApprovalForAll}.
696      */
697     function setApprovalForAll(address operator, bool approved) public virtual override {
698         require(operator != _msgSender(), 'ERC721: approve to caller');
699 
700         _operatorApprovals[_msgSender()][operator] = approved;
701         emit ApprovalForAll(_msgSender(), operator, approved);
702     }
703 
704     /**
705      * @dev See {IERC721-isApprovedForAll}.
706      */
707     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
708         return _operatorApprovals[owner][operator];
709     }
710 
711     /**
712      * @dev See {IERC721-transferFrom}.
713      */
714     function transferFrom(
715         address from,
716         address to,
717         uint256 tokenId
718     ) public virtual override {
719         //solhint-disable-next-line max-line-length
720         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
721 
722         _transfer(from, to, tokenId);
723     }
724 
725     /**
726      * @dev See {IERC721-safeTransferFrom}.
727      */
728     function safeTransferFrom(
729         address from,
730         address to,
731         uint256 tokenId
732     ) public virtual override {
733         safeTransferFrom(from, to, tokenId, '');
734     }
735 
736     /**
737      * @dev See {IERC721-safeTransferFrom}.
738      */
739     function safeTransferFrom(
740         address from,
741         address to,
742         uint256 tokenId,
743         bytes memory _data
744     ) public virtual override {
745         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
746         _safeTransfer(from, to, tokenId, _data);
747     }
748 
749     /**
750      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
751      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
752      *
753      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
754      *
755      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
756      * implement alternative mechanisms to perform token transfer, such as signature-based.
757      *
758      * Requirements:
759      *
760      * - `from` cannot be the zero address.
761      * - `to` cannot be the zero address.
762      * - `tokenId` token must exist and be owned by `from`.
763      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
764      *
765      * Emits a {Transfer} event.
766      */
767     function _safeTransfer(
768         address from,
769         address to,
770         uint256 tokenId,
771         bytes memory _data
772     ) internal virtual {
773         _transfer(from, to, tokenId);
774         require(_checkOnERC721Received(from, to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
775     }
776 
777     /**
778      * @dev Returns whether `tokenId` exists.
779      *
780      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
781      *
782      * Tokens start existing when they are minted (`_mint`),
783      * and stop existing when they are burned (`_burn`).
784      */
785     function _exists(uint256 tokenId) internal view virtual returns (bool) {
786         return _owners[tokenId] != address(0);
787     }
788 
789     /**
790      * @dev Returns whether `spender` is allowed to manage `tokenId`.
791      *
792      * Requirements:
793      *
794      * - `tokenId` must exist.
795      */
796     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
797         require(_exists(tokenId), 'ERC721: operator query for nonexistent token');
798         address owner = ERC721.ownerOf(tokenId);
799         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
800     }
801 
802     /**
803      * @dev Safely mints `tokenId` and transfers it to `to`.
804      *
805      * Requirements:
806      *
807      * - `tokenId` must not exist.
808      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
809      *
810      * Emits a {Transfer} event.
811      */
812     function _safeMint(address to, uint256 tokenId) internal virtual {
813         _safeMint(to, tokenId, '');
814     }
815 
816     /**
817      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
818      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
819      */
820     function _safeMint(
821         address to,
822         uint256 tokenId,
823         bytes memory _data
824     ) internal virtual {
825         _mint(to, tokenId);
826         require(_checkOnERC721Received(address(0), to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
827     }
828 
829     /**
830      * @dev Mints `tokenId` and transfers it to `to`.
831      *
832      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
833      *
834      * Requirements:
835      *
836      * - `tokenId` must not exist.
837      * - `to` cannot be the zero address.
838      *
839      * Emits a {Transfer} event.
840      */
841     function _mint(address to, uint256 tokenId) internal virtual {
842         require(to != address(0), 'ERC721: mint to the zero address');
843         require(!_exists(tokenId), 'ERC721: token already minted');
844 
845         _beforeTokenTransfer(address(0), to, tokenId);
846 
847         _balances[to] += 1;
848         _owners[tokenId] = to;
849 
850         emit Transfer(address(0), to, tokenId);
851     }
852 
853     /**
854      * @dev Destroys `tokenId`.
855      * The approval is cleared when the token is burned.
856      *
857      * Requirements:
858      *
859      * - `tokenId` must exist.
860      *
861      * Emits a {Transfer} event.
862      */
863     function _burn(uint256 tokenId) internal virtual {
864         address owner = ERC721.ownerOf(tokenId);
865 
866         _beforeTokenTransfer(owner, address(0), tokenId);
867 
868         // Clear approvals
869         _approve(address(0), tokenId);
870 
871         _balances[owner] -= 1;
872         delete _owners[tokenId];
873 
874         emit Transfer(owner, address(0), tokenId);
875     }
876 
877     /**
878      * @dev Transfers `tokenId` from `from` to `to`.
879      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
880      *
881      * Requirements:
882      *
883      * - `to` cannot be the zero address.
884      * - `tokenId` token must be owned by `from`.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _transfer(
889         address from,
890         address to,
891         uint256 tokenId
892     ) internal virtual {
893         require(ERC721.ownerOf(tokenId) == from, 'ERC721: transfer of token that is not own');
894         require(to != address(0), 'ERC721: transfer to the zero address');
895 
896         _beforeTokenTransfer(from, to, tokenId);
897 
898         // Clear approvals from the previous owner
899         _approve(address(0), tokenId);
900 
901         _balances[from] -= 1;
902         _balances[to] += 1;
903         _owners[tokenId] = to;
904 
905         emit Transfer(from, to, tokenId);
906     }
907 
908     /**
909      * @dev Approve `to` to operate on `tokenId`
910      *
911      * Emits a {Approval} event.
912      */
913     function _approve(address to, uint256 tokenId) internal virtual {
914         _tokenApprovals[tokenId] = to;
915         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
916     }
917 
918     /**
919      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
920      * The call is not executed if the target address is not a contract.
921      *
922      * @param from address representing the previous owner of the given token ID
923      * @param to target address that will receive the tokens
924      * @param tokenId uint256 ID of the token to be transferred
925      * @param _data bytes optional data to send along with the call
926      * @return bool whether the call correctly returned the expected magic value
927      */
928     function _checkOnERC721Received(
929         address from,
930         address to,
931         uint256 tokenId,
932         bytes memory _data
933     ) private returns (bool) {
934         if (to.isContract()) {
935             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
936                 return retval == IERC721Receiver.onERC721Received.selector;
937             } catch (bytes memory reason) {
938                 if (reason.length == 0) {
939                     revert('ERC721: transfer to non ERC721Receiver implementer');
940                 } else {
941                     assembly {
942                         revert(add(32, reason), mload(reason))
943                     }
944                 }
945             }
946         } else {
947             return true;
948         }
949     }
950 
951     /**
952      * @dev Hook that is called before any token transfer. This includes minting
953      * and burning.
954      *
955      * Calling conditions:
956      *
957      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
958      * transferred to `to`.
959      * - When `from` is zero, `tokenId` will be minted for `to`.
960      * - When `to` is zero, ``from``'s `tokenId` will be burned.
961      * - `from` and `to` are never both zero.
962      *
963      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
964      */
965     function _beforeTokenTransfer(
966         address from,
967         address to,
968         uint256 tokenId
969     ) internal virtual {}
970 }
971 
972 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
973 
974 pragma solidity ^0.8.0;
975 
976 /**
977  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
978  * enumerability of all the token ids in the contract as well as all token ids owned by each
979  * account.
980  */
981 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
982     // Mapping from owner to list of owned token IDs
983     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
984 
985     // Mapping from token ID to index of the owner tokens list
986     mapping(uint256 => uint256) private _ownedTokensIndex;
987 
988     // Array with all token ids, used for enumeration
989     uint256[] private _allTokens;
990 
991     // Mapping from token id to position in the allTokens array
992     mapping(uint256 => uint256) private _allTokensIndex;
993 
994     /**
995      * @dev See {IERC165-supportsInterface}.
996      */
997     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
998         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
999     }
1000 
1001     /**
1002      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1003      */
1004     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1005         require(index < ERC721.balanceOf(owner), 'ERC721Enumerable: owner index out of bounds');
1006         return _ownedTokens[owner][index];
1007     }
1008 
1009     /**
1010      * @dev See {IERC721Enumerable-totalSupply}.
1011      */
1012     function totalSupply() public view virtual override returns (uint256) {
1013         return _allTokens.length;
1014     }
1015 
1016     /**
1017      * @dev See {IERC721Enumerable-tokenByIndex}.
1018      */
1019     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1020         require(index < ERC721Enumerable.totalSupply(), 'ERC721Enumerable: global index out of bounds');
1021         return _allTokens[index];
1022     }
1023 
1024     /**
1025      * @dev Hook that is called before any token transfer. This includes minting
1026      * and burning.
1027      *
1028      * Calling conditions:
1029      *
1030      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1031      * transferred to `to`.
1032      * - When `from` is zero, `tokenId` will be minted for `to`.
1033      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1034      * - `from` cannot be the zero address.
1035      * - `to` cannot be the zero address.
1036      *
1037      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1038      */
1039     function _beforeTokenTransfer(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) internal virtual override {
1044         super._beforeTokenTransfer(from, to, tokenId);
1045 
1046         if (from == address(0)) {
1047             _addTokenToAllTokensEnumeration(tokenId);
1048         } else if (from != to) {
1049             _removeTokenFromOwnerEnumeration(from, tokenId);
1050         }
1051         if (to == address(0)) {
1052             _removeTokenFromAllTokensEnumeration(tokenId);
1053         } else if (to != from) {
1054             _addTokenToOwnerEnumeration(to, tokenId);
1055         }
1056     }
1057 
1058     /**
1059      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1060      * @param to address representing the new owner of the given token ID
1061      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1062      */
1063     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1064         uint256 length = ERC721.balanceOf(to);
1065         _ownedTokens[to][length] = tokenId;
1066         _ownedTokensIndex[tokenId] = length;
1067     }
1068 
1069     /**
1070      * @dev Private function to add a token to this extension's token tracking data structures.
1071      * @param tokenId uint256 ID of the token to be added to the tokens list
1072      */
1073     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1074         _allTokensIndex[tokenId] = _allTokens.length;
1075         _allTokens.push(tokenId);
1076     }
1077 
1078     /**
1079      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1080      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1081      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1082      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1083      * @param from address representing the previous owner of the given token ID
1084      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1085      */
1086     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1087         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1088         // then delete the last slot (swap and pop).
1089 
1090         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1091         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1092 
1093         // When the token to delete is the last token, the swap operation is unnecessary
1094         if (tokenIndex != lastTokenIndex) {
1095             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1096 
1097             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1098             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1099         }
1100 
1101         // This also deletes the contents at the last position of the array
1102         delete _ownedTokensIndex[tokenId];
1103         delete _ownedTokens[from][lastTokenIndex];
1104     }
1105 
1106     /**
1107      * @dev Private function to remove a token from this extension's token tracking data structures.
1108      * This has O(1) time complexity, but alters the order of the _allTokens array.
1109      * @param tokenId uint256 ID of the token to be removed from the tokens list
1110      */
1111     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1112         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1113         // then delete the last slot (swap and pop).
1114 
1115         uint256 lastTokenIndex = _allTokens.length - 1;
1116         uint256 tokenIndex = _allTokensIndex[tokenId];
1117 
1118         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1119         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1120         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1121         uint256 lastTokenId = _allTokens[lastTokenIndex];
1122 
1123         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1124         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1125 
1126         // This also deletes the contents at the last position of the array
1127         delete _allTokensIndex[tokenId];
1128         _allTokens.pop();
1129     }
1130 }
1131 
1132 // File: @openzeppelin/contracts/access/Ownable.sol
1133 pragma solidity ^0.8.0;
1134 
1135 /**
1136  * @dev Contract module which provides a basic access control mechanism, where
1137  * there is an account (an owner) that can be granted exclusive access to
1138  * specific functions.
1139  *
1140  * By default, the owner account will be the one that deploys the contract. This
1141  * can later be changed with {transferOwnership}.
1142  *
1143  * This module is used through inheritance. It will make available the modifier
1144  * `onlyOwner`, which can be applied to your functions to restrict their use to
1145  * the owner.
1146  */
1147 abstract contract Ownable is Context {
1148     address private _owner;
1149 
1150     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1151 
1152     /**
1153      * @dev Initializes the contract setting the deployer as the initial owner.
1154      */
1155     constructor() {
1156         _setOwner(_msgSender());
1157     }
1158 
1159     /**
1160      * @dev Returns the address of the current owner.
1161      */
1162     function owner() public view virtual returns (address) {
1163         return _owner;
1164     }
1165 
1166     /**
1167      * @dev Throws if called by any account other than the owner.
1168      */
1169     modifier onlyOwner() {
1170         require(owner() == _msgSender(), 'Ownable: caller is not the owner');
1171         _;
1172     }
1173 
1174     /**
1175      * @dev Leaves the contract without owner. It will not be possible to call
1176      * `onlyOwner` functions anymore. Can only be called by the current owner.
1177      *
1178      * NOTE: Renouncing ownership will leave the contract without an owner,
1179      * thereby removing any functionality that is only available to the owner.
1180      */
1181     function renounceOwnership() public virtual onlyOwner {
1182         _setOwner(address(0));
1183     }
1184 
1185     /**
1186      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1187      * Can only be called by the current owner.
1188      */
1189     function transferOwnership(address newOwner) public virtual onlyOwner {
1190         require(newOwner != address(0), 'Ownable: new owner is the zero address');
1191         _setOwner(newOwner);
1192     }
1193 
1194     function _setOwner(address newOwner) private {
1195         address oldOwner = _owner;
1196         _owner = newOwner;
1197         emit OwnershipTransferred(oldOwner, newOwner);
1198     }
1199 }
1200 
1201 pragma solidity >=0.7.0 <0.9.0;
1202 
1203 contract HeadboxSquad is ERC721Enumerable, Ownable {
1204     using Strings for uint256;
1205 
1206     string public baseURI;
1207     string public baseExtension = '.json';
1208     string public notRevealedUri;
1209     uint256 public cost = 0.04 ether;
1210     uint256 public maxSupply = 10000;
1211     uint256 public maxMintAmount = 20;
1212 
1213     // track member from minted nft (max 200 nft) ~ Wahyu
1214     uint256 public maxMemberNftSupply = 200;
1215     uint256 public totalNftMintedByMember = 0;
1216 
1217     // OG Minting (max 300 nft)
1218     uint256 public maxOGNftSupply = 300;
1219     uint256 public totalNftMintedByOG = 0;
1220     uint256 public maxMintAmountForOG = 1;
1221     bool public OGCanMint = false;
1222 
1223     bool public paused = true;
1224     bool public revealed = false;
1225     address[] public memberAddresses;
1226     mapping(address => uint256) public addressMintedBalance;
1227 
1228     constructor(
1229         string memory _name,
1230         string memory _symbol,
1231         string memory _initBaseURI,
1232         string memory _initNotRevealedUri
1233     ) ERC721(_name, _symbol) {
1234         setBaseURI(_initBaseURI);
1235         setNotRevealedURI(_initNotRevealedUri);
1236     }
1237 
1238     // internal
1239     function _baseURI() internal view virtual override returns (string memory) {
1240         return baseURI;
1241     }
1242 
1243     // public
1244     function mint(uint256 _mintAmount) public payable {
1245         require(!paused, 'the contract is paused');
1246         uint256 supply = totalSupply();
1247         require(_mintAmount > 0, 'need to mint at least 1 NFT');
1248         require(supply + _mintAmount <= maxSupply, 'max NFT limit exceeded');
1249 
1250         if (msg.sender != owner()) {
1251             if (isMember(msg.sender)) {
1252                 uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1253                 require(ownerMintedCount + _mintAmount <= maxMemberNftSupply, 'max NFT of member exceeded');
1254                 require(totalNftMintedByMember + _mintAmount <= maxMemberNftSupply, 'max NFT of member exceeded');
1255 
1256                 // incrementing totalNftMintedByMember ~ Wahyu
1257                 totalNftMintedByMember = totalNftMintedByMember + _mintAmount;
1258             } else if (OGCanMint == true) {
1259                 uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1260                 require(ownerMintedCount + _mintAmount <= maxMintAmountForOG, 'You can only minting one NFT on this OG minting.');
1261                 require(totalNftMintedByOG + _mintAmount <= maxOGNftSupply, 'max NFT for OG limit exceeded');
1262 
1263                 totalNftMintedByOG = totalNftMintedByOG + _mintAmount;
1264             } else {
1265                 uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1266                 require(ownerMintedCount + _mintAmount <= maxMintAmount, 'You can only minting max 20 NFT');
1267                 require(_mintAmount <= maxMintAmount, 'max mint amount per session exceeded');
1268                 require(msg.value >= cost * _mintAmount, 'insufficient funds');
1269             }
1270         }
1271 
1272         for (uint256 i = 1; i <= _mintAmount; i++) {
1273             addressMintedBalance[msg.sender]++;
1274             _safeMint(msg.sender, supply + i);
1275         }
1276     }
1277 
1278     function isMember(address _user) public view returns (bool) {
1279         for (uint256 i = 0; i < memberAddresses.length; i++) {
1280             if (memberAddresses[i] == _user) {
1281                 return true;
1282             }
1283         }
1284         return false;
1285     }
1286 
1287     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1288         uint256 ownerTokenCount = balanceOf(_owner);
1289         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1290         for (uint256 i; i < ownerTokenCount; i++) {
1291             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1292         }
1293         return tokenIds;
1294     }
1295 
1296     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1297         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1298 
1299         if (revealed == false) {
1300             return notRevealedUri;
1301         }
1302 
1303         string memory currentBaseURI = _baseURI();
1304         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : '';
1305     }
1306 
1307     //only owner
1308     function reveal() public onlyOwner {
1309         revealed = true;
1310     }
1311 
1312     function setMaxMintAmountForOG(uint256 _amount) public onlyOwner {
1313         maxMintAmountForOG = _amount;
1314     }
1315 
1316     function setMaxMemberNFtSupply(uint256 _limit) public onlyOwner {
1317         maxMemberNftSupply = _limit;
1318     }
1319 
1320     function setCost(uint256 _newCost) public onlyOwner {
1321         cost = _newCost;
1322     }
1323 
1324     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1325         maxMintAmount = _newmaxMintAmount;
1326     }
1327 
1328     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1329         baseURI = _newBaseURI;
1330     }
1331 
1332     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1333         baseExtension = _newBaseExtension;
1334     }
1335 
1336     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1337         notRevealedUri = _notRevealedURI;
1338     }
1339 
1340     function pause(bool _state) public onlyOwner {
1341         paused = _state;
1342     }
1343 
1344     function setOGCanMint(bool _state) public onlyOwner {
1345         OGCanMint = _state;
1346     }
1347 
1348     function setMemberAddresses(address[] calldata _users) public onlyOwner {
1349         delete memberAddresses;
1350         memberAddresses = _users;
1351     }
1352 
1353     function withdraw() public payable onlyOwner {
1354         (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1355         require(os);
1356     }
1357 }