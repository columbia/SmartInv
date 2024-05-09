1 // SPDX-License-Identifier: MIT
2 /***
3  *        .---.                                                                                                  
4  *        |   |                                                                                                  
5  *        '---'      __.....__                          __.....__                   __.....__                    
6  *        .---.  .-''         '.                    .-''         '.             .-''         '.                  
7  *        |   | /     .-''"'-.  `.            .|   /     .-''"'-.  `. .-,.--.  /     .-''"'-.  `. .-,.--.        
8  *        |   |/     /________\   \         .' |_ /     /________\   \|  .-. |/     /________\   \|  .-. |       
9  *        |   ||                  |    _  .'     ||                  || |  | ||                  || |  | |  _    
10  *        |   |\    .-------------'  .' |'--.  .-'\    .-------------'| |  | |\    .-------------'| |  | |.' |   
11  *        |   | \    '-.____...---. .   | / |  |   \    '-.____...---.| |  '-  \    '-.____...---.| |  '-.   | / 
12  *        |   |  `.             .'.'.'| |// |  |    `.             .' | |       `.             .' | |  .'.'| |// 
13  *     __.'   '    `''-...... -'.'.'.-'  /  |  '.'    `''-...... -'   | |         `''-...... -'   | |.'.'.-'  /  
14  *    |      '                  .'   \_.'   |   /                     |_|                         |_|.'   \_.'   
15  *    |____.'                               `'-'                                                                 
16  */
17 
18 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
19 
20 
21 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev Contract module that helps prevent reentrant calls to a function.
27  *
28  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
29  * available, which can be applied to functions to make sure there are no nested
30  * (reentrant) calls to them.
31  *
32  * Note that because there is a single `nonReentrant` guard, functions marked as
33  * `nonReentrant` may not call one another. This can be worked around by making
34  * those functions `private`, and then adding `external` `nonReentrant` entry
35  * points to them.
36  *
37  * TIP: If you would like to learn more about reentrancy and alternative ways
38  * to protect against it, check out our blog post
39  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
40  */
41 abstract contract ReentrancyGuard {
42     // Booleans are more expensive than uint256 or any type that takes up a full
43     // word because each write operation emits an extra SLOAD to first read the
44     // slot's contents, replace the bits taken up by the boolean, and then write
45     // back. This is the compiler's defense against contract upgrades and
46     // pointer aliasing, and it cannot be disabled.
47 
48     // The values being non-zero value makes deployment a bit more expensive,
49     // but in exchange the refund on every call to nonReentrant will be lower in
50     // amount. Since refunds are capped to a percentage of the total
51     // transaction's gas, it is best to keep them low in cases like this one, to
52     // increase the likelihood of the full refund coming into effect.
53     uint256 private constant _NOT_ENTERED = 1;
54     uint256 private constant _ENTERED = 2;
55 
56     uint256 private _status;
57 
58     constructor() {
59         _status = _NOT_ENTERED;
60     }
61 
62     /**
63      * @dev Prevents a contract from calling itself, directly or indirectly.
64      * Calling a `nonReentrant` function from another `nonReentrant`
65      * function is not supported. It is possible to prevent this from happening
66      * by making the `nonReentrant` function external, and making it call a
67      * `private` function that does the actual work.
68      */
69     modifier nonReentrant() {
70         // On the first call to nonReentrant, _notEntered will be true
71         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
72 
73         // Any calls to nonReentrant after this point will fail
74         _status = _ENTERED;
75 
76         _;
77 
78         // By storing the original value once again, a refund is triggered (see
79         // https://eips.ethereum.org/EIPS/eip-2200)
80         _status = _NOT_ENTERED;
81     }
82 }
83 
84 // File: @openzeppelin/contracts/utils/Strings.sol
85 
86 
87 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev String operations.
93  */
94 library Strings {
95     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
96     uint8 private constant _ADDRESS_LENGTH = 20;
97 
98     /**
99      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
100      */
101     function toString(uint256 value) internal pure returns (string memory) {
102         // Inspired by OraclizeAPI's implementation - MIT licence
103         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
104 
105         if (value == 0) {
106             return "0";
107         }
108         uint256 temp = value;
109         uint256 digits;
110         while (temp != 0) {
111             digits++;
112             temp /= 10;
113         }
114         bytes memory buffer = new bytes(digits);
115         while (value != 0) {
116             digits -= 1;
117             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
118             value /= 10;
119         }
120         return string(buffer);
121     }
122 
123     /**
124      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
125      */
126     function toHexString(uint256 value) internal pure returns (string memory) {
127         if (value == 0) {
128             return "0x00";
129         }
130         uint256 temp = value;
131         uint256 length = 0;
132         while (temp != 0) {
133             length++;
134             temp >>= 8;
135         }
136         return toHexString(value, length);
137     }
138 
139     /**
140      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
141      */
142     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
143         bytes memory buffer = new bytes(2 * length + 2);
144         buffer[0] = "0";
145         buffer[1] = "x";
146         for (uint256 i = 2 * length + 1; i > 1; --i) {
147             buffer[i] = _HEX_SYMBOLS[value & 0xf];
148             value >>= 4;
149         }
150         require(value == 0, "Strings: hex length insufficient");
151         return string(buffer);
152     }
153 
154     /**
155      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
156      */
157     function toHexString(address addr) internal pure returns (string memory) {
158         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
159     }
160 }
161 
162 // File: @openzeppelin/contracts/utils/Context.sol
163 
164 
165 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
166 
167 pragma solidity ^0.8.0;
168 
169 /**
170  * @dev Provides information about the current execution context, including the
171  * sender of the transaction and its data. While these are generally available
172  * via msg.sender and msg.data, they should not be accessed in such a direct
173  * manner, since when dealing with meta-transactions the account sending and
174  * paying for execution may not be the actual sender (as far as an application
175  * is concerned).
176  *
177  * This contract is only required for intermediate, library-like contracts.
178  */
179 abstract contract Context {
180     function _msgSender() internal view virtual returns (address) {
181         return msg.sender;
182     }
183 
184     function _msgData() internal view virtual returns (bytes calldata) {
185         return msg.data;
186     }
187 }
188 
189 // File: @openzeppelin/contracts/access/Ownable.sol
190 
191 
192 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
193 
194 pragma solidity ^0.8.0;
195 
196 
197 /**
198  * @dev Contract module which provides a basic access control mechanism, where
199  * there is an account (an owner) that can be granted exclusive access to
200  * specific functions.
201  *
202  * By default, the owner account will be the one that deploys the contract. This
203  * can later be changed with {transferOwnership}.
204  *
205  * This module is used through inheritance. It will make available the modifier
206  * `onlyOwner`, which can be applied to your functions to restrict their use to
207  * the owner.
208  */
209 abstract contract Ownable is Context {
210     address private _owner;
211 
212     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
213 
214     /**
215      * @dev Initializes the contract setting the deployer as the initial owner.
216      */
217     constructor() {
218         _transferOwnership(_msgSender());
219     }
220 
221     /**
222      * @dev Throws if called by any account other than the owner.
223      */
224     modifier onlyOwner() {
225         _checkOwner();
226         _;
227     }
228 
229     /**
230      * @dev Returns the address of the current owner.
231      */
232     function owner() public view virtual returns (address) {
233         return _owner;
234     }
235 
236     /**
237      * @dev Throws if the sender is not the owner.
238      */
239     function _checkOwner() internal view virtual {
240         require(owner() == _msgSender(), "Ownable: caller is not the owner");
241     }
242 
243     /**
244      * @dev Leaves the contract without owner. It will not be possible to call
245      * `onlyOwner` functions anymore. Can only be called by the current owner.
246      *
247      * NOTE: Renouncing ownership will leave the contract without an owner,
248      * thereby removing any functionality that is only available to the owner.
249      */
250     function renounceOwnership() public virtual onlyOwner {
251         _transferOwnership(address(0));
252     }
253 
254     /**
255      * @dev Transfers ownership of the contract to a new account (`newOwner`).
256      * Can only be called by the current owner.
257      */
258     function transferOwnership(address newOwner) public virtual onlyOwner {
259         require(newOwner != address(0), "Ownable: new owner is the zero address");
260         _transferOwnership(newOwner);
261     }
262 
263     /**
264      * @dev Transfers ownership of the contract to a new account (`newOwner`).
265      * Internal function without access restriction.
266      */
267     function _transferOwnership(address newOwner) internal virtual {
268         address oldOwner = _owner;
269         _owner = newOwner;
270         emit OwnershipTransferred(oldOwner, newOwner);
271     }
272 }
273 
274 // File: @openzeppelin/contracts/utils/Address.sol
275 
276 
277 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
278 
279 pragma solidity ^0.8.1;
280 
281 /**
282  * @dev Collection of functions related to the address type
283  */
284 library Address {
285     /**
286      * @dev Returns true if `account` is a contract.
287      *
288      * [IMPORTANT]
289      * ====
290      * It is unsafe to assume that an address for which this function returns
291      * false is an externally-owned account (EOA) and not a contract.
292      *
293      * Among others, `isContract` will return false for the following
294      * types of addresses:
295      *
296      *  - an externally-owned account
297      *  - a contract in construction
298      *  - an address where a contract will be created
299      *  - an address where a contract lived, but was destroyed
300      * ====
301      *
302      * [IMPORTANT]
303      * ====
304      * You shouldn't rely on `isContract` to protect against flash loan attacks!
305      *
306      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
307      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
308      * constructor.
309      * ====
310      */
311     function isContract(address account) internal view returns (bool) {
312         // This method relies on extcodesize/address.code.length, which returns 0
313         // for contracts in construction, since the code is only stored at the end
314         // of the constructor execution.
315 
316         return account.code.length > 0;
317     }
318 
319     /**
320      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
321      * `recipient`, forwarding all available gas and reverting on errors.
322      *
323      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
324      * of certain opcodes, possibly making contracts go over the 2300 gas limit
325      * imposed by `transfer`, making them unable to receive funds via
326      * `transfer`. {sendValue} removes this limitation.
327      *
328      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
329      *
330      * IMPORTANT: because control is transferred to `recipient`, care must be
331      * taken to not create reentrancy vulnerabilities. Consider using
332      * {ReentrancyGuard} or the
333      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
334      */
335     function sendValue(address payable recipient, uint256 amount) internal {
336         require(address(this).balance >= amount, "Address: insufficient balance");
337 
338         (bool success, ) = recipient.call{value: amount}("");
339         require(success, "Address: unable to send value, recipient may have reverted");
340     }
341 
342     /**
343      * @dev Performs a Solidity function call using a low level `call`. A
344      * plain `call` is an unsafe replacement for a function call: use this
345      * function instead.
346      *
347      * If `target` reverts with a revert reason, it is bubbled up by this
348      * function (like regular Solidity function calls).
349      *
350      * Returns the raw returned data. To convert to the expected return value,
351      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
352      *
353      * Requirements:
354      *
355      * - `target` must be a contract.
356      * - calling `target` with `data` must not revert.
357      *
358      * _Available since v3.1._
359      */
360     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
361         return functionCall(target, data, "Address: low-level call failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
366      * `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCall(
371         address target,
372         bytes memory data,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, 0, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380      * but also transferring `value` wei to `target`.
381      *
382      * Requirements:
383      *
384      * - the calling contract must have an ETH balance of at least `value`.
385      * - the called Solidity function must be `payable`.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(
390         address target,
391         bytes memory data,
392         uint256 value
393     ) internal returns (bytes memory) {
394         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
399      * with `errorMessage` as a fallback revert reason when `target` reverts.
400      *
401      * _Available since v3.1._
402      */
403     function functionCallWithValue(
404         address target,
405         bytes memory data,
406         uint256 value,
407         string memory errorMessage
408     ) internal returns (bytes memory) {
409         require(address(this).balance >= value, "Address: insufficient balance for call");
410         require(isContract(target), "Address: call to non-contract");
411 
412         (bool success, bytes memory returndata) = target.call{value: value}(data);
413         return verifyCallResult(success, returndata, errorMessage);
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
418      * but performing a static call.
419      *
420      * _Available since v3.3._
421      */
422     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
423         return functionStaticCall(target, data, "Address: low-level static call failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
428      * but performing a static call.
429      *
430      * _Available since v3.3._
431      */
432     function functionStaticCall(
433         address target,
434         bytes memory data,
435         string memory errorMessage
436     ) internal view returns (bytes memory) {
437         require(isContract(target), "Address: static call to non-contract");
438 
439         (bool success, bytes memory returndata) = target.staticcall(data);
440         return verifyCallResult(success, returndata, errorMessage);
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
445      * but performing a delegate call.
446      *
447      * _Available since v3.4._
448      */
449     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
450         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
455      * but performing a delegate call.
456      *
457      * _Available since v3.4._
458      */
459     function functionDelegateCall(
460         address target,
461         bytes memory data,
462         string memory errorMessage
463     ) internal returns (bytes memory) {
464         require(isContract(target), "Address: delegate call to non-contract");
465 
466         (bool success, bytes memory returndata) = target.delegatecall(data);
467         return verifyCallResult(success, returndata, errorMessage);
468     }
469 
470     /**
471      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
472      * revert reason using the provided one.
473      *
474      * _Available since v4.3._
475      */
476     function verifyCallResult(
477         bool success,
478         bytes memory returndata,
479         string memory errorMessage
480     ) internal pure returns (bytes memory) {
481         if (success) {
482             return returndata;
483         } else {
484             // Look for revert reason and bubble it up if present
485             if (returndata.length > 0) {
486                 // The easiest way to bubble the revert reason is using memory via assembly
487                 /// @solidity memory-safe-assembly
488                 assembly {
489                     let returndata_size := mload(returndata)
490                     revert(add(32, returndata), returndata_size)
491                 }
492             } else {
493                 revert(errorMessage);
494             }
495         }
496     }
497 }
498 
499 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
500 
501 
502 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
503 
504 pragma solidity ^0.8.0;
505 
506 /**
507  * @title ERC721 token receiver interface
508  * @dev Interface for any contract that wants to support safeTransfers
509  * from ERC721 asset contracts.
510  */
511 interface IERC721Receiver {
512     /**
513      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
514      * by `operator` from `from`, this function is called.
515      *
516      * It must return its Solidity selector to confirm the token transfer.
517      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
518      *
519      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
520      */
521     function onERC721Received(
522         address operator,
523         address from,
524         uint256 tokenId,
525         bytes calldata data
526     ) external returns (bytes4);
527 }
528 
529 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
530 
531 
532 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 /**
537  * @dev Interface of the ERC165 standard, as defined in the
538  * https://eips.ethereum.org/EIPS/eip-165[EIP].
539  *
540  * Implementers can declare support of contract interfaces, which can then be
541  * queried by others ({ERC165Checker}).
542  *
543  * For an implementation, see {ERC165}.
544  */
545 interface IERC165 {
546     /**
547      * @dev Returns true if this contract implements the interface defined by
548      * `interfaceId`. See the corresponding
549      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
550      * to learn more about how these ids are created.
551      *
552      * This function call must use less than 30 000 gas.
553      */
554     function supportsInterface(bytes4 interfaceId) external view returns (bool);
555 }
556 
557 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
558 
559 
560 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 
565 /**
566  * @dev Implementation of the {IERC165} interface.
567  *
568  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
569  * for the additional interface id that will be supported. For example:
570  *
571  * ```solidity
572  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
573  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
574  * }
575  * ```
576  *
577  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
578  */
579 abstract contract ERC165 is IERC165 {
580     /**
581      * @dev See {IERC165-supportsInterface}.
582      */
583     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
584         return interfaceId == type(IERC165).interfaceId;
585     }
586 }
587 
588 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
589 
590 
591 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 
596 /**
597  * @dev Required interface of an ERC721 compliant contract.
598  */
599 interface IERC721 is IERC165 {
600     /**
601      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
602      */
603     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
604 
605     /**
606      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
607      */
608     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
609 
610     /**
611      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
612      */
613     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
614 
615     /**
616      * @dev Returns the number of tokens in ``owner``'s account.
617      */
618     function balanceOf(address owner) external view returns (uint256 balance);
619 
620     /**
621      * @dev Returns the owner of the `tokenId` token.
622      *
623      * Requirements:
624      *
625      * - `tokenId` must exist.
626      */
627     function ownerOf(uint256 tokenId) external view returns (address owner);
628 
629     /**
630      * @dev Safely transfers `tokenId` token from `from` to `to`.
631      *
632      * Requirements:
633      *
634      * - `from` cannot be the zero address.
635      * - `to` cannot be the zero address.
636      * - `tokenId` token must exist and be owned by `from`.
637      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
638      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
639      *
640      * Emits a {Transfer} event.
641      */
642     function safeTransferFrom(
643         address from,
644         address to,
645         uint256 tokenId,
646         bytes calldata data
647     ) external;
648 
649     /**
650      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
651      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
652      *
653      * Requirements:
654      *
655      * - `from` cannot be the zero address.
656      * - `to` cannot be the zero address.
657      * - `tokenId` token must exist and be owned by `from`.
658      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
659      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
660      *
661      * Emits a {Transfer} event.
662      */
663     function safeTransferFrom(
664         address from,
665         address to,
666         uint256 tokenId
667     ) external;
668 
669     /**
670      * @dev Transfers `tokenId` token from `from` to `to`.
671      *
672      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
673      *
674      * Requirements:
675      *
676      * - `from` cannot be the zero address.
677      * - `to` cannot be the zero address.
678      * - `tokenId` token must be owned by `from`.
679      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
680      *
681      * Emits a {Transfer} event.
682      */
683     function transferFrom(
684         address from,
685         address to,
686         uint256 tokenId
687     ) external;
688 
689     /**
690      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
691      * The approval is cleared when the token is transferred.
692      *
693      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
694      *
695      * Requirements:
696      *
697      * - The caller must own the token or be an approved operator.
698      * - `tokenId` must exist.
699      *
700      * Emits an {Approval} event.
701      */
702     function approve(address to, uint256 tokenId) external;
703 
704     /**
705      * @dev Approve or remove `operator` as an operator for the caller.
706      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
707      *
708      * Requirements:
709      *
710      * - The `operator` cannot be the caller.
711      *
712      * Emits an {ApprovalForAll} event.
713      */
714     function setApprovalForAll(address operator, bool _approved) external;
715 
716     /**
717      * @dev Returns the account approved for `tokenId` token.
718      *
719      * Requirements:
720      *
721      * - `tokenId` must exist.
722      */
723     function getApproved(uint256 tokenId) external view returns (address operator);
724 
725     /**
726      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
727      *
728      * See {setApprovalForAll}
729      */
730     function isApprovedForAll(address owner, address operator) external view returns (bool);
731 }
732 
733 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
734 
735 
736 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
737 
738 pragma solidity ^0.8.0;
739 
740 
741 /**
742  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
743  * @dev See https://eips.ethereum.org/EIPS/eip-721
744  */
745 interface IERC721Metadata is IERC721 {
746     /**
747      * @dev Returns the token collection name.
748      */
749     function name() external view returns (string memory);
750 
751     /**
752      * @dev Returns the token collection symbol.
753      */
754     function symbol() external view returns (string memory);
755 
756     /**
757      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
758      */
759     function tokenURI(uint256 tokenId) external view returns (string memory);
760 }
761 
762 // File: erc721a/contracts/IERC721A.sol
763 
764 
765 // ERC721A Contracts v4.2.3
766 // Creator: Chiru Labs
767 
768 pragma solidity ^0.8.4;
769 
770 /**
771  * @dev Interface of ERC721A.
772  */
773 interface IERC721A {
774     /**
775      * The caller must own the token or be an approved operator.
776      */
777     error ApprovalCallerNotOwnerNorApproved();
778 
779     /**
780      * The token does not exist.
781      */
782     error ApprovalQueryForNonexistentToken();
783 
784     /**
785      * Cannot query the balance for the zero address.
786      */
787     error BalanceQueryForZeroAddress();
788 
789     /**
790      * Cannot mint to the zero address.
791      */
792     error MintToZeroAddress();
793 
794     /**
795      * The quantity of tokens minted must be more than zero.
796      */
797     error MintZeroQuantity();
798 
799     /**
800      * The token does not exist.
801      */
802     error OwnerQueryForNonexistentToken();
803 
804     /**
805      * The caller must own the token or be an approved operator.
806      */
807     error TransferCallerNotOwnerNorApproved();
808 
809     /**
810      * The token must be owned by `from`.
811      */
812     error TransferFromIncorrectOwner();
813 
814     /**
815      * Cannot safely transfer to a contract that does not implement the
816      * ERC721Receiver interface.
817      */
818     error TransferToNonERC721ReceiverImplementer();
819 
820     /**
821      * Cannot transfer to the zero address.
822      */
823     error TransferToZeroAddress();
824 
825     /**
826      * The token does not exist.
827      */
828     error URIQueryForNonexistentToken();
829 
830     /**
831      * The `quantity` minted with ERC2309 exceeds the safety limit.
832      */
833     error MintERC2309QuantityExceedsLimit();
834 
835     /**
836      * The `extraData` cannot be set on an unintialized ownership slot.
837      */
838     error OwnershipNotInitializedForExtraData();
839 
840     // =============================================================
841     //                            STRUCTS
842     // =============================================================
843 
844     struct TokenOwnership {
845         // The address of the owner.
846         address addr;
847         // Stores the start time of ownership with minimal overhead for tokenomics.
848         uint64 startTimestamp;
849         // Whether the token has been burned.
850         bool burned;
851         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
852         uint24 extraData;
853     }
854 
855     // =============================================================
856     //                         TOKEN COUNTERS
857     // =============================================================
858 
859     /**
860      * @dev Returns the total number of tokens in existence.
861      * Burned tokens will reduce the count.
862      * To get the total number of tokens minted, please see {_totalMinted}.
863      */
864     function totalSupply() external view returns (uint256);
865 
866     // =============================================================
867     //                            IERC165
868     // =============================================================
869 
870     /**
871      * @dev Returns true if this contract implements the interface defined by
872      * `interfaceId`. See the corresponding
873      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
874      * to learn more about how these ids are created.
875      *
876      * This function call must use less than 30000 gas.
877      */
878     function supportsInterface(bytes4 interfaceId) external view returns (bool);
879 
880     // =============================================================
881     //                            IERC721
882     // =============================================================
883 
884     /**
885      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
886      */
887     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
888 
889     /**
890      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
891      */
892     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
893 
894     /**
895      * @dev Emitted when `owner` enables or disables
896      * (`approved`) `operator` to manage all of its assets.
897      */
898     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
899 
900     /**
901      * @dev Returns the number of tokens in `owner`'s account.
902      */
903     function balanceOf(address owner) external view returns (uint256 balance);
904 
905     /**
906      * @dev Returns the owner of the `tokenId` token.
907      *
908      * Requirements:
909      *
910      * - `tokenId` must exist.
911      */
912     function ownerOf(uint256 tokenId) external view returns (address owner);
913 
914     /**
915      * @dev Safely transfers `tokenId` token from `from` to `to`,
916      * checking first that contract recipients are aware of the ERC721 protocol
917      * to prevent tokens from being forever locked.
918      *
919      * Requirements:
920      *
921      * - `from` cannot be the zero address.
922      * - `to` cannot be the zero address.
923      * - `tokenId` token must exist and be owned by `from`.
924      * - If the caller is not `from`, it must be have been allowed to move
925      * this token by either {approve} or {setApprovalForAll}.
926      * - If `to` refers to a smart contract, it must implement
927      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
928      *
929      * Emits a {Transfer} event.
930      */
931     function safeTransferFrom(
932         address from,
933         address to,
934         uint256 tokenId,
935         bytes calldata data
936     ) external payable;
937 
938     /**
939      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId
945     ) external payable;
946 
947     /**
948      * @dev Transfers `tokenId` from `from` to `to`.
949      *
950      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
951      * whenever possible.
952      *
953      * Requirements:
954      *
955      * - `from` cannot be the zero address.
956      * - `to` cannot be the zero address.
957      * - `tokenId` token must be owned by `from`.
958      * - If the caller is not `from`, it must be approved to move this token
959      * by either {approve} or {setApprovalForAll}.
960      *
961      * Emits a {Transfer} event.
962      */
963     function transferFrom(
964         address from,
965         address to,
966         uint256 tokenId
967     ) external payable;
968 
969     /**
970      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
971      * The approval is cleared when the token is transferred.
972      *
973      * Only a single account can be approved at a time, so approving the
974      * zero address clears previous approvals.
975      *
976      * Requirements:
977      *
978      * - The caller must own the token or be an approved operator.
979      * - `tokenId` must exist.
980      *
981      * Emits an {Approval} event.
982      */
983     function approve(address to, uint256 tokenId) external payable;
984 
985     /**
986      * @dev Approve or remove `operator` as an operator for the caller.
987      * Operators can call {transferFrom} or {safeTransferFrom}
988      * for any token owned by the caller.
989      *
990      * Requirements:
991      *
992      * - The `operator` cannot be the caller.
993      *
994      * Emits an {ApprovalForAll} event.
995      */
996     function setApprovalForAll(address operator, bool _approved) external;
997 
998     /**
999      * @dev Returns the account approved for `tokenId` token.
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must exist.
1004      */
1005     function getApproved(uint256 tokenId) external view returns (address operator);
1006 
1007     /**
1008      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1009      *
1010      * See {setApprovalForAll}.
1011      */
1012     function isApprovedForAll(address owner, address operator) external view returns (bool);
1013 
1014     // =============================================================
1015     //                        IERC721Metadata
1016     // =============================================================
1017 
1018     /**
1019      * @dev Returns the token collection name.
1020      */
1021     function name() external view returns (string memory);
1022 
1023     /**
1024      * @dev Returns the token collection symbol.
1025      */
1026     function symbol() external view returns (string memory);
1027 
1028     /**
1029      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1030      */
1031     function tokenURI(uint256 tokenId) external view returns (string memory);
1032 
1033     // =============================================================
1034     //                           IERC2309
1035     // =============================================================
1036 
1037     /**
1038      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1039      * (inclusive) is transferred from `from` to `to`, as defined in the
1040      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1041      *
1042      * See {_mintERC2309} for more details.
1043      */
1044     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1045 }
1046 
1047 // File: erc721a/contracts/ERC721A.sol
1048 
1049 
1050 // ERC721A Contracts v4.2.3
1051 // Creator: Chiru Labs
1052 
1053 pragma solidity ^0.8.4;
1054 
1055 
1056 /**
1057  * @dev Interface of ERC721 token receiver.
1058  */
1059 interface ERC721A__IERC721Receiver {
1060     function onERC721Received(
1061         address operator,
1062         address from,
1063         uint256 tokenId,
1064         bytes calldata data
1065     ) external returns (bytes4);
1066 }
1067 
1068 /**
1069  * @title ERC721A
1070  *
1071  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1072  * Non-Fungible Token Standard, including the Metadata extension.
1073  * Optimized for lower gas during batch mints.
1074  *
1075  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1076  * starting from `_startTokenId()`.
1077  *
1078  * Assumptions:
1079  *
1080  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1081  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1082  */
1083 contract ERC721A is IERC721A {
1084     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1085     struct TokenApprovalRef {
1086         address value;
1087     }
1088 
1089     // =============================================================
1090     //                           CONSTANTS
1091     // =============================================================
1092 
1093     // Mask of an entry in packed address data.
1094     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1095 
1096     // The bit position of `numberMinted` in packed address data.
1097     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1098 
1099     // The bit position of `numberBurned` in packed address data.
1100     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1101 
1102     // The bit position of `aux` in packed address data.
1103     uint256 private constant _BITPOS_AUX = 192;
1104 
1105     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1106     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1107 
1108     // The bit position of `startTimestamp` in packed ownership.
1109     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1110 
1111     // The bit mask of the `burned` bit in packed ownership.
1112     uint256 private constant _BITMASK_BURNED = 1 << 224;
1113 
1114     // The bit position of the `nextInitialized` bit in packed ownership.
1115     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1116 
1117     // The bit mask of the `nextInitialized` bit in packed ownership.
1118     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1119 
1120     // The bit position of `extraData` in packed ownership.
1121     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1122 
1123     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1124     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1125 
1126     // The mask of the lower 160 bits for addresses.
1127     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1128 
1129     // The maximum `quantity` that can be minted with {_mintERC2309}.
1130     // This limit is to prevent overflows on the address data entries.
1131     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1132     // is required to cause an overflow, which is unrealistic.
1133     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1134 
1135     // The `Transfer` event signature is given by:
1136     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1137     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1138         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1139 
1140     // =============================================================
1141     //                            STORAGE
1142     // =============================================================
1143 
1144     // The next token ID to be minted.
1145     uint256 private _currentIndex;
1146 
1147     // The number of tokens burned.
1148     uint256 private _burnCounter;
1149 
1150     // Token name
1151     string private _name;
1152 
1153     // Token symbol
1154     string private _symbol;
1155 
1156     // Mapping from token ID to ownership details
1157     // An empty struct value does not necessarily mean the token is unowned.
1158     // See {_packedOwnershipOf} implementation for details.
1159     //
1160     // Bits Layout:
1161     // - [0..159]   `addr`
1162     // - [160..223] `startTimestamp`
1163     // - [224]      `burned`
1164     // - [225]      `nextInitialized`
1165     // - [232..255] `extraData`
1166     mapping(uint256 => uint256) private _packedOwnerships;
1167 
1168     // Mapping owner address to address data.
1169     //
1170     // Bits Layout:
1171     // - [0..63]    `balance`
1172     // - [64..127]  `numberMinted`
1173     // - [128..191] `numberBurned`
1174     // - [192..255] `aux`
1175     mapping(address => uint256) private _packedAddressData;
1176 
1177     // Mapping from token ID to approved address.
1178     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1179 
1180     // Mapping from owner to operator approvals
1181     mapping(address => mapping(address => bool)) private _operatorApprovals;
1182 
1183     // =============================================================
1184     //                          CONSTRUCTOR
1185     // =============================================================
1186 
1187     constructor(string memory name_, string memory symbol_) {
1188         _name = name_;
1189         _symbol = symbol_;
1190         _currentIndex = _startTokenId();
1191     }
1192 
1193     // =============================================================
1194     //                   TOKEN COUNTING OPERATIONS
1195     // =============================================================
1196 
1197     /**
1198      * @dev Returns the starting token ID.
1199      * To change the starting token ID, please override this function.
1200      */
1201     function _startTokenId() internal view virtual returns (uint256) {
1202         return 0;
1203     }
1204 
1205     /**
1206      * @dev Returns the next token ID to be minted.
1207      */
1208     function _nextTokenId() internal view virtual returns (uint256) {
1209         return _currentIndex;
1210     }
1211 
1212     /**
1213      * @dev Returns the total number of tokens in existence.
1214      * Burned tokens will reduce the count.
1215      * To get the total number of tokens minted, please see {_totalMinted}.
1216      */
1217     function totalSupply() public view virtual override returns (uint256) {
1218         // Counter underflow is impossible as _burnCounter cannot be incremented
1219         // more than `_currentIndex - _startTokenId()` times.
1220         unchecked {
1221             return _currentIndex - _burnCounter - _startTokenId();
1222         }
1223     }
1224 
1225     /**
1226      * @dev Returns the total amount of tokens minted in the contract.
1227      */
1228     function _totalMinted() internal view virtual returns (uint256) {
1229         // Counter underflow is impossible as `_currentIndex` does not decrement,
1230         // and it is initialized to `_startTokenId()`.
1231         unchecked {
1232             return _currentIndex - _startTokenId();
1233         }
1234     }
1235 
1236     /**
1237      * @dev Returns the total number of tokens burned.
1238      */
1239     function _totalBurned() internal view virtual returns (uint256) {
1240         return _burnCounter;
1241     }
1242 
1243     // =============================================================
1244     //                    ADDRESS DATA OPERATIONS
1245     // =============================================================
1246 
1247     /**
1248      * @dev Returns the number of tokens in `owner`'s account.
1249      */
1250     function balanceOf(address owner) public view virtual override returns (uint256) {
1251         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1252         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1253     }
1254 
1255     /**
1256      * Returns the number of tokens minted by `owner`.
1257      */
1258     function _numberMinted(address owner) internal view returns (uint256) {
1259         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1260     }
1261 
1262     /**
1263      * Returns the number of tokens burned by or on behalf of `owner`.
1264      */
1265     function _numberBurned(address owner) internal view returns (uint256) {
1266         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1267     }
1268 
1269     /**
1270      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1271      */
1272     function _getAux(address owner) internal view returns (uint64) {
1273         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1274     }
1275 
1276     /**
1277      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1278      * If there are multiple variables, please pack them into a uint64.
1279      */
1280     function _setAux(address owner, uint64 aux) internal virtual {
1281         uint256 packed = _packedAddressData[owner];
1282         uint256 auxCasted;
1283         // Cast `aux` with assembly to avoid redundant masking.
1284         assembly {
1285             auxCasted := aux
1286         }
1287         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1288         _packedAddressData[owner] = packed;
1289     }
1290 
1291     // =============================================================
1292     //                            IERC165
1293     // =============================================================
1294 
1295     /**
1296      * @dev Returns true if this contract implements the interface defined by
1297      * `interfaceId`. See the corresponding
1298      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1299      * to learn more about how these ids are created.
1300      *
1301      * This function call must use less than 30000 gas.
1302      */
1303     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1304         // The interface IDs are constants representing the first 4 bytes
1305         // of the XOR of all function selectors in the interface.
1306         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1307         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1308         return
1309             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1310             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1311             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1312     }
1313 
1314     // =============================================================
1315     //                        IERC721Metadata
1316     // =============================================================
1317 
1318     /**
1319      * @dev Returns the token collection name.
1320      */
1321     function name() public view virtual override returns (string memory) {
1322         return _name;
1323     }
1324 
1325     /**
1326      * @dev Returns the token collection symbol.
1327      */
1328     function symbol() public view virtual override returns (string memory) {
1329         return _symbol;
1330     }
1331 
1332     /**
1333      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1334      */
1335     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1336         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1337 
1338         string memory baseURI = _baseURI();
1339         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1340     }
1341 
1342     /**
1343      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1344      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1345      * by default, it can be overridden in child contracts.
1346      */
1347     function _baseURI() internal view virtual returns (string memory) {
1348         return '';
1349     }
1350 
1351     // =============================================================
1352     //                     OWNERSHIPS OPERATIONS
1353     // =============================================================
1354 
1355     /**
1356      * @dev Returns the owner of the `tokenId` token.
1357      *
1358      * Requirements:
1359      *
1360      * - `tokenId` must exist.
1361      */
1362     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1363         return address(uint160(_packedOwnershipOf(tokenId)));
1364     }
1365 
1366     /**
1367      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1368      * It gradually moves to O(1) as tokens get transferred around over time.
1369      */
1370     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1371         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1372     }
1373 
1374     /**
1375      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1376      */
1377     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1378         return _unpackedOwnership(_packedOwnerships[index]);
1379     }
1380 
1381     /**
1382      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1383      */
1384     function _initializeOwnershipAt(uint256 index) internal virtual {
1385         if (_packedOwnerships[index] == 0) {
1386             _packedOwnerships[index] = _packedOwnershipOf(index);
1387         }
1388     }
1389 
1390     /**
1391      * Returns the packed ownership data of `tokenId`.
1392      */
1393     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1394         uint256 curr = tokenId;
1395 
1396         unchecked {
1397             if (_startTokenId() <= curr)
1398                 if (curr < _currentIndex) {
1399                     uint256 packed = _packedOwnerships[curr];
1400                     // If not burned.
1401                     if (packed & _BITMASK_BURNED == 0) {
1402                         // Invariant:
1403                         // There will always be an initialized ownership slot
1404                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1405                         // before an unintialized ownership slot
1406                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1407                         // Hence, `curr` will not underflow.
1408                         //
1409                         // We can directly compare the packed value.
1410                         // If the address is zero, packed will be zero.
1411                         while (packed == 0) {
1412                             packed = _packedOwnerships[--curr];
1413                         }
1414                         return packed;
1415                     }
1416                 }
1417         }
1418         revert OwnerQueryForNonexistentToken();
1419     }
1420 
1421     /**
1422      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1423      */
1424     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1425         ownership.addr = address(uint160(packed));
1426         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1427         ownership.burned = packed & _BITMASK_BURNED != 0;
1428         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1429     }
1430 
1431     /**
1432      * @dev Packs ownership data into a single uint256.
1433      */
1434     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1435         assembly {
1436             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1437             owner := and(owner, _BITMASK_ADDRESS)
1438             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1439             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1440         }
1441     }
1442 
1443     /**
1444      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1445      */
1446     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1447         // For branchless setting of the `nextInitialized` flag.
1448         assembly {
1449             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1450             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1451         }
1452     }
1453 
1454     // =============================================================
1455     //                      APPROVAL OPERATIONS
1456     // =============================================================
1457 
1458     /**
1459      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1460      * The approval is cleared when the token is transferred.
1461      *
1462      * Only a single account can be approved at a time, so approving the
1463      * zero address clears previous approvals.
1464      *
1465      * Requirements:
1466      *
1467      * - The caller must own the token or be an approved operator.
1468      * - `tokenId` must exist.
1469      *
1470      * Emits an {Approval} event.
1471      */
1472     function approve(address to, uint256 tokenId) public payable virtual override {
1473         address owner = ownerOf(tokenId);
1474 
1475         if (_msgSenderERC721A() != owner)
1476             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1477                 revert ApprovalCallerNotOwnerNorApproved();
1478             }
1479 
1480         _tokenApprovals[tokenId].value = to;
1481         emit Approval(owner, to, tokenId);
1482     }
1483 
1484     /**
1485      * @dev Returns the account approved for `tokenId` token.
1486      *
1487      * Requirements:
1488      *
1489      * - `tokenId` must exist.
1490      */
1491     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1492         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1493 
1494         return _tokenApprovals[tokenId].value;
1495     }
1496 
1497     /**
1498      * @dev Approve or remove `operator` as an operator for the caller.
1499      * Operators can call {transferFrom} or {safeTransferFrom}
1500      * for any token owned by the caller.
1501      *
1502      * Requirements:
1503      *
1504      * - The `operator` cannot be the caller.
1505      *
1506      * Emits an {ApprovalForAll} event.
1507      */
1508     function setApprovalForAll(address operator, bool approved) public virtual override {
1509         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1510         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1511     }
1512 
1513     /**
1514      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1515      *
1516      * See {setApprovalForAll}.
1517      */
1518     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1519         return _operatorApprovals[owner][operator];
1520     }
1521 
1522     /**
1523      * @dev Returns whether `tokenId` exists.
1524      *
1525      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1526      *
1527      * Tokens start existing when they are minted. See {_mint}.
1528      */
1529     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1530         return
1531             _startTokenId() <= tokenId &&
1532             tokenId < _currentIndex && // If within bounds,
1533             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1534     }
1535 
1536     /**
1537      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1538      */
1539     function _isSenderApprovedOrOwner(
1540         address approvedAddress,
1541         address owner,
1542         address msgSender
1543     ) private pure returns (bool result) {
1544         assembly {
1545             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1546             owner := and(owner, _BITMASK_ADDRESS)
1547             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1548             msgSender := and(msgSender, _BITMASK_ADDRESS)
1549             // `msgSender == owner || msgSender == approvedAddress`.
1550             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1551         }
1552     }
1553 
1554     /**
1555      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1556      */
1557     function _getApprovedSlotAndAddress(uint256 tokenId)
1558         private
1559         view
1560         returns (uint256 approvedAddressSlot, address approvedAddress)
1561     {
1562         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1563         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1564         assembly {
1565             approvedAddressSlot := tokenApproval.slot
1566             approvedAddress := sload(approvedAddressSlot)
1567         }
1568     }
1569 
1570     // =============================================================
1571     //                      TRANSFER OPERATIONS
1572     // =============================================================
1573 
1574     /**
1575      * @dev Transfers `tokenId` from `from` to `to`.
1576      *
1577      * Requirements:
1578      *
1579      * - `from` cannot be the zero address.
1580      * - `to` cannot be the zero address.
1581      * - `tokenId` token must be owned by `from`.
1582      * - If the caller is not `from`, it must be approved to move this token
1583      * by either {approve} or {setApprovalForAll}.
1584      *
1585      * Emits a {Transfer} event.
1586      */
1587     function transferFrom(
1588         address from,
1589         address to,
1590         uint256 tokenId
1591     ) public payable virtual override {
1592         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1593 
1594         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1595 
1596         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1597 
1598         // The nested ifs save around 20+ gas over a compound boolean condition.
1599         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1600             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1601 
1602         if (to == address(0)) revert TransferToZeroAddress();
1603 
1604         _beforeTokenTransfers(from, to, tokenId, 1);
1605 
1606         // Clear approvals from the previous owner.
1607         assembly {
1608             if approvedAddress {
1609                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1610                 sstore(approvedAddressSlot, 0)
1611             }
1612         }
1613 
1614         // Underflow of the sender's balance is impossible because we check for
1615         // ownership above and the recipient's balance can't realistically overflow.
1616         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1617         unchecked {
1618             // We can directly increment and decrement the balances.
1619             --_packedAddressData[from]; // Updates: `balance -= 1`.
1620             ++_packedAddressData[to]; // Updates: `balance += 1`.
1621 
1622             // Updates:
1623             // - `address` to the next owner.
1624             // - `startTimestamp` to the timestamp of transfering.
1625             // - `burned` to `false`.
1626             // - `nextInitialized` to `true`.
1627             _packedOwnerships[tokenId] = _packOwnershipData(
1628                 to,
1629                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1630             );
1631 
1632             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1633             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1634                 uint256 nextTokenId = tokenId + 1;
1635                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1636                 if (_packedOwnerships[nextTokenId] == 0) {
1637                     // If the next slot is within bounds.
1638                     if (nextTokenId != _currentIndex) {
1639                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1640                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1641                     }
1642                 }
1643             }
1644         }
1645 
1646         emit Transfer(from, to, tokenId);
1647         _afterTokenTransfers(from, to, tokenId, 1);
1648     }
1649 
1650     /**
1651      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1652      */
1653     function safeTransferFrom(
1654         address from,
1655         address to,
1656         uint256 tokenId
1657     ) public payable virtual override {
1658         safeTransferFrom(from, to, tokenId, '');
1659     }
1660 
1661     /**
1662      * @dev Safely transfers `tokenId` token from `from` to `to`.
1663      *
1664      * Requirements:
1665      *
1666      * - `from` cannot be the zero address.
1667      * - `to` cannot be the zero address.
1668      * - `tokenId` token must exist and be owned by `from`.
1669      * - If the caller is not `from`, it must be approved to move this token
1670      * by either {approve} or {setApprovalForAll}.
1671      * - If `to` refers to a smart contract, it must implement
1672      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1673      *
1674      * Emits a {Transfer} event.
1675      */
1676     function safeTransferFrom(
1677         address from,
1678         address to,
1679         uint256 tokenId,
1680         bytes memory _data
1681     ) public payable virtual override {
1682         transferFrom(from, to, tokenId);
1683         if (to.code.length != 0)
1684             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1685                 revert TransferToNonERC721ReceiverImplementer();
1686             }
1687     }
1688 
1689     /**
1690      * @dev Hook that is called before a set of serially-ordered token IDs
1691      * are about to be transferred. This includes minting.
1692      * And also called before burning one token.
1693      *
1694      * `startTokenId` - the first token ID to be transferred.
1695      * `quantity` - the amount to be transferred.
1696      *
1697      * Calling conditions:
1698      *
1699      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1700      * transferred to `to`.
1701      * - When `from` is zero, `tokenId` will be minted for `to`.
1702      * - When `to` is zero, `tokenId` will be burned by `from`.
1703      * - `from` and `to` are never both zero.
1704      */
1705     function _beforeTokenTransfers(
1706         address from,
1707         address to,
1708         uint256 startTokenId,
1709         uint256 quantity
1710     ) internal virtual {}
1711 
1712     /**
1713      * @dev Hook that is called after a set of serially-ordered token IDs
1714      * have been transferred. This includes minting.
1715      * And also called after one token has been burned.
1716      *
1717      * `startTokenId` - the first token ID to be transferred.
1718      * `quantity` - the amount to be transferred.
1719      *
1720      * Calling conditions:
1721      *
1722      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1723      * transferred to `to`.
1724      * - When `from` is zero, `tokenId` has been minted for `to`.
1725      * - When `to` is zero, `tokenId` has been burned by `from`.
1726      * - `from` and `to` are never both zero.
1727      */
1728     function _afterTokenTransfers(
1729         address from,
1730         address to,
1731         uint256 startTokenId,
1732         uint256 quantity
1733     ) internal virtual {}
1734 
1735     /**
1736      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1737      *
1738      * `from` - Previous owner of the given token ID.
1739      * `to` - Target address that will receive the token.
1740      * `tokenId` - Token ID to be transferred.
1741      * `_data` - Optional data to send along with the call.
1742      *
1743      * Returns whether the call correctly returned the expected magic value.
1744      */
1745     function _checkContractOnERC721Received(
1746         address from,
1747         address to,
1748         uint256 tokenId,
1749         bytes memory _data
1750     ) private returns (bool) {
1751         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1752             bytes4 retval
1753         ) {
1754             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1755         } catch (bytes memory reason) {
1756             if (reason.length == 0) {
1757                 revert TransferToNonERC721ReceiverImplementer();
1758             } else {
1759                 assembly {
1760                     revert(add(32, reason), mload(reason))
1761                 }
1762             }
1763         }
1764     }
1765 
1766     // =============================================================
1767     //                        MINT OPERATIONS
1768     // =============================================================
1769 
1770     /**
1771      * @dev Mints `quantity` tokens and transfers them to `to`.
1772      *
1773      * Requirements:
1774      *
1775      * - `to` cannot be the zero address.
1776      * - `quantity` must be greater than 0.
1777      *
1778      * Emits a {Transfer} event for each mint.
1779      */
1780     function _mint(address to, uint256 quantity) internal virtual {
1781         uint256 startTokenId = _currentIndex;
1782         if (quantity == 0) revert MintZeroQuantity();
1783 
1784         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1785 
1786         // Overflows are incredibly unrealistic.
1787         // `balance` and `numberMinted` have a maximum limit of 2**64.
1788         // `tokenId` has a maximum limit of 2**256.
1789         unchecked {
1790             // Updates:
1791             // - `balance += quantity`.
1792             // - `numberMinted += quantity`.
1793             //
1794             // We can directly add to the `balance` and `numberMinted`.
1795             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1796 
1797             // Updates:
1798             // - `address` to the owner.
1799             // - `startTimestamp` to the timestamp of minting.
1800             // - `burned` to `false`.
1801             // - `nextInitialized` to `quantity == 1`.
1802             _packedOwnerships[startTokenId] = _packOwnershipData(
1803                 to,
1804                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1805             );
1806 
1807             uint256 toMasked;
1808             uint256 end = startTokenId + quantity;
1809 
1810             // Use assembly to loop and emit the `Transfer` event for gas savings.
1811             // The duplicated `log4` removes an extra check and reduces stack juggling.
1812             // The assembly, together with the surrounding Solidity code, have been
1813             // delicately arranged to nudge the compiler into producing optimized opcodes.
1814             assembly {
1815                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1816                 toMasked := and(to, _BITMASK_ADDRESS)
1817                 // Emit the `Transfer` event.
1818                 log4(
1819                     0, // Start of data (0, since no data).
1820                     0, // End of data (0, since no data).
1821                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1822                     0, // `address(0)`.
1823                     toMasked, // `to`.
1824                     startTokenId // `tokenId`.
1825                 )
1826 
1827                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1828                 // that overflows uint256 will make the loop run out of gas.
1829                 // The compiler will optimize the `iszero` away for performance.
1830                 for {
1831                     let tokenId := add(startTokenId, 1)
1832                 } iszero(eq(tokenId, end)) {
1833                     tokenId := add(tokenId, 1)
1834                 } {
1835                     // Emit the `Transfer` event. Similar to above.
1836                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1837                 }
1838             }
1839             if (toMasked == 0) revert MintToZeroAddress();
1840 
1841             _currentIndex = end;
1842         }
1843         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1844     }
1845 
1846     /**
1847      * @dev Mints `quantity` tokens and transfers them to `to`.
1848      *
1849      * This function is intended for efficient minting only during contract creation.
1850      *
1851      * It emits only one {ConsecutiveTransfer} as defined in
1852      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1853      * instead of a sequence of {Transfer} event(s).
1854      *
1855      * Calling this function outside of contract creation WILL make your contract
1856      * non-compliant with the ERC721 standard.
1857      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1858      * {ConsecutiveTransfer} event is only permissible during contract creation.
1859      *
1860      * Requirements:
1861      *
1862      * - `to` cannot be the zero address.
1863      * - `quantity` must be greater than 0.
1864      *
1865      * Emits a {ConsecutiveTransfer} event.
1866      */
1867     function _mintERC2309(address to, uint256 quantity) internal virtual {
1868         uint256 startTokenId = _currentIndex;
1869         if (to == address(0)) revert MintToZeroAddress();
1870         if (quantity == 0) revert MintZeroQuantity();
1871         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1872 
1873         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1874 
1875         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1876         unchecked {
1877             // Updates:
1878             // - `balance += quantity`.
1879             // - `numberMinted += quantity`.
1880             //
1881             // We can directly add to the `balance` and `numberMinted`.
1882             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1883 
1884             // Updates:
1885             // - `address` to the owner.
1886             // - `startTimestamp` to the timestamp of minting.
1887             // - `burned` to `false`.
1888             // - `nextInitialized` to `quantity == 1`.
1889             _packedOwnerships[startTokenId] = _packOwnershipData(
1890                 to,
1891                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1892             );
1893 
1894             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1895 
1896             _currentIndex = startTokenId + quantity;
1897         }
1898         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1899     }
1900 
1901     /**
1902      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1903      *
1904      * Requirements:
1905      *
1906      * - If `to` refers to a smart contract, it must implement
1907      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1908      * - `quantity` must be greater than 0.
1909      *
1910      * See {_mint}.
1911      *
1912      * Emits a {Transfer} event for each mint.
1913      */
1914     function _safeMint(
1915         address to,
1916         uint256 quantity,
1917         bytes memory _data
1918     ) internal virtual {
1919         _mint(to, quantity);
1920 
1921         unchecked {
1922             if (to.code.length != 0) {
1923                 uint256 end = _currentIndex;
1924                 uint256 index = end - quantity;
1925                 do {
1926                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1927                         revert TransferToNonERC721ReceiverImplementer();
1928                     }
1929                 } while (index < end);
1930                 // Reentrancy protection.
1931                 if (_currentIndex != end) revert();
1932             }
1933         }
1934     }
1935 
1936     /**
1937      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1938      */
1939     function _safeMint(address to, uint256 quantity) internal virtual {
1940         _safeMint(to, quantity, '');
1941     }
1942 
1943     // =============================================================
1944     //                        BURN OPERATIONS
1945     // =============================================================
1946 
1947     /**
1948      * @dev Equivalent to `_burn(tokenId, false)`.
1949      */
1950     function _burn(uint256 tokenId) internal virtual {
1951         _burn(tokenId, false);
1952     }
1953 
1954     /**
1955      * @dev Destroys `tokenId`.
1956      * The approval is cleared when the token is burned.
1957      *
1958      * Requirements:
1959      *
1960      * - `tokenId` must exist.
1961      *
1962      * Emits a {Transfer} event.
1963      */
1964     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1965         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1966 
1967         address from = address(uint160(prevOwnershipPacked));
1968 
1969         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1970 
1971         if (approvalCheck) {
1972             // The nested ifs save around 20+ gas over a compound boolean condition.
1973             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1974                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1975         }
1976 
1977         _beforeTokenTransfers(from, address(0), tokenId, 1);
1978 
1979         // Clear approvals from the previous owner.
1980         assembly {
1981             if approvedAddress {
1982                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1983                 sstore(approvedAddressSlot, 0)
1984             }
1985         }
1986 
1987         // Underflow of the sender's balance is impossible because we check for
1988         // ownership above and the recipient's balance can't realistically overflow.
1989         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1990         unchecked {
1991             // Updates:
1992             // - `balance -= 1`.
1993             // - `numberBurned += 1`.
1994             //
1995             // We can directly decrement the balance, and increment the number burned.
1996             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1997             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1998 
1999             // Updates:
2000             // - `address` to the last owner.
2001             // - `startTimestamp` to the timestamp of burning.
2002             // - `burned` to `true`.
2003             // - `nextInitialized` to `true`.
2004             _packedOwnerships[tokenId] = _packOwnershipData(
2005                 from,
2006                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2007             );
2008 
2009             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2010             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2011                 uint256 nextTokenId = tokenId + 1;
2012                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2013                 if (_packedOwnerships[nextTokenId] == 0) {
2014                     // If the next slot is within bounds.
2015                     if (nextTokenId != _currentIndex) {
2016                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2017                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2018                     }
2019                 }
2020             }
2021         }
2022 
2023         emit Transfer(from, address(0), tokenId);
2024         _afterTokenTransfers(from, address(0), tokenId, 1);
2025 
2026         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2027         unchecked {
2028             _burnCounter++;
2029         }
2030     }
2031 
2032     // =============================================================
2033     //                     EXTRA DATA OPERATIONS
2034     // =============================================================
2035 
2036     /**
2037      * @dev Directly sets the extra data for the ownership data `index`.
2038      */
2039     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2040         uint256 packed = _packedOwnerships[index];
2041         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2042         uint256 extraDataCasted;
2043         // Cast `extraData` with assembly to avoid redundant masking.
2044         assembly {
2045             extraDataCasted := extraData
2046         }
2047         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2048         _packedOwnerships[index] = packed;
2049     }
2050 
2051     /**
2052      * @dev Called during each token transfer to set the 24bit `extraData` field.
2053      * Intended to be overridden by the cosumer contract.
2054      *
2055      * `previousExtraData` - the value of `extraData` before transfer.
2056      *
2057      * Calling conditions:
2058      *
2059      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2060      * transferred to `to`.
2061      * - When `from` is zero, `tokenId` will be minted for `to`.
2062      * - When `to` is zero, `tokenId` will be burned by `from`.
2063      * - `from` and `to` are never both zero.
2064      */
2065     function _extraData(
2066         address from,
2067         address to,
2068         uint24 previousExtraData
2069     ) internal view virtual returns (uint24) {}
2070 
2071     /**
2072      * @dev Returns the next extra data for the packed ownership data.
2073      * The returned result is shifted into position.
2074      */
2075     function _nextExtraData(
2076         address from,
2077         address to,
2078         uint256 prevOwnershipPacked
2079     ) private view returns (uint256) {
2080         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2081         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2082     }
2083 
2084     // =============================================================
2085     //                       OTHER OPERATIONS
2086     // =============================================================
2087 
2088     /**
2089      * @dev Returns the message sender (defaults to `msg.sender`).
2090      *
2091      * If you are writing GSN compatible contracts, you need to override this function.
2092      */
2093     function _msgSenderERC721A() internal view virtual returns (address) {
2094         return msg.sender;
2095     }
2096 
2097     /**
2098      * @dev Converts a uint256 to its ASCII string decimal representation.
2099      */
2100     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2101         assembly {
2102             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2103             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2104             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2105             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2106             let m := add(mload(0x40), 0xa0)
2107             // Update the free memory pointer to allocate.
2108             mstore(0x40, m)
2109             // Assign the `str` to the end.
2110             str := sub(m, 0x20)
2111             // Zeroize the slot after the string.
2112             mstore(str, 0)
2113 
2114             // Cache the end of the memory to calculate the length later.
2115             let end := str
2116 
2117             // We write the string from rightmost digit to leftmost digit.
2118             // The following is essentially a do-while loop that also handles the zero case.
2119             // prettier-ignore
2120             for { let temp := value } 1 {} {
2121                 str := sub(str, 1)
2122                 // Write the character to the pointer.
2123                 // The ASCII index of the '0' character is 48.
2124                 mstore8(str, add(48, mod(temp, 10)))
2125                 // Keep dividing `temp` until zero.
2126                 temp := div(temp, 10)
2127                 // prettier-ignore
2128                 if iszero(temp) { break }
2129             }
2130 
2131             let length := sub(end, str)
2132             // Move the pointer 32 bytes leftwards to make room for the length.
2133             str := sub(str, 0x20)
2134             // Store the length.
2135             mstore(str, length)
2136         }
2137     }
2138 }
2139 
2140 // File: contracts/jesterers.sol
2141 
2142 
2143 
2144 pragma solidity ^0.8.0;
2145 
2146 
2147 
2148 
2149 
2150 
2151 
2152 
2153 
2154 
2155 
2156 
2157 /***
2158  *        .---.                                                                                                  
2159  *        |   |                                                                                                  
2160  *        '---'      __.....__                          __.....__                   __.....__                    
2161  *        .---.  .-''         '.                    .-''         '.             .-''         '.                  
2162  *        |   | /     .-''"'-.  `.            .|   /     .-''"'-.  `. .-,.--.  /     .-''"'-.  `. .-,.--.        
2163  *        |   |/     /________\   \         .' |_ /     /________\   \|  .-. |/     /________\   \|  .-. |       
2164  *        |   ||                  |    _  .'     ||                  || |  | ||                  || |  | |  _    
2165  *        |   |\    .-------------'  .' |'--.  .-'\    .-------------'| |  | |\    .-------------'| |  | |.' |   
2166  *        |   | \    '-.____...---. .   | / |  |   \    '-.____...---.| |  '-  \    '-.____...---.| |  '-.   | / 
2167  *        |   |  `.             .'.'.'| |// |  |    `.             .' | |       `.             .' | |  .'.'| |// 
2168  *     __.'   '    `''-...... -'.'.'.-'  /  |  '.'    `''-...... -'   | |         `''-...... -'   | |.'.'.-'  /  
2169  *    |      '                  .'   \_.'   |   /                     |_|                         |_|.'   \_.'   
2170  *    |____.'                               `'-'                                                                 
2171  */
2172 
2173 
2174 contract jesterers is ERC721A, Ownable, ReentrancyGuard {
2175   using Address for address;
2176   using Strings for uint;
2177 
2178 
2179   string  public  baseTokenURI = "ipfs://bafybeifmdgzgyk4kxvespngwccxiihsz2xe5vpi6ewefekhdiaueuf5nwm/";
2180   uint256 public  maxSupply = 1150;
2181   uint256 public  MAX_MINTS_PER_TX = 10;
2182   uint256 public  PUBLIC_SALE_PRICE = 0.0049 ether;
2183   uint256 public  NUM_FREE_MINTS = 1150;
2184   uint256 public  MAX_FREE_PER_WALLET = 1;
2185   uint256 public freeAlreadyMinted = 0;
2186   bool public isPublicSaleActive = false;
2187   constructor() ERC721A("jesterers", "JESTS") {
2188   }
2189 
2190 
2191   function mint(uint256 numberOfTokens)
2192       external
2193       payable
2194   {
2195     require(isPublicSaleActive, "Nope! Not yet, hold on");
2196     require(totalSupply() + numberOfTokens < maxSupply + 1, "too late mfer");
2197 
2198     if(freeAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
2199         require(
2200             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
2201             "Incorrect ETH value sent"
2202         );
2203     } else {
2204         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
2205         require(
2206             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
2207             "Incorrect ETH value sent"
2208         );
2209         require(
2210             numberOfTokens <= MAX_MINTS_PER_TX,
2211             "Max mints per transaction exceeded"
2212         );
2213         } else {
2214             require(
2215                 numberOfTokens <= MAX_FREE_PER_WALLET,
2216                 "Max mints per transaction exceeded"
2217             );
2218             freeAlreadyMinted += numberOfTokens;
2219         }
2220     }
2221     _safeMint(msg.sender, numberOfTokens);
2222   }
2223 
2224   function setBaseURI(string memory baseURI)
2225     public
2226     onlyOwner
2227   {
2228     baseTokenURI = baseURI;
2229   }
2230 
2231   function treasuryMint(uint quantity)
2232     public
2233     onlyOwner
2234   {
2235     require(
2236       quantity > 0,
2237       "Invalid mint amount"
2238     );
2239     require(
2240       totalSupply() + quantity <= maxSupply,
2241       "Maximum supply exceeded"
2242     );
2243     _safeMint(msg.sender, quantity);
2244   }
2245 
2246   function withdraw()
2247     public
2248     onlyOwner
2249     nonReentrant
2250   {
2251     Address.sendValue(payable(msg.sender), address(this).balance);
2252   }
2253 
2254   function _baseURI()
2255     internal
2256     view
2257     virtual
2258     override
2259     returns (string memory)
2260   {
2261     return baseTokenURI;
2262   }
2263 
2264   function setIsPublicSaleActive(bool _isPublicSaleActive)
2265       external
2266       onlyOwner
2267   {
2268       isPublicSaleActive = _isPublicSaleActive;
2269   }
2270 
2271   function setNumFreeMints(uint256 _numfreemints)
2272       external
2273       onlyOwner
2274   {
2275       NUM_FREE_MINTS = _numfreemints;
2276   }
2277 
2278   function setSalePrice(uint256 _price)
2279       external
2280       onlyOwner
2281   {
2282       PUBLIC_SALE_PRICE = _price;
2283   }
2284 
2285   function setMaxLimitPerTransaction(uint256 _limit)
2286       external
2287       onlyOwner
2288   {
2289       MAX_MINTS_PER_TX = _limit;
2290   }
2291 
2292   function setFreeLimitPerWallet(uint256 _limit)
2293       external
2294       onlyOwner
2295   {
2296       MAX_FREE_PER_WALLET = _limit;
2297   }
2298 }