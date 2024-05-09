1 // (づ｡◕‿‿◕｡)づ
2 
3 // Les Non Fongible Femmes is a series of hand-painted female portraits from NonFungible Lady.
4 // Only 500 Les Non Fongible Femmes portraits will exist.
5 // Mint cost 0.03 eth per Femme, max 10 femmes per transaction, please mint directly from contract on Etherscan.
6 
7 // File: @openzeppelin/contracts/utils/Counters.sol
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @title Counters
13  * @author Matt Condon (@shrugs)
14  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
15  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
16  *
17  * Include with `using Counters for Counters.Counter;`
18  */
19 library Counters {
20     struct Counter {
21         // This variable should never be directly accessed by users of the library: interactions must be restricted to
22         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
23         // this feature: see https://github.com/ethereum/solidity/issues/4637
24         uint256 _value; // default: 0
25     }
26 
27     function current(Counter storage counter) internal view returns (uint256) {
28         return counter._value;
29     }
30 
31     function increment(Counter storage counter) internal {
32         unchecked {
33             counter._value += 1;
34         }
35     }
36 
37     function decrement(Counter storage counter) internal {
38         uint256 value = counter._value;
39         require(value > 0, "Counter: decrement overflow");
40         unchecked {
41             counter._value = value - 1;
42         }
43     }
44 
45     function reset(Counter storage counter) internal {
46         counter._value = 0;
47     }
48 }
49 
50 // File: contracts/WithLimitedSupply.sol
51 
52 
53 pragma solidity ^0.8.0;
54 
55 
56 /// @author 1001.digital 
57 /// @title A token tracker that limits the token supply and increments token IDs on each new mint.
58 abstract contract WithLimitedSupply {
59     using Counters for Counters.Counter;
60 
61     // Keeps track of how many we have minted
62     Counters.Counter private _tokenCount;
63 
64     /// @dev The maximum count of tokens this token tracker will hold.
65     uint256 private _maxSupply;
66 
67     /// Instanciate the contract
68     /// @param totalSupply_ how many tokens this collection should hold
69     constructor (uint256 totalSupply_) {
70         _maxSupply = totalSupply_;
71     }
72 
73     /// @dev Get the max Supply
74     /// @return the maximum token count
75     function maxSupply() public view returns (uint256) {
76         return _maxSupply;
77     }
78 
79     /// @dev Get the current token count
80     /// @return the created token count
81     function tokenCount() public view returns (uint256) {
82         return _tokenCount.current();
83     }
84 
85     /// @dev Check whether tokens are still available
86     /// @return the available token count
87     function availableTokenCount() public view returns (uint256) {
88         return maxSupply() - tokenCount();
89     }
90 
91     /// @dev Increment the token count and fetch the latest count
92     /// @return the next token id
93     function nextToken() internal virtual ensureAvailability returns (uint256) {
94         uint256 token = _tokenCount.current();
95 
96         _tokenCount.increment();
97 
98         return token;
99     }
100 
101     /// @dev Check whether another token is still available
102     modifier ensureAvailability() {
103         require(availableTokenCount() > 0, "No more tokens available");
104         _;
105     }
106 
107     /// @param amount Check whether number of tokens are still available
108     /// @dev Check whether tokens are still available
109     modifier ensureAvailabilityFor(uint256 amount) {
110         require(availableTokenCount() >= amount, "Requested number of tokens not available");
111         _;
112     }
113 }
114 // File: contracts/RandomlyAssigned.sol
115 
116 
117 pragma solidity ^0.8.0;
118 
119 
120 /// @author 1001.digital
121 /// @title Randomly assign tokenIDs from a given set of tokens.
122 abstract contract RandomlyAssigned is WithLimitedSupply {
123     // Used for random index assignment
124     mapping(uint256 => uint256) private tokenMatrix;
125 
126     // The initial token ID
127     uint256 private startFrom;
128 
129     /// Instanciate the contract
130     /// @param _maxSupply how many tokens this collection should hold
131     /// @param _startFrom the tokenID with which to start counting
132     constructor (uint256 _maxSupply, uint256 _startFrom)
133         WithLimitedSupply(_maxSupply)
134     {
135         startFrom = _startFrom;
136     }
137 
138     /// Get the next token ID
139     /// @dev Randomly gets a new token ID and keeps track of the ones that are still available.
140     /// @return the next token ID
141     function nextToken() internal override ensureAvailability returns (uint256) {
142         uint256 maxIndex = maxSupply() - tokenCount();
143         uint256 random = uint256(keccak256(
144             abi.encodePacked(
145                 msg.sender,
146                 block.coinbase,
147                 block.difficulty,
148                 block.gaslimit,
149                 block.timestamp
150             )
151         )) % maxIndex;
152 
153         uint256 value = 0;
154         if (tokenMatrix[random] == 0) {
155             // If this matrix position is empty, set the value to the generated random number.
156             value = random;
157         } else {
158             // Otherwise, use the previously stored number from the matrix.
159             value = tokenMatrix[random];
160         }
161 
162         // If the last available tokenID is still unused...
163         if (tokenMatrix[maxIndex - 1] == 0) {
164             // ...store that ID in the current matrix position.
165             tokenMatrix[random] = maxIndex - 1;
166         } else {
167             // ...otherwise copy over the stored number to the current matrix position.
168             tokenMatrix[random] = tokenMatrix[maxIndex - 1];
169         }
170 
171         // Increment counts
172         super.nextToken();
173 
174         return value + startFrom;
175     }
176 }
177 
178 // File: @openzeppelin/contracts/utils/Context.sol
179 
180 
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @dev Provides information about the current execution context, including the
186  * sender of the transaction and its data. While these are generally available
187  * via msg.sender and msg.data, they should not be accessed in such a direct
188  * manner, since when dealing with meta-transactions the account sending and
189  * paying for execution may not be the actual sender (as far as an application
190  * is concerned).
191  *
192  * This contract is only required for intermediate, library-like contracts.
193  */
194 abstract contract Context {
195     function _msgSender() internal view virtual returns (address) {
196         return msg.sender;
197     }
198 
199     function _msgData() internal view virtual returns (bytes calldata) {
200         return msg.data;
201     }
202 }
203 
204 // File: @openzeppelin/contracts/access/Ownable.sol
205 
206 
207 
208 pragma solidity ^0.8.0;
209 
210 
211 /**
212  * @dev Contract module which provides a basic access control mechanism, where
213  * there is an account (an owner) that can be granted exclusive access to
214  * specific functions.
215  *
216  * By default, the owner account will be the one that deploys the contract. This
217  * can later be changed with {transferOwnership}.
218  *
219  * This module is used through inheritance. It will make available the modifier
220  * `onlyOwner`, which can be applied to your functions to restrict their use to
221  * the owner.
222  */
223 abstract contract Ownable is Context {
224     address private _owner;
225 
226     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
227 
228     /**
229      * @dev Initializes the contract setting the deployer as the initial owner.
230      */
231     constructor() {
232         _setOwner(_msgSender());
233     }
234 
235     /**
236      * @dev Returns the address of the current owner.
237      */
238     function owner() public view virtual returns (address) {
239         return _owner;
240     }
241 
242     /**
243      * @dev Throws if called by any account other than the owner.
244      */
245     modifier onlyOwner() {
246         require(owner() == _msgSender(), "Ownable: caller is not the owner");
247         _;
248     }
249 
250     /**
251      * @dev Leaves the contract without owner. It will not be possible to call
252      * `onlyOwner` functions anymore. Can only be called by the current owner.
253      *
254      * NOTE: Renouncing ownership will leave the contract without an owner,
255      * thereby removing any functionality that is only available to the owner.
256      */
257     function renounceOwnership() public virtual onlyOwner {
258         _setOwner(address(0));
259     }
260 
261     /**
262      * @dev Transfers ownership of the contract to a new account (`newOwner`).
263      * Can only be called by the current owner.
264      */
265     function transferOwnership(address newOwner) public virtual onlyOwner {
266         require(newOwner != address(0), "Ownable: new owner is the zero address");
267         _setOwner(newOwner);
268     }
269 
270     function _setOwner(address newOwner) private {
271         address oldOwner = _owner;
272         _owner = newOwner;
273         emit OwnershipTransferred(oldOwner, newOwner);
274     }
275 }
276 
277 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
278 
279 
280 
281 pragma solidity ^0.8.0;
282 
283 /**
284  * @dev Interface of the ERC165 standard, as defined in the
285  * https://eips.ethereum.org/EIPS/eip-165[EIP].
286  *
287  * Implementers can declare support of contract interfaces, which can then be
288  * queried by others ({ERC165Checker}).
289  *
290  * For an implementation, see {ERC165}.
291  */
292 interface IERC165 {
293     /**
294      * @dev Returns true if this contract implements the interface defined by
295      * `interfaceId`. See the corresponding
296      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
297      * to learn more about how these ids are created.
298      *
299      * This function call must use less than 30 000 gas.
300      */
301     function supportsInterface(bytes4 interfaceId) external view returns (bool);
302 }
303 
304 
305 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
306 
307 
308 
309 pragma solidity ^0.8.0;
310 
311 
312 /**
313  * @dev Required interface of an ERC721 compliant contract.
314  */
315 interface IERC721 is IERC165 {
316     /**
317      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
318      */
319     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
320 
321     /**
322      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
323      */
324     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
325 
326     /**
327      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
328      */
329     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
330 
331     /**
332      * @dev Returns the number of tokens in ``owner``'s account.
333      */
334     function balanceOf(address owner) external view returns (uint256 balance);
335 
336     /**
337      * @dev Returns the owner of the `tokenId` token.
338      *
339      * Requirements:
340      *
341      * - `tokenId` must exist.
342      */
343     function ownerOf(uint256 tokenId) external view returns (address owner);
344 
345     /**
346      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
347      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
348      *
349      * Requirements:
350      *
351      * - `from` cannot be the zero address.
352      * - `to` cannot be the zero address.
353      * - `tokenId` token must exist and be owned by `from`.
354      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
355      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
356      *
357      * Emits a {Transfer} event.
358      */
359     function safeTransferFrom(
360         address from,
361         address to,
362         uint256 tokenId
363     ) external;
364 
365     /**
366      * @dev Transfers `tokenId` token from `from` to `to`.
367      *
368      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
369      *
370      * Requirements:
371      *
372      * - `from` cannot be the zero address.
373      * - `to` cannot be the zero address.
374      * - `tokenId` token must be owned by `from`.
375      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
376      *
377      * Emits a {Transfer} event.
378      */
379     function transferFrom(
380         address from,
381         address to,
382         uint256 tokenId
383     ) external;
384 
385     /**
386      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
387      * The approval is cleared when the token is transferred.
388      *
389      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
390      *
391      * Requirements:
392      *
393      * - The caller must own the token or be an approved operator.
394      * - `tokenId` must exist.
395      *
396      * Emits an {Approval} event.
397      */
398     function approve(address to, uint256 tokenId) external;
399 
400     /**
401      * @dev Returns the account approved for `tokenId` token.
402      *
403      * Requirements:
404      *
405      * - `tokenId` must exist.
406      */
407     function getApproved(uint256 tokenId) external view returns (address operator);
408 
409     /**
410      * @dev Approve or remove `operator` as an operator for the caller.
411      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
412      *
413      * Requirements:
414      *
415      * - The `operator` cannot be the caller.
416      *
417      * Emits an {ApprovalForAll} event.
418      */
419     function setApprovalForAll(address operator, bool _approved) external;
420 
421     /**
422      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
423      *
424      * See {setApprovalForAll}
425      */
426     function isApprovedForAll(address owner, address operator) external view returns (bool);
427 
428     /**
429      * @dev Safely transfers `tokenId` token from `from` to `to`.
430      *
431      * Requirements:
432      *
433      * - `from` cannot be the zero address.
434      * - `to` cannot be the zero address.
435      * - `tokenId` token must exist and be owned by `from`.
436      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
437      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
438      *
439      * Emits a {Transfer} event.
440      */
441     function safeTransferFrom(
442         address from,
443         address to,
444         uint256 tokenId,
445         bytes calldata data
446     ) external;
447 }
448 
449 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
450 
451 
452 
453 pragma solidity ^0.8.0;
454 
455 
456 /**
457  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
458  * @dev See https://eips.ethereum.org/EIPS/eip-721
459  */
460 interface IERC721Enumerable is IERC721 {
461     /**
462      * @dev Returns the total amount of tokens stored by the contract.
463      */
464     function totalSupply() external view returns (uint256);
465 
466     /**
467      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
468      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
469      */
470     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
471 
472     /**
473      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
474      * Use along with {totalSupply} to enumerate all tokens.
475      */
476     function tokenByIndex(uint256 index) external view returns (uint256);
477 }
478 
479 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
480 
481 
482 
483 pragma solidity ^0.8.0;
484 
485 
486 /**
487  * @dev Implementation of the {IERC165} interface.
488  *
489  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
490  * for the additional interface id that will be supported. For example:
491  *
492  * ```solidity
493  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
494  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
495  * }
496  * ```
497  *
498  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
499  */
500 abstract contract ERC165 is IERC165 {
501     /**
502      * @dev See {IERC165-supportsInterface}.
503      */
504     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
505         return interfaceId == type(IERC165).interfaceId;
506     }
507 }
508 
509 // File: @openzeppelin/contracts/utils/Strings.sol
510 
511 
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @dev String operations.
517  */
518 library Strings {
519     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
520 
521     /**
522      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
523      */
524     function toString(uint256 value) internal pure returns (string memory) {
525         // Inspired by OraclizeAPI's implementation - MIT licence
526         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
527 
528         if (value == 0) {
529             return "0";
530         }
531         uint256 temp = value;
532         uint256 digits;
533         while (temp != 0) {
534             digits++;
535             temp /= 10;
536         }
537         bytes memory buffer = new bytes(digits);
538         while (value != 0) {
539             digits -= 1;
540             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
541             value /= 10;
542         }
543         return string(buffer);
544     }
545 
546     /**
547      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
548      */
549     function toHexString(uint256 value) internal pure returns (string memory) {
550         if (value == 0) {
551             return "0x00";
552         }
553         uint256 temp = value;
554         uint256 length = 0;
555         while (temp != 0) {
556             length++;
557             temp >>= 8;
558         }
559         return toHexString(value, length);
560     }
561 
562     /**
563      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
564      */
565     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
566         bytes memory buffer = new bytes(2 * length + 2);
567         buffer[0] = "0";
568         buffer[1] = "x";
569         for (uint256 i = 2 * length + 1; i > 1; --i) {
570             buffer[i] = _HEX_SYMBOLS[value & 0xf];
571             value >>= 4;
572         }
573         require(value == 0, "Strings: hex length insufficient");
574         return string(buffer);
575     }
576 }
577 
578 
579 // File: @openzeppelin/contracts/utils/Address.sol
580 
581 
582 
583 pragma solidity ^0.8.0;
584 
585 /**
586  * @dev Collection of functions related to the address type
587  */
588 library Address {
589     /**
590      * @dev Returns true if `account` is a contract.
591      *
592      * [IMPORTANT]
593      * ====
594      * It is unsafe to assume that an address for which this function returns
595      * false is an externally-owned account (EOA) and not a contract.
596      *
597      * Among others, `isContract` will return false for the following
598      * types of addresses:
599      *
600      *  - an externally-owned account
601      *  - a contract in construction
602      *  - an address where a contract will be created
603      *  - an address where a contract lived, but was destroyed
604      * ====
605      */
606     function isContract(address account) internal view returns (bool) {
607         // This method relies on extcodesize, which returns 0 for contracts in
608         // construction, since the code is only stored at the end of the
609         // constructor execution.
610 
611         uint256 size;
612         assembly {
613             size := extcodesize(account)
614         }
615         return size > 0;
616     }
617 
618     /**
619      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
620      * `recipient`, forwarding all available gas and reverting on errors.
621      *
622      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
623      * of certain opcodes, possibly making contracts go over the 2300 gas limit
624      * imposed by `transfer`, making them unable to receive funds via
625      * `transfer`. {sendValue} removes this limitation.
626      *
627      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
628      *
629      * IMPORTANT: because control is transferred to `recipient`, care must be
630      * taken to not create reentrancy vulnerabilities. Consider using
631      * {ReentrancyGuard} or the
632      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
633      */
634     function sendValue(address payable recipient, uint256 amount) internal {
635         require(address(this).balance >= amount, "Address: insufficient balance");
636 
637         (bool success, ) = recipient.call{value: amount}("");
638         require(success, "Address: unable to send value, recipient may have reverted");
639     }
640 
641     /**
642      * @dev Performs a Solidity function call using a low level `call`. A
643      * plain `call` is an unsafe replacement for a function call: use this
644      * function instead.
645      *
646      * If `target` reverts with a revert reason, it is bubbled up by this
647      * function (like regular Solidity function calls).
648      *
649      * Returns the raw returned data. To convert to the expected return value,
650      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
651      *
652      * Requirements:
653      *
654      * - `target` must be a contract.
655      * - calling `target` with `data` must not revert.
656      *
657      * _Available since v3.1._
658      */
659     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
660         return functionCall(target, data, "Address: low-level call failed");
661     }
662 
663     /**
664      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
665      * `errorMessage` as a fallback revert reason when `target` reverts.
666      *
667      * _Available since v3.1._
668      */
669     function functionCall(
670         address target,
671         bytes memory data,
672         string memory errorMessage
673     ) internal returns (bytes memory) {
674         return functionCallWithValue(target, data, 0, errorMessage);
675     }
676 
677     /**
678      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
679      * but also transferring `value` wei to `target`.
680      *
681      * Requirements:
682      *
683      * - the calling contract must have an ETH balance of at least `value`.
684      * - the called Solidity function must be `payable`.
685      *
686      * _Available since v3.1._
687      */
688     function functionCallWithValue(
689         address target,
690         bytes memory data,
691         uint256 value
692     ) internal returns (bytes memory) {
693         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
694     }
695 
696     /**
697      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
698      * with `errorMessage` as a fallback revert reason when `target` reverts.
699      *
700      * _Available since v3.1._
701      */
702     function functionCallWithValue(
703         address target,
704         bytes memory data,
705         uint256 value,
706         string memory errorMessage
707     ) internal returns (bytes memory) {
708         require(address(this).balance >= value, "Address: insufficient balance for call");
709         require(isContract(target), "Address: call to non-contract");
710 
711         (bool success, bytes memory returndata) = target.call{value: value}(data);
712         return verifyCallResult(success, returndata, errorMessage);
713     }
714 
715     /**
716      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
717      * but performing a static call.
718      *
719      * _Available since v3.3._
720      */
721     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
722         return functionStaticCall(target, data, "Address: low-level static call failed");
723     }
724 
725     /**
726      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
727      * but performing a static call.
728      *
729      * _Available since v3.3._
730      */
731     function functionStaticCall(
732         address target,
733         bytes memory data,
734         string memory errorMessage
735     ) internal view returns (bytes memory) {
736         require(isContract(target), "Address: static call to non-contract");
737 
738         (bool success, bytes memory returndata) = target.staticcall(data);
739         return verifyCallResult(success, returndata, errorMessage);
740     }
741 
742     /**
743      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
744      * but performing a delegate call.
745      *
746      * _Available since v3.4._
747      */
748     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
749         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
750     }
751 
752     /**
753      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
754      * but performing a delegate call.
755      *
756      * _Available since v3.4._
757      */
758     function functionDelegateCall(
759         address target,
760         bytes memory data,
761         string memory errorMessage
762     ) internal returns (bytes memory) {
763         require(isContract(target), "Address: delegate call to non-contract");
764 
765         (bool success, bytes memory returndata) = target.delegatecall(data);
766         return verifyCallResult(success, returndata, errorMessage);
767     }
768 
769     /**
770      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
771      * revert reason using the provided one.
772      *
773      * _Available since v4.3._
774      */
775     function verifyCallResult(
776         bool success,
777         bytes memory returndata,
778         string memory errorMessage
779     ) internal pure returns (bytes memory) {
780         if (success) {
781             return returndata;
782         } else {
783             // Look for revert reason and bubble it up if present
784             if (returndata.length > 0) {
785                 // The easiest way to bubble the revert reason is using memory via assembly
786 
787                 assembly {
788                     let returndata_size := mload(returndata)
789                     revert(add(32, returndata), returndata_size)
790                 }
791             } else {
792                 revert(errorMessage);
793             }
794         }
795     }
796 }
797 
798 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
799 
800 
801 
802 pragma solidity ^0.8.0;
803 
804 
805 /**
806  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
807  * @dev See https://eips.ethereum.org/EIPS/eip-721
808  */
809 interface IERC721Metadata is IERC721 {
810     /**
811      * @dev Returns the token collection name.
812      */
813     function name() external view returns (string memory);
814 
815     /**
816      * @dev Returns the token collection symbol.
817      */
818     function symbol() external view returns (string memory);
819 
820     /**
821      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
822      */
823     function tokenURI(uint256 tokenId) external view returns (string memory);
824 }
825 
826 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
827 
828 
829 
830 pragma solidity ^0.8.0;
831 
832 /**
833  * @title ERC721 token receiver interface
834  * @dev Interface for any contract that wants to support safeTransfers
835  * from ERC721 asset contracts.
836  */
837 interface IERC721Receiver {
838     /**
839      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
840      * by `operator` from `from`, this function is called.
841      *
842      * It must return its Solidity selector to confirm the token transfer.
843      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
844      *
845      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
846      */
847     function onERC721Received(
848         address operator,
849         address from,
850         uint256 tokenId,
851         bytes calldata data
852     ) external returns (bytes4);
853 }
854 
855 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
856 
857 
858 
859 pragma solidity ^0.8.0;
860 
861 
862 
863 
864 
865 
866 
867 
868 /**
869  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
870  * the Metadata extension, but not including the Enumerable extension, which is available separately as
871  * {ERC721Enumerable}.
872  */
873 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
874     using Address for address;
875     using Strings for uint256;
876 
877     // Token name
878     string private _name;
879 
880     // Token symbol
881     string private _symbol;
882 
883     // Mapping from token ID to owner address
884     mapping(uint256 => address) private _owners;
885 
886     // Mapping owner address to token count
887     mapping(address => uint256) private _balances;
888 
889     // Mapping from token ID to approved address
890     mapping(uint256 => address) private _tokenApprovals;
891 
892     // Mapping from owner to operator approvals
893     mapping(address => mapping(address => bool)) private _operatorApprovals;
894 
895     /**
896      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
897      */
898     constructor(string memory name_, string memory symbol_) {
899         _name = name_;
900         _symbol = symbol_;
901     }
902 
903     /**
904      * @dev See {IERC165-supportsInterface}.
905      */
906     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
907         return
908             interfaceId == type(IERC721).interfaceId ||
909             interfaceId == type(IERC721Metadata).interfaceId ||
910             super.supportsInterface(interfaceId);
911     }
912 
913     /**
914      * @dev See {IERC721-balanceOf}.
915      */
916     function balanceOf(address owner) public view virtual override returns (uint256) {
917         require(owner != address(0), "ERC721: balance query for the zero address");
918         return _balances[owner];
919     }
920 
921     /**
922      * @dev See {IERC721-ownerOf}.
923      */
924     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
925         address owner = _owners[tokenId];
926         require(owner != address(0), "ERC721: owner query for nonexistent token");
927         return owner;
928     }
929 
930     /**
931      * @dev See {IERC721Metadata-name}.
932      */
933     function name() public view virtual override returns (string memory) {
934         return _name;
935     }
936 
937     /**
938      * @dev See {IERC721Metadata-symbol}.
939      */
940     function symbol() public view virtual override returns (string memory) {
941         return _symbol;
942     }
943 
944     /**
945      * @dev See {IERC721Metadata-tokenURI}.
946      */
947     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
948         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
949 
950         string memory baseURI = _baseURI();
951         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
952     }
953 
954     /**
955      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
956      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
957      * by default, can be overriden in child contracts.
958      */
959     function _baseURI() internal view virtual returns (string memory) {
960         return "";
961     }
962 
963     /**
964      * @dev See {IERC721-approve}.
965      */
966     function approve(address to, uint256 tokenId) public virtual override {
967         address owner = ERC721.ownerOf(tokenId);
968         require(to != owner, "ERC721: approval to current owner");
969 
970         require(
971             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
972             "ERC721: approve caller is not owner nor approved for all"
973         );
974 
975         _approve(to, tokenId);
976     }
977 
978     /**
979      * @dev See {IERC721-getApproved}.
980      */
981     function getApproved(uint256 tokenId) public view virtual override returns (address) {
982         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
983 
984         return _tokenApprovals[tokenId];
985     }
986 
987     /**
988      * @dev See {IERC721-setApprovalForAll}.
989      */
990     function setApprovalForAll(address operator, bool approved) public virtual override {
991         require(operator != _msgSender(), "ERC721: approve to caller");
992 
993         _operatorApprovals[_msgSender()][operator] = approved;
994         emit ApprovalForAll(_msgSender(), operator, approved);
995     }
996 
997     /**
998      * @dev See {IERC721-isApprovedForAll}.
999      */
1000     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1001         return _operatorApprovals[owner][operator];
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-transferFrom}.
1006      */
1007     function transferFrom(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) public virtual override {
1012         //solhint-disable-next-line max-line-length
1013         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1014 
1015         _transfer(from, to, tokenId);
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-safeTransferFrom}.
1020      */
1021     function safeTransferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) public virtual override {
1026         safeTransferFrom(from, to, tokenId, "");
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-safeTransferFrom}.
1031      */
1032     function safeTransferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId,
1036         bytes memory _data
1037     ) public virtual override {
1038         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1039         _safeTransfer(from, to, tokenId, _data);
1040     }
1041 
1042     /**
1043      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1044      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1045      *
1046      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1047      *
1048      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1049      * implement alternative mechanisms to perform token transfer, such as signature-based.
1050      *
1051      * Requirements:
1052      *
1053      * - `from` cannot be the zero address.
1054      * - `to` cannot be the zero address.
1055      * - `tokenId` token must exist and be owned by `from`.
1056      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function _safeTransfer(
1061         address from,
1062         address to,
1063         uint256 tokenId,
1064         bytes memory _data
1065     ) internal virtual {
1066         _transfer(from, to, tokenId);
1067         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1068     }
1069 
1070     /**
1071      * @dev Returns whether `tokenId` exists.
1072      *
1073      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1074      *
1075      * Tokens start existing when they are minted (`_mint`),
1076      * and stop existing when they are burned (`_burn`).
1077      */
1078     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1079         return _owners[tokenId] != address(0);
1080     }
1081 
1082     /**
1083      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1084      *
1085      * Requirements:
1086      *
1087      * - `tokenId` must exist.
1088      */
1089     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1090         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1091         address owner = ERC721.ownerOf(tokenId);
1092         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1093     }
1094 
1095     /**
1096      * @dev Safely mints `tokenId` and transfers it to `to`.
1097      *
1098      * Requirements:
1099      *
1100      * - `tokenId` must not exist.
1101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function _safeMint(address to, uint256 tokenId) internal virtual {
1106         _safeMint(to, tokenId, "");
1107     }
1108 
1109     /**
1110      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1111      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1112      */
1113     function _safeMint(
1114         address to,
1115         uint256 tokenId,
1116         bytes memory _data
1117     ) internal virtual {
1118         _mint(to, tokenId);
1119         require(
1120             _checkOnERC721Received(address(0), to, tokenId, _data),
1121             "ERC721: transfer to non ERC721Receiver implementer"
1122         );
1123     }
1124 
1125     /**
1126      * @dev Mints `tokenId` and transfers it to `to`.
1127      *
1128      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1129      *
1130      * Requirements:
1131      *
1132      * - `tokenId` must not exist.
1133      * - `to` cannot be the zero address.
1134      *
1135      * Emits a {Transfer} event.
1136      */
1137     function _mint(address to, uint256 tokenId) internal virtual {
1138         require(to != address(0), "ERC721: mint to the zero address");
1139         require(!_exists(tokenId), "ERC721: token already minted");
1140 
1141         _beforeTokenTransfer(address(0), to, tokenId);
1142 
1143         _balances[to] += 1;
1144         _owners[tokenId] = to;
1145 
1146         emit Transfer(address(0), to, tokenId);
1147     }
1148 
1149     /**
1150      * @dev Destroys `tokenId`.
1151      * The approval is cleared when the token is burned.
1152      *
1153      * Requirements:
1154      *
1155      * - `tokenId` must exist.
1156      *
1157      * Emits a {Transfer} event.
1158      */
1159     function _burn(uint256 tokenId) internal virtual {
1160         address owner = ERC721.ownerOf(tokenId);
1161 
1162         _beforeTokenTransfer(owner, address(0), tokenId);
1163 
1164         // Clear approvals
1165         _approve(address(0), tokenId);
1166 
1167         _balances[owner] -= 1;
1168         delete _owners[tokenId];
1169 
1170         emit Transfer(owner, address(0), tokenId);
1171     }
1172 
1173     /**
1174      * @dev Transfers `tokenId` from `from` to `to`.
1175      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1176      *
1177      * Requirements:
1178      *
1179      * - `to` cannot be the zero address.
1180      * - `tokenId` token must be owned by `from`.
1181      *
1182      * Emits a {Transfer} event.
1183      */
1184     function _transfer(
1185         address from,
1186         address to,
1187         uint256 tokenId
1188     ) internal virtual {
1189         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1190         require(to != address(0), "ERC721: transfer to the zero address");
1191 
1192         _beforeTokenTransfer(from, to, tokenId);
1193 
1194         // Clear approvals from the previous owner
1195         _approve(address(0), tokenId);
1196 
1197         _balances[from] -= 1;
1198         _balances[to] += 1;
1199         _owners[tokenId] = to;
1200 
1201         emit Transfer(from, to, tokenId);
1202     }
1203 
1204     /**
1205      * @dev Approve `to` to operate on `tokenId`
1206      *
1207      * Emits a {Approval} event.
1208      */
1209     function _approve(address to, uint256 tokenId) internal virtual {
1210         _tokenApprovals[tokenId] = to;
1211         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1212     }
1213 
1214     /**
1215      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1216      * The call is not executed if the target address is not a contract.
1217      *
1218      * @param from address representing the previous owner of the given token ID
1219      * @param to target address that will receive the tokens
1220      * @param tokenId uint256 ID of the token to be transferred
1221      * @param _data bytes optional data to send along with the call
1222      * @return bool whether the call correctly returned the expected magic value
1223      */
1224     function _checkOnERC721Received(
1225         address from,
1226         address to,
1227         uint256 tokenId,
1228         bytes memory _data
1229     ) private returns (bool) {
1230         if (to.isContract()) {
1231             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1232                 return retval == IERC721Receiver.onERC721Received.selector;
1233             } catch (bytes memory reason) {
1234                 if (reason.length == 0) {
1235                     revert("ERC721: transfer to non ERC721Receiver implementer");
1236                 } else {
1237                     assembly {
1238                         revert(add(32, reason), mload(reason))
1239                     }
1240                 }
1241             }
1242         } else {
1243             return true;
1244         }
1245     }
1246 
1247     /**
1248      * @dev Hook that is called before any token transfer. This includes minting
1249      * and burning.
1250      *
1251      * Calling conditions:
1252      *
1253      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1254      * transferred to `to`.
1255      * - When `from` is zero, `tokenId` will be minted for `to`.
1256      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1257      * - `from` and `to` are never both zero.
1258      *
1259      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1260      */
1261     function _beforeTokenTransfer(
1262         address from,
1263         address to,
1264         uint256 tokenId
1265     ) internal virtual {}
1266 }
1267 
1268 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1269 
1270 
1271 
1272 pragma solidity ^0.8.0;
1273 
1274 
1275 
1276 /**
1277  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1278  * enumerability of all the token ids in the contract as well as all token ids owned by each
1279  * account.
1280  */
1281 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1282     // Mapping from owner to list of owned token IDs
1283     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1284 
1285     // Mapping from token ID to index of the owner tokens list
1286     mapping(uint256 => uint256) private _ownedTokensIndex;
1287 
1288     // Array with all token ids, used for enumeration
1289     uint256[] private _allTokens;
1290 
1291     // Mapping from token id to position in the allTokens array
1292     mapping(uint256 => uint256) private _allTokensIndex;
1293 
1294     /**
1295      * @dev See {IERC165-supportsInterface}.
1296      */
1297     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1298         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1299     }
1300 
1301     /**
1302      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1303      */
1304     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1305         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1306         return _ownedTokens[owner][index];
1307     }
1308 
1309     /**
1310      * @dev See {IERC721Enumerable-totalSupply}.
1311      */
1312     function totalSupply() public view virtual override returns (uint256) {
1313         return _allTokens.length;
1314     }
1315 
1316     /**
1317      * @dev See {IERC721Enumerable-tokenByIndex}.
1318      */
1319     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1320         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1321         return _allTokens[index];
1322     }
1323 
1324     /**
1325      * @dev Hook that is called before any token transfer. This includes minting
1326      * and burning.
1327      *
1328      * Calling conditions:
1329      *
1330      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1331      * transferred to `to`.
1332      * - When `from` is zero, `tokenId` will be minted for `to`.
1333      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1334      * - `from` cannot be the zero address.
1335      * - `to` cannot be the zero address.
1336      *
1337      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1338      */
1339     function _beforeTokenTransfer(
1340         address from,
1341         address to,
1342         uint256 tokenId
1343     ) internal virtual override {
1344         super._beforeTokenTransfer(from, to, tokenId);
1345 
1346         if (from == address(0)) {
1347             _addTokenToAllTokensEnumeration(tokenId);
1348         } else if (from != to) {
1349             _removeTokenFromOwnerEnumeration(from, tokenId);
1350         }
1351         if (to == address(0)) {
1352             _removeTokenFromAllTokensEnumeration(tokenId);
1353         } else if (to != from) {
1354             _addTokenToOwnerEnumeration(to, tokenId);
1355         }
1356     }
1357 
1358     /**
1359      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1360      * @param to address representing the new owner of the given token ID
1361      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1362      */
1363     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1364         uint256 length = ERC721.balanceOf(to);
1365         _ownedTokens[to][length] = tokenId;
1366         _ownedTokensIndex[tokenId] = length;
1367     }
1368 
1369     /**
1370      * @dev Private function to add a token to this extension's token tracking data structures.
1371      * @param tokenId uint256 ID of the token to be added to the tokens list
1372      */
1373     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1374         _allTokensIndex[tokenId] = _allTokens.length;
1375         _allTokens.push(tokenId);
1376     }
1377 
1378     /**
1379      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1380      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1381      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1382      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1383      * @param from address representing the previous owner of the given token ID
1384      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1385      */
1386     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1387         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1388         // then delete the last slot (swap and pop).
1389 
1390         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1391         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1392 
1393         // When the token to delete is the last token, the swap operation is unnecessary
1394         if (tokenIndex != lastTokenIndex) {
1395             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1396 
1397             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1398             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1399         }
1400 
1401         // This also deletes the contents at the last position of the array
1402         delete _ownedTokensIndex[tokenId];
1403         delete _ownedTokens[from][lastTokenIndex];
1404     }
1405 
1406     /**
1407      * @dev Private function to remove a token from this extension's token tracking data structures.
1408      * This has O(1) time complexity, but alters the order of the _allTokens array.
1409      * @param tokenId uint256 ID of the token to be removed from the tokens list
1410      */
1411     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1412         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1413         // then delete the last slot (swap and pop).
1414 
1415         uint256 lastTokenIndex = _allTokens.length - 1;
1416         uint256 tokenIndex = _allTokensIndex[tokenId];
1417 
1418         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1419         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1420         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1421         uint256 lastTokenId = _allTokens[lastTokenIndex];
1422 
1423         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1424         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1425 
1426         // This also deletes the contents at the last position of the array
1427         delete _allTokensIndex[tokenId];
1428         _allTokens.pop();
1429     }
1430 }
1431 
1432 // File: contracts/Les_Non_Fongible_Femmes.sol
1433 
1434 // (づ｡◕‿‿◕｡)づ
1435 
1436 // Les Non Fongible Femmes is a series of hand-painted female portraits from NonFungible Lady.
1437 // Only 500 Les Non Fongible Femmes portraits will exist.
1438 // Mint cost 0.03 eth per Femme, max 10 femmes per transaction, please mint directly from contract on Etherscan.
1439 
1440 //SPDX-License-Identifier: MIT
1441 
1442 contract Les_Non_Fongible_Femmes is ERC721Enumerable, Ownable, RandomlyAssigned {
1443   using Strings for uint256;
1444   
1445   string public baseExtension = ".json";
1446   uint256 public cost = 0.03 ether;
1447   uint256 public maxFEMME = 500;
1448   uint256 public maxMintAmount = 10;
1449   bool public paused = false;
1450   
1451   string public baseURI = "https://ipfs.io/ipfs/QmVVGLmHfbQjpmPrk95qv7DtrBJ8ZfDVMv1iws7RJHhLCp/";
1452 
1453   constructor(
1454   ) ERC721("Les Non Fongible Femmes", "Femme")
1455   RandomlyAssigned(500, 1) {}
1456 
1457   // internal
1458   function _baseURI() internal view virtual override returns (string memory) {
1459     return baseURI;
1460   }
1461 
1462   // public
1463   function mint(uint256 _mintAmount) public payable {
1464     require(!paused);
1465     require(_mintAmount > 0);
1466     require(_mintAmount <= maxMintAmount);
1467     require(totalSupply() + _mintAmount <= maxFEMME);
1468     require(msg.value >= cost * _mintAmount);
1469 
1470     for (uint256 i = 1; i <= _mintAmount; i++) {
1471         uint256 mintIndex = nextToken();
1472      if (totalSupply() < maxFEMME) {
1473                 _safeMint(_msgSender(), mintIndex);
1474     }
1475    }
1476   }
1477 
1478   function walletOfOwner(address _owner)
1479     public
1480     view
1481     returns (uint256[] memory)
1482   {
1483     uint256 ownerTokenCount = balanceOf(_owner);
1484     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1485     for (uint256 i; i < ownerTokenCount; i++) {
1486       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1487     }
1488     return tokenIds;
1489   }
1490 
1491   function tokenURI(uint256 tokenId)
1492     public
1493     view
1494     virtual
1495     override
1496     returns (string memory)
1497   {
1498     require(
1499       _exists(tokenId),
1500       "ERC721Metadata: URI query for nonexistent token"
1501     );
1502 
1503     string memory currentBaseURI = _baseURI();
1504     return bytes(currentBaseURI).length > 0
1505         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1506         : "";
1507   }
1508 
1509   //only owner
1510 
1511   function withdraw() public payable onlyOwner {
1512     require(payable(msg.sender).send(address(this).balance));
1513   }
1514 }