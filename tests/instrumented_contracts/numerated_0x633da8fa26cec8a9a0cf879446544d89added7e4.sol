1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
27 
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
167 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
168 
169 pragma solidity ^0.8.0;
170 
171 /**
172  * @title ERC721 token receiver interface
173  * @dev Interface for any contract that wants to support safeTransfers
174  * from ERC721 asset contracts.
175  */
176 interface IERC721Receiver {
177     /**
178      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
179      * by `operator` from `from`, this function is called.
180      *
181      * It must return its Solidity selector to confirm the token transfer.
182      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
183      *
184      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
185      */
186     function onERC721Received(
187         address operator,
188         address from,
189         uint256 tokenId,
190         bytes calldata data
191     ) external returns (bytes4);
192 }
193 
194 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
200  * @dev See https://eips.ethereum.org/EIPS/eip-721
201  */
202 interface IERC721Metadata is IERC721 {
203     /**
204      * @dev Returns the token collection name.
205      */
206     function name() external view returns (string memory);
207 
208     /**
209      * @dev Returns the token collection symbol.
210      */
211     function symbol() external view returns (string memory);
212 
213     /**
214      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
215      */
216     function tokenURI(uint256 tokenId) external view returns (string memory);
217 }
218 
219 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev Collection of functions related to the address type
225  */
226 library Address {
227     /**
228      * @dev Returns true if `account` is a contract.
229      *
230      * [IMPORTANT]
231      * ====
232      * It is unsafe to assume that an address for which this function returns
233      * false is an externally-owned account (EOA) and not a contract.
234      *
235      * Among others, `isContract` will return false for the following
236      * types of addresses:
237      *
238      *  - an externally-owned account
239      *  - a contract in construction
240      *  - an address where a contract will be created
241      *  - an address where a contract lived, but was destroyed
242      * ====
243      */
244     function isContract(address account) internal view returns (bool) {
245         // This method relies on extcodesize, which returns 0 for contracts in
246         // construction, since the code is only stored at the end of the
247         // constructor execution.
248 
249         uint256 size;
250         assembly {
251             size := extcodesize(account)
252         }
253         return size > 0;
254     }
255 
256     /**
257      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
258      * `recipient`, forwarding all available gas and reverting on errors.
259      *
260      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
261      * of certain opcodes, possibly making contracts go over the 2300 gas limit
262      * imposed by `transfer`, making them unable to receive funds via
263      * `transfer`. {sendValue} removes this limitation.
264      *
265      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
266      *
267      * IMPORTANT: because control is transferred to `recipient`, care must be
268      * taken to not create reentrancy vulnerabilities. Consider using
269      * {ReentrancyGuard} or the
270      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
271      */
272     function sendValue(address payable recipient, uint256 amount) internal {
273         require(address(this).balance >= amount, "Address: insufficient balance");
274 
275         (bool success, ) = recipient.call{value: amount}("");
276         require(success, "Address: unable to send value, recipient may have reverted");
277     }
278 
279     /**
280      * @dev Performs a Solidity function call using a low level `call`. A
281      * plain `call` is an unsafe replacement for a function call: use this
282      * function instead.
283      *
284      * If `target` reverts with a revert reason, it is bubbled up by this
285      * function (like regular Solidity function calls).
286      *
287      * Returns the raw returned data. To convert to the expected return value,
288      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
289      *
290      * Requirements:
291      *
292      * - `target` must be a contract.
293      * - calling `target` with `data` must not revert.
294      *
295      * _Available since v3.1._
296      */
297     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
298         return functionCall(target, data, "Address: low-level call failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
303      * `errorMessage` as a fallback revert reason when `target` reverts.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(
308         address target,
309         bytes memory data,
310         string memory errorMessage
311     ) internal returns (bytes memory) {
312         return functionCallWithValue(target, data, 0, errorMessage);
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but also transferring `value` wei to `target`.
318      *
319      * Requirements:
320      *
321      * - the calling contract must have an ETH balance of at least `value`.
322      * - the called Solidity function must be `payable`.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(
327         address target,
328         bytes memory data,
329         uint256 value
330     ) internal returns (bytes memory) {
331         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
336      * with `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(
341         address target,
342         bytes memory data,
343         uint256 value,
344         string memory errorMessage
345     ) internal returns (bytes memory) {
346         require(address(this).balance >= value, "Address: insufficient balance for call");
347         require(isContract(target), "Address: call to non-contract");
348 
349         (bool success, bytes memory returndata) = target.call{value: value}(data);
350         return verifyCallResult(success, returndata, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but performing a static call.
356      *
357      * _Available since v3.3._
358      */
359     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
360         return functionStaticCall(target, data, "Address: low-level static call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
365      * but performing a static call.
366      *
367      * _Available since v3.3._
368      */
369     function functionStaticCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal view returns (bytes memory) {
374         require(isContract(target), "Address: static call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.staticcall(data);
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but performing a delegate call.
383      *
384      * _Available since v3.4._
385      */
386     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
387         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
392      * but performing a delegate call.
393      *
394      * _Available since v3.4._
395      */
396     function functionDelegateCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal returns (bytes memory) {
401         require(isContract(target), "Address: delegate call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.delegatecall(data);
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
409      * revert reason using the provided one.
410      *
411      * _Available since v4.3._
412      */
413     function verifyCallResult(
414         bool success,
415         bytes memory returndata,
416         string memory errorMessage
417     ) internal pure returns (bytes memory) {
418         if (success) {
419             return returndata;
420         } else {
421             // Look for revert reason and bubble it up if present
422             if (returndata.length > 0) {
423                 // The easiest way to bubble the revert reason is using memory via assembly
424 
425                 assembly {
426                     let returndata_size := mload(returndata)
427                     revert(add(32, returndata), returndata_size)
428                 }
429             } else {
430                 revert(errorMessage);
431             }
432         }
433     }
434 }
435 
436 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
437 
438 pragma solidity ^0.8.0;
439 
440 /**
441  * @dev Provides information about the current execution context, including the
442  * sender of the transaction and its data. While these are generally available
443  * via msg.sender and msg.data, they should not be accessed in such a direct
444  * manner, since when dealing with meta-transactions the account sending and
445  * paying for execution may not be the actual sender (as far as an application
446  * is concerned).
447  *
448  * This contract is only required for intermediate, library-like contracts.
449  */
450 abstract contract Context {
451     function _msgSender() internal view virtual returns (address) {
452         return msg.sender;
453     }
454 
455     function _msgData() internal view virtual returns (bytes calldata) {
456         return msg.data;
457     }
458 }
459 
460 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
461 
462 pragma solidity ^0.8.0;
463 
464 /**
465  * @dev String operations.
466  */
467 library Strings {
468     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
469 
470     /**
471      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
472      */
473     function toString(uint256 value) internal pure returns (string memory) {
474         // Inspired by OraclizeAPI's implementation - MIT licence
475         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
476 
477         if (value == 0) {
478             return "0";
479         }
480         uint256 temp = value;
481         uint256 digits;
482         while (temp != 0) {
483             digits++;
484             temp /= 10;
485         }
486         bytes memory buffer = new bytes(digits);
487         while (value != 0) {
488             digits -= 1;
489             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
490             value /= 10;
491         }
492         return string(buffer);
493     }
494 
495     /**
496      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
497      */
498     function toHexString(uint256 value) internal pure returns (string memory) {
499         if (value == 0) {
500             return "0x00";
501         }
502         uint256 temp = value;
503         uint256 length = 0;
504         while (temp != 0) {
505             length++;
506             temp >>= 8;
507         }
508         return toHexString(value, length);
509     }
510 
511     /**
512      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
513      */
514     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
515         bytes memory buffer = new bytes(2 * length + 2);
516         buffer[0] = "0";
517         buffer[1] = "x";
518         for (uint256 i = 2 * length + 1; i > 1; --i) {
519             buffer[i] = _HEX_SYMBOLS[value & 0xf];
520             value >>= 4;
521         }
522         require(value == 0, "Strings: hex length insufficient");
523         return string(buffer);
524     }
525 }
526 
527 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @dev Implementation of the {IERC165} interface.
533  *
534  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
535  * for the additional interface id that will be supported. For example:
536  *
537  * ```solidity
538  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
539  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
540  * }
541  * ```
542  *
543  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
544  */
545 abstract contract ERC165 is IERC165 {
546     /**
547      * @dev See {IERC165-supportsInterface}.
548      */
549     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
550         return interfaceId == type(IERC165).interfaceId;
551     }
552 }
553 
554 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
555 
556 pragma solidity ^0.8.0;
557 
558 /**
559  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
560  * the Metadata extension, but not including the Enumerable extension, which is available separately as
561  * {ERC721Enumerable}.
562  */
563 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
564     using Address for address;
565     using Strings for uint256;
566 
567     // Token name
568     string private _name;
569 
570     // Token symbol
571     string private _symbol;
572 
573     // Mapping from token ID to owner address
574     mapping(uint256 => address) private _owners;
575 
576     // Mapping owner address to token count
577     mapping(address => uint256) private _balances;
578 
579     // Mapping from token ID to approved address
580     mapping(uint256 => address) private _tokenApprovals;
581 
582     // Mapping from owner to operator approvals
583     mapping(address => mapping(address => bool)) private _operatorApprovals;
584 
585     /**
586      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
587      */
588     constructor(string memory name_, string memory symbol_) {
589         _name = name_;
590         _symbol = symbol_;
591     }
592 
593     /**
594      * @dev See {IERC165-supportsInterface}.
595      */
596     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
597         return
598             interfaceId == type(IERC721).interfaceId ||
599             interfaceId == type(IERC721Metadata).interfaceId ||
600             super.supportsInterface(interfaceId);
601     }
602 
603     /**
604      * @dev See {IERC721-balanceOf}.
605      */
606     function balanceOf(address owner) public view virtual override returns (uint256) {
607         require(owner != address(0), "ERC721: balance query for the zero address");
608         return _balances[owner];
609     }
610 
611     /**
612      * @dev See {IERC721-ownerOf}.
613      */
614     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
615         address owner = _owners[tokenId];
616         require(owner != address(0), "ERC721: owner query for nonexistent token");
617         return owner;
618     }
619 
620     /**
621      * @dev See {IERC721Metadata-name}.
622      */
623     function name() public view virtual override returns (string memory) {
624         return _name;
625     }
626 
627     /**
628      * @dev See {IERC721Metadata-symbol}.
629      */
630     function symbol() public view virtual override returns (string memory) {
631         return _symbol;
632     }
633 
634     /**
635      * @dev See {IERC721Metadata-tokenURI}.
636      */
637     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
638         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
639 
640         string memory baseURI = _baseURI();
641         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
642     }
643 
644     /**
645      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
646      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
647      * by default, can be overriden in child contracts.
648      */
649     function _baseURI() internal view virtual returns (string memory) {
650         return "";
651     }
652 
653     /**
654      * @dev See {IERC721-approve}.
655      */
656     function approve(address to, uint256 tokenId) public virtual override {
657         address owner = ERC721.ownerOf(tokenId);
658         require(to != owner, "ERC721: approval to current owner");
659 
660         require(
661             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
662             "ERC721: approve caller is not owner nor approved for all"
663         );
664 
665         _approve(to, tokenId);
666     }
667 
668     /**
669      * @dev See {IERC721-getApproved}.
670      */
671     function getApproved(uint256 tokenId) public view virtual override returns (address) {
672         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
673 
674         return _tokenApprovals[tokenId];
675     }
676 
677     /**
678      * @dev See {IERC721-setApprovalForAll}.
679      */
680     function setApprovalForAll(address operator, bool approved) public virtual override {
681         require(operator != _msgSender(), "ERC721: approve to caller");
682 
683         _operatorApprovals[_msgSender()][operator] = approved;
684         emit ApprovalForAll(_msgSender(), operator, approved);
685     }
686 
687     /**
688      * @dev See {IERC721-isApprovedForAll}.
689      */
690     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
691         return _operatorApprovals[owner][operator];
692     }
693 
694     /**
695      * @dev See {IERC721-transferFrom}.
696      */
697     function transferFrom(
698         address from,
699         address to,
700         uint256 tokenId
701     ) public virtual override {
702         //solhint-disable-next-line max-line-length
703         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
704 
705         _transfer(from, to, tokenId);
706     }
707 
708     /**
709      * @dev See {IERC721-safeTransferFrom}.
710      */
711     function safeTransferFrom(
712         address from,
713         address to,
714         uint256 tokenId
715     ) public virtual override {
716         safeTransferFrom(from, to, tokenId, "");
717     }
718 
719     /**
720      * @dev See {IERC721-safeTransferFrom}.
721      */
722     function safeTransferFrom(
723         address from,
724         address to,
725         uint256 tokenId,
726         bytes memory _data
727     ) public virtual override {
728         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
729         _safeTransfer(from, to, tokenId, _data);
730     }
731 
732     /**
733      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
734      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
735      *
736      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
737      *
738      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
739      * implement alternative mechanisms to perform token transfer, such as signature-based.
740      *
741      * Requirements:
742      *
743      * - `from` cannot be the zero address.
744      * - `to` cannot be the zero address.
745      * - `tokenId` token must exist and be owned by `from`.
746      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
747      *
748      * Emits a {Transfer} event.
749      */
750     function _safeTransfer(
751         address from,
752         address to,
753         uint256 tokenId,
754         bytes memory _data
755     ) internal virtual {
756         _transfer(from, to, tokenId);
757         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
758     }
759 
760     /**
761      * @dev Returns whether `tokenId` exists.
762      *
763      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
764      *
765      * Tokens start existing when they are minted (`_mint`),
766      * and stop existing when they are burned (`_burn`).
767      */
768     function _exists(uint256 tokenId) internal view virtual returns (bool) {
769         return _owners[tokenId] != address(0);
770     }
771 
772     /**
773      * @dev Returns whether `spender` is allowed to manage `tokenId`.
774      *
775      * Requirements:
776      *
777      * - `tokenId` must exist.
778      */
779     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
780         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
781         address owner = ERC721.ownerOf(tokenId);
782         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
783     }
784 
785     /**
786      * @dev Safely mints `tokenId` and transfers it to `to`.
787      *
788      * Requirements:
789      *
790      * - `tokenId` must not exist.
791      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
792      *
793      * Emits a {Transfer} event.
794      */
795     function _safeMint(address to, uint256 tokenId) internal virtual {
796         _safeMint(to, tokenId, "");
797     }
798 
799     /**
800      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
801      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
802      */
803     function _safeMint(
804         address to,
805         uint256 tokenId,
806         bytes memory _data
807     ) internal virtual {
808         _mint(to, tokenId);
809         require(
810             _checkOnERC721Received(address(0), to, tokenId, _data),
811             "ERC721: transfer to non ERC721Receiver implementer"
812         );
813     }
814 
815     /**
816      * @dev Mints `tokenId` and transfers it to `to`.
817      *
818      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
819      *
820      * Requirements:
821      *
822      * - `tokenId` must not exist.
823      * - `to` cannot be the zero address.
824      *
825      * Emits a {Transfer} event.
826      */
827     function _mint(address to, uint256 tokenId) internal virtual {
828         require(to != address(0), "ERC721: mint to the zero address");
829         require(!_exists(tokenId), "ERC721: token already minted");
830 
831         _beforeTokenTransfer(address(0), to, tokenId);
832 
833         _balances[to] += 1;
834         _owners[tokenId] = to;
835 
836         emit Transfer(address(0), to, tokenId);
837     }
838 
839     /**
840      * @dev Destroys `tokenId`.
841      * The approval is cleared when the token is burned.
842      *
843      * Requirements:
844      *
845      * - `tokenId` must exist.
846      *
847      * Emits a {Transfer} event.
848      */
849     function _burn(uint256 tokenId) internal virtual {
850         address owner = ERC721.ownerOf(tokenId);
851 
852         _beforeTokenTransfer(owner, address(0), tokenId);
853 
854         // Clear approvals
855         _approve(address(0), tokenId);
856 
857         _balances[owner] -= 1;
858         delete _owners[tokenId];
859 
860         emit Transfer(owner, address(0), tokenId);
861     }
862 
863     /**
864      * @dev Transfers `tokenId` from `from` to `to`.
865      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
866      *
867      * Requirements:
868      *
869      * - `to` cannot be the zero address.
870      * - `tokenId` token must be owned by `from`.
871      *
872      * Emits a {Transfer} event.
873      */
874     function _transfer(
875         address from,
876         address to,
877         uint256 tokenId
878     ) internal virtual {
879         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
880         require(to != address(0), "ERC721: transfer to the zero address");
881 
882         _beforeTokenTransfer(from, to, tokenId);
883 
884         // Clear approvals from the previous owner
885         _approve(address(0), tokenId);
886 
887         _balances[from] -= 1;
888         _balances[to] += 1;
889         _owners[tokenId] = to;
890 
891         emit Transfer(from, to, tokenId);
892     }
893 
894     /**
895      * @dev Approve `to` to operate on `tokenId`
896      *
897      * Emits a {Approval} event.
898      */
899     function _approve(address to, uint256 tokenId) internal virtual {
900         _tokenApprovals[tokenId] = to;
901         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
902     }
903 
904     /**
905      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
906      * The call is not executed if the target address is not a contract.
907      *
908      * @param from address representing the previous owner of the given token ID
909      * @param to target address that will receive the tokens
910      * @param tokenId uint256 ID of the token to be transferred
911      * @param _data bytes optional data to send along with the call
912      * @return bool whether the call correctly returned the expected magic value
913      */
914     function _checkOnERC721Received(
915         address from,
916         address to,
917         uint256 tokenId,
918         bytes memory _data
919     ) private returns (bool) {
920         if (to.isContract()) {
921             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
922                 return retval == IERC721Receiver.onERC721Received.selector;
923             } catch (bytes memory reason) {
924                 if (reason.length == 0) {
925                     revert("ERC721: transfer to non ERC721Receiver implementer");
926                 } else {
927                     assembly {
928                         revert(add(32, reason), mload(reason))
929                     }
930                 }
931             }
932         } else {
933             return true;
934         }
935     }
936 
937     /**
938      * @dev Hook that is called before any token transfer. This includes minting
939      * and burning.
940      *
941      * Calling conditions:
942      *
943      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
944      * transferred to `to`.
945      * - When `from` is zero, `tokenId` will be minted for `to`.
946      * - When `to` is zero, ``from``'s `tokenId` will be burned.
947      * - `from` and `to` are never both zero.
948      *
949      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
950      */
951     function _beforeTokenTransfer(
952         address from,
953         address to,
954         uint256 tokenId
955     ) internal virtual {}
956 }
957 
958 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
959 
960 pragma solidity ^0.8.0;
961 
962 /**
963  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
964  * @dev See https://eips.ethereum.org/EIPS/eip-721
965  */
966 interface IERC721Enumerable is IERC721 {
967     /**
968      * @dev Returns the total amount of tokens stored by the contract.
969      */
970     function totalSupply() external view returns (uint256);
971 
972     /**
973      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
974      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
975      */
976     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
977 
978     /**
979      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
980      * Use along with {totalSupply} to enumerate all tokens.
981      */
982     function tokenByIndex(uint256 index) external view returns (uint256);
983 }
984 
985 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
986 
987 pragma solidity ^0.8.0;
988 
989 /**
990  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
991  * enumerability of all the token ids in the contract as well as all token ids owned by each
992  * account.
993  */
994 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
995     // Mapping from owner to list of owned token IDs
996     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
997 
998     // Mapping from token ID to index of the owner tokens list
999     mapping(uint256 => uint256) private _ownedTokensIndex;
1000 
1001     // Array with all token ids, used for enumeration
1002     uint256[] private _allTokens;
1003 
1004     // Mapping from token id to position in the allTokens array
1005     mapping(uint256 => uint256) private _allTokensIndex;
1006 
1007     /**
1008      * @dev See {IERC165-supportsInterface}.
1009      */
1010     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1011         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
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
1052     function _beforeTokenTransfer(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) internal virtual override {
1057         super._beforeTokenTransfer(from, to, tokenId);
1058 
1059         if (from == address(0)) {
1060             _addTokenToAllTokensEnumeration(tokenId);
1061         } else if (from != to) {
1062             _removeTokenFromOwnerEnumeration(from, tokenId);
1063         }
1064         if (to == address(0)) {
1065             _removeTokenFromAllTokensEnumeration(tokenId);
1066         } else if (to != from) {
1067             _addTokenToOwnerEnumeration(to, tokenId);
1068         }
1069     }
1070 
1071     /**
1072      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1073      * @param to address representing the new owner of the given token ID
1074      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1075      */
1076     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1077         uint256 length = ERC721.balanceOf(to);
1078         _ownedTokens[to][length] = tokenId;
1079         _ownedTokensIndex[tokenId] = length;
1080     }
1081 
1082     /**
1083      * @dev Private function to add a token to this extension's token tracking data structures.
1084      * @param tokenId uint256 ID of the token to be added to the tokens list
1085      */
1086     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1087         _allTokensIndex[tokenId] = _allTokens.length;
1088         _allTokens.push(tokenId);
1089     }
1090 
1091     /**
1092      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1093      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1094      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1095      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1096      * @param from address representing the previous owner of the given token ID
1097      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1098      */
1099     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1100         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1101         // then delete the last slot (swap and pop).
1102 
1103         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1104         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1105 
1106         // When the token to delete is the last token, the swap operation is unnecessary
1107         if (tokenIndex != lastTokenIndex) {
1108             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1109 
1110             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1111             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1112         }
1113 
1114         // This also deletes the contents at the last position of the array
1115         delete _ownedTokensIndex[tokenId];
1116         delete _ownedTokens[from][lastTokenIndex];
1117     }
1118 
1119     /**
1120      * @dev Private function to remove a token from this extension's token tracking data structures.
1121      * This has O(1) time complexity, but alters the order of the _allTokens array.
1122      * @param tokenId uint256 ID of the token to be removed from the tokens list
1123      */
1124     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1125         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1126         // then delete the last slot (swap and pop).
1127 
1128         uint256 lastTokenIndex = _allTokens.length - 1;
1129         uint256 tokenIndex = _allTokensIndex[tokenId];
1130 
1131         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1132         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1133         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1134         uint256 lastTokenId = _allTokens[lastTokenIndex];
1135 
1136         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1137         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1138 
1139         // This also deletes the contents at the last position of the array
1140         delete _allTokensIndex[tokenId];
1141         _allTokens.pop();
1142     }
1143 }
1144 
1145 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1146 
1147 pragma solidity ^0.8.0;
1148 
1149 /**
1150  * @dev Contract module which provides a basic access control mechanism, where
1151  * there is an account (an owner) that can be granted exclusive access to
1152  * specific functions.
1153  *
1154  * By default, the owner account will be the one that deploys the contract. This
1155  * can later be changed with {transferOwnership}.
1156  *
1157  * This module is used through inheritance. It will make available the modifier
1158  * `onlyOwner`, which can be applied to your functions to restrict their use to
1159  * the owner.
1160  */
1161 abstract contract Ownable is Context {
1162     address private _owner;
1163 
1164     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1165 
1166     /**
1167      * @dev Initializes the contract setting the deployer as the initial owner.
1168      */
1169     constructor() {
1170         _setOwner(_msgSender());
1171     }
1172 
1173     /**
1174      * @dev Returns the address of the current owner.
1175      */
1176     function owner() public view virtual returns (address) {
1177         return _owner;
1178     }
1179 
1180     /**
1181      * @dev Throws if called by any account other than the owner.
1182      */
1183     modifier onlyOwner() {
1184         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1185         _;
1186     }
1187 
1188     /**
1189      * @dev Leaves the contract without owner. It will not be possible to call
1190      * `onlyOwner` functions anymore. Can only be called by the current owner.
1191      *
1192      * NOTE: Renouncing ownership will leave the contract without an owner,
1193      * thereby removing any functionality that is only available to the owner.
1194      */
1195     function renounceOwnership() public virtual onlyOwner {
1196         _setOwner(address(0));
1197     }
1198 
1199     /**
1200      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1201      * Can only be called by the current owner.
1202      */
1203     function transferOwnership(address newOwner) public virtual onlyOwner {
1204         require(newOwner != address(0), "Ownable: new owner is the zero address");
1205         _setOwner(newOwner);
1206     }
1207 
1208     function _setOwner(address newOwner) private {
1209         address oldOwner = _owner;
1210         _owner = newOwner;
1211         emit OwnershipTransferred(oldOwner, newOwner);
1212     }
1213 }
1214 
1215 pragma solidity ^0.8.0;
1216 
1217 /**
1218  * @title Counters
1219  * @author Matt Condon (@shrugs)
1220  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1221  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1222  *
1223  * Include with `using Counters for Counters.Counter;`
1224  */
1225 library Counters {
1226     struct Counter {
1227         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1228         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1229         // this feature: see https://github.com/ethereum/solidity/issues/4637
1230         uint256 _value; // default: 0
1231     }
1232 
1233     function current(Counter storage counter) internal view returns (uint256) {
1234         return counter._value;
1235     }
1236 
1237     function increment(Counter storage counter) internal {
1238         unchecked {
1239             counter._value += 1;
1240         }
1241     }
1242 
1243     function decrement(Counter storage counter) internal {
1244         uint256 value = counter._value;
1245         require(value > 0, "Counter: decrement overflow");
1246         unchecked {
1247             counter._value = value - 1;
1248         }
1249     }
1250 
1251     function reset(Counter storage counter) internal {
1252         counter._value = 0;
1253     }
1254 }
1255 
1256 /// @author 1001.digital
1257 /// @title A token tracker that limits the token supply and increments token IDs on each new mint.
1258 abstract contract WithLimitedSupply {
1259     using Counters for Counters.Counter;
1260 
1261     // Keeps track of how many we have minted
1262     Counters.Counter private _tokenCount;
1263 
1264     /// @dev The maximum count of tokens this token tracker will hold.
1265     uint256 private _maxSupply;
1266 
1267     /// Instanciate the contract
1268     /// @param maxSupply_ how many tokens this collection should hold
1269     constructor (uint256 maxSupply_) {
1270         _maxSupply = maxSupply_;
1271     }
1272 
1273     /// @dev Get the max Supply
1274     /// @return the maximum token count
1275     function maxSupply() public view returns (uint256) {
1276         return _maxSupply;
1277     }
1278 
1279     /// @dev Get the current token count
1280     /// @return the created token count
1281     function tokenCount() public view returns (uint256) {
1282         return _tokenCount.current();
1283     }
1284 
1285     /// @dev Check whether tokens are still available
1286     /// @return the available token count
1287     function availableTokenCount() public view returns (uint256) {
1288         return maxSupply() - tokenCount();
1289     }
1290 
1291     /// @dev Increment the token count and fetch the latest count
1292     /// @return the next token id
1293     function nextToken() internal virtual ensureAvailability returns (uint256) {
1294         uint256 token = _tokenCount.current();
1295 
1296         _tokenCount.increment();
1297 
1298         return token;
1299     }
1300 
1301     /// @dev Check whether another token is still available
1302     modifier ensureAvailability() {
1303         require(availableTokenCount() > 0, "No more tokens available");
1304         _;
1305     }
1306 
1307     /// @param amount Check whether number of tokens are still available
1308     /// @dev Check whether tokens are still available
1309     modifier ensureAvailabilityFor(uint256 amount) {
1310         require(availableTokenCount() >= amount, "Requested number of tokens not available");
1311         _;
1312     }
1313 }
1314 
1315 /// @author 1001.digital
1316 /// @title Randomly assign tokenIDs from a given set of tokens.
1317 abstract contract RandomlyAssigned is WithLimitedSupply {
1318     // Used for random index assignment
1319     mapping(uint256 => uint256) private tokenMatrix;
1320 
1321     // The initial token ID
1322     uint256 private startFrom;
1323 
1324     /// Instanciate the contract
1325     /// @param _totalSupply how many tokens this collection should hold
1326     /// @param _startFrom the tokenID with which to start counting
1327     constructor (uint256 _totalSupply, uint256 _startFrom)
1328         WithLimitedSupply(_totalSupply)
1329     {
1330         startFrom = _startFrom;
1331     }
1332 
1333     /// Get the next token ID
1334     /// @dev Randomly gets a new token ID and keeps track of the ones that are still available.
1335     /// @return the next token ID
1336     function nextToken() internal override ensureAvailability returns (uint256) {
1337         uint256 maxIndex = maxSupply() - tokenCount();
1338         uint256 random = uint256(keccak256(
1339             abi.encodePacked(
1340                 msg.sender,
1341                 block.coinbase,
1342                 block.difficulty,
1343                 block.gaslimit,
1344                 block.timestamp
1345             )
1346         )) % maxIndex;
1347 
1348         uint256 value = 0;
1349         if (tokenMatrix[random] == 0) {
1350             // If this matrix position is empty, set the value to the generated random number.
1351             value = random;
1352         } else {
1353             // Otherwise, use the previously stored number from the matrix.
1354             value = tokenMatrix[random];
1355         }
1356 
1357         // If the last available tokenID is still unused...
1358         if (tokenMatrix[maxIndex - 1] == 0) {
1359             // ...store that ID in the current matrix position.
1360             tokenMatrix[random] = maxIndex - 1;
1361         } else {
1362             // ...otherwise copy over the stored number to the current matrix position.
1363             tokenMatrix[random] = tokenMatrix[maxIndex - 1];
1364         }
1365 
1366         // Increment counts
1367         super.nextToken();
1368 
1369         return value + startFrom;
1370     }
1371 }
1372 
1373 // File: contracts/Metaversus.sol
1374 
1375 pragma solidity ^0.8.0;
1376 
1377 /**
1378  * @title Metaversus contract
1379  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1380  */
1381 contract Metaversus is ERC721, ERC721Enumerable, Ownable, RandomlyAssigned {
1382 
1383     uint256 public MAX_NFT_SUPPLY = 8888;
1384     // uint256 public RESERVED_NFT = 6000;
1385 
1386     uint256 public NFT_PRICE = 0.1 ether;
1387     uint256 public NFT_PRICE_PRESALE = 0.05 ether;
1388     
1389     uint256 public MAX_NFT_WALLET_PRESALE = 3;
1390     uint256 public MAX_NFT_WALLET = 10;
1391 
1392     bool public saleIsActive = false;
1393 
1394     uint256 public publicSaleStartTimestamp;
1395     string public baseTokenURI;
1396     
1397     mapping(address => bool) private whitelisted;
1398 
1399     event BaseURIChanged(string baseURI);
1400     event ReserveSaleMint(address minter, uint256 amountOfNFTs);
1401     event FinalSaleMint(address minter, uint256 amountOfNFTs);
1402 
1403     constructor(uint256 _publicSaleStartTimestamp) ERC721("Metaversus NFT", "MV") RandomlyAssigned(MAX_NFT_SUPPLY, 1)
1404     {
1405         // baseTokenURI = baseURI;
1406         publicSaleStartTimestamp = _publicSaleStartTimestamp;
1407     }
1408 
1409     function addToWhitelist(address[] calldata addresses) external onlyOwner {
1410         for (uint256 i = 0; i < addresses.length; i++) {
1411             require(addresses[i] != address(0), "Cannot add null address");
1412 
1413             whitelisted[addresses[i]] = true;
1414         }
1415     }
1416 
1417     function removeFromWhitelist(address[] calldata addresses) external onlyOwner {
1418         for (uint256 i = 0; i < addresses.length; i++) {
1419             require(addresses[i] != address(0), "Cannot add null address");
1420 
1421             whitelisted[addresses[i]] = false;
1422         }
1423     }
1424 
1425     function checkIfWhitelisted(address addr) external view returns (bool) {
1426         return whitelisted[addr];
1427     }
1428 
1429     function reserveNFT(uint256 amountOfNFTs) public onlyOwner {        
1430         
1431         for (uint i = 0; i < amountOfNFTs; i++) {
1432             
1433             uint256 tokenId = nextToken();
1434             _safeMint(msg.sender, tokenId);
1435         }
1436     }
1437 
1438     function mintNFT(uint256 amountOfNFTs) external payable {
1439         require(saleIsActive, "Sale must be active to mint NFT");
1440         require(tokenCount() + amountOfNFTs <= MAX_NFT_SUPPLY, "Minting would exceed max supply");
1441 
1442         if(hasFinalSaleStarted()) {
1443             require(NFT_PRICE * amountOfNFTs == msg.value, "ETH amount is incorrect");
1444             require(balanceOf(msg.sender) + amountOfNFTs <= MAX_NFT_WALLET, "Purchase exceeds max allowed per wallet");
1445         } else {
1446             require(NFT_PRICE_PRESALE * amountOfNFTs == msg.value, "ETH amount is incorrect");
1447             require(balanceOf(msg.sender) + amountOfNFTs <= MAX_NFT_WALLET_PRESALE, "Purchase exceeds max allowed per wallet");
1448         }
1449 
1450         for (uint256 i = 0; i < amountOfNFTs; i++) {
1451             uint256 tokenId = nextToken();
1452 
1453             _safeMint(msg.sender, tokenId);
1454         }
1455 
1456         emit FinalSaleMint(msg.sender, amountOfNFTs);
1457     }
1458 
1459     function flipSaleState() public onlyOwner {
1460         saleIsActive = !saleIsActive;
1461     }
1462     
1463     function hasFinalSaleStarted() public view returns(bool){
1464         return (block.timestamp >= publicSaleStartTimestamp) ? true : false;
1465     }
1466 
1467     function setBaseURI(string memory baseURI) public onlyOwner {
1468         baseTokenURI = baseURI;
1469         emit BaseURIChanged(baseURI);
1470     }
1471 
1472     function setPublicSaleStartTimestamp(uint256 _amount) external onlyOwner {
1473         publicSaleStartTimestamp = _amount;
1474     }
1475 
1476     function setNFT_PRICE(uint256 _amount) external onlyOwner {
1477         NFT_PRICE = _amount;
1478     }
1479 
1480     function setNFT_PRICE_PRESALE(uint256 _amount) external onlyOwner {
1481         NFT_PRICE_PRESALE = _amount;
1482     }
1483 
1484     function setMAX_NFT_WALLET(uint256 _amount) external onlyOwner {
1485         MAX_NFT_WALLET = _amount;
1486     }
1487 
1488     function setMAX_NFT_WALLET_PRESALE(uint256 _amount) external onlyOwner {
1489         MAX_NFT_WALLET_PRESALE = _amount;
1490     }
1491 
1492     function _baseURI() internal view virtual override returns (string memory) {
1493         return baseTokenURI;
1494     }
1495 
1496     function withdrawAll() public onlyOwner {
1497         uint256 balance = address(this).balance;
1498         require(balance > 0, "Insufficent balance");
1499         uint256 AhmedBal = (balance * 200) / 1000;
1500         uint256 Daniele = (balance * 50) / 1000;
1501         uint256 George = (balance * 375) / 1000;
1502         uint256 Brad = (balance * 375) / 1000;
1503 
1504         (bool success, ) = payable(0x692C9da6fACb65DCB092f036c753577379849068).call{value: AhmedBal}("");
1505         require(success, "Transfer failed to Ahmed");
1506         (bool success1, ) = payable(0x56cFf5fbBDE83a195aa8d8a38550bE8438617975).call{value: Daniele}("");
1507         require(success1, "Transfer failed to Daniele");
1508         (bool success2, ) = payable(0x4c8FeB3e02C67408d36c663Ad868d215B1B3239E).call{value: George}("");
1509         require(success2, "Transfer failed to George");
1510         (bool success3, ) = payable(0x97eD2321e644659E7a8d5aAf5f26a44a4225C652).call{value: Brad}("");
1511         require(success3, "Transfer failed to Brad");
1512     }
1513 
1514     function supportsInterface(bytes4 interfaceId)
1515         public
1516         view
1517         override(ERC721, ERC721Enumerable)
1518         returns (bool)
1519     {
1520         return
1521             super.supportsInterface(interfaceId);
1522     }
1523 
1524     function _beforeTokenTransfer(
1525         address from,
1526         address to,
1527         uint256 tokenId
1528     ) internal override(ERC721, ERC721Enumerable) {
1529         super._beforeTokenTransfer(from, to, tokenId);
1530     }
1531 }