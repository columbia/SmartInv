1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Contract module that helps prevent reentrant calls to a function.
8  *
9  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
10  * available, which can be applied to functions to make sure there are no nested
11  * (reentrant) calls to them.
12  *
13  * Note that because there is a single `nonReentrant` guard, functions marked as
14  * `nonReentrant` may not call one another. This can be worked around by making
15  * those functions `private`, and then adding `external` `nonReentrant` entry
16  * points to them.
17  *
18  * TIP: If you would like to learn more about reentrancy and alternative ways
19  * to protect against it, check out our blog post
20  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
21  */
22 abstract contract ReentrancyGuard {
23     // Booleans are more expensive than uint256 or any type that takes up a full
24     // word because each write operation emits an extra SLOAD to first read the
25     // slot's contents, replace the bits taken up by the boolean, and then write
26     // back. This is the compiler's defense against contract upgrades and
27     // pointer aliasing, and it cannot be disabled.
28 
29     // The values being non-zero value makes deployment a bit more expensive,
30     // but in exchange the refund on every call to nonReentrant will be lower in
31     // amount. Since refunds are capped to a percentage of the total
32     // transaction's gas, it is best to keep them low in cases like this one, to
33     // increase the likelihood of the full refund coming into effect.
34     uint256 private constant _NOT_ENTERED = 1;
35     uint256 private constant _ENTERED = 2;
36 
37     uint256 private _status;
38 
39     constructor() {
40         _status = _NOT_ENTERED;
41     }
42 
43     /**
44      * @dev Prevents a contract from calling itself, directly or indirectly.
45      * Calling a `nonReentrant` function from another `nonReentrant`
46      * function is not supported. It is possible to prevent this from happening
47      * by making the `nonReentrant` function external, and making it call a
48      * `private` function that does the actual work.
49      */
50     modifier nonReentrant() {
51         // On the first call to nonReentrant, _notEntered will be true
52         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
53 
54         // Any calls to nonReentrant after this point will fail
55         _status = _ENTERED;
56 
57         _;
58 
59         // By storing the original value once again, a refund is triggered (see
60         // https://eips.ethereum.org/EIPS/eip-2200)
61         _status = _NOT_ENTERED;
62     }
63 }
64 
65 // File: @openzeppelin/contracts/utils/Strings.sol
66 
67 
68 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev String operations.
74  */
75 library Strings {
76     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
80      */
81     function toString(uint256 value) internal pure returns (string memory) {
82         // Inspired by OraclizeAPI's implementation - MIT licence
83         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
84 
85         if (value == 0) {
86             return "0";
87         }
88         uint256 temp = value;
89         uint256 digits;
90         while (temp != 0) {
91             digits++;
92             temp /= 10;
93         }
94         bytes memory buffer = new bytes(digits);
95         while (value != 0) {
96             digits -= 1;
97             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
98             value /= 10;
99         }
100         return string(buffer);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
105      */
106     function toHexString(uint256 value) internal pure returns (string memory) {
107         if (value == 0) {
108             return "0x00";
109         }
110         uint256 temp = value;
111         uint256 length = 0;
112         while (temp != 0) {
113             length++;
114             temp >>= 8;
115         }
116         return toHexString(value, length);
117     }
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
121      */
122     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
123         bytes memory buffer = new bytes(2 * length + 2);
124         buffer[0] = "0";
125         buffer[1] = "x";
126         for (uint256 i = 2 * length + 1; i > 1; --i) {
127             buffer[i] = _HEX_SYMBOLS[value & 0xf];
128             value >>= 4;
129         }
130         require(value == 0, "Strings: hex length insufficient");
131         return string(buffer);
132     }
133 }
134 
135 // File: @openzeppelin/contracts/utils/Context.sol
136 
137 
138 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 /**
143  * @dev Provides information about the current execution context, including the
144  * sender of the transaction and its data. While these are generally available
145  * via msg.sender and msg.data, they should not be accessed in such a direct
146  * manner, since when dealing with meta-transactions the account sending and
147  * paying for execution may not be the actual sender (as far as an application
148  * is concerned).
149  *
150  * This contract is only required for intermediate, library-like contracts.
151  */
152 abstract contract Context {
153     function _msgSender() internal view virtual returns (address) {
154         return msg.sender;
155     }
156 
157     function _msgData() internal view virtual returns (bytes calldata) {
158         return msg.data;
159     }
160 }
161 
162 // File: @openzeppelin/contracts/access/Ownable.sol
163 
164 
165 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
166 
167 pragma solidity ^0.8.0;
168 
169 
170 /**
171  * @dev Contract module which provides a basic access control mechanism, where
172  * there is an account (an owner) that can be granted exclusive access to
173  * specific functions.
174  *
175  * By default, the owner account will be the one that deploys the contract. This
176  * can later be changed with {transferOwnership}.
177  *
178  * This module is used through inheritance. It will make available the modifier
179  * `onlyOwner`, which can be applied to your functions to restrict their use to
180  * the owner.
181  */
182 abstract contract Ownable is Context {
183     address private _owner;
184 
185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
186 
187     /**
188      * @dev Initializes the contract setting the deployer as the initial owner.
189      */
190     constructor() {
191         _transferOwnership(_msgSender());
192     }
193 
194     /**
195      * @dev Returns the address of the current owner.
196      */
197     function owner() public view virtual returns (address) {
198         return _owner;
199     }
200 
201     /**
202      * @dev Throws if called by any account other than the owner.
203      */
204     modifier onlyOwner() {
205         require(owner() == _msgSender(), "Ownable: caller is not the owner");
206         _;
207     }
208 
209     /**
210      * @dev Leaves the contract without owner. It will not be possible to call
211      * `onlyOwner` functions anymore. Can only be called by the current owner.
212      *
213      * NOTE: Renouncing ownership will leave the contract without an owner,
214      * thereby removing any functionality that is only available to the owner.
215      */
216     function renounceOwnership() public virtual onlyOwner {
217         _transferOwnership(address(0));
218     }
219 
220     /**
221      * @dev Transfers ownership of the contract to a new account (`newOwner`).
222      * Can only be called by the current owner.
223      */
224     function transferOwnership(address newOwner) public virtual onlyOwner {
225         require(newOwner != address(0), "Ownable: new owner is the zero address");
226         _transferOwnership(newOwner);
227     }
228 
229     /**
230      * @dev Transfers ownership of the contract to a new account (`newOwner`).
231      * Internal function without access restriction.
232      */
233     function _transferOwnership(address newOwner) internal virtual {
234         address oldOwner = _owner;
235         _owner = newOwner;
236         emit OwnershipTransferred(oldOwner, newOwner);
237     }
238 }
239 
240 // File: @openzeppelin/contracts/utils/Address.sol
241 
242 
243 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
244 
245 pragma solidity ^0.8.1;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      *
268      * [IMPORTANT]
269      * ====
270      * You shouldn't rely on `isContract` to protect against flash loan attacks!
271      *
272      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
273      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
274      * constructor.
275      * ====
276      */
277     function isContract(address account) internal view returns (bool) {
278         // This method relies on extcodesize/address.code.length, which returns 0
279         // for contracts in construction, since the code is only stored at the end
280         // of the constructor execution.
281 
282         return account.code.length > 0;
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         (bool success, ) = recipient.call{value: amount}("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain `call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327         return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value
359     ) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
365      * with `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         require(address(this).balance >= value, "Address: insufficient balance for call");
376         require(isContract(target), "Address: call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.call{value: value}(data);
379         return verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but performing a static call.
385      *
386      * _Available since v3.3._
387      */
388     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
389         return functionStaticCall(target, data, "Address: low-level static call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
394      * but performing a static call.
395      *
396      * _Available since v3.3._
397      */
398     function functionStaticCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal view returns (bytes memory) {
403         require(isContract(target), "Address: static call to non-contract");
404 
405         (bool success, bytes memory returndata) = target.staticcall(data);
406         return verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but performing a delegate call.
412      *
413      * _Available since v3.4._
414      */
415     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
416         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
421      * but performing a delegate call.
422      *
423      * _Available since v3.4._
424      */
425     function functionDelegateCall(
426         address target,
427         bytes memory data,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(isContract(target), "Address: delegate call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.delegatecall(data);
433         return verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
438      * revert reason using the provided one.
439      *
440      * _Available since v4.3._
441      */
442     function verifyCallResult(
443         bool success,
444         bytes memory returndata,
445         string memory errorMessage
446     ) internal pure returns (bytes memory) {
447         if (success) {
448             return returndata;
449         } else {
450             // Look for revert reason and bubble it up if present
451             if (returndata.length > 0) {
452                 // The easiest way to bubble the revert reason is using memory via assembly
453 
454                 assembly {
455                     let returndata_size := mload(returndata)
456                     revert(add(32, returndata), returndata_size)
457                 }
458             } else {
459                 revert(errorMessage);
460             }
461         }
462     }
463 }
464 
465 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
466 
467 
468 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
469 
470 pragma solidity ^0.8.0;
471 
472 /**
473  * @title ERC721 token receiver interface
474  * @dev Interface for any contract that wants to support safeTransfers
475  * from ERC721 asset contracts.
476  */
477 interface IERC721Receiver {
478     /**
479      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
480      * by `operator` from `from`, this function is called.
481      *
482      * It must return its Solidity selector to confirm the token transfer.
483      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
484      *
485      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
486      */
487     function onERC721Received(
488         address operator,
489         address from,
490         uint256 tokenId,
491         bytes calldata data
492     ) external returns (bytes4);
493 }
494 
495 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @dev Interface of the ERC165 standard, as defined in the
504  * https://eips.ethereum.org/EIPS/eip-165[EIP].
505  *
506  * Implementers can declare support of contract interfaces, which can then be
507  * queried by others ({ERC165Checker}).
508  *
509  * For an implementation, see {ERC165}.
510  */
511 interface IERC165 {
512     /**
513      * @dev Returns true if this contract implements the interface defined by
514      * `interfaceId`. See the corresponding
515      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
516      * to learn more about how these ids are created.
517      *
518      * This function call must use less than 30 000 gas.
519      */
520     function supportsInterface(bytes4 interfaceId) external view returns (bool);
521 }
522 
523 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
524 
525 
526 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 
531 /**
532  * @dev Implementation of the {IERC165} interface.
533  *
534  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
535  * for the additional interface id that will be supported. For example:
536  *
537  * ```solidity
538  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
539  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
540  * }
541  * ```
542  *
543  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
544  */
545 abstract contract ERC165 is IERC165 {
546     /**
547      * @dev See {IERC165-supportsInterface}.
548      */
549     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
550         return interfaceId == type(IERC165).interfaceId;
551     }
552 }
553 
554 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
555 
556 
557 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 
562 /**
563  * @dev Required interface of an ERC721 compliant contract.
564  */
565 interface IERC721 is IERC165 {
566     /**
567      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
568      */
569     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
570 
571     /**
572      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
573      */
574     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
575 
576     /**
577      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
578      */
579     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
580 
581     /**
582      * @dev Returns the number of tokens in ``owner``'s account.
583      */
584     function balanceOf(address owner) external view returns (uint256 balance);
585 
586     /**
587      * @dev Returns the owner of the `tokenId` token.
588      *
589      * Requirements:
590      *
591      * - `tokenId` must exist.
592      */
593     function ownerOf(uint256 tokenId) external view returns (address owner);
594 
595     /**
596      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
597      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
598      *
599      * Requirements:
600      *
601      * - `from` cannot be the zero address.
602      * - `to` cannot be the zero address.
603      * - `tokenId` token must exist and be owned by `from`.
604      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
605      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
606      *
607      * Emits a {Transfer} event.
608      */
609     function safeTransferFrom(
610         address from,
611         address to,
612         uint256 tokenId
613     ) external;
614 
615     /**
616      * @dev Transfers `tokenId` token from `from` to `to`.
617      *
618      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
619      *
620      * Requirements:
621      *
622      * - `from` cannot be the zero address.
623      * - `to` cannot be the zero address.
624      * - `tokenId` token must be owned by `from`.
625      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
626      *
627      * Emits a {Transfer} event.
628      */
629     function transferFrom(
630         address from,
631         address to,
632         uint256 tokenId
633     ) external;
634 
635     /**
636      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
637      * The approval is cleared when the token is transferred.
638      *
639      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
640      *
641      * Requirements:
642      *
643      * - The caller must own the token or be an approved operator.
644      * - `tokenId` must exist.
645      *
646      * Emits an {Approval} event.
647      */
648     function approve(address to, uint256 tokenId) external;
649 
650     /**
651      * @dev Returns the account approved for `tokenId` token.
652      *
653      * Requirements:
654      *
655      * - `tokenId` must exist.
656      */
657     function getApproved(uint256 tokenId) external view returns (address operator);
658 
659     /**
660      * @dev Approve or remove `operator` as an operator for the caller.
661      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
662      *
663      * Requirements:
664      *
665      * - The `operator` cannot be the caller.
666      *
667      * Emits an {ApprovalForAll} event.
668      */
669     function setApprovalForAll(address operator, bool _approved) external;
670 
671     /**
672      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
673      *
674      * See {setApprovalForAll}
675      */
676     function isApprovedForAll(address owner, address operator) external view returns (bool);
677 
678     /**
679      * @dev Safely transfers `tokenId` token from `from` to `to`.
680      *
681      * Requirements:
682      *
683      * - `from` cannot be the zero address.
684      * - `to` cannot be the zero address.
685      * - `tokenId` token must exist and be owned by `from`.
686      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
687      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
688      *
689      * Emits a {Transfer} event.
690      */
691     function safeTransferFrom(
692         address from,
693         address to,
694         uint256 tokenId,
695         bytes calldata data
696     ) external;
697 }
698 
699 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
700 
701 
702 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 
707 /**
708  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
709  * @dev See https://eips.ethereum.org/EIPS/eip-721
710  */
711 interface IERC721Metadata is IERC721 {
712     /**
713      * @dev Returns the token collection name.
714      */
715     function name() external view returns (string memory);
716 
717     /**
718      * @dev Returns the token collection symbol.
719      */
720     function symbol() external view returns (string memory);
721 
722     /**
723      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
724      */
725     function tokenURI(uint256 tokenId) external view returns (string memory);
726 }
727 
728 // File: erc721a/contracts/ERC721A.sol
729 
730 
731 // Creator: Chiru Labs
732 
733 pragma solidity ^0.8.4;
734 
735 
736 
737 
738 
739 
740 
741 
742 error ApprovalCallerNotOwnerNorApproved();
743 error ApprovalQueryForNonexistentToken();
744 error ApproveToCaller();
745 error ApprovalToCurrentOwner();
746 error BalanceQueryForZeroAddress();
747 error MintToZeroAddress();
748 error MintZeroQuantity();
749 error OwnerQueryForNonexistentToken();
750 error TransferCallerNotOwnerNorApproved();
751 error TransferFromIncorrectOwner();
752 error TransferToNonERC721ReceiverImplementer();
753 error TransferToZeroAddress();
754 error URIQueryForNonexistentToken();
755 
756 /**
757  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
758  * the Metadata extension. Built to optimize for lower gas during batch mints.
759  *
760  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
761  *
762  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
763  *
764  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
765  */
766 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
767     using Address for address;
768     using Strings for uint256;
769 
770     // Compiler will pack this into a single 256bit word.
771     struct TokenOwnership {
772         // The address of the owner.
773         address addr;
774         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
775         uint64 startTimestamp;
776         // Whether the token has been burned.
777         bool burned;
778     }
779 
780     // Compiler will pack this into a single 256bit word.
781     struct AddressData {
782         // Realistically, 2**64-1 is more than enough.
783         uint64 balance;
784         // Keeps track of mint count with minimal overhead for tokenomics.
785         uint64 numberMinted;
786         // Keeps track of burn count with minimal overhead for tokenomics.
787         uint64 numberBurned;
788         // For miscellaneous variable(s) pertaining to the address
789         // (e.g. number of whitelist mint slots used).
790         // If there are multiple variables, please pack them into a uint64.
791         uint64 aux;
792     }
793 
794     // The tokenId of the next token to be minted.
795     uint256 internal _currentIndex;
796 
797     // The number of tokens burned.
798     uint256 internal _burnCounter;
799 
800     // Token name
801     string private _name;
802 
803     // Token symbol
804     string private _symbol;
805 
806     // Mapping from token ID to ownership details
807     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
808     mapping(uint256 => TokenOwnership) internal _ownerships;
809 
810     // Mapping owner address to address data
811     mapping(address => AddressData) private _addressData;
812 
813     // Mapping from token ID to approved address
814     mapping(uint256 => address) private _tokenApprovals;
815 
816     // Mapping from owner to operator approvals
817     mapping(address => mapping(address => bool)) private _operatorApprovals;
818 
819     constructor(string memory name_, string memory symbol_) {
820         _name = name_;
821         _symbol = symbol_;
822         _currentIndex = _startTokenId();
823     }
824 
825     /**
826      * To change the starting tokenId, please override this function.
827      */
828     function _startTokenId() internal view virtual returns (uint256) {
829         return 0;
830     }
831 
832     /**
833      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
834      */
835     function totalSupply() public view returns (uint256) {
836         // Counter underflow is impossible as _burnCounter cannot be incremented
837         // more than _currentIndex - _startTokenId() times
838         unchecked {
839             return _currentIndex - _burnCounter - _startTokenId();
840         }
841     }
842 
843     /**
844      * Returns the total amount of tokens minted in the contract.
845      */
846     function _totalMinted() internal view returns (uint256) {
847         // Counter underflow is impossible as _currentIndex does not decrement,
848         // and it is initialized to _startTokenId()
849         unchecked {
850             return _currentIndex - _startTokenId();
851         }
852     }
853 
854     /**
855      * @dev See {IERC165-supportsInterface}.
856      */
857     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
858         return
859             interfaceId == type(IERC721).interfaceId ||
860             interfaceId == type(IERC721Metadata).interfaceId ||
861             super.supportsInterface(interfaceId);
862     }
863 
864     /**
865      * @dev See {IERC721-balanceOf}.
866      */
867     function balanceOf(address owner) public view override returns (uint256) {
868         if (owner == address(0)) revert BalanceQueryForZeroAddress();
869         return uint256(_addressData[owner].balance);
870     }
871 
872     /**
873      * Returns the number of tokens minted by `owner`.
874      */
875     function _numberMinted(address owner) internal view returns (uint256) {
876         return uint256(_addressData[owner].numberMinted);
877     }
878 
879     /**
880      * Returns the number of tokens burned by or on behalf of `owner`.
881      */
882     function _numberBurned(address owner) internal view returns (uint256) {
883         return uint256(_addressData[owner].numberBurned);
884     }
885 
886     /**
887      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
888      */
889     function _getAux(address owner) internal view returns (uint64) {
890         return _addressData[owner].aux;
891     }
892 
893     /**
894      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
895      * If there are multiple variables, please pack them into a uint64.
896      */
897     function _setAux(address owner, uint64 aux) internal {
898         _addressData[owner].aux = aux;
899     }
900 
901     /**
902      * Gas spent here starts off proportional to the maximum mint batch size.
903      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
904      */
905     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
906         uint256 curr = tokenId;
907 
908         unchecked {
909             if (_startTokenId() <= curr && curr < _currentIndex) {
910                 TokenOwnership memory ownership = _ownerships[curr];
911                 if (!ownership.burned) {
912                     if (ownership.addr != address(0)) {
913                         return ownership;
914                     }
915                     // Invariant:
916                     // There will always be an ownership that has an address and is not burned
917                     // before an ownership that does not have an address and is not burned.
918                     // Hence, curr will not underflow.
919                     while (true) {
920                         curr--;
921                         ownership = _ownerships[curr];
922                         if (ownership.addr != address(0)) {
923                             return ownership;
924                         }
925                     }
926                 }
927             }
928         }
929         revert OwnerQueryForNonexistentToken();
930     }
931 
932     /**
933      * @dev See {IERC721-ownerOf}.
934      */
935     function ownerOf(uint256 tokenId) public view override returns (address) {
936         return _ownershipOf(tokenId).addr;
937     }
938 
939     /**
940      * @dev See {IERC721Metadata-name}.
941      */
942     function name() public view virtual override returns (string memory) {
943         return _name;
944     }
945 
946     /**
947      * @dev See {IERC721Metadata-symbol}.
948      */
949     function symbol() public view virtual override returns (string memory) {
950         return _symbol;
951     }
952 
953     /**
954      * @dev See {IERC721Metadata-tokenURI}.
955      */
956     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
957         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
958 
959         string memory baseURI = _baseURI();
960         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
961     }
962 
963     /**
964      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
965      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
966      * by default, can be overriden in child contracts.
967      */
968     function _baseURI() internal view virtual returns (string memory) {
969         return '';
970     }
971 
972     /**
973      * @dev See {IERC721-approve}.
974      */
975     function approve(address to, uint256 tokenId) public virtual {
976         address owner = ERC721A.ownerOf(tokenId);
977         if (to == owner) revert ApprovalToCurrentOwner();
978 
979         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
980             revert ApprovalCallerNotOwnerNorApproved();
981         }
982 
983         _approve(to, tokenId, owner);
984     }
985 
986     /**
987      * @dev See {IERC721-getApproved}.
988      */
989     function getApproved(uint256 tokenId) public view override returns (address) {
990         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
991 
992         return _tokenApprovals[tokenId];
993     }
994 
995     /**
996      * @dev See {IERC721-setApprovalForAll}.
997      */
998     function setApprovalForAll(address operator, bool approved) public virtual override {
999         if (operator == _msgSender()) revert ApproveToCaller();
1000 
1001         _operatorApprovals[_msgSender()][operator] = approved;
1002         emit ApprovalForAll(_msgSender(), operator, approved);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-isApprovedForAll}.
1007      */
1008     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1009         return _operatorApprovals[owner][operator];
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-transferFrom}.
1014      */
1015     function transferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) public virtual override {
1020         _transfer(from, to, tokenId);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-safeTransferFrom}.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) public virtual override {
1031         safeTransferFrom(from, to, tokenId, '');
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-safeTransferFrom}.
1036      */
1037     function safeTransferFrom(
1038         address from,
1039         address to,
1040         uint256 tokenId,
1041         bytes memory _data
1042     ) public virtual override {
1043         _transfer(from, to, tokenId);
1044         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1045             revert TransferToNonERC721ReceiverImplementer();
1046         }
1047     }
1048 
1049     /**
1050      * @dev Returns whether `tokenId` exists.
1051      *
1052      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1053      *
1054      * Tokens start existing when they are minted (`_mint`),
1055      */
1056     function _exists(uint256 tokenId) internal view returns (bool) {
1057         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1058     }
1059 
1060     function _safeMint(address to, uint256 quantity) internal {
1061         _safeMint(to, quantity, '');
1062     }
1063 
1064     /**
1065      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1066      *
1067      * Requirements:
1068      *
1069      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1070      * - `quantity` must be greater than 0.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _safeMint(
1075         address to,
1076         uint256 quantity,
1077         bytes memory _data
1078     ) internal {
1079         _mint(to, quantity, _data, true);
1080     }
1081 
1082     /**
1083      * @dev Mints `quantity` tokens and transfers them to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - `to` cannot be the zero address.
1088      * - `quantity` must be greater than 0.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _mint(
1093         address to,
1094         uint256 quantity,
1095         bytes memory _data,
1096         bool safe
1097     ) internal {
1098         uint256 startTokenId = _currentIndex;
1099         if (to == address(0)) revert MintToZeroAddress();
1100         if (quantity == 0) revert MintZeroQuantity();
1101 
1102         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1103 
1104         // Overflows are incredibly unrealistic.
1105         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1106         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1107         unchecked {
1108             _addressData[to].balance += uint64(quantity);
1109             _addressData[to].numberMinted += uint64(quantity);
1110 
1111             _ownerships[startTokenId].addr = to;
1112             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1113 
1114             uint256 updatedIndex = startTokenId;
1115             uint256 end = updatedIndex + quantity;
1116 
1117             if (safe && to.isContract()) {
1118                 do {
1119                     emit Transfer(address(0), to, updatedIndex);
1120                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1121                         revert TransferToNonERC721ReceiverImplementer();
1122                     }
1123                 } while (updatedIndex != end);
1124                 // Reentrancy protection
1125                 if (_currentIndex != startTokenId) revert();
1126             } else {
1127                 do {
1128                     emit Transfer(address(0), to, updatedIndex++);
1129                 } while (updatedIndex != end);
1130             }
1131             _currentIndex = updatedIndex;
1132         }
1133         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1134     }
1135 
1136     /**
1137      * @dev Transfers `tokenId` from `from` to `to`.
1138      *
1139      * Requirements:
1140      *
1141      * - `to` cannot be the zero address.
1142      * - `tokenId` token must be owned by `from`.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _transfer(
1147         address from,
1148         address to,
1149         uint256 tokenId
1150     ) internal {
1151         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1152 
1153         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1154 
1155         bool isApprovedOrOwner = (_msgSender() == from ||
1156             isApprovedForAll(from, _msgSender()) ||
1157             getApproved(tokenId) == _msgSender());
1158 
1159         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1160         if (to == address(0)) revert TransferToZeroAddress();
1161 
1162         _beforeTokenTransfers(from, to, tokenId, 1);
1163 
1164         // Clear approvals from the previous owner
1165         _approve(address(0), tokenId, from);
1166 
1167         // Underflow of the sender's balance is impossible because we check for
1168         // ownership above and the recipient's balance can't realistically overflow.
1169         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1170         unchecked {
1171             _addressData[from].balance -= 1;
1172             _addressData[to].balance += 1;
1173 
1174             TokenOwnership storage currSlot = _ownerships[tokenId];
1175             currSlot.addr = to;
1176             currSlot.startTimestamp = uint64(block.timestamp);
1177 
1178             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1179             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1180             uint256 nextTokenId = tokenId + 1;
1181             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1182             if (nextSlot.addr == address(0)) {
1183                 // This will suffice for checking _exists(nextTokenId),
1184                 // as a burned slot cannot contain the zero address.
1185                 if (nextTokenId != _currentIndex) {
1186                     nextSlot.addr = from;
1187                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1188                 }
1189             }
1190         }
1191 
1192         emit Transfer(from, to, tokenId);
1193         _afterTokenTransfers(from, to, tokenId, 1);
1194     }
1195 
1196     /**
1197      * @dev This is equivalent to _burn(tokenId, false)
1198      */
1199     function _burn(uint256 tokenId) internal virtual {
1200         _burn(tokenId, false);
1201     }
1202 
1203     /**
1204      * @dev Destroys `tokenId`.
1205      * The approval is cleared when the token is burned.
1206      *
1207      * Requirements:
1208      *
1209      * - `tokenId` must exist.
1210      *
1211      * Emits a {Transfer} event.
1212      */
1213     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1214         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1215 
1216         address from = prevOwnership.addr;
1217 
1218         if (approvalCheck) {
1219             bool isApprovedOrOwner = (_msgSender() == from ||
1220                 isApprovedForAll(from, _msgSender()) ||
1221                 getApproved(tokenId) == _msgSender());
1222 
1223             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1224         }
1225 
1226         _beforeTokenTransfers(from, address(0), tokenId, 1);
1227 
1228         // Clear approvals from the previous owner
1229         _approve(address(0), tokenId, from);
1230 
1231         // Underflow of the sender's balance is impossible because we check for
1232         // ownership above and the recipient's balance can't realistically overflow.
1233         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1234         unchecked {
1235             AddressData storage addressData = _addressData[from];
1236             addressData.balance -= 1;
1237             addressData.numberBurned += 1;
1238 
1239             // Keep track of who burned the token, and the timestamp of burning.
1240             TokenOwnership storage currSlot = _ownerships[tokenId];
1241             currSlot.addr = from;
1242             currSlot.startTimestamp = uint64(block.timestamp);
1243             currSlot.burned = true;
1244 
1245             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1246             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1247             uint256 nextTokenId = tokenId + 1;
1248             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1249             if (nextSlot.addr == address(0)) {
1250                 // This will suffice for checking _exists(nextTokenId),
1251                 // as a burned slot cannot contain the zero address.
1252                 if (nextTokenId != _currentIndex) {
1253                     nextSlot.addr = from;
1254                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1255                 }
1256             }
1257         }
1258 
1259         emit Transfer(from, address(0), tokenId);
1260         _afterTokenTransfers(from, address(0), tokenId, 1);
1261 
1262         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1263         unchecked {
1264             _burnCounter++;
1265         }
1266     }
1267 
1268     /**
1269      * @dev Approve `to` to operate on `tokenId`
1270      *
1271      * Emits a {Approval} event.
1272      */
1273     function _approve(
1274         address to,
1275         uint256 tokenId,
1276         address owner
1277     ) internal {
1278         _tokenApprovals[tokenId] = to;
1279         emit Approval(owner, to, tokenId);
1280     }
1281 
1282     /**
1283      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1284      *
1285      * @param from address representing the previous owner of the given token ID
1286      * @param to target address that will receive the tokens
1287      * @param tokenId uint256 ID of the token to be transferred
1288      * @param _data bytes optional data to send along with the call
1289      * @return bool whether the call correctly returned the expected magic value
1290      */
1291     function _checkContractOnERC721Received(
1292         address from,
1293         address to,
1294         uint256 tokenId,
1295         bytes memory _data
1296     ) internal returns (bool) {
1297         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1298             return retval == IERC721Receiver(to).onERC721Received.selector;
1299         } catch (bytes memory reason) {
1300             if (reason.length == 0) {
1301                 revert TransferToNonERC721ReceiverImplementer();
1302             } else {
1303                 assembly {
1304                     revert(add(32, reason), mload(reason))
1305                 }
1306             }
1307         }
1308     }
1309     /**
1310    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1311    * The call is not executed if the target address is not a contract.
1312    *
1313    * @param from address representing the previous owner of the given token ID
1314    * @param to target address that will receive the tokens
1315    * @param tokenId uint256 ID of the token to be transferred
1316    * @param _data bytes optional data to send along with the call
1317    * @return bool whether the call correctly returned the expected magic value
1318    */
1319   function _checkOnERC721Received(
1320     address from,
1321     address to,
1322     uint256 tokenId,
1323     bytes memory _data
1324   ) internal returns (bool) {
1325     if (to.isContract()) {
1326       try
1327         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1328       returns (bytes4 retval) {
1329         return retval == IERC721Receiver(to).onERC721Received.selector;
1330       } catch (bytes memory reason) {
1331         if (reason.length == 0) {
1332           revert("ERC721A: transfer to non ERC721Receiver implementer");
1333         } else {
1334           assembly {
1335             revert(add(32, reason), mload(reason))
1336           }
1337         }
1338       }
1339     } else {
1340       return true;
1341     }
1342   }
1343 
1344 
1345     /**
1346      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1347      * And also called before burning one token.
1348      *
1349      * startTokenId - the first token id to be transferred
1350      * quantity - the amount to be transferred
1351      *
1352      * Calling conditions:
1353      *
1354      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1355      * transferred to `to`.
1356      * - When `from` is zero, `tokenId` will be minted for `to`.
1357      * - When `to` is zero, `tokenId` will be burned by `from`.
1358      * - `from` and `to` are never both zero.
1359      */
1360     function _beforeTokenTransfers(
1361         address from,
1362         address to,
1363         uint256 startTokenId,
1364         uint256 quantity
1365     ) internal virtual {}
1366 
1367     /**
1368      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1369      * minting.
1370      * And also called after one token has been burned.
1371      *
1372      * startTokenId - the first token id to be transferred
1373      * quantity - the amount to be transferred
1374      *
1375      * Calling conditions:
1376      *
1377      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1378      * transferred to `to`.
1379      * - When `from` is zero, `tokenId` has been minted for `to`.
1380      * - When `to` is zero, `tokenId` has been burned by `from`.
1381      * - `from` and `to` are never both zero.
1382      */
1383     function _afterTokenTransfers(
1384         address from,
1385         address to,
1386         uint256 startTokenId,
1387         uint256 quantity
1388     ) internal virtual {}
1389 }
1390 
1391 
1392 
1393 // File contracts/OperatorFilter/Workerigos.sol
1394 pragma solidity ^0.8.9;
1395 
1396 interface IOperatorFilterRegistry {
1397     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1398     function register(address registrant) external;
1399     function registerAndSubscribe(address registrant, address subscription) external;
1400     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1401     function updateOperator(address registrant, address operator, bool filtered) external;
1402     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1403     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1404     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1405     function subscribe(address registrant, address registrantToSubscribe) external;
1406     function unsubscribe(address registrant, bool copyExistingEntries) external;
1407     function subscriptionOf(address addr) external returns (address registrant);
1408     function subscribers(address registrant) external returns (address[] memory);
1409     function subscriberAt(address registrant, uint256 index) external returns (address);
1410     function copyEntriesOf(address registrant, address registrantToCopy) external;
1411     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1412     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1413     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1414     function filteredOperators(address addr) external returns (address[] memory);
1415     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1416     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1417     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1418     function isRegistered(address addr) external returns (bool);
1419     function codeHashOf(address addr) external returns (bytes32);
1420 }
1421 
1422 
1423 abstract contract OperatorFilterer {
1424     error OperatorNotAllowed(address operator);
1425 
1426     IOperatorFilterRegistry constant operatorFilterRegistry =
1427         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1428 
1429     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1430         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1431         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1432         // order for the modifier to filter addresses.
1433         if (address(operatorFilterRegistry).code.length > 0) {
1434             if (subscribe) {
1435                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1436             } else {
1437                 if (subscriptionOrRegistrantToCopy != address(0)) {
1438                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1439                 } else {
1440                     operatorFilterRegistry.register(address(this));
1441                 }
1442             }
1443         }
1444     }
1445 
1446     function _onlyAllowedOperator(address from) private view {
1447       if (
1448           !(
1449               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1450               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1451           )
1452       ) {
1453           revert OperatorNotAllowed(msg.sender);
1454       }
1455     }
1456 
1457     modifier onlyAllowedOperator(address from) virtual {
1458         // Check registry code length to facilitate testing in environments without a deployed registry.
1459         if (address(operatorFilterRegistry).code.length > 0) {
1460             // Allow spending tokens from addresses with balance
1461             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1462             // from an EOA.
1463             if (from == msg.sender) {
1464                 _;
1465                 return;
1466             }
1467             _onlyAllowedOperator(from);
1468         }
1469         _;
1470     }
1471 
1472     modifier onlyAllowedOperatorApproval(address operator) virtual {
1473         _checkFilterOperator(operator);
1474         _;
1475     }
1476 
1477     function _checkFilterOperator(address operator) internal view virtual {
1478         // Check registry code length to facilitate testing in environments without a deployed registry.
1479         if (address(operatorFilterRegistry).code.length > 0) {
1480             if (!operatorFilterRegistry.isOperatorAllowed(address(this), operator)) {
1481                 revert OperatorNotAllowed(operator);
1482             }
1483         }
1484     }
1485 }
1486 
1487 error ERC721RestrictedApprovalAddressRestricted();
1488 
1489  
1490 contract Workerigos is  ERC721A, Ownable, ReentrancyGuard, OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1491   using Strings for uint256;
1492  
1493   string public _baseTokenURI;
1494   string public hiddenMetadataUri;
1495  
1496   uint256 public cost = 0.001 ether;
1497   uint256 public maxSupply = 5000;
1498   uint256 public freeSupply = 2251;
1499   uint256 public maxMintAmountPerTx = 5;
1500  
1501   bool public paused;
1502   bool public revealed = true;
1503   uint256 constant royalty=600; // 6.00%
1504 
1505     // Mapping from owner to operator approvals
1506   mapping(address => mapping(address => bool)) private _operatorApprovals;
1507 
1508   /* @dev Mapping of restricted operator approvals set by contract Owner
1509   * This serves as an optional addition to ERC-721 so
1510   * that the contract owner can elect to prevent specific addresses/contracts
1511   * from being marked as the approver for a token. The reason for this
1512   * is that some projects may want to retain control of where their tokens can/can not be listed
1513   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1514   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1515   */
1516   mapping(address => bool) public restrictedApprovalAddresses;
1517 
1518   constructor(
1519     string memory _hiddenMetadataUri
1520   ) ERC721A("Workerigos", "WORKERIGOS") {
1521  
1522     setHiddenMetadataUri(_hiddenMetadataUri);
1523   }
1524  
1525   function mint(uint256 _mintAmount) public payable nonReentrant {
1526     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1527     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1528     require(!paused, "The contract is paused!");
1529     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1530 
1531     if (totalSupply() >= freeSupply) {
1532           require(msg.value > 0, "Max free supply exceeded!");
1533       }
1534  
1535     _safeMint(_msgSender(), _mintAmount);
1536     
1537   }
1538  
1539   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1540     _safeMint(_receiver, _mintAmount);
1541   }
1542  
1543   function _startTokenId() internal view virtual override returns (uint256) {
1544     return 1;
1545   }
1546  
1547   function setRevealed(bool _state) public onlyOwner {
1548     revealed = _state;
1549   }
1550  
1551   function setCost(uint256 _cost) public onlyOwner {
1552     cost = _cost;
1553   }
1554  
1555   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1556     maxMintAmountPerTx = _maxMintAmountPerTx;
1557   }
1558  
1559   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1560     maxSupply = _maxSupply;
1561   }
1562 
1563   function setFreeSupply(uint256 _freeSupply) public onlyOwner {
1564     freeSupply = _freeSupply;
1565   }
1566 
1567   function setPaused(bool _state) public onlyOwner {
1568     paused = _state;
1569   }
1570  
1571   function withdraw() public onlyOwner nonReentrant {
1572     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1573     require(os);
1574   }
1575  
1576   // METADATA HANDLING
1577  
1578   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1579     hiddenMetadataUri = _hiddenMetadataUri;
1580   }
1581  
1582   function setBaseURI(string calldata baseURI) public onlyOwner {
1583     _baseTokenURI = baseURI;
1584   }
1585  
1586   function _baseURI() internal view virtual override returns (string memory) {
1587       return _baseTokenURI;
1588   }
1589  
1590   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1591       require(_exists(_tokenId), "URI does not exist!");
1592  
1593       if (revealed) {
1594           return string(abi.encodePacked(_baseURI(), _tokenId.toString()));
1595       } else {
1596           return hiddenMetadataUri;
1597       }
1598   }
1599   /**
1600     * @dev See {IERC165-supportsInterface}.
1601     */
1602     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A) returns (bool) {
1603         return super.supportsInterface(interfaceId);
1604     }
1605 
1606    
1607    /**
1608    * @dev See {IERC721-approve}.
1609    */
1610   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1611     address owner = ERC721A.ownerOf(tokenId);
1612     require(to != owner, "ERC721A: approval to current owner");
1613     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1614 
1615     require(
1616       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1617       "ERC721A: approve caller is not owner nor approved for all"
1618     );
1619 
1620     _approve(to, tokenId, owner);
1621   }
1622   /**
1623    * @dev See {IERC721-setApprovalForAll}.
1624    */
1625   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1626     require(operator != _msgSender(), "ERC721A: approve to caller");
1627     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1628 
1629     _operatorApprovals[_msgSender()][operator] = approved;
1630     emit ApprovalForAll(_msgSender(), operator, approved);
1631   }
1632 
1633   /**
1634    * @dev See {IERC721-transferFrom}.
1635    */
1636   function transferFrom(
1637     address from,
1638     address to,
1639     uint256 tokenId
1640   ) public override onlyAllowedOperator(from) {
1641     _transfer(from, to, tokenId);
1642   }
1643 
1644   /**
1645    * @dev See {IERC721-safeTransferFrom}.
1646    */
1647   function safeTransferFrom(
1648     address from,
1649     address to,
1650     uint256 tokenId
1651   ) public override onlyAllowedOperator(from) {
1652     safeTransferFrom(from, to, tokenId, "");
1653   }
1654 
1655   /**
1656    * @dev See {IERC721-safeTransferFrom}.
1657    */
1658   function safeTransferFrom(
1659     address from,
1660     address to,
1661     uint256 tokenId,
1662     bytes memory _data
1663   ) public override onlyAllowedOperator(from) {
1664     _transfer(from, to, tokenId);
1665     require(
1666       _checkOnERC721Received(from, to, tokenId, _data),
1667       "ERC721A: transfer to non ERC721Receiver implementer"
1668     );
1669   }
1670 }