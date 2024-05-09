1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @title ERC721 token receiver interface
12  * @dev Interface for any contract that wants to support safeTransfers
13  * from ERC721 asset contracts.
14  */
15 interface IERC721Receiver {
16     /**
17      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
18      * by `operator` from `from`, this function is called.
19      *
20      * It must return its Solidity selector to confirm the token transfer.
21      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
22      *
23      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
24      */
25     function onERC721Received(
26         address operator,
27         address from,
28         uint256 tokenId,
29         bytes calldata data
30     ) external returns (bytes4);
31 }
32 
33 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
34 
35 
36 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Interface of the ERC165 standard, as defined in the
42  * https://eips.ethereum.org/EIPS/eip-165[EIP].
43  *
44  * Implementers can declare support of contract interfaces, which can then be
45  * queried by others ({ERC165Checker}).
46  *
47  * For an implementation, see {ERC165}.
48  */
49 interface IERC165 {
50     /**
51      * @dev Returns true if this contract implements the interface defined by
52      * `interfaceId`. See the corresponding
53      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
54      * to learn more about how these ids are created.
55      *
56      * This function call must use less than 30 000 gas.
57      */
58     function supportsInterface(bytes4 interfaceId) external view returns (bool);
59 }
60 
61 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
62 
63 
64 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
65 
66 pragma solidity ^0.8.0;
67 
68 
69 /**
70  * @dev Implementation of the {IERC165} interface.
71  *
72  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
73  * for the additional interface id that will be supported. For example:
74  *
75  * ```solidity
76  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
77  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
78  * }
79  * ```
80  *
81  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
82  */
83 abstract contract ERC165 is IERC165 {
84     /**
85      * @dev See {IERC165-supportsInterface}.
86      */
87     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
88         return interfaceId == type(IERC165).interfaceId;
89     }
90 }
91 
92 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
93 
94 
95 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
96 
97 pragma solidity ^0.8.0;
98 
99 
100 /**
101  * @dev Required interface of an ERC721 compliant contract.
102  */
103 interface IERC721 is IERC165 {
104     /**
105      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
106      */
107     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
108 
109     /**
110      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
111      */
112     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
113 
114     /**
115      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
116      */
117     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
118 
119     /**
120      * @dev Returns the number of tokens in ``owner``'s account.
121      */
122     function balanceOf(address owner) external view returns (uint256 balance);
123 
124     /**
125      * @dev Returns the owner of the `tokenId` token.
126      *
127      * Requirements:
128      *
129      * - `tokenId` must exist.
130      */
131     function ownerOf(uint256 tokenId) external view returns (address owner);
132 
133     /**
134      * @dev Safely transfers `tokenId` token from `from` to `to`.
135      *
136      * Requirements:
137      *
138      * - `from` cannot be the zero address.
139      * - `to` cannot be the zero address.
140      * - `tokenId` token must exist and be owned by `from`.
141      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
142      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
143      *
144      * Emits a {Transfer} event.
145      */
146     function safeTransferFrom(
147         address from,
148         address to,
149         uint256 tokenId,
150         bytes calldata data
151     ) external;
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
155      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId
171     ) external;
172 
173     /**
174      * @dev Transfers `tokenId` token from `from` to `to`.
175      *
176      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
177      *
178      * Requirements:
179      *
180      * - `from` cannot be the zero address.
181      * - `to` cannot be the zero address.
182      * - `tokenId` token must be owned by `from`.
183      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
184      *
185      * Emits a {Transfer} event.
186      */
187     function transferFrom(
188         address from,
189         address to,
190         uint256 tokenId
191     ) external;
192 
193     /**
194      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
195      * The approval is cleared when the token is transferred.
196      *
197      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
198      *
199      * Requirements:
200      *
201      * - The caller must own the token or be an approved operator.
202      * - `tokenId` must exist.
203      *
204      * Emits an {Approval} event.
205      */
206     function approve(address to, uint256 tokenId) external;
207 
208     /**
209      * @dev Approve or remove `operator` as an operator for the caller.
210      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
211      *
212      * Requirements:
213      *
214      * - The `operator` cannot be the caller.
215      *
216      * Emits an {ApprovalForAll} event.
217      */
218     function setApprovalForAll(address operator, bool _approved) external;
219 
220     /**
221      * @dev Returns the account approved for `tokenId` token.
222      *
223      * Requirements:
224      *
225      * - `tokenId` must exist.
226      */
227     function getApproved(uint256 tokenId) external view returns (address operator);
228 
229     /**
230      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
231      *
232      * See {setApprovalForAll}
233      */
234     function isApprovedForAll(address owner, address operator) external view returns (bool);
235 }
236 
237 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
238 
239 
240 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
241 
242 pragma solidity ^0.8.0;
243 
244 
245 /**
246  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
247  * @dev See https://eips.ethereum.org/EIPS/eip-721
248  */
249 interface IERC721Enumerable is IERC721 {
250     /**
251      * @dev Returns the total amount of tokens stored by the contract.
252      */
253     function totalSupply() external view returns (uint256);
254 
255     /**
256      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
257      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
258      */
259     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
260 
261     /**
262      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
263      * Use along with {totalSupply} to enumerate all tokens.
264      */
265     function tokenByIndex(uint256 index) external view returns (uint256);
266 }
267 
268 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
269 
270 
271 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
272 
273 pragma solidity ^0.8.0;
274 
275 
276 /**
277  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
278  * @dev See https://eips.ethereum.org/EIPS/eip-721
279  */
280 interface IERC721Metadata is IERC721 {
281     /**
282      * @dev Returns the token collection name.
283      */
284     function name() external view returns (string memory);
285 
286     /**
287      * @dev Returns the token collection symbol.
288      */
289     function symbol() external view returns (string memory);
290 
291     /**
292      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
293      */
294     function tokenURI(uint256 tokenId) external view returns (string memory);
295 }
296 
297 // File: @openzeppelin/contracts/utils/Context.sol
298 
299 
300 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev Provides information about the current execution context, including the
306  * sender of the transaction and its data. While these are generally available
307  * via msg.sender and msg.data, they should not be accessed in such a direct
308  * manner, since when dealing with meta-transactions the account sending and
309  * paying for execution may not be the actual sender (as far as an application
310  * is concerned).
311  *
312  * This contract is only required for intermediate, library-like contracts.
313  */
314 abstract contract Context {
315     function _msgSender() internal view virtual returns (address) {
316         return msg.sender;
317     }
318 
319     function _msgData() internal view virtual returns (bytes calldata) {
320         return msg.data;
321     }
322 }
323 
324 // File: @openzeppelin/contracts/access/Ownable.sol
325 
326 
327 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 
332 /**
333  * @dev Contract module which provides a basic access control mechanism, where
334  * there is an account (an owner) that can be granted exclusive access to
335  * specific functions.
336  *
337  * By default, the owner account will be the one that deploys the contract. This
338  * can later be changed with {transferOwnership}.
339  *
340  * This module is used through inheritance. It will make available the modifier
341  * `onlyOwner`, which can be applied to your functions to restrict their use to
342  * the owner.
343  */
344 abstract contract Ownable is Context {
345     address private _owner;
346 
347     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
348 
349     /**
350      * @dev Initializes the contract setting the deployer as the initial owner.
351      */
352     constructor() {
353         _transferOwnership(_msgSender());
354     }
355 
356     /**
357      * @dev Returns the address of the current owner.
358      */
359     function owner() public view virtual returns (address) {
360         return _owner;
361     }
362 
363     /**
364      * @dev Throws if called by any account other than the owner.
365      */
366     modifier onlyOwner() {
367         require(owner() == _msgSender(), "Ownable: caller is not the owner");
368         _;
369     }
370 
371     /**
372      * @dev Leaves the contract without owner. It will not be possible to call
373      * `onlyOwner` functions anymore. Can only be called by the current owner.
374      *
375      * NOTE: Renouncing ownership will leave the contract without an owner,
376      * thereby removing any functionality that is only available to the owner.
377      */
378     function renounceOwnership() public virtual onlyOwner {
379         _transferOwnership(address(0));
380     }
381 
382     /**
383      * @dev Transfers ownership of the contract to a new account (`newOwner`).
384      * Can only be called by the current owner.
385      */
386     function transferOwnership(address newOwner) public virtual onlyOwner {
387         require(newOwner != address(0), "Ownable: new owner is the zero address");
388         _transferOwnership(newOwner);
389     }
390 
391     /**
392      * @dev Transfers ownership of the contract to a new account (`newOwner`).
393      * Internal function without access restriction.
394      */
395     function _transferOwnership(address newOwner) internal virtual {
396         address oldOwner = _owner;
397         _owner = newOwner;
398         emit OwnershipTransferred(oldOwner, newOwner);
399     }
400 }
401 
402 // File: @openzeppelin/contracts/utils/Address.sol
403 
404 
405 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
406 
407 pragma solidity ^0.8.1;
408 
409 /**
410  * @dev Collection of functions related to the address type
411  */
412 library Address {
413     /**
414      * @dev Returns true if `account` is a contract.
415      *
416      * [IMPORTANT]
417      * ====
418      * It is unsafe to assume that an address for which this function returns
419      * false is an externally-owned account (EOA) and not a contract.
420      *
421      * Among others, `isContract` will return false for the following
422      * types of addresses:
423      *
424      *  - an externally-owned account
425      *  - a contract in construction
426      *  - an address where a contract will be created
427      *  - an address where a contract lived, but was destroyed
428      * ====
429      *
430      * [IMPORTANT]
431      * ====
432      * You shouldn't rely on `isContract` to protect against flash loan attacks!
433      *
434      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
435      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
436      * constructor.
437      * ====
438      */
439     function isContract(address account) internal view returns (bool) {
440         // This method relies on extcodesize/address.code.length, which returns 0
441         // for contracts in construction, since the code is only stored at the end
442         // of the constructor execution.
443 
444         return account.code.length > 0;
445     }
446 
447     /**
448      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
449      * `recipient`, forwarding all available gas and reverting on errors.
450      *
451      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
452      * of certain opcodes, possibly making contracts go over the 2300 gas limit
453      * imposed by `transfer`, making them unable to receive funds via
454      * `transfer`. {sendValue} removes this limitation.
455      *
456      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
457      *
458      * IMPORTANT: because control is transferred to `recipient`, care must be
459      * taken to not create reentrancy vulnerabilities. Consider using
460      * {ReentrancyGuard} or the
461      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
462      */
463     function sendValue(address payable recipient, uint256 amount) internal {
464         require(address(this).balance >= amount, "Address: insufficient balance");
465 
466         (bool success, ) = recipient.call{value: amount}("");
467         require(success, "Address: unable to send value, recipient may have reverted");
468     }
469 
470     /**
471      * @dev Performs a Solidity function call using a low level `call`. A
472      * plain `call` is an unsafe replacement for a function call: use this
473      * function instead.
474      *
475      * If `target` reverts with a revert reason, it is bubbled up by this
476      * function (like regular Solidity function calls).
477      *
478      * Returns the raw returned data. To convert to the expected return value,
479      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
480      *
481      * Requirements:
482      *
483      * - `target` must be a contract.
484      * - calling `target` with `data` must not revert.
485      *
486      * _Available since v3.1._
487      */
488     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
489         return functionCall(target, data, "Address: low-level call failed");
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
494      * `errorMessage` as a fallback revert reason when `target` reverts.
495      *
496      * _Available since v3.1._
497      */
498     function functionCall(
499         address target,
500         bytes memory data,
501         string memory errorMessage
502     ) internal returns (bytes memory) {
503         return functionCallWithValue(target, data, 0, errorMessage);
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
508      * but also transferring `value` wei to `target`.
509      *
510      * Requirements:
511      *
512      * - the calling contract must have an ETH balance of at least `value`.
513      * - the called Solidity function must be `payable`.
514      *
515      * _Available since v3.1._
516      */
517     function functionCallWithValue(
518         address target,
519         bytes memory data,
520         uint256 value
521     ) internal returns (bytes memory) {
522         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
527      * with `errorMessage` as a fallback revert reason when `target` reverts.
528      *
529      * _Available since v3.1._
530      */
531     function functionCallWithValue(
532         address target,
533         bytes memory data,
534         uint256 value,
535         string memory errorMessage
536     ) internal returns (bytes memory) {
537         require(address(this).balance >= value, "Address: insufficient balance for call");
538         require(isContract(target), "Address: call to non-contract");
539 
540         (bool success, bytes memory returndata) = target.call{value: value}(data);
541         return verifyCallResult(success, returndata, errorMessage);
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
546      * but performing a static call.
547      *
548      * _Available since v3.3._
549      */
550     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
551         return functionStaticCall(target, data, "Address: low-level static call failed");
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
556      * but performing a static call.
557      *
558      * _Available since v3.3._
559      */
560     function functionStaticCall(
561         address target,
562         bytes memory data,
563         string memory errorMessage
564     ) internal view returns (bytes memory) {
565         require(isContract(target), "Address: static call to non-contract");
566 
567         (bool success, bytes memory returndata) = target.staticcall(data);
568         return verifyCallResult(success, returndata, errorMessage);
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
573      * but performing a delegate call.
574      *
575      * _Available since v3.4._
576      */
577     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
578         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
583      * but performing a delegate call.
584      *
585      * _Available since v3.4._
586      */
587     function functionDelegateCall(
588         address target,
589         bytes memory data,
590         string memory errorMessage
591     ) internal returns (bytes memory) {
592         require(isContract(target), "Address: delegate call to non-contract");
593 
594         (bool success, bytes memory returndata) = target.delegatecall(data);
595         return verifyCallResult(success, returndata, errorMessage);
596     }
597 
598     /**
599      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
600      * revert reason using the provided one.
601      *
602      * _Available since v4.3._
603      */
604     function verifyCallResult(
605         bool success,
606         bytes memory returndata,
607         string memory errorMessage
608     ) internal pure returns (bytes memory) {
609         if (success) {
610             return returndata;
611         } else {
612             // Look for revert reason and bubble it up if present
613             if (returndata.length > 0) {
614                 // The easiest way to bubble the revert reason is using memory via assembly
615 
616                 assembly {
617                     let returndata_size := mload(returndata)
618                     revert(add(32, returndata), returndata_size)
619                 }
620             } else {
621                 revert(errorMessage);
622             }
623         }
624     }
625 }
626 
627 // File: @openzeppelin/contracts/utils/Strings.sol
628 
629 
630 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
631 
632 pragma solidity ^0.8.0;
633 
634 /**
635  * @dev String operations.
636  */
637 library Strings {
638     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
639 
640     /**
641      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
642      */
643     function toString(uint256 value) internal pure returns (string memory) {
644         // Inspired by OraclizeAPI's implementation - MIT licence
645         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
646 
647         if (value == 0) {
648             return "0";
649         }
650         uint256 temp = value;
651         uint256 digits;
652         while (temp != 0) {
653             digits++;
654             temp /= 10;
655         }
656         bytes memory buffer = new bytes(digits);
657         while (value != 0) {
658             digits -= 1;
659             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
660             value /= 10;
661         }
662         return string(buffer);
663     }
664 
665     /**
666      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
667      */
668     function toHexString(uint256 value) internal pure returns (string memory) {
669         if (value == 0) {
670             return "0x00";
671         }
672         uint256 temp = value;
673         uint256 length = 0;
674         while (temp != 0) {
675             length++;
676             temp >>= 8;
677         }
678         return toHexString(value, length);
679     }
680 
681     /**
682      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
683      */
684     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
685         bytes memory buffer = new bytes(2 * length + 2);
686         buffer[0] = "0";
687         buffer[1] = "x";
688         for (uint256 i = 2 * length + 1; i > 1; --i) {
689             buffer[i] = _HEX_SYMBOLS[value & 0xf];
690             value >>= 4;
691         }
692         require(value == 0, "Strings: hex length insufficient");
693         return string(buffer);
694     }
695 }
696 
697 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
698 
699 
700 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 
705 
706 
707 
708 
709 
710 
711 /**
712  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
713  * the Metadata extension, but not including the Enumerable extension, which is available separately as
714  * {ERC721Enumerable}.
715  */
716 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
717     using Address for address;
718     using Strings for uint256;
719 
720     // Token name
721     string private _name;
722 
723     // Token symbol
724     string private _symbol;
725 
726     // Mapping from token ID to owner address
727     mapping(uint256 => address) private _owners;
728 
729     // Mapping owner address to token count
730     mapping(address => uint256) private _balances;
731 
732     // Mapping from token ID to approved address
733     mapping(uint256 => address) private _tokenApprovals;
734 
735     // Mapping from owner to operator approvals
736     mapping(address => mapping(address => bool)) private _operatorApprovals;
737 
738     /**
739      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
740      */
741     constructor(string memory name_, string memory symbol_) {
742         _name = name_;
743         _symbol = symbol_;
744     }
745 
746     /**
747      * @dev See {IERC165-supportsInterface}.
748      */
749     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
750         return
751             interfaceId == type(IERC721).interfaceId ||
752             interfaceId == type(IERC721Metadata).interfaceId ||
753             super.supportsInterface(interfaceId);
754     }
755 
756     /**
757      * @dev See {IERC721-balanceOf}.
758      */
759     function balanceOf(address owner) public view virtual override returns (uint256) {
760         require(owner != address(0), "ERC721: balance query for the zero address");
761         return _balances[owner];
762     }
763 
764     /**
765      * @dev See {IERC721-ownerOf}.
766      */
767     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
768         address owner = _owners[tokenId];
769         require(owner != address(0), "ERC721: owner query for nonexistent token");
770         return owner;
771     }
772 
773     /**
774      * @dev See {IERC721Metadata-name}.
775      */
776     function name() public view virtual override returns (string memory) {
777         return _name;
778     }
779 
780     /**
781      * @dev See {IERC721Metadata-symbol}.
782      */
783     function symbol() public view virtual override returns (string memory) {
784         return _symbol;
785     }
786 
787     /**
788      * @dev See {IERC721Metadata-tokenURI}.
789      */
790     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
791         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
792 
793         string memory baseURI = _baseURI();
794         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
795     }
796 
797     /**
798      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
799      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
800      * by default, can be overridden in child contracts.
801      */
802     function _baseURI() internal view virtual returns (string memory) {
803         return "";
804     }
805 
806     /**
807      * @dev See {IERC721-approve}.
808      */
809     function approve(address to, uint256 tokenId) public virtual override {
810         address owner = ERC721.ownerOf(tokenId);
811         require(to != owner, "ERC721: approval to current owner");
812 
813         require(
814             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
815             "ERC721: approve caller is not owner nor approved for all"
816         );
817 
818         _approve(to, tokenId);
819     }
820 
821     /**
822      * @dev See {IERC721-getApproved}.
823      */
824     function getApproved(uint256 tokenId) public view virtual override returns (address) {
825         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
826 
827         return _tokenApprovals[tokenId];
828     }
829 
830     /**
831      * @dev See {IERC721-setApprovalForAll}.
832      */
833     function setApprovalForAll(address operator, bool approved) public virtual override {
834         _setApprovalForAll(_msgSender(), operator, approved);
835     }
836 
837     /**
838      * @dev See {IERC721-isApprovedForAll}.
839      */
840     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
841         return _operatorApprovals[owner][operator];
842     }
843 
844     /**
845      * @dev See {IERC721-transferFrom}.
846      */
847     function transferFrom(
848         address from,
849         address to,
850         uint256 tokenId
851     ) public virtual override {
852         //solhint-disable-next-line max-line-length
853         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
854 
855         _transfer(from, to, tokenId);
856     }
857 
858     /**
859      * @dev See {IERC721-safeTransferFrom}.
860      */
861     function safeTransferFrom(
862         address from,
863         address to,
864         uint256 tokenId
865     ) public virtual override {
866         safeTransferFrom(from, to, tokenId, "");
867     }
868 
869     /**
870      * @dev See {IERC721-safeTransferFrom}.
871      */
872     function safeTransferFrom(
873         address from,
874         address to,
875         uint256 tokenId,
876         bytes memory _data
877     ) public virtual override {
878         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
879         _safeTransfer(from, to, tokenId, _data);
880     }
881 
882     /**
883      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
884      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
885      *
886      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
887      *
888      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
889      * implement alternative mechanisms to perform token transfer, such as signature-based.
890      *
891      * Requirements:
892      *
893      * - `from` cannot be the zero address.
894      * - `to` cannot be the zero address.
895      * - `tokenId` token must exist and be owned by `from`.
896      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
897      *
898      * Emits a {Transfer} event.
899      */
900     function _safeTransfer(
901         address from,
902         address to,
903         uint256 tokenId,
904         bytes memory _data
905     ) internal virtual {
906         _transfer(from, to, tokenId);
907         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
908     }
909 
910     /**
911      * @dev Returns whether `tokenId` exists.
912      *
913      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
914      *
915      * Tokens start existing when they are minted (`_mint`),
916      * and stop existing when they are burned (`_burn`).
917      */
918     function _exists(uint256 tokenId) internal view virtual returns (bool) {
919         return _owners[tokenId] != address(0);
920     }
921 
922     /**
923      * @dev Returns whether `spender` is allowed to manage `tokenId`.
924      *
925      * Requirements:
926      *
927      * - `tokenId` must exist.
928      */
929     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
930         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
931         address owner = ERC721.ownerOf(tokenId);
932         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
933     }
934 
935     /**
936      * @dev Safely mints `tokenId` and transfers it to `to`.
937      *
938      * Requirements:
939      *
940      * - `tokenId` must not exist.
941      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
942      *
943      * Emits a {Transfer} event.
944      */
945     function _safeMint(address to, uint256 tokenId) internal virtual {
946         _safeMint(to, tokenId, "");
947     }
948 
949     /**
950      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
951      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
952      */
953     function _safeMint(
954         address to,
955         uint256 tokenId,
956         bytes memory _data
957     ) internal virtual {
958         _mint(to, tokenId);
959         require(
960             _checkOnERC721Received(address(0), to, tokenId, _data),
961             "ERC721: transfer to non ERC721Receiver implementer"
962         );
963     }
964 
965     /**
966      * @dev Mints `tokenId` and transfers it to `to`.
967      *
968      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
969      *
970      * Requirements:
971      *
972      * - `tokenId` must not exist.
973      * - `to` cannot be the zero address.
974      *
975      * Emits a {Transfer} event.
976      */
977     function _mint(address to, uint256 tokenId) internal virtual {
978         require(to != address(0), "ERC721: mint to the zero address");
979         require(!_exists(tokenId), "ERC721: token already minted");
980 
981         _beforeTokenTransfer(address(0), to, tokenId);
982 
983         _balances[to] += 1;
984         _owners[tokenId] = to;
985 
986         emit Transfer(address(0), to, tokenId);
987 
988         _afterTokenTransfer(address(0), to, tokenId);
989     }
990 
991     /**
992      * @dev Destroys `tokenId`.
993      * The approval is cleared when the token is burned.
994      *
995      * Requirements:
996      *
997      * - `tokenId` must exist.
998      *
999      * Emits a {Transfer} event.
1000      */
1001     function _burn(uint256 tokenId) internal virtual {
1002         address owner = ERC721.ownerOf(tokenId);
1003 
1004         _beforeTokenTransfer(owner, address(0), tokenId);
1005 
1006         // Clear approvals
1007         _approve(address(0), tokenId);
1008 
1009         _balances[owner] -= 1;
1010         delete _owners[tokenId];
1011 
1012         emit Transfer(owner, address(0), tokenId);
1013 
1014         _afterTokenTransfer(owner, address(0), tokenId);
1015     }
1016 
1017     /**
1018      * @dev Transfers `tokenId` from `from` to `to`.
1019      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1020      *
1021      * Requirements:
1022      *
1023      * - `to` cannot be the zero address.
1024      * - `tokenId` token must be owned by `from`.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _transfer(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) internal virtual {
1033         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1034         require(to != address(0), "ERC721: transfer to the zero address");
1035 
1036         _beforeTokenTransfer(from, to, tokenId);
1037 
1038         // Clear approvals from the previous owner
1039         _approve(address(0), tokenId);
1040 
1041         _balances[from] -= 1;
1042         _balances[to] += 1;
1043         _owners[tokenId] = to;
1044 
1045         emit Transfer(from, to, tokenId);
1046 
1047         _afterTokenTransfer(from, to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev Approve `to` to operate on `tokenId`
1052      *
1053      * Emits a {Approval} event.
1054      */
1055     function _approve(address to, uint256 tokenId) internal virtual {
1056         _tokenApprovals[tokenId] = to;
1057         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1058     }
1059 
1060     /**
1061      * @dev Approve `operator` to operate on all of `owner` tokens
1062      *
1063      * Emits a {ApprovalForAll} event.
1064      */
1065     function _setApprovalForAll(
1066         address owner,
1067         address operator,
1068         bool approved
1069     ) internal virtual {
1070         require(owner != operator, "ERC721: approve to caller");
1071         _operatorApprovals[owner][operator] = approved;
1072         emit ApprovalForAll(owner, operator, approved);
1073     }
1074 
1075     /**
1076      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1077      * The call is not executed if the target address is not a contract.
1078      *
1079      * @param from address representing the previous owner of the given token ID
1080      * @param to target address that will receive the tokens
1081      * @param tokenId uint256 ID of the token to be transferred
1082      * @param _data bytes optional data to send along with the call
1083      * @return bool whether the call correctly returned the expected magic value
1084      */
1085     function _checkOnERC721Received(
1086         address from,
1087         address to,
1088         uint256 tokenId,
1089         bytes memory _data
1090     ) private returns (bool) {
1091         if (to.isContract()) {
1092             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1093                 return retval == IERC721Receiver.onERC721Received.selector;
1094             } catch (bytes memory reason) {
1095                 if (reason.length == 0) {
1096                     revert("ERC721: transfer to non ERC721Receiver implementer");
1097                 } else {
1098                     assembly {
1099                         revert(add(32, reason), mload(reason))
1100                     }
1101                 }
1102             }
1103         } else {
1104             return true;
1105         }
1106     }
1107 
1108     /**
1109      * @dev Hook that is called before any token transfer. This includes minting
1110      * and burning.
1111      *
1112      * Calling conditions:
1113      *
1114      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1115      * transferred to `to`.
1116      * - When `from` is zero, `tokenId` will be minted for `to`.
1117      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1118      * - `from` and `to` are never both zero.
1119      *
1120      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1121      */
1122     function _beforeTokenTransfer(
1123         address from,
1124         address to,
1125         uint256 tokenId
1126     ) internal virtual {}
1127 
1128     /**
1129      * @dev Hook that is called after any transfer of tokens. This includes
1130      * minting and burning.
1131      *
1132      * Calling conditions:
1133      *
1134      * - when `from` and `to` are both non-zero.
1135      * - `from` and `to` are never both zero.
1136      *
1137      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1138      */
1139     function _afterTokenTransfer(
1140         address from,
1141         address to,
1142         uint256 tokenId
1143     ) internal virtual {}
1144 }
1145 
1146 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1147 
1148 
1149 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1150 
1151 pragma solidity ^0.8.0;
1152 
1153 
1154 
1155 /**
1156  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1157  * enumerability of all the token ids in the contract as well as all token ids owned by each
1158  * account.
1159  */
1160 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1161     // Mapping from owner to list of owned token IDs
1162     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1163 
1164     // Mapping from token ID to index of the owner tokens list
1165     mapping(uint256 => uint256) private _ownedTokensIndex;
1166 
1167     // Array with all token ids, used for enumeration
1168     uint256[] private _allTokens;
1169 
1170     // Mapping from token id to position in the allTokens array
1171     mapping(uint256 => uint256) private _allTokensIndex;
1172 
1173     /**
1174      * @dev See {IERC165-supportsInterface}.
1175      */
1176     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1177         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1178     }
1179 
1180     /**
1181      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1182      */
1183     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1184         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1185         return _ownedTokens[owner][index];
1186     }
1187 
1188     /**
1189      * @dev See {IERC721Enumerable-totalSupply}.
1190      */
1191     function totalSupply() public view virtual override returns (uint256) {
1192         return _allTokens.length;
1193     }
1194 
1195     /**
1196      * @dev See {IERC721Enumerable-tokenByIndex}.
1197      */
1198     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1199         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1200         return _allTokens[index];
1201     }
1202 
1203     /**
1204      * @dev Hook that is called before any token transfer. This includes minting
1205      * and burning.
1206      *
1207      * Calling conditions:
1208      *
1209      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1210      * transferred to `to`.
1211      * - When `from` is zero, `tokenId` will be minted for `to`.
1212      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1213      * - `from` cannot be the zero address.
1214      * - `to` cannot be the zero address.
1215      *
1216      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1217      */
1218     function _beforeTokenTransfer(
1219         address from,
1220         address to,
1221         uint256 tokenId
1222     ) internal virtual override {
1223         super._beforeTokenTransfer(from, to, tokenId);
1224 
1225         if (from == address(0)) {
1226             _addTokenToAllTokensEnumeration(tokenId);
1227         } else if (from != to) {
1228             _removeTokenFromOwnerEnumeration(from, tokenId);
1229         }
1230         if (to == address(0)) {
1231             _removeTokenFromAllTokensEnumeration(tokenId);
1232         } else if (to != from) {
1233             _addTokenToOwnerEnumeration(to, tokenId);
1234         }
1235     }
1236 
1237     /**
1238      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1239      * @param to address representing the new owner of the given token ID
1240      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1241      */
1242     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1243         uint256 length = ERC721.balanceOf(to);
1244         _ownedTokens[to][length] = tokenId;
1245         _ownedTokensIndex[tokenId] = length;
1246     }
1247 
1248     /**
1249      * @dev Private function to add a token to this extension's token tracking data structures.
1250      * @param tokenId uint256 ID of the token to be added to the tokens list
1251      */
1252     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1253         _allTokensIndex[tokenId] = _allTokens.length;
1254         _allTokens.push(tokenId);
1255     }
1256 
1257     /**
1258      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1259      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1260      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1261      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1262      * @param from address representing the previous owner of the given token ID
1263      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1264      */
1265     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1266         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1267         // then delete the last slot (swap and pop).
1268 
1269         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1270         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1271 
1272         // When the token to delete is the last token, the swap operation is unnecessary
1273         if (tokenIndex != lastTokenIndex) {
1274             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1275 
1276             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1277             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1278         }
1279 
1280         // This also deletes the contents at the last position of the array
1281         delete _ownedTokensIndex[tokenId];
1282         delete _ownedTokens[from][lastTokenIndex];
1283     }
1284 
1285     /**
1286      * @dev Private function to remove a token from this extension's token tracking data structures.
1287      * This has O(1) time complexity, but alters the order of the _allTokens array.
1288      * @param tokenId uint256 ID of the token to be removed from the tokens list
1289      */
1290     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1291         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1292         // then delete the last slot (swap and pop).
1293 
1294         uint256 lastTokenIndex = _allTokens.length - 1;
1295         uint256 tokenIndex = _allTokensIndex[tokenId];
1296 
1297         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1298         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1299         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1300         uint256 lastTokenId = _allTokens[lastTokenIndex];
1301 
1302         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1303         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1304 
1305         // This also deletes the contents at the last position of the array
1306         delete _allTokensIndex[tokenId];
1307         _allTokens.pop();
1308     }
1309 }
1310 
1311 // File: The Planet of Hares/ThePlanetOfHaresSeson2.sol
1312 
1313 
1314 pragma solidity ^0.8.0;
1315 
1316 
1317 
1318 
1319 
1320 
1321 contract ThePlanetOfHaresSeason2 is ERC721Enumerable, Ownable {
1322     using Address for address;
1323     using Strings for uint256;
1324 
1325     address public multiSigWallet;
1326     
1327     uint256 public NFT_PRICE = 400000000000000000;
1328 
1329     uint256 public constant MAX_SUPPLY = 7500;
1330 
1331     uint256 public MIN_NFT_PURCHASE = 1;
1332     uint256 public MAX_NFT_PURCHASE = 10;
1333     
1334     uint256 public hareReserve = 100;
1335     bool public saleIsActive = true;
1336     bool public isMetadataLocked = false;
1337 
1338     string private _baseURIExtended;
1339 
1340     modifier OnlyMultiSignWallet() {
1341         require(multiSigWallet == _msgSender(), "Caller is not the multiSigWallet");
1342         _;
1343     }
1344 
1345     constructor(address _multiSigWallet) ERC721("The Planet of Hares Season 2","HARES") {
1346         multiSigWallet = _multiSigWallet;
1347     }
1348 
1349     function setNFTPrice(uint256 _newPrice) public onlyOwner {
1350         NFT_PRICE = _newPrice;
1351     }
1352 
1353     function setPurchaseLimit(uint256 _min, uint256 _max) public onlyOwner {
1354         MIN_NFT_PURCHASE = _min;
1355         MAX_NFT_PURCHASE = _max;
1356     }
1357 
1358     function withdraw(address payable _recipient) public OnlyMultiSignWallet {
1359         uint balance = address(this).balance;
1360         require(balance != 0, "No balance");
1361         require(_recipient != address(0), "Withdraw to the zero address");
1362         
1363         _recipient.transfer(balance);
1364     }
1365 
1366     function flipSaleState() public onlyOwner {
1367         saleIsActive = !saleIsActive;
1368     }
1369 
1370     function lockMetadata() public onlyOwner {
1371         isMetadataLocked = true;
1372     }
1373 
1374     function reserveHares(address _to, uint256 _reserveAmount) public onlyOwner {
1375         uint256 supply = totalSupply();
1376         require(_reserveAmount > 0 && _reserveAmount <= hareReserve, "Not enough reserve left for team");
1377         for (uint256 i = 0; i < _reserveAmount; i++) {
1378             _safeMint(_to, supply + i + 2500);
1379         }
1380         hareReserve = hareReserve - _reserveAmount;
1381     }
1382 
1383     function mintHare(uint numberOfTokens) public payable {
1384         require(saleIsActive, "Sale is not active at the moment");
1385         require(numberOfTokens >= MIN_NFT_PURCHASE, "Number of tokens can not be less than MIN_NFT_PURCHASE");
1386         require(numberOfTokens <= MAX_NFT_PURCHASE, "Number of tokens can not be more than MAX_NFT_PURCHASE");
1387         require(totalSupply() + numberOfTokens <= MAX_SUPPLY - hareReserve, "Purchase would exceed max supply of Hares");
1388         require(NFT_PRICE * numberOfTokens <= msg.value, "Sent ether value is incorrect");
1389 
1390         for (uint i = 0; i < numberOfTokens; i++) {
1391             _safeMint(msg.sender, totalSupply() + 2500);
1392         }
1393     }
1394 
1395     function _baseURI() internal view virtual override returns (string memory) {
1396         return _baseURIExtended;
1397     }
1398 
1399     function setBaseURI(string memory baseURI_) external onlyOwner {
1400         require(!isMetadataLocked,"Metadata is locked");
1401         
1402         _baseURIExtended = baseURI_;
1403     }
1404 
1405     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1406         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1407 
1408         string memory base = _baseURI();
1409         return string(abi.encodePacked(base, tokenId.toString(), '.json'));
1410     }
1411 }