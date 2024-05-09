1 // SPDX-License-Identifier: MIT
2 
3 
4 
5 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
6 pragma solidity ^0.8.0;
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
29 pragma solidity ^0.8.0;
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
167 
168 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
169 pragma solidity ^0.8.0;
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
193 
194 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
195 pragma solidity ^0.8.0;
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
221 
222 
223 pragma solidity ^0.8.0;
224 
225 /**
226  * @dev String operations.
227  */
228 library Strings {
229     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
230 
231     /**
232      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
233      */
234     function toString(uint256 value) internal pure returns (string memory) {
235         // Inspired by OraclizeAPI's implementation - MIT licence
236         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
237 
238         if (value == 0) {
239             return "0";
240         }
241         uint256 temp = value;
242         uint256 digits;
243         while (temp != 0) {
244             digits++;
245             temp /= 10;
246         }
247         bytes memory buffer = new bytes(digits);
248         while (value != 0) {
249             digits -= 1;
250             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
251             value /= 10;
252         }
253         return string(buffer);
254     }
255 
256     /**
257      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
258      */
259     function toHexString(uint256 value) internal pure returns (string memory) {
260         if (value == 0) {
261             return "0x00";
262         }
263         uint256 temp = value;
264         uint256 length = 0;
265         while (temp != 0) {
266             length++;
267             temp >>= 8;
268         }
269         return toHexString(value, length);
270     }
271 
272     /**
273      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
274      */
275     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
276         bytes memory buffer = new bytes(2 * length + 2);
277         buffer[0] = "0";
278         buffer[1] = "x";
279         for (uint256 i = 2 * length + 1; i > 1; --i) {
280             buffer[i] = _HEX_SYMBOLS[value & 0xf];
281             value >>= 4;
282         }
283         require(value == 0, "Strings: hex length insufficient");
284         return string(buffer);
285     }
286 }
287 
288 // File: @openzeppelin/contracts/utils/Address.sol
289 
290 
291 
292 pragma solidity ^0.8.0;
293 
294 /**
295  * @dev Collection of functions related to the address type
296  */
297 library Address {
298     /**
299      * @dev Returns true if `account` is a contract.
300      *
301      * [IMPORTANT]
302      * ====
303      * It is unsafe to assume that an address for which this function returns
304      * false is an externally-owned account (EOA) and not a contract.
305      *
306      * Among others, `isContract` will return false for the following
307      * types of addresses:
308      *
309      *  - an externally-owned account
310      *  - a contract in construction
311      *  - an address where a contract will be created
312      *  - an address where a contract lived, but was destroyed
313      * ====
314      */
315     function isContract(address account) internal view returns (bool) {
316         // This method relies on extcodesize, which returns 0 for contracts in
317         // construction, since the code is only stored at the end of the
318         // constructor execution.
319 
320         uint256 size;
321         assembly {
322             size := extcodesize(account)
323         }
324         return size > 0;
325     }
326 
327     /**
328      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
329      * `recipient`, forwarding all available gas and reverting on errors.
330      *
331      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
332      * of certain opcodes, possibly making contracts go over the 2300 gas limit
333      * imposed by `transfer`, making them unable to receive funds via
334      * `transfer`. {sendValue} removes this limitation.
335      *
336      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
337      *
338      * IMPORTANT: because control is transferred to `recipient`, care must be
339      * taken to not create reentrancy vulnerabilities. Consider using
340      * {ReentrancyGuard} or the
341      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
342      */
343     function sendValue(address payable recipient, uint256 amount) internal {
344         require(address(this).balance >= amount, "Address: insufficient balance");
345 
346         (bool success, ) = recipient.call{value: amount}("");
347         require(success, "Address: unable to send value, recipient may have reverted");
348     }
349 
350     /**
351      * @dev Performs a Solidity function call using a low level `call`. A
352      * plain `call` is an unsafe replacement for a function call: use this
353      * function instead.
354      *
355      * If `target` reverts with a revert reason, it is bubbled up by this
356      * function (like regular Solidity function calls).
357      *
358      * Returns the raw returned data. To convert to the expected return value,
359      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
360      *
361      * Requirements:
362      *
363      * - `target` must be a contract.
364      * - calling `target` with `data` must not revert.
365      *
366      * _Available since v3.1._
367      */
368     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
369         return functionCall(target, data, "Address: low-level call failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
374      * `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCall(
379         address target,
380         bytes memory data,
381         string memory errorMessage
382     ) internal returns (bytes memory) {
383         return functionCallWithValue(target, data, 0, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but also transferring `value` wei to `target`.
389      *
390      * Requirements:
391      *
392      * - the calling contract must have an ETH balance of at least `value`.
393      * - the called Solidity function must be `payable`.
394      *
395      * _Available since v3.1._
396      */
397     function functionCallWithValue(
398         address target,
399         bytes memory data,
400         uint256 value
401     ) internal returns (bytes memory) {
402         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
407      * with `errorMessage` as a fallback revert reason when `target` reverts.
408      *
409      * _Available since v3.1._
410      */
411     function functionCallWithValue(
412         address target,
413         bytes memory data,
414         uint256 value,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         require(address(this).balance >= value, "Address: insufficient balance for call");
418         require(isContract(target), "Address: call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.call{value: value}(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but performing a static call.
427      *
428      * _Available since v3.3._
429      */
430     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
431         return functionStaticCall(target, data, "Address: low-level static call failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
436      * but performing a static call.
437      *
438      * _Available since v3.3._
439      */
440     function functionStaticCall(
441         address target,
442         bytes memory data,
443         string memory errorMessage
444     ) internal view returns (bytes memory) {
445         require(isContract(target), "Address: static call to non-contract");
446 
447         (bool success, bytes memory returndata) = target.staticcall(data);
448         return verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
453      * but performing a delegate call.
454      *
455      * _Available since v3.4._
456      */
457     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
458         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
463      * but performing a delegate call.
464      *
465      * _Available since v3.4._
466      */
467     function functionDelegateCall(
468         address target,
469         bytes memory data,
470         string memory errorMessage
471     ) internal returns (bytes memory) {
472         require(isContract(target), "Address: delegate call to non-contract");
473 
474         (bool success, bytes memory returndata) = target.delegatecall(data);
475         return verifyCallResult(success, returndata, errorMessage);
476     }
477 
478     /**
479      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
480      * revert reason using the provided one.
481      *
482      * _Available since v4.3._
483      */
484     function verifyCallResult(
485         bool success,
486         bytes memory returndata,
487         string memory errorMessage
488     ) internal pure returns (bytes memory) {
489         if (success) {
490             return returndata;
491         } else {
492             // Look for revert reason and bubble it up if present
493             if (returndata.length > 0) {
494                 // The easiest way to bubble the revert reason is using memory via assembly
495 
496                 assembly {
497                     let returndata_size := mload(returndata)
498                     revert(add(32, returndata), returndata_size)
499                 }
500             } else {
501                 revert(errorMessage);
502             }
503         }
504     }
505 }
506 
507 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
508 
509 
510 
511 pragma solidity ^0.8.0;
512 
513 
514 /**
515  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
516  * @dev See https://eips.ethereum.org/EIPS/eip-721
517  */
518 interface IERC721Metadata is IERC721 {
519     /**
520      * @dev Returns the token collection name.
521      */
522     function name() external view returns (string memory);
523 
524     /**
525      * @dev Returns the token collection symbol.
526      */
527     function symbol() external view returns (string memory);
528 
529     /**
530      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
531      */
532     function tokenURI(uint256 tokenId) external view returns (string memory);
533 }
534 
535 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
536 
537 
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @title ERC721 token receiver interface
543  * @dev Interface for any contract that wants to support safeTransfers
544  * from ERC721 asset contracts.
545  */
546 interface IERC721Receiver {
547     /**
548      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
549      * by `operator` from `from`, this function is called.
550      *
551      * It must return its Solidity selector to confirm the token transfer.
552      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
553      *
554      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
555      */
556     function onERC721Received(
557         address operator,
558         address from,
559         uint256 tokenId,
560         bytes calldata data
561     ) external returns (bytes4);
562 }
563 
564 // File: @openzeppelin/contracts/utils/Context.sol
565 pragma solidity ^0.8.0;
566 /**
567  * @dev Provides information about the current execution context, including the
568  * sender of the transaction and its data. While these are generally available
569  * via msg.sender and msg.data, they should not be accessed in such a direct
570  * manner, since when dealing with meta-transactions the account sending and
571  * paying for execution may not be the actual sender (as far as an application
572  * is concerned).
573  *
574  * This contract is only required for intermediate, library-like contracts.
575  */
576 abstract contract Context {
577     function _msgSender() internal view virtual returns (address) {
578         return msg.sender;
579     }
580 
581     function _msgData() internal view virtual returns (bytes calldata) {
582         return msg.data;
583     }
584 }
585 
586 
587 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
588 pragma solidity ^0.8.0;
589 /**
590  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
591  * the Metadata extension, but not including the Enumerable extension, which is available separately as
592  * {ERC721Enumerable}.
593  */
594 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
595     using Address for address;
596     using Strings for uint256;
597 
598     // Token name
599     string private _name;
600 
601     // Token symbol
602     string private _symbol;
603 
604     // Mapping from token ID to owner address
605     mapping(uint256 => address) private _owners;
606 
607     // Mapping owner address to token count
608     mapping(address => uint256) private _balances;
609 
610     // Mapping from token ID to approved address
611     mapping(uint256 => address) private _tokenApprovals;
612 
613     // Mapping from owner to operator approvals
614     mapping(address => mapping(address => bool)) private _operatorApprovals;
615 
616     /**
617      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
618      */
619     constructor(string memory name_, string memory symbol_) {
620         _name = name_;
621         _symbol = symbol_;
622     }
623 
624     /**
625      * @dev See {IERC165-supportsInterface}.
626      */
627     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
628         return
629             interfaceId == type(IERC721).interfaceId ||
630             interfaceId == type(IERC721Metadata).interfaceId ||
631             super.supportsInterface(interfaceId);
632     }
633 
634     /**
635      * @dev See {IERC721-balanceOf}.
636      */
637     function balanceOf(address owner) public view virtual override returns (uint256) {
638         require(owner != address(0), "ERC721: balance query for the zero address");
639         return _balances[owner];
640     }
641 
642     /**
643      * @dev See {IERC721-ownerOf}.
644      */
645     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
646         address owner = _owners[tokenId];
647         require(owner != address(0), "ERC721: owner query for nonexistent token");
648         return owner;
649     }
650 
651     /**
652      * @dev See {IERC721Metadata-name}.
653      */
654     function name() public view virtual override returns (string memory) {
655         return _name;
656     }
657 
658     /**
659      * @dev See {IERC721Metadata-symbol}.
660      */
661     function symbol() public view virtual override returns (string memory) {
662         return _symbol;
663     }
664 
665     /**
666      * @dev See {IERC721Metadata-tokenURI}.
667      */
668     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
669         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
670 
671         string memory baseURI = _baseURI();
672         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
673     }
674 
675     /**
676      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
677      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
678      * by default, can be overriden in child contracts.
679      */
680     function _baseURI() internal view virtual returns (string memory) {
681         return "";
682     }
683 
684     /**
685      * @dev See {IERC721-approve}.
686      */
687     function approve(address to, uint256 tokenId) public virtual override {
688         address owner = ERC721.ownerOf(tokenId);
689         require(to != owner, "ERC721: approval to current owner");
690 
691         require(
692             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
693             "ERC721: approve caller is not owner nor approved for all"
694         );
695 
696         _approve(to, tokenId);
697     }
698 
699     /**
700      * @dev See {IERC721-getApproved}.
701      */
702     function getApproved(uint256 tokenId) public view virtual override returns (address) {
703         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
704 
705         return _tokenApprovals[tokenId];
706     }
707 
708     /**
709      * @dev See {IERC721-setApprovalForAll}.
710      */
711     function setApprovalForAll(address operator, bool approved) public virtual override {
712         require(operator != _msgSender(), "ERC721: approve to caller");
713 
714         _operatorApprovals[_msgSender()][operator] = approved;
715         emit ApprovalForAll(_msgSender(), operator, approved);
716     }
717 
718     /**
719      * @dev See {IERC721-isApprovedForAll}.
720      */
721     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
722         return _operatorApprovals[owner][operator];
723     }
724 
725     /**
726      * @dev See {IERC721-transferFrom}.
727      */
728     function transferFrom(
729         address from,
730         address to,
731         uint256 tokenId
732     ) public virtual override {
733         //solhint-disable-next-line max-line-length
734         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
735 
736         _transfer(from, to, tokenId);
737     }
738 
739     /**
740      * @dev See {IERC721-safeTransferFrom}.
741      */
742     function safeTransferFrom(
743         address from,
744         address to,
745         uint256 tokenId
746     ) public virtual override {
747         safeTransferFrom(from, to, tokenId, "");
748     }
749 
750     /**
751      * @dev See {IERC721-safeTransferFrom}.
752      */
753     function safeTransferFrom(
754         address from,
755         address to,
756         uint256 tokenId,
757         bytes memory _data
758     ) public virtual override {
759         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
760         _safeTransfer(from, to, tokenId, _data);
761     }
762 
763     /**
764      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
765      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
766      *
767      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
768      *
769      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
770      * implement alternative mechanisms to perform token transfer, such as signature-based.
771      *
772      * Requirements:
773      *
774      * - `from` cannot be the zero address.
775      * - `to` cannot be the zero address.
776      * - `tokenId` token must exist and be owned by `from`.
777      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
778      *
779      * Emits a {Transfer} event.
780      */
781     function _safeTransfer(
782         address from,
783         address to,
784         uint256 tokenId,
785         bytes memory _data
786     ) internal virtual {
787         _transfer(from, to, tokenId);
788         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
789     }
790 
791     /**
792      * @dev Returns whether `tokenId` exists.
793      *
794      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
795      *
796      * Tokens start existing when they are minted (`_mint`),
797      * and stop existing when they are burned (`_burn`).
798      */
799     function _exists(uint256 tokenId) internal view virtual returns (bool) {
800         return _owners[tokenId] != address(0);
801     }
802 
803     /**
804      * @dev Returns whether `spender` is allowed to manage `tokenId`.
805      *
806      * Requirements:
807      *
808      * - `tokenId` must exist.
809      */
810     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
811         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
812         address owner = ERC721.ownerOf(tokenId);
813         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
814     }
815 
816     /**
817      * @dev Safely mints `tokenId` and transfers it to `to`.
818      *
819      * Requirements:
820      *
821      * - `tokenId` must not exist.
822      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
823      *
824      * Emits a {Transfer} event.
825      */
826     function _safeMint(address to, uint256 tokenId) internal virtual {
827         _safeMint(to, tokenId, "");
828     }
829 
830     /**
831      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
832      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
833      */
834     function _safeMint(
835         address to,
836         uint256 tokenId,
837         bytes memory _data
838     ) internal virtual {
839         _mint(to, tokenId);
840         require(
841             _checkOnERC721Received(address(0), to, tokenId, _data),
842             "ERC721: transfer to non ERC721Receiver implementer"
843         );
844     }
845 
846     /**
847      * @dev Mints `tokenId` and transfers it to `to`.
848      *
849      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
850      *
851      * Requirements:
852      *
853      * - `tokenId` must not exist.
854      * - `to` cannot be the zero address.
855      *
856      * Emits a {Transfer} event.
857      */
858     function _mint(address to, uint256 tokenId) internal virtual {
859         require(to != address(0), "ERC721: mint to the zero address");
860         require(!_exists(tokenId), "ERC721: token already minted");
861 
862         _beforeTokenTransfer(address(0), to, tokenId);
863 
864         _balances[to] += 1;
865         _owners[tokenId] = to;
866 
867         emit Transfer(address(0), to, tokenId);
868     }
869 
870     /**
871      * @dev Destroys `tokenId`.
872      * The approval is cleared when the token is burned.
873      *
874      * Requirements:
875      *
876      * - `tokenId` must exist.
877      *
878      * Emits a {Transfer} event.
879      */
880     function _burn(uint256 tokenId) internal virtual {
881         address owner = ERC721.ownerOf(tokenId);
882 
883         _beforeTokenTransfer(owner, address(0), tokenId);
884 
885         // Clear approvals
886         _approve(address(0), tokenId);
887 
888         _balances[owner] -= 1;
889         delete _owners[tokenId];
890 
891         emit Transfer(owner, address(0), tokenId);
892     }
893 
894     /**
895      * @dev Transfers `tokenId` from `from` to `to`.
896      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
897      *
898      * Requirements:
899      *
900      * - `to` cannot be the zero address.
901      * - `tokenId` token must be owned by `from`.
902      *
903      * Emits a {Transfer} event.
904      */
905     function _transfer(
906         address from,
907         address to,
908         uint256 tokenId
909     ) internal virtual {
910         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
911         require(to != address(0), "ERC721: transfer to the zero address");
912 
913         _beforeTokenTransfer(from, to, tokenId);
914 
915         // Clear approvals from the previous owner
916         _approve(address(0), tokenId);
917 
918         _balances[from] -= 1;
919         _balances[to] += 1;
920         _owners[tokenId] = to;
921 
922         emit Transfer(from, to, tokenId);
923     }
924 
925     /**
926      * @dev Approve `to` to operate on `tokenId`
927      *
928      * Emits a {Approval} event.
929      */
930     function _approve(address to, uint256 tokenId) internal virtual {
931         _tokenApprovals[tokenId] = to;
932         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
933     }
934 
935     /**
936      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
937      * The call is not executed if the target address is not a contract.
938      *
939      * @param from address representing the previous owner of the given token ID
940      * @param to target address that will receive the tokens
941      * @param tokenId uint256 ID of the token to be transferred
942      * @param _data bytes optional data to send along with the call
943      * @return bool whether the call correctly returned the expected magic value
944      */
945     function _checkOnERC721Received(
946         address from,
947         address to,
948         uint256 tokenId,
949         bytes memory _data
950     ) private returns (bool) {
951         if (to.isContract()) {
952             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
953                 return retval == IERC721Receiver.onERC721Received.selector;
954             } catch (bytes memory reason) {
955                 if (reason.length == 0) {
956                     revert("ERC721: transfer to non ERC721Receiver implementer");
957                 } else {
958                     assembly {
959                         revert(add(32, reason), mload(reason))
960                     }
961                 }
962             }
963         } else {
964             return true;
965         }
966     }
967 
968     /**
969      * @dev Hook that is called before any token transfer. This includes minting
970      * and burning.
971      *
972      * Calling conditions:
973      *
974      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
975      * transferred to `to`.
976      * - When `from` is zero, `tokenId` will be minted for `to`.
977      * - When `to` is zero, ``from``'s `tokenId` will be burned.
978      * - `from` and `to` are never both zero.
979      *
980      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
981      */
982     function _beforeTokenTransfer(
983         address from,
984         address to,
985         uint256 tokenId
986     ) internal virtual {}
987 }
988 
989 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
990 
991 
992 
993 pragma solidity ^0.8.0;
994 
995 
996 
997 /**
998  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
999  * enumerability of all the token ids in the contract as well as all token ids owned by each
1000  * account.
1001  */
1002 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1003     // Mapping from owner to list of owned token IDs
1004     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1005 
1006     // Mapping from token ID to index of the owner tokens list
1007     mapping(uint256 => uint256) private _ownedTokensIndex;
1008 
1009     // Array with all token ids, used for enumeration
1010     uint256[] private _allTokens;
1011 
1012     // Mapping from token id to position in the allTokens array
1013     mapping(uint256 => uint256) private _allTokensIndex;
1014 
1015     /**
1016      * @dev See {IERC165-supportsInterface}.
1017      */
1018     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1019         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1024      */
1025     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1026         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1027         return _ownedTokens[owner][index];
1028     }
1029 
1030     /**
1031      * @dev See {IERC721Enumerable-totalSupply}.
1032      */
1033     function totalSupply() public view virtual override returns (uint256) {
1034         return _allTokens.length;
1035     }
1036 
1037     /**
1038      * @dev See {IERC721Enumerable-tokenByIndex}.
1039      */
1040     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1041         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1042         return _allTokens[index];
1043     }
1044 
1045     /**
1046      * @dev Hook that is called before any token transfer. This includes minting
1047      * and burning.
1048      *
1049      * Calling conditions:
1050      *
1051      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1052      * transferred to `to`.
1053      * - When `from` is zero, `tokenId` will be minted for `to`.
1054      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1055      * - `from` cannot be the zero address.
1056      * - `to` cannot be the zero address.
1057      *
1058      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1059      */
1060     function _beforeTokenTransfer(
1061         address from,
1062         address to,
1063         uint256 tokenId
1064     ) internal virtual override {
1065         super._beforeTokenTransfer(from, to, tokenId);
1066 
1067         if (from == address(0)) {
1068             _addTokenToAllTokensEnumeration(tokenId);
1069         } else if (from != to) {
1070             _removeTokenFromOwnerEnumeration(from, tokenId);
1071         }
1072         if (to == address(0)) {
1073             _removeTokenFromAllTokensEnumeration(tokenId);
1074         } else if (to != from) {
1075             _addTokenToOwnerEnumeration(to, tokenId);
1076         }
1077     }
1078 
1079     /**
1080      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1081      * @param to address representing the new owner of the given token ID
1082      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1083      */
1084     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1085         uint256 length = ERC721.balanceOf(to);
1086         _ownedTokens[to][length] = tokenId;
1087         _ownedTokensIndex[tokenId] = length;
1088     }
1089 
1090     /**
1091      * @dev Private function to add a token to this extension's token tracking data structures.
1092      * @param tokenId uint256 ID of the token to be added to the tokens list
1093      */
1094     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1095         _allTokensIndex[tokenId] = _allTokens.length;
1096         _allTokens.push(tokenId);
1097     }
1098 
1099     /**
1100      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1101      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1102      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1103      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1104      * @param from address representing the previous owner of the given token ID
1105      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1106      */
1107     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1108         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1109         // then delete the last slot (swap and pop).
1110 
1111         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1112         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1113 
1114         // When the token to delete is the last token, the swap operation is unnecessary
1115         if (tokenIndex != lastTokenIndex) {
1116             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1117 
1118             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1119             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1120         }
1121 
1122         // This also deletes the contents at the last position of the array
1123         delete _ownedTokensIndex[tokenId];
1124         delete _ownedTokens[from][lastTokenIndex];
1125     }
1126 
1127     /**
1128      * @dev Private function to remove a token from this extension's token tracking data structures.
1129      * This has O(1) time complexity, but alters the order of the _allTokens array.
1130      * @param tokenId uint256 ID of the token to be removed from the tokens list
1131      */
1132     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1133         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1134         // then delete the last slot (swap and pop).
1135 
1136         uint256 lastTokenIndex = _allTokens.length - 1;
1137         uint256 tokenIndex = _allTokensIndex[tokenId];
1138 
1139         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1140         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1141         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1142         uint256 lastTokenId = _allTokens[lastTokenIndex];
1143 
1144         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1145         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1146 
1147         // This also deletes the contents at the last position of the array
1148         delete _allTokensIndex[tokenId];
1149         _allTokens.pop();
1150     }
1151 }
1152 
1153 
1154 // File: @openzeppelin/contracts/access/Ownable.sol
1155 pragma solidity ^0.8.0;
1156 /**
1157  * @dev Contract module which provides a basic access control mechanism, where
1158  * there is an account (an owner) that can be granted exclusive access to
1159  * specific functions.
1160  *
1161  * By default, the owner account will be the one that deploys the contract. This
1162  * can later be changed with {transferOwnership}.
1163  *
1164  * This module is used through inheritance. It will make available the modifier
1165  * `onlyOwner`, which can be applied to your functions to restrict their use to
1166  * the owner.
1167  */
1168 abstract contract Ownable is Context {
1169     address private _owner;
1170 
1171     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1172 
1173     /**
1174      * @dev Initializes the contract setting the deployer as the initial owner.
1175      */
1176     constructor() {
1177         _setOwner(_msgSender());
1178     }
1179 
1180     /**
1181      * @dev Returns the address of the current owner.
1182      */
1183     function owner() public view virtual returns (address) {
1184         return _owner;
1185     }
1186 
1187     /**
1188      * @dev Throws if called by any account other than the owner.
1189      */
1190     modifier onlyOwner() {
1191         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1192         _;
1193     }
1194 
1195     /**
1196      * @dev Leaves the contract without owner. It will not be possible to call
1197      * `onlyOwner` functions anymore. Can only be called by the current owner.
1198      *
1199      * NOTE: Renouncing ownership will leave the contract without an owner,
1200      * thereby removing any functionality that is only available to the owner.
1201      */
1202     function renounceOwnership() public virtual onlyOwner {
1203         _setOwner(address(0));
1204     }
1205 
1206     /**
1207      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1208      * Can only be called by the current owner.
1209      */
1210     function transferOwnership(address newOwner) public virtual onlyOwner {
1211         require(newOwner != address(0), "Ownable: new owner is the zero address");
1212         _setOwner(newOwner);
1213     }
1214 
1215     function _setOwner(address newOwner) private {
1216         address oldOwner = _owner;
1217         _owner = newOwner;
1218         emit OwnershipTransferred(oldOwner, newOwner);
1219     }
1220 }
1221 
1222 pragma solidity >=0.7.0 <0.9.0;
1223 
1224 contract Zoodlers is ERC721Enumerable, Ownable {
1225   using Strings for uint256;
1226 
1227   string baseURI;
1228   string public baseExtension = ".json";
1229   uint256 public cost = 0.05 ether;
1230   uint256 public maxSupply = 3232;
1231   uint256 public maxMintAmount = 50;
1232   uint256 public nftPerAddressLimit = 5;
1233   bool public paused = false;
1234   bool public revealed = false;
1235   string public notRevealedUri;
1236   mapping(address => uint256) public addressMintedBalance;
1237 
1238   constructor(
1239     string memory _name,
1240     string memory _symbol,
1241     string memory _initBaseURI,
1242     string memory _initNotRevealedUri
1243   ) ERC721(_name, _symbol) {
1244     setBaseURI(_initBaseURI);
1245     setNotRevealedURI(_initNotRevealedUri);
1246   }
1247 
1248   // internal
1249   function _baseURI() internal view virtual override returns (string memory) {
1250     return baseURI;
1251   }
1252 
1253   // public
1254   function mint(uint256 _mintAmount) public payable {
1255     uint256 supply = totalSupply();
1256     require(!paused);
1257     require(_mintAmount > 0);
1258     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1259     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1260 
1261     if (msg.sender != owner()) {
1262         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1263         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1264       require(msg.value >= cost * _mintAmount);
1265     }
1266 
1267     for (uint256 i = 1; i <= _mintAmount; i++) {
1268         addressMintedBalance[msg.sender]++;
1269       _safeMint(msg.sender, supply + i);
1270     }
1271   }
1272 
1273   function walletOfOwner(address _owner)
1274     public
1275     view
1276     returns (uint256[] memory)
1277   {
1278     uint256 ownerTokenCount = balanceOf(_owner);
1279     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1280     for (uint256 i; i < ownerTokenCount; i++) {
1281       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1282     }
1283     return tokenIds;
1284   }
1285 
1286   function tokenURI(uint256 tokenId)
1287     public
1288     view
1289     virtual
1290     override
1291     returns (string memory)
1292   {
1293     require(
1294       _exists(tokenId),
1295       "ERC721Metadata: URI query for nonexistent token"
1296     );
1297     
1298     if(revealed == false) {
1299         return notRevealedUri;
1300     }
1301 
1302     string memory currentBaseURI = _baseURI();
1303     return bytes(currentBaseURI).length > 0
1304         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1305         : "";
1306   }
1307 
1308   //only owner
1309   function reveal() public onlyOwner {
1310       revealed = true;
1311   }
1312   
1313   function setCost(uint256 _newCost) public onlyOwner {
1314     cost = _newCost;
1315   }
1316 
1317   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1318     maxMintAmount = _newmaxMintAmount;
1319   }
1320   
1321   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1322     notRevealedUri = _notRevealedURI;
1323   }
1324 
1325   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1326     baseURI = _newBaseURI;
1327   }
1328 
1329   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1330     baseExtension = _newBaseExtension;
1331   }
1332 
1333   function pause(bool _state) public onlyOwner {
1334     paused = _state;
1335   }
1336  
1337   function withdraw() public payable onlyOwner {
1338     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1339     require(os);
1340     // =============================================================================
1341   }
1342 }