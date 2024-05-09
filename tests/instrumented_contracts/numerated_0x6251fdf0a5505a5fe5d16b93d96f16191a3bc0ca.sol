1 /*
2 
3 ░░░░░▄▄▄▄▀▀▀▀▀▀▀▀▄▄▄▄▄▄░░░░░░░
4 ░░░░░█░░░░▒▒▒▒▒▒▒▒▒▒▒▒░░▀▀▄░░░░
5 ░░░░█░░░▒▒▒▒▒▒░░░░░░░░▒▒▒░░█░░░
6 ░░░█░░░░░░▄██▀▄▄░░░░░▄▄▄░░░░█░░
7 ░▄▀▒▄▄▄▒░█▀▀▀▀▄▄█░░░██▄▄█░░░░█░
8 █░▒█▒▄░▀▄▄▄▀░░░░░░░░█░░░▒▒▒▒▒░█
9 █░▒█░█▀▄▄░░░░░█▀░░░░▀▄░░▄▀▀▀▄▒█
10 ░█░▀▄░█▄░█▀▄▄░▀░▀▀░▄▄▀░░░░█░░█░
11 ░░█░░░▀▄▀█▄▄░█▀▀▀▄▄▄▄▀▀█▀██░█░░
12 ░░░█░░░░██░░▀█▄▄▄█▄▄█▄████░█░░░
13 ░░░░█░░░░▀▀▄░█░░░█░█▀██████░█░░
14 ░░░░░▀▄░░░░░▀▀▄▄▄█▄█▄█▄█▄▀░░█░░
15 ░░░░░░░▀▄▄░▒▒▒▒░░░░░░░░░░▒░░░█░
16 ░░░░░░░░░░▀▀▄▄░▒▒▒▒▒▒▒▒▒▒░░░░█░
17 ░░░░░░░░░░░░░░▀▄▄▄▄▄░░░░░░░░█░░
18 
19 */
20 
21 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
22 
23 // SPDX-License-Identifier: MIT
24 
25 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Contract module that helps prevent reentrant calls to a function.
31  *
32  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
33  * available, which can be applied to functions to make sure there are no nested
34  * (reentrant) calls to them.
35  *
36  * Note that because there is a single `nonReentrant` guard, functions marked as
37  * `nonReentrant` may not call one another. This can be worked around by making
38  * those functions `private`, and then adding `external` `nonReentrant` entry
39  * points to them.
40  *
41  * TIP: If you would like to learn more about reentrancy and alternative ways
42  * to protect against it, check out our blog post
43  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
44  */
45 abstract contract ReentrancyGuard {
46     // Booleans are more expensive than uint256 or any type that takes up a full
47     // word because each write operation emits an extra SLOAD to first read the
48     // slot's contents, replace the bits taken up by the boolean, and then write
49     // back. This is the compiler's defense against contract upgrades and
50     // pointer aliasing, and it cannot be disabled.
51 
52     // The values being non-zero value makes deployment a bit more expensive,
53     // but in exchange the refund on every call to nonReentrant will be lower in
54     // amount. Since refunds are capped to a percentage of the total
55     // transaction's gas, it is best to keep them low in cases like this one, to
56     // increase the likelihood of the full refund coming into effect.
57     uint256 private constant _NOT_ENTERED = 1;
58     uint256 private constant _ENTERED = 2;
59 
60     uint256 private _status;
61 
62     constructor() {
63         _status = _NOT_ENTERED;
64     }
65 
66     /**
67      * @dev Prevents a contract from calling itself, directly or indirectly.
68      * Calling a `nonReentrant` function from another `nonReentrant`
69      * function is not supported. It is possible to prevent this from happening
70      * by making the `nonReentrant` function external, and making it call a
71      * `private` function that does the actual work.
72      */
73     modifier nonReentrant() {
74         // On the first call to nonReentrant, _notEntered will be true
75         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
76 
77         // Any calls to nonReentrant after this point will fail
78         _status = _ENTERED;
79 
80         _;
81 
82         // By storing the original value once again, a refund is triggered (see
83         // https://eips.ethereum.org/EIPS/eip-2200)
84         _status = _NOT_ENTERED;
85     }
86 }
87 
88 // File: @openzeppelin/contracts/utils/Strings.sol
89 
90 
91 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev String operations.
97  */
98 library Strings {
99     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
103      */
104     function toString(uint256 value) internal pure returns (string memory) {
105         // Inspired by OraclizeAPI's implementation - MIT licence
106         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
107 
108         if (value == 0) {
109             return "0";
110         }
111         uint256 temp = value;
112         uint256 digits;
113         while (temp != 0) {
114             digits++;
115             temp /= 10;
116         }
117         bytes memory buffer = new bytes(digits);
118         while (value != 0) {
119             digits -= 1;
120             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
121             value /= 10;
122         }
123         return string(buffer);
124     }
125 
126     /**
127      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
128      */
129     function toHexString(uint256 value) internal pure returns (string memory) {
130         if (value == 0) {
131             return "0x00";
132         }
133         uint256 temp = value;
134         uint256 length = 0;
135         while (temp != 0) {
136             length++;
137             temp >>= 8;
138         }
139         return toHexString(value, length);
140     }
141 
142     /**
143      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
144      */
145     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
146         bytes memory buffer = new bytes(2 * length + 2);
147         buffer[0] = "0";
148         buffer[1] = "x";
149         for (uint256 i = 2 * length + 1; i > 1; --i) {
150             buffer[i] = _HEX_SYMBOLS[value & 0xf];
151             value >>= 4;
152         }
153         require(value == 0, "Strings: hex length insufficient");
154         return string(buffer);
155     }
156 }
157 
158 // File: @openzeppelin/contracts/utils/Context.sol
159 
160 
161 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
162 
163 pragma solidity ^0.8.0;
164 
165 /**
166  * @dev Provides information about the current execution context, including the
167  * sender of the transaction and its data. While these are generally available
168  * via msg.sender and msg.data, they should not be accessed in such a direct
169  * manner, since when dealing with meta-transactions the account sending and
170  * paying for execution may not be the actual sender (as far as an application
171  * is concerned).
172  *
173  * This contract is only required for intermediate, library-like contracts.
174  */
175 abstract contract Context {
176     function _msgSender() internal view virtual returns (address) {
177         return msg.sender;
178     }
179 
180     function _msgData() internal view virtual returns (bytes calldata) {
181         return msg.data;
182     }
183 }
184 
185 // File: @openzeppelin/contracts/access/Ownable.sol
186 
187 
188 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
189 
190 pragma solidity ^0.8.0;
191 
192 
193 /**
194  * @dev Contract module which provides a basic access control mechanism, where
195  * there is an account (an owner) that can be granted exclusive access to
196  * specific functions.
197  *
198  * By default, the owner account will be the one that deploys the contract. This
199  * can later be changed with {transferOwnership}.
200  *
201  * This module is used through inheritance. It will make available the modifier
202  * `onlyOwner`, which can be applied to your functions to restrict their use to
203  * the owner.
204  */
205 abstract contract Ownable is Context {
206     address private _owner;
207 
208     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
209 
210     /**
211      * @dev Initializes the contract setting the deployer as the initial owner.
212      */
213     constructor() {
214         _transferOwnership(_msgSender());
215     }
216 
217     /**
218      * @dev Returns the address of the current owner.
219      */
220     function owner() public view virtual returns (address) {
221         return _owner;
222     }
223 
224     /**
225      * @dev Throws if called by any account other than the owner.
226      */
227     modifier onlyOwner() {
228         require(owner() == _msgSender(), "Ownable: caller is not the owner");
229         _;
230     }
231 
232     /**
233      * @dev Leaves the contract without owner. It will not be possible to call
234      * `onlyOwner` functions anymore. Can only be called by the current owner.
235      *
236      * NOTE: Renouncing ownership will leave the contract without an owner,
237      * thereby removing any functionality that is only available to the owner.
238      */
239     function renounceOwnership() public virtual onlyOwner {
240         _transferOwnership(address(0));
241     }
242 
243     /**
244      * @dev Transfers ownership of the contract to a new account (`newOwner`).
245      * Can only be called by the current owner.
246      */
247     function transferOwnership(address newOwner) public virtual onlyOwner {
248         require(newOwner != address(0), "Ownable: new owner is the zero address");
249         _transferOwnership(newOwner);
250     }
251 
252     /**
253      * @dev Transfers ownership of the contract to a new account (`newOwner`).
254      * Internal function without access restriction.
255      */
256     function _transferOwnership(address newOwner) internal virtual {
257         address oldOwner = _owner;
258         _owner = newOwner;
259         emit OwnershipTransferred(oldOwner, newOwner);
260     }
261 }
262 
263 // File: @openzeppelin/contracts/utils/Address.sol
264 
265 
266 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
267 
268 pragma solidity ^0.8.1;
269 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274     /**
275      * @dev Returns true if `account` is a contract.
276      *
277      * [IMPORTANT]
278      * ====
279      * It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      *
282      * Among others, `isContract` will return false for the following
283      * types of addresses:
284      *
285      *  - an externally-owned account
286      *  - a contract in construction
287      *  - an address where a contract will be created
288      *  - an address where a contract lived, but was destroyed
289      * ====
290      *
291      * [IMPORTANT]
292      * ====
293      * You shouldn't rely on `isContract` to protect against flash loan attacks!
294      *
295      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
296      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
297      * constructor.
298      * ====
299      */
300     function isContract(address account) internal view returns (bool) {
301         // This method relies on extcodesize/address.code.length, which returns 0
302         // for contracts in construction, since the code is only stored at the end
303         // of the constructor execution.
304 
305         return account.code.length > 0;
306     }
307 
308     /**
309      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
310      * `recipient`, forwarding all available gas and reverting on errors.
311      *
312      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
313      * of certain opcodes, possibly making contracts go over the 2300 gas limit
314      * imposed by `transfer`, making them unable to receive funds via
315      * `transfer`. {sendValue} removes this limitation.
316      *
317      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
318      *
319      * IMPORTANT: because control is transferred to `recipient`, care must be
320      * taken to not create reentrancy vulnerabilities. Consider using
321      * {ReentrancyGuard} or the
322      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
323      */
324     function sendValue(address payable recipient, uint256 amount) internal {
325         require(address(this).balance >= amount, "Address: insufficient balance");
326 
327         (bool success, ) = recipient.call{value: amount}("");
328         require(success, "Address: unable to send value, recipient may have reverted");
329     }
330 
331     /**
332      * @dev Performs a Solidity function call using a low level `call`. A
333      * plain `call` is an unsafe replacement for a function call: use this
334      * function instead.
335      *
336      * If `target` reverts with a revert reason, it is bubbled up by this
337      * function (like regular Solidity function calls).
338      *
339      * Returns the raw returned data. To convert to the expected return value,
340      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
341      *
342      * Requirements:
343      *
344      * - `target` must be a contract.
345      * - calling `target` with `data` must not revert.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
350         return functionCall(target, data, "Address: low-level call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
355      * `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, 0, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but also transferring `value` wei to `target`.
370      *
371      * Requirements:
372      *
373      * - the calling contract must have an ETH balance of at least `value`.
374      * - the called Solidity function must be `payable`.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(
379         address target,
380         bytes memory data,
381         uint256 value
382     ) internal returns (bytes memory) {
383         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
388      * with `errorMessage` as a fallback revert reason when `target` reverts.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(
393         address target,
394         bytes memory data,
395         uint256 value,
396         string memory errorMessage
397     ) internal returns (bytes memory) {
398         require(address(this).balance >= value, "Address: insufficient balance for call");
399         require(isContract(target), "Address: call to non-contract");
400 
401         (bool success, bytes memory returndata) = target.call{value: value}(data);
402         return verifyCallResult(success, returndata, errorMessage);
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
407      * but performing a static call.
408      *
409      * _Available since v3.3._
410      */
411     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
412         return functionStaticCall(target, data, "Address: low-level static call failed");
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
417      * but performing a static call.
418      *
419      * _Available since v3.3._
420      */
421     function functionStaticCall(
422         address target,
423         bytes memory data,
424         string memory errorMessage
425     ) internal view returns (bytes memory) {
426         require(isContract(target), "Address: static call to non-contract");
427 
428         (bool success, bytes memory returndata) = target.staticcall(data);
429         return verifyCallResult(success, returndata, errorMessage);
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434      * but performing a delegate call.
435      *
436      * _Available since v3.4._
437      */
438     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
439         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
444      * but performing a delegate call.
445      *
446      * _Available since v3.4._
447      */
448     function functionDelegateCall(
449         address target,
450         bytes memory data,
451         string memory errorMessage
452     ) internal returns (bytes memory) {
453         require(isContract(target), "Address: delegate call to non-contract");
454 
455         (bool success, bytes memory returndata) = target.delegatecall(data);
456         return verifyCallResult(success, returndata, errorMessage);
457     }
458 
459     /**
460      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
461      * revert reason using the provided one.
462      *
463      * _Available since v4.3._
464      */
465     function verifyCallResult(
466         bool success,
467         bytes memory returndata,
468         string memory errorMessage
469     ) internal pure returns (bytes memory) {
470         if (success) {
471             return returndata;
472         } else {
473             // Look for revert reason and bubble it up if present
474             if (returndata.length > 0) {
475                 // The easiest way to bubble the revert reason is using memory via assembly
476 
477                 assembly {
478                     let returndata_size := mload(returndata)
479                     revert(add(32, returndata), returndata_size)
480                 }
481             } else {
482                 revert(errorMessage);
483             }
484         }
485     }
486 }
487 
488 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
489 
490 
491 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
492 
493 pragma solidity ^0.8.0;
494 
495 /**
496  * @title ERC721 token receiver interface
497  * @dev Interface for any contract that wants to support safeTransfers
498  * from ERC721 asset contracts.
499  */
500 interface IERC721Receiver {
501     /**
502      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
503      * by `operator` from `from`, this function is called.
504      *
505      * It must return its Solidity selector to confirm the token transfer.
506      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
507      *
508      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
509      */
510     function onERC721Received(
511         address operator,
512         address from,
513         uint256 tokenId,
514         bytes calldata data
515     ) external returns (bytes4);
516 }
517 
518 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
519 
520 
521 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
522 
523 pragma solidity ^0.8.0;
524 
525 /**
526  * @dev Interface of the ERC165 standard, as defined in the
527  * https://eips.ethereum.org/EIPS/eip-165[EIP].
528  *
529  * Implementers can declare support of contract interfaces, which can then be
530  * queried by others ({ERC165Checker}).
531  *
532  * For an implementation, see {ERC165}.
533  */
534 interface IERC165 {
535     /**
536      * @dev Returns true if this contract implements the interface defined by
537      * `interfaceId`. See the corresponding
538      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
539      * to learn more about how these ids are created.
540      *
541      * This function call must use less than 30 000 gas.
542      */
543     function supportsInterface(bytes4 interfaceId) external view returns (bool);
544 }
545 
546 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
547 
548 
549 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 
554 /**
555  * @dev Implementation of the {IERC165} interface.
556  *
557  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
558  * for the additional interface id that will be supported. For example:
559  *
560  * ```solidity
561  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
562  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
563  * }
564  * ```
565  *
566  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
567  */
568 abstract contract ERC165 is IERC165 {
569     /**
570      * @dev See {IERC165-supportsInterface}.
571      */
572     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
573         return interfaceId == type(IERC165).interfaceId;
574     }
575 }
576 
577 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
578 
579 
580 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
581 
582 pragma solidity ^0.8.0;
583 
584 
585 /**
586  * @dev Required interface of an ERC721 compliant contract.
587  */
588 interface IERC721 is IERC165 {
589     /**
590      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
591      */
592     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
593 
594     /**
595      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
596      */
597     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
598 
599     /**
600      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
601      */
602     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
603 
604     /**
605      * @dev Returns the number of tokens in ``owner``'s account.
606      */
607     function balanceOf(address owner) external view returns (uint256 balance);
608 
609     /**
610      * @dev Returns the owner of the `tokenId` token.
611      *
612      * Requirements:
613      *
614      * - `tokenId` must exist.
615      */
616     function ownerOf(uint256 tokenId) external view returns (address owner);
617 
618     /**
619      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
620      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
621      *
622      * Requirements:
623      *
624      * - `from` cannot be the zero address.
625      * - `to` cannot be the zero address.
626      * - `tokenId` token must exist and be owned by `from`.
627      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
628      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
629      *
630      * Emits a {Transfer} event.
631      */
632     function safeTransferFrom(
633         address from,
634         address to,
635         uint256 tokenId
636     ) external;
637 
638     /**
639      * @dev Transfers `tokenId` token from `from` to `to`.
640      *
641      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
642      *
643      * Requirements:
644      *
645      * - `from` cannot be the zero address.
646      * - `to` cannot be the zero address.
647      * - `tokenId` token must be owned by `from`.
648      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
649      *
650      * Emits a {Transfer} event.
651      */
652     function transferFrom(
653         address from,
654         address to,
655         uint256 tokenId
656     ) external;
657 
658     /**
659      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
660      * The approval is cleared when the token is transferred.
661      *
662      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
663      *
664      * Requirements:
665      *
666      * - The caller must own the token or be an approved operator.
667      * - `tokenId` must exist.
668      *
669      * Emits an {Approval} event.
670      */
671     function approve(address to, uint256 tokenId) external;
672 
673     /**
674      * @dev Returns the account approved for `tokenId` token.
675      *
676      * Requirements:
677      *
678      * - `tokenId` must exist.
679      */
680     function getApproved(uint256 tokenId) external view returns (address operator);
681 
682     /**
683      * @dev Approve or remove `operator` as an operator for the caller.
684      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
685      *
686      * Requirements:
687      *
688      * - The `operator` cannot be the caller.
689      *
690      * Emits an {ApprovalForAll} event.
691      */
692     function setApprovalForAll(address operator, bool _approved) external;
693 
694     /**
695      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
696      *
697      * See {setApprovalForAll}
698      */
699     function isApprovedForAll(address owner, address operator) external view returns (bool);
700 
701     /**
702      * @dev Safely transfers `tokenId` token from `from` to `to`.
703      *
704      * Requirements:
705      *
706      * - `from` cannot be the zero address.
707      * - `to` cannot be the zero address.
708      * - `tokenId` token must exist and be owned by `from`.
709      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
710      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
711      *
712      * Emits a {Transfer} event.
713      */
714     function safeTransferFrom(
715         address from,
716         address to,
717         uint256 tokenId,
718         bytes calldata data
719     ) external;
720 }
721 
722 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
723 
724 
725 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
726 
727 pragma solidity ^0.8.0;
728 
729 
730 /**
731  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
732  * @dev See https://eips.ethereum.org/EIPS/eip-721
733  */
734 interface IERC721Metadata is IERC721 {
735     /**
736      * @dev Returns the token collection name.
737      */
738     function name() external view returns (string memory);
739 
740     /**
741      * @dev Returns the token collection symbol.
742      */
743     function symbol() external view returns (string memory);
744 
745     /**
746      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
747      */
748     function tokenURI(uint256 tokenId) external view returns (string memory);
749 }
750 
751 // File: contracts/ERC721A.sol
752 
753 
754 // Creator: Chiru Labs
755 
756 pragma solidity ^0.8.4;
757 
758 
759 
760 
761 
762 
763 
764 
765 error ApprovalCallerNotOwnerNorApproved();
766 error ApprovalQueryForNonexistentToken();
767 error ApproveToCaller();
768 error ApprovalToCurrentOwner();
769 error BalanceQueryForZeroAddress();
770 error MintToZeroAddress();
771 error MintZeroQuantity();
772 error OwnerQueryForNonexistentToken();
773 error TransferCallerNotOwnerNorApproved();
774 error TransferFromIncorrectOwner();
775 error TransferToNonERC721ReceiverImplementer();
776 error TransferToZeroAddress();
777 error URIQueryForNonexistentToken();
778 
779 /**
780  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
781  * the Metadata extension. Built to optimize for lower gas during batch mints.
782  *
783  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
784  *
785  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
786  *
787  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
788  */
789 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
790     using Address for address;
791     using Strings for uint256;
792 
793     // Compiler will pack this into a single 256bit word.
794     struct TokenOwnership {
795         // The address of the owner.
796         address addr;
797         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
798         uint64 startTimestamp;
799         // Whether the token has been burned.
800         bool burned;
801     }
802 
803     // Compiler will pack this into a single 256bit word.
804     struct AddressData {
805         // Realistically, 2**64-1 is more than enough.
806         uint64 balance;
807         // Keeps track of mint count with minimal overhead for tokenomics.
808         uint64 numberMinted;
809         // Keeps track of burn count with minimal overhead for tokenomics.
810         uint64 numberBurned;
811         // For miscellaneous variable(s) pertaining to the address
812         // (e.g. number of whitelist mint slots used).
813         // If there are multiple variables, please pack them into a uint64.
814         uint64 aux;
815     }
816 
817     // The tokenId of the next token to be minted.
818     uint256 internal _currentIndex;
819 
820     // The number of tokens burned.
821     uint256 internal _burnCounter;
822 
823     // Token name
824     string private _name;
825 
826     // Token symbol
827     string private _symbol;
828 
829     // Mapping from token ID to ownership details
830     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
831     mapping(uint256 => TokenOwnership) internal _ownerships;
832 
833     // Mapping owner address to address data
834     mapping(address => AddressData) private _addressData;
835 
836     // Mapping from token ID to approved address
837     mapping(uint256 => address) private _tokenApprovals;
838 
839     // Mapping from owner to operator approvals
840     mapping(address => mapping(address => bool)) private _operatorApprovals;
841 
842     constructor(string memory name_, string memory symbol_) {
843         _name = name_;
844         _symbol = symbol_;
845         _currentIndex = _startTokenId();
846     }
847 
848     /**
849      * To change the starting tokenId, please override this function.
850      */
851     function _startTokenId() internal view virtual returns (uint256) {
852         return 1;
853     }
854 
855     /**
856      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
857      */
858     function totalSupply() public view returns (uint256) {
859         // Counter underflow is impossible as _burnCounter cannot be incremented
860         // more than _currentIndex - _startTokenId() times
861         unchecked {
862             return _currentIndex - _burnCounter - _startTokenId();
863         }
864     }
865 
866     /**
867      * Returns the total amount of tokens minted in the contract.
868      */
869     function _totalMinted() internal view returns (uint256) {
870         // Counter underflow is impossible as _currentIndex does not decrement,
871         // and it is initialized to _startTokenId()
872         unchecked {
873             return _currentIndex - _startTokenId();
874         }
875     }
876 
877     /**
878      * @dev See {IERC165-supportsInterface}.
879      */
880     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
881         return
882             interfaceId == type(IERC721).interfaceId ||
883             interfaceId == type(IERC721Metadata).interfaceId ||
884             super.supportsInterface(interfaceId);
885     }
886 
887     /**
888      * @dev See {IERC721-balanceOf}.
889      */
890     function balanceOf(address owner) public view override returns (uint256) {
891         if (owner == address(0)) revert BalanceQueryForZeroAddress();
892         return uint256(_addressData[owner].balance);
893     }
894 
895     /**
896      * Returns the number of tokens minted by `owner`.
897      */
898     function _numberMinted(address owner) internal view returns (uint256) {
899         return uint256(_addressData[owner].numberMinted);
900     }
901 
902     /**
903      * Returns the number of tokens burned by or on behalf of `owner`.
904      */
905     function _numberBurned(address owner) internal view returns (uint256) {
906         return uint256(_addressData[owner].numberBurned);
907     }
908 
909     /**
910      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
911      */
912     function _getAux(address owner) internal view returns (uint64) {
913         return _addressData[owner].aux;
914     }
915 
916     /**
917      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
918      * If there are multiple variables, please pack them into a uint64.
919      */
920     function _setAux(address owner, uint64 aux) internal {
921         _addressData[owner].aux = aux;
922     }
923 
924     /**
925      * Gas spent here starts off proportional to the maximum mint batch size.
926      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
927      */
928     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
929         uint256 curr = tokenId;
930 
931         unchecked {
932             if (_startTokenId() <= curr && curr < _currentIndex) {
933                 TokenOwnership memory ownership = _ownerships[curr];
934                 if (!ownership.burned) {
935                     if (ownership.addr != address(0)) {
936                         return ownership;
937                     }
938                     // Invariant:
939                     // There will always be an ownership that has an address and is not burned
940                     // before an ownership that does not have an address and is not burned.
941                     // Hence, curr will not underflow.
942                     while (true) {
943                         curr--;
944                         ownership = _ownerships[curr];
945                         if (ownership.addr != address(0)) {
946                             return ownership;
947                         }
948                     }
949                 }
950             }
951         }
952         revert OwnerQueryForNonexistentToken();
953     }
954 
955     /**
956      * @dev See {IERC721-ownerOf}.
957      */
958     function ownerOf(uint256 tokenId) public view override returns (address) {
959         return _ownershipOf(tokenId).addr;
960     }
961 
962     /**
963      * @dev See {IERC721Metadata-name}.
964      */
965     function name() public view virtual override returns (string memory) {
966         return _name;
967     }
968 
969     /**
970      * @dev See {IERC721Metadata-symbol}.
971      */
972     function symbol() public view virtual override returns (string memory) {
973         return _symbol;
974     }
975 
976     /**
977      * @dev See {IERC721Metadata-tokenURI}.
978      */
979     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
980         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
981 
982         string memory baseURI = _baseURI();
983         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
984     }
985 
986     /**
987      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
988      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
989      * by default, can be overriden in child contracts.
990      */
991     function _baseURI() internal view virtual returns (string memory) {
992         return '';
993     }
994 
995     /**
996      * @dev See {IERC721-approve}.
997      */
998     function approve(address to, uint256 tokenId) public override {
999         address owner = ERC721A.ownerOf(tokenId);
1000         if (to == owner) revert ApprovalToCurrentOwner();
1001 
1002         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1003             revert ApprovalCallerNotOwnerNorApproved();
1004         }
1005 
1006         _approve(to, tokenId, owner);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-getApproved}.
1011      */
1012     function getApproved(uint256 tokenId) public view override returns (address) {
1013         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1014 
1015         return _tokenApprovals[tokenId];
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-setApprovalForAll}.
1020      */
1021     function setApprovalForAll(address operator, bool approved) public virtual override {
1022         if (operator == _msgSender()) revert ApproveToCaller();
1023 
1024         _operatorApprovals[_msgSender()][operator] = approved;
1025         emit ApprovalForAll(_msgSender(), operator, approved);
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-isApprovedForAll}.
1030      */
1031     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1032         return _operatorApprovals[owner][operator];
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-transferFrom}.
1037      */
1038     function transferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) public virtual override {
1043         _transfer(from, to, tokenId);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-safeTransferFrom}.
1048      */
1049     function safeTransferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) public virtual override {
1054         safeTransferFrom(from, to, tokenId, '');
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-safeTransferFrom}.
1059      */
1060     function safeTransferFrom(
1061         address from,
1062         address to,
1063         uint256 tokenId,
1064         bytes memory _data
1065     ) public virtual override {
1066         _transfer(from, to, tokenId);
1067         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1068             revert TransferToNonERC721ReceiverImplementer();
1069         }
1070     }
1071 
1072     /**
1073      * @dev Returns whether `tokenId` exists.
1074      *
1075      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1076      *
1077      * Tokens start existing when they are minted (`_mint`),
1078      */
1079     function _exists(uint256 tokenId) internal view returns (bool) {
1080         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1081     }
1082 
1083     /**
1084      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1085      */
1086     function _safeMint(address to, uint256 quantity) internal {
1087         _safeMint(to, quantity, '');
1088     }
1089 
1090     /**
1091      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1092      *
1093      * Requirements:
1094      *
1095      * - If `to` refers to a smart contract, it must implement 
1096      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1097      * - `quantity` must be greater than 0.
1098      *
1099      * Emits a {Transfer} event.
1100      */
1101     function _safeMint(
1102         address to,
1103         uint256 quantity,
1104         bytes memory _data
1105     ) internal {
1106         uint256 startTokenId = _currentIndex;
1107         if (to == address(0)) revert MintToZeroAddress();
1108         if (quantity == 0) revert MintZeroQuantity();
1109 
1110         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1111 
1112         // Overflows are incredibly unrealistic.
1113         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1114         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1115         unchecked {
1116             _addressData[to].balance += uint64(quantity);
1117             _addressData[to].numberMinted += uint64(quantity);
1118 
1119             _ownerships[startTokenId].addr = to;
1120             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1121 
1122             uint256 updatedIndex = startTokenId;
1123             uint256 end = updatedIndex + quantity;
1124 
1125             if (to.isContract()) {
1126                 do {
1127                     emit Transfer(address(0), to, updatedIndex);
1128                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1129                         revert TransferToNonERC721ReceiverImplementer();
1130                     }
1131                 } while (updatedIndex != end);
1132                 // Reentrancy protection
1133                 if (_currentIndex != startTokenId) revert();
1134             } else {
1135                 do {
1136                     emit Transfer(address(0), to, updatedIndex++);
1137                 } while (updatedIndex != end);
1138             }
1139             _currentIndex = updatedIndex;
1140         }
1141         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1142     }
1143 
1144     /**
1145      * @dev Mints `quantity` tokens and transfers them to `to`.
1146      *
1147      * Requirements:
1148      *
1149      * - `to` cannot be the zero address.
1150      * - `quantity` must be greater than 0.
1151      *
1152      * Emits a {Transfer} event.
1153      */
1154     function _mint(address to, uint256 quantity) internal {
1155         uint256 startTokenId = _currentIndex;
1156         if (to == address(0)) revert MintToZeroAddress();
1157         if (quantity == 0) revert MintZeroQuantity();
1158 
1159         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1160 
1161         // Overflows are incredibly unrealistic.
1162         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1163         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1164         unchecked {
1165             _addressData[to].balance += uint64(quantity);
1166             _addressData[to].numberMinted += uint64(quantity);
1167 
1168             _ownerships[startTokenId].addr = to;
1169             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1170 
1171             uint256 updatedIndex = startTokenId;
1172             uint256 end = updatedIndex + quantity;
1173 
1174             do {
1175                 emit Transfer(address(0), to, updatedIndex++);
1176             } while (updatedIndex != end);
1177 
1178             _currentIndex = updatedIndex;
1179         }
1180         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1181     }
1182 
1183     /**
1184      * @dev Transfers `tokenId` from `from` to `to`.
1185      *
1186      * Requirements:
1187      *
1188      * - `to` cannot be the zero address.
1189      * - `tokenId` token must be owned by `from`.
1190      *
1191      * Emits a {Transfer} event.
1192      */
1193     function _transfer(
1194         address from,
1195         address to,
1196         uint256 tokenId
1197     ) private {
1198         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1199 
1200         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1201 
1202         bool isApprovedOrOwner = (_msgSender() == from ||
1203             isApprovedForAll(from, _msgSender()) ||
1204             getApproved(tokenId) == _msgSender());
1205 
1206         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1207         if (to == address(0)) revert TransferToZeroAddress();
1208 
1209         _beforeTokenTransfers(from, to, tokenId, 1);
1210 
1211         // Clear approvals from the previous owner
1212         _approve(address(0), tokenId, from);
1213 
1214         // Underflow of the sender's balance is impossible because we check for
1215         // ownership above and the recipient's balance can't realistically overflow.
1216         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1217         unchecked {
1218             _addressData[from].balance -= 1;
1219             _addressData[to].balance += 1;
1220 
1221             TokenOwnership storage currSlot = _ownerships[tokenId];
1222             currSlot.addr = to;
1223             currSlot.startTimestamp = uint64(block.timestamp);
1224 
1225             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1226             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1227             uint256 nextTokenId = tokenId + 1;
1228             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1229             if (nextSlot.addr == address(0)) {
1230                 // This will suffice for checking _exists(nextTokenId),
1231                 // as a burned slot cannot contain the zero address.
1232                 if (nextTokenId != _currentIndex) {
1233                     nextSlot.addr = from;
1234                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1235                 }
1236             }
1237         }
1238 
1239         emit Transfer(from, to, tokenId);
1240         _afterTokenTransfers(from, to, tokenId, 1);
1241     }
1242 
1243     /**
1244      * @dev Equivalent to `_burn(tokenId, false)`.
1245      */
1246     function _burn(uint256 tokenId) internal virtual {
1247         _burn(tokenId, false);
1248     }
1249 
1250     /**
1251      * @dev Destroys `tokenId`.
1252      * The approval is cleared when the token is burned.
1253      *
1254      * Requirements:
1255      *
1256      * - `tokenId` must exist.
1257      *
1258      * Emits a {Transfer} event.
1259      */
1260     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1261         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1262 
1263         address from = prevOwnership.addr;
1264 
1265         if (approvalCheck) {
1266             bool isApprovedOrOwner = (_msgSender() == from ||
1267                 isApprovedForAll(from, _msgSender()) ||
1268                 getApproved(tokenId) == _msgSender());
1269 
1270             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1271         }
1272 
1273         _beforeTokenTransfers(from, address(0), tokenId, 1);
1274 
1275         // Clear approvals from the previous owner
1276         _approve(address(0), tokenId, from);
1277 
1278         // Underflow of the sender's balance is impossible because we check for
1279         // ownership above and the recipient's balance can't realistically overflow.
1280         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1281         unchecked {
1282             AddressData storage addressData = _addressData[from];
1283             addressData.balance -= 1;
1284             addressData.numberBurned += 1;
1285 
1286             // Keep track of who burned the token, and the timestamp of burning.
1287             TokenOwnership storage currSlot = _ownerships[tokenId];
1288             currSlot.addr = from;
1289             currSlot.startTimestamp = uint64(block.timestamp);
1290             currSlot.burned = true;
1291 
1292             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1293             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1294             uint256 nextTokenId = tokenId + 1;
1295             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1296             if (nextSlot.addr == address(0)) {
1297                 // This will suffice for checking _exists(nextTokenId),
1298                 // as a burned slot cannot contain the zero address.
1299                 if (nextTokenId != _currentIndex) {
1300                     nextSlot.addr = from;
1301                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1302                 }
1303             }
1304         }
1305 
1306         emit Transfer(from, address(0), tokenId);
1307         _afterTokenTransfers(from, address(0), tokenId, 1);
1308 
1309         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1310         unchecked {
1311             _burnCounter++;
1312         }
1313     }
1314 
1315     /**
1316      * @dev Approve `to` to operate on `tokenId`
1317      *
1318      * Emits a {Approval} event.
1319      */
1320     function _approve(
1321         address to,
1322         uint256 tokenId,
1323         address owner
1324     ) private {
1325         _tokenApprovals[tokenId] = to;
1326         emit Approval(owner, to, tokenId);
1327     }
1328 
1329     /**
1330      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1331      *
1332      * @param from address representing the previous owner of the given token ID
1333      * @param to target address that will receive the tokens
1334      * @param tokenId uint256 ID of the token to be transferred
1335      * @param _data bytes optional data to send along with the call
1336      * @return bool whether the call correctly returned the expected magic value
1337      */
1338     function _checkContractOnERC721Received(
1339         address from,
1340         address to,
1341         uint256 tokenId,
1342         bytes memory _data
1343     ) private returns (bool) {
1344         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1345             return retval == IERC721Receiver(to).onERC721Received.selector;
1346         } catch (bytes memory reason) {
1347             if (reason.length == 0) {
1348                 revert TransferToNonERC721ReceiverImplementer();
1349             } else {
1350                 assembly {
1351                     revert(add(32, reason), mload(reason))
1352                 }
1353             }
1354         }
1355     }
1356 
1357     /**
1358      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1359      * And also called before burning one token.
1360      *
1361      * startTokenId - the first token id to be transferred
1362      * quantity - the amount to be transferred
1363      *
1364      * Calling conditions:
1365      *
1366      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1367      * transferred to `to`.
1368      * - When `from` is zero, `tokenId` will be minted for `to`.
1369      * - When `to` is zero, `tokenId` will be burned by `from`.
1370      * - `from` and `to` are never both zero.
1371      */
1372     function _beforeTokenTransfers(
1373         address from,
1374         address to,
1375         uint256 startTokenId,
1376         uint256 quantity
1377     ) internal virtual {}
1378 
1379     /**
1380      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1381      * minting.
1382      * And also called after one token has been burned.
1383      *
1384      * startTokenId - the first token id to be transferred
1385      * quantity - the amount to be transferred
1386      *
1387      * Calling conditions:
1388      *
1389      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1390      * transferred to `to`.
1391      * - When `from` is zero, `tokenId` has been minted for `to`.
1392      * - When `to` is zero, `tokenId` has been burned by `from`.
1393      * - `from` and `to` are never both zero.
1394      */
1395     function _afterTokenTransfers(
1396         address from,
1397         address to,
1398         uint256 startTokenId,
1399         uint256 quantity
1400     ) internal virtual {}
1401 }
1402 
1403 
1404 
1405 pragma solidity ^0.8.0;
1406 
1407 
1408 
1409 
1410 
1411 contract memesailorsxyz is ERC721A, Ownable, ReentrancyGuard {
1412   using Address for address;
1413   using Strings for uint;
1414 
1415 
1416   string  public  baseTokenURI = "";
1417   uint256 public  maxSupply = 3333;
1418   uint256 public  MAX_MINTS_PER_TX = 2;
1419   uint256 public  PUBLIC_SALE_PRICE = 0.005 ether;
1420   uint256 public  NUM_FREE_MINTS = 3333;
1421   uint256 public  MAX_FREE_PER_WALLET = 10;
1422   uint256 public freeNFTAlreadyMinted = 0;
1423   bool public isPublicSaleActive = false;
1424 
1425   constructor(
1426 
1427   ) ERC721A("memesailorsxyz", "SAILOR") {
1428 
1429   }
1430 
1431 
1432   function mint(uint256 numberOfTokens)
1433       external
1434       payable
1435   {
1436     require(isPublicSaleActive, "Public sale is not open");
1437     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1438 
1439     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1440         require(
1441             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1442             "Incorrect ETH value sent"
1443         );
1444     } else {
1445         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1446         require(
1447             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1448             "Incorrect ETH value sent"
1449         );
1450         require(
1451             numberOfTokens <= MAX_MINTS_PER_TX,
1452             "Max mints per transaction exceeded"
1453         );
1454         } else {
1455             require(
1456                 numberOfTokens <= MAX_FREE_PER_WALLET,
1457                 "Max mints per transaction exceeded"
1458             );
1459             freeNFTAlreadyMinted += numberOfTokens;
1460         }
1461     }
1462     _safeMint(msg.sender, numberOfTokens);
1463   }
1464 
1465   function setBaseURI(string memory baseURI)
1466     public
1467     onlyOwner
1468   {
1469     baseTokenURI = baseURI;
1470   }
1471 
1472   function treasuryMint(uint quantity)
1473     public
1474     onlyOwner
1475   {
1476     require(
1477       quantity > 0,
1478       "Invalid mint amount"
1479     );
1480     require(
1481       totalSupply() + quantity <= maxSupply,
1482       "Maximum supply exceeded"
1483     );
1484     _safeMint(msg.sender, quantity);
1485   }
1486 
1487   function withdraw()
1488     public
1489     onlyOwner
1490     nonReentrant
1491   {
1492     Address.sendValue(payable(msg.sender), address(this).balance);
1493   }
1494 
1495   function tokenURI(uint _tokenId)
1496     public
1497     view
1498     virtual
1499     override
1500     returns (string memory)
1501   {
1502     require(
1503       _exists(_tokenId),
1504       "ERC721Metadata: URI query for nonexistent token"
1505     );
1506     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1507   }
1508 
1509   function _baseURI()
1510     internal
1511     view
1512     virtual
1513     override
1514     returns (string memory)
1515   {
1516     return baseTokenURI;
1517   }
1518 
1519   function setIsPublicSaleActive(bool _isPublicSaleActive)
1520       external
1521       onlyOwner
1522   {
1523       isPublicSaleActive = _isPublicSaleActive;
1524   }
1525 
1526   function setNumFreeMints(uint256 _numfreemints)
1527       external
1528       onlyOwner
1529   {
1530       NUM_FREE_MINTS = _numfreemints;
1531   }
1532 
1533   function setSalePrice(uint256 _price)
1534       external
1535       onlyOwner
1536   {
1537       PUBLIC_SALE_PRICE = _price;
1538   }
1539 
1540   function setMaxLimitPerTransaction(uint256 _limit)
1541       external
1542       onlyOwner
1543   {
1544       MAX_MINTS_PER_TX = _limit;
1545   }
1546 
1547   function setFreeLimitPerWallet(uint256 _limit)
1548       external
1549       onlyOwner
1550   {
1551       MAX_FREE_PER_WALLET = _limit;
1552   }
1553 }