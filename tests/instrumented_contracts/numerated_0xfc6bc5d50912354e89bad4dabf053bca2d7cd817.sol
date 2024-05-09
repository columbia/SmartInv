1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-25
3 */
4 
5 // File: @openzeppelin/contracts/utils/Counters.sol
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @title Counters
11  * @author Matt Condon (@shrugs)
12  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
13  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
14  *
15  * Include with `using Counters for Counters.Counter;`
16  */
17 library Counters {
18     struct Counter {
19         // This variable should never be directly accessed by users of the library: interactions must be restricted to
20         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
21         // this feature: see https://github.com/ethereum/solidity/issues/4637
22         uint256 _value; // default: 0
23     }
24 
25     function current(Counter storage counter) internal view returns (uint256) {
26         return counter._value;
27     }
28 
29     function increment(Counter storage counter) internal {
30         unchecked {
31             counter._value += 1;
32         }
33     }
34 
35     function decrement(Counter storage counter) internal {
36         uint256 value = counter._value;
37         require(value > 0, "Counter: decrement overflow");
38         unchecked {
39             counter._value = value - 1;
40         }
41     }
42 
43     function reset(Counter storage counter) internal {
44         counter._value = 0;
45     }
46 }
47 
48 // File: contracts/WithLimitedSupply.sol
49 
50 
51 pragma solidity ^0.8.0;
52 
53 
54 /// @author 1001.digital 
55 /// @title A token tracker that limits the token supply and increments token IDs on each new mint.
56 abstract contract WithLimitedSupply {
57     using Counters for Counters.Counter;
58 
59     // Keeps track of how many we have minted
60     Counters.Counter private _tokenCount;
61 
62     /// @dev The maximum count of tokens this token tracker will hold.
63     uint256 private _maxSupply;
64 
65     /// Instanciate the contract
66     /// @param totalSupply_ how many tokens this collection should hold
67     constructor (uint256 totalSupply_) {
68         _maxSupply = totalSupply_;
69     }
70 
71     /// @dev Get the max Supply
72     /// @return the maximum token count
73     function maxSupply() public view returns (uint256) {
74         return _maxSupply;
75     }
76 
77     /// @dev Get the current token count
78     /// @return the created token count
79     function tokenCount() public view returns (uint256) {
80         return _tokenCount.current();
81     }
82 
83     /// @dev Check whether tokens are still available
84     /// @return the available token count
85     function availableTokenCount() public view returns (uint256) {
86         return maxSupply() - tokenCount();
87     }
88 
89     /// @dev Increment the token count and fetch the latest count
90     /// @return the next token id
91     function nextToken() internal virtual ensureAvailability returns (uint256) {
92         uint256 token = _tokenCount.current();
93 
94         _tokenCount.increment();
95 
96         return token;
97     }
98 
99     /// @dev Check whether another token is still available
100     modifier ensureAvailability() {
101         require(availableTokenCount() > 0, "No more tokens available");
102         _;
103     }
104 
105     /// @param amount Check whether number of tokens are still available
106     /// @dev Check whether tokens are still available
107     modifier ensureAvailabilityFor(uint256 amount) {
108         require(availableTokenCount() >= amount, "Requested number of tokens not available");
109         _;
110     }
111 }
112 // File: contracts/RandomlyAssigned.sol
113 
114 
115 pragma solidity ^0.8.0;
116 
117 
118 /// @author 1001.digital
119 /// @title Randomly assign tokenIDs from a given set of tokens.
120 abstract contract RandomlyAssigned is WithLimitedSupply {
121     // Used for random index assignment
122     mapping(uint256 => uint256) private tokenMatrix;
123 
124     // The initial token ID
125     uint256 private startFrom;
126 
127     /// Instanciate the contract
128     /// @param _maxSupply how many tokens this collection should hold
129     /// @param _startFrom the tokenID with which to start counting
130     constructor (uint256 _maxSupply, uint256 _startFrom)
131         WithLimitedSupply(_maxSupply)
132     {
133         startFrom = _startFrom;
134     }
135 
136     /// Get the next token ID
137     /// @dev Randomly gets a new token ID and keeps track of the ones that are still available.
138     /// @return the next token ID
139     function nextToken() internal override ensureAvailability returns (uint256) {
140         uint256 maxIndex = maxSupply() - tokenCount();
141         uint256 random = uint256(keccak256(
142             abi.encodePacked(
143                 msg.sender,
144                 block.coinbase,
145                 block.difficulty,
146                 block.gaslimit,
147                 block.timestamp
148             )
149         )) % maxIndex;
150 
151         uint256 value = 0;
152         if (tokenMatrix[random] == 0) {
153             // If this matrix position is empty, set the value to the generated random number.
154             value = random;
155         } else {
156             // Otherwise, use the previously stored number from the matrix.
157             value = tokenMatrix[random];
158         }
159 
160         // If the last available tokenID is still unused...
161         if (tokenMatrix[maxIndex - 1] == 0) {
162             // ...store that ID in the current matrix position.
163             tokenMatrix[random] = maxIndex - 1;
164         } else {
165             // ...otherwise copy over the stored number to the current matrix position.
166             tokenMatrix[random] = tokenMatrix[maxIndex - 1];
167         }
168 
169         // Increment counts
170         super.nextToken();
171 
172         return value + startFrom;
173     }
174 }
175 
176 // File: @openzeppelin/contracts/utils/Context.sol
177 
178 
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @dev Provides information about the current execution context, including the
184  * sender of the transaction and its data. While these are generally available
185  * via msg.sender and msg.data, they should not be accessed in such a direct
186  * manner, since when dealing with meta-transactions the account sending and
187  * paying for execution may not be the actual sender (as far as an application
188  * is concerned).
189  *
190  * This contract is only required for intermediate, library-like contracts.
191  */
192 abstract contract Context {
193     function _msgSender() internal view virtual returns (address) {
194         return msg.sender;
195     }
196 
197     function _msgData() internal view virtual returns (bytes calldata) {
198         return msg.data;
199     }
200 }
201 
202 // File: @openzeppelin/contracts/access/Ownable.sol
203 
204 
205 
206 pragma solidity ^0.8.0;
207 
208 
209 /**
210  * @dev Contract module which provides a basic access control mechanism, where
211  * there is an account (an owner) that can be granted exclusive access to
212  * specific functions.
213  *
214  * By default, the owner account will be the one that deploys the contract. This
215  * can later be changed with {transferOwnership}.
216  *
217  * This module is used through inheritance. It will make available the modifier
218  * `onlyOwner`, which can be applied to your functions to restrict their use to
219  * the owner.
220  */
221 abstract contract Ownable is Context {
222     address private _owner;
223 
224     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225 
226     /**
227      * @dev Initializes the contract setting the deployer as the initial owner.
228      */
229     constructor() {
230         _setOwner(_msgSender());
231     }
232 
233     /**
234      * @dev Returns the address of the current owner.
235      */
236     function owner() public view virtual returns (address) {
237         return _owner;
238     }
239 
240     /**
241      * @dev Throws if called by any account other than the owner.
242      */
243     modifier onlyOwner() {
244         require(owner() == _msgSender(), "Ownable: caller is not the owner");
245         _;
246     }
247 
248     /**
249      * @dev Leaves the contract without owner. It will not be possible to call
250      * `onlyOwner` functions anymore. Can only be called by the current owner.
251      *
252      * NOTE: Renouncing ownership will leave the contract without an owner,
253      * thereby removing any functionality that is only available to the owner.
254      */
255     function renounceOwnership() public virtual onlyOwner {
256         _setOwner(address(0));
257     }
258 
259     /**
260      * @dev Transfers ownership of the contract to a new account (`newOwner`).
261      * Can only be called by the current owner.
262      */
263     function transferOwnership(address newOwner) public virtual onlyOwner {
264         require(newOwner != address(0), "Ownable: new owner is the zero address");
265         _setOwner(newOwner);
266     }
267 
268     function _setOwner(address newOwner) private {
269         address oldOwner = _owner;
270         _owner = newOwner;
271         emit OwnershipTransferred(oldOwner, newOwner);
272     }
273 }
274 
275 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
276 
277 
278 
279 pragma solidity ^0.8.0;
280 
281 /**
282  * @dev Interface of the ERC165 standard, as defined in the
283  * https://eips.ethereum.org/EIPS/eip-165[EIP].
284  *
285  * Implementers can declare support of contract interfaces, which can then be
286  * queried by others ({ERC165Checker}).
287  *
288  * For an implementation, see {ERC165}.
289  */
290 interface IERC165 {
291     /**
292      * @dev Returns true if this contract implements the interface defined by
293      * `interfaceId`. See the corresponding
294      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
295      * to learn more about how these ids are created.
296      *
297      * This function call must use less than 30 000 gas.
298      */
299     function supportsInterface(bytes4 interfaceId) external view returns (bool);
300 }
301 
302 
303 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
304 
305 
306 
307 pragma solidity ^0.8.0;
308 
309 
310 /**
311  * @dev Required interface of an ERC721 compliant contract.
312  */
313 interface IERC721 is IERC165 {
314     /**
315      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
316      */
317     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
318 
319     /**
320      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
321      */
322     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
323 
324     /**
325      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
326      */
327     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
328 
329     /**
330      * @dev Returns the number of tokens in ``owner``'s account.
331      */
332     function balanceOf(address owner) external view returns (uint256 balance);
333 
334     /**
335      * @dev Returns the owner of the `tokenId` token.
336      *
337      * Requirements:
338      *
339      * - `tokenId` must exist.
340      */
341     function ownerOf(uint256 tokenId) external view returns (address owner);
342 
343     /**
344      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
345      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
346      *
347      * Requirements:
348      *
349      * - `from` cannot be the zero address.
350      * - `to` cannot be the zero address.
351      * - `tokenId` token must exist and be owned by `from`.
352      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
353      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
354      *
355      * Emits a {Transfer} event.
356      */
357     function safeTransferFrom(
358         address from,
359         address to,
360         uint256 tokenId
361     ) external;
362 
363     /**
364      * @dev Transfers `tokenId` token from `from` to `to`.
365      *
366      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
367      *
368      * Requirements:
369      *
370      * - `from` cannot be the zero address.
371      * - `to` cannot be the zero address.
372      * - `tokenId` token must be owned by `from`.
373      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
374      *
375      * Emits a {Transfer} event.
376      */
377     function transferFrom(
378         address from,
379         address to,
380         uint256 tokenId
381     ) external;
382 
383     /**
384      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
385      * The approval is cleared when the token is transferred.
386      *
387      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
388      *
389      * Requirements:
390      *
391      * - The caller must own the token or be an approved operator.
392      * - `tokenId` must exist.
393      *
394      * Emits an {Approval} event.
395      */
396     function approve(address to, uint256 tokenId) external;
397 
398     /**
399      * @dev Returns the account approved for `tokenId` token.
400      *
401      * Requirements:
402      *
403      * - `tokenId` must exist.
404      */
405     function getApproved(uint256 tokenId) external view returns (address operator);
406 
407     /**
408      * @dev Approve or remove `operator` as an operator for the caller.
409      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
410      *
411      * Requirements:
412      *
413      * - The `operator` cannot be the caller.
414      *
415      * Emits an {ApprovalForAll} event.
416      */
417     function setApprovalForAll(address operator, bool _approved) external;
418 
419     /**
420      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
421      *
422      * See {setApprovalForAll}
423      */
424     function isApprovedForAll(address owner, address operator) external view returns (bool);
425 
426     /**
427      * @dev Safely transfers `tokenId` token from `from` to `to`.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `tokenId` token must exist and be owned by `from`.
434      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
435      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
436      *
437      * Emits a {Transfer} event.
438      */
439     function safeTransferFrom(
440         address from,
441         address to,
442         uint256 tokenId,
443         bytes calldata data
444     ) external;
445 }
446 
447 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
448 
449 
450 
451 pragma solidity ^0.8.0;
452 
453 
454 /**
455  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
456  * @dev See https://eips.ethereum.org/EIPS/eip-721
457  */
458 interface IERC721Enumerable is IERC721 {
459     /**
460      * @dev Returns the total amount of tokens stored by the contract.
461      */
462     function totalSupply() external view returns (uint256);
463 
464     /**
465      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
466      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
467      */
468     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
469 
470     /**
471      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
472      * Use along with {totalSupply} to enumerate all tokens.
473      */
474     function tokenByIndex(uint256 index) external view returns (uint256);
475 }
476 
477 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
478 
479 
480 
481 pragma solidity ^0.8.0;
482 
483 
484 /**
485  * @dev Implementation of the {IERC165} interface.
486  *
487  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
488  * for the additional interface id that will be supported. For example:
489  *
490  * ```solidity
491  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
492  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
493  * }
494  * ```
495  *
496  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
497  */
498 abstract contract ERC165 is IERC165 {
499     /**
500      * @dev See {IERC165-supportsInterface}.
501      */
502     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
503         return interfaceId == type(IERC165).interfaceId;
504     }
505 }
506 
507 // File: @openzeppelin/contracts/utils/Strings.sol
508 
509 
510 
511 pragma solidity ^0.8.0;
512 
513 /**
514  * @dev String operations.
515  */
516 library Strings {
517     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
518 
519     /**
520      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
521      */
522     function toString(uint256 value) internal pure returns (string memory) {
523         // Inspired by OraclizeAPI's implementation - MIT licence
524         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
525 
526         if (value == 0) {
527             return "0";
528         }
529         uint256 temp = value;
530         uint256 digits;
531         while (temp != 0) {
532             digits++;
533             temp /= 10;
534         }
535         bytes memory buffer = new bytes(digits);
536         while (value != 0) {
537             digits -= 1;
538             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
539             value /= 10;
540         }
541         return string(buffer);
542     }
543 
544     /**
545      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
546      */
547     function toHexString(uint256 value) internal pure returns (string memory) {
548         if (value == 0) {
549             return "0x00";
550         }
551         uint256 temp = value;
552         uint256 length = 0;
553         while (temp != 0) {
554             length++;
555             temp >>= 8;
556         }
557         return toHexString(value, length);
558     }
559 
560     /**
561      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
562      */
563     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
564         bytes memory buffer = new bytes(2 * length + 2);
565         buffer[0] = "0";
566         buffer[1] = "x";
567         for (uint256 i = 2 * length + 1; i > 1; --i) {
568             buffer[i] = _HEX_SYMBOLS[value & 0xf];
569             value >>= 4;
570         }
571         require(value == 0, "Strings: hex length insufficient");
572         return string(buffer);
573     }
574 }
575 
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
1430 // File: contracts/Standametti.sol
1431 
1432 //   #####                                                                
1433 //  #     # #####   ##   #    # #####    ##   #    # ###### ##### ##### # 
1434 //  #         #    #  #  ##   # #    #  #  #  ##  ## #        #     #   # 
1435 //   #####    #   #    # # #  # #    # #    # # ## # #####    #     #   # 
1436 //       #   #   ###### #  # # #    # ###### #    # #        #     #   # 
1437 //  #     #   #   #    # #   ## #    # #    # #    # #        #     #   # 
1438 //   #####    #   #    # #    # #####  #    # #    # ######   #     #   # 
1439 
1440 
1441 // Standametti, the second art project by artist Pumpametti, documenting the cryptoniano culture through the artist's unique perspective of contemporary art brut.
1442 // Inside Standametti there will be very rare Aperioni, Zombioni, Ororioni and Alienori.
1443 
1444 // OG 300 Pumpametti holders can mint for free! Go to MettiMint if you have one OG metti or MettiMultiMint if you have more than one OG mettis, 
1445 // simply input your token ID, put 0 at the ether amount and you are good to go! For MettiMultiMint please write your token IDs separated by commas and no spaces,
1446 // for example if you own Metti #1 and Mettti #5, input 1,5 at mettiIds (uint256[]).
1447 
1448 // For the public (or OG metti holders if you want to get more Standamettis) it costs 0.02 ETH per Standametti mint, 
1449 // max 10 per transaction, mint directly from Standametti contract on Etherscan by select "publicmint".
1450 // For how to directly mint from contract go watch a video: https://www.youtube.com/watch?v=GZca6HOcPa0
1451 
1452 // There'll only be 4500 Standamettis, each a piece of 1/1 art. 
1453 
1454                                                                        
1455 
1456 //SPDX-License-Identifier: MIT
1457 
1458 pragma solidity ^0.8.0;
1459 
1460 interface MettiInterface {
1461     function ownerOf(uint256 tokenId) external view returns (address owner);
1462     function balanceOf(address owner) external view returns (uint256 balance);
1463     function tokenOfOwnerByIndex(address owner, uint256 index)
1464         external
1465         view
1466         returns (uint256 tokenId);
1467 }
1468 
1469 contract Standametti is ERC721Enumerable, Ownable, RandomlyAssigned {
1470   using Strings for uint256;
1471   
1472   string public baseExtension = ".json";
1473   uint256 public cost = 0.02 ether;
1474   uint256 public maxMettiSupply = 300;
1475   uint256 public maxPublicSupply = 4200;
1476   uint256 public maxSTANDASupply = 4500;
1477   uint256 public maxMintAmount = 10;
1478   bool public paused = false;
1479   
1480   string public baseURI = "https://ipfs.io/ipfs/QmZd2RwnapYAtETyyhVGTS9d8rDBvRPE3nvr573ed1QMcX/";
1481   
1482     //Allow OG Pumpametti holders to mint for free
1483   
1484   address public MettiAddress = 0x09646c5c1e42ede848A57d6542382C32f2877164;
1485   MettiInterface MettiContract = MettiInterface(MettiAddress);
1486   uint public MettiOwnersSupplyMinted = 0;
1487   uint public publicSupplyMinted = 0;
1488 
1489 
1490   constructor(
1491   ) ERC721("Standametti", "Standa")
1492   RandomlyAssigned(4500, 1) {}
1493 
1494   // internal
1495   function _baseURI() internal view virtual override returns (string memory) {
1496     return baseURI;
1497   }
1498 
1499   function MettiFreeMint(uint mettiId) public payable {
1500         require(mettiId > 0 && mettiId <= 300, "Token ID invalid");
1501         require(MettiContract.ownerOf(mettiId) == msg.sender, "Not the owner of this pumpametti");
1502 
1503         _safeMint(msg.sender, mettiId);
1504     }
1505 
1506     function MettiMultiFreeMint(uint256[] memory mettiIds) public payable {
1507         for (uint256 i = 0; i < mettiIds.length; i++) {
1508             require(MettiContract.ownerOf(mettiIds[i]) == msg.sender, "Not the owner of this pumpametti");
1509             _safeMint(_msgSender(), mettiIds[i]);
1510         }
1511     }
1512   
1513    function publicmint(uint256 _mintAmount) public payable {
1514     require(!paused);
1515     require(_mintAmount > 0);
1516     require(_mintAmount <= maxMintAmount);
1517     require( tx.origin == msg.sender, "CANNOT MINT THROUGH A CUSTOM CONTRACT");
1518     require(totalSupply() + _mintAmount <= maxSTANDASupply);
1519     require(publicSupplyMinted + _mintAmount <= maxPublicSupply, "No more public supply left");
1520     publicSupplyMinted = publicSupplyMinted + _mintAmount;
1521     require(msg.value >= cost * _mintAmount);
1522 
1523     for (uint256 i = 1; i <= _mintAmount; i++) {
1524         uint256 mintIndex = nextToken();
1525      if (totalSupply() < maxSTANDASupply) {
1526                 _safeMint(_msgSender(), mintIndex);
1527     }
1528    }
1529   }
1530 
1531   function walletOfOwner(address _owner)
1532     public
1533     view
1534     returns (uint256[] memory)
1535   {
1536     uint256 ownerTokenCount = balanceOf(_owner);
1537     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1538     for (uint256 i; i < ownerTokenCount; i++) {
1539       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1540     }
1541     return tokenIds;
1542   }
1543 
1544   function tokenURI(uint256 tokenId)
1545     public
1546     view
1547     virtual
1548     override
1549     returns (string memory)
1550   {
1551     require(
1552       _exists(tokenId),
1553       "ERC721Metadata: URI query for nonexistent token"
1554     );
1555 
1556     string memory currentBaseURI = _baseURI();
1557     return bytes(currentBaseURI).length > 0
1558         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1559         : "";
1560   }
1561 
1562   //only owner
1563 
1564   function withdraw() public payable onlyOwner {
1565     require(payable(msg.sender).send(address(this).balance));
1566   }
1567 }