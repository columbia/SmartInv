1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 //Developer Info:
5 //Written by Blockchainguy.net
6 //Email: info@blockchainguy.net
7 //Instagram: @sheraz.manzoor
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev String operations.
32  */
33 library Strings {
34     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
38      */
39     function toString(uint256 value) internal pure returns (string memory) {
40         // Inspired by OraclizeAPI's implementation - MIT licence
41         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
42 
43         if (value == 0) {
44             return "0";
45         }
46         uint256 temp = value;
47         uint256 digits;
48         while (temp != 0) {
49             digits++;
50             temp /= 10;
51         }
52         bytes memory buffer = new bytes(digits);
53         while (value != 0) {
54             digits -= 1;
55             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
56             value /= 10;
57         }
58         return string(buffer);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
63      */
64     function toHexString(uint256 value) internal pure returns (string memory) {
65         if (value == 0) {
66             return "0x00";
67         }
68         uint256 temp = value;
69         uint256 length = 0;
70         while (temp != 0) {
71             length++;
72             temp >>= 8;
73         }
74         return toHexString(value, length);
75     }
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
79      */
80     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
81         bytes memory buffer = new bytes(2 * length + 2);
82         buffer[0] = "0";
83         buffer[1] = "x";
84         for (uint256 i = 2 * length + 1; i > 1; --i) {
85             buffer[i] = _HEX_SYMBOLS[value & 0xf];
86             value >>= 4;
87         }
88         require(value == 0, "Strings: hex length insufficient");
89         return string(buffer);
90     }
91 }
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Collection of functions related to the address type
96  */
97 library Address {
98     /**
99      * @dev Returns true if `account` is a contract.
100      *
101      * [IMPORTANT]
102      * ====
103      * It is unsafe to assume that an address for which this function returns
104      * false is an externally-owned account (EOA) and not a contract.
105      *
106      * Among others, `isContract` will return false for the following
107      * types of addresses:
108      *
109      *  - an externally-owned account
110      *  - a contract in construction
111      *  - an address where a contract will be created
112      *  - an address where a contract lived, but was destroyed
113      * ====
114      */
115     function isContract(address account) internal view returns (bool) {
116         // This method relies on extcodesize, which returns 0 for contracts in
117         // construction, since the code is only stored at the end of the
118         // constructor execution.
119 
120         uint256 size;
121         assembly {
122             size := extcodesize(account)
123         }
124         return size > 0;
125     }
126 
127     /**
128      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
129      * `recipient`, forwarding all available gas and reverting on errors.
130      *
131      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
132      * of certain opcodes, possibly making contracts go over the 2300 gas limit
133      * imposed by `transfer`, making them unable to receive funds via
134      * `transfer`. {sendValue} removes this limitation.
135      *
136      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
137      *
138      * IMPORTANT: because control is transferred to `recipient`, care must be
139      * taken to not create reentrancy vulnerabilities. Consider using
140      * {ReentrancyGuard} or the
141      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
142      */
143     function sendValue(address payable recipient, uint256 amount) internal {
144         require(address(this).balance >= amount, "Address: insufficient balance");
145 
146         (bool success, ) = recipient.call{value: amount}("");
147         require(success, "Address: unable to send value, recipient may have reverted");
148     }
149 
150     /**
151      * @dev Performs a Solidity function call using a low level `call`. A
152      * plain `call` is an unsafe replacement for a function call: use this
153      * function instead.
154      *
155      * If `target` reverts with a revert reason, it is bubbled up by this
156      * function (like regular Solidity function calls).
157      *
158      * Returns the raw returned data. To convert to the expected return value,
159      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
160      *
161      * Requirements:
162      *
163      * - `target` must be a contract.
164      * - calling `target` with `data` must not revert.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
169         return functionCall(target, data, "Address: low-level call failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
174      * `errorMessage` as a fallback revert reason when `target` reverts.
175      *
176      * _Available since v3.1._
177      */
178     function functionCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         return functionCallWithValue(target, data, 0, errorMessage);
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
188      * but also transferring `value` wei to `target`.
189      *
190      * Requirements:
191      *
192      * - the calling contract must have an ETH balance of at least `value`.
193      * - the called Solidity function must be `payable`.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(
198         address target,
199         bytes memory data,
200         uint256 value
201     ) internal returns (bytes memory) {
202         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
207      * with `errorMessage` as a fallback revert reason when `target` reverts.
208      *
209      * _Available since v3.1._
210      */
211     function functionCallWithValue(
212         address target,
213         bytes memory data,
214         uint256 value,
215         string memory errorMessage
216     ) internal returns (bytes memory) {
217         require(address(this).balance >= value, "Address: insufficient balance for call");
218         require(isContract(target), "Address: call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.call{value: value}(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
226      * but performing a static call.
227      *
228      * _Available since v3.3._
229      */
230     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
231         return functionStaticCall(target, data, "Address: low-level static call failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
236      * but performing a static call.
237      *
238      * _Available since v3.3._
239      */
240     function functionStaticCall(
241         address target,
242         bytes memory data,
243         string memory errorMessage
244     ) internal view returns (bytes memory) {
245         require(isContract(target), "Address: static call to non-contract");
246 
247         (bool success, bytes memory returndata) = target.staticcall(data);
248         return verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
253      * but performing a delegate call.
254      *
255      * _Available since v3.4._
256      */
257     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
258         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
263      * but performing a delegate call.
264      *
265      * _Available since v3.4._
266      */
267     function functionDelegateCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         require(isContract(target), "Address: delegate call to non-contract");
273 
274         (bool success, bytes memory returndata) = target.delegatecall(data);
275         return verifyCallResult(success, returndata, errorMessage);
276     }
277 
278     /**
279      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
280      * revert reason using the provided one.
281      *
282      * _Available since v4.3._
283      */
284     function verifyCallResult(
285         bool success,
286         bytes memory returndata,
287         string memory errorMessage
288     ) internal pure returns (bytes memory) {
289         if (success) {
290             return returndata;
291         } else {
292             // Look for revert reason and bubble it up if present
293             if (returndata.length > 0) {
294                 // The easiest way to bubble the revert reason is using memory via assembly
295 
296                 assembly {
297                     let returndata_size := mload(returndata)
298                     revert(add(32, returndata), returndata_size)
299                 }
300             } else {
301                 revert(errorMessage);
302             }
303         }
304     }
305 }
306 pragma solidity ^0.8.0;
307 
308 /**
309  * @dev Interface of the ERC165 standard, as defined in the
310  * https://eips.ethereum.org/EIPS/eip-165[EIP].
311  *
312  * Implementers can declare support of contract interfaces, which can then be
313  * queried by others ({ERC165Checker}).
314  *
315  * For an implementation, see {ERC165}.
316  */
317 interface IERC165 {
318     /**
319      * @dev Returns true if this contract implements the interface defined by
320      * `interfaceId`. See the corresponding
321      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
322      * to learn more about how these ids are created.
323      *
324      * This function call must use less than 30 000 gas.
325      */
326     function supportsInterface(bytes4 interfaceId) external view returns (bool);
327 }
328 pragma solidity ^0.8.0;
329 
330 /**
331  * @title ERC721 token receiver interface
332  * @dev Interface for any contract that wants to support safeTransfers
333  * from ERC721 asset contracts.
334  */
335 interface IERC721Receiver {
336     /**
337      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
338      * by `operator` from `from`, this function is called.
339      *
340      * It must return its Solidity selector to confirm the token transfer.
341      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
342      *
343      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
344      */
345     function onERC721Received(
346         address operator,
347         address from,
348         uint256 tokenId,
349         bytes calldata data
350     ) external returns (bytes4);
351 }
352 pragma solidity ^0.8.0;
353 
354 
355 /**
356  * @dev Contract module which provides a basic access control mechanism, where
357  * there is an account (an owner) that can be granted exclusive access to
358  * specific functions.
359  *
360  * By default, the owner account will be the one that deploys the contract. This
361  * can later be changed with {transferOwnership}.
362  *
363  * This module is used through inheritance. It will make available the modifier
364  * `onlyOwner`, which can be applied to your functions to restrict their use to
365  * the owner.
366  */
367 abstract contract Ownable is Context {
368     address private _owner;
369 
370     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
371 
372     /**
373      * @dev Initializes the contract setting the deployer as the initial owner.
374      */
375     constructor() {
376         _setOwner(_msgSender());
377     }
378 
379     /**
380      * @dev Returns the address of the current owner.
381      */
382     function owner() public view virtual returns (address) {
383         return _owner;
384     }
385 
386     /**
387      * @dev Throws if called by any account other than the owner.
388      */
389     modifier onlyOwner() {
390         require(owner() == _msgSender(), "Ownable: caller is not the owner");
391         _;
392     }
393 
394     /**
395      * @dev Leaves the contract without owner. It will not be possible to call
396      * `onlyOwner` functions anymore. Can only be called by the current owner.
397      *
398      * NOTE: Renouncing ownership will leave the contract without an owner,
399      * thereby removing any functionality that is only available to the owner.
400      */
401     function renounceOwnership() public virtual onlyOwner {
402         _setOwner(address(0));
403     }
404 
405     /**
406      * @dev Transfers ownership of the contract to a new account (`newOwner`).
407      * Can only be called by the current owner.
408      */
409     function transferOwnership(address newOwner) public virtual onlyOwner {
410         require(newOwner != address(0), "Ownable: new owner is the zero address");
411         _setOwner(newOwner);
412     }
413 
414     function _setOwner(address newOwner) private {
415         address oldOwner = _owner;
416         _owner = newOwner;
417         emit OwnershipTransferred(oldOwner, newOwner);
418     }
419 }
420 pragma solidity ^0.8.0;
421 
422 
423 /**
424  * @dev Implementation of the {IERC165} interface.
425  *
426  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
427  * for the additional interface id that will be supported. For example:
428  *
429  * ```solidity
430  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
431  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
432  * }
433  * ```
434  *
435  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
436  */
437 abstract contract ERC165 is IERC165 {
438     /**
439      * @dev See {IERC165-supportsInterface}.
440      */
441     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
442         return interfaceId == type(IERC165).interfaceId;
443     }
444 }
445 pragma solidity ^0.8.0;
446 
447 
448 /**
449  * @dev Required interface of an ERC721 compliant contract.
450  */
451 interface IERC721 is IERC165 {
452     /**
453      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
454      */
455     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
456 
457     /**
458      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
459      */
460     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
461 
462     /**
463      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
464      */
465     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
466 
467     /**
468      * @dev Returns the number of tokens in ``owner``'s account.
469      */
470     function balanceOf(address owner) external view returns (uint256 balance);
471 
472     /**
473      * @dev Returns the owner of the `tokenId` token.
474      *
475      * Requirements:
476      *
477      * - `tokenId` must exist.
478      */
479     function ownerOf(uint256 tokenId) external view returns (address owner);
480 
481     /**
482      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
483      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
484      *
485      * Requirements:
486      *
487      * - `from` cannot be the zero address.
488      * - `to` cannot be the zero address.
489      * - `tokenId` token must exist and be owned by `from`.
490      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
491      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
492      *
493      * Emits a {Transfer} event.
494      */
495     function safeTransferFrom(
496         address from,
497         address to,
498         uint256 tokenId
499     ) external;
500 
501     /**
502      * @dev Transfers `tokenId` token from `from` to `to`.
503      *
504      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
505      *
506      * Requirements:
507      *
508      * - `from` cannot be the zero address.
509      * - `to` cannot be the zero address.
510      * - `tokenId` token must be owned by `from`.
511      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
512      *
513      * Emits a {Transfer} event.
514      */
515     function transferFrom(
516         address from,
517         address to,
518         uint256 tokenId
519     ) external;
520 
521     /**
522      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
523      * The approval is cleared when the token is transferred.
524      *
525      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
526      *
527      * Requirements:
528      *
529      * - The caller must own the token or be an approved operator.
530      * - `tokenId` must exist.
531      *
532      * Emits an {Approval} event.
533      */
534     function approve(address to, uint256 tokenId) external;
535 
536     /**
537      * @dev Returns the account approved for `tokenId` token.
538      *
539      * Requirements:
540      *
541      * - `tokenId` must exist.
542      */
543     function getApproved(uint256 tokenId) external view returns (address operator);
544 
545     /**
546      * @dev Approve or remove `operator` as an operator for the caller.
547      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
548      *
549      * Requirements:
550      *
551      * - The `operator` cannot be the caller.
552      *
553      * Emits an {ApprovalForAll} event.
554      */
555     function setApprovalForAll(address operator, bool _approved) external;
556 
557     /**
558      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
559      *
560      * See {setApprovalForAll}
561      */
562     function isApprovedForAll(address owner, address operator) external view returns (bool);
563 
564     /**
565      * @dev Safely transfers `tokenId` token from `from` to `to`.
566      *
567      * Requirements:
568      *
569      * - `from` cannot be the zero address.
570      * - `to` cannot be the zero address.
571      * - `tokenId` token must exist and be owned by `from`.
572      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
573      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
574      *
575      * Emits a {Transfer} event.
576      */
577     function safeTransferFrom(
578         address from,
579         address to,
580         uint256 tokenId,
581         bytes calldata data
582     ) external;
583 }
584 pragma solidity ^0.8.0;
585 
586 
587 /**
588  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
589  * @dev See https://eips.ethereum.org/EIPS/eip-721
590  */
591 interface IERC721Metadata is IERC721 {
592     /**
593      * @dev Returns the token collection name.
594      */
595     function name() external view returns (string memory);
596 
597     /**
598      * @dev Returns the token collection symbol.
599      */
600     function symbol() external view returns (string memory);
601 
602     /**
603      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
604      */
605     function tokenURI(uint256 tokenId) external view returns (string memory);
606 }
607 interface IERC721Enumerable is IERC721 {
608     /**
609      * @dev Returns the total amount of tokens stored by the contract.
610      */
611     function totalSupply() external view returns (uint256);
612 
613     /**
614      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
615      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
616      */
617     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
618 
619     /**
620      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
621      * Use along with {totalSupply} to enumerate all tokens.
622      */
623     function tokenByIndex(uint256 index) external view returns (uint256);
624 }
625 error ApprovalCallerNotOwnerNorApproved();
626 error ApprovalQueryForNonexistentToken();
627 error ApproveToCaller();
628 error ApprovalToCurrentOwner();
629 error BalanceQueryForZeroAddress();
630 error MintedQueryForZeroAddress();
631 error BurnedQueryForZeroAddress();
632 error AuxQueryForZeroAddress();
633 error MintToZeroAddress();
634 error MintZeroQuantity();
635 error OwnerIndexOutOfBounds();
636 error OwnerQueryForNonexistentToken();
637 error TokenIndexOutOfBounds();
638 error TransferCallerNotOwnerNorApproved();
639 error TransferFromIncorrectOwner();
640 error TransferToNonERC721ReceiverImplementer();
641 error TransferToZeroAddress();
642 error URIQueryForNonexistentToken();
643 
644 /**
645  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
646  * the Metadata extension. Built to optimize for lower gas during batch mints.
647  *
648  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
649  *
650  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
651  *
652  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
653  */
654 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
655     using Address for address;
656     using Strings for uint256;
657 
658     // Compiler will pack this into a single 256bit word.
659     struct TokenOwnership {
660         // The address of the owner.
661         address addr;
662         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
663         uint64 startTimestamp;
664         // Whether the token has been burned.
665         bool burned;
666     }
667 
668     // Compiler will pack this into a single 256bit word.
669     struct AddressData {
670         // Realistically, 2**64-1 is more than enough.
671         uint64 balance;
672         // Keeps track of mint count with minimal overhead for tokenomics.
673         uint64 numberMinted;
674         // Keeps track of burn count with minimal overhead for tokenomics.
675         uint64 numberBurned;
676         // For miscellaneous variable(s) pertaining to the address
677         // (e.g. number of whitelist mint slots used). 
678         // If there are multiple variables, please pack them into a uint64.
679         uint64 aux;
680     }
681 
682     // The tokenId of the next token to be minted.
683     uint256 internal _currentIndex = 1;
684 
685     // The number of tokens burned.
686     uint256 internal _burnCounter;
687 
688     // Token name
689     string private _name;
690 
691     // Token symbol
692     string private _symbol;
693 
694     // Mapping from token ID to ownership details
695     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
696     mapping(uint256 => TokenOwnership) internal _ownerships;
697 
698     // Mapping owner address to address data
699     mapping(address => AddressData) private _addressData;
700 
701     // Mapping from token ID to approved address
702     mapping(uint256 => address) private _tokenApprovals;
703 
704     // Mapping from owner to operator approvals
705     mapping(address => mapping(address => bool)) private _operatorApprovals;
706 
707     constructor(string memory name_, string memory symbol_) {
708         _name = name_;
709         _symbol = symbol_;
710     }
711 
712     /**
713      * @dev See {IERC721Enumerable-totalSupply}.
714      */
715     function totalSupply() public view returns (uint256) {
716         // Counter underflow is impossible as _burnCounter cannot be incremented
717         // more than _currentIndex times
718         unchecked {
719             return (_currentIndex - _burnCounter) - 1;    
720         }
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
736     function balanceOf(address owner) public view override returns (uint256) {
737         if (owner == address(0)) revert BalanceQueryForZeroAddress();
738         return uint256(_addressData[owner].balance);
739     }
740 
741     /**
742      * Returns the number of tokens minted by `owner`.
743      */
744     function _numberMinted(address owner) internal view returns (uint256) {
745         if (owner == address(0)) revert MintedQueryForZeroAddress();
746         return uint256(_addressData[owner].numberMinted);
747     }
748 
749     /**
750      * Returns the number of tokens burned by or on behalf of `owner`.
751      */
752     function _numberBurned(address owner) internal view returns (uint256) {
753         if (owner == address(0)) revert BurnedQueryForZeroAddress();
754         return uint256(_addressData[owner].numberBurned);
755     }
756 
757     /**
758      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
759      */
760     function _getAux(address owner) internal view returns (uint64) {
761         if (owner == address(0)) revert AuxQueryForZeroAddress();
762         return _addressData[owner].aux;
763     }
764 
765     /**
766      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
767      * If there are multiple variables, please pack them into a uint64.
768      */
769     function _setAux(address owner, uint64 aux) internal {
770         if (owner == address(0)) revert AuxQueryForZeroAddress();
771         _addressData[owner].aux = aux;
772     }
773 
774     /**
775      * Gas spent here starts off proportional to the maximum mint batch size.
776      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
777      */
778     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
779         uint256 curr = tokenId;
780 
781         unchecked {
782             if (curr < _currentIndex) {
783                 TokenOwnership memory ownership = _ownerships[curr];
784                 if (!ownership.burned) {
785                     if (ownership.addr != address(0)) {
786                         return ownership;
787                     }
788                     // Invariant: 
789                     // There will always be an ownership that has an address and is not burned 
790                     // before an ownership that does not have an address and is not burned.
791                     // Hence, curr will not underflow.
792                     while (true) {
793                         curr--;
794                         ownership = _ownerships[curr];
795                         if (ownership.addr != address(0)) {
796                             return ownership;
797                         }
798                     }
799                 }
800             }
801         }
802         revert OwnerQueryForNonexistentToken();
803     }
804 
805     /**
806      * @dev See {IERC721-ownerOf}.
807      */
808     function ownerOf(uint256 tokenId) public view override returns (address) {
809         return ownershipOf(tokenId).addr;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-name}.
814      */
815     function name() public view virtual override returns (string memory) {
816         return _name;
817     }
818 
819     /**
820      * @dev See {IERC721Metadata-symbol}.
821      */
822     function symbol() public view virtual override returns (string memory) {
823         return _symbol;
824     }
825 
826     /**
827      * @dev See {IERC721Metadata-tokenURI}.
828      */
829     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
830         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
831 
832         string memory baseURI = _baseURI();
833         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
834     }
835 
836     /**
837      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
838      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
839      * by default, can be overriden in child contracts.
840      */
841     function _baseURI() internal view virtual returns (string memory) {
842         return '';
843     }
844 
845     /**
846      * @dev See {IERC721-approve}.
847      */
848     function approve(address to, uint256 tokenId) public override {
849         address owner = ERC721A.ownerOf(tokenId);
850         if (to == owner) revert ApprovalToCurrentOwner();
851 
852         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
853             revert ApprovalCallerNotOwnerNorApproved();
854         }
855 
856         _approve(to, tokenId, owner);
857     }
858 
859     /**
860      * @dev See {IERC721-getApproved}.
861      */
862     function getApproved(uint256 tokenId) public view override returns (address) {
863         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
864 
865         return _tokenApprovals[tokenId];
866     }
867 
868     /**
869      * @dev See {IERC721-setApprovalForAll}.
870      */
871     function setApprovalForAll(address operator, bool approved) public override {
872         if (operator == _msgSender()) revert ApproveToCaller();
873 
874         _operatorApprovals[_msgSender()][operator] = approved;
875         emit ApprovalForAll(_msgSender(), operator, approved);
876     }
877 
878     /**
879      * @dev See {IERC721-isApprovedForAll}.
880      */
881     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
882         return _operatorApprovals[owner][operator];
883     }
884 
885     /**
886      * @dev See {IERC721-transferFrom}.
887      */
888     function transferFrom(
889         address from,
890         address to,
891         uint256 tokenId
892     ) public virtual override {
893         _transfer(from, to, tokenId);
894     }
895 
896     /**
897      * @dev See {IERC721-safeTransferFrom}.
898      */
899     function safeTransferFrom(
900         address from,
901         address to,
902         uint256 tokenId
903     ) public virtual override {
904         safeTransferFrom(from, to, tokenId, '');
905     }
906 
907     /**
908      * @dev See {IERC721-safeTransferFrom}.
909      */
910     function safeTransferFrom(
911         address from,
912         address to,
913         uint256 tokenId,
914         bytes memory _data
915     ) public virtual override {
916         _transfer(from, to, tokenId);
917         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
918             revert TransferToNonERC721ReceiverImplementer();
919         }
920     }
921 
922     /**
923      * @dev Returns whether `tokenId` exists.
924      *
925      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
926      *
927      * Tokens start existing when they are minted (`_mint`),
928      */
929     function _exists(uint256 tokenId) internal view returns (bool) {
930         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
931     }
932 
933     function _safeMint(address to, uint256 quantity) internal {
934         _safeMint(to, quantity, '');
935     }
936 
937     /**
938      * @dev Safely mints `quantity` tokens and transfers them to `to`.
939      *
940      * Requirements:
941      *
942      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
943      * - `quantity` must be greater than 0.
944      *
945      * Emits a {Transfer} event.
946      */
947     function _safeMint(
948         address to,
949         uint256 quantity,
950         bytes memory _data
951     ) internal {
952         _mint(to, quantity, _data, true);
953     }
954 
955     /**
956      * @dev Mints `quantity` tokens and transfers them to `to`.
957      *
958      * Requirements:
959      *
960      * - `to` cannot be the zero address.
961      * - `quantity` must be greater than 0.
962      *
963      * Emits a {Transfer} event.
964      */
965     function _mint(
966         address to,
967         uint256 quantity,
968         bytes memory _data,
969         bool safe
970     ) internal {
971         uint256 startTokenId = _currentIndex;
972         if (to == address(0)) revert MintToZeroAddress();
973         if (quantity == 0) revert MintZeroQuantity();
974 
975         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
976 
977         // Overflows are incredibly unrealistic.
978         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
979         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
980         unchecked {
981             _addressData[to].balance += uint64(quantity);
982             _addressData[to].numberMinted += uint64(quantity);
983 
984             _ownerships[startTokenId].addr = to;
985             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
986 
987             uint256 updatedIndex = startTokenId;
988 
989             for (uint256 i; i < quantity; i++) {
990                 emit Transfer(address(0), to, updatedIndex);
991                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
992                     revert TransferToNonERC721ReceiverImplementer();
993                 }
994                 updatedIndex++;
995             }
996 
997             _currentIndex = updatedIndex;
998         }
999         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1000     }
1001 
1002     /**
1003      * @dev Transfers `tokenId` from `from` to `to`.
1004      *
1005      * Requirements:
1006      *
1007      * - `to` cannot be the zero address.
1008      * - `tokenId` token must be owned by `from`.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function _transfer(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) private {
1017         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1018 
1019         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1020             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1021             getApproved(tokenId) == _msgSender());
1022 
1023         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1024         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1025         if (to == address(0)) revert TransferToZeroAddress();
1026 
1027         _beforeTokenTransfers(from, to, tokenId, 1);
1028 
1029         // Clear approvals from the previous owner
1030         _approve(address(0), tokenId, prevOwnership.addr);
1031 
1032         // Underflow of the sender's balance is impossible because we check for
1033         // ownership above and the recipient's balance can't realistically overflow.
1034         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1035         unchecked {
1036             _addressData[from].balance -= 1;
1037             _addressData[to].balance += 1;
1038 
1039             _ownerships[tokenId].addr = to;
1040             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1041 
1042             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1043             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1044             uint256 nextTokenId = tokenId + 1;
1045             if (_ownerships[nextTokenId].addr == address(0)) {
1046                 // This will suffice for checking _exists(nextTokenId),
1047                 // as a burned slot cannot contain the zero address.
1048                 if (nextTokenId < _currentIndex) {
1049                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1050                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1051                 }
1052             }
1053         }
1054 
1055         emit Transfer(from, to, tokenId);
1056         _afterTokenTransfers(from, to, tokenId, 1);
1057     }
1058 
1059     /**
1060      * @dev Destroys `tokenId`.
1061      * The approval is cleared when the token is burned.
1062      *
1063      * Requirements:
1064      *
1065      * - `tokenId` must exist.
1066      *
1067      * Emits a {Transfer} event.
1068      */
1069     function _burn(uint256 tokenId) internal virtual {
1070         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1071 
1072         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1073 
1074         // Clear approvals from the previous owner
1075         _approve(address(0), tokenId, prevOwnership.addr);
1076 
1077         // Underflow of the sender's balance is impossible because we check for
1078         // ownership above and the recipient's balance can't realistically overflow.
1079         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1080         unchecked {
1081             _addressData[prevOwnership.addr].balance -= 1;
1082             _addressData[prevOwnership.addr].numberBurned += 1;
1083 
1084             // Keep track of who burned the token, and the timestamp of burning.
1085             _ownerships[tokenId].addr = prevOwnership.addr;
1086             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1087             _ownerships[tokenId].burned = true;
1088 
1089             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1090             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1091             uint256 nextTokenId = tokenId + 1;
1092             if (_ownerships[nextTokenId].addr == address(0)) {
1093                 // This will suffice for checking _exists(nextTokenId),
1094                 // as a burned slot cannot contain the zero address.
1095                 if (nextTokenId < _currentIndex) {
1096                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1097                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1098                 }
1099             }
1100         }
1101 
1102         emit Transfer(prevOwnership.addr, address(0), tokenId);
1103         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1104 
1105         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1106         unchecked { 
1107             _burnCounter++;
1108         }
1109     }
1110 
1111     /**
1112      * @dev Approve `to` to operate on `tokenId`
1113      *
1114      * Emits a {Approval} event.
1115      */
1116     function _approve(
1117         address to,
1118         uint256 tokenId,
1119         address owner
1120     ) private {
1121         _tokenApprovals[tokenId] = to;
1122         emit Approval(owner, to, tokenId);
1123     }
1124 
1125     /**
1126      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1127      * The call is not executed if the target address is not a contract.
1128      *
1129      * @param from address representing the previous owner of the given token ID
1130      * @param to target address that will receive the tokens
1131      * @param tokenId uint256 ID of the token to be transferred
1132      * @param _data bytes optional data to send along with the call
1133      * @return bool whether the call correctly returned the expected magic value
1134      */
1135     function _checkOnERC721Received(
1136         address from,
1137         address to,
1138         uint256 tokenId,
1139         bytes memory _data
1140     ) private returns (bool) {
1141         if (to.isContract()) {
1142             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1143                 return retval == IERC721Receiver(to).onERC721Received.selector;
1144             } catch (bytes memory reason) {
1145                 if (reason.length == 0) {
1146                     revert TransferToNonERC721ReceiverImplementer();
1147                 } else {
1148                     assembly {
1149                         revert(add(32, reason), mload(reason))
1150                     }
1151                 }
1152             }
1153         } else {
1154             return true;
1155         }
1156     }
1157 
1158     /**
1159      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1160      * And also called before burning one token.
1161      *
1162      * startTokenId - the first token id to be transferred
1163      * quantity - the amount to be transferred
1164      *
1165      * Calling conditions:
1166      *
1167      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1168      * transferred to `to`.
1169      * - When `from` is zero, `tokenId` will be minted for `to`.
1170      * - When `to` is zero, `tokenId` will be burned by `from`.
1171      * - `from` and `to` are never both zero.
1172      */
1173     function _beforeTokenTransfers(
1174         address from,
1175         address to,
1176         uint256 startTokenId,
1177         uint256 quantity
1178     ) internal virtual {}
1179 
1180     /**
1181      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1182      * minting.
1183      * And also called after one token has been burned.
1184      *
1185      * startTokenId - the first token id to be transferred
1186      * quantity - the amount to be transferred
1187      *
1188      * Calling conditions:
1189      *
1190      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1191      * transferred to `to`.
1192      * - When `from` is zero, `tokenId` has been minted for `to`.
1193      * - When `to` is zero, `tokenId` has been burned by `from`.
1194      * - `from` and `to` are never both zero.
1195      */
1196     function _afterTokenTransfers(
1197         address from,
1198         address to,
1199         uint256 startTokenId,
1200         uint256 quantity
1201     ) internal virtual {}
1202 }
1203 
1204 
1205 contract TheHabAIbiz is Ownable, ERC721A {
1206 
1207     uint256 public maxPerTransaction = 10;
1208     uint256 public maxInAddress = 10;
1209 
1210     using Strings for uint256;
1211 
1212     mapping(uint256 => string) private _tokenURIs;
1213 
1214     bool public publicSaleState = true;
1215 
1216     string public baseURI = "";
1217     string public _extension = ".json";
1218     string public hiddenMetadataUri = "ipfs://QmXiJbpRRx27jgUgYugzhWEviU7Q1iZm7osWFFr2R9gLgW/";
1219     bool public revealed = false; 
1220     uint256 public price =  0.005 ether;
1221 
1222     uint256 public maxSupply = 4900;
1223 
1224     
1225     mapping(uint => uint256) public voucherIds;
1226     constructor() ERC721A("The HabAIbiz", "TH"){}
1227     
1228     function mintNFT(uint256 _quantity) public payable {
1229         require(_quantity > 0 && _quantity <= maxPerTransaction, "Wrong Quantity.");
1230         require(totalSupply() + _quantity <= maxSupply, "Reaching max supply");
1231         require(getMintedCount(msg.sender) + _quantity <= maxInAddress, "Exceed max minting amount");
1232         require(publicSaleState, "Public Sale Not Started Yet!");
1233 
1234         if(totalSupply() > 900){
1235             require(msg.value == price * _quantity, "Needs to send more eth");
1236         }
1237 
1238         _safeMint(msg.sender, _quantity);
1239 
1240     }
1241 
1242 
1243     function sendGifts(address[] memory _wallets) external onlyOwner{
1244         require(totalSupply() + _wallets.length <= maxSupply, "Max Supply Reached.");
1245         for(uint i = 0; i < _wallets.length; i++)
1246             _safeMint(_wallets[i], 1);
1247 
1248     }
1249    function sendGiftsToWallet(address _wallet, uint256 _num) external onlyOwner{
1250             require(totalSupply() + _num <= maxSupply, "Max Supply Reached.");
1251             _safeMint(_wallet, _num);
1252     }
1253 
1254     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1255         require(
1256             _exists(_tokenId),
1257             "ERC721Metadata: URI set of nonexistent token"
1258         );
1259         if (revealed == false) {
1260             return hiddenMetadataUri;
1261         }
1262         return string(abi.encodePacked(baseURI, _tokenId.toString(), _extension));
1263 
1264     }
1265 
1266     function updateBaseURI(string memory _newBaseURI) onlyOwner public {
1267         baseURI = _newBaseURI;
1268     }
1269     function updateExtension(string memory _temp) onlyOwner public {
1270         _extension = _temp;
1271     }
1272 
1273     function getBaseURI() external view returns(string memory) {
1274         return baseURI;
1275     }
1276 
1277     function updatePrice(uint256 _price) public onlyOwner() {
1278         price = _price;
1279     }
1280 
1281     function setRevealed(bool _state) public onlyOwner {
1282         revealed = _state;
1283     }
1284     function updateMaxSupply(uint256 _supply) public onlyOwner() {
1285         maxSupply = _supply;
1286     }
1287 
1288     function toggleMainSaleState() public onlyOwner() {
1289         publicSaleState = !publicSaleState;
1290     }
1291 
1292 
1293     function getBalance() public view returns(uint) {
1294         return address(this).balance;
1295     }
1296 
1297     function getMintedCount(address owner) public view returns (uint256) {
1298     return _numberMinted(owner);
1299   }
1300    function updatemaxPerTransaction(uint256 _temp) public onlyOwner() {
1301         maxPerTransaction = _temp;
1302     }
1303 
1304     function setmaxInAddresss(uint256 _maxInAddress) public onlyOwner() {
1305         maxInAddress = _maxInAddress;
1306     }
1307     function withdraw() external onlyOwner {
1308         uint _balance = address(this).balance;
1309         payable(msg.sender).transfer(_balance); //Owner
1310     }
1311 
1312     function updateHiddenMetadata(string memory _newBaseURI) onlyOwner public {
1313         hiddenMetadataUri = _newBaseURI;
1314     }
1315 
1316     function getOwnershipData(uint256 tokenId)
1317     external
1318     view
1319     returns (TokenOwnership memory)
1320   {
1321     return ownershipOf(tokenId);
1322   }
1323 
1324     receive() external payable {}
1325 
1326 }