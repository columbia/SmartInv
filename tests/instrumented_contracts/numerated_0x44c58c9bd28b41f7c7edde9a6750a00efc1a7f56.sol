1 // File: IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function updateOperator(address registrant, address operator, bool filtered) external;
12     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
13     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
14     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
15     function subscribe(address registrant, address registrantToSubscribe) external;
16     function unsubscribe(address registrant, bool copyExistingEntries) external;
17     function subscriptionOf(address addr) external returns (address registrant);
18     function subscribers(address registrant) external returns (address[] memory);
19     function subscriberAt(address registrant, uint256 index) external returns (address);
20     function copyEntriesOf(address registrant, address registrantToCopy) external;
21     function isOperatorFiltered(address registrant, address operator) external returns (bool);
22     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
23     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
24     function filteredOperators(address addr) external returns (address[] memory);
25     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
26     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
27     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
28     function isRegistered(address addr) external returns (bool);
29     function codeHashOf(address addr) external returns (bytes32);
30 }
31 
32 // File: OperatorFilterer.sol
33 
34 
35 pragma solidity ^0.8.13;
36 
37 
38 abstract contract OperatorFilterer {
39     error OperatorNotAllowed(address operator);
40 
41     IOperatorFilterRegistry constant operatorFilterRegistry =
42         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
43 
44     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
45         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
46         // will not revert, but the contract will need to be registered with the registry once it is deployed in
47         // order for the modifier to filter addresses.
48         if (address(operatorFilterRegistry).code.length > 0) {
49             if (subscribe) {
50                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
51             } else {
52                 if (subscriptionOrRegistrantToCopy != address(0)) {
53                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
54                 } else {
55                     operatorFilterRegistry.register(address(this));
56                 }
57             }
58         }
59     }
60 
61     modifier onlyAllowedOperator(address from) virtual {
62         // Check registry code length to facilitate testing in environments without a deployed registry.
63         if (address(operatorFilterRegistry).code.length > 0) {
64             // Allow spending tokens from addresses with balance
65             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
66             // from an EOA.
67             if (from == msg.sender) {
68                 _;
69                 return;
70             }
71             if (
72                 !(
73                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
74                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
75                 )
76             ) {
77                 revert OperatorNotAllowed(msg.sender);
78             }
79         }
80         _;
81     }
82 }
83 
84 // File: DefaultOperatorFilterer.sol
85 
86 
87 pragma solidity ^0.8.13;
88 
89 
90 abstract contract DefaultOperatorFilterer is OperatorFilterer {
91     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
92 
93     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
94 }
95 
96 // File: @openzeppelin/contracts/utils/Address.sol
97 
98 
99 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
100 
101 pragma solidity ^0.8.1;
102 
103 /**
104  * @dev Collection of functions related to the address type
105  */
106 library Address {
107     /**
108      * @dev Returns true if `account` is a contract.
109      *
110      * [IMPORTANT]
111      * ====
112      * It is unsafe to assume that an address for which this function returns
113      * false is an externally-owned account (EOA) and not a contract.
114      *
115      * Among others, `isContract` will return false for the following
116      * types of addresses:
117      *
118      *  - an externally-owned account
119      *  - a contract in construction
120      *  - an address where a contract will be created
121      *  - an address where a contract lived, but was destroyed
122      * ====
123      *
124      * [IMPORTANT]
125      * ====
126      * You shouldn't rely on `isContract` to protect against flash loan attacks!
127      *
128      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
129      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
130      * constructor.
131      * ====
132      */
133     function isContract(address account) internal view returns (bool) {
134         // This method relies on extcodesize/address.code.length, which returns 0
135         // for contracts in construction, since the code is only stored at the end
136         // of the constructor execution.
137 
138         return account.code.length > 0;
139     }
140 
141     /**
142      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
143      * `recipient`, forwarding all available gas and reverting on errors.
144      *
145      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
146      * of certain opcodes, possibly making contracts go over the 2300 gas limit
147      * imposed by `transfer`, making them unable to receive funds via
148      * `transfer`. {sendValue} removes this limitation.
149      *
150      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
151      *
152      * IMPORTANT: because control is transferred to `recipient`, care must be
153      * taken to not create reentrancy vulnerabilities. Consider using
154      * {ReentrancyGuard} or the
155      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
156      */
157     function sendValue(address payable recipient, uint256 amount) internal {
158         require(address(this).balance >= amount, "Address: insufficient balance");
159 
160         (bool success, ) = recipient.call{value: amount}("");
161         require(success, "Address: unable to send value, recipient may have reverted");
162     }
163 
164     /**
165      * @dev Performs a Solidity function call using a low level `call`. A
166      * plain `call` is an unsafe replacement for a function call: use this
167      * function instead.
168      *
169      * If `target` reverts with a revert reason, it is bubbled up by this
170      * function (like regular Solidity function calls).
171      *
172      * Returns the raw returned data. To convert to the expected return value,
173      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
174      *
175      * Requirements:
176      *
177      * - `target` must be a contract.
178      * - calling `target` with `data` must not revert.
179      *
180      * _Available since v3.1._
181      */
182     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
183         return functionCall(target, data, "Address: low-level call failed");
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
188      * `errorMessage` as a fallback revert reason when `target` reverts.
189      *
190      * _Available since v3.1._
191      */
192     function functionCall(
193         address target,
194         bytes memory data,
195         string memory errorMessage
196     ) internal returns (bytes memory) {
197         return functionCallWithValue(target, data, 0, errorMessage);
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
202      * but also transferring `value` wei to `target`.
203      *
204      * Requirements:
205      *
206      * - the calling contract must have an ETH balance of at least `value`.
207      * - the called Solidity function must be `payable`.
208      *
209      * _Available since v3.1._
210      */
211     function functionCallWithValue(
212         address target,
213         bytes memory data,
214         uint256 value
215     ) internal returns (bytes memory) {
216         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
221      * with `errorMessage` as a fallback revert reason when `target` reverts.
222      *
223      * _Available since v3.1._
224      */
225     function functionCallWithValue(
226         address target,
227         bytes memory data,
228         uint256 value,
229         string memory errorMessage
230     ) internal returns (bytes memory) {
231         require(address(this).balance >= value, "Address: insufficient balance for call");
232         require(isContract(target), "Address: call to non-contract");
233 
234         (bool success, bytes memory returndata) = target.call{value: value}(data);
235         return verifyCallResult(success, returndata, errorMessage);
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
240      * but performing a static call.
241      *
242      * _Available since v3.3._
243      */
244     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
245         return functionStaticCall(target, data, "Address: low-level static call failed");
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
250      * but performing a static call.
251      *
252      * _Available since v3.3._
253      */
254     function functionStaticCall(
255         address target,
256         bytes memory data,
257         string memory errorMessage
258     ) internal view returns (bytes memory) {
259         require(isContract(target), "Address: static call to non-contract");
260 
261         (bool success, bytes memory returndata) = target.staticcall(data);
262         return verifyCallResult(success, returndata, errorMessage);
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
267      * but performing a delegate call.
268      *
269      * _Available since v3.4._
270      */
271     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
272         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
277      * but performing a delegate call.
278      *
279      * _Available since v3.4._
280      */
281     function functionDelegateCall(
282         address target,
283         bytes memory data,
284         string memory errorMessage
285     ) internal returns (bytes memory) {
286         require(isContract(target), "Address: delegate call to non-contract");
287 
288         (bool success, bytes memory returndata) = target.delegatecall(data);
289         return verifyCallResult(success, returndata, errorMessage);
290     }
291 
292     /**
293      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
294      * revert reason using the provided one.
295      *
296      * _Available since v4.3._
297      */
298     function verifyCallResult(
299         bool success,
300         bytes memory returndata,
301         string memory errorMessage
302     ) internal pure returns (bytes memory) {
303         if (success) {
304             return returndata;
305         } else {
306             // Look for revert reason and bubble it up if present
307             if (returndata.length > 0) {
308                 // The easiest way to bubble the revert reason is using memory via assembly
309 
310                 assembly {
311                     let returndata_size := mload(returndata)
312                     revert(add(32, returndata), returndata_size)
313                 }
314             } else {
315                 revert(errorMessage);
316             }
317         }
318     }
319 }
320 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
321 
322 
323 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
324 
325 pragma solidity ^0.8.0;
326 
327 /**
328  * @title ERC721 token receiver interface
329  * @dev Interface for any contract that wants to support safeTransfers
330  * from ERC721 asset contracts.
331  */
332 interface IERC721Receiver {
333     /**
334      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
335      * by `operator` from `from`, this function is called.
336      *
337      * It must return its Solidity selector to confirm the token transfer.
338      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
339      *
340      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
341      */
342     function onERC721Received(
343         address operator,
344         address from,
345         uint256 tokenId,
346         bytes calldata data
347     ) external returns (bytes4);
348 }
349 
350 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
351 
352 
353 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 /**
358  * @dev Interface of the ERC165 standard, as defined in the
359  * https://eips.ethereum.org/EIPS/eip-165[EIP].
360  *
361  * Implementers can declare support of contract interfaces, which can then be
362  * queried by others ({ERC165Checker}).
363  *
364  * For an implementation, see {ERC165}.
365  */
366 interface IERC165 {
367     /**
368      * @dev Returns true if this contract implements the interface defined by
369      * `interfaceId`. See the corresponding
370      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
371      * to learn more about how these ids are created.
372      *
373      * This function call must use less than 30 000 gas.
374      */
375     function supportsInterface(bytes4 interfaceId) external view returns (bool);
376 }
377 
378 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
379 
380 
381 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
382 
383 pragma solidity ^0.8.0;
384 
385 
386 /**
387  * @dev Implementation of the {IERC165} interface.
388  *
389  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
390  * for the additional interface id that will be supported. For example:
391  *
392  * ```solidity
393  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
394  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
395  * }
396  * ```
397  *
398  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
399  */
400 abstract contract ERC165 is IERC165 {
401     /**
402      * @dev See {IERC165-supportsInterface}.
403      */
404     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
405         return interfaceId == type(IERC165).interfaceId;
406     }
407 }
408 
409 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
410 
411 
412 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
413 
414 pragma solidity ^0.8.0;
415 
416 
417 /**
418  * @dev Required interface of an ERC721 compliant contract.
419  */
420 interface IERC721 is IERC165 {
421     /**
422      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
423      */
424     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
425 
426     /**
427      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
428      */
429     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
430 
431     /**
432      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
433      */
434     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
435 
436     /**
437      * @dev Returns the number of tokens in ``owner``'s account.
438      */
439     function balanceOf(address owner) external view returns (uint256 balance);
440 
441     /**
442      * @dev Returns the owner of the `tokenId` token.
443      *
444      * Requirements:
445      *
446      * - `tokenId` must exist.
447      */
448     function ownerOf(uint256 tokenId) external view returns (address owner);
449 
450     /**
451      * @dev Safely transfers `tokenId` token from `from` to `to`.
452      *
453      * Requirements:
454      *
455      * - `from` cannot be the zero address.
456      * - `to` cannot be the zero address.
457      * - `tokenId` token must exist and be owned by `from`.
458      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
459      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
460      *
461      * Emits a {Transfer} event.
462      */
463     function safeTransferFrom(
464         address from,
465         address to,
466         uint256 tokenId,
467         bytes calldata data
468     ) external;
469 
470     /**
471      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
472      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
473      *
474      * Requirements:
475      *
476      * - `from` cannot be the zero address.
477      * - `to` cannot be the zero address.
478      * - `tokenId` token must exist and be owned by `from`.
479      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
480      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
481      *
482      * Emits a {Transfer} event.
483      */
484     function safeTransferFrom(
485         address from,
486         address to,
487         uint256 tokenId
488     ) external;
489 
490     /**
491      * @dev Transfers `tokenId` token from `from` to `to`.
492      *
493      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
494      *
495      * Requirements:
496      *
497      * - `from` cannot be the zero address.
498      * - `to` cannot be the zero address.
499      * - `tokenId` token must be owned by `from`.
500      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
501      *
502      * Emits a {Transfer} event.
503      */
504     function transferFrom(
505         address from,
506         address to,
507         uint256 tokenId
508     ) external;
509 
510     /**
511      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
512      * The approval is cleared when the token is transferred.
513      *
514      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
515      *
516      * Requirements:
517      *
518      * - The caller must own the token or be an approved operator.
519      * - `tokenId` must exist.
520      *
521      * Emits an {Approval} event.
522      */
523     function approve(address to, uint256 tokenId) external;
524 
525     /**
526      * @dev Approve or remove `operator` as an operator for the caller.
527      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
528      *
529      * Requirements:
530      *
531      * - The `operator` cannot be the caller.
532      *
533      * Emits an {ApprovalForAll} event.
534      */
535     function setApprovalForAll(address operator, bool _approved) external;
536 
537     /**
538      * @dev Returns the account approved for `tokenId` token.
539      *
540      * Requirements:
541      *
542      * - `tokenId` must exist.
543      */
544     function getApproved(uint256 tokenId) external view returns (address operator);
545 
546     /**
547      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
548      *
549      * See {setApprovalForAll}
550      */
551     function isApprovedForAll(address owner, address operator) external view returns (bool);
552 }
553 
554 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
555 
556 
557 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 
562 /**
563  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
564  * @dev See https://eips.ethereum.org/EIPS/eip-721
565  */
566 interface IERC721Metadata is IERC721 {
567     /**
568      * @dev Returns the token collection name.
569      */
570     function name() external view returns (string memory);
571 
572     /**
573      * @dev Returns the token collection symbol.
574      */
575     function symbol() external view returns (string memory);
576 
577     /**
578      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
579      */
580     function tokenURI(uint256 tokenId) external view returns (string memory);
581 }
582 
583 // File: @openzeppelin/contracts/utils/Context.sol
584 
585 
586 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 /**
591  * @dev Provides information about the current execution context, including the
592  * sender of the transaction and its data. While these are generally available
593  * via msg.sender and msg.data, they should not be accessed in such a direct
594  * manner, since when dealing with meta-transactions the account sending and
595  * paying for execution may not be the actual sender (as far as an application
596  * is concerned).
597  *
598  * This contract is only required for intermediate, library-like contracts.
599  */
600 abstract contract Context {
601     function _msgSender() internal view virtual returns (address) {
602         return msg.sender;
603     }
604 
605     function _msgData() internal view virtual returns (bytes calldata) {
606         return msg.data;
607     }
608 }
609 
610 // File: @openzeppelin/contracts/access/Ownable.sol
611 
612 
613 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 
618 /**
619  * @dev Contract module which provides a basic access control mechanism, where
620  * there is an account (an owner) that can be granted exclusive access to
621  * specific functions.
622  *
623  * By default, the owner account will be the one that deploys the contract. This
624  * can later be changed with {transferOwnership}.
625  *
626  * This module is used through inheritance. It will make available the modifier
627  * `onlyOwner`, which can be applied to your functions to restrict their use to
628  * the owner.
629  */
630 abstract contract Ownable is Context {
631     address private _owner;
632 
633     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
634 
635     /**
636      * @dev Initializes the contract setting the deployer as the initial owner.
637      */
638     constructor() {
639         _transferOwnership(_msgSender());
640     }
641 
642     /**
643      * @dev Returns the address of the current owner.
644      */
645     function owner() public view virtual returns (address) {
646         return _owner;
647     }
648 
649     /**
650      * @dev Throws if called by any account other than the owner.
651      */
652     modifier onlyOwner() {
653         require(owner() == _msgSender(), "Ownable: caller is not the owner");
654         _;
655     }
656 
657     /**
658      * @dev Leaves the contract without owner. It will not be possible to call
659      * `onlyOwner` functions anymore. Can only be called by the current owner.
660      *
661      * NOTE: Renouncing ownership will leave the contract without an owner,
662      * thereby removing any functionality that is only available to the owner.
663      */
664     function renounceOwnership() public virtual onlyOwner {
665         _transferOwnership(address(0));
666     }
667 
668     /**
669      * @dev Transfers ownership of the contract to a new account (`newOwner`).
670      * Can only be called by the current owner.
671      */
672     function transferOwnership(address newOwner) public virtual onlyOwner {
673         require(newOwner != address(0), "Ownable: new owner is the zero address");
674         _transferOwnership(newOwner);
675     }
676 
677     /**
678      * @dev Transfers ownership of the contract to a new account (`newOwner`).
679      * Internal function without access restriction.
680      */
681     function _transferOwnership(address newOwner) internal virtual {
682         address oldOwner = _owner;
683         _owner = newOwner;
684         emit OwnershipTransferred(oldOwner, newOwner);
685     }
686 }
687 
688 // File: @openzeppelin/contracts/utils/Strings.sol
689 
690 
691 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
692 
693 pragma solidity ^0.8.0;
694 
695 /**
696  * @dev String operations.
697  */
698 library Strings {
699     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
700 
701     /**
702      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
703      */
704     function toString(uint256 value) internal pure returns (string memory) {
705         // Inspired by OraclizeAPI's implementation - MIT licence
706         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
707 
708         if (value == 0) {
709             return "0";
710         }
711         uint256 temp = value;
712         uint256 digits;
713         while (temp != 0) {
714             digits++;
715             temp /= 10;
716         }
717         bytes memory buffer = new bytes(digits);
718         while (value != 0) {
719             digits -= 1;
720             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
721             value /= 10;
722         }
723         return string(buffer);
724     }
725 
726     /**
727      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
728      */
729     function toHexString(uint256 value) internal pure returns (string memory) {
730         if (value == 0) {
731             return "0x00";
732         }
733         uint256 temp = value;
734         uint256 length = 0;
735         while (temp != 0) {
736             length++;
737             temp >>= 8;
738         }
739         return toHexString(value, length);
740     }
741 
742     /**
743      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
744      */
745     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
746         bytes memory buffer = new bytes(2 * length + 2);
747         buffer[0] = "0";
748         buffer[1] = "x";
749         for (uint256 i = 2 * length + 1; i > 1; --i) {
750             buffer[i] = _HEX_SYMBOLS[value & 0xf];
751             value >>= 4;
752         }
753         require(value == 0, "Strings: hex length insufficient");
754         return string(buffer);
755     }
756 }
757 
758 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
759 
760 
761 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
762 
763 pragma solidity ^0.8.0;
764 
765 
766 
767 
768 
769 
770 
771 
772 /**
773  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
774  * the Metadata extension, but not including the Enumerable extension, which is available separately as
775  * {ERC721Enumerable}.
776  */
777 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
778     using Address for address;
779     using Strings for uint256;
780 
781     // Token name
782     string private _name;
783 
784     // Token symbol
785     string private _symbol;
786 
787     // Mapping from token ID to owner address
788     mapping(uint256 => address) private _owners;
789 
790     // Mapping owner address to token count
791     mapping(address => uint256) private _balances;
792 
793     // Mapping from token ID to approved address
794     mapping(uint256 => address) private _tokenApprovals;
795 
796     // Mapping from owner to operator approvals
797     mapping(address => mapping(address => bool)) private _operatorApprovals;
798 
799     /**
800      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
801      */
802     constructor(string memory name_, string memory symbol_) {
803         _name = name_;
804         _symbol = symbol_;
805     }
806 
807     /**
808      * @dev See {IERC165-supportsInterface}.
809      */
810     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
811         return
812             interfaceId == type(IERC721).interfaceId ||
813             interfaceId == type(IERC721Metadata).interfaceId ||
814             super.supportsInterface(interfaceId);
815     }
816 
817     /**
818      * @dev See {IERC721-balanceOf}.
819      */
820     function balanceOf(address owner) public view virtual override returns (uint256) {
821         require(owner != address(0), "ERC721: balance query for the zero address");
822         return _balances[owner];
823     }
824 
825     /**
826      * @dev See {IERC721-ownerOf}.
827      */
828     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
829         address owner = _owners[tokenId];
830         require(owner != address(0), "ERC721: owner query for nonexistent token");
831         return owner;
832     }
833 
834     /**
835      * @dev See {IERC721Metadata-name}.
836      */
837     function name() public view virtual override returns (string memory) {
838         return _name;
839     }
840 
841     /**
842      * @dev See {IERC721Metadata-symbol}.
843      */
844     function symbol() public view virtual override returns (string memory) {
845         return _symbol;
846     }
847 
848     /**
849      * @dev See {IERC721Metadata-tokenURI}.
850      */
851     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
852         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
853 
854         string memory baseURI = _baseURI();
855         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
856     }
857 
858     /**
859      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
860      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
861      * by default, can be overridden in child contracts.
862      */
863     function _baseURI() internal view virtual returns (string memory) {
864         return "";
865     }
866 
867     /**
868      * @dev See {IERC721-approve}.
869      */
870     function approve(address to, uint256 tokenId) public virtual override {
871         address owner = ERC721.ownerOf(tokenId);
872         require(to != owner, "ERC721: approval to current owner");
873 
874         require(
875             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
876             "ERC721: approve caller is not owner nor approved for all"
877         );
878 
879         _approve(to, tokenId);
880     }
881 
882     /**
883      * @dev See {IERC721-getApproved}.
884      */
885     function getApproved(uint256 tokenId) public view virtual override returns (address) {
886         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
887 
888         return _tokenApprovals[tokenId];
889     }
890 
891     /**
892      * @dev See {IERC721-setApprovalForAll}.
893      */
894     function setApprovalForAll(address operator, bool approved) public virtual override {
895         _setApprovalForAll(_msgSender(), operator, approved);
896     }
897 
898     /**
899      * @dev See {IERC721-isApprovedForAll}.
900      */
901     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
902         return _operatorApprovals[owner][operator];
903     }
904 
905     /**
906      * @dev See {IERC721-transferFrom}.
907      */
908     function transferFrom(
909         address from,
910         address to,
911         uint256 tokenId
912     ) public virtual override {
913         //solhint-disable-next-line max-line-length
914         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
915 
916         _transfer(from, to, tokenId);
917     }
918 
919     /**
920      * @dev See {IERC721-safeTransferFrom}.
921      */
922     function safeTransferFrom(
923         address from,
924         address to,
925         uint256 tokenId
926     ) public virtual override {
927         safeTransferFrom(from, to, tokenId, "");
928     }
929 
930     /**
931      * @dev See {IERC721-safeTransferFrom}.
932      */
933     function safeTransferFrom(
934         address from,
935         address to,
936         uint256 tokenId,
937         bytes memory _data
938     ) public virtual override {
939         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
940         _safeTransfer(from, to, tokenId, _data);
941     }
942 
943     /**
944      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
945      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
946      *
947      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
948      *
949      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
950      * implement alternative mechanisms to perform token transfer, such as signature-based.
951      *
952      * Requirements:
953      *
954      * - `from` cannot be the zero address.
955      * - `to` cannot be the zero address.
956      * - `tokenId` token must exist and be owned by `from`.
957      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _safeTransfer(
962         address from,
963         address to,
964         uint256 tokenId,
965         bytes memory _data
966     ) internal virtual {
967         _transfer(from, to, tokenId);
968         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
969     }
970 
971     /**
972      * @dev Returns whether `tokenId` exists.
973      *
974      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
975      *
976      * Tokens start existing when they are minted (`_mint`),
977      * and stop existing when they are burned (`_burn`).
978      */
979     function _exists(uint256 tokenId) internal view virtual returns (bool) {
980         return _owners[tokenId] != address(0);
981     }
982 
983     /**
984      * @dev Returns whether `spender` is allowed to manage `tokenId`.
985      *
986      * Requirements:
987      *
988      * - `tokenId` must exist.
989      */
990     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
991         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
992         address owner = ERC721.ownerOf(tokenId);
993         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
994     }
995 
996     /**
997      * @dev Safely mints `tokenId` and transfers it to `to`.
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must not exist.
1002      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _safeMint(address to, uint256 tokenId) internal virtual {
1007         _safeMint(to, tokenId, "");
1008     }
1009 
1010     /**
1011      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1012      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1013      */
1014     function _safeMint(
1015         address to,
1016         uint256 tokenId,
1017         bytes memory _data
1018     ) internal virtual {
1019         _mint(to, tokenId);
1020         require(
1021             _checkOnERC721Received(address(0), to, tokenId, _data),
1022             "ERC721: transfer to non ERC721Receiver implementer"
1023         );
1024     }
1025 
1026     /**
1027      * @dev Mints `tokenId` and transfers it to `to`.
1028      *
1029      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1030      *
1031      * Requirements:
1032      *
1033      * - `tokenId` must not exist.
1034      * - `to` cannot be the zero address.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _mint(address to, uint256 tokenId) internal virtual {
1039         require(to != address(0), "ERC721: mint to the zero address");
1040         require(!_exists(tokenId), "ERC721: token already minted");
1041 
1042         _beforeTokenTransfer(address(0), to, tokenId);
1043 
1044         _balances[to] += 1;
1045         _owners[tokenId] = to;
1046 
1047         emit Transfer(address(0), to, tokenId);
1048 
1049         _afterTokenTransfer(address(0), to, tokenId);
1050     }
1051 
1052     /**
1053      * @dev Destroys `tokenId`.
1054      * The approval is cleared when the token is burned.
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must exist.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _burn(uint256 tokenId) internal virtual {
1063         address owner = ERC721.ownerOf(tokenId);
1064 
1065         _beforeTokenTransfer(owner, address(0), tokenId);
1066 
1067         // Clear approvals
1068         _approve(address(0), tokenId);
1069 
1070         _balances[owner] -= 1;
1071         delete _owners[tokenId];
1072 
1073         emit Transfer(owner, address(0), tokenId);
1074 
1075         _afterTokenTransfer(owner, address(0), tokenId);
1076     }
1077 
1078     /**
1079      * @dev Transfers `tokenId` from `from` to `to`.
1080      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1081      *
1082      * Requirements:
1083      *
1084      * - `to` cannot be the zero address.
1085      * - `tokenId` token must be owned by `from`.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _transfer(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) internal virtual {
1094         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1095         require(to != address(0), "ERC721: transfer to the zero address");
1096 
1097         _beforeTokenTransfer(from, to, tokenId);
1098 
1099         // Clear approvals from the previous owner
1100         _approve(address(0), tokenId);
1101 
1102         _balances[from] -= 1;
1103         _balances[to] += 1;
1104         _owners[tokenId] = to;
1105 
1106         emit Transfer(from, to, tokenId);
1107 
1108         _afterTokenTransfer(from, to, tokenId);
1109     }
1110 
1111     /**
1112      * @dev Approve `to` to operate on `tokenId`
1113      *
1114      * Emits a {Approval} event.
1115      */
1116     function _approve(address to, uint256 tokenId) internal virtual {
1117         _tokenApprovals[tokenId] = to;
1118         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1119     }
1120 
1121     /**
1122      * @dev Approve `operator` to operate on all of `owner` tokens
1123      *
1124      * Emits a {ApprovalForAll} event.
1125      */
1126     function _setApprovalForAll(
1127         address owner,
1128         address operator,
1129         bool approved
1130     ) internal virtual {
1131         require(owner != operator, "ERC721: approve to caller");
1132         _operatorApprovals[owner][operator] = approved;
1133         emit ApprovalForAll(owner, operator, approved);
1134     }
1135 
1136     /**
1137      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1138      * The call is not executed if the target address is not a contract.
1139      *
1140      * @param from address representing the previous owner of the given token ID
1141      * @param to target address that will receive the tokens
1142      * @param tokenId uint256 ID of the token to be transferred
1143      * @param _data bytes optional data to send along with the call
1144      * @return bool whether the call correctly returned the expected magic value
1145      */
1146     function _checkOnERC721Received(
1147         address from,
1148         address to,
1149         uint256 tokenId,
1150         bytes memory _data
1151     ) private returns (bool) {
1152         if (to.isContract()) {
1153             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1154                 return retval == IERC721Receiver.onERC721Received.selector;
1155             } catch (bytes memory reason) {
1156                 if (reason.length == 0) {
1157                     revert("ERC721: transfer to non ERC721Receiver implementer");
1158                 } else {
1159                     assembly {
1160                         revert(add(32, reason), mload(reason))
1161                     }
1162                 }
1163             }
1164         } else {
1165             return true;
1166         }
1167     }
1168 
1169     /**
1170      * @dev Hook that is called before any token transfer. This includes minting
1171      * and burning.
1172      *
1173      * Calling conditions:
1174      *
1175      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1176      * transferred to `to`.
1177      * - When `from` is zero, `tokenId` will be minted for `to`.
1178      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1179      * - `from` and `to` are never both zero.
1180      *
1181      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1182      */
1183     function _beforeTokenTransfer(
1184         address from,
1185         address to,
1186         uint256 tokenId
1187     ) internal virtual {}
1188 
1189     /**
1190      * @dev Hook that is called after any transfer of tokens. This includes
1191      * minting and burning.
1192      *
1193      * Calling conditions:
1194      *
1195      * - when `from` and `to` are both non-zero.
1196      * - `from` and `to` are never both zero.
1197      *
1198      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1199      */
1200     function _afterTokenTransfer(
1201         address from,
1202         address to,
1203         uint256 tokenId
1204     ) internal virtual {}
1205 }
1206 
1207 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1208 
1209 
1210 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Burnable.sol)
1211 
1212 pragma solidity ^0.8.0;
1213 
1214 
1215 
1216 /**
1217  * @title ERC721 Burnable Token
1218  * @dev ERC721 Token that can be burned (destroyed).
1219  */
1220 abstract contract ERC721Burnable is Context, ERC721 {
1221     /**
1222      * @dev Burns `tokenId`. See {ERC721-_burn}.
1223      *
1224      * Requirements:
1225      *
1226      * - The caller must own `tokenId` or be an approved operator.
1227      */
1228     function burn(uint256 tokenId) public virtual {
1229         //solhint-disable-next-line max-line-length
1230         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1231         _burn(tokenId);
1232     }
1233 }
1234 
1235 // File: wojak.sol
1236 
1237 
1238 
1239 pragma solidity ^0.8.13;
1240 
1241 
1242 
1243 
1244 
1245 
1246 
1247 contract wojak is Ownable, ERC721Burnable, DefaultOperatorFilterer {
1248 
1249     string private baseURI;
1250 
1251     string public uriSuffix = '.json';
1252 
1253     uint256 public max_supply = 1553;
1254 
1255     uint256 public amountMintPerAccount = 1;
1256 
1257     uint256 public currentToken = 0;
1258 
1259 
1260 
1261     event MintSuccessful(address user);
1262 
1263 
1264 
1265     constructor() ERC721("wojak", "wojak") { 
1266 
1267     }
1268 
1269 
1270 
1271     function mint() external {
1272 
1273         require(balanceOf(msg.sender) < amountMintPerAccount);
1274 
1275         require(currentToken < max_supply);
1276 
1277 
1278 
1279         currentToken += 1;
1280 
1281         _safeMint(msg.sender, currentToken);
1282 
1283         
1284 
1285         emit MintSuccessful(msg.sender);
1286 
1287     }
1288 
1289 
1290 
1291 
1292 
1293     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1294 
1295         require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1296 
1297 
1298 
1299         string memory currentBaseURI = _baseURI();
1300 
1301         return bytes(currentBaseURI).length > 0
1302 
1303             ? string(abi.encodePacked(currentBaseURI, Strings.toString(_tokenId), uriSuffix))
1304 
1305             : '';
1306 
1307     }
1308 
1309 
1310 
1311      function setBaseURI(string memory baseURI_) external onlyOwner {
1312 
1313       baseURI = baseURI_;
1314 
1315     }
1316 
1317 
1318 
1319 
1320 
1321     function _baseURI() internal view virtual override returns (string memory) {
1322 
1323       return baseURI;
1324 
1325     }
1326 
1327 
1328 
1329     function contractURI() public pure returns (string memory) {
1330 
1331         return "ipfs://QmcqDqLqfNFyVQV9t2Wvf7WJzMDT3x7YvUT6fgRz6ZX7QN/";
1332 
1333     }
1334 
1335 
1336 
1337     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1338 
1339         super.transferFrom(from, to, tokenId);
1340 
1341     }
1342 
1343 
1344 
1345     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1346 
1347         super.safeTransferFrom(from, to, tokenId);
1348 
1349     }
1350 
1351 
1352 
1353     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1354 
1355         public
1356 
1357         override
1358 
1359         onlyAllowedOperator(from)
1360 
1361     {
1362 
1363         super.safeTransferFrom(from, to, tokenId, data);
1364 
1365     }
1366 
1367 }