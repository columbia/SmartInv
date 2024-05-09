1 // Dope Shibas
2 // SPDX-License-Identifier: MIT
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
27 
28 
29 
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Implementation of the {IERC165} interface.
36  *
37  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
38  * for the additional interface id that will be supported. For example:
39  *
40  * ```solidity
41  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
42  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
43  * }
44  * ```
45  *
46  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
47  */
48 abstract contract ERC165 is IERC165 {
49     /**
50      * @dev See {IERC165-supportsInterface}.
51      */
52     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
53         return interfaceId == type(IERC165).interfaceId;
54     }
55 }
56 
57 
58 pragma solidity ^0.8.0;
59 
60 /**
61  * @dev String operations.
62  */
63 library Strings {
64     bytes16 private constant alphabet = "0123456789abcdef";
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
68      */
69     function toString(uint256 value) internal pure returns (string memory) {
70         // Inspired by OraclizeAPI's implementation - MIT licence
71         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
72 
73         if (value == 0) {
74             return "0";
75         }
76         uint256 temp = value;
77         uint256 digits;
78         while (temp != 0) {
79             digits++;
80             temp /= 10;
81         }
82         bytes memory buffer = new bytes(digits);
83         while (value != 0) {
84             digits -= 1;
85             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
86             value /= 10;
87         }
88         return string(buffer);
89     }
90 
91     /**
92      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
93      */
94     function toHexString(uint256 value) internal pure returns (string memory) {
95         if (value == 0) {
96             return "0x00";
97         }
98         uint256 temp = value;
99         uint256 length = 0;
100         while (temp != 0) {
101             length++;
102             temp >>= 8;
103         }
104         return toHexString(value, length);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
109      */
110     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
111         bytes memory buffer = new bytes(2 * length + 2);
112         buffer[0] = "0";
113         buffer[1] = "x";
114         for (uint256 i = 2 * length + 1; i > 1; --i) {
115             buffer[i] = alphabet[value & 0xf];
116             value >>= 4;
117         }
118         require(value == 0, "Strings: hex length insufficient");
119         return string(buffer);
120     }
121 
122 }
123 
124 
125 
126 pragma solidity ^0.8.0;
127 
128 /*
129  * @dev Provides information about the current execution context, including the
130  * sender of the transaction and its data. While these are generally available
131  * via msg.sender and msg.data, they should not be accessed in such a direct
132  * manner, since when dealing with meta-transactions the account sending and
133  * paying for execution may not be the actual sender (as far as an application
134  * is concerned).
135  *
136  * This contract is only required for intermediate, library-like contracts.
137  */
138 abstract contract Context {
139     function _msgSender() internal view virtual returns (address) {
140         return msg.sender;
141     }
142 
143     function _msgData() internal view virtual returns (bytes calldata) {
144         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
145         return msg.data;
146     }
147 }
148 
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev Collection of functions related to the address type
154  */
155 library Address {
156     /**
157      * @dev Returns true if `account` is a contract.
158      *
159      * [IMPORTANT]
160      * ====
161      * It is unsafe to assume that an address for which this function returns
162      * false is an externally-owned account (EOA) and not a contract.
163      *
164      * Among others, `isContract` will return false for the following
165      * types of addresses:
166      *
167      *  - an externally-owned account
168      *  - a contract in construction
169      *  - an address where a contract will be created
170      *  - an address where a contract lived, but was destroyed
171      * ====
172      */
173     function isContract(address account) internal view returns (bool) {
174         // This method relies on extcodesize, which returns 0 for contracts in
175         // construction, since the code is only stored at the end of the
176         // constructor execution.
177 
178         uint256 size;
179         // solhint-disable-next-line no-inline-assembly
180         assembly { size := extcodesize(account) }
181         return size > 0;
182     }
183 
184     /**
185      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
186      * `recipient`, forwarding all available gas and reverting on errors.
187      *
188      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
189      * of certain opcodes, possibly making contracts go over the 2300 gas limit
190      * imposed by `transfer`, making them unable to receive funds via
191      * `transfer`. {sendValue} removes this limitation.
192      *
193      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
194      *
195      * IMPORTANT: because control is transferred to `recipient`, care must be
196      * taken to not create reentrancy vulnerabilities. Consider using
197      * {ReentrancyGuard} or the
198      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
199      */
200     function sendValue(address payable recipient, uint256 amount) internal {
201         require(address(this).balance >= amount, "Address: insufficient balance");
202 
203         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
204         (bool success, ) = recipient.call{ value: amount }("");
205         require(success, "Address: unable to send value, recipient may have reverted");
206     }
207 
208     /**
209      * @dev Performs a Solidity function call using a low level `call`. A
210      * plain`call` is an unsafe replacement for a function call: use this
211      * function instead.
212      *
213      * If `target` reverts with a revert reason, it is bubbled up by this
214      * function (like regular Solidity function calls).
215      *
216      * Returns the raw returned data. To convert to the expected return value,
217      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
218      *
219      * Requirements:
220      *
221      * - `target` must be a contract.
222      * - calling `target` with `data` must not revert.
223      *
224      * _Available since v3.1._
225      */
226     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
227       return functionCall(target, data, "Address: low-level call failed");
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
232      * `errorMessage` as a fallback revert reason when `target` reverts.
233      *
234      * _Available since v3.1._
235      */
236     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
237         return functionCallWithValue(target, data, 0, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but also transferring `value` wei to `target`.
243      *
244      * Requirements:
245      *
246      * - the calling contract must have an ETH balance of at least `value`.
247      * - the called Solidity function must be `payable`.
248      *
249      * _Available since v3.1._
250      */
251     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
252         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
257      * with `errorMessage` as a fallback revert reason when `target` reverts.
258      *
259      * _Available since v3.1._
260      */
261     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
262         require(address(this).balance >= value, "Address: insufficient balance for call");
263         require(isContract(target), "Address: call to non-contract");
264 
265         // solhint-disable-next-line avoid-low-level-calls
266         (bool success, bytes memory returndata) = target.call{ value: value }(data);
267         return _verifyCallResult(success, returndata, errorMessage);
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
272      * but performing a static call.
273      *
274      * _Available since v3.3._
275      */
276     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
277         return functionStaticCall(target, data, "Address: low-level static call failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
282      * but performing a static call.
283      *
284      * _Available since v3.3._
285      */
286     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
287         require(isContract(target), "Address: static call to non-contract");
288 
289         // solhint-disable-next-line avoid-low-level-calls
290         (bool success, bytes memory returndata) = target.staticcall(data);
291         return _verifyCallResult(success, returndata, errorMessage);
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but performing a delegate call.
297      *
298      * _Available since v3.4._
299      */
300     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
301         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
306      * but performing a delegate call.
307      *
308      * _Available since v3.4._
309      */
310     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
311         require(isContract(target), "Address: delegate call to non-contract");
312 
313         // solhint-disable-next-line avoid-low-level-calls
314         (bool success, bytes memory returndata) = target.delegatecall(data);
315         return _verifyCallResult(success, returndata, errorMessage);
316     }
317 
318     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
319         if (success) {
320             return returndata;
321         } else {
322             // Look for revert reason and bubble it up if present
323             if (returndata.length > 0) {
324                 // The easiest way to bubble the revert reason is using memory via assembly
325 
326                 // solhint-disable-next-line no-inline-assembly
327                 assembly {
328                     let returndata_size := mload(returndata)
329                     revert(add(32, returndata), returndata_size)
330                 }
331             } else {
332                 revert(errorMessage);
333             }
334         }
335     }
336 }
337 
338 
339 
340 
341 
342 pragma solidity ^0.8.0;
343 
344 /**
345  * @title ERC721 token receiver interface
346  * @dev Interface for any contract that wants to support safeTransfers
347  * from ERC721 asset contracts.
348  */
349 interface IERC721Receiver {
350     /**
351      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
352      * by `operator` from `from`, this function is called.
353      *
354      * It must return its Solidity selector to confirm the token transfer.
355      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
356      *
357      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
358      */
359     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
360 }
361 
362 
363 
364 
365 pragma solidity ^0.8.0;
366 
367 
368 /**
369  * @dev Required interface of an ERC721 compliant contract.
370  */
371 interface IERC721 is IERC165 {
372     /**
373      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
374      */
375     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
376 
377     /**
378      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
379      */
380     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
381 
382     /**
383      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
384      */
385     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
386 
387     /**
388      * @dev Returns the number of tokens in ``owner``'s account.
389      */
390     function balanceOf(address owner) external view returns (uint256 balance);
391 
392     /**
393      * @dev Returns the owner of the `tokenId` token.
394      *
395      * Requirements:
396      *
397      * - `tokenId` must exist.
398      */
399     function ownerOf(uint256 tokenId) external view returns (address owner);
400 
401     /**
402      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
403      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
404      *
405      * Requirements:
406      *
407      * - `from` cannot be the zero address.
408      * - `to` cannot be the zero address.
409      * - `tokenId` token must exist and be owned by `from`.
410      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
411      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
412      *
413      * Emits a {Transfer} event.
414      */
415     function safeTransferFrom(address from, address to, uint256 tokenId) external;
416 
417     /**
418      * @dev Transfers `tokenId` token from `from` to `to`.
419      *
420      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
421      *
422      * Requirements:
423      *
424      * - `from` cannot be the zero address.
425      * - `to` cannot be the zero address.
426      * - `tokenId` token must be owned by `from`.
427      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
428      *
429      * Emits a {Transfer} event.
430      */
431     function transferFrom(address from, address to, uint256 tokenId) external;
432 
433     /**
434      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
435      * The approval is cleared when the token is transferred.
436      *
437      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
438      *
439      * Requirements:
440      *
441      * - The caller must own the token or be an approved operator.
442      * - `tokenId` must exist.
443      *
444      * Emits an {Approval} event.
445      */
446     function approve(address to, uint256 tokenId) external;
447 
448     /**
449      * @dev Returns the account approved for `tokenId` token.
450      *
451      * Requirements:
452      *
453      * - `tokenId` must exist.
454      */
455     function getApproved(uint256 tokenId) external view returns (address operator);
456 
457     /**
458      * @dev Approve or remove `operator` as an operator for the caller.
459      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
460      *
461      * Requirements:
462      *
463      * - The `operator` cannot be the caller.
464      *
465      * Emits an {ApprovalForAll} event.
466      */
467     function setApprovalForAll(address operator, bool _approved) external;
468 
469     /**
470      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
471      *
472      * See {setApprovalForAll}
473      */
474     function isApprovedForAll(address owner, address operator) external view returns (bool);
475 
476     /**
477       * @dev Safely transfers `tokenId` token from `from` to `to`.
478       *
479       * Requirements:
480       *
481       * - `from` cannot be the zero address.
482       * - `to` cannot be the zero address.
483       * - `tokenId` token must exist and be owned by `from`.
484       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
485       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
486       *
487       * Emits a {Transfer} event.
488       */
489     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
490 }
491 
492 
493 pragma solidity ^0.8.0;
494 
495 
496 /**
497  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
498  * @dev See https://eips.ethereum.org/EIPS/eip-721
499  */
500 interface IERC721Enumerable is IERC721 {
501 
502     /**
503      * @dev Returns the total amount of tokens stored by the contract.
504      */
505     function totalSupply() external view returns (uint256);
506 
507     /**
508      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
509      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
510      */
511     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
512 
513     /**
514      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
515      * Use along with {totalSupply} to enumerate all tokens.
516      */
517     function tokenByIndex(uint256 index) external view returns (uint256);
518 }
519 
520 
521 pragma solidity ^0.8.0;
522 
523 
524 /**
525  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
526  * @dev See https://eips.ethereum.org/EIPS/eip-721
527  */
528 interface IERC721Metadata is IERC721 {
529 
530     /**
531      * @dev Returns the token collection name.
532      */
533     function name() external view returns (string memory);
534 
535     /**
536      * @dev Returns the token collection symbol.
537      */
538     function symbol() external view returns (string memory);
539 
540     /**
541      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
542      */
543     function tokenURI(uint256 tokenId) external view returns (string memory);
544 }
545 
546 
547 
548 pragma solidity ^0.8.0;
549 
550 
551 /**
552  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
553  * the Metadata extension, but not including the Enumerable extension, which is available separately as
554  * {ERC721Enumerable}.
555  */
556 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
557     using Address for address;
558     using Strings for uint256;
559 
560     // Token name
561     string private _name;
562 
563     // Token symbol
564     string private _symbol;
565 
566     // Mapping from token ID to owner address
567     mapping (uint256 => address) private _owners;
568 
569     // Mapping owner address to token count
570     mapping (address => uint256) private _balances;
571 
572     // Mapping from token ID to approved address
573     mapping (uint256 => address) private _tokenApprovals;
574 
575     // Mapping from owner to operator approvals
576     mapping (address => mapping (address => bool)) private _operatorApprovals;
577 
578     /**
579      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
580      */
581     constructor (string memory name_, string memory symbol_) {
582         _name = name_;
583         _symbol = symbol_;
584     }
585 
586     /**
587      * @dev See {IERC165-supportsInterface}.
588      */
589     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
590         return interfaceId == type(IERC721).interfaceId
591             || interfaceId == type(IERC721Metadata).interfaceId
592             || super.supportsInterface(interfaceId);
593     }
594 
595     /**
596      * @dev See {IERC721-balanceOf}.
597      */
598     function balanceOf(address owner) public view virtual override returns (uint256) {
599         require(owner != address(0), "ERC721: balance query for the zero address");
600         return _balances[owner];
601     }
602 
603     /**
604      * @dev See {IERC721-ownerOf}.
605      */
606     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
607         address owner = _owners[tokenId];
608         require(owner != address(0), "ERC721: owner query for nonexistent token");
609         return owner;
610     }
611 
612     /**
613      * @dev See {IERC721Metadata-name}.
614      */
615     function name() public view virtual override returns (string memory) {
616         return _name;
617     }
618 
619     /**
620      * @dev See {IERC721Metadata-symbol}.
621      */
622     function symbol() public view virtual override returns (string memory) {
623         return _symbol;
624     }
625 
626     /**
627      * @dev See {IERC721Metadata-tokenURI}.
628      */
629     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
630         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
631 
632         string memory baseURI = _baseURI();
633         return bytes(baseURI).length > 0
634             ? string(abi.encodePacked(baseURI, tokenId.toString()))
635             : '';
636     }
637 
638     /**
639      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
640      * in child contracts.
641      */
642     function _baseURI() internal view virtual returns (string memory) {
643         return "";
644     }
645 
646     /**
647      * @dev See {IERC721-approve}.
648      */
649     function approve(address to, uint256 tokenId) public virtual override {
650         address owner = ERC721.ownerOf(tokenId);
651         require(to != owner, "ERC721: approval to current owner");
652 
653         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
654             "ERC721: approve caller is not owner nor approved for all"
655         );
656 
657         _approve(to, tokenId);
658     }
659 
660     /**
661      * @dev See {IERC721-getApproved}.
662      */
663     function getApproved(uint256 tokenId) public view virtual override returns (address) {
664         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
665 
666         return _tokenApprovals[tokenId];
667     }
668 
669     /**
670      * @dev See {IERC721-setApprovalForAll}.
671      */
672     function setApprovalForAll(address operator, bool approved) public virtual override {
673         require(operator != _msgSender(), "ERC721: approve to caller");
674 
675         _operatorApprovals[_msgSender()][operator] = approved;
676         emit ApprovalForAll(_msgSender(), operator, approved);
677     }
678 
679     /**
680      * @dev See {IERC721-isApprovedForAll}.
681      */
682     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
683         return _operatorApprovals[owner][operator];
684     }
685 
686     /**
687      * @dev See {IERC721-transferFrom}.
688      */
689     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
690         //solhint-disable-next-line max-line-length
691         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
692 
693         _transfer(from, to, tokenId);
694     }
695 
696     /**
697      * @dev See {IERC721-safeTransferFrom}.
698      */
699     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
700         safeTransferFrom(from, to, tokenId, "");
701     }
702 
703     /**
704      * @dev See {IERC721-safeTransferFrom}.
705      */
706     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
707         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
708         _safeTransfer(from, to, tokenId, _data);
709     }
710 
711     /**
712      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
713      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
714      *
715      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
716      *
717      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
718      * implement alternative mechanisms to perform token transfer, such as signature-based.
719      *
720      * Requirements:
721      *
722      * - `from` cannot be the zero address.
723      * - `to` cannot be the zero address.
724      * - `tokenId` token must exist and be owned by `from`.
725      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
726      *
727      * Emits a {Transfer} event.
728      */
729     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
730         _transfer(from, to, tokenId);
731         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
732     }
733 
734     /**
735      * @dev Returns whether `tokenId` exists.
736      *
737      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
738      *
739      * Tokens start existing when they are minted (`_mint`),
740      * and stop existing when they are burned (`_burn`).
741      */
742     function _exists(uint256 tokenId) internal view virtual returns (bool) {
743         return _owners[tokenId] != address(0);
744     }
745 
746     /**
747      * @dev Returns whether `spender` is allowed to manage `tokenId`.
748      *
749      * Requirements:
750      *
751      * - `tokenId` must exist.
752      */
753     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
754         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
755         address owner = ERC721.ownerOf(tokenId);
756         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
757     }
758 
759     /**
760      * @dev Safely mints `tokenId` and transfers it to `to`.
761      *
762      * Requirements:
763      *
764      * - `tokenId` must not exist.
765      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
766      *
767      * Emits a {Transfer} event.
768      */
769     function _safeMint(address to, uint256 tokenId) internal virtual {
770         _safeMint(to, tokenId, "");
771     }
772 
773     /**
774      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
775      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
776      */
777     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
778         _mint(to, tokenId);
779         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
780     }
781 
782     /**
783      * @dev Mints `tokenId` and transfers it to `to`.
784      *
785      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
786      *
787      * Requirements:
788      *
789      * - `tokenId` must not exist.
790      * - `to` cannot be the zero address.
791      *
792      * Emits a {Transfer} event.
793      */
794     function _mint(address to, uint256 tokenId) internal virtual {
795         require(to != address(0), "ERC721: mint to the zero address");
796         require(!_exists(tokenId), "ERC721: token already minted");
797 
798         _beforeTokenTransfer(address(0), to, tokenId);
799 
800         _balances[to] += 1;
801         _owners[tokenId] = to;
802 
803         emit Transfer(address(0), to, tokenId);
804     }
805     
806 
807     /**
808      * @dev Destroys `tokenId`.
809      * The approval is cleared when the token is burned.
810      *
811      * Requirements:
812      *
813      * - `tokenId` must exist.
814      *
815      * Emits a {Transfer} event.
816      */
817     function _burn(uint256 tokenId) internal virtual {
818         address owner = ERC721.ownerOf(tokenId);
819 
820         _beforeTokenTransfer(owner, address(0), tokenId);
821 
822         // Clear approvals
823         _approve(address(0), tokenId);
824 
825         _balances[owner] -= 1;
826         delete _owners[tokenId];
827 
828         emit Transfer(owner, address(0), tokenId);
829     }
830 
831     /**
832      * @dev Transfers `tokenId` from `from` to `to`.
833      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
834      *
835      * Requirements:
836      *
837      * - `to` cannot be the zero address.
838      * - `tokenId` token must be owned by `from`.
839      *
840      * Emits a {Transfer} event.
841      */
842     function _transfer(address from, address to, uint256 tokenId) internal virtual {
843         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
844         require(to != address(0), "ERC721: transfer to the zero address");
845 
846         _beforeTokenTransfer(from, to, tokenId);
847 
848         // Clear approvals from the previous owner
849         _approve(address(0), tokenId);
850 
851         _balances[from] -= 1;
852         _balances[to] += 1;
853         _owners[tokenId] = to;
854 
855         emit Transfer(from, to, tokenId);
856     }
857 
858     /**
859      * @dev Approve `to` to operate on `tokenId`
860      *
861      * Emits a {Approval} event.
862      */
863     function _approve(address to, uint256 tokenId) internal virtual {
864         _tokenApprovals[tokenId] = to;
865         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
866     }
867 
868     /**
869      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
870      * The call is not executed if the target address is not a contract.
871      *
872      * @param from address representing the previous owner of the given token ID
873      * @param to target address that will receive the tokens
874      * @param tokenId uint256 ID of the token to be transferred
875      * @param _data bytes optional data to send along with the call
876      * @return bool whether the call correctly returned the expected magic value
877      */
878     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
879         private returns (bool)
880     {
881         if (to.isContract()) {
882             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
883                 return retval == IERC721Receiver(to).onERC721Received.selector;
884             } catch (bytes memory reason) {
885                 if (reason.length == 0) {
886                     revert("ERC721: transfer to non ERC721Receiver implementer");
887                 } else {
888                     // solhint-disable-next-line no-inline-assembly
889                     assembly {
890                         revert(add(32, reason), mload(reason))
891                     }
892                 }
893             }
894         } else {
895             return true;
896         }
897     }
898 
899     /**
900      * @dev Hook that is called before any token transfer. This includes minting
901      * and burning.
902      *
903      * Calling conditions:
904      *
905      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
906      * transferred to `to`.
907      * - When `from` is zero, `tokenId` will be minted for `to`.
908      * - When `to` is zero, ``from``'s `tokenId` will be burned.
909      * - `from` cannot be the zero address.
910      * - `to` cannot be the zero address.
911      *
912      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
913      */
914     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
915 }
916 
917 
918 pragma solidity ^0.8.0;
919 
920 /**
921  * @dev Contract module which provides a basic access control mechanism, where
922  * there is an account (an owner) that can be granted exclusive access to
923  * specific functions.
924  *
925  * By default, the owner account will be the one that deploys the contract. This
926  * can later be changed with {transferOwnership}.
927  *
928  * This module is used through inheritance. It will make available the modifier
929  * `onlyOwner`, which can be applied to your functions to restrict their use to
930  * the owner.
931  */
932 abstract contract Ownable is Context {
933     address private _owner;
934 
935     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
936 
937     /**
938      * @dev Initializes the contract setting the deployer as the initial owner.
939      */
940     constructor () {
941         address msgSender = _msgSender();
942         _owner = msgSender;
943         emit OwnershipTransferred(address(0), msgSender);
944     }
945 
946     /**
947      * @dev Returns the address of the current owner.
948      */
949     function owner() public view virtual returns (address) {
950         return _owner;
951     }
952 
953     /**
954      * @dev Throws if called by any account other than the owner.
955      */
956     modifier onlyOwner() {
957         require(owner() == _msgSender(), "Ownable: caller is not the owner");
958         _;
959     }
960 
961     /**
962      * @dev Leaves the contract without owner. It will not be possible to call
963      * `onlyOwner` functions anymore. Can only be called by the current owner.
964      *
965      * NOTE: Renouncing ownership will leave the contract without an owner,
966      * thereby removing any functionality that is only available to the owner.
967      */
968     function renounceOwnership() public virtual onlyOwner {
969         emit OwnershipTransferred(_owner, address(0));
970         _owner = address(0);
971     }
972 
973     /**
974      * @dev Transfers ownership of the contract to a new account (`newOwner`).
975      * Can only be called by the current owner.
976      */
977     function transferOwnership(address newOwner) public virtual onlyOwner {
978         require(newOwner != address(0), "Ownable: new owner is the zero address");
979         emit OwnershipTransferred(_owner, newOwner);
980         _owner = newOwner;
981     }
982 }
983 
984 pragma solidity ^0.8.0;
985 
986 
987 /**
988  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
989  * enumerability of all the token ids in the contract as well as all token ids owned by each
990  * account.
991  */
992 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
993     // Mapping from owner to list of owned token IDs
994     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
995 
996     // Mapping from token ID to index of the owner tokens list
997     mapping(uint256 => uint256) private _ownedTokensIndex;
998 
999     // Array with all token ids, used for enumeration
1000     uint256[] private _allTokens;
1001 
1002     // Mapping from token id to position in the allTokens array
1003     mapping(uint256 => uint256) private _allTokensIndex;
1004 
1005     /**
1006      * @dev See {IERC165-supportsInterface}.
1007      */
1008     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1009         return interfaceId == type(IERC721Enumerable).interfaceId
1010             || super.supportsInterface(interfaceId);
1011     }
1012 
1013     /**
1014      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1015      */
1016     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1017         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1018         return _ownedTokens[owner][index];
1019     }
1020 
1021     /**
1022      * @dev See {IERC721Enumerable-totalSupply}.
1023      */
1024     function totalSupply() public view virtual override returns (uint256) {
1025         return _allTokens.length;
1026     }
1027 
1028     /**
1029      * @dev See {IERC721Enumerable-tokenByIndex}.
1030      */
1031     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1032         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1033         return _allTokens[index];
1034     }
1035 
1036     /**
1037      * @dev Hook that is called before any token transfer. This includes minting
1038      * and burning.
1039      *
1040      * Calling conditions:
1041      *
1042      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1043      * transferred to `to`.
1044      * - When `from` is zero, `tokenId` will be minted for `to`.
1045      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1046      * - `from` cannot be the zero address.
1047      * - `to` cannot be the zero address.
1048      *
1049      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1050      */
1051     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1052         super._beforeTokenTransfer(from, to, tokenId);
1053 
1054         if (from == address(0)) {
1055             _addTokenToAllTokensEnumeration(tokenId);
1056         } else if (from != to) {
1057             _removeTokenFromOwnerEnumeration(from, tokenId);
1058         }
1059         if (to == address(0)) {
1060             _removeTokenFromAllTokensEnumeration(tokenId);
1061         } else if (to != from) {
1062             _addTokenToOwnerEnumeration(to, tokenId);
1063         }
1064     }
1065 
1066     /**
1067      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1068      * @param to address representing the new owner of the given token ID
1069      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1070      */
1071     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1072         uint256 length = ERC721.balanceOf(to);
1073         _ownedTokens[to][length] = tokenId;
1074         _ownedTokensIndex[tokenId] = length;
1075     }
1076 
1077     /**
1078      * @dev Private function to add a token to this extension's token tracking data structures.
1079      * @param tokenId uint256 ID of the token to be added to the tokens list
1080      */
1081     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1082         _allTokensIndex[tokenId] = _allTokens.length;
1083         _allTokens.push(tokenId);
1084     }
1085 
1086     /**
1087      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1088      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1089      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1090      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1091      * @param from address representing the previous owner of the given token ID
1092      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1093      */
1094     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1095         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1096         // then delete the last slot (swap and pop).
1097 
1098         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1099         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1100 
1101         // When the token to delete is the last token, the swap operation is unnecessary
1102         if (tokenIndex != lastTokenIndex) {
1103             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1104 
1105             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1106             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1107         }
1108 
1109         // This also deletes the contents at the last position of the array
1110         delete _ownedTokensIndex[tokenId];
1111         delete _ownedTokens[from][lastTokenIndex];
1112     }
1113 
1114     /**
1115      * @dev Private function to remove a token from this extension's token tracking data structures.
1116      * This has O(1) time complexity, but alters the order of the _allTokens array.
1117      * @param tokenId uint256 ID of the token to be removed from the tokens list
1118      */
1119     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1120         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1121         // then delete the last slot (swap and pop).
1122 
1123         uint256 lastTokenIndex = _allTokens.length - 1;
1124         uint256 tokenIndex = _allTokensIndex[tokenId];
1125 
1126         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1127         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1128         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1129         uint256 lastTokenId = _allTokens[lastTokenIndex];
1130 
1131         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1132         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1133 
1134         // This also deletes the contents at the last position of the array
1135         delete _allTokensIndex[tokenId];
1136         _allTokens.pop();
1137     }
1138 }
1139 
1140 
1141 pragma solidity ^0.8.0;
1142 
1143 
1144 contract DopeShiba is ERC721Enumerable, Ownable {
1145 
1146     using Strings for uint256;
1147 
1148     string _baseTokenURI;
1149     uint256 private _reserved = 100;
1150     uint256 private _price = 0.02 ether;
1151     bool public _paused = true;
1152 
1153     address t1 = 0x13F58543FD794C88221cc75f23e72541027aA3BD;
1154     address t2 = 0x9dD990f772b482C8e984936408514c032D85d47C;
1155 
1156     constructor(string memory baseURI) ERC721("Dope Shibas", "DOPESHIBA")  {
1157         setBaseURI(baseURI);
1158         _safeMint( t1, 0);
1159         _safeMint( t2, 1);
1160     }
1161 
1162     function adopt(uint256 num) public payable {
1163         uint256 supply = totalSupply();
1164         require( !_paused,                              "Sale paused" );
1165         require( num < 21,                              "You can adopt a maximum of 20 Shibas" );
1166         require( supply + num < 10000 - _reserved,      "Exceeds maximum Shibas supply" );
1167         require( msg.value >= _price * num,             "Ether sent is not correct" );
1168 
1169         for(uint256 i; i < num; i++){
1170             _safeMint( msg.sender, supply + i );
1171         }
1172     }
1173 
1174     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1175         uint256 tokenCount = balanceOf(_owner);
1176 
1177         uint256[] memory tokensId = new uint256[](tokenCount);
1178         for(uint256 i; i < tokenCount; i++){
1179             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1180         }
1181         return tokensId;
1182     }
1183 
1184     function setPrice(uint256 _newPrice) public onlyOwner() {
1185         _price = _newPrice;
1186     }
1187 
1188     function _baseURI() internal view virtual override returns (string memory) {
1189         return _baseTokenURI;
1190     }
1191 
1192     function setBaseURI(string memory baseURI) public onlyOwner {
1193         _baseTokenURI = baseURI;
1194     }
1195 
1196     function getPrice() public view returns (uint256){
1197         return _price;
1198     }
1199 
1200     function giveAway(address _to, uint256 _amount) external onlyOwner() {
1201         require( _amount <= _reserved, "Exceeds reserved Cat supply" );
1202 
1203         uint256 supply = totalSupply();
1204         for(uint256 i; i < _amount; i++){
1205             _safeMint( _to, supply + i );
1206         }
1207 
1208         _reserved -= _amount;
1209     }
1210 
1211     function pause(bool val) public onlyOwner {
1212         _paused = val;
1213     }
1214 
1215     function withdrawAll() public payable onlyOwner {
1216         uint256 _each = address(this).balance / 2;
1217         require(payable(t1).send(_each));
1218         require(payable(t2).send(_each));
1219     }
1220 }