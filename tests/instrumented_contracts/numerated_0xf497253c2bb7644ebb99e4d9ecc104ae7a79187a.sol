1 // SPDX-License-Identifier: MIT
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor() {
52         _setOwner(_msgSender());
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view virtual returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(owner() == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Leaves the contract without owner. It will not be possible to call
72      * `onlyOwner` functions anymore. Can only be called by the current owner.
73      *
74      * NOTE: Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public virtual onlyOwner {
78         _setOwner(address(0));
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Can only be called by the current owner.
84      */
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         _setOwner(newOwner);
88     }
89 
90     function _setOwner(address newOwner) private {
91         address oldOwner = _owner;
92         _owner = newOwner;
93         emit OwnershipTransferred(oldOwner, newOwner);
94     }
95 }
96 
97 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
98 
99 pragma solidity ^0.8.0;
100 
101 /**
102  * @dev Interface of the ERC165 standard, as defined in the
103  * https://eips.ethereum.org/EIPS/eip-165[EIP].
104  *
105  * Implementers can declare support of contract interfaces, which can then be
106  * queried by others ({ERC165Checker}).
107  *
108  * For an implementation, see {ERC165}.
109  */
110 interface IERC165 {
111     /**
112      * @dev Returns true if this contract implements the interface defined by
113      * `interfaceId`. See the corresponding
114      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
115      * to learn more about how these ids are created.
116      *
117      * This function call must use less than 30 000 gas.
118      */
119     function supportsInterface(bytes4 interfaceId) external view returns (bool);
120 }
121 
122 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
123 
124 pragma solidity ^0.8.0;
125 
126 /**
127  * @dev Required interface of an ERC721 compliant contract.
128  */
129 interface IERC721 is IERC165 {
130     /**
131      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
132      */
133     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
134 
135     /**
136      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
137      */
138     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
139 
140     /**
141      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
142      */
143     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
144 
145     /**
146      * @dev Returns the number of tokens in ``owner``'s account.
147      */
148     function balanceOf(address owner) external view returns (uint256 balance);
149 
150     /**
151      * @dev Returns the owner of the `tokenId` token.
152      *
153      * Requirements:
154      *
155      * - `tokenId` must exist.
156      */
157     function ownerOf(uint256 tokenId) external view returns (address owner);
158 
159     /**
160      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
161      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
162      *
163      * Requirements:
164      *
165      * - `from` cannot be the zero address.
166      * - `to` cannot be the zero address.
167      * - `tokenId` token must exist and be owned by `from`.
168      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
169      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
170      *
171      * Emits a {Transfer} event.
172      */
173     function safeTransferFrom(
174         address from,
175         address to,
176         uint256 tokenId
177     ) external;
178 
179     /**
180      * @dev Transfers `tokenId` token from `from` to `to`.
181      *
182      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
183      *
184      * Requirements:
185      *
186      * - `from` cannot be the zero address.
187      * - `to` cannot be the zero address.
188      * - `tokenId` token must be owned by `from`.
189      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
190      *
191      * Emits a {Transfer} event.
192      */
193     function transferFrom(
194         address from,
195         address to,
196         uint256 tokenId
197     ) external;
198 
199     /**
200      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
201      * The approval is cleared when the token is transferred.
202      *
203      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
204      *
205      * Requirements:
206      *
207      * - The caller must own the token or be an approved operator.
208      * - `tokenId` must exist.
209      *
210      * Emits an {Approval} event.
211      */
212     function approve(address to, uint256 tokenId) external;
213 
214     /**
215      * @dev Returns the account approved for `tokenId` token.
216      *
217      * Requirements:
218      *
219      * - `tokenId` must exist.
220      */
221     function getApproved(uint256 tokenId) external view returns (address operator);
222 
223     /**
224      * @dev Approve or remove `operator` as an operator for the caller.
225      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
226      *
227      * Requirements:
228      *
229      * - The `operator` cannot be the caller.
230      *
231      * Emits an {ApprovalForAll} event.
232      */
233     function setApprovalForAll(address operator, bool _approved) external;
234 
235     /**
236      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
237      *
238      * See {setApprovalForAll}
239      */
240     function isApprovedForAll(address owner, address operator) external view returns (bool);
241 
242     /**
243      * @dev Safely transfers `tokenId` token from `from` to `to`.
244      *
245      * Requirements:
246      *
247      * - `from` cannot be the zero address.
248      * - `to` cannot be the zero address.
249      * - `tokenId` token must exist and be owned by `from`.
250      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
251      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
252      *
253      * Emits a {Transfer} event.
254      */
255     function safeTransferFrom(
256         address from,
257         address to,
258         uint256 tokenId,
259         bytes calldata data
260     ) external;
261 }
262 
263 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
264 
265 pragma solidity ^0.8.0;
266 
267 /**
268  * @title ERC721 token receiver interface
269  * @dev Interface for any contract that wants to support safeTransfers
270  * from ERC721 asset contracts.
271  */
272 interface IERC721Receiver {
273     /**
274      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
275      * by `operator` from `from`, this function is called.
276      *
277      * It must return its Solidity selector to confirm the token transfer.
278      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
279      *
280      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
281      */
282     function onERC721Received(
283         address operator,
284         address from,
285         uint256 tokenId,
286         bytes calldata data
287     ) external returns (bytes4);
288 }
289 
290 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
291 
292 pragma solidity ^0.8.0;
293 
294 /**
295  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
296  * @dev See https://eips.ethereum.org/EIPS/eip-721
297  */
298 interface IERC721Metadata is IERC721 {
299     /**
300      * @dev Returns the token collection name.
301      */
302     function name() external view returns (string memory);
303 
304     /**
305      * @dev Returns the token collection symbol.
306      */
307     function symbol() external view returns (string memory);
308 
309     /**
310      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
311      */
312     function tokenURI(uint256 tokenId) external view returns (string memory);
313 }
314 
315 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
316 
317 pragma solidity ^0.8.0;
318 
319 /**
320  * @dev Collection of functions related to the address type
321  */
322 library Address {
323     /**
324      * @dev Returns true if `account` is a contract.
325      *
326      * [IMPORTANT]
327      * ====
328      * It is unsafe to assume that an address for which this function returns
329      * false is an externally-owned account (EOA) and not a contract.
330      *
331      * Among others, `isContract` will return false for the following
332      * types of addresses:
333      *
334      *  - an externally-owned account
335      *  - a contract in construction
336      *  - an address where a contract will be created
337      *  - an address where a contract lived, but was destroyed
338      * ====
339      */
340     function isContract(address account) internal view returns (bool) {
341         // This method relies on extcodesize, which returns 0 for contracts in
342         // construction, since the code is only stored at the end of the
343         // constructor execution.
344 
345         uint256 size;
346         assembly {
347             size := extcodesize(account)
348         }
349         return size > 0;
350     }
351 
352     /**
353      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
354      * `recipient`, forwarding all available gas and reverting on errors.
355      *
356      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
357      * of certain opcodes, possibly making contracts go over the 2300 gas limit
358      * imposed by `transfer`, making them unable to receive funds via
359      * `transfer`. {sendValue} removes this limitation.
360      *
361      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
362      *
363      * IMPORTANT: because control is transferred to `recipient`, care must be
364      * taken to not create reentrancy vulnerabilities. Consider using
365      * {ReentrancyGuard} or the
366      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
367      */
368     function sendValue(address payable recipient, uint256 amount) internal {
369         require(address(this).balance >= amount, "Address: insufficient balance");
370 
371         (bool success, ) = recipient.call{value: amount}("");
372         require(success, "Address: unable to send value, recipient may have reverted");
373     }
374 
375     /**
376      * @dev Performs a Solidity function call using a low level `call`. A
377      * plain `call` is an unsafe replacement for a function call: use this
378      * function instead.
379      *
380      * If `target` reverts with a revert reason, it is bubbled up by this
381      * function (like regular Solidity function calls).
382      *
383      * Returns the raw returned data. To convert to the expected return value,
384      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
385      *
386      * Requirements:
387      *
388      * - `target` must be a contract.
389      * - calling `target` with `data` must not revert.
390      *
391      * _Available since v3.1._
392      */
393     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
394         return functionCall(target, data, "Address: low-level call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
399      * `errorMessage` as a fallback revert reason when `target` reverts.
400      *
401      * _Available since v3.1._
402      */
403     function functionCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, 0, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but also transferring `value` wei to `target`.
414      *
415      * Requirements:
416      *
417      * - the calling contract must have an ETH balance of at least `value`.
418      * - the called Solidity function must be `payable`.
419      *
420      * _Available since v3.1._
421      */
422     function functionCallWithValue(
423         address target,
424         bytes memory data,
425         uint256 value
426     ) internal returns (bytes memory) {
427         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
432      * with `errorMessage` as a fallback revert reason when `target` reverts.
433      *
434      * _Available since v3.1._
435      */
436     function functionCallWithValue(
437         address target,
438         bytes memory data,
439         uint256 value,
440         string memory errorMessage
441     ) internal returns (bytes memory) {
442         require(address(this).balance >= value, "Address: insufficient balance for call");
443         require(isContract(target), "Address: call to non-contract");
444 
445         (bool success, bytes memory returndata) = target.call{value: value}(data);
446         return _verifyCallResult(success, returndata, errorMessage);
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
451      * but performing a static call.
452      *
453      * _Available since v3.3._
454      */
455     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
456         return functionStaticCall(target, data, "Address: low-level static call failed");
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
461      * but performing a static call.
462      *
463      * _Available since v3.3._
464      */
465     function functionStaticCall(
466         address target,
467         bytes memory data,
468         string memory errorMessage
469     ) internal view returns (bytes memory) {
470         require(isContract(target), "Address: static call to non-contract");
471 
472         (bool success, bytes memory returndata) = target.staticcall(data);
473         return _verifyCallResult(success, returndata, errorMessage);
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
478      * but performing a delegate call.
479      *
480      * _Available since v3.4._
481      */
482     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
483         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
488      * but performing a delegate call.
489      *
490      * _Available since v3.4._
491      */
492     function functionDelegateCall(
493         address target,
494         bytes memory data,
495         string memory errorMessage
496     ) internal returns (bytes memory) {
497         require(isContract(target), "Address: delegate call to non-contract");
498 
499         (bool success, bytes memory returndata) = target.delegatecall(data);
500         return _verifyCallResult(success, returndata, errorMessage);
501     }
502 
503     function _verifyCallResult(
504         bool success,
505         bytes memory returndata,
506         string memory errorMessage
507     ) private pure returns (bytes memory) {
508         if (success) {
509             return returndata;
510         } else {
511             // Look for revert reason and bubble it up if present
512             if (returndata.length > 0) {
513                 // The easiest way to bubble the revert reason is using memory via assembly
514 
515                 assembly {
516                     let returndata_size := mload(returndata)
517                     revert(add(32, returndata), returndata_size)
518                 }
519             } else {
520                 revert(errorMessage);
521             }
522         }
523     }
524 }
525 
526 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
527 
528 pragma solidity ^0.8.0;
529 
530 /**
531  * @dev String operations.
532  */
533 library Strings {
534     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
535 
536     /**
537      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
538      */
539     function toString(uint256 value) internal pure returns (string memory) {
540         // Inspired by OraclizeAPI's implementation - MIT licence
541         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
542 
543         if (value == 0) {
544             return "0";
545         }
546         uint256 temp = value;
547         uint256 digits;
548         while (temp != 0) {
549             digits++;
550             temp /= 10;
551         }
552         bytes memory buffer = new bytes(digits);
553         while (value != 0) {
554             digits -= 1;
555             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
556             value /= 10;
557         }
558         return string(buffer);
559     }
560 
561     /**
562      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
563      */
564     function toHexString(uint256 value) internal pure returns (string memory) {
565         if (value == 0) {
566             return "0x00";
567         }
568         uint256 temp = value;
569         uint256 length = 0;
570         while (temp != 0) {
571             length++;
572             temp >>= 8;
573         }
574         return toHexString(value, length);
575     }
576 
577     /**
578      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
579      */
580     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
581         bytes memory buffer = new bytes(2 * length + 2);
582         buffer[0] = "0";
583         buffer[1] = "x";
584         for (uint256 i = 2 * length + 1; i > 1; --i) {
585             buffer[i] = _HEX_SYMBOLS[value & 0xf];
586             value >>= 4;
587         }
588         require(value == 0, "Strings: hex length insufficient");
589         return string(buffer);
590     }
591 }
592 
593 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
594 
595 pragma solidity ^0.8.0;
596 
597 /**
598  * @dev Implementation of the {IERC165} interface.
599  *
600  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
601  * for the additional interface id that will be supported. For example:
602  *
603  * ```solidity
604  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
605  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
606  * }
607  * ```
608  *
609  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
610  */
611 abstract contract ERC165 is IERC165 {
612     /**
613      * @dev See {IERC165-supportsInterface}.
614      */
615     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
616         return interfaceId == type(IERC165).interfaceId;
617     }
618 }
619 
620 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.2.0
621 
622 pragma solidity ^0.8.0;
623 
624 /**
625  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
626  * the Metadata extension, but not including the Enumerable extension, which is available separately as
627  * {ERC721Enumerable}.
628  */
629 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
630     using Address for address;
631     using Strings for uint256;
632 
633     // Token name
634     string private _name;
635 
636     // Token symbol
637     string private _symbol;
638 
639     // Mapping from token ID to owner address
640     mapping(uint256 => address) private _owners;
641 
642     // Mapping owner address to token count
643     mapping(address => uint256) private _balances;
644 
645     // Mapping from token ID to approved address
646     mapping(uint256 => address) private _tokenApprovals;
647 
648     // Mapping from owner to operator approvals
649     mapping(address => mapping(address => bool)) private _operatorApprovals;
650 
651     /**
652      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
653      */
654     constructor(string memory name_, string memory symbol_) {
655         _name = name_;
656         _symbol = symbol_;
657     }
658 
659     /**
660      * @dev See {IERC165-supportsInterface}.
661      */
662     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
663         return
664             interfaceId == type(IERC721).interfaceId ||
665             interfaceId == type(IERC721Metadata).interfaceId ||
666             super.supportsInterface(interfaceId);
667     }
668 
669     /**
670      * @dev See {IERC721-balanceOf}.
671      */
672     function balanceOf(address owner) public view virtual override returns (uint256) {
673         require(owner != address(0), "ERC721: balance query for the zero address");
674         return _balances[owner];
675     }
676 
677     /**
678      * @dev See {IERC721-ownerOf}.
679      */
680     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
681         address owner = _owners[tokenId];
682         require(owner != address(0), "ERC721: owner query for nonexistent token");
683         return owner;
684     }
685 
686     /**
687      * @dev See {IERC721Metadata-name}.
688      */
689     function name() public view virtual override returns (string memory) {
690         return _name;
691     }
692 
693     /**
694      * @dev See {IERC721Metadata-symbol}.
695      */
696     function symbol() public view virtual override returns (string memory) {
697         return _symbol;
698     }
699 
700     /**
701      * @dev See {IERC721Metadata-tokenURI}.
702      */
703     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
704         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
705 
706         string memory baseURI = _baseURI();
707         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
708     }
709 
710     /**
711      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
712      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
713      * by default, can be overriden in child contracts.
714      */
715     function _baseURI() internal view virtual returns (string memory) {
716         return "";
717     }
718 
719     /**
720      * @dev See {IERC721-approve}.
721      */
722     function approve(address to, uint256 tokenId) public virtual override {
723         address owner = ERC721.ownerOf(tokenId);
724         require(to != owner, "ERC721: approval to current owner");
725 
726         require(
727             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
728             "ERC721: approve caller is not owner nor approved for all"
729         );
730 
731         _approve(to, tokenId);
732     }
733 
734     /**
735      * @dev See {IERC721-getApproved}.
736      */
737     function getApproved(uint256 tokenId) public view virtual override returns (address) {
738         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
739 
740         return _tokenApprovals[tokenId];
741     }
742 
743     /**
744      * @dev See {IERC721-setApprovalForAll}.
745      */
746     function setApprovalForAll(address operator, bool approved) public virtual override {
747         require(operator != _msgSender(), "ERC721: approve to caller");
748 
749         _operatorApprovals[_msgSender()][operator] = approved;
750         emit ApprovalForAll(_msgSender(), operator, approved);
751     }
752 
753     /**
754      * @dev See {IERC721-isApprovedForAll}.
755      */
756     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
757         return _operatorApprovals[owner][operator];
758     }
759 
760     /**
761      * @dev See {IERC721-transferFrom}.
762      */
763     function transferFrom(
764         address from,
765         address to,
766         uint256 tokenId
767     ) public virtual override {
768         //solhint-disable-next-line max-line-length
769         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
770 
771         _transfer(from, to, tokenId);
772     }
773 
774     /**
775      * @dev See {IERC721-safeTransferFrom}.
776      */
777     function safeTransferFrom(
778         address from,
779         address to,
780         uint256 tokenId
781     ) public virtual override {
782         safeTransferFrom(from, to, tokenId, "");
783     }
784 
785     /**
786      * @dev See {IERC721-safeTransferFrom}.
787      */
788     function safeTransferFrom(
789         address from,
790         address to,
791         uint256 tokenId,
792         bytes memory _data
793     ) public virtual override {
794         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
795         _safeTransfer(from, to, tokenId, _data);
796     }
797 
798     /**
799      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
800      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
801      *
802      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
803      *
804      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
805      * implement alternative mechanisms to perform token transfer, such as signature-based.
806      *
807      * Requirements:
808      *
809      * - `from` cannot be the zero address.
810      * - `to` cannot be the zero address.
811      * - `tokenId` token must exist and be owned by `from`.
812      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
813      *
814      * Emits a {Transfer} event.
815      */
816     function _safeTransfer(
817         address from,
818         address to,
819         uint256 tokenId,
820         bytes memory _data
821     ) internal virtual {
822         _transfer(from, to, tokenId);
823         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
824     }
825 
826     /**
827      * @dev Returns whether `tokenId` exists.
828      *
829      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
830      *
831      * Tokens start existing when they are minted (`_mint`),
832      * and stop existing when they are burned (`_burn`).
833      */
834     function _exists(uint256 tokenId) internal view virtual returns (bool) {
835         return _owners[tokenId] != address(0);
836     }
837 
838     /**
839      * @dev Returns whether `spender` is allowed to manage `tokenId`.
840      *
841      * Requirements:
842      *
843      * - `tokenId` must exist.
844      */
845     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
846         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
847         address owner = ERC721.ownerOf(tokenId);
848         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
849     }
850 
851     /**
852      * @dev Safely mints `tokenId` and transfers it to `to`.
853      *
854      * Requirements:
855      *
856      * - `tokenId` must not exist.
857      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
858      *
859      * Emits a {Transfer} event.
860      */
861     function _safeMint(address to, uint256 tokenId) internal virtual {
862         _safeMint(to, tokenId, "");
863     }
864 
865     /**
866      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
867      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
868      */
869     function _safeMint(
870         address to,
871         uint256 tokenId,
872         bytes memory _data
873     ) internal virtual {
874         _mint(to, tokenId);
875         require(
876             _checkOnERC721Received(address(0), to, tokenId, _data),
877             "ERC721: transfer to non ERC721Receiver implementer"
878         );
879     }
880 
881     /**
882      * @dev Mints `tokenId` and transfers it to `to`.
883      *
884      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
885      *
886      * Requirements:
887      *
888      * - `tokenId` must not exist.
889      * - `to` cannot be the zero address.
890      *
891      * Emits a {Transfer} event.
892      */
893     function _mint(address to, uint256 tokenId) internal virtual {
894         require(to != address(0), "ERC721: mint to the zero address");
895         require(!_exists(tokenId), "ERC721: token already minted");
896 
897         _beforeTokenTransfer(address(0), to, tokenId);
898 
899         _balances[to] += 1;
900         _owners[tokenId] = to;
901 
902         emit Transfer(address(0), to, tokenId);
903     }
904 
905     /**
906      * @dev Destroys `tokenId`.
907      * The approval is cleared when the token is burned.
908      *
909      * Requirements:
910      *
911      * - `tokenId` must exist.
912      *
913      * Emits a {Transfer} event.
914      */
915     function _burn(uint256 tokenId) internal virtual {
916         address owner = ERC721.ownerOf(tokenId);
917 
918         _beforeTokenTransfer(owner, address(0), tokenId);
919 
920         // Clear approvals
921         _approve(address(0), tokenId);
922 
923         _balances[owner] -= 1;
924         delete _owners[tokenId];
925 
926         emit Transfer(owner, address(0), tokenId);
927     }
928 
929     /**
930      * @dev Transfers `tokenId` from `from` to `to`.
931      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
932      *
933      * Requirements:
934      *
935      * - `to` cannot be the zero address.
936      * - `tokenId` token must be owned by `from`.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _transfer(
941         address from,
942         address to,
943         uint256 tokenId
944     ) internal virtual {
945         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
946         require(to != address(0), "ERC721: transfer to the zero address");
947 
948         _beforeTokenTransfer(from, to, tokenId);
949 
950         // Clear approvals from the previous owner
951         _approve(address(0), tokenId);
952 
953         _balances[from] -= 1;
954         _balances[to] += 1;
955         _owners[tokenId] = to;
956 
957         emit Transfer(from, to, tokenId);
958     }
959 
960     /**
961      * @dev Approve `to` to operate on `tokenId`
962      *
963      * Emits a {Approval} event.
964      */
965     function _approve(address to, uint256 tokenId) internal virtual {
966         _tokenApprovals[tokenId] = to;
967         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
968     }
969 
970     /**
971      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
972      * The call is not executed if the target address is not a contract.
973      *
974      * @param from address representing the previous owner of the given token ID
975      * @param to target address that will receive the tokens
976      * @param tokenId uint256 ID of the token to be transferred
977      * @param _data bytes optional data to send along with the call
978      * @return bool whether the call correctly returned the expected magic value
979      */
980     function _checkOnERC721Received(
981         address from,
982         address to,
983         uint256 tokenId,
984         bytes memory _data
985     ) private returns (bool) {
986         if (to.isContract()) {
987             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
988                 return retval == IERC721Receiver(to).onERC721Received.selector;
989             } catch (bytes memory reason) {
990                 if (reason.length == 0) {
991                     revert("ERC721: transfer to non ERC721Receiver implementer");
992                 } else {
993                     assembly {
994                         revert(add(32, reason), mload(reason))
995                     }
996                 }
997             }
998         } else {
999             return true;
1000         }
1001     }
1002 
1003     /**
1004      * @dev Hook that is called before any token transfer. This includes minting
1005      * and burning.
1006      *
1007      * Calling conditions:
1008      *
1009      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1010      * transferred to `to`.
1011      * - When `from` is zero, `tokenId` will be minted for `to`.
1012      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1013      * - `from` and `to` are never both zero.
1014      *
1015      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1016      */
1017     function _beforeTokenTransfer(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) internal virtual {}
1022 }
1023 
1024 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
1025 
1026 pragma solidity ^0.8.0;
1027 
1028 /**
1029  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1030  * @dev See https://eips.ethereum.org/EIPS/eip-721
1031  */
1032 interface IERC721Enumerable is IERC721 {
1033     /**
1034      * @dev Returns the total amount of tokens stored by the contract.
1035      */
1036     function totalSupply() external view returns (uint256);
1037 
1038     /**
1039      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1040      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1041      */
1042     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1043 
1044     /**
1045      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1046      * Use along with {totalSupply} to enumerate all tokens.
1047      */
1048     function tokenByIndex(uint256 index) external view returns (uint256);
1049 }
1050 
1051 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.2.0
1052 
1053 pragma solidity ^0.8.0;
1054 
1055 /**
1056  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1057  * enumerability of all the token ids in the contract as well as all token ids owned by each
1058  * account.
1059  */
1060 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1061     // Mapping from owner to list of owned token IDs
1062     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1063 
1064     // Mapping from token ID to index of the owner tokens list
1065     mapping(uint256 => uint256) private _ownedTokensIndex;
1066 
1067     // Array with all token ids, used for enumeration
1068     uint256[] private _allTokens;
1069 
1070     // Mapping from token id to position in the allTokens array
1071     mapping(uint256 => uint256) private _allTokensIndex;
1072 
1073     /**
1074      * @dev See {IERC165-supportsInterface}.
1075      */
1076     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1077         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1078     }
1079 
1080     /**
1081      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1082      */
1083     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1084         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1085         return _ownedTokens[owner][index];
1086     }
1087 
1088     /**
1089      * @dev See {IERC721Enumerable-totalSupply}.
1090      */
1091     function totalSupply() public view virtual override returns (uint256) {
1092         return _allTokens.length;
1093     }
1094 
1095     /**
1096      * @dev See {IERC721Enumerable-tokenByIndex}.
1097      */
1098     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1099         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1100         return _allTokens[index];
1101     }
1102 
1103     /**
1104      * @dev Hook that is called before any token transfer. This includes minting
1105      * and burning.
1106      *
1107      * Calling conditions:
1108      *
1109      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1110      * transferred to `to`.
1111      * - When `from` is zero, `tokenId` will be minted for `to`.
1112      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1113      * - `from` cannot be the zero address.
1114      * - `to` cannot be the zero address.
1115      *
1116      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1117      */
1118     function _beforeTokenTransfer(
1119         address from,
1120         address to,
1121         uint256 tokenId
1122     ) internal virtual override {
1123         super._beforeTokenTransfer(from, to, tokenId);
1124 
1125         if (from == address(0)) {
1126             _addTokenToAllTokensEnumeration(tokenId);
1127         } else if (from != to) {
1128             _removeTokenFromOwnerEnumeration(from, tokenId);
1129         }
1130         if (to == address(0)) {
1131             _removeTokenFromAllTokensEnumeration(tokenId);
1132         } else if (to != from) {
1133             _addTokenToOwnerEnumeration(to, tokenId);
1134         }
1135     }
1136 
1137     /**
1138      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1139      * @param to address representing the new owner of the given token ID
1140      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1141      */
1142     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1143         uint256 length = ERC721.balanceOf(to);
1144         _ownedTokens[to][length] = tokenId;
1145         _ownedTokensIndex[tokenId] = length;
1146     }
1147 
1148     /**
1149      * @dev Private function to add a token to this extension's token tracking data structures.
1150      * @param tokenId uint256 ID of the token to be added to the tokens list
1151      */
1152     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1153         _allTokensIndex[tokenId] = _allTokens.length;
1154         _allTokens.push(tokenId);
1155     }
1156 
1157     /**
1158      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1159      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1160      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1161      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1162      * @param from address representing the previous owner of the given token ID
1163      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1164      */
1165     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1166         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1167         // then delete the last slot (swap and pop).
1168 
1169         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1170         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1171 
1172         // When the token to delete is the last token, the swap operation is unnecessary
1173         if (tokenIndex != lastTokenIndex) {
1174             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1175 
1176             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1177             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1178         }
1179 
1180         // This also deletes the contents at the last position of the array
1181         delete _ownedTokensIndex[tokenId];
1182         delete _ownedTokens[from][lastTokenIndex];
1183     }
1184 
1185     /**
1186      * @dev Private function to remove a token from this extension's token tracking data structures.
1187      * This has O(1) time complexity, but alters the order of the _allTokens array.
1188      * @param tokenId uint256 ID of the token to be removed from the tokens list
1189      */
1190     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1191         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1192         // then delete the last slot (swap and pop).
1193 
1194         uint256 lastTokenIndex = _allTokens.length - 1;
1195         uint256 tokenIndex = _allTokensIndex[tokenId];
1196 
1197         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1198         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1199         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1200         uint256 lastTokenId = _allTokens[lastTokenIndex];
1201 
1202         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1203         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1204 
1205         // This also deletes the contents at the last position of the array
1206         delete _allTokensIndex[tokenId];
1207         _allTokens.pop();
1208     }
1209 }
1210 
1211 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.2.0
1212 
1213 pragma solidity ^0.8.0;
1214 
1215 /**
1216  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1217  *
1218  * These functions can be used to verify that a message was signed by the holder
1219  * of the private keys of a given address.
1220  */
1221 library ECDSA {
1222     /**
1223      * @dev Returns the address that signed a hashed message (`hash`) with
1224      * `signature`. This address can then be used for verification purposes.
1225      *
1226      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1227      * this function rejects them by requiring the `s` value to be in the lower
1228      * half order, and the `v` value to be either 27 or 28.
1229      *
1230      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1231      * verification to be secure: it is possible to craft signatures that
1232      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1233      * this is by receiving a hash of the original message (which may otherwise
1234      * be too long), and then calling {toEthSignedMessageHash} on it.
1235      *
1236      * Documentation for signature generation:
1237      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1238      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1239      */
1240     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1241         // Check the signature length
1242         // - case 65: r,s,v signature (standard)
1243         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1244         if (signature.length == 65) {
1245             bytes32 r;
1246             bytes32 s;
1247             uint8 v;
1248             // ecrecover takes the signature parameters, and the only way to get them
1249             // currently is to use assembly.
1250             assembly {
1251                 r := mload(add(signature, 0x20))
1252                 s := mload(add(signature, 0x40))
1253                 v := byte(0, mload(add(signature, 0x60)))
1254             }
1255             return recover(hash, v, r, s);
1256         } else if (signature.length == 64) {
1257             bytes32 r;
1258             bytes32 vs;
1259             // ecrecover takes the signature parameters, and the only way to get them
1260             // currently is to use assembly.
1261             assembly {
1262                 r := mload(add(signature, 0x20))
1263                 vs := mload(add(signature, 0x40))
1264             }
1265             return recover(hash, r, vs);
1266         } else {
1267             revert("ECDSA: invalid signature length");
1268         }
1269     }
1270 
1271     /**
1272      * @dev Overload of {ECDSA-recover} that receives the `r` and `vs` short-signature fields separately.
1273      *
1274      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1275      *
1276      * _Available since v4.2._
1277      */
1278     function recover(
1279         bytes32 hash,
1280         bytes32 r,
1281         bytes32 vs
1282     ) internal pure returns (address) {
1283         bytes32 s;
1284         uint8 v;
1285         assembly {
1286             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1287             v := add(shr(255, vs), 27)
1288         }
1289         return recover(hash, v, r, s);
1290     }
1291 
1292     /**
1293      * @dev Overload of {ECDSA-recover} that receives the `v`, `r` and `s` signature fields separately.
1294      */
1295     function recover(
1296         bytes32 hash,
1297         uint8 v,
1298         bytes32 r,
1299         bytes32 s
1300     ) internal pure returns (address) {
1301         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1302         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1303         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1304         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1305         //
1306         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1307         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1308         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1309         // these malleable signatures as well.
1310         require(
1311             uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
1312             "ECDSA: invalid signature 's' value"
1313         );
1314         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
1315 
1316         // If the signature is valid (and not malleable), return the signer address
1317         address signer = ecrecover(hash, v, r, s);
1318         require(signer != address(0), "ECDSA: invalid signature");
1319 
1320         return signer;
1321     }
1322 
1323     /**
1324      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1325      * produces hash corresponding to the one signed with the
1326      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1327      * JSON-RPC method as part of EIP-191.
1328      *
1329      * See {recover}.
1330      */
1331     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1332         // 32 is the length in bytes of hash,
1333         // enforced by the type signature above
1334         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1335     }
1336 
1337     /**
1338      * @dev Returns an Ethereum Signed Typed Data, created from a
1339      * `domainSeparator` and a `structHash`. This produces hash corresponding
1340      * to the one signed with the
1341      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1342      * JSON-RPC method as part of EIP-712.
1343      *
1344      * See {recover}.
1345      */
1346     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1347         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1348     }
1349 }
1350 
1351 // File @openzeppelin/contracts/utils/math/SafeCast.sol@v4.2.0
1352 
1353 pragma solidity ^0.8.0;
1354 
1355 /**
1356  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1357  * checks.
1358  *
1359  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1360  * easily result in undesired exploitation or bugs, since developers usually
1361  * assume that overflows raise errors. `SafeCast` restores this intuition by
1362  * reverting the transaction when such an operation overflows.
1363  *
1364  * Using this library instead of the unchecked operations eliminates an entire
1365  * class of bugs, so it's recommended to use it always.
1366  *
1367  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1368  * all math on `uint256` and `int256` and then downcasting.
1369  */
1370 library SafeCast {
1371     /**
1372      * @dev Returns the downcasted uint224 from uint256, reverting on
1373      * overflow (when the input is greater than largest uint224).
1374      *
1375      * Counterpart to Solidity's `uint224` operator.
1376      *
1377      * Requirements:
1378      *
1379      * - input must fit into 224 bits
1380      */
1381     function toUint224(uint256 value) internal pure returns (uint224) {
1382         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
1383         return uint224(value);
1384     }
1385 
1386     /**
1387      * @dev Returns the downcasted uint128 from uint256, reverting on
1388      * overflow (when the input is greater than largest uint128).
1389      *
1390      * Counterpart to Solidity's `uint128` operator.
1391      *
1392      * Requirements:
1393      *
1394      * - input must fit into 128 bits
1395      */
1396     function toUint128(uint256 value) internal pure returns (uint128) {
1397         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
1398         return uint128(value);
1399     }
1400 
1401     /**
1402      * @dev Returns the downcasted uint96 from uint256, reverting on
1403      * overflow (when the input is greater than largest uint96).
1404      *
1405      * Counterpart to Solidity's `uint96` operator.
1406      *
1407      * Requirements:
1408      *
1409      * - input must fit into 96 bits
1410      */
1411     function toUint96(uint256 value) internal pure returns (uint96) {
1412         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
1413         return uint96(value);
1414     }
1415 
1416     /**
1417      * @dev Returns the downcasted uint64 from uint256, reverting on
1418      * overflow (when the input is greater than largest uint64).
1419      *
1420      * Counterpart to Solidity's `uint64` operator.
1421      *
1422      * Requirements:
1423      *
1424      * - input must fit into 64 bits
1425      */
1426     function toUint64(uint256 value) internal pure returns (uint64) {
1427         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
1428         return uint64(value);
1429     }
1430 
1431     /**
1432      * @dev Returns the downcasted uint32 from uint256, reverting on
1433      * overflow (when the input is greater than largest uint32).
1434      *
1435      * Counterpart to Solidity's `uint32` operator.
1436      *
1437      * Requirements:
1438      *
1439      * - input must fit into 32 bits
1440      */
1441     function toUint32(uint256 value) internal pure returns (uint32) {
1442         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
1443         return uint32(value);
1444     }
1445 
1446     /**
1447      * @dev Returns the downcasted uint16 from uint256, reverting on
1448      * overflow (when the input is greater than largest uint16).
1449      *
1450      * Counterpart to Solidity's `uint16` operator.
1451      *
1452      * Requirements:
1453      *
1454      * - input must fit into 16 bits
1455      */
1456     function toUint16(uint256 value) internal pure returns (uint16) {
1457         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
1458         return uint16(value);
1459     }
1460 
1461     /**
1462      * @dev Returns the downcasted uint8 from uint256, reverting on
1463      * overflow (when the input is greater than largest uint8).
1464      *
1465      * Counterpart to Solidity's `uint8` operator.
1466      *
1467      * Requirements:
1468      *
1469      * - input must fit into 8 bits.
1470      */
1471     function toUint8(uint256 value) internal pure returns (uint8) {
1472         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
1473         return uint8(value);
1474     }
1475 
1476     /**
1477      * @dev Converts a signed int256 into an unsigned uint256.
1478      *
1479      * Requirements:
1480      *
1481      * - input must be greater than or equal to 0.
1482      */
1483     function toUint256(int256 value) internal pure returns (uint256) {
1484         require(value >= 0, "SafeCast: value must be positive");
1485         return uint256(value);
1486     }
1487 
1488     /**
1489      * @dev Returns the downcasted int128 from int256, reverting on
1490      * overflow (when the input is less than smallest int128 or
1491      * greater than largest int128).
1492      *
1493      * Counterpart to Solidity's `int128` operator.
1494      *
1495      * Requirements:
1496      *
1497      * - input must fit into 128 bits
1498      *
1499      * _Available since v3.1._
1500      */
1501     function toInt128(int256 value) internal pure returns (int128) {
1502         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
1503         return int128(value);
1504     }
1505 
1506     /**
1507      * @dev Returns the downcasted int64 from int256, reverting on
1508      * overflow (when the input is less than smallest int64 or
1509      * greater than largest int64).
1510      *
1511      * Counterpart to Solidity's `int64` operator.
1512      *
1513      * Requirements:
1514      *
1515      * - input must fit into 64 bits
1516      *
1517      * _Available since v3.1._
1518      */
1519     function toInt64(int256 value) internal pure returns (int64) {
1520         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
1521         return int64(value);
1522     }
1523 
1524     /**
1525      * @dev Returns the downcasted int32 from int256, reverting on
1526      * overflow (when the input is less than smallest int32 or
1527      * greater than largest int32).
1528      *
1529      * Counterpart to Solidity's `int32` operator.
1530      *
1531      * Requirements:
1532      *
1533      * - input must fit into 32 bits
1534      *
1535      * _Available since v3.1._
1536      */
1537     function toInt32(int256 value) internal pure returns (int32) {
1538         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
1539         return int32(value);
1540     }
1541 
1542     /**
1543      * @dev Returns the downcasted int16 from int256, reverting on
1544      * overflow (when the input is less than smallest int16 or
1545      * greater than largest int16).
1546      *
1547      * Counterpart to Solidity's `int16` operator.
1548      *
1549      * Requirements:
1550      *
1551      * - input must fit into 16 bits
1552      *
1553      * _Available since v3.1._
1554      */
1555     function toInt16(int256 value) internal pure returns (int16) {
1556         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
1557         return int16(value);
1558     }
1559 
1560     /**
1561      * @dev Returns the downcasted int8 from int256, reverting on
1562      * overflow (when the input is less than smallest int8 or
1563      * greater than largest int8).
1564      *
1565      * Counterpart to Solidity's `int8` operator.
1566      *
1567      * Requirements:
1568      *
1569      * - input must fit into 8 bits.
1570      *
1571      * _Available since v3.1._
1572      */
1573     function toInt8(int256 value) internal pure returns (int8) {
1574         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
1575         return int8(value);
1576     }
1577 
1578     /**
1579      * @dev Converts an unsigned uint256 into a signed int256.
1580      *
1581      * Requirements:
1582      *
1583      * - input must be less than or equal to maxInt256.
1584      */
1585     function toInt256(uint256 value) internal pure returns (int256) {
1586         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
1587         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
1588         return int256(value);
1589     }
1590 }
1591 
1592 // File contracts/TheSevens.sol
1593 
1594 pragma solidity =0.8.7;
1595 
1596 contract TheSevens is ERC721Enumerable, Ownable {
1597     using ECDSA for bytes32;
1598     using SafeCast for uint256;
1599 
1600     event TokenPriceChanged(uint256 newTokenPrice);
1601     event PresaleConfigChanged(address whitelistSigner, uint32 startTime, uint32 endTime);
1602     event SaleConfigChanged(uint32 startTime, uint32 initMaxCount, uint32 maxCountUnlockTime, uint32 unlockedMaxCount);
1603     event IsBurnEnabledChanged(bool newIsBurnEnabled);
1604     event TreasuryChanged(address newTreasury);
1605     event BaseURIChanged(string newBaseURI);
1606     event PresaleMint(address minter, uint256 count);
1607     event SaleMint(address minter, uint256 count);
1608 
1609     // Both structs fit in a single storage slot for gas optimization
1610     struct PresaleConfig {
1611         address whitelistSigner;
1612         uint32 startTime;
1613         uint32 endTime;
1614     }
1615     struct SaleConfig {
1616         uint32 startTime;
1617         uint32 initMaxCount;
1618         uint32 maxCountUnlockTime;
1619         uint32 unlockedMaxCount;
1620     }
1621 
1622     uint256 public immutable maxSupply;
1623     uint256 public immutable reserveCount;
1624 
1625     uint256 public tokensReserved;
1626     uint256 public nextTokenId;
1627     bool public isBurnEnabled;
1628     address payable public treasury;
1629 
1630     uint256 public tokenPrice;
1631 
1632     PresaleConfig public presaleConfig;
1633     mapping(address => uint256) public presaleBoughtCounts;
1634 
1635     SaleConfig public saleConfig;
1636 
1637     string public baseURI;
1638 
1639     bytes32 public DOMAIN_SEPARATOR;
1640     bytes32 public constant PRESALE_TYPEHASH = keccak256("Presale(address buyer,uint256 maxCount)");
1641 
1642     constructor(uint256 _maxSupply, uint256 _reserveCount) ERC721("Sevens Token", "SEVENS") {
1643         require(_reserveCount <= _maxSupply, "TheSevens: reserve count out of range");
1644 
1645         maxSupply = _maxSupply;
1646         reserveCount = _reserveCount;
1647 
1648         uint256 chainId;
1649         assembly {
1650             chainId := chainid()
1651         }
1652         DOMAIN_SEPARATOR = keccak256(
1653             abi.encode(
1654                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
1655                 keccak256(bytes("The Sevens")),
1656                 keccak256(bytes("1")),
1657                 chainId,
1658                 address(this)
1659             )
1660         );
1661     }
1662 
1663     function reserveTokens(address recipient, uint256 count) external onlyOwner {
1664         require(recipient != address(0), "TheSevens: zero address");
1665 
1666         // Gas optimization
1667         uint256 _nextTokenId = nextTokenId;
1668 
1669         require(count > 0, "TheSevens: invalid count");
1670         require(_nextTokenId + count <= maxSupply, "TheSevens: max supply exceeded");
1671 
1672         require(tokensReserved + count <= reserveCount, "TheSevens: max reserve count exceeded");
1673         tokensReserved += count;
1674 
1675         for (uint256 ind = 0; ind < count; ind++) {
1676             _safeMint(recipient, _nextTokenId + ind);
1677         }
1678         nextTokenId += count;
1679     }
1680 
1681     function setTokenPrice(uint256 _tokenPrice) external onlyOwner {
1682         tokenPrice = _tokenPrice;
1683         emit TokenPriceChanged(_tokenPrice);
1684     }
1685 
1686     function setUpPresale(
1687         address whitelistSigner,
1688         uint256 startTime,
1689         uint256 endTime
1690     ) external onlyOwner {
1691         uint32 _startTime = startTime.toUint32();
1692         uint32 _endTime = endTime.toUint32();
1693 
1694         // Check params
1695         require(whitelistSigner != address(0), "TheSevens: zero address");
1696         require(_startTime > 0 && _endTime > _startTime, "TheSevens: invalid time range");
1697 
1698         presaleConfig = PresaleConfig({whitelistSigner: whitelistSigner, startTime: _startTime, endTime: _endTime});
1699 
1700         emit PresaleConfigChanged(whitelistSigner, _startTime, _endTime);
1701     }
1702 
1703     function setUpSale(
1704         uint256 startTime,
1705         uint256 initMaxCount,
1706         uint256 maxCountUnlockTime,
1707         uint256 unlockedMaxCount
1708     ) external onlyOwner {
1709         uint32 _startTime = startTime.toUint32();
1710         uint32 _initMaxCount = initMaxCount.toUint32();
1711         uint32 _maxCountUnlockTime = maxCountUnlockTime.toUint32();
1712         uint32 _unlockedMaxCount = unlockedMaxCount.toUint32();
1713 
1714         require(_initMaxCount > 0 && _unlockedMaxCount > 0, "TheSevens: zero amount");
1715         require(_startTime > 0 && _maxCountUnlockTime > _startTime, "TheSevens: invalid time range");
1716 
1717         saleConfig = SaleConfig({
1718             startTime: _startTime,
1719             initMaxCount: _initMaxCount,
1720             maxCountUnlockTime: _maxCountUnlockTime,
1721             unlockedMaxCount: _unlockedMaxCount
1722         });
1723 
1724         emit SaleConfigChanged(_startTime, _initMaxCount, _maxCountUnlockTime, _unlockedMaxCount);
1725     }
1726 
1727     function setIsBurnEnabled(bool _isBurnEnabled) external onlyOwner {
1728         isBurnEnabled = _isBurnEnabled;
1729         emit IsBurnEnabledChanged(_isBurnEnabled);
1730     }
1731 
1732     function setTreasury(address payable _treasury) external onlyOwner {
1733         treasury = _treasury;
1734         emit TreasuryChanged(_treasury);
1735     }
1736 
1737     function setBaseURI(string calldata newbaseURI) external onlyOwner {
1738         baseURI = newbaseURI;
1739         emit BaseURIChanged(newbaseURI);
1740     }
1741 
1742     function mintPresaleTokens(
1743         uint256 count,
1744         uint256 maxCount,
1745         bytes calldata signature
1746     ) external payable {
1747         // Gas optimization
1748         uint256 _nextTokenId = nextTokenId;
1749 
1750         // Make sure presale has been set up
1751         PresaleConfig memory _presaleConfig = presaleConfig;
1752         require(_presaleConfig.whitelistSigner != address(0), "TheSevens: presale not configured");
1753 
1754         require(treasury != address(0), "TheSevens: treasury not set");
1755         require(tokenPrice > 0, "TheSevens: token price not set");
1756         require(count > 0, "TheSevens: invalid count");
1757         require(block.timestamp >= _presaleConfig.startTime, "TheSevens: presale not started");
1758         require(block.timestamp < _presaleConfig.endTime, "TheSevens: presale ended");
1759 
1760         require(_nextTokenId + count <= maxSupply, "TheSevens: max supply exceeded");
1761         require(tokenPrice * count == msg.value, "TheSevens: incorrect Ether value");
1762 
1763         // Verify EIP-712 signature
1764         bytes32 digest = keccak256(
1765             abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, keccak256(abi.encode(PRESALE_TYPEHASH, msg.sender, maxCount)))
1766         );
1767         address recoveredAddress = digest.recover(signature);
1768         require(
1769             recoveredAddress != address(0) && recoveredAddress == _presaleConfig.whitelistSigner,
1770             "TheSevens: invalid signature"
1771         );
1772 
1773         require(presaleBoughtCounts[msg.sender] + count <= maxCount, "TheSevens: presale max count exceeded");
1774         presaleBoughtCounts[msg.sender] += count;
1775 
1776         // The contract never holds any Ether. Everything gets redirected to treasury directly.
1777         treasury.transfer(msg.value);
1778 
1779         for (uint256 ind = 0; ind < count; ind++) {
1780             _safeMint(msg.sender, _nextTokenId + ind);
1781         }
1782         nextTokenId += count;
1783 
1784         emit PresaleMint(msg.sender, count);
1785     }
1786 
1787     function mintTokens(uint256 count) external payable {
1788         // Gas optimization
1789         uint256 _nextTokenId = nextTokenId;
1790 
1791         // Make sure presale has been set up
1792         SaleConfig memory _saleConfig = saleConfig;
1793         require(_saleConfig.startTime > 0, "TheSevens: sale not configured");
1794 
1795         require(treasury != address(0), "TheSevens: treasury not set");
1796         require(tokenPrice > 0, "TheSevens: token price not set");
1797         require(count > 0, "TheSevens: invalid count");
1798         require(block.timestamp >= _saleConfig.startTime, "TheSevens: sale not started");
1799 
1800         require(
1801             count <=
1802                 (
1803                     block.timestamp >= _saleConfig.maxCountUnlockTime
1804                         ? _saleConfig.unlockedMaxCount
1805                         : _saleConfig.initMaxCount
1806                 ),
1807             "TheSevens: max count per tx exceeded"
1808         );
1809         require(_nextTokenId + count <= maxSupply, "TheSevens: max supply exceeded");
1810         require(tokenPrice * count == msg.value, "TheSevens: incorrect Ether value");
1811 
1812         // The contract never holds any Ether. Everything gets redirected to treasury directly.
1813         treasury.transfer(msg.value);
1814 
1815         for (uint256 ind = 0; ind < count; ind++) {
1816             _safeMint(msg.sender, _nextTokenId + ind);
1817         }
1818         nextTokenId += count;
1819 
1820         emit SaleMint(msg.sender, count);
1821     }
1822 
1823     function burn(uint256 tokenId) external {
1824         require(isBurnEnabled, "TheSevens: burning disabled");
1825         require(_isApprovedOrOwner(msg.sender, tokenId), "TheSevens: burn caller is not owner nor approved");
1826         _burn(tokenId);
1827     }
1828 
1829     function _baseURI() internal view override returns (string memory) {
1830         return baseURI;
1831     }
1832 }