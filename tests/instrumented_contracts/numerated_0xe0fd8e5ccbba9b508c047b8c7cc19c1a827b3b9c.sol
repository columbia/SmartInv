1 // SPDX-License-Identifier: GPL-3.0
2 
3 
4 /*
5 
6                 _
7             ,.-" "-.,
8            /   ===   \
9           /  =======  \
10        __|  (o)   (0)  |__      
11       / _|    .---.    |_ \         
12      | /.----/ O O \----.\ |       
13       \/     |     |     \/        
14       |                   |            
15       |                   |           
16       |                   |          
17       _\   -.,_____,.-   /_         
18   ,.-"  "-.,_________,.-"  "-.,
19  /          |       |          \                        THE APING DEAD
20 |           l.     .l           |                       www.theapingdead.com
21 |            |     |            |
22 l.           |     |           .l             
23  |           l.   .l           | \,     
24  l.           |   |           .l   \,    
25   |           |   |           |      \,  
26   l.          |   |          .l        |
27    |          |   |          |         |
28    |          |---|          |         |
29    |          |   |          |         |
30    /"-.,__,.-"\   /"-.,__,.-"\"-.,_,.-"\
31   |            \ /            |         |
32   |             |             |         |
33    \__|__|__|__/ \__|__|__|__/ \_|__|__/
34 
35 */
36 
37 // File: @openzeppelin/contracts/utils/Strings.sol
38 
39 pragma solidity ^0.8.0;
40 
41 /**
42  * @dev String operations.
43  */
44 library Strings {
45     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
46 
47     /**
48      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
49      */
50     function toString(uint256 value) internal pure returns (string memory) {
51         // Inspired by OraclizeAPI's implementation - MIT licence
52         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
53 
54         if (value == 0) {
55             return "0";
56         }
57         uint256 temp = value;
58         uint256 digits;
59         while (temp != 0) {
60             digits++;
61             temp /= 10;
62         }
63         bytes memory buffer = new bytes(digits);
64         while (value != 0) {
65             digits -= 1;
66             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
67             value /= 10;
68         }
69         return string(buffer);
70     }
71 
72     /**
73      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
74      */
75     function toHexString(uint256 value) internal pure returns (string memory) {
76         if (value == 0) {
77             return "0x00";
78         }
79         uint256 temp = value;
80         uint256 length = 0;
81         while (temp != 0) {
82             length++;
83             temp >>= 8;
84         }
85         return toHexString(value, length);
86     }
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
90      */
91     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
92         bytes memory buffer = new bytes(2 * length + 2);
93         buffer[0] = "0";
94         buffer[1] = "x";
95         for (uint256 i = 2 * length + 1; i > 1; --i) {
96             buffer[i] = _HEX_SYMBOLS[value & 0xf];
97             value >>= 4;
98         }
99         require(value == 0, "Strings: hex length insufficient");
100         return string(buffer);
101     }
102 }
103 
104 // File: @openzeppelin/contracts/utils/Context.sol
105 
106 
107 
108 pragma solidity ^0.8.0;
109 
110 /**
111  * @dev Provides information about the current execution context, including the
112  * sender of the transaction and its data. While these are generally available
113  * via msg.sender and msg.data, they should not be accessed in such a direct
114  * manner, since when dealing with meta-transactions the account sending and
115  * paying for execution may not be the actual sender (as far as an application
116  * is concerned).
117  *
118  * This contract is only required for intermediate, library-like contracts.
119  */
120 abstract contract Context {
121     function _msgSender() internal view virtual returns (address) {
122         return msg.sender;
123     }
124 
125     function _msgData() internal view virtual returns (bytes calldata) {
126         return msg.data;
127     }
128 }
129 
130 // File: @openzeppelin/contracts/access/Ownable.sol
131 
132 
133 
134 pragma solidity ^0.8.0;
135 
136 
137 /**
138  * @dev Contract module which provides a basic access control mechanism, where
139  * there is an account (an owner) that can be granted exclusive access to
140  * specific functions.
141  *
142  * By default, the owner account will be the one that deploys the contract. This
143  * can later be changed with {transferOwnership}.
144  *
145  * This module is used through inheritance. It will make available the modifier
146  * `onlyOwner`, which can be applied to your functions to restrict their use to
147  * the owner.
148  */
149 abstract contract Ownable is Context {
150     address private _owner;
151 
152     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
153 
154     /**
155      * @dev Initializes the contract setting the deployer as the initial owner.
156      */
157     constructor() {
158         _setOwner(_msgSender());
159     }
160 
161     /**
162      * @dev Returns the address of the current owner.
163      */
164     function owner() public view virtual returns (address) {
165         return _owner;
166     }
167 
168     /**
169      * @dev Throws if called by any account other than the owner.
170      */
171     modifier onlyOwner() {
172         require(owner() == _msgSender(), "Ownable: caller is not the owner");
173         _;
174     }
175 
176     /**
177      * @dev Leaves the contract without owner. It will not be possible to call
178      * `onlyOwner` functions anymore. Can only be called by the current owner.
179      *
180      * NOTE: Renouncing ownership will leave the contract without an owner,
181      * thereby removing any functionality that is only available to the owner.
182      */
183     function renounceOwnership() public virtual onlyOwner {
184         _setOwner(address(0));
185     }
186 
187     /**
188      * @dev Transfers ownership of the contract to a new account (`newOwner`).
189      * Can only be called by the current owner.
190      */
191     function transferOwnership(address newOwner) public virtual onlyOwner {
192         require(newOwner != address(0), "Ownable: new owner is the zero address");
193         _setOwner(newOwner);
194     }
195 
196     function _setOwner(address newOwner) private {
197         address oldOwner = _owner;
198         _owner = newOwner;
199         emit OwnershipTransferred(oldOwner, newOwner);
200     }
201 }
202 
203 // File: @openzeppelin/contracts/utils/Address.sol
204 
205 
206 
207 pragma solidity ^0.8.0;
208 
209 /**
210  * @dev Collection of functions related to the address type
211  */
212 library Address {
213     /**
214      * @dev Returns true if `account` is a contract.
215      *
216      * [IMPORTANT]
217      * ====
218      * It is unsafe to assume that an address for which this function returns
219      * false is an externally-owned account (EOA) and not a contract.
220      *
221      * Among others, `isContract` will return false for the following
222      * types of addresses:
223      *
224      *  - an externally-owned account
225      *  - a contract in construction
226      *  - an address where a contract will be created
227      *  - an address where a contract lived, but was destroyed
228      * ====
229      */
230     function isContract(address account) internal view returns (bool) {
231         // This method relies on extcodesize, which returns 0 for contracts in
232         // construction, since the code is only stored at the end of the
233         // constructor execution.
234 
235         uint256 size;
236         assembly {
237             size := extcodesize(account)
238         }
239         return size > 0;
240     }
241 
242     /**
243      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
244      * `recipient`, forwarding all available gas and reverting on errors.
245      *
246      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
247      * of certain opcodes, possibly making contracts go over the 2300 gas limit
248      * imposed by `transfer`, making them unable to receive funds via
249      * `transfer`. {sendValue} removes this limitation.
250      *
251      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
252      *
253      * IMPORTANT: because control is transferred to `recipient`, care must be
254      * taken to not create reentrancy vulnerabilities. Consider using
255      * {ReentrancyGuard} or the
256      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
257      */
258     function sendValue(address payable recipient, uint256 amount) internal {
259         require(address(this).balance >= amount, "Address: insufficient balance");
260 
261         (bool success, ) = recipient.call{value: amount}("");
262         require(success, "Address: unable to send value, recipient may have reverted");
263     }
264 
265     /**
266      * @dev Performs a Solidity function call using a low level `call`. A
267      * plain `call` is an unsafe replacement for a function call: use this
268      * function instead.
269      *
270      * If `target` reverts with a revert reason, it is bubbled up by this
271      * function (like regular Solidity function calls).
272      *
273      * Returns the raw returned data. To convert to the expected return value,
274      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
275      *
276      * Requirements:
277      *
278      * - `target` must be a contract.
279      * - calling `target` with `data` must not revert.
280      *
281      * _Available since v3.1._
282      */
283     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
284         return functionCall(target, data, "Address: low-level call failed");
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
289      * `errorMessage` as a fallback revert reason when `target` reverts.
290      *
291      * _Available since v3.1._
292      */
293     function functionCall(
294         address target,
295         bytes memory data,
296         string memory errorMessage
297     ) internal returns (bytes memory) {
298         return functionCallWithValue(target, data, 0, errorMessage);
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
303      * but also transferring `value` wei to `target`.
304      *
305      * Requirements:
306      *
307      * - the calling contract must have an ETH balance of at least `value`.
308      * - the called Solidity function must be `payable`.
309      *
310      * _Available since v3.1._
311      */
312     function functionCallWithValue(
313         address target,
314         bytes memory data,
315         uint256 value
316     ) internal returns (bytes memory) {
317         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
322      * with `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(
327         address target,
328         bytes memory data,
329         uint256 value,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         require(address(this).balance >= value, "Address: insufficient balance for call");
333         require(isContract(target), "Address: call to non-contract");
334 
335         (bool success, bytes memory returndata) = target.call{value: value}(data);
336         return verifyCallResult(success, returndata, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but performing a static call.
342      *
343      * _Available since v3.3._
344      */
345     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
346         return functionStaticCall(target, data, "Address: low-level static call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
351      * but performing a static call.
352      *
353      * _Available since v3.3._
354      */
355     function functionStaticCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal view returns (bytes memory) {
360         require(isContract(target), "Address: static call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.staticcall(data);
363         return verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but performing a delegate call.
369      *
370      * _Available since v3.4._
371      */
372     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
373         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
378      * but performing a delegate call.
379      *
380      * _Available since v3.4._
381      */
382     function functionDelegateCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal returns (bytes memory) {
387         require(isContract(target), "Address: delegate call to non-contract");
388 
389         (bool success, bytes memory returndata) = target.delegatecall(data);
390         return verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
395      * revert reason using the provided one.
396      *
397      * _Available since v4.3._
398      */
399     function verifyCallResult(
400         bool success,
401         bytes memory returndata,
402         string memory errorMessage
403     ) internal pure returns (bytes memory) {
404         if (success) {
405             return returndata;
406         } else {
407             // Look for revert reason and bubble it up if present
408             if (returndata.length > 0) {
409                 // The easiest way to bubble the revert reason is using memory via assembly
410 
411                 assembly {
412                     let returndata_size := mload(returndata)
413                     revert(add(32, returndata), returndata_size)
414                 }
415             } else {
416                 revert(errorMessage);
417             }
418         }
419     }
420 }
421 
422 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
423 
424 
425 
426 pragma solidity ^0.8.0;
427 
428 /**
429  * @title ERC721 token receiver interface
430  * @dev Interface for any contract that wants to support safeTransfers
431  * from ERC721 asset contracts.
432  */
433 interface IERC721Receiver {
434     /**
435      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
436      * by `operator` from `from`, this function is called.
437      *
438      * It must return its Solidity selector to confirm the token transfer.
439      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
440      *
441      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
442      */
443     function onERC721Received(
444         address operator,
445         address from,
446         uint256 tokenId,
447         bytes calldata data
448     ) external returns (bytes4);
449 }
450 
451 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
452 
453 
454 
455 pragma solidity ^0.8.0;
456 
457 /**
458  * @dev Interface of the ERC165 standard, as defined in the
459  * https://eips.ethereum.org/EIPS/eip-165[EIP].
460  *
461  * Implementers can declare support of contract interfaces, which can then be
462  * queried by others ({ERC165Checker}).
463  *
464  * For an implementation, see {ERC165}.
465  */
466 interface IERC165 {
467     /**
468      * @dev Returns true if this contract implements the interface defined by
469      * `interfaceId`. See the corresponding
470      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
471      * to learn more about how these ids are created.
472      *
473      * This function call must use less than 30 000 gas.
474      */
475     function supportsInterface(bytes4 interfaceId) external view returns (bool);
476 }
477 
478 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
479 
480 
481 
482 pragma solidity ^0.8.0;
483 
484 
485 /**
486  * @dev Implementation of the {IERC165} interface.
487  *
488  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
489  * for the additional interface id that will be supported. For example:
490  *
491  * ```solidity
492  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
493  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
494  * }
495  * ```
496  *
497  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
498  */
499 abstract contract ERC165 is IERC165 {
500     /**
501      * @dev See {IERC165-supportsInterface}.
502      */
503     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
504         return interfaceId == type(IERC165).interfaceId;
505     }
506 }
507 
508 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
509 
510 
511 
512 pragma solidity ^0.8.0;
513 
514 
515 /**
516  * @dev Required interface of an ERC721 compliant contract.
517  */
518 interface IERC721 is IERC165 {
519     /**
520      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
521      */
522     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
523 
524     /**
525      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
526      */
527     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
528 
529     /**
530      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
531      */
532     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
533 
534     /**
535      * @dev Returns the number of tokens in ``owner``'s account.
536      */
537     function balanceOf(address owner) external view returns (uint256 balance);
538 
539     /**
540      * @dev Returns the owner of the `tokenId` token.
541      *
542      * Requirements:
543      *
544      * - `tokenId` must exist.
545      */
546     function ownerOf(uint256 tokenId) external view returns (address owner);
547 
548     /**
549      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
550      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
551      *
552      * Requirements:
553      *
554      * - `from` cannot be the zero address.
555      * - `to` cannot be the zero address.
556      * - `tokenId` token must exist and be owned by `from`.
557      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
558      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
559      *
560      * Emits a {Transfer} event.
561      */
562     function safeTransferFrom(
563         address from,
564         address to,
565         uint256 tokenId
566     ) external;
567 
568     /**
569      * @dev Transfers `tokenId` token from `from` to `to`.
570      *
571      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
572      *
573      * Requirements:
574      *
575      * - `from` cannot be the zero address.
576      * - `to` cannot be the zero address.
577      * - `tokenId` token must be owned by `from`.
578      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
579      *
580      * Emits a {Transfer} event.
581      */
582     function transferFrom(
583         address from,
584         address to,
585         uint256 tokenId
586     ) external;
587 
588     /**
589      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
590      * The approval is cleared when the token is transferred.
591      *
592      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
593      *
594      * Requirements:
595      *
596      * - The caller must own the token or be an approved operator.
597      * - `tokenId` must exist.
598      *
599      * Emits an {Approval} event.
600      */
601     function approve(address to, uint256 tokenId) external;
602 
603     /**
604      * @dev Returns the account approved for `tokenId` token.
605      *
606      * Requirements:
607      *
608      * - `tokenId` must exist.
609      */
610     function getApproved(uint256 tokenId) external view returns (address operator);
611 
612     /**
613      * @dev Approve or remove `operator` as an operator for the caller.
614      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
615      *
616      * Requirements:
617      *
618      * - The `operator` cannot be the caller.
619      *
620      * Emits an {ApprovalForAll} event.
621      */
622     function setApprovalForAll(address operator, bool _approved) external;
623 
624     /**
625      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
626      *
627      * See {setApprovalForAll}
628      */
629     function isApprovedForAll(address owner, address operator) external view returns (bool);
630 
631     /**
632      * @dev Safely transfers `tokenId` token from `from` to `to`.
633      *
634      * Requirements:
635      *
636      * - `from` cannot be the zero address.
637      * - `to` cannot be the zero address.
638      * - `tokenId` token must exist and be owned by `from`.
639      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
640      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
641      *
642      * Emits a {Transfer} event.
643      */
644     function safeTransferFrom(
645         address from,
646         address to,
647         uint256 tokenId,
648         bytes calldata data
649     ) external;
650 }
651 
652 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
653 
654 
655 
656 pragma solidity ^0.8.0;
657 
658 
659 /**
660  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
661  * @dev See https://eips.ethereum.org/EIPS/eip-721
662  */
663 interface IERC721Enumerable is IERC721 {
664     /**
665      * @dev Returns the total amount of tokens stored by the contract.
666      */
667     function totalSupply() external view returns (uint256);
668 
669     /**
670      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
671      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
672      */
673     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
674 
675     /**
676      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
677      * Use along with {totalSupply} to enumerate all tokens.
678      */
679     function tokenByIndex(uint256 index) external view returns (uint256);
680 }
681 
682 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
683 
684 
685 
686 pragma solidity ^0.8.0;
687 
688 
689 /**
690  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
691  * @dev See https://eips.ethereum.org/EIPS/eip-721
692  */
693 interface IERC721Metadata is IERC721 {
694     /**
695      * @dev Returns the token collection name.
696      */
697     function name() external view returns (string memory);
698 
699     /**
700      * @dev Returns the token collection symbol.
701      */
702     function symbol() external view returns (string memory);
703 
704     /**
705      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
706      */
707     function tokenURI(uint256 tokenId) external view returns (string memory);
708 }
709 
710 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
711 
712 
713 
714 pragma solidity ^0.8.0;
715 
716 
717 
718 
719 
720 
721 
722 
723 /**
724  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
725  * the Metadata extension, but not including the Enumerable extension, which is available separately as
726  * {ERC721Enumerable}.
727  */
728 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
729     using Address for address;
730     using Strings for uint256;
731 
732     // Token name
733     string private _name;
734 
735     // Token symbol
736     string private _symbol;
737 
738     // Mapping from token ID to owner address
739     mapping(uint256 => address) private _owners;
740 
741     // Mapping owner address to token count
742     mapping(address => uint256) private _balances;
743 
744     // Mapping from token ID to approved address
745     mapping(uint256 => address) private _tokenApprovals;
746 
747     // Mapping from owner to operator approvals
748     mapping(address => mapping(address => bool)) private _operatorApprovals;
749 
750     /**
751      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
752      */
753     constructor(string memory name_, string memory symbol_) {
754         _name = name_;
755         _symbol = symbol_;
756     }
757 
758     /**
759      * @dev See {IERC165-supportsInterface}.
760      */
761     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
762         return
763             interfaceId == type(IERC721).interfaceId ||
764             interfaceId == type(IERC721Metadata).interfaceId ||
765             super.supportsInterface(interfaceId);
766     }
767 
768     /**
769      * @dev See {IERC721-balanceOf}.
770      */
771     function balanceOf(address owner) public view virtual override returns (uint256) {
772         require(owner != address(0), "ERC721: balance query for the zero address");
773         return _balances[owner];
774     }
775 
776     /**
777      * @dev See {IERC721-ownerOf}.
778      */
779     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
780         address owner = _owners[tokenId];
781         require(owner != address(0), "ERC721: owner query for nonexistent token");
782         return owner;
783     }
784 
785     /**
786      * @dev See {IERC721Metadata-name}.
787      */
788     function name() public view virtual override returns (string memory) {
789         return _name;
790     }
791 
792     /**
793      * @dev See {IERC721Metadata-symbol}.
794      */
795     function symbol() public view virtual override returns (string memory) {
796         return _symbol;
797     }
798 
799     /**
800      * @dev See {IERC721Metadata-tokenURI}.
801      */
802     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
803         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
804 
805         string memory baseURI = _baseURI();
806         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
807     }
808 
809     /**
810      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
811      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
812      * by default, can be overriden in child contracts.
813      */
814     function _baseURI() internal view virtual returns (string memory) {
815         return "";
816     }
817 
818     /**
819      * @dev See {IERC721-approve}.
820      */
821     function approve(address to, uint256 tokenId) public virtual override {
822         address owner = ERC721.ownerOf(tokenId);
823         require(to != owner, "ERC721: approval to current owner");
824 
825         require(
826             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
827             "ERC721: approve caller is not owner nor approved for all"
828         );
829 
830         _approve(to, tokenId);
831     }
832 
833     /**
834      * @dev See {IERC721-getApproved}.
835      */
836     function getApproved(uint256 tokenId) public view virtual override returns (address) {
837         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
838 
839         return _tokenApprovals[tokenId];
840     }
841 
842     /**
843      * @dev See {IERC721-setApprovalForAll}.
844      */
845     function setApprovalForAll(address operator, bool approved) public virtual override {
846         require(operator != _msgSender(), "ERC721: approve to caller");
847 
848         _operatorApprovals[_msgSender()][operator] = approved;
849         emit ApprovalForAll(_msgSender(), operator, approved);
850     }
851 
852     /**
853      * @dev See {IERC721-isApprovedForAll}.
854      */
855     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
856         return _operatorApprovals[owner][operator];
857     }
858 
859     /**
860      * @dev See {IERC721-transferFrom}.
861      */
862     function transferFrom(
863         address from,
864         address to,
865         uint256 tokenId
866     ) public virtual override {
867         //solhint-disable-next-line max-line-length
868         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
869 
870         _transfer(from, to, tokenId);
871     }
872 
873     /**
874      * @dev See {IERC721-safeTransferFrom}.
875      */
876     function safeTransferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) public virtual override {
881         safeTransferFrom(from, to, tokenId, "");
882     }
883 
884     /**
885      * @dev See {IERC721-safeTransferFrom}.
886      */
887     function safeTransferFrom(
888         address from,
889         address to,
890         uint256 tokenId,
891         bytes memory _data
892     ) public virtual override {
893         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
894         _safeTransfer(from, to, tokenId, _data);
895     }
896 
897     /**
898      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
899      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
900      *
901      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
902      *
903      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
904      * implement alternative mechanisms to perform token transfer, such as signature-based.
905      *
906      * Requirements:
907      *
908      * - `from` cannot be the zero address.
909      * - `to` cannot be the zero address.
910      * - `tokenId` token must exist and be owned by `from`.
911      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
912      *
913      * Emits a {Transfer} event.
914      */
915     function _safeTransfer(
916         address from,
917         address to,
918         uint256 tokenId,
919         bytes memory _data
920     ) internal virtual {
921         _transfer(from, to, tokenId);
922         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
923     }
924 
925     /**
926      * @dev Returns whether `tokenId` exists.
927      *
928      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
929      *
930      * Tokens start existing when they are minted (`_mint`),
931      * and stop existing when they are burned (`_burn`).
932      */
933     function _exists(uint256 tokenId) internal view virtual returns (bool) {
934         return _owners[tokenId] != address(0);
935     }
936 
937     /**
938      * @dev Returns whether `spender` is allowed to manage `tokenId`.
939      *
940      * Requirements:
941      *
942      * - `tokenId` must exist.
943      */
944     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
945         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
946         address owner = ERC721.ownerOf(tokenId);
947         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
948     }
949 
950     /**
951      * @dev Safely mints `tokenId` and transfers it to `to`.
952      *
953      * Requirements:
954      *
955      * - `tokenId` must not exist.
956      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _safeMint(address to, uint256 tokenId) internal virtual {
961         _safeMint(to, tokenId, "");
962     }
963 
964     /**
965      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
966      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
967      */
968     function _safeMint(
969         address to,
970         uint256 tokenId,
971         bytes memory _data
972     ) internal virtual {
973         _mint(to, tokenId);
974         require(
975             _checkOnERC721Received(address(0), to, tokenId, _data),
976             "ERC721: transfer to non ERC721Receiver implementer"
977         );
978     }
979 
980     /**
981      * @dev Mints `tokenId` and transfers it to `to`.
982      *
983      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
984      *
985      * Requirements:
986      *
987      * - `tokenId` must not exist.
988      * - `to` cannot be the zero address.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _mint(address to, uint256 tokenId) internal virtual {
993         require(to != address(0), "ERC721: mint to the zero address");
994         require(!_exists(tokenId), "ERC721: token already minted");
995 
996         _beforeTokenTransfer(address(0), to, tokenId);
997 
998         _balances[to] += 1;
999         _owners[tokenId] = to;
1000 
1001         emit Transfer(address(0), to, tokenId);
1002     }
1003 
1004     /**
1005      * @dev Destroys `tokenId`.
1006      * The approval is cleared when the token is burned.
1007      *
1008      * Requirements:
1009      *
1010      * - `tokenId` must exist.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _burn(uint256 tokenId) internal virtual {
1015         address owner = ERC721.ownerOf(tokenId);
1016 
1017         _beforeTokenTransfer(owner, address(0), tokenId);
1018 
1019         // Clear approvals
1020         _approve(address(0), tokenId);
1021 
1022         _balances[owner] -= 1;
1023         delete _owners[tokenId];
1024 
1025         emit Transfer(owner, address(0), tokenId);
1026     }
1027 
1028     /**
1029      * @dev Transfers `tokenId` from `from` to `to`.
1030      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1031      *
1032      * Requirements:
1033      *
1034      * - `to` cannot be the zero address.
1035      * - `tokenId` token must be owned by `from`.
1036      *
1037      * Emits a {Transfer} event.
1038      */
1039     function _transfer(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) internal virtual {
1044         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1045         require(to != address(0), "ERC721: transfer to the zero address");
1046 
1047         _beforeTokenTransfer(from, to, tokenId);
1048 
1049         // Clear approvals from the previous owner
1050         _approve(address(0), tokenId);
1051 
1052         _balances[from] -= 1;
1053         _balances[to] += 1;
1054         _owners[tokenId] = to;
1055 
1056         emit Transfer(from, to, tokenId);
1057     }
1058 
1059     /**
1060      * @dev Approve `to` to operate on `tokenId`
1061      *
1062      * Emits a {Approval} event.
1063      */
1064     function _approve(address to, uint256 tokenId) internal virtual {
1065         _tokenApprovals[tokenId] = to;
1066         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1067     }
1068 
1069     /**
1070      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1071      * The call is not executed if the target address is not a contract.
1072      *
1073      * @param from address representing the previous owner of the given token ID
1074      * @param to target address that will receive the tokens
1075      * @param tokenId uint256 ID of the token to be transferred
1076      * @param _data bytes optional data to send along with the call
1077      * @return bool whether the call correctly returned the expected magic value
1078      */
1079     function _checkOnERC721Received(
1080         address from,
1081         address to,
1082         uint256 tokenId,
1083         bytes memory _data
1084     ) private returns (bool) {
1085         if (to.isContract()) {
1086             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1087                 return retval == IERC721Receiver.onERC721Received.selector;
1088             } catch (bytes memory reason) {
1089                 if (reason.length == 0) {
1090                     revert("ERC721: transfer to non ERC721Receiver implementer");
1091                 } else {
1092                     assembly {
1093                         revert(add(32, reason), mload(reason))
1094                     }
1095                 }
1096             }
1097         } else {
1098             return true;
1099         }
1100     }
1101 
1102     /**
1103      * @dev Hook that is called before any token transfer. This includes minting
1104      * and burning.
1105      *
1106      * Calling conditions:
1107      *
1108      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1109      * transferred to `to`.
1110      * - When `from` is zero, `tokenId` will be minted for `to`.
1111      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1112      * - `from` and `to` are never both zero.
1113      *
1114      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1115      */
1116     function _beforeTokenTransfer(
1117         address from,
1118         address to,
1119         uint256 tokenId
1120     ) internal virtual {}
1121 }
1122 
1123 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1124 
1125 
1126 
1127 pragma solidity ^0.8.0;
1128 
1129 
1130 
1131 /**
1132  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1133  * enumerability of all the token ids in the contract as well as all token ids owned by each
1134  * account.
1135  */
1136 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1137     // Mapping from owner to list of owned token IDs
1138     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1139 
1140     // Mapping from token ID to index of the owner tokens list
1141     mapping(uint256 => uint256) private _ownedTokensIndex;
1142 
1143     // Array with all token ids, used for enumeration
1144     uint256[] private _allTokens;
1145 
1146     // Mapping from token id to position in the allTokens array
1147     mapping(uint256 => uint256) private _allTokensIndex;
1148 
1149     /**
1150      * @dev See {IERC165-supportsInterface}.
1151      */
1152     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1153         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1154     }
1155 
1156     /**
1157      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1158      */
1159     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1160         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1161         return _ownedTokens[owner][index];
1162     }
1163 
1164     /**
1165      * @dev See {IERC721Enumerable-totalSupply}.
1166      */
1167     function totalSupply() public view virtual override returns (uint256) {
1168         return _allTokens.length;
1169     }
1170 
1171     /**
1172      * @dev See {IERC721Enumerable-tokenByIndex}.
1173      */
1174     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1175         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1176         return _allTokens[index];
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
1198     ) internal virtual override {
1199         super._beforeTokenTransfer(from, to, tokenId);
1200 
1201         if (from == address(0)) {
1202             _addTokenToAllTokensEnumeration(tokenId);
1203         } else if (from != to) {
1204             _removeTokenFromOwnerEnumeration(from, tokenId);
1205         }
1206         if (to == address(0)) {
1207             _removeTokenFromAllTokensEnumeration(tokenId);
1208         } else if (to != from) {
1209             _addTokenToOwnerEnumeration(to, tokenId);
1210         }
1211     }
1212 
1213     /**
1214      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1215      * @param to address representing the new owner of the given token ID
1216      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1217      */
1218     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1219         uint256 length = ERC721.balanceOf(to);
1220         _ownedTokens[to][length] = tokenId;
1221         _ownedTokensIndex[tokenId] = length;
1222     }
1223 
1224     /**
1225      * @dev Private function to add a token to this extension's token tracking data structures.
1226      * @param tokenId uint256 ID of the token to be added to the tokens list
1227      */
1228     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1229         _allTokensIndex[tokenId] = _allTokens.length;
1230         _allTokens.push(tokenId);
1231     }
1232 
1233     /**
1234      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1235      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1236      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1237      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1238      * @param from address representing the previous owner of the given token ID
1239      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1240      */
1241     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1242         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1243         // then delete the last slot (swap and pop).
1244 
1245         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1246         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1247 
1248         // When the token to delete is the last token, the swap operation is unnecessary
1249         if (tokenIndex != lastTokenIndex) {
1250             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1251 
1252             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1253             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1254         }
1255 
1256         // This also deletes the contents at the last position of the array
1257         delete _ownedTokensIndex[tokenId];
1258         delete _ownedTokens[from][lastTokenIndex];
1259     }
1260 
1261     /**
1262      * @dev Private function to remove a token from this extension's token tracking data structures.
1263      * This has O(1) time complexity, but alters the order of the _allTokens array.
1264      * @param tokenId uint256 ID of the token to be removed from the tokens list
1265      */
1266     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1267         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1268         // then delete the last slot (swap and pop).
1269 
1270         uint256 lastTokenIndex = _allTokens.length - 1;
1271         uint256 tokenIndex = _allTokensIndex[tokenId];
1272 
1273         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1274         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1275         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1276         uint256 lastTokenId = _allTokens[lastTokenIndex];
1277 
1278         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1279         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1280 
1281         // This also deletes the contents at the last position of the array
1282         delete _allTokensIndex[tokenId];
1283         _allTokens.pop();
1284     }
1285 }
1286 
1287 // File: contracts/TheApingDead.sol
1288 
1289 
1290 pragma solidity >=0.7.0 <0.9.0;
1291 
1292 
1293 
1294 contract TheApingDead is ERC721Enumerable, Ownable {
1295   using Strings for uint256;
1296 
1297   string public baseURI;
1298   string public baseExtension = ".json";
1299   string public notRevealedUri;
1300   uint256 public cost = 0.024 ether;
1301   uint256 public maxSupply = 2424;
1302   uint256 public maxMintAmount = 20;
1303   uint256 public nftPerAddressLimit = 40;
1304   bool public paused = false;
1305   bool public revealed = false;
1306   bool public onlyWhitelisted = false;
1307   address[] public whitelistedAddresses;
1308   mapping(address => uint256) public addressMintedBalance;
1309 
1310 
1311   constructor(
1312     string memory _name,
1313     string memory _symbol,
1314     string memory _initBaseURI,
1315     string memory _initNotRevealedUri
1316   ) ERC721(_name, _symbol) {
1317     setBaseURI(_initBaseURI);
1318     setNotRevealedURI(_initNotRevealedUri);
1319   }
1320 
1321   // internal
1322   function _baseURI() internal view virtual override returns (string memory) {
1323     return baseURI;
1324   }
1325 
1326   // public
1327   function mint(uint256 _mintAmount) public payable {
1328     require(!paused, "the contract is paused");
1329     uint256 supply = totalSupply();
1330     require(_mintAmount > 0, "need to mint at least 1 NFT");
1331     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1332     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1333 
1334     if (msg.sender != owner()) {
1335         if(onlyWhitelisted == true) {
1336             require(isWhitelisted(msg.sender), "user is not whitelisted");
1337             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1338             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1339         }
1340         require(msg.value >= cost * _mintAmount, "insufficient funds");
1341     }
1342     
1343     for (uint256 i = 1; i <= _mintAmount; i++) {
1344         addressMintedBalance[msg.sender]++;
1345       _safeMint(msg.sender, supply + i);
1346     }
1347   }
1348   
1349   function isWhitelisted(address _user) public view returns (bool) {
1350     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1351       if (whitelistedAddresses[i] == _user) {
1352           return true;
1353       }
1354     }
1355     return false;
1356   }
1357 
1358   function walletOfOwner(address _owner)
1359     public
1360     view
1361     returns (uint256[] memory)
1362   {
1363     uint256 ownerTokenCount = balanceOf(_owner);
1364     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1365     for (uint256 i; i < ownerTokenCount; i++) {
1366       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1367     }
1368     return tokenIds;
1369   }
1370 
1371   function tokenURI(uint256 tokenId)
1372     public
1373     view
1374     virtual
1375     override
1376     returns (string memory)
1377   {
1378     require(
1379       _exists(tokenId),
1380       "ERC721Metadata: URI query for nonexistent token"
1381     );
1382     
1383     if(revealed == false) {
1384         return notRevealedUri;
1385     }
1386 
1387     string memory currentBaseURI = _baseURI();
1388     return bytes(currentBaseURI).length > 0
1389         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1390         : "";
1391   }
1392 
1393   //only owner
1394   function reveal() public onlyOwner {
1395       revealed = true;
1396   }
1397   
1398   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1399     nftPerAddressLimit = _limit;
1400   }
1401   
1402   function setCost(uint256 _newCost) public onlyOwner {
1403     cost = _newCost;
1404   }
1405 
1406   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1407     maxMintAmount = _newmaxMintAmount;
1408   }
1409 
1410   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1411     baseURI = _newBaseURI;
1412   }
1413 
1414   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1415     baseExtension = _newBaseExtension;
1416   }
1417   
1418   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1419     notRevealedUri = _notRevealedURI;
1420   }
1421 
1422   function pause(bool _state) public onlyOwner {
1423     paused = _state;
1424   }
1425   
1426   function setOnlyWhitelisted(bool _state) public onlyOwner {
1427     onlyWhitelisted = _state;
1428   }
1429   
1430   function whitelistUsers(address[] calldata _users) public onlyOwner {
1431     delete whitelistedAddresses;
1432     whitelistedAddresses = _users;
1433   }
1434  
1435   function withdraw() public payable onlyOwner {
1436 
1437     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1438     require(os);
1439 
1440   }
1441 }