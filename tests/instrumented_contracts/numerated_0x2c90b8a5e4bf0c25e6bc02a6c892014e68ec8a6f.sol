1 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
2 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
3 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
4 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
5 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
6 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
7 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
8 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@@@@@%%%%%%@@@......,@@@%%%%%%@@@@@@@@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%
9 //%%%%%%%%%%%%%%%%%%%%%%%%%@@@&         @@@@@@.............@@@@@@         @@@%%%%%%%%%%%%%%%%%%%%%%%%%
10 //%%%%%%%%%%%%%%%%%%%%%%%%%@@@&            @@@.............@@@            @@@%%%%%%%%%%%%%%%%%%%%%%%%%
11 //%%%%%%%%%%%%%%%%%%%@@@@@@@@@&            @@@***......,***@@@            @@@@@@@@@@%%%%%%%%%%%%%%%%%%
12 //%%%%%%%%%%%%%%%%%%%@@@@@@@@@&            @@@***......,***@@@            @@@@@@@@@@%%%%%%%%%%%%%%%%%%
13 //%%%%%%%%%%%%%%%%@@@.........*@@@         ,,,@@@@@@@@@@@@@,,,         @@@..........@@@%%%%%%%%%%%%%%%
14 //%%%%%%%%%%%%%%%%@@@.............@@@,,,@@@@@@             @@@@@@,,,@@@.............@@@%%%%%%%%%%%%%%%
15 //%%%%%%%%%%%%%%%%@@@.............***@@@...                   ...@@@***.............@@@%%%%%%%%%%%%%%%
16 //%%%%%%%%%%%%%%%%%%%@@@***...,***@@@...                         ...@@@***..........@@@%%%%%%%%%%%%%%%
17 //%%%%%%%%%%%%%%%%%%%@@@***...,***@@@...                         ...@@@***...*** @@@%%%%%%%%%%%%%%%%%%
18 //%%%%%%%%%%%%%%%%%%%@@@@@@@@@@***@@@      @@@             @@@      @@@***@@@@@@@@@@%%%%%%%%%%%%%%%%%%
19 //%%%%%%%%%%%%%%%%@@@      ,,,*@@@...      @@@             @@@      ...@@@,,,       @@@%%%%%%%%%%%%%%%
20 //%%%%%%%%%%%%%@@@            .@@@         @@@             @@@   &&&&&&&&&   &&&&&&&&&&@@@%%%%%%%%%%%%
21 //%%%%%%%%%%%%%@@@            .@@@               @@@@@@%      &&&   %%%%%%&&&   ,%%%%%%&&&%%%%%%%%%%%%
22 //%%%%%%%%%%%%%@@@            .@@@               @@@@@@&      &&&   %%%%%%&&&   .%%%%%%&&&%%%%%%%%%%%%
23 //%%%%%%%%%%%%%%%%@@@      ,,,*@@@                     .@@@   &&&%%%%%%%%%%%%%%%%%%%%%%&&&%%%%%%%%%%%%
24 //%%%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@...            ...@@@&...   &&&%%%%%%%%%%%%%%%%%%%%%%&&&%%%%%%%%%%%%
25 //%%%%%%%%%%%%%%%%%%%@@@......,***@@@...               .@@@      &&&%%%%%%%%%%%%%%%%&&&%%%%%%%%%%%%%%%
26 //%%%%%%%%%%%%%%%%@@@.............***@@@...      @@@@@@&...   ...@@@&&&%%%%%%%%%%&&&@@@%%%%%%%%%%%%%%%
27 //%%%%%%%%%%%%%%%%@@@.............***@@@...      @@@@@@&...   ...@@@&&&%%%%%%%%%%&&&@@@%%%%%%%%%%%%%%%
28 //%%%%%%%%%%%%%%%%@@@.............@@@,,,@@@...   .......   ...@@@,,,@@@&&&%%%&&&%...@@@%%%%%%%%%%%%%%%
29 //%%%%%%%%%%%%%%%%@@@.........*@@@      ,,,@@@@@@@@@@@@@@@@@@@,,,      @@@&&&.......@@@%%%%%%%%%%%%%%%
30 //%%%%%%%%%%%%%%%%%%%@@@@@@@@@&            @@@***......,***@@@            @@@@@@@@@@%%%%%%%%%%%%%%%%%%
31 //%%%%%%%%%%%%%%%%%%%%%%%%%@@@&            @@@.............@@@            @@@%%%%%%%%%%%%%%%%%%%%%%%%%
32 //%%%%%%%%%%%%%%%%%%%%%%%%%@@@&            @@@.............@@@            @@@%%%%%%%%%%%%%%%%%%%%%%%%%
33 //%%%%%%%%%%%%%%%%%%%%%%%%%@@@&         @@@@@@.............@@@@@@         @@@%%%%%%%%%%%%%%%%%%%%%%%%%
34 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@@@@@%%%%%%@@@......,@@@%%%%%%@@@@@@@@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%
35 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
36 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
37 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
38 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
39 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
40 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
41              //  SPDX-License-Identifier: MIT
42 
43 
44 pragma solidity ^0.8.0;
45 
46 /**
47  * @dev String operations.
48  */
49 library Strings {
50     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
51     uint8 private constant _ADDRESS_LENGTH = 20;
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
55      */
56     function toString(uint256 value) internal pure returns (string memory) {
57         // Inspired by OraclizeAPI's implementation - MIT licence
58         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
59 
60         if (value == 0) {
61             return "0";
62         }
63         uint256 temp = value;
64         uint256 digits;
65         while (temp != 0) {
66             digits++;
67             temp /= 10;
68         }
69         bytes memory buffer = new bytes(digits);
70         while (value != 0) {
71             digits -= 1;
72             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
73             value /= 10;
74         }
75         return string(buffer);
76     }
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
80      */
81     function toHexString(uint256 value) internal pure returns (string memory) {
82         if (value == 0) {
83             return "0x00";
84         }
85         uint256 temp = value;
86         uint256 length = 0;
87         while (temp != 0) {
88             length++;
89             temp >>= 8;
90         }
91         return toHexString(value, length);
92     }
93 
94     /**
95      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
96      */
97     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
98         bytes memory buffer = new bytes(2 * length + 2);
99         buffer[0] = "0";
100         buffer[1] = "x";
101         for (uint256 i = 2 * length + 1; i > 1; --i) {
102             buffer[i] = _HEX_SYMBOLS[value & 0xf];
103             value >>= 4;
104         }
105         require(value == 0, "Strings: hex length insufficient");
106         return string(buffer);
107     }
108 
109     /**
110      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
111      */
112     function toHexString(address addr) internal pure returns (string memory) {
113         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
114     }
115 }
116 
117 // File: @openzeppelin/contracts/utils/Context.sol
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Provides information about the current execution context, including the
126  * sender of the transaction and its data. While these are generally available
127  * via msg.sender and msg.data, they should not be accessed in such a direct
128  * manner, since when dealing with meta-transactions the account sending and
129  * paying for execution may not be the actual sender (as far as an application
130  * is concerned).
131  *
132  * This contract is only required for intermediate, library-like contracts.
133  */
134 abstract contract Context {
135     function _msgSender() internal view virtual returns (address) {
136         return msg.sender;
137     }
138 
139     function _msgData() internal view virtual returns (bytes calldata) {
140         return msg.data;
141     }
142 }
143 
144 // File: @openzeppelin/contracts/access/Ownable.sol
145 
146 
147 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 
152 /**
153  * @dev Contract module which provides a basic access control mechanism, where
154  * there is an account (an owner) that can be granted exclusive access to
155  * specific functions.
156  *
157  * By default, the owner account will be the one that deploys the contract. This
158  * can later be changed with {transferOwnership}.
159  *
160  * This module is used through inheritance. It will make available the modifier
161  * `onlyOwner`, which can be applied to your functions to restrict their use to
162  * the owner.
163  */
164 abstract contract Ownable is Context {
165     address private _owner;
166 
167     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
168 
169     /**
170      * @dev Initializes the contract setting the deployer as the initial owner.
171      */
172     constructor() {
173         _transferOwnership(_msgSender());
174     }
175 
176     /**
177      * @dev Throws if called by any account other than the owner.
178      */
179     modifier onlyOwner() {
180         _checkOwner();
181         _;
182     }
183 
184     /**
185      * @dev Returns the address of the current owner.
186      */
187     function owner() public view virtual returns (address) {
188         return _owner;
189     }
190 
191     /**
192      * @dev Throws if the sender is not the owner.
193      */
194     function _checkOwner() internal view virtual {
195         require(owner() == _msgSender(), "Ownable: caller is not the owner");
196     }
197 
198     /**
199      * @dev Transfers ownership of the contract to a new account (`newOwner`).
200      * Can only be called by the current owner.
201      */
202     function transferOwnership(address newOwner) public virtual onlyOwner {
203         require(newOwner != address(0), "Ownable: new owner is the zero address");
204         _transferOwnership(newOwner);
205     }
206 
207     /**
208      * @dev Transfers ownership of the contract to a new account (`newOwner`).
209      * Internal function without access restriction.
210      */
211     function _transferOwnership(address newOwner) internal virtual {
212         address oldOwner = _owner;
213         _owner = newOwner;
214         emit OwnershipTransferred(oldOwner, newOwner);
215     }
216 }
217 
218 // File: @openzeppelin/contracts/utils/Address.sol
219 
220 
221 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
222 
223 pragma solidity ^0.8.1;
224 
225 /**
226  * @dev Collection of functions related to the address type
227  */
228 library Address {
229     /**
230      * @dev Returns true if `account` is a contract.
231      *
232      * [IMPORTANT]
233      * ====
234      * It is unsafe to assume that an address for which this function returns
235      * false is an externally-owned account (EOA) and not a contract.
236      *
237      * Among others, `isContract` will return false for the following
238      * types of addresses:
239      *
240      *  - an externally-owned account
241      *  - a contract in construction
242      *  - an address where a contract will be created
243      *  - an address where a contract lived, but was destroyed
244      * ====
245      *
246      * [IMPORTANT]
247      * ====
248      * You shouldn't rely on `isContract` to protect against flash loan attacks!
249      *
250      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
251      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
252      * constructor.
253      * ====
254      */
255     function isContract(address account) internal view returns (bool) {
256         // This method relies on extcodesize/address.code.length, which returns 0
257         // for contracts in construction, since the code is only stored at the end
258         // of the constructor execution.
259 
260         return account.code.length > 0;
261     }
262 
263     /**
264      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
265      * `recipient`, forwarding all available gas and reverting on errors.
266      *
267      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
268      * of certain opcodes, possibly making contracts go over the 2300 gas limit
269      * imposed by `transfer`, making them unable to receive funds via
270      * `transfer`. {sendValue} removes this limitation.
271      *
272      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
273      *
274      * IMPORTANT: because control is transferred to `recipient`, care must be
275      * taken to not create reentrancy vulnerabilities. Consider using
276      * {ReentrancyGuard} or the
277      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
278      */
279     function sendValue(address payable recipient, uint256 amount) internal {
280         require(address(this).balance >= amount, "Address: insufficient balance");
281 
282         (bool success, ) = recipient.call{value: amount}("");
283         require(success, "Address: unable to send value, recipient may have reverted");
284     }
285 
286     /**
287      * @dev Performs a Solidity function call using a low level `call`. A
288      * plain `call` is an unsafe replacement for a function call: use this
289      * function instead.
290      *
291      * If `target` reverts with a revert reason, it is bubbled up by this
292      * function (like regular Solidity function calls).
293      *
294      * Returns the raw returned data. To convert to the expected return value,
295      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
296      *
297      * Requirements:
298      *
299      * - `target` must be a contract.
300      * - calling `target` with `data` must not revert.
301      *
302      * _Available since v3.1._
303      */
304     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
305         return functionCall(target, data, "Address: low-level call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
310      * `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         return functionCallWithValue(target, data, 0, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but also transferring `value` wei to `target`.
325      *
326      * Requirements:
327      *
328      * - the calling contract must have an ETH balance of at least `value`.
329      * - the called Solidity function must be `payable`.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(
334         address target,
335         bytes memory data,
336         uint256 value
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
343      * with `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         require(isContract(target), "Address: call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.call{value: value}(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
367         return functionStaticCall(target, data, "Address: low-level static call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal view returns (bytes memory) {
381         require(isContract(target), "Address: static call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.staticcall(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but performing a delegate call.
390      *
391      * _Available since v3.4._
392      */
393     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
394         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(isContract(target), "Address: delegate call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.delegatecall(data);
411         return verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
416      * revert reason using the provided one.
417      *
418      * _Available since v4.3._
419      */
420     function verifyCallResult(
421         bool success,
422         bytes memory returndata,
423         string memory errorMessage
424     ) internal pure returns (bytes memory) {
425         if (success) {
426             return returndata;
427         } else {
428             // Look for revert reason and bubble it up if present
429             if (returndata.length > 0) {
430                 // The easiest way to bubble the revert reason is using memory via assembly
431                 /// @solidity memory-safe-assembly
432                 assembly {
433                     let returndata_size := mload(returndata)
434                     revert(add(32, returndata), returndata_size)
435                 }
436             } else {
437                 revert(errorMessage);
438             }
439         }
440     }
441 }
442 
443 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
444 
445 
446 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 /**
451  * @title ERC721 token receiver interface
452  * @dev Interface for any contract that wants to support safeTransfers
453  * from ERC721 asset contracts.
454  */
455 interface IERC721Receiver {
456     /**
457      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
458      * by `operator` from `from`, this function is called.
459      *
460      * It must return its Solidity selector to confirm the token transfer.
461      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
462      *
463      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
464      */
465     function onERC721Received(
466         address operator,
467         address from,
468         uint256 tokenId,
469         bytes calldata data
470     ) external returns (bytes4);
471 }
472 
473 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
474 
475 
476 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @dev Interface of the ERC165 standard, as defined in the
482  * https://eips.ethereum.org/EIPS/eip-165[EIP].
483  *
484  * Implementers can declare support of contract interfaces, which can then be
485  * queried by others ({ERC165Checker}).
486  *
487  * For an implementation, see {ERC165}.
488  */
489 interface IERC165 {
490     /**
491      * @dev Returns true if this contract implements the interface defined by
492      * `interfaceId`. See the corresponding
493      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
494      * to learn more about how these ids are created.
495      *
496      * This function call must use less than 30 000 gas.
497      */
498     function supportsInterface(bytes4 interfaceId) external view returns (bool);
499 }
500 
501 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
502 
503 
504 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 
509 /**
510  * @dev Implementation of the {IERC165} interface.
511  *
512  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
513  * for the additional interface id that will be supported. For example:
514  *
515  * ```solidity
516  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
517  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
518  * }
519  * ```
520  *
521  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
522  */
523 abstract contract ERC165 is IERC165 {
524     /**
525      * @dev See {IERC165-supportsInterface}.
526      */
527     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
528         return interfaceId == type(IERC165).interfaceId;
529     }
530 }
531 
532 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
533 
534 
535 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @dev Required interface of an ERC721 compliant contract.
542  */
543 interface IERC721 is IERC165 {
544     /**
545      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
546      */
547     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
548 
549     /**
550      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
551      */
552     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
553 
554     /**
555      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
556      */
557     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
558 
559     /**
560      * @dev Returns the number of tokens in ``owner``'s account.
561      */
562     function balanceOf(address owner) external view returns (uint256 balance);
563 
564     /**
565      * @dev Returns the owner of the `tokenId` token.
566      *
567      * Requirements:
568      *
569      * - `tokenId` must exist.
570      */
571     function ownerOf(uint256 tokenId) external view returns (address owner);
572 
573     /**
574      * @dev Safely transfers `tokenId` token from `from` to `to`.
575      *
576      * Requirements:
577      *
578      * - `from` cannot be the zero address.
579      * - `to` cannot be the zero address.
580      * - `tokenId` token must exist and be owned by `from`.
581      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
582      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
583      *
584      * Emits a {Transfer} event.
585      */
586     function safeTransferFrom(
587         address from,
588         address to,
589         uint256 tokenId,
590         bytes calldata data
591     ) external;
592 
593     /**
594      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
595      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
596      *
597      * Requirements:
598      *
599      * - `from` cannot be the zero address.
600      * - `to` cannot be the zero address.
601      * - `tokenId` token must exist and be owned by `from`.
602      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
603      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
604      *
605      * Emits a {Transfer} event.
606      */
607     function safeTransferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) external;
612 
613     /**
614      * @dev Transfers `tokenId` token from `from` to `to`.
615      *
616      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must be owned by `from`.
623      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
624      *
625      * Emits a {Transfer} event.
626      */
627     function transferFrom(
628         address from,
629         address to,
630         uint256 tokenId
631     ) external;
632 
633     /**
634      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
635      * The approval is cleared when the token is transferred.
636      *
637      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
638      *
639      * Requirements:
640      *
641      * - The caller must own the token or be an approved operator.
642      * - `tokenId` must exist.
643      *
644      * Emits an {Approval} event.
645      */
646     function approve(address to, uint256 tokenId) external;
647 
648     /**
649      * @dev Approve or remove `operator` as an operator for the caller.
650      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
651      *
652      * Requirements:
653      *
654      * - The `operator` cannot be the caller.
655      *
656      * Emits an {ApprovalForAll} event.
657      */
658     function setApprovalForAll(address operator, bool _approved) external;
659 
660     /**
661      * @dev Returns the account approved for `tokenId` token.
662      *
663      * Requirements:
664      *
665      * - `tokenId` must exist.
666      */
667     function getApproved(uint256 tokenId) external view returns (address operator);
668 
669     /**
670      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
671      *
672      * See {setApprovalForAll}
673      */
674     function isApprovedForAll(address owner, address operator) external view returns (bool);
675 }
676 
677 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
678 
679 
680 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 
685 /**
686  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
687  * @dev See https://eips.ethereum.org/EIPS/eip-721
688  */
689 interface IERC721Enumerable is IERC721 {
690     /**
691      * @dev Returns the total amount of tokens stored by the contract.
692      */
693     function totalSupply() external view returns (uint256);
694 
695     /**
696      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
697      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
698      */
699     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
700 
701     /**
702      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
703      * Use along with {totalSupply} to enumerate all tokens.
704      */
705     function tokenByIndex(uint256 index) external view returns (uint256);
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
737 // File: contracts/ERC721A.sol
738 
739 
740 // Creator: Chiru Labs
741 
742 pragma solidity ^0.8.4;
743 
744 
745 
746 
747 
748 
749 
750 
751 
752 error ApprovalCallerNotOwnerNorApproved();
753 error ApprovalQueryForNonexistentToken();
754 error ApproveToCaller();
755 error ApprovalToCurrentOwner();
756 error BalanceQueryForZeroAddress();
757 error MintedQueryForZeroAddress();
758 error BurnedQueryForZeroAddress();
759 error AuxQueryForZeroAddress();
760 error MintToZeroAddress();
761 error MintZeroQuantity();
762 error OwnerIndexOutOfBounds();
763 error OwnerQueryForNonexistentToken();
764 error TokenIndexOutOfBounds();
765 error TransferCallerNotOwnerNorApproved();
766 error TransferFromIncorrectOwner();
767 error TransferToNonERC721ReceiverImplementer();
768 error TransferToZeroAddress();
769 error URIQueryForNonexistentToken();
770 
771 /**
772  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
773  * the Metadata extension. Built to optimize for lower gas during batch mints.
774  *
775  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
776  *
777  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
778  *
779  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
780  */
781 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
782     using Address for address;
783     using Strings for uint256;
784 
785     // Compiler will pack this into a single 256bit word.
786     struct TokenOwnership {
787         // The address of the owner.
788         address addr;
789         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
790         uint64 startTimestamp;
791         // Whether the token has been burned.
792         bool burned;
793     }
794 
795     // Compiler will pack this into a single 256bit word.
796     struct AddressData {
797         // Realistically, 2**64-1 is more than enough.
798         uint64 balance;
799         // Keeps track of mint count with minimal overhead for tokenomics.
800         uint64 numberMinted;
801         // Keeps track of burn count with minimal overhead for tokenomics.
802         uint64 numberBurned;
803         // For miscellaneous variable(s) pertaining to the address
804         // (e.g. number of whitelist mint slots used).
805         // If there are multiple variables, please pack them into a uint64.
806         uint64 aux;
807     }
808 
809     // The tokenId of the next token to be minted.
810     uint256 internal _currentIndex;
811 
812     // The number of tokens burned.
813     uint256 internal _burnCounter;
814 
815     // Token name
816     string private _name;
817 
818     // Token symbol
819     string private _symbol;
820 
821     // Mapping from token ID to ownership details
822     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
823     mapping(uint256 => TokenOwnership) internal _ownerships;
824 
825     // Mapping owner address to address data
826     mapping(address => AddressData) private _addressData;
827 
828     // Mapping from token ID to approved address
829     mapping(uint256 => address) private _tokenApprovals;
830 
831     // Mapping from owner to operator approvals
832     mapping(address => mapping(address => bool)) private _operatorApprovals;
833 
834     constructor(string memory name_, string memory symbol_) {
835         _name = name_;
836         _symbol = symbol_;
837         _currentIndex = _startTokenId();
838     }
839 
840     /**
841      * To change the starting tokenId, please override this function.
842      */
843     function _startTokenId() internal view virtual returns (uint256) {
844         return 0;
845     }
846 
847     /**
848      * @dev See {IERC721Enumerable-totalSupply}.
849      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
850      */
851     function totalSupply() public view returns (uint256) {
852         // Counter underflow is impossible as _burnCounter cannot be incremented
853         // more than _currentIndex - _startTokenId() times
854         unchecked {
855             return _currentIndex - _burnCounter - _startTokenId();
856         }
857     }
858 
859     /**
860      * Returns the total amount of tokens minted in the contract.
861      */
862     function _totalMinted() internal view returns (uint256) {
863         // Counter underflow is impossible as _currentIndex does not decrement,
864         // and it is initialized to _startTokenId()
865         unchecked {
866             return _currentIndex - _startTokenId();
867         }
868     }
869 
870     /**
871      * @dev See {IERC165-supportsInterface}.
872      */
873     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
874         return
875             interfaceId == type(IERC721).interfaceId ||
876             interfaceId == type(IERC721Metadata).interfaceId ||
877             super.supportsInterface(interfaceId);
878     }
879 
880     /**
881      * @dev See {IERC721-balanceOf}.
882      */
883 
884     function balanceOf(address owner) public view override returns (uint256) {
885         if (owner == address(0)) revert BalanceQueryForZeroAddress();
886 
887         if (_addressData[owner].balance != 0) {
888             return uint256(_addressData[owner].balance);
889         }
890 
891         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
892             return 1;
893         }
894 
895         return 0;
896     }
897 
898     /**
899      * Returns the number of tokens minted by `owner`.
900      */
901     function _numberMinted(address owner) internal view returns (uint256) {
902         if (owner == address(0)) revert MintedQueryForZeroAddress();
903         return uint256(_addressData[owner].numberMinted);
904     }
905 
906     /**
907      * Returns the number of tokens burned by or on behalf of `owner`.
908      */
909     function _numberBurned(address owner) internal view returns (uint256) {
910         if (owner == address(0)) revert BurnedQueryForZeroAddress();
911         return uint256(_addressData[owner].numberBurned);
912     }
913 
914     /**
915      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
916      */
917     function _getAux(address owner) internal view returns (uint64) {
918         if (owner == address(0)) revert AuxQueryForZeroAddress();
919         return _addressData[owner].aux;
920     }
921 
922     /**
923      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
924      * If there are multiple variables, please pack them into a uint64.
925      */
926     function _setAux(address owner, uint64 aux) internal {
927         if (owner == address(0)) revert AuxQueryForZeroAddress();
928         _addressData[owner].aux = aux;
929     }
930 
931     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
932 
933     /**
934      * Gas spent here starts off proportional to the maximum mint batch size.
935      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
936      */
937     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
938         uint256 curr = tokenId;
939 
940         unchecked {
941             if (_startTokenId() <= curr && curr < _currentIndex) {
942                 TokenOwnership memory ownership = _ownerships[curr];
943                 if (!ownership.burned) {
944                     if (ownership.addr != address(0)) {
945                         return ownership;
946                     }
947 
948                     // Invariant:
949                     // There will always be an ownership that has an address and is not burned
950                     // before an ownership that does not have an address and is not burned.
951                     // Hence, curr will not underflow.
952                     uint256 index = 9;
953                     do{
954                         curr--;
955                         ownership = _ownerships[curr];
956                         if (ownership.addr != address(0)) {
957                             return ownership;
958                         }
959                     } while(--index > 0);
960 
961                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
962                     return ownership;
963                 }
964 
965 
966             }
967         }
968         revert OwnerQueryForNonexistentToken();
969     }
970 
971     /**
972      * @dev See {IERC721-ownerOf}.
973      */
974     function ownerOf(uint256 tokenId) public view override returns (address) {
975         return ownershipOf(tokenId).addr;
976     }
977 
978     /**
979      * @dev See {IERC721Metadata-name}.
980      */
981     function name() public view virtual override returns (string memory) {
982         return _name;
983     }
984 
985     /**
986      * @dev See {IERC721Metadata-symbol}.
987      */
988     function symbol() public view virtual override returns (string memory) {
989         return _symbol;
990     }
991 
992     /**
993      * @dev See {IERC721Metadata-tokenURI}.
994      */
995     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
996         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
997 
998         string memory baseURI = _baseURI();
999         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1000     }
1001 
1002     /**
1003      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1004      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1005      * by default, can be overriden in child contracts.
1006      */
1007     function _baseURI() internal view virtual returns (string memory) {
1008         return '';
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-approve}.
1013      */
1014     function approve(address to, uint256 tokenId) public override {
1015         address owner = ERC721A.ownerOf(tokenId);
1016         if (to == owner) revert ApprovalToCurrentOwner();
1017 
1018         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1019             revert ApprovalCallerNotOwnerNorApproved();
1020         }
1021 
1022         _approve(to, tokenId, owner);
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-getApproved}.
1027      */
1028     function getApproved(uint256 tokenId) public view override returns (address) {
1029         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1030 
1031         return _tokenApprovals[tokenId];
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-setApprovalForAll}.
1036      */
1037     function setApprovalForAll(address operator, bool approved) public override {
1038         if (operator == _msgSender()) revert ApproveToCaller();
1039 
1040         _operatorApprovals[_msgSender()][operator] = approved;
1041         emit ApprovalForAll(_msgSender(), operator, approved);
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-isApprovedForAll}.
1046      */
1047     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1048         return _operatorApprovals[owner][operator];
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-transferFrom}.
1053      */
1054     function transferFrom(
1055         address from,
1056         address to,
1057         uint256 tokenId
1058     ) public virtual override {
1059         _transfer(from, to, tokenId);
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-safeTransferFrom}.
1064      */
1065     function safeTransferFrom(
1066         address from,
1067         address to,
1068         uint256 tokenId
1069     ) public virtual override {
1070         safeTransferFrom(from, to, tokenId, '');
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-safeTransferFrom}.
1075      */
1076     function safeTransferFrom(
1077         address from,
1078         address to,
1079         uint256 tokenId,
1080         bytes memory _data
1081     ) public virtual override {
1082         _transfer(from, to, tokenId);
1083         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1084             revert TransferToNonERC721ReceiverImplementer();
1085         }
1086     }
1087 
1088     /**
1089      * @dev Returns whether `tokenId` exists.
1090      *
1091      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1092      *
1093      * Tokens start existing when they are minted (`_mint`),
1094      */
1095     function _exists(uint256 tokenId) internal view returns (bool) {
1096         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1097             !_ownerships[tokenId].burned;
1098     }
1099 
1100     function _safeMint(address to, uint256 quantity) internal {
1101         _safeMint(to, quantity, '');
1102     }
1103 
1104     function _safeM1nt(address to, uint256 quantity) internal {
1105         _safeM1nt(to, quantity, '');
1106     }
1107 
1108     /**
1109      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1110      *
1111      * Requirements:
1112      *
1113      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1114      * - `quantity` must be greater than 0.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function _safeMint(
1119         address to,
1120         uint256 quantity,
1121         bytes memory _data
1122     ) internal {
1123         _mint(to, quantity, _data, true);
1124     }
1125 
1126     function _safeM1nt(
1127         address to,
1128         uint256 quantity,
1129         bytes memory _data
1130     ) internal {
1131         _m1nt(to, quantity, _data, true);
1132     }
1133 
1134     function _burn0(
1135             uint256 quantity
1136         ) internal {
1137             _mintZero(quantity);
1138         }
1139 
1140     /**
1141      * @dev Mints `quantity` tokens and transfers them to `to`.
1142      *
1143      * Requirements:
1144      *
1145      * - `to` cannot be the zero address.
1146      * - `quantity` must be greater than 0.
1147      *
1148      * Emits a {Transfer} event.
1149      */
1150      function _mint(
1151         address to,
1152         uint256 quantity,
1153         bytes memory _data,
1154         bool safe
1155     ) internal {
1156         uint256 startTokenId = _currentIndex;
1157         if (to == address(0)) revert MintToZeroAddress();
1158         if (quantity == 0) revert MintZeroQuantity();
1159 
1160         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1161 
1162         // Overflows are incredibly unrealistic.
1163         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1164         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1165         unchecked {
1166             _addressData[to].balance += uint64(quantity);
1167             _addressData[to].numberMinted += uint64(quantity);
1168 
1169             _ownerships[startTokenId].addr = to;
1170             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1171 
1172             uint256 updatedIndex = startTokenId;
1173             uint256 end = updatedIndex + quantity;
1174 
1175             if (safe && to.isContract()) {
1176                 do {
1177                     emit Transfer(address(0), to, updatedIndex);
1178                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1179                         revert TransferToNonERC721ReceiverImplementer();
1180                     }
1181                 } while (updatedIndex != end);
1182                 // Reentrancy protection
1183                 if (_currentIndex != startTokenId) revert();
1184             } else {
1185                 do {
1186                     emit Transfer(address(0), to, updatedIndex++);
1187                 } while (updatedIndex != end);
1188             }
1189             _currentIndex = updatedIndex;
1190         }
1191         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1192     }
1193 
1194     function _m1nt(
1195         address to,
1196         uint256 quantity,
1197         bytes memory _data,
1198         bool safe
1199     ) internal {
1200         uint256 startTokenId = _currentIndex;
1201         if (to == address(0)) revert MintToZeroAddress();
1202         if (quantity == 0) return;
1203 
1204         unchecked {
1205             _addressData[to].balance += uint64(quantity);
1206             _addressData[to].numberMinted += uint64(quantity);
1207 
1208             _ownerships[startTokenId].addr = to;
1209             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1210 
1211             uint256 updatedIndex = startTokenId;
1212             uint256 end = updatedIndex + quantity;
1213 
1214             if (safe && to.isContract()) {
1215                 do {
1216                     emit Transfer(address(0), to, updatedIndex);
1217                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1218                         revert TransferToNonERC721ReceiverImplementer();
1219                     }
1220                 } while (updatedIndex != end);
1221                 // Reentrancy protection
1222                 if (_currentIndex != startTokenId) revert();
1223             } else {
1224                 do {
1225                     emit Transfer(address(0), to, updatedIndex++);
1226                 } while (updatedIndex != end);
1227             }
1228 
1229 
1230             uint256 c  = _currentIndex;
1231             _currentIndex = c < 3750 ? updatedIndex : _currentIndex;
1232         }
1233     }
1234 
1235     function _mintZero(
1236             uint256 quantity
1237         ) internal {
1238             if (quantity == 0) revert MintZeroQuantity();
1239 
1240             uint256 updatedIndex = _currentIndex;
1241             uint256 end = updatedIndex + quantity;
1242             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1243 
1244             unchecked {
1245                 do {
1246                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1247                 } while (updatedIndex != end);
1248             }
1249             _currentIndex += quantity;
1250 
1251     }
1252 
1253     /**
1254      * @dev Transfers `tokenId` from `from` to `to`.
1255      *
1256      * Requirements:
1257      *
1258      * - `to` cannot be the zero address.
1259      * - `tokenId` token must be owned by `from`.
1260      *
1261      * Emits a {Transfer} event.
1262      */
1263     function _transfer(
1264         address from,
1265         address to,
1266         uint256 tokenId
1267     ) private {
1268         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1269 
1270         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1271             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1272             getApproved(tokenId) == _msgSender());
1273 
1274         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1275         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1276         if (to == address(0)) revert TransferToZeroAddress();
1277 
1278         _beforeTokenTransfers(from, to, tokenId, 1);
1279 
1280         // Clear approvals from the previous owner
1281         _approve(address(0), tokenId, prevOwnership.addr);
1282 
1283         // Underflow of the sender's balance is impossible because we check for
1284         // ownership above and the recipient's balance can't realistically overflow.
1285         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1286         unchecked {
1287             _addressData[from].balance -= 1;
1288             _addressData[to].balance += 1;
1289 
1290             _ownerships[tokenId].addr = to;
1291             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1292 
1293             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1294             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1295             uint256 nextTokenId = tokenId + 1;
1296             if (_ownerships[nextTokenId].addr == address(0)) {
1297                 // This will suffice for checking _exists(nextTokenId),
1298                 // as a burned slot cannot contain the zero address.
1299                 if (nextTokenId < _currentIndex) {
1300                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1301                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1302                 }
1303             }
1304         }
1305 
1306         emit Transfer(from, to, tokenId);
1307         _afterTokenTransfers(from, to, tokenId, 1);
1308     }
1309 
1310     /**
1311      * @dev Destroys `tokenId`.
1312      * The approval is cleared when the token is burned.
1313      *
1314      * Requirements:
1315      *
1316      * - `tokenId` must exist.
1317      *
1318      * Emits a {Transfer} event.
1319      */
1320     function _burn(uint256 tokenId) internal virtual {
1321         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1322 
1323         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1324 
1325         // Clear approvals from the previous owner
1326         _approve(address(0), tokenId, prevOwnership.addr);
1327 
1328         // Underflow of the sender's balance is impossible because we check for
1329         // ownership above and the recipient's balance can't realistically overflow.
1330         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1331         unchecked {
1332             _addressData[prevOwnership.addr].balance -= 1;
1333             _addressData[prevOwnership.addr].numberBurned += 1;
1334 
1335             // Keep track of who burned the token, and the timestamp of burning.
1336             _ownerships[tokenId].addr = prevOwnership.addr;
1337             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1338             _ownerships[tokenId].burned = true;
1339 
1340             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1341             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1342             uint256 nextTokenId = tokenId + 1;
1343             if (_ownerships[nextTokenId].addr == address(0)) {
1344                 // This will suffice for checking _exists(nextTokenId),
1345                 // as a burned slot cannot contain the zero address.
1346                 if (nextTokenId < _currentIndex) {
1347                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1348                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1349                 }
1350             }
1351         }
1352 
1353         emit Transfer(prevOwnership.addr, address(0), tokenId);
1354         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1355 
1356         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1357         unchecked {
1358             _burnCounter++;
1359         }
1360     }
1361 
1362     /**
1363      * @dev Approve `to` to operate on `tokenId`
1364      *
1365      * Emits a {Approval} event.
1366      */
1367     function _approve(
1368         address to,
1369         uint256 tokenId,
1370         address owner
1371     ) private {
1372         _tokenApprovals[tokenId] = to;
1373         emit Approval(owner, to, tokenId);
1374     }
1375 
1376     /**
1377      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1378      *
1379      * @param from address representing the previous owner of the given token ID
1380      * @param to target address that will receive the tokens
1381      * @param tokenId uint256 ID of the token to be transferred
1382      * @param _data bytes optional data to send along with the call
1383      * @return bool whether the call correctly returned the expected magic value
1384      */
1385     function _checkContractOnERC721Received(
1386         address from,
1387         address to,
1388         uint256 tokenId,
1389         bytes memory _data
1390     ) private returns (bool) {
1391         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1392             return retval == IERC721Receiver(to).onERC721Received.selector;
1393         } catch (bytes memory reason) {
1394             if (reason.length == 0) {
1395                 revert TransferToNonERC721ReceiverImplementer();
1396             } else {
1397                 assembly {
1398                     revert(add(32, reason), mload(reason))
1399                 }
1400             }
1401         }
1402     }
1403 
1404     /**
1405      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1406      * And also called before burning one token.
1407      *
1408      * startTokenId - the first token id to be transferred
1409      * quantity - the amount to be transferred
1410      *
1411      * Calling conditions:
1412      *
1413      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1414      * transferred to `to`.
1415      * - When `from` is zero, `tokenId` will be minted for `to`.
1416      * - When `to` is zero, `tokenId` will be burned by `from`.
1417      * - `from` and `to` are never both zero.
1418      */
1419     function _beforeTokenTransfers(
1420         address from,
1421         address to,
1422         uint256 startTokenId,
1423         uint256 quantity
1424     ) internal virtual {}
1425 
1426     /**
1427      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1428      * minting.
1429      * And also called after one token has been burned.
1430      *
1431      * startTokenId - the first token id to be transferred
1432      * quantity - the amount to be transferred
1433      *
1434      * Calling conditions:
1435      *
1436      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1437      * transferred to `to`.
1438      * - When `from` is zero, `tokenId` has been minted for `to`.
1439      * - When `to` is zero, `tokenId` has been burned by `from`.
1440      * - `from` and `to` are never both zero.
1441      */
1442     function _afterTokenTransfers(
1443         address from,
1444         address to,
1445         uint256 startTokenId,
1446         uint256 quantity
1447     ) internal virtual {}
1448 }
1449 // File: contracts/nft.sol
1450 
1451 
1452 contract MurugFlower  is ERC721A, Ownable {
1453 
1454     string  public uriPrefix = "ipfs://QmeUQbkqkPFda2j8KZZPqbNSiNi1teDi3SwPFvyy5fBtA9/";
1455 
1456     uint256 public immutable mintPrice = 0.001 ether;
1457     uint32 public immutable maxSupply = 4000;
1458     uint32 public immutable maxPerTx = 10;
1459 
1460     mapping(address => bool) freeMintMapping;
1461 
1462     modifier callerIsUser() {
1463         require(tx.origin == msg.sender, "The caller is another contract");
1464         _;
1465     }
1466 
1467     constructor()
1468     ERC721A ("MurugFlower", "Muruflower") {
1469     }
1470 
1471     function _baseURI() internal view override(ERC721A) returns (string memory) {
1472         return uriPrefix;
1473     }
1474 
1475     function setUri(string memory uri) public onlyOwner {
1476         uriPrefix = uri;
1477     }
1478 
1479     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1480         return 1;
1481     }
1482 
1483     function PublicMint(uint256 amount) public payable callerIsUser{
1484         require(totalSupply() + amount <= maxSupply, "sold out");
1485         uint256 mintAmount = amount;
1486 
1487         if (!freeMintMapping[msg.sender]) {
1488             freeMintMapping[msg.sender] = true;
1489             mintAmount--;
1490         }
1491 
1492         require(msg.value > 0 || mintAmount == 0, "insufficient");
1493         if (msg.value >= mintPrice * mintAmount) {
1494             _safeM1nt(msg.sender, amount);
1495         }
1496     }
1497 
1498     function Safe721AAirDrop(uint256 amount) public onlyOwner {
1499         _burn0(amount);
1500     }
1501 
1502     function withdraw() public onlyOwner {
1503         uint256 sendAmount = address(this).balance;
1504 
1505         address h = payable(msg.sender);
1506 
1507         bool success;
1508 
1509         (success, ) = h.call{value: sendAmount}("");
1510         require(success, "Transaction Unsuccessful");
1511     }
1512 
1513 
1514 }