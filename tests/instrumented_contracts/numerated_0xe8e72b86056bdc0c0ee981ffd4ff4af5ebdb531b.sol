1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
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
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _setOwner(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _setOwner(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _setOwner(newOwner);
91     }
92 
93     function _setOwner(address newOwner) private {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
101 
102 
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Interface of the ERC165 standard, as defined in the
108  * https://eips.ethereum.org/EIPS/eip-165[EIP].
109  *
110  * Implementers can declare support of contract interfaces, which can then be
111  * queried by others ({ERC165Checker}).
112  *
113  * For an implementation, see {ERC165}.
114  */
115 interface IERC165 {
116     /**
117      * @dev Returns true if this contract implements the interface defined by
118      * `interfaceId`. See the corresponding
119      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
120      * to learn more about how these ids are created.
121      *
122      * This function call must use less than 30 000 gas.
123      */
124     function supportsInterface(bytes4 interfaceId) external view returns (bool);
125 }
126 
127 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
128 
129 
130 
131 pragma solidity ^0.8.0;
132 
133 
134 /**
135  * @dev Required interface of an ERC721 compliant contract.
136  */
137 interface IERC721 is IERC165 {
138     /**
139      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
140      */
141     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
142 
143     /**
144      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
145      */
146     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
147 
148     /**
149      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
150      */
151     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
152 
153     /**
154      * @dev Returns the number of tokens in ``owner``'s account.
155      */
156     function balanceOf(address owner) external view returns (uint256 balance);
157 
158     /**
159      * @dev Returns the owner of the `tokenId` token.
160      *
161      * Requirements:
162      *
163      * - `tokenId` must exist.
164      */
165     function ownerOf(uint256 tokenId) external view returns (address owner);
166 
167     /**
168      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
169      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
170      *
171      * Requirements:
172      *
173      * - `from` cannot be the zero address.
174      * - `to` cannot be the zero address.
175      * - `tokenId` token must exist and be owned by `from`.
176      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
177      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
178      *
179      * Emits a {Transfer} event.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId
185     ) external;
186 
187     /**
188      * @dev Transfers `tokenId` token from `from` to `to`.
189      *
190      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
191      *
192      * Requirements:
193      *
194      * - `from` cannot be the zero address.
195      * - `to` cannot be the zero address.
196      * - `tokenId` token must be owned by `from`.
197      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
198      *
199      * Emits a {Transfer} event.
200      */
201     function transferFrom(
202         address from,
203         address to,
204         uint256 tokenId
205     ) external;
206 
207     /**
208      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
209      * The approval is cleared when the token is transferred.
210      *
211      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
212      *
213      * Requirements:
214      *
215      * - The caller must own the token or be an approved operator.
216      * - `tokenId` must exist.
217      *
218      * Emits an {Approval} event.
219      */
220     function approve(address to, uint256 tokenId) external;
221 
222     /**
223      * @dev Returns the account approved for `tokenId` token.
224      *
225      * Requirements:
226      *
227      * - `tokenId` must exist.
228      */
229     function getApproved(uint256 tokenId) external view returns (address operator);
230 
231     /**
232      * @dev Approve or remove `operator` as an operator for the caller.
233      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
234      *
235      * Requirements:
236      *
237      * - The `operator` cannot be the caller.
238      *
239      * Emits an {ApprovalForAll} event.
240      */
241     function setApprovalForAll(address operator, bool _approved) external;
242 
243     /**
244      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
245      *
246      * See {setApprovalForAll}
247      */
248     function isApprovedForAll(address owner, address operator) external view returns (bool);
249 
250     /**
251      * @dev Safely transfers `tokenId` token from `from` to `to`.
252      *
253      * Requirements:
254      *
255      * - `from` cannot be the zero address.
256      * - `to` cannot be the zero address.
257      * - `tokenId` token must exist and be owned by `from`.
258      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
259      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
260      *
261      * Emits a {Transfer} event.
262      */
263     function safeTransferFrom(
264         address from,
265         address to,
266         uint256 tokenId,
267         bytes calldata data
268     ) external;
269 }
270 
271 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
272 
273 
274 
275 pragma solidity ^0.8.0;
276 
277 /**
278  * @title ERC721 token receiver interface
279  * @dev Interface for any contract that wants to support safeTransfers
280  * from ERC721 asset contracts.
281  */
282 interface IERC721Receiver {
283     /**
284      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
285      * by `operator` from `from`, this function is called.
286      *
287      * It must return its Solidity selector to confirm the token transfer.
288      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
289      *
290      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
291      */
292     function onERC721Received(
293         address operator,
294         address from,
295         uint256 tokenId,
296         bytes calldata data
297     ) external returns (bytes4);
298 }
299 
300 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
301 
302 
303 
304 pragma solidity ^0.8.0;
305 
306 
307 /**
308  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
309  * @dev See https://eips.ethereum.org/EIPS/eip-721
310  */
311 interface IERC721Metadata is IERC721 {
312     /**
313      * @dev Returns the token collection name.
314      */
315     function name() external view returns (string memory);
316 
317     /**
318      * @dev Returns the token collection symbol.
319      */
320     function symbol() external view returns (string memory);
321 
322     /**
323      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
324      */
325     function tokenURI(uint256 tokenId) external view returns (string memory);
326 }
327 
328 // File: @openzeppelin/contracts/utils/Address.sol
329 
330 
331 
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @dev Collection of functions related to the address type
336  */
337 library Address {
338     /**
339      * @dev Returns true if `account` is a contract.
340      *
341      * [IMPORTANT]
342      * ====
343      * It is unsafe to assume that an address for which this function returns
344      * false is an externally-owned account (EOA) and not a contract.
345      *
346      * Among others, `isContract` will return false for the following
347      * types of addresses:
348      *
349      *  - an externally-owned account
350      *  - a contract in construction
351      *  - an address where a contract will be created
352      *  - an address where a contract lived, but was destroyed
353      * ====
354      */
355     function isContract(address account) internal view returns (bool) {
356         // This method relies on extcodesize, which returns 0 for contracts in
357         // construction, since the code is only stored at the end of the
358         // constructor execution.
359 
360         uint256 size;
361         assembly {
362             size := extcodesize(account)
363         }
364         return size > 0;
365     }
366 
367     /**
368      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
369      * `recipient`, forwarding all available gas and reverting on errors.
370      *
371      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
372      * of certain opcodes, possibly making contracts go over the 2300 gas limit
373      * imposed by `transfer`, making them unable to receive funds via
374      * `transfer`. {sendValue} removes this limitation.
375      *
376      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
377      *
378      * IMPORTANT: because control is transferred to `recipient`, care must be
379      * taken to not create reentrancy vulnerabilities. Consider using
380      * {ReentrancyGuard} or the
381      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
382      */
383     function sendValue(address payable recipient, uint256 amount) internal {
384         require(address(this).balance >= amount, "Address: insufficient balance");
385 
386         (bool success, ) = recipient.call{value: amount}("");
387         require(success, "Address: unable to send value, recipient may have reverted");
388     }
389 
390     /**
391      * @dev Performs a Solidity function call using a low level `call`. A
392      * plain `call` is an unsafe replacement for a function call: use this
393      * function instead.
394      *
395      * If `target` reverts with a revert reason, it is bubbled up by this
396      * function (like regular Solidity function calls).
397      *
398      * Returns the raw returned data. To convert to the expected return value,
399      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
400      *
401      * Requirements:
402      *
403      * - `target` must be a contract.
404      * - calling `target` with `data` must not revert.
405      *
406      * _Available since v3.1._
407      */
408     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
409         return functionCall(target, data, "Address: low-level call failed");
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
414      * `errorMessage` as a fallback revert reason when `target` reverts.
415      *
416      * _Available since v3.1._
417      */
418     function functionCall(
419         address target,
420         bytes memory data,
421         string memory errorMessage
422     ) internal returns (bytes memory) {
423         return functionCallWithValue(target, data, 0, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but also transferring `value` wei to `target`.
429      *
430      * Requirements:
431      *
432      * - the calling contract must have an ETH balance of at least `value`.
433      * - the called Solidity function must be `payable`.
434      *
435      * _Available since v3.1._
436      */
437     function functionCallWithValue(
438         address target,
439         bytes memory data,
440         uint256 value
441     ) internal returns (bytes memory) {
442         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
447      * with `errorMessage` as a fallback revert reason when `target` reverts.
448      *
449      * _Available since v3.1._
450      */
451     function functionCallWithValue(
452         address target,
453         bytes memory data,
454         uint256 value,
455         string memory errorMessage
456     ) internal returns (bytes memory) {
457         require(address(this).balance >= value, "Address: insufficient balance for call");
458         require(isContract(target), "Address: call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.call{value: value}(data);
461         return _verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
466      * but performing a static call.
467      *
468      * _Available since v3.3._
469      */
470     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
471         return functionStaticCall(target, data, "Address: low-level static call failed");
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
476      * but performing a static call.
477      *
478      * _Available since v3.3._
479      */
480     function functionStaticCall(
481         address target,
482         bytes memory data,
483         string memory errorMessage
484     ) internal view returns (bytes memory) {
485         require(isContract(target), "Address: static call to non-contract");
486 
487         (bool success, bytes memory returndata) = target.staticcall(data);
488         return _verifyCallResult(success, returndata, errorMessage);
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
493      * but performing a delegate call.
494      *
495      * _Available since v3.4._
496      */
497     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
498         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
503      * but performing a delegate call.
504      *
505      * _Available since v3.4._
506      */
507     function functionDelegateCall(
508         address target,
509         bytes memory data,
510         string memory errorMessage
511     ) internal returns (bytes memory) {
512         require(isContract(target), "Address: delegate call to non-contract");
513 
514         (bool success, bytes memory returndata) = target.delegatecall(data);
515         return _verifyCallResult(success, returndata, errorMessage);
516     }
517 
518     function _verifyCallResult(
519         bool success,
520         bytes memory returndata,
521         string memory errorMessage
522     ) private pure returns (bytes memory) {
523         if (success) {
524             return returndata;
525         } else {
526             // Look for revert reason and bubble it up if present
527             if (returndata.length > 0) {
528                 // The easiest way to bubble the revert reason is using memory via assembly
529 
530                 assembly {
531                     let returndata_size := mload(returndata)
532                     revert(add(32, returndata), returndata_size)
533                 }
534             } else {
535                 revert(errorMessage);
536             }
537         }
538     }
539 }
540 
541 // File: @openzeppelin/contracts/utils/Strings.sol
542 
543 
544 
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @dev String operations.
549  */
550 library Strings {
551     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
552 
553     /**
554      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
555      */
556     function toString(uint256 value) internal pure returns (string memory) {
557         // Inspired by OraclizeAPI's implementation - MIT licence
558         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
559 
560         if (value == 0) {
561             return "0";
562         }
563         uint256 temp = value;
564         uint256 digits;
565         while (temp != 0) {
566             digits++;
567             temp /= 10;
568         }
569         bytes memory buffer = new bytes(digits);
570         while (value != 0) {
571             digits -= 1;
572             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
573             value /= 10;
574         }
575         return string(buffer);
576     }
577 
578     /**
579      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
580      */
581     function toHexString(uint256 value) internal pure returns (string memory) {
582         if (value == 0) {
583             return "0x00";
584         }
585         uint256 temp = value;
586         uint256 length = 0;
587         while (temp != 0) {
588             length++;
589             temp >>= 8;
590         }
591         return toHexString(value, length);
592     }
593 
594     /**
595      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
596      */
597     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
598         bytes memory buffer = new bytes(2 * length + 2);
599         buffer[0] = "0";
600         buffer[1] = "x";
601         for (uint256 i = 2 * length + 1; i > 1; --i) {
602             buffer[i] = _HEX_SYMBOLS[value & 0xf];
603             value >>= 4;
604         }
605         require(value == 0, "Strings: hex length insufficient");
606         return string(buffer);
607     }
608 }
609 
610 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
611 
612 
613 
614 pragma solidity ^0.8.0;
615 
616 
617 /**
618  * @dev Implementation of the {IERC165} interface.
619  *
620  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
621  * for the additional interface id that will be supported. For example:
622  *
623  * ```solidity
624  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
625  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
626  * }
627  * ```
628  *
629  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
630  */
631 abstract contract ERC165 is IERC165 {
632     /**
633      * @dev See {IERC165-supportsInterface}.
634      */
635     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
636         return interfaceId == type(IERC165).interfaceId;
637     }
638 }
639 
640 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
641 
642 
643 
644 pragma solidity ^0.8.0;
645 
646 
647 
648 
649 
650 
651 
652 
653 /**
654  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
655  * the Metadata extension, but not including the Enumerable extension, which is available separately as
656  * {ERC721Enumerable}.
657  */
658 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
659     using Address for address;
660     using Strings for uint256;
661 
662     // Token name
663     string private _name;
664 
665     // Token symbol
666     string private _symbol;
667 
668     // Mapping from token ID to owner address
669     mapping(uint256 => address) private _owners;
670 
671     // Mapping owner address to token count
672     mapping(address => uint256) private _balances;
673 
674     // Mapping from token ID to approved address
675     mapping(uint256 => address) private _tokenApprovals;
676 
677     // Mapping from owner to operator approvals
678     mapping(address => mapping(address => bool)) private _operatorApprovals;
679 
680     /**
681      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
682      */
683     constructor(string memory name_, string memory symbol_) {
684         _name = name_;
685         _symbol = symbol_;
686     }
687 
688     /**
689      * @dev See {IERC165-supportsInterface}.
690      */
691     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
692         return
693             interfaceId == type(IERC721).interfaceId ||
694             interfaceId == type(IERC721Metadata).interfaceId ||
695             super.supportsInterface(interfaceId);
696     }
697 
698     /**
699      * @dev See {IERC721-balanceOf}.
700      */
701     function balanceOf(address owner) public view virtual override returns (uint256) {
702         require(owner != address(0), "ERC721: balance query for the zero address");
703         return _balances[owner];
704     }
705 
706     /**
707      * @dev See {IERC721-ownerOf}.
708      */
709     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
710         address owner = _owners[tokenId];
711         require(owner != address(0), "ERC721: owner query for nonexistent token");
712         return owner;
713     }
714 
715     /**
716      * @dev See {IERC721Metadata-name}.
717      */
718     function name() public view virtual override returns (string memory) {
719         return _name;
720     }
721 
722     /**
723      * @dev See {IERC721Metadata-symbol}.
724      */
725     function symbol() public view virtual override returns (string memory) {
726         return _symbol;
727     }
728 
729     /**
730      * @dev See {IERC721Metadata-tokenURI}.
731      */
732     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
733         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
734 
735         string memory baseURI = _baseURI();
736         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
737     }
738 
739     /**
740      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
741      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
742      * by default, can be overriden in child contracts.
743      */
744     function _baseURI() internal view virtual returns (string memory) {
745         return "";
746     }
747 
748     /**
749      * @dev See {IERC721-approve}.
750      */
751     function approve(address to, uint256 tokenId) public virtual override {
752         address owner = ERC721.ownerOf(tokenId);
753         require(to != owner, "ERC721: approval to current owner");
754 
755         require(
756             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
757             "ERC721: approve caller is not owner nor approved for all"
758         );
759 
760         _approve(to, tokenId);
761     }
762 
763     /**
764      * @dev See {IERC721-getApproved}.
765      */
766     function getApproved(uint256 tokenId) public view virtual override returns (address) {
767         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
768 
769         return _tokenApprovals[tokenId];
770     }
771 
772     /**
773      * @dev See {IERC721-setApprovalForAll}.
774      */
775     function setApprovalForAll(address operator, bool approved) public virtual override {
776         require(operator != _msgSender(), "ERC721: approve to caller");
777 
778         _operatorApprovals[_msgSender()][operator] = approved;
779         emit ApprovalForAll(_msgSender(), operator, approved);
780     }
781 
782     /**
783      * @dev See {IERC721-isApprovedForAll}.
784      */
785     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
786         return _operatorApprovals[owner][operator];
787     }
788 
789     /**
790      * @dev See {IERC721-transferFrom}.
791      */
792     function transferFrom(
793         address from,
794         address to,
795         uint256 tokenId
796     ) public virtual override {
797         //solhint-disable-next-line max-line-length
798         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
799 
800         _transfer(from, to, tokenId);
801     }
802 
803     /**
804      * @dev See {IERC721-safeTransferFrom}.
805      */
806     function safeTransferFrom(
807         address from,
808         address to,
809         uint256 tokenId
810     ) public virtual override {
811         safeTransferFrom(from, to, tokenId, "");
812     }
813 
814     /**
815      * @dev See {IERC721-safeTransferFrom}.
816      */
817     function safeTransferFrom(
818         address from,
819         address to,
820         uint256 tokenId,
821         bytes memory _data
822     ) public virtual override {
823         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
824         _safeTransfer(from, to, tokenId, _data);
825     }
826 
827     /**
828      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
829      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
830      *
831      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
832      *
833      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
834      * implement alternative mechanisms to perform token transfer, such as signature-based.
835      *
836      * Requirements:
837      *
838      * - `from` cannot be the zero address.
839      * - `to` cannot be the zero address.
840      * - `tokenId` token must exist and be owned by `from`.
841      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
842      *
843      * Emits a {Transfer} event.
844      */
845     function _safeTransfer(
846         address from,
847         address to,
848         uint256 tokenId,
849         bytes memory _data
850     ) internal virtual {
851         _transfer(from, to, tokenId);
852         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
853     }
854 
855     /**
856      * @dev Returns whether `tokenId` exists.
857      *
858      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
859      *
860      * Tokens start existing when they are minted (`_mint`),
861      * and stop existing when they are burned (`_burn`).
862      */
863     function _exists(uint256 tokenId) internal view virtual returns (bool) {
864         return _owners[tokenId] != address(0);
865     }
866 
867     /**
868      * @dev Returns whether `spender` is allowed to manage `tokenId`.
869      *
870      * Requirements:
871      *
872      * - `tokenId` must exist.
873      */
874     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
875         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
876         address owner = ERC721.ownerOf(tokenId);
877         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
878     }
879 
880     /**
881      * @dev Safely mints `tokenId` and transfers it to `to`.
882      *
883      * Requirements:
884      *
885      * - `tokenId` must not exist.
886      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _safeMint(address to, uint256 tokenId) internal virtual {
891         _safeMint(to, tokenId, "");
892     }
893 
894     /**
895      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
896      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
897      */
898     function _safeMint(
899         address to,
900         uint256 tokenId,
901         bytes memory _data
902     ) internal virtual {
903         _mint(to, tokenId);
904         require(
905             _checkOnERC721Received(address(0), to, tokenId, _data),
906             "ERC721: transfer to non ERC721Receiver implementer"
907         );
908     }
909 
910     /**
911      * @dev Mints `tokenId` and transfers it to `to`.
912      *
913      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
914      *
915      * Requirements:
916      *
917      * - `tokenId` must not exist.
918      * - `to` cannot be the zero address.
919      *
920      * Emits a {Transfer} event.
921      */
922     function _mint(address to, uint256 tokenId) internal virtual {
923         require(to != address(0), "ERC721: mint to the zero address");
924         require(!_exists(tokenId), "ERC721: token already minted");
925 
926         _beforeTokenTransfer(address(0), to, tokenId);
927 
928         _balances[to] += 1;
929         _owners[tokenId] = to;
930 
931         emit Transfer(address(0), to, tokenId);
932     }
933 
934     /**
935      * @dev Destroys `tokenId`.
936      * The approval is cleared when the token is burned.
937      *
938      * Requirements:
939      *
940      * - `tokenId` must exist.
941      *
942      * Emits a {Transfer} event.
943      */
944     function _burn(uint256 tokenId) internal virtual {
945         address owner = ERC721.ownerOf(tokenId);
946 
947         _beforeTokenTransfer(owner, address(0), tokenId);
948 
949         // Clear approvals
950         _approve(address(0), tokenId);
951 
952         _balances[owner] -= 1;
953         delete _owners[tokenId];
954 
955         emit Transfer(owner, address(0), tokenId);
956     }
957 
958     /**
959      * @dev Transfers `tokenId` from `from` to `to`.
960      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
961      *
962      * Requirements:
963      *
964      * - `to` cannot be the zero address.
965      * - `tokenId` token must be owned by `from`.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _transfer(
970         address from,
971         address to,
972         uint256 tokenId
973     ) internal virtual {
974         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
975         require(to != address(0), "ERC721: transfer to the zero address");
976 
977         _beforeTokenTransfer(from, to, tokenId);
978 
979         // Clear approvals from the previous owner
980         _approve(address(0), tokenId);
981 
982         _balances[from] -= 1;
983         _balances[to] += 1;
984         _owners[tokenId] = to;
985 
986         emit Transfer(from, to, tokenId);
987     }
988 
989     /**
990      * @dev Approve `to` to operate on `tokenId`
991      *
992      * Emits a {Approval} event.
993      */
994     function _approve(address to, uint256 tokenId) internal virtual {
995         _tokenApprovals[tokenId] = to;
996         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
997     }
998 
999     /**
1000      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1001      * The call is not executed if the target address is not a contract.
1002      *
1003      * @param from address representing the previous owner of the given token ID
1004      * @param to target address that will receive the tokens
1005      * @param tokenId uint256 ID of the token to be transferred
1006      * @param _data bytes optional data to send along with the call
1007      * @return bool whether the call correctly returned the expected magic value
1008      */
1009     function _checkOnERC721Received(
1010         address from,
1011         address to,
1012         uint256 tokenId,
1013         bytes memory _data
1014     ) private returns (bool) {
1015         if (to.isContract()) {
1016             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1017                 return retval == IERC721Receiver(to).onERC721Received.selector;
1018             } catch (bytes memory reason) {
1019                 if (reason.length == 0) {
1020                     revert("ERC721: transfer to non ERC721Receiver implementer");
1021                 } else {
1022                     assembly {
1023                         revert(add(32, reason), mload(reason))
1024                     }
1025                 }
1026             }
1027         } else {
1028             return true;
1029         }
1030     }
1031 
1032     /**
1033      * @dev Hook that is called before any token transfer. This includes minting
1034      * and burning.
1035      *
1036      * Calling conditions:
1037      *
1038      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1039      * transferred to `to`.
1040      * - When `from` is zero, `tokenId` will be minted for `to`.
1041      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1042      * - `from` and `to` are never both zero.
1043      *
1044      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1045      */
1046     function _beforeTokenTransfer(
1047         address from,
1048         address to,
1049         uint256 tokenId
1050     ) internal virtual {}
1051 }
1052 
1053 // File: contracts/ChampionshipRings.sol
1054 
1055 pragma solidity ^0.8.4;
1056 
1057 
1058 
1059 
1060 contract ChampionshipRings is Ownable, ERC721 {
1061 
1062     event Mint(uint indexed _tokenId);
1063 
1064     uint public totalSupply = 0; // This is our mint counter as well
1065     mapping(uint => string) public tokenURIs; // Metadata location, updatable by owner
1066     string public _baseTokenURI; // Same for all tokens
1067     bool public paused = false;
1068     address public fcgAddr = 0x82258c0F6ad961CE259eA3A134d32484125E4E40;
1069 
1070     constructor() payable ERC721("FCG Championship Ring", "CHAMP") {
1071     }
1072 
1073     function mint(address to, uint[] memory tokenIds) external {
1074         require(!paused, "Paused");
1075         for (uint i = 0; i < tokenIds.length; i++) {
1076             require(!_exists(tokenIds[i]), "Token already minted");
1077             require(IERC721(fcgAddr).ownerOf(tokenIds[i]) == to, "Not the owner");
1078             _mint(to, tokenIds[i]);
1079             emit Mint(tokenIds[i]);
1080             totalSupply += 1;
1081         }
1082     }
1083 
1084     /**
1085      * @dev Returns a URI for a given token ID's metadata
1086      */
1087     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1088         return string(abi.encodePacked(_baseTokenURI, Strings.toString(_tokenId)));
1089     }
1090 
1091     // ADMIN FUNCTIONALITY
1092 
1093     /**
1094      * @dev Pauses or unpauses the contract
1095      */
1096     function setPaused(bool _paused) public onlyOwner {
1097         paused = _paused;
1098     }
1099 
1100     /**
1101      * @dev Updates the base token URI for the metadata
1102      */
1103     function setBaseTokenURI(string memory __baseTokenURI) public onlyOwner {
1104         _baseTokenURI = __baseTokenURI;
1105     }
1106 }