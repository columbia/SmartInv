1 // File: @openzeppelin/contracts/utils/Counters.sol
2 // SPDX-License-Identifier: MIT
3 /**
4             *Alright Apes*
5 
6                .-"""-.
7              _/-=-.   \
8             (_|a a/   |_
9              / "  \   ,_)
10         _    \`=' /__/
11        / \_  .;--'  `-.
12        \___)//      ,  \
13         \ \/;        \  \
14          \_.|         | |
15           .-\ '     _/_/
16         .'  _;.    (_  \
17        /  .'   `\   \\_/
18       |_ /       |  |\\
19      /  _)       /  / ||
20     /  /       _/  /  //
21     \_/       ( `-/  ||
22               /  /   \\ .-.
23               \_/     \'-'/
24                        `"`
25 */
26 
27 
28 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @title Counters
34  * @author Matt Condon (@shrugs)
35  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
36  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
37  *
38  * Include with `using Counters for Counters.Counter;`
39  */
40 library Counters {
41     struct Counter {
42         // This variable should never be directly accessed by users of the library: interactions must be restricted to
43         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
44         // this feature: see https://github.com/ethereum/solidity/issues/4637
45         uint256 _value; // default: 0
46     }
47 
48     function current(Counter storage counter) internal view returns (uint256) {
49         return counter._value;
50     }
51 
52     function increment(Counter storage counter) internal {
53         unchecked {
54             counter._value += 1;
55         }
56     }
57 
58     function decrement(Counter storage counter) internal {
59         uint256 value = counter._value;
60         require(value > 0, "Counter: decrement overflow");
61         unchecked {
62             counter._value = value - 1;
63         }
64     }
65 
66     function reset(Counter storage counter) internal {
67         counter._value = 0;
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Strings.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev String operations.
80  */
81 library Strings {
82     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
83 
84     /**
85      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
86      */
87     function toString(uint256 value) internal pure returns (string memory) {
88         // Inspired by OraclizeAPI's implementation - MIT licence
89         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
90 
91         if (value == 0) {
92             return "0";
93         }
94         uint256 temp = value;
95         uint256 digits;
96         while (temp != 0) {
97             digits++;
98             temp /= 10;
99         }
100         bytes memory buffer = new bytes(digits);
101         while (value != 0) {
102             digits -= 1;
103             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
104             value /= 10;
105         }
106         return string(buffer);
107     }
108 
109     /**
110      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
111      */
112     function toHexString(uint256 value) internal pure returns (string memory) {
113         if (value == 0) {
114             return "0x00";
115         }
116         uint256 temp = value;
117         uint256 length = 0;
118         while (temp != 0) {
119             length++;
120             temp >>= 8;
121         }
122         return toHexString(value, length);
123     }
124 
125     /**
126      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
127      */
128     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
129         bytes memory buffer = new bytes(2 * length + 2);
130         buffer[0] = "0";
131         buffer[1] = "x";
132         for (uint256 i = 2 * length + 1; i > 1; --i) {
133             buffer[i] = _HEX_SYMBOLS[value & 0xf];
134             value >>= 4;
135         }
136         require(value == 0, "Strings: hex length insufficient");
137         return string(buffer);
138     }
139 }
140 
141 // File: @openzeppelin/contracts/utils/Context.sol
142 
143 
144 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
145 
146 pragma solidity ^0.8.0;
147 
148 /**
149  * @dev Provides information about the current execution context, including the
150  * sender of the transaction and its data. While these are generally available
151  * via msg.sender and msg.data, they should not be accessed in such a direct
152  * manner, since when dealing with meta-transactions the account sending and
153  * paying for execution may not be the actual sender (as far as an application
154  * is concerned).
155  *
156  * This contract is only required for intermediate, library-like contracts.
157  */
158 abstract contract Context {
159     function _msgSender() internal view virtual returns (address) {
160         return msg.sender;
161     }
162 
163     function _msgData() internal view virtual returns (bytes calldata) {
164         return msg.data;
165     }
166 }
167 
168 // File: @openzeppelin/contracts/access/Ownable.sol
169 
170 
171 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
172 
173 pragma solidity ^0.8.0;
174 
175 
176 /**
177  * @dev Contract module which provides a basic access control mechanism, where
178  * there is an account (an owner) that can be granted exclusive access to
179  * specific functions.
180  *
181  * By default, the owner account will be the one that deploys the contract. This
182  * can later be changed with {transferOwnership}.
183  *
184  * This module is used through inheritance. It will make available the modifier
185  * `onlyOwner`, which can be applied to your functions to restrict their use to
186  * the owner.
187  */
188 abstract contract Ownable is Context {
189     address private _owner;
190 
191     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
192 
193     /**
194      * @dev Initializes the contract setting the deployer as the initial owner.
195      */
196     constructor() {
197         _transferOwnership(_msgSender());
198     }
199 
200     /**
201      * @dev Returns the address of the current owner.
202      */
203     function owner() public view virtual returns (address) {
204         return _owner;
205     }
206 
207     /**
208      * @dev Throws if called by any account other than the owner.
209      */
210     modifier onlyOwner() {
211         require(owner() == _msgSender(), "Ownable: caller is not the owner");
212         _;
213     }
214 
215     /**
216      * @dev Leaves the contract without owner. It will not be possible to call
217      * `onlyOwner` functions anymore. Can only be called by the current owner.
218      *
219      * NOTE: Renouncing ownership will leave the contract without an owner,
220      * thereby removing any functionality that is only available to the owner.
221      */
222     function renounceOwnership() public virtual onlyOwner {
223         _transferOwnership(address(0));
224     }
225 
226     /**
227      * @dev Transfers ownership of the contract to a new account (`newOwner`).
228      * Can only be called by the current owner.
229      */
230     function transferOwnership(address newOwner) public virtual onlyOwner {
231         require(newOwner != address(0), "Ownable: new owner is the zero address");
232         _transferOwnership(newOwner);
233     }
234 
235     /**
236      * @dev Transfers ownership of the contract to a new account (`newOwner`).
237      * Internal function without access restriction.
238      */
239     function _transferOwnership(address newOwner) internal virtual {
240         address oldOwner = _owner;
241         _owner = newOwner;
242         emit OwnershipTransferred(oldOwner, newOwner);
243     }
244 }
245 
246 // File: @openzeppelin/contracts/utils/Address.sol
247 
248 
249 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
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
459 
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
563 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
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
630      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
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
737 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
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
797         require(owner != address(0), "ERC721: balance query for the zero address");
798         return _balances[owner];
799     }
800 
801     /**
802      * @dev See {IERC721-ownerOf}.
803      */
804     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
805         address owner = _owners[tokenId];
806         require(owner != address(0), "ERC721: owner query for nonexistent token");
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
828         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
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
852             "ERC721: approve caller is not owner nor approved for all"
853         );
854 
855         _approve(to, tokenId);
856     }
857 
858     /**
859      * @dev See {IERC721-getApproved}.
860      */
861     function getApproved(uint256 tokenId) public view virtual override returns (address) {
862         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
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
890         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
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
913         bytes memory _data
914     ) public virtual override {
915         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
916         _safeTransfer(from, to, tokenId, _data);
917     }
918 
919     /**
920      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
921      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
922      *
923      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
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
941         bytes memory _data
942     ) internal virtual {
943         _transfer(from, to, tokenId);
944         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
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
967         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
968         address owner = ERC721.ownerOf(tokenId);
969         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
970     }
971 
972     /**
973      * @dev Safely mints `tokenId` and transfers it to `to`.
974      *
975      * Requirements:
976      *
977      * - `tokenId` must not exist.
978      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _safeMint(address to, uint256 tokenId) internal virtual {
983         _safeMint(to, tokenId, "");
984     }
985 
986     /**
987      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
988      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
989      */
990     function _safeMint(
991         address to,
992         uint256 tokenId,
993         bytes memory _data
994     ) internal virtual {
995         _mint(to, tokenId);
996         require(
997             _checkOnERC721Received(address(0), to, tokenId, _data),
998             "ERC721: transfer to non ERC721Receiver implementer"
999         );
1000     }
1001 
1002     /**
1003      * @dev Mints `tokenId` and transfers it to `to`.
1004      *
1005      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1006      *
1007      * Requirements:
1008      *
1009      * - `tokenId` must not exist.
1010      * - `to` cannot be the zero address.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _mint(address to, uint256 tokenId) internal virtual {
1015         require(to != address(0), "ERC721: mint to the zero address");
1016         require(!_exists(tokenId), "ERC721: token already minted");
1017 
1018         _beforeTokenTransfer(address(0), to, tokenId);
1019 
1020         _balances[to] += 1;
1021         _owners[tokenId] = to;
1022 
1023         emit Transfer(address(0), to, tokenId);
1024 
1025         _afterTokenTransfer(address(0), to, tokenId);
1026     }
1027 
1028     /**
1029      * @dev Destroys `tokenId`.
1030      * The approval is cleared when the token is burned.
1031      *
1032      * Requirements:
1033      *
1034      * - `tokenId` must exist.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _burn(uint256 tokenId) internal virtual {
1039         address owner = ERC721.ownerOf(tokenId);
1040 
1041         _beforeTokenTransfer(owner, address(0), tokenId);
1042 
1043         // Clear approvals
1044         _approve(address(0), tokenId);
1045 
1046         _balances[owner] -= 1;
1047         delete _owners[tokenId];
1048 
1049         emit Transfer(owner, address(0), tokenId);
1050 
1051         _afterTokenTransfer(owner, address(0), tokenId);
1052     }
1053 
1054     /**
1055      * @dev Transfers `tokenId` from `from` to `to`.
1056      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1057      *
1058      * Requirements:
1059      *
1060      * - `to` cannot be the zero address.
1061      * - `tokenId` token must be owned by `from`.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function _transfer(
1066         address from,
1067         address to,
1068         uint256 tokenId
1069     ) internal virtual {
1070         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1071         require(to != address(0), "ERC721: transfer to the zero address");
1072 
1073         _beforeTokenTransfer(from, to, tokenId);
1074 
1075         // Clear approvals from the previous owner
1076         _approve(address(0), tokenId);
1077 
1078         _balances[from] -= 1;
1079         _balances[to] += 1;
1080         _owners[tokenId] = to;
1081 
1082         emit Transfer(from, to, tokenId);
1083 
1084         _afterTokenTransfer(from, to, tokenId);
1085     }
1086 
1087     /**
1088      * @dev Approve `to` to operate on `tokenId`
1089      *
1090      * Emits a {Approval} event.
1091      */
1092     function _approve(address to, uint256 tokenId) internal virtual {
1093         _tokenApprovals[tokenId] = to;
1094         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1095     }
1096 
1097     /**
1098      * @dev Approve `operator` to operate on all of `owner` tokens
1099      *
1100      * Emits a {ApprovalForAll} event.
1101      */
1102     function _setApprovalForAll(
1103         address owner,
1104         address operator,
1105         bool approved
1106     ) internal virtual {
1107         require(owner != operator, "ERC721: approve to caller");
1108         _operatorApprovals[owner][operator] = approved;
1109         emit ApprovalForAll(owner, operator, approved);
1110     }
1111 
1112     /**
1113      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1114      * The call is not executed if the target address is not a contract.
1115      *
1116      * @param from address representing the previous owner of the given token ID
1117      * @param to target address that will receive the tokens
1118      * @param tokenId uint256 ID of the token to be transferred
1119      * @param _data bytes optional data to send along with the call
1120      * @return bool whether the call correctly returned the expected magic value
1121      */
1122     function _checkOnERC721Received(
1123         address from,
1124         address to,
1125         uint256 tokenId,
1126         bytes memory _data
1127     ) private returns (bool) {
1128         if (to.isContract()) {
1129             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1130                 return retval == IERC721Receiver.onERC721Received.selector;
1131             } catch (bytes memory reason) {
1132                 if (reason.length == 0) {
1133                     revert("ERC721: transfer to non ERC721Receiver implementer");
1134                 } else {
1135                     assembly {
1136                         revert(add(32, reason), mload(reason))
1137                     }
1138                 }
1139             }
1140         } else {
1141             return true;
1142         }
1143     }
1144 
1145     /**
1146      * @dev Hook that is called before any token transfer. This includes minting
1147      * and burning.
1148      *
1149      * Calling conditions:
1150      *
1151      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1152      * transferred to `to`.
1153      * - When `from` is zero, `tokenId` will be minted for `to`.
1154      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1155      * - `from` and `to` are never both zero.
1156      *
1157      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1158      */
1159     function _beforeTokenTransfer(
1160         address from,
1161         address to,
1162         uint256 tokenId
1163     ) internal virtual {}
1164 
1165     /**
1166      * @dev Hook that is called after any transfer of tokens. This includes
1167      * minting and burning.
1168      *
1169      * Calling conditions:
1170      *
1171      * - when `from` and `to` are both non-zero.
1172      * - `from` and `to` are never both zero.
1173      *
1174      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1175      */
1176     function _afterTokenTransfer(
1177         address from,
1178         address to,
1179         uint256 tokenId
1180     ) internal virtual {}
1181 }
1182 
1183 // File: contracts/AlrightApes.sol
1184 
1185 pragma solidity >=0.7.0 <0.9.0;
1186 
1187 
1188 
1189 
1190 contract AlrightApes is ERC721, Ownable {
1191   using Strings for uint256;
1192   using Counters for Counters.Counter;
1193 
1194   Counters.Counter private supply;
1195 
1196   string public uriPrefix;
1197   string public uriSuffix = ".json";
1198   string public hiddenMetadataUri;
1199   
1200   uint256 public cost = 0.00 ether;
1201   uint256 public maxSupply = 3000;
1202   uint256 public maxMintAmountPerTx = 3;
1203 
1204   bool public paused = true;
1205   bool public revealed = false;
1206 
1207   constructor(
1208       string memory uriPrefixIn,
1209       string memory _name,
1210       string memory _symbol
1211   ) ERC721(_name, _symbol) {
1212     setHiddenMetadataUri("ipfs://QmUtPLz1qxEubf7m7KWfY3138HDJuT6AAnjaHGon7qML5x/hidden.json");
1213     setUriPrefix(uriPrefixIn);
1214   }
1215 
1216   modifier mintCompliance(uint256 _mintAmount) {
1217     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1218     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1219     _;
1220   }
1221 
1222   function totalSupply() public view returns (uint256) {
1223     return supply.current();
1224   }
1225 
1226   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1227     require(!paused, "The contract is paused!");
1228     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1229 
1230     _mintLoop(msg.sender, _mintAmount);
1231   }
1232   
1233   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1234     _mintLoop(_receiver, _mintAmount);
1235   }
1236 
1237   function walletOfOwner(address _owner)
1238     public
1239     view
1240     returns (uint256[] memory)
1241   {
1242     uint256 ownerTokenCount = balanceOf(_owner);
1243     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1244     uint256 currentTokenId = 1;
1245     uint256 ownedTokenIndex = 0;
1246 
1247     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1248       address currentTokenOwner = ownerOf(currentTokenId);
1249 
1250       if (currentTokenOwner == _owner) {
1251         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1252 
1253         ownedTokenIndex++;
1254       }
1255 
1256       currentTokenId++;
1257     }
1258 
1259     return ownedTokenIds;
1260   }
1261 
1262   function tokenURI(uint256 _tokenId)
1263     public
1264     view
1265     virtual
1266     override
1267     returns (string memory)
1268   {
1269     require(
1270       _exists(_tokenId),
1271       "ERC721Metadata: URI query for nonexistent token"
1272     );
1273 
1274     if (revealed == false) {
1275       return hiddenMetadataUri;
1276     }
1277 
1278     string memory currentBaseURI = _baseURI();
1279     return bytes(currentBaseURI).length > 0
1280         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1281         : "";
1282   }
1283 
1284   function setRevealed(bool _state) public onlyOwner {
1285     revealed = _state;
1286   }
1287 
1288   function setCost(uint256 _cost) public onlyOwner {
1289     cost = _cost;
1290   }
1291 
1292   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1293     maxMintAmountPerTx = _maxMintAmountPerTx;
1294   }
1295 
1296   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1297     hiddenMetadataUri = _hiddenMetadataUri;
1298   }
1299 
1300   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1301     uriPrefix = _uriPrefix;
1302   }
1303 
1304   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1305     uriSuffix = _uriSuffix;
1306   }
1307 
1308   function setPaused(bool _state) public onlyOwner {
1309     paused = _state;
1310   }
1311 
1312   function withdraw() public onlyOwner {
1313     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1314     require(os);
1315   }
1316 
1317   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1318     for (uint256 i = 0; i < _mintAmount; i++) {
1319       supply.increment();
1320       _safeMint(_receiver, supply.current());
1321     }
1322   }
1323 
1324   function _baseURI() internal view virtual override returns (string memory) {
1325     return uriPrefix;
1326   }
1327 }