1 //   ]y      ,▄▒
2 
3         //   ▄╬╩▄▓▓╬╢╬▒⌐
4 
5         //   ▓#╟▓▄╣▀╫╬╚╨.,
6 
7         //  ▐▓∩▓¬╠╬█╓╣╟`%▄▄▀*ΣW@▓╠╘│▌⌐╙≈
8 
9         //  ╠^╚╝▓╝╚▀╬╩    `ⁿ╝╩╠╙ÖT╢Q╠╠╜Θ²╙╩"╔R══Qæ ,▄R⌐~ç   ,              µ▄
10 
11         //   "`"╜*"`           ╠ ╬Γ7▄▀╨╜╬▄▄╫╫Q╠╩@"╚╬#╬▓▓▓Ö╠╬▓╫╩╬▓▓╗╖▄▄Æ#╗▓▓▀
12 
13         //                     ║▐╚▒  ▀╞ µ ``╙     ^²▄╟¥⌐]╩¬    ``╙╙╨╩╩╙╙^`
14 
15         //                     ╟╠╬▌   ▒Ü╠           ╚╣¬╠
16 
17         //                     ╣║╣    ╠╙╚           ▐▌╠▓
18 
19         //                     ü╟╬    j╗▐⌐          j▓▄╞
20 
21         //                     ▓╪╔     ╣╠▌          ]╙▌Q%
22 
23         //                     ╬▌╟     ╘╝▓           ▓▌▒⌐▓
24 
25         //                   ]▒▒ε      ╬╙           ▀▒ └Q╬╕
26 
27         //                   ╣╬▌       ▓▌▄         ╬▒▀   ¼╬µ
28 
29         //                   ▓▌▌       ╫▒▌        ▓╣┘     ╟Γ¬
30 
31         //                   ▐╬▌▌       ╠▓▌       ▌µ`      ╫▓╫
32 
33         //                 ╓╬╗╬╟        ╟╣╬     ▄▐╠▐      ]▌█▄
34 
35         //                 ╝╫▀▄⌐       ╬▓▓╟    ▐╙▀▓√µ     ▐╫▓╩
36 
37 // Pettametti, art project by artist Pumpametti, 300 pettamettis for the 300 Pumpamettis, every Pumpa will get a Petta.
38 // Pumpametti holder get lifetime free mint for my projects, of course that includes the Pettametti!
39 // Go to MettiMint if you have one OG metti or MettiMultiMint if you have more than one OG mettis, 
40 // simply input your token ID, put 0 at the ether amount and you are good to go! For MettiMultiMint please write your token IDs separated by commas and no spaces,
41 // for example if you own Metti #1 and Mettti #5, input 1,5 at mettiIds (uint256[]).
42 // There'll only be 300 Pettamettis.
43 
44 // File: @openzeppelin/contracts/utils/Counters.sol
45 
46 pragma solidity ^0.8.0;
47 
48 /**
49  * @title Counters
50  * @author Matt Condon (@shrugs)
51  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
52  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
53  *
54  * Include with `using Counters for Counters.Counter;`
55  */
56 library Counters {
57     struct Counter {
58         // This variable should never be directly accessed by users of the library: interactions must be restricted to
59         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
60         // this feature: see https://github.com/ethereum/solidity/issues/4637
61         uint256 _value; // default: 0
62     }
63 
64     function current(Counter storage counter) internal view returns (uint256) {
65         return counter._value;
66     }
67 
68     function increment(Counter storage counter) internal {
69         unchecked {
70             counter._value += 1;
71         }
72     }
73 
74     function decrement(Counter storage counter) internal {
75         uint256 value = counter._value;
76         require(value > 0, "Counter: decrement overflow");
77         unchecked {
78             counter._value = value - 1;
79         }
80     }
81 
82     function reset(Counter storage counter) internal {
83         counter._value = 0;
84     }
85 }
86 
87 // File: contracts/WithLimitedSupply.sol
88 
89 
90 pragma solidity ^0.8.0;
91 
92 
93 /// @author 1001.digital 
94 /// @title A token tracker that limits the token supply and increments token IDs on each new mint.
95 abstract contract WithLimitedSupply {
96     using Counters for Counters.Counter;
97 
98     // Keeps track of how many we have minted
99     Counters.Counter private _tokenCount;
100 
101     /// @dev The maximum count of tokens this token tracker will hold.
102     uint256 private _maxSupply;
103 
104     /// Instanciate the contract
105     /// @param totalSupply_ how many tokens this collection should hold
106     constructor (uint256 totalSupply_) {
107         _maxSupply = totalSupply_;
108     }
109 
110     /// @dev Get the max Supply
111     /// @return the maximum token count
112     function maxSupply() public view returns (uint256) {
113         return _maxSupply;
114     }
115 
116     /// @dev Get the current token count
117     /// @return the created token count
118     function tokenCount() public view returns (uint256) {
119         return _tokenCount.current();
120     }
121 
122     /// @dev Check whether tokens are still available
123     /// @return the available token count
124     function availableTokenCount() public view returns (uint256) {
125         return maxSupply() - tokenCount();
126     }
127 
128     /// @dev Increment the token count and fetch the latest count
129     /// @return the next token id
130     function nextToken() internal virtual ensureAvailability returns (uint256) {
131         uint256 token = _tokenCount.current();
132 
133         _tokenCount.increment();
134 
135         return token;
136     }
137 
138     /// @dev Check whether another token is still available
139     modifier ensureAvailability() {
140         require(availableTokenCount() > 0, "No more tokens available");
141         _;
142     }
143 
144     /// @param amount Check whether number of tokens are still available
145     /// @dev Check whether tokens are still available
146     modifier ensureAvailabilityFor(uint256 amount) {
147         require(availableTokenCount() >= amount, "Requested number of tokens not available");
148         _;
149     }
150 }
151 // File: contracts/RandomlyAssigned.sol
152 
153 
154 pragma solidity ^0.8.0;
155 
156 
157 /// @author 1001.digital
158 /// @title Randomly assign tokenIDs from a given set of tokens.
159 abstract contract RandomlyAssigned is WithLimitedSupply {
160     // Used for random index assignment
161     mapping(uint256 => uint256) private tokenMatrix;
162 
163     // The initial token ID
164     uint256 private startFrom;
165 
166     /// Instanciate the contract
167     /// @param _maxSupply how many tokens this collection should hold
168     /// @param _startFrom the tokenID with which to start counting
169     constructor (uint256 _maxSupply, uint256 _startFrom)
170         WithLimitedSupply(_maxSupply)
171     {
172         startFrom = _startFrom;
173     }
174 
175     /// Get the next token ID
176     /// @dev Randomly gets a new token ID and keeps track of the ones that are still available.
177     /// @return the next token ID
178     function nextToken() internal override ensureAvailability returns (uint256) {
179         uint256 maxIndex = maxSupply() - tokenCount();
180         uint256 random = uint256(keccak256(
181             abi.encodePacked(
182                 msg.sender,
183                 block.coinbase,
184                 block.difficulty,
185                 block.gaslimit,
186                 block.timestamp
187             )
188         )) % maxIndex;
189 
190         uint256 value = 0;
191         if (tokenMatrix[random] == 0) {
192             // If this matrix position is empty, set the value to the generated random number.
193             value = random;
194         } else {
195             // Otherwise, use the previously stored number from the matrix.
196             value = tokenMatrix[random];
197         }
198 
199         // If the last available tokenID is still unused...
200         if (tokenMatrix[maxIndex - 1] == 0) {
201             // ...store that ID in the current matrix position.
202             tokenMatrix[random] = maxIndex - 1;
203         } else {
204             // ...otherwise copy over the stored number to the current matrix position.
205             tokenMatrix[random] = tokenMatrix[maxIndex - 1];
206         }
207 
208         // Increment counts
209         super.nextToken();
210 
211         return value + startFrom;
212     }
213 }
214 
215 // File: @openzeppelin/contracts/utils/Context.sol
216 
217 
218 
219 pragma solidity ^0.8.0;
220 
221 /**
222  * @dev Provides information about the current execution context, including the
223  * sender of the transaction and its data. While these are generally available
224  * via msg.sender and msg.data, they should not be accessed in such a direct
225  * manner, since when dealing with meta-transactions the account sending and
226  * paying for execution may not be the actual sender (as far as an application
227  * is concerned).
228  *
229  * This contract is only required for intermediate, library-like contracts.
230  */
231 abstract contract Context {
232     function _msgSender() internal view virtual returns (address) {
233         return msg.sender;
234     }
235 
236     function _msgData() internal view virtual returns (bytes calldata) {
237         return msg.data;
238     }
239 }
240 
241 // File: @openzeppelin/contracts/access/Ownable.sol
242 
243 
244 
245 pragma solidity ^0.8.0;
246 
247 
248 /**
249  * @dev Contract module which provides a basic access control mechanism, where
250  * there is an account (an owner) that can be granted exclusive access to
251  * specific functions.
252  *
253  * By default, the owner account will be the one that deploys the contract. This
254  * can later be changed with {transferOwnership}.
255  *
256  * This module is used through inheritance. It will make available the modifier
257  * `onlyOwner`, which can be applied to your functions to restrict their use to
258  * the owner.
259  */
260 abstract contract Ownable is Context {
261     address private _owner;
262 
263     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
264 
265     /**
266      * @dev Initializes the contract setting the deployer as the initial owner.
267      */
268     constructor() {
269         _setOwner(_msgSender());
270     }
271 
272     /**
273      * @dev Returns the address of the current owner.
274      */
275     function owner() public view virtual returns (address) {
276         return _owner;
277     }
278 
279     /**
280      * @dev Throws if called by any account other than the owner.
281      */
282     modifier onlyOwner() {
283         require(owner() == _msgSender(), "Ownable: caller is not the owner");
284         _;
285     }
286 
287     /**
288      * @dev Leaves the contract without owner. It will not be possible to call
289      * `onlyOwner` functions anymore. Can only be called by the current owner.
290      *
291      * NOTE: Renouncing ownership will leave the contract without an owner,
292      * thereby removing any functionality that is only available to the owner.
293      */
294     function renounceOwnership() public virtual onlyOwner {
295         _setOwner(address(0));
296     }
297 
298     /**
299      * @dev Transfers ownership of the contract to a new account (`newOwner`).
300      * Can only be called by the current owner.
301      */
302     function transferOwnership(address newOwner) public virtual onlyOwner {
303         require(newOwner != address(0), "Ownable: new owner is the zero address");
304         _setOwner(newOwner);
305     }
306 
307     function _setOwner(address newOwner) private {
308         address oldOwner = _owner;
309         _owner = newOwner;
310         emit OwnershipTransferred(oldOwner, newOwner);
311     }
312 }
313 
314 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
315 
316 
317 
318 pragma solidity ^0.8.0;
319 
320 /**
321  * @dev Interface of the ERC165 standard, as defined in the
322  * https://eips.ethereum.org/EIPS/eip-165[EIP].
323  *
324  * Implementers can declare support of contract interfaces, which can then be
325  * queried by others ({ERC165Checker}).
326  *
327  * For an implementation, see {ERC165}.
328  */
329 interface IERC165 {
330     /**
331      * @dev Returns true if this contract implements the interface defined by
332      * `interfaceId`. See the corresponding
333      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
334      * to learn more about how these ids are created.
335      *
336      * This function call must use less than 30 000 gas.
337      */
338     function supportsInterface(bytes4 interfaceId) external view returns (bool);
339 }
340 
341 
342 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
343 
344 
345 
346 pragma solidity ^0.8.0;
347 
348 
349 /**
350  * @dev Required interface of an ERC721 compliant contract.
351  */
352 interface IERC721 is IERC165 {
353     /**
354      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
355      */
356     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
357 
358     /**
359      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
360      */
361     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
362 
363     /**
364      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
365      */
366     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
367 
368     /**
369      * @dev Returns the number of tokens in ``owner``'s account.
370      */
371     function balanceOf(address owner) external view returns (uint256 balance);
372 
373     /**
374      * @dev Returns the owner of the `tokenId` token.
375      *
376      * Requirements:
377      *
378      * - `tokenId` must exist.
379      */
380     function ownerOf(uint256 tokenId) external view returns (address owner);
381 
382     /**
383      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
384      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
385      *
386      * Requirements:
387      *
388      * - `from` cannot be the zero address.
389      * - `to` cannot be the zero address.
390      * - `tokenId` token must exist and be owned by `from`.
391      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
392      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
393      *
394      * Emits a {Transfer} event.
395      */
396     function safeTransferFrom(
397         address from,
398         address to,
399         uint256 tokenId
400     ) external;
401 
402     /**
403      * @dev Transfers `tokenId` token from `from` to `to`.
404      *
405      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
406      *
407      * Requirements:
408      *
409      * - `from` cannot be the zero address.
410      * - `to` cannot be the zero address.
411      * - `tokenId` token must be owned by `from`.
412      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
413      *
414      * Emits a {Transfer} event.
415      */
416     function transferFrom(
417         address from,
418         address to,
419         uint256 tokenId
420     ) external;
421 
422     /**
423      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
424      * The approval is cleared when the token is transferred.
425      *
426      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
427      *
428      * Requirements:
429      *
430      * - The caller must own the token or be an approved operator.
431      * - `tokenId` must exist.
432      *
433      * Emits an {Approval} event.
434      */
435     function approve(address to, uint256 tokenId) external;
436 
437     /**
438      * @dev Returns the account approved for `tokenId` token.
439      *
440      * Requirements:
441      *
442      * - `tokenId` must exist.
443      */
444     function getApproved(uint256 tokenId) external view returns (address operator);
445 
446     /**
447      * @dev Approve or remove `operator` as an operator for the caller.
448      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
449      *
450      * Requirements:
451      *
452      * - The `operator` cannot be the caller.
453      *
454      * Emits an {ApprovalForAll} event.
455      */
456     function setApprovalForAll(address operator, bool _approved) external;
457 
458     /**
459      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
460      *
461      * See {setApprovalForAll}
462      */
463     function isApprovedForAll(address owner, address operator) external view returns (bool);
464 
465     /**
466      * @dev Safely transfers `tokenId` token from `from` to `to`.
467      *
468      * Requirements:
469      *
470      * - `from` cannot be the zero address.
471      * - `to` cannot be the zero address.
472      * - `tokenId` token must exist and be owned by `from`.
473      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
474      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
475      *
476      * Emits a {Transfer} event.
477      */
478     function safeTransferFrom(
479         address from,
480         address to,
481         uint256 tokenId,
482         bytes calldata data
483     ) external;
484 }
485 
486 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
487 
488 
489 
490 pragma solidity ^0.8.0;
491 
492 
493 /**
494  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
495  * @dev See https://eips.ethereum.org/EIPS/eip-721
496  */
497 interface IERC721Enumerable is IERC721 {
498     /**
499      * @dev Returns the total amount of tokens stored by the contract.
500      */
501     function totalSupply() external view returns (uint256);
502 
503     /**
504      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
505      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
506      */
507     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
508 
509     /**
510      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
511      * Use along with {totalSupply} to enumerate all tokens.
512      */
513     function tokenByIndex(uint256 index) external view returns (uint256);
514 }
515 
516 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
517 
518 
519 
520 pragma solidity ^0.8.0;
521 
522 
523 /**
524  * @dev Implementation of the {IERC165} interface.
525  *
526  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
527  * for the additional interface id that will be supported. For example:
528  *
529  * ```solidity
530  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
531  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
532  * }
533  * ```
534  *
535  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
536  */
537 abstract contract ERC165 is IERC165 {
538     /**
539      * @dev See {IERC165-supportsInterface}.
540      */
541     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
542         return interfaceId == type(IERC165).interfaceId;
543     }
544 }
545 
546 // File: @openzeppelin/contracts/utils/Strings.sol
547 
548 
549 
550 pragma solidity ^0.8.0;
551 
552 /**
553  * @dev String operations.
554  */
555 library Strings {
556     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
557 
558     /**
559      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
560      */
561     function toString(uint256 value) internal pure returns (string memory) {
562         // Inspired by OraclizeAPI's implementation - MIT licence
563         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
564 
565         if (value == 0) {
566             return "0";
567         }
568         uint256 temp = value;
569         uint256 digits;
570         while (temp != 0) {
571             digits++;
572             temp /= 10;
573         }
574         bytes memory buffer = new bytes(digits);
575         while (value != 0) {
576             digits -= 1;
577             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
578             value /= 10;
579         }
580         return string(buffer);
581     }
582 
583     /**
584      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
585      */
586     function toHexString(uint256 value) internal pure returns (string memory) {
587         if (value == 0) {
588             return "0x00";
589         }
590         uint256 temp = value;
591         uint256 length = 0;
592         while (temp != 0) {
593             length++;
594             temp >>= 8;
595         }
596         return toHexString(value, length);
597     }
598 
599     /**
600      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
601      */
602     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
603         bytes memory buffer = new bytes(2 * length + 2);
604         buffer[0] = "0";
605         buffer[1] = "x";
606         for (uint256 i = 2 * length + 1; i > 1; --i) {
607             buffer[i] = _HEX_SYMBOLS[value & 0xf];
608             value >>= 4;
609         }
610         require(value == 0, "Strings: hex length insufficient");
611         return string(buffer);
612     }
613 }
614 
615 
616 // File: @openzeppelin/contracts/utils/Address.sol
617 
618 
619 
620 pragma solidity ^0.8.0;
621 
622 /**
623  * @dev Collection of functions related to the address type
624  */
625 library Address {
626     /**
627      * @dev Returns true if `account` is a contract.
628      *
629      * [IMPORTANT]
630      * ====
631      * It is unsafe to assume that an address for which this function returns
632      * false is an externally-owned account (EOA) and not a contract.
633      *
634      * Among others, `isContract` will return false for the following
635      * types of addresses:
636      *
637      *  - an externally-owned account
638      *  - a contract in construction
639      *  - an address where a contract will be created
640      *  - an address where a contract lived, but was destroyed
641      * ====
642      */
643     function isContract(address account) internal view returns (bool) {
644         // This method relies on extcodesize, which returns 0 for contracts in
645         // construction, since the code is only stored at the end of the
646         // constructor execution.
647 
648         uint256 size;
649         assembly {
650             size := extcodesize(account)
651         }
652         return size > 0;
653     }
654 
655     /**
656      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
657      * `recipient`, forwarding all available gas and reverting on errors.
658      *
659      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
660      * of certain opcodes, possibly making contracts go over the 2300 gas limit
661      * imposed by `transfer`, making them unable to receive funds via
662      * `transfer`. {sendValue} removes this limitation.
663      *
664      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
665      *
666      * IMPORTANT: because control is transferred to `recipient`, care must be
667      * taken to not create reentrancy vulnerabilities. Consider using
668      * {ReentrancyGuard} or the
669      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
670      */
671     function sendValue(address payable recipient, uint256 amount) internal {
672         require(address(this).balance >= amount, "Address: insufficient balance");
673 
674         (bool success, ) = recipient.call{value: amount}("");
675         require(success, "Address: unable to send value, recipient may have reverted");
676     }
677 
678     /**
679      * @dev Performs a Solidity function call using a low level `call`. A
680      * plain `call` is an unsafe replacement for a function call: use this
681      * function instead.
682      *
683      * If `target` reverts with a revert reason, it is bubbled up by this
684      * function (like regular Solidity function calls).
685      *
686      * Returns the raw returned data. To convert to the expected return value,
687      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
688      *
689      * Requirements:
690      *
691      * - `target` must be a contract.
692      * - calling `target` with `data` must not revert.
693      *
694      * _Available since v3.1._
695      */
696     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
697         return functionCall(target, data, "Address: low-level call failed");
698     }
699 
700     /**
701      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
702      * `errorMessage` as a fallback revert reason when `target` reverts.
703      *
704      * _Available since v3.1._
705      */
706     function functionCall(
707         address target,
708         bytes memory data,
709         string memory errorMessage
710     ) internal returns (bytes memory) {
711         return functionCallWithValue(target, data, 0, errorMessage);
712     }
713 
714     /**
715      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
716      * but also transferring `value` wei to `target`.
717      *
718      * Requirements:
719      *
720      * - the calling contract must have an ETH balance of at least `value`.
721      * - the called Solidity function must be `payable`.
722      *
723      * _Available since v3.1._
724      */
725     function functionCallWithValue(
726         address target,
727         bytes memory data,
728         uint256 value
729     ) internal returns (bytes memory) {
730         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
731     }
732 
733     /**
734      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
735      * with `errorMessage` as a fallback revert reason when `target` reverts.
736      *
737      * _Available since v3.1._
738      */
739     function functionCallWithValue(
740         address target,
741         bytes memory data,
742         uint256 value,
743         string memory errorMessage
744     ) internal returns (bytes memory) {
745         require(address(this).balance >= value, "Address: insufficient balance for call");
746         require(isContract(target), "Address: call to non-contract");
747 
748         (bool success, bytes memory returndata) = target.call{value: value}(data);
749         return verifyCallResult(success, returndata, errorMessage);
750     }
751 
752     /**
753      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
754      * but performing a static call.
755      *
756      * _Available since v3.3._
757      */
758     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
759         return functionStaticCall(target, data, "Address: low-level static call failed");
760     }
761 
762     /**
763      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
764      * but performing a static call.
765      *
766      * _Available since v3.3._
767      */
768     function functionStaticCall(
769         address target,
770         bytes memory data,
771         string memory errorMessage
772     ) internal view returns (bytes memory) {
773         require(isContract(target), "Address: static call to non-contract");
774 
775         (bool success, bytes memory returndata) = target.staticcall(data);
776         return verifyCallResult(success, returndata, errorMessage);
777     }
778 
779     /**
780      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
781      * but performing a delegate call.
782      *
783      * _Available since v3.4._
784      */
785     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
786         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
787     }
788 
789     /**
790      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
791      * but performing a delegate call.
792      *
793      * _Available since v3.4._
794      */
795     function functionDelegateCall(
796         address target,
797         bytes memory data,
798         string memory errorMessage
799     ) internal returns (bytes memory) {
800         require(isContract(target), "Address: delegate call to non-contract");
801 
802         (bool success, bytes memory returndata) = target.delegatecall(data);
803         return verifyCallResult(success, returndata, errorMessage);
804     }
805 
806     /**
807      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
808      * revert reason using the provided one.
809      *
810      * _Available since v4.3._
811      */
812     function verifyCallResult(
813         bool success,
814         bytes memory returndata,
815         string memory errorMessage
816     ) internal pure returns (bytes memory) {
817         if (success) {
818             return returndata;
819         } else {
820             // Look for revert reason and bubble it up if present
821             if (returndata.length > 0) {
822                 // The easiest way to bubble the revert reason is using memory via assembly
823 
824                 assembly {
825                     let returndata_size := mload(returndata)
826                     revert(add(32, returndata), returndata_size)
827                 }
828             } else {
829                 revert(errorMessage);
830             }
831         }
832     }
833 }
834 
835 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
836 
837 
838 
839 pragma solidity ^0.8.0;
840 
841 
842 /**
843  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
844  * @dev See https://eips.ethereum.org/EIPS/eip-721
845  */
846 interface IERC721Metadata is IERC721 {
847     /**
848      * @dev Returns the token collection name.
849      */
850     function name() external view returns (string memory);
851 
852     /**
853      * @dev Returns the token collection symbol.
854      */
855     function symbol() external view returns (string memory);
856 
857     /**
858      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
859      */
860     function tokenURI(uint256 tokenId) external view returns (string memory);
861 }
862 
863 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
864 
865 
866 
867 pragma solidity ^0.8.0;
868 
869 /**
870  * @title ERC721 token receiver interface
871  * @dev Interface for any contract that wants to support safeTransfers
872  * from ERC721 asset contracts.
873  */
874 interface IERC721Receiver {
875     /**
876      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
877      * by `operator` from `from`, this function is called.
878      *
879      * It must return its Solidity selector to confirm the token transfer.
880      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
881      *
882      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
883      */
884     function onERC721Received(
885         address operator,
886         address from,
887         uint256 tokenId,
888         bytes calldata data
889     ) external returns (bytes4);
890 }
891 
892 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
893 
894 
895 
896 pragma solidity ^0.8.0;
897 
898 
899 
900 
901 
902 
903 
904 
905 /**
906  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
907  * the Metadata extension, but not including the Enumerable extension, which is available separately as
908  * {ERC721Enumerable}.
909  */
910 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
911     using Address for address;
912     using Strings for uint256;
913 
914     // Token name
915     string private _name;
916 
917     // Token symbol
918     string private _symbol;
919 
920     // Mapping from token ID to owner address
921     mapping(uint256 => address) private _owners;
922 
923     // Mapping owner address to token count
924     mapping(address => uint256) private _balances;
925 
926     // Mapping from token ID to approved address
927     mapping(uint256 => address) private _tokenApprovals;
928 
929     // Mapping from owner to operator approvals
930     mapping(address => mapping(address => bool)) private _operatorApprovals;
931 
932     /**
933      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
934      */
935     constructor(string memory name_, string memory symbol_) {
936         _name = name_;
937         _symbol = symbol_;
938     }
939 
940     /**
941      * @dev See {IERC165-supportsInterface}.
942      */
943     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
944         return
945             interfaceId == type(IERC721).interfaceId ||
946             interfaceId == type(IERC721Metadata).interfaceId ||
947             super.supportsInterface(interfaceId);
948     }
949 
950     /**
951      * @dev See {IERC721-balanceOf}.
952      */
953     function balanceOf(address owner) public view virtual override returns (uint256) {
954         require(owner != address(0), "ERC721: balance query for the zero address");
955         return _balances[owner];
956     }
957 
958     /**
959      * @dev See {IERC721-ownerOf}.
960      */
961     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
962         address owner = _owners[tokenId];
963         require(owner != address(0), "ERC721: owner query for nonexistent token");
964         return owner;
965     }
966 
967     /**
968      * @dev See {IERC721Metadata-name}.
969      */
970     function name() public view virtual override returns (string memory) {
971         return _name;
972     }
973 
974     /**
975      * @dev See {IERC721Metadata-symbol}.
976      */
977     function symbol() public view virtual override returns (string memory) {
978         return _symbol;
979     }
980 
981     /**
982      * @dev See {IERC721Metadata-tokenURI}.
983      */
984     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
985         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
986 
987         string memory baseURI = _baseURI();
988         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
989     }
990 
991     /**
992      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
993      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
994      * by default, can be overriden in child contracts.
995      */
996     function _baseURI() internal view virtual returns (string memory) {
997         return "";
998     }
999 
1000     /**
1001      * @dev See {IERC721-approve}.
1002      */
1003     function approve(address to, uint256 tokenId) public virtual override {
1004         address owner = ERC721.ownerOf(tokenId);
1005         require(to != owner, "ERC721: approval to current owner");
1006 
1007         require(
1008             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1009             "ERC721: approve caller is not owner nor approved for all"
1010         );
1011 
1012         _approve(to, tokenId);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-getApproved}.
1017      */
1018     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1019         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1020 
1021         return _tokenApprovals[tokenId];
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-setApprovalForAll}.
1026      */
1027     function setApprovalForAll(address operator, bool approved) public virtual override {
1028         require(operator != _msgSender(), "ERC721: approve to caller");
1029 
1030         _operatorApprovals[_msgSender()][operator] = approved;
1031         emit ApprovalForAll(_msgSender(), operator, approved);
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-isApprovedForAll}.
1036      */
1037     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1038         return _operatorApprovals[owner][operator];
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-transferFrom}.
1043      */
1044     function transferFrom(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) public virtual override {
1049         //solhint-disable-next-line max-line-length
1050         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1051 
1052         _transfer(from, to, tokenId);
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-safeTransferFrom}.
1057      */
1058     function safeTransferFrom(
1059         address from,
1060         address to,
1061         uint256 tokenId
1062     ) public virtual override {
1063         safeTransferFrom(from, to, tokenId, "");
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-safeTransferFrom}.
1068      */
1069     function safeTransferFrom(
1070         address from,
1071         address to,
1072         uint256 tokenId,
1073         bytes memory _data
1074     ) public virtual override {
1075         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1076         _safeTransfer(from, to, tokenId, _data);
1077     }
1078 
1079     /**
1080      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1081      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1082      *
1083      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1084      *
1085      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1086      * implement alternative mechanisms to perform token transfer, such as signature-based.
1087      *
1088      * Requirements:
1089      *
1090      * - `from` cannot be the zero address.
1091      * - `to` cannot be the zero address.
1092      * - `tokenId` token must exist and be owned by `from`.
1093      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function _safeTransfer(
1098         address from,
1099         address to,
1100         uint256 tokenId,
1101         bytes memory _data
1102     ) internal virtual {
1103         _transfer(from, to, tokenId);
1104         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1105     }
1106 
1107     /**
1108      * @dev Returns whether `tokenId` exists.
1109      *
1110      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1111      *
1112      * Tokens start existing when they are minted (`_mint`),
1113      * and stop existing when they are burned (`_burn`).
1114      */
1115     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1116         return _owners[tokenId] != address(0);
1117     }
1118 
1119     /**
1120      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1121      *
1122      * Requirements:
1123      *
1124      * - `tokenId` must exist.
1125      */
1126     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1127         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1128         address owner = ERC721.ownerOf(tokenId);
1129         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1130     }
1131 
1132     /**
1133      * @dev Safely mints `tokenId` and transfers it to `to`.
1134      *
1135      * Requirements:
1136      *
1137      * - `tokenId` must not exist.
1138      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1139      *
1140      * Emits a {Transfer} event.
1141      */
1142     function _safeMint(address to, uint256 tokenId) internal virtual {
1143         _safeMint(to, tokenId, "");
1144     }
1145 
1146     /**
1147      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1148      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1149      */
1150     function _safeMint(
1151         address to,
1152         uint256 tokenId,
1153         bytes memory _data
1154     ) internal virtual {
1155         _mint(to, tokenId);
1156         require(
1157             _checkOnERC721Received(address(0), to, tokenId, _data),
1158             "ERC721: transfer to non ERC721Receiver implementer"
1159         );
1160     }
1161 
1162     /**
1163      * @dev Mints `tokenId` and transfers it to `to`.
1164      *
1165      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1166      *
1167      * Requirements:
1168      *
1169      * - `tokenId` must not exist.
1170      * - `to` cannot be the zero address.
1171      *
1172      * Emits a {Transfer} event.
1173      */
1174     function _mint(address to, uint256 tokenId) internal virtual {
1175         require(to != address(0), "ERC721: mint to the zero address");
1176         require(!_exists(tokenId), "ERC721: token already minted");
1177 
1178         _beforeTokenTransfer(address(0), to, tokenId);
1179 
1180         _balances[to] += 1;
1181         _owners[tokenId] = to;
1182 
1183         emit Transfer(address(0), to, tokenId);
1184     }
1185 
1186     /**
1187      * @dev Destroys `tokenId`.
1188      * The approval is cleared when the token is burned.
1189      *
1190      * Requirements:
1191      *
1192      * - `tokenId` must exist.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function _burn(uint256 tokenId) internal virtual {
1197         address owner = ERC721.ownerOf(tokenId);
1198 
1199         _beforeTokenTransfer(owner, address(0), tokenId);
1200 
1201         // Clear approvals
1202         _approve(address(0), tokenId);
1203 
1204         _balances[owner] -= 1;
1205         delete _owners[tokenId];
1206 
1207         emit Transfer(owner, address(0), tokenId);
1208     }
1209 
1210     /**
1211      * @dev Transfers `tokenId` from `from` to `to`.
1212      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1213      *
1214      * Requirements:
1215      *
1216      * - `to` cannot be the zero address.
1217      * - `tokenId` token must be owned by `from`.
1218      *
1219      * Emits a {Transfer} event.
1220      */
1221     function _transfer(
1222         address from,
1223         address to,
1224         uint256 tokenId
1225     ) internal virtual {
1226         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1227         require(to != address(0), "ERC721: transfer to the zero address");
1228 
1229         _beforeTokenTransfer(from, to, tokenId);
1230 
1231         // Clear approvals from the previous owner
1232         _approve(address(0), tokenId);
1233 
1234         _balances[from] -= 1;
1235         _balances[to] += 1;
1236         _owners[tokenId] = to;
1237 
1238         emit Transfer(from, to, tokenId);
1239     }
1240 
1241     /**
1242      * @dev Approve `to` to operate on `tokenId`
1243      *
1244      * Emits a {Approval} event.
1245      */
1246     function _approve(address to, uint256 tokenId) internal virtual {
1247         _tokenApprovals[tokenId] = to;
1248         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1249     }
1250 
1251     /**
1252      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1253      * The call is not executed if the target address is not a contract.
1254      *
1255      * @param from address representing the previous owner of the given token ID
1256      * @param to target address that will receive the tokens
1257      * @param tokenId uint256 ID of the token to be transferred
1258      * @param _data bytes optional data to send along with the call
1259      * @return bool whether the call correctly returned the expected magic value
1260      */
1261     function _checkOnERC721Received(
1262         address from,
1263         address to,
1264         uint256 tokenId,
1265         bytes memory _data
1266     ) private returns (bool) {
1267         if (to.isContract()) {
1268             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1269                 return retval == IERC721Receiver.onERC721Received.selector;
1270             } catch (bytes memory reason) {
1271                 if (reason.length == 0) {
1272                     revert("ERC721: transfer to non ERC721Receiver implementer");
1273                 } else {
1274                     assembly {
1275                         revert(add(32, reason), mload(reason))
1276                     }
1277                 }
1278             }
1279         } else {
1280             return true;
1281         }
1282     }
1283 
1284     /**
1285      * @dev Hook that is called before any token transfer. This includes minting
1286      * and burning.
1287      *
1288      * Calling conditions:
1289      *
1290      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1291      * transferred to `to`.
1292      * - When `from` is zero, `tokenId` will be minted for `to`.
1293      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1294      * - `from` and `to` are never both zero.
1295      *
1296      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1297      */
1298     function _beforeTokenTransfer(
1299         address from,
1300         address to,
1301         uint256 tokenId
1302     ) internal virtual {}
1303 }
1304 
1305 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1306 
1307 
1308 
1309 pragma solidity ^0.8.0;
1310 
1311 
1312 
1313 /**
1314  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1315  * enumerability of all the token ids in the contract as well as all token ids owned by each
1316  * account.
1317  */
1318 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1319     // Mapping from owner to list of owned token IDs
1320     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1321 
1322     // Mapping from token ID to index of the owner tokens list
1323     mapping(uint256 => uint256) private _ownedTokensIndex;
1324 
1325     // Array with all token ids, used for enumeration
1326     uint256[] private _allTokens;
1327 
1328     // Mapping from token id to position in the allTokens array
1329     mapping(uint256 => uint256) private _allTokensIndex;
1330 
1331     /**
1332      * @dev See {IERC165-supportsInterface}.
1333      */
1334     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1335         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1336     }
1337 
1338     /**
1339      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1340      */
1341     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1342         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1343         return _ownedTokens[owner][index];
1344     }
1345 
1346     /**
1347      * @dev See {IERC721Enumerable-totalSupply}.
1348      */
1349     function totalSupply() public view virtual override returns (uint256) {
1350         return _allTokens.length;
1351     }
1352 
1353     /**
1354      * @dev See {IERC721Enumerable-tokenByIndex}.
1355      */
1356     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1357         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1358         return _allTokens[index];
1359     }
1360 
1361     /**
1362      * @dev Hook that is called before any token transfer. This includes minting
1363      * and burning.
1364      *
1365      * Calling conditions:
1366      *
1367      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1368      * transferred to `to`.
1369      * - When `from` is zero, `tokenId` will be minted for `to`.
1370      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1371      * - `from` cannot be the zero address.
1372      * - `to` cannot be the zero address.
1373      *
1374      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1375      */
1376     function _beforeTokenTransfer(
1377         address from,
1378         address to,
1379         uint256 tokenId
1380     ) internal virtual override {
1381         super._beforeTokenTransfer(from, to, tokenId);
1382 
1383         if (from == address(0)) {
1384             _addTokenToAllTokensEnumeration(tokenId);
1385         } else if (from != to) {
1386             _removeTokenFromOwnerEnumeration(from, tokenId);
1387         }
1388         if (to == address(0)) {
1389             _removeTokenFromAllTokensEnumeration(tokenId);
1390         } else if (to != from) {
1391             _addTokenToOwnerEnumeration(to, tokenId);
1392         }
1393     }
1394 
1395     /**
1396      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1397      * @param to address representing the new owner of the given token ID
1398      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1399      */
1400     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1401         uint256 length = ERC721.balanceOf(to);
1402         _ownedTokens[to][length] = tokenId;
1403         _ownedTokensIndex[tokenId] = length;
1404     }
1405 
1406     /**
1407      * @dev Private function to add a token to this extension's token tracking data structures.
1408      * @param tokenId uint256 ID of the token to be added to the tokens list
1409      */
1410     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1411         _allTokensIndex[tokenId] = _allTokens.length;
1412         _allTokens.push(tokenId);
1413     }
1414 
1415     /**
1416      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1417      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1418      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1419      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1420      * @param from address representing the previous owner of the given token ID
1421      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1422      */
1423     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1424         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1425         // then delete the last slot (swap and pop).
1426 
1427         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1428         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1429 
1430         // When the token to delete is the last token, the swap operation is unnecessary
1431         if (tokenIndex != lastTokenIndex) {
1432             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1433 
1434             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1435             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1436         }
1437 
1438         // This also deletes the contents at the last position of the array
1439         delete _ownedTokensIndex[tokenId];
1440         delete _ownedTokens[from][lastTokenIndex];
1441     }
1442 
1443     /**
1444      * @dev Private function to remove a token from this extension's token tracking data structures.
1445      * This has O(1) time complexity, but alters the order of the _allTokens array.
1446      * @param tokenId uint256 ID of the token to be removed from the tokens list
1447      */
1448     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1449         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1450         // then delete the last slot (swap and pop).
1451 
1452         uint256 lastTokenIndex = _allTokens.length - 1;
1453         uint256 tokenIndex = _allTokensIndex[tokenId];
1454 
1455         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1456         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1457         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1458         uint256 lastTokenId = _allTokens[lastTokenIndex];
1459 
1460         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1461         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1462 
1463         // This also deletes the contents at the last position of the array
1464         delete _allTokensIndex[tokenId];
1465         _allTokens.pop();
1466     }
1467 }
1468 
1469 // File: contracts/Pettametti.sol
1470 
1471      //   ]y      ,▄▒
1472 
1473         //   ▄╬╩▄▓▓╬╢╬▒⌐
1474 
1475         //   ▓#╟▓▄╣▀╫╬╚╨.,
1476 
1477         //  ▐▓∩▓¬╠╬█╓╣╟`%▄▄▀*ΣW@▓╠╘│▌⌐╙≈
1478 
1479         //  ╠^╚╝▓╝╚▀╬╩    `ⁿ╝╩╠╙ÖT╢Q╠╠╜Θ²╙╩"╔R══Qæ ,▄R⌐~ç   ,              µ▄
1480 
1481         //   "`"╜*"`           ╠ ╬Γ7▄▀╨╜╬▄▄╫╫Q╠╩@"╚╬#╬▓▓▓Ö╠╬▓╫╩╬▓▓╗╖▄▄Æ#╗▓▓▀
1482 
1483         //                     ║▐╚▒  ▀╞ µ ``╙     ^²▄╟¥⌐]╩¬    ``╙╙╨╩╩╙╙^`
1484 
1485         //                     ╟╠╬▌   ▒Ü╠           ╚╣¬╠
1486 
1487         //                     ╣║╣    ╠╙╚           ▐▌╠▓
1488 
1489         //                     ü╟╬    j╗▐⌐          j▓▄╞
1490 
1491         //                     ▓╪╔     ╣╠▌          ]╙▌Q%
1492 
1493         //                     ╬▌╟     ╘╝▓           ▓▌▒⌐▓
1494 
1495         //                   ]▒▒ε      ╬╙           ▀▒ └Q╬╕
1496 
1497         //                   ╣╬▌       ▓▌▄         ╬▒▀   ¼╬µ
1498 
1499         //                   ▓▌▌       ╫▒▌        ▓╣┘     ╟Γ¬
1500 
1501         //                   ▐╬▌▌       ╠▓▌       ▌µ`      ╫▓╫
1502 
1503         //                 ╓╬╗╬╟        ╟╣╬     ▄▐╠▐      ]▌█▄
1504 
1505         //                 ╝╫▀▄⌐       ╬▓▓╟    ▐╙▀▓√µ     ▐╫▓╩
1506 
1507 // Pettametti, art project by artist Pumpametti, 300 pettamettis for the 300 Pumpamettis, every Pumpa will get a Petta.
1508 // Pumpametti holder get lifetime free mint for my projects, of course that includes the Pettametti!
1509 // Go to MettiMint if you have one OG metti or MettiMultiMint if you have more than one OG mettis, 
1510 // simply input your token ID, put 0 at the ether amount and you are good to go! For MettiMultiMint please write your token IDs separated by commas and no spaces,
1511 // for example if you own Metti #1 and Mettti #5, input 1,5 at mettiIds (uint256[]).
1512 // There'll only be 300 Pettamettis.
1513 
1514 //SPDX-License-Identifier: MIT
1515 
1516 pragma solidity ^0.8.0;
1517 
1518 interface MettiInterface {
1519     function ownerOf(uint256 tokenId) external view returns (address owner);
1520     function balanceOf(address owner) external view returns (uint256 balance);
1521     function tokenOfOwnerByIndex(address owner, uint256 index)
1522         external
1523         view
1524         returns (uint256 tokenId);
1525 }
1526 
1527 contract Pettametti is ERC721Enumerable, Ownable, RandomlyAssigned {
1528   using Strings for uint256;
1529   
1530   string public baseExtension = ".json";
1531   uint256 public cost = 0.00 ether;
1532   uint256 public maxMettiSupply = 300;
1533   uint256 public maxPettaSupply = 300;
1534   uint256 public maxMintAmount = 20;
1535   bool public paused = false;
1536   
1537   string public baseURI = "https://ipfs.io/ipfs/QmRgXjdjTTFtzJEiXrD3atGJxQZ8nXFbtLuP8C2TX3Ykkc/";
1538   
1539     //Allow OG Pumpametti holders to mint for free
1540   
1541   address public MettiAddress = 0x09646c5c1e42ede848A57d6542382C32f2877164;
1542   MettiInterface MettiContract = MettiInterface(MettiAddress);
1543   uint public MettiOwnersSupplyMinted = 0;
1544   uint public publicSupplyMinted = 0;
1545 
1546 
1547   constructor(
1548   ) ERC721("Pettametti", "Petta")
1549   RandomlyAssigned(300, 1) {}
1550 
1551   // internal
1552   function _baseURI() internal view virtual override returns (string memory) {
1553     return baseURI;
1554   }
1555 
1556   function MettiFreeMint(uint mettiId) public payable {
1557         require(mettiId > 0 && mettiId <= 300, "Token ID invalid");
1558         require(MettiContract.ownerOf(mettiId) == msg.sender, "Not the owner of this pumpametti");
1559 
1560         _safeMint(msg.sender, mettiId);
1561     }
1562 
1563     function MettiMultiFreeMint(uint256[] memory mettiIds) public payable {
1564         for (uint256 i = 0; i < mettiIds.length; i++) {
1565             require(MettiContract.ownerOf(mettiIds[i]) == msg.sender, "Not the owner of this pumpametti");
1566             _safeMint(_msgSender(), mettiIds[i]);
1567         }
1568     }
1569 
1570   function walletOfOwner(address _owner)
1571     public
1572     view
1573     returns (uint256[] memory)
1574   {
1575     uint256 ownerTokenCount = balanceOf(_owner);
1576     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1577     for (uint256 i; i < ownerTokenCount; i++) {
1578       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1579     }
1580     return tokenIds;
1581   }
1582 
1583   function tokenURI(uint256 tokenId)
1584     public
1585     view
1586     virtual
1587     override
1588     returns (string memory)
1589   {
1590     require(
1591       _exists(tokenId),
1592       "ERC721Metadata: URI query for nonexistent token"
1593     );
1594 
1595     string memory currentBaseURI = _baseURI();
1596     return bytes(currentBaseURI).length > 0
1597         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1598         : "";
1599   }
1600 
1601   //only owner
1602 
1603   function withdraw() public payable onlyOwner {
1604     require(payable(msg.sender).send(address(this).balance));
1605   }
1606 }