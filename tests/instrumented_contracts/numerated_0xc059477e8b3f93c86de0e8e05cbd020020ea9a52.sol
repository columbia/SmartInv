1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.7 <0.9.0;
3 
4 //import "@openzeppelin/contracts/utils/Strings.sol";
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10     uint8 private constant _ADDRESS_LENGTH = 20;
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
61             buffer[i] = _HEX_SYMBOLS[value & 0xf];
62             value >>= 4;
63         }
64         require(value == 0, "Strings: hex length insufficient");
65         return string(buffer);
66     }
67 
68     /**
69      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
70      */
71     function toHexString(address addr) internal pure returns (string memory) {
72         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
73     }
74 }
75 
76 
77 //import "../utils/Context.sol";
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 
99 //import "../../utils/Address.sol";
100 /**
101  * @dev Collection of functions related to the address type
102  */
103 library Address {
104     /**
105      * @dev Returns true if `account` is a contract.
106      *
107      * [IMPORTANT]
108      * ====
109      * It is unsafe to assume that an address for which this function returns
110      * false is an externally-owned account (EOA) and not a contract.
111      *
112      * Among others, `isContract` will return false for the following
113      * types of addresses:
114      *
115      *  - an externally-owned account
116      *  - a contract in construction
117      *  - an address where a contract will be created
118      *  - an address where a contract lived, but was destroyed
119      * ====
120      *
121      * [IMPORTANT]
122      * ====
123      * You shouldn't rely on `isContract` to protect against flash loan attacks!
124      *
125      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
126      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
127      * constructor.
128      * ====
129      */
130     function isContract(address account) internal view returns (bool) {
131         // This method relies on extcodesize/address.code.length, which returns 0
132         // for contracts in construction, since the code is only stored at the end
133         // of the constructor execution.
134 
135         return account.code.length > 0;
136     }
137 
138     /**
139      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
140      * `recipient`, forwarding all available gas and reverting on errors.
141      *
142      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
143      * of certain opcodes, possibly making contracts go over the 2300 gas limit
144      * imposed by `transfer`, making them unable to receive funds via
145      * `transfer`. {sendValue} removes this limitation.
146      *
147      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
148      *
149      * IMPORTANT: because control is transferred to `recipient`, care must be
150      * taken to not create reentrancy vulnerabilities. Consider using
151      * {ReentrancyGuard} or the
152      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
153      */
154     function sendValue(address payable recipient, uint256 amount) internal {
155         require(address(this).balance >= amount, "Address: insufficient balance");
156 
157         (bool success, ) = recipient.call{value: amount}("");
158         require(success, "Address: unable to send value, recipient may have reverted");
159     }
160 
161     /**
162      * @dev Performs a Solidity function call using a low level `call`. A
163      * plain `call` is an unsafe replacement for a function call: use this
164      * function instead.
165      *
166      * If `target` reverts with a revert reason, it is bubbled up by this
167      * function (like regular Solidity function calls).
168      *
169      * Returns the raw returned data. To convert to the expected return value,
170      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
171      *
172      * Requirements:
173      *
174      * - `target` must be a contract.
175      * - calling `target` with `data` must not revert.
176      *
177      * _Available since v3.1._
178      */
179     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionCall(target, data, "Address: low-level call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
185      * `errorMessage` as a fallback revert reason when `target` reverts.
186      *
187      * _Available since v3.1._
188      */
189     function functionCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         return functionCallWithValue(target, data, 0, errorMessage);
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
199      * but also transferring `value` wei to `target`.
200      *
201      * Requirements:
202      *
203      * - the calling contract must have an ETH balance of at least `value`.
204      * - the called Solidity function must be `payable`.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value
212     ) internal returns (bytes memory) {
213         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
218      * with `errorMessage` as a fallback revert reason when `target` reverts.
219      *
220      * _Available since v3.1._
221      */
222     function functionCallWithValue(
223         address target,
224         bytes memory data,
225         uint256 value,
226         string memory errorMessage
227     ) internal returns (bytes memory) {
228         require(address(this).balance >= value, "Address: insufficient balance for call");
229         require(isContract(target), "Address: call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.call{value: value}(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a static call.
238      *
239      * _Available since v3.3._
240      */
241     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
242         return functionStaticCall(target, data, "Address: low-level static call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a static call.
248      *
249      * _Available since v3.3._
250      */
251     function functionStaticCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal view returns (bytes memory) {
256         require(isContract(target), "Address: static call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.staticcall(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
264      * but performing a delegate call.
265      *
266      * _Available since v3.4._
267      */
268     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
269         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
274      * but performing a delegate call.
275      *
276      * _Available since v3.4._
277      */
278     function functionDelegateCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal returns (bytes memory) {
283         require(isContract(target), "Address: delegate call to non-contract");
284 
285         (bool success, bytes memory returndata) = target.delegatecall(data);
286         return verifyCallResult(success, returndata, errorMessage);
287     }
288 
289     /**
290      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
291      * revert reason using the provided one.
292      *
293      * _Available since v4.3._
294      */
295     function verifyCallResult(
296         bool success,
297         bytes memory returndata,
298         string memory errorMessage
299     ) internal pure returns (bytes memory) {
300         if (success) {
301             return returndata;
302         } else {
303             // Look for revert reason and bubble it up if present
304             if (returndata.length > 0) {
305                 // The easiest way to bubble the revert reason is using memory via assembly
306                 /// @solidity memory-safe-assembly
307                 assembly {
308                     let returndata_size := mload(returndata)
309                     revert(add(32, returndata), returndata_size)
310                 }
311             } else {
312                 revert(errorMessage);
313             }
314         }
315     }
316 }
317 
318 
319 //import "@openzeppelin/contracts/access/Ownable.sol";
320 /**
321  * @dev Contract module which provides a basic access control mechanism, where
322  * there is an account (an owner) that can be granted exclusive access to
323  * specific functions.
324  *
325  * By default, the owner account will be the one that deploys the contract. This
326  * can later be changed with {transferOwnership}.
327  *
328  * This module is used through inheritance. It will make available the modifier
329  * `onlyOwner`, which can be applied to your functions to restrict their use to
330  * the owner.
331  */
332 abstract contract Ownable is Context {
333     address private _owner;
334 
335     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
336 
337     /**
338      * @dev Initializes the contract setting the deployer as the initial owner.
339      */
340     constructor() {
341         _transferOwnership(_msgSender());
342     }
343 
344     /**
345      * @dev Throws if called by any account other than the owner.
346      */
347     modifier onlyOwner() {
348         _checkOwner();
349         _;
350     }
351 
352     /**
353      * @dev Returns the address of the current owner.
354      */
355     function owner() public view virtual returns (address) {
356         return _owner;
357     }
358 
359     /**
360      * @dev Throws if the sender is not the owner.
361      */
362     function _checkOwner() internal view virtual {
363         require(owner() == _msgSender(), "Ownable: caller is not the owner");
364     }
365 
366     /**
367      * @dev Leaves the contract without owner. It will not be possible to call
368      * `onlyOwner` functions anymore. Can only be called by the current owner.
369      *
370      * NOTE: Renouncing ownership will leave the contract without an owner,
371      * thereby removing any functionality that is only available to the owner.
372      */
373     function renounceOwnership() public virtual onlyOwner {
374         _transferOwnership(address(0));
375     }
376 
377     /**
378      * @dev Transfers ownership of the contract to a new account (`newOwner`).
379      * Can only be called by the current owner.
380      */
381     function transferOwnership(address newOwner) public virtual onlyOwner {
382         require(newOwner != address(0), "Ownable: new owner is the zero address");
383         _transferOwnership(newOwner);
384     }
385 
386     /**
387      * @dev Transfers ownership of the contract to a new account (`newOwner`).
388      * Internal function without access restriction.
389      */
390     function _transferOwnership(address newOwner) internal virtual {
391         address oldOwner = _owner;
392         _owner = newOwner;
393         emit OwnershipTransferred(oldOwner, newOwner);
394     }
395 }
396 
397 
398 //import "./IERC165.sol";
399 /**
400  * @dev Interface of the ERC165 standard, as defined in the
401  * https://eips.ethereum.org/EIPS/eip-165[EIP].
402  *
403  * Implementers can declare support of contract interfaces, which can then be
404  * queried by others ({ERC165Checker}).
405  *
406  * For an implementation, see {ERC165}.
407  */
408 interface IERC165 {
409     /**
410      * @dev Returns true if this contract implements the interface defined by
411      * `interfaceId`. See the corresponding
412      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
413      * to learn more about how these ids are created.
414      *
415      * This function call must use less than 30 000 gas.
416      */
417     function supportsInterface(bytes4 interfaceId) external view returns (bool);
418 }
419 
420 
421 //import "./IERC721.sol";
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
456      * @dev Safely transfers `tokenId` token from `from` to `to`.
457      *
458      * Requirements:
459      *
460      * - `from` cannot be the zero address.
461      * - `to` cannot be the zero address.
462      * - `tokenId` token must exist and be owned by `from`.
463      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
464      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
465      *
466      * Emits a {Transfer} event.
467      */
468     function safeTransferFrom(
469         address from,
470         address to,
471         uint256 tokenId,
472         bytes calldata data
473     ) external;
474 
475     /**
476      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
477      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
478      *
479      * Requirements:
480      *
481      * - `from` cannot be the zero address.
482      * - `to` cannot be the zero address.
483      * - `tokenId` token must exist and be owned by `from`.
484      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
485      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
486      *
487      * Emits a {Transfer} event.
488      */
489     function safeTransferFrom(
490         address from,
491         address to,
492         uint256 tokenId
493     ) external;
494 
495     /**
496      * @dev Transfers `tokenId` token from `from` to `to`.
497      *
498      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
499      *
500      * Requirements:
501      *
502      * - `from` cannot be the zero address.
503      * - `to` cannot be the zero address.
504      * - `tokenId` token must be owned by `from`.
505      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
506      *
507      * Emits a {Transfer} event.
508      */
509     function transferFrom(
510         address from,
511         address to,
512         uint256 tokenId
513     ) external;
514 
515     /**
516      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
517      * The approval is cleared when the token is transferred.
518      *
519      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
520      *
521      * Requirements:
522      *
523      * - The caller must own the token or be an approved operator.
524      * - `tokenId` must exist.
525      *
526      * Emits an {Approval} event.
527      */
528     function approve(address to, uint256 tokenId) external;
529 
530     /**
531      * @dev Approve or remove `operator` as an operator for the caller.
532      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
533      *
534      * Requirements:
535      *
536      * - The `operator` cannot be the caller.
537      *
538      * Emits an {ApprovalForAll} event.
539      */
540     function setApprovalForAll(address operator, bool _approved) external;
541 
542     /**
543      * @dev Returns the account approved for `tokenId` token.
544      *
545      * Requirements:
546      *
547      * - `tokenId` must exist.
548      */
549     function getApproved(uint256 tokenId) external view returns (address operator);
550 
551     /**
552      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
553      *
554      * See {setApprovalForAll}
555      */
556     function isApprovedForAll(address owner, address operator) external view returns (bool);
557 }
558 
559 
560 //import "./IERC721Receiver.sol";
561 /**
562  * @title ERC721 token receiver interface
563  * @dev Interface for any contract that wants to support safeTransfers
564  * from ERC721 asset contracts.
565  */
566 interface IERC721Receiver {
567     /**
568      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
569      * by `operator` from `from`, this function is called.
570      *
571      * It must return its Solidity selector to confirm the token transfer.
572      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
573      *
574      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
575      */
576     function onERC721Received(
577         address operator,
578         address from,
579         uint256 tokenId,
580         bytes calldata data
581     ) external returns (bytes4);
582 }
583 
584 
585 //import "./extensions/IERC721Metadata.sol";
586 /**
587  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
588  * @dev See https://eips.ethereum.org/EIPS/eip-721
589  */
590 interface IERC721Metadata is IERC721 {
591     /**
592      * @dev Returns the token collection name.
593      */
594     function name() external view returns (string memory);
595 
596     /**
597      * @dev Returns the token collection symbol.
598      */
599     function symbol() external view returns (string memory);
600 
601     /**
602      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
603      */
604     function tokenURI(uint256 tokenId) external view returns (string memory);
605 }
606 
607 
608 
609 //import "../../utils/introspection/ERC165.sol";
610 /**
611  * @dev Implementation of the {IERC165} interface.
612  *
613  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
614  * for the additional interface id that will be supported. For example:
615  *
616  * ```solidity
617  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
618  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
619  * }
620  * ```
621  *
622  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
623  */
624 abstract contract ERC165 is IERC165 {
625     /**
626      * @dev See {IERC165-supportsInterface}.
627      */
628     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
629         return interfaceId == type(IERC165).interfaceId;
630     }
631 }
632 
633 
634 //import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
635 /**
636  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
637  * the Metadata extension, but not including the Enumerable extension, which is available separately as
638  * {ERC721Enumerable}.
639  */
640 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
641     using Address for address;
642     using Strings for uint256;
643 
644     // Token name
645     string private _name;
646 
647     // Token symbol
648     string private _symbol;
649 
650     // Mapping from token ID to owner address
651     mapping(uint256 => address) private _owners;
652 
653     // Mapping owner address to token count
654     mapping(address => uint256) private _balances;
655 
656     // Mapping from token ID to approved address
657     mapping(uint256 => address) private _tokenApprovals;
658 
659     // Mapping from owner to operator approvals
660     mapping(address => mapping(address => bool)) private _operatorApprovals;
661 
662     /**
663      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
664      */
665     constructor(string memory name_, string memory symbol_) {
666         _name = name_;
667         _symbol = symbol_;
668     }
669 
670     /**
671      * @dev See {IERC165-supportsInterface}.
672      */
673     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
674         return
675             interfaceId == type(IERC721).interfaceId ||
676             interfaceId == type(IERC721Metadata).interfaceId ||
677             super.supportsInterface(interfaceId);
678     }
679 
680     /**
681      * @dev See {IERC721-balanceOf}.
682      */
683     function balanceOf(address owner) public view virtual override returns (uint256) {
684         require(owner != address(0), "ERC721: address zero is not a valid owner");
685         return _balances[owner];
686     }
687 
688     /**
689      * @dev See {IERC721-ownerOf}.
690      */
691     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
692         address owner = _owners[tokenId];
693         require(owner != address(0), "ERC721: invalid token ID");
694         return owner;
695     }
696 
697     /**
698      * @dev See {IERC721Metadata-name}.
699      */
700     function name() public view virtual override returns (string memory) {
701         return _name;
702     }
703 
704     /**
705      * @dev See {IERC721Metadata-symbol}.
706      */
707     function symbol() public view virtual override returns (string memory) {
708         return _symbol;
709     }
710 
711     /**
712      * @dev See {IERC721Metadata-tokenURI}.
713      */
714     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
715         _requireMinted(tokenId);
716 
717         string memory baseURI = _baseURI();
718         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
719     }
720 
721     /**
722      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
723      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
724      * by default, can be overridden in child contracts.
725      */
726     function _baseURI() internal view virtual returns (string memory) {
727         return "";
728     }
729 
730     /**
731      * @dev See {IERC721-approve}.
732      */
733     function approve(address to, uint256 tokenId) public virtual override {
734         address owner = ERC721.ownerOf(tokenId);
735         require(to != owner, "ERC721: approval to current owner");
736 
737         require(
738             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
739             "ERC721: approve caller is not token owner nor approved for all"
740         );
741 
742         _approve(to, tokenId);
743     }
744 
745     /**
746      * @dev See {IERC721-getApproved}.
747      */
748     function getApproved(uint256 tokenId) public view virtual override returns (address) {
749         _requireMinted(tokenId);
750 
751         return _tokenApprovals[tokenId];
752     }
753 
754     /**
755      * @dev See {IERC721-setApprovalForAll}.
756      */
757     function setApprovalForAll(address operator, bool approved) public virtual override {
758         _setApprovalForAll(_msgSender(), operator, approved);
759     }
760 
761     /**
762      * @dev See {IERC721-isApprovedForAll}.
763      */
764     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
765         return _operatorApprovals[owner][operator];
766     }
767 
768     /**
769      * @dev See {IERC721-transferFrom}.
770      */
771     function transferFrom(
772         address from,
773         address to,
774         uint256 tokenId
775     ) public virtual override {
776         //solhint-disable-next-line max-line-length
777         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
778 
779         _transfer(from, to, tokenId);
780     }
781 
782     /**
783      * @dev See {IERC721-safeTransferFrom}.
784      */
785     function safeTransferFrom(
786         address from,
787         address to,
788         uint256 tokenId
789     ) public virtual override {
790         safeTransferFrom(from, to, tokenId, "");
791     }
792 
793     /**
794      * @dev See {IERC721-safeTransferFrom}.
795      */
796     function safeTransferFrom(
797         address from,
798         address to,
799         uint256 tokenId,
800         bytes memory data
801     ) public virtual override {
802         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
803         _safeTransfer(from, to, tokenId, data);
804     }
805 
806     /**
807      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
808      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
809      *
810      * `data` is additional data, it has no specified format and it is sent in call to `to`.
811      *
812      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
813      * implement alternative mechanisms to perform token transfer, such as signature-based.
814      *
815      * Requirements:
816      *
817      * - `from` cannot be the zero address.
818      * - `to` cannot be the zero address.
819      * - `tokenId` token must exist and be owned by `from`.
820      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
821      *
822      * Emits a {Transfer} event.
823      */
824     function _safeTransfer(
825         address from,
826         address to,
827         uint256 tokenId,
828         bytes memory data
829     ) internal virtual {
830         _transfer(from, to, tokenId);
831         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
832     }
833 
834     /**
835      * @dev Returns whether `tokenId` exists.
836      *
837      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
838      *
839      * Tokens start existing when they are minted (`_mint`),
840      * and stop existing when they are burned (`_burn`).
841      */
842     function _exists(uint256 tokenId) internal view virtual returns (bool) {
843         return _owners[tokenId] != address(0);
844     }
845 
846     /**
847      * @dev Returns whether `spender` is allowed to manage `tokenId`.
848      *
849      * Requirements:
850      *
851      * - `tokenId` must exist.
852      */
853     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
854         address owner = ERC721.ownerOf(tokenId);
855         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
856     }
857 
858     /**
859      * @dev Safely mints `tokenId` and transfers it to `to`.
860      *
861      * Requirements:
862      *
863      * - `tokenId` must not exist.
864      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
865      *
866      * Emits a {Transfer} event.
867      */
868     function _safeMint(address to, uint256 tokenId) internal virtual {
869         _safeMint(to, tokenId, "");
870     }
871 
872     /**
873      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
874      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
875      */
876     function _safeMint(
877         address to,
878         uint256 tokenId,
879         bytes memory data
880     ) internal virtual {
881         _mint(to, tokenId);
882         require(
883             _checkOnERC721Received(address(0), to, tokenId, data),
884             "ERC721: transfer to non ERC721Receiver implementer"
885         );
886     }
887 
888     /**
889      * @dev Mints `tokenId` and transfers it to `to`.
890      *
891      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
892      *
893      * Requirements:
894      *
895      * - `tokenId` must not exist.
896      * - `to` cannot be the zero address.
897      *
898      * Emits a {Transfer} event.
899      */
900     function _mint(address to, uint256 tokenId) internal virtual {
901         require(to != address(0), "ERC721: mint to the zero address");
902         require(!_exists(tokenId), "ERC721: token already minted");
903 
904         _beforeTokenTransfer(address(0), to, tokenId);
905 
906         _balances[to] += 1;
907         _owners[tokenId] = to;
908 
909         emit Transfer(address(0), to, tokenId);
910 
911         _afterTokenTransfer(address(0), to, tokenId);
912     }
913 
914     /**
915      * @dev Destroys `tokenId`.
916      * The approval is cleared when the token is burned.
917      *
918      * Requirements:
919      *
920      * - `tokenId` must exist.
921      *
922      * Emits a {Transfer} event.
923      */
924     function _burn(uint256 tokenId) internal virtual {
925         address owner = ERC721.ownerOf(tokenId);
926 
927         _beforeTokenTransfer(owner, address(0), tokenId);
928 
929         // Clear approvals
930         _approve(address(0), tokenId);
931 
932         _balances[owner] -= 1;
933         delete _owners[tokenId];
934 
935         emit Transfer(owner, address(0), tokenId);
936 
937         _afterTokenTransfer(owner, address(0), tokenId);
938     }
939 
940     /**
941      * @dev Transfers `tokenId` from `from` to `to`.
942      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
943      *
944      * Requirements:
945      *
946      * - `to` cannot be the zero address.
947      * - `tokenId` token must be owned by `from`.
948      *
949      * Emits a {Transfer} event.
950      */
951     function _transfer(
952         address from,
953         address to,
954         uint256 tokenId
955     ) internal virtual {
956         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
957         require(to != address(0), "ERC721: transfer to the zero address");
958 
959         _beforeTokenTransfer(from, to, tokenId);
960 
961         // Clear approvals from the previous owner
962         _approve(address(0), tokenId);
963 
964         _balances[from] -= 1;
965         _balances[to] += 1;
966         _owners[tokenId] = to;
967 
968         emit Transfer(from, to, tokenId);
969 
970         _afterTokenTransfer(from, to, tokenId);
971     }
972 
973     /**
974      * @dev Approve `to` to operate on `tokenId`
975      *
976      * Emits an {Approval} event.
977      */
978     function _approve(address to, uint256 tokenId) internal virtual {
979         _tokenApprovals[tokenId] = to;
980         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
981     }
982 
983     /**
984      * @dev Approve `operator` to operate on all of `owner` tokens
985      *
986      * Emits an {ApprovalForAll} event.
987      */
988     function _setApprovalForAll(
989         address owner,
990         address operator,
991         bool approved
992     ) internal virtual {
993         require(owner != operator, "ERC721: approve to caller");
994         _operatorApprovals[owner][operator] = approved;
995         emit ApprovalForAll(owner, operator, approved);
996     }
997 
998     /**
999      * @dev Reverts if the `tokenId` has not been minted yet.
1000      */
1001     function _requireMinted(uint256 tokenId) internal view virtual {
1002         require(_exists(tokenId), "ERC721: invalid token ID");
1003     }
1004 
1005     /**
1006      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1007      * The call is not executed if the target address is not a contract.
1008      *
1009      * @param from address representing the previous owner of the given token ID
1010      * @param to target address that will receive the tokens
1011      * @param tokenId uint256 ID of the token to be transferred
1012      * @param data bytes optional data to send along with the call
1013      * @return bool whether the call correctly returned the expected magic value
1014      */
1015     function _checkOnERC721Received(
1016         address from,
1017         address to,
1018         uint256 tokenId,
1019         bytes memory data
1020     ) private returns (bool) {
1021         if (to.isContract()) {
1022             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1023                 return retval == IERC721Receiver.onERC721Received.selector;
1024             } catch (bytes memory reason) {
1025                 if (reason.length == 0) {
1026                     revert("ERC721: transfer to non ERC721Receiver implementer");
1027                 } else {
1028                     /// @solidity memory-safe-assembly
1029                     assembly {
1030                         revert(add(32, reason), mload(reason))
1031                     }
1032                 }
1033             }
1034         } else {
1035             return true;
1036         }
1037     }
1038 
1039     /**
1040      * @dev Hook that is called before any token transfer. This includes minting
1041      * and burning.
1042      *
1043      * Calling conditions:
1044      *
1045      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1046      * transferred to `to`.
1047      * - When `from` is zero, `tokenId` will be minted for `to`.
1048      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1049      * - `from` and `to` are never both zero.
1050      *
1051      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1052      */
1053     function _beforeTokenTransfer(
1054         address from,
1055         address to,
1056         uint256 tokenId
1057     ) internal virtual {}
1058 
1059     /**
1060      * @dev Hook that is called after any transfer of tokens. This includes
1061      * minting and burning.
1062      *
1063      * Calling conditions:
1064      *
1065      * - when `from` and `to` are both non-zero.
1066      * - `from` and `to` are never both zero.
1067      *
1068      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1069      */
1070     function _afterTokenTransfer(
1071         address from,
1072         address to,
1073         uint256 tokenId
1074     ) internal virtual {}
1075 }
1076 
1077 
1078 //import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
1079 /**
1080  * @dev Contract module that helps prevent reentrant calls to a function.
1081  *
1082  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1083  * available, which can be applied to functions to make sure there are no nested
1084  * (reentrant) calls to them.
1085  *
1086  * Note that because there is a single `nonReentrant` guard, functions marked as
1087  * `nonReentrant` may not call one another. This can be worked around by making
1088  * those functions `private`, and then adding `external` `nonReentrant` entry
1089  * points to them.
1090  *
1091  * TIP: If you would like to learn more about reentrancy and alternative ways
1092  * to protect against it, check out our blog post
1093  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1094  */
1095 abstract contract ReentrancyGuard {
1096     // Booleans are more expensive than uint256 or any type that takes up a full
1097     // word because each write operation emits an extra SLOAD to first read the
1098     // slot's contents, replace the bits taken up by the boolean, and then write
1099     // back. This is the compiler's defense against contract upgrades and
1100     // pointer aliasing, and it cannot be disabled.
1101 
1102     // The values being non-zero value makes deployment a bit more expensive,
1103     // but in exchange the refund on every call to nonReentrant will be lower in
1104     // amount. Since refunds are capped to a percentage of the total
1105     // transaction's gas, it is best to keep them low in cases like this one, to
1106     // increase the likelihood of the full refund coming into effect.
1107     uint256 private constant _NOT_ENTERED = 1;
1108     uint256 private constant _ENTERED = 2;
1109 
1110     uint256 private _status;
1111 
1112     constructor() {
1113         _status = _NOT_ENTERED;
1114     }
1115 
1116     /**
1117      * @dev Prevents a contract from calling itself, directly or indirectly.
1118      * Calling a `nonReentrant` function from another `nonReentrant`
1119      * function is not supported. It is possible to prevent this from happening
1120      * by making the `nonReentrant` function external, and making it call a
1121      * `private` function that does the actual work.
1122      */
1123     modifier nonReentrant() {
1124         // On the first call to nonReentrant, _notEntered will be true
1125         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1126 
1127         // Any calls to nonReentrant after this point will fail
1128         _status = _ENTERED;
1129 
1130         _;
1131 
1132         // By storing the original value once again, a refund is triggered (see
1133         // https://eips.ethereum.org/EIPS/eip-2200)
1134         _status = _NOT_ENTERED;
1135     }
1136 }
1137 
1138 //import "./Common/IPurchasedChecker.sol";
1139 //--------------------------------------------
1140 // PurchasedChecker interface
1141 //--------------------------------------------
1142 interface IPurchasedChecker {
1143     //--------------------
1144     // function
1145     //--------------------
1146     function checkPurchased( address target ) external view returns (uint256);
1147     function checkPurchasedOnPrivate( address target ) external view returns (uint256);
1148     function checkPurchasedOnPublic( address target ) external view returns (uint256);
1149 }
1150 
1151 
1152 //import "./Common/IWhitelist.sol";
1153 //--------------------------------------------
1154 // WHITELIST intterface
1155 //--------------------------------------------
1156 interface IWhitelist {
1157     //--------------------
1158     // function
1159     //--------------------
1160     function check( address target ) external view returns (bool);
1161 }
1162 
1163 //------------------------------------------------------------
1164 // Token(ERC721)
1165 //------------------------------------------------------------
1166 contract Token is Ownable, ERC721, ReentrancyGuard, IPurchasedChecker {
1167     //--------------------------------------------------------
1168     // 定数
1169     //--------------------------------------------------------
1170     string constant private TOKEN_NAME = "MetaIdol";
1171     string constant private TOKEN_SYMBOL = "MI";
1172 
1173     // mainnet
1174     address constant private OWNER_ADDRESS = 0xE2E577A889f2EB52C84c34E4539D33798987B6d2;
1175 
1176     // constant
1177     uint256 constant private TOKEN_ID_OFS = 1;
1178     uint256 constant private BLOCK_SEC_MARGIN = 30;
1179 
1180     // enum
1181     uint256 constant private INFO_SALE_SUSPENDED = 0;
1182     uint256 constant private INFO_SALE_START = 1;
1183     uint256 constant private INFO_SALE_END = 2;
1184     uint256 constant private INFO_SALE_PRICE = 3;
1185     uint256 constant private INFO_SALE_WHITELISTED = 4;
1186     uint256 constant private INFO_SALE_USER_MINTED = 5;
1187     uint256 constant private INFO_SALE_USER_MINTABLE = 6;
1188     uint256 constant private INFO_MAX = 7;
1189     uint256 constant private USER_INFO_SALE_TYPE = INFO_MAX;
1190     uint256 constant private USER_INFO_TOTAL_SUPPLY = INFO_MAX + 1;
1191     uint256 constant private USER_INFO_TOKEN_MAX = INFO_MAX + 2;
1192     uint256 constant private USER_INFO_MINT_LIMIT = INFO_MAX + 3;
1193     uint256 constant private USER_INFO_MAX = INFO_MAX + 4;
1194 
1195     //--------------------------------------------------------
1196     // 管理
1197     //--------------------------------------------------------
1198     address private _manager;
1199 
1200     //--------------------------------------------------------
1201     // ストレージ
1202     //--------------------------------------------------------
1203     string private _base_uri_for_hidden;
1204     string private _base_uri_for_revealed;
1205     uint256 private _token_max;
1206     uint256 private _token_reserved;
1207     uint256 private _token_mint_limit;
1208     uint256 private _total_supply;
1209 
1210     // PRIVATE(whitelist)
1211     bool private _PRIVATE_SALE_is_suspended;
1212     uint256 private _PRIVATE_SALE_start;
1213     uint256 private _PRIVATE_SALE_end;
1214     uint256 private _PRIVATE_SALE_price;
1215     uint256 private _PRIVATE_SALE_mintable;
1216     IWhitelist[] private _PRIVATE_SALE_arr_whitelist;
1217     mapping( address => uint256 ) private _PRIVATE_SALE_map_user_minted;
1218 
1219     // PUBLIC
1220     bool private _PUBLIC_SALE_is_suspended;
1221     uint256 private _PUBLIC_SALE_start;
1222     uint256 private _PUBLIC_SALE_end;
1223     uint256 private _PUBLIC_SALE_price;
1224     uint256 private _PUBLIC_SALE_mintable;
1225     mapping( address => uint256 ) private _PUBLIC_SALE_map_user_minted;
1226 
1227     //--------------------------------------------------------
1228     // [modifier] onlyOwnerOrManager
1229     //--------------------------------------------------------
1230     modifier onlyOwnerOrManager() {
1231         require( msg.sender == owner() || msg.sender == manager(), "caller is not the owner neither manager" );
1232         _;
1233     }
1234 
1235     //--------------------------------------------------------
1236     // コンストラクタ
1237     //--------------------------------------------------------
1238     constructor() Ownable() ERC721( TOKEN_NAME, TOKEN_SYMBOL ) {
1239         transferOwnership( OWNER_ADDRESS );
1240         _manager = msg.sender;
1241 
1242         //-----------------------
1243         // mainnet
1244         //-----------------------
1245         _base_uri_for_hidden = "ipfs://QmX3S9CtNxNBGvy31rNcSCD6LCmwcH3JxTwhUXWzLXBnNJ/";
1246         //_base_uri_for_revealed = "";
1247         _token_max = 1111;
1248         _token_reserved = 50;
1249         _token_mint_limit = 20;
1250 
1251         //***********************
1252         // PRIVATE(whitelist)
1253         //***********************
1254         _PRIVATE_SALE_start = 1659013200;               // 2022-07-28 22:00:00(JST)
1255         _PRIVATE_SALE_end   = 1659099600;               // 2022-07-29 22:00:00(JST)
1256         _PRIVATE_SALE_price = 22000000000000000;        // 0.022 ETH
1257         _PRIVATE_SALE_mintable = 5;                     // 5 nft
1258         _PRIVATE_SALE_arr_whitelist.push( IWhitelist(0xc30Be91bDB2B8211eB7225ecfF7C49E61F6F26f6) );
1259         
1260         //~~~~~~~~~~~~~~~~~~~~~~~
1261         // PUBLIC
1262         //~~~~~~~~~~~~~~~~~~~~~~~
1263         _PUBLIC_SALE_start = 1659099600;                // 2022-07-29 22:00:00(JST)
1264         _PUBLIC_SALE_end   = 1659186000;                // 2022-07-30 22:00:00(JST)
1265         _PUBLIC_SALE_price = 23000000000000000;         // 0.023 ETH
1266         _PUBLIC_SALE_mintable = 0;                      // no limitation
1267     }
1268 
1269     //--------------------------------------------------------
1270     // [public] manager
1271     //--------------------------------------------------------
1272     function manager() public view returns (address) {
1273         return( _manager );
1274     }
1275 
1276     //--------------------------------------------------------
1277     // [external/onlyOwner] setManager
1278     //--------------------------------------------------------
1279     function setManager( address target ) external onlyOwner {
1280         _manager = target;
1281     }
1282 
1283     //--------------------------------------------------------
1284     // [external] get
1285     //--------------------------------------------------------
1286     function baseUriForHidden() external view returns (string memory) { return( _base_uri_for_hidden ); }
1287     function baseUriForRevealed() external view returns (string memory) { return( _base_uri_for_revealed ); }
1288     function tokenMax() external view returns (uint256) { return( _token_max ); }
1289     function tokenReserved() external view returns (uint256) { return( _token_reserved ); }
1290     function tokenMintLimit() external view returns (uint256) { return( _token_mint_limit ); }    
1291     function totalSupply() external view returns (uint256) { return( _total_supply ); }
1292 
1293     //--------------------------------------------------------
1294     // [external/onlyOwnerOrManager] set
1295     //--------------------------------------------------------
1296     function setBaseUriForHidden( string calldata uri ) external onlyOwnerOrManager { _base_uri_for_hidden = uri; }
1297     function setBaseUriForRevealed( string calldata uri ) external onlyOwnerOrManager { _base_uri_for_revealed = uri; }
1298     function setTokenMax( uint256 max ) external onlyOwnerOrManager { _token_max = max; }
1299     function setTokenReserved( uint256 reserved ) external onlyOwnerOrManager { _token_reserved = reserved; }
1300     function setTokenMintLimit( uint256 limit ) external onlyOwnerOrManager { _token_mint_limit = limit; }
1301 
1302     //--------------------------------------------------------
1303     // [public/override] tokenURI
1304     //--------------------------------------------------------
1305     function tokenURI( uint256 tokenId ) public view override returns (string memory) {
1306         require( _exists( tokenId ), "nonexistent token" );
1307 
1308         if( bytes(_base_uri_for_revealed).length > 0 ){
1309             return( string( abi.encodePacked( _base_uri_for_revealed, Strings.toString( tokenId ) ) ) );            
1310         }
1311 
1312         return( string( abi.encodePacked( _base_uri_for_hidden, Strings.toString( tokenId ) ) ) );
1313     }
1314 
1315     //********************************************************
1316     // [public] getInfo - PRIVATE(whitelist)
1317     //********************************************************
1318     function PRIVATE_SALE_getInfo( address target ) public view returns (uint256[INFO_MAX] memory) {
1319         uint256[INFO_MAX] memory arrRet;
1320 
1321         if( _PRIVATE_SALE_is_suspended ){ arrRet[INFO_SALE_SUSPENDED] = 1; }
1322         arrRet[INFO_SALE_START] = _PRIVATE_SALE_start;
1323         arrRet[INFO_SALE_END] = _PRIVATE_SALE_end;
1324         arrRet[INFO_SALE_PRICE] = _PRIVATE_SALE_price;
1325         if( _checkWhitelist( _PRIVATE_SALE_arr_whitelist, target ) ){ arrRet[INFO_SALE_WHITELISTED] = 1; }
1326         arrRet[INFO_SALE_USER_MINTED] = _PRIVATE_SALE_map_user_minted[target];
1327         arrRet[INFO_SALE_USER_MINTABLE] = _PRIVATE_SALE_mintable;
1328 
1329         return( arrRet );
1330     }
1331 
1332     //********************************************************
1333     // [external/onlyOwnerOrManager] write - PRIVATE(whitelist)
1334     //********************************************************
1335     // is_suspended
1336     function PRIVATE_SALE_suspend( bool flag ) external onlyOwnerOrManager {
1337         _PRIVATE_SALE_is_suspended = flag;
1338     }
1339 
1340     // start-end
1341     function PRIVATE_SALE_setStartEnd( uint256 start, uint256 end ) external onlyOwnerOrManager {
1342         _PRIVATE_SALE_start = start;
1343         _PRIVATE_SALE_end = end;
1344     }
1345 
1346     // price
1347     function PRIVATE_SALE_setPrice( uint256 price ) external onlyOwnerOrManager {
1348         _PRIVATE_SALE_price = price;
1349     }
1350 
1351     // mintable
1352     function PRIVATE_SALE_setMintable( uint256 mintable ) external onlyOwnerOrManager {
1353         _PRIVATE_SALE_mintable = mintable;
1354     }
1355 
1356     // whitelist
1357     function PRIVATE_SALE_setWhiteList( address[] calldata lists ) external onlyOwnerOrManager {
1358         delete _PRIVATE_SALE_arr_whitelist;
1359 
1360         for( uint256 i=0; i<lists.length; i++ ){
1361             require( lists[i] != address(0), "PRIVATE: invalid list"  );
1362             _PRIVATE_SALE_arr_whitelist.push( IWhitelist(lists[i]) );
1363         }
1364     }
1365 
1366     //********************************************************
1367     // [external/payable/nonReentrant] mint - PRIVATE(whitelist)
1368     //********************************************************
1369     function PRIVATE_SALE_mint( uint256 num ) external payable nonReentrant {
1370         uint256[INFO_MAX] memory arrInfo = PRIVATE_SALE_getInfo( msg.sender );
1371 
1372         require( arrInfo[INFO_SALE_SUSPENDED] == 0, "PRIVATE SALE: suspended" );
1373         require( arrInfo[INFO_SALE_START] == 0 || arrInfo[INFO_SALE_START] <= (block.timestamp+BLOCK_SEC_MARGIN), "PRIVATE SALE: not opend" );
1374         require( arrInfo[INFO_SALE_END] == 0 || (arrInfo[INFO_SALE_END]+BLOCK_SEC_MARGIN) > block.timestamp, "PRIVATE SALE: finished" );
1375         require( arrInfo[INFO_SALE_WHITELISTED] == 1, "PRIVATE SALE: not whitelisted" );
1376         require( arrInfo[INFO_SALE_USER_MINTABLE] == 0 || arrInfo[INFO_SALE_USER_MINTABLE] >= (arrInfo[INFO_SALE_USER_MINTED]+num), "PRIVATE SALE: reached the limit" );
1377 
1378         _checkPayment( msg.sender, arrInfo[INFO_SALE_PRICE]*num, msg.value );
1379 
1380         _mintTokens( msg.sender, num );
1381         _PRIVATE_SALE_map_user_minted[msg.sender] += num;
1382     }
1383 
1384     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1385     // [public] getInfo - PUBLIC
1386     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1387     function PUBLIC_SALE_getInfo( address target ) public view returns (uint256[INFO_MAX] memory) {
1388         uint256[INFO_MAX] memory arrRet;
1389 
1390         if( _PUBLIC_SALE_is_suspended ){ arrRet[INFO_SALE_SUSPENDED] = 1; }
1391         arrRet[INFO_SALE_START] = _PUBLIC_SALE_start;
1392         arrRet[INFO_SALE_END] = _PUBLIC_SALE_end;
1393         arrRet[INFO_SALE_PRICE] = _PUBLIC_SALE_price;
1394         arrRet[INFO_SALE_WHITELISTED] = 1;
1395         arrRet[INFO_SALE_USER_MINTED] = _PUBLIC_SALE_map_user_minted[target];
1396         arrRet[INFO_SALE_USER_MINTABLE] = _PUBLIC_SALE_mintable;
1397 
1398         return( arrRet );
1399     }
1400 
1401     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1402     // [external/onlyOwnerOrManager] write - PUBLIC
1403     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1404     // is_suspended
1405     function PUBLIC_SALE_suspend( bool flag ) external onlyOwnerOrManager {
1406         _PUBLIC_SALE_is_suspended = flag;
1407     }
1408 
1409     // start-end
1410     function PUBLIC_SALE_setStartEnd( uint256 start, uint256 end ) external onlyOwnerOrManager {
1411         _PUBLIC_SALE_start = start;
1412         _PUBLIC_SALE_end = end;
1413     }
1414 
1415     // price
1416     function PUBLIC_SALE_setPrice( uint256 price ) external onlyOwnerOrManager {
1417         _PUBLIC_SALE_price = price;
1418     }
1419 
1420     // mintable
1421     function PUBLIC_SALE_setMintable( uint256 mintable ) external onlyOwnerOrManager {
1422         _PUBLIC_SALE_mintable = mintable;
1423     }
1424 
1425     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1426     // [external/payable/nonReentrant] mint - PUBLIC
1427     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1428     function PUBLIC_SALE_mint( uint256 num ) external payable nonReentrant {
1429         uint256[INFO_MAX] memory arrInfo = PUBLIC_SALE_getInfo( msg.sender );
1430 
1431         require( arrInfo[INFO_SALE_SUSPENDED] == 0, "PUBLIC SALE: suspended" );
1432         require( arrInfo[INFO_SALE_START] == 0 || arrInfo[INFO_SALE_START] <= (block.timestamp+BLOCK_SEC_MARGIN), "PUBLIC SALE: not opend" );
1433         require( arrInfo[INFO_SALE_END] == 0 || (arrInfo[INFO_SALE_END]+BLOCK_SEC_MARGIN) > block.timestamp, "PUBLIC SALE: finished" );
1434         require( arrInfo[INFO_SALE_USER_MINTABLE] == 0 || arrInfo[INFO_SALE_USER_MINTABLE] >= (arrInfo[INFO_SALE_USER_MINTED]+num), "PUBLIC SALE: reached the limit" );
1435 
1436         _checkPayment( msg.sender, arrInfo[INFO_SALE_PRICE]*num, msg.value );
1437 
1438         _mintTokens( msg.sender, num );
1439         _PUBLIC_SALE_map_user_minted[msg.sender] += num;
1440     }
1441 
1442     //--------------------------------------------------------
1443     // [internal] _checkWhitelist
1444     //--------------------------------------------------------
1445     function _checkWhitelist( IWhitelist[] storage lists, address target ) internal view returns (bool) {
1446         for( uint256 i=0; i<lists.length; i++ ){
1447             if( lists[i].check(target) ){
1448                 return( true );
1449             }
1450         }
1451 
1452         return( false );        
1453     }
1454 
1455     //--------------------------------------------------------
1456     // [internal] _checkPayment
1457     //--------------------------------------------------------
1458     function _checkPayment( address msgSender, uint256 price, uint256 payment ) internal {
1459         require( price <= payment, "insufficient value" );
1460 
1461         // refund if overpaymented
1462         if( price < payment ){
1463             uint256 change = payment - price;
1464             address payable target = payable( msgSender );
1465             target.transfer( change );
1466         }
1467     }
1468 
1469     //--------------------------------------------------------
1470     // [internal] _mintTokens
1471     //--------------------------------------------------------
1472     function _mintTokens( address to, uint256 num ) internal {
1473         require( _total_supply >= _token_reserved, "reservation not finished" );
1474         require( (_total_supply+num) <= _token_max, "exceeded the supply range" );
1475         require( _token_mint_limit == 0 || _token_mint_limit >= num, "reached mint limitation" );
1476 
1477         for( uint256 i=0; i<num; i++ ){
1478             _mint( to, _total_supply+(TOKEN_ID_OFS+i) );
1479         }
1480         _total_supply += num;
1481     }
1482 
1483     //--------------------------------------------------------
1484     // [external/onlyOwnerOrManager] reserveTokens
1485     //--------------------------------------------------------
1486     function reserveTokens( uint256 num ) external onlyOwnerOrManager {
1487         require( (_total_supply+num) <= _token_reserved, "exceeded the reservation range" );
1488 
1489         for( uint256 i=0; i<num; i++ ){
1490             _mint( owner(), _total_supply+(TOKEN_ID_OFS+i) );
1491         }
1492         _total_supply += num;
1493     }
1494 
1495     //--------------------------------------------------------
1496     // [external] getUserInfo
1497     //--------------------------------------------------------
1498     function getUserInfo( address target ) external view returns (uint256[USER_INFO_MAX] memory) {
1499         uint256[USER_INFO_MAX] memory userInfo;
1500         uint256[INFO_MAX] memory info;
1501 
1502         // PRIVATE(whitelist)
1503         if( _checkWhitelist( _PRIVATE_SALE_arr_whitelist, target ) && (_PRIVATE_SALE_end == 0 || _PRIVATE_SALE_end > (block.timestamp+BLOCK_SEC_MARGIN/2)) ){
1504             userInfo[USER_INFO_SALE_TYPE] = 1;
1505             info = PRIVATE_SALE_getInfo( target );
1506         }
1507         // PUBLIC
1508         else{
1509             userInfo[USER_INFO_SALE_TYPE] = 2;
1510             info = PUBLIC_SALE_getInfo( target );
1511         }
1512 
1513         for( uint256 i=0; i<INFO_MAX; i++ ){
1514             userInfo[i] = info[i];
1515         }
1516 
1517         userInfo[USER_INFO_TOTAL_SUPPLY] = _total_supply;
1518         userInfo[USER_INFO_TOKEN_MAX] = _token_max;
1519         userInfo[USER_INFO_MINT_LIMIT] = _token_mint_limit;
1520 
1521         return( userInfo );
1522     }
1523 
1524     //--------------------------------------------------------
1525     // [external] for PurchasedChecker
1526     //--------------------------------------------------------
1527     function checkPurchased( address target ) external view override returns (uint256) { return( _PRIVATE_SALE_map_user_minted[target] + _PUBLIC_SALE_map_user_minted[target] ); }
1528     function checkPurchasedOnPrivate( address target ) external override view returns (uint256){ return( _PRIVATE_SALE_map_user_minted[target] ); }
1529     function checkPurchasedOnPublic( address target ) external override view returns (uint256){ return( _PUBLIC_SALE_map_user_minted[target] ); }
1530 
1531     //--------------------------------------------------------
1532     // [external] checkBalance
1533     //--------------------------------------------------------
1534     function checkBalance() external view returns (uint256) {
1535         return( address(this).balance );
1536     }
1537 
1538     //--------------------------------------------------------
1539     // [external/onlyOwnerOrManager] withdraw
1540     //--------------------------------------------------------
1541     function withdraw( uint256 amount ) external onlyOwnerOrManager {
1542         require( amount <= address(this).balance, "insufficient balance" );
1543 
1544         address payable target = payable( owner() );
1545         target.transfer( amount );
1546     }
1547 
1548 }