1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 /**
27  * @dev Required interface of an ERC721 compliant contract.
28  */
29 interface IERC721 is IERC165 {
30     /**
31      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
32      */
33     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
34 
35     /**
36      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
37      */
38     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
42      */
43     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
44 
45     /**
46      * @dev Returns the number of tokens in ``owner``'s account.
47      */
48     function balanceOf(address owner) external view returns (uint256 balance);
49 
50     /**
51      * @dev Returns the owner of the `tokenId` token.
52      *
53      * Requirements:
54      *
55      * - `tokenId` must exist.
56      */
57     function ownerOf(uint256 tokenId) external view returns (address owner);
58 
59     /**
60      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
61      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
62      *
63      * Requirements:
64      *
65      * - `from` cannot be the zero address.
66      * - `to` cannot be the zero address.
67      * - `tokenId` token must exist and be owned by `from`.
68      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
69      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
70      *
71      * Emits a {Transfer} event.
72      */
73     function safeTransferFrom(
74         address from,
75         address to,
76         uint256 tokenId
77     ) external;
78 
79     /**
80      * @dev Transfers `tokenId` token from `from` to `to`.
81      *
82      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must be owned by `from`.
89      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(
94         address from,
95         address to,
96         uint256 tokenId
97     ) external;
98 
99     /**
100      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
101      * The approval is cleared when the token is transferred.
102      *
103      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
104      *
105      * Requirements:
106      *
107      * - The caller must own the token or be an approved operator.
108      * - `tokenId` must exist.
109      *
110      * Emits an {Approval} event.
111      */
112     function approve(address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Returns the account approved for `tokenId` token.
116      *
117      * Requirements:
118      *
119      * - `tokenId` must exist.
120      */
121     function getApproved(uint256 tokenId) external view returns (address operator);
122 
123     /**
124      * @dev Approve or remove `operator` as an operator for the caller.
125      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
126      *
127      * Requirements:
128      *
129      * - The `operator` cannot be the caller.
130      *
131      * Emits an {ApprovalForAll} event.
132      */
133     function setApprovalForAll(address operator, bool _approved) external;
134 
135     /**
136      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
137      *
138      * See {setApprovalForAll}
139      */
140     function isApprovedForAll(address owner, address operator) external view returns (bool);
141 
142     /**
143      * @dev Safely transfers `tokenId` token from `from` to `to`.
144      *
145      * Requirements:
146      *
147      * - `from` cannot be the zero address.
148      * - `to` cannot be the zero address.
149      * - `tokenId` token must exist and be owned by `from`.
150      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
152      *
153      * Emits a {Transfer} event.
154      */
155     function safeTransferFrom(
156         address from,
157         address to,
158         uint256 tokenId,
159         bytes calldata data
160     ) external;
161 }
162 
163 /**
164  * @dev Interface of the ERC20 standard as defined in the EIP.
165  */
166 interface IERC20 {
167     function totalSupply() external view returns (uint256);
168 
169     function balanceOf(address account) external view returns (uint256);
170 
171     function transfer(address recipient, uint256 amount) external returns (bool);
172 
173     function allowance(address owner, address spender) external view returns (uint256);
174 
175     function approve(address spender, uint256 amount) external returns (bool);
176 
177     function transferFrom(
178         address sender,
179         address recipient,
180         uint256 amount
181     ) external returns (bool);
182 
183     function burn(uint256 burnQuantity) external returns (bool);
184 
185     event Transfer(address indexed from, address indexed to, uint256 value);
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 /**
190  * @dev String operations.
191  */
192 library Strings {
193     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
194 
195     /**
196      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
197      */
198     function toString(uint256 value) internal pure returns (string memory) {
199         // Inspired by OraclizeAPI's implementation - MIT licence
200         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
201 
202         if (value == 0) {
203             return "0";
204         }
205         uint256 temp = value;
206         uint256 digits;
207         while (temp != 0) {
208             digits++;
209             temp /= 10;
210         }
211         bytes memory buffer = new bytes(digits);
212         while (value != 0) {
213             digits -= 1;
214             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
215             value /= 10;
216         }
217         return string(buffer);
218     }
219 
220     /**
221      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
222      */
223     function toHexString(uint256 value) internal pure returns (string memory) {
224         if (value == 0) {
225             return "0x00";
226         }
227         uint256 temp = value;
228         uint256 length = 0;
229         while (temp != 0) {
230             length++;
231             temp >>= 8;
232         }
233         return toHexString(value, length);
234     }
235 
236     /**
237      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
238      */
239     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
240         bytes memory buffer = new bytes(2 * length + 2);
241         buffer[0] = "0";
242         buffer[1] = "x";
243         for (uint256 i = 2 * length + 1; i > 1; --i) {
244             buffer[i] = _HEX_SYMBOLS[value & 0xf];
245             value >>= 4;
246         }
247         require(value == 0, "Strings: hex length insufficient");
248         return string(buffer);
249     }
250 }
251 
252 /*
253  * @dev Provides information about the current execution context, including the
254  * sender of the transaction and its data. While these are generally available
255  * via msg.sender and msg.data, they should not be accessed in such a direct
256  * manner, since when dealing with meta-transactions the account sending and
257  * paying for execution may not be the actual sender (as far as an application
258  * is concerned).
259  *
260  * This contract is only required for intermediate, library-like contracts.
261  */
262 abstract contract Context {
263     function _msgSender() internal view virtual returns (address) {
264         return msg.sender;
265     }
266 
267     function _msgData() internal view virtual returns (bytes calldata) {
268         return msg.data;
269     }
270 }
271 
272 /**
273  * @dev Contract module which provides a basic access control mechanism, where
274  * there is an account (an owner) that can be granted exclusive access to
275  * specific functions.
276  *
277  * By default, the owner account will be the one that deploys the contract. This
278  * can later be changed with {transferOwnership}.
279  *
280  * This module is used through inheritance. It will make available the modifier
281  * `onlyDeployer`, which can be applied to your functions to restrict their use to
282  * the owner.
283  */
284 abstract contract Ownable is Context {
285     address private _owner;
286 
287     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
288 
289     /**
290      * @dev Initializes the contract setting the deployer as the initial owner.
291      */
292     constructor() {
293         _setOwner(_msgSender());
294     }
295 
296     /**
297      * @dev Returns the address of the current owner.
298      */
299     function owner() public view virtual returns (address) {
300         return _owner;
301     }
302 
303     /**
304      * @dev Throws if called by any account other than the owner.
305      */
306     modifier onlyDeployer() {
307         require(owner() == _msgSender(), "Ownable: caller is not the owner");
308         _;
309     }
310 
311     /**
312      * @dev Leaves the contract without owner. It will not be possible to call
313      * `onlyDeployer` functions anymore. Can only be called by the current owner.
314      *
315      * NOTE: Renouncing ownership will leave the contract without an owner,
316      * thereby removing any functionality that is only available to the owner.
317      */
318     function renounceOwnership() public virtual onlyDeployer {
319         _setOwner(address(0));
320     }
321 
322     /**
323      * @dev Transfers ownership of the contract to a new account (`newOwner`).
324      * Can only be called by the current owner.
325      */
326     function transferOwnership(address newOwner) public virtual onlyDeployer {
327         require(newOwner != address(0), "Ownable: new owner is the zero address");
328         _setOwner(newOwner);
329     }
330 
331     function _setOwner(address newOwner) private {
332         address oldOwner = _owner;
333         _owner = newOwner;
334         emit OwnershipTransferred(oldOwner, newOwner);
335     }
336 }
337 
338 /**
339  * @dev Contract module that helps prevent reentrant calls to a function.
340  *
341  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
342  * available, which can be applied to functions to make sure there are no nested
343  * (reentrant) calls to them.
344  *
345  * Note that because there is a single `nonReentrant` guard, functions marked as
346  * `nonReentrant` may not call one another. This can be worked around by making
347  * those functions `private`, and then adding `external` `nonReentrant` entry
348  * points to them.
349  *
350  * TIP: If you would like to learn more about reentrancy and alternative ways
351  * to protect against it, check out our blog post
352  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
353  */
354 abstract contract ReentrancyGuard {
355     // Booleans are more expensive than uint256 or any type that takes up a full
356     // word because each write operation emits an extra SLOAD to first read the
357     // slot's contents, replace the bits taken up by the boolean, and then write
358     // back. This is the compiler's defense against contract upgrades and
359     // pointer aliasing, and it cannot be disabled.
360 
361     // The values being non-zero value makes deployment a bit more expensive,
362     // but in exchange the refund on every call to nonReentrant will be lower in
363     // amount. Since refunds are capped to a percentage of the total
364     // transaction's gas, it is best to keep them low in cases like this one, to
365     // increase the likelihood of the full refund coming into effect.
366     uint256 private constant _NOT_ENTERED = 1;
367     uint256 private constant _ENTERED = 2;
368 
369     uint256 private _status;
370 
371     constructor() {
372         _status = _NOT_ENTERED;
373     }
374 
375     /**
376      * @dev Prevents a contract from calling itself, directly or indirectly.
377      * Calling a `nonReentrant` function from another `nonReentrant`
378      * function is not supported. It is possible to prevent this from happening
379      * by making the `nonReentrant` function external, and make it call a
380      * `private` function that does the actual work.
381      */
382     modifier nonReentrant() {
383         // On the first call to nonReentrant, _notEntered will be true
384         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
385 
386         // Any calls to nonReentrant after this point will fail
387         _status = _ENTERED;
388 
389         _;
390 
391         // By storing the original value once again, a refund is triggered (see
392         // https://eips.ethereum.org/EIPS/eip-2200)
393         _status = _NOT_ENTERED;
394     }
395 }
396 
397 /**
398  * @title ERC721 token receiver interface
399  * @dev Interface for any contract that wants to support safeTransfers
400  * from ERC721 asset contracts.
401  */
402 interface IERC721Receiver {
403     /**
404      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
405      * by `operator` from `from`, this function is called.
406      *
407      * It must return its Solidity selector to confirm the token transfer.
408      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
409      *
410      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
411      */
412     function onERC721Received(
413         address operator,
414         address from,
415         uint256 tokenId,
416         bytes calldata data
417     ) external returns (bytes4);
418 }
419 
420 /**
421  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
422  * @dev See https://eips.ethereum.org/EIPS/eip-721
423  */
424 interface IERC721Metadata is IERC721 {
425     /**
426      * @dev Returns the token collection name.
427      */
428     function name() external view returns (string memory);
429 
430     /**
431      * @dev Returns the token collection symbol.
432      */
433     function symbol() external view returns (string memory);
434 
435     /**
436      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
437      */
438     function tokenURI(uint256 tokenId) external view returns (string memory);
439 }
440 
441 /**
442  * @dev Collection of functions related to the address type
443  */
444 library Address {
445     /**
446      * @dev Returns true if `account` is a contract.
447      *
448      * [IMPORTANT]
449      * ====
450      * It is unsafe to assume that an address for which this function returns
451      * false is an externally-owned account (EOA) and not a contract.
452      *
453      * Among others, `isContract` will return false for the following
454      * types of addresses:
455      *
456      *  - an externally-owned account
457      *  - a contract in construction
458      *  - an address where a contract will be created
459      *  - an address where a contract lived, but was destroyed
460      * ====
461      */
462     function isContract(address account) internal view returns (bool) {
463         // This method relies on extcodesize, which returns 0 for contracts in
464         // construction, since the code is only stored at the end of the
465         // constructor execution.
466 
467         uint256 size;
468         assembly {
469             size := extcodesize(account)
470         }
471         return size > 0;
472     }
473 
474     /**
475      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
476      * `recipient`, forwarding all available gas and reverting on errors.
477      *
478      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
479      * of certain opcodes, possibly making contracts go over the 2300 gas limit
480      * imposed by `transfer`, making them unable to receive funds via
481      * `transfer`. {sendValue} removes this limitation.
482      *
483      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
484      *
485      * IMPORTANT: because control is transferred to `recipient`, care must be
486      * taken to not create reentrancy vulnerabilities. Consider using
487      * {ReentrancyGuard} or the
488      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
489      */
490     function sendValue(address payable recipient, uint256 amount) internal {
491         require(address(this).balance >= amount, "Address: insufficient balance");
492 
493         (bool success, ) = recipient.call{value: amount}("");
494         require(success, "Address: unable to send value, recipient may have reverted");
495     }
496 
497     /**
498      * @dev Performs a Solidity function call using a low level `call`. A
499      * plain `call` is an unsafe replacement for a function call: use this
500      * function instead.
501      *
502      * If `target` reverts with a revert reason, it is bubbled up by this
503      * function (like regular Solidity function calls).
504      *
505      * Returns the raw returned data. To convert to the expected return value,
506      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
507      *
508      * Requirements:
509      *
510      * - `target` must be a contract.
511      * - calling `target` with `data` must not revert.
512      *
513      * _Available since v3.1._
514      */
515     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
516         return functionCall(target, data, "Address: low-level call failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
521      * `errorMessage` as a fallback revert reason when `target` reverts.
522      *
523      * _Available since v3.1._
524      */
525     function functionCall(
526         address target,
527         bytes memory data,
528         string memory errorMessage
529     ) internal returns (bytes memory) {
530         return functionCallWithValue(target, data, 0, errorMessage);
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
535      * but also transferring `value` wei to `target`.
536      *
537      * Requirements:
538      *
539      * - the calling contract must have an ETH balance of at least `value`.
540      * - the called Solidity function must be `payable`.
541      *
542      * _Available since v3.1._
543      */
544     function functionCallWithValue(
545         address target,
546         bytes memory data,
547         uint256 value
548     ) internal returns (bytes memory) {
549         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
554      * with `errorMessage` as a fallback revert reason when `target` reverts.
555      *
556      * _Available since v3.1._
557      */
558     function functionCallWithValue(
559         address target,
560         bytes memory data,
561         uint256 value,
562         string memory errorMessage
563     ) internal returns (bytes memory) {
564         require(address(this).balance >= value, "Address: insufficient balance for call");
565         require(isContract(target), "Address: call to non-contract");
566 
567         (bool success, bytes memory returndata) = target.call{value: value}(data);
568         return _verifyCallResult(success, returndata, errorMessage);
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
573      * but performing a static call.
574      *
575      * _Available since v3.3._
576      */
577     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
578         return functionStaticCall(target, data, "Address: low-level static call failed");
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
583      * but performing a static call.
584      *
585      * _Available since v3.3._
586      */
587     function functionStaticCall(
588         address target,
589         bytes memory data,
590         string memory errorMessage
591     ) internal view returns (bytes memory) {
592         require(isContract(target), "Address: static call to non-contract");
593 
594         (bool success, bytes memory returndata) = target.staticcall(data);
595         return _verifyCallResult(success, returndata, errorMessage);
596     }
597 
598     /**
599      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
600      * but performing a delegate call.
601      *
602      * _Available since v3.4._
603      */
604     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
605         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
610      * but performing a delegate call.
611      *
612      * _Available since v3.4._
613      */
614     function functionDelegateCall(
615         address target,
616         bytes memory data,
617         string memory errorMessage
618     ) internal returns (bytes memory) {
619         require(isContract(target), "Address: delegate call to non-contract");
620 
621         (bool success, bytes memory returndata) = target.delegatecall(data);
622         return _verifyCallResult(success, returndata, errorMessage);
623     }
624 
625     function _verifyCallResult(
626         bool success,
627         bytes memory returndata,
628         string memory errorMessage
629     ) private pure returns (bytes memory) {
630         if (success) {
631             return returndata;
632         } else {
633             // Look for revert reason and bubble it up if present
634             if (returndata.length > 0) {
635                 // The easiest way to bubble the revert reason is using memory via assembly
636 
637                 assembly {
638                     let returndata_size := mload(returndata)
639                     revert(add(32, returndata), returndata_size)
640                 }
641             } else {
642                 revert(errorMessage);
643             }
644         }
645     }
646 }
647 
648 /**
649  * @dev Implementation of the {IERC165} interface.
650  *
651  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
652  * for the additional interface id that will be supported. For example:
653  *
654  * ```solidity
655  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
656  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
657  * }
658  * ```
659  *
660  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
661  */
662 abstract contract ERC165 is IERC165 {
663     /**
664      * @dev See {IERC165-supportsInterface}.
665      */
666     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
667         return interfaceId == type(IERC165).interfaceId;
668     }
669 }
670 
671 /**
672  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
673  * the Metadata extension, but not including the Enumerable extension, which is available separately as
674  * {ERC721Enumerable}.
675  */
676 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
677     using Address for address;
678     using Strings for uint256;
679 
680     // Token name
681     string private _name;
682 
683     // Token symbol
684     string private _symbol;
685 
686     // Mapping from token ID to owner address
687     mapping(uint256 => address) private _owners;
688 
689     // Mapping owner address to token count
690     mapping(address => uint256) private _balances;
691 
692     // Mapping from token ID to approved address
693     mapping(uint256 => address) private _tokenApprovals;
694 
695     // Mapping from owner to operator approvals
696     mapping(address => mapping(address => bool)) private _operatorApprovals;
697 
698     /**
699      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
700      */
701     constructor(string memory name_, string memory symbol_) {
702         _name = name_;
703         _symbol = symbol_;
704     }
705 
706     /**
707      * @dev See {IERC165-supportsInterface}.
708      */
709     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
710         return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || super.supportsInterface(interfaceId);
711     }
712 
713     /**
714      * @dev See {IERC721-balanceOf}.
715      */
716     function balanceOf(address owner) public view virtual override returns (uint256) {
717         require(owner != address(0), "ERC721: balance query for the zero address");
718         return _balances[owner];
719     }
720 
721     /**
722      * @dev See {IERC721-ownerOf}.
723      */
724     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
725         address owner = _owners[tokenId];
726         require(owner != address(0), "ERC721: owner query for nonexistent token");
727         return owner;
728     }
729 
730     /**
731      * @dev See {IERC721Metadata-name}.
732      */
733     function name() public view virtual override returns (string memory) {
734         return _name;
735     }
736 
737     /**
738      * @dev See {IERC721Metadata-symbol}.
739      */
740     function symbol() public view virtual override returns (string memory) {
741         return _symbol;
742     }
743 
744     /**
745      * @dev See {IERC721Metadata-tokenURI}.
746      */
747     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
748         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
749 
750         string memory baseURI = _baseURI();
751         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
752     }
753 
754     /**
755      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
756      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
757      * by default, can be overriden in child contracts.
758      */
759     function _baseURI() internal view virtual returns (string memory) {
760         return "";
761     }
762 
763     /**
764      * @dev See {IERC721-approve}.
765      */
766     function approve(address to, uint256 tokenId) public virtual override {
767         address owner = ERC721.ownerOf(tokenId);
768         require(to != owner, "ERC721: approval to current owner");
769 
770         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), "ERC721: approve caller is not owner nor approved for all");
771 
772         _approve(to, tokenId);
773     }
774 
775     /**
776      * @dev See {IERC721-getApproved}.
777      */
778     function getApproved(uint256 tokenId) public view virtual override returns (address) {
779         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
780 
781         return _tokenApprovals[tokenId];
782     }
783 
784     /**
785      * @dev See {IERC721-setApprovalForAll}.
786      */
787     function setApprovalForAll(address operator, bool approved) public virtual override {
788         require(operator != _msgSender(), "ERC721: approve to caller");
789 
790         _operatorApprovals[_msgSender()][operator] = approved;
791         emit ApprovalForAll(_msgSender(), operator, approved);
792     }
793 
794     /**
795      * @dev See {IERC721-isApprovedForAll}.
796      */
797     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
798         return _operatorApprovals[owner][operator];
799     }
800 
801     /**
802      * @dev See {IERC721-transferFrom}.
803      */
804     function transferFrom(
805         address from,
806         address to,
807         uint256 tokenId
808     ) public virtual override {
809         //solhint-disable-next-line max-line-length
810         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
811 
812         _transfer(from, to, tokenId);
813     }
814 
815     /**
816      * @dev See {IERC721-safeTransferFrom}.
817      */
818     function safeTransferFrom(
819         address from,
820         address to,
821         uint256 tokenId
822     ) public virtual override {
823         safeTransferFrom(from, to, tokenId, "");
824     }
825 
826     /**
827      * @dev See {IERC721-safeTransferFrom}.
828      */
829     function safeTransferFrom(
830         address from,
831         address to,
832         uint256 tokenId,
833         bytes memory _data
834     ) public virtual override {
835         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
836         _safeTransfer(from, to, tokenId, _data);
837     }
838 
839     /**
840      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
841      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
842      *
843      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
844      *
845      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
846      * implement alternative mechanisms to perform token transfer, such as signature-based.
847      *
848      * Requirements:
849      *
850      * - `from` cannot be the zero address.
851      * - `to` cannot be the zero address.
852      * - `tokenId` token must exist and be owned by `from`.
853      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
854      *
855      * Emits a {Transfer} event.
856      */
857     function _safeTransfer(
858         address from,
859         address to,
860         uint256 tokenId,
861         bytes memory _data
862     ) internal virtual {
863         _transfer(from, to, tokenId);
864         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
865     }
866 
867     /**
868      * @dev Returns whether `tokenId` exists.
869      *
870      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
871      *
872      * Tokens start existing when they are minted (`_mint`),
873      * and stop existing when they are burned (`_burn`).
874      */
875     function _exists(uint256 tokenId) internal view virtual returns (bool) {
876         return _owners[tokenId] != address(0);
877     }
878 
879     /**
880      * @dev Returns whether `spender` is allowed to manage `tokenId`.
881      *
882      * Requirements:
883      *
884      * - `tokenId` must exist.
885      */
886     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
887         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
888         address owner = ERC721.ownerOf(tokenId);
889         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
890     }
891 
892     /**
893      * @dev Safely mints `tokenId` and transfers it to `to`.
894      *
895      * Requirements:
896      *
897      * - `tokenId` must not exist.
898      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
899      *
900      * Emits a {Transfer} event.
901      */
902     function _safeMint(address to, uint256 tokenId) internal virtual {
903         _safeMint(to, tokenId, "");
904     }
905 
906     /**
907      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
908      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
909      */
910     function _safeMint(
911         address to,
912         uint256 tokenId,
913         bytes memory _data
914     ) internal virtual {
915         _mint(to, tokenId);
916         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
917     }
918 
919     /**
920      * @dev Mints `tokenId` and transfers it to `to`.
921      *
922      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
923      *
924      * Requirements:
925      *
926      * - `tokenId` must not exist.
927      * - `to` cannot be the zero address.
928      *
929      * Emits a {Transfer} event.
930      */
931     function _mint(address to, uint256 tokenId) internal virtual {
932         require(to != address(0), "ERC721: mint to the zero address");
933         require(!_exists(tokenId), "ERC721: token already minted");
934 
935         _beforeTokenTransfer(address(0), to, tokenId);
936 
937         _balances[to] += 1;
938         _owners[tokenId] = to;
939 
940         emit Transfer(address(0), to, tokenId);
941     }
942 
943     /**
944      * @dev Destroys `tokenId`.
945      * The approval is cleared when the token is burned.
946      *
947      * Requirements:
948      *
949      * - `tokenId` must exist.
950      *
951      * Emits a {Transfer} event.
952      */
953     function _burn(uint256 tokenId) internal virtual {
954         address owner = ERC721.ownerOf(tokenId);
955 
956         _beforeTokenTransfer(owner, address(0), tokenId);
957 
958         // Clear approvals
959         _approve(address(0), tokenId);
960 
961         _balances[owner] -= 1;
962         delete _owners[tokenId];
963 
964         emit Transfer(owner, address(0), tokenId);
965     }
966 
967     /**
968      * @dev Transfers `tokenId` from `from` to `to`.
969      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
970      *
971      * Requirements:
972      *
973      * - `to` cannot be the zero address.
974      * - `tokenId` token must be owned by `from`.
975      *
976      * Emits a {Transfer} event.
977      */
978     function _transfer(
979         address from,
980         address to,
981         uint256 tokenId
982     ) internal virtual {
983         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
984         require(to != address(0), "ERC721: transfer to the zero address");
985 
986         _beforeTokenTransfer(from, to, tokenId);
987 
988         // Clear approvals from the previous owner
989         _approve(address(0), tokenId);
990 
991         _balances[from] -= 1;
992         _balances[to] += 1;
993         _owners[tokenId] = to;
994 
995         emit Transfer(from, to, tokenId);
996     }
997 
998     /**
999      * @dev Approve `to` to operate on `tokenId`
1000      *
1001      * Emits a {Approval} event.
1002      */
1003     function _approve(address to, uint256 tokenId) internal virtual {
1004         _tokenApprovals[tokenId] = to;
1005         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1006     }
1007 
1008     /**
1009      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1010      * The call is not executed if the target address is not a contract.
1011      *
1012      * @param from address representing the previous owner of the given token ID
1013      * @param to target address that will receive the tokens
1014      * @param tokenId uint256 ID of the token to be transferred
1015      * @param _data bytes optional data to send along with the call
1016      * @return bool whether the call correctly returned the expected magic value
1017      */
1018     function _checkOnERC721Received(
1019         address from,
1020         address to,
1021         uint256 tokenId,
1022         bytes memory _data
1023     ) private returns (bool) {
1024         if (to.isContract()) {
1025             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1026                 return retval == IERC721Receiver(to).onERC721Received.selector;
1027             } catch (bytes memory reason) {
1028                 if (reason.length == 0) {
1029                     revert("ERC721: transfer to non ERC721Receiver implementer");
1030                 } else {
1031                     assembly {
1032                         revert(add(32, reason), mload(reason))
1033                     }
1034                 }
1035             }
1036         } else {
1037             return true;
1038         }
1039     }
1040 
1041     /**
1042      * @dev Hook that is called before any token transfer. This includes minting
1043      * and burning.
1044      *
1045      * Calling conditions:
1046      *
1047      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1048      * transferred to `to`.
1049      * - When `from` is zero, `tokenId` will be minted for `to`.
1050      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1051      * - `from` and `to` are never both zero.
1052      *
1053      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1054      */
1055     function _beforeTokenTransfer(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) internal virtual {}
1060 }
1061 
1062 /**
1063  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1064  * @dev See https://eips.ethereum.org/EIPS/eip-721
1065  */
1066 interface IERC721Enumerable is IERC721 {
1067     /**
1068      * @dev Returns the total amount of tokens stored by the contract.
1069      */
1070     function totalSupply() external view returns (uint256);
1071 
1072     /**
1073      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1074      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1075      */
1076     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1077 
1078     /**
1079      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1080      * Use along with {totalSupply} to enumerate all tokens.
1081      */
1082     function tokenByIndex(uint256 index) external view returns (uint256);
1083 }
1084 
1085 /**
1086  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1087  * enumerability of all the token ids in the contract as well as all token ids owned by each
1088  * account.
1089  */
1090 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1091     // Mapping from owner to list of owned token IDs
1092     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1093 
1094     // Mapping from token ID to index of the owner tokens list
1095     mapping(uint256 => uint256) private _ownedTokensIndex;
1096 
1097     // Array with all token ids, used for enumeration
1098     uint256[] private _allTokens;
1099 
1100     // Mapping from token id to position in the allTokens array
1101     mapping(uint256 => uint256) private _allTokensIndex;
1102 
1103     /**
1104      * @dev See {IERC165-supportsInterface}.
1105      */
1106     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1107         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1108     }
1109 
1110     /**
1111      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1112      */
1113     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1114         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1115         return _ownedTokens[owner][index];
1116     }
1117 
1118     /**
1119      * @dev See {IERC721Enumerable-totalSupply}.
1120      */
1121     function totalSupply() public view virtual override returns (uint256) {
1122         return _allTokens.length;
1123     }
1124 
1125     /**
1126      * @dev See {IERC721Enumerable-tokenByIndex}.
1127      */
1128     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1129         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1130         return _allTokens[index];
1131     }
1132 
1133     /**
1134      * @dev Hook that is called before any token transfer. This includes minting
1135      * and burning.
1136      *
1137      * Calling conditions:
1138      *
1139      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1140      * transferred to `to`.
1141      * - When `from` is zero, `tokenId` will be minted for `to`.
1142      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1143      * - `from` cannot be the zero address.
1144      * - `to` cannot be the zero address.
1145      *
1146      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1147      */
1148     function _beforeTokenTransfer(
1149         address from,
1150         address to,
1151         uint256 tokenId
1152     ) internal virtual override {
1153         super._beforeTokenTransfer(from, to, tokenId);
1154 
1155         if (from == address(0)) {
1156             _addTokenToAllTokensEnumeration(tokenId);
1157         } else if (from != to) {
1158             _removeTokenFromOwnerEnumeration(from, tokenId);
1159         }
1160         if (to == address(0)) {
1161             _removeTokenFromAllTokensEnumeration(tokenId);
1162         } else if (to != from) {
1163             _addTokenToOwnerEnumeration(to, tokenId);
1164         }
1165     }
1166 
1167     /**
1168      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1169      * @param to address representing the new owner of the given token ID
1170      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1171      */
1172     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1173         uint256 length = ERC721.balanceOf(to);
1174         _ownedTokens[to][length] = tokenId;
1175         _ownedTokensIndex[tokenId] = length;
1176     }
1177 
1178     /**
1179      * @dev Private function to add a token to this extension's token tracking data structures.
1180      * @param tokenId uint256 ID of the token to be added to the tokens list
1181      */
1182     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1183         _allTokensIndex[tokenId] = _allTokens.length;
1184         _allTokens.push(tokenId);
1185     }
1186 
1187     /**
1188      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1189      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1190      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1191      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1192      * @param from address representing the previous owner of the given token ID
1193      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1194      */
1195     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1196         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1197         // then delete the last slot (swap and pop).
1198 
1199         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1200         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1201 
1202         // When the token to delete is the last token, the swap operation is unnecessary
1203         if (tokenIndex != lastTokenIndex) {
1204             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1205 
1206             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1207             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1208         }
1209 
1210         // This also deletes the contents at the last position of the array
1211         delete _ownedTokensIndex[tokenId];
1212         delete _ownedTokens[from][lastTokenIndex];
1213     }
1214 
1215     /**
1216      * @dev Private function to remove a token from this extension's token tracking data structures.
1217      * This has O(1) time complexity, but alters the order of the _allTokens array.
1218      * @param tokenId uint256 ID of the token to be removed from the tokens list
1219      */
1220     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1221         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1222         // then delete the last slot (swap and pop).
1223 
1224         uint256 lastTokenIndex = _allTokens.length - 1;
1225         uint256 tokenIndex = _allTokensIndex[tokenId];
1226 
1227         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1228         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1229         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1230         uint256 lastTokenId = _allTokens[lastTokenIndex];
1231 
1232         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1233         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1234 
1235         // This also deletes the contents at the last position of the array
1236         delete _allTokensIndex[tokenId];
1237         _allTokens.pop();
1238     }
1239 }
1240 
1241 contract Mooncake is ERC721Enumerable, ReentrancyGuard, Ownable {
1242     string[] public slot0 = [
1243         "Almond paste ",
1244         "Azuki bean paste ",
1245         unicode"Açaí coconut custard ",
1246         "Baileys custard ",
1247         "Baked sweet potato ",
1248         "Black sesame paste ",
1249         "Blackberry custard ",
1250         "Blueberry custard ",
1251         "Champagne ganache ",
1252         unicode"Chestnut purée ",
1253         "Chocolate peanut butter ",
1254         "Classic lava custard ",
1255         "Classic lotus paste double salted egg yolk ",
1256         "Classic red bean paste double salted egg yolk ",
1257         "Coco tiramisu ",
1258         "Cream custard ",
1259         "Crystal flower ",
1260         "Deluxe abalone ",
1261         unicode"Deluxe bird’s nest ",
1262         "Deluxe caviar and truffle ",
1263         "Deluxe foie gras ",
1264         "Deluxe matsutake mushroom ",
1265         "Egg custard ",
1266         "Ferrero Rocher chocolate ",
1267         "Five kernel with roast pork ",
1268         "Fruit and vegetable ",
1269         "Ginseng lotus paste ",
1270         "Golden lotus paste ",
1271         "Golden lotus paste double salted egg yolk ",
1272         "Golden lotus paste triple salted egg yolk ",
1273         "Golden lotus paste with salted egg yolk ",
1274         "Green tea ",
1275         "Green tea mung bean ",
1276         "Ham and nut ",
1277         "Hazelnut cream ",
1278         "Jelly grass custard ",
1279         "Lava caramel macchiato ",
1280         "Lava coffee custard ",
1281         "Lava custard salted egg yolk ",
1282         "Limited-edition Musang King durian with salted egg yolk ",
1283         "Limited-edition preserved eggs and pickled ginger ",
1284         "Limited-edition seafood medley ",
1285         "Spicy chicken floss ",
1286         "Lychee Martini custard ",
1287         "Lychee with lime marshmallow ",
1288         "Mango mousse ",
1289         "Mango pomelo sago ",
1290         "Matcha red bean ",
1291         "Matcha red bean with salted egg yolk ",
1292         "Mixed berry custard ",
1293         "Mixed nuts ",
1294         "Mountain hawthorn ",
1295         "Mung bean paste ",
1296         "Munk bean paste double salted egg yolk ",
1297         "Munk bean paste single salted egg yolk ",
1298         "Musang King durian ",
1299         "Mysterious preserved eggs and pickled ginger ",
1300         "Nutella lava ",
1301         "Pandan coconut ",
1302         "Pandan coconut single yolk ",
1303         "Peanut butter and jelly ",
1304         "Pineapple jam ",
1305         "Plum blossom ",
1306         "Purple sweet potato ",
1307         "Purple yam ",
1308         "Red bean chestnut ",
1309         "Red bean matcha ",
1310         "Red bean paste ",
1311         "Red bean paste double salted egg yolk ",
1312         "Red bean paste single salted egg yolk ",
1313         "Red date ",
1314         "Red date lotus seed paste ",
1315         "Roasted chestnut ",
1316         "Sago chia seeds jelly ",
1317         "Strawberry jelly ",
1318         "Sweet bean paste double salted egg yolk ",
1319         "Taro paste ",
1320         "Taro paste with salted egg yolk ",
1321         "Traditional five kernel ",
1322         "Traditional jujube paste ",
1323         "Traditional lotus paste ",
1324         "Traditional sweet bean paste ",
1325         "Walnut and fig flavored egg custard ",
1326         "Wasabi bean ",
1327         "White lotus paste ",
1328         "White lotus paste double salted egg yolk ",
1329         "White peach Bellini ",
1330         "Wisteria blossom "
1331     ];
1332 
1333     string[] public slot1 = ["diamond-shaped ", "doge-shaped ", "eth-shaped ", "gluten-free ", "goldfish-shaped ", "heart-shaped ", "lotus-shaped ", "low-fat ", "low-sugar ", "magnolia-shaped ", "vegan "];
1334 
1335     string[] public slot2 = ["mini-", "mochi-", "snow-skin ", "ice cream ", "cream cheese ", "extra large ", "flaky crust "];
1336 
1337     string public STRING_MOONCAKE = "mooncake ";
1338 
1339     string public STRING_PRE_SLOT3 = "sprinkled with ";
1340 
1341     string[] public slot3 = [
1342         "50-year dried tangerine peel ",
1343         "almond flakes ",
1344         "bonito flakes ",
1345         "candied bacon bits ",
1346         "candied cacao nibs ",
1347         "caramel bits ",
1348         "chocolate peppermint crackle ",
1349         "cinnamon and brown sugar ",
1350         "cocoa powder ",
1351         "crunched coffee bean ",
1352         "crunchy salted caramel bits ",
1353         "fresh fruits ",
1354         "fruit confit ",
1355         "24-karat edible gold flakes ",
1356         "lotus seeds of the year ",
1357         "onion confit ",
1358         "pink Himalayan salt flakes ",
1359         "tangy lemon crinkle ",
1360         "tangy pomegranate seeds ",
1361         "toasted coconut flakes ",
1362         "toasted pistachios ",
1363         "toasted sesame seeds ",
1364         "volcanic salt caramel crisps ",
1365         "white truffle shavings "
1366     ];
1367 
1368     string public STRING_PRE_SLOT4 = "accompanied with a cup of ";
1369 
1370     string[] public slot4 = [
1371         "aged Pu'er tea ",
1372         "chamomile flowers tea ",
1373         "Darjeeling tea ",
1374         "Dragon Well green tea ",
1375         "Matcha green tea ",
1376         "jasmine green tea ",
1377         "Keemun black tea ",
1378         "Lapsang Souchong black tea ",
1379         "Moroccan mint tea ",
1380         "Osmanthus oolong tea ",
1381         "pomegranate green tea ",
1382         "roasted barley tea ",
1383         "Silver Needle white tea ",
1384         "turmeric ginger herbal tea ",
1385         "vanilla chai tea ",
1386         "white peony tea "
1387     ];
1388 
1389     string public STRING_PRE_SLOT5 = "presented ";
1390 
1391     string[] public slot5 = [
1392         "in a bento lunch box ",
1393         "in a biofriendly edible carton ",
1394         "in a Chinese takeout box ",
1395         "in a decorative paper wrap with origami finish ",
1396         "in a lantern-shaped LED box ",
1397         "in a lavish deep red chest ",
1398         "in a luxury sterling silver chest ",
1399         "in a metallic turquoise box ",
1400         "in a non-fungible token ",
1401         "in a stainless steel box ",
1402         "in a Swarovski crystal case ",
1403         "in a wicker picnic basket ",
1404         "in an elaborate box with jeweled clasp ",
1405         "on a biodegradable palm leaf wooden plate ",
1406         "on a fine bone china dish ",
1407         "on a jumbo pearl oyster shell ",
1408         "on a Qing dynasty porcelain plate ",
1409         "on a textured blue ceramic tray ",
1410         "on a vintage French oyster plate ",
1411         "on a vintage stoneware tray ",
1412         "on a woven bamboo placemat ",
1413         "on an antique rosewood tray "
1414     ];
1415 
1416     mapping(uint256 => uint256) public tokenTransferCounts; // This is the level a token can be upgraded to
1417     mapping(uint256 => uint256) public tokenLevels; // This is the current level of a token
1418 
1419     uint256 public SALES_START_TIMESTAMP = 1631880900; // 2021-09-17 12:15:00 UTC
1420     uint256 public CLAIM_START_TIMESTAMP = 1631880000; // 2021-09-17 12:00:00 UTC
1421 
1422     uint256 public MINT_FEE = 0.01 ether;
1423 
1424     uint256 public maxNftSupply = 1508;
1425     uint256 public maxFreeMints = 888;
1426 
1427     uint256 public numFreeMints;
1428     bool public contractSealed;
1429 
1430     event TokenUpgraded(uint256 indexed tokenId, uint256 newLevel, uint256 oldLevel);
1431     event AffiliateMint(uint256 indexed tokenId, address affiliate);
1432 
1433     /**
1434      * @dev Track token transfers / upgrade potentials
1435      */
1436     function _beforeTokenTransfer(
1437         address from,
1438         address to,
1439         uint256 tokenId
1440     ) internal override {
1441         super._beforeTokenTransfer(from, to, tokenId);
1442 
1443         // Skip freshly minted tokens to save gas
1444         if (from != address(0)) {
1445             tokenTransferCounts[tokenId] += 1;
1446         }
1447     }
1448 
1449     /**
1450      * @dev Upgrade a token if it's ready
1451      */
1452     function upgradeToken(uint256 tokenId) external {
1453         require(_exists(tokenId), "Update nonexistent token");
1454         require(_msgSender() == ERC721.ownerOf(tokenId), "Must own token for upgrade");
1455 
1456         require(tokenLevels[tokenId] < tokenTransferCounts[tokenId], "Token is not ready for upgrade");
1457         uint256 oldLevel = tokenLevels[tokenId];
1458         uint256 newLevel = tokenTransferCounts[tokenId];
1459 
1460         tokenLevels[tokenId] = newLevel;
1461 
1462         emit TokenUpgraded(tokenId, newLevel, oldLevel);
1463     }
1464 
1465     /**
1466      * @dev Return the slot id for each text chunk. Useful for translations.
1467      */
1468     function getMooncakeTextSlotIds(uint256 tokenId, uint256 level) public view returns (uint8[6] memory) {
1469         uint8[6] memory slotIds;
1470 
1471         //generate a sequence of pseudo random numbers, seeded by id
1472         uint32[15] memory seq;
1473         uint256 r = tokenId + 20000;
1474         for (uint256 i = 0; i < 15; i++) {
1475             r = (r * 16807) % 2147483647; //advance PRNG
1476             seq[i] = uint32(r);
1477         }
1478         uint16 sp = 0;
1479 
1480         uint8[5] memory slotLevelDefaults = [60, 90, 100, 100, 100];
1481         uint8[5] memory slotLevels;
1482 
1483         // Starting with 2 slots (on top of slot0)
1484         uint256 maxSlots = 2;
1485         // Freshly minted token is at level 0
1486         if (level > 0) {
1487             maxSlots = 2 + level;
1488         }
1489         if (maxSlots > 5) {
1490             maxSlots = 5;
1491         }
1492 
1493         for (uint256 i = 0; i < maxSlots; i++) {
1494             uint256 slotNum = seq[sp++] % 5;
1495             while (slotLevels[slotNum] != 0) {
1496                 slotNum = (slotNum + 1) % 5;
1497             }
1498             slotLevels[slotNum] = slotLevelDefaults[slotNum];
1499         }
1500 
1501         // Slot checks used up some random numbers
1502         sp = 5;
1503         uint16 f = 0;
1504 
1505         slotIds[0] = uint8(seq[0] % slot0.length);
1506 
1507         f = uint16(seq[sp++] % 100);
1508         if (f < slotLevels[0]) {
1509             slotIds[1] = uint8(seq[sp] % slot1.length);
1510         } else {
1511             slotIds[1] = 255;
1512         }
1513 
1514         f = uint16(seq[sp++] % 100);
1515         if (f < slotLevels[1]) {
1516             slotIds[2] = uint8(seq[sp] % slot2.length);
1517         } else {
1518             slotIds[2] = 255;
1519         }
1520 
1521         f = uint16(seq[sp++] % 100);
1522         if (f < slotLevels[2]) {
1523             slotIds[3] = uint8(seq[sp] % slot3.length);
1524         } else {
1525             slotIds[3] = 255;
1526         }
1527 
1528         f = uint16(seq[sp++] % 100);
1529         if (f < slotLevels[3]) {
1530             slotIds[4] = uint8(seq[sp] % slot4.length);
1531         } else {
1532             slotIds[4] = 255;
1533         }
1534 
1535         f = uint16(seq[sp++] % 100);
1536         if (f < slotLevels[4]) {
1537             slotIds[5] = uint8(seq[sp] % slot5.length);
1538         } else {
1539             slotIds[5] = 255;
1540         }
1541 
1542         return slotIds;
1543     }
1544 
1545     /**
1546      * @dev Return the mooncake text for a given tokenId and its level
1547      */
1548     function getMooncakeTextWithLevel(uint256 tokenId, uint256 level) public view returns (string memory) {
1549         uint8[6] memory slotIds = getMooncakeTextSlotIds(tokenId, level);
1550         string memory output = slot0[slotIds[0]];
1551 
1552         if (slotIds[1] < 255) {
1553             output = string(abi.encodePacked(output, slot1[slotIds[1]]));
1554         }
1555 
1556         if (slotIds[2] < 255) {
1557             output = string(abi.encodePacked(output, slot2[slotIds[2]]));
1558         }
1559 
1560         output = string(abi.encodePacked(output, STRING_MOONCAKE));
1561 
1562         if (slotIds[3] < 255) {
1563             output = string(abi.encodePacked(output, STRING_PRE_SLOT3, slot3[slotIds[3]]));
1564         }
1565 
1566         if (slotIds[4] < 255) {
1567             output = string(abi.encodePacked(output, STRING_PRE_SLOT4, slot4[slotIds[4]]));
1568         }
1569 
1570         if (slotIds[5] < 255) {
1571             output = string(abi.encodePacked(output, STRING_PRE_SLOT5, slot5[slotIds[5]]));
1572         }
1573 
1574         return output;
1575     }
1576 
1577     /**
1578      * @dev Return the mooncake text for a given tokenId
1579      */
1580     function getMooncakeText(uint256 tokenId) public view returns (string memory) {
1581         uint256 tokenLevel = tokenLevels[tokenId];
1582         return getMooncakeTextWithLevel(tokenId, tokenLevel);
1583     }
1584 
1585     /**
1586      * @dev Get token URI at a specified token level
1587      */
1588     function tokenURIWithLevel(uint256 tokenId, uint256 tokenLevel) public view returns (string memory) {
1589         string[17] memory parts;
1590         parts[
1591             0
1592         ] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>foreignObject { fill: black; font-family: "DM Sans", "Open Sans", "Calibri", -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif; font-size: 24px; }</style><rect width="100%" height="100%" fill="';
1593 
1594         if (tokenLevel == 0) {
1595             parts[1] = "#fef2d5";
1596         } else if (tokenLevel == 1) {
1597             parts[1] = "#feecc1";
1598         } else if (tokenLevel == 2) {
1599             parts[1] = "#fde5ae";
1600         } else {
1601             parts[1] = "#fccb2d";
1602         }
1603 
1604         parts[2] = '" /><foreignObject width="300" height="320" x="20" y="20" requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility">';
1605         parts[3] = getMooncakeTextWithLevel(tokenId, tokenLevel);
1606         parts[4] = "</foreignObject></svg>";
1607 
1608         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
1609         string memory json = Base64.encode(
1610             bytes(
1611                 string(
1612                     abi.encodePacked(
1613                         '{"name": "Mooncake #',
1614                         toString(tokenId),
1615                         '", "description": "The Mooncake Gift is a collection of randomized mooncakes generated and stored onchain. The more times a mooncake is gifted, the tastier it becomes. Images are intentionally omitted for others to interpret. Feel free to use these mooncakes in any way you want.", "image": "data:image/svg+xml;base64,',
1616                         Base64.encode(bytes(output)),
1617                         '"}'
1618                     )
1619                 )
1620             )
1621         );
1622         output = string(abi.encodePacked("data:application/json;base64,", json));
1623 
1624         return output;
1625     }
1626 
1627     /**
1628      * @dev Retrieve the current tokenURI (embedded SVG)
1629      */
1630     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1631         uint256 tokenLevel = tokenLevels[tokenId];
1632         return tokenURIWithLevel(tokenId, tokenLevel);
1633     }
1634 
1635     /**
1636      * @dev Mint tokens
1637      */
1638     function mintWithAffiliate(uint256 numberOfNfts, address affiliate) public payable nonReentrant {
1639         // Checks
1640         require(!contractSealed, "Contract sealed");
1641 
1642         require(block.timestamp >= SALES_START_TIMESTAMP, "Not started");
1643 
1644         require(numberOfNfts > 0, "Cannot mint 0 NFTs");
1645         require(numberOfNfts <= 50, "Cannot mint more than 50 in 1 tx");
1646 
1647         uint256 total = totalSupply();
1648         require(total + numberOfNfts <= maxNftSupply, "Sold out");
1649 
1650         require(msg.value == numberOfNfts * MINT_FEE, "Ether value sent is incorrect");
1651 
1652         // Effects
1653         for (uint256 i = 0; i < numberOfNfts; i++) {
1654             uint256 tokenId = total + i;
1655 
1656             _safeMint(_msgSender(), tokenId, "");
1657             if (affiliate != address(0)) {
1658                 emit AffiliateMint(tokenId, affiliate);
1659             }
1660         }
1661     }
1662 
1663     /**
1664      * @dev Mint tokens
1665      */
1666     function mintNfts(uint256 numberOfNfts) external payable {
1667         mintWithAffiliate(numberOfNfts, address(0));
1668     }
1669 
1670     /**
1671      * @dev Claim a free one
1672      */
1673     function claimOneFreeNft() external payable nonReentrant {
1674         // Checks
1675         require(!contractSealed, "Contract sealed");
1676 
1677         require(block.timestamp >= CLAIM_START_TIMESTAMP, "Not started");
1678 
1679         uint256 total = totalSupply();
1680         require(total + 1 <= maxNftSupply, "Sold out");
1681         require(numFreeMints + 1 <= maxFreeMints, "No more free tokens left");
1682 
1683         require(balanceOf(_msgSender()) == 0, "You already have a mooncake. Enjoy it!");
1684 
1685         // Effects
1686         numFreeMints += 1;
1687         _safeMint(_msgSender(), total, "");
1688     }
1689 
1690     /**
1691      * @dev Return detail information about an owner's token (tokenId, current level, potential level, uri)
1692      */
1693     function tokenDetailOfOwnerByIndex(address _owner, uint256 index)
1694         public
1695         view
1696         returns (
1697             uint256,
1698             uint256,
1699             uint256,
1700             string memory
1701         )
1702     {
1703         uint256 tokenId = tokenOfOwnerByIndex(_owner, index);
1704         uint256 tokenLevel = tokenLevels[tokenId];
1705         uint256 tokenTransferCount = tokenTransferCounts[tokenId];
1706         string memory uri = tokenURI(tokenId);
1707         return (tokenId, tokenLevel, tokenTransferCount, uri);
1708     }
1709 
1710     /**
1711      * @dev Reserve tokens and gift tokens
1712      */
1713     function deployerMintMultiple(address[] calldata recipients) external payable onlyDeployer {
1714         require(!contractSealed, "Contract sealed");
1715 
1716         uint256 total = totalSupply();
1717         require(total + recipients.length <= maxNftSupply, "Sold out");
1718 
1719         for (uint256 i = 0; i < recipients.length; i++) {
1720             require(recipients[i] != address(0), "Can't mint to null address");
1721 
1722             _safeMint(recipients[i], total + i);
1723         }
1724     }
1725 
1726     /**
1727      * @dev Deployer parameters
1728      */
1729     function deployerSetParam(uint256 key, uint256 value) external onlyDeployer {
1730         require(!contractSealed, "Contract sealed");
1731 
1732         if (key == 0) {
1733             SALES_START_TIMESTAMP = value;
1734         } else if (key == 1) {
1735             CLAIM_START_TIMESTAMP = value;
1736         } else if (key == 2) {
1737             MINT_FEE = value;
1738         } else if (key == 3) {
1739             maxNftSupply = value;
1740         } else if (key == 4) {
1741             maxFreeMints = value;
1742         } else {
1743             revert();
1744         }
1745     }
1746 
1747     /**
1748      * @dev Deployer withdraws ether from this contract
1749      */
1750     function deployerWithdraw(uint256 amount) external onlyDeployer {
1751         (bool success, ) = msg.sender.call{value: amount}("");
1752         require(success, "Transfer failed.");
1753     }
1754 
1755     /**
1756      * @dev Deployer withdraws ERC20s
1757      */
1758     function deployerWithdraw20(IERC20 token) external onlyDeployer {
1759         if (address(token) == 0x0000000000000000000000000000000000000000) {
1760             payable(owner()).transfer(address(this).balance);
1761             (bool success, ) = owner().call{value: address(this).balance}("");
1762             require(success, "Transfer failed.");
1763         } else {
1764             token.transfer(owner(), token.balanceOf(address(this)));
1765         }
1766     }
1767 
1768     /**
1769      * @dev Seal this contract
1770      */
1771     function deployerSealContract() external onlyDeployer {
1772         contractSealed = true;
1773     }
1774 
1775     function toString(uint256 value) internal pure returns (string memory) {
1776         // Inspired by OraclizeAPI's implementation - MIT license
1777         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1778 
1779         if (value == 0) {
1780             return "0";
1781         }
1782         uint256 temp = value;
1783         uint256 digits;
1784         while (temp != 0) {
1785             digits++;
1786             temp /= 10;
1787         }
1788         bytes memory buffer = new bytes(digits);
1789         while (value != 0) {
1790             digits -= 1;
1791             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1792             value /= 10;
1793         }
1794         return string(buffer);
1795     }
1796 
1797     constructor() ERC721("Mooncake", "MOONCAKE") Ownable() {}
1798 }
1799 
1800 /// [MIT License]
1801 /// @title Base64
1802 /// @notice Provides a function for encoding some bytes in base64
1803 /// @author Brecht Devos <brecht@loopring.org>
1804 library Base64 {
1805     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1806 
1807     /// @notice Encodes some bytes to the base64 representation
1808     function encode(bytes memory data) internal pure returns (string memory) {
1809         uint256 len = data.length;
1810         if (len == 0) return "";
1811 
1812         // multiply by 4/3 rounded up
1813         uint256 encodedLen = 4 * ((len + 2) / 3);
1814 
1815         // Add some extra buffer at the end
1816         bytes memory result = new bytes(encodedLen + 32);
1817 
1818         bytes memory table = TABLE;
1819 
1820         assembly {
1821             let tablePtr := add(table, 1)
1822             let resultPtr := add(result, 32)
1823 
1824             for {
1825                 let i := 0
1826             } lt(i, len) {
1827 
1828             } {
1829                 i := add(i, 3)
1830                 let input := and(mload(add(data, i)), 0xffffff)
1831 
1832                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1833                 out := shl(8, out)
1834                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1835                 out := shl(8, out)
1836                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1837                 out := shl(8, out)
1838                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1839                 out := shl(224, out)
1840 
1841                 mstore(resultPtr, out)
1842 
1843                 resultPtr := add(resultPtr, 4)
1844             }
1845 
1846             switch mod(len, 3)
1847             case 1 {
1848                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1849             }
1850             case 2 {
1851                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1852             }
1853 
1854             mstore(result, encodedLen)
1855         }
1856 
1857         return string(result);
1858     }
1859 }