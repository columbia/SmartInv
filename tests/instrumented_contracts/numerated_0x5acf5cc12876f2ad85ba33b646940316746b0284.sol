1 // SPDX-License-Identifier: MIT
2 
3 // ______ _               _____           _ _         _   _             
4 // |  _  (_)             |  ___|         | | |       | | (_)            
5 // | | | |_ _ __   ___   | |____   _____ | | |_ _   _| |_ _  ___  _ __  
6 // | | | | | '_ \ / _ \  |  __\ \ / / _ \| | __| | | | __| |/ _ \| '_ \ 
7 // | |/ /| | | | | (_) | | |___\ V / (_) | | |_| |_| | |_| | (_) | | | |
8 // |___/ |_|_| |_|\___/  \____/ \_/ \___/|_|\__|\__,_|\__|_|\___/|_| |_|
9 //
10 // STAKE YOUR DINO AND SEE IT EVOLVE INTO ITS ULTIMATE FORM!
11 // https://www.dinoevolution.io/                                                                    
12                                                                      
13 
14 
15 // File: @openzeppelin/contracts/utils/Counters.sol
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @title Counters
23  * @author Matt Condon (@shrugs)
24  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
25  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
26  *
27  * Include with `using Counters for Counters.Counter;`
28  */
29 library Counters {
30     struct Counter {
31         // This variable should never be directly accessed by users of the library: interactions must be restricted to
32         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
33         // this feature: see https://github.com/ethereum/solidity/issues/4637
34         uint256 _value; // default: 0
35     }
36 
37     function current(Counter storage counter) internal view returns (uint256) {
38         return counter._value;
39     }
40 
41     function increment(Counter storage counter) internal {
42         unchecked {
43             counter._value += 1;
44         }
45     }
46 
47     function decrement(Counter storage counter) internal {
48         uint256 value = counter._value;
49         require(value > 0, "Counter: decrement overflow");
50         unchecked {
51             counter._value = value - 1;
52         }
53     }
54 
55     function reset(Counter storage counter) internal {
56         counter._value = 0;
57     }
58 }
59 
60 // File: @openzeppelin/contracts/utils/Strings.sol
61 
62 
63 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
64 
65 pragma solidity ^0.8.0;
66 
67 /**
68  * @dev String operations.
69  */
70 library Strings {
71     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
72     uint8 private constant _ADDRESS_LENGTH = 20;
73 
74     /**
75      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
76      */
77     function toString(uint256 value) internal pure returns (string memory) {
78         // Inspired by OraclizeAPI's implementation - MIT licence
79         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
80 
81         if (value == 0) {
82             return "0";
83         }
84         uint256 temp = value;
85         uint256 digits;
86         while (temp != 0) {
87             digits++;
88             temp /= 10;
89         }
90         bytes memory buffer = new bytes(digits);
91         while (value != 0) {
92             digits -= 1;
93             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
94             value /= 10;
95         }
96         return string(buffer);
97     }
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
101      */
102     function toHexString(uint256 value) internal pure returns (string memory) {
103         if (value == 0) {
104             return "0x00";
105         }
106         uint256 temp = value;
107         uint256 length = 0;
108         while (temp != 0) {
109             length++;
110             temp >>= 8;
111         }
112         return toHexString(value, length);
113     }
114 
115     /**
116      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
117      */
118     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
119         bytes memory buffer = new bytes(2 * length + 2);
120         buffer[0] = "0";
121         buffer[1] = "x";
122         for (uint256 i = 2 * length + 1; i > 1; --i) {
123             buffer[i] = _HEX_SYMBOLS[value & 0xf];
124             value >>= 4;
125         }
126         require(value == 0, "Strings: hex length insufficient");
127         return string(buffer);
128     }
129 
130     /**
131      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
132      */
133     function toHexString(address addr) internal pure returns (string memory) {
134         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
135     }
136 }
137 
138 // File: @openzeppelin/contracts/utils/Context.sol
139 
140 
141 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
142 
143 pragma solidity ^0.8.0;
144 
145 /**
146  * @dev Provides information about the current execution context, including the
147  * sender of the transaction and its data. While these are generally available
148  * via msg.sender and msg.data, they should not be accessed in such a direct
149  * manner, since when dealing with meta-transactions the account sending and
150  * paying for execution may not be the actual sender (as far as an application
151  * is concerned).
152  *
153  * This contract is only required for intermediate, library-like contracts.
154  */
155 abstract contract Context {
156     function _msgSender() internal view virtual returns (address) {
157         return msg.sender;
158     }
159 
160     function _msgData() internal view virtual returns (bytes calldata) {
161         return msg.data;
162     }
163 }
164 
165 // File: @openzeppelin/contracts/access/Ownable.sol
166 
167 
168 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 
173 /**
174  * @dev Contract module which provides a basic access control mechanism, where
175  * there is an account (an owner) that can be granted exclusive access to
176  * specific functions.
177  *
178  * By default, the owner account will be the one that deploys the contract. This
179  * can later be changed with {transferOwnership}.
180  *
181  * This module is used through inheritance. It will make available the modifier
182  * `onlyOwner`, which can be applied to your functions to restrict their use to
183  * the owner.
184  */
185 abstract contract Ownable is Context {
186     address private _owner;
187 
188     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190     /**
191      * @dev Initializes the contract setting the deployer as the initial owner.
192      */
193     constructor() {
194         _transferOwnership(_msgSender());
195     }
196 
197     /**
198      * @dev Throws if called by any account other than the owner.
199      */
200     modifier onlyOwner() {
201         _checkOwner();
202         _;
203     }
204 
205     /**
206      * @dev Returns the address of the current owner.
207      */
208     function owner() public view virtual returns (address) {
209         return _owner;
210     }
211 
212     /**
213      * @dev Throws if the sender is not the owner.
214      */
215     function _checkOwner() internal view virtual {
216         require(owner() == _msgSender(), "Ownable: caller is not the owner");
217     }
218 
219     /**
220      * @dev Leaves the contract without owner. It will not be possible to call
221      * `onlyOwner` functions anymore. Can only be called by the current owner.
222      *
223      * NOTE: Renouncing ownership will leave the contract without an owner,
224      * thereby removing any functionality that is only available to the owner.
225      */
226     function renounceOwnership() public virtual onlyOwner {
227         _transferOwnership(address(0));
228     }
229 
230     /**
231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
232      * Can only be called by the current owner.
233      */
234     function transferOwnership(address newOwner) public virtual onlyOwner {
235         require(newOwner != address(0), "Ownable: new owner is the zero address");
236         _transferOwnership(newOwner);
237     }
238 
239     /**
240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
241      * Internal function without access restriction.
242      */
243     function _transferOwnership(address newOwner) internal virtual {
244         address oldOwner = _owner;
245         _owner = newOwner;
246         emit OwnershipTransferred(oldOwner, newOwner);
247     }
248 }
249 
250 // File: @openzeppelin/contracts/utils/Address.sol
251 
252 
253 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
254 
255 pragma solidity ^0.8.1;
256 
257 /**
258  * @dev Collection of functions related to the address type
259  */
260 library Address {
261     /**
262      * @dev Returns true if `account` is a contract.
263      *
264      * [IMPORTANT]
265      * ====
266      * It is unsafe to assume that an address for which this function returns
267      * false is an externally-owned account (EOA) and not a contract.
268      *
269      * Among others, `isContract` will return false for the following
270      * types of addresses:
271      *
272      *  - an externally-owned account
273      *  - a contract in construction
274      *  - an address where a contract will be created
275      *  - an address where a contract lived, but was destroyed
276      * ====
277      *
278      * [IMPORTANT]
279      * ====
280      * You shouldn't rely on `isContract` to protect against flash loan attacks!
281      *
282      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
283      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
284      * constructor.
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // This method relies on extcodesize/address.code.length, which returns 0
289         // for contracts in construction, since the code is only stored at the end
290         // of the constructor execution.
291 
292         return account.code.length > 0;
293     }
294 
295     /**
296      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
297      * `recipient`, forwarding all available gas and reverting on errors.
298      *
299      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
300      * of certain opcodes, possibly making contracts go over the 2300 gas limit
301      * imposed by `transfer`, making them unable to receive funds via
302      * `transfer`. {sendValue} removes this limitation.
303      *
304      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
305      *
306      * IMPORTANT: because control is transferred to `recipient`, care must be
307      * taken to not create reentrancy vulnerabilities. Consider using
308      * {ReentrancyGuard} or the
309      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
310      */
311     function sendValue(address payable recipient, uint256 amount) internal {
312         require(address(this).balance >= amount, "Address: insufficient balance");
313 
314         (bool success, ) = recipient.call{value: amount}("");
315         require(success, "Address: unable to send value, recipient may have reverted");
316     }
317 
318     /**
319      * @dev Performs a Solidity function call using a low level `call`. A
320      * plain `call` is an unsafe replacement for a function call: use this
321      * function instead.
322      *
323      * If `target` reverts with a revert reason, it is bubbled up by this
324      * function (like regular Solidity function calls).
325      *
326      * Returns the raw returned data. To convert to the expected return value,
327      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
328      *
329      * Requirements:
330      *
331      * - `target` must be a contract.
332      * - calling `target` with `data` must not revert.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
337         return functionCall(target, data, "Address: low-level call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
342      * `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(
347         address target,
348         bytes memory data,
349         string memory errorMessage
350     ) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, 0, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but also transferring `value` wei to `target`.
357      *
358      * Requirements:
359      *
360      * - the calling contract must have an ETH balance of at least `value`.
361      * - the called Solidity function must be `payable`.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(
366         address target,
367         bytes memory data,
368         uint256 value
369     ) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
375      * with `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(
380         address target,
381         bytes memory data,
382         uint256 value,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         require(address(this).balance >= value, "Address: insufficient balance for call");
386         require(isContract(target), "Address: call to non-contract");
387 
388         (bool success, bytes memory returndata) = target.call{value: value}(data);
389         return verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but performing a static call.
395      *
396      * _Available since v3.3._
397      */
398     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
399         return functionStaticCall(target, data, "Address: low-level static call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
404      * but performing a static call.
405      *
406      * _Available since v3.3._
407      */
408     function functionStaticCall(
409         address target,
410         bytes memory data,
411         string memory errorMessage
412     ) internal view returns (bytes memory) {
413         require(isContract(target), "Address: static call to non-contract");
414 
415         (bool success, bytes memory returndata) = target.staticcall(data);
416         return verifyCallResult(success, returndata, errorMessage);
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
421      * but performing a delegate call.
422      *
423      * _Available since v3.4._
424      */
425     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
426         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
431      * but performing a delegate call.
432      *
433      * _Available since v3.4._
434      */
435     function functionDelegateCall(
436         address target,
437         bytes memory data,
438         string memory errorMessage
439     ) internal returns (bytes memory) {
440         require(isContract(target), "Address: delegate call to non-contract");
441 
442         (bool success, bytes memory returndata) = target.delegatecall(data);
443         return verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
448      * revert reason using the provided one.
449      *
450      * _Available since v4.3._
451      */
452     function verifyCallResult(
453         bool success,
454         bytes memory returndata,
455         string memory errorMessage
456     ) internal pure returns (bytes memory) {
457         if (success) {
458             return returndata;
459         } else {
460             // Look for revert reason and bubble it up if present
461             if (returndata.length > 0) {
462                 // The easiest way to bubble the revert reason is using memory via assembly
463                 /// @solidity memory-safe-assembly
464                 assembly {
465                     let returndata_size := mload(returndata)
466                     revert(add(32, returndata), returndata_size)
467                 }
468             } else {
469                 revert(errorMessage);
470             }
471         }
472     }
473 }
474 
475 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
476 
477 
478 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 /**
483  * @title ERC721 token receiver interface
484  * @dev Interface for any contract that wants to support safeTransfers
485  * from ERC721 asset contracts.
486  */
487 interface IERC721Receiver {
488     /**
489      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
490      * by `operator` from `from`, this function is called.
491      *
492      * It must return its Solidity selector to confirm the token transfer.
493      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
494      *
495      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
496      */
497     function onERC721Received(
498         address operator,
499         address from,
500         uint256 tokenId,
501         bytes calldata data
502     ) external returns (bytes4);
503 }
504 
505 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
506 
507 
508 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 /**
513  * @dev Interface of the ERC165 standard, as defined in the
514  * https://eips.ethereum.org/EIPS/eip-165[EIP].
515  *
516  * Implementers can declare support of contract interfaces, which can then be
517  * queried by others ({ERC165Checker}).
518  *
519  * For an implementation, see {ERC165}.
520  */
521 interface IERC165 {
522     /**
523      * @dev Returns true if this contract implements the interface defined by
524      * `interfaceId`. See the corresponding
525      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
526      * to learn more about how these ids are created.
527      *
528      * This function call must use less than 30 000 gas.
529      */
530     function supportsInterface(bytes4 interfaceId) external view returns (bool);
531 }
532 
533 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
534 
535 
536 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 
541 /**
542  * @dev Implementation of the {IERC165} interface.
543  *
544  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
545  * for the additional interface id that will be supported. For example:
546  *
547  * ```solidity
548  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
549  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
550  * }
551  * ```
552  *
553  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
554  */
555 abstract contract ERC165 is IERC165 {
556     /**
557      * @dev See {IERC165-supportsInterface}.
558      */
559     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
560         return interfaceId == type(IERC165).interfaceId;
561     }
562 }
563 
564 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
565 
566 
567 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
568 
569 pragma solidity ^0.8.0;
570 
571 
572 /**
573  * @dev Required interface of an ERC721 compliant contract.
574  */
575 interface IERC721 is IERC165 {
576     /**
577      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
578      */
579     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
580 
581     /**
582      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
583      */
584     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
585 
586     /**
587      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
588      */
589     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
590 
591     /**
592      * @dev Returns the number of tokens in ``owner``'s account.
593      */
594     function balanceOf(address owner) external view returns (uint256 balance);
595 
596     /**
597      * @dev Returns the owner of the `tokenId` token.
598      *
599      * Requirements:
600      *
601      * - `tokenId` must exist.
602      */
603     function ownerOf(uint256 tokenId) external view returns (address owner);
604 
605     /**
606      * @dev Safely transfers `tokenId` token from `from` to `to`.
607      *
608      * Requirements:
609      *
610      * - `from` cannot be the zero address.
611      * - `to` cannot be the zero address.
612      * - `tokenId` token must exist and be owned by `from`.
613      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
614      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
615      *
616      * Emits a {Transfer} event.
617      */
618     function safeTransferFrom(
619         address from,
620         address to,
621         uint256 tokenId,
622         bytes calldata data
623     ) external;
624 
625     /**
626      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
627      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
628      *
629      * Requirements:
630      *
631      * - `from` cannot be the zero address.
632      * - `to` cannot be the zero address.
633      * - `tokenId` token must exist and be owned by `from`.
634      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
635      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
636      *
637      * Emits a {Transfer} event.
638      */
639     function safeTransferFrom(
640         address from,
641         address to,
642         uint256 tokenId
643     ) external;
644 
645     /**
646      * @dev Transfers `tokenId` token from `from` to `to`.
647      *
648      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
649      *
650      * Requirements:
651      *
652      * - `from` cannot be the zero address.
653      * - `to` cannot be the zero address.
654      * - `tokenId` token must be owned by `from`.
655      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
656      *
657      * Emits a {Transfer} event.
658      */
659     function transferFrom(
660         address from,
661         address to,
662         uint256 tokenId
663     ) external;
664 
665     /**
666      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
667      * The approval is cleared when the token is transferred.
668      *
669      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
670      *
671      * Requirements:
672      *
673      * - The caller must own the token or be an approved operator.
674      * - `tokenId` must exist.
675      *
676      * Emits an {Approval} event.
677      */
678     function approve(address to, uint256 tokenId) external;
679 
680     /**
681      * @dev Approve or remove `operator` as an operator for the caller.
682      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
683      *
684      * Requirements:
685      *
686      * - The `operator` cannot be the caller.
687      *
688      * Emits an {ApprovalForAll} event.
689      */
690     function setApprovalForAll(address operator, bool _approved) external;
691 
692     /**
693      * @dev Returns the account approved for `tokenId` token.
694      *
695      * Requirements:
696      *
697      * - `tokenId` must exist.
698      */
699     function getApproved(uint256 tokenId) external view returns (address operator);
700 
701     /**
702      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
703      *
704      * See {setApprovalForAll}
705      */
706     function isApprovedForAll(address owner, address operator) external view returns (bool);
707 }
708 
709 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
710 
711 
712 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
713 
714 pragma solidity ^0.8.0;
715 
716 
717 /**
718  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
719  * @dev See https://eips.ethereum.org/EIPS/eip-721
720  */
721 interface IERC721Metadata is IERC721 {
722     /**
723      * @dev Returns the token collection name.
724      */
725     function name() external view returns (string memory);
726 
727     /**
728      * @dev Returns the token collection symbol.
729      */
730     function symbol() external view returns (string memory);
731 
732     /**
733      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
734      */
735     function tokenURI(uint256 tokenId) external view returns (string memory);
736 }
737 
738 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
739 
740 
741 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
742 
743 pragma solidity ^0.8.0;
744 
745 
746 
747 
748 
749 
750 
751 
752 /**
753  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
754  * the Metadata extension, but not including the Enumerable extension, which is available separately as
755  * {ERC721Enumerable}.
756  */
757 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
758     using Address for address;
759     using Strings for uint256;
760 
761     // Token name
762     string private _name;
763 
764     // Token symbol
765     string private _symbol;
766 
767     // Mapping from token ID to owner address
768     mapping(uint256 => address) private _owners;
769 
770     // Mapping owner address to token count
771     mapping(address => uint256) private _balances;
772 
773     // Mapping from token ID to approved address
774     mapping(uint256 => address) private _tokenApprovals;
775 
776     // Mapping from owner to operator approvals
777     mapping(address => mapping(address => bool)) private _operatorApprovals;
778 
779     /**
780      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
781      */
782     constructor(string memory name_, string memory symbol_) {
783         _name = name_;
784         _symbol = symbol_;
785     }
786 
787     /**
788      * @dev See {IERC165-supportsInterface}.
789      */
790     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
791         return
792             interfaceId == type(IERC721).interfaceId ||
793             interfaceId == type(IERC721Metadata).interfaceId ||
794             super.supportsInterface(interfaceId);
795     }
796 
797     /**
798      * @dev See {IERC721-balanceOf}.
799      */
800     function balanceOf(address owner) public view virtual override returns (uint256) {
801         require(owner != address(0), "ERC721: address zero is not a valid owner");
802         return _balances[owner];
803     }
804 
805     /**
806      * @dev See {IERC721-ownerOf}.
807      */
808     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
809         address owner = _owners[tokenId];
810         require(owner != address(0), "ERC721: invalid token ID");
811         return owner;
812     }
813 
814     /**
815      * @dev See {IERC721Metadata-name}.
816      */
817     function name() public view virtual override returns (string memory) {
818         return _name;
819     }
820 
821     /**
822      * @dev See {IERC721Metadata-symbol}.
823      */
824     function symbol() public view virtual override returns (string memory) {
825         return _symbol;
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-tokenURI}.
830      */
831     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
832         _requireMinted(tokenId);
833 
834         string memory baseURI = _baseURI();
835         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
836     }
837 
838     /**
839      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
840      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
841      * by default, can be overridden in child contracts.
842      */
843     function _baseURI() internal view virtual returns (string memory) {
844         return "";
845     }
846 
847     /**
848      * @dev See {IERC721-approve}.
849      */
850     function approve(address to, uint256 tokenId) public virtual override {
851         address owner = ERC721.ownerOf(tokenId);
852         require(to != owner, "ERC721: approval to current owner");
853 
854         require(
855             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
856             "ERC721: approve caller is not token owner nor approved for all"
857         );
858 
859         _approve(to, tokenId);
860     }
861 
862     /**
863      * @dev See {IERC721-getApproved}.
864      */
865     function getApproved(uint256 tokenId) public view virtual override returns (address) {
866         _requireMinted(tokenId);
867 
868         return _tokenApprovals[tokenId];
869     }
870 
871     /**
872      * @dev See {IERC721-setApprovalForAll}.
873      */
874     function setApprovalForAll(address operator, bool approved) public virtual override {
875         _setApprovalForAll(_msgSender(), operator, approved);
876     }
877 
878     /**
879      * @dev See {IERC721-isApprovedForAll}.
880      */
881     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
882         return _operatorApprovals[owner][operator];
883     }
884 
885     /**
886      * @dev See {IERC721-transferFrom}.
887      */
888     function transferFrom(
889         address from,
890         address to,
891         uint256 tokenId
892     ) public virtual override {
893         //solhint-disable-next-line max-line-length
894         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
895 
896         _transfer(from, to, tokenId);
897     }
898 
899     /**
900      * @dev See {IERC721-safeTransferFrom}.
901      */
902     function safeTransferFrom(
903         address from,
904         address to,
905         uint256 tokenId
906     ) public virtual override {
907         safeTransferFrom(from, to, tokenId, "");
908     }
909 
910     /**
911      * @dev See {IERC721-safeTransferFrom}.
912      */
913     function safeTransferFrom(
914         address from,
915         address to,
916         uint256 tokenId,
917         bytes memory data
918     ) public virtual override {
919         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
920         _safeTransfer(from, to, tokenId, data);
921     }
922 
923     /**
924      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
925      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
926      *
927      * `data` is additional data, it has no specified format and it is sent in call to `to`.
928      *
929      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
930      * implement alternative mechanisms to perform token transfer, such as signature-based.
931      *
932      * Requirements:
933      *
934      * - `from` cannot be the zero address.
935      * - `to` cannot be the zero address.
936      * - `tokenId` token must exist and be owned by `from`.
937      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
938      *
939      * Emits a {Transfer} event.
940      */
941     function _safeTransfer(
942         address from,
943         address to,
944         uint256 tokenId,
945         bytes memory data
946     ) internal virtual {
947         _transfer(from, to, tokenId);
948         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
949     }
950 
951     /**
952      * @dev Returns whether `tokenId` exists.
953      *
954      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
955      *
956      * Tokens start existing when they are minted (`_mint`),
957      * and stop existing when they are burned (`_burn`).
958      */
959     function _exists(uint256 tokenId) internal view virtual returns (bool) {
960         return _owners[tokenId] != address(0);
961     }
962 
963     /**
964      * @dev Returns whether `spender` is allowed to manage `tokenId`.
965      *
966      * Requirements:
967      *
968      * - `tokenId` must exist.
969      */
970     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
971         address owner = ERC721.ownerOf(tokenId);
972         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
973     }
974 
975     /**
976      * @dev Safely mints `tokenId` and transfers it to `to`.
977      *
978      * Requirements:
979      *
980      * - `tokenId` must not exist.
981      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _safeMint(address to, uint256 tokenId) internal virtual {
986         _safeMint(to, tokenId, "");
987     }
988 
989     /**
990      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
991      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
992      */
993     function _safeMint(
994         address to,
995         uint256 tokenId,
996         bytes memory data
997     ) internal virtual {
998         _mint(to, tokenId);
999         require(
1000             _checkOnERC721Received(address(0), to, tokenId, data),
1001             "ERC721: transfer to non ERC721Receiver implementer"
1002         );
1003     }
1004 
1005     /**
1006      * @dev Mints `tokenId` and transfers it to `to`.
1007      *
1008      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1009      *
1010      * Requirements:
1011      *
1012      * - `tokenId` must not exist.
1013      * - `to` cannot be the zero address.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _mint(address to, uint256 tokenId) internal virtual {
1018         require(to != address(0), "ERC721: mint to the zero address");
1019         require(!_exists(tokenId), "ERC721: token already minted");
1020 
1021         _beforeTokenTransfer(address(0), to, tokenId);
1022 
1023         _balances[to] += 1;
1024         _owners[tokenId] = to;
1025 
1026         emit Transfer(address(0), to, tokenId);
1027 
1028         _afterTokenTransfer(address(0), to, tokenId);
1029     }
1030 
1031     /**
1032      * @dev Destroys `tokenId`.
1033      * The approval is cleared when the token is burned.
1034      *
1035      * Requirements:
1036      *
1037      * - `tokenId` must exist.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function _burn(uint256 tokenId) internal virtual {
1042         address owner = ERC721.ownerOf(tokenId);
1043 
1044         _beforeTokenTransfer(owner, address(0), tokenId);
1045 
1046         // Clear approvals
1047         _approve(address(0), tokenId);
1048 
1049         _balances[owner] -= 1;
1050         delete _owners[tokenId];
1051 
1052         emit Transfer(owner, address(0), tokenId);
1053 
1054         _afterTokenTransfer(owner, address(0), tokenId);
1055     }
1056 
1057     /**
1058      * @dev Transfers `tokenId` from `from` to `to`.
1059      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1060      *
1061      * Requirements:
1062      *
1063      * - `to` cannot be the zero address.
1064      * - `tokenId` token must be owned by `from`.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _transfer(
1069         address from,
1070         address to,
1071         uint256 tokenId
1072     ) internal virtual {
1073         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1074         require(to != address(0), "ERC721: transfer to the zero address");
1075 
1076         _beforeTokenTransfer(from, to, tokenId);
1077 
1078         // Clear approvals from the previous owner
1079         _approve(address(0), tokenId);
1080 
1081         _balances[from] -= 1;
1082         _balances[to] += 1;
1083         _owners[tokenId] = to;
1084 
1085         emit Transfer(from, to, tokenId);
1086 
1087         _afterTokenTransfer(from, to, tokenId);
1088     }
1089 
1090     /**
1091      * @dev Approve `to` to operate on `tokenId`
1092      *
1093      * Emits an {Approval} event.
1094      */
1095     function _approve(address to, uint256 tokenId) internal virtual {
1096         _tokenApprovals[tokenId] = to;
1097         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1098     }
1099 
1100     /**
1101      * @dev Approve `operator` to operate on all of `owner` tokens
1102      *
1103      * Emits an {ApprovalForAll} event.
1104      */
1105     function _setApprovalForAll(
1106         address owner,
1107         address operator,
1108         bool approved
1109     ) internal virtual {
1110         require(owner != operator, "ERC721: approve to caller");
1111         _operatorApprovals[owner][operator] = approved;
1112         emit ApprovalForAll(owner, operator, approved);
1113     }
1114 
1115     /**
1116      * @dev Reverts if the `tokenId` has not been minted yet.
1117      */
1118     function _requireMinted(uint256 tokenId) internal view virtual {
1119         require(_exists(tokenId), "ERC721: invalid token ID");
1120     }
1121 
1122     /**
1123      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1124      * The call is not executed if the target address is not a contract.
1125      *
1126      * @param from address representing the previous owner of the given token ID
1127      * @param to target address that will receive the tokens
1128      * @param tokenId uint256 ID of the token to be transferred
1129      * @param data bytes optional data to send along with the call
1130      * @return bool whether the call correctly returned the expected magic value
1131      */
1132     function _checkOnERC721Received(
1133         address from,
1134         address to,
1135         uint256 tokenId,
1136         bytes memory data
1137     ) private returns (bool) {
1138         if (to.isContract()) {
1139             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1140                 return retval == IERC721Receiver.onERC721Received.selector;
1141             } catch (bytes memory reason) {
1142                 if (reason.length == 0) {
1143                     revert("ERC721: transfer to non ERC721Receiver implementer");
1144                 } else {
1145                     /// @solidity memory-safe-assembly
1146                     assembly {
1147                         revert(add(32, reason), mload(reason))
1148                     }
1149                 }
1150             }
1151         } else {
1152             return true;
1153         }
1154     }
1155 
1156     /**
1157      * @dev Hook that is called before any token transfer. This includes minting
1158      * and burning.
1159      *
1160      * Calling conditions:
1161      *
1162      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1163      * transferred to `to`.
1164      * - When `from` is zero, `tokenId` will be minted for `to`.
1165      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1166      * - `from` and `to` are never both zero.
1167      *
1168      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1169      */
1170     function _beforeTokenTransfer(
1171         address from,
1172         address to,
1173         uint256 tokenId
1174     ) internal virtual {}
1175 
1176     /**
1177      * @dev Hook that is called after any transfer of tokens. This includes
1178      * minting and burning.
1179      *
1180      * Calling conditions:
1181      *
1182      * - when `from` and `to` are both non-zero.
1183      * - `from` and `to` are never both zero.
1184      *
1185      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1186      */
1187     function _afterTokenTransfer(
1188         address from,
1189         address to,
1190         uint256 tokenId
1191     ) internal virtual {}
1192 }
1193 
1194 // File: contracts/DinoEvolution.sol
1195 
1196 
1197 
1198 
1199 
1200 pragma solidity >=0.7.0 <0.9.0;
1201 
1202 
1203 
1204 
1205 contract DinoEvolution is ERC721, Ownable {
1206   using Strings for uint256;
1207   using Counters for Counters.Counter;
1208 
1209   Counters.Counter private supply;
1210 
1211   string public uriPrefix = "";
1212   string public uriSuffix = ".json";
1213   string public hiddenMetadataUri;
1214   
1215   uint256 public cost = 0.005 ether;
1216   uint256 public maxSupply = 6000;
1217   uint256 public maxMintAmountPerTx = 5;
1218   uint256 public maxLimitPerWallet = 5;
1219 
1220   bool public paused = true;
1221   bool public revealed = false;
1222 
1223   constructor() ERC721("Dino Evolution", "DINO") {
1224     setHiddenMetadataUri("ipfs://QmddRvzqH6DvhY3hB5wTYSPbJTTmBHM34C3HmcsrABYzPV/hidden.json");
1225   }
1226 
1227   modifier mintCompliance(uint256 _mintAmount) {
1228     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1229     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1230     require(balanceOf(msg.sender) + _mintAmount <= maxLimitPerWallet, "Max mint per wallet exceeded!");
1231     _;
1232   }
1233 
1234   function totalSupply() public view returns (uint256) {
1235     return supply.current();
1236   }
1237 
1238   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1239     require(!paused, "The contract is paused!");
1240     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1241 
1242     _mintLoop(msg.sender, _mintAmount);
1243   }
1244   
1245   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1246     _mintLoop(_receiver, _mintAmount);
1247   }
1248 
1249   function walletOfOwner(address _owner)
1250     public
1251     view
1252     returns (uint256[] memory)
1253   {
1254     uint256 ownerTokenCount = balanceOf(_owner);
1255     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1256     uint256 currentTokenId = 1;
1257     uint256 ownedTokenIndex = 0;
1258 
1259     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1260       address currentTokenOwner = ownerOf(currentTokenId);
1261 
1262       if (currentTokenOwner == _owner) {
1263         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1264 
1265         ownedTokenIndex++;
1266       }
1267 
1268       currentTokenId++;
1269     }
1270 
1271     return ownedTokenIds;
1272   }
1273 
1274   function tokenURI(uint256 _tokenId)
1275     public
1276     view
1277     virtual
1278     override
1279     returns (string memory)
1280   {
1281     require(
1282       _exists(_tokenId),
1283       "ERC721Metadata: URI query for nonexistent token"
1284     );
1285 
1286     if (revealed == false) {
1287       return hiddenMetadataUri;
1288     }
1289 
1290     string memory currentBaseURI = _baseURI();
1291     return bytes(currentBaseURI).length > 0
1292         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1293         : "";
1294   }
1295 
1296   function setRevealed(bool _state) public onlyOwner {
1297     revealed = _state;
1298   }
1299 
1300   function setCost(uint256 _cost) public onlyOwner {
1301     cost = _cost;
1302   }
1303 
1304   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1305     maxMintAmountPerTx = _maxMintAmountPerTx;
1306   }
1307 
1308   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1309     hiddenMetadataUri = _hiddenMetadataUri;
1310   }
1311 
1312   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1313     uriPrefix = _uriPrefix;
1314   }
1315 
1316   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1317     uriSuffix = _uriSuffix;
1318   }
1319 
1320   function setPaused(bool _state) public onlyOwner {
1321     paused = _state;
1322   }
1323 
1324   function withdraw() public onlyOwner {
1325     // This will transfer the remaining contract balance to the owner.
1326     // Do not remove this otherwise you will not be able to withdraw the funds.
1327     // =============================================================================
1328     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1329     require(os);
1330     // =============================================================================
1331   }
1332 
1333   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1334     for (uint256 i = 0; i < _mintAmount; i++) {
1335       supply.increment();
1336       _safeMint(_receiver, supply.current());
1337     }
1338   }
1339 
1340   function _baseURI() internal view virtual override returns (string memory) {
1341     return uriPrefix;
1342   }
1343 }