1 // Sources flattened with hardhat v2.9.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
32 
33 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
72      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(
85         address from,
86         address to,
87         uint256 tokenId
88     ) external;
89 
90     /**
91      * @dev Transfers `tokenId` token from `from` to `to`.
92      *
93      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must be owned by `from`.
100      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
112      * The approval is cleared when the token is transferred.
113      *
114      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
115      *
116      * Requirements:
117      *
118      * - The caller must own the token or be an approved operator.
119      * - `tokenId` must exist.
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address to, uint256 tokenId) external;
124 
125     /**
126      * @dev Returns the account approved for `tokenId` token.
127      *
128      * Requirements:
129      *
130      * - `tokenId` must exist.
131      */
132     function getApproved(uint256 tokenId) external view returns (address operator);
133 
134     /**
135      * @dev Approve or remove `operator` as an operator for the caller.
136      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
137      *
138      * Requirements:
139      *
140      * - The `operator` cannot be the caller.
141      *
142      * Emits an {ApprovalForAll} event.
143      */
144     function setApprovalForAll(address operator, bool _approved) external;
145 
146     /**
147      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
148      *
149      * See {setApprovalForAll}
150      */
151     function isApprovedForAll(address owner, address operator) external view returns (bool);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId,
170         bytes calldata data
171     ) external;
172 }
173 
174 
175 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
176 
177 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @title ERC721 token receiver interface
183  * @dev Interface for any contract that wants to support safeTransfers
184  * from ERC721 asset contracts.
185  */
186 interface IERC721Receiver {
187     /**
188      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
189      * by `operator` from `from`, this function is called.
190      *
191      * It must return its Solidity selector to confirm the token transfer.
192      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
193      *
194      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
195      */
196     function onERC721Received(
197         address operator,
198         address from,
199         uint256 tokenId,
200         bytes calldata data
201     ) external returns (bytes4);
202 }
203 
204 
205 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
206 
207 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
208 
209 pragma solidity ^0.8.0;
210 
211 /**
212  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
213  * @dev See https://eips.ethereum.org/EIPS/eip-721
214  */
215 interface IERC721Metadata is IERC721 {
216     /**
217      * @dev Returns the token collection name.
218      */
219     function name() external view returns (string memory);
220 
221     /**
222      * @dev Returns the token collection symbol.
223      */
224     function symbol() external view returns (string memory);
225 
226     /**
227      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
228      */
229     function tokenURI(uint256 tokenId) external view returns (string memory);
230 }
231 
232 
233 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
234 
235 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      */
260     function isContract(address account) internal view returns (bool) {
261         // This method relies on extcodesize, which returns 0 for contracts in
262         // construction, since the code is only stored at the end of the
263         // constructor execution.
264 
265         uint256 size;
266         assembly {
267             size := extcodesize(account)
268         }
269         return size > 0;
270     }
271 
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(address(this).balance >= amount, "Address: insufficient balance");
290 
291         (bool success, ) = recipient.call{value: amount}("");
292         require(success, "Address: unable to send value, recipient may have reverted");
293     }
294 
295     /**
296      * @dev Performs a Solidity function call using a low level `call`. A
297      * plain `call` is an unsafe replacement for a function call: use this
298      * function instead.
299      *
300      * If `target` reverts with a revert reason, it is bubbled up by this
301      * function (like regular Solidity function calls).
302      *
303      * Returns the raw returned data. To convert to the expected return value,
304      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305      *
306      * Requirements:
307      *
308      * - `target` must be a contract.
309      * - calling `target` with `data` must not revert.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
314         return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(
343         address target,
344         bytes memory data,
345         uint256 value
346     ) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         require(isContract(target), "Address: call to non-contract");
364 
365         (bool success, bytes memory returndata) = target.call{value: value}(data);
366         return verifyCallResult(success, returndata, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
376         return functionStaticCall(target, data, "Address: low-level static call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal view returns (bytes memory) {
390         require(isContract(target), "Address: static call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.staticcall(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
403         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         require(isContract(target), "Address: delegate call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.delegatecall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
425      * revert reason using the provided one.
426      *
427      * _Available since v4.3._
428      */
429     function verifyCallResult(
430         bool success,
431         bytes memory returndata,
432         string memory errorMessage
433     ) internal pure returns (bytes memory) {
434         if (success) {
435             return returndata;
436         } else {
437             // Look for revert reason and bubble it up if present
438             if (returndata.length > 0) {
439                 // The easiest way to bubble the revert reason is using memory via assembly
440 
441                 assembly {
442                     let returndata_size := mload(returndata)
443                     revert(add(32, returndata), returndata_size)
444                 }
445             } else {
446                 revert(errorMessage);
447             }
448         }
449     }
450 }
451 
452 
453 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
454 
455 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
456 
457 pragma solidity ^0.8.0;
458 
459 /**
460  * @dev Provides information about the current execution context, including the
461  * sender of the transaction and its data. While these are generally available
462  * via msg.sender and msg.data, they should not be accessed in such a direct
463  * manner, since when dealing with meta-transactions the account sending and
464  * paying for execution may not be the actual sender (as far as an application
465  * is concerned).
466  *
467  * This contract is only required for intermediate, library-like contracts.
468  */
469 abstract contract Context {
470     function _msgSender() internal view virtual returns (address) {
471         return msg.sender;
472     }
473 
474     function _msgData() internal view virtual returns (bytes calldata) {
475         return msg.data;
476     }
477 }
478 
479 
480 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
481 
482 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
483 
484 pragma solidity ^0.8.0;
485 
486 /**
487  * @dev String operations.
488  */
489 library Strings {
490     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
491 
492     /**
493      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
494      */
495     function toString(uint256 value) internal pure returns (string memory) {
496         // Inspired by OraclizeAPI's implementation - MIT licence
497         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
498 
499         if (value == 0) {
500             return "0";
501         }
502         uint256 temp = value;
503         uint256 digits;
504         while (temp != 0) {
505             digits++;
506             temp /= 10;
507         }
508         bytes memory buffer = new bytes(digits);
509         while (value != 0) {
510             digits -= 1;
511             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
512             value /= 10;
513         }
514         return string(buffer);
515     }
516 
517     /**
518      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
519      */
520     function toHexString(uint256 value) internal pure returns (string memory) {
521         if (value == 0) {
522             return "0x00";
523         }
524         uint256 temp = value;
525         uint256 length = 0;
526         while (temp != 0) {
527             length++;
528             temp >>= 8;
529         }
530         return toHexString(value, length);
531     }
532 
533     /**
534      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
535      */
536     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
537         bytes memory buffer = new bytes(2 * length + 2);
538         buffer[0] = "0";
539         buffer[1] = "x";
540         for (uint256 i = 2 * length + 1; i > 1; --i) {
541             buffer[i] = _HEX_SYMBOLS[value & 0xf];
542             value >>= 4;
543         }
544         require(value == 0, "Strings: hex length insufficient");
545         return string(buffer);
546     }
547 }
548 
549 
550 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
551 
552 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
553 
554 pragma solidity ^0.8.0;
555 
556 /**
557  * @dev Implementation of the {IERC165} interface.
558  *
559  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
560  * for the additional interface id that will be supported. For example:
561  *
562  * ```solidity
563  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
565  * }
566  * ```
567  *
568  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
569  */
570 abstract contract ERC165 is IERC165 {
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
575         return interfaceId == type(IERC165).interfaceId;
576     }
577 }
578 
579 
580 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.4.2
581 
582 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 
587 
588 
589 
590 
591 
592 /**
593  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
594  * the Metadata extension, but not including the Enumerable extension, which is available separately as
595  * {ERC721Enumerable}.
596  */
597 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
598     using Address for address;
599     using Strings for uint256;
600 
601     // Token name
602     string private _name;
603 
604     // Token symbol
605     string private _symbol;
606 
607     // Mapping from token ID to owner address
608     mapping(uint256 => address) private _owners;
609 
610     // Mapping owner address to token count
611     mapping(address => uint256) private _balances;
612 
613     // Mapping from token ID to approved address
614     mapping(uint256 => address) private _tokenApprovals;
615 
616     // Mapping from owner to operator approvals
617     mapping(address => mapping(address => bool)) private _operatorApprovals;
618 
619     /**
620      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
621      */
622     constructor(string memory name_, string memory symbol_) {
623         _name = name_;
624         _symbol = symbol_;
625     }
626 
627     /**
628      * @dev See {IERC165-supportsInterface}.
629      */
630     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
631         return
632             interfaceId == type(IERC721).interfaceId ||
633             interfaceId == type(IERC721Metadata).interfaceId ||
634             super.supportsInterface(interfaceId);
635     }
636 
637     /**
638      * @dev See {IERC721-balanceOf}.
639      */
640     function balanceOf(address owner) public view virtual override returns (uint256) {
641         require(owner != address(0), "ERC721: balance query for the zero address");
642         return _balances[owner];
643     }
644 
645     /**
646      * @dev See {IERC721-ownerOf}.
647      */
648     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
649         address owner = _owners[tokenId];
650         require(owner != address(0), "ERC721: owner query for nonexistent token");
651         return owner;
652     }
653 
654     /**
655      * @dev See {IERC721Metadata-name}.
656      */
657     function name() public view virtual override returns (string memory) {
658         return _name;
659     }
660 
661     /**
662      * @dev See {IERC721Metadata-symbol}.
663      */
664     function symbol() public view virtual override returns (string memory) {
665         return _symbol;
666     }
667 
668     /**
669      * @dev See {IERC721Metadata-tokenURI}.
670      */
671     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
672         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
673 
674         string memory baseURI = _baseURI();
675         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
676     }
677 
678     /**
679      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
680      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
681      * by default, can be overriden in child contracts.
682      */
683     function _baseURI() internal view virtual returns (string memory) {
684         return "";
685     }
686 
687     /**
688      * @dev See {IERC721-approve}.
689      */
690     function approve(address to, uint256 tokenId) public virtual override {
691         address owner = ERC721.ownerOf(tokenId);
692         require(to != owner, "ERC721: approval to current owner");
693 
694         require(
695             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
696             "ERC721: approve caller is not owner nor approved for all"
697         );
698 
699         _approve(to, tokenId);
700     }
701 
702     /**
703      * @dev See {IERC721-getApproved}.
704      */
705     function getApproved(uint256 tokenId) public view virtual override returns (address) {
706         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
707 
708         return _tokenApprovals[tokenId];
709     }
710 
711     /**
712      * @dev See {IERC721-setApprovalForAll}.
713      */
714     function setApprovalForAll(address operator, bool approved) public virtual override {
715         _setApprovalForAll(_msgSender(), operator, approved);
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
936      * @dev Approve `operator` to operate on all of `owner` tokens
937      *
938      * Emits a {ApprovalForAll} event.
939      */
940     function _setApprovalForAll(
941         address owner,
942         address operator,
943         bool approved
944     ) internal virtual {
945         require(owner != operator, "ERC721: approve to caller");
946         _operatorApprovals[owner][operator] = approved;
947         emit ApprovalForAll(owner, operator, approved);
948     }
949 
950     /**
951      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
952      * The call is not executed if the target address is not a contract.
953      *
954      * @param from address representing the previous owner of the given token ID
955      * @param to target address that will receive the tokens
956      * @param tokenId uint256 ID of the token to be transferred
957      * @param _data bytes optional data to send along with the call
958      * @return bool whether the call correctly returned the expected magic value
959      */
960     function _checkOnERC721Received(
961         address from,
962         address to,
963         uint256 tokenId,
964         bytes memory _data
965     ) private returns (bool) {
966         if (to.isContract()) {
967             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
968                 return retval == IERC721Receiver.onERC721Received.selector;
969             } catch (bytes memory reason) {
970                 if (reason.length == 0) {
971                     revert("ERC721: transfer to non ERC721Receiver implementer");
972                 } else {
973                     assembly {
974                         revert(add(32, reason), mload(reason))
975                     }
976                 }
977             }
978         } else {
979             return true;
980         }
981     }
982 
983     /**
984      * @dev Hook that is called before any token transfer. This includes minting
985      * and burning.
986      *
987      * Calling conditions:
988      *
989      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
990      * transferred to `to`.
991      * - When `from` is zero, `tokenId` will be minted for `to`.
992      * - When `to` is zero, ``from``'s `tokenId` will be burned.
993      * - `from` and `to` are never both zero.
994      *
995      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
996      */
997     function _beforeTokenTransfer(
998         address from,
999         address to,
1000         uint256 tokenId
1001     ) internal virtual {}
1002 }
1003 
1004 
1005 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.4.2
1006 
1007 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1008 
1009 pragma solidity ^0.8.0;
1010 
1011 
1012 /**
1013  * @title ERC721 Burnable Token
1014  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1015  */
1016 abstract contract ERC721Burnable is Context, ERC721 {
1017     /**
1018      * @dev Burns `tokenId`. See {ERC721-_burn}.
1019      *
1020      * Requirements:
1021      *
1022      * - The caller must own `tokenId` or be an approved operator.
1023      */
1024     function burn(uint256 tokenId) public virtual {
1025         //solhint-disable-next-line max-line-length
1026         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1027         _burn(tokenId);
1028     }
1029 }
1030 
1031 
1032 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
1033 
1034 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1035 
1036 pragma solidity ^0.8.0;
1037 
1038 /**
1039  * @dev Contract module which provides a basic access control mechanism, where
1040  * there is an account (an owner) that can be granted exclusive access to
1041  * specific functions.
1042  *
1043  * By default, the owner account will be the one that deploys the contract. This
1044  * can later be changed with {transferOwnership}.
1045  *
1046  * This module is used through inheritance. It will make available the modifier
1047  * `onlyOwner`, which can be applied to your functions to restrict their use to
1048  * the owner.
1049  */
1050 abstract contract Ownable is Context {
1051     address private _owner;
1052 
1053     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1054 
1055     /**
1056      * @dev Initializes the contract setting the deployer as the initial owner.
1057      */
1058     constructor() {
1059         _transferOwnership(_msgSender());
1060     }
1061 
1062     /**
1063      * @dev Returns the address of the current owner.
1064      */
1065     function owner() public view virtual returns (address) {
1066         return _owner;
1067     }
1068 
1069     /**
1070      * @dev Throws if called by any account other than the owner.
1071      */
1072     modifier onlyOwner() {
1073         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1074         _;
1075     }
1076 
1077     /**
1078      * @dev Leaves the contract without owner. It will not be possible to call
1079      * `onlyOwner` functions anymore. Can only be called by the current owner.
1080      *
1081      * NOTE: Renouncing ownership will leave the contract without an owner,
1082      * thereby removing any functionality that is only available to the owner.
1083      */
1084     function renounceOwnership() public virtual onlyOwner {
1085         _transferOwnership(address(0));
1086     }
1087 
1088     /**
1089      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1090      * Can only be called by the current owner.
1091      */
1092     function transferOwnership(address newOwner) public virtual onlyOwner {
1093         require(newOwner != address(0), "Ownable: new owner is the zero address");
1094         _transferOwnership(newOwner);
1095     }
1096 
1097     /**
1098      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1099      * Internal function without access restriction.
1100      */
1101     function _transferOwnership(address newOwner) internal virtual {
1102         address oldOwner = _owner;
1103         _owner = newOwner;
1104         emit OwnershipTransferred(oldOwner, newOwner);
1105     }
1106 }
1107 
1108 
1109 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.4.2
1110 
1111 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1112 
1113 pragma solidity ^0.8.0;
1114 
1115 /**
1116  * @dev These functions deal with verification of Merkle Trees proofs.
1117  *
1118  * The proofs can be generated using the JavaScript library
1119  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1120  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1121  *
1122  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1123  */
1124 library MerkleProof {
1125     /**
1126      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1127      * defined by `root`. For this, a `proof` must be provided, containing
1128      * sibling hashes on the branch from the leaf to the root of the tree. Each
1129      * pair of leaves and each pair of pre-images are assumed to be sorted.
1130      */
1131     function verify(
1132         bytes32[] memory proof,
1133         bytes32 root,
1134         bytes32 leaf
1135     ) internal pure returns (bool) {
1136         return processProof(proof, leaf) == root;
1137     }
1138 
1139     /**
1140      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1141      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1142      * hash matches the root of the tree. When processing the proof, the pairs
1143      * of leafs & pre-images are assumed to be sorted.
1144      *
1145      * _Available since v4.4._
1146      */
1147     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1148         bytes32 computedHash = leaf;
1149         for (uint256 i = 0; i < proof.length; i++) {
1150             bytes32 proofElement = proof[i];
1151             if (computedHash <= proofElement) {
1152                 // Hash(current computed hash + current element of the proof)
1153                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1154             } else {
1155                 // Hash(current element of the proof + current computed hash)
1156                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1157             }
1158         }
1159         return computedHash;
1160     }
1161 }
1162 
1163 
1164 // File contracts/extensions/custom/KamaClan.sol
1165 
1166 
1167 pragma solidity ^0.8.4;
1168 
1169 
1170 
1171 
1172 //
1173 // Built by https://nft-generator.art
1174 //
1175 contract KamaClanNFTContract is ERC721Burnable, Ownable {
1176   string internal baseUri;
1177 
1178   uint256 public cost = 0.06 ether;
1179   uint32 public maxPerMint = 10;
1180   uint32 public maxPerWallet = 10;
1181   uint32 public supply = 0;
1182   uint32 public totalSupply = 0;
1183   bool public open = false;
1184   bool public presaleOpen = false;
1185   bytes32 private merkleRoot;
1186   mapping(address => uint256) internal addressMintedMap;
1187   bool public revealed = false;
1188   string internal uriNotRevealed;
1189 
1190   address[] private payouts = [
1191     0x460Fd5059E7301680fA53E63bbBF7272E643e89C,
1192     0xdDedd728562d9dda2e0E93C604D0f57457DFBA3E,
1193     0x2e22Bc2153F01965D45e17eB3D48CDFbDB03868f,
1194     0x09A0B72A38D71E5eC1B2d2957EC839a2c25CBA91,
1195     0xB4123E0d6C09f47b678F17eB34Fab9522f5b19e2
1196   ];
1197   uint256[] private payoutSplit = [25, 50, 60, 150, 715];
1198 
1199   constructor(
1200     string memory _uri,
1201     string memory _name,
1202     string memory _symbol,
1203     uint32 _totalSupply,
1204     uint256 _cost,
1205     bool _open
1206   ) ERC721(_name, _symbol) {
1207     baseUri = _uri;
1208     totalSupply = _totalSupply;
1209     cost = _cost;
1210     open = _open;
1211   }
1212 
1213   // ------ Owner Only ------
1214 
1215   function setCost(uint256 _cost) public onlyOwner {
1216     cost = _cost;
1217   }
1218 
1219   function setOpen(bool _open) public onlyOwner {
1220     open = _open;
1221   }
1222 
1223   function setMaxPerWallet(uint32 _max) public onlyOwner {
1224     maxPerWallet = _max;
1225   }
1226 
1227   function setMaxPerMint(uint32 _max) public onlyOwner {
1228     maxPerMint = _max;
1229   }
1230 
1231   function setPresaleOpen(bool _open) public onlyOwner {
1232     presaleOpen = _open;
1233   }
1234 
1235   function setPreSaleAddresses(bytes32 root) public onlyOwner {
1236     merkleRoot = root;
1237   }
1238 
1239   function setUnrevealedURI(string memory _uri) public onlyOwner {
1240     uriNotRevealed = _uri;
1241   }
1242 
1243   function reveal() public onlyOwner {
1244     revealed = true;
1245   }
1246 
1247   function airdrop(address[] calldata to) public onlyOwner {
1248     for (uint32 i = 0; i < to.length; i++) {
1249       require(1 + supply <= totalSupply, "Limit reached");
1250       _safeMint(to[i], ++supply, "");
1251     }
1252   }
1253 
1254   function withdraw() public payable onlyOwner {
1255     uint256 balance = address(this).balance;
1256     uint256 size = payouts.length;
1257 
1258     for (uint256 i = 0; i < size; i++) {
1259       (bool success, ) = payable(payouts[i]).call{
1260         value: (balance * payoutSplit[i]) / 1000
1261       }("");
1262       require(success);
1263     }
1264   }
1265 
1266   function batchBurn(uint256[] memory token_ids) public {
1267     for (uint256 i = 0; i < token_ids.length; i++) {
1268       burn(token_ids[i]);
1269     }
1270   }
1271 
1272   // ------ Mint! ------
1273 
1274   function mint(uint32 count) external payable preMintChecks(count) {
1275     require(open == true, "Mint not open");
1276     performMint(count);
1277   }
1278 
1279   function presaleMint(uint32 count, bytes32[] calldata proof)
1280     external
1281     payable
1282     preMintChecks(count)
1283   {
1284     require(presaleOpen, "Presale not open");
1285     require(merkleRoot != "", "Presale not ready");
1286     require(
1287       MerkleProof.verify(
1288         proof,
1289         merkleRoot,
1290         keccak256(abi.encodePacked(msg.sender))
1291       ),
1292       "Not a presale member"
1293     );
1294 
1295     performMint(count);
1296   }
1297 
1298   function performMint(uint32 count) internal {
1299     for (uint32 i = 0; i < count; i++) {
1300       _safeMint(msg.sender, ++supply, "");
1301     }
1302     addressMintedMap[msg.sender] += count;
1303   }
1304 
1305   // ------ Read ------
1306 
1307   function tokenURI(uint256 _tokenId)
1308     public
1309     view
1310     override
1311     returns (string memory)
1312   {
1313     require(_tokenId <= supply, "Not minted yet");
1314     if (revealed == false) {
1315       return
1316         string(
1317           abi.encodePacked(uriNotRevealed, Strings.toString(_tokenId), ".json")
1318         );
1319     }
1320 
1321     return
1322       string(abi.encodePacked(baseUri, Strings.toString(_tokenId), ".json"));
1323   }
1324 
1325   // ------ Modifiers ------
1326 
1327   modifier preMintChecks(uint32 count) {
1328     require(count > 0, "Mint at least one.");
1329     require(count < maxPerMint + 1, "Max mint reached.");
1330     require(msg.value >= cost * count, "Not enough fund.");
1331     require(supply + count < totalSupply + 1, "Mint sold out");
1332     require(
1333       addressMintedMap[msg.sender] + count <= maxPerWallet,
1334       "Max total mint reached"
1335     );
1336     _;
1337   }
1338 }