1 // SPDX-License-Identifier: MIT
2 
3 /*
4  ______       _________   ______        ______       ______       _________
5 /_____/\     /________/\ /_____/\      /_____/\     /_____/\     /________/\
6 \::::_\/_    \__.::.__\/ \:::_ \ \     \::::_\/_    \::::_\/_    \__.::.__\/
7  \:\/___/\      \::\ \    \:(_) ) )_    \:\/___/\    \:\/___/\      \::\ \
8   \_::._\:\      \::\ \    \: __ `\ \    \::___\/_    \::___\/_      \::\ \
9     /____\:\      \::\ \    \ \ `\ \ \    \:\____/\    \:\____/\      \::\ \
10     \_____\/       \__\/     \_\/ \_\/     \_____\/     \_____\/       \__\/
11                      ________       ______     ______
12                     /_______/\     /_____/\   /_____/\
13                     \::: _  \ \    \:::_ \ \  \::::_\/_
14                      \::(_)  \ \    \:(_) \ \  \:\/___/\
15                       \:: __  \ \    \: ___\/   \::___\/_
16                        \:.\ \  \ \    \ \ \      \:\____/\
17                         \__\/\__\/     \_\/       \_____\/
18 
19  ______       ______       ______       ________      ______       _________   __  __
20 /_____/\     /_____/\     /_____/\     /_______/\    /_____/\     /________/\ /_/\/_/\
21 \::::_\/_    \:::_ \ \    \:::__\/     \__.::._\/    \::::_\/_    \__.::.__\/ \ \ \ \ \
22  \:\/___/\    \:\ \ \ \    \:\ \  __      \::\ \      \:\/___/\      \::\ \    \:\_\ \ \
23   \_::._\:\    \:\ \ \ \    \:\ \/_/\     _\::\ \__    \::___\/_      \::\ \    \::::_\/
24     /____\:\    \:\_\ \ \    \:\_\ \ \   /__\::\__/\    \:\____/\      \::\ \     \::\ \
25     \_____\/     \_____\/     \_____\/   \________\/     \_____\/       \__\/      \__\/
26 */
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Provides information about the current execution context, including the
31  * sender of the transaction and its data. While these are generally available
32  * via msg.sender and msg.data, they should not be accessed in such a direct
33  * manner, since when dealing with meta-transactions the account sending and
34  * paying for execution may not be the actual sender (as far as an application
35  * is concerned).
36  *
37  * This contract is only required for intermediate, library-like contracts.
38  */
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view virtual returns (bytes calldata) {
45         return msg.data;
46     }
47 }
48 
49 pragma solidity ^0.8.0;
50 
51 /**
52  * @dev Collection of functions related to the address type
53  */
54 library Address {
55     /**
56      * @dev Returns true if `account` is a contract.
57      *
58      * [IMPORTANT]
59      * ====
60      * It is unsafe to assume that an address for which this function returns
61      * false is an externally-owned account (EOA) and not a contract.
62      *
63      * Among others, `isContract` will return false for the following
64      * types of addresses:
65      *
66      *  - an externally-owned account
67      *  - a contract in construction
68      *  - an address where a contract will be created
69      *  - an address where a contract lived, but was destroyed
70      * ====
71      */
72     function isContract(address account) internal view returns (bool) {
73         // This method relies on extcodesize, which returns 0 for contracts in
74         // construction, since the code is only stored at the end of the
75         // constructor execution.
76 
77         uint256 size;
78         assembly {
79             size := extcodesize(account)
80         }
81         return size > 0;
82     }
83 
84     /**
85      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
86      * `recipient`, forwarding all available gas and reverting on errors.
87      *
88      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
89      * of certain opcodes, possibly making contracts go over the 2300 gas limit
90      * imposed by `transfer`, making them unable to receive funds via
91      * `transfer`. {sendValue} removes this limitation.
92      *
93      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
94      *
95      * IMPORTANT: because control is transferred to `recipient`, care must be
96      * taken to not create reentrancy vulnerabilities. Consider using
97      * {ReentrancyGuard} or the
98      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
99      */
100     function sendValue(address payable recipient, uint256 amount) internal {
101         require(address(this).balance >= amount, "Address: insufficient balance");
102 
103         (bool success, ) = recipient.call{value: amount}("");
104         require(success, "Address: unable to send value, recipient may have reverted");
105     }
106 
107     /**
108      * @dev Performs a Solidity function call using a low level `call`. A
109      * plain `call` is an unsafe replacement for a function call: use this
110      * function instead.
111      *
112      * If `target` reverts with a revert reason, it is bubbled up by this
113      * function (like regular Solidity function calls).
114      *
115      * Returns the raw returned data. To convert to the expected return value,
116      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
117      *
118      * Requirements:
119      *
120      * - `target` must be a contract.
121      * - calling `target` with `data` must not revert.
122      *
123      * _Available since v3.1._
124      */
125     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
126         return functionCall(target, data, "Address: low-level call failed");
127     }
128 
129     /**
130      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
131      * `errorMessage` as a fallback revert reason when `target` reverts.
132      *
133      * _Available since v3.1._
134      */
135     function functionCall(
136         address target,
137         bytes memory data,
138         string memory errorMessage
139     ) internal returns (bytes memory) {
140         return functionCallWithValue(target, data, 0, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but also transferring `value` wei to `target`.
146      *
147      * Requirements:
148      *
149      * - the calling contract must have an ETH balance of at least `value`.
150      * - the called Solidity function must be `payable`.
151      *
152      * _Available since v3.1._
153      */
154     function functionCallWithValue(
155         address target,
156         bytes memory data,
157         uint256 value
158     ) internal returns (bytes memory) {
159         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
164      * with `errorMessage` as a fallback revert reason when `target` reverts.
165      *
166      * _Available since v3.1._
167      */
168     function functionCallWithValue(
169         address target,
170         bytes memory data,
171         uint256 value,
172         string memory errorMessage
173     ) internal returns (bytes memory) {
174         require(address(this).balance >= value, "Address: insufficient balance for call");
175         require(isContract(target), "Address: call to non-contract");
176 
177         (bool success, bytes memory returndata) = target.call{value: value}(data);
178         return verifyCallResult(success, returndata, errorMessage);
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
183      * but performing a static call.
184      *
185      * _Available since v3.3._
186      */
187     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
188         return functionStaticCall(target, data, "Address: low-level static call failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
193      * but performing a static call.
194      *
195      * _Available since v3.3._
196      */
197     function functionStaticCall(
198         address target,
199         bytes memory data,
200         string memory errorMessage
201     ) internal view returns (bytes memory) {
202         require(isContract(target), "Address: static call to non-contract");
203 
204         (bool success, bytes memory returndata) = target.staticcall(data);
205         return verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
210      * but performing a delegate call.
211      *
212      * _Available since v3.4._
213      */
214     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
215         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
220      * but performing a delegate call.
221      *
222      * _Available since v3.4._
223      */
224     function functionDelegateCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal returns (bytes memory) {
229         require(isContract(target), "Address: delegate call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.delegatecall(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
237      * revert reason using the provided one.
238      *
239      * _Available since v4.3._
240      */
241     function verifyCallResult(
242         bool success,
243         bytes memory returndata,
244         string memory errorMessage
245     ) internal pure returns (bytes memory) {
246         if (success) {
247             return returndata;
248         } else {
249             // Look for revert reason and bubble it up if present
250             if (returndata.length > 0) {
251                 // The easiest way to bubble the revert reason is using memory via assembly
252 
253                 assembly {
254                     let returndata_size := mload(returndata)
255                     revert(add(32, returndata), returndata_size)
256                 }
257             } else {
258                 revert(errorMessage);
259             }
260         }
261     }
262 }
263 
264 pragma solidity ^0.8.0;
265 
266 /**
267  * @dev Interface of the ERC165 standard, as defined in the
268  * https://eips.ethereum.org/EIPS/eip-165[EIP].
269  *
270  * Implementers can declare support of contract interfaces, which can then be
271  * queried by others ({ERC165Checker}).
272  *
273  * For an implementation, see {ERC165}.
274  */
275 interface IERC165 {
276     /**
277      * @dev Returns true if this contract implements the interface defined by
278      * `interfaceId`. See the corresponding
279      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
280      * to learn more about how these ids are created.
281      *
282      * This function call must use less than 30 000 gas.
283      */
284     function supportsInterface(bytes4 interfaceId) external view returns (bool);
285 }
286 
287 pragma solidity ^0.8.0;
288 
289 /**
290  * @dev Required interface of an ERC721 compliant contract.
291  */
292 interface IERC721 is IERC165 {
293     /**
294      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
295      */
296     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
297 
298     /**
299      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
300      */
301     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
302 
303     /**
304      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
305      */
306     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
307 
308     /**
309      * @dev Returns the number of tokens in ``owner``'s account.
310      */
311     function balanceOf(address owner) external view returns (uint256 balance);
312 
313     /**
314      * @dev Returns the owner of the `tokenId` token.
315      *
316      * Requirements:
317      *
318      * - `tokenId` must exist.
319      */
320     function ownerOf(uint256 tokenId) external view returns (address owner);
321 
322     /**
323      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
324      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
325      *
326      * Requirements:
327      *
328      * - `from` cannot be the zero address.
329      * - `to` cannot be the zero address.
330      * - `tokenId` token must exist and be owned by `from`.
331      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
332      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
333      *
334      * Emits a {Transfer} event.
335      */
336     function safeTransferFrom(
337         address from,
338         address to,
339         uint256 tokenId
340     ) external;
341 
342     /**
343      * @dev Transfers `tokenId` token from `from` to `to`.
344      *
345      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
346      *
347      * Requirements:
348      *
349      * - `from` cannot be the zero address.
350      * - `to` cannot be the zero address.
351      * - `tokenId` token must be owned by `from`.
352      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
353      *
354      * Emits a {Transfer} event.
355      */
356     function transferFrom(
357         address from,
358         address to,
359         uint256 tokenId
360     ) external;
361 
362     /**
363      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
364      * The approval is cleared when the token is transferred.
365      *
366      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
367      *
368      * Requirements:
369      *
370      * - The caller must own the token or be an approved operator.
371      * - `tokenId` must exist.
372      *
373      * Emits an {Approval} event.
374      */
375     function approve(address to, uint256 tokenId) external;
376 
377     /**
378      * @dev Returns the account approved for `tokenId` token.
379      *
380      * Requirements:
381      *
382      * - `tokenId` must exist.
383      */
384     function getApproved(uint256 tokenId) external view returns (address operator);
385 
386     /**
387      * @dev Approve or remove `operator` as an operator for the caller.
388      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
389      *
390      * Requirements:
391      *
392      * - The `operator` cannot be the caller.
393      *
394      * Emits an {ApprovalForAll} event.
395      */
396     function setApprovalForAll(address operator, bool _approved) external;
397 
398     /**
399      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
400      *
401      * See {setApprovalForAll}
402      */
403     function isApprovedForAll(address owner, address operator) external view returns (bool);
404 
405     /**
406      * @dev Safely transfers `tokenId` token from `from` to `to`.
407      *
408      * Requirements:
409      *
410      * - `from` cannot be the zero address.
411      * - `to` cannot be the zero address.
412      * - `tokenId` token must exist and be owned by `from`.
413      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
414      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
415      *
416      * Emits a {Transfer} event.
417      */
418     function safeTransferFrom(
419         address from,
420         address to,
421         uint256 tokenId,
422         bytes calldata data
423     ) external;
424 }
425 
426 pragma solidity ^0.8.0;
427 
428 /**
429  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
430  * @dev See https://eips.ethereum.org/EIPS/eip-721
431  */
432 interface IERC721Metadata is IERC721 {
433     /**
434      * @dev Returns the token collection name.
435      */
436     function name() external view returns (string memory);
437 
438     /**
439      * @dev Returns the token collection symbol.
440      */
441     function symbol() external view returns (string memory);
442 
443     /**
444      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
445      */
446     function tokenURI(uint256 tokenId) external view returns (string memory);
447 }
448 
449 pragma solidity ^0.8.0;
450 
451 /**
452  * @title ERC721 token receiver interface
453  * @dev Interface for any contract that wants to support safeTransfers
454  * from ERC721 asset contracts.
455  */
456 interface IERC721Receiver {
457     /**
458      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
459      * by `operator` from `from`, this function is called.
460      *
461      * It must return its Solidity selector to confirm the token transfer.
462      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
463      *
464      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
465      */
466     function onERC721Received(
467         address operator,
468         address from,
469         uint256 tokenId,
470         bytes calldata data
471     ) external returns (bytes4);
472 }
473 
474 pragma solidity ^0.8.0;
475 
476 /**
477  * @dev Implementation of the {IERC165} interface.
478  *
479  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
480  * for the additional interface id that will be supported. For example:
481  *
482  * ```solidity
483  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
484  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
485  * }
486  * ```
487  *
488  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
489  */
490 abstract contract ERC165 is IERC165 {
491     /**
492      * @dev See {IERC165-supportsInterface}.
493      */
494     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
495         return interfaceId == type(IERC165).interfaceId;
496     }
497 }
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @dev String operations.
503  */
504 library Strings {
505     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
506 
507     /**
508      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
509      */
510     function toString(uint256 value) internal pure returns (string memory) {
511         // Inspired by OraclizeAPI's implementation - MIT licence
512         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
513 
514         if (value == 0) {
515             return "0";
516         }
517         uint256 temp = value;
518         uint256 digits;
519         while (temp != 0) {
520             digits++;
521             temp /= 10;
522         }
523         bytes memory buffer = new bytes(digits);
524         while (value != 0) {
525             digits -= 1;
526             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
527             value /= 10;
528         }
529         return string(buffer);
530     }
531 
532     /**
533      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
534      */
535     function toHexString(uint256 value) internal pure returns (string memory) {
536         if (value == 0) {
537             return "0x00";
538         }
539         uint256 temp = value;
540         uint256 length = 0;
541         while (temp != 0) {
542             length++;
543             temp >>= 8;
544         }
545         return toHexString(value, length);
546     }
547 
548     /**
549      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
550      */
551     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
552         bytes memory buffer = new bytes(2 * length + 2);
553         buffer[0] = "0";
554         buffer[1] = "x";
555         for (uint256 i = 2 * length + 1; i > 1; --i) {
556             buffer[i] = _HEX_SYMBOLS[value & 0xf];
557             value >>= 4;
558         }
559         require(value == 0, "Strings: hex length insufficient");
560         return string(buffer);
561     }
562 }
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
568  * the Metadata extension, but not including the Enumerable extension, which is available separately as
569  * {ERC721Enumerable}.
570  */
571 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
572     using Address for address;
573     using Strings for uint256;
574 
575     // Token name
576     string private _name;
577 
578     // Token symbol
579     string private _symbol;
580 
581     // Mapping from token ID to owner address
582     mapping(uint256 => address) private _owners;
583 
584     // Mapping owner address to token count
585     mapping(address => uint256) private _balances;
586 
587     // Mapping from token ID to approved address
588     mapping(uint256 => address) private _tokenApprovals;
589 
590     // Mapping from owner to operator approvals
591     mapping(address => mapping(address => bool)) private _operatorApprovals;
592 
593     /**
594      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
595      */
596     constructor(string memory name_, string memory symbol_) {
597         _name = name_;
598         _symbol = symbol_;
599     }
600 
601     /**
602      * @dev See {IERC165-supportsInterface}.
603      */
604     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
605         return
606         interfaceId == type(IERC721).interfaceId ||
607         interfaceId == type(IERC721Metadata).interfaceId ||
608         super.supportsInterface(interfaceId);
609     }
610 
611     /**
612      * @dev See {IERC721-balanceOf}.
613      */
614     function balanceOf(address owner) public view virtual override returns (uint256) {
615         require(owner != address(0), "ERC721: balance query for the zero address");
616         return _balances[owner];
617     }
618 
619     /**
620      * @dev See {IERC721-ownerOf}.
621      */
622     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
623         address owner = _owners[tokenId];
624         require(owner != address(0), "ERC721: owner query for nonexistent token");
625         return owner;
626     }
627 
628     /**
629      * @dev See {IERC721Metadata-name}.
630      */
631     function name() public view virtual override returns (string memory) {
632         return _name;
633     }
634 
635     /**
636      * @dev See {IERC721Metadata-symbol}.
637      */
638     function symbol() public view virtual override returns (string memory) {
639         return _symbol;
640     }
641 
642     /**
643      * @dev See {IERC721Metadata-tokenURI}.
644      */
645     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
646         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
647 
648         string memory baseURI = _baseURI();
649         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
650     }
651 
652     /**
653      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
654      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
655      * by default, can be overriden in child contracts.
656      */
657     function _baseURI() internal view virtual returns (string memory) {
658         return "";
659     }
660 
661     /**
662      * @dev See {IERC721-approve}.
663      */
664     function approve(address to, uint256 tokenId) public virtual override {
665         address owner = ERC721.ownerOf(tokenId);
666         require(to != owner, "ERC721: approval to current owner");
667 
668         require(
669             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
670             "ERC721: approve caller is not owner nor approved for all"
671         );
672 
673         _approve(to, tokenId);
674     }
675 
676     /**
677      * @dev See {IERC721-getApproved}.
678      */
679     function getApproved(uint256 tokenId) public view virtual override returns (address) {
680         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
681 
682         return _tokenApprovals[tokenId];
683     }
684 
685     /**
686      * @dev See {IERC721-setApprovalForAll}.
687      */
688     function setApprovalForAll(address operator, bool approved) public virtual override {
689         require(operator != _msgSender(), "ERC721: approve to caller");
690 
691         _operatorApprovals[_msgSender()][operator] = approved;
692         emit ApprovalForAll(_msgSender(), operator, approved);
693     }
694 
695     /**
696      * @dev See {IERC721-isApprovedForAll}.
697      */
698     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
699         return _operatorApprovals[owner][operator];
700     }
701 
702     /**
703      * @dev See {IERC721-transferFrom}.
704      */
705     function transferFrom(
706         address from,
707         address to,
708         uint256 tokenId
709     ) public virtual override {
710         //solhint-disable-next-line max-line-length
711         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
712 
713         _transfer(from, to, tokenId);
714     }
715 
716     /**
717      * @dev See {IERC721-safeTransferFrom}.
718      */
719     function safeTransferFrom(
720         address from,
721         address to,
722         uint256 tokenId
723     ) public virtual override {
724         safeTransferFrom(from, to, tokenId, "");
725     }
726 
727     /**
728      * @dev See {IERC721-safeTransferFrom}.
729      */
730     function safeTransferFrom(
731         address from,
732         address to,
733         uint256 tokenId,
734         bytes memory _data
735     ) public virtual override {
736         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
737         _safeTransfer(from, to, tokenId, _data);
738     }
739 
740     /**
741      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
742      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
743      *
744      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
745      *
746      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
747      * implement alternative mechanisms to perform token transfer, such as signature-based.
748      *
749      * Requirements:
750      *
751      * - `from` cannot be the zero address.
752      * - `to` cannot be the zero address.
753      * - `tokenId` token must exist and be owned by `from`.
754      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
755      *
756      * Emits a {Transfer} event.
757      */
758     function _safeTransfer(
759         address from,
760         address to,
761         uint256 tokenId,
762         bytes memory _data
763     ) internal virtual {
764         _transfer(from, to, tokenId);
765         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
766     }
767 
768     /**
769      * @dev Returns whether `tokenId` exists.
770      *
771      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
772      *
773      * Tokens start existing when they are minted (`_mint`),
774      * and stop existing when they are burned (`_burn`).
775      */
776     function _exists(uint256 tokenId) internal view virtual returns (bool) {
777         return _owners[tokenId] != address(0);
778     }
779 
780     /**
781      * @dev Returns whether `spender` is allowed to manage `tokenId`.
782      *
783      * Requirements:
784      *
785      * - `tokenId` must exist.
786      */
787     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
788         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
789         address owner = ERC721.ownerOf(tokenId);
790         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
791     }
792 
793     /**
794      * @dev Safely mints `tokenId` and transfers it to `to`.
795      *
796      * Requirements:
797      *
798      * - `tokenId` must not exist.
799      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
800      *
801      * Emits a {Transfer} event.
802      */
803     function _safeMint(address to, uint256 tokenId) internal virtual {
804         _safeMint(to, tokenId, "");
805     }
806 
807     /**
808      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
809      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
810      */
811     function _safeMint(
812         address to,
813         uint256 tokenId,
814         bytes memory _data
815     ) internal virtual {
816         _mint(to, tokenId);
817         require(
818             _checkOnERC721Received(address(0), to, tokenId, _data),
819             "ERC721: transfer to non ERC721Receiver implementer"
820         );
821     }
822 
823     /**
824      * @dev Mints `tokenId` and transfers it to `to`.
825      *
826      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
827      *
828      * Requirements:
829      *
830      * - `tokenId` must not exist.
831      * - `to` cannot be the zero address.
832      *
833      * Emits a {Transfer} event.
834      */
835     function _mint(address to, uint256 tokenId) internal virtual {
836         require(to != address(0), "ERC721: mint to the zero address");
837         require(!_exists(tokenId), "ERC721: token already minted");
838 
839         _beforeTokenTransfer(address(0), to, tokenId);
840 
841         _balances[to] += 1;
842         _owners[tokenId] = to;
843 
844         emit Transfer(address(0), to, tokenId);
845     }
846 
847     /**
848      * @dev Destroys `tokenId`.
849      * The approval is cleared when the token is burned.
850      *
851      * Requirements:
852      *
853      * - `tokenId` must exist.
854      *
855      * Emits a {Transfer} event.
856      */
857     function _burn(uint256 tokenId) internal virtual {
858         address owner = ERC721.ownerOf(tokenId);
859 
860         _beforeTokenTransfer(owner, address(0), tokenId);
861 
862         // Clear approvals
863         _approve(address(0), tokenId);
864 
865         _balances[owner] -= 1;
866         delete _owners[tokenId];
867 
868         emit Transfer(owner, address(0), tokenId);
869     }
870 
871     /**
872      * @dev Transfers `tokenId` from `from` to `to`.
873      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
874      *
875      * Requirements:
876      *
877      * - `to` cannot be the zero address.
878      * - `tokenId` token must be owned by `from`.
879      *
880      * Emits a {Transfer} event.
881      */
882     function _transfer(
883         address from,
884         address to,
885         uint256 tokenId
886     ) internal virtual {
887         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
888         require(to != address(0), "ERC721: transfer to the zero address");
889 
890         _beforeTokenTransfer(from, to, tokenId);
891 
892         // Clear approvals from the previous owner
893         _approve(address(0), tokenId);
894 
895         _balances[from] -= 1;
896         _balances[to] += 1;
897         _owners[tokenId] = to;
898 
899         emit Transfer(from, to, tokenId);
900     }
901 
902     /**
903      * @dev Approve `to` to operate on `tokenId`
904      *
905      * Emits a {Approval} event.
906      */
907     function _approve(address to, uint256 tokenId) internal virtual {
908         _tokenApprovals[tokenId] = to;
909         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
910     }
911 
912     /**
913      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
914      * The call is not executed if the target address is not a contract.
915      *
916      * @param from address representing the previous owner of the given token ID
917      * @param to target address that will receive the tokens
918      * @param tokenId uint256 ID of the token to be transferred
919      * @param _data bytes optional data to send along with the call
920      * @return bool whether the call correctly returned the expected magic value
921      */
922     function _checkOnERC721Received(
923         address from,
924         address to,
925         uint256 tokenId,
926         bytes memory _data
927     ) private returns (bool) {
928         if (to.isContract()) {
929             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
930                 return retval == IERC721Receiver.onERC721Received.selector;
931             } catch (bytes memory reason) {
932                 if (reason.length == 0) {
933                     revert("ERC721: transfer to non ERC721Receiver implementer");
934                 } else {
935                     assembly {
936                         revert(add(32, reason), mload(reason))
937                     }
938                 }
939             }
940         } else {
941             return true;
942         }
943     }
944 
945     /**
946      * @dev Hook that is called before any token transfer. This includes minting
947      * and burning.
948      *
949      * Calling conditions:
950      *
951      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
952      * transferred to `to`.
953      * - When `from` is zero, `tokenId` will be minted for `to`.
954      * - When `to` is zero, ``from``'s `tokenId` will be burned.
955      * - `from` and `to` are never both zero.
956      *
957      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
958      */
959     function _beforeTokenTransfer(
960         address from,
961         address to,
962         uint256 tokenId
963     ) internal virtual {}
964 }
965 
966 pragma solidity ^0.8.0;
967 
968 /**
969  * @dev Contract module which provides a basic access control mechanism, where
970  * there is an account (an owner) that can be granted exclusive access to
971  * specific functions.
972  *
973  * By default, the owner account will be the one that deploys the contract. This
974  * can later be changed with {transferOwnership}.
975  *
976  * This module is used through inheritance. It will make available the modifier
977  * `onlyOwner`, which can be applied to your functions to restrict their use to
978  * the owner.
979  */
980 abstract contract Ownable is Context {
981     address private _owner;
982 
983     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
984 
985     /**
986      * @dev Initializes the contract setting the deployer as the initial owner.
987      */
988     constructor() {
989         _setOwner(_msgSender());
990     }
991 
992     /**
993      * @dev Returns the address of the current owner.
994      */
995     function owner() public view virtual returns (address) {
996         return _owner;
997     }
998 
999     /**
1000      * @dev Throws if called by any account other than the owner.
1001      */
1002     modifier onlyOwner() {
1003         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1004         _;
1005     }
1006 
1007     /**
1008      * @dev Leaves the contract without owner. It will not be possible to call
1009      * `onlyOwner` functions anymore. Can only be called by the current owner.
1010      *
1011      * NOTE: Renouncing ownership will leave the contract without an owner,
1012      * thereby removing any functionality that is only available to the owner.
1013      */
1014     function renounceOwnership() public virtual onlyOwner {
1015         _setOwner(address(0));
1016     }
1017 
1018     /**
1019      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1020      * Can only be called by the current owner.
1021      */
1022     function transferOwnership(address newOwner) public virtual onlyOwner {
1023         require(newOwner != address(0), "Ownable: new owner is the zero address");
1024         _setOwner(newOwner);
1025     }
1026 
1027     function _setOwner(address newOwner) private {
1028         address oldOwner = _owner;
1029         _owner = newOwner;
1030         emit OwnershipTransferred(oldOwner, newOwner);
1031     }
1032 }
1033 
1034 pragma solidity ^0.8.0;
1035 
1036 /**
1037  * @title PaymentSplitter
1038  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1039  * that the Ether will be split in this way, since it is handled transparently by the contract.
1040  *
1041  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1042  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1043  * an amount proportional to the percentage of total shares they were assigned.
1044  *
1045  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1046  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1047  * function.
1048  *
1049  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1050  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1051  * to run tests before sending real value to this contract.
1052  */
1053 contract PaymentSplitter is Context {
1054     event PayeeAdded(address account, uint256 shares);
1055     event PaymentReleased(address to, uint256 amount);
1056     event PaymentReceived(address from, uint256 amount);
1057 
1058     uint256 private _totalShares;
1059     uint256 private _totalReleased;
1060 
1061     mapping(address => uint256) private _shares;
1062     mapping(address => uint256) private _released;
1063     address[] private _payees;
1064 
1065     /**
1066      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1067      * the matching position in the `shares` array.
1068      *
1069      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1070      * duplicates in `payees`.
1071      */
1072     constructor(address[] memory payees, uint256[] memory shares_) payable {
1073         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1074         require(payees.length > 0, "PaymentSplitter: no payees");
1075 
1076         for (uint256 i = 0; i < payees.length; i++) {
1077             _addPayee(payees[i], shares_[i]);
1078         }
1079     }
1080 
1081     /**
1082      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1083      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1084      * reliability of the events, and not the actual splitting of Ether.
1085      *
1086      * To learn more about this see the Solidity documentation for
1087      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1088      * functions].
1089      */
1090     receive() external payable virtual {
1091         emit PaymentReceived(_msgSender(), msg.value);
1092     }
1093 
1094     /**
1095      * @dev Getter for the total shares held by payees.
1096      */
1097     function totalShares() public view returns (uint256) {
1098         return _totalShares;
1099     }
1100 
1101     /**
1102      * @dev Getter for the total amount of Ether already released.
1103      */
1104     function totalReleased() public view returns (uint256) {
1105         return _totalReleased;
1106     }
1107 
1108     /**
1109      * @dev Getter for the amount of shares held by an account.
1110      */
1111     function shares(address account) public view returns (uint256) {
1112         return _shares[account];
1113     }
1114 
1115     /**
1116      * @dev Getter for the amount of Ether already released to a payee.
1117      */
1118     function released(address account) public view returns (uint256) {
1119         return _released[account];
1120     }
1121 
1122     /**
1123      * @dev Getter for the address of the payee number `index`.
1124      */
1125     function payee(uint256 index) public view returns (address) {
1126         return _payees[index];
1127     }
1128 
1129     /**
1130      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1131      * total shares and their previous withdrawals.
1132      */
1133     function release(address payable account) public virtual {
1134         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1135 
1136         uint256 totalReceived = address(this).balance + totalReleased();
1137         uint256 payment = _pendingPayment(account, totalReceived, released(account));
1138 
1139         require(payment != 0, "PaymentSplitter: account is not due payment");
1140 
1141         _released[account] += payment;
1142         _totalReleased += payment;
1143 
1144         Address.sendValue(account, payment);
1145         emit PaymentReleased(account, payment);
1146     }
1147 
1148     /**
1149      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1150      * already released amounts.
1151      */
1152     function _pendingPayment(
1153         address account,
1154         uint256 totalReceived,
1155         uint256 alreadyReleased
1156     ) private view returns (uint256) {
1157         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1158     }
1159 
1160     /**
1161      * @dev Add a new payee to the contract.
1162      * @param account The address of the payee to add.
1163      * @param shares_ The number of shares owned by the payee.
1164      */
1165     function _addPayee(address account, uint256 shares_) private {
1166         require(account != address(0), "PaymentSplitter: account is the zero address");
1167         require(shares_ > 0, "PaymentSplitter: shares are 0");
1168         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1169 
1170         _payees.push(account);
1171         _shares[account] = shares_;
1172         _totalShares = _totalShares + shares_;
1173         emit PayeeAdded(account, shares_);
1174     }
1175 }
1176 
1177 pragma solidity >=0.4.22 <0.9.0;
1178 
1179 contract StreetApeSociety is Ownable, ERC721, PaymentSplitter {
1180     using Strings for uint256;
1181 
1182     bool public active;
1183     uint256 public constant MAXQTY = 8888;
1184     uint256 public constant FREE = 500;
1185     uint256 public constant RESERVE = 25;
1186     uint256 public FEE = 0.05 ether;
1187     uint256 public LIMIT = 20;
1188 
1189     string public baseURI;
1190     uint256 public totalSupply;
1191 
1192     mapping(address => uint256) public mintMap;
1193     mapping(address => bool) public free;
1194 
1195     constructor(
1196         string memory tokenBaseURI,
1197         address[] memory payees,
1198         uint256[] memory shares
1199     ) ERC721("Street Ape Society", "SAS") PaymentSplitter(payees, shares)  {
1200         baseURI = tokenBaseURI;
1201     }
1202 
1203     function changeActive() external onlyOwner {
1204         active = !active;
1205     }
1206 
1207     function mint(uint256 mintQty) external payable {
1208         require(active, "INACTIVE");
1209         if (totalSupply < FREE + RESERVE) {
1210             require(mintQty == 1, "JUST ONE");
1211             require(msg.value == 0, "FREE");
1212             require(!free[msg.sender], "PAY");
1213             free[msg.sender] = true;
1214         } else {
1215             require(totalSupply + mintQty <= MAXQTY, "TOO MUCH");
1216             require(mintMap[msg.sender] + mintQty <= LIMIT, "YOU ARE DONE");
1217             require(msg.value >= FEE * mintQty, "NOT ENOUGH");
1218             mintMap[msg.sender] += mintQty;
1219         }
1220 
1221         for (uint256 i = 0; i < mintQty; i++) {
1222             _mint(msg.sender, totalSupply + i);
1223         }
1224 
1225         totalSupply += mintQty;
1226     }
1227 
1228     function reserve() external onlyOwner {
1229         for (uint256 i = 0; i < RESERVE; ++i) {
1230             _mint(msg.sender, totalSupply + i);
1231         }
1232 
1233         totalSupply += RESERVE;
1234     }
1235 
1236     function setBaseURI(string calldata URI) public onlyOwner {
1237         baseURI = URI;
1238     }
1239 
1240     function _baseURI() internal view override(ERC721) returns (string memory) {
1241         return baseURI;
1242     }
1243 
1244     function tokenURI(uint256 _tokenId) public view virtual override(ERC721) returns (string memory) {
1245         require(_exists(_tokenId), "ERC721Metadata: Nonexistent token");
1246         string memory currentBaseURI = _baseURI();
1247         return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json")) : "";
1248     }
1249 }