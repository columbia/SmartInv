1 // File: contracts/ERC721.sol
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
586 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
587 pragma solidity ^0.8.0;
588     contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
589     using Address for address;
590     using Strings for uint256;
591 
592     // Token name
593     string private _name;
594 
595     // Token symbol
596     string private _symbol;
597 
598     // Mapping from token ID to owner address
599     mapping(uint256 => address) private _owners;
600 
601     // Mapping owner address to token count
602     mapping(address => uint256) private _balances;
603 
604     // Mapping from token ID to approved address
605     mapping(uint256 => address) private _tokenApprovals;
606 
607     // Mapping from owner to operator approvals
608     mapping(address => mapping(address => bool)) private _operatorApprovals;
609 
610     /**
611      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
612      */
613     constructor(string memory name_, string memory symbol_) {
614         _name = name_;
615         _symbol = symbol_;
616     }
617 
618     /**
619      * @dev See {IERC165-supportsInterface}.
620      */
621     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
622         return
623             interfaceId == type(IERC721).interfaceId ||
624             interfaceId == type(IERC721Metadata).interfaceId ||
625             super.supportsInterface(interfaceId);
626     }
627 
628     function balanceOf(address owner) public view virtual override returns (uint256) {
629         require(owner != address(0), "ERC721: balance query for the zero address");
630         return _balances[owner];
631     }
632 
633     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
634         address owner = _owners[tokenId];
635         require(owner != address(0), "ERC721: owner query for nonexistent token");
636         return owner;
637     }
638 
639     function name() public view virtual override returns (string memory) {
640         return _name;
641     }
642 
643     function symbol() public view virtual override returns (string memory) {
644         return _symbol;
645     }
646 
647     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
648         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
649 
650         string memory baseURI = _baseURI();
651         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
652     }
653 
654     function _baseURI() internal view virtual returns (string memory) {
655         return "";
656     }
657 
658     function approve(address to, uint256 tokenId) public virtual override {
659         address owner = ERC721.ownerOf(tokenId);
660         require(to != owner, "ERC721: approval to current owner");
661 
662         require(
663             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
664             "ERC721: approve caller is not owner nor approved for all"
665         );
666 
667         _approve(to, tokenId);
668     }
669 
670     function getApproved(uint256 tokenId) public view virtual override returns (address) {
671         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
672 
673         return _tokenApprovals[tokenId];
674     }
675 
676     function setApprovalForAll(address operator, bool approved) public virtual override {
677         require(operator != _msgSender(), "ERC721: approve to caller");
678 
679         _operatorApprovals[_msgSender()][operator] = approved;
680         emit ApprovalForAll(_msgSender(), operator, approved);
681     }
682 
683     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
684         return _operatorApprovals[owner][operator];
685     }
686 
687     function transferFrom(
688         address from,
689         address to,
690         uint256 tokenId
691     ) public virtual override {
692         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
693 
694         _transfer(from, to, tokenId);
695     }
696 
697     function safeTransferFrom(
698         address from,
699         address to,
700         uint256 tokenId
701     ) public virtual override {
702         safeTransferFrom(from, to, tokenId, "");
703     }
704 
705     function safeTransferFrom(
706         address from,
707         address to,
708         uint256 tokenId,
709         bytes memory _data
710     ) public virtual override {
711         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
712         _safeTransfer(from, to, tokenId, _data);
713     }
714 
715     function _safeTransfer(
716         address from,
717         address to,
718         uint256 tokenId,
719         bytes memory _data
720     ) internal virtual {
721         _transfer(from, to, tokenId);
722         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
723     }
724 
725     function _exists(uint256 tokenId) internal view virtual returns (bool) {
726         return _owners[tokenId] != address(0);
727     }
728 
729     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
730         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
731         address owner = ERC721.ownerOf(tokenId);
732         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
733     }
734 
735     function _safeMint(address to, uint256 tokenId) internal virtual {
736         _safeMint(to, tokenId, "");
737     }
738 
739     function _safeMint(
740         address to,
741         uint256 tokenId,
742         bytes memory _data
743     ) internal virtual {
744         _mint(to, tokenId);
745         require(
746             _checkOnERC721Received(address(0), to, tokenId, _data),
747             "ERC721: transfer to non ERC721Receiver implementer"
748         );
749     }
750 
751     function _mint(address to, uint256 tokenId) internal virtual {
752         require(to != address(0), "ERC721: mint to the zero address");
753         require(!_exists(tokenId), "ERC721: token already minted");
754 
755         _beforeTokenTransfer(address(0), to, tokenId);
756 
757         _balances[to] += 1;
758         _owners[tokenId] = to;
759 
760         emit Transfer(address(0), to, tokenId);
761     }
762 
763     function _burn(uint256 tokenId) internal virtual {
764         address owner = ERC721.ownerOf(tokenId);
765 
766         _beforeTokenTransfer(owner, address(0), tokenId);
767 
768         _approve(address(0), tokenId);
769 
770         _balances[owner] -= 1;
771         delete _owners[tokenId];
772 
773         emit Transfer(owner, address(0), tokenId);
774     }
775 
776     function _transfer(
777         address from,
778         address to,
779         uint256 tokenId
780     ) internal virtual {
781         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
782         require(to != address(0), "ERC721: transfer to the zero address");
783 
784         _beforeTokenTransfer(from, to, tokenId);
785 
786         _approve(address(0), tokenId);
787 
788         _balances[from] -= 1;
789         _balances[to] += 1;
790         _owners[tokenId] = to;
791 
792         emit Transfer(from, to, tokenId);
793     }
794 
795     function _approve(address to, uint256 tokenId) internal virtual {
796         _tokenApprovals[tokenId] = to;
797         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
798     }
799 
800     function _checkOnERC721Received(
801         address from,
802         address to,
803         uint256 tokenId,
804         bytes memory _data
805     ) private returns (bool) {
806         if (to.isContract()) {
807             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
808                 return retval == IERC721Receiver.onERC721Received.selector;
809             } catch (bytes memory reason) {
810                 if (reason.length == 0) {
811                     revert("ERC721: transfer to non ERC721Receiver implementer");
812                 } else {
813                     assembly {
814                         revert(add(32, reason), mload(reason))
815                     }
816                 }
817             }
818         } else {
819             return true;
820         }
821     }
822 
823     function _beforeTokenTransfer(
824         address from,
825         address to,
826         uint256 tokenId
827     ) internal virtual {}
828 }
829 
830 pragma solidity ^0.8.0;
831 
832 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
833     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
834 
835     mapping(uint256 => uint256) private _ownedTokensIndex;
836 
837     uint256[] private _allTokens;
838 
839     mapping(uint256 => uint256) private _allTokensIndex;
840 
841     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
842         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
843     }
844 
845     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
846         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
847         return _ownedTokens[owner][index];
848     }
849 
850     function totalSupply() public view virtual override returns (uint256) {
851         return _allTokens.length;
852     }
853 
854     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
855         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
856         return _allTokens[index];
857     }
858 
859     function _beforeTokenTransfer(
860         address from,
861         address to,
862         uint256 tokenId
863     ) internal virtual override {
864         super._beforeTokenTransfer(from, to, tokenId);
865 
866         if (from == address(0)) {
867             _addTokenToAllTokensEnumeration(tokenId);
868         } else if (from != to) {
869             _removeTokenFromOwnerEnumeration(from, tokenId);
870         }
871         if (to == address(0)) {
872             _removeTokenFromAllTokensEnumeration(tokenId);
873         } else if (to != from) {
874             _addTokenToOwnerEnumeration(to, tokenId);
875         }
876     }
877 
878     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
879         uint256 length = ERC721.balanceOf(to);
880         _ownedTokens[to][length] = tokenId;
881         _ownedTokensIndex[tokenId] = length;
882     }
883 
884     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
885         _allTokensIndex[tokenId] = _allTokens.length;
886         _allTokens.push(tokenId);
887     }
888 
889     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
890 
891         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
892         uint256 tokenIndex = _ownedTokensIndex[tokenId];
893 
894         if (tokenIndex != lastTokenIndex) {
895             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
896 
897             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
898             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
899         }
900 
901         delete _ownedTokensIndex[tokenId];
902         delete _ownedTokens[from][lastTokenIndex];
903     }
904 
905     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
906 
907         uint256 lastTokenIndex = _allTokens.length - 1;
908         uint256 tokenIndex = _allTokensIndex[tokenId];
909 
910         uint256 lastTokenId = _allTokens[lastTokenIndex];
911 
912         _allTokens[tokenIndex] = lastTokenId;
913         _allTokensIndex[lastTokenId] = tokenIndex;
914 
915         delete _allTokensIndex[tokenId];
916         _allTokens.pop();
917     }
918 }
919 
920 pragma solidity ^0.8.0;
921 abstract contract Ownable is Context {
922     address private _owner;
923 
924     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
925 
926     constructor() {
927         _setOwner(_msgSender());
928     }
929 
930     function owner() public view virtual returns (address) {
931         return _owner;
932     }
933 
934     modifier onlyOwner() {
935         require(owner() == _msgSender(), "Ownable: caller is not the owner");
936         _;
937     }
938 
939     function renounceOwnership() public virtual onlyOwner {
940         _setOwner(address(0));
941     }
942 
943     function transferOwnership(address newOwner) public virtual onlyOwner {
944         require(newOwner != address(0), "Ownable: new owner is the zero address");
945         _setOwner(newOwner);
946     }
947 
948     function _setOwner(address newOwner) private {
949         address oldOwner = _owner;
950         _owner = newOwner;
951         emit OwnershipTransferred(oldOwner, newOwner);
952     }
953 }
954 // File: contracts/Beans.sol
955 
956 
957 //BEANS by Dumb Ways to Die Terms and Conditions [ https://www.beansnfts.io/terms ]
958 
959 pragma solidity ^0.8.0;
960 
961 
962 contract BEANS_DWTD is ERC721Enumerable, Ownable {
963   using Strings for uint256;
964 
965   string private baseURI;
966   string private baseExtension = ".json";
967 
968   string public notRevealedUri;
969   string public PROVENANCE = "";
970   uint256 public cost = 0.3 ether;
971   uint256 public maxSupply = 10000;
972   uint256 public maxMintAmount = 2;
973   uint256 public nftPerAddressLimit = 2;
974   uint256 public reserveCount = 100;
975 
976   bool public paused = true;
977   bool public revealed = false;
978   bool public onlyWhitelisted = true;
979   bool public signatureVerifiedWhitelist = true;
980 
981   bool private hasReserved = false;
982 
983   mapping(address => bool) public whitelistedAddresses;
984   mapping(address => uint256) public addressMintedBalance;
985 
986   constructor(
987     string memory _name,
988     string memory _symbol,
989     string memory _initBaseURI,
990     string memory _initNotRevealedUri
991   ) ERC721(_name, _symbol){
992     setBaseURI(_initBaseURI);
993     setNotRevealedURI(_initNotRevealedUri);
994     PROVENANCE = "00ca4cecf6b21be789c92d1ec9a1a02e41d2525675e234d871a9bedc866b0d64";
995 
996     reserve();
997   }
998 
999   function _baseURI() internal view virtual override returns (string memory) 
1000   {
1001     return baseURI;
1002   }
1003   
1004   function reserve() public onlyOwner 
1005   {
1006     if(hasReserved == false)
1007     {
1008         uint supply = totalSupply();
1009         uint i;
1010 
1011         for (i = 0; i < reserveCount; i++) {
1012             _safeMint(msg.sender, supply + i);
1013         }
1014     }
1015 
1016     hasReserved = true;
1017   }
1018 
1019   function getMessageHash(
1020         address _to,
1021         uint _amount,
1022         string memory _message,
1023         uint _nonce
1024     ) public pure returns (bytes32) {
1025         return keccak256(abi.encodePacked(_to, _amount, _message, _nonce));
1026     }
1027 
1028   function getEthSignedMessageHash(bytes32 _messageHash)
1029       public
1030       pure
1031       returns (bytes32)
1032   {
1033       return
1034           keccak256(
1035               abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
1036           );
1037   }
1038 
1039   function verify(
1040         address _signer,
1041         address _to,
1042         uint _amount,
1043         string memory _message,
1044         uint _nonce,
1045         bytes memory signature
1046     ) public pure returns (bool) {
1047         bytes32 messageHash = getMessageHash(_to, _amount, _message, _nonce);
1048         bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
1049 
1050         return recoverSigner(ethSignedMessageHash, signature) == _signer;
1051     }
1052 
1053     function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature)
1054         public
1055         pure
1056         returns (address)
1057     {
1058         (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
1059 
1060         return ecrecover(_ethSignedMessageHash, v, r, s);
1061     }
1062 
1063     function splitSignature(bytes memory sig)
1064         public
1065         pure
1066         returns (
1067             bytes32 r,
1068             bytes32 s,
1069             uint8 v
1070         )
1071     {
1072         require(sig.length == 65, "invalid signature length");
1073         assembly {
1074             r := mload(add(sig, 32))
1075             s := mload(add(sig, 64))
1076             v := byte(0, mload(add(sig, 96)))
1077         }
1078     }
1079 
1080   function mint(
1081     uint256 _mintAmount,
1082     uint _amount,
1083     string memory _message,
1084     uint _nonce,
1085     bytes memory signature) 
1086     public payable 
1087     {
1088         uint256 supply = totalSupply();
1089         require(_mintAmount > 0, "Need to mint at least 1 NFT");
1090         
1091         require(supply + _mintAmount <= maxSupply, "Sold Out!");
1092 
1093         if (msg.sender != owner()) 
1094         {
1095             if(signatureVerifiedWhitelist)
1096             {
1097                 require(verify(owner(), msg.sender, _amount, _message, _nonce, signature), "Failed to sign");
1098             }
1099             else if(onlyWhitelisted == true) 
1100             {
1101                 require(isWhitelisted(msg.sender), "User is not whitelisted");
1102             }
1103             require(!paused, "The contract is paused");
1104 
1105             require(msg.value >= cost * _mintAmount, "Insufficient funds");
1106 
1107             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1108             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "Max NFT per address exceeded");
1109 
1110             require(_mintAmount <= maxMintAmount, "Max mint amount per session exceeded");
1111         }
1112 
1113         addressMintedBalance[msg.sender] += _mintAmount;
1114 
1115         uint i;
1116 
1117         for (i = 0; i < _mintAmount; i++) {
1118             _safeMint(msg.sender, supply + i);
1119         }
1120   }
1121 
1122   function mintPublic(uint256 _mintAmount) public payable
1123   {
1124     require(!paused, "The contract is paused");
1125     require(signatureVerifiedWhitelist == false, "Signature required");
1126 
1127     uint256 supply = totalSupply();
1128     require(_mintAmount > 0, "Need to mint at least 1 NFT");
1129     
1130     require(supply + _mintAmount <= maxSupply, "Sold Out!");
1131 
1132     if (msg.sender != owner()) 
1133     {
1134         require(msg.value >= cost * _mintAmount, "Insufficient funds");
1135 
1136         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1137         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "Max NFT per address exceeded");
1138 
1139         require(_mintAmount <= maxMintAmount, "Max mint amount per session exceeded");
1140     }
1141 
1142     addressMintedBalance[msg.sender] += _mintAmount;
1143 
1144     uint i;
1145         
1146     for (i = 0; i < _mintAmount; i++) {
1147         _safeMint(msg.sender, supply + i);
1148     }
1149   }
1150 
1151   function walletOfOwner(address _owner)
1152     public
1153     view
1154     returns (uint256[] memory)
1155   {
1156     uint256 ownerTokenCount = balanceOf(_owner);
1157     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1158 
1159     for (uint256 i; i < ownerTokenCount; i++) {
1160       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1161     }
1162     return tokenIds;
1163   }
1164   
1165   function tokenURI(uint256 tokenId)
1166     public
1167     view
1168     virtual
1169     override
1170     returns (string memory)
1171   {
1172     require(
1173       _exists(tokenId),
1174       "ERC721Metadata: URI query for nonexistent token"
1175     );
1176     
1177     if(revealed == false) {
1178         return notRevealedUri;
1179     }
1180 
1181     string memory currentBaseURI = _baseURI();
1182     return bytes(currentBaseURI).length > 0
1183         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1184         : "";
1185   } 
1186 
1187   function setRevealed(bool _state) public onlyOwner 
1188   {
1189       revealed = _state;
1190   }
1191 
1192   function pause(bool _state) public onlyOwner 
1193   {
1194     paused = _state;
1195   }
1196 
1197   function setSignatureVerifiedWhitelist(bool _state) public onlyOwner 
1198   {
1199     signatureVerifiedWhitelist = _state;
1200   }
1201   
1202   function setNftPerAddressLimit(uint256 _limit) public onlyOwner 
1203   {
1204     nftPerAddressLimit = _limit;
1205   }
1206   
1207   function setCost(uint256 _newCost) public onlyOwner 
1208   {
1209     cost = _newCost;
1210   }
1211 
1212   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner 
1213   {
1214     maxMintAmount = _newmaxMintAmount;
1215   }
1216 
1217   function setBaseURI(string memory _newBaseURI) public onlyOwner 
1218   {
1219     baseURI = _newBaseURI;
1220   }
1221   
1222   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner 
1223   {
1224     notRevealedUri = _notRevealedURI;
1225   }
1226   
1227   function setProvenanceHash(string memory provenanceHash) public onlyOwner
1228   {
1229     PROVENANCE = provenanceHash;
1230   }
1231 
1232   function setOnlyWhitelisted(bool _state) public onlyOwner 
1233   {
1234     onlyWhitelisted = _state;
1235   }
1236 
1237   function whitelistAddress(address[] calldata usersToAdd) public onlyOwner
1238   {
1239     for (uint i = 0; i < usersToAdd.length; i++)
1240         whitelistedAddresses[usersToAdd[i]] = true;
1241   }
1242 
1243   function unWhitelistAdress(address[] calldata usersToAdd) public onlyOwner
1244   {
1245       for (uint i = 0; i < usersToAdd.length; i++)
1246         whitelistedAddresses[usersToAdd[i]] = false;
1247   }
1248 
1249   function isWhitelisted(address _address) public view returns(bool)
1250   {
1251       return whitelistedAddresses[_address];
1252   }
1253 
1254   function withdraw() public payable onlyOwner 
1255   {
1256     (bool hs, ) = payable(0x1e9C6144c06Bb4B21586E11bb9d0D526Dc590C9d).call{value: address(this).balance}("");
1257     require(hs);
1258   }
1259 }