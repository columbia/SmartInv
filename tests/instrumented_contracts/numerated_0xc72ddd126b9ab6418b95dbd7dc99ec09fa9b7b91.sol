1 // SPDX-License-Identifier: MIT
2 
3 /*
4   _    _       _         _____             _    _ _                 
5  | |  | |     | |       |  __ \           | |  | (_)                
6  | |  | | __ _| |_   _  | |  | |_   _  ___| | _| |_ _ __   __ _ ___ 
7  | |  | |/ _` | | | | | | |  | | | | |/ __| |/ / | | '_ \ / _` / __|
8  | |__| | (_| | | |_| | | |__| | |_| | (__|   <| | | | | | (_| \__ \
9   \____/ \__, |_|\__, | |_____/ \__,_|\___|_|\_\_|_|_| |_|\__, |___/
10           __/ |   __/ |                                    __/ |    
11          |___/   |___/                                    |___/     
12 
13   3333 Ugly Ducklings abandoned on the Ethereum Blockchain. The world deemed them too ugly... what will you do?
14   0.001 mint // 6 per tx // no roadmap, no anything. Pure degen.
15 */
16 
17 
18 // File: @openzeppelin/contracts/utils/Counters.sol
19 
20 
21 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
22 
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @title Counters
28  * @author Matt Condon (@shrugs)
29  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
30  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
31  *
32  * Include with `using Counters for Counters.Counter;`
33  */
34 library Counters {
35     struct Counter {
36         // This variable should never be directly accessed by users of the library: interactions must be restricted to
37         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
38         // this feature: see https://github.com/ethereum/solidity/issues/4637
39         uint256 _value; // default: 0
40     }
41 
42     function current(Counter storage counter) internal view returns (uint256) {
43         return counter._value;
44     }
45 
46     function increment(Counter storage counter) internal {
47         unchecked {
48             counter._value += 1;
49         }
50     }
51 
52     function decrement(Counter storage counter) internal {
53         uint256 value = counter._value;
54         require(value > 0, "Counter: decrement overflow");
55         unchecked {
56             counter._value = value - 1;
57         }
58     }
59 
60     function reset(Counter storage counter) internal {
61         counter._value = 0;
62     }
63 }
64 
65 // File: @openzeppelin/contracts/utils/Strings.sol
66 
67 
68 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev String operations.
74  */
75 library Strings {
76     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
133 }
134 
135 // File: @openzeppelin/contracts/utils/Context.sol
136 
137 
138 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 /**
143  * @dev Provides information about the current execution context, including the
144  * sender of the transaction and its data. While these are generally available
145  * via msg.sender and msg.data, they should not be accessed in such a direct
146  * manner, since when dealing with meta-transactions the account sending and
147  * paying for execution may not be the actual sender (as far as an application
148  * is concerned).
149  *
150  * This contract is only required for intermediate, library-like contracts.
151  */
152 abstract contract Context {
153     function _msgSender() internal view virtual returns (address) {
154         return msg.sender;
155     }
156 
157     function _msgData() internal view virtual returns (bytes calldata) {
158         return msg.data;
159     }
160 }
161 
162 // File: @openzeppelin/contracts/access/Ownable.sol
163 
164 
165 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
166 
167 pragma solidity ^0.8.0;
168 
169 
170 /**
171  * @dev Contract module which provides a basic access control mechanism, where
172  * there is an account (an owner) that can be granted exclusive access to
173  * specific functions.
174  *
175  * By default, the owner account will be the one that deploys the contract. This
176  * can later be changed with {transferOwnership}.
177  *
178  * This module is used through inheritance. It will make available the modifier
179  * `onlyOwner`, which can be applied to your functions to restrict their use to
180  * the owner.
181  */
182 abstract contract Ownable is Context {
183     address private _owner;
184 
185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
186 
187     /**
188      * @dev Initializes the contract setting the deployer as the initial owner.
189      */
190     constructor() {
191         _transferOwnership(_msgSender());
192     }
193 
194     /**
195      * @dev Returns the address of the current owner.
196      */
197     function owner() public view virtual returns (address) {
198         return _owner;
199     }
200 
201     /**
202      * @dev Throws if called by any account other than the owner.
203      */
204     modifier onlyOwner() {
205         require(owner() == _msgSender(), "Ownable: caller is not the owner");
206         _;
207     }
208 
209     /**
210      * @dev Leaves the contract without owner. It will not be possible to call
211      * `onlyOwner` functions anymore. Can only be called by the current owner.
212      *
213      * NOTE: Renouncing ownership will leave the contract without an owner,
214      * thereby removing any functionality that is only available to the owner.
215      */
216     function renounceOwnership() public virtual onlyOwner {
217         _transferOwnership(address(0));
218     }
219 
220     /**
221      * @dev Transfers ownership of the contract to a new account (`newOwner`).
222      * Can only be called by the current owner.
223      */
224     function transferOwnership(address newOwner) public virtual onlyOwner {
225         require(newOwner != address(0), "Ownable: new owner is the zero address");
226         _transferOwnership(newOwner);
227     }
228 
229     /**
230      * @dev Transfers ownership of the contract to a new account (`newOwner`).
231      * Internal function without access restriction.
232      */
233     function _transferOwnership(address newOwner) internal virtual {
234         address oldOwner = _owner;
235         _owner = newOwner;
236         emit OwnershipTransferred(oldOwner, newOwner);
237     }
238 }
239 
240 // File: @openzeppelin/contracts/utils/Address.sol
241 
242 
243 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
244 
245 pragma solidity ^0.8.1;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      *
268      * [IMPORTANT]
269      * ====
270      * You shouldn't rely on `isContract` to protect against flash loan attacks!
271      *
272      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
273      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
274      * constructor.
275      * ====
276      */
277     function isContract(address account) internal view returns (bool) {
278         // This method relies on extcodesize/address.code.length, which returns 0
279         // for contracts in construction, since the code is only stored at the end
280         // of the constructor execution.
281 
282         return account.code.length > 0;
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         (bool success, ) = recipient.call{value: amount}("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain `call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327         return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value
359     ) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
365      * with `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         require(address(this).balance >= value, "Address: insufficient balance for call");
376         require(isContract(target), "Address: call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.call{value: value}(data);
379         return verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but performing a static call.
385      *
386      * _Available since v3.3._
387      */
388     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
389         return functionStaticCall(target, data, "Address: low-level static call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
394      * but performing a static call.
395      *
396      * _Available since v3.3._
397      */
398     function functionStaticCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal view returns (bytes memory) {
403         require(isContract(target), "Address: static call to non-contract");
404 
405         (bool success, bytes memory returndata) = target.staticcall(data);
406         return verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but performing a delegate call.
412      *
413      * _Available since v3.4._
414      */
415     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
416         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
421      * but performing a delegate call.
422      *
423      * _Available since v3.4._
424      */
425     function functionDelegateCall(
426         address target,
427         bytes memory data,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(isContract(target), "Address: delegate call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.delegatecall(data);
433         return verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
438      * revert reason using the provided one.
439      *
440      * _Available since v4.3._
441      */
442     function verifyCallResult(
443         bool success,
444         bytes memory returndata,
445         string memory errorMessage
446     ) internal pure returns (bytes memory) {
447         if (success) {
448             return returndata;
449         } else {
450             // Look for revert reason and bubble it up if present
451             if (returndata.length > 0) {
452                 // The easiest way to bubble the revert reason is using memory via assembly
453 
454                 assembly {
455                     let returndata_size := mload(returndata)
456                     revert(add(32, returndata), returndata_size)
457                 }
458             } else {
459                 revert(errorMessage);
460             }
461         }
462     }
463 }
464 
465 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
466 
467 
468 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
469 
470 pragma solidity ^0.8.0;
471 
472 /**
473  * @title ERC721 token receiver interface
474  * @dev Interface for any contract that wants to support safeTransfers
475  * from ERC721 asset contracts.
476  */
477 interface IERC721Receiver {
478     /**
479      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
480      * by `operator` from `from`, this function is called.
481      *
482      * It must return its Solidity selector to confirm the token transfer.
483      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
484      *
485      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
486      */
487     function onERC721Received(
488         address operator,
489         address from,
490         uint256 tokenId,
491         bytes calldata data
492     ) external returns (bytes4);
493 }
494 
495 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @dev Interface of the ERC165 standard, as defined in the
504  * https://eips.ethereum.org/EIPS/eip-165[EIP].
505  *
506  * Implementers can declare support of contract interfaces, which can then be
507  * queried by others ({ERC165Checker}).
508  *
509  * For an implementation, see {ERC165}.
510  */
511 interface IERC165 {
512     /**
513      * @dev Returns true if this contract implements the interface defined by
514      * `interfaceId`. See the corresponding
515      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
516      * to learn more about how these ids are created.
517      *
518      * This function call must use less than 30 000 gas.
519      */
520     function supportsInterface(bytes4 interfaceId) external view returns (bool);
521 }
522 
523 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
524 
525 
526 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 
531 /**
532  * @dev Implementation of the {IERC165} interface.
533  *
534  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
535  * for the additional interface id that will be supported. For example:
536  *
537  * ```solidity
538  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
539  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
540  * }
541  * ```
542  *
543  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
544  */
545 abstract contract ERC165 is IERC165 {
546     /**
547      * @dev See {IERC165-supportsInterface}.
548      */
549     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
550         return interfaceId == type(IERC165).interfaceId;
551     }
552 }
553 
554 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
555 
556 
557 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 
562 /**
563  * @dev Required interface of an ERC721 compliant contract.
564  */
565 interface IERC721 is IERC165 {
566     /**
567      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
568      */
569     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
570 
571     /**
572      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
573      */
574     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
575 
576     /**
577      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
578      */
579     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
580 
581     /**
582      * @dev Returns the number of tokens in ``owner``'s account.
583      */
584     function balanceOf(address owner) external view returns (uint256 balance);
585 
586     /**
587      * @dev Returns the owner of the `tokenId` token.
588      *
589      * Requirements:
590      *
591      * - `tokenId` must exist.
592      */
593     function ownerOf(uint256 tokenId) external view returns (address owner);
594 
595     /**
596      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
597      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
598      *
599      * Requirements:
600      *
601      * - `from` cannot be the zero address.
602      * - `to` cannot be the zero address.
603      * - `tokenId` token must exist and be owned by `from`.
604      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
605      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
606      *
607      * Emits a {Transfer} event.
608      */
609     function safeTransferFrom(
610         address from,
611         address to,
612         uint256 tokenId
613     ) external;
614 
615     /**
616      * @dev Transfers `tokenId` token from `from` to `to`.
617      *
618      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
619      *
620      * Requirements:
621      *
622      * - `from` cannot be the zero address.
623      * - `to` cannot be the zero address.
624      * - `tokenId` token must be owned by `from`.
625      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
626      *
627      * Emits a {Transfer} event.
628      */
629     function transferFrom(
630         address from,
631         address to,
632         uint256 tokenId
633     ) external;
634 
635     /**
636      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
637      * The approval is cleared when the token is transferred.
638      *
639      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
640      *
641      * Requirements:
642      *
643      * - The caller must own the token or be an approved operator.
644      * - `tokenId` must exist.
645      *
646      * Emits an {Approval} event.
647      */
648     function approve(address to, uint256 tokenId) external;
649 
650     /**
651      * @dev Returns the account approved for `tokenId` token.
652      *
653      * Requirements:
654      *
655      * - `tokenId` must exist.
656      */
657     function getApproved(uint256 tokenId) external view returns (address operator);
658 
659     /**
660      * @dev Approve or remove `operator` as an operator for the caller.
661      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
662      *
663      * Requirements:
664      *
665      * - The `operator` cannot be the caller.
666      *
667      * Emits an {ApprovalForAll} event.
668      */
669     function setApprovalForAll(address operator, bool _approved) external;
670 
671     /**
672      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
673      *
674      * See {setApprovalForAll}
675      */
676     function isApprovedForAll(address owner, address operator) external view returns (bool);
677 
678     /**
679      * @dev Safely transfers `tokenId` token from `from` to `to`.
680      *
681      * Requirements:
682      *
683      * - `from` cannot be the zero address.
684      * - `to` cannot be the zero address.
685      * - `tokenId` token must exist and be owned by `from`.
686      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
687      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
688      *
689      * Emits a {Transfer} event.
690      */
691     function safeTransferFrom(
692         address from,
693         address to,
694         uint256 tokenId,
695         bytes calldata data
696     ) external;
697 }
698 
699 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
700 
701 
702 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 
707 /**
708  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
709  * @dev See https://eips.ethereum.org/EIPS/eip-721
710  */
711 interface IERC721Metadata is IERC721 {
712     /**
713      * @dev Returns the token collection name.
714      */
715     function name() external view returns (string memory);
716 
717     /**
718      * @dev Returns the token collection symbol.
719      */
720     function symbol() external view returns (string memory);
721 
722     /**
723      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
724      */
725     function tokenURI(uint256 tokenId) external view returns (string memory);
726 }
727 
728 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
729 
730 
731 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
732 
733 pragma solidity ^0.8.0;
734 
735 
736 
737 
738 
739 
740 
741 
742 /**
743  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
744  * the Metadata extension, but not including the Enumerable extension, which is available separately as
745  * {ERC721Enumerable}.
746  */
747 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
748     using Address for address;
749     using Strings for uint256;
750 
751     // Token name
752     string private _name;
753 
754     // Token symbol
755     string private _symbol;
756 
757     // Mapping from token ID to owner address
758     mapping(uint256 => address) private _owners;
759 
760     // Mapping owner address to token count
761     mapping(address => uint256) private _balances;
762 
763     // Mapping from token ID to approved address
764     mapping(uint256 => address) private _tokenApprovals;
765 
766     // Mapping from owner to operator approvals
767     mapping(address => mapping(address => bool)) private _operatorApprovals;
768 
769     /**
770      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
771      */
772     constructor(string memory name_, string memory symbol_) {
773         _name = name_;
774         _symbol = symbol_;
775     }
776 
777     /**
778      * @dev See {IERC165-supportsInterface}.
779      */
780     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
781         return
782             interfaceId == type(IERC721).interfaceId ||
783             interfaceId == type(IERC721Metadata).interfaceId ||
784             super.supportsInterface(interfaceId);
785     }
786 
787     /**
788      * @dev See {IERC721-balanceOf}.
789      */
790     function balanceOf(address owner) public view virtual override returns (uint256) {
791         require(owner != address(0), "ERC721: balance query for the zero address");
792         return _balances[owner];
793     }
794 
795     /**
796      * @dev See {IERC721-ownerOf}.
797      */
798     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
799         address owner = _owners[tokenId];
800         require(owner != address(0), "ERC721: owner query for nonexistent token");
801         return owner;
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-name}.
806      */
807     function name() public view virtual override returns (string memory) {
808         return _name;
809     }
810 
811     /**
812      * @dev See {IERC721Metadata-symbol}.
813      */
814     function symbol() public view virtual override returns (string memory) {
815         return _symbol;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-tokenURI}.
820      */
821     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
822         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
823 
824         string memory baseURI = _baseURI();
825         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
826     }
827 
828     /**
829      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
830      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
831      * by default, can be overriden in child contracts.
832      */
833     function _baseURI() internal view virtual returns (string memory) {
834         return "";
835     }
836 
837     /**
838      * @dev See {IERC721-approve}.
839      */
840     function approve(address to, uint256 tokenId) public virtual override {
841         address owner = ERC721.ownerOf(tokenId);
842         require(to != owner, "ERC721: approval to current owner");
843 
844         require(
845             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
846             "ERC721: approve caller is not owner nor approved for all"
847         );
848 
849         _approve(to, tokenId);
850     }
851 
852     /**
853      * @dev See {IERC721-getApproved}.
854      */
855     function getApproved(uint256 tokenId) public view virtual override returns (address) {
856         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
857 
858         return _tokenApprovals[tokenId];
859     }
860 
861     /**
862      * @dev See {IERC721-setApprovalForAll}.
863      */
864     function setApprovalForAll(address operator, bool approved) public virtual override {
865         _setApprovalForAll(_msgSender(), operator, approved);
866     }
867 
868     /**
869      * @dev See {IERC721-isApprovedForAll}.
870      */
871     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
872         return _operatorApprovals[owner][operator];
873     }
874 
875     /**
876      * @dev See {IERC721-transferFrom}.
877      */
878     function transferFrom(
879         address from,
880         address to,
881         uint256 tokenId
882     ) public virtual override {
883         //solhint-disable-next-line max-line-length
884         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
885 
886         _transfer(from, to, tokenId);
887     }
888 
889     /**
890      * @dev See {IERC721-safeTransferFrom}.
891      */
892     function safeTransferFrom(
893         address from,
894         address to,
895         uint256 tokenId
896     ) public virtual override {
897         safeTransferFrom(from, to, tokenId, "");
898     }
899 
900     /**
901      * @dev See {IERC721-safeTransferFrom}.
902      */
903     function safeTransferFrom(
904         address from,
905         address to,
906         uint256 tokenId,
907         bytes memory _data
908     ) public virtual override {
909         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
910         _safeTransfer(from, to, tokenId, _data);
911     }
912 
913     /**
914      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
915      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
916      *
917      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
918      *
919      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
920      * implement alternative mechanisms to perform token transfer, such as signature-based.
921      *
922      * Requirements:
923      *
924      * - `from` cannot be the zero address.
925      * - `to` cannot be the zero address.
926      * - `tokenId` token must exist and be owned by `from`.
927      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
928      *
929      * Emits a {Transfer} event.
930      */
931     function _safeTransfer(
932         address from,
933         address to,
934         uint256 tokenId,
935         bytes memory _data
936     ) internal virtual {
937         _transfer(from, to, tokenId);
938         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
939     }
940 
941     /**
942      * @dev Returns whether `tokenId` exists.
943      *
944      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
945      *
946      * Tokens start existing when they are minted (`_mint`),
947      * and stop existing when they are burned (`_burn`).
948      */
949     function _exists(uint256 tokenId) internal view virtual returns (bool) {
950         return _owners[tokenId] != address(0);
951     }
952 
953     /**
954      * @dev Returns whether `spender` is allowed to manage `tokenId`.
955      *
956      * Requirements:
957      *
958      * - `tokenId` must exist.
959      */
960     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
961         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
962         address owner = ERC721.ownerOf(tokenId);
963         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
964     }
965 
966     /**
967      * @dev Safely mints `tokenId` and transfers it to `to`.
968      *
969      * Requirements:
970      *
971      * - `tokenId` must not exist.
972      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
973      *
974      * Emits a {Transfer} event.
975      */
976     function _safeMint(address to, uint256 tokenId) internal virtual {
977         _safeMint(to, tokenId, "");
978     }
979 
980     /**
981      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
982      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
983      */
984     function _safeMint(
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) internal virtual {
989         _mint(to, tokenId);
990         require(
991             _checkOnERC721Received(address(0), to, tokenId, _data),
992             "ERC721: transfer to non ERC721Receiver implementer"
993         );
994     }
995 
996     /**
997      * @dev Mints `tokenId` and transfers it to `to`.
998      *
999      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must not exist.
1004      * - `to` cannot be the zero address.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _mint(address to, uint256 tokenId) internal virtual {
1009         require(to != address(0), "ERC721: mint to the zero address");
1010         require(!_exists(tokenId), "ERC721: token already minted");
1011 
1012         _beforeTokenTransfer(address(0), to, tokenId);
1013 
1014         _balances[to] += 1;
1015         _owners[tokenId] = to;
1016 
1017         emit Transfer(address(0), to, tokenId);
1018 
1019         _afterTokenTransfer(address(0), to, tokenId);
1020     }
1021 
1022     /**
1023      * @dev Destroys `tokenId`.
1024      * The approval is cleared when the token is burned.
1025      *
1026      * Requirements:
1027      *
1028      * - `tokenId` must exist.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function _burn(uint256 tokenId) internal virtual {
1033         address owner = ERC721.ownerOf(tokenId);
1034 
1035         _beforeTokenTransfer(owner, address(0), tokenId);
1036 
1037         // Clear approvals
1038         _approve(address(0), tokenId);
1039 
1040         _balances[owner] -= 1;
1041         delete _owners[tokenId];
1042 
1043         emit Transfer(owner, address(0), tokenId);
1044 
1045         _afterTokenTransfer(owner, address(0), tokenId);
1046     }
1047 
1048     /**
1049      * @dev Transfers `tokenId` from `from` to `to`.
1050      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1051      *
1052      * Requirements:
1053      *
1054      * - `to` cannot be the zero address.
1055      * - `tokenId` token must be owned by `from`.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _transfer(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) internal virtual {
1064         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1065         require(to != address(0), "ERC721: transfer to the zero address");
1066 
1067         _beforeTokenTransfer(from, to, tokenId);
1068 
1069         // Clear approvals from the previous owner
1070         _approve(address(0), tokenId);
1071 
1072         _balances[from] -= 1;
1073         _balances[to] += 1;
1074         _owners[tokenId] = to;
1075 
1076         emit Transfer(from, to, tokenId);
1077 
1078         _afterTokenTransfer(from, to, tokenId);
1079     }
1080 
1081     /**
1082      * @dev Approve `to` to operate on `tokenId`
1083      *
1084      * Emits a {Approval} event.
1085      */
1086     function _approve(address to, uint256 tokenId) internal virtual {
1087         _tokenApprovals[tokenId] = to;
1088         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1089     }
1090 
1091     /**
1092      * @dev Approve `operator` to operate on all of `owner` tokens
1093      *
1094      * Emits a {ApprovalForAll} event.
1095      */
1096     function _setApprovalForAll(
1097         address owner,
1098         address operator,
1099         bool approved
1100     ) internal virtual {
1101         require(owner != operator, "ERC721: approve to caller");
1102         _operatorApprovals[owner][operator] = approved;
1103         emit ApprovalForAll(owner, operator, approved);
1104     }
1105 
1106     /**
1107      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1108      * The call is not executed if the target address is not a contract.
1109      *
1110      * @param from address representing the previous owner of the given token ID
1111      * @param to target address that will receive the tokens
1112      * @param tokenId uint256 ID of the token to be transferred
1113      * @param _data bytes optional data to send along with the call
1114      * @return bool whether the call correctly returned the expected magic value
1115      */
1116     function _checkOnERC721Received(
1117         address from,
1118         address to,
1119         uint256 tokenId,
1120         bytes memory _data
1121     ) private returns (bool) {
1122         if (to.isContract()) {
1123             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1124                 return retval == IERC721Receiver.onERC721Received.selector;
1125             } catch (bytes memory reason) {
1126                 if (reason.length == 0) {
1127                     revert("ERC721: transfer to non ERC721Receiver implementer");
1128                 } else {
1129                     assembly {
1130                         revert(add(32, reason), mload(reason))
1131                     }
1132                 }
1133             }
1134         } else {
1135             return true;
1136         }
1137     }
1138 
1139     /**
1140      * @dev Hook that is called before any token transfer. This includes minting
1141      * and burning.
1142      *
1143      * Calling conditions:
1144      *
1145      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1146      * transferred to `to`.
1147      * - When `from` is zero, `tokenId` will be minted for `to`.
1148      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1149      * - `from` and `to` are never both zero.
1150      *
1151      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1152      */
1153     function _beforeTokenTransfer(
1154         address from,
1155         address to,
1156         uint256 tokenId
1157     ) internal virtual {}
1158 
1159     /**
1160      * @dev Hook that is called after any transfer of tokens. This includes
1161      * minting and burning.
1162      *
1163      * Calling conditions:
1164      *
1165      * - when `from` and `to` are both non-zero.
1166      * - `from` and `to` are never both zero.
1167      *
1168      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1169      */
1170     function _afterTokenTransfer(
1171         address from,
1172         address to,
1173         uint256 tokenId
1174     ) internal virtual {}
1175 }
1176 
1177 // File: contracts/UglyDucklings.sol
1178 
1179 
1180 
1181 /*
1182   _    _       _         _____             _    _ _                 
1183  | |  | |     | |       |  __ \           | |  | (_)                
1184  | |  | | __ _| |_   _  | |  | |_   _  ___| | _| |_ _ __   __ _ ___ 
1185  | |  | |/ _` | | | | | | |  | | | | |/ __| |/ / | | '_ \ / _` / __|
1186  | |__| | (_| | | |_| | | |__| | |_| | (__|   <| | | | | | (_| \__ \
1187   \____/ \__, |_|\__, | |_____/ \__,_|\___|_|\_\_|_|_| |_|\__, |___/
1188           __/ |   __/ |                                    __/ |    
1189          |___/   |___/                                    |___/     
1190 
1191   3333 Ugly Ducklings abandoned on the Ethereum Blockchain. The world deemed them too ugly... what will you do?
1192   0.001 mint // 6 per tx // no roadmap, no anything. Pure degen.
1193 */
1194 
1195 
1196 
1197 pragma solidity ^0.8.0;
1198 
1199 
1200 
1201 
1202 contract UglyDucklings is ERC721, Ownable {
1203     using Strings for uint256;
1204     using Counters for Counters.Counter;
1205 
1206     Counters.Counter private supply;
1207 
1208     string private baseTokenURI;
1209     string public contractURI;
1210   
1211     uint256 public cost = 0.001 ether;
1212     uint256 public maxSupply = 3333;
1213     uint256 public maxMintAmountPerTx = 6;
1214 
1215     bool public paused = true;
1216 
1217     constructor() ERC721("UglyDucklings", "UD") {
1218         baseTokenURI = "ipfs://QmRruSMoqGWULxzJobqmFvKxqns25EpuDDEo6693ARf9xX/";
1219         contractURI = "ipfs://QmSGsTRR8u1gKYScggtu1eg7bcdxLCfvD8DySGWeuTgNYy";
1220     }
1221 
1222     modifier mintCompliance(uint256 _mintAmount) {
1223         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1224         require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1225         _;
1226     }
1227 
1228     function totalSupply() public view returns (uint256) {
1229         return supply.current();
1230     }
1231 
1232     function mint(uint256 _mintAmount) external payable mintCompliance(_mintAmount) {
1233         require(!paused, "The contract is paused!");
1234         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1235 
1236         _mintLoop(msg.sender, _mintAmount);
1237     }
1238   
1239     function mintForAddress(uint256 _mintAmount, address _receiver) external mintCompliance(_mintAmount) onlyOwner {
1240         _mintLoop(_receiver, _mintAmount);
1241     }
1242 
1243     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1244         uint256 ownerTokenCount = balanceOf(_owner);
1245         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1246         uint256 currentTokenId = 1;
1247         uint256 ownedTokenIndex = 0;
1248 
1249         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1250             address currentTokenOwner = ownerOf(currentTokenId);
1251             if (currentTokenOwner == _owner) {
1252                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1253                 ownedTokenIndex++;
1254             }
1255         currentTokenId++;
1256         }
1257         return ownedTokenIds;
1258     }
1259 
1260     function setContractURI(string memory _contractURI) external onlyOwner {
1261         contractURI = _contractURI;
1262     }
1263 
1264     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1265         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1266 
1267         string memory baseURI = _baseURI();
1268         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1269     }
1270 
1271     function setBaseTokenURI(string memory _baseTokenURI) external onlyOwner {
1272         baseTokenURI = _baseTokenURI;
1273     }
1274 
1275     function setPaused(bool _state) external onlyOwner {
1276         paused = _state;
1277     }
1278 
1279     function setPrice(uint256 _cost) external onlyOwner {
1280         cost = _cost;
1281     }
1282 
1283     function withdraw() external onlyOwner {
1284         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1285         require(os);
1286     }
1287 
1288     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1289         for (uint256 i = 0; i < _mintAmount; i++) {
1290             supply.increment();
1291             _safeMint(_receiver,  supply.current());
1292         }
1293     }
1294 
1295     function _baseURI() internal view virtual override returns (string memory) {
1296         return baseTokenURI;
1297     }
1298 }