1 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function unregister(address addr) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 
33 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/OperatorFilterer.sol
34 
35 
36 pragma solidity ^0.8.13;
37 
38 
39 /**
40  * @title  OperatorFilterer
41  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
42  *         registrant's entries in the OperatorFilterRegistry.
43  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
44  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
45  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
46  */
47 abstract contract OperatorFilterer {
48     error OperatorNotAllowed(address operator);
49 
50     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
51         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
52 
53     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
54         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
55         // will not revert, but the contract will need to be registered with the registry once it is deployed in
56         // order for the modifier to filter addresses.
57         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
58             if (subscribe) {
59                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
60             } else {
61                 if (subscriptionOrRegistrantToCopy != address(0)) {
62                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
63                 } else {
64                     OPERATOR_FILTER_REGISTRY.register(address(this));
65                 }
66             }
67         }
68     }
69 
70     modifier onlyAllowedOperator(address from) virtual {
71         // Check registry code length to facilitate testing in environments without a deployed registry.
72         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
73             // Allow spending tokens from addresses with balance
74             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
75             // from an EOA.
76             if (from == msg.sender) {
77                 _;
78                 return;
79             }
80             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
81                 revert OperatorNotAllowed(msg.sender);
82             }
83         }
84         _;
85     }
86 
87     modifier onlyAllowedOperatorApproval(address operator) virtual {
88         // Check registry code length to facilitate testing in environments without a deployed registry.
89         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
90             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
91                 revert OperatorNotAllowed(operator);
92             }
93         }
94         _;
95     }
96 }
97 
98 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/DefaultOperatorFilterer.sol
99 
100 
101 pragma solidity ^0.8.13;
102 
103 
104 /**
105  * @title  DefaultOperatorFilterer
106  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
107  */
108 abstract contract DefaultOperatorFilterer is OperatorFilterer {
109     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
110 
111     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
112 }
113 
114 // File: @openzeppelin/contracts/utils/Strings.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev String operations.
123  */
124 library Strings {
125     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
126     uint8 private constant _ADDRESS_LENGTH = 20;
127 
128     /**
129      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
130      */
131     function toString(uint256 value) internal pure returns (string memory) {
132         // Inspired by OraclizeAPI's implementation - MIT licence
133         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
134 
135         if (value == 0) {
136             return "0";
137         }
138         uint256 temp = value;
139         uint256 digits;
140         while (temp != 0) {
141             digits++;
142             temp /= 10;
143         }
144         bytes memory buffer = new bytes(digits);
145         while (value != 0) {
146             digits -= 1;
147             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
148             value /= 10;
149         }
150         return string(buffer);
151     }
152 
153     /**
154      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
155      */
156     function toHexString(uint256 value) internal pure returns (string memory) {
157         if (value == 0) {
158             return "0x00";
159         }
160         uint256 temp = value;
161         uint256 length = 0;
162         while (temp != 0) {
163             length++;
164             temp >>= 8;
165         }
166         return toHexString(value, length);
167     }
168 
169     /**
170      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
171      */
172     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
173         bytes memory buffer = new bytes(2 * length + 2);
174         buffer[0] = "0";
175         buffer[1] = "x";
176         for (uint256 i = 2 * length + 1; i > 1; --i) {
177             buffer[i] = _HEX_SYMBOLS[value & 0xf];
178             value >>= 4;
179         }
180         require(value == 0, "Strings: hex length insufficient");
181         return string(buffer);
182     }
183 
184     /**
185      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
186      */
187     function toHexString(address addr) internal pure returns (string memory) {
188         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/Context.sol
193 
194 
195 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @dev Provides information about the current execution context, including the
201  * sender of the transaction and its data. While these are generally available
202  * via msg.sender and msg.data, they should not be accessed in such a direct
203  * manner, since when dealing with meta-transactions the account sending and
204  * paying for execution may not be the actual sender (as far as an application
205  * is concerned).
206  *
207  * This contract is only required for intermediate, library-like contracts.
208  */
209 abstract contract Context {
210     function _msgSender() internal view virtual returns (address) {
211         return msg.sender;
212     }
213 
214     function _msgData() internal view virtual returns (bytes calldata) {
215         return msg.data;
216     }
217 }
218 
219 // File: @openzeppelin/contracts/access/Ownable.sol
220 
221 
222 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
223 
224 pragma solidity ^0.8.0;
225 
226 
227 /**
228  * @dev Contract module which provides a basic access control mechanism, where
229  * there is an account (an owner) that can be granted exclusive access to
230  * specific functions.
231  *
232  * By default, the owner account will be the one that deploys the contract. This
233  * can later be changed with {transferOwnership}.
234  *
235  * This module is used through inheritance. It will make available the modifier
236  * `onlyOwner`, which can be applied to your functions to restrict their use to
237  * the owner.
238  */
239 abstract contract Ownable is Context {
240     address private _owner;
241 
242     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
243 
244     /**
245      * @dev Initializes the contract setting the deployer as the initial owner.
246      */
247     constructor() {
248         _transferOwnership(_msgSender());
249     }
250 
251     /**
252      * @dev Throws if called by any account other than the owner.
253      */
254     modifier onlyOwner() {
255         _checkOwner();
256         _;
257     }
258 
259     /**
260      * @dev Returns the address of the current owner.
261      */
262     function owner() public view virtual returns (address) {
263         return _owner;
264     }
265 
266     /**
267      * @dev Throws if the sender is not the owner.
268      */
269     function _checkOwner() internal view virtual {
270         require(owner() == _msgSender(), "Ownable: caller is not the owner");
271     }
272 
273     /**
274      * @dev Leaves the contract without owner. It will not be possible to call
275      * `onlyOwner` functions anymore. Can only be called by the current owner.
276      *
277      * NOTE: Renouncing ownership will leave the contract without an owner,
278      * thereby removing any functionality that is only available to the owner.
279      */
280     function renounceOwnership() public virtual onlyOwner {
281         _transferOwnership(address(0));
282     }
283 
284     /**
285      * @dev Transfers ownership of the contract to a new account (`newOwner`).
286      * Can only be called by the current owner.
287      */
288     function transferOwnership(address newOwner) public virtual onlyOwner {
289         require(newOwner != address(0), "Ownable: new owner is the zero address");
290         _transferOwnership(newOwner);
291     }
292 
293     /**
294      * @dev Transfers ownership of the contract to a new account (`newOwner`).
295      * Internal function without access restriction.
296      */
297     function _transferOwnership(address newOwner) internal virtual {
298         address oldOwner = _owner;
299         _owner = newOwner;
300         emit OwnershipTransferred(oldOwner, newOwner);
301     }
302 }
303 
304 // File: @openzeppelin/contracts/utils/Address.sol
305 
306 
307 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
308 
309 pragma solidity ^0.8.1;
310 
311 /**
312  * @dev Collection of functions related to the address type
313  */
314 library Address {
315     /**
316      * @dev Returns true if `account` is a contract.
317      *
318      * [IMPORTANT]
319      * ====
320      * It is unsafe to assume that an address for which this function returns
321      * false is an externally-owned account (EOA) and not a contract.
322      *
323      * Among others, `isContract` will return false for the following
324      * types of addresses:
325      *
326      *  - an externally-owned account
327      *  - a contract in construction
328      *  - an address where a contract will be created
329      *  - an address where a contract lived, but was destroyed
330      * ====
331      *
332      * [IMPORTANT]
333      * ====
334      * You shouldn't rely on `isContract` to protect against flash loan attacks!
335      *
336      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
337      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
338      * constructor.
339      * ====
340      */
341     function isContract(address account) internal view returns (bool) {
342         // This method relies on extcodesize/address.code.length, which returns 0
343         // for contracts in construction, since the code is only stored at the end
344         // of the constructor execution.
345 
346         return account.code.length > 0;
347     }
348 
349     /**
350      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
351      * `recipient`, forwarding all available gas and reverting on errors.
352      *
353      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
354      * of certain opcodes, possibly making contracts go over the 2300 gas limit
355      * imposed by `transfer`, making them unable to receive funds via
356      * `transfer`. {sendValue} removes this limitation.
357      *
358      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
359      *
360      * IMPORTANT: because control is transferred to `recipient`, care must be
361      * taken to not create reentrancy vulnerabilities. Consider using
362      * {ReentrancyGuard} or the
363      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
364      */
365     function sendValue(address payable recipient, uint256 amount) internal {
366         require(address(this).balance >= amount, "Address: insufficient balance");
367 
368         (bool success, ) = recipient.call{value: amount}("");
369         require(success, "Address: unable to send value, recipient may have reverted");
370     }
371 
372     /**
373      * @dev Performs a Solidity function call using a low level `call`. A
374      * plain `call` is an unsafe replacement for a function call: use this
375      * function instead.
376      *
377      * If `target` reverts with a revert reason, it is bubbled up by this
378      * function (like regular Solidity function calls).
379      *
380      * Returns the raw returned data. To convert to the expected return value,
381      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
382      *
383      * Requirements:
384      *
385      * - `target` must be a contract.
386      * - calling `target` with `data` must not revert.
387      *
388      * _Available since v3.1._
389      */
390     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
391         return functionCall(target, data, "Address: low-level call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
396      * `errorMessage` as a fallback revert reason when `target` reverts.
397      *
398      * _Available since v3.1._
399      */
400     function functionCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, 0, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410      * but also transferring `value` wei to `target`.
411      *
412      * Requirements:
413      *
414      * - the calling contract must have an ETH balance of at least `value`.
415      * - the called Solidity function must be `payable`.
416      *
417      * _Available since v3.1._
418      */
419     function functionCallWithValue(
420         address target,
421         bytes memory data,
422         uint256 value
423     ) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
429      * with `errorMessage` as a fallback revert reason when `target` reverts.
430      *
431      * _Available since v3.1._
432      */
433     function functionCallWithValue(
434         address target,
435         bytes memory data,
436         uint256 value,
437         string memory errorMessage
438     ) internal returns (bytes memory) {
439         require(address(this).balance >= value, "Address: insufficient balance for call");
440         require(isContract(target), "Address: call to non-contract");
441 
442         (bool success, bytes memory returndata) = target.call{value: value}(data);
443         return verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but performing a static call.
449      *
450      * _Available since v3.3._
451      */
452     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
453         return functionStaticCall(target, data, "Address: low-level static call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a static call.
459      *
460      * _Available since v3.3._
461      */
462     function functionStaticCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal view returns (bytes memory) {
467         require(isContract(target), "Address: static call to non-contract");
468 
469         (bool success, bytes memory returndata) = target.staticcall(data);
470         return verifyCallResult(success, returndata, errorMessage);
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
489     function functionDelegateCall(
490         address target,
491         bytes memory data,
492         string memory errorMessage
493     ) internal returns (bytes memory) {
494         require(isContract(target), "Address: delegate call to non-contract");
495 
496         (bool success, bytes memory returndata) = target.delegatecall(data);
497         return verifyCallResult(success, returndata, errorMessage);
498     }
499 
500     /**
501      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
502      * revert reason using the provided one.
503      *
504      * _Available since v4.3._
505      */
506     function verifyCallResult(
507         bool success,
508         bytes memory returndata,
509         string memory errorMessage
510     ) internal pure returns (bytes memory) {
511         if (success) {
512             return returndata;
513         } else {
514             // Look for revert reason and bubble it up if present
515             if (returndata.length > 0) {
516                 // The easiest way to bubble the revert reason is using memory via assembly
517                 /// @solidity memory-safe-assembly
518                 assembly {
519                     let returndata_size := mload(returndata)
520                     revert(add(32, returndata), returndata_size)
521                 }
522             } else {
523                 revert(errorMessage);
524             }
525         }
526     }
527 }
528 
529 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
530 
531 
532 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 /**
537  * @title ERC721 token receiver interface
538  * @dev Interface for any contract that wants to support safeTransfers
539  * from ERC721 asset contracts.
540  */
541 interface IERC721Receiver {
542     /**
543      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
544      * by `operator` from `from`, this function is called.
545      *
546      * It must return its Solidity selector to confirm the token transfer.
547      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
548      *
549      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
550      */
551     function onERC721Received(
552         address operator,
553         address from,
554         uint256 tokenId,
555         bytes calldata data
556     ) external returns (bytes4);
557 }
558 
559 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev Interface of the ERC165 standard, as defined in the
568  * https://eips.ethereum.org/EIPS/eip-165[EIP].
569  *
570  * Implementers can declare support of contract interfaces, which can then be
571  * queried by others ({ERC165Checker}).
572  *
573  * For an implementation, see {ERC165}.
574  */
575 interface IERC165 {
576     /**
577      * @dev Returns true if this contract implements the interface defined by
578      * `interfaceId`. See the corresponding
579      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
580      * to learn more about how these ids are created.
581      *
582      * This function call must use less than 30 000 gas.
583      */
584     function supportsInterface(bytes4 interfaceId) external view returns (bool);
585 }
586 
587 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
588 
589 
590 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 
595 /**
596  * @dev Implementation of the {IERC165} interface.
597  *
598  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
599  * for the additional interface id that will be supported. For example:
600  *
601  * ```solidity
602  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
603  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
604  * }
605  * ```
606  *
607  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
608  */
609 abstract contract ERC165 is IERC165 {
610     /**
611      * @dev See {IERC165-supportsInterface}.
612      */
613     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
614         return interfaceId == type(IERC165).interfaceId;
615     }
616 }
617 
618 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
619 
620 
621 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
622 
623 pragma solidity ^0.8.0;
624 
625 
626 /**
627  * @dev Required interface of an ERC721 compliant contract.
628  */
629 interface IERC721 is IERC165 {
630     /**
631      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
632      */
633     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
634 
635     /**
636      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
637      */
638     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
639 
640     /**
641      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
642      */
643     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
644 
645     /**
646      * @dev Returns the number of tokens in ``owner``'s account.
647      */
648     function balanceOf(address owner) external view returns (uint256 balance);
649 
650     /**
651      * @dev Returns the owner of the `tokenId` token.
652      *
653      * Requirements:
654      *
655      * - `tokenId` must exist.
656      */
657     function ownerOf(uint256 tokenId) external view returns (address owner);
658 
659     /**
660      * @dev Safely transfers `tokenId` token from `from` to `to`.
661      *
662      * Requirements:
663      *
664      * - `from` cannot be the zero address.
665      * - `to` cannot be the zero address.
666      * - `tokenId` token must exist and be owned by `from`.
667      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
668      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
669      *
670      * Emits a {Transfer} event.
671      */
672     function safeTransferFrom(
673         address from,
674         address to,
675         uint256 tokenId,
676         bytes calldata data
677     ) external;
678 
679     /**
680      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
681      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
682      *
683      * Requirements:
684      *
685      * - `from` cannot be the zero address.
686      * - `to` cannot be the zero address.
687      * - `tokenId` token must exist and be owned by `from`.
688      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
689      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
690      *
691      * Emits a {Transfer} event.
692      */
693     function safeTransferFrom(
694         address from,
695         address to,
696         uint256 tokenId
697     ) external;
698 
699     /**
700      * @dev Transfers `tokenId` token from `from` to `to`.
701      *
702      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
703      *
704      * Requirements:
705      *
706      * - `from` cannot be the zero address.
707      * - `to` cannot be the zero address.
708      * - `tokenId` token must be owned by `from`.
709      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
710      *
711      * Emits a {Transfer} event.
712      */
713     function transferFrom(
714         address from,
715         address to,
716         uint256 tokenId
717     ) external;
718 
719     /**
720      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
721      * The approval is cleared when the token is transferred.
722      *
723      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
724      *
725      * Requirements:
726      *
727      * - The caller must own the token or be an approved operator.
728      * - `tokenId` must exist.
729      *
730      * Emits an {Approval} event.
731      */
732     function approve(address to, uint256 tokenId) external;
733 
734     /**
735      * @dev Approve or remove `operator` as an operator for the caller.
736      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
737      *
738      * Requirements:
739      *
740      * - The `operator` cannot be the caller.
741      *
742      * Emits an {ApprovalForAll} event.
743      */
744     function setApprovalForAll(address operator, bool _approved) external;
745 
746     /**
747      * @dev Returns the account approved for `tokenId` token.
748      *
749      * Requirements:
750      *
751      * - `tokenId` must exist.
752      */
753     function getApproved(uint256 tokenId) external view returns (address operator);
754 
755     /**
756      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
757      *
758      * See {setApprovalForAll}
759      */
760     function isApprovedForAll(address owner, address operator) external view returns (bool);
761 }
762 
763 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
764 
765 
766 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
767 
768 pragma solidity ^0.8.0;
769 
770 
771 /**
772  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
773  * @dev See https://eips.ethereum.org/EIPS/eip-721
774  */
775 interface IERC721Metadata is IERC721 {
776     /**
777      * @dev Returns the token collection name.
778      */
779     function name() external view returns (string memory);
780 
781     /**
782      * @dev Returns the token collection symbol.
783      */
784     function symbol() external view returns (string memory);
785 
786     /**
787      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
788      */
789     function tokenURI(uint256 tokenId) external view returns (string memory);
790 }
791 
792 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
793 
794 
795 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
796 
797 pragma solidity ^0.8.0;
798 
799 
800 
801 
802 
803 
804 
805 
806 /**
807  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
808  * the Metadata extension, but not including the Enumerable extension, which is available separately as
809  * {ERC721Enumerable}.
810  */
811 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
812     using Address for address;
813     using Strings for uint256;
814 
815     // Token name
816     string private _name;
817 
818     // Token symbol
819     string private _symbol;
820 
821     // Mapping from token ID to owner address
822     mapping(uint256 => address) private _owners;
823 
824     // Mapping owner address to token count
825     mapping(address => uint256) private _balances;
826 
827     // Mapping from token ID to approved address
828     mapping(uint256 => address) private _tokenApprovals;
829 
830     // Mapping from owner to operator approvals
831     mapping(address => mapping(address => bool)) private _operatorApprovals;
832 
833     /**
834      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
835      */
836     constructor(string memory name_, string memory symbol_) {
837         _name = name_;
838         _symbol = symbol_;
839     }
840 
841     /**
842      * @dev See {IERC165-supportsInterface}.
843      */
844     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
845         return
846             interfaceId == type(IERC721).interfaceId ||
847             interfaceId == type(IERC721Metadata).interfaceId ||
848             super.supportsInterface(interfaceId);
849     }
850 
851     /**
852      * @dev See {IERC721-balanceOf}.
853      */
854     function balanceOf(address owner) public view virtual override returns (uint256) {
855         require(owner != address(0), "ERC721: address zero is not a valid owner");
856         return _balances[owner];
857     }
858 
859     /**
860      * @dev See {IERC721-ownerOf}.
861      */
862     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
863         address owner = _owners[tokenId];
864         require(owner != address(0), "ERC721: invalid token ID");
865         return owner;
866     }
867 
868     /**
869      * @dev See {IERC721Metadata-name}.
870      */
871     function name() public view virtual override returns (string memory) {
872         return _name;
873     }
874 
875     /**
876      * @dev See {IERC721Metadata-symbol}.
877      */
878     function symbol() public view virtual override returns (string memory) {
879         return _symbol;
880     }
881 
882     /**
883      * @dev See {IERC721Metadata-tokenURI}.
884      */
885     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
886         _requireMinted(tokenId);
887 
888         string memory baseURI = _baseURI();
889         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
890     }
891 
892     /**
893      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
894      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
895      * by default, can be overridden in child contracts.
896      */
897     function _baseURI() internal view virtual returns (string memory) {
898         return "";
899     }
900 
901     /**
902      * @dev See {IERC721-approve}.
903      */
904     function approve(address to, uint256 tokenId) public virtual override {
905         address owner = ERC721.ownerOf(tokenId);
906         require(to != owner, "ERC721: approval to current owner");
907 
908         require(
909             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
910             "ERC721: approve caller is not token owner nor approved for all"
911         );
912 
913         _approve(to, tokenId);
914     }
915 
916     /**
917      * @dev See {IERC721-getApproved}.
918      */
919     function getApproved(uint256 tokenId) public view virtual override returns (address) {
920         _requireMinted(tokenId);
921 
922         return _tokenApprovals[tokenId];
923     }
924 
925     /**
926      * @dev See {IERC721-setApprovalForAll}.
927      */
928     function setApprovalForAll(address operator, bool approved) public virtual override {
929         _setApprovalForAll(_msgSender(), operator, approved);
930     }
931 
932     /**
933      * @dev See {IERC721-isApprovedForAll}.
934      */
935     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
936         return _operatorApprovals[owner][operator];
937     }
938 
939     /**
940      * @dev See {IERC721-transferFrom}.
941      */
942     function transferFrom(
943         address from,
944         address to,
945         uint256 tokenId
946     ) public virtual override {
947         //solhint-disable-next-line max-line-length
948         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
949 
950         _transfer(from, to, tokenId);
951     }
952 
953     /**
954      * @dev See {IERC721-safeTransferFrom}.
955      */
956     function safeTransferFrom(
957         address from,
958         address to,
959         uint256 tokenId
960     ) public virtual override {
961         safeTransferFrom(from, to, tokenId, "");
962     }
963 
964     /**
965      * @dev See {IERC721-safeTransferFrom}.
966      */
967     function safeTransferFrom(
968         address from,
969         address to,
970         uint256 tokenId,
971         bytes memory data
972     ) public virtual override {
973         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
974         _safeTransfer(from, to, tokenId, data);
975     }
976 
977     /**
978      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
979      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
980      *
981      * `data` is additional data, it has no specified format and it is sent in call to `to`.
982      *
983      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
984      * implement alternative mechanisms to perform token transfer, such as signature-based.
985      *
986      * Requirements:
987      *
988      * - `from` cannot be the zero address.
989      * - `to` cannot be the zero address.
990      * - `tokenId` token must exist and be owned by `from`.
991      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
992      *
993      * Emits a {Transfer} event.
994      */
995     function _safeTransfer(
996         address from,
997         address to,
998         uint256 tokenId,
999         bytes memory data
1000     ) internal virtual {
1001         _transfer(from, to, tokenId);
1002         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1003     }
1004 
1005     /**
1006      * @dev Returns whether `tokenId` exists.
1007      *
1008      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1009      *
1010      * Tokens start existing when they are minted (`_mint`),
1011      * and stop existing when they are burned (`_burn`).
1012      */
1013     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1014         return _owners[tokenId] != address(0);
1015     }
1016 
1017     /**
1018      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1019      *
1020      * Requirements:
1021      *
1022      * - `tokenId` must exist.
1023      */
1024     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1025         address owner = ERC721.ownerOf(tokenId);
1026         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1027     }
1028 
1029     /**
1030      * @dev Safely mints `tokenId` and transfers it to `to`.
1031      *
1032      * Requirements:
1033      *
1034      * - `tokenId` must not exist.
1035      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1036      *
1037      * Emits a {Transfer} event.
1038      */
1039     function _safeMint(address to, uint256 tokenId) internal virtual {
1040         _safeMint(to, tokenId, "");
1041     }
1042 
1043     /**
1044      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1045      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1046      */
1047     function _safeMint(
1048         address to,
1049         uint256 tokenId,
1050         bytes memory data
1051     ) internal virtual {
1052         _mint(to, tokenId);
1053         require(
1054             _checkOnERC721Received(address(0), to, tokenId, data),
1055             "ERC721: transfer to non ERC721Receiver implementer"
1056         );
1057     }
1058 
1059     /**
1060      * @dev Mints `tokenId` and transfers it to `to`.
1061      *
1062      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1063      *
1064      * Requirements:
1065      *
1066      * - `tokenId` must not exist.
1067      * - `to` cannot be the zero address.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _mint(address to, uint256 tokenId) internal virtual {
1072         require(to != address(0), "ERC721: mint to the zero address");
1073         require(!_exists(tokenId), "ERC721: token already minted");
1074 
1075         _beforeTokenTransfer(address(0), to, tokenId);
1076 
1077         _balances[to] += 1;
1078         _owners[tokenId] = to;
1079 
1080         emit Transfer(address(0), to, tokenId);
1081 
1082         _afterTokenTransfer(address(0), to, tokenId);
1083     }
1084 
1085     /**
1086      * @dev Destroys `tokenId`.
1087      * The approval is cleared when the token is burned.
1088      *
1089      * Requirements:
1090      *
1091      * - `tokenId` must exist.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function _burn(uint256 tokenId) internal virtual {
1096         address owner = ERC721.ownerOf(tokenId);
1097 
1098         _beforeTokenTransfer(owner, address(0), tokenId);
1099 
1100         // Clear approvals
1101         _approve(address(0), tokenId);
1102 
1103         _balances[owner] -= 1;
1104         delete _owners[tokenId];
1105 
1106         emit Transfer(owner, address(0), tokenId);
1107 
1108         _afterTokenTransfer(owner, address(0), tokenId);
1109     }
1110 
1111     /**
1112      * @dev Transfers `tokenId` from `from` to `to`.
1113      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1114      *
1115      * Requirements:
1116      *
1117      * - `to` cannot be the zero address.
1118      * - `tokenId` token must be owned by `from`.
1119      *
1120      * Emits a {Transfer} event.
1121      */
1122     function _transfer(
1123         address from,
1124         address to,
1125         uint256 tokenId
1126     ) internal virtual {
1127         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1128         require(to != address(0), "ERC721: transfer to the zero address");
1129 
1130         _beforeTokenTransfer(from, to, tokenId);
1131 
1132         // Clear approvals from the previous owner
1133         _approve(address(0), tokenId);
1134 
1135         _balances[from] -= 1;
1136         _balances[to] += 1;
1137         _owners[tokenId] = to;
1138 
1139         emit Transfer(from, to, tokenId);
1140 
1141         _afterTokenTransfer(from, to, tokenId);
1142     }
1143 
1144     /**
1145      * @dev Approve `to` to operate on `tokenId`
1146      *
1147      * Emits an {Approval} event.
1148      */
1149     function _approve(address to, uint256 tokenId) internal virtual {
1150         _tokenApprovals[tokenId] = to;
1151         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1152     }
1153 
1154     /**
1155      * @dev Approve `operator` to operate on all of `owner` tokens
1156      *
1157      * Emits an {ApprovalForAll} event.
1158      */
1159     function _setApprovalForAll(
1160         address owner,
1161         address operator,
1162         bool approved
1163     ) internal virtual {
1164         require(owner != operator, "ERC721: approve to caller");
1165         _operatorApprovals[owner][operator] = approved;
1166         emit ApprovalForAll(owner, operator, approved);
1167     }
1168 
1169     /**
1170      * @dev Reverts if the `tokenId` has not been minted yet.
1171      */
1172     function _requireMinted(uint256 tokenId) internal view virtual {
1173         require(_exists(tokenId), "ERC721: invalid token ID");
1174     }
1175 
1176     /**
1177      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1178      * The call is not executed if the target address is not a contract.
1179      *
1180      * @param from address representing the previous owner of the given token ID
1181      * @param to target address that will receive the tokens
1182      * @param tokenId uint256 ID of the token to be transferred
1183      * @param data bytes optional data to send along with the call
1184      * @return bool whether the call correctly returned the expected magic value
1185      */
1186     function _checkOnERC721Received(
1187         address from,
1188         address to,
1189         uint256 tokenId,
1190         bytes memory data
1191     ) private returns (bool) {
1192         if (to.isContract()) {
1193             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1194                 return retval == IERC721Receiver.onERC721Received.selector;
1195             } catch (bytes memory reason) {
1196                 if (reason.length == 0) {
1197                     revert("ERC721: transfer to non ERC721Receiver implementer");
1198                 } else {
1199                     /// @solidity memory-safe-assembly
1200                     assembly {
1201                         revert(add(32, reason), mload(reason))
1202                     }
1203                 }
1204             }
1205         } else {
1206             return true;
1207         }
1208     }
1209 
1210     /**
1211      * @dev Hook that is called before any token transfer. This includes minting
1212      * and burning.
1213      *
1214      * Calling conditions:
1215      *
1216      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1217      * transferred to `to`.
1218      * - When `from` is zero, `tokenId` will be minted for `to`.
1219      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1220      * - `from` and `to` are never both zero.
1221      *
1222      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1223      */
1224     function _beforeTokenTransfer(
1225         address from,
1226         address to,
1227         uint256 tokenId
1228     ) internal virtual {}
1229 
1230     /**
1231      * @dev Hook that is called after any transfer of tokens. This includes
1232      * minting and burning.
1233      *
1234      * Calling conditions:
1235      *
1236      * - when `from` and `to` are both non-zero.
1237      * - `from` and `to` are never both zero.
1238      *
1239      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1240      */
1241     function _afterTokenTransfer(
1242         address from,
1243         address to,
1244         uint256 tokenId
1245     ) internal virtual {}
1246 }
1247 
1248 // File: contracts/AKCB.sol
1249 
1250 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1251 
1252 pragma solidity 0.8.13;
1253 
1254 
1255 
1256 
1257 contract AKCB is ERC721, DefaultOperatorFilterer, Ownable {
1258 
1259     struct BeastType {
1260         uint32 Male;
1261         uint32 Female;
1262     }
1263 
1264     uint32 public constant MAX_TOKENS = 10000;
1265     uint32 public constant MAX_EACH_TYPE = 500;
1266     uint32 private constant TOTAL_MALES = 400;
1267     uint32 private constant TOTAL_FEMALES = 100;
1268     uint32 private currentSupply = 0;
1269     uint32 private nftPerAddressLimit = 1;
1270 
1271     mapping(address => uint32) public _walletsMinted;
1272     mapping(uint => BeastType) private Supply;
1273 
1274     //---- Round based supplies
1275     string private CURR_ROUND_NAME = "Presale";
1276     uint private CURR_ROUND_TIME = 0;
1277     uint public CURR_MINT_COST = 0 ether;
1278 
1279     bytes32 private verificationHash;
1280 
1281     bool public hasSaleStarted = false;
1282     bool public onlyBeastListed = true;
1283 
1284     string public baseURI;
1285     address public uriManagerAddr;
1286     address public teamReserveAddr;
1287 
1288     modifier onlyURIManager () {
1289         require(uriManagerAddr == msg.sender, "URI Manager: caller is not the ipfs manager");
1290         _;
1291     }
1292 
1293     modifier onlyReserveAddr () {
1294         require(teamReserveAddr == msg.sender, "Reserve Address: caller is not the reserve address");
1295         _;
1296     }
1297 
1298     constructor() ERC721("a KID called BEAST", "AKCB") {
1299         uriManagerAddr = msg.sender;
1300         teamReserveAddr = msg.sender;
1301         setBaseURI("ipfs://QmXSQ88MgyAaYA81RhnCPZT93ToHbUfZCtnQoJ9x9hj1Mk/");
1302 
1303         for(uint x = 1; x<= (MAX_TOKENS/MAX_EACH_TYPE);x++)
1304         {
1305             Supply[x] = BeastType({
1306                 Male: TOTAL_MALES,
1307                 Female: TOTAL_FEMALES
1308             });
1309         }
1310     }
1311 
1312     // OpenSea Operator Filter Registry Functions https://github.com/ProjectOpenSea/operator-filter-registry
1313     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1314         super.setApprovalForAll(operator, approved);
1315     }
1316 
1317     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1318         super.approve(operator, tokenId);
1319     }
1320 
1321     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1322         super.transferFrom(from, to, tokenId);
1323     }
1324 
1325     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1326         super.safeTransferFrom(from, to, tokenId);
1327     }
1328 
1329     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1330         public
1331         override
1332         onlyAllowedOperator(from)
1333     {
1334         super.safeTransferFrom(from, to, tokenId, data);
1335     }
1336     // End Opensea Operator Filter Registry
1337 
1338     function _baseURI() internal view virtual override returns (string memory) {
1339         return baseURI;
1340     }
1341 
1342     function totalSupply() public view returns (uint)
1343     {
1344         return currentSupply;
1345     }
1346 
1347     function mintNFT(uint _typeB, uint _typeG, bytes32[] memory proof) external payable {
1348         require(msg.value >= CURR_MINT_COST, "Insufficient funds");
1349         require(hasSaleStarted == true, "Sale hasn't started");
1350         require((_walletsMinted[msg.sender] + 1) <= nftPerAddressLimit, "Max NFT per address exceeded");
1351 
1352         if(onlyBeastListed == true) {
1353             bytes32 user = keccak256(abi.encodePacked(msg.sender));
1354             require(verify(user,proof), "User is not beast listed");
1355         }
1356 
1357         _walletsMinted[msg.sender]++;
1358 
1359         _mintNFT(_typeB, _typeG);
1360     }
1361 
1362     function _mintNFT(uint _typeB, uint _typeG) internal {
1363         require(_typeB <= 20 && _typeG <= 2,"Overflow");
1364         require(currentSupply < MAX_TOKENS, "Max Supply has been reached");
1365 
1366         unchecked{
1367 
1368             BeastType memory bt = Supply[_typeB];
1369             uint selectedSupply = 0;
1370 
1371             if(_typeG == 0)
1372                 selectedSupply = bt.Male;
1373             else if(_typeG == 1)
1374                 selectedSupply = bt.Female;
1375             else {
1376                 //pseudo randomness selection between Male/Female
1377                 _typeG = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, totalSupply()))) % 2;
1378 
1379                 if(_typeG == 0) {
1380                     if(bt.Male > 0)
1381                         selectedSupply = bt.Male;
1382                     else {
1383                         selectedSupply = bt.Female;
1384                         _typeG = 1;
1385                     }
1386                 }
1387                 else if(_typeG == 1) {
1388                     if(bt.Female > 0)
1389                         selectedSupply = bt.Female;
1390                     else {
1391                         selectedSupply = bt.Male;
1392                         _typeG = 0;
1393                     }
1394                 }
1395             }
1396 
1397             require(selectedSupply > 0, "Not enough supply remaining in this type");
1398 
1399             uint theToken = (_typeB * MAX_EACH_TYPE) - (_typeG == 0 ? (selectedSupply + TOTAL_FEMALES) : selectedSupply) + 1;
1400 
1401             if(_typeG == 0)
1402                 Supply[_typeB].Male--;
1403             else
1404                 Supply[_typeB].Female--;
1405 
1406             currentSupply++;
1407             _safeMint(msg.sender, theToken);
1408         }
1409     }
1410 
1411     function getInformations() external view returns (string memory,uint256[(MAX_TOKENS/MAX_EACH_TYPE) + 1] memory,uint256[(MAX_TOKENS/MAX_EACH_TYPE) + 1] memory, uint, uint,uint,uint, bool,bool)
1412     {
1413         uint256[(MAX_TOKENS/MAX_EACH_TYPE) + 1] memory tokenIdsMale;
1414         uint256[(MAX_TOKENS/MAX_EACH_TYPE) + 1] memory tokenIdsFemale;
1415 
1416         for (uint256 i = 1; i <= (MAX_TOKENS/MAX_EACH_TYPE); i++) {
1417             tokenIdsMale[i] = Supply[i].Male;
1418             tokenIdsFemale[i] = Supply[i].Female;
1419         }
1420         return (CURR_ROUND_NAME, tokenIdsMale,tokenIdsFemale, CURR_ROUND_TIME,CURR_MINT_COST,nftPerAddressLimit, totalSupply(), hasSaleStarted, onlyBeastListed);
1421     }
1422 
1423     function verify(bytes32 user, bytes32[] memory proof) internal view returns (bool)
1424     {
1425         bytes32 computedHash = user;
1426 
1427         for (uint256 i = 0; i < proof.length; i++) {
1428             bytes32 proofElement = proof[i];
1429 
1430             if (computedHash <= proofElement) {
1431                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1432             } else {
1433                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1434             }
1435         }
1436         return computedHash == verificationHash;
1437     }
1438 
1439     //only owner functions
1440 
1441     function setNewRound(uint cost, string memory name, uint32 perAddressLimit, uint theTime, bool isOnlyBeastListed, bool saleState) external onlyOwner {
1442         CURR_MINT_COST = cost;
1443         CURR_ROUND_NAME = name;
1444         nftPerAddressLimit = perAddressLimit;
1445         CURR_ROUND_TIME = theTime;
1446         hasSaleStarted = saleState;
1447         onlyBeastListed = isOnlyBeastListed;
1448     }
1449 
1450     function setVerificationHash(bytes32 _hash) external onlyOwner
1451     {
1452         verificationHash = _hash;
1453     }
1454 
1455     function setOnlyBeastListed(bool _BeastListed) external onlyOwner {
1456         onlyBeastListed = _BeastListed;
1457     }
1458 
1459     function setBaseURI(string memory _newBaseURI) public onlyURIManager {
1460         baseURI = _newBaseURI;
1461     }
1462 
1463     function withdraw(uint amount) external onlyOwner {
1464         require(payable(msg.sender).send(amount));
1465     }
1466 
1467     function setSaleStarted(bool _state) external onlyOwner {
1468         hasSaleStarted = _state;
1469     }
1470 
1471     function setURIManager(address _uriManagerAddr) external onlyOwner {
1472         require(_uriManagerAddr != address(0), "URI Manager: new owner is the zero address");
1473         uriManagerAddr = _uriManagerAddr;
1474     }
1475 
1476     function setTeamReserveAddr(address _teamReserveAddr) external onlyOwner {
1477         require(_teamReserveAddr != address(0), "Team Reserve: new reserve holder is the zero address");
1478         teamReserveAddr = _teamReserveAddr;
1479     }
1480 
1481     // Reserves to minted first
1482     function mintReserves(uint _typeB, uint _typeG, uint amount) external onlyReserveAddr {
1483         require(_typeG <= 1,"No Random type G");
1484         if (_typeG == 0) {
1485             require(Supply[_typeB].Male - amount >= TOTAL_MALES - 40, "Only 40 for this gender can be reserved.");
1486         } else {
1487             require(Supply[_typeB].Female - amount >= TOTAL_FEMALES - 10, "Only 10 for this gender can be reserved.");
1488         }
1489         uint i;
1490         for (i = 0; i < amount; i++) {
1491             _mintNFT(_typeB, _typeG);
1492         }
1493     }
1494 
1495     function mintHoodReserve(uint _typeB) external onlyReserveAddr {
1496         require(Supply[_typeB].Male + Supply[_typeB].Female == MAX_EACH_TYPE, "Only mint reserves if none ever minted for beasthood.");
1497         uint i;
1498         for (i = 0; i < 40; i++) {
1499             _mintNFT(_typeB, 0);
1500 
1501             if (i < 10) {
1502                 _mintNFT(_typeB, 1);
1503             }
1504         }
1505     }
1506 }