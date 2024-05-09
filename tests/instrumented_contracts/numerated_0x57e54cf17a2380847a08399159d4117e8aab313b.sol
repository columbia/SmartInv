1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
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
72 
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
98 
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
171 
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
390 
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
419 
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
446 
447 pragma solidity ^0.8.0;
448 
449 
450 /**
451  * @dev Implementation of the {IERC165} interface.
452  *
453  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
454  * for the additional interface id that will be supported. For example:
455  *
456  * ```solidity
457  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
458  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
459  * }
460  * ```
461  *
462  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
463  */
464 abstract contract ERC165 is IERC165 {
465     /**
466      * @dev See {IERC165-supportsInterface}.
467      */
468     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
469         return interfaceId == type(IERC165).interfaceId;
470     }
471 }
472 
473 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
474 
475 
476 
477 pragma solidity ^0.8.0;
478 
479 
480 /**
481  * @dev Required interface of an ERC721 compliant contract.
482  */
483 interface IERC721 is IERC165 {
484     /**
485      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
486      */
487     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
488 
489     /**
490      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
491      */
492     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
493 
494     /**
495      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
496      */
497     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
498 
499     /**
500      * @dev Returns the number of tokens in ``owner``'s account.
501      */
502     function balanceOf(address owner) external view returns (uint256 balance);
503 
504     /**
505      * @dev Returns the owner of the `tokenId` token.
506      *
507      * Requirements:
508      *
509      * - `tokenId` must exist.
510      */
511     function ownerOf(uint256 tokenId) external view returns (address owner);
512 
513     /**
514      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
515      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
516      *
517      * Requirements:
518      *
519      * - `from` cannot be the zero address.
520      * - `to` cannot be the zero address.
521      * - `tokenId` token must exist and be owned by `from`.
522      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
523      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
524      *
525      * Emits a {Transfer} event.
526      */
527     function safeTransferFrom(
528         address from,
529         address to,
530         uint256 tokenId
531     ) external;
532 
533     /**
534      * @dev Transfers `tokenId` token from `from` to `to`.
535      *
536      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
537      *
538      * Requirements:
539      *
540      * - `from` cannot be the zero address.
541      * - `to` cannot be the zero address.
542      * - `tokenId` token must be owned by `from`.
543      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
544      *
545      * Emits a {Transfer} event.
546      */
547     function transferFrom(
548         address from,
549         address to,
550         uint256 tokenId
551     ) external;
552 
553     /**
554      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
555      * The approval is cleared when the token is transferred.
556      *
557      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
558      *
559      * Requirements:
560      *
561      * - The caller must own the token or be an approved operator.
562      * - `tokenId` must exist.
563      *
564      * Emits an {Approval} event.
565      */
566     function approve(address to, uint256 tokenId) external;
567 
568     /**
569      * @dev Returns the account approved for `tokenId` token.
570      *
571      * Requirements:
572      *
573      * - `tokenId` must exist.
574      */
575     function getApproved(uint256 tokenId) external view returns (address operator);
576 
577     /**
578      * @dev Approve or remove `operator` as an operator for the caller.
579      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
580      *
581      * Requirements:
582      *
583      * - The `operator` cannot be the caller.
584      *
585      * Emits an {ApprovalForAll} event.
586      */
587     function setApprovalForAll(address operator, bool _approved) external;
588 
589     /**
590      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
591      *
592      * See {setApprovalForAll}
593      */
594     function isApprovedForAll(address owner, address operator) external view returns (bool);
595 
596     /**
597      * @dev Safely transfers `tokenId` token from `from` to `to`.
598      *
599      * Requirements:
600      *
601      * - `from` cannot be the zero address.
602      * - `to` cannot be the zero address.
603      * - `tokenId` token must exist and be owned by `from`.
604      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
605      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
606      *
607      * Emits a {Transfer} event.
608      */
609     function safeTransferFrom(
610         address from,
611         address to,
612         uint256 tokenId,
613         bytes calldata data
614     ) external;
615 }
616 
617 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
618 
619 
620 
621 pragma solidity ^0.8.0;
622 
623 
624 /**
625  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
626  * @dev See https://eips.ethereum.org/EIPS/eip-721
627  */
628 interface IERC721Enumerable is IERC721 {
629     /**
630      * @dev Returns the total amount of tokens stored by the contract.
631      */
632     function totalSupply() external view returns (uint256);
633 
634     /**
635      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
636      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
637      */
638     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
639 
640     /**
641      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
642      * Use along with {totalSupply} to enumerate all tokens.
643      */
644     function tokenByIndex(uint256 index) external view returns (uint256);
645 }
646 
647 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
648 
649 
650 
651 pragma solidity ^0.8.0;
652 
653 
654 /**
655  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
656  * @dev See https://eips.ethereum.org/EIPS/eip-721
657  */
658 interface IERC721Metadata is IERC721 {
659     /**
660      * @dev Returns the token collection name.
661      */
662     function name() external view returns (string memory);
663 
664     /**
665      * @dev Returns the token collection symbol.
666      */
667     function symbol() external view returns (string memory);
668 
669     /**
670      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
671      */
672     function tokenURI(uint256 tokenId) external view returns (string memory);
673 }
674 
675 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
676 
677 
678 
679 pragma solidity ^0.8.0;
680 
681 
682 
683 
684 
685 
686 
687 
688 /**
689  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
690  * the Metadata extension, but not including the Enumerable extension, which is available separately as
691  * {ERC721Enumerable}.
692  */
693 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
694     using Address for address;
695     using Strings for uint256;
696 
697     // Token name
698     string private _name;
699 
700     // Token symbol
701     string private _symbol;
702 
703     // Mapping from token ID to owner address
704     mapping(uint256 => address) private _owners;
705 
706     // Mapping owner address to token count
707     mapping(address => uint256) private _balances;
708 
709     // Mapping from token ID to approved address
710     mapping(uint256 => address) private _tokenApprovals;
711 
712     // Mapping from owner to operator approvals
713     mapping(address => mapping(address => bool)) private _operatorApprovals;
714 
715     /**
716      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
717      */
718     constructor(string memory name_, string memory symbol_) {
719         _name = name_;
720         _symbol = symbol_;
721     }
722 
723     /**
724      * @dev See {IERC165-supportsInterface}.
725      */
726     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
727         return
728             interfaceId == type(IERC721).interfaceId ||
729             interfaceId == type(IERC721Metadata).interfaceId ||
730             super.supportsInterface(interfaceId);
731     }
732 
733     /**
734      * @dev See {IERC721-balanceOf}.
735      */
736     function balanceOf(address owner) public view virtual override returns (uint256) {
737         require(owner != address(0), "ERC721: balance query for the zero address");
738         return _balances[owner];
739     }
740 
741     /**
742      * @dev See {IERC721-ownerOf}.
743      */
744     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
745         address owner = _owners[tokenId];
746         require(owner != address(0), "ERC721: owner query for nonexistent token");
747         return owner;
748     }
749 
750     /**
751      * @dev See {IERC721Metadata-name}.
752      */
753     function name() public view virtual override returns (string memory) {
754         return _name;
755     }
756 
757     /**
758      * @dev See {IERC721Metadata-symbol}.
759      */
760     function symbol() public view virtual override returns (string memory) {
761         return _symbol;
762     }
763 
764     /**
765      * @dev See {IERC721Metadata-tokenURI}.
766      */
767     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
768         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
769 
770         string memory baseURI = _baseURI();
771         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
772     }
773 
774     /**
775      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
776      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
777      * by default, can be overriden in child contracts.
778      */
779     function _baseURI() internal view virtual returns (string memory) {
780         return "";
781     }
782 
783     /**
784      * @dev See {IERC721-approve}.
785      */
786     function approve(address to, uint256 tokenId) public virtual override {
787         address owner = ERC721.ownerOf(tokenId);
788         require(to != owner, "ERC721: approval to current owner");
789 
790         require(
791             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
792             "ERC721: approve caller is not owner nor approved for all"
793         );
794 
795         _approve(to, tokenId);
796     }
797 
798     /**
799      * @dev See {IERC721-getApproved}.
800      */
801     function getApproved(uint256 tokenId) public view virtual override returns (address) {
802         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
803 
804         return _tokenApprovals[tokenId];
805     }
806 
807     /**
808      * @dev See {IERC721-setApprovalForAll}.
809      */
810     function setApprovalForAll(address operator, bool approved) public virtual override {
811         require(operator != _msgSender(), "ERC721: approve to caller");
812 
813         _operatorApprovals[_msgSender()][operator] = approved;
814         emit ApprovalForAll(_msgSender(), operator, approved);
815     }
816 
817     /**
818      * @dev See {IERC721-isApprovedForAll}.
819      */
820     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
821         return _operatorApprovals[owner][operator];
822     }
823 
824     /**
825      * @dev See {IERC721-transferFrom}.
826      */
827     function transferFrom(
828         address from,
829         address to,
830         uint256 tokenId
831     ) public virtual override {
832         //solhint-disable-next-line max-line-length
833         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
834 
835         _transfer(from, to, tokenId);
836     }
837 
838     /**
839      * @dev See {IERC721-safeTransferFrom}.
840      */
841     function safeTransferFrom(
842         address from,
843         address to,
844         uint256 tokenId
845     ) public virtual override {
846         safeTransferFrom(from, to, tokenId, "");
847     }
848 
849     /**
850      * @dev See {IERC721-safeTransferFrom}.
851      */
852     function safeTransferFrom(
853         address from,
854         address to,
855         uint256 tokenId,
856         bytes memory _data
857     ) public virtual override {
858         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
859         _safeTransfer(from, to, tokenId, _data);
860     }
861 
862     /**
863      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
864      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
865      *
866      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
867      *
868      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
869      * implement alternative mechanisms to perform token transfer, such as signature-based.
870      *
871      * Requirements:
872      *
873      * - `from` cannot be the zero address.
874      * - `to` cannot be the zero address.
875      * - `tokenId` token must exist and be owned by `from`.
876      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
877      *
878      * Emits a {Transfer} event.
879      */
880     function _safeTransfer(
881         address from,
882         address to,
883         uint256 tokenId,
884         bytes memory _data
885     ) internal virtual {
886         _transfer(from, to, tokenId);
887         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
888     }
889 
890     /**
891      * @dev Returns whether `tokenId` exists.
892      *
893      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
894      *
895      * Tokens start existing when they are minted (`_mint`),
896      * and stop existing when they are burned (`_burn`).
897      */
898     function _exists(uint256 tokenId) internal view virtual returns (bool) {
899         return _owners[tokenId] != address(0);
900     }
901 
902     /**
903      * @dev Returns whether `spender` is allowed to manage `tokenId`.
904      *
905      * Requirements:
906      *
907      * - `tokenId` must exist.
908      */
909     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
910         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
911         address owner = ERC721.ownerOf(tokenId);
912         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
913     }
914 
915     /**
916      * @dev Safely mints `tokenId` and transfers it to `to`.
917      *
918      * Requirements:
919      *
920      * - `tokenId` must not exist.
921      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
922      *
923      * Emits a {Transfer} event.
924      */
925     function _safeMint(address to, uint256 tokenId) internal virtual {
926         _safeMint(to, tokenId, "");
927     }
928 
929     /**
930      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
931      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
932      */
933     function _safeMint(
934         address to,
935         uint256 tokenId,
936         bytes memory _data
937     ) internal virtual {
938         _mint(to, tokenId);
939         require(
940             _checkOnERC721Received(address(0), to, tokenId, _data),
941             "ERC721: transfer to non ERC721Receiver implementer"
942         );
943     }
944 
945     /**
946      * @dev Mints `tokenId` and transfers it to `to`.
947      *
948      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
949      *
950      * Requirements:
951      *
952      * - `tokenId` must not exist.
953      * - `to` cannot be the zero address.
954      *
955      * Emits a {Transfer} event.
956      */
957     function _mint(address to, uint256 tokenId) internal virtual {
958         require(to != address(0), "ERC721: mint to the zero address");
959         require(!_exists(tokenId), "ERC721: token already minted");
960 
961         _beforeTokenTransfer(address(0), to, tokenId);
962 
963         _balances[to] += 1;
964         _owners[tokenId] = to;
965 
966         emit Transfer(address(0), to, tokenId);
967     }
968 
969     /**
970      * @dev Destroys `tokenId`.
971      * The approval is cleared when the token is burned.
972      *
973      * Requirements:
974      *
975      * - `tokenId` must exist.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _burn(uint256 tokenId) internal virtual {
980         address owner = ERC721.ownerOf(tokenId);
981 
982         _beforeTokenTransfer(owner, address(0), tokenId);
983 
984         // Clear approvals
985         _approve(address(0), tokenId);
986 
987         _balances[owner] -= 1;
988         delete _owners[tokenId];
989 
990         emit Transfer(owner, address(0), tokenId);
991     }
992 
993     /**
994      * @dev Transfers `tokenId` from `from` to `to`.
995      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
996      *
997      * Requirements:
998      *
999      * - `to` cannot be the zero address.
1000      * - `tokenId` token must be owned by `from`.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _transfer(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) internal virtual {
1009         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1010         require(to != address(0), "ERC721: transfer to the zero address");
1011 
1012         _beforeTokenTransfer(from, to, tokenId);
1013 
1014         // Clear approvals from the previous owner
1015         _approve(address(0), tokenId);
1016 
1017         _balances[from] -= 1;
1018         _balances[to] += 1;
1019         _owners[tokenId] = to;
1020 
1021         emit Transfer(from, to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev Approve `to` to operate on `tokenId`
1026      *
1027      * Emits a {Approval} event.
1028      */
1029     function _approve(address to, uint256 tokenId) internal virtual {
1030         _tokenApprovals[tokenId] = to;
1031         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1032     }
1033 
1034     /**
1035      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1036      * The call is not executed if the target address is not a contract.
1037      *
1038      * @param from address representing the previous owner of the given token ID
1039      * @param to target address that will receive the tokens
1040      * @param tokenId uint256 ID of the token to be transferred
1041      * @param _data bytes optional data to send along with the call
1042      * @return bool whether the call correctly returned the expected magic value
1043      */
1044     function _checkOnERC721Received(
1045         address from,
1046         address to,
1047         uint256 tokenId,
1048         bytes memory _data
1049     ) private returns (bool) {
1050         if (to.isContract()) {
1051             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1052                 return retval == IERC721Receiver.onERC721Received.selector;
1053             } catch (bytes memory reason) {
1054                 if (reason.length == 0) {
1055                     revert("ERC721: transfer to non ERC721Receiver implementer");
1056                 } else {
1057                     assembly {
1058                         revert(add(32, reason), mload(reason))
1059                     }
1060                 }
1061             }
1062         } else {
1063             return true;
1064         }
1065     }
1066 
1067     /**
1068      * @dev Hook that is called before any token transfer. This includes minting
1069      * and burning.
1070      *
1071      * Calling conditions:
1072      *
1073      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1074      * transferred to `to`.
1075      * - When `from` is zero, `tokenId` will be minted for `to`.
1076      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1077      * - `from` and `to` are never both zero.
1078      *
1079      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1080      */
1081     function _beforeTokenTransfer(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) internal virtual {}
1086 }
1087 
1088 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1089 
1090 
1091 
1092 pragma solidity ^0.8.0;
1093 
1094 
1095 
1096 /**
1097  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1098  * enumerability of all the token ids in the contract as well as all token ids owned by each
1099  * account.
1100  */
1101 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1102     // Mapping from owner to list of owned token IDs
1103     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1104 
1105     // Mapping from token ID to index of the owner tokens list
1106     mapping(uint256 => uint256) private _ownedTokensIndex;
1107 
1108     // Array with all token ids, used for enumeration
1109     uint256[] private _allTokens;
1110 
1111     // Mapping from token id to position in the allTokens array
1112     mapping(uint256 => uint256) private _allTokensIndex;
1113 
1114     /**
1115      * @dev See {IERC165-supportsInterface}.
1116      */
1117     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1118         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1119     }
1120 
1121     /**
1122      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1123      */
1124     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1125         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1126         return _ownedTokens[owner][index];
1127     }
1128 
1129     /**
1130      * @dev See {IERC721Enumerable-totalSupply}.
1131      */
1132     function totalSupply() public view virtual override returns (uint256) {
1133         return _allTokens.length;
1134     }
1135 
1136     /**
1137      * @dev See {IERC721Enumerable-tokenByIndex}.
1138      */
1139     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1140         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1141         return _allTokens[index];
1142     }
1143 
1144     /**
1145      * @dev Hook that is called before any token transfer. This includes minting
1146      * and burning.
1147      *
1148      * Calling conditions:
1149      *
1150      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1151      * transferred to `to`.
1152      * - When `from` is zero, `tokenId` will be minted for `to`.
1153      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1154      * - `from` cannot be the zero address.
1155      * - `to` cannot be the zero address.
1156      *
1157      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1158      */
1159     function _beforeTokenTransfer(
1160         address from,
1161         address to,
1162         uint256 tokenId
1163     ) internal virtual override {
1164         super._beforeTokenTransfer(from, to, tokenId);
1165 
1166         if (from == address(0)) {
1167             _addTokenToAllTokensEnumeration(tokenId);
1168         } else if (from != to) {
1169             _removeTokenFromOwnerEnumeration(from, tokenId);
1170         }
1171         if (to == address(0)) {
1172             _removeTokenFromAllTokensEnumeration(tokenId);
1173         } else if (to != from) {
1174             _addTokenToOwnerEnumeration(to, tokenId);
1175         }
1176     }
1177 
1178     /**
1179      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1180      * @param to address representing the new owner of the given token ID
1181      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1182      */
1183     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1184         uint256 length = ERC721.balanceOf(to);
1185         _ownedTokens[to][length] = tokenId;
1186         _ownedTokensIndex[tokenId] = length;
1187     }
1188 
1189     /**
1190      * @dev Private function to add a token to this extension's token tracking data structures.
1191      * @param tokenId uint256 ID of the token to be added to the tokens list
1192      */
1193     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1194         _allTokensIndex[tokenId] = _allTokens.length;
1195         _allTokens.push(tokenId);
1196     }
1197 
1198     /**
1199      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1200      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1201      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1202      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1203      * @param from address representing the previous owner of the given token ID
1204      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1205      */
1206     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1207         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1208         // then delete the last slot (swap and pop).
1209 
1210         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1211         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1212 
1213         // When the token to delete is the last token, the swap operation is unnecessary
1214         if (tokenIndex != lastTokenIndex) {
1215             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1216 
1217             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1218             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1219         }
1220 
1221         // This also deletes the contents at the last position of the array
1222         delete _ownedTokensIndex[tokenId];
1223         delete _ownedTokens[from][lastTokenIndex];
1224     }
1225 
1226     /**
1227      * @dev Private function to remove a token from this extension's token tracking data structures.
1228      * This has O(1) time complexity, but alters the order of the _allTokens array.
1229      * @param tokenId uint256 ID of the token to be removed from the tokens list
1230      */
1231     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1232         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1233         // then delete the last slot (swap and pop).
1234 
1235         uint256 lastTokenIndex = _allTokens.length - 1;
1236         uint256 tokenIndex = _allTokensIndex[tokenId];
1237 
1238         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1239         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1240         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1241         uint256 lastTokenId = _allTokens[lastTokenIndex];
1242 
1243         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1244         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1245 
1246         // This also deletes the contents at the last position of the array
1247         delete _allTokensIndex[tokenId];
1248         _allTokens.pop();
1249     }
1250 }
1251 
1252 // File: contracts/PogPunks.sol
1253 
1254 
1255 
1256 pragma solidity ^0.8.0;
1257 
1258 
1259 
1260 contract PogPunks is ERC721Enumerable, Ownable {
1261   using Strings for uint256;
1262   string public baseURI;
1263   string public baseExtension = ".json";
1264   uint256 public cost = .065 ether;
1265   uint256 public maxSupply = 3500;
1266   uint256 public maxMintAmount = 10;
1267   uint256 public privateMaxMint = 5;
1268   bool public paused = false;
1269 
1270   mapping(address => uint) public minted;
1271 
1272   uint public startDate = 1636979400;
1273   uint public privateDate = 1636725201;
1274 
1275   constructor() ERC721("CryptoPugs", "CPUGS") {
1276       
1277     setBaseURI("https://gateway.pinata.cloud/ipfs/QmSxXtEEdhdMcX2VCzNNhsdq7cfV4M8EnEwbFKcwQxLUiE/");
1278     
1279     for (uint i = 0; i < 50; i++) {
1280       _safeMint(0xDc1AAf2CB6080743786A8475dFaD461Fa523760c, totalSupply()+1);
1281     }
1282     
1283     transferOwnership(0xD2898C5927eDC339B1E3a1771f0070032fd53E83);
1284 
1285   }
1286 
1287   // internal
1288   function _baseURI() internal view virtual override returns (string memory) {
1289     return baseURI;
1290   }
1291 
1292   // public
1293   function mint(address _to, uint256 _mintAmount) public payable {
1294     require(!paused);
1295     require(_mintAmount > 0);
1296     require(totalSupply() + _mintAmount <= maxSupply);
1297     require(block.timestamp >= privateDate, "Minting has not started yet");
1298     
1299     if (block.timestamp < startDate) {
1300         require(minted[msg.sender] + _mintAmount <= privateMaxMint, "You have minted the max for private sale");
1301         minted[msg.sender] += _mintAmount;
1302     } else {
1303         require(_mintAmount <= maxMintAmount, "You have reached the max mint per transaction");
1304     }
1305     
1306     require(msg.value >= cost * _mintAmount);
1307     payable(owner()).transfer(msg.value);
1308 
1309     for (uint256 i = 0; i < _mintAmount; i++) {
1310       _safeMint(_to, totalSupply()+1);
1311     }
1312   }
1313 
1314   function walletOfOwner(address _owner)
1315     public
1316     view
1317     returns (uint256[] memory)
1318   {
1319     uint256 ownerTokenCount = balanceOf(_owner);
1320     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1321     for (uint256 i; i < ownerTokenCount; i++) {
1322       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1323     }
1324     return tokenIds;
1325   }
1326 
1327   function tokenURI(uint256 tokenId)
1328     public
1329     view
1330     virtual
1331     override
1332     returns (string memory)
1333   {
1334     require(
1335       _exists(tokenId),
1336       "ERC721Metadata: URI query for nonexistent token"
1337     );
1338 
1339     string memory currentBaseURI = _baseURI();
1340     return bytes(currentBaseURI).length > 0
1341         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1342         : "";
1343   }
1344 
1345   // only owner
1346   function setCost(uint256 _newCost) public onlyOwner() {
1347     cost = _newCost;
1348   }
1349 
1350   function setStartDate(uint _newDate) public onlyOwner() {
1351     startDate = _newDate;
1352   }
1353   
1354   function setPrivateStartDate(uint _newDate) public onlyOwner() {
1355     privateDate = _newDate;
1356   }
1357 
1358   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1359     maxMintAmount = _newmaxMintAmount;
1360   }
1361 
1362   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1363     baseURI = _newBaseURI;
1364   }
1365 
1366   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1367     baseExtension = _newBaseExtension;
1368   }
1369 
1370   function pause(bool _state) public onlyOwner {
1371     paused = _state;
1372   }
1373 }