1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
7 
8 
9 
10 //    /$$$$$$  /$$   /$$ /$$$$$$$                  /$$                              
11 //   /$$$_  $$| $$  / $$| $$__  $$                | $$                              
12 //  | $$$$\ $$|  $$/ $$/| $$  \ $$ /$$   /$$  /$$$$$$$  /$$$$$$  /$$   /$$  /$$$$$$$
13 //  | $$ $$ $$ \  $$$$/ | $$$$$$$/| $$  | $$ /$$__  $$ /$$__  $$| $$  | $$ /$$_____/
14 //  | $$\ $$$$  >$$  $$ | $$____/ | $$  | $$| $$  | $$| $$  \ $$| $$  | $$|  $$$$$$ 
15 //  | $$ \ $$$ /$$/\  $$| $$      | $$  | $$| $$  | $$| $$  | $$| $$  | $$ \____  $$
16 //  |  $$$$$$/| $$  \ $$| $$      |  $$$$$$/|  $$$$$$$|  $$$$$$$|  $$$$$$$ /$$$$$$$/
17 //   \______/ |__/  |__/|__/       \______/  \_______/ \____  $$ \____  $$|_______/ 
18 //                                                     /$$  \ $$ /$$  | $$          
19 //                                                    |  $$$$$$/|  $$$$$$/          
20 //                                                     \______/  \______/           
21 
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @title Counters
27  * @author Matt Condon (@shrugs)
28  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
29  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
30  *
31  * Include with `using Counters for Counters.Counter;`
32  */
33 library Counters {
34     struct Counter {
35         // This variable should never be directly accessed by users of the library: interactions must be restricted to
36         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
37         // this feature: see https://github.com/ethereum/solidity/issues/4637
38         uint256 _value; // default: 0
39     }
40 
41     function current(Counter storage counter) internal view returns (uint256) {
42         return counter._value;
43     }
44 
45     function increment(Counter storage counter) internal {
46         unchecked {
47             counter._value += 1;
48         }
49     }
50 
51     function decrement(Counter storage counter) internal {
52         uint256 value = counter._value;
53         require(value > 0, "Counter: decrement overflow");
54         unchecked {
55             counter._value = value - 1;
56         }
57     }
58 
59     function reset(Counter storage counter) internal {
60         counter._value = 0;
61     }
62 }
63 
64 // File: @openzeppelin/contracts/utils/Strings.sol
65 
66 
67 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev String operations.
73  */
74 library Strings {
75     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
76     uint8 private constant _ADDRESS_LENGTH = 20;
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
80      */
81     function toString(uint256 value) internal pure returns (string memory) {
82         // Inspired by OraclizeAPI's implementation - MIT licence
83         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
84 
85         if (value == 0) {
86             return "0";
87         }
88         uint256 temp = value;
89         uint256 digits;
90         while (temp != 0) {
91             digits++;
92             temp /= 10;
93         }
94         bytes memory buffer = new bytes(digits);
95         while (value != 0) {
96             digits -= 1;
97             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
98             value /= 10;
99         }
100         return string(buffer);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
105      */
106     function toHexString(uint256 value) internal pure returns (string memory) {
107         if (value == 0) {
108             return "0x00";
109         }
110         uint256 temp = value;
111         uint256 length = 0;
112         while (temp != 0) {
113             length++;
114             temp >>= 8;
115         }
116         return toHexString(value, length);
117     }
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
121      */
122     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
123         bytes memory buffer = new bytes(2 * length + 2);
124         buffer[0] = "0";
125         buffer[1] = "x";
126         for (uint256 i = 2 * length + 1; i > 1; --i) {
127             buffer[i] = _HEX_SYMBOLS[value & 0xf];
128             value >>= 4;
129         }
130         require(value == 0, "Strings: hex length insufficient");
131         return string(buffer);
132     }
133 
134     /**
135      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
136      */
137     function toHexString(address addr) internal pure returns (string memory) {
138         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
139     }
140 }
141 
142 // File: @openzeppelin/contracts/utils/Context.sol
143 
144 
145 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
146 
147 pragma solidity ^0.8.0;
148 
149 /**
150  * @dev Provides information about the current execution context, including the
151  * sender of the transaction and its data. While these are generally available
152  * via msg.sender and msg.data, they should not be accessed in such a direct
153  * manner, since when dealing with meta-transactions the account sending and
154  * paying for execution may not be the actual sender (as far as an application
155  * is concerned).
156  *
157  * This contract is only required for intermediate, library-like contracts.
158  */
159 abstract contract Context {
160     function _msgSender() internal view virtual returns (address) {
161         return msg.sender;
162     }
163 
164     function _msgData() internal view virtual returns (bytes calldata) {
165         return msg.data;
166     }
167 }
168 
169 // File: @openzeppelin/contracts/access/Ownable.sol
170 
171 
172 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
173 
174 pragma solidity ^0.8.0;
175 
176 
177 /**
178  * @dev Contract module which provides a basic access control mechanism, where
179  * there is an account (an owner) that can be granted exclusive access to
180  * specific functions.
181  *
182  * By default, the owner account will be the one that deploys the contract. This
183  * can later be changed with {transferOwnership}.
184  *
185  * This module is used through inheritance. It will make available the modifier
186  * `onlyOwner`, which can be applied to your functions to restrict their use to
187  * the owner.
188  */
189 abstract contract Ownable is Context {
190     address private _owner;
191 
192     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
193 
194     /**
195      * @dev Initializes the contract setting the deployer as the initial owner.
196      */
197     constructor() {
198         _transferOwnership(_msgSender());
199     }
200 
201     /**
202      * @dev Throws if called by any account other than the owner.
203      */
204     modifier onlyOwner() {
205         _checkOwner();
206         _;
207     }
208 
209     /**
210      * @dev Returns the address of the current owner.
211      */
212     function owner() public view virtual returns (address) {
213         return _owner;
214     }
215 
216     /**
217      * @dev Throws if the sender is not the owner.
218      */
219     function _checkOwner() internal view virtual {
220         require(owner() == _msgSender(), "Ownable: caller is not the owner");
221     }
222 
223     /**
224      * @dev Leaves the contract without owner. It will not be possible to call
225      * `onlyOwner` functions anymore. Can only be called by the current owner.
226      *
227      * NOTE: Renouncing ownership will leave the contract without an owner,
228      * thereby removing any functionality that is only available to the owner.
229      */
230     function renounceOwnership() public virtual onlyOwner {
231         _transferOwnership(address(0));
232     }
233 
234     /**
235      * @dev Transfers ownership of the contract to a new account (`newOwner`).
236      * Can only be called by the current owner.
237      */
238     function transferOwnership(address newOwner) public virtual onlyOwner {
239         require(newOwner != address(0), "Ownable: new owner is the zero address");
240         _transferOwnership(newOwner);
241     }
242 
243     /**
244      * @dev Transfers ownership of the contract to a new account (`newOwner`).
245      * Internal function without access restriction.
246      */
247     function _transferOwnership(address newOwner) internal virtual {
248         address oldOwner = _owner;
249         _owner = newOwner;
250         emit OwnershipTransferred(oldOwner, newOwner);
251     }
252 }
253 
254 // File: @openzeppelin/contracts/utils/Address.sol
255 
256 
257 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
258 
259 pragma solidity ^0.8.1;
260 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if `account` is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, `isContract` will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      *
282      * [IMPORTANT]
283      * ====
284      * You shouldn't rely on `isContract` to protect against flash loan attacks!
285      *
286      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
287      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
288      * constructor.
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // This method relies on extcodesize/address.code.length, which returns 0
293         // for contracts in construction, since the code is only stored at the end
294         // of the constructor execution.
295 
296         return account.code.length > 0;
297     }
298 
299     /**
300      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
301      * `recipient`, forwarding all available gas and reverting on errors.
302      *
303      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
304      * of certain opcodes, possibly making contracts go over the 2300 gas limit
305      * imposed by `transfer`, making them unable to receive funds via
306      * `transfer`. {sendValue} removes this limitation.
307      *
308      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
309      *
310      * IMPORTANT: because control is transferred to `recipient`, care must be
311      * taken to not create reentrancy vulnerabilities. Consider using
312      * {ReentrancyGuard} or the
313      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
314      */
315     function sendValue(address payable recipient, uint256 amount) internal {
316         require(address(this).balance >= amount, "Address: insufficient balance");
317 
318         (bool success, ) = recipient.call{value: amount}("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level `call`. A
324      * plain `call` is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If `target` reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332      *
333      * Requirements:
334      *
335      * - `target` must be a contract.
336      * - calling `target` with `data` must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341         return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346      * `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value
373     ) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
379      * with `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(
384         address target,
385         bytes memory data,
386         uint256 value,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         require(address(this).balance >= value, "Address: insufficient balance for call");
390         require(isContract(target), "Address: call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.call{value: value}(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a static call.
399      *
400      * _Available since v3.3._
401      */
402     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
403         return functionStaticCall(target, data, "Address: low-level static call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a static call.
409      *
410      * _Available since v3.3._
411      */
412     function functionStaticCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal view returns (bytes memory) {
417         require(isContract(target), "Address: static call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.staticcall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a delegate call.
426      *
427      * _Available since v3.4._
428      */
429     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
430         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a delegate call.
436      *
437      * _Available since v3.4._
438      */
439     function functionDelegateCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal returns (bytes memory) {
444         require(isContract(target), "Address: delegate call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.delegatecall(data);
447         return verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
452      * revert reason using the provided one.
453      *
454      * _Available since v4.3._
455      */
456     function verifyCallResult(
457         bool success,
458         bytes memory returndata,
459         string memory errorMessage
460     ) internal pure returns (bytes memory) {
461         if (success) {
462             return returndata;
463         } else {
464             // Look for revert reason and bubble it up if present
465             if (returndata.length > 0) {
466                 // The easiest way to bubble the revert reason is using memory via assembly
467                 /// @solidity memory-safe-assembly
468                 assembly {
469                     let returndata_size := mload(returndata)
470                     revert(add(32, returndata), returndata_size)
471                 }
472             } else {
473                 revert(errorMessage);
474             }
475         }
476     }
477 }
478 
479 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
480 
481 
482 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
483 
484 pragma solidity ^0.8.0;
485 
486 /**
487  * @title ERC721 token receiver interface
488  * @dev Interface for any contract that wants to support safeTransfers
489  * from ERC721 asset contracts.
490  */
491 interface IERC721Receiver {
492     /**
493      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
494      * by `operator` from `from`, this function is called.
495      *
496      * It must return its Solidity selector to confirm the token transfer.
497      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
498      *
499      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
500      */
501     function onERC721Received(
502         address operator,
503         address from,
504         uint256 tokenId,
505         bytes calldata data
506     ) external returns (bytes4);
507 }
508 
509 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
510 
511 
512 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 /**
517  * @dev Interface of the ERC165 standard, as defined in the
518  * https://eips.ethereum.org/EIPS/eip-165[EIP].
519  *
520  * Implementers can declare support of contract interfaces, which can then be
521  * queried by others ({ERC165Checker}).
522  *
523  * For an implementation, see {ERC165}.
524  */
525 interface IERC165 {
526     /**
527      * @dev Returns true if this contract implements the interface defined by
528      * `interfaceId`. See the corresponding
529      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
530      * to learn more about how these ids are created.
531      *
532      * This function call must use less than 30 000 gas.
533      */
534     function supportsInterface(bytes4 interfaceId) external view returns (bool);
535 }
536 
537 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 
545 /**
546  * @dev Implementation of the {IERC165} interface.
547  *
548  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
549  * for the additional interface id that will be supported. For example:
550  *
551  * ```solidity
552  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
553  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
554  * }
555  * ```
556  *
557  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
558  */
559 abstract contract ERC165 is IERC165 {
560     /**
561      * @dev See {IERC165-supportsInterface}.
562      */
563     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564         return interfaceId == type(IERC165).interfaceId;
565     }
566 }
567 
568 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
569 
570 
571 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 
576 /**
577  * @dev Required interface of an ERC721 compliant contract.
578  */
579 interface IERC721 is IERC165 {
580     /**
581      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
582      */
583     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
584 
585     /**
586      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
587      */
588     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
589 
590     /**
591      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
592      */
593     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
594 
595     /**
596      * @dev Returns the number of tokens in ``owner``'s account.
597      */
598     function balanceOf(address owner) external view returns (uint256 balance);
599 
600     /**
601      * @dev Returns the owner of the `tokenId` token.
602      *
603      * Requirements:
604      *
605      * - `tokenId` must exist.
606      */
607     function ownerOf(uint256 tokenId) external view returns (address owner);
608 
609     /**
610      * @dev Safely transfers `tokenId` token from `from` to `to`.
611      *
612      * Requirements:
613      *
614      * - `from` cannot be the zero address.
615      * - `to` cannot be the zero address.
616      * - `tokenId` token must exist and be owned by `from`.
617      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
618      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
619      *
620      * Emits a {Transfer} event.
621      */
622     function safeTransferFrom(
623         address from,
624         address to,
625         uint256 tokenId,
626         bytes calldata data
627     ) external;
628 
629     /**
630      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
631      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
632      *
633      * Requirements:
634      *
635      * - `from` cannot be the zero address.
636      * - `to` cannot be the zero address.
637      * - `tokenId` token must exist and be owned by `from`.
638      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
639      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
640      *
641      * Emits a {Transfer} event.
642      */
643     function safeTransferFrom(
644         address from,
645         address to,
646         uint256 tokenId
647     ) external;
648 
649     /**
650      * @dev Transfers `tokenId` token from `from` to `to`.
651      *
652      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
653      *
654      * Requirements:
655      *
656      * - `from` cannot be the zero address.
657      * - `to` cannot be the zero address.
658      * - `tokenId` token must be owned by `from`.
659      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
660      *
661      * Emits a {Transfer} event.
662      */
663     function transferFrom(
664         address from,
665         address to,
666         uint256 tokenId
667     ) external;
668 
669     /**
670      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
671      * The approval is cleared when the token is transferred.
672      *
673      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
674      *
675      * Requirements:
676      *
677      * - The caller must own the token or be an approved operator.
678      * - `tokenId` must exist.
679      *
680      * Emits an {Approval} event.
681      */
682     function approve(address to, uint256 tokenId) external;
683 
684     /**
685      * @dev Approve or remove `operator` as an operator for the caller.
686      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
687      *
688      * Requirements:
689      *
690      * - The `operator` cannot be the caller.
691      *
692      * Emits an {ApprovalForAll} event.
693      */
694     function setApprovalForAll(address operator, bool _approved) external;
695 
696     /**
697      * @dev Returns the account approved for `tokenId` token.
698      *
699      * Requirements:
700      *
701      * - `tokenId` must exist.
702      */
703     function getApproved(uint256 tokenId) external view returns (address operator);
704 
705     /**
706      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
707      *
708      * See {setApprovalForAll}
709      */
710     function isApprovedForAll(address owner, address operator) external view returns (bool);
711 }
712 
713 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
714 
715 
716 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 
721 /**
722  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
723  * @dev See https://eips.ethereum.org/EIPS/eip-721
724  */
725 interface IERC721Metadata is IERC721 {
726     /**
727      * @dev Returns the token collection name.
728      */
729     function name() external view returns (string memory);
730 
731     /**
732      * @dev Returns the token collection symbol.
733      */
734     function symbol() external view returns (string memory);
735 
736     /**
737      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
738      */
739     function tokenURI(uint256 tokenId) external view returns (string memory);
740 }
741 
742 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
743 
744 
745 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
746 
747 pragma solidity ^0.8.0;
748 
749 
750 
751 
752 
753 
754 
755 
756 /**
757  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
758  * the Metadata extension, but not including the Enumerable extension, which is available separately as
759  * {ERC721Enumerable}.
760  */
761 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
762     using Address for address;
763     using Strings for uint256;
764 
765     // Token name
766     string private _name;
767 
768     // Token symbol
769     string private _symbol;
770 
771     // Mapping from token ID to owner address
772     mapping(uint256 => address) private _owners;
773 
774     // Mapping owner address to token count
775     mapping(address => uint256) private _balances;
776 
777     // Mapping from token ID to approved address
778     mapping(uint256 => address) private _tokenApprovals;
779 
780     // Mapping from owner to operator approvals
781     mapping(address => mapping(address => bool)) private _operatorApprovals;
782 
783     /**
784      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
785      */
786     constructor(string memory name_, string memory symbol_) {
787         _name = name_;
788         _symbol = symbol_;
789     }
790 
791     /**
792      * @dev See {IERC165-supportsInterface}.
793      */
794     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
795         return
796             interfaceId == type(IERC721).interfaceId ||
797             interfaceId == type(IERC721Metadata).interfaceId ||
798             super.supportsInterface(interfaceId);
799     }
800 
801     /**
802      * @dev See {IERC721-balanceOf}.
803      */
804     function balanceOf(address owner) public view virtual override returns (uint256) {
805         require(owner != address(0), "ERC721: address zero is not a valid owner");
806         return _balances[owner];
807     }
808 
809     /**
810      * @dev See {IERC721-ownerOf}.
811      */
812     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
813         address owner = _owners[tokenId];
814         require(owner != address(0), "ERC721: invalid token ID");
815         return owner;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-name}.
820      */
821     function name() public view virtual override returns (string memory) {
822         return _name;
823     }
824 
825     /**
826      * @dev See {IERC721Metadata-symbol}.
827      */
828     function symbol() public view virtual override returns (string memory) {
829         return _symbol;
830     }
831 
832     /**
833      * @dev See {IERC721Metadata-tokenURI}.
834      */
835     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
836         _requireMinted(tokenId);
837 
838         string memory baseURI = _baseURI();
839         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
840     }
841 
842     /**
843      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
844      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
845      * by default, can be overridden in child contracts.
846      */
847     function _baseURI() internal view virtual returns (string memory) {
848         return "";
849     }
850 
851     /**
852      * @dev See {IERC721-approve}.
853      */
854     function approve(address to, uint256 tokenId) public virtual override {
855         address owner = ERC721.ownerOf(tokenId);
856         require(to != owner, "ERC721: approval to current owner");
857 
858         require(
859             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
860             "ERC721: approve caller is not token owner nor approved for all"
861         );
862 
863         _approve(to, tokenId);
864     }
865 
866     /**
867      * @dev See {IERC721-getApproved}.
868      */
869     function getApproved(uint256 tokenId) public view virtual override returns (address) {
870         _requireMinted(tokenId);
871 
872         return _tokenApprovals[tokenId];
873     }
874 
875     /**
876      * @dev See {IERC721-setApprovalForAll}.
877      */
878     function setApprovalForAll(address operator, bool approved) public virtual override {
879         _setApprovalForAll(_msgSender(), operator, approved);
880     }
881 
882     /**
883      * @dev See {IERC721-isApprovedForAll}.
884      */
885     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
886         return _operatorApprovals[owner][operator];
887     }
888 
889     /**
890      * @dev See {IERC721-transferFrom}.
891      */
892     function transferFrom(
893         address from,
894         address to,
895         uint256 tokenId
896     ) public virtual override {
897         //solhint-disable-next-line max-line-length
898         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
899 
900         _transfer(from, to, tokenId);
901     }
902 
903     /**
904      * @dev See {IERC721-safeTransferFrom}.
905      */
906     function safeTransferFrom(
907         address from,
908         address to,
909         uint256 tokenId
910     ) public virtual override {
911         safeTransferFrom(from, to, tokenId, "");
912     }
913 
914     /**
915      * @dev See {IERC721-safeTransferFrom}.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes memory data
922     ) public virtual override {
923         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
924         _safeTransfer(from, to, tokenId, data);
925     }
926 
927     /**
928      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
929      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
930      *
931      * `data` is additional data, it has no specified format and it is sent in call to `to`.
932      *
933      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
934      * implement alternative mechanisms to perform token transfer, such as signature-based.
935      *
936      * Requirements:
937      *
938      * - `from` cannot be the zero address.
939      * - `to` cannot be the zero address.
940      * - `tokenId` token must exist and be owned by `from`.
941      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
942      *
943      * Emits a {Transfer} event.
944      */
945     function _safeTransfer(
946         address from,
947         address to,
948         uint256 tokenId,
949         bytes memory data
950     ) internal virtual {
951         _transfer(from, to, tokenId);
952         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
953     }
954 
955     /**
956      * @dev Returns whether `tokenId` exists.
957      *
958      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
959      *
960      * Tokens start existing when they are minted (`_mint`),
961      * and stop existing when they are burned (`_burn`).
962      */
963     function _exists(uint256 tokenId) internal view virtual returns (bool) {
964         return _owners[tokenId] != address(0);
965     }
966 
967     /**
968      * @dev Returns whether `spender` is allowed to manage `tokenId`.
969      *
970      * Requirements:
971      *
972      * - `tokenId` must exist.
973      */
974     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
975         address owner = ERC721.ownerOf(tokenId);
976         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
977     }
978 
979     /**
980      * @dev Safely mints `tokenId` and transfers it to `to`.
981      *
982      * Requirements:
983      *
984      * - `tokenId` must not exist.
985      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _safeMint(address to, uint256 tokenId) internal virtual {
990         _safeMint(to, tokenId, "");
991     }
992 
993     /**
994      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
995      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
996      */
997     function _safeMint(
998         address to,
999         uint256 tokenId,
1000         bytes memory data
1001     ) internal virtual {
1002         _mint(to, tokenId);
1003         require(
1004             _checkOnERC721Received(address(0), to, tokenId, data),
1005             "ERC721: transfer to non ERC721Receiver implementer"
1006         );
1007     }
1008 
1009     /**
1010      * @dev Mints `tokenId` and transfers it to `to`.
1011      *
1012      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1013      *
1014      * Requirements:
1015      *
1016      * - `tokenId` must not exist.
1017      * - `to` cannot be the zero address.
1018      *
1019      * Emits a {Transfer} event.
1020      */
1021     function _mint(address to, uint256 tokenId) internal virtual {
1022         require(to != address(0), "ERC721: mint to the zero address");
1023         require(!_exists(tokenId), "ERC721: token already minted");
1024 
1025         _beforeTokenTransfer(address(0), to, tokenId);
1026 
1027         _balances[to] += 1;
1028         _owners[tokenId] = to;
1029 
1030         emit Transfer(address(0), to, tokenId);
1031 
1032         _afterTokenTransfer(address(0), to, tokenId);
1033     }
1034 
1035     /**
1036      * @dev Destroys `tokenId`.
1037      * The approval is cleared when the token is burned.
1038      *
1039      * Requirements:
1040      *
1041      * - `tokenId` must exist.
1042      *
1043      * Emits a {Transfer} event.
1044      */
1045     function _burn(uint256 tokenId) internal virtual {
1046         address owner = ERC721.ownerOf(tokenId);
1047 
1048         _beforeTokenTransfer(owner, address(0), tokenId);
1049 
1050         // Clear approvals
1051         _approve(address(0), tokenId);
1052 
1053         _balances[owner] -= 1;
1054         delete _owners[tokenId];
1055 
1056         emit Transfer(owner, address(0), tokenId);
1057 
1058         _afterTokenTransfer(owner, address(0), tokenId);
1059     }
1060 
1061     /**
1062      * @dev Transfers `tokenId` from `from` to `to`.
1063      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1064      *
1065      * Requirements:
1066      *
1067      * - `to` cannot be the zero address.
1068      * - `tokenId` token must be owned by `from`.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _transfer(
1073         address from,
1074         address to,
1075         uint256 tokenId
1076     ) internal virtual {
1077         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1078         require(to != address(0), "ERC721: transfer to the zero address");
1079 
1080         _beforeTokenTransfer(from, to, tokenId);
1081 
1082         // Clear approvals from the previous owner
1083         _approve(address(0), tokenId);
1084 
1085         _balances[from] -= 1;
1086         _balances[to] += 1;
1087         _owners[tokenId] = to;
1088 
1089         emit Transfer(from, to, tokenId);
1090 
1091         _afterTokenTransfer(from, to, tokenId);
1092     }
1093 
1094     /**
1095      * @dev Approve `to` to operate on `tokenId`
1096      *
1097      * Emits an {Approval} event.
1098      */
1099     function _approve(address to, uint256 tokenId) internal virtual {
1100         _tokenApprovals[tokenId] = to;
1101         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1102     }
1103 
1104     /**
1105      * @dev Approve `operator` to operate on all of `owner` tokens
1106      *
1107      * Emits an {ApprovalForAll} event.
1108      */
1109     function _setApprovalForAll(
1110         address owner,
1111         address operator,
1112         bool approved
1113     ) internal virtual {
1114         require(owner != operator, "ERC721: approve to caller");
1115         _operatorApprovals[owner][operator] = approved;
1116         emit ApprovalForAll(owner, operator, approved);
1117     }
1118 
1119     /**
1120      * @dev Reverts if the `tokenId` has not been minted yet.
1121      */
1122     function _requireMinted(uint256 tokenId) internal view virtual {
1123         require(_exists(tokenId), "ERC721: invalid token ID");
1124     }
1125 
1126     /**
1127      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1128      * The call is not executed if the target address is not a contract.
1129      *
1130      * @param from address representing the previous owner of the given token ID
1131      * @param to target address that will receive the tokens
1132      * @param tokenId uint256 ID of the token to be transferred
1133      * @param data bytes optional data to send along with the call
1134      * @return bool whether the call correctly returned the expected magic value
1135      */
1136     function _checkOnERC721Received(
1137         address from,
1138         address to,
1139         uint256 tokenId,
1140         bytes memory data
1141     ) private returns (bool) {
1142         if (to.isContract()) {
1143             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1144                 return retval == IERC721Receiver.onERC721Received.selector;
1145             } catch (bytes memory reason) {
1146                 if (reason.length == 0) {
1147                     revert("ERC721: transfer to non ERC721Receiver implementer");
1148                 } else {
1149                     /// @solidity memory-safe-assembly
1150                     assembly {
1151                         revert(add(32, reason), mload(reason))
1152                     }
1153                 }
1154             }
1155         } else {
1156             return true;
1157         }
1158     }
1159 
1160     /**
1161      * @dev Hook that is called before any token transfer. This includes minting
1162      * and burning.
1163      *
1164      * Calling conditions:
1165      *
1166      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1167      * transferred to `to`.
1168      * - When `from` is zero, `tokenId` will be minted for `to`.
1169      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1170      * - `from` and `to` are never both zero.
1171      *
1172      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1173      */
1174     function _beforeTokenTransfer(
1175         address from,
1176         address to,
1177         uint256 tokenId
1178     ) internal virtual {}
1179 
1180     /**
1181      * @dev Hook that is called after any transfer of tokens. This includes
1182      * minting and burning.
1183      *
1184      * Calling conditions:
1185      *
1186      * - when `from` and `to` are both non-zero.
1187      * - `from` and `to` are never both zero.
1188      *
1189      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1190      */
1191     function _afterTokenTransfer(
1192         address from,
1193         address to,
1194         uint256 tokenId
1195     ) internal virtual {}
1196 }
1197 
1198 // File: contracts/0xPudgys.sol
1199 
1200 
1201 
1202 // Amended by 0xPudgysDev
1203 
1204 pragma solidity >=0.7.0 <0.9.0;
1205 
1206 
1207 
1208 
1209 contract OxPudgys is ERC721, Ownable {
1210   using Strings for uint256;
1211   using Counters for Counters.Counter;
1212 
1213   Counters.Counter private supply;
1214 
1215   string public uriPrefix = "";
1216   string public uriSuffix = ".json";
1217   string public hiddenMetadataUri;
1218   
1219   uint256 public cost = 0.002 ether;
1220   uint256 public maxSupply = 1112;
1221   uint256 public maxMintAmountPerTx = 10;
1222 
1223   bool public paused = true;
1224   bool public revealed = false;
1225 
1226   constructor() ERC721("0xPudgys", "0XP") {
1227     setHiddenMetadataUri("ipfs://QmeVzg2zhSXCfKJBi5dgrVVxp4JN4v3ydsWUSKpQKwjhP8/1.json");
1228   }
1229 
1230   modifier mintCompliance(uint256 _mintAmount) {
1231     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1232     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1233     _;
1234   }
1235 
1236   function totalSupply() public view returns (uint256) {
1237     return supply.current();
1238   }
1239 
1240   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1241     require(!paused, "The contract is paused!");
1242     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1243 
1244     _mintLoop(msg.sender, _mintAmount);
1245   }
1246   
1247   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1248     _mintLoop(_receiver, _mintAmount);
1249   }
1250 
1251   function walletOfOwner(address _owner)
1252     public
1253     view
1254     returns (uint256[] memory)
1255   {
1256     uint256 ownerTokenCount = balanceOf(_owner);
1257     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1258     uint256 currentTokenId = 1;
1259     uint256 ownedTokenIndex = 0;
1260 
1261     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1262       address currentTokenOwner = ownerOf(currentTokenId);
1263 
1264       if (currentTokenOwner == _owner) {
1265         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1266 
1267         ownedTokenIndex++;
1268       }
1269 
1270       currentTokenId++;
1271     }
1272 
1273     return ownedTokenIds;
1274   }
1275 
1276   function tokenURI(uint256 _tokenId)
1277     public
1278     view
1279     virtual
1280     override
1281     returns (string memory)
1282   {
1283     require(
1284       _exists(_tokenId),
1285       "ERC721Metadata: URI query for nonexistent token"
1286     );
1287 
1288     if (revealed == false) {
1289       return hiddenMetadataUri;
1290     }
1291 
1292     string memory currentBaseURI = _baseURI();
1293     return bytes(currentBaseURI).length > 0
1294         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1295         : "";
1296   }
1297 
1298   function setRevealed(bool _state) public onlyOwner {
1299     revealed = _state;
1300   }
1301 
1302   function setCost(uint256 _cost) public onlyOwner {
1303     cost = _cost;
1304   }
1305 
1306   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1307     maxMintAmountPerTx = _maxMintAmountPerTx;
1308   }
1309 
1310   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1311     hiddenMetadataUri = _hiddenMetadataUri;
1312   }
1313 
1314   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1315     uriPrefix = _uriPrefix;
1316   }
1317 
1318   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1319     uriSuffix = _uriSuffix;
1320   }
1321 
1322   function setPaused(bool _state) public onlyOwner {
1323     paused = _state;
1324   }
1325 
1326   function withdraw() public onlyOwner {
1327 
1328     // =============================================================================
1329     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1330     require(os);
1331     // =============================================================================
1332   }
1333 
1334   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1335     for (uint256 i = 0; i < _mintAmount; i++) {
1336       supply.increment();
1337       _safeMint(_receiver, supply.current());
1338     }
1339   }
1340 
1341   function _baseURI() internal view virtual override returns (string memory) {
1342     return uriPrefix;
1343   }
1344 }