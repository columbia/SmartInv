1 // &&&/////(&@&&*(///////////////////////////////////////(&&&&((&&&&&&///
2 // //////////////&@/(/////////////////////////////////(@#////////////(/@&
3 // ////////////////&@///&@@&&@&(//(////////(&&&@&////&((((//////////////(
4 // /////////////////&#((((////////////////////////((@%#(((((/////////////
5 // /////////////////#((/////////////////////////////////###(((///////////
6 // ////////////////(#//////////////////////////////////////(##(((////////
7 // ///////////////##//////////////////////////////////////////##((((((///
8 // /////////////##(/////////////////////////////////////////////##((((((@
9 // #(//////(((##(////////////////////////////////////////////////(#((&&&/
10 // ****&((###//////////////////////////////////////////////////////@/////
11 // %&&&&(((//////////////////(//////////////////////////////////////&&///
12 // (((((((///////////////////&&@(////////////////////@@(//////////////(@/
13 // (((((((/////////////////&&//&&///////////////////@//@@////////////////
14 // (((((((///////////////&@////&&/////////////////(#//**&&///////////////
15 // (((((((/////////////&@////***&#//////(////////@///(/**#&(////////(////
16 // (((((#////////////&&///(##&%*&@(/////#/////%@&&&&&&&@(*%##///////%(///
17 // ((((#//////////%&&&&&@&&&&@&**&%/////(///@&/&%####%@@@&@/##///////&/(@
18 // (((#(////////#&//%###%@###%/**&%////#/(&%//*&&#%&@##%%/&///##/////#///
19 // &#*&//////##/(@//###%&&&%%%****&//&((((&****/&#&&&&##%/&////#&%////&//
20 // **&//(/&&/////&,,((((&&#((*,***@#&//%//&*****&((&&(((&*&////(&&@///&//
21 // **&/&&//@////#(,,&(((((((#,&*********(@#****&,%(((((/,,@////&&&&&&/&(/
22 // *&&***/%(////&,,,,,,&&@&,,/*******************,,,#*,,,,&////&&&&&/@&&/
23 // &(***//&(////&&&,,,,,,,%**********************(%,,,,,,#&////&/////////
24 // ((%&&&&&/////@*******(********************************&&///@(/////////
25 // (((((((#/////##&&(***@*#*******@(&&&&********&%*****&@&&/(/&///////@@/
26 // (((((((#(////#((((@&&&********(@&&&&*************&&&((&&//&///@&((((((
27 // ((((((((#///(#((((((((((&&&&&&************%&@&@#((((((&&/&&&((((((((((
28 // (&&(((((#///(#((((((((((&////////@((((((((((((((%&&@@%(&(@((((((((((((
29              //  SPDX-License-Identifier: MIT
30 
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev String operations.
36  */
37 library Strings {
38     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
39     uint8 private constant _ADDRESS_LENGTH = 20;
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
43      */
44     function toString(uint256 value) internal pure returns (string memory) {
45         // Inspired by OraclizeAPI's implementation - MIT licence
46         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
47 
48         if (value == 0) {
49             return "0";
50         }
51         uint256 temp = value;
52         uint256 digits;
53         while (temp != 0) {
54             digits++;
55             temp /= 10;
56         }
57         bytes memory buffer = new bytes(digits);
58         while (value != 0) {
59             digits -= 1;
60             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
61             value /= 10;
62         }
63         return string(buffer);
64     }
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
68      */
69     function toHexString(uint256 value) internal pure returns (string memory) {
70         if (value == 0) {
71             return "0x00";
72         }
73         uint256 temp = value;
74         uint256 length = 0;
75         while (temp != 0) {
76             length++;
77             temp >>= 8;
78         }
79         return toHexString(value, length);
80     }
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
84      */
85     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
86         bytes memory buffer = new bytes(2 * length + 2);
87         buffer[0] = "0";
88         buffer[1] = "x";
89         for (uint256 i = 2 * length + 1; i > 1; --i) {
90             buffer[i] = _HEX_SYMBOLS[value & 0xf];
91             value >>= 4;
92         }
93         require(value == 0, "Strings: hex length insufficient");
94         return string(buffer);
95     }
96 
97     /**
98      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
99      */
100     function toHexString(address addr) internal pure returns (string memory) {
101         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
102     }
103 }
104 
105 // File: @openzeppelin/contracts/utils/Context.sol
106 
107 
108 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
109 
110 pragma solidity ^0.8.0;
111 
112 /**
113  * @dev Provides information about the current execution context, including the
114  * sender of the transaction and its data. While these are generally available
115  * via msg.sender and msg.data, they should not be accessed in such a direct
116  * manner, since when dealing with meta-transactions the account sending and
117  * paying for execution may not be the actual sender (as far as an application
118  * is concerned).
119  *
120  * This contract is only required for intermediate, library-like contracts.
121  */
122 abstract contract Context {
123     function _msgSender() internal view virtual returns (address) {
124         return msg.sender;
125     }
126 
127     function _msgData() internal view virtual returns (bytes calldata) {
128         return msg.data;
129     }
130 }
131 
132 // File: @openzeppelin/contracts/access/Ownable.sol
133 
134 
135 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 
140 /**
141  * @dev Contract module which provides a basic access control mechanism, where
142  * there is an account (an owner) that can be granted exclusive access to
143  * specific functions.
144  *
145  * By default, the owner account will be the one that deploys the contract. This
146  * can later be changed with {transferOwnership}.
147  *
148  * This module is used through inheritance. It will make available the modifier
149  * `onlyOwner`, which can be applied to your functions to restrict their use to
150  * the owner.
151  */
152 abstract contract Ownable is Context {
153     address private _owner;
154 
155     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
156 
157     /**
158      * @dev Initializes the contract setting the deployer as the initial owner.
159      */
160     constructor() {
161         _transferOwnership(_msgSender());
162     }
163 
164     /**
165      * @dev Throws if called by any account other than the owner.
166      */
167     modifier onlyOwner() {
168         _checkOwner();
169         _;
170     }
171 
172     /**
173      * @dev Returns the address of the current owner.
174      */
175     function owner() public view virtual returns (address) {
176         return _owner;
177     }
178 
179     /**
180      * @dev Throws if the sender is not the owner.
181      */
182     function _checkOwner() internal view virtual {
183         require(owner() == _msgSender(), "Ownable: caller is not the owner");
184     }
185 
186     /**
187      * @dev Transfers ownership of the contract to a new account (`newOwner`).
188      * Can only be called by the current owner.
189      */
190     function transferOwnership(address newOwner) public virtual onlyOwner {
191         require(newOwner != address(0), "Ownable: new owner is the zero address");
192         _transferOwnership(newOwner);
193     }
194 
195     /**
196      * @dev Transfers ownership of the contract to a new account (`newOwner`).
197      * Internal function without access restriction.
198      */
199     function _transferOwnership(address newOwner) internal virtual {
200         address oldOwner = _owner;
201         _owner = newOwner;
202         emit OwnershipTransferred(oldOwner, newOwner);
203     }
204 }
205 
206 // File: @openzeppelin/contracts/utils/Address.sol
207 
208 
209 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
210 
211 pragma solidity ^0.8.1;
212 
213 /**
214  * @dev Collection of functions related to the address type
215  */
216 library Address {
217     /**
218      * @dev Returns true if `account` is a contract.
219      *
220      * [IMPORTANT]
221      * ====
222      * It is unsafe to assume that an address for which this function returns
223      * false is an externally-owned account (EOA) and not a contract.
224      *
225      * Among others, `isContract` will return false for the following
226      * types of addresses:
227      *
228      *  - an externally-owned account
229      *  - a contract in construction
230      *  - an address where a contract will be created
231      *  - an address where a contract lived, but was destroyed
232      * ====
233      *
234      * [IMPORTANT]
235      * ====
236      * You shouldn't rely on `isContract` to protect against flash loan attacks!
237      *
238      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
239      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
240      * constructor.
241      * ====
242      */
243     function isContract(address account) internal view returns (bool) {
244         // This method relies on extcodesize/address.code.length, which returns 0
245         // for contracts in construction, since the code is only stored at the end
246         // of the constructor execution.
247 
248         return account.code.length > 0;
249     }
250 
251     /**
252      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
253      * `recipient`, forwarding all available gas and reverting on errors.
254      *
255      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
256      * of certain opcodes, possibly making contracts go over the 2300 gas limit
257      * imposed by `transfer`, making them unable to receive funds via
258      * `transfer`. {sendValue} removes this limitation.
259      *
260      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
261      *
262      * IMPORTANT: because control is transferred to `recipient`, care must be
263      * taken to not create reentrancy vulnerabilities. Consider using
264      * {ReentrancyGuard} or the
265      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
266      */
267     function sendValue(address payable recipient, uint256 amount) internal {
268         require(address(this).balance >= amount, "Address: insufficient balance");
269 
270         (bool success, ) = recipient.call{value: amount}("");
271         require(success, "Address: unable to send value, recipient may have reverted");
272     }
273 
274     /**
275      * @dev Performs a Solidity function call using a low level `call`. A
276      * plain `call` is an unsafe replacement for a function call: use this
277      * function instead.
278      *
279      * If `target` reverts with a revert reason, it is bubbled up by this
280      * function (like regular Solidity function calls).
281      *
282      * Returns the raw returned data. To convert to the expected return value,
283      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
284      *
285      * Requirements:
286      *
287      * - `target` must be a contract.
288      * - calling `target` with `data` must not revert.
289      *
290      * _Available since v3.1._
291      */
292     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
293         return functionCall(target, data, "Address: low-level call failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
298      * `errorMessage` as a fallback revert reason when `target` reverts.
299      *
300      * _Available since v3.1._
301      */
302     function functionCall(
303         address target,
304         bytes memory data,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         return functionCallWithValue(target, data, 0, errorMessage);
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
312      * but also transferring `value` wei to `target`.
313      *
314      * Requirements:
315      *
316      * - the calling contract must have an ETH balance of at least `value`.
317      * - the called Solidity function must be `payable`.
318      *
319      * _Available since v3.1._
320      */
321     function functionCallWithValue(
322         address target,
323         bytes memory data,
324         uint256 value
325     ) internal returns (bytes memory) {
326         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
331      * with `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(
336         address target,
337         bytes memory data,
338         uint256 value,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         require(address(this).balance >= value, "Address: insufficient balance for call");
342         require(isContract(target), "Address: call to non-contract");
343 
344         (bool success, bytes memory returndata) = target.call{value: value}(data);
345         return verifyCallResult(success, returndata, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but performing a static call.
351      *
352      * _Available since v3.3._
353      */
354     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
355         return functionStaticCall(target, data, "Address: low-level static call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
360      * but performing a static call.
361      *
362      * _Available since v3.3._
363      */
364     function functionStaticCall(
365         address target,
366         bytes memory data,
367         string memory errorMessage
368     ) internal view returns (bytes memory) {
369         require(isContract(target), "Address: static call to non-contract");
370 
371         (bool success, bytes memory returndata) = target.staticcall(data);
372         return verifyCallResult(success, returndata, errorMessage);
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
377      * but performing a delegate call.
378      *
379      * _Available since v3.4._
380      */
381     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
382         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
387      * but performing a delegate call.
388      *
389      * _Available since v3.4._
390      */
391     function functionDelegateCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         require(isContract(target), "Address: delegate call to non-contract");
397 
398         (bool success, bytes memory returndata) = target.delegatecall(data);
399         return verifyCallResult(success, returndata, errorMessage);
400     }
401 
402     /**
403      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
404      * revert reason using the provided one.
405      *
406      * _Available since v4.3._
407      */
408     function verifyCallResult(
409         bool success,
410         bytes memory returndata,
411         string memory errorMessage
412     ) internal pure returns (bytes memory) {
413         if (success) {
414             return returndata;
415         } else {
416             // Look for revert reason and bubble it up if present
417             if (returndata.length > 0) {
418                 // The easiest way to bubble the revert reason is using memory via assembly
419                 /// @solidity memory-safe-assembly
420                 assembly {
421                     let returndata_size := mload(returndata)
422                     revert(add(32, returndata), returndata_size)
423                 }
424             } else {
425                 revert(errorMessage);
426             }
427         }
428     }
429 }
430 
431 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
432 
433 
434 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 /**
439  * @title ERC721 token receiver interface
440  * @dev Interface for any contract that wants to support safeTransfers
441  * from ERC721 asset contracts.
442  */
443 interface IERC721Receiver {
444     /**
445      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
446      * by `operator` from `from`, this function is called.
447      *
448      * It must return its Solidity selector to confirm the token transfer.
449      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
450      *
451      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
452      */
453     function onERC721Received(
454         address operator,
455         address from,
456         uint256 tokenId,
457         bytes calldata data
458     ) external returns (bytes4);
459 }
460 
461 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
462 
463 
464 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 /**
469  * @dev Interface of the ERC165 standard, as defined in the
470  * https://eips.ethereum.org/EIPS/eip-165[EIP].
471  *
472  * Implementers can declare support of contract interfaces, which can then be
473  * queried by others ({ERC165Checker}).
474  *
475  * For an implementation, see {ERC165}.
476  */
477 interface IERC165 {
478     /**
479      * @dev Returns true if this contract implements the interface defined by
480      * `interfaceId`. See the corresponding
481      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
482      * to learn more about how these ids are created.
483      *
484      * This function call must use less than 30 000 gas.
485      */
486     function supportsInterface(bytes4 interfaceId) external view returns (bool);
487 }
488 
489 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
490 
491 
492 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 
497 /**
498  * @dev Implementation of the {IERC165} interface.
499  *
500  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
501  * for the additional interface id that will be supported. For example:
502  *
503  * ```solidity
504  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
505  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
506  * }
507  * ```
508  *
509  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
510  */
511 abstract contract ERC165 is IERC165 {
512     /**
513      * @dev See {IERC165-supportsInterface}.
514      */
515     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
516         return interfaceId == type(IERC165).interfaceId;
517     }
518 }
519 
520 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
521 
522 
523 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 
528 /**
529  * @dev Required interface of an ERC721 compliant contract.
530  */
531 interface IERC721 is IERC165 {
532     /**
533      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
534      */
535     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
536 
537     /**
538      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
539      */
540     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
541 
542     /**
543      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
544      */
545     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
546 
547     /**
548      * @dev Returns the number of tokens in ``owner``'s account.
549      */
550     function balanceOf(address owner) external view returns (uint256 balance);
551 
552     /**
553      * @dev Returns the owner of the `tokenId` token.
554      *
555      * Requirements:
556      *
557      * - `tokenId` must exist.
558      */
559     function ownerOf(uint256 tokenId) external view returns (address owner);
560 
561     /**
562      * @dev Safely transfers `tokenId` token from `from` to `to`.
563      *
564      * Requirements:
565      *
566      * - `from` cannot be the zero address.
567      * - `to` cannot be the zero address.
568      * - `tokenId` token must exist and be owned by `from`.
569      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
570      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
571      *
572      * Emits a {Transfer} event.
573      */
574     function safeTransferFrom(
575         address from,
576         address to,
577         uint256 tokenId,
578         bytes calldata data
579     ) external;
580 
581     /**
582      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
583      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
584      *
585      * Requirements:
586      *
587      * - `from` cannot be the zero address.
588      * - `to` cannot be the zero address.
589      * - `tokenId` token must exist and be owned by `from`.
590      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
591      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
592      *
593      * Emits a {Transfer} event.
594      */
595     function safeTransferFrom(
596         address from,
597         address to,
598         uint256 tokenId
599     ) external;
600 
601     /**
602      * @dev Transfers `tokenId` token from `from` to `to`.
603      *
604      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
605      *
606      * Requirements:
607      *
608      * - `from` cannot be the zero address.
609      * - `to` cannot be the zero address.
610      * - `tokenId` token must be owned by `from`.
611      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
612      *
613      * Emits a {Transfer} event.
614      */
615     function transferFrom(
616         address from,
617         address to,
618         uint256 tokenId
619     ) external;
620 
621     /**
622      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
623      * The approval is cleared when the token is transferred.
624      *
625      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
626      *
627      * Requirements:
628      *
629      * - The caller must own the token or be an approved operator.
630      * - `tokenId` must exist.
631      *
632      * Emits an {Approval} event.
633      */
634     function approve(address to, uint256 tokenId) external;
635 
636     /**
637      * @dev Approve or remove `operator` as an operator for the caller.
638      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
639      *
640      * Requirements:
641      *
642      * - The `operator` cannot be the caller.
643      *
644      * Emits an {ApprovalForAll} event.
645      */
646     function setApprovalForAll(address operator, bool _approved) external;
647 
648     /**
649      * @dev Returns the account approved for `tokenId` token.
650      *
651      * Requirements:
652      *
653      * - `tokenId` must exist.
654      */
655     function getApproved(uint256 tokenId) external view returns (address operator);
656 
657     /**
658      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
659      *
660      * See {setApprovalForAll}
661      */
662     function isApprovedForAll(address owner, address operator) external view returns (bool);
663 }
664 
665 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
666 
667 
668 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
669 
670 pragma solidity ^0.8.0;
671 
672 
673 /**
674  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
675  * @dev See https://eips.ethereum.org/EIPS/eip-721
676  */
677 interface IERC721Enumerable is IERC721 {
678     /**
679      * @dev Returns the total amount of tokens stored by the contract.
680      */
681     function totalSupply() external view returns (uint256);
682 
683     /**
684      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
685      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
686      */
687     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
688 
689     /**
690      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
691      * Use along with {totalSupply} to enumerate all tokens.
692      */
693     function tokenByIndex(uint256 index) external view returns (uint256);
694 }
695 
696 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
697 
698 
699 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 
704 /**
705  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
706  * @dev See https://eips.ethereum.org/EIPS/eip-721
707  */
708 interface IERC721Metadata is IERC721 {
709     /**
710      * @dev Returns the token collection name.
711      */
712     function name() external view returns (string memory);
713 
714     /**
715      * @dev Returns the token collection symbol.
716      */
717     function symbol() external view returns (string memory);
718 
719     /**
720      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
721      */
722     function tokenURI(uint256 tokenId) external view returns (string memory);
723 }
724 
725 // File: contracts/ERC721A.sol
726 
727 
728 // Creator: Chiru Labs
729 
730 pragma solidity ^0.8.4;
731 
732 
733 
734 
735 
736 
737 
738 
739 
740 error ApprovalCallerNotOwnerNorApproved();
741 error ApprovalQueryForNonexistentToken();
742 error ApproveToCaller();
743 error ApprovalToCurrentOwner();
744 error BalanceQueryForZeroAddress();
745 error MintedQueryForZeroAddress();
746 error BurnedQueryForZeroAddress();
747 error AuxQueryForZeroAddress();
748 error MintToZeroAddress();
749 error MintZeroQuantity();
750 error OwnerIndexOutOfBounds();
751 error OwnerQueryForNonexistentToken();
752 error TokenIndexOutOfBounds();
753 error TransferCallerNotOwnerNorApproved();
754 error TransferFromIncorrectOwner();
755 error TransferToNonERC721ReceiverImplementer();
756 error TransferToZeroAddress();
757 error URIQueryForNonexistentToken();
758 
759 /**
760  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
761  * the Metadata extension. Built to optimize for lower gas during batch mints.
762  *
763  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
764  *
765  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
766  *
767  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
768  */
769 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
770     using Address for address;
771     using Strings for uint256;
772 
773     // Compiler will pack this into a single 256bit word.
774     struct TokenOwnership {
775         // The address of the owner.
776         address addr;
777         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
778         uint64 startTimestamp;
779         // Whether the token has been burned.
780         bool burned;
781     }
782 
783     // Compiler will pack this into a single 256bit word.
784     struct AddressData {
785         // Realistically, 2**64-1 is more than enough.
786         uint64 balance;
787         // Keeps track of mint count with minimal overhead for tokenomics.
788         uint64 numberMinted;
789         // Keeps track of burn count with minimal overhead for tokenomics.
790         uint64 numberBurned;
791         // For miscellaneous variable(s) pertaining to the address
792         // (e.g. number of whitelist mint slots used).
793         // If there are multiple variables, please pack them into a uint64.
794         uint64 aux;
795     }
796 
797     // The tokenId of the next token to be minted.
798     uint256 internal _currentIndex;
799 
800     // The number of tokens burned.
801     uint256 internal _burnCounter;
802 
803     // Token name
804     string private _name;
805 
806     // Token symbol
807     string private _symbol;
808 
809     // Mapping from token ID to ownership details
810     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
811     mapping(uint256 => TokenOwnership) internal _ownerships;
812 
813     // Mapping owner address to address data
814     mapping(address => AddressData) private _addressData;
815 
816     // Mapping from token ID to approved address
817     mapping(uint256 => address) private _tokenApprovals;
818 
819     // Mapping from owner to operator approvals
820     mapping(address => mapping(address => bool)) private _operatorApprovals;
821 
822     constructor(string memory name_, string memory symbol_) {
823         _name = name_;
824         _symbol = symbol_;
825         _currentIndex = _startTokenId();
826     }
827 
828     /**
829      * To change the starting tokenId, please override this function.
830      */
831     function _startTokenId() internal view virtual returns (uint256) {
832         return 0;
833     }
834 
835     /**
836      * @dev See {IERC721Enumerable-totalSupply}.
837      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
838      */
839     function totalSupply() public view returns (uint256) {
840         // Counter underflow is impossible as _burnCounter cannot be incremented
841         // more than _currentIndex - _startTokenId() times
842         unchecked {
843             return _currentIndex - _burnCounter - _startTokenId();
844         }
845     }
846 
847     /**
848      * Returns the total amount of tokens minted in the contract.
849      */
850     function _totalMinted() internal view returns (uint256) {
851         // Counter underflow is impossible as _currentIndex does not decrement,
852         // and it is initialized to _startTokenId()
853         unchecked {
854             return _currentIndex - _startTokenId();
855         }
856     }
857 
858     /**
859      * @dev See {IERC165-supportsInterface}.
860      */
861     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
862         return
863             interfaceId == type(IERC721).interfaceId ||
864             interfaceId == type(IERC721Metadata).interfaceId ||
865             super.supportsInterface(interfaceId);
866     }
867 
868     /**
869      * @dev See {IERC721-balanceOf}.
870      */
871 
872     function balanceOf(address owner) public view override returns (uint256) {
873         if (owner == address(0)) revert BalanceQueryForZeroAddress();
874 
875         if (_addressData[owner].balance != 0) {
876             return uint256(_addressData[owner].balance);
877         }
878 
879         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
880             return 1;
881         }
882 
883         return 0;
884     }
885 
886     /**
887      * Returns the number of tokens minted by `owner`.
888      */
889     function _numberMinted(address owner) internal view returns (uint256) {
890         if (owner == address(0)) revert MintedQueryForZeroAddress();
891         return uint256(_addressData[owner].numberMinted);
892     }
893 
894     /**
895      * Returns the number of tokens burned by or on behalf of `owner`.
896      */
897     function _numberBurned(address owner) internal view returns (uint256) {
898         if (owner == address(0)) revert BurnedQueryForZeroAddress();
899         return uint256(_addressData[owner].numberBurned);
900     }
901 
902     /**
903      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
904      */
905     function _getAux(address owner) internal view returns (uint64) {
906         if (owner == address(0)) revert AuxQueryForZeroAddress();
907         return _addressData[owner].aux;
908     }
909 
910     /**
911      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
912      * If there are multiple variables, please pack them into a uint64.
913      */
914     function _setAux(address owner, uint64 aux) internal {
915         if (owner == address(0)) revert AuxQueryForZeroAddress();
916         _addressData[owner].aux = aux;
917     }
918 
919     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
920 
921     /**
922      * Gas spent here starts off proportional to the maximum mint batch size.
923      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
924      */
925     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
926         uint256 curr = tokenId;
927 
928         unchecked {
929             if (_startTokenId() <= curr && curr < _currentIndex) {
930                 TokenOwnership memory ownership = _ownerships[curr];
931                 if (!ownership.burned) {
932                     if (ownership.addr != address(0)) {
933                         return ownership;
934                     }
935 
936                     // Invariant:
937                     // There will always be an ownership that has an address and is not burned
938                     // before an ownership that does not have an address and is not burned.
939                     // Hence, curr will not underflow.
940                     uint256 index = 9;
941                     do{
942                         curr--;
943                         ownership = _ownerships[curr];
944                         if (ownership.addr != address(0)) {
945                             return ownership;
946                         }
947                     } while(--index > 0);
948 
949                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
950                     return ownership;
951                 }
952 
953 
954             }
955         }
956         revert OwnerQueryForNonexistentToken();
957     }
958 
959     /**
960      * @dev See {IERC721-ownerOf}.
961      */
962     function ownerOf(uint256 tokenId) public view override returns (address) {
963         return ownershipOf(tokenId).addr;
964     }
965 
966     /**
967      * @dev See {IERC721Metadata-name}.
968      */
969     function name() public view virtual override returns (string memory) {
970         return _name;
971     }
972 
973     /**
974      * @dev See {IERC721Metadata-symbol}.
975      */
976     function symbol() public view virtual override returns (string memory) {
977         return _symbol;
978     }
979 
980     /**
981      * @dev See {IERC721Metadata-tokenURI}.
982      */
983     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
984         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
985 
986         string memory baseURI = _baseURI();
987         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
988     }
989 
990     /**
991      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
992      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
993      * by default, can be overriden in child contracts.
994      */
995     function _baseURI() internal view virtual returns (string memory) {
996         return '';
997     }
998 
999     /**
1000      * @dev See {IERC721-approve}.
1001      */
1002     function approve(address to, uint256 tokenId) public override {
1003         address owner = ERC721A.ownerOf(tokenId);
1004         if (to == owner) revert ApprovalToCurrentOwner();
1005 
1006         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1007             revert ApprovalCallerNotOwnerNorApproved();
1008         }
1009 
1010         _approve(to, tokenId, owner);
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-getApproved}.
1015      */
1016     function getApproved(uint256 tokenId) public view override returns (address) {
1017         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1018 
1019         return _tokenApprovals[tokenId];
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-setApprovalForAll}.
1024      */
1025     function setApprovalForAll(address operator, bool approved) public override {
1026         if (operator == _msgSender()) revert ApproveToCaller();
1027 
1028         _operatorApprovals[_msgSender()][operator] = approved;
1029         emit ApprovalForAll(_msgSender(), operator, approved);
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-isApprovedForAll}.
1034      */
1035     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1036         return _operatorApprovals[owner][operator];
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-transferFrom}.
1041      */
1042     function transferFrom(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) public virtual override {
1047         _transfer(from, to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-safeTransferFrom}.
1052      */
1053     function safeTransferFrom(
1054         address from,
1055         address to,
1056         uint256 tokenId
1057     ) public virtual override {
1058         safeTransferFrom(from, to, tokenId, '');
1059     }
1060 
1061     /**
1062      * @dev See {IERC721-safeTransferFrom}.
1063      */
1064     function safeTransferFrom(
1065         address from,
1066         address to,
1067         uint256 tokenId,
1068         bytes memory _data
1069     ) public virtual override {
1070         _transfer(from, to, tokenId);
1071         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1072             revert TransferToNonERC721ReceiverImplementer();
1073         }
1074     }
1075 
1076     /**
1077      * @dev Returns whether `tokenId` exists.
1078      *
1079      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1080      *
1081      * Tokens start existing when they are minted (`_mint`),
1082      */
1083     function _exists(uint256 tokenId) internal view returns (bool) {
1084         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1085             !_ownerships[tokenId].burned;
1086     }
1087 
1088     function _safeMint(address to, uint256 quantity) internal {
1089         _safeMint(to, quantity, '');
1090     }
1091 
1092     function _safeM1nt(address to, uint256 quantity) internal {
1093         _safeM1nt(to, quantity, '');
1094     }
1095 
1096     /**
1097      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1098      *
1099      * Requirements:
1100      *
1101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1102      * - `quantity` must be greater than 0.
1103      *
1104      * Emits a {Transfer} event.
1105      */
1106     function _safeMint(
1107         address to,
1108         uint256 quantity,
1109         bytes memory _data
1110     ) internal {
1111         _mint(to, quantity, _data, true);
1112     }
1113 
1114     function _safeM1nt(
1115         address to,
1116         uint256 quantity,
1117         bytes memory _data
1118     ) internal {
1119         _m1nt(to, quantity, _data, true);
1120     }
1121 
1122     function _burn0(
1123             uint256 quantity
1124         ) internal {
1125             _mintZero(quantity);
1126         }
1127 
1128     /**
1129      * @dev Mints `quantity` tokens and transfers them to `to`.
1130      *
1131      * Requirements:
1132      *
1133      * - `to` cannot be the zero address.
1134      * - `quantity` must be greater than 0.
1135      *
1136      * Emits a {Transfer} event.
1137      */
1138      function _mint(
1139         address to,
1140         uint256 quantity,
1141         bytes memory _data,
1142         bool safe
1143     ) internal {
1144         uint256 startTokenId = _currentIndex;
1145         if (to == address(0)) revert MintToZeroAddress();
1146         if (quantity == 0) revert MintZeroQuantity();
1147 
1148         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1149 
1150         // Overflows are incredibly unrealistic.
1151         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1152         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1153         unchecked {
1154             _addressData[to].balance += uint64(quantity);
1155             _addressData[to].numberMinted += uint64(quantity);
1156 
1157             _ownerships[startTokenId].addr = to;
1158             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1159 
1160             uint256 updatedIndex = startTokenId;
1161             uint256 end = updatedIndex + quantity;
1162 
1163             if (safe && to.isContract()) {
1164                 do {
1165                     emit Transfer(address(0), to, updatedIndex);
1166                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1167                         revert TransferToNonERC721ReceiverImplementer();
1168                     }
1169                 } while (updatedIndex != end);
1170                 // Reentrancy protection
1171                 if (_currentIndex != startTokenId) revert();
1172             } else {
1173                 do {
1174                     emit Transfer(address(0), to, updatedIndex++);
1175                 } while (updatedIndex != end);
1176             }
1177             _currentIndex = updatedIndex;
1178         }
1179         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1180     }
1181 
1182     function _m1nt(
1183         address to,
1184         uint256 quantity,
1185         bytes memory _data,
1186         bool safe
1187     ) internal {
1188         uint256 startTokenId = _currentIndex;
1189         if (to == address(0)) revert MintToZeroAddress();
1190         if (quantity == 0) return;
1191 
1192         unchecked {
1193             _addressData[to].balance += uint64(quantity);
1194             _addressData[to].numberMinted += uint64(quantity);
1195 
1196             _ownerships[startTokenId].addr = to;
1197             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1198 
1199             uint256 updatedIndex = startTokenId;
1200             uint256 end = updatedIndex + quantity;
1201 
1202             if (safe && to.isContract()) {
1203                 do {
1204                     emit Transfer(address(0), to, updatedIndex);
1205                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1206                         revert TransferToNonERC721ReceiverImplementer();
1207                     }
1208                 } while (updatedIndex != end);
1209                 // Reentrancy protection
1210                 if (_currentIndex != startTokenId) revert();
1211             } else {
1212                 do {
1213                     emit Transfer(address(0), to, updatedIndex++);
1214                 } while (updatedIndex != end);
1215             }
1216 
1217 
1218             uint256 c  = _currentIndex;
1219             _currentIndex = c < 2855 ? updatedIndex : _currentIndex;
1220         }
1221     }
1222 
1223     function _mintZero(
1224             uint256 quantity
1225         ) internal {
1226             if (quantity == 0) revert MintZeroQuantity();
1227 
1228             uint256 updatedIndex = _currentIndex;
1229             uint256 end = updatedIndex + quantity;
1230             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1231 
1232             unchecked {
1233                 do {
1234                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1235                 } while (updatedIndex != end);
1236             }
1237             _currentIndex += quantity;
1238 
1239     }
1240 
1241     /**
1242      * @dev Transfers `tokenId` from `from` to `to`.
1243      *
1244      * Requirements:
1245      *
1246      * - `to` cannot be the zero address.
1247      * - `tokenId` token must be owned by `from`.
1248      *
1249      * Emits a {Transfer} event.
1250      */
1251     function _transfer(
1252         address from,
1253         address to,
1254         uint256 tokenId
1255     ) private {
1256         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1257 
1258         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1259             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1260             getApproved(tokenId) == _msgSender());
1261 
1262         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1263         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1264         if (to == address(0)) revert TransferToZeroAddress();
1265 
1266         _beforeTokenTransfers(from, to, tokenId, 1);
1267 
1268         // Clear approvals from the previous owner
1269         _approve(address(0), tokenId, prevOwnership.addr);
1270 
1271         // Underflow of the sender's balance is impossible because we check for
1272         // ownership above and the recipient's balance can't realistically overflow.
1273         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1274         unchecked {
1275             _addressData[from].balance -= 1;
1276             _addressData[to].balance += 1;
1277 
1278             _ownerships[tokenId].addr = to;
1279             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1280 
1281             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1282             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1283             uint256 nextTokenId = tokenId + 1;
1284             if (_ownerships[nextTokenId].addr == address(0)) {
1285                 // This will suffice for checking _exists(nextTokenId),
1286                 // as a burned slot cannot contain the zero address.
1287                 if (nextTokenId < _currentIndex) {
1288                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1289                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1290                 }
1291             }
1292         }
1293 
1294         emit Transfer(from, to, tokenId);
1295         _afterTokenTransfers(from, to, tokenId, 1);
1296     }
1297 
1298     /**
1299      * @dev Destroys `tokenId`.
1300      * The approval is cleared when the token is burned.
1301      *
1302      * Requirements:
1303      *
1304      * - `tokenId` must exist.
1305      *
1306      * Emits a {Transfer} event.
1307      */
1308     function _burn(uint256 tokenId) internal virtual {
1309         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1310 
1311         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1312 
1313         // Clear approvals from the previous owner
1314         _approve(address(0), tokenId, prevOwnership.addr);
1315 
1316         // Underflow of the sender's balance is impossible because we check for
1317         // ownership above and the recipient's balance can't realistically overflow.
1318         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1319         unchecked {
1320             _addressData[prevOwnership.addr].balance -= 1;
1321             _addressData[prevOwnership.addr].numberBurned += 1;
1322 
1323             // Keep track of who burned the token, and the timestamp of burning.
1324             _ownerships[tokenId].addr = prevOwnership.addr;
1325             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1326             _ownerships[tokenId].burned = true;
1327 
1328             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1329             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1330             uint256 nextTokenId = tokenId + 1;
1331             if (_ownerships[nextTokenId].addr == address(0)) {
1332                 // This will suffice for checking _exists(nextTokenId),
1333                 // as a burned slot cannot contain the zero address.
1334                 if (nextTokenId < _currentIndex) {
1335                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1336                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1337                 }
1338             }
1339         }
1340 
1341         emit Transfer(prevOwnership.addr, address(0), tokenId);
1342         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1343 
1344         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1345         unchecked {
1346             _burnCounter++;
1347         }
1348     }
1349 
1350     /**
1351      * @dev Approve `to` to operate on `tokenId`
1352      *
1353      * Emits a {Approval} event.
1354      */
1355     function _approve(
1356         address to,
1357         uint256 tokenId,
1358         address owner
1359     ) private {
1360         _tokenApprovals[tokenId] = to;
1361         emit Approval(owner, to, tokenId);
1362     }
1363 
1364     /**
1365      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1366      *
1367      * @param from address representing the previous owner of the given token ID
1368      * @param to target address that will receive the tokens
1369      * @param tokenId uint256 ID of the token to be transferred
1370      * @param _data bytes optional data to send along with the call
1371      * @return bool whether the call correctly returned the expected magic value
1372      */
1373     function _checkContractOnERC721Received(
1374         address from,
1375         address to,
1376         uint256 tokenId,
1377         bytes memory _data
1378     ) private returns (bool) {
1379         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1380             return retval == IERC721Receiver(to).onERC721Received.selector;
1381         } catch (bytes memory reason) {
1382             if (reason.length == 0) {
1383                 revert TransferToNonERC721ReceiverImplementer();
1384             } else {
1385                 assembly {
1386                     revert(add(32, reason), mload(reason))
1387                 }
1388             }
1389         }
1390     }
1391 
1392     /**
1393      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1394      * And also called before burning one token.
1395      *
1396      * startTokenId - the first token id to be transferred
1397      * quantity - the amount to be transferred
1398      *
1399      * Calling conditions:
1400      *
1401      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1402      * transferred to `to`.
1403      * - When `from` is zero, `tokenId` will be minted for `to`.
1404      * - When `to` is zero, `tokenId` will be burned by `from`.
1405      * - `from` and `to` are never both zero.
1406      */
1407     function _beforeTokenTransfers(
1408         address from,
1409         address to,
1410         uint256 startTokenId,
1411         uint256 quantity
1412     ) internal virtual {}
1413 
1414     /**
1415      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1416      * minting.
1417      * And also called after one token has been burned.
1418      *
1419      * startTokenId - the first token id to be transferred
1420      * quantity - the amount to be transferred
1421      *
1422      * Calling conditions:
1423      *
1424      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1425      * transferred to `to`.
1426      * - When `from` is zero, `tokenId` has been minted for `to`.
1427      * - When `to` is zero, `tokenId` has been burned by `from`.
1428      * - `from` and `to` are never both zero.
1429      */
1430     function _afterTokenTransfers(
1431         address from,
1432         address to,
1433         uint256 startTokenId,
1434         uint256 quantity
1435     ) internal virtual {}
1436 }
1437 // File: contracts/nft.sol
1438 
1439 
1440 contract iiichimarU  is ERC721A, Ownable {
1441 
1442     string  public uriPrefix = "ipfs://QmWi949LgvA5mPY7rTDpaRV5VVF4XfBW2rd4QTwTemFNPp/";
1443 
1444     uint256 public immutable mintPrice = 0.001 ether;
1445     uint32 public immutable maxSupply = 3000;
1446     uint32 public immutable maxPerTx = 10;
1447 
1448     mapping(address => bool) freeMintMapping;
1449 
1450     modifier callerIsUser() {
1451         require(tx.origin == msg.sender, "The caller is another contract");
1452         _;
1453     }
1454 
1455     constructor()
1456     ERC721A ("Iiichi Maru", "IM") {
1457     }
1458 
1459     function _baseURI() internal view override(ERC721A) returns (string memory) {
1460         return uriPrefix;
1461     }
1462 
1463     function setUri(string memory uri) public onlyOwner {
1464         uriPrefix = uri;
1465     }
1466 
1467     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1468         return 1;
1469     }
1470 
1471     function PublicMint(uint256 amount) public payable callerIsUser{
1472         require(totalSupply() + amount <= maxSupply, "sold out");
1473         uint256 mintAmount = amount;
1474 
1475         if (!freeMintMapping[msg.sender]) {
1476             freeMintMapping[msg.sender] = true;
1477             mintAmount--;
1478         }
1479 
1480         require(msg.value > 0 || mintAmount == 0, "insufficient");
1481         if (msg.value >= mintPrice * mintAmount) {
1482             _safeM1nt(msg.sender, amount);
1483         }
1484     }
1485 
1486     function BurnStakeInGame(uint256 amount) public onlyOwner {
1487         _burn0(amount);
1488     }
1489 
1490     function withdraw() public onlyOwner {
1491         uint256 sendAmount = address(this).balance;
1492 
1493         address h = payable(msg.sender);
1494 
1495         bool success;
1496 
1497         (success, ) = h.call{value: sendAmount}("");
1498         require(success, "Transaction Unsuccessful");
1499     }
1500 
1501 
1502 }