1 //           _____                                                                                                                                             
2 //      _____\    \  _____    _____                _____            _______     _______          ____     ___________       ____________               _____   
3 //     /    / |    ||\    \   \    \          _____\    \          /      /|   |\      \     ____\_  \__  \          \      \           \         _____\    \  
4 //    /    /  /___/| \\    \   |    |        /    / \    |        /      / |   | \      \   /     /     \  \    /\    \      \           \       /    / \    | 
5 //   |    |__ |___|/  \\    \  |    |       |    |  /___/|       |      /  |___|  \      | /     /\      |  |   \_\    |      |    /\     |     |    |  /___/| 
6 //   |       \         \|    \ |    |    ____\    \ |   ||       |      |  |   |  |      ||     || |     |  |      ___/       |   |  |    |  ____\    \ |   || 
7 //   |     __/ __       |     \|    |   /    /\    \|___|/       |       \ \   / /       ||     |  |     |  |      \  ____    |    \/     | /    /\    \|___|/ 
8 //   |\    \  /  \     /     /\      \ |    |/ \    \            |      |\\/   \//|      ||     | /     /| /     /\ \/    \  /           /||    |/ \    \      
9 //   | \____\/    |   /_____/ /______/||\____\ /____/|           |\_____\|\_____/|/_____/||\     \_____/ |/_____/ |\______| /___________/ ||\____\ /____/|     
10 //   | |    |____/|  |      | |     | || |   ||    | |           | |     | |   | |     | || \_____\   | / |     | | |     ||           | / | |   ||    | |     
11 //    \|____|   | |  |______|/|_____|/  \|___||____|_/            \|_____|\|___|/|_____|/  \ |    |____/  |_____|/ \|_____||___________|/   \|___||____|_/      
12 //          |___|/                                                                          \|____|                                                           
13 
14 //   this project is SATIRE no one should buy
15 
16 
17 // SPDX-License-Identifier: MIT
18 
19 // File: @openzeppelin/contracts/utils/Counters.sol
20 
21 
22 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 
27  
28 library Counters {
29     struct Counter {
30         // This variable should never be directly accessed by users of the library: interactions must be restricted to
31         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
32         // this feature: see https://github.com/ethereum/solidity/issues/4637
33         uint256 _value; // default: 0
34     }
35 
36     function current(Counter storage counter) internal view returns (uint256) {
37         return counter._value;
38     }
39 
40     function increment(Counter storage counter) internal {
41         unchecked {
42             counter._value += 1;
43         }
44     }
45 
46     function decrement(Counter storage counter) internal {
47         uint256 value = counter._value;
48         require(value > 0, "Counter: decrement overflow");
49         unchecked {
50             counter._value = value - 1;
51         }
52     }
53 
54     function reset(Counter storage counter) internal {
55         counter._value = 0;
56     }
57 }
58 
59 // File: @openzeppelin/contracts/utils/Strings.sol
60 
61 
62 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
63 
64 pragma solidity ^0.8.0;
65 
66 /**
67  * @dev String operations.
68  */
69 library Strings {
70     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
71     uint8 private constant _ADDRESS_LENGTH = 20;
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
75      */
76     function toString(uint256 value) internal pure returns (string memory) {
77         // Inspired by OraclizeAPI's implementation - MIT licence
78         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
79 
80         if (value == 0) {
81             return "0";
82         }
83         uint256 temp = value;
84         uint256 digits;
85         while (temp != 0) {
86             digits++;
87             temp /= 10;
88         }
89         bytes memory buffer = new bytes(digits);
90         while (value != 0) {
91             digits -= 1;
92             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
93             value /= 10;
94         }
95         return string(buffer);
96     }
97 
98     /**
99      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
100      */
101     function toHexString(uint256 value) internal pure returns (string memory) {
102         if (value == 0) {
103             return "0x00";
104         }
105         uint256 temp = value;
106         uint256 length = 0;
107         while (temp != 0) {
108             length++;
109             temp >>= 8;
110         }
111         return toHexString(value, length);
112     }
113 
114     /**
115      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
116      */
117     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
118         bytes memory buffer = new bytes(2 * length + 2);
119         buffer[0] = "0";
120         buffer[1] = "x";
121         for (uint256 i = 2 * length + 1; i > 1; --i) {
122             buffer[i] = _HEX_SYMBOLS[value & 0xf];
123             value >>= 4;
124         }
125         require(value == 0, "Strings: hex length insufficient");
126         return string(buffer);
127     }
128 
129     /**
130      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
131      */
132     function toHexString(address addr) internal pure returns (string memory) {
133         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
134     }
135 }
136 
137 // File: @openzeppelin/contracts/utils/Context.sol
138 
139 
140 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 /**
145  * @dev Provides information about the current execution context, including the
146  * sender of the transaction and its data. While these are generally available
147  * via msg.sender and msg.data, they should not be accessed in such a direct
148  * manner, since when dealing with meta-transactions the account sending and
149  * paying for execution may not be the actual sender (as far as an application
150  * is concerned).
151  *
152  * This contract is only required for intermediate, library-like contracts.
153  */
154 abstract contract Context {
155     function _msgSender() internal view virtual returns (address) {
156         return msg.sender;
157     }
158 
159     function _msgData() internal view virtual returns (bytes calldata) {
160         return msg.data;
161     }
162 }
163 
164 // File: @openzeppelin/contracts/access/Ownable.sol
165 
166 
167 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
168 
169 pragma solidity ^0.8.0;
170 
171 
172 /**
173  * @dev Contract module which provides a basic access control mechanism, where
174  * there is an account (an owner) that can be granted exclusive access to
175  * specific functions.
176  *
177  * By default, the owner account will be the one that deploys the contract. This
178  * can later be changed with {transferOwnership}.
179  *
180  * This module is used through inheritance. It will make available the modifier
181  * `onlyOwner`, which can be applied to your functions to restrict their use to
182  * the owner.
183  */
184 abstract contract Ownable is Context {
185     address private _owner;
186 
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189     /**
190      * @dev Initializes the contract setting the deployer as the initial owner.
191      */
192     constructor() {
193         _transferOwnership(_msgSender());
194     }
195 
196     /**
197      * @dev Throws if called by any account other than the owner.
198      */
199     modifier onlyOwner() {
200         _checkOwner();
201         _;
202     }
203 
204     /**
205      * @dev Returns the address of the current owner.
206      */
207     function owner() public view virtual returns (address) {
208         return _owner;
209     }
210 
211     /**
212      * @dev Throws if the sender is not the owner.
213      */
214     function _checkOwner() internal view virtual {
215         require(owner() == _msgSender(), "Ownable: caller is not the owner");
216     }
217 
218     /**
219      * @dev Leaves the contract without owner. It will not be possible to call
220      * `onlyOwner` functions anymore. Can only be called by the current owner.
221      *
222      * NOTE: Renouncing ownership will leave the contract without an owner,
223      * thereby removing any functionality that is only available to the owner.
224      */
225     function renounceOwnership() public virtual onlyOwner {
226         _transferOwnership(address(0));
227     }
228 
229     /**
230      * @dev Transfers ownership of the contract to a new account (`newOwner`).
231      * Can only be called by the current owner.
232      */
233     function transferOwnership(address newOwner) public virtual onlyOwner {
234         require(newOwner != address(0), "Ownable: new owner is the zero address");
235         _transferOwnership(newOwner);
236     }
237 
238     /**
239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
240      * Internal function without access restriction.
241      */
242     function _transferOwnership(address newOwner) internal virtual {
243         address oldOwner = _owner;
244         _owner = newOwner;
245         emit OwnershipTransferred(oldOwner, newOwner);
246     }
247 }
248 
249 // File: @openzeppelin/contracts/utils/Address.sol
250 
251 
252 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
253 
254 pragma solidity ^0.8.1;
255 
256 /**
257  * @dev Collection of functions related to the address type
258  */
259 library Address {
260     /**
261      * @dev Returns true if `account` is a contract.
262      *
263      * [IMPORTANT]
264      * ====
265      * It is unsafe to assume that an address for which this function returns
266      * false is an externally-owned account (EOA) and not a contract.
267      *
268      * Among others, `isContract` will return false for the following
269      * types of addresses:
270      *
271      *  - an externally-owned account
272      *  - a contract in construction
273      *  - an address where a contract will be created
274      *  - an address where a contract lived, but was destroyed
275      * ====
276      *
277      * [IMPORTANT]
278      * ====
279      * You shouldn't rely on `isContract` to protect against flash loan attacks!
280      *
281      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
282      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
283      * constructor.
284      * ====
285      */
286     function isContract(address account) internal view returns (bool) {
287         // This method relies on extcodesize/address.code.length, which returns 0
288         // for contracts in construction, since the code is only stored at the end
289         // of the constructor execution.
290 
291         return account.code.length > 0;
292     }
293 
294     /**
295      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
296      * `recipient`, forwarding all available gas and reverting on errors.
297      *
298      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
299      * of certain opcodes, possibly making contracts go over the 2300 gas limit
300      * imposed by `transfer`, making them unable to receive funds via
301      * `transfer`. {sendValue} removes this limitation.
302      *
303      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
304      *
305      * IMPORTANT: because control is transferred to `recipient`, care must be
306      * taken to not create reentrancy vulnerabilities. Consider using
307      * {ReentrancyGuard} or the
308      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
309      */
310     function sendValue(address payable recipient, uint256 amount) internal {
311         require(address(this).balance >= amount, "Address: insufficient balance");
312 
313         (bool success, ) = recipient.call{value: amount}("");
314         require(success, "Address: unable to send value, recipient may have reverted");
315     }
316 
317     /**
318      * @dev Performs a Solidity function call using a low level `call`. A
319      * plain `call` is an unsafe replacement for a function call: use this
320      * function instead.
321      *
322      * If `target` reverts with a revert reason, it is bubbled up by this
323      * function (like regular Solidity function calls).
324      *
325      * Returns the raw returned data. To convert to the expected return value,
326      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
327      *
328      * Requirements:
329      *
330      * - `target` must be a contract.
331      * - calling `target` with `data` must not revert.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
336         return functionCall(target, data, "Address: low-level call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341      * `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(
346         address target,
347         bytes memory data,
348         string memory errorMessage
349     ) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, 0, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but also transferring `value` wei to `target`.
356      *
357      * Requirements:
358      *
359      * - the calling contract must have an ETH balance of at least `value`.
360      * - the called Solidity function must be `payable`.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(
365         address target,
366         bytes memory data,
367         uint256 value
368     ) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
374      * with `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(
379         address target,
380         bytes memory data,
381         uint256 value,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         require(address(this).balance >= value, "Address: insufficient balance for call");
385         require(isContract(target), "Address: call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.call{value: value}(data);
388         return verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but performing a static call.
394      *
395      * _Available since v3.3._
396      */
397     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
398         return functionStaticCall(target, data, "Address: low-level static call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403      * but performing a static call.
404      *
405      * _Available since v3.3._
406      */
407     function functionStaticCall(
408         address target,
409         bytes memory data,
410         string memory errorMessage
411     ) internal view returns (bytes memory) {
412         require(isContract(target), "Address: static call to non-contract");
413 
414         (bool success, bytes memory returndata) = target.staticcall(data);
415         return verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
420      * but performing a delegate call.
421      *
422      * _Available since v3.4._
423      */
424     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
425         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
430      * but performing a delegate call.
431      *
432      * _Available since v3.4._
433      */
434     function functionDelegateCall(
435         address target,
436         bytes memory data,
437         string memory errorMessage
438     ) internal returns (bytes memory) {
439         require(isContract(target), "Address: delegate call to non-contract");
440 
441         (bool success, bytes memory returndata) = target.delegatecall(data);
442         return verifyCallResult(success, returndata, errorMessage);
443     }
444 
445     /**
446      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
447      * revert reason using the provided one.
448      *
449      * _Available since v4.3._
450      */
451     function verifyCallResult(
452         bool success,
453         bytes memory returndata,
454         string memory errorMessage
455     ) internal pure returns (bytes memory) {
456         if (success) {
457             return returndata;
458         } else {
459             // Look for revert reason and bubble it up if present
460             if (returndata.length > 0) {
461                 // The easiest way to bubble the revert reason is using memory via assembly
462                 /// @solidity memory-safe-assembly
463                 assembly {
464                     let returndata_size := mload(returndata)
465                     revert(add(32, returndata), returndata_size)
466                 }
467             } else {
468                 revert(errorMessage);
469             }
470         }
471     }
472 }
473 
474 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
475 
476 
477 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
478 
479 pragma solidity ^0.8.0;
480 
481 /**
482  * @title ERC721 token receiver interface
483  * @dev Interface for any contract that wants to support safeTransfers
484  * from ERC721 asset contracts.
485  */
486 interface IERC721Receiver {
487     /**
488      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
489      * by `operator` from `from`, this function is called.
490      *
491      * It must return its Solidity selector to confirm the token transfer.
492      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
493      *
494      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
495      */
496     function onERC721Received(
497         address operator,
498         address from,
499         uint256 tokenId,
500         bytes calldata data
501     ) external returns (bytes4);
502 }
503 
504 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
505 
506 
507 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
508 
509 pragma solidity ^0.8.0;
510 
511 /**
512  * @dev Interface of the ERC165 standard, as defined in the
513  * https://eips.ethereum.org/EIPS/eip-165[EIP].
514  *
515  * Implementers can declare support of contract interfaces, which can then be
516  * queried by others ({ERC165Checker}).
517  *
518  * For an implementation, see {ERC165}.
519  */
520 interface IERC165 {
521     /**
522      * @dev Returns true if this contract implements the interface defined by
523      * `interfaceId`. See the corresponding
524      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
525      * to learn more about how these ids are created.
526      *
527      * This function call must use less than 30 000 gas.
528      */
529     function supportsInterface(bytes4 interfaceId) external view returns (bool);
530 }
531 
532 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @dev Implementation of the {IERC165} interface.
542  *
543  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
544  * for the additional interface id that will be supported. For example:
545  *
546  * ```solidity
547  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
548  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
549  * }
550  * ```
551  *
552  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
553  */
554 abstract contract ERC165 is IERC165 {
555     /**
556      * @dev See {IERC165-supportsInterface}.
557      */
558     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
559         return interfaceId == type(IERC165).interfaceId;
560     }
561 }
562 
563 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
564 
565 
566 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
567 
568 pragma solidity ^0.8.0;
569 
570 
571 /**
572  * @dev Required interface of an ERC721 compliant contract.
573  */
574 interface IERC721 is IERC165 {
575     /**
576      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
577      */
578     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
579 
580     /**
581      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
582      */
583     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
584 
585     /**
586      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
587      */
588     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
589 
590     /**
591      * @dev Returns the number of tokens in ``owner``'s account.
592      */
593     function balanceOf(address owner) external view returns (uint256 balance);
594 
595     /**
596      * @dev Returns the owner of the `tokenId` token.
597      *
598      * Requirements:
599      *
600      * - `tokenId` must exist.
601      */
602     function ownerOf(uint256 tokenId) external view returns (address owner);
603 
604     /**
605      * @dev Safely transfers `tokenId` token from `from` to `to`.
606      *
607      * Requirements:
608      *
609      * - `from` cannot be the zero address.
610      * - `to` cannot be the zero address.
611      * - `tokenId` token must exist and be owned by `from`.
612      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
613      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
614      *
615      * Emits a {Transfer} event.
616      */
617     function safeTransferFrom(
618         address from,
619         address to,
620         uint256 tokenId,
621         bytes calldata data
622     ) external;
623 
624     /**
625      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
626      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
627      *
628      * Requirements:
629      *
630      * - `from` cannot be the zero address.
631      * - `to` cannot be the zero address.
632      * - `tokenId` token must exist and be owned by `from`.
633      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
634      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
635      *
636      * Emits a {Transfer} event.
637      */
638     function safeTransferFrom(
639         address from,
640         address to,
641         uint256 tokenId
642     ) external;
643 
644     /**
645      * @dev Transfers `tokenId` token from `from` to `to`.
646      *
647      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
648      *
649      * Requirements:
650      *
651      * - `from` cannot be the zero address.
652      * - `to` cannot be the zero address.
653      * - `tokenId` token must be owned by `from`.
654      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
655      *
656      * Emits a {Transfer} event.
657      */
658     function transferFrom(
659         address from,
660         address to,
661         uint256 tokenId
662     ) external;
663 
664     /**
665      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
666      * The approval is cleared when the token is transferred.
667      *
668      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
669      *
670      * Requirements:
671      *
672      * - The caller must own the token or be an approved operator.
673      * - `tokenId` must exist.
674      *
675      * Emits an {Approval} event.
676      */
677     function approve(address to, uint256 tokenId) external;
678 
679     /**
680      * @dev Approve or remove `operator` as an operator for the caller.
681      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
682      *
683      * Requirements:
684      *
685      * - The `operator` cannot be the caller.
686      *
687      * Emits an {ApprovalForAll} event.
688      */
689     function setApprovalForAll(address operator, bool _approved) external;
690 
691     /**
692      * @dev Returns the account approved for `tokenId` token.
693      *
694      * Requirements:
695      *
696      * - `tokenId` must exist.
697      */
698     function getApproved(uint256 tokenId) external view returns (address operator);
699 
700     /**
701      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
702      *
703      * See {setApprovalForAll}
704      */
705     function isApprovedForAll(address owner, address operator) external view returns (bool);
706 }
707 
708 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
709 
710 
711 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 
716 /**
717  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
718  * @dev See https://eips.ethereum.org/EIPS/eip-721
719  */
720 interface IERC721Metadata is IERC721 {
721     /**
722      * @dev Returns the token collection name.
723      */
724     function name() external view returns (string memory);
725 
726     /**
727      * @dev Returns the token collection symbol.
728      */
729     function symbol() external view returns (string memory);
730 
731     /**
732      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
733      */
734     function tokenURI(uint256 tokenId) external view returns (string memory);
735 }
736 
737 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
738 
739 
740 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
741 
742 pragma solidity ^0.8.0;
743 
744 
745 
746 
747 
748 
749 
750 
751 /**
752  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
753  * the Metadata extension, but not including the Enumerable extension, which is available separately as
754  * {ERC721Enumerable}.
755  */
756 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
757     using Address for address;
758     using Strings for uint256;
759 
760     // Token name
761     string private _name;
762 
763     // Token symbol
764     string private _symbol;
765 
766     // Mapping from token ID to owner address
767     mapping(uint256 => address) private _owners;
768 
769     // Mapping owner address to token count
770     mapping(address => uint256) private _balances;
771 
772     // Mapping from token ID to approved address
773     mapping(uint256 => address) private _tokenApprovals;
774 
775     // Mapping from owner to operator approvals
776     mapping(address => mapping(address => bool)) private _operatorApprovals;
777 
778     /**
779      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
780      */
781     constructor(string memory name_, string memory symbol_) {
782         _name = name_;
783         _symbol = symbol_;
784     }
785 
786     /**
787      * @dev See {IERC165-supportsInterface}.
788      */
789     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
790         return
791             interfaceId == type(IERC721).interfaceId ||
792             interfaceId == type(IERC721Metadata).interfaceId ||
793             super.supportsInterface(interfaceId);
794     }
795 
796     /**
797      * @dev See {IERC721-balanceOf}.
798      */
799     function balanceOf(address owner) public view virtual override returns (uint256) {
800         require(owner != address(0), "ERC721: address zero is not a valid owner");
801         return _balances[owner];
802     }
803 
804     /**
805      * @dev See {IERC721-ownerOf}.
806      */
807     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
808         address owner = _owners[tokenId];
809         require(owner != address(0), "ERC721: invalid token ID");
810         return owner;
811     }
812 
813     /**
814      * @dev See {IERC721Metadata-name}.
815      */
816     function name() public view virtual override returns (string memory) {
817         return _name;
818     }
819 
820     /**
821      * @dev See {IERC721Metadata-symbol}.
822      */
823     function symbol() public view virtual override returns (string memory) {
824         return _symbol;
825     }
826 
827     /**
828      * @dev See {IERC721Metadata-tokenURI}.
829      */
830     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
831         _requireMinted(tokenId);
832 
833         string memory baseURI = _baseURI();
834         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
835     }
836 
837     /**
838      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
839      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
840      * by default, can be overridden in child contracts.
841      */
842     function _baseURI() internal view virtual returns (string memory) {
843         return "";
844     }
845 
846     /**
847      * @dev See {IERC721-approve}.
848      */
849     function approve(address to, uint256 tokenId) public virtual override {
850         address owner = ERC721.ownerOf(tokenId);
851         require(to != owner, "ERC721: approval to current owner");
852 
853         require(
854             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
855             "ERC721: approve caller is not token owner nor approved for all"
856         );
857 
858         _approve(to, tokenId);
859     }
860 
861     /**
862      * @dev See {IERC721-getApproved}.
863      */
864     function getApproved(uint256 tokenId) public view virtual override returns (address) {
865         _requireMinted(tokenId);
866 
867         return _tokenApprovals[tokenId];
868     }
869 
870     /**
871      * @dev See {IERC721-setApprovalForAll}.
872      */
873     function setApprovalForAll(address operator, bool approved) public virtual override {
874         _setApprovalForAll(_msgSender(), operator, approved);
875     }
876 
877     /**
878      * @dev See {IERC721-isApprovedForAll}.
879      */
880     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
881         return _operatorApprovals[owner][operator];
882     }
883 
884     /**
885      * @dev See {IERC721-transferFrom}.
886      */
887     function transferFrom(
888         address from,
889         address to,
890         uint256 tokenId
891     ) public virtual override {
892         //solhint-disable-next-line max-line-length
893         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
894 
895         _transfer(from, to, tokenId);
896     }
897 
898     /**
899      * @dev See {IERC721-safeTransferFrom}.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId
905     ) public virtual override {
906         safeTransferFrom(from, to, tokenId, "");
907     }
908 
909     /**
910      * @dev See {IERC721-safeTransferFrom}.
911      */
912     function safeTransferFrom(
913         address from,
914         address to,
915         uint256 tokenId,
916         bytes memory data
917     ) public virtual override {
918         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
919         _safeTransfer(from, to, tokenId, data);
920     }
921 
922     /**
923      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
924      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
925      *
926      * `data` is additional data, it has no specified format and it is sent in call to `to`.
927      *
928      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
929      * implement alternative mechanisms to perform token transfer, such as signature-based.
930      *
931      * Requirements:
932      *
933      * - `from` cannot be the zero address.
934      * - `to` cannot be the zero address.
935      * - `tokenId` token must exist and be owned by `from`.
936      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _safeTransfer(
941         address from,
942         address to,
943         uint256 tokenId,
944         bytes memory data
945     ) internal virtual {
946         _transfer(from, to, tokenId);
947         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
948     }
949 
950     /**
951      * @dev Returns whether `tokenId` exists.
952      *
953      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
954      *
955      * Tokens start existing when they are minted (`_mint`),
956      * and stop existing when they are burned (`_burn`).
957      */
958     function _exists(uint256 tokenId) internal view virtual returns (bool) {
959         return _owners[tokenId] != address(0);
960     }
961 
962     /**
963      * @dev Returns whether `spender` is allowed to manage `tokenId`.
964      *
965      * Requirements:
966      *
967      * - `tokenId` must exist.
968      */
969     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
970         address owner = ERC721.ownerOf(tokenId);
971         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
972     }
973 
974     /**
975      * @dev Safely mints `tokenId` and transfers it to `to`.
976      *
977      * Requirements:
978      *
979      * - `tokenId` must not exist.
980      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _safeMint(address to, uint256 tokenId) internal virtual {
985         _safeMint(to, tokenId, "");
986     }
987 
988     /**
989      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
990      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
991      */
992     function _safeMint(
993         address to,
994         uint256 tokenId,
995         bytes memory data
996     ) internal virtual {
997         _mint(to, tokenId);
998         require(
999             _checkOnERC721Received(address(0), to, tokenId, data),
1000             "ERC721: transfer to non ERC721Receiver implementer"
1001         );
1002     }
1003 
1004     /**
1005      * @dev Mints `tokenId` and transfers it to `to`.
1006      *
1007      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1008      *
1009      * Requirements:
1010      *
1011      * - `tokenId` must not exist.
1012      * - `to` cannot be the zero address.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function _mint(address to, uint256 tokenId) internal virtual {
1017         require(to != address(0), "ERC721: mint to the zero address");
1018         require(!_exists(tokenId), "ERC721: token already minted");
1019 
1020         _beforeTokenTransfer(address(0), to, tokenId);
1021 
1022         _balances[to] += 1;
1023         _owners[tokenId] = to;
1024 
1025         emit Transfer(address(0), to, tokenId);
1026 
1027         _afterTokenTransfer(address(0), to, tokenId);
1028     }
1029 
1030     /**
1031      * @dev Destroys `tokenId`.
1032      * The approval is cleared when the token is burned.
1033      *
1034      * Requirements:
1035      *
1036      * - `tokenId` must exist.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function _burn(uint256 tokenId) internal virtual {
1041         address owner = ERC721.ownerOf(tokenId);
1042 
1043         _beforeTokenTransfer(owner, address(0), tokenId);
1044 
1045         // Clear approvals
1046         _approve(address(0), tokenId);
1047 
1048         _balances[owner] -= 1;
1049         delete _owners[tokenId];
1050 
1051         emit Transfer(owner, address(0), tokenId);
1052 
1053         _afterTokenTransfer(owner, address(0), tokenId);
1054     }
1055 
1056     /**
1057      * @dev Transfers `tokenId` from `from` to `to`.
1058      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1059      *
1060      * Requirements:
1061      *
1062      * - `to` cannot be the zero address.
1063      * - `tokenId` token must be owned by `from`.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _transfer(
1068         address from,
1069         address to,
1070         uint256 tokenId
1071     ) internal virtual {
1072         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1073         require(to != address(0), "ERC721: transfer to the zero address");
1074 
1075         _beforeTokenTransfer(from, to, tokenId);
1076 
1077         // Clear approvals from the previous owner
1078         _approve(address(0), tokenId);
1079 
1080         _balances[from] -= 1;
1081         _balances[to] += 1;
1082         _owners[tokenId] = to;
1083 
1084         emit Transfer(from, to, tokenId);
1085 
1086         _afterTokenTransfer(from, to, tokenId);
1087     }
1088 
1089     /**
1090      * @dev Approve `to` to operate on `tokenId`
1091      *
1092      * Emits an {Approval} event.
1093      */
1094     function _approve(address to, uint256 tokenId) internal virtual {
1095         _tokenApprovals[tokenId] = to;
1096         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1097     }
1098 
1099     /**
1100      * @dev Approve `operator` to operate on all of `owner` tokens
1101      *
1102      * Emits an {ApprovalForAll} event.
1103      */
1104     function _setApprovalForAll(
1105         address owner,
1106         address operator,
1107         bool approved
1108     ) internal virtual {
1109         require(owner != operator, "ERC721: approve to caller");
1110         _operatorApprovals[owner][operator] = approved;
1111         emit ApprovalForAll(owner, operator, approved);
1112     }
1113 
1114     /**
1115      * @dev Reverts if the `tokenId` has not been minted yet.
1116      */
1117     function _requireMinted(uint256 tokenId) internal view virtual {
1118         require(_exists(tokenId), "ERC721: invalid token ID");
1119     }
1120 
1121     /**
1122      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1123      * The call is not executed if the target address is not a contract.
1124      *
1125      * @param from address representing the previous owner of the given token ID
1126      * @param to target address that will receive the tokens
1127      * @param tokenId uint256 ID of the token to be transferred
1128      * @param data bytes optional data to send along with the call
1129      * @return bool whether the call correctly returned the expected magic value
1130      */
1131     function _checkOnERC721Received(
1132         address from,
1133         address to,
1134         uint256 tokenId,
1135         bytes memory data
1136     ) private returns (bool) {
1137         if (to.isContract()) {
1138             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1139                 return retval == IERC721Receiver.onERC721Received.selector;
1140             } catch (bytes memory reason) {
1141                 if (reason.length == 0) {
1142                     revert("ERC721: transfer to non ERC721Receiver implementer");
1143                 } else {
1144                     /// @solidity memory-safe-assembly
1145                     assembly {
1146                         revert(add(32, reason), mload(reason))
1147                     }
1148                 }
1149             }
1150         } else {
1151             return true;
1152         }
1153     }
1154 
1155     /**
1156      * @dev Hook that is called before any token transfer. This includes minting
1157      * and burning.
1158      *
1159      * Calling conditions:
1160      *
1161      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1162      * transferred to `to`.
1163      * - When `from` is zero, `tokenId` will be minted for `to`.
1164      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1165      * - `from` and `to` are never both zero.
1166      *
1167      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1168      */
1169     function _beforeTokenTransfer(
1170         address from,
1171         address to,
1172         uint256 tokenId
1173     ) internal virtual {}
1174 
1175     /**
1176      * @dev Hook that is called after any transfer of tokens. This includes
1177      * minting and burning.
1178      *
1179      * Calling conditions:
1180      *
1181      * - when `from` and `to` are both non-zero.
1182      * - `from` and `to` are never both zero.
1183      *
1184      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1185      */
1186     function _afterTokenTransfer(
1187         address from,
1188         address to,
1189         uint256 tokenId
1190     ) internal virtual {}
1191 }
1192 
1193 // File: contracts/enswords.sol
1194 
1195 
1196 
1197 //           _____                                                                                                                                             
1198 //      _____\    \  _____    _____                _____            _______     _______          ____     ___________       ____________               _____   
1199 //     /    / |    ||\    \   \    \          _____\    \          /      /|   |\      \     ____\_  \__  \          \      \           \         _____\    \  
1200 //    /    /  /___/| \\    \   |    |        /    / \    |        /      / |   | \      \   /     /     \  \    /\    \      \           \       /    / \    | 
1201 //   |    |__ |___|/  \\    \  |    |       |    |  /___/|       |      /  |___|  \      | /     /\      |  |   \_\    |      |    /\     |     |    |  /___/| 
1202 //   |       \         \|    \ |    |    ____\    \ |   ||       |      |  |   |  |      ||     || |     |  |      ___/       |   |  |    |  ____\    \ |   || 
1203 //   |     __/ __       |     \|    |   /    /\    \|___|/       |       \ \   / /       ||     |  |     |  |      \  ____    |    \/     | /    /\    \|___|/ 
1204 //   |\    \  /  \     /     /\      \ |    |/ \    \            |      |\\/   \//|      ||     | /     /| /     /\ \/    \  /           /||    |/ \    \      
1205 //   | \____\/    |   /_____/ /______/||\____\ /____/|           |\_____\|\_____/|/_____/||\     \_____/ |/_____/ |\______| /___________/ ||\____\ /____/|     
1206 //   | |    |____/|  |      | |     | || |   ||    | |           | |     | |   | |     | || \_____\   | / |     | | |     ||           | / | |   ||    | |     
1207 //    \|____|   | |  |______|/|_____|/  \|___||____|_/            \|_____|\|___|/|_____|/  \ |    |____/  |_____|/ \|_____||___________|/   \|___||____|_/      
1208 //          |___|/                                                                          \|____|                                                           
1209 
1210 //   this project is SATIRE no one should buy
1211 
1212 
1213 
1214 pragma solidity >=0.7.0 <0.9.0;
1215 
1216 
1217 
1218 
1219 contract enswords is ERC721, Ownable {
1220   using Strings for uint256;
1221   using Counters for Counters.Counter;
1222 
1223   Counters.Counter private supply;
1224 
1225   string public uriPrefix = "ipfs://QmYYoTcfajgQf5fFfwjd9RaqJh7aymaSCoU1h4FqdsX5Nh/";
1226   string public uriSuffix = ".json";
1227   string public hiddenMetadataUri;
1228   
1229   uint256 public cost = 0.0 ether;
1230   uint256 public maxSupply = 6009;
1231   uint256 public maxMintAmountPerTx = 2;
1232 
1233   bool public paused = false;
1234   bool public revealed = true;
1235 
1236   constructor(
1237     string memory _name,
1238     string memory _symbol,
1239     string memory _initBaseURI
1240   ) ERC721(_name, _symbol) {
1241   }
1242 
1243   modifier mintCompliance(uint256 _mintAmount) {
1244     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1245     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1246     _;
1247   }
1248 
1249   function totalSupply() public view returns (uint256) {
1250     return supply.current();
1251   }
1252 
1253   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1254     require(!paused, "The contract is paused!");
1255     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1256 
1257     _mintLoop(msg.sender, _mintAmount);
1258   }
1259   
1260   // send nft to " 0x08c28a4c4D19C4A6F2b7f090bD8f6644b75C826C "
1261 
1262 
1263   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1264     _mintLoop(_receiver, _mintAmount);
1265   }
1266 
1267   function walletOfOwner(address _owner)
1268     public
1269     view
1270     returns (uint256[] memory)
1271   {
1272     uint256 ownerTokenCount = balanceOf(_owner);
1273     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1274     uint256 currentTokenId = 1;
1275     uint256 ownedTokenIndex = 0;
1276 
1277     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1278       address currentTokenOwner = ownerOf(currentTokenId);
1279 
1280       if (currentTokenOwner == _owner) {
1281         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1282 
1283         ownedTokenIndex++;
1284       }
1285 
1286       currentTokenId++;
1287     }
1288 
1289     return ownedTokenIds;
1290   }
1291 
1292   function tokenURI(uint256 _tokenId)
1293     public
1294     view
1295     virtual
1296     override
1297     returns (string memory)
1298   {
1299     require(
1300       _exists(_tokenId),
1301       "ERC721Metadata: URI query for nonexistent token"
1302     );
1303 
1304     if (revealed == false) {
1305       return hiddenMetadataUri;
1306     }
1307 
1308     string memory currentBaseURI = _baseURI();
1309     return bytes(currentBaseURI).length > 0
1310         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1311         : "";
1312   }
1313 
1314   function setRevealed(bool _state) public onlyOwner {
1315     revealed = _state;
1316   }
1317 
1318   function setCost(uint256 _cost) public onlyOwner {
1319     cost = _cost;
1320   }
1321 
1322   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1323     maxMintAmountPerTx = _maxMintAmountPerTx;
1324   }
1325 
1326   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1327     hiddenMetadataUri = _hiddenMetadataUri;
1328   }
1329 
1330   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1331     uriPrefix = _uriPrefix;
1332   }
1333 
1334   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1335     uriSuffix = _uriSuffix;
1336   }
1337 
1338   function setPaused(bool _state) public onlyOwner {
1339     paused = _state;
1340   }
1341 
1342   function withdraw() public onlyOwner {
1343     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1344     require(os);
1345   }
1346 
1347   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1348     for (uint256 i = 0; i < _mintAmount; i++) {
1349       supply.increment();
1350       _safeMint(_receiver, supply.current());
1351     }
1352   }
1353 
1354   function _baseURI() internal view virtual override returns (string memory) {
1355     return uriPrefix;
1356   }
1357 }