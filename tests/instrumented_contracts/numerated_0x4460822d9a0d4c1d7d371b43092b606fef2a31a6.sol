1 /**
2 */
3 
4 /**
5 
6 
7 $$$$$$$$\ $$\                        $$$$$$\             $$\            $$$$$$\   $$$$$$\        $$\      $$\            $$\     $$\                                          $$\     $$\                     
8 \__$$  __|$$ |                      $$  __$$\            $$ |          $$  __$$\ $$  __$$\       $$$\    $$$ |           $$ |    $$ |                                         $$ |    \__|                    
9    $$ |   $$$$$$$\   $$$$$$\        $$ /  $$ | $$$$$$\ $$$$$$\         $$ /  $$ |$$ /  \__|      $$$$\  $$$$ | $$$$$$\ $$$$$$\   $$$$$$$\   $$$$$$\  $$$$$$\$$$$\   $$$$$$\ $$$$$$\   $$\  $$$$$$$\  $$$$$$$\ 
10    $$ |   $$  __$$\ $$  __$$\       $$$$$$$$ |$$  __$$\\_$$  _|        $$ |  $$ |$$$$\           $$\$$\$$ $$ | \____$$\\_$$  _|  $$  __$$\ $$  __$$\ $$  _$$  _$$\  \____$$\\_$$  _|  $$ |$$  _____|$$  _____|
11    $$ |   $$ |  $$ |$$$$$$$$ |      $$  __$$ |$$ |  \__| $$ |          $$ |  $$ |$$  _|          $$ \$$$  $$ | $$$$$$$ | $$ |    $$ |  $$ |$$$$$$$$ |$$ / $$ / $$ | $$$$$$$ | $$ |    $$ |$$ /      \$$$$$$\  
12    $$ |   $$ |  $$ |$$   ____|      $$ |  $$ |$$ |       $$ |$$\       $$ |  $$ |$$ |            $$ |\$  /$$ |$$  __$$ | $$ |$$\ $$ |  $$ |$$   ____|$$ | $$ | $$ |$$  __$$ | $$ |$$\ $$ |$$ |       \____$$\ 
13    $$ |   $$ |  $$ |\$$$$$$$\       $$ |  $$ |$$ |       \$$$$  |       $$$$$$  |$$ |            $$ | \_/ $$ |\$$$$$$$ | \$$$$  |$$ |  $$ |\$$$$$$$\ $$ | $$ | $$ |\$$$$$$$ | \$$$$  |$$ |\$$$$$$$\ $$$$$$$  |
14    \__|   \__|  \__| \_______|      \__|  \__|\__|        \____/        \______/ \__|            \__|     \__| \_______|  \____/ \__|  \__| \_______|\__| \__| \__| \_______|  \____/ \__| \_______|\_______/ 
15                                                                                                                                                                                                               
16                                                                                                                                                                                                               
17                                                                                                                                                                                                               
18 
19                                                                                                                            
20 
21 */
22 
23 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
24 
25 // SPDX-License-Identifier: MIT
26 
27 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Contract module that helps prevent reentrant calls to a function.
33  *
34  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
35  * available, which can be applied to functions to make sure there are no nested
36  * (reentrant) calls to them.
37  *
38  * Note that because there is a single `nonReentrant` guard, functions marked as
39  * `nonReentrant` may not call one another. This can be worked around by making
40  * those functions `private`, and then adding `external` `nonReentrant` entry
41  * points to them.
42  *
43  * TIP: If you would like to learn more about reentrancy and alternative ways
44  * to protect against it, check out our blog post
45  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
46  */
47 abstract contract ReentrancyGuard {
48     // Booleans are more expensive than uint256 or any type that takes up a full
49     // word because each write operation emits an extra SLOAD to first read the
50     // slot's contents, replace the bits taken up by the boolean, and then write
51     // back. This is the compiler's defense against contract upgrades and
52     // pointer aliasing, and it cannot be disabled.
53 
54     // The values being non-zero value makes deployment a bit more expensive,
55     // but in exchange the refund on every call to nonReentrant will be lower in
56     // amount. Since refunds are capped to a percentage of the total
57     // transaction's gas, it is best to keep them low in cases like this one, to
58     // increase the likelihood of the full refund coming into effect.
59     uint256 private constant _NOT_ENTERED = 1;
60     uint256 private constant _ENTERED = 2;
61 
62     uint256 private _status;
63 
64     constructor() {
65         _status = _NOT_ENTERED;
66     }
67 
68     /**
69      * @dev Prevents a contract from calling itself, directly or indirectly.
70      * Calling a `nonReentrant` function from another `nonReentrant`
71      * function is not supported. It is possible to prevent this from happening
72      * by making the `nonReentrant` function external, and making it call a
73      * `private` function that does the actual work.
74      */
75     modifier nonReentrant() {
76         // On the first call to nonReentrant, _notEntered will be true
77         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
78 
79         // Any calls to nonReentrant after this point will fail
80         _status = _ENTERED;
81 
82         _;
83 
84         // By storing the original value once again, a refund is triggered (see
85         // https://eips.ethereum.org/EIPS/eip-2200)
86         _status = _NOT_ENTERED;
87     }
88 }
89 
90 // File: @openzeppelin/contracts/utils/Strings.sol
91 
92 
93 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev String operations.
99  */
100 library Strings {
101     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
105      */
106     function toString(uint256 value) internal pure returns (string memory) {
107         // Inspired by OraclizeAPI's implementation - MIT licence
108         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
109 
110         if (value == 0) {
111             return "0";
112         }
113         uint256 temp = value;
114         uint256 digits;
115         while (temp != 0) {
116             digits++;
117             temp /= 10;
118         }
119         bytes memory buffer = new bytes(digits);
120         while (value != 0) {
121             digits -= 1;
122             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
123             value /= 10;
124         }
125         return string(buffer);
126     }
127 
128     /**
129      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
130      */
131     function toHexString(uint256 value) internal pure returns (string memory) {
132         if (value == 0) {
133             return "0x00";
134         }
135         uint256 temp = value;
136         uint256 length = 0;
137         while (temp != 0) {
138             length++;
139             temp >>= 8;
140         }
141         return toHexString(value, length);
142     }
143 
144     /**
145      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
146      */
147     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
148         bytes memory buffer = new bytes(2 * length + 2);
149         buffer[0] = "0";
150         buffer[1] = "x";
151         for (uint256 i = 2 * length + 1; i > 1; --i) {
152             buffer[i] = _HEX_SYMBOLS[value & 0xf];
153             value >>= 4;
154         }
155         require(value == 0, "Strings: hex length insufficient");
156         return string(buffer);
157     }
158 }
159 
160 // File: @openzeppelin/contracts/utils/Context.sol
161 
162 
163 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
164 
165 pragma solidity ^0.8.0;
166 
167 /**
168  * @dev Provides information about the current execution context, including the
169  * sender of the transaction and its data. While these are generally available
170  * via msg.sender and msg.data, they should not be accessed in such a direct
171  * manner, since when dealing with meta-transactions the account sending and
172  * paying for execution may not be the actual sender (as far as an application
173  * is concerned).
174  *
175  * This contract is only required for intermediate, library-like contracts.
176  */
177 abstract contract Context {
178     function _msgSender() internal view virtual returns (address) {
179         return msg.sender;
180     }
181 
182     function _msgData() internal view virtual returns (bytes calldata) {
183         return msg.data;
184     }
185 }
186 
187 // File: @openzeppelin/contracts/access/Ownable.sol
188 
189 
190 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
191 
192 pragma solidity ^0.8.0;
193 
194 
195 /**
196  * @dev Contract module which provides a basic access control mechanism, where
197  * there is an account (an owner) that can be granted exclusive access to
198  * specific functions.
199  *
200  * By default, the owner account will be the one that deploys the contract. This
201  * can later be changed with {transferOwnership}.
202  *
203  * This module is used through inheritance. It will make available the modifier
204  * `onlyOwner`, which can be applied to your functions to restrict their use to
205  * the owner.
206  */
207 abstract contract Ownable is Context {
208     address private _owner;
209 
210     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
211 
212     /**
213      * @dev Initializes the contract setting the deployer as the initial owner.
214      */
215     constructor() {
216         _transferOwnership(_msgSender());
217     }
218 
219     /**
220      * @dev Returns the address of the current owner.
221      */
222     function owner() public view virtual returns (address) {
223         return _owner;
224     }
225 
226     /**
227      * @dev Throws if called by any account other than the owner.
228      */
229     modifier onlyOwner() {
230         require(owner() == _msgSender(), "Ownable: caller is not the owner");
231         _;
232     }
233 
234     /**
235      * @dev Leaves the contract without owner. It will not be possible to call
236      * `onlyOwner` functions anymore. Can only be called by the current owner.
237      *
238      * NOTE: Renouncing ownership will leave the contract without an owner,
239      * thereby removing any functionality that is only available to the owner.
240      */
241     function renounceOwnership() public virtual onlyOwner {
242         _transferOwnership(address(0));
243     }
244 
245     /**
246      * @dev Transfers ownership of the contract to a new account (`newOwner`).
247      * Can only be called by the current owner.
248      */
249     function transferOwnership(address newOwner) public virtual onlyOwner {
250         require(newOwner != address(0), "Ownable: new owner is the zero address");
251         _transferOwnership(newOwner);
252     }
253 
254     /**
255      * @dev Transfers ownership of the contract to a new account (`newOwner`).
256      * Internal function without access restriction.
257      */
258     function _transferOwnership(address newOwner) internal virtual {
259         address oldOwner = _owner;
260         _owner = newOwner;
261         emit OwnershipTransferred(oldOwner, newOwner);
262     }
263 }
264 
265 // File: @openzeppelin/contracts/utils/Address.sol
266 
267 
268 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
269 
270 pragma solidity ^0.8.1;
271 
272 /**
273  * @dev Collection of functions related to the address type
274  */
275 library Address {
276     /**
277      * @dev Returns true if `account` is a contract.
278      *
279      * [IMPORTANT]
280      * ====
281      * It is unsafe to assume that an address for which this function returns
282      * false is an externally-owned account (EOA) and not a contract.
283      *
284      * Among others, `isContract` will return false for the following
285      * types of addresses:
286      *
287      *  - an externally-owned account
288      *  - a contract in construction
289      *  - an address where a contract will be created
290      *  - an address where a contract lived, but was destroyed
291      * ====
292      *
293      * [IMPORTANT]
294      * ====
295      * You shouldn't rely on `isContract` to protect against flash loan attacks!
296      *
297      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
298      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
299      * constructor.
300      * ====
301      */
302     function isContract(address account) internal view returns (bool) {
303         // This method relies on extcodesize/address.code.length, which returns 0
304         // for contracts in construction, since the code is only stored at the end
305         // of the constructor execution.
306 
307         return account.code.length > 0;
308     }
309 
310     /**
311      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
312      * `recipient`, forwarding all available gas and reverting on errors.
313      *
314      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
315      * of certain opcodes, possibly making contracts go over the 2300 gas limit
316      * imposed by `transfer`, making them unable to receive funds via
317      * `transfer`. {sendValue} removes this limitation.
318      *
319      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
320      *
321      * IMPORTANT: because control is transferred to `recipient`, care must be
322      * taken to not create reentrancy vulnerabilities. Consider using
323      * {ReentrancyGuard} or the
324      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
325      */
326     function sendValue(address payable recipient, uint256 amount) internal {
327         require(address(this).balance >= amount, "Address: insufficient balance");
328 
329         (bool success, ) = recipient.call{value: amount}("");
330         require(success, "Address: unable to send value, recipient may have reverted");
331     }
332 
333     /**
334      * @dev Performs a Solidity function call using a low level `call`. A
335      * plain `call` is an unsafe replacement for a function call: use this
336      * function instead.
337      *
338      * If `target` reverts with a revert reason, it is bubbled up by this
339      * function (like regular Solidity function calls).
340      *
341      * Returns the raw returned data. To convert to the expected return value,
342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
343      *
344      * Requirements:
345      *
346      * - `target` must be a contract.
347      * - calling `target` with `data` must not revert.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, 0, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but also transferring `value` wei to `target`.
372      *
373      * Requirements:
374      *
375      * - the calling contract must have an ETH balance of at least `value`.
376      * - the called Solidity function must be `payable`.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(
381         address target,
382         bytes memory data,
383         uint256 value
384     ) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
390      * with `errorMessage` as a fallback revert reason when `target` reverts.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(
395         address target,
396         bytes memory data,
397         uint256 value,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         require(address(this).balance >= value, "Address: insufficient balance for call");
401         require(isContract(target), "Address: call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.call{value: value}(data);
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but performing a static call.
410      *
411      * _Available since v3.3._
412      */
413     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
414         return functionStaticCall(target, data, "Address: low-level static call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
419      * but performing a static call.
420      *
421      * _Available since v3.3._
422      */
423     function functionStaticCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal view returns (bytes memory) {
428         require(isContract(target), "Address: static call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.staticcall(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but performing a delegate call.
437      *
438      * _Available since v3.4._
439      */
440     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
441         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
446      * but performing a delegate call.
447      *
448      * _Available since v3.4._
449      */
450     function functionDelegateCall(
451         address target,
452         bytes memory data,
453         string memory errorMessage
454     ) internal returns (bytes memory) {
455         require(isContract(target), "Address: delegate call to non-contract");
456 
457         (bool success, bytes memory returndata) = target.delegatecall(data);
458         return verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     /**
462      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
463      * revert reason using the provided one.
464      *
465      * _Available since v4.3._
466      */
467     function verifyCallResult(
468         bool success,
469         bytes memory returndata,
470         string memory errorMessage
471     ) internal pure returns (bytes memory) {
472         if (success) {
473             return returndata;
474         } else {
475             // Look for revert reason and bubble it up if present
476             if (returndata.length > 0) {
477                 // The easiest way to bubble the revert reason is using memory via assembly
478 
479                 assembly {
480                     let returndata_size := mload(returndata)
481                     revert(add(32, returndata), returndata_size)
482                 }
483             } else {
484                 revert(errorMessage);
485             }
486         }
487     }
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
491 
492 
493 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 /**
498  * @title ERC721 token receiver interface
499  * @dev Interface for any contract that wants to support safeTransfers
500  * from ERC721 asset contracts.
501  */
502 interface IERC721Receiver {
503     /**
504      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
505      * by `operator` from `from`, this function is called.
506      *
507      * It must return its Solidity selector to confirm the token transfer.
508      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
509      *
510      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
511      */
512     function onERC721Received(
513         address operator,
514         address from,
515         uint256 tokenId,
516         bytes calldata data
517     ) external returns (bytes4);
518 }
519 
520 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev Interface of the ERC165 standard, as defined in the
529  * https://eips.ethereum.org/EIPS/eip-165[EIP].
530  *
531  * Implementers can declare support of contract interfaces, which can then be
532  * queried by others ({ERC165Checker}).
533  *
534  * For an implementation, see {ERC165}.
535  */
536 interface IERC165 {
537     /**
538      * @dev Returns true if this contract implements the interface defined by
539      * `interfaceId`. See the corresponding
540      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
541      * to learn more about how these ids are created.
542      *
543      * This function call must use less than 30 000 gas.
544      */
545     function supportsInterface(bytes4 interfaceId) external view returns (bool);
546 }
547 
548 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @dev Implementation of the {IERC165} interface.
558  *
559  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
560  * for the additional interface id that will be supported. For example:
561  *
562  * ```solidity
563  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
565  * }
566  * ```
567  *
568  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
569  */
570 abstract contract ERC165 is IERC165 {
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
575         return interfaceId == type(IERC165).interfaceId;
576     }
577 }
578 
579 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
580 
581 
582 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 
587 /**
588  * @dev Required interface of an ERC721 compliant contract.
589  */
590 interface IERC721 is IERC165 {
591     /**
592      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
593      */
594     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
595 
596     /**
597      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
598      */
599     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
600 
601     /**
602      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
603      */
604     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
605 
606     /**
607      * @dev Returns the number of tokens in ``owner``'s account.
608      */
609     function balanceOf(address owner) external view returns (uint256 balance);
610 
611     /**
612      * @dev Returns the owner of the `tokenId` token.
613      *
614      * Requirements:
615      *
616      * - `tokenId` must exist.
617      */
618     function ownerOf(uint256 tokenId) external view returns (address owner);
619 
620     /**
621      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
622      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
623      *
624      * Requirements:
625      *
626      * - `from` cannot be the zero address.
627      * - `to` cannot be the zero address.
628      * - `tokenId` token must exist and be owned by `from`.
629      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
630      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
631      *
632      * Emits a {Transfer} event.
633      */
634     function safeTransferFrom(
635         address from,
636         address to,
637         uint256 tokenId
638     ) external;
639 
640     /**
641      * @dev Transfers `tokenId` token from `from` to `to`.
642      *
643      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
644      *
645      * Requirements:
646      *
647      * - `from` cannot be the zero address.
648      * - `to` cannot be the zero address.
649      * - `tokenId` token must be owned by `from`.
650      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
651      *
652      * Emits a {Transfer} event.
653      */
654     function transferFrom(
655         address from,
656         address to,
657         uint256 tokenId
658     ) external;
659 
660     /**
661      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
662      * The approval is cleared when the token is transferred.
663      *
664      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
665      *
666      * Requirements:
667      *
668      * - The caller must own the token or be an approved operator.
669      * - `tokenId` must exist.
670      *
671      * Emits an {Approval} event.
672      */
673     function approve(address to, uint256 tokenId) external;
674 
675     /**
676      * @dev Returns the account approved for `tokenId` token.
677      *
678      * Requirements:
679      *
680      * - `tokenId` must exist.
681      */
682     function getApproved(uint256 tokenId) external view returns (address operator);
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
697      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
698      *
699      * See {setApprovalForAll}
700      */
701     function isApprovedForAll(address owner, address operator) external view returns (bool);
702 
703     /**
704      * @dev Safely transfers `tokenId` token from `from` to `to`.
705      *
706      * Requirements:
707      *
708      * - `from` cannot be the zero address.
709      * - `to` cannot be the zero address.
710      * - `tokenId` token must exist and be owned by `from`.
711      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
712      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
713      *
714      * Emits a {Transfer} event.
715      */
716     function safeTransferFrom(
717         address from,
718         address to,
719         uint256 tokenId,
720         bytes calldata data
721     ) external;
722 }
723 
724 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
725 
726 
727 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 
732 /**
733  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
734  * @dev See https://eips.ethereum.org/EIPS/eip-721
735  */
736 interface IERC721Metadata is IERC721 {
737     /**
738      * @dev Returns the token collection name.
739      */
740     function name() external view returns (string memory);
741 
742     /**
743      * @dev Returns the token collection symbol.
744      */
745     function symbol() external view returns (string memory);
746 
747     /**
748      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
749      */
750     function tokenURI(uint256 tokenId) external view returns (string memory);
751 }
752 
753 // File: contracts/ERC721A.sol
754 
755 
756 // Creator: Chiru Labs
757 
758 pragma solidity ^0.8.4;
759 
760 
761 
762 
763 
764 
765 
766 
767 error ApprovalCallerNotOwnerNorApproved();
768 error ApprovalQueryForNonexistentToken();
769 error ApproveToCaller();
770 error ApprovalToCurrentOwner();
771 error BalanceQueryForZeroAddress();
772 error MintToZeroAddress();
773 error MintZeroQuantity();
774 error OwnerQueryForNonexistentToken();
775 error TransferCallerNotOwnerNorApproved();
776 error TransferFromIncorrectOwner();
777 error TransferToNonERC721ReceiverImplementer();
778 error TransferToZeroAddress();
779 error URIQueryForNonexistentToken();
780 
781 /**
782  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
783  * the Metadata extension. Built to optimize for lower gas during batch mints.
784  *
785  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
786  *
787  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
788  *
789  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
790  */
791 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
792     using Address for address;
793     using Strings for uint256;
794 
795     // Compiler will pack this into a single 256bit word.
796     struct TokenOwnership {
797         // The address of the owner.
798         address addr;
799         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
800         uint64 startTimestamp;
801         // Whether the token has been burned.
802         bool burned;
803     }
804 
805     // Compiler will pack this into a single 256bit word.
806     struct AddressData {
807         // Realistically, 2**64-1 is more than enough.
808         uint64 balance;
809         // Keeps track of mint count with minimal overhead for tokenomics.
810         uint64 numberMinted;
811         // Keeps track of burn count with minimal overhead for tokenomics.
812         uint64 numberBurned;
813         // For miscellaneous variable(s) pertaining to the address
814         // (e.g. number of whitelist mint slots used).
815         // If there are multiple variables, please pack them into a uint64.
816         uint64 aux;
817     }
818 
819     // The tokenId of the next token to be minted.
820     uint256 internal _currentIndex;
821 
822     // The number of tokens burned.
823     uint256 internal _burnCounter;
824 
825     // Token name
826     string private _name;
827 
828     // Token symbol
829     string private _symbol;
830 
831     // Mapping from token ID to ownership details
832     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
833     mapping(uint256 => TokenOwnership) internal _ownerships;
834 
835     // Mapping owner address to address data
836     mapping(address => AddressData) private _addressData;
837 
838     // Mapping from token ID to approved address
839     mapping(uint256 => address) private _tokenApprovals;
840 
841     // Mapping from owner to operator approvals
842     mapping(address => mapping(address => bool)) private _operatorApprovals;
843 
844     constructor(string memory name_, string memory symbol_) {
845         _name = name_;
846         _symbol = symbol_;
847         _currentIndex = _startTokenId();
848     }
849 
850     /**
851      * To change the starting tokenId, please override this function.
852      */
853     function _startTokenId() internal view virtual returns (uint256) {
854         return 1;
855     }
856 
857     /**
858      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
859      */
860     function totalSupply() public view returns (uint256) {
861         // Counter underflow is impossible as _burnCounter cannot be incremented
862         // more than _currentIndex - _startTokenId() times
863         unchecked {
864             return _currentIndex - _burnCounter - _startTokenId();
865         }
866     }
867 
868     /**
869      * Returns the total amount of tokens minted in the contract.
870      */
871     function _totalMinted() internal view returns (uint256) {
872         // Counter underflow is impossible as _currentIndex does not decrement,
873         // and it is initialized to _startTokenId()
874         unchecked {
875             return _currentIndex - _startTokenId();
876         }
877     }
878 
879     /**
880      * @dev See {IERC165-supportsInterface}.
881      */
882     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
883         return
884             interfaceId == type(IERC721).interfaceId ||
885             interfaceId == type(IERC721Metadata).interfaceId ||
886             super.supportsInterface(interfaceId);
887     }
888 
889     /**
890      * @dev See {IERC721-balanceOf}.
891      */
892     function balanceOf(address owner) public view override returns (uint256) {
893         if (owner == address(0)) revert BalanceQueryForZeroAddress();
894         return uint256(_addressData[owner].balance);
895     }
896 
897     /**
898      * Returns the number of tokens minted by `owner`.
899      */
900     function _numberMinted(address owner) internal view returns (uint256) {
901         return uint256(_addressData[owner].numberMinted);
902     }
903 
904     /**
905      * Returns the number of tokens burned by or on behalf of `owner`.
906      */
907     function _numberBurned(address owner) internal view returns (uint256) {
908         return uint256(_addressData[owner].numberBurned);
909     }
910 
911     /**
912      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
913      */
914     function _getAux(address owner) internal view returns (uint64) {
915         return _addressData[owner].aux;
916     }
917 
918     /**
919      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
920      * If there are multiple variables, please pack them into a uint64.
921      */
922     function _setAux(address owner, uint64 aux) internal {
923         _addressData[owner].aux = aux;
924     }
925 
926     /**
927      * Gas spent here starts off proportional to the maximum mint batch size.
928      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
929      */
930     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
931         uint256 curr = tokenId;
932 
933         unchecked {
934             if (_startTokenId() <= curr && curr < _currentIndex) {
935                 TokenOwnership memory ownership = _ownerships[curr];
936                 if (!ownership.burned) {
937                     if (ownership.addr != address(0)) {
938                         return ownership;
939                     }
940                     // Invariant:
941                     // There will always be an ownership that has an address and is not burned
942                     // before an ownership that does not have an address and is not burned.
943                     // Hence, curr will not underflow.
944                     while (true) {
945                         curr--;
946                         ownership = _ownerships[curr];
947                         if (ownership.addr != address(0)) {
948                             return ownership;
949                         }
950                     }
951                 }
952             }
953         }
954         revert OwnerQueryForNonexistentToken();
955     }
956 
957     /**
958      * @dev See {IERC721-ownerOf}.
959      */
960     function ownerOf(uint256 tokenId) public view override returns (address) {
961         return _ownershipOf(tokenId).addr;
962     }
963 
964     /**
965      * @dev See {IERC721Metadata-name}.
966      */
967     function name() public view virtual override returns (string memory) {
968         return _name;
969     }
970 
971     /**
972      * @dev See {IERC721Metadata-symbol}.
973      */
974     function symbol() public view virtual override returns (string memory) {
975         return _symbol;
976     }
977 
978     /**
979      * @dev See {IERC721Metadata-tokenURI}.
980      */
981     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
982         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
983 
984         string memory baseURI = _baseURI();
985         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
986     }
987 
988     /**
989      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
990      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
991      * by default, can be overriden in child contracts.
992      */
993     function _baseURI() internal view virtual returns (string memory) {
994         return '';
995     }
996 
997     /**
998      * @dev See {IERC721-approve}.
999      */
1000     function approve(address to, uint256 tokenId) public override {
1001         address owner = ERC721A.ownerOf(tokenId);
1002         if (to == owner) revert ApprovalToCurrentOwner();
1003 
1004         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1005             revert ApprovalCallerNotOwnerNorApproved();
1006         }
1007 
1008         _approve(to, tokenId, owner);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-getApproved}.
1013      */
1014     function getApproved(uint256 tokenId) public view override returns (address) {
1015         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1016 
1017         return _tokenApprovals[tokenId];
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-setApprovalForAll}.
1022      */
1023     function setApprovalForAll(address operator, bool approved) public virtual override {
1024         if (operator == _msgSender()) revert ApproveToCaller();
1025 
1026         _operatorApprovals[_msgSender()][operator] = approved;
1027         emit ApprovalForAll(_msgSender(), operator, approved);
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-isApprovedForAll}.
1032      */
1033     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1034         return _operatorApprovals[owner][operator];
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-transferFrom}.
1039      */
1040     function transferFrom(
1041         address from,
1042         address to,
1043         uint256 tokenId
1044     ) public virtual override {
1045         _transfer(from, to, tokenId);
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-safeTransferFrom}.
1050      */
1051     function safeTransferFrom(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) public virtual override {
1056         safeTransferFrom(from, to, tokenId, '');
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-safeTransferFrom}.
1061      */
1062     function safeTransferFrom(
1063         address from,
1064         address to,
1065         uint256 tokenId,
1066         bytes memory _data
1067     ) public virtual override {
1068         _transfer(from, to, tokenId);
1069         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1070             revert TransferToNonERC721ReceiverImplementer();
1071         }
1072     }
1073 
1074     /**
1075      * @dev Returns whether `tokenId` exists.
1076      *
1077      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1078      *
1079      * Tokens start existing when they are minted (`_mint`),
1080      */
1081     function _exists(uint256 tokenId) internal view returns (bool) {
1082         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1083     }
1084 
1085     /**
1086      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1087      */
1088     function _safeMint(address to, uint256 quantity) internal {
1089         _safeMint(to, quantity, '');
1090     }
1091 
1092     /**
1093      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1094      *
1095      * Requirements:
1096      *
1097      * - If `to` refers to a smart contract, it must implement 
1098      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1099      * - `quantity` must be greater than 0.
1100      *
1101      * Emits a {Transfer} event.
1102      */
1103     function _safeMint(
1104         address to,
1105         uint256 quantity,
1106         bytes memory _data
1107     ) internal {
1108         uint256 startTokenId = _currentIndex;
1109         if (to == address(0)) revert MintToZeroAddress();
1110         if (quantity == 0) revert MintZeroQuantity();
1111 
1112         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1113 
1114         // Overflows are incredibly unrealistic.
1115         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1116         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1117         unchecked {
1118             _addressData[to].balance += uint64(quantity);
1119             _addressData[to].numberMinted += uint64(quantity);
1120 
1121             _ownerships[startTokenId].addr = to;
1122             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1123 
1124             uint256 updatedIndex = startTokenId;
1125             uint256 end = updatedIndex + quantity;
1126 
1127             if (to.isContract()) {
1128                 do {
1129                     emit Transfer(address(0), to, updatedIndex);
1130                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1131                         revert TransferToNonERC721ReceiverImplementer();
1132                     }
1133                 } while (updatedIndex != end);
1134                 // Reentrancy protection
1135                 if (_currentIndex != startTokenId) revert();
1136             } else {
1137                 do {
1138                     emit Transfer(address(0), to, updatedIndex++);
1139                 } while (updatedIndex != end);
1140             }
1141             _currentIndex = updatedIndex;
1142         }
1143         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1144     }
1145 
1146     /**
1147      * @dev Mints `quantity` tokens and transfers them to `to`.
1148      *
1149      * Requirements:
1150      *
1151      * - `to` cannot be the zero address.
1152      * - `quantity` must be greater than 0.
1153      *
1154      * Emits a {Transfer} event.
1155      */
1156     function _mint(address to, uint256 quantity) internal {
1157         uint256 startTokenId = _currentIndex;
1158         if (to == address(0)) revert MintToZeroAddress();
1159         if (quantity == 0) revert MintZeroQuantity();
1160 
1161         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1162 
1163         // Overflows are incredibly unrealistic.
1164         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1165         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1166         unchecked {
1167             _addressData[to].balance += uint64(quantity);
1168             _addressData[to].numberMinted += uint64(quantity);
1169 
1170             _ownerships[startTokenId].addr = to;
1171             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1172 
1173             uint256 updatedIndex = startTokenId;
1174             uint256 end = updatedIndex + quantity;
1175 
1176             do {
1177                 emit Transfer(address(0), to, updatedIndex++);
1178             } while (updatedIndex != end);
1179 
1180             _currentIndex = updatedIndex;
1181         }
1182         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1183     }
1184 
1185     /**
1186      * @dev Transfers `tokenId` from `from` to `to`.
1187      *
1188      * Requirements:
1189      *
1190      * - `to` cannot be the zero address.
1191      * - `tokenId` token must be owned by `from`.
1192      *
1193      * Emits a {Transfer} event.
1194      */
1195     function _transfer(
1196         address from,
1197         address to,
1198         uint256 tokenId
1199     ) private {
1200         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1201 
1202         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1203 
1204         bool isApprovedOrOwner = (_msgSender() == from ||
1205             isApprovedForAll(from, _msgSender()) ||
1206             getApproved(tokenId) == _msgSender());
1207 
1208         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1209         if (to == address(0)) revert TransferToZeroAddress();
1210 
1211         _beforeTokenTransfers(from, to, tokenId, 1);
1212 
1213         // Clear approvals from the previous owner
1214         _approve(address(0), tokenId, from);
1215 
1216         // Underflow of the sender's balance is impossible because we check for
1217         // ownership above and the recipient's balance can't realistically overflow.
1218         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1219         unchecked {
1220             _addressData[from].balance -= 1;
1221             _addressData[to].balance += 1;
1222 
1223             TokenOwnership storage currSlot = _ownerships[tokenId];
1224             currSlot.addr = to;
1225             currSlot.startTimestamp = uint64(block.timestamp);
1226 
1227             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1228             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1229             uint256 nextTokenId = tokenId + 1;
1230             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1231             if (nextSlot.addr == address(0)) {
1232                 // This will suffice for checking _exists(nextTokenId),
1233                 // as a burned slot cannot contain the zero address.
1234                 if (nextTokenId != _currentIndex) {
1235                     nextSlot.addr = from;
1236                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1237                 }
1238             }
1239         }
1240 
1241         emit Transfer(from, to, tokenId);
1242         _afterTokenTransfers(from, to, tokenId, 1);
1243     }
1244 
1245     /**
1246      * @dev Equivalent to `_burn(tokenId, false)`.
1247      */
1248     function _burn(uint256 tokenId) internal virtual {
1249         _burn(tokenId, false);
1250     }
1251 
1252     /**
1253      * @dev Destroys `tokenId`.
1254      * The approval is cleared when the token is burned.
1255      *
1256      * Requirements:
1257      *
1258      * - `tokenId` must exist.
1259      *
1260      * Emits a {Transfer} event.
1261      */
1262     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1263         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1264 
1265         address from = prevOwnership.addr;
1266 
1267         if (approvalCheck) {
1268             bool isApprovedOrOwner = (_msgSender() == from ||
1269                 isApprovedForAll(from, _msgSender()) ||
1270                 getApproved(tokenId) == _msgSender());
1271 
1272             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1273         }
1274 
1275         _beforeTokenTransfers(from, address(0), tokenId, 1);
1276 
1277         // Clear approvals from the previous owner
1278         _approve(address(0), tokenId, from);
1279 
1280         // Underflow of the sender's balance is impossible because we check for
1281         // ownership above and the recipient's balance can't realistically overflow.
1282         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1283         unchecked {
1284             AddressData storage addressData = _addressData[from];
1285             addressData.balance -= 1;
1286             addressData.numberBurned += 1;
1287 
1288             // Keep track of who burned the token, and the timestamp of burning.
1289             TokenOwnership storage currSlot = _ownerships[tokenId];
1290             currSlot.addr = from;
1291             currSlot.startTimestamp = uint64(block.timestamp);
1292             currSlot.burned = true;
1293 
1294             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1295             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1296             uint256 nextTokenId = tokenId + 1;
1297             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1298             if (nextSlot.addr == address(0)) {
1299                 // This will suffice for checking _exists(nextTokenId),
1300                 // as a burned slot cannot contain the zero address.
1301                 if (nextTokenId != _currentIndex) {
1302                     nextSlot.addr = from;
1303                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1304                 }
1305             }
1306         }
1307 
1308         emit Transfer(from, address(0), tokenId);
1309         _afterTokenTransfers(from, address(0), tokenId, 1);
1310 
1311         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1312         unchecked {
1313             _burnCounter++;
1314         }
1315     }
1316 
1317     /**
1318      * @dev Approve `to` to operate on `tokenId`
1319      *
1320      * Emits a {Approval} event.
1321      */
1322     function _approve(
1323         address to,
1324         uint256 tokenId,
1325         address owner
1326     ) private {
1327         _tokenApprovals[tokenId] = to;
1328         emit Approval(owner, to, tokenId);
1329     }
1330 
1331     /**
1332      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1333      *
1334      * @param from address representing the previous owner of the given token ID
1335      * @param to target address that will receive the tokens
1336      * @param tokenId uint256 ID of the token to be transferred
1337      * @param _data bytes optional data to send along with the call
1338      * @return bool whether the call correctly returned the expected magic value
1339      */
1340     function _checkContractOnERC721Received(
1341         address from,
1342         address to,
1343         uint256 tokenId,
1344         bytes memory _data
1345     ) private returns (bool) {
1346         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1347             return retval == IERC721Receiver(to).onERC721Received.selector;
1348         } catch (bytes memory reason) {
1349             if (reason.length == 0) {
1350                 revert TransferToNonERC721ReceiverImplementer();
1351             } else {
1352                 assembly {
1353                     revert(add(32, reason), mload(reason))
1354                 }
1355             }
1356         }
1357     }
1358 
1359     /**
1360      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1361      * And also called before burning one token.
1362      *
1363      * startTokenId - the first token id to be transferred
1364      * quantity - the amount to be transferred
1365      *
1366      * Calling conditions:
1367      *
1368      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1369      * transferred to `to`.
1370      * - When `from` is zero, `tokenId` will be minted for `to`.
1371      * - When `to` is zero, `tokenId` will be burned by `from`.
1372      * - `from` and `to` are never both zero.
1373      */
1374     function _beforeTokenTransfers(
1375         address from,
1376         address to,
1377         uint256 startTokenId,
1378         uint256 quantity
1379     ) internal virtual {}
1380 
1381     /**
1382      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1383      * minting.
1384      * And also called after one token has been burned.
1385      *
1386      * startTokenId - the first token id to be transferred
1387      * quantity - the amount to be transferred
1388      *
1389      * Calling conditions:
1390      *
1391      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1392      * transferred to `to`.
1393      * - When `from` is zero, `tokenId` has been minted for `to`.
1394      * - When `to` is zero, `tokenId` has been burned by `from`.
1395      * - `from` and `to` are never both zero.
1396      */
1397     function _afterTokenTransfers(
1398         address from,
1399         address to,
1400         uint256 startTokenId,
1401         uint256 quantity
1402     ) internal virtual {}
1403 }
1404 // File: contracts/DokeV.sol
1405 
1406 
1407 
1408 pragma solidity ^0.8.0;
1409 
1410 
1411 
1412 
1413 
1414 contract TheArtOfMathematics is ERC721A, Ownable, ReentrancyGuard {
1415   using Address for address;
1416   using Strings for uint;
1417 
1418 
1419   string  public  baseTokenURI = "ipfs://QmYHT6RkGvoEfFk77AEu5qcDM2Rgo6GsCmSrE9cmgavEG6/";
1420   uint256  public  maxSupply = 540;
1421   uint256 public  MAX_MINTS_PER_TX = 5;
1422   uint256 public  PUBLIC_SALE_PRICE = 0.005 ether;
1423   uint256 public  NUM_FREE_MINTS = 100;
1424   uint256 public  MAX_FREE_PER_WALLET = 1;
1425   uint256 public freeNFTAlreadyMinted = 0;
1426   bool public isPublicSaleActive = false ;
1427 
1428   constructor(
1429 
1430   ) ERC721A("The Art Of Mathematics", "TAOM") {
1431 
1432   }
1433 
1434 
1435   function mint(uint256 numberOfTokens)
1436       external
1437       payable
1438   {
1439     require(isPublicSaleActive, "Public sale is not open");
1440     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1441 
1442     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1443         require(
1444             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1445             "Incorrect ETH value sent"
1446         );
1447     } else {
1448         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1449         require(
1450             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1451             "Incorrect ETH value sent"
1452         );
1453         require(
1454             numberOfTokens <= MAX_MINTS_PER_TX,
1455             "Max mints per transaction exceeded"
1456         );
1457         } else {
1458             require(
1459                 numberOfTokens <= MAX_FREE_PER_WALLET,
1460                 "Max mints per transaction exceeded"
1461             );
1462             freeNFTAlreadyMinted += numberOfTokens;
1463         }
1464     }
1465     _safeMint(msg.sender, numberOfTokens);
1466   }
1467 
1468   function setBaseURI(string memory baseURI)
1469     public
1470     onlyOwner
1471   {
1472     baseTokenURI = baseURI;
1473   }
1474 
1475   function treasuryMint(uint quantity)
1476     public
1477     onlyOwner
1478   {
1479     require(
1480       quantity > 0,
1481       "Invalid mint amount"
1482     );
1483     require(
1484       totalSupply() + quantity <= maxSupply,
1485       "Maximum supply exceeded"
1486     );
1487     _safeMint(msg.sender, quantity);
1488   }
1489 
1490   function withdraw()
1491     public
1492     onlyOwner
1493     nonReentrant
1494   {
1495     Address.sendValue(payable(msg.sender), address(this).balance);
1496   }
1497 
1498   function tokenURI(uint _tokenId)
1499     public
1500     view
1501     virtual
1502     override
1503     returns (string memory)
1504   {
1505     require(
1506       _exists(_tokenId),
1507       "ERC721Metadata: URI query for nonexistent token"
1508     );
1509     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1510   }
1511 
1512   function _baseURI()
1513     internal
1514     view
1515     virtual
1516     override
1517     returns (string memory)
1518   {
1519     return baseTokenURI;
1520   }
1521 
1522   function setIsPublicSaleActive(bool _isPublicSaleActive)
1523       external
1524       onlyOwner
1525   {
1526       isPublicSaleActive = _isPublicSaleActive;
1527   }
1528 
1529   function setNumFreeMints(uint256 _numfreemints)
1530       external
1531       onlyOwner
1532   {
1533       NUM_FREE_MINTS = _numfreemints;
1534   }
1535 
1536   function setSalePrice(uint256 _price)
1537       external
1538       onlyOwner
1539   {
1540       PUBLIC_SALE_PRICE = _price;
1541   }
1542   function cutMaxSupply(uint256 _amount) public onlyOwner {
1543         require(
1544             maxSupply +_amount >= 1, 
1545             "Supply cannot fall below minted tokens."
1546         );
1547         maxSupply += _amount;
1548     }
1549   function setMaxLimitPerTransaction(uint256 _limit)
1550       external
1551       onlyOwner
1552   {
1553       MAX_MINTS_PER_TX = _limit;
1554   }
1555 
1556   function setFreeLimitPerWallet(uint256 _limit)
1557       external
1558       onlyOwner
1559   {
1560       MAX_FREE_PER_WALLET = _limit;
1561   }
1562 }