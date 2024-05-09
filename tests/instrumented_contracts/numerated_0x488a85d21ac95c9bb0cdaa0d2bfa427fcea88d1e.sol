1 // SPDX-License-Identifier: GPL-3.0
2 
3 /**
4 Created by 0xfoobar in collab with Bored Punk Yacht Club
5 
6  ________  ________  ________  _______   ________          ________  ___  ___  ________   ___  __             ___    ___ ________  ________  ___  ___  _________        ________  ___       ___  ___  ________
7 |\   __  \|\   __  \|\   __  \|\  ___ \ |\   ___ \        |\   __  \|\  \|\  \|\   ___  \|\  \|\  \          |\  \  /  /|\   __  \|\   ____\|\  \|\  \|\___   ___\     |\   ____\|\  \     |\  \|\  \|\   __  \
8 \ \  \|\ /\ \  \|\  \ \  \|\  \ \   __/|\ \  \_|\ \       \ \  \|\  \ \  \\\  \ \  \\ \  \ \  \/  /|_        \ \  \/  / | \  \|\  \ \  \___|\ \  \\\  \|___ \  \_|     \ \  \___|\ \  \    \ \  \\\  \ \  \|\ /_
9  \ \   __  \ \  \\\  \ \   _  _\ \  \_|/_\ \  \ \\ \       \ \   ____\ \  \\\  \ \  \\ \  \ \   ___  \        \ \    / / \ \   __  \ \  \    \ \   __  \   \ \  \       \ \  \    \ \  \    \ \  \\\  \ \   __  \
10   \ \  \|\  \ \  \\\  \ \  \\  \\ \  \_|\ \ \  \_\\ \       \ \  \___|\ \  \\\  \ \  \\ \  \ \  \\ \  \        \/  /  /   \ \  \ \  \ \  \____\ \  \ \  \   \ \  \       \ \  \____\ \  \____\ \  \\\  \ \  \|\  \
11    \ \_______\ \_______\ \__\\ _\\ \_______\ \_______\       \ \__\    \ \_______\ \__\\ \__\ \__\\ \__\     __/  / /      \ \__\ \__\ \_______\ \__\ \__\   \ \__\       \ \_______\ \_______\ \_______\ \_______\
12     \|_______|\|_______|\|__|\|__|\|_______|\|_______|        \|__|     \|_______|\|__| \|__|\|__| \|__|    |\___/ /        \|__|\|__|\|_______|\|__|\|__|    \|__|        \|_______|\|_______|\|_______|\|_______|
13                                                                                                             \|___|/
14 
15 
16 */
17 
18 
19 // File: @openzeppelin/contracts/utils/Context.sol
20 
21 pragma solidity ^0.8.0;
22 
23 /*
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
40         return msg.data;
41     }
42 }
43 
44 // File: @openzeppelin/contracts/access/Ownable.sol
45 
46 
47 
48 pragma solidity ^0.8.0;
49 
50 /**
51  * @dev Contract module which provides a basic access control mechanism, where
52  * there is an account (an owner) that can be granted exclusive access to
53  * specific functions.
54  *
55  * By default, the owner account will be the one that deploys the contract. This
56  * can later be changed with {transferOwnership}.
57  *
58  * This module is used through inheritance. It will make available the modifier
59  * `onlyOwner`, which can be applied to your functions to restrict their use to
60  * the owner.
61  */
62 abstract contract Ownable is Context {
63     address private _owner;
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     /**
68      * @dev Initializes the contract setting the deployer as the initial owner.
69      */
70     constructor () {
71         address msgSender = _msgSender();
72         _owner = msgSender;
73         emit OwnershipTransferred(address(0), msgSender);
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
86     modifier onlyOwner() {
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
98     function renounceOwnership() public virtual onlyOwner {
99         emit OwnershipTransferred(_owner, address(0));
100         _owner = address(0);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Can only be called by the current owner.
106      */
107     function transferOwnership(address newOwner) public virtual onlyOwner {
108         require(newOwner != address(0), "Ownable: new owner is the zero address");
109         emit OwnershipTransferred(_owner, newOwner);
110         _owner = newOwner;
111     }
112 }
113 
114 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
115 
116 
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Interface of the ERC165 standard, as defined in the
122  * https://eips.ethereum.org/EIPS/eip-165[EIP].
123  *
124  * Implementers can declare support of contract interfaces, which can then be
125  * queried by others ({ERC165Checker}).
126  *
127  * For an implementation, see {ERC165}.
128  */
129 interface IERC165 {
130     /**
131      * @dev Returns true if this contract implements the interface defined by
132      * `interfaceId`. See the corresponding
133      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
134      * to learn more about how these ids are created.
135      *
136      * This function call must use less than 30 000 gas.
137      */
138     function supportsInterface(bytes4 interfaceId) external view returns (bool);
139 }
140 
141 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
142 
143 
144 
145 pragma solidity ^0.8.0;
146 
147 
148 /**
149  * @dev Required interface of an ERC721 compliant contract.
150  */
151 interface IERC721 is IERC165 {
152     /**
153      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
154      */
155     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
156 
157     /**
158      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
159      */
160     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
161 
162     /**
163      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
164      */
165     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
166 
167     /**
168      * @dev Returns the number of tokens in ``owner``'s account.
169      */
170     function balanceOf(address owner) external view returns (uint256 balance);
171 
172     /**
173      * @dev Returns the owner of the `tokenId` token.
174      *
175      * Requirements:
176      *
177      * - `tokenId` must exist.
178      */
179     function ownerOf(uint256 tokenId) external view returns (address owner);
180 
181     /**
182      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
183      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
184      *
185      * Requirements:
186      *
187      * - `from` cannot be the zero address.
188      * - `to` cannot be the zero address.
189      * - `tokenId` token must exist and be owned by `from`.
190      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
191      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
192      *
193      * Emits a {Transfer} event.
194      */
195     function safeTransferFrom(address from, address to, uint256 tokenId) external;
196 
197     /**
198      * @dev Transfers `tokenId` token from `from` to `to`.
199      *
200      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
201      *
202      * Requirements:
203      *
204      * - `from` cannot be the zero address.
205      * - `to` cannot be the zero address.
206      * - `tokenId` token must be owned by `from`.
207      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transferFrom(address from, address to, uint256 tokenId) external;
212 
213     /**
214      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
215      * The approval is cleared when the token is transferred.
216      *
217      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
218      *
219      * Requirements:
220      *
221      * - The caller must own the token or be an approved operator.
222      * - `tokenId` must exist.
223      *
224      * Emits an {Approval} event.
225      */
226     function approve(address to, uint256 tokenId) external;
227 
228     /**
229      * @dev Returns the account approved for `tokenId` token.
230      *
231      * Requirements:
232      *
233      * - `tokenId` must exist.
234      */
235     function getApproved(uint256 tokenId) external view returns (address operator);
236 
237     /**
238      * @dev Approve or remove `operator` as an operator for the caller.
239      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
240      *
241      * Requirements:
242      *
243      * - The `operator` cannot be the caller.
244      *
245      * Emits an {ApprovalForAll} event.
246      */
247     function setApprovalForAll(address operator, bool _approved) external;
248 
249     /**
250      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
251      *
252      * See {setApprovalForAll}
253      */
254     function isApprovedForAll(address owner, address operator) external view returns (bool);
255 
256     /**
257       * @dev Safely transfers `tokenId` token from `from` to `to`.
258       *
259       * Requirements:
260       *
261       * - `from` cannot be the zero address.
262       * - `to` cannot be the zero address.
263       * - `tokenId` token must exist and be owned by `from`.
264       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
265       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
266       *
267       * Emits a {Transfer} event.
268       */
269     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
270 }
271 
272 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
273 
274 
275 
276 pragma solidity ^0.8.0;
277 
278 /**
279  * @title ERC721 token receiver interface
280  * @dev Interface for any contract that wants to support safeTransfers
281  * from ERC721 asset contracts.
282  */
283 interface IERC721Receiver {
284     /**
285      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
286      * by `operator` from `from`, this function is called.
287      *
288      * It must return its Solidity selector to confirm the token transfer.
289      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
290      *
291      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
292      */
293     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
294 }
295 
296 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
297 
298 
299 
300 pragma solidity ^0.8.0;
301 
302 
303 /**
304  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
305  * @dev See https://eips.ethereum.org/EIPS/eip-721
306  */
307 interface IERC721Metadata is IERC721 {
308 
309     /**
310      * @dev Returns the token collection name.
311      */
312     function name() external view returns (string memory);
313 
314     /**
315      * @dev Returns the token collection symbol.
316      */
317     function symbol() external view returns (string memory);
318 
319     /**
320      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
321      */
322     function tokenURI(uint256 tokenId) external view returns (string memory);
323 }
324 
325 // File: @openzeppelin/contracts/utils/Address.sol
326 
327 
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @dev Collection of functions related to the address type
333  */
334 library Address {
335     /**
336      * @dev Returns true if `account` is a contract.
337      *
338      * [IMPORTANT]
339      * ====
340      * It is unsafe to assume that an address for which this function returns
341      * false is an externally-owned account (EOA) and not a contract.
342      *
343      * Among others, `isContract` will return false for the following
344      * types of addresses:
345      *
346      *  - an externally-owned account
347      *  - a contract in construction
348      *  - an address where a contract will be created
349      *  - an address where a contract lived, but was destroyed
350      * ====
351      */
352     function isContract(address account) internal view returns (bool) {
353         // This method relies on extcodesize, which returns 0 for contracts in
354         // construction, since the code is only stored at the end of the
355         // constructor execution.
356 
357         uint256 size;
358         // solhint-disable-next-line no-inline-assembly
359         assembly { size := extcodesize(account) }
360         return size > 0;
361     }
362 
363     /**
364      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
365      * `recipient`, forwarding all available gas and reverting on errors.
366      *
367      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
368      * of certain opcodes, possibly making contracts go over the 2300 gas limit
369      * imposed by `transfer`, making them unable to receive funds via
370      * `transfer`. {sendValue} removes this limitation.
371      *
372      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
373      *
374      * IMPORTANT: because control is transferred to `recipient`, care must be
375      * taken to not create reentrancy vulnerabilities. Consider using
376      * {ReentrancyGuard} or the
377      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
378      */
379     function sendValue(address payable recipient, uint256 amount) internal {
380         require(address(this).balance >= amount, "Address: insufficient balance");
381 
382         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
383         (bool success, ) = recipient.call{ value: amount }("");
384         require(success, "Address: unable to send value, recipient may have reverted");
385     }
386 
387     /**
388      * @dev Performs a Solidity function call using a low level `call`. A
389      * plain`call` is an unsafe replacement for a function call: use this
390      * function instead.
391      *
392      * If `target` reverts with a revert reason, it is bubbled up by this
393      * function (like regular Solidity function calls).
394      *
395      * Returns the raw returned data. To convert to the expected return value,
396      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
397      *
398      * Requirements:
399      *
400      * - `target` must be a contract.
401      * - calling `target` with `data` must not revert.
402      *
403      * _Available since v3.1._
404      */
405     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
406       return functionCall(target, data, "Address: low-level call failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
411      * `errorMessage` as a fallback revert reason when `target` reverts.
412      *
413      * _Available since v3.1._
414      */
415     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
416         return functionCallWithValue(target, data, 0, errorMessage);
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
421      * but also transferring `value` wei to `target`.
422      *
423      * Requirements:
424      *
425      * - the calling contract must have an ETH balance of at least `value`.
426      * - the called Solidity function must be `payable`.
427      *
428      * _Available since v3.1._
429      */
430     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
431         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
436      * with `errorMessage` as a fallback revert reason when `target` reverts.
437      *
438      * _Available since v3.1._
439      */
440     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
441         require(address(this).balance >= value, "Address: insufficient balance for call");
442         require(isContract(target), "Address: call to non-contract");
443 
444         // solhint-disable-next-line avoid-low-level-calls
445         (bool success, bytes memory returndata) = target.call{ value: value }(data);
446         return _verifyCallResult(success, returndata, errorMessage);
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
451      * but performing a static call.
452      *
453      * _Available since v3.3._
454      */
455     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
456         return functionStaticCall(target, data, "Address: low-level static call failed");
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
461      * but performing a static call.
462      *
463      * _Available since v3.3._
464      */
465     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
466         require(isContract(target), "Address: static call to non-contract");
467 
468         // solhint-disable-next-line avoid-low-level-calls
469         (bool success, bytes memory returndata) = target.staticcall(data);
470         return _verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475      * but performing a delegate call.
476      *
477      * _Available since v3.4._
478      */
479     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
480         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
485      * but performing a delegate call.
486      *
487      * _Available since v3.4._
488      */
489     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
490         require(isContract(target), "Address: delegate call to non-contract");
491 
492         // solhint-disable-next-line avoid-low-level-calls
493         (bool success, bytes memory returndata) = target.delegatecall(data);
494         return _verifyCallResult(success, returndata, errorMessage);
495     }
496 
497     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
498         if (success) {
499             return returndata;
500         } else {
501             // Look for revert reason and bubble it up if present
502             if (returndata.length > 0) {
503                 // The easiest way to bubble the revert reason is using memory via assembly
504 
505                 // solhint-disable-next-line no-inline-assembly
506                 assembly {
507                     let returndata_size := mload(returndata)
508                     revert(add(32, returndata), returndata_size)
509                 }
510             } else {
511                 revert(errorMessage);
512             }
513         }
514     }
515 }
516 
517 // File: @openzeppelin/contracts/utils/Strings.sol
518 
519 
520 
521 pragma solidity ^0.8.0;
522 
523 /**
524  * @dev String operations.
525  */
526 library Strings {
527     bytes16 private constant alphabet = "0123456789abcdef";
528 
529     /**
530      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
531      */
532     function toString(uint256 value) internal pure returns (string memory) {
533         // Inspired by OraclizeAPI's implementation - MIT licence
534         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
535 
536         if (value == 0) {
537             return "0";
538         }
539         uint256 temp = value;
540         uint256 digits;
541         while (temp != 0) {
542             digits++;
543             temp /= 10;
544         }
545         bytes memory buffer = new bytes(digits);
546         while (value != 0) {
547             digits -= 1;
548             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
549             value /= 10;
550         }
551         return string(buffer);
552     }
553 
554     /**
555      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
556      */
557     function toHexString(uint256 value) internal pure returns (string memory) {
558         if (value == 0) {
559             return "0x00";
560         }
561         uint256 temp = value;
562         uint256 length = 0;
563         while (temp != 0) {
564             length++;
565             temp >>= 8;
566         }
567         return toHexString(value, length);
568     }
569 
570     /**
571      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
572      */
573     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
574         bytes memory buffer = new bytes(2 * length + 2);
575         buffer[0] = "0";
576         buffer[1] = "x";
577         for (uint256 i = 2 * length + 1; i > 1; --i) {
578             buffer[i] = alphabet[value & 0xf];
579             value >>= 4;
580         }
581         require(value == 0, "Strings: hex length insufficient");
582         return string(buffer);
583     }
584 
585 }
586 
587 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
588 
589 
590 
591 pragma solidity ^0.8.0;
592 
593 
594 /**
595  * @dev Implementation of the {IERC165} interface.
596  *
597  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
598  * for the additional interface id that will be supported. For example:
599  *
600  * ```solidity
601  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
602  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
603  * }
604  * ```
605  *
606  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
607  */
608 abstract contract ERC165 is IERC165 {
609     /**
610      * @dev See {IERC165-supportsInterface}.
611      */
612     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
613         return interfaceId == type(IERC165).interfaceId;
614     }
615 }
616 
617 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
618 
619 
620 
621 pragma solidity ^0.8.0;
622 
623 
624 
625 
626 
627 
628 
629 
630 /**
631  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
632  * the Metadata extension, but not including the Enumerable extension, which is available separately as
633  * {ERC721Enumerable}.
634  */
635 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
636     using Address for address;
637     using Strings for uint256;
638 
639     // Token name
640     string private _name;
641 
642     // Token symbol
643     string private _symbol;
644 
645     // Mapping from token ID to owner address
646     mapping (uint256 => address) private _owners;
647 
648     // Mapping owner address to token count
649     mapping (address => uint256) private _balances;
650 
651     // Mapping from token ID to approved address
652     mapping (uint256 => address) private _tokenApprovals;
653 
654     // Mapping from owner to operator approvals
655     mapping (address => mapping (address => bool)) private _operatorApprovals;
656 
657     /**
658      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
659      */
660     constructor (string memory name_, string memory symbol_) {
661         _name = name_;
662         _symbol = symbol_;
663     }
664 
665     /**
666      * @dev See {IERC165-supportsInterface}.
667      */
668     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
669         return interfaceId == type(IERC721).interfaceId
670             || interfaceId == type(IERC721Metadata).interfaceId
671             || super.supportsInterface(interfaceId);
672     }
673 
674     /**
675      * @dev See {IERC721-balanceOf}.
676      */
677     function balanceOf(address owner) public view virtual override returns (uint256) {
678         require(owner != address(0), "ERC721: balance query for the zero address");
679         return _balances[owner];
680     }
681 
682     /**
683      * @dev See {IERC721-ownerOf}.
684      */
685     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
686         address owner = _owners[tokenId];
687         require(owner != address(0), "ERC721: owner query for nonexistent token");
688         return owner;
689     }
690 
691     /**
692      * @dev See {IERC721Metadata-name}.
693      */
694     function name() public view virtual override returns (string memory) {
695         return _name;
696     }
697 
698     /**
699      * @dev See {IERC721Metadata-symbol}.
700      */
701     function symbol() public view virtual override returns (string memory) {
702         return _symbol;
703     }
704 
705     /**
706      * @dev See {IERC721Metadata-tokenURI}.
707      */
708     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
709         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
710 
711         string memory baseURI = _baseURI();
712         return bytes(baseURI).length > 0
713             ? string(abi.encodePacked(baseURI, tokenId.toString()))
714             : '';
715     }
716 
717     /**
718      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
719      * in child contracts.
720      */
721     function _baseURI() internal view virtual returns (string memory) {
722         return "";
723     }
724 
725     /**
726      * @dev See {IERC721-approve}.
727      */
728     function approve(address to, uint256 tokenId) public virtual override {
729         address owner = ERC721.ownerOf(tokenId);
730         require(to != owner, "ERC721: approval to current owner");
731 
732         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
733             "ERC721: approve caller is not owner nor approved for all"
734         );
735 
736         _approve(to, tokenId);
737     }
738 
739     /**
740      * @dev See {IERC721-getApproved}.
741      */
742     function getApproved(uint256 tokenId) public view virtual override returns (address) {
743         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
744 
745         return _tokenApprovals[tokenId];
746     }
747 
748     /**
749      * @dev See {IERC721-setApprovalForAll}.
750      */
751     function setApprovalForAll(address operator, bool approved) public virtual override {
752         require(operator != _msgSender(), "ERC721: approve to caller");
753 
754         _operatorApprovals[_msgSender()][operator] = approved;
755         emit ApprovalForAll(_msgSender(), operator, approved);
756     }
757 
758     /**
759      * @dev See {IERC721-isApprovedForAll}.
760      */
761     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
762         return _operatorApprovals[owner][operator];
763     }
764 
765     /**
766      * @dev See {IERC721-transferFrom}.
767      */
768     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
769         //solhint-disable-next-line max-line-length
770         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
771 
772         _transfer(from, to, tokenId);
773     }
774 
775     /**
776      * @dev See {IERC721-safeTransferFrom}.
777      */
778     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
779         safeTransferFrom(from, to, tokenId, "");
780     }
781 
782     /**
783      * @dev See {IERC721-safeTransferFrom}.
784      */
785     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
786         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
787         _safeTransfer(from, to, tokenId, _data);
788     }
789 
790     /**
791      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
792      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
793      *
794      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
795      *
796      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
797      * implement alternative mechanisms to perform token transfer, such as signature-based.
798      *
799      * Requirements:
800      *
801      * - `from` cannot be the zero address.
802      * - `to` cannot be the zero address.
803      * - `tokenId` token must exist and be owned by `from`.
804      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
805      *
806      * Emits a {Transfer} event.
807      */
808     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
809         _transfer(from, to, tokenId);
810         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
811     }
812 
813     /**
814      * @dev Returns whether `tokenId` exists.
815      *
816      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
817      *
818      * Tokens start existing when they are minted (`_mint`),
819      * and stop existing when they are burned (`_burn`).
820      */
821     function _exists(uint256 tokenId) internal view virtual returns (bool) {
822         return _owners[tokenId] != address(0);
823     }
824 
825     /**
826      * @dev Returns whether `spender` is allowed to manage `tokenId`.
827      *
828      * Requirements:
829      *
830      * - `tokenId` must exist.
831      */
832     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
833         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
834         address owner = ERC721.ownerOf(tokenId);
835         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
836     }
837 
838     /**
839      * @dev Safely mints `tokenId` and transfers it to `to`.
840      *
841      * Requirements:
842      *
843      * - `tokenId` must not exist.
844      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
845      *
846      * Emits a {Transfer} event.
847      */
848     function _safeMint(address to, uint256 tokenId) internal virtual {
849         _safeMint(to, tokenId, "");
850     }
851 
852     /**
853      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
854      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
855      */
856     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
857         _mint(to, tokenId);
858         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
859     }
860 
861     /**
862      * @dev Mints `tokenId` and transfers it to `to`.
863      *
864      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
865      *
866      * Requirements:
867      *
868      * - `tokenId` must not exist.
869      * - `to` cannot be the zero address.
870      *
871      * Emits a {Transfer} event.
872      */
873     function _mint(address to, uint256 tokenId) internal virtual {
874         require(to != address(0), "ERC721: mint to the zero address");
875         require(!_exists(tokenId), "ERC721: token already minted");
876 
877         _beforeTokenTransfer(address(0), to, tokenId);
878 
879         _balances[to] += 1;
880         _owners[tokenId] = to;
881 
882         emit Transfer(address(0), to, tokenId);
883     }
884 
885     /**
886      * @dev Destroys `tokenId`.
887      * The approval is cleared when the token is burned.
888      *
889      * Requirements:
890      *
891      * - `tokenId` must exist.
892      *
893      * Emits a {Transfer} event.
894      */
895     function _burn(uint256 tokenId) internal virtual {
896         address owner = ERC721.ownerOf(tokenId);
897 
898         _beforeTokenTransfer(owner, address(0), tokenId);
899 
900         // Clear approvals
901         _approve(address(0), tokenId);
902 
903         _balances[owner] -= 1;
904         delete _owners[tokenId];
905 
906         emit Transfer(owner, address(0), tokenId);
907     }
908 
909     /**
910      * @dev Transfers `tokenId` from `from` to `to`.
911      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
912      *
913      * Requirements:
914      *
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must be owned by `from`.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _transfer(address from, address to, uint256 tokenId) internal virtual {
921         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
922         require(to != address(0), "ERC721: transfer to the zero address");
923 
924         _beforeTokenTransfer(from, to, tokenId);
925 
926         // Clear approvals from the previous owner
927         _approve(address(0), tokenId);
928 
929         _balances[from] -= 1;
930         _balances[to] += 1;
931         _owners[tokenId] = to;
932 
933         emit Transfer(from, to, tokenId);
934     }
935 
936     /**
937      * @dev Approve `to` to operate on `tokenId`
938      *
939      * Emits a {Approval} event.
940      */
941     function _approve(address to, uint256 tokenId) internal virtual {
942         _tokenApprovals[tokenId] = to;
943         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
944     }
945 
946     /**
947      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
948      * The call is not executed if the target address is not a contract.
949      *
950      * @param from address representing the previous owner of the given token ID
951      * @param to target address that will receive the tokens
952      * @param tokenId uint256 ID of the token to be transferred
953      * @param _data bytes optional data to send along with the call
954      * @return bool whether the call correctly returned the expected magic value
955      */
956     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
957         private returns (bool)
958     {
959         if (to.isContract()) {
960             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
961                 return retval == IERC721Receiver(to).onERC721Received.selector;
962             } catch (bytes memory reason) {
963                 if (reason.length == 0) {
964                     revert("ERC721: transfer to non ERC721Receiver implementer");
965                 } else {
966                     // solhint-disable-next-line no-inline-assembly
967                     assembly {
968                         revert(add(32, reason), mload(reason))
969                     }
970                 }
971             }
972         } else {
973             return true;
974         }
975     }
976 
977     /**
978      * @dev Hook that is called before any token transfer. This includes minting
979      * and burning.
980      *
981      * Calling conditions:
982      *
983      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
984      * transferred to `to`.
985      * - When `from` is zero, `tokenId` will be minted for `to`.
986      * - When `to` is zero, ``from``'s `tokenId` will be burned.
987      * - `from` cannot be the zero address.
988      * - `to` cannot be the zero address.
989      *
990      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
991      */
992     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
993 }
994 
995 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
996 
997 
998 
999 pragma solidity ^0.8.0;
1000 
1001 /**
1002  * @dev These functions deal with verification of Merkle Trees proofs.
1003  *
1004  * The proofs can be generated using the JavaScript library
1005  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1006  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1007  *
1008  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1009  */
1010 library MerkleProof {
1011     /**
1012      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1013      * defined by `root`. For this, a `proof` must be provided, containing
1014      * sibling hashes on the branch from the leaf to the root of the tree. Each
1015      * pair of leaves and each pair of pre-images are assumed to be sorted.
1016      */
1017     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
1018         bytes32 computedHash = leaf;
1019 
1020         for (uint256 i = 0; i < proof.length; i++) {
1021             bytes32 proofElement = proof[i];
1022 
1023             if (computedHash <= proofElement) {
1024                 // Hash(current computed hash + current element of the proof)
1025                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1026             } else {
1027                 // Hash(current element of the proof + current computed hash)
1028                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1029             }
1030         }
1031 
1032         // Check if the computed hash (root) is equal to the provided root
1033         return computedHash == root;
1034     }
1035 }
1036 
1037 // File: contracts/BoredPunk.sol
1038 
1039 
1040 pragma solidity ^0.8.4;
1041 
1042 
1043 
1044 
1045 interface IERC20 {
1046   function currentSupply() external view returns (uint);
1047   function balanceOf(address tokenOwner) external view returns (uint balance);
1048   function allowance(address tokenOwner, address spender) external view returns (uint remaining);
1049   function transfer(address to, uint tokens) external returns (bool success);
1050   function approve(address spender, uint tokens) external returns (bool success);
1051   function transferFrom(address from, address to, uint tokens) external returns (bool success);
1052 
1053   event Transfer(address indexed from, address indexed to, uint tokens);
1054   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
1055 }
1056 
1057 interface Opensea {
1058     function balanceOf(address tokenOwner, uint tokenId) external view returns (bool);
1059 
1060     function safeTransferFrom(address _from, address _to, uint _id, uint _value, bytes memory _data) external;
1061 }
1062 
1063 contract BoredPunkYachtClub is ERC721, Ownable {
1064 
1065     event Mint(address indexed _to, uint indexed _tokenId);
1066 
1067     bytes32 public merkleRoot = ""; // Construct this from (oldId, newId) tuple elements
1068     address public openseaSharedAddress = 0x495f947276749Ce646f68AC8c248420045cb7b5e;
1069     address public burnAddress = 0x000000000000000000000000000000000000dEaD;
1070     uint public maxSupply = 888; // Maximum tokens that can be minted
1071     uint public totalSupply = 0; // This is our mint counter as well
1072     string public _baseTokenURI;
1073 
1074     // Royalty variables below
1075     uint public spoofInitBalance = 1 ether;
1076     uint constant public PRECISION = 1000000; // million
1077     uint public curMul = 1 * PRECISION;
1078     mapping(uint => uint) public tokenMultipliers; // Maps token id to last withdrawal multiplier
1079 
1080 
1081     constructor() payable ERC721("BoredPunkYachtClub", "BPYC") {}
1082 
1083     receive() external payable {
1084         // As of July 2021, OpenSea distributes royalties if the gas fee is less than 0.04 eth
1085         curMul += (msg.value * PRECISION) / (spoofInitBalance * totalSupply); // This could round down to 0 if not careful; only greater if msg.value > 0.001 eth
1086     }
1087 
1088     function claimMultipleRewards(uint[] memory tokenIds) public {
1089         for (uint i = 0; i < tokenIds.length; i++) {
1090             claimRewards(tokenIds[i]);
1091         }
1092     }
1093 
1094     function claimRewards(uint tokenId) public {
1095         address tokenOwner = ownerOf(tokenId);
1096         // require(tokenOwner == msg.sender, "Only tokenholder can claim rewards");
1097 
1098         uint weiReward = (curMul - tokenMultipliers[tokenId]) * spoofInitBalance / PRECISION;
1099         tokenMultipliers[tokenId] = curMul;
1100 
1101         (bool success,) = tokenOwner.call{value: weiReward}("");
1102         require(success, "Failed to send ether");
1103     }
1104 
1105 
1106     function mintAndBurn(uint256 oldId, uint256 newId, bytes32 leaf, bytes32[] memory proof) external {
1107         // Don't allow reminting
1108         require(!_exists(newId), "Token already minted");
1109 
1110         // Verify that (oldId, newId) correspond to the Merkle leaf
1111         require(keccak256(abi.encodePacked(oldId, newId)) == leaf, "Ids don't match Merkle leaf");
1112 
1113         // Verify that (oldId, newId) is a valid pair in the Merkle tree
1114         require(verify(merkleRoot, leaf, proof), "Not a valid element in the Merkle tree");
1115 
1116         // Verify that msg.sender is the owner of the old token
1117         require(Opensea(openseaSharedAddress).balanceOf(msg.sender, oldId), "Only token owner can mintAndBurn"); // Error coming here
1118 
1119         // Transfer the old OpenSea Shared Storefront token to this contract (with ability for owner to retrieve in case of error)
1120         Opensea(openseaSharedAddress).safeTransferFrom(msg.sender, burnAddress, oldId, 1, "");
1121 
1122         // Mint new token
1123         _mint(msg.sender, newId);
1124         emit Mint(msg.sender, newId);
1125         totalSupply += 1;
1126 
1127         // Initialize the rewards multiplier
1128         tokenMultipliers[newId] = curMul;
1129     }
1130 
1131     function onERC721Received(
1132         address operator,
1133         address from,
1134         uint256 tokenId,
1135         bytes calldata data
1136     ) public returns (bytes4) {
1137         return 0xf0b9e5ba;
1138     }
1139 
1140     function verify(bytes32 root, bytes32 leaf, bytes32[] memory proof) public pure returns (bool) {
1141         return MerkleProof.verify(proof, root, leaf);
1142     }
1143 
1144     /**
1145      * @dev Returns a URI for a given token ID's metadata
1146      */
1147     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1148         return string(abi.encodePacked(_baseTokenURI, Strings.toString(_tokenId)));
1149     }
1150 
1151     /**
1152      * @dev Updates the base token URI for the metadata
1153      */
1154     function setBaseTokenURI(string memory __baseTokenURI) public onlyOwner {
1155         _baseTokenURI = __baseTokenURI;
1156     }
1157 
1158     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1159         merkleRoot = _merkleRoot;
1160     }
1161 }