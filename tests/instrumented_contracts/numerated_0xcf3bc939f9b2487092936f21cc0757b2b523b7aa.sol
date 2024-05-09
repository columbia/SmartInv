1 /*
2      ##### /##                                 ###
3   ######  / ##                                  ###
4  /#   /  /  ##                                   ##
5 /    /  /   ##                                   ##
6     /  /    /                                    ##
7    ## ##   /       /###   ##   ####      /###    ##
8    ## ##  /       / ###  / ##    ###  / / ###  / ##
9    ## ###/       /   ###/  ##     ###/ /   ###/  ##
10    ## ##  ###   ##    ##   ##      ## ##    ##   ##
11    ## ##    ##  ##    ##   ##      ## ##    ##   ##
12    #  ##    ##  ##    ##   ##      ## ##    ##   ##
13       /     ##  ##    ##   ##      ## ##    ##   ##
14   /##/      ### ##    ##   ##      ## ##    /#   ##
15  /  ####    ##   ######     #########  ####/ ##  ### /
16 /    ##     #     ####        #### ###  ###   ##  ##/
17 #                                   ###
18  ##                          #####   ###
19                            /#######  /#
20                           /      ###/
21 
22                        ##### ##                 ###
23                     ######  /### /               ###
24                    /#   /  /  ##/                 ##
25                   /    /  /    #                  ##
26                       /  /                        ##
27                      ## ##       /###     /###    ##       /###
28                      ## ##      / ###  / / ###  / ##      / #### /
29                      ## ###### /   ###/ /   ###/  ##     ##  ###/
30                      ## ##### ##    ## ##    ##   ##    ####
31                      ## ##    ##    ## ##    ##   ##      ###
32                      #  ##    ##    ## ##    ##   ##        ###
33                         #     ##    ## ##    ##   ##          ###
34                     /####     ##    ## ##    ##   ##     /###  ##
35                    /  #####    ######   ######    ### / / #### /
36                   /    ###      ####     ####      ##/     ###/
37                   #
38                    ##
39 */
40 // SPDX-License-Identifier: MIT
41 pragma solidity ^0.8.0;
42 
43 /**
44  * @dev String operations.
45  */
46 library Strings {
47    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
48    uint8 private constant _ADDRESS_LENGTH = 20;
49 
50    /**
51     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
52     */
53    function toString(uint256 value) internal pure returns (string memory) {
54       if (value == 0) {
55          return "0";
56       }
57       uint256 temp = value;
58       uint256 digits;
59       while (temp != 0) {
60          digits++;
61          temp /= 10;
62       }
63       bytes memory buffer = new bytes(digits);
64       while (value != 0) {
65          digits -= 1;
66          buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
67          value /= 10;
68       }
69       return string(buffer);
70    }
71 
72    /**
73     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
74     */
75    function toHexString(uint256 value) internal pure returns (string memory) {
76       if (value == 0) {
77           return "0x00";
78       }
79       uint256 temp = value;
80       uint256 length = 0;
81       while (temp != 0) {
82          length++;
83          temp >>= 8;
84       }
85       return toHexString(value, length);
86    }
87 
88    /**
89     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
90     */
91    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
92       bytes memory buffer = new bytes(2 * length + 2);
93       buffer[0] = "0";
94       buffer[1] = "x";
95       for (uint256 i = 2 * length + 1; i > 1; --i) {
96          buffer[i] = _HEX_SYMBOLS[value & 0xf];
97          value >>= 4;
98       }
99       require(value == 0, "Strings: hex length insufficient");
100       return string(buffer);
101    }
102 
103    /**
104     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
105     */
106    function toHexString(address addr) internal pure returns (string memory) {
107       return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
108    }
109 }
110 
111 // File: Address.sol
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @dev Collection of functions related to the address type
116  */
117 library Address {
118     /**
119      * @dev Returns true if `account` is a contract.
120      * [IMPORTANT]
121      * ====
122      * It is unsafe to assume that an address for which this function returns
123      * false is an externally-owned account (EOA) and not a contract.
124      * Among others, `isContract` will return false for the following
125      * types of addresses:
126      *  - an externally-owned account
127      *  - a contract in construction
128      *  - an address where a contract will be created
129      *  - an address where a contract lived, but was destroyed
130      * ====
131      */
132     function isContract(address account) internal view returns (bool) {
133         // This method relies on extcodesize, which returns 0 for contracts in
134         // construction, since the code is only stored at the end of the
135         // constructor execution.
136         uint256 size;
137         assembly {
138             size := extcodesize(account)
139         }
140         return size > 0;
141     }
142 
143 /*
144  ████   ████████  █████ █████  ██████████    ██████████ █████ █████   ████████  ████
145 ░░███  ███░░░░███░░███ ░░███  ░███░░░░███   ░███░░░░███░░███ ░░███   ███░░░░███░░███
146  ░███ ░░░    ░███ ░███  ░███ █░░░    ███    ░░░    ███  ░███  ░███ █░░░    ░███ ░███
147  ░███    ██████░  ░███████████      ███           ███   ░███████████   ██████░  ░███
148  ░███   ░░░░░░███ ░░░░░░░███░█     ███           ███    ░░░░░░░███░█  ░░░░░░███ ░███
149  ░███  ███   ░███       ░███░     ███           ███           ░███░  ███   ░███ ░███
150  █████░░████████        █████    ███           ███            █████ ░░████████  █████
151 ░░░░░  ░░░░░░░░        ░░░░░    ░░░           ░░░            ░░░░░   ░░░░░░░░  ░░░░░
152 */
153 
154     /**
155      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
156      * `recipient`, forwarding all available gas and reverting on errors.
157      *
158      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
159      * of certain opcodes, possibly making contracts go over the 2300 gas limit
160      * imposed by `transfer`, making them unable to receive funds via
161      * `transfer`. {sendValue} removes this limitation.
162      *
163      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
164      *
165      * IMPORTANT: because control is transferred to `recipient`, care must be
166      * taken to not create reentrancy vulnerabilities. Consider using
167      * {ReentrancyGuard} or the
168      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
169      */
170     function sendValue(address payable recipient, uint256 amount) internal {
171         require(address(this).balance >= amount, "Address: insufficient balance");
172 
173         (bool success, ) = recipient.call{value: amount}("");
174         require(success, "Address: unable to send value, recipient may have reverted");
175     }
176 
177     /**
178      * @dev Performs a Solidity function call using a low level `call`. A
179      * plain `call` is an unsafe replacement for a function call: use this
180      * function instead.
181      *
182      * If `target` reverts with a revert reason, it is bubbled up by this
183      * function (like regular Solidity function calls).
184      *
185      * Returns the raw returned data. To convert to the expected return value,
186      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
187      *
188      * Requirements:
189      *
190      * - `target` must be a contract.
191      * - calling `target` with `data` must not revert.
192      *
193      * _Available since v3.1._
194      */
195     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
196         return functionCall(target, data, "Address: low-level call failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
201      * `errorMessage` as a fallback revert reason when `target` reverts.
202      *
203      * _Available since v3.1._
204      */
205     function functionCall(
206         address target,
207         bytes memory data,
208         string memory errorMessage
209     ) internal returns (bytes memory) {
210         return functionCallWithValue(target, data, 0, errorMessage);
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
215      * but also transferring `value` wei to `target`.
216      *
217      * Requirements:
218      *
219      * - the calling contract must have an ETH balance of at least `value`.
220      * - the called Solidity function must be `payable`.
221      *
222      * _Available since v3.1._
223      */
224     function functionCallWithValue(
225         address target,
226         bytes memory data,
227         uint256 value
228     ) internal returns (bytes memory) {
229         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
234      * with `errorMessage` as a fallback revert reason when `target` reverts.
235      *
236      * _Available since v3.1._
237      */
238     function functionCallWithValue(
239         address target,
240         bytes memory data,
241         uint256 value,
242         string memory errorMessage
243     ) internal returns (bytes memory) {
244         require(address(this).balance >= value, "Address: insufficient balance for call");
245         require(isContract(target), "Address: call to non-contract");
246 
247         (bool success, bytes memory returndata) = target.call{value: value}(data);
248         return _verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
253      * but performing a static call.
254      *
255      * _Available since v3.3._
256      */
257     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
258         return functionStaticCall(target, data, "Address: low-level static call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
263      * but performing a static call.
264      *
265      * _Available since v3.3._
266      */
267     function functionStaticCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal view returns (bytes memory) {
272         require(isContract(target), "Address: static call to non-contract");
273 
274         (bool success, bytes memory returndata) = target.staticcall(data);
275         return _verifyCallResult(success, returndata, errorMessage);
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
280      * but performing a delegate call.
281      *
282      * _Available since v3.4._
283      */
284     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
285         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
290      * but performing a delegate call.
291      *
292      * _Available since v3.4._
293      */
294     function functionDelegateCall(
295         address target,
296         bytes memory data,
297         string memory errorMessage
298     ) internal returns (bytes memory) {
299         require(isContract(target), "Address: delegate call to non-contract");
300 
301         (bool success, bytes memory returndata) = target.delegatecall(data);
302         return _verifyCallResult(success, returndata, errorMessage);
303     }
304 
305     function _verifyCallResult(
306         bool success,
307         bytes memory returndata,
308         string memory errorMessage
309     ) private pure returns (bytes memory) {
310         if (success) {
311             return returndata;
312         } else {
313             // Look for revert reason and bubble it up if present
314             if (returndata.length > 0) {
315                 // The easiest way to bubble the revert reason is using memory via assembly
316 
317                 assembly {
318                     let returndata_size := mload(returndata)
319                     revert(add(32, returndata), returndata_size)
320                 }
321             } else {
322                 revert(errorMessage);
323             }
324         }
325     }
326 }
327 
328 // File: Context.sol
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @dev Provides information about the current execution context, including the
333  * sender of the transaction and its data. While these are generally available
334  * via msg.sender and msg.data, they should not be accessed in such a direct
335  * manner, since when dealing with meta-transactions the account sending and
336  * paying for execution may not be the actual sender (as far as an application
337  * is concerned).
338  * This contract is only required for intermediate, library-like contracts.
339  */
340 abstract contract Context {
341    function _msgSender() internal view virtual returns(address) {
342       return msg.sender;
343    }
344 
345    function _msgData() internal view virtual returns(bytes calldata) {
346       return msg.data;
347    }
348 }
349 
350 // File: Ownable.sol
351 pragma solidity ^0.8.0;
352 
353 /**
354  * @dev Contract module which provides a basic access control mechanism, where
355  * there is an account (an owner) that can be granted exclusive access to
356  * specific functions.
357  * By default, the owner account will be the one that deploys the contract.
358  * This module is used through inheritance. It will make available the modifier
359  * `onlyOwner`, which can be applied to your functions to restrict their use to
360  * the owner.
361  */
362 abstract contract Ownable is Context {
363    address private _owner;
364 
365    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
366 
367    /**
368     * @dev Initializes the contract setting the deployer as the initial owner.
369     */
370    constructor() {
371       _transferOwnership(_msgSender());
372    }
373 
374    /**
375     * @dev Returns the address of the current owner.
376     */
377    function owner() public view virtual returns (address) {
378       return _owner;
379    }
380 
381    /**
382     * @dev Throws if called by any account other than the owner.
383     */
384    modifier onlyOwner() {
385       require(owner() == _msgSender(), "Not an owner");
386       _;
387    }
388 
389    /**
390     * @dev Leaves the contract without owner. It will not be possible to call
391     * `onlyOwner` functions anymore. Can only be called by the current owner.
392     * NOTE: Renouncing ownership will leave the contract without an owner,
393     * thereby removing any functionality that is only available to the owner.
394     */
395    function renounceOwnership() public virtual onlyOwner {
396       _transferOwnership(address(0));
397    }
398 
399    /**
400     * @dev Transfers ownership of the contract to a new account (`newOwner`).
401     * Can only be called by the current owner.
402     */
403    function transferOwnership(address newOwner) public virtual onlyOwner {
404       require(newOwner != address(0), "Ownable: new owner is the zero address");
405       _transferOwnership(newOwner);
406    }
407 
408    /**
409     * @dev Transfers ownership of the contract to a new account (`newOwner`).
410     * Internal function without access restriction.
411     */
412    function _transferOwnership(address newOwner) internal virtual {
413       address oldOwner = _owner;
414       _owner = newOwner;
415       emit OwnershipTransferred(oldOwner, newOwner);
416    }
417 }
418 
419 // File: IERC721Receiver.sol
420 pragma solidity ^0.8.0;
421 
422 /**
423  * @title ERC721 token receiver interface
424  * @dev Interface for any contract that wants to support safeTransfers
425  * from ERC721 asset contracts.
426  */
427 interface IERC721Receiver {
428     /**
429      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
430      * by `operator` from `from`, this function is called.
431      *
432      * It must return its Solidity selector to confirm the token transfer.
433      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
434      *
435      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
436      */
437     function onERC721Received(
438         address operator,
439         address from,
440         uint256 tokenId,
441         bytes calldata data
442     ) external returns (bytes4);
443 }
444 
445 // File: IERC165.sol
446 pragma solidity ^0.8.0;
447 
448 /**
449  * @dev Interface of the ERC165 standard, as defined in the
450  * https://eips.ethereum.org/EIPS/eip-165[EIP].
451  *
452  * Implementers can declare support of contract interfaces, which can then be
453  * queried by others ({ERC165Checker}).
454  *
455  * For an implementation, see {ERC165}.
456  */
457 interface IERC165 {
458    /**
459      * @dev Returns true if this contract implements the interface defined by
460      * `interfaceId`. See the corresponding
461      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
462      * to learn more about how these ids are created.
463      *
464      * This function call must use less than 30 000 gas.
465      */
466    function supportsInterface(bytes4 interfaceId) external view returns(bool);
467 }
468 
469 // File: ERC165.sol
470 pragma solidity ^0.8.0;
471 
472 /**
473  * @dev Implementation of the {IERC165} interface.
474  *
475  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
476  * for the additional interface id that will be supported. For example:
477  *
478  * ```solidity
479  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
480  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
481  * }
482  * ```
483  *
484  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
485  */
486 abstract contract ERC165 is IERC165 {
487     /**
488      * @dev See {IERC165-supportsInterface}.
489      */
490     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
491         return interfaceId == type(IERC165).interfaceId;
492     }
493 }
494 
495 // File: IERC721.sol
496 pragma solidity ^0.8.0;
497 
498 /**
499  * @dev Required interface of an ERC721 compliant contract.
500  */
501 interface IERC721 is IERC165 {
502     /**
503      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
504      */
505     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
506 
507     /**
508      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
509      */
510     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
511 
512     /**
513      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
514      */
515     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
516 
517     /**
518      * @dev Returns the number of tokens in ``owner``'s account.
519      */
520     function balanceOf(address owner) external view returns (uint256 balance);
521 
522     /**
523      * @dev Returns the owner of the `tokenId` token.
524      *
525      * Requirements:
526      *
527      * - `tokenId` must exist.
528      */
529     function ownerOf(uint256 tokenId) external view returns (address owner);
530 
531     /**
532      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
533      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
534      *
535      * Requirements:
536      *
537      * - `from` cannot be the zero address.
538      * - `to` cannot be the zero address.
539      * - `tokenId` token must exist and be owned by `from`.
540      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
541      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
542      *
543      * Emits a {Transfer} event.
544      */
545     function safeTransferFrom(
546         address from,
547         address to,
548         uint256 tokenId
549     ) external;
550 
551     /**
552      * @dev Transfers `tokenId` token from `from` to `to`.
553      *
554      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must be owned by `from`.
561      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
562      *
563      * Emits a {Transfer} event.
564      */
565     function transferFrom(
566         address from,
567         address to,
568         uint256 tokenId
569     ) external;
570 
571     /**
572      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
573      * The approval is cleared when the token is transferred.
574      *
575      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
576      *
577      * Requirements:
578      *
579      * - The caller must own the token or be an approved operator.
580      * - `tokenId` must exist.
581      *
582      * Emits an {Approval} event.
583      */
584     function approve(address to, uint256 tokenId) external;
585 
586     /**
587      * @dev Returns the account approved for `tokenId` token.
588      *
589      * Requirements:
590      *
591      * - `tokenId` must exist.
592      */
593     function getApproved(uint256 tokenId) external view returns (address operator);
594 
595     /**
596      * @dev Approve or remove `operator` as an operator for the caller.
597      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
598      *
599      * Requirements:
600      *
601      * - The `operator` cannot be the caller.
602      *
603      * Emits an {ApprovalForAll} event.
604      */
605     function setApprovalForAll(address operator, bool _approved) external;
606 
607     /**
608      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
609      *
610      * See {setApprovalForAll}
611      */
612     function isApprovedForAll(address owner, address operator) external view returns (bool);
613 
614     /**
615      * @dev Safely transfers `tokenId` token from `from` to `to`.
616      *
617      * Requirements:
618      *
619      * - `from` cannot be the zero address.
620      * - `to` cannot be the zero address.
621      * - `tokenId` token must exist and be owned by `from`.
622      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
623      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
624      *
625      * Emits a {Transfer} event.
626      */
627     function safeTransferFrom(
628         address from,
629         address to,
630         uint256 tokenId,
631         bytes calldata data
632     ) external;
633 }
634 
635 // File: IERC721Enumerable.sol
636 pragma solidity ^0.8.0;
637 
638 /**
639  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
640  * @dev See https://eips.ethereum.org/EIPS/eip-721
641  */
642 interface IERC721Enumerable is IERC721 {
643     /**
644      * @dev Returns the total amount of tokens stored by the contract.
645      */
646     function totalSupply() external view returns (uint256);
647 
648     /**
649      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
650      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
651      */
652     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
653 
654     /**
655      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
656      * Use along with {totalSupply} to enumerate all tokens.
657      */
658     function tokenByIndex(uint256 index) external view returns (uint256);
659 }
660 
661 // File: IERC721Metadata.sol
662 pragma solidity ^0.8.0;
663 
664 /**
665  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
666  * @dev See https://eips.ethereum.org/EIPS/eip-721
667  */
668 interface IERC721Metadata is IERC721 {
669     /**
670      * @dev Returns the token collection name.
671      */
672     function name() external view returns (string memory);
673 
674     /**
675      * @dev Returns the token collection symbol.
676      */
677     function symbol() external view returns (string memory);
678 
679     /**
680      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
681      */
682     function tokenURI(uint256 tokenId) external view returns (string memory);
683 }
684 
685 // File: Pausable.sol
686 pragma solidity ^0.8.0;
687 
688 /**
689  * @dev Contract module which allows children to implement an emergency stop
690  * mechanism that can be triggered by an authorized account.
691  *
692  * This module is used through inheritance. It will make available the
693  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
694  * the functions of your contract. Note that they will not be pausable by
695  * simply including this module, only once the modifiers are put in place.
696  */
697 abstract contract Pausable is Context {
698     /**
699      * @dev Emitted when the pause is triggered by `account`.
700      */
701     event Paused(address account);
702 
703     /**
704      * @dev Emitted when the pause is lifted by `account`.
705      */
706     event Unpaused(address account);
707 
708     bool private _paused;
709 
710     /**
711      * @dev Initializes the contract in unpaused state.
712      */
713     constructor() {
714         _paused = true;
715     }
716 
717     /**
718      * @dev Modifier to make a function callable only when the contract is not paused.
719      *
720      * Requirements:
721      *
722      * - The contract must not be paused.
723      */
724     modifier whenNotPaused() {
725         _requireNotPaused();
726         _;
727     }
728 
729     /**
730      * @dev Modifier to make a function callable only when the contract is paused.
731      *
732      * Requirements:
733      *
734      * - The contract must be paused.
735      */
736     modifier whenPaused() {
737         _requirePaused();
738         _;
739     }
740 
741     /**
742      * @dev Returns true if the contract is paused, and false otherwise.
743      */
744     function paused() public view virtual returns (bool) {
745         return _paused;
746     }
747 
748     /**
749      * @dev Throws if the contract is paused.
750      */
751     function _requireNotPaused() internal view virtual {
752         require(!paused(), "Pausable: paused");
753     }
754 
755     /**
756      * @dev Throws if the contract is not paused.
757      */
758     function _requirePaused() internal view virtual {
759         require(paused(), "Pausable: not paused");
760     }
761 
762     /**
763      * @dev Triggers stopped state.
764      *
765      * Requirements:
766      *
767      * - The contract must not be paused.
768      */
769     function _pause() internal virtual whenNotPaused {
770         _paused = true;
771         emit Paused(_msgSender());
772     }
773 
774     /**
775      * @dev Returns to normal state.
776      *
777      * Requirements:
778      *
779      * - The contract must be paused.
780      */
781     function _unpause() internal virtual whenPaused {
782         _paused = false;
783         emit Unpaused(_msgSender());
784     }
785 }
786 
787 // File: ERC721A.sol
788 pragma solidity ^0.8.0;
789 
790 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
791     using Address for address;
792     using Strings for uint256;
793 
794     struct TokenOwnership {
795         address addr;
796         uint64 startTimestamp;
797     }
798 
799     struct AddressData {
800         uint128 balance;
801         uint128 numberMinted;
802     }
803 
804     uint256 internal currentIndex = 1;
805 
806     // Token name
807     string private _name;
808 
809     // Token symbol
810     string private _symbol;
811 
812     // Mapping from token ID to ownership details
813     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
814     mapping(uint256 => TokenOwnership) internal _ownerships;
815 
816     // Mapping owner address to address data
817     mapping(address => AddressData) private _addressData;
818 
819     // Mapping from token ID to approved address
820     mapping(uint256 => address) private _tokenApprovals;
821 
822     // Mapping from owner to operator approvals
823     mapping(address => mapping(address => bool)) private _operatorApprovals;
824 
825     constructor(string memory name_, string memory symbol_) {
826         _name = name_;
827         _symbol = symbol_;
828     }
829 
830     /**
831      * @dev See {IERC721Enumerable-totalSupply}.
832      */
833     function totalSupply() public view override returns (uint256) {
834         return currentIndex;
835     }
836 
837     /**
838      * @dev See {IERC721Enumerable-tokenByIndex}.
839      */
840     function tokenByIndex(uint256 index) public view override returns (uint256) {
841         require(index < totalSupply(), 'ERC721A: global index out of bounds');
842         return index;
843     }
844 
845     /**
846      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
847      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
848      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
849      */
850     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
851         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
852         uint256 numMintedSoFar = totalSupply();
853         uint256 tokenIdsIdx;
854         address currOwnershipAddr;
855 
856         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
857         unchecked {
858             for (uint256 i; i < numMintedSoFar; i++) {
859                 TokenOwnership memory ownership = _ownerships[i];
860                 if (ownership.addr != address(0)) {
861                     currOwnershipAddr = ownership.addr;
862                 }
863                 if (currOwnershipAddr == owner) {
864                     if (tokenIdsIdx == index) {
865                         return i;
866                     }
867                     tokenIdsIdx++;
868                 }
869             }
870         }
871 
872         revert('ERC721A: unable to get token of owner by index');
873     }
874 
875     /**
876      * @dev See {IERC165-supportsInterface}.
877      */
878     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
879         return
880             interfaceId == type(IERC721).interfaceId ||
881             interfaceId == type(IERC721Metadata).interfaceId ||
882             interfaceId == type(IERC721Enumerable).interfaceId ||
883             super.supportsInterface(interfaceId);
884     }
885 
886     /**
887      * @dev See {IERC721-balanceOf}.
888      */
889     function balanceOf(address owner) public view override returns (uint256) {
890         require(owner != address(0), 'ERC721A: balance query for the zero address');
891         return uint256(_addressData[owner].balance);
892     }
893 
894     function _numberMinted(address owner) internal view returns (uint256) {
895         require(owner != address(0), 'ERC721A: number minted query for the zero address');
896         return uint256(_addressData[owner].numberMinted);
897     }
898 
899     /**
900      * Gas spent here starts off proportional to the maximum mint batch size.
901      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
902      */
903     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
904         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
905 
906         unchecked {
907             for (uint256 curr = tokenId; curr >= 0; curr--) {
908                 TokenOwnership memory ownership = _ownerships[curr];
909                 if (ownership.addr != address(0)) {
910                     return ownership;
911                 }
912             }
913         }
914 
915         revert('ERC721A: unable to determine the owner of token');
916     }
917 
918     /**
919      * @dev See {IERC721-ownerOf}.
920      */
921     function ownerOf(uint256 tokenId) public view override returns (address) {
922         return ownershipOf(tokenId).addr;
923     }
924 
925     /**
926      * @dev See {IERC721Metadata-name}.
927      */
928     function name() public view virtual override returns (string memory) {
929         return _name;
930     }
931 
932     /**
933      * @dev See {IERC721Metadata-symbol}.
934      */
935     function symbol() public view virtual override returns (string memory) {
936         return _symbol;
937     }
938 
939     /**
940      * @dev See {IERC721Metadata-tokenURI}.
941      */
942     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
943         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
944 
945         string memory baseURI = _baseURI();
946         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
947     }
948 
949     /**
950      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
951      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
952      * by default, can be overriden in child contracts.
953      */
954     function _baseURI() internal view virtual returns (string memory) {
955         return '';
956     }
957 
958     /**
959      * @dev See {IERC721-approve}.
960      */
961     function approve(address to, uint256 tokenId) public override {
962         address owner = ERC721A.ownerOf(tokenId);
963         require(to != owner, 'ERC721A: approval to current owner');
964 
965         require(
966             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
967             'ERC721A: approve caller is not owner nor approved for all'
968         );
969 
970         _approve(to, tokenId, owner);
971     }
972 
973     /**
974      * @dev See {IERC721-getApproved}.
975      */
976     function getApproved(uint256 tokenId) public view override returns (address) {
977         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
978 
979         return _tokenApprovals[tokenId];
980     }
981 
982     /**
983      * @dev See {IERC721-setApprovalForAll}.
984      */
985     function setApprovalForAll(address operator, bool approved) public override {
986         require(operator != _msgSender(), 'ERC721A: approve to caller');
987 
988         _operatorApprovals[_msgSender()][operator] = approved;
989         emit ApprovalForAll(_msgSender(), operator, approved);
990     }
991 
992     /**
993      * @dev See {IERC721-isApprovedForAll}.
994      */
995     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
996         return _operatorApprovals[owner][operator];
997     }
998 
999     /**
1000      * @dev See {IERC721-transferFrom}.
1001      */
1002     function transferFrom(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) public override {
1007         _transfer(from, to, tokenId);
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-safeTransferFrom}.
1012      */
1013     function safeTransferFrom(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) public override {
1018         safeTransferFrom(from, to, tokenId, '');
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-safeTransferFrom}.
1023      */
1024     function safeTransferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId,
1028         bytes memory _data
1029     ) public override {
1030         _transfer(from, to, tokenId);
1031         require(
1032             _checkOnERC721Received(from, to, tokenId, _data),
1033             'ERC721A: transfer to non ERC721Receiver implementer'
1034         );
1035     }
1036 
1037     /**
1038      * @dev Returns whether `tokenId` exists.
1039      *
1040      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1041      *
1042      * Tokens start existing when they are minted (`_mint`),
1043      */
1044     function _exists(uint256 tokenId) internal view returns (bool) {
1045         return tokenId < currentIndex;
1046     }
1047 
1048     function _safeMint(address to, uint256 quantity) internal {
1049         _safeMint(to, quantity, '');
1050     }
1051 
1052     /**
1053      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1054      *
1055      * Requirements:
1056      *
1057      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1058      * - `quantity` must be greater than 0.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _safeMint(
1063         address to,
1064         uint256 quantity,
1065         bytes memory _data
1066     ) internal {
1067         _mint(to, quantity, _data, true);
1068     }
1069 
1070     /**
1071      * @dev Mints `quantity` tokens and transfers them to `to`.
1072      *
1073      * Requirements:
1074      *
1075      * - `to` cannot be the zero address.
1076      * - `quantity` must be greater than 0.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _mint(
1081         address to,
1082         uint256 quantity,
1083         bytes memory _data,
1084         bool safe
1085     ) internal {
1086         uint256 startTokenId = currentIndex;
1087         require(to != address(0), 'ERC721A: mint to the zero address');
1088         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1089 
1090         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1091 
1092         // Overflows are incredibly unrealistic.
1093         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1094         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1095         unchecked {
1096             _addressData[to].balance += uint128(quantity);
1097             _addressData[to].numberMinted += uint128(quantity);
1098 
1099             _ownerships[startTokenId].addr = to;
1100             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1101 
1102             uint256 updatedIndex = startTokenId;
1103 
1104             for (uint256 i; i < quantity; i++) {
1105                 emit Transfer(address(0), to, updatedIndex);
1106                 if (safe) {
1107                     require(
1108                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1109                         'ERC721A: transfer to non ERC721Receiver implementer'
1110                     );
1111                 }
1112 
1113                 updatedIndex++;
1114             }
1115 
1116             currentIndex = updatedIndex;
1117         }
1118 
1119         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1120     }
1121 
1122     /**
1123      * @dev Transfers `tokenId` from `from` to `to`.
1124      *
1125      * Requirements:
1126      *
1127      * - `to` cannot be the zero address.
1128      * - `tokenId` token must be owned by `from`.
1129      *
1130      * Emits a {Transfer} event.
1131      */
1132     function _transfer(
1133         address from,
1134         address to,
1135         uint256 tokenId
1136     ) private {
1137         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1138 
1139         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1140             getApproved(tokenId) == _msgSender() ||
1141             isApprovedForAll(prevOwnership.addr, _msgSender()));
1142 
1143         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1144 
1145         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1146         require(to != address(0), 'ERC721A: transfer to the zero address');
1147 
1148         _beforeTokenTransfers(from, to, tokenId, 1);
1149 
1150         // Clear approvals from the previous owner
1151         _approve(address(0), tokenId, prevOwnership.addr);
1152 
1153         // Underflow of the sender's balance is impossible because we check for
1154         // ownership above and the recipient's balance can't realistically overflow.
1155         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1156         unchecked {
1157             _addressData[from].balance -= 1;
1158             _addressData[to].balance += 1;
1159 
1160             _ownerships[tokenId].addr = to;
1161             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1162 
1163             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1164             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1165             uint256 nextTokenId = tokenId + 1;
1166             if (_ownerships[nextTokenId].addr == address(0)) {
1167                 if (_exists(nextTokenId)) {
1168                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1169                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1170                 }
1171             }
1172         }
1173 
1174         emit Transfer(from, to, tokenId);
1175         _afterTokenTransfers(from, to, tokenId, 1);
1176     }
1177 
1178     /**
1179      * @dev Approve `to` to operate on `tokenId`
1180      *
1181      * Emits a {Approval} event.
1182      */
1183     function _approve(
1184         address to,
1185         uint256 tokenId,
1186         address owner
1187     ) private {
1188         _tokenApprovals[tokenId] = to;
1189         emit Approval(owner, to, tokenId);
1190     }
1191 
1192     /**
1193      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1194      * The call is not executed if the target address is not a contract.
1195      *
1196      * @param from address representing the previous owner of the given token ID
1197      * @param to target address that will receive the tokens
1198      * @param tokenId uint256 ID of the token to be transferred
1199      * @param _data bytes optional data to send along with the call
1200      * @return bool whether the call correctly returned the expected magic value
1201      */
1202     function _checkOnERC721Received(
1203         address from,
1204         address to,
1205         uint256 tokenId,
1206         bytes memory _data
1207     ) private returns (bool) {
1208         if (to.isContract()) {
1209             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1210                 return retval == IERC721Receiver(to).onERC721Received.selector;
1211             } catch (bytes memory reason) {
1212                 if (reason.length == 0) {
1213                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1214                 } else {
1215                     assembly {
1216                         revert(add(32, reason), mload(reason))
1217                     }
1218                 }
1219             }
1220         } else {
1221             return true;
1222         }
1223     }
1224 
1225     /**
1226      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1227      *
1228      * startTokenId - the first token id to be transferred
1229      * quantity - the amount to be transferred
1230      *
1231      * Calling conditions:
1232      *
1233      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1234      * transferred to `to`.
1235      * - When `from` is zero, `tokenId` will be minted for `to`.
1236      */
1237     function _beforeTokenTransfers(
1238         address from,
1239         address to,
1240         uint256 startTokenId,
1241         uint256 quantity
1242     ) internal virtual {}
1243 
1244     /**
1245      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1246      * minting.
1247      *
1248      * startTokenId - the first token id to be transferred
1249      * quantity - the amount to be transferred
1250      *
1251      * Calling conditions:
1252      *
1253      * - when `from` and `to` are both non-zero.
1254      * - `from` and `to` are never both zero.
1255      */
1256     function _afterTokenTransfers(
1257         address from,
1258         address to,
1259         uint256 startTokenId,
1260         uint256 quantity
1261     ) internal virtual {}
1262 }
1263 
1264 
1265 
1266 
1267 /*
1268 ███████████                          █████                                         ███
1269 ░░███░░░░░███                        ░░███                                         ░░░
1270  ░███    ░███   ██████   ██████    ███████  █████████████    ██████   ████████     ████   █████
1271  ░██████████   ███░░███ ░░░░░███  ███░░███ ░░███░░███░░███  ░░░░░███ ░░███░░███   ░░███  ███░░
1272  ░███░░░░░███ ░███ ░███  ███████ ░███ ░███  ░███ ░███ ░███   ███████  ░███ ░███    ░███ ░░█████
1273  ░███    ░███ ░███ ░███ ███░░███ ░███ ░███  ░███ ░███ ░███  ███░░███  ░███ ░███    ░███  ░░░░███
1274  █████   █████░░██████ ░░████████░░████████ █████░███ █████░░████████ ░███████     █████ ██████
1275 ░░░░░   ░░░░░  ░░░░░░   ░░░░░░░░  ░░░░░░░░ ░░░░░ ░░░ ░░░░░  ░░░░░░░░  ░███░░░     ░░░░░ ░░░░░░
1276                                                                       ░███
1277                                                                       █████
1278                                                                      ░░░░░
1279                       █████       █████
1280                      ░░███       ░░███
1281  ████████    ██████  ███████      ░███████    ██████  ████████   ██████
1282 ░░███░░███  ███░░███░░░███░       ░███░░███  ███░░███░░███░░███ ███░░███
1283  ░███ ░███ ░███ ░███  ░███        ░███ ░███ ░███████  ░███ ░░░ ░███████
1284  ░███ ░███ ░███ ░███  ░███ ███    ░███ ░███ ░███░░░   ░███     ░███░░░
1285  ████ █████░░██████   ░░█████     ████ █████░░██████  █████    ░░██████
1286 ░░░░ ░░░░░  ░░░░░░     ░░░░░     ░░░░ ░░░░░  ░░░░░░  ░░░░░      ░░░░░░
1287 */
1288 
1289 pragma solidity ^0.8.17;
1290 
1291 contract RoyalFools is Ownable, ERC721A, Pausable {
1292     string public originFoolsURI;
1293     string constant SECRETPHRASE = "13477431";
1294 
1295     uint256 public constant FOOLSONWALLET = 1;
1296     uint256 public constant TOSSACOIN = 0 ether;
1297 
1298     uint256 public royalCourt = 7431;
1299     uint256 private inPrison = 741;
1300     uint256 internal totalMinted;
1301 
1302     mapping(address => uint256) public howManyFools;
1303 
1304     constructor(
1305         string memory foolURI,
1306         uint256 _royalCourt,
1307         uint256 _inPrison) ERC721A("Royal Fools", "RF") {
1308 
1309             theDungeonMaster(foolURI);
1310             royalCourt = _royalCourt;
1311             inPrison = _inPrison;
1312     }
1313 
1314     modifier fairOnFire {
1315         require(totalSupply() <= royalCourt, "Sale has ended");
1316         _;
1317     }
1318 
1319     modifier wholsTheKingHere() {
1320         require(owner() == msg.sender);
1321         _;
1322     }
1323 
1324     function saleOff() public wholsTheKingHere {
1325         _pause();
1326     }
1327 
1328     function saleOn() public wholsTheKingHere {
1329         _unpause();
1330     }
1331 
1332     function theDungeonMaster(string memory foolURI) public wholsTheKingHere {
1333         originFoolsURI = foolURI;
1334     }
1335 
1336     function setInPrison(uint256 value) public wholsTheKingHere {
1337         inPrison = value;
1338     }
1339 
1340     function setMaxMintSupply(uint256 maxMintSupply) external wholsTheKingHere {
1341         royalCourt = maxMintSupply;
1342     }
1343 
1344     function totalFoolsMinted() public view returns (uint) {
1345         return totalMinted;
1346     }
1347 
1348     function _baseURI() internal view virtual override returns (string memory) {
1349         return originFoolsURI;
1350     }
1351 
1352     function homeBoy() public wholsTheKingHere {
1353         _safeMint(msg.sender, inPrison);
1354     }
1355 
1356     function godsMessage(uint256 _count, address[] calldata addresses) external wholsTheKingHere {
1357         uint256 supply = totalSupply();
1358 
1359         require(supply <= royalCourt, "Total supply spent");
1360         require(supply + _count + inPrison <= royalCourt, "Total supply exceeded");
1361 
1362         for (uint256 i = 0; i < addresses.length; i++) {
1363             require(addresses[i] != address(0), "Can't add a null address");
1364             _safeMint(addresses[i],_count);
1365         }
1366     }
1367 
1368     function mintFool() public payable fairOnFire {
1369         uint256 mintIndex = totalSupply();
1370 
1371         require(mintIndex + FOOLSONWALLET + inPrison <= royalCourt, "Total supply exceeded");
1372         require(howManyFools[msg.sender] < FOOLSONWALLET);
1373         require(msg.value == TOSSACOIN, "Incorrect value");
1374         _safeMint(msg.sender, FOOLSONWALLET);
1375         howManyFools[msg.sender] += FOOLSONWALLET;
1376         totalMinted++;
1377     }
1378 
1379     function _beforeTokenTransfers(
1380         address from,
1381         address to,
1382         uint256 startTokenId,
1383         uint256 quantity
1384     ) internal whenNotPaused override {
1385         super._beforeTokenTransfers(from, to, startTokenId, quantity);
1386     }
1387 
1388     function LhlTaKool() public pure returns(string memory) {
1389         return SECRETPHRASE;
1390     }
1391 }