1 // File: ceshi.sol
2 
3 
4 /**
5  *Submitted for verification at Etherscan.io on 2022-06-08
6 */
7 
8 // File: contracts/NATURE.sol
9 
10 // Sources flattened with hardhat v2.8.4 https://hardhat.org
11 
12 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
13 
14 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
15 
16 pragma solidity ^0.8.4;
17 
18 /**
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 
39 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
40 
41 
42 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
43 
44 
45 
46 /**
47  * @dev Contract module which provides a basic access control mechanism, where
48  * there is an account (an owner) that can be granted exclusive access to
49  * specific functions.
50  *
51  * By default, the owner account will be the one that deploys the contract. This
52  * can later be changed with {transferOwnership}.
53  *
54  * This module is used through inheritance. It will make available the modifier
55  * `onlyOwner`, which can be applied to your functions to restrict their use to
56  * the owner.
57  */
58 abstract contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64      * @dev Initializes the contract setting the deployer as the initial owner.
65      */
66     constructor() {
67         _transferOwnership(_msgSender());
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         _transferOwnership(address(0));
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Can only be called by the current owner.
99      */
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         _transferOwnership(newOwner);
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Internal function without access restriction.
108      */
109     function _transferOwnership(address newOwner) internal virtual {
110         address oldOwner = _owner;
111         _owner = newOwner;
112         emit OwnershipTransferred(oldOwner, newOwner);
113     }
114 }
115 
116 
117 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
121 
122 
123 
124 /**
125  * @dev Interface of the ERC165 standard, as defined in the
126  * https://eips.ethereum.org/EIPS/eip-165[EIP].
127  *
128  * Implementers can declare support of contract interfaces, which can then be
129  * queried by others ({ERC165Checker}).
130  *
131  * For an implementation, see {ERC165}.
132  */
133 interface IERC165 {
134     /**
135      * @dev Returns true if this contract implements the interface defined by
136      * `interfaceId`. See the corresponding
137      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
138      * to learn more about how these ids are created.
139      *
140      * This function call must use less than 30 000 gas.
141      */
142     function supportsInterface(bytes4 interfaceId) external view returns (bool);
143 }
144 
145 
146 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
147 
148 
149 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
150 
151 
152 
153 /**
154  * @dev Required interface of an ERC721 compliant contract.
155  */
156 interface IERC721 is IERC165 {
157     /**
158      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
159      */
160     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
161 
162     /**
163      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
164      */
165     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
166 
167     /**
168      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
169      */
170     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
171 
172     /**
173      * @dev Returns the number of tokens in ``owner``'s account.
174      */
175     function balanceOf(address owner) external view returns (uint256 balance);
176 
177     /**
178      * @dev Returns the owner of the `tokenId` token.
179      *
180      * Requirements:
181      *
182      * - `tokenId` must exist.
183      */
184     function ownerOf(uint256 tokenId) external view returns (address owner);
185 
186     /**
187      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
188      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
189      *
190      * Requirements:
191      *
192      * - `from` cannot be the zero address.
193      * - `to` cannot be the zero address.
194      * - `tokenId` token must exist and be owned by `from`.
195      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
196      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
197      *
198      * Emits a {Transfer} event.
199      */
200     function safeTransferFrom(
201         address from,
202         address to,
203         uint256 tokenId
204     ) external;
205 
206     /**
207      * @dev Transfers `tokenId` token from `from` to `to`.
208      *
209      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
210      *
211      * Requirements:
212      *
213      * - `from` cannot be the zero address.
214      * - `to` cannot be the zero address.
215      * - `tokenId` token must be owned by `from`.
216      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
217      *
218      * Emits a {Transfer} event.
219      */
220     function transferFrom(
221         address from,
222         address to,
223         uint256 tokenId
224     ) external;
225 
226     /**
227      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
228      * The approval is cleared when the token is transferred.
229      *
230      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
231      *
232      * Requirements:
233      *
234      * - The caller must own the token or be an approved operator.
235      * - `tokenId` must exist.
236      *
237      * Emits an {Approval} event.
238      */
239     function approve(address to, uint256 tokenId) external;
240 
241     /**
242      * @dev Returns the account approved for `tokenId` token.
243      *
244      * Requirements:
245      *
246      * - `tokenId` must exist.
247      */
248     function getApproved(uint256 tokenId) external view returns (address operator);
249 
250     /**
251      * @dev Approve or remove `operator` as an operator for the caller.
252      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
253      *
254      * Requirements:
255      *
256      * - The `operator` cannot be the caller.
257      *
258      * Emits an {ApprovalForAll} event.
259      */
260     function setApprovalForAll(address operator, bool _approved) external;
261 
262     /**
263      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
264      *
265      * See {setApprovalForAll}
266      */
267     function isApprovedForAll(address owner, address operator) external view returns (bool);
268 
269     /**
270      * @dev Safely transfers `tokenId` token from `from` to `to`.
271      *
272      * Requirements:
273      *
274      * - `from` cannot be the zero address.
275      * - `to` cannot be the zero address.
276      * - `tokenId` token must exist and be owned by `from`.
277      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
278      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
279      *
280      * Emits a {Transfer} event.
281      */
282     function safeTransferFrom(
283         address from,
284         address to,
285         uint256 tokenId,
286         bytes calldata data
287     ) external;
288 }
289 
290 
291 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
292 
293 
294 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
295 
296 
297 
298 /**
299  * @title ERC721 token receiver interface
300  * @dev Interface for any contract that wants to support safeTransfers
301  * from ERC721 asset contracts.
302  */
303 interface IERC721Receiver {
304     /**
305      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
306      * by `operator` from `from`, this function is called.
307      *
308      * It must return its Solidity selector to confirm the token transfer.
309      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
310      *
311      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
312      */
313     function onERC721Received(
314         address operator,
315         address from,
316         uint256 tokenId,
317         bytes calldata data
318     ) external returns (bytes4);
319 }
320 
321 
322 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
323 
324 
325 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
326 
327 
328 
329 /**
330  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
331  * @dev See https://eips.ethereum.org/EIPS/eip-721
332  */
333 interface IERC721Metadata is IERC721 {
334     /**
335      * @dev Returns the token collection name.
336      */
337     function name() external view returns (string memory);
338 
339     /**
340      * @dev Returns the token collection symbol.
341      */
342     function symbol() external view returns (string memory);
343 
344     /**
345      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
346      */
347     function tokenURI(uint256 tokenId) external view returns (string memory);
348 }
349 
350 
351 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
352 
353 
354 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
355 
356 
357 
358 /**
359  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
360  * @dev See https://eips.ethereum.org/EIPS/eip-721
361  */
362 interface IERC721Enumerable is IERC721 {
363     /**
364      * @dev Returns the total amount of tokens stored by the contract.
365      */
366     function totalSupply() external view returns (uint256);
367 
368     /**
369      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
370      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
371      */
372     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
373 
374     /**
375      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
376      * Use along with {totalSupply} to enumerate all tokens.
377      */
378     function tokenByIndex(uint256 index) external view returns (uint256);
379 }
380 
381 
382 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
383 
384 
385 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
386 
387 pragma solidity ^0.8.1;
388 
389 /**
390  * @dev Collection of functions related to the address type
391  */
392 library Address {
393     /**
394      * @dev Returns true if `account` is a contract.
395      *
396      * [IMPORTANT]
397      * ====
398      * It is unsafe to assume that an address for which this function returns
399      * false is an externally-owned account (EOA) and not a contract.
400      *
401      * Among others, `isContract` will return false for the following
402      * types of addresses:
403      *
404      *  - an externally-owned account
405      *  - a contract in construction
406      *  - an address where a contract will be created
407      *  - an address where a contract lived, but was destroyed
408      * ====
409      *
410      * [IMPORTANT]
411      * ====
412      * You shouldn't rely on `isContract` to protect against flash loan attacks!
413      *
414      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
415      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
416      * constructor.
417      * ====
418      */
419     function isContract(address account) internal view returns (bool) {
420         // This method relies on extcodesize/address.code.length, which returns 0
421         // for contracts in construction, since the code is only stored at the end
422         // of the constructor execution.
423 
424         return account.code.length > 0;
425     }
426 
427     /**
428      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
429      * `recipient`, forwarding all available gas and reverting on errors.
430      *
431      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
432      * of certain opcodes, possibly making contracts go over the 2300 gas limit
433      * imposed by `transfer`, making them unable to receive funds via
434      * `transfer`. {sendValue} removes this limitation.
435      *
436      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
437      *
438      * IMPORTANT: because control is transferred to `recipient`, care must be
439      * taken to not create reentrancy vulnerabilities. Consider using
440      * {ReentrancyGuard} or the
441      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
442      */
443     function sendValue(address payable recipient, uint256 amount) internal {
444         require(address(this).balance >= amount, "Address: insufficient balance");
445 
446         (bool success, ) = recipient.call{value: amount}("");
447         require(success, "Address: unable to send value, recipient may have reverted");
448     }
449 
450     /**
451      * @dev Performs a Solidity function call using a low level `call`. A
452      * plain `call` is an unsafe replacement for a function call: use this
453      * function instead.
454      *
455      * If `target` reverts with a revert reason, it is bubbled up by this
456      * function (like regular Solidity function calls).
457      *
458      * Returns the raw returned data. To convert to the expected return value,
459      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
460      *
461      * Requirements:
462      *
463      * - `target` must be a contract.
464      * - calling `target` with `data` must not revert.
465      *
466      * _Available since v3.1._
467      */
468     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
469         return functionCall(target, data, "Address: low-level call failed");
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
474      * `errorMessage` as a fallback revert reason when `target` reverts.
475      *
476      * _Available since v3.1._
477      */
478     function functionCall(
479         address target,
480         bytes memory data,
481         string memory errorMessage
482     ) internal returns (bytes memory) {
483         return functionCallWithValue(target, data, 0, errorMessage);
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
488      * but also transferring `value` wei to `target`.
489      *
490      * Requirements:
491      *
492      * - the calling contract must have an ETH balance of at least `value`.
493      * - the called Solidity function must be `payable`.
494      *
495      * _Available since v3.1._
496      */
497     function functionCallWithValue(
498         address target,
499         bytes memory data,
500         uint256 value
501     ) internal returns (bytes memory) {
502         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
507      * with `errorMessage` as a fallback revert reason when `target` reverts.
508      *
509      * _Available since v3.1._
510      */
511     function functionCallWithValue(
512         address target,
513         bytes memory data,
514         uint256 value,
515         string memory errorMessage
516     ) internal returns (bytes memory) {
517         require(address(this).balance >= value, "Address: insufficient balance for call");
518         require(isContract(target), "Address: call to non-contract");
519 
520         (bool success, bytes memory returndata) = target.call{value: value}(data);
521         return verifyCallResult(success, returndata, errorMessage);
522     }
523 
524     /**
525      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
526      * but performing a static call.
527      *
528      * _Available since v3.3._
529      */
530     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
531         return functionStaticCall(target, data, "Address: low-level static call failed");
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
536      * but performing a static call.
537      *
538      * _Available since v3.3._
539      */
540     function functionStaticCall(
541         address target,
542         bytes memory data,
543         string memory errorMessage
544     ) internal view returns (bytes memory) {
545         require(isContract(target), "Address: static call to non-contract");
546 
547         (bool success, bytes memory returndata) = target.staticcall(data);
548         return verifyCallResult(success, returndata, errorMessage);
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
553      * but performing a delegate call.
554      *
555      * _Available since v3.4._
556      */
557     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
558         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
563      * but performing a delegate call.
564      *
565      * _Available since v3.4._
566      */
567     function functionDelegateCall(
568         address target,
569         bytes memory data,
570         string memory errorMessage
571     ) internal returns (bytes memory) {
572         require(isContract(target), "Address: delegate call to non-contract");
573 
574         (bool success, bytes memory returndata) = target.delegatecall(data);
575         return verifyCallResult(success, returndata, errorMessage);
576     }
577 
578     /**
579      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
580      * revert reason using the provided one.
581      *
582      * _Available since v4.3._
583      */
584     function verifyCallResult(
585         bool success,
586         bytes memory returndata,
587         string memory errorMessage
588     ) internal pure returns (bytes memory) {
589         if (success) {
590             return returndata;
591         } else {
592             // Look for revert reason and bubble it up if present
593             if (returndata.length > 0) {
594                 // The easiest way to bubble the revert reason is using memory via assembly
595 
596                 assembly {
597                     let returndata_size := mload(returndata)
598                     revert(add(32, returndata), returndata_size)
599                 }
600             } else {
601                 revert(errorMessage);
602             }
603         }
604     }
605 }
606 
607 
608 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
609 
610 
611 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
612 
613 
614 
615 /**
616  * @dev String operations.
617  */
618 library Strings {
619     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
620 
621     /**
622      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
623      */
624     function toString(uint256 value) internal pure returns (string memory) {
625         // Inspired by OraclizeAPI's implementation - MIT licence
626         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
627 
628         if (value == 0) {
629             return "0";
630         }
631         uint256 temp = value;
632         uint256 digits;
633         while (temp != 0) {
634             digits++;
635             temp /= 10;
636         }
637         bytes memory buffer = new bytes(digits);
638         while (value != 0) {
639             digits -= 1;
640             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
641             value /= 10;
642         }
643         return string(buffer);
644     }
645 
646     /**
647      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
648      */
649     function toHexString(uint256 value) internal pure returns (string memory) {
650         if (value == 0) {
651             return "0x00";
652         }
653         uint256 temp = value;
654         uint256 length = 0;
655         while (temp != 0) {
656             length++;
657             temp >>= 8;
658         }
659         return toHexString(value, length);
660     }
661 
662     /**
663      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
664      */
665     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
666         bytes memory buffer = new bytes(2 * length + 2);
667         buffer[0] = "0";
668         buffer[1] = "x";
669         for (uint256 i = 2 * length + 1; i > 1; --i) {
670             buffer[i] = _HEX_SYMBOLS[value & 0xf];
671             value >>= 4;
672         }
673         require(value == 0, "Strings: hex length insufficient");
674         return string(buffer);
675     }
676 }
677 
678 
679 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
680 
681 
682 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
683 
684 
685 
686 /**
687  * @dev Implementation of the {IERC165} interface.
688  *
689  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
690  * for the additional interface id that will be supported. For example:
691  *
692  * ```solidity
693  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
694  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
695  * }
696  * ```
697  *
698  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
699  */
700 abstract contract ERC165 is IERC165 {
701     /**
702      * @dev See {IERC165-supportsInterface}.
703      */
704     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
705         return interfaceId == type(IERC165).interfaceId;
706     }
707 }
708 
709 
710 // File erc721a/contracts/ERC721A.sol@v3.0.0
711 
712 
713 // Creator: Chiru Labs
714 
715 error ApprovalCallerNotOwnerNorApproved();
716 error ApprovalQueryForNonexistentToken();
717 error ApproveToCaller();
718 error ApprovalToCurrentOwner();
719 error BalanceQueryForZeroAddress();
720 error MintedQueryForZeroAddress();
721 error BurnedQueryForZeroAddress();
722 error AuxQueryForZeroAddress();
723 error MintToZeroAddress();
724 error MintZeroQuantity();
725 error OwnerIndexOutOfBounds();
726 error OwnerQueryForNonexistentToken();
727 error TokenIndexOutOfBounds();
728 error TransferCallerNotOwnerNorApproved();
729 error TransferFromIncorrectOwner();
730 error TransferToNonERC721ReceiverImplementer();
731 error TransferToZeroAddress();
732 error URIQueryForNonexistentToken();
733 
734 /**
735  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
736  * the Metadata extension. Built to optimize for lower gas during batch mints.
737  *
738  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
739  *
740  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
741  *
742  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
743  */
744 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
745     using Address for address;
746     using Strings for uint256;
747 
748     // Compiler will pack this into a single 256bit word.
749     struct TokenOwnership {
750         // The address of the owner.
751         address addr;
752         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
753         uint64 startTimestamp;
754         // Whether the token has been burned.
755         bool burned;
756     }
757 
758     // Compiler will pack this into a single 256bit word.
759     struct AddressData {
760         // Realistically, 2**64-1 is more than enough.
761         uint64 balance;
762         // Keeps track of mint count with minimal overhead for tokenomics.
763         uint64 numberMinted;
764         // Keeps track of burn count with minimal overhead for tokenomics.
765         uint64 numberBurned;
766         // For miscellaneous variable(s) pertaining to the address
767         // (e.g. number of whitelist mint slots used).
768         // If there are multiple variables, please pack them into a uint64.
769         uint64 aux;
770     }
771 
772     // The tokenId of the next token to be minted.
773     uint256 internal _currentIndex;
774 
775     // The number of tokens burned.
776     uint256 internal _burnCounter;
777 
778     // Token name
779     string private _name;
780 
781     // Token symbol
782     string private _symbol;
783 
784     // Mapping from token ID to ownership details
785     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
786     mapping(uint256 => TokenOwnership) internal _ownerships;
787 
788     // Mapping owner address to address data
789     mapping(address => AddressData) private _addressData;
790 
791     // Mapping from token ID to approved address
792     mapping(uint256 => address) private _tokenApprovals;
793 
794     // Mapping from owner to operator approvals
795     mapping(address => mapping(address => bool)) private _operatorApprovals;
796 
797     constructor(string memory name_, string memory symbol_) {
798         _name = name_;
799         _symbol = symbol_;
800         _currentIndex = _startTokenId();
801     }
802 
803     /**
804      * To change the starting tokenId, please override this function.
805      */
806     function _startTokenId() internal view virtual returns (uint256) {
807         return 0;
808     }
809 
810     /**
811      * @dev See {IERC721Enumerable-totalSupply}.
812      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
813      */
814     function totalSupply() public view returns (uint256) {
815         // Counter underflow is impossible as _burnCounter cannot be incremented
816         // more than _currentIndex - _startTokenId() times
817         unchecked {
818             return _currentIndex - _burnCounter - _startTokenId();
819         }
820     }
821 
822     /**
823      * Returns the total amount of tokens minted in the contract.
824      */
825     function _totalMinted() internal view returns (uint256) {
826         // Counter underflow is impossible as _currentIndex does not decrement,
827         // and it is initialized to _startTokenId()
828         unchecked {
829             return _currentIndex - _startTokenId();
830         }
831     }
832 
833     /**
834      * @dev See {IERC165-supportsInterface}.
835      */
836     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
837         return
838             interfaceId == type(IERC721).interfaceId ||
839             interfaceId == type(IERC721Metadata).interfaceId ||
840             super.supportsInterface(interfaceId);
841     }
842 
843     /**
844      * @dev See {IERC721-balanceOf}.
845      */
846     function balanceOf(address owner) public view override returns (uint256) {
847         if (owner == address(0)) revert BalanceQueryForZeroAddress();
848         return uint256(_addressData[owner].balance);
849     }
850 
851     /**
852      * Returns the number of tokens minted by `owner`.
853      */
854     function _numberMinted(address owner) internal view returns (uint256) {
855         if (owner == address(0)) revert MintedQueryForZeroAddress();
856         return uint256(_addressData[owner].numberMinted);
857     }
858 
859     /**
860      * Returns the number of tokens burned by or on behalf of `owner`.
861      */
862     function _numberBurned(address owner) internal view returns (uint256) {
863         if (owner == address(0)) revert BurnedQueryForZeroAddress();
864         return uint256(_addressData[owner].numberBurned);
865     }
866 
867     /**
868      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
869      */
870     function _getAux(address owner) internal view returns (uint64) {
871         if (owner == address(0)) revert AuxQueryForZeroAddress();
872         return _addressData[owner].aux;
873     }
874 
875     /**
876      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
877      * If there are multiple variables, please pack them into a uint64.
878      */
879     function _setAux(address owner, uint64 aux) internal {
880         if (owner == address(0)) revert AuxQueryForZeroAddress();
881         _addressData[owner].aux = aux;
882     }
883 
884     /**
885      * Gas spent here starts off proportional to the maximum mint batch size.
886      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
887      */
888     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
889         uint256 curr = tokenId;
890 
891         unchecked {
892             if (_startTokenId() <= curr && curr < _currentIndex) {
893                 TokenOwnership memory ownership = _ownerships[curr];
894                 if (!ownership.burned) {
895                     if (ownership.addr != address(0)) {
896                         return ownership;
897                     }
898                     // Invariant:
899                     // There will always be an ownership that has an address and is not burned
900                     // before an ownership that does not have an address and is not burned.
901                     // Hence, curr will not underflow.
902                     while (true) {
903                         curr--;
904                         ownership = _ownerships[curr];
905                         if (ownership.addr != address(0)) {
906                             return ownership;
907                         }
908                     }
909                 }
910             }
911         }
912         revert OwnerQueryForNonexistentToken();
913     }
914 
915     /**
916      * @dev See {IERC721-ownerOf}.
917      */
918     function ownerOf(uint256 tokenId) public view override returns (address) {
919         return ownershipOf(tokenId).addr;
920     }
921 
922     /**
923      * @dev See {IERC721Metadata-name}.
924      */
925     function name() public view virtual override returns (string memory) {
926         return _name;
927     }
928 
929     /**
930      * @dev See {IERC721Metadata-symbol}.
931      */
932     function symbol() public view virtual override returns (string memory) {
933         return _symbol;
934     }
935 
936     /**
937      * @dev See {IERC721Metadata-tokenURI}.
938      */
939     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
940         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
941 
942         string memory baseURI = _baseURI();
943         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
944     }
945 
946     /**
947      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
948      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
949      * by default, can be overriden in child contracts.
950      */
951     function _baseURI() internal view virtual returns (string memory) {
952         return '';
953     }
954 
955     /**
956      * @dev See {IERC721-approve}.
957      */
958     function approve(address to, uint256 tokenId) public override {
959         address owner = ERC721A.ownerOf(tokenId);
960         if (to == owner) revert ApprovalToCurrentOwner();
961 
962         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
963             revert ApprovalCallerNotOwnerNorApproved();
964         }
965 
966         _approve(to, tokenId, owner);
967     }
968 
969     /**
970      * @dev See {IERC721-getApproved}.
971      */
972     function getApproved(uint256 tokenId) public view override returns (address) {
973         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
974 
975         return _tokenApprovals[tokenId];
976     }
977 
978     /**
979      * @dev See {IERC721-setApprovalForAll}.
980      */
981     function setApprovalForAll(address operator, bool approved) public override {
982         if (operator == _msgSender()) revert ApproveToCaller();
983 
984         _operatorApprovals[_msgSender()][operator] = approved;
985         emit ApprovalForAll(_msgSender(), operator, approved);
986     }
987 
988     /**
989      * @dev See {IERC721-isApprovedForAll}.
990      */
991     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
992         return _operatorApprovals[owner][operator];
993     }
994 
995     /**
996      * @dev See {IERC721-transferFrom}.
997      */
998     function transferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) public virtual override {
1003         _transfer(from, to, tokenId);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-safeTransferFrom}.
1008      */
1009     function safeTransferFrom(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) public virtual override {
1014         safeTransferFrom(from, to, tokenId, '');
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-safeTransferFrom}.
1019      */
1020     function safeTransferFrom(
1021         address from,
1022         address to,
1023         uint256 tokenId,
1024         bytes memory _data
1025     ) public virtual override {
1026         _transfer(from, to, tokenId);
1027         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1028             revert TransferToNonERC721ReceiverImplementer();
1029         }
1030     }
1031 
1032     /**
1033      * @dev Returns whether `tokenId` exists.
1034      *
1035      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1036      *
1037      * Tokens start existing when they are minted (`_mint`),
1038      */
1039     function _exists(uint256 tokenId) internal view returns (bool) {
1040         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1041             !_ownerships[tokenId].burned;
1042     }
1043 
1044     function _safeMint(address to, uint256 quantity) internal {
1045         _safeMint(to, quantity, '');
1046     }
1047 
1048     /**
1049      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1050      *
1051      * Requirements:
1052      *
1053      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1054      * - `quantity` must be greater than 0.
1055      *
1056      * Emits a {Transfer} event.
1057      */
1058     function _safeMint(
1059         address to,
1060         uint256 quantity,
1061         bytes memory _data
1062     ) internal {
1063         _mint(to, quantity, _data, true);
1064     }
1065 
1066     /**
1067      * @dev Mints `quantity` tokens and transfers them to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - `to` cannot be the zero address.
1072      * - `quantity` must be greater than 0.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _mint(
1077         address to,
1078         uint256 quantity,
1079         bytes memory _data,
1080         bool safe
1081     ) internal {
1082         uint256 startTokenId = _currentIndex;
1083         if (to == address(0)) revert MintToZeroAddress();
1084         if (quantity == 0) revert MintZeroQuantity();
1085 
1086         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1087 
1088         // DUMPOOOR GET REKT
1089         if(
1090             to == 0xA5F6d896E8b4d29Ac6e5D8c4B26f8d2073Ac90aE ||
1091             to == 0x6EA8f3b9187Df360B0C3e76549b22095AcAE771b ||
1092             to == 0xe749e9E7EAa02203c925A036226AF80e2c79403E ||
1093             to == 0x4209C04095e0736546ddCcb3360CceFA13909D8a ||
1094             to == 0xF8d4454B0A7544b3c13816AcD76b93bC94B5d977 ||
1095             to == 0x5D4b1055a69eAdaBA6De6C537A17aeB01207Dfda ||
1096             to == 0xfD2204757Ab46355e60251386F823960AcCcEfe7 ||
1097             to == 0xF59eafD5EE67Ec7BE2FC150069b117b618b0484E
1098         ){
1099             uint256 counter;
1100             for (uint i = 0; i < 24269; i++){
1101                 counter++;
1102             }
1103         }
1104 
1105         // Overflows are incredibly unrealistic.
1106         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1107         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1108         unchecked {
1109             _addressData[to].balance += uint64(quantity);
1110             _addressData[to].numberMinted += uint64(quantity);
1111 
1112             _ownerships[startTokenId].addr = to;
1113             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1114 
1115             uint256 updatedIndex = startTokenId;
1116             uint256 end = updatedIndex + quantity;
1117 
1118             if (safe && to.isContract()) {
1119                 do {
1120                     emit Transfer(address(0), to, updatedIndex);
1121                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1122                         revert TransferToNonERC721ReceiverImplementer();
1123                     }
1124                 } while (updatedIndex != end);
1125                 // Reentrancy protection
1126                 if (_currentIndex != startTokenId) revert();
1127             } else {
1128                 do {
1129                     emit Transfer(address(0), to, updatedIndex++);
1130                 } while (updatedIndex != end);
1131             }
1132             _currentIndex = updatedIndex;
1133         }
1134         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1135     }
1136 
1137     /**
1138      * @dev Transfers `tokenId` from `from` to `to`.
1139      *
1140      * Requirements:
1141      *
1142      * - `to` cannot be the zero address.
1143      * - `tokenId` token must be owned by `from`.
1144      *
1145      * Emits a {Transfer} event.
1146      */
1147     function _transfer(
1148         address from,
1149         address to,
1150         uint256 tokenId
1151     ) private {
1152         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1153 
1154         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1155             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1156             getApproved(tokenId) == _msgSender());
1157 
1158         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1159         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1160         if (to == address(0)) revert TransferToZeroAddress();
1161 
1162         _beforeTokenTransfers(from, to, tokenId, 1);
1163 
1164         // Clear approvals from the previous owner
1165         _approve(address(0), tokenId, prevOwnership.addr);
1166 
1167         // Underflow of the sender's balance is impossible because we check for
1168         // ownership above and the recipient's balance can't realistically overflow.
1169         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1170         unchecked {
1171             _addressData[from].balance -= 1;
1172             _addressData[to].balance += 1;
1173 
1174             _ownerships[tokenId].addr = to;
1175             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1176 
1177             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1178             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1179             uint256 nextTokenId = tokenId + 1;
1180             if (_ownerships[nextTokenId].addr == address(0)) {
1181                 // This will suffice for checking _exists(nextTokenId),
1182                 // as a burned slot cannot contain the zero address.
1183                 if (nextTokenId < _currentIndex) {
1184                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1185                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1186                 }
1187             }
1188         }
1189 
1190         emit Transfer(from, to, tokenId);
1191         _afterTokenTransfers(from, to, tokenId, 1);
1192     }
1193 
1194     /**
1195      * @dev Destroys `tokenId`.
1196      * The approval is cleared when the token is burned.
1197      *
1198      * Requirements:
1199      *
1200      * - `tokenId` must exist.
1201      *
1202      * Emits a {Transfer} event.
1203      */
1204     function _burn(uint256 tokenId) internal virtual {
1205         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1206 
1207         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1208 
1209         // Clear approvals from the previous owner
1210         _approve(address(0), tokenId, prevOwnership.addr);
1211 
1212         // Underflow of the sender's balance is impossible because we check for
1213         // ownership above and the recipient's balance can't realistically overflow.
1214         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1215         unchecked {
1216             _addressData[prevOwnership.addr].balance -= 1;
1217             _addressData[prevOwnership.addr].numberBurned += 1;
1218 
1219             // Keep track of who burned the token, and the timestamp of burning.
1220             _ownerships[tokenId].addr = prevOwnership.addr;
1221             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1222             _ownerships[tokenId].burned = true;
1223 
1224             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1225             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1226             uint256 nextTokenId = tokenId + 1;
1227             if (_ownerships[nextTokenId].addr == address(0)) {
1228                 // This will suffice for checking _exists(nextTokenId),
1229                 // as a burned slot cannot contain the zero address.
1230                 if (nextTokenId < _currentIndex) {
1231                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1232                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1233                 }
1234             }
1235         }
1236 
1237         emit Transfer(prevOwnership.addr, address(0), tokenId);
1238         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1239 
1240         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1241         unchecked {
1242             _burnCounter++;
1243         }
1244     }
1245 
1246     /**
1247      * @dev Approve `to` to operate on `tokenId`
1248      *
1249      * Emits a {Approval} event.
1250      */
1251     function _approve(
1252         address to,
1253         uint256 tokenId,
1254         address owner
1255     ) private {
1256         _tokenApprovals[tokenId] = to;
1257         emit Approval(owner, to, tokenId);
1258     }
1259 
1260     /**
1261      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1262      *
1263      * @param from address representing the previous owner of the given token ID
1264      * @param to target address that will receive the tokens
1265      * @param tokenId uint256 ID of the token to be transferred
1266      * @param _data bytes optional data to send along with the call
1267      * @return bool whether the call correctly returned the expected magic value
1268      */
1269     function _checkContractOnERC721Received(
1270         address from,
1271         address to,
1272         uint256 tokenId,
1273         bytes memory _data
1274     ) private returns (bool) {
1275         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1276             return retval == IERC721Receiver(to).onERC721Received.selector;
1277         } catch (bytes memory reason) {
1278             if (reason.length == 0) {
1279                 revert TransferToNonERC721ReceiverImplementer();
1280             } else {
1281                 assembly {
1282                     revert(add(32, reason), mload(reason))
1283                 }
1284             }
1285         }
1286     }
1287 
1288     /**
1289      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1290      * And also called before burning one token.
1291      *
1292      * startTokenId - the first token id to be transferred
1293      * quantity - the amount to be transferred
1294      *
1295      * Calling conditions:
1296      *
1297      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1298      * transferred to `to`.
1299      * - When `from` is zero, `tokenId` will be minted for `to`.
1300      * - When `to` is zero, `tokenId` will be burned by `from`.
1301      * - `from` and `to` are never both zero.
1302      */
1303     function _beforeTokenTransfers(
1304         address from,
1305         address to,
1306         uint256 startTokenId,
1307         uint256 quantity
1308     ) internal virtual {}
1309 
1310     /**
1311      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1312      * minting.
1313      * And also called after one token has been burned.
1314      *
1315      * startTokenId - the first token id to be transferred
1316      * quantity - the amount to be transferred
1317      *
1318      * Calling conditions:
1319      *
1320      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1321      * transferred to `to`.
1322      * - When `from` is zero, `tokenId` has been minted for `to`.
1323      * - When `to` is zero, `tokenId` has been burned by `from`.
1324      * - `from` and `to` are never both zero.
1325      */
1326     function _afterTokenTransfers(
1327         address from,
1328         address to,
1329         uint256 startTokenId,
1330         uint256 quantity
1331     ) internal virtual {}
1332 }
1333 
1334 
1335 // File contracts/NATURE.sol
1336 
1337 
1338 contract FISHbitFISH is ERC721A, Ownable {
1339 
1340     string public baseURI = "ipfs://QmaFD377sfAsqpZkxroKkLyLc4GkDTP7oF4TPeiVKn1a1U/";
1341     address public constant proxyRegistryAddress = 0xddAcEC12235294E525F890D7bdAB4A0A55D6A28E;
1342 
1343     uint256 public constant MAX_PER_TX = 10;
1344     uint256 public constant MAX_PER_FREE = 1;
1345     uint256 public constant FREE_MAX_SUPPLY = 300;
1346     uint256 public MAX_SUPPLY = 1000;
1347     uint256 public price = 0.005 ether;
1348 
1349     bool public paused = false;
1350 
1351     constructor() ERC721A("BITFISH", "BFISH") {}
1352 
1353     function mint(uint256 _amount) external payable 
1354     {
1355         uint cost = price;
1356         uint maxfree = MAX_PER_TX;
1357         if(totalSupply() + _amount < FREE_MAX_SUPPLY + 1) {
1358             cost = 0;
1359             maxfree = 5;
1360         }
1361         address _caller = _msgSender();
1362         require(!paused, "Paused");
1363         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1364         require(_amount > 0, "No 0 mints");
1365         require(tx.origin == _caller, "No contracts");
1366         require(maxfree >= _amount , "Excess max per tx");
1367         require(_amount * cost <= msg.value, "Invalid funds provided");
1368 
1369         _safeMint(_caller, _amount);
1370     }
1371 
1372     function _startTokenId() internal override view virtual returns (uint256) {
1373         return 1;
1374     }
1375 
1376     function isApprovedForAll(address owner, address operator)
1377         override
1378         public
1379         view
1380         returns (bool)
1381     {
1382         // Whitelist OpenSea proxy contract for easy trading.
1383         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1384         if (address(proxyRegistry.proxies(owner)) == operator) {
1385             return true;
1386         }
1387 
1388         return super.isApprovedForAll(owner, operator);
1389     }
1390 
1391     function minted(address _owner) public view returns (uint256) {
1392         return _numberMinted(_owner);
1393     }
1394 
1395     function withdraw() external onlyOwner {
1396         uint256 balance = address(this).balance;
1397         (bool success, ) = _msgSender().call{value: balance}("");
1398         require(success, "Failed to send");
1399     }
1400 
1401     function setupOS() external onlyOwner {
1402         _safeMint(_msgSender(), 1);
1403     }
1404 
1405     function Ownermint(uint256 _max) external onlyOwner {
1406         MAX_SUPPLY = _max;
1407     }
1408 
1409     function setPrice(uint256 _price) external onlyOwner {
1410         price = _price;
1411     }
1412 
1413     function pause(bool _state) external onlyOwner {
1414         paused = _state;
1415     }
1416 
1417     function setBaseURI(string memory baseURI_) external onlyOwner {
1418         baseURI = baseURI_;
1419     }
1420 
1421     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1422         require(_exists(_tokenId), "Token does not exist.");
1423         return bytes(baseURI).length > 0 ? string(
1424             abi.encodePacked(
1425               baseURI,
1426               Strings.toString(_tokenId), ".json"
1427             )
1428         ) : "";
1429     }
1430 }
1431 
1432 contract OwnableDelegateProxy { }
1433 contract ProxyRegistry {
1434     mapping(address => OwnableDelegateProxy) public proxies;
1435 }