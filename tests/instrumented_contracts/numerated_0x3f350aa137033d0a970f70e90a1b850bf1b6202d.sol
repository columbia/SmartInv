1 // SPDX-License-Identifier: MIT
2 
3 /*
4 AkiraPills
5 2019 Nfts
6 Free Mint
7 Max 2 mint per transaction
8 ################################################################################
9 ################################################################################
10 ################################################################################
11 ################################################################################
12 ################################################################################
13 ################################################################################
14 ################################################################################
15 ################################################################################
16 ############################################&((#@&/*%&(((&######################
17 #########################################%((@         ((((((####################
18 #######################################&(&     &(((((((((((((&##################
19 ####################################%((@    &(((((((((((((((((##################
20 ##################################&(%     &(((((((((((((((((((%#################
21 ###############################%/(@    &(((((((((((((((((((((###################
22 #############################&**&    &((((((((((((((((((((((&###################
23 ##########################%**@&**.%(((((((((((((((((((((((&#####################
24 ########################&*#    &**%(((((((((((((((((((((%#######################
25 #####################%**@    %******#((((((((((((((((&##########################
26 ####################%/     &**********&((((((((((((%############################
27 ##################&@     #***************#/&&%%@&###############################
28 ##################****#***********************&#################################
29 ##################/************************%####################################
30 ##################%**********************&######################################
31 ####################/*****************%#########################################
32 ######################&************#/%##########################################
33 ###########################%&&%#################################################
34 ################################################################################
35 ################################################################################
36 ################################################################################
37 ################################################################################
38 ################################################################################
39 ################################################################################                                       
40            
41             AkiraPills
42                         Good for Health
43                                         Bad for Education
44 
45 */
46 
47 
48 // File: @openzeppelin/contracts/utils/Context.sol
49 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
50 
51 pragma solidity ^0.8.0;
52 
53 
54 abstract contract Context {
55     function _msgSender() internal view virtual returns (address) {
56         return msg.sender;
57     }
58 
59     function _msgData() internal view virtual returns (bytes calldata) {
60         return msg.data;
61     }
62 }
63 
64 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
65 
66 pragma solidity ^0.8.0;
67 
68 /**
69  * @dev String operations.
70  */
71 library Strings {
72     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
73 
74     /**
75      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
76      */
77     function toString(uint256 value) internal pure returns (string memory) {
78         // Inspired by OraclizeAPI's implementation - MIT licence
79         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
80 
81         if (value == 0) {
82             return "0";
83         }
84         uint256 temp = value;
85         uint256 digits;
86         while (temp != 0) {
87             digits++;
88             temp /= 10;
89         }
90         bytes memory buffer = new bytes(digits);
91         while (value != 0) {
92             digits -= 1;
93             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
94             value /= 10;
95         }
96         return string(buffer);
97     }
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
101      */
102     function toHexString(uint256 value) internal pure returns (string memory) {
103         if (value == 0) {
104             return "0x00";
105         }
106         uint256 temp = value;
107         uint256 length = 0;
108         while (temp != 0) {
109             length++;
110             temp >>= 8;
111         }
112         return toHexString(value, length);
113     }
114 
115     /**
116      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
117      */
118     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
119         bytes memory buffer = new bytes(2 * length + 2);
120         buffer[0] = "0";
121         buffer[1] = "x";
122         for (uint256 i = 2 * length + 1; i > 1; --i) {
123             buffer[i] = _HEX_SYMBOLS[value & 0xf];
124             value >>= 4;
125         }
126         require(value == 0, "Strings: hex length insufficient");
127         return string(buffer);
128     }
129 }
130 // File: @openzeppelin/contracts/access/Ownable.sol
131 
132 
133 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 
138 /**
139  * @dev Contract module which provides a basic access control mechanism, where
140  * there is an account (an owner) that can be granted exclusive access to
141  * specific functions.
142  *
143  * By default, the owner account will be the one that deploys the contract. This
144  * can later be changed with {transferOwnership}.
145  *
146  * This module is used through inheritance. It will make available the modifier
147  * `onlyOwner`, which can be applied to your functions to restrict their use to
148  * the owner.
149  */
150 abstract contract Ownable is Context {
151     address private _owner;
152 
153     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155     /**
156      * @dev Initializes the contract setting the deployer as the initial owner.
157      */
158     constructor() {
159         _transferOwnership(_msgSender());
160     }
161 
162     /**
163      * @dev Returns the address of the current owner.
164      */
165     function owner() public view virtual returns (address) {
166         return _owner;
167     }
168 
169     /**
170      * @dev Throws if called by any account other than the owner.
171      */
172     modifier onlyOwner() {
173         require(owner() == _msgSender(), "Ownable: caller is not the owner");
174         _;
175     }
176 
177     /**
178      * @dev Leaves the contract without owner. It will not be possible to call
179      * `onlyOwner` functions anymore. Can only be called by the current owner.
180      *
181      * NOTE: Renouncing ownership will leave the contract without an owner,
182      * thereby removing any functionality that is only available to the owner.
183      */
184     function renounceOwnership() public virtual onlyOwner {
185         _transferOwnership(address(0));
186     }
187 
188     /**
189      * @dev Transfers ownership of the contract to a new account (`newOwner`).
190      * Can only be called by the current owner.
191      */
192     function transferOwnership(address newOwner) public virtual onlyOwner {
193         require(newOwner != address(0), "Ownable: new owner is the zero address");
194         _transferOwnership(newOwner);
195     }
196 
197     /**
198      * @dev Transfers ownership of the contract to a new account (`newOwner`).
199      * Internal function without access restriction.
200      */
201     function _transferOwnership(address newOwner) internal virtual {
202         address oldOwner = _owner;
203         _owner = newOwner;
204         emit OwnershipTransferred(oldOwner, newOwner);
205     }
206 }
207 
208 // File: @openzeppelin/contracts/utils/Address.sol
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @dev Collection of functions related to the address type
217  */
218 library Address {
219     /**
220      * @dev Returns true if `account` is a contract.
221      *
222      * [IMPORTANT]
223      * ====
224      * It is unsafe to assume that an address for which this function returns
225      * false is an externally-owned account (EOA) and not a contract.
226      *
227      * Among others, `isContract` will return false for the following
228      * types of addresses:
229      *
230      *  - an externally-owned account
231      *  - a contract in construction
232      *  - an address where a contract will be created
233      *  - an address where a contract lived, but was destroyed
234      * ====
235      */
236     function isContract(address account) internal view returns (bool) {
237         // This method relies on extcodesize, which returns 0 for contracts in
238         // construction, since the code is only stored at the end of the
239         // constructor execution.
240 
241         uint256 size;
242         assembly {
243             size := extcodesize(account)
244         }
245         return size > 0;
246     }
247 
248    
249     function sendValue(address payable recipient, uint256 amount) internal {
250         require(address(this).balance >= amount, "Address: insufficient balance");
251 
252         (bool success, ) = recipient.call{value: amount}("");
253         require(success, "Address: unable to send value, recipient may have reverted");
254     }
255 
256     
257     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
258         return functionCall(target, data, "Address: low-level call failed");
259     }
260 
261    
262     function functionCall(
263         address target,
264         bytes memory data,
265         string memory errorMessage
266     ) internal returns (bytes memory) {
267         return functionCallWithValue(target, data, 0, errorMessage);
268     }
269 
270    
271     function functionCallWithValue(
272         address target,
273         bytes memory data,
274         uint256 value
275     ) internal returns (bytes memory) {
276         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
277     }
278 
279    
280     function functionCallWithValue(
281         address target,
282         bytes memory data,
283         uint256 value,
284         string memory errorMessage
285     ) internal returns (bytes memory) {
286         require(address(this).balance >= value, "Address: insufficient balance for call");
287         require(isContract(target), "Address: call to non-contract");
288 
289         (bool success, bytes memory returndata) = target.call{value: value}(data);
290         return verifyCallResult(success, returndata, errorMessage);
291     }
292 
293    
294     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
295         return functionStaticCall(target, data, "Address: low-level static call failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
300      * but performing a static call.
301      *
302      * _Available since v3.3._
303      */
304     function functionStaticCall(
305         address target,
306         bytes memory data,
307         string memory errorMessage
308     ) internal view returns (bytes memory) {
309         require(isContract(target), "Address: static call to non-contract");
310 
311         (bool success, bytes memory returndata) = target.staticcall(data);
312         return verifyCallResult(success, returndata, errorMessage);
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but performing a delegate call.
318      *
319      * _Available since v3.4._
320      */
321     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
322         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
327      * but performing a delegate call.
328      *
329      * _Available since v3.4._
330      */
331     function functionDelegateCall(
332         address target,
333         bytes memory data,
334         string memory errorMessage
335     ) internal returns (bytes memory) {
336         require(isContract(target), "Address: delegate call to non-contract");
337 
338         (bool success, bytes memory returndata) = target.delegatecall(data);
339         return verifyCallResult(success, returndata, errorMessage);
340     }
341 
342     /**
343      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
344      * revert reason using the provided one.
345      *
346      * _Available since v4.3._
347      */
348     function verifyCallResult(
349         bool success,
350         bytes memory returndata,
351         string memory errorMessage
352     ) internal pure returns (bytes memory) {
353         if (success) {
354             return returndata;
355         } else {
356             // Look for revert reason and bubble it up if present
357             if (returndata.length > 0) {
358                 // The easiest way to bubble the revert reason is using memory via assembly
359 
360                 assembly {
361                     let returndata_size := mload(returndata)
362                     revert(add(32, returndata), returndata_size)
363                 }
364             } else {
365                 revert(errorMessage);
366             }
367         }
368     }
369 }
370 
371 
372 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
373 
374 
375 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 /**
380  * @dev Interface of the ERC165 standard, as defined in the
381  * https://eips.ethereum.org/EIPS/eip-165[EIP].
382  *
383  * Implementers can declare support of contract interfaces, which can then be
384  * queried by others ({ERC165Checker}).
385  *
386  * For an implementation, see {ERC165}.
387  */
388 interface IERC165 {
389     /**
390      * @dev Returns true if this contract implements the interface defined by
391      * `interfaceId`. See the corresponding
392      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
393      * to learn more about how these ids are created.
394      *
395      * This function call must use less than 30 000 gas.
396      */
397     function supportsInterface(bytes4 interfaceId) external view returns (bool);
398 }
399 
400 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
401 
402 
403 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
404 
405 pragma solidity ^0.8.0;
406 
407 
408 /**
409  * @dev Implementation of the {IERC165} interface.
410  *
411  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
412  * for the additional interface id that will be supported. For example:
413  *
414  * ```solidity
415  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
416  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
417  * }
418  * ```
419  *
420  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
421  */
422 abstract contract ERC165 is IERC165 {
423     /**
424      * @dev See {IERC165-supportsInterface}.
425      */
426     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
427         return interfaceId == type(IERC165).interfaceId;
428     }
429 }
430 
431 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 /**
439  * @title ERC721 token receiver interface
440  * @dev Interface for any contract that wants to support safeTransfers
441  * from ERC721 asset contracts.
442  */
443 interface IERC721Receiver {
444     /**
445      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
446      * by `operator` from `from`, this function is called.
447      *
448      * It must return its Solidity selector to confirm the token transfer.
449      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
450      *
451      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
452      */
453     function onERC721Received(
454         address operator,
455         address from,
456         uint256 tokenId,
457         bytes calldata data
458     ) external returns (bytes4);
459 }
460 
461 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
462 
463 
464 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 
469 /**
470  * @dev Required interface of an ERC721 compliant contract.
471  */
472 interface IERC721 is IERC165 {
473     /**
474      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
475      */
476     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
477 
478     /**
479      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
480      */
481     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
482 
483     /**
484      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
485      */
486     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
487 
488     /**
489      * @dev Returns the number of tokens in ``owner``'s account.
490      */
491     function balanceOf(address owner) external view returns (uint256 balance);
492 
493     /**
494      * @dev Returns the owner of the `tokenId` token.
495      *
496      * Requirements:
497      *
498      * - `tokenId` must exist.
499      */
500     function ownerOf(uint256 tokenId) external view returns (address owner);
501 
502     /**
503      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
504      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
505      *
506      * Requirements:
507      *
508      * - `from` cannot be the zero address.
509      * - `to` cannot be the zero address.
510      * - `tokenId` token must exist and be owned by `from`.
511      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
512      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
513      *
514      * Emits a {Transfer} event.
515      */
516     function safeTransferFrom(
517         address from,
518         address to,
519         uint256 tokenId
520     ) external;
521 
522     /**
523      * @dev Transfers `tokenId` token from `from` to `to`.
524      *
525      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
526      *
527      * Requirements:
528      *
529      * - `from` cannot be the zero address.
530      * - `to` cannot be the zero address.
531      * - `tokenId` token must be owned by `from`.
532      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
533      *
534      * Emits a {Transfer} event.
535      */
536     function transferFrom(
537         address from,
538         address to,
539         uint256 tokenId
540     ) external;
541 
542     /**
543      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
544      * The approval is cleared when the token is transferred.
545      *
546      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
547      *
548      * Requirements:
549      *
550      * - The caller must own the token or be an approved operator.
551      * - `tokenId` must exist.
552      *
553      * Emits an {Approval} event.
554      */
555     function approve(address to, uint256 tokenId) external;
556 
557     /**
558      * @dev Returns the account approved for `tokenId` token.
559      *
560      * Requirements:
561      *
562      * - `tokenId` must exist.
563      */
564     function getApproved(uint256 tokenId) external view returns (address operator);
565 
566     /**
567      * @dev Approve or remove `operator` as an operator for the caller.
568      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
569      *
570      * Requirements:
571      *
572      * - The `operator` cannot be the caller.
573      *
574      * Emits an {ApprovalForAll} event.
575      */
576     function setApprovalForAll(address operator, bool _approved) external;
577 
578     /**
579      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
580      *
581      * See {setApprovalForAll}
582      */
583     function isApprovedForAll(address owner, address operator) external view returns (bool);
584 
585     /**
586      * @dev Safely transfers `tokenId` token from `from` to `to`.
587      *
588      * Requirements:
589      *
590      * - `from` cannot be the zero address.
591      * - `to` cannot be the zero address.
592      * - `tokenId` token must exist and be owned by `from`.
593      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
594      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
595      *
596      * Emits a {Transfer} event.
597      */
598     function safeTransferFrom(
599         address from,
600         address to,
601         uint256 tokenId,
602         bytes calldata data
603     ) external;
604 }
605 
606 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
607 
608 
609 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 
614 /**
615  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
616  * @dev See https://eips.ethereum.org/EIPS/eip-721
617  */
618 interface IERC721Enumerable is IERC721 {
619     /**
620      * @dev Returns the total amount of tokens stored by the contract.
621      */
622     function totalSupply() external view returns (uint256);
623 
624     /**
625      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
626      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
627      */
628     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
629 
630     /**
631      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
632      * Use along with {totalSupply} to enumerate all tokens.
633      */
634     function tokenByIndex(uint256 index) external view returns (uint256);
635 }
636 
637 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
638 
639 
640 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 
645 /**
646  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
647  * @dev See https://eips.ethereum.org/EIPS/eip-721
648  */
649 interface IERC721Metadata is IERC721 {
650     /**
651      * @dev Returns the token collection name.
652      */
653     function name() external view returns (string memory);
654 
655     /**
656      * @dev Returns the token collection symbol.
657      */
658     function symbol() external view returns (string memory);
659 
660     /**
661      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
662      */
663     function tokenURI(uint256 tokenId) external view returns (string memory);
664 }
665 
666 
667 pragma solidity ^0.8.0;
668 
669 
670 /**
671  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
672  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
673  *
674  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
675  *
676  * Does not support burning tokens to address(0).
677  *
678  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
679  */
680 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
681     using Address for address;
682     using Strings for uint256;
683 
684     struct TokenOwnership {
685         address addr;
686         uint64 startTimestamp;
687     }
688 
689     struct AddressData {
690         uint128 balance;
691         uint128 numberMinted;
692     }
693 
694     uint256 internal currentIndex = 0;
695 
696     uint256 internal immutable maxBatchSize;
697 
698     // Token name
699     string private _name;
700 
701     // Token symbol
702     string private _symbol;
703 
704     // Mapping from token ID to ownership details
705     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
706     mapping(uint256 => TokenOwnership) internal _ownerships;
707 
708     // Mapping owner address to address data
709     mapping(address => AddressData) private _addressData;
710 
711     // Mapping from token ID to approved address
712     mapping(uint256 => address) private _tokenApprovals;
713 
714     // Mapping from owner to operator approvals
715     mapping(address => mapping(address => bool)) private _operatorApprovals;
716 
717     /**
718      * @dev
719      * `maxBatchSize` refers to how much a minter can mint at a time.
720      */
721     constructor(
722         string memory name_,
723         string memory symbol_,
724         uint256 maxBatchSize_
725     ) {
726         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
727         _name = name_;
728         _symbol = symbol_;
729         maxBatchSize = maxBatchSize_;
730     }
731 
732     /**
733      * @dev See {IERC721Enumerable-totalSupply}.
734      */
735     function totalSupply() public view override returns (uint256) {
736         return currentIndex;
737     }
738 
739     /**
740      * @dev See {IERC721Enumerable-tokenByIndex}.
741      */
742     function tokenByIndex(uint256 index) public view override returns (uint256) {
743         require(index < totalSupply(), 'ERC721A: global index out of bounds');
744         return index;
745     }
746 
747     /**
748      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
749      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
750      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
751      */
752     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
753         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
754         uint256 numMintedSoFar = totalSupply();
755         uint256 tokenIdsIdx = 0;
756         address currOwnershipAddr = address(0);
757         for (uint256 i = 0; i < numMintedSoFar; i++) {
758             TokenOwnership memory ownership = _ownerships[i];
759             if (ownership.addr != address(0)) {
760                 currOwnershipAddr = ownership.addr;
761             }
762             if (currOwnershipAddr == owner) {
763                 if (tokenIdsIdx == index) {
764                     return i;
765                 }
766                 tokenIdsIdx++;
767             }
768         }
769         revert('ERC721A: unable to get token of owner by index');
770     }
771 
772     /**
773      * @dev See {IERC165-supportsInterface}.
774      */
775     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
776         return
777             interfaceId == type(IERC721).interfaceId ||
778             interfaceId == type(IERC721Metadata).interfaceId ||
779             interfaceId == type(IERC721Enumerable).interfaceId ||
780             super.supportsInterface(interfaceId);
781     }
782 
783     /**
784      * @dev See {IERC721-balanceOf}.
785      */
786     function balanceOf(address owner) public view override returns (uint256) {
787         require(owner != address(0), 'ERC721A: balance query for the zero address');
788         return uint256(_addressData[owner].balance);
789     }
790 
791     function _numberMinted(address owner) internal view returns (uint256) {
792         require(owner != address(0), 'ERC721A: number minted query for the zero address');
793         return uint256(_addressData[owner].numberMinted);
794     }
795 
796     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
797         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
798 
799         uint256 lowestTokenToCheck;
800         if (tokenId >= maxBatchSize) {
801             lowestTokenToCheck = tokenId - maxBatchSize + 1;
802         }
803 
804         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
805             TokenOwnership memory ownership = _ownerships[curr];
806             if (ownership.addr != address(0)) {
807                 return ownership;
808             }
809         }
810 
811         revert('ERC721A: unable to determine the owner of token');
812     }
813 
814     /**
815      * @dev See {IERC721-ownerOf}.
816      */
817     function ownerOf(uint256 tokenId) public view override returns (address) {
818         return ownershipOf(tokenId).addr;
819     }
820 
821     /**
822      * @dev See {IERC721Metadata-name}.
823      */
824     function name() public view virtual override returns (string memory) {
825         return _name;
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-symbol}.
830      */
831     function symbol() public view virtual override returns (string memory) {
832         return _symbol;
833     }
834 
835     /**
836      * @dev See {IERC721Metadata-tokenURI}.
837      */
838     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
839         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
840 
841         string memory baseURI = _baseURI();
842         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
843     }
844 
845     /**
846      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
847      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
848      * by default, can be overriden in child contracts.
849      */
850     function _baseURI() internal view virtual returns (string memory) {
851         return '';
852     }
853 
854     /**
855      * @dev See {IERC721-approve}.
856      */
857     function approve(address to, uint256 tokenId) public override {
858         address owner = ERC721A.ownerOf(tokenId);
859         require(to != owner, 'ERC721A: approval to current owner');
860 
861         require(
862             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
863             'ERC721A: approve caller is not owner nor approved for all'
864         );
865 
866         _approve(to, tokenId, owner);
867     }
868 
869     /**
870      * @dev See {IERC721-getApproved}.
871      */
872     function getApproved(uint256 tokenId) public view override returns (address) {
873         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
874 
875         return _tokenApprovals[tokenId];
876     }
877 
878     /**
879      * @dev See {IERC721-setApprovalForAll}.
880      */
881     function setApprovalForAll(address operator, bool approved) public override {
882         require(operator != _msgSender(), 'ERC721A: approve to caller');
883 
884         _operatorApprovals[_msgSender()][operator] = approved;
885         emit ApprovalForAll(_msgSender(), operator, approved);
886     }
887 
888     /**
889      * @dev See {IERC721-isApprovedForAll}.
890      */
891     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
892         return _operatorApprovals[owner][operator];
893     }
894 
895     /**
896      * @dev See {IERC721-transferFrom}.
897      */
898     function transferFrom(
899         address from,
900         address to,
901         uint256 tokenId
902     ) public override {
903         _transfer(from, to, tokenId);
904     }
905 
906     /**
907      * @dev See {IERC721-safeTransferFrom}.
908      */
909     function safeTransferFrom(
910         address from,
911         address to,
912         uint256 tokenId
913     ) public override {
914         safeTransferFrom(from, to, tokenId, '');
915     }
916 
917     /**
918      * @dev See {IERC721-safeTransferFrom}.
919      */
920     function safeTransferFrom(
921         address from,
922         address to,
923         uint256 tokenId,
924         bytes memory _data
925     ) public override {
926         _transfer(from, to, tokenId);
927         require(
928             _checkOnERC721Received(from, to, tokenId, _data),
929             'ERC721A: transfer to non ERC721Receiver implementer'
930         );
931     }
932 
933     /**
934      * @dev Returns whether `tokenId` exists.
935      *
936      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
937      *
938      * Tokens start existing when they are minted (`_mint`),
939      */
940     function _exists(uint256 tokenId) internal view returns (bool) {
941         return tokenId < currentIndex;
942     }
943 
944     function _safeMint(address to, uint256 quantity) internal {
945         _safeMint(to, quantity, '');
946     }
947 
948     /**
949      * @dev Mints `quantity` tokens and transfers them to `to`.
950      *
951      * Requirements:
952      *
953      * - `to` cannot be the zero address.
954      * - `quantity` cannot be larger than the max batch size.
955      *
956      * Emits a {Transfer} event.
957      */
958     function _safeMint(
959         address to,
960         uint256 quantity,
961         bytes memory _data
962     ) internal {
963         uint256 startTokenId = currentIndex;
964         require(to != address(0), 'ERC721A: mint to the zero address');
965         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
966         require(!_exists(startTokenId), 'ERC721A: token already minted');
967         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
968         require(quantity > 0, 'ERC721A: quantity must be greater 0');
969 
970         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
971 
972         AddressData memory addressData = _addressData[to];
973         _addressData[to] = AddressData(
974             addressData.balance + uint128(quantity),
975             addressData.numberMinted + uint128(quantity)
976         );
977         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
978 
979         uint256 updatedIndex = startTokenId;
980 
981         for (uint256 i = 0; i < quantity; i++) {
982             emit Transfer(address(0), to, updatedIndex);
983             require(
984                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
985                 'ERC721A: transfer to non ERC721Receiver implementer'
986             );
987             updatedIndex++;
988         }
989 
990         currentIndex = updatedIndex;
991         _afterTokenTransfers(address(0), to, startTokenId, quantity);
992     }
993 
994     /**
995      * @dev Transfers `tokenId` from `from` to `to`.
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
1008     ) private {
1009         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1010 
1011         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1012             getApproved(tokenId) == _msgSender() ||
1013             isApprovedForAll(prevOwnership.addr, _msgSender()));
1014 
1015         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1016 
1017         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1018         require(to != address(0), 'ERC721A: transfer to the zero address');
1019 
1020         _beforeTokenTransfers(from, to, tokenId, 1);
1021 
1022         // Clear approvals from the previous owner
1023         _approve(address(0), tokenId, prevOwnership.addr);
1024 
1025         // Underflow of the sender's balance is impossible because we check for
1026         // ownership above and the recipient's balance can't realistically overflow.
1027         unchecked {
1028             _addressData[from].balance -= 1;
1029             _addressData[to].balance += 1;
1030         }
1031 
1032         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1033 
1034         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1035         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1036         uint256 nextTokenId = tokenId + 1;
1037         if (_ownerships[nextTokenId].addr == address(0)) {
1038             if (_exists(nextTokenId)) {
1039                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1040             }
1041         }
1042 
1043         emit Transfer(from, to, tokenId);
1044         _afterTokenTransfers(from, to, tokenId, 1);
1045     }
1046 
1047     /**
1048      * @dev Approve `to` to operate on `tokenId`
1049      *
1050      * Emits a {Approval} event.
1051      */
1052     function _approve(
1053         address to,
1054         uint256 tokenId,
1055         address owner
1056     ) private {
1057         _tokenApprovals[tokenId] = to;
1058         emit Approval(owner, to, tokenId);
1059     }
1060 
1061     /**
1062      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1063      * The call is not executed if the target address is not a contract.
1064      *
1065      * @param from address representing the previous owner of the given token ID
1066      * @param to target address that will receive the tokens
1067      * @param tokenId uint256 ID of the token to be transferred
1068      * @param _data bytes optional data to send along with the call
1069      * @return bool whether the call correctly returned the expected magic value
1070      */
1071     function _checkOnERC721Received(
1072         address from,
1073         address to,
1074         uint256 tokenId,
1075         bytes memory _data
1076     ) private returns (bool) {
1077         if (to.isContract()) {
1078             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1079                 return retval == IERC721Receiver(to).onERC721Received.selector;
1080             } catch (bytes memory reason) {
1081                 if (reason.length == 0) {
1082                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1083                 } else {
1084                     assembly {
1085                         revert(add(32, reason), mload(reason))
1086                     }
1087                 }
1088             }
1089         } else {
1090             return true;
1091         }
1092     }
1093 
1094     /**
1095      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1096      *
1097      * startTokenId - the first token id to be transferred
1098      * quantity - the amount to be transferred
1099      *
1100      * Calling conditions:
1101      *
1102      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1103      * transferred to `to`.
1104      * - When `from` is zero, `tokenId` will be minted for `to`.
1105      */
1106     function _beforeTokenTransfers(
1107         address from,
1108         address to,
1109         uint256 startTokenId,
1110         uint256 quantity
1111     ) internal virtual {}
1112 
1113     /**
1114      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1115      * minting.
1116      *
1117      * startTokenId - the first token id to be transferred
1118      * quantity - the amount to be transferred
1119      *
1120      * Calling conditions:
1121      *
1122      * - when `from` and `to` are both non-zero.
1123      * - `from` and `to` are never both zero.
1124      */
1125     function _afterTokenTransfers(
1126         address from,
1127         address to,
1128         uint256 startTokenId,
1129         uint256 quantity
1130     ) internal virtual {}
1131 }
1132 
1133 /*
1134 AkiraPills
1135 2019 Nfts
1136 Free Mint
1137 Max 2 mint per transaction
1138 ################################################################################
1139 ################################################################################
1140 ################################################################################
1141 ################################################################################
1142 ################################################################################
1143 ################################################################################
1144 ################################################################################
1145 ################################################################################
1146 ############################################&((#@&/*%&(((&######################
1147 #########################################%((@         ((((((####################
1148 #######################################&(&     &(((((((((((((&##################
1149 ####################################%((@    &(((((((((((((((((##################
1150 ##################################&(%     &(((((((((((((((((((%#################
1151 ###############################%/(@    &(((((((((((((((((((((###################
1152 #############################&**&    &((((((((((((((((((((((&###################
1153 ##########################%**@&**.%(((((((((((((((((((((((&#####################
1154 ########################&*#    &**%(((((((((((((((((((((%#######################
1155 #####################%**@    %******#((((((((((((((((&##########################
1156 ####################%/     &**********&((((((((((((%############################
1157 ##################&@     #***************#/&&%%@&###############################
1158 ##################****#***********************&#################################
1159 ##################/************************%####################################
1160 ##################%**********************&######################################
1161 ####################/*****************%#########################################
1162 ######################&************#/%##########################################
1163 ###########################%&&%#################################################
1164 ################################################################################
1165 ################################################################################
1166 ################################################################################
1167 ################################################################################
1168 ################################################################################
1169 ################################################################################                                       
1170            
1171             AkiraPills
1172                         Good for Health
1173                                         Bad for Education
1174 
1175 */
1176 
1177 pragma solidity ^0.8.0;
1178 
1179 contract AkiraPills is ERC721A, Ownable {
1180   using Strings for uint256;
1181 
1182   string private uriPrefix = "";
1183   string private uriSuffix = ".json";
1184   string public hiddenMetadataUri;
1185   
1186   uint256 public price = 0 ether; 
1187   uint256 public maxSupply = 2019; 
1188   uint256 public maxMintAmountPerTx = 2; 
1189   
1190   bool public paused = false;
1191   bool public revealed = false;
1192   mapping(address => uint256) public addressMintedBalance;
1193 
1194 
1195   constructor() ERC721A("AkiraPills", "AKP", maxMintAmountPerTx) {
1196     setHiddenMetadataUri("ipfs://QmTP18T6kHBR2t2C11LtmgN7PHsqxGTqyFeyGUbKXxVLBi");
1197   }
1198 
1199   modifier mintCompliance(uint256 _mintAmount) {
1200     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1201     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1202     _;
1203   }
1204 
1205   
1206    
1207   function PilltoAddress(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1208     _safeMint(_to, _mintAmount);
1209   }
1210 function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount)
1211    {
1212     require(!paused, "The contract is paused!");
1213     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1214     
1215     
1216     _safeMint(msg.sender, _mintAmount);
1217   }
1218  
1219   function walletOfOwner(address _owner)
1220     public
1221     view
1222     returns (uint256[] memory)
1223   {
1224     uint256 ownerTokenCount = balanceOf(_owner);
1225     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1226     uint256 currentTokenId = 0;
1227     uint256 ownedTokenIndex = 0;
1228 
1229     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1230       address currentTokenOwner = ownerOf(currentTokenId);
1231 
1232       if (currentTokenOwner == _owner) {
1233         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1234 
1235         ownedTokenIndex++;
1236       }
1237 
1238       currentTokenId++;
1239     }
1240 
1241     return ownedTokenIds;
1242   }
1243 
1244   function tokenURI(uint256 _tokenId)
1245     public
1246     view
1247     virtual
1248     override
1249     returns (string memory)
1250   {
1251     require(
1252       _exists(_tokenId),
1253       "ERC721Metadata: URI query for nonexistent token"
1254     );
1255 
1256     if (revealed == false) {
1257       return hiddenMetadataUri;
1258     }
1259 
1260     string memory currentBaseURI = _baseURI();
1261     return bytes(currentBaseURI).length > 0
1262         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1263         : "";
1264   }
1265 
1266   function setRevealed(bool _state) public onlyOwner {
1267     revealed = _state;
1268   
1269   }
1270 
1271   function setPrice(uint256 _price) public onlyOwner {
1272     price = _price;
1273 
1274   }
1275  
1276   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1277     hiddenMetadataUri = _hiddenMetadataUri;
1278   }
1279 
1280 
1281 
1282   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1283     uriPrefix = _uriPrefix;
1284   }
1285 
1286   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1287     uriSuffix = _uriSuffix;
1288   }
1289 
1290   function setPaused(bool _state) public onlyOwner {
1291     paused = _state;
1292   }
1293 
1294   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1295       _safeMint(_receiver, _mintAmount);
1296   }
1297 
1298   function _baseURI() internal view virtual override returns (string memory) {
1299     return uriPrefix;
1300     
1301   }
1302 
1303     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1304     maxMintAmountPerTx = _maxMintAmountPerTx;
1305 
1306   }
1307 
1308     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1309     maxSupply = _maxSupply;
1310 
1311   }
1312 
1313 
1314   
1315 
1316   function withdraw() public onlyOwner {
1317     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1318     require(os);
1319     
1320 
1321  
1322   }
1323   
1324 }