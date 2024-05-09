1 // ██████╗░░█████╗░██╗░░░██╗░█████╗░██╗░░░░░███████╗░█████╗░░█████╗░██╗░░░░░░██████╗
2 // ██╔══██╗██╔══██╗╚██╗░██╔╝██╔══██╗██║░░░░░██╔════╝██╔══██╗██╔══██╗██║░░░░░██╔════╝
3 // ██████╔╝██║░░██║░╚████╔╝░███████║██║░░░░░█████╗░░██║░░██║██║░░██║██║░░░░░╚█████╗░
4 // ██╔══██╗██║░░██║░░╚██╔╝░░██╔══██║██║░░░░░██╔══╝░░██║░░██║██║░░██║██║░░░░░░╚═══██╗
5 // ██║░░██║╚█████╔╝░░░██║░░░██║░░██║███████╗██║░░░░░╚█████╔╝╚█████╔╝███████╗██████╔╝
6 // ╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═╝░░░░░░╚════╝░░╚════╝░╚══════╝╚═════╝░
7 // SPDX-License-Identifier: MIT
8 //OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21    function _msgSender() internal view virtual returns(address) {
22       return msg.sender;
23    }
24 
25    function _msgData() internal view virtual returns(bytes calldata) {
26       return msg.data;
27    }
28 }
29 
30 
31 //OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  * By default, the owner account will be the one that deploys the contract.
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44    address private _owner;
45 
46    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48    /**
49     * @dev Initializes the contract setting the deployer as the initial owner.
50    */
51    constructor() {
52       _transferOwnership(_msgSender());
53    }
54 
55    /**
56     * @dev Returns the address of the current owner.
57    */
58    function owner() public view virtual returns (address) {
59       return _owner;
60    }
61 
62    /**
63     * @dev Throws if called by any account other than the owner.
64    */
65    modifier onlyOwner() {
66       require(owner() == _msgSender(), "Not an owner");
67       _;
68    }
69 
70    /**
71     * @dev Leaves the contract without owner. It will not be possible to call
72     * `onlyOwner` functions anymore. Can only be called by the current owner.
73     * NOTE: Renouncing ownership will leave the contract without an owner,
74     * thereby removing any functionality that is only available to the owner.
75    */
76    function renounceOwnership() public virtual onlyOwner {
77       _transferOwnership(address(0));
78    }
79 
80    /**
81     * @dev Transfers ownership of the contract to a new account (`newOwner`).
82     * Can only be called by the current owner.
83    */
84    function transferOwnership(address newOwner) public virtual onlyOwner {
85       require(newOwner != address(0), "Ownable: new owner is the zero address");
86       _transferOwnership(newOwner);
87    }
88 
89    /**
90     * @dev Transfers ownership of the contract to a new account (`newOwner`).
91     * Internal function without access restriction.
92    */
93    function _transferOwnership(address newOwner) internal virtual {
94       address oldOwner = _owner;
95       _owner = newOwner;
96       emit OwnershipTransferred(oldOwner, newOwner);
97    }
98 }
99 
100 
101 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev String operations.
106  */
107 library Strings {
108     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
109     uint8 private constant _ADDRESS_LENGTH = 20;
110 
111     /**
112      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
113      */
114     function toString(uint256 value) internal pure returns (string memory) {
115 
116         if (value == 0) {
117             return "0";
118         }
119         uint256 temp = value;
120         uint256 digits;
121         while (temp != 0) {
122             digits++;
123             temp /= 10;
124         }
125         bytes memory buffer = new bytes(digits);
126         while (value != 0) {
127             digits -= 1;
128             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
129             value /= 10;
130         }
131         return string(buffer);
132     }
133 
134     /**
135      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
136      */
137     function toHexString(uint256 value) internal pure returns (string memory) {
138         if (value == 0) {
139             return "0x00";
140         }
141         uint256 temp = value;
142         uint256 length = 0;
143         while (temp != 0) {
144             length++;
145             temp >>= 8;
146         }
147         return toHexString(value, length);
148     }
149 
150     /**
151      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
152      */
153     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
154         bytes memory buffer = new bytes(2 * length + 2);
155         buffer[0] = "0";
156         buffer[1] = "x";
157         for (uint256 i = 2 * length + 1; i > 1; --i) {
158             buffer[i] = _HEX_SYMBOLS[value & 0xf];
159             value >>= 4;
160         }
161         require(value == 0, "Strings: hex length insufficient");
162         return string(buffer);
163     }
164 
165     /**
166      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
167      */
168     function toHexString(address addr) internal pure returns (string memory) {
169         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
170     }
171 }
172 //  .-. .-.  .--.  ,---.  ,---..-.   .-.                
173 //  | | | | / /\ \ | .-.\ | .-.\\ \_/ )/                
174 //  | `-' |/ /__\ \| |-' )| |-' )\   (_)                
175 //  | .-. ||  __  || |--' | |--'  ) (                   
176 //  | | |)|| |  |)|| |    | |     | |                   
177 //  /(  (_)|_|  (_)/(     /(     /(_|                   
178 // (__)           (__)   (__)   (__)                    
179 //      .---. ,---.   .---.   .---.  ,-. .-..-.   .-.   
180 //     ( .-._)| .-.\ / .-. ) / .-. ) | |/ /  \ \_/ )/   
181 //    (_) \   | |-' )| | |(_)| | |(_)| | /    \   (_)   
182 //    _  \ \  | |--' | | | | | | | | | | \     ) (      
183 //   ( `-'  ) | |    \ `-' / \ `-' / | |) \    | |      
184 //    `----'  /(      )---'   )---'  |((_)-'  /(_|      
185 //           (__)    (_)     (_)     (_)     (__)       
186 //                     ,--,  ,-.      .--.  ,-.         
187 //                   .' .')  | |     / /\ \ |(||\    /| 
188 //                   |  |(_) | |    / /__\ \(_)|(\  / | 
189 //                   \  \    | |    |  __  || |(_)\/  | 
190 //                    \  `-. | `--. | |  |)|| || \  / | 
191 //                     \____\|( __.'|_|  (_)`-'| |\/| | 
192 //                           (_)               '-'  '-' 
193 
194 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
195 pragma solidity ^0.8.1;
196 
197 /**
198  * @dev Collection of functions related to the address type
199  */
200 library Address {
201     /**
202      * @dev Returns true if `account` is a contract.
203      *
204      * [IMPORTANT]
205      * ====
206      * It is unsafe to assume that an address for which this function returns
207      * false is an externally-owned account (EOA) and not a contract.
208      *
209      * Among others, `isContract` will return false for the following
210      * types of addresses:
211      *
212      *  - an externally-owned account
213      *  - a contract in construction
214      *  - an address where a contract will be created
215      *  - an address where a contract lived, but was destroyed
216      * ====
217      *
218      * [IMPORTANT]
219      * ====
220      * You shouldn't rely on `isContract` to protect against flash loan attacks!
221      *
222      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
223      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
224      * constructor.
225      * ====
226      */
227     function isContract(address account) internal view returns (bool) {
228         // This method relies on extcodesize/address.code.length, which returns 0
229         // for contracts in construction, since the code is only stored at the end
230         // of the constructor execution.
231 
232         return account.code.length > 0;
233     }
234 
235     /**
236      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
237      * `recipient`, forwarding all available gas and reverting on errors.
238      *
239      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
240      * of certain opcodes, possibly making contracts go over the 2300 gas limit
241      * imposed by `transfer`, making them unable to receive funds via
242      * `transfer`. {sendValue} removes this limitation.
243      *
244      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
245      *
246      * IMPORTANT: because control is transferred to `recipient`, care must be
247      * taken to not create reentrancy vulnerabilities. Consider using
248      * {ReentrancyGuard} or the
249      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
250      */
251     function sendValue(address payable recipient, uint256 amount) internal {
252         require(address(this).balance >= amount, "Address: insufficient balance");
253 
254         (bool success, ) = recipient.call{value: amount}("");
255         require(success, "Address: unable to send value, recipient may have reverted");
256     }
257 
258     /**
259      * @dev Performs a Solidity function call using a low level `call`. A
260      * plain `call` is an unsafe replacement for a function call: use this
261      * function instead.
262      *
263      * If `target` reverts with a revert reason, it is bubbled up by this
264      * function (like regular Solidity function calls).
265      *
266      * Returns the raw returned data. To convert to the expected return value,
267      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
268      *
269      * Requirements:
270      *
271      * - `target` must be a contract.
272      * - calling `target` with `data` must not revert.
273      *
274      * _Available since v3.1._
275      */
276     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
277         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
282      * `errorMessage` as a fallback revert reason when `target` reverts.
283      *
284      * _Available since v3.1._
285      */
286     function functionCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         return functionCallWithValue(target, data, 0, errorMessage);
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but also transferring `value` wei to `target`.
297      *
298      * Requirements:
299      *
300      * - the calling contract must have an ETH balance of at least `value`.
301      * - the called Solidity function must be `payable`.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(
306         address target,
307         bytes memory data,
308         uint256 value
309     ) internal returns (bytes memory) {
310         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
315      * with `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCallWithValue(
320         address target,
321         bytes memory data,
322         uint256 value,
323         string memory errorMessage
324     ) internal returns (bytes memory) {
325         require(address(this).balance >= value, "Address: insufficient balance for call");
326         (bool success, bytes memory returndata) = target.call{value: value}(data);
327         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but performing a static call.
333      *
334      * _Available since v3.3._
335      */
336     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
337         return functionStaticCall(target, data, "Address: low-level static call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
342      * but performing a static call.
343      *
344      * _Available since v3.3._
345      */
346     function functionStaticCall(
347         address target,
348         bytes memory data,
349         string memory errorMessage
350     ) internal view returns (bytes memory) {
351         (bool success, bytes memory returndata) = target.staticcall(data);
352         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
357      * but performing a delegate call.
358      *
359      * _Available since v3.4._
360      */
361     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
362         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
367      * but performing a delegate call.
368      *
369      * _Available since v3.4._
370      */
371     function functionDelegateCall(
372         address target,
373         bytes memory data,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         (bool success, bytes memory returndata) = target.delegatecall(data);
377         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
382      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
383      *
384      * _Available since v4.8._
385      */
386     function verifyCallResultFromTarget(
387         address target,
388         bool success,
389         bytes memory returndata,
390         string memory errorMessage
391     ) internal view returns (bytes memory) {
392         if (success) {
393             if (returndata.length == 0) {
394                 // only check isContract if the call was successful and the return data is empty
395                 // otherwise we already know that it was a contract
396                 require(isContract(target), "Address: call to non-contract");
397             }
398             return returndata;
399         } else {
400             _revert(returndata, errorMessage);
401         }
402     }
403 
404     /**
405      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
406      * revert reason or using the provided one.
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
418             _revert(returndata, errorMessage);
419         }
420     }
421 
422     function _revert(bytes memory returndata, string memory errorMessage) private pure {
423         // Look for revert reason and bubble it up if present
424         if (returndata.length > 0) {
425             // The easiest way to bubble the revert reason is using memory via assembly
426             /// @solidity memory-safe-assembly
427             assembly {
428                 let returndata_size := mload(returndata)
429                 revert(add(32, returndata), returndata_size)
430             }
431         } else {
432             revert(errorMessage);
433         }
434     }
435 }
436 
437 
438 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @title Counters
443  * @author Matt Condon (@shrugs)
444  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
445  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
446  *
447  * Include with `using Counters for Counters.Counter;`
448  */
449 library Counters {
450     struct Counter {
451         // This variable should never be directly accessed by users of the library: interactions must be restricted to
452         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
453         // this feature: see https://github.com/ethereum/solidity/issues/4637
454         uint256 _value; // default: 0
455     }
456 
457     function current(Counter storage counter) internal view returns (uint256) {
458         return counter._value;
459     }
460 
461     function increment(Counter storage counter) internal {
462         unchecked {
463             counter._value += 1;
464         }
465     }
466 
467     function decrement(Counter storage counter) internal {
468         uint256 value = counter._value;
469         require(value > 0, "Counter: decrement overflow");
470         unchecked {
471             counter._value = value - 1;
472         }
473     }
474 
475     function reset(Counter storage counter) internal {
476         counter._value = 0;
477     }
478 }
479 
480 
481 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
482 pragma solidity ^0.8.0;
483 
484 /**
485  * @dev Interface of the ERC165 standard, as defined in the
486  * https://eips.ethereum.org/EIPS/eip-165[EIP].
487  *
488  * Implementers can declare support of contract interfaces, which can then be
489  * queried by others ({ERC165Checker}).
490  *
491  * For an implementation, see {ERC165}.
492  */
493 interface IERC165 {
494     /**
495      * @dev Returns true if this contract implements the interface defined by
496      * `interfaceId`. See the corresponding
497      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
498      * to learn more about how these ids are created.
499      *
500      * This function call must use less than 30 000 gas.
501      */
502     function supportsInterface(bytes4 interfaceId) external view returns (bool);
503 }
504 
505 
506 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
507 pragma solidity ^0.8.0;
508 
509 /**
510  * @dev Implementation of the {IERC165} interface.
511  *
512  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
513  * for the additional interface id that will be supported. For example:
514  *
515  * ```solidity
516  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
517  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
518  * }
519  * ```
520  *
521  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
522  */
523 abstract contract ERC165 is IERC165 {
524     /**
525      * @dev See {IERC165-supportsInterface}.
526      */
527     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
528         return interfaceId == type(IERC165).interfaceId;
529     }
530 }
531 
532 
533 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
534 pragma solidity ^0.8.0;
535 
536 /**
537  * @dev Required interface of an ERC721 compliant contract.
538  */
539 interface IERC721 {
540    /**
541     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
542     */
543    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
544 
545    /**
546     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
547     */
548    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
549 
550    /**
551     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
552     */
553    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
554 
555    /**
556     * @dev Returns the number of tokens in ``owner``'s account.
557     */
558    function balanceOf(address owner) external view returns (uint256 balance);
559 
560    /**
561     * @dev Returns the owner of the `tokenId` token.
562     *
563     * Requirements:
564     *
565     * - `tokenId` must exist.
566     */
567    function ownerOf(uint256 tokenId) external view returns (address owner);
568 
569    /**
570     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
571     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
572     *
573     * Requirements:
574     *
575     * - `from` cannot be the zero address.
576     * - `to` cannot be the zero address.
577     * - `tokenId` token must exist and be owned by `from`.
578     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
579     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
580     *
581     * Emits a {Transfer} event.
582     */
583    function safeTransferFrom(
584       address from,
585       address to,
586       uint256 tokenId
587    ) external;
588 
589    /**
590     * @dev Transfers `tokenId` token from `from` to `to`.
591     *
592     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
593     *
594     * Requirements:
595     *
596     * - `from` cannot be the zero address.
597     * - `to` cannot be the zero address.
598     * - `tokenId` token must be owned by `from`.
599     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
600     *
601     * Emits a {Transfer} event.
602     */
603    function transferFrom(
604       address from,
605       address to,
606       uint256 tokenId
607    ) external;
608 
609    /**
610     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
611     * The approval is cleared when the token is transferred.
612     *
613     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
614     *
615     * Requirements:
616     *
617     * - The caller must own the token or be an approved operator.
618     * - `tokenId` must exist.
619     *
620     * Emits an {Approval} event.
621     */
622    function approve(address to, uint256 tokenId) external;
623 
624    /**
625     * @dev Returns the account approved for `tokenId` token.
626     *
627     * Requirements:
628     *
629     * - `tokenId` must exist.
630     */
631    function getApproved(uint256 tokenId) external view returns (address operator);
632 
633    /**
634     * @dev Approve or remove `operator` as an operator for the caller.
635     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
636     *
637     * Requirements:
638     *
639     * - The `operator` cannot be the caller.
640     *
641     * Emits an {ApprovalForAll} event.
642     */
643    function setApprovalForAll(address operator, bool _approved) external;
644 
645    /**
646     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
647     *
648     * See {setApprovalForAll}
649     */
650    function isApprovedForAll(address owner, address operator) external view returns (bool);
651 
652    /**
653     * @dev Safely transfers `tokenId` token from `from` to `to`.
654     *
655     * Requirements:
656     *
657     * - `from` cannot be the zero address.
658     * - `to` cannot be the zero address.
659     * - `tokenId` token must exist and be owned by `from`.
660     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
661     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
662     *
663     * Emits a {Transfer} event.
664     */
665    function safeTransferFrom(
666       address from,
667       address to,
668       uint256 tokenId,
669       bytes calldata data
670    ) external;
671 }
672 
673 
674 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
675 pragma solidity ^0.8.0;
676 
677 /**
678  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
679  * @dev See https://eips.ethereum.org/EIPS/eip-721
680  */
681 interface IERC721Metadata is IERC721 {
682     /**
683      * @dev Returns the token collection name.
684      */
685     function name() external view returns (string memory);
686 
687     /**
688      * @dev Returns the token collection symbol.
689      */
690     function symbol() external view returns (string memory);
691 
692     /**
693      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
694      */
695     function tokenURI(uint256 tokenId) external view returns (string memory);
696 }
697 
698 //                     .. ...                                        
699 //                       .....                                        
700 //                      .....
701 //                     ........                                       
702 //                     ...... ///.((###.//////             
703 //               () .  ....***...//(((((##///(((**.       
704 //           ()..,///***.....(/,,//((((#*(((###((((((*/.               
705 //         .((////(((.#(/.(#((###((/(#((##((((###((((///           
706 //        ((/(SKAKUN/(##(( /(.#,,###(/((#((##(((#####(((((.            
707 //       .*(/#####((##,((.#/..  AVERA((##,,//(((#####*####*          
708 //      .((*(ANKH((((#/,(###( *.#####(,,... (*//(#####(((((*         
709 //     .//((#####(,((## (#.#,/((##(DAHLIN/,. ,*/((((###*((((,      
710 //     /*/(/#####(/((###.(##*(//(#METAVERSEM4STER(,. *//((_(((*       
711 //    **.((***.,*&%###/((/((./*.*/&&&%&&&&&*.**/,(#/(####//,/()   
712 //    *,/(/**,/*(KING'S FOOL(*.*,,** ./YA RISUU**//*#(#(((##()         
713 //    */(,(/*,*(,%&&&&&&%,/*/**/(.*%&&&&&&/*/ .##(##(((((//**)         
714 //    .((,#(//**(#*&&&&&%#(((  ##(((#####(/(/ *(####(((((///)
715 //    /#((((##(.*//.//(((#(((/((,##((#(   ##  ((###((/((///*          
716 //    .#(/(((####(/  (((###((##((###       , //(((//.///,/
717 //     ////#(((#####,(  (##, /#/            /(/////**//            
718 //       //,((,((#####.(#  ,           ##  .((//*/*               
719 //          .///*/((###*(((,//##/.     ,#(((((/                   
720 //                  ((((///((//(((((((((/     
721 
722 
723 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
724 pragma solidity ^0.8.0;
725 
726 /**
727  * @title ERC721 token receiver interface
728  * @dev Interface for any contract that wants to support safeTransfers
729  * from ERC721 asset contracts.
730  */
731 interface IERC721Receiver {
732     /**
733      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
734      * by `operator` from `from`, this function is called.
735      *
736      * It must return its Solidity selector to confirm the token transfer.
737      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
738      *
739      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
740      */
741     function onERC721Received(
742         address operator,
743         address from,
744         uint256 tokenId,
745         bytes calldata data
746     ) external returns (bytes4);
747 }
748 
749 
750 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
751 pragma solidity ^0.8.0;
752 
753 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
754     using Address for address;
755     using Strings for uint256;
756 
757     string private _name;
758 
759     string private _symbol;
760 
761     mapping(uint256 => address) private _owners;
762 
763     mapping(address => uint256) private _balances;
764 
765     mapping(uint256 => address) private _tokenApprovals;
766 
767     mapping(address => mapping(address => bool)) private _operatorApprovals;
768 
769     constructor(string memory name_, string memory symbol_) {
770         _name = name_;
771         _symbol = symbol_;
772     }
773 
774     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165) returns (bool) {
775         return
776             interfaceId == type(IERC721).interfaceId ||
777             interfaceId == type(IERC721Metadata).interfaceId ||
778             super.supportsInterface(interfaceId);
779     }
780 
781     function balanceOf(address owner) public view virtual override returns (uint256) {
782         require(owner != address(0), "ERC721: address zero is not a valid owner");
783         return _balances[owner];
784     }
785 
786     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
787         address owner = _ownerOf(tokenId);
788         require(owner != address(0), "ERC721: invalid token ID");
789         return owner;
790     }
791 
792     function name() public view virtual override returns (string memory) {
793         return _name;
794     }
795 
796     function symbol() public view virtual override returns (string memory) {
797         return _symbol;
798     }
799 
800     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
801         _requireMinted(tokenId);
802 
803         string memory baseURI = _baseURI();
804         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
805     }
806 
807     function _baseURI() internal view virtual returns (string memory) {
808         return "";
809     }
810 
811     function approve(address to, uint256 tokenId) public virtual override {
812         address owner = ERC721.ownerOf(tokenId);
813         require(to != owner, "ERC721: approval to current owner");
814 
815         require(
816             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
817             "ERC721: approve caller is not token owner or approved for all"
818         );
819 
820         _approve(to, tokenId);
821     }
822 
823     function getApproved(uint256 tokenId) public view virtual override returns (address) {
824         _requireMinted(tokenId);
825 
826         return _tokenApprovals[tokenId];
827     }
828 
829     function setApprovalForAll(address operator, bool approved) public virtual override {
830         _setApprovalForAll(_msgSender(), operator, approved);
831     }
832 
833     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
834         return _operatorApprovals[owner][operator];
835     }
836 
837     function transferFrom(
838         address from,
839         address to,
840         uint256 tokenId
841     ) public virtual override {
842         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
843 
844         _transfer(from, to, tokenId);
845     }
846 
847     function safeTransferFrom(
848         address from,
849         address to,
850         uint256 tokenId
851     ) public virtual override {
852         safeTransferFrom(from, to, tokenId, "");
853     }
854 
855     function safeTransferFrom(
856         address from,
857         address to,
858         uint256 tokenId,
859         bytes memory data
860     ) public virtual override {
861         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
862         _safeTransfer(from, to, tokenId, data);
863     }
864 
865     function _safeTransfer(
866         address from,
867         address to,
868         uint256 tokenId,
869         bytes memory data
870     ) internal virtual {
871         _transfer(from, to, tokenId);
872         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
873     }
874 
875     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
876         return _owners[tokenId];
877     }
878 
879     function _exists(uint256 tokenId) internal view virtual returns (bool) {
880         return _ownerOf(tokenId) != address(0);
881     }
882 
883     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
884         address owner = ERC721.ownerOf(tokenId);
885         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
886     }
887 
888     function _safeMint(address to, uint256 tokenId) internal virtual {
889         _safeMint(to, tokenId, "");
890     }
891 
892     function _safeMint(
893         address to,
894         uint256 tokenId,
895         bytes memory data
896     ) internal virtual {
897         _mint(to, tokenId);
898         require(
899             _checkOnERC721Received(address(0), to, tokenId, data),
900             "ERC721: transfer to non ERC721Receiver implementer"
901         );
902     }
903 
904     function _mint(address to, uint256 tokenId) internal virtual {
905         require(to != address(0), "ERC721: mint to the zero address");
906         require(!_exists(tokenId), "ERC721: token already minted");
907 
908         _beforeTokenTransfer(address(0), to, tokenId);
909 
910         require(!_exists(tokenId), "ERC721: token already minted");
911 
912         unchecked {
913             _balances[to] += 1;
914         }
915 
916         _owners[tokenId] = to;
917 
918         emit Transfer(address(0), to, tokenId);
919 
920         _afterTokenTransfer(address(0), to, tokenId);
921     }
922 
923     function _burn(uint256 tokenId) internal virtual {
924         address owner = ERC721.ownerOf(tokenId);
925 
926         _beforeTokenTransfer(owner, address(0), tokenId);
927 
928         owner = ERC721.ownerOf(tokenId);
929 
930         delete _tokenApprovals[tokenId];
931 
932         unchecked {
933             _balances[owner] -= 1;
934         }
935         delete _owners[tokenId];
936 
937         emit Transfer(owner, address(0), tokenId);
938 
939         _afterTokenTransfer(owner, address(0), tokenId);
940     }
941 
942     function _transfer(
943         address from,
944         address to,
945         uint256 tokenId
946     ) internal virtual {
947         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
948         require(to != address(0), "ERC721: transfer to the zero address");
949 
950         _beforeTokenTransfer(from, to, tokenId);
951 
952         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
953 
954         delete _tokenApprovals[tokenId];
955 
956         unchecked {
957             _balances[from] -= 1;
958             _balances[to] += 1;
959         }
960         _owners[tokenId] = to;
961 
962         emit Transfer(from, to, tokenId);
963 
964         _afterTokenTransfer(from, to, tokenId);
965     }
966 
967     function _approve(address to, uint256 tokenId) internal virtual {
968         _tokenApprovals[tokenId] = to;
969         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
970     }
971 
972     function _setApprovalForAll(
973         address owner,
974         address operator,
975         bool approved
976     ) internal virtual {
977         require(owner != operator, "ERC721: approve to caller");
978         _operatorApprovals[owner][operator] = approved;
979         emit ApprovalForAll(owner, operator, approved);
980     }
981 
982     function _requireMinted(uint256 tokenId) internal view virtual {
983         require(_exists(tokenId), "ERC721: invalid token ID");
984     }
985 
986     function _checkOnERC721Received(
987         address from,
988         address to,
989         uint256 tokenId,
990         bytes memory data
991     ) private returns (bool) {
992         if (to.isContract()) {
993             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
994                 return retval == IERC721Receiver.onERC721Received.selector;
995             } catch (bytes memory reason) {
996                 if (reason.length == 0) {
997                     revert("ERC721: transfer to non ERC721Receiver implementer");
998                 } else {
999                     assembly {
1000                         revert(add(32, reason), mload(reason))
1001                     }
1002                 }
1003             }
1004         } else {
1005             return true;
1006         }
1007     }
1008 
1009     function _beforeTokenTransfer(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) internal virtual {}
1014 
1015     function _afterTokenTransfer(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) internal virtual {}
1020 
1021     function _beforeConsecutiveTokenTransfer(
1022         address from,
1023         address to,
1024         uint256,
1025         uint96 size
1026     ) internal virtual {
1027         if (from != address(0)) {
1028             _balances[from] -= size;
1029         }
1030         if (to != address(0)) {
1031             _balances[to] += size;
1032         }
1033     }
1034 
1035     function _afterConsecutiveTokenTransfer(
1036         address,
1037         address,
1038         uint256,
1039         uint96
1040     ) internal virtual {}
1041 }
1042 
1043 
1044 interface IRoyalFools {
1045     function balanceOf(address owner) external view returns (uint256);
1046 }
1047 
1048 // ██░ ██  ▄▄▄      ██▓     ██▓     ▒███████  █     █░▓█████ ▓█████  ███▄    █
1049 // ██░ ██ ▒████▄    ▓██▒    ▓██▒    ▒██▒  ██ ▓█░ █ ░█░▓█   ▀ ▓█   ▀  ██ ▀█   █
1050 // ██▀▀██ ▒██  ▀█▄  ▒██░    ▒██░    ▒██░  ██ ▒█░ █ ░█ ▒███   ▒███   ▓██  ▀█ ██
1051 // ▓█ ░██ ░██▄▄▄▄██ ▒██░    ▒██░    ▒██   ██ ░█░ █ ░█ ▒▓█  ▄ ▒▓█  ▄ ▓██▒  ▐▌██
1052 // ▓█ ░██ ▒▓█   ▓██▒░██████▒░██████▒░ ████▓▒ ░░██▒██▓ ░▒████▒░▒████▒▒██░   ▓██
1053 // ▒  ░▒ ▒ ▒   ▓▒█ ░ ▒░▓  ░░ ▒░▓  ░░ ▒░▒░▒░ ░ ▓░▒ ▒  ░░ ▒░ ░░░ ▒░ ░░ ▒░   ▒ ▒ 
1054 // ▒  ▒░ ░  ▒   ▒▒ ░░ ░ ▒  ░░ ░ ▒  ░  ░ ▒ ▒░  ▒ ░ ░  ░ ░  ░ ░ ░  ░░ ░░   ░ ▒░
1055 // ░  ░░ ░  ░   ▒     ░ ░    ░ ░   ░ ░ ░ ▒    ░   ░    ░    ░     ░   ░ ░ 
1056 // ░  ░  ░    ░  ░   ░  ░    ░  ░    ░ ░      ░       ░  ░   ░  ░         ░ 
1057 
1058 
1059 pragma solidity ^0.8.17;
1060 
1061 contract RoyalFoolsHalloween is ERC721, Ownable {
1062    using Counters for Counters.Counter;
1063    using Strings for uint256;
1064 
1065    Counters.Counter private supply;
1066 
1067    string public baseTokenURI;
1068    string public baseExtension;
1069    uint256 public maxElements;
1070 
1071    IRoyalFools private token;
1072 
1073    bool public isPaused;
1074 
1075    mapping(address => uint256) avaliableClaims;
1076    mapping(address => bool) isClaimer;
1077 
1078    error Soldout();
1079    error EmptyBalance();
1080    error AlreadyClaimed();
1081    error ContractIsPaused();
1082 
1083    constructor(
1084        string memory baseURI,
1085        string memory _baseExtension,
1086        uint256 _maxElements) ERC721("RoyalFoolsHalloween", "RFH") {
1087 
1088            supply.increment();
1089            setBaseURI(baseURI);
1090 
1091            baseExtension = _baseExtension;
1092            maxElements = _maxElements;
1093            token = IRoyalFools(0xCF3bc939f9B2487092936F21cC0757b2b523B7aA);
1094     }
1095 
1096     modifier claimIsOpen() {
1097         if (isPaused == false) {
1098             revert ContractIsPaused();
1099         }
1100         if (totalSupply() > maxElements) {
1101             revert Soldout();
1102         }
1103         _;
1104     }
1105 
1106     function totalSupply() public view returns (uint256) {
1107         return supply.current();
1108     }
1109 
1110     function claim() public claimIsOpen {
1111         address wallet = _msgSender();
1112         uint256 tokenId = totalSupply();
1113         uint256 balance = token.balanceOf(wallet);
1114 
1115         require(balance > 0, "Empty balance");
1116 
1117         if (!isClaimer[wallet]) {
1118             avaliableClaims[wallet] = balance;
1119             isClaimer[wallet] = true;
1120         }
1121 
1122         require(avaliableClaims[wallet] > 0, "All claimed");
1123 
1124         _safeMint(wallet, tokenId);
1125         supply.increment();
1126         avaliableClaims[wallet] -= 1;
1127     }
1128 
1129     function burn(uint256 tokenId) public {
1130         require(_isApprovedOrOwner(msg.sender, tokenId), "Not approved or owner");
1131         _burn(tokenId);
1132     }
1133 
1134     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1135         require(_exists(tokenId), "URI for nonexistent tokenId");
1136 
1137         string memory baseURI = _baseURI();
1138 
1139         return bytes(baseURI).length > 0
1140         ? string(abi.encodePacked(baseURI, tokenId.toString(), baseExtension))
1141         : "";
1142     }
1143 
1144     function _baseURI() internal view override returns (string memory) {
1145         return baseTokenURI;
1146     }
1147 
1148     function setBaseExtension(string memory _newExtension) public onlyOwner {
1149         baseExtension = _newExtension;
1150     }
1151 
1152     function setBaseURI(string memory baseURI) public onlyOwner {
1153         baseTokenURI = baseURI;
1154     }
1155 
1156     function setMaxElements(uint256 _newAmount) public onlyOwner {
1157         maxElements = _newAmount;
1158     }
1159 
1160     function setPause(bool _newState) public onlyOwner {
1161         isPaused = _newState;
1162     }
1163 
1164     function uncheckedIncrement(uint256 i) internal pure returns (uint256) {
1165         unchecked {
1166             i++;
1167         }
1168         return i;
1169     }
1170 }