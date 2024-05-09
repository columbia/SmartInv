1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 /// @title Binkies
5 /// @author André Costa @ Terratecc
6 
7 
8 /**                                                                                                                                   
9                                                                                                                                                       
10   @@@@@@@@@@@@@@@@@@(                                                     @@@@@                                                                       
11  @@@@@@@@@@@@@@@@@@@@@/         .@@@@                                    &@@@@@@                   #@@@&                                              
12  @@@@@@@@@%##&@@@@@@@@@        @@@@@@@@                                  &@@@@@@                 %@@@@@@@(                                            
13  @@@@@@@.        @@@@@@/       @@@@@@@@                                  %@@@@@@                 (@@@@@@@%                               @@@@@@@@@&   
14  @@@@@@@         @@@@@@          @@@@         @@@@@    @@@,              (@@@@@@    .@@@@@@@       ,@@@(            @@@@@@@@@          @@@@@@@@@@@@@  
15  @@@@@@@@@@@@@@@@@@@@@           &@@%        @@@@@@@@@@@@@@@@@@&         *@@@@@@ (@@@@@@@@@@        @@@          @@@@@@@@@@@@@@@      @@@@@@@@@@@@@&  
16  @@@@@@@@@@@@@@@@@@@@@         @@@@@@@       @@@@@@@@@@@@@@@@@@@@,       ,@@@@@@@@@@@@@@@@        @@@@@@@       @@@@@@@*  ,@@@@@@     @@@@@@(         
17  @@@@@@@@@@@@@@@@@@@@@@        @@@@@@@&      @@@@@@@@(     %@@@@@@       .@@@@@@@@@@@@@          %@@@@@@@      @@@@@@@*    @@@@@@@     @@@@@@@@@(     
18  @@@@@@@.        @@@@@@@       @@@@@@@@      @@@@@@@        (@@@@@@      .@@@@@@@@@@@@           @@@@@@@@      @@@@@@@@@@@@@@@@@@        @@@@@@@@@@   
19  @@@@@@@.        &@@@@@@       @@@@@@@@      @@@@@@@        .@@@@@@       @@@@@@@@@@@@@@         @@@@@@@@.     @@@@@@@@@@@@@@@               *@@@@@@  
20  @@@@@@@@&#(/(&@@@@@@@@@       @@@@@@@@      @@@@@@@         @@@@@@       @@@@@@@@@@@@@@@@*      &@@@@@@@       @@@@@@@@@#*(@@@       #@@@@@@@@@@@@@( 
21  @@@@@@@@@@@@@@@@@@@@@@        @@@@@@@#      &@@@@@@         @@@@@@       @@@@@@  .@@@@@@@@@      @@@@@@@        @@@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@  
22   @@@@@@@@@@@@@@@@@@@          %@@@@@@        @@@@@@         @@@@@@       @@@@@@     @@@@@@       @@@@@@%          *@@@@@@@@@@@&      (@@@@@@@@@@@    
23 
24   */
25 
26 
27 pragma solidity ^0.8.9;
28 
29 /**
30  * @dev String operations.
31  */
32 library Strings {
33     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
37      */
38     function toString(uint256 value) internal pure returns (string memory) {
39         // Inspired by OraclizeAPI's implementation - MIT licence
40         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
41 
42         if (value == 0) {
43             return "0";
44         }
45         uint256 temp = value;
46         uint256 digits;
47         while (temp != 0) {
48             digits++;
49             temp /= 10;
50         }
51         bytes memory buffer = new bytes(digits);
52         while (value != 0) {
53             digits -= 1;
54             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
55             value /= 10;
56         }
57         return string(buffer);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
62      */
63     function toHexString(uint256 value) internal pure returns (string memory) {
64         if (value == 0) {
65             return "0x00";
66         }
67         uint256 temp = value;
68         uint256 length = 0;
69         while (temp != 0) {
70             length++;
71             temp >>= 8;
72         }
73         return toHexString(value, length);
74     }
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
78      */
79     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
80         bytes memory buffer = new bytes(2 * length + 2);
81         buffer[0] = "0";
82         buffer[1] = "x";
83         for (uint256 i = 2 * length + 1; i > 1; --i) {
84             buffer[i] = _HEX_SYMBOLS[value & 0xf];
85             value >>= 4;
86         }
87         require(value == 0, "Strings: hex length insufficient");
88         return string(buffer);
89     }
90 }
91 
92 // File: @openzeppelin/contracts/utils/Context.sol
93 
94 
95 
96 pragma solidity ^0.8.9;
97 
98 /**
99  * @dev Provides information about the current execution context, including the
100  * sender of the transaction and its data. While these are generally available
101  * via msg.sender and msg.data, they should not be accessed in such a direct
102  * manner, since when dealing with meta-transactions the account sending and
103  * paying for execution may not be the actual sender (as far as an application
104  * is concerned).
105  *
106  * This contract is only required for intermediate, library-like contracts.
107  */
108 abstract contract Context {
109     function _msgSender() internal view virtual returns (address) {
110         return msg.sender;
111     }
112 
113     function _msgData() internal view virtual returns (bytes calldata) {
114         return msg.data;
115     }
116 }
117 
118 // File: @openzeppelin/contracts/access/Ownable.sol
119 
120 
121 
122 pragma solidity ^0.8.9;
123 
124 
125 /**
126  * @dev Contract module which provides a basic access control mechanism, where
127  * there is an account (an owner) that can be granted exclusive access to
128  * specific functions.
129  *
130  * By default, the owner account will be the one that deploys the contract. This
131  * can later be changed with {transferOwnership}.
132  *
133  * This module is used through inheritance. It will make available the modifier
134  * `onlyOwner`, which can be applied to your functions to restrict their use to
135  * the owner.
136  */
137 abstract contract Ownable is Context {
138     address private _owner;
139 
140     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142     /**
143      * @dev Initializes the contract setting the deployer as the initial owner.
144      */
145     constructor() {
146         _setOwner(_msgSender());
147     }
148 
149     /**
150      * @dev Returns the address of the current owner.
151      */
152     function owner() public view virtual returns (address) {
153         return _owner;
154     }
155 
156     /**
157      * @dev Throws if called by any account other than the owner.
158      */
159     modifier onlyOwner() {
160         require(owner() == _msgSender(), "Ownable: caller is not the owner");
161         _;
162     }
163 
164     /**
165      * @dev Leaves the contract without owner. It will not be possible to call
166      * `onlyOwner` functions anymore. Can only be called by the current owner.
167      *
168      * NOTE: Renouncing ownership will leave the contract without an owner,
169      * thereby removing any functionality that is only available to the owner.
170      */
171     function renounceOwnership() public virtual onlyOwner {
172         _setOwner(address(0));
173     }
174 
175     /**
176      * @dev Transfers ownership of the contract to a new account (`newOwner`).
177      * Can only be called by the current owner.
178      */
179     function transferOwnership(address newOwner) public virtual onlyOwner {
180         require(newOwner != address(0), "Ownable: new owner is the zero address");
181         _setOwner(newOwner);
182     }
183 
184     function _setOwner(address newOwner) private {
185         address oldOwner = _owner;
186         _owner = newOwner;
187         emit OwnershipTransferred(oldOwner, newOwner);
188     }
189 }
190 
191 // File: @openzeppelin/contracts/utils/Address.sol
192 
193 
194 
195 pragma solidity ^0.8.9;
196 
197 /**
198  * @dev Collection of functions related to the address type
199  */
200 library Address {
201     /**
202      * @dev Returns true if `account` is a contract.
203      *
204      * [IMPORTANT]
205      * ====
206      * It is unsafe to assume that an address for which this function returns
207      * false is an externally-owned account (EOA) and not a contract.
208      *
209      * Among others, `isContract` will return false for the following
210      * types of addresses:
211      *
212      *  - an externally-owned account
213      *  - a contract in construction
214      *  - an address where a contract will be created
215      *  - an address where a contract lived, but was destroyed
216      * ====
217      */
218     function isContract(address account) internal view returns (bool) {
219         // This method relies on extcodesize, which returns 0 for contracts in
220         // construction, since the code is only stored at the end of the
221         // constructor execution.
222 
223         uint256 size;
224         assembly {
225             size := extcodesize(account)
226         }
227         return size > 0;
228     }
229 
230     /**
231      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
232      * `recipient`, forwarding all available gas and reverting on errors.
233      *
234      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
235      * of certain opcodes, possibly making contracts go over the 2300 gas limit
236      * imposed by `transfer`, making them unable to receive funds via
237      * `transfer`. {sendValue} removes this limitation.
238      *
239      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
240      *
241      * IMPORTANT: because control is transferred to `recipient`, care must be
242      * taken to not create reentrancy vulnerabilities. Consider using
243      * {ReentrancyGuard} or the
244      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
245      */
246     function sendValue(address payable recipient, uint256 amount) internal {
247         require(address(this).balance >= amount, "Address: insufficient balance");
248 
249         (bool success, ) = recipient.call{value: amount}("");
250         require(success, "Address: unable to send value, recipient may have reverted");
251     }
252 
253     /**
254      * @dev Performs a Solidity function call using a low level `call`. A
255      * plain `call` is an unsafe replacement for a function call: use this
256      * function instead.
257      *
258      * If `target` reverts with a revert reason, it is bubbled up by this
259      * function (like regular Solidity function calls).
260      *
261      * Returns the raw returned data. To convert to the expected return value,
262      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
263      *
264      * Requirements:
265      *
266      * - `target` must be a contract.
267      * - calling `target` with `data` must not revert.
268      *
269      * _Available since v3.1._
270      */
271     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
272         return functionCall(target, data, "Address: low-level call failed");
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
277      * `errorMessage` as a fallback revert reason when `target` reverts.
278      *
279      * _Available since v3.1._
280      */
281     function functionCall(
282         address target,
283         bytes memory data,
284         string memory errorMessage
285     ) internal returns (bytes memory) {
286         return functionCallWithValue(target, data, 0, errorMessage);
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
291      * but also transferring `value` wei to `target`.
292      *
293      * Requirements:
294      *
295      * - the calling contract must have an ETH balance of at least `value`.
296      * - the called Solidity function must be `payable`.
297      *
298      * _Available since v3.1._
299      */
300     function functionCallWithValue(
301         address target,
302         bytes memory data,
303         uint256 value
304     ) internal returns (bytes memory) {
305         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
310      * with `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCallWithValue(
315         address target,
316         bytes memory data,
317         uint256 value,
318         string memory errorMessage
319     ) internal returns (bytes memory) {
320         require(address(this).balance >= value, "Address: insufficient balance for call");
321         require(isContract(target), "Address: call to non-contract");
322 
323         (bool success, bytes memory returndata) = target.call{value: value}(data);
324         return verifyCallResult(success, returndata, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but performing a static call.
330      *
331      * _Available since v3.3._
332      */
333     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
334         return functionStaticCall(target, data, "Address: low-level static call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
339      * but performing a static call.
340      *
341      * _Available since v3.3._
342      */
343     function functionStaticCall(
344         address target,
345         bytes memory data,
346         string memory errorMessage
347     ) internal view returns (bytes memory) {
348         require(isContract(target), "Address: static call to non-contract");
349 
350         (bool success, bytes memory returndata) = target.staticcall(data);
351         return verifyCallResult(success, returndata, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but performing a delegate call.
357      *
358      * _Available since v3.4._
359      */
360     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
361         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
366      * but performing a delegate call.
367      *
368      * _Available since v3.4._
369      */
370     function functionDelegateCall(
371         address target,
372         bytes memory data,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         require(isContract(target), "Address: delegate call to non-contract");
376 
377         (bool success, bytes memory returndata) = target.delegatecall(data);
378         return verifyCallResult(success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
383      * revert reason using the provided one.
384      *
385      * _Available since v4.3._
386      */
387     function verifyCallResult(
388         bool success,
389         bytes memory returndata,
390         string memory errorMessage
391     ) internal pure returns (bytes memory) {
392         if (success) {
393             return returndata;
394         } else {
395             // Look for revert reason and bubble it up if present
396             if (returndata.length > 0) {
397                 // The easiest way to bubble the revert reason is using memory via assembly
398 
399                 assembly {
400                     let returndata_size := mload(returndata)
401                     revert(add(32, returndata), returndata_size)
402                 }
403             } else {
404                 revert(errorMessage);
405             }
406         }
407     }
408 }
409 
410 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
411 
412 pragma solidity ^0.8.9;
413 
414 /**
415  * @title ERC721 token receiver interface
416  * @dev Interface for any contract that wants to support safeTransfers
417  * from ERC721 asset contracts.
418  */
419 interface IERC721Receiver {
420     /**
421      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
422      * by `operator` from `from`, this function is called.
423      *
424      * It must return its Solidity selector to confirm the token transfer.
425      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
426      *
427      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
428      */
429     function onERC721Received(
430         address operator,
431         address from,
432         uint256 tokenId,
433         bytes calldata data
434     ) external returns (bytes4);
435 }
436 
437 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
438 
439 
440 
441 pragma solidity ^0.8.9;
442 
443 /**
444  * @dev Interface of the ERC165 standard, as defined in the
445  * https://eips.ethereum.org/EIPS/eip-165[EIP].
446  *
447  * Implementers can declare support of contract interfaces, which can then be
448  * queried by others ({ERC165Checker}).
449  *
450  * For an implementation, see {ERC165}.
451  */
452 interface IERC165 {
453     /**
454      * @dev Returns true if this contract implements the interface defined by
455      * `interfaceId`. See the corresponding
456      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
457      * to learn more about how these ids are created.
458      *
459      * This function call must use less than 30 000 gas.
460      */
461     function supportsInterface(bytes4 interfaceId) external view returns (bool);
462 }
463 
464 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
465 
466 
467 
468 pragma solidity ^0.8.9;
469 
470 
471 /**
472  * @dev Implementation of the {IERC165} interface.
473  *
474  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
475  * for the additional interface id that will be supported. For example:
476  *
477  * ```solidity
478  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
479  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
480  * }
481  * ```
482  *
483  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
484  */
485 abstract contract ERC165 is IERC165 {
486     /**
487      * @dev See {IERC165-supportsInterface}.
488      */
489     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
490         return interfaceId == type(IERC165).interfaceId;
491     }
492 }
493 
494 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
495 
496 
497 
498 pragma solidity ^0.8.9;
499 
500 
501 /**
502  * @dev Required interface of an ERC721 compliant contract.
503  */
504 interface IERC721 is IERC165 {
505     /**
506      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
507      */
508     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
509 
510     /**
511      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
512      */
513     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
514 
515     /**
516      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
517      */
518     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
519 
520     /**
521      * @dev Returns the number of tokens in ``owner``'s account.
522      */
523     function balanceOf(address owner) external view returns (uint256 balance);
524 
525     /**
526      * @dev Returns the owner of the `tokenId` token.
527      *
528      * Requirements:
529      *
530      * - `tokenId` must exist.
531      */
532     function ownerOf(uint256 tokenId) external view returns (address owner);
533 
534     /**
535      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
536      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
537      *
538      * Requirements:
539      *
540      * - `from` cannot be the zero address.
541      * - `to` cannot be the zero address.
542      * - `tokenId` token must exist and be owned by `from`.
543      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
544      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
545      *
546      * Emits a {Transfer} event.
547      */
548     function safeTransferFrom(
549         address from,
550         address to,
551         uint256 tokenId
552     ) external;
553 
554     /**
555      * @dev Transfers `tokenId` token from `from` to `to`.
556      *
557      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
558      *
559      * Requirements:
560      *
561      * - `from` cannot be the zero address.
562      * - `to` cannot be the zero address.
563      * - `tokenId` token must be owned by `from`.
564      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
565      *
566      * Emits a {Transfer} event.
567      */
568     function transferFrom(
569         address from,
570         address to,
571         uint256 tokenId
572     ) external;
573 
574     /**
575      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
576      * The approval is cleared when the token is transferred.
577      *
578      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
579      *
580      * Requirements:
581      *
582      * - The caller must own the token or be an approved operator.
583      * - `tokenId` must exist.
584      *
585      * Emits an {Approval} event.
586      */
587     function approve(address to, uint256 tokenId) external;
588 
589     /**
590      * @dev Returns the account approved for `tokenId` token.
591      *
592      * Requirements:
593      *
594      * - `tokenId` must exist.
595      */
596     function getApproved(uint256 tokenId) external view returns (address operator);
597 
598     /**
599      * @dev Approve or remove `operator` as an operator for the caller.
600      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
601      *
602      * Requirements:
603      *
604      * - The `operator` cannot be the caller.
605      *
606      * Emits an {ApprovalForAll} event.
607      */
608     function setApprovalForAll(address operator, bool _approved) external;
609 
610     /**
611      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
612      *
613      * See {setApprovalForAll}
614      */
615     function isApprovedForAll(address owner, address operator) external view returns (bool);
616 
617     /**
618      * @dev Safely transfers `tokenId` token from `from` to `to`.
619      *
620      * Requirements:
621      *
622      * - `from` cannot be the zero address.
623      * - `to` cannot be the zero address.
624      * - `tokenId` token must exist and be owned by `from`.
625      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
626      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
627      *
628      * Emits a {Transfer} event.
629      */
630     function safeTransferFrom(
631         address from,
632         address to,
633         uint256 tokenId,
634         bytes calldata data
635     ) external;
636 }
637 
638 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
639 
640 
641 
642 pragma solidity ^0.8.9;
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
667 pragma solidity >=0.8.9;
668 // to enable certain compiler features
669 
670 
671 
672 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
673     using Address for address;
674     using Strings for uint256;
675 
676     // Token name
677     string private _name;
678 
679     // Token symbol
680     string private _symbol;
681 
682     // Mapping from token ID to owner address
683     mapping(uint256 => address) private _owners;
684 
685     // Mapping owner address to token count
686     mapping(address => uint256) private _balances;
687 
688     // Mapping from token ID to approved address
689     mapping(uint256 => address) private _tokenApprovals;
690 
691     // Mapping from owner to operator approvals
692     mapping(address => mapping(address => bool)) private _operatorApprovals;
693     
694     //Mapping para atribuirle un URI para cada token
695     mapping(uint256 => string) internal id_to_URI;
696 
697     /**
698      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
699      */
700     constructor(string memory name_, string memory symbol_) {
701         _name = name_;
702         _symbol = symbol_;
703     }
704 
705     /**
706      * @dev See {IERC165-supportsInterface}.
707      */
708     
709     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
710         return
711             interfaceId == type(IERC721).interfaceId ||
712             interfaceId == type(IERC721Metadata).interfaceId ||
713             super.supportsInterface(interfaceId);
714     }
715     
716 
717     /**
718      * @dev See {IERC721-balanceOf}.
719      */
720     function balanceOf(address owner) public view virtual override returns (uint256) {
721         require(owner != address(0), "ERC721: balance query for the zero address");
722         return _balances[owner];
723     }
724 
725     /**
726      * @dev See {IERC721-ownerOf}.
727      */
728     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
729         address owner = _owners[tokenId];
730         require(owner != address(0), "ERC721: owner query for nonexistent token");
731         return owner;
732     }
733 
734     /**
735      * @dev See {IERC721Metadata-name}.
736      */
737     function name() public view virtual override returns (string memory) {
738         return _name;
739     }
740 
741     /**
742      * @dev See {IERC721Metadata-symbol}.
743      */
744     function symbol() public view virtual override returns (string memory) {
745         return _symbol;
746     }
747 
748     /**
749      * @dev See {IERC721Metadata-tokenURI}.
750      */
751     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {  }
752 
753     /**
754      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
755      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
756      * by default, can be overriden in child contracts.
757      */
758     function _baseURI() internal view virtual returns (string memory) {
759         return "";
760     }
761 
762     /**
763      * @dev See {IERC721-approve}.
764      */
765     function approve(address to, uint256 tokenId) public virtual override {
766         address owner = ERC721.ownerOf(tokenId);
767         require(to != owner, "ERC721: approval to current owner");
768 
769         require(
770             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
771             "ERC721: approve caller is not owner nor approved for all"
772         );
773 
774         _approve(to, tokenId);
775     }
776 
777     /**
778      * @dev See {IERC721-getApproved}.
779      */
780     function getApproved(uint256 tokenId) public view virtual override returns (address) {
781         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
782 
783         return _tokenApprovals[tokenId];
784     }
785 
786     /**
787      * @dev See {IERC721-setApprovalForAll}.
788      */
789     function setApprovalForAll(address operator, bool approved) public virtual override {
790         require(operator != _msgSender(), "ERC721: approve to caller");
791 
792         _operatorApprovals[_msgSender()][operator] = approved;
793         emit ApprovalForAll(_msgSender(), operator, approved);
794     }
795 
796     /**
797      * @dev See {IERC721-isApprovedForAll}.
798      */
799     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
800         return _operatorApprovals[owner][operator];
801     }
802 
803     /**
804      * @dev See {IERC721-transferFrom}.
805      */
806     function transferFrom(
807         address from,
808         address to,
809         uint256 tokenId
810     ) public virtual override {
811         //solhint-disable-next-line max-line-length
812         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
813 
814         _transfer(from, to, tokenId);
815     }
816 
817     /**
818      * @dev See {IERC721-safeTransferFrom}.
819      */
820     function safeTransferFrom(
821         address from,
822         address to,
823         uint256 tokenId
824     ) public virtual override {
825         safeTransferFrom(from, to, tokenId, "");
826     }
827 
828     /**
829      * @dev See {IERC721-safeTransferFrom}.
830      */
831     function safeTransferFrom(
832         address from,
833         address to,
834         uint256 tokenId,
835         bytes memory _data
836     ) public virtual override {
837         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
838         _safeTransfer(from, to, tokenId, _data);
839     }
840 
841     /**
842      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
843      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
844      *
845      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
846      *
847      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
848      * implement alternative mechanisms to perform token transfer, such as signature-based.
849      *
850      * Requirements:
851      *
852      * - `from` cannot be the zero address.
853      * - `to` cannot be the zero address.
854      * - `tokenId` token must exist and be owned by `from`.
855      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
856      *
857      * Emits a {Transfer} event.
858      */
859     function _safeTransfer(
860         address from,
861         address to,
862         uint256 tokenId,
863         bytes memory _data
864     ) internal virtual {
865         _transfer(from, to, tokenId);
866         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
867     }
868 
869     /**
870      * @dev Returns whether `tokenId` exists.
871      *
872      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
873      *
874      * Tokens start existing when they are minted (`_mint`),
875      * and stop existing when they are burned (`_burn`).
876      */
877     function _exists(uint256 tokenId) internal view virtual returns (bool) {
878         return _owners[tokenId] != address(0);
879     }
880 
881     /**
882      * @dev Returns whether `spender` is allowed to manage `tokenId`.
883      *
884      * Requirements:
885      *
886      * - `tokenId` must exist.
887      */
888     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
889         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
890         address owner = ERC721.ownerOf(tokenId);
891         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
892     }
893 
894     /**
895      * @dev Safely mints `tokenId` and transfers it to `to`.
896      *
897      * Requirements:
898      *
899      * - `tokenId` must not exist.
900      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _safeMint(address to, uint256 tokenId) internal virtual {
905         _safeMint(to, tokenId, "");
906     }
907 
908     /**
909      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
910      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
911      */
912     function _safeMint(
913         address to,
914         uint256 tokenId,
915         bytes memory _data
916     ) internal virtual {
917         _mint(to, tokenId);
918         require(
919             _checkOnERC721Received(address(0), to, tokenId, _data),
920             "ERC721: transfer to non ERC721Receiver implementer"
921         );
922     }
923 
924     /**
925      * @dev Mints `tokenId` and transfers it to `to`.
926      *
927      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
928      *
929      * Requirements:
930      *
931      * - `tokenId` must not exist.
932      * - `to` cannot be the zero address.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _mint(address to, uint256 tokenId) internal virtual {
937         require(to != address(0), "ERC721: mint to the zero address");
938         require(!_exists(tokenId), "ERC721: token already minted");
939 
940         _beforeTokenTransfer(address(0), to, tokenId);
941 
942         _balances[to] += 1;
943         _owners[tokenId] = to;
944 
945         emit Transfer(address(0), to, tokenId);
946     }
947 
948     /**
949      * @dev Destroys `tokenId`.
950      * The approval is cleared when the token is burned.
951      *
952      * Requirements:
953      *
954      * - `tokenId` must exist.
955      *
956      * Emits a {Transfer} event.
957      */
958     function _burn(uint256 tokenId) internal virtual {
959         address owner = ERC721.ownerOf(tokenId);
960 
961         _beforeTokenTransfer(owner, address(0), tokenId);
962 
963         // Clear approvals
964         _approve(address(0), tokenId);
965 
966         _balances[owner] -= 1;
967         delete _owners[tokenId];
968 
969         emit Transfer(owner, address(0), tokenId);
970     }
971 
972     /**
973      * @dev Transfers `tokenId` from `from` to `to`.
974      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
975      *
976      * Requirements:
977      *
978      * - `to` cannot be the zero address.
979      * - `tokenId` token must be owned by `from`.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _transfer(
984         address from,
985         address to,
986         uint256 tokenId
987     ) internal virtual {
988         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
989         require(to != address(0), "ERC721: transfer to the zero address");
990 
991         _beforeTokenTransfer(from, to, tokenId);
992 
993         // Clear approvals from the previous owner
994         _approve(address(0), tokenId);
995 
996         _balances[from] -= 1;
997         _balances[to] += 1;
998         _owners[tokenId] = to;
999 
1000         emit Transfer(from, to, tokenId);
1001     }
1002 
1003     /**
1004      * @dev Approve `to` to operate on `tokenId`
1005      *
1006      * Emits a {Approval} event.
1007      */
1008     function _approve(address to, uint256 tokenId) internal virtual {
1009         _tokenApprovals[tokenId] = to;
1010         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1011     }
1012 
1013     /**
1014      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1015      * The call is not executed if the target address is not a contract.
1016      *
1017      * @param from address representing the previous owner of the given token ID
1018      * @param to target address that will receive the tokens
1019      * @param tokenId uint256 ID of the token to be transferred
1020      * @param _data bytes optional data to send along with the call
1021      * @return bool whether the call correctly returned the expected magic value
1022      */
1023     function _checkOnERC721Received(
1024         address from,
1025         address to,
1026         uint256 tokenId,
1027         bytes memory _data
1028     ) private returns (bool) {
1029         if (to.isContract()) {
1030             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1031                 return retval == IERC721Receiver.onERC721Received.selector;
1032             } catch (bytes memory reason) {
1033                 if (reason.length == 0) {
1034                     revert("ERC721: transfer to non ERC721Receiver implementer");
1035                 } else {
1036                     assembly {
1037                         revert(add(32, reason), mload(reason))
1038                     }
1039                 }
1040             }
1041         } else {
1042             return true;
1043         }
1044     }
1045 
1046     /**
1047      * @dev Hook that is called before any token transfer. This includes minting
1048      * and burning.
1049      *
1050      * Calling conditions:
1051      *
1052      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1053      * transferred to `to`.
1054      * - When `from` is zero, `tokenId` will be minted for `to`.
1055      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1056      * - `from` and `to` are never both zero.
1057      *
1058      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1059      */
1060     function _beforeTokenTransfer(
1061         address from,
1062         address to,
1063         uint256 tokenId
1064     ) internal virtual {}
1065 }
1066 
1067 pragma solidity ^0.8.9;
1068 
1069 /**
1070  * @dev Contract module that helps prevent reentrant calls to a function.
1071  *
1072  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1073  * available, which can be applied to functions to make sure there are no nested
1074  * (reentrant) calls to them.
1075  *
1076  * Note that because there is a single `nonReentrant` guard, functions marked as
1077  * `nonReentrant` may not call one another. This can be worked around by making
1078  * those functions `private`, and then adding `external` `nonReentrant` entry
1079  * points to them.
1080  *
1081  * TIP: If you would like to learn more about reentrancy and alternative ways
1082  * to protect against it, check out our blog post
1083  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1084  */
1085 abstract contract ReentrancyGuard {
1086     // Booleans are more expensive than uint256 or any type that takes up a full
1087     // word because each write operation emits an extra SLOAD to first read the
1088     // slot's contents, replace the bits taken up by the boolean, and then write
1089     // back. This is the compiler's defense against contract upgrades and
1090     // pointer aliasing, and it cannot be disabled.
1091 
1092     // The values being non-zero value makes deployment a bit more expensive,
1093     // but in exchange the refund on every call to nonReentrant will be lower in
1094     // amount. Since refunds are capped to a percentage of the total
1095     // transaction's gas, it is best to keep them low in cases like this one, to
1096     // increase the likelihood of the full refund coming into effect.
1097     uint256 private constant _NOT_ENTERED = 1;
1098     uint256 private constant _ENTERED = 2;
1099 
1100     uint256 private _status;
1101 
1102     constructor() {
1103         _status = _NOT_ENTERED;
1104     }
1105 
1106     /**
1107      * @dev Prevents a contract from calling itself, directly or indirectly.
1108      * Calling a `nonReentrant` function from another `nonReentrant`
1109      * function is not supported. It is possible to prevent this from happening
1110      * by making the `nonReentrant` function external, and making it call a
1111      * `private` function that does the actual work.
1112      */
1113     modifier nonReentrant() {
1114         // On the first call to nonReentrant, _notEntered will be true
1115         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1116 
1117         // Any calls to nonReentrant after this point will fail
1118         _status = _ENTERED;
1119 
1120         _;
1121 
1122         // By storing the original value once again, a refund is triggered (see
1123         // https://eips.ethereum.org/EIPS/eip-2200)
1124         _status = _NOT_ENTERED;
1125     }
1126 }
1127 
1128 
1129 pragma solidity ^0.8.9;
1130 
1131 /**
1132  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1133  * @dev See https://eips.ethereum.org/EIPS/eip-721
1134  */
1135 interface IERC721Enumerable is IERC721 {
1136     /**
1137      * @dev Returns the total amount of tokens stored by the contract.
1138      */
1139     function totalSupply() external view returns (uint256);
1140 
1141     /**
1142      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1143      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1144      */
1145     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1146 
1147     /**
1148      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1149      * Use along with {totalSupply} to enumerate all tokens.
1150      */
1151     function tokenByIndex(uint256 index) external view returns (uint256);
1152 }
1153 
1154 
1155 // Creator: Chiru Labs
1156 
1157 pragma solidity ^0.8.9;
1158 
1159 /**
1160  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1161  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1162  *
1163  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1164  *
1165  * Does not support burning tokens to address(0).
1166  *
1167  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
1168  */
1169 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1170     using Address for address;
1171     using Strings for uint256;
1172 
1173     struct TokenOwnership {
1174         address addr;
1175         uint64 startTimestamp;
1176     }
1177 
1178     struct AddressData {
1179         uint128 balance;
1180         uint128 numberMinted;
1181     }
1182 
1183     uint256 internal currentIndex;
1184 
1185     // Token name
1186     string private _name;
1187 
1188     // Token symbol
1189     string private _symbol;
1190 
1191     // Mapping from token ID to ownership details
1192     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1193     mapping(uint256 => TokenOwnership) internal _ownerships;
1194 
1195     // Mapping owner address to address data
1196     mapping(address => AddressData) private _addressData;
1197 
1198     // Mapping from token ID to approved address
1199     mapping(uint256 => address) private _tokenApprovals;
1200 
1201     // Mapping from owner to operator approvals
1202     mapping(address => mapping(address => bool)) private _operatorApprovals;
1203 
1204     constructor(string memory name_, string memory symbol_) {
1205         _name = name_;
1206         _symbol = symbol_;
1207     }
1208 
1209     /**
1210      * @dev See {IERC721Enumerable-totalSupply}.
1211      */
1212     function totalSupply() public view virtual override returns (uint256) {
1213         return currentIndex;
1214     }
1215 
1216     /**
1217      * @dev See {IERC721Enumerable-tokenByIndex}.
1218      */
1219     function tokenByIndex(uint256 index) public view override returns (uint256) {
1220         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1221         return index;
1222     }
1223 
1224     /**
1225      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1226      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1227      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1228      */
1229     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1230         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1231         uint256 numMintedSoFar = totalSupply();
1232         uint256 tokenIdsIdx;
1233         address currOwnershipAddr;
1234 
1235         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1236         unchecked {
1237             for (uint256 i; i < numMintedSoFar; i++) {
1238                 TokenOwnership memory ownership = _ownerships[i];
1239                 if (ownership.addr != address(0)) {
1240                     currOwnershipAddr = ownership.addr;
1241                 }
1242                 if (currOwnershipAddr == owner) {
1243                     if (tokenIdsIdx == index) {
1244                         return i;
1245                     }
1246                     tokenIdsIdx++;
1247                 }
1248             }
1249         }
1250 
1251         revert('ERC721A: unable to get token of owner by index');
1252     }
1253 
1254     /**
1255      * @dev See {IERC165-supportsInterface}.
1256      */
1257     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1258         return
1259             interfaceId == type(IERC721).interfaceId ||
1260             interfaceId == type(IERC721Metadata).interfaceId ||
1261             interfaceId == type(IERC721Enumerable).interfaceId ||
1262             super.supportsInterface(interfaceId);
1263     }
1264 
1265     /**
1266      * @dev See {IERC721-balanceOf}.
1267      */
1268     function balanceOf(address owner) public view override returns (uint256) {
1269         require(owner != address(0), 'ERC721A: balance query for the zero address');
1270         return uint256(_addressData[owner].balance);
1271     }
1272 
1273     function _numberMinted(address owner) internal view returns (uint256) {
1274         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1275         return uint256(_addressData[owner].numberMinted);
1276     }
1277 
1278     /**
1279      * Gas spent here starts off proportional to the maximum mint batch size.
1280      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1281      */
1282     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1283         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1284 
1285         unchecked {
1286             for (uint256 curr = tokenId; curr >= 0; curr--) {
1287                 TokenOwnership memory ownership = _ownerships[curr];
1288                 if (ownership.addr != address(0)) {
1289                     return ownership;
1290                 }
1291             }
1292         }
1293 
1294         revert('ERC721A: unable to determine the owner of token');
1295     }
1296 
1297     /**
1298      * @dev See {IERC721-ownerOf}.
1299      */
1300     function ownerOf(uint256 tokenId) public view override returns (address) {
1301         return ownershipOf(tokenId).addr;
1302     }
1303 
1304     /**
1305      * @dev See {IERC721Metadata-name}.
1306      */
1307     function name() public view virtual override returns (string memory) {
1308         return _name;
1309     }
1310 
1311     /**
1312      * @dev See {IERC721Metadata-symbol}.
1313      */
1314     function symbol() public view virtual override returns (string memory) {
1315         return _symbol;
1316     }
1317 
1318     /**
1319      * @dev See {IERC721Metadata-tokenURI}.
1320      */
1321     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1322         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1323 
1324         string memory baseURI = _baseURI();
1325         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1326     }
1327 
1328     /**
1329      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1330      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1331      * by default, can be overriden in child contracts.
1332      */
1333     function _baseURI() internal view virtual returns (string memory) {
1334         return '';
1335     }
1336 
1337     /**
1338      * @dev See {IERC721-approve}.
1339      */
1340     function approve(address to, uint256 tokenId) public override {
1341         address owner = ERC721A.ownerOf(tokenId);
1342         require(to != owner, 'ERC721A: approval to current owner');
1343 
1344         require(
1345             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1346             'ERC721A: approve caller is not owner nor approved for all'
1347         );
1348 
1349         _approve(to, tokenId, owner);
1350     }
1351 
1352     /**
1353      * @dev See {IERC721-getApproved}.
1354      */
1355     function getApproved(uint256 tokenId) public view override returns (address) {
1356         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1357 
1358         return _tokenApprovals[tokenId];
1359     }
1360 
1361     /**
1362      * @dev See {IERC721-setApprovalForAll}.
1363      */
1364     function setApprovalForAll(address operator, bool approved) public override {
1365         require(operator != _msgSender(), 'ERC721A: approve to caller');
1366 
1367         _operatorApprovals[_msgSender()][operator] = approved;
1368         emit ApprovalForAll(_msgSender(), operator, approved);
1369     }
1370 
1371     /**
1372      * @dev See {IERC721-isApprovedForAll}.
1373      */
1374     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1375         return _operatorApprovals[owner][operator];
1376     }
1377 
1378     /**
1379      * @dev See {IERC721-transferFrom}.
1380      */
1381     function transferFrom(
1382         address from,
1383         address to,
1384         uint256 tokenId
1385     ) public virtual override {
1386         _transfer(from, to, tokenId);
1387     }
1388 
1389     /**
1390      * @dev See {IERC721-safeTransferFrom}.
1391      */
1392     function safeTransferFrom(
1393         address from,
1394         address to,
1395         uint256 tokenId
1396     ) public virtual override {
1397         safeTransferFrom(from, to, tokenId, '');
1398     }
1399 
1400     /**
1401      * @dev See {IERC721-safeTransferFrom}.
1402      */
1403     function safeTransferFrom(
1404         address from,
1405         address to,
1406         uint256 tokenId,
1407         bytes memory _data
1408     ) public override {
1409         _transfer(from, to, tokenId);
1410         require(
1411             _checkOnERC721Received(from, to, tokenId, _data),
1412             'ERC721A: transfer to non ERC721Receiver implementer'
1413         );
1414     }
1415 
1416     /**
1417      * @dev Returns whether `tokenId` exists.
1418      *
1419      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1420      *
1421      * Tokens start existing when they are minted (`_mint`),
1422      */
1423     function _exists(uint256 tokenId) internal view returns (bool) {
1424         return tokenId < currentIndex;
1425     }
1426 
1427     function _safeMint(address to, uint256 quantity) internal {
1428         _safeMint(to, quantity, '');
1429     }
1430 
1431     /**
1432      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1433      *
1434      * Requirements:
1435      *
1436      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1437      * - `quantity` must be greater than 0.
1438      *
1439      * Emits a {Transfer} event.
1440      */
1441     function _safeMint(
1442         address to,
1443         uint256 quantity,
1444         bytes memory _data
1445     ) internal {
1446         _mint(to, quantity, _data, true);
1447     }
1448 
1449     /**
1450      * @dev Mints `quantity` tokens and transfers them to `to`.
1451      *
1452      * Requirements:
1453      *
1454      * - `to` cannot be the zero address.
1455      * - `quantity` must be greater than 0.
1456      *
1457      * Emits a {Transfer} event.
1458      */
1459     function _mint(
1460         address to,
1461         uint256 quantity,
1462         bytes memory _data,
1463         bool safe
1464     ) internal {
1465         uint256 startTokenId = currentIndex;
1466         require(to != address(0), 'ERC721A: mint to the zero address');
1467         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1468 
1469         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1470 
1471         // Overflows are incredibly unrealistic.
1472         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1473         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1474         unchecked {
1475             _addressData[to].balance += uint128(quantity);
1476             _addressData[to].numberMinted += uint128(quantity);
1477 
1478             _ownerships[startTokenId].addr = to;
1479             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1480 
1481             uint256 updatedIndex = startTokenId;
1482 
1483             for (uint256 i; i < quantity; i++) {
1484                 emit Transfer(address(0), to, updatedIndex);
1485                 if (safe) {
1486                     require(
1487                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1488                         'ERC721A: transfer to non ERC721Receiver implementer'
1489                     );
1490                 }
1491 
1492                 updatedIndex++;
1493             }
1494 
1495             currentIndex = updatedIndex;
1496         }
1497 
1498         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1499     }
1500 
1501     /**
1502      * @dev Transfers `tokenId` from `from` to `to`.
1503      *
1504      * Requirements:
1505      *
1506      * - `to` cannot be the zero address.
1507      * - `tokenId` token must be owned by `from`.
1508      *
1509      * Emits a {Transfer} event.
1510      */
1511     function _transfer(
1512         address from,
1513         address to,
1514         uint256 tokenId
1515     ) private {
1516         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1517 
1518         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1519             getApproved(tokenId) == _msgSender() ||
1520             isApprovedForAll(prevOwnership.addr, _msgSender()));
1521 
1522         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1523 
1524         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1525         require(to != address(0), 'ERC721A: transfer to the zero address');
1526 
1527         _beforeTokenTransfers(from, to, tokenId, 1);
1528 
1529         // Clear approvals from the previous owner
1530         _approve(address(0), tokenId, prevOwnership.addr);
1531 
1532         // Underflow of the sender's balance is impossible because we check for
1533         // ownership above and the recipient's balance can't realistically overflow.
1534         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1535         unchecked {
1536             _addressData[from].balance -= 1;
1537             _addressData[to].balance += 1;
1538 
1539             _ownerships[tokenId].addr = to;
1540             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1541 
1542             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1543             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1544             uint256 nextTokenId = tokenId + 1;
1545             if (_ownerships[nextTokenId].addr == address(0)) {
1546                 if (_exists(nextTokenId)) {
1547                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1548                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1549                 }
1550             }
1551         }
1552 
1553         emit Transfer(from, to, tokenId);
1554         _afterTokenTransfers(from, to, tokenId, 1);
1555     }
1556 
1557     /**
1558      * @dev Approve `to` to operate on `tokenId`
1559      *
1560      * Emits a {Approval} event.
1561      */
1562     function _approve(
1563         address to,
1564         uint256 tokenId,
1565         address owner
1566     ) private {
1567         _tokenApprovals[tokenId] = to;
1568         emit Approval(owner, to, tokenId);
1569     }
1570 
1571     /**
1572      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1573      * The call is not executed if the target address is not a contract.
1574      *
1575      * @param from address representing the previous owner of the given token ID
1576      * @param to target address that will receive the tokens
1577      * @param tokenId uint256 ID of the token to be transferred
1578      * @param _data bytes optional data to send along with the call
1579      * @return bool whether the call correctly returned the expected magic value
1580      */
1581     function _checkOnERC721Received(
1582         address from,
1583         address to,
1584         uint256 tokenId,
1585         bytes memory _data
1586     ) private returns (bool) {
1587         if (to.isContract()) {
1588             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1589                 return retval == IERC721Receiver(to).onERC721Received.selector;
1590             } catch (bytes memory reason) {
1591                 if (reason.length == 0) {
1592                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1593                 } else {
1594                     assembly {
1595                         revert(add(32, reason), mload(reason))
1596                     }
1597                 }
1598             }
1599         } else {
1600             return true;
1601         }
1602     }
1603 
1604     /**
1605      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1606      *
1607      * startTokenId - the first token id to be transferred
1608      * quantity - the amount to be transferred
1609      *
1610      * Calling conditions:
1611      *
1612      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1613      * transferred to `to`.
1614      * - When `from` is zero, `tokenId` will be minted for `to`.
1615      */
1616     function _beforeTokenTransfers(
1617         address from,
1618         address to,
1619         uint256 startTokenId,
1620         uint256 quantity
1621     ) internal virtual {}
1622 
1623     /**
1624      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1625      * minting.
1626      *
1627      * startTokenId - the first token id to be transferred
1628      * quantity - the amount to be transferred
1629      *
1630      * Calling conditions:
1631      *
1632      * - when `from` and `to` are both non-zero.
1633      * - `from` and `to` are never both zero.
1634      */
1635     function _afterTokenTransfers(
1636         address from,
1637         address to,
1638         uint256 startTokenId,
1639         uint256 quantity
1640     ) internal virtual {}
1641 }
1642 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1643 
1644 
1645 contract Binkies is ERC721A, Ownable, ReentrancyGuard {
1646     
1647     using Strings for uint256;
1648     
1649     //declares the maximum amount of tokens that can be minted, total and in presale
1650     uint256 private maxTotalTokens;
1651     
1652     //initial part of the URI for the metadata
1653     string private _currentBaseURI;
1654     
1655     //the amount of reserved mints that have currently been executed by creator and giveaways
1656     uint private _reservedMints;
1657     
1658     //the maximum amount of reserved mints allowed for creator and giveaways
1659     uint private maxReservedMints = 1000;
1660 
1661     //amount of mints that each address has executed
1662     mapping(address => uint256) public mintsPerAddress;
1663     
1664     //current state os sale
1665     enum State {NoSale, OpenSale}
1666 
1667     State private saleState_;
1668     
1669     //declaring initial values for variables
1670     constructor() ERC721A('Binkies', 'B') {
1671         maxTotalTokens = 10000;
1672 
1673         _currentBaseURI = "ipfs://QmTTJy1dwZL1ifG8JBa1tTnirk6KYtsUFEez1GjQ2w3Uks/";
1674     }
1675     
1676     //in case somebody accidentaly sends funds or transaction to contract
1677     receive() payable external {}
1678     fallback() payable external {
1679         revert();
1680     }
1681     
1682     //visualize baseURI
1683     function _baseURI() internal view virtual override returns (string memory) {
1684         return _currentBaseURI;
1685     }
1686     
1687     //change baseURI in case needed for IPFS
1688     function changeBaseURI(string memory baseURI_) public onlyOwner {
1689         _currentBaseURI = baseURI_;
1690     }
1691 
1692     function setSaleState(uint newSaleState) public onlyOwner {
1693         require(newSaleState < 2, "Invalid Sale State!");
1694         if (newSaleState == 0) {
1695             saleState_ = State.NoSale;
1696         }
1697         else {
1698             saleState_ = State.OpenSale;
1699         }
1700     }
1701 
1702     //mint a @param number of NFTs in public sale
1703     function mint() public nonReentrant {
1704         require(msg.sender == tx.origin, "Sender is not the same as origin!");
1705         require(saleState_ == State.OpenSale, "Public Sale in not open yet!");
1706         require(totalSupply() < maxTotalTokens - (maxReservedMints - _reservedMints), "Not enough NFTs left to mint..");
1707         require(mintsPerAddress[msg.sender] == 0, "Wallet has already have minted an NFT!");
1708 
1709         _safeMint(msg.sender, 1);
1710         mintsPerAddress[msg.sender] += 1;
1711     }
1712     
1713     function tokenURI(uint256 tokenId_) public view virtual override returns (string memory) {
1714         require(_exists(tokenId_), "ERC721Metadata: URI query for nonexistent token");
1715 
1716         tokenId_ += 1;
1717         string memory baseURI = _baseURI();
1718         return string(abi.encodePacked(baseURI, tokenId_.toString(), ".json")); 
1719     }
1720     
1721     //reserved NFTs for creator
1722     function reservedMint(uint number, address recipient) public onlyOwner {
1723         require(_reservedMints + number <= maxReservedMints, "Not enough Reserved NFTs left to mint..");
1724 
1725         _safeMint(recipient, number);
1726         mintsPerAddress[recipient] += number;
1727         _reservedMints += number; 
1728         
1729     }
1730     
1731     //burn the tokens that have not been sold yet
1732     function burnTokens() public onlyOwner {
1733         maxTotalTokens = totalSupply();
1734     }
1735     
1736     //se the current account balance
1737     function accountBalance() public onlyOwner view returns(uint) {
1738         return address(this).balance;
1739     }
1740     
1741     //retrieve all funds recieved from minting
1742     function withdraw() public onlyOwner {
1743         uint256 balance = accountBalance();
1744         require(balance > 0, 'No Funds to withdraw, Balance is 0');
1745 
1746         _withdraw(payable(msg.sender), balance); 
1747     }
1748     
1749     //send the percentage of funds to a shareholder´s wallet
1750     function _withdraw(address payable account, uint256 amount) internal {
1751         (bool sent, ) = account.call{value: amount}("");
1752         require(sent, "Failed to send Ether");
1753     }
1754     
1755     //to see the total amount of reserved mints left 
1756     function reservedMintsLeft() public onlyOwner view returns(uint) {
1757         return maxReservedMints - _reservedMints;
1758     }
1759     
1760     //see current state of sale
1761     //see the current state of the sale
1762     function saleState() public view returns(State){
1763         return saleState_;
1764     }
1765     
1766    
1767 }