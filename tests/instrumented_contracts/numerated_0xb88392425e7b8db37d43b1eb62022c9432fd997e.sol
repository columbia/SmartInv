1 //            __  __                  
2  //          |  \/  |                 
3  // _ ____  _| \  / | __ _ _   _  ___ 
4  //| '_ \ \/ / |\/| |/ _` | | | |/ __|
5  //| |_) >  <| |  | | (_| | |_| | (__ 
6  //| .__/_/\_\_|  |_|\__,_|\__, |\___|
7  //| |                      __/ |     
8  //|_|                     |___/   2.0
9 
10 
11 //First 1000 Free
12 //0.01 Per Mint
13 // SPDX-License-Identifier: MIT
14 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Interface of the ERC165 standard, as defined in the
20  * https://eips.ethereum.org/EIPS/eip-165[EIP].
21  *
22  * Implementers can declare support of contract interfaces, which can then be
23  * queried by others ({ERC165Checker}).
24  *
25  * For an implementation, see {ERC165}.
26  */
27 interface IERC165 {
28     /**
29      * @dev Returns true if this contract implements the interface defined by
30      * `interfaceId`. See the corresponding
31      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
32      * to learn more about how these ids are created.
33      *
34      * This function call must use less than 30 000 gas.
35      */
36     function supportsInterface(bytes4 interfaceId) external view returns (bool);
37 }
38 
39 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
40 
41 pragma solidity ^0.8.0;
42 
43 /**
44  * @dev Required interface of an ERC721 compliant contract.
45  */
46 interface IERC721 is IERC165 {
47     /**
48      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
49      */
50     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
54      */
55     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
56 
57     /**
58      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
59      */
60     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
61 
62     /**
63      * @dev Returns the number of tokens in ``owner``'s account.
64      */
65     function balanceOf(address owner) external view returns (uint256 balance);
66 
67     /**
68      * @dev Returns the owner of the `tokenId` token.
69      *
70      * Requirements:
71      *
72      * - `tokenId` must exist.
73      */
74     function ownerOf(uint256 tokenId) external view returns (address owner);
75 
76     /**
77      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
78      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
79      *
80      * Requirements:
81      *
82      * - `from` cannot be the zero address.
83      * - `to` cannot be the zero address.
84      * - `tokenId` token must exist and be owned by `from`.
85      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
86      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
87      *
88      * Emits a {Transfer} event.
89      */
90     function safeTransferFrom(
91         address from,
92         address to,
93         uint256 tokenId
94     ) external;
95 
96     /**
97      * @dev Transfers `tokenId` token from `from` to `to`.
98      *
99      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
100      *
101      * Requirements:
102      *
103      * - `from` cannot be the zero address.
104      * - `to` cannot be the zero address.
105      * - `tokenId` token must be owned by `from`.
106      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transferFrom(
111         address from,
112         address to,
113         uint256 tokenId
114     ) external;
115 
116     /**
117      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
118      * The approval is cleared when the token is transferred.
119      *
120      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
121      *
122      * Requirements:
123      *
124      * - The caller must own the token or be an approved operator.
125      * - `tokenId` must exist.
126      *
127      * Emits an {Approval} event.
128      */
129     function approve(address to, uint256 tokenId) external;
130 
131     /**
132      * @dev Returns the account approved for `tokenId` token.
133      *
134      * Requirements:
135      *
136      * - `tokenId` must exist.
137      */
138     function getApproved(uint256 tokenId) external view returns (address operator);
139 
140     /**
141      * @dev Approve or remove `operator` as an operator for the caller.
142      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
143      *
144      * Requirements:
145      *
146      * - The `operator` cannot be the caller.
147      *
148      * Emits an {ApprovalForAll} event.
149      */
150     function setApprovalForAll(address operator, bool _approved) external;
151 
152     /**
153      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
154      *
155      * See {setApprovalForAll}
156      */
157     function isApprovedForAll(address owner, address operator) external view returns (bool);
158 
159     /**
160      * @dev Safely transfers `tokenId` token from `from` to `to`.
161      *
162      * Requirements:
163      *
164      * - `from` cannot be the zero address.
165      * - `to` cannot be the zero address.
166      * - `tokenId` token must exist and be owned by `from`.
167      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
168      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
169      *
170      * Emits a {Transfer} event.
171      */
172     function safeTransferFrom(
173         address from,
174         address to,
175         uint256 tokenId,
176         bytes calldata data
177     ) external;
178 }
179 
180 
181 
182 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
183 
184 pragma solidity ^0.8.0;
185 
186 /**
187  * @title ERC721 token receiver interface
188  * @dev Interface for any contract that wants to support safeTransfers
189  * from ERC721 asset contracts.
190  */
191 interface IERC721Receiver {
192     /**
193      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
194      * by `operator` from `from`, this function is called.
195      *
196      * It must return its Solidity selector to confirm the token transfer.
197      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
198      *
199      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
200      */
201     function onERC721Received(
202         address operator,
203         address from,
204         uint256 tokenId,
205         bytes calldata data
206     ) external returns (bytes4);
207 }
208 
209 
210 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
211 
212 pragma solidity ^0.8.0;
213 
214 
215 /**
216  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
217  * @dev See https://eips.ethereum.org/EIPS/eip-721
218  */
219 interface IERC721Metadata is IERC721 {
220     /**
221      * @dev Returns the token collection name.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the token collection symbol.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
232      */
233     function tokenURI(uint256 tokenId) external view returns (string memory);
234 }
235 
236 
237 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 
242 /**
243  * @dev Implementation of the {IERC165} interface.
244  *
245  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
246  * for the additional interface id that will be supported. For example:
247  *
248  * ```solidity
249  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
250  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
251  * }
252  * ```
253  *
254  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
255  */
256 abstract contract ERC165 is IERC165 {
257     /**
258      * @dev See {IERC165-supportsInterface}.
259      */
260     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
261         return interfaceId == type(IERC165).interfaceId;
262     }
263 }
264 
265 
266 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
267 
268 pragma solidity ^0.8.0;
269 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274     /**
275      * @dev Returns true if `account` is a contract.
276      *
277      * [IMPORTANT]
278      * ====
279      * It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      *
282      * Among others, `isContract` will return false for the following
283      * types of addresses:
284      *
285      *  - an externally-owned account
286      *  - a contract in construction
287      *  - an address where a contract will be created
288      *  - an address where a contract lived, but was destroyed
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // This method relies on extcodesize, which returns 0 for contracts in
293         // construction, since the code is only stored at the end of the
294         // constructor execution.
295 
296         uint256 size;
297         assembly {
298             size := extcodesize(account)
299         }
300         return size > 0;
301     }
302 
303     /**
304      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
305      * `recipient`, forwarding all available gas and reverting on errors.
306      *
307      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
308      * of certain opcodes, possibly making contracts go over the 2300 gas limit
309      * imposed by `transfer`, making them unable to receive funds via
310      * `transfer`. {sendValue} removes this limitation.
311      *
312      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
313      *
314      * IMPORTANT: because control is transferred to `recipient`, care must be
315      * taken to not create reentrancy vulnerabilities. Consider using
316      * {ReentrancyGuard} or the
317      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
318      */
319     function sendValue(address payable recipient, uint256 amount) internal {
320         require(address(this).balance >= amount, "Address: insufficient balance");
321 
322         (bool success, ) = recipient.call{value: amount}("");
323         require(success, "Address: unable to send value, recipient may have reverted");
324     }
325 
326     /**
327      * @dev Performs a Solidity function call using a low level `call`. A
328      * plain `call` is an unsafe replacement for a function call: use this
329      * function instead.
330      *
331      * If `target` reverts with a revert reason, it is bubbled up by this
332      * function (like regular Solidity function calls).
333      *
334      * Returns the raw returned data. To convert to the expected return value,
335      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
336      *
337      * Requirements:
338      *
339      * - `target` must be a contract.
340      * - calling `target` with `data` must not revert.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
345         return functionCall(target, data, "Address: low-level call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
350      * `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(
355         address target,
356         bytes memory data,
357         string memory errorMessage
358     ) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, 0, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but also transferring `value` wei to `target`.
365      *
366      * Requirements:
367      *
368      * - the calling contract must have an ETH balance of at least `value`.
369      * - the called Solidity function must be `payable`.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(
374         address target,
375         bytes memory data,
376         uint256 value
377     ) internal returns (bytes memory) {
378         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
383      * with `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387     function functionCallWithValue(
388         address target,
389         bytes memory data,
390         uint256 value,
391         string memory errorMessage
392     ) internal returns (bytes memory) {
393         require(address(this).balance >= value, "Address: insufficient balance for call");
394         require(isContract(target), "Address: call to non-contract");
395 
396         (bool success, bytes memory returndata) = target.call{value: value}(data);
397         return verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
402      * but performing a static call.
403      *
404      * _Available since v3.3._
405      */
406     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
407         return functionStaticCall(target, data, "Address: low-level static call failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
412      * but performing a static call.
413      *
414      * _Available since v3.3._
415      */
416     function functionStaticCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal view returns (bytes memory) {
421         require(isContract(target), "Address: static call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.staticcall(data);
424         return verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but performing a delegate call.
430      *
431      * _Available since v3.4._
432      */
433     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
434         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
439      * but performing a delegate call.
440      *
441      * _Available since v3.4._
442      */
443     function functionDelegateCall(
444         address target,
445         bytes memory data,
446         string memory errorMessage
447     ) internal returns (bytes memory) {
448         require(isContract(target), "Address: delegate call to non-contract");
449 
450         (bool success, bytes memory returndata) = target.delegatecall(data);
451         return verifyCallResult(success, returndata, errorMessage);
452     }
453 
454     /**
455      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
456      * revert reason using the provided one.
457      *
458      * _Available since v4.3._
459      */
460     function verifyCallResult(
461         bool success,
462         bytes memory returndata,
463         string memory errorMessage
464     ) internal pure returns (bytes memory) {
465         if (success) {
466             return returndata;
467         } else {
468             // Look for revert reason and bubble it up if present
469             if (returndata.length > 0) {
470                 // The easiest way to bubble the revert reason is using memory via assembly
471 
472                 assembly {
473                     let returndata_size := mload(returndata)
474                     revert(add(32, returndata), returndata_size)
475                 }
476             } else {
477                 revert(errorMessage);
478             }
479         }
480     }
481 }
482 
483 
484 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
485 
486 pragma solidity ^0.8.0;
487 
488 /**
489  * @dev Provides information about the current execution context, including the
490  * sender of the transaction and its data. While these are generally available
491  * via msg.sender and msg.data, they should not be accessed in such a direct
492  * manner, since when dealing with meta-transactions the account sending and
493  * paying for execution may not be the actual sender (as far as an application
494  * is concerned).
495  *
496  * This contract is only required for intermediate, library-like contracts.
497  */
498 abstract contract Context {
499     function _msgSender() internal view virtual returns (address) {
500         return msg.sender;
501     }
502 
503     function _msgData() internal view virtual returns (bytes calldata) {
504         return msg.data;
505     }
506 }
507 
508 
509 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
510 
511 pragma solidity ^0.8.0;
512 
513 /**
514  * @dev String operations.
515  */
516 library Strings {
517     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
518 
519     /**
520      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
521      */
522     function toString(uint256 value) internal pure returns (string memory) {
523         // Inspired by OraclizeAPI's implementation - MIT licence
524         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
525 
526         if (value == 0) {
527             return "0";
528         }
529         uint256 temp = value;
530         uint256 digits;
531         while (temp != 0) {
532             digits++;
533             temp /= 10;
534         }
535         bytes memory buffer = new bytes(digits);
536         while (value != 0) {
537             digits -= 1;
538             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
539             value /= 10;
540         }
541         return string(buffer);
542     }
543 
544     /**
545      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
546      */
547     function toHexString(uint256 value) internal pure returns (string memory) {
548         if (value == 0) {
549             return "0x00";
550         }
551         uint256 temp = value;
552         uint256 length = 0;
553         while (temp != 0) {
554             length++;
555             temp >>= 8;
556         }
557         return toHexString(value, length);
558     }
559 
560     /**
561      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
562      */
563     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
564         bytes memory buffer = new bytes(2 * length + 2);
565         buffer[0] = "0";
566         buffer[1] = "x";
567         for (uint256 i = 2 * length + 1; i > 1; --i) {
568             buffer[i] = _HEX_SYMBOLS[value & 0xf];
569             value >>= 4;
570         }
571         require(value == 0, "Strings: hex length insufficient");
572         return string(buffer);
573     }
574 }
575 
576 
577 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
578 
579 pragma solidity ^0.8.0;
580 
581 
582 /**
583  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
584  * the Metadata extension, but not including the Enumerable extension, which is available separately as
585  * {ERC721Enumerable}.
586  */
587 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
588     using Address for address;
589     using Strings for uint256;
590 
591     // Token name
592     string private _name;
593 
594     // Token symbol
595     string private _symbol;
596 
597     // Mapping from token ID to owner address
598     mapping(uint256 => address) private _owners;
599 
600     // Mapping owner address to token count
601     mapping(address => uint256) private _balances;
602 
603     // Mapping from token ID to approved address
604     mapping(uint256 => address) private _tokenApprovals;
605 
606     // Mapping from owner to operator approvals
607     mapping(address => mapping(address => bool)) private _operatorApprovals;
608 
609     /**
610      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
611      */
612     constructor(string memory name_, string memory symbol_) {
613         _name = name_;
614         _symbol = symbol_;
615     }
616 
617     /**
618      * @dev See {IERC165-supportsInterface}.
619      */
620     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
621         return
622             interfaceId == type(IERC721).interfaceId ||
623             interfaceId == type(IERC721Metadata).interfaceId ||
624             super.supportsInterface(interfaceId);
625     }
626 
627     /**
628      * @dev See {IERC721-balanceOf}.
629      */
630     function balanceOf(address owner) public view virtual override returns (uint256) {
631         require(owner != address(0), "ERC721: balance query for the zero address");
632         return _balances[owner];
633     }
634 
635     /**
636      * @dev See {IERC721-ownerOf}.
637      */
638     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
639         address owner = _owners[tokenId];
640         require(owner != address(0), "ERC721: owner query for nonexistent token");
641         return owner;
642     }
643 
644     /**
645      * @dev See {IERC721Metadata-name}.
646      */
647     function name() public view virtual override returns (string memory) {
648         return _name;
649     }
650 
651     /**
652      * @dev See {IERC721Metadata-symbol}.
653      */
654     function symbol() public view virtual override returns (string memory) {
655         return _symbol;
656     }
657 
658     /**
659      * @dev See {IERC721Metadata-tokenURI}.
660      */
661     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
662         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
663 
664         string memory baseURI = _baseURI();
665         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
666     }
667 
668     /**
669      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
670      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
671      * by default, can be overriden in child contracts.
672      */
673     function _baseURI() internal view virtual returns (string memory) {
674         return "";
675     }
676 
677     /**
678      * @dev See {IERC721-approve}.
679      */
680     function approve(address to, uint256 tokenId) public virtual override {
681         address owner = ERC721.ownerOf(tokenId);
682         require(to != owner, "ERC721: approval to current owner");
683 
684         require(
685             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
686             "ERC721: approve caller is not owner nor approved for all"
687         );
688 
689         _approve(to, tokenId);
690     }
691 
692     /**
693      * @dev See {IERC721-getApproved}.
694      */
695     function getApproved(uint256 tokenId) public view virtual override returns (address) {
696         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
697 
698         return _tokenApprovals[tokenId];
699     }
700 
701     /**
702      * @dev See {IERC721-setApprovalForAll}.
703      */
704     function setApprovalForAll(address operator, bool approved) public virtual override {
705         _setApprovalForAll(_msgSender(), operator, approved);
706     }
707 
708     /**
709      * @dev See {IERC721-isApprovedForAll}.
710      */
711     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
712         return _operatorApprovals[owner][operator];
713     }
714 
715     /**
716      * @dev See {IERC721-transferFrom}.
717      */
718     function transferFrom(
719         address from,
720         address to,
721         uint256 tokenId
722     ) public virtual override {
723         //solhint-disable-next-line max-line-length
724         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
725 
726         _transfer(from, to, tokenId);
727     }
728 
729     /**
730      * @dev See {IERC721-safeTransferFrom}.
731      */
732     function safeTransferFrom(
733         address from,
734         address to,
735         uint256 tokenId
736     ) public virtual override {
737         safeTransferFrom(from, to, tokenId, "");
738     }
739 
740     /**
741      * @dev See {IERC721-safeTransferFrom}.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 tokenId,
747         bytes memory _data
748     ) public virtual override {
749         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
750         _safeTransfer(from, to, tokenId, _data);
751     }
752 
753     /**
754      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
755      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
756      *
757      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
758      *
759      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
760      * implement alternative mechanisms to perform token transfer, such as signature-based.
761      *
762      * Requirements:
763      *
764      * - `from` cannot be the zero address.
765      * - `to` cannot be the zero address.
766      * - `tokenId` token must exist and be owned by `from`.
767      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
768      *
769      * Emits a {Transfer} event.
770      */
771     function _safeTransfer(
772         address from,
773         address to,
774         uint256 tokenId,
775         bytes memory _data
776     ) internal virtual {
777         _transfer(from, to, tokenId);
778         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
779     }
780 
781     /**
782      * @dev Returns whether `tokenId` exists.
783      *
784      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
785      *
786      * Tokens start existing when they are minted (`_mint`),
787      * and stop existing when they are burned (`_burn`).
788      */
789     function _exists(uint256 tokenId) internal view virtual returns (bool) {
790         return _owners[tokenId] != address(0);
791     }
792 
793     /**
794      * @dev Returns whether `spender` is allowed to manage `tokenId`.
795      *
796      * Requirements:
797      *
798      * - `tokenId` must exist.
799      */
800     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
801         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
802         address owner = ERC721.ownerOf(tokenId);
803         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
804     }
805 
806     /**
807      * @dev Safely mints `tokenId` and transfers it to `to`.
808      *
809      * Requirements:
810      *
811      * - `tokenId` must not exist.
812      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
813      *
814      * Emits a {Transfer} event.
815      */
816     function _safeMint(address to, uint256 tokenId) internal virtual {
817         _safeMint(to, tokenId, "");
818     }
819 
820     /**
821      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
822      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
823      */
824     function _safeMint(
825         address to,
826         uint256 tokenId,
827         bytes memory _data
828     ) internal virtual {
829         _mint(to, tokenId);
830         require(
831             _checkOnERC721Received(address(0), to, tokenId, _data),
832             "ERC721: transfer to non ERC721Receiver implementer"
833         );
834     }
835 
836     /**
837      * @dev Mints `tokenId` and transfers it to `to`.
838      *
839      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
840      *
841      * Requirements:
842      *
843      * - `tokenId` must not exist.
844      * - `to` cannot be the zero address.
845      *
846      * Emits a {Transfer} event.
847      */
848     function _mint(address to, uint256 tokenId) internal virtual {
849         require(to != address(0), "ERC721: mint to the zero address");
850         require(!_exists(tokenId), "ERC721: token already minted");
851 
852         _beforeTokenTransfer(address(0), to, tokenId);
853 
854         _balances[to] += 1;
855         _owners[tokenId] = to;
856 
857         emit Transfer(address(0), to, tokenId);
858     }
859 
860     /**
861      * @dev Destroys `tokenId`.
862      * The approval is cleared when the token is burned.
863      *
864      * Requirements:
865      *
866      * - `tokenId` must exist.
867      *
868      * Emits a {Transfer} event.
869      */
870     function _burn(uint256 tokenId) internal virtual {
871         address owner = ERC721.ownerOf(tokenId);
872 
873         _beforeTokenTransfer(owner, address(0), tokenId);
874 
875         // Clear approvals
876         _approve(address(0), tokenId);
877 
878         _balances[owner] -= 1;
879         delete _owners[tokenId];
880 
881         emit Transfer(owner, address(0), tokenId);
882     }
883 
884     /**
885      * @dev Transfers `tokenId` from `from` to `to`.
886      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
887      *
888      * Requirements:
889      *
890      * - `to` cannot be the zero address.
891      * - `tokenId` token must be owned by `from`.
892      *
893      * Emits a {Transfer} event.
894      */
895     function _transfer(
896         address from,
897         address to,
898         uint256 tokenId
899     ) internal virtual {
900         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
901         require(to != address(0), "ERC721: transfer to the zero address");
902 
903         _beforeTokenTransfer(from, to, tokenId);
904 
905         // Clear approvals from the previous owner
906         _approve(address(0), tokenId);
907 
908         _balances[from] -= 1;
909         _balances[to] += 1;
910         _owners[tokenId] = to;
911 
912         emit Transfer(from, to, tokenId);
913     }
914 
915     /**
916      * @dev Approve `to` to operate on `tokenId`
917      *
918      * Emits a {Approval} event.
919      */
920     function _approve(address to, uint256 tokenId) internal virtual {
921         _tokenApprovals[tokenId] = to;
922         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
923     }
924 
925     /**
926      * @dev Approve `operator` to operate on all of `owner` tokens
927      *
928      * Emits a {ApprovalForAll} event.
929      */
930     function _setApprovalForAll(
931         address owner,
932         address operator,
933         bool approved
934     ) internal virtual {
935         require(owner != operator, "ERC721: approve to caller");
936         _operatorApprovals[owner][operator] = approved;
937         emit ApprovalForAll(owner, operator, approved);
938     }
939 
940     /**
941      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
942      * The call is not executed if the target address is not a contract.
943      *
944      * @param from address representing the previous owner of the given token ID
945      * @param to target address that will receive the tokens
946      * @param tokenId uint256 ID of the token to be transferred
947      * @param _data bytes optional data to send along with the call
948      * @return bool whether the call correctly returned the expected magic value
949      */
950     function _checkOnERC721Received(
951         address from,
952         address to,
953         uint256 tokenId,
954         bytes memory _data
955     ) private returns (bool) {
956         if (to.isContract()) {
957             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
958                 return retval == IERC721Receiver.onERC721Received.selector;
959             } catch (bytes memory reason) {
960                 if (reason.length == 0) {
961                     revert("ERC721: transfer to non ERC721Receiver implementer");
962                 } else {
963                     assembly {
964                         revert(add(32, reason), mload(reason))
965                     }
966                 }
967             }
968         } else {
969             return true;
970         }
971     }
972 
973     /**
974      * @dev Hook that is called before any token transfer. This includes minting
975      * and burning.
976      *
977      * Calling conditions:
978      *
979      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
980      * transferred to `to`.
981      * - When `from` is zero, `tokenId` will be minted for `to`.
982      * - When `to` is zero, ``from``'s `tokenId` will be burned.
983      * - `from` and `to` are never both zero.
984      *
985      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
986      */
987     function _beforeTokenTransfer(
988         address from,
989         address to,
990         uint256 tokenId
991     ) internal virtual {}
992 }
993 
994 
995 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
996 
997 pragma solidity ^0.8.0;
998 
999 /**
1000  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1001  * @dev See https://eips.ethereum.org/EIPS/eip-721
1002  */
1003 interface IERC721Enumerable is IERC721 {
1004     /**
1005      * @dev Returns the total amount of tokens stored by the contract.
1006      */
1007     function totalSupply() external view returns (uint256);
1008 
1009     /**
1010      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1011      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1012      */
1013     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1014 
1015     /**
1016      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1017      * Use along with {totalSupply} to enumerate all tokens.
1018      */
1019     function tokenByIndex(uint256 index) external view returns (uint256);
1020 }
1021 
1022 
1023 
1024 pragma solidity ^0.8.0;
1025 
1026 
1027 /**
1028  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1029  * enumerability of all the token ids in the contract as well as all token ids owned by each
1030  * account.
1031  */
1032 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1033     // Mapping from owner to list of owned token IDs
1034     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1035 
1036     // Mapping from token ID to index of the owner tokens list
1037     mapping(uint256 => uint256) private _ownedTokensIndex;
1038 
1039     // Array with all token ids, used for enumeration
1040     uint256[] private _allTokens;
1041 
1042     // Mapping from token id to position in the allTokens array
1043     mapping(uint256 => uint256) private _allTokensIndex;
1044 
1045     /**
1046      * @dev See {IERC165-supportsInterface}.
1047      */
1048     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1049         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1050     }
1051 
1052     /**
1053      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1054      */
1055     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1056         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1057         return _ownedTokens[owner][index];
1058     }
1059 
1060     /**
1061      * @dev See {IERC721Enumerable-totalSupply}.
1062      */
1063     function totalSupply() public view virtual override returns (uint256) {
1064         return _allTokens.length;
1065     }
1066 
1067     /**
1068      * @dev See {IERC721Enumerable-tokenByIndex}.
1069      */
1070     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1071         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1072         return _allTokens[index];
1073     }
1074 
1075     /**
1076      * @dev Hook that is called before any token transfer. This includes minting
1077      * and burning.
1078      *
1079      * Calling conditions:
1080      *
1081      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1082      * transferred to `to`.
1083      * - When `from` is zero, `tokenId` will be minted for `to`.
1084      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1085      * - `from` cannot be the zero address.
1086      * - `to` cannot be the zero address.
1087      *
1088      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1089      */
1090     function _beforeTokenTransfer(
1091         address from,
1092         address to,
1093         uint256 tokenId
1094     ) internal virtual override {
1095         super._beforeTokenTransfer(from, to, tokenId);
1096 
1097         if (from == address(0)) {
1098             _addTokenToAllTokensEnumeration(tokenId);
1099         } else if (from != to) {
1100             _removeTokenFromOwnerEnumeration(from, tokenId);
1101         }
1102         if (to == address(0)) {
1103             _removeTokenFromAllTokensEnumeration(tokenId);
1104         } else if (to != from) {
1105             _addTokenToOwnerEnumeration(to, tokenId);
1106         }
1107     }
1108 
1109     /**
1110      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1111      * @param to address representing the new owner of the given token ID
1112      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1113      */
1114     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1115         uint256 length = ERC721.balanceOf(to);
1116         _ownedTokens[to][length] = tokenId;
1117         _ownedTokensIndex[tokenId] = length;
1118     }
1119 
1120     /**
1121      * @dev Private function to add a token to this extension's token tracking data structures.
1122      * @param tokenId uint256 ID of the token to be added to the tokens list
1123      */
1124     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1125         _allTokensIndex[tokenId] = _allTokens.length;
1126         _allTokens.push(tokenId);
1127     }
1128 
1129     /**
1130      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1131      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1132      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1133      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1134      * @param from address representing the previous owner of the given token ID
1135      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1136      */
1137     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1138         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1139         // then delete the last slot (swap and pop).
1140 
1141         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1142         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1143 
1144         // When the token to delete is the last token, the swap operation is unnecessary
1145         if (tokenIndex != lastTokenIndex) {
1146             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1147 
1148             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1149             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1150         }
1151 
1152         // This also deletes the contents at the last position of the array
1153         delete _ownedTokensIndex[tokenId];
1154         delete _ownedTokens[from][lastTokenIndex];
1155     }
1156 
1157     /**
1158      * @dev Private function to remove a token from this extension's token tracking data structures.
1159      * This has O(1) time complexity, but alters the order of the _allTokens array.
1160      * @param tokenId uint256 ID of the token to be removed from the tokens list
1161      */
1162     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1163         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1164         // then delete the last slot (swap and pop).
1165 
1166         uint256 lastTokenIndex = _allTokens.length - 1;
1167         uint256 tokenIndex = _allTokensIndex[tokenId];
1168 
1169         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1170         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1171         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1172         uint256 lastTokenId = _allTokens[lastTokenIndex];
1173 
1174         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1175         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1176 
1177         // This also deletes the contents at the last position of the array
1178         delete _allTokensIndex[tokenId];
1179         _allTokens.pop();
1180     }
1181 }
1182 
1183 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1184 
1185 pragma solidity ^0.8.0;
1186 
1187 
1188 /**
1189  * @dev Contract module which provides a basic access control mechanism, where
1190  * there is an account (an owner) that can be granted exclusive access to
1191  * specific functions.
1192  *
1193  * By default, the owner account will be the one that deploys the contract. This
1194  * can later be changed with {transferOwnership}.
1195  *
1196  * This module is used through inheritance. It will make available the modifier
1197  * `onlyOwner`, which can be applied to your functions to restrict their use to
1198  * the owner.
1199  */
1200 abstract contract Ownable is Context {
1201     address private _owner;
1202 
1203     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1204 
1205     /**
1206      * @dev Initializes the contract setting the deployer as the initial owner.
1207      */
1208     constructor() {
1209         _transferOwnership(_msgSender());
1210     }
1211 
1212     /**
1213      * @dev Returns the address of the current owner.
1214      */
1215     function owner() public view virtual returns (address) {
1216         return _owner;
1217     }
1218 
1219     /**
1220      * @dev Throws if called by any account other than the owner.
1221      */
1222     modifier onlyOwner() {
1223         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1224         _;
1225     }
1226 
1227     /**
1228      * @dev Leaves the contract without owner. It will not be possible to call
1229      * `onlyOwner` functions anymore. Can only be called by the current owner.
1230      *
1231      * NOTE: Renouncing ownership will leave the contract without an owner,
1232      * thereby removing any functionality that is only available to the owner.
1233      */
1234     function renounceOwnership() public virtual onlyOwner {
1235         _transferOwnership(address(0));
1236     }
1237 
1238     /**
1239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1240      * Can only be called by the current owner.
1241      */
1242     function transferOwnership(address newOwner) public virtual onlyOwner {
1243         require(newOwner != address(0), "Ownable: new owner is the zero address");
1244         _transferOwnership(newOwner);
1245     }
1246 
1247     /**
1248      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1249      * Internal function without access restriction.
1250      */
1251     function _transferOwnership(address newOwner) internal virtual {
1252         address oldOwner = _owner;
1253         _owner = newOwner;
1254         emit OwnershipTransferred(oldOwner, newOwner);
1255     }
1256 }
1257 
1258 
1259 pragma solidity ^0.8.0;
1260 
1261 
1262 contract pxMAYC is ERC721Enumerable, Ownable {
1263 
1264     uint256 public pxMAYCPrice = 10000000000000000;
1265     uint public constant maxpxMAYCPurchase = 10;
1266     uint public pxMAYCSupply = 6666;
1267     bool public drop_is_active = false;
1268     string public baseURI = "https://ipfs.io/ipfs/QmQsTrkFptdGH9SfaLrYixCWBptqME2xqG4dPbQRFF3FuC/";
1269     uint256 public tokensMinted = 0;
1270     uint256 public freeMints = 1000;
1271 
1272      mapping(address => uint) addressesThatMinted;
1273 
1274     constructor() ERC721("pxMAYC", "pxMAYC"){
1275     
1276     }
1277 
1278     function withdraw() public onlyOwner {
1279         require(payable(msg.sender).send(address(this).balance));
1280     }
1281 
1282     function flipDropState() public onlyOwner {
1283         drop_is_active = !drop_is_active;
1284     }
1285 
1286     function freeMintpxMAYC(uint numberOfTokens) public {
1287         require(drop_is_active, "Please wait until the drop is active to mint");
1288         require(numberOfTokens > 0 && numberOfTokens <= maxpxMAYCPurchase, "Mint count is too little or too high");
1289         require(tokensMinted + numberOfTokens <= freeMints, "Purchase will exceed max supply of free mints");
1290         require(addressesThatMinted[msg.sender] + numberOfTokens <= 10, "You have already minted 10!");
1291         uint256 tokenIndex = tokensMinted;
1292         tokensMinted += numberOfTokens;
1293         addressesThatMinted[msg.sender] += numberOfTokens;
1294 
1295         for (uint i = 0; i < numberOfTokens; i++){
1296             _safeMint(msg.sender, tokenIndex);
1297             tokenIndex++;
1298         }
1299     }
1300 
1301     function mintpxMAYC(uint numberOfTokens) public payable {
1302         require(drop_is_active, "Please wait until the drop is active to mint");
1303         require(numberOfTokens > 0 && numberOfTokens <= maxpxMAYCPurchase, "Mint count is too little or too high");
1304         require(tokensMinted + numberOfTokens <= pxMAYCSupply, "Purchase would exceed max supply of pxMAYC");
1305         require(msg.value >= pxMAYCPrice * numberOfTokens, "ETH value sent is too little for this many pxMAYC");
1306         require(addressesThatMinted[msg.sender] + numberOfTokens <= 30, "You have already minted 30!");
1307 
1308         uint256 tokenIndex = tokensMinted;
1309         tokensMinted += numberOfTokens;
1310         addressesThatMinted[msg.sender] += numberOfTokens;
1311 
1312         for (uint i = 0; i < numberOfTokens; i++){
1313             _safeMint(msg.sender, tokenIndex);
1314             tokenIndex++;
1315         }
1316     }
1317 
1318     function _baseURI() internal view virtual override returns (string memory) {
1319         return baseURI;
1320     }
1321 
1322       function setpxMAYCPrice(uint256 newpxMAYCPrice)public onlyOwner{
1323         pxMAYCPrice = newpxMAYCPrice;
1324     }
1325 
1326       function setBaseURI(string memory newBaseURI)public onlyOwner{
1327         baseURI = newBaseURI;
1328     }
1329 
1330     function setSupply(uint256 newSupply)public onlyOwner{
1331         pxMAYCSupply = newSupply;
1332 
1333     }
1334     function setFreeMints(uint256 newfreeMints)public onlyOwner{
1335         freeMints = newfreeMints;
1336 
1337 
1338     
1339     }
1340 
1341 }