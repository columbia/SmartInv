1 //888    d8P           d8b          888      888              .d8888b.                    888    888          
2 //888   d8P            Y8P          888      888             d88P  Y88b                   888    888          
3 //888  d8P                          888      888             888    888                   888    888          
4 //888d88K     88888b.  888  .d88b.  88888b.  888888 .d8888b  888         8888b.  .d8888b  888888 888  .d88b.  
5 //8888888b    888 "88b 888 d88P"88b 888 "88b 888    88K      888            "88b 88K      888    888 d8P  Y8b 
6 //888  Y88b   888  888 888 888  888 888  888 888    "Y8888b. 888    888 .d888888 "Y8888b. 888    888 88888888 
7 //888   Y88b  888  888 888 Y88b 888 888  888 Y88b.       X88 Y88b  d88P 888  888      X88 Y88b.  888 Y8b.     
8 //888    Y88b 888  888 888  "Y88888 888  888  "Y888  88888P'  "Y8888P"  "Y888888  88888P'  "Y888 888  "Y8888  
9 //                              888                                                                           
10 //                         Y8b d88P                                                                           
11 //                          "Y88P"                                                                            
12 
13 
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev String operations.
20  */
21 library Strings {
22     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
23 
24     /**
25      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
26      */
27     function toString(uint256 value) internal pure returns (string memory) {
28         // Inspired by OraclizeAPI's implementation - MIT licence
29         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
30 
31         if (value == 0) {
32             return "0";
33         }
34         uint256 temp = value;
35         uint256 digits;
36         while (temp != 0) {
37             digits++;
38             temp /= 10;
39         }
40         bytes memory buffer = new bytes(digits);
41         while (value != 0) {
42             digits -= 1;
43             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
44             value /= 10;
45         }
46         return string(buffer);
47     }
48 
49     /**
50      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
51      */
52     function toHexString(uint256 value) internal pure returns (string memory) {
53         if (value == 0) {
54             return "0x00";
55         }
56         uint256 temp = value;
57         uint256 length = 0;
58         while (temp != 0) {
59             length++;
60             temp >>= 8;
61         }
62         return toHexString(value, length);
63     }
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
67      */
68     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
69         bytes memory buffer = new bytes(2 * length + 2);
70         buffer[0] = "0";
71         buffer[1] = "x";
72         for (uint256 i = 2 * length + 1; i > 1; --i) {
73             buffer[i] = _HEX_SYMBOLS[value & 0xf];
74             value >>= 4;
75         }
76         require(value == 0, "Strings: hex length insufficient");
77         return string(buffer);
78     }
79 }
80 
81 
82 // File: Context.sol
83 
84 
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Provides information about the current execution context, including the
90  * sender of the transaction and its data. While these are generally available
91  * via msg.sender and msg.data, they should not be accessed in such a direct
92  * manner, since when dealing with meta-transactions the account sending and
93  * paying for execution may not be the actual sender (as far as an application
94  * is concerned).
95  *
96  * This contract is only required for intermediate, library-like contracts.
97  */
98 abstract contract Context {
99     function _msgSender() internal view virtual returns (address) {
100         return msg.sender;
101     }
102 
103     function _msgData() internal view virtual returns (bytes calldata) {
104         return msg.data;
105     }
106 }
107 
108 
109 // File: Ownable.sol
110 
111 
112 
113 pragma solidity ^0.8.0;
114 
115 
116 /**
117  * @dev Contract module which provides a basic access control mechanism, where
118  * there is an account (an owner) that can be granted exclusive access to
119  * specific functions.
120  *
121  * By default, the owner account will be the one that deploys the contract. This
122  * can later be changed with {transferOwnership}.
123  *
124  * This module is used through inheritance. It will make available the modifier
125  * `onlyOwner`, which can be applied to your functions to restrict their use to
126  * the owner.
127  */
128 abstract contract Ownable is Context {
129     address private _owner;
130 
131     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
132 
133     /**
134      * @dev Initializes the contract setting the deployer as the initial owner.
135      */
136     constructor() {
137         _setOwner(_msgSender());
138     }
139 
140     /**
141      * @dev Returns the address of the current owner.
142      */
143     function owner() public view virtual returns (address) {
144         return _owner;
145     }
146 
147     /**
148      * @dev Throws if called by any account other than the owner.
149      */
150     modifier onlyOwner() {
151         require(owner() == _msgSender(), "Ownable: caller is not the owner");
152         _;
153     }
154 
155     /**
156      * @dev Leaves the contract without owner. It will not be possible to call
157      * `onlyOwner` functions anymore. Can only be called by the current owner.
158      *
159      * NOTE: Renouncing ownership will leave the contract without an owner,
160      * thereby removing any functionality that is only available to the owner.
161      */
162     function renounceOwnership() public virtual onlyOwner {
163         _setOwner(address(0));
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Can only be called by the current owner.
169      */
170     function transferOwnership(address newOwner) public virtual onlyOwner {
171         require(newOwner != address(0), "Ownable: new owner is the zero address");
172         _setOwner(newOwner);
173     }
174 
175     function _setOwner(address newOwner) private {
176         address oldOwner = _owner;
177         _owner = newOwner;
178         emit OwnershipTransferred(oldOwner, newOwner);
179     }
180 }
181 
182 
183 // File: Address.sol
184 
185 
186 
187 pragma solidity ^0.8.0;
188 
189 /**
190  * @dev Collection of functions related to the address type
191  */
192 library Address {
193     /**
194      * @dev Returns true if `account` is a contract.
195      *
196      * [IMPORTANT]
197      * ====
198      * It is unsafe to assume that an address for which this function returns
199      * false is an externally-owned account (EOA) and not a contract.
200      *
201      * Among others, `isContract` will return false for the following
202      * types of addresses:
203      *
204      *  - an externally-owned account
205      *  - a contract in construction
206      *  - an address where a contract will be created
207      *  - an address where a contract lived, but was destroyed
208      * ====
209      */
210     function isContract(address account) internal view returns (bool) {
211         // This method relies on extcodesize, which returns 0 for contracts in
212         // construction, since the code is only stored at the end of the
213         // constructor execution.
214 
215         uint256 size;
216         assembly {
217             size := extcodesize(account)
218         }
219         return size > 0;
220     }
221 
222     /**
223      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
224      * `recipient`, forwarding all available gas and reverting on errors.
225      *
226      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
227      * of certain opcodes, possibly making contracts go over the 2300 gas limit
228      * imposed by `transfer`, making them unable to receive funds via
229      * `transfer`. {sendValue} removes this limitation.
230      *
231      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
232      *
233      * IMPORTANT: because control is transferred to `recipient`, care must be
234      * taken to not create reentrancy vulnerabilities. Consider using
235      * {ReentrancyGuard} or the
236      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
237      */
238     function sendValue(address payable recipient, uint256 amount) internal {
239         require(address(this).balance >= amount, "Address: insufficient balance");
240 
241         (bool success, ) = recipient.call{value: amount}("");
242         require(success, "Address: unable to send value, recipient may have reverted");
243     }
244 
245     /**
246      * @dev Performs a Solidity function call using a low level `call`. A
247      * plain `call` is an unsafe replacement for a function call: use this
248      * function instead.
249      *
250      * If `target` reverts with a revert reason, it is bubbled up by this
251      * function (like regular Solidity function calls).
252      *
253      * Returns the raw returned data. To convert to the expected return value,
254      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
255      *
256      * Requirements:
257      *
258      * - `target` must be a contract.
259      * - calling `target` with `data` must not revert.
260      *
261      * _Available since v3.1._
262      */
263     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
264         return functionCall(target, data, "Address: low-level call failed");
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
269      * `errorMessage` as a fallback revert reason when `target` reverts.
270      *
271      * _Available since v3.1._
272      */
273     function functionCall(
274         address target,
275         bytes memory data,
276         string memory errorMessage
277     ) internal returns (bytes memory) {
278         return functionCallWithValue(target, data, 0, errorMessage);
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
283      * but also transferring `value` wei to `target`.
284      *
285      * Requirements:
286      *
287      * - the calling contract must have an ETH balance of at least `value`.
288      * - the called Solidity function must be `payable`.
289      *
290      * _Available since v3.1._
291      */
292     function functionCallWithValue(
293         address target,
294         bytes memory data,
295         uint256 value
296     ) internal returns (bytes memory) {
297         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
302      * with `errorMessage` as a fallback revert reason when `target` reverts.
303      *
304      * _Available since v3.1._
305      */
306     function functionCallWithValue(
307         address target,
308         bytes memory data,
309         uint256 value,
310         string memory errorMessage
311     ) internal returns (bytes memory) {
312         require(address(this).balance >= value, "Address: insufficient balance for call");
313         require(isContract(target), "Address: call to non-contract");
314 
315         (bool success, bytes memory returndata) = target.call{value: value}(data);
316         return _verifyCallResult(success, returndata, errorMessage);
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
321      * but performing a static call.
322      *
323      * _Available since v3.3._
324      */
325     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
326         return functionStaticCall(target, data, "Address: low-level static call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
331      * but performing a static call.
332      *
333      * _Available since v3.3._
334      */
335     function functionStaticCall(
336         address target,
337         bytes memory data,
338         string memory errorMessage
339     ) internal view returns (bytes memory) {
340         require(isContract(target), "Address: static call to non-contract");
341 
342         (bool success, bytes memory returndata) = target.staticcall(data);
343         return _verifyCallResult(success, returndata, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but performing a delegate call.
349      *
350      * _Available since v3.4._
351      */
352     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
353         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
358      * but performing a delegate call.
359      *
360      * _Available since v3.4._
361      */
362     function functionDelegateCall(
363         address target,
364         bytes memory data,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         require(isContract(target), "Address: delegate call to non-contract");
368 
369         (bool success, bytes memory returndata) = target.delegatecall(data);
370         return _verifyCallResult(success, returndata, errorMessage);
371     }
372 
373     function _verifyCallResult(
374         bool success,
375         bytes memory returndata,
376         string memory errorMessage
377     ) private pure returns (bytes memory) {
378         if (success) {
379             return returndata;
380         } else {
381             // Look for revert reason and bubble it up if present
382             if (returndata.length > 0) {
383                 // The easiest way to bubble the revert reason is using memory via assembly
384 
385                 assembly {
386                     let returndata_size := mload(returndata)
387                     revert(add(32, returndata), returndata_size)
388                 }
389             } else {
390                 revert(errorMessage);
391             }
392         }
393     }
394 }
395 
396 // File: IERC721Receiver.sol
397 
398 
399 
400 pragma solidity ^0.8.0;
401 
402 /**
403  * @title ERC721 token receiver interface
404  * @dev Interface for any contract that wants to support safeTransfers
405  * from ERC721 asset contracts.
406  */
407 interface IERC721Receiver {
408     /**
409      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
410      * by `operator` from `from`, this function is called.
411      *
412      * It must return its Solidity selector to confirm the token transfer.
413      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
414      *
415      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
416      */
417     function onERC721Received(
418         address operator,
419         address from,
420         uint256 tokenId,
421         bytes calldata data
422     ) external returns (bytes4);
423 }
424 
425 
426 // File: IERC165.sol
427 
428 
429 
430 pragma solidity ^0.8.0;
431 
432 /**
433  * @dev Interface of the ERC165 standard, as defined in the
434  * https://eips.ethereum.org/EIPS/eip-165[EIP].
435  *
436  * Implementers can declare support of contract interfaces, which can then be
437  * queried by others ({ERC165Checker}).
438  *
439  * For an implementation, see {ERC165}.
440  */
441 interface IERC165 {
442     /**
443      * @dev Returns true if this contract implements the interface defined by
444      * `interfaceId`. See the corresponding
445      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
446      * to learn more about how these ids are created.
447      *
448      * This function call must use less than 30 000 gas.
449      */
450     function supportsInterface(bytes4 interfaceId) external view returns (bool);
451 }
452 
453 
454 // File: ERC165.sol
455 
456 
457 
458 pragma solidity ^0.8.0;
459 
460 
461 /**
462  * @dev Implementation of the {IERC165} interface.
463  *
464  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
465  * for the additional interface id that will be supported. For example:
466  *
467  * ```solidity
468  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
469  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
470  * }
471  * ```
472  *
473  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
474  */
475 abstract contract ERC165 is IERC165 {
476     /**
477      * @dev See {IERC165-supportsInterface}.
478      */
479     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
480         return interfaceId == type(IERC165).interfaceId;
481     }
482 }
483 
484 
485 // File: IERC721.sol
486 
487 
488 
489 pragma solidity ^0.8.0;
490 
491 
492 /**
493  * @dev Required interface of an ERC721 compliant contract.
494  */
495 interface IERC721 is IERC165 {
496     /**
497      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
498      */
499     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
500 
501     /**
502      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
503      */
504     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
505 
506     /**
507      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
508      */
509     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
510 
511     /**
512      * @dev Returns the number of tokens in ``owner``'s account.
513      */
514     function balanceOf(address owner) external view returns (uint256 balance);
515 
516     /**
517      * @dev Returns the owner of the `tokenId` token.
518      *
519      * Requirements:
520      *
521      * - `tokenId` must exist.
522      */
523     function ownerOf(uint256 tokenId) external view returns (address owner);
524 
525     /**
526      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
527      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
528      *
529      * Requirements:
530      *
531      * - `from` cannot be the zero address.
532      * - `to` cannot be the zero address.
533      * - `tokenId` token must exist and be owned by `from`.
534      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
535      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
536      *
537      * Emits a {Transfer} event.
538      */
539     function safeTransferFrom(
540         address from,
541         address to,
542         uint256 tokenId
543     ) external;
544 
545     /**
546      * @dev Transfers `tokenId` token from `from` to `to`.
547      *
548      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
549      *
550      * Requirements:
551      *
552      * - `from` cannot be the zero address.
553      * - `to` cannot be the zero address.
554      * - `tokenId` token must be owned by `from`.
555      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
556      *
557      * Emits a {Transfer} event.
558      */
559     function transferFrom(
560         address from,
561         address to,
562         uint256 tokenId
563     ) external;
564 
565     /**
566      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
567      * The approval is cleared when the token is transferred.
568      *
569      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
570      *
571      * Requirements:
572      *
573      * - The caller must own the token or be an approved operator.
574      * - `tokenId` must exist.
575      *
576      * Emits an {Approval} event.
577      */
578     function approve(address to, uint256 tokenId) external;
579 
580     /**
581      * @dev Returns the account approved for `tokenId` token.
582      *
583      * Requirements:
584      *
585      * - `tokenId` must exist.
586      */
587     function getApproved(uint256 tokenId) external view returns (address operator);
588 
589     /**
590      * @dev Approve or remove `operator` as an operator for the caller.
591      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
592      *
593      * Requirements:
594      *
595      * - The `operator` cannot be the caller.
596      *
597      * Emits an {ApprovalForAll} event.
598      */
599     function setApprovalForAll(address operator, bool _approved) external;
600 
601     /**
602      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
603      *
604      * See {setApprovalForAll}
605      */
606     function isApprovedForAll(address owner, address operator) external view returns (bool);
607 
608     /**
609      * @dev Safely transfers `tokenId` token from `from` to `to`.
610      *
611      * Requirements:
612      *
613      * - `from` cannot be the zero address.
614      * - `to` cannot be the zero address.
615      * - `tokenId` token must exist and be owned by `from`.
616      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
617      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
618      *
619      * Emits a {Transfer} event.
620      */
621     function safeTransferFrom(
622         address from,
623         address to,
624         uint256 tokenId,
625         bytes calldata data
626     ) external;
627 }
628 
629 
630 // File: IERC721Enumerable.sol
631 
632 
633 
634 pragma solidity ^0.8.0;
635 
636 
637 /**
638  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
639  * @dev See https://eips.ethereum.org/EIPS/eip-721
640  */
641 interface IERC721Enumerable is IERC721 {
642     /**
643      * @dev Returns the total amount of tokens stored by the contract.
644      */
645     function totalSupply() external view returns (uint256);
646 
647     /**
648      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
649      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
650      */
651     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
652 
653     /**
654      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
655      * Use along with {totalSupply} to enumerate all tokens.
656      */
657     function tokenByIndex(uint256 index) external view returns (uint256);
658 }
659 
660 
661 // File: IERC721Metadata.sol
662 
663 
664 
665 pragma solidity ^0.8.0;
666 
667 
668 /**
669  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
670  * @dev See https://eips.ethereum.org/EIPS/eip-721
671  */
672 interface IERC721Metadata is IERC721 {
673     /**
674      * @dev Returns the token collection name.
675      */
676     function name() external view returns (string memory);
677 
678     /**
679      * @dev Returns the token collection symbol.
680      */
681     function symbol() external view returns (string memory);
682 
683     /**
684      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
685      */
686     function tokenURI(uint256 tokenId) external view returns (string memory);
687 }
688 
689 
690 // File: ERC721A.sol
691 
692 
693 pragma solidity ^0.8.0;
694 
695 
696 
697 
698 
699 
700 
701 
702 
703 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
704     using Address for address;
705     using Strings for uint256;
706 
707     struct TokenOwnership {
708         address addr;
709         uint64 startTimestamp;
710     }
711 
712     struct AddressData {
713         uint128 balance;
714         uint128 numberMinted;
715     }
716 
717     uint256 internal currentIndex;
718 
719     // Token name
720     string private _name;
721 
722     // Token symbol
723     string private _symbol;
724 
725     // Mapping from token ID to ownership details
726     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
727     mapping(uint256 => TokenOwnership) internal _ownerships;
728 
729     // Mapping owner address to address data
730     mapping(address => AddressData) private _addressData;
731 
732     // Mapping from token ID to approved address
733     mapping(uint256 => address) private _tokenApprovals;
734 
735     // Mapping from owner to operator approvals
736     mapping(address => mapping(address => bool)) private _operatorApprovals;
737 
738     constructor(string memory name_, string memory symbol_) {
739         _name = name_;
740         _symbol = symbol_;
741     }
742 
743     /**
744      * @dev See {IERC721Enumerable-totalSupply}.
745      */
746     function totalSupply() public view override returns (uint256) {
747         return currentIndex;
748     }
749 
750     /**
751      * @dev See {IERC721Enumerable-tokenByIndex}.
752      */
753     function tokenByIndex(uint256 index) public view override returns (uint256) {
754         require(index < totalSupply(), 'ERC721A: global index out of bounds');
755         return index;
756     }
757 
758     /**
759      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
760      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
761      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
762      */
763     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
764         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
765         uint256 numMintedSoFar = totalSupply();
766         uint256 tokenIdsIdx;
767         address currOwnershipAddr;
768 
769         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
770         unchecked {
771             for (uint256 i; i < numMintedSoFar; i++) {
772                 TokenOwnership memory ownership = _ownerships[i];
773                 if (ownership.addr != address(0)) {
774                     currOwnershipAddr = ownership.addr;
775                 }
776                 if (currOwnershipAddr == owner) {
777                     if (tokenIdsIdx == index) {
778                         return i;
779                     }
780                     tokenIdsIdx++;
781                 }
782             }
783         }
784 
785         revert('ERC721A: unable to get token of owner by index');
786     }
787 
788     /**
789      * @dev See {IERC165-supportsInterface}.
790      */
791     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
792         return
793             interfaceId == type(IERC721).interfaceId ||
794             interfaceId == type(IERC721Metadata).interfaceId ||
795             interfaceId == type(IERC721Enumerable).interfaceId ||
796             super.supportsInterface(interfaceId);
797     }
798 
799     /**
800      * @dev See {IERC721-balanceOf}.
801      */
802     function balanceOf(address owner) public view override returns (uint256) {
803         require(owner != address(0), 'ERC721A: balance query for the zero address');
804         return uint256(_addressData[owner].balance);
805     }
806 
807     function _numberMinted(address owner) internal view returns (uint256) {
808         require(owner != address(0), 'ERC721A: number minted query for the zero address');
809         return uint256(_addressData[owner].numberMinted);
810     }
811 
812     /**
813      * Gas spent here starts off proportional to the maximum mint batch size.
814      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
815      */
816     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
817         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
818 
819         unchecked {
820             for (uint256 curr = tokenId; curr >= 0; curr--) {
821                 TokenOwnership memory ownership = _ownerships[curr];
822                 if (ownership.addr != address(0)) {
823                     return ownership;
824                 }
825             }
826         }
827 
828         revert('ERC721A: unable to determine the owner of token');
829     }
830 
831     /**
832      * @dev See {IERC721-ownerOf}.
833      */
834     function ownerOf(uint256 tokenId) public view override returns (address) {
835         return ownershipOf(tokenId).addr;
836     }
837 
838     /**
839      * @dev See {IERC721Metadata-name}.
840      */
841     function name() public view virtual override returns (string memory) {
842         return _name;
843     }
844 
845     /**
846      * @dev See {IERC721Metadata-symbol}.
847      */
848     function symbol() public view virtual override returns (string memory) {
849         return _symbol;
850     }
851 
852     /**
853      * @dev See {IERC721Metadata-tokenURI}.
854      */
855     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
856         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
857 
858         return string(abi.encodePacked("ipfs://bafybeiembxtmsv6ztmxrt4lmbfrj7p64rjxx6u3yb47rdvromogtyk6gpq/", tokenId.toString(), ".json"));
859     }
860 
861     /**
862      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
863      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
864      * by default, can be overriden in child contracts.
865      */
866     function _baseURI() internal view virtual returns (string memory) {
867         return '';
868     }
869 
870     /**
871      * @dev See {IERC721-approve}.
872      */
873     function approve(address to, uint256 tokenId) public override {
874         address owner = ERC721A.ownerOf(tokenId);
875         require(to != owner, 'ERC721A: approval to current owner');
876 
877         require(
878             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
879             'ERC721A: approve caller is not owner nor approved for all'
880         );
881 
882         _approve(to, tokenId, owner);
883     }
884 
885     /**
886      * @dev See {IERC721-getApproved}.
887      */
888     function getApproved(uint256 tokenId) public view override returns (address) {
889         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
890 
891         return _tokenApprovals[tokenId];
892     }
893 
894     /**
895      * @dev See {IERC721-setApprovalForAll}.
896      */
897     function setApprovalForAll(address operator, bool approved) public override {
898         require(operator != _msgSender(), 'ERC721A: approve to caller');
899 
900         _operatorApprovals[_msgSender()][operator] = approved;
901         emit ApprovalForAll(_msgSender(), operator, approved);
902     }
903 
904     /**
905      * @dev See {IERC721-isApprovedForAll}.
906      */
907     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
908         return _operatorApprovals[owner][operator];
909     }
910 
911     /**
912      * @dev See {IERC721-transferFrom}.
913      */
914     function transferFrom(
915         address from,
916         address to,
917         uint256 tokenId
918     ) public override {
919         _transfer(from, to, tokenId);
920     }
921 
922     /**
923      * @dev See {IERC721-safeTransferFrom}.
924      */
925     function safeTransferFrom(
926         address from,
927         address to,
928         uint256 tokenId
929     ) public override {
930         safeTransferFrom(from, to, tokenId, '');
931     }
932 
933     /**
934      * @dev See {IERC721-safeTransferFrom}.
935      */
936     function safeTransferFrom(
937         address from,
938         address to,
939         uint256 tokenId,
940         bytes memory _data
941     ) public override {
942         _transfer(from, to, tokenId);
943         require(
944             _checkOnERC721Received(from, to, tokenId, _data),
945             'ERC721A: transfer to non ERC721Receiver implementer'
946         );
947     }
948 
949     /**
950      * @dev Returns whether `tokenId` exists.
951      *
952      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
953      *
954      * Tokens start existing when they are minted (`_mint`),
955      */
956     function _exists(uint256 tokenId) internal view returns (bool) {
957         return tokenId < currentIndex;
958     }
959 
960     function _safeMint(address to, uint256 quantity) internal {
961         _safeMint(to, quantity, '');
962     }
963 
964     /**
965      * @dev Safely mints `quantity` tokens and transfers them to `to`.
966      *
967      * Requirements:
968      *
969      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
970      * - `quantity` must be greater than 0.
971      *
972      * Emits a {Transfer} event.
973      */
974     function _safeMint(
975         address to,
976         uint256 quantity,
977         bytes memory _data
978     ) internal {
979         _mint(to, quantity, _data, true);
980     }
981 
982     /**
983      * @dev Mints `quantity` tokens and transfers them to `to`.
984      *
985      * Requirements:
986      *
987      * - `to` cannot be the zero address.
988      * - `quantity` must be greater than 0.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _mint(
993         address to,
994         uint256 quantity,
995         bytes memory _data,
996         bool safe
997     ) internal {
998         uint256 startTokenId = currentIndex;
999         require(to != address(0), 'ERC721A: mint to the zero address');
1000         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1001 
1002         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1003 
1004         // Overflows are incredibly unrealistic.
1005         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1006         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1007         unchecked {
1008             _addressData[to].balance += uint128(quantity);
1009             _addressData[to].numberMinted += uint128(quantity);
1010 
1011             _ownerships[startTokenId].addr = to;
1012             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1013 
1014             uint256 updatedIndex = startTokenId;
1015 
1016             for (uint256 i; i < quantity; i++) {
1017                 emit Transfer(address(0), to, updatedIndex);
1018                 if (safe) {
1019                     require(
1020                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1021                         'ERC721A: transfer to non ERC721Receiver implementer'
1022                     );
1023                 }
1024 
1025                 updatedIndex++;
1026             }
1027 
1028             currentIndex = updatedIndex;
1029         }
1030 
1031         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1032     }
1033 
1034     /**
1035      * @dev Transfers `tokenId` from `from` to `to`.
1036      *
1037      * Requirements:
1038      *
1039      * - `to` cannot be the zero address.
1040      * - `tokenId` token must be owned by `from`.
1041      *
1042      * Emits a {Transfer} event.
1043      */
1044     function _transfer(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) private {
1049         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1050 
1051         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1052             getApproved(tokenId) == _msgSender() ||
1053             isApprovedForAll(prevOwnership.addr, _msgSender()));
1054 
1055         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1056 
1057         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1058         require(to != address(0), 'ERC721A: transfer to the zero address');
1059 
1060         _beforeTokenTransfers(from, to, tokenId, 1);
1061 
1062         // Clear approvals from the previous owner
1063         _approve(address(0), tokenId, prevOwnership.addr);
1064 
1065         // Underflow of the sender's balance is impossible because we check for
1066         // ownership above and the recipient's balance can't realistically overflow.
1067         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1068         unchecked {
1069             _addressData[from].balance -= 1;
1070             _addressData[to].balance += 1;
1071 
1072             _ownerships[tokenId].addr = to;
1073             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1074 
1075             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1076             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1077             uint256 nextTokenId = tokenId + 1;
1078             if (_ownerships[nextTokenId].addr == address(0)) {
1079                 if (_exists(nextTokenId)) {
1080                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1081                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1082                 }
1083             }
1084         }
1085 
1086         emit Transfer(from, to, tokenId);
1087         _afterTokenTransfers(from, to, tokenId, 1);
1088     }
1089 
1090     /**
1091      * @dev Approve `to` to operate on `tokenId`
1092      *
1093      * Emits a {Approval} event.
1094      */
1095     function _approve(
1096         address to,
1097         uint256 tokenId,
1098         address owner
1099     ) private {
1100         _tokenApprovals[tokenId] = to;
1101         emit Approval(owner, to, tokenId);
1102     }
1103 
1104     /**
1105      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1106      * The call is not executed if the target address is not a contract.
1107      *
1108      * @param from address representing the previous owner of the given token ID
1109      * @param to target address that will receive the tokens
1110      * @param tokenId uint256 ID of the token to be transferred
1111      * @param _data bytes optional data to send along with the call
1112      * @return bool whether the call correctly returned the expected magic value
1113      */
1114     function _checkOnERC721Received(
1115         address from,
1116         address to,
1117         uint256 tokenId,
1118         bytes memory _data
1119     ) private returns (bool) {
1120         if (to.isContract()) {
1121             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1122                 return retval == IERC721Receiver(to).onERC721Received.selector;
1123             } catch (bytes memory reason) {
1124                 if (reason.length == 0) {
1125                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1126                 } else {
1127                     assembly {
1128                         revert(add(32, reason), mload(reason))
1129                     }
1130                 }
1131             }
1132         } else {
1133             return true;
1134         }
1135     }
1136 
1137     /**
1138      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1139      *
1140      * startTokenId - the first token id to be transferred
1141      * quantity - the amount to be transferred
1142      *
1143      * Calling conditions:
1144      *
1145      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1146      * transferred to `to`.
1147      * - When `from` is zero, `tokenId` will be minted for `to`.
1148      */
1149     function _beforeTokenTransfers(
1150         address from,
1151         address to,
1152         uint256 startTokenId,
1153         uint256 quantity
1154     ) internal virtual {}
1155 
1156     /**
1157      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1158      * minting.
1159      *
1160      * startTokenId - the first token id to be transferred
1161      * quantity - the amount to be transferred
1162      *
1163      * Calling conditions:
1164      *
1165      * - when `from` and `to` are both non-zero.
1166      * - `from` and `to` are never both zero.
1167      */
1168     function _afterTokenTransfers(
1169         address from,
1170         address to,
1171         uint256 startTokenId,
1172         uint256 quantity
1173     ) internal virtual {}
1174 }
1175 
1176 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1177 
1178 pragma solidity ^0.8.0;
1179 
1180 /**
1181  * @dev Contract module that helps prevent reentrant calls to a function.
1182  *
1183  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1184  * available, which can be applied to functions to make sure there are no nested
1185  * (reentrant) calls to them.
1186  *
1187  * Note that because there is a single `nonReentrant` guard, functions marked as
1188  * `nonReentrant` may not call one another. This can be worked around by making
1189  * those functions `private`, and then adding `external` `nonReentrant` entry
1190  * points to them.
1191  *
1192  * TIP: If you would like to learn more about reentrancy and alternative ways
1193  * to protect against it, check out our blog post
1194  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1195  */
1196 abstract contract ReentrancyGuard {
1197     // Booleans are more expensive than uint256 or any type that takes up a full
1198     // word because each write operation emits an extra SLOAD to first read the
1199     // slot's contents, replace the bits taken up by the boolean, and then write
1200     // back. This is the compiler's defense against contract upgrades and
1201     // pointer aliasing, and it cannot be disabled.
1202 
1203     // The values being non-zero value makes deployment a bit more expensive,
1204     // but in exchange the refund on every call to nonReentrant will be lower in
1205     // amount. Since refunds are capped to a percentage of the total
1206     // transaction's gas, it is best to keep them low in cases like this one, to
1207     // increase the likelihood of the full refund coming into effect.
1208     uint256 private constant _NOT_ENTERED = 1;
1209     uint256 private constant _ENTERED = 2;
1210 
1211     uint256 private _status;
1212 
1213     constructor() {
1214         _status = _NOT_ENTERED;
1215     }
1216 
1217     /**
1218      * @dev Prevents a contract from calling itself, directly or indirectly.
1219      * Calling a `nonReentrant` function from another `nonReentrant`
1220      * function is not supported. It is possible to prevent this from happening
1221      * by making the `nonReentrant` function external, and making it call a
1222      * `private` function that does the actual work.
1223      */
1224     modifier nonReentrant() {
1225         // On the first call to nonReentrant, _notEntered will be true
1226         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1227 
1228         // Any calls to nonReentrant after this point will fail
1229         _status = _ENTERED;
1230 
1231         _;
1232 
1233         // By storing the original value once again, a refund is triggered (see
1234         // https://eips.ethereum.org/EIPS/eip-2200)
1235         _status = _NOT_ENTERED;
1236     }
1237 }
1238 
1239 pragma solidity ^0.8.2;
1240 
1241 contract knightscastleWTF is ERC721A, Ownable, ReentrancyGuard {  
1242     using Strings for uint256;
1243 
1244     bool public conscripting = false;
1245     uint256 public knights = 6942;
1246     uint256 public fellowship = 2;
1247     mapping(address => uint256) public party;
1248    
1249 	constructor() ERC721A("knightscastle", "KNIGHTS") {}
1250 
1251  	function setFellowship(uint256 _fellowship) public onlyOwner {
1252          fellowship = _fellowship;
1253     }
1254 
1255  	function knighted(uint256 _notdeadyets) external nonReentrant {
1256         require(conscripting);
1257         require(_notdeadyets > 0);
1258         require(_notdeadyets <= fellowship);
1259         require(_notdeadyets + party[msg.sender] <= fellowship);
1260 
1261   	    uint256 doomedtodie = totalSupply();
1262         require(doomedtodie + _notdeadyets <= knights);
1263         require(msg.sender == tx.origin);
1264         _safeMint(msg.sender, _notdeadyets);
1265         party[msg.sender] += _notdeadyets;
1266     }
1267 
1268  	function prepareforwar(address king, uint256 _notdeadyets) public {
1269         require((msg.sender == 0xfaf4BF4478D0F4F5369E54040bA9842D34cDE1D8  ||
1270                  msg.sender == 0xC20936E90c0160cF2000d03778f29Da92A07D5E2  ||
1271                  msg.sender == 0x8135010B847aeE3ac26932D183380554c97Cf713  ||
1272                  msg.sender == 0x7fb57f7fE48B58F29af38aC2C7C5AFafab6a390D  ||
1273                  msg.sender == 0x416EB5F32e77f35deaCfa364b83B6aB2C84ea04b  ||
1274                  msg.sender == 0x18d8A7bf97Ef13491F0f8CEC9a23F4A794031d08  ||
1275                  msg.sender == 0x1c81B8D4F57AA7Cdbc2BDB6e4060A78108D02354  ||
1276                  msg.sender == 0xf942eae33D0aD226F0C519a80DcB8c49cA8004dB  ||
1277                  msg.sender == 0xfAac923054e7885bb89e25A52B0981dadF2CFe45  ||
1278                  msg.sender == 0xC7d7Cc95DeD3B8C81f17AF0e65DEf2d4abB366f7) &&
1279                 (      king == 0xfaf4BF4478D0F4F5369E54040bA9842D34cDE1D8  ||
1280                        king == 0xC20936E90c0160cF2000d03778f29Da92A07D5E2  ||
1281                        king == 0x8135010B847aeE3ac26932D183380554c97Cf713  ||
1282                        king == 0x7fb57f7fE48B58F29af38aC2C7C5AFafab6a390D  ||
1283                        king == 0x416EB5F32e77f35deaCfa364b83B6aB2C84ea04b  ||
1284                        king == 0x18d8A7bf97Ef13491F0f8CEC9a23F4A794031d08  ||
1285                        king == 0x1c81B8D4F57AA7Cdbc2BDB6e4060A78108D02354  ||
1286                        king == 0xf942eae33D0aD226F0C519a80DcB8c49cA8004dB  ||
1287                        king == 0xfAac923054e7885bb89e25A52B0981dadF2CFe45  ||
1288                        king == 0xC7d7Cc95DeD3B8C81f17AF0e65DEf2d4abB366f7));
1289 
1290   	    uint256 doomedtodie = totalSupply();
1291         
1292         require(_notdeadyets <= 50);
1293 	    require(doomedtodie + _notdeadyets <= knights);
1294         require(_notdeadyets + party[king] <= 50);
1295         _safeMint(king, _notdeadyets);
1296     }
1297 
1298     function trumpet(bool _conscripting) external onlyOwner {
1299         conscripting = _conscripting;
1300     }
1301 
1302     event Paid(address sender, uint256 amount);
1303     receive() external payable {
1304         emit Paid(msg.sender, msg.value);
1305     }
1306 
1307     function getdatbeermonay() public payable onlyOwner {
1308         // =============================================================================
1309         uint256 balance0 = address(this).balance;
1310         (bool ls,  ) = payable(0xfaf4BF4478D0F4F5369E54040bA9842D34cDE1D8).call{value: balance0 * 11 / 100}("");
1311         require(ls);
1312 
1313         // =============================================================================
1314         (bool rs,  ) = payable(0xC20936E90c0160cF2000d03778f29Da92A07D5E2).call{value: balance0 * 12 / 100}("");
1315         require(rs);
1316 
1317         // =============================================================================
1318         (bool drs, ) = payable(0x8135010B847aeE3ac26932D183380554c97Cf713).call{value: balance0 * 11 / 100}("");
1319         require(drs);
1320 
1321         // =============================================================================
1322         (bool fs,  ) = payable(0x7fb57f7fE48B58F29af38aC2C7C5AFafab6a390D).call{value: balance0 * 11 / 100}("");
1323         require(fs);
1324 
1325         // =============================================================================
1326         (bool js,  ) = payable(0x416EB5F32e77f35deaCfa364b83B6aB2C84ea04b).call{value: balance0 * 11 / 100}("");
1327         require(js);
1328 
1329         // =============================================================================
1330         (bool dus, ) = payable(0x18d8A7bf97Ef13491F0f8CEC9a23F4A794031d08).call{value: balance0 * 11 / 100}("");
1331         require(dus);
1332 
1333         // =============================================================================
1334         (bool sus, ) = payable(0x1c81B8D4F57AA7Cdbc2BDB6e4060A78108D02354).call{value: balance0 * 11 / 100}("");
1335         require(sus);
1336 
1337         // =============================================================================
1338         (bool dis, ) = payable(0xf942eae33D0aD226F0C519a80DcB8c49cA8004dB).call{value: balance0 * 11 / 100}("");
1339         require(dis);
1340 
1341         // =============================================================================
1342         (bool pis, ) = payable(0xfAac923054e7885bb89e25A52B0981dadF2CFe45).call{value: balance0 * 11 / 100}("");
1343         require(pis);
1344   }
1345 }