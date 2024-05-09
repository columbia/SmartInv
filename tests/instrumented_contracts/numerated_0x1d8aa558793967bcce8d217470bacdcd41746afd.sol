1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 // SPDX-Licence Identifier: MIT
4 pragma solidity ^0.8.0;
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
72 // SPDX-Licence Identifier: MIT
73 pragma solidity ^0.8.0;
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
98 // SPDX-Licence Identifier: MIT
99 pragma solidity ^0.8.0;
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
171 // SPDX-Licence Identifier: MIT
172 pragma solidity ^0.8.0;
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
389 
390 // SPDX-Licence Identifier: MIT
391 pragma solidity ^0.8.0;
392 
393 /**
394  * @title ERC721 token receiver interface
395  * @dev Interface for any contract that wants to support safeTransfers
396  * from ERC721 asset contracts.
397  */
398 interface IERC721Receiver {
399     /**
400      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
401      * by `operator` from `from`, this function is called.
402      *
403      * It must return its Solidity selector to confirm the token transfer.
404      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
405      *
406      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
407      */
408     function onERC721Received(
409         address operator,
410         address from,
411         uint256 tokenId,
412         bytes calldata data
413     ) external returns (bytes4);
414 }
415 
416 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
417 
418 
419 // SPDX-Licence Identifier: MIT
420 pragma solidity ^0.8.0;
421 
422 /**
423  * @dev Interface of the ERC165 standard, as defined in the
424  * https://eips.ethereum.org/EIPS/eip-165[EIP].
425  *
426  * Implementers can declare support of contract interfaces, which can then be
427  * queried by others ({ERC165Checker}).
428  *
429  * For an implementation, see {ERC165}.
430  */
431 interface IERC165 {
432     /**
433      * @dev Returns true if this contract implements the interface defined by
434      * `interfaceId`. See the corresponding
435      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
436      * to learn more about how these ids are created.
437      *
438      * This function call must use less than 30 000 gas.
439      */
440     function supportsInterface(bytes4 interfaceId) external view returns (bool);
441 }
442 
443 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
444 
445 
446 // SPDX-Licence Identifier: MIT
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @dev Implementation of the {IERC165} interface.
451  *
452  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
453  * for the additional interface id that will be supported. For example:
454  *
455  * ```solidity
456  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
457  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
458  * }
459  * ```
460  *
461  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
462  */
463 abstract contract ERC165 is IERC165 {
464     /**
465      * @dev See {IERC165-supportsInterface}.
466      */
467     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
468         return interfaceId == type(IERC165).interfaceId;
469     }
470 }
471 
472 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
473 
474 
475 // SPDX-Licence Identifier: MIT
476 pragma solidity ^0.8.0;
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
615 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
616 
617 // SPDX-Licence Identifier: MIT
618 
619 pragma solidity ^0.8.0;
620 
621 
622 /**
623  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
624  * @dev See https://eips.ethereum.org/EIPS/eip-721
625  */
626 interface IERC721Enumerable is IERC721 {
627     /**
628      * @dev Returns the total amount of tokens stored by the contract.
629      */
630     function totalSupply() external view returns (uint256);
631 
632     /**
633      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
634      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
635      */
636     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
637 
638     /**
639      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
640      * Use along with {totalSupply} to enumerate all tokens.
641      */
642     function tokenByIndex(uint256 index) external view returns (uint256);
643 }
644 
645 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
646 
647 
648 // SPDX-Licence Identifier: MIT
649 pragma solidity ^0.8.0;
650 
651 
652 /**
653  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
654  * @dev See https://eips.ethereum.org/EIPS/eip-721
655  */
656 interface IERC721Metadata is IERC721 {
657     /**
658      * @dev Returns the token collection name.
659      */
660     function name() external view returns (string memory);
661 
662     /**
663      * @dev Returns the token collection symbol.
664      */
665     function symbol() external view returns (string memory);
666 
667     /**
668      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
669      */
670     function tokenURI(uint256 tokenId) external view returns (string memory);
671 }
672 
673 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
674 
675 // SPDX-Licence Identifier: MIT
676 pragma solidity ^0.8.0;
677 
678 /**
679  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
680  * the Metadata extension, but not including the Enumerable extension, which is available separately as
681  * {ERC721Enumerable}.
682  */
683 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
684     using Address for address;
685     using Strings for uint256;
686 
687     // Token name
688     string private _name;
689 
690     // Token symbol
691     string private _symbol;
692 
693     // Mapping from token ID to owner address
694     mapping(uint256 => address) private _owners;
695 
696     // Mapping owner address to token count
697     mapping(address => uint256) private _balances;
698 
699     // Mapping from token ID to approved address
700     mapping(uint256 => address) private _tokenApprovals;
701 
702     // Mapping from owner to operator approvals
703     mapping(address => mapping(address => bool)) private _operatorApprovals;
704 
705     /**
706      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
707      */
708     constructor(string memory name_, string memory symbol_) {
709         _name = name_;
710         _symbol = symbol_;
711     }
712 
713     /**
714      * @dev See {IERC165-supportsInterface}.
715      */
716     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
717         return
718             interfaceId == type(IERC721).interfaceId ||
719             interfaceId == type(IERC721Metadata).interfaceId ||
720             super.supportsInterface(interfaceId);
721     }
722 
723     /**
724      * @dev See {IERC721-balanceOf}.
725      */
726     function balanceOf(address owner) public view virtual override returns (uint256) {
727         require(owner != address(0), "ERC721: balance query for the zero address");
728         return _balances[owner];
729     }
730 
731     /**
732      * @dev See {IERC721-ownerOf}.
733      */
734     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
735         address owner = _owners[tokenId];
736         require(owner != address(0), "ERC721: owner query for nonexistent token");
737         return owner;
738     }
739 
740     /**
741      * @dev See {IERC721Metadata-name}.
742      */
743     function name() public view virtual override returns (string memory) {
744         return _name;
745     }
746 
747     /**
748      * @dev See {IERC721Metadata-symbol}.
749      */
750     function symbol() public view virtual override returns (string memory) {
751         return _symbol;
752     }
753 
754     /**
755      * @dev See {IERC721Metadata-tokenURI}.
756      */
757     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
758         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
759 
760         string memory baseURI = _baseURI();
761         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
762     }
763 
764     /**
765      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
766      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
767      * by default, can be overriden in child contracts.
768      */
769     function _baseURI() internal view virtual returns (string memory) {
770         return "";
771     }
772 
773     /**
774      * @dev See {IERC721-approve}.
775      */
776     function approve(address to, uint256 tokenId) public virtual override {
777         address owner = ERC721.ownerOf(tokenId);
778         require(to != owner, "ERC721: approval to current owner");
779 
780         require(
781             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
782             "ERC721: approve caller is not owner nor approved for all"
783         );
784 
785         _approve(to, tokenId);
786     }
787 
788     /**
789      * @dev See {IERC721-getApproved}.
790      */
791     function getApproved(uint256 tokenId) public view virtual override returns (address) {
792         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
793 
794         return _tokenApprovals[tokenId];
795     }
796 
797     /**
798      * @dev See {IERC721-setApprovalForAll}.
799      */
800     function setApprovalForAll(address operator, bool approved) public virtual override {
801         require(operator != _msgSender(), "ERC721: approve to caller");
802 
803         _operatorApprovals[_msgSender()][operator] = approved;
804         emit ApprovalForAll(_msgSender(), operator, approved);
805     }
806 
807     /**
808      * @dev See {IERC721-isApprovedForAll}.
809      */
810     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
811         return _operatorApprovals[owner][operator];
812     }
813 
814     /**
815      * @dev See {IERC721-transferFrom}.
816      */
817     function transferFrom(
818         address from,
819         address to,
820         uint256 tokenId
821     ) public virtual override {
822         //solhint-disable-next-line max-line-length
823         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
824 
825         _transfer(from, to, tokenId);
826     }
827 
828     /**
829      * @dev See {IERC721-safeTransferFrom}.
830      */
831     function safeTransferFrom(
832         address from,
833         address to,
834         uint256 tokenId
835     ) public virtual override {
836         safeTransferFrom(from, to, tokenId, "");
837     }
838 
839     /**
840      * @dev See {IERC721-safeTransferFrom}.
841      */
842     function safeTransferFrom(
843         address from,
844         address to,
845         uint256 tokenId,
846         bytes memory _data
847     ) public virtual override {
848         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
849         _safeTransfer(from, to, tokenId, _data);
850     }
851 
852     /**
853      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
854      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
855      *
856      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
857      *
858      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
859      * implement alternative mechanisms to perform token transfer, such as signature-based.
860      *
861      * Requirements:
862      *
863      * - `from` cannot be the zero address.
864      * - `to` cannot be the zero address.
865      * - `tokenId` token must exist and be owned by `from`.
866      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
867      *
868      * Emits a {Transfer} event.
869      */
870     function _safeTransfer(
871         address from,
872         address to,
873         uint256 tokenId,
874         bytes memory _data
875     ) internal virtual {
876         _transfer(from, to, tokenId);
877         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
878     }
879 
880     /**
881      * @dev Returns whether `tokenId` exists.
882      *
883      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
884      *
885      * Tokens start existing when they are minted (`_mint`),
886      * and stop existing when they are burned (`_burn`).
887      */
888     function _exists(uint256 tokenId) internal view virtual returns (bool) {
889         return _owners[tokenId] != address(0);
890     }
891 
892     /**
893      * @dev Returns whether `spender` is allowed to manage `tokenId`.
894      *
895      * Requirements:
896      *
897      * - `tokenId` must exist.
898      */
899     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
900         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
901         address owner = ERC721.ownerOf(tokenId);
902         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
903     }
904 
905     /**
906      * @dev Safely mints `tokenId` and transfers it to `to`.
907      *
908      * Requirements:
909      *
910      * - `tokenId` must not exist.
911      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
912      *
913      * Emits a {Transfer} event.
914      */
915     function _safeMint(address to, uint256 tokenId) internal virtual {
916         _safeMint(to, tokenId, "");
917     }
918 
919     /**
920      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
921      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
922      */
923     function _safeMint(
924         address to,
925         uint256 tokenId,
926         bytes memory _data
927     ) internal virtual {
928         _mint(to, tokenId);
929         require(
930             _checkOnERC721Received(address(0), to, tokenId, _data),
931             "ERC721: transfer to non ERC721Receiver implementer"
932         );
933     }
934 
935     /**
936      * @dev Mints `tokenId` and transfers it to `to`.
937      *
938      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
939      *
940      * Requirements:
941      *
942      * - `tokenId` must not exist.
943      * - `to` cannot be the zero address.
944      *
945      * Emits a {Transfer} event.
946      */
947     function _mint(address to, uint256 tokenId) internal virtual {
948         require(to != address(0), "ERC721: mint to the zero address");
949         require(!_exists(tokenId), "ERC721: token already minted");
950 
951         _beforeTokenTransfer(address(0), to, tokenId);
952 
953         _balances[to] += 1;
954         _owners[tokenId] = to;
955 
956         emit Transfer(address(0), to, tokenId);
957     }
958 
959     /**
960      * @dev Destroys `tokenId`.
961      * The approval is cleared when the token is burned.
962      *
963      * Requirements:
964      *
965      * - `tokenId` must exist.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _burn(uint256 tokenId) internal virtual {
970         address owner = ERC721.ownerOf(tokenId);
971 
972         _beforeTokenTransfer(owner, address(0), tokenId);
973 
974         // Clear approvals
975         _approve(address(0), tokenId);
976 
977         _balances[owner] -= 1;
978         delete _owners[tokenId];
979 
980         emit Transfer(owner, address(0), tokenId);
981     }
982 
983     /**
984      * @dev Transfers `tokenId` from `from` to `to`.
985      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
986      *
987      * Requirements:
988      *
989      * - `to` cannot be the zero address.
990      * - `tokenId` token must be owned by `from`.
991      *
992      * Emits a {Transfer} event.
993      */
994     function _transfer(
995         address from,
996         address to,
997         uint256 tokenId
998     ) internal virtual {
999         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1000         require(to != address(0), "ERC721: transfer to the zero address");
1001 
1002         _beforeTokenTransfer(from, to, tokenId);
1003 
1004         // Clear approvals from the previous owner
1005         _approve(address(0), tokenId);
1006 
1007         _balances[from] -= 1;
1008         _balances[to] += 1;
1009         _owners[tokenId] = to;
1010 
1011         emit Transfer(from, to, tokenId);
1012     }
1013 
1014     /**
1015      * @dev Approve `to` to operate on `tokenId`
1016      *
1017      * Emits a {Approval} event.
1018      */
1019     function _approve(address to, uint256 tokenId) internal virtual {
1020         _tokenApprovals[tokenId] = to;
1021         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1026      * The call is not executed if the target address is not a contract.
1027      *
1028      * @param from address representing the previous owner of the given token ID
1029      * @param to target address that will receive the tokens
1030      * @param tokenId uint256 ID of the token to be transferred
1031      * @param _data bytes optional data to send along with the call
1032      * @return bool whether the call correctly returned the expected magic value
1033      */
1034     function _checkOnERC721Received(
1035         address from,
1036         address to,
1037         uint256 tokenId,
1038         bytes memory _data
1039     ) private returns (bool) {
1040         if (to.isContract()) {
1041             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1042                 return retval == IERC721Receiver.onERC721Received.selector;
1043             } catch (bytes memory reason) {
1044                 if (reason.length == 0) {
1045                     revert("ERC721: transfer to non ERC721Receiver implementer");
1046                 } else {
1047                     assembly {
1048                         revert(add(32, reason), mload(reason))
1049                     }
1050                 }
1051             }
1052         } else {
1053             return true;
1054         }
1055     }
1056 
1057     /**
1058      * @dev Hook that is called before any token transfer. This includes minting
1059      * and burning.
1060      *
1061      * Calling conditions:
1062      *
1063      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1064      * transferred to `to`.
1065      * - When `from` is zero, `tokenId` will be minted for `to`.
1066      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1067      * - `from` and `to` are never both zero.
1068      *
1069      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1070      */
1071     function _beforeTokenTransfer(
1072         address from,
1073         address to,
1074         uint256 tokenId
1075     ) internal virtual {}
1076 }
1077 
1078 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1079 
1080 
1081 // SPDX-Licence Identifier: MIT
1082 pragma solidity ^0.8.0;
1083 
1084 
1085 
1086 /**
1087  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1088  * enumerability of all the token ids in the contract as well as all token ids owned by each
1089  * account.
1090  */
1091 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1092     // Mapping from owner to list of owned token IDs
1093     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1094 
1095     // Mapping from token ID to index of the owner tokens list
1096     mapping(uint256 => uint256) private _ownedTokensIndex;
1097 
1098     // Array with all token ids, used for enumeration
1099     uint256[] private _allTokens;
1100 
1101     // Mapping from token id to position in the allTokens array
1102     mapping(uint256 => uint256) private _allTokensIndex;
1103 
1104     /**
1105      * @dev See {IERC165-supportsInterface}.
1106      */
1107     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1108         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1109     }
1110 
1111     /**
1112      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1113      */
1114     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1115         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1116         return _ownedTokens[owner][index];
1117     }
1118 
1119     /**
1120      * @dev See {IERC721Enumerable-totalSupply}.
1121      */
1122     function totalSupply() public view virtual override returns (uint256) {
1123         return _allTokens.length;
1124     }
1125 
1126     /**
1127      * @dev See {IERC721Enumerable-tokenByIndex}.
1128      */
1129     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1130         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1131         return _allTokens[index];
1132     }
1133 
1134     /**
1135      * @dev Hook that is called before any token transfer. This includes minting
1136      * and burning.
1137      *
1138      * Calling conditions:
1139      *
1140      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1141      * transferred to `to`.
1142      * - When `from` is zero, `tokenId` will be minted for `to`.
1143      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1144      * - `from` cannot be the zero address.
1145      * - `to` cannot be the zero address.
1146      *
1147      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1148      */
1149     function _beforeTokenTransfer(
1150         address from,
1151         address to,
1152         uint256 tokenId
1153     ) internal virtual override {
1154         super._beforeTokenTransfer(from, to, tokenId);
1155 
1156         if (from == address(0)) {
1157             _addTokenToAllTokensEnumeration(tokenId);
1158         } else if (from != to) {
1159             _removeTokenFromOwnerEnumeration(from, tokenId);
1160         }
1161         if (to == address(0)) {
1162             _removeTokenFromAllTokensEnumeration(tokenId);
1163         } else if (to != from) {
1164             _addTokenToOwnerEnumeration(to, tokenId);
1165         }
1166     }
1167 
1168     /**
1169      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1170      * @param to address representing the new owner of the given token ID
1171      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1172      */
1173     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1174         uint256 length = ERC721.balanceOf(to);
1175         _ownedTokens[to][length] = tokenId;
1176         _ownedTokensIndex[tokenId] = length;
1177     }
1178 
1179     /**
1180      * @dev Private function to add a token to this extension's token tracking data structures.
1181      * @param tokenId uint256 ID of the token to be added to the tokens list
1182      */
1183     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1184         _allTokensIndex[tokenId] = _allTokens.length;
1185         _allTokens.push(tokenId);
1186     }
1187 
1188     /**
1189      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1190      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1191      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1192      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1193      * @param from address representing the previous owner of the given token ID
1194      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1195      */
1196     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1197         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1198         // then delete the last slot (swap and pop).
1199 
1200         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1201         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1202 
1203         // When the token to delete is the last token, the swap operation is unnecessary
1204         if (tokenIndex != lastTokenIndex) {
1205             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1206 
1207             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1208             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1209         }
1210 
1211         // This also deletes the contents at the last position of the array
1212         delete _ownedTokensIndex[tokenId];
1213         delete _ownedTokens[from][lastTokenIndex];
1214     }
1215 
1216     /**
1217      * @dev Private function to remove a token from this extension's token tracking data structures.
1218      * This has O(1) time complexity, but alters the order of the _allTokens array.
1219      * @param tokenId uint256 ID of the token to be removed from the tokens list
1220      */
1221     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1222         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1223         // then delete the last slot (swap and pop).
1224 
1225         uint256 lastTokenIndex = _allTokens.length - 1;
1226         uint256 tokenIndex = _allTokensIndex[tokenId];
1227 
1228         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1229         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1230         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1231         uint256 lastTokenId = _allTokens[lastTokenIndex];
1232 
1233         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1234         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1235 
1236         // This also deletes the contents at the last position of the array
1237         delete _allTokensIndex[tokenId];
1238         _allTokens.pop();
1239     }
1240 }
1241 
1242 // File: contracts/NFT.sol
1243 
1244 
1245 // SPDX-Licence Identifier: MIT
1246 pragma solidity ^0.8.0;
1247 
1248 
1249 
1250 contract NFT is ERC721Enumerable, Ownable {
1251   using Strings for uint256;
1252 
1253   string public baseURI;
1254   string public baseExtension = ".json";
1255   uint256 public cost = 0.029 ether;
1256   uint256 public maxSupply = 4951;
1257   uint256 public maxMintAmount = 5;
1258   bool public paused = false;
1259 
1260   constructor(
1261     string memory _name,
1262     string memory _symbol,
1263     string memory _initBaseURI
1264   ) ERC721(_name, _symbol) {
1265     setBaseURI(_initBaseURI);
1266 
1267   	/*
1268   	uncomment below line if you want to mint nfts while 
1269   	deploying change number 1 to any you like
1270     */
1271     //mint(msg.sender, 1)
1272   }
1273   /* 
1274   internal baseURI function
1275   */
1276   function _baseURI() internal view virtual override returns (string memory) {
1277     return baseURI;
1278   }
1279 
1280   /*
1281   mint function to mint no of tokens
1282   */
1283   function mint(address _to, uint256 _mintAmount) public payable {
1284     uint256 supply = totalSupply();
1285     require(!paused);
1286     require(_mintAmount > 0);
1287     require(_mintAmount <= maxMintAmount);
1288     if (msg.sender != owner()) {
1289         require(msg.value >= cost * _mintAmount);
1290 
1291         /*set max supply to 4700 for users*/
1292         require(supply + _mintAmount <= 4700);  
1293     } else {
1294       
1295         /* it set 4951 limit for owner */
1296         require(supply + _mintAmount <= maxSupply);
1297     }
1298 
1299     // for minting the NFTs 
1300     for (uint256 i = 1; i <= _mintAmount; i++) {
1301       _safeMint(_to, supply + i);
1302     }
1303   }
1304 
1305 
1306   function walletOfOwner(address _owner)
1307     public
1308     view
1309     returns (uint256[] memory)
1310   {
1311     uint256 ownerTokenCount = balanceOf(_owner);
1312     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1313     for (uint256 i; i < ownerTokenCount; i++) {
1314       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1315     }
1316     return tokenIds;
1317   }
1318 
1319   /*
1320   returns the uri of nft
1321   */
1322   function tokenURI(uint256 tokenId)
1323     public
1324     view
1325     virtual
1326     override
1327     returns (string memory)
1328   {
1329     require(
1330       _exists(tokenId),
1331       "ERC721Metadata: URI query for nonexistent token"
1332     );
1333 
1334     string memory currentBaseURI = _baseURI();
1335     return bytes(currentBaseURI).length > 0
1336         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1337         : "";
1338   }
1339 
1340   /* 
1341   only owner 
1342   */
1343   function setCost(uint256 _newCost) public onlyOwner {
1344     cost = _newCost;
1345   }
1346 
1347   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1348     maxMintAmount = _newmaxMintAmount;
1349   }
1350 
1351   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1352     baseURI = _newBaseURI;
1353   }
1354 
1355   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1356     baseExtension = _newBaseExtension;
1357   }
1358 
1359   function pause(bool _state) public onlyOwner {
1360     paused = _state;
1361   }
1362  
1363   function withdraw() public payable onlyOwner {
1364     /* 
1365     This will payout the owner of the contract balance.
1366     Do not remove this otherwise you will not be able to withdraw the funds.
1367  	*/
1368     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1369     require(os);
1370   }
1371 }