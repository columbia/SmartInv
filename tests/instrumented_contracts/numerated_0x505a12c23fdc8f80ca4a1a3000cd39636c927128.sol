1 /*
2 ███████╗██╗   ██╗███╗   ██╗ ██████╗██████╗  ██████╗ ███╗   ██╗ █████╗ ██╗   ██╗████████╗███████╗
3 ██╔════╝╚██╗ ██╔╝████╗  ██║██╔════╝██╔══██╗██╔═══██╗████╗  ██║██╔══██╗██║   ██║╚══██╔══╝██╔════╝
4 ███████╗ ╚████╔╝ ██╔██╗ ██║██║     ██████╔╝██║   ██║██╔██╗ ██║███████║██║   ██║   ██║   ███████╗
5 ╚════██║  ╚██╔╝  ██║╚██╗██║██║     ██╔══██╗██║   ██║██║╚██╗██║██╔══██║██║   ██║   ██║   ╚════██║
6 ███████║   ██║   ██║ ╚████║╚██████╗██║  ██║╚██████╔╝██║ ╚████║██║  ██║╚██████╔╝   ██║   ███████║
7 ╚══════╝   ╚═╝   ╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚══════╝  DAO */
8 // SPDX-License-Identifier: GPL-3.0
9 
10 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
11 pragma solidity ^0.8.0;
12 /**
13  * @dev Interface of the ERC165 standard, as defined in the
14  * https://eips.ethereum.org/EIPS/eip-165[EIP].
15  *
16  * Implementers can declare support of contract interfaces, which can then be
17  * queried by others ({ERC165Checker}).
18  *
19  * For an implementation, see {ERC165}.
20  */
21 interface IERC165 {
22     /**
23      * @dev Returns true if this contract implements the interface defined by
24      * `interfaceId`. See the corresponding
25      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
26      * to learn more about how these ids are created.
27      *
28      * This function call must use less than 30 000 gas.
29      */
30     function supportsInterface(bytes4 interfaceId) external view returns (bool);
31 }
32 
33 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
34 pragma solidity ^0.8.0;
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
70      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(
83         address from,
84         address to,
85         uint256 tokenId
86     ) external;
87 
88     /**
89      * @dev Transfers `tokenId` token from `from` to `to`.
90      *
91      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must be owned by `from`.
98      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
110      * The approval is cleared when the token is transferred.
111      *
112      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
113      *
114      * Requirements:
115      *
116      * - The caller must own the token or be an approved operator.
117      * - `tokenId` must exist.
118      *
119      * Emits an {Approval} event.
120      */
121     function approve(address to, uint256 tokenId) external;
122 
123     /**
124      * @dev Returns the account approved for `tokenId` token.
125      *
126      * Requirements:
127      *
128      * - `tokenId` must exist.
129      */
130     function getApproved(uint256 tokenId) external view returns (address operator);
131 
132     /**
133      * @dev Approve or remove `operator` as an operator for the caller.
134      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
135      *
136      * Requirements:
137      *
138      * - The `operator` cannot be the caller.
139      *
140      * Emits an {ApprovalForAll} event.
141      */
142     function setApprovalForAll(address operator, bool _approved) external;
143 
144     /**
145      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
146      *
147      * See {setApprovalForAll}
148      */
149     function isApprovedForAll(address owner, address operator) external view returns (bool);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId,
168         bytes calldata data
169     ) external;
170 }
171 
172 
173 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
174 pragma solidity ^0.8.0;
175 /**
176  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
177  * @dev See https://eips.ethereum.org/EIPS/eip-721
178  */
179 interface IERC721Enumerable is IERC721 {
180     /**
181      * @dev Returns the total amount of tokens stored by the contract.
182      */
183     function totalSupply() external view returns (uint256);
184 
185     /**
186      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
187      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
188      */
189     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
190 
191     /**
192      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
193      * Use along with {totalSupply} to enumerate all tokens.
194      */
195     function tokenByIndex(uint256 index) external view returns (uint256);
196 }
197 
198 
199 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
200 pragma solidity ^0.8.0;
201 /**
202  * @dev Implementation of the {IERC165} interface.
203  *
204  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
205  * for the additional interface id that will be supported. For example:
206  *
207  * ```solidity
208  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
209  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
210  * }
211  * ```
212  *
213  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
214  */
215 abstract contract ERC165 is IERC165 {
216     /**
217      * @dev See {IERC165-supportsInterface}.
218      */
219     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
220         return interfaceId == type(IERC165).interfaceId;
221     }
222 }
223 
224 // File: @openzeppelin/contracts/utils/Strings.sol
225 
226 
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev String operations.
232  */
233 library Strings {
234     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
235 
236     /**
237      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
238      */
239     function toString(uint256 value) internal pure returns (string memory) {
240 
241 
242         if (value == 0) {
243             return "0";
244         }
245         uint256 temp = value;
246         uint256 digits;
247         while (temp != 0) {
248             digits++;
249             temp /= 10;
250         }
251         bytes memory buffer = new bytes(digits);
252         while (value != 0) {
253             digits -= 1;
254             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
255             value /= 10;
256         }
257         return string(buffer);
258     }
259 
260     /**
261      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
262      */
263     function toHexString(uint256 value) internal pure returns (string memory) {
264         if (value == 0) {
265             return "0x00";
266         }
267         uint256 temp = value;
268         uint256 length = 0;
269         while (temp != 0) {
270             length++;
271             temp >>= 8;
272         }
273         return toHexString(value, length);
274     }
275 
276     /**
277      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
278      */
279     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
280         bytes memory buffer = new bytes(2 * length + 2);
281         buffer[0] = "0";
282         buffer[1] = "x";
283         for (uint256 i = 2 * length + 1; i > 1; --i) {
284             buffer[i] = _HEX_SYMBOLS[value & 0xf];
285             value >>= 4;
286         }
287         require(value == 0, "Strings: hex length insufficient");
288         return string(buffer);
289     }
290 }
291 
292 // File: @openzeppelin/contracts/utils/Address.sol
293 
294 
295 
296 pragma solidity ^0.8.0;
297 
298 /**
299  * @dev Collection of functions related to the address type
300  */
301 library Address {
302     /**
303      * @dev Returns true if `account` is a contract.
304      *
305      * [IMPORTANT]
306      * ====
307      * It is unsafe to assume that an address for which this function returns
308      * false is an externally-owned account (EOA) and not a contract.
309      *
310      * Among others, `isContract` will return false for the following
311      * types of addresses:
312      *
313      *  - an externally-owned account
314      *  - a contract in construction
315      *  - an address where a contract will be created
316      *  - an address where a contract lived, but was destroyed
317      * ====
318      */
319     function isContract(address account) internal view returns (bool) {
320         // This method relies on extcodesize, which returns 0 for contracts in
321         // construction, since the code is only stored at the end of the
322         // constructor execution.
323 
324         uint256 size;
325         assembly {
326             size := extcodesize(account)
327         }
328         return size > 0;
329     }
330 
331     /**
332      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
333      * `recipient`, forwarding all available gas and reverting on errors.
334      *
335      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
336      * of certain opcodes, possibly making contracts go over the 2300 gas limit
337      * imposed by `transfer`, making them unable to receive funds via
338      * `transfer`. {sendValue} removes this limitation.
339      *
340      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
341      *
342      * IMPORTANT: because control is transferred to `recipient`, care must be
343      * taken to not create reentrancy vulnerabilities. Consider using
344      * {ReentrancyGuard} or the
345      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
346      */
347     function sendValue(address payable recipient, uint256 amount) internal {
348         require(address(this).balance >= amount, "Address: insufficient balance");
349 
350         (bool success, ) = recipient.call{value: amount}("");
351         require(success, "Address: unable to send value, recipient may have reverted");
352     }
353 
354     /**
355      * @dev Performs a Solidity function call using a low level `call`. A
356      * plain `call` is an unsafe replacement for a function call: use this
357      * function instead.
358      *
359      * If `target` reverts with a revert reason, it is bubbled up by this
360      * function (like regular Solidity function calls).
361      *
362      * Returns the raw returned data. To convert to the expected return value,
363      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
364      *
365      * Requirements:
366      *
367      * - `target` must be a contract.
368      * - calling `target` with `data` must not revert.
369      *
370      * _Available since v3.1._
371      */
372     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
373         return functionCall(target, data, "Address: low-level call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
378      * `errorMessage` as a fallback revert reason when `target` reverts.
379      *
380      * _Available since v3.1._
381      */
382     function functionCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal returns (bytes memory) {
387         return functionCallWithValue(target, data, 0, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but also transferring `value` wei to `target`.
393      *
394      * Requirements:
395      *
396      * - the calling contract must have an ETH balance of at least `value`.
397      * - the called Solidity function must be `payable`.
398      *
399      * _Available since v3.1._
400      */
401     function functionCallWithValue(
402         address target,
403         bytes memory data,
404         uint256 value
405     ) internal returns (bytes memory) {
406         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
411      * with `errorMessage` as a fallback revert reason when `target` reverts.
412      *
413      * _Available since v3.1._
414      */
415     function functionCallWithValue(
416         address target,
417         bytes memory data,
418         uint256 value,
419         string memory errorMessage
420     ) internal returns (bytes memory) {
421         require(address(this).balance >= value, "Address: insufficient balance for call");
422         require(isContract(target), "Address: call to non-contract");
423 
424         (bool success, bytes memory returndata) = target.call{value: value}(data);
425         return verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
430      * but performing a static call.
431      *
432      * _Available since v3.3._
433      */
434     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
435         return functionStaticCall(target, data, "Address: low-level static call failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
440      * but performing a static call.
441      *
442      * _Available since v3.3._
443      */
444     function functionStaticCall(
445         address target,
446         bytes memory data,
447         string memory errorMessage
448     ) internal view returns (bytes memory) {
449         require(isContract(target), "Address: static call to non-contract");
450 
451         (bool success, bytes memory returndata) = target.staticcall(data);
452         return verifyCallResult(success, returndata, errorMessage);
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
457      * but performing a delegate call.
458      *
459      * _Available since v3.4._
460      */
461     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
462         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
467      * but performing a delegate call.
468      *
469      * _Available since v3.4._
470      */
471     function functionDelegateCall(
472         address target,
473         bytes memory data,
474         string memory errorMessage
475     ) internal returns (bytes memory) {
476         require(isContract(target), "Address: delegate call to non-contract");
477 
478         (bool success, bytes memory returndata) = target.delegatecall(data);
479         return verifyCallResult(success, returndata, errorMessage);
480     }
481 
482     /**
483      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
484      * revert reason using the provided one.
485      *
486      * _Available since v4.3._
487      */
488     function verifyCallResult(
489         bool success,
490         bytes memory returndata,
491         string memory errorMessage
492     ) internal pure returns (bytes memory) {
493         if (success) {
494             return returndata;
495         } else {
496             // Look for revert reason and bubble it up if present
497             if (returndata.length > 0) {
498                 // The easiest way to bubble the revert reason is using memory via assembly
499 
500                 assembly {
501                     let returndata_size := mload(returndata)
502                     revert(add(32, returndata), returndata_size)
503                 }
504             } else {
505                 revert(errorMessage);
506             }
507         }
508     }
509 }
510 
511 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
512 
513 
514 
515 pragma solidity ^0.8.0;
516 
517 
518 /**
519  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
520  * @dev See https://eips.ethereum.org/EIPS/eip-721
521  */
522 interface IERC721Metadata is IERC721 {
523     /**
524      * @dev Returns the token collection name.
525      */
526     function name() external view returns (string memory);
527 
528     /**
529      * @dev Returns the token collection symbol.
530      */
531     function symbol() external view returns (string memory);
532 
533     /**
534      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
535      */
536     function tokenURI(uint256 tokenId) external view returns (string memory);
537 }
538 
539 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
540 
541 
542 
543 pragma solidity ^0.8.0;
544 
545 /**
546  * @title ERC721 token receiver interface
547  * @dev Interface for any contract that wants to support safeTransfers
548  * from ERC721 asset contracts.
549  */
550 interface IERC721Receiver {
551     /**
552      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
553      * by `operator` from `from`, this function is called.
554      *
555      * It must return its Solidity selector to confirm the token transfer.
556      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
557      *
558      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
559      */
560     function onERC721Received(
561         address operator,
562         address from,
563         uint256 tokenId,
564         bytes calldata data
565     ) external returns (bytes4);
566 }
567 
568 // File: @openzeppelin/contracts/utils/Context.sol
569 pragma solidity ^0.8.0;
570 /**
571  * @dev Provides information about the current execution context, including the
572  * sender of the transaction and its data. While these are generally available
573  * via msg.sender and msg.data, they should not be accessed in such a direct
574  * manner, since when dealing with meta-transactions the account sending and
575  * paying for execution may not be the actual sender (as far as an application
576  * is concerned).
577  *
578  * This contract is only required for intermediate, library-like contracts.
579  */
580 abstract contract Context {
581     function _msgSender() internal view virtual returns (address) {
582         return msg.sender;
583     }
584 
585     function _msgData() internal view virtual returns (bytes calldata) {
586         return msg.data;
587     }
588 }
589 
590 
591 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
592 pragma solidity ^0.8.0;
593 /**
594  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
595  * the Metadata extension, but not including the Enumerable extension, which is available separately as
596  * {ERC721Enumerable}.
597  */
598 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
599     using Address for address;
600     using Strings for uint256;
601 
602     // Token name
603     string private _name;
604 
605     // Token symbol
606     string private _symbol;
607 
608     // Mapping from token ID to owner address
609     mapping(uint256 => address) private _owners;
610 
611     // Mapping owner address to token count
612     mapping(address => uint256) private _balances;
613 
614     // Mapping from token ID to approved address
615     mapping(uint256 => address) private _tokenApprovals;
616 
617     // Mapping from owner to operator approvals
618     mapping(address => mapping(address => bool)) private _operatorApprovals;
619 
620     /**
621      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
622      */
623     constructor(string memory name_, string memory symbol_) {
624         _name = name_;
625         _symbol = symbol_;
626     }
627 
628     /**
629      * @dev See {IERC165-supportsInterface}.
630      */
631     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
632         return
633             interfaceId == type(IERC721).interfaceId ||
634             interfaceId == type(IERC721Metadata).interfaceId ||
635             super.supportsInterface(interfaceId);
636     }
637 
638     /**
639      * @dev See {IERC721-balanceOf}.
640      */
641     function balanceOf(address owner) public view virtual override returns (uint256) {
642         require(owner != address(0), "ERC721: balance query for the zero address");
643         return _balances[owner];
644     }
645 
646     /**
647      * @dev See {IERC721-ownerOf}.
648      */
649     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
650         address owner = _owners[tokenId];
651         require(owner != address(0), "ERC721: owner query for nonexistent token");
652         return owner;
653     }
654 
655     /**
656      * @dev See {IERC721Metadata-name}.
657      */
658     function name() public view virtual override returns (string memory) {
659         return _name;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-symbol}.
664      */
665     function symbol() public view virtual override returns (string memory) {
666         return _symbol;
667     }
668 
669     /**
670      * @dev See {IERC721Metadata-tokenURI}.
671      */
672     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
673         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
674 
675         string memory baseURI = _baseURI();
676         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
677     }
678 
679     /**
680      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
681      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
682      * by default, can be overriden in child contracts.
683      */
684     function _baseURI() internal view virtual returns (string memory) {
685         return "";
686     }
687 
688     /**
689      * @dev See {IERC721-approve}.
690      */
691     function approve(address to, uint256 tokenId) public virtual override {
692         address owner = ERC721.ownerOf(tokenId);
693         require(to != owner, "ERC721: approval to current owner");
694 
695         require(
696             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
697             "ERC721: approve caller is not owner nor approved for all"
698         );
699 
700         _approve(to, tokenId);
701     }
702 
703     /**
704      * @dev See {IERC721-getApproved}.
705      */
706     function getApproved(uint256 tokenId) public view virtual override returns (address) {
707         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
708 
709         return _tokenApprovals[tokenId];
710     }
711 
712     /**
713      * @dev See {IERC721-setApprovalForAll}.
714      */
715     function setApprovalForAll(address operator, bool approved) public virtual override {
716         require(operator != _msgSender(), "ERC721: approve to caller");
717 
718         _operatorApprovals[_msgSender()][operator] = approved;
719         emit ApprovalForAll(_msgSender(), operator, approved);
720     }
721 
722     /**
723      * @dev See {IERC721-isApprovedForAll}.
724      */
725     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
726         return _operatorApprovals[owner][operator];
727     }
728 
729     /**
730      * @dev See {IERC721-transferFrom}.
731      */
732     function transferFrom(
733         address from,
734         address to,
735         uint256 tokenId
736     ) public virtual override {
737         //solhint-disable-next-line max-line-length
738         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
739 
740         _transfer(from, to, tokenId);
741     }
742 
743     /**
744      * @dev See {IERC721-safeTransferFrom}.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId
750     ) public virtual override {
751         safeTransferFrom(from, to, tokenId, "");
752     }
753 
754     /**
755      * @dev See {IERC721-safeTransferFrom}.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId,
761         bytes memory _data
762     ) public virtual override {
763         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
764         _safeTransfer(from, to, tokenId, _data);
765     }
766 
767     /**
768      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
769      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
770      *
771      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
772      *
773      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
774      * implement alternative mechanisms to perform token transfer, such as signature-based.
775      *
776      * Requirements:
777      *
778      * - `from` cannot be the zero address.
779      * - `to` cannot be the zero address.
780      * - `tokenId` token must exist and be owned by `from`.
781      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
782      *
783      * Emits a {Transfer} event.
784      */
785     function _safeTransfer(
786         address from,
787         address to,
788         uint256 tokenId,
789         bytes memory _data
790     ) internal virtual {
791         _transfer(from, to, tokenId);
792         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
793     }
794 
795     /**
796      * @dev Returns whether `tokenId` exists.
797      *
798      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
799      *
800      * Tokens start existing when they are minted (`_mint`),
801      * and stop existing when they are burned (`_burn`).
802      */
803     function _exists(uint256 tokenId) internal view virtual returns (bool) {
804         return _owners[tokenId] != address(0);
805     }
806 
807     /**
808      * @dev Returns whether `spender` is allowed to manage `tokenId`.
809      *
810      * Requirements:
811      *
812      * - `tokenId` must exist.
813      */
814     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
815         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
816         address owner = ERC721.ownerOf(tokenId);
817         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
818     }
819 
820     /**
821      * @dev Safely mints `tokenId` and transfers it to `to`.
822      *
823      * Requirements:
824      *
825      * - `tokenId` must not exist.
826      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _safeMint(address to, uint256 tokenId) internal virtual {
831         _safeMint(to, tokenId, "");
832     }
833 
834     /**
835      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
836      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
837      */
838     function _safeMint(
839         address to,
840         uint256 tokenId,
841         bytes memory _data
842     ) internal virtual {
843         _mint(to, tokenId);
844         require(
845             _checkOnERC721Received(address(0), to, tokenId, _data),
846             "ERC721: transfer to non ERC721Receiver implementer"
847         );
848     }
849 
850     /**
851      * @dev Mints `tokenId` and transfers it to `to`.
852      *
853      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
854      *
855      * Requirements:
856      *
857      * - `tokenId` must not exist.
858      * - `to` cannot be the zero address.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _mint(address to, uint256 tokenId) internal virtual {
863         require(to != address(0), "ERC721: mint to the zero address");
864         require(!_exists(tokenId), "ERC721: token already minted");
865 
866         _beforeTokenTransfer(address(0), to, tokenId);
867 
868         _balances[to] += 1;
869         _owners[tokenId] = to;
870 
871         emit Transfer(address(0), to, tokenId);
872     }
873 
874     /**
875      * @dev Destroys `tokenId`.
876      * The approval is cleared when the token is burned.
877      *
878      * Requirements:
879      *
880      * - `tokenId` must exist.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _burn(uint256 tokenId) internal virtual {
885         address owner = ERC721.ownerOf(tokenId);
886 
887         _beforeTokenTransfer(owner, address(0), tokenId);
888 
889         // Clear approvals
890         _approve(address(0), tokenId);
891 
892         _balances[owner] -= 1;
893         delete _owners[tokenId];
894 
895         emit Transfer(owner, address(0), tokenId);
896     }
897 
898     /**
899      * @dev Transfers `tokenId` from `from` to `to`.
900      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
901      *
902      * Requirements:
903      *
904      * - `to` cannot be the zero address.
905      * - `tokenId` token must be owned by `from`.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _transfer(
910         address from,
911         address to,
912         uint256 tokenId
913     ) internal virtual {
914         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
915         require(to != address(0), "ERC721: transfer to the zero address");
916 
917         _beforeTokenTransfer(from, to, tokenId);
918 
919         // Clear approvals from the previous owner
920         _approve(address(0), tokenId);
921 
922         _balances[from] -= 1;
923         _balances[to] += 1;
924         _owners[tokenId] = to;
925 
926         emit Transfer(from, to, tokenId);
927     }
928 
929     /**
930      * @dev Approve `to` to operate on `tokenId`
931      *
932      * Emits a {Approval} event.
933      */
934     function _approve(address to, uint256 tokenId) internal virtual {
935         _tokenApprovals[tokenId] = to;
936         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
937     }
938 
939     /**
940      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
941      * The call is not executed if the target address is not a contract.
942      *
943      * @param from address representing the previous owner of the given token ID
944      * @param to target address that will receive the tokens
945      * @param tokenId uint256 ID of the token to be transferred
946      * @param _data bytes optional data to send along with the call
947      * @return bool whether the call correctly returned the expected magic value
948      */
949     function _checkOnERC721Received(
950         address from,
951         address to,
952         uint256 tokenId,
953         bytes memory _data
954     ) private returns (bool) {
955         if (to.isContract()) {
956             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
957                 return retval == IERC721Receiver.onERC721Received.selector;
958             } catch (bytes memory reason) {
959                 if (reason.length == 0) {
960                     revert("ERC721: transfer to non ERC721Receiver implementer");
961                 } else {
962                     assembly {
963                         revert(add(32, reason), mload(reason))
964                     }
965                 }
966             }
967         } else {
968             return true;
969         }
970     }
971 
972     /**
973      * @dev Hook that is called before any token transfer. This includes minting
974      * and burning.
975      *
976      * Calling conditions:
977      *
978      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
979      * transferred to `to`.
980      * - When `from` is zero, `tokenId` will be minted for `to`.
981      * - When `to` is zero, ``from``'s `tokenId` will be burned.
982      * - `from` and `to` are never both zero.
983      *
984      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
985      */
986     function _beforeTokenTransfer(
987         address from,
988         address to,
989         uint256 tokenId
990     ) internal virtual {}
991 }
992 
993 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
994 
995 
996 
997 pragma solidity ^0.8.0;
998 
999 
1000 
1001 /**
1002  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1003  * enumerability of all the token ids in the contract as well as all token ids owned by each
1004  * account.
1005  */
1006 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1007     // Mapping from owner to list of owned token IDs
1008     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1009 
1010     // Mapping from token ID to index of the owner tokens list
1011     mapping(uint256 => uint256) private _ownedTokensIndex;
1012 
1013     // Array with all token ids, used for enumeration
1014     uint256[] private _allTokens;
1015 
1016     // Mapping from token id to position in the allTokens array
1017     mapping(uint256 => uint256) private _allTokensIndex;
1018 
1019     /**
1020      * @dev See {IERC165-supportsInterface}.
1021      */
1022     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1023         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1024     }
1025 
1026     /**
1027      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1028      */
1029     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1030         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1031         return _ownedTokens[owner][index];
1032     }
1033 
1034     /**
1035      * @dev See {IERC721Enumerable-totalSupply}.
1036      */
1037     function totalSupply() public view virtual override returns (uint256) {
1038         return _allTokens.length;
1039     }
1040 
1041     /**
1042      * @dev See {IERC721Enumerable-tokenByIndex}.
1043      */
1044     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1045         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1046         return _allTokens[index];
1047     }
1048 
1049     /**
1050      * @dev Hook that is called before any token transfer. This includes minting
1051      * and burning.
1052      *
1053      * Calling conditions:
1054      *
1055      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1056      * transferred to `to`.
1057      * - When `from` is zero, `tokenId` will be minted for `to`.
1058      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1059      * - `from` cannot be the zero address.
1060      * - `to` cannot be the zero address.
1061      *
1062      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1063      */
1064     function _beforeTokenTransfer(
1065         address from,
1066         address to,
1067         uint256 tokenId
1068     ) internal virtual override {
1069         super._beforeTokenTransfer(from, to, tokenId);
1070 
1071         if (from == address(0)) {
1072             _addTokenToAllTokensEnumeration(tokenId);
1073         } else if (from != to) {
1074             _removeTokenFromOwnerEnumeration(from, tokenId);
1075         }
1076         if (to == address(0)) {
1077             _removeTokenFromAllTokensEnumeration(tokenId);
1078         } else if (to != from) {
1079             _addTokenToOwnerEnumeration(to, tokenId);
1080         }
1081     }
1082 
1083     /**
1084      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1085      * @param to address representing the new owner of the given token ID
1086      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1087      */
1088     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1089         uint256 length = ERC721.balanceOf(to);
1090         _ownedTokens[to][length] = tokenId;
1091         _ownedTokensIndex[tokenId] = length;
1092     }
1093 
1094     /**
1095      * @dev Private function to add a token to this extension's token tracking data structures.
1096      * @param tokenId uint256 ID of the token to be added to the tokens list
1097      */
1098     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1099         _allTokensIndex[tokenId] = _allTokens.length;
1100         _allTokens.push(tokenId);
1101     }
1102 
1103     /**
1104      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1105      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1106      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1107      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1108      * @param from address representing the previous owner of the given token ID
1109      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1110      */
1111     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1112         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1113         // then delete the last slot (swap and pop).
1114 
1115         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1116         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1117 
1118         // When the token to delete is the last token, the swap operation is unnecessary
1119         if (tokenIndex != lastTokenIndex) {
1120             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1121 
1122             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1123             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1124         }
1125 
1126         // This also deletes the contents at the last position of the array
1127         delete _ownedTokensIndex[tokenId];
1128         delete _ownedTokens[from][lastTokenIndex];
1129     }
1130 
1131     /**
1132      * @dev Private function to remove a token from this extension's token tracking data structures.
1133      * This has O(1) time complexity, but alters the order of the _allTokens array.
1134      * @param tokenId uint256 ID of the token to be removed from the tokens list
1135      */
1136     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1137         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1138         // then delete the last slot (swap and pop).
1139 
1140         uint256 lastTokenIndex = _allTokens.length - 1;
1141         uint256 tokenIndex = _allTokensIndex[tokenId];
1142 
1143         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1144         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1145         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1146         uint256 lastTokenId = _allTokens[lastTokenIndex];
1147 
1148         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1149         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1150 
1151         // This also deletes the contents at the last position of the array
1152         delete _allTokensIndex[tokenId];
1153         _allTokens.pop();
1154     }
1155 }
1156 
1157 
1158 // File: @openzeppelin/contracts/access/Ownable.sol
1159 pragma solidity ^0.8.0;
1160 /**
1161  * @dev Contract module which provides a basic access control mechanism, where
1162  * there is an account (an owner) that can be granted exclusive access to
1163  * specific functions.
1164  *
1165  * By default, the owner account will be the one that deploys the contract. This
1166  * can later be changed with {transferOwnership}.
1167  *
1168  * This module is used through inheritance. It will make available the modifier
1169  * `onlyOwner`, which can be applied to your functions to restrict their use to
1170  * the owner.
1171  */
1172 abstract contract Ownable is Context {
1173     address private _owner;
1174 
1175     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1176 
1177     /**
1178      * @dev Initializes the contract setting the deployer as the initial owner.
1179      */
1180     constructor() {
1181         _setOwner(_msgSender());
1182     }
1183 
1184     /**
1185      * @dev Returns the address of the current owner.
1186      */
1187     function owner() public view virtual returns (address) {
1188         return _owner;
1189     }
1190 
1191     /**
1192      * @dev Throws if called by any account other than the owner.
1193      */
1194     modifier onlyOwner() {
1195         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1196         _;
1197     }
1198 
1199     /**
1200      * @dev Leaves the contract without owner. It will not be possible to call
1201      * `onlyOwner` functions anymore. Can only be called by the current owner.
1202      *
1203      * NOTE: Renouncing ownership will leave the contract without an owner,
1204      * thereby removing any functionality that is only available to the owner.
1205      */
1206     function renounceOwnership() public virtual onlyOwner {
1207         _setOwner(address(0));
1208     }
1209 
1210     /**
1211      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1212      * Can only be called by the current owner.
1213      */
1214     function transferOwnership(address newOwner) public virtual onlyOwner {
1215         require(newOwner != address(0), "Ownable: new owner is the zero address");
1216         _setOwner(newOwner);
1217     }
1218 
1219     function _setOwner(address newOwner) private {
1220         address oldOwner = _owner;
1221         _owner = newOwner;
1222         emit OwnershipTransferred(oldOwner, newOwner);
1223     }
1224 }
1225 
1226 
1227 pragma solidity >=0.7.0 <0.9.0;
1228 
1229 contract GNAUTS is ERC721Enumerable, Ownable {
1230   using Strings for uint256;
1231 
1232   string public baseURI;
1233   string public baseExtension = ".json";
1234   string public notRevealedUri;
1235   uint256 public cost = 0.25 ether;
1236   uint256 public maxSupply = 777;
1237   uint256 public maxMintAmount = 2;
1238   uint256 public nftPerAddressLimit = 2;
1239   bool public paused = true;
1240   bool public revealed = false;
1241   bool public onlyWhitelisted = true;
1242   address[] public whitelistedAddresses;
1243   mapping(address => uint256) public addressMintedBalance;
1244 
1245   //PROVENANCE
1246 
1247   string public PROVENANCE = "";
1248   uint256 public startingIndexBlock;
1249   uint256 public startingIndex;
1250 
1251   // NAMES
1252   event Named(uint256 indexed index, string name);
1253   mapping(uint256 => string) private _tokenNames;
1254   mapping(string => bool) private _namesUsed;
1255 
1256   constructor(
1257     string memory _name,
1258     string memory _symbol,
1259     string memory _initBaseURI,
1260     string memory _initNotRevealedUri
1261   ) ERC721(_name, _symbol) {
1262     setBaseURI(_initBaseURI);
1263     setNotRevealedURI(_initNotRevealedUri);
1264   }
1265 
1266   // internal
1267   function _baseURI() internal view virtual override returns (string memory) {
1268     return baseURI;
1269   }
1270 
1271   // public
1272   function mint(uint256 _mintAmount) public payable {
1273     require(!paused, "the contract is paused");
1274     uint256 supply = totalSupply();
1275     require(_mintAmount > 0, "need to mint at least 1 NFT");
1276     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1277     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1278 
1279     if (msg.sender != owner()) {
1280         if(onlyWhitelisted == true) {
1281             require(isWhitelisted(msg.sender), "user is not whitelisted");
1282             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1283             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1284         }
1285         require(msg.value >= cost * _mintAmount, "insufficient funds");
1286     }
1287 
1288     for (uint256 i = 1; i <= _mintAmount; i++) {
1289       addressMintedBalance[msg.sender]++;
1290       _safeMint(msg.sender, supply + i);
1291     }
1292 
1293 
1294     // If we haven't set the starting index and this is either 1) the last saleable token or 2) the contract is not revealed for the first time
1295     if (startingIndexBlock == 0 && (totalSupply() == maxSupply)) {
1296             startingIndexBlock = block.number;
1297     }
1298   }
1299 
1300   function isWhitelisted(address _user) public view returns (bool) {
1301     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1302       if (whitelistedAddresses[i] == _user) {
1303           return true;
1304       }
1305     }
1306     return false;
1307   }
1308 
1309   function walletOfOwner(address _owner)
1310     public
1311     view
1312     returns (uint256[] memory)
1313   {
1314     uint256 ownerTokenCount = balanceOf(_owner);
1315     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1316     for (uint256 i; i < ownerTokenCount; i++) {
1317       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1318     }
1319     return tokenIds;
1320   }
1321 
1322   function tokenURI(uint256 tokenId)
1323     public
1324     view
1325     virtual
1326     override
1327     returns (string memory)
1328   {
1329     require(
1330       _exists(tokenId),
1331       "ERC721Metadata: URI query for nonexistent token"
1332     );
1333 
1334     if(revealed == false) {
1335         return notRevealedUri;
1336     }
1337 
1338     string memory currentBaseURI = _baseURI();
1339     return bytes(currentBaseURI).length > 0
1340         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1341         : "";
1342   }
1343 
1344     /**
1345      * Set the starting index for the collection
1346      */
1347     function setStartingIndex() public {
1348         require(startingIndex == 0, "Starting index is already set");
1349         require(startingIndexBlock != 0, "Starting index block must be set");
1350 
1351         startingIndex = uint(blockhash(startingIndexBlock)) % maxSupply;
1352         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1353         if (block.number - startingIndexBlock > 255) {
1354             startingIndex = uint(blockhash(block.number - 1)) % maxSupply;
1355         }
1356         // Prevent default sequence
1357         if (startingIndex == 0) {
1358             startingIndex = startingIndex + 1;
1359         }
1360     }
1361 
1362     /**
1363      * Set the starting index block for the collection, essentially unblocking
1364      * setting starting index
1365      */
1366     function emergencySetStartingIndexBlock() public onlyOwner {
1367         require(startingIndex == 0, "Starting index is already set");
1368 
1369         startingIndexBlock = block.number;
1370     }
1371 
1372 /*
1373     -------------------------------------
1374     NAMING
1375     -------------------------------------
1376     */
1377     function setName(uint256 tokenId, string memory name) public {
1378         require(revealed, "Collection hasnt been revealed yet!");
1379         address owner = ownerOf(tokenId);
1380         require(msg.sender == owner, "Address is not the owner of NFT!");
1381         require(validateName(name) == true, "Name is not valid!");
1382         require(isNameUsed(name) == false, "This name is already being used.");
1383         if (bytes(_tokenNames[tokenId]).length > 0) {
1384             _namesUsed[toLower(_tokenNames[tokenId])] = false;
1385         }
1386         _namesUsed[toLower(name)] = true;
1387         _tokenNames[tokenId] = name;
1388         emit Named(tokenId, name);
1389     }
1390 
1391     function tokenNameByIndex(uint256 index)
1392         public
1393         view
1394         returns (string memory)
1395     {
1396         return _tokenNames[index];
1397     }
1398 
1399     function isNameUsed(string memory nameString) public view returns (bool) {
1400         return _namesUsed[toLower(nameString)];
1401     }
1402 
1403     function validateName(string memory str) public pure returns (bool) {
1404         bytes memory b = bytes(str);
1405         if (b.length < 3) return false;
1406         if (b.length > 32) return false;
1407         if (b[0] == 0x20) return false;
1408         if (b[b.length - 1] == 0x20) return false;
1409         bytes1 lastChar = b[0];
1410         for (uint256 i; i < b.length; i++) {
1411             bytes1 char = b[i];
1412             if (char == 0x20 && lastChar == 0x20) return false;
1413             if (
1414                 !(char >= 0x41 && char <= 0x5A) &&
1415                 !(char >= 0x61 && char <= 0x7A) &&
1416                 !(char == 0x20)
1417             ) return false;
1418             lastChar = char;
1419         }
1420         return true;
1421     }
1422 
1423     function toLower(string memory str) public pure returns (string memory) {
1424         bytes memory bStr = bytes(str);
1425         bytes memory bLower = new bytes(bStr.length);
1426         for (uint256 i = 0; i < bStr.length; i++) {
1427             if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
1428                 bLower[i] = bytes1(uint8(bStr[i]) + 32);
1429             } else {
1430                 bLower[i] = bStr[i];
1431             }
1432         }
1433         return string(bLower);
1434     }
1435 
1436 
1437     /*
1438     -------------------------------------
1439     ONLY OWNER
1440     -------------------------------------
1441     */
1442   function reveal() public onlyOwner {
1443       revealed = true;
1444   }
1445 
1446       /*
1447     * Set provenance once it's calculated
1448     */
1449   function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1450     PROVENANCE = provenanceHash;
1451   }
1452 
1453   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1454     nftPerAddressLimit = _limit;
1455   }
1456 
1457   function setCost(uint256 _newCost) public onlyOwner {
1458     cost = _newCost;
1459   }
1460 
1461   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1462     maxMintAmount = _newmaxMintAmount;
1463   }
1464 
1465   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1466     baseURI = _newBaseURI;
1467   }
1468 
1469   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1470     baseExtension = _newBaseExtension;
1471   }
1472 
1473   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1474     notRevealedUri = _notRevealedURI;
1475   }
1476 
1477   function pause(bool _state) public onlyOwner {
1478     paused = _state;
1479   }
1480 
1481   function setOnlyWhitelisted(bool _state) public onlyOwner {
1482     onlyWhitelisted = _state;
1483   }
1484 
1485   function whitelistUsers(address[] calldata _users) public onlyOwner {
1486     delete whitelistedAddresses;
1487     whitelistedAddresses = _users;
1488   }
1489 
1490   function withdraw() public payable onlyOwner {
1491     // This will pay devs % of the initial sale.
1492     // =============================================================================
1493     uint256 addressOneAmt = address(this).balance * 15 / 100;
1494     uint256 addressTwoAmt = address(this).balance * 5 / 100;
1495 
1496     // =============================================================================
1497     (bool hs, ) = payable(0x14AB4457bfA3AA1057fdee9687c60A108e6F5aC1).call{value: addressOneAmt}("");
1498     require(hs);
1499     // =============================================================================
1500 
1501     (bool fs, ) = payable(0x30909DA8B6ae3afA42fEf31AaCd0c6b5F12E898C).call{value: addressTwoAmt}("");
1502     require(fs);
1503 
1504     // This will payout the SYNCRONAUT DAO GNOSIS SAFE the remainder of the contract balance.
1505     // =============================================================================
1506     (bool os, ) = payable(0x375b2E5ffc8bC5db38e8F2B3CdECF8341F58bf2B).call{value: address(this).balance}("");
1507     require(os);
1508     // =============================================================================
1509   }
1510 }