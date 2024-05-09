1 /**
2 
3                                                       .-'''-.                                                            
4                                                      '   _    \                    _______                               
5  __  __   ___   .--.   _..._                       /   /` '.   \                   \  ___ `'.   .--.      __.....__      
6 |  |/  `.'   `. |__| .'     '.                    .   |     \  '                    ' |--.\  \  |__|  .-''         '.    
7 |   .-.  .-.   '.--..   .-.   .     .|            |   '      |  '.-,.--.            | |    \  ' .--. /     .-''"'-.  `.  
8 |  |  |  |  |  ||  ||  '   '  |   .' |_           \    \     / / |  .-. |           | |     |  '|  |/     /________\   \ 
9 |  |  |  |  |  ||  ||  |   |  | .'     |           `.   ` ..' /  | |  | |           | |     |  ||  ||                  | 
10 |  |  |  |  |  ||  ||  |   |  |'--.  .-'              '-...-'`   | |  | |           | |     ' .'|  |\    .-------------' 
11 |  |  |  |  |  ||  ||  |   |  |   |  |                           | |  '-            | |___.' /' |  | \    '-.____...---. 
12 |__|  |__|  |__||__||  |   |  |   |  |                           | |               /_______.'/  |__|  `.             .'  
13                     |  |   |  |   |  '.'                         | |               \_______|/           `''-...... -'    
14                     |  |   |  |   |   /                          |_|                                                     
15                     '--'   '--'   `'-'                                                                                   
16 
17 
18 */
19 
20 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
21 
22 // SPDX-License-Identifier: MIT
23 
24 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev Contract module that helps prevent reentrant calls to a function.
30  *
31  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
32  * available, which can be applied to functions to make sure there are no nested
33  * (reentrant) calls to them.
34  *
35  * Note that because there is a single `nonReentrant` guard, functions marked as
36  * `nonReentrant` may not call one another. This can be worked around by making
37  * those functions `private`, and then adding `external` `nonReentrant` entry
38  * points to them.
39  *
40  * TIP: If you would like to learn more about reentrancy and alternative ways
41  * to protect against it, check out our blog post
42  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
43  */
44 abstract contract ReentrancyGuard {
45     // Booleans are more expensive than uint256 or any type that takes up a full
46     // word because each write operation emits an extra SLOAD to first read the
47     // slot's contents, replace the bits taken up by the boolean, and then write
48     // back. This is the compiler's defense against contract upgrades and
49     // pointer aliasing, and it cannot be disabled.
50 
51     // The values being non-zero value makes deployment a bit more expensive,
52     // but in exchange the refund on every call to nonReentrant will be lower in
53     // amount. Since refunds are capped to a percentage of the total
54     // transaction's gas, it is best to keep them low in cases like this one, to
55     // increase the likelihood of the full refund coming into effect.
56     uint256 private constant _NOT_ENTERED = 1;
57     uint256 private constant _ENTERED = 2;
58 
59     uint256 private _status;
60 
61     constructor() {
62         _status = _NOT_ENTERED;
63     }
64 
65     /**
66      * @dev Prevents a contract from calling itself, directly or indirectly.
67      * Calling a `nonReentrant` function from another `nonReentrant`
68      * function is not supported. It is possible to prevent this from happening
69      * by making the `nonReentrant` function external, and making it call a
70      * `private` function that does the actual work.
71      */
72     modifier nonReentrant() {
73         // On the first call to nonReentrant, _notEntered will be true
74         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
75 
76         // Any calls to nonReentrant after this point will fail
77         _status = _ENTERED;
78 
79         _;
80 
81         // By storing the original value once again, a refund is triggered (see
82         // https://eips.ethereum.org/EIPS/eip-2200)
83         _status = _NOT_ENTERED;
84     }
85 }
86 
87 // File: @openzeppelin/contracts/utils/Strings.sol
88 
89 
90 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev String operations.
96  */
97 library Strings {
98     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
99 
100     /**
101      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
102      */
103     function toString(uint256 value) internal pure returns (string memory) {
104         // Inspired by OraclizeAPI's implementation - MIT licence
105         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
106 
107         if (value == 0) {
108             return "0";
109         }
110         uint256 temp = value;
111         uint256 digits;
112         while (temp != 0) {
113             digits++;
114             temp /= 10;
115         }
116         bytes memory buffer = new bytes(digits);
117         while (value != 0) {
118             digits -= 1;
119             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
120             value /= 10;
121         }
122         return string(buffer);
123     }
124 
125     /**
126      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
127      */
128     function toHexString(uint256 value) internal pure returns (string memory) {
129         if (value == 0) {
130             return "0x00";
131         }
132         uint256 temp = value;
133         uint256 length = 0;
134         while (temp != 0) {
135             length++;
136             temp >>= 8;
137         }
138         return toHexString(value, length);
139     }
140 
141     /**
142      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
143      */
144     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
145         bytes memory buffer = new bytes(2 * length + 2);
146         buffer[0] = "0";
147         buffer[1] = "x";
148         for (uint256 i = 2 * length + 1; i > 1; --i) {
149             buffer[i] = _HEX_SYMBOLS[value & 0xf];
150             value >>= 4;
151         }
152         require(value == 0, "Strings: hex length insufficient");
153         return string(buffer);
154     }
155 }
156 
157 // File: @openzeppelin/contracts/utils/Context.sol
158 
159 
160 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
161 
162 pragma solidity ^0.8.0;
163 
164 /**
165  * @dev Provides information about the current execution context, including the
166  * sender of the transaction and its data. While these are generally available
167  * via msg.sender and msg.data, they should not be accessed in such a direct
168  * manner, since when dealing with meta-transactions the account sending and
169  * paying for execution may not be the actual sender (as far as an application
170  * is concerned).
171  *
172  * This contract is only required for intermediate, library-like contracts.
173  */
174 abstract contract Context {
175     function _msgSender() internal view virtual returns (address) {
176         return msg.sender;
177     }
178 
179     function _msgData() internal view virtual returns (bytes calldata) {
180         return msg.data;
181     }
182 }
183 
184 // File: @openzeppelin/contracts/access/Ownable.sol
185 
186 
187 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
188 
189 pragma solidity ^0.8.0;
190 
191 
192 /**
193  * @dev Contract module which provides a basic access control mechanism, where
194  * there is an account (an owner) that can be granted exclusive access to
195  * specific functions.
196  *
197  * By default, the owner account will be the one that deploys the contract. This
198  * can later be changed with {transferOwnership}.
199  *
200  * This module is used through inheritance. It will make available the modifier
201  * `onlyOwner`, which can be applied to your functions to restrict their use to
202  * the owner.
203  */
204 abstract contract Ownable is Context {
205     address private _owner;
206 
207     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
208 
209     /**
210      * @dev Initializes the contract setting the deployer as the initial owner.
211      */
212     constructor() {
213         _transferOwnership(_msgSender());
214     }
215 
216     /**
217      * @dev Returns the address of the current owner.
218      */
219     function owner() public view virtual returns (address) {
220         return _owner;
221     }
222 
223     /**
224      * @dev Throws if called by any account other than the owner.
225      */
226     modifier onlyOwner() {
227         require(owner() == _msgSender(), "Ownable: caller is not the owner");
228         _;
229     }
230 
231     /**
232      * @dev Leaves the contract without owner. It will not be possible to call
233      * `onlyOwner` functions anymore. Can only be called by the current owner.
234      *
235      * NOTE: Renouncing ownership will leave the contract without an owner,
236      * thereby removing any functionality that is only available to the owner.
237      */
238     function renounceOwnership() public virtual onlyOwner {
239         _transferOwnership(address(0));
240     }
241 
242     /**
243      * @dev Transfers ownership of the contract to a new account (`newOwner`).
244      * Can only be called by the current owner.
245      */
246     function transferOwnership(address newOwner) public virtual onlyOwner {
247         require(newOwner != address(0), "Ownable: new owner is the zero address");
248         _transferOwnership(newOwner);
249     }
250 
251     /**
252      * @dev Transfers ownership of the contract to a new account (`newOwner`).
253      * Internal function without access restriction.
254      */
255     function _transferOwnership(address newOwner) internal virtual {
256         address oldOwner = _owner;
257         _owner = newOwner;
258         emit OwnershipTransferred(oldOwner, newOwner);
259     }
260 }
261 
262 // File: @openzeppelin/contracts/utils/Address.sol
263 
264 
265 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
266 
267 pragma solidity ^0.8.1;
268 
269 /**
270  * @dev Collection of functions related to the address type
271  */
272 library Address {
273     /**
274      * @dev Returns true if `account` is a contract.
275      *
276      * [IMPORTANT]
277      * ====
278      * It is unsafe to assume that an address for which this function returns
279      * false is an externally-owned account (EOA) and not a contract.
280      *
281      * Among others, `isContract` will return false for the following
282      * types of addresses:
283      *
284      *  - an externally-owned account
285      *  - a contract in construction
286      *  - an address where a contract will be created
287      *  - an address where a contract lived, but was destroyed
288      * ====
289      *
290      * [IMPORTANT]
291      * ====
292      * You shouldn't rely on `isContract` to protect against flash loan attacks!
293      *
294      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
295      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
296      * constructor.
297      * ====
298      */
299     function isContract(address account) internal view returns (bool) {
300         // This method relies on extcodesize/address.code.length, which returns 0
301         // for contracts in construction, since the code is only stored at the end
302         // of the constructor execution.
303 
304         return account.code.length > 0;
305     }
306 
307     /**
308      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
309      * `recipient`, forwarding all available gas and reverting on errors.
310      *
311      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
312      * of certain opcodes, possibly making contracts go over the 2300 gas limit
313      * imposed by `transfer`, making them unable to receive funds via
314      * `transfer`. {sendValue} removes this limitation.
315      *
316      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
317      *
318      * IMPORTANT: because control is transferred to `recipient`, care must be
319      * taken to not create reentrancy vulnerabilities. Consider using
320      * {ReentrancyGuard} or the
321      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
322      */
323     function sendValue(address payable recipient, uint256 amount) internal {
324         require(address(this).balance >= amount, "Address: insufficient balance");
325 
326         (bool success, ) = recipient.call{value: amount}("");
327         require(success, "Address: unable to send value, recipient may have reverted");
328     }
329 
330     /**
331      * @dev Performs a Solidity function call using a low level `call`. A
332      * plain `call` is an unsafe replacement for a function call: use this
333      * function instead.
334      *
335      * If `target` reverts with a revert reason, it is bubbled up by this
336      * function (like regular Solidity function calls).
337      *
338      * Returns the raw returned data. To convert to the expected return value,
339      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
340      *
341      * Requirements:
342      *
343      * - `target` must be a contract.
344      * - calling `target` with `data` must not revert.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
349         return functionCall(target, data, "Address: low-level call failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
354      * `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(
359         address target,
360         bytes memory data,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         return functionCallWithValue(target, data, 0, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but also transferring `value` wei to `target`.
369      *
370      * Requirements:
371      *
372      * - the calling contract must have an ETH balance of at least `value`.
373      * - the called Solidity function must be `payable`.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(
378         address target,
379         bytes memory data,
380         uint256 value
381     ) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
387      * with `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(
392         address target,
393         bytes memory data,
394         uint256 value,
395         string memory errorMessage
396     ) internal returns (bytes memory) {
397         require(address(this).balance >= value, "Address: insufficient balance for call");
398         require(isContract(target), "Address: call to non-contract");
399 
400         (bool success, bytes memory returndata) = target.call{value: value}(data);
401         return verifyCallResult(success, returndata, errorMessage);
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
406      * but performing a static call.
407      *
408      * _Available since v3.3._
409      */
410     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
411         return functionStaticCall(target, data, "Address: low-level static call failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
416      * but performing a static call.
417      *
418      * _Available since v3.3._
419      */
420     function functionStaticCall(
421         address target,
422         bytes memory data,
423         string memory errorMessage
424     ) internal view returns (bytes memory) {
425         require(isContract(target), "Address: static call to non-contract");
426 
427         (bool success, bytes memory returndata) = target.staticcall(data);
428         return verifyCallResult(success, returndata, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but performing a delegate call.
434      *
435      * _Available since v3.4._
436      */
437     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
438         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
443      * but performing a delegate call.
444      *
445      * _Available since v3.4._
446      */
447     function functionDelegateCall(
448         address target,
449         bytes memory data,
450         string memory errorMessage
451     ) internal returns (bytes memory) {
452         require(isContract(target), "Address: delegate call to non-contract");
453 
454         (bool success, bytes memory returndata) = target.delegatecall(data);
455         return verifyCallResult(success, returndata, errorMessage);
456     }
457 
458     /**
459      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
460      * revert reason using the provided one.
461      *
462      * _Available since v4.3._
463      */
464     function verifyCallResult(
465         bool success,
466         bytes memory returndata,
467         string memory errorMessage
468     ) internal pure returns (bytes memory) {
469         if (success) {
470             return returndata;
471         } else {
472             // Look for revert reason and bubble it up if present
473             if (returndata.length > 0) {
474                 // The easiest way to bubble the revert reason is using memory via assembly
475 
476                 assembly {
477                     let returndata_size := mload(returndata)
478                     revert(add(32, returndata), returndata_size)
479                 }
480             } else {
481                 revert(errorMessage);
482             }
483         }
484     }
485 }
486 
487 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
488 
489 
490 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
491 
492 pragma solidity ^0.8.0;
493 
494 /**
495  * @title ERC721 token receiver interface
496  * @dev Interface for any contract that wants to support safeTransfers
497  * from ERC721 asset contracts.
498  */
499 interface IERC721Receiver {
500     /**
501      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
502      * by `operator` from `from`, this function is called.
503      *
504      * It must return its Solidity selector to confirm the token transfer.
505      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
506      *
507      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
508      */
509     function onERC721Received(
510         address operator,
511         address from,
512         uint256 tokenId,
513         bytes calldata data
514     ) external returns (bytes4);
515 }
516 
517 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
518 
519 
520 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 /**
525  * @dev Interface of the ERC165 standard, as defined in the
526  * https://eips.ethereum.org/EIPS/eip-165[EIP].
527  *
528  * Implementers can declare support of contract interfaces, which can then be
529  * queried by others ({ERC165Checker}).
530  *
531  * For an implementation, see {ERC165}.
532  */
533 interface IERC165 {
534     /**
535      * @dev Returns true if this contract implements the interface defined by
536      * `interfaceId`. See the corresponding
537      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
538      * to learn more about how these ids are created.
539      *
540      * This function call must use less than 30 000 gas.
541      */
542     function supportsInterface(bytes4 interfaceId) external view returns (bool);
543 }
544 
545 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
546 
547 
548 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
549 
550 pragma solidity ^0.8.0;
551 
552 
553 /**
554  * @dev Implementation of the {IERC165} interface.
555  *
556  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
557  * for the additional interface id that will be supported. For example:
558  *
559  * ```solidity
560  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
561  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
562  * }
563  * ```
564  *
565  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
566  */
567 abstract contract ERC165 is IERC165 {
568     /**
569      * @dev See {IERC165-supportsInterface}.
570      */
571     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
572         return interfaceId == type(IERC165).interfaceId;
573     }
574 }
575 
576 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
577 
578 
579 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
580 
581 pragma solidity ^0.8.0;
582 
583 
584 /**
585  * @dev Required interface of an ERC721 compliant contract.
586  */
587 interface IERC721 is IERC165 {
588     /**
589      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
590      */
591     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
592 
593     /**
594      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
595      */
596     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
597 
598     /**
599      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
600      */
601     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
602 
603     /**
604      * @dev Returns the number of tokens in ``owner``'s account.
605      */
606     function balanceOf(address owner) external view returns (uint256 balance);
607 
608     /**
609      * @dev Returns the owner of the `tokenId` token.
610      *
611      * Requirements:
612      *
613      * - `tokenId` must exist.
614      */
615     function ownerOf(uint256 tokenId) external view returns (address owner);
616 
617     /**
618      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
619      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
620      *
621      * Requirements:
622      *
623      * - `from` cannot be the zero address.
624      * - `to` cannot be the zero address.
625      * - `tokenId` token must exist and be owned by `from`.
626      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
627      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
628      *
629      * Emits a {Transfer} event.
630      */
631     function safeTransferFrom(
632         address from,
633         address to,
634         uint256 tokenId
635     ) external;
636 
637     /**
638      * @dev Transfers `tokenId` token from `from` to `to`.
639      *
640      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
641      *
642      * Requirements:
643      *
644      * - `from` cannot be the zero address.
645      * - `to` cannot be the zero address.
646      * - `tokenId` token must be owned by `from`.
647      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
648      *
649      * Emits a {Transfer} event.
650      */
651     function transferFrom(
652         address from,
653         address to,
654         uint256 tokenId
655     ) external;
656 
657     /**
658      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
659      * The approval is cleared when the token is transferred.
660      *
661      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
662      *
663      * Requirements:
664      *
665      * - The caller must own the token or be an approved operator.
666      * - `tokenId` must exist.
667      *
668      * Emits an {Approval} event.
669      */
670     function approve(address to, uint256 tokenId) external;
671 
672     /**
673      * @dev Returns the account approved for `tokenId` token.
674      *
675      * Requirements:
676      *
677      * - `tokenId` must exist.
678      */
679     function getApproved(uint256 tokenId) external view returns (address operator);
680 
681     /**
682      * @dev Approve or remove `operator` as an operator for the caller.
683      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
684      *
685      * Requirements:
686      *
687      * - The `operator` cannot be the caller.
688      *
689      * Emits an {ApprovalForAll} event.
690      */
691     function setApprovalForAll(address operator, bool _approved) external;
692 
693     /**
694      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
695      *
696      * See {setApprovalForAll}
697      */
698     function isApprovedForAll(address owner, address operator) external view returns (bool);
699 
700     /**
701      * @dev Safely transfers `tokenId` token from `from` to `to`.
702      *
703      * Requirements:
704      *
705      * - `from` cannot be the zero address.
706      * - `to` cannot be the zero address.
707      * - `tokenId` token must exist and be owned by `from`.
708      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
709      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
710      *
711      * Emits a {Transfer} event.
712      */
713     function safeTransferFrom(
714         address from,
715         address to,
716         uint256 tokenId,
717         bytes calldata data
718     ) external;
719 }
720 
721 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
722 
723 
724 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 
729 /**
730  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
731  * @dev See https://eips.ethereum.org/EIPS/eip-721
732  */
733 interface IERC721Metadata is IERC721 {
734     /**
735      * @dev Returns the token collection name.
736      */
737     function name() external view returns (string memory);
738 
739     /**
740      * @dev Returns the token collection symbol.
741      */
742     function symbol() external view returns (string memory);
743 
744     /**
745      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
746      */
747     function tokenURI(uint256 tokenId) external view returns (string memory);
748 }
749 
750 // File: contracts/ERC721A.sol
751 
752 
753 // Creator: Chiru Labs
754 
755 pragma solidity ^0.8.4;
756 
757 
758 
759 
760 
761 
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
779  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
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
851         return 1;
852     }
853 
854     /**
855      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
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
877      * @dev See {IERC165-supportsInterface}.
878      */
879     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
880         return
881             interfaceId == type(IERC721).interfaceId ||
882             interfaceId == type(IERC721Metadata).interfaceId ||
883             super.supportsInterface(interfaceId);
884     }
885 
886     /**
887      * @dev See {IERC721-balanceOf}.
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
955      * @dev See {IERC721-ownerOf}.
956      */
957     function ownerOf(uint256 tokenId) public view override returns (address) {
958         return _ownershipOf(tokenId).addr;
959     }
960 
961     /**
962      * @dev See {IERC721Metadata-name}.
963      */
964     function name() public view virtual override returns (string memory) {
965         return _name;
966     }
967 
968     /**
969      * @dev See {IERC721Metadata-symbol}.
970      */
971     function symbol() public view virtual override returns (string memory) {
972         return _symbol;
973     }
974 
975     /**
976      * @dev See {IERC721Metadata-tokenURI}.
977      */
978     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
979         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
980 
981         string memory baseURI = _baseURI();
982         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
983     }
984 
985     /**
986      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
987      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
988      * by default, can be overriden in child contracts.
989      */
990     function _baseURI() internal view virtual returns (string memory) {
991         return '';
992     }
993 
994     /**
995      * @dev See {IERC721-approve}.
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
1009      * @dev See {IERC721-getApproved}.
1010      */
1011     function getApproved(uint256 tokenId) public view override returns (address) {
1012         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1013 
1014         return _tokenApprovals[tokenId];
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-setApprovalForAll}.
1019      */
1020     function setApprovalForAll(address operator, bool approved) public virtual override {
1021         if (operator == _msgSender()) revert ApproveToCaller();
1022 
1023         _operatorApprovals[_msgSender()][operator] = approved;
1024         emit ApprovalForAll(_msgSender(), operator, approved);
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-isApprovedForAll}.
1029      */
1030     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1031         return _operatorApprovals[owner][operator];
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-transferFrom}.
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
1046      * @dev See {IERC721-safeTransferFrom}.
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
1057      * @dev See {IERC721-safeTransferFrom}.
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
1072      * @dev Returns whether `tokenId` exists.
1073      *
1074      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1075      *
1076      * Tokens start existing when they are minted (`_mint`),
1077      */
1078     function _exists(uint256 tokenId) internal view returns (bool) {
1079         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1080     }
1081 
1082     /**
1083      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1084      */
1085     function _safeMint(address to, uint256 quantity) internal {
1086         _safeMint(to, quantity, '');
1087     }
1088 
1089     /**
1090      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1091      *
1092      * Requirements:
1093      *
1094      * - If `to` refers to a smart contract, it must implement 
1095      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1096      * - `quantity` must be greater than 0.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function _safeMint(
1101         address to,
1102         uint256 quantity,
1103         bytes memory _data
1104     ) internal {
1105         uint256 startTokenId = _currentIndex;
1106         if (to == address(0)) revert MintToZeroAddress();
1107         if (quantity == 0) revert MintZeroQuantity();
1108 
1109         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1110 
1111         // Overflows are incredibly unrealistic.
1112         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1113         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1114         unchecked {
1115             _addressData[to].balance += uint64(quantity);
1116             _addressData[to].numberMinted += uint64(quantity);
1117 
1118             _ownerships[startTokenId].addr = to;
1119             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1120 
1121             uint256 updatedIndex = startTokenId;
1122             uint256 end = updatedIndex + quantity;
1123 
1124             if (to.isContract()) {
1125                 do {
1126                     emit Transfer(address(0), to, updatedIndex);
1127                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1128                         revert TransferToNonERC721ReceiverImplementer();
1129                     }
1130                 } while (updatedIndex != end);
1131                 // Reentrancy protection
1132                 if (_currentIndex != startTokenId) revert();
1133             } else {
1134                 do {
1135                     emit Transfer(address(0), to, updatedIndex++);
1136                 } while (updatedIndex != end);
1137             }
1138             _currentIndex = updatedIndex;
1139         }
1140         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1141     }
1142 
1143     /**
1144      * @dev Mints `quantity` tokens and transfers them to `to`.
1145      *
1146      * Requirements:
1147      *
1148      * - `to` cannot be the zero address.
1149      * - `quantity` must be greater than 0.
1150      *
1151      * Emits a {Transfer} event.
1152      */
1153     function _mint(address to, uint256 quantity) internal {
1154         uint256 startTokenId = _currentIndex;
1155         if (to == address(0)) revert MintToZeroAddress();
1156         if (quantity == 0) revert MintZeroQuantity();
1157 
1158         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1159 
1160         // Overflows are incredibly unrealistic.
1161         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1162         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1163         unchecked {
1164             _addressData[to].balance += uint64(quantity);
1165             _addressData[to].numberMinted += uint64(quantity);
1166 
1167             _ownerships[startTokenId].addr = to;
1168             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1169 
1170             uint256 updatedIndex = startTokenId;
1171             uint256 end = updatedIndex + quantity;
1172 
1173             do {
1174                 emit Transfer(address(0), to, updatedIndex++);
1175             } while (updatedIndex != end);
1176 
1177             _currentIndex = updatedIndex;
1178         }
1179         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1180     }
1181 
1182     /**
1183      * @dev Transfers `tokenId` from `from` to `to`.
1184      *
1185      * Requirements:
1186      *
1187      * - `to` cannot be the zero address.
1188      * - `tokenId` token must be owned by `from`.
1189      *
1190      * Emits a {Transfer} event.
1191      */
1192     function _transfer(
1193         address from,
1194         address to,
1195         uint256 tokenId
1196     ) private {
1197         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1198 
1199         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1200 
1201         bool isApprovedOrOwner = (_msgSender() == from ||
1202             isApprovedForAll(from, _msgSender()) ||
1203             getApproved(tokenId) == _msgSender());
1204 
1205         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1206         if (to == address(0)) revert TransferToZeroAddress();
1207 
1208         _beforeTokenTransfers(from, to, tokenId, 1);
1209 
1210         // Clear approvals from the previous owner
1211         _approve(address(0), tokenId, from);
1212 
1213         // Underflow of the sender's balance is impossible because we check for
1214         // ownership above and the recipient's balance can't realistically overflow.
1215         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1216         unchecked {
1217             _addressData[from].balance -= 1;
1218             _addressData[to].balance += 1;
1219 
1220             TokenOwnership storage currSlot = _ownerships[tokenId];
1221             currSlot.addr = to;
1222             currSlot.startTimestamp = uint64(block.timestamp);
1223 
1224             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1225             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1226             uint256 nextTokenId = tokenId + 1;
1227             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1228             if (nextSlot.addr == address(0)) {
1229                 // This will suffice for checking _exists(nextTokenId),
1230                 // as a burned slot cannot contain the zero address.
1231                 if (nextTokenId != _currentIndex) {
1232                     nextSlot.addr = from;
1233                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1234                 }
1235             }
1236         }
1237 
1238         emit Transfer(from, to, tokenId);
1239         _afterTokenTransfers(from, to, tokenId, 1);
1240     }
1241 
1242     /**
1243      * @dev Equivalent to `_burn(tokenId, false)`.
1244      */
1245     function _burn(uint256 tokenId) internal virtual {
1246         _burn(tokenId, false);
1247     }
1248 
1249     /**
1250      * @dev Destroys `tokenId`.
1251      * The approval is cleared when the token is burned.
1252      *
1253      * Requirements:
1254      *
1255      * - `tokenId` must exist.
1256      *
1257      * Emits a {Transfer} event.
1258      */
1259     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1260         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1261 
1262         address from = prevOwnership.addr;
1263 
1264         if (approvalCheck) {
1265             bool isApprovedOrOwner = (_msgSender() == from ||
1266                 isApprovedForAll(from, _msgSender()) ||
1267                 getApproved(tokenId) == _msgSender());
1268 
1269             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1270         }
1271 
1272         _beforeTokenTransfers(from, address(0), tokenId, 1);
1273 
1274         // Clear approvals from the previous owner
1275         _approve(address(0), tokenId, from);
1276 
1277         // Underflow of the sender's balance is impossible because we check for
1278         // ownership above and the recipient's balance can't realistically overflow.
1279         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1280         unchecked {
1281             AddressData storage addressData = _addressData[from];
1282             addressData.balance -= 1;
1283             addressData.numberBurned += 1;
1284 
1285             // Keep track of who burned the token, and the timestamp of burning.
1286             TokenOwnership storage currSlot = _ownerships[tokenId];
1287             currSlot.addr = from;
1288             currSlot.startTimestamp = uint64(block.timestamp);
1289             currSlot.burned = true;
1290 
1291             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1292             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1293             uint256 nextTokenId = tokenId + 1;
1294             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1295             if (nextSlot.addr == address(0)) {
1296                 // This will suffice for checking _exists(nextTokenId),
1297                 // as a burned slot cannot contain the zero address.
1298                 if (nextTokenId != _currentIndex) {
1299                     nextSlot.addr = from;
1300                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1301                 }
1302             }
1303         }
1304 
1305         emit Transfer(from, address(0), tokenId);
1306         _afterTokenTransfers(from, address(0), tokenId, 1);
1307 
1308         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1309         unchecked {
1310             _burnCounter++;
1311         }
1312     }
1313 
1314     /**
1315      * @dev Approve `to` to operate on `tokenId`
1316      *
1317      * Emits a {Approval} event.
1318      */
1319     function _approve(
1320         address to,
1321         uint256 tokenId,
1322         address owner
1323     ) private {
1324         _tokenApprovals[tokenId] = to;
1325         emit Approval(owner, to, tokenId);
1326     }
1327 
1328     /**
1329      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1330      *
1331      * @param from address representing the previous owner of the given token ID
1332      * @param to target address that will receive the tokens
1333      * @param tokenId uint256 ID of the token to be transferred
1334      * @param _data bytes optional data to send along with the call
1335      * @return bool whether the call correctly returned the expected magic value
1336      */
1337     function _checkContractOnERC721Received(
1338         address from,
1339         address to,
1340         uint256 tokenId,
1341         bytes memory _data
1342     ) private returns (bool) {
1343         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1344             return retval == IERC721Receiver(to).onERC721Received.selector;
1345         } catch (bytes memory reason) {
1346             if (reason.length == 0) {
1347                 revert TransferToNonERC721ReceiverImplementer();
1348             } else {
1349                 assembly {
1350                     revert(add(32, reason), mload(reason))
1351                 }
1352             }
1353         }
1354     }
1355 
1356     /**
1357      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1358      * And also called before burning one token.
1359      *
1360      * startTokenId - the first token id to be transferred
1361      * quantity - the amount to be transferred
1362      *
1363      * Calling conditions:
1364      *
1365      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1366      * transferred to `to`.
1367      * - When `from` is zero, `tokenId` will be minted for `to`.
1368      * - When `to` is zero, `tokenId` will be burned by `from`.
1369      * - `from` and `to` are never both zero.
1370      */
1371     function _beforeTokenTransfers(
1372         address from,
1373         address to,
1374         uint256 startTokenId,
1375         uint256 quantity
1376     ) internal virtual {}
1377 
1378     /**
1379      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1380      * minting.
1381      * And also called after one token has been burned.
1382      *
1383      * startTokenId - the first token id to be transferred
1384      * quantity - the amount to be transferred
1385      *
1386      * Calling conditions:
1387      *
1388      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1389      * transferred to `to`.
1390      * - When `from` is zero, `tokenId` has been minted for `to`.
1391      * - When `to` is zero, `tokenId` has been burned by `from`.
1392      * - `from` and `to` are never both zero.
1393      */
1394     function _afterTokenTransfers(
1395         address from,
1396         address to,
1397         uint256 startTokenId,
1398         uint256 quantity
1399     ) internal virtual {}
1400 }
1401 // File: contracts/MINTorDIE.sol
1402 
1403 
1404 
1405 pragma solidity ^0.8.0;
1406 
1407 
1408 
1409 
1410 
1411 contract MINTorDIE is ERC721A, Ownable, ReentrancyGuard {
1412   using Address for address;
1413   using Strings for uint;
1414 
1415 
1416   string  public  baseTokenURI = "ipfs://QmWF1fpGPySXNjmhJN2wd6mmRwLFwKxvvFT929Duef56pR/";
1417   uint256  public  maxSupply = 5000;
1418   uint256 public  MAX_MINTS_PER_TX = 10;
1419   uint256 public  PUBLIC_SALE_PRICE = 0.003 ether;
1420   uint256 public  NUM_FREE_MINTS = 1000;
1421   uint256 public  MAX_FREE_PER_WALLET = 2;
1422   uint256 public freeNFTAlreadyMinted = 0;
1423   bool public isPublicSaleActive = false;
1424 
1425   constructor(
1426 
1427   ) ERC721A("MINTorDIE", "DIE") {
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