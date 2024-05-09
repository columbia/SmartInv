1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-07
3 */
4 
5 // File: @openzeppelin/contracts/utils/Counters.sol
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: contracts/WithLimitedSupply.sol
48 
49 
50 pragma solidity ^0.8.0;
51 
52 
53 /// @author 1001.digital
54 /// @title A token tracker that limits the token supply and increments token IDs on each new mint.
55 abstract contract WithLimitedSupply {
56     using Counters for Counters.Counter;
57 
58     // Keeps track of how many we have minted
59     Counters.Counter private _tokenCount;
60 
61     /// @dev The maximum count of tokens this token tracker will hold.
62     uint256 private _maxSupply;
63 
64     /// Instanciate the contract
65     /// @param totalSupply_ how many tokens this collection should hold
66     constructor (uint256 totalSupply_) {
67         _maxSupply = totalSupply_;
68     }
69 
70     /// @dev Get the max Supply
71     /// @return the maximum token count
72     function maxSupply() public view returns (uint256) {
73         return _maxSupply;
74     }
75 
76     /// @dev Get the current token count
77     /// @return the created token count
78     function tokenCount() public view returns (uint256) {
79         return _tokenCount.current();
80     }
81 
82     /// @dev Check whether tokens are still available
83     /// @return the available token count
84     function availableTokenCount() public view returns (uint256) {
85         return maxSupply() - tokenCount();
86     }
87 
88     /// @dev Increment the token count and fetch the latest count
89     /// @return the next token id
90     function nextToken() internal virtual ensureAvailability returns (uint256) {
91         uint256 token = _tokenCount.current();
92 
93         _tokenCount.increment();
94 
95         return token;
96     }
97 
98     /// @dev Check whether another token is still available
99     modifier ensureAvailability() {
100         require(availableTokenCount() > 0, "No more tokens available");
101         _;
102     }
103 
104     /// @param amount Check whether number of tokens are still available
105     /// @dev Check whether tokens are still available
106     modifier ensureAvailabilityFor(uint256 amount) {
107         require(availableTokenCount() >= amount, "Requested number of tokens not available");
108         _;
109     }
110 }
111 // File: contracts/RandomlyAssigned.sol
112 
113 
114 pragma solidity ^0.8.0;
115 
116 
117 /// @author 1001.digital
118 /// @title Randomly assign tokenIDs from a given set of tokens.
119 abstract contract RandomlyAssigned is WithLimitedSupply {
120     // Used for random index assignment
121     mapping(uint256 => uint256) private tokenMatrix;
122 
123     // The initial token ID
124     uint256 private startFrom;
125 
126     /// Instanciate the contract
127     /// @param _maxSupply how many tokens this collection should hold
128     /// @param _startFrom the tokenID with which to start counting
129     constructor (uint256 _maxSupply, uint256 _startFrom)
130         WithLimitedSupply(_maxSupply)
131     {
132         startFrom = _startFrom;
133     }
134 
135     /// Get the next token ID
136     /// @dev Randomly gets a new token ID and keeps track of the ones that are still available.
137     /// @return the next token ID
138     function nextToken() internal override ensureAvailability returns (uint256) {
139         uint256 maxIndex = maxSupply() - tokenCount();
140         uint256 random = uint256(keccak256(
141             abi.encodePacked(
142                 msg.sender,
143                 block.coinbase,
144                 block.difficulty,
145                 block.gaslimit,
146                 block.timestamp
147             )
148         )) % maxIndex;
149 
150         uint256 value = 0;
151         if (tokenMatrix[random] == 0) {
152             // If this matrix position is empty, set the value to the generated random number.
153             value = random;
154         } else {
155             // Otherwise, use the previously stored number from the matrix.
156             value = tokenMatrix[random];
157         }
158 
159         // If the last available tokenID is still unused...
160         if (tokenMatrix[maxIndex - 1] == 0) {
161             // ...store that ID in the current matrix position.
162             tokenMatrix[random] = maxIndex - 1;
163         } else {
164             // ...otherwise copy over the stored number to the current matrix position.
165             tokenMatrix[random] = tokenMatrix[maxIndex - 1];
166         }
167 
168         // Increment counts
169         super.nextToken();
170 
171         return value + startFrom;
172     }
173 }
174 
175 // File: @openzeppelin/contracts/utils/Context.sol
176 
177 
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @dev Provides information about the current execution context, including the
183  * sender of the transaction and its data. While these are generally available
184  * via msg.sender and msg.data, they should not be accessed in such a direct
185  * manner, since when dealing with meta-transactions the account sending and
186  * paying for execution may not be the actual sender (as far as an application
187  * is concerned).
188  *
189  * This contract is only required for intermediate, library-like contracts.
190  */
191 abstract contract Context {
192     function _msgSender() internal view virtual returns (address) {
193         return msg.sender;
194     }
195 
196     function _msgData() internal view virtual returns (bytes calldata) {
197         return msg.data;
198     }
199 }
200 
201 // File: @openzeppelin/contracts/access/Ownable.sol
202 
203 
204 
205 pragma solidity ^0.8.0;
206 
207 
208 /**
209  * @dev Contract module which provides a basic access control mechanism, where
210  * there is an account (an owner) that can be granted exclusive access to
211  * specific functions.
212  *
213  * By default, the owner account will be the one that deploys the contract. This
214  * can later be changed with {transferOwnership}.
215  *
216  * This module is used through inheritance. It will make available the modifier
217  * `onlyOwner`, which can be applied to your functions to restrict their use to
218  * the owner.
219  */
220 abstract contract Ownable is Context {
221     address private _owner;
222 
223     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
224 
225     /**
226      * @dev Initializes the contract setting the deployer as the initial owner.
227      */
228     constructor() {
229         _setOwner(_msgSender());
230     }
231 
232     /**
233      * @dev Returns the address of the current owner.
234      */
235     function owner() public view virtual returns (address) {
236         return _owner;
237     }
238 
239     /**
240      * @dev Throws if called by any account other than the owner.
241      */
242     modifier onlyOwner() {
243         require(owner() == _msgSender(), "Ownable: caller is not the owner");
244         _;
245     }
246 
247     /**
248      * @dev Leaves the contract without owner. It will not be possible to call
249      * `onlyOwner` functions anymore. Can only be called by the current owner.
250      *
251      * NOTE: Renouncing ownership will leave the contract without an owner,
252      * thereby removing any functionality that is only available to the owner.
253      */
254     function renounceOwnership() public virtual onlyOwner {
255         _setOwner(address(0));
256     }
257 
258     /**
259      * @dev Transfers ownership of the contract to a new account (`newOwner`).
260      * Can only be called by the current owner.
261      */
262     function transferOwnership(address newOwner) public virtual onlyOwner {
263         require(newOwner != address(0), "Ownable: new owner is the zero address");
264         _setOwner(newOwner);
265     }
266 
267     function _setOwner(address newOwner) private {
268         address oldOwner = _owner;
269         _owner = newOwner;
270         emit OwnershipTransferred(oldOwner, newOwner);
271     }
272 }
273 
274 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
275 
276 
277 
278 pragma solidity ^0.8.0;
279 
280 /**
281  * @dev Interface of the ERC165 standard, as defined in the
282  * https://eips.ethereum.org/EIPS/eip-165[EIP].
283  *
284  * Implementers can declare support of contract interfaces, which can then be
285  * queried by others ({ERC165Checker}).
286  *
287  * For an implementation, see {ERC165}.
288  */
289 interface IERC165 {
290     /**
291      * @dev Returns true if this contract implements the interface defined by
292      * `interfaceId`. See the corresponding
293      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
294      * to learn more about how these ids are created.
295      *
296      * This function call must use less than 30 000 gas.
297      */
298     function supportsInterface(bytes4 interfaceId) external view returns (bool);
299 }
300 
301 
302 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
303 
304 
305 
306 pragma solidity ^0.8.0;
307 
308 
309 /**
310  * @dev Required interface of an ERC721 compliant contract.
311  */
312 interface IERC721 is IERC165 {
313     /**
314      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
315      */
316     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
317 
318     /**
319      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
320      */
321     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
322 
323     /**
324      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
325      */
326     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
327 
328     /**
329      * @dev Returns the number of tokens in ``owner``'s account.
330      */
331     function balanceOf(address owner) external view returns (uint256 balance);
332 
333     /**
334      * @dev Returns the owner of the `tokenId` token.
335      *
336      * Requirements:
337      *
338      * - `tokenId` must exist.
339      */
340     function ownerOf(uint256 tokenId) external view returns (address owner);
341 
342     /**
343      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
344      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
345      *
346      * Requirements:
347      *
348      * - `from` cannot be the zero address.
349      * - `to` cannot be the zero address.
350      * - `tokenId` token must exist and be owned by `from`.
351      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
352      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
353      *
354      * Emits a {Transfer} event.
355      */
356     function safeTransferFrom(
357         address from,
358         address to,
359         uint256 tokenId
360     ) external;
361 
362     /**
363      * @dev Transfers `tokenId` token from `from` to `to`.
364      *
365      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
366      *
367      * Requirements:
368      *
369      * - `from` cannot be the zero address.
370      * - `to` cannot be the zero address.
371      * - `tokenId` token must be owned by `from`.
372      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
373      *
374      * Emits a {Transfer} event.
375      */
376     function transferFrom(
377         address from,
378         address to,
379         uint256 tokenId
380     ) external;
381 
382     /**
383      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
384      * The approval is cleared when the token is transferred.
385      *
386      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
387      *
388      * Requirements:
389      *
390      * - The caller must own the token or be an approved operator.
391      * - `tokenId` must exist.
392      *
393      * Emits an {Approval} event.
394      */
395     function approve(address to, uint256 tokenId) external;
396 
397     /**
398      * @dev Returns the account approved for `tokenId` token.
399      *
400      * Requirements:
401      *
402      * - `tokenId` must exist.
403      */
404     function getApproved(uint256 tokenId) external view returns (address operator);
405 
406     /**
407      * @dev Approve or remove `operator` as an operator for the caller.
408      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
409      *
410      * Requirements:
411      *
412      * - The `operator` cannot be the caller.
413      *
414      * Emits an {ApprovalForAll} event.
415      */
416     function setApprovalForAll(address operator, bool _approved) external;
417 
418     /**
419      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
420      *
421      * See {setApprovalForAll}
422      */
423     function isApprovedForAll(address owner, address operator) external view returns (bool);
424 
425     /**
426      * @dev Safely transfers `tokenId` token from `from` to `to`.
427      *
428      * Requirements:
429      *
430      * - `from` cannot be the zero address.
431      * - `to` cannot be the zero address.
432      * - `tokenId` token must exist and be owned by `from`.
433      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
434      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
435      *
436      * Emits a {Transfer} event.
437      */
438     function safeTransferFrom(
439         address from,
440         address to,
441         uint256 tokenId,
442         bytes calldata data
443     ) external;
444 }
445 
446 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
447 
448 
449 
450 pragma solidity ^0.8.0;
451 
452 
453 /**
454  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
455  * @dev See https://eips.ethereum.org/EIPS/eip-721
456  */
457 interface IERC721Enumerable is IERC721 {
458     /**
459      * @dev Returns the total amount of tokens stored by the contract.
460      */
461     function totalSupply() external view returns (uint256);
462 
463     /**
464      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
465      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
466      */
467     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
468 
469     /**
470      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
471      * Use along with {totalSupply} to enumerate all tokens.
472      */
473     function tokenByIndex(uint256 index) external view returns (uint256);
474 }
475 
476 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
477 
478 
479 
480 pragma solidity ^0.8.0;
481 
482 
483 /**
484  * @dev Implementation of the {IERC165} interface.
485  *
486  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
487  * for the additional interface id that will be supported. For example:
488  *
489  * ```solidity
490  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
491  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
492  * }
493  * ```
494  *
495  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
496  */
497 abstract contract ERC165 is IERC165 {
498     /**
499      * @dev See {IERC165-supportsInterface}.
500      */
501     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
502         return interfaceId == type(IERC165).interfaceId;
503     }
504 }
505 
506 // File: @openzeppelin/contracts/utils/Strings.sol
507 
508 
509 
510 pragma solidity ^0.8.0;
511 
512 /**
513  * @dev String operations.
514  */
515 library Strings {
516     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
517 
518     /**
519      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
520      */
521     function toString(uint256 value) internal pure returns (string memory) {
522         // Inspired by OraclizeAPI's implementation - MIT licence
523         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
524 
525         if (value == 0) {
526             return "0";
527         }
528         uint256 temp = value;
529         uint256 digits;
530         while (temp != 0) {
531             digits++;
532             temp /= 10;
533         }
534         bytes memory buffer = new bytes(digits);
535         while (value != 0) {
536             digits -= 1;
537             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
538             value /= 10;
539         }
540         return string(buffer);
541     }
542 
543     /**
544      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
545      */
546     function toHexString(uint256 value) internal pure returns (string memory) {
547         if (value == 0) {
548             return "0x00";
549         }
550         uint256 temp = value;
551         uint256 length = 0;
552         while (temp != 0) {
553             length++;
554             temp >>= 8;
555         }
556         return toHexString(value, length);
557     }
558 
559     /**
560      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
561      */
562     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
563         bytes memory buffer = new bytes(2 * length + 2);
564         buffer[0] = "0";
565         buffer[1] = "x";
566         for (uint256 i = 2 * length + 1; i > 1; --i) {
567             buffer[i] = _HEX_SYMBOLS[value & 0xf];
568             value >>= 4;
569         }
570         require(value == 0, "Strings: hex length insufficient");
571         return string(buffer);
572     }
573 }
574 
575 // File: @openzeppelin/contracts/utils/Address.sol
576 
577 
578 
579 pragma solidity ^0.8.0;
580 
581 /**
582  * @dev Collection of functions related to the address type
583  */
584 library Address {
585     /**
586      * @dev Returns true if `account` is a contract.
587      *
588      * [IMPORTANT]
589      * ====
590      * It is unsafe to assume that an address for which this function returns
591      * false is an externally-owned account (EOA) and not a contract.
592      *
593      * Among others, `isContract` will return false for the following
594      * types of addresses:
595      *
596      *  - an externally-owned account
597      *  - a contract in construction
598      *  - an address where a contract will be created
599      *  - an address where a contract lived, but was destroyed
600      * ====
601      */
602     function isContract(address account) internal view returns (bool) {
603         // This method relies on extcodesize, which returns 0 for contracts in
604         // construction, since the code is only stored at the end of the
605         // constructor execution.
606 
607         uint256 size;
608         assembly {
609             size := extcodesize(account)
610         }
611         return size > 0;
612     }
613 
614     /**
615      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
616      * `recipient`, forwarding all available gas and reverting on errors.
617      *
618      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
619      * of certain opcodes, possibly making contracts go over the 2300 gas limit
620      * imposed by `transfer`, making them unable to receive funds via
621      * `transfer`. {sendValue} removes this limitation.
622      *
623      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
624      *
625      * IMPORTANT: because control is transferred to `recipient`, care must be
626      * taken to not create reentrancy vulnerabilities. Consider using
627      * {ReentrancyGuard} or the
628      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
629      */
630     function sendValue(address payable recipient, uint256 amount) internal {
631         require(address(this).balance >= amount, "Address: insufficient balance");
632 
633         (bool success, ) = recipient.call{value: amount}("");
634         require(success, "Address: unable to send value, recipient may have reverted");
635     }
636 
637     /**
638      * @dev Performs a Solidity function call using a low level `call`. A
639      * plain `call` is an unsafe replacement for a function call: use this
640      * function instead.
641      *
642      * If `target` reverts with a revert reason, it is bubbled up by this
643      * function (like regular Solidity function calls).
644      *
645      * Returns the raw returned data. To convert to the expected return value,
646      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
647      *
648      * Requirements:
649      *
650      * - `target` must be a contract.
651      * - calling `target` with `data` must not revert.
652      *
653      * _Available since v3.1._
654      */
655     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
656         return functionCall(target, data, "Address: low-level call failed");
657     }
658 
659     /**
660      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
661      * `errorMessage` as a fallback revert reason when `target` reverts.
662      *
663      * _Available since v3.1._
664      */
665     function functionCall(
666         address target,
667         bytes memory data,
668         string memory errorMessage
669     ) internal returns (bytes memory) {
670         return functionCallWithValue(target, data, 0, errorMessage);
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
675      * but also transferring `value` wei to `target`.
676      *
677      * Requirements:
678      *
679      * - the calling contract must have an ETH balance of at least `value`.
680      * - the called Solidity function must be `payable`.
681      *
682      * _Available since v3.1._
683      */
684     function functionCallWithValue(
685         address target,
686         bytes memory data,
687         uint256 value
688     ) internal returns (bytes memory) {
689         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
690     }
691 
692     /**
693      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
694      * with `errorMessage` as a fallback revert reason when `target` reverts.
695      *
696      * _Available since v3.1._
697      */
698     function functionCallWithValue(
699         address target,
700         bytes memory data,
701         uint256 value,
702         string memory errorMessage
703     ) internal returns (bytes memory) {
704         require(address(this).balance >= value, "Address: insufficient balance for call");
705         require(isContract(target), "Address: call to non-contract");
706 
707         (bool success, bytes memory returndata) = target.call{value: value}(data);
708         return verifyCallResult(success, returndata, errorMessage);
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
713      * but performing a static call.
714      *
715      * _Available since v3.3._
716      */
717     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
718         return functionStaticCall(target, data, "Address: low-level static call failed");
719     }
720 
721     /**
722      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
723      * but performing a static call.
724      *
725      * _Available since v3.3._
726      */
727     function functionStaticCall(
728         address target,
729         bytes memory data,
730         string memory errorMessage
731     ) internal view returns (bytes memory) {
732         require(isContract(target), "Address: static call to non-contract");
733 
734         (bool success, bytes memory returndata) = target.staticcall(data);
735         return verifyCallResult(success, returndata, errorMessage);
736     }
737 
738     /**
739      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
740      * but performing a delegate call.
741      *
742      * _Available since v3.4._
743      */
744     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
745         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
746     }
747 
748     /**
749      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
750      * but performing a delegate call.
751      *
752      * _Available since v3.4._
753      */
754     function functionDelegateCall(
755         address target,
756         bytes memory data,
757         string memory errorMessage
758     ) internal returns (bytes memory) {
759         require(isContract(target), "Address: delegate call to non-contract");
760 
761         (bool success, bytes memory returndata) = target.delegatecall(data);
762         return verifyCallResult(success, returndata, errorMessage);
763     }
764 
765     /**
766      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
767      * revert reason using the provided one.
768      *
769      * _Available since v4.3._
770      */
771     function verifyCallResult(
772         bool success,
773         bytes memory returndata,
774         string memory errorMessage
775     ) internal pure returns (bytes memory) {
776         if (success) {
777             return returndata;
778         } else {
779             // Look for revert reason and bubble it up if present
780             if (returndata.length > 0) {
781                 // The easiest way to bubble the revert reason is using memory via assembly
782 
783                 assembly {
784                     let returndata_size := mload(returndata)
785                     revert(add(32, returndata), returndata_size)
786                 }
787             } else {
788                 revert(errorMessage);
789             }
790         }
791     }
792 }
793 
794 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
795 pragma solidity ^0.8.0;
796 /**
797  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
798  * @dev See https://eips.ethereum.org/EIPS/eip-721
799  */
800 interface IERC721Metadata is IERC721 {
801     /**
802      * @dev Returns the token collection name.
803      */
804     function name() external view returns (string memory);
805 
806     /**
807      * @dev Returns the token collection symbol.
808      */
809     function symbol() external view returns (string memory);
810 
811     /**
812      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
813      */
814     function tokenURI(uint256 tokenId) external view returns (string memory);
815 }
816 
817 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
818 
819 
820 
821 pragma solidity ^0.8.0;
822 
823 /**
824  * @title ERC721 token receiver interface
825  * @dev Interface for any contract that wants to support safeTransfers
826  * from ERC721 asset contracts.
827  */
828 interface IERC721Receiver {
829     /**
830      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
831      * by `operator` from `from`, this function is called.
832      *
833      * It must return its Solidity selector to confirm the token transfer.
834      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
835      *
836      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
837      */
838     function onERC721Received(
839         address operator,
840         address from,
841         uint256 tokenId,
842         bytes calldata data
843     ) external returns (bytes4);
844 }
845 
846 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
847 
848 
849 
850 pragma solidity ^0.8.0;
851 
852 
853 
854 
855 
856 
857 
858 
859 /**
860  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
861  * the Metadata extension, but not including the Enumerable extension, which is available separately as
862  * {ERC721Enumerable}.
863  */
864 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
865     using Address for address;
866     using Strings for uint256;
867 
868     // Token name
869     string private _name;
870 
871     // Token symbol
872     string private _symbol;
873 
874     // Mapping from token ID to owner address
875     mapping(uint256 => address) private _owners;
876 
877     // Mapping owner address to token count
878     mapping(address => uint256) private _balances;
879 
880     // Mapping from token ID to approved address
881     mapping(uint256 => address) private _tokenApprovals;
882 
883     // Mapping from owner to operator approvals
884     mapping(address => mapping(address => bool)) private _operatorApprovals;
885 
886     /**
887      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
888      */
889     constructor(string memory name_, string memory symbol_) {
890         _name = name_;
891         _symbol = symbol_;
892     }
893 
894     /**
895      * @dev See {IERC165-supportsInterface}.
896      */
897     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
898         return
899             interfaceId == type(IERC721).interfaceId ||
900             interfaceId == type(IERC721Metadata).interfaceId ||
901             super.supportsInterface(interfaceId);
902     }
903 
904     /**
905      * @dev See {IERC721-balanceOf}.
906      */
907     function balanceOf(address owner) public view virtual override returns (uint256) {
908         require(owner != address(0), "ERC721: balance query for the zero address");
909         return _balances[owner];
910     }
911 
912     /**
913      * @dev See {IERC721-ownerOf}.
914      */
915     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
916         address owner = _owners[tokenId];
917         require(owner != address(0), "ERC721: owner query for nonexistent token");
918         return owner;
919     }
920 
921     /**
922      * @dev See {IERC721Metadata-name}.
923      */
924     function name() public view virtual override returns (string memory) {
925         return _name;
926     }
927 
928     /**
929      * @dev See {IERC721Metadata-symbol}.
930      */
931     function symbol() public view virtual override returns (string memory) {
932         return _symbol;
933     }
934 
935     /**
936      * @dev See {IERC721Metadata-tokenURI}.
937      */
938     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
939         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
940 
941         string memory baseURI = _baseURI();
942         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
943     }
944 
945     /**
946      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
947      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
948      * by default, can be overriden in child contracts.
949      */
950     function _baseURI() internal view virtual returns (string memory) {
951         return "";
952     }
953 
954     /**
955      * @dev See {IERC721-approve}.
956      */
957     function approve(address to, uint256 tokenId) public virtual override {
958         address owner = ERC721.ownerOf(tokenId);
959         require(to != owner, "ERC721: approval to current owner");
960 
961         require(
962             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
963             "ERC721: approve caller is not owner nor approved for all"
964         );
965 
966         _approve(to, tokenId);
967     }
968 
969     /**
970      * @dev See {IERC721-getApproved}.
971      */
972     function getApproved(uint256 tokenId) public view virtual override returns (address) {
973         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
974 
975         return _tokenApprovals[tokenId];
976     }
977 
978     /**
979      * @dev See {IERC721-setApprovalForAll}.
980      */
981     function setApprovalForAll(address operator, bool approved) public virtual override {
982         require(operator != _msgSender(), "ERC721: approve to caller");
983 
984         _operatorApprovals[_msgSender()][operator] = approved;
985         emit ApprovalForAll(_msgSender(), operator, approved);
986     }
987 
988     /**
989      * @dev See {IERC721-isApprovedForAll}.
990      */
991     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
992         return _operatorApprovals[owner][operator];
993     }
994 
995     /**
996      * @dev See {IERC721-transferFrom}.
997      */
998     function transferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) public virtual override {
1003         //solhint-disable-next-line max-line-length
1004         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1005 
1006         _transfer(from, to, tokenId);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-safeTransferFrom}.
1011      */
1012     function safeTransferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) public virtual override {
1017         safeTransferFrom(from, to, tokenId, "");
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-safeTransferFrom}.
1022      */
1023     function safeTransferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId,
1027         bytes memory _data
1028     ) public virtual override {
1029         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1030         _safeTransfer(from, to, tokenId, _data);
1031     }
1032 
1033     /**
1034      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1035      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1036      *
1037      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1038      *
1039      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1040      * implement alternative mechanisms to perform token transfer, such as signature-based.
1041      *
1042      * Requirements:
1043      *
1044      * - `from` cannot be the zero address.
1045      * - `to` cannot be the zero address.
1046      * - `tokenId` token must exist and be owned by `from`.
1047      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _safeTransfer(
1052         address from,
1053         address to,
1054         uint256 tokenId,
1055         bytes memory _data
1056     ) internal virtual {
1057         _transfer(from, to, tokenId);
1058         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1059     }
1060 
1061     /**
1062      * @dev Returns whether `tokenId` exists.
1063      *
1064      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1065      *
1066      * Tokens start existing when they are minted (`_mint`),
1067      * and stop existing when they are burned (`_burn`).
1068      */
1069     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1070         return _owners[tokenId] != address(0);
1071     }
1072 
1073     /**
1074      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1075      *
1076      * Requirements:
1077      *
1078      * - `tokenId` must exist.
1079      */
1080     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1081         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1082         address owner = ERC721.ownerOf(tokenId);
1083         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1084     }
1085 
1086     /**
1087      * @dev Safely mints `tokenId` and transfers it to `to`.
1088      *
1089      * Requirements:
1090      *
1091      * - `tokenId` must not exist.
1092      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function _safeMint(address to, uint256 tokenId) internal virtual {
1097         _safeMint(to, tokenId, "");
1098     }
1099 
1100     /**
1101      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1102      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1103      */
1104     function _safeMint(
1105         address to,
1106         uint256 tokenId,
1107         bytes memory _data
1108     ) internal virtual {
1109         _mint(to, tokenId);
1110         require(
1111             _checkOnERC721Received(address(0), to, tokenId, _data),
1112             "ERC721: transfer to non ERC721Receiver implementer"
1113         );
1114     }
1115 
1116     /**
1117      * @dev Mints `tokenId` and transfers it to `to`.
1118      *
1119      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1120      *
1121      * Requirements:
1122      *
1123      * - `tokenId` must not exist.
1124      * - `to` cannot be the zero address.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function _mint(address to, uint256 tokenId) internal virtual {
1129         require(to != address(0), "ERC721: mint to the zero address");
1130         require(!_exists(tokenId), "ERC721: token already minted");
1131 
1132         _beforeTokenTransfer(address(0), to, tokenId);
1133 
1134         _balances[to] += 1;
1135         _owners[tokenId] = to;
1136 
1137         emit Transfer(address(0), to, tokenId);
1138     }
1139 
1140     /**
1141      * @dev Destroys `tokenId`.
1142      * The approval is cleared when the token is burned.
1143      *
1144      * Requirements:
1145      *
1146      * - `tokenId` must exist.
1147      *
1148      * Emits a {Transfer} event.
1149      */
1150     function _burn(uint256 tokenId) internal virtual {
1151         address owner = ERC721.ownerOf(tokenId);
1152 
1153         _beforeTokenTransfer(owner, address(0), tokenId);
1154 
1155         // Clear approvals
1156         _approve(address(0), tokenId);
1157 
1158         _balances[owner] -= 1;
1159         delete _owners[tokenId];
1160 
1161         emit Transfer(owner, address(0), tokenId);
1162     }
1163 
1164     /**
1165      * @dev Transfers `tokenId` from `from` to `to`.
1166      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1167      *
1168      * Requirements:
1169      *
1170      * - `to` cannot be the zero address.
1171      * - `tokenId` token must be owned by `from`.
1172      *
1173      * Emits a {Transfer} event.
1174      */
1175     function _transfer(
1176         address from,
1177         address to,
1178         uint256 tokenId
1179     ) internal virtual {
1180         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1181         require(to != address(0), "ERC721: transfer to the zero address");
1182 
1183         _beforeTokenTransfer(from, to, tokenId);
1184 
1185         // Clear approvals from the previous owner
1186         _approve(address(0), tokenId);
1187 
1188         _balances[from] -= 1;
1189         _balances[to] += 1;
1190         _owners[tokenId] = to;
1191 
1192         emit Transfer(from, to, tokenId);
1193     }
1194 
1195     /**
1196      * @dev Approve `to` to operate on `tokenId`
1197      *
1198      * Emits a {Approval} event.
1199      */
1200     function _approve(address to, uint256 tokenId) internal virtual {
1201         _tokenApprovals[tokenId] = to;
1202         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1203     }
1204 
1205     /**
1206      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1207      * The call is not executed if the target address is not a contract.
1208      *
1209      * @param from address representing the previous owner of the given token ID
1210      * @param to target address that will receive the tokens
1211      * @param tokenId uint256 ID of the token to be transferred
1212      * @param _data bytes optional data to send along with the call
1213      * @return bool whether the call correctly returned the expected magic value
1214      */
1215     function _checkOnERC721Received(
1216         address from,
1217         address to,
1218         uint256 tokenId,
1219         bytes memory _data
1220     ) private returns (bool) {
1221         if (to.isContract()) {
1222             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1223                 return retval == IERC721Receiver.onERC721Received.selector;
1224             } catch (bytes memory reason) {
1225                 if (reason.length == 0) {
1226                     revert("ERC721: transfer to non ERC721Receiver implementer");
1227                 } else {
1228                     assembly {
1229                         revert(add(32, reason), mload(reason))
1230                     }
1231                 }
1232             }
1233         } else {
1234             return true;
1235         }
1236     }
1237 
1238     /**
1239      * @dev Hook that is called before any token transfer. This includes minting
1240      * and burning.
1241      *
1242      * Calling conditions:
1243      *
1244      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1245      * transferred to `to`.
1246      * - When `from` is zero, `tokenId` will be minted for `to`.
1247      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1248      * - `from` and `to` are never both zero.
1249      *
1250      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1251      */
1252     function _beforeTokenTransfer(
1253         address from,
1254         address to,
1255         uint256 tokenId
1256     ) internal virtual {}
1257 }
1258 
1259 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1260 
1261 
1262 
1263 pragma solidity ^0.8.0;
1264 
1265 
1266 
1267 /**
1268  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1269  * enumerability of all the token ids in the contract as well as all token ids owned by each
1270  * account.
1271  */
1272 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1273     // Mapping from owner to list of owned token IDs
1274     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1275 
1276     // Mapping from token ID to index of the owner tokens list
1277     mapping(uint256 => uint256) private _ownedTokensIndex;
1278 
1279     // Array with all token ids, used for enumeration
1280     uint256[] private _allTokens;
1281 
1282     // Mapping from token id to position in the allTokens array
1283     mapping(uint256 => uint256) private _allTokensIndex;
1284 
1285     /**
1286      * @dev See {IERC165-supportsInterface}.
1287      */
1288     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1289         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1290     }
1291 
1292     /**
1293      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1294      */
1295     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1296         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1297         return _ownedTokens[owner][index];
1298     }
1299 
1300     /**
1301      * @dev See {IERC721Enumerable-totalSupply}.
1302      */
1303     function totalSupply() public view virtual override returns (uint256) {
1304         return _allTokens.length;
1305     }
1306 
1307     /**
1308      * @dev See {IERC721Enumerable-tokenByIndex}.
1309      */
1310     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1311         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1312         return _allTokens[index];
1313     }
1314 
1315     /**
1316      * @dev Hook that is called before any token transfer. This includes minting
1317      * and burning.
1318      *
1319      * Calling conditions:
1320      *
1321      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1322      * transferred to `to`.
1323      * - When `from` is zero, `tokenId` will be minted for `to`.
1324      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1325      * - `from` cannot be the zero address.
1326      * - `to` cannot be the zero address.
1327      *
1328      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1329      */
1330     function _beforeTokenTransfer(
1331         address from,
1332         address to,
1333         uint256 tokenId
1334     ) internal virtual override {
1335         super._beforeTokenTransfer(from, to, tokenId);
1336 
1337         if (from == address(0)) {
1338             _addTokenToAllTokensEnumeration(tokenId);
1339         } else if (from != to) {
1340             _removeTokenFromOwnerEnumeration(from, tokenId);
1341         }
1342         if (to == address(0)) {
1343             _removeTokenFromAllTokensEnumeration(tokenId);
1344         } else if (to != from) {
1345             _addTokenToOwnerEnumeration(to, tokenId);
1346         }
1347     }
1348 
1349     /**
1350      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1351      * @param to address representing the new owner of the given token ID
1352      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1353      */
1354     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1355         uint256 length = ERC721.balanceOf(to);
1356         _ownedTokens[to][length] = tokenId;
1357         _ownedTokensIndex[tokenId] = length;
1358     }
1359 
1360     /**
1361      * @dev Private function to add a token to this extension's token tracking data structures.
1362      * @param tokenId uint256 ID of the token to be added to the tokens list
1363      */
1364     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1365         _allTokensIndex[tokenId] = _allTokens.length;
1366         _allTokens.push(tokenId);
1367     }
1368 
1369     /**
1370      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1371      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1372      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1373      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1374      * @param from address representing the previous owner of the given token ID
1375      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1376      */
1377     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1378         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1379         // then delete the last slot (swap and pop).
1380 
1381         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1382         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1383 
1384         // When the token to delete is the last token, the swap operation is unnecessary
1385         if (tokenIndex != lastTokenIndex) {
1386             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1387 
1388             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1389             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1390         }
1391 
1392         // This also deletes the contents at the last position of the array
1393         delete _ownedTokensIndex[tokenId];
1394         delete _ownedTokens[from][lastTokenIndex];
1395     }
1396 
1397     /**
1398      * @dev Private function to remove a token from this extension's token tracking data structures.
1399      * This has O(1) time complexity, but alters the order of the _allTokens array.
1400      * @param tokenId uint256 ID of the token to be removed from the tokens list
1401      */
1402     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1403         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1404         // then delete the last slot (swap and pop).
1405 
1406         uint256 lastTokenIndex = _allTokens.length - 1;
1407         uint256 tokenIndex = _allTokensIndex[tokenId];
1408 
1409         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1410         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1411         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1412         uint256 lastTokenId = _allTokens[lastTokenIndex];
1413 
1414         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1415         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1416 
1417         // This also deletes the contents at the last position of the array
1418         delete _allTokensIndex[tokenId];
1419         _allTokens.pop();
1420     }
1421 }
1422 
1423 // File: @openzeppelin/contracts/utils/Pausable.sol
1424 
1425 
1426 
1427 //SPDX-License-Identifier: MIT
1428 pragma solidity ^0.8.0;
1429 
1430 contract Mendel is ERC721Enumerable, Ownable, RandomlyAssigned {
1431   using Strings for uint256;
1432 
1433   string public baseExtension = ".json";
1434   uint256 public cost = 0.18 ether;
1435   uint256 public maxMintSupply = 770;
1436 
1437   uint256 public maxPresaleMintAmount = 3;
1438 
1439   uint256 public maxMintAmount = 3;
1440 
1441   bool public isPresaleActive = false;
1442   bool public isTeamMintActive = false;
1443   bool public isPublicSaleActive = false;
1444 
1445   uint public teamMintSupplyMinted = 0;
1446   uint public teamMintMaxSupply = 40; //40 for team + giveaways
1447 
1448   uint public publicSupplyMinted = 0; //Used for public and whitelist mints
1449   uint public publicMaxSupply = 730;  //Used for public and whitelist mints
1450 
1451   uint public presaleDay = 0;
1452 
1453   mapping(address => uint256) public whitelist;
1454   mapping(address => uint256) public teamWhitelist;
1455 
1456   string public baseURI;
1457 
1458   constructor(
1459   ) ERC721("Mendel", "MENDEL")
1460   RandomlyAssigned(770, 1) {
1461   }
1462 
1463   function _baseURI() internal view virtual override returns (string memory) {
1464     return baseURI;
1465   }
1466 
1467   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1468     baseURI = _newBaseURI;
1469   }
1470 
1471   function mint(uint256 _mintAmount) public payable {
1472     require(isPublicSaleActive, "Public Sale is not active");
1473     require(_mintAmount > 0);
1474     require(_mintAmount <= maxMintAmount);
1475     require(publicSupplyMinted + teamMintSupplyMinted + _mintAmount <= maxMintSupply);
1476     require(publicSupplyMinted + _mintAmount <= publicMaxSupply);
1477     require(msg.value >= cost * _mintAmount);
1478 
1479     for (uint256 i = 1; i <= _mintAmount; i++) {
1480       uint256 mintIndex = nextToken();
1481 
1482       _safeMint(_msgSender(), mintIndex);
1483     }
1484 
1485     publicSupplyMinted = publicSupplyMinted + _mintAmount;
1486   }
1487 
1488   function presaleMint(uint256 _mintAmount) external payable {
1489       require(isPresaleActive, "Presale is not active");
1490       require(_mintAmount > 0);
1491       require(_mintAmount <= maxPresaleMintAmount);
1492       require(publicSupplyMinted + teamMintSupplyMinted + _mintAmount <= maxMintSupply);
1493       require(publicSupplyMinted + _mintAmount <= publicMaxSupply);
1494       require(msg.value >= cost * _mintAmount);
1495       require(presaleDay >= 1);
1496 
1497       uint256 senderLimit = whitelist[msg.sender];
1498       if (presaleDay == 1){
1499           senderLimit -= 1;
1500       }else{
1501           if (senderLimit >= 1){
1502               senderLimit = 1;
1503           }
1504       }
1505 
1506       require(senderLimit > 0, "You have no tokens left");
1507       require(_mintAmount <= senderLimit, "Your max token holding exceeded");
1508 
1509 
1510       for (uint256 i = 0; i < _mintAmount; i++) {
1511           uint256 mintIndex = nextToken();
1512           _safeMint(_msgSender(), mintIndex);
1513           senderLimit -= 1;
1514       }
1515       if (presaleDay == 1) {
1516           senderLimit += 1;
1517       }
1518       publicSupplyMinted = publicSupplyMinted + _mintAmount;
1519       whitelist[msg.sender] = senderLimit;
1520   }
1521 
1522 
1523   function teamMint(uint256 _mintAmount) external payable {
1524       require(isTeamMintActive, "Teammint is not active");
1525       require(_mintAmount > 0);
1526       require(_mintAmount <= maxMintAmount);
1527       require(publicSupplyMinted + teamMintSupplyMinted + _mintAmount <= maxMintSupply);
1528       require(teamMintSupplyMinted + _mintAmount <= teamMintMaxSupply);
1529 
1530       uint256 senderLimit = teamWhitelist[msg.sender];
1531 
1532       require(senderLimit > 0, "You have no tokens left");
1533       require(_mintAmount <= senderLimit, "Your max token holding exceeded");
1534 
1535 
1536       for (uint256 i = 0; i < _mintAmount; i++) {
1537         uint256 mintIndex = nextToken();
1538         _safeMint(_msgSender(), mintIndex);
1539         senderLimit -= 1;
1540       }
1541 
1542       teamMintSupplyMinted = teamMintSupplyMinted + _mintAmount;
1543       teamWhitelist[msg.sender] = senderLimit;
1544   }
1545   function addWhitelist(
1546       address[] calldata _addrs,
1547       uint256[] calldata _limit
1548   ) external onlyOwner {
1549       require(_addrs.length == _limit.length);
1550       for (uint256 i = 0; i < _addrs.length; i++) {
1551           whitelist[_addrs[i]] = _limit[i];
1552       }
1553   }
1554   function addTeamMintWhitelist(
1555       address[] calldata _addrs,
1556       uint256[] calldata _limit
1557   ) external onlyOwner {
1558       require(_addrs.length == _limit.length);
1559       for (uint256 i = 0; i < _addrs.length; i++) {
1560           teamWhitelist[_addrs[i]] = _limit[i];
1561       }
1562   }
1563   function walletOfOwner(address _owner)
1564     public
1565     view
1566     returns (uint256[] memory)
1567   {
1568     uint256 ownerTokenCount = balanceOf(_owner);
1569     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1570     for (uint256 i; i < ownerTokenCount; i++) {
1571       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1572     }
1573     return tokenIds;
1574   }
1575 
1576   function tokenURI(uint256 tokenId)
1577     public
1578     view
1579     virtual
1580     override
1581     returns (string memory)
1582   {
1583     require(
1584       _exists(tokenId),
1585       "ERC721Metadata: URI query for nonexistent token"
1586     );
1587 
1588     string memory currentBaseURI = _baseURI();
1589     return bytes(currentBaseURI).length > 0
1590         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1591         : "";
1592   }
1593   //only owner
1594 
1595   function changeCost(uint256 newCost) external onlyOwner {
1596       cost = newCost;
1597   }
1598 
1599     function togglePresaleStatus() external onlyOwner {
1600         isPresaleActive = !isPresaleActive;
1601     }
1602     function mintDay(uint day) external onlyOwner {
1603         presaleDay = day;
1604     }
1605 
1606     function toggleTeamMintStatus() external onlyOwner {
1607         isTeamMintActive = !isTeamMintActive;
1608     }
1609 
1610     function togglePublicSaleStatus() external onlyOwner {
1611         isPublicSaleActive = !isPublicSaleActive;
1612     }
1613 
1614   function withdraw() public payable onlyOwner {
1615     require(payable(msg.sender).send(address(this).balance));
1616   }
1617 
1618 }