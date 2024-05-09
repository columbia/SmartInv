1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // File @openzeppelin/contracts/utils/Context.sol@v4.3.0
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
27 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.0
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43     address private _previousOwner;
44     uint256 private _lockTime;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     constructor() {
49         address msgSender = _msgSender();
50         _owner = msgSender;
51         _previousOwner = _owner;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     function owner() public view returns (address) {
56         return _owner;
57     }
58 
59     modifier onlyOwner() {
60         require(_owner == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     function renounceOwnership() public virtual onlyOwner {
65         _previousOwner = address(0);
66         emit OwnershipTransferred(_owner, address(0));
67         _owner = address(0);
68     }
69 
70     function transferOwnership(address newOwner) public virtual onlyOwner {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75     
76     function geUnlockTime() public view returns (uint256) {
77         return _lockTime;
78     }
79 
80     function lock(uint256 time) public virtual onlyOwner {
81         _previousOwner = _owner;
82         _owner = address(0);
83         _lockTime = block.timestamp + time;
84         emit OwnershipTransferred(_owner, address(0));
85     }
86 
87     function unlock() public virtual {
88         require(_previousOwner == msg.sender, "You don't have permission to unlock");
89         require(block.timestamp > _lockTime , "Contract is locked for a while");
90         emit OwnershipTransferred(_owner, _previousOwner);
91         _owner = _previousOwner;
92     }
93 }
94 
95 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.0
96 
97 /**
98  * @dev Interface of the ERC165 standard, as defined in the
99  * https://eips.ethereum.org/EIPS/eip-165[EIP].
100  *
101  * Implementers can declare support of contract interfaces, which can then be
102  * queried by others ({ERC165Checker}).
103  *
104  * For an implementation, see {ERC165}.
105  */
106 interface IERC165 {
107     /**
108      * @dev Returns true if this contract implements the interface defined by
109      * `interfaceId`. See the corresponding
110      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
111      * to learn more about how these ids are created.
112      *
113      * This function call must use less than 30 000 gas.
114      */
115     function supportsInterface(bytes4 interfaceId) external view returns (bool);
116 }
117 
118 
119 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.0
120 
121 /**
122  * @dev Required interface of an ERC721 compliant contract.
123  */
124 interface IERC721 is IERC165 {
125     /**
126      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
127      */
128     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
129 
130     /**
131      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
132      */
133     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
134 
135     /**
136      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
137      */
138     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
139 
140     /**
141      * @dev Returns the number of tokens in ``owner``'s account.
142      */
143     function balanceOf(address owner) external view returns (uint256 balance);
144 
145     /**
146      * @dev Returns the owner of the `tokenId` token.
147      *
148      * Requirements:
149      *
150      * - `tokenId` must exist.
151      */
152     function ownerOf(uint256 tokenId) external view returns (address owner);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
156      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be have been whiteed to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId
172     ) external;
173 
174     /**
175      * @dev Transfers `tokenId` token from `from` to `to`.
176      *
177      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
178      *
179      * Requirements:
180      *
181      * - `from` cannot be the zero address.
182      * - `to` cannot be the zero address.
183      * - `tokenId` token must be owned by `from`.
184      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
185      *
186      * Emits a {Transfer} event.
187      */
188     function transferFrom(
189         address from,
190         address to,
191         uint256 tokenId
192     ) external;
193 
194     /**
195      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
196      * The approval is cleared when the token is transferred.
197      *
198      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
199      *
200      * Requirements:
201      *
202      * - The caller must own the token or be an approved operator.
203      * - `tokenId` must exist.
204      *
205      * Emits an {Approval} event.
206      */
207     function approve(address to, uint256 tokenId) external;
208 
209     /**
210      * @dev Returns the account approved for `tokenId` token.
211      *
212      * Requirements:
213      *
214      * - `tokenId` must exist.
215      */
216     function getApproved(uint256 tokenId) external view returns (address operator);
217 
218     /**
219      * @dev Approve or remove `operator` as an operator for the caller.
220      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
221      *
222      * Requirements:
223      *
224      * - The `operator` cannot be the caller.
225      *
226      * Emits an {ApprovalForAll} event.
227      */
228     function setApprovalForAll(address operator, bool _approved) external;
229 
230     /**
231      * @dev Returns if the `operator` is whiteed to manage all of the assets of `owner`.
232      *
233      * See {setApprovalForAll}
234      */
235     function isApprovedForAll(address owner, address operator) external view returns (bool);
236 
237     /**
238      * @dev Safely transfers `tokenId` token from `from` to `to`.
239      *
240      * Requirements:
241      *
242      * - `from` cannot be the zero address.
243      * - `to` cannot be the zero address.
244      * - `tokenId` token must exist and be owned by `from`.
245      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
246      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
247      *
248      * Emits a {Transfer} event.
249      */
250     function safeTransferFrom(
251         address from,
252         address to,
253         uint256 tokenId,
254         bytes calldata data
255     ) external;
256 }
257 
258 
259 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.0
260 
261 /**
262  * @title ERC721 token receiver interface
263  * @dev Interface for any contract that wants to support safeTransfers
264  * from ERC721 asset contracts.
265  */
266 interface IERC721Receiver {
267     /**
268      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
269      * by `operator` from `from`, this function is called.
270      *
271      * It must return its Solidity selector to confirm the token transfer.
272      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
273      *
274      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
275      */
276     function onERC721Received(
277         address operator,
278         address from,
279         uint256 tokenId,
280         bytes calldata data
281     ) external returns (bytes4);
282 }
283 
284 
285 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.0
286 
287 /**
288  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
289  * @dev See https://eips.ethereum.org/EIPS/eip-721
290  */
291 interface IERC721Metadata is IERC721 {
292     /**
293      * @dev Returns the token collection name.
294      */
295     function name() external view returns (string memory);
296 
297     /**
298      * @dev Returns the token collection symbol.
299      */
300     function symbol() external view returns (string memory);
301 
302     /**
303      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
304      */
305     function tokenURI(uint256 tokenId) external view returns (string memory);
306 }
307 
308 
309 // File @openzeppelin/contracts/utils/Address.sol@v4.3.0
310 
311 /**
312  * @dev Collection of functions related to the address type
313  */
314 library Address {
315     /**
316      * @dev Returns true if `account` is a contract.
317      *
318      * [IMPORTANT]
319      * ====
320      * It is unsafe to assume that an address for which this function returns
321      * false is an externally-owned account (EOA) and not a contract.
322      *
323      * Among others, `isContract` will return false for the following
324      * types of addresses:
325      *
326      *  - an externally-owned account
327      *  - a contract in construction
328      *  - an address where a contract will be created
329      *  - an address where a contract lived, but was destroyed
330      * ====
331      */
332     function isContract(address account) internal view returns (bool) {
333         // This method relies on extcodesize, which returns 0 for contracts in
334         // construction, since the code is only stored at the end of the
335         // constructor execution.
336 
337         uint256 size;
338         assembly {
339             size := extcodesize(account)
340         }
341         return size > 0;
342     }
343 
344     /**
345      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
346      * `recipient`, forwarding all available gas and reverting on errors.
347      *
348      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
349      * of certain opcodes, possibly making contracts go over the 2300 gas limit
350      * imposed by `transfer`, making them unable to receive funds via
351      * `transfer`. {sendValue} removes this limitation.
352      *
353      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
354      *
355      * IMPORTANT: because control is transferred to `recipient`, care must be
356      * taken to not create reentrancy vulnerabilities. Consider using
357      * {ReentrancyGuard} or the
358      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
359      */
360     function sendValue(address payable recipient, uint256 amount) internal {
361         require(address(this).balance >= amount, "Address: insufficient balance");
362 
363         (bool success, ) = recipient.call{value: amount}("");
364         require(success, "Address: unable to send value, recipient may have reverted");
365     }
366 
367     /**
368      * @dev Performs a Solidity function call using a low level `call`. A
369      * plain `call` is an unsafe replacement for a function call: use this
370      * function instead.
371      *
372      * If `target` reverts with a revert reason, it is bubbled up by this
373      * function (like regular Solidity function calls).
374      *
375      * Returns the raw returned data. To convert to the expected return value,
376      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
377      *
378      * Requirements:
379      *
380      * - `target` must be a contract.
381      * - calling `target` with `data` must not revert.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
386         return functionCall(target, data, "Address: low-level call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
391      * `errorMessage` as a fallback revert reason when `target` reverts.
392      *
393      * _Available since v3.1._
394      */
395     function functionCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         return functionCallWithValue(target, data, 0, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but also transferring `value` wei to `target`.
406      *
407      * Requirements:
408      *
409      * - the calling contract must have an ETH balance of at least `value`.
410      * - the called Solidity function must be `payable`.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(
415         address target,
416         bytes memory data,
417         uint256 value
418     ) internal returns (bytes memory) {
419         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
424      * with `errorMessage` as a fallback revert reason when `target` reverts.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(
429         address target,
430         bytes memory data,
431         uint256 value,
432         string memory errorMessage
433     ) internal returns (bytes memory) {
434         require(address(this).balance >= value, "Address: insufficient balance for call");
435         require(isContract(target), "Address: call to non-contract");
436 
437         (bool success, bytes memory returndata) = target.call{value: value}(data);
438         return verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
443      * but performing a static call.
444      *
445      * _Available since v3.3._
446      */
447     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
448         return functionStaticCall(target, data, "Address: low-level static call failed");
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
453      * but performing a static call.
454      *
455      * _Available since v3.3._
456      */
457     function functionStaticCall(
458         address target,
459         bytes memory data,
460         string memory errorMessage
461     ) internal view returns (bytes memory) {
462         require(isContract(target), "Address: static call to non-contract");
463 
464         (bool success, bytes memory returndata) = target.staticcall(data);
465         return verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
470      * but performing a delegate call.
471      *
472      * _Available since v3.4._
473      */
474     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
475         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
480      * but performing a delegate call.
481      *
482      * _Available since v3.4._
483      */
484     function functionDelegateCall(
485         address target,
486         bytes memory data,
487         string memory errorMessage
488     ) internal returns (bytes memory) {
489         require(isContract(target), "Address: delegate call to non-contract");
490 
491         (bool success, bytes memory returndata) = target.delegatecall(data);
492         return verifyCallResult(success, returndata, errorMessage);
493     }
494 
495     /**
496      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
497      * revert reason using the provided one.
498      *
499      * _Available since v4.3._
500      */
501     function verifyCallResult(
502         bool success,
503         bytes memory returndata,
504         string memory errorMessage
505     ) internal pure returns (bytes memory) {
506         if (success) {
507             return returndata;
508         } else {
509             // Look for revert reason and bubble it up if present
510             if (returndata.length > 0) {
511                 // The easiest way to bubble the revert reason is using memory via assembly
512 
513                 assembly {
514                     let returndata_size := mload(returndata)
515                     revert(add(32, returndata), returndata_size)
516                 }
517             } else {
518                 revert(errorMessage);
519             }
520         }
521     }
522 }
523 
524 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.0
525 
526 /**
527  * @dev String operations.
528  */
529 library Strings {
530     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
531 
532     /**
533      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
534      */
535     function toString(uint256 value) internal pure returns (string memory) {
536         // Inspired by OraclizeAPI's implementation - MIT licence
537         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
538 
539         if (value == 0) {
540             return "0";
541         }
542         uint256 temp = value;
543         uint256 digits;
544         while (temp != 0) {
545             digits++;
546             temp /= 10;
547         }
548         bytes memory buffer = new bytes(digits);
549         while (value != 0) {
550             digits -= 1;
551             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
552             value /= 10;
553         }
554         return string(buffer);
555     }
556 
557     /**
558      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
559      */
560     function toHexString(uint256 value) internal pure returns (string memory) {
561         if (value == 0) {
562             return "0x00";
563         }
564         uint256 temp = value;
565         uint256 length = 0;
566         while (temp != 0) {
567             length++;
568             temp >>= 8;
569         }
570         return toHexString(value, length);
571     }
572 
573     /**
574      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
575      */
576     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
577         bytes memory buffer = new bytes(2 * length + 2);
578         buffer[0] = "0";
579         buffer[1] = "x";
580         for (uint256 i = 2 * length + 1; i > 1; --i) {
581             buffer[i] = _HEX_SYMBOLS[value & 0xf];
582             value >>= 4;
583         }
584         require(value == 0, "Strings: hex length insufficient");
585         return string(buffer);
586     }
587 }
588 
589 
590 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.0
591 
592 /**
593  * @dev Implementation of the {IERC165} interface.
594  *
595  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
596  * for the additional interface id that will be supported. For example:
597  *
598  * ```solidity
599  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
600  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
601  * }
602  * ```
603  *
604  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
605  */
606 abstract contract ERC165 is IERC165 {
607     /**
608      * @dev See {IERC165-supportsInterface}.
609      */
610     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
611         return interfaceId == type(IERC165).interfaceId;
612     }
613 }
614 
615 
616 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.0
617 
618 /**
619  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
620  * the Metadata extension, but not including the Enumerable extension, which is available separately as
621  * {ERC721Enumerable}.
622  */
623 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
624     using Address for address;
625     using Strings for uint256;
626 
627     // Token name
628     string private _name;
629 
630     // Token symbol
631     string private _symbol;
632 
633     // Mapping from token ID to owner address
634     mapping(uint256 => address) private _owners;
635 
636     // Mapping owner address to token count
637     mapping(address => uint256) private _balances;
638 
639     // Mapping from token ID to approved address
640     mapping(uint256 => address) private _tokenApprovals;
641 
642     // Mapping from owner to operator approvals
643     mapping(address => mapping(address => bool)) private _operatorApprovals;
644 
645     /**
646      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
647      */
648     constructor(string memory name_, string memory symbol_) {
649         _name = name_;
650         _symbol = symbol_;
651     }
652 
653     /**
654      * @dev See {IERC165-supportsInterface}.
655      */
656     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
657         return
658             interfaceId == type(IERC721).interfaceId ||
659             interfaceId == type(IERC721Metadata).interfaceId ||
660             super.supportsInterface(interfaceId);
661     }
662 
663     /**
664      * @dev See {IERC721-balanceOf}.
665      */
666     function balanceOf(address owner) public view virtual override returns (uint256) {
667         require(owner != address(0), "ERC721: balance query for the zero address");
668         return _balances[owner];
669     }
670 
671     /**
672      * @dev See {IERC721-ownerOf}.
673      */
674     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
675         address owner = _owners[tokenId];
676         require(owner != address(0), "ERC721: owner query for nonexistent token");
677         return owner;
678     }
679 
680     /**
681      * @dev See {IERC721Metadata-name}.
682      */
683     function name() public view virtual override returns (string memory) {
684         return _name;
685     }
686 
687     /**
688      * @dev See {IERC721Metadata-symbol}.
689      */
690     function symbol() public view virtual override returns (string memory) {
691         return _symbol;
692     }
693 
694     /**
695      * @dev See {IERC721Metadata-tokenURI}.
696      */
697     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
698         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
699 
700         string memory baseURI = _baseURI();
701         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
702     }
703 
704     /**
705      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
706      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
707      * by default, can be overriden in child contracts.
708      */
709     function _baseURI() internal view virtual returns (string memory) {
710         return "";
711     }
712 
713     /**
714      * @dev See {IERC721-approve}.
715      */
716     function approve(address to, uint256 tokenId) public virtual override {
717         address owner = ERC721.ownerOf(tokenId);
718         require(to != owner, "ERC721: approval to current owner");
719 
720         require(
721             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
722             "ERC721: approve caller is not owner nor approved for all"
723         );
724 
725         _approve(to, tokenId);
726     }
727 
728     /**
729      * @dev See {IERC721-getApproved}.
730      */
731     function getApproved(uint256 tokenId) public view virtual override returns (address) {
732         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
733 
734         return _tokenApprovals[tokenId];
735     }
736 
737     /**
738      * @dev See {IERC721-setApprovalForAll}.
739      */
740     function setApprovalForAll(address operator, bool approved) public virtual override {
741         require(operator != _msgSender(), "ERC721: approve to caller");
742 
743         _operatorApprovals[_msgSender()][operator] = approved;
744         emit ApprovalForAll(_msgSender(), operator, approved);
745     }
746 
747     /**
748      * @dev See {IERC721-isApprovedForAll}.
749      */
750     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
751         return _operatorApprovals[owner][operator];
752     }
753 
754     /**
755      * @dev See {IERC721-transferFrom}.
756      */
757     function transferFrom(
758         address from,
759         address to,
760         uint256 tokenId
761     ) public virtual override {
762         //solhint-disable-next-line max-line-length
763         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
764 
765         _transfer(from, to, tokenId);
766     }
767 
768     /**
769      * @dev See {IERC721-safeTransferFrom}.
770      */
771     function safeTransferFrom(
772         address from,
773         address to,
774         uint256 tokenId
775     ) public virtual override {
776         safeTransferFrom(from, to, tokenId, "");
777     }
778 
779     /**
780      * @dev See {IERC721-safeTransferFrom}.
781      */
782     function safeTransferFrom(
783         address from,
784         address to,
785         uint256 tokenId,
786         bytes memory _data
787     ) public virtual override {
788         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
789         _safeTransfer(from, to, tokenId, _data);
790     }
791 
792     /**
793      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
794      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
795      *
796      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
797      *
798      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
799      * implement alternative mechanisms to perform token transfer, such as signature-based.
800      *
801      * Requirements:
802      *
803      * - `from` cannot be the zero address.
804      * - `to` cannot be the zero address.
805      * - `tokenId` token must exist and be owned by `from`.
806      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
807      *
808      * Emits a {Transfer} event.
809      */
810     function _safeTransfer(
811         address from,
812         address to,
813         uint256 tokenId,
814         bytes memory _data
815     ) internal virtual {
816         _transfer(from, to, tokenId);
817         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
818     }
819 
820     /**
821      * @dev Returns whether `tokenId` exists.
822      *
823      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
824      *
825      * Tokens start existing when they are minted (`_mint`),
826      * and stop existing when they are burned (`_burn`).
827      */
828     function _exists(uint256 tokenId) internal view virtual returns (bool) {
829         return _owners[tokenId] != address(0);
830     }
831 
832     /**
833      * @dev Returns whether `spender` is whiteed to manage `tokenId`.
834      *
835      * Requirements:
836      *
837      * - `tokenId` must exist.
838      */
839     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
840         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
841         address owner = ERC721.ownerOf(tokenId);
842         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
843     }
844 
845     /**
846      * @dev Safely mints `tokenId` and transfers it to `to`.
847      *
848      * Requirements:
849      *
850      * - `tokenId` must not exist.
851      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
852      *
853      * Emits a {Transfer} event.
854      */
855     function _safeMint(address to, uint256 tokenId) internal virtual {
856         _safeMint(to, tokenId, "");
857     }
858 
859     /**
860      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
861      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
862      */
863     function _safeMint(
864         address to,
865         uint256 tokenId,
866         bytes memory _data
867     ) internal virtual {
868         _mint(to, tokenId);
869         require(
870             _checkOnERC721Received(address(0), to, tokenId, _data),
871             "ERC721: transfer to non ERC721Receiver implementer"
872         );
873     }
874 
875     /**
876      * @dev Mints `tokenId` and transfers it to `to`.
877      *
878      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
879      *
880      * Requirements:
881      *
882      * - `tokenId` must not exist.
883      * - `to` cannot be the zero address.
884      *
885      * Emits a {Transfer} event.
886      */
887     function _mint(address to, uint256 tokenId) internal virtual {
888         require(to != address(0), "ERC721: mint to the zero address");
889         require(!_exists(tokenId), "ERC721: token already minted");
890 
891         _beforeTokenTransfer(address(0), to, tokenId);
892 
893         _balances[to] += 1;
894         _owners[tokenId] = to;
895 
896         emit Transfer(address(0), to, tokenId);
897     }
898 
899     /**
900      * @dev Destroys `tokenId`.
901      * The approval is cleared when the token is burned.
902      *
903      * Requirements:
904      *
905      * - `tokenId` must exist.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _burn(uint256 tokenId) internal virtual {
910         address owner = ERC721.ownerOf(tokenId);
911 
912         _beforeTokenTransfer(owner, address(0), tokenId);
913 
914         // Clear approvals
915         _approve(address(0), tokenId);
916 
917         _balances[owner] -= 1;
918         delete _owners[tokenId];
919 
920         emit Transfer(owner, address(0), tokenId);
921     }
922 
923     /**
924      * @dev Transfers `tokenId` from `from` to `to`.
925      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
926      *
927      * Requirements:
928      *
929      * - `to` cannot be the zero address.
930      * - `tokenId` token must be owned by `from`.
931      *
932      * Emits a {Transfer} event.
933      */
934     function _transfer(
935         address from,
936         address to,
937         uint256 tokenId
938     ) internal virtual {
939         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
940         require(to != address(0), "ERC721: transfer to the zero address");
941 
942         _beforeTokenTransfer(from, to, tokenId);
943 
944         // Clear approvals from the previous owner
945         _approve(address(0), tokenId);
946 
947         _balances[from] -= 1;
948         _balances[to] += 1;
949         _owners[tokenId] = to;
950 
951         emit Transfer(from, to, tokenId);
952     }
953 
954     /**
955      * @dev Approve `to` to operate on `tokenId`
956      *
957      * Emits a {Approval} event.
958      */
959     function _approve(address to, uint256 tokenId) internal virtual {
960         _tokenApprovals[tokenId] = to;
961         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
962     }
963 
964     /**
965      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
966      * The call is not executed if the target address is not a contract.
967      *
968      * @param from address representing the previous owner of the given token ID
969      * @param to target address that will receive the tokens
970      * @param tokenId uint256 ID of the token to be transferred
971      * @param _data bytes optional data to send along with the call
972      * @return bool whether the call correctly returned the expected magic value
973      */
974     function _checkOnERC721Received(
975         address from,
976         address to,
977         uint256 tokenId,
978         bytes memory _data
979     ) private returns (bool) {
980         if (to.isContract()) {
981             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
982                 return retval == IERC721Receiver.onERC721Received.selector;
983             } catch (bytes memory reason) {
984                 if (reason.length == 0) {
985                     revert("ERC721: transfer to non ERC721Receiver implementer");
986                 } else {
987                     assembly {
988                         revert(add(32, reason), mload(reason))
989                     }
990                 }
991             }
992         } else {
993             return true;
994         }
995     }
996 
997     /**
998      * @dev Hook that is called before any token transfer. This includes minting
999      * and burning.
1000      *
1001      * Calling conditions:
1002      *
1003      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1004      * transferred to `to`.
1005      * - When `from` is zero, `tokenId` will be minted for `to`.
1006      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1007      * - `from` and `to` are never both zero.
1008      *
1009      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1010      */
1011     function _beforeTokenTransfer(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) internal virtual {}
1016 }
1017 
1018 
1019 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.0
1020 
1021 /**
1022  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1023  * @dev See https://eips.ethereum.org/EIPS/eip-721
1024  */
1025 interface IERC721Enumerable is IERC721 {
1026     /**
1027      * @dev Returns the total amount of tokens stored by the contract.
1028      */
1029     function totalSupply() external view returns (uint256);
1030 
1031     /**
1032      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1033      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1034      */
1035     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1036 
1037     /**
1038      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1039      * Use along with {totalSupply} to enumerate all tokens.
1040      */
1041     function tokenByIndex(uint256 index) external view returns (uint256);
1042 }
1043 
1044 
1045 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.0
1046 
1047 
1048 /**
1049  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1050  * enumerability of all the token ids in the contract as well as all token ids owned by each
1051  * account.
1052  */
1053 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1054     // Mapping from owner to list of owned token IDs
1055     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1056 
1057     // Mapping from token ID to index of the owner tokens list
1058     mapping(uint256 => uint256) private _ownedTokensIndex;
1059 
1060     // Array with all token ids, used for enumeration
1061     uint256[] private _allTokens;
1062 
1063     // Mapping from token id to position in the allTokens array
1064     mapping(uint256 => uint256) private _allTokensIndex;
1065 
1066     /**
1067      * @dev See {IERC165-supportsInterface}.
1068      */
1069     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1070         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1071     }
1072 
1073     /**
1074      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1075      */
1076     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1077         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1078         return _ownedTokens[owner][index];
1079     }
1080 
1081     /**
1082      * @dev See {IERC721Enumerable-totalSupply}.
1083      */
1084     function totalSupply() public view virtual override returns (uint256) {
1085         return _allTokens.length;
1086     }
1087 
1088     /**
1089      * @dev See {IERC721Enumerable-tokenByIndex}.
1090      */
1091     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1092         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1093         return _allTokens[index];
1094     }
1095 
1096     /**
1097      * @dev Hook that is called before any token transfer. This includes minting
1098      * and burning.
1099      *
1100      * Calling conditions:
1101      *
1102      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1103      * transferred to `to`.
1104      * - When `from` is zero, `tokenId` will be minted for `to`.
1105      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1106      * - `from` cannot be the zero address.
1107      * - `to` cannot be the zero address.
1108      *
1109      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1110      */
1111     function _beforeTokenTransfer(
1112         address from,
1113         address to,
1114         uint256 tokenId
1115     ) internal virtual override {
1116         super._beforeTokenTransfer(from, to, tokenId);
1117 
1118         if (from == address(0)) {
1119             _addTokenToAllTokensEnumeration(tokenId);
1120         } else if (from != to) {
1121             _removeTokenFromOwnerEnumeration(from, tokenId);
1122         }
1123         if (to == address(0)) {
1124             _removeTokenFromAllTokensEnumeration(tokenId);
1125         } else if (to != from) {
1126             _addTokenToOwnerEnumeration(to, tokenId);
1127         }
1128     }
1129 
1130     /**
1131      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1132      * @param to address representing the new owner of the given token ID
1133      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1134      */
1135     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1136         uint256 length = ERC721.balanceOf(to);
1137         _ownedTokens[to][length] = tokenId;
1138         _ownedTokensIndex[tokenId] = length;
1139     }
1140 
1141     /**
1142      * @dev Private function to add a token to this extension's token tracking data structures.
1143      * @param tokenId uint256 ID of the token to be added to the tokens list
1144      */
1145     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1146         _allTokensIndex[tokenId] = _allTokens.length;
1147         _allTokens.push(tokenId);
1148     }
1149 
1150     /**
1151      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1152      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this whites for
1153      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1154      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1155      * @param from address representing the previous owner of the given token ID
1156      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1157      */
1158     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1159         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1160         // then delete the last slot (swap and pop).
1161 
1162         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1163         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1164 
1165         // When the token to delete is the last token, the swap operation is unnecessary
1166         if (tokenIndex != lastTokenIndex) {
1167             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1168 
1169             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1170             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1171         }
1172 
1173         // This also deletes the contents at the last position of the array
1174         delete _ownedTokensIndex[tokenId];
1175         delete _ownedTokens[from][lastTokenIndex];
1176     }
1177 
1178     /**
1179      * @dev Private function to remove a token from this extension's token tracking data structures.
1180      * This has O(1) time complexity, but alters the order of the _allTokens array.
1181      * @param tokenId uint256 ID of the token to be removed from the tokens list
1182      */
1183     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1184         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1185         // then delete the last slot (swap and pop).
1186 
1187         uint256 lastTokenIndex = _allTokens.length - 1;
1188         uint256 tokenIndex = _allTokensIndex[tokenId];
1189 
1190         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1191         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1192         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1193         uint256 lastTokenId = _allTokens[lastTokenIndex];
1194 
1195         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1196         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1197 
1198         // This also deletes the contents at the last position of the array
1199         delete _allTokensIndex[tokenId];
1200         _allTokens.pop();
1201     }
1202 }
1203 
1204 
1205 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.0
1206 
1207 
1208 // CAUTION
1209 // This version of SafeMath should only be used with Solidity 0.8 or later,
1210 // because it relies on the compiler's built in overflow checks.
1211 
1212 /**
1213  * @dev Wrappers over Solidity's arithmetic operations.
1214  *
1215  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1216  * now has built in overflow checking.
1217  */
1218 library SafeMath {
1219     /**
1220      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1221      *
1222      * _Available since v3.4._
1223      */
1224     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1225         unchecked {
1226             uint256 c = a + b;
1227             if (c < a) return (false, 0);
1228             return (true, c);
1229         }
1230     }
1231 
1232     /**
1233      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1234      *
1235      * _Available since v3.4._
1236      */
1237     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1238         unchecked {
1239             if (b > a) return (false, 0);
1240             return (true, a - b);
1241         }
1242     }
1243 
1244     /**
1245      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1246      *
1247      * _Available since v3.4._
1248      */
1249     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1250         unchecked {
1251             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1252             // benefit is lost if 'b' is also tested.
1253             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1254             if (a == 0) return (true, 0);
1255             uint256 c = a * b;
1256             if (c / a != b) return (false, 0);
1257             return (true, c);
1258         }
1259     }
1260 
1261     /**
1262      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1263      *
1264      * _Available since v3.4._
1265      */
1266     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1267         unchecked {
1268             if (b == 0) return (false, 0);
1269             return (true, a / b);
1270         }
1271     }
1272 
1273     /**
1274      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1275      *
1276      * _Available since v3.4._
1277      */
1278     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1279         unchecked {
1280             if (b == 0) return (false, 0);
1281             return (true, a % b);
1282         }
1283     }
1284 
1285     /**
1286      * @dev Returns the addition of two unsigned integers, reverting on
1287      * overflow.
1288      *
1289      * Counterpart to Solidity's `+` operator.
1290      *
1291      * Requirements:
1292      *
1293      * - Addition cannot overflow.
1294      */
1295     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1296         return a + b;
1297     }
1298 
1299     /**
1300      * @dev Returns the subtraction of two unsigned integers, reverting on
1301      * overflow (when the result is negative).
1302      *
1303      * Counterpart to Solidity's `-` operator.
1304      *
1305      * Requirements:
1306      *
1307      * - Subtraction cannot overflow.
1308      */
1309     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1310         return a - b;
1311     }
1312 
1313     /**
1314      * @dev Returns the multiplication of two unsigned integers, reverting on
1315      * overflow.
1316      *
1317      * Counterpart to Solidity's `*` operator.
1318      *
1319      * Requirements:
1320      *
1321      * - Multiplication cannot overflow.
1322      */
1323     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1324         return a * b;
1325     }
1326 
1327     /**
1328      * @dev Returns the integer division of two unsigned integers, reverting on
1329      * division by zero. The result is rounded towards zero.
1330      *
1331      * Counterpart to Solidity's `/` operator.
1332      *
1333      * Requirements:
1334      *
1335      * - The divisor cannot be zero.
1336      */
1337     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1338         return a / b;
1339     }
1340 
1341     /**
1342      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1343      * reverting when dividing by zero.
1344      *
1345      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1346      * opcode (which leaves remaining gas untouched) while Solidity uses an
1347      * invalid opcode to revert (consuming all remaining gas).
1348      *
1349      * Requirements:
1350      *
1351      * - The divisor cannot be zero.
1352      */
1353     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1354         return a % b;
1355     }
1356 
1357     /**
1358      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1359      * overflow (when the result is negative).
1360      *
1361      * CAUTION: This function is deprecated because it requires allocating memory for the error
1362      * message unnecessarily. For custom revert reasons use {trySub}.
1363      *
1364      * Counterpart to Solidity's `-` operator.
1365      *
1366      * Requirements:
1367      *
1368      * - Subtraction cannot overflow.
1369      */
1370     function sub(
1371         uint256 a,
1372         uint256 b,
1373         string memory errorMessage
1374     ) internal pure returns (uint256) {
1375         unchecked {
1376             require(b <= a, errorMessage);
1377             return a - b;
1378         }
1379     }
1380 
1381     /**
1382      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1383      * division by zero. The result is rounded towards zero.
1384      *
1385      * Counterpart to Solidity's `/` operator. Note: this function uses a
1386      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1387      * uses an invalid opcode to revert (consuming all remaining gas).
1388      *
1389      * Requirements:
1390      *
1391      * - The divisor cannot be zero.
1392      */
1393     function div(
1394         uint256 a,
1395         uint256 b,
1396         string memory errorMessage
1397     ) internal pure returns (uint256) {
1398         unchecked {
1399             require(b > 0, errorMessage);
1400             return a / b;
1401         }
1402     }
1403 
1404     /**
1405      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1406      * reverting with custom message when dividing by zero.
1407      *
1408      * CAUTION: This function is deprecated because it requires allocating memory for the error
1409      * message unnecessarily. For custom revert reasons use {tryMod}.
1410      *
1411      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1412      * opcode (which leaves remaining gas untouched) while Solidity uses an
1413      * invalid opcode to revert (consuming all remaining gas).
1414      *
1415      * Requirements:
1416      *
1417      * - The divisor cannot be zero.
1418      */
1419     function mod(
1420         uint256 a,
1421         uint256 b,
1422         string memory errorMessage
1423     ) internal pure returns (uint256) {
1424         unchecked {
1425             require(b > 0, errorMessage);
1426             return a % b;
1427         }
1428     }
1429 }
1430 
1431 
1432 
1433 
1434 /**
1435  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1436  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1437  *
1438  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1439  *
1440  * Does not support burning tokens to address(0).
1441  */
1442 contract ERC721A is
1443   Context,
1444   ERC165,
1445   IERC721,
1446   IERC721Metadata,
1447   IERC721Enumerable
1448 {
1449   using Address for address;
1450   using Strings for uint256;
1451 
1452   struct TokenOwnership {
1453     address addr;
1454     uint64 startTimestamp;
1455   }
1456 
1457   struct AddressData {
1458     uint128 balance;
1459     uint128 numberMinted;
1460   }
1461 
1462   uint256 private currentIndex = 0;
1463 
1464   uint256 internal immutable maxBatchSize;
1465 
1466   // Token name
1467   string private _name;
1468 
1469   // Token symbol
1470   string private _symbol;
1471 
1472   // Mapping from token ID to ownership details
1473   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1474   mapping(uint256 => TokenOwnership) private _ownerships;
1475 
1476   // Mapping owner address to address data
1477   mapping(address => AddressData) private _addressData;
1478 
1479   // Mapping from token ID to approved address
1480   mapping(uint256 => address) private _tokenApprovals;
1481 
1482   // Mapping from owner to operator approvals
1483   mapping(address => mapping(address => bool)) private _operatorApprovals;
1484 
1485   /**
1486    * @dev
1487    * `maxBatchSize` refers to how much a minter can mint at a time.
1488    */
1489   constructor(
1490     string memory name_,
1491     string memory symbol_,
1492     uint256 maxBatchSize_
1493   ) {
1494     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1495     _name = name_;
1496     _symbol = symbol_;
1497     maxBatchSize = maxBatchSize_;
1498   }
1499 
1500   /**
1501    * @dev See {IERC721Enumerable-totalSupply}.
1502    */
1503   function totalSupply() public view override returns (uint256) {
1504     return currentIndex;
1505   }
1506 
1507   /**
1508    * @dev See {IERC721Enumerable-tokenByIndex}.
1509    */
1510   function tokenByIndex(uint256 index) public view override returns (uint256) {
1511     require(index < totalSupply(), "ERC721A: global index out of bounds");
1512     return index;
1513   }
1514 
1515   /**
1516    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1517    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1518    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1519    */
1520   function tokenOfOwnerByIndex(address owner, uint256 index)
1521     public
1522     view
1523     override
1524     returns (uint256)
1525   {
1526     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1527     uint256 numMintedSoFar = totalSupply();
1528     uint256 tokenIdsIdx = 0;
1529     address currOwnershipAddr = address(0);
1530     for (uint256 i = 0; i < numMintedSoFar; i++) {
1531       TokenOwnership memory ownership = _ownerships[i];
1532       if (ownership.addr != address(0)) {
1533         currOwnershipAddr = ownership.addr;
1534       }
1535       if (currOwnershipAddr == owner) {
1536         if (tokenIdsIdx == index) {
1537           return i;
1538         }
1539         tokenIdsIdx++;
1540       }
1541     }
1542     revert("ERC721A: unable to get token of owner by index");
1543   }
1544 
1545   function walletOfOwner(address owner) public view returns(uint256[] memory) {
1546     uint256 tokenCount = balanceOf(owner);
1547 
1548     uint256[] memory tokenIds = new uint256[](tokenCount);
1549     if (tokenCount == 0)
1550     {
1551       return tokenIds;
1552     }
1553 
1554     uint256 numMintedSoFar = totalSupply();
1555     uint256 tokenIdsIdx = 0;
1556     address currOwnershipAddr = address(0);
1557     for (uint256 i = 0; i < numMintedSoFar; i++) {
1558       TokenOwnership memory ownership = _ownerships[i];
1559       if (ownership.addr != address(0)) {
1560         currOwnershipAddr = ownership.addr;
1561       }
1562       if (currOwnershipAddr == owner) {
1563         tokenIds[tokenIdsIdx] = i;
1564         tokenIdsIdx++;
1565         if (tokenIdsIdx == tokenCount) {
1566           return tokenIds;
1567         }
1568       }
1569     }
1570     revert("ERC721A: unable to get walletOfOwner");
1571   }
1572 
1573   /**
1574    * @dev See {IERC165-supportsInterface}.
1575    */
1576   function supportsInterface(bytes4 interfaceId)
1577     public
1578     view
1579     virtual
1580     override(ERC165, IERC165)
1581     returns (bool)
1582   {
1583     return
1584       interfaceId == type(IERC721).interfaceId ||
1585       interfaceId == type(IERC721Metadata).interfaceId ||
1586       interfaceId == type(IERC721Enumerable).interfaceId ||
1587       super.supportsInterface(interfaceId);
1588   }
1589 
1590   /**
1591    * @dev See {IERC721-balanceOf}.
1592    */
1593   function balanceOf(address owner) public view override returns (uint256) {
1594     require(owner != address(0), "ERC721A: balance query for the zero address");
1595     return uint256(_addressData[owner].balance);
1596   }
1597 
1598   function _numberMinted(address owner) internal view returns (uint256) {
1599     require(
1600       owner != address(0),
1601       "ERC721A: number minted query for the zero address"
1602     );
1603     return uint256(_addressData[owner].numberMinted);
1604   }
1605 
1606   function ownershipOf(uint256 tokenId)
1607     internal
1608     view
1609     returns (TokenOwnership memory)
1610   {
1611     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1612 
1613     uint256 lowestTokenToCheck;
1614     if (tokenId >= maxBatchSize) {
1615       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1616     }
1617 
1618     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1619       TokenOwnership memory ownership = _ownerships[curr];
1620       if (ownership.addr != address(0)) {
1621         return ownership;
1622       }
1623     }
1624 
1625     revert("ERC721A: unable to determine the owner of token");
1626   }
1627 
1628   /**
1629    * @dev See {IERC721-ownerOf}.
1630    */
1631   function ownerOf(uint256 tokenId) public view override returns (address) {
1632     return ownershipOf(tokenId).addr;
1633   }
1634 
1635   /**
1636    * @dev See {IERC721Metadata-name}.
1637    */
1638   function name() public view virtual override returns (string memory) {
1639     return _name;
1640   }
1641 
1642   /**
1643    * @dev See {IERC721Metadata-symbol}.
1644    */
1645   function symbol() public view virtual override returns (string memory) {
1646     return _symbol;
1647   }
1648 
1649   /**
1650    * @dev See {IERC721Metadata-tokenURI}.
1651    */
1652   function tokenURI(uint256 tokenId)
1653     public
1654     view
1655     virtual
1656     override
1657     returns (string memory)
1658   {
1659       tokenId = tokenId;
1660     require(
1661       _exists(tokenId),
1662       "ERC721Metadata: URI query for nonexistent token"
1663     );
1664 
1665     string memory baseURI = _baseURI();
1666     return
1667       bytes(baseURI).length > 0
1668         ? string(abi.encodePacked(baseURI, (tokenId + 556).toString()))
1669         : "";
1670   }
1671 
1672   /**
1673    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1674    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1675    * by default, can be overriden in child contracts.
1676    */
1677   function _baseURI() internal view virtual returns (string memory) {
1678     return "";
1679   }
1680 
1681   /**
1682    * @dev See {IERC721-approve}.
1683    */
1684   function approve(address to, uint256 tokenId) public override {
1685     address owner = ERC721A.ownerOf(tokenId);
1686     require(to != owner, "ERC721A: approval to current owner");
1687 
1688     require(
1689       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1690       "ERC721A: approve caller is not owner nor approved for all"
1691     );
1692 
1693     _approve(to, tokenId, owner);
1694   }
1695 
1696   /**
1697    * @dev See {IERC721-getApproved}.
1698    */
1699   function getApproved(uint256 tokenId) public view override returns (address) {
1700     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1701 
1702     return _tokenApprovals[tokenId];
1703   }
1704 
1705   /**
1706    * @dev See {IERC721-setApprovalForAll}.
1707    */
1708   function setApprovalForAll(address operator, bool approved) public override {
1709     require(operator != _msgSender(), "ERC721A: approve to caller");
1710 
1711     _operatorApprovals[_msgSender()][operator] = approved;
1712     emit ApprovalForAll(_msgSender(), operator, approved);
1713   }
1714 
1715   /**
1716    * @dev See {IERC721-isApprovedForAll}.
1717    */
1718   function isApprovedForAll(address owner, address operator)
1719     public
1720     view
1721     virtual
1722     override
1723     returns (bool)
1724   {
1725     return _operatorApprovals[owner][operator];
1726   }
1727 
1728   /**
1729    * @dev See {IERC721-transferFrom}.
1730    */
1731   function transferFrom(
1732     address from,
1733     address to,
1734     uint256 tokenId
1735   ) public virtual override {
1736     _transfer(from, to, tokenId);
1737   }
1738 
1739   /**
1740    * @dev See {IERC721-safeTransferFrom}.
1741    */
1742   function safeTransferFrom(
1743     address from,
1744     address to,
1745     uint256 tokenId
1746   ) public virtual override {
1747     safeTransferFrom(from, to, tokenId, "");
1748   }
1749 
1750   /**
1751    * @dev See {IERC721-safeTransferFrom}.
1752    */
1753   function safeTransferFrom(
1754     address from,
1755     address to,
1756     uint256 tokenId,
1757     bytes memory _data
1758   ) public virtual override {
1759     _transfer(from, to, tokenId);
1760     require(
1761       _checkOnERC721Received(from, to, tokenId, _data),
1762       "ERC721A: transfer to non ERC721Receiver implementer"
1763     );
1764   }
1765 
1766   /**
1767    * @dev Returns whether `tokenId` exists.
1768    *
1769    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1770    *
1771    * Tokens start existing when they are minted (`_mint`),
1772    */
1773   function _exists(uint256 tokenId) internal view returns (bool) {
1774     return tokenId < currentIndex;
1775   }
1776 
1777   function _safeMint(address to, uint256 quantity) internal {
1778     _safeMint(to, quantity, "");
1779   }
1780 
1781   /**
1782    * @dev Mints `quantity` tokens and transfers them to `to`.
1783    *
1784    * Requirements:
1785    *
1786    * - `to` cannot be the zero address.
1787    * - `quantity` cannot be larger than the max batch size.
1788    *
1789    * Emits a {Transfer} event.
1790    */
1791   function _safeMint(
1792     address to,
1793     uint256 quantity,
1794     bytes memory _data
1795   ) internal {
1796     uint256 startTokenId = currentIndex;
1797     require(to != address(0), "ERC721A: mint to the zero address");
1798     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1799     require(!_exists(startTokenId), "ERC721A: token already minted");
1800     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1801 
1802     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1803 
1804     AddressData memory addressData = _addressData[to];
1805     _addressData[to] = AddressData(
1806       addressData.balance + uint128(quantity),
1807       addressData.numberMinted + uint128(quantity)
1808     );
1809     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1810 
1811     uint256 updatedIndex = startTokenId;
1812 
1813     for (uint256 i = 0; i < quantity; i++) {
1814       emit Transfer(address(0), to, updatedIndex);
1815       require(
1816         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1817         "ERC721A: transfer to non ERC721Receiver implementer"
1818       );
1819       updatedIndex++;
1820     }
1821 
1822     currentIndex = updatedIndex;
1823     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1824   }
1825 
1826   /**
1827    * @dev Transfers `tokenId` from `from` to `to`.
1828    *
1829    * Requirements:
1830    *
1831    * - `to` cannot be the zero address.
1832    * - `tokenId` token must be owned by `from`.
1833    *
1834    * Emits a {Transfer} event.
1835    */
1836   function _transfer(
1837     address from,
1838     address to,
1839     uint256 tokenId
1840   ) private {
1841     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1842 
1843     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1844       getApproved(tokenId) == _msgSender() ||
1845       isApprovedForAll(prevOwnership.addr, _msgSender()));
1846 
1847     require(
1848       isApprovedOrOwner,
1849       "ERC721A: transfer caller is not owner nor approved"
1850     );
1851 
1852     require(
1853       prevOwnership.addr == from,
1854       "ERC721A: transfer from incorrect owner"
1855     );
1856     require(to != address(0), "ERC721A: transfer to the zero address");
1857 
1858     _beforeTokenTransfers(from, to, tokenId, 1);
1859 
1860     // Clear approvals from the previous owner
1861     _approve(address(0), tokenId, prevOwnership.addr);
1862 
1863     _addressData[from].balance -= 1;
1864     _addressData[to].balance += 1;
1865     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1866 
1867     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1868     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1869     uint256 nextTokenId = tokenId + 1;
1870     if (_ownerships[nextTokenId].addr == address(0)) {
1871       if (_exists(nextTokenId)) {
1872         _ownerships[nextTokenId] = TokenOwnership(
1873           prevOwnership.addr,
1874           prevOwnership.startTimestamp
1875         );
1876       }
1877     }
1878 
1879     emit Transfer(from, to, tokenId);
1880     _afterTokenTransfers(from, to, tokenId, 1);
1881   }
1882 
1883   /**
1884    * @dev Approve `to` to operate on `tokenId`
1885    *
1886    * Emits a {Approval} event.
1887    */
1888   function _approve(
1889     address to,
1890     uint256 tokenId,
1891     address owner
1892   ) private {
1893     _tokenApprovals[tokenId] = to;
1894     emit Approval(owner, to, tokenId);
1895   }
1896 
1897   uint256 public nextOwnerToExplicitlySet = 0;
1898 
1899   /**
1900    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1901    */
1902   function _setOwnersExplicit(uint256 quantity) internal {
1903     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1904     require(quantity > 0, "quantity must be nonzero");
1905     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1906     if (endIndex > currentIndex - 1) {
1907       endIndex = currentIndex - 1;
1908     }
1909     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1910     require(_exists(endIndex), "not enough minted yet for this cleanup");
1911     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1912       if (_ownerships[i].addr == address(0)) {
1913         TokenOwnership memory ownership = ownershipOf(i);
1914         _ownerships[i] = TokenOwnership(
1915           ownership.addr,
1916           ownership.startTimestamp
1917         );
1918       }
1919     }
1920     nextOwnerToExplicitlySet = endIndex + 1;
1921   }
1922 
1923   /**
1924    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1925    * The call is not executed if the target address is not a contract.
1926    *
1927    * @param from address representing the previous owner of the given token ID
1928    * @param to target address that will receive the tokens
1929    * @param tokenId uint256 ID of the token to be transferred
1930    * @param _data bytes optional data to send along with the call
1931    * @return bool whether the call correctly returned the expected magic value
1932    */
1933   function _checkOnERC721Received(
1934     address from,
1935     address to,
1936     uint256 tokenId,
1937     bytes memory _data
1938   ) private returns (bool) {
1939     if (to.isContract()) {
1940       try
1941         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1942       returns (bytes4 retval) {
1943         return retval == IERC721Receiver(to).onERC721Received.selector;
1944       } catch (bytes memory reason) {
1945         if (reason.length == 0) {
1946           revert("ERC721A: transfer to non ERC721Receiver implementer");
1947         } else {
1948           assembly {
1949             revert(add(32, reason), mload(reason))
1950           }
1951         }
1952       }
1953     } else {
1954       return true;
1955     }
1956   }
1957 
1958   /**
1959    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1960    *
1961    * startTokenId - the first token id to be transferred
1962    * quantity - the amount to be transferred
1963    *
1964    * Calling conditions:
1965    *
1966    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1967    * transferred to `to`.
1968    * - When `from` is zero, `tokenId` will be minted for `to`.
1969    */
1970   function _beforeTokenTransfers(
1971     address from,
1972     address to,
1973     uint256 startTokenId,
1974     uint256 quantity
1975   ) internal virtual {}
1976 
1977   /**
1978    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1979    * minting.
1980    *
1981    * startTokenId - the first token id to be transferred
1982    * quantity - the amount to be transferred
1983    *
1984    * Calling conditions:
1985    *
1986    * - when `from` and `to` are both non-zero.
1987    * - `from` and `to` are never both zero.
1988    */
1989   function _afterTokenTransfers(
1990     address from,
1991     address to,
1992     uint256 startTokenId,
1993     uint256 quantity
1994   ) internal virtual {}
1995 }
1996 
1997 contract PAPC_G is ERC721A, Ownable {
1998     string private _baseUri = "https://ipfs.io/ipfs/QmXng4M2LvUdc1a5vzYbx6UrJJNe61mignwsmDGJAiegBV/";
1999 
2000     uint256 public constant MAX_SUPPLY = 5000;
2001     uint256 public constant PRICE_SALE = 0.01 ether;
2002     uint256 private _mintCount = 0;
2003 
2004     bool public _isMintingActive = false;
2005     bool public _isMintedForTreasury = false;
2006 
2007     uint256 public constant START_SALE = 1048238400;
2008 
2009     address treasuryWallet = 0xeffd3ac8EA0e9EBF3FDF4371109FA5CaEE2D4aB1;
2010 
2011     mapping(address => bool) private oldHolderForFreeMint;
2012     mapping(address => bool) private activedHolderForFreeMint;
2013 
2014     event Mint(address _to, uint256 _amount);
2015 
2016     constructor(address[] memory holderForFreeMint) ERC721A("PAPC- Punk Ape Pixel Club Genesis", "PAPC-G", 100) {
2017 
2018         for (uint i = 0; i < holderForFreeMint.length; i++) {
2019             oldHolderForFreeMint[holderForFreeMint[i]] = true;
2020             activedHolderForFreeMint[holderForFreeMint[i]] = false;
2021         }
2022     }
2023 
2024     function getBalance() public view returns(uint) {
2025         return address(this).balance;
2026     }
2027 
2028     function withdraw() public onlyOwner{
2029         address payable to = payable(msg.sender);
2030         to.transfer(getBalance());
2031     } 
2032 
2033     function treasuryMint() public onlyOwner {
2034         require(_isMintedForTreasury == false, "NFTs are already minted for teasury wallet");
2035         _safeMint(treasuryWallet, 100);
2036 
2037         _isMintedForTreasury = true;
2038     }
2039 
2040     function freeMint(address receiver, uint256 quantity) public onlyOwner {
2041         _safeMint(receiver, quantity);
2042         
2043         emit Mint(receiver, quantity);
2044     }
2045 
2046     function holderMint() external {
2047         require(_isMintingActive && block.timestamp >= START_SALE, "PAPC-G: holder mint is not active");
2048         require(oldHolderForFreeMint[msg.sender] == true, "PAPC-G: You are not allowed!");
2049         require(activedHolderForFreeMint[msg.sender] == false, "PAPC-G: You are already free minted");
2050 
2051         _safeMint(msg.sender, 10);
2052         _mintCount = _mintCount + 10;
2053         activedHolderForFreeMint[msg.sender] = true;
2054 
2055         emit Mint(msg.sender, 10);
2056     }
2057 
2058     function isActivedHolderForFreeMint(address holder) public view returns(bool) {
2059         return activedHolderForFreeMint[holder];
2060     }
2061 
2062     function mint(uint256 quantity) external payable {
2063         require(_isMintingActive && block.timestamp >= START_SALE, "PAPC-G: sale is not active");
2064         require(quantity <= 25, "PAPC-G: minting too many");
2065         require(_mintCount + quantity <= MAX_SUPPLY, "PAPC-G: exceeds max supply");
2066         require(quantity * PRICE_SALE == msg.value, "PAPC-G: must send correct ETH amount");
2067 
2068         _safeMint(msg.sender, quantity);
2069         _mintCount = _mintCount + quantity;
2070 
2071         emit Mint(msg.sender, quantity);
2072     }
2073 
2074     function setBaseURI(string memory baseUri) public onlyOwner {
2075         _baseUri = baseUri;
2076     }
2077 
2078     function _baseURI() internal view virtual override returns (string memory) {
2079         return _baseUri;
2080     }
2081 
2082     function toggleMinting() public onlyOwner {
2083         _isMintingActive = !_isMintingActive;
2084     }
2085 }