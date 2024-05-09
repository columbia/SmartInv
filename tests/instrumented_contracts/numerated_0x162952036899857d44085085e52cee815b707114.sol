1 // SPDX-License-Identifier: MIT
2 /*
3                                                                                                     
4                      Website: https://goghost.world/
5                                                                                
6                               Twitter: https://twitter.com/Gogh0st/
7 
8                                     Discord: https://discord.gg/goghost/                                                 
9                                                                    
10                                  
11                                         @@@@@@@@@@@@@@@@@@@@@@                                      
12                                     @@@@@.                  %@@@@                                   
13                                  @@@@                           @@@@                                
14                                @@@&                               @@@@                              
15                              @@@@                                   @@@.                            
16                             @@@                                       @@@                           
17                            @@@                           @@@@@@        @@@                          
18                           @@@            @@@@@@          @@@(          ,@@.                         
19                          .@@             @@@/                           @@@                         
20                          @@@                      @@&,,,,                @@                         
21                          @@(                       ,@/@        @@@@@@@@@@%@@@@@                     
22                         &@@                                                    @@@                  
23                         @@@       @@@@@@@@@@@@@@                                @@                  
24                         @@@      /             @@@@                  @@@@@@@/@@.                    
25                         @@@                       @@            @@@@@@    @@(                       
26                         @@@            @@@@@@@@@@@           @@@@         @@@                       
27                         @@,       @@@@@@                                  @@@                       
28                        /@@     @@@@                                       @@@                       
29                        @@@                                                @@@                       
30                        @@@                                                @@@                       
31                       *@@                                                 @@@                       
32                       @@@  @@.                                            @@@                       
33                      @@@  @@                                              @@@                       
34                    @@@   @@            @@@@@@@@@@@@@@@@         @@@@@@@@@ @@@                       
35                     @@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     /@@@@                       
36                        @@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  .@@@@@@@@@@                          
37                        @@@@@@@  @@@@@@@@@@@@@@*   @@@@@@@@@@@@@@@                                   
38                             .@@@@@(        @@@@@@@@/     @@@                                        
39                                  @@@@@@@@@@@                                                        
40                                                                                                     
41 */
42 
43 // Sources flattened with hardhat v2.9.3 https://hardhat.org
44 
45 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
46 
47 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
48 
49 pragma solidity ^0.8.0;
50 
51 /**
52  * @dev String operations.
53  */
54 library Strings {
55     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
59      */
60     function toString(uint256 value) internal pure returns (string memory) {
61         // Inspired by OraclizeAPI's implementation - MIT licence
62         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
63 
64         if (value == 0) {
65             return "0";
66         }
67         uint256 temp = value;
68         uint256 digits;
69         while (temp != 0) {
70             digits++;
71             temp /= 10;
72         }
73         bytes memory buffer = new bytes(digits);
74         while (value != 0) {
75             digits -= 1;
76             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
77             value /= 10;
78         }
79         return string(buffer);
80     }
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
84      */
85     function toHexString(uint256 value) internal pure returns (string memory) {
86         if (value == 0) {
87             return "0x00";
88         }
89         uint256 temp = value;
90         uint256 length = 0;
91         while (temp != 0) {
92             length++;
93             temp >>= 8;
94         }
95         return toHexString(value, length);
96     }
97 
98     /**
99      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
100      */
101     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
102         bytes memory buffer = new bytes(2 * length + 2);
103         buffer[0] = "0";
104         buffer[1] = "x";
105         for (uint256 i = 2 * length + 1; i > 1; --i) {
106             buffer[i] = _HEX_SYMBOLS[value & 0xf];
107             value >>= 4;
108         }
109         require(value == 0, "Strings: hex length insufficient");
110         return string(buffer);
111     }
112 }
113 
114 
115 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
116 
117 
118 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Provides information about the current execution context, including the
124  * sender of the transaction and its data. While these are generally available
125  * via msg.sender and msg.data, they should not be accessed in such a direct
126  * manner, since when dealing with meta-transactions the account sending and
127  * paying for execution may not be the actual sender (as far as an application
128  * is concerned).
129  *
130  * This contract is only required for intermediate, library-like contracts.
131  */
132 abstract contract Context {
133     function _msgSender() internal view virtual returns (address) {
134         return msg.sender;
135     }
136 
137     function _msgData() internal view virtual returns (bytes calldata) {
138         return msg.data;
139     }
140 }
141 
142 
143 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
144 
145 
146 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 /**
151  * @dev Contract module which provides a basic access control mechanism, where
152  * there is an account (an owner) that can be granted exclusive access to
153  * specific functions.
154  *
155  * By default, the owner account will be the one that deploys the contract. This
156  * can later be changed with {transferOwnership}.
157  *
158  * This module is used through inheritance. It will make available the modifier
159  * `onlyOwner`, which can be applied to your functions to restrict their use to
160  * the owner.
161  */
162 abstract contract Ownable is Context {
163     address private _owner;
164 
165     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
166 
167     /**
168      * @dev Initializes the contract setting the deployer as the initial owner.
169      */
170     constructor() {
171         _transferOwnership(_msgSender());
172     }
173 
174     /**
175      * @dev Returns the address of the current owner.
176      */
177     function owner() public view virtual returns (address) {
178         return _owner;
179     }
180 
181     /**
182      * @dev Throws if called by any account other than the owner.
183      */
184     modifier onlyOwner() {
185         require(owner() == _msgSender(), "Ownable: caller is not the owner");
186         _;
187     }
188 
189     /**
190      * @dev Leaves the contract without owner. It will not be possible to call
191      * `onlyOwner` functions anymore. Can only be called by the current owner.
192      *
193      * NOTE: Renouncing ownership will leave the contract without an owner,
194      * thereby removing any functionality that is only available to the owner.
195      */
196     function renounceOwnership() public virtual onlyOwner {
197         _transferOwnership(address(0));
198     }
199 
200     /**
201      * @dev Transfers ownership of the contract to a new account (`newOwner`).
202      * Can only be called by the current owner.
203      */
204     function transferOwnership(address newOwner) public virtual onlyOwner {
205         require(newOwner != address(0), "Ownable: new owner is the zero address");
206         _transferOwnership(newOwner);
207     }
208 
209     /**
210      * @dev Transfers ownership of the contract to a new account (`newOwner`).
211      * Internal function without access restriction.
212      */
213     function _transferOwnership(address newOwner) internal virtual {
214         address oldOwner = _owner;
215         _owner = newOwner;
216         emit OwnershipTransferred(oldOwner, newOwner);
217     }
218 }
219 
220 
221 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
222 
223 
224 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 /**
229  * @dev Interface of the ERC165 standard, as defined in the
230  * https://eips.ethereum.org/EIPS/eip-165[EIP].
231  *
232  * Implementers can declare support of contract interfaces, which can then be
233  * queried by others ({ERC165Checker}).
234  *
235  * For an implementation, see {ERC165}.
236  */
237 interface IERC165 {
238     /**
239      * @dev Returns true if this contract implements the interface defined by
240      * `interfaceId`. See the corresponding
241      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
242      * to learn more about how these ids are created.
243      *
244      * This function call must use less than 30 000 gas.
245      */
246     function supportsInterface(bytes4 interfaceId) external view returns (bool);
247 }
248 
249 
250 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
251 
252 
253 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
254 
255 pragma solidity ^0.8.0;
256 
257 /**
258  * @dev Required interface of an ERC721 compliant contract.
259  */
260 interface IERC721 is IERC165 {
261     /**
262      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
263      */
264     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
265 
266     /**
267      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
268      */
269     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
270 
271     /**
272      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
273      */
274     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
275 
276     /**
277      * @dev Returns the number of tokens in ``owner``'s account.
278      */
279     function balanceOf(address owner) external view returns (uint256 balance);
280 
281     /**
282      * @dev Returns the owner of the `tokenId` token.
283      *
284      * Requirements:
285      *
286      * - `tokenId` must exist.
287      */
288     function ownerOf(uint256 tokenId) external view returns (address owner);
289 
290     /**
291      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
292      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
293      *
294      * Requirements:
295      *
296      * - `from` cannot be the zero address.
297      * - `to` cannot be the zero address.
298      * - `tokenId` token must exist and be owned by `from`.
299      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
300      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
301      *
302      * Emits a {Transfer} event.
303      */
304     function safeTransferFrom(
305         address from,
306         address to,
307         uint256 tokenId
308     ) external;
309 
310     /**
311      * @dev Transfers `tokenId` token from `from` to `to`.
312      *
313      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
314      *
315      * Requirements:
316      *
317      * - `from` cannot be the zero address.
318      * - `to` cannot be the zero address.
319      * - `tokenId` token must be owned by `from`.
320      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
321      *
322      * Emits a {Transfer} event.
323      */
324     function transferFrom(
325         address from,
326         address to,
327         uint256 tokenId
328     ) external;
329 
330     /**
331      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
332      * The approval is cleared when the token is transferred.
333      *
334      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
335      *
336      * Requirements:
337      *
338      * - The caller must own the token or be an approved operator.
339      * - `tokenId` must exist.
340      *
341      * Emits an {Approval} event.
342      */
343     function approve(address to, uint256 tokenId) external;
344 
345     /**
346      * @dev Returns the account approved for `tokenId` token.
347      *
348      * Requirements:
349      *
350      * - `tokenId` must exist.
351      */
352     function getApproved(uint256 tokenId) external view returns (address operator);
353 
354     /**
355      * @dev Approve or remove `operator` as an operator for the caller.
356      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
357      *
358      * Requirements:
359      *
360      * - The `operator` cannot be the caller.
361      *
362      * Emits an {ApprovalForAll} event.
363      */
364     function setApprovalForAll(address operator, bool _approved) external;
365 
366     /**
367      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
368      *
369      * See {setApprovalForAll}
370      */
371     function isApprovedForAll(address owner, address operator) external view returns (bool);
372 
373     /**
374      * @dev Safely transfers `tokenId` token from `from` to `to`.
375      *
376      * Requirements:
377      *
378      * - `from` cannot be the zero address.
379      * - `to` cannot be the zero address.
380      * - `tokenId` token must exist and be owned by `from`.
381      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
382      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
383      *
384      * Emits a {Transfer} event.
385      */
386     function safeTransferFrom(
387         address from,
388         address to,
389         uint256 tokenId,
390         bytes calldata data
391     ) external;
392 }
393 
394 
395 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
396 
397 
398 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
426 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
427 
428 
429 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
430 
431 pragma solidity ^0.8.0;
432 
433 /**
434  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
435  * @dev See https://eips.ethereum.org/EIPS/eip-721
436  */
437 interface IERC721Metadata is IERC721 {
438     /**
439      * @dev Returns the token collection name.
440      */
441     function name() external view returns (string memory);
442 
443     /**
444      * @dev Returns the token collection symbol.
445      */
446     function symbol() external view returns (string memory);
447 
448     /**
449      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
450      */
451     function tokenURI(uint256 tokenId) external view returns (string memory);
452 }
453 
454 
455 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
456 
457 
458 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
459 
460 pragma solidity ^0.8.1;
461 
462 /**
463  * @dev Collection of functions related to the address type
464  */
465 library Address {
466     /**
467      * @dev Returns true if `account` is a contract.
468      *
469      * [IMPORTANT]
470      * ====
471      * It is unsafe to assume that an address for which this function returns
472      * false is an externally-owned account (EOA) and not a contract.
473      *
474      * Among others, `isContract` will return false for the following
475      * types of addresses:
476      *
477      *  - an externally-owned account
478      *  - a contract in construction
479      *  - an address where a contract will be created
480      *  - an address where a contract lived, but was destroyed
481      * ====
482      *
483      * [IMPORTANT]
484      * ====
485      * You shouldn't rely on `isContract` to protect against flash loan attacks!
486      *
487      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
488      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
489      * constructor.
490      * ====
491      */
492     function isContract(address account) internal view returns (bool) {
493         // This method relies on extcodesize/address.code.length, which returns 0
494         // for contracts in construction, since the code is only stored at the end
495         // of the constructor execution.
496 
497         return account.code.length > 0;
498     }
499 
500     /**
501      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
502      * `recipient`, forwarding all available gas and reverting on errors.
503      *
504      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
505      * of certain opcodes, possibly making contracts go over the 2300 gas limit
506      * imposed by `transfer`, making them unable to receive funds via
507      * `transfer`. {sendValue} removes this limitation.
508      *
509      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
510      *
511      * IMPORTANT: because control is transferred to `recipient`, care must be
512      * taken to not create reentrancy vulnerabilities. Consider using
513      * {ReentrancyGuard} or the
514      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
515      */
516     function sendValue(address payable recipient, uint256 amount) internal {
517         require(address(this).balance >= amount, "Address: insufficient balance");
518 
519         (bool success, ) = recipient.call{value: amount}("");
520         require(success, "Address: unable to send value, recipient may have reverted");
521     }
522 
523     /**
524      * @dev Performs a Solidity function call using a low level `call`. A
525      * plain `call` is an unsafe replacement for a function call: use this
526      * function instead.
527      *
528      * If `target` reverts with a revert reason, it is bubbled up by this
529      * function (like regular Solidity function calls).
530      *
531      * Returns the raw returned data. To convert to the expected return value,
532      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
533      *
534      * Requirements:
535      *
536      * - `target` must be a contract.
537      * - calling `target` with `data` must not revert.
538      *
539      * _Available since v3.1._
540      */
541     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
542         return functionCall(target, data, "Address: low-level call failed");
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
547      * `errorMessage` as a fallback revert reason when `target` reverts.
548      *
549      * _Available since v3.1._
550      */
551     function functionCall(
552         address target,
553         bytes memory data,
554         string memory errorMessage
555     ) internal returns (bytes memory) {
556         return functionCallWithValue(target, data, 0, errorMessage);
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
561      * but also transferring `value` wei to `target`.
562      *
563      * Requirements:
564      *
565      * - the calling contract must have an ETH balance of at least `value`.
566      * - the called Solidity function must be `payable`.
567      *
568      * _Available since v3.1._
569      */
570     function functionCallWithValue(
571         address target,
572         bytes memory data,
573         uint256 value
574     ) internal returns (bytes memory) {
575         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
580      * with `errorMessage` as a fallback revert reason when `target` reverts.
581      *
582      * _Available since v3.1._
583      */
584     function functionCallWithValue(
585         address target,
586         bytes memory data,
587         uint256 value,
588         string memory errorMessage
589     ) internal returns (bytes memory) {
590         require(address(this).balance >= value, "Address: insufficient balance for call");
591         require(isContract(target), "Address: call to non-contract");
592 
593         (bool success, bytes memory returndata) = target.call{value: value}(data);
594         return verifyCallResult(success, returndata, errorMessage);
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
599      * but performing a static call.
600      *
601      * _Available since v3.3._
602      */
603     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
604         return functionStaticCall(target, data, "Address: low-level static call failed");
605     }
606 
607     /**
608      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
609      * but performing a static call.
610      *
611      * _Available since v3.3._
612      */
613     function functionStaticCall(
614         address target,
615         bytes memory data,
616         string memory errorMessage
617     ) internal view returns (bytes memory) {
618         require(isContract(target), "Address: static call to non-contract");
619 
620         (bool success, bytes memory returndata) = target.staticcall(data);
621         return verifyCallResult(success, returndata, errorMessage);
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
626      * but performing a delegate call.
627      *
628      * _Available since v3.4._
629      */
630     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
631         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
632     }
633 
634     /**
635      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
636      * but performing a delegate call.
637      *
638      * _Available since v3.4._
639      */
640     function functionDelegateCall(
641         address target,
642         bytes memory data,
643         string memory errorMessage
644     ) internal returns (bytes memory) {
645         require(isContract(target), "Address: delegate call to non-contract");
646 
647         (bool success, bytes memory returndata) = target.delegatecall(data);
648         return verifyCallResult(success, returndata, errorMessage);
649     }
650 
651     /**
652      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
653      * revert reason using the provided one.
654      *
655      * _Available since v4.3._
656      */
657     function verifyCallResult(
658         bool success,
659         bytes memory returndata,
660         string memory errorMessage
661     ) internal pure returns (bytes memory) {
662         if (success) {
663             return returndata;
664         } else {
665             // Look for revert reason and bubble it up if present
666             if (returndata.length > 0) {
667                 // The easiest way to bubble the revert reason is using memory via assembly
668 
669                 assembly {
670                     let returndata_size := mload(returndata)
671                     revert(add(32, returndata), returndata_size)
672                 }
673             } else {
674                 revert(errorMessage);
675             }
676         }
677     }
678 }
679 
680 
681 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
682 
683 
684 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
685 
686 pragma solidity ^0.8.0;
687 
688 /**
689  * @dev Implementation of the {IERC165} interface.
690  *
691  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
692  * for the additional interface id that will be supported. For example:
693  *
694  * ```solidity
695  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
696  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
697  * }
698  * ```
699  *
700  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
701  */
702 abstract contract ERC165 is IERC165 {
703     /**
704      * @dev See {IERC165-supportsInterface}.
705      */
706     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
707         return interfaceId == type(IERC165).interfaceId;
708     }
709 }
710 
711 
712 // File erc721a/contracts/ERC721A.sol@v3.1.0
713 
714 
715 // Creator: Chiru Labs
716 
717 pragma solidity ^0.8.4;
718 
719 
720 
721 
722 
723 
724 
725 error ApprovalCallerNotOwnerNorApproved();
726 error ApprovalQueryForNonexistentToken();
727 error ApproveToCaller();
728 error ApprovalToCurrentOwner();
729 error BalanceQueryForZeroAddress();
730 error MintToZeroAddress();
731 error MintZeroQuantity();
732 error OwnerQueryForNonexistentToken();
733 error TransferCallerNotOwnerNorApproved();
734 error TransferFromIncorrectOwner();
735 error TransferToNonERC721ReceiverImplementer();
736 error TransferToZeroAddress();
737 error URIQueryForNonexistentToken();
738 
739 /**
740  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
741  * the Metadata extension. Built to optimize for lower gas during batch mints.
742  *
743  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
744  *
745  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
746  *
747  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
748  */
749 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
750     using Address for address;
751     using Strings for uint256;
752 
753     // Compiler will pack this into a single 256bit word.
754     struct TokenOwnership {
755         // The address of the owner.
756         address addr;
757         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
758         uint64 startTimestamp;
759         // Whether the token has been burned.
760         bool burned;
761     }
762 
763     // Compiler will pack this into a single 256bit word.
764     struct AddressData {
765         // Realistically, 2**64-1 is more than enough.
766         uint64 balance;
767         // Keeps track of mint count with minimal overhead for tokenomics.
768         uint64 numberMinted;
769         // Keeps track of burn count with minimal overhead for tokenomics.
770         uint64 numberBurned;
771         // For miscellaneous variable(s) pertaining to the address
772         // (e.g. number of whitelist mint slots used).
773         // If there are multiple variables, please pack them into a uint64.
774         uint64 aux;
775     }
776 
777     // The tokenId of the next token to be minted.
778     uint256 internal _currentIndex;
779 
780     // The number of tokens burned.
781     uint256 internal _burnCounter;
782 
783     // Token name
784     string private _name;
785 
786     // Token symbol
787     string private _symbol;
788 
789     // Mapping from token ID to ownership details
790     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
791     mapping(uint256 => TokenOwnership) internal _ownerships;
792 
793     // Mapping owner address to address data
794     mapping(address => AddressData) private _addressData;
795 
796     // Mapping from token ID to approved address
797     mapping(uint256 => address) private _tokenApprovals;
798 
799     // Mapping from owner to operator approvals
800     mapping(address => mapping(address => bool)) private _operatorApprovals;
801 
802     constructor(string memory name_, string memory symbol_) {
803         _name = name_;
804         _symbol = symbol_;
805         _currentIndex = _startTokenId();
806     }
807 
808     /**
809      * To change the starting tokenId, please override this function.
810      */
811     function _startTokenId() internal view virtual returns (uint256) {
812         return 0;
813     }
814 
815     /**
816      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
817      */
818     function totalSupply() public view returns (uint256) {
819         // Counter underflow is impossible as _burnCounter cannot be incremented
820         // more than _currentIndex - _startTokenId() times
821         unchecked {
822             return _currentIndex - _burnCounter - _startTokenId();
823         }
824     }
825 
826     /**
827      * Returns the total amount of tokens minted in the contract.
828      */
829     function _totalMinted() internal view returns (uint256) {
830         // Counter underflow is impossible as _currentIndex does not decrement,
831         // and it is initialized to _startTokenId()
832         unchecked {
833             return _currentIndex - _startTokenId();
834         }
835     }
836 
837     /**
838      * @dev See {IERC165-supportsInterface}.
839      */
840     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
841         return
842             interfaceId == type(IERC721).interfaceId ||
843             interfaceId == type(IERC721Metadata).interfaceId ||
844             super.supportsInterface(interfaceId);
845     }
846 
847     /**
848      * @dev See {IERC721-balanceOf}.
849      */
850     function balanceOf(address owner) public view override returns (uint256) {
851         if (owner == address(0)) revert BalanceQueryForZeroAddress();
852         return uint256(_addressData[owner].balance);
853     }
854 
855     /**
856      * Returns the number of tokens minted by `owner`.
857      */
858     function _numberMinted(address owner) internal view returns (uint256) {
859         return uint256(_addressData[owner].numberMinted);
860     }
861 
862     /**
863      * Returns the number of tokens burned by or on behalf of `owner`.
864      */
865     function _numberBurned(address owner) internal view returns (uint256) {
866         return uint256(_addressData[owner].numberBurned);
867     }
868 
869     /**
870      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
871      */
872     function _getAux(address owner) internal view returns (uint64) {
873         return _addressData[owner].aux;
874     }
875 
876     /**
877      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
878      * If there are multiple variables, please pack them into a uint64.
879      */
880     function _setAux(address owner, uint64 aux) internal {
881         _addressData[owner].aux = aux;
882     }
883 
884     /**
885      * Gas spent here starts off proportional to the maximum mint batch size.
886      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
887      */
888     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
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
919         return _ownershipOf(tokenId).addr;
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
981     function setApprovalForAll(address operator, bool approved) public virtual override {
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
1088         // Overflows are incredibly unrealistic.
1089         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1090         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1091         unchecked {
1092             _addressData[to].balance += uint64(quantity);
1093             _addressData[to].numberMinted += uint64(quantity);
1094 
1095             _ownerships[startTokenId].addr = to;
1096             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1097 
1098             uint256 updatedIndex = startTokenId;
1099             uint256 end = updatedIndex + quantity;
1100 
1101             if (safe && to.isContract()) {
1102                 do {
1103                     emit Transfer(address(0), to, updatedIndex);
1104                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1105                         revert TransferToNonERC721ReceiverImplementer();
1106                     }
1107                 } while (updatedIndex != end);
1108                 // Reentrancy protection
1109                 if (_currentIndex != startTokenId) revert();
1110             } else {
1111                 do {
1112                     emit Transfer(address(0), to, updatedIndex++);
1113                 } while (updatedIndex != end);
1114             }
1115             _currentIndex = updatedIndex;
1116         }
1117         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1118     }
1119 
1120     /**
1121      * @dev Transfers `tokenId` from `from` to `to`.
1122      *
1123      * Requirements:
1124      *
1125      * - `to` cannot be the zero address.
1126      * - `tokenId` token must be owned by `from`.
1127      *
1128      * Emits a {Transfer} event.
1129      */
1130     function _transfer(
1131         address from,
1132         address to,
1133         uint256 tokenId
1134     ) private {
1135         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1136 
1137         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1138 
1139         bool isApprovedOrOwner = (_msgSender() == from ||
1140             isApprovedForAll(from, _msgSender()) ||
1141             getApproved(tokenId) == _msgSender());
1142 
1143         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1144         if (to == address(0)) revert TransferToZeroAddress();
1145 
1146         _beforeTokenTransfers(from, to, tokenId, 1);
1147 
1148         // Clear approvals from the previous owner
1149         _approve(address(0), tokenId, from);
1150 
1151         // Underflow of the sender's balance is impossible because we check for
1152         // ownership above and the recipient's balance can't realistically overflow.
1153         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1154         unchecked {
1155             _addressData[from].balance -= 1;
1156             _addressData[to].balance += 1;
1157 
1158             TokenOwnership storage currSlot = _ownerships[tokenId];
1159             currSlot.addr = to;
1160             currSlot.startTimestamp = uint64(block.timestamp);
1161 
1162             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1163             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1164             uint256 nextTokenId = tokenId + 1;
1165             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1166             if (nextSlot.addr == address(0)) {
1167                 // This will suffice for checking _exists(nextTokenId),
1168                 // as a burned slot cannot contain the zero address.
1169                 if (nextTokenId != _currentIndex) {
1170                     nextSlot.addr = from;
1171                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1172                 }
1173             }
1174         }
1175 
1176         emit Transfer(from, to, tokenId);
1177         _afterTokenTransfers(from, to, tokenId, 1);
1178     }
1179 
1180     /**
1181      * @dev This is equivalent to _burn(tokenId, false)
1182      */
1183     function _burn(uint256 tokenId) internal virtual {
1184         _burn(tokenId, false);
1185     }
1186 
1187     /**
1188      * @dev Destroys `tokenId`.
1189      * The approval is cleared when the token is burned.
1190      *
1191      * Requirements:
1192      *
1193      * - `tokenId` must exist.
1194      *
1195      * Emits a {Transfer} event.
1196      */
1197     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1198         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1199 
1200         address from = prevOwnership.addr;
1201 
1202         if (approvalCheck) {
1203             bool isApprovedOrOwner = (_msgSender() == from ||
1204                 isApprovedForAll(from, _msgSender()) ||
1205                 getApproved(tokenId) == _msgSender());
1206 
1207             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1208         }
1209 
1210         _beforeTokenTransfers(from, address(0), tokenId, 1);
1211 
1212         // Clear approvals from the previous owner
1213         _approve(address(0), tokenId, from);
1214 
1215         // Underflow of the sender's balance is impossible because we check for
1216         // ownership above and the recipient's balance can't realistically overflow.
1217         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1218         unchecked {
1219             AddressData storage addressData = _addressData[from];
1220             addressData.balance -= 1;
1221             addressData.numberBurned += 1;
1222 
1223             // Keep track of who burned the token, and the timestamp of burning.
1224             TokenOwnership storage currSlot = _ownerships[tokenId];
1225             currSlot.addr = from;
1226             currSlot.startTimestamp = uint64(block.timestamp);
1227             currSlot.burned = true;
1228 
1229             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1230             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1231             uint256 nextTokenId = tokenId + 1;
1232             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1233             if (nextSlot.addr == address(0)) {
1234                 // This will suffice for checking _exists(nextTokenId),
1235                 // as a burned slot cannot contain the zero address.
1236                 if (nextTokenId != _currentIndex) {
1237                     nextSlot.addr = from;
1238                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1239                 }
1240             }
1241         }
1242 
1243         emit Transfer(from, address(0), tokenId);
1244         _afterTokenTransfers(from, address(0), tokenId, 1);
1245 
1246         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1247         unchecked {
1248             _burnCounter++;
1249         }
1250     }
1251 
1252     /**
1253      * @dev Approve `to` to operate on `tokenId`
1254      *
1255      * Emits a {Approval} event.
1256      */
1257     function _approve(
1258         address to,
1259         uint256 tokenId,
1260         address owner
1261     ) private {
1262         _tokenApprovals[tokenId] = to;
1263         emit Approval(owner, to, tokenId);
1264     }
1265 
1266     /**
1267      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1268      *
1269      * @param from address representing the previous owner of the given token ID
1270      * @param to target address that will receive the tokens
1271      * @param tokenId uint256 ID of the token to be transferred
1272      * @param _data bytes optional data to send along with the call
1273      * @return bool whether the call correctly returned the expected magic value
1274      */
1275     function _checkContractOnERC721Received(
1276         address from,
1277         address to,
1278         uint256 tokenId,
1279         bytes memory _data
1280     ) private returns (bool) {
1281         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1282             return retval == IERC721Receiver(to).onERC721Received.selector;
1283         } catch (bytes memory reason) {
1284             if (reason.length == 0) {
1285                 revert TransferToNonERC721ReceiverImplementer();
1286             } else {
1287                 assembly {
1288                     revert(add(32, reason), mload(reason))
1289                 }
1290             }
1291         }
1292     }
1293 
1294     /**
1295      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1296      * And also called before burning one token.
1297      *
1298      * startTokenId - the first token id to be transferred
1299      * quantity - the amount to be transferred
1300      *
1301      * Calling conditions:
1302      *
1303      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1304      * transferred to `to`.
1305      * - When `from` is zero, `tokenId` will be minted for `to`.
1306      * - When `to` is zero, `tokenId` will be burned by `from`.
1307      * - `from` and `to` are never both zero.
1308      */
1309     function _beforeTokenTransfers(
1310         address from,
1311         address to,
1312         uint256 startTokenId,
1313         uint256 quantity
1314     ) internal virtual {}
1315 
1316     /**
1317      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1318      * minting.
1319      * And also called after one token has been burned.
1320      *
1321      * startTokenId - the first token id to be transferred
1322      * quantity - the amount to be transferred
1323      *
1324      * Calling conditions:
1325      *
1326      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1327      * transferred to `to`.
1328      * - When `from` is zero, `tokenId` has been minted for `to`.
1329      * - When `to` is zero, `tokenId` has been burned by `from`.
1330      * - `from` and `to` are never both zero.
1331      */
1332     function _afterTokenTransfers(
1333         address from,
1334         address to,
1335         uint256 startTokenId,
1336         uint256 quantity
1337     ) internal virtual {}
1338 }
1339 
1340 
1341 // File contracts/GoGhost.sol
1342 
1343 
1344 pragma solidity ^0.8.4;
1345 
1346 
1347 
1348 contract GoGhost is ERC721A, Ownable {
1349   enum MintType {
1350     Standard,
1351     Whitelist,
1352     Free
1353   }
1354 
1355   string coverCid;
1356   bytes32 revealedCidHash;
1357   string revealedCid;
1358   uint256 maxSupply;
1359   bool revealed;
1360   address signer;
1361   mapping(address => uint256) mintedCount;
1362   uint256 whitelistMintedCount;
1363   uint256 freeMintMintedCount;
1364 
1365   constructor(
1366     address _signer,
1367     string memory collectionName,
1368     string memory collectionSymbol,
1369     string memory _coverCid,
1370     bytes32 _revealedCidHash,
1371     uint256 _totalSupply
1372   ) ERC721A(collectionName, collectionSymbol) {
1373     signer = _signer;
1374     coverCid = _coverCid;
1375     revealedCidHash = _revealedCidHash;
1376     maxSupply = _totalSupply;
1377   }
1378 
1379   function hashPolicy(
1380     address client,
1381     MintType mintType,
1382     uint256 unitPrice,
1383     uint256 perWalletLimit,
1384     uint256 _maxSupply,
1385     uint256 startTime,
1386     uint256 endTime,
1387     uint256 deadline
1388   ) public view returns (bytes32) {
1389     return
1390       keccak256(
1391         abi.encode(
1392           "GoGhost",
1393           address(this),
1394           client,
1395           mintType,
1396           unitPrice,
1397           perWalletLimit,
1398           _maxSupply,
1399           startTime,
1400           endTime,
1401           deadline
1402         )
1403       );
1404   }
1405 
1406   function verifyPolicySignature(
1407     address client,
1408     MintType mintType,
1409     uint256 unitPrice,
1410     uint256 perWalletLimit,
1411     uint256 _maxSupply,
1412     uint256 startTime,
1413     uint256 endTime,
1414     uint256 deadline,
1415     uint8 v,
1416     bytes32 r,
1417     bytes32 s
1418   ) public view returns (address) {
1419     bytes32 objectHash = hashPolicy(
1420       client,
1421       mintType,
1422       unitPrice,
1423       perWalletLimit,
1424       _maxSupply,
1425       startTime,
1426       endTime,
1427       deadline
1428     );
1429     bytes32 messageHash = keccak256(
1430       abi.encodePacked("\x19Ethereum Signed Message:\n32", objectHash)
1431     );
1432     return ecrecover(messageHash, v, r, s);
1433   }
1434 
1435   function mint(
1436     uint256 amount,
1437     uint256 unitPrice,
1438     uint256 perWalletLimit,
1439     uint256 startTime,
1440     uint256 endTime,
1441     uint256 deadline,
1442     uint8 v,
1443     bytes32 r,
1444     bytes32 s
1445   ) public payable {
1446     require(
1447       totalSupply() + amount <= maxSupply,
1448       "GoGhost: not enough token to mint"
1449     );
1450     require(msg.value == amount * unitPrice, "GoGhost: insufficient value");
1451     require(
1452       mintedCount[msg.sender] + amount <= perWalletLimit,
1453       "GoGhost: reached the per wallet limit"
1454     );
1455     require(
1456       block.timestamp >= startTime,
1457       "GoGhost: minting feature is disabled"
1458     );
1459     require(
1460       block.timestamp <= endTime,
1461       "GoGhost: minting feature is disabled"
1462     );
1463     require(block.timestamp <= deadline, "GoGhost: signature is expired");
1464     require(
1465       verifyPolicySignature(
1466         msg.sender,
1467         MintType.Standard,
1468         unitPrice,
1469         perWalletLimit,
1470         0,
1471         startTime,
1472         endTime,
1473         deadline,
1474         v,
1475         r,
1476         s
1477       ) == signer,
1478       "GoGhost: invalid signature"
1479     );
1480 
1481     mintedCount[msg.sender] += amount;
1482     _safeMint(msg.sender, amount);
1483   }
1484 
1485   function whitelistMint(
1486     uint256 amount,
1487     uint256 unitPrice,
1488     uint256 perWalletLimit,
1489     uint256 whitelistMaxSupply,
1490     uint256 startTime,
1491     uint256 endTime,
1492     uint256 deadline,
1493     uint8 v,
1494     bytes32 r,
1495     bytes32 s
1496   ) public payable {
1497     require(
1498       totalSupply() + amount <= maxSupply,
1499       "GoGhost: not enough token to mint"
1500     );
1501     require(msg.value == amount * unitPrice, "GoGhost: insufficient value");
1502     require(
1503       mintedCount[msg.sender] + amount <= perWalletLimit,
1504       "GoGhost: reached the per wallet limit"
1505     );
1506     require(
1507       block.timestamp >= startTime,
1508       "GoGhost: minting feature is disabled"
1509     );
1510     require(
1511       block.timestamp <= endTime,
1512       "GoGhost: minting feature is disabled"
1513     );
1514     require(block.timestamp <= deadline, "GoGhost: signature is expired");
1515     require(
1516       whitelistMintedCount + amount <= whitelistMaxSupply,
1517       "GoGhost: reached the whitelist limit"
1518     );
1519     require(
1520       verifyPolicySignature(
1521         msg.sender,
1522         MintType.Whitelist,
1523         unitPrice,
1524         perWalletLimit,
1525         whitelistMaxSupply,
1526         startTime,
1527         endTime,
1528         deadline,
1529         v,
1530         r,
1531         s
1532       ) == signer,
1533       "GoGhost: invalid signature"
1534     );
1535 
1536     mintedCount[msg.sender] += amount;
1537     whitelistMintedCount += amount;
1538     _safeMint(msg.sender, amount);
1539   }
1540 
1541   function freeMint(
1542     uint256 amount,
1543     uint256 perWalletLimit,
1544     uint256 freeMintMaxSupply,
1545     uint256 startTime,
1546     uint256 endTime,
1547     uint256 deadline,
1548     uint8 v,
1549     bytes32 r,
1550     bytes32 s
1551   ) public {
1552     require(
1553       totalSupply() + amount <= maxSupply,
1554       "GoGhost: not enough token to mint"
1555     );
1556     require(
1557       mintedCount[msg.sender] + amount <= perWalletLimit,
1558       "GoGhost: reached the per wallet limit"
1559     );
1560     require(
1561       block.timestamp >= startTime,
1562       "GoGhost: minting feature is disabled"
1563     );
1564     require(
1565       block.timestamp <= endTime,
1566       "GoGhost: minting feature is disabled"
1567     );
1568     require(block.timestamp <= deadline, "GoGhost: signature is expired");
1569     require(
1570       whitelistMintedCount + amount <= freeMintMaxSupply,
1571       "GoGhost: reached the free mint limit"
1572     );
1573     require(
1574       verifyPolicySignature(
1575         msg.sender,
1576         MintType.Free,
1577         0,
1578         perWalletLimit,
1579         freeMintMaxSupply,
1580         startTime,
1581         endTime,
1582         deadline,
1583         v,
1584         r,
1585         s
1586       ) == signer,
1587       "GoGhost: invalid signature"
1588     );
1589 
1590     mintedCount[msg.sender] += amount;
1591     freeMintMintedCount += amount;
1592     _safeMint(msg.sender, amount);
1593   }
1594 
1595   function reveal(string memory _revealedCid) public onlyOwner {
1596     require(!revealed, "GoGhost: already revealed");
1597     require(
1598       keccak256(bytes(_revealedCid)) == revealedCidHash,
1599       "GoGhost: Revealed CID not matched"
1600     );
1601 
1602     revealed = true;
1603     revealedCid = _revealedCid;
1604   }
1605 
1606   function tokenURI(uint256 tokenId)
1607     public
1608     view
1609     override(ERC721A)
1610     returns (string memory)
1611   {
1612     if (revealed) {
1613       return
1614         string(
1615           abi.encodePacked(
1616             "https://",
1617             revealedCid,
1618             ".ipfs.nftstorage.link/metadata/",
1619             Strings.toString(tokenId + 1),
1620             ".json"
1621           )
1622         );
1623     } else {
1624       return string(abi.encodePacked("https://", coverCid, ".ipfs.nftstorage.link/cover.json"));
1625     }
1626   }
1627 
1628   function collectFee() onlyOwner public {
1629     payable(address(owner())).transfer(address(this).balance);
1630   }
1631 }
1632 
1633 
1634 // File contracts/Storage.sol