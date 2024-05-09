1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.1/contracts/utils/Strings.sol
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev String operations.
8  */
9 library Strings {
10     bytes16 private constant alphabet = "0123456789abcdef";
11 
12     /**
13      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
14      */
15     function toString(uint256 value) internal pure returns (string memory) {
16         // Inspired by OraclizeAPI's implementation - MIT licence
17         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
18 
19         if (value == 0) {
20             return "0";
21         }
22         uint256 temp = value;
23         uint256 digits;
24         while (temp != 0) {
25             digits++;
26             temp /= 10;
27         }
28         bytes memory buffer = new bytes(digits);
29         while (value != 0) {
30             digits -= 1;
31             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
32             value /= 10;
33         }
34         return string(buffer);
35     }
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
39      */
40     function toHexString(uint256 value) internal pure returns (string memory) {
41         if (value == 0) {
42             return "0x00";
43         }
44         uint256 temp = value;
45         uint256 length = 0;
46         while (temp != 0) {
47             length++;
48             temp >>= 8;
49         }
50         return toHexString(value, length);
51     }
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
55      */
56     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
57         bytes memory buffer = new bytes(2 * length + 2);
58         buffer[0] = "0";
59         buffer[1] = "x";
60         for (uint256 i = 2 * length + 1; i > 1; --i) {
61             buffer[i] = alphabet[value & 0xf];
62             value >>= 4;
63         }
64         require(value == 0, "Strings: hex length insufficient");
65         return string(buffer);
66     }
67 
68 }
69 
70 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.1/contracts/utils/Context.sol
71 
72 
73 
74 pragma solidity ^0.8.0;
75 
76 /*
77  * @dev Provides information about the current execution context, including the
78  * sender of the transaction and its data. While these are generally available
79  * via msg.sender and msg.data, they should not be accessed in such a direct
80  * manner, since when dealing with meta-transactions the account sending and
81  * paying for execution may not be the actual sender (as far as an application
82  * is concerned).
83  *
84  * This contract is only required for intermediate, library-like contracts.
85  */
86 abstract contract Context {
87     function _msgSender() internal view virtual returns (address) {
88         return msg.sender;
89     }
90 
91     function _msgData() internal view virtual returns (bytes calldata) {
92         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
93         return msg.data;
94     }
95 }
96 
97 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.1/contracts/utils/Address.sol
98 
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev Collection of functions related to the address type
104  */
105 library Address {
106     /**
107      * @dev Returns true if `account` is a contract.
108      *
109      * [IMPORTANT]
110      * ====
111      * It is unsafe to assume that an address for which this function returns
112      * false is an externally-owned account (EOA) and not a contract.
113      *
114      * Among others, `isContract` will return false for the following
115      * types of addresses:
116      *
117      *  - an externally-owned account
118      *  - a contract in construction
119      *  - an address where a contract will be created
120      *  - an address where a contract lived, but was destroyed
121      * ====
122      */
123     function isContract(address account) internal view returns (bool) {
124         // This method relies on extcodesize, which returns 0 for contracts in
125         // construction, since the code is only stored at the end of the
126         // constructor execution.
127 
128         uint256 size;
129         // solhint-disable-next-line no-inline-assembly
130         assembly { size := extcodesize(account) }
131         return size > 0;
132     }
133 
134     /**
135      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
136      * `recipient`, forwarding all available gas and reverting on errors.
137      *
138      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
139      * of certain opcodes, possibly making contracts go over the 2300 gas limit
140      * imposed by `transfer`, making them unable to receive funds via
141      * `transfer`. {sendValue} removes this limitation.
142      *
143      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
144      *
145      * IMPORTANT: because control is transferred to `recipient`, care must be
146      * taken to not create reentrancy vulnerabilities. Consider using
147      * {ReentrancyGuard} or the
148      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
149      */
150     function sendValue(address payable recipient, uint256 amount) internal {
151         require(address(this).balance >= amount, "Address: insufficient balance");
152 
153         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
154         (bool success, ) = recipient.call{ value: amount }("");
155         require(success, "Address: unable to send value, recipient may have reverted");
156     }
157 
158     /**
159      * @dev Performs a Solidity function call using a low level `call`. A
160      * plain`call` is an unsafe replacement for a function call: use this
161      * function instead.
162      *
163      * If `target` reverts with a revert reason, it is bubbled up by this
164      * function (like regular Solidity function calls).
165      *
166      * Returns the raw returned data. To convert to the expected return value,
167      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
168      *
169      * Requirements:
170      *
171      * - `target` must be a contract.
172      * - calling `target` with `data` must not revert.
173      *
174      * _Available since v3.1._
175      */
176     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
177       return functionCall(target, data, "Address: low-level call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
182      * `errorMessage` as a fallback revert reason when `target` reverts.
183      *
184      * _Available since v3.1._
185      */
186     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
187         return functionCallWithValue(target, data, 0, errorMessage);
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
192      * but also transferring `value` wei to `target`.
193      *
194      * Requirements:
195      *
196      * - the calling contract must have an ETH balance of at least `value`.
197      * - the called Solidity function must be `payable`.
198      *
199      * _Available since v3.1._
200      */
201     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
202         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
207      * with `errorMessage` as a fallback revert reason when `target` reverts.
208      *
209      * _Available since v3.1._
210      */
211     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
212         require(address(this).balance >= value, "Address: insufficient balance for call");
213         require(isContract(target), "Address: call to non-contract");
214 
215         // solhint-disable-next-line avoid-low-level-calls
216         (bool success, bytes memory returndata) = target.call{ value: value }(data);
217         return _verifyCallResult(success, returndata, errorMessage);
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
222      * but performing a static call.
223      *
224      * _Available since v3.3._
225      */
226     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
227         return functionStaticCall(target, data, "Address: low-level static call failed");
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
232      * but performing a static call.
233      *
234      * _Available since v3.3._
235      */
236     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
237         require(isContract(target), "Address: static call to non-contract");
238 
239         // solhint-disable-next-line avoid-low-level-calls
240         (bool success, bytes memory returndata) = target.staticcall(data);
241         return _verifyCallResult(success, returndata, errorMessage);
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
246      * but performing a delegate call.
247      *
248      * _Available since v3.4._
249      */
250     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
251         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
256      * but performing a delegate call.
257      *
258      * _Available since v3.4._
259      */
260     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
261         require(isContract(target), "Address: delegate call to non-contract");
262 
263         // solhint-disable-next-line avoid-low-level-calls
264         (bool success, bytes memory returndata) = target.delegatecall(data);
265         return _verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
269         if (success) {
270             return returndata;
271         } else {
272             // Look for revert reason and bubble it up if present
273             if (returndata.length > 0) {
274                 // The easiest way to bubble the revert reason is using memory via assembly
275 
276                 // solhint-disable-next-line no-inline-assembly
277                 assembly {
278                     let returndata_size := mload(returndata)
279                     revert(add(32, returndata), returndata_size)
280                 }
281             } else {
282                 revert(errorMessage);
283             }
284         }
285     }
286 }
287 
288 
289 
290 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.1/contracts/token/ERC721/IERC721Receiver.sol
291 
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @title ERC721 token receiver interface
297  * @dev Interface for any contract that wants to support safeTransfers
298  * from ERC721 asset contracts.
299  */
300 interface IERC721Receiver {
301     /**
302      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
303      * by `operator` from `from`, this function is called.
304      *
305      * It must return its Solidity selector to confirm the token transfer.
306      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
307      *
308      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
309      */
310     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
311 }
312 
313 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.1/contracts/utils/introspection/IERC165.sol
314 
315 
316 pragma solidity ^0.8.0;
317 
318 /**
319  * @dev Interface of the ERC165 standard, as defined in the
320  * https://eips.ethereum.org/EIPS/eip-165[EIP].
321  *
322  * Implementers can declare support of contract interfaces, which can then be
323  * queried by others ({ERC165Checker}).
324  *
325  * For an implementation, see {ERC165}.
326  */
327 interface IERC165 {
328     /**
329      * @dev Returns true if this contract implements the interface defined by
330      * `interfaceId`. See the corresponding
331      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
332      * to learn more about how these ids are created.
333      *
334      * This function call must use less than 30 000 gas.
335      */
336     function supportsInterface(bytes4 interfaceId) external view returns (bool);
337 }
338 
339 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.1/contracts/utils/introspection/ERC165.sol
340 
341 pragma solidity ^0.8.0;
342 
343 
344 /**
345  * @dev Implementation of the {IERC165} interface.
346  *
347  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
348  * for the additional interface id that will be supported. For example:
349  *
350  * ```solidity
351  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
352  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
353  * }
354  * ```
355  *
356  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
357  */
358 abstract contract ERC165 is IERC165 {
359     /**
360      * @dev See {IERC165-supportsInterface}.
361      */
362     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
363         return interfaceId == type(IERC165).interfaceId;
364     }
365 }
366 
367 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.1/contracts/token/ERC721/IERC721.sol
368 
369 
370 pragma solidity ^0.8.0;
371 
372 
373 /**
374  * @dev Required interface of an ERC721 compliant contract.
375  */
376 interface IERC721 is IERC165 {
377     /**
378      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
379      */
380     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
381 
382     /**
383      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
384      */
385     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
386 
387     /**
388      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
389      */
390     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
391 
392     /**
393      * @dev Returns the number of tokens in ``owner``'s account.
394      */
395     function balanceOf(address owner) external view returns (uint256 balance);
396 
397     /**
398      * @dev Returns the owner of the `tokenId` token.
399      *
400      * Requirements:
401      *
402      * - `tokenId` must exist.
403      */
404     function ownerOf(uint256 tokenId) external view returns (address owner);
405 
406     /**
407      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
408      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
409      *
410      * Requirements:
411      *
412      * - `from` cannot be the zero address.
413      * - `to` cannot be the zero address.
414      * - `tokenId` token must exist and be owned by `from`.
415      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
416      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
417      *
418      * Emits a {Transfer} event.
419      */
420     function safeTransferFrom(address from, address to, uint256 tokenId) external;
421 
422     /**
423      * @dev Transfers `tokenId` token from `from` to `to`.
424      *
425      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
426      *
427      * Requirements:
428      *
429      * - `from` cannot be the zero address.
430      * - `to` cannot be the zero address.
431      * - `tokenId` token must be owned by `from`.
432      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
433      *
434      * Emits a {Transfer} event.
435      */
436     function transferFrom(address from, address to, uint256 tokenId) external;
437 
438     /**
439      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
440      * The approval is cleared when the token is transferred.
441      *
442      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
443      *
444      * Requirements:
445      *
446      * - The caller must own the token or be an approved operator.
447      * - `tokenId` must exist.
448      *
449      * Emits an {Approval} event.
450      */
451     function approve(address to, uint256 tokenId) external;
452 
453     /**
454      * @dev Returns the account approved for `tokenId` token.
455      *
456      * Requirements:
457      *
458      * - `tokenId` must exist.
459      */
460     function getApproved(uint256 tokenId) external view returns (address operator);
461 
462     /**
463      * @dev Approve or remove `operator` as an operator for the caller.
464      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
465      *
466      * Requirements:
467      *
468      * - The `operator` cannot be the caller.
469      *
470      * Emits an {ApprovalForAll} event.
471      */
472     function setApprovalForAll(address operator, bool _approved) external;
473 
474     /**
475      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
476      *
477      * See {setApprovalForAll}
478      */
479     function isApprovedForAll(address owner, address operator) external view returns (bool);
480 
481     /**
482       * @dev Safely transfers `tokenId` token from `from` to `to`.
483       *
484       * Requirements:
485       *
486       * - `from` cannot be the zero address.
487       * - `to` cannot be the zero address.
488       * - `tokenId` token must exist and be owned by `from`.
489       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
490       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
491       *
492       * Emits a {Transfer} event.
493       */
494     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
495 }
496 
497 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.1/contracts/token/ERC721/extensions/IERC721Metadata.sol
498 
499 
500 pragma solidity ^0.8.0;
501 
502 
503 /**
504  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
505  * @dev See https://eips.ethereum.org/EIPS/eip-721
506  */
507 interface IERC721Metadata is IERC721 {
508 
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
525 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.1/contracts/token/ERC721/ERC721.sol
526 
527 
528 pragma solidity ^0.8.0;
529 
530 
531 
532 
533 
534 
535 
536 
537 /**
538  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
539  * the Metadata extension, but not including the Enumerable extension, which is available separately as
540  * {ERC721Enumerable}.
541  */
542 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
543     using Address for address;
544     using Strings for uint256;
545 
546     // Token name
547     string private _name;
548 
549     // Token symbol
550     string private _symbol;
551 
552     // Mapping from token ID to owner address
553     mapping (uint256 => address) private _owners;
554 
555     // Mapping owner address to token count
556     mapping (address => uint256) private _balances;
557 
558     // Mapping from token ID to approved address
559     mapping (uint256 => address) private _tokenApprovals;
560 
561     // Mapping from owner to operator approvals
562     mapping (address => mapping (address => bool)) private _operatorApprovals;
563 
564     /**
565      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
566      */
567     constructor (string memory name_, string memory symbol_) {
568         _name = name_;
569         _symbol = symbol_;
570     }
571 
572     /**
573      * @dev See {IERC165-supportsInterface}.
574      */
575     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
576         return interfaceId == type(IERC721).interfaceId
577             || interfaceId == type(IERC721Metadata).interfaceId
578             || super.supportsInterface(interfaceId);
579     }
580 
581     /**
582      * @dev See {IERC721-balanceOf}.
583      */
584     function balanceOf(address owner) public view virtual override returns (uint256) {
585         require(owner != address(0), "ERC721: balance query for the zero address");
586         return _balances[owner];
587     }
588 
589     /**
590      * @dev See {IERC721-ownerOf}.
591      */
592     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
593         address owner = _owners[tokenId];
594         require(owner != address(0), "ERC721: owner query for nonexistent token");
595         return owner;
596     }
597 
598     /**
599      * @dev See {IERC721Metadata-name}.
600      */
601     function name() public view virtual override returns (string memory) {
602         return _name;
603     }
604 
605     /**
606      * @dev See {IERC721Metadata-symbol}.
607      */
608     function symbol() public view virtual override returns (string memory) {
609         return _symbol;
610     }
611 
612     /**
613      * @dev See {IERC721Metadata-tokenURI}.
614      */
615     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
616         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
617 
618         string memory baseURI = _baseURI();
619         return bytes(baseURI).length > 0
620             ? string(abi.encodePacked(baseURI, tokenId.toString()))
621             : '';
622     }
623 
624     /**
625      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
626      * in child contracts.
627      */
628     function _baseURI() internal view virtual returns (string memory) {
629         return "";
630     }
631 
632     /**
633      * @dev See {IERC721-approve}.
634      */
635     function approve(address to, uint256 tokenId) public virtual override {
636         address owner = ERC721.ownerOf(tokenId);
637         require(to != owner, "ERC721: approval to current owner");
638 
639         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
640             "ERC721: approve caller is not owner nor approved for all"
641         );
642 
643         _approve(to, tokenId);
644     }
645 
646     /**
647      * @dev See {IERC721-getApproved}.
648      */
649     function getApproved(uint256 tokenId) public view virtual override returns (address) {
650         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
651 
652         return _tokenApprovals[tokenId];
653     }
654 
655     /**
656      * @dev See {IERC721-setApprovalForAll}.
657      */
658     function setApprovalForAll(address operator, bool approved) public virtual override {
659         require(operator != _msgSender(), "ERC721: approve to caller");
660 
661         _operatorApprovals[_msgSender()][operator] = approved;
662         emit ApprovalForAll(_msgSender(), operator, approved);
663     }
664 
665     /**
666      * @dev See {IERC721-isApprovedForAll}.
667      */
668     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
669         return _operatorApprovals[owner][operator];
670     }
671 
672     /**
673      * @dev See {IERC721-transferFrom}.
674      */
675     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
676         //solhint-disable-next-line max-line-length
677         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
678 
679         _transfer(from, to, tokenId);
680     }
681 
682     /**
683      * @dev See {IERC721-safeTransferFrom}.
684      */
685     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
686         safeTransferFrom(from, to, tokenId, "");
687     }
688 
689     /**
690      * @dev See {IERC721-safeTransferFrom}.
691      */
692     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
693         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
694         _safeTransfer(from, to, tokenId, _data);
695     }
696 
697     /**
698      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
699      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
700      *
701      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
702      *
703      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
704      * implement alternative mechanisms to perform token transfer, such as signature-based.
705      *
706      * Requirements:
707      *
708      * - `from` cannot be the zero address.
709      * - `to` cannot be the zero address.
710      * - `tokenId` token must exist and be owned by `from`.
711      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
712      *
713      * Emits a {Transfer} event.
714      */
715     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
716         _transfer(from, to, tokenId);
717         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
718     }
719 
720     /**
721      * @dev Returns whether `tokenId` exists.
722      *
723      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
724      *
725      * Tokens start existing when they are minted (`_mint`),
726      * and stop existing when they are burned (`_burn`).
727      */
728     function _exists(uint256 tokenId) internal view virtual returns (bool) {
729         return _owners[tokenId] != address(0);
730     }
731 
732     /**
733      * @dev Returns whether `spender` is allowed to manage `tokenId`.
734      *
735      * Requirements:
736      *
737      * - `tokenId` must exist.
738      */
739     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
740         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
741         address owner = ERC721.ownerOf(tokenId);
742         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
743     }
744 
745     /**
746      * @dev Safely mints `tokenId` and transfers it to `to`.
747      *
748      * Requirements:
749      *
750      * - `tokenId` must not exist.
751      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
752      *
753      * Emits a {Transfer} event.
754      */
755     function _safeMint(address to, uint256 tokenId) internal virtual {
756         _safeMint(to, tokenId, "");
757     }
758 
759     /**
760      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
761      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
762      */
763     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
764         _mint(to, tokenId);
765         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
766     }
767 
768     /**
769      * @dev Mints `tokenId` and transfers it to `to`.
770      *
771      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
772      *
773      * Requirements:
774      *
775      * - `tokenId` must not exist.
776      * - `to` cannot be the zero address.
777      *
778      * Emits a {Transfer} event.
779      */
780     function _mint(address to, uint256 tokenId) internal virtual {
781         require(to != address(0), "ERC721: mint to the zero address");
782         require(!_exists(tokenId), "ERC721: token already minted");
783 
784         _beforeTokenTransfer(address(0), to, tokenId);
785 
786         _balances[to] += 1;
787         _owners[tokenId] = to;
788 
789         emit Transfer(address(0), to, tokenId);
790     }
791 
792     /**
793      * @dev Destroys `tokenId`.
794      * The approval is cleared when the token is burned.
795      *
796      * Requirements:
797      *
798      * - `tokenId` must exist.
799      *
800      * Emits a {Transfer} event.
801      */
802     function _burn(uint256 tokenId) internal virtual {
803         address owner = ERC721.ownerOf(tokenId);
804 
805         _beforeTokenTransfer(owner, address(0), tokenId);
806 
807         // Clear approvals
808         _approve(address(0), tokenId);
809 
810         _balances[owner] -= 1;
811         delete _owners[tokenId];
812 
813         emit Transfer(owner, address(0), tokenId);
814     }
815 
816     /**
817      * @dev Transfers `tokenId` from `from` to `to`.
818      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
819      *
820      * Requirements:
821      *
822      * - `to` cannot be the zero address.
823      * - `tokenId` token must be owned by `from`.
824      *
825      * Emits a {Transfer} event.
826      */
827     function _transfer(address from, address to, uint256 tokenId) internal virtual {
828         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
829         require(to != address(0), "ERC721: transfer to the zero address");
830 
831         _beforeTokenTransfer(from, to, tokenId);
832 
833         // Clear approvals from the previous owner
834         _approve(address(0), tokenId);
835 
836         _balances[from] -= 1;
837         _balances[to] += 1;
838         _owners[tokenId] = to;
839 
840         emit Transfer(from, to, tokenId);
841     }
842 
843     /**
844      * @dev Approve `to` to operate on `tokenId`
845      *
846      * Emits a {Approval} event.
847      */
848     function _approve(address to, uint256 tokenId) internal virtual {
849         _tokenApprovals[tokenId] = to;
850         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
851     }
852 
853     /**
854      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
855      * The call is not executed if the target address is not a contract.
856      *
857      * @param from address representing the previous owner of the given token ID
858      * @param to target address that will receive the tokens
859      * @param tokenId uint256 ID of the token to be transferred
860      * @param _data bytes optional data to send along with the call
861      * @return bool whether the call correctly returned the expected magic value
862      */
863     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
864         private returns (bool)
865     {
866         if (to.isContract()) {
867             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
868                 return retval == IERC721Receiver(to).onERC721Received.selector;
869             } catch (bytes memory reason) {
870                 if (reason.length == 0) {
871                     revert("ERC721: transfer to non ERC721Receiver implementer");
872                 } else {
873                     // solhint-disable-next-line no-inline-assembly
874                     assembly {
875                         revert(add(32, reason), mload(reason))
876                     }
877                 }
878             }
879         } else {
880             return true;
881         }
882     }
883 
884     /**
885      * @dev Hook that is called before any token transfer. This includes minting
886      * and burning.
887      *
888      * Calling conditions:
889      *
890      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
891      * transferred to `to`.
892      * - When `from` is zero, `tokenId` will be minted for `to`.
893      * - When `to` is zero, ``from``'s `tokenId` will be burned.
894      * - `from` cannot be the zero address.
895      * - `to` cannot be the zero address.
896      *
897      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
898      */
899     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
900 }
901 
902 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.1/contracts/token/ERC721/extensions/ERC721URIStorage.sol
903 
904 
905 pragma solidity ^0.8.0;
906 
907 
908 /**
909  * @dev ERC721 token with storage based token URI management.
910  */
911 abstract contract ERC721URIStorage is ERC721 {
912     using Strings for uint256;
913 
914     // Optional mapping for token URIs
915     mapping (uint256 => string) private _tokenURIs;
916 
917     /**
918      * @dev See {IERC721Metadata-tokenURI}.
919      */
920     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
921         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
922 
923         string memory _tokenURI = _tokenURIs[tokenId];
924         string memory base = _baseURI();
925 
926         // If there is no base URI, return the token URI.
927         if (bytes(base).length == 0) {
928             return _tokenURI;
929         }
930         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
931         if (bytes(_tokenURI).length > 0) {
932             return string(abi.encodePacked(base, _tokenURI));
933         }
934 
935         return super.tokenURI(tokenId);
936     }
937 
938     /**
939      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
940      *
941      * Requirements:
942      *
943      * - `tokenId` must exist.
944      */
945     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
946         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
947         _tokenURIs[tokenId] = _tokenURI;
948     }
949 
950     /**
951      * @dev Destroys `tokenId`.
952      * The approval is cleared when the token is burned.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must exist.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _burn(uint256 tokenId) internal virtual override {
961         super._burn(tokenId);
962 
963         if (bytes(_tokenURIs[tokenId]).length != 0) {
964             delete _tokenURIs[tokenId];
965         }
966     }
967 }
968 
969 // File: contracts/Wsot.sol
970 
971 // contracts/Wsot.sol
972 pragma solidity ^0.8.0;
973 
974 
975 contract Wsot is ERC721URIStorage {
976     address owner;
977 
978     constructor() ERC721('WSOT','WSOTNFT') {
979         owner = msg.sender;
980     }
981 
982     function awardItem(address player, string memory tokenURI,uint256 newItemId )
983         public
984         returns (uint256)
985     {
986         
987         if (msg.sender != owner) return 0;
988         _safeMint(player, newItemId);
989         _setTokenURI(newItemId, tokenURI);
990 
991         return newItemId;
992     }
993 }