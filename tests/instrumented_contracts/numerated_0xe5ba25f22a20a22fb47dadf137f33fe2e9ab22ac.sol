1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 
27 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Interface of the ERC165 standard, as defined in the
33  * https://eips.ethereum.org/EIPS/eip-165[EIP].
34  *
35  * Implementers can declare support of contract interfaces, which can then be
36  * queried by others ({ERC165Checker}).
37  *
38  * For an implementation, see {ERC165}.
39  */
40 interface IERC165 {
41     /**
42      * @dev Returns true if this contract implements the interface defined by
43      * `interfaceId`. See the corresponding
44      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
45      * to learn more about how these ids are created.
46      *
47      * This function call must use less than 30 000 gas.
48      */
49     function supportsInterface(bytes4 interfaceId) external view returns (bool);
50 }
51 
52 
53 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
54 
55 pragma solidity ^0.8.0;
56 
57 /**
58  * @dev Implementation of the {IERC165} interface.
59  *
60  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
61  * for the additional interface id that will be supported. For example:
62  *
63  * ```solidity
64  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
65  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
66  * }
67  * ```
68  *
69  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
70  */
71 abstract contract ERC165 is IERC165 {
72     /**
73      * @dev See {IERC165-supportsInterface}.
74      */
75     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
76         return interfaceId == type(IERC165).interfaceId;
77     }
78 }
79 
80 
81 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
82 
83 pragma solidity ^0.8.0;
84 
85 /**
86  * @dev Required interface of an ERC721 compliant contract.
87  */
88 interface IERC721 is IERC165 {
89     /**
90      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
91      */
92     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
93 
94     /**
95      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
96      */
97     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
98 
99     /**
100      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
101      */
102     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
103 
104     /**
105      * @dev Returns the number of tokens in ``owner``'s account.
106      */
107     function balanceOf(address owner) external view returns (uint256 balance);
108 
109     /**
110      * @dev Returns the owner of the `tokenId` token.
111      *
112      * Requirements:
113      *
114      * - `tokenId` must exist.
115      */
116     function ownerOf(uint256 tokenId) external view returns (address owner);
117 
118     /**
119      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
120      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
121      *
122      * Requirements:
123      *
124      * - `from` cannot be the zero address.
125      * - `to` cannot be the zero address.
126      * - `tokenId` token must exist and be owned by `from`.
127      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
128      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
129      *
130      * Emits a {Transfer} event.
131      */
132     function safeTransferFrom(
133         address from,
134         address to,
135         uint256 tokenId
136     ) external;
137 
138     /**
139      * @dev Transfers `tokenId` token from `from` to `to`.
140      *
141      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
142      *
143      * Requirements:
144      *
145      * - `from` cannot be the zero address.
146      * - `to` cannot be the zero address.
147      * - `tokenId` token must be owned by `from`.
148      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
149      *
150      * Emits a {Transfer} event.
151      */
152     function transferFrom(
153         address from,
154         address to,
155         uint256 tokenId
156     ) external;
157 
158     /**
159      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
160      * The approval is cleared when the token is transferred.
161      *
162      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
163      *
164      * Requirements:
165      *
166      * - The caller must own the token or be an approved operator.
167      * - `tokenId` must exist.
168      *
169      * Emits an {Approval} event.
170      */
171     function approve(address to, uint256 tokenId) external;
172 
173     /**
174      * @dev Returns the account approved for `tokenId` token.
175      *
176      * Requirements:
177      *
178      * - `tokenId` must exist.
179      */
180     function getApproved(uint256 tokenId) external view returns (address operator);
181 
182     /**
183      * @dev Approve or remove `operator` as an operator for the caller.
184      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
185      *
186      * Requirements:
187      *
188      * - The `operator` cannot be the caller.
189      *
190      * Emits an {ApprovalForAll} event.
191      */
192     function setApprovalForAll(address operator, bool _approved) external;
193 
194     /**
195      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
196      *
197      * See {setApprovalForAll}
198      */
199     function isApprovedForAll(address owner, address operator) external view returns (bool);
200 
201     /**
202      * @dev Safely transfers `tokenId` token from `from` to `to`.
203      *
204      * Requirements:
205      *
206      * - `from` cannot be the zero address.
207      * - `to` cannot be the zero address.
208      * - `tokenId` token must exist and be owned by `from`.
209      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
210      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
211      *
212      * Emits a {Transfer} event.
213      */
214     function safeTransferFrom(
215         address from,
216         address to,
217         uint256 tokenId,
218         bytes calldata data
219     ) external;
220 }
221 
222 
223 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
229  * @dev See https://eips.ethereum.org/EIPS/eip-721
230  */
231 interface IERC721Metadata is IERC721 {
232     /**
233      * @dev Returns the token collection name.
234      */
235     function name() external view returns (string memory);
236 
237     /**
238      * @dev Returns the token collection symbol.
239      */
240     function symbol() external view returns (string memory);
241 
242     /**
243      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
244      */
245     function tokenURI(uint256 tokenId) external view returns (string memory);
246 }
247 
248 
249 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
250 
251 pragma solidity ^0.8.0;
252 
253 /**
254  * @title ERC721 token receiver interface
255  * @dev Interface for any contract that wants to support safeTransfers
256  * from ERC721 asset contracts.
257  */
258 interface IERC721Receiver {
259     /**
260      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
261      * by `operator` from `from`, this function is called.
262      *
263      * It must return its Solidity selector to confirm the token transfer.
264      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
265      *
266      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
267      */
268     function onERC721Received(
269         address operator,
270         address from,
271         uint256 tokenId,
272         bytes calldata data
273     ) external returns (bytes4);
274 }
275 
276 
277 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
278 
279 pragma solidity ^0.8.0;
280 
281 /**
282  * @dev Collection of functions related to the address type
283  */
284 library Address {
285     /**
286      * @dev Returns true if `account` is a contract.
287      *
288      * [IMPORTANT]
289      * ====
290      * It is unsafe to assume that an address for which this function returns
291      * false is an externally-owned account (EOA) and not a contract.
292      *
293      * Among others, `isContract` will return false for the following
294      * types of addresses:
295      *
296      *  - an externally-owned account
297      *  - a contract in construction
298      *  - an address where a contract will be created
299      *  - an address where a contract lived, but was destroyed
300      * ====
301      */
302     function isContract(address account) internal view returns (bool) {
303         // This method relies on extcodesize, which returns 0 for contracts in
304         // construction, since the code is only stored at the end of the
305         // constructor execution.
306 
307         uint256 size;
308         assembly {
309             size := extcodesize(account)
310         }
311         return size > 0;
312     }
313 
314     /**
315      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
316      * `recipient`, forwarding all available gas and reverting on errors.
317      *
318      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
319      * of certain opcodes, possibly making contracts go over the 2300 gas limit
320      * imposed by `transfer`, making them unable to receive funds via
321      * `transfer`. {sendValue} removes this limitation.
322      *
323      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
324      *
325      * IMPORTANT: because control is transferred to `recipient`, care must be
326      * taken to not create reentrancy vulnerabilities. Consider using
327      * {ReentrancyGuard} or the
328      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
329      */
330     function sendValue(address payable recipient, uint256 amount) internal {
331         require(address(this).balance >= amount, "Address: insufficient balance");
332 
333         (bool success, ) = recipient.call{value: amount}("");
334         require(success, "Address: unable to send value, recipient may have reverted");
335     }
336 
337     /**
338      * @dev Performs a Solidity function call using a low level `call`. A
339      * plain `call` is an unsafe replacement for a function call: use this
340      * function instead.
341      *
342      * If `target` reverts with a revert reason, it is bubbled up by this
343      * function (like regular Solidity function calls).
344      *
345      * Returns the raw returned data. To convert to the expected return value,
346      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
347      *
348      * Requirements:
349      *
350      * - `target` must be a contract.
351      * - calling `target` with `data` must not revert.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
356         return functionCall(target, data, "Address: low-level call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
361      * `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, 0, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but also transferring `value` wei to `target`.
376      *
377      * Requirements:
378      *
379      * - the calling contract must have an ETH balance of at least `value`.
380      * - the called Solidity function must be `payable`.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value
388     ) internal returns (bytes memory) {
389         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
394      * with `errorMessage` as a fallback revert reason when `target` reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(
399         address target,
400         bytes memory data,
401         uint256 value,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         require(address(this).balance >= value, "Address: insufficient balance for call");
405         require(isContract(target), "Address: call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.call{value: value}(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but performing a static call.
414      *
415      * _Available since v3.3._
416      */
417     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
418         return functionStaticCall(target, data, "Address: low-level static call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
423      * but performing a static call.
424      *
425      * _Available since v3.3._
426      */
427     function functionStaticCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal view returns (bytes memory) {
432         require(isContract(target), "Address: static call to non-contract");
433 
434         (bool success, bytes memory returndata) = target.staticcall(data);
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440      * but performing a delegate call.
441      *
442      * _Available since v3.4._
443      */
444     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
445         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
450      * but performing a delegate call.
451      *
452      * _Available since v3.4._
453      */
454     function functionDelegateCall(
455         address target,
456         bytes memory data,
457         string memory errorMessage
458     ) internal returns (bytes memory) {
459         require(isContract(target), "Address: delegate call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.delegatecall(data);
462         return verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
467      * revert reason using the provided one.
468      *
469      * _Available since v4.3._
470      */
471     function verifyCallResult(
472         bool success,
473         bytes memory returndata,
474         string memory errorMessage
475     ) internal pure returns (bytes memory) {
476         if (success) {
477             return returndata;
478         } else {
479             // Look for revert reason and bubble it up if present
480             if (returndata.length > 0) {
481                 // The easiest way to bubble the revert reason is using memory via assembly
482 
483                 assembly {
484                     let returndata_size := mload(returndata)
485                     revert(add(32, returndata), returndata_size)
486                 }
487             } else {
488                 revert(errorMessage);
489             }
490         }
491     }
492 }
493 
494 
495 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 /**
500  * @dev String operations.
501  */
502 library Strings {
503     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
504 
505     /**
506      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
507      */
508     function toString(uint256 value) internal pure returns (string memory) {
509         // Inspired by OraclizeAPI's implementation - MIT licence
510         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
511 
512         if (value == 0) {
513             return "0";
514         }
515         uint256 temp = value;
516         uint256 digits;
517         while (temp != 0) {
518             digits++;
519             temp /= 10;
520         }
521         bytes memory buffer = new bytes(digits);
522         while (value != 0) {
523             digits -= 1;
524             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
525             value /= 10;
526         }
527         return string(buffer);
528     }
529 
530     /**
531      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
532      */
533     function toHexString(uint256 value) internal pure returns (string memory) {
534         if (value == 0) {
535             return "0x00";
536         }
537         uint256 temp = value;
538         uint256 length = 0;
539         while (temp != 0) {
540             length++;
541             temp >>= 8;
542         }
543         return toHexString(value, length);
544     }
545 
546     /**
547      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
548      */
549     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
550         bytes memory buffer = new bytes(2 * length + 2);
551         buffer[0] = "0";
552         buffer[1] = "x";
553         for (uint256 i = 2 * length + 1; i > 1; --i) {
554             buffer[i] = _HEX_SYMBOLS[value & 0xf];
555             value >>= 4;
556         }
557         require(value == 0, "Strings: hex length insufficient");
558         return string(buffer);
559     }
560 }
561 
562 
563 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 /**
568  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
569  * the Metadata extension, but not including the Enumerable extension, which is available separately as
570  * {ERC721Enumerable}.
571  */
572 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
573     using Address for address;
574     using Strings for uint256;
575 
576     // Token name
577     string private _name;
578 
579     // Token symbol
580     string private _symbol;
581 
582     // Mapping from token ID to owner address
583     mapping(uint256 => address) private _owners;
584 
585     // Mapping owner address to token count
586     mapping(address => uint256) private _balances;
587 
588     // Mapping from token ID to approved address
589     mapping(uint256 => address) private _tokenApprovals;
590 
591     // Mapping from owner to operator approvals
592     mapping(address => mapping(address => bool)) private _operatorApprovals;
593 
594     /**
595      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
596      */
597     constructor(string memory name_, string memory symbol_) {
598         _name = name_;
599         _symbol = symbol_;
600     }
601 
602     /**
603      * @dev See {IERC165-supportsInterface}.
604      */
605     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
606         return
607             interfaceId == type(IERC721).interfaceId ||
608             interfaceId == type(IERC721Metadata).interfaceId ||
609             super.supportsInterface(interfaceId);
610     }
611 
612     /**
613      * @dev See {IERC721-balanceOf}.
614      */
615     function balanceOf(address owner) public view virtual override returns (uint256) {
616         require(owner != address(0), "ERC721: balance query for the zero address");
617         return _balances[owner];
618     }
619 
620     /**
621      * @dev See {IERC721-ownerOf}.
622      */
623     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
624         address owner = _owners[tokenId];
625         require(owner != address(0), "ERC721: owner query for nonexistent token");
626         return owner;
627     }
628 
629     /**
630      * @dev See {IERC721Metadata-name}.
631      */
632     function name() public view virtual override returns (string memory) {
633         return _name;
634     }
635 
636     /**
637      * @dev See {IERC721Metadata-symbol}.
638      */
639     function symbol() public view virtual override returns (string memory) {
640         return _symbol;
641     }
642 
643     /**
644      * @dev See {IERC721Metadata-tokenURI}.
645      */
646     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
647         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
648 
649         string memory baseURI = _baseURI();
650         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
651     }
652 
653     /**
654      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
655      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
656      * by default, can be overriden in child contracts.
657      */
658     function _baseURI() internal view virtual returns (string memory) {
659         return "";
660     }
661 
662     /**
663      * @dev See {IERC721-approve}.
664      */
665     function approve(address to, uint256 tokenId) public virtual override {
666         address owner = ERC721.ownerOf(tokenId);
667         require(to != owner, "ERC721: approval to current owner");
668 
669         require(
670             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
671             "ERC721: approve caller is not owner nor approved for all"
672         );
673 
674         _approve(to, tokenId);
675     }
676 
677     /**
678      * @dev See {IERC721-getApproved}.
679      */
680     function getApproved(uint256 tokenId) public view virtual override returns (address) {
681         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
682 
683         return _tokenApprovals[tokenId];
684     }
685 
686     /**
687      * @dev See {IERC721-setApprovalForAll}.
688      */
689     function setApprovalForAll(address operator, bool approved) public virtual override {
690         _setApprovalForAll(_msgSender(), operator, approved);
691     }
692 
693     /**
694      * @dev See {IERC721-isApprovedForAll}.
695      */
696     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
697         return _operatorApprovals[owner][operator];
698     }
699 
700     /**
701      * @dev See {IERC721-transferFrom}.
702      */
703     function transferFrom(
704         address from,
705         address to,
706         uint256 tokenId
707     ) public virtual override {
708         //solhint-disable-next-line max-line-length
709         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
710 
711         _transfer(from, to, tokenId);
712     }
713 
714     /**
715      * @dev See {IERC721-safeTransferFrom}.
716      */
717     function safeTransferFrom(
718         address from,
719         address to,
720         uint256 tokenId
721     ) public virtual override {
722         safeTransferFrom(from, to, tokenId, "");
723     }
724 
725     /**
726      * @dev See {IERC721-safeTransferFrom}.
727      */
728     function safeTransferFrom(
729         address from,
730         address to,
731         uint256 tokenId,
732         bytes memory _data
733     ) public virtual override {
734         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
735         _safeTransfer(from, to, tokenId, _data);
736     }
737 
738     /**
739      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
740      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
741      *
742      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
743      *
744      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
745      * implement alternative mechanisms to perform token transfer, such as signature-based.
746      *
747      * Requirements:
748      *
749      * - `from` cannot be the zero address.
750      * - `to` cannot be the zero address.
751      * - `tokenId` token must exist and be owned by `from`.
752      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
753      *
754      * Emits a {Transfer} event.
755      */
756     function _safeTransfer(
757         address from,
758         address to,
759         uint256 tokenId,
760         bytes memory _data
761     ) internal virtual {
762         _transfer(from, to, tokenId);
763         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
764     }
765 
766     /**
767      * @dev Returns whether `tokenId` exists.
768      *
769      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
770      *
771      * Tokens start existing when they are minted (`_mint`),
772      * and stop existing when they are burned (`_burn`).
773      */
774     function _exists(uint256 tokenId) internal view virtual returns (bool) {
775         return _owners[tokenId] != address(0);
776     }
777 
778     /**
779      * @dev Returns whether `spender` is allowed to manage `tokenId`.
780      *
781      * Requirements:
782      *
783      * - `tokenId` must exist.
784      */
785     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
786         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
787         address owner = ERC721.ownerOf(tokenId);
788         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
789     }
790 
791     /**
792      * @dev Safely mints `tokenId` and transfers it to `to`.
793      *
794      * Requirements:
795      *
796      * - `tokenId` must not exist.
797      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
798      *
799      * Emits a {Transfer} event.
800      */
801     function _safeMint(address to, uint256 tokenId) internal virtual {
802         _safeMint(to, tokenId, "");
803     }
804 
805     /**
806      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
807      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
808      */
809     function _safeMint(
810         address to,
811         uint256 tokenId,
812         bytes memory _data
813     ) internal virtual {
814         _mint(to, tokenId);
815         require(
816             _checkOnERC721Received(address(0), to, tokenId, _data),
817             "ERC721: transfer to non ERC721Receiver implementer"
818         );
819     }
820 
821     /**
822      * @dev Mints `tokenId` and transfers it to `to`.
823      *
824      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
825      *
826      * Requirements:
827      *
828      * - `tokenId` must not exist.
829      * - `to` cannot be the zero address.
830      *
831      * Emits a {Transfer} event.
832      */
833     function _mint(address to, uint256 tokenId) internal virtual {
834         require(to != address(0), "ERC721: mint to the zero address");
835         require(!_exists(tokenId), "ERC721: token already minted");
836 
837         _beforeTokenTransfer(address(0), to, tokenId);
838 
839         _balances[to] += 1;
840         _owners[tokenId] = to;
841 
842         emit Transfer(address(0), to, tokenId);
843     }
844 
845     /**
846      * @dev Destroys `tokenId`.
847      * The approval is cleared when the token is burned.
848      *
849      * Requirements:
850      *
851      * - `tokenId` must exist.
852      *
853      * Emits a {Transfer} event.
854      */
855     function _burn(uint256 tokenId) internal virtual {
856         address owner = ERC721.ownerOf(tokenId);
857 
858         _beforeTokenTransfer(owner, address(0), tokenId);
859 
860         // Clear approvals
861         _approve(address(0), tokenId);
862 
863         _balances[owner] -= 1;
864         delete _owners[tokenId];
865 
866         emit Transfer(owner, address(0), tokenId);
867     }
868 
869     /**
870      * @dev Transfers `tokenId` from `from` to `to`.
871      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
872      *
873      * Requirements:
874      *
875      * - `to` cannot be the zero address.
876      * - `tokenId` token must be owned by `from`.
877      *
878      * Emits a {Transfer} event.
879      */
880     function _transfer(
881         address from,
882         address to,
883         uint256 tokenId
884     ) internal virtual {
885         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
886         require(to != address(0), "ERC721: transfer to the zero address");
887 
888         _beforeTokenTransfer(from, to, tokenId);
889 
890         // Clear approvals from the previous owner
891         _approve(address(0), tokenId);
892 
893         _balances[from] -= 1;
894         _balances[to] += 1;
895         _owners[tokenId] = to;
896 
897         emit Transfer(from, to, tokenId);
898     }
899 
900     /**
901      * @dev Approve `to` to operate on `tokenId`
902      *
903      * Emits a {Approval} event.
904      */
905     function _approve(address to, uint256 tokenId) internal virtual {
906         _tokenApprovals[tokenId] = to;
907         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
908     }
909 
910     /**
911      * @dev Approve `operator` to operate on all of `owner` tokens
912      *
913      * Emits a {ApprovalForAll} event.
914      */
915     function _setApprovalForAll(
916         address owner,
917         address operator,
918         bool approved
919     ) internal virtual {
920         require(owner != operator, "ERC721: approve to caller");
921         _operatorApprovals[owner][operator] = approved;
922         emit ApprovalForAll(owner, operator, approved);
923     }
924 
925     /**
926      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
927      * The call is not executed if the target address is not a contract.
928      *
929      * @param from address representing the previous owner of the given token ID
930      * @param to target address that will receive the tokens
931      * @param tokenId uint256 ID of the token to be transferred
932      * @param _data bytes optional data to send along with the call
933      * @return bool whether the call correctly returned the expected magic value
934      */
935     function _checkOnERC721Received(
936         address from,
937         address to,
938         uint256 tokenId,
939         bytes memory _data
940     ) private returns (bool) {
941         if (to.isContract()) {
942             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
943                 return retval == IERC721Receiver.onERC721Received.selector;
944             } catch (bytes memory reason) {
945                 if (reason.length == 0) {
946                     revert("ERC721: transfer to non ERC721Receiver implementer");
947                 } else {
948                     assembly {
949                         revert(add(32, reason), mload(reason))
950                     }
951                 }
952             }
953         } else {
954             return true;
955         }
956     }
957 
958     /**
959      * @dev Hook that is called before any token transfer. This includes minting
960      * and burning.
961      *
962      * Calling conditions:
963      *
964      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
965      * transferred to `to`.
966      * - When `from` is zero, `tokenId` will be minted for `to`.
967      * - When `to` is zero, ``from``'s `tokenId` will be burned.
968      * - `from` and `to` are never both zero.
969      *
970      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
971      */
972     function _beforeTokenTransfer(
973         address from,
974         address to,
975         uint256 tokenId
976     ) internal virtual {}
977 }
978 
979 
980 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
981 
982 pragma solidity ^0.8.0;
983 
984 /**
985  * @dev Contract module which provides a basic access control mechanism, where
986  * there is an account (an owner) that can be granted exclusive access to
987  * specific functions.
988  *
989  * By default, the owner account will be the one that deploys the contract. This
990  * can later be changed with {transferOwnership}.
991  *
992  * This module is used through inheritance. It will make available the modifier
993  * `onlyOwner`, which can be applied to your functions to restrict their use to
994  * the owner.
995  */
996 abstract contract Ownable is Context {
997     address private _owner;
998 
999     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1000 
1001     /**
1002      * @dev Initializes the contract setting the deployer as the initial owner.
1003      */
1004     constructor() {
1005         _transferOwnership(_msgSender());
1006     }
1007 
1008     /**
1009      * @dev Returns the address of the current owner.
1010      */
1011     function owner() public view virtual returns (address) {
1012         return _owner;
1013     }
1014 
1015     /**
1016      * @dev Throws if called by any account other than the owner.
1017      */
1018     modifier onlyOwner() {
1019         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1020         _;
1021     }
1022 
1023     /**
1024      * @dev Leaves the contract without owner. It will not be possible to call
1025      * `onlyOwner` functions anymore. Can only be called by the current owner.
1026      *
1027      * NOTE: Renouncing ownership will leave the contract without an owner,
1028      * thereby removing any functionality that is only available to the owner.
1029      */
1030     function renounceOwnership() public virtual onlyOwner {
1031         _transferOwnership(address(0));
1032     }
1033 
1034     /**
1035      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1036      * Can only be called by the current owner.
1037      */
1038     function transferOwnership(address newOwner) public virtual onlyOwner {
1039         require(newOwner != address(0), "Ownable: new owner is the zero address");
1040         _transferOwnership(newOwner);
1041     }
1042 
1043     /**
1044      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1045      * Internal function without access restriction.
1046      */
1047     function _transferOwnership(address newOwner) internal virtual {
1048         address oldOwner = _owner;
1049         _owner = newOwner;
1050         emit OwnershipTransferred(oldOwner, newOwner);
1051     }
1052 }
1053 
1054 // Summer Bears
1055 // A gas paid airdrop brought to you by Winter Bears team
1056 
1057 pragma solidity ^0.8.10;
1058 
1059 contract SummerBears is ERC721, Ownable {
1060     constructor() ERC721("SummerBears", "SB") {}
1061 
1062     uint256 public constant MAX_BEARS = 10000;
1063     string private baseURI;
1064 
1065     function withdraw() public onlyOwner {
1066         uint balance = address(this).balance;
1067         payable(msg.sender).transfer(balance);
1068     }
1069 
1070     function airDropBears(address[] memory owners, uint16[] memory tokenIds) public onlyOwner {
1071         for(uint16 i = 0; i < tokenIds.length; i++) {
1072           if (tokenIds[i] < MAX_BEARS) { // implementing token max cap
1073             _safeMint(owners[i], tokenIds[i]);
1074           }
1075         }
1076     }
1077 
1078     function setBaseUri(string memory _uri) external onlyOwner {
1079         baseURI = _uri;
1080     }
1081 
1082     function _baseURI() internal view virtual override returns (string memory) {
1083         return baseURI;
1084     }
1085 
1086     function totalSupply() public pure returns (uint256) {
1087       return MAX_BEARS;
1088     }
1089 }