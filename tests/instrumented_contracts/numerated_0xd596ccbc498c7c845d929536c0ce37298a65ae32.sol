1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 pragma solidity ^0.8.9;
5 
6 /**
7  * @dev String operations.
8  */
9 library Strings {
10     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
67 }
68 
69 // File: @openzeppelin/contracts/utils/Context.sol
70 
71 
72 
73 pragma solidity ^0.8.9;
74 
75 /**
76  * @dev Provides information about the current execution context, including the
77  * sender of the transaction and its data. While these are generally available
78  * via msg.sender and msg.data, they should not be accessed in such a direct
79  * manner, since when dealing with meta-transactions the account sending and
80  * paying for execution may not be the actual sender (as far as an application
81  * is concerned).
82  *
83  * This contract is only required for intermediate, library-like contracts.
84  */
85 abstract contract Context {
86     function _msgSender() internal view virtual returns (address) {
87         return msg.sender;
88     }
89 
90     function _msgData() internal view virtual returns (bytes calldata) {
91         return msg.data;
92     }
93 }
94 
95 // File: @openzeppelin/contracts/access/Ownable.sol
96 
97 
98 
99 pragma solidity ^0.8.9;
100 
101 
102 /**
103  * @dev Contract module which provides a basic access control mechanism, where
104  * there is an account (an owner) that can be granted exclusive access to
105  * specific functions.
106  *
107  * By default, the owner account will be the one that deploys the contract. This
108  * can later be changed with {transferOwnership}.
109  *
110  * This module is used through inheritance. It will make available the modifier
111  * `onlyOwner`, which can be applied to your functions to restrict their use to
112  * the owner.
113  */
114 abstract contract Ownable is Context {
115     address private _owner;
116 
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119     /**
120      * @dev Initializes the contract setting the deployer as the initial owner.
121      */
122     constructor() {
123         _setOwner(_msgSender());
124     }
125 
126     /**
127      * @dev Returns the address of the current owner.
128      */
129     function owner() public view virtual returns (address) {
130         return _owner;
131     }
132 
133     /**
134      * @dev Throws if called by any account other than the owner.
135      */
136     modifier onlyOwner() {
137         require(owner() == _msgSender(), "Ownable: caller is not the owner");
138         _;
139     }
140 
141     /**
142      * @dev Leaves the contract without owner. It will not be possible to call
143      * `onlyOwner` functions anymore. Can only be called by the current owner.
144      *
145      * NOTE: Renouncing ownership will leave the contract without an owner,
146      * thereby removing any functionality that is only available to the owner.
147      */
148     function renounceOwnership() public virtual onlyOwner {
149         _setOwner(address(0));
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      * Can only be called by the current owner.
155      */
156     function transferOwnership(address newOwner) public virtual onlyOwner {
157         require(newOwner != address(0), "Ownable: new owner is the zero address");
158         _setOwner(newOwner);
159     }
160 
161     function _setOwner(address newOwner) private {
162         address oldOwner = _owner;
163         _owner = newOwner;
164         emit OwnershipTransferred(oldOwner, newOwner);
165     }
166 }
167 
168 // File: @openzeppelin/contracts/utils/Address.sol
169 
170 
171 
172 pragma solidity ^0.8.9;
173 
174 /**
175  * @dev Collection of functions related to the address type
176  */
177 library Address {
178     /**
179      * @dev Returns true if `account` is a contract.
180      *
181      * [IMPORTANT]
182      * ====
183      * It is unsafe to assume that an address for which this function returns
184      * false is an externally-owned account (EOA) and not a contract.
185      *
186      * Among others, `isContract` will return false for the following
187      * types of addresses:
188      *
189      *  - an externally-owned account
190      *  - a contract in construction
191      *  - an address where a contract will be created
192      *  - an address where a contract lived, but was destroyed
193      * ====
194      */
195     function isContract(address account) internal view returns (bool) {
196         // This method relies on extcodesize, which returns 0 for contracts in
197         // construction, since the code is only stored at the end of the
198         // constructor execution.
199 
200         uint256 size;
201         assembly {
202             size := extcodesize(account)
203         }
204         return size > 0;
205     }
206 
207     /**
208      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
209      * `recipient`, forwarding all available gas and reverting on errors.
210      *
211      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
212      * of certain opcodes, possibly making contracts go over the 2300 gas limit
213      * imposed by `transfer`, making them unable to receive funds via
214      * `transfer`. {sendValue} removes this limitation.
215      *
216      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
217      *
218      * IMPORTANT: because control is transferred to `recipient`, care must be
219      * taken to not create reentrancy vulnerabilities. Consider using
220      * {ReentrancyGuard} or the
221      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
222      */
223     function sendValue(address payable recipient, uint256 amount) internal {
224         require(address(this).balance >= amount, "Address: insufficient balance");
225 
226         (bool success, ) = recipient.call{value: amount}("");
227         require(success, "Address: unable to send value, recipient may have reverted");
228     }
229 
230     /**
231      * @dev Performs a Solidity function call using a low level `call`. A
232      * plain `call` is an unsafe replacement for a function call: use this
233      * function instead.
234      *
235      * If `target` reverts with a revert reason, it is bubbled up by this
236      * function (like regular Solidity function calls).
237      *
238      * Returns the raw returned data. To convert to the expected return value,
239      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
240      *
241      * Requirements:
242      *
243      * - `target` must be a contract.
244      * - calling `target` with `data` must not revert.
245      *
246      * _Available since v3.1._
247      */
248     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
249         return functionCall(target, data, "Address: low-level call failed");
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
254      * `errorMessage` as a fallback revert reason when `target` reverts.
255      *
256      * _Available since v3.1._
257      */
258     function functionCall(
259         address target,
260         bytes memory data,
261         string memory errorMessage
262     ) internal returns (bytes memory) {
263         return functionCallWithValue(target, data, 0, errorMessage);
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
268      * but also transferring `value` wei to `target`.
269      *
270      * Requirements:
271      *
272      * - the calling contract must have an ETH balance of at least `value`.
273      * - the called Solidity function must be `payable`.
274      *
275      * _Available since v3.1._
276      */
277     function functionCallWithValue(
278         address target,
279         bytes memory data,
280         uint256 value
281     ) internal returns (bytes memory) {
282         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
287      * with `errorMessage` as a fallback revert reason when `target` reverts.
288      *
289      * _Available since v3.1._
290      */
291     function functionCallWithValue(
292         address target,
293         bytes memory data,
294         uint256 value,
295         string memory errorMessage
296     ) internal returns (bytes memory) {
297         require(address(this).balance >= value, "Address: insufficient balance for call");
298         require(isContract(target), "Address: call to non-contract");
299 
300         (bool success, bytes memory returndata) = target.call{value: value}(data);
301         return verifyCallResult(success, returndata, errorMessage);
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
306      * but performing a static call.
307      *
308      * _Available since v3.3._
309      */
310     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
311         return functionStaticCall(target, data, "Address: low-level static call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
316      * but performing a static call.
317      *
318      * _Available since v3.3._
319      */
320     function functionStaticCall(
321         address target,
322         bytes memory data,
323         string memory errorMessage
324     ) internal view returns (bytes memory) {
325         require(isContract(target), "Address: static call to non-contract");
326 
327         (bool success, bytes memory returndata) = target.staticcall(data);
328         return verifyCallResult(success, returndata, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but performing a delegate call.
334      *
335      * _Available since v3.4._
336      */
337     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
338         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
343      * but performing a delegate call.
344      *
345      * _Available since v3.4._
346      */
347     function functionDelegateCall(
348         address target,
349         bytes memory data,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         require(isContract(target), "Address: delegate call to non-contract");
353 
354         (bool success, bytes memory returndata) = target.delegatecall(data);
355         return verifyCallResult(success, returndata, errorMessage);
356     }
357 
358     /**
359      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
360      * revert reason using the provided one.
361      *
362      * _Available since v4.3._
363      */
364     function verifyCallResult(
365         bool success,
366         bytes memory returndata,
367         string memory errorMessage
368     ) internal pure returns (bytes memory) {
369         if (success) {
370             return returndata;
371         } else {
372             // Look for revert reason and bubble it up if present
373             if (returndata.length > 0) {
374                 // The easiest way to bubble the revert reason is using memory via assembly
375 
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
388 
389 pragma solidity ^0.8.9;
390 
391 /**
392  * @title ERC721 token receiver interface
393  * @dev Interface for any contract that wants to support safeTransfers
394  * from ERC721 asset contracts.
395  */
396 interface IERC721Receiver {
397     /**
398      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
399      * by `operator` from `from`, this function is called.
400      *
401      * It must return its Solidity selector to confirm the token transfer.
402      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
403      *
404      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
405      */
406     function onERC721Received(
407         address operator,
408         address from,
409         uint256 tokenId,
410         bytes calldata data
411     ) external returns (bytes4);
412 }
413 
414 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
415 
416 
417 
418 pragma solidity ^0.8.9;
419 
420 /**
421  * @dev Interface of the ERC165 standard, as defined in the
422  * https://eips.ethereum.org/EIPS/eip-165[EIP].
423  *
424  * Implementers can declare support of contract interfaces, which can then be
425  * queried by others ({ERC165Checker}).
426  *
427  * For an implementation, see {ERC165}.
428  */
429 interface IERC165 {
430     /**
431      * @dev Returns true if this contract implements the interface defined by
432      * `interfaceId`. See the corresponding
433      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
434      * to learn more about how these ids are created.
435      *
436      * This function call must use less than 30 000 gas.
437      */
438     function supportsInterface(bytes4 interfaceId) external view returns (bool);
439 }
440 
441 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
442 
443 
444 
445 pragma solidity ^0.8.9;
446 
447 
448 /**
449  * @dev Implementation of the {IERC165} interface.
450  *
451  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
452  * for the additional interface id that will be supported. For example:
453  *
454  * ```solidity
455  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
456  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
457  * }
458  * ```
459  *
460  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
461  */
462 abstract contract ERC165 is IERC165 {
463     /**
464      * @dev See {IERC165-supportsInterface}.
465      */
466     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
467         return interfaceId == type(IERC165).interfaceId;
468     }
469 }
470 
471 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
472 
473 
474 
475 pragma solidity ^0.8.9;
476 
477 
478 /**
479  * @dev Required interface of an ERC721 compliant contract.
480  */
481 interface IERC721 is IERC165 {
482     /**
483      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
484      */
485     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
486 
487     /**
488      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
489      */
490     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
491 
492     /**
493      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
494      */
495     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
496 
497     /**
498      * @dev Returns the number of tokens in ``owner``'s account.
499      */
500     function balanceOf(address owner) external view returns (uint256 balance);
501 
502     /**
503      * @dev Returns the owner of the `tokenId` token.
504      *
505      * Requirements:
506      *
507      * - `tokenId` must exist.
508      */
509     function ownerOf(uint256 tokenId) external view returns (address owner);
510 
511     /**
512      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
513      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
514      *
515      * Requirements:
516      *
517      * - `from` cannot be the zero address.
518      * - `to` cannot be the zero address.
519      * - `tokenId` token must exist and be owned by `from`.
520      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
521      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
522      *
523      * Emits a {Transfer} event.
524      */
525     function safeTransferFrom(
526         address from,
527         address to,
528         uint256 tokenId
529     ) external;
530 
531     /**
532      * @dev Transfers `tokenId` token from `from` to `to`.
533      *
534      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
535      *
536      * Requirements:
537      *
538      * - `from` cannot be the zero address.
539      * - `to` cannot be the zero address.
540      * - `tokenId` token must be owned by `from`.
541      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
542      *
543      * Emits a {Transfer} event.
544      */
545     function transferFrom(
546         address from,
547         address to,
548         uint256 tokenId
549     ) external;
550 
551     /**
552      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
553      * The approval is cleared when the token is transferred.
554      *
555      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
556      *
557      * Requirements:
558      *
559      * - The caller must own the token or be an approved operator.
560      * - `tokenId` must exist.
561      *
562      * Emits an {Approval} event.
563      */
564     function approve(address to, uint256 tokenId) external;
565 
566     /**
567      * @dev Returns the account approved for `tokenId` token.
568      *
569      * Requirements:
570      *
571      * - `tokenId` must exist.
572      */
573     function getApproved(uint256 tokenId) external view returns (address operator);
574 
575     /**
576      * @dev Approve or remove `operator` as an operator for the caller.
577      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
578      *
579      * Requirements:
580      *
581      * - The `operator` cannot be the caller.
582      *
583      * Emits an {ApprovalForAll} event.
584      */
585     function setApprovalForAll(address operator, bool _approved) external;
586 
587     /**
588      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
589      *
590      * See {setApprovalForAll}
591      */
592     function isApprovedForAll(address owner, address operator) external view returns (bool);
593 
594     /**
595      * @dev Safely transfers `tokenId` token from `from` to `to`.
596      *
597      * Requirements:
598      *
599      * - `from` cannot be the zero address.
600      * - `to` cannot be the zero address.
601      * - `tokenId` token must exist and be owned by `from`.
602      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
603      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
604      *
605      * Emits a {Transfer} event.
606      */
607     function safeTransferFrom(
608         address from,
609         address to,
610         uint256 tokenId,
611         bytes calldata data
612     ) external;
613 }
614 
615 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
616 
617 
618 
619 pragma solidity ^0.8.9;
620 
621 
622 /**
623  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
624  * @dev See https://eips.ethereum.org/EIPS/eip-721
625  */
626 interface IERC721Metadata is IERC721 {
627     /**
628      * @dev Returns the token collection name.
629      */
630     function name() external view returns (string memory);
631 
632     /**
633      * @dev Returns the token collection symbol.
634      */
635     function symbol() external view returns (string memory);
636 
637     /**
638      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
639      */
640     function tokenURI(uint256 tokenId) external view returns (string memory);
641 }
642 
643 
644 pragma solidity >=0.8.9;
645 // to enable certain compiler features
646 
647 
648 
649 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
650     using Address for address;
651     using Strings for uint256;
652 
653     // Token name
654     string private _name;
655 
656     // Token symbol
657     string private _symbol;
658 
659     // Mapping from token ID to owner address
660     mapping(uint256 => address) private _owners;
661 
662     // Mapping owner address to token count
663     mapping(address => uint256) private _balances;
664 
665     // Mapping from token ID to approved address
666     mapping(uint256 => address) private _tokenApprovals;
667 
668     // Mapping from owner to operator approvals
669     mapping(address => mapping(address => bool)) private _operatorApprovals;
670     
671     //Mapping para atribuirle un URI para cada token
672     mapping(uint256 => string) internal id_to_URI;
673 
674     /**
675      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
676      */
677     constructor(string memory name_, string memory symbol_) {
678         _name = name_;
679         _symbol = symbol_;
680     }
681 
682     /**
683      * @dev See {IERC165-supportsInterface}.
684      */
685     
686     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
687         return
688             interfaceId == type(IERC721).interfaceId ||
689             interfaceId == type(IERC721Metadata).interfaceId ||
690             super.supportsInterface(interfaceId);
691     }
692     
693 
694     /**
695      * @dev See {IERC721-balanceOf}.
696      */
697     function balanceOf(address owner) public view virtual override returns (uint256) {
698         require(owner != address(0), "ERC721: balance query for the zero address");
699         return _balances[owner];
700     }
701 
702     /**
703      * @dev See {IERC721-ownerOf}.
704      */
705     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
706         address owner = _owners[tokenId];
707         require(owner != address(0), "ERC721: owner query for nonexistent token");
708         return owner;
709     }
710 
711     /**
712      * @dev See {IERC721Metadata-name}.
713      */
714     function name() public view virtual override returns (string memory) {
715         return _name;
716     }
717 
718     /**
719      * @dev See {IERC721Metadata-symbol}.
720      */
721     function symbol() public view virtual override returns (string memory) {
722         return _symbol;
723     }
724 
725     /**
726      * @dev See {IERC721Metadata-tokenURI}.
727      */
728     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {  }
729 
730     /**
731      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
732      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
733      * by default, can be overriden in child contracts.
734      */
735     function _baseURI() internal view virtual returns (string memory) {
736         return "";
737     }
738 
739     /**
740      * @dev See {IERC721-approve}.
741      */
742     function approve(address to, uint256 tokenId) public virtual override {
743         address owner = ERC721.ownerOf(tokenId);
744         require(to != owner, "ERC721: approval to current owner");
745 
746         require(
747             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
748             "ERC721: approve caller is not owner nor approved for all"
749         );
750 
751         _approve(to, tokenId);
752     }
753 
754     /**
755      * @dev See {IERC721-getApproved}.
756      */
757     function getApproved(uint256 tokenId) public view virtual override returns (address) {
758         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
759 
760         return _tokenApprovals[tokenId];
761     }
762 
763     /**
764      * @dev See {IERC721-setApprovalForAll}.
765      */
766     function setApprovalForAll(address operator, bool approved) public virtual override {
767         require(operator != _msgSender(), "ERC721: approve to caller");
768 
769         _operatorApprovals[_msgSender()][operator] = approved;
770         emit ApprovalForAll(_msgSender(), operator, approved);
771     }
772 
773     /**
774      * @dev See {IERC721-isApprovedForAll}.
775      */
776     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
777         return _operatorApprovals[owner][operator];
778     }
779 
780     /**
781      * @dev See {IERC721-transferFrom}.
782      */
783     function transferFrom(
784         address from,
785         address to,
786         uint256 tokenId
787     ) public virtual override {
788         //solhint-disable-next-line max-line-length
789         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
790 
791         _transfer(from, to, tokenId);
792     }
793 
794     /**
795      * @dev See {IERC721-safeTransferFrom}.
796      */
797     function safeTransferFrom(
798         address from,
799         address to,
800         uint256 tokenId
801     ) public virtual override {
802         safeTransferFrom(from, to, tokenId, "");
803     }
804 
805     /**
806      * @dev See {IERC721-safeTransferFrom}.
807      */
808     function safeTransferFrom(
809         address from,
810         address to,
811         uint256 tokenId,
812         bytes memory _data
813     ) public virtual override {
814         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
815         _safeTransfer(from, to, tokenId, _data);
816     }
817 
818     /**
819      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
820      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
821      *
822      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
823      *
824      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
825      * implement alternative mechanisms to perform token transfer, such as signature-based.
826      *
827      * Requirements:
828      *
829      * - `from` cannot be the zero address.
830      * - `to` cannot be the zero address.
831      * - `tokenId` token must exist and be owned by `from`.
832      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
833      *
834      * Emits a {Transfer} event.
835      */
836     function _safeTransfer(
837         address from,
838         address to,
839         uint256 tokenId,
840         bytes memory _data
841     ) internal virtual {
842         _transfer(from, to, tokenId);
843         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
844     }
845 
846     /**
847      * @dev Returns whether `tokenId` exists.
848      *
849      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
850      *
851      * Tokens start existing when they are minted (`_mint`),
852      * and stop existing when they are burned (`_burn`).
853      */
854     function _exists(uint256 tokenId) internal view virtual returns (bool) {
855         return _owners[tokenId] != address(0);
856     }
857 
858     /**
859      * @dev Returns whether `spender` is allowed to manage `tokenId`.
860      *
861      * Requirements:
862      *
863      * - `tokenId` must exist.
864      */
865     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
866         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
867         address owner = ERC721.ownerOf(tokenId);
868         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
869     }
870 
871     /**
872      * @dev Safely mints `tokenId` and transfers it to `to`.
873      *
874      * Requirements:
875      *
876      * - `tokenId` must not exist.
877      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
878      *
879      * Emits a {Transfer} event.
880      */
881     function _safeMint(address to, uint256 tokenId) internal virtual {
882         _safeMint(to, tokenId, "");
883     }
884 
885     /**
886      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
887      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
888      */
889     function _safeMint(
890         address to,
891         uint256 tokenId,
892         bytes memory _data
893     ) internal virtual {
894         _mint(to, tokenId);
895         require(
896             _checkOnERC721Received(address(0), to, tokenId, _data),
897             "ERC721: transfer to non ERC721Receiver implementer"
898         );
899     }
900 
901     /**
902      * @dev Mints `tokenId` and transfers it to `to`.
903      *
904      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
905      *
906      * Requirements:
907      *
908      * - `tokenId` must not exist.
909      * - `to` cannot be the zero address.
910      *
911      * Emits a {Transfer} event.
912      */
913     function _mint(address to, uint256 tokenId) internal virtual {
914         require(to != address(0), "ERC721: mint to the zero address");
915         require(!_exists(tokenId), "ERC721: token already minted");
916 
917         _beforeTokenTransfer(address(0), to, tokenId);
918 
919         _balances[to] += 1;
920         _owners[tokenId] = to;
921 
922         emit Transfer(address(0), to, tokenId);
923     }
924 
925     /**
926      * @dev Destroys `tokenId`.
927      * The approval is cleared when the token is burned.
928      *
929      * Requirements:
930      *
931      * - `tokenId` must exist.
932      *
933      * Emits a {Transfer} event.
934      */
935     function _burn(uint256 tokenId) internal virtual {
936         address owner = ERC721.ownerOf(tokenId);
937 
938         _beforeTokenTransfer(owner, address(0), tokenId);
939 
940         // Clear approvals
941         _approve(address(0), tokenId);
942 
943         _balances[owner] -= 1;
944         delete _owners[tokenId];
945 
946         emit Transfer(owner, address(0), tokenId);
947     }
948 
949     /**
950      * @dev Transfers `tokenId` from `from` to `to`.
951      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
952      *
953      * Requirements:
954      *
955      * - `to` cannot be the zero address.
956      * - `tokenId` token must be owned by `from`.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _transfer(
961         address from,
962         address to,
963         uint256 tokenId
964     ) internal virtual {
965         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
966         require(to != address(0), "ERC721: transfer to the zero address");
967 
968         _beforeTokenTransfer(from, to, tokenId);
969 
970         // Clear approvals from the previous owner
971         _approve(address(0), tokenId);
972 
973         _balances[from] -= 1;
974         _balances[to] += 1;
975         _owners[tokenId] = to;
976 
977         emit Transfer(from, to, tokenId);
978     }
979 
980     /**
981      * @dev Approve `to` to operate on `tokenId`
982      *
983      * Emits a {Approval} event.
984      */
985     function _approve(address to, uint256 tokenId) internal virtual {
986         _tokenApprovals[tokenId] = to;
987         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
988     }
989 
990     /**
991      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
992      * The call is not executed if the target address is not a contract.
993      *
994      * @param from address representing the previous owner of the given token ID
995      * @param to target address that will receive the tokens
996      * @param tokenId uint256 ID of the token to be transferred
997      * @param _data bytes optional data to send along with the call
998      * @return bool whether the call correctly returned the expected magic value
999      */
1000     function _checkOnERC721Received(
1001         address from,
1002         address to,
1003         uint256 tokenId,
1004         bytes memory _data
1005     ) private returns (bool) {
1006         if (to.isContract()) {
1007             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1008                 return retval == IERC721Receiver.onERC721Received.selector;
1009             } catch (bytes memory reason) {
1010                 if (reason.length == 0) {
1011                     revert("ERC721: transfer to non ERC721Receiver implementer");
1012                 } else {
1013                     assembly {
1014                         revert(add(32, reason), mload(reason))
1015                     }
1016                 }
1017             }
1018         } else {
1019             return true;
1020         }
1021     }
1022 
1023     /**
1024      * @dev Hook that is called before any token transfer. This includes minting
1025      * and burning.
1026      *
1027      * Calling conditions:
1028      *
1029      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1030      * transferred to `to`.
1031      * - When `from` is zero, `tokenId` will be minted for `to`.
1032      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1033      * - `from` and `to` are never both zero.
1034      *
1035      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1036      */
1037     function _beforeTokenTransfer(
1038         address from,
1039         address to,
1040         uint256 tokenId
1041     ) internal virtual {}
1042 }
1043 
1044 pragma solidity ^0.8.9;
1045 
1046 /**
1047  * @dev Contract module that helps prevent reentrant calls to a function.
1048  *
1049  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1050  * available, which can be applied to functions to make sure there are no nested
1051  * (reentrant) calls to them.
1052  *
1053  * Note that because there is a single `nonReentrant` guard, functions marked as
1054  * `nonReentrant` may not call one another. This can be worked around by making
1055  * those functions `private`, and then adding `external` `nonReentrant` entry
1056  * points to them.
1057  *
1058  * TIP: If you would like to learn more about reentrancy and alternative ways
1059  * to protect against it, check out our blog post
1060  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1061  */
1062 abstract contract ReentrancyGuard {
1063     // Booleans are more expensive than uint256 or any type that takes up a full
1064     // word because each write operation emits an extra SLOAD to first read the
1065     // slot's contents, replace the bits taken up by the boolean, and then write
1066     // back. This is the compiler's defense against contract upgrades and
1067     // pointer aliasing, and it cannot be disabled.
1068 
1069     // The values being non-zero value makes deployment a bit more expensive,
1070     // but in exchange the refund on every call to nonReentrant will be lower in
1071     // amount. Since refunds are capped to a percentage of the total
1072     // transaction's gas, it is best to keep them low in cases like this one, to
1073     // increase the likelihood of the full refund coming into effect.
1074     uint256 private constant _NOT_ENTERED = 1;
1075     uint256 private constant _ENTERED = 2;
1076 
1077     uint256 private _status;
1078 
1079     constructor() {
1080         _status = _NOT_ENTERED;
1081     }
1082 
1083     /**
1084      * @dev Prevents a contract from calling itself, directly or indirectly.
1085      * Calling a `nonReentrant` function from another `nonReentrant`
1086      * function is not supported. It is possible to prevent this from happening
1087      * by making the `nonReentrant` function external, and making it call a
1088      * `private` function that does the actual work.
1089      */
1090     modifier nonReentrant() {
1091         // On the first call to nonReentrant, _notEntered will be true
1092         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1093 
1094         // Any calls to nonReentrant after this point will fail
1095         _status = _ENTERED;
1096 
1097         _;
1098 
1099         // By storing the original value once again, a refund is triggered (see
1100         // https://eips.ethereum.org/EIPS/eip-2200)
1101         _status = _NOT_ENTERED;
1102     }
1103 }
1104 
1105 
1106 pragma solidity ^0.8.9;
1107 
1108 /**
1109  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1110  * @dev See https://eips.ethereum.org/EIPS/eip-721
1111  */
1112 interface IERC721Enumerable is IERC721 {
1113     /**
1114      * @dev Returns the total amount of tokens stored by the contract.
1115      */
1116     function totalSupply() external view returns (uint256);
1117 
1118     /**
1119      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1120      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1121      */
1122     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1123 
1124     /**
1125      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1126      * Use along with {totalSupply} to enumerate all tokens.
1127      */
1128     function tokenByIndex(uint256 index) external view returns (uint256);
1129 }
1130 
1131 
1132 // Creator: Chiru Labs
1133 
1134 pragma solidity ^0.8.9;
1135 
1136 /**
1137  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1138  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1139  *
1140  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1141  *
1142  * Does not support burning tokens to address(0).
1143  *
1144  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
1145  */
1146 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1147     using Address for address;
1148     using Strings for uint256;
1149 
1150     struct TokenOwnership {
1151         address addr;
1152         uint64 startTimestamp;
1153     }
1154 
1155     struct AddressData {
1156         uint128 balance;
1157         uint128 numberMinted;
1158     }
1159 
1160     uint256 internal currentIndex;
1161 
1162     // Token name
1163     string private _name;
1164 
1165     // Token symbol
1166     string private _symbol;
1167 
1168     // Mapping from token ID to ownership details
1169     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1170     mapping(uint256 => TokenOwnership) internal _ownerships;
1171 
1172     // Mapping owner address to address data
1173     mapping(address => AddressData) private _addressData;
1174 
1175     // Mapping from token ID to approved address
1176     mapping(uint256 => address) private _tokenApprovals;
1177 
1178     // Mapping from owner to operator approvals
1179     mapping(address => mapping(address => bool)) private _operatorApprovals;
1180 
1181     constructor(string memory name_, string memory symbol_) {
1182         _name = name_;
1183         _symbol = symbol_;
1184     }
1185 
1186     /**
1187      * @dev See {IERC721Enumerable-totalSupply}.
1188      */
1189     function totalSupply() public view virtual override returns (uint256) {
1190         return currentIndex;
1191     }
1192 
1193     /**
1194      * @dev See {IERC721Enumerable-tokenByIndex}.
1195      */
1196     function tokenByIndex(uint256 index) public view override returns (uint256) {
1197         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1198         return index;
1199     }
1200 
1201     /**
1202      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1203      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1204      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1205      */
1206     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1207         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1208         uint256 numMintedSoFar = totalSupply();
1209         uint256 tokenIdsIdx;
1210         address currOwnershipAddr;
1211 
1212         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1213         unchecked {
1214             for (uint256 i; i < numMintedSoFar; i++) {
1215                 TokenOwnership memory ownership = _ownerships[i];
1216                 if (ownership.addr != address(0)) {
1217                     currOwnershipAddr = ownership.addr;
1218                 }
1219                 if (currOwnershipAddr == owner) {
1220                     if (tokenIdsIdx == index) {
1221                         return i;
1222                     }
1223                     tokenIdsIdx++;
1224                 }
1225             }
1226         }
1227 
1228         revert('ERC721A: unable to get token of owner by index');
1229     }
1230 
1231     /**
1232      * @dev See {IERC165-supportsInterface}.
1233      */
1234     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1235         return
1236             interfaceId == type(IERC721).interfaceId ||
1237             interfaceId == type(IERC721Metadata).interfaceId ||
1238             interfaceId == type(IERC721Enumerable).interfaceId ||
1239             super.supportsInterface(interfaceId);
1240     }
1241 
1242     /**
1243      * @dev See {IERC721-balanceOf}.
1244      */
1245     function balanceOf(address owner) public view override returns (uint256) {
1246         require(owner != address(0), 'ERC721A: balance query for the zero address');
1247         return uint256(_addressData[owner].balance);
1248     }
1249 
1250     function _numberMinted(address owner) internal view returns (uint256) {
1251         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1252         return uint256(_addressData[owner].numberMinted);
1253     }
1254 
1255     /**
1256      * Gas spent here starts off proportional to the maximum mint batch size.
1257      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1258      */
1259     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1260         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1261 
1262         unchecked {
1263             for (uint256 curr = tokenId; curr >= 0; curr--) {
1264                 TokenOwnership memory ownership = _ownerships[curr];
1265                 if (ownership.addr != address(0)) {
1266                     return ownership;
1267                 }
1268             }
1269         }
1270 
1271         revert('ERC721A: unable to determine the owner of token');
1272     }
1273 
1274     /**
1275      * @dev See {IERC721-ownerOf}.
1276      */
1277     function ownerOf(uint256 tokenId) public view override returns (address) {
1278         return ownershipOf(tokenId).addr;
1279     }
1280 
1281     /**
1282      * @dev See {IERC721Metadata-name}.
1283      */
1284     function name() public view virtual override returns (string memory) {
1285         return _name;
1286     }
1287 
1288     /**
1289      * @dev See {IERC721Metadata-symbol}.
1290      */
1291     function symbol() public view virtual override returns (string memory) {
1292         return _symbol;
1293     }
1294 
1295     /**
1296      * @dev See {IERC721Metadata-tokenURI}.
1297      */
1298     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1299         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1300 
1301         string memory baseURI = _baseURI();
1302         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1303     }
1304 
1305     /**
1306      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1307      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1308      * by default, can be overriden in child contracts.
1309      */
1310     function _baseURI() internal view virtual returns (string memory) {
1311         return '';
1312     }
1313 
1314     /**
1315      * @dev See {IERC721-approve}.
1316      */
1317     function approve(address to, uint256 tokenId) public override {
1318         address owner = ERC721A.ownerOf(tokenId);
1319         require(to != owner, 'ERC721A: approval to current owner');
1320 
1321         require(
1322             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1323             'ERC721A: approve caller is not owner nor approved for all'
1324         );
1325 
1326         _approve(to, tokenId, owner);
1327     }
1328 
1329     /**
1330      * @dev See {IERC721-getApproved}.
1331      */
1332     function getApproved(uint256 tokenId) public view override returns (address) {
1333         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1334 
1335         return _tokenApprovals[tokenId];
1336     }
1337 
1338     /**
1339      * @dev See {IERC721-setApprovalForAll}.
1340      */
1341     function setApprovalForAll(address operator, bool approved) public override {
1342         require(operator != _msgSender(), 'ERC721A: approve to caller');
1343 
1344         _operatorApprovals[_msgSender()][operator] = approved;
1345         emit ApprovalForAll(_msgSender(), operator, approved);
1346     }
1347 
1348     /**
1349      * @dev See {IERC721-isApprovedForAll}.
1350      */
1351     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1352         return _operatorApprovals[owner][operator];
1353     }
1354 
1355     /**
1356      * @dev See {IERC721-transferFrom}.
1357      */
1358     function transferFrom(
1359         address from,
1360         address to,
1361         uint256 tokenId
1362     ) public virtual override {
1363         _transfer(from, to, tokenId);
1364     }
1365 
1366     /**
1367      * @dev See {IERC721-safeTransferFrom}.
1368      */
1369     function safeTransferFrom(
1370         address from,
1371         address to,
1372         uint256 tokenId
1373     ) public virtual override {
1374         safeTransferFrom(from, to, tokenId, '');
1375     }
1376 
1377     /**
1378      * @dev See {IERC721-safeTransferFrom}.
1379      */
1380     function safeTransferFrom(
1381         address from,
1382         address to,
1383         uint256 tokenId,
1384         bytes memory _data
1385     ) public override {
1386         _transfer(from, to, tokenId);
1387         require(
1388             _checkOnERC721Received(from, to, tokenId, _data),
1389             'ERC721A: transfer to non ERC721Receiver implementer'
1390         );
1391     }
1392 
1393     /**
1394      * @dev Returns whether `tokenId` exists.
1395      *
1396      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1397      *
1398      * Tokens start existing when they are minted (`_mint`),
1399      */
1400     function _exists(uint256 tokenId) internal view returns (bool) {
1401         return tokenId < currentIndex;
1402     }
1403 
1404     function _safeMint(address to, uint256 quantity) internal {
1405         _safeMint(to, quantity, '');
1406     }
1407 
1408     /**
1409      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1410      *
1411      * Requirements:
1412      *
1413      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1414      * - `quantity` must be greater than 0.
1415      *
1416      * Emits a {Transfer} event.
1417      */
1418     function _safeMint(
1419         address to,
1420         uint256 quantity,
1421         bytes memory _data
1422     ) internal {
1423         _mint(to, quantity, _data, true);
1424     }
1425 
1426     /**
1427      * @dev Mints `quantity` tokens and transfers them to `to`.
1428      *
1429      * Requirements:
1430      *
1431      * - `to` cannot be the zero address.
1432      * - `quantity` must be greater than 0.
1433      *
1434      * Emits a {Transfer} event.
1435      */
1436     function _mint(
1437         address to,
1438         uint256 quantity,
1439         bytes memory _data,
1440         bool safe
1441     ) internal {
1442         uint256 startTokenId = currentIndex;
1443         require(to != address(0), 'ERC721A: mint to the zero address');
1444         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1445 
1446         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1447 
1448         // Overflows are incredibly unrealistic.
1449         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1450         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1451         unchecked {
1452             _addressData[to].balance += uint128(quantity);
1453             _addressData[to].numberMinted += uint128(quantity);
1454 
1455             _ownerships[startTokenId].addr = to;
1456             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1457 
1458             uint256 updatedIndex = startTokenId;
1459 
1460             for (uint256 i; i < quantity; i++) {
1461                 emit Transfer(address(0), to, updatedIndex);
1462                 if (safe) {
1463                     require(
1464                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1465                         'ERC721A: transfer to non ERC721Receiver implementer'
1466                     );
1467                 }
1468 
1469                 updatedIndex++;
1470             }
1471 
1472             currentIndex = updatedIndex;
1473         }
1474 
1475         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1476     }
1477 
1478     /**
1479      * @dev Transfers `tokenId` from `from` to `to`.
1480      *
1481      * Requirements:
1482      *
1483      * - `to` cannot be the zero address.
1484      * - `tokenId` token must be owned by `from`.
1485      *
1486      * Emits a {Transfer} event.
1487      */
1488     function _transfer(
1489         address from,
1490         address to,
1491         uint256 tokenId
1492     ) private {
1493         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1494 
1495         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1496             getApproved(tokenId) == _msgSender() ||
1497             isApprovedForAll(prevOwnership.addr, _msgSender()));
1498 
1499         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1500 
1501         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1502         require(to != address(0), 'ERC721A: transfer to the zero address');
1503 
1504         _beforeTokenTransfers(from, to, tokenId, 1);
1505 
1506         // Clear approvals from the previous owner
1507         _approve(address(0), tokenId, prevOwnership.addr);
1508 
1509         // Underflow of the sender's balance is impossible because we check for
1510         // ownership above and the recipient's balance can't realistically overflow.
1511         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1512         unchecked {
1513             _addressData[from].balance -= 1;
1514             _addressData[to].balance += 1;
1515 
1516             _ownerships[tokenId].addr = to;
1517             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1518 
1519             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1520             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1521             uint256 nextTokenId = tokenId + 1;
1522             if (_ownerships[nextTokenId].addr == address(0)) {
1523                 if (_exists(nextTokenId)) {
1524                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1525                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1526                 }
1527             }
1528         }
1529 
1530         emit Transfer(from, to, tokenId);
1531         _afterTokenTransfers(from, to, tokenId, 1);
1532     }
1533 
1534     /**
1535      * @dev Approve `to` to operate on `tokenId`
1536      *
1537      * Emits a {Approval} event.
1538      */
1539     function _approve(
1540         address to,
1541         uint256 tokenId,
1542         address owner
1543     ) private {
1544         _tokenApprovals[tokenId] = to;
1545         emit Approval(owner, to, tokenId);
1546     }
1547 
1548     /**
1549      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1550      * The call is not executed if the target address is not a contract.
1551      *
1552      * @param from address representing the previous owner of the given token ID
1553      * @param to target address that will receive the tokens
1554      * @param tokenId uint256 ID of the token to be transferred
1555      * @param _data bytes optional data to send along with the call
1556      * @return bool whether the call correctly returned the expected magic value
1557      */
1558     function _checkOnERC721Received(
1559         address from,
1560         address to,
1561         uint256 tokenId,
1562         bytes memory _data
1563     ) private returns (bool) {
1564         if (to.isContract()) {
1565             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1566                 return retval == IERC721Receiver(to).onERC721Received.selector;
1567             } catch (bytes memory reason) {
1568                 if (reason.length == 0) {
1569                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1570                 } else {
1571                     assembly {
1572                         revert(add(32, reason), mload(reason))
1573                     }
1574                 }
1575             }
1576         } else {
1577             return true;
1578         }
1579     }
1580 
1581     /**
1582      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1583      *
1584      * startTokenId - the first token id to be transferred
1585      * quantity - the amount to be transferred
1586      *
1587      * Calling conditions:
1588      *
1589      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1590      * transferred to `to`.
1591      * - When `from` is zero, `tokenId` will be minted for `to`.
1592      */
1593     function _beforeTokenTransfers(
1594         address from,
1595         address to,
1596         uint256 startTokenId,
1597         uint256 quantity
1598     ) internal virtual {}
1599 
1600     /**
1601      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1602      * minting.
1603      *
1604      * startTokenId - the first token id to be transferred
1605      * quantity - the amount to be transferred
1606      *
1607      * Calling conditions:
1608      *
1609      * - when `from` and `to` are both non-zero.
1610      * - `from` and `to` are never both zero.
1611      */
1612     function _afterTokenTransfers(
1613         address from,
1614         address to,
1615         uint256 startTokenId,
1616         uint256 quantity
1617     ) internal virtual {}
1618 }
1619 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1620 
1621 
1622 pragma solidity ^0.8.9;
1623 
1624 contract StickyDAO is ERC721A, Ownable, ReentrancyGuard {
1625     using Strings for uint256;
1626     
1627     //declares the maximum amount of tokens that can be minted, total and in presale
1628     uint256 private maxTotalTokens = 8888;
1629 
1630     //reservedmints for the team
1631     uint256 private _reservedMints;
1632     uint256 private maxReservedMints = 150;
1633     
1634     //initial part of the URI for the metadata
1635     string private _currentBaseURI;
1636         
1637     //cost of mints depending on state of sale    
1638     uint private mintCostPresale = 0.069 ether;
1639     uint private mintCostPublicSale = 0.089 ether;
1640 
1641     //max number of mints per transaction in public sale
1642     uint private maxMintPerTX = 3;
1643     
1644     //dummy address that we use to sign the mint transaction to make sure it is valid
1645     address private dummy = 0x80E4929c869102140E69550BBECC20bEd61B080c;
1646 
1647     //amount of mints that each address has executed
1648     mapping(address => uint256) public mintsPerAddress;
1649     
1650     //current state os sale
1651     enum State {NoSale, Presale, PublicSale}
1652 
1653     //defines the uri for when the NFTs have not been yet revealed
1654     string public unrevealedURI;
1655     
1656     //marks the timestamp of when the respective sales open
1657     uint256 public presaleLaunchTime;
1658     uint256 public publicSaleLaunchTime;
1659     uint256 public revealTime;
1660     
1661     //declaring initial values for variables
1662     constructor() ERC721A("Sticky DAO", "SDAO"){
1663         
1664         unrevealedURI = "ipfs://QmewxUZYZJCU3nG77U9ucD1Ph4BUCfhoBRxmyor4Rs8Y2i/";
1665     }
1666     
1667     //in case somebody accidentaly sends funds or transaction to contract
1668     receive() payable external {}
1669     fallback() payable external {
1670         revert();
1671     }
1672     
1673     //visualize baseURI
1674     function _baseURI() internal view virtual override returns (string memory) {
1675         return _currentBaseURI;
1676     }
1677     
1678     //change baseURI in case needed for IPFS
1679     function changeBaseURI(string memory baseURI_) public onlyOwner {
1680         _currentBaseURI = baseURI_;
1681     }
1682     
1683     function changeUnrevealedURI(string memory unrevealedURI_) public onlyOwner {
1684         unrevealedURI = unrevealedURI_;
1685     }
1686     
1687     //gets the tokenID of NFT to be minted
1688     /*function tokenId() internal view returns(uint256) {
1689         return numberOfTotalTokens + 1;
1690     }*/
1691     
1692     modifier onlyValidAccess(uint8 _v, bytes32 _r, bytes32 _s) {
1693         require( isValidAccessMessage(msg.sender,_v,_r,_s), 'Invalid Signature' );
1694         _;
1695     }
1696  
1697     /* 
1698     * @dev Verifies if message was signed by owner to give access to _add for this contract.
1699     *      Assumes Geth signature prefix.
1700     * @param _add Address of agent with access
1701     * @param _v ECDSA signature parameter v.
1702     * @param _r ECDSA signature parameters r.
1703     * @param _s ECDSA signature parameters s.
1704     * @return Validity of access message for a given address.
1705     */
1706     function isValidAccessMessage(address _add, uint8 _v, bytes32 _r, bytes32 _s) view public returns (bool) {
1707         bytes32 hash = keccak256(abi.encodePacked(address(this), _add));
1708         return dummy == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), _v, _r, _s);
1709     }
1710 
1711     //mint a @param number of NFTs in presale
1712     function presaleMint(uint256 number, uint maxMint, uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v,  _r, _s) public payable nonReentrant {
1713         State saleState_ = saleState();
1714         require(saleState_ != State.NoSale, "Sale in not open yet!");
1715         //require(msg.sender == tx.origin, "No transaction from smart contracts!");
1716         require(saleState_ != State.PublicSale, "Presale has closed, Check out Public Sale!");
1717         require(totalSupply() + number <= maxTotalTokens, "Not enough NFTs left to mint..");
1718         require(mintsPerAddress[msg.sender] + number <= maxMint, "Maximum Mints per Address exceeded!");
1719         require(msg.value >= mintCost() * number, "Not sufficient Ether to mint this amount of NFTs (Cost = 0.069 ether each NFT)");
1720         
1721         _safeMint(msg.sender, number);
1722         mintsPerAddress[msg.sender] += number;
1723 
1724     }
1725 
1726     //mint a @param number of NFTs in public sale
1727     function publicSaleMint(uint256 number) public payable nonReentrant {
1728         State saleState_ = saleState();
1729         require(saleState_ != State.NoSale, "Sale in not open yet!");
1730         //require(msg.sender == tx.origin, "No transaction from smart contracts!");
1731         require(saleState_ != State.Presale, "Presale has closed, Check out Public Sale!");
1732         require(totalSupply() + number <= maxTotalTokens, "Not enough NFTs left to mint..");
1733         require(number <= maxMintPerTX, "Maximum Mints per Address exceeded!");
1734         require(msg.value >= mintCost() * number, "Not sufficient Ether to mint this amount of NFTs (Cost = 0.089 ether each NFT)");
1735         
1736         _safeMint(msg.sender, number);
1737         mintsPerAddress[msg.sender] += number;
1738     }
1739     
1740     //reserved NFTs for creator
1741     function reservedMints(uint256 number, address recipient) public onlyOwner {
1742         require(_reservedMints + number <= maxReservedMints, "Not enough NFTs left to mint..");
1743         _safeMint(recipient, number);
1744         mintsPerAddress[recipient] += number;
1745     }
1746 
1747     function tokenURI(uint256 tokenId_) public view virtual override returns (string memory) {
1748         require(_exists(tokenId_), "ERC721Metadata: URI query for nonexistent token");
1749         
1750         //check to see that 24 hours have passed since beginning of publicsale launch
1751         if (revealTime == 0) {
1752             return unrevealedURI;
1753         }
1754         
1755         else {
1756             string memory baseURI = _baseURI();
1757             return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId_.toString(), '.json')) : "";
1758         }    
1759     }
1760     
1761     //begins the minting of the NFTs
1762     function switchToPresale() public onlyOwner{
1763         State saleState_ = saleState();
1764         require(saleState_ == State.NoSale, "Presale has already opened!");
1765         presaleLaunchTime = block.timestamp;
1766     }
1767     
1768     //begins the public sale
1769     function switchToPublicSale() public onlyOwner {
1770         State saleState_ = saleState();
1771         require(saleState_ != State.PublicSale, "Public Sale is already live!");
1772         require(saleState_ != State.NoSale, "Cannot change to Public Sale if there has not been a Presale!");
1773         
1774         publicSaleLaunchTime = block.timestamp;
1775     }
1776     
1777     //se the current account balance
1778     function accountBalance() public onlyOwner view returns(uint) {
1779         return address(this).balance;
1780     }
1781     
1782     //change the dummy account used for signing transactions
1783     function changeDummy(address _dummy) public onlyOwner {
1784         dummy = _dummy;
1785     }
1786     
1787     //to see the total amount of reserved mints left 
1788     function reservedMintsLeft() public onlyOwner view returns(uint) {
1789         return maxReservedMints - _reservedMints;
1790     }
1791     
1792     //get the funds from the minting of the NFTs
1793     function withdraw() public onlyOwner nonReentrant{
1794         uint256 balance = accountBalance();
1795         require(balance > 0, "No funds to retrieve!");
1796 
1797         _withdraw(payable(owner()), balance); //to avoid dust eth
1798         
1799     }
1800 
1801     function _withdraw(address payable account, uint256 amount) internal {
1802         (bool sent, ) = account.call{value: amount}("");
1803         require(sent, "Failed to send Ether");
1804     }
1805 
1806     //see the current state of the sale
1807     function saleState() public view returns(State){
1808         if (presaleLaunchTime == 0) {
1809             return State.NoSale;
1810         }
1811         else if (publicSaleLaunchTime == 0) {
1812             return State.Presale;
1813         }
1814         else {
1815             return State.PublicSale;
1816         }
1817     }
1818 
1819     //get the current price to mint
1820     function mintCost() public view returns(uint256) {
1821         State saleState_ = saleState();
1822         if (saleState_ == State.NoSale || saleState_ == State.Presale) {
1823             return mintCostPresale;
1824         }
1825         else {
1826             return mintCostPublicSale;
1827         }
1828 
1829     }
1830 
1831     //reveal the NFTs
1832     function reveal() public onlyOwner {
1833         revealTime = block.timestamp;
1834     }
1835 
1836 }