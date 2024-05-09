1 // Pumpametti, the genesis art project by artist Pumpametti, paying homage to artist Alberto Giacometti, documenting the cryptoniano culture.
2 // Inside Pumpametti there will be very rare Aperioni, Zombioni, and Alienori.
3 // Cost 0.01 ETH per Pumpametti mint, max 10 per transaction, mint directly from contract. 
4 // There'll only be 300 Pumpamettis, each a piece of 1/1 art. 
5 
6 // File: @openzeppelin/contracts/utils/Counters.sol
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @title Counters
12  * @author Matt Condon (@shrugs)
13  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
14  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
15  *
16  * Include with `using Counters for Counters.Counter;`
17  */
18 library Counters {
19     struct Counter {
20         // This variable should never be directly accessed by users of the library: interactions must be restricted to
21         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
22         // this feature: see https://github.com/ethereum/solidity/issues/4637
23         uint256 _value; // default: 0
24     }
25 
26     function current(Counter storage counter) internal view returns (uint256) {
27         return counter._value;
28     }
29 
30     function increment(Counter storage counter) internal {
31         unchecked {
32             counter._value += 1;
33         }
34     }
35 
36     function decrement(Counter storage counter) internal {
37         uint256 value = counter._value;
38         require(value > 0, "Counter: decrement overflow");
39         unchecked {
40             counter._value = value - 1;
41         }
42     }
43 
44     function reset(Counter storage counter) internal {
45         counter._value = 0;
46     }
47 }
48 
49 // File: contracts/WithLimitedSupply.sol
50 
51 
52 pragma solidity ^0.8.0;
53 
54 
55 /// @author 1001.digital 
56 /// @title A token tracker that limits the token supply and increments token IDs on each new mint.
57 abstract contract WithLimitedSupply {
58     using Counters for Counters.Counter;
59 
60     // Keeps track of how many we have minted
61     Counters.Counter private _tokenCount;
62 
63     /// @dev The maximum count of tokens this token tracker will hold.
64     uint256 private _maxSupply;
65 
66     /// Instanciate the contract
67     /// @param totalSupply_ how many tokens this collection should hold
68     constructor (uint256 totalSupply_) {
69         _maxSupply = totalSupply_;
70     }
71 
72     /// @dev Get the max Supply
73     /// @return the maximum token count
74     function maxSupply() public view returns (uint256) {
75         return _maxSupply;
76     }
77 
78     /// @dev Get the current token count
79     /// @return the created token count
80     function tokenCount() public view returns (uint256) {
81         return _tokenCount.current();
82     }
83 
84     /// @dev Check whether tokens are still available
85     /// @return the available token count
86     function availableTokenCount() public view returns (uint256) {
87         return maxSupply() - tokenCount();
88     }
89 
90     /// @dev Increment the token count and fetch the latest count
91     /// @return the next token id
92     function nextToken() internal virtual ensureAvailability returns (uint256) {
93         uint256 token = _tokenCount.current();
94 
95         _tokenCount.increment();
96 
97         return token;
98     }
99 
100     /// @dev Check whether another token is still available
101     modifier ensureAvailability() {
102         require(availableTokenCount() > 0, "No more tokens available");
103         _;
104     }
105 
106     /// @param amount Check whether number of tokens are still available
107     /// @dev Check whether tokens are still available
108     modifier ensureAvailabilityFor(uint256 amount) {
109         require(availableTokenCount() >= amount, "Requested number of tokens not available");
110         _;
111     }
112 }
113 // File: contracts/RandomlyAssigned.sol
114 
115 
116 pragma solidity ^0.8.0;
117 
118 
119 /// @author 1001.digital
120 /// @title Randomly assign tokenIDs from a given set of tokens.
121 abstract contract RandomlyAssigned is WithLimitedSupply {
122     // Used for random index assignment
123     mapping(uint256 => uint256) private tokenMatrix;
124 
125     // The initial token ID
126     uint256 private startFrom;
127 
128     /// Instanciate the contract
129     /// @param _maxSupply how many tokens this collection should hold
130     /// @param _startFrom the tokenID with which to start counting
131     constructor (uint256 _maxSupply, uint256 _startFrom)
132         WithLimitedSupply(_maxSupply)
133     {
134         startFrom = _startFrom;
135     }
136 
137     /// Get the next token ID
138     /// @dev Randomly gets a new token ID and keeps track of the ones that are still available.
139     /// @return the next token ID
140     function nextToken() internal override ensureAvailability returns (uint256) {
141         uint256 maxIndex = maxSupply() - tokenCount();
142         uint256 random = uint256(keccak256(
143             abi.encodePacked(
144                 msg.sender,
145                 block.coinbase,
146                 block.difficulty,
147                 block.gaslimit,
148                 block.timestamp
149             )
150         )) % maxIndex;
151 
152         uint256 value = 0;
153         if (tokenMatrix[random] == 0) {
154             // If this matrix position is empty, set the value to the generated random number.
155             value = random;
156         } else {
157             // Otherwise, use the previously stored number from the matrix.
158             value = tokenMatrix[random];
159         }
160 
161         // If the last available tokenID is still unused...
162         if (tokenMatrix[maxIndex - 1] == 0) {
163             // ...store that ID in the current matrix position.
164             tokenMatrix[random] = maxIndex - 1;
165         } else {
166             // ...otherwise copy over the stored number to the current matrix position.
167             tokenMatrix[random] = tokenMatrix[maxIndex - 1];
168         }
169 
170         // Increment counts
171         super.nextToken();
172 
173         return value + startFrom;
174     }
175 }
176 
177 // File: @openzeppelin/contracts/utils/Context.sol
178 
179 
180 
181 pragma solidity ^0.8.0;
182 
183 /**
184  * @dev Provides information about the current execution context, including the
185  * sender of the transaction and its data. While these are generally available
186  * via msg.sender and msg.data, they should not be accessed in such a direct
187  * manner, since when dealing with meta-transactions the account sending and
188  * paying for execution may not be the actual sender (as far as an application
189  * is concerned).
190  *
191  * This contract is only required for intermediate, library-like contracts.
192  */
193 abstract contract Context {
194     function _msgSender() internal view virtual returns (address) {
195         return msg.sender;
196     }
197 
198     function _msgData() internal view virtual returns (bytes calldata) {
199         return msg.data;
200     }
201 }
202 
203 // File: @openzeppelin/contracts/access/Ownable.sol
204 
205 
206 
207 pragma solidity ^0.8.0;
208 
209 
210 /**
211  * @dev Contract module which provides a basic access control mechanism, where
212  * there is an account (an owner) that can be granted exclusive access to
213  * specific functions.
214  *
215  * By default, the owner account will be the one that deploys the contract. This
216  * can later be changed with {transferOwnership}.
217  *
218  * This module is used through inheritance. It will make available the modifier
219  * `onlyOwner`, which can be applied to your functions to restrict their use to
220  * the owner.
221  */
222 abstract contract Ownable is Context {
223     address private _owner;
224 
225     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
226 
227     /**
228      * @dev Initializes the contract setting the deployer as the initial owner.
229      */
230     constructor() {
231         _setOwner(_msgSender());
232     }
233 
234     /**
235      * @dev Returns the address of the current owner.
236      */
237     function owner() public view virtual returns (address) {
238         return _owner;
239     }
240 
241     /**
242      * @dev Throws if called by any account other than the owner.
243      */
244     modifier onlyOwner() {
245         require(owner() == _msgSender(), "Ownable: caller is not the owner");
246         _;
247     }
248 
249     /**
250      * @dev Leaves the contract without owner. It will not be possible to call
251      * `onlyOwner` functions anymore. Can only be called by the current owner.
252      *
253      * NOTE: Renouncing ownership will leave the contract without an owner,
254      * thereby removing any functionality that is only available to the owner.
255      */
256     function renounceOwnership() public virtual onlyOwner {
257         _setOwner(address(0));
258     }
259 
260     /**
261      * @dev Transfers ownership of the contract to a new account (`newOwner`).
262      * Can only be called by the current owner.
263      */
264     function transferOwnership(address newOwner) public virtual onlyOwner {
265         require(newOwner != address(0), "Ownable: new owner is the zero address");
266         _setOwner(newOwner);
267     }
268 
269     function _setOwner(address newOwner) private {
270         address oldOwner = _owner;
271         _owner = newOwner;
272         emit OwnershipTransferred(oldOwner, newOwner);
273     }
274 }
275 
276 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
277 
278 
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @dev Interface of the ERC165 standard, as defined in the
284  * https://eips.ethereum.org/EIPS/eip-165[EIP].
285  *
286  * Implementers can declare support of contract interfaces, which can then be
287  * queried by others ({ERC165Checker}).
288  *
289  * For an implementation, see {ERC165}.
290  */
291 interface IERC165 {
292     /**
293      * @dev Returns true if this contract implements the interface defined by
294      * `interfaceId`. See the corresponding
295      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
296      * to learn more about how these ids are created.
297      *
298      * This function call must use less than 30 000 gas.
299      */
300     function supportsInterface(bytes4 interfaceId) external view returns (bool);
301 }
302 
303 
304 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
305 
306 
307 
308 pragma solidity ^0.8.0;
309 
310 
311 /**
312  * @dev Required interface of an ERC721 compliant contract.
313  */
314 interface IERC721 is IERC165 {
315     /**
316      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
317      */
318     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
319 
320     /**
321      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
322      */
323     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
324 
325     /**
326      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
327      */
328     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
329 
330     /**
331      * @dev Returns the number of tokens in ``owner``'s account.
332      */
333     function balanceOf(address owner) external view returns (uint256 balance);
334 
335     /**
336      * @dev Returns the owner of the `tokenId` token.
337      *
338      * Requirements:
339      *
340      * - `tokenId` must exist.
341      */
342     function ownerOf(uint256 tokenId) external view returns (address owner);
343 
344     /**
345      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
346      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
347      *
348      * Requirements:
349      *
350      * - `from` cannot be the zero address.
351      * - `to` cannot be the zero address.
352      * - `tokenId` token must exist and be owned by `from`.
353      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
354      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
355      *
356      * Emits a {Transfer} event.
357      */
358     function safeTransferFrom(
359         address from,
360         address to,
361         uint256 tokenId
362     ) external;
363 
364     /**
365      * @dev Transfers `tokenId` token from `from` to `to`.
366      *
367      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
368      *
369      * Requirements:
370      *
371      * - `from` cannot be the zero address.
372      * - `to` cannot be the zero address.
373      * - `tokenId` token must be owned by `from`.
374      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
375      *
376      * Emits a {Transfer} event.
377      */
378     function transferFrom(
379         address from,
380         address to,
381         uint256 tokenId
382     ) external;
383 
384     /**
385      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
386      * The approval is cleared when the token is transferred.
387      *
388      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
389      *
390      * Requirements:
391      *
392      * - The caller must own the token or be an approved operator.
393      * - `tokenId` must exist.
394      *
395      * Emits an {Approval} event.
396      */
397     function approve(address to, uint256 tokenId) external;
398 
399     /**
400      * @dev Returns the account approved for `tokenId` token.
401      *
402      * Requirements:
403      *
404      * - `tokenId` must exist.
405      */
406     function getApproved(uint256 tokenId) external view returns (address operator);
407 
408     /**
409      * @dev Approve or remove `operator` as an operator for the caller.
410      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
411      *
412      * Requirements:
413      *
414      * - The `operator` cannot be the caller.
415      *
416      * Emits an {ApprovalForAll} event.
417      */
418     function setApprovalForAll(address operator, bool _approved) external;
419 
420     /**
421      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
422      *
423      * See {setApprovalForAll}
424      */
425     function isApprovedForAll(address owner, address operator) external view returns (bool);
426 
427     /**
428      * @dev Safely transfers `tokenId` token from `from` to `to`.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must exist and be owned by `from`.
435      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
436      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
437      *
438      * Emits a {Transfer} event.
439      */
440     function safeTransferFrom(
441         address from,
442         address to,
443         uint256 tokenId,
444         bytes calldata data
445     ) external;
446 }
447 
448 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
449 
450 
451 
452 pragma solidity ^0.8.0;
453 
454 
455 /**
456  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
457  * @dev See https://eips.ethereum.org/EIPS/eip-721
458  */
459 interface IERC721Enumerable is IERC721 {
460     /**
461      * @dev Returns the total amount of tokens stored by the contract.
462      */
463     function totalSupply() external view returns (uint256);
464 
465     /**
466      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
467      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
468      */
469     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
470 
471     /**
472      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
473      * Use along with {totalSupply} to enumerate all tokens.
474      */
475     function tokenByIndex(uint256 index) external view returns (uint256);
476 }
477 
478 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
479 
480 
481 
482 pragma solidity ^0.8.0;
483 
484 
485 /**
486  * @dev Implementation of the {IERC165} interface.
487  *
488  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
489  * for the additional interface id that will be supported. For example:
490  *
491  * ```solidity
492  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
493  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
494  * }
495  * ```
496  *
497  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
498  */
499 abstract contract ERC165 is IERC165 {
500     /**
501      * @dev See {IERC165-supportsInterface}.
502      */
503     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
504         return interfaceId == type(IERC165).interfaceId;
505     }
506 }
507 
508 // File: @openzeppelin/contracts/utils/Strings.sol
509 
510 
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @dev String operations.
516  */
517 library Strings {
518     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
519 
520     /**
521      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
522      */
523     function toString(uint256 value) internal pure returns (string memory) {
524         // Inspired by OraclizeAPI's implementation - MIT licence
525         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
526 
527         if (value == 0) {
528             return "0";
529         }
530         uint256 temp = value;
531         uint256 digits;
532         while (temp != 0) {
533             digits++;
534             temp /= 10;
535         }
536         bytes memory buffer = new bytes(digits);
537         while (value != 0) {
538             digits -= 1;
539             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
540             value /= 10;
541         }
542         return string(buffer);
543     }
544 
545     /**
546      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
547      */
548     function toHexString(uint256 value) internal pure returns (string memory) {
549         if (value == 0) {
550             return "0x00";
551         }
552         uint256 temp = value;
553         uint256 length = 0;
554         while (temp != 0) {
555             length++;
556             temp >>= 8;
557         }
558         return toHexString(value, length);
559     }
560 
561     /**
562      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
563      */
564     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
565         bytes memory buffer = new bytes(2 * length + 2);
566         buffer[0] = "0";
567         buffer[1] = "x";
568         for (uint256 i = 2 * length + 1; i > 1; --i) {
569             buffer[i] = _HEX_SYMBOLS[value & 0xf];
570             value >>= 4;
571         }
572         require(value == 0, "Strings: hex length insufficient");
573         return string(buffer);
574     }
575 }
576 
577 // File: @openzeppelin/contracts/utils/Address.sol
578 
579 
580 
581 pragma solidity ^0.8.0;
582 
583 /**
584  * @dev Collection of functions related to the address type
585  */
586 library Address {
587     /**
588      * @dev Returns true if `account` is a contract.
589      *
590      * [IMPORTANT]
591      * ====
592      * It is unsafe to assume that an address for which this function returns
593      * false is an externally-owned account (EOA) and not a contract.
594      *
595      * Among others, `isContract` will return false for the following
596      * types of addresses:
597      *
598      *  - an externally-owned account
599      *  - a contract in construction
600      *  - an address where a contract will be created
601      *  - an address where a contract lived, but was destroyed
602      * ====
603      */
604     function isContract(address account) internal view returns (bool) {
605         // This method relies on extcodesize, which returns 0 for contracts in
606         // construction, since the code is only stored at the end of the
607         // constructor execution.
608 
609         uint256 size;
610         assembly {
611             size := extcodesize(account)
612         }
613         return size > 0;
614     }
615 
616     /**
617      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
618      * `recipient`, forwarding all available gas and reverting on errors.
619      *
620      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
621      * of certain opcodes, possibly making contracts go over the 2300 gas limit
622      * imposed by `transfer`, making them unable to receive funds via
623      * `transfer`. {sendValue} removes this limitation.
624      *
625      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
626      *
627      * IMPORTANT: because control is transferred to `recipient`, care must be
628      * taken to not create reentrancy vulnerabilities. Consider using
629      * {ReentrancyGuard} or the
630      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
631      */
632     function sendValue(address payable recipient, uint256 amount) internal {
633         require(address(this).balance >= amount, "Address: insufficient balance");
634 
635         (bool success, ) = recipient.call{value: amount}("");
636         require(success, "Address: unable to send value, recipient may have reverted");
637     }
638 
639     /**
640      * @dev Performs a Solidity function call using a low level `call`. A
641      * plain `call` is an unsafe replacement for a function call: use this
642      * function instead.
643      *
644      * If `target` reverts with a revert reason, it is bubbled up by this
645      * function (like regular Solidity function calls).
646      *
647      * Returns the raw returned data. To convert to the expected return value,
648      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
649      *
650      * Requirements:
651      *
652      * - `target` must be a contract.
653      * - calling `target` with `data` must not revert.
654      *
655      * _Available since v3.1._
656      */
657     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
658         return functionCall(target, data, "Address: low-level call failed");
659     }
660 
661     /**
662      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
663      * `errorMessage` as a fallback revert reason when `target` reverts.
664      *
665      * _Available since v3.1._
666      */
667     function functionCall(
668         address target,
669         bytes memory data,
670         string memory errorMessage
671     ) internal returns (bytes memory) {
672         return functionCallWithValue(target, data, 0, errorMessage);
673     }
674 
675     /**
676      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
677      * but also transferring `value` wei to `target`.
678      *
679      * Requirements:
680      *
681      * - the calling contract must have an ETH balance of at least `value`.
682      * - the called Solidity function must be `payable`.
683      *
684      * _Available since v3.1._
685      */
686     function functionCallWithValue(
687         address target,
688         bytes memory data,
689         uint256 value
690     ) internal returns (bytes memory) {
691         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
692     }
693 
694     /**
695      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
696      * with `errorMessage` as a fallback revert reason when `target` reverts.
697      *
698      * _Available since v3.1._
699      */
700     function functionCallWithValue(
701         address target,
702         bytes memory data,
703         uint256 value,
704         string memory errorMessage
705     ) internal returns (bytes memory) {
706         require(address(this).balance >= value, "Address: insufficient balance for call");
707         require(isContract(target), "Address: call to non-contract");
708 
709         (bool success, bytes memory returndata) = target.call{value: value}(data);
710         return verifyCallResult(success, returndata, errorMessage);
711     }
712 
713     /**
714      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
715      * but performing a static call.
716      *
717      * _Available since v3.3._
718      */
719     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
720         return functionStaticCall(target, data, "Address: low-level static call failed");
721     }
722 
723     /**
724      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
725      * but performing a static call.
726      *
727      * _Available since v3.3._
728      */
729     function functionStaticCall(
730         address target,
731         bytes memory data,
732         string memory errorMessage
733     ) internal view returns (bytes memory) {
734         require(isContract(target), "Address: static call to non-contract");
735 
736         (bool success, bytes memory returndata) = target.staticcall(data);
737         return verifyCallResult(success, returndata, errorMessage);
738     }
739 
740     /**
741      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
742      * but performing a delegate call.
743      *
744      * _Available since v3.4._
745      */
746     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
747         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
748     }
749 
750     /**
751      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
752      * but performing a delegate call.
753      *
754      * _Available since v3.4._
755      */
756     function functionDelegateCall(
757         address target,
758         bytes memory data,
759         string memory errorMessage
760     ) internal returns (bytes memory) {
761         require(isContract(target), "Address: delegate call to non-contract");
762 
763         (bool success, bytes memory returndata) = target.delegatecall(data);
764         return verifyCallResult(success, returndata, errorMessage);
765     }
766 
767     /**
768      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
769      * revert reason using the provided one.
770      *
771      * _Available since v4.3._
772      */
773     function verifyCallResult(
774         bool success,
775         bytes memory returndata,
776         string memory errorMessage
777     ) internal pure returns (bytes memory) {
778         if (success) {
779             return returndata;
780         } else {
781             // Look for revert reason and bubble it up if present
782             if (returndata.length > 0) {
783                 // The easiest way to bubble the revert reason is using memory via assembly
784 
785                 assembly {
786                     let returndata_size := mload(returndata)
787                     revert(add(32, returndata), returndata_size)
788                 }
789             } else {
790                 revert(errorMessage);
791             }
792         }
793     }
794 }
795 
796 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
797 
798 
799 
800 pragma solidity ^0.8.0;
801 
802 
803 /**
804  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
805  * @dev See https://eips.ethereum.org/EIPS/eip-721
806  */
807 interface IERC721Metadata is IERC721 {
808     /**
809      * @dev Returns the token collection name.
810      */
811     function name() external view returns (string memory);
812 
813     /**
814      * @dev Returns the token collection symbol.
815      */
816     function symbol() external view returns (string memory);
817 
818     /**
819      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
820      */
821     function tokenURI(uint256 tokenId) external view returns (string memory);
822 }
823 
824 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
825 
826 
827 
828 pragma solidity ^0.8.0;
829 
830 /**
831  * @title ERC721 token receiver interface
832  * @dev Interface for any contract that wants to support safeTransfers
833  * from ERC721 asset contracts.
834  */
835 interface IERC721Receiver {
836     /**
837      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
838      * by `operator` from `from`, this function is called.
839      *
840      * It must return its Solidity selector to confirm the token transfer.
841      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
842      *
843      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
844      */
845     function onERC721Received(
846         address operator,
847         address from,
848         uint256 tokenId,
849         bytes calldata data
850     ) external returns (bytes4);
851 }
852 
853 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
854 
855 
856 
857 pragma solidity ^0.8.0;
858 
859 
860 
861 
862 
863 
864 
865 
866 /**
867  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
868  * the Metadata extension, but not including the Enumerable extension, which is available separately as
869  * {ERC721Enumerable}.
870  */
871 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
872     using Address for address;
873     using Strings for uint256;
874 
875     // Token name
876     string private _name;
877 
878     // Token symbol
879     string private _symbol;
880 
881     // Mapping from token ID to owner address
882     mapping(uint256 => address) private _owners;
883 
884     // Mapping owner address to token count
885     mapping(address => uint256) private _balances;
886 
887     // Mapping from token ID to approved address
888     mapping(uint256 => address) private _tokenApprovals;
889 
890     // Mapping from owner to operator approvals
891     mapping(address => mapping(address => bool)) private _operatorApprovals;
892 
893     /**
894      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
895      */
896     constructor(string memory name_, string memory symbol_) {
897         _name = name_;
898         _symbol = symbol_;
899     }
900 
901     /**
902      * @dev See {IERC165-supportsInterface}.
903      */
904     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
905         return
906             interfaceId == type(IERC721).interfaceId ||
907             interfaceId == type(IERC721Metadata).interfaceId ||
908             super.supportsInterface(interfaceId);
909     }
910 
911     /**
912      * @dev See {IERC721-balanceOf}.
913      */
914     function balanceOf(address owner) public view virtual override returns (uint256) {
915         require(owner != address(0), "ERC721: balance query for the zero address");
916         return _balances[owner];
917     }
918 
919     /**
920      * @dev See {IERC721-ownerOf}.
921      */
922     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
923         address owner = _owners[tokenId];
924         require(owner != address(0), "ERC721: owner query for nonexistent token");
925         return owner;
926     }
927 
928     /**
929      * @dev See {IERC721Metadata-name}.
930      */
931     function name() public view virtual override returns (string memory) {
932         return _name;
933     }
934 
935     /**
936      * @dev See {IERC721Metadata-symbol}.
937      */
938     function symbol() public view virtual override returns (string memory) {
939         return _symbol;
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-tokenURI}.
944      */
945     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
946         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
947 
948         string memory baseURI = _baseURI();
949         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
950     }
951 
952     /**
953      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
954      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
955      * by default, can be overriden in child contracts.
956      */
957     function _baseURI() internal view virtual returns (string memory) {
958         return "";
959     }
960 
961     /**
962      * @dev See {IERC721-approve}.
963      */
964     function approve(address to, uint256 tokenId) public virtual override {
965         address owner = ERC721.ownerOf(tokenId);
966         require(to != owner, "ERC721: approval to current owner");
967 
968         require(
969             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
970             "ERC721: approve caller is not owner nor approved for all"
971         );
972 
973         _approve(to, tokenId);
974     }
975 
976     /**
977      * @dev See {IERC721-getApproved}.
978      */
979     function getApproved(uint256 tokenId) public view virtual override returns (address) {
980         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
981 
982         return _tokenApprovals[tokenId];
983     }
984 
985     /**
986      * @dev See {IERC721-setApprovalForAll}.
987      */
988     function setApprovalForAll(address operator, bool approved) public virtual override {
989         require(operator != _msgSender(), "ERC721: approve to caller");
990 
991         _operatorApprovals[_msgSender()][operator] = approved;
992         emit ApprovalForAll(_msgSender(), operator, approved);
993     }
994 
995     /**
996      * @dev See {IERC721-isApprovedForAll}.
997      */
998     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
999         return _operatorApprovals[owner][operator];
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-transferFrom}.
1004      */
1005     function transferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) public virtual override {
1010         //solhint-disable-next-line max-line-length
1011         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1012 
1013         _transfer(from, to, tokenId);
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-safeTransferFrom}.
1018      */
1019     function safeTransferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) public virtual override {
1024         safeTransferFrom(from, to, tokenId, "");
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-safeTransferFrom}.
1029      */
1030     function safeTransferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId,
1034         bytes memory _data
1035     ) public virtual override {
1036         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1037         _safeTransfer(from, to, tokenId, _data);
1038     }
1039 
1040     /**
1041      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1042      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1043      *
1044      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1045      *
1046      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1047      * implement alternative mechanisms to perform token transfer, such as signature-based.
1048      *
1049      * Requirements:
1050      *
1051      * - `from` cannot be the zero address.
1052      * - `to` cannot be the zero address.
1053      * - `tokenId` token must exist and be owned by `from`.
1054      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1055      *
1056      * Emits a {Transfer} event.
1057      */
1058     function _safeTransfer(
1059         address from,
1060         address to,
1061         uint256 tokenId,
1062         bytes memory _data
1063     ) internal virtual {
1064         _transfer(from, to, tokenId);
1065         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1066     }
1067 
1068     /**
1069      * @dev Returns whether `tokenId` exists.
1070      *
1071      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1072      *
1073      * Tokens start existing when they are minted (`_mint`),
1074      * and stop existing when they are burned (`_burn`).
1075      */
1076     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1077         return _owners[tokenId] != address(0);
1078     }
1079 
1080     /**
1081      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1082      *
1083      * Requirements:
1084      *
1085      * - `tokenId` must exist.
1086      */
1087     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1088         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1089         address owner = ERC721.ownerOf(tokenId);
1090         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1091     }
1092 
1093     /**
1094      * @dev Safely mints `tokenId` and transfers it to `to`.
1095      *
1096      * Requirements:
1097      *
1098      * - `tokenId` must not exist.
1099      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1100      *
1101      * Emits a {Transfer} event.
1102      */
1103     function _safeMint(address to, uint256 tokenId) internal virtual {
1104         _safeMint(to, tokenId, "");
1105     }
1106 
1107     /**
1108      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1109      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1110      */
1111     function _safeMint(
1112         address to,
1113         uint256 tokenId,
1114         bytes memory _data
1115     ) internal virtual {
1116         _mint(to, tokenId);
1117         require(
1118             _checkOnERC721Received(address(0), to, tokenId, _data),
1119             "ERC721: transfer to non ERC721Receiver implementer"
1120         );
1121     }
1122 
1123     /**
1124      * @dev Mints `tokenId` and transfers it to `to`.
1125      *
1126      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1127      *
1128      * Requirements:
1129      *
1130      * - `tokenId` must not exist.
1131      * - `to` cannot be the zero address.
1132      *
1133      * Emits a {Transfer} event.
1134      */
1135     function _mint(address to, uint256 tokenId) internal virtual {
1136         require(to != address(0), "ERC721: mint to the zero address");
1137         require(!_exists(tokenId), "ERC721: token already minted");
1138 
1139         _beforeTokenTransfer(address(0), to, tokenId);
1140 
1141         _balances[to] += 1;
1142         _owners[tokenId] = to;
1143 
1144         emit Transfer(address(0), to, tokenId);
1145     }
1146 
1147     /**
1148      * @dev Destroys `tokenId`.
1149      * The approval is cleared when the token is burned.
1150      *
1151      * Requirements:
1152      *
1153      * - `tokenId` must exist.
1154      *
1155      * Emits a {Transfer} event.
1156      */
1157     function _burn(uint256 tokenId) internal virtual {
1158         address owner = ERC721.ownerOf(tokenId);
1159 
1160         _beforeTokenTransfer(owner, address(0), tokenId);
1161 
1162         // Clear approvals
1163         _approve(address(0), tokenId);
1164 
1165         _balances[owner] -= 1;
1166         delete _owners[tokenId];
1167 
1168         emit Transfer(owner, address(0), tokenId);
1169     }
1170 
1171     /**
1172      * @dev Transfers `tokenId` from `from` to `to`.
1173      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1174      *
1175      * Requirements:
1176      *
1177      * - `to` cannot be the zero address.
1178      * - `tokenId` token must be owned by `from`.
1179      *
1180      * Emits a {Transfer} event.
1181      */
1182     function _transfer(
1183         address from,
1184         address to,
1185         uint256 tokenId
1186     ) internal virtual {
1187         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1188         require(to != address(0), "ERC721: transfer to the zero address");
1189 
1190         _beforeTokenTransfer(from, to, tokenId);
1191 
1192         // Clear approvals from the previous owner
1193         _approve(address(0), tokenId);
1194 
1195         _balances[from] -= 1;
1196         _balances[to] += 1;
1197         _owners[tokenId] = to;
1198 
1199         emit Transfer(from, to, tokenId);
1200     }
1201 
1202     /**
1203      * @dev Approve `to` to operate on `tokenId`
1204      *
1205      * Emits a {Approval} event.
1206      */
1207     function _approve(address to, uint256 tokenId) internal virtual {
1208         _tokenApprovals[tokenId] = to;
1209         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1210     }
1211 
1212     /**
1213      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1214      * The call is not executed if the target address is not a contract.
1215      *
1216      * @param from address representing the previous owner of the given token ID
1217      * @param to target address that will receive the tokens
1218      * @param tokenId uint256 ID of the token to be transferred
1219      * @param _data bytes optional data to send along with the call
1220      * @return bool whether the call correctly returned the expected magic value
1221      */
1222     function _checkOnERC721Received(
1223         address from,
1224         address to,
1225         uint256 tokenId,
1226         bytes memory _data
1227     ) private returns (bool) {
1228         if (to.isContract()) {
1229             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1230                 return retval == IERC721Receiver.onERC721Received.selector;
1231             } catch (bytes memory reason) {
1232                 if (reason.length == 0) {
1233                     revert("ERC721: transfer to non ERC721Receiver implementer");
1234                 } else {
1235                     assembly {
1236                         revert(add(32, reason), mload(reason))
1237                     }
1238                 }
1239             }
1240         } else {
1241             return true;
1242         }
1243     }
1244 
1245     /**
1246      * @dev Hook that is called before any token transfer. This includes minting
1247      * and burning.
1248      *
1249      * Calling conditions:
1250      *
1251      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1252      * transferred to `to`.
1253      * - When `from` is zero, `tokenId` will be minted for `to`.
1254      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1255      * - `from` and `to` are never both zero.
1256      *
1257      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1258      */
1259     function _beforeTokenTransfer(
1260         address from,
1261         address to,
1262         uint256 tokenId
1263     ) internal virtual {}
1264 }
1265 
1266 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1267 
1268 
1269 
1270 pragma solidity ^0.8.0;
1271 
1272 
1273 
1274 /**
1275  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1276  * enumerability of all the token ids in the contract as well as all token ids owned by each
1277  * account.
1278  */
1279 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1280     // Mapping from owner to list of owned token IDs
1281     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1282 
1283     // Mapping from token ID to index of the owner tokens list
1284     mapping(uint256 => uint256) private _ownedTokensIndex;
1285 
1286     // Array with all token ids, used for enumeration
1287     uint256[] private _allTokens;
1288 
1289     // Mapping from token id to position in the allTokens array
1290     mapping(uint256 => uint256) private _allTokensIndex;
1291 
1292     /**
1293      * @dev See {IERC165-supportsInterface}.
1294      */
1295     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1296         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1297     }
1298 
1299     /**
1300      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1301      */
1302     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1303         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1304         return _ownedTokens[owner][index];
1305     }
1306 
1307     /**
1308      * @dev See {IERC721Enumerable-totalSupply}.
1309      */
1310     function totalSupply() public view virtual override returns (uint256) {
1311         return _allTokens.length;
1312     }
1313 
1314     /**
1315      * @dev See {IERC721Enumerable-tokenByIndex}.
1316      */
1317     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1318         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1319         return _allTokens[index];
1320     }
1321 
1322     /**
1323      * @dev Hook that is called before any token transfer. This includes minting
1324      * and burning.
1325      *
1326      * Calling conditions:
1327      *
1328      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1329      * transferred to `to`.
1330      * - When `from` is zero, `tokenId` will be minted for `to`.
1331      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1332      * - `from` cannot be the zero address.
1333      * - `to` cannot be the zero address.
1334      *
1335      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1336      */
1337     function _beforeTokenTransfer(
1338         address from,
1339         address to,
1340         uint256 tokenId
1341     ) internal virtual override {
1342         super._beforeTokenTransfer(from, to, tokenId);
1343 
1344         if (from == address(0)) {
1345             _addTokenToAllTokensEnumeration(tokenId);
1346         } else if (from != to) {
1347             _removeTokenFromOwnerEnumeration(from, tokenId);
1348         }
1349         if (to == address(0)) {
1350             _removeTokenFromAllTokensEnumeration(tokenId);
1351         } else if (to != from) {
1352             _addTokenToOwnerEnumeration(to, tokenId);
1353         }
1354     }
1355 
1356     /**
1357      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1358      * @param to address representing the new owner of the given token ID
1359      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1360      */
1361     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1362         uint256 length = ERC721.balanceOf(to);
1363         _ownedTokens[to][length] = tokenId;
1364         _ownedTokensIndex[tokenId] = length;
1365     }
1366 
1367     /**
1368      * @dev Private function to add a token to this extension's token tracking data structures.
1369      * @param tokenId uint256 ID of the token to be added to the tokens list
1370      */
1371     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1372         _allTokensIndex[tokenId] = _allTokens.length;
1373         _allTokens.push(tokenId);
1374     }
1375 
1376     /**
1377      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1378      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1379      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1380      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1381      * @param from address representing the previous owner of the given token ID
1382      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1383      */
1384     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1385         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1386         // then delete the last slot (swap and pop).
1387 
1388         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1389         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1390 
1391         // When the token to delete is the last token, the swap operation is unnecessary
1392         if (tokenIndex != lastTokenIndex) {
1393             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1394 
1395             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1396             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1397         }
1398 
1399         // This also deletes the contents at the last position of the array
1400         delete _ownedTokensIndex[tokenId];
1401         delete _ownedTokens[from][lastTokenIndex];
1402     }
1403 
1404     /**
1405      * @dev Private function to remove a token from this extension's token tracking data structures.
1406      * This has O(1) time complexity, but alters the order of the _allTokens array.
1407      * @param tokenId uint256 ID of the token to be removed from the tokens list
1408      */
1409     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1410         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1411         // then delete the last slot (swap and pop).
1412 
1413         uint256 lastTokenIndex = _allTokens.length - 1;
1414         uint256 tokenIndex = _allTokensIndex[tokenId];
1415 
1416         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1417         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1418         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1419         uint256 lastTokenId = _allTokens[lastTokenIndex];
1420 
1421         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1422         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1423 
1424         // This also deletes the contents at the last position of the array
1425         delete _allTokensIndex[tokenId];
1426         _allTokens.pop();
1427     }
1428 }
1429 
1430 // File: contracts/Pumpametti.sol
1431 
1432 //SPDX-License-Identifier: MIT
1433 
1434 // Pumpametti, the genesis art project by artist Pumpametti, paying homage to artist Alberto Giacometti, documenting the cryptoniano culture.
1435 // Inside Pumpametti there will be very rare Aperioni, Zombioni, and Alienori.
1436 // Cost 0.01 ETH per Pumpametti mint, max 10 per transaction, mint directly from contract. 
1437 // There'll only be 300 Pumpamettis, each a piece of 1/1 art. 
1438 
1439 pragma solidity ^0.8.0;
1440 
1441 contract Pumpametti is ERC721Enumerable, Ownable, RandomlyAssigned {
1442   using Strings for uint256;
1443   
1444   string public baseExtension = ".json";
1445   uint256 public cost = 0.01 ether;
1446   uint256 public maxXIA = 300;
1447   uint256 public maxMintAmount = 10;
1448   bool public paused = false;
1449   
1450   string public baseURI = "https://ipfs.io/ipfs/QmUCG1oLBMs9WFSvv3bwTJ3Rs3citJvH6wpT2xpSEM9GT7/";
1451 
1452   constructor(
1453   ) ERC721("Pumpametti", "Metti")
1454   RandomlyAssigned(300, 1) {}
1455 
1456   // internal
1457   function _baseURI() internal view virtual override returns (string memory) {
1458     return baseURI;
1459   }
1460 
1461   // public
1462   function mint(uint256 _mintAmount) public payable {
1463     require(!paused);
1464     require(_mintAmount > 0);
1465     require(_mintAmount <= maxMintAmount);
1466     require(totalSupply() + _mintAmount <= maxXIA);
1467     require(msg.value >= cost * _mintAmount);
1468 
1469     for (uint256 i = 1; i <= _mintAmount; i++) {
1470         uint256 mintIndex = nextToken();
1471      if (totalSupply() < maxXIA) {
1472                 _safeMint(_msgSender(), mintIndex);
1473     }
1474    }
1475   }
1476 
1477   function walletOfOwner(address _owner)
1478     public
1479     view
1480     returns (uint256[] memory)
1481   {
1482     uint256 ownerTokenCount = balanceOf(_owner);
1483     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1484     for (uint256 i; i < ownerTokenCount; i++) {
1485       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1486     }
1487     return tokenIds;
1488   }
1489 
1490   function tokenURI(uint256 tokenId)
1491     public
1492     view
1493     virtual
1494     override
1495     returns (string memory)
1496   {
1497     require(
1498       _exists(tokenId),
1499       "ERC721Metadata: URI query for nonexistent token"
1500     );
1501 
1502     string memory currentBaseURI = _baseURI();
1503     return bytes(currentBaseURI).length > 0
1504         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1505         : "";
1506   }
1507 
1508   //only owner
1509 
1510   function withdraw() public payable onlyOwner {
1511     require(payable(msg.sender).send(address(this).balance));
1512   }
1513 }