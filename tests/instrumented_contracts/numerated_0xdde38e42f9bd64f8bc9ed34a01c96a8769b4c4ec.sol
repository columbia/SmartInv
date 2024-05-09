1 // Sources flattened with hardhat v2.4.3 https://hardhat.org
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
27 
28 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _setOwner(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _setOwner(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _setOwner(newOwner);
89     }
90 
91     function _setOwner(address newOwner) private {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 
99 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev Interface of the ERC165 standard, as defined in the
105  * https://eips.ethereum.org/EIPS/eip-165[EIP].
106  *
107  * Implementers can declare support of contract interfaces, which can then be
108  * queried by others ({ERC165Checker}).
109  *
110  * For an implementation, see {ERC165}.
111  */
112 interface IERC165 {
113     /**
114      * @dev Returns true if this contract implements the interface defined by
115      * `interfaceId`. See the corresponding
116      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
117      * to learn more about how these ids are created.
118      *
119      * This function call must use less than 30 000 gas.
120      */
121     function supportsInterface(bytes4 interfaceId) external view returns (bool);
122 }
123 
124 
125 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
126 
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev Required interface of an ERC721 compliant contract.
131  */
132 interface IERC721 is IERC165 {
133     /**
134      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
135      */
136     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
137 
138     /**
139      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
140      */
141     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
142 
143     /**
144      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
145      */
146     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
147 
148     /**
149      * @dev Returns the number of tokens in ``owner``'s account.
150      */
151     function balanceOf(address owner) external view returns (uint256 balance);
152 
153     /**
154      * @dev Returns the owner of the `tokenId` token.
155      *
156      * Requirements:
157      *
158      * - `tokenId` must exist.
159      */
160     function ownerOf(uint256 tokenId) external view returns (address owner);
161 
162     /**
163      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
164      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
165      *
166      * Requirements:
167      *
168      * - `from` cannot be the zero address.
169      * - `to` cannot be the zero address.
170      * - `tokenId` token must exist and be owned by `from`.
171      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
172      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
173      *
174      * Emits a {Transfer} event.
175      */
176     function safeTransferFrom(
177         address from,
178         address to,
179         uint256 tokenId
180     ) external;
181 
182     /**
183      * @dev Transfers `tokenId` token from `from` to `to`.
184      *
185      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
186      *
187      * Requirements:
188      *
189      * - `from` cannot be the zero address.
190      * - `to` cannot be the zero address.
191      * - `tokenId` token must be owned by `from`.
192      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
193      *
194      * Emits a {Transfer} event.
195      */
196     function transferFrom(
197         address from,
198         address to,
199         uint256 tokenId
200     ) external;
201 
202     /**
203      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
204      * The approval is cleared when the token is transferred.
205      *
206      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
207      *
208      * Requirements:
209      *
210      * - The caller must own the token or be an approved operator.
211      * - `tokenId` must exist.
212      *
213      * Emits an {Approval} event.
214      */
215     function approve(address to, uint256 tokenId) external;
216 
217     /**
218      * @dev Returns the account approved for `tokenId` token.
219      *
220      * Requirements:
221      *
222      * - `tokenId` must exist.
223      */
224     function getApproved(uint256 tokenId) external view returns (address operator);
225 
226     /**
227      * @dev Approve or remove `operator` as an operator for the caller.
228      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
229      *
230      * Requirements:
231      *
232      * - The `operator` cannot be the caller.
233      *
234      * Emits an {ApprovalForAll} event.
235      */
236     function setApprovalForAll(address operator, bool _approved) external;
237 
238     /**
239      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
240      *
241      * See {setApprovalForAll}
242      */
243     function isApprovedForAll(address owner, address operator) external view returns (bool);
244 
245     /**
246      * @dev Safely transfers `tokenId` token from `from` to `to`.
247      *
248      * Requirements:
249      *
250      * - `from` cannot be the zero address.
251      * - `to` cannot be the zero address.
252      * - `tokenId` token must exist and be owned by `from`.
253      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
254      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
255      *
256      * Emits a {Transfer} event.
257      */
258     function safeTransferFrom(
259         address from,
260         address to,
261         uint256 tokenId,
262         bytes calldata data
263     ) external;
264 }
265 
266 
267 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
268 
269 pragma solidity ^0.8.0;
270 
271 /**
272  * @title ERC721 token receiver interface
273  * @dev Interface for any contract that wants to support safeTransfers
274  * from ERC721 asset contracts.
275  */
276 interface IERC721Receiver {
277     /**
278      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
279      * by `operator` from `from`, this function is called.
280      *
281      * It must return its Solidity selector to confirm the token transfer.
282      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
283      *
284      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
285      */
286     function onERC721Received(
287         address operator,
288         address from,
289         uint256 tokenId,
290         bytes calldata data
291     ) external returns (bytes4);
292 }
293 
294 
295 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
296 
297 pragma solidity ^0.8.0;
298 
299 /**
300  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
301  * @dev See https://eips.ethereum.org/EIPS/eip-721
302  */
303 interface IERC721Metadata is IERC721 {
304     /**
305      * @dev Returns the token collection name.
306      */
307     function name() external view returns (string memory);
308 
309     /**
310      * @dev Returns the token collection symbol.
311      */
312     function symbol() external view returns (string memory);
313 
314     /**
315      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
316      */
317     function tokenURI(uint256 tokenId) external view returns (string memory);
318 }
319 
320 
321 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
322 
323 pragma solidity ^0.8.0;
324 
325 /**
326  * @dev Collection of functions related to the address type
327  */
328 library Address {
329     /**
330      * @dev Returns true if `account` is a contract.
331      *
332      * [IMPORTANT]
333      * ====
334      * It is unsafe to assume that an address for which this function returns
335      * false is an externally-owned account (EOA) and not a contract.
336      *
337      * Among others, `isContract` will return false for the following
338      * types of addresses:
339      *
340      *  - an externally-owned account
341      *  - a contract in construction
342      *  - an address where a contract will be created
343      *  - an address where a contract lived, but was destroyed
344      * ====
345      */
346     function isContract(address account) internal view returns (bool) {
347         // This method relies on extcodesize, which returns 0 for contracts in
348         // construction, since the code is only stored at the end of the
349         // constructor execution.
350 
351         uint256 size;
352         assembly {
353             size := extcodesize(account)
354         }
355         return size > 0;
356     }
357 
358     /**
359      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
360      * `recipient`, forwarding all available gas and reverting on errors.
361      *
362      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
363      * of certain opcodes, possibly making contracts go over the 2300 gas limit
364      * imposed by `transfer`, making them unable to receive funds via
365      * `transfer`. {sendValue} removes this limitation.
366      *
367      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
368      *
369      * IMPORTANT: because control is transferred to `recipient`, care must be
370      * taken to not create reentrancy vulnerabilities. Consider using
371      * {ReentrancyGuard} or the
372      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
373      */
374     function sendValue(address payable recipient, uint256 amount) internal {
375         require(address(this).balance >= amount, "Address: insufficient balance");
376 
377         (bool success, ) = recipient.call{value: amount}("");
378         require(success, "Address: unable to send value, recipient may have reverted");
379     }
380 
381     /**
382      * @dev Performs a Solidity function call using a low level `call`. A
383      * plain `call` is an unsafe replacement for a function call: use this
384      * function instead.
385      *
386      * If `target` reverts with a revert reason, it is bubbled up by this
387      * function (like regular Solidity function calls).
388      *
389      * Returns the raw returned data. To convert to the expected return value,
390      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
391      *
392      * Requirements:
393      *
394      * - `target` must be a contract.
395      * - calling `target` with `data` must not revert.
396      *
397      * _Available since v3.1._
398      */
399     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
400         return functionCall(target, data, "Address: low-level call failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
405      * `errorMessage` as a fallback revert reason when `target` reverts.
406      *
407      * _Available since v3.1._
408      */
409     function functionCall(
410         address target,
411         bytes memory data,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         return functionCallWithValue(target, data, 0, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but also transferring `value` wei to `target`.
420      *
421      * Requirements:
422      *
423      * - the calling contract must have an ETH balance of at least `value`.
424      * - the called Solidity function must be `payable`.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(
429         address target,
430         bytes memory data,
431         uint256 value
432     ) internal returns (bytes memory) {
433         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
438      * with `errorMessage` as a fallback revert reason when `target` reverts.
439      *
440      * _Available since v3.1._
441      */
442     function functionCallWithValue(
443         address target,
444         bytes memory data,
445         uint256 value,
446         string memory errorMessage
447     ) internal returns (bytes memory) {
448         require(address(this).balance >= value, "Address: insufficient balance for call");
449         require(isContract(target), "Address: call to non-contract");
450 
451         (bool success, bytes memory returndata) = target.call{value: value}(data);
452         return _verifyCallResult(success, returndata, errorMessage);
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
457      * but performing a static call.
458      *
459      * _Available since v3.3._
460      */
461     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
462         return functionStaticCall(target, data, "Address: low-level static call failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
467      * but performing a static call.
468      *
469      * _Available since v3.3._
470      */
471     function functionStaticCall(
472         address target,
473         bytes memory data,
474         string memory errorMessage
475     ) internal view returns (bytes memory) {
476         require(isContract(target), "Address: static call to non-contract");
477 
478         (bool success, bytes memory returndata) = target.staticcall(data);
479         return _verifyCallResult(success, returndata, errorMessage);
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
484      * but performing a delegate call.
485      *
486      * _Available since v3.4._
487      */
488     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
489         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
494      * but performing a delegate call.
495      *
496      * _Available since v3.4._
497      */
498     function functionDelegateCall(
499         address target,
500         bytes memory data,
501         string memory errorMessage
502     ) internal returns (bytes memory) {
503         require(isContract(target), "Address: delegate call to non-contract");
504 
505         (bool success, bytes memory returndata) = target.delegatecall(data);
506         return _verifyCallResult(success, returndata, errorMessage);
507     }
508 
509     function _verifyCallResult(
510         bool success,
511         bytes memory returndata,
512         string memory errorMessage
513     ) private pure returns (bytes memory) {
514         if (success) {
515             return returndata;
516         } else {
517             // Look for revert reason and bubble it up if present
518             if (returndata.length > 0) {
519                 // The easiest way to bubble the revert reason is using memory via assembly
520 
521                 assembly {
522                     let returndata_size := mload(returndata)
523                     revert(add(32, returndata), returndata_size)
524                 }
525             } else {
526                 revert(errorMessage);
527             }
528         }
529     }
530 }
531 
532 
533 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
534 
535 pragma solidity ^0.8.0;
536 
537 /**
538  * @dev String operations.
539  */
540 library Strings {
541     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
542 
543     /**
544      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
545      */
546     function toString(uint256 value) internal pure returns (string memory) {
547         // Inspired by OraclizeAPI's implementation - MIT licence
548         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
549 
550         if (value == 0) {
551             return "0";
552         }
553         uint256 temp = value;
554         uint256 digits;
555         while (temp != 0) {
556             digits++;
557             temp /= 10;
558         }
559         bytes memory buffer = new bytes(digits);
560         while (value != 0) {
561             digits -= 1;
562             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
563             value /= 10;
564         }
565         return string(buffer);
566     }
567 
568     /**
569      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
570      */
571     function toHexString(uint256 value) internal pure returns (string memory) {
572         if (value == 0) {
573             return "0x00";
574         }
575         uint256 temp = value;
576         uint256 length = 0;
577         while (temp != 0) {
578             length++;
579             temp >>= 8;
580         }
581         return toHexString(value, length);
582     }
583 
584     /**
585      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
586      */
587     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
588         bytes memory buffer = new bytes(2 * length + 2);
589         buffer[0] = "0";
590         buffer[1] = "x";
591         for (uint256 i = 2 * length + 1; i > 1; --i) {
592             buffer[i] = _HEX_SYMBOLS[value & 0xf];
593             value >>= 4;
594         }
595         require(value == 0, "Strings: hex length insufficient");
596         return string(buffer);
597     }
598 }
599 
600 
601 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @dev Implementation of the {IERC165} interface.
607  *
608  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
609  * for the additional interface id that will be supported. For example:
610  *
611  * ```solidity
612  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
613  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
614  * }
615  * ```
616  *
617  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
618  */
619 abstract contract ERC165 is IERC165 {
620     /**
621      * @dev See {IERC165-supportsInterface}.
622      */
623     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
624         return interfaceId == type(IERC165).interfaceId;
625     }
626 }
627 
628 
629 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.2.0
630 
631 pragma solidity ^0.8.0;
632 
633 
634 
635 
636 
637 
638 
639 /**
640  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
641  * the Metadata extension, but not including the Enumerable extension, which is available separately as
642  * {ERC721Enumerable}.
643  */
644 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
645     using Address for address;
646     using Strings for uint256;
647 
648     // Token name
649     string private _name;
650 
651     // Token symbol
652     string private _symbol;
653 
654     // Mapping from token ID to owner address
655     mapping(uint256 => address) private _owners;
656 
657     // Mapping owner address to token count
658     mapping(address => uint256) private _balances;
659 
660     // Mapping from token ID to approved address
661     mapping(uint256 => address) private _tokenApprovals;
662 
663     // Mapping from owner to operator approvals
664     mapping(address => mapping(address => bool)) private _operatorApprovals;
665 
666     /**
667      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
668      */
669     constructor(string memory name_, string memory symbol_) {
670         _name = name_;
671         _symbol = symbol_;
672     }
673 
674     /**
675      * @dev See {IERC165-supportsInterface}.
676      */
677     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
678         return
679             interfaceId == type(IERC721).interfaceId ||
680             interfaceId == type(IERC721Metadata).interfaceId ||
681             super.supportsInterface(interfaceId);
682     }
683 
684     /**
685      * @dev See {IERC721-balanceOf}.
686      */
687     function balanceOf(address owner) public view virtual override returns (uint256) {
688         require(owner != address(0), "ERC721: balance query for the zero address");
689         return _balances[owner];
690     }
691 
692     /**
693      * @dev See {IERC721-ownerOf}.
694      */
695     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
696         address owner = _owners[tokenId];
697         require(owner != address(0), "ERC721: owner query for nonexistent token");
698         return owner;
699     }
700 
701     /**
702      * @dev See {IERC721Metadata-name}.
703      */
704     function name() public view virtual override returns (string memory) {
705         return _name;
706     }
707 
708     /**
709      * @dev See {IERC721Metadata-symbol}.
710      */
711     function symbol() public view virtual override returns (string memory) {
712         return _symbol;
713     }
714 
715     /**
716      * @dev See {IERC721Metadata-tokenURI}.
717      */
718     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
719         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
720 
721         string memory baseURI = _baseURI();
722         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
723     }
724 
725     /**
726      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
727      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
728      * by default, can be overriden in child contracts.
729      */
730     function _baseURI() internal view virtual returns (string memory) {
731         return "";
732     }
733 
734     /**
735      * @dev See {IERC721-approve}.
736      */
737     function approve(address to, uint256 tokenId) public virtual override {
738         address owner = ERC721.ownerOf(tokenId);
739         require(to != owner, "ERC721: approval to current owner");
740 
741         require(
742             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
743             "ERC721: approve caller is not owner nor approved for all"
744         );
745 
746         _approve(to, tokenId);
747     }
748 
749     /**
750      * @dev See {IERC721-getApproved}.
751      */
752     function getApproved(uint256 tokenId) public view virtual override returns (address) {
753         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
754 
755         return _tokenApprovals[tokenId];
756     }
757 
758     /**
759      * @dev See {IERC721-setApprovalForAll}.
760      */
761     function setApprovalForAll(address operator, bool approved) public virtual override {
762         require(operator != _msgSender(), "ERC721: approve to caller");
763 
764         _operatorApprovals[_msgSender()][operator] = approved;
765         emit ApprovalForAll(_msgSender(), operator, approved);
766     }
767 
768     /**
769      * @dev See {IERC721-isApprovedForAll}.
770      */
771     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
772         return _operatorApprovals[owner][operator];
773     }
774 
775     /**
776      * @dev See {IERC721-transferFrom}.
777      */
778     function transferFrom(
779         address from,
780         address to,
781         uint256 tokenId
782     ) public virtual override {
783         //solhint-disable-next-line max-line-length
784         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
785 
786         _transfer(from, to, tokenId);
787     }
788 
789     /**
790      * @dev See {IERC721-safeTransferFrom}.
791      */
792     function safeTransferFrom(
793         address from,
794         address to,
795         uint256 tokenId
796     ) public virtual override {
797         safeTransferFrom(from, to, tokenId, "");
798     }
799 
800     /**
801      * @dev See {IERC721-safeTransferFrom}.
802      */
803     function safeTransferFrom(
804         address from,
805         address to,
806         uint256 tokenId,
807         bytes memory _data
808     ) public virtual override {
809         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
810         _safeTransfer(from, to, tokenId, _data);
811     }
812 
813     /**
814      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
815      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
816      *
817      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
818      *
819      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
820      * implement alternative mechanisms to perform token transfer, such as signature-based.
821      *
822      * Requirements:
823      *
824      * - `from` cannot be the zero address.
825      * - `to` cannot be the zero address.
826      * - `tokenId` token must exist and be owned by `from`.
827      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
828      *
829      * Emits a {Transfer} event.
830      */
831     function _safeTransfer(
832         address from,
833         address to,
834         uint256 tokenId,
835         bytes memory _data
836     ) internal virtual {
837         _transfer(from, to, tokenId);
838         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
839     }
840 
841     /**
842      * @dev Returns whether `tokenId` exists.
843      *
844      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
845      *
846      * Tokens start existing when they are minted (`_mint`),
847      * and stop existing when they are burned (`_burn`).
848      */
849     function _exists(uint256 tokenId) internal view virtual returns (bool) {
850         return _owners[tokenId] != address(0);
851     }
852 
853     /**
854      * @dev Returns whether `spender` is allowed to manage `tokenId`.
855      *
856      * Requirements:
857      *
858      * - `tokenId` must exist.
859      */
860     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
861         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
862         address owner = ERC721.ownerOf(tokenId);
863         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
864     }
865 
866     /**
867      * @dev Safely mints `tokenId` and transfers it to `to`.
868      *
869      * Requirements:
870      *
871      * - `tokenId` must not exist.
872      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
873      *
874      * Emits a {Transfer} event.
875      */
876     function _safeMint(address to, uint256 tokenId) internal virtual {
877         _safeMint(to, tokenId, "");
878     }
879 
880     /**
881      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
882      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
883      */
884     function _safeMint(
885         address to,
886         uint256 tokenId,
887         bytes memory _data
888     ) internal virtual {
889         _mint(to, tokenId);
890         require(
891             _checkOnERC721Received(address(0), to, tokenId, _data),
892             "ERC721: transfer to non ERC721Receiver implementer"
893         );
894     }
895 
896     /**
897      * @dev Mints `tokenId` and transfers it to `to`.
898      *
899      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
900      *
901      * Requirements:
902      *
903      * - `tokenId` must not exist.
904      * - `to` cannot be the zero address.
905      *
906      * Emits a {Transfer} event.
907      */
908     function _mint(address to, uint256 tokenId) internal virtual {
909         require(to != address(0), "ERC721: mint to the zero address");
910         require(!_exists(tokenId), "ERC721: token already minted");
911 
912         _beforeTokenTransfer(address(0), to, tokenId);
913 
914         _balances[to] += 1;
915         _owners[tokenId] = to;
916 
917         emit Transfer(address(0), to, tokenId);
918     }
919 
920     /**
921      * @dev Destroys `tokenId`.
922      * The approval is cleared when the token is burned.
923      *
924      * Requirements:
925      *
926      * - `tokenId` must exist.
927      *
928      * Emits a {Transfer} event.
929      */
930     function _burn(uint256 tokenId) internal virtual {
931         address owner = ERC721.ownerOf(tokenId);
932 
933         _beforeTokenTransfer(owner, address(0), tokenId);
934 
935         // Clear approvals
936         _approve(address(0), tokenId);
937 
938         _balances[owner] -= 1;
939         delete _owners[tokenId];
940 
941         emit Transfer(owner, address(0), tokenId);
942     }
943 
944     /**
945      * @dev Transfers `tokenId` from `from` to `to`.
946      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
947      *
948      * Requirements:
949      *
950      * - `to` cannot be the zero address.
951      * - `tokenId` token must be owned by `from`.
952      *
953      * Emits a {Transfer} event.
954      */
955     function _transfer(
956         address from,
957         address to,
958         uint256 tokenId
959     ) internal virtual {
960         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
961         require(to != address(0), "ERC721: transfer to the zero address");
962 
963         _beforeTokenTransfer(from, to, tokenId);
964 
965         // Clear approvals from the previous owner
966         _approve(address(0), tokenId);
967 
968         _balances[from] -= 1;
969         _balances[to] += 1;
970         _owners[tokenId] = to;
971 
972         emit Transfer(from, to, tokenId);
973     }
974 
975     /**
976      * @dev Approve `to` to operate on `tokenId`
977      *
978      * Emits a {Approval} event.
979      */
980     function _approve(address to, uint256 tokenId) internal virtual {
981         _tokenApprovals[tokenId] = to;
982         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
983     }
984 
985     /**
986      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
987      * The call is not executed if the target address is not a contract.
988      *
989      * @param from address representing the previous owner of the given token ID
990      * @param to target address that will receive the tokens
991      * @param tokenId uint256 ID of the token to be transferred
992      * @param _data bytes optional data to send along with the call
993      * @return bool whether the call correctly returned the expected magic value
994      */
995     function _checkOnERC721Received(
996         address from,
997         address to,
998         uint256 tokenId,
999         bytes memory _data
1000     ) private returns (bool) {
1001         if (to.isContract()) {
1002             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1003                 return retval == IERC721Receiver(to).onERC721Received.selector;
1004             } catch (bytes memory reason) {
1005                 if (reason.length == 0) {
1006                     revert("ERC721: transfer to non ERC721Receiver implementer");
1007                 } else {
1008                     assembly {
1009                         revert(add(32, reason), mload(reason))
1010                     }
1011                 }
1012             }
1013         } else {
1014             return true;
1015         }
1016     }
1017 
1018     /**
1019      * @dev Hook that is called before any token transfer. This includes minting
1020      * and burning.
1021      *
1022      * Calling conditions:
1023      *
1024      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1025      * transferred to `to`.
1026      * - When `from` is zero, `tokenId` will be minted for `to`.
1027      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1028      * - `from` and `to` are never both zero.
1029      *
1030      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1031      */
1032     function _beforeTokenTransfer(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) internal virtual {}
1037 }
1038 
1039 
1040 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
1041 
1042 pragma solidity ^0.8.0;
1043 
1044 /**
1045  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1046  * @dev See https://eips.ethereum.org/EIPS/eip-721
1047  */
1048 interface IERC721Enumerable is IERC721 {
1049     /**
1050      * @dev Returns the total amount of tokens stored by the contract.
1051      */
1052     function totalSupply() external view returns (uint256);
1053 
1054     /**
1055      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1056      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1057      */
1058     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1059 
1060     /**
1061      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1062      * Use along with {totalSupply} to enumerate all tokens.
1063      */
1064     function tokenByIndex(uint256 index) external view returns (uint256);
1065 }
1066 
1067 
1068 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.2.0
1069 
1070 pragma solidity ^0.8.0;
1071 
1072 
1073 /**
1074  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1075  * enumerability of all the token ids in the contract as well as all token ids owned by each
1076  * account.
1077  */
1078 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1079     // Mapping from owner to list of owned token IDs
1080     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1081 
1082     // Mapping from token ID to index of the owner tokens list
1083     mapping(uint256 => uint256) private _ownedTokensIndex;
1084 
1085     // Array with all token ids, used for enumeration
1086     uint256[] private _allTokens;
1087 
1088     // Mapping from token id to position in the allTokens array
1089     mapping(uint256 => uint256) private _allTokensIndex;
1090 
1091     /**
1092      * @dev See {IERC165-supportsInterface}.
1093      */
1094     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1095         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1096     }
1097 
1098     /**
1099      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1100      */
1101     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1102         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1103         return _ownedTokens[owner][index];
1104     }
1105 
1106     /**
1107      * @dev See {IERC721Enumerable-totalSupply}.
1108      */
1109     function totalSupply() public view virtual override returns (uint256) {
1110         return _allTokens.length;
1111     }
1112 
1113     /**
1114      * @dev See {IERC721Enumerable-tokenByIndex}.
1115      */
1116     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1117         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1118         return _allTokens[index];
1119     }
1120 
1121     /**
1122      * @dev Hook that is called before any token transfer. This includes minting
1123      * and burning.
1124      *
1125      * Calling conditions:
1126      *
1127      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1128      * transferred to `to`.
1129      * - When `from` is zero, `tokenId` will be minted for `to`.
1130      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1131      * - `from` cannot be the zero address.
1132      * - `to` cannot be the zero address.
1133      *
1134      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1135      */
1136     function _beforeTokenTransfer(
1137         address from,
1138         address to,
1139         uint256 tokenId
1140     ) internal virtual override {
1141         super._beforeTokenTransfer(from, to, tokenId);
1142 
1143         if (from == address(0)) {
1144             _addTokenToAllTokensEnumeration(tokenId);
1145         } else if (from != to) {
1146             _removeTokenFromOwnerEnumeration(from, tokenId);
1147         }
1148         if (to == address(0)) {
1149             _removeTokenFromAllTokensEnumeration(tokenId);
1150         } else if (to != from) {
1151             _addTokenToOwnerEnumeration(to, tokenId);
1152         }
1153     }
1154 
1155     /**
1156      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1157      * @param to address representing the new owner of the given token ID
1158      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1159      */
1160     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1161         uint256 length = ERC721.balanceOf(to);
1162         _ownedTokens[to][length] = tokenId;
1163         _ownedTokensIndex[tokenId] = length;
1164     }
1165 
1166     /**
1167      * @dev Private function to add a token to this extension's token tracking data structures.
1168      * @param tokenId uint256 ID of the token to be added to the tokens list
1169      */
1170     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1171         _allTokensIndex[tokenId] = _allTokens.length;
1172         _allTokens.push(tokenId);
1173     }
1174 
1175     /**
1176      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1177      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1178      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1179      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1180      * @param from address representing the previous owner of the given token ID
1181      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1182      */
1183     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1184         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1185         // then delete the last slot (swap and pop).
1186 
1187         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1188         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1189 
1190         // When the token to delete is the last token, the swap operation is unnecessary
1191         if (tokenIndex != lastTokenIndex) {
1192             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1193 
1194             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1195             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1196         }
1197 
1198         // This also deletes the contents at the last position of the array
1199         delete _ownedTokensIndex[tokenId];
1200         delete _ownedTokens[from][lastTokenIndex];
1201     }
1202 
1203     /**
1204      * @dev Private function to remove a token from this extension's token tracking data structures.
1205      * This has O(1) time complexity, but alters the order of the _allTokens array.
1206      * @param tokenId uint256 ID of the token to be removed from the tokens list
1207      */
1208     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1209         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1210         // then delete the last slot (swap and pop).
1211 
1212         uint256 lastTokenIndex = _allTokens.length - 1;
1213         uint256 tokenIndex = _allTokensIndex[tokenId];
1214 
1215         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1216         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1217         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1218         uint256 lastTokenId = _allTokens[lastTokenIndex];
1219 
1220         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1221         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1222 
1223         // This also deletes the contents at the last position of the array
1224         delete _allTokensIndex[tokenId];
1225         _allTokens.pop();
1226     }
1227 }
1228 
1229 
1230 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.2.0
1231 
1232 pragma solidity ^0.8.0;
1233 
1234 // CAUTION
1235 // This version of SafeMath should only be used with Solidity 0.8 or later,
1236 // because it relies on the compiler's built in overflow checks.
1237 
1238 /**
1239  * @dev Wrappers over Solidity's arithmetic operations.
1240  *
1241  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1242  * now has built in overflow checking.
1243  */
1244 library SafeMath {
1245     /**
1246      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1247      *
1248      * _Available since v3.4._
1249      */
1250     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1251         unchecked {
1252             uint256 c = a + b;
1253             if (c < a) return (false, 0);
1254             return (true, c);
1255         }
1256     }
1257 
1258     /**
1259      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1260      *
1261      * _Available since v3.4._
1262      */
1263     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1264         unchecked {
1265             if (b > a) return (false, 0);
1266             return (true, a - b);
1267         }
1268     }
1269 
1270     /**
1271      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1272      *
1273      * _Available since v3.4._
1274      */
1275     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1276         unchecked {
1277             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1278             // benefit is lost if 'b' is also tested.
1279             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1280             if (a == 0) return (true, 0);
1281             uint256 c = a * b;
1282             if (c / a != b) return (false, 0);
1283             return (true, c);
1284         }
1285     }
1286 
1287     /**
1288      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1289      *
1290      * _Available since v3.4._
1291      */
1292     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1293         unchecked {
1294             if (b == 0) return (false, 0);
1295             return (true, a / b);
1296         }
1297     }
1298 
1299     /**
1300      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1301      *
1302      * _Available since v3.4._
1303      */
1304     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1305         unchecked {
1306             if (b == 0) return (false, 0);
1307             return (true, a % b);
1308         }
1309     }
1310 
1311     /**
1312      * @dev Returns the addition of two unsigned integers, reverting on
1313      * overflow.
1314      *
1315      * Counterpart to Solidity's `+` operator.
1316      *
1317      * Requirements:
1318      *
1319      * - Addition cannot overflow.
1320      */
1321     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1322         return a + b;
1323     }
1324 
1325     /**
1326      * @dev Returns the subtraction of two unsigned integers, reverting on
1327      * overflow (when the result is negative).
1328      *
1329      * Counterpart to Solidity's `-` operator.
1330      *
1331      * Requirements:
1332      *
1333      * - Subtraction cannot overflow.
1334      */
1335     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1336         return a - b;
1337     }
1338 
1339     /**
1340      * @dev Returns the multiplication of two unsigned integers, reverting on
1341      * overflow.
1342      *
1343      * Counterpart to Solidity's `*` operator.
1344      *
1345      * Requirements:
1346      *
1347      * - Multiplication cannot overflow.
1348      */
1349     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1350         return a * b;
1351     }
1352 
1353     /**
1354      * @dev Returns the integer division of two unsigned integers, reverting on
1355      * division by zero. The result is rounded towards zero.
1356      *
1357      * Counterpart to Solidity's `/` operator.
1358      *
1359      * Requirements:
1360      *
1361      * - The divisor cannot be zero.
1362      */
1363     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1364         return a / b;
1365     }
1366 
1367     /**
1368      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1369      * reverting when dividing by zero.
1370      *
1371      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1372      * opcode (which leaves remaining gas untouched) while Solidity uses an
1373      * invalid opcode to revert (consuming all remaining gas).
1374      *
1375      * Requirements:
1376      *
1377      * - The divisor cannot be zero.
1378      */
1379     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1380         return a % b;
1381     }
1382 
1383     /**
1384      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1385      * overflow (when the result is negative).
1386      *
1387      * CAUTION: This function is deprecated because it requires allocating memory for the error
1388      * message unnecessarily. For custom revert reasons use {trySub}.
1389      *
1390      * Counterpart to Solidity's `-` operator.
1391      *
1392      * Requirements:
1393      *
1394      * - Subtraction cannot overflow.
1395      */
1396     function sub(
1397         uint256 a,
1398         uint256 b,
1399         string memory errorMessage
1400     ) internal pure returns (uint256) {
1401         unchecked {
1402             require(b <= a, errorMessage);
1403             return a - b;
1404         }
1405     }
1406 
1407     /**
1408      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1409      * division by zero. The result is rounded towards zero.
1410      *
1411      * Counterpart to Solidity's `/` operator. Note: this function uses a
1412      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1413      * uses an invalid opcode to revert (consuming all remaining gas).
1414      *
1415      * Requirements:
1416      *
1417      * - The divisor cannot be zero.
1418      */
1419     function div(
1420         uint256 a,
1421         uint256 b,
1422         string memory errorMessage
1423     ) internal pure returns (uint256) {
1424         unchecked {
1425             require(b > 0, errorMessage);
1426             return a / b;
1427         }
1428     }
1429 
1430     /**
1431      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1432      * reverting with custom message when dividing by zero.
1433      *
1434      * CAUTION: This function is deprecated because it requires allocating memory for the error
1435      * message unnecessarily. For custom revert reasons use {tryMod}.
1436      *
1437      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1438      * opcode (which leaves remaining gas untouched) while Solidity uses an
1439      * invalid opcode to revert (consuming all remaining gas).
1440      *
1441      * Requirements:
1442      *
1443      * - The divisor cannot be zero.
1444      */
1445     function mod(
1446         uint256 a,
1447         uint256 b,
1448         string memory errorMessage
1449     ) internal pure returns (uint256) {
1450         unchecked {
1451             require(b > 0, errorMessage);
1452             return a % b;
1453         }
1454     }
1455 }
1456 
1457 
1458 // File contracts/CBC.sol
1459 
1460 pragma solidity ^0.8.0;
1461 
1462 /**
1463  *
1464 _________                        _____.__                 __________                      _________ .__       ___.    
1465 \_   ___ \_____    _____ _______/ ____\__|______   ____   \______   \ ____ _____ _______  \_   ___ \|  |  __ _\_ |__  
1466 /    \  \/\__  \  /     \\____ \   __\|  \_  __ \_/ __ \   |    |  _// __ \\__  \\_  __ \ /    \  \/|  | |  |  \ __ \ 
1467 \     \____/ __ \|  Y Y  \  |_> >  |  |  ||  | \/\  ___/   |    |   \  ___/ / __ \|  | \/ \     \___|  |_|  |  / \_\ \
1468  \______  (____  /__|_|  /   __/|__|  |__||__|    \___  >  |______  /\___  >____  /__|     \______  /____/____/|___  /
1469         \/     \/      \/|__|                         \/          \/     \/     \/                \/               \/ 
1470  *
1471  * @author Smokey Bear
1472  * Mint a campfire bear.
1473  *
1474  */
1475 contract CampfireBearClub is ERC721Enumerable, Ownable {
1476   using SafeMath for uint256;
1477 
1478   // Each bear costs 0.08 ETH to mint.
1479   uint256 public constant price = 0.08 ether;
1480 
1481   // Only 10 bears can be purchased in a single transaction.
1482   uint256 public constant maxPurchase = 10;
1483 
1484   // There will only be 10000 bears available.
1485   uint256 public constant maxBears = 10000;
1486 
1487   // 2000 bears are available during presale.
1488   uint256 public constant bearPresale = 2000;
1489 
1490   // Presale price is 0.04 ETH to mint.
1491   uint256 public constant presalePrice = 0.04 ether;
1492 
1493   // Flag to make the sale active or disabled.
1494   bool public saleIsActive = false;
1495 
1496   // Flag to make the presale active or disabled.
1497   bool public presaleIsActive = false;
1498 
1499   // Base URI for the metadata.
1500   string public uri = "";
1501 
1502   constructor() ERC721("Campfire Bear Club", "CBC") {}
1503 
1504   function flipSaleState() public onlyOwner {
1505     saleIsActive = !saleIsActive;
1506   }
1507 
1508   function flipPresaleState() public onlyOwner {
1509     presaleIsActive = !presaleIsActive;
1510   }
1511 
1512   function _baseURI() internal override view virtual returns (string memory) {
1513     return uri;
1514   }
1515 
1516   function setBaseURI(string memory _uri) public onlyOwner {
1517     uri = _uri;
1518   }
1519 
1520   function withdraw() public onlyOwner {
1521     uint balance = address(this).balance;
1522     payable(msg.sender).transfer(balance);
1523   }
1524 
1525   function reserveBears() public onlyOwner {
1526     uint supply = totalSupply();
1527     uint i;
1528     for (i = 0; i < 35; i++) {
1529       _safeMint(msg.sender, supply + i);
1530     }
1531   }
1532 
1533   function mint(uint numberOfBears) public payable {
1534     require(presaleIsActive || saleIsActive, "One of the sales must be active");
1535     require(numberOfBears <= maxPurchase, "Can only mint up to 10 bears at once");
1536 
1537     if (presaleIsActive) {
1538       require(totalSupply().add(numberOfBears) <= bearPresale, "Purchase would exceed max supply of bears");
1539       require(presalePrice.mul(numberOfBears) <= msg.value, "Ether value sent is not correct");
1540 
1541       for(uint i = 0; i < numberOfBears; i++) {
1542         uint mintIndex = totalSupply();
1543         if (totalSupply() < bearPresale) {
1544           _safeMint(msg.sender, mintIndex);
1545         }
1546       }
1547     } else {
1548       require(totalSupply().add(numberOfBears) <= maxBears, "Purchase would exceed max supply of bears");
1549       require(price.mul(numberOfBears) <= msg.value, "Ether value sent is not correct");
1550 
1551       for(uint i = 0; i < numberOfBears; i++) {
1552         uint mintIndex = totalSupply();
1553         if (totalSupply() < maxBears) {
1554           _safeMint(msg.sender, mintIndex);
1555         }
1556       }
1557     }
1558   }
1559 }