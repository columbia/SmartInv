1 /**********************************************************************************************************
2       ___           ___           ___           ___           ___          _____    
3      /  /\         /  /\         /  /\         /  /\         /__/\        /  /::\   
4     /  /::\       /  /::\       /  /::\       /  /::\        \  \:\      /  /:/\:\  
5    /  /:/\:\     /  /:/\:\     /  /:/\:\     /  /:/\:\        \  \:\    /  /:/  \:\ 
6   /  /:/  \:\   /  /:/~/:/    /  /:/~/::\   /  /:/~/::\   _____\__\:\  /__/:/ \__\:|
7  /__/:/ \__\:\ /__/:/ /:/___ /__/:/ /:/\:\ /__/:/ /:/\:\ /__/::::::::\ \  \:\ /  /:/
8  \  \:\ /  /:/ \  \:\/:::::/ \  \:\/:/__\/ \  \:\/:/__\/ \  \:\~~\~~\/  \  \:\  /:/ 
9   \  \:\  /:/   \  \::/~~~~   \  \::/       \  \::/       \  \:\         \  \:\/:/  
10    \  \:\/:/     \  \:\        \  \:\        \  \:\        \  \:\         \  \::/   
11     \  \::/       \  \:\        \  \:\        \  \:\        \  \:\         \__\/    
12      \__\/         \__\/         \__\/         \__\/         \__\/                  
13 
14 
15 To obtain a Base64 encoded version of a Token's PRG you can call the function:
16 
17 function getTokenPRGBase64(uint256 tokenId, bool pal, uint8 filterResonanceRouting, uint8 filterModeVolume)
18 
19 where:
20 
21   tokenId                - the id of the token
22   pal                    - true for a pal version, false for ntsc
23   filterResonanceRouting - 0 for default, otherwise a byte value in the format the SID register $d417 expects:
24                              bit 0:    set to 1 to filter voice 1
25                              bit 1:    set to 1 to filter voice 2
26                              bit 2:    set to 1 to filter voice 3
27                              bit 3:    set to 1 to filter external voice (not used)
28                              bits 4-7: filter resonance (0-15)
29 
30   filterModeVolume       - 0 for default, otherwise a byte value in the format the SID register $d418 expects:
31                              bits 0-3: volume (0-15)
32                              bit 4:    set to 1 to enable the low pass filter
33                              bit 5:    set to 1 to enable the band pass filter
34                              bit 6:    set to 1 to enable the high pass filter
35                              bit 7:    set to 1 to disable voice 3
36 
37 The filters in some older model C64s may produce excessive distortion. If you intend to run the PRG
38 on one of these models, a value of 240 for filterResonanceRouting may produce a better output than
39 the default value.
40 
41 **********************************************************************************************************/
42 
43 // File: @openzeppelin/contracts@4.7.3/utils/Strings.sol
44 
45 
46 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
47 
48 pragma solidity ^0.8.0;
49 
50 /**
51  * @dev String operations.
52  */
53 library Strings {
54     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
55     uint8 private constant _ADDRESS_LENGTH = 20;
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
59      */
60     function toString(uint256 value) internal pure returns (string memory) {
61         // Inspired by OraclizeAPI's implementation - MIT licence
62         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
63 
64         if (value == 0) {
65             return "0";
66         }
67         uint256 temp = value;
68         uint256 digits;
69         while (temp != 0) {
70             digits++;
71             temp /= 10;
72         }
73         bytes memory buffer = new bytes(digits);
74         while (value != 0) {
75             digits -= 1;
76             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
77             value /= 10;
78         }
79         return string(buffer);
80     }
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
84      */
85     function toHexString(uint256 value) internal pure returns (string memory) {
86         if (value == 0) {
87             return "0x00";
88         }
89         uint256 temp = value;
90         uint256 length = 0;
91         while (temp != 0) {
92             length++;
93             temp >>= 8;
94         }
95         return toHexString(value, length);
96     }
97 
98     /**
99      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
100      */
101     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
102         bytes memory buffer = new bytes(2 * length + 2);
103         buffer[0] = "0";
104         buffer[1] = "x";
105         for (uint256 i = 2 * length + 1; i > 1; --i) {
106             buffer[i] = _HEX_SYMBOLS[value & 0xf];
107             value >>= 4;
108         }
109         require(value == 0, "Strings: hex length insufficient");
110         return string(buffer);
111     }
112 
113     /**
114      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
115      */
116     function toHexString(address addr) internal pure returns (string memory) {
117         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
118     }
119 }
120 
121 // File: @openzeppelin/contracts@4.7.3/utils/Context.sol
122 
123 
124 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
125 
126 pragma solidity ^0.8.0;
127 
128 /**
129  * @dev Provides information about the current execution context, including the
130  * sender of the transaction and its data. While these are generally available
131  * via msg.sender and msg.data, they should not be accessed in such a direct
132  * manner, since when dealing with meta-transactions the account sending and
133  * paying for execution may not be the actual sender (as far as an application
134  * is concerned).
135  *
136  * This contract is only required for intermediate, library-like contracts.
137  */
138 abstract contract Context {
139     function _msgSender() internal view virtual returns (address) {
140         return msg.sender;
141     }
142 
143     function _msgData() internal view virtual returns (bytes calldata) {
144         return msg.data;
145     }
146 }
147 
148 // File: @openzeppelin/contracts@4.7.3/access/Ownable.sol
149 
150 
151 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
152 
153 pragma solidity ^0.8.0;
154 
155 
156 /**
157  * @dev Contract module which provides a basic access control mechanism, where
158  * there is an account (an owner) that can be granted exclusive access to
159  * specific functions.
160  *
161  * By default, the owner account will be the one that deploys the contract. This
162  * can later be changed with {transferOwnership}.
163  *
164  * This module is used through inheritance. It will make available the modifier
165  * `onlyOwner`, which can be applied to your functions to restrict their use to
166  * the owner.
167  */
168 abstract contract Ownable is Context {
169     address private _owner;
170 
171     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
172 
173     /**
174      * @dev Initializes the contract setting the deployer as the initial owner.
175      */
176     constructor() {
177         _transferOwnership(_msgSender());
178     }
179 
180     /**
181      * @dev Throws if called by any account other than the owner.
182      */
183     modifier onlyOwner() {
184         _checkOwner();
185         _;
186     }
187 
188     /**
189      * @dev Returns the address of the current owner.
190      */
191     function owner() public view virtual returns (address) {
192         return _owner;
193     }
194 
195     /**
196      * @dev Throws if the sender is not the owner.
197      */
198     function _checkOwner() internal view virtual {
199         require(owner() == _msgSender(), "Ownable: caller is not the owner");
200     }
201 
202     /**
203      * @dev Leaves the contract without owner. It will not be possible to call
204      * `onlyOwner` functions anymore. Can only be called by the current owner.
205      *
206      * NOTE: Renouncing ownership will leave the contract without an owner,
207      * thereby removing any functionality that is only available to the owner.
208      */
209     function renounceOwnership() public virtual onlyOwner {
210         _transferOwnership(address(0));
211     }
212 
213     /**
214      * @dev Transfers ownership of the contract to a new account (`newOwner`).
215      * Can only be called by the current owner.
216      */
217     function transferOwnership(address newOwner) public virtual onlyOwner {
218         require(newOwner != address(0), "Ownable: new owner is the zero address");
219         _transferOwnership(newOwner);
220     }
221 
222     /**
223      * @dev Transfers ownership of the contract to a new account (`newOwner`).
224      * Internal function without access restriction.
225      */
226     function _transferOwnership(address newOwner) internal virtual {
227         address oldOwner = _owner;
228         _owner = newOwner;
229         emit OwnershipTransferred(oldOwner, newOwner);
230     }
231 }
232 
233 // File: @openzeppelin/contracts@4.7.3/utils/Address.sol
234 
235 
236 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
237 
238 pragma solidity ^0.8.1;
239 
240 /**
241  * @dev Collection of functions related to the address type
242  */
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, `isContract` will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      *
261      * [IMPORTANT]
262      * ====
263      * You shouldn't rely on `isContract` to protect against flash loan attacks!
264      *
265      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
266      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
267      * constructor.
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies on extcodesize/address.code.length, which returns 0
272         // for contracts in construction, since the code is only stored at the end
273         // of the constructor execution.
274 
275         return account.code.length > 0;
276     }
277 
278     /**
279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280      * `recipient`, forwarding all available gas and reverting on errors.
281      *
282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
284      * imposed by `transfer`, making them unable to receive funds via
285      * `transfer`. {sendValue} removes this limitation.
286      *
287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288      *
289      * IMPORTANT: because control is transferred to `recipient`, care must be
290      * taken to not create reentrancy vulnerabilities. Consider using
291      * {ReentrancyGuard} or the
292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         (bool success, ) = recipient.call{value: amount}("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain `call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320         return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(
330         address target,
331         bytes memory data,
332         string memory errorMessage
333     ) internal returns (bytes memory) {
334         return functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(
349         address target,
350         bytes memory data,
351         uint256 value
352     ) internal returns (bytes memory) {
353         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
358      * with `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(
363         address target,
364         bytes memory data,
365         uint256 value,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         require(address(this).balance >= value, "Address: insufficient balance for call");
369         require(isContract(target), "Address: call to non-contract");
370 
371         (bool success, bytes memory returndata) = target.call{value: value}(data);
372         return verifyCallResult(success, returndata, errorMessage);
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
382         return functionStaticCall(target, data, "Address: low-level static call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
387      * but performing a static call.
388      *
389      * _Available since v3.3._
390      */
391     function functionStaticCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal view returns (bytes memory) {
396         require(isContract(target), "Address: static call to non-contract");
397 
398         (bool success, bytes memory returndata) = target.staticcall(data);
399         return verifyCallResult(success, returndata, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
404      * but performing a delegate call.
405      *
406      * _Available since v3.4._
407      */
408     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
409         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
414      * but performing a delegate call.
415      *
416      * _Available since v3.4._
417      */
418     function functionDelegateCall(
419         address target,
420         bytes memory data,
421         string memory errorMessage
422     ) internal returns (bytes memory) {
423         require(isContract(target), "Address: delegate call to non-contract");
424 
425         (bool success, bytes memory returndata) = target.delegatecall(data);
426         return verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
431      * revert reason using the provided one.
432      *
433      * _Available since v4.3._
434      */
435     function verifyCallResult(
436         bool success,
437         bytes memory returndata,
438         string memory errorMessage
439     ) internal pure returns (bytes memory) {
440         if (success) {
441             return returndata;
442         } else {
443             // Look for revert reason and bubble it up if present
444             if (returndata.length > 0) {
445                 // The easiest way to bubble the revert reason is using memory via assembly
446                 /// @solidity memory-safe-assembly
447                 assembly {
448                     let returndata_size := mload(returndata)
449                     revert(add(32, returndata), returndata_size)
450                 }
451             } else {
452                 revert(errorMessage);
453             }
454         }
455     }
456 }
457 
458 // File: @openzeppelin/contracts@4.7.3/token/ERC721/IERC721Receiver.sol
459 
460 
461 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @title ERC721 token receiver interface
467  * @dev Interface for any contract that wants to support safeTransfers
468  * from ERC721 asset contracts.
469  */
470 interface IERC721Receiver {
471     /**
472      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
473      * by `operator` from `from`, this function is called.
474      *
475      * It must return its Solidity selector to confirm the token transfer.
476      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
477      *
478      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
479      */
480     function onERC721Received(
481         address operator,
482         address from,
483         uint256 tokenId,
484         bytes calldata data
485     ) external returns (bytes4);
486 }
487 
488 // File: @openzeppelin/contracts@4.7.3/utils/introspection/IERC165.sol
489 
490 
491 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
492 
493 pragma solidity ^0.8.0;
494 
495 /**
496  * @dev Interface of the ERC165 standard, as defined in the
497  * https://eips.ethereum.org/EIPS/eip-165[EIP].
498  *
499  * Implementers can declare support of contract interfaces, which can then be
500  * queried by others ({ERC165Checker}).
501  *
502  * For an implementation, see {ERC165}.
503  */
504 interface IERC165 {
505     /**
506      * @dev Returns true if this contract implements the interface defined by
507      * `interfaceId`. See the corresponding
508      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
509      * to learn more about how these ids are created.
510      *
511      * This function call must use less than 30 000 gas.
512      */
513     function supportsInterface(bytes4 interfaceId) external view returns (bool);
514 }
515 
516 // File: @openzeppelin/contracts@4.7.3/utils/introspection/ERC165.sol
517 
518 
519 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
520 
521 pragma solidity ^0.8.0;
522 
523 
524 /**
525  * @dev Implementation of the {IERC165} interface.
526  *
527  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
528  * for the additional interface id that will be supported. For example:
529  *
530  * ```solidity
531  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
532  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
533  * }
534  * ```
535  *
536  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
537  */
538 abstract contract ERC165 is IERC165 {
539     /**
540      * @dev See {IERC165-supportsInterface}.
541      */
542     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
543         return interfaceId == type(IERC165).interfaceId;
544     }
545 }
546 
547 // File: @openzeppelin/contracts@4.7.3/token/ERC721/IERC721.sol
548 
549 
550 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
551 
552 pragma solidity ^0.8.0;
553 
554 
555 /**
556  * @dev Required interface of an ERC721 compliant contract.
557  */
558 interface IERC721 is IERC165 {
559     /**
560      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
561      */
562     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
563 
564     /**
565      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
566      */
567     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
568 
569     /**
570      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
571      */
572     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
573 
574     /**
575      * @dev Returns the number of tokens in ``owner``'s account.
576      */
577     function balanceOf(address owner) external view returns (uint256 balance);
578 
579     /**
580      * @dev Returns the owner of the `tokenId` token.
581      *
582      * Requirements:
583      *
584      * - `tokenId` must exist.
585      */
586     function ownerOf(uint256 tokenId) external view returns (address owner);
587 
588     /**
589      * @dev Safely transfers `tokenId` token from `from` to `to`.
590      *
591      * Requirements:
592      *
593      * - `from` cannot be the zero address.
594      * - `to` cannot be the zero address.
595      * - `tokenId` token must exist and be owned by `from`.
596      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
597      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
598      *
599      * Emits a {Transfer} event.
600      */
601     function safeTransferFrom(
602         address from,
603         address to,
604         uint256 tokenId,
605         bytes calldata data
606     ) external;
607 
608     /**
609      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
610      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
611      *
612      * Requirements:
613      *
614      * - `from` cannot be the zero address.
615      * - `to` cannot be the zero address.
616      * - `tokenId` token must exist and be owned by `from`.
617      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
618      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
619      *
620      * Emits a {Transfer} event.
621      */
622     function safeTransferFrom(
623         address from,
624         address to,
625         uint256 tokenId
626     ) external;
627 
628     /**
629      * @dev Transfers `tokenId` token from `from` to `to`.
630      *
631      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
632      *
633      * Requirements:
634      *
635      * - `from` cannot be the zero address.
636      * - `to` cannot be the zero address.
637      * - `tokenId` token must be owned by `from`.
638      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
639      *
640      * Emits a {Transfer} event.
641      */
642     function transferFrom(
643         address from,
644         address to,
645         uint256 tokenId
646     ) external;
647 
648     /**
649      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
650      * The approval is cleared when the token is transferred.
651      *
652      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
653      *
654      * Requirements:
655      *
656      * - The caller must own the token or be an approved operator.
657      * - `tokenId` must exist.
658      *
659      * Emits an {Approval} event.
660      */
661     function approve(address to, uint256 tokenId) external;
662 
663     /**
664      * @dev Approve or remove `operator` as an operator for the caller.
665      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
666      *
667      * Requirements:
668      *
669      * - The `operator` cannot be the caller.
670      *
671      * Emits an {ApprovalForAll} event.
672      */
673     function setApprovalForAll(address operator, bool _approved) external;
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
685      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
686      *
687      * See {setApprovalForAll}
688      */
689     function isApprovedForAll(address owner, address operator) external view returns (bool);
690 }
691 
692 // File: @openzeppelin/contracts@4.7.3/token/ERC721/extensions/IERC721Enumerable.sol
693 
694 
695 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
696 
697 pragma solidity ^0.8.0;
698 
699 
700 /**
701  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
702  * @dev See https://eips.ethereum.org/EIPS/eip-721
703  */
704 interface IERC721Enumerable is IERC721 {
705     /**
706      * @dev Returns the total amount of tokens stored by the contract.
707      */
708     function totalSupply() external view returns (uint256);
709 
710     /**
711      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
712      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
713      */
714     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
715 
716     /**
717      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
718      * Use along with {totalSupply} to enumerate all tokens.
719      */
720     function tokenByIndex(uint256 index) external view returns (uint256);
721 }
722 
723 // File: @openzeppelin/contracts@4.7.3/token/ERC721/extensions/IERC721Metadata.sol
724 
725 
726 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
727 
728 pragma solidity ^0.8.0;
729 
730 
731 /**
732  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
733  * @dev See https://eips.ethereum.org/EIPS/eip-721
734  */
735 interface IERC721Metadata is IERC721 {
736     /**
737      * @dev Returns the token collection name.
738      */
739     function name() external view returns (string memory);
740 
741     /**
742      * @dev Returns the token collection symbol.
743      */
744     function symbol() external view returns (string memory);
745 
746     /**
747      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
748      */
749     function tokenURI(uint256 tokenId) external view returns (string memory);
750 }
751 
752 // File: @openzeppelin/contracts@4.7.3/token/ERC721/ERC721.sol
753 
754 
755 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
756 
757 pragma solidity ^0.8.0;
758 
759 
760 
761 
762 
763 
764 
765 
766 /**
767  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
768  * the Metadata extension, but not including the Enumerable extension, which is available separately as
769  * {ERC721Enumerable}.
770  */
771 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
772     using Address for address;
773     using Strings for uint256;
774 
775     // Token name
776     string private _name;
777 
778     // Token symbol
779     string private _symbol;
780 
781     // Mapping from token ID to owner address
782     mapping(uint256 => address) private _owners;
783 
784     // Mapping owner address to token count
785     mapping(address => uint256) private _balances;
786 
787     // Mapping from token ID to approved address
788     mapping(uint256 => address) private _tokenApprovals;
789 
790     // Mapping from owner to operator approvals
791     mapping(address => mapping(address => bool)) private _operatorApprovals;
792 
793     /**
794      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
795      */
796     constructor(string memory name_, string memory symbol_) {
797         _name = name_;
798         _symbol = symbol_;
799     }
800 
801     /**
802      * @dev See {IERC165-supportsInterface}.
803      */
804     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
805         return
806             interfaceId == type(IERC721).interfaceId ||
807             interfaceId == type(IERC721Metadata).interfaceId ||
808             super.supportsInterface(interfaceId);
809     }
810 
811     /**
812      * @dev See {IERC721-balanceOf}.
813      */
814     function balanceOf(address owner) public view virtual override returns (uint256) {
815         require(owner != address(0), "ERC721: address zero is not a valid owner");
816         return _balances[owner];
817     }
818 
819     /**
820      * @dev See {IERC721-ownerOf}.
821      */
822     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
823         address owner = _owners[tokenId];
824         require(owner != address(0), "ERC721: invalid token ID");
825         return owner;
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-name}.
830      */
831     function name() public view virtual override returns (string memory) {
832         return _name;
833     }
834 
835     /**
836      * @dev See {IERC721Metadata-symbol}.
837      */
838     function symbol() public view virtual override returns (string memory) {
839         return _symbol;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-tokenURI}.
844      */
845     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
846         _requireMinted(tokenId);
847 
848         string memory baseURI = _baseURI();
849         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
850     }
851 
852     /**
853      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
854      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
855      * by default, can be overridden in child contracts.
856      */
857     function _baseURI() internal view virtual returns (string memory) {
858         return "";
859     }
860 
861     /**
862      * @dev See {IERC721-approve}.
863      */
864     function approve(address to, uint256 tokenId) public virtual override {
865         address owner = ERC721.ownerOf(tokenId);
866         require(to != owner, "ERC721: approval to current owner");
867 
868         require(
869             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
870             "ERC721: approve caller is not token owner nor approved for all"
871         );
872 
873         _approve(to, tokenId);
874     }
875 
876     /**
877      * @dev See {IERC721-getApproved}.
878      */
879     function getApproved(uint256 tokenId) public view virtual override returns (address) {
880         _requireMinted(tokenId);
881 
882         return _tokenApprovals[tokenId];
883     }
884 
885     /**
886      * @dev See {IERC721-setApprovalForAll}.
887      */
888     function setApprovalForAll(address operator, bool approved) public virtual override {
889         _setApprovalForAll(_msgSender(), operator, approved);
890     }
891 
892     /**
893      * @dev See {IERC721-isApprovedForAll}.
894      */
895     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
896         return _operatorApprovals[owner][operator];
897     }
898 
899     /**
900      * @dev See {IERC721-transferFrom}.
901      */
902     function transferFrom(
903         address from,
904         address to,
905         uint256 tokenId
906     ) public virtual override {
907         //solhint-disable-next-line max-line-length
908         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
909 
910         _transfer(from, to, tokenId);
911     }
912 
913     /**
914      * @dev See {IERC721-safeTransferFrom}.
915      */
916     function safeTransferFrom(
917         address from,
918         address to,
919         uint256 tokenId
920     ) public virtual override {
921         safeTransferFrom(from, to, tokenId, "");
922     }
923 
924     /**
925      * @dev See {IERC721-safeTransferFrom}.
926      */
927     function safeTransferFrom(
928         address from,
929         address to,
930         uint256 tokenId,
931         bytes memory data
932     ) public virtual override {
933         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
934         _safeTransfer(from, to, tokenId, data);
935     }
936 
937     /**
938      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
939      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
940      *
941      * `data` is additional data, it has no specified format and it is sent in call to `to`.
942      *
943      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
944      * implement alternative mechanisms to perform token transfer, such as signature-based.
945      *
946      * Requirements:
947      *
948      * - `from` cannot be the zero address.
949      * - `to` cannot be the zero address.
950      * - `tokenId` token must exist and be owned by `from`.
951      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
952      *
953      * Emits a {Transfer} event.
954      */
955     function _safeTransfer(
956         address from,
957         address to,
958         uint256 tokenId,
959         bytes memory data
960     ) internal virtual {
961         _transfer(from, to, tokenId);
962         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
963     }
964 
965     /**
966      * @dev Returns whether `tokenId` exists.
967      *
968      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
969      *
970      * Tokens start existing when they are minted (`_mint`),
971      * and stop existing when they are burned (`_burn`).
972      */
973     function _exists(uint256 tokenId) internal view virtual returns (bool) {
974         return _owners[tokenId] != address(0);
975     }
976 
977     /**
978      * @dev Returns whether `spender` is allowed to manage `tokenId`.
979      *
980      * Requirements:
981      *
982      * - `tokenId` must exist.
983      */
984     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
985         address owner = ERC721.ownerOf(tokenId);
986         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
987     }
988 
989     /**
990      * @dev Safely mints `tokenId` and transfers it to `to`.
991      *
992      * Requirements:
993      *
994      * - `tokenId` must not exist.
995      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
996      *
997      * Emits a {Transfer} event.
998      */
999     function _safeMint(address to, uint256 tokenId) internal virtual {
1000         _safeMint(to, tokenId, "");
1001     }
1002 
1003     /**
1004      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1005      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1006      */
1007     function _safeMint(
1008         address to,
1009         uint256 tokenId,
1010         bytes memory data
1011     ) internal virtual {
1012         _mint(to, tokenId);
1013         require(
1014             _checkOnERC721Received(address(0), to, tokenId, data),
1015             "ERC721: transfer to non ERC721Receiver implementer"
1016         );
1017     }
1018 
1019     /**
1020      * @dev Mints `tokenId` and transfers it to `to`.
1021      *
1022      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1023      *
1024      * Requirements:
1025      *
1026      * - `tokenId` must not exist.
1027      * - `to` cannot be the zero address.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _mint(address to, uint256 tokenId) internal virtual {
1032         require(to != address(0), "ERC721: mint to the zero address");
1033         require(!_exists(tokenId), "ERC721: token already minted");
1034 
1035         _beforeTokenTransfer(address(0), to, tokenId);
1036 
1037         _balances[to] += 1;
1038         _owners[tokenId] = to;
1039 
1040         emit Transfer(address(0), to, tokenId);
1041 
1042         _afterTokenTransfer(address(0), to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev Destroys `tokenId`.
1047      * The approval is cleared when the token is burned.
1048      *
1049      * Requirements:
1050      *
1051      * - `tokenId` must exist.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _burn(uint256 tokenId) internal virtual {
1056         address owner = ERC721.ownerOf(tokenId);
1057 
1058         _beforeTokenTransfer(owner, address(0), tokenId);
1059 
1060         // Clear approvals
1061         _approve(address(0), tokenId);
1062 
1063         _balances[owner] -= 1;
1064         delete _owners[tokenId];
1065 
1066         emit Transfer(owner, address(0), tokenId);
1067 
1068         _afterTokenTransfer(owner, address(0), tokenId);
1069     }
1070 
1071     /**
1072      * @dev Transfers `tokenId` from `from` to `to`.
1073      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1074      *
1075      * Requirements:
1076      *
1077      * - `to` cannot be the zero address.
1078      * - `tokenId` token must be owned by `from`.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _transfer(
1083         address from,
1084         address to,
1085         uint256 tokenId
1086     ) internal virtual {
1087         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1088         require(to != address(0), "ERC721: transfer to the zero address");
1089 
1090         _beforeTokenTransfer(from, to, tokenId);
1091 
1092         // Clear approvals from the previous owner
1093         _approve(address(0), tokenId);
1094 
1095         _balances[from] -= 1;
1096         _balances[to] += 1;
1097         _owners[tokenId] = to;
1098 
1099         emit Transfer(from, to, tokenId);
1100 
1101         _afterTokenTransfer(from, to, tokenId);
1102     }
1103 
1104     /**
1105      * @dev Approve `to` to operate on `tokenId`
1106      *
1107      * Emits an {Approval} event.
1108      */
1109     function _approve(address to, uint256 tokenId) internal virtual {
1110         _tokenApprovals[tokenId] = to;
1111         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1112     }
1113 
1114     /**
1115      * @dev Approve `operator` to operate on all of `owner` tokens
1116      *
1117      * Emits an {ApprovalForAll} event.
1118      */
1119     function _setApprovalForAll(
1120         address owner,
1121         address operator,
1122         bool approved
1123     ) internal virtual {
1124         require(owner != operator, "ERC721: approve to caller");
1125         _operatorApprovals[owner][operator] = approved;
1126         emit ApprovalForAll(owner, operator, approved);
1127     }
1128 
1129     /**
1130      * @dev Reverts if the `tokenId` has not been minted yet.
1131      */
1132     function _requireMinted(uint256 tokenId) internal view virtual {
1133         require(_exists(tokenId), "ERC721: invalid token ID");
1134     }
1135 
1136     /**
1137      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1138      * The call is not executed if the target address is not a contract.
1139      *
1140      * @param from address representing the previous owner of the given token ID
1141      * @param to target address that will receive the tokens
1142      * @param tokenId uint256 ID of the token to be transferred
1143      * @param data bytes optional data to send along with the call
1144      * @return bool whether the call correctly returned the expected magic value
1145      */
1146     function _checkOnERC721Received(
1147         address from,
1148         address to,
1149         uint256 tokenId,
1150         bytes memory data
1151     ) private returns (bool) {
1152         if (to.isContract()) {
1153             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1154                 return retval == IERC721Receiver.onERC721Received.selector;
1155             } catch (bytes memory reason) {
1156                 if (reason.length == 0) {
1157                     revert("ERC721: transfer to non ERC721Receiver implementer");
1158                 } else {
1159                     /// @solidity memory-safe-assembly
1160                     assembly {
1161                         revert(add(32, reason), mload(reason))
1162                     }
1163                 }
1164             }
1165         } else {
1166             return true;
1167         }
1168     }
1169 
1170     /**
1171      * @dev Hook that is called before any token transfer. This includes minting
1172      * and burning.
1173      *
1174      * Calling conditions:
1175      *
1176      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1177      * transferred to `to`.
1178      * - When `from` is zero, `tokenId` will be minted for `to`.
1179      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1180      * - `from` and `to` are never both zero.
1181      *
1182      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1183      */
1184     function _beforeTokenTransfer(
1185         address from,
1186         address to,
1187         uint256 tokenId
1188     ) internal virtual {}
1189 
1190     /**
1191      * @dev Hook that is called after any transfer of tokens. This includes
1192      * minting and burning.
1193      *
1194      * Calling conditions:
1195      *
1196      * - when `from` and `to` are both non-zero.
1197      * - `from` and `to` are never both zero.
1198      *
1199      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1200      */
1201     function _afterTokenTransfer(
1202         address from,
1203         address to,
1204         uint256 tokenId
1205     ) internal virtual {}
1206 }
1207 
1208 // File: @openzeppelin/contracts@4.7.3/token/ERC721/extensions/ERC721Enumerable.sol
1209 
1210 
1211 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1212 
1213 pragma solidity ^0.8.0;
1214 
1215 
1216 
1217 /**
1218  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1219  * enumerability of all the token ids in the contract as well as all token ids owned by each
1220  * account.
1221  */
1222 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1223     // Mapping from owner to list of owned token IDs
1224     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1225 
1226     // Mapping from token ID to index of the owner tokens list
1227     mapping(uint256 => uint256) private _ownedTokensIndex;
1228 
1229     // Array with all token ids, used for enumeration
1230     uint256[] private _allTokens;
1231 
1232     // Mapping from token id to position in the allTokens array
1233     mapping(uint256 => uint256) private _allTokensIndex;
1234 
1235     /**
1236      * @dev See {IERC165-supportsInterface}.
1237      */
1238     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1239         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1240     }
1241 
1242     /**
1243      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1244      */
1245     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1246         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1247         return _ownedTokens[owner][index];
1248     }
1249 
1250     /**
1251      * @dev See {IERC721Enumerable-totalSupply}.
1252      */
1253     function totalSupply() public view virtual override returns (uint256) {
1254         return _allTokens.length;
1255     }
1256 
1257     /**
1258      * @dev See {IERC721Enumerable-tokenByIndex}.
1259      */
1260     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1261         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1262         return _allTokens[index];
1263     }
1264 
1265     /**
1266      * @dev Hook that is called before any token transfer. This includes minting
1267      * and burning.
1268      *
1269      * Calling conditions:
1270      *
1271      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1272      * transferred to `to`.
1273      * - When `from` is zero, `tokenId` will be minted for `to`.
1274      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1275      * - `from` cannot be the zero address.
1276      * - `to` cannot be the zero address.
1277      *
1278      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1279      */
1280     function _beforeTokenTransfer(
1281         address from,
1282         address to,
1283         uint256 tokenId
1284     ) internal virtual override {
1285         super._beforeTokenTransfer(from, to, tokenId);
1286 
1287         if (from == address(0)) {
1288             _addTokenToAllTokensEnumeration(tokenId);
1289         } else if (from != to) {
1290             _removeTokenFromOwnerEnumeration(from, tokenId);
1291         }
1292         if (to == address(0)) {
1293             _removeTokenFromAllTokensEnumeration(tokenId);
1294         } else if (to != from) {
1295             _addTokenToOwnerEnumeration(to, tokenId);
1296         }
1297     }
1298 
1299     /**
1300      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1301      * @param to address representing the new owner of the given token ID
1302      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1303      */
1304     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1305         uint256 length = ERC721.balanceOf(to);
1306         _ownedTokens[to][length] = tokenId;
1307         _ownedTokensIndex[tokenId] = length;
1308     }
1309 
1310     /**
1311      * @dev Private function to add a token to this extension's token tracking data structures.
1312      * @param tokenId uint256 ID of the token to be added to the tokens list
1313      */
1314     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1315         _allTokensIndex[tokenId] = _allTokens.length;
1316         _allTokens.push(tokenId);
1317     }
1318 
1319     /**
1320      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1321      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1322      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1323      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1324      * @param from address representing the previous owner of the given token ID
1325      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1326      */
1327     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1328         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1329         // then delete the last slot (swap and pop).
1330 
1331         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1332         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1333 
1334         // When the token to delete is the last token, the swap operation is unnecessary
1335         if (tokenIndex != lastTokenIndex) {
1336             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1337 
1338             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1339             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1340         }
1341 
1342         // This also deletes the contents at the last position of the array
1343         delete _ownedTokensIndex[tokenId];
1344         delete _ownedTokens[from][lastTokenIndex];
1345     }
1346 
1347     /**
1348      * @dev Private function to remove a token from this extension's token tracking data structures.
1349      * This has O(1) time complexity, but alters the order of the _allTokens array.
1350      * @param tokenId uint256 ID of the token to be removed from the tokens list
1351      */
1352     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1353         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1354         // then delete the last slot (swap and pop).
1355 
1356         uint256 lastTokenIndex = _allTokens.length - 1;
1357         uint256 tokenIndex = _allTokensIndex[tokenId];
1358 
1359         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1360         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1361         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1362         uint256 lastTokenId = _allTokens[lastTokenIndex];
1363 
1364         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1365         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1366 
1367         // This also deletes the contents at the last position of the array
1368         delete _allTokensIndex[tokenId];
1369         _allTokens.pop();
1370     }
1371 }
1372 
1373 // File: oraand.sol
1374 
1375 pragma solidity ^0.8.4;
1376 
1377 
1378 
1379 
1380 
1381 interface IOraandURI {
1382   function tokenURI(IOraandPRGToken tokenContract, uint256 tokenId) external view returns (string memory);
1383 }
1384 
1385 interface IOraandPRGToken {
1386   function getTokenPRGBase64(uint256 tokenId, bool patchedVersion) external view returns (string memory);
1387   function getTokenPRG(uint256 tokenId, bool pal, uint8 filterResonanceRouting, uint8 filterModeVolume) external view returns (bytes memory);
1388   function getTokenPatchedPRG(uint256 tokenId, bool pal, uint8 filterResonanceRouting, uint8 filterModeVolume) external view returns (bytes memory);
1389   function getTokenAttributes(uint256 tokenId) external view returns (string memory);
1390   function getTokenParams(uint256 tokenId) external view returns (uint64);
1391   function getTokenModes(uint256 tokenId) external view returns (uint8);
1392   function getTokenPatchUnlocked(uint256 tokenId) external view returns (bool);
1393 }
1394 
1395 // ORAAND contract
1396 contract ORAAND is ERC721, ERC721Enumerable, Ownable, IOraandPRGToken {
1397   using Strings for uint256;
1398 
1399   string constant tokenName   = "oraand";
1400   string constant tokenSymbol = "oraand";
1401 
1402   string private description = "2048 byte on chain PRG for the Commodore 64";
1403 
1404   uint256 constant MAX_NUMBER_TOKENS = 1024;
1405 
1406   uint256 public mintPrice = .0256e18;
1407 
1408   uint256 constant DAY_SECONDS = 24 * 60 * 60;
1409 
1410   string private imageBaseURI     = "https://nopsta.com/oraand/i/";
1411   string private animationBaseURI = "https://nopsta.com/oraand/v/";
1412   string private externalBaseURI  = "https://nopsta.com/oraand/";
1413 
1414   bytes constant basePRGData = hex"01080b0800009e323036320000000078a9358501a97f8d0ddc8d0dddad0ddcad0ddda92c8dfaffa90a8dfbffa9018d1ad0a9188d11d0a9ff8dfeffa9098dffffa2fd8e12d0a9009d00309dfc309df93195019dff1fa9089dffd79dfcd89df9d99deadabdbe0c9d0f20bdf60c9d2723cad0d3a93c855ba9e88d18d0a0b4a9038560a9008556b9f20b8848293f9d0070e86829c005564a4a8556c660d0e89d0070e898d0d920c70fa2208e30348666a2488665a7b88d003418bd003469089d0134bd303469009d3134e8e02ed0eaa438be0070bd003485618567bd30348562a9238568be2270bd00348563bd30348564a007b16749ff3163116191658810f3a908a26520f309e638a538c922d0c0a900856c20e20aa203a9ec8dff59a9008d3f5abdcf0a8d3f0a8d500a8d580abdd50a8d440abdd60a8d560abdd40a8596bdd30a8597bdda0a8598bdde0a85998656a22b869ba2fe869da000a201a599202d0ae8e009d0f8a6978696a219869ba202869da207202d0acad0faa656ca1099a9008d20d08d21d0a91f8588a9f4858758af00dcc52ff03b852f2904d002e6578a2908d002c6578a2901d008a558c908f002e6588a2902d006a558f002c6588a2910d00fe66ca56cc9043004a900856c20e20aa66cf01abdec0b8deb09bdef0b8dec09a56ddda80c3007a900856d20b50a20f20a4c8d0918750095009002f601a69e60488a489848a9ff8d19d0204a0de66da55ef014a55b855d4904855bad18d049108d18d0a900855e68a868aa684040869c186596484818a59b659d859b859a68990050481869ffc01d1006e49cd002a9ff99005168481869f8990052681865984818b9ff59659a99005ab93f5a690099405aa902859a68c8cad0c568a69c60ada70cf0030a9002492d8da70c60a9308551a9008550a9408537a000b1508556a007b350a556915086568810f5a908a25020f309c637d0e260c66e3002d004a908856e6018a5586901c909d002a900855860004080c00108fff80108fff90907f7f8084737a9088558a964856da900856e20470d60a55ef002ea60a55b8551a204a000988550915088d0fbe651cad0f1a5572903aabdcf0a8d610b8d770b8d840ba558d003e65e608536a9008554a9308555a93e8530a55b8531a56ef004c536d003205b0b38a530e9288530b002c631a940a25420f309c636d0dfe65e60a200eaeaeabc0050b154f07a18bd005a65308550bd405a65318551bc0051b154c0ffd002a9008533bc0052b15485328660a000b350bd4470e000f00ac909d006a633f002a9019150c8b350bd6f70e000f00ac90fd006a632f002a9019150a028b150f006a903a633d002a9029150c8a9049150a050b350bd9a709150c8b350bdc5709150a660e8e040f0034c5d0b6000070ec1b68b0a0a0aa11fa0088808a1209f5ddc9f5fdfe2a11e5e5ee0de08880808881f48dd9c48c82a8787595a98ea999959a99b9a5897564747470747d9589b1a5987075796150752d2a79414536828a853e75212d25212925352114f13145111515206d14f0f062666a3a625e48e0ece0ece8ea4664d25e44d8d0ccc0ecd0c0a89ce0cc5490a85c55cdf5d5695535550c704428b088584020dc80544c10786030107870645850548480888080787070747c70646860645850545457500280a05000a0a0560500a145028141ea05050220000328000e000f800fe008000e000f800fe000103070f1f3f7fff00000000000000000000000000000000ff003f000f000300fffefcf8f0e0c0800103070f1f3f7fff80c0e0f0f8fcfeffff7f3f1f0f070301fffefcf8f0e0c0802d435a7c5285a95a5a85b4f7a30a52b45a85b4f7a30a52b402030405070603040406080a0e0d07080406080a0e0d07084c7a0fa528d00aa52ba28520f3094c680d38a585e52b8585b007c686100320bd0fc629d00dc62ad009a5284901852820b40fc6241004a94f8524a202a524d007d60fd00320670ebcea0b18b970007509997000b97100750c997100b574c951f03cb5b9d01a18b972007db00c997200900eb973006900290fd002f6b9997300b5b9f01a38b97200fdb00c997200b00eb97300e900290fd002d6b9997300d612d015b506f011b9740049019974004ab5069002b5039512b515f032d615d02eb51ef005d6184c100ef618b51818862d351b7521aab97400c981f00cbd170d997000bd2f0d997100a62db5259515ca30034c830da218b5709d00d4ca10f860100804010707070fa0a0a00a140000000808020032001e0014b4321111418161dddebfbd440ea46cd0010a950fb9b70c852b207d0a39480e0903951b207d0a39470e79530e29079521207d0a2901951ea903855fb9ac0c9525c001d004a9288526c908d002065fa55f95039512207d0ad95b0ea900b002a9029506f612a9019515a941bcea0b997400a46ce002d01a207d0ad9bb0ca900b00e207d0ac920b004a9158582207d0a850e207d0ad9570eb008a9518574a9018573b9b30c859fe000d02d20bd0fc003d0268609207d0ac932b01d290385098625207d0ac932a981b002a9158574861ba55f8503a9028506207d0ad9590eb006a9008523851d98d035bcea0ba911997400e002d00b207d0a2903a8b95f0e8582a92895039512a9789506f612207d0a2907a8b94c0e9525207d0a2901850a60a9018524a214a9009503e0031029bcea0ba56cd010bd650e997500bd620e090d997600d00ba911997500bd620e997600967320670ef60fca10cca9648529a901852a60a59f8586a9008528f0eda9308551a207a03fe007f004b14ef00c207d0addf70fb004a90191508810e9a551854f18a550854e694085509002e651ca10d3603c648cdc";
1415 
1416   uint constant FILTERRESONANCEROUTINGPOSITION = 0x18a;
1417   uint constant FILTERMODEVOLUMEPOSITION       = 0x186;
1418 
1419   // prg data 1
1420   uint constant PRGDATA1SEGMENTLENGTH = 56;
1421   uint constant PRGDATA1POSITION      = 0x7c8;
1422   bytes constant prgData1 = hex"a9308551a207a03feea70c207d0addf20fb004a90191508810eea551854f869ea940a25020f309ca10dc60080e141e3250648c0000000000207d0a293f692ec9549008a2088eab0c8eaf0c85a0a9308551a207a03f207d0ac5a0b004a90191508810f2869ea940a25020f309ca10e460a9a085a0207d0a2907855f29fdd002e65fa9308551a207a03f207d0ac5a0b004a90191503898e55fa810ee869ea940a25020f309ca10e060";
1423   
1424   // prg data 2
1425   uint constant PRGDATA2SEGMENTLENGTH = 239;
1426   uint constant PRGDATA2POSITION      = 0x711;
1427   bytes constant prgData2 = hex"207d0a297fc90ab002690a85a0a9308551a9008550a207a03f207d0ac5a0b004a90191508810f2869ea940a25020f309ca10e4a907859ca003a207bd00309d3830ca10f7a9084820ef0f6838ad4f0fe9088d4f0f8810e2a92020ef0f18ad4f0f69608d4f0f9003ee500fc69c10c9a940859ca003a204b900309d0030e88810f618ad870f69088d870f9003ee880f18ad8a0f69088d8a0f9003ee8b0fc69cd0d2207d0a9031a204a0308451c8844fa9008550a9c0854ea03fb150914e8810f9869ea940a25020f30938a54ee940854eb002c64fcad0e0a9088dab0c8daf0c60186d4c0f8d4c0f9003ee4d0f60000000207d0a290785b4207d0a2907690e859cd006a59c2903d017a9308551207d0a2903d002e651207d0a29db1869008550207d0a25b4aa207d0aa59c2903a8b9dc0f855f20e00fc69cd0c9a907859ca003a207bd00309d3830ca10f7a9084820cf0f6838ad650fe9088d650f8810e2a92020cf0f18ad650f69608d650f9003ee660fc69c10c9a940859ca003a204b900309d0030e88810f618ad9d0f69088d9d0f9003ee9e0f18ada00f69088da00f9003eea10fc69cd0d2a9088dab0c8daf0c60186d620f8d620f9003ee630f6000010840a000a9019150869ea55fa25020f309ca10f060000000000000000000000000207d0a290785b4207d0a2907690e859cd006a59c2903d017a9308551207d0a2903d002e651207d0a29db1869008550207d0a25b4aa207d0aa59c2903a8b9dc0f855f20e00fc69cd0c9a907859ca003a207bd00309d3830ca10f7a9084820cf0f6838ad650fe9088d650f8810e2a92020cf0f18ad650f69608d650f9003ee660fc69c10c9a940859ca003a204b900309d0030e88810f618ad9d0f69088d9d0f9003ee9e0f18ada00f69088da00f9003eea10fc69cd0d2a9088dab0c8daf0c60186d620f8d620f9003ee630f60000105bda000a9019150869ea55fa25020f309ca10f060000000000000000000000000207d0a290f69028de00fa90f85b4207d0a29076906859cd006a59c2903d017a9308551207d0a2903d002e651207d0a29db1869008550207d0a25b4aaa59c2901a8b9e00f855f20e40fc69cd0cca907859ca003a207bd00309d3830ca10f7a9084820d30f6838ad690fe9088d690f8810e2a92020d30f18ad690f69608d690f9003ee6a0fc69c10c9a940859ca003a204b900309d0030e88810f618ada10f69088da10f9003eea20f18ada40f69088da40f9003eea50fc69cd0d2a9088dab0c8daf0c60186d660f8d660f9003ee670f6000010840a000a9019150869eade00fa25020f309ca10ef6000000000000000";
1428 
1429   // prg data 3
1430   uint constant PRGDATA3LENGTH   = 457;
1431   uint constant PRGDATA3POSITION = 0x548;
1432   bytes constant prgData3 = hex"4c740ea46cc624c6a9d00aa98085a9a52849018528a528d00aa5aca28520f3094c750d38a585e5ac8585b002c68618a57f65bc857fc4cff004a524d02da5a739620ed026207d0ad9bb0ca900b003207d0a85bca524d013207d0ac964290885cfb9540eb003b9580e85ada20286a818a5a73d650e6524d005207d0a95b5bcea0bb97400c951f039b5b9d01a18b972007db00c997200900eb973006900290fd002f6b9997300b5b9f01a38b97200fdb00c997200b00eb97300e900290fd002d6b9997300a524d01db51829071875b5f618aabd0060997000bd0061997100a6a8b5ad997400a524d5a1d008b9740029fe997400ca30034cb30da524d006a5aa8524e6a7a218b5709d00d4ca10f8601141414115514151899cdd8689d9031f0f1f3f7f6e8c6e0208080c0c04080a0fa200207d0a291fc91810f7a8b9170dc5b3f0ef85b39d0060b92f0d9d0061cad0e1a214a900950385a7e0031053207d0a9518a94195ada46cb9ac0c85aabcea0b9673a910997500bd5f0e997600a56cd018a9ff85aaa91195ada9f0997500bd5c0e997600bd680ed015c901d005bd6b0ed00cc902d005bd6e0ed003bd710e95a1ca10a0a901852485a98528a46ca9788585b9b30c8586b9b70c85ac60";
1433 
1434   // prg data 4
1435   uint constant PRGDATA4LENGTH   = 457;
1436   uint constant PRGDATA4POSITION = 0x548;
1437   bytes constant prgData4 = hex"4c7b0ea200d00ffe00d8fe00d9fe00dafe00dbcad0f1a46cc003d004a915d00e6674e6bda5bd29036900aabd6f0e8574c624c6a9d007a98085a920010fa5aca28520f30918a57f65bc857fc000f004a524d016a5a7395d0ed00f207d0ad9bb0ca900b003207d0a85bc207d0ac964b94f0eb003b9530e85ada20286a818a5a73d600e6524d005207d0a95b5bcea0b38b97000e906997000b00fb97100e900997100b005a90099710018b972007db00c997200b973006900997300a524d023a46cb51839770ebcea0b1875b5f618aabd0060997000bd0061997100a6a8b5ad997400a524d5a1d005a920997400ca108ba524d006a5aa8524e6a7a901857aa218b5709d00d4ca10f8604141414115514151ed98fae698fa031f0f1f3f7f648c6e010303070704080a0f5020508000070a0807000307a200207d0a291fc91810f7a8b9170dc5b3f0ef85b39d0060b92f0d9d0061cad0e1a214a900950385a7e003104e207d0a9518a94195ada46cb9730e85aabcea0b9673a910997500bd5a0e997600a56cd013a90a85aaa94195adbd570e997600bd630ed015c901d005bd660ed00cc902d005bd690ed003bd6c0e95a1ca10a5a901852485a98528a46cb9b30c8586b9b70c85ac60a930";
1438 
1439   // prg data 5
1440   uint constant PRGDATA5POSITION      = 0x518;
1441   uint constant PRGDATA5SEGMENTLENGTH = 24;
1442   bytes constant prgData5 = hex"1727394b5f748aa1bad4f00e2d4e7196bee8144374a9e11c5a9ce22d7ccf2885e852c137b439c55af79e4f0ad1a3826e68718ab3ee3c9e15a24604dcd0e21467dd793c29448d08b8a1c528cdbaf17853871a10710c1c2d3f52667b92aac3defa18385a7ea4ccf7245486bcf53171b5fc4898ee48a90d79ea62e26af89030dc90521af2d4c4c4d4f02060b820a434e4a88888a8e040c070404868c850101050c08080e08090d090a0";
1443 
1444   // prg data 6
1445   uint constant PRGDATA6POSITION = 0x530;
1446   bytes constant prgData6 = hex"0101010101010101010101020202020202020303030303040404040505050606060707080809090a0a0b0c0d0d0e0f10111213141517181a1b1d1f20222427292b2e3134373a3e4145494e52575c62686e757c83010101010101010101010101020202020202020303030303040404040505050606070707080809090a0b0b0c0d0e0e0f10111213151617191a1c1d1f212325272a2c2f3235383b3f43474b4f54595e646a70777e";
1447 
1448   // prg data 7
1449   uint constant PRGDATA7POSITION = 0x56;
1450   bytes constant prgData7 = hex"000b0b0402060d010a0c0b06060e000f000f0f010b0d01000607000f000b0e06";
1451 
1452   // prg data 8
1453   uint constant PRGDATA8POSITION = 0x17e;
1454   bytes constant prgData8 = hex"010f000101010506020b0c0e0e060f0b0f0b0004010002070302030b010f060e";
1455 
1456   // prg data 9
1457   uint constant PRGDATA9POSITION = 0x287;
1458   bytes constant prgData9 = hex"1d2b2d4d5f63656971878da9c3cfe7f5";
1459 
1460   // prg data 10
1461   uint constant PRGDATA10SEGMENTLENGTH = 3;
1462   uint constant PRGDATA10POSITION      = 0x4b1;
1463   bytes constant prgData10 = hex"08000014000a14005014281478785050505060500a020408";
1464 
1465   // increment prob
1466   // length 16
1467   uint constant PRGDATA11SEGMENTLENGTH = 4;
1468   uint constant PRGDATA11POSITION      = 0x4bc;
1469 
1470   // prg data 11
1471   bytes constant prgData11 = hex"320000141400001e0a00001420000020";
1472 
1473   // prg data 12
1474   uint constant PRGDATA12SEGMENTLENGTH = 4;
1475   uint constant PRGDATA12POSITION      = 0x4b8; 
1476   bytes constant prgData12 = hex"1ea05050325050a0";
1477 
1478   // prg data 13
1479   uint constant PRGDATA13SEGMENTLENGTH = 56;
1480   uint constant PRGDATA13POSITION      = 0x4c0;
1481   bytes constant prgData13 = hex"8000e000f800fe008000e000f800fe000102070a1f2a7faa00000000000000000000000000000000ff003f000f000300ffaafca8f0a0c08080c0a0908884828180c0a0908884828101030509112141810102040810204080804020100804020181412111090503018182848890a0c08080c0e0f0f8fcfeff80c0e0f0f8fcfeff0103070f1f3f7fff00000000000000000000000000000000ff7f3f1f0f070301fffefcf8f0e0c08080c0e0f0f8fcfeff80c0e0f0f8fcfeff0103050911214181010204081020408080402010080402017f3f1f0f07030100010204081020408020104864524944422010486452494442040812264a922242000001020408102000008040201008044222120a06020000424448506040000080402090c8e4723980402090c8e472390102040913274e9c010204081020408080402010080402019c4e2713090402013972e4c8902040808040209048a452298040209048a452290102040912254a9401020408102040808040201008040201944a2512090402012952a4489020408080c0e0b0988c868380c0e0b0988c86830103070d193161c101020408102040808040201008040201c16131190d07030183868c98b0e0c08080c0e0b0d8acd6ab80c0e0b0d8acd6ab0103070d1b356bd501020408102040808040201008040201d56b351b0d070301abd6acd8b0e0c08080c0a0908884c2a180402010088442210102050b162d5bb70102040810204080804020100804020190482412090402016fdebc78f0e0c08080c0a09098a4c28180c0a09098a4c28101030509192543810102040810204080804020100804020181412111090503018182848890a0c08080c0a09088a492a980402010082412290103070f1d3b75eb01020408102040808040201008040201944a241208040201d7aedcb8f0e0c08080c0e0f0f8fcfeff80c0e0f0f8fcfeff0103070f1f3f7fff01020408102040808040201008040201ff7f3f1f0f070301fffefcf8f0e0c0808000200088002200800020008800220000000200080022000000000000000000000000000000000088002200080002008800200080000000804020904824924980402090482492490102050b162d5bb60102040810204080804020100804020192492412090402016ddab468d0a0408000c000f000fc00ff00c000f000fc00ff0103050e173b5dee00000000000000000000000000000000007f001f0007000177badce870a0c0808000a000a800aa008000a000a800aa000102070a1f2a7faa00000000000000000000000000000000aa002a000a000200ffaafca8f0a0c08080c0a0d0a8d4aad58040a050a854aa550103070f1f3f7fff01020408102040808040201008040201aa552a150a050201fffefcf8f0e0c08080c0a09088c4a29180402010884422110103070f1e3d7bf7010204081020408080402010080402018844221108040201efdebc78f0e0c0808040209048a452298040209048a452290102050b162d5bb601020408102040808040201008040201944a2512090402016ddab468d0a04080804020100804020180402010080402010102040810204080010204081020408080402010080402018040201008040201010204081020408080402090c864b2d980402090c864b2d90102040913264d9b01020408102040808040201008040201ec763b1d0e070301376edcb870e0c0808000e000f800fe008000e000f800fe00010007001f007f0000000000000000000000000000000000ff003f000f000300ff00fc00f000c0008040a050a854aa558040a050a854aa55000102050a152a5500000000000000000000000000000000aa552a150a050201aa54a850a04080008040201088442211804020108844221101020408112244880102040810204080804020100804020188442211080402011122448810204080000080002000880000008000200088000101040613194c660000000000000000000000000000000022000800020000003398cc603080c000000080402010884400008040201088440101040613194c660000000000000000000000000000000022110804020100003398cc603080c0008000a000a800aa008000a000a800aa00000002000a002a0000000000000000000000000000000000aa002a000a000200aa00a800a000800080c0a0908884828180402010080402010103070f1f3f7fff010204081020408080402010080402018040201008040201fefcf8f0e0c08000008000a000a800aa008000a000a800aa0102050a152a55aa00000000000000000000000000000000002a000a0002000055aa54a850a040808040a050a854aa558040a050a854aa550103070f1f3f7fff01020408102040808040201008040201aa552a150a050201fffefcf8f0e0c080";
1482 
1483   // prg data 14
1484   bytes constant prgData14 = hex"0c13181f22181618181f242b2e242224181f242b2e2422240c13181c211f1518181f24282d2b2124181f24282d2b21240c13181b221f1618181f24272e2b2224181f24272e2b22240c13181c231f1718181f24282f2b2324181f24282f2b23240c13181c231f1718181f24282f2b2324302b24283b3723300c13181c221f1618181f24282e2b2224302b24283a3722300c12181b221e1618181e24272e2a2224302a24273a3622300c12181b211e1518181e24272d2a2124302a243339362130";
1485 
1486   // prg data 15
1487   uint constant PRGDATA15LENGTH   = 4;
1488   uint constant PRGDATA15POSITION = 0x4a9;
1489   bytes constant prgData15 = hex"00300C06";
1490 
1491   // prg data 16
1492   uint constant PRGDATA16POSITION = 0x4ad;
1493   bytes constant prgData16 = hex"000C0C06";
1494 
1495   // prg data 17
1496   uint constant PRGDATA17POSITION = 0x64d;
1497   bytes constant prgData17 = hex"c0c0c00c18";
1498 
1499   // patch data 1
1500   uint constant PATCHDATA1LENGTH   = 13;
1501   uint constant PATCHDATA1POSITION = 0x2c2;
1502   bytes constant patchData1 = hex"18ad18d06902290e09e08d18d0";
1503   
1504   // patch data 2
1505   uint constant PATCHDATA2LENGTH   = 6;
1506   uint constant PATCHDATA2POSITION = 0x2b7;
1507   bytes constant patchData2 = hex"a9e88d18d060";
1508 
1509   // patch data 3
1510   uint constant PATCHDATA3LENGTH   = 8;
1511   uint constant PATCHDATA3POSITION = 0x2a0;
1512   bytes constant patchData3 = hex"207d0a29019150ea";
1513 
1514   // patch data 4
1515   uint constant PATCHDATA4LENGTH   = 13;
1516   uint constant PATCHDATA4POSITION = 0x28c;
1517   bytes constant patchData4 = hex"207d0a8d0020207d0a8d042060";
1518 
1519   // patch data 5
1520   uint constant PATCHDATA5LENGTH    = 6;
1521   uint constant PATCHDATA5POSITION1 = 0x2f3;
1522   uint constant PATCHDATA5POSITION2 = 0x33a;
1523   bytes constant patchData5 = hex"ee21d0ee20d0";
1524 
1525   // TokenData has the values specific to each token
1526   struct TokenData {
1527     uint64 params;
1528 
1529     uint8 modes;
1530     uint8 defaultMode;
1531 
1532     bool patchUnlocked;
1533 
1534     uint256 lastTransfer;
1535   }
1536 
1537   // mapping of tokenIds to the token's data
1538   mapping(uint256 => TokenData) tokenData;
1539 
1540   // the number of tokens minted
1541   uint256 _tokenIdCounter;
1542 
1543   IOraandURI public tokenURIContract;
1544 
1545   constructor() ERC721(tokenName, tokenSymbol) {
1546   }
1547 
1548 
1549   // ----------------------------- mint ----------------------------- //
1550 
1551   function mintToken()
1552     public
1553     payable
1554     returns (uint256)
1555   {
1556     require (_tokenIdCounter < MAX_NUMBER_TOKENS, "Mint over");
1557 
1558     require (balanceOf(msg.sender) < 16, "Limit 16");
1559     require (msg.value >= mintPrice, "Mint price");
1560 
1561     uint256 tokenId = _tokenIdCounter;
1562 
1563     unchecked {
1564       _tokenIdCounter = _tokenIdCounter + 1;
1565     }
1566 
1567     _safeMint(msg.sender, tokenId);
1568 
1569     tokenData[tokenId].params = uint64(bytes8(keccak256(abi.encodePacked(block.timestamp, msg.sender, tokenId.toString()))));
1570 
1571     tokenData[tokenId].lastTransfer = block.timestamp;
1572 
1573     return tokenId;
1574   }
1575 
1576   // ---------------------- token information ----------------------- //
1577 
1578   function tokenURI(uint256 tokenId) 
1579     override 
1580     public 
1581     view 
1582     returns (string memory) 
1583   {
1584     checkTokenId(tokenId);
1585 
1586     if (address(tokenURIContract) != address(0)) {
1587       return tokenURIContract.tokenURI(IOraandPRGToken(this), tokenId);
1588     }    
1589 
1590     string memory tokenIdString = Strings.toString(tokenId);
1591 
1592     string memory json = base64Encode(bytes(string(abi.encodePacked(
1593       '{"name":"oraand ', tokenIdString,
1594       '","description":"', description, '",',
1595       getTokenURIs(tokenIdString),
1596       ',"attributes":', getTokenAttributes(tokenId),
1597       ',"prg":"data:application/x-c64-program;base64,', getTokenPRGBase64(tokenId, false), 
1598       '"}'
1599     ))));
1600 
1601     return string(abi.encodePacked('data:application/json;base64,', json));
1602   }
1603 
1604 
1605   function getTokenURIs(string memory tokenIdString) 
1606     internal
1607     view 
1608     returns (string memory) 
1609   {
1610     string memory uriString = string(abi.encodePacked(
1611       '"image":"', imageBaseURI, tokenIdString,
1612       '.png","animation_url":"', animationBaseURI, tokenIdString,
1613       '","external_url":"', externalBaseURI, tokenIdString, '"'
1614     ));
1615 
1616     return uriString;
1617   }
1618 
1619   function getTokenAttributes(uint256 tokenId) 
1620     override(IOraandPRGToken)
1621     public
1622     view 
1623     returns (string memory) 
1624   {
1625     checkTokenId(tokenId);
1626 
1627     uint8 param = uint8((tokenData[tokenId].params >> 8) & 0x1f);
1628 
1629     string memory patch = "No";
1630     if(tokenData[tokenId].patchUnlocked) {
1631       patch = "Yes";
1632     }
1633 
1634     return string(
1635       abi.encodePacked('[{"trait_type":"Type","value":"', 
1636         Strings.toString(tokenData[tokenId].params & 7 ) ,'"},{"trait_type":"FG","value":"', 
1637         Strings.toString(uint8(prgData7[param])) ,'"},{"trait_type":"BG","value":"', 
1638         Strings.toString(uint8(prgData8[param])) ,'"}, {"trait_type":"Charset","value":"', 
1639         Strings.toString((tokenData[tokenId].params >> 32) & 0x1f) ,'"},{"trait_type":"Modes","value":"', 
1640         Strings.toString(tokenData[tokenId].modes),     
1641         '"}, {"trait_type":"Patch","value":"',patch,
1642         '"}]'
1643     ));
1644   }
1645 
1646   function getTokenSecondsSinceLastTransfer(uint256 tokenId)
1647     external
1648     view
1649     returns (uint256)
1650   {
1651     checkTokenId(tokenId);
1652 
1653     return block.timestamp - tokenData[tokenId].lastTransfer;
1654   }
1655 
1656   function getTokenParams(uint256 tokenId) 
1657     override(IOraandPRGToken)
1658     external
1659     view
1660     returns (uint64) 
1661   {
1662     checkTokenId(tokenId);
1663     
1664     return tokenData[tokenId].params;
1665   }
1666 
1667   function getTokenModes(uint256 tokenId) 
1668     override(IOraandPRGToken)
1669     external 
1670     view
1671     returns (uint8) 
1672   {
1673     checkTokenId(tokenId);
1674     
1675     return tokenData[tokenId].modes;
1676   }
1677 
1678   function getTokenPatchUnlocked(uint256 tokenId) 
1679     override(IOraandPRGToken)
1680     external
1681     view
1682     returns (bool)
1683   {
1684     checkTokenId(tokenId);
1685     
1686     return tokenData[tokenId].patchUnlocked;
1687   }
1688 
1689   function getTokenPRGBase64(uint256 tokenId, bool patchedVersion) 
1690     override(IOraandPRGToken)
1691     public
1692     view
1693     returns (string memory)
1694   {
1695     checkTokenId(tokenId);
1696 
1697     if (patchedVersion) {
1698       return getTokenPatchedPRGBase64(tokenId, true, 0, 0);
1699     } else {
1700       return getTokenPRGBase64(tokenId, true, 0, 0);
1701     }
1702   }
1703 
1704   function getTokenPRGBase64(uint256 tokenId, bool pal, uint8 filterResonanceRouting, uint8 filterModeVolume)
1705     public
1706     view
1707     returns (string memory)
1708   {
1709     return base64Encode(getTokenPRG(tokenId, pal, filterResonanceRouting, filterModeVolume));
1710   }
1711 
1712   function getTokenPRG(uint256 tokenId, bool pal, uint8 filterResonanceRouting, uint8 filterModeVolume)
1713     override(IOraandPRGToken)
1714     public
1715     view
1716     returns (bytes memory)
1717   {
1718     checkTokenId(tokenId);
1719 
1720     bytes memory tokenPRG = basePRGData;
1721 
1722     unchecked {
1723 
1724       uint i;
1725       uint offset = 0;
1726 
1727       uint param = uint(tokenData[tokenId].params & 0x7);
1728 
1729       if (param > 0 && param < 4) {
1730         offset = uint((param - 1) * 56);
1731         for (i = 0; i < PRGDATA1SEGMENTLENGTH; i++) {
1732           tokenPRG[PRGDATA1POSITION + i] = prgData1[i + offset];
1733         }
1734       } else if (param > 3) {
1735         offset = uint((param - 4) * 239);
1736 
1737         for (i = 0; i < PRGDATA2SEGMENTLENGTH; i++) {
1738           tokenPRG[PRGDATA2POSITION + i] = prgData2[i + offset];
1739         }
1740       } 
1741 
1742       if (param > 3) {
1743         for (i = 0; i < PRGDATA3LENGTH; i++) {
1744           tokenPRG[PRGDATA3POSITION + i] = prgData3[i];
1745         }
1746         tokenPRG[0xa5] = bytes1(0x10);
1747         tokenPRG[0xa6] = bytes1(0x0f);
1748       } else {
1749 
1750         if ((tokenData[tokenId].params >> 3) & 0x1 > 0) {
1751           tokenPRG[0x651] = hex"0a";
1752         }
1753       }
1754 
1755       if (filterResonanceRouting != 0) {
1756         tokenPRG[FILTERRESONANCEROUTINGPOSITION] = bytes1(filterResonanceRouting);
1757       }
1758 
1759       if (filterModeVolume != 0) {
1760         tokenPRG[FILTERMODEVOLUMEPOSITION] = bytes1(filterModeVolume); 
1761       }
1762 
1763       offset = uint((tokenData[tokenId].params >> 16) & 0x7) * 24;
1764 
1765       uint noteOffset = uint((tokenData[tokenId].params >> 24) & 0xf);
1766 
1767       if (!pal) {
1768         noteOffset += 84;
1769 
1770         for (i = 0; i < PRGDATA15LENGTH; i++) {
1771           tokenPRG[PRGDATA15POSITION + i] = prgData15[i];
1772           tokenPRG[PRGDATA16POSITION + i] = prgData16[i];
1773         }
1774 
1775         if (param < 4) {
1776           for (i = 0; i < 4; i++) {
1777             tokenPRG[PRGDATA17POSITION + i] = prgData17[i];
1778           }
1779 
1780           if ((tokenData[tokenId].params >> 3) & 0x1 > 0) {
1781             tokenPRG[0x651] = hex"0c";
1782           } else {
1783             tokenPRG[0x651] = hex"18";
1784           }
1785 
1786           tokenPRG[0x696] = hex"04";
1787           tokenPRG[0x57f] = hex"5f";
1788           tokenPRG[0x6ae] = hex"30";
1789           tokenPRG[0x75d] = hex"30";
1790           tokenPRG[0x763] = hex"90";
1791         }
1792       }
1793 
1794 
1795       for (i = 0; i < PRGDATA5SEGMENTLENGTH; i++) {
1796         param = uint(uint8(prgData14[i + offset])) + noteOffset;
1797         tokenPRG[PRGDATA5POSITION + i] = prgData5[param];
1798         tokenPRG[PRGDATA6POSITION + i] = prgData6[param];
1799       }
1800 
1801       param = uint((tokenData[tokenId].params >> 8) & 0x1f);
1802 
1803       tokenPRG[PRGDATA8POSITION] = prgData8[param];
1804       tokenPRG[PRGDATA7POSITION] = prgData7[param];
1805 
1806       offset = uint((tokenData[tokenId].params >> 32) & 0x1f) * 56;
1807 
1808       if (offset < 1736) {
1809         for (i = 0; i < PRGDATA13SEGMENTLENGTH; i++) {
1810           tokenPRG[PRGDATA13POSITION + i] = prgData13[offset + i];
1811         }
1812       }
1813 
1814       param = uint((tokenData[tokenId].params >> 40) & 0xff);
1815       tokenPRG[0xca7 - 0x7ff] = bytes1(uint8(param));
1816 
1817       param = uint((tokenData[tokenId].params >> 48) & 0xf );
1818       tokenPRG[PRGDATA9POSITION] = prgData9[param];
1819 
1820       param = uint(((tokenData[tokenId].params >> 56) & 0x7) * 3);
1821       for (i = 0; i < PRGDATA10SEGMENTLENGTH; i++) {
1822         tokenPRG[PRGDATA10POSITION + i] = prgData10[i + param];
1823       }
1824 
1825       param = uint(((tokenData[tokenId].params >> 59) & 0x3) * 4);
1826       for (i = 0; i < PRGDATA11SEGMENTLENGTH; i++) {
1827         tokenPRG[PRGDATA11POSITION + i] = prgData11[i + param];
1828       }
1829 
1830       param = uint(((tokenData[tokenId].params >> 61) & 0x1) * 4);
1831       for (i = 0; i < PRGDATA12SEGMENTLENGTH; i++) {
1832         tokenPRG[PRGDATA12POSITION + i] = prgData12[i + param];
1833       }
1834 
1835       tokenPRG[0x1c6] = bytes1(tokenData[tokenId].modes + 1);
1836 
1837       if (tokenData[tokenId].defaultMode != 0) {
1838         tokenPRG[0x10e] = bytes1(tokenData[tokenId].defaultMode);
1839       }
1840     }
1841 
1842     return tokenPRG;
1843   }
1844 
1845   // Returns the patched PRG as base64 encoded data, requires patch to be unlocked
1846   function getTokenPatchedPRGBase64(uint256 tokenId, bool pal, uint8 filterResonanceRouting, uint8 filterModeVolume)
1847     public
1848     view
1849     returns (string memory)
1850   {
1851     return base64Encode(getTokenPatchedPRG(tokenId, pal, filterResonanceRouting, filterModeVolume));
1852   }
1853 
1854   // Returns the patched PRG as bytes, requires patch to be unlocked
1855   function getTokenPatchedPRG(uint256 tokenId, bool pal, uint8 filterResonanceRouting, uint8 filterModeVolume)
1856     override(IOraandPRGToken)
1857     public
1858     view
1859     returns (bytes memory)
1860   {
1861     checkTokenId( tokenId );
1862 
1863     require (tokenData[tokenId].patchUnlocked, "Locked");
1864     
1865     bytes memory tokenPRG = getTokenPRG(tokenId, pal, filterResonanceRouting, filterModeVolume);
1866 
1867     uint256 i = 0;
1868 
1869     unchecked {
1870       // apply patches
1871 
1872       for (i = 0; i < PRGDATA4LENGTH; i++) {
1873         tokenPRG[PRGDATA4POSITION + i] = prgData4[i];
1874       }
1875 
1876       if (uint8((tokenData[tokenId].params >> 1) & 3) == 3) {
1877         tokenPRG[0x6ce] = hex"0f";
1878       }
1879 
1880       if (!pal) {
1881         tokenPRG[0x6ce] = hex"0c";
1882         tokenPRG[0x66d] = hex"0a";
1883         tokenPRG[0x675] = hex"08";
1884         tokenPRG[0x676] = hex"0c";
1885         tokenPRG[0x677] = hex"0a";
1886       }
1887 
1888       uint param = uint((tokenData[tokenId].params >> 2) & 7);
1889 
1890       if (param > 3) {
1891         tokenPRG[0x35e] = 0xee;
1892         tokenPRG[0x360] = 0xd0;
1893 
1894         if (param == 4) {
1895           tokenPRG[0x54d] = 0xd0;  
1896 
1897           param = uint((tokenData[tokenId].params >> 7) & 0x2);     
1898 
1899           tokenPRG[0x35f] = bytes1(0x16 + uint8(param));
1900         } else if (param == 5) {
1901           tokenPRG[0x35f] = 0x21;
1902         } else if (param == 6) {
1903           tokenPRG[0x360] = 0x20;
1904           tokenPRG[0x35f] = 0x00;
1905         } else {
1906           tokenPRG[0x35f] = 0x16;
1907         }
1908       } else if (param == 3) {
1909         tokenPRG[0x330] = 0xa5;
1910         tokenPRG[0x331] = 0x70; // or other sid shado
1911       } else if (param == 2) {
1912         tokenPRG[0x347] = bytes1(uint8(tokenData[tokenId].params & 0xff));
1913       } else if(param == 1) {
1914         if (uint((tokenData[tokenId].params) >> 6 & 1) == 0) {
1915           for (i = 0; i < PATCHDATA5LENGTH; i++) {
1916             tokenPRG[PATCHDATA5POSITION1 + i] = patchData5[i];
1917           }
1918         } else {
1919           for (i = 0; i < PATCHDATA5LENGTH; i++) {
1920             tokenPRG[PATCHDATA5POSITION2 + i] = patchData5[i];
1921           }
1922         }
1923       } else {
1924         tokenPRG[0x2ff] = 0xa4;
1925         tokenPRG[0x300] = 0x81;
1926       }
1927 
1928       if (((tokenData[tokenId].params >> 8) & 0xff) > 190) {
1929         tokenPRG[0x55]   = 0x8a;
1930         tokenPRG[0x56] = 0xea;
1931       }
1932 
1933       if (((tokenData[tokenId].params >> 14) & 0xff) > 60) {
1934         for (i = 0; i < PATCHDATA1LENGTH; i++) {
1935           tokenPRG[PATCHDATA1POSITION + i] = patchData1[i];
1936         } 
1937 
1938         for(i = 0; i < PATCHDATA2LENGTH; i++) {
1939           tokenPRG[PATCHDATA2POSITION + i] = patchData2[i];
1940         }
1941       } else {
1942         tokenPRG[0x304] = 0xea;
1943         tokenPRG[0x305] = 0xea;
1944       }
1945 
1946       if (((tokenData[tokenId].params >> 22) & 0xff) > 127) {
1947         for(i = 0; i < 8; i++) {
1948           tokenPRG[PATCHDATA3POSITION + i] = patchData3[i];
1949         }
1950       } else {
1951         for(i = 0; i < 13; i++) {
1952           tokenPRG[PATCHDATA4POSITION + i] = patchData4[i];      
1953         }
1954       }
1955     }
1956 
1957     return tokenPRG;
1958   }
1959 
1960   // ------------------------ check criteria ------------------------ //
1961 
1962   // Check tokenId is less than the total number of tokens
1963   function checkTokenId(uint256 tokenId) 
1964     public
1965     view
1966   {
1967     require (tokenId < _tokenIdCounter, "Invalid id");
1968   }
1969 
1970   // Check tokenId is valid and sender is the owner of the token
1971   function checkIsTokenOwner(address sender, uint256 tokenId) 
1972     public
1973     view
1974   {
1975     checkTokenId(tokenId);
1976     require (ERC721.ownerOf(tokenId) == sender, "Not owner");
1977   }
1978 
1979   // Check tokenId is valid and the token has been held for the time requirement
1980   function checkHoldTime(address sender, uint256 tokenId, uint256 timeRequirement) 
1981     public
1982     view
1983   {
1984     checkIsTokenOwner(sender, tokenId);
1985 
1986     string memory message = string(abi.encodePacked("Req time ", timeRequirement.toString()));
1987     require ((block.timestamp - tokenData[tokenId].lastTransfer) >= timeRequirement, message);
1988   }
1989 
1990   // Check if modes can be unlocked 
1991   function checkCanUnlockModes(address sender, uint256 tokenId, uint8 modes)
1992     public
1993     view
1994   {
1995     require (modes < 4, "Invalid");
1996 
1997     uint256[4] memory timeReq = [0, 8 * DAY_SECONDS, 16 * DAY_SECONDS, 32 * DAY_SECONDS];
1998     uint256 timeRequirement = timeReq[modes];
1999     checkHoldTime(sender, tokenId, timeRequirement);
2000   }
2001 
2002   // Check if meet requirements to unlock the patch (held for 64 days)
2003   function checkCanUnlockPatch(address sender, uint256 tokenId)
2004     public
2005     view
2006   {
2007     uint256 timeRequirement = 64 * DAY_SECONDS;
2008     checkHoldTime(sender, tokenId, timeRequirement);
2009   }
2010 
2011 
2012   // ------------------------ token modify  ------------------------- //
2013 
2014   // Set the maximum mode for the token
2015   function unlockModes(uint256 tokenId, uint8 modes)
2016     external
2017   {
2018     checkCanUnlockModes(msg.sender, tokenId, modes);
2019 
2020     tokenData[tokenId].modes = modes;
2021   }
2022 
2023   // Set the default mode for the token
2024   function setDefaultMode(uint256 tokenId, uint8 defaultMode)
2025     external
2026   {
2027     checkIsTokenOwner(msg.sender, tokenId);
2028 
2029     require (defaultMode <= tokenData[tokenId].modes, "Locked");
2030 
2031     tokenData[tokenId].defaultMode = defaultMode;
2032   }
2033 
2034   // Unlock the patch
2035   function unlockPatch(uint256 tokenId)
2036     external
2037   {
2038     checkCanUnlockPatch(msg.sender, tokenId);
2039 
2040     tokenData[tokenId].patchUnlocked = true;
2041   }
2042 
2043   // --------------- ERC721, ERC721Enumerable overrides --------------//
2044 
2045   function supportsInterface(bytes4 interfaceId)
2046     public
2047     view
2048     override(ERC721, ERC721Enumerable)
2049     returns (bool)
2050   {
2051       return super.supportsInterface( interfaceId );
2052   }
2053 
2054   function _beforeTokenTransfer(address from, address to, uint256 tokenId)
2055     internal
2056     override(ERC721, ERC721Enumerable)
2057   {
2058     super._beforeTokenTransfer(from, to, tokenId);
2059 
2060     if (tokenId < _tokenIdCounter) {
2061       tokenData[tokenId].lastTransfer = block.timestamp;
2062     }
2063   }
2064 
2065   // ------------------------ contract owner ------------------------ //
2066 
2067   function setMintPrice(uint256 price)
2068     external
2069     Ownable.onlyOwner
2070   {
2071     mintPrice = price;
2072   }
2073 
2074   function withdraw(uint256 amount)
2075     external
2076     Ownable.onlyOwner
2077   {
2078     require (amount <= address(this).balance, "Amt");
2079 
2080     payable(msg.sender).transfer(amount);
2081   }
2082 
2083   function setImageBaseURI(string memory baseURI) //, string memory extension )
2084     external
2085     Ownable.onlyOwner
2086   {
2087     imageBaseURI = baseURI;
2088   }
2089 
2090   function setAnimationBaseURI(string memory baseURI) //, string memory extension )
2091     external
2092     Ownable.onlyOwner 
2093   {
2094     animationBaseURI = baseURI;
2095   }
2096 
2097   function setExternalBaseURI(string memory baseURI)
2098     external
2099     Ownable.onlyOwner 
2100   {
2101     externalBaseURI = baseURI;
2102   }
2103 
2104   function setDescription(string memory desc)
2105     external
2106     Ownable.onlyOwner 
2107   {
2108     description = desc;
2109   }
2110 
2111   function setTokenURIContract(IOraandURI uriContract)
2112     external
2113     onlyOwner
2114   {
2115     tokenURIContract = uriContract;
2116   }
2117 
2118   // ---------------------------- base64 ---------------------------- //
2119 
2120   // From OpenZeppelin Contracts (last updated v4.7.0) (utils/Base64.sol) - MIT Licence
2121   // @dev Base64 Encoding/Decoding Table
2122   string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
2123 
2124   //@dev Converts a `bytes` to its Bytes64 `string` representation.
2125 
2126   function base64Encode(bytes memory data) internal pure returns (string memory) {
2127 
2128       // Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
2129       // https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
2130       if (data.length == 0) return "";
2131 
2132       // Loads the table into memory
2133       string memory table = _TABLE;
2134 
2135       // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
2136       // and split into 4 numbers of 6 bits.
2137       // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
2138       // - `data.length + 2`  -> Round up
2139       // - `/ 3`              -> Number of 3-bytes chunks
2140       // - `4 *`              -> 4 characters for each chunk
2141       string memory result = new string(4 * ((data.length + 2) / 3));
2142 
2143       /// @solidity memory-safe-assembly
2144       assembly {
2145           // Prepare the lookup table (skip the first "length" byte)
2146           let tablePtr := add(table, 1)
2147 
2148           // Prepare result pointer, jump over length
2149           let resultPtr := add(result, 32)
2150 
2151           // Run over the input, 3 bytes at a time
2152           for {
2153               let dataPtr := data
2154               let endPtr := add(data, mload(data))
2155           } lt(dataPtr, endPtr) {
2156 
2157           } {
2158               // Advance 3 bytes
2159               dataPtr := add(dataPtr, 3)
2160               let input := mload(dataPtr)
2161 
2162               // To write each character, shift the 3 bytes (18 bits) chunk
2163               // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
2164               // and apply logical AND with 0x3F which is the number of
2165               // the previous character in the ASCII table prior to the Base64 Table
2166               // The result is then added to the table to get the character to write,
2167               // and finally write it in the result pointer but with a left shift
2168               // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
2169 
2170               mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
2171               resultPtr := add(resultPtr, 1) // Advance
2172 
2173               mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
2174               resultPtr := add(resultPtr, 1) // Advance
2175 
2176               mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
2177               resultPtr := add(resultPtr, 1) // Advance
2178 
2179               mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
2180               resultPtr := add(resultPtr, 1) // Advance
2181           }
2182 
2183           // When data `bytes` is not exactly 3 bytes long
2184           // it is padded with `=` characters at the end
2185           switch mod(mload(data), 3)
2186           case 1 {
2187               mstore8(sub(resultPtr, 1), 0x3d)
2188               mstore8(sub(resultPtr, 2), 0x3d)
2189           }
2190           case 2 {
2191               mstore8(sub(resultPtr, 1), 0x3d)
2192           }
2193       }
2194       return result;
2195   }
2196 }