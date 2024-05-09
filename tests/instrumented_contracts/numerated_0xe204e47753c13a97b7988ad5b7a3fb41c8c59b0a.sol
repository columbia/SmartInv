1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 /*
5 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
6 @██████╗  ██████╗  ██████╗ ██████╗ ██╗     ███████╗     ██████╗ █████╗ ████████╗███████╗@
7 @██╔══██╗██╔═══██╗██╔═══██╗██╔══██╗██║     ██╔════╝    ██╔════╝██╔══██╗╚══██╔══╝██╔════╝@
8 @██║  ██║██║   ██║██║   ██║██║  ██║██║     █████╗      ██║     ███████║   ██║   ███████╗@
9 @██║  ██║██║   ██║██║   ██║██║  ██║██║     ██╔══╝      ██║     ██╔══██║   ██║   ╚════██║@
10 @██████╔╝╚██████╔╝╚██████╔╝██████╔╝███████╗███████╗    ╚██████╗██║  ██║   ██║   ███████║@
11 @╚═════╝  ╚═════╝  ╚═════╝ ╚═════╝ ╚══════╝╚══════╝     ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝@
12 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
13 
14 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
15 
16 As the Doodle Cats collection, we would like to draw attention to the other creatures we share our world with. Therefore, as a society,
17 we will work with charities to make this world a better place for all living things.
18 For Doodle Cats fans who want to join our community, the first 1000 NFTs are free, the remaining 9000 NFTs can be minted with 0.01 Ethereum.
19                                                                                        
20                                                                                                                              - Doodle Cats Team
21 
22 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
23 */
24 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @title Counters
30  * @author Matt Condon (@shrugs)
31  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
32  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
33  *
34  * Include with `using Counters for Counters.Counter;`
35  */
36 library Counters {
37     struct Counter {
38         // This variable should never be directly accessed by users of the library: interactions must be restricted to
39         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
40         // this feature: see https://github.com/ethereum/solidity/issues/4637
41         uint256 _value; // default: 0
42     }
43 
44     function current(Counter storage counter) internal view returns (uint256) {
45         return counter._value;
46     }
47 
48     function increment(Counter storage counter) internal {
49         unchecked {
50             counter._value += 1;
51         }
52     }
53 
54     function decrement(Counter storage counter) internal {
55         uint256 value = counter._value;
56         require(value > 0, "Counter: decrement overflow");
57         unchecked {
58             counter._value = value - 1;
59         }
60     }
61 
62     function reset(Counter storage counter) internal {
63         counter._value = 0;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
82      */
83     function toString(uint256 value) internal pure returns (string memory) {
84         // Inspired by OraclizeAPI's implementation - MIT licence
85         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
86 
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
107      */
108     function toHexString(uint256 value) internal pure returns (string memory) {
109         if (value == 0) {
110             return "0x00";
111         }
112         uint256 temp = value;
113         uint256 length = 0;
114         while (temp != 0) {
115             length++;
116             temp >>= 8;
117         }
118         return toHexString(value, length);
119     }
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
123      */
124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 }
136 
137 // File: @openzeppelin/contracts/utils/Context.sol
138 
139 
140 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 /**
145  * @dev Provides information about the current execution context, including the
146  * sender of the transaction and its data. While these are generally available
147  * via msg.sender and msg.data, they should not be accessed in such a direct
148  * manner, since when dealing with meta-transactions the account sending and
149  * paying for execution may not be the actual sender (as far as an application
150  * is concerned).
151  *
152  * This contract is only required for intermediate, library-like contracts.
153  */
154 abstract contract Context {
155     function _msgSender() internal view virtual returns (address) {
156         return msg.sender;
157     }
158 
159     function _msgData() internal view virtual returns (bytes calldata) {
160         return msg.data;
161     }
162 }
163 
164 // File: @openzeppelin/contracts/access/Ownable.sol
165 
166 
167 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
168 
169 pragma solidity ^0.8.0;
170 
171 
172 /**
173  * @dev Contract module which provides a basic access control mechanism, where
174  * there is an account (an owner) that can be granted exclusive access to
175  * specific functions.
176  *
177  * By default, the owner account will be the one that deploys the contract. This
178  * can later be changed with {transferOwnership}.
179  *
180  * This module is used through inheritance. It will make available the modifier
181  * `onlyOwner`, which can be applied to your functions to restrict their use to
182  * the owner.
183  */
184 abstract contract Ownable is Context {
185     address private _owner;
186 
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189     /**
190      * @dev Initializes the contract setting the deployer as the initial owner.
191      */
192     constructor() {
193         _transferOwnership(_msgSender());
194     }
195 
196     /**
197      * @dev Returns the address of the current owner.
198      */
199     function owner() public view virtual returns (address) {
200         return _owner;
201     }
202 
203     /**
204      * @dev Throws if called by any account other than the owner.
205      */
206     modifier onlyOwner() {
207         require(owner() == _msgSender(), "Ownable: caller is not the owner");
208         _;
209     }
210 
211     /**
212      * @dev Leaves the contract without owner. It will not be possible to call
213      * `onlyOwner` functions anymore. Can only be called by the current owner.
214      *
215      * NOTE: Renouncing ownership will leave the contract without an owner,
216      * thereby removing any functionality that is only available to the owner.
217      */
218     function renounceOwnership() public virtual onlyOwner {
219         _transferOwnership(address(0));
220     }
221 
222     /**
223      * @dev Transfers ownership of the contract to a new account (`newOwner`).
224      * Can only be called by the current owner.
225      */
226     function transferOwnership(address newOwner) public virtual onlyOwner {
227         require(newOwner != address(0), "Ownable: new owner is the zero address");
228         _transferOwnership(newOwner);
229     }
230 
231     /**
232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
233      * Internal function without access restriction.
234      */
235     function _transferOwnership(address newOwner) internal virtual {
236         address oldOwner = _owner;
237         _owner = newOwner;
238         emit OwnershipTransferred(oldOwner, newOwner);
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/Address.sol
243 
244 
245 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
246 
247 pragma solidity ^0.8.1;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      *
270      * [IMPORTANT]
271      * ====
272      * You shouldn't rely on `isContract` to protect against flash loan attacks!
273      *
274      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
275      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
276      * constructor.
277      * ====
278      */
279     function isContract(address account) internal view returns (bool) {
280         // This method relies on extcodesize/address.code.length, which returns 0
281         // for contracts in construction, since the code is only stored at the end
282         // of the constructor execution.
283 
284         return account.code.length > 0;
285     }
286 
287     /**
288      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
289      * `recipient`, forwarding all available gas and reverting on errors.
290      *
291      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
292      * of certain opcodes, possibly making contracts go over the 2300 gas limit
293      * imposed by `transfer`, making them unable to receive funds via
294      * `transfer`. {sendValue} removes this limitation.
295      *
296      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
297      *
298      * IMPORTANT: because control is transferred to `recipient`, care must be
299      * taken to not create reentrancy vulnerabilities. Consider using
300      * {ReentrancyGuard} or the
301      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
302      */
303     function sendValue(address payable recipient, uint256 amount) internal {
304         require(address(this).balance >= amount, "Address: insufficient balance");
305 
306         (bool success, ) = recipient.call{value: amount}("");
307         require(success, "Address: unable to send value, recipient may have reverted");
308     }
309 
310     /**
311      * @dev Performs a Solidity function call using a low level `call`. A
312      * plain `call` is an unsafe replacement for a function call: use this
313      * function instead.
314      *
315      * If `target` reverts with a revert reason, it is bubbled up by this
316      * function (like regular Solidity function calls).
317      *
318      * Returns the raw returned data. To convert to the expected return value,
319      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
320      *
321      * Requirements:
322      *
323      * - `target` must be a contract.
324      * - calling `target` with `data` must not revert.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
329         return functionCall(target, data, "Address: low-level call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
334      * `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(
339         address target,
340         bytes memory data,
341         string memory errorMessage
342     ) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, 0, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but also transferring `value` wei to `target`.
349      *
350      * Requirements:
351      *
352      * - the calling contract must have an ETH balance of at least `value`.
353      * - the called Solidity function must be `payable`.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value
361     ) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(
372         address target,
373         bytes memory data,
374         uint256 value,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         require(address(this).balance >= value, "Address: insufficient balance for call");
378         require(isContract(target), "Address: call to non-contract");
379 
380         (bool success, bytes memory returndata) = target.call{value: value}(data);
381         return verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but performing a static call.
387      *
388      * _Available since v3.3._
389      */
390     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
391         return functionStaticCall(target, data, "Address: low-level static call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
396      * but performing a static call.
397      *
398      * _Available since v3.3._
399      */
400     function functionStaticCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal view returns (bytes memory) {
405         require(isContract(target), "Address: static call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.staticcall(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but performing a delegate call.
414      *
415      * _Available since v3.4._
416      */
417     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
418         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
423      * but performing a delegate call.
424      *
425      * _Available since v3.4._
426      */
427     function functionDelegateCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal returns (bytes memory) {
432         require(isContract(target), "Address: delegate call to non-contract");
433 
434         (bool success, bytes memory returndata) = target.delegatecall(data);
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
440      * revert reason using the provided one.
441      *
442      * _Available since v4.3._
443      */
444     function verifyCallResult(
445         bool success,
446         bytes memory returndata,
447         string memory errorMessage
448     ) internal pure returns (bytes memory) {
449         if (success) {
450             return returndata;
451         } else {
452             // Look for revert reason and bubble it up if present
453             if (returndata.length > 0) {
454                 // The easiest way to bubble the revert reason is using memory via assembly
455 
456                 assembly {
457                     let returndata_size := mload(returndata)
458                     revert(add(32, returndata), returndata_size)
459                 }
460             } else {
461                 revert(errorMessage);
462             }
463         }
464     }
465 }
466 
467 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
468 
469 
470 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
471 
472 pragma solidity ^0.8.0;
473 
474 /**
475  * @title ERC721 token receiver interface
476  * @dev Interface for any contract that wants to support safeTransfers
477  * from ERC721 asset contracts.
478  */
479 interface IERC721Receiver {
480     /**
481      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
482      * by `operator` from `from`, this function is called.
483      *
484      * It must return its Solidity selector to confirm the token transfer.
485      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
486      *
487      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
488      */
489     function onERC721Received(
490         address operator,
491         address from,
492         uint256 tokenId,
493         bytes calldata data
494     ) external returns (bytes4);
495 }
496 
497 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
498 
499 
500 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 /**
505  * @dev Interface of the ERC165 standard, as defined in the
506  * https://eips.ethereum.org/EIPS/eip-165[EIP].
507  *
508  * Implementers can declare support of contract interfaces, which can then be
509  * queried by others ({ERC165Checker}).
510  *
511  * For an implementation, see {ERC165}.
512  */
513 interface IERC165 {
514     /**
515      * @dev Returns true if this contract implements the interface defined by
516      * `interfaceId`. See the corresponding
517      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
518      * to learn more about how these ids are created.
519      *
520      * This function call must use less than 30 000 gas.
521      */
522     function supportsInterface(bytes4 interfaceId) external view returns (bool);
523 }
524 
525 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 
533 /**
534  * @dev Implementation of the {IERC165} interface.
535  *
536  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
537  * for the additional interface id that will be supported. For example:
538  *
539  * ```solidity
540  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
541  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
542  * }
543  * ```
544  *
545  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
546  */
547 abstract contract ERC165 is IERC165 {
548     /**
549      * @dev See {IERC165-supportsInterface}.
550      */
551     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
552         return interfaceId == type(IERC165).interfaceId;
553     }
554 }
555 
556 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
557 
558 
559 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 
564 /**
565  * @dev Required interface of an ERC721 compliant contract.
566  */
567 interface IERC721 is IERC165 {
568     /**
569      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
570      */
571     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
572 
573     /**
574      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
575      */
576     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
577 
578     /**
579      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
580      */
581     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
582 
583     /**
584      * @dev Returns the number of tokens in ``owner``'s account.
585      */
586     function balanceOf(address owner) external view returns (uint256 balance);
587 
588     /**
589      * @dev Returns the owner of the `tokenId` token.
590      *
591      * Requirements:
592      *
593      * - `tokenId` must exist.
594      */
595     function ownerOf(uint256 tokenId) external view returns (address owner);
596 
597     /**
598      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
599      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must exist and be owned by `from`.
606      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
607      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
608      *
609      * Emits a {Transfer} event.
610      */
611     function safeTransferFrom(
612         address from,
613         address to,
614         uint256 tokenId
615     ) external;
616 
617     /**
618      * @dev Transfers `tokenId` token from `from` to `to`.
619      *
620      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
621      *
622      * Requirements:
623      *
624      * - `from` cannot be the zero address.
625      * - `to` cannot be the zero address.
626      * - `tokenId` token must be owned by `from`.
627      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
628      *
629      * Emits a {Transfer} event.
630      */
631     function transferFrom(
632         address from,
633         address to,
634         uint256 tokenId
635     ) external;
636 
637     /**
638      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
639      * The approval is cleared when the token is transferred.
640      *
641      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
642      *
643      * Requirements:
644      *
645      * - The caller must own the token or be an approved operator.
646      * - `tokenId` must exist.
647      *
648      * Emits an {Approval} event.
649      */
650     function approve(address to, uint256 tokenId) external;
651 
652     /**
653      * @dev Returns the account approved for `tokenId` token.
654      *
655      * Requirements:
656      *
657      * - `tokenId` must exist.
658      */
659     function getApproved(uint256 tokenId) external view returns (address operator);
660 
661     /**
662      * @dev Approve or remove `operator` as an operator for the caller.
663      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
664      *
665      * Requirements:
666      *
667      * - The `operator` cannot be the caller.
668      *
669      * Emits an {ApprovalForAll} event.
670      */
671     function setApprovalForAll(address operator, bool _approved) external;
672 
673     /**
674      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
675      *
676      * See {setApprovalForAll}
677      */
678     function isApprovedForAll(address owner, address operator) external view returns (bool);
679 
680     /**
681      * @dev Safely transfers `tokenId` token from `from` to `to`.
682      *
683      * Requirements:
684      *
685      * - `from` cannot be the zero address.
686      * - `to` cannot be the zero address.
687      * - `tokenId` token must exist and be owned by `from`.
688      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
689      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
690      *
691      * Emits a {Transfer} event.
692      */
693     function safeTransferFrom(
694         address from,
695         address to,
696         uint256 tokenId,
697         bytes calldata data
698     ) external;
699 }
700 
701 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
702 
703 
704 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 
709 /**
710  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
711  * @dev See https://eips.ethereum.org/EIPS/eip-721
712  */
713 interface IERC721Metadata is IERC721 {
714     /**
715      * @dev Returns the token collection name.
716      */
717     function name() external view returns (string memory);
718 
719     /**
720      * @dev Returns the token collection symbol.
721      */
722     function symbol() external view returns (string memory);
723 
724     /**
725      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
726      */
727     function tokenURI(uint256 tokenId) external view returns (string memory);
728 }
729 
730 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
731 
732 
733 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
734 
735 pragma solidity ^0.8.0;
736 
737 
738 
739 
740 
741 
742 
743 
744 /**
745  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
746  * the Metadata extension, but not including the Enumerable extension, which is available separately as
747  * {ERC721Enumerable}.
748  */
749 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
750     using Address for address;
751     using Strings for uint256;
752 
753     // Token name
754     string private _name;
755 
756     // Token symbol
757     string private _symbol;
758 
759     // Mapping from token ID to owner address
760     mapping(uint256 => address) private _owners;
761 
762     // Mapping owner address to token count
763     mapping(address => uint256) private _balances;
764 
765     // Mapping from token ID to approved address
766     mapping(uint256 => address) private _tokenApprovals;
767 
768     // Mapping from owner to operator approvals
769     mapping(address => mapping(address => bool)) private _operatorApprovals;
770 
771     /**
772      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
773      */
774     constructor(string memory name_, string memory symbol_) {
775         _name = name_;
776         _symbol = symbol_;
777     }
778 
779     /**
780      * @dev See {IERC165-supportsInterface}.
781      */
782     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
783         return
784             interfaceId == type(IERC721).interfaceId ||
785             interfaceId == type(IERC721Metadata).interfaceId ||
786             super.supportsInterface(interfaceId);
787     }
788 
789     /**
790      * @dev See {IERC721-balanceOf}.
791      */
792     function balanceOf(address owner) public view virtual override returns (uint256) {
793         require(owner != address(0), "ERC721: balance query for the zero address");
794         return _balances[owner];
795     }
796 
797     /**
798      * @dev See {IERC721-ownerOf}.
799      */
800     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
801         address owner = _owners[tokenId];
802         require(owner != address(0), "ERC721: owner query for nonexistent token");
803         return owner;
804     }
805 
806     /**
807      * @dev See {IERC721Metadata-name}.
808      */
809     function name() public view virtual override returns (string memory) {
810         return _name;
811     }
812 
813     /**
814      * @dev See {IERC721Metadata-symbol}.
815      */
816     function symbol() public view virtual override returns (string memory) {
817         return _symbol;
818     }
819 
820     /**
821      * @dev See {IERC721Metadata-tokenURI}.
822      */
823     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
824         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
825 
826         string memory baseURI = _baseURI();
827         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
828     }
829 
830     /**
831      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
832      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
833      * by default, can be overriden in child contracts.
834      */
835     function _baseURI() internal view virtual returns (string memory) {
836         return "";
837     }
838 
839     /**
840      * @dev See {IERC721-approve}.
841      */
842     function approve(address to, uint256 tokenId) public virtual override {
843         address owner = ERC721.ownerOf(tokenId);
844         require(to != owner, "ERC721: approval to current owner");
845 
846         require(
847             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
848             "ERC721: approve caller is not owner nor approved for all"
849         );
850 
851         _approve(to, tokenId);
852     }
853 
854     /**
855      * @dev See {IERC721-getApproved}.
856      */
857     function getApproved(uint256 tokenId) public view virtual override returns (address) {
858         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
859 
860         return _tokenApprovals[tokenId];
861     }
862 
863     /**
864      * @dev See {IERC721-setApprovalForAll}.
865      */
866     function setApprovalForAll(address operator, bool approved) public virtual override {
867         _setApprovalForAll(_msgSender(), operator, approved);
868     }
869 
870     /**
871      * @dev See {IERC721-isApprovedForAll}.
872      */
873     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
874         return _operatorApprovals[owner][operator];
875     }
876 
877     /**
878      * @dev See {IERC721-transferFrom}.
879      */
880     function transferFrom(
881         address from,
882         address to,
883         uint256 tokenId
884     ) public virtual override {
885         //solhint-disable-next-line max-line-length
886         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
887 
888         _transfer(from, to, tokenId);
889     }
890 
891     /**
892      * @dev See {IERC721-safeTransferFrom}.
893      */
894     function safeTransferFrom(
895         address from,
896         address to,
897         uint256 tokenId
898     ) public virtual override {
899         safeTransferFrom(from, to, tokenId, "");
900     }
901 
902     /**
903      * @dev See {IERC721-safeTransferFrom}.
904      */
905     function safeTransferFrom(
906         address from,
907         address to,
908         uint256 tokenId,
909         bytes memory _data
910     ) public virtual override {
911         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
912         _safeTransfer(from, to, tokenId, _data);
913     }
914 
915     /**
916      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
917      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
918      *
919      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
920      *
921      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
922      * implement alternative mechanisms to perform token transfer, such as signature-based.
923      *
924      * Requirements:
925      *
926      * - `from` cannot be the zero address.
927      * - `to` cannot be the zero address.
928      * - `tokenId` token must exist and be owned by `from`.
929      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
930      *
931      * Emits a {Transfer} event.
932      */
933     function _safeTransfer(
934         address from,
935         address to,
936         uint256 tokenId,
937         bytes memory _data
938     ) internal virtual {
939         _transfer(from, to, tokenId);
940         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
941     }
942 
943     /**
944      * @dev Returns whether `tokenId` exists.
945      *
946      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
947      *
948      * Tokens start existing when they are minted (`_mint`),
949      * and stop existing when they are burned (`_burn`).
950      */
951     function _exists(uint256 tokenId) internal view virtual returns (bool) {
952         return _owners[tokenId] != address(0);
953     }
954 
955     /**
956      * @dev Returns whether `spender` is allowed to manage `tokenId`.
957      *
958      * Requirements:
959      *
960      * - `tokenId` must exist.
961      */
962     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
963         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
964         address owner = ERC721.ownerOf(tokenId);
965         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
966     }
967 
968     /**
969      * @dev Safely mints `tokenId` and transfers it to `to`.
970      *
971      * Requirements:
972      *
973      * - `tokenId` must not exist.
974      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
975      *
976      * Emits a {Transfer} event.
977      */
978     function _safeMint(address to, uint256 tokenId) internal virtual {
979         _safeMint(to, tokenId, "");
980     }
981 
982     /**
983      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
984      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
985      */
986     function _safeMint(
987         address to,
988         uint256 tokenId,
989         bytes memory _data
990     ) internal virtual {
991         _mint(to, tokenId);
992         require(
993             _checkOnERC721Received(address(0), to, tokenId, _data),
994             "ERC721: transfer to non ERC721Receiver implementer"
995         );
996     }
997 
998     /**
999      * @dev Mints `tokenId` and transfers it to `to`.
1000      *
1001      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1002      *
1003      * Requirements:
1004      *
1005      * - `tokenId` must not exist.
1006      * - `to` cannot be the zero address.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function _mint(address to, uint256 tokenId) internal virtual {
1011         require(to != address(0), "ERC721: mint to the zero address");
1012         require(!_exists(tokenId), "ERC721: token already minted");
1013 
1014         _beforeTokenTransfer(address(0), to, tokenId);
1015 
1016         _balances[to] += 1;
1017         _owners[tokenId] = to;
1018 
1019         emit Transfer(address(0), to, tokenId);
1020 
1021         _afterTokenTransfer(address(0), to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev Destroys `tokenId`.
1026      * The approval is cleared when the token is burned.
1027      *
1028      * Requirements:
1029      *
1030      * - `tokenId` must exist.
1031      *
1032      * Emits a {Transfer} event.
1033      */
1034     function _burn(uint256 tokenId) internal virtual {
1035         address owner = ERC721.ownerOf(tokenId);
1036 
1037         _beforeTokenTransfer(owner, address(0), tokenId);
1038 
1039         // Clear approvals
1040         _approve(address(0), tokenId);
1041 
1042         _balances[owner] -= 1;
1043         delete _owners[tokenId];
1044 
1045         emit Transfer(owner, address(0), tokenId);
1046 
1047         _afterTokenTransfer(owner, address(0), tokenId);
1048     }
1049 
1050     /**
1051      * @dev Transfers `tokenId` from `from` to `to`.
1052      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1053      *
1054      * Requirements:
1055      *
1056      * - `to` cannot be the zero address.
1057      * - `tokenId` token must be owned by `from`.
1058      *
1059      * Emits a {Transfer} event.
1060      */
1061     function _transfer(
1062         address from,
1063         address to,
1064         uint256 tokenId
1065     ) internal virtual {
1066         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1067         require(to != address(0), "ERC721: transfer to the zero address");
1068 
1069         _beforeTokenTransfer(from, to, tokenId);
1070 
1071         // Clear approvals from the previous owner
1072         _approve(address(0), tokenId);
1073 
1074         _balances[from] -= 1;
1075         _balances[to] += 1;
1076         _owners[tokenId] = to;
1077 
1078         emit Transfer(from, to, tokenId);
1079 
1080         _afterTokenTransfer(from, to, tokenId);
1081     }
1082 
1083     /**
1084      * @dev Approve `to` to operate on `tokenId`
1085      *
1086      * Emits a {Approval} event.
1087      */
1088     function _approve(address to, uint256 tokenId) internal virtual {
1089         _tokenApprovals[tokenId] = to;
1090         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1091     }
1092 
1093     /**
1094      * @dev Approve `operator` to operate on all of `owner` tokens
1095      *
1096      * Emits a {ApprovalForAll} event.
1097      */
1098     function _setApprovalForAll(
1099         address owner,
1100         address operator,
1101         bool approved
1102     ) internal virtual {
1103         require(owner != operator, "ERC721: approve to caller");
1104         _operatorApprovals[owner][operator] = approved;
1105         emit ApprovalForAll(owner, operator, approved);
1106     }
1107 
1108     /**
1109      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1110      * The call is not executed if the target address is not a contract.
1111      *
1112      * @param from address representing the previous owner of the given token ID
1113      * @param to target address that will receive the tokens
1114      * @param tokenId uint256 ID of the token to be transferred
1115      * @param _data bytes optional data to send along with the call
1116      * @return bool whether the call correctly returned the expected magic value
1117      */
1118     function _checkOnERC721Received(
1119         address from,
1120         address to,
1121         uint256 tokenId,
1122         bytes memory _data
1123     ) private returns (bool) {
1124         if (to.isContract()) {
1125             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1126                 return retval == IERC721Receiver.onERC721Received.selector;
1127             } catch (bytes memory reason) {
1128                 if (reason.length == 0) {
1129                     revert("ERC721: transfer to non ERC721Receiver implementer");
1130                 } else {
1131                     assembly {
1132                         revert(add(32, reason), mload(reason))
1133                     }
1134                 }
1135             }
1136         } else {
1137             return true;
1138         }
1139     }
1140 
1141     /**
1142      * @dev Hook that is called before any token transfer. This includes minting
1143      * and burning.
1144      *
1145      * Calling conditions:
1146      *
1147      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1148      * transferred to `to`.
1149      * - When `from` is zero, `tokenId` will be minted for `to`.
1150      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1151      * - `from` and `to` are never both zero.
1152      *
1153      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1154      */
1155     function _beforeTokenTransfer(
1156         address from,
1157         address to,
1158         uint256 tokenId
1159     ) internal virtual {}
1160 
1161     /**
1162      * @dev Hook that is called after any transfer of tokens. This includes
1163      * minting and burning.
1164      *
1165      * Calling conditions:
1166      *
1167      * - when `from` and `to` are both non-zero.
1168      * - `from` and `to` are never both zero.
1169      *
1170      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1171      */
1172     function _afterTokenTransfer(
1173         address from,
1174         address to,
1175         uint256 tokenId
1176     ) internal virtual {}
1177 }
1178 
1179 // File: contracts/DoodleCats.sol
1180 
1181 
1182 pragma solidity >=0.7.0 <0.9.0;
1183 
1184 
1185 contract DoodleCats is ERC721, Ownable {
1186   using Strings for uint256;
1187   using Counters for Counters.Counter;
1188 
1189   Counters.Counter private supply;
1190 
1191   string public uriPrefix = "";
1192   string public uriSuffix = ".json";
1193   string public hiddenMetadataUri;
1194   
1195   uint256 public cost = 0 ether; // For Doodle Cats fans who want to join our community, the first 1000 NFTs are free, the remaining 9000 NFTs can be minted with 0.01 Ethereum.
1196   uint256 public maxSupply = 1000;
1197   uint256 public maxMintAmountPerTx = 3;
1198 
1199   bool public paused = true;
1200   bool public revealed = false;
1201 
1202   constructor() ERC721("Doodle Cats", "DODC") {
1203     setHiddenMetadataUri("ipfs://QmYrn86qKUwo4BkvDsYtBFM3V3WX9wGDwRoZZPyfusaWUK/hidden.json");
1204   }
1205 
1206   modifier mintCompliance(uint256 _mintAmount) {
1207     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1208     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1209     _;
1210   }
1211 
1212   function totalSupply() public view returns (uint256) {
1213     return supply.current();
1214   }
1215 
1216   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1217     require(!paused, "The contract is paused!");
1218     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1219 
1220     _mintLoop(msg.sender, _mintAmount);
1221   }
1222   
1223   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1224     _mintLoop(_receiver, _mintAmount);
1225   }
1226 
1227   function walletOfOwner(address _owner)
1228     public
1229     view
1230     returns (uint256[] memory)
1231   {
1232     uint256 ownerTokenCount = balanceOf(_owner);
1233     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1234     uint256 currentTokenId = 1;
1235     uint256 ownedTokenIndex = 0;
1236 
1237     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1238       address currentTokenOwner = ownerOf(currentTokenId);
1239 
1240       if (currentTokenOwner == _owner) {
1241         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1242 
1243         ownedTokenIndex++;
1244       }
1245 
1246       currentTokenId++;
1247     }
1248 
1249     return ownedTokenIds;
1250   }
1251 
1252   function tokenURI(uint256 _tokenId)
1253     public
1254     view
1255     virtual
1256     override
1257     returns (string memory)
1258   {
1259     require(
1260       _exists(_tokenId),
1261       "ERC721Metadata: URI query for nonexistent token"
1262     );
1263 
1264     if (revealed == false) {
1265       return hiddenMetadataUri;
1266     }
1267 
1268     string memory currentBaseURI = _baseURI();
1269     return bytes(currentBaseURI).length > 0
1270         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1271         : "";
1272   }
1273 
1274   function setRevealed(bool _state) public onlyOwner {
1275     revealed = _state;
1276   }
1277 
1278   function setCost(uint256 _cost) public onlyOwner {
1279     cost = _cost;
1280   }
1281 
1282   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1283     maxMintAmountPerTx = _maxMintAmountPerTx;
1284   }
1285   
1286    function setmaxSupply(uint256 _maxSupply) public onlyOwner {
1287     maxSupply = _maxSupply;
1288   }
1289 
1290   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1291     hiddenMetadataUri = _hiddenMetadataUri;
1292   }
1293 
1294   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1295     uriPrefix = _uriPrefix;
1296   }
1297 
1298   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1299     uriSuffix = _uriSuffix;
1300   }
1301 
1302   function setPaused(bool _state) public onlyOwner {
1303     paused = _state;
1304   }
1305 
1306   function withdraw() public onlyOwner {
1307     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1308     require(os);
1309   }
1310 
1311   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1312     for (uint256 i = 0; i < _mintAmount; i++) {
1313       supply.increment();
1314       _safeMint(_receiver, supply.current());
1315     }
1316   }
1317 
1318   function _baseURI() internal view virtual override returns (string memory) {
1319     return uriPrefix;
1320   }
1321 }