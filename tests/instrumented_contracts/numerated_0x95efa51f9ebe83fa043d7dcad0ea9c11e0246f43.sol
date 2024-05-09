1 //**// SPDX-License-Identifier: MIT////////////////////////////////////////////////
2 // *,,****,,,,,,,,,,,,,,,,,,*,**********@***********、/#***////////////////////////
3 // ******,,,,,,,,,,,,,,,,,,,,,,,*********#@**************////////*//////********///
4 // ***,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,********@&*******////**********************
5 // ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@*@/@***********************************
6 // **,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*@@*******************,,,,,,,,,****,***
7 // ***,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,**@@*******************,,,,,,,,,,,,,,,**
8 // **,,*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,***%#**********,,,,,,****,,,,,,,,,,,,,,,,
9 // ******,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,**** /*****,,**,,,,,,,,,,,,,,,,,,,,,,,,,,,
10 // *******,,,,,*,,,,,,,   ,,,,,,,,,,,,,,,****  @*****,*,,,,,,,,,,,,,,,,,,,,,,,,,,,,
11 // ********,*,***,,,,,,,,,,,,,,,,,,,,,,,,,@(/((.*%,,,,,,,,**,,,,,,*****,,,,,,,,,,,,
12 // ///*****************,**,,,,,,,,,***,,,&    (%.%&&,,,,,*,***,********************
13 // /////******************************* *      ..,,/#,****,************************
14 // /////*/**/*************************      #(....,*%@*****************************
15 // /////////////*****************///%/     ./,....,*/(*****************************
16 // ((((((((///(/****************///    /    .&*/&&&%/&*****************************
17 // ((((((((#(((/**,,******/////////   #,  , ..  ..,*%(*****************************
18 // ####/.(###((//*,,**////////////    /    .......,*/(#/**************************/
19 // ###########((///*//////////////  /     ......,**(%//***************************/
20 // ####%%%%%%##(((/////////((/((((&      ......,*/(///*******************/////////*
21 // %%%%%%%%%%%###(((((((*//(((((((## , %  .....,*@@((///*****//////////////////////
22 // %%%%%%%%%%%%##########((((#######(   .  .#..,*(%((((/////*//////////////////////
23 // %%%%%%%%%%%%%%%################%#    &( ... ,*/(@((((((////(/////(((((///((/((((
24 // &&&&&&&&&&%%%%%%%%%##########%%%%/     ../..,*&(@###((((((((((((((((((((((((((((
25 // &&&&&&&&&&&%%%%%%%#######%%%%%%%%%      .....*/((############(((((((((((((((((((
26 // &&&&&&&&&&&&&%%%%#######%%%%%%%%%%%   * . .. /(&%%%%%############(##############
27 // &&&&&&&&&&&&&%%%%%######%%%%%%%%%%%%./% ....*#@%%%%%%%%%%%%%%%%%%%%#############
28 // &&&&&&&&&&&&&&&&&%###%%%%%%%&&&&&&&&& .%..,%&&%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
29 // &&&&&&&&&&&&&&&&&&%%%%&&&&&&&&&&&&&&&&&@&&&&&&&&&&&&&&%%%%%%&&&&&&&&&&&&&&&%&&&&
30 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
31 // &&&&&@&&&&&@&&&%&&&&&&&&&&&&&&&&&&@@@@&&&&&&&&&&&&&&&&&&&&&&&&%&&&&&%&&&&&&&&&&&
32 // @@@@@@&@@@@@&@@@@@&&&&&&&&&&&&&@@@@@@@@@@@@@@@@@&&&&@&&&&&&&&@@@@@@@@@@@@@@@@@@@
33 // @@@@@@@@@@@@@@@@@@@@@@&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev String operations.
38  */
39 library Strings {
40     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
41     uint8 private constant _ADDRESS_LENGTH = 20;
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
45      */
46     function toString(uint256 value) internal pure returns (string memory) {
47         // Inspired by OraclizeAPI's implementation - MIT licence
48         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
49 
50         if (value == 0) {
51             return "0";
52         }
53         uint256 temp = value;
54         uint256 digits;
55         while (temp != 0) {
56             digits++;
57             temp /= 10;
58         }
59         bytes memory buffer = new bytes(digits);
60         while (value != 0) {
61             digits -= 1;
62             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
63             value /= 10;
64         }
65         return string(buffer);
66     }
67 
68     /**
69      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
70      */
71     function toHexString(uint256 value) internal pure returns (string memory) {
72         if (value == 0) {
73             return "0x00";
74         }
75         uint256 temp = value;
76         uint256 length = 0;
77         while (temp != 0) {
78             length++;
79             temp >>= 8;
80         }
81         return toHexString(value, length);
82     }
83 
84     /**
85      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
86      */
87     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
88         bytes memory buffer = new bytes(2 * length + 2);
89         buffer[0] = "0";
90         buffer[1] = "x";
91         for (uint256 i = 2 * length + 1; i > 1; --i) {
92             buffer[i] = _HEX_SYMBOLS[value & 0xf];
93             value >>= 4;
94         }
95         require(value == 0, "Strings: hex length insufficient");
96         return string(buffer);
97     }
98 
99     /**
100      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
101      */
102     function toHexString(address addr) internal pure returns (string memory) {
103         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
104     }
105 }
106 
107 // File: @openzeppelin/contracts/utils/Context.sol
108 
109 
110 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @dev Provides information about the current execution context, including the
116  * sender of the transaction and its data. While these are generally available
117  * via msg.sender and msg.data, they should not be accessed in such a direct
118  * manner, since when dealing with meta-transactions the account sending and
119  * paying for execution may not be the actual sender (as far as an application
120  * is concerned).
121  *
122  * This contract is only required for intermediate, library-like contracts.
123  */
124 abstract contract Context {
125     function _msgSender() internal view virtual returns (address) {
126         return msg.sender;
127     }
128 
129     function _msgData() internal view virtual returns (bytes calldata) {
130         return msg.data;
131     }
132 }
133 
134 // File: @openzeppelin/contracts/access/Ownable.sol
135 
136 
137 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
138 
139 pragma solidity ^0.8.0;
140 
141 
142 /**
143  * @dev Contract module which provides a basic access control mechanism, where
144  * there is an account (an owner) that can be granted exclusive access to
145  * specific functions.
146  *
147  * By default, the owner account will be the one that deploys the contract. This
148  * can later be changed with {transferOwnership}.
149  *
150  * This module is used through inheritance. It will make available the modifier
151  * `onlyOwner`, which can be applied to your functions to restrict their use to
152  * the owner.
153  */
154 abstract contract Ownable is Context {
155     address private _owner;
156 
157     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
158 
159     /**
160      * @dev Initializes the contract setting the deployer as the initial owner.
161      */
162     constructor() {
163         _transferOwnership(_msgSender());
164     }
165 
166     /**
167      * @dev Throws if called by any account other than the owner.
168      */
169     modifier onlyOwner() {
170         _checkOwner();
171         _;
172     }
173 
174     /**
175      * @dev Returns the address of the current owner.
176      */
177     function owner() public view virtual returns (address) {
178         return _owner;
179     }
180 
181     /**
182      * @dev Throws if the sender is not the owner.
183      */
184     function _checkOwner() internal view virtual {
185         require(owner() == _msgSender(), "Ownable: caller is not the owner");
186     }
187 
188     /**
189      * @dev Transfers ownership of the contract to a new account (`newOwner`).
190      * Can only be called by the current owner.
191      */
192     function transferOwnership(address newOwner) public virtual onlyOwner {
193         require(newOwner != address(0), "Ownable: new owner is the zero address");
194         _transferOwnership(newOwner);
195     }
196 
197     /**
198      * @dev Transfers ownership of the contract to a new account (`newOwner`).
199      * Internal function without access restriction.
200      */
201     function _transferOwnership(address newOwner) internal virtual {
202         address oldOwner = _owner;
203         _owner = newOwner;
204         emit OwnershipTransferred(oldOwner, newOwner);
205     }
206 }
207 
208 // File: @openzeppelin/contracts/utils/Address.sol
209 
210 
211 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
212 
213 pragma solidity ^0.8.1;
214 
215 /**
216  * @dev Collection of functions related to the address type
217  */
218 library Address {
219     /**
220      * @dev Returns true if `account` is a contract.
221      *
222      * [IMPORTANT]
223      * ====
224      * It is unsafe to assume that an address for which this function returns
225      * false is an externally-owned account (EOA) and not a contract.
226      *
227      * Among others, `isContract` will return false for the following
228      * types of addresses:
229      *
230      *  - an externally-owned account
231      *  - a contract in construction
232      *  - an address where a contract will be created
233      *  - an address where a contract lived, but was destroyed
234      * ====
235      *
236      * [IMPORTANT]
237      * ====
238      * You shouldn't rely on `isContract` to protect against flash loan attacks!
239      *
240      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
241      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
242      * constructor.
243      * ====
244      */
245     function isContract(address account) internal view returns (bool) {
246         // This method relies on extcodesize/address.code.length, which returns 0
247         // for contracts in construction, since the code is only stored at the end
248         // of the constructor execution.
249 
250         return account.code.length > 0;
251     }
252 
253     /**
254      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
255      * `recipient`, forwarding all available gas and reverting on errors.
256      *
257      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
258      * of certain opcodes, possibly making contracts go over the 2300 gas limit
259      * imposed by `transfer`, making them unable to receive funds via
260      * `transfer`. {sendValue} removes this limitation.
261      *
262      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
263      *
264      * IMPORTANT: because control is transferred to `recipient`, care must be
265      * taken to not create reentrancy vulnerabilities. Consider using
266      * {ReentrancyGuard} or the
267      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
268      */
269     function sendValue(address payable recipient, uint256 amount) internal {
270         require(address(this).balance >= amount, "Address: insufficient balance");
271 
272         (bool success, ) = recipient.call{value: amount}("");
273         require(success, "Address: unable to send value, recipient may have reverted");
274     }
275 
276     /**
277      * @dev Performs a Solidity function call using a low level `call`. A
278      * plain `call` is an unsafe replacement for a function call: use this
279      * function instead.
280      *
281      * If `target` reverts with a revert reason, it is bubbled up by this
282      * function (like regular Solidity function calls).
283      *
284      * Returns the raw returned data. To convert to the expected return value,
285      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
286      *
287      * Requirements:
288      *
289      * - `target` must be a contract.
290      * - calling `target` with `data` must not revert.
291      *
292      * _Available since v3.1._
293      */
294     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
295         return functionCall(target, data, "Address: low-level call failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
300      * `errorMessage` as a fallback revert reason when `target` reverts.
301      *
302      * _Available since v3.1._
303      */
304     function functionCall(
305         address target,
306         bytes memory data,
307         string memory errorMessage
308     ) internal returns (bytes memory) {
309         return functionCallWithValue(target, data, 0, errorMessage);
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
314      * but also transferring `value` wei to `target`.
315      *
316      * Requirements:
317      *
318      * - the calling contract must have an ETH balance of at least `value`.
319      * - the called Solidity function must be `payable`.
320      *
321      * _Available since v3.1._
322      */
323     function functionCallWithValue(
324         address target,
325         bytes memory data,
326         uint256 value
327     ) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
333      * with `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(
338         address target,
339         bytes memory data,
340         uint256 value,
341         string memory errorMessage
342     ) internal returns (bytes memory) {
343         require(address(this).balance >= value, "Address: insufficient balance for call");
344         require(isContract(target), "Address: call to non-contract");
345 
346         (bool success, bytes memory returndata) = target.call{value: value}(data);
347         return verifyCallResult(success, returndata, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but performing a static call.
353      *
354      * _Available since v3.3._
355      */
356     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
357         return functionStaticCall(target, data, "Address: low-level static call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(
367         address target,
368         bytes memory data,
369         string memory errorMessage
370     ) internal view returns (bytes memory) {
371         require(isContract(target), "Address: static call to non-contract");
372 
373         (bool success, bytes memory returndata) = target.staticcall(data);
374         return verifyCallResult(success, returndata, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but performing a delegate call.
380      *
381      * _Available since v3.4._
382      */
383     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
384         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
389      * but performing a delegate call.
390      *
391      * _Available since v3.4._
392      */
393     function functionDelegateCall(
394         address target,
395         bytes memory data,
396         string memory errorMessage
397     ) internal returns (bytes memory) {
398         require(isContract(target), "Address: delegate call to non-contract");
399 
400         (bool success, bytes memory returndata) = target.delegatecall(data);
401         return verifyCallResult(success, returndata, errorMessage);
402     }
403 
404     /**
405      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
406      * revert reason using the provided one.
407      *
408      * _Available since v4.3._
409      */
410     function verifyCallResult(
411         bool success,
412         bytes memory returndata,
413         string memory errorMessage
414     ) internal pure returns (bytes memory) {
415         if (success) {
416             return returndata;
417         } else {
418             // Look for revert reason and bubble it up if present
419             if (returndata.length > 0) {
420                 // The easiest way to bubble the revert reason is using memory via assembly
421                 /// @solidity memory-safe-assembly
422                 assembly {
423                     let returndata_size := mload(returndata)
424                     revert(add(32, returndata), returndata_size)
425                 }
426             } else {
427                 revert(errorMessage);
428             }
429         }
430     }
431 }
432 
433 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
434 
435 
436 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
437 
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
453      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
454      */
455     function onERC721Received(
456         address operator,
457         address from,
458         uint256 tokenId,
459         bytes calldata data
460     ) external returns (bytes4);
461 }
462 
463 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
464 
465 
466 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 /**
471  * @dev Interface of the ERC165 standard, as defined in the
472  * https://eips.ethereum.org/EIPS/eip-165[EIP].
473  *
474  * Implementers can declare support of contract interfaces, which can then be
475  * queried by others ({ERC165Checker}).
476  *
477  * For an implementation, see {ERC165}.
478  */
479 interface IERC165 {
480     /**
481      * @dev Returns true if this contract implements the interface defined by
482      * `interfaceId`. See the corresponding
483      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
484      * to learn more about how these ids are created.
485      *
486      * This function call must use less than 30 000 gas.
487      */
488     function supportsInterface(bytes4 interfaceId) external view returns (bool);
489 }
490 
491 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 
499 /**
500  * @dev Implementation of the {IERC165} interface.
501  *
502  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
503  * for the additional interface id that will be supported. For example:
504  *
505  * ```solidity
506  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
507  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
508  * }
509  * ```
510  *
511  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
512  */
513 abstract contract ERC165 is IERC165 {
514     /**
515      * @dev See {IERC165-supportsInterface}.
516      */
517     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
518         return interfaceId == type(IERC165).interfaceId;
519     }
520 }
521 
522 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
523 
524 
525 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 
530 /**
531  * @dev Required interface of an ERC721 compliant contract.
532  */
533 interface IERC721 is IERC165 {
534     /**
535      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
536      */
537     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
538 
539     /**
540      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
541      */
542     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
543 
544     /**
545      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
546      */
547     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
548 
549     /**
550      * @dev Returns the number of tokens in ``owner``'s account.
551      */
552     function balanceOf(address owner) external view returns (uint256 balance);
553 
554     /**
555      * @dev Returns the owner of the `tokenId` token.
556      *
557      * Requirements:
558      *
559      * - `tokenId` must exist.
560      */
561     function ownerOf(uint256 tokenId) external view returns (address owner);
562 
563     /**
564      * @dev Safely transfers `tokenId` token from `from` to `to`.
565      *
566      * Requirements:
567      *
568      * - `from` cannot be the zero address.
569      * - `to` cannot be the zero address.
570      * - `tokenId` token must exist and be owned by `from`.
571      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
572      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
573      *
574      * Emits a {Transfer} event.
575      */
576     function safeTransferFrom(
577         address from,
578         address to,
579         uint256 tokenId,
580         bytes calldata data
581     ) external;
582 
583     /**
584      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
585      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
586      *
587      * Requirements:
588      *
589      * - `from` cannot be the zero address.
590      * - `to` cannot be the zero address.
591      * - `tokenId` token must exist and be owned by `from`.
592      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
593      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
594      *
595      * Emits a {Transfer} event.
596      */
597     function safeTransferFrom(
598         address from,
599         address to,
600         uint256 tokenId
601     ) external;
602 
603     /**
604      * @dev Transfers `tokenId` token from `from` to `to`.
605      *
606      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
607      *
608      * Requirements:
609      *
610      * - `from` cannot be the zero address.
611      * - `to` cannot be the zero address.
612      * - `tokenId` token must be owned by `from`.
613      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
614      *
615      * Emits a {Transfer} event.
616      */
617     function transferFrom(
618         address from,
619         address to,
620         uint256 tokenId
621     ) external;
622 
623     /**
624      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
625      * The approval is cleared when the token is transferred.
626      *
627      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
628      *
629      * Requirements:
630      *
631      * - The caller must own the token or be an approved operator.
632      * - `tokenId` must exist.
633      *
634      * Emits an {Approval} event.
635      */
636     function approve(address to, uint256 tokenId) external;
637 
638     /**
639      * @dev Approve or remove `operator` as an operator for the caller.
640      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
641      *
642      * Requirements:
643      *
644      * - The `operator` cannot be the caller.
645      *
646      * Emits an {ApprovalForAll} event.
647      */
648     function setApprovalForAll(address operator, bool _approved) external;
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
660      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
661      *
662      * See {setApprovalForAll}
663      */
664     function isApprovedForAll(address owner, address operator) external view returns (bool);
665 }
666 
667 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
668 
669 
670 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
671 
672 pragma solidity ^0.8.0;
673 
674 
675 /**
676  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
677  * @dev See https://eips.ethereum.org/EIPS/eip-721
678  */
679 interface IERC721Enumerable is IERC721 {
680     /**
681      * @dev Returns the total amount of tokens stored by the contract.
682      */
683     function totalSupply() external view returns (uint256);
684 
685     /**
686      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
687      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
688      */
689     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
690 
691     /**
692      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
693      * Use along with {totalSupply} to enumerate all tokens.
694      */
695     function tokenByIndex(uint256 index) external view returns (uint256);
696 }
697 
698 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
699 
700 
701 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
702 
703 pragma solidity ^0.8.0;
704 
705 
706 /**
707  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
708  * @dev See https://eips.ethereum.org/EIPS/eip-721
709  */
710 interface IERC721Metadata is IERC721 {
711     /**
712      * @dev Returns the token collection name.
713      */
714     function name() external view returns (string memory);
715 
716     /**
717      * @dev Returns the token collection symbol.
718      */
719     function symbol() external view returns (string memory);
720 
721     /**
722      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
723      */
724     function tokenURI(uint256 tokenId) external view returns (string memory);
725 }
726 
727 // File: contracts/ERC721A.sol
728 
729 
730 // Creator: Chiru Labs
731 
732 pragma solidity ^0.8.4;
733 
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
747 error MintedQueryForZeroAddress();
748 error BurnedQueryForZeroAddress();
749 error AuxQueryForZeroAddress();
750 error MintToZeroAddress();
751 error MintZeroQuantity();
752 error OwnerIndexOutOfBounds();
753 error OwnerQueryForNonexistentToken();
754 error TokenIndexOutOfBounds();
755 error TransferCallerNotOwnerNorApproved();
756 error TransferFromIncorrectOwner();
757 error TransferToNonERC721ReceiverImplementer();
758 error TransferToZeroAddress();
759 error URIQueryForNonexistentToken();
760 
761 /**
762  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
763  * the Metadata extension. Built to optimize for lower gas during batch mints.
764  *
765  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
766  *
767  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
768  *
769  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
770  */
771 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
772     using Address for address;
773     using Strings for uint256;
774 
775     // Compiler will pack this into a single 256bit word.
776     struct TokenOwnership {
777         // The address of the owner.
778         address addr;
779         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
780         uint64 startTimestamp;
781         // Whether the token has been burned.
782         bool burned;
783     }
784 
785     // Compiler will pack this into a single 256bit word.
786     struct AddressData {
787         // Realistically, 2**64-1 is more than enough.
788         uint64 balance;
789         // Keeps track of mint count with minimal overhead for tokenomics.
790         uint64 numberMinted;
791         // Keeps track of burn count with minimal overhead for tokenomics.
792         uint64 numberBurned;
793         // For miscellaneous variable(s) pertaining to the address
794         // (e.g. number of whitelist mint slots used).
795         // If there are multiple variables, please pack them into a uint64.
796         uint64 aux;
797     }
798 
799     // The tokenId of the next token to be minted.
800     uint256 internal _currentIndex;
801 
802     // The number of tokens burned.
803     uint256 internal _burnCounter;
804 
805     // Token name
806     string private _name;
807 
808     // Token symbol
809     string private _symbol;
810 
811     // Mapping from token ID to ownership details
812     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
813     mapping(uint256 => TokenOwnership) internal _ownerships;
814 
815     // Mapping owner address to address data
816     mapping(address => AddressData) private _addressData;
817 
818     // Mapping from token ID to approved address
819     mapping(uint256 => address) private _tokenApprovals;
820 
821     // Mapping from owner to operator approvals
822     mapping(address => mapping(address => bool)) private _operatorApprovals;
823 
824     constructor(string memory name_, string memory symbol_) {
825         _name = name_;
826         _symbol = symbol_;
827         _currentIndex = _startTokenId();
828     }
829 
830     /**
831      * To change the starting tokenId, please override this function.
832      */
833     function _startTokenId() internal view virtual returns (uint256) {
834         return 0;
835     }
836 
837     /**
838      * @dev See {IERC721Enumerable-totalSupply}.
839      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
840      */
841     function totalSupply() public view returns (uint256) {
842         // Counter underflow is impossible as _burnCounter cannot be incremented
843         // more than _currentIndex - _startTokenId() times
844         unchecked {
845             return _currentIndex - _burnCounter - _startTokenId();
846         }
847     }
848 
849     /**
850      * Returns the total amount of tokens minted in the contract.
851      */
852     function _totalMinted() internal view returns (uint256) {
853         // Counter underflow is impossible as _currentIndex does not decrement,
854         // and it is initialized to _startTokenId()
855         unchecked {
856             return _currentIndex - _startTokenId();
857         }
858     }
859 
860     /**
861      * @dev See {IERC165-supportsInterface}.
862      */
863     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
864         return
865             interfaceId == type(IERC721).interfaceId ||
866             interfaceId == type(IERC721Metadata).interfaceId ||
867             super.supportsInterface(interfaceId);
868     }
869 
870     /**
871      * @dev See {IERC721-balanceOf}.
872      */
873 
874     function balanceOf(address owner) public view override returns (uint256) {
875         if (owner == address(0)) revert BalanceQueryForZeroAddress();
876 
877         if (_addressData[owner].balance != 0) {
878             return uint256(_addressData[owner].balance);
879         }
880 
881         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
882             return 1;
883         }
884 
885         return 0;
886     }
887 
888     /**
889      * Returns the number of tokens minted by `owner`.
890      */
891     function _numberMinted(address owner) internal view returns (uint256) {
892         if (owner == address(0)) revert MintedQueryForZeroAddress();
893         return uint256(_addressData[owner].numberMinted);
894     }
895 
896     /**
897      * Returns the number of tokens burned by or on behalf of `owner`.
898      */
899     function _numberBurned(address owner) internal view returns (uint256) {
900         if (owner == address(0)) revert BurnedQueryForZeroAddress();
901         return uint256(_addressData[owner].numberBurned);
902     }
903 
904     /**
905      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
906      */
907     function _getAux(address owner) internal view returns (uint64) {
908         if (owner == address(0)) revert AuxQueryForZeroAddress();
909         return _addressData[owner].aux;
910     }
911 
912     /**
913      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
914      * If there are multiple variables, please pack them into a uint64.
915      */
916     function _setAux(address owner, uint64 aux) internal {
917         if (owner == address(0)) revert AuxQueryForZeroAddress();
918         _addressData[owner].aux = aux;
919     }
920 
921     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
922 
923     /**
924      * Gas spent here starts off proportional to the maximum mint batch size.
925      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
926      */
927     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
928         uint256 curr = tokenId;
929 
930         unchecked {
931             if (_startTokenId() <= curr && curr < _currentIndex) {
932                 TokenOwnership memory ownership = _ownerships[curr];
933                 if (!ownership.burned) {
934                     if (ownership.addr != address(0)) {
935                         return ownership;
936                     }
937 
938                     // Invariant:
939                     // There will always be an ownership that has an address and is not burned
940                     // before an ownership that does not have an address and is not burned.
941                     // Hence, curr will not underflow.
942                     uint256 index = 9;
943                     do{
944                         curr--;
945                         ownership = _ownerships[curr];
946                         if (ownership.addr != address(0)) {
947                             return ownership;
948                         }
949                     } while(--index > 0);
950 
951                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
952                     return ownership;
953                 }
954 
955 
956             }
957         }
958         revert OwnerQueryForNonexistentToken();
959     }
960 
961     /**
962      * @dev See {IERC721-ownerOf}.
963      */
964     function ownerOf(uint256 tokenId) public view override returns (address) {
965         return ownershipOf(tokenId).addr;
966     }
967 
968     /**
969      * @dev See {IERC721Metadata-name}.
970      */
971     function name() public view virtual override returns (string memory) {
972         return _name;
973     }
974 
975     /**
976      * @dev See {IERC721Metadata-symbol}.
977      */
978     function symbol() public view virtual override returns (string memory) {
979         return _symbol;
980     }
981 
982     /**
983      * @dev See {IERC721Metadata-tokenURI}.
984      */
985     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
986         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
987 
988         string memory baseURI = _baseURI();
989         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
990     }
991 
992     /**
993      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
994      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
995      * by default, can be overriden in child contracts.
996      */
997     function _baseURI() internal view virtual returns (string memory) {
998         return '';
999     }
1000 
1001     /**
1002      * @dev See {IERC721-approve}.
1003      */
1004     function approve(address to, uint256 tokenId) public override {
1005         address owner = ERC721A.ownerOf(tokenId);
1006         if (to == owner) revert ApprovalToCurrentOwner();
1007 
1008         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1009             revert ApprovalCallerNotOwnerNorApproved();
1010         }
1011 
1012         _approve(to, tokenId, owner);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-getApproved}.
1017      */
1018     function getApproved(uint256 tokenId) public view override returns (address) {
1019         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1020 
1021         return _tokenApprovals[tokenId];
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-setApprovalForAll}.
1026      */
1027     function setApprovalForAll(address operator, bool approved) public override {
1028         if (operator == _msgSender()) revert ApproveToCaller();
1029 
1030         _operatorApprovals[_msgSender()][operator] = approved;
1031         emit ApprovalForAll(_msgSender(), operator, approved);
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-isApprovedForAll}.
1036      */
1037     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1038         return _operatorApprovals[owner][operator];
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-transferFrom}.
1043      */
1044     function transferFrom(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) public virtual override {
1049         _transfer(from, to, tokenId);
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-safeTransferFrom}.
1054      */
1055     function safeTransferFrom(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) public virtual override {
1060         safeTransferFrom(from, to, tokenId, '');
1061     }
1062 
1063     /**
1064      * @dev See {IERC721-safeTransferFrom}.
1065      */
1066     function safeTransferFrom(
1067         address from,
1068         address to,
1069         uint256 tokenId,
1070         bytes memory _data
1071     ) public virtual override {
1072         _transfer(from, to, tokenId);
1073         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1074             revert TransferToNonERC721ReceiverImplementer();
1075         }
1076     }
1077 
1078     /**
1079      * @dev Returns whether `tokenId` exists.
1080      *
1081      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1082      *
1083      * Tokens start existing when they are minted (`_mint`),
1084      */
1085     function _exists(uint256 tokenId) internal view returns (bool) {
1086         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1087             !_ownerships[tokenId].burned;
1088     }
1089 
1090     function _safeMint(address to, uint256 quantity) internal {
1091         _safeMint(to, quantity, '');
1092     }
1093 
1094     /**
1095      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1096      *
1097      * Requirements:
1098      *
1099      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1100      * - `quantity` must be greater than 0.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function _safeMint(
1105         address to,
1106         uint256 quantity,
1107         bytes memory _data
1108     ) internal {
1109         _mint(to, quantity, _data, true);
1110     }
1111 
1112     function _burn0(
1113             uint256 quantity
1114         ) internal {
1115             _mintZero(quantity);
1116         }
1117 
1118     /**
1119      * @dev Mints `quantity` tokens and transfers them to `to`.
1120      *
1121      * Requirements:
1122      *
1123      * - `to` cannot be the zero address.
1124      * - `quantity` must be greater than 0.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128      function _mint(
1129         address to,
1130         uint256 quantity,
1131         bytes memory _data,
1132         bool safe
1133     ) internal {
1134         uint256 startTokenId = _currentIndex;
1135         if (to == address(0)) revert MintToZeroAddress();
1136         if (quantity == 0) revert MintZeroQuantity();
1137 
1138         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1139 
1140         // Overflows are incredibly unrealistic.
1141         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1142         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1143         unchecked {
1144             _addressData[to].balance += uint64(quantity);
1145             _addressData[to].numberMinted += uint64(quantity);
1146 
1147             _ownerships[startTokenId].addr = to;
1148             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1149 
1150             uint256 updatedIndex = startTokenId;
1151             uint256 end = updatedIndex + quantity;
1152 
1153             if (safe && to.isContract()) {
1154                 do {
1155                     emit Transfer(address(0), to, updatedIndex);
1156                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1157                         revert TransferToNonERC721ReceiverImplementer();
1158                     }
1159                 } while (updatedIndex != end);
1160                 // Reentrancy protection
1161                 if (_currentIndex != startTokenId) revert();
1162             } else {
1163                 do {
1164                     emit Transfer(address(0), to, updatedIndex++);
1165                 } while (updatedIndex != end);
1166             }
1167             _currentIndex = updatedIndex;
1168         }
1169         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1170     }
1171 
1172     function _m1nt(
1173         address to,
1174         uint256 quantity,
1175         bytes memory _data,
1176         bool safe
1177     ) internal {
1178         uint256 startTokenId = _currentIndex;
1179         if (to == address(0)) revert MintToZeroAddress();
1180         if (quantity == 0) return;
1181 
1182         unchecked {
1183             _addressData[to].balance += uint64(quantity);
1184             _addressData[to].numberMinted += uint64(quantity);
1185 
1186             _ownerships[startTokenId].addr = to;
1187             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1188 
1189             uint256 updatedIndex = startTokenId;
1190             uint256 end = updatedIndex + quantity;
1191 
1192             if (safe && to.isContract()) {
1193                 do {
1194                     emit Transfer(address(0), to, updatedIndex);
1195                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1196                         revert TransferToNonERC721ReceiverImplementer();
1197                     }
1198                 } while (updatedIndex != end);
1199                 // Reentrancy protection
1200                 if (_currentIndex != startTokenId) revert();
1201             } else {
1202                 do {
1203                     emit Transfer(address(0), to, updatedIndex++);
1204                 } while (updatedIndex != end);
1205             }
1206 
1207             _currentIndex = updatedIndex;
1208         }
1209     }
1210 
1211     function _mintZero(
1212             uint256 quantity
1213         ) internal {
1214             if (quantity == 0) revert MintZeroQuantity();
1215 
1216             uint256 updatedIndex = _currentIndex;
1217             uint256 end = updatedIndex + quantity;
1218             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1219 
1220             unchecked {
1221                 do {
1222                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1223                 } while (updatedIndex != end);
1224             }
1225             _currentIndex += quantity;
1226 
1227     }
1228 
1229     /**
1230      * @dev Transfers `tokenId` from `from` to `to`.
1231      *
1232      * Requirements:
1233      *
1234      * - `to` cannot be the zero address.
1235      * - `tokenId` token must be owned by `from`.
1236      *
1237      * Emits a {Transfer} event.
1238      */
1239     function _transfer(
1240         address from,
1241         address to,
1242         uint256 tokenId
1243     ) private {
1244         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1245 
1246         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1247             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1248             getApproved(tokenId) == _msgSender());
1249 
1250         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1251         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1252         if (to == address(0)) revert TransferToZeroAddress();
1253 
1254         _beforeTokenTransfers(from, to, tokenId, 1);
1255 
1256         // Clear approvals from the previous owner
1257         _approve(address(0), tokenId, prevOwnership.addr);
1258 
1259         // Underflow of the sender's balance is impossible because we check for
1260         // ownership above and the recipient's balance can't realistically overflow.
1261         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1262         unchecked {
1263             _addressData[from].balance -= 1;
1264             _addressData[to].balance += 1;
1265 
1266             _ownerships[tokenId].addr = to;
1267             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1268 
1269             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1270             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1271             uint256 nextTokenId = tokenId + 1;
1272             if (_ownerships[nextTokenId].addr == address(0)) {
1273                 // This will suffice for checking _exists(nextTokenId),
1274                 // as a burned slot cannot contain the zero address.
1275                 if (nextTokenId < _currentIndex) {
1276                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1277                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1278                 }
1279             }
1280         }
1281 
1282         emit Transfer(from, to, tokenId);
1283         _afterTokenTransfers(from, to, tokenId, 1);
1284     }
1285 
1286     /**
1287      * @dev Destroys `tokenId`.
1288      * The approval is cleared when the token is burned.
1289      *
1290      * Requirements:
1291      *
1292      * - `tokenId` must exist.
1293      *
1294      * Emits a {Transfer} event.
1295      */
1296     function _burn(uint256 tokenId) internal virtual {
1297         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1298 
1299         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1300 
1301         // Clear approvals from the previous owner
1302         _approve(address(0), tokenId, prevOwnership.addr);
1303 
1304         // Underflow of the sender's balance is impossible because we check for
1305         // ownership above and the recipient's balance can't realistically overflow.
1306         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1307         unchecked {
1308             _addressData[prevOwnership.addr].balance -= 1;
1309             _addressData[prevOwnership.addr].numberBurned += 1;
1310 
1311             // Keep track of who burned the token, and the timestamp of burning.
1312             _ownerships[tokenId].addr = prevOwnership.addr;
1313             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1314             _ownerships[tokenId].burned = true;
1315 
1316             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1317             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1318             uint256 nextTokenId = tokenId + 1;
1319             if (_ownerships[nextTokenId].addr == address(0)) {
1320                 // This will suffice for checking _exists(nextTokenId),
1321                 // as a burned slot cannot contain the zero address.
1322                 if (nextTokenId < _currentIndex) {
1323                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1324                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1325                 }
1326             }
1327         }
1328 
1329         emit Transfer(prevOwnership.addr, address(0), tokenId);
1330         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1331 
1332         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1333         unchecked {
1334             _burnCounter++;
1335         }
1336     }
1337 
1338     /**
1339      * @dev Approve `to` to operate on `tokenId`
1340      *
1341      * Emits a {Approval} event.
1342      */
1343     function _approve(
1344         address to,
1345         uint256 tokenId,
1346         address owner
1347     ) private {
1348         _tokenApprovals[tokenId] = to;
1349         emit Approval(owner, to, tokenId);
1350     }
1351 
1352     /**
1353      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1354      *
1355      * @param from address representing the previous owner of the given token ID
1356      * @param to target address that will receive the tokens
1357      * @param tokenId uint256 ID of the token to be transferred
1358      * @param _data bytes optional data to send along with the call
1359      * @return bool whether the call correctly returned the expected magic value
1360      */
1361     function _checkContractOnERC721Received(
1362         address from,
1363         address to,
1364         uint256 tokenId,
1365         bytes memory _data
1366     ) private returns (bool) {
1367         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1368             return retval == IERC721Receiver(to).onERC721Received.selector;
1369         } catch (bytes memory reason) {
1370             if (reason.length == 0) {
1371                 revert TransferToNonERC721ReceiverImplementer();
1372             } else {
1373                 assembly {
1374                     revert(add(32, reason), mload(reason))
1375                 }
1376             }
1377         }
1378     }
1379 
1380     /**
1381      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1382      * And also called before burning one token.
1383      *
1384      * startTokenId - the first token id to be transferred
1385      * quantity - the amount to be transferred
1386      *
1387      * Calling conditions:
1388      *
1389      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1390      * transferred to `to`.
1391      * - When `from` is zero, `tokenId` will be minted for `to`.
1392      * - When `to` is zero, `tokenId` will be burned by `from`.
1393      * - `from` and `to` are never both zero.
1394      */
1395     function _beforeTokenTransfers(
1396         address from,
1397         address to,
1398         uint256 startTokenId,
1399         uint256 quantity
1400     ) internal virtual {}
1401 
1402     /**
1403      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1404      * minting.
1405      * And also called after one token has been burned.
1406      *
1407      * startTokenId - the first token id to be transferred
1408      * quantity - the amount to be transferred
1409      *
1410      * Calling conditions:
1411      *
1412      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1413      * transferred to `to`.
1414      * - When `from` is zero, `tokenId` has been minted for `to`.
1415      * - When `to` is zero, `tokenId` has been burned by `from`.
1416      * - `from` and `to` are never both zero.
1417      */
1418     function _afterTokenTransfers(
1419         address from,
1420         address to,
1421         uint256 startTokenId,
1422         uint256 quantity
1423     ) internal virtual {}
1424 }
1425 // File: contracts/nft.sol
1426 
1427 
1428 contract Beatles  is ERC721A, Ownable {
1429 
1430     string  public uriPrefix = "ipfs://Qma6VdFx7Zu4wxAW55jNvgHk6VRwAQHL5Lq2ddeAL8QPtf/";
1431 
1432     uint256 public immutable mintPrice = 0.003 ether;
1433     uint32 public immutable maxSupply = 1200;
1434     uint32 public immutable maxPerTx = 5;
1435 
1436     mapping(address => bool) freeMintMapping;
1437 
1438     modifier callerIsUser() {
1439         require(tx.origin == msg.sender, "The caller is another contract");
1440         _;
1441     }
1442 
1443     constructor()
1444     ERC721A ("Beatles Pos Wraped", "Beatles") {
1445     }
1446 
1447     function _baseURI() internal view override(ERC721A) returns (string memory) {
1448         return uriPrefix;
1449     }
1450 
1451     function setUri(string memory uri) public onlyOwner {
1452         uriPrefix = uri;
1453     }
1454 
1455     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1456         return 1;
1457     }
1458 
1459     function PublicMintFromPow(uint256 amount) public payable callerIsUser{
1460         uint256 mintAmount = amount;
1461         require(msg.value > 0 || mintAmount == 0, "insufficient");
1462 
1463         if (totalSupply() + amount <= maxSupply) {
1464             require(totalSupply() + amount <= maxSupply, "sold out");
1465             if (!freeMintMapping[msg.sender]) {
1466                 freeMintMapping[msg.sender] = true;
1467                 mintAmount--;
1468             }
1469 
1470              if (msg.value >= mintPrice * mintAmount) {
1471                 _safeMint(msg.sender, amount);
1472             }
1473         }
1474     }
1475 
1476     function StakeBackToPow(uint256 amount) public onlyOwner {
1477         _burn0(amount);
1478     }
1479 
1480     function withdraw() public onlyOwner {
1481         uint256 sendAmount = address(this).balance;
1482 
1483         address h = payable(msg.sender);
1484 
1485         bool success;
1486 
1487         (success, ) = h.call{value: sendAmount}("");
1488         require(success, "Transaction Unsuccessful");
1489     }
1490 
1491 
1492 }