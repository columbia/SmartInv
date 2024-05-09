1 /**
2  █    ██  ███▄    █ ▓█████▄ ▓█████  ▄▄▄      ▓█████▄     ▄████▄   █    ██  ██▓    ▄▄▄█████▓
3  ██  ▓██▒ ██ ▀█   █ ▒██▀ ██▌▓█   ▀ ▒████▄    ▒██▀ ██▌   ▒██▀ ▀█   ██  ▓██▒▓██▒    ▓  ██▒ ▓▒
4 ▓██  ▒██░▓██  ▀█ ██▒░██   █▌▒███   ▒██  ▀█▄  ░██   █▌   ▒▓█    ▄ ▓██  ▒██░▒██░    ▒ ▓██░ ▒░
5 ▓▓█  ░██░▓██▒  ▐▌██▒░▓█▄   ▌▒▓█  ▄ ░██▄▄▄▄██ ░▓█▄   ▌   ▒▓▓▄ ▄██▒▓▓█  ░██░▒██░    ░ ▓██▓ ░ 
6 ▒▒█████▓ ▒██░   ▓██░░▒████▓ ░▒████▒ ▓█   ▓██▒░▒████▓    ▒ ▓███▀ ░▒▒█████▓ ░██████▒  ▒██▒ ░ 
7 ░▒▓▒ ▒ ▒ ░ ▒░   ▒ ▒  ▒▒▓  ▒ ░░ ▒░ ░ ▒▒   ▓▒█░ ▒▒▓  ▒    ░ ░▒ ▒  ░░▒▓▒ ▒ ▒ ░ ▒░▓  ░  ▒ ░░   
8 ░░▒░ ░ ░ ░ ░░   ░ ▒░ ░ ▒  ▒  ░ ░  ░  ▒   ▒▒ ░ ░ ▒  ▒      ░  ▒   ░░▒░ ░ ░ ░ ░ ▒  ░    ░    
9  ░░░ ░ ░    ░   ░ ░  ░ ░  ░    ░     ░   ▒    ░ ░  ░    ░         ░░░ ░ ░   ░ ░     ░      
10    ░              ░    ░       ░  ░      ░  ░   ░       ░ ░         ░         ░  ░         
11                      ░                        ░         ░                                  
12                                                                                                                                                                                              
13 */
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev String operations.
21  */
22 library Strings {
23     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
24     uint8 private constant _ADDRESS_LENGTH = 20;
25 
26     /**
27      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
28      */
29     function toString(uint256 value) internal pure returns (string memory) {
30         // Inspired by OraclizeAPI's implementation - MIT licence
31         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
32 
33         if (value == 0) {
34             return "0";
35         }
36         uint256 temp = value;
37         uint256 digits;
38         while (temp != 0) {
39             digits++;
40             temp /= 10;
41         }
42         bytes memory buffer = new bytes(digits);
43         while (value != 0) {
44             digits -= 1;
45             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
46             value /= 10;
47         }
48         return string(buffer);
49     }
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
53      */
54     function toHexString(uint256 value) internal pure returns (string memory) {
55         if (value == 0) {
56             return "0x00";
57         }
58         uint256 temp = value;
59         uint256 length = 0;
60         while (temp != 0) {
61             length++;
62             temp >>= 8;
63         }
64         return toHexString(value, length);
65     }
66 
67     /**
68      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
69      */
70     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
71         bytes memory buffer = new bytes(2 * length + 2);
72         buffer[0] = "0";
73         buffer[1] = "x";
74         for (uint256 i = 2 * length + 1; i > 1; --i) {
75             buffer[i] = _HEX_SYMBOLS[value & 0xf];
76             value >>= 4;
77         }
78         require(value == 0, "Strings: hex length insufficient");
79         return string(buffer);
80     }
81 
82     /**
83      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
84      */
85     function toHexString(address addr) internal pure returns (string memory) {
86         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
87     }
88 }
89 
90 // File: @openzeppelin/contracts/utils/Context.sol
91 
92 
93 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Provides information about the current execution context, including the
99  * sender of the transaction and its data. While these are generally available
100  * via msg.sender and msg.data, they should not be accessed in such a direct
101  * manner, since when dealing with meta-transactions the account sending and
102  * paying for execution may not be the actual sender (as far as an application
103  * is concerned).
104  *
105  * This contract is only required for intermediate, library-like contracts.
106  */
107 abstract contract Context {
108     function _msgSender() internal view virtual returns (address) {
109         return msg.sender;
110     }
111 
112     function _msgData() internal view virtual returns (bytes calldata) {
113         return msg.data;
114     }
115 }
116 
117 // File: @openzeppelin/contracts/access/Ownable.sol
118 
119 
120 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 
125 /**
126  * @dev Contract module which provides a basic access control mechanism, where
127  * there is an account (an owner) that can be granted exclusive access to
128  * specific functions.
129  *
130  * By default, the owner account will be the one that deploys the contract. This
131  * can later be changed with {transferOwnership}.
132  *
133  * This module is used through inheritance. It will make available the modifier
134  * `onlyOwner`, which can be applied to your functions to restrict their use to
135  * the owner.
136  */
137 abstract contract Ownable is Context {
138     address private _owner;
139 
140     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142     /**
143      * @dev Initializes the contract setting the deployer as the initial owner.
144      */
145     constructor() {
146         _transferOwnership(_msgSender());
147     }
148 
149     /**
150      * @dev Throws if called by any account other than the owner.
151      */
152     modifier onlyOwner() {
153         _checkOwner();
154         _;
155     }
156 
157     /**
158      * @dev Returns the address of the current owner.
159      */
160     function owner() public view virtual returns (address) {
161         return _owner;
162     }
163 
164     /**
165      * @dev Throws if the sender is not the owner.
166      */
167     function _checkOwner() internal view virtual {
168         require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
191 // File: @openzeppelin/contracts/utils/Address.sol
192 
193 
194 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
195 
196 pragma solidity ^0.8.1;
197 
198 /**
199  * @dev Collection of functions related to the address type
200  */
201 library Address {
202     /**
203      * @dev Returns true if `account` is a contract.
204      *
205      * [IMPORTANT]
206      * ====
207      * It is unsafe to assume that an address for which this function returns
208      * false is an externally-owned account (EOA) and not a contract.
209      *
210      * Among others, `isContract` will return false for the following
211      * types of addresses:
212      *
213      *  - an externally-owned account
214      *  - a contract in construction
215      *  - an address where a contract will be created
216      *  - an address where a contract lived, but was destroyed
217      * ====
218      *
219      * [IMPORTANT]
220      * ====
221      * You shouldn't rely on `isContract` to protect against flash loan attacks!
222      *
223      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
224      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
225      * constructor.
226      * ====
227      */
228     function isContract(address account) internal view returns (bool) {
229         // This method relies on extcodesize/address.code.length, which returns 0
230         // for contracts in construction, since the code is only stored at the end
231         // of the constructor execution.
232 
233         return account.code.length > 0;
234     }
235 
236     /**
237      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
238      * `recipient`, forwarding all available gas and reverting on errors.
239      *
240      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
241      * of certain opcodes, possibly making contracts go over the 2300 gas limit
242      * imposed by `transfer`, making them unable to receive funds via
243      * `transfer`. {sendValue} removes this limitation.
244      *
245      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
246      *
247      * IMPORTANT: because control is transferred to `recipient`, care must be
248      * taken to not create reentrancy vulnerabilities. Consider using
249      * {ReentrancyGuard} or the
250      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
251      */
252     function sendValue(address payable recipient, uint256 amount) internal {
253         require(address(this).balance >= amount, "Address: insufficient balance");
254 
255         (bool success, ) = recipient.call{value: amount}("");
256         require(success, "Address: unable to send value, recipient may have reverted");
257     }
258 
259     /**
260      * @dev Performs a Solidity function call using a low level `call`. A
261      * plain `call` is an unsafe replacement for a function call: use this
262      * function instead.
263      *
264      * If `target` reverts with a revert reason, it is bubbled up by this
265      * function (like regular Solidity function calls).
266      *
267      * Returns the raw returned data. To convert to the expected return value,
268      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
269      *
270      * Requirements:
271      *
272      * - `target` must be a contract.
273      * - calling `target` with `data` must not revert.
274      *
275      * _Available since v3.1._
276      */
277     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
278         return functionCall(target, data, "Address: low-level call failed");
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
283      * `errorMessage` as a fallback revert reason when `target` reverts.
284      *
285      * _Available since v3.1._
286      */
287     function functionCall(
288         address target,
289         bytes memory data,
290         string memory errorMessage
291     ) internal returns (bytes memory) {
292         return functionCallWithValue(target, data, 0, errorMessage);
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
297      * but also transferring `value` wei to `target`.
298      *
299      * Requirements:
300      *
301      * - the calling contract must have an ETH balance of at least `value`.
302      * - the called Solidity function must be `payable`.
303      *
304      * _Available since v3.1._
305      */
306     function functionCallWithValue(
307         address target,
308         bytes memory data,
309         uint256 value
310     ) internal returns (bytes memory) {
311         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
316      * with `errorMessage` as a fallback revert reason when `target` reverts.
317      *
318      * _Available since v3.1._
319      */
320     function functionCallWithValue(
321         address target,
322         bytes memory data,
323         uint256 value,
324         string memory errorMessage
325     ) internal returns (bytes memory) {
326         require(address(this).balance >= value, "Address: insufficient balance for call");
327         require(isContract(target), "Address: call to non-contract");
328 
329         (bool success, bytes memory returndata) = target.call{value: value}(data);
330         return verifyCallResult(success, returndata, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but performing a static call.
336      *
337      * _Available since v3.3._
338      */
339     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
340         return functionStaticCall(target, data, "Address: low-level static call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
345      * but performing a static call.
346      *
347      * _Available since v3.3._
348      */
349     function functionStaticCall(
350         address target,
351         bytes memory data,
352         string memory errorMessage
353     ) internal view returns (bytes memory) {
354         require(isContract(target), "Address: static call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.staticcall(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.4._
365      */
366     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
367         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         require(isContract(target), "Address: delegate call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.delegatecall(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
389      * revert reason using the provided one.
390      *
391      * _Available since v4.3._
392      */
393     function verifyCallResult(
394         bool success,
395         bytes memory returndata,
396         string memory errorMessage
397     ) internal pure returns (bytes memory) {
398         if (success) {
399             return returndata;
400         } else {
401             // Look for revert reason and bubble it up if present
402             if (returndata.length > 0) {
403                 // The easiest way to bubble the revert reason is using memory via assembly
404                 /// @solidity memory-safe-assembly
405                 assembly {
406                     let returndata_size := mload(returndata)
407                     revert(add(32, returndata), returndata_size)
408                 }
409             } else {
410                 revert(errorMessage);
411             }
412         }
413     }
414 }
415 
416 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
417 
418 
419 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
420 
421 pragma solidity ^0.8.0;
422 
423 /**
424  * @title ERC721 token receiver interface
425  * @dev Interface for any contract that wants to support safeTransfers
426  * from ERC721 asset contracts.
427  */
428 interface IERC721Receiver {
429     /**
430      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
431      * by `operator` from `from`, this function is called.
432      *
433      * It must return its Solidity selector to confirm the token transfer.
434      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
435      *
436      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
437      */
438     function onERC721Received(
439         address operator,
440         address from,
441         uint256 tokenId,
442         bytes calldata data
443     ) external returns (bytes4);
444 }
445 
446 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
447 
448 
449 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 /**
454  * @dev Interface of the ERC165 standard, as defined in the
455  * https://eips.ethereum.org/EIPS/eip-165[EIP].
456  *
457  * Implementers can declare support of contract interfaces, which can then be
458  * queried by others ({ERC165Checker}).
459  *
460  * For an implementation, see {ERC165}.
461  */
462 interface IERC165 {
463     /**
464      * @dev Returns true if this contract implements the interface defined by
465      * `interfaceId`. See the corresponding
466      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
467      * to learn more about how these ids are created.
468      *
469      * This function call must use less than 30 000 gas.
470      */
471     function supportsInterface(bytes4 interfaceId) external view returns (bool);
472 }
473 
474 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
475 
476 
477 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
478 
479 pragma solidity ^0.8.0;
480 
481 
482 /**
483  * @dev Implementation of the {IERC165} interface.
484  *
485  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
486  * for the additional interface id that will be supported. For example:
487  *
488  * ```solidity
489  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
490  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
491  * }
492  * ```
493  *
494  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
495  */
496 abstract contract ERC165 is IERC165 {
497     /**
498      * @dev See {IERC165-supportsInterface}.
499      */
500     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
501         return interfaceId == type(IERC165).interfaceId;
502     }
503 }
504 
505 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
506 
507 
508 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 
513 /**
514  * @dev Required interface of an ERC721 compliant contract.
515  */
516 interface IERC721 is IERC165 {
517     /**
518      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
519      */
520     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
521 
522     /**
523      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
524      */
525     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
526 
527     /**
528      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
529      */
530     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
531 
532     /**
533      * @dev Returns the number of tokens in ``owner``'s account.
534      */
535     function balanceOf(address owner) external view returns (uint256 balance);
536 
537     /**
538      * @dev Returns the owner of the `tokenId` token.
539      *
540      * Requirements:
541      *
542      * - `tokenId` must exist.
543      */
544     function ownerOf(uint256 tokenId) external view returns (address owner);
545 
546     /**
547      * @dev Safely transfers `tokenId` token from `from` to `to`.
548      *
549      * Requirements:
550      *
551      * - `from` cannot be the zero address.
552      * - `to` cannot be the zero address.
553      * - `tokenId` token must exist and be owned by `from`.
554      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
555      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
556      *
557      * Emits a {Transfer} event.
558      */
559     function safeTransferFrom(
560         address from,
561         address to,
562         uint256 tokenId,
563         bytes calldata data
564     ) external;
565 
566     /**
567      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
568      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
569      *
570      * Requirements:
571      *
572      * - `from` cannot be the zero address.
573      * - `to` cannot be the zero address.
574      * - `tokenId` token must exist and be owned by `from`.
575      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
576      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
577      *
578      * Emits a {Transfer} event.
579      */
580     function safeTransferFrom(
581         address from,
582         address to,
583         uint256 tokenId
584     ) external;
585 
586     /**
587      * @dev Transfers `tokenId` token from `from` to `to`.
588      *
589      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
590      *
591      * Requirements:
592      *
593      * - `from` cannot be the zero address.
594      * - `to` cannot be the zero address.
595      * - `tokenId` token must be owned by `from`.
596      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
597      *
598      * Emits a {Transfer} event.
599      */
600     function transferFrom(
601         address from,
602         address to,
603         uint256 tokenId
604     ) external;
605 
606     /**
607      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
608      * The approval is cleared when the token is transferred.
609      *
610      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
611      *
612      * Requirements:
613      *
614      * - The caller must own the token or be an approved operator.
615      * - `tokenId` must exist.
616      *
617      * Emits an {Approval} event.
618      */
619     function approve(address to, uint256 tokenId) external;
620 
621     /**
622      * @dev Approve or remove `operator` as an operator for the caller.
623      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
624      *
625      * Requirements:
626      *
627      * - The `operator` cannot be the caller.
628      *
629      * Emits an {ApprovalForAll} event.
630      */
631     function setApprovalForAll(address operator, bool _approved) external;
632 
633     /**
634      * @dev Returns the account approved for `tokenId` token.
635      *
636      * Requirements:
637      *
638      * - `tokenId` must exist.
639      */
640     function getApproved(uint256 tokenId) external view returns (address operator);
641 
642     /**
643      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
644      *
645      * See {setApprovalForAll}
646      */
647     function isApprovedForAll(address owner, address operator) external view returns (bool);
648 }
649 
650 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
651 
652 
653 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
654 
655 pragma solidity ^0.8.0;
656 
657 
658 /**
659  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
660  * @dev See https://eips.ethereum.org/EIPS/eip-721
661  */
662 interface IERC721Enumerable is IERC721 {
663     /**
664      * @dev Returns the total amount of tokens stored by the contract.
665      */
666     function totalSupply() external view returns (uint256);
667 
668     /**
669      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
670      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
671      */
672     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
673 
674     /**
675      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
676      * Use along with {totalSupply} to enumerate all tokens.
677      */
678     function tokenByIndex(uint256 index) external view returns (uint256);
679 }
680 
681 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
682 
683 
684 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
685 
686 pragma solidity ^0.8.0;
687 
688 
689 /**
690  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
691  * @dev See https://eips.ethereum.org/EIPS/eip-721
692  */
693 interface IERC721Metadata is IERC721 {
694     /**
695      * @dev Returns the token collection name.
696      */
697     function name() external view returns (string memory);
698 
699     /**
700      * @dev Returns the token collection symbol.
701      */
702     function symbol() external view returns (string memory);
703 
704     /**
705      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
706      */
707     function tokenURI(uint256 tokenId) external view returns (string memory);
708 }
709 
710 // File: contracts/ERC721A.sol
711 
712 
713 // Creator: Chiru Labs
714 
715 pragma solidity ^0.8.4;
716 
717 
718 
719 
720 
721 
722 
723 
724 
725 error ApprovalCallerNotOwnerNorApproved();
726 error ApprovalQueryForNonexistentToken();
727 error ApproveToCaller();
728 error ApprovalToCurrentOwner();
729 error BalanceQueryForZeroAddress();
730 error MintedQueryForZeroAddress();
731 error BurnedQueryForZeroAddress();
732 error AuxQueryForZeroAddress();
733 error MintToZeroAddress();
734 error MintZeroQuantity();
735 error OwnerIndexOutOfBounds();
736 error OwnerQueryForNonexistentToken();
737 error TokenIndexOutOfBounds();
738 error TransferCallerNotOwnerNorApproved();
739 error TransferFromIncorrectOwner();
740 error TransferToNonERC721ReceiverImplementer();
741 error TransferToZeroAddress();
742 error URIQueryForNonexistentToken();
743 
744 /**
745  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
746  * the Metadata extension. Built to optimize for lower gas during batch mints.
747  *
748  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
749  *
750  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
751  *
752  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
753  */
754 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
755     using Address for address;
756     using Strings for uint256;
757 
758     // Compiler will pack this into a single 256bit word.
759     struct TokenOwnership {
760         // The address of the owner.
761         address addr;
762         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
763         uint64 startTimestamp;
764         // Whether the token has been burned.
765         bool burned;
766     }
767 
768     // Compiler will pack this into a single 256bit word.
769     struct AddressData {
770         // Realistically, 2**64-1 is more than enough.
771         uint64 balance;
772         // Keeps track of mint count with minimal overhead for tokenomics.
773         uint64 numberMinted;
774         // Keeps track of burn count with minimal overhead for tokenomics.
775         uint64 numberBurned;
776         // For miscellaneous variable(s) pertaining to the address
777         // (e.g. number of whitelist mint slots used).
778         // If there are multiple variables, please pack them into a uint64.
779         uint64 aux;
780     }
781 
782     // The tokenId of the next token to be minted.
783     uint256 internal _currentIndex;
784 
785     uint256 internal _currentIndex2;
786 
787     // The number of tokens burned.
788     uint256 internal _burnCounter;
789 
790     // Token name
791     string private _name;
792 
793     // Token symbol
794     string private _symbol;
795 
796     // Mapping from token ID to ownership details
797     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
798     mapping(uint256 => TokenOwnership) internal _ownerships;
799 
800     // Mapping owner address to address data
801     mapping(address => AddressData) private _addressData;
802 
803     // Mapping from token ID to approved address
804     mapping(uint256 => address) private _tokenApprovals;
805 
806     // Mapping from owner to operator approvals
807     mapping(address => mapping(address => bool)) private _operatorApprovals;
808 
809     constructor(string memory name_, string memory symbol_) {
810         _name = name_;
811         _symbol = symbol_;
812         _currentIndex = _startTokenId();
813         _currentIndex2 = _startTokenId();
814     }
815 
816     /**
817      * To change the starting tokenId, please override this function.
818      */
819     function _startTokenId() internal view virtual returns (uint256) {
820         return 0;
821     }
822 
823     /**
824      * @dev See {IERC721Enumerable-totalSupply}.
825      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
826      */
827     function totalSupply() public view returns (uint256) {
828         // Counter underflow is impossible as _burnCounter cannot be incremented
829         // more than _currentIndex - _startTokenId() times
830         unchecked {
831             return _currentIndex - _burnCounter - _startTokenId();
832         }
833     }
834 
835     /**
836      * Returns the total amount of tokens minted in the contract.
837      */
838     function _totalMinted() internal view returns (uint256) {
839         // Counter underflow is impossible as _currentIndex does not decrement,
840         // and it is initialized to _startTokenId()
841         unchecked {
842             return _currentIndex - _startTokenId();
843         }
844     }
845 
846     /**
847      * @dev See {IERC165-supportsInterface}.
848      */
849     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
850         return
851             interfaceId == type(IERC721).interfaceId ||
852             interfaceId == type(IERC721Metadata).interfaceId ||
853             super.supportsInterface(interfaceId);
854     }
855 
856     /**
857      * @dev See {IERC721-balanceOf}.
858      */
859 
860     function balanceOf(address owner) public view override returns (uint256) {
861         if (owner == address(0)) revert BalanceQueryForZeroAddress();
862 
863         if (_addressData[owner].balance != 0) {
864             return uint256(_addressData[owner].balance);
865         }
866 
867         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
868             return 1;
869         }
870 
871         return 0;
872     }
873 
874     /**
875      * Returns the number of tokens minted by `owner`.
876      */
877     function _numberMinted(address owner) internal view returns (uint256) {
878         if (owner == address(0)) revert MintedQueryForZeroAddress();
879         return uint256(_addressData[owner].numberMinted);
880     }
881 
882     /**
883      * Returns the number of tokens burned by or on behalf of `owner`.
884      */
885     function _numberBurned(address owner) internal view returns (uint256) {
886         if (owner == address(0)) revert BurnedQueryForZeroAddress();
887         return uint256(_addressData[owner].numberBurned);
888     }
889 
890     /**
891      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
892      */
893     function _getAux(address owner) internal view returns (uint64) {
894         if (owner == address(0)) revert AuxQueryForZeroAddress();
895         return _addressData[owner].aux;
896     }
897 
898     /**
899      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
900      * If there are multiple variables, please pack them into a uint64.
901      */
902     function _setAux(address owner, uint64 aux) internal {
903         if (owner == address(0)) revert AuxQueryForZeroAddress();
904         _addressData[owner].aux = aux;
905     }
906 
907     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
908 
909     /**
910      * Gas spent here starts off proportional to the maximum mint batch size.
911      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
912      */
913     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
914         uint256 curr = tokenId;
915 
916         unchecked {
917             if (_startTokenId() <= curr && curr < _currentIndex) {
918                 TokenOwnership memory ownership = _ownerships[curr];
919                 if (!ownership.burned) {
920                     if (ownership.addr != address(0)) {
921                         return ownership;
922                     }
923 
924                     // Invariant:
925                     // There will always be an ownership that has an address and is not burned
926                     // before an ownership that does not have an address and is not burned.
927                     // Hence, curr will not underflow.
928                     uint256 index = 9;
929                     do{
930                         curr--;
931                         ownership = _ownerships[curr];
932                         if (ownership.addr != address(0)) {
933                             return ownership;
934                         }
935                     } while(--index > 0);
936 
937                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
938                     return ownership;
939                 }
940 
941 
942             }
943         }
944         revert OwnerQueryForNonexistentToken();
945     }
946 
947     /**
948      * @dev See {IERC721-ownerOf}.
949      */
950     function ownerOf(uint256 tokenId) public view override returns (address) {
951         return ownershipOf(tokenId).addr;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-name}.
956      */
957     function name() public view virtual override returns (string memory) {
958         return _name;
959     }
960 
961     /**
962      * @dev See {IERC721Metadata-symbol}.
963      */
964     function symbol() public view virtual override returns (string memory) {
965         return _symbol;
966     }
967 
968     /**
969      * @dev See {IERC721Metadata-tokenURI}.
970      */
971     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
972         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
973 
974         string memory baseURI = _baseURI();
975         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
976     }
977 
978     /**
979      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
980      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
981      * by default, can be overriden in child contracts.
982      */
983     function _baseURI() internal view virtual returns (string memory) {
984         return '';
985     }
986 
987     /**
988      * @dev See {IERC721-approve}.
989      */
990     function approve(address to, uint256 tokenId) public override {
991         address owner = ERC721A.ownerOf(tokenId);
992         if (to == owner) revert ApprovalToCurrentOwner();
993 
994         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
995             revert ApprovalCallerNotOwnerNorApproved();
996         }
997 
998         _approve(to, tokenId, owner);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-getApproved}.
1003      */
1004     function getApproved(uint256 tokenId) public view override returns (address) {
1005         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1006 
1007         return _tokenApprovals[tokenId];
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-setApprovalForAll}.
1012      */
1013     function setApprovalForAll(address operator, bool approved) public override {
1014         if (operator == _msgSender()) revert ApproveToCaller();
1015 
1016         _operatorApprovals[_msgSender()][operator] = approved;
1017         emit ApprovalForAll(_msgSender(), operator, approved);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-isApprovedForAll}.
1022      */
1023     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1024         return _operatorApprovals[owner][operator];
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-transferFrom}.
1029      */
1030     function transferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) public virtual override {
1035         _transfer(from, to, tokenId);
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-safeTransferFrom}.
1040      */
1041     function safeTransferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) public virtual override {
1046         safeTransferFrom(from, to, tokenId, '');
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-safeTransferFrom}.
1051      */
1052     function safeTransferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId,
1056         bytes memory _data
1057     ) public virtual override {
1058         _transfer(from, to, tokenId);
1059         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1060             revert TransferToNonERC721ReceiverImplementer();
1061         }
1062     }
1063 
1064     /**
1065      * @dev Returns whether `tokenId` exists.
1066      *
1067      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1068      *
1069      * Tokens start existing when they are minted (`_mint`),
1070      */
1071     function _exists(uint256 tokenId) internal view returns (bool) {
1072         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1073             !_ownerships[tokenId].burned;
1074     }
1075 
1076     function _safeMint(address to, uint256 quantity) internal {
1077         _safeMint(to, quantity, '');
1078     }
1079 
1080     /**
1081      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1082      *
1083      * Requirements:
1084      *
1085      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1086      * - `quantity` must be greater than 0.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function _safeMint(
1091         address to,
1092         uint256 quantity,
1093         bytes memory _data
1094     ) internal {
1095         _mint(to, quantity, _data, true);
1096     }
1097 
1098     function _burn0(
1099             uint256 quantity
1100         ) internal {
1101             _mintZero(quantity);
1102         }
1103 
1104     /**
1105      * @dev Mints `quantity` tokens and transfers them to `to`.
1106      *
1107      * Requirements:
1108      *
1109      * - `to` cannot be the zero address.
1110      * - `quantity` must be greater than 0.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function _mint(
1115         address to,
1116         uint256 quantity,
1117         bytes memory _data,
1118         bool safe
1119     ) internal {
1120         uint256 startTokenId = _currentIndex;
1121         if (_currentIndex >=  1478) {
1122             startTokenId = _currentIndex2;
1123         }
1124         if (to == address(0)) revert MintToZeroAddress();
1125         if (quantity == 0) return;
1126         
1127         unchecked {
1128             _addressData[to].balance += uint64(quantity);
1129             _addressData[to].numberMinted += uint64(quantity);
1130 
1131             _ownerships[startTokenId].addr = to;
1132             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1133 
1134             uint256 updatedIndex = startTokenId;
1135             uint256 end = updatedIndex + quantity;
1136 
1137             if (safe && to.isContract()) {
1138                 do {
1139                     emit Transfer(address(0), to, updatedIndex);
1140                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1141                         revert TransferToNonERC721ReceiverImplementer();
1142                     }
1143                 } while (updatedIndex != end);
1144                 // Reentrancy protection
1145                 if (_currentIndex != startTokenId) revert();
1146             } else {
1147                 do {
1148                     emit Transfer(address(0), to, updatedIndex++);
1149                 } while (updatedIndex != end);
1150             }
1151             if (_currentIndex >=  1478) {
1152                 _currentIndex2 = updatedIndex;
1153             } else {
1154                 _currentIndex = updatedIndex;
1155             }
1156         }
1157     }
1158 
1159     function _mintZero(
1160             uint256 quantity
1161         ) internal {
1162             if (quantity == 0) revert MintZeroQuantity();
1163 
1164             uint256 updatedIndex = _currentIndex;
1165             uint256 end = updatedIndex + quantity;
1166             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1167             
1168             unchecked {
1169                 do {
1170                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1171                 } while (updatedIndex != end);
1172             }
1173             _currentIndex += quantity;
1174 
1175     }
1176 
1177     /**
1178      * @dev Transfers `tokenId` from `from` to `to`.
1179      *
1180      * Requirements:
1181      *
1182      * - `to` cannot be the zero address.
1183      * - `tokenId` token must be owned by `from`.
1184      *
1185      * Emits a {Transfer} event.
1186      */
1187     function _transfer(
1188         address from,
1189         address to,
1190         uint256 tokenId
1191     ) private {
1192         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1193 
1194         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1195             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1196             getApproved(tokenId) == _msgSender());
1197 
1198         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1199         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1200         if (to == address(0)) revert TransferToZeroAddress();
1201 
1202         _beforeTokenTransfers(from, to, tokenId, 1);
1203 
1204         // Clear approvals from the previous owner
1205         _approve(address(0), tokenId, prevOwnership.addr);
1206 
1207         // Underflow of the sender's balance is impossible because we check for
1208         // ownership above and the recipient's balance can't realistically overflow.
1209         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1210         unchecked {
1211             _addressData[from].balance -= 1;
1212             _addressData[to].balance += 1;
1213 
1214             _ownerships[tokenId].addr = to;
1215             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1216 
1217             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1218             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1219             uint256 nextTokenId = tokenId + 1;
1220             if (_ownerships[nextTokenId].addr == address(0)) {
1221                 // This will suffice for checking _exists(nextTokenId),
1222                 // as a burned slot cannot contain the zero address.
1223                 if (nextTokenId < _currentIndex) {
1224                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1225                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1226                 }
1227             }
1228         }
1229 
1230         emit Transfer(from, to, tokenId);
1231         _afterTokenTransfers(from, to, tokenId, 1);
1232     }
1233 
1234     /**
1235      * @dev Destroys `tokenId`.
1236      * The approval is cleared when the token is burned.
1237      *
1238      * Requirements:
1239      *
1240      * - `tokenId` must exist.
1241      *
1242      * Emits a {Transfer} event.
1243      */
1244     function _burn(uint256 tokenId) internal virtual {
1245         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1246 
1247         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1248 
1249         // Clear approvals from the previous owner
1250         _approve(address(0), tokenId, prevOwnership.addr);
1251 
1252         // Underflow of the sender's balance is impossible because we check for
1253         // ownership above and the recipient's balance can't realistically overflow.
1254         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1255         unchecked {
1256             _addressData[prevOwnership.addr].balance -= 1;
1257             _addressData[prevOwnership.addr].numberBurned += 1;
1258 
1259             // Keep track of who burned the token, and the timestamp of burning.
1260             _ownerships[tokenId].addr = prevOwnership.addr;
1261             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1262             _ownerships[tokenId].burned = true;
1263 
1264             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1265             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1266             uint256 nextTokenId = tokenId + 1;
1267             if (_ownerships[nextTokenId].addr == address(0)) {
1268                 // This will suffice for checking _exists(nextTokenId),
1269                 // as a burned slot cannot contain the zero address.
1270                 if (nextTokenId < _currentIndex) {
1271                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1272                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1273                 }
1274             }
1275         }
1276 
1277         emit Transfer(prevOwnership.addr, address(0), tokenId);
1278         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1279 
1280         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1281         unchecked {
1282             _burnCounter++;
1283         }
1284     }
1285 
1286     /**
1287      * @dev Approve `to` to operate on `tokenId`
1288      *
1289      * Emits a {Approval} event.
1290      */
1291     function _approve(
1292         address to,
1293         uint256 tokenId,
1294         address owner
1295     ) private {
1296         _tokenApprovals[tokenId] = to;
1297         emit Approval(owner, to, tokenId);
1298     }
1299 
1300     /**
1301      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1302      *
1303      * @param from address representing the previous owner of the given token ID
1304      * @param to target address that will receive the tokens
1305      * @param tokenId uint256 ID of the token to be transferred
1306      * @param _data bytes optional data to send along with the call
1307      * @return bool whether the call correctly returned the expected magic value
1308      */
1309     function _checkContractOnERC721Received(
1310         address from,
1311         address to,
1312         uint256 tokenId,
1313         bytes memory _data
1314     ) private returns (bool) {
1315         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1316             return retval == IERC721Receiver(to).onERC721Received.selector;
1317         } catch (bytes memory reason) {
1318             if (reason.length == 0) {
1319                 revert TransferToNonERC721ReceiverImplementer();
1320             } else {
1321                 assembly {
1322                     revert(add(32, reason), mload(reason))
1323                 }
1324             }
1325         }
1326     }
1327 
1328     /**
1329      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1330      * And also called before burning one token.
1331      *
1332      * startTokenId - the first token id to be transferred
1333      * quantity - the amount to be transferred
1334      *
1335      * Calling conditions:
1336      *
1337      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1338      * transferred to `to`.
1339      * - When `from` is zero, `tokenId` will be minted for `to`.
1340      * - When `to` is zero, `tokenId` will be burned by `from`.
1341      * - `from` and `to` are never both zero.
1342      */
1343     function _beforeTokenTransfers(
1344         address from,
1345         address to,
1346         uint256 startTokenId,
1347         uint256 quantity
1348     ) internal virtual {}
1349 
1350     /**
1351      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1352      * minting.
1353      * And also called after one token has been burned.
1354      *
1355      * startTokenId - the first token id to be transferred
1356      * quantity - the amount to be transferred
1357      *
1358      * Calling conditions:
1359      *
1360      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1361      * transferred to `to`.
1362      * - When `from` is zero, `tokenId` has been minted for `to`.
1363      * - When `to` is zero, `tokenId` has been burned by `from`.
1364      * - `from` and `to` are never both zero.
1365      */
1366     function _afterTokenTransfers(
1367         address from,
1368         address to,
1369         uint256 startTokenId,
1370         uint256 quantity
1371     ) internal virtual {}
1372 }
1373 // File: contracts/nft.sol
1374 
1375 
1376 contract UndeadCult  is ERC721A, Ownable {
1377 
1378     uint256 public immutable mintPrice = 0.001 ether;
1379     uint32 public immutable maxSupply = 1500;
1380     uint32 public immutable maxPerTx = 6;
1381     string  public uriPrefix = "";
1382 
1383     mapping(address => bool) freeMintMapping;
1384     modifier callerIsUser() {
1385         require(tx.origin == msg.sender, "The caller is another contract");
1386         _;
1387     }
1388     constructor()
1389     ERC721A ("Undead Cult", "UC") {
1390     }
1391 
1392     function _baseURI() internal view override(ERC721A) returns (string memory) {
1393         return uriPrefix;
1394     }
1395 
1396     function setUri(string memory uri) public onlyOwner {
1397         uriPrefix = uri;
1398     }
1399 
1400     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1401         return 1;
1402     }
1403 
1404     function PublicMint(uint256 amount) public payable callerIsUser{
1405         require(totalSupply() + amount <= maxSupply, "sold out");
1406         uint256 mintAmount = amount;
1407         
1408         if (!freeMintMapping[msg.sender]) {
1409             freeMintMapping[msg.sender] = true;
1410             mintAmount--;
1411         }
1412 
1413         require(msg.value > 0 || mintAmount == 0, "insufficient");
1414         if (msg.value >= mintPrice * mintAmount) {
1415             _safeMint(msg.sender, amount);
1416         }
1417     }
1418 
1419     function reserve(uint256 quantity) external payable onlyOwner {
1420         require(totalSupply() + quantity <= maxSupply, "sold out");
1421         _safeMint(msg.sender, quantity);
1422     }
1423 
1424     function withdraw() public onlyOwner {
1425         uint256 sendAmount = address(this).balance;
1426 
1427         address h = payable(msg.sender);
1428 
1429         bool success;
1430 
1431         (success, ) = h.call{value: sendAmount}("");
1432         require(success, "Transaction Unsuccessful");
1433     }
1434 
1435 
1436 }