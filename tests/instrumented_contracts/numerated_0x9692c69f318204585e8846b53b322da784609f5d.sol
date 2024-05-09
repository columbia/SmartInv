1 // SPDX-License-Identifier: MIT
2 //     ___                                  _ 
3 //   /'___)                   _            ( )
4 //  | (__  _   _  _ __  _ __ (_)   __     _| |
5 //  | ,__)( ) ( )( '__)( '__)| | /'__`\ /'_` |
6 //  | |   | (_) || |   | |   | |(  ___/( (_| |
7 //  (_)   `\___/'(_)   (_)   (_)`\____)`\__,_)
8 //  ...... BEARS STAY HERE V2..... NOV 2022...
9 
10 //  Opensea introduced new royalty policies so new contract was needed.
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 
23 
24 
25 
26 // File: contracts/IOperatorFilterRegistry.sol
27 
28 
29 pragma solidity ^0.8.13;
30 
31 interface IOperatorFilterRegistry {
32     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
33     function register(address registrant) external;
34     function registerAndSubscribe(address registrant, address subscription) external;
35     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
36     function updateOperator(address registrant, address operator, bool filtered) external;
37     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
38     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
39     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
40     function subscribe(address registrant, address registrantToSubscribe) external;
41     function unsubscribe(address registrant, bool copyExistingEntries) external;
42     function subscriptionOf(address addr) external returns (address registrant);
43     function subscribers(address registrant) external returns (address[] memory);
44     function subscriberAt(address registrant, uint256 index) external returns (address);
45     function copyEntriesOf(address registrant, address registrantToCopy) external;
46     function isOperatorFiltered(address registrant, address operator) external returns (bool);
47     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
48     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
49     function filteredOperators(address addr) external returns (address[] memory);
50     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
51     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
52     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
53     function isRegistered(address addr) external returns (bool);
54     function codeHashOf(address addr) external returns (bytes32);
55 }
56 
57 // File: contracts/OperatorFilterer.sol
58 
59 
60 pragma solidity ^0.8.13;
61 
62 
63 abstract contract OperatorFilterer {
64     error OperatorNotAllowed(address operator);
65 
66     IOperatorFilterRegistry constant operatorFilterRegistry =
67         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
68 
69     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
70         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
71         // will not revert, but the contract will need to be registered with the registry once it is deployed in
72         // order for the modifier to filter addresses.
73         if (address(operatorFilterRegistry).code.length > 0) {
74             if (subscribe) {
75                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
76             } else {
77                 if (subscriptionOrRegistrantToCopy != address(0)) {
78                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
79                 } else {
80                     operatorFilterRegistry.register(address(this));
81                 }
82             }
83         }
84     }
85 
86     modifier onlyAllowedOperator(address from) virtual {
87         // Check registry code length to facilitate testing in environments without a deployed registry.
88         if (address(operatorFilterRegistry).code.length > 0) {
89             // Allow spending tokens from addresses with balance
90             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
91             // from an EOA.
92             if (from == msg.sender) {
93                 _;
94                 return;
95             }
96             if (
97                 !(
98                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
99                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
100                 )
101             ) {
102                 revert OperatorNotAllowed(msg.sender);
103             }
104         }
105         _;
106     }
107 }
108 
109 // File: contracts/DefaultOperatorFilterer.sol
110 
111 
112 pragma solidity ^0.8.13;
113 
114 
115 abstract contract DefaultOperatorFilterer is OperatorFilterer {
116     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
117 
118     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
119 }
120 
121 // File: contracts/Furried.sol
122 
123 /**
124  *Submitted for verification at Etherscan.io on 2022-11-12
125 */
126 
127 pragma solidity ^0.8.0;
128 
129 abstract contract Context {
130     function _msgSender() internal view virtual returns (address) {
131         return msg.sender;
132     }
133 
134     function _msgData() internal view virtual returns (bytes calldata) {
135         return msg.data;
136     }
137 }
138 pragma solidity ^0.8.0;
139 
140 /**
141  * @dev String operations.
142  */
143 library Strings {
144     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
145 
146     /**
147      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
148      */
149     function toString(uint256 value) internal pure returns (string memory) {
150         // Inspired by OraclizeAPI's implementation - MIT licence
151         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
152 
153         if (value == 0) {
154             return "0";
155         }
156         uint256 temp = value;
157         uint256 digits;
158         while (temp != 0) {
159             digits++;
160             temp /= 10;
161         }
162         bytes memory buffer = new bytes(digits);
163         while (value != 0) {
164             digits -= 1;
165             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
166             value /= 10;
167         }
168         return string(buffer);
169     }
170 
171     /**
172      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
173      */
174     function toHexString(uint256 value) internal pure returns (string memory) {
175         if (value == 0) {
176             return "0x00";
177         }
178         uint256 temp = value;
179         uint256 length = 0;
180         while (temp != 0) {
181             length++;
182             temp >>= 8;
183         }
184         return toHexString(value, length);
185     }
186 
187     /**
188      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
189      */
190     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
191         bytes memory buffer = new bytes(2 * length + 2);
192         buffer[0] = "0";
193         buffer[1] = "x";
194         for (uint256 i = 2 * length + 1; i > 1; --i) {
195             buffer[i] = _HEX_SYMBOLS[value & 0xf];
196             value >>= 4;
197         }
198         require(value == 0, "Strings: hex length insufficient");
199         return string(buffer);
200     }
201 }
202 pragma solidity ^0.8.0;
203 
204 /**
205  * @dev Collection of functions related to the address type
206  */
207 library Address {
208     /**
209      * @dev Returns true if `account` is a contract.
210      *
211      * [IMPORTANT]
212      * ====
213      * It is unsafe to assume that an address for which this function returns
214      * false is an externally-owned account (EOA) and not a contract.
215      *
216      * Among others, `isContract` will return false for the following
217      * types of addresses:
218      *
219      *  - an externally-owned account
220      *  - a contract in construction
221      *  - an address where a contract will be created
222      *  - an address where a contract lived, but was destroyed
223      * ====
224      */
225     function isContract(address account) internal view returns (bool) {
226         // This method relies on extcodesize, which returns 0 for contracts in
227         // construction, since the code is only stored at the end of the
228         // constructor execution.
229 
230         uint256 size;
231         assembly {
232             size := extcodesize(account)
233         }
234         return size > 0;
235     }
236 
237     /**
238      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
239      * `recipient`, forwarding all available gas and reverting on errors.
240      *
241      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
242      * of certain opcodes, possibly making contracts go over the 2300 gas limit
243      * imposed by `transfer`, making them unable to receive funds via
244      * `transfer`. {sendValue} removes this limitation.
245      *
246      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
247      *
248      * IMPORTANT: because control is transferred to `recipient`, care must be
249      * taken to not create reentrancy vulnerabilities. Consider using
250      * {ReentrancyGuard} or the
251      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
252      */
253     function sendValue(address payable recipient, uint256 amount) internal {
254         require(address(this).balance >= amount, "Address: insufficient balance");
255 
256         (bool success, ) = recipient.call{value: amount}("");
257         require(success, "Address: unable to send value, recipient may have reverted");
258     }
259 
260     /**
261      * @dev Performs a Solidity function call using a low level `call`. A
262      * plain `call` is an unsafe replacement for a function call: use this
263      * function instead.
264      *
265      * If `target` reverts with a revert reason, it is bubbled up by this
266      * function (like regular Solidity function calls).
267      *
268      * Returns the raw returned data. To convert to the expected return value,
269      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
270      *
271      * Requirements:
272      *
273      * - `target` must be a contract.
274      * - calling `target` with `data` must not revert.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
279         return functionCall(target, data, "Address: low-level call failed");
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
284      * `errorMessage` as a fallback revert reason when `target` reverts.
285      *
286      * _Available since v3.1._
287      */
288     function functionCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal returns (bytes memory) {
293         return functionCallWithValue(target, data, 0, errorMessage);
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
298      * but also transferring `value` wei to `target`.
299      *
300      * Requirements:
301      *
302      * - the calling contract must have an ETH balance of at least `value`.
303      * - the called Solidity function must be `payable`.
304      *
305      * _Available since v3.1._
306      */
307     function functionCallWithValue(
308         address target,
309         bytes memory data,
310         uint256 value
311     ) internal returns (bytes memory) {
312         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
317      * with `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCallWithValue(
322         address target,
323         bytes memory data,
324         uint256 value,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         require(address(this).balance >= value, "Address: insufficient balance for call");
328         require(isContract(target), "Address: call to non-contract");
329 
330         (bool success, bytes memory returndata) = target.call{value: value}(data);
331         return verifyCallResult(success, returndata, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but performing a static call.
337      *
338      * _Available since v3.3._
339      */
340     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
341         return functionStaticCall(target, data, "Address: low-level static call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
346      * but performing a static call.
347      *
348      * _Available since v3.3._
349      */
350     function functionStaticCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal view returns (bytes memory) {
355         require(isContract(target), "Address: static call to non-contract");
356 
357         (bool success, bytes memory returndata) = target.staticcall(data);
358         return verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but performing a delegate call.
364      *
365      * _Available since v3.4._
366      */
367     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
368         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
373      * but performing a delegate call.
374      *
375      * _Available since v3.4._
376      */
377     function functionDelegateCall(
378         address target,
379         bytes memory data,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         require(isContract(target), "Address: delegate call to non-contract");
383 
384         (bool success, bytes memory returndata) = target.delegatecall(data);
385         return verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
390      * revert reason using the provided one.
391      *
392      * _Available since v4.3._
393      */
394     function verifyCallResult(
395         bool success,
396         bytes memory returndata,
397         string memory errorMessage
398     ) internal pure returns (bytes memory) {
399         if (success) {
400             return returndata;
401         } else {
402             // Look for revert reason and bubble it up if present
403             if (returndata.length > 0) {
404                 // The easiest way to bubble the revert reason is using memory via assembly
405 
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 pragma solidity ^0.8.0;
417 
418 /**
419  * @dev Interface of the ERC165 standard, as defined in the
420  * https://eips.ethereum.org/EIPS/eip-165[EIP].
421  *
422  * Implementers can declare support of contract interfaces, which can then be
423  * queried by others ({ERC165Checker}).
424  *
425  * For an implementation, see {ERC165}.
426  */
427 interface IERC165 {
428     /**
429      * @dev Returns true if this contract implements the interface defined by
430      * `interfaceId`. See the corresponding
431      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
432      * to learn more about how these ids are created.
433      *
434      * This function call must use less than 30 000 gas.
435      */
436     function supportsInterface(bytes4 interfaceId) external view returns (bool);
437 }
438 pragma solidity ^0.8.0;
439 
440 /**
441  * @title ERC721 token receiver interface
442  * @dev Interface for any contract that wants to support safeTransfers
443  * from ERC721 asset contracts.
444  */
445 interface IERC721Receiver {
446     /**
447      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
448      * by `operator` from `from`, this function is called.
449      *
450      * It must return its Solidity selector to confirm the token transfer.
451      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
452      *
453      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
454      */
455     function onERC721Received(
456         address operator,
457         address from,
458         uint256 tokenId,
459         bytes calldata data
460     ) external returns (bytes4);
461 }
462 pragma solidity ^0.8.0;
463 
464 
465 /**
466  * @dev Contract module which provides a basic access control mechanism, where
467  * there is an account (an owner) that can be granted exclusive access to
468  * specific functions.
469  *
470  * By default, the owner account will be the one that deploys the contract. This
471  * can later be changed with {transferOwnership}.
472  *
473  * This module is used through inheritance. It will make available the modifier
474  * `onlyOwner`, which can be applied to your functions to restrict their use to
475  * the owner.
476  */
477 abstract contract Ownable is Context {
478     address private _owner;
479 
480     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
481 
482     /**
483      * @dev Initializes the contract setting the deployer as the initial owner.
484      */
485     constructor() {
486         _setOwner(_msgSender());
487     }
488 
489     /**
490      * @dev Returns the address of the current owner.
491      */
492     function owner() public view virtual returns (address) {
493         return _owner;
494     }
495 
496     /**
497      * @dev Throws if called by any account other than the owner.
498      */
499     modifier onlyOwner() {
500         require(owner() == _msgSender(), "Ownable: caller is not the owner");
501         _;
502     }
503 
504     /**
505      * @dev Leaves the contract without owner. It will not be possible to call
506      * `onlyOwner` functions anymore. Can only be called by the current owner.
507      *
508      * NOTE: Renouncing ownership will leave the contract without an owner,
509      * thereby removing any functionality that is only available to the owner.
510      */
511     function renounceOwnership() public virtual onlyOwner {
512         _setOwner(address(0));
513     }
514 
515     /**
516      * @dev Transfers ownership of the contract to a new account (`newOwner`).
517      * Can only be called by the current owner.
518      */
519     function transferOwnership(address newOwner) public virtual onlyOwner {
520         require(newOwner != address(0), "Ownable: new owner is the zero address");
521         _setOwner(newOwner);
522     }
523 
524     function _setOwner(address newOwner) private {
525         address oldOwner = _owner;
526         _owner = newOwner;
527         emit OwnershipTransferred(oldOwner, newOwner);
528     }
529 }
530 pragma solidity ^0.8.0;
531 
532 
533 /**
534  * @dev Implementation of the {IERC165} interface.
535  *
536  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
537  * for the additional interface id that will be supported. For example:
538  *
539  * ```solidity
540  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
541  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
542  * }
543  * ```
544  *
545  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
546  */
547 abstract contract ERC165 is IERC165 {
548     /**
549      * @dev See {IERC165-supportsInterface}.
550      */
551     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
552         return interfaceId == type(IERC165).interfaceId;
553     }
554 }
555 pragma solidity ^0.8.0;
556 
557 
558 /**
559  * @dev Required interface of an ERC721 compliant contract.
560  */
561 interface IERC721 is IERC165 {
562     /**
563      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
564      */
565     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
566 
567     /**
568      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
569      */
570     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
571 
572     /**
573      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
574      */
575     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
576 
577     /**
578      * @dev Returns the number of tokens in ``owner``'s account.
579      */
580     function balanceOf(address owner) external view returns (uint256 balance);
581 
582     /**
583      * @dev Returns the owner of the `tokenId` token.
584      *
585      * Requirements:
586      *
587      * - `tokenId` must exist.
588      */
589     function ownerOf(uint256 tokenId) external view returns (address owner);
590 
591     /**
592      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
593      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
594      *
595      * Requirements:
596      *
597      * - `from` cannot be the zero address.
598      * - `to` cannot be the zero address.
599      * - `tokenId` token must exist and be owned by `from`.
600      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
601      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
602      *
603      * Emits a {Transfer} event.
604      */
605     function safeTransferFrom(
606         address from,
607         address to,
608         uint256 tokenId
609     ) external;
610 
611     /**
612      * @dev Transfers `tokenId` token from `from` to `to`.
613      *
614      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
615      *
616      * Requirements:
617      *
618      * - `from` cannot be the zero address.
619      * - `to` cannot be the zero address.
620      * - `tokenId` token must be owned by `from`.
621      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
622      *
623      * Emits a {Transfer} event.
624      */
625     function transferFrom(
626         address from,
627         address to,
628         uint256 tokenId
629     ) external;
630 
631     /**
632      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
633      * The approval is cleared when the token is transferred.
634      *
635      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
636      *
637      * Requirements:
638      *
639      * - The caller must own the token or be an approved operator.
640      * - `tokenId` must exist.
641      *
642      * Emits an {Approval} event.
643      */
644     function approve(address to, uint256 tokenId) external;
645 
646     /**
647      * @dev Returns the account approved for `tokenId` token.
648      *
649      * Requirements:
650      *
651      * - `tokenId` must exist.
652      */
653     function getApproved(uint256 tokenId) external view returns (address operator);
654 
655     /**
656      * @dev Approve or remove `operator` as an operator for the caller.
657      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
658      *
659      * Requirements:
660      *
661      * - The `operator` cannot be the caller.
662      *
663      * Emits an {ApprovalForAll} event.
664      */
665     function setApprovalForAll(address operator, bool _approved) external;
666 
667     /**
668      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
669      *
670      * See {setApprovalForAll}
671      */
672     function isApprovedForAll(address owner, address operator) external view returns (bool);
673 
674     /**
675      * @dev Safely transfers `tokenId` token from `from` to `to`.
676      *
677      * Requirements:
678      *
679      * - `from` cannot be the zero address.
680      * - `to` cannot be the zero address.
681      * - `tokenId` token must exist and be owned by `from`.
682      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
683      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
684      *
685      * Emits a {Transfer} event.
686      */
687     function safeTransferFrom(
688         address from,
689         address to,
690         uint256 tokenId,
691         bytes calldata data
692     ) external;
693 }
694 pragma solidity ^0.8.0;
695 
696 
697 /**
698  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
699  * @dev See https://eips.ethereum.org/EIPS/eip-721
700  */
701 interface IERC721Metadata is IERC721 {
702     /**
703      * @dev Returns the token collection name.
704      */
705     function name() external view returns (string memory);
706 
707     /**
708      * @dev Returns the token collection symbol.
709      */
710     function symbol() external view returns (string memory);
711 
712     /**
713      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
714      */
715     function tokenURI(uint256 tokenId) external view returns (string memory);
716 }
717 interface IERC721Enumerable is IERC721 {
718     /**
719      * @dev Returns the total amount of tokens stored by the contract.
720      */
721     function totalSupply() external view returns (uint256);
722 
723     /**
724      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
725      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
726      */
727     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
728 
729     /**
730      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
731      * Use along with {totalSupply} to enumerate all tokens.
732      */
733     function tokenByIndex(uint256 index) external view returns (uint256);
734 }
735 error ApprovalCallerNotOwnerNorApproved();
736 error ApprovalQueryForNonexistentToken();
737 error ApproveToCaller();
738 error ApprovalToCurrentOwner();
739 error BalanceQueryForZeroAddress();
740 error MintedQueryForZeroAddress();
741 error BurnedQueryForZeroAddress();
742 error AuxQueryForZeroAddress();
743 error MintToZeroAddress();
744 error MintZeroQuantity();
745 error OwnerIndexOutOfBounds();
746 error OwnerQueryForNonexistentToken();
747 error TokenIndexOutOfBounds();
748 error TransferCallerNotOwnerNorApproved();
749 error TransferFromIncorrectOwner();
750 error TransferToNonERC721ReceiverImplementer();
751 error TransferToZeroAddress();
752 error URIQueryForNonexistentToken();
753 
754 /**
755  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
756  * the Metadata extension. Built to optimize for lower gas during batch mints.
757  *
758  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
759  *
760  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
761  *
762  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
763  */
764 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
765     using Address for address;
766     using Strings for uint256;
767 
768     // Compiler will pack this into a single 256bit word.
769     struct TokenOwnership {
770         // The address of the owner.
771         address addr;
772         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
773         uint64 startTimestamp;
774         // Whether the token has been burned.
775         bool burned;
776     }
777 
778     // Compiler will pack this into a single 256bit word.
779     struct AddressData {
780         // Realistically, 2**64-1 is more than enough.
781         uint64 balance;
782         // Keeps track of mint count with minimal overhead for tokenomics.
783         uint64 numberMinted;
784         // Keeps track of burn count with minimal overhead for tokenomics.
785         uint64 numberBurned;
786         // For miscellaneous variable(s) pertaining to the address
787         // (e.g. number of whitelist mint slots used). 
788         // If there are multiple variables, please pack them into a uint64.
789         uint64 aux;
790     }
791 
792     // The tokenId of the next token to be minted.
793     uint256 internal _currentIndex = 1;
794 
795     // The number of tokens burned.
796     uint256 internal _burnCounter;
797 
798     // Token name
799     string private _name;
800 
801     // Token symbol
802     string private _symbol;
803 
804     // Mapping from token ID to ownership details
805     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
806     mapping(uint256 => TokenOwnership) internal _ownerships;
807 
808     // Mapping owner address to address data
809     mapping(address => AddressData) private _addressData;
810 
811     // Mapping from token ID to approved address
812     mapping(uint256 => address) private _tokenApprovals;
813 
814     // Mapping from owner to operator approvals
815     mapping(address => mapping(address => bool)) private _operatorApprovals;
816 
817     constructor(string memory name_, string memory symbol_) {
818         _name = name_;
819         _symbol = symbol_;
820     }
821 
822     /**
823      * @dev See {IERC721Enumerable-totalSupply}.
824      */
825     function totalSupply() public view returns (uint256) {
826         // Counter underflow is impossible as _burnCounter cannot be incremented
827         // more than _currentIndex times
828         unchecked {
829             return (_currentIndex - _burnCounter) - 1;    
830         }
831     }
832 
833     /**
834      * @dev See {IERC165-supportsInterface}.
835      */
836     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
837         return
838             interfaceId == type(IERC721).interfaceId ||
839             interfaceId == type(IERC721Metadata).interfaceId ||
840             super.supportsInterface(interfaceId);
841     }
842 
843     /**
844      * @dev See {IERC721-balanceOf}.
845      */
846     function balanceOf(address owner) public view override returns (uint256) {
847         if (owner == address(0)) revert BalanceQueryForZeroAddress();
848         return uint256(_addressData[owner].balance);
849     }
850 
851     /**
852      * Returns the number of tokens minted by `owner`.
853      */
854     function _numberMinted(address owner) internal view returns (uint256) {
855         if (owner == address(0)) revert MintedQueryForZeroAddress();
856         return uint256(_addressData[owner].numberMinted);
857     }
858 
859     /**
860      * Returns the number of tokens burned by or on behalf of `owner`.
861      */
862     function _numberBurned(address owner) internal view returns (uint256) {
863         if (owner == address(0)) revert BurnedQueryForZeroAddress();
864         return uint256(_addressData[owner].numberBurned);
865     }
866 
867     /**
868      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
869      */
870     function _getAux(address owner) internal view returns (uint64) {
871         if (owner == address(0)) revert AuxQueryForZeroAddress();
872         return _addressData[owner].aux;
873     }
874 
875     /**
876      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
877      * If there are multiple variables, please pack them into a uint64.
878      */
879     function _setAux(address owner, uint64 aux) internal {
880         if (owner == address(0)) revert AuxQueryForZeroAddress();
881         _addressData[owner].aux = aux;
882     }
883 
884     /**
885      * Gas spent here starts off proportional to the maximum mint batch size.
886      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
887      */
888     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
889         uint256 curr = tokenId;
890 
891         unchecked {
892             if (curr < _currentIndex) {
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
919         return ownershipOf(tokenId).addr;
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
981     function setApprovalForAll(address operator, bool approved) public override {
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
1027         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
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
1040         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1041     }
1042 
1043     function _safeMint(address to, uint256 quantity) internal {
1044         _safeMint(to, quantity, '');
1045     }
1046 
1047     /**
1048      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1049      *
1050      * Requirements:
1051      *
1052      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1053      * - `quantity` must be greater than 0.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _safeMint(
1058         address to,
1059         uint256 quantity,
1060         bytes memory _data
1061     ) internal {
1062         _mint(to, quantity, _data, true);
1063     }
1064 
1065     /**
1066      * @dev Mints `quantity` tokens and transfers them to `to`.
1067      *
1068      * Requirements:
1069      *
1070      * - `to` cannot be the zero address.
1071      * - `quantity` must be greater than 0.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _mint(
1076         address to,
1077         uint256 quantity,
1078         bytes memory _data,
1079         bool safe
1080     ) internal {
1081         uint256 startTokenId = _currentIndex;
1082         if (to == address(0)) revert MintToZeroAddress();
1083         if (quantity == 0) revert MintZeroQuantity();
1084 
1085         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1086 
1087         // Overflows are incredibly unrealistic.
1088         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1089         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1090         unchecked {
1091             _addressData[to].balance += uint64(quantity);
1092             _addressData[to].numberMinted += uint64(quantity);
1093 
1094             _ownerships[startTokenId].addr = to;
1095             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1096 
1097             uint256 updatedIndex = startTokenId;
1098 
1099             for (uint256 i; i < quantity; i++) {
1100                 emit Transfer(address(0), to, updatedIndex);
1101                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1102                     revert TransferToNonERC721ReceiverImplementer();
1103                 }
1104                 updatedIndex++;
1105             }
1106 
1107             _currentIndex = updatedIndex;
1108         }
1109         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1110     }
1111 
1112     /**
1113      * @dev Transfers `tokenId` from `from` to `to`.
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
1126     ) private {
1127         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1128 
1129         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1130             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1131             getApproved(tokenId) == _msgSender());
1132 
1133         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1134         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1135         if (to == address(0)) revert TransferToZeroAddress();
1136 
1137         _beforeTokenTransfers(from, to, tokenId, 1);
1138 
1139         // Clear approvals from the previous owner
1140         _approve(address(0), tokenId, prevOwnership.addr);
1141 
1142         // Underflow of the sender's balance is impossible because we check for
1143         // ownership above and the recipient's balance can't realistically overflow.
1144         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1145         unchecked {
1146             _addressData[from].balance -= 1;
1147             _addressData[to].balance += 1;
1148 
1149             _ownerships[tokenId].addr = to;
1150             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1151 
1152             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1153             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1154             uint256 nextTokenId = tokenId + 1;
1155             if (_ownerships[nextTokenId].addr == address(0)) {
1156                 // This will suffice for checking _exists(nextTokenId),
1157                 // as a burned slot cannot contain the zero address.
1158                 if (nextTokenId < _currentIndex) {
1159                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1160                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1161                 }
1162             }
1163         }
1164 
1165         emit Transfer(from, to, tokenId);
1166         _afterTokenTransfers(from, to, tokenId, 1);
1167     }
1168 
1169     /**
1170      * @dev Destroys `tokenId`.
1171      * The approval is cleared when the token is burned.
1172      *
1173      * Requirements:
1174      *
1175      * - `tokenId` must exist.
1176      *
1177      * Emits a {Transfer} event.
1178      */
1179     function _burn(uint256 tokenId) internal virtual {
1180         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1181 
1182         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1183 
1184         // Clear approvals from the previous owner
1185         _approve(address(0), tokenId, prevOwnership.addr);
1186 
1187         // Underflow of the sender's balance is impossible because we check for
1188         // ownership above and the recipient's balance can't realistically overflow.
1189         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1190         unchecked {
1191             _addressData[prevOwnership.addr].balance -= 1;
1192             _addressData[prevOwnership.addr].numberBurned += 1;
1193 
1194             // Keep track of who burned the token, and the timestamp of burning.
1195             _ownerships[tokenId].addr = prevOwnership.addr;
1196             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1197             _ownerships[tokenId].burned = true;
1198 
1199             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1200             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1201             uint256 nextTokenId = tokenId + 1;
1202             if (_ownerships[nextTokenId].addr == address(0)) {
1203                 // This will suffice for checking _exists(nextTokenId),
1204                 // as a burned slot cannot contain the zero address.
1205                 if (nextTokenId < _currentIndex) {
1206                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1207                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1208                 }
1209             }
1210         }
1211 
1212         emit Transfer(prevOwnership.addr, address(0), tokenId);
1213         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1214 
1215         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1216         unchecked { 
1217             _burnCounter++;
1218         }
1219     }
1220 
1221     /**
1222      * @dev Approve `to` to operate on `tokenId`
1223      *
1224      * Emits a {Approval} event.
1225      */
1226     function _approve(
1227         address to,
1228         uint256 tokenId,
1229         address owner
1230     ) private {
1231         _tokenApprovals[tokenId] = to;
1232         emit Approval(owner, to, tokenId);
1233     }
1234 
1235     /**
1236      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1237      * The call is not executed if the target address is not a contract.
1238      *
1239      * @param from address representing the previous owner of the given token ID
1240      * @param to target address that will receive the tokens
1241      * @param tokenId uint256 ID of the token to be transferred
1242      * @param _data bytes optional data to send along with the call
1243      * @return bool whether the call correctly returned the expected magic value
1244      */
1245     function _checkOnERC721Received(
1246         address from,
1247         address to,
1248         uint256 tokenId,
1249         bytes memory _data
1250     ) private returns (bool) {
1251         if (to.isContract()) {
1252             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1253                 return retval == IERC721Receiver(to).onERC721Received.selector;
1254             } catch (bytes memory reason) {
1255                 if (reason.length == 0) {
1256                     revert TransferToNonERC721ReceiverImplementer();
1257                 } else {
1258                     assembly {
1259                         revert(add(32, reason), mload(reason))
1260                     }
1261                 }
1262             }
1263         } else {
1264             return true;
1265         }
1266     }
1267 
1268     /**
1269      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1270      * And also called before burning one token.
1271      *
1272      * startTokenId - the first token id to be transferred
1273      * quantity - the amount to be transferred
1274      *
1275      * Calling conditions:
1276      *
1277      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1278      * transferred to `to`.
1279      * - When `from` is zero, `tokenId` will be minted for `to`.
1280      * - When `to` is zero, `tokenId` will be burned by `from`.
1281      * - `from` and `to` are never both zero.
1282      */
1283     function _beforeTokenTransfers(
1284         address from,
1285         address to,
1286         uint256 startTokenId,
1287         uint256 quantity
1288     ) internal virtual {}
1289 
1290     /**
1291      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1292      * minting.
1293      * And also called after one token has been burned.
1294      *
1295      * startTokenId - the first token id to be transferred
1296      * quantity - the amount to be transferred
1297      *
1298      * Calling conditions:
1299      *
1300      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1301      * transferred to `to`.
1302      * - When `from` is zero, `tokenId` has been minted for `to`.
1303      * - When `to` is zero, `tokenId` has been burned by `from`.
1304      * - `from` and `to` are never both zero.
1305      */
1306     function _afterTokenTransfers(
1307         address from,
1308         address to,
1309         uint256 startTokenId,
1310         uint256 quantity
1311     ) internal virtual {}
1312 }
1313 
1314 library ECDSA {
1315     enum RecoverError {
1316         NoError,
1317         InvalidSignature,
1318         InvalidSignatureLength,
1319         InvalidSignatureS,
1320         InvalidSignatureV
1321     }
1322 
1323     function _throwError(RecoverError error) private pure {
1324         if (error == RecoverError.NoError) {
1325             return; // no error: do nothing
1326         } else if (error == RecoverError.InvalidSignature) {
1327             revert("ECDSA: invalid signature");
1328         } else if (error == RecoverError.InvalidSignatureLength) {
1329             revert("ECDSA: invalid signature length");
1330         } else if (error == RecoverError.InvalidSignatureS) {
1331             revert("ECDSA: invalid signature 's' value");
1332         } else if (error == RecoverError.InvalidSignatureV) {
1333             revert("ECDSA: invalid signature 'v' value");
1334         }
1335     }
1336 
1337     /**
1338      * @dev Returns the address that signed a hashed message (`hash`) with
1339      * `signature` or error string. This address can then be used for verification purposes.
1340      *
1341      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1342      * this function rejects them by requiring the `s` value to be in the lower
1343      * half order, and the `v` value to be either 27 or 28.
1344      *
1345      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1346      * verification to be secure: it is possible to craft signatures that
1347      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1348      * this is by receiving a hash of the original message (which may otherwise
1349      * be too long), and then calling {toEthSignedMessageHash} on it.
1350      *
1351      * Documentation for signature generation:
1352      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1353      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1354      *
1355      * _Available since v4.3._
1356      */
1357     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1358         // Check the signature length
1359         // - case 65: r,s,v signature (standard)
1360         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1361         if (signature.length == 65) {
1362             bytes32 r;
1363             bytes32 s;
1364             uint8 v;
1365             // ecrecover takes the signature parameters, and the only way to get them
1366             // currently is to use assembly.
1367             assembly {
1368                 r := mload(add(signature, 0x20))
1369                 s := mload(add(signature, 0x40))
1370                 v := byte(0, mload(add(signature, 0x60)))
1371             }
1372             return tryRecover(hash, v, r, s);
1373         } else if (signature.length == 64) {
1374             bytes32 r;
1375             bytes32 vs;
1376             // ecrecover takes the signature parameters, and the only way to get them
1377             // currently is to use assembly.
1378             assembly {
1379                 r := mload(add(signature, 0x20))
1380                 vs := mload(add(signature, 0x40))
1381             }
1382             return tryRecover(hash, r, vs);
1383         } else {
1384             return (address(0), RecoverError.InvalidSignatureLength);
1385         }
1386     }
1387 
1388     /**
1389      * @dev Returns the address that signed a hashed message (`hash`) with
1390      * `signature`. This address can then be used for verification purposes.
1391      *
1392      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1393      * this function rejects them by requiring the `s` value to be in the lower
1394      * half order, and the `v` value to be either 27 or 28.
1395      *
1396      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1397      * verification to be secure: it is possible to craft signatures that
1398      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1399      * this is by receiving a hash of the original message (which may otherwise
1400      * be too long), and then calling {toEthSignedMessageHash} on it.
1401      */
1402     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1403         (address recovered, RecoverError error) = tryRecover(hash, signature);
1404         _throwError(error);
1405         return recovered;
1406     }
1407 
1408     /**
1409      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1410      *
1411      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1412      *
1413      * _Available since v4.3._
1414      */
1415     function tryRecover(
1416         bytes32 hash,
1417         bytes32 r,
1418         bytes32 vs
1419     ) internal pure returns (address, RecoverError) {
1420         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1421         uint8 v = uint8((uint256(vs) >> 255) + 27);
1422         return tryRecover(hash, v, r, s);
1423     }
1424 
1425     /**
1426      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1427      *
1428      * _Available since v4.2._
1429      */
1430     function recover(
1431         bytes32 hash,
1432         bytes32 r,
1433         bytes32 vs
1434     ) internal pure returns (address) {
1435         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1436         _throwError(error);
1437         return recovered;
1438     }
1439 
1440     /**
1441      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1442      * `r` and `s` signature fields separately.
1443      *
1444      * _Available since v4.3._
1445      */
1446     function tryRecover(
1447         bytes32 hash,
1448         uint8 v,
1449         bytes32 r,
1450         bytes32 s
1451     ) internal pure returns (address, RecoverError) {
1452         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1453         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1454         // the valid range for s in (301): 0 < s < secp256k1n � 2 + 1, and for v in (302): v ? {27, 28}. Most
1455         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1456         //
1457         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1458         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1459         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1460         // these malleable signatures as well.
1461         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1462             return (address(0), RecoverError.InvalidSignatureS);
1463         }
1464         if (v != 27 && v != 28) {
1465             return (address(0), RecoverError.InvalidSignatureV);
1466         }
1467 
1468         // If the signature is valid (and not malleable), return the signer address
1469         address signer = ecrecover(hash, v, r, s);
1470         if (signer == address(0)) {
1471             return (address(0), RecoverError.InvalidSignature);
1472         }
1473 
1474         return (signer, RecoverError.NoError);
1475     }
1476 
1477     /**
1478      * @dev Overload of {ECDSA-recover} that receives the `v`,
1479      * `r` and `s` signature fields separately.
1480      */
1481     function recover(
1482         bytes32 hash,
1483         uint8 v,
1484         bytes32 r,
1485         bytes32 s
1486     ) internal pure returns (address) {
1487         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1488         _throwError(error);
1489         return recovered;
1490     }
1491 
1492     /**
1493      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1494      * produces hash corresponding to the one signed with the
1495      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1496      * JSON-RPC method as part of EIP-191.
1497      *
1498      * See {recover}.
1499      */
1500     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1501         // 32 is the length in bytes of hash,
1502         // enforced by the type signature above
1503         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1504     }
1505 
1506     /**
1507      * @dev Returns an Ethereum Signed Message, created from `s`. This
1508      * produces hash corresponding to the one signed with the
1509      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1510      * JSON-RPC method as part of EIP-191.
1511      *
1512      * See {recover}.
1513      */
1514     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1515         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1516     }
1517 
1518     /**
1519      * @dev Returns an Ethereum Signed Typed Data, created from a
1520      * `domainSeparator` and a `structHash`. This produces hash corresponding
1521      * to the one signed with the
1522      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1523      * JSON-RPC method as part of EIP-712.
1524      *
1525      * See {recover}.
1526      */
1527     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1528         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1529     }
1530 }
1531 abstract contract EIP712 {
1532     /* solhint-disable var-name-mixedcase */
1533     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1534     // invalidate the cached domain separator if the chain id changes.
1535     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1536     uint256 private immutable _CACHED_CHAIN_ID;
1537     address private immutable _CACHED_THIS;
1538 
1539     bytes32 private immutable _HASHED_NAME;
1540     bytes32 private immutable _HASHED_VERSION;
1541     bytes32 private immutable _TYPE_HASH;
1542 
1543     /* solhint-enable var-name-mixedcase */
1544 
1545     /**
1546      * @dev Initializes the domain separator and parameter caches.
1547      *
1548      * The meaning of `name` and `version` is specified in
1549      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1550      *
1551      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1552      * - `version`: the current major version of the signing domain.
1553      *
1554      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1555      * contract upgrade].
1556      */
1557     constructor(string memory name, string memory version) {
1558         bytes32 hashedName = keccak256(bytes(name));
1559         bytes32 hashedVersion = keccak256(bytes(version));
1560         bytes32 typeHash = keccak256(
1561             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1562         );
1563         _HASHED_NAME = hashedName;
1564         _HASHED_VERSION = hashedVersion;
1565         _CACHED_CHAIN_ID = block.chainid;
1566         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1567         _CACHED_THIS = address(this);
1568         _TYPE_HASH = typeHash;
1569     }
1570 
1571     /**
1572      * @dev Returns the domain separator for the current chain.
1573      */
1574     function _domainSeparatorV4() internal view returns (bytes32) {
1575         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1576             return _CACHED_DOMAIN_SEPARATOR;
1577         } else {
1578             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1579         }
1580     }
1581 
1582     function _buildDomainSeparator(
1583         bytes32 typeHash,
1584         bytes32 nameHash,
1585         bytes32 versionHash
1586     ) private view returns (bytes32) {
1587         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1588     }
1589 
1590     /**
1591      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1592      * function returns the hash of the fully encoded EIP712 message for this domain.
1593      *
1594      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1595      *
1596      * ```solidity
1597      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1598      *     keccak256("Mail(address to,string contents)"),
1599      *     mailTo,
1600      *     keccak256(bytes(mailContents))
1601      * )));
1602      * address signer = ECDSA.recover(digest, signature);
1603      * ```
1604      */
1605     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1606         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1607     }
1608 }
1609 
1610 contract Furried is Ownable, DefaultOperatorFilterer, ERC721A {
1611 
1612     uint256 public walletMax = 2;
1613     using Strings for uint256;
1614 
1615     mapping(uint256 => string) private _tokenURIs;
1616     bool public publicSaleOpen = false;
1617     string public baseURI = "ipfs://willbeupdated/";
1618     string public _extension = ".json";
1619     uint256 public price = 0 ether;
1620     uint256 public maxSupply = 1533;
1621 
1622     constructor() ERC721A("Furried", "FURIED"){}
1623     
1624     function mintNFT(uint256 _quantity) public payable {
1625         require(_quantity > 0 && _quantity <= walletMax, "Wallet full, check max per wallet!");
1626         require(totalSupply() + _quantity <= maxSupply, "Reached max supply!");
1627         require(msg.value == price * _quantity, "Needs to send more ETH!");
1628         require(getMintedCount(msg.sender) + _quantity <= walletMax, "Exceeded max minting amount!");
1629         require(publicSaleOpen, "Public sale not yet started!");
1630 
1631         _safeMint(msg.sender, _quantity);
1632 
1633     }
1634 
1635 
1636     function sendGifts(address[] memory _wallets) external onlyOwner{
1637         require(totalSupply() + _wallets.length <= maxSupply, "Max Supply Reached.");
1638         for(uint i = 0; i < _wallets.length; i++)
1639             _safeMint(_wallets[i], 1);
1640 
1641     }
1642    function sendGiftsToWallet(address _wallet, uint256 _num) external onlyOwner{
1643                require(totalSupply() + _num <= maxSupply, "Max Supply Reached.");
1644             _safeMint(_wallet, _num);
1645     }
1646 
1647 
1648     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1649         require(
1650             _exists(_tokenId),
1651             "ERC721Metadata: URI set of nonexistent token"
1652         );
1653 
1654         return string(abi.encodePacked(baseURI, _tokenId.toString(), _extension));
1655     }
1656 
1657     function updateBaseURI(string memory _newBaseURI) onlyOwner public {
1658         baseURI = _newBaseURI;
1659     }
1660     function updateExtension(string memory _temp) onlyOwner public {
1661         _extension = _temp;
1662     }
1663 
1664     function getBaseURI() external view returns(string memory) {
1665         return baseURI;
1666     }
1667 
1668     function setPrice(uint256 _price) public onlyOwner() {
1669         price = _price;
1670     }
1671     function setWalletMaxs(uint256 _walletMax) public onlyOwner() {
1672         walletMax = _walletMax;
1673     }
1674 
1675     function setmaxSupply(uint256 _supply) public onlyOwner() {
1676         require(_supply <= 5858, "Error: New max supply cant be higher than original max.");
1677         maxSupply = _supply;
1678     }
1679 
1680     function toggleSale() public onlyOwner() {
1681         publicSaleOpen = !publicSaleOpen;
1682     }
1683 
1684 
1685     function getBalance() public view returns(uint) {
1686         return address(this).balance;
1687     }
1688 
1689     function getMintedCount(address owner) public view returns (uint256) {
1690     return _numberMinted(owner);
1691   }
1692 
1693     function withdraw() external onlyOwner {
1694         uint _balance = address(this).balance;
1695         payable(owner()).transfer(_balance); //Owner
1696     }
1697 
1698     function getOwnershipData(uint256 tokenId)
1699     external
1700     view
1701     returns (TokenOwnership memory)
1702   {
1703     return ownershipOf(tokenId);
1704   }
1705 
1706     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1707         super.transferFrom(from, to, tokenId);
1708     }
1709     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1710         super.safeTransferFrom(from, to, tokenId);
1711     }
1712 
1713     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1714         public
1715         override
1716         onlyAllowedOperator(from)
1717     {
1718         super.safeTransferFrom(from, to, tokenId, data);
1719     }
1720 
1721 
1722     receive() external payable {}
1723 
1724 
1725 
1726 
1727 }