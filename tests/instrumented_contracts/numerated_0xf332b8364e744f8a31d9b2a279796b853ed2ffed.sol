1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Context.sol
80 
81 
82 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev Provides information about the current execution context, including the
88  * sender of the transaction and its data. While these are generally available
89  * via msg.sender and msg.data, they should not be accessed in such a direct
90  * manner, since when dealing with meta-transactions the account sending and
91  * paying for execution may not be the actual sender (as far as an application
92  * is concerned).
93  *
94  * This contract is only required for intermediate, library-like contracts.
95  */
96 abstract contract Context {
97     function _msgSender() internal view virtual returns (address) {
98         return msg.sender;
99     }
100 
101     function _msgData() internal view virtual returns (bytes calldata) {
102         return msg.data;
103     }
104 }
105 
106 // File: @openzeppelin/contracts/access/Ownable.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 
114 /**
115  * @dev Contract module which provides a basic access control mechanism, where
116  * there is an account (an owner) that can be granted exclusive access to
117  * specific functions.
118  *
119  * By default, the owner account will be the one that deploys the contract. This
120  * can later be changed with {transferOwnership}.
121  *
122  * This module is used through inheritance. It will make available the modifier
123  * `onlyOwner`, which can be applied to your functions to restrict their use to
124  * the owner.
125  */
126 abstract contract Ownable is Context {
127     address private _owner;
128 
129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131     /**
132      * @dev Initializes the contract setting the deployer as the initial owner.
133      */
134     constructor() {
135         _transferOwnership(_msgSender());
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         _checkOwner();
143         _;
144     }
145 
146     /**
147      * @dev Returns the address of the current owner.
148      */
149     function owner() public view virtual returns (address) {
150         return _owner;
151     }
152 
153     /**
154      * @dev Throws if the sender is not the owner.
155      */
156     function _checkOwner() internal view virtual {
157         require(owner() == _msgSender(), "Ownable: caller is not the owner");
158     }
159 
160     /**
161      * @dev Leaves the contract without owner. It will not be possible to call
162      * `onlyOwner` functions anymore. Can only be called by the current owner.
163      *
164      * NOTE: Renouncing ownership will leave the contract without an owner,
165      * thereby removing any functionality that is only available to the owner.
166      */
167     function renounceOwnership() public virtual onlyOwner {
168         _transferOwnership(address(0));
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public virtual onlyOwner {
176         require(newOwner != address(0), "Ownable: new owner is the zero address");
177         _transferOwnership(newOwner);
178     }
179 
180     /**
181      * @dev Transfers ownership of the contract to a new account (`newOwner`).
182      * Internal function without access restriction.
183      */
184     function _transferOwnership(address newOwner) internal virtual {
185         address oldOwner = _owner;
186         _owner = newOwner;
187         emit OwnershipTransferred(oldOwner, newOwner);
188     }
189 }
190 
191 // File: contracts/prepay.sol
192 
193 
194 pragma solidity 0.8.17;
195 
196 
197 contract prepay is Ownable {
198 
199     uint256 public currentToken = 0; //confirm number of marketing NFT prior to deploy
200     uint256 public prepayCost = .08 ether;
201     uint256 public prepayLimit = 1500;
202     uint256 public prepay_txnLimit = 10;
203     uint256 public i = 0;
204 
205     bool public prepayActive = false; // determines whether presale is active
206 
207     mapping (address => uint256) public prepaid;
208     mapping (uint256 => address) public prepayer;
209 
210 // @dev user pays for specified num of tokens, address and qty are indexed for later use by minting contract
211     function prepayment(uint256 numTokens) external payable {
212         require (prepayActive, "round inactive");
213         require (msg.value >= prepayCost*numTokens, "Incorrect value sent");
214         require (numTokens + currentToken <= prepayLimit, "No more left");
215         require (numTokens <= prepay_txnLimit);
216         if (prepaid[msg.sender] == 0) {
217             i++;
218             prepayer[i] = msg.sender;
219         }
220         prepaid[msg.sender] += numTokens;
221         currentToken += numTokens;
222     }
223 
224 // @dev checks how many NFTs an address has prepaid for
225     function prepaidQTY(address addr) external view returns (uint256) {
226         return prepaid[addr];
227     }
228 
229 // @dev check what address is in a specific prepay slot
230     function prepayerID(uint256 ID) external view returns (address) {
231         return prepayer[ID];
232     }
233 
234 // @dev flips the state for presale
235     function flipPrepay() external onlyOwner {
236         prepayActive = !prepayActive;
237     }
238 // @dev changes cost of the prepayment per token
239     function changePrepayCost(uint256 _prepayCost) external onlyOwner {
240         prepayCost = _prepayCost;
241     }
242 
243 }
244 
245 
246 // File: @openzeppelin/contracts/utils/Address.sol
247 
248 
249 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
250 
251 pragma solidity ^0.8.1;
252 
253 /**
254  * @dev Collection of functions related to the address type
255  */
256 library Address {
257     /**
258      * @dev Returns true if `account` is a contract.
259      *
260      * [IMPORTANT]
261      * ====
262      * It is unsafe to assume that an address for which this function returns
263      * false is an externally-owned account (EOA) and not a contract.
264      *
265      * Among others, `isContract` will return false for the following
266      * types of addresses:
267      *
268      *  - an externally-owned account
269      *  - a contract in construction
270      *  - an address where a contract will be created
271      *  - an address where a contract lived, but was destroyed
272      * ====
273      *
274      * [IMPORTANT]
275      * ====
276      * You shouldn't rely on `isContract` to protect against flash loan attacks!
277      *
278      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
279      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
280      * constructor.
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // This method relies on extcodesize/address.code.length, which returns 0
285         // for contracts in construction, since the code is only stored at the end
286         // of the constructor execution.
287 
288         return account.code.length > 0;
289     }
290 
291     /**
292      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
293      * `recipient`, forwarding all available gas and reverting on errors.
294      *
295      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
296      * of certain opcodes, possibly making contracts go over the 2300 gas limit
297      * imposed by `transfer`, making them unable to receive funds via
298      * `transfer`. {sendValue} removes this limitation.
299      *
300      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
301      *
302      * IMPORTANT: because control is transferred to `recipient`, care must be
303      * taken to not create reentrancy vulnerabilities. Consider using
304      * {ReentrancyGuard} or the
305      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
306      */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         (bool success, ) = recipient.call{value: amount}("");
311         require(success, "Address: unable to send value, recipient may have reverted");
312     }
313 
314     /**
315      * @dev Performs a Solidity function call using a low level `call`. A
316      * plain `call` is an unsafe replacement for a function call: use this
317      * function instead.
318      *
319      * If `target` reverts with a revert reason, it is bubbled up by this
320      * function (like regular Solidity function calls).
321      *
322      * Returns the raw returned data. To convert to the expected return value,
323      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
324      *
325      * Requirements:
326      *
327      * - `target` must be a contract.
328      * - calling `target` with `data` must not revert.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
333         return functionCall(target, data, "Address: low-level call failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
338      * `errorMessage` as a fallback revert reason when `target` reverts.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(
343         address target,
344         bytes memory data,
345         string memory errorMessage
346     ) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, 0, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but also transferring `value` wei to `target`.
353      *
354      * Requirements:
355      *
356      * - the calling contract must have an ETH balance of at least `value`.
357      * - the called Solidity function must be `payable`.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(
362         address target,
363         bytes memory data,
364         uint256 value
365     ) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
371      * with `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(
376         address target,
377         bytes memory data,
378         uint256 value,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         require(address(this).balance >= value, "Address: insufficient balance for call");
382         require(isContract(target), "Address: call to non-contract");
383 
384         (bool success, bytes memory returndata) = target.call{value: value}(data);
385         return verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but performing a static call.
391      *
392      * _Available since v3.3._
393      */
394     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
395         return functionStaticCall(target, data, "Address: low-level static call failed");
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
400      * but performing a static call.
401      *
402      * _Available since v3.3._
403      */
404     function functionStaticCall(
405         address target,
406         bytes memory data,
407         string memory errorMessage
408     ) internal view returns (bytes memory) {
409         require(isContract(target), "Address: static call to non-contract");
410 
411         (bool success, bytes memory returndata) = target.staticcall(data);
412         return verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a delegate call.
418      *
419      * _Available since v3.4._
420      */
421     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
422         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
427      * but performing a delegate call.
428      *
429      * _Available since v3.4._
430      */
431     function functionDelegateCall(
432         address target,
433         bytes memory data,
434         string memory errorMessage
435     ) internal returns (bytes memory) {
436         require(isContract(target), "Address: delegate call to non-contract");
437 
438         (bool success, bytes memory returndata) = target.delegatecall(data);
439         return verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
444      * revert reason using the provided one.
445      *
446      * _Available since v4.3._
447      */
448     function verifyCallResult(
449         bool success,
450         bytes memory returndata,
451         string memory errorMessage
452     ) internal pure returns (bytes memory) {
453         if (success) {
454             return returndata;
455         } else {
456             // Look for revert reason and bubble it up if present
457             if (returndata.length > 0) {
458                 // The easiest way to bubble the revert reason is using memory via assembly
459                 /// @solidity memory-safe-assembly
460                 assembly {
461                     let returndata_size := mload(returndata)
462                     revert(add(32, returndata), returndata_size)
463                 }
464             } else {
465                 revert(errorMessage);
466             }
467         }
468     }
469 }
470 
471 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
472 
473 
474 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
475 
476 pragma solidity ^0.8.0;
477 
478 /**
479  * @title ERC721 token receiver interface
480  * @dev Interface for any contract that wants to support safeTransfers
481  * from ERC721 asset contracts.
482  */
483 interface IERC721Receiver {
484     /**
485      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
486      * by `operator` from `from`, this function is called.
487      *
488      * It must return its Solidity selector to confirm the token transfer.
489      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
490      *
491      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
492      */
493     function onERC721Received(
494         address operator,
495         address from,
496         uint256 tokenId,
497         bytes calldata data
498     ) external returns (bytes4);
499 }
500 
501 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
502 
503 
504 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 /**
509  * @dev Interface of the ERC165 standard, as defined in the
510  * https://eips.ethereum.org/EIPS/eip-165[EIP].
511  *
512  * Implementers can declare support of contract interfaces, which can then be
513  * queried by others ({ERC165Checker}).
514  *
515  * For an implementation, see {ERC165}.
516  */
517 interface IERC165 {
518     /**
519      * @dev Returns true if this contract implements the interface defined by
520      * `interfaceId`. See the corresponding
521      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
522      * to learn more about how these ids are created.
523      *
524      * This function call must use less than 30 000 gas.
525      */
526     function supportsInterface(bytes4 interfaceId) external view returns (bool);
527 }
528 
529 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
530 
531 
532 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 
537 /**
538  * @dev Implementation of the {IERC165} interface.
539  *
540  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
541  * for the additional interface id that will be supported. For example:
542  *
543  * ```solidity
544  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
545  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
546  * }
547  * ```
548  *
549  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
550  */
551 abstract contract ERC165 is IERC165 {
552     /**
553      * @dev See {IERC165-supportsInterface}.
554      */
555     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
556         return interfaceId == type(IERC165).interfaceId;
557     }
558 }
559 
560 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
561 
562 
563 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 
568 /**
569  * @dev Required interface of an ERC721 compliant contract.
570  */
571 interface IERC721 is IERC165 {
572     /**
573      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
574      */
575     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
576 
577     /**
578      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
579      */
580     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
581 
582     /**
583      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
584      */
585     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
586 
587     /**
588      * @dev Returns the number of tokens in ``owner``'s account.
589      */
590     function balanceOf(address owner) external view returns (uint256 balance);
591 
592     /**
593      * @dev Returns the owner of the `tokenId` token.
594      *
595      * Requirements:
596      *
597      * - `tokenId` must exist.
598      */
599     function ownerOf(uint256 tokenId) external view returns (address owner);
600 
601     /**
602      * @dev Safely transfers `tokenId` token from `from` to `to`.
603      *
604      * Requirements:
605      *
606      * - `from` cannot be the zero address.
607      * - `to` cannot be the zero address.
608      * - `tokenId` token must exist and be owned by `from`.
609      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
610      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
611      *
612      * Emits a {Transfer} event.
613      */
614     function safeTransferFrom(
615         address from,
616         address to,
617         uint256 tokenId,
618         bytes calldata data
619     ) external;
620 
621     /**
622      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
623      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
624      *
625      * Requirements:
626      *
627      * - `from` cannot be the zero address.
628      * - `to` cannot be the zero address.
629      * - `tokenId` token must exist and be owned by `from`.
630      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
631      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
632      *
633      * Emits a {Transfer} event.
634      */
635     function safeTransferFrom(
636         address from,
637         address to,
638         uint256 tokenId
639     ) external;
640 
641     /**
642      * @dev Transfers `tokenId` token from `from` to `to`.
643      *
644      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
645      *
646      * Requirements:
647      *
648      * - `from` cannot be the zero address.
649      * - `to` cannot be the zero address.
650      * - `tokenId` token must be owned by `from`.
651      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
652      *
653      * Emits a {Transfer} event.
654      */
655     function transferFrom(
656         address from,
657         address to,
658         uint256 tokenId
659     ) external;
660 
661     /**
662      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
663      * The approval is cleared when the token is transferred.
664      *
665      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
666      *
667      * Requirements:
668      *
669      * - The caller must own the token or be an approved operator.
670      * - `tokenId` must exist.
671      *
672      * Emits an {Approval} event.
673      */
674     function approve(address to, uint256 tokenId) external;
675 
676     /**
677      * @dev Approve or remove `operator` as an operator for the caller.
678      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
679      *
680      * Requirements:
681      *
682      * - The `operator` cannot be the caller.
683      *
684      * Emits an {ApprovalForAll} event.
685      */
686     function setApprovalForAll(address operator, bool _approved) external;
687 
688     /**
689      * @dev Returns the account approved for `tokenId` token.
690      *
691      * Requirements:
692      *
693      * - `tokenId` must exist.
694      */
695     function getApproved(uint256 tokenId) external view returns (address operator);
696 
697     /**
698      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
699      *
700      * See {setApprovalForAll}
701      */
702     function isApprovedForAll(address owner, address operator) external view returns (bool);
703 }
704 
705 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
706 
707 
708 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
709 
710 pragma solidity ^0.8.0;
711 
712 
713 /**
714  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
715  * @dev See https://eips.ethereum.org/EIPS/eip-721
716  */
717 interface IERC721Metadata is IERC721 {
718     /**
719      * @dev Returns the token collection name.
720      */
721     function name() external view returns (string memory);
722 
723     /**
724      * @dev Returns the token collection symbol.
725      */
726     function symbol() external view returns (string memory);
727 
728     /**
729      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
730      */
731     function tokenURI(uint256 tokenId) external view returns (string memory);
732 }
733 
734 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
735 
736 
737 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
738 
739 pragma solidity ^0.8.0;
740 
741 
742 
743 
744 
745 
746 
747 
748 /**
749  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
750  * the Metadata extension, but not including the Enumerable extension, which is available separately as
751  * {ERC721Enumerable}.
752  */
753 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
754     using Address for address;
755     using Strings for uint256;
756 
757     // Token name
758     string private _name;
759 
760     // Token symbol
761     string private _symbol;
762 
763     // Mapping from token ID to owner address
764     mapping(uint256 => address) private _owners;
765 
766     // Mapping owner address to token count
767     mapping(address => uint256) private _balances;
768 
769     // Mapping from token ID to approved address
770     mapping(uint256 => address) private _tokenApprovals;
771 
772     // Mapping from owner to operator approvals
773     mapping(address => mapping(address => bool)) private _operatorApprovals;
774 
775     /**
776      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
777      */
778     constructor(string memory name_, string memory symbol_) {
779         _name = name_;
780         _symbol = symbol_;
781     }
782 
783     /**
784      * @dev See {IERC165-supportsInterface}.
785      */
786     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
787         return
788             interfaceId == type(IERC721).interfaceId ||
789             interfaceId == type(IERC721Metadata).interfaceId ||
790             super.supportsInterface(interfaceId);
791     }
792 
793     /**
794      * @dev See {IERC721-balanceOf}.
795      */
796     function balanceOf(address owner) public view virtual override returns (uint256) {
797         require(owner != address(0), "ERC721: address zero is not a valid owner");
798         return _balances[owner];
799     }
800 
801     /**
802      * @dev See {IERC721-ownerOf}.
803      */
804     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
805         address owner = _owners[tokenId];
806         require(owner != address(0), "ERC721: invalid token ID");
807         return owner;
808     }
809 
810     /**
811      * @dev See {IERC721Metadata-name}.
812      */
813     function name() public view virtual override returns (string memory) {
814         return _name;
815     }
816 
817     /**
818      * @dev See {IERC721Metadata-symbol}.
819      */
820     function symbol() public view virtual override returns (string memory) {
821         return _symbol;
822     }
823 
824     /**
825      * @dev See {IERC721Metadata-tokenURI}.
826      */
827     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
828         _requireMinted(tokenId);
829 
830         string memory baseURI = _baseURI();
831         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
832     }
833 
834     /**
835      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
836      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
837      * by default, can be overridden in child contracts.
838      */
839     function _baseURI() internal view virtual returns (string memory) {
840         return "";
841     }
842 
843     /**
844      * @dev See {IERC721-approve}.
845      */
846     function approve(address to, uint256 tokenId) public virtual override {
847         address owner = ERC721.ownerOf(tokenId);
848         require(to != owner, "ERC721: approval to current owner");
849 
850         require(
851             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
852             "ERC721: approve caller is not token owner nor approved for all"
853         );
854 
855         _approve(to, tokenId);
856     }
857 
858     /**
859      * @dev See {IERC721-getApproved}.
860      */
861     function getApproved(uint256 tokenId) public view virtual override returns (address) {
862         _requireMinted(tokenId);
863 
864         return _tokenApprovals[tokenId];
865     }
866 
867     /**
868      * @dev See {IERC721-setApprovalForAll}.
869      */
870     function setApprovalForAll(address operator, bool approved) public virtual override {
871         _setApprovalForAll(_msgSender(), operator, approved);
872     }
873 
874     /**
875      * @dev See {IERC721-isApprovedForAll}.
876      */
877     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
878         return _operatorApprovals[owner][operator];
879     }
880 
881     /**
882      * @dev See {IERC721-transferFrom}.
883      */
884     function transferFrom(
885         address from,
886         address to,
887         uint256 tokenId
888     ) public virtual override {
889         //solhint-disable-next-line max-line-length
890         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
891 
892         _transfer(from, to, tokenId);
893     }
894 
895     /**
896      * @dev See {IERC721-safeTransferFrom}.
897      */
898     function safeTransferFrom(
899         address from,
900         address to,
901         uint256 tokenId
902     ) public virtual override {
903         safeTransferFrom(from, to, tokenId, "");
904     }
905 
906     /**
907      * @dev See {IERC721-safeTransferFrom}.
908      */
909     function safeTransferFrom(
910         address from,
911         address to,
912         uint256 tokenId,
913         bytes memory data
914     ) public virtual override {
915         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
916         _safeTransfer(from, to, tokenId, data);
917     }
918 
919     /**
920      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
921      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
922      *
923      * `data` is additional data, it has no specified format and it is sent in call to `to`.
924      *
925      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
926      * implement alternative mechanisms to perform token transfer, such as signature-based.
927      *
928      * Requirements:
929      *
930      * - `from` cannot be the zero address.
931      * - `to` cannot be the zero address.
932      * - `tokenId` token must exist and be owned by `from`.
933      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
934      *
935      * Emits a {Transfer} event.
936      */
937     function _safeTransfer(
938         address from,
939         address to,
940         uint256 tokenId,
941         bytes memory data
942     ) internal virtual {
943         _transfer(from, to, tokenId);
944         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
945     }
946 
947     /**
948      * @dev Returns whether `tokenId` exists.
949      *
950      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
951      *
952      * Tokens start existing when they are minted (`_mint`),
953      * and stop existing when they are burned (`_burn`).
954      */
955     function _exists(uint256 tokenId) internal view virtual returns (bool) {
956         return _owners[tokenId] != address(0);
957     }
958 
959     /**
960      * @dev Returns whether `spender` is allowed to manage `tokenId`.
961      *
962      * Requirements:
963      *
964      * - `tokenId` must exist.
965      */
966     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
967         address owner = ERC721.ownerOf(tokenId);
968         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
969     }
970 
971     /**
972      * @dev Safely mints `tokenId` and transfers it to `to`.
973      *
974      * Requirements:
975      *
976      * - `tokenId` must not exist.
977      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _safeMint(address to, uint256 tokenId) internal virtual {
982         _safeMint(to, tokenId, "");
983     }
984 
985     /**
986      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
987      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
988      */
989     function _safeMint(
990         address to,
991         uint256 tokenId,
992         bytes memory data
993     ) internal virtual {
994         _mint(to, tokenId);
995         require(
996             _checkOnERC721Received(address(0), to, tokenId, data),
997             "ERC721: transfer to non ERC721Receiver implementer"
998         );
999     }
1000 
1001     /**
1002      * @dev Mints `tokenId` and transfers it to `to`.
1003      *
1004      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1005      *
1006      * Requirements:
1007      *
1008      * - `tokenId` must not exist.
1009      * - `to` cannot be the zero address.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _mint(address to, uint256 tokenId) internal virtual {
1014         require(to != address(0), "ERC721: mint to the zero address");
1015         require(!_exists(tokenId), "ERC721: token already minted");
1016 
1017         _beforeTokenTransfer(address(0), to, tokenId);
1018 
1019         _balances[to] += 1;
1020         _owners[tokenId] = to;
1021 
1022         emit Transfer(address(0), to, tokenId);
1023 
1024         _afterTokenTransfer(address(0), to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev Destroys `tokenId`.
1029      * The approval is cleared when the token is burned.
1030      *
1031      * Requirements:
1032      *
1033      * - `tokenId` must exist.
1034      *
1035      * Emits a {Transfer} event.
1036      */
1037     function _burn(uint256 tokenId) internal virtual {
1038         address owner = ERC721.ownerOf(tokenId);
1039 
1040         _beforeTokenTransfer(owner, address(0), tokenId);
1041 
1042         // Clear approvals
1043         _approve(address(0), tokenId);
1044 
1045         _balances[owner] -= 1;
1046         delete _owners[tokenId];
1047 
1048         emit Transfer(owner, address(0), tokenId);
1049 
1050         _afterTokenTransfer(owner, address(0), tokenId);
1051     }
1052 
1053     /**
1054      * @dev Transfers `tokenId` from `from` to `to`.
1055      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1056      *
1057      * Requirements:
1058      *
1059      * - `to` cannot be the zero address.
1060      * - `tokenId` token must be owned by `from`.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function _transfer(
1065         address from,
1066         address to,
1067         uint256 tokenId
1068     ) internal virtual {
1069         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1070         require(to != address(0), "ERC721: transfer to the zero address");
1071 
1072         _beforeTokenTransfer(from, to, tokenId);
1073 
1074         // Clear approvals from the previous owner
1075         _approve(address(0), tokenId);
1076 
1077         _balances[from] -= 1;
1078         _balances[to] += 1;
1079         _owners[tokenId] = to;
1080 
1081         emit Transfer(from, to, tokenId);
1082 
1083         _afterTokenTransfer(from, to, tokenId);
1084     }
1085 
1086     /**
1087      * @dev Approve `to` to operate on `tokenId`
1088      *
1089      * Emits an {Approval} event.
1090      */
1091     function _approve(address to, uint256 tokenId) internal virtual {
1092         _tokenApprovals[tokenId] = to;
1093         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1094     }
1095 
1096     /**
1097      * @dev Approve `operator` to operate on all of `owner` tokens
1098      *
1099      * Emits an {ApprovalForAll} event.
1100      */
1101     function _setApprovalForAll(
1102         address owner,
1103         address operator,
1104         bool approved
1105     ) internal virtual {
1106         require(owner != operator, "ERC721: approve to caller");
1107         _operatorApprovals[owner][operator] = approved;
1108         emit ApprovalForAll(owner, operator, approved);
1109     }
1110 
1111     /**
1112      * @dev Reverts if the `tokenId` has not been minted yet.
1113      */
1114     function _requireMinted(uint256 tokenId) internal view virtual {
1115         require(_exists(tokenId), "ERC721: invalid token ID");
1116     }
1117 
1118     /**
1119      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1120      * The call is not executed if the target address is not a contract.
1121      *
1122      * @param from address representing the previous owner of the given token ID
1123      * @param to target address that will receive the tokens
1124      * @param tokenId uint256 ID of the token to be transferred
1125      * @param data bytes optional data to send along with the call
1126      * @return bool whether the call correctly returned the expected magic value
1127      */
1128     function _checkOnERC721Received(
1129         address from,
1130         address to,
1131         uint256 tokenId,
1132         bytes memory data
1133     ) private returns (bool) {
1134         if (to.isContract()) {
1135             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1136                 return retval == IERC721Receiver.onERC721Received.selector;
1137             } catch (bytes memory reason) {
1138                 if (reason.length == 0) {
1139                     revert("ERC721: transfer to non ERC721Receiver implementer");
1140                 } else {
1141                     /// @solidity memory-safe-assembly
1142                     assembly {
1143                         revert(add(32, reason), mload(reason))
1144                     }
1145                 }
1146             }
1147         } else {
1148             return true;
1149         }
1150     }
1151 
1152     /**
1153      * @dev Hook that is called before any token transfer. This includes minting
1154      * and burning.
1155      *
1156      * Calling conditions:
1157      *
1158      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1159      * transferred to `to`.
1160      * - When `from` is zero, `tokenId` will be minted for `to`.
1161      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1162      * - `from` and `to` are never both zero.
1163      *
1164      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1165      */
1166     function _beforeTokenTransfer(
1167         address from,
1168         address to,
1169         uint256 tokenId
1170     ) internal virtual {}
1171 
1172     /**
1173      * @dev Hook that is called after any transfer of tokens. This includes
1174      * minting and burning.
1175      *
1176      * Calling conditions:
1177      *
1178      * - when `from` and `to` are both non-zero.
1179      * - `from` and `to` are never both zero.
1180      *
1181      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1182      */
1183     function _afterTokenTransfer(
1184         address from,
1185         address to,
1186         uint256 tokenId
1187     ) internal virtual {}
1188 }
1189 
1190 // File: @openzeppelin/contracts/utils/Counters.sol
1191 
1192 
1193 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1194 
1195 pragma solidity ^0.8.0;
1196 
1197 /**
1198  * @title Counters
1199  * @author Matt Condon (@shrugs)
1200  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1201  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1202  *
1203  * Include with `using Counters for Counters.Counter;`
1204  */
1205 library Counters {
1206     struct Counter {
1207         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1208         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1209         // this feature: see https://github.com/ethereum/solidity/issues/4637
1210         uint256 _value; // default: 0
1211     }
1212 
1213     function current(Counter storage counter) internal view returns (uint256) {
1214         return counter._value;
1215     }
1216 
1217     function increment(Counter storage counter) internal {
1218         unchecked {
1219             counter._value += 1;
1220         }
1221     }
1222 
1223     function decrement(Counter storage counter) internal {
1224         uint256 value = counter._value;
1225         require(value > 0, "Counter: decrement overflow");
1226         unchecked {
1227             counter._value = value - 1;
1228         }
1229     }
1230 
1231     function reset(Counter storage counter) internal {
1232         counter._value = 0;
1233     }
1234 }
1235 
1236 // File: contracts/MICE_mint.sol
1237 
1238 //SPDX-License-Identifier: MIT
1239 
1240 pragma solidity 0.8.17;
1241 
1242 
1243 
1244 
1245 contract MICE is ERC721, Ownable, prepay {
1246     using Counters for Counters.Counter;
1247     Counters.Counter public _tokenIds;
1248 
1249 
1250     string public ipfsHash = "ipfs://QmbcB8n4WSwhTeMi7MPRpAmBCgPAGVAjbHsAYK8HKGQEzo/Erc721_Data_";
1251     string public unrevealed = "ipfs://QmZYMwjGjZ7HFWUgwFJHxMXgDAPcMnKLyeD5H2abZEAHoZ/Erc721_Data_0.json";
1252 
1253     address artist = 0xdb049066EE25AF0Cb07feC30358F63F8B7674905;
1254     address dev = 0x1C1e33246E29DdEdd720533996292502A457C7c3; 
1255     address MW = 0x044D11A418B84e12ECF8f6184Cf06e8641e18d65;
1256     address BD = 0x7E7834576eDd58e92c57C63e41bfdAc12AaAaf9f;
1257     address PW = 0x2EDCcF4F5c3Fa61457aE9c84F736fDD6AA386322;
1258     address SL = 0x7f206725A73264EBf717965a1ae4ff111AbbBC14;
1259     address arsenal = 0x1a30791385F41F9AC738329b77Cfc103A35d0cc7;
1260 
1261     uint256 public MICEcost = .08 ether; //**** BE SURE TO UPDATE THIS
1262     uint256 public MICEpresaleCost = .08 ether; //**** BE SURE TO UPDATE THIS
1263     uint256 public maxNFT = 10000; //**** BE SURE TO UPDATE THIS
1264     uint256 public currentLimit = 2250; //**** BE SURE TO UPDATE THIS
1265     uint256 public txnLimit = 10; //**** BE SURE TO UPDATE THIS
1266 
1267     uint256 public artistPay = 50;
1268     uint256 public devPay = 100;
1269     uint256 public MWPay = 540;
1270     uint256 public BDPay = 200;
1271     uint256 public PWPay = 40;
1272     uint256 public SLPay = 50;
1273     uint256 public arsenalPay = 20;
1274     
1275     bool public presaleActive = false; // determines whether presale is active
1276     bool public saleActive = false; // determines whether sale is active
1277     bool public creditCardSaleActive = false; // determines whether creditCard is active
1278     bool public revealed = false;
1279 
1280     address crossmintAddress = 0xdAb1a1854214684acE522439684a145E62505233;
1281 
1282     constructor() ERC721("MICE NFT", "MICE") {
1283     }
1284 
1285 // @dev allows for minting at presale price
1286     function presale(uint256 numTokens) external payable {
1287         require (presaleActive, "round inactive");
1288         require (msg.value >= MICEpresaleCost*numTokens, "Incorrect value sent");
1289         require (numTokens + _tokenIds.current() <= maxNFT, "No more left");
1290         require (numTokens + _tokenIds.current() <= currentLimit, "No more left");
1291         require (numTokens <= txnLimit, "too many per txn");
1292         uint256 i = 0;
1293         while (i < numTokens) {
1294             _tokenIds.increment();
1295             _safeMint(msg.sender, _tokenIds.current());
1296             i ++;
1297         }
1298     }
1299 
1300 // @dev public minting round
1301     function sale(uint256 numTokens) external payable {
1302         require (saleActive, "round inactive");
1303         require (msg.value >= MICEcost*numTokens, "Incorrect value sent");
1304         require (numTokens + _tokenIds.current() <= maxNFT, "No more left");
1305         require (numTokens + _tokenIds.current() <= currentLimit, "No more left");
1306         require (numTokens <= txnLimit, "too many per txn");
1307         uint256 i = 0;
1308         while (i < numTokens) {
1309             _tokenIds.increment();
1310             _safeMint(msg.sender, _tokenIds.current());
1311             i ++;
1312         }
1313     }
1314 
1315 // @dev crossmint application able to utilize cc payment mechanism
1316     function crossmint(address _to) public payable {
1317         require (creditCardSaleActive, "round inactive");
1318         require (MICEcost == msg.value, "Incorrect value sent");
1319         require (1 + _tokenIds.current() <= maxNFT, "No more left");
1320         require (1 + _tokenIds.current() <= currentLimit, "No more left");
1321         require (msg.sender == crossmintAddress, "This function is for Crossmint only.");
1322         _tokenIds.increment();
1323         _safeMint(_to, _tokenIds.current());
1324     }
1325     
1326  // @dev allows for minting by the team for marketing purposes
1327     function marketingMint(uint256 numTokens, address destination) public onlyOwner {
1328         require (numTokens + _tokenIds.current() <= maxNFT, "No more left");
1329         require (numTokens + _tokenIds.current() <= currentLimit, "No more left");
1330         uint256 i = 0;
1331         while (i < numTokens) {
1332             _tokenIds.increment();
1333             _safeMint(destination, _tokenIds.current());
1334             i ++;
1335         }
1336     }
1337 
1338 // @dev flips the state for presale
1339     function flipPresale() external onlyOwner {
1340         presaleActive = !presaleActive;
1341     }
1342 
1343 // @dev flips the state for sale
1344     function flipSale() external onlyOwner {
1345         saleActive = !saleActive;
1346     }
1347 
1348 // @dev flips the state for creditCardSale
1349     function flipCreditCardSale() external onlyOwner {
1350         creditCardSaleActive = !creditCardSaleActive;
1351     }
1352 
1353     function _baseURI() internal view virtual override returns (string memory) {
1354         return ipfsHash;
1355     }
1356 
1357     function revealer() external onlyOwner {
1358         revealed = true;
1359     }
1360 
1361     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1362         _requireMinted(tokenId);
1363         string memory baseURI = _baseURI();
1364         string memory result = !revealed ? unrevealed : string.concat(baseURI, Strings.toString(tokenId), ".json");
1365         return result;
1366     }
1367 
1368     function changeMICEcost(uint256 _cost) external onlyOwner {
1369         MICEcost = _cost;
1370     }
1371 
1372     function changeMICEpresaleCost(uint256 _presaleCost) external onlyOwner {
1373         MICEpresaleCost = _presaleCost;
1374     }
1375 
1376     function changeTXNlimit(uint256 _txnLimit) external onlyOwner {
1377         txnLimit = _txnLimit;
1378     }
1379 
1380     function currentMintLimit(uint256 _currentLimit) external onlyOwner {
1381         currentLimit = _currentLimit;
1382     }
1383 
1384     function setCrossmintAddress(address _crossmintAddress) external onlyOwner {
1385         crossmintAddress = _crossmintAddress;
1386     }
1387 
1388     function withdraw() external onlyOwner returns (bool) {
1389         uint256 total = address(this).balance;
1390         uint256 balanceArtist = (total / 1000) * artistPay;
1391         uint256 balanceDev = (total / 1000) * devPay;
1392         uint256 balanceMW = (total / 1000) * MWPay;
1393         uint256 balanceBD = (total / 1000) * BDPay;
1394         uint256 balancePW = (total / 1000) * PWPay;
1395         uint256 balanceSL = (total / 1000) * SLPay;
1396         uint256 balanceArsenal = (total / 1000) * arsenalPay;
1397         payable(artist).transfer(balanceArtist);
1398         payable(dev).transfer(balanceDev);
1399         payable(MW).transfer(balanceMW);
1400         payable(BD).transfer(balanceBD);
1401         payable(PW).transfer(balancePW);
1402         payable(SL).transfer(balanceSL);
1403         payable(arsenal).transfer(balanceArsenal);
1404         return true;
1405     }
1406 
1407     function payout(uint256 start, uint256 stop) external onlyOwner {
1408         while (start <= stop) {
1409             address addy = prepayer[start];
1410             uint256 x = prepaid[addy];
1411             marketingMint(x, addy);
1412             prepaid[addy] = 0;
1413             start++;
1414         }
1415     } 
1416 
1417 }