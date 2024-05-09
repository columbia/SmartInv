1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-31
3 */
4 
5 pragma solidity ^0.8.0;
6 
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
28 
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 
35 /**
36  * @dev Implementation of the {IERC165} interface.
37  *
38  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
39  * for the additional interface id that will be supported. For example:
40  *
41  * ```solidity
42  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
43  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
44  * }
45  * ```
46  *
47  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
48  */
49 abstract contract ERC165 is IERC165 {
50     /**
51      * @dev See {IERC165-supportsInterface}.
52      */
53     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
54         return interfaceId == type(IERC165).interfaceId;
55     }
56 }
57 
58 
59 pragma solidity ^0.8.0;
60 
61 /**
62  * @dev String operations.
63  */
64 library Strings {
65     bytes16 private constant alphabet = "0123456789abcdef";
66 
67     /**
68      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
69      */
70     function toString(uint256 value) internal pure returns (string memory) {
71         // Inspired by OraclizeAPI's implementation - MIT licence
72         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
73 
74         if (value == 0) {
75             return "0";
76         }
77         uint256 temp = value;
78         uint256 digits;
79         while (temp != 0) {
80             digits++;
81             temp /= 10;
82         }
83         bytes memory buffer = new bytes(digits);
84         while (value != 0) {
85             digits -= 1;
86             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
87             value /= 10;
88         }
89         return string(buffer);
90     }
91 
92     /**
93      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
94      */
95     function toHexString(uint256 value) internal pure returns (string memory) {
96         if (value == 0) {
97             return "0x00";
98         }
99         uint256 temp = value;
100         uint256 length = 0;
101         while (temp != 0) {
102             length++;
103             temp >>= 8;
104         }
105         return toHexString(value, length);
106     }
107 
108     /**
109      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
110      */
111     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
112         bytes memory buffer = new bytes(2 * length + 2);
113         buffer[0] = "0";
114         buffer[1] = "x";
115         for (uint256 i = 2 * length + 1; i > 1; --i) {
116             buffer[i] = alphabet[value & 0xf];
117             value >>= 4;
118         }
119         require(value == 0, "Strings: hex length insufficient");
120         return string(buffer);
121     }
122 
123 }
124 
125 
126 
127 pragma solidity ^0.8.0;
128 
129 /*
130  * @dev Provides information about the current execution context, including the
131  * sender of the transaction and its data. While these are generally available
132  * via msg.sender and msg.data, they should not be accessed in such a direct
133  * manner, since when dealing with meta-transactions the account sending and
134  * paying for execution may not be the actual sender (as far as an application
135  * is concerned).
136  *
137  * This contract is only required for intermediate, library-like contracts.
138  */
139 abstract contract Context {
140     function _msgSender() internal view virtual returns (address) {
141         return msg.sender;
142     }
143 
144     function _msgData() internal view virtual returns (bytes calldata) {
145         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
146         return msg.data;
147     }
148 }
149 
150 
151 pragma solidity ^0.8.0;
152 
153 /**
154  * @dev Collection of functions related to the address type
155  */
156 library Address {
157     /**
158      * @dev Returns true if `account` is a contract.
159      *
160      * [IMPORTANT]
161      * ====
162      * It is unsafe to assume that an address for which this function returns
163      * false is an externally-owned account (EOA) and not a contract.
164      *
165      * Among others, `isContract` will return false for the following
166      * types of addresses:
167      *
168      *  - an externally-owned account
169      *  - a contract in construction
170      *  - an address where a contract will be created
171      *  - an address where a contract lived, but was destroyed
172      * ====
173      */
174     function isContract(address account) internal view returns (bool) {
175         // This method relies on extcodesize, which returns 0 for contracts in
176         // construction, since the code is only stored at the end of the
177         // constructor execution.
178 
179         uint256 size;
180         // solhint-disable-next-line no-inline-assembly
181         assembly { size := extcodesize(account) }
182         return size > 0;
183     }
184 
185     /**
186      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
187      * `recipient`, forwarding all available gas and reverting on errors.
188      *
189      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
190      * of certain opcodes, possibly making contracts go over the 2300 gas limit
191      * imposed by `transfer`, making them unable to receive funds via
192      * `transfer`. {sendValue} removes this limitation.
193      *
194      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
195      *
196      * IMPORTANT: because control is transferred to `recipient`, care must be
197      * taken to not create reentrancy vulnerabilities. Consider using
198      * {ReentrancyGuard} or the
199      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
200      */
201     function sendValue(address payable recipient, uint256 amount) internal {
202         require(address(this).balance >= amount, "Address: insufficient balance");
203 
204         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
205         (bool success, ) = recipient.call{ value: amount }("");
206         require(success, "Address: unable to send value, recipient may have reverted");
207     }
208 
209     /**
210      * @dev Performs a Solidity function call using a low level `call`. A
211      * plain`call` is an unsafe replacement for a function call: use this
212      * function instead.
213      *
214      * If `target` reverts with a revert reason, it is bubbled up by this
215      * function (like regular Solidity function calls).
216      *
217      * Returns the raw returned data. To convert to the expected return value,
218      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
219      *
220      * Requirements:
221      *
222      * - `target` must be a contract.
223      * - calling `target` with `data` must not revert.
224      *
225      * _Available since v3.1._
226      */
227     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
228       return functionCall(target, data, "Address: low-level call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
233      * `errorMessage` as a fallback revert reason when `target` reverts.
234      *
235      * _Available since v3.1._
236      */
237     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
238         return functionCallWithValue(target, data, 0, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but also transferring `value` wei to `target`.
244      *
245      * Requirements:
246      *
247      * - the calling contract must have an ETH balance of at least `value`.
248      * - the called Solidity function must be `payable`.
249      *
250      * _Available since v3.1._
251      */
252     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
253         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
258      * with `errorMessage` as a fallback revert reason when `target` reverts.
259      *
260      * _Available since v3.1._
261      */
262     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
263         require(address(this).balance >= value, "Address: insufficient balance for call");
264         require(isContract(target), "Address: call to non-contract");
265 
266         // solhint-disable-next-line avoid-low-level-calls
267         (bool success, bytes memory returndata) = target.call{ value: value }(data);
268         return _verifyCallResult(success, returndata, errorMessage);
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
273      * but performing a static call.
274      *
275      * _Available since v3.3._
276      */
277     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
278         return functionStaticCall(target, data, "Address: low-level static call failed");
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
283      * but performing a static call.
284      *
285      * _Available since v3.3._
286      */
287     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
288         require(isContract(target), "Address: static call to non-contract");
289 
290         // solhint-disable-next-line avoid-low-level-calls
291         (bool success, bytes memory returndata) = target.staticcall(data);
292         return _verifyCallResult(success, returndata, errorMessage);
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
297      * but performing a delegate call.
298      *
299      * _Available since v3.4._
300      */
301     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
302         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
307      * but performing a delegate call.
308      *
309      * _Available since v3.4._
310      */
311     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
312         require(isContract(target), "Address: delegate call to non-contract");
313 
314         // solhint-disable-next-line avoid-low-level-calls
315         (bool success, bytes memory returndata) = target.delegatecall(data);
316         return _verifyCallResult(success, returndata, errorMessage);
317     }
318 
319     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
320         if (success) {
321             return returndata;
322         } else {
323             // Look for revert reason and bubble it up if present
324             if (returndata.length > 0) {
325                 // The easiest way to bubble the revert reason is using memory via assembly
326 
327                 // solhint-disable-next-line no-inline-assembly
328                 assembly {
329                     let returndata_size := mload(returndata)
330                     revert(add(32, returndata), returndata_size)
331                 }
332             } else {
333                 revert(errorMessage);
334             }
335         }
336     }
337 }
338 
339 
340 
341 
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @title ERC721 token receiver interface
347  * @dev Interface for any contract that wants to support safeTransfers
348  * from ERC721 asset contracts.
349  */
350 interface IERC721Receiver {
351     /**
352      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
353      * by `operator` from `from`, this function is called.
354      *
355      * It must return its Solidity selector to confirm the token transfer.
356      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
357      *
358      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
359      */
360     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
361 }
362 
363 
364 
365 
366 pragma solidity ^0.8.0;
367 
368 
369 /**
370  * @dev Required interface of an ERC721 compliant contract.
371  */
372 interface IERC721 is IERC165 {
373     /**
374      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
375      */
376     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
377 
378     /**
379      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
380      */
381     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
382 
383     /**
384      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
385      */
386     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
387 
388     /**
389      * @dev Returns the number of tokens in ``owner``'s account.
390      */
391     function balanceOf(address owner) external view returns (uint256 balance);
392 
393     /**
394      * @dev Returns the owner of the `tokenId` token.
395      *
396      * Requirements:
397      *
398      * - `tokenId` must exist.
399      */
400     function ownerOf(uint256 tokenId) external view returns (address owner);
401 
402     /**
403      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
404      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
405      *
406      * Requirements:
407      *
408      * - `from` cannot be the zero address.
409      * - `to` cannot be the zero address.
410      * - `tokenId` token must exist and be owned by `from`.
411      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
412      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
413      *
414      * Emits a {Transfer} event.
415      */
416     function safeTransferFrom(address from, address to, uint256 tokenId) external;
417 
418     /**
419      * @dev Transfers `tokenId` token from `from` to `to`.
420      *
421      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
422      *
423      * Requirements:
424      *
425      * - `from` cannot be the zero address.
426      * - `to` cannot be the zero address.
427      * - `tokenId` token must be owned by `from`.
428      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
429      *
430      * Emits a {Transfer} event.
431      */
432     function transferFrom(address from, address to, uint256 tokenId) external;
433 
434     /**
435      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
436      * The approval is cleared when the token is transferred.
437      *
438      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
439      *
440      * Requirements:
441      *
442      * - The caller must own the token or be an approved operator.
443      * - `tokenId` must exist.
444      *
445      * Emits an {Approval} event.
446      */
447     function approve(address to, uint256 tokenId) external;
448 
449     /**
450      * @dev Returns the account approved for `tokenId` token.
451      *
452      * Requirements:
453      *
454      * - `tokenId` must exist.
455      */
456     function getApproved(uint256 tokenId) external view returns (address operator);
457 
458     /**
459      * @dev Approve or remove `operator` as an operator for the caller.
460      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
461      *
462      * Requirements:
463      *
464      * - The `operator` cannot be the caller.
465      *
466      * Emits an {ApprovalForAll} event.
467      */
468     function setApprovalForAll(address operator, bool _approved) external;
469 
470     /**
471      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
472      *
473      * See {setApprovalForAll}
474      */
475     function isApprovedForAll(address owner, address operator) external view returns (bool);
476 
477     /**
478       * @dev Safely transfers `tokenId` token from `from` to `to`.
479       *
480       * Requirements:
481       *
482       * - `from` cannot be the zero address.
483       * - `to` cannot be the zero address.
484       * - `tokenId` token must exist and be owned by `from`.
485       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
486       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
487       *
488       * Emits a {Transfer} event.
489       */
490     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
491 }
492 
493 
494 pragma solidity ^0.8.0;
495 
496 
497 /**
498  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
499  * @dev See https://eips.ethereum.org/EIPS/eip-721
500  */
501 interface IERC721Enumerable is IERC721 {
502 
503     /**
504      * @dev Returns the total amount of tokens stored by the contract.
505      */
506     function totalSupply() external view returns (uint256);
507 
508     /**
509      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
510      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
511      */
512     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
513 
514     /**
515      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
516      * Use along with {totalSupply} to enumerate all tokens.
517      */
518     function tokenByIndex(uint256 index) external view returns (uint256);
519 }
520 
521 
522 pragma solidity ^0.8.0;
523 
524 
525 /**
526  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
527  * @dev See https://eips.ethereum.org/EIPS/eip-721
528  */
529 interface IERC721Metadata is IERC721 {
530 
531     /**
532      * @dev Returns the token collection name.
533      */
534     function name() external view returns (string memory);
535 
536     /**
537      * @dev Returns the token collection symbol.
538      */
539     function symbol() external view returns (string memory);
540 
541     /**
542      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
543      */
544     function tokenURI(uint256 tokenId) external view returns (string memory);
545 }
546 
547 
548 
549 pragma solidity ^0.8.0;
550 
551 
552 /**
553  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
554  * the Metadata extension, but not including the Enumerable extension, which is available separately as
555  * {ERC721Enumerable}.
556  */
557 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
558     using Address for address;
559     using Strings for uint256;
560 
561     // Token name
562     string private _name;
563 
564     // Token symbol
565     string private _symbol;
566 
567     // Mapping from token ID to owner address
568     mapping (uint256 => address) private _owners;
569 
570     // Mapping owner address to token count
571     mapping (address => uint256) private _balances;
572 
573     // Mapping from token ID to approved address
574     mapping (uint256 => address) private _tokenApprovals;
575 
576     // Mapping from owner to operator approvals
577     mapping (address => mapping (address => bool)) private _operatorApprovals;
578 
579     /**
580      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
581      */
582     constructor (string memory name_, string memory symbol_) {
583         _name = name_;
584         _symbol = symbol_;
585     }
586 
587     /**
588      * @dev See {IERC165-supportsInterface}.
589      */
590     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
591         return interfaceId == type(IERC721).interfaceId
592             || interfaceId == type(IERC721Metadata).interfaceId
593             || super.supportsInterface(interfaceId);
594     }
595 
596     /**
597      * @dev See {IERC721-balanceOf}.
598      */
599     function balanceOf(address owner) public view virtual override returns (uint256) {
600         require(owner != address(0), "ERC721: balance query for the zero address");
601         return _balances[owner];
602     }
603 
604     /**
605      * @dev See {IERC721-ownerOf}.
606      */
607     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
608         address owner = _owners[tokenId];
609         require(owner != address(0), "ERC721: owner query for nonexistent token");
610         return owner;
611     }
612 
613     /**
614      * @dev See {IERC721Metadata-name}.
615      */
616     function name() public view virtual override returns (string memory) {
617         return _name;
618     }
619 
620     /**
621      * @dev See {IERC721Metadata-symbol}.
622      */
623     function symbol() public view virtual override returns (string memory) {
624         return _symbol;
625     }
626 
627     /**
628      * @dev See {IERC721Metadata-tokenURI}.
629      */
630     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
631         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
632 
633         string memory baseURI = _baseURI();
634         return bytes(baseURI).length > 0
635             ? string(abi.encodePacked(baseURI, tokenId.toString()))
636             : '';
637     }
638 
639     /**
640      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
641      * in child contracts.
642      */
643     function _baseURI() internal view virtual returns (string memory) {
644         return "";
645     }
646 
647     /**
648      * @dev See {IERC721-approve}.
649      */
650     function approve(address to, uint256 tokenId) public virtual override {
651         address owner = ERC721.ownerOf(tokenId);
652         require(to != owner, "ERC721: approval to current owner");
653 
654         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
655             "ERC721: approve caller is not owner nor approved for all"
656         );
657 
658         _approve(to, tokenId);
659     }
660 
661     /**
662      * @dev See {IERC721-getApproved}.
663      */
664     function getApproved(uint256 tokenId) public view virtual override returns (address) {
665         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
666 
667         return _tokenApprovals[tokenId];
668     }
669 
670     /**
671      * @dev See {IERC721-setApprovalForAll}.
672      */
673     function setApprovalForAll(address operator, bool approved) public virtual override {
674         require(operator != _msgSender(), "ERC721: approve to caller");
675 
676         _operatorApprovals[_msgSender()][operator] = approved;
677         emit ApprovalForAll(_msgSender(), operator, approved);
678     }
679 
680     /**
681      * @dev See {IERC721-isApprovedForAll}.
682      */
683     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
684         return _operatorApprovals[owner][operator];
685     }
686 
687     /**
688      * @dev See {IERC721-transferFrom}.
689      */
690     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
691         //solhint-disable-next-line max-line-length
692         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
693 
694         _transfer(from, to, tokenId);
695     }
696 
697     /**
698      * @dev See {IERC721-safeTransferFrom}.
699      */
700     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
701         safeTransferFrom(from, to, tokenId, "");
702     }
703 
704     /**
705      * @dev See {IERC721-safeTransferFrom}.
706      */
707     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
708         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
709         _safeTransfer(from, to, tokenId, _data);
710     }
711 
712     /**
713      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
714      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
715      *
716      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
717      *
718      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
719      * implement alternative mechanisms to perform token transfer, such as signature-based.
720      *
721      * Requirements:
722      *
723      * - `from` cannot be the zero address.
724      * - `to` cannot be the zero address.
725      * - `tokenId` token must exist and be owned by `from`.
726      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
727      *
728      * Emits a {Transfer} event.
729      */
730     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
731         _transfer(from, to, tokenId);
732         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
733     }
734 
735     /**
736      * @dev Returns whether `tokenId` exists.
737      *
738      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
739      *
740      * Tokens start existing when they are minted (`_mint`),
741      * and stop existing when they are burned (`_burn`).
742      */
743     function _exists(uint256 tokenId) internal view virtual returns (bool) {
744         return _owners[tokenId] != address(0);
745     }
746 
747     /**
748      * @dev Returns whether `spender` is allowed to manage `tokenId`.
749      *
750      * Requirements:
751      *
752      * - `tokenId` must exist.
753      */
754     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
755         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
756         address owner = ERC721.ownerOf(tokenId);
757         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
758     }
759 
760     /**
761      * @dev Safely mints `tokenId` and transfers it to `to`.
762      *
763      * Requirements:
764      *
765      * - `tokenId` must not exist.
766      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
767      *
768      * Emits a {Transfer} event.
769      */
770     function _safeMint(address to, uint256 tokenId) internal virtual {
771         _safeMint(to, tokenId, "");
772     }
773 
774     /**
775      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
776      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
777      */
778     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
779         _mint(to, tokenId);
780         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
781     }
782 
783     /**
784      * @dev Mints `tokenId` and transfers it to `to`.
785      *
786      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
787      *
788      * Requirements:
789      *
790      * - `tokenId` must not exist.
791      * - `to` cannot be the zero address.
792      *
793      * Emits a {Transfer} event.
794      */
795     function _mint(address to, uint256 tokenId) internal virtual {
796         require(to != address(0), "ERC721: mint to the zero address");
797         require(!_exists(tokenId), "ERC721: token already minted");
798 
799         _beforeTokenTransfer(address(0), to, tokenId);
800 
801         _balances[to] += 1;
802         _owners[tokenId] = to;
803 
804         emit Transfer(address(0), to, tokenId);
805     }
806     
807 
808     /**
809      * @dev Destroys `tokenId`.
810      * The approval is cleared when the token is burned.
811      *
812      * Requirements:
813      *
814      * - `tokenId` must exist.
815      *
816      * Emits a {Transfer} event.
817      */
818     function _burn(uint256 tokenId) internal virtual {
819         address owner = ERC721.ownerOf(tokenId);
820 
821         _beforeTokenTransfer(owner, address(0), tokenId);
822 
823         // Clear approvals
824         _approve(address(0), tokenId);
825 
826         _balances[owner] -= 1;
827         delete _owners[tokenId];
828 
829         emit Transfer(owner, address(0), tokenId);
830     }
831 
832     /**
833      * @dev Transfers `tokenId` from `from` to `to`.
834      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
835      *
836      * Requirements:
837      *
838      * - `to` cannot be the zero address.
839      * - `tokenId` token must be owned by `from`.
840      *
841      * Emits a {Transfer} event.
842      */
843     function _transfer(address from, address to, uint256 tokenId) internal virtual {
844         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
845         require(to != address(0), "ERC721: transfer to the zero address");
846 
847         _beforeTokenTransfer(from, to, tokenId);
848 
849         // Clear approvals from the previous owner
850         _approve(address(0), tokenId);
851 
852         _balances[from] -= 1;
853         _balances[to] += 1;
854         _owners[tokenId] = to;
855 
856         emit Transfer(from, to, tokenId);
857     }
858 
859     /**
860      * @dev Approve `to` to operate on `tokenId`
861      *
862      * Emits a {Approval} event.
863      */
864     function _approve(address to, uint256 tokenId) internal virtual {
865         _tokenApprovals[tokenId] = to;
866         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
867     }
868 
869     /**
870      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
871      * The call is not executed if the target address is not a contract.
872      *
873      * @param from address representing the previous owner of the given token ID
874      * @param to target address that will receive the tokens
875      * @param tokenId uint256 ID of the token to be transferred
876      * @param _data bytes optional data to send along with the call
877      * @return bool whether the call correctly returned the expected magic value
878      */
879     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
880         private returns (bool)
881     {
882         if (to.isContract()) {
883             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
884                 return retval == IERC721Receiver(to).onERC721Received.selector;
885             } catch (bytes memory reason) {
886                 if (reason.length == 0) {
887                     revert("ERC721: transfer to non ERC721Receiver implementer");
888                 } else {
889                     // solhint-disable-next-line no-inline-assembly
890                     assembly {
891                         revert(add(32, reason), mload(reason))
892                     }
893                 }
894             }
895         } else {
896             return true;
897         }
898     }
899 
900     /**
901      * @dev Hook that is called before any token transfer. This includes minting
902      * and burning.
903      *
904      * Calling conditions:
905      *
906      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
907      * transferred to `to`.
908      * - When `from` is zero, `tokenId` will be minted for `to`.
909      * - When `to` is zero, ``from``'s `tokenId` will be burned.
910      * - `from` cannot be the zero address.
911      * - `to` cannot be the zero address.
912      *
913      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
914      */
915     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
916 }
917 
918 
919 pragma solidity ^0.8.0;
920 
921 /**
922  * @dev Contract module which provides a basic access control mechanism, where
923  * there is an account (an owner) that can be granted exclusive access to
924  * specific functions.
925  *
926  * By default, the owner account will be the one that deploys the contract. This
927  * can later be changed with {transferOwnership}.
928  *
929  * This module is used through inheritance. It will make available the modifier
930  * `onlyOwner`, which can be applied to your functions to restrict their use to
931  * the owner.
932  */
933 abstract contract Ownable is Context {
934     address private _owner;
935 
936     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
937 
938     /**
939      * @dev Initializes the contract setting the deployer as the initial owner.
940      */
941     constructor () {
942         address msgSender = _msgSender();
943         _owner = msgSender;
944         emit OwnershipTransferred(address(0), msgSender);
945     }
946 
947     /**
948      * @dev Returns the address of the current owner.
949      */
950     function owner() public view virtual returns (address) {
951         return _owner;
952     }
953 
954     /**
955      * @dev Throws if called by any account other than the owner.
956      */
957     modifier onlyOwner() {
958         require(owner() == _msgSender(), "Ownable: caller is not the owner");
959         _;
960     }
961 
962     /**
963      * @dev Leaves the contract without owner. It will not be possible to call
964      * `onlyOwner` functions anymore. Can only be called by the current owner.
965      *
966      * NOTE: Renouncing ownership will leave the contract without an owner,
967      * thereby removing any functionality that is only available to the owner.
968      */
969     function renounceOwnership() public virtual onlyOwner {
970         emit OwnershipTransferred(_owner, address(0));
971         _owner = address(0);
972     }
973 
974     /**
975      * @dev Transfers ownership of the contract to a new account (`newOwner`).
976      * Can only be called by the current owner.
977      */
978     function transferOwnership(address newOwner) public virtual onlyOwner {
979         require(newOwner != address(0), "Ownable: new owner is the zero address");
980         emit OwnershipTransferred(_owner, newOwner);
981         _owner = newOwner;
982     }
983 }
984 
985 pragma solidity ^0.8.0;
986 
987 
988 /**
989  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
990  * enumerability of all the token ids in the contract as well as all token ids owned by each
991  * account.
992  */
993 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
994     // Mapping from owner to list of owned token IDs
995     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
996 
997     // Mapping from token ID to index of the owner tokens list
998     mapping(uint256 => uint256) private _ownedTokensIndex;
999 
1000     // Array with all token ids, used for enumeration
1001     uint256[] private _allTokens;
1002 
1003     // Mapping from token id to position in the allTokens array
1004     mapping(uint256 => uint256) private _allTokensIndex;
1005 
1006     /**
1007      * @dev See {IERC165-supportsInterface}.
1008      */
1009     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1010         return interfaceId == type(IERC721Enumerable).interfaceId
1011             || super.supportsInterface(interfaceId);
1012     }
1013 
1014     /**
1015      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1016      */
1017     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1018         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1019         return _ownedTokens[owner][index];
1020     }
1021 
1022     /**
1023      * @dev See {IERC721Enumerable-totalSupply}.
1024      */
1025     function totalSupply() public view virtual override returns (uint256) {
1026         return _allTokens.length;
1027     }
1028 
1029     /**
1030      * @dev See {IERC721Enumerable-tokenByIndex}.
1031      */
1032     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1033         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1034         return _allTokens[index];
1035     }
1036 
1037     /**
1038      * @dev Hook that is called before any token transfer. This includes minting
1039      * and burning.
1040      *
1041      * Calling conditions:
1042      *
1043      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1044      * transferred to `to`.
1045      * - When `from` is zero, `tokenId` will be minted for `to`.
1046      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1047      * - `from` cannot be the zero address.
1048      * - `to` cannot be the zero address.
1049      *
1050      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1051      */
1052     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1053         super._beforeTokenTransfer(from, to, tokenId);
1054 
1055         if (from == address(0)) {
1056             _addTokenToAllTokensEnumeration(tokenId);
1057         } else if (from != to) {
1058             _removeTokenFromOwnerEnumeration(from, tokenId);
1059         }
1060         if (to == address(0)) {
1061             _removeTokenFromAllTokensEnumeration(tokenId);
1062         } else if (to != from) {
1063             _addTokenToOwnerEnumeration(to, tokenId);
1064         }
1065     }
1066 
1067     /**
1068      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1069      * @param to address representing the new owner of the given token ID
1070      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1071      */
1072     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1073         uint256 length = ERC721.balanceOf(to);
1074         _ownedTokens[to][length] = tokenId;
1075         _ownedTokensIndex[tokenId] = length;
1076     }
1077 
1078     /**
1079      * @dev Private function to add a token to this extension's token tracking data structures.
1080      * @param tokenId uint256 ID of the token to be added to the tokens list
1081      */
1082     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1083         _allTokensIndex[tokenId] = _allTokens.length;
1084         _allTokens.push(tokenId);
1085     }
1086 
1087     /**
1088      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1089      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1090      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1091      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1092      * @param from address representing the previous owner of the given token ID
1093      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1094      */
1095     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1096         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1097         // then delete the last slot (swap and pop).
1098 
1099         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1100         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1101 
1102         // When the token to delete is the last token, the swap operation is unnecessary
1103         if (tokenIndex != lastTokenIndex) {
1104             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1105 
1106             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1107             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1108         }
1109 
1110         // This also deletes the contents at the last position of the array
1111         delete _ownedTokensIndex[tokenId];
1112         delete _ownedTokens[from][lastTokenIndex];
1113     }
1114 
1115     /**
1116      * @dev Private function to remove a token from this extension's token tracking data structures.
1117      * This has O(1) time complexity, but alters the order of the _allTokens array.
1118      * @param tokenId uint256 ID of the token to be removed from the tokens list
1119      */
1120     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1121         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1122         // then delete the last slot (swap and pop).
1123 
1124         uint256 lastTokenIndex = _allTokens.length - 1;
1125         uint256 tokenIndex = _allTokensIndex[tokenId];
1126 
1127         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1128         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1129         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1130         uint256 lastTokenId = _allTokens[lastTokenIndex];
1131 
1132         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1133         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1134 
1135         // This also deletes the contents at the last position of the array
1136         delete _allTokensIndex[tokenId];
1137         _allTokens.pop();
1138     }
1139 }
1140 
1141 
1142 pragma solidity ^0.8.0;
1143 
1144 
1145 contract Donuts is ERC721Enumerable, Ownable {
1146 
1147     using Strings for uint256;
1148 
1149     string _baseTokenURI;
1150     uint256 private _reserved = 100;
1151     uint256 private _price = 0.04 ether;
1152     bool public _paused = true;
1153 
1154     address t1 = 0xc18b211b9411B6655CdfD55A4EAbC4D9D2D62291;
1155     address t2 = 0xa458B7374376B7d6AAB1d66a3ff4e0070F71DA0a;
1156     address t3 = 0x120f6521592154E710939f9D19f6C7B3fd29F9a0;
1157     address t4 = 0x09395ff0FC25F72DFca41a72E393A0f92D289c8F;
1158 
1159     constructor(string memory baseURI) ERC721("One Donuts", "ONEDONUTS")  {
1160         setBaseURI(baseURI);
1161         _safeMint( t1, 0);
1162         _safeMint( t2, 1);
1163         _safeMint( t3, 2);
1164         _safeMint( t4, 3);
1165     }
1166 
1167     function adopt(uint256 num) public payable {
1168         uint256 supply = totalSupply();
1169         require( !_paused,                              "Baking paused" );
1170         require( num < 21,                              "You can bake a maximum of 20 Donuts" );
1171         require( supply + num < 5000 - _reserved,      "Exceeds maximum Donuts supply" );
1172         require( msg.value >= _price * num,             "Ether sent is not correct" );
1173 
1174         for(uint256 i; i < num; i++){
1175             _safeMint( msg.sender, supply + i );
1176         }
1177     }
1178 
1179     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1180         uint256 tokenCount = balanceOf(_owner);
1181 
1182         uint256[] memory tokensId = new uint256[](tokenCount);
1183         for(uint256 i; i < tokenCount; i++){
1184             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1185         }
1186         return tokensId;
1187     }
1188 
1189     function setPrice(uint256 _newPrice) public onlyOwner() {
1190         _price = _newPrice;
1191     }
1192 
1193     function _baseURI() internal view virtual override returns (string memory) {
1194         return _baseTokenURI;
1195     }
1196 
1197     function setBaseURI(string memory baseURI) public onlyOwner {
1198         _baseTokenURI = baseURI;
1199     }
1200 
1201     function getPrice() public view returns (uint256){
1202         return _price;
1203     }
1204 
1205     function giveAway(address _to, uint256 _amount) external onlyOwner() {
1206         require( _amount <= _reserved, "Exceeds reserved Donuts supply" );
1207 
1208         uint256 supply = totalSupply();
1209         for(uint256 i; i < _amount; i++){
1210             _safeMint( _to, supply + i );
1211         }
1212 
1213         _reserved -= _amount;
1214     }
1215 
1216     function pause(bool val) public onlyOwner {
1217         _paused = val;
1218     }
1219 
1220     function withdrawAll() public payable onlyOwner {
1221         uint256 _each = address(this).balance / 4;
1222         require(payable(t1).send(_each));
1223         require(payable(t2).send(_each));
1224         require(payable(t3).send(_each));
1225         require(payable(t4).send(_each));
1226     }
1227 }