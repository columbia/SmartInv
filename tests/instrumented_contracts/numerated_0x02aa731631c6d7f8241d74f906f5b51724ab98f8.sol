1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @title ERC721 token receiver interface
7  * @dev Interface for any contract that wants to support safeTransfers
8  * from ERC721 asset contracts.
9  */
10 interface IERC721Receiver {
11     /**
12      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
13      * by `operator` from `from`, this function is called.
14      *
15      * It must return its Solidity selector to confirm the token transfer.
16      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
17      *
18      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
19      */
20     function onERC721Received(
21         address operator,
22         address from,
23         uint256 tokenId,
24         bytes calldata data
25     ) external returns (bytes4);
26 }
27 
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev String operations.
33  */
34 library Strings {
35     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
39      */
40     function toString(uint256 value) internal pure returns (string memory) {
41         // Inspired by OraclizeAPI's implementation - MIT licence
42         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
43 
44         if (value == 0) {
45             return "0";
46         }
47         uint256 temp = value;
48         uint256 digits;
49         while (temp != 0) {
50             digits++;
51             temp /= 10;
52         }
53         bytes memory buffer = new bytes(digits);
54         while (value != 0) {
55             digits -= 1;
56             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
57             value /= 10;
58         }
59         return string(buffer);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
64      */
65     function toHexString(uint256 value) internal pure returns (string memory) {
66         if (value == 0) {
67             return "0x00";
68         }
69         uint256 temp = value;
70         uint256 length = 0;
71         while (temp != 0) {
72             length++;
73             temp >>= 8;
74         }
75         return toHexString(value, length);
76     }
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
80      */
81     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
82         bytes memory buffer = new bytes(2 * length + 2);
83         buffer[0] = "0";
84         buffer[1] = "x";
85         for (uint256 i = 2 * length + 1; i > 1; --i) {
86             buffer[i] = _HEX_SYMBOLS[value & 0xf];
87             value >>= 4;
88         }
89         require(value == 0, "Strings: hex length insufficient");
90         return string(buffer);
91     }
92 }
93 
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Collection of functions related to the address type
99  */
100 library Address {
101     /**
102      * @dev Returns true if `account` is a contract.
103      *
104      * [IMPORTANT]
105      * ====
106      * It is unsafe to assume that an address for which this function returns
107      * false is an externally-owned account (EOA) and not a contract.
108      *
109      * Among others, `isContract` will return false for the following
110      * types of addresses:
111      *
112      *  - an externally-owned account
113      *  - a contract in construction
114      *  - an address where a contract will be created
115      *  - an address where a contract lived, but was destroyed
116      * ====
117      */
118     function isContract(address account) internal view returns (bool) {
119         // This method relies on extcodesize, which returns 0 for contracts in
120         // construction, since the code is only stored at the end of the
121         // constructor execution.
122 
123         uint256 size;
124         assembly {
125             size := extcodesize(account)
126         }
127         return size > 0;
128     }
129 
130     /**
131      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
132      * `recipient`, forwarding all available gas and reverting on errors.
133      *
134      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
135      * of certain opcodes, possibly making contracts go over the 2300 gas limit
136      * imposed by `transfer`, making them unable to receive funds via
137      * `transfer`. {sendValue} removes this limitation.
138      *
139      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
140      *
141      * IMPORTANT: because control is transferred to `recipient`, care must be
142      * taken to not create reentrancy vulnerabilities. Consider using
143      * {ReentrancyGuard} or the
144      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
145      */
146     function sendValue(address payable recipient, uint256 amount) internal {
147         require(address(this).balance >= amount, "Address: insufficient balance");
148 
149         (bool success, ) = recipient.call{value: amount}("");
150         require(success, "Address: unable to send value, recipient may have reverted");
151     }
152 
153     /**
154      * @dev Performs a Solidity function call using a low level `call`. A
155      * plain `call` is an unsafe replacement for a function call: use this
156      * function instead.
157      *
158      * If `target` reverts with a revert reason, it is bubbled up by this
159      * function (like regular Solidity function calls).
160      *
161      * Returns the raw returned data. To convert to the expected return value,
162      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
163      *
164      * Requirements:
165      *
166      * - `target` must be a contract.
167      * - calling `target` with `data` must not revert.
168      *
169      * _Available since v3.1._
170      */
171     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
172         return functionCall(target, data, "Address: low-level call failed");
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
177      * `errorMessage` as a fallback revert reason when `target` reverts.
178      *
179      * _Available since v3.1._
180      */
181     function functionCall(
182         address target,
183         bytes memory data,
184         string memory errorMessage
185     ) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, 0, errorMessage);
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
191      * but also transferring `value` wei to `target`.
192      *
193      * Requirements:
194      *
195      * - the calling contract must have an ETH balance of at least `value`.
196      * - the called Solidity function must be `payable`.
197      *
198      * _Available since v3.1._
199      */
200     function functionCallWithValue(
201         address target,
202         bytes memory data,
203         uint256 value
204     ) internal returns (bytes memory) {
205         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
210      * with `errorMessage` as a fallback revert reason when `target` reverts.
211      *
212      * _Available since v3.1._
213      */
214     function functionCallWithValue(
215         address target,
216         bytes memory data,
217         uint256 value,
218         string memory errorMessage
219     ) internal returns (bytes memory) {
220         require(address(this).balance >= value, "Address: insufficient balance for call");
221         require(isContract(target), "Address: call to non-contract");
222 
223         (bool success, bytes memory returndata) = target.call{value: value}(data);
224         return _verifyCallResult(success, returndata, errorMessage);
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
229      * but performing a static call.
230      *
231      * _Available since v3.3._
232      */
233     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
234         return functionStaticCall(target, data, "Address: low-level static call failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
239      * but performing a static call.
240      *
241      * _Available since v3.3._
242      */
243     function functionStaticCall(
244         address target,
245         bytes memory data,
246         string memory errorMessage
247     ) internal view returns (bytes memory) {
248         require(isContract(target), "Address: static call to non-contract");
249 
250         (bool success, bytes memory returndata) = target.staticcall(data);
251         return _verifyCallResult(success, returndata, errorMessage);
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
256      * but performing a delegate call.
257      *
258      * _Available since v3.4._
259      */
260     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
261         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
266      * but performing a delegate call.
267      *
268      * _Available since v3.4._
269      */
270     function functionDelegateCall(
271         address target,
272         bytes memory data,
273         string memory errorMessage
274     ) internal returns (bytes memory) {
275         require(isContract(target), "Address: delegate call to non-contract");
276 
277         (bool success, bytes memory returndata) = target.delegatecall(data);
278         return _verifyCallResult(success, returndata, errorMessage);
279     }
280 
281     function _verifyCallResult(
282         bool success,
283         bytes memory returndata,
284         string memory errorMessage
285     ) private pure returns (bytes memory) {
286         if (success) {
287             return returndata;
288         } else {
289             // Look for revert reason and bubble it up if present
290             if (returndata.length > 0) {
291                 // The easiest way to bubble the revert reason is using memory via assembly
292 
293                 assembly {
294                     let returndata_size := mload(returndata)
295                     revert(add(32, returndata), returndata_size)
296                 }
297             } else {
298                 revert(errorMessage);
299             }
300         }
301     }
302 }
303 
304 
305 pragma solidity ^0.8.0;
306 
307 /*
308  * @dev Provides information about the current execution context, including the
309  * sender of the transaction and its data. While these are generally available
310  * via msg.sender and msg.data, they should not be accessed in such a direct
311  * manner, since when dealing with meta-transactions the account sending and
312  * paying for execution may not be the actual sender (as far as an application
313  * is concerned).
314  *
315  * This contract is only required for intermediate, library-like contracts.
316  */
317 abstract contract Context {
318     function _msgSender() internal view virtual returns (address) {
319         return msg.sender;
320     }
321 
322     function _msgData() internal view virtual returns (bytes calldata) {
323         return msg.data;
324     }
325 }
326 
327 
328 pragma solidity ^0.8.0;
329 
330 /**
331  * @dev Contract module which provides a basic access control mechanism, where
332  * there is an account (an owner) that can be granted exclusive access to
333  * specific functions.
334  *
335  * By default, the owner account will be the one that deploys the contract. This
336  * can later be changed with {transferOwnership}.
337  *
338  * This module is used through inheritance. It will make available the modifier
339  * `onlyOwner`, which can be applied to your functions to restrict their use to
340  * the owner.
341  */
342 abstract contract Ownable is Context {
343     address private _owner;
344 
345     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
346 
347     /**
348      * @dev Initializes the contract setting the deployer as the initial owner.
349      */
350     constructor() {
351         _setOwner(_msgSender());
352     }
353 
354     /**
355      * @dev Returns the address of the current owner.
356      */
357     function owner() public view virtual returns (address) {
358         return _owner;
359     }
360 
361     /**
362      * @dev Throws if called by any account other than the owner.
363      */
364     modifier onlyOwner() {
365         require(owner() == _msgSender(), "Ownable: caller is not the owner");
366         _;
367     }
368 
369     /**
370      * @dev Leaves the contract without owner. It will not be possible to call
371      * `onlyOwner` functions anymore. Can only be called by the current owner.
372      *
373      * NOTE: Renouncing ownership will leave the contract without an owner,
374      * thereby removing any functionality that is only available to the owner.
375      */
376     function renounceOwnership() public virtual onlyOwner {
377         _setOwner(address(0));
378     }
379 
380     /**
381      * @dev Transfers ownership of the contract to a new account (`newOwner`).
382      * Can only be called by the current owner.
383      */
384     function transferOwnership(address newOwner) public virtual onlyOwner {
385         require(newOwner != address(0), "Ownable: new owner is the zero address");
386         _setOwner(newOwner);
387     }
388 
389     function _setOwner(address newOwner) private {
390         address oldOwner = _owner;
391         _owner = newOwner;
392         emit OwnershipTransferred(oldOwner, newOwner);
393     }
394 }
395 
396 pragma solidity ^0.8.0;
397 
398 /**
399  * @dev Interface of the ERC165 standard, as defined in the
400  * https://eips.ethereum.org/EIPS/eip-165[EIP].
401  *
402  * Implementers can declare support of contract interfaces, which can then be
403  * queried by others ({ERC165Checker}).
404  *
405  * For an implementation, see {ERC165}.
406  */
407 interface IERC165 {
408     /**
409      * @dev Returns true if this contract implements the interface defined by
410      * `interfaceId`. See the corresponding
411      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
412      * to learn more about how these ids are created.
413      *
414      * This function call must use less than 30 000 gas.
415      */
416     function supportsInterface(bytes4 interfaceId) external view returns (bool);
417 }
418 
419 pragma solidity ^0.8.0;
420 
421 
422 /**
423  * @dev Required interface of an ERC721 compliant contract.
424  */
425 interface IERC721 is IERC165 {
426     /**
427      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
428      */
429     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
430 
431     /**
432      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
433      */
434     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
435 
436     /**
437      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
438      */
439     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
440 
441     /**
442      * @dev Returns the number of tokens in ``owner``'s account.
443      */
444     function balanceOf(address owner) external view returns (uint256 balance);
445 
446     /**
447      * @dev Returns the owner of the `tokenId` token.
448      *
449      * Requirements:
450      *
451      * - `tokenId` must exist.
452      */
453     function ownerOf(uint256 tokenId) external view returns (address owner);
454 
455     /**
456      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
457      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
458      *
459      * Requirements:
460      *
461      * - `from` cannot be the zero address.
462      * - `to` cannot be the zero address.
463      * - `tokenId` token must exist and be owned by `from`.
464      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
465      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
466      *
467      * Emits a {Transfer} event.
468      */
469     function safeTransferFrom(
470         address from,
471         address to,
472         uint256 tokenId
473     ) external;
474 
475     /**
476      * @dev Transfers `tokenId` token from `from` to `to`.
477      *
478      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
479      *
480      * Requirements:
481      *
482      * - `from` cannot be the zero address.
483      * - `to` cannot be the zero address.
484      * - `tokenId` token must be owned by `from`.
485      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
486      *
487      * Emits a {Transfer} event.
488      */
489     function transferFrom(
490         address from,
491         address to,
492         uint256 tokenId
493     ) external;
494 
495     /**
496      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
497      * The approval is cleared when the token is transferred.
498      *
499      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
500      *
501      * Requirements:
502      *
503      * - The caller must own the token or be an approved operator.
504      * - `tokenId` must exist.
505      *
506      * Emits an {Approval} event.
507      */
508     function approve(address to, uint256 tokenId) external;
509 
510     /**
511      * @dev Returns the account approved for `tokenId` token.
512      *
513      * Requirements:
514      *
515      * - `tokenId` must exist.
516      */
517     function getApproved(uint256 tokenId) external view returns (address operator);
518 
519     /**
520      * @dev Approve or remove `operator` as an operator for the caller.
521      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
522      *
523      * Requirements:
524      *
525      * - The `operator` cannot be the caller.
526      *
527      * Emits an {ApprovalForAll} event.
528      */
529     function setApprovalForAll(address operator, bool _approved) external;
530 
531     /**
532      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
533      *
534      * See {setApprovalForAll}
535      */
536     function isApprovedForAll(address owner, address operator) external view returns (bool);
537 
538     /**
539      * @dev Safely transfers `tokenId` token from `from` to `to`.
540      *
541      * Requirements:
542      *
543      * - `from` cannot be the zero address.
544      * - `to` cannot be the zero address.
545      * - `tokenId` token must exist and be owned by `from`.
546      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
547      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
548      *
549      * Emits a {Transfer} event.
550      */
551     function safeTransferFrom(
552         address from,
553         address to,
554         uint256 tokenId,
555         bytes calldata data
556     ) external;
557 }
558 
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
564  * @dev See https://eips.ethereum.org/EIPS/eip-721
565  */
566 interface IERC721Enumerable is IERC721 {
567     /**
568      * @dev Returns the total amount of tokens stored by the contract.
569      */
570     function totalSupply() external view returns (uint256);
571 
572     /**
573      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
574      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
575      */
576     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
577 
578     /**
579      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
580      * Use along with {totalSupply} to enumerate all tokens.
581      */
582     function tokenByIndex(uint256 index) external view returns (uint256);
583 }
584 
585 
586 pragma solidity ^0.8.0;
587 
588 /**
589  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
590  * @dev See https://eips.ethereum.org/EIPS/eip-721
591  */
592 interface IERC721Metadata is IERC721 {
593     /**
594      * @dev Returns the token collection name.
595      */
596     function name() external view returns (string memory);
597 
598     /**
599      * @dev Returns the token collection symbol.
600      */
601     function symbol() external view returns (string memory);
602 
603     /**
604      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
605      */
606     function tokenURI(uint256 tokenId) external view returns (string memory);
607 }
608 
609 
610 pragma solidity ^0.8.0;
611 
612 /**
613  * @dev Implementation of the {IERC165} interface.
614  *
615  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
616  * for the additional interface id that will be supported. For example:
617  *
618  * ```solidity
619  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
620  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
621  * }
622  * ```
623  *
624  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
625  */
626 abstract contract ERC165 is IERC165 {
627     /**
628      * @dev See {IERC165-supportsInterface}.
629      */
630     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
631         return interfaceId == type(IERC165).interfaceId;
632     }
633 }
634 
635 
636 pragma solidity ^0.8.0;
637 
638 /**
639  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
640  * the Metadata extension, but not including the Enumerable extension, which is available separately as
641  * {ERC721Enumerable}.
642  */
643 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
644     using Address for address;
645     using Strings for uint256;
646 
647     // Token name
648     string private _name;
649 
650     // Token symbol
651     string private _symbol;
652 
653     // Mapping from token ID to owner address
654     mapping(uint256 => address) private _owners;
655 
656     // Mapping owner address to token count
657     mapping(address => uint256) private _balances;
658 
659     // Mapping from token ID to approved address
660     mapping(uint256 => address) private _tokenApprovals;
661 
662     // Mapping from owner to operator approvals
663     mapping(address => mapping(address => bool)) private _operatorApprovals;
664 
665     /**
666      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
667      */
668     constructor(string memory name_, string memory symbol_) {
669         _name = name_;
670         _symbol = symbol_;
671     }
672 
673     /**
674      * @dev See {IERC165-supportsInterface}.
675      */
676     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
677         return
678             interfaceId == type(IERC721).interfaceId ||
679             interfaceId == type(IERC721Metadata).interfaceId ||
680             super.supportsInterface(interfaceId);
681     }
682 
683     /**
684      * @dev See {IERC721-balanceOf}.
685      */
686     function balanceOf(address owner) public view virtual override returns (uint256) {
687         require(owner != address(0), "ERC721: balance query for the zero address");
688         return _balances[owner];
689     }
690 
691     /**
692      * @dev See {IERC721-ownerOf}.
693      */
694     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
695         address owner = _owners[tokenId];
696         require(owner != address(0), "ERC721: owner query for nonexistent token");
697         return owner;
698     }
699 
700     /**
701      * @dev See {IERC721Metadata-name}.
702      */
703     function name() public view virtual override returns (string memory) {
704         return _name;
705     }
706 
707     /**
708      * @dev See {IERC721Metadata-symbol}.
709      */
710     function symbol() public view virtual override returns (string memory) {
711         return _symbol;
712     }
713 
714     /**
715      * @dev See {IERC721Metadata-tokenURI}.
716      */
717     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
718         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
719 
720         string memory baseURI = _baseURI();
721         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
722     }
723 
724     /**
725      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
726      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
727      * by default, can be overriden in child contracts.
728      */
729     function _baseURI() internal view virtual returns (string memory) {
730         return "";
731     }
732 
733     /**
734      * @dev See {IERC721-approve}.
735      */
736     function approve(address to, uint256 tokenId) public virtual override {
737         address owner = ERC721.ownerOf(tokenId);
738         require(to != owner, "ERC721: approval to current owner");
739 
740         require(
741             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
742             "ERC721: approve caller is not owner nor approved for all"
743         );
744 
745         _approve(to, tokenId);
746     }
747 
748     /**
749      * @dev See {IERC721-getApproved}.
750      */
751     function getApproved(uint256 tokenId) public view virtual override returns (address) {
752         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
753 
754         return _tokenApprovals[tokenId];
755     }
756 
757     /**
758      * @dev See {IERC721-setApprovalForAll}.
759      */
760     function setApprovalForAll(address operator, bool approved) public virtual override {
761         require(operator != _msgSender(), "ERC721: approve to caller");
762 
763         _operatorApprovals[_msgSender()][operator] = approved;
764         emit ApprovalForAll(_msgSender(), operator, approved);
765     }
766 
767     /**
768      * @dev See {IERC721-isApprovedForAll}.
769      */
770     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
771         return _operatorApprovals[owner][operator];
772     }
773 
774     /**
775      * @dev See {IERC721-transferFrom}.
776      */
777     function transferFrom(
778         address from,
779         address to,
780         uint256 tokenId
781     ) public virtual override {
782         //solhint-disable-next-line max-line-length
783         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
784 
785         _transfer(from, to, tokenId);
786     }
787 
788     /**
789      * @dev See {IERC721-safeTransferFrom}.
790      */
791     function safeTransferFrom(
792         address from,
793         address to,
794         uint256 tokenId
795     ) public virtual override {
796         safeTransferFrom(from, to, tokenId, "");
797     }
798 
799     /**
800      * @dev See {IERC721-safeTransferFrom}.
801      */
802     function safeTransferFrom(
803         address from,
804         address to,
805         uint256 tokenId,
806         bytes memory _data
807     ) public virtual override {
808         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
809         _safeTransfer(from, to, tokenId, _data);
810     }
811 
812     /**
813      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
814      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
815      *
816      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
817      *
818      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
819      * implement alternative mechanisms to perform token transfer, such as signature-based.
820      *
821      * Requirements:
822      *
823      * - `from` cannot be the zero address.
824      * - `to` cannot be the zero address.
825      * - `tokenId` token must exist and be owned by `from`.
826      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _safeTransfer(
831         address from,
832         address to,
833         uint256 tokenId,
834         bytes memory _data
835     ) internal virtual {
836         _transfer(from, to, tokenId);
837         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
838     }
839 
840     /**
841      * @dev Returns whether `tokenId` exists.
842      *
843      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
844      *
845      * Tokens start existing when they are minted (`_mint`),
846      * and stop existing when they are burned (`_burn`).
847      */
848     function _exists(uint256 tokenId) internal view virtual returns (bool) {
849         return _owners[tokenId] != address(0);
850     }
851 
852     /**
853      * @dev Returns whether `spender` is allowed to manage `tokenId`.
854      *
855      * Requirements:
856      *
857      * - `tokenId` must exist.
858      */
859     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
860         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
861         address owner = ERC721.ownerOf(tokenId);
862         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
863     }
864 
865     /**
866      * @dev Safely mints `tokenId` and transfers it to `to`.
867      *
868      * Requirements:
869      *
870      * - `tokenId` must not exist.
871      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
872      *
873      * Emits a {Transfer} event.
874      */
875     function _safeMint(address to, uint256 tokenId) internal virtual {
876         _safeMint(to, tokenId, "");
877     }
878 
879     /**
880      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
881      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
882      */
883     function _safeMint(
884         address to,
885         uint256 tokenId,
886         bytes memory _data
887     ) internal virtual {
888         _mint(to, tokenId);
889         require(
890             _checkOnERC721Received(address(0), to, tokenId, _data),
891             "ERC721: transfer to non ERC721Receiver implementer"
892         );
893     }
894 
895     /**
896      * @dev Mints `tokenId` and transfers it to `to`.
897      *
898      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
899      *
900      * Requirements:
901      *
902      * - `tokenId` must not exist.
903      * - `to` cannot be the zero address.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _mint(address to, uint256 tokenId) internal virtual {
908         require(to != address(0), "ERC721: mint to the zero address");
909         require(!_exists(tokenId), "ERC721: token already minted");
910 
911         _beforeTokenTransfer(address(0), to, tokenId);
912 
913         _balances[to] += 1;
914         _owners[tokenId] = to;
915 
916         emit Transfer(address(0), to, tokenId);
917     }
918 
919     /**
920      * @dev Destroys `tokenId`.
921      * The approval is cleared when the token is burned.
922      *
923      * Requirements:
924      *
925      * - `tokenId` must exist.
926      *
927      * Emits a {Transfer} event.
928      */
929     function _burn(uint256 tokenId) internal virtual {
930         address owner = ERC721.ownerOf(tokenId);
931 
932         _beforeTokenTransfer(owner, address(0), tokenId);
933 
934         // Clear approvals
935         _approve(address(0), tokenId);
936 
937         _balances[owner] -= 1;
938         delete _owners[tokenId];
939 
940         emit Transfer(owner, address(0), tokenId);
941     }
942 
943     /**
944      * @dev Transfers `tokenId` from `from` to `to`.
945      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
946      *
947      * Requirements:
948      *
949      * - `to` cannot be the zero address.
950      * - `tokenId` token must be owned by `from`.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _transfer(
955         address from,
956         address to,
957         uint256 tokenId
958     ) internal virtual {
959         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
960         require(to != address(0), "ERC721: transfer to the zero address");
961 
962         _beforeTokenTransfer(from, to, tokenId);
963 
964         // Clear approvals from the previous owner
965         _approve(address(0), tokenId);
966 
967         _balances[from] -= 1;
968         _balances[to] += 1;
969         _owners[tokenId] = to;
970 
971         emit Transfer(from, to, tokenId);
972     }
973 
974     /**
975      * @dev Approve `to` to operate on `tokenId`
976      *
977      * Emits a {Approval} event.
978      */
979     function _approve(address to, uint256 tokenId) internal virtual {
980         _tokenApprovals[tokenId] = to;
981         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
982     }
983 
984     /**
985      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
986      * The call is not executed if the target address is not a contract.
987      *
988      * @param from address representing the previous owner of the given token ID
989      * @param to target address that will receive the tokens
990      * @param tokenId uint256 ID of the token to be transferred
991      * @param _data bytes optional data to send along with the call
992      * @return bool whether the call correctly returned the expected magic value
993      */
994     function _checkOnERC721Received(
995         address from,
996         address to,
997         uint256 tokenId,
998         bytes memory _data
999     ) private returns (bool) {
1000         if (to.isContract()) {
1001             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1002                 return retval == IERC721Receiver(to).onERC721Received.selector;
1003             } catch (bytes memory reason) {
1004                 if (reason.length == 0) {
1005                     revert("ERC721: transfer to non ERC721Receiver implementer");
1006                 } else {
1007                     assembly {
1008                         revert(add(32, reason), mload(reason))
1009                     }
1010                 }
1011             }
1012         } else {
1013             return true;
1014         }
1015     }
1016 
1017     /**
1018      * @dev Hook that is called before any token transfer. This includes minting
1019      * and burning.
1020      *
1021      * Calling conditions:
1022      *
1023      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1024      * transferred to `to`.
1025      * - When `from` is zero, `tokenId` will be minted for `to`.
1026      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1027      * - `from` and `to` are never both zero.
1028      *
1029      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1030      */
1031     function _beforeTokenTransfer(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) internal virtual {}
1036 }
1037 
1038 pragma solidity ^0.8.0;
1039 
1040 /**
1041  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1042  * enumerability of all the token ids in the contract as well as all token ids owned by each
1043  * account.
1044  */
1045 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1046     // Mapping from owner to list of owned token IDs
1047     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1048 
1049     // Mapping from token ID to index of the owner tokens list
1050     mapping(uint256 => uint256) private _ownedTokensIndex;
1051 
1052     // Array with all token ids, used for enumeration
1053     uint256[] private _allTokens;
1054 
1055     // Mapping from token id to position in the allTokens array
1056     mapping(uint256 => uint256) private _allTokensIndex;
1057 
1058     /**
1059      * @dev See {IERC165-supportsInterface}.
1060      */
1061     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1062         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1067      */
1068     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1069         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1070         return _ownedTokens[owner][index];
1071     }
1072 
1073     /**
1074      * @dev See {IERC721Enumerable-totalSupply}.
1075      */
1076     function totalSupply() public view virtual override returns (uint256) {
1077         return _allTokens.length;
1078     }
1079 
1080     /**
1081      * @dev See {IERC721Enumerable-tokenByIndex}.
1082      */
1083     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1084         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1085         return _allTokens[index];
1086     }
1087 
1088     /**
1089      * @dev Hook that is called before any token transfer. This includes minting
1090      * and burning.
1091      *
1092      * Calling conditions:
1093      *
1094      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1095      * transferred to `to`.
1096      * - When `from` is zero, `tokenId` will be minted for `to`.
1097      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1098      * - `from` cannot be the zero address.
1099      * - `to` cannot be the zero address.
1100      *
1101      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1102      */
1103     function _beforeTokenTransfer(
1104         address from,
1105         address to,
1106         uint256 tokenId
1107     ) internal virtual override {
1108         super._beforeTokenTransfer(from, to, tokenId);
1109 
1110         if (from == address(0)) {
1111             _addTokenToAllTokensEnumeration(tokenId);
1112         } else if (from != to) {
1113             _removeTokenFromOwnerEnumeration(from, tokenId);
1114         }
1115         if (to == address(0)) {
1116             _removeTokenFromAllTokensEnumeration(tokenId);
1117         } else if (to != from) {
1118             _addTokenToOwnerEnumeration(to, tokenId);
1119         }
1120     }
1121 
1122     /**
1123      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1124      * @param to address representing the new owner of the given token ID
1125      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1126      */
1127     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1128         uint256 length = ERC721.balanceOf(to);
1129         _ownedTokens[to][length] = tokenId;
1130         _ownedTokensIndex[tokenId] = length;
1131     }
1132 
1133     /**
1134      * @dev Private function to add a token to this extension's token tracking data structures.
1135      * @param tokenId uint256 ID of the token to be added to the tokens list
1136      */
1137     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1138         _allTokensIndex[tokenId] = _allTokens.length;
1139         _allTokens.push(tokenId);
1140     }
1141 
1142     /**
1143      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1144      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1145      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1146      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1147      * @param from address representing the previous owner of the given token ID
1148      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1149      */
1150     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1151         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1152         // then delete the last slot (swap and pop).
1153 
1154         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1155         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1156 
1157         // When the token to delete is the last token, the swap operation is unnecessary
1158         if (tokenIndex != lastTokenIndex) {
1159             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1160 
1161             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1162             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1163         }
1164 
1165         // This also deletes the contents at the last position of the array
1166         delete _ownedTokensIndex[tokenId];
1167         delete _ownedTokens[from][lastTokenIndex];
1168     }
1169 
1170     /**
1171      * @dev Private function to remove a token from this extension's token tracking data structures.
1172      * This has O(1) time complexity, but alters the order of the _allTokens array.
1173      * @param tokenId uint256 ID of the token to be removed from the tokens list
1174      */
1175     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1176         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1177         // then delete the last slot (swap and pop).
1178 
1179         uint256 lastTokenIndex = _allTokens.length - 1;
1180         uint256 tokenIndex = _allTokensIndex[tokenId];
1181 
1182         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1183         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1184         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1185         uint256 lastTokenId = _allTokens[lastTokenIndex];
1186 
1187         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1188         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1189 
1190         // This also deletes the contents at the last position of the array
1191         delete _allTokensIndex[tokenId];
1192         _allTokens.pop();
1193     }
1194 }
1195 
1196 pragma solidity ^0.8.0;
1197 
1198 
1199 abstract contract BOTB {
1200     function ownerOf(uint256 tokenId) public virtual view returns (address);
1201     function tokenOfOwnerByIndex(address owner, uint256 index) public virtual view returns (uint256);
1202     function balanceOf(address owner) external virtual view returns (uint256 balance);
1203 }
1204 
1205 contract BearsOnTheBlock is ERC721Enumerable, Ownable{
1206     BOTB private botb;
1207     uint256 public maxBears;
1208     uint constant public MAX_BEARS_MINT = 51;
1209     bool public saleIsActive = false;
1210     uint256 public startingIndex;
1211     uint256 public startingIndexBlock;
1212     uint256 public setBlockTimestamp;
1213     uint256 public revealTimestamp;
1214     string public BearProvenance;
1215     string private baseURI;
1216 
1217     constructor(
1218         string memory name,
1219         string memory symbol,
1220         uint256 maxNftSupply,
1221         address botbContractAddress,
1222         uint256 saleStart
1223     ) ERC721(name, symbol){
1224         maxBears = maxNftSupply;
1225         botb = BOTB(botbContractAddress);
1226         revealTimestamp = saleStart + (86400 * 7);
1227         setBlockTimestamp = saleStart + (86400 * 6);
1228     }
1229 
1230     function setRevealTimestamp(uint256 revealTimeStamp) public onlyOwner {
1231         revealTimestamp = revealTimeStamp;
1232     }
1233 
1234     function setStartingBlockTimestamp(uint256 startingBlockTimestamp) public onlyOwner {
1235         setBlockTimestamp = startingBlockTimestamp;
1236     }
1237 
1238     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1239         BearProvenance = provenanceHash;
1240     }
1241 
1242     function isMinted(uint256 tokenId) external view returns (bool) {
1243         require(tokenId < maxBears, "tokenId outside collection bounds");
1244         return _exists(tokenId);
1245     }
1246 
1247     function _baseURI() internal view override returns (string memory) {
1248         return baseURI;
1249     }
1250 
1251     function setBaseURI(string memory uri) public onlyOwner {
1252         baseURI = uri;
1253     }
1254 
1255     function flipSaleState() public onlyOwner {
1256         saleIsActive = !saleIsActive;
1257     }
1258 
1259     function trySetStartingIndexBlock() private {
1260         if ( startingIndexBlock == 0 && (totalSupply() == maxBears || block.timestamp >= setBlockTimestamp)) {
1261             startingIndexBlock = block.number;
1262         }
1263     }
1264 
1265     function mintBear(uint256 botbTokenId) public {
1266         require(saleIsActive, "Sale must be active to mint a Bear");
1267         require(totalSupply() < maxBears, "Purchase would exceed max supply of Bears");
1268         require(botbTokenId < maxBears, "Requested tokenId exceeds upper bound");
1269         require(botb.ownerOf(botbTokenId) == msg.sender, "Must own the Bull for requested tokenId to claim a Bear");
1270 
1271         _safeMint(msg.sender, botbTokenId);
1272         trySetStartingIndexBlock();
1273     }
1274 
1275     function mintNBears(uint256[] memory tokenIds) public {
1276         require(saleIsActive, "Sale must be active to mint a Bear");
1277         uint length = tokenIds.length;
1278         require(length < MAX_BEARS_MINT, "Cannot claim more than fifty bears at once");
1279         uint balance = botb.balanceOf(msg.sender);
1280         require(balance >= length, "Must hold at least as many Bulls as the number of Bears you intend to claim");
1281 
1282         for(uint i = 0; i < balance && i < length && i < MAX_BEARS_MINT; i++) {
1283             require(totalSupply() < maxBears, "Cannot exceed max supply of Bears.");
1284             uint tokenId = tokenIds[i];
1285             require(botb.ownerOf(tokenId) == msg.sender, "Must own the Bull for requested tokenId to claim a Bear");
1286             if (!_exists(tokenId)) {
1287                 _safeMint(msg.sender, tokenId);
1288             }
1289         }
1290         trySetStartingIndexBlock();
1291     }
1292 
1293     function setStartingIndex() public {
1294         require(startingIndex == 0, "Starting index is already set");
1295         require(startingIndexBlock != 0, "Starting index block must be set");
1296         require(block.timestamp >= revealTimestamp || totalSupply() == maxBears,
1297             "Must be on or after the reveal time to set starting index"
1298         );
1299 
1300         startingIndex = uint256(blockhash(startingIndexBlock)) % maxBears;
1301 
1302         if ((block.number - startingIndexBlock) > 255) {
1303             startingIndex = uint256(blockhash(block.number - 1)) % maxBears;
1304         }
1305 
1306         // Prevent default sequence
1307         if (startingIndex == 0) {
1308             startingIndex = startingIndex + 1;
1309         }
1310     }
1311 
1312     function emergencySetStartingIndexBlock() public onlyOwner {
1313         require(startingIndexBlock == 0, "Starting index block is already set");
1314         require(startingIndex == 0, "Starting index is already set");
1315 
1316         startingIndexBlock = block.number;
1317     }
1318 }