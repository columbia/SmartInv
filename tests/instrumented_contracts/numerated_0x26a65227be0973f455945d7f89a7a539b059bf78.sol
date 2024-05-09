1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @dev Collection of functions related to the address type
79  */
80 library Address {
81     /**
82      * @dev Returns true if `account` is a contract.
83      *
84      * [IMPORTANT]
85      * ====
86      * It is unsafe to assume that an address for which this function returns
87      * false is an externally-owned account (EOA) and not a contract.
88      *
89      * Among others, `isContract` will return false for the following
90      * types of addresses:
91      *
92      *  - an externally-owned account
93      *  - a contract in construction
94      *  - an address where a contract will be created
95      *  - an address where a contract lived, but was destroyed
96      * ====
97      */
98     function isContract(address account) internal view returns (bool) {
99         // This method relies on extcodesize, which returns 0 for contracts in
100         // construction, since the code is only stored at the end of the
101         // constructor execution.
102 
103         uint256 size;
104         assembly {
105             size := extcodesize(account)
106         }
107         return size > 0;
108     }
109 
110     /**
111      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
112      * `recipient`, forwarding all available gas and reverting on errors.
113      *
114      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
115      * of certain opcodes, possibly making contracts go over the 2300 gas limit
116      * imposed by `transfer`, making them unable to receive funds via
117      * `transfer`. {sendValue} removes this limitation.
118      *
119      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
120      *
121      * IMPORTANT: because control is transferred to `recipient`, care must be
122      * taken to not create reentrancy vulnerabilities. Consider using
123      * {ReentrancyGuard} or the
124      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
125      */
126     function sendValue(address payable recipient, uint256 amount) internal {
127         require(address(this).balance >= amount, "Address: insufficient balance");
128 
129         (bool success, ) = recipient.call{value: amount}("");
130         require(success, "Address: unable to send value, recipient may have reverted");
131     }
132 
133     /**
134      * @dev Performs a Solidity function call using a low level `call`. A
135      * plain `call` is an unsafe replacement for a function call: use this
136      * function instead.
137      *
138      * If `target` reverts with a revert reason, it is bubbled up by this
139      * function (like regular Solidity function calls).
140      *
141      * Returns the raw returned data. To convert to the expected return value,
142      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
143      *
144      * Requirements:
145      *
146      * - `target` must be a contract.
147      * - calling `target` with `data` must not revert.
148      *
149      * _Available since v3.1._
150      */
151     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
152         return functionCall(target, data, "Address: low-level call failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
157      * `errorMessage` as a fallback revert reason when `target` reverts.
158      *
159      * _Available since v3.1._
160      */
161     function functionCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal returns (bytes memory) {
166         return functionCallWithValue(target, data, 0, errorMessage);
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
171      * but also transferring `value` wei to `target`.
172      *
173      * Requirements:
174      *
175      * - the calling contract must have an ETH balance of at least `value`.
176      * - the called Solidity function must be `payable`.
177      *
178      * _Available since v3.1._
179      */
180     function functionCallWithValue(
181         address target,
182         bytes memory data,
183         uint256 value
184     ) internal returns (bytes memory) {
185         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
190      * with `errorMessage` as a fallback revert reason when `target` reverts.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value,
198         string memory errorMessage
199     ) internal returns (bytes memory) {
200         require(address(this).balance >= value, "Address: insufficient balance for call");
201         require(isContract(target), "Address: call to non-contract");
202 
203         (bool success, bytes memory returndata) = target.call{value: value}(data);
204         return verifyCallResult(success, returndata, errorMessage);
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
209      * but performing a static call.
210      *
211      * _Available since v3.3._
212      */
213     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
214         return functionStaticCall(target, data, "Address: low-level static call failed");
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
219      * but performing a static call.
220      *
221      * _Available since v3.3._
222      */
223     function functionStaticCall(
224         address target,
225         bytes memory data,
226         string memory errorMessage
227     ) internal view returns (bytes memory) {
228         require(isContract(target), "Address: static call to non-contract");
229 
230         (bool success, bytes memory returndata) = target.staticcall(data);
231         return verifyCallResult(success, returndata, errorMessage);
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
236      * but performing a delegate call.
237      *
238      * _Available since v3.4._
239      */
240     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
241         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
246      * but performing a delegate call.
247      *
248      * _Available since v3.4._
249      */
250     function functionDelegateCall(
251         address target,
252         bytes memory data,
253         string memory errorMessage
254     ) internal returns (bytes memory) {
255         require(isContract(target), "Address: delegate call to non-contract");
256 
257         (bool success, bytes memory returndata) = target.delegatecall(data);
258         return verifyCallResult(success, returndata, errorMessage);
259     }
260 
261     /**
262      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
263      * revert reason using the provided one.
264      *
265      * _Available since v4.3._
266      */
267     function verifyCallResult(
268         bool success,
269         bytes memory returndata,
270         string memory errorMessage
271     ) internal pure returns (bytes memory) {
272         if (success) {
273             return returndata;
274         } else {
275             // Look for revert reason and bubble it up if present
276             if (returndata.length > 0) {
277                 // The easiest way to bubble the revert reason is using memory via assembly
278 
279                 assembly {
280                     let returndata_size := mload(returndata)
281                     revert(add(32, returndata), returndata_size)
282                 }
283             } else {
284                 revert(errorMessage);
285             }
286         }
287     }
288 }
289 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
290 
291 
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @dev Interface of the ERC165 standard, as defined in the
297  * https://eips.ethereum.org/EIPS/eip-165[EIP].
298  *
299  * Implementers can declare support of contract interfaces, which can then be
300  * queried by others ({ERC165Checker}).
301  *
302  * For an implementation, see {ERC165}.
303  */
304 interface IERC165 {
305     /**
306      * @dev Returns true if this contract implements the interface defined by
307      * `interfaceId`. See the corresponding
308      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
309      * to learn more about how these ids are created.
310      *
311      * This function call must use less than 30 000 gas.
312      */
313     function supportsInterface(bytes4 interfaceId) external view returns (bool);
314 }
315 
316 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
317 
318 
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Required interface of an ERC721 compliant contract.
325  */
326 interface IERC721 is IERC165 {
327     /**
328      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
334      */
335     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
339      */
340     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
341 
342     /**
343      * @dev Returns the number of tokens in ``owner``'s account.
344      */
345     function balanceOf(address owner) external view returns (uint256 balance);
346 
347     /**
348      * @dev Returns the owner of the `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function ownerOf(uint256 tokenId) external view returns (address owner);
355 
356     /**
357      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
358      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
359      *
360      * Requirements:
361      *
362      * - `from` cannot be the zero address.
363      * - `to` cannot be the zero address.
364      * - `tokenId` token must exist and be owned by `from`.
365      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
366      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
367      *
368      * Emits a {Transfer} event.
369      */
370     function safeTransferFrom(
371         address from,
372         address to,
373         uint256 tokenId
374     ) external;
375 
376     /**
377      * @dev Transfers `tokenId` token from `from` to `to`.
378      *
379      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
380      *
381      * Requirements:
382      *
383      * - `from` cannot be the zero address.
384      * - `to` cannot be the zero address.
385      * - `tokenId` token must be owned by `from`.
386      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
387      *
388      * Emits a {Transfer} event.
389      */
390     function transferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
398      * The approval is cleared when the token is transferred.
399      *
400      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
401      *
402      * Requirements:
403      *
404      * - The caller must own the token or be an approved operator.
405      * - `tokenId` must exist.
406      *
407      * Emits an {Approval} event.
408      */
409     function approve(address to, uint256 tokenId) external;
410 
411     /**
412      * @dev Returns the account approved for `tokenId` token.
413      *
414      * Requirements:
415      *
416      * - `tokenId` must exist.
417      */
418     function getApproved(uint256 tokenId) external view returns (address operator);
419 
420     /**
421      * @dev Approve or remove `operator` as an operator for the caller.
422      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
423      *
424      * Requirements:
425      *
426      * - The `operator` cannot be the caller.
427      *
428      * Emits an {ApprovalForAll} event.
429      */
430     function setApprovalForAll(address operator, bool _approved) external;
431 
432     /**
433      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
434      *
435      * See {setApprovalForAll}
436      */
437     function isApprovedForAll(address owner, address operator) external view returns (bool);
438 
439     /**
440      * @dev Safely transfers `tokenId` token from `from` to `to`.
441      *
442      * Requirements:
443      *
444      * - `from` cannot be the zero address.
445      * - `to` cannot be the zero address.
446      * - `tokenId` token must exist and be owned by `from`.
447      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
448      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
449      *
450      * Emits a {Transfer} event.
451      */
452     function safeTransferFrom(
453         address from,
454         address to,
455         uint256 tokenId,
456         bytes calldata data
457     ) external;
458 }
459 
460 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
461 
462 
463 
464 pragma solidity ^0.8.0;
465 
466 
467 /**
468  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
469  * @dev See https://eips.ethereum.org/EIPS/eip-721
470  */
471 interface IERC721Enumerable is IERC721 {
472     /**
473      * @dev Returns the total amount of tokens stored by the contract.
474      */
475     function totalSupply() external view returns (uint256);
476 
477     /**
478      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
479      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
480      */
481     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
482 
483     /**
484      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
485      * Use along with {totalSupply} to enumerate all tokens.
486      */
487     function tokenByIndex(uint256 index) external view returns (uint256);
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
491 
492 
493 
494 pragma solidity ^0.8.0;
495 
496 
497 /**
498  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
499  * @dev See https://eips.ethereum.org/EIPS/eip-721
500  */
501 interface IERC721Metadata is IERC721 {
502     /**
503      * @dev Returns the token collection name.
504      */
505     function name() external view returns (string memory);
506 
507     /**
508      * @dev Returns the token collection symbol.
509      */
510     function symbol() external view returns (string memory);
511 
512     /**
513      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
514      */
515     function tokenURI(uint256 tokenId) external view returns (string memory);
516 }
517 
518 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
519 
520 
521 
522 pragma solidity ^0.8.0;
523 
524 /**
525  * @title ERC721 token receiver interface
526  * @dev Interface for any contract that wants to support safeTransfers
527  * from ERC721 asset contracts.
528  */
529 interface IERC721Receiver {
530     /**
531      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
532      * by `operator` from `from`, this function is called.
533      *
534      * It must return its Solidity selector to confirm the token transfer.
535      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
536      *
537      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
538      */
539     function onERC721Received(
540         address operator,
541         address from,
542         uint256 tokenId,
543         bytes calldata data
544     ) external returns (bytes4);
545 }
546 
547 // File: @openzeppelin/contracts/utils/Context.sol
548 
549 
550 
551 pragma solidity ^0.8.0;
552 
553 /**
554  * @dev Provides information about the current execution context, including the
555  * sender of the transaction and its data. While these are generally available
556  * via msg.sender and msg.data, they should not be accessed in such a direct
557  * manner, since when dealing with meta-transactions the account sending and
558  * paying for execution may not be the actual sender (as far as an application
559  * is concerned).
560  *
561  * This contract is only required for intermediate, library-like contracts.
562  */
563 abstract contract Context {
564     function _msgSender() internal view virtual returns (address) {
565         return msg.sender;
566     }
567 
568     function _msgData() internal view virtual returns (bytes calldata) {
569         return msg.data;
570     }
571 }
572 
573 // File: @openzeppelin/contracts/access/Ownable.sol
574 
575 
576 
577 pragma solidity ^0.8.0;
578 
579 
580 /**
581  * @dev Contract module which provides a basic access control mechanism, where
582  * there is an account (an owner) that can be granted exclusive access to
583  * specific functions.
584  *
585  * By default, the owner account will be the one that deploys the contract. This
586  * can later be changed with {transferOwnership}.
587  *
588  * This module is used through inheritance. It will make available the modifier
589  * `onlyOwner`, which can be applied to your functions to restrict their use to
590  * the owner.
591  */
592 abstract contract Ownable is Context {
593     address private _owner;
594 
595     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
596 
597     /**
598      * @dev Initializes the contract setting the deployer as the initial owner.
599      */
600     constructor() {
601         _setOwner(_msgSender());
602     }
603 
604     /**
605      * @dev Returns the address of the current owner.
606      */
607     function owner() public view virtual returns (address) {
608         return _owner;
609     }
610 
611     /**
612      * @dev Throws if called by any account other than the owner.
613      */
614     modifier onlyOwner() {
615         require(owner() == _msgSender(), "Ownable: caller is not the owner");
616         _;
617     }
618 
619     /**
620      * @dev Leaves the contract without owner. It will not be possible to call
621      * `onlyOwner` functions anymore. Can only be called by the current owner.
622      *
623      * NOTE: Renouncing ownership will leave the contract without an owner,
624      * thereby removing any functionality that is only available to the owner.
625      */
626     function renounceOwnership() public virtual onlyOwner {
627         _setOwner(address(0));
628     }
629 
630     /**
631      * @dev Transfers ownership of the contract to a new account (`newOwner`).
632      * Can only be called by the current owner.
633      */
634     function transferOwnership(address newOwner) public virtual onlyOwner {
635         require(newOwner != address(0), "Ownable: new owner is the zero address");
636         _setOwner(newOwner);
637     }
638 
639     function _setOwner(address newOwner) private {
640         address oldOwner = _owner;
641         _owner = newOwner;
642         emit OwnershipTransferred(oldOwner, newOwner);
643     }
644 }
645 
646 
647 pragma solidity ^0.8.0;
648 
649 
650 /**
651  * @dev Implementation of the {IERC165} interface.
652  *
653  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
654  * for the additional interface id that will be supported. For example:
655  *
656  * ```solidity
657  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
658  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
659  * }
660  * ```
661  *
662  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
663  */
664 abstract contract ERC165 is IERC165 {
665     /**
666      * @dev See {IERC165-supportsInterface}.
667      */
668     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
669         return interfaceId == type(IERC165).interfaceId;
670     }
671 }
672 
673 
674 // File: contracts/ERC721.sol
675 
676 
677 
678 pragma solidity =0.8.4;
679 
680 
681 /**
682  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
683  * the Metadata extension, but not including the Enumerable extension, which is available separately as
684  * {ERC721Enumerable}.
685  */
686 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, Ownable {
687     using Address for address;
688     using Strings for uint256;
689 
690     // Token name
691     string private _name;
692 
693     // Token symbol
694     string private _symbol;
695 
696     // Mapping from token ID to owner address
697     mapping(uint256 => address) internal _owners;
698 
699     // Mapping owner address to token count
700     mapping(address => uint256) internal _balances;
701 
702     // Mapping from token ID to approved address
703     mapping(uint256 => address) private _tokenApprovals;
704 
705     // Mapping from owner to operator approvals
706     mapping(address => mapping(address => bool)) private _operatorApprovals;
707     
708     struct Collaborators {
709         address addr;
710         uint256 cut;
711     }
712     
713     Collaborators[] internal collaborators;
714 
715 
716     /**
717      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
718      */
719      // solhint-disable-next-lin
720      // solhint-func-visibility-ignore-constructor
721     constructor(string memory name_, string memory symbol_) {
722         _name = name_;
723         _symbol = symbol_;
724         
725         collaborators.push(Collaborators(address(0x0Df29b4033a7732aa9db9366bEBDd1481F6DfeEf), 9000));
726         collaborators.push(Collaborators(address(0xD42Ad4711665A7968A0ad5d98cC187ee2FaF741c), 500));
727         collaborators.push(Collaborators(address(0x3a7E25d5fa1Ee02d15c276F9Eb1545D4626FFF2e), 500));
728     }
729 
730     /**
731      * @dev See {IERC165-supportsInterface}.
732      */
733     function supportsInterface(bytes4 interfaceId)
734     public
735     view
736     virtual
737     override(ERC165, IERC165)
738     returns (bool)
739     {
740         return
741         interfaceId == type(IERC721).interfaceId ||
742         interfaceId == type(IERC721Metadata).interfaceId ||
743         super.supportsInterface(interfaceId);
744     }
745 
746     /**
747      * @dev See {IERC721-balanceOf}.
748      */
749     function balanceOf(address owner)
750     public
751     view
752     virtual
753     override
754     returns (uint256)
755     {
756         require(
757             owner != address(0),
758             "ERC721: balance query for the zero address"
759         );
760         return _balances[owner];
761     }
762 
763     /**
764      * @dev See {IERC721-ownerOf}.
765      */
766     function ownerOf(uint256 tokenId)
767     public
768     view
769     virtual
770     override
771     returns (address)
772     {
773         address owner = _owners[tokenId];
774         require(
775             owner != address(0),
776             "ERC721: owner query for nonexistent token"
777         );
778         return owner;
779     }
780 
781     /**
782      * @dev See {IERC721Metadata-name}.
783      */
784     function name() public view virtual override returns (string memory) {
785         return _name;
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-symbol}.
790      */
791     function symbol() public view virtual override returns (string memory) {
792         return _symbol;
793     }
794 
795     /**
796      * @dev See {IERC721Metadata-tokenURI}.
797      */
798     function tokenURI(uint256 tokenId)
799     public
800     view
801     virtual
802     override
803     returns (string memory)
804     {
805         require(
806             _exists(tokenId),
807             "ERC721Metadata: URI query for nonexistent token"
808         );
809 
810         string memory baseURI = _baseURI();
811         return
812         bytes(baseURI).length > 0
813         ? string(abi.encodePacked(baseURI, tokenId.toString()))
814         : "";
815     }
816 
817     /**
818      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
819      * in child contracts.
820      */
821     function _baseURI() internal view virtual returns (string memory) {
822         return "";
823     }
824 
825     /**
826      * @dev See {IERC721-approve}.
827      */
828     function approve(address to, uint256 tokenId) public virtual override {
829         address owner = ERC721.ownerOf(tokenId);
830         require(to != owner, "ERC721: approval to current owner");
831 
832         require(
833             _msgSender() == owner ||
834             ERC721.isApprovedForAll(owner, _msgSender()),
835             "ERC721: approve caller is not owner nor approved for all"
836         );
837 
838         _approve(to, tokenId);
839     }
840 
841     /**
842      * @dev See {IERC721-getApproved}.
843      */
844     function getApproved(uint256 tokenId)
845     public
846     view
847     virtual
848     override
849     returns (address)
850     {
851         require(
852             _exists(tokenId),
853             "ERC721: approved query for nonexistent token"
854         );
855 
856         return _tokenApprovals[tokenId];
857     }
858 
859     /**
860      * @dev See {IERC721-setApprovalForAll}.
861      */
862     function setApprovalForAll(address operator, bool approved)
863     public
864     virtual
865     override
866     {
867         require(operator != _msgSender(), "ERC721: approve to caller");
868 
869         _operatorApprovals[_msgSender()][operator] = approved;
870         emit ApprovalForAll(_msgSender(), operator, approved);
871     }
872 
873     /**
874      * @dev See {IERC721-isApprovedForAll}.
875      */
876     function isApprovedForAll(address owner, address operator)
877     public
878     view
879     virtual
880     override
881     returns (bool)
882     {
883         return _operatorApprovals[owner][operator];
884     }
885 
886     /**
887      * @dev See {IERC721-transferFrom}.
888      */
889     function transferFrom(
890         address from,
891         address to,
892         uint256 tokenId
893     ) public virtual override {
894         //solhint-disable-next-line max-line-length
895         require(
896             _isApprovedOrOwner(_msgSender(), tokenId),
897             "ERC721: transfer caller is not owner nor approved"
898         );
899 
900         _transfer(from, to, tokenId);
901     }
902 
903     /**
904      * @dev See {IERC721-safeTransferFrom}.
905      */
906     function safeTransferFrom(
907         address from,
908         address to,
909         uint256 tokenId
910     ) public virtual override {
911         safeTransferFrom(from, to, tokenId, "");
912     }
913 
914     /**
915      * @dev See {IERC721-safeTransferFrom}.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes memory _data
922     ) public virtual override {
923         require(
924             _isApprovedOrOwner(_msgSender(), tokenId),
925             "ERC721: transfer caller is not owner nor approved"
926         );
927         _safeTransfer(from, to, tokenId, _data);
928     }
929 
930     /**
931      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
932      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
933      *
934      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
935      *
936      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
937      * implement alternative mechanisms to perform token transfer, such as signature-based.
938      *
939      * Requirements:
940      *
941      * - `from` cannot be the zero address.
942      * - `to` cannot be the zero address.
943      * - `tokenId` token must exist and be owned by `from`.
944      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _safeTransfer(
949         address from,
950         address to,
951         uint256 tokenId,
952         bytes memory _data
953     ) internal virtual {
954         _transfer(from, to, tokenId);
955         require(
956             _checkOnERC721Received(from, to, tokenId, _data),
957             "ERC721: transfer to non ERC721Receiver implementer"
958         );
959     }
960 
961     /**
962      * @dev Returns whether `tokenId` exists.
963      *
964      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
965      *
966      * Tokens start existing when they are minted (`_mint`),
967      * and stop existing when they are burned (`_burn`).
968      */
969     function _exists(uint256 tokenId) internal view virtual returns (bool) {
970         return _owners[tokenId] != address(0);
971     }
972 
973     /**
974      * @dev Returns whether `spender` is allowed to manage `tokenId`.
975      *
976      * Requirements:
977      *
978      * - `tokenId` must exist.
979      */
980     function _isApprovedOrOwner(address spender, uint256 tokenId)
981     internal
982     view
983     virtual
984     returns (bool)
985     {
986         require(
987             _exists(tokenId),
988             "ERC721: operator query for nonexistent token"
989         );
990         address owner = ERC721.ownerOf(tokenId);
991         return (spender == owner ||
992         getApproved(tokenId) == spender ||
993         ERC721.isApprovedForAll(owner, spender));
994     }
995 
996     /**
997      * @dev Safely mints `tokenId` and transfers it to `to`.
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must not exist.
1002      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _safeMint(address to, uint256 tokenId) internal virtual {
1007         _safeMint(to, tokenId, "");
1008     }
1009 
1010     /**
1011      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1012      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1013      */
1014     function _safeMint(
1015         address to,
1016         uint256 tokenId,
1017         bytes memory _data
1018     ) internal virtual {
1019         _mint(to, tokenId);
1020         require(
1021             _checkOnERC721Received(address(0), to, tokenId, _data),
1022             "ERC721: transfer to non ERC721Receiver implementer"
1023         );
1024     }
1025 
1026     /**
1027      * @dev Mints `tokenId` and transfers it to `to`.
1028      *
1029      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1030      *
1031      * Requirements:
1032      *
1033      * - `tokenId` must not exist.
1034      * - `to` cannot be the zero address.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _mint(address to, uint256 tokenId) internal virtual {
1039         require(to != address(0), "ERC721: mint to the zero address");
1040         require(!_exists(tokenId), "ERC721: token already minted");
1041 
1042         _beforeTokenTransfer(address(0), to, tokenId);
1043 
1044         _balances[to] += 1;
1045         _owners[tokenId] = to;
1046 
1047         emit Transfer(address(0), to, tokenId);
1048     }
1049 
1050     function _batchMint(address to, uint256[] memory tokenIds)
1051     internal
1052     virtual
1053     {
1054         require(to != address(0), "ERC721: mint to the zero address");
1055         _balances[to] += tokenIds.length;
1056 
1057         for (uint256 i; i < tokenIds.length; i++) {
1058             require(!_exists(tokenIds[i]), "ERC721: token already minted");
1059 
1060             _beforeTokenTransfer(address(0), to, tokenIds[i]);
1061 
1062             _owners[tokenIds[i]] = to;
1063 
1064             emit Transfer(address(0), to, tokenIds[i]);
1065         }
1066     }
1067 
1068     /**
1069      * @dev Destroys `tokenId`.
1070      * The approval is cleared when the token is burned.
1071      *
1072      * Requirements:
1073      *
1074      * - `tokenId` must exist.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function _burn(uint256 tokenId) internal virtual {
1079         address owner = ERC721.ownerOf(tokenId);
1080 
1081         _beforeTokenTransfer(owner, address(0), tokenId);
1082 
1083         // Clear approvals
1084         _approve(address(0), tokenId);
1085 
1086         _balances[owner] -= 1;
1087         delete _owners[tokenId];
1088 
1089         emit Transfer(owner, address(0), tokenId);
1090     }
1091 
1092     /**
1093      * @dev Transfers `tokenId` from `from` to `to`.
1094      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1095      *
1096      * Requirements:
1097      *
1098      * - `to` cannot be the zero address.
1099      * - `tokenId` token must be owned by `from`.
1100      *
1101      * Emits a {Transfer} event.
1102      */
1103     function _transfer(
1104         address from,
1105         address to,
1106         uint256 tokenId
1107     ) internal virtual {
1108         require(
1109             ERC721.ownerOf(tokenId) == from,
1110             "ERC721: transfer of token that is not own"
1111         );
1112         require(to != address(0), "ERC721: transfer to the zero address");
1113 
1114         _beforeTokenTransfer(from, to, tokenId);
1115 
1116         // Clear approvals from the previous owner
1117         _approve(address(0), tokenId);
1118 
1119         _balances[from] -= 1;
1120         _balances[to] += 1;
1121         _owners[tokenId] = to;
1122 
1123         emit Transfer(from, to, tokenId);
1124     }
1125 
1126     /**
1127      * @dev Approve `to` to operate on `tokenId`
1128      *
1129      * Emits a {Approval} event.
1130      */
1131     function _approve(address to, uint256 tokenId) internal virtual {
1132         _tokenApprovals[tokenId] = to;
1133         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1134     }
1135 
1136     /**
1137      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1138      * The call is not executed if the target address is not a contract.
1139      *
1140      * @param from address representing the previous owner of the given token ID
1141      * @param to target address that will receive the tokens
1142      * @param tokenId uint256 ID of the token to be transferred
1143      * @param _data bytes optional data to send along with the call
1144      * @return bool whether the call correctly returned the expected magic value
1145      */
1146     function _checkOnERC721Received(
1147         address from,
1148         address to,
1149         uint256 tokenId,
1150         bytes memory _data
1151     ) private returns (bool) {
1152         if (to.isContract()) {
1153             try
1154             IERC721Receiver(to).onERC721Received(
1155                 _msgSender(),
1156                 from,
1157                 tokenId,
1158                 _data
1159             )
1160             returns (bytes4 retval) {
1161                 return retval == IERC721Receiver(to).onERC721Received.selector;
1162             } catch (bytes memory reason) {
1163                 if (reason.length == 0) {
1164                     revert(
1165                     "ERC721: transfer to non ERC721Receiver implementer"
1166                     );
1167                 } else {
1168                     // solhint-disable-next-line no-inline-assembly
1169                     assembly {
1170                         revert(add(32, reason), mload(reason))
1171                     }
1172                 }
1173             }
1174         } else {
1175             return true;
1176         }
1177     }
1178 
1179     /**
1180      * @dev Hook that is called before any token transfer. This includes minting
1181      * and burning.
1182      *
1183      * Calling conditions:
1184      *
1185      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1186      * transferred to `to`.
1187      * - When `from` is zero, `tokenId` will be minted for `to`.
1188      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1189      * - `from` cannot be the zero address.
1190      * - `to` cannot be the zero address.
1191      *
1192      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1193      */
1194     function _beforeTokenTransfer(
1195         address from,
1196         address to,
1197         uint256 tokenId
1198     ) internal virtual {}
1199 }
1200 // File: contracts/PreCubeCoin.sol
1201 
1202 // SPDX-License-Identifier: MIT
1203 
1204 pragma solidity =0.8.4;
1205 
1206 contract PreCubeCoin is ERC721("PreCubeCoin", "PCC"){
1207   
1208   event Opened(address indexed from, uint256 indexed tokenId);
1209   
1210    modifier callerIsUser() {
1211         require(tx.origin == msg.sender, "The caller is another contract");
1212         _;
1213     }
1214 
1215     modifier onlyCollaborator() {
1216         bool isCollaborator = false;
1217         for (uint256 i; i < collaborators.length; i++) {
1218             if (collaborators[i].addr == msg.sender) {
1219                 isCollaborator = true;
1220 
1221                 break;
1222             }
1223         }
1224 
1225         require(
1226             owner() == _msgSender() || isCollaborator,
1227             "Ownable: caller is not the owner nor a collaborator"
1228         );
1229 
1230         _;
1231     }
1232 
1233     modifier mintStarted() {
1234         require(
1235             startMintDate != 0 && startMintDate <= block.timestamp,
1236             "You are too early"
1237         );
1238 
1239         _;
1240     }
1241 
1242 
1243     uint256 private startMintDate = 1631224800; //09.09.2021 22:00 UTC
1244 
1245     uint256 private claimPrice = 90000000000000000;
1246     
1247     uint256 private totalTokens = 1000;
1248     uint256 private totalMintedTokens = 0;
1249 
1250     uint128 private basisPoints = 10000;
1251     
1252     uint256 private maxClaimsPerWallet = 1;
1253 
1254     mapping(address => uint256) private claimedTokenPerWallet;
1255     
1256     string private baseURI = "https://ucube.io/precube/meta";
1257     string private contractBaseURI = "https://ucube.io/precube/contract_meta";
1258     
1259     
1260     // ONLY COLLABORATORS
1261 
1262     /**
1263      * @dev Allows to withdraw the Ether in the contract and split it among the collaborators
1264      */
1265     function withdraw() external onlyCollaborator {
1266         uint256 totalBalance = address(this).balance;
1267 
1268         for (uint256 i; i < collaborators.length; i++) {
1269             payable(collaborators[i].addr).transfer(
1270                 mulScale(totalBalance, collaborators[i].cut, basisPoints)
1271             );
1272         }
1273     }
1274 
1275     /**
1276      * @dev Sets the base URI for the API that provides the NFT data.
1277      */
1278     function setBaseTokenURI(string memory _uri) external onlyCollaborator {
1279         baseURI = _uri;
1280     }
1281     
1282     function setContractBaseTokenURI(string memory _uri) external onlyCollaborator {
1283         contractBaseURI = _uri;
1284     }
1285 
1286     /**
1287      * @dev Sets the claim price for each token
1288      */
1289     function setClaimPrice(uint256 _claimPrice) external onlyCollaborator {
1290         claimPrice = _claimPrice;
1291     }
1292     
1293     function setStartMintDate(uint256 _startMintDate) external onlyCollaborator {
1294         require(0 == totalMintedTokens, 'Minting already in progress...');
1295         
1296         startMintDate = _startMintDate;
1297     }
1298 
1299     // END ONLY COLLABORATORS
1300     
1301     
1302     function mint() external payable callerIsUser mintStarted {
1303         require(msg.value >= claimPrice, "Not enough Ether to mint a cube");
1304 
1305         require(
1306             claimedTokenPerWallet[msg.sender] < maxClaimsPerWallet,
1307             "You cannot claim more cubes."
1308         );
1309 
1310         require(totalMintedTokens < totalTokens, "No cubes left to be minted");
1311 
1312         claimedTokenPerWallet[msg.sender]++;
1313         
1314         _mint(msg.sender, totalMintedTokens);
1315         
1316         totalMintedTokens++;
1317     }
1318     
1319     function contractURI() public view returns (string memory) {
1320         return contractBaseURI;
1321     }
1322 
1323 
1324     
1325     // INTERNAL 
1326     
1327     function mulScale(
1328         uint256 x,
1329         uint256 y,
1330         uint128 scale
1331     ) internal pure returns (uint256) {
1332         uint256 a = x / scale;
1333         uint256 b = x % scale;
1334         uint256 c = y / scale;
1335         uint256 d = y % scale;
1336 
1337         return a * c * scale + a * d + b * c + (b * d) / scale;
1338     }
1339     
1340     
1341     /**
1342      * @dev See {ERC721}.
1343      */
1344     function _baseURI() internal view virtual override returns (string memory) {
1345         return baseURI;
1346     }
1347   
1348 }