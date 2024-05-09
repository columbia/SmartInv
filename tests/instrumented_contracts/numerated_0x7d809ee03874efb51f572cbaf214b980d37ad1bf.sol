1 // SPDX-License-Identifier: MIT
2 
3 
4 /*
5 
6  
7                                                                                                         
8                                                                                                         
9    ____   ___               ___      ___                          ____                     ___          
10   6MMMMb/ `MM                MM       MM                         6MMMMb\                   `MM          
11  8P    YM  MM                MM       MM                        6M'    `                    MM          
12 6M      Y  MM  __  ___   ___ MM____   MM____  ____    ___       MM         ____      ___    MM   ____   
13 MM         MM 6MMb `MM    MM MMMMMMb  MMMMMMb `MM(    )M'       YM.       6MMMMb   6MMMMb   MM  6MMMMb\ 
14 MM         MMM9 `Mb MM    MM MM'  `Mb MM'  `Mb `Mb    d'         YMMMMb  6M'  `Mb 8M'  `Mb  MM MM'    ` 
15 MM         MM'   MM MM    MM MM    MM MM    MM  YM.  ,P              `Mb MM    MM     ,oMM  MM YM.      
16 MM         MM    MM MM    MM MM    MM MM    MM   MM  M                MM MMMMMMMM ,6MM9'MM  MM  YMMMMb  
17 YM      6  MM    MM MM    MM MM    MM MM    MM   `Mbd'                MM MM       MM'   MM  MM      `Mb 
18  8b    d9  MM    MM YM.   MM MM.  ,M9 MM.  ,M9    YMP           L    ,M9 YM    d9 MM.  ,MM  MM L    ,MM 
19   YMMMM9  _MM_  _MM_ YMMM9MM_MYMMMM9 _MYMMMM9      M            MYMMMM9   YMMMM9  `YMMM9'Yb_MM_MYMMMM9  
20                                                   d'                                                    
21                                               (8),P                                                     
22                                                YMM                                                      
23 
24   
25 
26                                                                                           
27 */
28 
29 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * dev Contract module that helps prevent reentrant calls to a function.
38  *
39  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
40  * available, which can be applied to functions to make sure there are no nested
41  * (reentrant) calls to them.
42  *
43  * Note that because there is a single `nonReentrant` guard, functions marked as
44  * `nonReentrant` may not call one another. This can be worked around by making
45  * those functions `private`, and then adding `external` `nonReentrant` entry
46  * points to them.
47  *
48  * TIP: If you would like to learn more about reentrancy and alternative ways
49  * to protect against it, check out our blog post
50  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
51  */
52 abstract contract ReentrancyGuard {
53     // Booleans are more expensive than uint256 or any type that takes up a full
54     // word because each write operation emits an extra SLOAD to first read the
55     // slot's contents, replace the bits taken up by the boolean, and then write
56     // back. This is the compiler's defense against contract upgrades and
57     // pointer aliasing, and it cannot be disabled.
58 
59     // The values being non-zero value makes deployment a bit more expensive,
60     // but in exchange the refund on every call to nonReentrant will be lower in
61     // amount. Since refunds are capped to a percentage of the total
62     // transaction's gas, it is best to keep them low in cases like this one, to
63     // increase the likelihood of the full refund coming into effect.
64     uint256 private constant _NOT_ENTERED = 1;
65     uint256 private constant _ENTERED = 2;
66 
67     uint256 private _status;
68 
69     constructor() {
70         _status = _NOT_ENTERED;
71     }
72 
73     /**
74      * dev Prevents a contract from calling itself, directly or indirectly.
75      * Calling a `nonReentrant` function from another `nonReentrant`
76      * function is not supported. It is possible to prevent this from happening
77      * by making the `nonReentrant` function external, and making it call a
78      * `private` function that does the actual work.
79      */
80     modifier nonReentrant() {
81         // On the first call to nonReentrant, _notEntered will be true
82         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
83 
84         // Any calls to nonReentrant after this point will fail
85         _status = _ENTERED;
86 
87         _;
88 
89         // By storing the original value once again, a refund is triggered (see
90         // https://eips.ethereum.org/EIPS/eip-2200)
91         _status = _NOT_ENTERED;
92     }
93 }
94 
95 // File: @openzeppelin/contracts/utils/Strings.sol
96 
97 
98 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * dev String operations.
104  */
105 library Strings {
106     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
107 
108     /**
109      * dev Converts a `uint256` to its ASCII `string` decimal representation.
110      */
111     function toString(uint256 value) internal pure returns (string memory) {
112         // Inspired by OraclizeAPI's implementation - MIT licence
113         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
114 
115         if (value == 0) {
116             return "0";
117         }
118         uint256 temp = value;
119         uint256 digits;
120         while (temp != 0) {
121             digits++;
122             temp /= 10;
123         }
124         bytes memory buffer = new bytes(digits);
125         while (value != 0) {
126             digits -= 1;
127             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
128             value /= 10;
129         }
130         return string(buffer);
131     }
132 
133     /**
134      * dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
135      */
136     function toHexString(uint256 value) internal pure returns (string memory) {
137         if (value == 0) {
138             return "0x00";
139         }
140         uint256 temp = value;
141         uint256 length = 0;
142         while (temp != 0) {
143             length++;
144             temp >>= 8;
145         }
146         return toHexString(value, length);
147     }
148 
149     /**
150      * dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
151      */
152     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
153         bytes memory buffer = new bytes(2 * length + 2);
154         buffer[0] = "0";
155         buffer[1] = "x";
156         for (uint256 i = 2 * length + 1; i > 1; --i) {
157             buffer[i] = _HEX_SYMBOLS[value & 0xf];
158             value >>= 4;
159         }
160         require(value == 0, "Strings: hex length insufficient");
161         return string(buffer);
162     }
163 }
164 
165 // File: @openzeppelin/contracts/utils/Context.sol
166 
167 
168 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 /**
173  * dev Provides information about the current execution context, including the
174  * sender of the transaction and its data. While these are generally available
175  * via msg.sender and msg.data, they should not be accessed in such a direct
176  * manner, since when dealing with meta-transactions the account sending and
177  * paying for execution may not be the actual sender (as far as an application
178  * is concerned).
179  *
180  * This contract is only required for intermediate, library-like contracts.
181  */
182 abstract contract Context {
183     function _msgSender() internal view virtual returns (address) {
184         return msg.sender;
185     }
186 
187     function _msgData() internal view virtual returns (bytes calldata) {
188         return msg.data;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/access/Ownable.sol
193 
194 
195 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 
200 /**
201  * dev Contract module which provides a basic access control mechanism, where
202  * there is an account (an owner) that can be granted exclusive access to
203  * specific functions.
204  *
205  * By default, the owner account will be the one that deploys the contract. This
206  * can later be changed with {transferOwnership}.
207  *
208  * This module is used through inheritance. It will make available the modifier
209  * `onlyOwner`, which can be applied to your functions to restrict their use to
210  * the owner.
211  */
212 abstract contract Ownable is Context {
213     address private _owner;
214 
215     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
216 
217     /**
218      * dev Initializes the contract setting the deployer as the initial owner.
219      */
220     constructor() {
221         _transferOwnership(_msgSender());
222     }
223 
224     /**
225      * dev Returns the address of the current owner.
226      */
227     function owner() public view virtual returns (address) {
228         return _owner;
229     }
230 
231     /**
232      * dev Throws if called by any account other than the owner.
233      */
234     modifier onlyOwner() {
235         require(owner() == _msgSender(), "Ownable: caller is not the owner");
236         _;
237     }
238 
239     /**
240      * dev Leaves the contract without owner. It will not be possible to call
241      * `onlyOwner` functions anymore. Can only be called by the current owner.
242      *
243      * NOTE: Renouncing ownership will leave the contract without an owner,
244      * thereby removing any functionality that is only available to the owner.
245      */
246     function renounceOwnership() public virtual onlyOwner {
247         _transferOwnership(address(0));
248     }
249 
250     /**
251      * dev Transfers ownership of the contract to a new account (`newOwner`).
252      * Can only be called by the current owner.
253      */
254     function transferOwnership(address newOwner) public virtual onlyOwner {
255         require(newOwner != address(0), "Ownable: new owner is the zero address");
256         _transferOwnership(newOwner);
257     }
258 
259     /**
260      * dev Transfers ownership of the contract to a new account (`newOwner`).
261      * Internal function without access restriction.
262      */
263     function _transferOwnership(address newOwner) internal virtual {
264         address oldOwner = _owner;
265         _owner = newOwner;
266         emit OwnershipTransferred(oldOwner, newOwner);
267     }
268 }
269 
270 // File: @openzeppelin/contracts/utils/Address.sol
271 
272 
273 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
274 
275 pragma solidity ^0.8.1;
276 
277 /**
278  * dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      *
298      * [IMPORTANT]
299      * ====
300      * You shouldn't rely on `isContract` to protect against flash loan attacks!
301      *
302      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
303      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
304      * constructor.
305      * ====
306      */
307     function isContract(address account) internal view returns (bool) {
308         // This method relies on extcodesize/address.code.length, which returns 0
309         // for contracts in construction, since the code is only stored at the end
310         // of the constructor execution.
311 
312         return account.code.length > 0;
313     }
314 
315     /**
316      * dev Replacement for Solidity's `transfer`: sends `amount` wei to
317      * `recipient`, forwarding all available gas and reverting on errors.
318      *
319      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
320      * of certain opcodes, possibly making contracts go over the 2300 gas limit
321      * imposed by `transfer`, making them unable to receive funds via
322      * `transfer`. {sendValue} removes this limitation.
323      *
324      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
325      *
326      * IMPORTANT: because control is transferred to `recipient`, care must be
327      * taken to not create reentrancy vulnerabilities. Consider using
328      * {ReentrancyGuard} or the
329      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
330      */
331     function sendValue(address payable recipient, uint256 amount) internal {
332         require(address(this).balance >= amount, "Address: insufficient balance");
333 
334         (bool success, ) = recipient.call{value: amount}("");
335         require(success, "Address: unable to send value, recipient may have reverted");
336     }
337 
338     /**
339      * dev Performs a Solidity function call using a low level `call`. A
340      * plain `call` is an unsafe replacement for a function call: use this
341      * function instead.
342      *
343      * If `target` reverts with a revert reason, it is bubbled up by this
344      * function (like regular Solidity function calls).
345      *
346      * Returns the raw returned data. To convert to the expected return value,
347      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
348      *
349      * Requirements:
350      *
351      * - `target` must be a contract.
352      * - calling `target` with `data` must not revert.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
357         return functionCall(target, data, "Address: low-level call failed");
358     }
359 
360     /**
361      * dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
362      * `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(
367         address target,
368         bytes memory data,
369         string memory errorMessage
370     ) internal returns (bytes memory) {
371         return functionCallWithValue(target, data, 0, errorMessage);
372     }
373 
374     /**
375      * dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but also transferring `value` wei to `target`.
377      *
378      * Requirements:
379      *
380      * - the calling contract must have an ETH balance of at least `value`.
381      * - the called Solidity function must be `payable`.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(
386         address target,
387         bytes memory data,
388         uint256 value
389     ) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
391     }
392 
393     /**
394      * dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
395      * with `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(
400         address target,
401         bytes memory data,
402         uint256 value,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         require(address(this).balance >= value, "Address: insufficient balance for call");
406         require(isContract(target), "Address: call to non-contract");
407 
408         (bool success, bytes memory returndata) = target.call{value: value}(data);
409         return verifyCallResult(success, returndata, errorMessage);
410     }
411 
412     /**
413      * dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414      * but performing a static call.
415      *
416      * _Available since v3.3._
417      */
418     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
419         return functionStaticCall(target, data, "Address: low-level static call failed");
420     }
421 
422     /**
423      * dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
424      * but performing a static call.
425      *
426      * _Available since v3.3._
427      */
428     function functionStaticCall(
429         address target,
430         bytes memory data,
431         string memory errorMessage
432     ) internal view returns (bytes memory) {
433         require(isContract(target), "Address: static call to non-contract");
434 
435         (bool success, bytes memory returndata) = target.staticcall(data);
436         return verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440      * dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441      * but performing a delegate call.
442      *
443      * _Available since v3.4._
444      */
445     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
446         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
447     }
448 
449     /**
450      * dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
451      * but performing a delegate call.
452      *
453      * _Available since v3.4._
454      */
455     function functionDelegateCall(
456         address target,
457         bytes memory data,
458         string memory errorMessage
459     ) internal returns (bytes memory) {
460         require(isContract(target), "Address: delegate call to non-contract");
461 
462         (bool success, bytes memory returndata) = target.delegatecall(data);
463         return verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
468      * revert reason using the provided one.
469      *
470      * _Available since v4.3._
471      */
472     function verifyCallResult(
473         bool success,
474         bytes memory returndata,
475         string memory errorMessage
476     ) internal pure returns (bytes memory) {
477         if (success) {
478             return returndata;
479         } else {
480             // Look for revert reason and bubble it up if present
481             if (returndata.length > 0) {
482                 // The easiest way to bubble the revert reason is using memory via assembly
483 
484                 assembly {
485                     let returndata_size := mload(returndata)
486                     revert(add(32, returndata), returndata_size)
487                 }
488             } else {
489                 revert(errorMessage);
490             }
491         }
492     }
493 }
494 
495 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @title ERC721 token receiver interface
504  * dev Interface for any contract that wants to support safeTransfers
505  * from ERC721 asset contracts.
506  */
507 interface IERC721Receiver {
508     /**
509      * dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
510      * by `operator` from `from`, this function is called.
511      *
512      * It must return its Solidity selector to confirm the token transfer.
513      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
514      *
515      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
516      */
517     function onERC721Received(
518         address operator,
519         address from,
520         uint256 tokenId,
521         bytes calldata data
522     ) external returns (bytes4);
523 }
524 
525 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 /**
533  * dev Interface of the ERC165 standard, as defined in the
534  * https://eips.ethereum.org/EIPS/eip-165[EIP].
535  *
536  * Implementers can declare support of contract interfaces, which can then be
537  * queried by others ({ERC165Checker}).
538  *
539  * For an implementation, see {ERC165}.
540  */
541 interface IERC165 {
542     /**
543      * dev Returns true if this contract implements the interface defined by
544      * `interfaceId`. See the corresponding
545      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
546      * to learn more about how these ids are created.
547      *
548      * This function call must use less than 30 000 gas.
549      */
550     function supportsInterface(bytes4 interfaceId) external view returns (bool);
551 }
552 
553 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
554 
555 
556 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 
561 /**
562  * dev Implementation of the {IERC165} interface.
563  *
564  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
565  * for the additional interface id that will be supported. For example:
566  *
567  * ```solidity
568  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
569  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
570  * }
571  * ```
572  *
573  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
574  */
575 abstract contract ERC165 is IERC165 {
576     /**
577      * dev See {IERC165-supportsInterface}.
578      */
579     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
580         return interfaceId == type(IERC165).interfaceId;
581     }
582 }
583 
584 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
585 
586 
587 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * dev Required interface of an ERC721 compliant contract.
594  */
595 interface IERC721 is IERC165 {
596     /**
597      * dev Emitted when `tokenId` token is transferred from `from` to `to`.
598      */
599     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
600 
601     /**
602      * dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
603      */
604     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
605 
606     /**
607      * dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
608      */
609     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
610 
611     /**
612      * dev Returns the number of tokens in ``owner``'s account.
613      */
614     function balanceOf(address owner) external view returns (uint256 balance);
615 
616     /**
617      * dev Returns the owner of the `tokenId` token.
618      *
619      * Requirements:
620      *
621      * - `tokenId` must exist.
622      */
623     function ownerOf(uint256 tokenId) external view returns (address owner);
624 
625     /**
626      * dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
627      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
628      *
629      * Requirements:
630      *
631      * - `from` cannot be the zero address.
632      * - `to` cannot be the zero address.
633      * - `tokenId` token must exist and be owned by `from`.
634      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
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
646      * dev Transfers `tokenId` token from `from` to `to`.
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
666      * dev Gives permission to `to` to transfer `tokenId` token to another account.
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
681      * dev Returns the account approved for `tokenId` token.
682      *
683      * Requirements:
684      *
685      * - `tokenId` must exist.
686      */
687     function getApproved(uint256 tokenId) external view returns (address operator);
688 
689     /**
690      * dev Approve or remove `operator` as an operator for the caller.
691      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
692      *
693      * Requirements:
694      *
695      * - The `operator` cannot be the caller.
696      *
697      * Emits an {ApprovalForAll} event.
698      */
699     function setApprovalForAll(address operator, bool _approved) external;
700 
701     /**
702      * dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
703      *
704      * See {setApprovalForAll}
705      */
706     function isApprovedForAll(address owner, address operator) external view returns (bool);
707 
708     /**
709      * dev Safely transfers `tokenId` token from `from` to `to`.
710      *
711      * Requirements:
712      *
713      * - `from` cannot be the zero address.
714      * - `to` cannot be the zero address.
715      * - `tokenId` token must exist and be owned by `from`.
716      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
717      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
718      *
719      * Emits a {Transfer} event.
720      */
721     function safeTransferFrom(
722         address from,
723         address to,
724         uint256 tokenId,
725         bytes calldata data
726     ) external;
727 }
728 
729 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
730 
731 
732 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 
737 /**
738  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
739  * dev See https://eips.ethereum.org/EIPS/eip-721
740  */
741 interface IERC721Metadata is IERC721 {
742     /**
743      * dev Returns the token collection name.
744      */
745     function name() external view returns (string memory);
746 
747     /**
748      * dev Returns the token collection symbol.
749      */
750     function symbol() external view returns (string memory);
751 
752     /**
753      * dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
754      */
755     function tokenURI(uint256 tokenId) external view returns (string memory);
756 }
757 
758 // File: erc721a/contracts/ERC721A.sol
759 
760 
761 pragma solidity ^0.8.4;
762 
763 
764 error ApprovalCallerNotOwnerNorApproved();
765 error ApprovalQueryForNonexistentToken();
766 error ApproveToCaller();
767 error ApprovalToCurrentOwner();
768 error BalanceQueryForZeroAddress();
769 error MintToZeroAddress();
770 error MintZeroQuantity();
771 error OwnerQueryForNonexistentToken();
772 error TransferCallerNotOwnerNorApproved();
773 error TransferFromIncorrectOwner();
774 error TransferToNonERC721ReceiverImplementer();
775 error TransferToZeroAddress();
776 error URIQueryForNonexistentToken();
777 
778 /**
779  * dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
780  * the Metadata extension. Built to optimize for lower gas during batch mints.
781  *
782  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
783  *
784  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
785  *
786  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
787  */
788 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
789     using Address for address;
790     using Strings for uint256;
791 
792     // Compiler will pack this into a single 256bit word.
793     struct TokenOwnership {
794         // The address of the owner.
795         address addr;
796         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
797         uint64 startTimestamp;
798         // Whether the token has been burned.
799         bool burned;
800     }
801 
802     // Compiler will pack this into a single 256bit word.
803     struct AddressData {
804         // Realistically, 2**64-1 is more than enough.
805         uint64 balance;
806         // Keeps track of mint count with minimal overhead for tokenomics.
807         uint64 numberMinted;
808         // Keeps track of burn count with minimal overhead for tokenomics.
809         uint64 numberBurned;
810         // For miscellaneous variable(s) pertaining to the address
811         // (e.g. number of whitelist mint slots used).
812         // If there are multiple variables, please pack them into a uint64.
813         uint64 aux;
814     }
815 
816     // The tokenId of the next token to be minted.
817     uint256 internal _currentIndex;
818 
819     // The number of tokens burned.
820     uint256 internal _burnCounter;
821 
822     // Token name
823     string private _name;
824 
825     // Token symbol
826     string private _symbol;
827 
828     // Mapping from token ID to ownership details
829     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
830     mapping(uint256 => TokenOwnership) internal _ownerships;
831 
832     // Mapping owner address to address data
833     mapping(address => AddressData) private _addressData;
834 
835     // Mapping from token ID to approved address
836     mapping(uint256 => address) private _tokenApprovals;
837 
838     // Mapping from owner to operator approvals
839     mapping(address => mapping(address => bool)) private _operatorApprovals;
840 
841     constructor(string memory name_, string memory symbol_) {
842         _name = name_;
843         _symbol = symbol_;
844         _currentIndex = _startTokenId();
845     }
846 
847     /**
848      * To change the starting tokenId, please override this function.
849      */
850     function _startTokenId() internal view virtual returns (uint256) {
851         return 0;
852     }
853 
854     /**
855      * dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
856      */
857     function totalSupply() public view returns (uint256) {
858         // Counter underflow is impossible as _burnCounter cannot be incremented
859         // more than _currentIndex - _startTokenId() times
860         unchecked {
861             return _currentIndex - _burnCounter - _startTokenId();
862         }
863     }
864 
865     /**
866      * Returns the total amount of tokens minted in the contract.
867      */
868     function _totalMinted() internal view returns (uint256) {
869         // Counter underflow is impossible as _currentIndex does not decrement,
870         // and it is initialized to _startTokenId()
871         unchecked {
872             return _currentIndex - _startTokenId();
873         }
874     }
875 
876     /**
877      * dev See {IERC165-supportsInterface}.
878      */
879     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
880         return
881             interfaceId == type(IERC721).interfaceId ||
882             interfaceId == type(IERC721Metadata).interfaceId ||
883             super.supportsInterface(interfaceId);
884     }
885 
886     /**
887      * dev See {IERC721-balanceOf}.
888      */
889     function balanceOf(address owner) public view override returns (uint256) {
890         if (owner == address(0)) revert BalanceQueryForZeroAddress();
891         return uint256(_addressData[owner].balance);
892     }
893 
894     /**
895      * Returns the number of tokens minted by `owner`.
896      */
897     function _numberMinted(address owner) internal view returns (uint256) {
898         return uint256(_addressData[owner].numberMinted);
899     }
900 
901     /**
902      * Returns the number of tokens burned by or on behalf of `owner`.
903      */
904     function _numberBurned(address owner) internal view returns (uint256) {
905         return uint256(_addressData[owner].numberBurned);
906     }
907 
908     /**
909      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
910      */
911     function _getAux(address owner) internal view returns (uint64) {
912         return _addressData[owner].aux;
913     }
914 
915     /**
916      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
917      * If there are multiple variables, please pack them into a uint64.
918      */
919     function _setAux(address owner, uint64 aux) internal {
920         _addressData[owner].aux = aux;
921     }
922 
923     /**
924      * Gas spent here starts off proportional to the maximum mint batch size.
925      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
926      */
927     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
928         uint256 curr = tokenId;
929 
930         unchecked {
931             if (_startTokenId() <= curr && curr < _currentIndex) {
932                 TokenOwnership memory ownership = _ownerships[curr];
933                 if (!ownership.burned) {
934                     if (ownership.addr != address(0)) {
935                         return ownership;
936                     }
937                     // Invariant:
938                     // There will always be an ownership that has an address and is not burned
939                     // before an ownership that does not have an address and is not burned.
940                     // Hence, curr will not underflow.
941                     while (true) {
942                         curr--;
943                         ownership = _ownerships[curr];
944                         if (ownership.addr != address(0)) {
945                             return ownership;
946                         }
947                     }
948                 }
949             }
950         }
951         revert OwnerQueryForNonexistentToken();
952     }
953 
954     /**
955      * dev See {IERC721-ownerOf}.
956      */
957     function ownerOf(uint256 tokenId) public view override returns (address) {
958         return _ownershipOf(tokenId).addr;
959     }
960 
961     /**
962      * dev See {IERC721Metadata-name}.
963      */
964     function name() public view virtual override returns (string memory) {
965         return _name;
966     }
967 
968     /**
969      * dev See {IERC721Metadata-symbol}.
970      */
971     function symbol() public view virtual override returns (string memory) {
972         return _symbol;
973     }
974 
975     /**
976      * dev See {IERC721Metadata-tokenURI}.
977      */
978     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
979         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
980 
981         string memory baseURI = _baseURI();
982         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
983     }
984 
985     /**
986      * dev Base URI for computing {tokenURI}. If set, the resulting URI for each
987      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
988      * by default, can be overriden in child contracts.
989      */
990     function _baseURI() internal view virtual returns (string memory) {
991         return '';
992     }
993 
994     /**
995      * dev See {IERC721-approve}.
996      */
997     function approve(address to, uint256 tokenId) public override {
998         address owner = ERC721A.ownerOf(tokenId);
999         if (to == owner) revert ApprovalToCurrentOwner();
1000 
1001         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1002             revert ApprovalCallerNotOwnerNorApproved();
1003         }
1004 
1005         _approve(to, tokenId, owner);
1006     }
1007 
1008     /**
1009      * dev See {IERC721-getApproved}.
1010      */
1011     function getApproved(uint256 tokenId) public view override returns (address) {
1012         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1013 
1014         return _tokenApprovals[tokenId];
1015     }
1016 
1017     /**
1018      * dev See {IERC721-setApprovalForAll}.
1019      */
1020     function setApprovalForAll(address operator, bool approved) public virtual override {
1021         if (operator == _msgSender()) revert ApproveToCaller();
1022 
1023         _operatorApprovals[_msgSender()][operator] = approved;
1024         emit ApprovalForAll(_msgSender(), operator, approved);
1025     }
1026 
1027     /**
1028      * dev See {IERC721-isApprovedForAll}.
1029      */
1030     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1031         return _operatorApprovals[owner][operator];
1032     }
1033 
1034     /**
1035      * dev See {IERC721-transferFrom}.
1036      */
1037     function transferFrom(
1038         address from,
1039         address to,
1040         uint256 tokenId
1041     ) public virtual override {
1042         _transfer(from, to, tokenId);
1043     }
1044 
1045     /**
1046      * dev See {IERC721-safeTransferFrom}.
1047      */
1048     function safeTransferFrom(
1049         address from,
1050         address to,
1051         uint256 tokenId
1052     ) public virtual override {
1053         safeTransferFrom(from, to, tokenId, '');
1054     }
1055 
1056     /**
1057      * dev See {IERC721-safeTransferFrom}.
1058      */
1059     function safeTransferFrom(
1060         address from,
1061         address to,
1062         uint256 tokenId,
1063         bytes memory _data
1064     ) public virtual override {
1065         _transfer(from, to, tokenId);
1066         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1067             revert TransferToNonERC721ReceiverImplementer();
1068         }
1069     }
1070 
1071     /**
1072      * dev Returns whether `tokenId` exists.
1073      *
1074      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1075      *
1076      * Tokens start existing when they are minted (`_mint`),
1077      */
1078     function _exists(uint256 tokenId) internal view returns (bool) {
1079         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1080             !_ownerships[tokenId].burned;
1081     }
1082 
1083     function _safeMint(address to, uint256 quantity) internal {
1084         _safeMint(to, quantity, '');
1085     }
1086 
1087     /**
1088      * dev Safely mints `quantity` tokens and transfers them to `to`.
1089      *
1090      * Requirements:
1091      *
1092      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1093      * - `quantity` must be greater than 0.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function _safeMint(
1098         address to,
1099         uint256 quantity,
1100         bytes memory _data
1101     ) internal {
1102         _mint(to, quantity, _data, true);
1103     }
1104 
1105     /**
1106      * dev Mints `quantity` tokens and transfers them to `to`.
1107      *
1108      * Requirements:
1109      *
1110      * - `to` cannot be the zero address.
1111      * - `quantity` must be greater than 0.
1112      *
1113      * Emits a {Transfer} event.
1114      */
1115     function _mint(
1116         address to,
1117         uint256 quantity,
1118         bytes memory _data,
1119         bool safe
1120     ) internal {
1121         uint256 startTokenId = _currentIndex;
1122         if (to == address(0)) revert MintToZeroAddress();
1123         if (quantity == 0) revert MintZeroQuantity();
1124 
1125         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1126 
1127         // Overflows are incredibly unrealistic.
1128         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1129         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1130         unchecked {
1131             _addressData[to].balance += uint64(quantity);
1132             _addressData[to].numberMinted += uint64(quantity);
1133 
1134             _ownerships[startTokenId].addr = to;
1135             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1136 
1137             uint256 updatedIndex = startTokenId;
1138             uint256 end = updatedIndex + quantity;
1139 
1140             if (safe && to.isContract()) {
1141                 do {
1142                     emit Transfer(address(0), to, updatedIndex);
1143                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1144                         revert TransferToNonERC721ReceiverImplementer();
1145                     }
1146                 } while (updatedIndex != end);
1147                 // Reentrancy protection
1148                 if (_currentIndex != startTokenId) revert();
1149             } else {
1150                 do {
1151                     emit Transfer(address(0), to, updatedIndex++);
1152                 } while (updatedIndex != end);
1153             }
1154             _currentIndex = updatedIndex;
1155         }
1156         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1157     }
1158 
1159     /**
1160      * dev Transfers `tokenId` from `from` to `to`.
1161      *
1162      * Requirements:
1163      *
1164      * - `to` cannot be the zero address.
1165      * - `tokenId` token must be owned by `from`.
1166      *
1167      * Emits a {Transfer} event.
1168      */
1169     function _transfer(
1170         address from,
1171         address to,
1172         uint256 tokenId
1173     ) private {
1174         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1175 
1176         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1177 
1178         bool isApprovedOrOwner = (_msgSender() == from ||
1179             isApprovedForAll(from, _msgSender()) ||
1180             getApproved(tokenId) == _msgSender());
1181 
1182         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1183         if (to == address(0)) revert TransferToZeroAddress();
1184 
1185         _beforeTokenTransfers(from, to, tokenId, 1);
1186 
1187         // Clear approvals from the previous owner
1188         _approve(address(0), tokenId, from);
1189 
1190         // Underflow of the sender's balance is impossible because we check for
1191         // ownership above and the recipient's balance can't realistically overflow.
1192         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1193         unchecked {
1194             _addressData[from].balance -= 1;
1195             _addressData[to].balance += 1;
1196 
1197             TokenOwnership storage currSlot = _ownerships[tokenId];
1198             currSlot.addr = to;
1199             currSlot.startTimestamp = uint64(block.timestamp);
1200 
1201             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1202             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1203             uint256 nextTokenId = tokenId + 1;
1204             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1205             if (nextSlot.addr == address(0)) {
1206                 // This will suffice for checking _exists(nextTokenId),
1207                 // as a burned slot cannot contain the zero address.
1208                 if (nextTokenId != _currentIndex) {
1209                     nextSlot.addr = from;
1210                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1211                 }
1212             }
1213         }
1214 
1215         emit Transfer(from, to, tokenId);
1216         _afterTokenTransfers(from, to, tokenId, 1);
1217     }
1218 
1219     /**
1220      * dev This is equivalent to _burn(tokenId, false)
1221      */
1222     function _burn(uint256 tokenId) internal virtual {
1223         _burn(tokenId, false);
1224     }
1225 
1226     /**
1227      * dev Destroys `tokenId`.
1228      * The approval is cleared when the token is burned.
1229      *
1230      * Requirements:
1231      *
1232      * - `tokenId` must exist.
1233      *
1234      * Emits a {Transfer} event.
1235      */
1236     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1237         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1238 
1239         address from = prevOwnership.addr;
1240 
1241         if (approvalCheck) {
1242             bool isApprovedOrOwner = (_msgSender() == from ||
1243                 isApprovedForAll(from, _msgSender()) ||
1244                 getApproved(tokenId) == _msgSender());
1245 
1246             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1247         }
1248 
1249         _beforeTokenTransfers(from, address(0), tokenId, 1);
1250 
1251         // Clear approvals from the previous owner
1252         _approve(address(0), tokenId, from);
1253 
1254         // Underflow of the sender's balance is impossible because we check for
1255         // ownership above and the recipient's balance can't realistically overflow.
1256         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1257         unchecked {
1258             AddressData storage addressData = _addressData[from];
1259             addressData.balance -= 1;
1260             addressData.numberBurned += 1;
1261 
1262             // Keep track of who burned the token, and the timestamp of burning.
1263             TokenOwnership storage currSlot = _ownerships[tokenId];
1264             currSlot.addr = from;
1265             currSlot.startTimestamp = uint64(block.timestamp);
1266             currSlot.burned = true;
1267 
1268             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1269             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1270             uint256 nextTokenId = tokenId + 1;
1271             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1272             if (nextSlot.addr == address(0)) {
1273                 // This will suffice for checking _exists(nextTokenId),
1274                 // as a burned slot cannot contain the zero address.
1275                 if (nextTokenId != _currentIndex) {
1276                     nextSlot.addr = from;
1277                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1278                 }
1279             }
1280         }
1281 
1282         emit Transfer(from, address(0), tokenId);
1283         _afterTokenTransfers(from, address(0), tokenId, 1);
1284 
1285         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1286         unchecked {
1287             _burnCounter++;
1288         }
1289     }
1290 
1291     /**
1292      * dev Approve `to` to operate on `tokenId`
1293      *
1294      * Emits a {Approval} event.
1295      */
1296     function _approve(
1297         address to,
1298         uint256 tokenId,
1299         address owner
1300     ) private {
1301         _tokenApprovals[tokenId] = to;
1302         emit Approval(owner, to, tokenId);
1303     }
1304 
1305     /**
1306      * dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1307      *
1308      * @param from address representing the previous owner of the given token ID
1309      * @param to target address that will receive the tokens
1310      * @param tokenId uint256 ID of the token to be transferred
1311      * @param _data bytes optional data to send along with the call
1312      * @return bool whether the call correctly returned the expected magic value
1313      */
1314     function _checkContractOnERC721Received(
1315         address from,
1316         address to,
1317         uint256 tokenId,
1318         bytes memory _data
1319     ) private returns (bool) {
1320         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1321             return retval == IERC721Receiver(to).onERC721Received.selector;
1322         } catch (bytes memory reason) {
1323             if (reason.length == 0) {
1324                 revert TransferToNonERC721ReceiverImplementer();
1325             } else {
1326                 assembly {
1327                     revert(add(32, reason), mload(reason))
1328                 }
1329             }
1330         }
1331     }
1332 
1333     /**
1334      * dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1335      * And also called before burning one token.
1336      *
1337      * startTokenId - the first token id to be transferred
1338      * quantity - the amount to be transferred
1339      *
1340      * Calling conditions:
1341      *
1342      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1343      * transferred to `to`.
1344      * - When `from` is zero, `tokenId` will be minted for `to`.
1345      * - When `to` is zero, `tokenId` will be burned by `from`.
1346      * - `from` and `to` are never both zero.
1347      */
1348     function _beforeTokenTransfers(
1349         address from,
1350         address to,
1351         uint256 startTokenId,
1352         uint256 quantity
1353     ) internal virtual {}
1354 
1355     /**
1356      * dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1357      * minting.
1358      * And also called after one token has been burned.
1359      *
1360      * startTokenId - the first token id to be transferred
1361      * quantity - the amount to be transferred
1362      *
1363      * Calling conditions:
1364      *
1365      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1366      * transferred to `to`.
1367      * - When `from` is zero, `tokenId` has been minted for `to`.
1368      * - When `to` is zero, `tokenId` has been burned by `from`.
1369      * - `from` and `to` are never both zero.
1370      */
1371     function _afterTokenTransfers(
1372         address from,
1373         address to,
1374         uint256 startTokenId,
1375         uint256 quantity
1376     ) internal virtual {}
1377 }
1378 
1379 
1380 
1381 pragma solidity >=0.8.9 <0.9.0;
1382 
1383 
1384 contract RealChubbySeals is ERC721A, Ownable, ReentrancyGuard {
1385 
1386   using Strings for uint256;
1387 
1388   string public uriPrefix = '';
1389   string public uriSuffix = '.json';
1390   
1391   uint256 public cost;
1392   uint256 public freeMintSupply;
1393   uint256 public maxSupply;
1394   uint256 public maxMintAmountPerWallet;
1395 
1396   bool public paused = true;
1397 
1398   mapping(address => uint256) private _walletMints;
1399   mapping(address => uint256) private _freeWalletMints;
1400 
1401   constructor(
1402     string memory _tokenName,
1403     string memory _tokenSymbol,
1404     uint256 _cost,
1405     uint256 _freeMintSupply,
1406     uint256 _maxSupply,
1407     uint256 _maxMintAmountPerWallet,
1408     string memory _uriPrefix
1409   ) ERC721A(_tokenName, _tokenSymbol) {
1410     setCost(_cost);
1411     setFreeMint(_freeMintSupply);
1412     maxSupply = _maxSupply;
1413     setMaxMintAmountPerWallet(_maxMintAmountPerWallet);
1414     setUriPrefix(_uriPrefix);
1415     _safeMint(_msgSender(), 4);
1416   }
1417 
1418   modifier mintCompliance(uint256 _mintAmount) {
1419     require(_mintAmount > 0 && _walletMints[_msgSender()] + _mintAmount < maxMintAmountPerWallet + 1, 'Invalid mint amount!');
1420     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1421     require(totalSupply() >= freeMintSupply, 'Free mint not finished yet!');
1422     _;
1423   }
1424 
1425   modifier freeMintCompliance() {
1426     require(_freeWalletMints[_msgSender()] + 1 <= 1, 'You have already minted');
1427     require(totalSupply() + 1 <= freeMintSupply, 'Max free mint supply exceeded!');
1428     _;
1429   }
1430 
1431   modifier mintPriceCompliance(uint256 _mintAmount) {
1432     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1433     _;
1434   }
1435 
1436   function freeMint() public freeMintCompliance {
1437     require(!paused, 'The contract is paused!');
1438 
1439     _freeWalletMints[_msgSender()] += 1;
1440     _safeMint(_msgSender(), 1);
1441   }
1442 
1443 
1444   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1445     require(!paused, 'The contract is paused!');
1446 
1447     _walletMints[_msgSender()] += _mintAmount;
1448     _safeMint(_msgSender(), _mintAmount);
1449   }
1450 
1451   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1452     uint256 ownerTokenCount = balanceOf(_owner);
1453     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1454     uint256 currentTokenId = _startTokenId();
1455     uint256 ownedTokenIndex = 0;
1456     address latestOwnerAddress;
1457 
1458     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1459       TokenOwnership memory ownership = _ownerships[currentTokenId];
1460 
1461       if (!ownership.burned && ownership.addr != address(0)) {
1462         latestOwnerAddress = ownership.addr;
1463       }
1464 
1465       if (latestOwnerAddress == _owner) {
1466         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1467 
1468         ownedTokenIndex++;
1469       }
1470 
1471       currentTokenId++;
1472     }
1473 
1474     return ownedTokenIds;
1475   }
1476 
1477   function _startTokenId() internal view virtual override returns (uint256) {
1478     return 1;
1479   }
1480 
1481   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1482     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1483 
1484     string memory currentBaseURI = _baseURI();
1485     return bytes(currentBaseURI).length > 0
1486         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1487         : '';
1488   }
1489 
1490   function setCost(uint256 _cost) public onlyOwner {
1491     cost = _cost;
1492   }
1493 
1494   function setFreeMint(uint256 _supply) public onlyOwner {
1495     freeMintSupply = _supply;
1496   }
1497 
1498   function setMaxMintAmountPerWallet(uint256 _maxMintAmountPerWallet) public onlyOwner {
1499     maxMintAmountPerWallet = _maxMintAmountPerWallet;
1500   }
1501 
1502   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1503     uriPrefix = _uriPrefix;
1504   }
1505 
1506   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1507     uriSuffix = _uriSuffix;
1508   }
1509 
1510   function setPaused(bool _state) public onlyOwner {
1511     paused = _state;
1512   }
1513 
1514   function withdraw() public onlyOwner nonReentrant {
1515 
1516     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1517     require(os);
1518   }
1519 
1520   function _baseURI() internal view virtual override returns (string memory) {
1521     return uriPrefix;
1522   }
1523 }